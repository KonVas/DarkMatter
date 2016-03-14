Pjet : Pattern {
	var which, key, <>repeats;
	*new { arg which = 0, key = "pt", repeats=inf;
		^super.newCopyArgs(which, key, repeats);
	}
	storeArgs { ^[which,key, repeats ] }
	embedInStream { arg inval;
		var jetStream, i, jets, jet;
		jetStream = which.asStream;
		repeats.value(inval).do({
			i = jetStream.next(inval);
			if(i.isNil) { ^inval };
			jets = Event.default.parent[\darkmatter]["jets"];
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
		var jetStream, i, jets, jet, min, max, vals;
		jetStream = which.asStream;
		repeats.value(inval).do({
			i = jetStream.next(inval);
			if(i.isNil) { ^inval };
			jets = Event.default.parent[\darkmatter]["jets"];
			vals = jets.collect({|jt| jt[key].interpret });
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
		var constituentStream, i, thisJetNum, constituent, jets, constituents;
		constituentStream = which.asStream;
		repeats.value(inval).do({
			i = constituentStream.next(inval);
			if(i.isNil) { ^inval };
			jets = Event.default.parent[\darkmatter]["jets"];
			thisJetNum = jetnum%jets.size;
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
		var constituentStream, i, thisJetNum, constituent, jets, constituents, min, max, vals;
		constituentStream = which.asStream;
		repeats.value(inval).do({
			i = constituentStream.next(inval);
			if(i.isNil) { ^inval };
			jets = Event.default.parent[\darkmatter]["jets"];
			thisJetNum = jetnum%jets.size;
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
		var jets;
		repeats.value(inval).do({
			jets = Event.default.parent[\darkmatter]["jets"];
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
		var jetStream, i, jets, jet;
		jetStream = which.asStream;
		repeats.value(inval).do({
			i = jetStream.next(inval);
			if(i.isNil) { ^inval };
			jets = Event.default.parent[\darkmatter]["jets"];
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
		var jets, total;
		repeats.value(inval).do({
			total = 0;
			jets = Event.default.parent[\darkmatter]["jets"];
			jets.do({|jet|
				total = total + jet["constituents"].size;
			});
			inval = total.embedInStream(inval);
		});
		^inval
	}
}