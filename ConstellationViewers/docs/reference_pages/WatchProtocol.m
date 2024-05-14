(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineUsage[WatchProtocol,
	{
		BasicDefinitions -> {
			{"WatchProtocol[protocol]", "Null", "Pops open a video stream of a live protocol."},
			{"WatchProtocol[stream]", "Null", "Opens the live video associated with the stream."}
		},
		MoreInformation -> {
			"If a protocol has finished streaming. A video page representing the cloud file will open instead."
		},
		Input :> {
			{"protocol", ProtocolTypes[], "The protocol being recorded."},
			{"instrument", ObjectP[Object[Instrument]], "The instrument attached to the computer that is streaming the video."},
			{"stream", ObjectP[Object[Stream]], "The stream object representing the video."}
		},
		SeeAlso -> {
		},
		Author -> {
			"platform"
		}
	}
];


