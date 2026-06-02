' Day 2 / 3.1 — Build a MarkupGrid content tree from a movies AA
'
' This is the exact pattern used by MainScene.populateGrid() in the
' actual channel (`components/MainScene.brs`). The grid does the
' rendering; our job is to hand it a ContentNode whose children carry
' the fields the per-item component (MovieCard) wants to read.
'
' MovieCard reads three fields per item:
'   itemContent.title          shown under the poster
'   itemContent.hdPosterUrl    the poster image
'   itemContent.description    rating line ("Rating 8.8")
'
' BrightScript                                  JavaScript / React equivalent       Notes
' --------------------------------------------  ----------------------------------- ------------------------
' root = createObject("roSGNode","ContentNode") <ItemList>                          the "list"  wrapper
' for each movie in movies                      movies.map(movie => (...))          map data -> nodes
' item.title = movie.title                      <Item title={movie.title} />        per-item props
' root.appendChild(item)                          )                                 collected children
' m.grid.content = root                         setContent(root)                    hand to the framework
'
' Run: brs 3.1-markup-grid-content.brs
sub Main()
    movies = [
        { title: "Inception",    rating: 8.8, posterUri: "https://picsum.photos/seed/inception/240/320" }
        { title: "Interstellar", rating: 8.6, posterUri: "https://picsum.photos/seed/interstellar/240/320" }
        { title: "Tenet",        rating: 7.4, posterUri: "https://picsum.photos/seed/tenet/240/320" }
        { title: "Oppenheimer",  rating: 8.3, posterUri: "https://picsum.photos/seed/oppenheimer/240/320" }
    ]

    gridContent = buildGridContent(movies)

    print "grid children = " ; gridContent.getChildCount()
    print ""
    for each card in gridContent.getChildren(-1, 0)
        print "- " ; card.title
        print "    poster = " ; card.hdPosterUrl
        print "    line2  = " ; card.description
    end for

    ' In a real component you would just do:
    '   m.grid.content = gridContent
end sub

' Mirror of MainScene.populateGrid:
'   creates one ContentNode per movie and sets the three fields MovieCard
'   reads. The root wrapper exists ONLY so the grid has something whose
'   children it can render.
function buildGridContent(movies as object) as object
    root = createObject("roSGNode", "ContentNode")

    for each movie in movies
        card = createObject("roSGNode", "ContentNode")
        card.title       = movie.title
        card.hdPosterUrl = movie.posterUri
        card.description = "Rating " + movie.rating.ToStr()
        root.appendChild(card)
    end for

    return root
end function
