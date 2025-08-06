(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotTrajectory*)


DefineUsage[PlotTrajectory,
	{
		BasicDefinitions->{
			{
				Definition->{"PlotTrajectory[trajectory]","plot"},
				Description->"plots the concentration of all species in 'trajectory' versus time.",
				Inputs:>{
					{
						InputName->"trajectory",
						Description->"One or more Object[Simulation,Kinetics] objects or numeric trajectories to plot.",
						Widget->Alternatives[
							"Enter trajectories:"->Adder[Widget[Type->Expression,Pattern:>TrajectoryP,Size->Paragraph]],
							"Select object(s):"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Simulation,Kinetics]],ObjectTypes->{Object[Simulation,Kinetics]}]]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A visualization of the time evolution of species concentrations.",
						Pattern:>ZoomableP
					}
				}
			},

			{
				Definition->{"PlotTrajectory[trajectory,species]","plot"},
				Description->"plots only the concentrations of 'species'.",
				Inputs:>{
					{
						InputName->"trajectory",
						Description->"One or more Object[Simulation,Kinetics] objects or numeric trajectories to plot.",
						Widget->Alternatives[
							"Enter trajectories:"->Adder[Widget[Type->Expression,Pattern:>TrajectoryP,Size->Paragraph]],
							"Select object(s):"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Simulation,Kinetics]],ObjectTypes->{Object[Simulation,Kinetics]}]]
						]
					},
					{
						InputName->"species",
						Description->"A list of species to be plotted.",
						Widget->Alternatives[
							"Enter individual species:"->Adder[Widget[Type->Expression,Pattern:>ReactionSpeciesP,Size->Line]],
							"Enter all species:"->Widget[Type->Expression,Pattern:>{ReactionSpeciesP..},Size->Line]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A visualization of the time evolution of species concentrations.",
						Pattern:>ZoomableP
					}
				}
			},

			{
				Definition->{"PlotTrajectory[trajectory,indices]","plot"},
				Description->"plots only the species in 'trajectory' whose positions match the 'indices'.",
				Inputs:>{
					{
						InputName->"trajectory",
						Description->"One or more Object[Simulation,Kinetics] objects or numeric trajectories to plot.",
						Widget->Alternatives[
							"Enter trajectories:"->Adder[Widget[Type->Expression,Pattern:>TrajectoryP,Size->Paragraph]],
							"Select object(s):"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Simulation,Kinetics]],ObjectTypes->{Object[Simulation,Kinetics]}]]
						]
					},
					{
						InputName->"indices",
						Description->"A list of indicies of species to plot.",
						Widget->Alternatives[
							"Enter index:"->Adder[Widget[Type->Expression,Pattern:>_Integer,Size->Word]],
							"Enter indices:"->Widget[Type->Expression,Pattern:>{_Integer..},Size->Line]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A visualization of the time evolution of species concentrations.",
						Pattern:>ZoomableP
					}
				}
			},

			{
				Definition->{"PlotTrajectory[trajectory,n]","plot"},
				Description->"plots only the 'n' most abundant species. If 'n'<0, plots the 'n' least abundant species.",
				MoreInformation->"Species abundances are compared at the end of the simulated timecourse.",
				Inputs:>{
					{
						InputName->"trajectory",
						Description->"One or more Object[Simulation,Kinetics] objects or numeric trajectories to plot.",
						Widget->Alternatives[
							"Enter trajectories:"->Adder[Widget[Type->Expression,Pattern:>TrajectoryP,Size->Paragraph]],
							"Select object(s):"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Simulation,Kinetics]],ObjectTypes->{Object[Simulation,Kinetics]}]]
						]
					},
					{
						InputName->"n",
						Description->"The number of species to plot (most abundant if n>0, or least abundant if n<0).",
						Widget->Widget[Type->Expression,Pattern:>n_Integer/;n!=0,Size->Word]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A visualization of the time evolution of species concentrations.",
						Pattern:>ZoomableP
					}
				}
			}
		},
		SeeAlso -> {
			"SimulateKinetics",
			"EmeraldListLinePlot"
		},
		Author -> {"dirk.schild", "sebastian.bernasek", "brad", "alice", "qian", "thomas"},
		Preview->True
	}
];