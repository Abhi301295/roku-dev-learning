' MovieService.brs — catalogue + queries (uses MovieUtils_* helpers)

' Offline fallback for MovieFetchTask. Mirrors the shape of assets/movies.json
' so the UI works end-to-end if the JSON read fails.
function MovieService_getCatalogue() as object
    sampleVideo = "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"
    return [
        { title: "Inception", year: 2010, rating: 8.8, durationMins: 148, posterUri: "https://picsum.photos/seed/inception/240/320", videoUrl: sampleVideo, videoFormat: "hls" }
        { title: "Interstellar", year: 2014, rating: 8.6, durationMins: 169, posterUri: "https://picsum.photos/seed/interstellar/240/320", videoUrl: sampleVideo, videoFormat: "hls" }
        { title: "Tenet", year: 2020, rating: 7.4, durationMins: 150, posterUri: "https://picsum.photos/seed/tenet/240/320", videoUrl: sampleVideo, videoFormat: "hls" }
        { title: "Oppenheimer", year: 2023, rating: 8.3, durationMins: 180, posterUri: "https://picsum.photos/seed/oppenheimer/240/320", videoUrl: sampleVideo, videoFormat: "hls" }
        { title: "Dunkirk", year: 2017, rating: 7.9, durationMins: 106, posterUri: "https://picsum.photos/seed/dunkirk/240/320", videoUrl: sampleVideo, videoFormat: "mp4" }
        { title: "The Prestige", year: 2006, rating: 8.5, durationMins: 130, posterUri: "https://picsum.photos/seed/prestige/240/320", videoUrl: sampleVideo, videoFormat: "hls" }
    ]
end function

function getMovies() as object
    return [
        { title: "Inception", year: 2010, rating: 8.8, durationMins: 148 }
        { title: "Interstellar", year: 2014, rating: 8.6, durationMins: 169 }
        { title: "Tenet", year: 2020, rating: 7.4, durationMins: 150 }
        { title: "Oppenheimer", year: 2023, rating: 8.3, durationMins: 180 }
        { title: "Dunkirk", year: 2017, rating: 7.9, durationMins: 106 }
        { title: "The Prestige", year: 2006, rating: 8.5, durationMins: 130 }
    ]
end function

function MovieService_getSampleMovies() as object
    return [
        { id: 1, title: "Inception", rating: 8.8, genre: "Sci-Fi" }
        { id: 2, title: "Batman Begins", rating: 8.2, genre: "Action" }
        { id: 3, title: "The Dark Knight", rating: 9.0, genre: "Action" }
    ]
end function

' filter → filter → map + reduce pipeline.
function MovieService_getTopPicks() as object
    catalogue = MovieService_getCatalogue()
    recent = MovieUtils_filterArray(catalogue, MovieUtils_isRecent)
    wellRated = MovieUtils_filterArray(recent, MovieUtils_isWellRated)
    return {
        labels: MovieUtils_mapArray(wellRated, MovieUtils_toLabel)
        totalMinutes: MovieUtils_reduceArray(wellRated, MovieUtils_addDuration, 0)
    }
end function

function MovieService_getHighestRatedMovie(movies as object) as object
    if movies.count() = 0 then return invalid
    highestRated = movies[0]
    for each movie in movies
        if movie.rating > highestRated.rating then highestRated = movie
    end for
    return highestRated
end function

function MovieService_getMoviesByGenre(movies as object, genre as string) as object
    out = []
    for each movie in movies
        if movie.genre = genre then out.push(movie)
    end for
    return out
end function

function MovieService_findMovieById(movies as object, id as integer) as object
    for each movie in movies
        if movie.id = id then return movie
    end for
    return invalid
end function

function MovieService_mapApiResponse(apiResponse as object) as object
    out = []
    for each item in apiResponse
        out.push({
            id: item.movie_id
            title: item.movie_name
            rating: item.movie_rating
        })
    end for
    return out
end function
