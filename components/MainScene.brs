' MainScene — day-2-implementation branch
'
' Verifies the SceneGraph half of exercises/day-02/02-Observers:
'
'   Section 2.*  Synthetic demos that run synchronously inside init().
'                They create their own ContentNodes, fire observers,
'                and print to the console immediately. No UI needed.
'
'   Section 3.*  Real channel lifecycle. After the section-2 prints,
'                init() wires up the Task -> Scene -> Grid -> Video
'                chain (the same patterns the day-2 channel uses), then
'                starts the catalogue fetch. From that point on:
'                   - Task -> Scene fires once when MovieFetchTask
'                     publishes its response field.
'                   - Grid focus/select fires as you navigate the grid
'                     with the remote and press OK.
'                   - Video state machine fires as the player walks
'                     buffering -> playing -> finished | error.
'
'   Sections 4 and 5 (Observable / EventBus / MVVM classes) are pure
'   BrighterScript and verified under brs CLI — nothing to wire here.
'
' Watch with:   the BrightScript Simulator's console window
'               (or `telnet <roku-ip> 8085` when sideloaded to real hardware).
'
' Timing note: same-thread observeField fires SYNCHRONOUSLY. The
' section-2 mutations below dispatch their callbacks before the next
' line runs. Cross-thread writes (Task response, Video state) are queued
' and dispatched on the next render-thread tick, so the section-3 prints
' interleave with user input rather than appearing all at boot.

sub init()
    runSyntheticDemos()      ' Section 2 — fires synchronously, see below
    bootChannelLifecycle()   ' Section 3 — wires observers, starts the fetch
end sub

' ======================================================================
' Section 2 — synthetic demos
' ======================================================================
'
' Each `node.field = value` below dispatches its callback before the
' next line runs (writes and observers all live on the render thread),
' so the prints land in clean linear order in the simulator console.

sub runSyntheticDemos()
    print ""
    print "========== Day-2 / Observers / Section 2 — synthetic demos =========="
    demoObserveFieldBasics()
    demoSharedFieldObserver()
    demoUnobserveCleanup()
    demoAlwaysNotifyBehaviour()
    print "========== End of Section 2 demos =========="
    print ""
end sub

' Mirrors exercises/day-02/02-Observers/2.1-observeField-basics.brs
' Expect 3 callbacks, one per mutation.
sub demoObserveFieldBasics()
    print "[2.1] setup: ContentNode + addField('counter') + observeField"
    m.counterNode = createObject("roSGNode", "ContentNode")
    m.counterNode.addField("counter", "integer", true)
    m.counterNode.counter = 0
    m.counterNode.observeField("counter", "onCounterChange")

    print "[2.1] mutating counter -> 1, 2, 5"
    m.counterNode.counter = 1
    m.counterNode.counter = 2
    m.counterNode.counter = 5
end sub

' Mirrors exercises/day-02/02-Observers/2.2-event-payload.brs
' One callback for many fields, branching on event.getField().
' Expect 3 callbacks (title, rating, year).
sub demoSharedFieldObserver()
    print "[2.2] setup: one ContentNode, 3 fields, 1 shared observer"
    m.movieNode = createObject("roSGNode", "ContentNode")
    m.movieNode.addFields({ rating: 0.0, year: 0 })

    ' `title` is a built-in ContentNode field, no need to addField.
    m.movieNode.observeField("title",  "onMovieFieldChange")
    m.movieNode.observeField("rating", "onMovieFieldChange")
    m.movieNode.observeField("year",   "onMovieFieldChange")

    print "[2.2] mutating each field once"
    m.movieNode.title  = "Inception"
    m.movieNode.rating = 8.8
    m.movieNode.year   = 2010
end sub

' Mirrors exercises/day-02/02-Observers/2.3-scoped-and-unobserve.brs
' Expect 2 callbacks, then unobserve, then 0 callbacks on the next 2.
sub demoUnobserveCleanup()
    print "[2.3] setup: register observer, mutate, unobserve, mutate again"
    m.tempCounter = createObject("roSGNode", "ContentNode")
    m.tempCounter.addField("counter", "integer", true)
    m.tempCounter.observeField("counter", "onTempCounterChange")

    m.tempCounter.counter = 1
    m.tempCounter.counter = 2

    ' Drop every observer this caller added on `counter`. From here on
    ' mutations are silent — the cleanup pattern senior channel code
    ' uses on screen teardown.
    m.tempCounter.unobserveField("counter")
    print "[2.3] (after unobserveField, writes 3 and 4 fire NO callbacks)"

    m.tempCounter.counter = 3
    m.tempCounter.counter = 4
