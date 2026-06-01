' MovieFetchTask — runs on its own logic thread.
'
' Lifecycle:
'   1. Parent sets m.top.url (optional) and m.top.control = "RUN"
'   2. Roku invokes the function named in m.top.functionName (set in init)
'   3. fetchMovies() does its work synchronously off the render thread
'   4. Assigning to m.top.response fires the observer in the parent Scene

sub init()
    m.top.functionName = "fetchMovies"
end sub

function fetchMovies() as void
    response = { movies: [], source: "", error: "" }

    if Len(m.top.url) > 0 then
        loadFromUrl(m.top.url, response)
    end if

    if response.movies.count() = 0 then
        ' Sleep so the asynchronous Task → observer flow is observable in logs.
        Sleep(500)
        response.movies = MovieService_getCatalogue()
        if Len(response.source) = 0 then response.source = "local"
    end if

    m.top.response = response
end function

' Mutates `response` in place with the parsed payload or an error message.
' Expects the server to return { movies: [...] }.
sub loadFromUrl(url as string, response as object)
    try
        http = CreateObject("roUrlTransfer")
        http.SetUrl(url)
        http.SetCertificatesFile("common:/certs/ca-bundle.crt")
        http.InitClientCertificates()
        http.AddHeader("Accept", "application/json")

        body = http.GetToString()
        if body = invalid or Len(body) = 0 then
            response.error = "Empty response body"
            return
        end if

        parsed = ParseJSON(body)
        if parsed = invalid or parsed.movies = invalid then
            response.error = "Unexpected JSON shape"
            return
        end if

        response.movies = parsed.movies
        response.source = "remote"
    catch e
        response.error = e.message
    end try
end sub
