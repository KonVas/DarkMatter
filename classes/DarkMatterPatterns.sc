Pjet : Pattern {
	var which, key, <>repeats;
	*new { arg which, key = "pt", repeats=inf;
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

Pconstituent : Pattern {
	var jetnum, which, key, <>repeats;
	*new { arg jetnum, which, key = "pt", repeats=inf;
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