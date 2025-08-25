(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFluorescenceThermodynamics*)


DefineUsage[PlotFluorescenceThermodynamics,
	{
		BasicDefinitions -> {
			{
				Definition->{"PlotFluorescenceThermodynamics[fluorescenceThermodynamicsObject]", "plot"},
				Description->"plots the cooling and melting curves contained by 'fluorescenceThermodynamicsObject'.",
				Inputs:>{
					{
						InputName->"fluorescenceThermodynamicsObject",
						Description->"One or more Object[Data,FluorescenceThermodynamics] objects to be plotted.",
						Widget->If[
							TrueQ[$ObjectSelectorWorkaround],
							Alternatives[
								"Enter Object(s):"->Widget[Type->Expression,Pattern:>ListableP[ObjectP[Object[Data,FluorescenceThermodynamics]]],Size->Paragraph],
								"Select Object(s):"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Data,FluorescenceThermodynamics]],ObjectTypes->{Object[Data,FluorescenceThermodynamics]}]]
							],
							Alternatives[
								"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Data,FluorescenceThermodynamics]],ObjectTypes->{Object[Data,FluorescenceThermodynamics]}],
								"Multiple Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Data,FluorescenceThermodynamics]],ObjectTypes->{Object[Data,FluorescenceThermodynamics]}]]
							]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A 2D visualization of the melting curve.",
						Pattern:>ValidGraphicsP[]
					}
				}
			},
			{
				Definition -> {"PlotFluorescenceThermodynamics[protocol]", "plot"},
				Description -> "creates a 'plot' of the cooling and melting curves found in the Data field of 'protocol'.",
				Inputs :> {
					{
						InputName -> "protocol",
						Description -> "The protocol object containing fluorescence thermodynamics data objects.",
						Widget -> Alternatives[
							Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, FluorescenceThermodynamics]]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "The figure generated from data found in the fluorescence thermodynamics protocol.",
						Pattern :> ValidGraphicsP[]
					}
				}
			}
		},		
		SeeAlso -> {
			"PlotFluorescenceIntensity",
			"PlotFluorescenceKinetics"
		},
		Author -> {"dirk.schild", "sebastian.bernasek", "hayley", "brad"},
		Preview->True
	}
];