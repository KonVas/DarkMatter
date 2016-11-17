// =====================================================================
// SuperCollider Workspace
// =====================================================================

//061 Rocks!

//:

s.reboot;
s.meter;
MasterEQ(2);

//:

(
n = LFNoise1;
Ndef(\horns, {
    |duration = 8, amp = 0.08, freq = 65|
    var env = EnvGen.kr( Env.adsr(0.1, 0.6, 0.8, duration), doneAction:2);
    a=SinOsc.ar(freq, Ndef(\horns).ar*n.ar(0.1,3), n.ar(3,6)).tanh;
    9.do{a=AllpassL.ar(a,0.3,{0.2.rand+0.1}!2,5)};
    a = (a * env) * amp;
    a.tanh;
});
)

Ndef(\horns).play;

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

SynthDef("pingy",
    { arg out=0, freq=440, sustain=0.05, amp=0.1, pan;
        var env;
        env = EnvGen.kr(Env.sine(sustain), doneAction:2) * amp;
        Out.ar(out, Splay.ar(SinOsc.ar({freq * Rand(0.98, 1.02) } ! 20 , 0, env)) / 20)
    }).add;


SynthDef(\crackle, {|out = 0, crack = 1.5, sustain = 0.5, amp = 0.1|
    var env, pan;
    pan = LFNoise1.kr(1).range(-1, 1);
    env = EnvGen.kr(Env.sine(sustain), doneAction:2);
    Out.ar(out,
        Limiter.ar(
            Pan2.ar(Crackle.ar({crack * Rand(0.98, 1.02)} !2 ),
                pan, amp * env
            )
        )
    )
}).add;
)

(
Tdef(\horny, {
	var freq_1 =  PconstituentS(0, Prand((0..9), inf), \pt).linexp(0, 1.0, 60.0, 65.0).asStream;
	var freq_2 = PjetS(Prand((0..9), inf), \phi).linlin(0, 1.0, 60, 68).asStream;
	var dur =  PjetS(Prand([0, 2, 4], inf), \pt).asStream;
    loop{
        Ndef(\horns).set( \freq, [freq_1, freq_2].choose.next);
        (dur.next * 0.5 + 0.1).wait;

    }
}).play;
)

(
Pdef(\fb,
    Pbind(\instrument, \fback,
        \freq, PconstituentS(0, Prand((0..9), inf), \pt).linlin(0, 1.0, 1.0, 100.0) + 200,
		\fb, 0.1,
        \sustain, 0.6,
        \amp, 0.9,
        \dur, PjetS(Prand([0, 2, 4], inf), \pt) * 0.2 + 0.3)
		//PjetS(Prand([0, 2, 4], inf), \pt) * 0.8 + 1)
    //PjetS(Prand([0, 2, 4], inf), \pt) * 1 + 1)
);
)

//:

Ndef(\feed)[0] = Pdef(\fb);
Ndef(\feed).play;

(
Pdef(\ping, Pbind(\instrument, \pingy,
    \amp, 0.9,
    \sustain, PjetS(Prand((0..9), inf), \pt).linlin(0, 1.0, 0.3, 0.6),
    \freq, PconstituentS(0, Prand((0..9), inf), \pt).linlin(0, 1.0, 60.0, 80.0),
    \dur, PconstituentS(0, Prand([0, 2, 4], inf), \pt) * 0.2 + 0.2)
);
)
 

Ndef(\ping)[0] = Pdef(\ping);
Ndef(\ping).play(0,2);

 

(
Pdef(\crk, Pbind(\instrument, \crackle,
    \amp, 0.1,
    \sustain, 0.3,
    \crack, PconstituentS(0, Prand((0..9), inf), \pt).linlin(0, 1.0, 1.25, 1.5),
	\pitch, PconstituentS(0, Prand((0..9), inf), \pt).linlin(0, 1.0, 120.0, 1220.0),
    \dur, PconstituentS(0, Prand([0, 2, 4], inf), \pt) * 0.1 + 0.1)
);
)
 

Ndef(\crack)[0] = Pdef(\crk);
Ndef(\crack).play;

 

NdefMixer(s);

 
//Ndef.clear(8);

//Ndef.clear(3);


/*
    Ndef(\crack).stop(8);
    Ndef(\feed).stop(8);
    Ndef(\ping).stop(8);
*/

