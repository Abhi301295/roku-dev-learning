' Day 1 / 3 — Arrays and the for-each loop
'
' BrightScript's idiomatic loop is `for each VAR in COLLECTION`.
' Use `arr.count()` for length and `arr.push(value)` to append.
'
' BrightScript                    JavaScript equivalent              Notes
' ------------------------------  ---------------------------------  ---------------------------
' for each x in arr               for (const x of arr)               or arr.forEach(x => ...)
'   ...                             ...
' end for                         }
' arr.count()                     arr.length                         BRS: method  /  JS: property
' arr.push(x)                     arr.push(x)                        same — append at end
' StrI(n).Trim()                  String(n)  /  `${n}`               BRS: `+` is type-strict, must
'                                                                    explicitly stringify; JS: `+`
'                                                                    coerces automatically
' "a" + StrI(n).Trim()            "a" + n   /   `a${n}`              JS auto-coerces; BRS does not
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
