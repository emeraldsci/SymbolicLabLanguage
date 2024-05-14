(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Simulation, Hybridization], {
	Description->"A simulation to predict the secondary structure of a given nucleic acid oligomer by considering the formation of potential intermolecular Watson-Crick pairing between nucleotides.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- Method Information --- *)
		StartingMaterials -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule, Oligomer][Simulations]|Model[Molecule, cDNA][Simulations]|Model[Molecule, Transcript][Simulations],
			Description -> "The objects containing the source structure used in this simulation.",
			Category -> "General",
			Abstract -> True
		},
		InitialStructures -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> StructureP,
			Description -> "The starting structures of the nucleic acid oligomers which will be used to initialize hybridization.",
			Category -> "General",
			Abstract -> True
		},
		HybridizationDomain -> {
			Format -> Multiple,
			Class -> {Integer, Integer, Integer},
			Pattern :> {GreaterP[0,1],GreaterP[0Nucleotide,1Nucleotide],GreaterP[0Nucleotide,1Nucleotide]},
			Units -> {None, Nucleotide, Nucleotide},
			Description -> "The domain of positions within the strands for which hybridization calculations are restricted to.",
			Category -> "General",
			Headers -> {"Strand Index","Starting Base Number","Ending Base Number"}
		},
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Temperature at which Gibbs free energy of hybridized structure will be calculated.",
			Category -> "General",
			Abstract -> False
		},
		Method -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> HybridizationMethodP,
			Description -> "Determine whether the returned hybridized structures are sorted by ascending energy or descending number of bonds.",
			Category -> "General",
			Abstract -> False
		},
		Depth -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterEqualP[1, 1] | {GreaterEqualP[1, 1]} | Infinity,
			Description -> "Number of times to recursively hybridize the structures when simulating.",
			Category -> "General",
			Abstract -> False
		},
		Consolidate -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Determine if all hybridizations are extended to their maximum length so that the neighbouring bases of each bond cannot be further paired.",
			Category -> "General",
			Abstract -> False
		},
		MaxMismatch -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "Maximum number of mismatches allowed in any given duplex.",
			Category -> "General",
			Abstract -> False
		},
		MinPieceSize -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "Minimum number of consecutive paired bases required in a duplex containing mismatches.",
			Category -> "General",
			Abstract -> False
		},
		MinLevel -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "Minimum number of bases required in each duplex.",
			Category -> "General",
			Abstract -> False
		},
		(* --- Simulation Results --- *)
		MostStableStructure -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> StructureP,
			Description -> "The returned structure which has the minimum Gibbs free energy or maximum number of bonds depending on Method option.",
			Category -> "Simulation Results",
			Abstract -> True
		},
		HybridizedStructures -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> StructureP,
			Description -> "The final hybridized structures resulting from the simulation starting from the initial structures.",
			Category -> "Simulation Results",
			Abstract -> True
		},
		HybridizedEnergies -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> EnergyP,
			Units -> KilocaloriePerMole,
			Description -> "For each member of HybridizedStructures, the free energy of hybridization starting from the initial structure to the hybridized structure.",
			Category -> "Simulation Results",
			IndexMatching -> HybridizedStructures,
			Abstract -> True
		},
		HybridizedNumberOfBonds -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "For each member of HybridizedStructures, the number of bonds in the hybridized structure.",
			Category -> "Simulation Results",
			IndexMatching -> HybridizedStructures,
			Abstract -> True
		},
		HybridizedPercentage -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Percent],
			Units -> Percent,
			Description -> "For each member of HybridizedStructures, the percent composition of the hybridized structure at equilibrium.",
			Category -> "Simulation Results",
			IndexMatching -> HybridizedStructures,
			Abstract -> True
		},
		HybridizationMechanism -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReactionMechanismP,
			Description -> "The ReactionMechanism summarizing the series of reactions in the hybridization process.",
			Category -> "Simulation Results",
			Abstract -> True
		}
	}
}];
