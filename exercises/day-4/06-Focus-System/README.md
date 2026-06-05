# Day 4 / 06 — Focus System

Roku has **no mouse, no touch, no browser**. One node in the scene tree holds focus at any time. The remote drives it with **UP / DOWN / LEFT / RIGHT**; **OK** activates the focused node.

## What you learn

| API | Meaning |
|-----|---------|
| `node.setFocus(true)` | Give this node the remote's attention |
| `node.hasFocus()` | Returns `true` if this node currently holds focus |

Lists (`LabelList`, `MarkupGrid`, `RowList`) handle **UP/DOWN** (and **LEFT/RIGHT** within a row) internally once they have focus. Moving focus **between** sibling nodes is your job — usually via `onKeyEvent`.

## Exercise

| File pair | Goal |
|-----------|------|
| `1.1-focus-basics-scene.{xml,brs}` | Two `LabelList` nodes; boot focus on list A; **LEFT/RIGHT** moves focus between them; log `hasFocus()` |

## Sideload checklist

1. Copy pair → `components/FocusBasicsScene.xml` + `.brs`
2. Set root scene to `FocusBasicsScene`
3. Build and sideload

## Expected console

```text
[4.6] FocusBasicsScene init
[4.6] listA.hasFocus() = true
[4.6] listB.hasFocus() = false
[4.6] moved focus -> listB
[4.6] listA.hasFocus() = false
[4.6] listB.hasFocus() = true
```

## React mental model

There is no DOM `focus()` on arbitrary divs. Think of focus as **which widget owns the remote right now** — closer to roving tabindex in a TV app than to web defaults.
