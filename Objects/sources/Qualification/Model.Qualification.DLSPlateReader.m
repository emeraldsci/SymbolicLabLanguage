(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Packager loads things alphabetically, so the shared fields for the plate reader qual models live here. *)
(* Shared ModelQualificationPlateReader Fields*)
$ModelQualificationPlateReaderSharedFields={
	PlateReaderModel->{
		Format->Single,
		Class->Link,
		Pattern:>_Link,
		Relation->Alternatives[
			Model[Instrument]
		],
		Description->"The plate reader on which the Qualification is run.",
		Category->"General"
	},

	SampleBlankPairs->{
		Format->Multiple,
		Class->{Link,Link},
		Pattern:>{_Link ,_Link},
		Relation->{Model[Sample],Model[Sample]},
		Description->"Model sample paired with corresponding blank used for solvent background.",
		Headers->{"Sample","Blank"},
		Category->"General"
	},

	(*Sample Preparation*)

	SamplePreparationVolume->{
		Format->Single,
		Class->Real,
		Pattern:>GreaterP[0*Microliter],
		Units->Microliter,
		Description->"The volume of test sample prepared for the qualification.",
		Category->"Sample Preparation"
	},

	PreparationModelContainer->{
		Format->Single,
		Class->Link,
		Pattern:>_Link,
		Relation->Model[Container],
		Description->"The model container used to prepare qualification test samples.",
		Category->"Sample Preparation"
	},

	PrepareReplicates->{
		Format->Single,
		Class->Boolean,
		Pattern:>BooleanP,
		Description->"Indicates if replicates should be expanded out when generating sample manipulation primitives.",
		Category->"Sample Preparation"
	},

	(*UV Vis - Wavelength Accuracy*)

	WavelengthAccuracySample->{
		Format -> Single,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Model[Sample]
		],
		Description -> "The sample model used to assess wavelength accuracy of detector.",
		Category -> "Wavelength Accuracy Test"
	},

	WavelengthAccuracyReplicates -> {
		Format -> Single,
		Class -> Integer,
		Pattern :> GreaterP[0,1],
		Description -> "The number of replicate samples used to test wavelength accuracy.",
		Category -> "Wavelength Accuracy Test"
	},

	(* UV-Vis Absorbance Accuracy *)

	AbsorbanceAccuracySamples->{
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Model[Sample]
		],
		Description -> "The sample models used to assess absorbance accuracy of detector.",
		Category -> "Absorbance Accuracy Test"
	},

	AbsorbanceAccuracyReplicates -> {
		Format -> Single,
		Class -> Integer,
		Pattern :> GreaterP[0,1],
		Description -> "The number of replicate samples used to test absorbance accuracy.",
		Category -> "Absorbance Accuracy Test"
	},

	(* UV-Vis Detector Linearity *)

	LinearitySamples -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation ->  Alternatives[
			Model[Sample]
		],
		Description -> "The sample models used to assess linearity of detector.",
		Category -> "Detector Linearity Test"
	},

	LinearityReplicates -> {
		Format -> Single,
		Class -> Integer,
		Pattern :> GreaterP[0,1],
		Description -> "The number of replicate samples used to test linearity.",
		Category -> "Detector Linearity Test"
	},

	(*UV Vis Stray Light*)

	StrayLightSamples -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation ->  Alternatives[
			Model[Sample]
		],
		Description -> "The sample models used to test the stray light of the instrument.",
		Category -> "Stray Light Test"
	},

	StrayLightReplicates -> {
		Format -> Single,
		Class -> Integer,
		Pattern :> GreaterP[0,1],
		Description -> "The number of replicate samples used to test stray light.",
		Category -> "Stray Light Test"
	},

	(*Fluorescence Polarization Test*)

	PolarizationSamples -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Model[Sample]
		],
		Description -> "The Fluorescence Polarization Reference sample Models used to assess fluorescence polarization measurements by the plate reader.",
		Category -> "Polarization Test"
	},

	PolarizationReplicates ->{
		Format -> Single,
		Class -> Integer,
		Pattern :> GreaterP[0,1],
		Description -> "The number of replicate samples used to test polarization measurements.",
		Category -> "Polarization Test"
	},

	(*Alpha Screen Test*)
	AlphaScreenAccuracySamples -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Model[Sample]
		],
		Description -> "The AlphaScreen Reference sample Models used to assess AlphaScreen absorbance accuracy by the plate reader.",
		Category -> "AlphaScreen Test"
	},

	AlphaScreenAccuracyReplicates ->{
		Format -> Single,
		Class -> Integer,
		Pattern :> GreaterP[0,1],
		Description -> "The number of replicate samples used to test AlphaScreen absorbance accuracy.",
		Category -> "AlphaScreen Test"
	},
	AlphaScreenLinearitySamples -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Model[Sample]
		],
		Description -> "The AlphaScreen Reference sample Models used to assess AlphaScreen detector linearity by the plate reader.",
		Category -> "AlphaScreen Test"
	},
	AlphaScreenLinearityReplicates ->{
		Format -> Single,
		Class -> Integer,
		Pattern :> GreaterP[0,1],
		Description -> "The number of replicate samples used to test AlphaScreen detector linearity.",
		Category -> "AlphaScreen Test"
	},

	(* CircularDichroism Test *)
	CircularDichroismRectusSample -> {
		Format -> Single,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Model[Sample]
		],
		Description -> "The CircularDichroism Reference sample Model with optical pure R- (Rectus) configuration that will be used to prepare a serial of sample with different enantiomeric excess.",
		Category -> "Circular Dichroism Qualification"
	},
	CircularDichroismSinisterSample -> {
		Format -> Single,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Model[Sample]
		],
		Description -> "The CircularDichroism Reference sample Model with optical pure S- (Sinister) configuration that will be used to prepare a serial of sample with different enantiomeric excess.",
		Category -> "Circular Dichroism Qualification"
	},
	CircularDichroismReplicates ->{
		Format -> Single,
		Class -> Integer,
		Pattern :> GreaterP[0,1],
		Description -> "The number of replicate samples used to test CircularDichroism qualification samples.",
		Category -> "Circular Dichroism Qualification"
	},

	(* Nephelometry Test *)
	NephelometryAccuracySamples -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Model[Sample],
			Object[Sample]
		],
		Description -> "The sample models used to assess Nephelometer light scattering accuracy by the plate reader.",
		Category -> "Nephelometer Qualification"
	},
	NephelometryAccuracyReplicates ->{
		Format -> Single,
		Class -> Integer,
		Pattern :> GreaterP[0,1],
		Description -> "The number of replicate samples used to test Nephelometer light scattering accuracy.",
		Category -> "Nephelometer Qualification"
	},
	NephelometryLinearitySamples -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Model[Sample],
			Object[Sample]
		],
		Description -> "The sample Models used to assess Nephelometer detector linearity by the plate reader.",
		Category -> "Nephelometer Qualification"
	},
	NephelometryLinearityReplicates ->{
		Format -> Single,
		Class -> Integer,
		Pattern :> GreaterP[0,1],
		Description -> "The number of replicate samples used to test Nephelometer detector linearity.",
		Category -> "Nephelometer Qualification"
	}
};

With[
	(* Shared Fields *)
	{insertMe=Sequence@@$ModelQualificationPlateReaderSharedFields},
	DefineObjectType[Model[Qualification, DLSPlateReader], {
		Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of a plate reader.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
			(* Sample Preparation *)
			insertMe,
			(* Light Scattering Specific Fields *)
			LightScatteringValidationSamples -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Model[Sample],
				Description -> "The standards used for testing the instrument.",
				Category -> "Sample Preparation"
			},
			LightScatteringIndependentReplicates -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> _Integer,
				Description -> "For each member of LightScatteringValidationSamples, number of independently prepared sample replicates or concentration series per sample type.",
				Category -> "Sample Preparation",
				IndexMatching -> LightScatteringValidationSamples
			},
			LightScatteringWellReplicates -> {
				Format -> Single,
				Class -> Integer,
				Pattern :> RangeP[3, 384, 1],
				Description -> "Number of technical well replicates for each sample/concentration.",
				Category -> "Sample Preparation"
			}

			(* Dynamic Light Scattering Test *)
				(* Add diffusion coefficient dilution series later *)

			(* Static Light Scattering Test *)
				(* Add A2 dilution series later *)

		}
	}];
];