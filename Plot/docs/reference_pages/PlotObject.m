(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*PlotObject*)


(* Define pattern for allowable data types *)
dataTypeP=Alternatives@@Sort@(First@#&/@Cases[Keys@DownValues@Plot`Private`plotObject,Plot`Private`plotObject[_Symbol,___],-1]);


DefineUsage[PlotObject,
{
	BasicDefinitions -> {
		{
			Definition->{"PlotObject[object]", "fig"},
			Description->"creates a plot of the information in 'object' using a style determined by the SLL Type of 'object'.",
			Inputs:>{
				{
					InputName->"object",
					Description->"An object to plot.",
					Widget->If[
						TrueQ[$ObjectSelectorWorkaround],
						Alternatives[
							"Enter Object(s):"->Widget[Type->Expression,Pattern:>ListableP[ObjectP[Types[]]],Size->Paragraph,PatternTooltip->"Input must match ListableP[TypeP[]]"],
							"Select Object(s):"->Adder[Widget[Type->Object,Pattern:>ObjectP[Types[]],PreparedSample->False,PreparedContainer->False,PatternTooltip->"Input must match TypeP[]"]]
						],
						Alternatives[
							"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Types[]],PreparedSample->False,PreparedContainer->False,PatternTooltip->"Input must match TypeP[]"],
							"Multiple Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Types[]],PreparedSample->False,PreparedContainer->False,PatternTooltip->"Input must match TypeP[]"]]
						]
					]
				}
			},
			Outputs:>{
				{
					OutputName->"fig",
					Description->"A visual display of the input.",
					Pattern:>ValidGraphicsP[]
				}
			}
		},
		{
			Definition->{"PlotObject[type,rawData]", "fig"},
			Description->"plots 'rawData' in the appropriate plot style for 'type'.",
			Inputs:>{
				{
					InputName->"type",
					Description->"An SLL Type to associate with the 'rawData'.",
					Widget->Alternatives[
						"Select Type:"->Widget[Type->Enumeration,Pattern:>dataTypeP],
						"Enter Type:"->Widget[Type->Expression,Pattern:>dataTypeP,Size->Word]
					]
				},
				{
					InputName->"rawData",
					Description->"Data points to plot.",
					Widget->Widget[Type->Expression,Pattern:>ListableP[UnitCoordinatesP[],1],Size->Paragraph,PatternTooltip->"Input must match ListableP[UnitCoordinatesP[]]."]
				}
			},
			Outputs:>{
				{
					OutputName->"fig",
					Description->"A visual display of the input.",
					Pattern:>ValidGraphicsP[]
				}
			}
		}
	},
	MoreInformation -> {
		"Given a Constellation object as input, PlotObject automatically determines the appropriate function to plot the object.",
		"To check which plot function PlotObject redirects to, please run PlotObjectFunction[myInput] in the notebook.",
		"See the Examples below for a list of possible plot functions, and links to their respective documentation pages."
	},
	SeeAlso -> {
		"EmeraldBarChart",
		"EmeraldListLinePlot",
		"PlotChromatography",
		"PlotPeaks"
	},
	Author -> {"dirk.schild", "eunbin.go", "ryan.bisbey", "charlene.konkankit", "cgullekson", "sebastian.bernasek", "kevin.hou", "hayley", "brad"},
	Preview->True
}];

DefineUsage[PlotObjectFunction,
	{
		BasicDefinitions->{
			{"PlotObjectFunction[object]", "function", "for 'object', returns the downstram plot 'function' used by PlotObject."}
		},
		Input:>{
			{"object",ObjectP[],"An object to plot."}
		},
		Output:>{
			{"function",_Symbol,"A function used by PlotObjects."}
		},
		MoreInformation->{
		},
		SeeAlso->{
			"PlotObject"
		},
		Author->{"pnafisi", "kelmen.low"}
	}
];