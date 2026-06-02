' Day 2 / Observers / 3.1 — Task → Scene communication
'
' Runs in: a real Roku device, or brs-engine.
'
' This is THE central reactive pattern in every Roku channel. Mirrors
' your own `components/MovieFetchTask.brs` + `components/MainScene.brs`
' wiring:
'
'   MovieFetchTask runs on its OWN thread (Task extends... Task). It
'   blocks on the network without freezing the UI. When it finishes, it
'   writes the result into a field on itself (`m.top.response`). The
'   parent Scene has previously observed that field. The platform
'   marshals the value across threads and fires the Scene's callback on
'   the render thread.
'
' The contract is just three lines on each side:
'
'   --- Scene side (render thread) ---
'   m.task = m.top.findNode("movieTask")
'   m.task.observeField("response", "onMoviesLoaded")
'   m.task.url = "pkg:/assets/movies.json"
'   m.task.control = "RUN"
'
'   --- Task side (worker thread) ---
'   sub init()
'       m.top.functionName = "fetchMovies"
'   end sub
'   function fetchMovies() as void
'       result = { movies: [...], error: "" }    ' or error path
'       m.top.response = result                  ' setting -> observer fires
'   end function
'
' Why this is "reactive":
'   - The Scene never polls. It declares interest once, then forgets.
'   - The Task never knows who's listening. It just publishes.
'   - Adding a second listener (e.g. an analytics tracker) costs one
'     more observeField call; the Task is unchanged.
'
' Senior gotchas:
'   - `response` is an associative array on a node field. Roku declares
'     it as `assocarray` with alwaysNotify=true so a second identical
'     payload still fires. (See 2.4.)
'   - Never share a Task across threads. Each Task is started by
'     `control = "RUN"` and finishes by setting its output field.
'   - You CANNOT pass a `roSGNode` reference back from the Task as data;
'     fields cross the thread boundary as AAs/strings/numbers.
'
' BrightScript / SceneGraph                        JavaScript equivalent
' ----------------------------------------------   ----------------------------------------------
' m.task.observeField("response", "onLoaded")      worker.addEventListener("message", onLoaded)
' m.task.control = "RUN"                           worker.postMessage({ start: true })
' m.top.response = result                          self.postMessage(result)       // inside worker
'
' Expected device output (after the JSON parses successfully):
'   [scene] starting fetch
'   [task]  worker running on background thread
'   [task]  publishing response
'   [scene] onMoviesLoaded fired (6 movies, error="")
sub init()
    m.task = m.top.findNode("movieTask")
    m.task.observeField("response", "onMoviesLoaded")
end sub

sub startFetch()
    print "[scene] starting fetch"
    m.task.url = "pkg:/assets/movies.json"
    m.task.control = "RUN"
end sub

sub onMoviesLoaded(event as object)
    response = event.getData()
    if response = invalid then
        print "[scene] onMoviesLoaded fired with invalid"
        return
    end if

    count = 0
    if response.movies <> invalid then count = response.movies.count()

    err = ""
    if response.error <> invalid then err = response.error

    print "[scene] onMoviesLoaded fired (" ; count ; " movies, error='" ; err ; "')"
end sub
