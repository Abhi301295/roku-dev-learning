' Day 3 / 03 — MovieTask (test harness on day3-implementation)
'
' Copied from exercises/day-03/03-Task-Nodes/tasks/1.1-movie-task.brs.
' Exercise 1: returns ONE movie so onMoviesLoaded asserts child count = 1.
' To test exercise 4/5, replace this file's loadMovies with the 1.2 / 1.3
' version (or copy those files over this pair).

sub init()
    m.top.functionName = "loadMovies"
    print "[3.1] MovieTask init; functionName = " ; m.top.functionName
end sub

function loadMovies() as void
    print "[3.1] loadMovies running on Task thread"

    content = createObject("roSGNode", "ContentNode")

    movie = createObject("roSGNode", "ContentNode")
    movie.title = "Interstellar"
    content.appendChild(movie)

    print "[3.1] publishing content (" ; content.getChildCount() ; " child)"
    m.top.content = content
end function
