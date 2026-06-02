' Day 2 / 2.4 — Recursive traversal of a ContentNode tree
'
' Two-level trees (RowList) are common, but content trees can go deeper:
' a "category > sub-category > items" menu, an EPG grid, or a folder
' browser. The shape is the same as a DOM walk: visit the current node,
' then recurse into its children.
'
' BrightScript                                  JavaScript / DOM equivalent       Notes
' --------------------------------------------  -------------------------------- ------------------------
' node.getChildren(-1, 0)                       [...node.childNodes]              children as an array
' node.getChildCount()                          node.childNodes.length            leaf check: count == 0
' recurse on each child                         walk(child)                       same pattern
' result.push(node.title)                       result.push(node.tagName)         flatten leaf titles
'
' Two helpers below show the two halves of every tree walk:
'   countNodes(root)    total node count (including the root)
'   findByTitle(root, "X")  depth-first search returning the first match
'   collectTitles(root) flatten every node's title into an array
'
' Run: brs 2.4-recursive-traversal.brs
sub Main()
    root = buildSampleTree()

    print "total nodes        = " ; countNodes(root)
    print "leaf  count        = " ; countLeaves(root)

    print ""
    found = findByTitle(root, "Dunkirk")
    if found = invalid then
        print "Dunkirk not found"
    else
        print "found '" ; found.title ; "' under parent '" ; found.getParent().title ; "'"
    end if

    notThere = findByTitle(root, "Avatar")
    print "Avatar found?      = " ; (notThere <> invalid)

    print ""
    print "--- flat titles ---"
    for each t in collectTitles(root)
        print "- " ; t
    end for
end sub

' Build a 3-level tree to exercise the recursion:
'   Catalogue
'   ├── Sci-Fi
'   │   ├── Mind-bending
'   │   │   ├── Inception
'   │   │   └── Tenet
'   │   └── Space
'   │       └── Interstellar
'   └── War
'       └── Dunkirk
function buildSampleTree() as object
    root = node("Catalogue")

    scifi = node("Sci-Fi")
    root.appendChild(scifi)

    mind = node("Mind-bending")
    scifi.appendChild(mind)
    mind.appendChild(node("Inception"))
    mind.appendChild(node("Tenet"))

    space = node("Space")
    scifi.appendChild(space)
    space.appendChild(node("Interstellar"))

    war = node("War")
    root.appendChild(war)
    war.appendChild(node("Dunkirk"))

    return root
end function

function node(title as string) as object
    n = createObject("roSGNode", "ContentNode")
    n.title = title
    return n
end function

' --- generic recursive helpers ---

' Total nodes in the tree, including the root.
function countNodes(root as object) as integer
    if root = invalid then return 0
    total = 1
    for each child in root.getChildren(-1, 0)
        total = total + countNodes(child)
    end for
    return total
end function

' Leaves only (nodes with no children). Useful for "how many cards
' total" across a RowList-style tree.
function countLeaves(root as object) as integer
    if root = invalid then return 0
    if root.getChildCount() = 0 then return 1
    total = 0
    for each child in root.getChildren(-1, 0)
        total = total + countLeaves(child)
    end for
    return total
end function

' Depth-first search by title. Returns the first match, or invalid.
function findByTitle(root as object, target as string) as object
    if root = invalid then return invalid
    if root.title = target then return root

    for each child in root.getChildren(-1, 0)
        match = findByTitle(child, target)
        if match <> invalid then return match
    end for
    return invalid
end function

' Flatten every node's title into a single array, root first, then DFS.
function collectTitles(root as object) as object
    out = []
    walk(root, out)
    return out
end function

sub walk(n as object, out as object)
    if n = invalid then return
    out.push(n.title)
    for each child in n.getChildren(-1, 0)
        walk(child, out)
    end for
end sub
