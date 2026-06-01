# Day 1 — BrightScript Basics + Functions

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

## Run an exercise

```bash
cd exercises/day-01
brs 1.1-variables.brs
brs 2.1-functions-vs-subs.brs
# ... any file in this folder
```

## Why outside `source/`?

Roku allows only **one** `sub Main()` in `source/`. Multiple files there cause BS1003 (duplicate `Main`).

## Cheat-sheet

```brightscript
sub greet(name as string)          ' no return
    print "hello, " + name
end sub

function add(a as integer, b as integer) as integer
    return a + b
end function

sub repeat(msg as string, times = 1 as integer)  ' default arg
    for i = 1 to times
        print msg
    end for
end sub
```

## Key takeaways

- `+` is type-strict — use `StrI(n).Trim()` or `n.ToStr()` for integers in strings.
- `invalid` is null/undefined; missing keys return it.
- Subs return `invalid`; use `function` when you need a value back.
- Required params before optional (default) params.
- Avoid built-in names (`log`, `abs`, `len`, `m` as a top-level var, etc.).
