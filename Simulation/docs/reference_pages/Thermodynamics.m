(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*shared*)


thermoMoreInfomration = Sequence[
	"DNA Nearest Neighbor parameters from Object[Report, Literature, \"id:kEJ9mqa1Jr7P\"]: Allawi, Hatim T., and John SantaLucia. \"Thermodynamics and NMR of internal GT mismatches in DNA.\" Biochemistry 36.34 (1997): 10581-10594.",
	"RNA Nearest Neighbor parameters from Object[Report, Literature, \"id:M8n3rxYAnNkm\"]: Xia, Tianbing, et al. \"Thermodynamic parameters for an expanded nearest-neighbor model for formation of RNA duplexes with Watson-Crick base pairs.\" Biochemistry 37.42 (1998): 14719-14735.",
	"If given a nucleic acid sequence, strand, or sequence length, this function assumes a two-state binding between the provided sequence and a perfect reverse complement.",
	"Given a structure, considers only the bonded regions of the structure.",
	"Supported polymer types are DNA and RNA.",
	"Untyped sequences or lengths default to DNA if there is ambiguity.",
	"Enthalpy is independent of salt concentration, while entropy values for a given salt concentration. MonovalentSaltConcentration and DivalentSaltConcentration can be used to specify the concentration of monovalent salt (Na+, K+) and divalent salt (Mg2+) respectively. The entropy correction term is calculated as: 0.368*(Sequence Length - 1)*ln[(Na+) + 140*(Mg2+)] from Object[Report,Literature, \"id:eGakld09nLXo\"]: von Ahsen, et al. \"Application of a Thermodynamic Nearest-Neighbor Model to Estimate Nucleic Acid Stability and Optimize Probe Design:Prediction of Melting Points of Multiple Mutations of Apolipoprotein B-3500 and Factor V with a Hybridization Probe Genotyping Assay on the LightCycler\" Clinical Chemistry 45.12 (1999) 2094-2101."
];



(* ::Subsubsection:: *)
(*SimulateEnthalpy*)

