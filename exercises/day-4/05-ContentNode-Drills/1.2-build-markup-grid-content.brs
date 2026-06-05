' Day 4 / 05 / Drill 1.2 — MarkupGrid content tree (brs CLI)
'
' Builds the flat tree that backs Exercise 2's MarkupGrid: one child per
' movie, each carrying `title` plus a poster URL (the fields the grid's
' item component reads). Still one level deep — a MarkupGrid is a flat
' grid, the difference from a LabelList is the richer item component, not
' the tree shape.
'
' Run: brs 1.2-build-markup-grid-content.brs
'
' Expected output:
'   grid children = 5
'   - Interstellar   poster=https://picsum.photos/seed/interstellar/200/260
'   - Inception      poster=https://picsum.photos/seed/inception/200/260
'   ...
sub Main()
    movies = ["Interstellar", "Inception", "Oppenheimer", "Dunkirk", "Tenet"]

    root = buildGridContent(movies)

    print "grid children = " ; root.getChildCount()
    for each child in root.getChildren(-1, 0)
        print "- " ; child.title ; "   poster=" ; child.hdGridPosterUrl
    end for
end sub

function buildGridContent(titles as object) as object
    root = createObject("roSGNode", "ContentNode")
    for each title in titles
        item = createObject("roSGNode", "ContentNode")
        item.title = title
        poster = "https://picsum.photos/seed/" + LCase(title) + "/200/260"
        item.hdGridPosterUrl = poster
        item.hdPosterUrl = poster
        root.appendChild(item)
    end for
    return root
end function
