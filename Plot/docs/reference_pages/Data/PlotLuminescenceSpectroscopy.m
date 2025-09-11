(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotLuminescenceSpectroscopy*)


DefineUsage[PlotLuminescenceSpectroscopy,
	{
		BasicDefinitions -> {
			{
				Definition->{"PlotLuminescenceSpectroscopy[luminescenceSpectroscopyData]", "plot"},
				Description->"displays luminescence intensity vs wavelength for the supplied 'luminescenceSpectroscopyData'.",
				Inputs:>{
					{
						InputName->"luminescenceSpectroscopyData",
						Description->"One or more Object[Data,LuminescenceSpectroscopy] objects containing emission spectra.",
						Widget->If[
							TrueQ[$ObjectSelectorWorkaround],
							Alternatives[
								"Enter Object(s):"->Widget[Type->Expression,Pattern:>ListableP[ObjectP[Object[Data,LuminescenceSpectroscopy]]],Size->Paragraph],
								"Select Object(s):"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Data,LuminescenceSpectroscopy]]]]
							],
							Alternatives[
								"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Data,LuminescenceSpectroscopy]]],
								"Multiple Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Data,LuminescenceSpectroscopy]]]]
							]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A 2D visualization of luminescence intensity as a function of wavelength.",
						Pattern:>ValidGraphicsP[]
					}
				}
			},
			{
				Definition -> {"PlotLuminescenceSpectroscopy[protocol]", "plot"},
				Description -> "creates a 'plot' of luminescence intensity vs wavelength for the data found in the Data field of 'protocol'.",
				Inputs :> {
					{
						InputName -> "protocol",
						Description -> "The protocol object containing luminescence spectroscopy data objects.",
						Widget -> Alternatives[
							Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, LuminescenceSpectroscopy]]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "The figure generated from data found in the luminescence spectroscopy protocol.",
						Pattern :> ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"PlotAbsorbanceSpectroscopy",
			"PlotFluorescenceSpectroscopy",
			"PlotLuminescenceKinetics"
		},
		Author -> {"ben", "sebastian.bernasek", "hayley"},
		Preview->True
	}
];