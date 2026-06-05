' Day 4 / 08 / Exercise 4 — Navigation stack: Home → Details → Player
'
' Paired with 4.1-movie-flow-scene.xml.
'
' Three-screen flow managed by a manual stack:
'
'   home  ->  details  ->  player
'     ^          ^           |
'     |          |___________|  (BACK pops one level at a time)
'
' Transitions:
'   Home:     itemSelected on grid  -> pushScreen("details")
'   Details:  itemSelected on "Play" -> pushScreen("player")
'   Any:      BACK key              -> popScreen()
'
' This is the same architecture as components/MainScene.brs, which
' toggles browse UI vs playerLayer and uses onKeyEvent for BACK.
'
' Expected console:
'   [4.8] MovieFlowScene init
'   [4.8] stack = home
'   [4.8] Selected Interstellar
'   [4.8] push -> details   stack = home, details
'   [4.8] Selected Play
'   [4.8] push -> player   stack = home, details, player
'   [4.8] BACK -> pop to details
'   [4.8] BACK -> pop to home

sub init()
    m.homeScreen = m.top.findNode("homeScreen")
    m.detailsScreen = m.top.findNode("detailsScreen")
    m.playerScreen = m.top.findNode("playerScreen")
    m.homeGrid = m.top.findNode("homeGrid")
    m.detailsTitle = m.top.findNode("detailsTitle")
    m.detailsSynopsis = m.top.findNode("detailsSynopsis")
    m.detailsActions = m.top.findNode("detailsActions")
    m.playerTitle = m.top.findNode("playerTitle")
    m.stackLabel = m.top.findNode("stackLabel")

    m.movie = {
        title: "Interstellar"
        synopsis: "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival."
        poster: "https://picsum.photos/seed/interstellar/200/260"
    }

    m.homeGrid.content = buildHomeContent(m.movie)
    m.homeGrid.observeField("itemSelected", "onHomeSelected")

    m.detailsActions.content = buildActionContent(["Play"])
    m.detailsActions.observeField("itemSelected", "onDetailsAction")

    m.navStack = ["home"]
    updateStackLabel()

    print "[4.8] MovieFlowScene init"
    print "[4.8] stack = home"

    m.homeGrid.setFocus(true)
end sub

function buildHomeContent(movie as object) as object
    root = createObject("roSGNode", "ContentNode")
    item = createObject("roSGNode", "ContentNode")
    item.title = movie.title
    item.hdGridPosterUrl = movie.poster
    item.hdPosterUrl = movie.poster
    root.appendChild(item)
    return root
end function

function buildActionContent(labels as object) as object
    root = createObject("roSGNode", "ContentNode")
    for each label in labels
        node = createObject("roSGNode", "ContentNode")
        node.title = label
        root.appendChild(node)
    end for
    return root
end function

sub onHomeSelected(event as object)
    idx = event.getData()
    if idx <> 0 then return

    print "[4.8] Selected " ; m.movie.title
    m.detailsTitle.text = m.movie.title
    m.detailsSynopsis.text = m.movie.synopsis
    pushScreen("details")
    m.detailsActions.setFocus(true)
end sub

sub onDetailsAction(event as object)
    idx = event.getData()
    if idx <> 0 then return

    print "[4.8] Selected Play"
    m.playerTitle.text = "Now playing: " + m.movie.title
    pushScreen("player")
end sub

' --- Navigation stack ---------------------------------------------------

sub pushScreen(screenName as string)
    m.navStack.push(screenName)
    showScreen(screenName)
    updateStackLabel()
    print "[4.8] push -> " ; screenName ; "   stack = " ; stackToString()
end sub

sub popScreen()
    if m.navStack.count() <= 1 then return

    m.navStack.pop()
    prev = m.navStack[m.navStack.count() - 1]
    showScreen(prev)
    updateStackLabel()
    print "[4.8] BACK -> pop to " ; prev

    if prev = "home" then
        m.homeGrid.setFocus(true)
    else if prev = "details" then
        m.detailsActions.setFocus(true)
    end if
end sub

sub showScreen(screenName as string)
    m.homeScreen.visible = (screenName = "home")
    m.detailsScreen.visible = (screenName = "details")
    m.playerScreen.visible = (screenName = "player")
end sub

sub updateStackLabel()
    m.stackLabel.text = "stack: " + stackToString()
end sub

function stackToString() as string
    parts = []
    for each entry in m.navStack
        parts.push(entry)
    end for
    return parts.join(" → ")
end function

function onKeyEvent(key as string, press as boolean) as boolean
    if not press then return false

    if key = "back" and m.navStack.count() > 1 then
        popScreen()
        return true
    end if

    return false
end function
