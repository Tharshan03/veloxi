# PROJECT_MEMORY_VELOXI

## Resume executif
- Projet: **Veloxi** (nom app), package Flutter indique `mighty_delivery` (`pubspec.yaml`), code heritage d'un template delivery.
- Type: application mobile Flutter multi-role orientee livraison locale (client + delivery man), avec modules commandes, suivi, verification, paiements, wallet, chat support, SOS, bid.
- Plateformes: Android + iOS (dossiers `android/`, `ios/`).
- Backend principal: API REST Laravel exposee via `https://hub.veloxi.fr/api/` (`lib/bidding/utils/app_server_config.dart`, `lib/main/utils/Constants.dart`).
- Services externes critiques: Firebase (Core/Auth/Firestore/Storage/Crashlytics), OneSignal, Google Maps, Crisp Chat, multiples PSP (Stripe, Razorpay, Flutterwave, Paystack, Paytm, Paytabs, MyFatoorah, PayTR).
- Etat global: MobX centralise via `appStore` global (`lib/main/store/AppStore.dart`) + `SharedPreferences` + payloads ecran.
- Navigation: majoritairement imperative via extensions `.launch(...)` (nb_utils style), pas de route table centrale.

## A. Vue d'ensemble du projet
### Nom du projet
- Nom business/UI: `Veloxi` (`lib/main/utils/Constants.dart`, `android/app/src/main/AndroidManifest.xml`, `ios/Runner/Info.plist`).
- Nom package Flutter: `mighty_delivery` (`pubspec.yaml`).

