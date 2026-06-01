' MainScene controller — render-thread BrightScript.
'
' Owns the movie list UI. Fetching happens in MovieFetchTask (its own thread);
' MainScene only observes the result and renders cards.

sub init()
    m.statusLabel = m.top.findNode("statusLabel")
    m.hintLabel = m.top.findNode("hintLabel")
    m.cardRow = m.top.findNode("cardRow")

    fetchMovies()

    m.top.setFocus(true)
end sub

' Spawn the Task, wire the observer, set control = "RUN" to start it.
' The Task publishes m.task.response when finished, which fires onMoviesLoaded.
sub fetchMovies()
    m.task = createObject("roSGNode", "MovieFetchTask")
    m.task.observeField("response", "onMoviesLoaded")
    m.task.control = "RUN"
end sub

sub onMoviesLoaded()
    response = m.task.response
    if response = invalid then
        m.statusLabel.text = "No response from task"
        return
    end if

    if response.error <> invalid and Len(response.error) > 0 then
        m.statusLabel.text = "Error: " + response.error + " (showing local data)"
    else
        m.statusLabel.text = "Loaded " + StrI(response.movies.count()).Trim() + " movies"
    end if

    populateCards(response.movies)
    m.hintLabel.text = "Press BACK on the remote to exit"
end sub

' Build a row of MovieCard nodes from an array of { title, rating, ... } maps.
sub populateCards(movies as object)
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
