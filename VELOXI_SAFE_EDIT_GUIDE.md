# VELOXI_SAFE_EDIT_GUIDE

## Objectif
Guider les changements UI/structure sans casser les parcours metier stables de Veloxi.

## 1) Ce que tu peux modifier sans danger relatif
- Couleurs globales: `lib/main/utils/Colors.dart`
- Theme shell: `lib/main/store/AppStore.dart` (parties `lightTheme`, `darkTheme`, `updateTheme`)
- Typographies globales: `lib/extensions/text_styles.dart`
- Scaffold/app bar/buttons communs: `lib/main/components/CommonScaffoldComponent.dart`, `lib/main/utils/Widgets.dart`
- Assets visuels et mappings: `assets/*`, `lib/main/utils/Images.dart`
- Ecrans mostly contenu statique: `AboutUsScreen`, `PageDetailScreen`, `ThemeScreen`.

## 2) Ce que tu dois modifier avec prudence
- Dashboards: `lib/user/screens/DashboardScreen.dart`, `lib/delivery/fragment/DHomeFragment.dart`, `lib/delivery/screens/DeliveryDashBoard.dart`
- Notification flow: `lib/main/utils/Common.dart`, `lib/main/services/NotificationService.dart`
- City/location selectors: `lib/main/screens/UserCitySelectScreen.dart`, `lib/user/screens/GoogleMapScreen.dart`
- Verification ecrans: `VerificationListScreen`, `EmailVerificationScreen`, `VerificationScreen`.

## 3) Ce que tu dois eviter sans test complet
- `lib/user/screens/CreateOrderScreen.dart`
- `lib/user/screens/PaymentScreen.dart`
- `lib/user/screens/OrderDetailScreen.dart`
- `lib/delivery/screens/ReceivedScreenOrderScreen.dart`
- `lib/main/network/NetworkUtils.dart`
- `lib/main/network/RestApis.dart`
- `lib/main/services/AuthServices.dart`
- `lib/main/screens/SplashScreen.dart`
- `lib/main/utils/Constants.dart` (sauf changements maitrises)

## 4) Regressions typiques a anticiper
- Redirection wrong au lancement (login/verification/city/dashboard).
- Statut commande casse (transition non autorisee).
- Paiement enregistre sans `order_id` correct ou statut incoherent.
- Notification ouvre mauvais ecran/id.
- Delivery geoloc plus mise a jour.
- OTP verification bloquee.
- Wallet/cash logic inversee.

## 5) Checklist avant commit
- [ ] Build debug Android lance.
- [ ] Build iOS compile (au minimum).
- [ ] Login email OK.
- [ ] Logout OK.
- [ ] Changement ville OK.
- [ ] Theme light/dark toujours stable.
- [ ] Aucun endpoint critique modifie involontairement.
- [ ] Si UI refactor: golden/screenshot manuelle des ecrans principaux.

## 6) Checklist de test apres modif design
### Client
- [ ] `SplashScreen` route correctement.
- [ ] `DashboardScreen` charge commandes.
- [ ] `CreateOrderScreen` ouvre et calcule total.
- [ ] Creation draft fonctionne.
- [ ] Creation commande + paiement (au moins un mode) fonctionne.
- [ ] `OrderDetailScreen` affiche et actions support/review encore OK.

### Delivery
- [ ] `DHomeFragment` charge compteurs.
- [ ] `DeliveryDashBoard` liste statuts.
- [ ] Accept -> Pickup -> Departed -> Delivered toujours faisable.
- [ ] `ReceivedScreenOrderScreen` capture signatures/preuves.

### Notifications/externes
- [ ] Notification list charge.
- [ ] Click notification ouvre bon order detail.
- [ ] Crisp chat ouvre si active.

## 7) Checklist avant release
- [ ] VersionCode/VersionName verifies (`android/app/build.gradle`).
- [ ] Signing release valide.
- [ ] Keys/maps/onesignal/firebase non cassees.
- [ ] Smoke test sur device reel Android + iOS.
- [ ] Paiement cash + wallet + 1 online teste.
- [ ] Flux verification user complet teste.
- [ ] Aucune erreur critique Crashlytics sur session QA.

## 8) Strategie recommandee de refonte UI progressive
1. Tokeniser style global (colors, text styles, spacing).
2. Harmoniser composants partages (buttons, app bar, cards, forms).
3. Refactor ecrans en sous-widgets sans toucher logique.
4. Appliquer nouveau design ecran par ecran.
5. Tester flux metier apres chaque lot.

## 9) Regle d'or
Si un changement touche un fichier de niveau critique 1 ou 2, valider au moins un scenario end-to-end complet (client + delivery) avant merge.

