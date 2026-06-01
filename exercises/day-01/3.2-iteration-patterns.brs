' Day 1 / Section 3 / 3.2 — Iteration patterns
'
' Three common ways to walk an array:
'   1. for each VAR in COLLECTION    — cleanest, no index
'   2. for i = 0 to COLLECTION.count() - 1   — when you need the index
'   3. while ...                     — flexible, for "stop when" loops
'
' BrightScript                              JavaScript equivalent
' ----------------------------------------  -----------------------------------------
' for each x in arr                         for (const x of arr) { ... }
'   ...                                     // or arr.forEach(x => { ... })
' end for
'
' for i = 0 to arr.count() - 1              for (let i = 0; i < arr.length; i++) { ... }
'   arr[i]                                  // arr[i] same
' end for
'
' while cond                                while (cond) {
'   ...                                       ...
' end while                                 }
'
' exit for     /  exit while                break                  // same effect
' (no `continue` keyword in BRS)            continue
' arr.count()                               arr.length
'
' Run: brs 3.2-iteration-patterns.brs
sub Main()
    fruits = ["apple", "banana", "cherry", "date"]

    ' --- 1. for each: most readable, prefer this when index is not needed ---
    print "[for each]"
    for each fruit in fruits
        print "- " + fruit
    end for

    ' --- 2. indexed for loop: when you need the position ---
    print "[for i]"
    for i = 0 to fruits.count() - 1
        print StrI(i).Trim() + ": " + fruits[i]
    end for

    ' --- 3. while: stop early on a condition ---
    print "[while]"
    i = 0
    while i < fruits.count()
        if fruits[i] = "cherry" then
            print "found cherry at index " + StrI(i).Trim()
            exit while
        end if
        i = i + 1
    end while

    ' --- exit for: bail out of for-each / for-i ---
    print "[exit for]"
    for each fruit in fruits
        if fruit = "banana" then
            print "stopping at " + fruit
            exit for
        end if
        print "skipped " + fruit
    end for
end sub
