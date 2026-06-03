' Day 3 / 2.3 — m.top vs m.global (BrightScript half)
'
' Probes the three scopes side by side. In a real channel you would
' declare m.global.<field> in the Scene's init() ONCE, then read or
' write it from any component:
'
'   (in MainScene.brs init())
'     m.global.addField("appTheme", "string", false)
'     m.global.appTheme = "dark"
'
'   (in any other component)
'     theme = m.global.appTheme
'     m.global.observeField("appTheme", "onThemeChanged")
'
' This demo only PROBES the scopes from one component to keep the
' wiring tiny.
'
' Expected console output:
'   [2.3] m              has type roAssociativeArray
'   [2.3] m.top          has subtype GlobalScopeDemo
'   [2.3] m.global       has type roSGNode (subtype Node)
'   [2.3] m.top.seedValue = hello-from-init

sub init()
    print "[2.3] m              has type " ; type(m)
    print "[2.3] m.top          has subtype " ; m.top.subtype()
    print "[2.3] m.global       has type " ; type(m.global) ; " (subtype " ; m.global.subtype() ; ")"
    print "[2.3] m.top.seedValue = " ; m.top.seedValue
end sub
