' MainScene is the root component for the channel.
'
' It does four things:
'   1. Asks MovieFetchTask to load assets/movies.json.
'   2. Shows a row of MovieCards built from the response.
'   3. Plays the selected movie in a Video overlay.
'   4. Handles the BACK key (return to grid from the player).

' ----------------------------------------------------------------------
' Init
' ----------------------------------------------------------------------

sub init()
    cacheNodes()
    initState()
    registerObservers()
    startFetch()
end sub

' Cache every node reference once. `m` is per-instance state that survives
' across all the subs in this file. Doing findNode("...") on every event
' would be wasteful.
sub cacheNodes()
    m.titleLabel = m.top.findNode("titleLabel")
    m.statusLabel = m.top.findNode("statusLabel")
    m.hintLabel = m.top.findNode("hintLabel")
    m.loading = m.top.findNode("loading")
    m.grid = m.top.findNode("movieGrid")
    m.task = m.top.findNode("movieTask")
    m.playerLayer = m.top.findNode("playerLayer")
    m.player = m.top.findNode("moviePlayer")
    m.playerTitle = m.top.findNode("playerTitle")
end sub

sub initState()
    m.catalogueUrl = "pkg:/assets/movies.json"
    m.movies = []
    m.isPlaying = false
    m.currentTitle = ""
end sub

' "observeField" tells SceneGraph to call our function whenever the named
' field changes. This replaces polling with event-driven updates.
sub registerObservers()
    m.task.observeField("response", "onMoviesLoaded")
    m.grid.observeField("itemSelected", "onItemSelected")
    m.player.observeField("state", "onPlayerState")
end sub

' ----------------------------------------------------------------------
' Fetch
' ----------------------------------------------------------------------

sub startFetch()
    m.statusLabel.text = "Loading..."
    m.loading.visible = true
    m.task.url = m.catalogueUrl
    m.task.control = "RUN"
end sub

sub onMoviesLoaded()
    m.loading.visible = false
    response = m.task.response

    if response = invalid then
        showError("Task did not return a response")
        return
    end if

    if Len(response.error) > 0 then
        showError(response.error)
        return
    end if

    m.movies = response.movies
    if m.movies = invalid or m.movies.count() = 0 then
        showError("No movies found in catalogue")
        return
    end if

    m.statusLabel.text = "Loaded " + StrI(m.movies.count()).Trim() + " movies"
    populateGrid(m.movies)
    showBrowseUi()
    m.grid.setFocus(true)
end sub

' ----------------------------------------------------------------------
' Grid
' ----------------------------------------------------------------------

' MarkupGrid renders one MovieCard per child of `content`. ContentNode is
' Roku's generic data carrier for grids, rows and the Video node.
sub populateGrid(movies as object)
    root = createObject("roSGNode", "ContentNode")

    for each movie in movies
        item = createObject("roSGNode", "ContentNode")
        item.title = movie.title
        item.hdPosterUrl = movie.posterUri
        item.description = "Rating " + movie.rating.ToStr()
        root.appendChild(item)
    end for

    m.grid.content = root
end sub

sub onItemSelected()
    idx = m.grid.itemSelected
    if idx < 0 or idx >= m.movies.count() then return
    playMovie(m.movies[idx])
end sub

' ----------------------------------------------------------------------
' Player
' ----------------------------------------------------------------------

sub playMovie(movie as object)
    if movie.videoUrl = invalid or Len(movie.videoUrl) = 0 then
        m.statusLabel.text = "Missing videoUrl for '" + movie.title + "'"
        return
    end if

    m.currentTitle = movie.title
    m.isPlaying = true

    ' Reset the Video node before loading new content. Skipping this can
    ' leave the player in a weird state when switching streams.
    m.player.control = "stop"
    m.player.content = invalid

    content = createObject("roSGNode", "ContentNode")
    content.url = movie.videoUrl
    content.streamFormat = movie.videoFormat
    content.title = movie.title

    m.playerTitle.text = "Loading: " + movie.title
    hideBrowseUi()
    m.playerLayer.visible = true
    m.player.content = content
    m.player.setFocus(true)
    m.player.control = "play"
end sub

' The Video node publishes "state" as it transitions through the playback
' lifecycle: none -> buffering -> playing -> finished | error.
sub onPlayerState()
    state = m.player.state
    if state = invalid then return

    print "[player] state=" + state

    if state = "buffering" then
        m.playerTitle.text = "Buffering: " + m.currentTitle
    else if state = "playing" then
        m.playerTitle.text = m.currentTitle
    else if state = "error" then
        showPlayerError()
    else if state = "finished" then
        closePlayer()
    end if
end sub

sub showPlayerError()
    code = m.player.errorCode
    if code = invalid then code = -1

    msg = m.player.errorMsg
    if msg = invalid or Len(msg) = 0 then msg = "Playback failed"

    print "[player] errorCode=" + StrI(code).Trim() + " msg=" + msg
    m.playerTitle.text = "Error (" + StrI(code).Trim() + "): " + msg
    m.hintLabel.text = "BACK to return"
end sub

sub closePlayer()
    m.isPlaying = false
    m.player.control = "stop"
    m.player.content = invalid
    m.playerLayer.visible = false
    showBrowseUi()
    m.grid.setFocus(true)
end sub

' ----------------------------------------------------------------------
' UI helpers
' ----------------------------------------------------------------------

sub showError(message as string)
    m.statusLabel.text = message
    m.statusLabel.visible = true
    m.hintLabel.text = ""
    m.grid.visible = false
end sub

sub showBrowseUi()
    m.titleLabel.visible = true
    m.statusLabel.visible = true
    m.grid.visible = true
    m.hintLabel.visible = true
    m.hintLabel.text = "<- ->  navigate    OK  play    BACK  exit"
end sub

sub hideBrowseUi()
    m.titleLabel.visible = false
    m.statusLabel.visible = false
    m.grid.visible = false
    m.hintLabel.visible = true
    m.hintLabel.text = "BACK to return"
end sub

' ----------------------------------------------------------------------
' Keys
' ----------------------------------------------------------------------

' Return true if we handled the key; return false to let SceneGraph use its
' default behaviour (which on the root Scene closes the channel for BACK).
function onKeyEvent(key as string, press as boolean) as boolean
    if not press then return false

    if key = "back" and m.isPlaying then
        closePlayer()
        return true
    end if

    return false
end function
