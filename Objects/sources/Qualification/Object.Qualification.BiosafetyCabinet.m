(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,BiosafetyCabinet], {
	Description->"A protocol that verifies the functionality of the biosafety cabinet target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields ->{
		SamplePreparationUnitOperations->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SamplePreparationP,
			Description->"The sample preparation unit operations used to handle transfers in this qualification.",
			Category->"Sample Preparation"
		},
		SamplePreparationManipulation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,ManualSamplePreparation],
			Description->"The sample preparation protocol used used to handle transfers in this qualification.",
			Category->"Sample Preparation"
		},
		SampleFiltrationPreparationManipulation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,ManualSamplePreparation],
			Description->"The sample preparation protocol used used to handle transfers in this qualification.",
			Category->"Sample Preparation"
		},
		SampleIncubationProtocol->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,IncubateCells],
			Description->"The sample incubation protocol used to handle samples in this qualification.",
			Category->"Sample Preparation"
		},
		SampleImagingProtocol->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,ImageSample],
			Description->"The sample imaging protocol used to handle samples in this qualification.",
			Category->"General"
		},
		BacterialMediaSamples->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description->"The media buffer solutions which will be utilized during this qualification.",
			Category->"General"
		},
		UnfilteredSample->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description->"The unfiltered buffer solution which will be utilized during this qualification.",
			Category->"General"
		},
		FilteredSample->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample],
				Model[Container,Vessel],
				Object[Container,Vessel]
			],
			Description->"The buffer solution which will be utilized filtered during this qualification.",
			Category->"General"
		},
		PipetteTips -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "The model of the sterile pipette tips used for this qualification.",
			Category -> "General"
		},
		SmokeGenerator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part],
				Object[Part]
			],
			Description -> "The smoke generator used to evaluate airflow in this qualification.",
			Category -> "General"
		},
		Lighter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part,Lighter],
				Object[Part,Lighter]
			],
			Description -> "The lighter used to light the smoke generator to evaluate airflow in this qualification.",
			Category -> "General"
		},
		Anemometer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The air flow meter used to evaluate airflow in this qualification.",
			Category -> "General"
		},
		AnemometerStand -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The stand that hold the air flow meter during measurement in this qualification.",
			Category -> "General"
		},
		ConstrictedWindowTemperature -> {
			Format -> Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description -> "The temperature measured on the Constricted Window test.",
			Category -> "Test Results"
		},
		ConstrictedWindowMeanAirFlow -> {
			Format -> Single,
			Class->Real,
			Pattern:>GreaterP[0*(Meter/Second)],
			Units->(Foot/Minute),
			Description -> "The average airflow measured on the Constricted Window test.",
			Category -> "Test Results"
		},
		DownflowTemperature -> {
			Format -> Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description -> "The temperature measured on the DownFlow test.",
			Category -> "Test Results"
		},
		DownflowMeanAirFlow -> {
			Format -> Single,
			Class->Real,
			Pattern:>GreaterP[0*(Meter/Second)],
			Units->(Foot/Minute),
			Description -> "The average airflow measured on the DownFlow test.",
			Category -> "Test Results"
		}
	}
}];