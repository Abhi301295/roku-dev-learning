' Day 3 / 2.1 — init() lifecycle and m.top (BrightScript half)
'
' Probes the state of `m`, `m.top`, and the interface field at the
' exact point init() runs.
'
' Things this file demonstrates:
'   - `m.top.subtype()` returns the component name from the XML.
'   - Interface field defaults are visible here; parent overrides are
'     not, because they land AFTER init() returns.
'   - `m` and `m.top` are different scopes; both are addressable.
'
' Expected console output (NO parent override):
'   [2.1] init starting
'   [2.1] m.top.subtype() = InitLifecycleDemo
'   [2.1] m.top.label     = (unset)
'   [2.1] init returning. After this, parent attribute writes (if any)
'         will land and fire any observers we registered.

sub init()
    print "[2.1] init starting"
    print "[2.1] m.top.subtype() = " ; m.top.subtype()
    print "[2.1] m.top.label     = " ; m.top.label
    print "[2.1] init returning. After this, parent attribute writes (if any)"
    print "      will land and fire any observers we registered."
end sub
