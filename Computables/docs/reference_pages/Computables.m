(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*fractionContainerReplacement*)

DefineUsage[fractionContainerReplacement,
	{
		BasicDefinitions -> {
			{"fractionContainerReplacement[protocol]", "updatedProtocol", "updates the protocol fields."}
		},
		Input :> {
			{"protocol", ObjectP[ObjectP[Object[Protocol, HPLC]]], "The protocol to update."}
		},
		Output :> {
			{"updatedProtocol", ObjectP[ObjectP[Object[Protocol, HPLC]]], "The protocol updated by this function."}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentHPLC"
		},
		Author -> {"andrey.shur", "lei.tian", "jihan.kim"}
	}
];