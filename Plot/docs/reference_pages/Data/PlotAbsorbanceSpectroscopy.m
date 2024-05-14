(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotAbsorbanceSpectroscopy*)


DefineUsage[PlotAbsorbanceSpectroscopy,
	{
		BasicDefinitions->{
			{
				Definition->{"PlotAbsorbanceSpectroscopy[spectroscopyObjects]","plot"},
				Description->"provides a graphical plot of spectra belonging to 'spectroscopyObjects'.",

				Inputs:>{
					{
						InputName->"spectroscopyObjects",
						Description->"One or more objects containing absorbance spectra.",
						Widget->If[
							TrueQ[$ObjectSelectorWorkaround],
							Alternatives[
								"Enter object(s):"->Widget[Type->Expression,Pattern:>ListableP[ObjectP[Object[Data,AbsorbanceSpectroscopy]]],Size->Line],
								"Select object(s):"->Adder@Widget[Type->Object,Pattern:>ObjectP[Object[Data,AbsorbanceSpectroscopy]],ObjectTypes->{Object[Data,AbsorbanceSpectroscopy]}]
							],
							Alternatives[
								"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Data,AbsorbanceSpectroscopy]],ObjectTypes->{Object[Data,AbsorbanceSpectroscopy]}],
								"Multiple Objects"->Adder@Widget[Type->Object,Pattern:>ObjectP[Object[Data,AbsorbanceSpectroscopy]],ObjectTypes->{Object[Data,AbsorbanceSpectroscopy]}]
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
				Definition->{"PlotAbsorbanceSpectroscopy[spectrum]","plot"},
				Description->"provides a graphical plot of the provided spectrum.",

				Inputs:>{
					{
						InputName->"spectrum",
						Description->"The spectrum you wish to plot.",
						Widget->Alternatives[
							"Raw Data"->Widget[Type->Expression,Pattern:>UnitCoordinatesP[],Size->Paragraph]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A graphical representation of the spectrum.",
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
			"sebastian.bernasek",
			"hayley",
			"brad"			
		},
		Preview->True
	}
];
