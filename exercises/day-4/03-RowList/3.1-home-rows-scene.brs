' Day 4 / 03 / Exercise 3 — Home rows in a RowList (BrightScript half)
'
' Paired with 3.1-home-rows-scene.xml.
'
' The ONE new idea versus MarkupGrid: the content tree is two levels
' deep. Outer loop builds row nodes; inner loop appends card nodes to
' each row.
'
'   Home                  root
'    ├── Trending          row node  (title = header)
'    │    ├── Interstellar  card node
'    │    └── Inception
'    └── Sci-Fi
'         ├── Arrival
'         └── Dune
'
' React equivalent:
'
'   sections.map(section => (
'     <Row label={section.name}>
'       {section.movies.map(m => <Card key={m} title={m} />)}
'     </Row>
'   ))
'
' RowList focus movement is automatic once content is bound:
'   up / down    -> switch rows
'   left / right -> scroll within the focused row
'
' Expected console:
'   [4.3] HomeRowsScene init
'   [4.3] rows = 2
'   [4.3] row 0 "Trending" -> 2 items
'   [4.3] row 1 "Sci-Fi" -> 2 items

sub init()
    m.rowList = m.top.findNode("rowList")
    m.statusLabel = m.top.findNode("statusLabel")

    sections = [
        { name: "Trending", movies: ["Interstellar", "Inception"] }
        { name: "Sci-Fi",   movies: ["Arrival", "Dune"] }
    ]

    content = buildHomeRowsContent(sections)
    m.rowList.content = content

    print "[4.3] HomeRowsScene init"
    print "[4.3] rows = " ; content.getChildCount()
    rowIndex = 0
    for each row in content.getChildren(-1, 0)
        print "[4.3] row " ; rowIndex ; " " ; chr(34) ; row.title ; chr(34) ; " -> " ; row.getChildCount() ; " items"
        rowIndex = rowIndex + 1
    end for

    m.statusLabel.text = "Up/Down: rows   Left/Right: items"
    m.rowList.setFocus(true)
end sub

' Build the two-level tree.
'   outer loop -> one ContentNode per section (a ROW; title = header)
'   inner loop -> one ContentNode per movie (a CARD) appended to the row
function buildHomeRowsContent(sections as object) as object
    root = createObject("roSGNode", "ContentNode")
    root.title = "Home"

    for each section in sections
        rowNode = createObject("roSGNode", "ContentNode")
        rowNode.title = section.name

        for each movieTitle in section.movies
            rowNode.appendChild(buildCardNode(movieTitle))
        end for

        root.appendChild(rowNode)
    end for

    return root
end function

' One movie card. StandardGridItemComponent reads title + poster URL.
function buildCardNode(movieTitle as string) as object
    card = createObject("roSGNode", "ContentNode")
    card.title = movieTitle

    seed = LCase(movieTitle)
    poster = "https://picsum.photos/seed/" + seed + "/200/260"
    card.hdGridPosterUrl = poster
    card.hdPosterUrl = poster

    return card
end function
