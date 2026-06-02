' Day 2 / 2.2 — Mutating a ContentNode tree: insert, remove, replace
'
' Once a grid is rendered, the cheapest way to update it is usually:
'   - rebuild the whole content tree and reassign grid.content (covered
'     in Section 3).
' But sometimes you want surgical edits: append a "load more" page, drop
' a single item, swap a placeholder for the real card.
'
' BrightScript                                  JavaScript / DOM equivalent       Notes
' --------------------------------------------  -------------------------------- ------------------------
' parent.appendChild(child)                     parent.appendChild(child)         add at the end
' parent.insertChild(child, idx)                parent.insertBefore(child, ref)   insert at index (idx >=
'                                                                                 count means append)
' parent.removeChild(child)                     parent.removeChild(child)         remove by reference
' parent.removeChildIndex(idx)                  parent.children[idx].remove()     remove by index
' parent.removeChildren([n1, n2, ...])          [n1, n2].forEach(n => n.remove()) batch remove
' parent.replaceChild(newNode, idx)             parent.replaceChild(new, old)     swap at index
' parent.appendChildren(arr)                    arr.forEach(parent.appendChild)   batch append
'
' Important: each ContentNode has exactly ONE parent. appendChild moves
' the node if it already has a parent — it does not copy it. The DOM
' behaves the same way.
'
' Run: brs 2.2-insert-remove-replace.brs
sub Main()
    root = createObject("roSGNode", "ContentNode")
    appendTitles(root, ["A", "B", "C", "D"])
    printTree("start", root)                            ' A B C D

    ' insertChild at index 1 -> ends up between A and B.
    inserted = createObject("roSGNode", "ContentNode")
    inserted.title = "A.5"
    root.insertChild(inserted, 1)
    printTree("after insert A.5 at 1", root)            ' A A.5 B C D

    ' removeChildIndex(0) -> drop A.
    root.removeChildIndex(0)
    printTree("after remove idx 0", root)               ' A.5 B C D

    ' removeChild by reference -> drop the node holding "C".
    cNode = findChildByTitle(root, "C")
    root.removeChild(cNode)
    printTree("after remove 'C'", root)                 ' A.5 B D

    ' replaceChild at index 0 with a fresh node.
    replacement = createObject("roSGNode", "ContentNode")
    replacement.title = "A.5*"
    root.replaceChild(replacement, 0)
    printTree("after replace idx 0", root)              ' A.5* B D

    ' Batch append.
    extras = [makeTitleNode("E"), makeTitleNode("F")]
    root.appendChildren(extras)
    printTree("after appendChildren E,F", root)         ' A.5* B D E F

    ' Batch remove.
    toRemove = [findChildByTitle(root, "B"), findChildByTitle(root, "E")]
    root.removeChildren(toRemove)
    printTree("after removeChildren B,E", root)         ' A.5* D F
end sub

sub appendTitles(parent as object, titles as object)
    for each t in titles
        parent.appendChild(makeTitleNode(t))
    end for
end sub

function makeTitleNode(t as string) as object
    n = createObject("roSGNode", "ContentNode")
    n.title = t
    return n
end function

function findChildByTitle(parent as object, t as string) as object
    for each child in parent.getChildren(-1, 0)
        if child.title = t then return child
    end for
    return invalid
end function

sub printTree(label as string, root as object)
    titles = ""
    for each child in root.getChildren(-1, 0)
        if Len(titles) > 0 then titles = titles + " "
        titles = titles + child.title
    end for
    print "[" ; label ; "] count=" ; root.getChildCount() ; "  -> " ; titles
end sub
