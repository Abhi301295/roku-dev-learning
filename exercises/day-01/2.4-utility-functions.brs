' Day 1 / 9 — Utility functions (formatters, guards, transforms)
'
' Most channels build a small library of pure helpers. They take input,
' return output, and don't mutate global state.
'
' BrightScript                              JavaScript equivalent              Notes
' ----------------------------------------  ---------------------------------  -----------------------
' a \ b                                     Math.floor(a / b)                  BRS: integer division
'                                           (a / b) | 0                        JS has no `\` operator
' a - (b * c)                               a - b * c                          same arithmetic
' Len(s)                                    s.length                           BRS function vs JS prop
' StrI(n).Trim()                            String(n)                          stringify integer
' "$" + StrI(n).Trim() + ".00"              `$${n}.00`                         template literal in JS
' n < 10                                    n < 10                             same
' value = invalid                           value == null                      `==` matches null+undefined
' type(v) = "String" or                     typeof v === "string"              BRS: also check "roString"
'   type(v) = "roString"                                                       (boxed form)
' arr.push(x)                               arr.push(x)                        same
' for each x in arr                         for (const x of arr)
'   out.push(x)                               out.push(x)
' end for                                   }
'
' "Default fallback" pattern:
' if isNonEmpty(a) then return a            return a ?? b ?? c                 JS nullish-coalescing
' if isNonEmpty(b) then return b            (only if "non-empty" = "not null")
' return c
'
' Run: brs utility-functions.brs
sub Main()
    print formatPrice(199)
    print formatDuration(3725)

    title = pickFirst(invalid, "", "Inception")
    print "title = " + title

    titles = mapTitles([
        { title: "Inception" },
        { title: "Interstellar" },
        { title: "Oppenheimer" }
    ])
    for each t in titles
        print "- " + t
    end for
end sub

function formatPrice(amount as integer) as string
    return "$" + StrI(amount).Trim() + ".00"
end function

function formatDuration(seconds as integer) as string
    hours = seconds \ 3600
    remainder = seconds - (hours * 3600)
    minutes = remainder \ 60
    secs = remainder - (minutes * 60)
    return pad(hours) + "h " + pad(minutes) + "m " + pad(secs) + "s"
end function

function pad(n as integer) as string
    if n < 10 then
        return "0" + StrI(n).Trim()
    end if
    return StrI(n).Trim()
end function

function pickFirst(a as dynamic, b as dynamic, c as dynamic) as dynamic
    if isNonEmpty(a) then return a
    if isNonEmpty(b) then return b
    return c
end function

function isNonEmpty(value as dynamic) as boolean
    if value = invalid then return false
    if type(value) = "String" or type(value) = "roString"
        return Len(value) > 0
    end if
    return true
end function

function mapTitles(movies as object) as object
    titles = []
    for each movie in movies
        titles.push(movie.title)
    end for
    return titles
end function
