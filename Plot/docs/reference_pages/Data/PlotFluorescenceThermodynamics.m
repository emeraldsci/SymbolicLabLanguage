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
			}
		},		
		SeeAlso -> {
			"PlotFluorescenceIntensity",
			"PlotFluorescenceKinetics"
		},
		Author -> {
			"sebastian.bernasek",
			"hayley",
			"brad"			
		},
		Preview->True
	}
];
