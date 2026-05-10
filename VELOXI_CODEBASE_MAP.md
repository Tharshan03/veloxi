# VELOXI_CODEBASE_MAP

## Arborescence utile
```text
lib/
  main.dart                         # entrypoint + bootstrap global
  main/
    store/AppStore.dart             # etat global MobX, theme, flags metier
    network/
      NetworkUtils.dart             # transport HTTP + headers + erreurs
      RestApis.dart                 # endpoints REST principaux
    services/
      AuthServices.dart             # Firebase auth + social + sync user
      UserServices.dart             # Firestore users
      OrdersMessageService.dart     # chat order-level Firestore
      NotificationService.dart      # push OneSignal outbound
      VersionServices.dart          # popup update version
    screens/                        # auth/common settings/support/splash
    models/                         # models API
    components/                     # scaffold/app shell/widgets partages
    utils/
      Constants.dart                # constantes globales + cles prefs + roles
      Common.dart                   # helpers metier transverses
      Colors.dart                   # palette principale
      Images.dart                   # mapping assets
  user/
    screens/
      DashboardScreen.dart          # dashboard client
      CreateOrderScreen.dart        # creation commande (tres critique)
      PaymentScreen.dart            # paiements multi-gateway (critique)
      OrderDetailScreen.dart        # detail + actions commande (critique)
      OrderTrackingScreen.dart      # tracking live map
    fragment/
      OrderFragment.dart            # liste commandes client
      AccountFragment.dart          # profil/settings client
    components/                     # cards/dialogs metier client
  delivery/
    fragment/
      DHomeFragment.dart            # home livreur + counts + bids stream
      DProfileFragment.dart         # profil/settings livreur
    screens/
      DeliveryDashBoard.dart        # execution des statuts livreur (critique)
      ReceivedScreenOrderScreen.dart# preuve pickup/delivery + otp + paiement
      OrdersMapScreen.dart          # map commandes
      VerifyDeliveryPersonScreen.dart
  bidding/
    delivery/
      network/RestApis.dart         # endpoints bids
      screens/DeliveryBidListScreen.dart
    user/screens/BidListScreen.dart # bids cote client
  extensions/                       # utilitaires UI/navigation/prefs/style
  languageConfiguration/            # i18n dynamique server + local json

android/
  app/build.gradle                  # sdk, signing, minify, deps natives
  app/src/main/AndroidManifest.xml  # permissions + maps key + services
  app/google-services.json          # firebase android config

ios/
  Runner/AppDelegate.swift          # Firebase + Google Maps key
  Runner/Info.plist                 # permissions iOS + URL schemes
  Runner/GoogleService-Info.plist   # firebase iOS config
  OneSignalNotificationServiceExtension/

assets/
  icons/images/lottie/ringtone/staticjson
```

## Role de chaque dossier important
- `lib/main/`: socle transverse (auth, API, models, store, utils).
- `lib/user/`: parcours client (commande, paiement, wallet, profile).
- `lib/delivery/`: parcours livreur (ordre terrain, verification docs, payouts).
- `lib/bidding/`: mode enchere sur commandes.
- `lib/extensions/`: primitives UI/UX et helpers de navigation.
- `lib/languageConfiguration/`: gestion langues server-driven.
- `android/` et `ios/`: configuration native/build/permissions/integrations.
- `assets/`: design content + ressources statiques runtime.

## Fichiers cles et impact modification
### Critiques niveau 1 (ne pas casser)
- `lib/main.dart`: bootstrap app; toute erreur casse demarrage complet.
- `lib/main/screens/SplashScreen.dart`: gate principal vers tous les flux.
- `lib/main/network/NetworkUtils.dart`: impact toutes les requetes.
- `lib/main/network/RestApis.dart`: impact metier global.
- `lib/main/store/AppStore.dart`: impact etat global et theme.
- `lib/main/services/AuthServices.dart`: impact login/social/OTP/session.

### Critiques niveau 2 (metier coeur)
- `lib/user/screens/CreateOrderScreen.dart`: creation commande + pricing + draft.
- `lib/user/screens/PaymentScreen.dart`: paiements multi-fournisseurs.
- `lib/user/screens/OrderDetailScreen.dart`: actions/annulation/support/review.
- `lib/delivery/screens/DeliveryDashBoard.dart`: pipeline etats livreur.
- `lib/delivery/screens/ReceivedScreenOrderScreen.dart`: preuve operationnelle et cash collect.

### Critiques niveau 3 (plateforme/services)
- `android/app/build.gradle`, `android/app/src/main/AndroidManifest.xml`
- `ios/Runner/AppDelegate.swift`, `ios/Runner/Info.plist`, `ios/Podfile`
- `lib/main/utils/Constants.dart` (cles, endpoints, roles, statuses)

## Fichiers plutot "safe UI" (avec tests smoke)
- `lib/main/utils/Colors.dart`
- `lib/extensions/text_styles.dart`
- `lib/main/utils/Widgets.dart`
- `lib/main/components/CommonScaffoldComponent.dart`
- `lib/main/utils/Images.dart` + `assets/*`

## Points de couplage fort
- Globals dans `lib/main.dart` (`appStore`, `authService`, `userService`, `navigatorKey`).
- Navigation directe ecran->ecran via `.launch`.
- Conditions metier en string constants (`ORDER_*`, `PAYMENT_*`, `CLIENT/DELIVERY_MAN`).
- SharedPreferences massivement utilise pour decisions de flux.

## Cartographie rapide des flux runtime
1. Boot: `main.dart` -> `SplashScreen`
2. Session gate: `SplashScreen` -> `WalkThroughScreen` | `LoginScreen` | `VerificationListScreen` | `DashboardScreen` | `DHomeFragment`
3. Client orders: `DashboardScreen` -> `OrderFragment` -> `OrderDetailScreen` / `CreateOrderScreen` -> `PaymentScreen`
4. Delivery execution: `DHomeFragment` -> `DeliveryDashBoard` -> `ReceivedScreenOrderScreen`
5. Support & notifications: OneSignal click -> `OrderDetailScreen` ou `ChatScreen`

## A verifier ulterieurement
- Presence/absence de tests automatisees.
- Eventuelles routes/deep links non inspectees hors fichiers lus.

