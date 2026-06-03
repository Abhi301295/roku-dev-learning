# Day 3 — Real SceneGraph Components

Day 2 taught the data layer (`ContentNode`) and the reactive layer (`observeField`) that flow **through** SceneGraph. Day 3 is where you start authoring **your own components**: XML files that declare shape and `.brs` files that own behaviour, exactly like the channel's existing `MovieCard.xml` + `MovieCard.brs`, `MovieFetchTask.xml` + `MovieFetchTask.brs`, and `MainScene.xml` + `MainScene.brs`.

Each topic lives in its own numbered subfolder. Start at `01-…`.

## Folder convention

Each day groups files by **topic**. One folder per topic, prefixed with a two-digit number that fixes the learning order regardless of the topic name. SceneGraph components are XML + BrightScript **pairs** sharing the same base name.

```text
exercises/day-03/
├── 01-Components/
│   ├── 1.1-minimal-component.xml
│   ├── 1.1-minimal-component.brs
│   ├── 1.2-interface-fields.xml
│   ├── 1.2-interface-fields.brs
│   ├── ...
│   ├── 4-challenge-movie-badge.xml
│   └── 4-challenge-movie-badge.brs
├── 02-ContentNode-Binding/
│   ├── 1.1-build-movie-content.brs
│   ├── ...
│   └── 2-two-level-hierarchy.brs
└── 03-Task-Nodes/
    ├── 2.1-home-scene.xml
    ├── 2.1-home-scene.brs
    └── tasks/
        ├── 1.1-movie-task.xml
        ├── 1.1-movie-task.brs
        ├── 1.2-movie-task-three-movies.xml
        ├── 1.2-movie-task-three-movies.brs
        ├── 1.3-movie-task-from-array.xml
        └── 1.3-movie-task-from-array.brs
```

The folder number fixes the order to learn topics. The file numbers inside fix the order within a topic.

## Topics

| # | Topic | What it teaches | Detailed README |
|---|-------|-----------------|-----------------|
| 01 | **Components** | XML anatomy (`<component>`, `<interface>`, `<children>`), lifecycle (`init()`, `m.top`, `m.global`), tree navigation (`findNode`), and the three canonical communication patterns: parent → child, child → parent, cross-component via `m.global`. | [`01-Components/README.md`](./01-Components/README.md) |
| 02 | **ContentNode + UI Binding** | The `Data → ContentNode tree → UI component` pattern. Building a tree from an AA array (`buildMovieContent`), built-in vs custom fields (`addField`), traversing/printing a tree (`printContentTree`), and the two-level genre hierarchy that backs a `RowList`. Assigning `.content` is Roku's `setMovies(data)`. | [`02-ContentNode-Binding/README.md`](./02-ContentNode-Binding/README.md) |
| 03 | **Task Nodes** | Background work off the render thread (`extends Task`, `functionName`, `control = "RUN"`). `MovieTask` publishes a `ContentNode` on `content`; `HomeScene` observes and assigns `RowList.content`. Exercises 1–5 from single-movie stub through `buildContentFromTitles`. The production Netflix-style pipeline: Scene → Task → API → ContentNode → RowList. | [`03-Task-Nodes/README.md`](./03-Task-Nodes/README.md) |

## Runtime caveat

XML components (topics `01` and `03`) live entirely inside the SceneGraph runtime. The `brs` CLI cannot instantiate them (no XML parser, no scene tree, no Task thread). Those are **reference code**: read on disk, then **copy** into `components/` on the `day-3-implementation` branch to actually run.

Topic `02` (ContentNode + UI Binding) is plain BrightScript that builds and walks `ContentNode` trees with no render thread, so those `.brs` files **do** run directly under the `brs` CLI (e.g. `brs 1.1-build-movie-content.brs`).

Watch console output via the **BrightScript Simulator** console (or `telnet <roku-ip> 8085` when sideloaded to real hardware).

## Why outside `source/`?

Same reason as Day 1 and Day 2: Roku allows only one `sub Main()` in `source/`, and only one root Scene tag in `manifest`. Reference components stay here so you can study and copy them without disturbing the channel build.
