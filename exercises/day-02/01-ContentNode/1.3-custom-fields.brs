' Day 2 / 1.3 — Custom (dynamic) fields with addField / addFields
'
' The built-in metadata fields cover the common cases, but real channels
' carry app-specific data: IMDb rating as a float, "is4k" flags, internal
' ids, analytics tags, etc. Those need addField first, then they behave
' like any other field.
'
' Why declare them at all?
'   - ContentNode rejects unknown writes silently. `node.foo = 1` on a
'     field that was never declared is a no-op, and `node.foo` reads back
'     `invalid`.
'   - addField also gives you a type (so the platform validates writes)
'     and an "alwaysNotify" flag for observers (covered in a later day).
'
' BrightScript                                          JavaScript equivalent          Notes
' ----------------------------------------------------  ----------------------------- ----------------------------
' node.addField("imdbRating", "float", true)            node.imdbRating = 8.8         BRS: must DECLARE first
' node.addFields({ a: 1, b: "x" })                      Object.assign(node, {...})    declare + set in one call
' node.imdbRating = 8.8                                 node.imdbRating = 8.8         dot-set after declaration
' node.getField("imdbRating")                           node["imdbRating"]            dynamic key read
' node.removeField("imdbRating")                        delete node.imdbRating        drop the field
' node.unknown                                          obj.unknown                   BRS: invalid (no error)
'                                                                                     JS: undefined
'
' addField signature:
'   node.addField(name as string, type as string, alwaysNotify as boolean)
'     name          field name, dot-accessible afterwards
'     type          "string", "integer", "float", "boolean", "node",
'                   "array", "assocarray", "color", ...
'     alwaysNotify  true => observer fires even when the new value equals
'                   the previous value
'
' Run: brs 1.3-custom-fields.brs
sub Main()
    node = createObject("roSGNode", "ContentNode")
    node.title = "Inception"

    ' --- declare one at a time ---
    node.addField("imdbRating", "float", true)
    node.addField("is4k", "boolean", true)
    node.addField("genre", "string", true)

    node.imdbRating = 8.8
    node.is4k = true
    node.genre = "Sci-Fi"

    print "imdbRating = " ; node.imdbRating
    print "is4k       = " ; node.is4k
    print "genre      = " ; node.genre

    ' --- declare + set as a batch with addFields ---
    ' addFields takes an AA: { name: defaultValue, ... }. Each entry is
    ' declared as a "dynamic" field with that initial value.
    '
    ' Caveat: some BRS runtimes (notably the `brs` CLI) declare the
    ' field but do not seed string defaults. To stay portable, declare
    ' once with addFields and then dot-assign anything you need to read
    ' back immediately.
    node.addFields({
        durationMins: 148
        director: ""
    })
    node.director = "Christopher Nolan"

    print "duration   = " ; node.durationMins ; " mins"
    print "director   = " ; node.director

    ' --- pitfall: writing to an undeclared field is silently ignored ---
    node.notAField = "won't stick"
    print "notAField  = " ; node.notAField     ' invalid

    ' --- dynamic-key read with getField ---
    print "via getField = " ; node.getField("imdbRating")

    ' --- removeField ---
    node.removeField("genre")
    print "genre after remove = " ; node.genre   ' invalid
end sub
