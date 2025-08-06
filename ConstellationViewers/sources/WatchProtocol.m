(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


getStreamObjectFromProtocol[protocol: ObjectP[{Object[Protocol],Object[Maintenance],Object[Qualification]}]] := Module[{stream},
	(* $Simulation being True means we are in simulation land and can short circuit some of the goofy checks *)
	If[MatchQ[protocol, ObjectP[Object[Protocol, Incubate]]] && Not[$Simulation],
		(* Because mixer set up to work in parallel in Incubate protocol, we need to find the latest stream of the current iteration instrument *)
		stream = getStreamObjectFromIncubationProtocol[protocol],
		(* Typically, the last stream should be the one waiting to be stopped *)
		stream = Quiet[Download[protocol, Streams[[-1]][Object]]];
		If[!MatchQ[stream, ObjectP[Object[Stream]]],
			Message[WatchProtocol::StreamNotFound];
			Return[$Failed];
		]
	];
	stream
];

getStreamObjectFromIncubationProtocol[protocol: ObjectP[Object[Protocol, Incubate]]] := Module[{iteration, streams, incubationPC, filteredStreams, stream},
	(* extract the PC information of the current iteration instrument*)
	iteration = Lookup[CurrentIterations[protocol], Field[CurrentIncubationParameters]];
	{
		streams,
		incubationPC
	} = Quiet[Download[
		protocol,
		{
			Packet[Streams[VideoCaptureComputer]],
			CurrentIncubationParameters[[iteration, Instrument]][VideoCaptureComputer][Object]
		}
	]];
	(* find out the streams corresponding to the current iteration instrument*)
	filteredStreams = If[streams == {},
		Message[WatchProtocol::StreamNotFound];
		Return[$Failed],
		Cases[streams, KeyValuePattern[VideoCaptureComputer->ObjectP[incubationPC]]]
	];
	(* return the last stream if multiple streams found *)
	stream = If[filteredStreams == {},
		Message[WatchProtocol::StreamNotFound];
		Return[$Failed],
		Lookup[filteredStreams, Object][[-1]]
	];
	stream
]

WatchProtocol::StreamNotFound = "A live stream was not found for this object.";
WatchProtocol::CannotOffset = "Video cannot be launched at the selected time offset. The video is still post-processing. Please try again in a few hours."

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

WatchProtocol[stream: ObjectP[Object[Stream]]] := Module[{urls,  cloudfile},
	cloudfile = Download[stream, VideoFile];
	If[!NullQ[cloudfile],
		launchCloudFileVideoHTML[Download[cloudfile, CloudFile]];
		Return[$Failed];
	];

	urls = getStreamUrls[stream];

	launchStreamViewer[urls];
];

WatchProtocol[stream: ObjectP[Object[Stream]], startOffsetInSeconds_Integer] := Module[{cloudfile},
	cloudfile = Download[stream, VideoFile];
    If[NullQ[cloudfile],
        Message[WatchProtocol::CannotOffset];
        Return[$Failed];
    ];

    launchCloudFileVideoHTML[Download[cloudfile, CloudFile], startOffsetInSeconds];
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