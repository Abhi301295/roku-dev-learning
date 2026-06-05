# Day 4 / 04 — Focus & Selection

Every focusable Roku list (`LabelList`, `MarkupGrid`, `RowList`, `TimeGrid`) publishes its navigation state through two observable integer fields. You never poll the remote or intercept key events for navigation — you just observe:

| Field | Fires when | Value |
|-------|-----------|-------|
| `itemFocused` | The user scrolls / highlights a different item | Index of the highlighted item |
| `itemSelected` | The user presses **OK** | Index of the selected item |

The platform guarantees `itemSelected` fires **after** focus has settled, so reading `m.movies[idx]` from your parallel array is safe.

## Exercise

| File pair | Goal |
|-----------|------|
| `4.1-focus-selection-scene.{xml,brs}` | Observe both fields on a MarkupGrid and print `Focused:` / `Selected:` lines with the movie title |

## Expected console

Navigate the grid, then press OK on Interstellar:

```text
[4.4] FocusSelectionScene init; 5 movies bound
[4.4] Focused: Inception
[4.4] Focused: Interstellar
[4.4] Selected: Interstellar
```

The on-screen status label mirrors the last focus + selection so you can see it without the console.

## Senior gotchas

- **`itemSelected` is sticky.** Selecting the same index twice does not re-fire unless the field is `alwaysNotify="true"`. Most channels rely on the user moving focus between selections.
- **Keep `itemFocused` cheap.** It fires on every scroll tick — no network, no large rebuilds. Do the heavy work (load details, start playback) in `itemSelected`.

## React / DOM mental model

```js
list.addEventListener("focus", e => console.log("Focused:", items[e.index]))
list.addEventListener("activate", e => console.log("Selected:", items[e.index]))
```

```brightscript
m.grid.observeField("itemFocused",  "onFocused")
m.grid.observeField("itemSelected", "onSelected")
```
