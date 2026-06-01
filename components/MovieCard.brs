' MovieCard is the per-item component used by MarkupGrid. The grid passes
' data through two built-in fields:
'   itemContent   ContentNode for this card (set whenever the row scrolls)
'   focusPercent  float 0..1 that ramps as focus moves on or off this card
'
' We never read these synchronously — we observe them and react.

sub init()
    m.poster = m.top.findNode("poster")
    m.titleLabel = m.top.findNode("titleLabel")
    m.ratingLabel = m.top.findNode("ratingLabel")
    m.focusRing = m.top.findNode("focusRing")

    m.top.observeField("itemContent", "onContentChange")
    m.top.observeField("focusPercent", "onFocusChange")
end sub

sub onContentChange()
    content = m.top.itemContent
    if content = invalid then return

    m.poster.uri = content.hdPosterUrl
    m.titleLabel.text = content.title
    m.ratingLabel.text = content.description
end sub

sub onFocusChange()
    m.focusRing.opacity = m.top.focusPercent
end sub
