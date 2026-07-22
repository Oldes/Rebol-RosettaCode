Rebol [
    title: "Rosetta code: Text between"
    file:  %Text_between.r3
    url:   https://rosettacode.org/wiki/Text_between
]

text-between: function [
    "Return the text of str between start and ende markers ('start'/'end' mean beginning/end of str)"
    str [string!] start [string!] ends [string!]
    /case "Case sensitive"
][
    s-rule: either/only start = "start" [][thru start]
    ;; if `ends` is never found, take all to the end of str!
    e-rule: either/only ends  = "end" [to end][to ends | to end]
    parse/:case str [s-rule copy result: e-rule]
    result
]

tests: [
    "Hello Rosetta Code world"
    "Hello " " world"

    "Hello Rosetta Code world"
    "start" " world"

    "Hello Rosetta Code world"
    "Hello " "end"

    {</div><div style="chinese">你好嗎</div>}
    {<div style="chinese">} "</div>"

    {<text>Hello <span>Rosetta Code</span> world</text><table style="myTable">}
    "<text>" "<table>"

    {<table style="myTable"><tr><td>hello world</td></tr></table>}
    "<table>" "</table>"

    "The quick brown fox jumps over the lazy other fox"
    "quick " " fox"

    "One fish two fish red fish blue fish"
    "fish " " red"

    "FooBarBazFooBuxQuux"
    "Foo" "Foo"
]

foreach [text start end] tests [
    print ["Text:  " mold text ]
    print ["Start: " mold start]
    print ["End:   " mold end  ]
    print ["Output:" mold text-between text start end]
    print ""
]