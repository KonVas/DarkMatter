Pjet : Pattern {
	var which, key, <>repeats;
	*new { arg which = 0, key = "pt", repeats=inf;
		^super.newCopyArgs(which, key, repeats);
	}
	storeArgs { ^[which,key, repeats ] }
	embedInStream { arg inval;
		var currentEvent, jetStream, i, jets, jet;
		jetStream = which.asStream;
		repeats.value(inval).do({
			i = jetStream.next(inval);
			if(i.isNil) { ^inval };
			currentEvent = Event.default.parent[\events][inval[\event]] ?? {Event.default.parent[\darkmatter]};
			jets = currentEvent["jets"];
			i = i%jets.size;
			jet = jets[i][key.asString].interpret;
			Event.default.parent.constituents = Event.default.parent.constituents.add([i.asInteger, -1]).asSet; // -1 means jet data used
			inval = jet.embedInStream(inval);
		});
		^inval
	}
}

PjetS : Pjet { // scales values for key between 0 and 1

	embedInStream { arg inval;
		var currentEvent, jetStream, i, jets, jet, min, max, vals;
		jetStream = which.asStream;
		repeats.value(inval).do({
			i = jetStream.next(inval);
			if(i.isNil) { ^inval };
			currentEvent = Event.default.parent[\events][inval[\event]] ?? {Event.default.parent[\darkmatter]};
			jets = currentEvent["jets"];
			vals = jets.collect({|jt| jt[key.asString].interpret });
			min = vals.minItem;
			max = vals.maxItem;
			i = i%jets.size;
			jet = jets[i][key.asString].interpret;
			jet = jet.linlin(min, max, 0, 1);
			Event.default.parent.constituents = Event.default.parent.constituents.add([i.asInteger, -1]).asSet; // -1 means jet data used
			inval = jet.embedInStream(inval);
		});
		^inval
	}
}

Pconstituent : Pattern {
	var jetnum, which, key, <>repeats;
	*new { arg jetnum = 0, which = 0, key = "pt", repeats=inf;
		^super.newCopyArgs(jetnum, which, key, repeats);
	}
	storeArgs { ^[which,repeats ] }
	embedInStream { arg inval;
		var currentEvent, constituentStream, jetStream, i, thisJetNum, constituent, jets, constituents;
		constituentStream = which.asStream;
		jetStream = jetnum.asStream;
		repeats.value(inval).do({
			i = constituentStream.next(inval);
			if(i.isNil) { ^inval };
			currentEvent = Event.default.parent[\events][inval[\event]] ?? {Event.default.parent[\darkmatter]};
			jets = currentEvent["jets"];
			thisJetNum = jetStream.next(inval);
			thisJetNum = thisJetNum%jets.size;
			constituents = jets[thisJetNum]["constituents"];
			i = i%constituents.size;
			constituent = constituents[i][key.asString].interpret;
			Event.default.parent.constituents = Event.default.parent.constituents.add([thisJetNum.asInteger, i]).asSet;
			inval = constituent.embedInStream(inval);
		});
		^inval
	}
}

PconstituentS : Pconstituent {  // scales values for key between 0 and 1
	embedInStream { arg inval;
		var currentEvent, constituentStream, jetStream, i, thisJetNum, constituent, jets, constituents, min, max, vals;
		constituentStream = which.asStream;
		jetStream = jetnum.asStream;
		repeats.value(inval).do({
			i = constituentStream.next(inval);
			if(i.isNil) { ^inval };
			currentEvent = Event.default.parent[\events][inval[\event]] ?? {Event.default.parent[\darkmatter]};
			jets = currentEvent["jets"];
			thisJetNum = jetStream.next(inval);
			thisJetNum = thisJetNum%jets.size;
			constituents = jets[thisJetNum]["constituents"];
			vals = constituents.collect({|ct| ct[key.asString].interpret });
			min = vals.minItem;
			max = vals.maxItem;
			i = i%constituents.size;
			constituent = constituents[i][key.asString].interpret;
			constituent = constituent.linlin(min, max, 0, 1);
			Event.default.parent.constituents = Event.default.parent.constituents.add([thisJetNum.asInteger, i]).asSet;
			inval = constituent.embedInStream(inval);
		});
		^inval
	}
}

PnumJets : Pattern {
	var <>repeats;
	*new { arg repeats=inf;
		^super.newCopyArgs(repeats);
	}
	storeArgs { ^[repeats ] }
	embedInStream { arg inval;
		var currentEvent, jets;
		repeats.value(inval).do({
			currentEvent = Event.default.parent[\events][inval[\event]] ?? {Event.default.parent[\darkmatter]};
			jets = currentEvent["jets"];
			inval = jets.size.embedInStream(inval);
		});
		^inval
	}
}

PnumConstituents : Pattern {
	var which, <>repeats;
	*new { arg which = 0, repeats=inf;
		^super.newCopyArgs(which, repeats);
	}
	storeArgs { ^[which, repeats ] }
	embedInStream { arg inval;
		var currentEvent, jetStream, i, jets, jet;
		jetStream = which.asStream;
		repeats.value(inval).do({
			i = jetStream.next(inval);
			if(i.isNil) { ^inval };
			currentEvent = Event.default.parent[\events][inval[\event]] ?? {Event.default.parent[\darkmatter]};
			jets = currentEvent["jets"];
			i = i%jets.size;
			jet = jets[i];
			inval = jet["constituents"].size.embedInStream(inval);
		});
		^inval
	}
}

PtotalConstituents : Pattern {
	var <>repeats;
	*new { arg repeats=inf;
		^super.newCopyArgs(repeats);
	}
	storeArgs { ^[repeats ] }
	embedInStream { arg inval;
		var currentEvent, jets, total;
		repeats.value(inval).do({
			total = 0;
			currentEvent = Event.default.parent[\events][inval[\event]] ?? {Event.default.parent[\darkmatter]};
			jets = currentEvent["jets"];
			jets.do({|jet|
				total = total + jet["constituents"].size;
			});
			inval = total.embedInStream(inval);
		});
		^inval
	}
}