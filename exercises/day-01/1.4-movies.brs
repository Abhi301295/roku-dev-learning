' Day 1 / 4 — Array of associative arrays + string conversion
'
' Real-world data usually looks like a list of objects. To concatenate an
' Integer into a String you must convert it explicitly: `+` is type-strict.
' StrI(int) returns " 2010" with a leading space for the sign — use .Trim().
'
' Run: brs movies.brs
sub Main()
    movies = [
        {
            title: "Inception"
            year: 2010
        }
        {
            title: "Interstellar"
            year: 2014
        }
        {
            title: "Oppenheimer"
            year: 2023
        }
    ]

    for each movie in movies
        print movie.title + " (" + StrI(movie.year).Trim() + ")"
    end for
end sub
