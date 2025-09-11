(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotAbsorbanceKinetics*)


DefineUsage[PlotAbsorbanceKinetics,
	{
		BasicDefinitions->{
			{
				Definition->{"PlotAbsorbanceKinetics[spectroscopyObjects]","plot"},
				Description->"provides a graphical plot of the trajectory stored in the object 'spectroscopyObjects'.",

				Inputs:>{
					{
						InputName->"spectroscopyObjects",
						Description->"One or more objects containing absorbance spectra.",
						Widget->If[
							TrueQ[$ObjectSelectorWorkaround],
							Alternatives[
								"Enter object(s):"->Widget[Type->Expression,Pattern:>ListableP[ObjectP[Object[Data,AbsorbanceKinetics]]],Size->Line],
								"Select object(s):"->Adder@Widget[Type->Object,Pattern:>ObjectP[Object[Data,AbsorbanceKinetics]],ObjectTypes->{Object[Data,AbsorbanceKinetics]}]
							],
							Alternatives[
								"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Data,AbsorbanceKinetics]],ObjectTypes->{Object[Data,AbsorbanceKinetics]}],
								"Multiple Objects"->Adder@Widget[Type->Object,Pattern:>ObjectP[Object[Data,AbsorbanceKinetics]],ObjectTypes->{Object[Data,AbsorbanceKinetics]}]
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
				Definition -> {"PlotAbsorbanceKinetics[protocol]", "plot"},
				Description -> "creates a 'plot' of the trajectory values in the data objects found in the Data field of 'protocol'.",
				Inputs :> {
					{
						InputName -> "protocol",
						Description -> "The protocol object containing absorbance kinetics data objects.",
						Widget -> Alternatives[
							Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, AbsorbanceKinetics]]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "The figure generated from data found in the absorbance kinetics protocol.",
						Pattern :> ValidGraphicsP[]
					}
				}
			},
			{
				Definition->{"PlotAbsorbanceKinetics[spectrum]","plot"},
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
			"PlotAbsorbanceSpectroscopy",
			"PlotNMR"
		},
		Author -> {"yanzhe.zhu", "amir.saadat", "hayley", "brad"},
		Preview->True
	}
];