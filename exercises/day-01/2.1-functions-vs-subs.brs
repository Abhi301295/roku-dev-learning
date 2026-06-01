' Day 1 / 6 — function vs sub
'
' BrightScript has two routine types:
'   - sub      : performs an action; does NOT return a value
'   - function : computes and returns a value
' Calling convention is the same: name(arg1, arg2). Subs simply ignore returns.
'
' BrightScript                            JavaScript equivalent                Notes
' --------------------------------------  -----------------------------------  -----------------------
' sub greet(name as string)               function greet(name) { ... }         JS has no sub/function
'   print "Hi, " + name                                                        split — only `function`
' end sub                                                                      (or arrow `=>`)
'
' function add(a as integer, b as integer) as integer    function add(a, b) { return a + b }
'   return a + b                                         (TS: function add(a:number,b:number):number{})
' end function
'
' result = greet("x")  ' invalid          const result = greet("x")  // undefined
' total  = add(2, 3)                      const total  = add(2, 3)
' add(10, 20)                             add(10, 20)                          ignore return — same
' print add(2, 3)                         console.log(add(2, 3))
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
    print "Total subscribers: "; getTotalSubscribers(platforms)
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

function getTotalSubscribers(platforms as object) as integer
    total = 0
    for each platform in platforms
        total = total + platform.subscribers
    end for
    return total
end function
