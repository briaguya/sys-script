(def nxtas-peg
  (peg/compile
    '{:num (some (range "09))
      :key (+ "A" "B" "X" "Y" "L" "R" "ZL" "ZR" "DRIGHT" "DLEFT" "DDOWN" "DUP")
      :qkey (* "KEY_" (<- :key))
      :keys (+ "NONE" (* :qkey (any (* ";" :qkey))))
      :stick (* (<- :num) ";" (<- :num))
      :main (* (<- :num) " " :keys " " :stick " " :stick)}))

(def bitmap
  @{"A" (int/u64 "1")
    "B" (int/u64 "2")
    "X" (int/u64 "4")
    "Y" (int/u64 "8")
    "L" (int/u64 "64")
    "R" (int/u64 "128")
    "ZL" (int/u64 "128")
    "ZR" (int/u64 "256")
    "DLEFT" (int/u64 "4096")
    "DUP" (int/u64 "8192")
    "DRIGHT" (int/u64 "16384")
    "DDOWN" (int/u64 "32768")})

(defn runinput [line con vsync frame]
  (def res (peg/match nxtas-peg line))
  (def nframe (scan-number (in res 0)))
  (def btns (reduce bor (int/u64 "0") (map bitmap (array/slice res 1 -5))))
  (each i (range frame nframe) (switch/event-wait vsync))
  (hiddbg/set-buttons con btns)
  nframe)

(with [tasfile (file/open "sdmc:/scripts/tasfile.txt" :r) file/close]
(with [disp (vi/default-display) vi/close-display]
(with [vsync (vi/vsync-event disp) switch/close-event]

  (defn frames [n] (each i (range n) (switch/event-wait vsync)))

  (with
    [fcon
    (hiddbg/attach
      :pro-controller
      :bluetooth
      0xFF0000FF
      0xFF00FFFF
      0xFF00FF00
      0xFFFF0000)
    hiddbg/detach]

    (frames 60)
    (hiddbg/set-buttons fcon (int/u64 "192"))
    (frames 60)
    (hiddbg/set-buttons fcon (int/u64 "0"))
    (frames 60)
    (hiddbg/set-buttons fcon (int/u64 "1"))
    (frames 60)
    (hiddbg/set-buttons fcon (int/u64 "0"))
    (frames 60)

    (var fileempty false)
    (var frame 0)

    (switch/event-wait vsync)

    (while (not fileempty)
      (def line (file/read tasfile :line))
      (if (nil? line)
        (set fileeempty true)
        (set frame (runinput line fcon vsync frame))))
  )
)))