// =====================================================================
// SuperCollider Workspace
// =====================================================================

//Dark Matter SynthDefs

(
SynthDef(\fback, {|out, freq = 120.0, fb = 1, sustain = 0.05, amp = 0.1|
    var env, pan, sig;
	n = 9;
    pan = LFNoise1.kr(1).range(-1, 1);
    env = EnvGen.kr(Env.perc(0.01, sustain), doneAction:2);
	sig = SinOscFB.ar( 100 * SinOscFB.ar( { freq * Rand(0.98, 1.02)}!20, fb, env));
	Out.ar(out,
		Limiter.ar(
				Splay.ar(
					sig / 20, pan
			)
		) * amp
	)
}).add;

SynthDef("pingy", { arg out=0, freq=440, sustain=0.05, amp=0.5, pan;
        var env;
        env = EnvGen.kr(Env.perc(0.01, sustain), doneAction:2) * amp;
        Out.ar(out,
			Splay.ar(SinOsc.ar({freq * Rand(0.98, 1.02) } ! 20 , 0, env)) / 20)
    }).add;


SynthDef(\crackle, {|out = 0, crack = 1.5, release = 0.5, amp = 0.1|
    var env = EnvGen.kr(Env.sine(release), doneAction:2);
    c = Splay.ar(Crackle.ar({crack * Rand(0.98, 1.02)}!20));
	Out.ar(out, c * env * amp)
}).add;

SynthDef(\vint, {| freq = 440, out = 0, dur = 0.5, amp = 0.1 |
	c = Splay.ar(VarSaw.ar({freq * ExpRand(0.98, 1.02)}!20)) * EnvGen.kr(Env.sine(dur), doneAction: 2);
	Out.ar(out, c.dup * amp / 20);
}).add;

SynthDef(\pmosc, {| freq = 440, out = 0, dur = 0.5, amp = 0.3 |
	c = PMOsc.ar(freq) * EnvGen.kr(Env.perc(0.03, 0.25), doneAction: 2);
	Out.ar(out, c.dup * amp);
}).add;

SynthDef(\grains, {| out = 0, freq = 120.0, rel = 0.2, amp = 0.3|
	var sig, env;
	env = EnvGen.kr(Env.perc(0.01, rel), doneAction:2);
	sig = SinOsc.ar([freq, freq + 2.02], 0, env);
	Out.ar(out, sig.dup * amp);
}).add;

)

//Boiler Pdefs

Pdef(\feedSynth, Pbind(\instrument, \fback, \freq, PjetS(Prand((0..9), inf), \pt), \dur, Pconstituent(0, Prand([0, 2, 4], inf), \pt) * 0.1 + 0.1).trace);

Pdef(\pingy, Pbind(\instrument, \pingy, \freq, PjetS(Prand((0..9), inf), \pt), \dur, Pconstituent(0, Prand([0, 2, 4], inf), \pt) * 0.01 + 0.1).trace);

Pdef(\crk, Pbind(\instrument, \crackle, \amp, 0.3, \release, 0.5, \crack, PconstituentS(0, Prand((0..9), inf), \pt).linlin(0, 1.0, 0.1, 1.5), \dur, PconstituentS(0, Prand([0, 2, 4], inf), \pt) * 0.01 + 0.01));
Ndef(\crackle)[0] = Pdef(\crk);
Ndef(\crackle).play;

Pdef(\vinty, Pbind(\instrument, \vint, \amp, 0.3, \freq, PjetS(Prand((0..9), inf), \pt).linlin(0, 1, 120.0, 220.0), \dur, Pconstituent(0, Prand([0, 2, 4], inf), \pt) * 0.1 + 0.1).trace);

Pdef(\pmosc, Pbind(\instrument, \pmosc, \freq, PjetS(Prand((0..9), inf), \pt).linexp(0, 1, 120.0, 1220.0), \dur, Pconstituent(0, Prand([0, 2, 4], inf), \pt) * 0.1 + 0.1).trace);

Pdef(\granular, Pbind(\instrument, \grains, \amp, 0.01, \freq, PjetS(Prand((0..9), inf), \pt).linlin(0, 1, 100, 600), \dur, Pconstituent(0, Prand([0, 2, 4], inf), \pt) * 0.01 + 0.01).trace);




NdefMixer(s);
