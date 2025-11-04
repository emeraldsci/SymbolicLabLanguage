(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, MeasureViscosity], {
	Description->"A protocol for measuring the viscosity of samples.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

	(*-- Sample Preparation --*)
		PlateSeal->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Item],Object[Item]],
			Description->"The self-adhesive seal used to cover the Sample if it is a plate after Sample Preparation.",
			Category->"Sample Preparation"
		},
		Needle->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Item,Needle],Object[Item,Needle]],
			Description->"The apparatus used to remove any air bubbles in the Sample container if it is in an autosampler vial after Sample Preparation.",
			Category->"Sample Preparation"
		},
		(*-- General Method Information --*)
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument,Viscometer],
				Model[Instrument,Viscometer]
			],
			Description -> "The viscometer that is used to measure the viscosity of the sample. The available instrument measures pressure drops across a rectangular slit in a microfluid chip as a sample is pumped though to calculate viscosity.",
			Category -> "General"
		},
		MethodFilePath->{
			Format->Multiple,
			Class->String,
			Pattern:>FilePathP,
			Description->"The file path of the folder containing the protocol file with the run parameters.",
			Category->"General",
			Developer->True
		},
		DataFilePath -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path of the folder containing the data file generated at the conclusion of the experiment.",
			Category -> "General",
			Developer -> True
		},
		AssayType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ViscosityAssayTypeP,
			Description -> "The general experiment method that will be used to measure the viscosity of the sample. LowViscosity AssayType is intended for samples with viscosities between 0.3 and 150 m*Pa*s. HighViscosity AssayType is intended for samples with viscosities between 100 and 1000 m*Pa*s. HighShearRate AssayType will conduct measurements at high shear rates for samples with viscosities between 1 m*Pa*s and 150 m*Pa*s.",
			Category -> "General"
		},
		ViscometerChip -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part,ViscometerChip],
				Model[Part,ViscometerChip]
			],
			Description -> "The microfluidic device of known dimensions containing pressure sensors that is used to measure the viscosity of sample.",
			Category -> "General"
		},
		ViscometerChipFerrules -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item,Consumable],
				Model[Item,Consumable]
			],
			Description -> "The ferrules that connect the microfluidic tubing to the viscometer chip.",
			Category -> "General",
			Developer -> True
		},
		ViscometerChipWrench->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Item,Wrench],
				Model[Item,Wrench]
			],
			Description->"The wrench used to secure the connections between the sample flow path tubing and the viscometer chip.",
			Category->"General"
		},
		ViscometerChipTweezers->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Item,Tweezer],
				Model[Item,Tweezer]
			],
			Description->"A pair of tweezers for operations on the viscometer instrument.",
			Category->"General"
		},
		ViscometerPliers->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Item,Plier],
				Model[Item,Plier]
			],
			Description->"A pair of pliers for operations on the viscometer instrument.",
			Category->"General"
		},
		ViscometerChipPlacement -> {
			Format -> Multiple,
			Class -> {Link,Link, String},
			Pattern :> {_Link, _Link,LocationPositionP},
			Relation -> {Alternatives[Object[Part],Model[Part]],Alternatives[Object[Instrument],Model[Instrument]], Null},
			Description -> "A list of placements used to place the ViscometerChip in the appropriate position of the instrument.",
			Category -> "Instrument Specifications",
			Developer -> True,
			Headers->{"Object to Place","Instrument","Position"}
		},
		SampleTrayRack ->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container,Rack],Model[Container,Rack]],
			Description -> "The rack that is used to hold the sample containers on the autosampler deck.",
			Category -> "General"
		},
		SampleTrayPlacement -> {
			Format -> Multiple,
			Class -> {Link,Link, String},
			Pattern :> {_Link, _Link,LocationPositionP},
			Relation -> {Alternatives[Object[Container],Model[Container]], Alternatives[Object[Instrument],Model[Instrument]],Null},
			Description -> "A list of placements used to place the SampleTrayRack in the appropriate position of the instrument.",
			Category -> "General",
			Developer -> True,
			Headers->{"Object to Place","Destination Location","Destination Position"}
		},
		SampleTrayInsert ->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part],Model[Part]],
			Description -> "The tray insert that is placed under the sample to prevent condensation build up is the SampleTemperature is below 18 C.",
			Category -> "General"
		},
		ContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Alternatives[Object[Container],Model[Container]], Alternatives[Object[Container],Model[Container]], Null},
			Description -> "A list of placements used to place the containers to be measured, and optionally, the RecoupSampleContainers, in the appropriate positions of the sample tray holder.",
			Category -> "Instrument Specifications",
			Developer -> True,
			Headers->{"Object to Place", "Destination Object","Destination Position"}
		},
		SamplesWithRecoupContainers -> {
			Format -> Multiple,
			Class -> {String, Link, String, Expression,String,Link},
			Pattern :> {LocationPositionP,_Link, _String, BooleanP,_String,_Link},
			Relation -> {Null,Alternatives[Object[Sample],Object[Container],Model[Container]], Null, Null,Null,Alternatives[Object[Container],Model[Container]]},
			Description -> "A list indicating the vial/well position of each Sample, recipe file name, the RecoupSample boolean, and the recovery vial/well, if applicable .",
			Category -> "Instrument Specifications",
			Developer -> True,
			Headers->{"Vial/Well", "Sample or Container","Recipe Name","Recoup Sample","Recoup Sample Well/Vial", "Recoup Sample Container"}
		},
		UniqueWorkingContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description ->"A modified list of WorkingContainers where there are no duplicates and is used for sample integrity check prior to loading into the instrument.",
			Category -> "General",
			Developer -> True
		},
		RecipeFileNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The names of the recipe files for measuring the viscosity of samples in this protocol.",
			Category -> "Method Information",
			Developer -> True
		},
		MeasurementFileNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The names of the method files for measuring the viscosity of samples in this protocol.",
			Category -> "Method Information",
			Developer -> True
		},
		NumberOfRuns -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Units -> None,
			Description -> "The number of individual runs of viscosity measurement that utilizes a distinct recipe file comprising of a set of loading, measurement and cleaning methods.",
			Category -> "Method Information",
			Developer -> True
		},
		RunNumbers -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Units -> None,
			Description -> "The list of numbers that are used to identify viscosity measurement runs with distinct recipe files. These are also used as identifiers for recipe files when loading into the instrument software.",
			Category -> "Method Information",
			Developer -> True
		},
		SampleTrayPositions -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Units -> None,
			Description -> "The list of numbers that are used to identify the ordered position of a sample in the sample tray for any given measure viscosity run. These are also used as identifiers for recipe files when loading into the instrument software.",
			Category -> "Method Information",
			Developer -> True
		},
		SampleTemperature -> {
			Format -> Single,
			Class -> Real,
			Units -> Celsius,
			Pattern :> GreaterEqualP[0 Celsius],
			Description -> "The temperature of the instrument's autosampler tray where samples are stored while awaiting measurement.",
			Category -> "General"
		},
		NitrogenValve -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates whether the nitrogen valve should be open and to start the flow of gas into the instrument and prevent condensation if the SampleTemperature and/or MeasurementTemperature is below 20 C.",
			Category -> "General"
		},
		(*-- Autosampler options --*)
		AutosamplerPrePressurization -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates whether the autosampler should inject air into the dead space of the sample vial to decrease bubble formation in the autosampler syringe prior to sample aspiration.",
			Category -> "General"
		},
		InjectionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "For each member of SamplesIn, The volume of sample that is dispensed from the Autosampler syringe into the chip injection syringe.",
			Category -> "General",
			IndexMatching->SamplesIn
		},

		(*-- Viscosity Measuremnet Specifications --*)
		MeasurementMethods -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ViscosityMeasurementMethodP,
			Description -> "For each member of SamplesIn, the type of measurement and the subset of parameters that will be determined by the instrument during the measurement.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		MeasurementTemperatures -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[GreaterEqualP[0*Celsius],2],
			Description -> "For each member of SamplesIn, indicates the set of MeasurementTemperatures at which viscosity readings will be measured.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		TemperatureStabilityMargins -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "For each member of SamplesIn, indicates the maximum allowable deviation from the set MeasurementTemperature before initiating a measurement.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		TemperatureStabilityTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Minute,
			Description -> "For each member of SamplesIn, the time that the instrument has to be at the MeasurementTemperature +/- TemperatureStabilityMargin before a measurement step is started.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		FlowRates -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[GreaterP[0*Microliter/Minute],2],
			Description -> "For each member of SamplesIn, the volumetric rate at which the sample is pumped through the measurement channel of the chip.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		RelativePressures -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[GreaterP[0*Percent],2],
			Description -> "For each member of SamplesIn, the list of pressures as a percentage of the maximum pressure rating of the chip, that the sensors should achieve during viscosity measurements.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		EquilibrationTimes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[GreaterP[0*Second],2],
			Description -> "For each member of SamplesIn, the set of times during which the instrument is flowing the sample through the measurement channel to develop a steady-state flow profile prior to collecting the data used to determine the average viscosity.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		MeasurementTimes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[GreaterP[0*Second],2],
			Description -> "For each member of SamplesIn, the set of times the instrument flows sample through the measurement channel and collects data that is used to determine the average viscosity.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		PauseTimes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[GreaterEqualP[0*Second],2],
			Description -> "For each member of SamplesIn, the set of times between each measurement step in the MeasurementMethodTable to allow for sample relaxation.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		NumberOfReadings -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Units -> None,
			Description -> "For each member of SamplesIn, the number of times measurements are taken with each set of MeasurementTemperature, FlowRate, EquilibrationTime, and MeasurementTime.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		Priming -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the measurement chip's channels will be initially wetted with the sample prior to measurements and between changes in MeasurementTemperatures.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		MeasurementMethodTables -> {
			Format->Multiple,
			Class->Expression,
			Pattern:>ListableP[{{GreaterEqualP[0 Celsius],GreaterEqualP[0 Microliter/Minute]|Null,GreaterEqualP[0 Percent]|Null,GreaterEqualP[0 Second]|Null,GreaterEqualP[0 Second]|Null,GreaterEqualP[0 Second]|Null,BooleanP,GreaterEqualP[1]}..},2],
			Description -> "For each member of SamplesIn, the sequence of measurement steps, {MeasurementTemperature, FlowRate,Relative  Pressure, EquilibrationTime, MeasurementTime,PauseTime, Priming, NumberOfReadings} that will be used to measure the sample's viscosity.",
			Category -> "General",
			IndexMatching -> SamplesIn,
			Developer->True
		},
		RemeasurementAlloweds -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the sample will be directed to a holding reservoir and recycled and sent back in the chip for additional measurements if the InjectionVolume is used up before all steps in the MeasurementMethod are completed.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		RemeasurementReloadVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Microliter],
			Units -> Microliter,
			Description -> "For each member of SamplesIn, indicates the volume of the sample that will be drawn from the holding reservoir and pumped back into the syringe for additional measurements if RemeasurementAllowed is True and the InjectionVolume is used up before the measurement method is completed.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		RecoupSamples -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the sample injected into the instrument will be recovered, or alternatively, discarded, at the conclusion of the measurement.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		RecoupSampleContainerSame -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the recouped sample will be transferred back into the original container or well or a new container or well upon completion of all measurement steps. If False, the sample will be placed into an empty container or well.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		RecoupSampleContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container],Model[Container]],
			Description -> "The container that will be used to store the sample after measurement if RecoupSampleContainerSame is False.",
			Category -> "General"
		},
		ResidualIncubation -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the autosampler tray holding the input samples should remain at the set SampleTemperature at the conclusion of measurements for all samples, until the samples are stored.",
			Category -> "General"
		},
		(* -- Clean up -- *)
		PrimaryBuffer ->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The first solvent that is used to flush the instrument after a sample has been measured and before measuring the next sample. The PrimaryBuffer should be the principle solvent of all Samples being measured and is used to dilute out any dissolved components in the samples. Samples should be miscible in the PrimaryBuffer. A standard method will be used to flush the instrument with the PrimaryBuffer.",
			Category -> "Cleaning"
		},
		SecondaryCleaningSolvent ->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The second solution that is used to flush the instrument after a sample has been measured and before measuring the next sample. The SecondaryCleaningSolution is commonly 1% Aquet in RO water and is used to perform a thorough cleaning of the instrument. A standard method will be used to flush the instrument with the SecondaryCleaningSolution.",
			Category -> "Cleaning"
		},
		TertiaryCleaningSolvent ->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The third solution that is used to flush the instrument after a sample has been measured and before measuring the next sample. The TertiaryCleaningSolution is commonly Isopropanol and is used to perform flush out cleaning solutions and dry the wetted components in preparation for the next sample measurement. A standard method will be used to flush the instrument with the TertiaryCleaningSolution.",
			Category -> "Cleaning"
		},
		CleaningSolutionPlacements ->{
			Format -> Multiple,
			Class -> {Link,Link,Expression},
			Pattern :> {_Link,_Link, LocationPositionP},
			Relation -> {Object[Container]|Model[Container], Object[Instrument]|Model[Instrument],Null},
			Description -> "The placement used to place the cleaning solution containers in its appropriate position on the viscometer.",
			Category -> "Instrument Specifications",
			Developer -> True,
			Headers->{"Object to Place", "Destination Location", "Destination Location Position"}
		},
		GroundStateCleaningSolutionPlacements ->{
			Format -> Multiple,
			Class -> {Link,Link,Expression},
			Pattern :> {_Link,_Link, LocationPositionP},
			Relation -> {Object[Container]|Model[Container], Object[Instrument]|Model[Instrument],Null},
			Description -> "The placement used to place the cleaning solution containers that reside on the instrument in the ground state.",
			Category -> "Instrument Specifications",
			Developer -> True,
			Headers->{"Object to Place", "Destination Location", "Destination Location Position"}
		},
		EstimatedProcessingTime->{
			Format -> Single,
			Class ->Real,
			Pattern :> TimeP,
			Units->Hour,
			Description -> "The estimated amount of time remaining until the instrument is projected to finish all measurements.",
			Category -> "General",
			Developer->True
		},
		PrimaryBufferStorageCondition ->{
			Format -> Single,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Disposal,
			Description -> "The storage conditions under which the PrimaryBuffer should be stored after its usage in this experiment.",
			Category -> "Cleaning"
		},
		WasteWeightData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The weight of the waste solvent container of the viscometer at the end of the MeasureViscosity protocol.",
			Category -> "Sensor Information",
			Developer -> True
		},
		(* -- Experimental Results -- *)
		MethodFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The files containing the measurement method parameters inputted into the viscometer instrument.",
			Category -> "Experimental Results"
		},
		DataFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The CSV file containing the processed experiment data generated by the viscometer instrument.",
			Category -> "Experimental Results"
		},
		RawDataFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The CSV file containing the raw, unprocessed data generated by the viscometer instrument.",
			Category -> "Experimental Results"
		},
		(* -- Others -- *)
		SoftwareWindowImages->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image taken of the software window when an error is encountered.",
			Category->"General",
			Developer->True
		},
		PistonCleaningWipes -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item,Consumable],Object[Item,Consumable]],
			Description -> "The cleaning material used to wipe off unwanted impurities from the piston part of the target.",
			Category -> "Cleaning"
		},
		PistonCleaningSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample],Object[Sample]],
			Description -> "The cleaning solution used to clean uff unwanted impurities from the piston part of the target.",
			Category -> "Cleaning"
		}
	}
}];
