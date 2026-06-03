' Day 3 / 3.2 — Child-to-parent via interface field (BrightScript half)
'
' This component exposes `clickCount` as its outbound signal. Any
' parent that wants to know when this component fires hooks in with:
'
'   m.top.findNode("emitter").observeField("clickCount", "onChildClicked")
'
' Inside this component, simulateEmit(...) is a stand-in for whatever
' triggers the emit in your real code (a remote OK key, a Task
' completion, an animation finish). The parent invokes it directly
' for testing — e.g. m.top.findNode("emitter").callFunc("simulateEmit", invalid)
' or, more typically, the component owns its own focus and onKeyEvent
' and calls simulateEmit() internally.
'
' Expected console output (after three simulateEmit calls):
'   [3.2] init; ready to emit on m.top.clickCount
'   [3.2] emit -> clickCount = 1
'   [3.2] emit -> clickCount = 2
'   [3.2] emit -> clickCount = 3

sub init()
    print "[3.2] init; ready to emit on m.top.clickCount"
end sub

' Public test trigger: bump the outbound field. The parent's observer
' fires on every write because of alwaysNotify="true" in the XML.
sub simulateEmit()
    m.top.clickCount = m.top.clickCount + 1
    print "[3.2] emit -> clickCount = " ; m.top.clickCount
end sub
