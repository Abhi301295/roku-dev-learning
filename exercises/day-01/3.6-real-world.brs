' Day 1 / Section 3 / 3.6 — Real-world: filter + map + reduce together
'
' Channel-style scenario: an API returns a catalogue of titles. We need to
' produce a "trending highly-rated picks" list with totals.
'
' BrightScript pipeline                     JavaScript equivalent (chained)
' ----------------------------------------  -----------------------------------------
' recent       = filterArray(catalogue,     const totalMinutes = catalogue
'                            isRecent)        .filter(isRecent)
' wellRated    = filterArray(recent,          .filter(isWellRated)
'                            isWellRated)     .reduce(addDuration, 0)
' totalMinutes = reduceArray(wellRated,
'                            addDuration, 0)
'
' labels = mapArray(wellRated, toLabel)     const labels = wellRated.map(toLabel)
'
' Why chained calls don't work in BRS:      In JS, .filter / .map / .reduce all
'   roArray has no .filter / .map /         live on Array.prototype, so they chain.
'   .reduce methods, so we always           In BRS we route through a generic
'   wrap with our own helpers and           helper that takes the array AND a
'   pass functions by NAME.                 function reference.
'
' a \ b                                     Math.floor(a / b)            // BRS integer divide
' StrI(n).Trim()                            String(n)                    // stringify int
'
' Run: brs 3.6-real-world.brs
sub Main()
    catalogue = [
        { title: "Inception",     year: 2010, rating: 8.8, durationMins: 148 }
        { title: "Interstellar",  year: 2014, rating: 8.6, durationMins: 169 }
        { title: "Tenet",         year: 2020, rating: 7.4, durationMins: 150 }
        { title: "Oppenheimer",   year: 2023, rating: 8.3, durationMins: 180 }
        { title: "Dunkirk",       year: 2017, rating: 7.9, durationMins: 106 }
        { title: "The Prestige",  year: 2006, rating: 8.5, durationMins: 130 }
    ]

    ' Pipeline: pick recent (>=2014) AND well-rated (>=8.0), then build labels,
    ' then total their runtime.
    recent       = filterArray(catalogue, isRecent)
    wellRated    = filterArray(recent, isWellRated)
    labels       = mapArray(wellRated, toLabel)
    totalMinutes = reduceArray(wellRated, addDuration, 0)

    print "[picks]"
    for each lbl in labels : print "- " + lbl : end for
    print ""
    print "total runtime: " + formatRuntime(totalMinutes)
end sub

' --- generic helpers (same shape as 3.3 / 3.4 / 3.5) ---

function filterArray(arr as object, predicate as function) as object
    out = []
    for each item in arr
        if predicate(item) then out.push(item)
    end for
    return out
end function

function mapArray(arr as object, transform as function) as object
    out = []
    for each item in arr
        out.push(transform(item))
    end for
    return out
end function

function reduceArray(arr as object, combine as function, seed as dynamic) as dynamic
    acc = seed
    for each item in arr
        acc = combine(acc, item)
    end for
    return acc
end function

' --- domain functions ---

function isRecent(movie as object) as boolean
    return movie.year >= 2014
end function

function isWellRated(movie as object) as boolean
    return movie.rating >= 8.0
end function

function toLabel(movie as object) as string
    return movie.title + " (" + StrI(movie.year).Trim() + ") - " + movie.rating.ToStr()
end function

function addDuration(total as integer, movie as object) as integer
    return total + movie.durationMins
end function

function formatRuntime(totalMinutes as integer) as string
    hours   = totalMinutes \ 60
    minutes = totalMinutes - (hours * 60)
    return StrI(hours).Trim() + "h " + StrI(minutes).Trim() + "m"
end function