DefineUsageWithCompanions[SimulateEnthalpy,
{
	BasicDefinitions -> {
		{
			Definition->{"SimulateEnthalpy[reaction]", "enthalpyObject"},
			Description->"computes the change in enthalpy of the given reaction between two nucleic acid oligomers with traditional Nearest Neighbor thermodynamic analysis.",
			Inputs :> {
				{
					InputName->"reaction",
					Widget->Alternatives[
						Widget[Type->Object, Pattern:> ObjectP[Model[Reaction]]],
						Widget[Type->Expression, Pattern:> ListableP[ReactionP | ObjectP[Model[Reaction]] | Reaction[{_Structure..}, {_Structure..}, _]], PatternTooltip->"A reaction like Reaction[{reactants..}, {products..}, kForwardRate].", Size->Line]
					],
					Expandable->False,
					Description->"A reversible reaction between two nucleic acid structures, from which a change in enthalpy will be computed."
				}
			},
			Outputs :> {
				{
					OutputName->"enthalpyObject",
					Pattern:> ObjectP[Object[Simulation, Enthalpy]],
					Description->"Enthalpy simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateEnthalpy[reactantAplusB]", "enthalpyObject"},
			Description->"finds the product of reaction from 'reactantA' + 'reactantB', then computes the change in enthalpy.",
			Inputs :> {
				{
					InputName->"reactantAplusB",
					Widget->Widget[
						Type->Expression,
					(* Match on exactly 2 reactants added together--when they are the same, Mathematica switches to a multiply pattern (x2) so it needs to be in the pattern *)
						Pattern:> ListableP[Verbatim[Plus][(ObjectP[{Model[Sample], Object[Sample]}] | SequenceP | StrandP | StructureP), (ObjectP[{Model[Sample], Object[Sample]}] | SequenceP | StrandP | StructureP)] | 2 (ObjectP[{Model[Sample], Object[Sample]}] | SequenceP | StrandP | StructureP)],
						PatternTooltip->"Two sequences, strands, or structures added like: DNA[\"GGACTGACGCGTTGA\"] + DNA[\"TCAACGCGTCAGTCC\"].",
						Size->Line
					],
					Expandable->False,
					Description->"Two oligomers added to make a reaction."
				}
			},
			Outputs :> {
				{
					OutputName->"enthalpyObject",
					Pattern:> ObjectP[Object[Simulation, Enthalpy]],
					Description->"Enthalpy simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateEnthalpy[reactantEquilibriumProduct]", "enthalpyObject"},
			Description->"infers the type of reaction from the given 'reactant' \[Equilibrium] 'product' state and computes the enthalpy for that reaction.",
			Inputs :> {
				{
					InputName->"reactantEquilibriumProduct",
					Widget->Widget[Type->Expression, Pattern:> ListableP[StructureP \[Equilibrium] StructureP], PatternTooltip->"A structure at equilibrium like: Equilibrium[Structure[{Strand[DNA[\"AACCCCATAACCCCAACAAGGGGAAGAAGGGG\"]]},{Bond[{1,1,11;;14},{1,1,20;;23}]}],  Structure[{Strand[DNA[\"AACCCCATAACCCCAACAAGGGGAAGAAGGGG\"]]},{Bond[{1,1,3;;6},{1,1,29;;32}],Bond[{1,1,11;;14},{1,1,20;;23}]}]].", Size->Line],
					Expandable->False,
					Description->"A nucleic acid structure participating as a product in a reaction."
				}
			},
			Outputs :> {
				{
					OutputName->"enthalpyObject",
					Pattern:> ObjectP[Object[Simulation, Enthalpy]],
					Description->"Enthalpy simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateEnthalpy[reactionMechanism]", "enthalpyObject"},
			Description->"computes the enthalpy from the reaction in the given mechanism.",
			Inputs :> {
				{
					InputName->"reactionMechanism",
					Widget->Alternatives[
						Widget[Type->Object, Pattern:> ObjectP[Model[ReactionMechanism]]],
						Widget[Type->Expression, Pattern:> ListableP[ReactionMechanismP | ObjectP[Model[ReactionMechanism]]], PatternTooltip->"A reaction mechanism like ReactionMechanism[{\"a\"+\"b\"->\"c\",kf}].", Size->Line]
					],
					Expandable->False,
					Description->"A simple mechanism contains only one first order or second order reaction."
				}
			},
			Outputs :> {
				{
					OutputName->"enthalpyObject",
					Pattern:> ObjectP[Object[Simulation, Enthalpy]],
					Description->"Enthalpy simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateEnthalpy[oligomer]", "enthalpyObject"},
			Description->"considers the hybridization reaction between the given 'oligomer' and its reverse complement.",
			Inputs :> {
				{
					InputName->"oligomer",
					Widget->Alternatives[
						Widget[Type->Object, Pattern:> ObjectP[{Model[Sample], Object[Sample], Model[Molecule, Oligomer]}],PreparedSample->False],
						Widget[Type->Number, Pattern:> GreaterEqualP[0, 1]],
						Widget[Type->Expression, Pattern:> ListableP[_Integer | SequenceP | StrandP | ObjectP[{Model[Sample], Object[Sample], Model[Molecule, Oligomer]}]], PatternTooltip->"A sequence or strand like \"AAGGTT\" or Strand[DNA[\"ATCG\"]].", Size->Line]
					],
					Expandable->False,
					Description->"An oligomer participating in a hybridization reaction with its reverse complement."
				}
			},
			Outputs :> {
				{
					OutputName->"enthalpyObject",
					Pattern:> ObjectP[Object[Simulation, Enthalpy]],
					Description->"Enthalpy simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateEnthalpy[structure]", "enthalpyObject"},
			Description->"considers the melting reaction whereby all of the bonds in the given 'structure' are melted.",
			Inputs :> {
				{
					InputName->"structure",
					Widget->Widget[Type->Expression, Pattern:> ListableP[StructureP], PatternTooltip->"A list of or single structure like Structure[{Strand[DNA[\"AAAAA\"]],Strand[DNA[\"TTTTT\"]]},{Bond[{1,1},{2,1}]}].", Size->Line],
					Expandable->False,
					Description->"A nucleic acid structure that will be completely melted."
				}
			},
			Outputs :> {
				{
					OutputName->"enthalpyObject",
					Pattern:> ObjectP[Object[Simulation, Enthalpy]],
					Description->"Enthalpy simulation object or packet."
				}
			}
		}
	},
	MoreInformation -> {
		thermoMoreInfomration
	},
	Tutorials -> {
		"NearestNeighbor"
	},
	Guides -> {
		"Simulation",
		"NucleicAcids"
	},
	SeeAlso -> {
		"SimulateEntropy",
		"SimulateFreeEnergy",
		"SimulateMeltingTemperature"
	},
	Author -> {
		"brad",
		"amir.saadat",
		"david.hattery",
		"qian",
		"alice"
	},
	Preview->True
}];



(* ::Subsubsection:: *)
(*SimulateEntropy*)

DefineUsageWithCompanions[SimulateEntropy,
{
	BasicDefinitions -> {
		{
			Definition->{"SimulateEntropy[reaction]", "entropyObject"},
			Description->"computes the change in entropy of the given reaction between two nucleic acid oligomers with traditional Nearest Neighbor thermodynamic analysis.",
			Inputs :> {
				{
					InputName->"reaction",
					Widget->Alternatives[
						Widget[Type->Object, Pattern:> ObjectP[Model[Reaction]]],
						Widget[Type->Expression, Pattern:> ListableP[ReactionP | ObjectP[Model[Reaction]] | Reaction[{_Structure..}, {_Structure..}, _]], PatternTooltip->"A reaction like Reaction[{reactants..}, {products..}, kForwardRate].", Size->Line]
					],
					Expandable->False,
					Description->"A reversible reaction between two nucleic acid structures, from which a change in entropy will be computed."
				}
			},
			Outputs :> {
				{
					OutputName->"entropyObject",
					Pattern:> ObjectP[Object[Simulation, Entropy]],
					Description->"Entropy simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateEntropy[reactantAplusB]", "entropyObject"},
			Description->"finds the product of reaction from 'reactantA' + 'reactantB', then computes the change in entropy.",
			Inputs :> {
				{
					InputName->"reactantAplusB",
					Widget->Widget[
						Type->Expression,
					(* Match on exactly 2 reactants added together--when they are the same, Mathematica switches to a multiply pattern (x2) so it needs to be in the pattern *)
						Pattern:> ListableP[Verbatim[Plus][(ObjectP[{Model[Sample], Object[Sample]}] | SequenceP | StrandP | StructureP), (ObjectP[{Model[Sample], Object[Sample]}] | SequenceP | StrandP | StructureP)] | 2 (ObjectP[{Model[Sample], Object[Sample]}] | SequenceP | StrandP | StructureP)],
						PatternTooltip->"Two sequences, strands, or structures added like: DNA[\"GGACTGACGCGTTGA\"] + DNA[\"TCAACGCGTCAGTCC\"].",
						Size->Line
					],
					Expandable->False,
					Description->"Two oligomers added to make a reaction."
				}
			},
			Outputs :> {
				{
					OutputName->"entropyObject",
					Pattern:> ObjectP[Object[Simulation, Entropy]],
					Description->"Entropy simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateEntropy[reactantEquilibriumProduct]", "entropyObject"},
			Description->"infers the type of reaction from the given 'reactant' \[Equilibrium] 'product' state and computes the entropy for that reaction.",
			Inputs :> {
				{
					InputName->"reactantEquilibriumProduct",
					Widget->Widget[Type->Expression, Pattern:> ListableP[StructureP \[Equilibrium] StructureP], PatternTooltip->"A structure at equilibrium like: Equilibrium[Structure[{Strand[DNA[\"AACCCCATAACCCCAACAAGGGGAAGAAGGGG\"]]},{Bond[{1,1,11;;14},{1,1,20;;23}]}],  Structure[{Strand[DNA[\"AACCCCATAACCCCAACAAGGGGAAGAAGGGG\"]]},{Bond[{1,1,3;;6},{1,1,29;;32}],Bond[{1,1,11;;14},{1,1,20;;23}]}]].", Size->Line],
					Expandable->False,
					Description->"A nucleic acid structure participating as a product in a reaction."
				}
			},
			Outputs :> {
				{
					OutputName->"entropyObject",
					Pattern:> ObjectP[Object[Simulation, Entropy]],
					Description->"Entropy simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateEntropy[reactionMechanism]", "entropyObject"},
			Description->"computes the entropy from the reaction in the given mechanism.",
			Inputs :> {
				{
					InputName->"reactionMechanism",
					Widget->Alternatives[
						Widget[Type->Object, Pattern:> ObjectP[Model[ReactionMechanism]]],
						Widget[Type->Expression, Pattern:> ListableP[ReactionMechanismP | ObjectP[Model[ReactionMechanism]]], PatternTooltip->"A reaction mechanism like ReactionMechanism[{\"a\"+\"b\"->\"c\",kf}].", Size->Line]
					],
					Expandable->False,
					Description->"A simple mechanism contains only one first order or second order reaction."
				}
			},
			Outputs :> {
				{
					OutputName->"entropyObject",
					Pattern:> ObjectP[Object[Simulation, Entropy]],
					Description->"Entropy simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateEntropy[oligomer]", "entropyObject"},
			Description->"considers the hybridization reaction between the given 'oligomer' and its reverse complement.",
			Inputs :> {
				{
					InputName->"oligomer",
					Widget->Alternatives[
						Widget[Type->Object, Pattern:> ObjectP[{Model[Sample], Object[Sample], Model[Molecule, Oligomer]}],PreparedSample->False],
						Widget[Type->Number, Pattern:> GreaterEqualP[0, 1]],
						Widget[Type->Expression, Pattern:> ListableP[_Integer | SequenceP | StrandP | ObjectP[{Model[Sample], Object[Sample], Model[Molecule, Oligomer]}]], PatternTooltip->"A sequence or strand like \"AAGGTT\" or Strand[DNA[\"ATCG\"]].", Size->Line]
					],
					Expandable->False,
					Description->"An oligomer participating in a hybridization reaction with its reverse complement."
				}
			},
			Outputs :> {
				{
					OutputName->"entropyObject",
					Pattern:> ObjectP[Object[Simulation, Entropy]],
					Description->"Entropy simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateEntropy[structure]", "entropyObject"},
			Description->"considers the melting reaction whereby all of the bonds in the given 'structure' are melted.",
			Inputs :> {
				{
					InputName->"structure",
					Widget->Widget[Type->Expression, Pattern:> ListableP[StructureP], PatternTooltip->"A list of or single structure like Structure[{Strand[DNA[\"AAAAA\"]],Strand[DNA[\"TTTTT\"]]},{Bond[{1,1},{2,1}]}].", Size->Line],
					Expandable->False,
					Description->"A nucleic acid structure that will be completely melted."
				}
			},
			Outputs :> {
				{
					OutputName->"entropyObject",
					Pattern:> ObjectP[Object[Simulation, Entropy]],
					Description->"Entropy simulation object or packet."
				}
			}
		}
	},
	MoreInformation -> {
		thermoMoreInfomration
	},
	Tutorials -> {
		"NearestNeighbor"
	},
	Guides -> {
		"Simulation",
		"NucleicAcids"
	},
	SeeAlso -> {
		"SimulateEnthalpy",
		"SimulateFreeEnergy",
		"SimulateMeltingTemperature"
	},
	Author -> {
		"brad",
		"amir.saadat",
		"david.hattery",
		"qian",
		"alice"
	},
	Preview->True
}];



(* ::Subsubsection:: *)
(*SimulateEquilibriumConstant*)

DefineUsageWithCompanions[SimulateEquilibriumConstant,
{
	BasicDefinitions -> {
		{
			Definition->{"SimulateEquilibriumConstant[reaction, temperature]", "equilibriumConstantObject"},
			Description->"computes the equilibrium constant of the given reaction between two nucleic acid oligomers at the specified concentration with traditional Nearest Neighbor thermodynamic analysis.",
			Inputs :> {
				{
					InputName->"reaction",
					Widget->Alternatives[
						Widget[Type->Object, Pattern:> ObjectP[Model[Reaction]]],
						Widget[Type->Expression, Pattern:> ListableP[ReactionP | ObjectP[Model[Reaction]] | Reaction[{_Structure..}, {_Structure..}, _]], PatternTooltip->"A reaction like Reaction[{reactants..}, {products..}, kForwardRate].", Size->Line]
					],
					Expandable->False,
					Description->"A reversible reaction between two nucleic acid structures, from which equilibrium constant will be computed."
				},
				{
					InputName->"temperature",
					Widget->Alternatives[
						Adder[Alternatives[
							Widget[Type->Enumeration, Pattern:> Alternatives[defaultTemperatureValue]],
							Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Kelvin], Units-> Celsius | Kelvin | Fahrenheit]
						]],
						Widget[Type->Expression, Pattern:> ListableP[TemperatureP | DistributionP["Celsius"]], PatternTooltip->"A list of, or single temperature or Celsius temperature distribution like: QuantityDistribution[NormalDistribution[30, 2], Celsius].", Size->Line]
					],
					Expandable->False,
					Description->"Temperature at which equilibrium constant is computed."
				}
			},
			Outputs :> {
				{
					OutputName->"equilibriumConstantObject",
					Pattern:> ObjectP[Object[Simulation, EquilibriumConstant]],
					Description->"EquilibriumConstant simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateEquilibriumConstant[reactantAplusB, temperature]", "equilibriumConstantObject"},
			Description->"finds the product of reaction from 'reactantA' + 'reactantB', then computes the equilibrium constant.",
			Inputs :> {
				{
					InputName->"reactantAplusB",
					Widget->Widget[
						Type->Expression,
					(* Match on exactly 2 reactants added together--when they are the same, Mathematica switches to a multiply pattern (x2) so it needs to be in the pattern *)
						Pattern:> ListableP[Verbatim[Plus][(ObjectP[{Model[Sample], Object[Sample]}] | SequenceP | StrandP | StructureP), (ObjectP[{Model[Sample], Object[Sample]}] | SequenceP | StrandP | StructureP)] | 2 (ObjectP[{Model[Sample], Object[Sample]}] | SequenceP | StrandP | StructureP)],
						PatternTooltip->"Two sequences, strands, or structures added like: DNA[\"GGACTGACGCGTTGA\"] + DNA[\"TCAACGCGTCAGTCC\"].",
						Size->Line
					],
					Expandable->False,
					Description->"Two oligomers added to make a reaction."
				},
				{
					InputName->"temperature",
					Widget->Alternatives[
						Adder[Alternatives[
							Widget[Type->Enumeration, Pattern:> Alternatives[defaultTemperatureValue]],
							Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Kelvin], Units-> Celsius | Kelvin | Fahrenheit]
						]],
						Widget[Type->Expression, Pattern:> ListableP[TemperatureP | DistributionP["Celsius"]], PatternTooltip->"A list of, or single temperature or Celsius temperature distribution like: QuantityDistribution[NormalDistribution[30, 2], Celsius].", Size->Line]
					],
					Expandable->False,
					Description->"Temperature at which equilibrium constant is computed."
				}
			},
			Outputs :> {
				{
					OutputName->"equilibriumConstantObject",
					Pattern:> ObjectP[Object[Simulation, EquilibriumConstant]],
					Description->"EquilibriumConstant simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateEquilibriumConstant[reactantEquilibriumProduct, temperature]", "equilibriumConstantObject"},
			Description->"infers the type of reaction from the given 'reactant' \[Equilibrium] 'product' state and computes the equilibrium constant for that reaction.",
			Inputs :> {
				{
					InputName->"reactantEquilibriumProduct",
					Widget->Widget[Type->Expression, Pattern:> ListableP[StructureP \[Equilibrium] StructureP], PatternTooltip->"A structure at equilibrium like: Equilibrium[Structure[{Strand[DNA[\"AACCCCATAACCCCAACAAGGGGAAGAAGGGG\"]]},{Bond[{1,1,11;;14},{1,1,20;;23}]}],  Structure[{Strand[DNA[\"AACCCCATAACCCCAACAAGGGGAAGAAGGGG\"]]},{Bond[{1,1,3;;6},{1,1,29;;32}],Bond[{1,1,11;;14},{1,1,20;;23}]}]].", Size->Line],
					Expandable->False,
					Description->"A nucleic acid structure reactant in equilibrium with a product in a reaction."
				},
				{
					InputName->"temperature",
					Widget->Alternatives[
						Adder[Alternatives[
							Widget[Type->Enumeration, Pattern:> Alternatives[defaultTemperatureValue]],
							Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Kelvin], Units-> Celsius | Kelvin | Fahrenheit]
						]],
						Widget[Type->Expression, Pattern:> ListableP[TemperatureP | DistributionP["Celsius"]], PatternTooltip->"A list of, or single temperature or Celsius temperature distribution like: QuantityDistribution[NormalDistribution[30, 2], Celsius].", Size->Line]
					],
					Expandable->False,
					Description->"Temperature at which equilibrium constant is computed."
				}
			},
			Outputs :> {
				{
					OutputName->"equilibriumConstantObject",
					Pattern:> ObjectP[Object[Simulation, EquilibriumConstant]],
					Description->"EquilibriumConstant simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateEquilibriumConstant[reactionMechanism, temperature]", "equilibriumConstantObject"},
			Description->"computes the equilibrium constant from the reaction in the given mechanism.",
			Inputs :> {
				{
					InputName->"reactionMechanism",
					Widget->Alternatives[
						Widget[Type->Object, Pattern:> ObjectP[Model[ReactionMechanism]]],
						Widget[Type->Expression, Pattern:> ListableP[ReactionMechanismP | ObjectP[Model[ReactionMechanism]]], PatternTooltip->"A reaction mechanism like ReactionMechanism[{\"a\"+\"b\"->\"c\",kf}].", Size->Line]
					],
					Expandable->False,
					Description->"A simple mechanism contains only one first order or second order reaction."
				},
				{
					InputName->"temperature",
					Widget->Alternatives[
						Adder[Alternatives[
							Widget[Type->Enumeration, Pattern:> Alternatives[defaultTemperatureValue]],
							Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Kelvin], Units-> Celsius | Kelvin | Fahrenheit]
						]],
						Widget[Type->Expression, Pattern:> ListableP[TemperatureP | DistributionP["Celsius"]], PatternTooltip->"A list of, or single temperature or Celsius temperature distribution like: QuantityDistribution[NormalDistribution[30, 2], Celsius].", Size->Line]
					],
					Expandable->False,
					Description->"Temperature at which equilibrium constant is computed."
				}
			},
			Outputs :> {
				{
					OutputName->"equilibriumConstantObject",
					Pattern:> ObjectP[Object[Simulation, EquilibriumConstant]],
					Description->"EquilibriumConstant simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateEquilibriumConstant[oligomer, temperature]", "equilibriumConstantObject"},
			Description->"considers the hybridization reaction between the given 'oligomer' and its reverse complement.",
			Inputs :> {
				{
					InputName->"oligomer",
					Widget->Alternatives[
						Widget[Type->Object, Pattern:> ObjectP[{Model[Sample], Object[Sample], Model[Molecule, Oligomer]}],PreparedSample->False],
						Widget[Type->Number, Pattern:> GreaterEqualP[0, 1]],
						Widget[Type->Expression, Pattern:> ListableP[_Integer | SequenceP | StrandP | ObjectP[{Model[Sample], Object[Sample], Model[Molecule, Oligomer]}]], PatternTooltip->"A sequence or strand like \"AAGGTT\" or Strand[DNA[\"ATCG\"]].", Size->Line]
					],
					Expandable->False,
					Description->"An oligomer participating in a hybridization reaction with its reverse complement."
				},
				{
					InputName->"temperature",
					Widget->Alternatives[
						Adder[Alternatives[
							Widget[Type->Enumeration, Pattern:> Alternatives[defaultTemperatureValue]],
							Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Kelvin], Units-> Celsius | Kelvin | Fahrenheit]
						]],
						Widget[Type->Expression, Pattern:> ListableP[TemperatureP | DistributionP["Celsius"]], PatternTooltip->"A list of, or single temperature or Celsius temperature distribution like: QuantityDistribution[NormalDistribution[30, 2], Celsius].", Size->Line]
					],
					Expandable->False,
					Description->"Temperature at which equilibrium constant is computed."
				}
			},
			Outputs :> {
				{
					OutputName->"equilibriumConstantObject",
					Pattern:> ObjectP[Object[Simulation, EquilibriumConstant]],
					Description->"EquilibriumConstant simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateEquilibriumConstant[structure, temperature]", "equilibriumConstantObject"},
			Description->"considers the melting reaction whereby all of the bonds in the given 'structure' are melted.",
			Inputs :> {
				{
					InputName->"structure",
					Widget->Widget[Type->Expression, Pattern:> ListableP[StructureP], PatternTooltip->"A list of or single structure like Structure[{Strand[DNA[\"AAAAA\"]],Strand[DNA[\"TTTTT\"]]},{Bond[{1,1},{2,1}]}].", Size->Line],
					Expandable->False,
					Description->"A nucleic acid structure that will be completely melted."
				},
				{
					InputName->"temperature",
					Widget->Alternatives[
						Adder[Alternatives[
							Widget[Type->Enumeration, Pattern:> Alternatives[defaultTemperatureValue]],
							Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Kelvin], Units-> Celsius | Kelvin | Fahrenheit]
						]],
						Widget[Type->Expression, Pattern:> ListableP[TemperatureP | DistributionP["Celsius"]], PatternTooltip->"A list of, or single temperature or Celsius temperature distribution like: QuantityDistribution[NormalDistribution[30, 2], Celsius].", Size->Line]
					],
					Expandable->False,
					Description->"Temperature at which equilibrium constant is computed."
				}
			},
			Outputs :> {
				{
					OutputName->"equilibriumConstantObject",
					Pattern:> ObjectP[Object[Simulation, EquilibriumConstant]],
					Description->"EquilibriumConstant simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateEquilibriumConstant[enthalpy, entropy, temperature]", "equilibriumConstantObject"},
			Description->"computes the equilibrium constant from the given enthalpy and entropy of a reaction.",
			Inputs :> {
				{
					InputName->"enthalpy",
					Widget->Alternatives[
						Widget[Type->Quantity, Pattern:> RangeP[-Infinity KilocaloriePerMole, Infinity KilocaloriePerMole], Units-> KilocaloriePerMole | Calorie / Micromole | Joule / Mole | Joule / Micromole ],
						Widget[Type->Expression, Pattern:> ListableP[EnergyP | DistributionP[Joule / Mole]], PatternTooltip->"Enter enthalpy or enthalpy distribution like: -55*KilocaloriePerMole or QuantityDistribution[EmpiricalDistribution[{-55}],KilocaloriePerMole].", Size->Line]
					],
					Expandable->False,
					Description->"Enthalpy of the reaction."
				},
				{
					InputName->"entropy",
					Widget->Alternatives[
						Widget[Type->Quantity, Pattern:> RangeP[-Infinity CaloriePerMoleKelvin, Infinity CaloriePerMoleKelvin], Units-> CaloriePerMoleKelvin | Calorie / (Micromole Kelvin) | Joule / (Mole Kelvin) | Joule / (Micromole Kelvin) ],
						Widget[Type->Expression, Pattern:> ListableP[EntropyP | DistributionP[Joule / (Mole Kelvin)]], PatternTooltip->"Enter entropy or entropy distribution like: -150*CaloriePerMoleKelvin or QuantityDistribution[NormalDistribution[-150,5],CaloriePerMoleKelvin].", Size->Line]
					],
					Expandable->False,
					Description->"Entropy of the reaction."
				},
				{
					InputName->"temperature",
					Widget->Alternatives[
						Adder[Alternatives[
							Widget[Type->Enumeration, Pattern:> Alternatives[defaultTemperatureValue]],
							Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Kelvin], Units-> Celsius | Kelvin | Fahrenheit]
						]],
						Widget[Type->Expression, Pattern:> ListableP[TemperatureP | DistributionP["Celsius"]], PatternTooltip->"A list of, or single temperature or Celsius temperature distribution like: QuantityDistribution[NormalDistribution[30, 2], Celsius].", Size->Line]
					],
					Expandable->False,
					Description->"Temperature at which equilibrium constant is computed."
				}
			},
			Outputs :> {
				{
					OutputName->"equilibriumConstantObject",
					Pattern:> ObjectP[Object[Simulation, EquilibriumConstant]],
					Description->"EquilibriumConstant simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateEquilibriumConstant[freeEnergy, temperature]", "equilibriumConstantObject"},
			Description->"computes the equilibrium constant from the given Gibbs free energy of a reaction.",
			Inputs :> {
				{
					InputName->"freeEnergy",
					Widget->Alternatives[
						Widget[Type->Quantity, Pattern:> RangeP[-Infinity KilocaloriePerMole, Infinity KilocaloriePerMole], Units-> KilocaloriePerMole | Calorie / Micromole | Joule / Mole | Joule / Micromole ],
						Widget[Type->Expression, Pattern:> ListableP[EnergyP | DistributionP[Joule / Mole]], PatternTooltip->"An freeEnergy or freeEnergy distribution like: QuantityDistribution[NormalDistribution[30, 2], KilocaloriePerMole].", Size->Line]
					],
					Expandable->False,
					Description->"Free energy of the reaction."
				},
				{
					InputName->"temperature",
					Widget->Alternatives[
						Adder[Alternatives[
							Widget[Type->Enumeration, Pattern:> Alternatives[defaultTemperatureValue]],
							Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Kelvin], Units-> Celsius | Kelvin | Fahrenheit]
						]],
						Widget[Type->Expression, Pattern:> ListableP[TemperatureP | DistributionP["Celsius"]], PatternTooltip->"A list of, or single temperature or Celsius temperature distribution like: QuantityDistribution[NormalDistribution[30, 2], Celsius].", Size->Line]
					],
					Expandable->False,
					Description->"Temperature at which equilibrium constant is computed."
				}
			},
			Outputs :> {
				{
					OutputName->"equilibriumConstantObject",
					Pattern:> ObjectP[Object[Simulation, EquilibriumConstant]],
					Description->"EquilibriumConstant simulation object or packet."
				}
			}
		}
	},
	MoreInformation -> {
		"Equilibrium constant is calculated from EquilibriumConstant = E^(-\[CapitalDelta]G/(R*T)).",
		thermoMoreInfomration,
		"If thermodynamic paramaters are provided, a second order reaction (A + B \[Equilibrium] AB) is assumed.",
		"Temperature defaults to 37.0 \[Degree]C."
	},
	Tutorials -> {
		"Simulation",
		"NucleicAcids",
		"NearestNeighbor"
	},
	SeeAlso -> {
		"SimulateEntropy",
		"SimulateEnthalpy",
		"SimulateFreeEnergy"
	},
	Author -> {
		"brad",
		"amir.saadat",
		"david.hattery",
		"alice"
	},
	Preview->True
}];



(* ::Subsubsection:: *)
(*SimulateFreeEnergy*)

DefineUsageWithCompanions[SimulateFreeEnergy,
{
	BasicDefinitions -> {
		{
			Definition->{"SimulateFreeEnergy[reaction, temperature]", "freeEnergyObject"},
			Description->"computes the free energy of the given reaction between two nucleic acid oligomers at the specified concentration with traditional Nearest Neighbor thermodynamic analysis.",
			Inputs :> {
				{
					InputName->"reaction",
					Widget->Alternatives[
						Widget[Type->Object, Pattern:> ObjectP[Model[Reaction]]],
						Widget[Type->Expression, Pattern:> ListableP[ReactionP | ObjectP[Model[Reaction]] | Reaction[{_Structure..}, {_Structure..}, _]], PatternTooltip->"A reaction like Reaction[{reactants..}, {products..}, kForwardRate].", Size->Line]
					],
					Expandable->False,
					Description->"A reversible reaction between two nucleic acid structures, from which a change in Free energy will be computed."
				},
				{
					InputName->"temperature",
					Widget->Alternatives[
						Adder[Alternatives[
							Widget[Type->Enumeration, Pattern:> Alternatives[defaultTemperatureValue]],
							Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Kelvin], Units-> Celsius | Kelvin | Fahrenheit]
						]],
						Widget[Type->Expression, Pattern:> ListableP[TemperatureP | DistributionP["Celsius"]], PatternTooltip->"A list of, or single temperature or Celsius temperature distribution like: QuantityDistribution[NormalDistribution[30, 2], Celsius].", Size->Line]
					],
					Expandable->False,
					Description->"Temperature at which free energy is computed."
				}
			},
			Outputs :> {
				{
					OutputName->"freeEnergyObject",
					Pattern:> ObjectP[Object[Simulation, FreeEnergy]],
					Description->"FreeEnergy simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateFreeEnergy[reactantAplusB, temperature]", "freeEnergyObject"},
			Description->"finds the product of reaction from 'reactantA' + 'reactantB', then computes the free energy.",
			Inputs :> {
				{
					InputName->"reactantAplusB",
					Widget->Widget[
						Type->Expression,
					(* Match on exactly 2 reactants added together--when they are the same, Mathematica switches to a multiply pattern (x2) so it needs to be in the pattern *)
						Pattern:> ListableP[Verbatim[Plus][(ObjectP[{Model[Sample], Object[Sample]}] | SequenceP | StrandP | StructureP), (ObjectP[{Model[Sample], Object[Sample]}] | SequenceP | StrandP | StructureP)] | 2 (ObjectP[{Model[Sample], Object[Sample]}] | SequenceP | StrandP | StructureP)],
						PatternTooltip->"Two sequences, strands, or structures added like: DNA[\"GGACTGACGCGTTGA\"] + DNA[\"TCAACGCGTCAGTCC\"].",
						Size->Line
					],
					Expandable->False,
					Description->"Two oligomers added to make a reaction."
				},
				{
					InputName->"temperature",
					Widget->Alternatives[
						Adder[Alternatives[
							Widget[Type->Enumeration, Pattern:> Alternatives[defaultTemperatureValue]],
							Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Kelvin], Units-> Celsius | Kelvin | Fahrenheit]
						]],
						Widget[Type->Expression, Pattern:> ListableP[TemperatureP | DistributionP["Celsius"]], PatternTooltip->"A list of, or single temperature or Celsius temperature distribution like: QuantityDistribution[NormalDistribution[30, 2], Celsius].", Size->Line]
					],
					Expandable->False,
					Description->"Temperature at which free energy is computed."
				}
			},
			Outputs :> {
				{
					OutputName->"freeEnergyObject",
					Pattern:> ObjectP[Object[Simulation, FreeEnergy]],
					Description->"FreeEnergy simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateFreeEnergy[reactantEquilibriumProduct, temperature]", "freeEnergyObject"},
			Description->"infers the type of reaction from the given 'reactant' \[Equilibrium] 'product' state and computes the free energy for that reaction.",
			Inputs :> {
				{
					InputName->"reactantEquilibriumProduct",
					Widget->Widget[Type->Expression, Pattern:> ListableP[StructureP \[Equilibrium] StructureP], PatternTooltip->"A structure at equilibrium like: Equilibrium[Structure[{Strand[DNA[\"AACCCCATAACCCCAACAAGGGGAAGAAGGGG\"]]},{Bond[{1,1,11;;14},{1,1,20;;23}]}],  Structure[{Strand[DNA[\"AACCCCATAACCCCAACAAGGGGAAGAAGGGG\"]]},{Bond[{1,1,3;;6},{1,1,29;;32}],Bond[{1,1,11;;14},{1,1,20;;23}]}]].", Size->Line],
					Expandable->False,
					Description->"A nucleic acid structure participating as a product in a reaction."
				},
				{
					InputName->"temperature",
					Widget->Alternatives[
						Adder[Alternatives[
							Widget[Type->Enumeration, Pattern:> Alternatives[defaultTemperatureValue]],
							Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Kelvin], Units-> Celsius | Kelvin | Fahrenheit]
						]],
						Widget[Type->Expression, Pattern:> ListableP[TemperatureP | DistributionP["Celsius"]], PatternTooltip->"A list of, or single temperature or Celsius temperature distribution like: QuantityDistribution[NormalDistribution[30, 2], Celsius].", Size->Line]
					],
					Expandable->False,
					Description->"Temperature at which free energy is computed."
				}
			},
			Outputs :> {
				{
					OutputName->"freeEnergyObject",
					Pattern:> ObjectP[Object[Simulation, FreeEnergy]],
					Description->"FreeEnergy simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateFreeEnergy[reactionMechanism, temperature]", "freeEnergyObject"},
			Description->"computes the free energy from the reaction in the given mechanism.",
			Inputs :> {
				{
					InputName->"reactionMechanism",
					Widget->Alternatives[
						Widget[Type->Object, Pattern:> ObjectP[Model[ReactionMechanism]]],
						Widget[Type->Expression, Pattern:> ListableP[ReactionMechanismP | ObjectP[Model[ReactionMechanism]]], PatternTooltip->"A reaction mechanism like ReactionMechanism[{\"a\"+\"b\"->\"c\",kf}].", Size->Line]
					],
					Expandable->False,
					Description->"A simple mechanism contains only one first order or second order reaction."
				},
				{
					InputName->"temperature",
					Widget->Alternatives[
						Adder[Alternatives[
							Widget[Type->Enumeration, Pattern:> Alternatives[defaultTemperatureValue]],
							Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Kelvin], Units-> Celsius | Kelvin | Fahrenheit]
						]],
						Widget[Type->Expression, Pattern:> ListableP[TemperatureP | DistributionP["Celsius"]], PatternTooltip->"A list of, or single temperature or Celsius temperature distribution like: QuantityDistribution[NormalDistribution[30, 2], Celsius].", Size->Line]
					],
					Expandable->False,
					Description->"Temperature at which free energy is computed."
				}
			},
			Outputs :> {
				{
					OutputName->"freeEnergyObject",
					Pattern:> ObjectP[Object[Simulation, FreeEnergy]],
					Description->"FreeEnergy simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateFreeEnergy[oligomer, temperature]", "freeEnergyObject"},
			Description->"considers the hybridization reaction between the given 'oligomer' and its reverse complement.",
			Inputs :> {
				{
					InputName->"oligomer",
					Widget->Alternatives[
						Widget[Type->Object, Pattern:> ObjectP[{Model[Sample], Object[Sample], Model[Molecule, Oligomer]}],PreparedSample->False],
						Widget[Type->Number, Pattern:> GreaterEqualP[0, 1]],
						Widget[Type->Expression, Pattern:> ListableP[_Integer | SequenceP | StrandP | ObjectP[{Model[Sample], Object[Sample], Model[Molecule, Oligomer]}]], PatternTooltip->"A sequence or strand like \"AAGGTT\" or Strand[DNA[\"ATCG\"]].", Size->Line]
					],
					Expandable->False,
					Description->"An oligomer participating in a hybridization reaction with its reverse complement."
				},
				{
					InputName->"temperature",
					Widget->Alternatives[
						Adder[Alternatives[
							Widget[Type->Enumeration, Pattern:> Alternatives[defaultTemperatureValue]],
							Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Kelvin], Units-> Celsius | Kelvin | Fahrenheit]
						]],
						Widget[Type->Expression, Pattern:> ListableP[TemperatureP | DistributionP["Celsius"]], PatternTooltip->"A list of, or single temperature or Celsius temperature distribution like: QuantityDistribution[NormalDistribution[30, 2], Celsius].", Size->Line]
					],
					Expandable->False,
					Description->"Temperature at which free energy is computed."
				}
			},
			Outputs :> {
				{
					OutputName->"freeEnergyObject",
					Pattern:> ObjectP[Object[Simulation, FreeEnergy]],
					Description->"FreeEnergy simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateFreeEnergy[structure, temperature]", "freeEnergyObject"},
			Description->"considers the melting reaction whereby all of the bonds in the given 'structure' are melted.",
			Inputs :> {
				{
					InputName->"structure",
					Widget->Widget[Type->Expression, Pattern:> ListableP[StructureP], PatternTooltip->"A list of or single structure like Structure[{Strand[DNA[\"AAAAA\"]],Strand[DNA[\"TTTTT\"]]},{Bond[{1,1},{2,1}]}].", Size->Line],
					Expandable->False,
					Description->"A nucleic acid structure that will be completely melted."
				},
				{
					InputName->"temperature",
					Widget->Alternatives[
						Adder[Alternatives[
							Widget[Type->Enumeration, Pattern:> Alternatives[defaultTemperatureValue]],
							Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Kelvin], Units-> Celsius | Kelvin | Fahrenheit]
						]],
						Widget[Type->Expression, Pattern:> ListableP[TemperatureP | DistributionP["Celsius"]], PatternTooltip->"A list of, or single temperature or Celsius temperature distribution like: QuantityDistribution[NormalDistribution[30, 2], Celsius].", Size->Line]
					],
					Expandable->False,
					Description->"Temperature at which free energy is computed."
				}
			},
			Outputs :> {
				{
					OutputName->"freeEnergyObject",
					Pattern:> ObjectP[Object[Simulation, FreeEnergy]],
					Description->"FreeEnergy simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateFreeEnergy[enthalpy, entropy, temperature]", "freeEnergyObject"},
			Description->"computes the free energy from the given enthalpy and entropy of a reaction.",
			Inputs :> {
				{
					InputName->"enthalpy",
					Widget->Alternatives[
						Widget[Type->Quantity, Pattern:> RangeP[-Infinity KilocaloriePerMole, Infinity KilocaloriePerMole], Units-> KilocaloriePerMole | Calorie / Micromole | Joule / Mole | Joule / Micromole ],
						Widget[Type->Expression, Pattern:> ListableP[EnergyP | DistributionP[Joule / Mole]], PatternTooltip->"Enter enthalpy or enthalpy distribution like: -55*KilocaloriePerMole or QuantityDistribution[EmpiricalDistribution[{-55}],KilocaloriePerMole].", Size->Line]
					],
					Expandable->False,
					Description->"Enthalpy of the reaction."
				},
				{
					InputName->"entropy",
					Widget->Alternatives[
						Widget[Type->Quantity, Pattern:> RangeP[-Infinity CaloriePerMoleKelvin, Infinity CaloriePerMoleKelvin], Units-> CaloriePerMoleKelvin | Calorie / (Micromole Kelvin) | Joule / (Mole Kelvin) | Joule / (Micromole Kelvin) ],
						Widget[Type->Expression, Pattern:> ListableP[EntropyP | DistributionP[Joule / (Mole Kelvin)]], PatternTooltip->"Enter entropy or entropy distribution like: -150*CaloriePerMoleKelvin or QuantityDistribution[NormalDistribution[-150,5],CaloriePerMoleKelvin].", Size->Line]
					],
					Expandable->False,
					Description->"Entropy of the reaction."
				},
				{
					InputName->"temperature",
					Widget->Alternatives[
						Adder[Alternatives[
							Widget[Type->Enumeration, Pattern:> Alternatives[defaultTemperatureValue]],
							Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Kelvin], Units-> Celsius | Kelvin | Fahrenheit]
						]],
						Widget[Type->Expression, Pattern:> ListableP[TemperatureP | DistributionP["Celsius"]], PatternTooltip->"A list of, or single temperature or Celsius temperature distribution like: QuantityDistribution[NormalDistribution[30, 2], Celsius].", Size->Line]
					],
					Expandable->False,
					Description->"Temperature at which free energy is computed."
				}
			},
			Outputs :> {
				{
					OutputName->"freeEnergyObject",
					Pattern:> ObjectP[Object[Simulation, FreeEnergy]],
					Description->"FreeEnergy simulation object or packet."
				}
			}
		}
	},
	MoreInformation -> {
		"Free energy is calculated from \[CapitalDelta]G = \[CapitalDelta]H - T \[CapitalDelta]S.",
		thermoMoreInfomration,
		"Temperature defaults to 37.0 \[Degree]C."
	},
	Tutorials -> {
		"NearestNeighbor"
	},
	Guides -> {
		"Simulation",
		"NucleicAcids"
	},
	SeeAlso -> {
		"SimulateEntropy",
		"SimulateEnthalpy",
		"SimulateMeltingTemperature"
	},
	Author -> {
		"brad",
		"amir.saadat",
		"david.hattery",
		"qian",
		"alice"
	},
	Preview->True
}];



