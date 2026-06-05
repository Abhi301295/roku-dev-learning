# Day 4 / 03 — RowList

**RowList** is the component behind Netflix-style home screens: multiple horizontal rows, each with its own section header.

## Target tree

```text
Home
 ├── Trending
 │    ├── Interstellar
 │    └── Inception
 │
 └── Sci-Fi
      ├── Arrival
      └── Dune
```

- **Level 1** children (`Trending`, `Sci-Fi`) → rows; their `title` is the section header.
- **Level 2** children → cards inside each row.

## What you learn

| Concept | Detail |
|---------|--------|
| Hierarchical `content` | Root → row nodes → movie nodes |
| `rowItemSize` | Size array per row (here: one size for all rows) |
| `itemComponentName` | Card component (`StandardGridItemComponent`) |
| Focus movement | Up/down switches rows; left/right scrolls within a row |

## Exercise

| File pair | Goal |
|-----------|------|
| `3.1-home-rows-scene.{xml,brs}` | Build the tree above, bind to `RowList`, print row/item counts |

## Sideload checklist

1. Copy pair → `components/HomeRowsScene.xml` + `.brs`
2. Set root scene to `HomeRowsScene`
3. Build and sideload

## Expected console

```text
[4.3] HomeRowsScene init
[4.3] rows = 2
[4.3] row 0 "Trending" -> 2 items
[4.3] row 1 "Sci-Fi" -> 2 items
```

## React mental model

```jsx
sections.map(section => (
  <Row key={section.name} label={section.name}>
    {section.movies.map(m => <MovieCard key={m.title} {...m} />)}
  </Row>
))
```

```brightscript
m.rowList.content = buildHomeRowsContent(sections)
```
