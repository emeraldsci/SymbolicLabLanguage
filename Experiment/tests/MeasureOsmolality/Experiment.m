(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentMeasureOsmolality : Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentMeasureOsmolality*)


(* ::Subsubsection:: *)
(*ExperimentMeasureOsmolality*)


DefineTests[
	ExperimentMeasureOsmolality,
	{
		(*Example Basic*)
		(*Positive cases and examples*)
		Example[{Basic,"Measure the osmolality of a single sample:"},
			ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID]],
			ObjectP[Object[Protocol,MeasureOsmolality]]
		],
		Example[{Basic,"Measure the osmolality two samples:"},
			ExperimentMeasureOsmolality[{Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID]}],
			ObjectP[Object[Protocol,MeasureOsmolality]]
		],
		Example[{Basic,"Measure the osmolality of a sample by referencing the container:"},
			ExperimentMeasureOsmolality[Object[Container,Vessel,"Test 2 mL Tube 1 for ExperimentMeasureOsmolality "<>$SessionUUID]],
			ObjectP[Object[Protocol,MeasureOsmolality]]
		],
		(*Unit Test for Model-Less Object*)
		Example[{Basic,"Measure the osmolality of a single sample when the Object[Sample] does not have a Model:"},
			ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample with no model for ExperimentMeasureOsmolality "<>$SessionUUID]],
			ObjectP[Object[Protocol,MeasureOsmolality]]
		],
		(* Messages *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentMeasureOsmolality[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentMeasureOsmolality[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentMeasureOsmolality[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentMeasureOsmolality[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages,"DiscardedSamples","If the provided sample is discarded, an error will be thrown:"},
			ExperimentMeasureOsmolality[Object[Sample,"Test discarded Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID]],
			$Failed,
			Messages:>{Error::DiscardedSamples,Error::InvalidInput}
		],
		Example[{Messages,"ContainerlessSamples","If the provided sample is not located in a container, an error will be thrown:"},
			ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample with no container for ExperimentMeasureOsmolality "<>$SessionUUID]],
			$Failed,
			Messages:>{Error::ContainerlessSamples,Error::InvalidInput}
		],
		Example[{Messages,"OsmolalityNonLiquidSamplesNotSupported","If the provided sample is not liquid, an error will be thrown:"},
			ExperimentMeasureOsmolality[Object[Sample,"Test solid sample for ExperimentMeasureOsmolality "<>$SessionUUID]],
			$Failed,
			Messages:>{Error::SolidSamplesUnsupported,Error::InvalidInput}
		],
		Example[{Messages,"OsmolalityNoVolume","If the provided sample does not have volume populated, an error will be thrown:"},
			ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample with no volume for ExperimentMeasureOsmolality "<>$SessionUUID]],
			$Failed,
			Messages:>{Error::OsmolalityNoVolume,Error::InvalidInput}
		],
		(* Conflicting options messages *)
		Example[{Messages,"OsmolalityCalibrantIncompatible","Return $Failed if the calibrants provided are not compatible with the instrument specified:"},
			ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Instrument->Object[Instrument,Osmometer,"Test Vapro 5600 Osmometer for ExperimentMeasureOsmolality "<>$SessionUUID],
				Calibrant->{Object[Sample,"Test 240 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID],Object[Sample,"Test 280 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID],Object[Sample,"Test 320 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID]}
			],
			$Failed,
			Messages:>{Error::OsmolalityCalibrantIncompatible,Error::InvalidOption}
		],
		Example[{Messages,"OsmolalityCalibrantOsmolalitiesIncompatible","Return $Failed if the calibrants osmolalities provided are not compatible with the instrument specified:"},
			ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Instrument->Object[Instrument,Osmometer,"Test Vapro 5600 Osmometer for ExperimentMeasureOsmolality "<>$SessionUUID],
				CalibrantOsmolality->{100 Milli Mole/Kilogram,200 Milli Mole/Kilogram,300 Milli Mole/Kilogram}
			],
			$Failed,
			Messages:>{Error::OsmolalityCalibrantOsmolalitiesIncompatible,Error::InvalidOption}
		],
		Example[{Messages,"OsmolalityControlOsmolalitiesIncompatible","Return $Failed if the controls osmolalities provided are not compatible with the instrument specified:"},
			ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Instrument->Object[Instrument,Osmometer,"Test Vapro 5600 Osmometer for ExperimentMeasureOsmolality "<>$SessionUUID],
				Control->Model[Sample,"Milli-Q water"],
				ControlOsmolality->0 Millimole/Kilogram
			],
			$Failed,
			Messages:>{Error::OsmolalityControlOsmolalitiesIncompatible,Error::InvalidOption}
		],
		Example[{Messages,"OsmolalityCalibrantsMisordered","Return $Failed if the calibrants provided are compatible with the instrument specified but not in a compatible order:"},
			ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Instrument->Object[Instrument,Osmometer,"Test Vapro 5600 Osmometer for ExperimentMeasureOsmolality "<>$SessionUUID],
				Calibrant->{
					Model[Sample,"Osmolality Standard 100 mmol/kg Sodium Chloride"],
					Model[Sample,"Osmolality Standard 290 mmol/kg Sodium Chloride"],
					Model[Sample,"Osmolality Standard 1000 mmol/kg Sodium Chloride"]
				}
			],
			$Failed,
			Messages:>{Error::OsmolalityCalibrantsMisordered,Error::InvalidOption}
		],
		Example[{Messages,"OsmolalityCalibrantOsmolalitiesMisordered","Return $Failed if the calibrants osmolalities provided are compatible with the instrument specified but not in a compatible order:"},
			ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Instrument->Object[Instrument,Osmometer,"Test Vapro 5600 Osmometer for ExperimentMeasureOsmolality "<>$SessionUUID],
				CalibrantOsmolality->{100 Milli Mole/Kilogram,290 Milli Mole/Kilogram,1000 Milli Mole/Kilogram}
			],
			$Failed,
			Messages:>{Error::OsmolalityCalibrantOsmolalitiesMisordered,Error::InvalidOption}
		],
		Example[{Messages,"OsmolalityLowSampleVolume","Warn if the sample volume is below that recommended for an accurate measurement:"},
			ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Instrument->Object[Instrument,Osmometer,"Test Vapro 5600 Osmometer for ExperimentMeasureOsmolality "<>$SessionUUID],
				SampleVolume->5 Microliter
			],
			ObjectP[Object[Protocol,MeasureOsmolality]],
			Messages:>{Warning::OsmolalityLowSampleVolume}
		],
		Example[{Messages,"OsmolalityLowControlVolume","Warn if the control volume is below that recommended for an accurate measurement:"},
			ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Instrument->Object[Instrument,Osmometer,"Test Vapro 5600 Osmometer for ExperimentMeasureOsmolality "<>$SessionUUID],
				ControlVolume->5 Microliter
			],
			ObjectP[Object[Protocol,MeasureOsmolality]],
			Messages:>{Warning::OsmolalityLowControlVolume}
		],
		Example[{Messages,"OsmolalityReadingsExceedsMaximum","Return $Failed if the number of readings requested is not compatible with the instrument:"},
			ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				NumberOfReadings->40
			],
			$Failed,
			Messages:>{Error::OsmolalityReadingsExceedsMaximum,Error::InvalidOption}
		],
		Example[{Messages,"OsmolalityEquilibrationTimeReadings","Return $Failed if the number of readings is not compatible with the specified equilibration times:"},
			ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				NumberOfReadings->2,
				EquilibrationTime->InternalDefault
			],
			$Failed,
			Messages:>{Error::OsmolalityEquilibrationTimeReadings,Error::InvalidOption}
		],
		Example[{Messages,"InputContainsTemporalLinks","A Warning is thrown if any inputs contain temporal links:"},
			ExperimentMeasureOsmolality[Link[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],Now-1 Second]],
			ObjectP[Object[Protocol,MeasureOsmolality]],
			Messages:>{
				Warning::InputContainsTemporalLinks
			}
		],
		(* Option precision checks *)
		Example[{Options,SampleVolume,"SampleVolume, if specified, is rounded to the nearest 0.1 microliter:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				SampleVolume->9.81 Microliter,
				Output->Options
			];
			Lookup[options,SampleVolume],
			9.8 Microliter,
			EquivalenceFunction->Equal,
			Messages:>{Warning::InstrumentPrecision},
			Variables:>{options}
		],
		Example[{Options,EquilibrationTime,"EquilibrationTimes, if specified, are rounded to the nearest 1 second:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				EquilibrationTime->30.2 Second,
				Output->Options
			];
			Lookup[options,EquilibrationTime],
			30 Second,
			EquivalenceFunction->Equal,
			Messages:>{Warning::InstrumentPrecision},
			Variables:>{options}
		],
		(* Map thread errors and warnings *)
		Example[{Messages,"OsmolalityUnknownViscosity","Warn if the viscosity of the sample can't be found and viscous loading is unspecified:"},
			ExperimentMeasureOsmolality[Object[Sample,"Test sample with Null viscosity for ExperimentMeasureOsmolality "<>$SessionUUID]],
			ObjectP[Object[Protocol,MeasureOsmolality]],
			Messages:>{Warning::OsmolalityUnknownViscosity}
		],
		Example[{Messages,"OsmolalityTransferHighViscosity","Return $Failed if sample is viscous, but viscous loading is set to False:"},
			ExperimentMeasureOsmolality[Object[Sample,"Test viscous sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				ViscousLoading->False
			],
			$Failed,
			Messages:>{Error::OsmolalityTransferHighViscosity,Error::InvalidOption}
		],
		Example[{Messages,"OsmolalitySampleCarryOver","Warn if the viscosity of the sample is low, but viscous loading is set to True:"},
			ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				ViscousLoading->True
			],
			ObjectP[Object[Protocol,MeasureOsmolality]],
			Messages:>{Warning::OsmolalitySampleCarryOver}
		],
		Example[{Messages,"OsmolalityNoInoculationPaper","Warn if viscous loading is set/resolves to False, but inoculation paper is set to Null:"},
			ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				ViscousLoading->False,
				InoculationPaper->Null
			],
			ObjectP[Object[Protocol,MeasureOsmolality]],
			Messages:>{Warning::OsmolalityNoInoculationPaper}
		],
		Example[{Messages,"OsmolalityInoculationPaperHighViscosity","Warn if viscous loading is set/resolved to True, but inoculation paper is set to not Null:"},
			ExperimentMeasureOsmolality[Object[Sample,"Test viscous sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				ViscousLoading->True,
				InoculationPaper->Model[Item,InoculationPaper,"6.7mm diameter solute free paper"]
			],
			ObjectP[Object[Protocol,MeasureOsmolality]],
			Messages:>{Warning::OsmolalityInoculationPaperHighViscosity}
		],
		Example[{Messages,"OsmolalityShortEquilibrationTime","Warn if a short equilibration time is specified and the instrument is the Vapro 5600:"},
			ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				EquilibrationTime->5 Second
			],
			ObjectP[Object[Protocol,MeasureOsmolality]],
			Messages:>{Warning::OsmolalityShortEquilibrationTime}
		],
		Example[{Messages,"OsmolalityViscousTransferMinimumVolume","Warn if viscous loading is specified with a sample volume of less than 10 uL:"},
			ExperimentMeasureOsmolality[Object[Sample,"Test viscous sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				ViscousLoading->True,
				SampleVolume->9 Microliter
			],
			ObjectP[Object[Protocol,MeasureOsmolality]],
			Messages:>{Warning::OsmolalityViscousTransferMinimumVolume}
		],
		Example[{Messages,"OsmolalityControlOsmolalityDeviation","Warn if the osmolality target value for a control differs significantly from the database osmolality:"},
			ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Control->Model[Sample,"Osmolality Standard 1000 mmol/kg Sodium Chloride"],
				ControlOsmolality->900 Millimole/Kilogram
			],
			ObjectP[Object[Protocol,MeasureOsmolality]],
			Messages:>{Warning::OsmolalityControlOsmolalityDeviation}
		],
		Example[{Messages,"OsmolalityControlOsmolalityUnknown","Throw an error if a control with unknown osmolality is specified, but a corresponding target osmolality is not specified:"},
			ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Control->Model[Sample,StockSolution,"Test Saline Model"]
			],
			$Failed,
			Messages:>{Error::OsmolalityControlOsmolalityUnknown,Error::InvalidOption}
		],
		Example[{Messages,"OsmolalityControlTolerance","Warn if the tolerance for a control is tighter than the instrument repeatability and standard tolerances:"},
			ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Control->Model[Sample,"Osmolality Standard 1000 mmol/kg Sodium Chloride"],
				ControlTolerance->1 Millimole/Kilogram
			],
			ObjectP[Object[Protocol,MeasureOsmolality]],
			Messages:>{Warning::OsmolalityControlTolerance}
		],
		Example[{Messages,"OsmolalityControlConflict","Warn if the tolerance for a control is tighter than the instrument repeatability and standard tolerances:"},
			ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Control->Null,
				ControlOsmolality->1000 Millimole/Kilogram
			],
			$Failed,
			Messages:>{Error::OsmolalityControlConflict,Error::InvalidOption}
		],
		(* Demonstration of Options specific to ExperimentMeasureOsmolality*)
		Example[{Options,OsmolalityMethod,"Specify the method/principle to use to measure osmolality:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				OsmolalityMethod->VaporPressureOsmometry,
				Output->Options
			];
			Lookup[options,OsmolalityMethod],
			VaporPressureOsmometry,
			Variables:>{options}
		],
		Example[{Options,Instrument,"Specify the instrument to use to measure osmolality:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Instrument->Object[Instrument,Osmometer,"Test Vapro 5600 Osmometer for ExperimentMeasureOsmolality "<>$SessionUUID],
				Output->Options
			];
			Lookup[options,Instrument],
			ObjectReferenceP[Object[Instrument,Osmometer,"Test Vapro 5600 Osmometer for ExperimentMeasureOsmolality "<>$SessionUUID]],
			Variables:>{options}
		],
		Example[{Options,NumberOfReplicates,"Specify the total number of times to measure the osmolality of the samples, using a fresh aliquot each time:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				NumberOfReplicates->2,
				Output->Options
			];
			Lookup[options,NumberOfReplicates],
			2,
			Variables:>{options}
		],
		Example[{Options,PreClean,"Specify if the thermocouple head is to be cleaned prior to experiment, in addition to after experiment:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				PreClean->True,
				Output->Options
			];
			Lookup[options,PreClean],
			True,
			Variables:>{options}
		],
		Example[{Options,CleaningSolution,"Specify the solution used to clean the thermocouple head of the osmometer instrument:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				CleaningSolution->Model[Sample,"Milli-Q water"],
				Output->Options
			];
			Lookup[options,CleaningSolution],
			ObjectReferenceP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,Calibrant,"Specify the solutions of known osmolality used to calibrate the osmometer instrument:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Calibrant->{Model[Sample,"Osmolality Standard 290 mmol/kg Sodium Chloride"],Model[Sample,"Osmolality Standard 1000 mmol/kg Sodium Chloride"],Model[Sample,"Osmolality Standard 100 mmol/kg Sodium Chloride"]},
				CalibrantOsmolality->{290 Milli Mole/Kilogram,1000 Milli Mole/Kilogram,100 Milli Mole/Kilogram},
				Output->Options
			];
			Lookup[options,Calibrant],
			{
				ObjectReferenceP[Model[Sample,"Osmolality Standard 290 mmol/kg Sodium Chloride"]],
				ObjectReferenceP[Model[Sample,"Osmolality Standard 1000 mmol/kg Sodium Chloride"]],
				ObjectReferenceP[Model[Sample,"Osmolality Standard 100 mmol/kg Sodium Chloride"]]
			},
			Variables:>{options}
		],
		Example[{Options,CalibrantOsmolality,"Specify the osmolalities of the solutions of known osmolality used to calibrate the osmometer instrument:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Calibrant->{Model[Sample,"Osmolality Standard 290 mmol/kg Sodium Chloride"],Model[Sample,"Osmolality Standard 1000 mmol/kg Sodium Chloride"],Model[Sample,"Osmolality Standard 100 mmol/kg Sodium Chloride"]},
				CalibrantOsmolality->{290 Milli Mole/Kilogram,1000 Milli Mole/Kilogram,100 Milli Mole/Kilogram},
				Output->Options
			];
			Lookup[options,CalibrantOsmolality],
			{290 Milli Mole/Kilogram,1000 Milli Mole/Kilogram,100 Milli Mole/Kilogram},
			Variables:>{options}
		],
		Example[{Options,CalibrantVolume,"Specify the volume of calibrants used to calibrate the instrument:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				CalibrantVolume->{10 Microliter,10 Microliter,10 Microliter},
				Output->Options
			];
			Lookup[options,CalibrantVolume],
			{10 Microliter,10 Microliter,10 Microliter},
			Variables:>{options}
		],
		Example[{Options,ViscousLoading,"Specify whether to use specialized loading techniques suitable for highly viscous samples:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test viscous sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				ViscousLoading->{True},
				Output->Options
			];
			Lookup[options,ViscousLoading],
			{True},
			Variables:>{options}
		],
		Example[{Options,InoculationPaper,"Specify the paper to be inoculated with sample during sample loading:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				InoculationPaper->Model[Item,InoculationPaper,"6.7mm diameter solute free paper"],
				Output->Options
			];
			Lookup[options,InoculationPaper],
			ObjectReferenceP[Model[Item,InoculationPaper,"6.7mm diameter solute free paper"]],
			Variables:>{options}
		],
		Example[{Options,SampleVolume,"Specify the volume of sample to be used for the osmolality measurement:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				SampleVolume->{10 Microliter},
				Output->Options
			];
			Lookup[options,SampleVolume],
			{10 Microliter},
			Variables:>{options}
		],
		Example[{Options,NumberOfReadings,"Specify the number of times to measure the osmolality of the same sample, without reloading:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				NumberOfReadings->{10},
				Output->Options
			];
			Lookup[options,NumberOfReadings],
			{10},
			Variables:>{options}
		],
		Example[{Options,EquilibrationTime,"Specify the time duration between the sample being loading into the measurement chamber and the measurement taking place:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				EquilibrationTime->{30 Second},
				Output->Options
			];
			Lookup[options,EquilibrationTime],
			{30 Second},
			Variables:>{options}
		],
		Example[{Options,EquilibrationTime,"Specify the time duration between the sample being loading into the measurement chamber and the measurement taking place:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				EquilibrationTime->{30 Second},
				Output->Options
			];
			Lookup[options,EquilibrationTime],
			{30 Second},
			Variables:>{options}
		],
		Example[{Options,Control,"Specify the standard to use to validate the instrument calibration:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Control->Model[Sample,"Osmolality Standard 280 mmol/kg Protein Based"],
				Output->Options
			];
			Lookup[options,Control],
			ObjectReferenceP[Model[Sample,"Osmolality Standard 280 mmol/kg Protein Based"]],
			Variables:>{options}
		],
		Example[{Options,ControlOsmolality,"Specify the target osmolality for the standards used to validate the instrument calibration:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Control->Model[Sample,"Osmolality Standard 280 mmol/kg Protein Based"],
				ControlOsmolality->280 Millimole/Kilogram,
				Output->Options
			];
			Lookup[options,ControlOsmolality],
			280 Millimole/Kilogram,
			Variables:>{options}
		],
		Example[{Options,ControlVolume,"Specify the volume of standard to use to validate the instrument calibration:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Control->Model[Sample,"Osmolality Standard 280 mmol/kg Protein Based"],
				ControlVolume->9 Microliter,
				Output->Options
			];
			Lookup[options,ControlVolume],
			9 Microliter,
			Variables:>{options}
		],
		Example[{Options,ControlTolerance,"Specify the tolerance within which the measured standard osmolality must match the target value to validate the instrument calibration:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Control->Model[Sample,"Osmolality Standard 280 mmol/kg Protein Based"],
				ControlOsmolality->280 Millimole/Kilogram,
				ControlTolerance->20 Millimole/Kilogram,
				Output->Options
			];
			Lookup[options,ControlTolerance],
			20 Millimole/Kilogram,
			Variables:>{options}
		],
		Example[{Options,MaxNumberOfCalibrations,"Specify the tolerance within which the measured standard osmolality must match the target value to validate the instrument calibration:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				MaxNumberOfCalibrations->1,
				Output->Options
			];
			Lookup[options,MaxNumberOfCalibrations],
			1,
			Variables:>{options}
		],
		Example[{Options,PostRunInstrumentContaminationLevel,"Specify a measurement of thermocouple contamination after the samples have been run:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				PostRunInstrumentContaminationLevel->True,
				Output->Options
			];
			Lookup[options,PostRunInstrumentContaminationLevel],
			True,
			Variables:>{options}
		],
		Example[{Options,NumberOfControlReplicates,"Specify the number of measurements that should be taken, and averaged, for each of the Controls. The mean values are then compared to the ControlTolerances to determine if a calibration was successful:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Control->{Model[Sample,"Osmolality Standard 280 mmol/kg Protein Based"],Model[Sample,"Osmolality Standard 240 mmol/kg Protein Based"]},
				NumberOfControlReplicates->{1,3},
				Output->Options
			];
			Lookup[options,NumberOfControlReplicates],
			{1,3},
			Variables:>{options}
		],
		(* Post processing *)
		Example[{Options,MeasureWeight,"Specify whether to weigh the sample after measurement in the post processing step:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],MeasureWeight->False,Output->Options];
			Lookup[options,MeasureWeight],
			False,
			Variables:>{options}
		],
		Example[{Options,MeasureVolume,"Specify whether to measure the volume of the sample after measurement in the post processing step:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],MeasureVolume->False,Output->Options];
			Lookup[options,MeasureVolume],
			False,
			Variables:>{options}
		],
		Example[{Options,ImageSample,"Specify whether to image the sample after measurement in the post processing step:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				ImageSample->False,
				Output->Options
			];
			Lookup[options,ImageSample],
			False,
			Variables:>{options}
		],
		Example[{Options,PreparatoryUnitOperations,"Specify prepared samples for ExperimentMeasureOsmolality:"},
			options=Quiet[
				ExperimentMeasureOsmolality["My Container for Osmolality Measurements",
					PreparatoryUnitOperations->{
						LabelContainer[
							Label->"My Container for Osmolality Measurements",
							Container->Model[Container,Vessel,"2mL Tube"]
						],
						Transfer[
							Source->Model[Sample,"Milli-Q water"],
							Amount->30 Microliter,
							Destination->"My Container for Osmolality Measurements"
						]
					},
					Output->Options
				],
				Warning::OsmolalityUnknownViscosity
			];
			Lookup[options,SampleVolume],
			10 Microliter,
			Variables:>{options}
		],
		(*incubate options*)
		Example[{Options,Incubate,"Measure the osmolality of a single liquid sample with Incubation before measurement, using the default Incubate parameters:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Incubate->True,
				Output->Options
			];
			Lookup[options,Incubate],
			True,
			Variables:>{options}
		],
		Example[{Options,IncubationTime,"Measure the osmolality of a single liquid sample with Incubation before measurement for 10 minutes:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Incubate->True,
				IncubationTime->10 Minute,
				Output->Options
			];
			Lookup[options,IncubationTime],
			10 Minute,
			Variables:>{options}
		],
		Example[{Options,MaxIncubationTime,"Measure the osmolality of a single liquid sample with MaxIncubation before measurement for 1 hour:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Incubate->True,
				MaxIncubationTime->1 Hour,
				Output->Options
			];
			Lookup[options,MaxIncubationTime],
			1 Hour,
			Variables:>{options}
		],
		Example[{Options,IncubationTemperature,"Measure the osmolality of a single liquid sample with Incubation before measurement for 10 minutes at 30 degrees C:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Incubate->True,
				IncubationTime->10 Minute,
				IncubationTemperature->30 Celsius,
				Output->Options
			];
			Lookup[options,IncubationTemperature],
			30 Celsius,
			Variables:>{options}
		],
		Example[{Options,IncubationInstrument,"Measure the osmolality of a single liquid sample with Incubation before measurement and specify the Incubation instrument:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Incubate->True,
				IncubationInstrument->Model[Instrument,HeatBlock,"Thermal-Lok  2510-1104"],
				Output->Options
			];
			Lookup[options,IncubationInstrument],
			ObjectReferenceP[Model[Instrument,HeatBlock,"Thermal-Lok  2510-1104"]],
			Variables:>{options}
		],
		Example[{Options,IncubateAliquot,"The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				IncubateAliquot->100 Microliter,
				IncubateAliquotContainer->Model[Container,Plate,"96-well PCR Plate"],
				Output->Options
			];
			Lookup[options,IncubateAliquot],
			100 Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotContainer,"The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				IncubateAliquot->90 Microliter,
				IncubateAliquotContainer->Model[Container,Plate,"96-well PCR Plate"],
				Output->Options
			];
			Lookup[options,IncubateAliquotContainer],
			{1,ObjectReferenceP[Model[Container,Plate,"96-well PCR Plate"]]},
			Variables:>{options}
		],
		Example[{Options,Mix,"Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Mix->True,
				Output->Options
			];
			Lookup[options,Mix],
			True,
			Variables:>{options}
		],
		Example[{Options,MixType,"Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Mix->True,
				MixType->Vortex,
				Output->Options
			];
			Lookup[options,MixType],
			Vortex,
			Variables:>{options}
		],
		Example[{Options,MixUntilDissolved,"Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incubation will occur prior to starting the experiment:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				MixUntilDissolved->True,
				MixType->Vortex,
				Output->Options
			];
			Lookup[options,MixUntilDissolved],
			True,
			Variables:>{options}
		],
		Example[{Options,AnnealingTime,"Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				AnnealingTime->40 Minute,
				Output->Options
			];
			Lookup[options,AnnealingTime],
			40 Minute,
			Variables:>{options}
		],
		(*centrifuge options*)
		Example[{Options,Centrifuge,"Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				CentrifugeAliquotContainer->Model[Container,Plate,"96-well PCR Plate"],
				Centrifuge->True,
				Output->Options
			];
			Lookup[options,Centrifuge],
			True,
			Variables:>{options}
		],
		Example[{Options,CentrifugeInstrument,"The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				CentrifugeInstrument->Model[Instrument,Centrifuge,"Avanti J-15R"],
				Output->Options
			];
			Lookup[options,CentrifugeInstrument],
			ObjectReferenceP[Model[Instrument,Centrifuge,"Avanti J-15R"]],
			Variables:>{options}
		],
		Example[{Options,CentrifugeIntensity,"The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				CentrifugeIntensity->1000 RPM,
				Output->Options
			];
			Lookup[options,CentrifugeIntensity],
			1000 RPM,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeTime,"The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				CentrifugeTime->5 Minute,
				Output->Options
			];
			Lookup[options,CentrifugeTime],
			5 Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeTemperature,"The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				CentrifugeTemperature->10 Celsius,
				Output->Options
			];
			Lookup[options,CentrifugeTemperature],
			10 Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquot,"The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				CentrifugeAliquot->100 Microliter,
				CentrifugeAliquotContainer->Model[Container,Plate,"96-well PCR Plate"],
				Output->Options
			];
			Lookup[options,CentrifugeAliquot],
			100*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotContainer,"The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				CentrifugeAliquot->100 Microliter,
				CentrifugeAliquotContainer->Model[Container,Plate,"96-well PCR Plate"],
				Output->Options
			];
			Lookup[options,CentrifugeAliquotContainer],
			{1,ObjectP[Model[Container,Plate,"96-well PCR Plate"]]},
			Variables:>{options}
		],
		(* filter options *)
		Example[{Options,Filtration,"Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"],
				Filtration->True,
				Output->Options
			];
			Lookup[options,Filtration],
			True,
			Variables:>{options}
		],
		Example[{Options,FiltrationType,"The type of filtration method that should be used to perform the filtration:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				FiltrationType->Syringe,
				FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"],
				Output->Options
			];
			Lookup[options,FiltrationType],
			Syringe,
			Variables:>{options}
		],
		Example[{Options,FilterInstrument,"The instrument that should be used to perform the filtration:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				FilterInstrument->Model[Instrument,SyringePump,"NE-1010 Syringe Pump"],
				FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"],
				Output->Options
			];
			Lookup[options,FilterInstrument],
			ObjectP[Model[Instrument,SyringePump,"NE-1010 Syringe Pump"]],
			Variables:>{options}
		],
		Example[{Options,Filter,"The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"],
				Filter->Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"],
				Output->Options
			];
			Lookup[options,Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables:>{options}
		],
		Example[{Options,FilterMaterial,"The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"],
				FilterMaterial->PES,
				Output->Options
			];
			Lookup[options,FilterMaterial],
			PES,
			Variables:>{options}
		],
		Example[{Options,PrefilterMaterial,"The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test large Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				PrefilterMaterial->GxF,
				Output->Options
			];
			Lookup[options,PrefilterMaterial],
			GxF,
			Variables:>{options}
		],
		Example[{Options,FilterPoreSize,"The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"],
				FilterPoreSize->0.22 Micrometer,
				Output->Options
			];
			Lookup[options,FilterPoreSize],
			0.22 Micrometer,
			Variables:>{options}
		],
		Example[{Options,PrefilterPoreSize,"The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test large Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				PrefilterPoreSize->1. Micrometer,
				Output->Options
			];
			Lookup[options,PrefilterPoreSize],
			1. Micrometer,
			Variables:>{options}
		],
		Example[{Options,FilterSyringe,"The syringe used to force that sample through a filter:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"],
				FiltrationType->Syringe,
				FilterSyringe->Model[Container, Syringe, "id:AEqRl9Kz1VD1"],
				Output->Options
			];
			Lookup[options,FilterSyringe],
			ObjectP[Model[Container, Syringe, "id:AEqRl9Kz1VD1"]],
			Variables:>{options}
		],
		Example[{Options,FilterHousing,"The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				FilterHousing->Model[Instrument,FilterBlock,"Filter Block"],
				FiltrationType->Vacuum,
				Output->Options
			];
			Lookup[options,FilterHousing],
			ObjectP[Model[Instrument,FilterBlock,"Filter Block"]],
			Variables:>{options}
		],
		Example[{Options,FilterIntensity,"The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"],
				FilterAliquot->90 Microliter,
				FiltrationType->Centrifuge,
				FilterIntensity->1000 RPM,
				Output->Options
			];
			Lookup[options,FilterIntensity],
			1000 RPM,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterTime,"The amount of time for which the samples will be centrifuged during filtration:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"],
				FilterAliquot->90 Microliter,
				FiltrationType->Centrifuge,
				FilterTime->20 Minute,
				Output->Options
			];
			Lookup[options,FilterTime],
			20 Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterTemperature,"The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"],
				FilterAliquot->90 Microliter,
				FiltrationType->Centrifuge,
				FilterTemperature->22 Celsius,
				Output->Options
			];
			Lookup[options,FilterTemperature],
			22 Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterSterile,"Indicates if the filtration of the samples should be done in a sterile environment:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"],
				FilterSterile->False,
				Output->Options
			];
			Lookup[options,FilterSterile],
			False,
			Variables:>{options}
		],
		Example[{Options,FilterAliquot,"The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"],
				FilterAliquot->95 Microliter,
				Output->Options
			];
			Lookup[options,FilterAliquot],
			95 Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterAliquotContainer,"The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				FilterAliquotContainer->Model[Container,Vessel,"2mL Tube"],
				FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"],
				Output->Options
			];
			Lookup[options,FilterAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options}
		],
		Example[{Options,FilterContainerOut,"The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"],
				Output->Options
			];
			Lookup[options,FilterContainerOut],
			{1,ObjectP[Model[Container,Plate,"96-well PCR Plate"]]},
			Variables:>{options}
		],

		(*Aliquot options*)
		Example[{Options,Aliquot,"Measure the osmolality of a single liquid sample by first aliquoting the sample:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Aliquot->True,
				Output->Options
			];
			Lookup[options,Aliquot],
			True,
			Variables:>{options}
		],
		Example[{Options,AliquotAmount,"The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				AliquotAmount->95 Microliter,
				AliquotContainer->Model[Container,Vessel,"1mL HPLC Vial (total recovery) with Cap and PTFE/Silicone Septum"],
				Output->Options
			];
			Lookup[options,AliquotAmount],
			95 Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,AssayVolume,"The desired total volume of the aliquoted sample plus dilution buffer:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				AssayVolume->95 Microliter,
				Output->Options
			];
			Lookup[options,AssayVolume],
			95 Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentration,"The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test sample with composition for ExperimentMeasureOsmolality "<>$SessionUUID],
				TargetConcentration->5 Micromolar,
				Output->Options
			];
			Lookup[options,TargetConcentration],
			5 Micromolar,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentrationAnalyte,"Set the TargetConcentrationAnalyte option to specify which analyte to achieve the desired TargetConcentration for dilution of aliquots of SamplesIn:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test sample with composition for ExperimentMeasureOsmolality "<>$SessionUUID],
				TargetConcentration->5 Micromolar,
				TargetConcentrationAnalyte->Model[Molecule,"Uracil"],
				Output->Options
			];
			Lookup[options,TargetConcentrationAnalyte],
			ObjectP[Model[Molecule,"Uracil"]],
			Variables:>{options}
		],
		Example[{Options,ConcentratedBuffer,"The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],
				AliquotAmount->50 Microliter,
				AssayVolume->200 Microliter,
				AliquotContainer->Model[Container,Plate,"96-well PCR Plate"],
				Output->Options
			];
			Lookup[options,ConcentratedBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,BufferDilutionFactor,"The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				BufferDilutionFactor->2,
				ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],
				AliquotAmount->25 Microliter,
				AssayVolume->200 Microliter,
				AliquotContainer->Model[Container,Plate,"96-well PCR Plate"],
				Output->Options
			];
			Lookup[options,BufferDilutionFactor],
			2,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,BufferDiluent,"The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				BufferDiluent->Model[Sample,"Milli-Q water"],
				BufferDilutionFactor->2,
				ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],
				AliquotAmount->25 Microliter,
				AssayVolume->200 Microliter,
				AliquotContainer->Model[Container,Plate,"96-well PCR Plate"],
				Output->Options
			];
			Lookup[options,BufferDiluent],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,AssayBuffer,"The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				AssayBuffer->Model[Sample,StockSolution,"10x UV buffer"],
				AliquotAmount->25 Microliter,
				AssayVolume->200 Microliter,
				AliquotContainer->Model[Container,Plate,"96-well PCR Plate"],
				Output->Options
			];
			Lookup[options,AssayBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,AliquotSampleStorageCondition,"The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				AliquotSampleStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,AliquotSampleStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,AliquotSampleLabel,"Specify a label for the aliquoted sample:"},
			options=ExperimentMeasureOsmolality[
				Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Aliquot->True,
				AliquotSampleLabel->"Test Label for ExperimentMeasureOsmolality 1",
				Output->Options
			];
			Lookup[options,AliquotSampleLabel],
			{"Test Label for ExperimentMeasureOsmolality 1"},
			Variables:>{options}
		],
		Example[{Options,ConsolidateAliquots,"Indicates if identical aliquots should be prepared in the same container/position:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				ConsolidateAliquots->True,
				Output->Options
			];
			Lookup[options,ConsolidateAliquots],
			True,
			Variables:>{options}
		],
		Example[{Options,AliquotPreparation,"Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Aliquot->True,
				AliquotPreparation->Manual,
				Output->Options
			];
			Lookup[options,AliquotPreparation],
			Manual,
			Variables:>{options}
		],
		Example[{Options,AliquotContainer,"The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				AliquotContainer->Model[Container,Vessel,"1mL HPLC Vial (total recovery) with Cap and PTFE/Silicone Septum"],
				Output->Options
			];
			Lookup[options,AliquotContainer],
			{{1, ObjectReferenceP[Model[Container, Vessel, "1mL HPLC Vial (total recovery) with Cap and PTFE/Silicone Septum"]]}},
			Variables:>{options}
		],
		Example[{Options,SamplesInStorageCondition,"Indicates how the input samples of the experiment should be stored:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				SamplesInStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotDestinationWell,"Indicates how the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				IncubateAliquotContainer->Model[Container,Plate,"96-well PCR Plate"],
				IncubateAliquotDestinationWell->"A1",
				Output->Options
			];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotDestinationWell,"Indicates how the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				CentrifugeAliquotDestinationWell->"A1",
				CentrifugeAliquotContainer->Model[Container,Plate,"96-well PCR Plate"],
				Output->Options
			];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,FilterAliquotDestinationWell,"Indicates how the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				FilterAliquotDestinationWell->"A1",
				FilterAliquotContainer->Model[Container,Vessel,"2mL Tube"],
				FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"],
				Output->Options
			];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,DestinationWell,"Indicates how the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				DestinationWell->"A1",
				Output->Options
			];
			Lookup[options,DestinationWell],
			{"A1"},
			Variables:>{options}
		],
		Example[{Options,Name,"Specify the name of a protocol:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Name->"My Exploratory Osmolality Test Protocol",
				Output->Options
			];
			Lookup[options,Name],
			"My Exploratory Osmolality Test Protocol",
			Variables:>{options}
		],
		Example[{Options,Template,"Inherit options from a previously run protocol:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Template->Object[Protocol,MeasureOsmolality,"Test Template MeasureOsmolality Protocol for ExperimentMeasureOsmolality "<>$SessionUUID],
				Output->Options
			];
			Lookup[options,EquilibrationTime],
			101 Second,
			Variables:>{options}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentMeasureOsmolality[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container,Vessel,"2mL Tube"],
				PreparedModelAmount -> 20 Microliter,
				Output -> Options
			];
			prepUOs = Lookup[options, PreparatoryUnitOperations];
			{
				prepUOs[[-1, 1]][Sample],
				prepUOs[[-1, 1]][Container],
				prepUOs[[-1, 1]][Amount],
				prepUOs[[-1, 1]][Well],
				prepUOs[[-1, 1]][ContainerLabel]
			},
			{
				{ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]]..},
				{ObjectP[Model[Container, Vessel, "2mL Tube"]]..},
				{EqualP[20 Microliter]..},
				{"A1", "A1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],

		Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
			ExperimentMeasureOsmolality[
				Model[Sample, "Ammonium hydroxide"],
				PreparedModelAmount -> 0.5 Milliliter,
				Aliquot -> True,
				Mix -> True,
				ViscousLoading -> False
			],
			ObjectP[Object[Protocol, MeasureOsmolality]]
		],

		Example[{Additional,"Use the sample preparation options to prepare samples before the main experiment:"},
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Incubate->True,
				Centrifuge->True,
				Filtration->True,
				Aliquot->True,
				Output->Options
			];
			{Lookup[options,Incubate],Lookup[options,Centrifuge],Lookup[options,Filtration],Lookup[options,Aliquot]},
			{True,True,True,True},
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Additional,"If control replicates are specified, members of the Control option are expanded by those replicates in the Control field. ControlOsmolalities and ControlTolerances are stored per batch of replicates:"},
			Download[
				ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
					Control->{
						Model[Sample,"Osmolality Standard 290 mmol/kg Sodium Chloride"],
						Model[Sample,"Osmolality Standard 100 mmol/kg Sodium Chloride"]
					},
					NumberOfControlReplicates->{
						3,
						1
					},
					ControlOsmolality->{
						290 Millimole/Kilogram,
						100 Millimole/Kilogram
					},
					ControlTolerance->5 Millimole/Kilogram
				],
				{
					Controls,
					NumberOfControlReplicates,
					ControlOsmolalities,
					ControlTolerances
				}
			],
			{
				LinkP/@{Model[Sample,"Osmolality Standard 290 mmol/kg Sodium Chloride"],Model[Sample,"Osmolality Standard 290 mmol/kg Sodium Chloride"],Model[Sample,"Osmolality Standard 290 mmol/kg Sodium Chloride"],Model[Sample,"Osmolality Standard 100 mmol/kg Sodium Chloride"]},
				{3,1},
				{EqualP[290 Millimole/Kilogram],EqualP[100 Millimole/Kilogram]},
				{EqualP[5 Millimole/Kilogram],EqualP[5 Millimole/Kilogram]}
			}
		],
		(* Additional tests *)
		Test["Calibrants can be specified by object:",
			protocol=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Calibrant->{
					Object[Sample,"Test 290 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID],
					Object[Sample,"Test 1000 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID],
					Object[Sample,"Test 100 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID]
				}
			];
			Download[protocol,Calibrants],
			{
				ObjectP[Object[Sample,"Test 290 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID]],
				ObjectP[Object[Sample,"Test 1000 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID]],
				ObjectP[Object[Sample,"Test 100 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID]]
			},
			Variables:>{protocol}
		],
		(* Resource packet tests *)
		Test["The osmometer instrument resource is created:",
			protocol=ExperimentMeasureOsmolality[Object[Sample,"Test viscous sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Instrument->Object[Instrument,Osmometer,"Test Vapro 5600 Osmometer for ExperimentMeasureOsmolality "<>$SessionUUID]
			];
			Download[protocol,{Instrument}],
			{
				ObjectP[Object[Instrument,Osmometer,"Test Vapro 5600 Osmometer for ExperimentMeasureOsmolality "<>$SessionUUID]]
			},
			Variables:>{protocol}
		],
		Test["If a non-viscous sample is provided, with 10 uL sample volume, the standard pipette and tip is used:",
			protocol=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				SampleVolume->10 Microliter
			];
			Download[protocol,{Pipettes,PipetteTips}],
			{
				{ObjectP[Model[Instrument,Pipette,"AC-037 10 uL Pipette, Vapro 5600"]]},
				{ObjectP[Model[Item,Tips]]}
			},
			Variables:>{protocol}
		],
		Test["If a viscous sample is provided, a positive displacement pipette is used, with appropriate tip volume:",
			protocol=ExperimentMeasureOsmolality[Object[Sample,"Test viscous sample for ExperimentMeasureOsmolality "<>$SessionUUID]];
			{pipettes,volumes,min,max}=Download[protocol,{Pipettes,SampleVolumes,PipetteTips[MinVolume],PipetteTips[MaxVolume]}];
			{pipettes[[1]],volumes[[1]]},
			{
				ObjectP[Model[Instrument,Pipette,"Pos-D MR-100"]],
				RangeP[First[min],First[max]]
			},
			Variables:>{protocol,pipettes,volumes,min,max}
		],
		Test["If viscous loading is specified for a non-viscous sample, a positive displacement pipette is used, with appropriate tip volume:",
			protocol=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				ViscousLoading->True
			];
			{pipetteTypes,volumes,min,max}=Download[protocol,{Pipettes[PipetteType],SampleVolumes,PipetteTips[MinVolume],PipetteTips[MaxVolume]}];
			{pipetteTypes[[1]],volumes[[1]]},
			{
				PositiveDisplacement,
				RangeP[First[min],First[max]]
			},
			Variables:>{protocol,pipetteTypes,volumes,min,max},
			Messages:>{Warning::OsmolalitySampleCarryOver}
		],
		Test["If a non-viscous sample is provided, with less than 10 uL sample volume, a micropipette is used, with appropriate tip volume:",
			protocol=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				SampleVolume->9 Microliter
			];
			{pipetteTypes,volumes,min,max}=Download[protocol,{Pipettes[PipetteType],SampleVolumes,PipetteTips[MinVolume],PipetteTips[MaxVolume]}];
			{pipetteTypes,volumes},
			{
				{Micropipette},
				{RangeP[First[min],First[max]]}
			},
			Variables:>{protocol,pipetteTypes,volumes,min,max}
		],
		Test["If a non-viscous sample is provided, with more than 10 uL sample volume, a micropipette is used with appropriate tip volume:",
			protocol=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				SampleVolume->11 Microliter
			];
			{pipetteTypes,volumes,min,max}=Download[protocol,{Pipettes[PipetteType],SampleVolumes,PipetteTips[MinVolume],PipetteTips[MaxVolume]}];
			{pipetteTypes,volumes},
			{
				{Micropipette},
				{RangeP[First[min],First[max]]}
			},
			Variables:>{protocol,pipetteTypes,volumes,min,max}
		],
		Test["If a non-viscous sample is provided, inoculation paper is used:",
			protocol=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID]];
			Download[protocol,{InoculationPapers}],
			{
				{ObjectP[Model[Item,InoculationPaper]]}
			},
			Variables:>{protocol}
		],
		Test["If inoculation paper is used, tweezers are gathered:",
			protocol=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				InoculationPaper->Model[Item,InoculationPaper,"6.7mm diameter solute free paper"]
			];
			Download[protocol,Tweezers],
			{
				ObjectP[Model[Item,Tweezer]]
			},
			Variables:>{protocol}
		],
		Test["Calibrant resources are generated for each calibrant:",
			protocol=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID]];
			Download[protocol,{Calibrants}],
			{ConstantArray[ObjectP[Model[Sample]],3]},
			Variables:>{protocol}
		],
		Test["Equilibration times are parsed into internal default equilibration times and equilibration times:",
			protocol=ExperimentMeasureOsmolality[{Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID]},
				EquilibrationTime->{Automatic,30 Second}
			];
			Download[protocol,{EquilibrationTimes,InternalDefaultEquilibrationTimes}],
			{
				{Null,EqualP[30 Second]},
				{True,False}
			},
			Variables:>{protocol}
		],
		(* Verify that an additional 100 mmol/kg standard is populated if measuring thermocouple contamination at the end of the protocol *)
		Test["If a measurement of thermocouple contamination after the samples have been run is specified, an additional 100 mmol/kg standard is requested with appropriate resources:",
			Download[
				ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
					PostRunInstrumentContaminationLevel->True
				],
				{
					PostRunInstrumentContaminationStandard,
					PostRunInstrumentContaminationInoculationPapers,
					PostRunInstrumentContaminationTweezers,
					PostRunInstrumentContaminationPipettes,
					PostRunInstrumentContaminationPipetteTips
				}
			],
			{
				LinkP[Model[Sample,"Osmolality Standard 100 mmol/kg Sodium Chloride"]],
				LinkP[Model[Item,InoculationPaper]],
				LinkP[Model[Item,Tweezer]],
				LinkP[Model[Instrument,Pipette]],
				LinkP[Model[Item,Tips]]
			}
		],
		Test["If a measurement of thermocouple contamination after the samples have been run is not specified, do not request the additional resources:",
			Download[
				ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
					PostRunInstrumentContaminationLevel->False
				],
				{
					PostRunInstrumentContaminationStandard,
					PostRunInstrumentContaminationInoculationPapers,
					PostRunInstrumentContaminationTweezers,
					PostRunInstrumentContaminationPipettes,
					PostRunInstrumentContaminationPipetteTips
				}
			],
			{
				Null,
				Null,
				Null,
				Null,
				Null
			}
		],
		(* Verify calibration resolution *)
		Test["If calibrants and calibrant osmolalities are automatic, they resolve to the manufacturer recommended values of the instrument:",
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Instrument->Model[Instrument,Osmometer,"Vapro 5600"],
				Calibrant->Automatic,
				CalibrantOsmolality->Automatic,
				Output->Options
			];
			Lookup[options,{Calibrant,CalibrantOsmolality}],
			{ObjectP[#]&/@Model[Instrument,Osmometer,"Vapro 5600"][ManufacturerCalibrants],Model[Instrument,Osmometer,"Vapro 5600"][ManufacturerCalibrantOsmolalities]},
			Variables:>{options}
		],
		(* Verify viscous loading and inoculation paper resolution *)
		Test["If a non-viscous sample is supplied, viscous loading resolves to False, and Inoculation Paper resolves to the default type:",
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Output->Options
			];
			Lookup[options,{ViscousLoading,InoculationPaper}],
			{False,ObjectP[Model[Item,InoculationPaper,"6.7mm diameter solute free paper"]]},
			Variables:>{options}
		],
		Test["If a viscous sample is supplied, viscous loading resolves to True, and Inoculation Paper resolves to Null:",
			options=ExperimentMeasureOsmolality[Object[Sample,"Test viscous sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Output->Options
			];
			Lookup[options,{ViscousLoading,InoculationPaper}],
			{True,Null},
			Variables:>{options}
		],
		(* Verify equilibration times resolution *)
		(* If a non-viscous sample is given with 1 readings, equilibration time -> InternalDefault *)
		Test["If a non-viscous sample is supplied, with 1 reading, equilibration time resolves to InternalDefault:",
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				NumberOfReadings->1,
				Output->Options
			];
			Lookup[options,EquilibrationTime],
			InternalDefault,
			Variables:>{options}
		],
		(* If a non-viscous sample is given with 10 readings, equilibration time -> InternalDefault *)
		Test["If a non-viscous sample is supplied, with 10 readings, equilibration time resolves to InternalDefault:",
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				NumberOfReadings->10,
				Output->Options
			];
			Lookup[options,EquilibrationTime],
			InternalDefault,
			Variables:>{options}
		],
		(* If a non-viscous sample is given with 2 readings, equilibration time -> 60 Second *)
		Test["If a non-viscous sample is supplied, with 2 readings, equilibration time resolves to 60 seconds:",
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				NumberOfReadings->2,
				Output->Options
			];
			Lookup[options,EquilibrationTime],
			60 Second,
			Variables:>{options}
		],
		(* If a viscous sample is given with 1 readings, equilibration time -> InternalDefault *)
		Test["If a viscous sample is supplied, with 1 reading, equilibration time resolves to InternalDefault:",
		options=ExperimentMeasureOsmolality[Object[Sample,"Test viscous sample for ExperimentMeasureOsmolality "<>$SessionUUID],
			NumberOfReadings->1,
			Output->Options
		];
		Lookup[options,EquilibrationTime],
			InternalDefault,
			Variables:>{options}
		],
		(* If a viscous sample is given with 10 readings, equilibration time -> InternalDefault *)
		Test["If a viscous sample is supplied, with 10 readings, equilibration time resolves to InternalDefault:",
			options=ExperimentMeasureOsmolality[Object[Sample,"Test viscous sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				NumberOfReadings->10,
				Output->Options
			];
			Lookup[options,EquilibrationTime],
			InternalDefault,
			Variables:>{options}
		],
		(* If a viscous sample is given with 2 readings, equilibration time -> 60 Second *)
		Test["If a viscous sample is supplied, with 2 readings, equilibration time resolves to 60 seconds:",
			options=ExperimentMeasureOsmolality[Object[Sample,"Test viscous sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				NumberOfReadings->2,
				Output->Options
			];
			Lookup[options,EquilibrationTime],
			60 Second,
			Variables:>{options}
		],
		(* If cleaning solution is not specified, it defaults to manufacturer recommended *)
		Test["If CleaningSolution is not specified, it resolves to the manufacturer recommended solution:",
			options=ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Instrument->Model[Instrument,Osmometer,"Vapro 5600"],
				CleaningSolution->Automatic,
				Output->Options
			];
			Lookup[options,CleaningSolution],
			ObjectReferenceP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		(* Verify resources etc for control replicates *)
		Test["If control replicates are specified, NumberOfControlReplicates, ControlTolerances and ControlOsmolalities index match the Control option - 1 per control group. The other control fields index match the controls expanded for the NumberOfControlReplicates:",
			Download[
				ExperimentMeasureOsmolality[Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
					Control->{
						Model[Sample,"Osmolality Standard 290 mmol/kg Sodium Chloride"],
						Model[Sample,"Osmolality Standard 100 mmol/kg Sodium Chloride"]
					},
					NumberOfControlReplicates->{
						3,
						1
					}
				],
				{
					NumberOfControlReplicates,
					ControlTolerances,
					ControlOsmolalities,
					Controls,
					ControlPipettes,
					ControlPipetteTips,
					ControlVolumes,
					ControlInoculationPapers,
					ControlTweezers
				}
			],
			{
				{3,1},
				{GreaterP[0 Millimole/Kilogram],GreaterP[0 Millimole/Kilogram]},
				{GreaterP[0 Millimole/Kilogram],GreaterP[0 Millimole/Kilogram]},
				LinkP/@{Model[Sample,"Osmolality Standard 290 mmol/kg Sodium Chloride"],Model[Sample,"Osmolality Standard 290 mmol/kg Sodium Chloride"],Model[Sample,"Osmolality Standard 290 mmol/kg Sodium Chloride"],Model[Sample,"Osmolality Standard 100 mmol/kg Sodium Chloride"]},
				ConstantArray[LinkP[Model[Instrument,Pipette]],4],
				ConstantArray[LinkP[Model[Item,Tips]],4],
				ConstantArray[EqualP[10 Microliter],4],
				ConstantArray[LinkP[Model[Item,InoculationPaper]],4],
				ConstantArray[LinkP[Model[Item,Tweezer]],4]
			}
		]
	},
	SetUp:>{
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
	},
	TearDown:>{
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	},
	SymbolSetUp:>{

		Module[
			{
				testObjList,existsFilter,
				cache,

				containerIDs,
				testBench,
				testContainer1,testContainer2,testContainer3,testContainer4,testContainer5,testContainer6,
				testContainer7,testContainer8,testContainer9,testContainer10,testContainer11,testContainer12,
				testContainer13,testContainer14,testContainer15, testContainer16,
				benchPacket,containerPackets,

				sampleIDs,
				testSample,testSampleDiscarded,testSampleNullVolume,testSampleNoModel,testSampleNoContainer,
				testSampleSolid,testSampleViscous,testSampleCalibrant240,testSampleCalibrant280,testSampleCalibrant320,
				testSampleCalibrant100,testSampleCalibrant290,testSampleCalibrant1000,
				testSampleNoViscosity,testSampleWithConcentration,testSampleLarge,
				samplePackets,sampleChangePackets,

				instrumentIDs,
				testOsmometer,testPipette,
				instrumentPackets,

				protocolIDs,
				testProtocolTemplate,
				protocolPackets,

				uploadPackets
			},

			testObjList={
				Object[Container,Bench,"Test bench for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 1 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 2 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 3 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 4 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 5 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 6 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 7 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 8 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 9 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 10 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 11 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 50 mL Tube 1 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 1 mL Ampoule 1 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 1 mL Ampoule 2 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 1 mL Ampoule 3 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 50 mL Tube 2 for ExperimentMeasureOsmolality "<>$SessionUUID],

				Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test discarded Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test Milli-Q water sample with no volume for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test Milli-Q water sample with no model for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test Milli-Q water sample with no container for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test solid sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test viscous sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test sample with Null viscosity for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test sample with composition for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test large Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test 240 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test 280 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test 320 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test 100 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test 290 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test 1000 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID],

				Object[Instrument,Osmometer,"Test Vapro 5600 Osmometer for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Instrument,Pipette,"Test 10uL pipette for ExperimentMeasureOsmolality "<>$SessionUUID],

				Object[Protocol,MeasureOsmolality,"Test Template MeasureOsmolality Protocol for ExperimentMeasureOsmolality "<>$SessionUUID]
			};

			(* Erase any objects that we failed to erase in the last unit test teardown *)
			existsFilter=DatabaseMemberQ[testObjList];

			EraseObject[PickList[testObjList,existsFilter],Force->True,Verbose->False];

			(* Create correct number of IDs of type from created objects list *)
			createIDs[type:TypeP[]]:=CreateID[ConstantArray[type,Count[testObjList,ObjectReferenceP[type]]]];

			{
				testBench
			}=createIDs[Object[Container,Bench]];

			{
				testContainer1,
				testContainer2,
				testContainer3,
				testContainer4,
				testContainer5,
				testContainer6,
				testContainer7,
				testContainer8,
				testContainer9,
				testContainer10,
				testContainer11,
				testContainer12,
				testContainer13,
				testContainer14,
				testContainer15,
				testContainer16
			}=containerIDs=createIDs[Object[Container,Vessel]];

			{
				testSample,
				testSampleDiscarded,
				testSampleNullVolume,
				testSampleNoModel,
				testSampleNoContainer,
				testSampleSolid,
				testSampleViscous,
				testSampleNoViscosity,
				testSampleWithConcentration,
				testSampleLarge,
				testSampleCalibrant240,
				testSampleCalibrant280,
				testSampleCalibrant320,
				testSampleCalibrant100,
				testSampleCalibrant290,
				testSampleCalibrant1000
			}=sampleIDs=createIDs[Object[Sample]];

			{
				testOsmometer,
				testPipette
			}=instrumentIDs=Join[createIDs[Object[Instrument,Osmometer]],createIDs[Object[Instrument,Pipette]]];

			{
				testProtocolTemplate
			}=protocolIDs=createIDs[Object[Protocol,MeasureOsmolality]];

			(* Create the bench for testing *)
			benchPacket=<|
				Object->testBench,
				Name->"Test bench for ExperimentMeasureOsmolality "<>$SessionUUID,
				Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects]
			|>;

			(* Keep a rolling cache so that we can reduce the number of uploads *)
			cache=Experiment`Private`FlattenCachePackets[{benchPacket}];

			(* Create some containers *)
			containerPackets=UploadSample[
				{
					(*1*)Model[Container,Vessel,"2mL Tube"],
					(*2*)Model[Container,Vessel,"2mL Tube"],
					(*3*)Model[Container,Vessel,"2mL Tube"],
					(*4*)Model[Container,Vessel,"2mL Tube"],
					(*5*)Model[Container,Vessel,"2mL Tube"],
					(*6*)Model[Container,Vessel,"2mL Tube"],
					(*7*)Model[Container,Vessel,"2mL Tube"],
					(*8*)Model[Container,Vessel,"2mL Tube"],
					(*9*)Model[Container,Vessel,"2mL Tube"],
					(*10*)Model[Container,Vessel,"2mL Tube"],
					(*11*)Model[Container,Vessel,"2mL Tube"],
					(*12*)Model[Container,Vessel,"50mL Tube"],
					(*13*)Model[Container,Vessel,"1mL clear glass ampule"],
					(*14*)Model[Container,Vessel,"1mL clear glass ampule"],
					(*15*)Model[Container,Vessel,"1mL clear glass ampule"],
					(*16*)Model[Container,Vessel,"50mL Tube"]
				},
				{
					(*1*){"Bench Top Slot",testBench},
					(*2*){"Bench Top Slot",testBench},
					(*3*){"Bench Top Slot",testBench},
					(*4*){"Bench Top Slot",testBench},
					(*5*){"Bench Top Slot",testBench},
					(*6*){"Bench Top Slot",testBench},
					(*7*){"Bench Top Slot",testBench},
					(*8*){"Bench Top Slot",testBench},
					(*9*){"Bench Top Slot",testBench},
					(*10*){"Bench Top Slot",testBench},
					(*11*){"Bench Top Slot",testBench},
					(*12*){"Bench Top Slot",testBench},
					(*13*){"Bench Top Slot",testBench},
					(*14*){"Bench Top Slot",testBench},
					(*15*){"Bench Top Slot",testBench},
					(*16*){"Bench Top Slot",testBench}
				},
				ID->{
					(*1*)testContainer1,
					(*2*)testContainer2,
					(*3*)testContainer3,
					(*4*)testContainer4,
					(*5*)testContainer5,
					(*6*)testContainer6,
					(*7*)testContainer7,
					(*8*)testContainer8,
					(*9*)testContainer9,
					(*10*)testContainer10,
					(*11*)testContainer11,
					(*12*)testContainer12,
					(*13*)testContainer13,
					(*14*)testContainer14,
					(*15*)testContainer15,
					(*16*)testContainer16
				}[ID],
				Name->{
					(*1*)"Test 2 mL Tube 1 for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*2*)"Test 2 mL Tube 2 for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*3*)"Test 2 mL Tube 3 for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*4*)"Test 2 mL Tube 4 for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*5*)"Test 2 mL Tube 5 for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*6*)"Test 2 mL Tube 6 for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*7*)"Test 2 mL Tube 7 for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*8*)"Test 2 mL Tube 8 for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*9*)"Test 2 mL Tube 9 for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*10*)"Test 2 mL Tube 10 for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*11*)"Test 2 mL Tube 11 for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*12*)"Test 50 mL Tube 1 for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*13*)"Test 1 mL Ampoule 1 for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*14*)"Test 1 mL Ampoule 2 for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*15*)"Test 1 mL Ampoule 3 for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*16*)"Test 50 mL Tube 2 for ExperimentMeasureOsmolality " <> $SessionUUID
				},
				Cache->cache,
				Upload->False
			];

			cache=Experiment`Private`FlattenCachePackets[{cache,containerPackets}];

			samplePackets=UploadSample[
				{
					(*1*)Model[Sample,"Milli-Q water"],
					(*2*)Model[Sample,"Milli-Q water"],
					(*3*)Model[Sample,"Milli-Q water"],
					(*4*)Model[Sample,"Milli-Q water"],(* This will be overwritten with Null later *)
					(*5*)Model[Sample,"Milli-Q water"],
					(*6*)Model[Sample,"Fluorescein, sodium salt"],
					(*7*)Model[Sample,"Polysorbate 20"],
					(*8*)Model[Sample,"Milli-Q water"],
					(*9*)Model[Sample,StockSolution,"Red Food Dye Test Solution"],
					(*10*)Model[Sample,"Milli-Q water"],
					(*11*)Model[Sample,"Osmolality Standard 240 mmol/kg Protein Based"],
					(*12*)Model[Sample,"Osmolality Standard 280 mmol/kg Protein Based"],
					(*13*)Model[Sample,"Osmolality Standard 320 mmol/kg Protein Based"],
					(*14*)Model[Sample,"Osmolality Standard 100 mmol/kg Sodium Chloride"],
					(*15*)Model[Sample,"Osmolality Standard 290 mmol/kg Sodium Chloride"],
					(*16*)Model[Sample,"Osmolality Standard 1000 mmol/kg Sodium Chloride"]
				},
				{
					(*1*){"A1",testContainer1},
					(*2*){"A1",testContainer2},
					(*3*){"A1",testContainer3},
					(*4*){"A1",testContainer4},
					(*5*){"A1",testContainer4},(* This will be overwritten with Null later *)
					(*6*){"A1",testContainer5},
					(*7*){"A1",testContainer6},
					(*8*){"A1",testContainer7},
					(*9*){"A1",testContainer8},
					(*10*){"A1",testContainer12},
					(*11*){"A1",testContainer9},
					(*12*){"A1",testContainer10},
					(*13*){"A1",testContainer11},
					(*14*){"A1",testContainer16},
					(*15*){"A1",testContainer13},
					(*16*){"A1",testContainer14}
				},
				InitialAmount->{
					(*1*)100 Microliter,
					(*2*)100 Microliter,
					(*3*)Null,
					(*4*)100 Microliter,
					(*5*)100 Microliter,
					(*6*)100 Milligram,
					(*7*)100 Microliter,
					(*8*)100 Microliter,
					(*9*)100 Microliter,
					(*10*)10 Milliliter,
					(*11*)100 Microliter,
					(*12*)100 Microliter,
					(*13*)100 Microliter,
					(*14*)1 Milliliter,
					(*15*)1 Milliliter,
					(*16*)1 Milliliter
				},
				ID->{
					(*1*)testSample,
					(*2*)testSampleDiscarded,
					(*3*)testSampleNullVolume,
					(*4*)testSampleNoModel,
					(*5*)testSampleNoContainer,
					(*6*)testSampleSolid,
					(*7*)testSampleViscous,
					(*8*)testSampleNoViscosity,
					(*9*)testSampleWithConcentration,
					(*10*)testSampleLarge,
					(*11*)testSampleCalibrant240,
					(*12*)testSampleCalibrant280,
					(*13*)testSampleCalibrant320,
					(*14*)testSampleCalibrant100,
					(*15*)testSampleCalibrant290,
					(*16*)testSampleCalibrant1000
				}[ID],
				Name->{
					(*1*)"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*2*)"Test discarded Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*3*)"Test Milli-Q water sample with no volume for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*4*)"Test Milli-Q water sample with no model for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*5*)"Test Milli-Q water sample with no container for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*6*)"Test solid sample for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*7*)"Test viscous sample for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*8*)"Test sample with Null viscosity for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*9*)"Test sample with composition for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*10*)"Test large Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*11*)"Test 240 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*12*)"Test 280 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*13*)"Test 320 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*14*)"Test 100 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*15*)"Test 290 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID,
					(*16*)"Test 1000 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID
				},
				Cache->cache,
				Upload->False,
				(* FastTrack -> True here because we're doing shenanigans uploading two samples to the same container (but then moving them to Null later) *)
				FastTrack -> True
			];

			cache=Experiment`Private`FlattenCachePackets[{cache,samplePackets}];

			(* Generate some change packets to give our samples their unique identities *)
			sampleChangePackets=Flatten[{
				(* Function requires viscosity of samples to be populated to avoid advisory warning *)
				(* Discard one sample *)
				UploadSampleStatus[testSampleDiscarded,Discarded,Upload->False,FastTrack->True,Cache->cache],
				<|Object->testSampleDiscarded,Viscosity->1 Milli Pascal Second|>,

				(* Set volume of Null volume sample *)
				<|Object->testSampleNullVolume,Volume->Null,Viscosity->1 Milli Pascal Second|>,

				(* Remove model from no-model sample *)
				<|Object->testSampleNoModel,Model->Null,Viscosity->1 Milli Pascal Second|>,

				(* Remove container from containerless sample *)
				<|Object->testSampleNoContainer,Container->Null,Position->Null,Replace[LocationLog]->{},Viscosity->1 Milli Pascal Second|>,

				(* Set the viscosity of our viscous sample *)
				<|Object->testSampleViscous,Viscosity->400 Milli Pascal Second|>,

				(* Ensure that our Null viscosity sample does indeed have Null viscosity *)
				<|Object->testSampleNoViscosity,Viscosity->Null|>,

				(* Sample with concentration *)
				<|Object->testSampleWithConcentration,Replace[Composition]->{{100 VolumePercent,Link[Model[Molecule,"Water"]],Now},{10 Micromolar,Link[Model[Molecule,"Uracil"]],Now}},Viscosity->1 Milli Pascal Second|>,

				(* Upload viscosity to any remaining test samples *)
				<|Object->testSample,Viscosity->1 Milli Pascal Second|>,
				<|Object->testSampleLarge,Viscosity->1 Milli Pascal Second|>
			}];

			(* Create some test instruments *)
			instrumentPackets={
				<|
					Object->testOsmometer,
					Name->"Test Vapro 5600 Osmometer for ExperimentMeasureOsmolality "<>$SessionUUID,
					Model->Link[Model[Instrument,Osmometer,"Vapro 5600"],Objects],
					Status->Available,
					Replace[SerialNumbers]->{"Instrument","5600202558"},
					Cost->9827.04 USD,
					DataFilePath->"Data\\Vapro5600\\VaproTest",
					Replace[ManufacturerCalibrants]->{
						Link[Model[Sample,"Osmolality Standard 290 mmol/kg Sodium Chloride"]],
						Link[Model[Sample,"Osmolality Standard 1000 mmol/kg Sodium Chloride"]],
						Link[Model[Sample,"Osmolality Standard 100 mmol/kg Sodium Chloride"]]
					},
					Site -> Link[$Site]
				|>,
				<|
					Object->testPipette,
					Name->"Test 10uL pipette for ExperimentMeasureOsmolality "<>$SessionUUID,
					Model->Link[Model[Instrument,Pipette,"AC-037 10 uL Pipette, Vapro 5600"],Objects],
					Status->Available
				|>
			};

			(* Create a protocol to test templating *)
			protocolPackets={
				<|
					Object->testProtocolTemplate,
					Name->"Test Template MeasureOsmolality Protocol for ExperimentMeasureOsmolality "<>$SessionUUID,
					ResolvedOptions->{EquilibrationTime->101 Second}
				|>
			};

			(* Combine all packets for upload and set to dev object *)
			uploadPackets=Append[#,DeveloperObject->True]&/@Flatten[{benchPacket,containerPackets,samplePackets,sampleChangePackets,instrumentPackets,protocolPackets}];

			Upload[uploadPackets];
		]
	},
	SymbolTearDown:>{
		Module[{testObjList,existsFilter},

			testObjList={
				Object[Container,Bench,"Test bench for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 1 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 2 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 3 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 4 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 5 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 6 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 7 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 8 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 9 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 10 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 11 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 50 mL Tube 1 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 1 mL Ampoule 1 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 1 mL Ampoule 2 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 1 mL Ampoule 3 for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Container,Vessel,"Test 50 mL Tube 2 for ExperimentMeasureOsmolality "<>$SessionUUID],

				Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test discarded Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test Milli-Q water sample with no volume for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test Milli-Q water sample with no model for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test Milli-Q water sample with no container for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test solid sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test viscous sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test sample with Null viscosity for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test sample with composition for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test large Milli-Q water sample for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test 240 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test 280 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test 320 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test 100 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test 290 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Sample,"Test 1000 mmol/kg calibrant for ExperimentMeasureOsmolality "<>$SessionUUID],

				Object[Instrument,Osmometer,"Test Vapro 5600 Osmometer for ExperimentMeasureOsmolality "<>$SessionUUID],
				Object[Instrument,Pipette,"Test 10uL pipette for ExperimentMeasureOsmolality "<>$SessionUUID],

				Object[Protocol,MeasureOsmolality,"Test Template MeasureOsmolality Protocol for ExperimentMeasureOsmolality "<>$SessionUUID]
			};

			(* Erase any remaining objects *)
			existsFilter=DatabaseMemberQ[testObjList];

			EraseObject[PickList[testObjList,existsFilter],Force->True,Verbose->False];
		]
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];









