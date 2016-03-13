// depends on wslib and Canvas3D

// load and parse your scouting file (will take a little while)
(
var file;

file = File("/Library/Application Support/SuperCollider/Extensions/DarkMatter/Scouting/tests/scouting_split_ph","r");
~events = file.readAllString;
file.close;
~events = ~events.split(Char.nl);
~events = ~events.collect({|string|
	var event;
	event = string.parseYAML;
	event.notNil.if({event["event"]}, nil); // check for bad json
}).reject(_.isNil);

~events = ~events.collectAs({|event|
	var eventNum;
	eventNum = event["eventNum"].interpret;
	eventNum -> event;
}, IdentityDictionary);
~events.writeArchive("events.arch".resolveRelative);
)

~events = Object.readArchive("events.arch".resolveRelative);

//////// General setup and GUI
(
var width = 800, height = 800;
var window, canvas, comp, eventView, jetView, activeEventText, setEventFunc, codeButton, items, colorFunc;
var broadcastAddr;
var euler = exp(1);

window = Window("Available Events", Rect(128, 64, width, height), false).front;
canvas = Canvas3D(window, Rect(0, 0, width * 0.8, height)).background_(Color.black).scale_(200).perspective_(0.4).distance_(6);
comp = CompositeView(window, Rect(width * 0.8, 0, width * 0.2, height));
comp.layout = VLayout(activeEventText = StaticText().string_("Active: "), eventView = ListView(), jetView = ListView(), codeButton = Button().states_([["Generate Code"]]));

eventView.items = ~events.keys.asArray;

eventView.action = {|view|
	var key, currentEvent, paths;
	key = view.item.interpret;
	currentEvent = ~events[key];
	//Event.default.parent[\darkmatter] = currentEvent; // stash it globally

	paths = currentEvent["jets"].collect({|jet|
		jet["constituents"].collect({|constituent|
			var eta = constituent["eta"].interpret; // 0 to in practice +/- infinity for theta = 0/180 degrees. but probably +/- 4.5-5
			var pt = constituent["pt"].interpret; // goes from 0.604827 to 135.41 in sample data; 0-3500 gV
			var phi = constituent["phi"].interpret; // 0 +/- pi
			var theta = 2 * atan(euler.pow(eta.neg)); // maybe more useful, from 0 - pi
			var x = pt * cos(phi);
			var y = pt * sin(phi);
			var z = pt * sinh(eta);
			[[0, 0, 0], [x, y, z]]
		});
	});

	jetView.items = (0..paths.size - 1).add("All");

	canvas.items = [];
	items = paths.collect({|jet, i|
		jet.collect({|path|
			var item;
			item = Canvas3DItem().width_(2).paths_([path]);
			canvas.add(item);
			item
		});
	});

	jetView.valueAction = paths.size;
};

// setup updates
/*NetAddr.broadcastFlag = true;
broadcastAddr = NMLNetAddrMP("255.255.255.255", 57120 + (0..7)); // for SC testing*/
//broadcastAddr = NMLNetAddrMP("255.255.255.255", 12000);
//broadcastAddr = NetAddr.localAddr;
broadcastAddr = NetAddr("192.168.0.100", 12000);

// this will let the visualisations know what you've used.
Event.default.parent[\finish]= {
	var eventNum, numElementsUsed;
	eventNum = ~darkmatter["eventNum"].interpret;
	numElementsUsed = ~constituents.size;
	broadcastAddr.sendMsg('/eventUsed', eventNum, numElementsUsed, *(~constituents.asArray.flat));
	// cleanup before next SC event
	//~constituents.postln;
	~constituents.clear;
};

setEventFunc = {|key|
	var currentEvent, eventNum, jets, numJets, data, msg;
	currentEvent = ~events[key];
	Event.default.parent[\darkmatter] = currentEvent; // stash it globally
	activeEventText.string = "Active:" + key.asString;
	eventNum = currentEvent.["eventNum"].interpret;
	jets = currentEvent["jets"];
	numJets = jets.size;
	data = jets.collect({|jet|
		var constituents, numConstituents, constituentData;
		constituents = jet["constituents"];
		numConstituents = constituents.size;
		constituentData = constituents.collect({|constituent|
			var eta = constituent["eta"].interpret; // 0 to in practice +/- infinity for theta = 0/180 degrees. but probably +/- 4.5-5
			var pt = constituent["pt"].interpret; // goes from 0.604827 to 135.41 in sample data; 0-3500 gV
			var phi = constituent["phi"].interpret; // 0 +/- pi
			var theta = 2 * atan(euler.pow(eta.neg)); // maybe more useful, from 0 - pi
			var m = constituent["m"].interpret;
			var x = pt * cos(phi);
			var y = pt * sin(phi);
			var z = pt * sinh(eta);
			[x, y, z, eta, pt, phi, m].asFloat; // need
		});
		[numConstituents, constituentData].postln;
	});
	//data.flat.size.postln;
	msg = ['/newEvent', eventNum, ~addrBook.me.name, numJets, data.flat].flat;
/*	msg.postln;
	msg.size.postln;*/
	try {broadcastAddr.sendMsg(*msg); }// update visualisations
};

//OSCdef(\test, {|msg| msg.postln },'/newEvent');

eventView.mouseDownAction = {|view, x, y, modifiers, buttonNumber, clickCount|
	var key;
	if(clickCount == 2, {
		key = view.item.interpret;
		setEventFunc.value(key);
	});
};


jetView.action = {|view|
	var selectedJet, colorFunc;
	selectedJet = view.value;
	items.do({|jet, i|
		jet.do({|item|
			item.color = if(i == selectedJet || {jetView.item == "All" }, { Color.rand }, {Color.grey(rand(0.5, 0.8)).alpha_(0.4) });
		});
	});
	canvas.refresh;
};

eventView.valueAction = 0;
setEventFunc.value(eventView.item.interpret);

// spin canvas on mouse move
canvas.mouseMoveAction = {|v,x,y|
	canvas.transforms = [
		Canvas3D.mRotateY(x / -200 % 2pi),
		Canvas3D.mRotateX(y / 200 % 2pi)
	];
	canvas.refresh;
};

canvas.mouseMoveAction.value(nil, 50, 50); // initial rotation

)


