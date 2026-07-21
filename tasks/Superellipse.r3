Rebol [
    title: "Rosetta code: Superellipse"
    file:  %Superellipse.r3
    url:   https://rosettacode.org/wiki/Superellipse
    needs: blend2d
]

cmds: [fill-all 0.0.0 pen white line-width 4 line]
scale: 8.0 n: 2.5 a: b: 200.0 t: 0.0
;; Superellipse (Lamé curve): x = a·|cos t|^(2/n)·sign(cos t)
;;                            y = b·|sin t|^(2/n)·sign(sin t)
while [t <= 360.0] [
    x: ((power abs cosine t  2.0 / n) * a * sign? cosine t) / 5.0 + 50.0
    y: ((power abs sine   t  2.0 / n) * b * sign? sine   t) / 5.0 + 50.0
    append cmds scale * as-pair x y
    t: t + 0.5
]

browse save %Superellipse.png draw 800x800 cmds