(* ::Subsubsection:: *)
(*SimulateMeltingTemperature*)

DefineUsageWithCompanions[SimulateMeltingTemperature,
{
	BasicDefinitions -> {
		{
			Definition->{"SimulateMeltingTemperature[reaction, concentration]", "meltingTemperatureObject"},
			Description->"computes the melting temperature of the given reaction between two nucleic acid oligomers at the specified concentration with traditional Nearest Neighbor thermodynamic analysis.",
			Inputs :> {
				{
					InputName->"reaction",
					Widget->Alternatives[
						Widget[Type->Object, Pattern:> ObjectP[Model[Reaction]]],
						Widget[Type->Expression, Pattern:> ListableP[ReactionP | ObjectP[Model[Reaction]] | Reaction[{_Structure..}, {_Structure..}, _]], PatternTooltip->"A reaction like Reaction[{reactants..}, {products..}, kForwardRate].", Size->Line]
					],
					Expandable->False,
					Description->"A reversible reaction between two nucleic acid structures, from which melting temperature will be computed."
				},
				{
					InputName->"concentration",
					Widget->Alternatives[
						Adder[
							Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Micromolar], Units-> Picomolar | Nanomolar | Micromolar | Molar ]
						],
						Widget[Type->Expression, Pattern:> ListableP[ConcentrationP | DistributionP["Molar"] | Rule[SequenceP | StrandP | StructureP, UnitsP["Molar"] | DistributionP["Molar"]]], PatternTooltip->"A list of, or single concentration or concentration distribution like: QuantityDistribution[NormalDistribution[30, 2], Micromolar].", Size->Line]
					],
					Expandable->False,
					Description->"Concentration at which melting temperature is computed."
				}
			},
			Outputs :> {
				{
					OutputName->"meltingTemperatureObject",
					Pattern:> ObjectP[Object[Simulation, MeltingTemperature]],
					Description->"MeltingTemperature simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateMeltingTemperature[reactantAplusB, concentration]", "meltingTemperatureObject"},
			Description->"finds the product of reaction from 'reactantA' + 'reactantB', then computes the melting temperature.",
			Inputs :> {
				{
					InputName->"reactantAplusB",
					Widget->Widget[
						Type->Expression,
					(* Match on exactly 2 reactants added together--when they are the same, Mathematica switches to a multiply pattern (x2) so it needs to be in the pattern *)
						Pattern:> ListableP[Verbatim[Plus][(ObjectP[{Model[Sample], Object[Sample]}] | SequenceP | StrandP | StructureP), (ObjectP[{Model[Sample], Object[Sample]}] | SequenceP | StrandP | StructureP)] | 2 (ObjectP[{Model[Sample], Object[Sample]}] | SequenceP | StrandP | StructureP)],
						PatternTooltip->"Two sequences, strands, or structures added like: DNA[\"GGACTGACGCGTTGA\"] + DNA[\"TCAACGCGTCAGTCC\"].",
						Size->Line
					],
					Expandable->False,
					Description->"Two oligomers added to make a reaction."
				},
				{
					InputName->"concentration",
					Widget->Alternatives[
						Adder[
							Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Micromolar], Units-> Picomolar | Nanomolar | Micromolar | Molar ]
						],
						Widget[Type->Expression, Pattern:> ListableP[ConcentrationP | DistributionP["Molar"] | Rule[SequenceP | StrandP | StructureP, UnitsP["Molar"] | DistributionP["Molar"]]], PatternTooltip->"A list of, or single concentration or concentration distribution like: QuantityDistribution[NormalDistribution[30, 2], Micromolar].", Size->Line]
					],
					Expandable->False,
					Description->"Concentration at which melting temperature is computed."
				}
			},
			Outputs :> {
				{
					OutputName->"meltingTemperatureObject",
					Pattern:> ObjectP[Object[Simulation, MeltingTemperature]],
					Description->"MeltingTemperature simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateMeltingTemperature[reactantEquilibriumProduct, concentration]", "meltingTemperatureObject"},
			Description->"infers the type of reaction from the given 'reactant' \[Equilibrium] 'product' state and computes the melting temperature for that reaction.",
			Inputs :> {
				{
					InputName->"reactantEquilibriumProduct",
					Widget->Widget[Type->Expression, Pattern:> ListableP[StructureP \[Equilibrium] StructureP], PatternTooltip->"A structure at equilibrium like: Equilibrium[Structure[{Strand[DNA[\"AACCCCATAACCCCAACAAGGGGAAGAAGGGG\"]]},{Bond[{1,1,11;;14},{1,1,20;;23}]}],  Structure[{Strand[DNA[\"AACCCCATAACCCCAACAAGGGGAAGAAGGGG\"]]},{Bond[{1,1,3;;6},{1,1,29;;32}],Bond[{1,1,11;;14},{1,1,20;;23}]}]].", Size->Line],
					Expandable->False,
					Description->"A nucleic acid structure participating as a product in a reaction."
				},
				{
					InputName->"concentration",
					Widget->Alternatives[
						Adder[
							Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Micromolar], Units-> Picomolar | Nanomolar | Micromolar | Molar ]
						],
						Widget[Type->Expression, Pattern:> ListableP[ConcentrationP | DistributionP["Molar"] | Rule[SequenceP | StrandP | StructureP, UnitsP["Molar"] | DistributionP["Molar"]]], PatternTooltip->"A list of, or single concentration or concentration distribution like: QuantityDistribution[NormalDistribution[30, 2], Micromolar].", Size->Line]
					],
					Expandable->False,
					Description->"Concentration at which melting temperature is computed."
				}
			},
			Outputs :> {
				{
					OutputName->"meltingTemperatureObject",
					Pattern:> ObjectP[Object[Simulation, MeltingTemperature]],
					Description->"MeltingTemperature simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateMeltingTemperature[reactionMechanism, concentration]", "meltingTemperatureObject"},
			Description->"computes the melting temperature from the reaction in the given mechanism.",
			Inputs :> {
				{
					InputName->"reactionMechanism",
					Widget->Alternatives[
						Widget[Type->Object, Pattern:> ObjectP[Model[ReactionMechanism]]],
						Widget[Type->Expression, Pattern:> ListableP[ReactionMechanismP | ObjectP[Model[ReactionMechanism]]], PatternTooltip->"A reaction mechanism like ReactionMechanism[{\"a\"+\"b\"->\"c\",kf}].", Size->Line]
					],
					Expandable->False,
					Description->"A simple mechanism contains only one first order or second order reaction."
				},
				{
					InputName->"concentration",
					Widget->Alternatives[
						Adder[
							Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Micromolar], Units-> Picomolar | Nanomolar | Micromolar | Molar ]
						],
						Widget[Type->Expression, Pattern:> ListableP[ConcentrationP | DistributionP["Molar"] | Rule[SequenceP | StrandP | StructureP, UnitsP["Molar"] | DistributionP["Molar"]]], PatternTooltip->"A list of, or single concentration or concentration distribution like: QuantityDistribution[NormalDistribution[30, 2], Micromolar].", Size->Line]
					],
					Expandable->False,
					Description->"Concentration at which melting temperature is computed."
				}
			},
			Outputs :> {
				{
					OutputName->"meltingTemperatureObject",
					Pattern:> ObjectP[Object[Simulation, MeltingTemperature]],
					Description->"MeltingTemperature simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateMeltingTemperature[oligomer, concentration]", "meltingTemperatureObject"},
			Description->"considers the hybridization reaction between the given 'oligomer' and its reverse complement.",
			Inputs :> {
				{
					InputName->"oligomer",
					Widget->Alternatives[
						Widget[Type->Object, Pattern:> ObjectP[{Model[Sample], Object[Sample], Model[Molecule, Oligomer]}],PreparedSample->False],
						Widget[Type->Number, Pattern:> GreaterEqualP[0, 1]],
						Widget[Type->Expression, Pattern:> ListableP[_Integer | SequenceP | StrandP | ObjectP[{Model[Sample], Object[Sample], Model[Molecule, Oligomer]}]], PatternTooltip->"A sequence or strand like \"AAGGTT\" or Strand[DNA[\"ATCG\"]].", Size->Line]
					],
					Expandable->False,
					Description->"An oligomer participating in a hybridization reaction with its reverse complement."
				},
				{
					InputName->"concentration",
					Widget->Alternatives[
						Adder[
							Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Micromolar], Units-> Picomolar | Nanomolar | Micromolar | Molar ]
						],
						Widget[Type->Expression, Pattern:> ListableP[ConcentrationP | DistributionP["Molar"] | Rule[SequenceP | StrandP | StructureP, UnitsP["Molar"] | DistributionP["Molar"]]], PatternTooltip->"A list of, or single concentration or concentration distribution like: QuantityDistribution[NormalDistribution[30, 2], Micromolar].", Size->Line]
					],
					Expandable->False,
					Description->"Concentration at which melting temperature is computed."
				}
			},
			Outputs :> {
				{
					OutputName->"meltingTemperatureObject",
					Pattern:> ObjectP[Object[Simulation, MeltingTemperature]],
					Description->"MeltingTemperature simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateMeltingTemperature[structure, concentration]", "meltingTemperatureObject"},
			Description->"considers the melting reaction whereby all of the bonds in the given 'structure' are melted.",
			Inputs :> {
				{
					InputName->"structure",
					Widget->Widget[Type->Expression, Pattern:> ListableP[StructureP], PatternTooltip->"A list of or single structure like Structure[{Strand[DNA[\"AAAAA\"]],Strand[DNA[\"TTTTT\"]]},{Bond[{1,1},{2,1}]}].", Size->Line],
					Expandable->False,
					Description->"A nucleic acid structure that will be completely melted."
				},
				{
					InputName->"concentration",
					Widget->Alternatives[
						Adder[
							Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Micromolar], Units-> Picomolar | Nanomolar | Micromolar | Molar ]
						],
						Widget[Type->Expression, Pattern:> ListableP[ConcentrationP | DistributionP["Molar"] | Rule[SequenceP | StrandP | StructureP, UnitsP["Molar"] | DistributionP["Molar"]]], PatternTooltip->"A list of, or single concentration or concentration distribution like: QuantityDistribution[NormalDistribution[30, 2], Micromolar].", Size->Line]
					],
					Expandable->False,
					Description->"Concentration at which melting temperature is computed."
				}
			},
			Outputs :> {
				{
					OutputName->"meltingTemperatureObject",
					Pattern:> ObjectP[Object[Simulation, MeltingTemperature]],
					Description->"MeltingTemperature simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateMeltingTemperature[enthalpy, entropy, concentration]", "meltingTemperatureObject"},
			Description->"computes the melting temperature from the given enthalpy and entropy of a reaction.",
			Inputs :> {
				{
					InputName->"enthalpy",
					Widget->Alternatives[
						Widget[Type->Quantity, Pattern:> RangeP[-Infinity KilocaloriePerMole, Infinity KilocaloriePerMole], Units-> KilocaloriePerMole | Calorie / Micromole | Joule / Mole | Joule / Micromole ],
						Widget[Type->Expression, Pattern:> ListableP[EnergyP | DistributionP[Joule / Mole]], PatternTooltip->"Enter enthalpy or enthalpy distribution like: -55*KilocaloriePerMole or QuantityDistribution[EmpiricalDistribution[{-55}],KilocaloriePerMole].", Size->Line]
					],
					Expandable->False,
					Description->"Enthalpy of the reaction."
				},
				{
					InputName->"entropy",
					Widget->Alternatives[
						Widget[Type->Quantity, Pattern:> RangeP[-Infinity CaloriePerMoleKelvin, Infinity CaloriePerMoleKelvin], Units-> CaloriePerMoleKelvin | Calorie / (Micromole Kelvin) | Joule / (Mole Kelvin) | Joule / (Micromole Kelvin) ],
						Widget[Type->Expression, Pattern:> ListableP[EntropyP | DistributionP[Joule / (Mole Kelvin)]], PatternTooltip->"Enter entropy or entropy distribution like: -150*CaloriePerMoleKelvin or QuantityDistribution[NormalDistribution[-150,5],CaloriePerMoleKelvin].", Size->Line]
					],
					Expandable->False,
					Description->"Entropy of the reaction."
				},
				{
					InputName->"concentration",
					Widget->Alternatives[
						Adder[
							Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Micromolar], Units-> Picomolar | Nanomolar | Micromolar | Molar ]
						],
						Widget[Type->Expression, Pattern:> ListableP[ConcentrationP | DistributionP["Molar"] | Rule[SequenceP | StrandP | StructureP, UnitsP["Molar"] | DistributionP["Molar"]]], PatternTooltip->"A list of, or single concentration or concentration distribution like: QuantityDistribution[NormalDistribution[30, 2], Micromolar].", Size->Line]
					],
					Expandable->False,
					Description->"Concentration at which melting temperature is computed."
				}
			},
			Outputs :> {
				{
					OutputName->"meltingTemperatureObject",
					Pattern:> ObjectP[Object[Simulation, MeltingTemperature]],
					Description->"MeltingTemperature simulation object or packet."
				}
			}
		}
	},
	MoreInformation -> {
		"Melting temperature is defined as the temperature at which half of the strands are in the double-helical state and half are in the random-coil state.",
		"In first order folding or melting case, melting temperature is calculated from Tm = \[CapitalDelta]H/\[CapitalDelta]S.",
		"In second order paring or melting case, melting temperature is calculated from Tm = \[CapitalDelta]H/(\[CapitalDelta]S-R ln[Ct]). For bimolecular self-complementary cases (A + A \[Equilibrium] A2), Ct = C[A] (C[A] represents the concentration of A). For bimolecular nonself-complimentary cases (A + B \[Equilibrium] AB), if C[A] = C[B], Ct = (C[A] + C[B]) / 4, if C[A] > C[B], Ct = C[A] - C[B]/2, and if C[A] < C[B], Ct = C[B] - C[A]/2. See reference: Object[Report,Literature,\"id:o1k9jAKpjE8a\"]: John SantaLucia. \"A Unified View of Polymer,Dumbbell,and Oligonucleotide DNA Nearest-Neighbor Thermodynamics.\" Proceedings of the National Academy of Sciences of the United States of America 95.4 (1998):1460\[Dash]1465.",
		thermoMoreInfomration,
		"Assumes a second order reaction if enthalpy and entropy are provided."
	},
	Tutorials -> {
		"NearestNeighbor"
	},
	Guides -> {
		"Simulation",
		"NucleicAcids"
	},
	SeeAlso -> {
		"SimulateEntropy",
		"SimulateEnthalpy",
		"SimulateFreeEnergy"
	},
	Author -> {
		"brad",
		"amir.saadat",
		"david.hattery",
		"alice"
	},
	Preview->True
}];


