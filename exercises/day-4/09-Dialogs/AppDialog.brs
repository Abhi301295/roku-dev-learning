' Day 4 / 09 — Reusable dialog component (BrightScript half)
'
' Paired with AppDialog.xml.
'
' Parent → child via interface fields (title, message, visible).
' Child → parent via buttonSelected (alwaysNotify on OK press).
'
' When visible flips to true we repaint and give the button list focus
' so the remote works immediately without the parent calling setFocus.

sub init()
    m.scrim = m.top.findNode("scrim")
    m.card = m.top.findNode("card")
    m.titleLabel = m.top.findNode("titleLabel")
    m.messageLabel = m.top.findNode("messageLabel")
    m.buttonList = m.top.findNode("buttonList")

    m.buttonList.content = buildButtonContent(["Retry", "Cancel"])
    m.buttonList.observeField("itemSelected", "onButtonPressed")

    m.top.observeField("title", "onFieldsChanged")
    m.top.observeField("message", "onFieldsChanged")
    m.top.observeField("visible", "onVisibleChanged")

    m.top.visible = false
    applyVisible(false)
end sub

function buildButtonContent(labels as object) as object
    root = createObject("roSGNode", "ContentNode")
    for each label in labels
        item = createObject("roSGNode", "ContentNode")
        item.title = label
        root.appendChild(item)
    end for
    return root
end function

sub onFieldsChanged()
    m.titleLabel.text = m.top.title
    m.messageLabel.text = m.top.message
end sub

sub onVisibleChanged()
    applyVisible(m.top.visible)
end sub

sub applyVisible(show as boolean)
    m.scrim.visible = show
    m.card.visible = show
    m.top.visible = show

    if show then
        onFieldsChanged()
        m.buttonList.setFocus(true)
    end if
end sub

sub onButtonPressed(event as object)
    idx = event.getData()
    if idx < 0 then return

    ' Bump outbound field so the parent Scene can react.
    m.top.buttonSelected = idx
end sub
