(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*PlotCapillaryIsoelectricFocusing*)


DefineUsage[PlotCapillaryIsoelectricFocusing,
	{
		BasicDefinitions -> {
			{
				Definition->{"PlotCapillaryIsoelectricFocusing[dataObject]", "plot"},
				Description->"generates a graphical plot of the data stored in a CapillaryIsoelectricFocusing data object.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "dataObject",
							Description-> "The CapillaryIsoelectricFocusing data to be plotted.",
							Widget->Widget[Type->Object,Pattern:>ObjectP[Object[Data,CapillaryIsoelectricFocusing]]]
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
				Definition->{"PlotCapillaryIsoelectricFocusing[chromatograph]", "plot"},
				Description->"generates a graphical plot of the provided CapillaryIsoelectricFocusing data.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "electrophoratogram",
							Description-> "The electrophoresis data you wish to plot.",
							Widget->Alternatives[
									(* Distance vs absorbance*)
									Adder[{
										"Distance"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0*Pixel],Units:>Pixel],
										"Absorbance"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0*AbsorbanceUnit],Units:>AbsorbanceUnit]
									}],
									(* Distance vs Fluorescence*)
									Adder[{
										"Distance"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0*Pixel],Units:>Pixel],
										"Fluorescence"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0*RFU],Units:>RFU]
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
			"PlotCapillaryIsoelectricFocusingEvolution",
			"PlotCapillaryGelElectrophoresisSDS",
			"PlotPAGE"
		},
		Author -> {
			"gil.sharon"
		},
		Preview->True
	}];
