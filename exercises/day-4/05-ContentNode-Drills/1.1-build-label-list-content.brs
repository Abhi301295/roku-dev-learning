' Day 4 / 05 / Drill 1.1 — LabelList content tree (brs CLI)
'
' Builds the flat ContentNode tree that backs Exercise 1's LabelList.
' A LabelList reads each child's `title` for the row text, so the tree
' is one level deep: root -> one child per category.
'
'   Categories
'   ├── Movies
'   ├── TV Shows
'   ├── Sports
'   └── Kids
'
' In the scene the only extra line is:  m.labelList.content = root
'
' Run: brs 1.1-build-label-list-content.brs
'
' Expected output:
'   label count = 4
'   - Movies
'   - TV Shows
'   - Sports
'   - Kids
sub Main()
    categories = ["Movies", "TV Shows", "Sports", "Kids"]

    root = buildCategoryContent(categories)

    print "label count = " ; root.getChildCount()
    for each child in root.getChildren(-1, 0)
        print "- " ; child.title
    end for
end sub

function buildCategoryContent(names as object) as object
    root = createObject("roSGNode", "ContentNode")
    for each name in names
        item = createObject("roSGNode", "ContentNode")
        item.title = name
        root.appendChild(item)
    end for
    return root
end function
