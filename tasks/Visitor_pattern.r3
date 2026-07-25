Rebol [
    title: "Rosetta code: Visitor pattern"
    file:  %Visitor_pattern.r3
    url:   https://rosettacode.org/wiki/Visitor_pattern
]

;; Car elements are just plain objects tagged with 'type - no accept
;; method needed, since Rebol can already switch on a value's type
;; at runtime without a round-trip through the object being visited.

wheel: func [wheel-name [string!]] [
    make object! [type: 'wheel name: wheel-name]
]
body:   does [make object! [type: 'body  ]]
engine: does [make object! [type: 'engine]]

car: does [
    make object! [
        type: 'car
        elements: reduce [
            wheel "front left"
            wheel "front right"
            wheel "back left"
            wheel "back right"
            body
            engine
        ]
    ]
]

;; A "visitor" is just a function that walks a car's elements and
;; switches on each one's type, then handles the car itself last.

do-visit: func [a-car [object!]] [
    foreach element a-car/elements [
        switch element/type [
            body   [print  "Moving my body"]
            wheel  [print ["Kicking my" element/name "wheel"]]
            engine [print  "Starting my engine"]
        ]
    ]
    print "Starting my car"
]

print-visit: func [a-car [object!]] [
    foreach element a-car/elements [
        switch element/type [
            body   [print  "Visiting body"]
            wheel  [print ["Visiting" element/name "wheel"]]
            engine [print  "Visiting engine"]
        ]
    ]
    print "Visiting car"
]

;; --- demo -------------------------------------------------------

print-visit my-car: car
   do-visit my-car
