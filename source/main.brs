' Day 1 — BrightScript basics: types, collections, loops, invalid, and string conversion.
sub Main()

    ' --- 1. Variables and primitive types ---
    ' BrightScript is dynamically typed: no dim/as declarations; type is inferred from the value.
    name = "Abhishek"
    years = 5
    learning = true

    print name
    print years
    print learning
    print type(name)      ' String
    print type(years)     ' Integer
    print type(learning)  ' Boolean


    ' --- 2. Associative arrays (objects) ---
    ' Curly braces create an roAssociativeArray; access fields with dot notation.
    developer = {
        name: "Abhishek"
        role: "Frontend Developer"
        experience: 5
        skills: [
            "React"
            "Next.js"
            "TypeScript"
        ]
    }

    print developer.name
    print developer.role
    print type(developer)        ' roAssociativeArray
    print type(developer.skills) ' roArray


    ' --- 3. Arrays and for-each loops ---
    techStack = [
        "React"
        "Next.js"
        "TypeScript"
        "BrightScript"
    ]

    for each tech in techStack
        print tech
    end for


    ' --- 4. Array of associative arrays ---
    ' Each movie entry is its own { title, year } object inside the array.
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
        ' StrI() adds a leading space for sign padding; .Trim() removes it before concatenation.
        print movie.title + " (" + StrI(movie.year).Trim() + ")"
    end for


    ' --- 5. Nested API-style response (assoc array + array of assocs) ---
    response = {
        success: true
        data: [
            {
                name: "Netflix"
                subscribers: 300
            }
            {
                name: "Prime Video"
                subscribers: 200
            }
        ]
    }

    print response.successessss 'To check the invalid value'

    for each item in response.data
        ' Two ways to turn an integer into a string for concatenation:
        print item.name + " - " + StrI(item.subscribers).Trim()
        print item.name + " - " + item.subscribers.ToStr()
    end for


    ' --- 6. invalid — BrightScript's null/undefined ---
    ' Accessing a missing property or typo returns invalid; compare with "invalid" (lowercase).
    movie = invalid

    if movie = invalid
        print "A"   ' movie is unset → this branch runs
    else
        print "B"
    end if


    ' --- 7. Array count ---
    ' Reassign movies to an empty array to demo .count() (overwrites the list from section 4).
    movies = []

    print movies.count()  ' 0
end sub
