' Day 1 / 9 — Utility functions (formatters, guards, transforms)
'
' Most channels build a small library of pure helpers. They take input,
' return output, and don't mutate global state.
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
