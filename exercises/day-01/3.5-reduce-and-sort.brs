' Day 1 / Section 3 / 3.5 — Reduce and Sort
'
' reduce() collapses an array into a single value (sum, count, lookup table, …).
' We build our own; BrightScript provides no reduce/fold built-in.
' For sorting, roArray HAS a built-in .Sort() — we use it on simple values
' and write a small comparator-based sort for arrays of objects.
'
' BrightScript                              JavaScript equivalent
' ----------------------------------------  -----------------------------------------
' reduceArray(nums, addInts, 0)             nums.reduce((a, b) => a + b, 0)
' reduceArray(nums, maxInt, nums[0])        nums.reduce((a, b) => Math.max(a, b))
'
' arr.Sort()                                arr.sort()                       // BUT...
'   sorts ASC for ints / strings              JS default coerces to STRING:
'                                             [10, 2, 1].sort() -> [1, 10, 2]
'                                             use [10, 2, 1].sort((a,b)=>a-b)
'
' Sort by field (custom):                   arr.sort((a, b) => a.year - b.year)
'   sortByYearAsc(movies)                   // built-in comparator-based sort
'   (insertion sort, written manually)
'
' BrightScript has NO built-in:             JavaScript built-ins on Array:
'   reduce / fold                             arr.reduce(fn, seed)
'   reduceRight                               arr.reduceRight(fn, seed)
'   sort by comparator on roArray             arr.sort(compareFn)
'
' arr.Sort()  // mutates input              arr.sort()  // also mutates input
'                                           arr.toSorted()  // ES2023, returns new
'
' Run: brs 3.5-reduce-and-sort.brs
sub Main()
    nums = [3, 1, 4, 1, 5, 9, 2, 6, 5]

    ' --- reduce: sum ---
    total = reduceArray(nums, addInts, 0)
    print "sum: " + StrI(total).Trim()           ' 36

    ' --- reduce: max ---
    biggest = reduceArray(nums, maxInt, nums[0])
    print "max: " + StrI(biggest).Trim()         ' 9

    ' --- built-in sort for primitives ---
    nums.Sort()
    print "sorted asc: "; nums                    ' 1,1,2,3,4,5,5,6,9

    ' --- sort an array of objects by a field (custom) ---
    movies = [
        { title: "Tenet",        year: 2020 }
        { title: "Inception",    year: 2010 }
        { title: "Oppenheimer",  year: 2023 }
        { title: "Interstellar", year: 2014 }
    ]
    sorted = sortByYearAsc(movies)
    print "[movies by year asc]"
    for each movie in sorted
        print "- " + movie.title + " (" + StrI(movie.year).Trim() + ")"
    end for
end sub

' Generic reduce: starts at "seed" and applies combine(acc, item) for each entry.
function reduceArray(arr as object, combine as function, seed as dynamic) as dynamic
    acc = seed
    for each item in arr
        acc = combine(acc, item)
    end for
    return acc
end function

function addInts(a as integer, b as integer) as integer
    return a + b
end function

function maxInt(a as integer, b as integer) as integer
    if b > a then return b
    return a
end function

' Insertion sort by movie.year (small arrays — fine for a learning demo).
function sortByYearAsc(arr as object) as object
    out = []
    for each item in arr : out.push(item) : end for
    for i = 1 to out.count() - 1
        cur = out[i]
        j = i - 1
        while j >= 0 and out[j].year > cur.year
            out[j + 1] = out[j]
            j = j - 1
        end while
        out[j + 1] = cur
    end for
    return out
end function
