' Day 3 / 4 — Challenge: MovieBadge (reference solution)
'
' Pattern recap baked into this file:
'   - Section 1: <component>, <interface>, <children> all declared in
'     the xml half.
'   - Section 2: init() does cacheNodes + registerObservers; m.top.* is
'     used only at the contract surface (subscribing and reading).
'   - Section 3.1: parent writes m.top.movie -> we re-render.
'   - Section 3.1: parent writes m.top.selected -> we recolour the frame.
'   - Section 3.2: parent observes m.top.clickCount; we bump it from
'     callbackEnter() to signal a click upward.
'
' Cleanup note: SceneGraph drops observers automatically when a
' component is destroyed, so MovieBadge does not call unobserveField
' on its own fields. In dynamic UIs where you create and destroy
' children manually mid-screen, you would.
'
' Expected console output, in order, when the parent does:
'   badge.movie    = { title: "Inception", rating: 8.8, posterUri: "..." }
'   badge.selected = true
'   badge.callFunc("callbackEnter", invalid)     ' parent's OK handler
'
'   [movie-badge] init; ready
'   [movie-badge] onMovieChanged; title=Inception rating=8.8
'   [movie-badge] onSelectedChanged; selected=true
'   [movie-badge] emit -> clickCount = 1

sub init()
    cacheNodes()
    registerObservers()
    print "[movie-badge] init; ready"
end sub

' ---------- setup ----------

sub cacheNodes()
    m.frame       = m.top.findNode("frame")
    m.poster      = m.top.findNode("poster")
    m.titleLabel  = m.top.findNode("titleLabel")
    m.ratingLabel = m.top.findNode("ratingLabel")
end sub

sub registerObservers()
    m.top.observeField("movie",    "onMovieChanged")
    m.top.observeField("selected", "onSelectedChanged")
end sub

' ---------- inbound (parent writes -> we repaint) ----------

sub onMovieChanged()
    movie = m.top.movie
    if movie = invalid then return

    title     = guardString(movie.title,     "")
    rating    = guardFloat(movie.rating,     0.0)
    posterUri = guardString(movie.posterUri, "")

    m.titleLabel.text  = title
    m.ratingLabel.text = "Rating " + rating.ToStr()
    m.poster.uri       = posterUri

    print "[movie-badge] onMovieChanged; title=" ; title ; " rating=" ; rating
end sub

sub onSelectedChanged()
    selected = m.top.selected
    if selected then
        m.frame.color = "0x3D5DC9FF"
    else
        m.frame.color = "0x1A2238FF"
    end if
    print "[movie-badge] onSelectedChanged; selected=" ; selected
end sub

' ---------- outbound (we write -> parent's observer fires) ----------

' Parents call this when the user presses OK on this badge. Because
' clickCount is alwaysNotify=true in the XML, a second consecutive
' press at the same numeric value still fires the parent's observer.
sub callbackEnter()
    m.top.clickCount = m.top.clickCount + 1
    print "[movie-badge] emit -> clickCount = " ; m.top.clickCount
end sub

' ---------- tiny helpers ----------

function guardString(value as dynamic, default as string) as string
    if value = invalid then return default
    return value
end function

function guardFloat(value as dynamic, default as float) as float
    if value = invalid then return default
    return value
end function
