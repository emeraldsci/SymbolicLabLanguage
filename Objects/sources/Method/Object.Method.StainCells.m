(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Method,StainCells],{
	Description->"A series of stains, mordants, decolorizers, and counter stains that will be added to cell samples to color them for microscopy and quantification.",
	CreatePrivileges->None,
	Cache->Session,
	Fields-> {

		Synonyms -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "List of possible alternative names this method goes by.",
			Category -> "Organizational Information",
			Abstract -> True
		},

		(* ------Staining------ *)

		Stain -> {
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"The chemical reagents or stock solutions added to a cell sample to color the cells.",
			Category->"Stain Preparation"
		},
		StainVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milliliter],
			Units->Milliliter,
			Description->"For each member of Stain, the volume of the Stain to add to the cells to color them.",
			Category->"Stain Preparation",
			IndexMatching -> Stain
		},
		StainConcentration -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[0*Molar], GreaterEqualP[0*Gram/Liter], GreaterEqualP[0*VolumePercent], GreaterEqualP[0*MassPercent]],
			Units -> None,
			Description -> "For each member of Stain, the final concentration of the StainAnalyte in the cell suspension after dilution of the Stain in the media cells are suspended in.",
			Category -> "Stain Preparation",
			IndexMatching -> Stain
		},
		StainAnalyte -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> IdentityModelTypeP,
			Description->"For each member of Stain, the active substance of interest which causes staining and whose concentration in the final cell and stain mixture is specified by the StainConcentration option.",
			Category->"Stain Preparation",
			IndexMatching -> Stain
		},
		StainStorageCondition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Disposal,
			Description->"For each member of Stain, the non-default condition under which each Stain should be stored after the protocol is completed.",
			Category->"Sample Storage",
			IndexMatching -> Stain
		},

		StainSourceTemperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Kelvin],
			Units -> Celsius,
			Description -> "For each member of Stain, the desired temperature of the Stain prior to transferring to the cell sample.",
			Category -> "Stain Preparation",
			IndexMatching -> Stain
		},
		StainSourceEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "For each member of Stain, the minimum duration of time for which the Stain is heated/cooled to the target StainSourceTemperature.",
			Category->"Stain Preparation",
			IndexMatching -> Stain
		},
		MaxStainSourceEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description->"For each member of Stain, the maximum duration of time for which the Stain is heated/cooled to the target StainSourceTemperature, if it does not reach the StainSourceTemperature after StainSourceEquilibrationTime.",
			Category->"Stain Preparation",
			IndexMatching -> Stain
		},
		StainSourceEquilibrationCheck -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> EquilibrationCheckP,
			Description->"For each member of Stain, the method used to verify the temperature of the Stain before the transfer is performed.",
			Category->"Stain Preparation",
			IndexMatching -> Stain
		},

		StainDestinationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The desired temperature of the cells prior to transferring the Stain.",
			Category -> "Stain Preparation"
		},
		StainDestinationEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "The minimum duration of time for which the cell sample is heated/cooled to the target StainDestinationTemperature.",
			Category->"Stain Preparation"
		},
		MaxStainDestinationEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description->"The maximum duration of time for which the cell sample is heated/cooled to the target StainDestinationTemperature, if the sample does not reach the StainDestinationTemperature after StainDestinationEquilibrationTime.",
			Category->"Stain Preparation"
		},
		StainDestinationEquilibrationCheck -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> EquilibrationCheckP,
			Description->"The method by which to verify the temperature of the cell sample before adding the Stain.",
			Category->"Stain Preparation"
		},

		StainMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the cell sample should be mixed after adding the Stain.",
			Category->"Staining"
		},
		StainMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CellMixTypeP,
			Description -> "Indicates the style of motion used to mix the sample with the Stain.",
			Category->"Staining"
		},
		StainMixInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The instrument used to perform the StainMix.",
			Category->"Staining"
		},
		StainTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "Duration of time for which the sample is incubated after adding the Stain.",
			Category->"Staining"
		},
		StainMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * RPM],
			Units -> RPM,
			Description -> "Frequency of rotation the StainMixInstrument should use to mix the sample after adding the Stain.",
			Category->"Staining"
		},
		StainMixRateProfile -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _List,
			Description -> "The frequency of rotation the StainMixInstrument should use to mix the sample, over the course of time.",
			Category -> "Staining"
		},
		StainNumberOfMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "Number of times the sample should be mixed if StainMixType is Pipette or Invert.",
			Category -> "Staining"
		},
		StainMixVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milliliter],
			Units->Milliliter,
			Description -> "The volume of the sample that should be pipetted up and down to mix if StainMixType is Pipette.",
			Category -> "Staining"
		},
		StainTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The temperature of the device at which to hold the cell sample after adding the Stain.",
			Category -> "Staining"
		},
		StainTemperatureProfile -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _List,
			Description -> "The temperature of the device, over the course of time, that should be used to incubate the sample after adding the Stain.",
			Category -> "Staining"
		},
		StainAnnealingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description->"Minimum duration for which the cell sample should remain in the incubator allowing the system to settle to room temperature after the StainTime has passed.",
			Category->"Staining"
		},
		StainResidualIncubation -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description->"Indicates if the incubation should continue after StainTime has finished while waiting to progress to the next step in the protocol.",
			Category->"Staining"
		},

		(* Stain Washing *)
		StainWash -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Units -> None,
			Description -> "Indicates if cell sample should be washed after incubation and mixing with the Stain.",
			Category -> "Stain Washing"
		},
		NumberOfStainWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "The number of times that the cell sample should be washed with StainWashSolution.",
			Category -> "Stain Washing"
		},
		StainWashType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Pellet|Adherent|Null],
			Description -> "The method by which the cell sample should be washed.",
			Category->"Stain Washing"
		},
		StainWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The solution that is used to wash the cell sample after incubation with the Stain.",
			Category->"Stain Washing"
		},
		StainWashSolutionContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The unique container of StainWashSolution that will be used during this batch of cell washing.",
			Category->"Stain Washing"
		},
		StainWashContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The container that the cells will be placed in when they are washed.",
			Category->"Stain Washing"
		},
		StainWashSolutionPipette -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, Pipette],
				Object[Instrument, Pipette]
			],
			Description -> "The pipette that will be used to transfer the StainWashSolution into the StainWashContainer.",
			Category->"Stain Washing"
		},
		StainWashSolutionTips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Tips],
				Object[Item, Tips]
			],
			Description -> "The tips used to transfer the StainWashSolution into the StainWashContainer.",
			Category->"Stain Washing"
		},
		StainWashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The amount of StainWashSolution that is added to the StainWashContainer when the cells are washed.",
			Category->"Stain Washing"
		},

		StainWashSolutionTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature to heat/cool the StainWashSolution to before the washing occurs.",
			Category->"Stain Washing"
		},
		StainWashSolutionEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The duration of time for which the wash solution will be heated/cooled to the target StainWashSolutionTemperature.",
			Category->"Stain Washing"
		},
		MaxStainWashSolutionEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The maximum duration of time for which the StainWashSolution will be heated/cooled to the target StainWashSolutionTemperature, if they do not reach the StainWashSolutionTemperature after StainWashSolutionEquilibrationTime.",
			Category->"Stain Washing"
		},
		StainWashSolutionEquilibrationCheck -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> EquilibrationCheckP,
			Description -> "The method by which to verify the temperature of the StainWashSolution before the transfer is performed.",
			Category->"Stain Washing"
		},



		StainWashSolutionAspirationMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if mixing should occur during aspiration from the StainWashSolution.",
			Category->"Stain Washing"
		},
		StainWashSolutionAspirationMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Swirl|Pipette,
			Description -> "The type of mixing that should occur during aspiration from the StainWashSolution.",
			Category->"Stain Washing"
		},
		NumberOfStainWashSolutionAspirationMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of times that the StainWashSolution should be mixed during aspiration.",
			Category->"Stain Washing"
		},
		StainWashSolutionDispenseMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if mixing should occur after the cells are dispensed into the StainWashSolution.",
			Category->"Stain Washing"
		},
		StainWashSolutionDispenseMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Swirl|Pipette,
			Description -> "The type of mixing that should occur after the cells are dispensed into the StainWashSolution.",
			Category->"Stain Washing"
		},
		NumberOfStainWashSolutionDispenseMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of times that the cell/StainWashSolution suspension should be mixed after dispension.",
			Category->"Stain Washing"
		},
		StainWashSolutionIncubation -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the cells should be incubated and/or mixed after the StainWashSolution is added.",
			Category->"Stain Washing"
		},
		StainWashSolutionIncubationInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,Shaker],
				Object[Instrument,Shaker],
				Model[Instrument,HeatBlock],
				Object[Instrument,HeatBlock]
			],
			Description -> "The instrument used to perform the Mixing and/or Incubation of the cell sample/StainWashSolution mixture.",
			Category->"Stain Washing"
		},
		StainWashSolutionIncubationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The amount of time that the cells should be incubated/mixed with the StainWashSolution.",
			Category->"Stain Washing"
		},
		StainWashSolutionIncubationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Celsius],
			Units -> Celsius,
			Description -> "The temperature of the mix instrument while mixing/incubating the cells with the StainWashSolution.",
			Category->"Stain Washing"
		},
		StainWashSolutionMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the cells and StainWashSolution should be mixed during StainWashSolutionIncubation.",
			Category->"Stain Washing"
		},
		StainWashSolutionMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Shake],
			Description -> "Indicates the style of motion used to mix the sample.",
			Category->"Stain Washing"
		},
		StainWashSolutionMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The frequency of rotation of the mixing instrument should use to mix the cells/StainWashSolution.",
			Category->"Stain Washing"
		},

		StainWashPellet -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the cells and StainWashSolution should be centrifuged to create a pellet after StainWashSolutionIncubation to be able to safely aspirate the StainWashSolution from the cells.",
			Category->"Stain Washing"
		},
		StainWashPelletInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,Centrifuge],
				Object[Instrument,Centrifuge]
			],
			Description->"The centrifuge that will be used to spin the cell sample with StainWashSolution added to it after StainWashSolutionIncubation.",
			Category->"Stain Washing"
		},
		StainWashPelletIntensity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description->"The rotational speed or the force that will be applied to the cell sample with StainWashSolution by centrifugation in order to create a pellet.",
			Category->"Stain Washing"
		},
		StainWashPelletTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The amount of time that the cell sample with StainWashSolution will be centrifuged to create a pellet.",
			Category->"Stain Washing"
		},
		StainWashPelletTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the centrifuge chamber will be held while the cell sample with StainWashSolution is being centrifuged.",
			Category->"Stain Washing"
		},
		StainWashPelletSupernatantVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The amount of supernatant that will be aspirated from the cell sample with StainWashSolution after centrifugation created a cell pellet.",
			Category->"Stain Washing"
		},
		StainWashPelletSupernatantDestination -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description->"The container that the supernatant is dispensed into after aspiration from the pelleted cell sample. If the supernatant will not be used for further experimentation, the destination is set to Waste.",
			Category->"Stain Washing"
		},
		StainWashPelletSupernatantTransferInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,Pipette],
				Object[Instrument,Pipette]
			],
			Description->"The pipette that will be used to transfer off the supernatant (StainWashSolution and Stain) from the pelleted cell sample.",
			Category->"Stain Washing"
		},






		(* ------Mordanting------ *)

		Mordant -> {
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"The chemical reagents or stock solutions added to a cell sample to aid in fixing the Stain to the cell sample.",
			Category->"Mordant Preparation"
		},
		MordantVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milliliter],
			Units->Milliliter,
			Description->"For each member of Mordant, the volume of the Mordant to add to the cells to aid in staining them.",
			Category->"Mordant Preparation",
			IndexMatching -> Mordant
		},
		MordantConcentration -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[0*Molar], GreaterEqualP[0*Gram/Liter], GreaterEqualP[0*VolumePercent], GreaterEqualP[0*MassPercent]],
			Units -> None,
			Description -> "For each member of Mordant, the final concentration of the MordantAnalyte in the cell suspension after dilution of the Mordant in the media cells are suspended in.",
			Category -> "Mordant Preparation",
			IndexMatching -> Mordant
		},
		MordantAnalyte -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> IdentityModelTypeP,
			Description->"For each member of Mordant, the active substance of interest which causes staining and whose concentration in the final cell and stain mixture is specified by the MordantConcentration option.",
			Category->"Mordant Preparation",
			IndexMatching -> Mordant
		},
		MordantStorageCondition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Disposal,
			Description->"For each member of Mordant, the non-default condition under which each Mordant should be stored after the protocol is completed.",
			Category->"Sample Storage",
			IndexMatching -> Mordant
		},

		MordantSourceTemperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Kelvin],
			Units -> Celsius,
			Description -> "For each member of Mordant, the desired temperature of the Mordant prior to transferring to the cell sample.",
			Category -> "Mordant Preparation",
			IndexMatching -> Mordant
		},
		MordantSourceEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "For each member of Mordant, the minimum duration of time for which the Mordant is heated/cooled to the target MordantSourceTemperature.",
			Category->"Mordant Preparation",
			IndexMatching -> Mordant
		},
		MaxMordantSourceEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description->"For each member of Mordant, the maximum duration of time for which the Mordant is heated/cooled to the target MordantSourceTemperature, if it does not reach the MordantSourceTemperature after MordantSourceEquilibrationTime.",
			Category->"Mordant Preparation",
			IndexMatching -> Mordant
		},
		MordantSourceEquilibrationCheck -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> EquilibrationCheckP,
			Description->"For each member of Mordant, the method used to verify the temperature of the Mordant before the transfer is performed.",
			Category->"Mordant Preparation",
			IndexMatching -> Mordant
		},

		MordantDestinationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The desired temperature of the cells prior to transferring the Mordant.",
			Category -> "Mordant Preparation"
		},
		MordantDestinationEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "The minimum duration of time for which the cell sample is heated/cooled to the target MordantDestinationTemperature.",
			Category->"Mordant Preparation"
		},
		MaxMordantDestinationEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description->"The maximum duration of time for which the cell sample is heated/cooled to the target MordantDestinationTemperature, if the sample does not reach the MordantDestinationTemperature after MordantDestinationEquilibrationTime.",
			Category->"Mordant Preparation"
		},
		MordantDestinationEquilibrationCheck -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> EquilibrationCheckP,
			Description->"The method by which to verify the temperature of the cell sample before adding the Mordant.",
			Category->"Mordant Preparation"
		},

		MordantMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the cell sample should be mixed after adding the Mordant.",
			Category->"Mordanting"
		},
		MordantMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CellMixTypeP,
			Description -> "Indicates the style of motion used to mix the sample with the Mordant.",
			Category->"Mordanting"
		},
		MordantMixInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The instrument used to perform the MordantMix.",
			Category->"Mordanting"
		},
		MordantTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "Duration of time for which the sample is incubated after adding the Mordant.",
			Category->"Mordanting"
		},
		MordantMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * RPM],
			Units -> RPM,
			Description -> "Frequency of rotation the MordantMixInstrument should use to mix the sample after adding the Mordant.",
			Category->"Mordanting"
		},
		MordantMixRateProfile -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _List,
			Description -> "The frequency of rotation the MordantMixInstrument should use to mix the sample, over the course of time.",
			Category -> "Mordanting"
		},
		MordantNumberOfMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "Number of times the sample should be mixed if MordantMixType is Pipette or Invert.",
			Category -> "Mordanting"
		},
		MordantMixVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milliliter],
			Units->Milliliter,
			Description -> "The volume of the sample that should be pipetted up and down to mix if MordantMixType is Pipette.",
			Category -> "Mordanting"
		},
		MordantTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The temperature of the device at which to hold the cell sample after adding the Mordant.",
			Category -> "Mordanting"
		},
		MordantTemperatureProfile -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _List,
			Description -> "The temperature of the device, over the course of time, that should be used to incubate the sample after adding the Mordant.",
			Category -> "Mordanting"
		},
		MordantAnnealingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description->"Minimum duration for which the cell sample should remain in the incubator allowing the system to settle to room temperature after the MordantTime has passed.",
			Category->"Mordanting"
		},
		MordantResidualIncubation -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description->"Indicates if the incubation should continue after MordantTime has finished while waiting to progress to the next step in the protocol.",
			Category->"Mordanting"
		},

		(* Mordant Washing *)
		MordantWash -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Units -> None,
			Description -> "Indicates if cell sample should be washed after incubation and mixing with the Mordant.",
			Category -> "Mordant Washing"
		},
		NumberOfMordantWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "The number of times that the cell sample should be washed with MordantWashSolution.",
			Category -> "Mordant Washing"
		},
		MordantWashType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Pellet|Adherent|Null],
			Description -> "The method by which the cell sample should be washed.",
			Category->"Mordant Washing"
		},
		MordantWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The solution that is used to wash the cell sample after incubation with the Mordant.",
			Category->"Mordant Washing"
		},
		MordantWashSolutionContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The unique container of MordantWashSolution that will be used during this batch of cell washing.",
			Category->"Mordant Washing"
		},
		MordantWashContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The container that the cells will be placed in when they are washed.",
			Category->"Mordant Washing"
		},
		MordantWashSolutionPipette -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, Pipette],
				Object[Instrument, Pipette]
			],
			Description -> "The pipette that will be used to transfer the MordantWashSolution into the MordantWashContainer.",
			Category->"Mordant Washing"
		},
		MordantWashSolutionTips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Tips],
				Object[Item, Tips]
			],
			Description -> "The tips used to transfer the MordantWashSolution into the MordantWashContainer.",
			Category->"Mordant Washing"
		},
		MordantWashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The amount of MordantWashSolution that is added to the MordantWashContainer when the cells are washed.",
			Category->"Mordant Washing"
		},

		MordantWashSolutionTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature to heat/cool the MordantWashSolution to before the washing occurs.",
			Category->"Mordant Washing"
		},
		MordantWashSolutionEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The duration of time for which the wash solution will be heated/cooled to the target MordantWashSolutionTemperature.",
			Category->"Mordant Washing"
		},
		MaxMordantWashSolutionEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The maximum duration of time for which the MordantWashSolution will be heated/cooled to the target MordantWashSolutionTemperature, if they do not reach the MordantWashSolutionTemperature after MordantWashSolutionEquilibrationTime.",
			Category->"Mordant Washing"
		},
		MordantWashSolutionEquilibrationCheck -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> EquilibrationCheckP,
			Description -> "The method by which to verify the temperature of the MordantWashSolution before the transfer is performed.",
			Category->"Mordant Washing"
		},

		MordantWashSolutionAspirationMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if mixing should occur during aspiration from the MordantWashSolution.",
			Category->"Mordant Washing"
		},
		MordantWashSolutionAspirationMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Swirl|Pipette,
			Description -> "The type of mixing that should occur during aspiration from the MordantWashSolution.",
			Category->"Mordant Washing"
		},
		NumberOfMordantWashSolutionAspirationMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of times that the MordantWashSolution should be mixed during aspiration.",
			Category->"Mordant Washing"
		},
		MordantWashSolutionDispenseMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if mixing should occur after the cells are dispensed into the MordantWashSolution.",
			Category->"Mordant Washing"
		},
		MordantWashSolutionDispenseMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Swirl|Pipette,
			Description -> "The type of mixing that should occur after the cells are dispensed into the MordantWashSolution.",
			Category->"Mordant Washing"
		},
		NumberOfMordantWashSolutionDispenseMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of times that the cell/MordantWashSolution suspension should be mixed after dispension.",
			Category->"Mordant Washing"
		},
		MordantWashSolutionIncubation -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the cells should be incubated and/or mixed after the MordantWashSolution is added.",
			Category->"Mordant Washing"
		},
		MordantWashSolutionIncubationInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,Shaker],
				Object[Instrument,Shaker],
				Model[Instrument,HeatBlock],
				Object[Instrument,HeatBlock]
			],
			Description -> "The instrument used to perform the Mixing and/or Incubation of the cell sample/MordantWashSolution mixture.",
			Category->"Mordant Washing"
		},
		MordantWashSolutionIncubationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The amount of time that the cells should be incubated/mixed with the MordantWashSolution.",
			Category->"Mordant Washing"
		},
		MordantWashSolutionIncubationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Celsius],
			Units -> Celsius,
			Description -> "The temperature of the mix instrument while mixing/incubating the cells with the MordantWashSolution.",
			Category->"Mordant Washing"
		},
		MordantWashSolutionMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the cells and MordantWashSolution should be mixed during MordantWashSolutionIncubation.",
			Category->"Mordant Washing"
		},
		MordantWashSolutionMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Shake],
			Description -> "Indicates the style of motion used to mix the sample.",
			Category->"Mordant Washing"
		},
		MordantWashSolutionMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The frequency of rotation of the mixing instrument should use to mix the cells/MordantWashSolution.",
			Category->"Mordant Washing"
		},

		MordantWashPellet -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the cells and MordantWashSolution should be centrifuged to create a pellet after MordantWashSolutionIncubation to be able to safely aspirate the MordantWashSolution from the cells.",
			Category->"Mordant Washing"
		},
		MordantWashPelletInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,Centrifuge],
				Object[Instrument,Centrifuge]
			],
			Description->"The centrifuge that will be used to spin the cell sample with MordantWashSolution added to it after MordantWashSolutionIncubation.",
			Category->"Mordant Washing"
		},
		MordantWashPelletIntensity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description->"The rotational speed or the force that will be applied to the cell sample with MordantWashSolution by centrifugation in order to create a pellet.",
			Category->"Mordant Washing"
		},
		MordantWashPelletTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The amount of time that the cell sample with MordantWashSolution will be centrifuged to create a pellet.",
			Category->"Mordant Washing"
		},
		MordantWashPelletTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the centrifuge chamber will be held while the cell sample with MordantWashSolution is being centrifuged.",
			Category->"Mordant Washing"
		},
		MordantWashPelletSupernatantVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The amount of supernatant that will be aspirated from the cell sample with MordantWashSolution after centrifugation created a cell pellet.",
			Category->"Mordant Washing"
		},
		MordantWashPelletSupernatantDestination -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description->"The container that the supernatant is dispensed into after aspiration from the pelleted cell sample. If the supernatant will not be used for further experimentation, the destination is set to Waste.",
			Category->"Mordant Washing"
		},
		MordantWashPelletSupernatantTransferInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,Pipette],
				Object[Instrument,Pipette]
			],
			Description->"The pipette that will be used to transfer off the supernatant (MordantWashSolution and Mordant) from the pelleted cell sample.",
			Category->"Mordant Washing"
		},






		(* ------Decolorizer------ *)
		Decolorizer -> {
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"The chemical reagents or stock solutions added to cells to remove excess Stain.",
			Category->"Decolorizer Preparation"
		},
		DecolorizerVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milliliter],
			Units->Milliliter,
			Description->"For each member of Decolorizer, the volume of the Decolorizer to add to the cells to remove excess Stain.",
			Category->"Decolorizer Preparation",
			IndexMatching -> Decolorizer
		},
		DecolorizerConcentration -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[0*Molar], GreaterEqualP[0*Gram/Liter], GreaterEqualP[0*VolumePercent], GreaterEqualP[0*MassPercent]],
			Units -> None,
			Description -> "For each member of Decolorizer, the final concentration of the DecolorizerAnalyte in the cell suspension after dilution of the Decolorizer in the media cells are suspended in.",
			Category -> "Decolorizer Preparation",
			IndexMatching -> Decolorizer
		},
		DecolorizerAnalyte -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> IdentityModelTypeP,
			Description->"For each member of Decolorizer, the active substance of interest which causes staining and whose concentration in the final cell and stain mixture is specified by the DecolorizerConcentration option.",
			Category->"Decolorizer Preparation",
			IndexMatching -> Decolorizer
		},
		DecolorizerStorageCondition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Disposal,
			Description->"For each member of Decolorizer, the non-default condition under which each Decolorizer should be stored after the protocol is completed.",
			Category->"Sample Storage",
			IndexMatching -> Decolorizer
		},

		DecolorizerSourceTemperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Kelvin],
			Units -> Celsius,
			Description -> "For each member of Decolorizer, the desired temperature of the Decolorizer prior to transferring to the cell sample.",
			Category -> "Decolorizer Preparation",
			IndexMatching -> Decolorizer
		},
		DecolorizerSourceEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "For each member of Decolorizer, the minimum duration of time for which the Decolorizer is heated/cooled to the target DecolorizerSourceTemperature.",
			Category->"Decolorizer Preparation",
			IndexMatching -> Decolorizer
		},
		MaxDecolorizerSourceEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description->"For each member of Decolorizer, the maximum duration of time for which the Decolorizer is heated/cooled to the target DecolorizerSourceTemperature, if it does not reach the DecolorizerSourceTemperature after DecolorizerSourceEquilibrationTime.",
			Category->"Decolorizer Preparation",
			IndexMatching -> Decolorizer
		},
		DecolorizerSourceEquilibrationCheck -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> EquilibrationCheckP,
			Description->"For each member of Decolorizer, the method used to verify the temperature of the Decolorizer before the transfer is performed.",
			Category->"Decolorizer Preparation",
			IndexMatching -> Decolorizer
		},

		DecolorizerDestinationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The desired temperature of the cells prior to transferring the Decolorizer.",
			Category -> "Decolorizer Preparation"
		},
		DecolorizerDestinationEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "The minimum duration of time for which the cell sample is heated/cooled to the target DecolorizerDestinationTemperature.",
			Category->"Decolorizer Preparation"
		},
		MaxDecolorizerDestinationEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description->"The maximum duration of time for which the cell sample is heated/cooled to the target DecolorizerDestinationTemperature, if the sample does not reach the DecolorizerDestinationTemperature after DecolorizerDestinationEquilibrationTime.",
			Category->"Decolorizer Preparation"
		},
		DecolorizerDestinationEquilibrationCheck -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> EquilibrationCheckP,
			Description->"The method by which to verify the temperature of the cell sample before adding the Decolorizer.",
			Category->"Decolorizer Preparation"
		},

		DecolorizerMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the cell sample should be mixed after adding the Decolorizer.",
			Category->"Decolorizing"
		},
		DecolorizerMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CellMixTypeP,
			Description -> "Indicates the style of motion used to mix the sample with the Decolorizer.",
			Category->"Decolorizing"
		},
		DecolorizerMixInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The instrument used to perform the DecolorizerMix.",
			Category->"Decolorizing"
		},
		DecolorizerTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "Duration of time for which the sample is incubated after adding the Decolorizer.",
			Category->"Decolorizing"
		},
		DecolorizerMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * RPM],
			Units -> RPM,
			Description -> "Frequency of rotation the DecolorizerMixInstrument should use to mix the sample after adding the Decolorizer.",
			Category->"Decolorizing"
		},
		DecolorizerMixRateProfile -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _List,
			Description -> "The frequency of rotation the DecolorizerMixInstrument should use to mix the sample, over the course of time.",
			Category -> "Decolorizing"
		},
		DecolorizerNumberOfMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "Number of times the sample should be mixed if DecolorizerMixType is Pipette or Invert.",
			Category -> "Decolorizing"
		},
		DecolorizerMixVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milliliter],
			Units->Milliliter,
			Description -> "The volume of the sample that should be pipetted up and down to mix if DecolorizerMixType is Pipette.",
			Category -> "Decolorizing"
		},
		DecolorizerTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The temperature of the device at which to hold the cell sample after adding the Decolorizer.",
			Category -> "Decolorizing"
		},
		DecolorizerTemperatureProfile -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _List,
			Description -> "The temperature of the device, over the course of time, that should be used to incubate the sample after adding the Decolorizer.",
			Category -> "Decolorizing"
		},
		DecolorizerAnnealingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description->"Minimum duration for which the cell sample should remain in the incubator allowing the system to settle to room temperature after the DecolorizerTime has passed.",
			Category->"Decolorizing"
		},
		DecolorizerResidualIncubation -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description->"Indicates if the incubation should continue after DecolorizerTime has finished while waiting to progress to the next step in the protocol.",
			Category->"Decolorizing"
		},

		(* Decolorizer Washing *)
		DecolorizerWash -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Units -> None,
			Description -> "Indicates if cell sample should be washed after incubation and mixing with the Decolorizer.",
			Category -> "Decolorizer Washing"
		},
		NumberOfDecolorizerWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "The number of times that the cell sample should be washed with DecolorizerWashSolution.",
			Category -> "Decolorizer Washing"
		},
		DecolorizerWashType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Pellet|Adherent|Null],
			Description -> "The method by which the cell sample should be washed.",
			Category->"Decolorizer Washing"
		},
		DecolorizerWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The solution that is used to wash the cell sample after incubation with the Decolorizer.",
			Category->"Decolorizer Washing"
		},
		DecolorizerWashSolutionContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The unique container of DecolorizerWashSolution that will be used during this batch of cell washing.",
			Category->"Decolorizer Washing"
		},
		DecolorizerWashContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The container that the cells will be placed in when they are washed.",
			Category->"Decolorizer Washing"
		},
		DecolorizerWashSolutionPipette -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, Pipette],
				Object[Instrument, Pipette]
			],
			Description -> "The pipette that will be used to transfer the DecolorizerWashSolution into the DecolorizerWashContainer.",
			Category->"Decolorizer Washing"
		},
		DecolorizerWashSolutionTips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Tips],
				Object[Item, Tips]
			],
			Description -> "The tips used to transfer the DecolorizerWashSolution into the DecolorizerWashContainer.",
			Category->"Decolorizer Washing"
		},
		DecolorizerWashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The amount of DecolorizerWashSolution that is added to the DecolorizerWashContainer when the cells are washed.",
			Category->"Decolorizer Washing"
		},

		DecolorizerWashSolutionTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature to heat/cool the DecolorizerWashSolution to before the washing occurs.",
			Category->"Decolorizer Washing"
		},
		DecolorizerWashSolutionEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The duration of time for which the wash solution will be heated/cooled to the target DecolorizerWashSolutionTemperature.",
			Category->"Decolorizer Washing"
		},
		MaxDecolorizerWashSolutionEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The maximum duration of time for which the DecolorizerWashSolution will be heated/cooled to the target DecolorizerWashSolutionTemperature, if they do not reach the DecolorizerWashSolutionTemperature after DecolorizerWashSolutionEquilibrationTime.",
			Category->"Decolorizer Washing"
		},
		DecolorizerWashSolutionEquilibrationCheck -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> EquilibrationCheckP,
			Description -> "The method by which to verify the temperature of the DecolorizerWashSolution before the transfer is performed.",
			Category->"Decolorizer Washing"
		},

		DecolorizerWashSolutionAspirationMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if mixing should occur during aspiration from the DecolorizerWashSolution.",
			Category->"Decolorizer Washing"
		},
		DecolorizerWashSolutionAspirationMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Swirl|Pipette,
			Description -> "The type of mixing that should occur during aspiration from the DecolorizerWashSolution.",
			Category->"Decolorizer Washing"
		},
		NumberOfDecolorizerWashSolutionAspirationMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of times that the DecolorizerWashSolution should be mixed during aspiration.",
			Category->"Decolorizer Washing"
		},
		DecolorizerWashSolutionDispenseMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if mixing should occur after the cells are dispensed into the DecolorizerWashSolution.",
			Category->"Decolorizer Washing"
		},
		DecolorizerWashSolutionDispenseMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Swirl|Pipette,
			Description -> "The type of mixing that should occur after the cells are dispensed into the DecolorizerWashSolution.",
			Category->"Decolorizer Washing"
		},
		NumberOfDecolorizerWashSolutionDispenseMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of times that the cell/DecolorizerWashSolution suspension should be mixed after dispension.",
			Category->"Decolorizer Washing"
		},
		DecolorizerWashSolutionIncubation -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the cells should be incubated and/or mixed after the DecolorizerWashSolution is added.",
			Category->"Decolorizer Washing"
		},
		DecolorizerWashSolutionIncubationInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,Shaker],
				Object[Instrument,Shaker],
				Model[Instrument,HeatBlock],
				Object[Instrument,HeatBlock]
			],
			Description -> "The instrument used to perform the Mixing and/or Incubation of the cell sample/DecolorizerWashSolution mixture.",
			Category->"Decolorizer Washing"
		},
		DecolorizerWashSolutionIncubationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The amount of time that the cells should be incubated/mixed with the DecolorizerWashSolution.",
			Category->"Decolorizer Washing"
		},
		DecolorizerWashSolutionIncubationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Celsius],
			Units -> Celsius,
			Description -> "The temperature of the mix instrument while mixing/incubating the cells with the DecolorizerWashSolution.",
			Category->"Decolorizer Washing"
		},
		DecolorizerWashSolutionMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the cells and DecolorizerWashSolution should be mixed during DecolorizerWashSolutionIncubation.",
			Category->"Decolorizer Washing"
		},
		DecolorizerWashSolutionMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Shake],
			Description -> "Indicates the style of motion used to mix the sample.",
			Category->"Decolorizer Washing"
		},
		DecolorizerWashSolutionMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The frequency of rotation of the mixing instrument should use to mix the cells/DecolorizerWashSolution.",
			Category->"Decolorizer Washing"
		},

		DecolorizerWashPellet -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the cells and DecolorizerWashSolution should be centrifuged to create a pellet after DecolorizerWashSolutionIncubation to be able to safely aspirate the DecolorizerWashSolution from the cells.",
			Category->"Decolorizer Washing"
		},
		DecolorizerWashPelletInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,Centrifuge],
				Object[Instrument,Centrifuge]
			],
			Description->"The centrifuge that will be used to spin the cell sample with DecolorizerWashSolution added to it after DecolorizerWashSolutionIncubation.",
			Category->"Decolorizer Washing"
		},
		DecolorizerWashPelletIntensity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description->"The rotational speed or the force that will be applied to the cell sample with DecolorizerWashSolution by centrifugation in order to create a pellet.",
			Category->"Decolorizer Washing"
		},
		DecolorizerWashPelletTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The amount of time that the cell sample with DecolorizerWashSolution will be centrifuged to create a pellet.",
			Category->"Decolorizer Washing"
		},
		DecolorizerWashPelletTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the centrifuge chamber will be held while the cell sample with DecolorizerWashSolution is being centrifuged.",
			Category->"Decolorizer Washing"
		},
		DecolorizerWashPelletSupernatantVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The amount of supernatant that will be aspirated from the cell sample with DecolorizerWashSolution after centrifugation created a cell pellet.",
			Category->"Decolorizer Washing"
		},
		DecolorizerWashPelletSupernatantDestination -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description->"The container that the supernatant is dispensed into after aspiration from the pelleted cell sample. If the supernatant will not be used for further experimentation, the destination is set to Waste.",
			Category->"Decolorizer Washing"
		},
		DecolorizerWashPelletSupernatantTransferInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,Pipette],
				Object[Instrument,Pipette]
			],
			Description->"The pipette that will be used to transfer off the supernatant (DecolorizerWashSolution and Decolorizer) from the pelleted cell sample.",
			Category->"Decolorizer Washing"
		},



		(*-----CounterStain------*)
		CounterStain -> {
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"The chemical reagents or stock solutions with a contrasting color to the principal Stain added to the cells to stain contrasting features in the cells for improved visibility.",
			Category->"CounterStain Preparation"
		},
		CounterStainVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milliliter],
			Units->Milliliter,
			Description->"For each member of CounterStain, the volume of the CounterStain to add to the cells to stain cells in a contrasting color to the Stain.",
			Category->"CounterStain Preparation",
			IndexMatching -> CounterStain
		},
		CounterStainConcentration -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[0*Molar], GreaterEqualP[0*Gram/Liter], GreaterEqualP[0*VolumePercent], GreaterEqualP[0*MassPercent]],
			Units -> None,
			Description -> "For each member of CounterStain, the final concentration of the CounterStainAnalyte in the cell suspension after dilution of the CounterStain in the media cells are suspended in.",
			Category -> "CounterStain Preparation",
			IndexMatching -> CounterStain
		},
		CounterStainAnalyte -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> IdentityModelTypeP,
			Description->"For each member of CounterStain, the active substance of interest which causes staining and whose concentration in the final cell and stain mixture is specified by the CounterStainConcentration option.",
			Category->"CounterStain Preparation",
			IndexMatching -> CounterStain
		},
		CounterStainStorageCondition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Disposal,
			Description->"For each member of CounterStain, the non-default condition under which each CounterStain should be stored after the protocol is completed.",
			Category->"Sample Storage",
			IndexMatching -> CounterStain
		},

		CounterStainSourceTemperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Kelvin],
			Units -> Celsius,
			Description -> "For each member of CounterStain, the desired temperature of the CounterStain prior to transferring to the cell sample.",
			Category -> "CounterStain Preparation",
			IndexMatching -> CounterStain
		},
		CounterStainSourceEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "For each member of CounterStain, the minimum duration of time for which the CounterStain is heated/cooled to the target CounterStainSourceTemperature.",
			Category->"CounterStain Preparation",
			IndexMatching -> CounterStain
		},
		MaxCounterStainSourceEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description->"For each member of CounterStain, the maximum duration of time for which the CounterStain is heated/cooled to the target CounterStainSourceTemperature, if it does not reach the CounterStainSourceTemperature after CounterStainSourceEquilibrationTime.",
			Category->"CounterStain Preparation",
			IndexMatching -> CounterStain
		},
		CounterStainSourceEquilibrationCheck -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> EquilibrationCheckP,
			Description->"For each member of CounterStain, the method used to verify the temperature of the CounterStain before the transfer is performed.",
			Category->"CounterStain Preparation",
			IndexMatching -> CounterStain
		},

		CounterStainDestinationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The desired temperature of the cells prior to transferring the CounterStain.",
			Category -> "CounterStain Preparation"
		},
		CounterStainDestinationEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "The minimum duration of time for which the cell sample is heated/cooled to the target CounterStainDestinationTemperature.",
			Category->"CounterStain Preparation"
		},
		MaxCounterStainDestinationEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description->"The maximum duration of time for which the cell sample is heated/cooled to the target CounterStainDestinationTemperature, if the sample does not reach the CounterStainDestinationTemperature after CounterStainDestinationEquilibrationTime.",
			Category->"CounterStain Preparation"
		},
		CounterStainDestinationEquilibrationCheck -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> EquilibrationCheckP,
			Description->"The method by which to verify the temperature of the cell sample before adding the CounterStain.",
			Category->"CounterStain Preparation"
		},

		CounterStainMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the cell sample should be mixed after adding the CounterStain.",
			Category->"CounterStaining"
		},
		CounterStainMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CellMixTypeP,
			Description -> "Indicates the style of motion used to mix the sample with the CounterStain.",
			Category->"CounterStaining"
		},
		CounterStainMixInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The instrument used to perform the CounterStainMix.",
			Category->"CounterStaining"
		},
		CounterStainTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "Duration of time for which the sample is incubated after adding the CounterStain.",
			Category->"CounterStaining"
		},
		CounterStainMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * RPM],
			Units -> RPM,
			Description -> "Frequency of rotation the CounterStainMixInstrument should use to mix the sample after adding the CounterStain.",
			Category->"CounterStaining"
		},
		CounterStainMixRateProfile -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _List,
			Description -> "The frequency of rotation the CounterStainMixInstrument should use to mix the sample, over the course of time.",
			Category -> "CounterStaining"
		},
		CounterStainNumberOfMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "Number of times the sample should be mixed if CounterStainMixType is Pipette or Invert.",
			Category -> "CounterStaining"
		},
		CounterStainMixVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milliliter],
			Units->Milliliter,
			Description -> "The volume of the sample that should be pipetted up and down to mix if CounterStainMixType is Pipette.",
			Category -> "CounterStaining"
		},
		CounterStainTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The temperature of the device at which to hold the cell sample after adding the CounterStain.",
			Category -> "CounterStaining"
		},
		CounterStainTemperatureProfile -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _List,
			Description -> "The temperature of the device, over the course of time, that should be used to incubate the sample after adding the CounterStain.",
			Category -> "CounterStaining"
		},
		CounterStainAnnealingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description->"Minimum duration for which the cell sample should remain in the incubator allowing the system to settle to room temperature after the CounterStainTime has passed.",
			Category->"CounterStaining"
		},
		CounterStainResidualIncubation -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description->"Indicates if the incubation should continue after CounterStainTime has finished while waiting to progress to the next step in the protocol.",
			Category->"CounterStaining"
		},

		(* CounterStain Washing *)
		CounterStainWash -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Units -> None,
			Description -> "Indicates if cell sample should be washed after incubation and mixing with the CounterStain.",
			Category -> "CounterStain Washing"
		},
		NumberOfCounterStainWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "The number of times that the cell sample should be washed with CounterStainWashSolution.",
			Category -> "CounterStain Washing"
		},
		CounterStainWashType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Pellet|Adherent|Null],
			Description -> "The method by which the cell sample should be washed.",
			Category->"CounterStain Washing"
		},
		CounterStainWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The solution that is used to wash the cell sample after incubation with the CounterStain.",
			Category->"CounterStain Washing"
		},
		CounterStainWashSolutionContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The unique container of CounterStainWashSolution that will be used during this batch of cell washing.",
			Category->"CounterStain Washing"
		},
		CounterStainWashContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The container that the cells will be placed in when they are washed.",
			Category->"CounterStain Washing"
		},
		CounterStainWashSolutionPipette -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, Pipette],
				Object[Instrument, Pipette]
			],
			Description -> "The pipette that will be used to transfer the CounterStainWashSolution into the CounterStainWashContainer.",
			Category->"CounterStain Washing"
		},
		CounterStainWashSolutionTips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Tips],
				Object[Item, Tips]
			],
			Description -> "The tips used to transfer the CounterStainWashSolution into the CounterStainWashContainer.",
			Category->"CounterStain Washing"
		},
		CounterStainWashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The amount of CounterStainWashSolution that is added to the CounterStainWashContainer when the cells are washed.",
			Category->"CounterStain Washing"
		},

		CounterStainWashSolutionTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature to heat/cool the CounterStainWashSolution to before the washing occurs.",
			Category->"CounterStain Washing"
		},
		CounterStainWashSolutionEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The duration of time for which the wash solution will be heated/cooled to the target CounterStainWashSolutionTemperature.",
			Category->"CounterStain Washing"
		},
		MaxCounterStainWashSolutionEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The maximum duration of time for which the CounterStainWashSolution will be heated/cooled to the target CounterStainWashSolutionTemperature, if they do not reach the CounterStainWashSolutionTemperature after CounterStainWashSolutionEquilibrationTime.",
			Category->"CounterStain Washing"
		},
		CounterStainWashSolutionEquilibrationCheck -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> EquilibrationCheckP,
			Description -> "The method by which to verify the temperature of the CounterStainWashSolution before the transfer is performed.",
			Category->"CounterStain Washing"
		},

		CounterStainWashSolutionAspirationMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if mixing should occur during aspiration from the CounterStainWashSolution.",
			Category->"CounterStain Washing"
		},
		CounterStainWashSolutionAspirationMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Swirl|Pipette,
			Description -> "The type of mixing that should occur during aspiration from the CounterStainWashSolution.",
			Category->"CounterStain Washing"
		},
		NumberOfCounterStainWashSolutionAspirationMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of times that the CounterStainWashSolution should be mixed during aspiration.",
			Category->"CounterStain Washing"
		},
		CounterStainWashSolutionDispenseMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if mixing should occur after the cells are dispensed into the CounterStainWashSolution.",
			Category->"CounterStain Washing"
		},
		CounterStainWashSolutionDispenseMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Swirl|Pipette,
			Description -> "The type of mixing that should occur after the cells are dispensed into the CounterStainWashSolution.",
			Category->"CounterStain Washing"
		},
		NumberOfCounterStainWashSolutionDispenseMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of times that the cell/CounterStainWashSolution suspension should be mixed after dispension.",
			Category->"CounterStain Washing"
		},
		CounterStainWashSolutionIncubation -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the cells should be incubated and/or mixed after the CounterStainWashSolution is added.",
			Category->"CounterStain Washing"
		},
		CounterStainWashSolutionIncubationInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,Shaker],
				Object[Instrument,Shaker],
				Model[Instrument,HeatBlock],
				Object[Instrument,HeatBlock]
			],
			Description -> "The instrument used to perform the Mixing and/or Incubation of the cell sample/CounterStainWashSolution mixture.",
			Category->"CounterStain Washing"
		},
		CounterStainWashSolutionIncubationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The amount of time that the cells should be incubated/mixed with the CounterStainWashSolution.",
			Category->"CounterStain Washing"
		},
		CounterStainWashSolutionIncubationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Celsius],
			Units -> Celsius,
			Description -> "The temperature of the mix instrument while mixing/incubating the cells with the CounterStainWashSolution.",
			Category->"CounterStain Washing"
		},
		CounterStainWashSolutionMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the cells and CounterStainWashSolution should be mixed during CounterStainWashSolutionIncubation.",
			Category->"CounterStain Washing"
		},
		CounterStainWashSolutionMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Shake],
			Description -> "Indicates the style of motion used to mix the sample.",
			Category->"CounterStain Washing"
		},
		CounterStainWashSolutionMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The frequency of rotation of the mixing instrument should use to mix the cells/CounterStainWashSolution.",
			Category->"CounterStain Washing"
		},

		CounterStainWashPellet -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the cells and CounterStainWashSolution should be centrifuged to create a pellet after CounterStainWashSolutionIncubation to be able to safely aspirate the CounterStainWashSolution from the cells.",
			Category->"CounterStain Washing"
		},
		CounterStainWashPelletInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,Centrifuge],
				Object[Instrument,Centrifuge]
			],
			Description->"The centrifuge that will be used to spin the cell sample with CounterStainWashSolution added to it after CounterStainWashSolutionIncubation.",
			Category->"CounterStain Washing"
		},
		CounterStainWashPelletIntensity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description->"The rotational speed or the force that will be applied to the cell sample with CounterStainWashSolution by centrifugation in order to create a pellet.",
			Category->"CounterStain Washing"
		},
		CounterStainWashPelletTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The amount of time that the cell sample with CounterStainWashSolution will be centrifuged to create a pellet.",
			Category->"CounterStain Washing"
		},
		CounterStainWashPelletTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the centrifuge chamber will be held while the cell sample with CounterStainWashSolution is being centrifuged.",
			Category->"CounterStain Washing"
		},
		CounterStainWashPelletSupernatantVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The amount of supernatant that will be aspirated from the cell sample with CounterStainWashSolution after centrifugation created a cell pellet.",
			Category->"CounterStain Washing"
		},
		CounterStainWashPelletSupernatantDestination -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description->"The container that the supernatant is dispensed into after aspiration from the pelleted cell sample. If the supernatant will not be used for further experimentation, the destination is set to Waste.",
			Category->"CounterStain Washing"
		},
		CounterStainWashPelletSupernatantTransferInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,Pipette],
				Object[Instrument,Pipette]
			],
			Description->"The pipette that will be used to transfer off the supernatant (CounterStainWashSolution and CounterStain) from the pelleted cell sample.",
			Category->"CounterStain Washing"
		}
	}
}];
