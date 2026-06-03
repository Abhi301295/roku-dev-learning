' Day 3 / 3.1 — Parent-to-child via interface field (BrightScript half)
'
' init() does two things:
'   1. cacheNodes() — one findNode per declared child.
'   2. subscribe to our OWN interface field, so a parent write fires us.
'
' When the parent writes m.top.movie, the platform fires onMovieChanged
' on this component. The observer reads m.top.movie itself rather than
' relying on the event payload, which is the shape you want when the
' callback also needs neighbouring fields.
'
' Expected console output (after the parent sets m.top.movie):
'   [3.1] onMovieChanged; rendering Inception / 8.8

sub init()
    cacheNodes()
    m.top.observeField("movie", "onMovieChanged")
end sub

sub cacheNodes()
    m.titleLabel  = m.top.findNode("titleLabel")
    m.ratingLabel = m.top.findNode("ratingLabel")
end sub

sub onMovieChanged()
    movie = m.top.movie
    if movie = invalid then return

    title  = ""
    rating = 0.0
    if movie.title <> invalid  then title  = movie.title
    if movie.rating <> invalid then rating = movie.rating

    m.titleLabel.text  = title
    m.ratingLabel.text = "Rating " + rating.ToStr()

    print "[3.1] onMovieChanged; rendering " ; title ; " / " ; rating
end sub
