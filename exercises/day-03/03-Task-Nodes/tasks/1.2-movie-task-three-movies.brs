' Day 3 / 03 / Exercise 4 — Three hard-coded ContentNode children
'
' Same Task shell as 1.1; only loadMovies() changes.
'
' Target tree:
'
'   (root)
'   ├── Interstellar
'   ├── Inception
'   └── Oppenheimer
'
' Expected: onMoviesLoaded prints child count = 3

sub init()
    m.top.functionName = "loadMovies"
    print "[3.1] MovieTask init (three-movies build)"
end sub

function loadMovies() as void
    print "[3.1] loadMovies running on Task thread"

    content = createObject("roSGNode", "ContentNode")

    titles = ["Interstellar", "Inception", "Oppenheimer"]
    for each title in titles
        movie = createObject("roSGNode", "ContentNode")
        movie.title = title
        content.appendChild(movie)
    end for

    print "[3.1] publishing content (" ; content.getChildCount() ; " children)"
    m.top.content = content
end function
