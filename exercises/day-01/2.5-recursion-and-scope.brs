' Day 1 / 10 — Recursion and variable scope
'
' Scope: variables inside a sub/function are local to that routine.
' There is no block scope inside if/for — only routine-level scope.
'
' Run: brs recursion-and-scope.brs
sub Main()
    print "factorial(5) = " + StrI(factorial(5)).Trim()
    print "factorial(7) = " + StrI(factorial(7)).Trim()
    print "fib(10) = " + StrI(fib(10)).Trim()

    x = 1
    helper()
    print "x in Main after helper() = " + StrI(x).Trim()
end sub

function factorial(n as integer) as integer
    if n <= 1 then return 1
    return n * factorial(n - 1)
end function

function fib(n as integer) as integer
    if n < 2 then return n
    return fib(n - 1) + fib(n - 2)
end function

sub helper()
    x = 999
    print "x in helper() = " + StrI(x).Trim()
end sub
