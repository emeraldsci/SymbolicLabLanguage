(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*Pairing*)


DefineUsage[Pairing,
{
	BasicDefinitions -> {
		{"Pairing[seqA, seqB]", "pairs", "returns all possible pairings of 'seqA' and 'seqB'."},
		{"Pairing[{seqA,intervalA, seqB]", "pairs", "returns only pairs touching some part of 'intervalA' on 'seqA'."},
		{"Pairing[seqA, {seqB,intervalB}]", "pairs", "returns only pairs touching some part of 'intervalB' on 'seqB'."},
		{"Pairing[{seqA,intervalA, {seqB,intervalB}]", "pairs", "returns only pairs touching some both part of 'intervalA' on 'seqA' and part of 'intervalB' on 'seqB'."}
	},
	MoreInformation -> {
		"Note that interval specification is different for sequences, strands, and structures"
	},
	Input :> {
		{"seqA", _?SequenceQ | _?StrandQ | _?StructureQ, "First thing to pair."},
		{"seqB", _?SequenceQ | _?StrandQ | _?StructureQ, "Second thing to pair."},
		{"intervalA", {_Integer, _Integer} | {_Integer, {_Integer, _Integer}} | {_Integer, _Integer, {_Integer, _Integer}}, "Interval on 'seqA' to pair onto."},
		{"intervalB", {_Integer, _Integer} | {_Integer, {_Integer, _Integer}} | {_Integer, _Integer, {_Integer, _Integer}}, "Interval on 'seqB' to pair onto."}
	},
	Output :> {
		{"pairs", {_?StructureQ...}, "A list of structures containing all pairings of 'seqA' and 'seqB'."}
	},
	SeeAlso -> {
		"SimulateFolding",
		"SimulateReactivity"
	},
	Author -> {"scicomp", "brad", "qian"}
}];


(* ::Subsubsection:: *)
(*SimulateFolding*)


DefineUsageWithCompanions[SimulateFolding,{
	BasicDefinitions->{
		{
			Definition -> {"SimulateFolding[oligomer]", "foldingObject"},
			Description->"predicts potential secondary structure interactions of the provided 'oligomer' with itself.",
			Inputs:>{
				{
					InputName->"oligomer",
					Widget->
						Alternatives[
							Widget[Type->Object, Pattern:> ObjectP[{Object[Sample],  Model[Sample]}],PreparedContainer->False,PreparedSample->False],
							Widget[Type->Expression, Pattern:> SequenceP | StrandP | StructureP , PatternTooltip->"Sequence, strand with one or more motifs, or structure", Size->Line],
							Adder[
								Alternatives[
									Widget[Type->Object, Pattern:> ObjectP[{Object[Sample],  Model[Sample]}],PreparedContainer->False,PreparedSample->False],
									Widget[Type->Expression, Pattern:> SequenceP | StrandP | StructureP , PatternTooltip->"Sequence, strand with one or more motifs, or structure", Size->Line]
								]
							]
					],
					Expandable->False,
					Description->"Initial sequence, or strand, or structure to fold from."
				}
			},
			Outputs:> {
				{
					OutputName->"foldingObject",
					Pattern:> ObjectP[Object[Simulation, Folding]],
					Description->"An Object[Simulation, Folding] object or packet describing the folding behavior of 'oligomer'."
				}
			}
		}
	},
	MoreInformation -> {
		"Kinetic method is an implementation of Nussinov's dynamic programing algorithm described in Object[Report, Literature, \"id:E8zoYveXdRWm\"]: R. Nussinov et al. \"Algorithms for loop matchings.\" SIAM Journal on Applied mathematics 35.1 (1978): 68-82.",
		"Thermodynamic method is an implementation of Zuker's free energy minimization algorithm described in Object[Report, Literature, \"id:GmzlKjYVz86e\"]: M. Zuker. \"On finding all suboptimal foldings of an RNA molecule.\" Science 244.4900 (1989): 48-100.",
		"The Thermodynamic folding allows only for planar folding and thus can not detect so called \"pseudoknots\", which can be found by the Kinetic method. However, structures returned by the Kinetic method places no constraints on which bases can pair and therefore may not necessarily be topologically obtainable.",
		"Following loops can appear in folded structures:",
		Grid[{
			{"Loop", "Description"},
			{"StackingLoop", "Watson-Crick paired nucleotides on both strands."},
			{"BulgeLoop", "Unpaired nucleotides occur on only one strand of double helix."},
			{"InternalLoop", "Double helix interrupted by non-Watson-Crick paired nucleotides on both strands."},
			{"MultipleLoop", "Three or more helixes intersect."}
		}]
	},
	Tutorials -> {
	},
	Guides -> {
		"Simulation",
		"NucleicAcids"
	},
	SeeAlso -> {
		"SimulateFreeEnergy",
		"SimulateReactivity"
	},
	Author -> {"scicomp", "brad", "amir.saadat", "david.hattery", "alice"},
	Preview->True
}];