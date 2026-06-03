' Day 3 / 02 / Exercise 3 — Walk and print a ContentNode tree
'
' Before you trust a tree to the UI, you want to SEE it. printContentTree
' is the debugging tool you will reach for constantly: it walks the tree
' depth-first and prints each node's title, indented by depth.
'
' Target output for the flat movie tree:
'
'   Movies
'     Interstellar
'     Inception
'
' The walk is the classic recursive DOM traversal: print the current node,
' then recurse into each child with one more level of indentation.
'
' BrightScript                                  JavaScript / DOM equivalent       Notes
' --------------------------------------------  -------------------------------- ------------------------
' node.getChildren(-1, 0)                       [...node.childNodes]              children as an array
' node.getChildCount()                          node.childNodes.length            leaf check: count == 0
' recurse with depth + 1                        walk(child, depth + 1)            deeper indent
' string(n, " ")                                " ".repeat(n)                     build the indent string
'
' Run: brs 1.3-print-content-tree.brs
sub Main()
    movies = [
        { title: "Interstellar", rating: 8.6, year: 2014 }
        { title: "Inception",    rating: 8.8, year: 2010 }
    ]

    root = buildMovieContent(movies)

    print "--- titles only ---"
    printContentTree(root)
end sub

' Exercise 3: print the whole tree, root first, indented by depth.
'
' `depth` is an optional parameter so callers just write
' printContentTree(root). BrightScript fills the default (0) on the first
' call, and the recursion passes depth + 1 going down.
sub printContentTree(node as object, depth = 0 as integer)
    if node = invalid then return

    indent = string(depth * 2, " ")
    label = node.title
    if label = invalid then label = "(untitled)"
    print indent ; label

    for each child in node.getChildren(-1, 0)
        printContentTree(child, depth + 1)
    end for
end sub

' The root carries the heading "Movies" so the printout has a top label.
function buildMovieContent(movies as object) as object
    root = createObject("roSGNode", "ContentNode")
    root.title = "Movies"

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
