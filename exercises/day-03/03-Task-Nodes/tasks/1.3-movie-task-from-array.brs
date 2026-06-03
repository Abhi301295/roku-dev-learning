' Day 3 / 03 / Exercise 5 — AA array -> ContentNode inside the Task
'
' Production apps follow the same steps after a real API call:
'
'   1. Fetch / read JSON on the Task thread (blocking is OK here).
'   2. Parse into BrightScript data (array of AAs or strings).
'   3. buildContentFromTitles(...) -> ContentNode tree.
'   4. m.top.content = tree -> Scene observer -> RowList.content.
'
' This exercise skips HTTP and starts at step 2 with a string array.
'
' Input:
'   movies = ["Interstellar", "Inception", "Oppenheimer"]
'
' Output tree:
'   (root)
'   ├── Interstellar
'   ├── Inception
'   └── Oppenheimer

sub init()
    m.top.functionName = "loadMovies"
    print "[3.1] MovieTask init (from-array build)"
end sub

function loadMovies() as void
    print "[3.1] loadMovies running on Task thread"

    movies = [
        "Interstellar"
        "Inception"
        "Oppenheimer"
    ]

    content = buildContentFromTitles(movies)

    print "[3.1] publishing content (" ; content.getChildCount() ; " children)"
    m.top.content = content
end function

' Exercise 5 helper: turn a flat string list into a one-level tree.
' Swap the input for parsed JSON rows once you add a real API call.
function buildContentFromTitles(titles as object) as object
    root = createObject("roSGNode", "ContentNode")

    for each title in titles
        item = createObject("roSGNode", "ContentNode")
        item.title = title
        root.appendChild(item)
    end for

    return root
end function
