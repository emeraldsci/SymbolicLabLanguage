(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotAbsorbanceQuantification*)


DefineUsage[PlotAbsorbanceQuantification,
	{
		BasicDefinitions->{

			{
				Definition->{"PlotAbsorbanceQuantification[quantAnalysis]","plot"},
				Description->"generates a line plot of the Object[Data,AbsorbanceSpectroscopy] associated with each item in 'quantAnalysis'.",

				Inputs:>{
					{
						InputName->"quantAnalysis",
						Description->"One or more Object[Analysis,AbsorbanceQuantification] objects containing Object[Data,AbsorbanceSpectroscopy] to be plotted.",
						Widget->If[
							TrueQ[$ObjectSelectorWorkaround],
							Alternatives[
								"Enter object(s):"->Widget[Type->Expression,Pattern:>ListableP[ObjectP[Object[Analysis,AbsorbanceQuantification]]],Size->Paragraph],
								"Select object:"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,AbsorbanceQuantification]],ObjectTypes->{Object[Analysis,AbsorbanceQuantification]}]]
							],
							Alternatives[
								"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,AbsorbanceQuantification]],ObjectTypes->{Object[Analysis,AbsorbanceQuantification]}],
								"Multiple Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,AbsorbanceQuantification]],ObjectTypes->{Object[Analysis,AbsorbanceQuantification]}]]
							]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A graphical representation of the spectra.",
						Pattern:>ValidGraphicsP[]
					}
				}
			},
			{
				Definition->{"PlotAbsorbanceQuantification[quantProtocol]","plot"},
				Description->"generates a line plot of the Object[Data,AbsorbanceSpectroscopy] associated with each item in 'quantProtocol'.",

				Inputs:>{
					{
						InputName->"quantProtocol",
						Description->"One or more protocol[AbsorbanceQuantification] objects containing Object[Data,AbsorbanceSpectroscopy] to be plotted.",
						Widget->If[
							TrueQ[$ObjectSelectorWorkaround],
							Alternatives[
								"Enter object(s):"->Widget[Type->Expression,Pattern:>ListableP[ObjectP[Object[Protocol,AbsorbanceQuantification]]],Size->Paragraph],
								"Select object:"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,AbsorbanceQuantification]],ObjectTypes->{Object[Protocol,AbsorbanceQuantification]}]]
							],
							Alternatives[
								"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,AbsorbanceQuantification]],ObjectTypes->{Object[Protocol,AbsorbanceQuantification]}],
								"Multiple Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,AbsorbanceQuantification]],ObjectTypes->{Object[Protocol,AbsorbanceQuantification]}]]
							]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A graphical representation of the spectra.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentAbsorbanceSpectroscopy",
			"AnalyzeAbsorbanceQuantification"
		},
		Author -> {"dirk.schild", "sebastian.bernasek", "brad"},
		Preview->True
	}
];