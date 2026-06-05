' Day 4 / 07 / Exercises 1–3 — Menu navigation (BrightScript half)
'
' Paired with 2.1-menu-navigation-scene.xml.
'
' Exercise 1 — Home / Settings / Profile in a LabelList.
'   UP / DOWN navigation is automatic once the list has focus.
'
' Exercise 2 — Press OK on Settings.
'   itemSelected fires -> we print exactly:
'     Selected Settings
'
' Exercise 3 — Press BACK on the Settings (or Profile) screen.
'   onKeyEvent pops the navigation stack and returns to the menu.
'
' Navigation stack (manual — Roku has no router):
'
'   m.navStack = ["menu"]
'   pushScreen("settings")  -> stack = ["menu", "settings"]
'   popScreen()               -> stack = ["menu"]
'
' React equivalent:
'   router.push("/settings")   -> pushScreen
'   router.back()              -> popScreen (on BACK key)
'
' Expected console:
'   [4.7] MenuNavigationScene init; 3 menu items
'   [4.7] focus -> 1   (Settings)
'   [4.7] Selected Settings
'   [4.7] push -> settings   stack = menu, settings
'   [4.7] BACK -> pop to menu

sub init()
    m.menuScreen = m.top.findNode("menuScreen")
    m.settingsScreen = m.top.findNode("settingsScreen")
    m.profileScreen = m.top.findNode("profileScreen")
    m.mainMenu = m.top.findNode("mainMenu")
    m.statusLabel = m.top.findNode("statusLabel")

    m.menuItems = ["Home", "Settings", "Profile"]
    m.mainMenu.content = buildMenuContent(m.menuItems)

    m.mainMenu.observeField("itemFocused", "onMenuFocused")
    m.mainMenu.observeField("itemSelected", "onMenuSelected")

    ' Navigation stack — top of stack is the current screen name.
    m.navStack = ["menu"]

    print "[4.7] MenuNavigationScene init; " ; m.menuItems.count() ; " menu items"
    m.statusLabel.text = "UP/DOWN: navigate   OK: open   BACK: return"
    m.mainMenu.setFocus(true)
end sub

function buildMenuContent(labels as object) as object
    root = createObject("roSGNode", "ContentNode")
    for each label in labels
        item = createObject("roSGNode", "ContentNode")
        item.title = label
        root.appendChild(item)
    end for
    return root
end function

sub onMenuFocused(event as object)
    idx = event.getData()
    if idx < 0 or idx >= m.menuItems.count() then return
    print "[4.7] focus -> " ; idx ; "   (" ; m.menuItems[idx] ; ")"
end sub

sub onMenuSelected(event as object)
    idx = event.getData()
    if idx < 0 or idx >= m.menuItems.count() then return

    name = m.menuItems[idx]

    ' Exercise 2 — exact print line from the brief.
    if name = "Settings" then
        print "[4.7] Selected Settings"
    else
        print "[4.7] Selected " ; name
    end if

    if name = "Settings" then
        pushScreen("settings")
    else if name = "Profile" then
        pushScreen("profile")
    else if name = "Home" then
        m.statusLabel.text = "Home selected (stay on menu)"
    end if
end sub

' --- Navigation stack ---------------------------------------------------

sub pushScreen(screenName as string)
    m.navStack.push(screenName)
    showScreen(screenName)
    print "[4.7] push -> " ; screenName ; "   stack = " ; stackToString()
end sub

sub popScreen()
    if m.navStack.count() <= 1 then
        print "[4.7] pop ignored — already at root"
        return
    end if

    m.navStack.pop()
    prev = m.navStack[m.navStack.count() - 1]
    showScreen(prev)
    print "[4.7] BACK -> pop to " ; prev

    if prev = "menu" then
        m.mainMenu.setFocus(true)
    end if
end sub

sub showScreen(screenName as string)
    m.menuScreen.visible = (screenName = "menu")
    m.settingsScreen.visible = (screenName = "settings")
    m.profileScreen.visible = (screenName = "profile")
end sub

function stackToString() as string
    parts = []
    for each entry in m.navStack
        parts.push(entry)
    end for
    return parts.join(", ")
end function

' Exercise 3 — BACK pops the stack when not on the root menu.
function onKeyEvent(key as string, press as boolean) as boolean
    if not press then return false

    if key = "back" and m.navStack.count() > 1 then
        popScreen()
        return true
    end if

    return false
end function
