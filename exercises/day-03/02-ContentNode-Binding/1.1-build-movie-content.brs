' Day 3 / 02 / Exercise 1 — Data array -> ContentNode tree
'
' Day 2 taught the pieces in isolation:
'
'   Field  ->  Observer  ->  Label
'
' Day 3 wires up the pattern every real channel screen is built on:
'
'   Data (AA array)  ->  ContentNode tree  ->  UI component
'
' React mental model:
'
'   movies.map(movie => <MovieCard title={movie.title} />)
'
'   Movies Array                    plain AAs, pure data
'         |
'         v
'   ContentNode Tree                what you build here
'         |
'         v
'   MarkupGrid / RowList / LabelList  renders automatically from the tree
'
' The grid/list does NOT render the AA array directly. You first translate
' the data into a tree of real roSGNode "ContentNode" objects. THAT tree is
' what you hand to `someList.content`, and the UI paints itself from it.
'
' This first exercise builds the flat one-level tree:
'
'   root (Movies)
'   |-- Interstellar
'   |-- Inception
'
' BrightScript                                JavaScript / React equivalent     Notes
' ------------------------------------------  --------------------------------- ------------------------
' createObject("roSGNode", "ContentNode")     document.createElement(...)        a real node, not an AA
' root.appendChild(child)                      root.appendChild(child)           same name, same behaviour
' root.getChildCount()                         root.childNodes.length            how many children
' root.getChildren(-1, 0)                      [...root.childNodes]              all children as an array
'
' Run: brs 1.1-build-movie-content.brs
sub Main()
    movies = [
        { title: "Interstellar", rating: 8.6 }
        { title: "Inception",    rating: 8.8 }
    ]

    root = buildMovieContent(movies)

    print "root subtype = " ; root.subtype()        ' ContentNode
    print "child count  = " ; root.getChildCount()  ' 2

    print ""
    print "--- children ---"
    for each child in root.getChildren(-1, 0)
        print "- " ; child.title
    end for

    ' In a real screen this is the whole point:
    '   m.movieGrid.content = root
end sub

' Exercise 1: turn an array of movie AAs into a ContentNode tree.
'
'   - root is one ContentNode (the parent the grid/list points at).
'   - each movie becomes its OWN child ContentNode appended to root.
'
' Only the built-in `title` field is set here; Exercise 2 adds the rest.
function buildMovieContent(movies as object) as object
    root = createObject("roSGNode", "ContentNode")

    for each movie in movies
        movieNode = createObject("roSGNode", "ContentNode")
        movieNode.title = movie.title
        root.appendChild(movieNode)
    end for

    return root
end function
