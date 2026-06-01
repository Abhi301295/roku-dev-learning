' Channel entry point. Roku invokes Main() on launch.
' Exercises live under /exercises and are NOT packaged with the channel.
'
' Project layout (Day 4 — multiple files, no imports):
'   source/main.brs              → entry only
'   source/utils/MovieUtils.brs  → pure helpers (MovieUtils_*)
'   source/services/MovieService.brs → data + business logic (MovieService_*)
'
sub Main()
    print "Roku TV Learning - channel started"
    print ""

    ' --- MovieUtils (called from any file; no import statement) ---

    movies = getMovies()
    for each movie in movies
        print formatMovie({
            title: movie.title
            year: 2020
            rating: 8.5
        })
    end for

    ' print "[safeGetTitle]"
    ' print MovieUtils_safeGetTitle(invalid)
    ' print MovieUtils_safeGetTitle({ rating: 8.8 })
    ' print MovieUtils_safeGetTitle({ title: "Inception" })
    ' print ""

    ' movies = MovieService_getSampleMovies()

    ' print "[highest rated]"
    ' top = MovieService_getHighestRatedMovie(movies)
    ' print top.title
    ' print ""

    ' print "[Action count]"
    ' actionMovies = MovieService_getMoviesByGenre(movies, "Action")
    ' print actionMovies.count()
    ' print ""

    ' print "[find by id=2]"
    ' found = MovieService_findMovieById(movies, 2)
    ' print found.title
    ' print ""

    ' apiResponse = [
    '     { movie_name: "Inception", movie_rating: 8.8 }
    '     { movie_name: "Interstellar", movie_rating: 8.7 }
    ' ]
    ' mapped = MovieService_mapApiResponse(apiResponse)
    ' print "[mapped API count]"; mapped.count()
    ' print ""

    ' picks = MovieService_getTopPicks()
    ' print "[top picks]"
    ' for each lbl in picks.labels
    '     print "- " + lbl
    ' end for
    ' print ""
    ' print "total runtime: " + MovieUtils_formatRuntime(picks.totalMinutes)
end sub
