' Day 2 / Observers / 2.2 — The roSGNodeEvent payload
'
' Runs in: a real Roku device, or brs-engine. (See 2.1 for why brs CLI
' cannot run observers.)
'
' Callback shape (b): one parameter, an `roSGNodeEvent`. This object tells
' you exactly what fired, on which node, with what new value — without
' you having to capture references manually.
'
' roSGNodeEvent API (the only members you'll touch in 95% of channels):
'   event.getField()       string — name of the field that changed
'   event.getData()        dynamic — the NEW value
'   event.getNode()        string — the id of the node that fired
'   event.getRoSGNode()    object — the node reference itself
'
' Why prefer shape (b) over shape (a) from 2.1?
'   - You can share ONE callback across multiple fields on the same node
'     and branch on event.getField().
'   - When the same callback is used for several nodes (a generic
'     handler), event.getRoSGNode() / getNode() identifies the source.
'   - getData() is the new value *as the platform observed it*, which
'     can matter if your code raced another write.
'
' Senior gotcha: getData() vs reading the node.
'   `event.getData()` is the value at the time the event was queued.
'   `m.node.counter` is the value at the time the callback runs.
'   They can differ if many writes coalesced into one render-thread tick.
'   For booleans/counters this rarely matters; for arrays/AAs it can.
'
' BrightScript / SceneGraph                              JavaScript / DOM equivalent
' ----------------------------------------------------   -------------------------------------
' node.observeField("title", "onAnyChange")              el.addEventListener("title", onChange)
' sub onAnyChange(event as object)                       function onChange(event) {
'   field   = event.getField()                             const field = event.type;
'   value   = event.getData()                              const value = event.detail;
'   source  = event.getRoSGNode()                          const source = event.target;
' end sub                                                }
'
' Expected device output:
'   [observer] field=title    new value=Inception
'   [observer] field=rating   new value=8.8
'   [observer] field=year     new value=2010
sub init()
    m.movie = createObject("roSGNode", "ContentNode")
    m.movie.addFields({ rating: 0.0, year: 0 })
    m.movie.title = ""

    ' One callback, three fields. Without the event payload we couldn't
    ' tell which field changed.
    m.movie.observeField("title",  "onMovieField")
    m.movie.observeField("rating", "onMovieField")
    m.movie.observeField("year",   "onMovieField")
end sub

sub onMovieField(event as object)
    field = event.getField()
    value = event.getData()
    print "[observer] field=" ; field ; "   new value=" ; value
end sub

sub demo()
    m.movie.title  = "Inception"
    m.movie.rating = 8.8
    m.movie.year   = 2010
end sub
