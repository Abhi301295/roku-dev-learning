# Roku TV Learning

A workspace for learning Roku channel development with BrightScript /
BrighterScript and SceneGraph.

## Repository contents

| Folder | What it is |
|--------|------------|
| `source/`, `components/`, `assets/`, `manifest` | A sideloadable Roku channel |
| `exercises/` | Stand-alone BrightScript drills, organised by day |
| `scripts/` | `build.sh` + `roku-package.sh` |
| `bsconfig.json` | BrighterScript compiler configuration |

Each `exercises/<day>/` folder has its own README describing the drills for
that day.

## Prerequisites

- Node.js 18+ (for the BrighterScript compiler)
- `zip` available on the shell
- A Roku device on the same network with **Developer Mode** enabled, OR the
  BrightScript simulator (`brs`) for running plain BrightScript locally
- Recommended editor: VS Code with the **BrightScript Language** extension

Install the build toolchain (once):

```bash
npm install -g brighterscript brs
```

## Build the channel

```bash
npm run build
```

This runs `bsc` to validate + transpile, then packages a sideloadable zip at
`out/roku-tv-learning.zip`.

## Sideload to a Roku device

1. On the Roku, enable Developer Mode (Home ×3, Up ×2, Right, Left, Right,
   Left, Right) and note the developer web server URL (e.g.
   `http://192.168.x.x`).
2. Open that URL in a browser, sign in, and upload
   `out/roku-tv-learning.zip`.
3. Click **Install and Launch**.

Stream the device logs while the channel runs:

```bash
telnet <roku-ip> 8085
```

## Run in a BrightScript simulator

A BrightScript simulator lets you run channels on your laptop without a
Roku device. Two common options:

- **[brs-engine](https://github.com/lvcabral/brs-engine)** — full
  simulation engine that loads a channel `.zip` (manifest + components +
  source) and renders the SceneGraph UI in a browser or Electron shell.
- **[`brs` CLI](https://github.com/sjbarag/brs)** — lightweight
  interpreter focused on the language itself; great for stand-alone
  exercise scripts but does not render SceneGraph UI.

### Load the whole channel in brs-engine

Build the channel zip first, then drop it onto the simulator:

```bash
npm run build
# → out/roku-tv-learning.zip
```

Open the simulator and use its **Open / Load** option to point at
`out/roku-tv-learning.zip`. The channel runs end-to-end, including
SceneGraph UI, key handling, and any `Task` nodes. Behaviour matches a
real Roku for most use cases; hardware-only features (DRM, certain video
codecs, real-remote events) may still need a device.

### Run a single file with `brs` CLI

For pure-BrightScript exercises:

```bash
brs path/to/script.brs
```

The CLI does not auto-discover sibling files. If a script depends on
other `.brs` files, pass each one on the command line; the entry point
should be **last**:

```bash
brs source/helper.brs source/main.brs
```

## Validate the whole project

`bsc` (BrighterScript compiler) catches type errors, missing functions, and
bad XML references across the entire project without sideloading:

```bash
npx bsc        # or `npm run build` to also produce the channel zip
```

Run this whenever you change a `.brs`, `.bs`, or `.xml` file.

## Useful references

- [Roku Developer Docs](https://developer.roku.com/docs)
- [SceneGraph Component Index](https://developer.roku.com/docs/references/scenegraph/index-scenegraph-nodes.md)
- [BrightScript Reference](https://developer.roku.com/docs/references/brightscript/language/brightscript-language-reference.md)
- [BrighterScript](https://github.com/rokucommunity/brighterscript)
- [brs-engine simulator](https://github.com/lvcabral/brs-engine)
- [`brs` CLI](https://github.com/sjbarag/brs)

## Troubleshooting

| Symptom | Check |
|---------|-------|
| `bsc` errors about unknown functions | Make sure each component XML declares every `<script>` it needs (`autoImportComponentScript` is off in `bsconfig.json`) |
| Channel installs but the screen stays blank | Telnet `8085` and look for stack traces during `init()` |
| Missing images on the device | The device may be offline or the image URL unreachable |
| Simulator errors about a missing function | Pass the file that defines it on the same `brs` command |
