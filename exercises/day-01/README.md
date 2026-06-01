# Day 1 — BrightScript Basics + Functions + Arrays

Standalone exercises run with the `brs` CLI. Not packaged in the channel — `source/main.brs` is.

Files use a `<section>.<step>-<topic>.brs` naming scheme so the intended learning order is obvious.

## Section 1 — Language basics

| Step | File | Concepts |
|------|------|----------|
| 1.1  | `1.1-variables.brs` | Primitive types (String, Integer, Boolean), `type()` |
| 1.2  | `1.2-associative-arrays.brs` | Objects with `{}`, dot access, nested arrays |
| 1.3  | `1.3-arrays.brs` | Arrays, `for each` loops, `.count()` |
| 1.4  | `1.4-movies.brs` | Array of objects, `StrI(int).Trim()` for concatenation |
| 1.5  | `1.5-api-response.brs` | Nested data, `invalid`, `.ToStr()`, missing fields |

## Section 2 — Functions and subs

| Step | File | Concepts |
|------|------|----------|
| 2.1  | `2.1-functions-vs-subs.brs` | `sub` vs `function`, calling conventions |
| 2.2  | `2.2-parameters.brs` | Type annotations, default values, `dynamic` |
| 2.3  | `2.3-return-types.brs` | `as integer / string / boolean / object / void` |
| 2.4  | `2.4-utility-functions.brs` | Formatters, guards, mapping arrays |
| 2.5  | `2.5-recursion-and-scope.brs` | Recursion (factorial, fib), local scope |

## Section 3 — Arrays: filtering and mapping

| Step | File | Concepts |
|------|------|----------|
| 3.1  | `3.1-array-methods.brs` | `push`/`pop`, `shift`/`unshift`, `count`, `peek`, bracket access, `append`, `clear` |
| 3.2  | `3.2-iteration-patterns.brs` | `for each`, indexed `for`, `while`, `exit for`/`exit while` |
| 3.3  | `3.3-filter.brs` | Build a generic `filterArray()` with predicate functions |
| 3.4  | `3.4-map.brs` | Build a generic `mapArray()` with transform functions |
| 3.5  | `3.5-reduce-and-sort.brs` | Build `reduceArray()` (sum/max), built-in `Sort()`, sort-by-field |
| 3.6  | `3.6-real-world.brs` | Pipeline: filter → filter → map → reduce on a movie catalogue |

## Run an exercise

```bash
cd exercises/day-01
brs 3.1-array-methods.brs
brs 3.6-real-world.brs
# ... any file in this folder
```

## Why outside `source/`?

Roku allows only **one** `sub Main()` in `source/`. Multiple files there cause BS1003 (duplicate `Main`).

## Cheat-sheet

```brightscript
' --- sub vs function ---
sub greet(name as string)          ' no return
    print "hello, " + name
end sub

function add(a as integer, b as integer) as integer
    return a + b
end function

' --- generic filter / map / reduce ---
function filterArray(arr as object, predicate as function) as object
    out = []
    for each item in arr
        if predicate(item) then out.push(item)
    end for
    return out
end function

function mapArray(arr as object, transform as function) as object
    out = []
    for each item in arr
        out.push(transform(item))
    end for
    return out
end function

function reduceArray(arr as object, combine as function, seed as dynamic) as dynamic
    acc = seed
    for each item in arr
        acc = combine(acc, item)
    end for
    return acc
end function
```

## Key takeaways

- `+` is type-strict — use `StrI(n).Trim()` or `n.ToStr()` for integers in strings.
- `invalid` is null/undefined; missing keys return it.
- Subs return `invalid`; use `function` when you need a value back.
- Required params before optional (default) params.
- BrightScript has **no** built-in `filter`, `map`, or `reduce` — write them as generics with function parameters.
- For arrays, **bracket access (`arr[i]`)** is portable; `getEntry()` may not exist in every BRS engine.
- Avoid built-in names (`log`, `abs`, `len`, `m` as a top-level var, etc.).
