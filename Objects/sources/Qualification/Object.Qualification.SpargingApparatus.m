(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,SpargingApparatus], {
	Description->"A protocol that verifies the functionality of the sparging apparatus target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		SamplePreparationProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,RoboticSamplePreparation]|Object[Protocol,ManualSamplePreparation],
			Description -> "The sample manipulation protocol used to generate the test samples.",
			Category -> "Sample Preparation"
		},
		DissolvedOxygenMeter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The instrument used to  measure the dissolved oxygen concentration of the qualification sample.",
			Category -> "General",
			Abstract -> True
		},
		InitialDissolvedOxygen->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,MeasureDissolvedOxygen],
			Description->"The MeasureDissolvedOxygen protocol generated as a result of the execution of MeasureDissolvedOxygen, which is used to determine the initial dissolved oxygen reading of the sample.",
			Category -> "General"
		},
		FinalDissolvedOxygen->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,MeasureDissolvedOxygen],
			Description->"The MeasureDissolvedOxygen protocol generated as a result of the execution of MeasureDissolvedOxygen, which is used to determine the final dissolved oxygen reading of the sample.",
			Category -> "General"
		},
		InitialDissolvedOxygenConcentration ->  {
			Format -> Single,
			Class -> Expression,
			Pattern :> (DistributionP[Percent]|DistributionP[Milligram/Liter]),
			Description -> "The measured dissolved oxygen of the qualification sample before the sparging degassing.",
			Category -> "Experimental Results"
		},
		FinalDissolvedOxygenConcentration ->  {
			Format -> Single,
			Class -> Expression,
			Pattern :> (DistributionP[Percent]|DistributionP[Milligram/Liter]),
			Description -> "The measured dissolved oxygen of the qualification sample after the sparging degassing.",
			Category -> "Experimental Results"
		},
		ArgonPressureLog -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Qualifications],
			Description -> "The pressure log for the argon gas of the schlenk line during the run, if used in the experiment.",
			Category -> "General"
		},
		NitrogenPressureLog -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Qualifications],
			Description -> "The pressure log for the nitrogen gas of the schlenk line during the run, if used in the experiment.",
			Category -> "General"
		},
		HeliumPressureLog -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Qualifications],
			Description -> "The pressure log for the helium gas of the schlenk line during the run, if used in the experiment.",
			Category -> "General"
		},
		ChannelAGasPressure -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Qualifications],
			Description -> "The pressure data of the gas out of channel A of the schlenk line during the run, if used in the experiment.",
			Category -> "Sensor Information"
		},
		ChannelBGasPressure -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Qualifications],
			Description -> "The pressure data of the gas out of channel B of the schlenk line during the run, if used in the experiment.",
			Category -> "Sensor Information"
		},
		VacuumSensorPressure -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Qualifications],
			Description -> "The pressure data of the vacuum sensor connected to the schlenk line during the run, if used in the experiment.",
			Category -> "Sensor Information"
		},
		WasteContainer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Container,Vessel],
				Object[Container,Vessel]
			],
			Description->"The vessel used to collect waste liquid during the procedure.",
			Category->"General",
			Developer->True
		}
	}
}];
