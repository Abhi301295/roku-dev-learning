' MovieFetchTask runs on a dedicated Task thread (extends Task).
'
' Inputs (set by the parent before "RUN"):
'   m.top.url       string — either "pkg:/..." (packaged file) or "http(s)://..."
'
' Output (the parent observes this field):
'   m.top.response  { movies: [ ... ], error: "" }
'                   - movies: array on success, empty array on failure
'                   - error : empty on success, human-readable message on failure
'
' Lifecycle:
'   1. Parent sets `url`, then `control = "RUN"`.
'   2. Roku invokes the function named in m.top.functionName ("fetchMovies").
'   3. fetchMovies() does the blocking read/parse here, off the render thread.
'   4. Setting `response` fires the parent's observer.

sub init()
    m.top.functionName = "fetchMovies"
end sub

function fetchMovies() as void
    response = { movies: [], error: "" }

    url = m.top.url
    if url = invalid or Len(url) = 0 then
        response.error = "No url provided"
        m.top.response = response
        return
    end if

    body = readBody(url, response)
    if Len(response.error) > 0 then
        m.top.response = response
        return
    end if

    parseBody(body, response)
    m.top.response = response
end function

' Returns the response body as a string, or "" with response.error set.
function readBody(url as string, response as object) as string
    if Left(url, 4) = "pkg:" then
        body = ReadAsciiFile(url)
        if body = invalid or Len(body) = 0 then
            response.error = "Could not read " + url
            return ""
        end if
        return body
    end if

    try
        http = CreateObject("roUrlTransfer")
        http.SetUrl(url)

        if Left(url, 5) = "https" then
            http.SetCertificatesFile("common:/certs/ca-bundle.crt")
            http.InitClientCertificates()
        end if

        http.AddHeader("Accept", "application/json")
        body = http.GetToString()

        if body = invalid or Len(body) = 0 then
            response.error = "Empty response from " + url
            return ""
        end if

        return body
    catch e
        response.error = "HTTP error: " + e.message
        return ""
    end try
end function

' Parses the JSON body and fills response.movies, or sets response.error.
sub parseBody(body as string, response as object)
    parsed = ParseJSON(body)
    if parsed = invalid then
        response.error = "Invalid JSON"
        return
    end if
    if parsed.movies = invalid then
        response.error = "JSON has no 'movies' array"
        return
    end if
    response.movies = parsed.movies
end sub
