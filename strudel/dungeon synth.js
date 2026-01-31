setcpm(70)

// 0,4,7	major
// 0,3,7	minor
// 0,3,6	diminished
// 0,4,8	augmented

// D Minor: Dm, Edim, F, Gm, Am, Bb, C
// D - E - F - G - A - Bb - C

const chords = note(`<[0, 7, 12]@4 [0,7,12]@4>`
.add(`<d2 bb1>`))
.room(.75)
.sound("piano")
.hpf(200)
.lpf(500)
.velocity(rand.range(0.3, 0.45))
.detune(perlin.range(-10, 10))
.gain(0.35)

const melody = note(`
<
[a3 a3] g3 f3 e3
[d3 d3] e3 f3 e3
a3 [a3 g3] g3 [e3 e3]
d3 [e3 e3] f3@2
a3 [bb3 bb3] a3 [bb3
bb3] a3 g3 f3
[e3 e3] [d3 d3] [e3 e3] f3
g3 a3@3
>
`)
.sound("piano")
.lpf(tri.range(400, 1800).slow(32)) // Filter slowly "breathes" over 32 bars
  .room(0.7)
  .gain(0.3)
  .velocity(rand.range(0.4, 0.7))
  .sometimesBy(0.1, x => x.delay(0.2))

const melodyOctave = melody
  .add(-12)
  .gain("<0@16 0.4@16>")
  .pan(0.7)

const bass = 
  note(`<d1 d1 bb0 bb0>`)
.sound("sine")
.lpf(300)
.gain("<0.4@16 0.8@16>")

const bd = sound(
  "<bd ~ bd*<1 0.5> ~>"
)
.gain(0.15)
.lpf(400)
.room(1)

stack (
  chords,
  bd,
  melody,
  melodyOctave,
  bass
)
