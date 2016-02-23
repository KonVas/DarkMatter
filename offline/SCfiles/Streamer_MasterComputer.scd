// =====================================================================
// SuperCollider Workspace
// =====================================================================

/*
	Code to sonify data generated with CERN Open Data analysis toolkit:
	http://opendata.cern.ch/getting-started/CMS
*/

//Run this to load the file with the data.
(
var path = PathName.new("data/".resolveRelative);
~dataJson = JSONFileReader.read(path.pathOnly  +/+ "/DecaysToLeptons/TwoLeptons/data.json").postln; //data in json format.
);

/*I don't know y, but this is required, values appear as strings initially.*/
~data = ~dataJson["data"].collect{|it| it.asFloat }; //convert values to floats.

//Then run this to start streaming the data as single events.
(
Tdef(\oscStream,
	{
		~events = Pseq(~data, 1).asStream;
		~timeInterval = 1;
		~loopEvents = ~data.size;
		~loopEvents.do{ /*replace 'loopEvents.do' to loop for non-stop streaming*/
			~timeInterval.wait;
			if(~data.notNil){
				if(~addrBook.notNil){
					~singleEvent = ~events.next;
					~addrBook.sendAll('/stream', ~singleEvent.postln);
					{~numBox.value_(~singleEvent.value)}.defer;
				}
			};
		};
		Tdef(\oscStream).stop;
		~addrBook.sendAll('/stream', "No Events".postln);
	}
);
/*
		Window with slider and button to control
		and start/stop streaming as single events with modulatable speed.
	*/

w = Window.new("ControlPanel", bounds:Rect(100, 500, 400, 120)).layout_(
	VLayout(
		HLayout(
			Button(parent:w)
			.states_([
				["streamOFF"],
				["streamON"]
			])
			.action_({|butt|
				if(butt.value == 1){
					Tdef(\oscStream).play
				}{
					Tdef(\oscStream).pause
				};
			}),
			Slider(parent:w)
			.action_({|sl|
				~timeInterval = sl.value.round(0.01).max(0.01).lag(0.3)
			})
			.value_(1.0)
			.orientation_(\horizontal),
			~numBox = NumberBox(w)
		)
	)
).front;
w.onClose_({ Tdef(\oscStream).stop; })
);