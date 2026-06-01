' Day 1 / 4 — Array of associative arrays + string conversion
'
' Real-world data usually looks like a list of objects. To concatenate an
' Integer into a String you must convert it explicitly: `+` is type-strict.
' StrI(int) returns " 2010" with a leading space for the sign — use .Trim().
'
' BrightScript                    JavaScript equivalent              Notes
' ------------------------------  ---------------------------------  ---------------------------
' [ { ... }  { ... } ]            [{...}, {...}]                     array of objects — same shape
' for each m in movies            for (const m of movies)
'   m.title                         m.title
' "x" + StrI(year).Trim()         "x" + year                         JS coerces with `+`; BRS does not
'                                 `x${year}`                         template literal in JS
' StrI(n)                         String(n)  /  n.toString()         BRS StrI returns " 2010" with
'                                                                    leading sign-space
' StrI(n).Trim()                  String(n).trim()                   BRS .Trim() (capital T);
'                                                                    JS .trim() (lowercase)
' n.ToStr()                       n.toString()                       BRS PascalCase; JS camelCase
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
