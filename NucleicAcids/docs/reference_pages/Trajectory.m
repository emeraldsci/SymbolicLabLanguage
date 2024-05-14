(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineUsage[Trajectory,{
	BasicDefinitions->
		{
			{"Trajectory[species,xvals,yvals,units]","trajectory","represents a trajectory describing the behavior ."},
			{"Trajectory[trajectory,subSpeces]","subTrajectory","returns a trajectory containing only the species listed in 'subSpeces'."}
		},
	MoreInformation-> {
		"Use Keys[trajectory] to see the properties that can be dereferenced from a trajectory.",
		"Dereference properties using trajectory[property], e.g. trajectory[Units].",
		"Extract concentration coordinates for a species using trajectory[species]",
		"Extract concentration of a species at a specific time using trajectory[speices,time]"
	},
	Input:>
		{
			{"species",{SpeciesP..},"List of species."},
			{"xvals",{_?NumericQ..},"Independent variable, can be time or temperature."},
			{"yvals",{{_?NumericQ..}..},"Dependent variable, can be concentration or amount.  Order of 'yvals' corresponds to order of 'species'."},
			{"units",{TemperatureP|TimeP,ConcentrationP|AmountP},"Units for 'xvals' and 'yvals'."}

		},
	Output:>
		{
			{"trajectory",TrajectoryP,"A Trajectory construct."},
			{"subTrajectory",TrajectoryP,"A Trajectory containing a subset of the original species."}
		},
	SeeAlso->{"ReactionMechanism","State","SimulateKinetics","PlotTrajectory","ToTrajectory"},
	Author->{
		"brad",
		"alice",
		"qian",
		"thomas"
	}
}];
