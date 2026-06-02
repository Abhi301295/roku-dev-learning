' Day 2 / 1.2 — Standard fields on ContentNode
'
' ContentNode ships with a long list of pre-declared fields that the
' built-in nodes (MarkupGrid, RowList, Video, etc.) already know how to
' read. You don't need to declare them — just set them.
'
' Common metadata fields (full list: SceneGraph "Content Meta-Data" docs):
'   title           string   shown by grids and players
'   description     string   short blurb / second line
'   shortDescriptionLine1 / 2 string  alternative short lines (some lists)
'   hdPosterUrl     string   poster for HD layouts (most channels use this)
'   sdPosterUrl     string   poster for SD layouts
'   fhdPosterUrl    string   poster for full-HD layouts
'   releaseDate     string   "YYYY-MM-DD"
'   length          integer  runtime in seconds (used by Video progress UI)
'   rating          string   "TV-MA", "PG-13", ... (string, not a number!)
'   url             string   stream URL          (used by Video.content)
'   streamFormat    string   "hls" / "dash" / "mp4" / ...  (Video)
'
' BrightScript                                  JavaScript equivalent          Notes
' --------------------------------------------  ----------------------------- ---------------------------
' node.title = "Inception"                      obj.title = "Inception"       built-in, no addField needed
' node.hdPosterUrl = "https://..."              obj.hdPosterUrl = "https://"  grids read this directly
' node.length = 148 * 60                        obj.length = 148 * 60         integer SECONDS, not minutes
' node.rating = "PG-13"                         obj.rating = "PG-13"          STRING, not the numeric IMDB
' node.releaseDate = "2010-07-16"               obj.releaseDate = "..."       ISO date string
' node.url = "https://.../movie.m3u8"           obj.url = "..."               consumed by Video.content
' node.streamFormat = "hls"                     obj.streamFormat = "hls"      must match the URL type
'
' Run: brs 1.2-standard-fields.brs
sub Main()
    node = createObject("roSGNode", "ContentNode")

    node.title         = "Inception"
    node.description   = "A thief who steals corporate secrets through dream-sharing tech."
    node.hdPosterUrl   = "https://picsum.photos/seed/inception/240/320"
    node.releaseDate   = "2010-07-16"
    node.length        = 148 * 60        ' 148 minutes -> seconds
    node.rating        = "PG-13"         ' STRING, not the IMDb 8.8
    node.url           = "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"
    node.streamFormat  = "hls"

    print "title        = " ; node.title
    print "description  = " ; node.description
    print "hdPosterUrl  = " ; node.hdPosterUrl
    print "releaseDate  = " ; node.releaseDate
    print "length (s)   = " ; node.length
    print "rating       = " ; node.rating
    print "url          = " ; node.url
    print "streamFormat = " ; node.streamFormat

    ' Pitfall: passing a number to a string field. ContentNode coerces /
    ' rejects depending on the field. `rating` is declared as string, so
    ' setting it to a number is a no-op (silently keeps the previous value).
    badRating = createObject("roSGNode", "ContentNode")
    badRating.rating = 8.8                  ' wrong type, ignored
    print "bad rating   = '" ; badRating.rating ; "'"   ' empty string
end sub
