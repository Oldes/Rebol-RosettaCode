Rebol [
    title: "Rosetta code: Sine wave"
    file:  %Sine_wave.r3
    url:   https://rosettacode.org/wiki/Sine_wave
]

audio: import miniaudio ;@@ https://github.com/Oldes/Rebol-MiniAudio
;; init a playback device (first available)...
;; keep the reference to the device handle, else it will be released by GC!
device: audio/init-playback 1

a: 0   ;; sine phase accumulator
b: PI  ;; cosine phase accumulator (start offset by PI)

with audio [
    wave: make-waveform-node type_sine 0.5 440.0  ;; sine wave: 50% amplitude, 440 Hz
    sound: play/fade wave 0:0:1   ;; start playback with a 1-second fade-in
    wait 5                        ;; keep playing for 5 seconds

    ;; modulate frequency with two slowly drifting phase accumulators
    loop 500 [
        a: a + 0.01
        b: b + 0.006
        wave/frequency: 440.0 + (220.0 * ((sin a) * cos b))  ;; ±220 Hz wobble around 440
        wait 0.01
    ]
    stop/fade sound 0:0:2   ;; fade out over 2 seconds, but keep looping below

    ;; faster modulation pass while fade-out completes
    loop 400 [
        a: a + 0.02         ;; doubled step — faster sweep
        b: b + 0.003        ;; slower cosine drift
        wave/frequency: 440.0 + (220.0 * ((sin a) * cos b))
        wait 0.005          ;; tighter polling interval
    ]
]