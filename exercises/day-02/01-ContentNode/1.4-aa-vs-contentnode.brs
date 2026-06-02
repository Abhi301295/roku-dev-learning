' Day 2 / 1.4 — AA vs ContentNode: when to use which
'
' BrightScript channels juggle two "object-shaped" things constantly:
'   Associative Array (AA)   pure data, the JSON shape from the API
'   ContentNode              a Node the SceneGraph framework can render
'
' Rule of thumb:
'   - Data in flight (HTTP response, ParseJSON result, helpers, state):
'     keep it as an AA. Cheap, easy to log, easy to map / filter / reduce.
'   - Data the framework will RENDER (grid.content, video.content,
'     rowlist.content): build a ContentNode tree at the last moment.
'
' BrightScript                          JavaScript equivalent           Notes
' ------------------------------------  ------------------------------  ------------------------------
' { title: "x" }                        { title: "x" }                  AA: plain data, fast to build
' createObject("roSGNode","ContentNode") document.createElement("div")  Node: framework-managed
' aa.title                              aa.title                        AA reads any key directly
' node.title                            node.title                      Node reads only DECLARED fields
' aa.foo = "anything"                   aa.foo = "anything"             AA accepts any new key
' node.foo = "anything"                 node.foo = "anything" (custom)  Node: silently rejected unless
'                                                                       it was added via addField()
' for each k in aa: ... : end for       for (const k in obj) {...}      iterate AA keys
' node.getFields()                      Object.entries(el.dataset)      Node: ask for the field bag
'
' Common mistake (don't do this):
'   m.grid.content = { items: movies }       ' AA -> grid does nothing
'
' Correct:
'   root = createObject("roSGNode", "ContentNode")
'   for each movie in movies
'       item = createObject("roSGNode", "ContentNode")
'       item.title = movie.title
'       root.appendChild(item)
'   end for
'   m.grid.content = root                    ' Node tree -> grid renders
'
' Run: brs 1.4-aa-vs-contentnode.brs
sub Main()
    movie = { title: "Inception", rating: 8.8, durationMins: 148 }

    print "--- AA ---"
    print "type      = " ; type(movie)            ' roAssociativeArray (both runtimes)
    print "title     = " ; movie.title
    print "rating    = " ; movie.rating
    print "any key   = " ; movie.anythingGoes     ' invalid, no error

    movie.newKey = "added on the fly"             ' AAs accept any key
    print "newKey    = " ; movie.newKey

    print ""
    print "--- ContentNode from the same AA ---"
    node = aaToContentNode(movie)
    print "type      = " ; type(node)             ' roSGNode (device) / Node (brs CLI)
    print "subtype   = " ; node.subtype()         ' ContentNode
    print "title     = " ; node.title
    print "duration  = " ; node.durationMins ; " mins"

    ' AA dump style: easy. Node dump style: getFields() returns an AA.
    print ""
    print "node.getFields() ="
    fields = node.getFields()
    for each key in fields
        print "  " ; key ; " = " ; fields[key]
    end for
end sub

' Builds a ContentNode from a movie AA. Standard fields (title,
' description) are set directly; custom keys are declared first.
function aaToContentNode(movie as object) as object
    node = createObject("roSGNode", "ContentNode")
    node.title       = movie.title
    node.description = "Rating " + movie.rating.ToStr()

    ' Declare the app-specific fields before writing them.
    ' (Note: `rating` is already a built-in STRING field on ContentNode,
    ' so the numeric IMDb score goes into a separate custom field.)
    node.addFields({
        durationMins: movie.durationMins
        imdbRating: movie.rating
    })
    return node
end function