///////// Sample Pattern use

SynthDef("pingy",
{ arg out=0, freq=440, sustain=0.05, amp=0.1, pan;
	var env;
	env = EnvGen.kr(Env.perc(0.01, sustain), doneAction:2) * amp;
		Out.ar(out, Splay.ar(SinOsc.ar({freq * Rand(0.98, 1.02) } ! 20 , 0, env)))
}).add;

Pbind(\freq, Pjet(1, "pt").trace).play; //use pt of jet 0 of current CERN event

Pbind(\freq, Pjet(Pseq([0, 1], inf))).play // jetnum can be a pattern

// use phi of constituents 0, 2, 4 of jet 0 of current CERN event
Pdef(\test, Pbind(\freq, Pjet(Pseq([0, 1], inf), \pt), \dur, Pconstituent(0, Prand([0, 2, 4], inf), \phi).abs * 0.1)).play

Pdef(\test, Pbind(\instrument, \pingy, \freq, Pjet(Prand((0..9), inf), \pt), \dur, Pconstituent(0, Prand([0, 2, 4], inf), \pt) * 0.1 + 0.1).trace).play


SynthDef("pingy2", { arg out=0, freq=440, interval=1, sustain=0.05, amp=0.005, pan;
	var env, signal;
	env = EnvGen.kr(Env.perc(0.01, sustain), doneAction:2) * amp;
	signal = SinOsc.ar(({[freq, freq*interval] * Rand(0.98, 1.02) } ! 20).sum , 0, env);
	Out.ar(out, Splay.ar(signal))
}).add;

// original
Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(Pseq((0..3), inf), \pt)/6, \dur, 0.2)).play

// create an interval: when \jet is provided, the interval is given by jet("m")/constituents_number. In this case, as jetnum is changing, the interval is calculated for each jetnum: the meaning is that we compare the relation between mass an number of constituents between different jets
Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(Pseq((0..3), inf), \pt)/6, \interval, Pinterval(Pseq((0..3), inf), \jet), \dur, 0.2)).play

// create an interval: when a number or a pattern is provided instead of \jet, the interval is given by constituents("m")[which]/constituents_number (note in the following example that Pinterval =~ 0, so it sounds as the original)
Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(Pseq((0..3), inf), \pt)/6, \interval, Pinterval(Pseq((0..3), inf), 0), \dur, 0.2)).play

// to solve the above problem, rescale the previous interval by a factor
Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(Pseq((0..3), inf), \pt)/6, \interval, Pinterval(Pseq((0..3), inf), 0)*100, \dur, 0.2)).play

// the next rescale is obtained by use of a pattern
Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(Pseq((0..3), inf), \pt)/6, \interval, Pinterval(Pseq((0..3), inf), 0)*Pjet(Pseq((0..3), inf), \pt), \dur, 0.2)).play

// do the same but changing patterns' length: do create some "unmeaningful" variation!
Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(Pseq((0..3), inf), \pt)/6, \interval, Pinterval(Pseq((0..4), inf), 0)*Pjet(Pseq((0..5), inf), \pt), \dur, 0.2)).play

// until now we always used the first constituent of each jet for creating our interval, and this has let us compare the relation among the first constituent's mass of each jets.
// Now, let's fix the jet, and do compare constituent's masses among them.
Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(0, \pt)/6, \interval, Pinterval(0, Pseq((0..7), inf))*100, \dur, 0.2)).play

// this is boring!! let's compare constituents's velocities instead, stating the key \pt
Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(0, \pt)/6, \interval, Pinterval(0, Pseq((0..7), inf), \pt), \dur, 0.2)).play

// some variants:
Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(Pseq((0..3), inf), \pt)/6, \interval, Pinterval(Pseq((0..2), inf), 0) * 500, \dur, 0.2)).play

Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(Pseq((0..3), inf), \pt)/6, \interval, Pinterval(Pseq((0..2), inf), 0, \pt), \dur, 0.2)).play

Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(Pseq((0..3), inf), \pt)/6, \interval, Pinterval(Pseq((0..2), inf), Pseq((0..7), inf), \pt), \dur, 0.2)).play

Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(Pseq((0..3), inf), \pt)/6, \interval, Pinterval(Pseq((0..3), inf), \jet), \dur, 0.6, \legato, 4)).play

Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(Pseq((0..3), inf), \pt)/6, \interval, Pinterval(Pseq((0..3), inf), 0, \pt), \dur, 0.6, \legato, 4)).play

// listen to same Gamelan!!
Pdef(\test, Pbind(\instrument, \pingy2, \freq, Pjet(Pseq((0..3), inf), \pt)/6, \interval, Pinterval(Pseq((0..3), inf), Pseq((0..7), inf), \pt), \dur, 0.6, \legato, 4)).play
