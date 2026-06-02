' Day 2 / 3.4 — Real-world pipeline: filter + map + build ContentNode
'
' Ties day-01 (filter/map/reduce on AAs) together with day-02
' (ContentNode tree building). The shape every real channel ends up
' with:
'
'   1. Get raw data       (HTTP / JSON parse)        -> array of AAs
'   2. Filter / sort it   (business rules)           -> array of AAs
'   3. Map to a card AA   (rename / format fields)   -> array of AAs
'   4. Build content tree (ContentNode per item)     -> ContentNode
'   5. Hand to the grid   (m.grid.content = tree)    -> render
'
' Keep steps 1-3 in plain AAs. They are easy to log, easy to test, and
' cheap to rebuild. Step 4 is the only place ContentNode appears.
'
' BrightScript                                  JavaScript / React equivalent       Notes
' --------------------------------------------  ----------------------------------- ------------------------
' filterArray(movies, isRecent)                 movies.filter(isRecent)             same shape, BRS uses
'                                                                                   generic helpers
' mapArray(filtered, toCard)                    .map(toCard)                        per-item formatter
' buildGridContent(cards)                       <Grid items={cards} />              the only Node step
'
' Run: brs 3.4-pipeline-to-content.brs
sub Main()
    catalogue = [
        { title: "Inception",    year: 2010, rating: 8.8, posterUri: "https://picsum.photos/seed/inception/240/320" }
        { title: "Interstellar", year: 2014, rating: 8.6, posterUri: "https://picsum.photos/seed/interstellar/240/320" }
        { title: "Tenet",        year: 2020, rating: 7.4, posterUri: "https://picsum.photos/seed/tenet/240/320" }
        { title: "Oppenheimer",  year: 2023, rating: 8.3, posterUri: "https://picsum.photos/seed/oppenheimer/240/320" }
        { title: "Dunkirk",      year: 2017, rating: 7.9, posterUri: "https://picsum.photos/seed/dunkirk/240/320" }
        { title: "The Prestige", year: 2006, rating: 8.5, posterUri: "https://picsum.photos/seed/prestige/240/320" }
    ]

    ' --- the pipeline (stays in AA land for as long as possible) ---
    recent    = filterArray(catalogue, isRecent)         ' year >= 2014
    wellRated = filterArray(recent,    isWellRated)      ' rating >= 8.0
    cards     = mapArray(wellRated,    toCardAA)         ' rename fields

    print "matched " ; cards.count() ; " cards:"
    for each c in cards
        print "  - " ; c.title ; "   " ; c.description
    end for

    ' --- the ONLY step that uses ContentNode ---
    gridContent = buildGridContent(cards)

    print ""
    print "grid children = " ; gridContent.getChildCount()
    print "first card type     = " ; type(gridContent.getChild(0))     ' roSGNode (device) / Node (brs CLI)
    print "first card subtype  = " ; gridContent.getChild(0).subtype() ' ContentNode

    ' Generic field-map version of the same builder. Useful when you have
    ' many different AA shapes feeding the same grid (search results,
    ' recommendations, watch history) and want one code path.
    fieldMap = {
        title:       "title"
        hdPosterUrl: "posterUri"
        description: "ratingLine"
    }
    genericTree = buildContentNodeList(cards, fieldMap)
    print "generic builder children = " ; genericTree.getChildCount()
end sub

' --- generic helpers from day 1 ---

function filterArray(arr as object, predicate as function) as object
    out = []
    for each item in arr
        if predicate(item) then out.push(item)
    end for
    return out
end function

function mapArray(arr as object, transform as function) as object
    out = []
    for each item in arr
        out.push(transform(item))
    end for
    return out
end function

' --- predicates / mappers ---

function isRecent(movie as object) as boolean
    return movie.year >= 2014
end function

function isWellRated(movie as object) as boolean
    return movie.rating >= 8.0
end function

' Maps a raw movie AA into a "card AA" with exactly the keys the grid
' wants to read. Doing this rename here means the ContentNode builder
' becomes trivial.
function toCardAA(movie as object) as object
    return {
        title: movie.title
        posterUri: movie.posterUri
        ratingLine: "Rating " + movie.rating.ToStr() + " - " + StrI(movie.year).Trim()
        description: "Rating " + movie.rating.ToStr() + " - " + StrI(movie.year).Trim()
    }
end function

' --- ContentNode builders ---

' Specific builder: knows the exact field names. This is what
' MainScene.populateGrid does today.
function buildGridContent(cards as object) as object
    root = createObject("roSGNode", "ContentNode")
    for each c in cards
        item = createObject("roSGNode", "ContentNode")
        item.title       = c.title
        item.hdPosterUrl = c.posterUri
        item.description = c.description
        root.appendChild(item)
    end for
    return root
end function

' Generic builder: takes a fieldMap { contentNodeField: sourceAaKey }.
' Same idea as mapArray/transform from day 1 — one helper that works for
' every grid feed you ever write.
function buildContentNodeList(items as object, fieldMap as object) as object
    root = createObject("roSGNode", "ContentNode")
    for each item in items
        node = createObject("roSGNode", "ContentNode")
        for each cnField in fieldMap
            sourceKey = fieldMap[cnField]
            node[cnField] = item[sourceKey]
        end for
        root.appendChild(node)
    end for
    return root
end function
