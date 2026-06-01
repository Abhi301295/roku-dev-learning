' StringUtils.brs — string helpers (no import needed; everything is global).
'
' BrightScript                    JavaScript equivalent
' ------------------------------  ---------------------------------
' UCase(s)                        s.toUpperCase()
' LCase(s)                        s.toLowerCase()
' Left(s, n)                      s.slice(0, n)
' Right(s, n)                     s.slice(-n)
' Mid(s, start)                   s.slice(start - 1)            ' BRS Mid is 1-indexed
' Mid(s, start, length)           s.substr(start - 1, length)
' Len(s)                          s.length
' (no built-in StrReverse)        [...s].reverse().join("")     ' write our own loop

function StringUtils_capitalize(text as string) as string
    if Len(text) = 0 then return text
    return UCase(Left(text, 1)) + Right(text, Len(text) - 1)
end function

function StringUtils_reverse(text as string) as string
    out = ""
    for i = Len(text) to 1 step -1
        out = out + Mid(text, i, 1)
    end for
    return out
end function

function StringUtils_toLowerCase(text as string) as string
    return LCase(text)
end function

function StringUtils_toUpperCase(text as string) as string
    return UCase(text)
end function
