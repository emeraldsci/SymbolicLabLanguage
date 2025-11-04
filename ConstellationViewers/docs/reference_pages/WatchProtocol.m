(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineUsage[WatchProtocol,
	{
		BasicDefinitions -> {
			{
				Definition -> {"WatchProtocol[protocol]", "video"},
				Description -> "Pops open a video stream of a live protocol.",
				Inputs :> {
					{InputName -> "protocol", Widget -> Widget[Type -> Expression, Size -> Line, Pattern :> ObjectP[]], Description -> "The protocol being recorded."}
				},
				Outputs :> {
					{OutputName->"video", Description->"A video stream pops open. This value is always Null.", Pattern:>Null}
				}
			},
			{
				Definition -> {"WatchProtocol[stream]", "video"},
				Description -> "Opens the live video associated with the stream.",
				Inputs :> {
					{InputName -> "stream", Widget -> Widget[Type -> Expression, Size -> Line, Pattern :> ObjectP[{Object[Stream]}]], Description -> "The stream object representing the video."}
				},
				Outputs :> {
					{OutputName->"video", Description->"A video stream pops open. This value is always Null.", Pattern:>Null}
				}
			},
			{
				Definition -> {"WatchProtocol[stream, startTime]", "video"},
				Description -> "Plays the live video associated with the stream starting from specified startTime.",
				Inputs :> {
					{InputName -> "stream", Widget -> Widget[Type -> Expression, Size -> Line, Pattern :> ObjectP[{Object[Stream]}]], Description -> "The stream object representing the video."},
					{InputName -> "startTime", Widget -> Widget[Type -> Expression, Size -> Line, Pattern :> _Integer], Description -> "The start time in second to play the video."}
				},
				Outputs :> {
					{OutputName->"video", Description->"A video stream pops open. This value is always Null.", Pattern:>Null}
				}
			},
			{
				Definition -> {"WatchProtocol[stream, startDate]", "video"},
				Description -> "Plays the live video associated with the stream starting from specified startTime.",
				Inputs :> {
					{InputName -> "stream", Widget -> Widget[Type -> Expression, Size -> Line, Pattern :> ObjectP[{Object[Stream]}]], Description -> "The stream object representing the video."},
					{InputName -> "startDate", Widget -> Widget[Type -> Expression, Size -> Line, Pattern :> _?DateObjectQ], Description -> "The start time in date to play the video."}
				},
				Outputs :> {
					{OutputName->"video", Description->"A video stream pops open. This value is always Null.", Pattern:>Null}
				}
			},
			{
				Definition -> {"WatchProtocol[stream, startTime, endTime]", "video"},
				Description -> "Plays the live video stream within the specified time range.",
				Inputs :> {
					{InputName -> "stream", Widget -> Widget[Type -> Expression, Size -> Line, Pattern :> ObjectP[{Object[Stream]}]], Description -> "The stream object representing the video."},
					{InputName -> "startTime", Widget -> Widget[Type -> Expression, Size -> Line, Pattern :> _Integer], Description -> "The start time in second to play the video."},
					{InputName -> "endTime", Widget -> Widget[Type -> Expression, Size -> Line, Pattern :> _Integer], Description -> "The end time in second to play the video."}
				},
				Outputs :> {
					{OutputName->"video", Description->"A video stream pops open. This value is always Null.", Pattern:>Null}
				}
			},
			{
				Definition -> {"WatchProtocol[stream, startDate, endDate]", "video"},
				Description -> "Plays the live video stream within the specified time range.",
				Inputs :> {
					{InputName -> "stream", Widget -> Widget[Type -> Expression, Size -> Line, Pattern :> ObjectP[{Object[Stream]}]], Description -> "The stream object representing the video."},
					{InputName -> "startDate", Widget -> Widget[Type -> Expression, Size -> Line, Pattern :> _?DateObjectQ], Description -> "The start time in date to play the video."},
					{InputName -> "endDate", Widget -> Widget[Type -> Expression, Size -> Line, Pattern :> _?DateObjectQ], Description -> "The end time in date to play the video."}
				},
				Outputs :> {
					{OutputName->"video", Description->"A video stream pops open. This value is always Null.", Pattern:>Null}
				}
			}
		},
		MoreInformation -> {
			"If a protocol has finished streaming. A video page representing the cloud file will open instead."
		},
		SeeAlso -> {
		},
		Author -> {"platform"}
	}
];

