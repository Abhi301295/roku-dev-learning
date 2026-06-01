' MovieCard — Chapter 2 reusable component.
'
' Mirrors the blog example: a Group with three interface fields and one
' observer per field. Updating m.top.title from a parent automatically
' triggers onTitleChange() here, which then mutates the inner Label.

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
