# Day 4 — Lists, Grids, Content Rendering & Focus Navigation

Day 4 has two halves. The morning covers **how Roku displays collections** (`ContentNode → list component`). The afternoon covers **how the remote drives the UI** (focus, keys, navigation stack, dialogs) — the area React developers struggle with most.

```text
Part A — Content rendering          Part B — Focus & navigation
─────────────────────────          ─────────────────────────────
API → ContentNode                  setFocus / hasFocus
  → LabelList / MarkupGrid         onKeyEvent
  → RowList                        navigation stack (manual router)
                                   reusable dialogs
```

There is no browser. No mouse. No touch. Only **UP / DOWN / LEFT / RIGHT / OK / BACK**.

## Folder convention

```text
exercises/day-4/
├── 01-LabelList/              Part A — sidebar categories
├── 02-MarkupGrid/             Part A — flat movie grid
├── 03-RowList/                Part A — Netflix-style rows
├── 04-Focus-And-Selection/    Part A — itemFocused / itemSelected
├── 05-ContentNode-Drills/     Part A — tree builders (brs CLI)
├── 06-Focus-System/           Part B — setFocus / hasFocus
├── 07-Menu-Navigation/        Part B — menu + onKeyEvent + BACK
├── 08-Navigation-Stack/       Part B — Home → Details → Player
└── 09-Dialogs/                Part B — reusable AppDialog
```

SceneGraph exercises are `.xml` + `.brs` pairs. Topic `05` runs under the `brs` CLI.

## Part A — Lists & grids

| # | Topic | What it teaches | README |
|---|-------|-----------------|--------|
| 01 | **LabelList** | Flat `content`, UP/DOWN navigation, `itemFocused` / `itemSelected` | [`01-LabelList/README.md`](./01-LabelList/README.md) |
| 02 | **MarkupGrid** | Visual `movies.map(...)` — rows, columns, content binding | [`02-MarkupGrid/README.md`](./02-MarkupGrid/README.md) |
| 03 | **RowList** | Two-level `ContentNode` tree, Netflix-style home screen | [`03-RowList/README.md`](./03-RowList/README.md) |
| 04 | **Focus & Selection** | Observe `itemFocused` / `itemSelected` on a grid | [`04-Focus-And-Selection/README.md`](./04-Focus-And-Selection/README.md) |
| 05 | **ContentNode Drills** | Build trees without SceneGraph — validate before binding | [`05-ContentNode-Drills/README.md`](./05-ContentNode-Drills/README.md) |

## Part B — Focus & navigation

| # | Topic | What it teaches | README |
|---|-------|-----------------|--------|
| 06 | **Focus System** | `setFocus(true)`, `hasFocus()`, moving focus between siblings | [`06-Focus-System/README.md`](./06-Focus-System/README.md) |
| 07 | **Menu Navigation** | Home / Settings / Profile menu; OK prints `Selected Settings`; BACK pops stack | [`07-Menu-Navigation/README.md`](./07-Menu-Navigation/README.md) |
| 08 | **Navigation Stack** | Home → Movie Details → Player; manual `push` / `pop` | [`08-Navigation-Stack/README.md`](./08-Navigation-Stack/README.md) |
| 09 | **Dialogs** | Reusable `AppDialog` — Network Error + Retry | [`09-Dialogs/README.md`](./09-Dialogs/README.md) |

## Exercises at a glance

| Exercise | Build | Key idea |
|----------|-------|----------|
| A1 | Categories → Movies, TV Shows, Sports, Kids | `LabelList` + `.content` |
| A2 | Nolan movies in a grid | `MarkupGrid` |
| A3 | Home → Trending + Sci-Fi rows | `RowList` two-level tree |
| A4 | Print `Focused:` / `Selected:` on grid scroll + OK | `observeField` on list fields |
| B1 | Home / Settings / Profile — UP/DOWN | List handles vertical focus |
| B2 | OK on Settings → `Selected Settings` | `itemSelected` |
| B3 | BACK → return to previous screen | `onKeyEvent` + navigation stack |
| B4 | Home → Details → Player | Three-level stack |
| B5 | Network Error dialog with Retry | Reusable dialog component |

## Runtime caveat

XML scenes (topics `01`–`04`, `06`–`09`) need the SceneGraph runtime. Copy pairs into `components/` on a `day-4-implementation` branch, set the scene as root in `manifest`, then `npm run build` and load in **brs-engine** or sideload.

Topic `05` and the ContentNode drills run directly:

```bash
cd exercises/day-4/05-ContentNode-Drills
brs 1.1-build-label-list-content.brs
brs 1.2-build-markup-grid-content.brs
brs 1.3-build-rowlist-content.brs
```

Topic `09` requires copying **both** `AppDialog` and `DialogDemoScene` into `components/`.

Watch console output via the simulator log or `telnet <roku-ip> 8085`.

## Suggested reading

| Path | Content |
|------|---------|
| [`DAY-4-CONCEPTS.md`](./DAY-4-CONCEPTS.md) | Full conceptual guide (Parts A + B) |
| `exercises/day-03/01-Components/` | Component patterns used by `AppDialog` |
| `exercises/day-02/02-Observers/3.2-grid-selection.brs` | Production focus/select pattern |
| `components/MainScene.*` | Production grid + player + `onKeyEvent` BACK |
