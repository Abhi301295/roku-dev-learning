' Day 2 / Observers / 1.3 — Unsubscribe and observer leaks
'
' Runs in: brs CLI (no SceneGraph needed)
'
' Subscribing is half the contract. The other half is *removing* the
' subscription when the consumer goes away. On Roku, every observer you
' add pins a function reference on the node. If you swap screens and
' never unobserve, the old screen's callbacks keep firing, often against
' stale `m` state. Symptoms: phantom log lines, crashes after navigation,
' rising memory.
'
' BrightScript shim                          JavaScript / EventEmitter         Roku platform API
' ----------------------------------------   -------------------------------   --------------------------------
' obs.subscribe(cb)                          emitter.on("x", cb)               node.observeField("x", "cb")
' obs.unsubscribe(cb)                        emitter.off("x", cb)              node.unobserveField("x")
'                                                                              (Roku: removes ALL observers
'                                                                               on that field for this node)
'
' Senior rule: every `observeField` on the render thread must have a
' matching cleanup. Screen-scoped components get away with it because
' tearing down the scene drops the node anyway, but Task-side observers
' and shared/global nodes leak forever if you don't unobserve.
'
' Run: brs 1.3-unsubscribe-and-leaks.brs
sub Main()
    obs = newObservable("status", "idle")

    obs.subscribe(logger)
    obs.subscribe(uiUpdater)

    print "[2 subscribers]"
    obs.setValue("loading")     ' both fire

    print ""
    print "[remove uiUpdater]"
    obs.unsubscribe(uiUpdater)
    obs.setValue("ready")       ' only logger fires

    print ""
    print "[clear all]"
    obs.clear()
    obs.setValue("error")       ' nobody fires
    print "  (no observer output above)"
end sub

sub logger(field as string, value as dynamic)
    print "  [logger]    " ; field ; " = " ; value
end sub

sub uiUpdater(field as string, value as dynamic)
    print "  [ui]        repaint for " ; value
end sub

' --- shim with unsubscribe + clear ---
'
' Storing function references in an AA is fine in BrightScript. The
' tricky bit is "equality": two function references compare equal only
' when they point to the same global function. That's the same constraint
' the JS pattern uses (`emitter.off(name, cb)` requires the exact `cb`).
function newObservable(field as string, initial as dynamic) as object
    obs = {
        field: field
        value: initial
        subscribers: []
    }

    obs.subscribe = function(callback as function) as void
        m.subscribers.push(callback)
    end function

    obs.unsubscribe = function(callback as function) as void
        kept = []
        for each cb in m.subscribers
            if not (cb = callback) then kept.push(cb)
        end for
        m.subscribers = kept
    end function

    obs.clear = function() as void
        m.subscribers = []
    end function

    obs.setValue = function(value as dynamic) as void
        if isPrimitive(m.value) and isPrimitive(value) and m.value = value then return
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

function isPrimitive(v as dynamic) as boolean
    if v = invalid then return true
    t = type(v)
    if t = "Integer" or t = "Float" or t = "Double" or t = "LongInteger" then return true
    if t = "String" or t = "roString" or t = "Boolean" then return true
    return false
end function
