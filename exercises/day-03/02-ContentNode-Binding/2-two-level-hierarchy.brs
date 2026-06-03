' Day 3 / 02 / Exercise 4 — Two-level hierarchy (the RowList shape)
'
' This is the important one. A flat list is fine for a single grid, but the
' Netflix-style "rows of cards" screen is a TWO-LEVEL ContentNode tree:
'
'   Movies
'    |-- Sci-Fi
'    |    |-- Interstellar
'    |    \-- Inception
'    |
'    \-- Drama
'         \-- Oppenheimer
'
' Level 1 children (Sci-Fi, Drama) become the ROWS (their title is the
' section header). Level 2 children (the movies) become the CARDS inside
' each row. Built entirely from real nodes:
'
'   createObject("roSGNode", "ContentNode")
'
' ...no custom class, because the SceneGraph UI only consumes ContentNode
' trees. A custom BrightScript class would never bind to a RowList.
'
' BrightScript                                  React equivalent                 Notes
' --------------------------------------------  -------------------------------- ------------------------
' root.appendChild(genreNode)                   <RowList>{genres.map(...)}        outer level => rows
' genreNode.title = "Sci-Fi"                     <Row label="Sci-Fi">             section header
' genreNode.appendChild(movieNode)                {movies.map(<Card />)}          inner level => cards
'
' Run: brs 2-two-level-hierarchy.brs
sub Main()
    catalogue = [
        {
            genre: "Sci-Fi"
            movies: [
                { title: "Interstellar", rating: 8.6, year: 2014 }
                { title: "Inception",    rating: 8.8, year: 2010 }
            ]
        }
        {
            genre: "Drama"
            movies: [
                { title: "Oppenheimer", rating: 8.3, year: 2023 }
            ]
        }
    ]

    root = buildGenreContent(catalogue)

    print "genre (row) count = " ; root.getChildCount()      ' 2
    print ""
    printContentTree(root)

    ' The whole point — in a real RowList component this single line makes
    ' the UI render every row and every card automatically:
    '
    '   m.rowList.content = root
    '
    ' That is Roku's equivalent of React's setMovies(data) triggering a
    ' re-render. Assigning `.content` IS the render trigger.
end sub

' Exercise 4: build the two-level tree.
'   outer loop -> one ContentNode per genre (a row)
'   inner loop -> one ContentNode per movie (a card) appended to its genre
function buildGenreContent(catalogue as object) as object
    root = createObject("roSGNode", "ContentNode")
    root.title = "Movies"

    for each section in catalogue
        genreNode = createObject("roSGNode", "ContentNode")
        genreNode.title = section.genre

        for each movie in section.movies
            genreNode.appendChild(buildMovieNode(movie))
        end for

        root.appendChild(genreNode)
    end for

    return root
end function

' One movie card: built-in title + custom rating/year fields.
function buildMovieNode(movie as object) as object
    movieNode = createObject("roSGNode", "ContentNode")
    movieNode.title = movie.title
    movieNode.addField("imdbRating", "float", true)
    movieNode.addField("year", "integer", true)
    movieNode.imdbRating = movie.rating
    movieNode.year = movie.year
    return movieNode
end function

' Same depth-first printer from Exercise 3 — proves the hierarchy is real.
sub printContentTree(node as object, depth = 0 as integer)
    if node = invalid then return
    indent = string(depth * 2, " ")
    label = node.title
    if label = invalid then label = "(untitled)"
    print indent ; label
    for each child in node.getChildren(-1, 0)
        printContentTree(child, depth + 1)
    end for
end sub
