(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotLuminescenceKinetics*)


DefineUsage[PlotLuminescenceKinetics,
	{
		BasicDefinitions -> {
			{
				Definition->{"PlotLuminescenceKinetics[luminescenceKineticsData]", "plot"},
				Description->"displays emission trajectories from the supplied 'luminescenceKineticsData'.",
				Inputs:>{
					{
						InputName->"luminescenceKineticsData",
						Description->"One or more Object[Data,LuminescenceKinetics] objects containing emission trajectories.",
						Widget->If[
							TrueQ[$ObjectSelectorWorkaround],
							Alternatives[
								"Enter Object(s):"->Widget[Type->Expression,Pattern:>ListableP[ObjectP[Object[Data,LuminescenceKinetics]]],Size->Paragraph],
								"Select Object(s):"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Data,LuminescenceKinetics]],ObjectTypes->{Object[Data,LuminescenceKinetics]}]]
							],
							Alternatives[
								"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Data,LuminescenceKinetics]],ObjectTypes->{Object[Data,LuminescenceKinetics]}],
								"Multiple Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Data,LuminescenceKinetics]],ObjectTypes->{Object[Data,LuminescenceKinetics]}]]
							]			
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"The plot of the emission trajectory.",
						Pattern:>ValidGraphicsP[]
					}
				}
			},
			{
				Definition->{"PlotLuminescenceKinetics[EmissionTrajectoryData]", "plot"},
				Description->"displays luminescence vs time when given a set of raw 'emissionTrajectories'.",
				Inputs:>{
					{
						InputName->"EmissionTrajectoryData",
						Description->"One or more sets of 2D coordinate pairs representing luminescence emission trajectories.",
						Widget->Alternatives[
							"Individual Trajectory"->Adder[Widget[Type->Expression,Pattern:>{UnitCoordinatesP[]..},Size->Paragraph]],
							"Multiple Trajectories"->Widget[Type->Expression,Pattern:>ListableP[{UnitCoordinatesP[]..}],Size->Paragraph]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"The plot of the emission trajectory.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"PlotLuminescenceIntensity",
			"PlotLuminescenceSpectroscopy"
		},
		Author -> {
			"sebastian.bernasek",
			"kevin.hou",
			"hayley"			
		},
		Preview->True
	}
];
