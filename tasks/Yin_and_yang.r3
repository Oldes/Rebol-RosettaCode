Rebol [
    title: "Rosetta code: Yin and yang"
    file:  %Yin_and_yang.r3
    url:   https://rosettacode.org/wiki/Yin_and_yang
    needs: blend2d
]

draw-yinyang: function [
    "Draw a yin-yang symbol of given radius r centered at pos onto pic."
    pic [image! pair!] pos [pair!] r [integer! decimal!]
][
    r2: 2 * r
    draw pic compose [
        fill-pen :black
        circle (pos) (r2 + 2)                      ;; outer black disc
        fill-pen :white
        arc (pos) (as-pair r2 r2) 90 180           ;; white half
        fill-pen :black
        circle (as-pair pos/x pos/y - r) (r)       ;; black small disc, upper half
        fill-pen :white
        circle (as-pair pos/x pos/y + r) (r)       ;; white small disc, lower half
        circle (as-pair pos/x pos/y - r) (r / 3)   ;; white dot inside it
        fill-pen :black
        circle (as-pair pos/x pos/y + r) (r / 3)   ;; black dot inside it
    ]
]

pic: draw-yinyang 600x600 300x300 120
pic: draw-yinyang pic 80x80 20
browse save %Yin_and_yang.png pic
