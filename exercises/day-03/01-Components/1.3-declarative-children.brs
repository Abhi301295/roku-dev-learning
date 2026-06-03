' Day 3 / 1.3 — Declarative children (BrightScript half)
'
' The XML half declared three children (background, titleLabel,
' taglineLabel) with ids. By the time init() runs they're already
' attached to m.top. We just grab references and set their text.
'
' Why cache via findNode in init() instead of looking them up every
' time? findNode walks the component's tree. Calling it once per child
' during init is cheap. Calling it on every observer fire (or every
' frame) is wasteful — and undisciplined enough that it becomes a
' code-review smell in any production channel.
'
' Expected console output:
'   [1.3] cached 3 children; titleLabel.text = "Inception"

sub init()
    m.background   = m.top.findNode("background")
    m.titleLabel   = m.top.findNode("titleLabel")
    m.taglineLabel = m.top.findNode("taglineLabel")

    m.titleLabel.text   = "Inception"
    m.taglineLabel.text = "Your mind is the scene of the crime."

    print "[1.3] cached 3 children; titleLabel.text = " ; chr(34) ; m.titleLabel.text ; chr(34)
end sub
