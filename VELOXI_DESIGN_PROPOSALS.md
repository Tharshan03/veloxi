# 🎨 Veloxi — Propositions de styles de design

> 4 directions visuelles pour faire évoluer l'identité actuelle (teal → bleu).
> Chaque maquette est décrite par : **palette, typographie, composants, ambiance, exemples d'usage**.
> Toutes restent **compatibles** avec le `ColorUtils` existant — il suffit de changer 4-5 tokens.

---

## 🟢 Style A — **Brand Aurora** *(évolution douce de l'actuel)*

> "Garder l'ADN actuel, mais plus polish, plus moderne."

### Palette
| Token | Valeur | Usage |
|---|---|---|
| `brandPrimary` | `#12C7B0` | CTA principal, accents |
| `brandSecondary` | `#0088FF` | Liens, secondary action |
| `brandGradient` | `#12C7B0 → #0088FF` | Boutons CTA, AppBar |
| `surface` | `#FFFFFF` | Cartes |
| `surfaceAlt` | `#F0FDFB` | Fond chip / badge |
| `border` | `#D1FAF4` | Bordures input/cards |
| `textPrimary` | `#0F172A` | Titres |
| `textSecondary` | `#64748B` | Descriptions |
| `darkBg` | `#0F172A` | Fond dark mode |
| `darkSurface` | `#1E293B` | Cartes dark |

### Typographie
- **Display** : Inter / Poppins — 700, 24-32sp
- **Body** : Inter — 400-600, 14-16sp
- **Caption** : 12sp, lettre-spacing +0.2

### Composants
- 🔘 **Boutons** : `radius 16`, gradient + ombre douce `elev 4`
- 🃏 **Cartes** : `radius 24`, `shadow blur 20 / opacity 4%`
- 🔖 **Chips** : pill `radius 999`, fond `surfaceAlt`
- 📍 **Inputs** : bordure `border`, focus `brandPrimary`, label flottant

### Ambiance
✨ Lumineux, sain, "fintech moderne". Très peu de friction visuelle. Aligné avec Revolut, N26, Lydia.

### Exemple — Bouton CTA
```
┌───────────────────────────────────┐
│ 🟢🔵    Place order               │ ← gradient teal→bleu
└───────────────────────────────────┘
   radius 16 · ombre teal 20%
```

---

## 🔵 Style B — **Deep Ocean** *(plus pro, plus livrer-vite)*

> "Bleu profond, dynamique, image de précision logistique."

### Palette
| Token | Valeur | Usage |
|---|---|---|
| `brandPrimary` | `#0066FF` | CTA principal |
| `brandAccent` | `#00E0B8` | Succès, badges actifs |
| `brandGradient` | `#0066FF → #00B7FF` | AppBar, FAB |
| `surface` | `#FFFFFF` | Cartes |
| `surfaceAlt` | `#F0F6FF` | Sections background |
| `border` | `#DBE5F5` | Inputs |
| `textPrimary` | `#0A1530` | Titres très contrastés |
| `darkBg` | `#0A1024` | Fond dark navy |
| `accentWarn` | `#FFB020` | Pickup, alertes |

### Typographie
- **Display** : Manrope 800
- **Body** : Manrope 500-600
- **Numéros (prix, distance)** : Manrope 700 + tabular-nums

