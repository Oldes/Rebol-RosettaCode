Rebol [
    title: "Rosetta code: Hello world/Standard error"
    file:  %Hello_world-Standard_error.r3
    url:   https://rosettacode.org/wiki/Hello_world-Standard_error
]

err-print: func [
    "Print value to stderr."
    value
] either/only exists? %/dev/stderr [
    ;; On Posix
    write %/dev/stderr value
][  ;; On Windows
    modify system/ports/output 'error true
    also print value
    modify system/ports/output 'error false
]

err-print "Goodbye, World!"
