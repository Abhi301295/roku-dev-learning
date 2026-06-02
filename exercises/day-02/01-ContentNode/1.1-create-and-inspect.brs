' Day 2 / 1.1 — Create and inspect a ContentNode
'
' ContentNode is Roku's generic data carrier for SceneGraph. Grids, rows,
' and the Video node all read their data from a tree of ContentNode
' objects, not from plain associative arrays (AAs).
'
' A ContentNode is an roSGNode of subtype "ContentNode":
'   createObject("roSGNode", "ContentNode")   ' the only way to make one
'
' BrightScript                                  JavaScript / DOM equivalent              Notes
' --------------------------------------------  ----------------------------------------- --------------------------
' createObject("roSGNode", "ContentNode")      document.createElement("div")             "make a fresh node"
' node.title = "Inception"                     node.dataset.title = "Inception"          set a built-in field
' node.title                                   node.dataset.title                        read it back
' type(node)                                   typeof node                               BRS returns "roSGNode"
' node.subtype()                               node.tagName                              "ContentNode" / "DIV"
' { title: "x" }                               { title: "x" }                            AA: data only, NO grid will
'                                                                                        render it
' createObject("roSGNode","ContentNode")       new HTMLElement()                         Node: has identity + fields
'                                                                                        the framework can observe
'
' Why ContentNode (not just an AA)?
'   - MarkupGrid / RowList / Video read their `content` field as a Node
'     tree. They will NOT accept an AA.
'   - Nodes have a stable identity (roSGNode), observable fields, and a
'     parent/child tree. AAs are pure data.
'
' Run: brs 1.1-create-and-inspect.brs
sub Main()
    node = createObject("roSGNode", "ContentNode")

    ' type() returns "roSGNode" on a real Roku device and "Node" in the
    ' `brs` CLI. subtype() is consistent in both: "ContentNode".
    print "type     = " ; type(node)        ' roSGNode (device) / Node (brs CLI)
    print "subtype  = " ; node.subtype()    ' ContentNode

    ' Built-in fields can be set with dot syntax just like an AA.
    node.title = "Inception"
    node.description = "Rating 8.8"

    print "title    = " ; node.title
    print "desc     = " ; node.description

    ' Compare with a plain AA. Looks similar, but it is NOT a Node:
    aa = { title: "Inception", description: "Rating 8.8" }
    print "aa type  = " ; type(aa)          ' roAssociativeArray (both device + brs CLI)
    print "aa title = " ; aa.title
end sub
