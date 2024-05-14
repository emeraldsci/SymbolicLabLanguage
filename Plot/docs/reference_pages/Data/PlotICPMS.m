(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotICPMS*)

DefineUsage[PlotICPMS,
	{
		BasicDefinitions -> {
			{
				Definition->{"PlotICPMS[ICPMSData]", "plot"},
				Description->"provides a graphical plot the provided ICP-MS spectra.",
				Inputs:>{
					{
						InputName->"ICPMSData",
						Description->"The spectra you wish to plot.",
						Widget->Widget[Type->Object,Pattern:>ObjectP[Object[Data,ICPMS]]]
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
				Definition->{"PlotICPMS[spectra]", "plot"},
				Description->"provides a graphical plot the provided ICP-MS spectra.",
				Inputs:>{
					{
						InputName->"spectra",
						Description->"The spectra you wish to plot.",
						Widget->Widget[Type->Expression,Pattern:>CoordinatesP,Size->Paragraph]
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
			"PlotChromatography",
			"PlotNMR"
		},
		Author -> {
			"hanming.yang"
		},
		Preview->True
	}
]