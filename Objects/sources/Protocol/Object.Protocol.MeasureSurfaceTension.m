(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, MeasureSurfaceTension], {
	Description->"A protocol for measuring the surface tension of samples of varying concentrations.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Instrument->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Instrument,Tensiometer]|Model[Instrument,Tensiometer],
			Description->"The tensiometer that is used to measure the surface tension of the sample.",
			Category -> "General",
			Abstract->True
		},
		SampleAmounts -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Microliter] | GreaterEqualP[0*Milligram],
			Units->Microliter,
			Description -> "For each member of SamplesIn, the amount of sample or aliquot that will be taken to make the dilutions.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> True
		},
		Dilutions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{GreaterEqualP[0 Microliter],GreaterEqualP[0 Microliter]}...}|Null,
			Description -> "For each member of SamplesIn, the collection of dilutions performed on the sample before measuring surface tension. This is the volume of the sample and the volume of the diluent that will be mixed together for each concentration in the dilution curve.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation"
		},
		SerialDilutions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :>{{GreaterEqualP[0 Microliter],GreaterEqualP[0 Microliter]}...}|Null,
			Description -> "For each member of SamplesIn, the volume of the sample transferred in a serial dilution and the volume of the Diluent it is mixed with at each step.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation"
		},
		Diluents->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"For each member of SamplesIn, the sample that is used to dilute the sample to a concentration series.",
			IndexMatching -> SamplesIn,
			Category->"Sample Preparation"
		},
		AssayPlates->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Container, Plate] | Object[Container, Plate],
			Description->"The plates that the samples are in when measuring the their surface tension.",
			Category->"Sample Preparation"
		},
		AssayPlatesAppearanceTop->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"The top images of assay plates that the samples are in when measuring the their surface tension.",
			Category->"Sample Preparation"
		},
		AssayPlatesAppearanceSide->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"The side images of assay plates that the samples are in when measuring the their surface tension.",
			Category->"Sample Preparation"
		},
		AssayPlatePlacements->{
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Alternatives[Object[Container],Model[Container]], Null},
			Description -> "A list of placements used to place the AssayPlates in their appropriate positions on the tensiometer.",
			Category -> "Instrument Specifications",
			Developer -> True,
			Headers -> {"Assay plate","Placement"}
		},
		AssayPlateLids->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Item, Lid]|Object[Item, Lid],
			Description->"The covers that are placed on the AsssayPlates before and after measurement.",
			Category->"Sample Preparation"
		},
		SampleLoadingVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?VolumeQ,
			Units -> Liter Micro,
			Description -> "The volume of sample-diluent mixture loaded into each well.",
			Category -> "Sample Preparation"
		},
		DilutionContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container] | Model[Container],
			Description->"The container or containers in which each sample is diluted with the Diluent to make the concentration series.",
			Category->"Sample Preparation"
		},
		SampleDilutionPrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleManipulationP | RoboticSamplePreparationP,
			Description -> "A set of instructions specifying the loading and mixing of each sample and the Diluent in the DilutionContainers.",
			Category -> "Sample Preparation"
		},
		SampleDilutionManipulation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->(Object[Protocol,SampleManipulation]|Object[Protocol,RoboticSamplePreparation]|Object[Protocol,ManualSamplePreparation]|Object[Notebook,Script]),
			Description->"The protocol(s) used to load the DilutionContainers and mix their contents.",
			Category->"Sample Preparation"
		},
		AssayPlatePrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleManipulationP,
			Description -> "A set of instructions specifying the loading of the assay plate with the required samples.",
			Category -> "Sample Preparation"
		},
		AssayPlateManipulation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->(Object[Protocol,SampleManipulation]|Object[Protocol,RoboticSamplePreparation]),
			Description->"A sample manipulation protocol used to load the assay plate.",
			Category -> "Sample Preparation"
		},
		DilutionMixVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Microliter],
			Units->Microliter,
			Description -> "For each member of SamplesIn, the volume that is pipetted out and in of the dilution to mix the sample with the Diluent to make the DilutionCurve.",
			Category->"Sample Preparation"
		},
		DilutionNumberOfMixes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>RangeP[0,20,1],
			Description -> "For each member of SamplesIn, the number of pipette out and in cycles that is used to mix the sample with the Diluent to make the DilutionCurve.",
			Category->"Sample Preparation"
		},
		DilutionMixRates->{
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0.4 Microliter/Second,250 Microliter/Second],
			Units->Microliter/Second,
			Description -> "For each member of SamplesIn, the speed at which the DilutionMixVolume is pipetted out and in of the dilution to mix the sample with the Diluent to make the DilutionCurve.",
			Category->"Sample Preparation"
		},
		SingleSamplePerProbe -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the samples are arranged on the measurement plate so that there is only one input sample in each row.",
			Category -> "Sample Preparation"
		},
		AssayPositions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{ObjectP[{Model[Container], Object[Container]}], WellPositionP}..},
			Description -> "For each member of SamplesIn, the well positions in the measurement plate occupied by the sample dilution.",
			Category -> "Sample Preparation"
		},
		SampleRecoveryPrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleManipulationP,
			Description -> "A set of instructions specifying the movement of samples from the AssayPlates to the ContainersOut.",
			Category -> "Sample Preparation"
		},
		SampleRecoveryManipulation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,SampleManipulation],
			Description->"A sample manipulation protocol used to move the samples from the AssayPlates to the ContainersOut.",
			Category->"Sample Preparation"
		},
		DilutionStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description -> "For each member of SamplesIn, the conditions under which any leftover samples from the DilutionCurve should be stored after the samples are transferred to the measurement plate.",
			Category->"Sample Preparation"
		},
		ImageDilutionContainers->{
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the dilution plate was imaged after loading the assay plate onto the instrument.",
			Category -> "Sample Preparation"
		},
		PreparedPlate->{
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description-> "Indicates if the input plates have been prepared prior to the start of the experiment. If True, the samples in column 12 of the plate are used as calibrants.",
			Category -> "Sample Preparation"
		},
		Calibrant->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The sample that is used to calibrate the scales used to take the surface tension measurements.",
			Category->"Calibration Parameters"
		},
		CalibrantVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milliliter],
			Units->Microliter,
			Description -> "The amount of calibrant that will be taken to calibrate the instrument.",
			Category -> "Calibration Parameters",
			Abstract -> True
		},
		CalibrantSurfaceTension->{
			Format->Single,
			Class->Real,
			Pattern :>RangeP[10 Milli Newton/Meter,100 Milli Newton/Meter],
			Units -> Milli Newton/Meter,
			Description -> "The surface tension value of the Calibrant that is used to perform the calibration.",
			Category->"Calibration Parameters"
		},			
		NumberOfCalibrationMeasurements->{
			Format->Single,
			Class->Integer,
			Pattern:>RangeP[1,20,1],
			Description-> "The number of subsequent times surface tension of the calibration liquid is measured before taking the measurements. The average of these measurements are used in the calibration.",
			Category->"Calibration Parameters"
		},
		MaxCalibrationNoise->{
			Format->Single,
			Class->Real,
			Pattern :> RangeP[0.05 Milli Newton/Meter,0.2 Milli Newton/Meter],
			Units -> Milli Newton/Meter,
			Description -> "The maximum noise (probe vibration) accepted while the probes are in the air before they are moved into the calibration sample.",
			Category -> "Calibration Parameters"
		},	
		EquilibrationTime->{
			Format->Single,
			Class->Real,
			Pattern :> RangeP[0 Minute,120 Minute],
			Units -> Minute,
			Description -> "The minimum amount of time, after being plated but before readings begin, used for the sample to equilibrate.",
			Category -> "General"
		},	
		NumberOfSampleMeasurements->{
			Format->Single,
			Class->Integer,
			Pattern :> RangeP[1,20,1],
			Description -> "The number of subsequent times surface tension of the sample is measured.",
			Category -> "General"
		},	
		ProbeSpeed->{
			Format->Single,
			Class->Real,
			Pattern :> RangeP[30 Percent,100 Percent],
			Units -> Percent,
			Description ->"The percentage of the default speed that is used to move the measurement table down, pulling the probe out of the liquid.",
			Category -> "General"
		},
		MaxDryNoise->{
			Format->Single,
			Class->Real,
			Pattern :> RangeP[0.05 Milli Newton/Meter,0.2 Milli Newton/Meter],
			Units -> Milli Newton/Meter,
			Description -> "The maximum noise (probe vibration) accepted while the probes are in the air before the probes are moved into the sample.",
			Category -> "General"
		},	
		MaxWetNoise->{
			Format->Single,
			Class->Real,
			Pattern :> RangeP[0.05 Milli Newton/Meter,0.2 Milli Newton/Meter],
			Units -> Milli Newton/Meter,
			Description -> "The maximum noise (probe vibration) accepted while the probes are in the sample liquid before the probes are pulled out of the liquid to take the measurement.",
			Category -> "General"
		},
		MethodFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the file necessary for the instrument to load its method file and execute this protocol.",
			Category -> "General",
			Developer -> True
		},
		PreCleaningMethod->{
			Format->Multiple,
			Class->Expression,
			Pattern :> ListableP[Burn|Solution],
			Description -> "The method used to clean the tensiometer probes before measurements begin.",
			Category -> "Cleaning"
		},
		 CleaningMethod->{
			Format->Multiple,
			Class->Expression ,
			Pattern :> ListableP[Burn|Solution],
			Description -> "The method used to clean the tensiometer probes between all measurements within a single dilution curve (of the same sample).",
			Category -> "Cleaning"
		},
		CleaningSolutions->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The solutions the probes are dipped into to clean the tensiometer probes.",
			Category->"Cleaning"
		},
		CleaningSolutionContainer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container]|Model[Container],
			Description->"The container the solution the probes are dipped into to clean the tensiometer probes is in.",
			Category->"Cleaning"
		},
		CleaningSolutionPlacements->{
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container]|Model[Container], Null},
			Description -> "The placement used to place the cleaning solution container in its appropriate position on the tensiometer.",
			Category -> "Instrument Specifications",
			Developer -> True,
			Headers->{"Object to Place", "Placement Tree"}
		},
		CleaningSolutionPrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleManipulationP,
			Description -> "A set of instructions specifying the loading of the CleaningSolution into the CleaningSolutionContainer.",
			Category -> "Cleaning"
		},
		CleaningSolutionManipulation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,SampleManipulation],
			Description->"A sample manipulation protocol used to load the CleaningSolutionContainer.",
			Category->"Cleaning"
		},
		PreheatingTime->{
			Format->Single,
			Class->Real,
			Pattern :> RangeP[0 Second, 2 Second],
			Units -> Second,
			Description -> "The duration of one of three short heating pulses used by the instrument's internal probe cleaner to preheat the probes before the primary cleaning pulse.",
			Category -> "Cleaning"
		},
		BurningTime->{
			Format->Single,
			Class->Real,
			Pattern :> RangeP[0 Second, 20 Second],
			Units -> Second,
			Description -> "The duration of the primary cleaning pulse used by the instrument's internal probe cleaner to burn contaminants off the probes before a new plate is measured.",
			Category -> "Cleaning"
		},
		CoolingTime->{
			Format->Single,
			Class->Real,
			Pattern :> RangeP[0 Second, 20 Second],
			Units -> Second,
			Description ->  "The duration of the cooling period after the instrument's internal probe cleaner issues a primary cleaning pulse and before a new plate is measured.",
			Category -> "Cleaning"
		},
		MaxCleaningNoise->{
			Format->Single,
			Class->Real,
			Pattern :> RangeP[0.05 Milli Newton/Meter,0.2 Milli Newton/Meter],
			Units -> Milli Newton/Meter,
			Description -> "The maximum noise accepted before the probes are brought into contact with the instrument's internal probe cleaner.",
			Category -> "Cleaning"
		},	
		BetweenMeasurementBurningTime->{
			Format->Single,
			Class->Real,
			Pattern :> RangeP[0 Second, 10 Second],
			Units -> Second,
			Description -> "The duration of the primary cleaning pulse used by the instrument's internal probe cleaner to burn contaminants off the probes between all measurements within a single dilution curve (of the same sample).",
			Category -> "Cleaning"
		},
		BetweenMeasurementCoolingTime->{
			Format->Single,
			Class->Real,
			Pattern :> RangeP[0 Second, 10 Second],
			Units -> Second,
			Description ->  "The duration of the cooling period between measurements after the instrument's internal probe cleaner issues a primary cleaning pulse and before a new measurement within a single dilution curve (of the same sample).",
			Category -> "Cleaning"
		},
		NumberOfCleanings->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0,1],
			Description-> "The number of times the probe cleaner was used in the protocol.",
			Category->"Cleaning"
		},

		DataFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path of the data files generated at the conclusion of the experiment.",
			Category -> "General",
			Developer -> True
		},
		CriticalMicelleConcentrations->{
			Format->Multiple,
			Class->Real,
			Pattern :> GreaterP[0*Molar]|GreaterP[0 Gram/Liter]|RangeP[0 Percent,100 Percent],
			Description-> "For each member of SamplesIn, the concentration of surfactants above which micelles form and all additional surfactants added to the system go into micelles. This is the concentration where increasing the concentration of the sample stops decreasing the surface tension.",
			IndexMatching -> SamplesIn,
			Category->"Experimental Results"
			},
		ApparentPartitioningCoefficients->{
			Format->Multiple,
			Class->Real,
			Pattern :> GreaterP[0/Molar]|GreaterP[0 Liter/Gram]|GreaterP[0 /Percent],
			Description-> "For each member of SamplesIn, an apparent partitioning coefficient used to quantify partitioning the air-water interface. This is the inverse of the concentration where increasing the concentration of the sample starts decreasing the surface tension.",
			IndexMatching -> SamplesIn,
			Category->"Experimental Results"
			},
		SurfaceExcessConcentrations->{
			Format->Multiple,
			Class->Real,
			Pattern :> GreaterP[0*Mole/Meter^2],
			Units->Mole/Meter^2,
			Description-> "For each member of SamplesIn, the amount of surfactant adsorbed at the air water interface per surface area. This is calculated by taking the negative of the slope of the concentration dependent region of a surface tension vs. log of concentration graph divided by the temperature the measurement was taken at and the ideal gas constant.",
			IndexMatching -> SamplesIn,
			Category->"Experimental Results"
			},
		CrossSectionalAreas->{
			Format->Multiple,
			Class->Real,
			Pattern :> GreaterP[0*Meter^2],
			Units->Meter^2,
			Description-> "For each member of SamplesIn, the area of the surfactant molecule at the surface. This is calculated by taking the inverse of the SurfaceExcessConcentration and the Avogadro constant.",
			IndexMatching -> SamplesIn,
			Category->"Experimental Results"
			},
		MaxSurfacePressures->{
			Format->Multiple,
			Class->Real,
			Pattern :> GreaterP[0*Milli Newton/Meter],
			Units->Milli Newton/Meter,
			Description-> "For each member of SamplesIn, the largest surface pressure of the dilutions. This is also the difference between the surface tension of the diluent and the surface tension of the most concentrated dilution.",
			IndexMatching -> SamplesIn,
			Category->"Experimental Results"
			}
	}			
}];



