# Day 4 / 02 — MarkupGrid

A **MarkupGrid** is Roku's visual `movies.map(...)` — a flat grid of item components, one per `ContentNode` child.

## What you learn

| Concept | Detail |
|---------|--------|
| `numRows` / `numColumns` | Layout grid dimensions |
| `itemSize` / `itemSpacing` | Card size and gap |
| `itemComponentName` | Which component renders each child (here: built-in `StandardGridItemComponent`) |
| `content` | Flat tree — root's **children** become cards |

## Exercise

| File pair | Goal |
|-----------|------|
| `2.1-nolan-movies-scene.{xml,brs}` | Five Christopher Nolan titles in a single-row grid |

Movies: **Interstellar**, **Inception**, **Oppenheimer**, **Dunkirk**, **Tenet**.

## Sideload checklist

1. Copy pair → `components/NolanGridScene.xml` + `.brs`
2. Set root scene to `NolanGridScene`
3. Build and sideload

## Expected result

A horizontal row of five poster cards. Console on init:

```text
[4.2] NolanGridScene init; grid children = 5
[4.2]   - Interstellar
[4.2]   - Inception
...
```

## vs RowList

| MarkupGrid | RowList |
|------------|---------|
| Flat `ContentNode` children | Two-level tree (rows → items) |
| You choose rows × columns | One horizontal strip per row node |
| Good for "all movies" page | Good for Netflix-style home screen |
