' Day 4 / 05 / Drill 1.3 — RowList content tree (brs CLI)
'
' Builds the TWO-LEVEL tree that backs Exercise 3's RowList — the only
' shape on Day 4 that is deeper than one level:
'
'   Home                  root  (rowList.content)
'    ├── Trending          row node  (title = section header)
'    │    ├── Interstellar  card node
'    │    └── Inception
'    └── Sci-Fi
'         ├── Arrival
'         └── Dune
'
' Level-1 children are ROWS; level-2 children are the CARDS in each row.
' printContentTree proves the hierarchy before any UI is involved.
'
' Run: brs 1.3-build-rowlist-content.brs
'
' Expected output:
'   row count = 2
'
'   Home
'     Trending
'       Interstellar
'       Inception
'     Sci-Fi
'       Arrival
'       Dune
sub Main()
    sections = [
        { name: "Trending", movies: ["Interstellar", "Inception"] }
        { name: "Sci-Fi",   movies: ["Arrival", "Dune"] }
    ]

    root = buildHomeRowsContent(sections)

    print "row count = " ; root.getChildCount()
    print ""
    printContentTree(root)
end sub

function buildHomeRowsContent(sections as object) as object
    root = createObject("roSGNode", "ContentNode")
    root.title = "Home"

    for each section in sections
        rowNode = createObject("roSGNode", "ContentNode")
        rowNode.title = section.name

        for each movieTitle in section.movies
            card = createObject("roSGNode", "ContentNode")
            card.title = movieTitle
            rowNode.appendChild(card)
        end for

        root.appendChild(rowNode)
    end for

    return root
end function

' Depth-first printer: indents two spaces per level so the tree shape is
' visible at a glance. Same helper used across Day 3 / 02.
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
