(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Method, SynthesisCycle], {
	Description->"A set of method parameters for a solid phase synthesis cycle for a given monomer model.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

	(* --- Polymer --- *)
		Scale->{
			Format->Single,
			Class->Real,
			Pattern :> GreaterP[0 Micromole],
			Units->Micromole,
			Description->"The starting amount of free available sites for coupling the growing chain to during synthesis.",
			Category -> "General"
		},
		SynthesisType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PolymerP,
			Description -> "The type of polymer synthesized by this method.",
			Category -> "General"
		},
		SwellPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SynthesisCycleStepP,
			Description -> "A list of synthesis steps used to swell the resin prior to the start of the synthesis.",
			Category -> "General",
			Abstract -> True
		},
		DownloadCyclePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SynthesisCycleStepP,
			Description -> "A list of synthesis steps used to couple the first C terminal monomer to undownloaded resin.",
			Category -> "General",
			Abstract -> True
		},
		InitialCyclePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SynthesisCycleStepP,
			Description -> "A list of synthesis steps used to couple the second monomer to the strand being synthesized.",
			Category -> "General",
			Abstract -> True
		},
		StandardCyclePrimitives -> {
			Format -> Multiple,
			Class -> {Expression,Expression},
			Pattern :> {SequenceP,{SynthesisCycleStepP..}},
			Description -> "For each type of a monomer being used, a list of synthesis steps used to couple all but the first two and the last monomers to the strand being synthesized.",
			Category -> "General",
			Headers-> {"Monomer Type", "Primitives"},
			Abstract -> True
		},
		FinalCyclePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SynthesisCycleStepP,
			Description -> "A list of synthesis steps used to couple the last monomer in the sequence to the strand being synthesized.",
			Category -> "General",
			Abstract -> True
		},
		CleavagePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SynthesisCycleStepP,
			Description -> "A list of cleavage steps used cleave the strands from the resin after synthesis.",
			Category -> "General",
			Abstract -> True
		},

	(* --- Washing --- *)
		WashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milliliter],
			Units -> Milliliter,
			Description -> "The volume of wash solution used to rinse the resin in the reaction vessel.",
			Category -> "Washing"
		},
		WashPurgeTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Second,
			Description -> "The length of time that for which the wash solution is purged from the reaction vessel.",
			Category -> "Washing"
		},

	(* --- Deprotection --- *)
		DeprotectionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The volume of deprotection solution incubated with the resin in order to remove the protecting group from the growing polymer chain and make it available for a subsequent coupling.",
			Category -> "Deprotection"
		},
		DeprotectionTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "The length of time that the resin is incubated with deprotection solution.",
			Category -> "Deprotection"
		},
		NumberOfDeprotections -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times the resin is incubated with deprotection solution.",
			Category -> "Deprotection"
		},
		NumberOfDeprotectionWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times the resin is to be rinsed with the wash solution after a deprotection in order to remove any unreacted material not covalently bound to the resin.",
			Category -> "Deprotection"
		},
		DeprotectionPurgeTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Second,
			Description -> "The length of time that for which the deprotection solution is purged from the reaction vessel.",
			Category -> "Deprotection"
		},

	(* -- Deprotonation --- *)
		DeprotonationVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The volume of deprotonation solution incubated with the resin in order to remove a hydrogen cation to faciliate subsequent coupling reaction.",
			Category -> "Deprotonation"
		},
		DeprotonationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "The length of time that the resin is incubated with the deprotonation solution.",
			Category -> "Deprotonation"
		},
		NumberOfDeprotonations -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times the resin is incubated with deprotonation solution.",
			Category -> "Deprotonation"
		},
		NumberOfDeprotonationWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times the resin is to rinsed with the wash solution.",
			Category -> "Deprotonation"
		},

	(* --- Monomer Activation --- *)
		MonomerVolumeRatio -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*((Milliliter)/Micromole)],
			Units -> (Milliliter)/Micromole,
			Description -> "The volume of monomer solution per unit of synthesis scale incubated with the coupling solution during the monomer activation in order to add a leaving group to the monomer for the subsequent coupling reaction.",
			Category -> "Monomer Activation"
		},
		MonomerVolumes->{
			Format -> Multiple,
			Class -> {Expression,Real},
			Pattern :> {SequenceP,GreaterEqualP[0 Milliliter]},
			Units -> {None,Milliliter},
			Description -> "The volume of monomer solution incubated with the preactivation and base or activation solution in order to add a leaving group to the mononomer for the subsequent coupling reaction.",
			Category -> "Monomer Activation",
			Headers-> {"Monomer Type", "Volume"}
		},
		PreactivationVolumes->{
			Format -> Multiple,
			Class -> {Expression,Real},
			Pattern :> {SequenceP,GreaterEqualP[0 Milliliter]},
			Units -> {None,Milliliter},
			Description -> "The volume of preactivation solution incubated with the monomer and base solution.",
			Category -> "Monomer Activation",
			Headers-> {"Monomer Type", "Volume"}
		},
		BaseVolumes->{
			Format -> Multiple,
			Class -> {Expression,Real},
			Pattern :> {SequenceP,GreaterEqualP[0 Milliliter]},
			Units -> {None,Milliliter},
			Description -> "The volume of base solution incubated with the monomer and preactivation solution.",
			Category -> "Monomer Activation",
			Headers-> {"Monomer Type", "Volume"}
		},
		ActivationVolumes->{
			Format -> Multiple,
			Class -> {Expression,Real},
			Pattern :> {SequenceP,GreaterEqualP[0 Milliliter]},
			Units -> {None,Milliliter},
			Description -> "The volume of activation solution incubated with the monomer solution.",
			Category -> "Monomer Activation",
			Headers-> {"Monomer Type", "Volume"}
		},
		ActivationTimes -> {
			Format -> Multiple,
			Class -> {Expression,Real},
			Pattern :> {SequenceP,GreaterEqualP[0*Minute]},
			Units -> {None,Minute},
			Description -> "The length of time the coupling solution is mixed to activate the monomer prior to its incubation with the resin.",
			Category -> "Monomer Activation",
			Headers-> {"Monomer Type", "Time"}
		},

	(* --- Coupling --- *)
		CouplingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "The length of time that the resin is incubated with the coupling solution in order to link the coupling monomer the growing polymer chain.",
			Category -> "Coupling"
		},
		NumberOfCouplingWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times the resin is to rinsed with the wash solution after a coupling in order to remove any unreacted material not covalently bound to the resin.",
			Category -> "Coupling"
		},
		NumberOfCouplings -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times the resin is incubated with coupling solution.",
			Category -> "Coupling"
		},

	(* --- Capping --- *)
		CappingVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The volume of capping solution incubated with the resin in order to add a permanent protecting group to any unreacted chains and remove them from any subsequent coupling steps.",
			Category -> "Capping"
		},
		CappingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "The length of time that the resin is incubated with the capping solution.",
			Category -> "Capping"
		},
		NumberOfCappings -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times the resin is incubated with capping solution.",
			Category -> "Capping"
		},
		NumberOfCappingWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times the resin is to rinsed with the wash solution after a capping in order to remove any unreacted material not covalently bound to the resin.",
			Category -> "Capping"
		},
		CappingPurgeTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Second,
			Description -> "The length of time that for which the capping solution is purged from the reaction vessel.",
			Category -> "Capping"
		}
	}
}];
