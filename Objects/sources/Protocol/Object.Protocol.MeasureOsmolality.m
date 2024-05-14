(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol,MeasureOsmolality],{
	Description->"A protocol object for measuring the osmolality of a sample solution.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(*Setup*)
		OsmolalityMethod->{
			Format->Single,
			Class->Expression,
			Pattern:>OsmolalityMethodP,
			Description->"The experimental technique or principle used to determine the osmolality of the samples.",
			Category -> "General"
		},
		Instrument->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Instrument,Osmometer],Model[Instrument,Osmometer]],
			Description->"The instrument used to measure the osmolality of a sample.",
			Category -> "General"
		},
		(*Cleaning*)
		PreClean->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the osmometer thermocouple is to undergo an additional clean prior to experiment, before calibration. The instrument thermocouple is always cleaned after experiment.",
			Category->"Cleaning"
		},
		CleaningSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"The solution used to wash the thermocouple head to remove any debris.",
			Category->"Cleaning"
		},
		DesiccantCartridgeReplace->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the desiccant cartridge of the osmometer is exhausted and will be replaced. Remaining cartridge life is assessed visually by the operator.",
			Category->"Cleaning",
			Developer->True
		},
		DesiccantCartridge->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Item,Cartridge,Desiccant],Model[Item,Cartridge,Desiccant]],
			Description->"The cartridge containing a water binding substance used to dry the measurement chamber after cleaning.",
			Category->"Cleaning",
			Developer->True
		},
		(*Calibration*)
		Calibrants->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"The solutions of known osmolality used by the instrument to determine the conversion from raw measurement to osmolality.",
			Category->"Calibration"
		},
		CalibrantOsmolalities->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Milli Mole/Kilogram],
			Units->Milli Mole/Kilogram,
			Description->"For each member of Calibrants, the osmolality of the solution used by the instrument to determine the conversion from raw measurement to osmolality.",
			Category->"Calibration",
			IndexMatching->Calibrants
		},
		CalibrantVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"For each member of Calibrants, the volume of solution used to calibrate the instrument.",
			Category->"Calibration",
			IndexMatching->Calibrants
		},
		CalibrantInoculationPapers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Item,InoculationPaper],Model[Item,InoculationPaper]],
			Description->"For each member of Calibrants, the paper that is saturated with calibrant solution on sample loading and holds the solution during measurement.",
			Category->"Calibration",
			IndexMatching->Calibrants
		},
		CalibrantTweezers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Item],Object[Item]],
			Description->"For each member of Calibrants, the tweezers used to load the sample paper into the sample holder.",
			Category->"Calibration",
			IndexMatching->Calibrants,
			Developer->True
		},
		CalibrantPipettes->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Instrument],Model[Instrument]],
			Description->"For each member of Calibrants, the pipette used to measure out and transfer the calibrant solution into the instrument.",
			Category->"Calibration",
			IndexMatching->Calibrants
		},
		CalibrantPipetteTips->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Item],Object[Item]],
			Description->"For each member of Calibrants, the pipette tip used with the pipette to transfer calibrant solution into the instrument.",
			Category->"Calibration",
			IndexMatching->Calibrants
		},
		CalibrantNumber->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Description->"For each member of Calibrants, the index number of the calibrant, starting from 1.",
			Category->"Calibration",
			IndexMatching->Calibrants,
			Developer->True
		},
		(*Control*)
		Controls->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"The solutions of known osmolality used to verify the calibration of the instrument.",
			Category->"Calibration"
		},
		ControlOsmolalities->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Milli Mole/Kilogram],
			Units->Milli Mole/Kilogram,
			Description->"For each member of Controls, the osmolality of the solution used to verify the calibration of the instrument.",
			Category->"Calibration",
			IndexMatching->Controls
		},
		ControlVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"For each member of Controls, the volume of solution used to verify the calibration of the instrument.",
			Category->"Calibration",
			IndexMatching->Controls
		},
		ControlInoculationPapers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Item,InoculationPaper],Model[Item,InoculationPaper]],
			Description->"For each member of Controls, the paper that is saturated with control solution on sample loading and holds the solution during measurement.",
			Category->"Calibration",
			IndexMatching->Controls
		},
		ControlTweezers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Item],Object[Item]],
			Description->"For each member of Controls, the tweezers used to load the sample paper into the sample holder.",
			Category->"Calibration",
			IndexMatching->Controls,
			Developer->True
		},
		ControlPipettes->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Instrument],Model[Instrument]],
			Description->"For each member of Controls, the pipette used to measure out and transfer the control solution into the instrument.",
			Category->"Calibration",
			IndexMatching->Controls
		},
		ControlPipetteTips->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Item],Object[Item]],
			Description->"For each member of Controls, the pipette tip used with the pipette to transfer control solution into the instrument.",
			Category->"Calibration",
			IndexMatching->Controls
		},
		ControlTolerances->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Millimole/Kilogram],
			Units->Milli Mole/Kilogram,
			Description->"For each member of ControlOsmolalities, the amount that the averaged measured osmolality of that batch of control replicates is permitted to deviate from the corresponding ControlOsmolality for calibration to be deemed successful.",
			Category->"Calibration",
			IndexMatching->ControlOsmolalities
		},
		NumberOfControlReplicates->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Description->"For each member of ControlOsmolalities, the batch lengths of replicate members in Controls that will be averaged and compared to each ControlOsmolality.",
			Category->"Calibration",
			IndexMatching->ControlOsmolalities
		},
		MeasuredControlOsmolalities->{
			Format->Multiple,
			Class->Distribution,
			Pattern:>DistributionP[Milli Mole/Kilogram],
			Units->Milli Mole/Kilogram,
			Description->"For each member of ControlOsmolalities, the osmolality distribution of each batch of controls measured in this protocol. The mean value is compared to the corresponding member of ControlOsmolalities.",
			Category->"Calibration",
			IndexMatching->ControlOsmolalities
		},
		MaxNumberOfCalibrations->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Description->"The maximum number of times that calibration should be attempted to achieve a calibration where the measured osmolalities for all the Controls are within their respective ControlTolerances.",
			Category->"Calibration"
		},
		UnmetCalibrationThreshold->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if all of the ControlTolerances were met by the instrument calibration, prior to exhausting the MaxNumberOfCalibrations.",
			Category->"Calibration"
		},
		CalibrationAttemptNumber->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Description->"The number of the calibration attempt that is currently underway.",
			Category->"Calibration",
			Developer->True
		},
		VerifiedOperator->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[User,Emerald]],
			Description->"The operator who has completed vapro 5600 training in this protocol and is verified to continue with calibration and/or sample measurement.",
			Category->"General",
			Developer->True
		},
		(*Sample Loading*)
		InoculationPapers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Item,InoculationPaper],Model[Item,InoculationPaper]],
			Description->"For each member of SamplesIn, the paper that is saturated with sample solution on sample loading and holds the sample during measurement.",
			Category->"Sample Loading",
			IndexMatching->SamplesIn
		},
		Tweezers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Item],Object[Item]],
			Description->"For each member of SamplesIn, the tweezers used to load the sample paper into the sample holder.",
			Category->"Sample Loading",
			IndexMatching->SamplesIn,
			Developer->True
		},
		SampleVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units->Microliter,
			Description->"For each member of SamplesIn, the volume of sample solution that is loaded into the osmometer and used to measure osmolality.",
			Category->"Sample Loading",
			IndexMatching->SamplesIn
		},
		Pipettes->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Instrument],Model[Instrument]],
			Description->"For each member of SamplesIn, the pipette used to measure out and transfer the sample solution into the instrument.",
			Category->"Sample Loading",
			IndexMatching->SamplesIn
		},
		PipetteTips->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Item],Object[Item]],
			Description->"For each member of SamplesIn, the pipette tip used with the pipette to transfer sample solution into the instrument.",
			Category->"Sample Loading",
			IndexMatching->SamplesIn
		},
		ViscousLoadings->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the sample is too resistant to flow for standard transfer and loading techniques.",
			Category->"Sample Loading",
			IndexMatching->SamplesIn
		},
		(*Measurement*)
		NumberOfReadings->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Description->"For each member of SamplesIn, the number of times to measure the osmolality of the sample once loaded into the instrument.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		SampleReadingNumber->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{GreaterP[0,1]..},
			Description->"For each member of SamplesIn, the index number of the sample reading, starting from 1.",
			Category -> "General",
			IndexMatching->SamplesIn,
			Developer->True
		},
		SampleReadingCounter->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Description->"The sample reading number that is currently being measured.",
			Category -> "General",
			Developer->True
		},
		EquilibrationTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Second,
			Description->"For each member of SamplesIn, the amount of time to wait between loading a sample into the instrument and measuring the osmolality.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		InternalDefaultEquilibrationTimes->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the amount of time to wait between loading a sample into the instrument and measuring osmolality is set to an internal default value by the instrument.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		InstrumentModes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>OsmolalityModeP,
			Description->"For each member of SamplesIn, the measurement mode to set the instrument to, in order to take the measurement.",
			Category -> "General",
			IndexMatching->SamplesIn,
			Developer->True
		},
		MeasurementTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"The total amount of time it takes to complete all the osmolality measurements of the samples.",
			Category -> "General",
			Developer->True
		},
		(*Experiment Results*)
		DataFiles->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"The processed experiment data generated by the osmometer instrument.",
			Category->"Experimental Results"
		},
		RawDataFiles->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"The raw experiment data generated by the osmometer instrument, in proprietary format.",
			Category->"Experimental Results",
			Developer->True
		},
		DataFilePath->{
			Format->Multiple,
			Class->String,
			Pattern:>FilePathP,
			Description->"The file path of the folder containing the data files generated at the conclusion of the experiment.",
			Category->"Experimental Results",
			Developer->True
		},
		FileNames->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"For each member of SamplesIn, the name to use for the datafiles when generated by the instrument.",
			Category->"Experimental Results",
			IndexMatching->SamplesIn,
			Developer->True
		},
		ControlFileNames->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"For each member of Controls, the name to use for the datafiles when generated by the instrument.",
			Category->"Experimental Results",
			IndexMatching->Controls,
			Developer->True
		},
		ControlData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"Control data generated by this protocol using the final calibration.",
			Category->"Experimental Results"
		},
		ControlDataFiles->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"The processed control data generated by the osmometer instrument using the final calibration.",
			Category->"Experimental Results"
		},
		ControlRawDataFiles->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"The raw control data generated by the osmometer instrument using the final calibration, in proprietary format.",
			Category->"Experimental Results",
			Developer->True
		},
		VoidControlData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"Any control data generated by this protocol using discarded calibrations that did not meet the specified ControlTolerances.",
			Category->"Experimental Results",
			Developer->True
		},
		VoidControlDataFiles->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"The processed control data generated by the osmometer instrument using discarded calibrations that did not meet the specified ControlTolerances.",
			Category->"Experimental Results",
			Developer->True
		},
		VoidControlRawDataFiles->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"The raw control data generated by the osmometer instrument, in proprietary format using discarded calibrations that did not meet the specified ControlTolerances.",
			Category->"Experimental Results",
			Developer->True
		},
		VoidControlFileNames->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"For each member of Controls, the name to use for the datafiles when generated by the instrument.",
			Category->"Experimental Results",
			IndexMatching->Controls,
			Developer->True
		},
		ControlVideoDirectory->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The directory storing a video capturing the calibration and control process for the instrument.",
			Category->"Experimental Results",
			Developer->True
		},
		SampleVideoDirectory->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The directory storing a video capturing the sample measurement process for the instrument.",
			Category->"Experimental Results",
			Developer->True
		},
		VideoDirectoryCommand->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The command prompt command to create the video directories on the local computer.",
			Category->"Experimental Results",
			Developer->True
		},
		ControlLocalVideoDirectory->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The directory on the local instrument pc storing a video capturing the calibration and control process for the instrument.",
			Category->"Experimental Results",
			Developer->True
		},
		SampleLocalVideoDirectory->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The directory on the local instrument pc storing a video capturing the sample measurement process for the instrument.",
			Category->"Experimental Results",
			Developer->True
		},
		VideoUploadCommand->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The command prompt command to upload the control and sample videos from the local computer to the z drive.",
			Category->"Experimental Results",
			Developer->True
		},
		VoidCalibrationVideoFiles->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"The files storing video capturing the calibration processes for the instrument that were not successful and not used.",
			Category->"Experimental Results",
			Developer->True
		},
		CalibrationVideoFiles->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"The files storing video capturing the calibration process for the instrument.",
			Category->"Experimental Results"
		},
		MosaicVideoFile->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"A composite of aligned videos showing the loading of the Vapro 5600 during this protocol for all calibrants, controls and samples.",
			Category->"Experimental Results"
		},
		InitialInstrumentContaminationLevel->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0],
			Units->None,
			Description->"The instrument thermocouple contamination level as measured by the instrument at the beginning of the protocol, when the calibration is performed. For the Vapro 5600 this is measured when the 100 mmol/kg standard is run.",
			Category->"Experimental Results"
		},
		Temperature->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityCoordinatesP[{None,Celsius}],
			Units->{None,Celsius},
			Description->"The ambient temperature around the instrument during the protocol period.",
			Category->"Experimental Results"
		},
		RelativeHumidity->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityCoordinatesP[{None,Percent}],
			Units->{None,Percent},
			Description->"The ambient relative humidity around the instrument during the protocol period.",
			Category->"Experimental Results"
		},
		PostRunInstrumentContaminationLevel->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0],
			Units->None,
			Description->"The instrument thermocouple contamination level as measured by the instrument after sample measurement is complete.",
			Category->"Experimental Results"
		},
		PostRunInstrumentContaminationStandard->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"The 100 mmol/kg standard used to measure the level of thermocouple contamination of the instrument after sample measurement is complete.",
			Category->"General"
		},
		PostRunInstrumentContaminationInoculationPapers->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Item,InoculationPaper],Model[Item,InoculationPaper]],
			Description->"The paper that is saturated with 100 mmol/kg standard solution on sample loading and holds the solution during measurement.",
			Category->"General"
		},
		PostRunInstrumentContaminationTweezers->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Item],Object[Item]],
			Description->"The tweezers used to load the sample paper into the sample holder.",
			Category->"General",
			Developer->True
		},
		PostRunInstrumentContaminationPipettes->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Instrument],Model[Instrument]],
			Description->"The pipette used to measure out and transfer the 100 mmol/kg standard solution into the instrument.",
			Category->"General"
		},
		PostRunInstrumentContaminationPipetteTips->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Item],Object[Item]],
			Description->"The pipette tip used with the pipette to transfer 100 mmol/kg standard solution into the instrument.",
			Category->"General"
		},
		PostRunInstrumentContaminationFileName->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The name to use for the datafile containing the instrument contamination measurement after sample measurement is complete.",
			Category->"Experimental Results",
			Developer->True
		},
		PostRunInstrumentContaminationData->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"Data generated by this protocol when measuring instrument contamination after sample measurement is complete.",
			Category->"Experimental Results"
		},
		PostRunInstrumentContaminationDataFile->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"The processed control data generated when measuring instrument contamination after sample measurement is complete.",
			Category->"Experimental Results"
		},
		PostRunInstrumentContaminationRawDataFile->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"The raw control data generated when measuring instrument contamination after sample measurement is complete, in proprietary format.",
			Category->"Experimental Results",
			Developer->True
		}
	}
}];
