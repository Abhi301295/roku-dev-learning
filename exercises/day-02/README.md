# Day 2 — SceneGraph fundamentals

Day 2 covers the building blocks every Roku channel relies on: the **data carrier** the framework consumes (`ContentNode`) and the **reactive plumbing** that connects threads, UI widgets, and the player (`observeField`).

Each topic lives in its own numbered subfolder. Start at `01-…`, work through to the highest number.

## Folder convention

Each day groups files by **topic**. One folder per topic, prefixed with a two-digit number that fixes the learning order regardless of the topic name. Files inside use `<section>.<step>-<subtopic>.<ext>`:

```text
exercises/day-02/
├── 01-ContentNode/      ← start here
│   ├── 1.1-create-and-inspect.brs
│   ├── ...
│   └── 4-class-challenges.bs
├── 02-Observers/        ← Observers & Reactive Programming
│   ├── 1.1-pattern-fundamentals.brs
│   ├── ...
│   └── 4-observable-class.bs
└── 03-<NextTopic>/      ← added when we move on
```

The number tells you the order to learn the topics; the file numbers inside tell you the order within a topic. Adding a new topic later never disturbs the existing order.

## Topics

| # | Topic | What it teaches | Detailed README |
|---|-------|-----------------|-----------------|
| 01 | **ContentNode** | The shape `MarkupGrid.content`, `RowList.content`, and `Video.content` expect. Built-in fields vs custom fields. Tree-building, traversal, and the AA → ContentNode boundary. | [`01-ContentNode/README.md`](./01-ContentNode/README.md) |
| 02 | **Observers & Reactive Programming** | `observeField`, the `roSGNodeEvent` payload, scoped vs global lookup, `alwaysNotify`, and the three canonical channel patterns (Task→Scene, grid selection, Video state machine). | [`02-Observers/README.md`](./02-Observers/README.md) |

## Runtime quick reference

| Pattern | brs CLI? | Notes |
|---------|----------|-------|
| `createObject("roSGNode", "ContentNode")` and the tree API | ✅ runs | Used throughout `01-ContentNode` |
| BrighterScript `class` (after `bsc` transpile) | ✅ runs | Used in `4-*.bs` challenge files |
| `roSGNode.observeField` and the full reactive API | ❌ device or `brs-engine` only | The CLI's interpreter crashes; `02-Observers/2.x` and `3.x` are designed as on-device reference code |

Every file marks `Runs in: …` near the top, so you can see at a glance whether `brs <file>` will work or whether the file is reference-only.

## Why outside `source/`?

Same reason as day 1: Roku allows only **one** `sub Main()` in `source/`. Each drill is a standalone file with its own `Main` (or `init`-shaped reference component), kept here to avoid the BS1003 duplicate-Main error and to keep the channel build clean.
