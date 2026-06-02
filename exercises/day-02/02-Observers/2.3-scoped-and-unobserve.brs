' Day 2 / Observers / 2.3 — observeFieldScoped + unobserveField
'
' Runs in: a real Roku device, or brs-engine. (Reference reading on CLI.)
'
' Roku ships TWO related observe APIs and one removal API. Senior code
' picks them deliberately.
'
'                                     What gets searched for the callback?
'   ------------------------------    ------------------------------------------------
'   observeField(field, callback)     Global (component-file-level) function lookup
'   observeFieldScoped(field, cb)     Local first (the m. scope of the OBSERVING
'                                     component), then walks up if not found
'   unobserveField(field)             Removes EVERY observer this caller added on
'                                     that field. There is no per-callback removal.
'
' Why observeFieldScoped exists:
'   Imagine MainScene observes a field on a child component. With
'   `observeField`, the callback `onTaskDone` is looked up in MAINSCENE's
'   .brs file. With `observeFieldScoped`, it can also see callbacks on
'   `m.` (helpful when the registering code itself is in a shared
'   helper module). For most channel code, plain `observeField` is fine.
'
' Cleanup pattern that prevents leaks:
'
'   sub registerObservers()
'       m.task.observeField("response", "onResponse")
'       m.grid.observeField("itemSelected", "onItemSelected")
'   end sub
'
'   sub onSceneClosing()
'       m.task.unobserveField("response")
'       m.grid.unobserveField("itemSelected")
'   end sub
'
' Because `unobserveField` removes ALL of THIS caller's observers on a
' field, you don't need to remember which sub registered which.
'
' Roku platform API                                Day-1 shim equivalent
' --------------------------------------------     --------------------------------------------
' node.observeField("x", "cb")                     obs.subscribe(cb)
' node.observeFieldScoped("x", "cb")               (no shim — same idea, different lookup)
' node.unobserveField("x")                         obs.clear()         (per-field)
'
' Expected device output:
'   [obs] counter changed -> 1
'   [obs] counter changed -> 2
'   [obs] (after unobserve, no further output for counter)
sub init()
    m.state = createObject("roSGNode", "ContentNode")
    m.state.addField("counter", "integer", true)

    ' Most common form. The callback `onCounter` is a global sub below.
    m.state.observeField("counter", "onCounter")
end sub

sub onCounter(event as object)
    print "[obs] counter changed -> " ; event.getData()
end sub

sub demo()
    m.state.counter = 1
    m.state.counter = 2

    ' Drop the observer entirely. No more "[obs]" lines below.
    m.state.unobserveField("counter")

    m.state.counter = 3
    m.state.counter = 4
end sub
