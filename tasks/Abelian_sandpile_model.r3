Rebol [
    title: "Rosetta code: Abelian sandpile model"
    file:  %Abelian_sandpile_model.r3
    url:   https://rosettacode.org/wiki/Abelian_sandpile_model
    needs: blend2d
]

sandpile: function [
    "Simulate an abelian sandpile on an n x n grid (with 1-cell sink border) and return the final image"
    n [integer!] "Requested interior grid size; bumped up to the next odd number if even, so a true center cell always exists"
    width [integer!] "Output image width/height in pixels"
    /anim "Show a live animated window while it topples"
    /limit max-iterations [integer!] "Stop after this many iterations even if not stable"
][
    if even? n [ ++ n ]                      ;; pad to the next odd size: guarantees an exact, symmetric center cell
    m: make vector! reduce ['u32! n * n]
    mp: copy m                               ;; snapshot buffer: firing decisions read mp, updates hit m
    center: (n + 1) / 2                      ;; always the true center now that n is odd
    m/(((center - 1) * n) + center): 10000   ;; drop the pile in the center cell
    cell-size: width / n
    radius: cell-size / 2
    img: make image! as-pair width width
    hsv: 0.200.255                           ;; hue varies per cell below; sat/value stay fixed

    if all [anim function? :view] [          ;; only animate if /anim was used and a GUI is available
        win: view/no-wait img
    ]
    count: 0
    cmds: clear []

    redraw: does [
        ;; Rebuild the Draw block from the current pile state and render it into img
        append clear cmds [fill black fill-all]
        for r 2 n - 1 1 [                    ;; interior rows only; border stays empty/unfired
            for c 2 n - 1 1 [                ;; interior columns only
                p: r - 1 * n + c
                if m/:p > 0 [
                    hsv/1: 200 * m/:p % 255  ;; hue cycles with chip count
                    append cmds compose [
                        fill-pen (hsv-to-rgb hsv)
                        circle (cell-size * as-pair c - .5 r - .5) (radius)
                    ]
                ]
            ]
        ]
        draw img cmds
    ]
    forever [
        append clear mp m                    ;; refresh snapshot: this pass fires based on the old state
        stable: true
        for r 2 n - 1 1 [
            for c 2 n - 1 1 [

                p: ((r - 1) * n) + c
                if mp/:p >= 4 [              ;; decide firing from the snapshot, not from live m
                    stable: false
                    m/:p: m/:p - 4
                    m/(p - n): m/(p - n) + 1
                    m/(p + 1): m/(p + 1) + 1
                    m/(p + n): m/(p + n) + 1
                    m/(p - 1): m/(p - 1) + 1
                ]
            ]
        ]
        if win [
            redraw
            show win
            wait 0.001                       ;; brief pause so the animation is visible
        ]
        if any [
            stable
            all [limit ++ count == max-iterations] ;; also stop once the iteration cap is hit
        ] [break]
    ]
    either win [unview win] [redraw]         ;; close the live window, or render once if we never animated
    img
]

browse save %Abelian_sandpile_model.jpg sandpile/anim/limit 77 800 7'500