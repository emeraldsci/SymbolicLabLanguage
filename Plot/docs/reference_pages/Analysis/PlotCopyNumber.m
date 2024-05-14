(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotCopyNumber*)


DefineUsage[PlotCopyNumber,
	{
		BasicDefinitions->{
			{
				Definition->{"PlotCopyNumber[copyNumbers]","fig"},
				Description->"plots the standard curve and Log10[copy number] from each copy number analysis object in 'copyNumbers'.",

				Inputs:>{
					{
						InputName->"copyNumbers",
						Description->"One or more copy number analysis objects.",
						Widget->If[
							TrueQ[$ObjectSelectorWorkaround],
							Alternatives[
								"Enter object(s):"->Widget[Type->Expression,Pattern:>ListableP[ObjectP[Object[Analysis,CopyNumber]],1],Size->Paragraph],
								"Select object(s):"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,CopyNumber]],ObjectTypes->{Object[Analysis,CopyNumber]}]]
							],
							Alternatives[
								"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,CopyNumber]],ObjectTypes->{Object[Analysis,CopyNumber]}],
								"Multiple Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,CopyNumber]],ObjectTypes->{Object[Analysis,CopyNumber]}]]
							]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"fig",
						Description->"A line plot of quantification cycle versus copy number.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso->{
			"AnalyzeCopyNumber",
			"EmeraldListLinePlot"
		},
		Author->{"scicomp", "brad", "sebastian.bernasek", "eqian"},
		Preview->True
	}
];