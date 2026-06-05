' Day 4 / 04 / Exercise 4 — Focus & Selection (BrightScript half)
'
' Paired with 4.1-focus-selection-scene.xml.
'
' The point of this exercise: prove that you read a list's navigation
' state purely by OBSERVING two fields. No remote polling, no onKeyEvent.
'
'   itemFocused   integer  changes as the user scrolls   -> "Focused: X"
'   itemSelected  integer  changes when OK is pressed     -> "Selected: X"
'
' Both callbacks receive an roSGNodeEvent. event.getData() is the new
' integer index. We map index -> title through a parallel array we kept
' on m (the same two-array discipline used across the channel).
'
' Senior gotchas (worth memorizing):
'   - itemSelected is "sticky": pressing OK on the SAME index twice does
'     not re-fire unless the field is alwaysNotify=true. Channels rely on
'     the user moving focus between selections.
'   - itemFocused fires on EVERY scroll tick. Keep its callback cheap —
'     no network, no rebuilds. Do heavy work (load details, play) in
'     itemSelected instead.
'
' Expected console (scroll to Interstellar, press OK):
'   [4.4] FocusSelectionScene init; 5 movies bound
'   [4.4] Focused: Inception
'   [4.4] Focused: Interstellar
'   [4.4] Selected: Interstellar

sub init()
    m.movieGrid = m.top.findNode("movieGrid")
    m.focusedLabel = m.top.findNode("focusedLabel")
    m.selectedLabel = m.top.findNode("selectedLabel")

    ' Parallel array: the observers get an index; we resolve the title here.
    m.titles = ["Interstellar", "Inception", "Oppenheimer", "Dunkirk", "Tenet"]

    m.movieGrid.content = buildGridContent(m.titles)

    ' Subscribe BEFORE giving focus, so the first focus event is caught.
    m.movieGrid.observeField("itemFocused", "onFocused")
    m.movieGrid.observeField("itemSelected", "onSelected")

    print "[4.4] FocusSelectionScene init; " ; m.titles.count() ; " movies bound"

    m.movieGrid.setFocus(true)
end sub

function buildGridContent(titles as object) as object
    root = createObject("roSGNode", "ContentNode")
    for each title in titles
        item = createObject("roSGNode", "ContentNode")
        item.title = title
        poster = "https://picsum.photos/seed/" + LCase(title) + "/200/260"
        item.hdGridPosterUrl = poster
        item.hdPosterUrl = poster
        root.appendChild(item)
    end for
    return root
end function

' Fires on every scroll tick — keep it cheap.
sub onFocused(event as object)
    idx = event.getData()
    if idx < 0 or idx >= m.titles.count() then return
    title = m.titles[idx]
    print "[4.4] Focused: " ; title
    m.focusedLabel.text = "Focused: " + title
end sub

' Fires once per OK press, after focus settles.
sub onSelected(event as object)
    idx = event.getData()
    if idx < 0 or idx >= m.titles.count() then return
    title = m.titles[idx]
    print "[4.4] Selected: " ; title
    m.selectedLabel.text = "Selected: " + title
end sub
