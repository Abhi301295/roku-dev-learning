# Day 4 / 01 — LabelList

A **LabelList** is the simplest content list: one text label per `ContentNode` child. Use it for sidebars, settings menus, and category pickers.

```text
Categories
├── Movies
├── TV Shows
├── Sports
└── Kids
```

## What you learn

| Concept | Detail |
|---------|--------|
| `content` | Assign a flat `ContentNode` tree; each child's `title` becomes a row label |
| `itemFocused` | Integer index of the highlighted row (fires while navigating) |
| `itemSelected` | Integer index when the user presses OK |
| Focus | Call `labelList.setFocus(true)` after binding content |

## Exercise

| File pair | Goal |
|-----------|------|
| `1.1-categories-scene.{xml,brs}` | Build four category nodes, bind to `LabelList`, observe focus + selection |

## Sideload checklist

1. Copy `1.1-categories-scene.xml` → `components/CategoriesScene.xml`
2. Copy `1.1-categories-scene.brs` → `components/CategoriesScene.brs`
3. Point `source/main.bs` at `CreateScene("CategoriesScene")`
4. `npm run build` → load `out/roku-tv-learning.zip`

## Expected console

```text
[4.1] CategoriesScene init; 4 categories bound
[4.1] focus -> 0   (Movies)
[4.1] focus -> 1   (TV Shows)
[4.1] selected -> 1   (TV Shows)
```

Navigate with arrow keys; press OK to select.

## React mental model

```jsx
categories.map(name => <MenuItem label={name} />)
```

```brightscript
m.labelList.content = buildCategoryContent(categories)
```
