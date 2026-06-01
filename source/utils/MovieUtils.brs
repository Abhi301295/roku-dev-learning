' MovieUtils.brs — pure helpers (no catalogue / API knowledge)
'
' BrightScript has NO import/require. Every .brs under source/ is compiled
' together; functions are global. Prefix names with the file stem to avoid clashes.
'
' BrightScript                    JavaScript equivalent
' ------------------------------  ---------------------------------
' (no import)                     import { safeGetTitle } from "./MovieUtils"
' MovieUtils_safeGetTitle(...)    export function safeGetTitle(...) { ... }

function formatMovie(movie as object) as string
    ' StrI() is for integers only — 8.8 becomes 8. Use .ToStr() for floats.
    if movie = invalid then
        return ""
    end if

    if movie.title = invalid then
        return ""
    end if
    return movie.title + " (" + StrI(movie.year).Trim() + ") - " + movie.rating.ToStr()
end function

function MovieUtils_safeGetTitle(movie as dynamic) as string
    if movie = invalid then return "Unknown Movie"
    if movie.title = invalid then return "Unknown Movie"
    return movie.title
end function

function MovieUtils_filterArray(arr as object, predicate as function) as object
    out = []
    for each item in arr
        if predicate(item) then out.push(item)
    end for
    return out
end function

function MovieUtils_mapArray(arr as object, transform as function) as object
    out = []
    for each item in arr
        out.push(transform(item))
    end for
    return out
end function

function MovieUtils_reduceArray(arr as object, combine as function, seed as dynamic) as dynamic
    acc = seed
    for each item in arr
        acc = combine(acc, item)
    end for
    return acc
end function

function MovieUtils_isRecent(movie as object) as boolean
    return movie.year >= 2014
end function

function MovieUtils_isWellRated(movie as object) as boolean
    return movie.rating >= 8.0
end function

function MovieUtils_toLabel(movie as object) as string
    return movie.title + " (" + StrI(movie.year).Trim() + ") - " + movie.rating.ToStr()
end function

function MovieUtils_addDuration(total as integer, movie as object) as integer
    return total + movie.durationMins
end function

function MovieUtils_formatRuntime(totalMinutes as integer) as string
    hours = totalMinutes \ 60
    minutes = totalMinutes - (hours * 60)
    return StrI(hours).Trim() + "h " + StrI(minutes).Trim() + "m"
end function
