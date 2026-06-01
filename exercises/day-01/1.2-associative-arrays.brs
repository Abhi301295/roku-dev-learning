' Day 1 / 2 — Associative arrays (objects)
'
' Curly braces create an roAssociativeArray. Access fields with dot notation
' (`obj.key`) or bracket notation (`obj["key"]`). Keys are case-insensitive.
' Nested arrays/objects are fully supported.
'
' BrightScript                    JavaScript equivalent              Notes
' ------------------------------  ---------------------------------  ---------------------------
' { name: "Abhi" }                { name: "Abhi" }                   same literal syntax
' { a: 1  b: 2 }                  { a: 1, b: 2 }                     BRS: newline OR comma; JS: comma
' obj.name                        obj.name                           dot access — same
' obj["name"]                     obj["name"]                        bracket access — same
' obj.NAME / obj.name (same)      obj.NAME / obj.name (different)    BRS keys CASE-INSENSITIVE,
'                                                                    JS keys are CASE-SENSITIVE
' [ "a"  "b"  "c" ]               ["a", "b", "c"]                    BRS: newline OR comma; JS: comma
' type(obj)  // "roAssociativeArray"  typeof obj  // "object"        BRS distinguishes obj vs array;
' type(arr)  // "roArray"             typeof arr  // "object"        JS uses Array.isArray(arr)
' (missing key) -> invalid        (missing key) -> undefined         no exception in either
'
' Run: brs associative-arrays.brs
sub Main()
    developer = {
        name: "Abhishek"
        role: "Frontend Developer"
        experience: 5
        skills: [
            "React"
            "Next.js"
            "TypeScript"
        ]
    }

    print developer.name
    print developer.role
    print developer.experience

    print type(developer)        ' roAssociativeArray
    print type(developer.skills) ' roArray
end sub
