' Day 4 / 02 / Exercise 2 — Nolan movies in a MarkupGrid (BrightScript half)
'
' Paired with 2.1-nolan-movies-scene.xml.
'
' The pattern is identical to LabelList, only the item component is
' richer. We:
'
'   1. Build a flat ContentNode tree, one child per movie. We set the
'      fields StandardGridItemComponent reads: title + hdGridPosterUrl.
'   2. Assign it to m.movieGrid.content (the render trigger).
'   3. Give the grid focus.
'
' This is the exact shape of MainScene.populateGrid() in the real
' channel, just with the built-in item component instead of MovieCard.
'
'   movies.map(m => <Card poster={m} title={m.title} />)   (React)
'   for each movie: item.title = ... ; root.appendChild(item)  (here)
'
' Expected console:
'   [4.2] NolanGridScene init; grid children = 5
'   [4.2]   - Interstellar
'   [4.2]   - Inception
'   [4.2]   - Oppenheimer
'   [4.2]   - Dunkirk
'   [4.2]   - Tenet

sub init()
    m.movieGrid = m.top.findNode("movieGrid")
    m.statusLabel = m.top.findNode("statusLabel")

    movies = [
        { title: "Interstellar", year: 2014 }
        { title: "Inception",    year: 2010 }
        { title: "Oppenheimer",  year: 2023 }
        { title: "Dunkirk",      year: 2017 }
        { title: "Tenet",        year: 2020 }
    ]

    content = buildGridContent(movies)
    m.movieGrid.content = content

    print "[4.2] NolanGridScene init; grid children = " ; content.getChildCount()
    for each child in content.getChildren(-1, 0)
        print "[4.2]   - " ; child.title
    end for

    m.statusLabel.text = "Use left/right to browse"
    m.movieGrid.setFocus(true)
end sub

' One ContentNode per movie. StandardGridItemComponent reads `title` and
' a poster URL field; we use a deterministic placeholder image per title
' so the grid shows real artwork in the simulator.
function buildGridContent(movies as object) as object
    root = createObject("roSGNode", "ContentNode")
    for each movie in movies
        item = createObject("roSGNode", "ContentNode")
        item.title = movie.title

        ' hdGridPosterUrl is the field StandardGridItemComponent prefers
        ' for grid artwork; set the generic hdPosterUrl too for safety.
        seed = LCase(movie.title)
        poster = "https://picsum.photos/seed/" + seed + "/200/260"
        item.hdGridPosterUrl = poster
        item.hdPosterUrl = poster

        ' year isn't a built-in ContentNode field; declare before setting.
        item.addField("year", "integer", false)
        item.year = movie.year

        root.appendChild(item)
    end for
    return root
end function
