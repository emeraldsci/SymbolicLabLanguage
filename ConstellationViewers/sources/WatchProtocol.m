(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


getStreamObjectFromProtocol[protocol: ObjectP[{Object[Protocol],Object[Maintenance],Object[Qualification]}]] := Module[{stream},
	(* $Simulation being True means we are in simulation land and can short circuit some of the goofy checks *)
	stream = If[MatchQ[protocol, ObjectP[Object[Protocol, Incubate]]] && Not[$Simulation],
		(* Because mixer set up to work in parallel in Incubate protocol, we need to find the latest stream of the current iteration instrument *)
		getStreamObjectFromIncubationProtocol[protocol],
		(* Typically, the last stream should be the one waiting to be stopped *)
		Quiet[Download[protocol, Streams[[-1]][Object]]]
	];

	If[!MatchQ[stream, ObjectP[Object[Stream]]],
		Message[WatchProtocol::StreamNotFound];$Failed,
		stream
	]
];

getStreamObjectFromIncubationProtocol[protocol: ObjectP[Object[Protocol, Incubate]]] := Module[{iteration, streams, computer, transformBSCcomputer, filteredStreams, stream},
	(* extract the PC information of the current iteration instrument*)
	iteration = Lookup[CurrentIterations[protocol], Field[CurrentIncubationParameters], Null];
	
	(* downloading differently if we are not iterating on CurrentIncubationParameters *)
	{
		streams,
		computer,
		transformBSCcomputer
	} = If[NullQ[iteration],
		Quiet[Download[
			protocol,
			{
				Packet[Streams[VideoCaptureComputer, EndTime]],
				HandlingEnvironment[VideoCaptureComputer][Object],
				TransformBiosafetyCabinet[VideoCaptureComputer][Object]
			}
		]],
		Quiet[Download[
			protocol,
			{
				Packet[Streams[VideoCaptureComputer, EndTime]],
				CurrentIncubationParameters[[iteration, Instrument]][VideoCaptureComputer][Object],
				TransformBiosafetyCabinet[VideoCaptureComputer][Object]
			}
		]]
	];
	(* get the PC object *)
	(* find out the streams corresponding to the current iteration instrument*)
	filteredStreams = If[streams == {},
		Message[WatchProtocol::StreamNotFound];
		Return[$Failed],
		Cases[streams, KeyValuePattern[VideoCaptureComputer -> ObjectP[{computer, transformBSCcomputer} /. {Null -> Nothing}]]]
	];
	(* return the last ongoing stream if multiple streams found *)
	stream = If[filteredStreams == {},
		Message[WatchProtocol::StreamNotFound];
		Return[$Failed],
		FirstCase[Reverse[filteredStreams], KeyValuePattern[EndTime -> Null]]
	];
	Download[stream, Object]
];

WatchProtocol::StreamNotFound = "A live stream was not found for this object.";
WatchProtocol::CannotOffset = "Video cannot be launched at the selected time offset. The video is still post-processing. Please try again in a few hours.";
WatchProtocol::SpecifiedTimeNotValid = "Video cannot be played because the specified start or end time is invalid. Please ensure that both times fall within the stream's start time, `1`, and end time, `2`, and that the specified start time is earlier than the specified end time.";

DefineOptions[WatchProtocol,
	Options :> {
		{PlaySpeed -> 1,GreaterP[0], "The speed that the video will be played at."}
	}
];

WatchProtocol[protocol: ObjectP[{Object[Protocol],Object[Maintenance],Object[Qualification]}]] := Module[{streamObject},
	streamObject = getStreamObjectFromProtocol[protocol];
	If[MatchQ[streamObject, $Failed],
		Return[$Failed];
	];

	WatchProtocol[streamObject];
];


getStreamURLForOneHour[stream: ObjectP[Object[Stream]], startTime: _?DateObjectQ] := Module[{id, resp},
	id = Download[stream, ID];
	resp = ConstellationRequest[Association["Path" -> "livestream/get",
		"Body" -> ExportJSON[Association["stream_id" -> id,
			"start_timestamp" ->  DateObjectToRFC3339[startTime],
			"end_timestamp" -> DateObjectToRFC3339[startTime + 1 Hour]
		]],
		"Method" -> "POST"]];
	Lookup[resp, "url", ""]
];

getStreamUrls[stream: ObjectP[Object[Stream]]] := Module[{startTime, endTime, timeIntervals},
	startTime = Download[stream, StartTime];
	endTime = Download[stream, EndTime] /. Null -> Now;

	timeIntervals = DateRange[startTime, endTime, 1 Hour];

	getStreamURLForOneHour[stream, #] & /@ timeIntervals
];

WatchProtocol[stream: ObjectP[Object[Stream]]] := Module[{urls, result, cloudfile},
	cloudfile = Download[stream, VideoFile];
	If[!NullQ[cloudfile],
		result = launchCloudFileVideoHTML[Download[cloudfile, CloudFile]];
		If[MatchQ[result, $Failed], Return[$Failed], Return[Null]]
	];

	urls = getStreamUrls[stream];

	launchStreamViewer[urls];
];

WatchProtocol[stream: ObjectP[Object[Stream]], startOffsetInSeconds_Integer, myOptions:OptionsPattern[]] := Module[{cloudfile, safeOps, playSpeed, startTime, endTime},

	(* Get the options *)
	safeOps=SafeOptions[WatchProtocol, ToList[myOptions]];
	playSpeed=Lookup[safeOps,PlaySpeed,1];

	{cloudfile, startTime, endTime} = Download[stream, {VideoFile, StartTime, EndTime}];

    If[NullQ[cloudfile],
        Message[WatchProtocol::CannotOffset];
        Return[$Failed];
    ];

	(* check if the specified date/time is valid *)
	If[!MatchQ[startOffsetInSeconds, RangeP[0, Round[Unitless[endTime - startTime, Second], 1]]],
		Message[WatchProtocol::SpecifiedTimeNotValid, startTime, endTime];
		Return[$Failed];
	];

	launchCloudFileVideoHTML[Download[cloudfile, CloudFile], startOffsetInSeconds, Null, playSpeed];
];

WatchProtocol[stream: ObjectP[Object[Stream]], startOffsetInSeconds: Alternatives[Null, _Integer], endOffsetInSeconds: Alternatives[Null, _Integer], myOptions:OptionsPattern[]] := Module[{cloudfile, safeOps, playSpeed, startTime, endTime},

	(* Get the options *)
	safeOps=SafeOptions[WatchProtocol, ToList[myOptions]];
	playSpeed=Lookup[safeOps,PlaySpeed,1];

	{cloudfile, startTime, endTime} = Download[stream, {VideoFile, StartTime, EndTime}];

	If[NullQ[cloudfile],
		Message[WatchProtocol::CannotOffset];
		Return[$Failed];
	];

	(* check if the specified date/time is valid *)
	If[
		!Or[
			NullQ[startOffsetInSeconds],
			NullQ[endOffsetInSeconds],
			And[
				MatchQ[startOffsetInSeconds, RangeP[0, endOffsetInSeconds]],
				MatchQ[endOffsetInSeconds, RangeP[startOffsetInSeconds, Round[Unitless[endTime - startTime, Second], 1]]]
			]
		],
		Message[WatchProtocol::SpecifiedTimeNotValid, startTime, endTime];
		Return[$Failed];
	];

	launchCloudFileVideoHTML[Download[cloudfile, CloudFile], startOffsetInSeconds, endOffsetInSeconds, playSpeed];
];

WatchProtocol[stream: ObjectP[Object[Stream]], startOffsetInTime: _?DateObjectQ, myOptions:OptionsPattern[]] := Module[{cloudfile, safeOps, playSpeed,startTime, endTime, startOffsetInSeconds},

	(* Get the options *)
	safeOps=SafeOptions[WatchProtocol, ToList[myOptions]];
	playSpeed=Lookup[safeOps,PlaySpeed,1];

	{cloudfile, startTime, endTime} = Download[stream, {VideoFile, StartTime, EndTime}];

	If[NullQ[cloudfile],
		Message[WatchProtocol::CannotOffset];
		Return[$Failed];
	];

	(* check if the specified date/time is valid *)
	If[!MatchQ[startOffsetInTime, RangeP[startTime, endTime]],
		Message[WatchProtocol::SpecifiedTimeNotValid, startTime, endTime];
		Return[$Failed];
	];

	startOffsetInSeconds = Round[Unitless[startOffsetInTime - startTime, Second], 1];

	launchCloudFileVideoHTML[Download[cloudfile, CloudFile], startOffsetInSeconds, Null, playSpeed];
];

WatchProtocol[stream: ObjectP[Object[Stream]], startOffsetInTime: Alternatives[Null, _?DateObjectQ], endOffsetInTime: Alternatives[Null, _?DateObjectQ], myOptions:OptionsPattern[]] := Module[{cloudfile, startTime, endTime, startOffsetInSeconds, endOffsetInSeconds, safeOps, playSpeed},

	(* Get the options *)
	safeOps=SafeOptions[WatchProtocol, ToList[myOptions]];
	playSpeed=Lookup[safeOps,PlaySpeed,1];

	{cloudfile, startTime, endTime} = Download[stream, {VideoFile, StartTime, EndTime}];

	If[NullQ[cloudfile],
		Message[WatchProtocol::CannotOffset];
		Return[$Failed];
	];

	(* check if the specified date/time is valid *)
	If[
		!Or[
			NullQ[startOffsetInTime],
			NullQ[endOffsetInTime],
			And[
				MatchQ[startOffsetInTime, RangeP[startTime, endOffsetInTime]],
				MatchQ[endOffsetInTime, RangeP[startOffsetInTime, endTime]]
			]
		],
		Message[WatchProtocol::SpecifiedTimeNotValid, startTime, endTime];
		Return[$Failed];
	];

	startOffsetInSeconds = If[NullQ[startOffsetInTime],
		0,
		Round[Unitless[startOffsetInTime - startTime, Second], 1]
	];
	endOffsetInSeconds = If[NullQ[endOffsetInTime],
		Round[Unitless[endTime - startTime, Second], 1],
		Round[Unitless[endOffsetInTime - startTime, Second], 1]
	];

	launchCloudFileVideoHTML[Download[cloudfile, CloudFile], startOffsetInSeconds, endOffsetInSeconds, playSpeed];
];

launchStreamViewer[urls: {_String..}] := Module[{urlManifests, urlManifestJSON, pluginDir,videoJSDir, html, shouldUsePlugin, script, filename},
	urlManifests = "{\"url\":\"" <> # <> "\", \"mimeType\": \"application/x-mpegURL\"}" & /@  urls;

	urlManifestJSON = "[" <> StringRiffle[urlManifests, ", "] <> "]";

	videoJSDir = FileNameJoin[{PackageDirectory["ConstellationViewers`"], "resources", "videojs-http-streaming.min.js"}];
	pluginDir = FileNameJoin[{PackageDirectory["ConstellationViewers`"], "resources", "videojs-plugin-concat.min.js"}];

	shouldUsePlugin = Length[urls] > 1;

	script = If[shouldUsePlugin,
		"var playerElement = $('#videojs');
				playerElement.show();
				var player = videojs('videojs');
				console.log('Created VideoJS Player');
				player.concat({
				  manifests: "<> urlManifestJSON <> ",
				  callback: (err, result) => {
					if (err) {
					  console.error(err);
					  return;
					}
					console.log(result);
					player.src({
					  src: `data:application/vnd.videojs.vhs+json,${JSON.stringify(result.manifestObject)}`,
					  type: 'application/vnd.videojs.vhs+json'
					});
				  }
				});
				player.width(400);
				player.height(300);
				player.play();",
		"var playerElement = $('#videojs');
				playerElement.show();
				var player = videojs('videojs');
				console.log('Created VideoJS Player');
				player.src({
  					src: '"<> urls[[1]] <>"',
  					type: 'application/x-mpegURL'
  				});
				player.width(400);
				player.height(300);
				player.play();"
	];

	html="<!DOCTYPE html><html>
		<body>
			<script src=\"http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js\" type=\"text/javascript\"></script>
			<video id=\"videojs\" class=\"player video-js vjs-default-skin\"  controls autoplay></video>
			<link href=\"https://unpkg.com/video.js/dist/video-js.min.css\" rel=\"stylesheet\">
			<script src=\"https://unpkg.com/video.js/dist/video.min.js\"></script>
			<script src=\"https://cdnjs.cloudflare.com/ajax/libs/videojs-contrib-hls/5.14.1/videojs-contrib-hls.js\"></script>
			<script src=\""<> videoJSDir <>"\"></script>
			<script src=\""<> pluginDir <>"\"></script>
			<script type=\"text/javascript\">
			"<>script<>"
			</script>
		</body></html>";
	filename=FileNameJoin[{$TemporaryDirectory,CreateUUID[]}]<>".html";
	Export[filename,html,"String"];
	SafeOpen[filename];
];
