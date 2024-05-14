(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,ProteinCapillaryElectrophoresis],{
	Description->"A protocol that verifies the functionality of the protein capillary electrophoresis instrument target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		QualifiedExperiments->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Alternatives[CESDS,cIEF],
			Description->"The experiments tested as part of this qualification object.",
			Category->"General"
		},
		SamplePreparationProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,RoboticSamplePreparation]|Object[Protocol,ManualSamplePreparation],
			Description -> "The sample manipulation protocol used to generate the test samples.",
			Category -> "Sample Preparation"
		},
		(* Capillary gel electrophoresis SDS *)
		CESDSQualificationProtocol->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,CapillaryGelElectrophoresisSDS],
			Description->"The absorbance spectroscopy protocol used to test capillary gel electrophoresis SDS performance.",
			Category -> "General"
		},
		CESDSQualificationSamples->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description->"All samples used in this qualification that are used to test capillary gel electrophoresis SDS target instrument capabilities.",
			Category -> "General"
		},
		CESDSSamples->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description->"Samples with known expected results that are used to test capillary gel electrophoresis SDS target instrument capabilities.",
			Category -> "General"
		},
		CESDSSampleVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0Microliter],
			Units -> Microliter,
			IndexMatching->CESDSSamples,
			Description->"For each member of CESDSSamples, specifies the volume of resuspended sample used to resuspend lyophilized samples used to qualify capillary gel electrophoresis SDS experiments on the instrument.",
			Category->"Sample Preparation"
		},
		CESDSSamplePremadeMastermixes->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample]
			],
			IndexMatching->CESDSSamples,
			Description->"For each member of CESDSSamples, specifies the sample models of premade mastermixes to be used with samples to qualify capillary gel electrophoresis SDS experiments on the instrument.",
			Category -> "General"
		},
		CESDSSamplePremadeMastermixVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0Microliter],
			Units -> Microliter,
			IndexMatching->CESDSSamples,
			Description->"For each member of CESDSSamples, specifies the volumes of premade mastermixes to be used with samples to qualify capillary gel electrophoresis SDS experiments on the instrument.",
			Category -> "General"
		},
		CESDSStandards->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description->"Samples with known expected results that are used to test capillary gel electrophoresis SDS target instrument capabilities.",
			Category -> "General"
		},
		CESDSStandardVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0Microliter],
			Units -> Microliter,
			IndexMatching->CESDSStandards,
			Description->"For each member of CESDSStandards, specifies the volume of resuspended sample used to resuspend lyophilized samples used to qualify capillary gel electrophoresis SDS experiments on the instrument.",
			Category->"Sample Preparation"
		},
		CESDSStandardPremadeMastermixes->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample]
			],
			IndexMatching->CESDSStandards,
			Description->"For each member of CESDSStandards, specifies the sample models of premade mastermixes to be used with samples to qualify capillary gel electrophoresis SDS experiments on the instrument.",
			Category -> "General"
		},
		CESDSStandardPremadeMastermixVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0Microliter],
			Units -> Microliter,
			IndexMatching->CESDSStandards,
			Description->"For each member of CESDSStandards, specifies the volumes of premade mastermixes to be used with samples to qualify capillary gel electrophoresis SDS experiments on the instrument.",
			Category -> "General"
		},
		CESDSLadders->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description->"Samples with known expected results that are used to test capillary gel electrophoresis SDS target instrument capabilities.",
			Category -> "General"
		},
		CESDSLadderVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0Microliter],
			Units -> Microliter,
			IndexMatching->CESDSLadders,
			Description->"For each member of CESDSLadders, specifies the volume of resuspended sample used to resuspend lyophilized samples used to qualify capillary gel electrophoresis SDS experiments on the instrument.",
			Category->"Sample Preparation"
		},
		CESDSLadderPremadeMastermixes->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample]
			],
			IndexMatching->CESDSLadders,
			Description->"For each member of CESDSLadders, specifies the sample models of premade mastermixes to be used with samples to qualify capillary gel electrophoresis SDS experiments on the instrument.",
			Category -> "General"
		},
		CESDSLadderPremadeMastermixVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0Microliter],
			Units -> Microliter,
			IndexMatching->CESDSLadders,
			Description->"For each member of CESDSLadders, specifies the volumes of premade mastermixes to be used with samples to qualify capillary gel electrophoresis SDS experiments on the instrument.",
			Category -> "General"
		},
		(*Experimental Results*)
		CESDSPeaksAnalyses->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Analysis,Peaks]
			],
			Description->"Analyses performed to determine the peak location for capillary gel electrophoresis qualification samples.",
			Category->"Experimental Results"
		},
		(* Capillary Isoelectric Focusing *)
		CIEFQualificationProtocol->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,CapillaryIsoelectricFocusing],
			Description->"The absorbance spectroscopy protocol used to test capillary isoelectric focusing performance.",
			Category -> "General"
		},
		CIEFQualificationSamples->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description->"All samples used in this qualification that are used to test capillary isoelectric focusing target instrument capabilities.",
			Category -> "General"
		},
		CIEFSamples->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description->"Samples with known expected results that are used to test capillary isoelectric focusing target instrument capabilities.",
			Category -> "General"
		},
		CIEFSampleVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0Microliter],
			Units -> Microliter,
			IndexMatching->CIEFSamples,
			Description->"For each member of CIEFSamples, specifies the volume of resuspended sample used to resuspend lyophilized samples used to qualify capillary isoelectric focusing experiments on the instrument.",
			Category->"Sample Preparation"
		},
		CIEFSamplePremadeMastermixes->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample]
			],
			IndexMatching->CIEFSamples,
			Description->"For each member of CIEFSamples, specifies the sample models of premade mastermixes to be used with samples to qualify capillary isoelectric focusing experiments on the instrument.",
			Category -> "General"
		},
		CIEFSamplePremadeMastermixVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0Microliter],
			Units -> Microliter,
			IndexMatching->CIEFSamples,
			Description->"For each member of CIEFSamples, specifies the volumes of premade mastermixes to be used with samples to qualify capillary isoelectric focusing experiments on the instrument.",
			Category -> "General"
		},
		CIEFStandards->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description->"Samples with known expected results that are used to test capillary isoelectric focusing target instrument capabilities.",
			Category -> "General"
		},
		CIEFStandardVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0Microliter],
			Units -> Microliter,
			IndexMatching->CIEFStandards,
			Description->"For each member of CIEFStandards, specifies the volume of resuspended sample used to resuspend lyophilized samples used to qualify capillary isoelectric focusing experiments on the instrument.",
			Category->"Sample Preparation"
		},
		CIEFStandardPremadeMastermixes->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample]
			],
			IndexMatching->CIEFStandards,
			Description->"For each member of CIEFStandards, specifies the sample models of premade mastermixes to be used with samples to qualify capillary isoelectric focusing experiments on the instrument.",
			Category -> "General"
		},
		CIEFStandardPremadeMastermixVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0Microliter],
			Units -> Microliter,
			IndexMatching->CIEFStandards,
			Description->"For each member of CIEFStandards, specifies the volumes of premade mastermixes to be used with samples to qualify capillary isoelectric focusing experiments on the instrument.",
			Category -> "General"
		},
		(*Experimental Results*)
		CIEFPeaksAnalyses->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Analysis,Peaks]
			],
			Description->"Analyses performed to determine the peak location for capillary isoelectric focusing qualification samples.",
			Category->"Experimental Results"
		}
	}
}];
