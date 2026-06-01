' Day 1 / 6 — function vs sub
'
' BrightScript has two routine types:
'   - sub      : performs an action; does NOT return a value
'   - function : computes and returns a value
' Calling convention is the same: name(arg1, arg2). Subs simply ignore returns.
'
' Run: brs functions-vs-subs.brs
sub Main()
    movie = {
        title: "Interstellar"
        year: 2014
    }
    platforms = [
        {
            name: "Netflix"
            subscribers: 300
        }


        {
            name: "Prime"
            subscribers: 200
        }
    ]
    print getMovieTitle(movie)
    greet("Abhishek")

    total = add(2, 3)
    print "add(2, 3) = "; total

    add(10, 20)

    result = greet("Roku")
    print "greet returned: "; result ' invalid
end sub

sub greet(name as string)
    print "Hello, "; name
end sub

function add(a as integer, b as integer) as integer
    return a + b
end function

function getMovieTitle(movie as object) as string
    return movie.title
end function
