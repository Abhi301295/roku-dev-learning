# Day 3 / 01 — Real SceneGraph Components

The XML file declares a component's **shape** (its name, the interface it exposes to parents, the children it ships with). The paired `.brs` file owns its **behaviour** (lifecycle `init()`, observers, callbacks, helpers). Both halves share the same component identity through the `<script uri="...">` link.

Each exercise here is one `.xml` + one `.brs` pair with the same base filename.

## Runtime caveat

These components must be **instantiated by the SceneGraph runtime**. They will not run under the `brs` CLI. To execute them:

1. Switch to the `day-3-implementation` branch.
2. Copy the `.xml` + `.brs` pair into `components/` (rename to match the `<component name="…">` declared in the XML, e.g. `components/MinimalComponent.xml`).
3. Reference the component from `components/MainScene.xml` inside `<children>`, e.g. `<MinimalComponent id="demo" />`.
4. `npm run build` and sideload, or open in the BrightScript Simulator.
5. Watch the simulator's console for the `[1.1]` / `[1.2]` / … log tags.

## Section 1 — XML anatomy

The bare minimum syntax, then the two pieces that make a component **useful** for other code: its `<interface>` (its public API) and its `<children>` (its declared visual tree).

| Step | File pair | Concepts |
|------|-----------|----------|
| 1.1  | `1.1-minimal-component.{xml,brs}` | `<?xml ?>`, `<component name extends>`, `<script uri>`, `init()` |
| 1.2  | `1.2-interface-fields.{xml,brs}`  | `<interface>` + `<field id type value alwaysNotify alias>`; what's visible to the parent and when |
| 1.3  | `1.3-declarative-children.{xml,brs}` | `<children>`, child `id="…"` attribute, `findNode` from `init()` |

## Section 2 — Lifecycle and tree navigation

Inside the component: when does `init()` run, where does state live, and how do you reach the children that XML wired up?

| Step | File pair | Concepts |
|------|-----------|----------|
| 2.1  | `2.1-init-and-m-top.{xml,brs}`        | `init()` contract; `m` vs `m.top`; what's set up by the time `init()` fires |
| 2.2  | `2.2-findNode-and-caching.{xml,brs}`  | One `findNode` per child during `init`; cached references on `m.*`; the React `useRef` analogue |
| 2.3  | `2.3-m-global-vs-m-top.{xml,brs}`     | `m.global` as the scene-wide shared `roSGNode`; declaring shared fields, observing from elsewhere |

## Section 3 — Component communication

The three ways components exchange information. Each is just `observeField`, framed differently.

| Step | File pair | Direction | Mechanism |
|------|-----------|-----------|-----------|
| 3.1  | `3.1-parent-to-child.{xml,brs}`   | parent → child | child observes its own interface field |
| 3.2  | `3.2-child-to-parent.{xml,brs}`   | child → parent | parent observes the child's interface field |
| 3.3  | `3.3-cross-component.{xml,brs}`   | sibling ↔ sibling | both observe a field on the shared `m.global` node |

## Section 4 — Challenge

Build a production-shaped component that uses everything from sections 1–3 in one place.

| File pair | Goal |
|-----------|------|
| `4-challenge-movie-badge.{xml,brs}` | A `MovieBadge` component: declares `<interface>` for inbound data (`movie`, `selected`) and outbound signal (`clickCount`); declares `<children>` for the poster + title + rating layout; observes its own fields and repaints. The file ships a complete reference solution. Try building one from scratch first. |

## Cheat sheet

```xml
<!-- Component skeleton -->
<?xml version="1.0" encoding="utf-8" ?>
<component name="MyThing" extends="Group">
    <script type="text/brightscript" uri="pkg:/components/MyThing.brs" />

    <interface>
        <field id="data"   type="assocarray" />                  <!-- inbound -->
        <field id="click"  type="integer" alwaysNotify="true" /> <!-- outbound -->
    </interface>

    <children>
        <Label id="titleLabel" translation="[0,0]" />
    </children>
</component>
```

```brightscript
' Paired .brs
sub init()
    m.titleLabel = m.top.findNode("titleLabel")     ' cache once
    m.top.observeField("data", "onDataChanged")     ' subscribe to inbound
end sub

sub onDataChanged()
    payload = m.top.data
    if payload = invalid then return
    m.titleLabel.text = payload.title
end sub

' Outbound: bump the click field; the parent's observer fires.
sub callbackEnter()
    m.top.click = m.top.click + 1
end sub
```
