Rebol [
    title: "Rosetta code: Smallest enclosing circle problem"
    file:  %Smallest_enclosing_circle_problem.r3
    url:   https://rosettacode.org/wiki/Smallest_enclosing_circle_problem
]

welzl: function/with [
    "Return the smallest enclosing circle of a block of pair! points using Welzl's algorithm"
    points [block!]
][
    ;; shuffle points to ensure expected O(n) performance
    welzl-rec random copy points []
][
    make-circle: func [c r] [
        reduce/no-set [centre: c  radius: r]
    ]

    encloses: func [point circle] [
        ;; true when point lies within or on the circle boundary
        circle/radius >= distance point circle/centre
    ]

    circle-from-two-points: func [a b] [
        ;; circle with diameter a-b
        make-circle
            as-pair (a/x + b/x) / 2.0  (a/y + b/y) / 2.0
            (distance a b) / 2.0
    ]

    circle-from-three-points: function [a b c][
        ;; circumscribed circle via perpendicular bisector intersection
        ba: as-pair (b/x - a/x) (b/y - a/y)
        ca: as-pair (c/x - a/x) (c/y - a/y)
        bb:  (ba/x * ba/x) + (ba/y * ba/y)
        cc:  (ca/x * ca/x) + (ca/y * ca/y)
        dd: ((ba/x * ca/y) - (ba/y * ca/x)) * 2.0  ;; 2× cross product
        centre: as-pair
            (((ca/y * bb) - (ba/y * cc)) / dd) + a/x
            (((ba/x * cc) - (ca/x * bb)) / dd) + a/y
        make-circle centre distance a centre
    ]

    circle-from-points: func [points][
        ;; base-case dispatcher: 0-3 boundary points determine a unique circle
        switch length? points [
            0 [make-circle 0.0x0.0 0.0]
            1 [make-circle points/1 0.0]
            2 [circle-from-two-points points/1 points/2]
            3 [circle-from-three-points points/1 points/2 points/3]
        ]
    ]

    welzl-rec: function [pts boundary][
        ;; base case: no points left or boundary fully determines the circle
        if any [empty? pts  3 = length? boundary] [
            return circle-from-points boundary
        ]
        point: take/last pts: copy pts    ;; pick next candidate (input is pre-shuffled)
        candidate: welzl-rec pts boundary
        if encloses point candidate [return candidate]  ;; already inside — done
        ;; point must lie on the boundary; recurse with it added to boundary
        welzl-rec pts append copy boundary point
    ]
]

tests: [
    [0.0x0.0 0.0x1.0 1.0x0.0]
    [5.0x-2.0 -3.0x-2.0 -2.0x5.0 1.0x6.0 0.0x2.0]
    [0.0x0.0 -2.0x-1.0 3.0x-4.0 2.0x8.0 3.0x11.0 -8.0x-2.0 -14.0x-6.0 7.0x3.0 10.0x4.0 -1.0x4.0]
]

foreach test tests [
    circle: welzl test
    print [
        "Centre: (" circle/centre/x "," circle/centre/y "), Radius:" circle/radius
    ]
]