end sub

' Mirrors exercises/day-02/02-Observers/2.4-alwaysNotify.brs
' Strict node: 3 writes -> 2 callbacks (3rd equal-value suppressed).
' Always node: 3 writes -> 3 callbacks (re-fires on equal value).
sub demoAlwaysNotifyBehaviour()
    print "[2.4] setup: two nodes; strict (default) vs alwaysNotify=true"
    m.strictCounter = createObject("roSGNode", "ContentNode")
    m.strictCounter.addField("count", "integer", false)
    m.strictCounter.observeField("count", "onStrictCounterChange")

    m.alwaysCounter = createObject("roSGNode", "ContentNode")
    m.alwaysCounter.addField("count", "integer", true)
    m.alwaysCounter.observeField("count", "onAlwaysCounterChange")

    print "[2.4] strict: 1, 2, 2  -> expect 2 callbacks (third is suppressed)"
    m.strictCounter.count = 1
    m.strictCounter.count = 2
    m.strictCounter.count = 2

    print "[2.4] always: 1, 2, 2  -> expect 3 callbacks (re-fire on equal)"
    m.alwaysCounter.count = 1
    m.alwaysCounter.count = 2
    m.alwaysCounter.count = 2
end sub

' ======================================================================
' Section 3 — full channel lifecycle (asynchronous, interactive)
' ======================================================================
'
' The observers below are wired at boot; their callbacks fire later as
' the Task thread publishes the catalogue (3.1), the user navigates the
' grid (3.2), and the Video node walks its state machine (3.3).

sub bootChannelLifecycle()
    print "========== Day-2 / Observers / Section 3 — channel lifecycle =========="
    print "[3.x] (interactive: <-/-> to scroll, OK to play, BACK to return)"
    cacheChannelNodes()
    initChannelState()
    registerLifecycleObservers()
    startCatalogueFetch()
end sub

' Cache every XML-declared UI node once. `m` is per-instance state that
' survives across all subs in this file, so we avoid findNode() on every
' event.
sub cacheChannelNodes()
    m.titleLabel  = m.top.findNode("titleLabel")
    m.statusLabel = m.top.findNode("statusLabel")
    m.hintLabel   = m.top.findNode("hintLabel")
    m.loading     = m.top.findNode("loading")
    m.grid        = m.top.findNode("movieGrid")
    m.task        = m.top.findNode("movieTask")
    m.playerLayer = m.top.findNode("playerLayer")
    m.player      = m.top.findNode("moviePlayer")
    m.playerTitle = m.top.findNode("playerTitle")
end sub

' Per-scene state read/written by the Section 3 callbacks and helpers.
sub initChannelState()
    m.movies = []
    m.isPlaying = false
    m.currentTitle = ""
end sub

' Wire the three real-world observer patterns from Section 3.
sub registerLifecycleObservers()
    ' Exercise 3.1 — Task -> Scene. `response` is alwaysNotify=true on
    ' a real Task, so even a second identical payload still fires.
    m.task.observeField("response", "onMoviesLoaded")

    ' Exercise 3.2 — Grid focus + selection. itemFocused fires
    ' constantly while scrolling (keep callbacks cheap); itemSelected
    ' fires once per OK press.
    m.grid.observeField("itemFocused",  "onItemFocused")
    m.grid.observeField("itemSelected", "onItemSelected")

    ' Exercise 3.3 — Video state machine. One observer covers
    ' buffering / playing / paused / finished / error.
    m.player.observeField("state", "onPlayerState")
end sub

' Kick off MovieFetchTask. The Task -> Scene callback runs once the
' worker thread publishes its response field.
sub startCatalogueFetch()
    m.titleLabel.text = "Day-2 implementation — Observers Section 2 + 3"
    m.statusLabel.text = "Loading..."
    m.loading.visible = true
    m.task.url = "pkg:/assets/movies.json"
    m.task.control = "RUN"
