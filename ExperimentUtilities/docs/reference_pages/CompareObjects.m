(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*CompareObjects*)

DefineUsage[
	CompareObjects,
	{
		BasicDefinitions->{
			{"CompareObjects[objects]","summary","prints a table containing the field names and field values for any fields that have different contents between the 'objects'."},
			{"CompareObjects[object1,object2]","summary","prints a table containing the field names and field values for any fields that have different contents between 'object1' and 'object2'."}
		},
		AdditionalDefinitions->{},
		MoreInformation->{
			"By default, the function only prints fields for which the values differ. However, it can be specified to print all fields and highlight those that differ."
		},
		Input:>{
			{"objects",{ObjectP[]...},"A list of objects to compare."},
			{"object1",{ObjectP[]...},"First object to compare."},
			{"object2",{ObjectP[]...},"Second object to compare."}
		},
		Output:>{
			{"summary",_,"A table highlighting the similarities and differences in field population between the objects."}
		},
		SeeAlso->{

		},
		Author->{"david.ascough", "dirk.schild"}
	}
];
