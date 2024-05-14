(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*MicroscopeImageSelect*)


(* Updated definition to Command Center *)
DefineUsage[MicroscopeImageSelect,
	{
		BasicDefinitions->{
			{
				Definition->{"MicroscopeImageSelect[microscopeData]","imageAssociations"},
				Description->"returns a list of image associations which satisfy the specified imaging parameters.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"microscopeData",
							Description->"A list of ExperimentImageCells protocol or microscope data objects.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Data,Microscope],Object[Protocol,ImageCells]}]
							]
						},
						IndexName->"Microscope data"
					]
				},
				Outputs:>{
					{
						OutputName->"imageAssociations",
						Description->"Image associations which satisfy the specified imaging parameters.",
						Pattern:>ListableP[_Association]
					}
				}
			}
		},
		SeeAlso->{
			"AnalyzeCellCount",
			"ExperimentImageCells",
			"PlotMicroscope"
		},
		Author->{"scicomp", "brad", "varoth.lilascharoen", "amir.saadat", "kevin.hou"}
	}
];