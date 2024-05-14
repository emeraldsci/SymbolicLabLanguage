(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification,ProteinCapillaryElectrophoresis],{
	Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of a protein capillary electrophoresis instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		QualifiedExperiments->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Alternatives[CESDS,cIEF],
			Description->"The experiment/s to qualify as part of the procedure.",
			Category->"General"
		},
		(* Capillary gel electrophoresis SDS *)
		CESDSSampleVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0Microliter],
			Units->Microliter,
			Description->"Specifies the volumes of prepared samples (in PreparatoryUnitOperations) to use to qualify capillary gel electrophoresis SDS experiments on the instrument.",
			Category->"Sample Preparation"
		},
		CESDSSamplePremadeMastermix->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample]
			],
			IndexMatching->CESDSSampleVolumes,
			Description->"For each member of CESDSSampleVolumes, specifies the sample models of premade mastermixes to be used with samples to qualify capillary gel electrophoresis SDS experiments on the instrument.",
			Category->"Sample Preparation"
		},
		CESDSSamplePremadeMastermixVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0Microliter],
			Units->Microliter,
			IndexMatching->CESDSSampleVolumes,
			Description->"For each member of CESDSSampleVolumes, specifies the volumes of premade mastermixes to be used with samples to qualify capillary gel electrophoresis SDS experiments on the instrument.",
			Category->"Sample Preparation"
		},
		CESDSStandards->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample]
			],
			Description->"The standard models used to test capillary gel electrophoresis SDS experiments run on the instrument.",
			Category->"Sample Preparation"
		},
		CESDSStandardVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0Microliter],
			Units->Microliter,
			IndexMatching->CESDSStandards,
			Description->"For each member of CESDSStandards, specifies the volume of resuspended sample used to resuspend lyophilized standards used to qualify capillary gel electrophoresis SDS experiments on the instrument.",
			Category->"Sample Preparation"
		},
		CESDSStandardPremadeMastermix->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample]
			],
			IndexMatching->CESDSStandards,
			Description->"For each member of CESDSStandards, specifies the sample models of premade mastermixes to be used with standards to qualify capillary gel electrophoresis SDS experiments on the instrument.",
			Category->"Sample Preparation"
		},
		CESDSStandardPremadeMastermixVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0Microliter],
			Units->Microliter,
			IndexMatching->CESDSStandards,
			Description->"For each member of CESDSStandards, specifies the volumes of premade mastermixes to be used with standards to qualify capillary gel electrophoresis SDS experiments on the instrument.",
			Category->"Sample Preparation"
		},
		CESDSLadders->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample]
			],
			Description->"The Ladder models used to test capillary gel electrophoresis SDS experiments run on the instrument.",
			Category->"Sample Preparation"
		},
		CESDSLadderVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0Microliter],
			Units->Microliter,
			IndexMatching->CESDSLadders,
			Description->"For each member of CESDSLadders, specifies the volume of resuspended sample used to resuspend lyophilized Ladders used to qualify capillary gel electrophoresis SDS experiments on the instrument.",
			Category->"Sample Preparation"
		},
		CESDSLadderPremadeMastermix->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample]
			],
			IndexMatching->CESDSLadders,
			Description->"For each member of CESDSLadders, specifies the sample models of premade mastermixes to be used with Ladders to qualify capillary gel electrophoresis SDS experiments on the instrument.",
			Category->"Sample Preparation"
		},
		CESDSLadderPremadeMastermixVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0Microliter],
			Units->Microliter,
			IndexMatching->CESDSLadders,
			Description->"For each member of CESDSLadders, specifies the volumes of premade mastermixes to be used with Ladders to qualify capillary gel electrophoresis SDS experiments on the instrument.",
			Category->"Sample Preparation"
		},
		(* Capillary Isoelectric Focusing *)
		CIEFSampleVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0Microliter],
			Units->Microliter,
			Description->"Specifies the volumes of prepared samples (in PreparatoryUnitOperations) to use to qualify capillary isoelectric focusing experiments on the instrument.",
			Category->"Sample Preparation"
		},
		CIEFSamplePremadeMastermix->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample]
			],
			IndexMatching->CIEFSampleVolumes,
			Description->"For each member of CIEFSampleVolumes, specifies the sample models of premade mastermixes to be used with samples to qualify capillary isoelectric focusing experiments on the instrument.",
			Category->"Sample Preparation"
		},
		CIEFSamplePremadeMastermixVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0Microliter],
			Units->Microliter,
			IndexMatching->CIEFSampleVolumes,
			Description->"For each member of CIEFSampleVolumes, specifies the volumes of premade mastermixes to be used with samples to qualify capillary isoelectric focusing experiments on the instrument.",
			Category->"Sample Preparation"
		},
		CIEFStandards->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample]
			],
			Description->"The standard models used to test capillary gel electrophoresis SDS experiments run on the instrument.",
			Category->"Sample Preparation"
		},
		CIEFStandardVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0Microliter],
			Units->Microliter,
			IndexMatching->CIEFStandards,
			Description->"For each member of CIEFStandards, specifies the volume of resuspended sample used to resuspend lyophilized standards used to qualify capillary isoelectric focusing experiments on the instrument.",
			Category->"Sample Preparation"
		},
		CIEFStandardPremadeMastermix->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample]
			],
			IndexMatching->CIEFStandards,
			Description->"For each member of CIEFStandards, specifies the sample models of premade mastermixes to be used with standards to qualify capillary isoelectric focusing experiments on the instrument.",
			Category->"Sample Preparation"
		},
		CIEFStandardPremadeMastermixVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0Microliter],
			Units->Microliter,
			IndexMatching->CIEFStandards,
			Description->"For each member of CIEFStandards, specifies the volumes of premade mastermixes to be used with standards to qualify capillary isoelectric focusing experiments on the instrument.",
			Category->"Sample Preparation"
		}
	}
}];