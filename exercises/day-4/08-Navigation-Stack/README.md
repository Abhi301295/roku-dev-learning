# Day 4 / 08 — Navigation Stack

React has `router.push("/details")`. Roku has **no router**. You manage screen transitions manually:

```text
Scene A  →  Scene B  →  Scene C
   ↑            ↑           |
   |____________|___________|   (BACK pops one level)
```

In practice, most channels use **one Scene** with multiple screen `Group`s, toggling `visible` and maintaining a stack array.

## What you learn

| Pattern | Detail |
|---------|--------|
| `m.navStack` | BrightScript array of screen names; top = current |
| `pushScreen(name)` | Append to stack, show that Group |
| `popScreen()` | Remove top, show previous Group, restore focus |
| `onKeyEvent("back")` | Pop the stack; return `true` to swallow the key |
| Focus restore | After pop, `setFocus(true)` on the right list/grid |

## Exercise

| File pair | Goal |
|-----------|------|
| `4.1-movie-flow-scene.{xml,brs}` | **Home → Movie Details → Player**; BACK unwinds one level at a time |

## Expected console

Select Interstellar, press Play, press BACK twice:

```text
[4.8] MovieFlowScene init
[4.8] stack = home
[4.8] Selected Interstellar
[4.8] push -> details   stack = home → details
[4.8] Selected Play
[4.8] push -> player   stack = home → details → player
[4.8] BACK -> pop to details
[4.8] BACK -> pop to home
```

## Production reference

`components/MainScene.brs` uses the same idea: `hideBrowseUi()` / `showBrowseUi()` + `m.playerLayer.visible` + `onKeyEvent` for BACK during playback.

## Sideload checklist

1. Copy pair → `components/MovieFlowScene.xml` + `.brs`
2. Set root scene to `MovieFlowScene`
3. Build and sideload
