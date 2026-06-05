' Day 4 / 01 / Exercise 1 — Categories in a LabelList (BrightScript half)
'
' Paired with 1.1-categories-scene.xml.
'
' The whole job of this Scene:
'
'   1. Build a flat ContentNode tree — one child per category, each with
'      a `title`. LabelList reads `title` for the row text.
'   2. Assign that tree to m.categoryList.content. THAT assignment is the
'      render trigger (Roku's equivalent of React setState).
'   3. Observe the two fields every focusable list publishes:
'        itemFocused   -> index of the highlighted row (changes on scroll)
'        itemSelected  -> index pressed OK on (changes only on select)
'   4. Give the list focus so the remote drives it.
'
' BrightScript / SceneGraph                     React / DOM equivalent
' -------------------------------------------   ----------------------------------
' root.appendChild(item); item.title = name     categories.map(c => <MenuItem .../>)
' m.categoryList.content = root                 setItems(categories)
' observeField("itemFocused", ...)              onMouseEnter / focus handler
' observeField("itemSelected", ...)             onClick handler
'
' Expected console:
'   [4.1] CategoriesScene init; 4 categories bound
'   [4.1] focus -> 0   (Movies)        (as you scroll)
'   [4.1] selected -> 1   (TV Shows)   (when you press OK)

sub init()
    m.categoryList = m.top.findNode("categoryList")
    m.statusLabel = m.top.findNode("statusLabel")

    ' Keep a plain-array copy alongside the node tree. The observers get
    ' an integer index, and reading m.categories[idx] is cheaper and
    ' clearer than walking the ContentNode children every time.
    m.categories = ["Movies", "TV Shows", "Sports", "Kids"]

    m.categoryList.content = buildCategoryContent(m.categories)

    m.categoryList.observeField("itemFocused", "onCategoryFocused")
    m.categoryList.observeField("itemSelected", "onCategorySelected")

    print "[4.1] CategoriesScene init; " ; m.categories.count() ; " categories bound"

    m.categoryList.setFocus(true)
end sub

' Build a flat ContentNode tree: one child per category name.
' LabelList renders root's CHILDREN, not root itself — each child's
' `title` becomes the row text.
function buildCategoryContent(names as object) as object
    root = createObject("roSGNode", "ContentNode")
    for each name in names
        item = createObject("roSGNode", "ContentNode")
        item.title = name
        root.appendChild(item)
    end for
    return root
end function

' itemFocused fires constantly while the user scrolls. Keep this cheap:
' no network, no tree rebuilds. Here we just log and update a label.
sub onCategoryFocused(event as object)
    idx = event.getData()
    if idx < 0 or idx >= m.categories.count() then return
    print "[4.1] focus -> " ; idx ; "   (" ; m.categories[idx] ; ")"
end sub

' itemSelected fires once per OK press, after focus has settled.
sub onCategorySelected(event as object)
    idx = event.getData()
    if idx < 0 or idx >= m.categories.count() then return
    name = m.categories[idx]
    print "[4.1] selected -> " ; idx ; "   (" ; name ; ")"
    m.statusLabel.text = "Selected: " + name
end sub
