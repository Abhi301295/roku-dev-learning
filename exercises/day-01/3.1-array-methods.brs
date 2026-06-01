' Day 1 / Section 3 / 3.1 — Built-in array methods
'
' BrightScript (roArray)          JavaScript equivalent              Notes
' ------------------------------  ---------------------------------  ---------------------------
' arr.push(x)                     arr.push(x)                        same — add at end
' arr.pop()                       arr.pop()                          same — remove from end
' arr.unshift(x)                  arr.unshift(x)                     same — add at start
' arr.shift()                     arr.shift()                        same — remove from start
' arr.count()                     arr.length                         property in JS, method in BRS
' arr[i]                          arr[i]                             same — read / write by index
' arr.peek()                      arr[arr.length - 1]                last item, does NOT remove (unlike pop)
'                                 arr.at(-1)                         ES2022 optional chaining style
' arr.append(otherArr)            arr.push(...other)                 mutates in place; merges other into self
'                                 arr.concat(other)                  returns NEW array (does not mutate)
' arr.clear()                     arr.length = 0                     removes all entries
'                                 arr.splice(0)
' indexOfValue(arr, x)  (below)   arr.indexOf(x)                     BRS has no built-in indexOf on roArray
' indexOfBy(arr, k, v)  (below)   arr.findIndex(o => o[k] === v)
' findIndex(arr, fn)    (below)   arr.findIndex(fn)
' for each x in arr               for (const x of arr)               or arr.forEach(fn) — no return value
' getHighestRatedMovie (below)    arr.reduce((best, m) => ...)       or loop + compare — no built-in maxBy
'
' Not in this file but common later:
' arr.delete(i)                   arr.splice(i, 1)
' arr.insert(i, x)                arr.splice(i, 0, x)
' arr.reverse()                   arr.reverse()                      both mutate in place
' arr.sort() / sortBy(field)      arr.sort(compareFn)
' arr.join(sep)                   arr.join(sep)
'
' No built-in filter / map / reduce — you write helpers (sections 3.3–3.5).
'
' Run: brs 3.1-array-methods.brs
sub Main()
    movies = [
        {
            title: "Inception"
            rating: 8.8
        }
        {
            title: "Batman Begins"
            rating: 8.2
        }
        {
            title: "The Dark Knight"
            rating: 9.0
        }
    ]
    highestRatedMovie = getHighestRatedMovie(movies)
    print "Highest rated movie: "; highestRatedMovie.title + " (" + StrI(highestRatedMovie.rating).Trim() + ")"
    nums = [10, 20, 30]


    ' --- push / pop : add/remove at the END ---
    nums.push(40)
    print "after push: "; describe(nums) ' [10, 20, 30, 40]

    last = nums.pop()
    print "popped: " + StrI(last).Trim() ' 40
    print "after pop:  "; describe(nums) ' [10, 20, 30]

    ' --- unshift / shift : add/remove at the START ---
    nums.unshift(5)
    print "after unshift: "; describe(nums) ' [5, 10, 20, 30]

    first = nums.shift()
    print "shifted: " + StrI(first).Trim() ' 5
    print "after shift:   "; describe(nums) ' [10, 20, 30]

    ' --- count / index access / peek ---
    ' Bracket notation (arr[i]) is the portable way to read/write entries.
    print "count: " + StrI(nums.count()).Trim() ' 3
    print "first:  " + StrI(nums[0]).Trim() ' 10
    print "last:   " + StrI(nums.peek()).Trim() ' 30 (peek = last without removing)

    nums[1] = 99
    print "after nums[1] = 99: "; describe(nums) ' [10, 99, 30]

    ' --- append : merge another array in place ---
    extra = [100, 200]
    nums.append(extra)
    print "after append: "; describe(nums) ' [10, 99, 30, 100, 200]

    ' --- indexOfValue : primitives only (Integer / String / Boolean) ---
    ' `=` cannot compare objects — use indexOfBy or findIndex for object arrays.
    print "indexOf 99:    " + StrI(indexOfValue(nums, 99)).Trim()
    print "indexOf 1234:  " + StrI(indexOfValue(nums, 1234)).Trim()

    ' --- indexOfBy : find an object by one field value ---
    print "indexOfBy title 'The Dark Knight': " + StrI(indexOfBy(movies, "title", "The Dark Knight")).Trim()
    print "indexOfBy title 'Tenet':           " + StrI(indexOfBy(movies, "title", "Tenet")).Trim()

    ' --- findIndex : find an object with a custom predicate ---
    print "findIndex rating >= 9.0: " + StrI(findIndex(movies, isRatingNinePlus)).Trim()

    ' --- clear : remove all entries ---
    nums.clear()
    print "after clear: count = " + StrI(nums.count()).Trim()
end sub

' Primitives only — `=` fails on objects in BRS / is reference-only on Roku.
function indexOfValue(arr as object, target as dynamic) as integer
    for i = 0 to arr.count() - 1
        if arr[i] = target then return i
    end for
    return -1
end function

' Find first item where arr[i][key] = value (works on arrays of objects).
function indexOfBy(arr as object, key as string, value as dynamic) as integer
    for i = 0 to arr.count() - 1
        if arr[i][key] = value then return i
    end for
    return -1
end function

' Find first item where predicate(item) returns true.
function findIndex(arr as object, predicate as function) as integer
    for i = 0 to arr.count() - 1
        if predicate(arr[i]) then return i
    end for
    return -1
end function

function isRatingNinePlus(movie as object) as boolean
    return movie.rating >= 9.0
end function

' Helper: print the array as "[a, b, c]" without each item on its own line.
function describe(arr as object) as string
    parts = ""
    for i = 0 to arr.count() - 1
        if i > 0 then parts = parts + ", "
        parts = parts + arr[i].ToStr()
    end for
    return "[" + parts + "]"
end function

function getHighestRatedMovie(movies as object) as object
    highestRated = movies[0]
    for each movie in movies
        if movie.rating > highestRated.rating then
            highestRated = movie
        end if
    end for
    return highestRated
end function
