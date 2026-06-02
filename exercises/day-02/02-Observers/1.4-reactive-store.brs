' Day 2 / Observers / 1.4 — A multi-field reactive store
'
' Runs in: brs CLI (no SceneGraph needed)
'
' Real screens have many reactive fields, not one. A `roSGNode` is a
' container of named fields, each independently observable. This file
' simulates that with a "store" AA holding many observables at once.
'
' The pattern is the same as Redux/MobX/Pinia/etc.:
'   - One owner of state.
'   - Subscribers attach by field name.
'   - Mutating one field fires only that field's observers.
'
' BrightScript shim                              Roku platform API
' --------------------------------------------   --------------------------------------------
' store = newStore({ loading: true, count: 0 })  node.addFields({ loading: true, count: 0 })
' store.observe("count", onCount)                node.observeField("count", "onCount")
' store.set("count", 1)                          node.count = 1
' store.set("loading", false)                    node.loading = false
'
' Reading this side-by-side with the real platform pattern (Section 2)
' makes the translation obvious: every line maps one-to-one.
'
' Run: brs 1.4-reactive-store.brs
sub Main()
    store = newStore({ loading: true, errorMsg: "", movieCount: 0 })

    store.observe("loading", onLoading)
    store.observe("errorMsg", onError)
    store.observe("movieCount", onCount)

    print "[fetch start]"
    store.set("loading", true) ' value already true -> no fire

    print "[fetch done, 6 movies]"
    store.set("loading", false)
    store.set("movieCount", 6)

    print ""
    print "[different field, only its observer fires]"
    store.set("errorMsg", "Network timeout")
end sub

sub onLoading(field as string, value as dynamic)
    if value then
        print "  [spinner] show"
    else
        print "  [spinner] hide"
    end if
end sub

sub onError(field as string, value as dynamic)
    if Len(value) > 0 then
        print "  [error]   " ; value
    end if
end sub

sub onCount(field as string, value as dynamic)
    print "  [count]   " ; value ; " movies"
end sub

' --- store: many independent observables under one AA ---
'
' Internally just a map from field name -> { value, subscribers[] }.
' This is essentially how Roku stores observers per-field on a node.
function newStore(initial as object) as object
    store = {
        fields: {}
    }
    for each k in initial
        store.fields[k] = { value: initial[k], subscribers: [] }
    end for

    ' Senior gotcha: don't use `aa[key] = invalid` as a membership check.
    ' AAs have built-in methods (count, keys, lookup, doesExist, ...) that
    ' bracket-indexing returns instead of `invalid`. Use `doesExist`.
    store.observe = function(field as string, callback as function) as void
        if not m.fields.doesExist(field) then
            m.fields[field] = { value: invalid, subscribers: [] }
        end if
        m.fields[field].subscribers.push(callback)
    end function

    store.set = function(field as string, value as dynamic) as void
        if not m.fields.doesExist(field) then
            m.fields[field] = { value: value, subscribers: [] }
            return ' first write: no observers yet
        end if
        slot = m.fields[field]
        if isPrimitive(slot.value) and isPrimitive(value) and slot.value = value then return
        slot.value = value
        for each cb in slot.subscribers
            cb(field, value)
        end for
    end function

    store.get = function(field as string) as dynamic
        if not m.fields.doesExist(field) then return invalid
        return m.fields[field].value
    end function

    return store
end function

function isPrimitive(v as dynamic) as boolean
    if v = invalid then return true
    t = type(v)
    if t = "Integer" or t = "Float" or t = "Double" or t = "LongInteger" then return true
    if t = "String" or t = "roString" or t = "Boolean" then return true
    return false
end function
