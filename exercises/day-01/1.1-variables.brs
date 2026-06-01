' Day 1 / 1 — Variables and primitive types
'
' BrightScript is dynamically typed: no `dim ... as ...` is required.
' type() returns short names ("String", "Integer", "Boolean") for unboxed
' primitives, and ro* names ("roString", "roInt") for boxed values.
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
