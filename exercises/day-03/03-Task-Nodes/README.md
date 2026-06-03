# Day 3 / 03 — Task Nodes

If SceneGraph is Roku's React, **Task nodes** are Roku's answer to:

```text
fetch(...)   axios(...)   useEffect(...)   React Query / SWR
```

Roku's hard rule:

> **The render thread must not perform network operations.**

All blocking work (HTTP, disk reads, heavy parsing) runs on a **Task** thread. When the work finishes, the Task writes an **interface field**; the Scene's `observeField` callback runs on the render thread and updates the UI.

## React vs Roku

```javascript
useEffect(() => {
    fetchMovies()
}, [])
```

```brightscript
m.movieTask = createObject("roSGNode", "MovieTask")
m.movieTask.observeField("content", "onMoviesLoaded")
m.movieTask.control = "RUN"
```

```text
content field changes
       ↓
observer fires (render thread)
       ↓
m.rowList.content = content
```

## Architecture (every production app)

```text
HomeScene
    ↓  observeField + control = "RUN"
MovieTask          (worker thread — loadMovies)
    ↓  blocking fetch / read / parse
ContentNode tree   (m.top.content)
    ↓  onMoviesLoaded
RowList.content    (UI renders automatically)
```

This is the same shape as Netflix / Disney+ / Prime Video catalog screens. Understanding **Scene → Task → ContentNode → RowList** matters more than memorizing every BrightScript keyword.

## Files

| Step | Files | Exercise |
|------|-------|----------|
| 1.1 | `tasks/1.1-movie-task.{xml,brs}` | **1** — `MovieTask` extends `Task`, `functionName`, one `Interstellar` child |
| 2.1 | `2.1-home-scene.{xml,brs}` | **2 & 3** — create Task, `observeField("content")`, `onMoviesLoaded` prints `getChildCount()` |
| 1.2 | `tasks/1.2-movie-task-three-movies.{xml,brs}` | **4** — three hard-coded titles |
| 1.3 | `tasks/1.3-movie-task-from-array.{xml,brs}` | **5** — `buildContentFromTitles(movies)` from a string array |

All three Task pairs declare the **same** `<component name="MovieTask">`. Advance by **replacing** the copy under `components/tasks/` — never sideload two `MovieTask` definitions at once.

## Sideload checklist

On the `day-3-implementation` branch:

```text
components/
├── HomeScene.xml          ← copy from 2.1-home-scene.xml
├── HomeScene.brs          ← copy from 2.1-home-scene.brs
└── tasks/
    ├── MovieTask.xml      ← copy from tasks/1.1 (then 1.2, then 1.3)
    └── MovieTask.brs
```

1. Point the channel manifest root Scene at `HomeScene`.
2. Build + sideload (or BrightScript Simulator).
3. Watch the console for `[3.1]` tags.

### Expected console

| Task version | `getChildCount()` | Titles |
|--------------|-------------------|--------|
| `1.1` | `1` | Interstellar |
| `1.2` / `1.3` | `3` | Interstellar, Inception, Oppenheimer |

## Task skeleton (Exercise 1)

```xml
<component name="MovieTask" extends="Task">
    <interface>
        <field id="content" type="node" />
    </interface>
    <script type="text/brightscript" uri="pkg:/components/tasks/MovieTask.brs" />
</component>
```

```brightscript
sub init()
    m.top.functionName = "loadMovies"
end sub

function loadMovies() as void
    content = createObject("roSGNode", "ContentNode")
    ' ... append children ...
    m.top.content = content
end function
```

## Scene skeleton (Exercises 2 & 3)

```brightscript
sub init()
    m.movieTask = createObject("roSGNode", "MovieTask")
    m.movieTask.observeField("content", "onMoviesLoaded")
    m.movieTask.control = "RUN"
end sub

sub onMoviesLoaded()
    content = m.movieTask.content
    print content.getChildCount()
    m.rowList.content = content
end sub
```

## Exercise 5 helper

```brightscript
function buildContentFromTitles(titles as object) as object
    root = createObject("roSGNode", "ContentNode")
    for each title in titles
        item = createObject("roSGNode", "ContentNode")
        item.title = title
        root.appendChild(item)
    end for
    return root
end function
```

In a real channel you would parse JSON into `titles` (or richer movie AAs) **on the Task thread**, then publish the tree.

## Relation to this repo's channel

The shipping channel uses the same **Task → Scene observer** pattern with a different payload shape:

| Teaching (`03-Task-Nodes`) | Production (`components/`) |
|----------------------------|----------------------------|
| `MovieTask` + `content` (`type="node"`) | `MovieFetchTask` + `response` (`type="assocarray"`) |
| Scene assigns `RowList.content` directly | `MainScene.onMoviesLoaded` builds the grid from `response.movies` |

Both are valid. This topic teaches **ContentNode on the Task** so it lines up with topic `02-ContentNode-Binding`. Production often returns an **assocarray** from the Task and builds the **ContentNode tree on the Scene thread** after parse — see `components/MovieFetchTask.brs` and `components/MainScene.brs`.

## Runtime caveat

Like topic `01-Components`, these XML files are **reference code** for the simulator/device. The `brs` CLI cannot run Tasks or Scenes. Topic `02` drills still run under `brs` for tree-building practice without a render thread.

## Prerequisites

- Topic **02** — building and assigning `ContentNode` trees to `RowList.content`
- Day **02 / Observers / 3.1** — Task → Scene `observeField` (assocarray variant)