end sub

' ======================================================================
' Section 2 callbacks — referenced by name from observeField above.
' ======================================================================

' Exercise 2.1 — no-arg form: framework gives us nothing, so we re-read
' the field from the node we captured on `m`.
sub onCounterChange()
    print "[2.1] observer fired; counter is now " ; m.counterNode.counter
end sub

' Exercise 2.2 — event-payload form: roSGNodeEvent tells us which field
' changed (getField) and what its new value is (getData), so one
' callback can serve many fields.
sub onMovieFieldChange(event as object)
    print "[2.2] observer fired; field=" ; event.getField() ; "    new value=" ; event.getData()
end sub

' Exercise 2.3 — same shape as 2.2; tag differs so the console log is
' unambiguous about which exercise this came from.
sub onTempCounterChange(event as object)
    print "[2.3] observer fired; counter -> " ; event.getData()
end sub

' Exercise 2.4 — two callbacks proving the strict-vs-alwaysNotify
' difference. Same payload shape; only the tag and source node differ.
sub onStrictCounterChange(event as object)
    print "[2.4 strict] fired with " ; event.getData()
end sub

sub onAlwaysCounterChange(event as object)
    print "[2.4 always] fired with " ; event.getData()
end sub

' ======================================================================
' Section 3 callbacks — the real-world patterns the day-2 channel uses.
' ======================================================================

' --- Exercise 3.1 — Task -> Scene communication -----------------------
'   Mirrors exercises/day-02/02-Observers/3.1-task-to-scene.brs
'   Fires ONCE on the render thread when MovieFetchTask (running on its
'   own worker thread) writes `m.top.response` from its functionName.
sub onMoviesLoaded(event as object)
    m.loading.visible = false
    response = event.getData()

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

    print "[3.1] onMoviesLoaded fired (" ; m.movies.count() ; " movies, error='" ; response.error ; "')"

    m.statusLabel.text = "Loaded " + StrI(m.movies.count()).Trim() + " movies"
    populateGrid(m.movies)
    showBrowseUi()
    m.grid.setFocus(true)
end sub

' --- Exercise 3.2 — Grid focus / selection ----------------------------
'   Mirrors exercises/day-02/02-Observers/3.2-grid-selection.brs
'   itemFocused changes as the user scrolls; itemSelected changes only
'   when they press OK. Both are observable on every focusable list.
sub onItemFocused(event as object)
    idx = event.getData()
    if idx < 0 or idx >= m.movies.count() then return
    print "[3.2] focus -> " ; idx ; "   (" ; m.movies[idx].title ; ")"
end sub

sub onItemSelected(event as object)
    idx = event.getData()
    if idx < 0 or idx >= m.movies.count() then return
    print "[3.2] OK    -> " ; idx ; "   (" ; m.movies[idx].title ; ")"
    playMovie(m.movies[idx])
end sub

' --- Exercise 3.3 — Video state machine -------------------------------
'   Mirrors exercises/day-02/02-Observers/3.3-video-state-machine.brs
'   One observable field drives the whole UI lifecycle of playback.
sub onPlayerState(event as object)
    state = event.getData()
    if state = invalid then return

    print "[3.3] state=" ; state

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

' ======================================================================
' Helpers used by the Section 3 callbacks (grid content, player
' lifecycle, UI). Not observable patterns themselves — just the
' infrastructure the patterns need to be exercised end-to-end.
' ======================================================================

' MarkupGrid renders one MovieCard per child of its `content` ContentNode.
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

sub showPlayerError()
    code = m.player.errorCode
    if code = invalid then code = -1

    msg = m.player.errorMsg
    if msg = invalid or Len(msg) = 0 then msg = "Playback failed"

    print "[3.3] errorCode=" ; code ; " msg=" ; msg
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

' BACK key returns to the grid when the player is open; otherwise let
' SceneGraph use its default behaviour (which closes the channel).
function onKeyEvent(key as string, press as boolean) as boolean
    if not press then return false

    if key = "back" and m.isPlaying then
        closePlayer()
        return true
    end if

    return false
end function
