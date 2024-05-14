(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*checkSolidMedia*)

DefineUsage[checkSolidMedia,
	{
		BasicDefinitions -> {
			{"checkSolidMedia[packets, messagesQ]","{solidMediaInvalidInputs, solidMediaTest}","generates a list of samples whose CultureAdhesion is SolidMedia from a list of sample 'packets'. If messagesQ is True, checkSolidMedia also returns an error (Error::InvalidSolidMediaSample). If messagesQ is False, checkSolidMedia returns tests and does not throw an error message."}
		},
		Input :> {
			{"packets", {PacketP[Object[Sample]]..}, "A single sample packet or list of sample packets."},
			{"messagesQ", BooleanP, "Indicates if messages are being thrown or if tests are being gathered and messages are silenced."}
		},
		Output :> {
			{"solidMediaInvalidInputs", _List, "A list of samples whose CultureAdhesion is SolidMedia."},
			{"solidMediaTest", _List, "A failing test and passing test for checking if samples are in solid media."}

		},
		SeeAlso -> {},
		Author -> {"melanie.reschke", "yanzhe.zhu"}
	}
];

(* ::Subsection:: *)
(*checkDiscardedSamples*)

DefineUsage[checkDiscardedSamples,
	{
		BasicDefinitions -> {
			{"checkDiscardedSamples[packets, messagesQ]","{discardedSampleInvalidInputs, discardedSampleTest}","generates a list of Discarded samples from a list of sample 'packets'. If messagesQ is True, checkDiscardedSamples also returns an error (Error::DiscardedSamples). If messagesQ is False, checkDiscardedSamples returns tests and does not throw an error message."}
		},
		Input :> {
			{"packets", {PacketP[Object[Sample]]..}, "A single sample packet or list of sample packets."},
			{"messagesQ", BooleanP, "Indicates if messages are being thrown or if tests are being gathered and messages are silenced."}
		},
		Output :> {
			{"discardedSampleInvalidInputs", _List, "A list of samples that are Discarded."},
			{"discardedSampleTest", _List, "A failing test and passing test for checking if samples are Discarded."}

		},
		SeeAlso -> {},
		Author -> {"melanie.reschke"}
	}
];