### Stack technique exacte
- UI: Flutter Material + widgets custom (`lib/main/components`, `lib/extensions`).
- Langage: Dart SDK `>=3.10.0 <4.0.0`.
- State management: `mobx`, `flutter_mobx`.
- HTTP: `http` package + wrapper maison (`lib/main/network/NetworkUtils.dart`).
- Persistence locale: `shared_preferences`.
- Geoloc/maps: `geolocator`, `google_maps_flutter`, `google_maps_place_picker_mb`, `geocode`, `geocoding`.
- Notifications: OneSignal SDK Flutter + extension iOS OneSignal.
- Firebase: `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `firebase_messaging`, `firebase_crashlytics`, `firebase_analytics`.
- Paiements: Stripe, Razorpay, Flutterwave, Paystack, Paytm, Paytabs, MyFatoorah, Braintree drop-in natif Android, PayTR.
- Chat support: `crisp_chat`.

### Structure generale du repo (utile)
- `lib/`: coeur app Flutter (main, user, delivery, bidding, extensions).
- `android/`: build Gradle, manifest, integration Google Services, signing release.
- `ios/`: Runner, Podfile, OneSignalNotificationServiceExtension, GoogleService-Info.
- `assets/`: images, icons, lottie, ringtone, json de langues.

### Objectif metier deduit du code
- Gerer des commandes de livraison locale de bout en bout:
  - creation commande client,
  - affectation/acceptation par livreur,
  - suivi statut et tracking,
  - preuve de pickup/delivery,
  - paiement online/cash/wallet,
  - support/claim/rewards/referral.

### Roles/modules applicatifs
- Client: dashboard client, creation et suivi commandes (`lib/user/**`).
- Delivery man: dashboard livreur, etats commandes terrain, payout, vehicule, verification docs, SOS (`lib/delivery/**`).
- Bidding: enchere/contre-offre entre client et livreur (`lib/bidding/**`).
- Admin panel/backoffice: **a verifier** (non present dans ce repo mobile), mais backend expose des endpoints admin-oriented.

## B. Architecture technique reelle
### Style d'architecture detecte
- Architecture **hybride feature + service layer**:
  - features par dossier: `main`, `user`, `delivery`, `bidding`.
  - couche API centralisee en fonctions globales (`lib/main/network/RestApis.dart`, `lib/bidding/delivery/network/RestApis.dart`).
  - store global MobX unique (`AppStore`) et globals singleton (`appStore`, `authService`, `userService`, etc.) dans `lib/main.dart`.
- Pas de pattern strict repository/usecase propre (clean architecture partielle/absente).
- Navigation imperative par ecrans; pas de route generator structure.

### Separation UI / logique / data
- UI: ecrans dans `lib/*/screens`, fragments dans `lib/*/fragment`.
- Logique metier: souvent dans `State` d'ecrans + helpers dans `lib/main/utils/Common.dart`.
- Data/API: models dans `lib/main/models`, appels REST dans `RestApis.dart`.
- Services externes temps reel/auth: `lib/main/services/*` (Firebase/Firestore/OneSignal helpers).

### Gestion d'etat
- `AppStore` MobX contient:
  - auth/session (`isLoggedIn`, `userEmail`, `userType`),
  - theme/colors dynamiques,
  - devise/config app,
  - unread notifications,
  - toggles metier (insurance, bidding, sms, crisp).
- Etat local ecran via `setState` majoritaire.
- Persistance via SharedPreferences (cles dans `Constants.dart`).

### Chargement/transformations de donnees
- Flux type:
  1. ecran appelle fonction API globale (`getOrderList`, `getDashboardDetail`...).
  2. `buildHttpResponse` construit URL + headers Bearer.
  3. `handleResponse` decode JSON, gere erreurs HTTP.
  4. parsing vers model Dart (`fromJson`).
  5. mise a jour UI via `setState` + parfois `appStore`.

## C. Cartographie dossiers/fichiers importants
## D. Point d'entree et cycle d'initialisation
### Point d'entree
- Fichier: `lib/main.dart`
- `main()`:
  - `WidgetsFlutterBinding.ensureInitialized()`
  - `Firebase.initializeApp()`
  - hook crashs via `FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError`
  - init SharedPreferences
  - hydrate `appStore` depuis prefs (login, profil, theme, language)
  - charge json local langues (`initJsonFile()`)
  - init OneSignal (`oneSignalSettings()`)
  - `runApp(MyApp())`

### Sequence de demarrage runtime
1. `MaterialApp` lance `SplashScreen` (`home: SplashScreen()`).
2. `SplashScreen.init()`:
   - charge language list serveur + theme color serveur,
   - charge detail utilisateur si logge,
   - verifie statut verification (email/otp/document),
   - verifie ville selectionnee,
   - redirige vers walkthrough/login/verification/dashboard.
3. `SplashScreen` demande aussi permission location (`Geolocator.requestPermission`).

### Initialisation services
- Firebase: init dans `main.dart`; configure aussi iOS natif (`ios/Runner/AppDelegate.swift`).
- OneSignal: init + listeners click/foreground dans `oneSignalSettings()` (`lib/main/utils/Common.dart`).
- Connectivity watcher: `MyAppState.init()` ecoute `Connectivity().onConnectivityChanged` pour pousser `NoInternetScreen`.

### Points sensibles dans init
- `MyAppState.setState` annule `_connectivitySubscription` (pattern dangereux: cancel dans setState, pas dispose).
- `Firebase.initializeApp()` n'utilise pas explicitement `DefaultFirebaseOptions.currentPlatform` (classe presente mais non utilisee).
- Globals appStore/services initialises top-level (couplage fort).

## E. Analyse metier fonctionnelle
### 1) Authentification / Session
- Ecrans: `LoginScreen`, `RegisterScreen`, `ForgotPasswordScreen`, `VerificationListScreen`, `EmailVerificationScreen`, `VerificationScreen`.
- Services/API:
  - REST: `logInApi`, `signUpApi`, `forgotPassword`, `updateUserStatus`, `logoutApi`.
  - Firebase Auth: email/password, Google, Apple, OTP phone.
  - Firestore user sync: `UserService`.
- Risques regression:
  - mismatch entre session API token et session Firebase uid.
  - flow verification multi-etapes bloque facilement si casses conditions `OTP_VERIFIED/EMAIL_VERIFIED/IS_VERIFIED_DELIVERY_MAN`.

### 2) Onboarding / First launch
- Ecran: `WalkThroughScreen` puis `LoginScreen`.
- Condition: `IS_FIRST_TIME` dans prefs (`SplashScreen`).
- Risque: faible (principalement visuel/flow).

### 3) Creation commande / course
- Ecran coeur: `lib/user/screens/CreateOrderScreen.dart` (2431 lignes).
- Donnees utilisees:
  - static details (`getCreateOrderDetails`),
  - adresses utilisateur, vehicules, coupons,
  - calcul total (`getTotalAmountForOrder`),
  - envoi commande (`createOrder`).
- Include: packaging symbols, insurance, bid option, draft/order created.
- Paiement post-creation: redirection `PaymentScreen` ou wallet/cash logic.
- Risque: **tres eleve** (fichier monolithique, logique metier dense).

### 4) Affectation livreur / execution commande
- Delivery dashboard: `DeliveryDashBoard.dart`
- API: `getDeliveryBoyOrderList`, `updateOrder`, `updateOrderStatusForAssignedTab`, `cancelAutoAssignOrder`, `rescheduleOrder`.
- Ecran execution preuve: `ReceivedScreenOrderScreen` (signatures + OTP + preuve photos + paiement cash).
- Risque: **eleve**, statut order strictement sequentiel.

### 5) Suivi commande
- Client detail: `OrderDetailScreen`
- Tracking map live: `OrderTrackingScreen` (poll 5 sec `getUserDetail` du livreur + polyline API).
- Risque: moyen-eleve (depend API distance/polyline + geoloc livreur mise a jour).

### 6) Notifications
- Push inbound OneSignal + routing conditionnelle (`oneSignalSettings`).
- Notification list API: `NotificationScreen` via `getNotification`.
- Outbound chat push: `NotificationService.sendPushNotifications` appelle OneSignal REST avec `mOneSignalRestKey`.
- Risque: eleve securite/config (cles en code).

### 7) Paiement
- Ecran: `PaymentScreen` (~942 lignes).
- Gateways recuperees dynamiquement (`getPaymentGatewayList`) puis dispatch par type.
- Confirmation paiement enregistre backend (`savePayment`).
- Cash collect sur pickup/delivery dans `ReceivedScreenOrderScreen`.
- Risque: **critique** (beaucoup de SDK + logique conditionnelle).

### 8) Profil / wallet / bank / payout
- Client: `AccountFragment`, `WalletScreen`, `BankDetailScreen`.
- Delivery: `DProfileFragment`, `WithDrawScreen`, `DriverPayoutScreen`.
- API: `getWalletList`, `saveWallet`, `saveWithDrawRequest`, `updateBankDetail`, `getDriverPayout`.

### 9) Adresse / maps / geoloc
- Ville/pays: `UserCitySelectScreen` + `getCountryList/getCityList`.
- Place picker: `GoogleMapScreen` (Google place picker package).
- open external map: `openMap`.
- Livraison live location: livreur push lat/lng via `updateUserStatus` depuis stream Geolocator.

### 10) Historique/statuts/reviews/claims
- `OrderHistoryScreen`, `order_history_list.dart`, `ReviewScreen`, `ClaimListScreen`, `ClaimDetailsScreen`.
- API: `getUserOrderHistoryList`, `createReview`, `getClaimList`.

### 11) Roles utilisateurs
- Const roles: `CLIENT`, `DELIVERY_MAN`, `ADMIN` (`Constants.dart`).
- UI route selon role dans `SplashScreen`, `LoginScreen`, `VerificationListScreen`.

## F. Navigation et routing
### Mode navigation
- Navigation imperative via extension `.launch(context, ...)` et helpers `finish/pop/push`.
- Peu ou pas de named routes configurees dans `MaterialApp`.

### Ecrans d'entree
- `SplashScreen` est l'unique `home`.

### Redirections automatiques critiques
- `SplashScreen` redirige selon:
  - login state,
  - profile verification,
  - city selection,
  - role client vs delivery.

### Dependances entre pages (exemples)
- `LoginScreen` -> `VerificationListScreen` ou `UserCitySelectScreen` -> dashboard role.
- `CreateOrderScreen` -> `PaymentScreen` / `DashboardScreen`.
- `DeliveryDashBoard` -> `ReceivedScreenOrderScreen` -> update status + save payment.

## G. Couche donnees / API / backend
### Noyau reseau
- `lib/main/network/NetworkUtils.dart`
  - `buildHeaderTokens()` ajoute Bearer token depuis prefs.
  - `buildBaseUrl()` compose URL via `mBaseUrl`.
  - `buildHttpResponse()` GET/POST/PUT/DELETE + timeout.
  - `handleResponse()` decode success/error + 401 dialog session expired.

### Endpoints critiques (selection)
- Auth: `new-login`, `new-register`, `new-socialLogin`, `logout`.
- User/profile: `user-detail`, `update-profile`, `update-user-status`, `user-profile-detail`.
- Orders: `order-save`, `order-list`, `order-detail`, `order-update/{id}`, `assign-order-update`.
- Meta: `get-appsetting`, `dashboard-detail`, `deliveryman-dashboard-data`, `language-table-list`.
- Payment/wallet: `paymentgateway-list`, `payment-save`, `wallet-list`, `save-wallet`, withdraw endpoints.
- Geo helpers backend: `distance-matrix-api`, `directions-polyline-api`.

### Parsing et erreurs
- Parsing model `fromJson` dans `lib/main/models/*`.
- Erreurs REST souvent rethrow string message; peu de typed exceptions.
- 401 ouvre dialog et relance login.

### Classes data critiques
- `OrderListModel`, `OrderDetailModel`, `CreateOrderDetailModel`, `PaymentGatewayListModel`, `LoginResponse`, `AppSettingModel`, `DashboardCountModel`, `DashboardDetail`.

## H. Firebase / notifications / externes
### Firebase usage detecte
- Auth: email/password, Google, Apple, phone OTP (`AuthServices`, `VerificationScreen`).
- Firestore:
  - users collection (`UserService`),
  - order messages (`OrdersMessageService`),
  - popup config runtime (`show_popup/config` lu par plusieurs ecrans),
  - bidding stream collection (`delivery_man`).
- Crashlytics: hook FlutterError.
- Messaging package declare, mais logique FCM Flutter explicite **a verifier** (pas de handler visible dans fichiers inspectes).

### OneSignal
- Init SDK, permission request, click handlers, foreground handlers.
- iOS extension presente: `ios/OneSignalNotificationServiceExtension/*`.

### Crisp Chat
- Configuration dynamique depuis `dashboard-detail` (`crispData`), accessible client et delivery dashboards.

### Google Maps
- API key en dur dans Android manifest + iOS AppDelegate + `Constants.dart`.

### Risques config
- Cles sensibles en code (`googleMapAPIKey`, OneSignal REST key).
- Changement bundle/appId peut casser Google/OneSignal/Firebase/Auth social.

## I. UI / theme / design system
### Sources design principales
- Theme global MobX: `AppStore.lightTheme`, `AppStore.darkTheme`, `updateTheme`.
- Couleurs: `lib/main/utils/Colors.dart` + `ColorUtils` dans `dynamic_theme.dart`.
- Typo: `lib/extensions/text_styles.dart` (bold/primary/secondary wrappers).
- Widgets communs:
  - `CommonScaffoldComponent`,
  - `commonAppBarWidget`, `commonButton`,
  - helpers decoration/extensions (`lib/extensions/*`).
- Assets: centralises via `lib/main/utils/Images.dart`.

### Refonte legere (faible risque)
- Ajuster palette/branding:
  - `lib/main/utils/Colors.dart`
  - `lib/main/store/AppStore.dart` (theme objects)
  - `lib/main/utils/Images.dart` + assets.
- Ajuster composants communs:
  - `lib/main/utils/Widgets.dart`
  - `lib/extensions/text_styles.dart`
  - `lib/extensions/decorations.dart`.

### Refonte profonde (risque plus haut)
- Ecrans tres couples UI+metier:
  - `CreateOrderScreen.dart`
  - `PaymentScreen.dart`
  - `OrderDetailScreen.dart`
  - `DeliveryDashBoard.dart`
  - `ReceivedScreenOrderScreen.dart`
- Prioriser extraction widgets avant refonte visuelle majeure.

## J. Packages et dependances (cles)
### State
- `mobx`, `flutter_mobx`: store global et observers.

### Reseau/data
- `http`, `connectivity_plus`, `shared_preferences`.

### Maps/location
- `geolocator`, `google_maps_flutter`, `google_maps_place_picker_mb`, `maps_launcher`, `geocoding`.

### Firebase/notification
- `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `firebase_crashlytics`, `firebase_analytics`, `firebase_messaging`, `onesignal_flutter`.

### UI/media
- `cached_network_image`, `lottie`, `flutter_vector_icons`, `animated_bottom_navigation_bar`, `google_fonts`, `syncfusion_flutter_signaturepad`, `screenshot`.

### Paiements
- `flutter_stripe`, `razorpay_flutter`, `flutterwave_standard_smart`, `pay_with_paystack`, `paytmpayments_allinonesdk`, `flutter_paytabs_bridge`, `my_fatoorah`, `flutter_braintree_payment`, `paytr` flow custom.

### Impact retrait package (high-level)
- Retrait `mobx`: casse appStore et une grande partie des ecrans.
- Retrait maps/geoloc: casse create order, tracking, routing.
- Retrait payment SDK: casse paiements correspondants.
- Retrait firebase_auth/firestore: casse login social/OTP, sync user, bidding streams.
- Retrait OneSignal: casse push runtime + player_id logic.

## K. Android natif
### Build/config
- `android/app/build.gradle`:
  - compileSdk 36, targetSdk 35, minSdk 28,
  - Java/Kotlin 17,
  - versionCode 81, versionName 8.5.0,
  - release minify+shrink actifs,
  - signing via `key.properties`.
- `android/settings.gradle`: AGP 8.9.1, Kotlin 2.1.0, Google services plugin.
- `android/build.gradle`: resolutionStrategy force play-services-location 21.0.1, repos custom paytm.

### Permissions Android
- Main manifest: internet, fine/coarse location, post notifications, storage read/write.
- Debug manifest ajoute mock/background location + foreground service.

### Integrations natives
- Google Maps API key via manifest meta-data.
- Braintree browser switch activity configuree.
- Crisp notification service (FCM intent filter).

### Points build sensibles
- Incoherence package path Kotlin (`android/app/src/main/kotlin/com/mighty/delivery/MainActivity.kt`) vs package `com.tsdigital.veloxiapp`.
- Proguard + shrink active: attention regressions reflection plugins paiement.

## L. Risques et zones critiques
### Fichiers les plus sensibles
1. `lib/user/screens/CreateOrderScreen.dart`
2. `lib/user/screens/PaymentScreen.dart`
3. `lib/user/screens/OrderDetailScreen.dart`
4. `lib/delivery/screens/DeliveryDashBoard.dart`
5. `lib/delivery/screens/ReceivedScreenOrderScreen.dart`
6. `lib/main/network/RestApis.dart`
7. `lib/main/network/NetworkUtils.dart`
8. `lib/main/store/AppStore.dart`
9. `lib/main/screens/SplashScreen.dart`
10. `lib/main/services/AuthServices.dart`

### Modules a ne pas modifier sans precautions
- Auth/session/verification,
- state transitions des commandes,
- paiement multi-gateway,
- update location live delivery,
- notifications/push routing.

### Ecrans plutot visuels (risque faible-moyen)
- `ThemeScreen`, `AboutUsScreen`, `PageDetailScreen`, composants d'habillage, cartes statiques.

### Dependances fragiles
- SDK paiements natifs,
- OneSignal + extensions,
- Social login Google/Apple,
- Maps API keys.

## M. Strategie de modification future
1. **Zones sures pour design**
   - styles globaux, couleurs, app bars, boutons communs, assets.
2. **Zones a modifier avec prudence**
   - ecrans dashboard client/livreur, liste commandes, cartes ordre.
3. **Zones a eviter sans campagne de test complete**
   - create order, payment, received order, auth flows, network utils.
4. **Strategie recommandee**
   - phase 1: tokenisation UI (colors/text styles/components)
   - phase 2: refactor ecrans critiques en sous-widgets sans changer logique
   - phase 3: redesign progressif page par page avec tests de flux metier.
5. **Methode avant chaque changement**
   - lister flux impactes,
   - identifier endpoints touches,
   - test manuel role client + role delivery,
   - verifier paiement/suivi/notification.

## N. Checklist tests minimum apres changements
- Login email + logout.
- Login social (Google/Apple) (**si credentials dispo**).
- Verification email + OTP phone.
- Selection ville.
- Creation commande draft + commande active.
- Paiement (au moins 1 online + wallet/cash selon env).
- Delivery: accept -> pickup -> departed -> delivered.
- Tracking map client.
- Reception notification + ouverture deeplink order/chat.

## O. Si je veux seulement une refonte UI sans casser le metier
Commencer exactement par:
1. `lib/main/utils/Colors.dart` (palette)
2. `lib/main/store/AppStore.dart` (ThemeData light/dark)
3. `lib/extensions/text_styles.dart` (typography scale)
4. `lib/main/utils/Widgets.dart` + `lib/main/components/CommonScaffoldComponent.dart` (shell UI commun)
5. `lib/main/utils/Images.dart` + `assets/*` (branding)

Ensuite seulement, toucher des ecrans feature par feature:
- `DashboardScreen` puis `AccountFragment` (client)
- `DHomeFragment` puis `DProfileFragment` (delivery)
- garder `CreateOrderScreen` et `PaymentScreen` pour la fin.

## Informations a verifier (non confirmees strictement)
- Mise en oeuvre effective Firebase Messaging handlers (foreground/background) cote Flutter.
- Couverture test automatisee (aucun dossier test inspecte dans cette analyse).
- Cohabitation exacte backend admin panel hors repo mobile.

