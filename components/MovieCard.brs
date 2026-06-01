' MovieCard controller.
'
' Three interface fields wired to inner nodes via observeField — updating
' m.top.title from a parent triggers onTitleChange() which mutates the Label.

sub init()
    m.poster = m.top.findNode("poster")
    m.titleLabel = m.top.findNode("titleLabel")
    m.ratingLabel = m.top.findNode("ratingLabel")

    m.top.observeField("posterUri", "onPosterUriChange")
    m.top.observeField("title", "onTitleChange")
    m.top.observeField("rating", "onRatingChange")
end sub

sub onPosterUriChange()
    m.poster.uri = m.top.posterUri
end sub

sub onTitleChange()
    m.titleLabel.text = m.top.title
end sub

' Floats need .ToStr(); StrI() truncates to integer.
sub onRatingChange()
    m.ratingLabel.text = "Rating: " + m.top.rating.ToStr()
end sub
