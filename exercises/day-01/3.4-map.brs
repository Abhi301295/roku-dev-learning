' Day 1 / Section 3 / 3.4 — Map (transform each item)
'
' Like filter, BrightScript has no built-in map(). We build it ourselves.
' map() takes:
'   - an input array
'   - a transform function (item -> new value)
' and returns a NEW array of the same length.
'
' BrightScript                              JavaScript equivalent
' ----------------------------------------  -----------------------------------------
' mapArray(movies, getTitle)                movies.map(getTitle)             // built-in
'                                           movies.map(m => m.title)         // arrow
'
' function getTitle(m as object) as string  function getTitle(m) {
'   return m.title                            return m.title
' end function                              }
'
' transform as function                     transform: (item) => U          // TS
'
' Result: NEW array, same length            Same — both return a new array,
' (input not mutated)                       leaving the input untouched
'
' for each x in arr : print x : end for     for (const x of arr) console.log(x)
' (BRS one-liner with `:` separator)        (no `:` separator in JS;
'                                            use semicolons / newlines)
'
' Run: brs 3.4-map.brs
sub Main()
    movies = [
        { title: "Inception",    year: 2010 }
        { title: "Interstellar", year: 2014 }
        { title: "Oppenheimer",  year: 2023 }
    ]

    ' Extract just titles.
    titles = mapArray(movies, getTitle)
    print "[titles]"
    for each t in titles : print "- " + t : end for

    ' Build a display string per movie.
    labels = mapArray(movies, formatMovie)
    print "[labels]"
    for each lbl in labels : print "- " + lbl : end for

    ' Map a list of numbers.
    prices = [99, 199, 299, 499]
    formatted = mapArray(prices, formatPrice)
    print "[prices]"
    for each p in formatted : print "- " + p : end for
end sub

' Generic map: applies transform(item) to every entry, returns a new array.
function mapArray(arr as object, transform as function) as object
    out = []
    for each item in arr
        out.push(transform(item))
    end for
    return out
end function

function getTitle(movie as object) as string
    return movie.title
end function

function formatMovie(movie as object) as string
    return movie.title + " (" + StrI(movie.year).Trim() + ")"
end function

function formatPrice(amount as integer) as string
    return "$" + StrI(amount).Trim() + ".00"
end function
