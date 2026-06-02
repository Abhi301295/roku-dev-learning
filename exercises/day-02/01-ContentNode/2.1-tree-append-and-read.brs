' Day 2 / 2.1 — Building a ContentNode tree: appendChild + read back
'
' A grid does not display one ContentNode — it displays the CHILDREN of
' the ContentNode you assign to `grid.content`. So every grid feed looks
' like:
'
'   root                       <- m.grid.content
'   ├── item                   <- one MovieCard
'   ├── item
'   ├── item
'   └── ...
'
' Building that tree is just appendChild in a loop, exactly like the DOM.
'
' BrightScript                              JavaScript / DOM equivalent       Notes
' ----------------------------------------  -------------------------------- -------------------------
' parent.appendChild(child)                 parent.appendChild(child)         same name, same behaviour
' parent.getChildCount()                    parent.childNodes.length          how many children
' parent.getChild(i)                        parent.childNodes[i]              ith child (0-based)
' parent.getChildren(-1, 0)                 Array.from(parent.childNodes)     all children as an array
' parent.getChildren(2, 1)                  Array.from(...).slice(1, 1+2)     count, startIndex
' for each c in parent.getChildren(-1, 0)   for (const c of node.childNodes)  iterate
'
' getChildren(num, idx):
'   num   how many to return (-1 means "all from idx onwards")
'   idx   starting index (0-based)
'
' Run: brs 2.1-tree-append-and-read.brs
sub Main()
    movies = [
        { title: "Inception",    rating: 8.8 }
        { title: "Interstellar", rating: 8.6 }
        { title: "Tenet",        rating: 7.4 }
        { title: "Oppenheimer",  rating: 8.3 }
    ]

    root = buildRoot(movies)

    print "child count = " ; root.getChildCount()        ' 4

    ' Read individual children by index.
    print "first  = " ; root.getChild(0).title           ' Inception
    print "last   = " ; root.getChild(root.getChildCount() - 1).title

    ' Iterate every child. getChildren(-1, 0) returns an roArray of nodes.
    print ""
    print "--- iterate all ---"
    for each child in root.getChildren(-1, 0)
        print "- " ; child.title ; "   " ; child.description
    end for

    ' Slice: take 2 children starting at index 1.
    print ""
    print "--- middle slice (2 from idx 1) ---"
    for each child in root.getChildren(2, 1)
        print "- " ; child.title
    end for

    ' Out-of-range getChild returns invalid (it does NOT throw).
    missing = root.getChild(99)
    print ""
    print "out-of-range = " ; missing                    ' invalid
end sub

' Standard "AA list -> ContentNode tree" pattern used by every grid feed.
function buildRoot(movies as object) as object
    root = createObject("roSGNode", "ContentNode")
    for each movie in movies
        item = createObject("roSGNode", "ContentNode")
        item.title = movie.title
        item.description = "Rating " + movie.rating.ToStr()
        root.appendChild(item)
    end for
    return root
end function
