' Day 3 / 03 / Exercises 2 & 3 — Consume MovieTask from HomeScene
'
' Paired with 2.1-home-scene.xml.
'
' Exercise 2 — wire the Task:
'
'   m.movieTask = createObject("roSGNode", "MovieTask")
'   m.movieTask.observeField("content", "onMoviesLoaded")
'   m.movieTask.control = "RUN"
'
' Exercise 3 — handle the result in onMoviesLoaded():
'
'   content = m.movieTask.content
'   print content.getChildCount()    ' 1 with tasks/1.1, 3 with 1.2/1.3
'
' The Task runs on another thread. When it sets m.top.content, the
' platform marshals the node reference and fires this callback on the
' render thread — same reactive chain as Day 2 Observers 3.1, but the
' payload is a ContentNode tree instead of an assocarray.
'
' Expected console with tasks/1.1-movie-task:
'   [3.1] HomeScene init; starting MovieTask
'   [3.1] MovieTask init; functionName = loadMovies
'   [3.1] loadMovies running on Task thread
'   [3.1] publishing content (1 child)
'   [3.1] onMoviesLoaded; child count = 1
'   [3.1]   - Interstellar
'
' With tasks/1.2 or 1.3, child count = 3.

sub init()
    m.statusLabel = m.top.findNode("statusLabel")
    m.rowList = m.top.findNode("rowList")

    ' Exercise 2: create Task, subscribe, start.
    ' "MovieTask" must match <component name="MovieTask"> in MovieTask.xml.
    ' The linter flags this because MovieTask.xml is reference code under
    ' exercises/ (not in the channel build) until you copy it to
    ' components/tasks/ for sideload. The line is correct at runtime; we
    ' silence the editor-only "Unknown roSGNode" warning here.
    ' bs:disable-next-line
    m.movieTask = createObject("roSGNode", "MovieTask")
    m.movieTask.observeField("content", "onMoviesLoaded")
    m.movieTask.control = "RUN"

    print "[3.1] HomeScene init; starting MovieTask"
    m.statusLabel.text = "Loading movies..."
end sub

' Exercise 3: runs on the render thread when the Task publishes content.
sub onMoviesLoaded()
    content = m.movieTask.content
    if content = invalid then
        print "[3.1] onMoviesLoaded; content is invalid"
        m.statusLabel.text = "Task returned no content"
        return
    end if

    count = content.getChildCount()
    print "[3.1] onMoviesLoaded; child count = " ; count

    for each child in content.getChildren(-1, 0)
        title = child.title
        if title = invalid then title = "(untitled)"
        print "[3.1]   - " ; title
    end for

    ' Full pipeline: Task -> ContentNode -> RowList (topic 02).
    m.rowList.content = content
    m.statusLabel.text = "Loaded " + count.ToStr() + " movies"
    m.rowList.setFocus(true)
end sub
