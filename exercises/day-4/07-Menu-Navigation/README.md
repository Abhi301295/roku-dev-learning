# Day 4 / 07 — Menu Navigation & onKeyEvent

This topic covers **Exercises 1–3** from the Focus Management brief, plus the introduction to `onKeyEvent`.

## What you learn

| Concept | Detail |
|---------|--------|
| UP / DOWN | `LabelList` handles this internally once it has focus |
| `itemSelected` | Fires on OK; map index → menu item |
| `onKeyEvent` | The most important Roku UI method for keys the list doesn't handle (especially **BACK**) |
| Navigation stack | Manual `push` / `pop` array — Roku's equivalent of `router.push` / `router.back` |

```brightscript
function onKeyEvent(key as String, press as Boolean) as Boolean
```

- Return **`true`** — you handled the key; SceneGraph stops propagating.
- Return **`false`** — let default behaviour run (BACK at root closes the channel).

Always check `press` — keys fire on **down** and **up**; you almost always want `if not press then return false`.

## Exercise

| File pair | Goal |
|-----------|------|
| `2.1-menu-navigation-scene.{xml,brs}` | Menu: Home / Settings / Profile; OK on Settings prints `Selected Settings`; BACK returns to menu |

## Expected console

Scroll to Settings, press OK, then BACK:

```text
[4.7] MenuNavigationScene init; 3 menu items
[4.7] focus -> 1   (Settings)
[4.7] Selected Settings
[4.7] push -> settings   stack = menu, settings
[4.7] BACK -> pop to menu
```

## Sideload checklist

1. Copy pair → `components/MenuNavigationScene.xml` + `.brs`
2. Set root scene to `MenuNavigationScene`
3. Build and sideload
