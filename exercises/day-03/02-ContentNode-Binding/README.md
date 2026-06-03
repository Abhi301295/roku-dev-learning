# Day 3 / 02 — ContentNode + UI Binding

Day 2 taught the reactive chain in isolation:

```text
Field
  ↓
Observer
  ↓
Label
```

This topic teaches the chain every real channel screen is built on:

```text
Data (AA array)
  ↓
ContentNode tree
  ↓
UI Component (MarkupGrid / RowList / LabelList)
```

A grid or list never renders a plain associative-array list directly. You first **translate** the data into a tree of real `roSGNode` `ContentNode` objects. That tree is what you assign to `someList.content`, and the UI paints itself from it.

## React mental model

```jsx
movies.map(movie => (
    <MovieCard title={movie.title} />
))
```

becomes

```text
Movies Array
      ↓        buildMovieContent(...)
ContentNode Tree
      ↓        m.rowList.content = root
MarkupGrid / RowList / LabelList
```

## Exercises

| Step | File | Goal |
|------|------|------|
| 1.1  | `1.1-build-movie-content.brs` | `buildMovieContent(movies)` — turn an AA array into a flat one-level ContentNode tree (`title` only). |
| 1.2  | `1.2-content-fields.brs` | Add `title` + `rating` + `year` to every node. Shows why custom fields need `addField` first. |
| 1.3  | `1.3-print-content-tree.brs` | `printContentTree(node)` — depth-first walk that prints titles indented by depth. |
| 2    | `2-two-level-hierarchy.brs` | **The important one.** Build the genre → movies hierarchy (the RowList shape) from real `ContentNode` objects. |

Exercise 4's target tree:

```text
Movies
 ├── Sci-Fi
 │    ├── Interstellar
 │    └── Inception
 │
 └── Drama
      └── Oppenheimer
```

## Built-in vs custom fields (the gotchas)

- `title` is a **built-in** ContentNode field — dot-assign it directly.
- `rating` is **also built-in**, but it is a **string** for content advisories (`"PG-13"`, `"TV-MA"`), not your IMDb number. `movieNode.rating = 8.6` is the wrong type and is ignored. Use a custom name such as `imdbRating` for numeric scores.
- `year` is **not** built-in — declare it with `addField` before assigning.
- Any other undeclared write is **silently dropped** and reads back `invalid`.

```brightscript
movieNode.title = "Interstellar"              ' built-in
movieNode.addField("imdbRating", "float", true)
movieNode.addField("year", "integer", true)
movieNode.imdbRating = 8.6                    ' custom (not built-in `rating`)
movieNode.year = 2014
```

## Why a real ContentNode, not a custom class

The SceneGraph UI (`RowList`, `MarkupGrid`, `LabelList`) only consumes a `ContentNode` tree. A custom BrightScript class would never bind to `someList.content`. That is why Exercise 4 insists on `createObject("roSGNode", "ContentNode")` for every node.

## Next topic

Topic **03-Task-Nodes** builds the same `ContentNode` tree **on a Task thread** and publishes it to `HomeScene` via `observeField("content")` — the production **Scene → Task → ContentNode → RowList** pipeline.

## Why this matters

Soon you will write:

```xml
<RowList id="rowList" />
```

and:

```brightscript
m.rowList.content = rootContent
```

The moment you assign `.content`, the UI renders the whole tree automatically. That assignment **is** Roku's equivalent of React's:

```jsx
setMovies(data)
```

triggering a re-render.

## Runtime caveat

Unlike the XML components in `01-Components`, these four files are **plain BrightScript** that build and walk `ContentNode` trees with no observers and no render thread. They run directly under the `brs` CLI:

```bash
cd exercises/day-03/02-ContentNode-Binding
brs 1.1-build-movie-content.brs
brs 1.2-content-fields.brs
brs 1.3-print-content-tree.brs
brs 2-two-level-hierarchy.brs
```

(`type(node)` prints `Node` in the CLI and `roSGNode` on a device; `subtype()` is `ContentNode` in both.)
