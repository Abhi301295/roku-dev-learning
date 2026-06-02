# Day 2 / 02 — Observers & Reactive Programming

Why your channel never "polls": `roSGNode.observeField` lets one place declare interest in a field and the platform fans out notifications when the field changes. Threads, UI widgets, Tasks, and the Video node all communicate through this single mechanism.

## Runtime caveat

`observeField` is a SceneGraph render-thread API. The `brs` CLI does **not** implement it (the CLI's interpreter crashes when you try to register a callback). Files are split accordingly:

| Section | Runtime |
|---------|---------|
| 1.x — pattern fundamentals | `brs` CLI ✓ (uses a teaching shim) |
| 2.x — real `observeField` API | Device or `brs-engine` |
| 3.x — real-world channel patterns | Device or `brs-engine` |
| 4 — class challenge | `brs` CLI ✓ (after `bsc` transpile) |

Every file has a `Runs in:` header so you never lose track.

## Section 1 — Pattern fundamentals (CLI-runnable)

| Step | File | Concepts |
|------|------|----------|
| 1.1  | `1.1-pattern-fundamentals.brs`   | Subscribe → setValue → notify; equal-value suppression; one observable, one subscriber |
| 1.2  | `1.2-multiple-subscribers.brs`   | Fan-out: one mutation drives many reactions (UI + analytics + logging) |
| 1.3  | `1.3-unsubscribe-and-leaks.brs`  | Removing one subscriber vs `clear()`; observer leaks on screen teardown |
| 1.4  | `1.4-reactive-store.brs`         | Multi-field store (many observables in one AA) — same shape as a `roSGNode`'s field bag |

Each Section 1 file inlines a small `newObservable(...)` shim so you can run it standalone with the `brs` CLI:

```bash
cd exercises/day-02/02-Observers
brs 1.1-pattern-fundamentals.brs
brs 1.4-reactive-store.brs
```

## Section 2 — Real Roku `observeField` API (device / brs-engine)

| Step | File | Concepts |
|------|------|----------|
| 2.1  | `2.1-observeField-basics.brs`    | `node.observeField(field, callbackName)`; the no-arg callback shape |
| 2.2  | `2.2-event-payload.brs`          | The `roSGNodeEvent`: `getField()`, `getData()`, `getNode()`, `getRoSGNode()` |
| 2.3  | `2.3-scoped-and-unobserve.brs`   | `observeField` vs `observeFieldScoped`; `unobserveField(field)` and leak cleanup |
| 2.4  | `2.4-alwaysNotify.brs`           | `addField(name, type, alwaysNotify)`; force-fire on equal writes (kick / command patterns) |

These files don't run in the CLI. They are designed to be **read** as reference and **copied** into a component on a real Roku. Each one documents the expected device output near the top.

## Section 3 — Real-world channel patterns (device / brs-engine)

Mirrors of code already in this repository (`components/MainScene.brs` and `components/MovieFetchTask.brs`). Read each next to the file it mirrors and the pattern lands.

| Step | File | Mirrors |
|------|------|---------|
| 3.1  | `3.1-task-to-scene.brs`          | Task → Scene over `m.task.response` (the canonical "fetch on background thread" pattern) |
| 3.2  | `3.2-grid-selection.brs`         | `MarkupGrid.itemFocused` / `MarkupGrid.itemSelected`; the index → AA pattern |
| 3.3  | `3.3-video-state-machine.brs`    | `Video.state` walks `buffering → playing → finished / error`; one observer, many UI reactions |

## Section 4 — Challenges (`brs` CLI after transpile)

Two BrighterScript files, two different reactive-class patterns:

| File | Pattern | Goal |
|------|---------|------|
| `4-observable-class.bs` | **EventBus** — one container, many keys | `class Observable` (single value, many subscribers) plus `class EventBus` (a bag of named fields). Reproduces subscribe / setValue / unsubscribe / suppress-equal-value semantics. Also demonstrates the `doesExist` gotcha (built-in AA methods masquerade as values when bracket-indexed). |
| `5-mvvm-challenges.bs` | **MVVM** — one observable per field, composed into a ViewModel | `class ObservableField` (value + listeners + subscribe / setValue / getValue) and `class MovieViewModel` composing two ObservableFields (`title`, `rating`). Mirrors the MobX `observable`, SwiftUI `@Published`, Vue `ref` mindset — and the way a real `roSGNode` exposes per-field observers. |

Build and run:

```bash
cd exercises/day-02/02-Observers
mkdir -p .build
bsc --rootDir . --files 4-observable-class.bs \
    --stagingDir .build --createPackage=false --copyToStaging=true
cd .build && brs 4-observable-class.brs

cd ..
bsc --rootDir . --files 5-mvvm-challenges.bs \
    --stagingDir .build --createPackage=false --copyToStaging=true
cd .build && brs 5-mvvm-challenges.brs
```

Expected output — `4-observable-class.bs`:

```text
[challenge 1] subscribed; setValue(5) fires once ->
  [onCounter] counter -> 5

[challenge 2] setValue(5) again is a no-op (equal)

[challenge 3] two subscribers; one setValue -> both fire
  [onCounter] counter -> 6
  [also]      counter -> 6

[challenge 4] unsubscribe alsoOnCounter; only [onCounter] fires
  [onCounter] counter -> 7

[challenge 5] EventBus: title fires title observers, count fires count observers
  [title]     Inception
  [count]     6
```

Expected output — `5-mvvm-challenges.bs`:

```text
[challenge 1+2] direct ObservableField:
Title changed to Interstellar

[challenge 3+4] MovieViewModel composes ObservableFields:
Movie title updated

[bonus] two subscribers; one setValue -> both fire
Movie title updated
Title changed to Inception 4 (4K Remaster)
```

## Quick cheat-sheet

```brightscript
' --- register an observer ---
m.task.observeField("response",     "onResponse")        ' callback shape (a): no args
m.grid.observeField("itemSelected", "onItemSelected")    ' callback shape (a)
m.player.observeField("state",      "onPlayerState")     ' callback shape (b): event arg

' --- callback with event payload ---
sub onAny(event as object)
    field  = event.getField()
    value  = event.getData()
    node   = event.getRoSGNode()
end sub

' --- custom field, force re-fire on equal writes ---
m.state.addField("command", "string", true)              ' alwaysNotify=true

' --- cleanup (call when leaving the screen) ---
m.task.unobserveField("response")
```

## Key takeaways

- **Reactive = subscribe + publish + suppress-equal**. Roku's `observeField` is the same pattern you'd reach for in JS with `EventTarget`/`EventEmitter`, but the framework owns the dispatch.
- **One callback can handle many fields** — branch inside on `event.getField()`. Saves dozens of named subs.
- **Default behaviour suppresses equal values.** Use `addField(name, type, true)` when you need "fire on every write" (Task `response`, Video `state`, custom command fields).
- **Cross-thread communication = observe a Task field.** Never share node refs or call subs across threads; only field values cross the boundary.
- **Always unobserve** before tearing a screen down if the node outlives the screen. Screen-scoped nodes are dropped by the framework, so that case is "free."
- **Don't do heavy work in `itemFocused`.** Fires per scroll-tick. Keep network / rebuild work in `itemSelected`.
- **Reading vs `event.getData()`** can differ if writes coalesced; trust `getData()` for "what the platform saw."
- **AA gotcha:** `roAssociativeArray` has built-in methods (`count`, `keys`, `lookup`, `doesExist`, …). `aa["count"]` returns the built-in function, **not** `invalid`. Use `aa.doesExist("count")` for membership checks. Bit Section 4 of this folder; will bite you in any reactive store.
