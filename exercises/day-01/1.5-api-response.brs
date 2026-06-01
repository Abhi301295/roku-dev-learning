' Day 1 / 5 — API-shaped data, invalid checks, and count()
'
' Mirrors a typical JSON response: a top-level object with a flag and an
' array of records. Demonstrates:
'   - Reading nested fields
'   - `invalid` (BrightScript's null/undefined)
'   - Two ways to stringify an integer: StrI(n).Trim() and n.ToStr()
'   - `arr.count()` on an empty array
'
' BrightScript                    JavaScript equivalent              Notes
' ------------------------------  ---------------------------------  ---------------------------
' invalid                         null  /  undefined                 BRS has one "missing" value;
'                                                                    JS has two
' x = invalid                     x = null                           explicit "no value" assignment
' if x = invalid                  if (x == null)                     `==` matches null AND undefined
' obj.missingKey -> invalid       obj.missingKey -> undefined        no exception in either
' StrI(n).Trim()                  String(n)  /  n.toString()         BRS PascalCase + leading-space
' n.ToStr()                       n.toString()                       both produce the digits
' arr.count()                     arr.length                         method vs property
' [].count()  // 0                [].length     // 0
' print obj.x; obj.y              console.log(obj.x, obj.y)          BRS `;` keeps items on same line
'
' Run: brs api-response.brs
sub Main()
    response = {
        success: true
        data: [
            {
                name: "Netflix"
                subscribers: 300
            }
            {
                name: "Prime Video"
                subscribers: 200
            }
        ]
    }

    print "success: "; response.success

    for each item in response.data
        print item.name + " - " + StrI(item.subscribers).Trim()
        print item.name + " - " + item.subscribers.ToStr()
    end for

    ' invalid demo: a missing/typo'd field returns invalid.
    movie = invalid
    if movie = invalid
        print "movie is invalid"
    else
        print "movie is set"
    end if

    ' Missing field also yields invalid (no exception thrown).
    print "typo lookup: "; response.successesss

    emptyList = []
    print "empty count: " + StrI(emptyList.count()).Trim()
end sub
