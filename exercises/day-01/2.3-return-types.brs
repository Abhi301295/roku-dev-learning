' Day 1 / 8 — Return types
'
' Functions can declare what they return:
'   as integer / as string / as boolean / as object / as dynamic / as void
' "as void" behaves like a sub — no meaningful return value.
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
