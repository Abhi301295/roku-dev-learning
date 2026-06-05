' Day 4 / 06 / Topic 1 — Focus System (BrightScript half)
'
' Paired with 1.1-focus-basics-scene.xml.
'
' Roku focus in two API calls:
'
'   node.setFocus(true)   give this node the remote
'   node.hasFocus()       returns true if this node currently has focus
'
' Only ONE node in the scene tree holds focus at a time. Lists like
' LabelList handle UP/DOWN internally once they have focus. Moving
' focus BETWEEN siblings (listA <-> listB) is YOUR job — usually via
' onKeyEvent, as shown here.
'
' Expected console:
'   [4.6] FocusBasicsScene init
'   [4.6] listA.hasFocus() = true
'   [4.6] listB.hasFocus() = false
'   [4.6] moved focus -> listB
'   [4.6] listA.hasFocus() = false
'   [4.6] listB.hasFocus() = true

sub init()
    m.listA = m.top.findNode("listA")
    m.listB = m.top.findNode("listB")
    m.statusLabel = m.top.findNode("statusLabel")

    m.listA.content = buildListContent(["Alpha", "Beta", "Gamma"])
    m.listB.content = buildListContent(["One", "Two", "Three"])

    m.listA.setFocus(true)
    printFocusState("init")

    m.statusLabel.text = "Focus is on list A"
end sub

function buildListContent(labels as object) as object
    root = createObject("roSGNode", "ContentNode")
    for each label in labels
        item = createObject("roSGNode", "ContentNode")
        item.title = label
        root.appendChild(item)
    end for
    return root
end function

sub printFocusState(tag as string)
    print "[4.6] " ; tag
    print "[4.6] listA.hasFocus() = " ; m.listA.hasFocus()
    print "[4.6] listB.hasFocus() = " ; m.listB.hasFocus()
end sub

' Move focus between the two lists at the horizontal edges.
' Return true to tell SceneGraph "I handled this key."
function onKeyEvent(key as string, press as boolean) as boolean
    if not press then return false

    if key = "right" and m.listA.hasFocus() then
        m.listB.setFocus(true)
        print "[4.6] moved focus -> listB"
        printFocusState("after RIGHT")
        m.statusLabel.text = "Focus is on list B"
        return true
    end if

    if key = "left" and m.listB.hasFocus() then
        m.listA.setFocus(true)
        print "[4.6] moved focus -> listA"
        printFocusState("after LEFT")
        m.statusLabel.text = "Focus is on list A"
        return true
    end if

    return false
end function
