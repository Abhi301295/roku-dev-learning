' Day 1 / 7 — Parameters: type annotations and default values
'
'   name as string          — required parameter
'   times = 1 as integer    — default if caller omits the arg
'   data as dynamic         — accepts any type
' Required parameters must come BEFORE parameters with defaults.
'
' BrightScript                              JavaScript equivalent
' ----------------------------------------  -----------------------------------------
' sub repeat(message as string,             function repeat(message, times = 1) { ... }
'            times = 1 as integer)          (TS: repeat(message: string, times: number = 1))
'
' sub describe(value as dynamic)            function describe(value) { ... }
'                                           (TS: describe(value: any) — or unknown)
'
' type(value)                               typeof value
' "String" / "Integer" / "roArray" /        "string" / "number" / "object" /
' "roAssociativeArray"                      "object"   (use Array.isArray to split)
'
' Required-before-default rule              same in JS — required params come first
'
' Run: brs parameters.brs
sub Main()
    repeat("Hi", 3)
    repeat("Solo")

    describe("Abhishek")
    describe(42)
    describe([1, 2, 3])
    describe({ name: "Roku" })
end sub

sub repeat(message as string, times = 1 as integer)
    for i = 1 to times
        print message
    end for
end sub

sub describe(value as dynamic)
    print "type=" + type(value) + "  value="; value
end sub
