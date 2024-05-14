(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*ObjectLogAssociation*)


DefineUsage[ObjectLogAssociation,
	{
		BasicDefinitions -> {
			{"ObjectLogAssociation[objects]", "out", "returns a list of associations that summarizes the most recent changes to Constellation of the specified Objects."},
			{"ObjectLogAssociation[packets]", "out", "returns a list of associations that summarizes the most recent changes to Constellation of the specified Types."},
			{"ObjectLogAssociation[]", "out", "when neither object or type are specified, the user can get the most recent changes to Constellation."}
		},
		Input :> {
			{"objects", ListableP[ObjectP[]], "An Object Packet."},
			{"types", ListableP[TypeP[]], "A list of Object Packets."},
			{"none", _, "no inputs"}
		},
		Output :> {
			{"out", _, "Return a list of associations to summarize the recent change to Constellation of the specified Objects, Types or all changes."}
		},
		SeeAlso -> {
			"Association",
			"DefineObjectType",
			"Upload"
		},
		Author -> {"scicomp", "platform"}
	}];