### Composants
- 🔘 **Boutons** : `radius 12` (plus carré, plus pro), gradient bleu-cyan
- 🃏 **Cartes** : `radius 16`, bordure 1px `border` (pas d'ombre par défaut)
- 🔖 **Chips status** :
  - Pending → `#FFB020` 15% bg + texte ambré
  - Active → `#00E0B8` 15% bg + texte vert
  - Done → `#0066FF` 15% bg + texte bleu
- 📊 **Stats** : grosse typo number 28sp + label 12sp gris

### Ambiance
🚀 Pro, rapide, "cockpit livreur". Inspiration : Stripe, Uber Driver, Bolt Driver.

### Exemple — Carte de course
```
╔═══════════════════════════════════╗
║  #VLX-2384       🟡 Pickup        ║
║  ────────────────────────────     ║
║  📍 13 rue Boétie, 75008          ║
║  📍 7 av. Mozart, 75016           ║
║  💰 12,40 €    ⏱ 14 min   2.8 km  ║
║  ┌─────────────────────────────┐  ║
║  │  ▶  Take this order         │  ║ ← gradient bleu-cyan
║  └─────────────────────────────┘  ║
╚═══════════════════════════════════╝
```

---

## ⚫ Style C — **Dark Performance** *(dark-first, premium)*

> "Sombre par défaut, accents fluo. Pour les pros qui roulent la nuit."

### Palette
| Token | Valeur | Usage |
|---|---|---|
| `bgBase` | `#0B0F19` | Fond principal |
| `bgSurface` | `#151A26` | Cartes |
| `bgSurfaceHi` | `#1E2433` | Hover / élevé |
| `border` | `#262C3D` | Séparateurs subtils |
| `brandPrimary` | `#39FFB0` | CTA, accents (teal néon) |
| `brandSecondary` | `#5B9DFF` | Liens |
| `textPrimary` | `#F5F7FA` | Titres |
| `textSecondary` | `#8C95AB` | Body |
| `glow` | `#39FFB0 @ 30%` | Halo derrière CTA |

### Typographie
- **Display** : Space Grotesk 700
- **Body** : Inter 400-500
- **Mono** : JetBrains Mono (numéros tracking)

### Composants
- 🔘 **Boutons CTA** : fond `brandPrimary`, texte `bgBase` (noir sur teal néon), `radius 14`, **glow** derrière
- 🃏 **Cartes** : fond `bgSurface`, bordure 1px `border`, `radius 20`, **pas d'ombre**, hover lift +2px
- 🔖 **Chips** : `radius 8`, fond border 30%, contour 1px
- 📊 **Stats** : très grosse typo, accents fluo
- 🎯 **Map** : style Mapbox dark-monochrome + tracé teal néon

### Ambiance
🌙 Premium, gamer-driver, performant. Inspiration : Linear, Vercel, Tesla app.

### Exemple — Dashboard livreur
```
╔══════════════════════════════════════╗
║  Hey Litharsan 👋    ⚙️  🔔(3)        ║
║                                       ║
║  ╔════════════╗  ╔════════════╗      ║
║  ║  ⚡ 47      ║  ║  💰 €184   ║      ║
║  ║  Today      ║  ║  Earnings   ║      ║
║  ╚════════════╝  ╚════════════╝      ║
║                                       ║
║  ▼ Live order                         ║
║  ╔════════════════════════════════╗  ║
║  ║ ▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░ 62%       ║  ║
║  ║ → Picking up at 4 av. Foch    ║  ║
║  ║ ETA 7 min · 1.4 km            ║  ║
║  ║                                ║  ║
║  ║ [▶ Open in Maps] [💬 Chat]    ║  ║
║  ╚════════════════════════════════╝  ║
║                                       ║
║  ⬛⬛⬛⬛ GO ONLINE ⬛⬛⬛⬛           ║ ← néon teal + glow
╚══════════════════════════════════════╝
```

---

## 🌅 Style D — **Soft Material 3** *(officiel Google, très accessible)*

> "Material You natif. Maximal pour l'a11y, animations fluides."

### Palette dérivée du brand
- **Couleur source** : `#12C7B0`
- **ColorScheme** auto-généré par Material 3 (50 → 900) :
  - `primary` `#006B5C` · `onPrimary` `#FFFFFF`
  - `primaryContainer` `#A0F1DD` · `onPrimaryContainer` `#00201A`
  - `secondary` `#4A6360` · `tertiary` `#46617A`
  - `surface` `#FAFDFB` · `surfaceVariant` `#DAE5E1`
  - `error` `#BA1A1A`

### Typographie
- **Roboto** (par défaut M3) ou **Google Sans**
- Échelle M3 : `displayLarge` 57 / `headlineLarge` 32 / `titleLarge` 22 / `bodyLarge` 16

### Composants
- 🔘 **Boutons** : `FilledButton.tonal` (teal pâle), `FilledButton` (teal saturé), `radius 20` natif
- 🃏 **Cartes** : `Card.filled` ou `Card.outlined`, ripple natif
- 🔖 **Chips** : `FilterChip` / `InputChip` natifs
- 📍 **Inputs** : `OutlinedTextField` M3
- 🌗 **Theme** : auto dark/light avec `ColorScheme.fromSeed(seedColor: brand)`
- 🎬 **Motion** : courbes M3 `emphasizedEasing`

### Ambiance
🎨 Officiel, accessible, conformiste, robuste. Idéal si tu vises Play Store featured + accessibilité AAA.

### Exemple — Sheet de filtre
```
┌──────────────────────────────────────┐
│  Filter orders                    ✕  │
│  ──────────────────────────────────  │
│  Status                              │
│  ⬢ All   ⬡ Pending   ⬡ Active       │ ← FilterChip M3
│  ⬡ Done  ⬡ Cancelled                 │
│                                      │
│  Date range                          │
│  [─────●━━━━━━━━●─────]              │ ← Slider M3
│  Jan 1            Today              │
│                                      │
│  ┌──────────────┐ ┌────────────────┐ │
│  │   Reset      │ │   Apply (12)   │ │ ← FilledButton tonal + filled
│  └──────────────┘ └────────────────┘ │
└──────────────────────────────────────┘
```

---

## 🧩 Comparatif rapide

| Critère | A · Aurora | B · Ocean | C · Dark Perf | D · M3 |
|---|---|---|---|---|
| Effort migration | 🟢 Faible | 🟡 Moyen | 🔴 Lourd (dark-first) | 🟡 Moyen |
| Identité actuelle | ✅ Conservée | ⚠️ Repivotée bleu | ⚠️ Repivot dark | ✅ Conservée |
| Image marque | Moderne fintech | Pro logistique | Premium gamer | Officiel/sérieux |
| A11y | 🟢 OK | 🟢 OK | 🟡 Contrastes ⚠️ | 🟢 Excellent |
| Risque régression | 🟢 Faible | 🟡 Moyen | 🔴 Élevé | 🟡 Moyen |
| Wow effect | 🟡 | 🟢 | 🟢🟢 | 🟡 |

---

## 🎯 Ma recommandation

| Si tu veux… | Choisis |
|---|---|
| Polir l'existant sans tout refaire | **A · Brand Aurora** ✨ |
| Repositionner Veloxi en "Bolt-like pro" | **B · Deep Ocean** |
| Frapper fort, viser pros & nuit | **C · Dark Performance** |
| Maximiser a11y et conformité Play Store | **D · Soft Material 3** |

> 💡 Recommandation perso : **Style A en V1 immédiat** (1-2 jours de migration), puis envisager **C** en option "Driver Pro mode" plus tard.

---

## 🔧 Prochaines étapes possibles

1. Tu choisis **A / B / C / D** (ou un mix)
2. Je crée `lib/main/theme/` avec `AppColors`, `AppTypography`, `AppShapes`, `AppButtonStyles`
3. Je migre 1 écran vitrine (ex : `DashboardScreen`) pour validation visuelle
4. Si OK → migration globale auto-pilotée

