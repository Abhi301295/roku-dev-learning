' Day 3 / 1.1 — Minimal SceneGraph component (BrightScript half)
'
' Paired with 1.1-minimal-component.xml. The XML declares shape; this
' file owns behaviour.
'
' init() is THE component lifecycle hook. SceneGraph calls it ONCE,
' right after the component has been constructed and any declared
' children are attached. By the time init() runs:
'   - m.top is the component's root node (a Group here)
'   - any children declared in <children> are reachable via findNode
'   - the parent has NOT yet written attribute-style interface values
'     (those land AFTER init returns; see 2.1)
'
' Expected console output (one instance added to a Scene):
'   [1.1] init fired; subtype(m.top) = MinimalComponent
'   [1.1] m.top type = roSGNode

sub init()
    print "[1.1] init fired; subtype(m.top) = " ; m.top.subtype()
    print "[1.1] m.top type = " ; type(m.top)
end sub
