' Day 2 / Observers / 3.3 — Video state machine observer
'
' Runs in: a real Roku device, or brs-engine.
'
' The Video node is the classic example of "one observable field drives a
' whole state machine." Its `state` field walks through these values:
'
'   "none"        -> initial, before play
'   "buffering"   -> opening / downloading enough to start
'   "playing"     -> media is actively rendering
'   "paused"      -> trick-play pause
'   "stopped"     -> control was stopped externally
'   "finished"    -> reached end of stream
'   "error"       -> playback failed; read errorCode / errorMsg
'
' One observer, one state machine, multiple UI reactions. Mirrors
' `onPlayerState` from MainScene.brs.
'
' Sub-fields you'll observe alongside `state`:
'   position           integer  current playback position in seconds
'                                (frequency capped by `notificationInterval`)
'   duration           integer  total stream length once known
'   contentIsPlaylist  boolean  HLS variant manifest available, etc.
'
' Senior gotchas:
'   - `state` is alwaysNotify=true on a real Video node, so observing
'     "buffering" twice in a row (rebuffer) does fire twice. Use this for
'     spinner control.
'   - The Video node clears `errorCode` and `errorMsg` on the NEXT
'     `play`. Read both inside the observer; don't read them later.
'   - When closing the player, reset:
'         m.player.control = "stop"
'         m.player.content = invalid
'     This is exactly what `closePlayer` in MainScene does.
'
' BrightScript / SceneGraph                        JavaScript / HTMLMediaElement equivalent
' ----------------------------------------------   ----------------------------------------------
' m.player.observeField("state", "onState")        video.addEventListener("playing", onPlay)
'                                                  video.addEventListener("ended",   onEnd)
'                                                  video.addEventListener("error",   onErr)
'                                                  (Roku unifies them into one field;
'                                                   you switch inside the callback.)
'
' Expected device output (one successful playback of a stream):
'   [video] state=buffering
'   [video] state=playing
'   [video] state=finished
sub init()
    m.player = m.top.findNode("moviePlayer")
    m.player.observeField("state", "onPlayerState")
end sub

sub onPlayerState(event as object)
    state = event.getData()
    if state = invalid then return

    print "[video] state=" ; state

    if state = "buffering" then
        showSpinner(true)
    else if state = "playing" then
        showSpinner(false)
    else if state = "paused" then
        ' user pressed trick-play pause; nothing to do
    else if state = "error" then
        showSpinner(false)
        printError()
    else if state = "finished" then
        closePlayer()
    end if
end sub

sub showSpinner(visible as boolean)
    print "  spinner = " ; visible
end sub

sub printError()
    code = m.player.errorCode
    if code = invalid then code = -1
    msg = m.player.errorMsg
    if msg = invalid or Len(msg) = 0 then msg = "Playback failed"
    print "  error(" ; code ; "): " ; msg
end sub

sub closePlayer()
    m.player.control = "stop"
    m.player.content = invalid
    print "  player closed"
end sub
