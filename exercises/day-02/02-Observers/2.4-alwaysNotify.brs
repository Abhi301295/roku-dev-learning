' Day 2 / Observers / 2.4 — alwaysNotify: force-fire on equal values
'
' Runs in: a real Roku device, or brs-engine. (Reference reading on CLI.)
'
' Default Roku behaviour: when you write a field, observers fire ONLY if
' the new value differs from the previous one. This is the right default
' (don't repaint when nothing changed), but it bites in two real cases:
'
'   Case 1 — "kick" pattern.
'     m.task.response = invalid                   ' first set (no observer fires
'                                                   if already invalid)
'     m.task.control  = "RUN"
'     ' Task finishes -> sets response = { ... } -> observer fires (different
'     ' from invalid).
'     ' But if a SECOND fetch returns the same shape your equality check
'     ' would skip it. With alwaysNotify=true on `response`, the observer
'     ' fires on every Task completion regardless of equality.
'
'   Case 2 — "fire on every write" semantics, like a command bus.
'     m.cmd.command = "play"
'     m.cmd.command = "play"   ' second write should re-fire, not no-op
'
' How to opt in:
'
'   node.addField(name, type, alwaysNotify)
'                              ↑
'                              `true` -> observers fire on EVERY write
'                              `false`-> only on changed value (default)
'
' Built-in fields:
'   `addField` sets it for CUSTOM fields. Most built-in fields already
'   default to alwaysNotify=true where it matters (e.g. Video `state`,
'   Task `response`). You don't need to do anything for those.
'
' Roku platform API                                Day-1 shim equivalent
' --------------------------------------------     --------------------------------------------
' node.addField("response", "assocarray", true)    obs has no `value =` guard
' node.response = { ok: true }                     obs.setValue({ ok: true })
' node.response = { ok: true }   (re-fires)        obs.setValue({ ok: true })   (re-fires)
'
' Expected device output (compare the two halves):
'   [strict] fired with 1
'   [strict] fired with 2
'   ( "[strict] fired with 2" again: NO — equal value is suppressed )
'   [always] fired with 1
'   [always] fired with 2
'   [always] fired with 2     ' <- re-fires because alwaysNotify=true
sub init()
    m.strict = createObject("roSGNode", "ContentNode")
    m.strict.addField("count", "integer", false)             ' default
    m.strict.observeField("count", "onStrict")

    m.always = createObject("roSGNode", "ContentNode")
    m.always.addField("count", "integer", true)              ' alwaysNotify
    m.always.observeField("count", "onAlways")
end sub

sub onStrict(event as object) : print "[strict] fired with " ; event.getData() : end sub
sub onAlways(event as object) : print "[always] fired with " ; event.getData() : end sub

sub demo()
    m.strict.count = 1
    m.strict.count = 2
    m.strict.count = 2          ' suppressed (equal)

    m.always.count = 1
    m.always.count = 2
    m.always.count = 2          ' re-fires
end sub
