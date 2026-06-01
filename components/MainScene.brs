' MainScene controller — render-thread BrightScript
'
' Lifecycle recap from Chapter 3:
'   1. Main() (source/main.bs) creates an roSGScreen and calls CreateScene("MainScene")
'   2. SceneGraph builds this XML node tree
'   3. init() below runs automatically before the UI is rendered
'   4. From here we mutate node fields and react to events
'
' `m.top` is the MainScene root. `m` itself is the script's instance scope —
' anything we cache on it lives for the lifetime of the scene.

sub init()
    print "[MainScene] init"

    m.helloLabel = m.top.findNode("helloLabel")
    m.subtitleLabel = m.top.findNode("subtitleLabel")
    m.statusLabel = m.top.findNode("statusLabel")
    m.cardRow = m.top.findNode("cardRow")

    ' Chapter 1: prove BrightScript can mutate fields declared in XML.
    m.helloLabel.text = "Welcome to Roku Development!"

    ' Chapter 2: observer pattern — react to a field change instead of polling.
    m.subtitleLabel.observeField("text", "onSubtitleChange")
    m.subtitleLabel.text = "Chapters 1-3 — SceneGraph + BrightScript"

    populateCards()
    runChapter3Demos()

    m.statusLabel.text = "Press BACK on the remote to exit"
    m.top.setFocus(true)
end sub

sub onSubtitleChange()
    print "[observer] subtitleLabel.text -> " + m.subtitleLabel.text
end sub

' Chapter 2: build a row of reusable MovieCard nodes from the function-based
' catalogue defined in source/services/MovieService.brs. Each card is a custom
' component (components/MovieCard.xml) with public fields posterUri / title /
' rating that we set via assignment.
sub populateCards()
    movies = MovieService_getCatalogue()

    cardWidth = 200
    gap = 30

    for i = 0 to movies.count() - 1
        movie = movies[i]

        card = createObject("roSGNode", "MovieCard")
        card.translation = [i * (cardWidth + gap), 0]
        card.title = movie.title
        card.rating = movie.rating
        card.posterUri = ""

        m.cardRow.appendChild(card)
    end for
end sub

' Chapter 3: fundamentals demonstrated end-to-end inside one scene. Logs go to
' the Roku debug console (telnet <device-ip> 8085) on a real device.
sub runChapter3Demos()
    print "--- Chapter 3 demos ---"

    print "[filterByRating >= 8.5]"
    movies = MovieService_getCatalogue()
    for each item in MovieUtils_filterByRating(movies, 8.5)
        print "- " + item.title
    end for

    print "[findByTitle('Tenet')]"
    hit = MovieUtils_findByTitle(movies, "Tenet")
    if hit = invalid then
        print "  not found"
    else
        print "  " + hit.title + " (" + StrI(hit.year).Trim() + ")"
    end if

    print "[averageRating]"
    print "  avg = " + MovieUtils_averageRating(movies).ToStr()

    print "[try/catch — divide by zero]"
    try
        bogus = divide(10, 0)
        print "  result = " + bogus.ToStr()
    catch e
        print "  caught: " + e.message
    end try

    print "[StringUtils]"
    print "  capitalize('hello') -> " + StringUtils_capitalize("hello")
    print "  reverse('roku')     -> " + StringUtils_reverse("roku")
end sub

' Throws on b = 0 to exercise the try/catch block above. Floats are compared
' loosely here because BrightScript auto-promotes integer 0 to float for `=`.
function divide(a as float, b as float) as float
    if b = 0 then throw "Divide by zero"
    return a / b
end function
