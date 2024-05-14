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
			}
		},
		SeeAlso -> {
			"PlotAbsorbanceSpectroscopy",
			"PlotFluorescenceSpectroscopy",
			"PlotLuminescenceKinetics"
		},
		Author -> {
			"sebastian.bernasek",
			"hayley"
		},
		Preview->True
	}
];
