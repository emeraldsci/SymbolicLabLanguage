(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification, CrossFlowFiltration], {
	Description->"A protocol that verifies the functionality of the cross flow filtration instrument target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* ----- Samples and Consumables ----- *)

		CalibrationWeights->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Item,CalibrationWeight],
				Object[Item,CalibrationWeight]
			],
			Description->"The calibration weights used to qualify the balance.",
			Category -> "General"
		},

		WeightHandles->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Item,WeightHandle],
				Model[Item,Tweezer],
				Object[Item,WeightHandle],
				Object[Item,Tweezer]
			],
			IndexMatching->CalibrationWeights,
			Description->"For each member of CalibrationWeights, the weight tweezers/forks/handle used to pick up and move the weight to/from the balance.",
			Category -> "General"
		},

		FolderPath->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The directory where the files are to be saved during the experiment.",
			Category->"Data Processing",
			Developer->True
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
		},

		Fitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Plumbing,Fitting],
				Object[Plumbing,Fitting]
			],
			Description->"The fitting used to attach the syringe to the conductivity sensor.",
			Category->"General",
			Developer->True
		},

		RinseSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description->"The solution used to wash the conductivity sensor between calibration solutions.",
			Category->"General",
			Developer->True
		},

		DataFiles->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"The data files containing the results of the cross-flow filtration experiment.",
			Category->"Data Processing"
		},

		(* ---------- CrossFlow qual sample prep ---------- *)

		SamplePreparationProtocol->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,RoboticSamplePreparation]|Object[Protocol,ManualSamplePreparation],
			Description->"The sample manipulation protocol used to generate the test samples.",
			Category->"Sample Preparation"
		},

		CrossFlowFiltrationSample->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample]
			],
			Description->"The sample prepared as part of PreparatoryUnitOperations of the CrossFlowFiltration qualification.",
			Category->"Sample Preparation"
		},

		CrossFlowFiltrationControl->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample]
			],
			Description->"The an aliquot of the sample prepared for the CrossFlowFiltration qualification and used as a reference in subsequent analyses.",
			Category->"Sample Preparation"
		},

		MeasureDensityProtocol->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol,MeasureDensity]],
			Description->"The density measurement protocol of the sample before filtering.",
			Category -> "Sample Preparation"
		},

		(* ---------- Post CrossFlow analyses ---------- *)

		CrossFlowFiltrationProtocol->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Protocol, CrossFlowFiltration]
			],
			Description->"The Experiment protocol object used to concentrate and diafiltrate samples.",
			Category->"General"
		},

		MeasureConductivityProtocol->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Protocol, MeasureConductivity]
			],
			Description->"The Experiment protocol object used to measure qualification sample conductivity.",
			Category->"Data Processing"
		},

		AbsorbanceIntensityProtocol->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Protocol, AbsorbanceIntensity],
				Object[Protocol, ManualSamplePreparation]
			],
			Description->"The Experiment protocol object used to measure qualification sample absorbance.",
			Category->"Data Processing"
		},

		AbsorbanceSamplePreparationUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The sample preparation primitives to be evaluated by the absorbance subprotocol.",
			Category -> "Data Processing"
		},

		(* Two validation results we collected during the qualification procedures *)
		FeedValidationResults->{
			Format-> Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0],
			Units->None,
			Description->"The calibration weight results of the \"Feed Weighing Balance\" during this maintenance.",
			Category->"Sample Loading"
		},
		DiafiltrationValidationResults->{
			Format-> Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0],
			Units->None,
			Description->"The calibration weight results of the \"Diafiltraiton Weighing Balance\" during this maintenance.",
			Category->"Sample Loading"
		},
		CalibrationWeightFeedPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Item]|Model[Item], Object[Instrument], Null},
			Description -> "The information that guide operator to put CalibrationWeights to the Feed Weighing Balance of the Instrument.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		CalibrationWeightDiafiltrationPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Item]|Model[Item], Object[Instrument], Null},
			Description -> "The information that guide operator to put CalibrationWeights to the Diafiltration Weighing Balance of the Instrument.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		}
	}
}];