(* ::Subsubsection:: *)
(*StructureFaces*)


DefineUsage[StructureFaces,
{
	BasicDefinitions -> {
		{"StructureFaces[structure]", "faces", "given a nucleic acid structure, the function breaks down the structure into a list of 'faces', each face contains the corresponding loop type and start/end indices in the original structure."}
	},
	MoreInformation -> {
		"The decomposited faces of the structure plays a vital role in thermodynamics calculation, such as entropy/enthalpy/free energy calculation. Each face can be a type of StackingLoop|HairpinLoop|BulgeLoop|InternalLoop|MultipleLoop, more detailed description about the loop definitions can be found in Object[Report,Literature,\"id:GmzlKjPkvDR4\"]: SantaLucia Jr, J., & Hicks, D. (2004). The thermodynamics of DNA structural motifs. Annu. Rev. Biophys. Biomol. Struct., 33, 415-440."
	},
	Input :> {
		{"structure", _?StructureQ, "A structure that you want the faces of."}
	},
	Output :> {
		{"faces", {{LoopTypeP, {_Integer, _Integer}..}...}, "The faces of the structure, the corresponding loop type of each face can be StackingLoop|HairpinLoop|BulgeLoop|InternalLoop|MultipleLoop."}
	},
	SeeAlso -> {
		"SimulateFreeEnergy",
		"SimulateFolding",
		"SimulateReactivity"
	},
	Author -> {"scicomp", "brad", "amir.saadat", "qian", "alice", "austin"}
}];