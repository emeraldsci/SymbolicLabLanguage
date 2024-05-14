(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*PlotCapillaryIsoelectricFocusingEvolution*)


DefineUsage[PlotCapillaryIsoelectricFocusingEvolution,
	{
		BasicDefinitions -> {
			{
				Definition->{"PlotCapillaryIsoelectricFocusingEvolution[dataObject]", "plot"},
				Description->"generates a graphical plot of the separation evolution data stored in a CapillaryIsoelectricFocusing data object.",
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
						Description->"A graphical representation of the evolution of protein separation in isoelectric focusing over time.",
						Pattern:>_Graphics
					}
				}
			},
			{
				Definition->{"PlotCapillaryIsoelectricFocusingEvolution[chromatograph]", "plot"},
				Description->"generates a graphical plot of the provided CapillaryIsoelectricFocusing separation data over time.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "electrophoratogram",
							Description-> "The electrophoresis data you wish to plot over time.",
							Widget->Alternatives[
								(* Distance vs absorbance*)
								Adder[Adder[{
									"Distance"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0*Pixel],Units:>Pixel],
									"Absorbance"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0*AbsorbanceUnit],Units:>AbsorbanceUnit]
								}]],
								(* Distance vs Fluorescence*)
								Adder[Adder[{
									"Distance"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0*Pixel],Units:>Pixel],
									"Fluorescence"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0*RFU],Units:>RFU]
								}]]
							]
						},
						IndexName -> "dataObject"
					]
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A graphical representation of the evolution of protein separation in isoelectric focusing over time.",
						Pattern:>_Graphics
					}
				}
			}
		},
		SeeAlso -> {
			"PlotCapillaryIsoelectricFocusing",
			"PlotCapillaryGelElectrophoresisSDS",
			"PlotPAGE"
		},
		Author -> {
			"gil.sharon"
		},
		Preview->True
	}];
