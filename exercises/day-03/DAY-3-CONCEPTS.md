# Day 3 — Conceptual Learning Guide

**Roku TV Learning · SceneGraph authoring**

Day 2 established the **data carrier** (`ContentNode`) and the **reactive glue** (`observeField`) that flow through SceneGraph. Day 3 is where you **author your own components**: XML declares shape, BrightScript owns behaviour, and the three topics below connect into the pipeline every production catalog app uses.

---

## How Day 3 fits the bigger picture

| Day | Focus |
|-----|--------|
| Day 1 | BrightScript language, AAs, channel entry (`Main`) |
| Day 2 | `ContentNode` trees, `observeField`, Task→Scene, grids, Video state |
| **Day 3** | **Custom components**, **data→UI binding**, **Task workers** |

End-to-end production pattern (memorize this):

```text
Scene
  ↓  createObject / findNode + observeField + control = "RUN"
Task (worker thread)
  ↓  fetch / parse / build tree
ContentNode tree
  ↓  assign .content
MarkupGrid / RowList / Video
```

---

## Topic 01 — Real SceneGraph Components

### What a component is

A SceneGraph **component** is a reusable UI (or logic) unit defined by **two files**:

| File | Role |
|------|------|
| `.xml` | Declares **shape**: name, base type (`extends`), public fields (`<interface>`), child nodes (`<children>`), link to script |
| `.brs` | Declares **behaviour**: `init()`, observers, callbacks, helpers |

The XML prolog and root tag:

```xml
<?xml version="1.0" encoding="utf-8" ?>
<component name="MyThing" extends="Group">
    <script type="text/brightscript" uri="pkg:/components/MyThing.brs" />
    ...
</component>
```

- **`name`** — Type string used in XML (`<MyThing id="x" />`) and in `createObject("roSGNode", "MyThing")`.
- **`extends`** — Base node type. Common bases:
  - `Group` — generic container (most custom UI)
  - `Scene` — root of a screen
  - `Task` — background worker (Topic 03)
  - `Label`, `Poster`, etc. — extend a built-in to add fields/behaviour

### `init()` — the component constructor

SceneGraph calls `init()` **once** per instance, on the **render thread** (except `Task`).

When `init()` runs:

- `m.top` is the component’s root node (the `Group`, `Scene`, etc.).
- Children declared in `<children>` are already attached; you can `findNode("id")`.
- Parent **has not yet** written interface fields from outside — use `observeField` to react when they arrive.

**Rule:** No blocking work in `init()` on UI components. The scene cannot draw until `init()` returns.

### Where state lives

| Symbol | Meaning |
|--------|---------|
| `m` | Per-instance associative array; survives across all subs in this `.brs` for this instance |
| `m.top` | This component’s root `roSGNode` |
| `m.global` | Shared node visible to **every** component in the scene — use for cross-sibling communication |

Cache child references once in `init()`:

```brightscript
m.titleLabel = m.top.findNode("titleLabel")
```

Analogue: React `useRef` — stable reference, no repeated DOM queries.

### `<interface>` — the public API

Fields on `<interface>` are how **parents** (or observers) read/write data on your component without knowing internals.

```xml
<interface>
    <field id="movie" type="assocarray" />
    <field id="clickCount" type="integer" alwaysNotify="true" />
</interface>
```

- **Inbound** — parent sets `child.movie = { title: "Inception", rating: 8.8 }`.
- **Outbound** — child bumps `m.top.clickCount`; parent’s observer fires.

`alwaysNotify="true"` forces the observer even when the new value equals the old one (important for counters and Task outputs).

### `<children>` — declarative subtree

XML can pre-wire visual children:

```xml
<children>
    <Label id="titleLabel" translation="[0, 0]" />
</children>
```

BrightScript reaches them with `m.top.findNode("titleLabel")`. The `id` attribute is mandatory for programmatic access.

### Three communication patterns

All three are **`observeField`** with different **who writes / who listens**:

| Pattern | Direction | Writer | Listener |
|---------|-----------|--------|----------|
| Parent → child | Down | Parent sets child’s interface field | Child observes **its own** `m.top.field` |
| Child → parent | Up | Child sets its interface field | Parent observes **child’s** field |
| Cross-component | Sideways | Any component sets `m.global.sharedField` | Others observe `m.global.sharedField` |

**Parent → child (props-like):**

```brightscript
' Child init()
m.top.observeField("movie", "onMovieChanged")

sub onMovieChanged()
    m.titleLabel.text = m.top.movie.title
end sub
```

**Child → parent (events-like):**

```brightscript
' Parent init()
child = m.top.findNode("badge")
child.observeField("clickCount", "onBadgeClicked")
```

**Cross-component (lightweight bus):**

Declare fields on `m.global` in the Scene XML or via `addField`, then multiple components observe the same field.

### Challenge synthesis: `MovieBadge`

