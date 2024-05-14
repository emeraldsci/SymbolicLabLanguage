(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


getStreamObjectFromProtocol[protocol: ObjectP[{Object[Protocol],Object[Maintenance],Object[Qualification]}]] := Module[{stream},
	stream = Quiet[Download[protocol, Streams[[-1]][Object]]];
	If[!MatchQ[stream, ObjectP[Object[Stream]]],
		Message[WatchProtocol::StreamNotFound];
		Return[$Failed];
	];
	stream
];


WatchProtocol::StreamNotFound = "A live stream was not found for this object.";

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
		Return[];
	];

	urls = getStreamUrls[stream];

	launchStreamViewer[urls];
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