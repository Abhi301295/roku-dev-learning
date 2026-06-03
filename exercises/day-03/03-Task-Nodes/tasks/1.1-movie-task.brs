' Day 3 / 03 / Exercise 1 — MovieTask worker (BrightScript half)
'
' Paired with 1.1-movie-task.xml.
'
' Lifecycle (the whole pattern in four lines):
'
'   Scene:  m.movieTask.observeField("content", "onMoviesLoaded")
'   Scene:  m.movieTask.control = "RUN"
'   Task:   loadMovies() runs on the worker thread
'   Task:   m.top.content = tree   -> observer fires on render thread
'
' React equivalent:
'
'   useEffect(() => { fetchMovies().then(setMovies) }, [])
'
' This first version returns ONE movie so Exercise 3 can assert
' getChildCount() = 1. Exercises 4 and 5 replace loadMovies() in
' 1.2-movie-task-three-movies.brs and 1.3-movie-task-from-array.brs.
'
' Expected console (with 2.1-home-scene):
'   [3.1] MovieTask init; functionName = loadMovies
'   [3.1] loadMovies running on Task thread
'   [3.1] publishing content (1 child)
'   [3.1] onMoviesLoaded; child count = 1

sub init()
    m.top.functionName = "loadMovies"
    print "[3.1] MovieTask init; functionName = " ; m.top.functionName
end sub

' Runs on the Task thread when the Scene sets control = "RUN".
' Never touch UI nodes from here — only build data and publish it.
function loadMovies() as void
    print "[3.1] loadMovies running on Task thread"

    content = createObject("roSGNode", "ContentNode")

    movie = createObject("roSGNode", "ContentNode")
    movie.title = "Interstellar"
    content.appendChild(movie)

    print "[3.1] publishing content (" ; content.getChildCount() ; " child)"
    m.top.content = content
end function
