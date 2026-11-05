# Customer app UI upgrade: Cursor prompt pack

Direction: light-first pastel "Peach pop", premium and glossy, 3D-style assets, balanced motion (key moments only).

## Setup (do once)

1. Copy `design_tokens.json` to `packages/design_system/tokens/design_tokens.json`.
2. Copy `ui-design-system.mdc` to `.cursor/rules/ui-design-system.mdc`. Project rules must use the `.mdc` extension; a plain `.md` file in that folder is ignored. The rule applies automatically to Dart files under `packages/design_system` and `apps/customer_app`, and you can also attach it manually with `@ui-design-system`.
3. Make sure the monorepo has `packages/design_system`, `packages/app_core` and `apps/customer_app` (Flutter, Riverpod, go_router).
4. Use Agent mode. Start a new chat for each stage, attach `@design_tokens.json`, and commit after each stage so you can roll back.
5. Run the stages in order. If the agent drifts, tell it to re-read `@ui-design-system` and list its deviations.

## Stage 1: Tokens and theme

```
Read @design_tokens.json and follow @ui-design-system.

Task: build the token layer in packages/design_system. Do not build screens yet.
1. Write tool/gen_tokens.dart that generates Dart from design_tokens.json: colors for
   light and dark (as a ThemeExtension), radius, spacing, elevation (BoxShadow lists),
   gradients, glass settings, typography, and motion (durations, curves, springs).
   Editing the JSON and re-running the script must regenerate everything.
2. Bundle the two fonts from the tokens (Bricolage Grotesque, Plus Jakarta Sans) as
   local assets with a Noto Sans Devanagari fallback. Confirm each font's licence
   allows bundling and log it in assets/LICENSES.md.
3. Build ThemeData for light (default) and dark, plus a theme mode setting stored in
   preferences (system, light, dark).
4. Add a Widgetbook "Foundations" section: colour swatches, type scale, radius,
   elevation, a glass sample over the pastel backdrop, and the three button variants.
5. Add a test that fails if a hex colour literal appears outside generated files.
6. Add golden tests for the Foundations pages in both themes.

Before coding, ask me up to 3 clarifying questions, then give a short plan.
```

## Stage 2: Motion primitives and 3D assets

```
Read @design_tokens.json and follow @ui-design-system.

Task: build the reusable motion layer in packages/design_system, each with a Widgetbook
entry in a "Motion Lab" section.
- MotionPolicy (single place that decides reduced motion, low-end fallbacks)
- PressableScale (press token plus light haptic)
- StaggeredReveal (stagger token, max 8 items, plays once per session)
- FloatingAsset (3D WebP with float loop and a scaling shadow ellipse)
- TiltParallax (gyroscope via sensors_plus when available, drag tilt as the fallback)
- GlassSurface (blur from glass tokens, opaque fallback on low-end devices)
- PastelBackdrop (static pre-blurred image built from gradient.backdropBlobs)
- AccentGradientButton (exactly the components.button.primary spec)
- AnimatedCounter, ShimmerSkeleton
- LottieMoment and RiveMoment wrappers (hero moments only, with reduced-motion fallbacks)

Assets: create assets/3d/ with placeholder category icons from the Microsoft Fluent Emoji
3D set (MIT licence): wrench, plunger, broom, electric plug, light bulb, shower, toolbox.
Convert to WebP at 256 to 512 px, 40 KB max each. Record every file, its source URL and
the MIT notice in assets/LICENSES.md.

Rules: wrap animated regions in RepaintBoundary, pause loops when off-screen, and
justify any BackdropFilter or shader. Package choices: flutter_animate, animations,
lottie, rive (latest stable versions; check pub.dev for current APIs).

Ask me up to 3 clarifying questions first, then plan, then implement.
```

## Stage 3: Home

```
Read @design_tokens.json and follow @ui-design-system.

Task: build the customer Home screen with fake data from a Riverpod mock repository
(no backend).
- Greeting and location chip, glass search bar, category grid (support-pastel tiles
  with FloatingAsset icons), promo carousel, floating glass bottom bar.
- Motion plan (write it first): one orchestrated reveal of the tiles on first load
  only; subtle parallax on the header while scrolling; the search bar expands into
  the search screen with a container transform; press feedback on tiles and buttons.
  Nothing else animates on its own.
- Reduced motion: static layout, 120 ms fades only.

Acceptance: 60 fps in profile mode on a low-end device, both themes verified, golden
tests for the screen in both themes, no hardcoded visual values.

Write the motion plan, ask me up to 2 questions, then implement.
```

