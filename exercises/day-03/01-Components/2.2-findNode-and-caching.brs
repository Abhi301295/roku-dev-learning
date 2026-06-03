' Day 3 / 2.2 — findNode and node caching (BrightScript half)
'
' Two patterns shown here:
'   1. cacheNodes() — one findNode per child, references parked on m.*.
'   2. populate()   — uses the cached references.
'
' Notice init() shrinks to two named-intent calls. As the count of
' declared children grows, this keeps init() readable and lets each
' helper stay short.
'
' Expected console output:
'   [2.2] cached 5 nodes; hero text = Inception

sub init()
    cacheNodes()
    populate()
end sub

sub cacheNodes()
    m.frame         = m.top.findNode("frame")
    m.heroLabel     = m.top.findNode("heroLabel")
    m.directorLabel = m.top.findNode("directorLabel")
    m.ratingLabel   = m.top.findNode("ratingLabel")
    m.yearLabel     = m.top.findNode("yearLabel")
end sub

sub populate()
    m.heroLabel.text     = "Inception"
    m.directorLabel.text = "Director: Christopher Nolan"
    m.ratingLabel.text   = "Rating: 8.8 / 10"
    m.yearLabel.text     = "Year: 2010"

    print "[2.2] cached 5 nodes; hero text = " ; m.heroLabel.text
end sub
