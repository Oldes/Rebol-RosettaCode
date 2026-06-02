Rebol [
    title: "Rosetta code: Draw a pixel"
    file:  %Draw_a_pixel.r3
    url:   https://rosettacode.org/wiki/Draw_a_pixel
]

img: make image! 320x240   ;; Create a new image of size 320x240 pixels
img/(100x100): 255.0.0     ;; Set the pixel at position 100x100 to pure red

;; Set random pixels at a random position to a random RGB color
loop 10000 [ poke img random 320x240 random 255.255.255 ]

save %Draw_a_pixel.png img ;; Save the image to a PNG file named "test.png"
browse %Draw_a_pixel.png   ;; Open the saved image file using the default browser