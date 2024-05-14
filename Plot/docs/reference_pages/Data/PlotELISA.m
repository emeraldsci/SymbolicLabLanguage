(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotELISA*)

DefineUsage[PlotELISA,
	{
		BasicDefinitions -> {
			{
				Definition->{"PlotELISA[elisaData]", "plot"},
				Description->"displays the absorbance (ELISA), fluorescence (CapillaryELISA with customized cartridges) or analyte concentration (CapillaryELISA with pre-loaded cartridges) vs dilution factors for the supplied 'elisaData'.",
				Inputs:>{
					{
						InputName->"elisaData",
						Description->"ELISA data you wish to plot.",
						Widget->Alternatives[
							"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Data, ELISA]]],
							"Multiple Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Data, ELISA]]]]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"The ELISA plot of absorbance, fluorescence or analyte concentration.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentELISA",
			"ExperimentCapillaryELISA"
		},
		Author -> {"scicomp", "brad", "axu"},
		Preview->True
	}
];