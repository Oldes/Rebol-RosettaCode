Rebol [
    title: "Rosetta code: Air mass"
    file:  %Air_mass.r3
    url:   https://rosettacode.org/wiki/Air_mass
]

rho: function [
    "Air density ratio (relative to sea level) at altitude a (m), scale height 8500 m"
    a [number!]
][
    exp (a / -8500)
]

height: function [
    "Height above sea level (m) of the point distance d along the line of sight"
    a [number!] "from observer altitude a (m)"
    z [number!] "at zenith angle z (degrees)"
    d [number!]
][
    aa: 6371000 + a
    hh: sqrt ((aa * aa) + (d * d) - (2 * d * aa * cosine (180 - z)))
    hh - 6371000
]

density: function [
    "Integrate air density along the line of sight from altitude a at zenith angle z"
    a [number!] z [number!]
][
    d: sum: 0
    while [d < 10000000] [
        delta: max 0.001 (0.001 * d) ;; coarser steps further out
        sum: sum + ((rho height a z (d + (0.5 * delta))) * delta)
        d: d + delta
    ]
    sum
]

air-mass: function [
    "Relative airmass at altitude a (m) and zenith angle z (deg), normalized so airmass(a, 0) = 1"
    a [number!] z [number!]
][
    (density a z) / (density a 0)
]

print "Angle  0 m         13700 m"
print "------------------------------"
for z 0 90 5 [
    printf [" " 5 " " 11.00000001 " " 11.00000001] [z  air-mass 0 z  air-mass 13700 z]
]