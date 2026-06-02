' Day 2 / Observers / 2.1 — observeField basics (real Roku API)
'
' Runs in: a real Roku device, or brs-engine. NOT the brs CLI — observers
' need the SceneGraph render thread and message pump, which the CLI does
' not implement. Use this file as reference code; copy the pattern into
' MainScene.brs to see it fire.
'
' Signature you'll use 100x in your channel:
'   node.observeField(<fieldName as string>, <callbackName as string>)
'                                              ↑
'                                              GLOBAL function (or sub) name
'                                              in the same component's .brs
'                                              file (Roku looks it up by name)
'
' Mechanics on device:
'   1. You set up the observer in init() (or wherever).
'   2. Anyone — including your own code, a Task on another thread, or the
'      framework — writes the field.
'   3. The platform queues a notification on the render thread.
'   4. Between message-pump ticks, the platform invokes your callback.
'      The callback runs on the RENDER thread, so it can touch nodes.
'
' BrightScript / SceneGraph                       Day-1 shim equivalent
' --------------------------------------------    --------------------------------------------
' node.observeField("counter", "onCounter")       obs.subscribe(onCounter)
' node.counter = 42                               obs.setValue(42)
' sub onCounter()                                 sub onCounter(field, value)
'   value = m.node.counter                          ' value is the new value
' end sub                                         end sub
'
' Two callback shapes are valid:
'   (a) sub onCounter()                  ' no args — read current value via `m.node.counter`
'   (b) sub onCounter(event as object)   ' event = roSGNodeEvent (covered in 2.2)
'
' This file uses shape (a) — the simpler form. Shape (b) is 2.2.
'
' Expected device output (after wiring this into a component):
'   [observer] counter changed; value is now 1
'   [observer] counter changed; value is now 2
'   [observer] counter changed; value is now 5
sub init()
    ' Typical placement: cache nodes, declare state, then register
    ' observers. Mirrors MainScene.brs's `init -> cacheNodes ->
    ' registerObservers` shape.
    m.counterNode = createObject("roSGNode", "ContentNode")
    m.counterNode.addField("counter", "integer", true)
    m.counterNode.counter = 0

    m.counterNode.observeField("counter", "onCounterChange")
end sub

' Two ways to react. We're using the no-argument form here; the
' framework gives us nothing, so we look the value up directly.
sub onCounterChange()
    value = m.counterNode.counter
    print "[observer] counter changed; value is now " ; value
end sub

' Caller in the scene: every mutation fires the observer. The brs CLI
' would crash trying to execute this; on device it prints three lines.
sub demo()
    m.counterNode.counter = 1
    m.counterNode.counter = 2
    m.counterNode.counter = 5
end sub
