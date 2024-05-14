(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ObjectLog *)
DefineUsage[ObjectLog,
	{
		BasicDefinitions -> {
			{"ObjectLog[object]", "table", "returns 'table' of the most recent changes to an 'object'."},
			{"ObjectLog[type]", "table", "returns 'table' corresponding to changes of the supplied 'type'."},
			{"ObjectLog[]", "table", "returns 'table' of the  most recent changes in Constellations."}
		},
		MoreInformation -> {
			"Options can be further used specify conditions for ObjectLog[]. Additional conditions include date ranges, specific types, and limits.",
			"In the output, the Date column indicates timestamp indicating when the object change occurred.",
			"Object represents the object that was changed. This can also be a type if a type was modified.",
			"User represents the user who modified the object.",
			"DateLogRevised: If the change log was revised, this column indicates the timestamp such revision occurred.",
			"UserWhoRevisedLog indicated the user who revised the change log.",
			"Fields is an association of field value pairs which indicate the fields changed and the updated values."
		},
		Input :> {
			{"object", ListableP[ObjectP[]], "Object to retrieve change logs from."},
			{"type", ListableP[TypeP[]], "Type to retrive change log from."}
		},
		Output :> {
			{"table", _Pane, "A table displaying information regarding a series of changes in constellations."},
			{"associations", {ObjectLogAssociationP..}, "A list of associations representing changes to items in constellations."}
		},
		SeeAlso -> {"Download", "Search"},
		Author -> {"platform", "pavan.shah"}
	}];
