' MovieService.brs — offline movie catalogue.
'
' Used by MovieFetchTask when the JSON load fails (no network, missing file,
' parse error). Mirrors the shape of assets/movies.json so the rest of the
' channel works without changes.

function MovieService_getCatalogue() as object
    sampleVideo = "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"
    return [
        { title: "Inception", year: 2010, rating: 8.8, durationMins: 148, posterUri: "https://picsum.photos/seed/inception/240/320", videoUrl: sampleVideo, videoFormat: "hls" }
        { title: "Interstellar", year: 2014, rating: 8.6, durationMins: 169, posterUri: "https://picsum.photos/seed/interstellar/240/320", videoUrl: sampleVideo, videoFormat: "hls" }
        { title: "Tenet", year: 2020, rating: 7.4, durationMins: 150, posterUri: "https://picsum.photos/seed/tenet/240/320", videoUrl: sampleVideo, videoFormat: "hls" }
        { title: "Oppenheimer", year: 2023, rating: 8.3, durationMins: 180, posterUri: "https://picsum.photos/seed/oppenheimer/240/320", videoUrl: sampleVideo, videoFormat: "hls" }
        { title: "Dunkirk", year: 2017, rating: 7.9, durationMins: 106, posterUri: "https://picsum.photos/seed/dunkirk/240/320", videoUrl: sampleVideo, videoFormat: "hls" }
        { title: "The Prestige", year: 2006, rating: 8.5, durationMins: 130, posterUri: "https://picsum.photos/seed/prestige/240/320", videoUrl: sampleVideo, videoFormat: "hls" }
    ]
end function
