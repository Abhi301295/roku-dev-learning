' Day 3 / 02 / Exercise 2 — Give every ContentNode real fields
'
' Exercise 1 only set `title`. A card on screen needs more: a rating to
' show, a release year, a poster, etc. This exercise attaches three fields
' to every movie node:
'
'   movieNode.title      = "Interstellar"   ' built-in
'   movieNode.imdbRating = 8.6              ' custom float (see gotcha below)
'   movieNode.year       = 2014              ' custom integer
'
' Built-in vs custom fields — the rules that trip everyone up:
'
'   - `title` is a BUILT-IN ContentNode field. Dot-assign it directly.
'   - `rating` is ALSO built-in, but it is a STRING ("PG-13"), not your
'     IMDb score. Use a custom name like `imdbRating` for 8.6.
'   - `year` is NOT built-in. Declare with addField before assigning.
'   - Any other undeclared write is silently ignored (reads back invalid).
'
' BrightScript                                  JavaScript equivalent          Notes
' --------------------------------------------  ----------------------------- ----------------------------
' node.title = "x"                              node.title = "x"               built-in: just works
' node.addField("rating", "float", true)        (declare a typed slot)         REQUIRED before writing
' node.addField("year", "integer", true)        (declare a typed slot)         REQUIRED before writing
' node.rating = 8.6                             node.rating = 8.6              dot-set AFTER declaring
' node.getField("rating")                       node["rating"]                 dynamic-key read
'
' addField(name, type, alwaysNotify):
'   name          dot-accessible afterwards
'   type          "string" | "integer" | "float" | "boolean" | "node" | ...
'   alwaysNotify  observer fires even when the value is unchanged (Day 2)
'
' Run: brs 1.2-content-fields.brs
sub Main()
    movies = [
        { title: "Interstellar", rating: 8.6, year: 2014 }
        { title: "Inception",    rating: 8.8, year: 2010 }
    ]

    root = buildMovieContent(movies)

    print "child count = " ; root.getChildCount()
    print ""
    print "--- every node, every field ---"
    for each child in root.getChildren(-1, 0)
        print "- " ; child.title ; "  (" ; child.year.ToStr() ; ")  imdb " ; child.imdbRating.ToStr()
    end for

    ' Pitfall: built-in `rating` is a STRING ("PG-13"), not your IMDb float.
    sample = root.getChild(0)
    sample.rating = 8.6
    print ""
    print "built-in rating after 8.6 = '" ; sample.rating ; "'"   ' empty / unchanged

    sample.notAField = "ignored"
    print "undeclared field reads back = " ; sample.notAField    ' invalid
end sub

' Exercise 2: same flat tree as Exercise 1, but each child now carries
' title + numeric score + year.
'
' Gotcha: ContentNode already has a built-in `rating` field — but it is a
' STRING for content advisories ("PG-13", "TV-MA"), not your IMDb number.
' Writing movieNode.rating = 8.6 is the wrong type and is ignored.
' Use a custom field name (here: imdbRating) declared with addField.
function buildMovieContent(movies as object) as object
    root = createObject("roSGNode", "ContentNode")

    for each movie in movies
        movieNode = createObject("roSGNode", "ContentNode")

        movieNode.title = movie.title

        movieNode.addField("imdbRating", "float", true)
        movieNode.addField("year", "integer", true)
        movieNode.imdbRating = movie.rating
        movieNode.year = movie.year

        root.appendChild(movieNode)
    end for

    return root
end function
