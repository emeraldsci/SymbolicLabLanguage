(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*SimulateHybridization*)


hybMoreInfomration = Sequence[
	"This function by default conducts Pairing first with the input pair of oligomers, then conducts Folding to infinity depth to allow intra-molecular pairing. If Folding is turned off in option control, only inter-molecular pairing is considered.",
	"The function can also handle a list of oligomer lists as input: SimulateHybridization[{{oligomer..}..}].",
	"Thermodynamic DNA Nearest Neighbor parameters from Object[Report, Literature, \"id:kEJ9mqa1Jr7P\"]: Allawi, Hatim T., and John SantaLucia. \"MeltingCurve and NMR of internal GT mismatches in DNA.\" Biochemistry 36.34 (1997): 10581-10594.",
	"Thermodynamic RNA Nearest Neighbor parameters from Object[Report, Literature, \"id:M8n3rxYAnNkm\"]: Xia, Tianbing, et al. \"Thermodynamic parameters for an expanded nearest-neighbor model for formation of RNA duplexes with Watson-Crick base pairs.\" Biochemistry 37.42 (1998): 14719-14735."
];

DefineUsageWithCompanions[SimulateHybridization, {
	BasicDefinitions -> {
		{
			Definition->{"SimulateHybridization[oligomer]", "hybridization"},
			Description->"predicts potential secondary structure interactions of the provided list of 'oligomer'.",
			Inputs:>{
				{
					InputName->"oligomer",
					Widget->Adder[Adder[
						Alternatives[
							Widget[Type->Expression, Pattern:> SequenceP | StrandP | StructureP, PatternTooltip->"Sequence (e.g. \"ATCGTAGCGTA\"), strand with one or more motifs, or structure.", Size->Line],
							Widget[Type->Object, Pattern:> ObjectP[{Object[Sample], Model[Sample]}],PreparedSample->False]
						]
					]],
					Expandable->False,
					Description->"Initial list of sequences, or strands, or structures to hybridize from, or two lists to hybridize between."
				}
			},
			Outputs:> {
				{
					OutputName->"hybridization",
					Pattern:> ObjectP[Object[Simulation, Hybridization]],
					Description->"A list of hybridized structures describing the hybridization behavior of 'oligomer'."
				}
			}
		}
	},
	MoreInformation -> {
		hybMoreInfomration
	},
	Tutorials -> {
	},
	Guides -> {
		"Simulation",
		"NucleicAcids"
	},
	SeeAlso -> {
		"SimulateFolding",
		"SimulateReactivity"
	},
	Author -> {
		"brad",
		"david.hattery",
		"qian"
	},
	Preview->True
}];