(* ::Subsection:: *)
(*ExperimentMeasureOsmolalityOptions*)


(* ---------------------------------------- *)
(* -- ExperimentMeasureOsmolalityOptions -- *)
(* ---------------------------------------- *)


DefineTests[ExperimentMeasureOsmolalityOptions,
	{
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			ExperimentMeasureOsmolalityOptions[
				Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolalityOptions "<>$SessionUUID]
			],
			_Grid
		],

		Example[{Basic,"View any potential issues with provided inputs/options displayed:"},
			ExperimentMeasureOsmolalityOptions[
				Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolalityOptions "<>$SessionUUID],
				SampleVolume->5 Microliter
			],
			_Grid,
			Messages:>{Warning::OsmolalityLowSampleVolume}
		],

		Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentMeasureOsmolalityOptions[
				{
					Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolalityOptions "<>$SessionUUID]
				},
				OutputFormat->List
			],
			{(_Rule|_RuleDelayed)..}
		]
	},


	(*  build test objects *)
	Stubs:>{
		$EmailEnabled=False,
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SetUp:>{
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
	},
	TearDown:>{
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	},
	SymbolSetUp:>{

		Module[
			{
				testObjList,existsFilter,
				cache,

				containerIDs,
				testBench,
				testContainer1,
				benchPacket,containerPackets,

				sampleIDs,
				testSample,
				samplePackets,sampleChangePackets,

				instrumentIDs,
				testOsmometer,testPipette,
				instrumentPackets,

				uploadPackets
			},

			testObjList={
				Object[Container,Bench,"Test bench for ExperimentMeasureOsmolalityOptions "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 1 for ExperimentMeasureOsmolalityOptions "<>$SessionUUID],
				Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolalityOptions "<>$SessionUUID],
				Object[Instrument,Osmometer,"Test Vapro 5600 Osmometer for ExperimentMeasureOsmolalityOptions "<>$SessionUUID],
				Object[Instrument,Pipette,"Test 10uL pipette for ExperimentMeasureOsmolalityOptions "<>$SessionUUID]
			};

			(* Erase any objects that we failed to erase in the last unit test teardown *)
			existsFilter=DatabaseMemberQ[testObjList];

			EraseObject[PickList[testObjList,existsFilter],Force->True,Verbose->False];

			(* Create correct number of IDs of type from created objects list *)
			createIDs[type:TypeP[]]:=CreateID[ConstantArray[type,Count[testObjList,ObjectReferenceP[type]]]];

			{
				testBench
			}=createIDs[Object[Container,Bench]];

			{
				testContainer1
			}=containerIDs=createIDs[Object[Container,Vessel]];

			{
				testSample
			}=sampleIDs=createIDs[Object[Sample]];

			{
				testOsmometer,
				testPipette
			}=instrumentIDs=Join[createIDs[Object[Instrument,Osmometer]],createIDs[Object[Instrument,Pipette]]];

			(* Create the bench for testing *)
			benchPacket=<|
				Object->testBench,
				Name->"Test bench for ExperimentMeasureOsmolalityOptions "<>$SessionUUID,
				Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects]
			|>;

			(* Keep a rolling cache so that we can reduce the number of uploads *)
			cache=Experiment`Private`FlattenCachePackets[{benchPacket}];

			(* Create some containers *)
			containerPackets=UploadSample[
				{
					(*1*)Model[Container,Vessel,"2mL Tube"]
				},
				{
					(*1*){"Bench Top Slot",testBench}
				},
				ID->{
					(*1*)testContainer1
				}[ID],
				Name->{
					(*1*)"Test 2 mL Tube 1 for ExperimentMeasureOsmolalityOptions "<>$SessionUUID
				},
				Cache->cache,
				Upload->False
			];

			cache=Experiment`Private`FlattenCachePackets[{cache,containerPackets}];

			samplePackets=UploadSample[
				{
					(*1*)Model[Sample,"Milli-Q water"]
				},
				{
					(*1*){"A1",testContainer1}
				},
				InitialAmount->{
					(*1*)100 Microliter
				},
				ID->{
					(*1*)testSample
				}[ID],
				Name->{
					(*1*)"Test Milli-Q water sample for ExperimentMeasureOsmolalityOptions "<>$SessionUUID
				},
				Cache->cache,
				Upload->False
			];

			cache=Experiment`Private`FlattenCachePackets[{cache,samplePackets}];

			(* Generate some change packets to give our samples their unique identities *)
			sampleChangePackets=Flatten[{
				(* Upload viscosity to samples *)
				<|Object->testSample,Viscosity->1 Milli Pascal Second|>
			}];

			(* Create some test instruments *)
			instrumentPackets={
				<|
					Object->testOsmometer,
					Name->"Test Vapro 5600 Osmometer for ExperimentMeasureOsmolalityOptions "<>$SessionUUID,
					Model->Link[Model[Instrument,Osmometer,"Vapro 5600"],Objects],
					Status->Available,
					Replace[SerialNumbers]->{"Instrument","5600202558"},
					Cost->9827.04 USD,
					DataFilePath->"Data\\Vapro5600\\VaproTest",
					Replace[ManufacturerCalibrants]->{
						Link[Model[Sample,"Osmolality Standard 290 mmol/kg Sodium Chloride"]],
						Link[Model[Sample,"Osmolality Standard 1000 mmol/kg Sodium Chloride"]],
						Link[Model[Sample,"Osmolality Standard 100 mmol/kg Sodium Chloride"]]
					}
				|>,
				<|
					Object->testPipette,
					Name->"Test 10uL pipette for ExperimentMeasureOsmolalityOptions "<>$SessionUUID,
					Model->Link[Model[Instrument,Pipette,"AC-037 10 uL Pipette, Vapro 5600"],Objects],
					Status->Available
				|>
			};

			(* Combine all packets for upload and set to dev object *)
			uploadPackets=Append[#,DeveloperObject->True]&/@Flatten[{benchPacket,containerPackets,samplePackets,sampleChangePackets,instrumentPackets}];

			Upload[uploadPackets];
		]
	},
	SymbolTearDown:>{
		Module[{testObjList,existsFilter},

			testObjList={
				Object[Container,Bench,"Test bench for ExperimentMeasureOsmolalityOptions "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 1 for ExperimentMeasureOsmolalityOptions "<>$SessionUUID],
				Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolalityOptions "<>$SessionUUID],
				Object[Instrument,Osmometer,"Test Vapro 5600 Osmometer for ExperimentMeasureOsmolalityOptions "<>$SessionUUID],
				Object[Instrument,Pipette,"Test 10uL pipette for ExperimentMeasureOsmolalityOptions "<>$SessionUUID]
			};

			(* Erase any remaining objects *)
			existsFilter=DatabaseMemberQ[testObjList];

			EraseObject[PickList[testObjList,existsFilter],Force->True,Verbose->False];
		]
	}
];


(* ::Subsection:: *)
(*ValidExperimentMeasureOsmolalityQ*)


(* --------------------------------------- *)
(* -- ValidExperimentMeasureOsmolalityQ -- *)
(* --------------------------------------- *)


DefineTests[ValidExperimentMeasureOsmolalityQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issues:"},
			ValidExperimentMeasureOsmolalityQ[
				Object[Sample,"Test Milli-Q water sample for ValidExperimentMeasureOsmolalityQ "<>$SessionUUID]
			],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentMeasureOsmolalityQ[
				Object[Sample,"Test Milli-Q water sample for ValidExperimentMeasureOsmolalityQ "<>$SessionUUID],
				SampleVolume->50 Microliter
			],
			False,
			Messages:>{{Error::Pattern,Error::InvalidOption}}
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentMeasureOsmolalityQ[
				Object[Sample,"Test Milli-Q water sample for ValidExperimentMeasureOsmolalityQ "<>$SessionUUID],
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentMeasureOsmolalityQ[
				Object[Sample,"Test Milli-Q water sample for ValidExperimentMeasureOsmolalityQ "<>$SessionUUID],
				Verbose->True
			],
			True
		]
	},


	(*  build test objects *)
	Stubs:>{
		$EmailEnabled=False,
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SetUp:>{
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
	},
	TearDown:>{
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	},
	SymbolSetUp:>{

		Module[
			{
				testObjList,existsFilter,
				cache,

				containerIDs,
				testBench,
				testContainer1,
				benchPacket,containerPackets,

				sampleIDs,
				testSample,
				samplePackets,sampleChangePackets,

				instrumentIDs,
				testOsmometer,testPipette,
				instrumentPackets,

				uploadPackets
			},

			testObjList={
				Object[Container,Bench,"Test bench for ValidExperimentMeasureOsmolalityQ "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 1 for ValidExperimentMeasureOsmolalityQ "<>$SessionUUID],
				Object[Sample,"Test Milli-Q water sample for ValidExperimentMeasureOsmolalityQ "<>$SessionUUID],
				Object[Instrument,Osmometer,"Test Vapro 5600 Osmometer for ValidExperimentMeasureOsmolalityQ "<>$SessionUUID],
				Object[Instrument,Pipette,"Test 10uL pipette for ValidExperimentMeasureOsmolalityQ "<>$SessionUUID]
			};

			(* Erase any objects that we failed to erase in the last unit test teardown *)
			existsFilter=DatabaseMemberQ[testObjList];

			EraseObject[PickList[testObjList,existsFilter],Force->True,Verbose->False];

			(* Create correct number of IDs of type from created objects list *)
			createIDs[type:TypeP[]]:=CreateID[ConstantArray[type,Count[testObjList,ObjectReferenceP[type]]]];

			{
				testBench
			}=createIDs[Object[Container,Bench]];

			{
				testContainer1
			}=containerIDs=createIDs[Object[Container,Vessel]];

			{
				testSample
			}=sampleIDs=createIDs[Object[Sample]];

			{
				testOsmometer,
				testPipette
			}=instrumentIDs=Join[createIDs[Object[Instrument,Osmometer]],createIDs[Object[Instrument,Pipette]]];

			(* Create the bench for testing *)
			benchPacket=<|
				Object->testBench,
				Name->"Test bench for ValidExperimentMeasureOsmolalityQ "<>$SessionUUID,
				Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects]
			|>;

			(* Keep a rolling cache so that we can reduce the number of uploads *)
			cache=Experiment`Private`FlattenCachePackets[{benchPacket}];

			(* Create some containers *)
			containerPackets=UploadSample[
				{
					(*1*)Model[Container,Vessel,"2mL Tube"]
				},
				{
					(*1*){"Bench Top Slot",testBench}
				},
				ID->{
					(*1*)testContainer1
				}[ID],
				Name->{
					(*1*)"Test 2 mL Tube 1 for ValidExperimentMeasureOsmolalityQ "<>$SessionUUID
				},
				Cache->cache,
				Upload->False
			];

			cache=Experiment`Private`FlattenCachePackets[{cache,containerPackets}];

			samplePackets=UploadSample[
				{
					(*1*)Model[Sample,"Milli-Q water"]
				},
				{
					(*1*){"A1",testContainer1}
				},
				InitialAmount->{
					(*1*)100 Microliter
				},
				ID->{
					(*1*)testSample
				}[ID],
				Name->{
					(*1*)"Test Milli-Q water sample for ValidExperimentMeasureOsmolalityQ "<>$SessionUUID
				},
				Cache->cache,
				Upload->False
			];

			cache=Experiment`Private`FlattenCachePackets[{cache,samplePackets}];

			(* Generate some change packets to give our samples their unique identities *)
			sampleChangePackets=Flatten[{
				(* Upload viscosity to samples *)
				<|Object->testSample,Viscosity->1 Milli Pascal Second|>
			}];

			(* Create some test instruments *)
			instrumentPackets={
				<|
					Object->testOsmometer,
					Name->"Test Vapro 5600 Osmometer for ValidExperimentMeasureOsmolalityQ "<>$SessionUUID,
					Model->Link[Model[Instrument,Osmometer,"Vapro 5600"],Objects],
					Status->Available,
					Replace[SerialNumbers]->{"Instrument","5600202558"},
					Cost->9827.04 USD,
					DataFilePath->"Data\\Vapro5600\\VaproTest",
					Replace[ManufacturerCalibrants]->{
						Link[Model[Sample,"Osmolality Standard 290 mmol/kg Sodium Chloride"]],
						Link[Model[Sample,"Osmolality Standard 1000 mmol/kg Sodium Chloride"]],
						Link[Model[Sample,"Osmolality Standard 100 mmol/kg Sodium Chloride"]]
					}
				|>,
				<|
					Object->testPipette,
					Name->"Test 10uL pipette for ValidExperimentMeasureOsmolalityQ "<>$SessionUUID,
					Model->Link[Model[Instrument,Pipette,"AC-037 10 uL Pipette, Vapro 5600"],Objects],
					Status->Available
				|>
			};

			(* Combine all packets for upload and set to dev object *)
			uploadPackets=Append[#,DeveloperObject->True]&/@Flatten[{benchPacket,containerPackets,samplePackets,sampleChangePackets,instrumentPackets}];

			Upload[uploadPackets];
		]
	},
	SymbolTearDown:>{
		Module[{testObjList,existsFilter},

			testObjList={
				Object[Container,Bench,"Test bench for ValidExperimentMeasureOsmolalityQ "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 1 for ValidExperimentMeasureOsmolalityQ "<>$SessionUUID],
				Object[Sample,"Test Milli-Q water sample for ValidExperimentMeasureOsmolalityQ "<>$SessionUUID],
				Object[Instrument,Osmometer,"Test Vapro 5600 Osmometer for ValidExperimentMeasureOsmolalityQ "<>$SessionUUID],
				Object[Instrument,Pipette,"Test 10uL pipette for ValidExperimentMeasureOsmolalityQ "<>$SessionUUID]
			};

			(* Erase any remaining objects *)
			existsFilter=DatabaseMemberQ[testObjList];

			EraseObject[PickList[testObjList,existsFilter],Force->True,Verbose->False];
		]
	}
];



(* ::Subsection:: *)
(*ExperimentMeasureOsmolalityPreview*)


(* ---------------------------------------- *)
(* -- ExperimentMeasureOsmolalityPreview -- *)
(* ---------------------------------------- *)


DefineTests[ExperimentMeasureOsmolalityPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentMeasureOsmolality:"},
			ExperimentMeasureOsmolalityPreview[
				Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolalityPreview "<>$SessionUUID]
			],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed, try using ExperimentMeasureOsmolalityOptions:"},
			ExperimentMeasureOsmolalityOptions[
				Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolalityPreview "<>$SessionUUID]
			],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentMeasureOsmolalityQ:"},
			ValidExperimentMeasureOsmolalityQ[
				Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolalityPreview "<>$SessionUUID]
			],
			True
		]
	},

	(*  build test objects *)
	Stubs:>{
		$EmailEnabled=False,
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SetUp:>{
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
	},
	TearDown:>{
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	},
	SymbolSetUp:>{

		Module[
			{
				testObjList,existsFilter,
				cache,

				containerIDs,
				testBench,
				testContainer1,
				benchPacket,containerPackets,

				sampleIDs,
				testSample,
				samplePackets,sampleChangePackets,

				instrumentIDs,
				testOsmometer,testPipette,
				instrumentPackets,

				uploadPackets
			},

			testObjList={
				Object[Container,Bench,"Test bench for ExperimentMeasureOsmolalityPreview "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 1 for ExperimentMeasureOsmolalityPreview "<>$SessionUUID],
				Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolalityPreview "<>$SessionUUID],
				Object[Instrument,Osmometer,"Test Vapro 5600 Osmometer for ExperimentMeasureOsmolalityPreview "<>$SessionUUID],
				Object[Instrument,Pipette,"Test 10uL pipette for ExperimentMeasureOsmolalityPreview "<>$SessionUUID]
			};

			(* Erase any objects that we failed to erase in the last unit test teardown *)
			existsFilter=DatabaseMemberQ[testObjList];

			EraseObject[PickList[testObjList,existsFilter],Force->True,Verbose->False];

			(* Create correct number of IDs of type from created objects list *)
			createIDs[type:TypeP[]]:=CreateID[ConstantArray[type,Count[testObjList,ObjectReferenceP[type]]]];

			{
				testBench
			}=createIDs[Object[Container,Bench]];

			{
				testContainer1
			}=containerIDs=createIDs[Object[Container,Vessel]];

			{
				testSample
			}=sampleIDs=createIDs[Object[Sample]];

			{
				testOsmometer,
				testPipette
			}=instrumentIDs=Join[createIDs[Object[Instrument,Osmometer]],createIDs[Object[Instrument,Pipette]]];

			(* Create the bench for testing *)
			benchPacket=<|
				Object->testBench,
				Name->"Test bench for ExperimentMeasureOsmolalityPreview "<>$SessionUUID,
				Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects]
			|>;

			(* Keep a rolling cache so that we can reduce the number of uploads *)
			cache=Experiment`Private`FlattenCachePackets[{benchPacket}];

			(* Create some containers *)
			containerPackets=UploadSample[
				{
					(*1*)Model[Container,Vessel,"2mL Tube"]
				},
				{
					(*1*){"Bench Top Slot",testBench}
				},
				ID->{
					(*1*)testContainer1
				}[ID],
				Name->{
					(*1*)"Test 2 mL Tube 1 for ExperimentMeasureOsmolalityPreview "<>$SessionUUID
				},
				Cache->cache,
				Upload->False
			];

			cache=Experiment`Private`FlattenCachePackets[{cache,containerPackets}];

			samplePackets=UploadSample[
				{
					(*1*)Model[Sample,"Milli-Q water"]
				},
				{
					(*1*){"A1",testContainer1}
				},
				InitialAmount->{
					(*1*)100 Microliter
				},
				ID->{
					(*1*)testSample
				}[ID],
				Name->{
					(*1*)"Test Milli-Q water sample for ExperimentMeasureOsmolalityPreview "<>$SessionUUID
				},
				Cache->cache,
				Upload->False
			];

			cache=Experiment`Private`FlattenCachePackets[{cache,samplePackets}];

			(* Generate some change packets to give our samples their unique identities *)
			sampleChangePackets=Flatten[{
				(* Upload viscosity to samples *)
				<|Object->testSample,Viscosity->1 Milli Pascal Second|>
			}];

			(* Create some test instruments *)
			instrumentPackets={
				<|
					Object->testOsmometer,
					Name->"Test Vapro 5600 Osmometer for ExperimentMeasureOsmolalityPreview "<>$SessionUUID,
					Model->Link[Model[Instrument,Osmometer,"Vapro 5600"],Objects],
					Status->Available,
					Replace[SerialNumbers]->{"Instrument","5600202558"},
					Cost->9827.04 USD,
					DataFilePath->"Data\\Vapro5600\\VaproTest",
					Replace[ManufacturerCalibrants]->{
						Link[Model[Sample,"Osmolality Standard 290 mmol/kg Sodium Chloride"]],
						Link[Model[Sample,"Osmolality Standard 1000 mmol/kg Sodium Chloride"]],
						Link[Model[Sample,"Osmolality Standard 100 mmol/kg Sodium Chloride"]]
					}
				|>,
				<|
					Object->testPipette,
					Name->"Test 10uL pipette for ExperimentMeasureOsmolalityPreview "<>$SessionUUID,
					Model->Link[Model[Instrument,Pipette,"AC-037 10 uL Pipette, Vapro 5600"],Objects],
					Status->Available
				|>
			};

			(* Combine all packets for upload and set to dev object *)
			uploadPackets=Append[#,DeveloperObject->True]&/@Flatten[{benchPacket,containerPackets,samplePackets,sampleChangePackets,instrumentPackets}];

			Upload[uploadPackets];
		]
	},
	SymbolTearDown:>{
		Module[{testObjList,existsFilter},

			testObjList={
				Object[Container,Bench,"Test bench for ExperimentMeasureOsmolalityPreview "<>$SessionUUID],
				Object[Container,Vessel,"Test 2 mL Tube 1 for ExperimentMeasureOsmolalityPreview "<>$SessionUUID],
				Object[Sample,"Test Milli-Q water sample for ExperimentMeasureOsmolalityPreview "<>$SessionUUID],
				Object[Instrument,Osmometer,"Test Vapro 5600 Osmometer for ExperimentMeasureOsmolalityPreview "<>$SessionUUID],
				Object[Instrument,Pipette,"Test 10uL pipette for ExperimentMeasureOsmolalityPreview "<>$SessionUUID]
			};

			(* Erase any remaining objects *)
			existsFilter=DatabaseMemberQ[testObjList];

			EraseObject[PickList[testObjList,existsFilter],Force->True,Verbose->False];
		]
	}
];
