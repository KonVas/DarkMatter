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

Pinterval : Pattern {
	var jetnum, which, key, <>repeats;
	*new { arg jetnum, which, key = "m", repeats=inf;
		^super.newCopyArgs(jetnum, which, key, repeats);
	}
	storeArgs { ^[which,repeats ] }
	embedInStream { arg inval;
		var jetStream, keyStream, i, j, thisJetNum, outInt, jets, keyVal, constituentsNum;
		if (which.asString == "jet", {
			jetStream = jetnum.asStream;
			keyStream = jetStream.asStream;
		}, {
			jetStream = jetnum.asStream;
			keyStream = which.asStream;
		});
		repeats.value(inval).do({
			i = keyStream.next(inval);
			if(i.isNil) { ^inval };
			j = jetStream.next(inval);
			if(j.isNil) { ^inval };
			jets = Event.default.parent[\darkmatter]["jets"];
			thisJetNum = j%jets.size;
			if (which.asString == "jet", {
				keyVal = jets;
				i = thisJetNum;
			}, {
				keyVal = jets[thisJetNum]["constituents"];
				i = i%keyVal.size;
			});
			constituentsNum = jets[thisJetNum]["constituents"].size;
			if (constituentsNum == 0) { constituentsNum = 1 };
			outInt = keyVal[i][key.asString].interpret / constituentsNum;
			if (which.asString == "jet", {
				Event.default.parent.constituents = Event.default.parent.constituents.add([thisJetNum.asInteger, -1]).asSet;
			}, {
				Event.default.parent.constituents = Event.default.parent.constituents.add([thisJetNum.asInteger, i]).asSet;
			});
			inval = outInt.embedInStream(inval);
		});
		^inval
	}
}
