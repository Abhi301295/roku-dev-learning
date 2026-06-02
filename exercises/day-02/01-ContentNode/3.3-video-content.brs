' Day 2 / 3.3 — Build the Video node's content
'
' The Video node also reads a ContentNode, but it cares about a DIFFERENT
' set of fields: the stream URL, the format, optional bitrate hints, an
' optional title for the overlay. It does NOT use children — it consumes
' the single ContentNode you assign to `content`.
'
' Minimum fields:
'   url           string   stream URL          (required)
'   streamFormat  string   "hls" / "dash" / "mp4" / "ism" / ...  (required)
'   title         string   shown by enableUI/trickPlay overlays
'
' Useful extras:
'   length        integer  total runtime in seconds (progress bar)
'   subtitleTracks      array of { Url, Language, ... }
'   streamBitrates      array of integers (adaptive bitrates, "0" = default)
'   streamUrls          array of strings (parallel to streamBitrates)
'
' BrightScript                                  JavaScript / HTMLVideoElement       Notes
' --------------------------------------------  ----------------------------------- ------------------------
' content.url = "https://.../master.m3u8"       videoEl.src = "https://.../master"  the URL itself
' content.streamFormat = "hls"                  (browser infers from MIME or .m3u8) BRS must be told
' content.title = "Inception"                   videoEl.title = "Inception"         overlay title
' content.length = 148 * 60                     videoEl.duration (read-only)        BRS: seconds, you set it
' m.player.content = content                    videoEl.load(); videoEl.play()      hand to the framework
' m.player.control = "play"                     videoEl.play()                      explicit kick-off
'
' Run: brs 3.3-video-content.brs
sub Main()
    movie = {
        title: "Inception"
        videoUrl: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"
        videoFormat: "hls"
        durationMins: 148
    }

    content = buildVideoContent(movie)

    print "title         = " ; content.title
    print "url           = " ; content.url
    print "streamFormat  = " ; content.streamFormat
    print "length (s)    = " ; content.length

    ' In a real component:
    '   m.player.content = content
    '   m.player.control = "play"

    ' --- Guard: validate before handing to the Video node ---
    print ""
    bad = { title: "Broken", videoUrl: "", videoFormat: "hls" }
    err = validateMovieForPlayback(bad)
    if Len(err) > 0 then
        print "[skip play] " ; err
    end if

    ok = validateMovieForPlayback(movie)
    print "ok? " ; (Len(ok) = 0)
end sub

' Mirror of MainScene.playMovie's content-building block, isolated so we
' can unit-test it from the CLI.
function buildVideoContent(movie as object) as object
    content = createObject("roSGNode", "ContentNode")
    content.title        = movie.title
    content.url          = movie.videoUrl
    content.streamFormat = movie.videoFormat

    if movie.durationMins <> invalid then
        content.length = movie.durationMins * 60
    end if

    return content
end function

' Returns "" on success, else a human-readable error string. Use this
' BEFORE setting m.player.content to avoid a confusing "state=error"
' from the Video node.
function validateMovieForPlayback(movie as object) as string
    if movie = invalid then return "movie is invalid"
    if movie.videoUrl = invalid or Len(movie.videoUrl) = 0 then
        return "missing videoUrl"
    end if
    if movie.videoFormat = invalid or Len(movie.videoFormat) = 0 then
        return "missing videoFormat"
    end if
    return ""
end function
