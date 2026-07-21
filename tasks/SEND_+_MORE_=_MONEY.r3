Rebol [
    title: "Rosetta code: SEND + MORE = MONEY"
    file:  %SEND_+_MORE_=_MONEY.r3
    url:   https://rosettacode.org/wiki/SEND_%2B_MORE_%3D_MONEY
]

m: 1
for s 8 9 1 [
    for e 0 9 1 [
        if find reduce [m s] e [continue]
        for n 0 9 1 [
            if find reduce [m s e] n [continue]
            for d 0 9 1 [
                if find reduce [m s e n] d [continue]
                for o 0 9 1 [
                    if find reduce [m s e n d] o [continue]
                    for r 0 9 1 [
                        if find reduce [m s e n d o] r [continue]
                        for y 0 9 1 [
                            if find reduce [m s e n d o] y [continue]
                            if (( 1000 * s) + ( 100 * e) + ( 10 * n) + d
                            +   ( 1000 * m) + ( 100 * o) + ( 10 * r) + e)
                            == ((10000 * m) + (1000 * o) + (100 * n) + (10 * e) + y) [
                                print rejoin [s e n d " + " m o r e " == " m o n e y]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ]
]