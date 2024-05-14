(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*PlotQuantificationCycle*)


DefineUsage[PlotQuantificationCycle,
	{
		BasicDefinitions->{
			{
				Definition->{"PlotQuantificationCycle[quantificationCycles]","fig"},
				Description->"plots the normalized and baseline-subtracted amplification curve and quantification cycle from each quantification cycle analysis object in 'quantificationCycles'.",

				Inputs:>{
					{
						InputName->"quantificationCycles",
						Description->"One or more quantification cycle analysis objects.",
						Widget->If[
							TrueQ[$ObjectSelectorWorkaround],
							Alternatives[
								"Enter object(s):"->Widget[Type->Expression,Pattern:>ListableP[ObjectP[Object[Analysis,QuantificationCycle]],1],Size->Paragraph],
								"Select object(s):"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,QuantificationCycle]],ObjectTypes->{Object[Analysis,QuantificationCycle]}]]
							],
							Alternatives[
								"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,QuantificationCycle]],ObjectTypes->{Object[Analysis,QuantificationCycle]}],
								"Multiple Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,QuantificationCycle]],ObjectTypes->{Object[Analysis,QuantificationCycle]}]]
							]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"fig",
						Description->"The quantification cycle plot.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso->{
			"AnalyzeQuantificationCycle",
			"EmeraldListLinePlot"
		},
		Author->{"scicomp", "brad", "sebastian.bernasek", "eqian"},
		Preview->True
	}
];