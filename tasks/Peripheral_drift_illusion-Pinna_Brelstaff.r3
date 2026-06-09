Rebol [
    title: "Rosetta code: Peripheral drift illusion"
    file:  %Peripheral_drift_illusion-Pinna_Brelstaff.r3
    url:   https://rosettacode.org/wiki/Peripheral_drift_illusion
    needs: blend2d       ;; draw extension
]

n:    7
r:    800 / (2 * n)
step: 360 *  2 / (n - 1)

cmds: compose [pen off translate (as-pair r r)]

repeat row n [
    repeat col n [
        x: (2 * (col - 1)) * r
        y: (2 * (row - 1)) * r
        angle: (col + row - 2) * step

        ;; draw rings outside-in so smaller rings appear on top
        for ring 5 1 -1 [
            ring-r: r * ring / 6
            offs:   r * 0.12            ;; fixed small offset for all rings
            a:      angle + (ring * 25) ;; each ring rotated incrementally more

            append cmds compose [
                fill-pen (either odd? ring [240.240.240] [20.20.20])
                circle (as-pair x + (offs * cosine a) y + (offs * sine a)) (ring-r)
            ]
        ]
    ]
]

img: make image! [800x800 100.100.100]
browse save %Peripheral_drift_illusion-Pinna_Brelstaff.png draw img cmds
