' Day 2 / Observers / 1.2 — Multiple subscribers on one value
'
' Runs in: brs CLI (no SceneGraph needed)
'
' Reactive systems shine when ONE change drives many reactions. Imagine a
' "currentMovie" field on your Scene: the title label, the rating badge,
' and an analytics tracker all need to update together. Instead of every
' UI piece polling, every piece subscribes to the same field. The
' framework fans the change out.
'
' BrightScript shim                          JavaScript / EventEmitter         Roku platform API
' ----------------------------------------   -------------------------------   --------------------------------
' obs.subscribe(updateTitle)                 emitter.on("movie", updateTitle)  node.observeField("movie", "onTitle")
' obs.subscribe(updateRating)                emitter.on("movie", updateRating) node.observeField("movie", "onRating")
' obs.subscribe(logAnalytics)                emitter.on("movie", logAnalytics) node.observeField("movie", "onAnalytics")
' obs.setValue(movie)                        emitter.emit("movie", movie)      node.movie = movie
'   -> all three callbacks fire                                                 -> Roku fires all three observers
'   -> in subscription order                                                    -> on the render thread tick
'
' Run: brs 1.2-multiple-subscribers.brs
sub Main()
    obs = newObservable("currentMovie", invalid)

    obs.subscribe(updateTitle)
    obs.subscribe(updateRating)
    obs.subscribe(logAnalytics)

    print "[3 observers subscribed, firing 1 update...]"
    obs.setValue({ title: "Inception", rating: 8.8 })

    print ""
    print "[changing movie -> 1 update, 3 reactions...]"
    obs.setValue({ title: "Interstellar", rating: 8.6 })
end sub

' --- reactions ---

sub updateTitle(field as string, movie as dynamic)
    if movie = invalid then return
    print "  [ui] title -> " ; movie.title
end sub

sub updateRating(field as string, movie as dynamic)
    if movie = invalid then return
    print "  [ui] rating -> " ; movie.rating
end sub

sub logAnalytics(field as string, movie as dynamic)
    if movie = invalid then return
    print "  [analytics] viewed='" ; movie.title ; "' rating=" ; movie.rating
end sub

' --- shim (same as 1.1, copied so each file is standalone) ---

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
        ' BrightScript can compare primitives with `=` but throws on AAs /
        ' arrays. For the shim, we only suppress when both sides are
        ' primitives AND equal; object-typed fields always fire (matches
        ' Roku's behaviour for `node` / `assocarray` typed fields).
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

' Helper used by the shim to decide whether two values can be `=` compared
' safely. BrightScript throws on AA / array equality.
function isPrimitive(v as dynamic) as boolean
    if v = invalid then return true
    t = type(v)
    if t = "Integer" or t = "Float" or t = "Double" or t = "LongInteger" then return true
    if t = "String" or t = "roString" or t = "Boolean" then return true
    return false
end function
