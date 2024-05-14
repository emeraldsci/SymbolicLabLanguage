(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*TrajectoryRegression*)


DefineUsage[TrajectoryRegression,
{
	BasicDefinitions -> {
		{"TrajectoryRegression[sim]", "concAll", "extracts concentrations of all species at all times from the Trajectory 'sim'."},
		{"TrajectoryRegression[sim,t]", "concOneTime", "extracts concentrations of all species at time 't'."},
		{"TrajectoryRegression[sim,spec]", "concOneSpec", "extracts concentration of species 'spec' at all times."},
		{"TrajectoryRegression[sim,spec,t]", "concOne", "extracts concentration of species 'spec' at time 't'."}
	},
	Input :> {
		{"sim", TrajectoryP, "A Trajectory to extract concentrations from."},
		{"t", _?NumericQ | _?TimeQ | End, "A time or list of times at which to extract concentrations.  With or without time Units.  Can also use the symbol End to denote the last time point in the Trajectory."},
		{"spec", ReactionSpeciesP, "Name of species to extract concentration of."}
	},
	Output :> {
		{"concAll", {{_?NumberQ..}..}, "An array of size n x k, where n is number of time points and k is number of species, containing the concentration of all species in 'sim' at all times."},
		{"concOneTime", {_?NumberQ..}, "A list of size k, where k is number of species, containing the concentrations of all species at one time."},
		{"concOneSpec", {_?NumberQ..}, "A list of size n, where n is number of time points, containing the concentrations of one species at all times."},
		{"concOne", _?NumberQ, "Concentration of a single species at a single time."}
	},
	SeeAlso -> {
		"SimulateKinetics",
		"KineticTrajectory",
		"ToTrajectory"
	},
	Author -> {
		"brad",
		"alice",
		"qian",
		"thomas"
	}
}];


(* ::Subsubsection:: *)
(*NameMotifs*)


DefineUsage[NameMotifs,
{
	BasicDefinitions -> {
		{"NameMotifs[item:(StructureP|StrandP|SequenceP)]", "named:(StructureP|StrandP|SequenceP)", "takes either a Structure, strand, or a sequence, and names any unnamed motifs with a unique string generated using Unique[]."}
	},
	Input :> {
		{"item", _, "Any Structure, strand, or explicitly typed sequence."}
	},
	Output :> {
		{"named", _, "The Structure, strand, or sequence with unique names inserted for any unnamed motifs."}
	},
	SeeAlso -> {
		"SpeciesList",
		"ToStrand"
	},
	Author -> {
		"brad"
	}
}];


(* ::Subsubsection:: *)
(*SpeciesList*)


DefineUsage[SpeciesList,
{
	BasicDefinitions -> {
		{"SpeciesList[reactions]", "out", "returns a list of unique species present in the given reactions."}
	},
	Input :> {
		{"reactions", _ReactionMechanism | {ImplicitReactionP..}, "Set of reactions to pull species from."}
	},
	Output :> {
		{"out", {SpeciesP...}, "All species present in 'reactions'."}
	},
	SeeAlso -> {
		"ReactionMechanism",
		"ToStructure"
	},
	Author -> {
		"brad",
		"alice",
		"qian",
		"thomas"
	}
}];


(* ::Subsubsection:: *)
(*ToReactionMechanism*)


DefineUsage[ToReactionMechanism,
{
	BasicDefinitions -> {
		{"ToReactionMechanism[reactionList]", "mech", "contrusts a properly formatted ReactionMechanism from the given reactions and rates."}
	},
	Input :> {
		{"reactionList", {ImplicitReactionP...}, "List of reactions and rates."}
	},
	Output :> {
		{"mech", ReactionMechanismP, "A properly formatted ReactionMechanism."}
	},
	SeeAlso -> {
		"ReactionMechanismQ",
		"SimulateKinetics",
		"PlotReactionMechanism",
		"Reaction"
	},
	Author -> {
		"brad",
		"alice",
		"qian",
		"thomas"
	}
}];



(* ::Subsubsection::Closed:: *)
(*ToSequence*)


DefineUsage[ToSequence,
{
	BasicDefinitions -> {
		{"ToSequence[com]", "comSeqs", "returns a list of sequences in the strand."},
		{"ToSequence[str]", "strSeqs", "returns a list of sequences in the motifs."}
	},
	Input :> {
		{"com", StructureP, "The Structure whose sequences will be returned."},
		{"str", StrandP, "The strand whose sequences will be returned."}
	},
	Output :> {
		{"strSeqs", {_String..}, "List of sequences in 'str'."},
		{"comSeqs", {{_String..}..}, "List of sequences in each strand in 'com'."}
	},
	SeeAlso -> {
		"ToStrand",
		"ToStructure",
		"SequenceQ"
	},
	Author -> {
		"brad",
		"alice",
		"qian",
		"thomas"
	}
}];


(* ::Subsubsection:: *)
(*ToState*)


DefineUsage[ToState,
{
	BasicDefinitions -> {
		{"ToState[speciesRules]", "s", "converts a list of rules, relating species name with concentration, to a properly formatted state."},
		{"ToState[speciesRules,unit]", "s", "add 'unit' to all of the values in the state."}
	},
	Input :> {
		{"speciesRules", {InitialConditionP..}, "Specifies species and concentrations."},
		{"unit", UnitsP[], "Unit to add to the state."}
	},
	Output :> {
		{"s", StateP, "A properly formatted _State."}
	},
	SeeAlso -> {
		"ToReactionMechanism",
		"ToTrajectory",
		"StateQ"
	},
	Author -> {
		"brad",
		"alice",
		"qian",
		"thomas"
	}
}];