A production-shaped component combines:

- `<interface>` for `movie`, `selected` (in), `clickCount` (out)
- `<children>` for poster, title, rating labels
- `init()` caches nodes + subscribes to own fields
- Callbacks repaint UI and bump outbound fields

### React mental model (components)

| React | Roku SceneGraph |
|-------|-----------------|
| Function component | `<component>` + `init()` |
| `props` | Parent writes interface fields |
| `useState` + `setState` | Field write + `observeField` |
| `useRef` | `m.childId = m.top.findNode(...)` |
| Context | `m.global` |

### Runtime note

Custom XML components **do not run** under the plain `brs` CLI (no scene tree). Copy `.xml` + `.brs` into `components/` and sideload or use **brs-engine** with the channel zip.

---

## Topic 02 — ContentNode + UI Binding

### The shift from Day 2

Day 2 practiced reactive plumbing in isolation:

```text
Field  →  Observer  →  Label
```

Day 3 applies it at **catalog scale**:

```text
Data (AA array)
  ↓
ContentNode tree
  ↓
UI component (MarkupGrid / RowList / LabelList)
```

### Why not pass an AA array to the grid?

`MarkupGrid.content`, `RowList.content`, and `Video.content` expect an **`roSGNode` tree** of subtype `ContentNode`, not a BrightScript associative array.

| Plain AA | ContentNode |
|----------|-------------|
| Pure data, no identity | Stable `roSGNode` identity |
| Grids ignore it | Framework reads children and fields |
| No `observeField` on items | Fields can be observed |

**Conversion boundary:** Your API/JSON becomes AAs first; then you **build** a `ContentNode` tree before assigning `.content`.

### Building a flat tree (one row / one grid)

```brightscript
function buildMovieContent(movies as object) as object
    root = createObject("roSGNode", "ContentNode")
    for each movie in movies
        item = createObject("roSGNode", "ContentNode")
        item.title = movie.title
        root.appendChild(item)
    end for
    return root
end function
```

Assign:

```brightscript
m.grid.content = root
```

The grid renders **children** of `root`, not `root` itself.

### Built-in vs custom fields

| Field | Kind | Notes |
|-------|------|-------|
| `title`, `description`, `hdPosterUrl`, `url`, … | Built-in | Set directly; documented in SceneGraph metadata docs |
| `rating` | Built-in **string** | Content advisory: `"PG-13"`, `"TV-MA"` — **not** IMDb 8.6 |
| `imdbRating`, `year`, app IDs, flags | Custom | Must `addField` before assign |

**Critical gotcha:** Writing to an undeclared field is **silently ignored**; read returns `invalid`.

```brightscript
movieNode.title = "Interstellar"
movieNode.addField("imdbRating", "float", true)
movieNode.addField("year", "integer", true)
movieNode.imdbRating = 8.6
movieNode.year = 2014
```

`movieNode.rating = 8.6` does **not** store a numeric score — wrong type on a string field.

### Tree operations (DOM analogue)

| BrightScript | Meaning |
|--------------|---------|
| `parent.appendChild(child)` | Add child |
| `parent.getChildCount()` | Number of children |
| `parent.getChild(i)` | Child by index (OOB → `invalid`) |
| `parent.getChildren(-1, 0)` | All children as array |
| `node.getParent()` | Walk up |

### Debugging: `printContentTree`

Depth-first traversal with indentation proves shape before you trust the UI:

```text
Movies
  Sci-Fi
    Interstellar
    Inception
  Drama
    Oppenheimer
```

### Two-level hierarchy (RowList shape)

Netflix-style UI = **rows of cards**:

```text
root                    ← rowList.content
├── row "Sci-Fi"        ← row.title = section header
│   ├── movie card
│   └── movie card
└── row "Drama"
    └── movie card
```

Outer loop creates row nodes; inner loop appends movie nodes to each row.

### React mental model (binding)

```jsx
movies.map(m => <MovieCard title={m.title} />)
setMovies(data)  // triggers re-render
```

```brightscript
' build tree from movies
m.rowList.content = rootContent   ' triggers grid render
```

Assigning `.content` **is** Roku’s `setMovies`.

### Why not a custom BrightScript class?

`RowList` / `MarkupGrid` only accept real `ContentNode` nodes. A `class MovieItem` in BrighterScript is useful for drills but **cannot** be assigned to `.content`.

### Practice runtime

Topic 02 `.brs` files run with `brs` CLI (no SceneGraph). Topic 01 and 03 need device/simulator.

---

## Topic 03 — Task Nodes

### The problem Tasks solve

Roku enforces:

> **The render thread must not perform network I/O or long blocking work.**

Without Tasks, HTTP, disk reads, and heavy JSON parsing **freeze the UI**.

Tasks are SceneGraph’s answer to:

- `fetch` / `axios`
- `useEffect` with async work
- React Query / SWR

