' MovieUtils.brs — pure helpers (no catalogue / API knowledge)
'
' BrightScript has NO import/require. Every .brs under source/ is compiled
' together; functions are global. Prefix names with the file stem to avoid clashes.
'
' Collection utils ↔ JavaScript equivalents
' ------------------------------------------------------------
' MovieUtils_filterByRating(arr, 8.5)   arr.filter(m => m.rating >= 8.5)
' MovieUtils_findByTitle(arr, "Tenet")  arr.find(m => m.title === "Tenet") ?? null
' MovieUtils_averageRating(arr)         arr.reduce((s,m)=>s+m.rating,0) / arr.length
' MovieUtils_totalWatchTime(arr)        arr.reduce((s,m)=>s+m.durationMins,0)
' MovieUtils_mapTitles(arr)             arr.map(m => m.title)
'
' Generic helpers that take a function-by-name:
' MovieUtils_filterArray(arr, fn)       arr.filter(fn)
' MovieUtils_mapArray(arr, fn)          arr.map(fn)
' MovieUtils_reduceArray(arr, fn, seed) arr.reduce(fn, seed)

function formatMovie(movie as object) as string
    ' StrI() is for integers only — 8.8 becomes 8. Use .ToStr() for floats.
    return movie.title + " (" + StrI(movie.year).Trim() + ") - " + movie.rating.ToStr()
end function

function MovieUtils_safeGetTitle(movie as dynamic) as string
    if movie = invalid then return "Unknown Movie"
    if movie.title = invalid then return "Unknown Movie"
    return movie.title
end function

' --- Domain-specific collection helpers ---

' Returns movies whose rating is >= minRating (keeps order).
function MovieUtils_filterByRating(movies as object, minRating as float) as object
    out = []
    for each movie in movies
        if movie.rating >= minRating then out.push(movie)
    end for
    return out
end function

' Returns the first movie with movie.title = title, or invalid.
' Note: returns a dynamic (object OR invalid) — declared `as object` because
' BRS allows invalid to flow through `as object` returns at runtime, and
' callers must guard with `if result = invalid`.
function MovieUtils_findByTitle(movies as object, title as string) as object
    for each movie in movies
        if movie.title = title then return movie
    end for
    return invalid
end function

' Average of movie.rating values. Returns 0.0 for an empty array.
function MovieUtils_averageRating(movies as object) as float
    count = movies.count()
    if count = 0 then return 0.0
    total = 0.0
    for each movie in movies
        total = total + movie.rating
    end for
    return total / count
end function

' Sum of movie.durationMins (in minutes).
function MovieUtils_totalWatchTime(movies as object) as integer
    total = 0
    for each movie in movies
        total = total + movie.durationMins
    end for
    return total
end function

' Maps an array of movie objects to an array of their titles.
'   [ { title: "Inception" }, { title: "Tenet" } ]  ->  [ "Inception", "Tenet" ]
function MovieUtils_mapTitles(movies as object) as object
    titles = []
    for each movie in movies
        titles.push(movie.title)
    end for
    return titles
end function

' --- Generic helpers (function-by-name) ---

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
