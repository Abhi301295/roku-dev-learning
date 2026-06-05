# Day 4 — Conceptual Learning Guide

**Roku TV Learning · Lists, Grids, Content Rendering & Focus Navigation**

Day 3 taught you to **author components** and **build `ContentNode` trees**. Day 4 has two halves:

- **Part A** — connect those trees to `LabelList`, `MarkupGrid`, and `RowList`.
- **Part B** — focus, remote input, navigation stacks, and dialogs — where React developers struggle most.

There is no browser. No mouse. No touch. Only **UP / DOWN / LEFT / RIGHT / OK / BACK**.

---

## How Day 4 fits the bigger picture

| Day | Focus |
|-----|--------|
| Day 1 | BrightScript language, AAs, channel entry (`Main`) |
| Day 2 | `ContentNode` trees, `observeField`, Task→Scene, grids, Video state |
| Day 3 | Custom components, data→UI binding, Task workers |
| **Day 4** | **LabelList, MarkupGrid, RowList**, focus system, `onKeyEvent`, navigation stack, dialogs |

The pipeline behind almost every Roku app:

```text
API / data
  ↓  parse to AA array
ContentNode tree
  ↓  assign .content
LabelList / MarkupGrid / RowList
  ↓  itemSelected
Video details
```

---

## The one mental model for all three components

Every content list works the same way:

