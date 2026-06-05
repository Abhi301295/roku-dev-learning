# Day 4 / 09 — Dialogs

Roku has no `window.alert()`. Channels build **modal components** that dim the screen, show a card, and publish button presses through interface fields.

## Dialog types

| Type | Fields | Buttons |
|------|--------|---------|
| **Error** | title + message | Retry, Cancel |
| **Confirmation** | title + message | Yes, No |
| **Loading** | message only | none (spinner elsewhere) |

## What you learn

| Concept | Detail |
|---------|--------|
| Reusable component | `AppDialog` with `<interface>` for `title`, `message`, `visible` |
| Child → parent | `buttonSelected` with `alwaysNotify="true"` |
| Focus trap | Dialog calls `buttonList.setFocus(true)` when shown |
| Visibility | Toggle `visible` on both the dialog Group and its scrim |

## Exercise

| Files | Goal |
|-------|------|
| `AppDialog.{xml,brs}` | Reusable modal — title, message, Retry / Cancel |
| `5.1-dialog-demo-scene.{xml,brs}` | Show **Network Error** / **Retry?** on boot; handle button press |

## Expected console

Press Retry on the dialog:

```text
[4.9] DialogDemoScene init
[4.9] showing Network Error dialog
[4.9] dialog button -> 0 (Retry)
[4.9] retrying fetch...
```

## Sideload checklist

Copy **four** files into `components/`:

1. `AppDialog.xml` + `AppDialog.brs`
2. `5.1-dialog-demo-scene.xml` → `DialogDemoScene.xml`
3. `5.1-dialog-demo-scene.brs` → `DialogDemoScene.brs`

Set root scene to `DialogDemoScene`, build, sideload.

## React mental model

```jsx
<Modal open={showError} title="Network Error" onRetry={...} />
```

```brightscript
m.errorDialog.visible = true
m.errorDialog.observeField("buttonSelected", "onDialogButton")
```
