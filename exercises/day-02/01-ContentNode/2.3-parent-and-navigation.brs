' Day 2 / 2.3 — Parent references and navigating a two-level tree
'
' RowList (and most "row of rows" layouts) needs a two-level ContentNode
' tree:
'
'   root                          <- m.rowList.content
'   ├── row "Trending"
'   │   ├── movie A
'   │   ├── movie B
'   │   └── movie C
'   ├── row "Sci-Fi"
'   │   ├── movie D
'   │   └── movie E
'   └── row "Recently Added"
'       └── movie F
'
' The row node uses its own `title` for the section label; its children
' become the cells in that row.
'
' BrightScript                              JavaScript / DOM equivalent       Notes
' ----------------------------------------  -------------------------------- ------------------------
' child.getParent()                         child.parentNode                  walk up one level
' parent.getChildren(-1, 0)                 [...parent.childNodes]            all children
' parent.getChildCount()                    parent.childNodes.length          fan-out
' for each row in root.getChildren(-1, 0)   for (const row of root.children)  outer loop
'   for each item in row.getChildren(...)     for (const it of row.children)  inner loop
'
' Run: brs 2.3-parent-and-navigation.brs
sub Main()
    rows = [
        { title: "Trending",       items: ["Inception", "Interstellar", "Tenet"] }
        { title: "Sci-Fi",         items: ["Oppenheimer", "Dunkirk"] }
        { title: "Recently Added", items: ["The Prestige"] }
    ]

    root = buildRowList(rows)

    print "row count = " ; root.getChildCount()                     ' 3
    print "total items = " ; countLeaves(root)                      ' 6
    print ""

    ' Walk the whole tree, two levels deep.
    print "--- full tree ---"
    for each row in root.getChildren(-1, 0)
        print row.title ; "  (" ; row.getChildCount() ; " items)"
        for each item in row.getChildren(-1, 0)
            print "    - " ; item.title
        end for
    end for

    ' Parent reference: from a leaf, walk back up to its row, then to the root.
    print ""
    leaf = root.getChild(1).getChild(0)                             ' "Oppenheimer"
    print "leaf            = " ; leaf.title
    print "leaf.parent     = " ; leaf.getParent().title             ' "Sci-Fi"
    print "leaf.parent.parent has parent? " ; (leaf.getParent().getParent() <> invalid)
    print "root parent     = " ; (root.getParent() = invalid)       ' true; root has no parent
end sub

' Two-level builder. `rows` is an AA list { title, items: [titleStrings] }.
function buildRowList(rows as object) as object
    root = createObject("roSGNode", "ContentNode")

    for each rowData in rows
        row = createObject("roSGNode", "ContentNode")
        row.title = rowData.title                                   ' section header

        for each itemTitle in rowData.items
            item = createObject("roSGNode", "ContentNode")
            item.title = itemTitle
            row.appendChild(item)
        end for

        root.appendChild(row)
    end for

    return root
end function

' Count leaves (cards) across all rows. Same shape as walking the tree.
function countLeaves(root as object) as integer
    total = 0
    for each row in root.getChildren(-1, 0)
        total = total + row.getChildCount()
    end for
    return total
end function
