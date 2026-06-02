' Day 2 / 3.2 — Build a RowList content tree (rows of rows)
'
' RowList is the "Netflix-style" layout: a vertical stack of horizontal
' rows. Its content is a TWO-LEVEL ContentNode tree:
'
'   root                             <- rowList.content
'   ├── row "Trending"               <- row.title becomes the section label
'   │   ├── movie card               <- one cell in the row
'   │   ├── movie card
'   │   └── ...
'   ├── row "Sci-Fi"
'   │   └── ...
'   └── row "Recently Added"
'       └── ...
'
' This is the same shape as 2.3, but now the leaf nodes carry the real
' card fields (title, hdPosterUrl, description) that the per-item
' component will read.
'
' BrightScript                                  JavaScript / React equivalent       Notes
' --------------------------------------------  ----------------------------------- ------------------------
' root.appendChild(row)                         <RowList>{rows.map(...)}            outer level
' row.title = "Trending"                        <Row label="Trending">              section header
' row.appendChild(card)                           {items.map(<Card />)}             inner level
'
' Run: brs 3.2-row-list-content.brs
sub Main()
    catalogue = [
        {
            title: "Trending"
            items: [
                { title: "Inception",    rating: 8.8, posterUri: "https://picsum.photos/seed/inception/240/320" }
                { title: "Interstellar", rating: 8.6, posterUri: "https://picsum.photos/seed/interstellar/240/320" }
                { title: "Tenet",        rating: 7.4, posterUri: "https://picsum.photos/seed/tenet/240/320" }
            ]
        }
        {
            title: "Sci-Fi"
            items: [
                { title: "Oppenheimer",  rating: 8.3, posterUri: "https://picsum.photos/seed/oppenheimer/240/320" }
                { title: "Interstellar", rating: 8.6, posterUri: "https://picsum.photos/seed/interstellar/240/320" }
            ]
        }
        {
            title: "Recently Added"
            items: [
                { title: "The Prestige", rating: 8.5, posterUri: "https://picsum.photos/seed/prestige/240/320" }
            ]
        }
    ]

    listContent = buildRowListContent(catalogue)

    print "row count = " ; listContent.getChildCount()
    print ""
    for each row in listContent.getChildren(-1, 0)
        print row.title ; "  (" ; row.getChildCount() ; ")"
        for each card in row.getChildren(-1, 0)
            print "    - " ; card.title ; "   " ; card.description
        end for
    end for

    ' In a real component:
    '   m.rowList.content = listContent
end sub

' Outer loop builds rows; inner loop builds the cards inside each row.
function buildRowListContent(catalogue as object) as object
    root = createObject("roSGNode", "ContentNode")

    for each section in catalogue
        row = createObject("roSGNode", "ContentNode")
        row.title = section.title

        for each movie in section.items
            row.appendChild(buildCard(movie))
        end for

        root.appendChild(row)
    end for

    return root
end function

' Same per-card shape as 3.1. Kept as a helper so 3.4 can reuse it.
function buildCard(movie as object) as object
    card = createObject("roSGNode", "ContentNode")
    card.title       = movie.title
    card.hdPosterUrl = movie.posterUri
    card.description = "Rating " + movie.rating.ToStr()
    return card
end function
