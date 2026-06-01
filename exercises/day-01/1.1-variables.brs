' Day 1 / 1 — Variables and primitive types
'
' BrightScript is dynamically typed: no `dim ... as ...` is required.
' type() returns short names ("String", "Integer", "Boolean") for unboxed
' primitives, and ro* names ("roString", "roInt") for boxed values.
'
' BrightScript                    JavaScript equivalent              Notes
' ------------------------------  ---------------------------------  ---------------------------
' name = "Abhishek"               let name = "Abhishek"              no `let`/`const`/`var`; just assign
' years = 5                       const years = 5                    integer literal
' learning = true                 const learning = true              same booleans (true/false)
' type(value)                     typeof value                       BRS returns "String" / "Integer" /
'                                                                    "Boolean" — JS returns "string"/
'                                                                    "number"/"boolean"
' "String" / "Integer" / "Boolean"  "string" / "number" / "boolean"  BRS has Integer & Float (split);
'                                                                    JS has only Number
' "roString" / "roInt"            (no equivalent)                    boxed object form in BRS only
' print x                         console.log(x)
'
' Run: brs variables.brs
sub Main()
    name = "Abhishek"
    years = 5
    learning = true

    print name
    print years
    print learning

    print type(name)      ' String
    print type(years)     ' Integer
    print type(learning)  ' Boolean
end sub
