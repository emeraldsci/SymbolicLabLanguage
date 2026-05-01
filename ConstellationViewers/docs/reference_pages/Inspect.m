(* ::Subsubsection::Closed:: *)
(*Inspect*)

(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineUsage[TwelveHourDateString, {
	BasicDefinitions -> {
		{"TwelveHourDateString[dateObject]", "twelveHourDateString", "converts a DateObject[...] to a string in the format \"Date\" \"Hour12\":\"Minute\":\"Second\" \"AMPMLowerCase\"."}
	},
	Input :> {
		{"dateObject", _DateObject, "The date object to be converted."}
	},
	Output :> {
		{"twelveHourDateString", _String, "The string in the format \"Date\" \"Hour12\":\"Minute\":\"Second\" \"AMPMLowerCase\"."}
	},
	MoreInformation -> {},
	Sync -> Automatic,
	SeeAlso -> {},
	Tutorials -> {},
	Author -> {"platform"}
}];

DefineUsage[Inspect, {
	BasicDefinitions -> {
		{
			Definition -> {"Inspect[object]", "table"},
			Description -> "displays all of the information stored in the database for 'object' in a formatted grid with a plot of the object followed by its fields and values.",
			Inputs :> {
				{
					InputName -> "object",
					Description -> "An object whose database information you want to inspect.",
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[Types[]], PreparedSample -> False, PreparedContainer -> False, PatternTooltip -> "Must match ObjectP[]."]
				}
			},
			Outputs :> {
				{
					OutputName -> "table",
					Description -> "A formatted version of the input object's database information placed in a grid for display.",
					Pattern :> _Grid
				}
			}
		},
		{
			Definition -> {"Inspect[type]", "nbObj"},
			Description -> "Opens a Type Definitions Viewer in a separate window.",
			Inputs :> {
				{
					InputName -> "type",
					Description -> "A type whose database information you want to inspect.",
					Widget -> With[{typeAlternatives=Apply[Alternatives, Types[]]},
						Alternatives[
							"Select Type" -> Widget[Type -> Enumeration, Pattern :> typeAlternatives, PatternTooltip -> "Must match TypeP[]"],
							"Enter Type" -> Widget[Type -> Expression, Pattern :> TypeP[], PatternTooltip -> "Valid types have the form Object[type,subtype] or Model[type,subtype]", Size -> Word]
						]
					]
				}
			},
			Outputs :> {
				{
					OutputName -> "nbObj",
					Description -> "The Emerald Cloud Lab Type Definitions Viewer notebook object",
					Pattern :> _NotebookObject
				}
			}
		}
	},
	SeeAlso -> {
		"Download",
		"PlotObject"
	},
	Author -> {
		"platform",
		"kevin.hou",
		"brad",
		"frezza"
	},
	Preview -> True
}];