1. Build a `ContentNode` tree (the data).
2. Assign it to `list.content` (the render trigger — Roku's `setState`).
3. Observe `itemFocused` / `itemSelected` (navigation state).
4. Call `list.setFocus(true)` so the remote drives it.

The components differ only in **what tree shape they expect** and **how they render each item**.

| Component | Tree shape | Item render | Use for |
|-----------|-----------|-------------|---------|
| `LabelList` | Flat (root → items) | Built-in text row (`title`) | Sidebars, menus, settings |
| `MarkupGrid` | Flat (root → items) | A component per item (`itemComponentName`) | "All movies" grids |
| `RowList` | **Two-level** (root → rows → items) | A component per card | Netflix-style home screens |

---

## Topic 01 — LabelList

The simplest list: one text row per child, reading `title`.

```brightscript
root = createObject("roSGNode", "ContentNode")
for each name in ["Movies", "TV Shows", "Sports", "Kids"]
    item = createObject("roSGNode", "ContentNode")
    item.title = name
    root.appendChild(item)
end for
m.categoryList.content = root
```

Layout fields worth knowing:

| Field | Meaning |
|-------|---------|
| `itemSize` | `[width, height]` of one row |
| `numRows` | Visible rows before scrolling |
| `color` / `focusedColor` | Unfocused vs focused text color |

LabelList is where you first meet `itemFocused` and `itemSelected` — the same two fields every other list publishes.

---

## Topic 02 — MarkupGrid

Roku's visual `movies.map(...)`. Same flat tree as LabelList, but each child is rendered by a **component** instead of a text label.

| Field | Meaning |
|-------|---------|
| `numRows` / `numColumns` | Grid dimensions |
| `itemSize` | `[width, height]` of one card |
| `itemSpacing` | `[horizontal, vertical]` gap |
| `itemComponentName` | Component rendering each child |

You can use the built-in `StandardGridItemComponent` (reads `title`, `hdGridPosterUrl`) or your own component (like the channel's `MovieCard`). The tree shape is identical either way:

```text
root
├── card (title + poster)
├── card
└── card
```

`MarkupGrid` vs `RowList`: a grid is **flat** and you choose rows × columns; a RowList is a **strip of rows**, each scrolling independently.

---

## Topic 03 — RowList

The most important catalog component. Its `content` is a **two-level** tree:

```text
Home                  ← rowList.content (root)
├── Trending          ← a ROW (title = header)
│   ├── Interstellar  ← a CARD
│   └── Inception
└── Sci-Fi
    ├── Arrival
    └── Dune
```

- **Level-1 children** → rows; their `title` is the section header.
- **Level-2 children** → cards inside each row.

Build it with a nested loop — outer for rows, inner for cards:

```brightscript
for each section in sections
    rowNode = createObject("roSGNode", "ContentNode")
    rowNode.title = section.name
    for each movie in section.movies
        rowNode.appendChild(buildCardNode(movie))
    end for
    root.appendChild(rowNode)
end for
```

Focus movement is automatic once bound:

| Key | Action |
|-----|--------|
| Up / Down | Switch rows |
| Left / Right | Scroll within the focused row |

Layout fields specific to RowList: `rowItemSize` (card size per row), `rowItemSpacing`, `rowHeights`, `showRowLabel`, `rowLabelOffset`.

---

## Topic 04 — Focus & Selection

Every focusable list publishes two observable integer fields. You **observe** them — never poll the remote or intercept keys for navigation.

| Field | Fires when | Value |
|-------|-----------|-------|
| `itemFocused` | User scrolls / highlights | Index of highlighted item |
| `itemSelected` | User presses OK | Index of selected item |

```brightscript
m.grid.observeField("itemFocused",  "onFocused")
m.grid.observeField("itemSelected", "onSelected")

sub onFocused(event as object)
    idx = event.getData()
    print "Focused: " ; m.titles[idx]
end sub

sub onSelected(event as object)
    idx = event.getData()
    print "Selected: " ; m.titles[idx]
end sub
```

**Rules of thumb:**

1. **Subscribe before `setFocus`** so the first focus event is caught.
2. **Keep `itemFocused` cheap** — it fires every scroll tick. No network, no rebuilds.
3. **Do heavy work in `itemSelected`** — load details, start playback.
4. **`itemSelected` is sticky** — pressing OK on the same index twice won't re-fire unless `alwaysNotify="true"`.
5. **Two-array discipline** — keep a parallel BrightScript array so `idx → data` is a cheap lookup.

---

## React mental model (Day 4)

```jsx
// LabelList
categories.map(c => <MenuItem label={c} />)

// MarkupGrid
movies.map(m => <Card title={m.title} poster={m.poster} />)

// RowList
sections.map(s => (
  <Row label={s.name}>
    {s.movies.map(m => <Card title={m} />)}
  </Row>
))

// Focus & selection
<List onFocus={e => ...} onActivate={e => ...} />
```

```brightscript
m.list.content = buildTree(data)   ' the render trigger
m.list.observeField("itemFocused", "onFocused")
m.list.observeField("itemSelected", "onSelected")
m.list.setFocus(true)
```

Assigning `.content` **is** Roku's `setMovies(data)`.

---

# Part B — Focus Management & Navigation

---

## Topic 06 — Focus System

Only **one** node in the scene tree holds focus at any time. The remote drives it; you decide which node gets it.

| API | Meaning |
|-----|---------|
| `node.setFocus(true)` | Give this node the remote |
| `node.hasFocus()` | Returns `true` if this node currently holds focus |

Lists handle **UP/DOWN** (and **LEFT/RIGHT** within a row) once they have focus. Moving focus **between siblings** (e.g. two lists side by side) is your job — usually via `onKeyEvent`.

```brightscript
m.listA.setFocus(true)
print m.listA.hasFocus()   ' true
print m.listB.hasFocus()   ' false
```

---

## Topic 07 — onKeyEvent

The most important Roku UI method for keys lists don't handle themselves (especially **BACK**):

```brightscript
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    if key = "back" and m.navStack.count() > 1 then
        popScreen()
        return true    ' swallow the key
    end if

    return false       ' let SceneGraph handle it
end function
```

| Return | Meaning |
|--------|---------|
| `true` | You handled the key; propagation stops |
| `false` | Default behaviour runs (BACK at root **closes the channel**) |

Always check `press` — keys fire on down **and** up.

### Menu exercises (1–3)

| Exercise | Mechanism |
|----------|-----------|
| UP/DOWN through Home / Settings / Profile | `LabelList` internal focus |
| OK → `Selected Settings` | `itemSelected` observer |
| BACK → previous screen | `onKeyEvent` + `popScreen()` |

---

## Topic 08 — Navigation Stack

React:

```js
router.push("/details")
router.back()
```

Roku — **no router**. You manage screens manually:

```text
Scene (one root)
├── homeScreen      Group visible=true/false
├── detailsScreen   Group visible=true/false
└── playerScreen    Group visible=true/false

m.navStack = ["home"]
pushScreen("details")   ' stack = ["home", "details"]
popScreen()             ' stack = ["home"]
```

```brightscript
sub pushScreen(name as string)
    m.navStack.push(name)
    showScreen(name)
end sub

sub popScreen()
    if m.navStack.count() <= 1 then return
    m.navStack.pop()
    showScreen(m.navStack[m.navStack.count() - 1])
    restoreFocus()
end sub
```

**Exercise 4 flow:** Home → Movie Details → Player. BACK unwinds one level at a time. Same pattern as `components/MainScene.brs` (`hideBrowseUi` / `playerLayer` / `onKeyEvent`).

---

## Topic 09 — Dialogs

No `window.alert()`. Build a **reusable modal component**:

| Type | Example |
|------|---------|
| Error | Network Error — Retry? |
| Confirmation | Delete this item? — Yes / No |
| Loading | Please wait… (no buttons; spinner elsewhere) |

```xml
<interface>
    <field id="title" type="string" />
    <field id="message" type="string" />
    <field id="visible" type="boolean" />
    <field id="buttonSelected" type="integer" alwaysNotify="true" />
</interface>
```

Parent shows the dialog:

```brightscript
m.errorDialog.title = "Network Error"
m.errorDialog.message = "Unable to reach the server. Retry?"
m.errorDialog.visible = true
m.errorDialog.observeField("buttonSelected", "onDialogButton")
```

When `visible` flips to `true`, the dialog grabs focus on its button list so the remote works immediately.

---

## React mental model (Part B)

| React | Roku |
|-------|------|
| `router.push("/settings")` | `pushScreen("settings")` |
| `router.back()` | `popScreen()` on BACK key |
| `onKeyDown` on document | `onKeyEvent` on Scene |
| `<Modal open={...} onRetry={...} />` | `AppDialog.visible = true` + observe `buttonSelected` |
| Browser focus / tab order | `setFocus(true)` on exactly one node |

---

## Runtime note

XML scenes (topics `01`–`04`, `06`–`09`) need the SceneGraph runtime — copy each pair into `components/` and sideload, or load the channel zip in brs-engine. Topic `05` (`ContentNode-Drills`) runs under the `brs` CLI. Topic `09` needs both `AppDialog` and the demo Scene copied.

---

## Day 4 — Key takeaways

**Part A — Content rendering**

1. **One pattern, three components**: build tree → assign `.content` → observe focus/selection → `setFocus`.
2. **LabelList & MarkupGrid take flat trees**; **RowList takes a two-level tree** (rows → cards).
3. **`itemFocused` / `itemSelected`** are observable on every focusable list — observe, don't poll.
4. **Validate the tree in the console first** (`05-ContentNode-Drills`) before binding to the UI.

**Part B — Focus & navigation**

5. **`setFocus(true)` / `hasFocus()`** — one node owns the remote at a time.
6. **`onKeyEvent`** — return `true` to swallow a key; always check `press`.
7. **Navigation stack** — manual `push` / `pop`; no built-in router.
8. **Dialogs** — reusable component with `visible` + `buttonSelected` (child → parent).
9. **Focus, navigation, and input** are used constantly in every production channel.

---

## Suggested further reading (in repo)

| Path | Content |
|------|---------|
| `exercises/day-4/01-LabelList/README.md` | LabelList exercise |
| `exercises/day-4/02-MarkupGrid/README.md` | MarkupGrid exercise |
| `exercises/day-4/03-RowList/README.md` | RowList exercise |
| `exercises/day-4/04-Focus-And-Selection/README.md` | Focus / selection observers |
| `exercises/day-4/05-ContentNode-Drills/README.md` | CLI tree builders |
| `exercises/day-4/06-Focus-System/README.md` | `setFocus` / `hasFocus` |
| `exercises/day-4/07-Menu-Navigation/README.md` | Menu + `onKeyEvent` |
| `exercises/day-4/08-Navigation-Stack/README.md` | Home → Details → Player |
| `exercises/day-4/09-Dialogs/README.md` | Reusable `AppDialog` |
| `exercises/day-03/01-Components/` | Component patterns for dialogs |
| `exercises/day-02/02-Observers/3.2-grid-selection.brs` | Production focus/select pattern |
| `components/MainScene.*` | Production grid + player + `onKeyEvent` BACK |

---

*Document version: Day 4 learning track · aligns with `exercises/day-4/` and a future `day-4-implementation` branch.*