## Stage 4: Service detail and booking form

```
Read @design_tokens.json and follow @ui-design-system.

Task: build service detail and the booking form.
- The tile on Home transitions into the detail screen with a container transform.
- The booking form is rendered from a JSON schema (use the "Tap repair" example:
  issue type chips, tap count stepper, optional photos, notes) so new services need
  no app release. Chips select with the snappy spring and a light haptic.
- A sticky glass summary bar shows the price estimate with AnimatedCounter and the
  AccentGradientButton "Book now", which opens a confirmation sheet.
- Fake data only. Motion plan first.

Ask me up to 2 questions, then implement.
```

## Stage 5: Finding your pro (the signature screen)

```
Read @design_tokens.json and follow @ui-design-system.

Task: build the "Finding your pro" screen. This is the one screen that gets the most
motion; spend the boldness here.
- A soft radar ripple expanding from the customer's location over a map placeholder,
  with small pro dots drifting in as they are "found". Use Rive if a licensed file is
  available; otherwise a CustomPainter ripple.
- Status text that updates with real states: Contacting nearby pros, N pros nearby,
  Waiting for a response. States: searching, found, nobody available.
- Cancel button always visible. If nobody is available, show "Schedule instead" and
  "Try again".
- Simulate the state flow with a fake Riverpod controller.
- Reduced motion: static ripple, text and dots update without movement.

Motion plan first, then ask me up to 2 questions, then implement.
```

## Stage 6: Pro assigned and live tracking

```
Read @design_tokens.json and follow @ui-design-system.

Task: build "Pro assigned" and "Live tracking".
- Assigned: the pro card rises with the soft spring, the avatar pops, one subtle
  confetti burst (once), start-OTP shown in a clear chip, call and chat buttons.
- Tracking: a map behind a draggable glass bottom sheet with three snap points. Marker
  position is interpolated smoothly between location updates; the route line draws in
  once; ETA changes use AnimatedCounter. Put the map behind a MapProvider interface and
  use a fake map widget when no API key is configured. Feed fake location updates from
  a Riverpod stream.
- Show states: on the way, arrived, job started.

Motion plan first, then ask me up to 2 questions, then implement.
```

## Stage 7: Job in progress, payment and rating

```
Read @design_tokens.json and follow @ui-design-system.

Task: build job in progress, payment and rating.
- Job in progress: animated timeline (accepted, on the way, arrived, in progress,
  done), with the current step highlighted using the highlight colour.
- Payment: price breakdown (collapsible), payment method list (stubs), clear total.
- Success moment: a check burst on the accent gradient, one per payment, with a light
  haptic. Use a Lottie or Rive file only if a licensed one is available; otherwise
  build it in code.
- Rating: stars that fill with the bouncy spring and a haptic, quick tip chips, and a
  receipt link.

Motion plan first, then ask me up to 2 questions, then implement.
```

## Stage 8: Polish and audit (no new features)

```
Read @design_tokens.json and follow @ui-design-system.

Task: audit the customer app and produce a report, then fix what you can.
1. Performance: profile every screen in profile mode, list jank frames, expensive
   blur layers and oversized images, and fix them. Report app size change.
2. Reduced motion: verify every animation has a fallback.
3. Accessibility: semantic labels, 48 dp targets, text scaling to 1.3x, and contrast of
   the primary button label on the gradient. Fix failures.
4. Themes: walk every screen in light and dark and fix inconsistencies.
5. Licences: check assets/LICENSES.md against every asset in the repo and remove unused
   assets.
6. Tokens: confirm no hardcoded visual values remain.

Output a short report with what you found, what you fixed and what still needs my
decision.
```

## Replacing placeholders later

The Fluent Emoji set is a good starting point, but free 3D sets are recognisable. Before launch, consider commissioning a custom set of 20 to 30 icons plus 3 to 4 hero illustrations in the same pastel palette, then swap the files in `assets/3d/` without touching code.