(* ::Subsubsection::Closed:: *)
(*ToStrand*)


DefineUsage[ToStrand,
{
	BasicDefinitions -> {
		{"ToStrand[seq]", "str", "returns a single strand containing one or more motifs, specified by 'seq'."},
		{"ToStrand[seqs]", "str", "returns a list of strands where each strand contains the motifs defined in the sublist 'seqs'."},
		{"ToStrand[struct]", "strs", "extracts the list of strands from 'struct'."}
	},
	MoreInformation -> {
		"List of sequence inputs are treated as motifs in a single strand",
		"Use double list to receive multiple strands",
		"Listable over Polymer and Motif options",
		"Options will have their dimensions expanded to match input list",
		"Same Labels are appeneded with integers to make all labels unique"
	},
	Input :> {
		{"seq", _String | {_String...}, "Sequence(s) to put into a strand."},
		{"seqs", {{_String...}...}, "Sequences to put into a strand."},
		{"com", StructureP, "A Structure to pull strands from."}
	},
	Output :> {
		{"str", StrandP, "A properly formatted strand."},
		{"strs", {StrandP...}, "List of strand from 'struct'."}
	},
	SeeAlso -> {
		"ToStructure",
		"ToSequence"
	},
	Author -> {
		"brad",
		"alice",
		"qian",
		"thomas"
	}
}];


(* ::Subsubsection::Closed:: *)
(*ToStructure*)


DefineUsage[ToStructure,
{
	BasicDefinitions -> {
		{"ToStructure[seq]", "out", "returns a single Structure containing a single strand.  The strand will contain 'seq' as its lone motif."},
		{"ToStructure[seqList]", "out_Structure", "returns a single Structure containing a single strand.  Each element of 'seqList' is a motif in the strand."},
		{"ToStructure[seqSuperList]", "out_Structure", "returns a single Structure containing multiple strands.  Each sublist of 'seqSuperList' becones a strand."}
	},
	Input :> {
		{"seq", StrandP | SequenceP, "A sequence or strand to be formatted as a Structure."},
		{"seqList", {SequenceP..}, "A list of sequences that will be inserted into a single strand in the Structure."},
		{"seqSuperList", {{SequenceP..}..}, "Each sublist is inserted into a strand."}
	},
	Output :> {
		{"out", StructureP, "A properly formatted Structure."}
	},
	SeeAlso -> {
		"ToStrand",
		"ToSequence"
	},
	Author -> {
		"brad",
		"alice",
		"qian",
		"thomas"
	}
}];


(* ::Subsubsection:: *)
(*sortAndReformatStructures*)


DefineUsage[sortAndReformatStructures,
	{
		BasicDefinitions -> {
			{"sortAndReformatStructures[expr]", "processedExpr", "finds any structures in 'expr' and sorts them and reformats their bonds into motif baseapair format."}
		},
		Input :> {
			{"expr", _, "An expression that might contain structures."}
		},
		Output :> {
			{"processedExpr", _, "An expression whose structures have been sorted and reformatted."}
		},
		SeeAlso -> {
			"StructureSort",
			"Structure"
		},
		Author -> {
			"brad",
			"alice",
			"qian",
			"thomas"
		}
	}];



(* ::Subsubsection:: *)
(*ToTrajectory*)


DefineUsage[ToTrajectory,
{
	BasicDefinitions -> {
		{"ToTrajectory[specs,concs,times,{timeUnit,concUnit}]", "traj", "transforms a list of data points and time points into a properly formatted Trajectory."},
		{"ToTrajectory[specs,concs,times]", "traj", "assumes time unit of Second and concentration unit of Molar."},
		{"ToTrajectory[concs,times,{timeUnit,concUnit}]", "traj", "names the species sequentially in alphabetical order starting with \"A\"."},
		{"ToTrajectory[concs,times]", "traj", "assumes time unit of Second and concentration unit of Molar and names the species in alphabetical order."},
		{"ToTrajectory[specs,interpFunc,{timeUnit,concUnit}]", "traj", "parses the data and time points out of the InterpolatingFunction 'interpFunc' and formats them as a Trajectory."},
		{"ToTrajectory[specs,interpFunc]", "traj", "assumes time unit of Second and concentration unit of Molar and names the species in alphabetical order."}
	},
	Input :> {
		{"specs", {ReactionSpeciesP..}, "List of species names."},
		{"concs", {{_?NumericQ..}..}, "Concentrations of the species at each time point."},
		{"times", {_?NumericQ..}, "List of time points."},
		{"timeUnit", _?UnitsQ, "Units for time variables."},
		{"concUnit", _?UnitsQ, "Units for concentration variables."},
		{"interpFunc", _InterpolatingFunction, "Interpolating function (output of NDSolve) describing concentrations of species over time."}
	},
	Output :> {
		{"traj", TrajectoryP, "A properly formatted Trajectory."}
	},
	SeeAlso -> {
		"ToState",
		"SimulateKinetics",
		"KineticTrajectory",
		"SimulateMeltingCurve"
	},
	Author -> {
		"brad",
		"alice",
		"qian",
		"thomas"
	}
}];
