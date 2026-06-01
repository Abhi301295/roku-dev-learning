' Day 1 / 8 — Return types
'
' Functions can declare what they return:
'   as integer / as string / as boolean / as object / as dynamic / as void
' "as void" behaves like a sub — no meaningful return value.
'
' BrightScript                              JavaScript / TypeScript equivalent
' ----------------------------------------  -------------------------------------------
' function isAdult(n as integer) as boolean function isAdult(n) { ... }   // plain JS
'                                           function isAdult(n: number): boolean   // TS
'
' function fullName(...) as string          function fullName(...): string         // TS
' function makeUser(...) as object          function makeUser(...): object         // TS
' function ... as dynamic                   function ... : any  /  unknown         // TS
' function logMessage(...) as void          function logMessage(...): void         // TS
'
' return age >= 18                          return age >= 18                       // same
' return { name: name, age: age }           return { name, age }                   // JS shorthand
'
' NOTE: do NOT name a function `log` in BRS — that shadows the built-in
' natural log (Math.log). Use `logMessage` or `printLog` instead.
'
' Run: brs return-types.brs
sub Main()
    print isAdult(20)
    print isAdult(15)

    print fullName("Abhi", "Awasthi")

    user = makeUser("Abhi", 25)
    print user.name + " / " + StrI(user.age).Trim()

    logMessage("hello from logMessage()")
end sub

function isAdult(age as integer) as boolean
    return age >= 18
end function

function fullName(first as string, last as string) as string
    return first + " " + last
end function

function makeUser(name as string, age as integer) as object
    return {
        name: name
        age: age
    }
end function

function logMessage(message as string) as void
    print "[log] " + message
end function
