(
~events = "sample.json".resolveRelative.parseYAMLFile;
~testEvent = ~events["event"];
~jets = ~testEvent["jets"];


SynthDef(\sinegrain, { arg out=0, freq=440, sustain=0.05, amp=0.1;
	var env;
	env = EnvGen.kr(Env.perc(0.01, sustain, amp, 0.1), doneAction:2);
	Out.ar(out, Splay.ar(SinOsc.ar([freq, freq * 0.5], 0, env)))
}).add;

~funcDict = IdentityDictionary();
~funcDict[\default] = {|m, etas, phis, thetas, pts, xS, yS, zS|
	Pdef(\player, Pbind(\amp, m / 80, \midinote, Pseq(phis, inf) * 30 +  60 + 20, \pan, Pseq(thetas, inf) / 0.5pi - 1, \dur, 0.1 , \legato, 3).trace).play;
};

~funcDict[\slowDrones] = {|m, etas, phis, thetas, pts, xS, yS, zS|
	Pdef(\player, Pbind(\instrument, \sinegrain, \amp, m / 80, \midinote, phis * 30 + 20, \pan, thetas / 0.5pi - 1, \dur, 4 , \legato, 3).trace).play;
};
~jetConstruct = {|jet, key = \default| // m goes from 18 to 41 in example
	var m, constituents;
	var euler = exp(1);
	var etas, phis, thetas, pts, xS, yS, zS, size;
	m = jet["m"].interpret;
	constituents = jet["constituents"];
	size = constituents.size;
	etas = Array.new(size);
	phis = Array.new(size);
	thetas = Array.new(size);
	pts = Array.new(size);
	xS = Array.new(size);
	yS = Array.new(size);
	zS = Array.new(size);
	constituents.do({|constituent|
		var eta = constituent["eta"].interpret; // 0 to in practice +/- infinity for theta = 0/180 degrees.
		var pt = constituent["pt"].interpret; // goes from 0.604827 to 135.41 in sample data
		var phi = constituent["phi"].interpret; // 0 +/- pi
		var theta = 2 * atan(euler.pow(eta.neg)); // maybe more useful, from 0 - pi
		var x = pt * cos(phi);
		var y = pt * sin(phi);
		var z = pt * sinh(eta);
		etas.add(eta);
		phis.add(phi);
		thetas.add(theta);
		pts.add(pt);
		xS.add(x);
		yS.add(y);
		zS.add(z);
	});
	~funcDict[key].value(m, etas, phis, thetas, pts, xS, yS, zS);
};

)

~jetConstruct.(~jets.first)

~jetConstruct.(~jets.last, \slowDrones)

////////////////
(
~jets.collect({|jet|
	jet["constituents"].collect({|constituent| constituent["pt"].interpret});
}).flat.minItem
)

(
~jets.collect({|jet|
	jet["m"].interpret;
}).maxItem
)
	