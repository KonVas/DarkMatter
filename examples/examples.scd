SynthDef("pingy2", { arg out=0, freq=440, interval=1, sustain=0.05, amp=0.005, pan;
	var env, signal;
	env = EnvGen.kr(Env.perc(0.01, sustain), doneAction:2) * amp;
	signal = SinOsc.ar(({[freq, freq*interval] * Rand(0.98, 1.02) } ! 20).sum , 0, env);
	Out.ar(out, Splay.ar(signal))
}).add;

// original
Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(Pseq((0..3), inf), \pt)/6, \dur, 0.2)).play

// create an interval: when \jet is provided, the interval is given by jet("m")/constituents_number. In this case, as jetnum is changing, the interval is calculated for each jetnum: the meaning is that we compare the relation between mass an number of constituents between different jets
Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(Pseq((0..3), inf), \pt)/6, \interval, PjetMean(Pseq((0..3), inf), \jet), \dur, 0.2)).play

// create an interval: when a number or a pattern is provided instead of \jet, the interval is given by constituents("m")[which]/constituents_number (note in the following example that PjetMean =~ 0, so it sounds as the original)
Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(Pseq((0..3), inf), \pt)/6, \interval, PjetMean(Pseq((0..3), inf), 0), \dur, 0.2)).play

// to solve the above problem, rescale the previous interval by a factor
Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(Pseq((0..3), inf), \pt)/6, \interval, PjetMean(Pseq((0..3), inf), 0)*100, \dur, 0.2)).play

// the next rescale is obtained by use of a pattern
Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(Pseq((0..3), inf), \pt)/6, \interval, PjetMean(Pseq((0..3), inf), 0)*Pjet(Pseq((0..3), inf), \pt), \dur, 0.2)).play

// do the same but changing patterns' length: do create some "unmeaningful" variation!
Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(Pseq((0..3), inf), \pt)/6, \interval, PjetMean(Pseq((0..4), inf), 0)*Pjet(Pseq((0..5), inf), \pt), \dur, 0.2)).play

// until now we always used the first constituent of each jet for creating our interval, and this has let us compare the relation among the first constituent's mass of each jets.
// Now, let's fix the jet, and do compare constituent's masses among them.
Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(0, \pt)/6, \interval, PjetMean(0, Pseq((0..7), inf))*100, \dur, 0.2)).play

// this is boring!! let's compare constituents's velocities instead, stating the key \pt
Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(0, \pt)/6, \interval, PjetMean(0, Pseq((0..7), inf), \pt), \dur, 0.2)).play

// some variants:
Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(Pseq((0..3), inf), \pt)/6, \interval, PjetMean(Pseq((0..2), inf), 0) * 500, \dur, 0.2)).play

Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(Pseq((0..3), inf), \pt)/6, \interval, PjetMean(Pseq((0..2), inf), 0, \pt), \dur, 0.2)).play

Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(Pseq((0..3), inf), \pt)/6, \interval, PjetMean(Pseq((0..2), inf), Pseq((0..7), inf), \pt), \dur, 0.2)).play

Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(Pseq((0..3), inf), \pt)/6, \interval, PjetMean(Pseq((0..3), inf), \jet), \dur, 0.6, \legato, 4)).play

Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(Pseq((0..3), inf), \pt)/6, \interval, PjetMean(Pseq((0..3), inf), 0, \pt), \dur, 0.6, \legato, 4)).play

// listen to same Gamelan!!
Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(Pseq((0..3), inf), \pt)/6, \interval, PjetMean(Pseq((0..3), inf), Pseq((0..7), inf), \pt), \dur, 0.6, \legato, 4)).play