' Day 1 / 2 — Associative arrays (objects)
'
' Curly braces create an roAssociativeArray. Access fields with dot notation
' (`obj.key`) or bracket notation (`obj["key"]`). Keys are case-insensitive.
' Nested arrays/objects are fully supported.
'
' Run: brs associative-arrays.brs
sub Main()
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
    print developer.experience

    print type(developer)        ' roAssociativeArray
    print type(developer.skills) ' roArray
end sub