### What a Task is

A component with `extends="Task"`:

- Runs `functionName` on a **worker thread** when Scene sets `control = "RUN"`.
- Publishes results via **interface fields** (e.g. `content`, `response`).
- Never touches UI nodes directly.

### Task anatomy

**XML:**

```xml
<component name="MovieTask" extends="Task">
    <script type="text/brightscript" uri="pkg:/components/tasks/MovieTask.brs" />
    <interface>
        <field id="content" type="node" />
    </interface>
</component>
```

**BrightScript:**

```brightscript
sub init()
    m.top.functionName = "loadMovies"
end sub

function loadMovies() as void
    content = createObject("roSGNode", "ContentNode")
    ' ... build tree ...
    m.top.content = content
end function
```

### Scene consumption

```brightscript
sub init()
    m.movieTask = createObject("roSGNode", "MovieTask")
    m.movieTask.observeField("content", "onMoviesLoaded")
    m.movieTask.control = "RUN"
end sub

sub onMoviesLoaded()
    content = m.movieTask.content
    m.rowList.content = content
end sub
```

Reactive chain:

```text
Task sets m.top.content
  ↓
observeField fires on render thread
  ↓
Scene assigns grid.content
  ↓
UI renders
```

### `createObject` vs XML declaration

| Approach | When |
|----------|------|
| `createObject("roSGNode", "MovieTask")` in `init()` | Start Task on demand; keeps scene XML clean |
| `<MovieTask id="movieTask" />` in Scene + `findNode` | Task exists for life of scene (e.g. `MainScene` + `MovieFetchTask`) |

Both are valid. Name in code must match `<component name="MovieTask">`.

### Exercise progression

| Step | Learning |
|------|----------|
| 1 | Minimal Task: one `ContentNode` child (`Interstellar`) |
| 2–3 | Scene wires Task; `onMoviesLoaded` prints `getChildCount()` |
| 4 | Three hard-coded movie nodes |
| 5 | `buildContentFromTitles(["Interstellar", ...])` — AA/string list → tree inside Task |

### Production vs teaching payload

| Teaching (`MovieTask`) | Production (`MovieFetchTask` in repo) |
|------------------------|----------------------------------------|
| `content` field (`type="node"`) | `response` field (`type="assocarray"`) |
| Scene assigns tree directly | Scene builds `ContentNode` from `response.movies` on render thread |

Both use the same **observe → react** pattern from Day 2. Teaching uses `ContentNode` on the Task to align with Topic 02; production often returns parsed AAs and builds the tree on the Scene thread (thread-marshalling and team preference).

### Full architecture (catalog app)

```text
HomeScene                    (render thread — UI + observers)
    ↓
MovieTask                    (worker — loadMovies)
    ↓
HTTP / pkg:/ JSON / parse
    ↓
ContentNode tree
    ↓
onMoviesLoaded → MarkupGrid.content
    ↓
MovieCard per item (itemContent from grid)
```

### Rules of thumb

1. **Subscribe before `RUN`** — `observeField` then `control = "RUN"`.
2. **Task never calls `findNode` on UI** — only publish data fields.
3. **Scene never blocks on network** — delegate to Task.
4. **Validate with console first** — `print getChildCount()` and titles before trusting the grid.

### Testing

- Branch: `day3-implementation`
- Copy `HomeScene` + `tasks/MovieTask` into `components/`
- `source/main.bs` → `CreateScene("HomeScene")`
- `npm run build` → load `out/roku-tv-learning.zip` in brs-engine or sideload
- Console: `telnet <roku-ip> 8085` or simulator log — look for `[3.1]` tags

---

## Day 3 — Key takeaways

1. **Components** = XML shape + `.brs` behaviour; communicate via interface fields and `observeField`.
2. **ContentNode binding** = convert app data to a real node tree; assign `.content` to let the framework render.
3. **Tasks** = off-thread work; publish results to fields; Scene observes and updates UI.
4. **Built-in `rating` is a string** — use custom fields for numeric scores.
5. **The pipeline** Scene → Task → ContentNode → Grid is the pattern behind most streaming catalog UIs.

---

## Suggested further reading (in repo)

| Path | Content |
|------|---------|
| `exercises/day-03/01-Components/README.md` | Component exercise index |
| `exercises/day-03/02-ContentNode-Binding/README.md` | Binding drills + `brs` commands |
| `exercises/day-03/03-Task-Nodes/README.md` | Task sideload checklist |
| `exercises/day-02/01-ContentNode/` | Deep ContentNode API |
| `exercises/day-02/02-Observers/` | `observeField` production patterns |
| `components/MovieCard.*`, `MovieFetchTask.*`, `MainScene.*` | Shipping reference implementations |

---

*Document version: Day 3 learning track · aligns with `exercises/day-03/` and `day3-implementation` branch.*
