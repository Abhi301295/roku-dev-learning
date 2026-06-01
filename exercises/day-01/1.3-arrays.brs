' Day 1 / 3 — Arrays and the for-each loop
'
' BrightScript's idiomatic loop is `for each VAR in COLLECTION`.
' Use `arr.count()` for length and `arr.push(value)` to append.
'
' Run: brs arrays.brs
sub Main()
    techStack = [
        "React"
        "Next.js"
        "TypeScript"
        "BrightScript"
    ]

    for each tech in techStack
        print tech
    end for

    print "Total: " + StrI(techStack.count()).Trim()
end sub
