' Day 2 / Observers / 1.1 — The observer pattern from scratch
'
' Runs in: brs CLI (no SceneGraph needed)
'
' "Reactive programming" sounds fancy. The kernel is small:
'   1. Subscribe a callback to a value.
'   2. When the value changes, the value's owner calls every subscribed
'      callback with the new value.
'   3. You stop polling and start *reacting*.
'
' This is exactly what Roku's `observeField` does on `roSGNode`. The CLI
' doesn't ship SceneGraph, so this file builds a tiny BrighterScript-
' equivalent ("Observable") so you can run the pattern and see it fire
' immediately. Sections 2 and 3 then use the real platform API.
'
' BrightScript shim                          JavaScript / EventEmitter        Roku platform API
' ----------------------------------------   ------------------------------   --------------------------------
' obs = newObservable("counter", 0)          new EventTarget()                createObject("roSGNode", "ContentNode")
' obs.subscribe(onChange)                    target.addEventListener(...)     node.observeField("counter", "onChange")
' obs.setValue(42)                           target.dispatch(new Event(...))  node.counter = 42
'   -> every subscriber fires synchronously    (sync)                           (fires on render thread)
'
' Run: brs 1.1-pattern-fundamentals.brs
sub Main()
    obs = newObservable("counter", 0)

    ' Subscribe a callback by name. The shim stores the function reference
    ' alongside the value, just like Roku stores observer thunks on a node.
    obs.subscribe(onCounterChange)

    print "[before] value = " ; obs.getValue()
    print "[mutate] -> 1"
    obs.setValue(1)
    print "[mutate] -> 2"
    obs.setValue(2)
    print "[mutate] -> 2 (no-op, value unchanged)"
    obs.setValue(2)            ' setValue should NOT fire if value didn't change
    print "[after]  value = " ; obs.getValue()
end sub

' --- callback (the reaction) ---

sub onCounterChange(field as string, value as dynamic)
    print "  [observer] " ; field ; " changed -> " ; value
end sub

' --- the shim: a poor-man's roSGNode observer ---
'
' Returns an AA with these methods:
'   subscribe(callback)   register a function reference; will be called as
'                         callback(fieldName, newValue) on every change
'   setValue(value)       updates the value and fires every subscriber if
'                         and only if the value actually changed
'   getValue()            read the current value
function newObservable(field as string, initial as dynamic) as object
    obs = {
        field: field
        value: initial
        subscribers: []
    }

    obs.subscribe = function(callback as function) as void
        m.subscribers.push(callback)
    end function

    obs.setValue = function(value as dynamic) as void
        if m.value = value then return        ' no-op when unchanged (default Roku behaviour)
        m.value = value
        for each cb in m.subscribers
            cb(m.field, m.value)
        end for
    end function

    obs.getValue = function() as dynamic
        return m.value
    end function

    return obs
end function
