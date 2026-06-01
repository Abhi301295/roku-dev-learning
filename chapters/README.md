# Blog Chapters 1–3 — Implementation Map

This folder is just notes. Implementation lives in `source/` and `components/`.

Source blogs by Krishna Kumar Chaturvedi:

- [Series outline / Chapter 1: Getting Started](https://medium.com/@krishna.kumar.chaturvedi/roku-app-development-series-outline-dc2ff85c4cd2)
- [Chapter 2: Understanding SceneGraph](https://medium.com/@krishna.kumar.chaturvedi/part-2-getting-started-with-roku-app-development-beginner-friendly-technical-d91a5e3a6c64)
- [Chapter 3: BrightScript Fundamentals](https://medium.com/@krishna.kumar.chaturvedi/chapter-3-brightscript-fundamentals-the-heart-of-your-roku-app-9f5a370c0870)

## Chapter 1 — Getting Started / Hello World

| Blog concept | Where in repo |
|---|---|
| Channel manifest | `manifest` |
| Channel entry `Main()` + `roSGScreen` event loop | `source/main.bs` → `showScene()` |
| First `Scene` component (`MainScene`) | `components/MainScene.xml` |
| BrightScript controller mutating a Label via `m.top.findNode("helloLabel")` | `components/MainScene.brs` → `init()` |
| Folder layout (`manifest` + `source/` + `components/`) | repo root |
| Packaging (zip of contents, not parent folder) | `scripts/roku-package.sh` packages the `bsc` staging dir |

## Chapter 2 — SceneGraph

| Blog concept | Where in repo |
|---|---|
| `Scene` → `Group` → `Label` / `Poster` tree | `components/MainScene.xml`, `components/MovieCard.xml` |
| Node fields set in XML + changed dynamically | `MainScene.brs` `init()` writes `helloLabel.text` |
| Reusable custom component with `<interface>` fields | `components/MovieCard.xml` (`posterUri`, `title`, `rating`) |
| Wiring data into the component from a parent | `MainScene.brs` `populateCards()` builds `MovieCard` nodes |
| Observer pattern via `observeField` | `MovieCard.brs` observes each interface field; `MainScene.brs` observes `subtitleLabel.text` |

## Chapter 3 — BrightScript Fundamentals

| Blog concept | Where in repo |
|---|---|
| `sub` vs `function`, return types, scope | `source/utils/MovieUtils.brs`, `exercises/day-01/2.*` |
| Variables, primitive types, `Type()` | `exercises/day-01/1.1-variables.brs` |
| Arrays + `for each` + `while` + `exit for` | `exercises/day-01/1.3-arrays.brs`, `3.2-iteration-patterns.brs` |
| Associative arrays | `exercises/day-01/1.2-associative-arrays.brs`, `source/services/MovieService.brs` |
| Generic filter / map / reduce | `source/utils/MovieUtils.brs` → `*_filterArray`, `*_mapArray`, `*_reduceArray` |
| `try / catch / throw` | `components/MainScene.brs` → `runChapter3Demos()` calls `divide(10, 0)` |
| Defensive `invalid` checks | `MovieUtils_findByTitle` and its callers in `source/main.bs` |
| BrighterScript classes (extra over the blog) | `source/models/Movie.bs`, `MovieCollection.bs`, `MovieService.bs` |

## What still lives in the next chapter

The blog explicitly defers a deep Task / multithreading example to Chapter 4
("Will have a detailed tutorial for this"). We follow suit — there is no
`Task` node in this branch yet.

## Run it

```bash
npm run build       # bsc validate + transpile + zip staging dir to out/
brs source/main.brs # NOT representative — render thread has no UI; use a real device or Roku VS Code emulator
```

On a real device, sideload `out/roku-tv-learning.zip` via the developer
web server. Connect to `telnet <device-ip> 8085` to see the `print` output
from both threads.
