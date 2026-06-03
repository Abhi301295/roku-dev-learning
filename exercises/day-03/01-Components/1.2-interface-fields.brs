' Day 3 / 1.2 — Interface fields (BrightScript half)
'
' How the <interface> fields show up at runtime.
'
' Construction order on a real device:
'   1. The XML is parsed and the component instance is built.
'   2. Interface field DEFAULTS (from value="...") are applied.
'   3. `sub init()` runs.
'   4. AFTER init() returns, the parent's attribute-style writes land:
'        <InterfaceFieldsDemo title="Inception" rating="8.8" />
'      Those writes fire any observers the component registered in init.
'
' Consequence: inside init(), m.top.title still reads the DEFAULT, even
' if the parent passed a value at the declaration site. To react to the
' parent's value, observeField in init() and react in the callback
' (covered in 3.1).
'
' Expected console output (with NO parent override):
'   [1.2] m.top.title  = (no title set)
'   [1.2] m.top.rating =  0
'   [1.2] m.top.is4k   = false

sub init()
    print "[1.2] m.top.title  = " ; m.top.title
    print "[1.2] m.top.rating = " ; m.top.rating
    print "[1.2] m.top.is4k   = " ; m.top.is4k
end sub
