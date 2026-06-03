' Day 3 / 03 — HomeScene (test harness on day3-implementation)
'
' Copied from exercises/day-03/03-Task-Nodes/2.1-home-scene.brs so the
' channel can actually sideload it. Logic is unchanged from the exercise:
'
'   create MovieTask -> observeField("content") -> control = "RUN"
'   onMoviesLoaded -> print getChildCount() -> grid.content = tree
'
' The exercise XML used a RowList; here we render the flat tree with a
' MarkupGrid (id still "rowList") + the existing MovieCard, so no extra
' item component is needed. The .brs is identical either way: findNode,
' .content, and setFocus all work on MarkupGrid too.

sub init()
    m.statusLabel = m.top.findNode("statusLabel")
    m.rowList = m.top.findNode("rowList")

    ' Exercise 2: create Task, subscribe, start.
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

    m.rowList.content = content
    m.statusLabel.text = "Loaded " + count.ToStr() + " movies"
    m.rowList.setFocus(true)
end sub
