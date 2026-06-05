# Day 4 / 05 — ContentNode Drills (brs CLI)

The four scenes in topics `01`–`04` need the SceneGraph runtime to render. But the **data half** — the `ContentNode` tree you assign to `.content` — is plain BrightScript and runs anywhere. These three drills build the exact trees that back Exercises 1–3 and print them, so you can **validate shape before trusting the UI**.

This is the discipline every senior Roku dev follows: prove `getChildCount()` and titles in the console first, then bind to the grid.

## Files

| File | Builds the tree for | Shape |
|------|--------------------|-------|
| `1.1-build-label-list-content.brs` | Exercise 1 (LabelList) | Flat: root → 4 category nodes |
| `1.2-build-markup-grid-content.brs` | Exercise 2 (MarkupGrid) | Flat: root → 5 movie nodes |
| `1.3-build-rowlist-content.brs` | Exercise 3 (RowList) | Two-level: root → 2 rows → movie cards |

## Run

```bash
cd exercises/day-4/05-ContentNode-Drills
brs 1.1-build-label-list-content.brs
brs 1.2-build-markup-grid-content.brs
brs 1.3-build-rowlist-content.brs
```

(`type(node)` prints `Node` under the CLI and `roSGNode` on a device; `subtype()` is `ContentNode` in both.)

## Why this matters

The line that renders the UI in a real scene is a single assignment:

```brightscript
m.list.content = root
```

If the tree is wrong, the grid silently renders nothing or the wrong rows. These drills let you debug the tree with zero SceneGraph overhead — the same reason Day 3 / 02 ran the binding logic under the CLI.
