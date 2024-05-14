(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*PlotCapillaryGelElectrophoresisSDS*)


DefineUsage[PlotCapillaryGelElectrophoresisSDS,
	{
		BasicDefinitions -> {
			{
				Definition->{"PlotCapillaryGelElectrophoresisSDS[dataObject]", "plot"},
				Description->"generates a graphical plot of the data stored in a CapillaryGelElectrophoresisSDS data object.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "dataObject",
							Description-> "The CapillaryGelElectrophoresisSDS data to be plotted.",
							Widget->Widget[Type->Object,Pattern:>ObjectP[Object[Data,CapillaryGelElectrophoresisSDS]]]
						},
						IndexName -> "dataObject"
					]
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A graphical representation of the protein separation trace.",
						Pattern:>_Graphics
					}
				}
			},
			{
				Definition->{"PlotCapillaryGelElectrophoresisSDS[chromatograph]", "plot"},
				Description->"generates a graphical plot of the provided CapillaryGelElectrophoresisSDS data.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "electrophoratogram",
							Description-> "The electrophoresis data you wish to plot.",
							Widget->Alternatives[
								(* Migration Time vs absorbance*)
								Adder[{
									"Migration Time"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0*Second],Units:>Second],
									"Absorbance"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0*AbsorbanceUnit],Units:>AbsorbanceUnit]
								}]
							]
						},
						IndexName -> "dataObject"
					]
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A graphical representation of the protein separation trace.",
						Pattern:>_Graphics
					}
				}
			}
		},
		SeeAlso -> {
			"PlotCapillaryIsoelectricFocusing",
			"PlotChromatography",
			"PlotPAGE"
		},
		Author -> {
			"gil.sharon",
			"kevin.hou"
		},
		Preview->True
	}];
