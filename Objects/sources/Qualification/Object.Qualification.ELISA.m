(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Qualification,ELISA],{
	Description -> "A protocol that verifies the functionality of the liquid handler target for ELISA.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		QualificationKey -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The qualification object ID converted to a all-lower-case format.",
			Category -> "General",
			Developer -> True
		},
		WashingBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample],
				Model[Container],
				Object[Container]
			],
			Description -> "Samples used to wash off Qualification sample for plate washer testing.",
			Category -> "General"
		},
		Tips -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "Pipetting tips loaded onto the ELISA NIMBUS.",
			Category -> "General"
		},

		DeckPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container] | Object[Sample] | Object[Item], Null},
			Description -> "A list of rack and holder placements to set up the ELISA NIMBUS instrument deck slots.",
			Category -> "General",
			Headers -> {"Container", "Placement Tree"}
		},
		VesselRackPlacements -> {
			Format -> Multiple,
			Class -> {Link,Link,Expression},
			Pattern :> {_Link,_Link,LocationPositionP},
			Relation -> {(Object[Container]|Model[Container]|Object[Sample]|Model[Sample]|Model[Item]|Object[Item]),(Object[Container]|Model[Container]),Null},
			Description -> "List of placements of containers into automation-friendly vial racks and plate holders.",
			Category -> "General",
			Headers -> {"Object to Place","Destination Object","Destination Position"}
		},

		BufferContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container] | Object[Sample] | Model[Sample], Null},
			Description -> "A list of deck placements used for placing buffers needed to run the protocol onto the instrument buffer deck.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},
		ActiveTubeCarriers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Rack],
			Description -> "A list of tube racks on the liquid handler deck that are loaded with tubes and used in this protocol.",
			Category -> "Placements",
			Developer -> True
		},



		(* Sample Preparation for Incubator-shaker, washer, and pipetting testing*)
		ELISAPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern:>ELISAPrimitivesP,
			Description -> "The primitives used by the ELISA NIMBUS to generate the test samples.",
			Category -> "General"
		},
		MethodFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path of the folder containing the protocol file which contains the run parameters.",
			Category -> "General",
			Developer -> True
		},
		MethodFile->{
			Format->Single,
			Class->Link,
			Pattern :> _Link,
			Relation->Object[EmeraldCloudFile],
			Description->"The json file containing the run information generated for the qualification run.",
			Category->"Experimental Results"
		},
		ELISALiquidHandlingLog -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The instrumentation trace file that monitored and recorded the execution of this robotic liquid handling by the ELISA Instrument.",
			Category -> "General"
		},
		ELISALiquidHandlingLogPath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path of the instrumentation trace file that monitored and recorded the execution of this robotic liquid handling by the ELISA Instrument.",
			Category -> "General",
			Developer -> True
		},


		(*Plate Reader testing*)
		AbsorbanceQualificationPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample],
				Model[Container],
				Object[Container]
			],
			Description -> "Samples with known expected results that are run on the target instrument to test UV-Vis capabilities.",
			Category -> "Absorbance Accuracy Test"
		},
		AbsorbanceQualificationDataFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path of the folder containing the verification data file generated at the conclusion of the experiment.",
			Category -> "Absorbance Accuracy Test",
			Developer -> True
		},
		AbsorbanceQualificationDataFileNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The names of the data file generated at the conclusion of the experiment.",
			Category -> "Absorbance Accuracy Test",
			Developer -> True
		},
		AbsorbanceQualificationDataFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The txt files containing the verification report summary generated at the conclusion of the experiment.",
			Category -> "Absorbance Accuracy Test"
		},
		AbsorbanceQualificationData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Qualifications],
			Description -> "The Data objects generated by the ELISA plate reader.",
			Category -> "Absorbance Accuracy Test"
		},



		(*Pipetting testing*)
		LiquidHandlingQualificationVessels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample]|Model[Sample]|Object[Container]|Model[Container],
			Description -> "Samples for which volume is measured by weighing the sample and calculating the volume based on its weight and known density.",
			Category -> "Volume Measurement"
		},
		(*Shaker-Incubator testing*)

		ShakerIncubatorQualificationPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "Microplate used to qualify ELISA NIMBUS bottom Shaker-Incubator.",
			Category -> "Shaker Incubator Test"
		},
		SecondaryShakerIncubatorQualificationPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "Microplate used to qualify ELISA NIMBUS top Shaker-Incubators.",
			Category -> "Shaker Incubator Test"
		},
		SamplePreparationUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The macro liquid-handling primitives used by sample manipulation to generate the test samples for shaker-incubator testing.",
			Category -> "Shaker Incubator Test"
		},
		SamplePreparationProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "The sample manipulation protocol that was used to generate the test samples for shaker-incubator testing.",
			Category -> "Shaker Incubator Test"
		},
		FullyDissolved -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if all components in the solution appear fully dissolved by visual inspection.",
			Category -> "Shaker Incubator Test"
		},



		(*Washer testing*)
		WasherQualificationPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample],
				Model[Container],
				Object[Container]
			],
			Description -> "Microplate to test the washing capabilities of the ELISA NIMBUS plate washer.",
			Category -> "Plate Washer Test"
		},
		Balance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The balance instrument used to weigh the WasherQualificationPlate before and after wash.",
			Category -> "Plate Washer Test"
		},
		WasherQualificationPlatePreWashWeight -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The data object containing the weight of the plate that is going to be used qualify the ELISA NIMBUS plate washer.",
			Category -> "Plate Washer Test"
		},
		WasherQualificationPlatePostWashWeight -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The data object containing the weight of the plate that has been used qualify the ELISA NIMBUS plate washer.",
			Category -> "Plate Washer Test"
		},
		FullyWashed -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if all of the wells in the plate is free of any unwashed dye by visual inspection.",
			Category -> "Plate Washer Test"
		}
	}
}
];