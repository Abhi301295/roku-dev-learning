' Day 1 / Section 3 / 3.3 — Filter
'
' BrightScript has NO built-in filter() for arrays — we write our own.
' A filter() takes:
'   - an input array
'   - a predicate function (returns true to keep, false to drop)
' Function references are passed by name in BrightScript.
'
' BrightScript                              JavaScript equivalent
' ----------------------------------------  -----------------------------------------
' filterArray(arr, isRecent)                arr.filter(isRecent)             // built-in
'                                           arr.filter(m => m.year >= 2017)  // arrow
'
' function isRecent(m as object) as boolean function isRecent(m) {
'   return m.year >= 2017                     return m.year >= 2017
' end function                              }
'
' Pass-by-name (no parens):                 Pass function reference:
'   filterArray(movies, isRecent)             arr.filter(isRecent)
'
' predicate as function                     predicate: (item) => boolean   // TS
'
' No built-in filter on roArray             Array.prototype.filter is built-in
'
' Run: brs 3.3-filter.brs
sub Main()
    movies = [
        { title: "Inception",     year: 2010, rating: 8.8 }
        { title: "Interstellar",  year: 2014, rating: 8.6 }
        { title: "Tenet",         year: 2020, rating: 7.4 }
        { title: "Oppenheimer",   year: 2023, rating: 8.3 }
        { title: "Dunkirk",       year: 2017, rating: 7.9 }
    ]

    ' Pass the predicate function by name (no parentheses).
    recent = filterArray(movies, isRecent)
    print "[recent (>=2017)]"
    printTitles(recent)

    highlyRated = filterArray(movies, isHighlyRated)
    print "[rating >= 8.5]"
    printTitles(highlyRated)
end sub

' Generic filter: returns a new array containing items for which predicate(item) = true.
function filterArray(arr as object, predicate as function) as object
    out = []
    for each item in arr
        if predicate(item) then out.push(item)
    end for
    return out
end function

' Predicates: each takes one item and returns a boolean.
function isRecent(movie as object) as boolean
    return movie.year >= 2017
end function

function isHighlyRated(movie as object) as boolean
    return movie.rating >= 8.5
end function

sub printTitles(movies as object)
    for each movie in movies
        print "- " + movie.title + " (" + StrI(movie.year).Trim() + ")"
    end for
end sub
