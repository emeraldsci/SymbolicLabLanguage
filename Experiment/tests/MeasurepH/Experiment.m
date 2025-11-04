(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentMeasurepH : Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentMeasurepH*)


(* ::Subsubsection::Closed:: *)
(*ExperimentMeasurepH*)


DefineTests[
	ExperimentMeasurepH,
	{
		(*Positive cases and examples*)
		Example[{Basic,"Measure the pH of a single sample:"},
			ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID]],
			ObjectP[Object[Protocol,MeasurepH]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
		],
		Example[{Basic,"Specify the calibration buffers that should be used to calibration the Immersion probe before pH measurement. If a two-point calibration is desired, set MediumCalibrationBuffer->Null (as shown in the example below):"},
			ExperimentMeasurepH[
				{
					Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],
					Object[Sample,"Large test water sample for ExperimentMeasurepH " <> $SessionUUID]
				},
				LowCalibrationBuffer->Model[Sample, "id:BYDOjvGjGxGr"],
				MediumCalibrationBuffer->Null,
				HighCalibrationBuffer->Model[Sample,"id:1ZA60vwjbbV8"]
			],
			ObjectP[Object[Protocol,MeasurepH]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
		],
		Example[{Basic,"Setting Aliquot->True will take an aliquot of your sample for pH Measurement - this is often used to prevent sample contamination when using an immersion probe. The option RecoupSample->True can be set if the aliquotted sample should be recouped after measurement:"},
			ExperimentMeasurepH[Object[Container,Vessel,"Test container 2 for ExperimentMeasurepH " <> $SessionUUID],Aliquot->True,AliquotAmount->25Milliliter,RecoupSample->True],
			ObjectP[Object[Protocol,MeasurepH]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
		],
		(*Additional Unit Tests*)
		Example[{Additional,"Measure the pH of a single sample when the Object[Sample] does not have a Model:"},
			ExperimentMeasurepH[Object[Sample, "Test MilliQ water sample for sample without a model for ExperimentMeasurepH " <> $SessionUUID], SecondaryWashSolution -> Null],
			ObjectP[Object[Protocol,MeasurepH]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
		],
		Example[{Additional,"Specify the length of time that the pH should be read for each sample. Sensornet performs pH readings in 1 second heartbeats so the number of data points gathered will be the number of seconds specifed as this option. This option only applies to samples measured via an Immersion probe:"},
			ExperimentMeasurepH[
				{
					Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID]
				},
				AcquisitionTime->10 Second
			],
			ObjectP[Object[Protocol,MeasurepH]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
		],
		Example[{Additional,"Turning on RecoupSample -> True should automatically turn on Aliquot->True:"},
			protocol=ExperimentMeasurepH[
				{
					Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],
					Object[Sample,"Large test water sample for ExperimentMeasurepH " <> $SessionUUID]
				},
				RecoupSample->{False,True}
			];
			Aliquot/.Download[protocol, AliquotSamplePreparation],
			{False,True},
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]},
			Variables :> {protocol}
		],
		Example[{Additional,"Measure the pH of a plate sample:"},
			ExperimentMeasurepH[Object[Sample, "Test water sample in a plate for ExperimentMeasurepH " <> $SessionUUID], SecondaryWashSolution -> Null],
			ObjectP[Object[Protocol]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
		],
		Example[{Additional,"Measure the pH of a very large sample when Aliquot -> True:"},
			ExperimentMeasurepH[Object[Sample, "Extra large test water sample for ExperimentMeasurepH " <> $SessionUUID],Aliquot->True],
			ObjectP[Object[Protocol,MeasurepH]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
		],
		Example[{Additional,"Measure 1L of a solution in a 1L bottle:"},
			protocol=ExperimentMeasurepH[Object[Sample, "Stock pH 10 calibration solution for ExperimentMeasurepH " <> $SessionUUID]];
			Download[protocol,{ProbeInstruments,Probes}],
			{
				List[ObjectP[]],
				List[ObjectP[]]
			},
			Variables:>{protocol}
		],
		Example[{Additional,"When switching instruments, the batching should done smartly to minimize switching between instruments:"},
			protocol=ExperimentMeasurepH[
				{Object[Sample, "Test sample in tube for ExperimentMeasurepH " <> $SessionUUID], Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID], Object[Sample, "Test MilliQ water sample for ExperimentMeasurepH " <> $SessionUUID]},
				Instrument -> {Model[Instrument, pHMeter, "id:BYDOjvG65vLz"], Model[Instrument, pHMeter, "id:AEqRl9K8o1D5"], Model[Instrument, pHMeter, "id:BYDOjvG65vLz"]},
				AcquisitionTime -> {30 Second, 10 Second, 20 Second},
				Aliquot -> {False, False, True},
				RecoupSample -> {False, False, True},
				SecondaryWashSolution -> Null
			];
			Download[protocol,{ProbeInstruments,ProbeInstrumentsSelect,ProbeBatchLength,ProbeParameters[[All,Sample]][Name]}],
			{
				ConstantArray[ObjectP[],2],
				ConstantArray[True,2],
				{2,1},
				{"Test sample in tube for ExperimentMeasurepH " <> $SessionUUID,"Test MilliQ water sample for ExperimentMeasurepH " <> $SessionUUID,"Test water sample for ExperimentMeasurepH " <> $SessionUUID}
			},
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
		],
		Example[{Additional,"When switching instruments, the batching should done smartly to minimize switching between instruments (part 2):"},
			protocol=ExperimentMeasurepH[
				{
					Object[Sample, "Test sample in tube for ExperimentMeasurepH " <> $SessionUUID],
					Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
					Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
					Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
					Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID]
				},
				Instrument -> {
					Model[Instrument, pHMeter, "id:BYDOjvG65vLz"],
					Model[Instrument, pHMeter, "id:BYDOjvG65vLz"],
					Model[Instrument, pHMeter, "SevenExcellence (for pH)"],
					Model[Instrument, pHMeter, "SevenExcellence (for pH)"],
					Model[Instrument, pHMeter, "id:BYDOjvG65vLz"]
				},
				SecondaryWashSolution -> Null
			];
			Download[protocol,{ProbeInstruments,Probes,ProbeInstrumentsSelect,ProbeBatchLength}],
			{
				ConstantArray[ObjectP[],2],
				{ObjectP[],ObjectP[]},
				{True,True},
				{3,2}
			},
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
		],

		Example[{Options,Probe,"Specify a specific probe on the pHMeter for measurement:"},
			options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],Probe->Model[Part, pHProbe, "InLab Reach Pro-225"],Output->Options];
			Lookup[options, {Probe,Instrument}],
			{
				ObjectP[Model[Part, pHProbe, "InLab Reach Pro-225"]],
				ObjectP[{Model[Instrument, pHMeter, "SevenExcellence (for pH)"], Model[Instrument, pHMeter, "Mettler Toledo InLab Reach 225"]}]
			},
			Variables :> {options}
		],

		Example[{Options,NumberOfReplicates,"Measure the pH of a single liquid sample by specifying a NumberOfReplicates, in this case, repeatedly measuring the sample:"},
			options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],NumberOfReplicates->2,Output->Options];
			Lookup[options, NumberOfReplicates],
			2,
			Variables :> {options}
		],
		Example[{Options,RecoupSample,"Measure the pH of a single liquid sample and recoup that sample:"},
			options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],RecoupSample->True,Output->Options];
			Lookup[options,RecoupSample],
			True,
			Variables :> {options}
		],
		Example[{Options,ImageSample,"Measure the pH of a single liquid sample and do not take an image afterwards:"},
			options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],ImageSample->False,Output->Options];
			Lookup[options,ImageSample],
			False,
			Variables :> {options}
		],

		Example[{Options,Instrument,"Measure the pH of a single liquid sample by specifying a specific instrument object or model:"},
			options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],Instrument->Model[Instrument, pHMeter, "Mettler Toledo InLab Micro"],Output->Options];
			Lookup[options, Instrument],
			ObjectP[Model[Instrument, pHMeter, "Mettler Toledo InLab Micro"]],
			Variables :> {options}
		],
		(* Commenting out TemperatureCorrection as this option needs re-worked. *)
		Example[{Options,AcquisitionTime,"Measure the pH of a single liquid sample with a custom acquisition time (time over which to read pH):"},
		  options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],AcquisitionTime->1 Minute,Output->Options];
		  Lookup[options, {AcquisitionTime,Instrument, Probe(*, TemperatureCorrection*)}],
		  {
			  1 Minute,
			  Except[ObjectP[Model[Instrument, pHMeter, "SevenExcellence (for pH)"]]],
			  ObjectP[Model[Part, pHProbe]](*,
			  Null*)
		  },
		  Variables :> {options}
		],
		(* Our temperature correction option needs reworked. The current option patterns apply to conductivity not pH. *)
		(*{Options,TemperatureCorrection,"Measure the pH of a single sample with correction for the sample temperature:"}*)
		Test["Measure the pH of a single sample with correction for the sample temperature:",
			options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],TemperatureCorrection->Linear,Output->Options];
			Lookup[options, {AcquisitionTime, (*TemperatureCorrection,*) Instrument, Probe}],
			{
				Null,
				(* Hidden options are not returned for Output -> Options. *)
				(*Linear,*)
				ObjectP[Model[Instrument, pHMeter, "SevenExcellence (for pH)"]],
				ObjectP[]
			},
			Variables :> {options}
		],

		Example[{Options,WashSolution,"Measure the pH of a single liquid sample while specifying a wash solution to wash the pH probe with:"},
			protocol=ExperimentMeasurepH[
				Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],
				WashSolution->Model[Sample,StockSolution,"Red Food Dye Test Solution"]
			];
			Download[protocol,WashSolutions],
			{ObjectP[Model[Sample,StockSolution,"Red Food Dye Test Solution"]]},
			Variables:>{protocol}
		],
		Example[{Options,SecondaryWashSolution,"Measure the pH of a single liquid sample while specifying a secondary wash solution to wash the pH probe with:"},
			protocol=ExperimentMeasurepH[
				Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],
				SecondaryWashSolution->Model[Sample,"Milli-Q water"]
			];
			Download[protocol,SecondaryWashSolutions],
			{ObjectP[Model[Sample,"Milli-Q water"]]},
			Variables:>{protocol}
		],
		Example[{Options,SecondaryWashSolution,"Measure the pH of a single liquid sample while specifying no secondary wash solution to wash the pH probe with:"},
			protocol=ExperimentMeasurepH[
				Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],
				SecondaryWashSolution->Null
			];
			Download[protocol,SecondaryWashSolutions],
			{Null},
			Variables :> {protocol}
		],
		Example[{Options,LowCalibrationBuffer,"Measure the pH of a single liquid sample while specifying a custom low calibrant solution (between pH 2 and 5). Note to change LowCalibrationBufferpH, if necessary:"},
		  options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],LowCalibrationBuffer->Model[Sample,"Reference Buffer - pH 4.63"],LowCalibrationBufferpH->4.63,Output->Options];
		  Lookup[options,LowCalibrationBuffer],
			ObjectP[Model[Sample,"Reference Buffer - pH 4.63"]],
		  Variables :> {options}
		],
		Example[{Options,LowCalibrationBufferpH,"Measure the pH of a single liquid sample while specifying a custom pH value for the Low pH calibrant buffer. Note to change the LowCalibrationBuffer, if necessary (default is 4):"},
		  options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],LowCalibrationBufferpH->4.63,LowCalibrationBuffer->Model[Sample,"Reference Buffer - pH 4.63"],Output->Options];
		  Lookup[options,LowCalibrationBufferpH],
		  4.63,
		  Variables :> {options}
		],
		Example[{Options,MediumCalibrationBuffer,"Measure the pH of a single liquid sample while specifying a custom medium calibrant solution (between pH 5 and 9). Note to change MediumCalibrationBufferpH, if necessary (default is 7):"},
		  options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],MediumCalibrationBuffer->Model[Sample,"Reference Buffer - pH 7.38"],MediumCalibrationBufferpH->7.38,Output->Options];
		  Lookup[options,MediumCalibrationBuffer],
			ObjectP[Model[Sample,"Reference Buffer - pH 7.38"]],
		  Variables :> {options}
		],
		Example[{Options,MediumCalibrationBufferpH,"Measure the pH of a single liquid sample while specifying a custom pH value for the Medium pH calibrant buffer. Note to change the MediumCalibrationBuffer, if necessary:"},
		  options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],MediumCalibrationBufferpH->7.38,MediumCalibrationBuffer->Model[Sample,"Reference Buffer - pH 7.38"],Output->Options];
		  Lookup[options,MediumCalibrationBufferpH],
		  7.38,
		  Variables :> {options}
		],
		Example[{Options,HighCalibrationBuffer,"Measure the pH of a single liquid sample while specifying a custom high calibrant solution (between pH 9 and 12). Note to change HighCalibrationBufferpH, if necessary (default is 10):"},
		  options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],HighCalibrationBuffer->Model[Sample,"Reference Buffer - pH 11.00"],HighCalibrationBufferpH->11,Output->Options];
		  Lookup[options,HighCalibrationBuffer],
			ObjectP[Model[Sample,"Reference Buffer - pH 11.00"]],
		  Variables :> {options}
		],
		Example[{Options,HighCalibrationBufferpH,"Measure the pH of a single liquid sample while specifying a custom pH value for the High pH calibrant buffer. Note to change the HighCalibrationBuffer, if necessary:"},
		  options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],HighCalibrationBufferpH->11,HighCalibrationBuffer->Model[Sample,"Reference Buffer - pH 11.00"],Output->Options];
		  Lookup[options,HighCalibrationBufferpH],
		  11,
				EquivalenceFunction->Equal,
		  Variables :> {options}
		],
		Example[{Options,Name,"Measure the pH of a single liquid sample with a Name specified for the protocol:"},
		  options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],Name->"Measure pH with 1 min acquisition.",AcquisitionTime->1 Minute,Output->Options];
		  Lookup[options,Name],
		  "Measure pH with 1 min acquisition.",
		  Variables:>{options}
		],

		Example[{Options,Template,"A template protocol whose methodology should be reproduced in running this experiment. Option values will be inherited from the template protocol, but can be individually overridden by directly specifying values for those options to this Experiment function:"},
			options=ExperimentMeasurepH[
				Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],
				Template->Object[Protocol,MeasurepH,"pH Test Template Protocol for ExperimentMeasurepH " <> $SessionUUID],
				Probe->Model[Part, pHProbe, "InLab Reach Pro-225"],
				Output->Options
			];
			Lookup[options,AliquotAmount],
			25*Milliliter,
			Variables:>{options},
			EquivalenceFunction->Equal
		],

		(* Verification Standard Options *)
		Example[{Options, VerificationStandard, "Confirm the calbiration is suitable with a verification standard using the VerificationStandard option:"},
			protocol = ExperimentMeasurepH[
				Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
				VerificationStandard -> Model[Sample, "Reference Buffer - pH 11.00"]
			];
			Download[protocol, VerificationStandard],
			ObjectP[Model[Sample, "Reference Buffer - pH 11.00"]],
			Variables :> {protocol}
		],
		Example[{Options, {MinVerificationStandardpH, MaxVerificationStandardpH}, "Set a range of acceptable pH values for the pH measured of the VerificationStandard with the calibration using MinVerificationStandardpH and MaxVerificationStandardpH:"},
			protocol = ExperimentMeasurepH[
				Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
				VerificationStandard -> Model[Sample, "Reference Buffer - pH 11.00"],
				MinVerificationStandardpH -> 10.9,
				MaxVerificationStandardpH -> 11.1
			];
			Download[protocol, {MinVerificationStandardpH, MaxVerificationStandardpH}],
			{EqualP[10.9], EqualP[11.1]},
			Variables :> {protocol}
		],
		Example[{Options, VerificationStandardWashSolution, "Set the solution used to clean the pH probe prior to measuring the VerificationStandard using the VerificationStandardWashSolution option:"},
			protocol = ExperimentMeasurepH[
				Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
				VerificationStandard -> Model[Sample, "Reference Buffer - pH 11.00"],
				VerificationStandardWashSolution -> Model[Sample, "Milli-Q water"]
			];
			Download[protocol, VerificationStandardWashSolution],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {protocol}
		],
		Example[{Messages, "Error::VerificationStandardOptionsRequired", "If options related to calibration verification standard are Null but a VerificationStandard was specified an error is thrown:"},
			ExperimentMeasurepH[
				Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
				VerificationStandard -> Model[Sample, "Reference Buffer - pH 11.00"],
				MinVerificationStandardpH -> Null
			],
			$Failed,
			Messages :> {Error::VerificationStandardOptionsRequired, Error::InvalidOption},
			Variables :> {options}
		],
		Test[{"(2) If options related to calibration verification standard are Null but a VerificationStandard was specified an error is thrown:"},
			ExperimentMeasurepH[
				Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
				VerificationStandard -> Model[Sample, "Reference Buffer - pH 11.00"],
				MaxVerificationStandardpH -> Null
			],
			$Failed,
			Messages :> {Error::VerificationStandardOptionsRequired, Error::InvalidOption},
			Variables :> {options}
		],
		Example[{Messages, "Error::VerificationStandardRequired", "If options related to calibration verification standard are non-Null but VerificationStandard is Null and error is thrown:"},
			ExperimentMeasurepH[
				Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
				VerificationStandard -> Null,
				MinVerificationStandardpH -> 10.9,
				MaxVerificationStandardpH -> 11.1
			],
			$Failed,
			Messages :> {Error::VerificationStandardRequired, Error::InvalidOption}
		],
		Test["If options related to calibration verification standard are non-Null but VerificationStandard is Null and error is thrown:",
			ExperimentMeasurepH[
				Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
				VerificationStandard -> Null,
				VerificationStandardWashSolution -> Model[Sample, "Milli-Q water"]
			],
			$Failed,
			Messages :> {Error::VerificationStandardRequired, Error::InvalidOption}
		],
		Example[{Messages, "Warning::VerificationStandardRangeAndSampleMismatch", "If MinVerificationStandardpH and MaxVerificationStandardpH do not comprise a valid range and error is thrown:"},
			ExperimentMeasurepH[
				Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
				VerificationStandard -> Model[Sample, "Reference Buffer - pH 11.00"],
				MinVerificationStandardpH -> 10.5,
				MaxVerificationStandardpH -> 10.6
			],
			ObjectP[Object[Protocol, MeasurepH]],
			Messages :> {Warning::VerificationStandardRangeAndSampleMismatch}
		],
		Example[{Messages, "Error::InvalidVerificationStandardpHRange", "If MinVerificationStandardpH and MaxVerificationStandardpH do not comprise a valid range and error is thrown:"},
			ExperimentMeasurepH[
				Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
				VerificationStandard -> Model[Sample, "Reference Buffer - pH 11.00"],
				MinVerificationStandardpH -> 11.1,
				MaxVerificationStandardpH -> 10.9
			],
			$Failed,
			Messages :> {Error::InvalidVerificationStandardpHRange, Error::InvalidOption}
		],
		Example[{Messages, "Error::UniformedVerificationStandardpH", "If automatic resolution of MinVerificationStandardpH and MaxVerificationStandardpH is not possible because the pH of the VerificationStandard is not known an error is thrown:"},
			ExperimentMeasurepH[
				Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
				VerificationStandard -> Model[Sample, "Test medium calibration solution model with no pH for ExperimentMeasurepH " <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::UniformedVerificationStandardpH, Error::InvalidOption}
		],
		Example[{Messages, "Error::InputCannotBeOption", "Inputs cannot be given as values for options, otherwise an error is thrown:"},
			ExperimentMeasurepH[
				Object[Sample, "Large test water sample for ExperimentMeasurepH " <> $SessionUUID],
				VerificationStandard -> Object[Sample, "Large test water sample for ExperimentMeasurepH " <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::InputCannotBeOption, Error::InvalidOption, Error::InvalidInput}
		],
		Example[{Messages, "Error::NullVolumeSampleInOption", "Object[Sample] values for options must have their Volume informed, otherwise an error is thrown:"},
			ExperimentMeasurepH[
				Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
				VerificationStandard -> Object[Sample, "Test water sample with Volume=Null for ExperimentMeasurepH " <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::NullVolumeSampleInOption, Error::InvalidOption}
		],
		(*)
		Example[{Messages, "Error::InsufficientVolumeSampleInOption", "Object[Sample] values for options must have sufficient Volume, otherwise an error is thrown:"},
			ExperimentMeasurepH[
				Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
				VerificationStandard -> Object[Sample, "Test sample with volume too low for measurement ExperimentMeasurepH " <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::InsufficientVolumeSampleInOption, Error::InvalidOption}
		],
		*)
		Example[{Messages, "Error::IncompatibleSampleInOption", "Object[Sample] values for options must be compatible with the phMeter probes, otherwise an error is thrown:"},
			ExperimentMeasurepH[
				Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
				VerificationStandard -> Object[Sample, "Test too acidic sample for ExperimentMeasurepH " <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::IncompatibleSampleInOption, Error::InvalidOption}
		],

		(*post processing options*)
		Example[{Options,MeasureWeight,"Specify whether to weigh the sample after measurement in the post processing step:"},
			options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],MeasureWeight->False,Output->Options];
			Lookup[options,MeasureWeight],
			False,
			Variables:>{options}
		],
		Example[{Options,MeasureVolume,"Specify whether to measure the volume of the sample after measurement in the post processing step:"},
			options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],MeasureVolume->False,Output->Options];
			Lookup[options,MeasureVolume],
			False,
			Variables:>{options}
		],

		Example[{Options,PreparatoryUnitOperations,"Specify prepared samples by PreparatoryUnitOperations for pH measurement:"},
			protocol=ExperimentMeasurepH[{"WaterSample Container 1", "WaterSample Container 2", "WaterSample Container 3","WaterSample Container 4"},
				PreparatoryUnitOperations -> {LabelContainer[Label -> "WaterSample Container 1",
					Container -> Model[Container, Vessel, "2mL Tube"]],
					LabelContainer[Label -> "WaterSample Container 2",
						Container -> Model[Container, Vessel, "2mL Tube"]],
					LabelContainer[Label -> "WaterSample Container 3",
						Container -> Model[Container, Vessel, "2mL Tube"]],
					LabelContainer[Label -> "WaterSample Container 4",
						Container -> Model[Container, Vessel, "2mL Tube"]],
					Transfer[Source -> Model[Sample, "Milli-Q water"],
						Amount -> 1 Milliliter, Destination -> "WaterSample Container 1"],
					Transfer[Source -> Model[Sample, "Milli-Q water"],
						Amount -> 1 Milliliter, Destination -> "WaterSample Container 2"],
					Transfer[Source -> Model[Sample, "Milli-Q water"],
						Amount -> 1 Milliliter, Destination -> "WaterSample Container 3"],
					Transfer[Source -> Model[Sample, "Milli-Q water"],
						Amount -> 1 Milliliter,
						Destination -> "WaterSample Container 4"]},
				ImageSample -> False, MeasureVolume -> False, SecondaryWashSolution -> Null];
			Length[Download[protocol,SamplesIn]],
			4,
			TimeConstraint -> 1000,
			Variables :> {protocol}
		],
		Example[{Options,PreparatoryUnitOperations,"Specify prepared samples by PreparatoryUnitOperations for the wash solution:"},
			protocol=ExperimentMeasurepH[
				Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
				LowCalibrationBuffer -> "wash",
				LowCalibrationBufferpH -> 6,
				PreparatoryUnitOperations -> {
					LabelContainer[Label -> "50mL Tube", Container -> Model[Container, Vessel, "50mL Tube"]],
					Transfer[Source -> Model[Sample, StockSolution, "70% Ethanol"], Destination -> "50mL Tube", Amount -> 50 Milliliter],
					LabelSample[Label -> "wash", Sample -> {"A1", "50mL Tube"}]
				}
			];
			Download[protocol,ProbeLowCalibrationBuffer],
			ObjectP[Model[Sample, StockSolution, "70% Ethanol"]],
			Variables :> {protocol}
		],

		(*incubate options*)
		Example[{Options,Incubate,"Measure the pH of a single liquid sample with Incubation before measurement, using the default Incubate parameters:"},
		  options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],Incubate->True,Output->Options];
		  Lookup[options,Incubate],
		  True,
		  Variables:>{options}
		],
		Example[{Options,IncubationTime,"Measure the pH of a single liquid sample with Incubation before measurement for 10 minutes:"},
		  options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],Incubate->True,IncubationTime->10 Minute,Output->Options];
		  Lookup[options,IncubationTime],
		  10 Minute,
		  Variables:>{options}
		],
		Example[{Options,MaxIncubationTime,"Measure the pH of a single liquid sample with MaxIncubation before measurement for 1 hour:"},
		  options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],Incubate->True,MaxIncubationTime->1 Hour,Output->Options];
		  Lookup[options,MaxIncubationTime],
		  1 Hour,
		  Variables:>{options}
		],
		Example[{Options,IncubationTemperature,"Measure the pH of a single liquid sample with Incubation before measurement for 10 minutes at 30 degrees C:"},
		  options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],Incubate->True,IncubationTime->10 Minute,IncubationTemperature -> 30 Celsius,Output->Options];
		  Lookup[options,IncubationTemperature],
		  30 Celsius,
		  Variables:>{options}
		],
		Example[{Options,IncubationInstrument,"Measure the pH of a single liquid sample with Incubation before measurement and specify the Incubation instrument:"},
		  options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],Incubate->True,IncubationInstrument->Model[Instrument,HeatBlock,"Thermal-Lok  2510-1104"],Output->Options];
		  Lookup[options,IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"Thermal-Lok  2510-1104"]],
		  Variables:>{options}
		],
		Example[{Options,IncubateAliquot,"The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
		  options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],IncubateAliquot->1 Milliliter,IncubateAliquotContainer->Model[Container, Vessel, "2mL Tube"],Output->Options];
		  Lookup[options,IncubateAliquot],
		  1 Milliliter,
				EquivalenceFunction->Equal,
		  Variables:>{options}
		],
		Example[{Options,IncubateAliquotContainer,"The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
		  options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],IncubateAliquot->1 Milliliter,IncubateAliquotContainer->Model[Container, Vessel, "2mL Tube"],Output->Options];
		  Lookup[options,IncubateAliquotContainer],
				{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
		  Variables:>{options}
		],

		Example[{Options,Mix,"Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],Mix->True,Output->Options];
			Lookup[options,Mix],
			True,
			Variables:>{options}
		],
		Example[{Options,MixType,"Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],Mix->True,MixType->Vortex,Output->Options];
			Lookup[options,MixType],
			Vortex,
			Variables:>{options}
		],
		Example[{Options,MixUntilDissolved,"Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
			options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],MixUntilDissolved->True,MixType->Vortex,Output->Options];
			Lookup[options,MixUntilDissolved],
			True,
			Variables:>{options}
		],
		Example[{Options,AnnealingTime,"Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],AnnealingTime->40 Minute,Output->Options];
			Lookup[options,AnnealingTime],
			40 Minute,
			Variables:>{options}
		],

		(*centrifuge options*)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Avanti J-15R"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], CentrifugeTime -> 5*Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			5*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], CentrifugeTemperature -> 10*Celsius, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], CentrifugeAliquot -> 10*Milliliter,CentrifugeAliquotContainer -> Model[Container, Vessel, "50mL Tube"],Output -> Options];
			Lookup[options, CentrifugeAliquot],
			10*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], CentrifugeAliquot -> 10*Milliliter,CentrifugeAliquotContainer -> Model[Container, Vessel, "50mL Tube"],Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options}
		],
		(* filter options *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], Filter -> Model[Item,Filter,"Disk Filter, GxF/PTFE, 0.22um, 25mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, GxF/PTFE, 0.22um, 25mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], FilterMaterial -> PES, Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],PrefilterMaterial -> GxF,FilterMaterial->PTFE, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], FilterPoreSize -> 0.22*Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], PrefilterPoreSize -> 1.*Micrometer, FilterMaterial -> PTFE, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "id:AEqRl9Kz1VD1"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "id:AEqRl9Kz1VD1"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentMeasurepH[Object[Sample,"Large test water sample for ExperimentMeasurepH " <> $SessionUUID], FiltrationType -> PeristalticPump, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], Output -> Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], Aliquot->True, FilterAliquot -> 1 Milliliter,FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], Aliquot->True, FilterAliquot -> 1 Milliliter,FiltrationType -> Centrifuge, FilterTime -> 20*Minute, Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], Aliquot->True, FilterAliquot -> 1 Milliliter,FiltrationType -> Centrifuge, FilterTemperature -> 22*Celsius, Output -> Options];
			Lookup[options, FilterTemperature],
			22*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],(* we will revisit this and change FilterSterile to make better sense with this task https://app.asana.com/1/84467620246/task/1209775340905665?focus=true
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options}
		],*)
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], FilterAliquot -> 10*Milliliter, Output -> Options];
			Lookup[options, FilterAliquot],
			10*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options}
		],

		(*Aliquot options*)
		Example[{Options,Aliquot,"Measure the pH of a single liquid sample by first aliquotting the sample:"},
			options=ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],Aliquot->True,Output->Options];
			Lookup[options, Aliquot],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], AliquotAmount -> 20*Milliliter,AliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, AliquotAmount],
			20*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], AssayVolume -> 20*Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			20*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], TargetConcentration -> 5*Micromolar, Output -> Options];
			Lookup[options, TargetConcentration],
			5*Micromolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "The analyte whose desired final concentration is specified:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], TargetConcentration -> 5 Micromolar, TargetConcentrationAnalyte -> Model[Molecule, "Uracil"], Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, "Uracil"]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],AliquotAmount->15*Milliliter,AssayVolume->30*Milliliter,AliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],AliquotAmount->15*Milliliter,AssayVolume->30*Milliliter,AliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasurepH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],AliquotAmount->15*Milliliter,AssayVolume->30*Milliliter,AliquotContainer -> Model[Container,Vessel,"50mL Tube"], Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasurepH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"],AliquotAmount->5*Milliliter,AssayVolume->20*Milliliter, AliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentMeasurepH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentMeasurepH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentMeasurepH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options,AliquotContainer,"The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentMeasurepH[
				Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],
				AliquotContainer->Model[Container,Vessel,"50mL Tube"],
				AliquotAmount->30 Milliliter,
				Output->Options
			];
			Lookup[options,AliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]}},
			Variables:>{options}
		],
		Example[{Options,SamplesInStorageCondition, "Indicates how the input samples of the experiment should be stored:"},
			options = ExperimentMeasurepH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID], SamplesInStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotDestinationWell, "Indicates how the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentMeasurepH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID], IncubateAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotDestinationWell, "Indicates how the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentMeasurepH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID], CentrifugeAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,FilterAliquotDestinationWell, "Indicates how the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentMeasurepH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID], FilterAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,DestinationWell, "Indicates how the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentMeasurepH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID], DestinationWell -> "A1", Output -> Options];
			Lookup[options,DestinationWell],
			{"A1"},
			Variables:>{options}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentMeasurepH[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Vessel, "50mL Tube"],
				PreparedModelAmount -> 40 Milliliter,
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
				{ObjectP[Model[Container, Vessel, "50mL Tube"]]..},
				{EqualP[40 Milliliter]..},
				{"A1", "A1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],

		Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
			ExperimentMeasurepH[
				Model[Sample, "Ammonium hydroxide"],
				PreparedModelAmount -> 0.5 Milliliter,
				Aliquot -> True,
				Mix -> True,
				SecondaryWashSolution -> Null
			],
			ObjectP[Object[Protocol, MeasurepH]]
		],

		Example[{Options,MaxpHSlope, "Specify MaxpHSlope and MinpHSlope:"},
			options = ExperimentMeasurepH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID], MaxpHSlope-> 102*Percent, MinpHSlope -> 98*Percent, Output->Options];
			Lookup[options, {MinpHSlope, MaxpHSlope}],
			{EqualP[98*Percent], EqualP[102*Percent]},
			Variables :> {options},
			TimeConstraint->1000
		],

		Example[{Options,MaxpHOffset, "Specify MaxpHOffset and MinpHOffset:"},
			options = ExperimentMeasurepH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID], MaxpHOffset-> 50*Milli*Volt, MinpHOffset -> -50*Milli*Volt, Output->Options];
			Lookup[options, {MinpHOffset, MaxpHOffset}],
			{EqualP[-50*Milli*Volt], EqualP[50*Milli*Volt]},
			Variables :> {options},
			TimeConstraint->1000
		],

		Example[{Options,MinpHSlope, "Specify MaxpHSlope and MinpHSlope:"},
			protocol = ExperimentMeasurepH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID], MaxpHSlope-> 102*Percent, MinpHSlope -> 98*Percent];
			Download[protocol, {MinpHSlope, MaxpHSlope}],
			{EqualP[98*Percent], EqualP[102*Percent]},
			Variables :> {protocol},
			TimeConstraint->1000
		],

		Example[{Options,MinpHOffset, "Specify MaxpHOffset and MinpHOffset:"},
			protocol = ExperimentMeasurepH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID], MaxpHOffset-> 50*Milli*Volt, MinpHOffset -> -50*Milli*Volt];
			Download[protocol, {MinpHOffset, MaxpHOffset}],
			{EqualP[-50*Milli*Volt], EqualP[50*Milli*Volt]},
			Variables :> {protocol},
			TimeConstraint->1000
		],

		Test["Sets the InSitu flag:",
			options = Download[
				ExperimentMeasurepH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID], DestinationWell -> "A1", InSitu->True],
				InSitu
			],
			True,
			Variables:>{options}
		],

		Test["Sets the WashProbe flag:",
			options = Download[
				ExperimentMeasurepH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID], DestinationWell -> "A1", WashProbe->False],
				WashProbe
			],
			False,
			Variables:>{options}
		],

		Test["Batched immersion fields needed for looping are index matched:",
			protocol=ExperimentMeasurepH[{Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID]},NumberOfReplicates->6];
			Length/@Download[protocol,{ProbeInstruments,DataFilePath,CalibrationFilePath,ProbeInstrumentsSelect,ProbeInstrumentsRelease,Probes,ProbePorts}],
			{2,2,2,2,2,2,2},
			Variables :> {protocol},
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
		],

		(*Input errors and warnings*)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentMeasurepH[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentMeasurepH[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentMeasurepH[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentMeasurepH[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container,Vessel,"50mL Tube"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample, "Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentMeasurepH[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container,Vessel,"50mL Tube"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample, "Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentMeasurepH[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages,"RecoupSampleAliquotConflict","Return an error when RecoupSample is True but Aliquot is false:"},
			ExperimentMeasurepH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
				RecoupSample->True,
				Aliquot->False
			],
			$Failed,
			Messages:>{
				Error::RecoupSampleAliquotConflict,
				Error::InvalidOption
			}
		],
		(* This test needs reworked as the pattern for TemperatureCorrection applies to conductivity measurements not pH measurements. *)
		(*{Messages,"TemperatureCorrectionConflict","Return an error when TemperatureCorrection is incompatible for the given instrument:"}*)
		Test["Return an error when TemperatureCorrection is incompatible for the given instrument:",
			ExperimentMeasurepH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
				TemperatureCorrection->Linear,
				Instrument->Model[Instrument, pHMeter, "Mettler Toledo InLab Micro"]
			],
			$Failed,
			Messages:>{
				Error::TemperatureCorrectionConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages,"pHProbeConflict","Return an error when the Probe is set Null, but the instrument requires it:"},
			ExperimentMeasurepH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
				Probe->Null,
				Instrument->Model[Instrument, pHMeter, "SevenExcellence (for pH)"]
			],
			$Failed,
			Messages:>{
				Error::pHProbeConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages,"pHProbeConflict","Return an error when the Probe is incompatible for the given instrument:"},
			ExperimentMeasurepH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
				Probe->Model[Part, pHProbe, "InLab Reach Pro-225"],
				Instrument->Model[Instrument, pHMeter, "Mettler Toledo InLab Micro"]
			],
			$Failed,
			Messages:>{
				Error::pHProbeConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages,"AcquisitionTimeConflict","Return an error for when AcquisitionTime is specified and the instrument is incapatible:"},
			ExperimentMeasurepH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
				Instrument->Model[Instrument, pHMeter, "SevenExcellence (for pH)"],
				AcquisitionTime->1 Minute],
			$Failed,
			Messages:>{
				Error::AcquisitionTimeConflict,
				Error::InvalidInput,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingReferencepHValues","Return an error for when the specified CalibrationBufferpH is different from what is in the model:"},
			ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],LowCalibrationBuffer->Model[Sample,"Reference Buffer - pH 4.63"],LowCalibrationBufferpH->6],
			$Failed,
			Messages:>{
				Error::ConflictingReferencepHValues,
				Error::InvalidOption
			}
		],
		Example[{Messages,"DeprecatedInstrumentModel","Return an error for when a deprecated instrument is specified:"},
			ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],Instrument->Model[Instrument, pHMeter, "Sensorex SG900C"]],
			$Failed,
			Messages:>{
				Error::DeprecatedInstrumentModel,
				Error::InvalidOption
			}
		],
		Example[{Messages,"LowAndHighpHValuesMustBeSpecified","Return an error for when both Low and High CalibrationBufferpH values are Null:"},
			ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],LowCalibrationBuffer->Object[Sample,"Test Medium calibration solution with no pH value for ExperimentMeasurepH " <> $SessionUUID],HighCalibrationBuffer->Object[Sample,"Another test calibration solution with no pH Value for ExperimentMeasurepH " <> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::LowAndHighpHValuesMustBeSpecified,
				Error::InvalidOption}
		],
		Example[{Messages,"MediumCalibrationOptionsRequiredTogether","Return an error for when one of MediumCalibrationBufferpH,MediumCalibrationBuffer is specified and the other Null:"},
			ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],MediumCalibrationBuffer->Object[Sample,"Test Medium calibration solution with no pH value for ExperimentMeasurepH " <> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::MediumCalibrationOptionsRequiredTogether,
				Error::InvalidOption
			}
		],

		Example[{Messages,"DiscardedSamples","Return an error for a discarded sample:"},
			ExperimentMeasurepH[Object[Sample, "Test discarded sample for ExperimentMeasurepH " <> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		], (*
		Example[{Messages,"InvalidContainer","Return an error for an invalid container type and Aliquot is False:"},
			ExperimentMeasurepH[Object[Container, ReactionVessel, "Test container 4 invalid for ExperimentMeasurepH " <> $SessionUUID],Aliquot->False],
			$Failed,
			Messages:>{
				Error::InvalidContainer,
				Error::InvalidInput,
				Error::InvalidOption
			}
		], *)
		Example[{Messages,"NoVolume","Return an error for samples that do not have a volume:"},
			ExperimentMeasurepH[Object[Sample, "Test water sample with Volume=Null for ExperimentMeasurepH " <> $SessionUUID], SecondaryWashSolution -> Null],
			$Failed,
			Messages:>{
				Error::NoVolume,
				Error::InvalidInput
			}
		],
		Example[{Messages,"EmptyContainers","Return an error for a container without a sample:"},
			ExperimentMeasurepH[Object[Container, Vessel, "Test container 5 with no sample for ExperimentMeasurepH " <> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::EmptyContainers
			}
		],
		Example[{Messages,"IncompatibleSample","Return an error for a sample incapable of measurement:"},
			ExperimentMeasurepH[Object[Sample,"Test incompatible sample for ExperimentMeasurepH " <> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::IncompatibleSample,
				Error::InvalidInput
			}
		],
		Example[{Messages,"IncompatibleSample","Return an error for a sample too acidic for measurement:"},
			ExperimentMeasurepH[Object[Sample,"Test too acidic sample for ExperimentMeasurepH " <> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::IncompatibleSample,
				Error::InvalidInput
			}
		],
		Example[{Messages,"IncompatibleSampleInstrument","Return an error when the sample to be measured is chemically incompatible with the specified instrument:"},
			ExperimentMeasurepH[Object[Sample,"Test anti-Glass chemical for ExperimentMeasurepH " <> $SessionUUID],Instrument->Object[Instrument, pHMeter, "Alsace"]],
			$Failed,
			Messages:>{
				Error::IncompatibleSample,
				Error::IncompatibleSampleInstrument,
				Error::InvalidInput,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InsufficientVolume","Return an error for too low sample volume, thereby incapable of measurement:"},

			ExperimentMeasurepH[Object[Sample, "Test sample with volume too low for measurement ExperimentMeasurepH " <> $SessionUUID], SecondaryWashSolution -> Null],
			$Failed,
			Messages:>{
				Error::InsufficientVolume,
				Error::InvalidInput
			}
		],
		Example[{Messages,"ConflictingInstrumentProbeType","Return an error for when the specified Instrument and ProbeType conflict:"},
			ExperimentMeasurepH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],ProbeType->Surface,Instrument->Model[Instrument,pHMeter,"Mettler Toledo InLab Reach 225"]],
			$Failed,
			Messages:>{
				Error::ConflictingInstrumentProbeType,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SurfaceAliquotConflict","Return a warning for InstrumentType==Surface and Aliquot==False:"},
			ExperimentMeasurepH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],ProbeType->Surface,Aliquot->False],
			ObjectP[Object[Protocol, MeasurepH]],
			Messages:>{
				Warning::SurfaceAliquotConflict
			},
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
		],
		(*Conflicting inputs*)
		Example[{Messages,"IncompatibleInstrument","Return an error when the Instrument is specified, Aliquot is false, and the Container is too big:"}, (*fix*)
			ExperimentMeasurepH[Object[Sample,"Test water sample for too large container for lil stick for ExperimentMeasurepH " <> $SessionUUID],Aliquot->False,Instrument->Model[Instrument, pHMeter, "Mettler Toledo InLab Micro"]],
			$Failed,
			Messages:>{
				Error::IncompatibleInstrument,
				Error::InvalidOption,
				Error::InvalidInput
			}
		],
		Example[{Messages,"NoAvailableInstruments","Return $Failed when a container with too low of liquid volume is enqueued without aliquot:"},
			ExperimentMeasurepH[Object[Sample,"Test water sample for too large container for ExperimentMeasurepH " <> $SessionUUID],Aliquot->False, SecondaryWashSolution -> Null],
			$Failed,
			Messages:>{
				Error::NoAvailablepHInstruments,
				Error::InvalidInput
			}
		],
		Example[{Options,ProbeType,"Indicate you'd like to use the surface probe:"},
			ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],ProbeType->Surface][Probes][ProbeType],
			{Surface}
		],
		Test["Use the surface probe when the volume is too small to be measured by any other method:",
			ExperimentMeasurepH[Object[Sample,"Surface probe test sample in tube for ExperimentMeasurepH " <> $SessionUUID], SecondaryWashSolution -> Null][Probes][ProbeType],
			{Surface}
		],
		Test["If Aliquot->False gives a warning that a portion of the sample will be used for the measurement:",
			ExperimentMeasurepH[Object[Sample,"Surface probe test sample in tube for ExperimentMeasurepH " <> $SessionUUID],Aliquot->False, SecondaryWashSolution -> Null][Probes][ProbeType],
			{Surface},
			Messages:>{Warning::SurfaceAliquotConflict}
		],
		Test["When a surface probe model is specified ProbeType resolves to Surface:",
			Lookup[
				ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],Probe->Model[Part, pHProbe, "id:J8AY5jDmW5ma"]][ResolvedOptions],
				ProbeType
			],
			Surface
		],
		Test["If there is a ParentProtocol and WasteBeaker is specified in this ParentProtocol, the new protocol of MeasurepH will use the same WasteBeaker:",
			ExperimentMeasurepH[
				Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
				ParentProtocol -> Object[Protocol, AdjustpH, "pH ParentProtocol for ExperimentMeasurepH " <> $SessionUUID]][WasteBeaker],
			LinkP[Object[Sample, "Water WasteBeaker for ExperimentMeasurepH " <> $SessionUUID]]
		],
		Test["When a surface probe instrument is specified ProbeType resolves to Surface:",
			Lookup[
				ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],Probe->Object[Part, pHProbe, "id:eGakldJEV194"]][ResolvedOptions],
				ProbeType
			],
			Surface,
			Messages:>{
				Warning::OptionContainsUnusableObject
			}
		],
		Test["Resolve calibration buffer rack and calibration wash solution rack:",
			protocol = ExperimentMeasurepH[Object[Sample,"Test water sample for ExperimentMeasurepH " <> $SessionUUID],SecondaryWashSolution -> Null];
			Download[protocol, {CalibrationBufferRack, CalibrationWashSolutionRack}],
			{LinkP[Model[Container, Rack, "id:dORYzZda6Yrb"]], LinkP[Model[Container, Rack, "id:dORYzZda6Yrb"]]},
			Variables:>{protocol}
		]
	},
	(* without this, telescope crashes and the test fails *)
	HardwareConfiguration->HighRAM,
	Stubs:>{
	},
	TurnOffMessages :> {
		Warning::SampleMustBeMoved
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects={};

		Module[{testObjList,existsFilter},

			testObjList = {
				Object[Container, Vessel, "Test container 1 for ExperimentMeasurepH " <> $SessionUUID],
				Object[Container, Vessel, "Test container 2 for ExperimentMeasurepH " <> $SessionUUID],
				Object[Container, Vessel, "Test container 3 for ExperimentMeasurepH " <> $SessionUUID],
				Object[Container, ReactionVessel, SolidPhaseSynthesis, "Test container 4 invalid for ExperimentMeasurepH " <> $SessionUUID],
				Object[Container, Vessel, "Test container 5 with no sample for ExperimentMeasurepH " <> $SessionUUID],
				Object[Container, Vessel, "Test container 6 that is too big for ExperimentMeasurepH " <> $SessionUUID],
				Object[Container, Vessel, "Test container 7 that is too large for lil stick for ExperimentMeasurepH " <> $SessionUUID],
				Object[Container, Vessel, "Test container 8 with incompatible sample for ExperimentMeasurepH " <> $SessionUUID],
				Object[Container, Vessel, "Test container 9 with too acidic sample for ExperimentMeasurepH " <> $SessionUUID],
				Object[Container, Vessel, "Test container 10 with anti-Glass sample for ExperimentMeasurepH " <> $SessionUUID],
				Object[Container, Vessel, "Test container 11 for No Volume sample for ExperimentMeasurepH " <> $SessionUUID],
				Model[Container, Vessel, "Test container model with no calibration data for ExperimentMeasurepH " <> $SessionUUID],
				Object[Container, Vessel, "Test container 12 for no calibration for ExperimentMeasurepH " <> $SessionUUID],
				Object[Container, Vessel, "Test container 13 for large sample volume for ExperimentMeasurepH " <> $SessionUUID],
				Object[Container, Vessel, "Test container 14 for MilliQ water for ExperimentMeasurepH " <> $SessionUUID],
				Object[Container, Vessel, "Test container 15 for medium calibration solution with no pH for ExperimentMeasurepH " <> $SessionUUID],
				Object[Container, Vessel, "Test container 16 for another calibration solution with no pH for ExperimentMeasurepH " <> $SessionUUID],
				Object[Container, Vessel, "Test container 17 for solution without a model for ExperimentMeasurepH " <> $SessionUUID],
				Object[Container, Vessel, "Test container 18 Stock pH 10 calibration solution for ExperimentMeasurepH " <> $SessionUUID],
				Object[Container, Vessel, "Test container 19 for extra large sample volume for ExperimentMeasurepH " <> $SessionUUID],
				Object[Container, Vessel, "Test container 20 for ExperimentMeasurepH " <> $SessionUUID],
				Object[Container, Vessel,"Test container 22 600ml beaker for ExperimentMeasurepH " <> $SessionUUID],
				Object[Container, Plate, "Test plate container for ExperimentMeasurepH " <> $SessionUUID],
				Object[Sample, "Test discarded sample for ExperimentMeasurepH " <> $SessionUUID],
				Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
				Object[Sample, "Test water sample in a plate for ExperimentMeasurepH " <> $SessionUUID],
				Object[Sample, "Test water sample for invalid container for ExperimentMeasurepH " <> $SessionUUID],
				Object[Sample, "Test sample with volume too low for measurement ExperimentMeasurepH " <> $SessionUUID],
				Object[Sample, "Test water sample for too large container for ExperimentMeasurepH " <> $SessionUUID],
				Object[Sample, "Test water sample for too large container for lil stick for ExperimentMeasurepH " <> $SessionUUID],
				Object[Sample, "Test water sample with Volume=Null for ExperimentMeasurepH " <> $SessionUUID],
				Object[Sample, "Test water sample for container sans calibration data for ExperimentMeasurepH " <> $SessionUUID],
				Object[Sample, "Large test water sample for ExperimentMeasurepH " <> $SessionUUID],
				Object[Sample, "Test incompatible sample for ExperimentMeasurepH " <> $SessionUUID],
				Object[Sample, "Test too acidic sample for ExperimentMeasurepH " <> $SessionUUID],
				Object[Sample, "Test anti-Glass chemical for ExperimentMeasurepH " <> $SessionUUID],
				Object[Sample, "Test MilliQ water sample for ExperimentMeasurepH " <> $SessionUUID],
				Object[Sample, "Test MilliQ water sample for sample without a model for ExperimentMeasurepH " <> $SessionUUID],
				Object[Sample, "Test Medium calibration solution with no pH value for ExperimentMeasurepH " <> $SessionUUID],
				Object[Sample, "Another test calibration solution with no pH Value for ExperimentMeasurepH " <> $SessionUUID],
				Object[Sample, "Stock pH 10 calibration solution for ExperimentMeasurepH " <> $SessionUUID],
				Object[Sample, "Extra large test water sample for ExperimentMeasurepH " <> $SessionUUID],
				Object[Sample, "Test sample in tube for ExperimentMeasurepH " <> $SessionUUID],
				Object[Sample, "Water WashSolution for ExperimentMeasurepH " <> $SessionUUID],
				Object[Sample, "Water WasteBeaker for ExperimentMeasurepH " <> $SessionUUID],
				Model[Sample, "Test chemical model incompatible for ExperimentMeasurepH " <> $SessionUUID],
				Model[Sample, "Test chemical model too acidic for ExperimentMeasurepH " <> $SessionUUID],
				Model[Sample, "Test medium calibration solution model with no pH for ExperimentMeasurepH " <> $SessionUUID],
				Model[Sample, "Another test calibration solution model with no pH for ExperimentMeasurepH " <> $SessionUUID],
				Object[Protocol, MeasurepH, "pH Test Template Protocol for ExperimentMeasurepH " <> $SessionUUID],
				Object[Sample, "Surface probe test sample in tube for ExperimentMeasurepH " <> $SessionUUID],
				Object[Container,Bench,"Bench for ExperimentMeasurepH tests" <> $SessionUUID],
				Object[Protocol, MeasurepH, "pH Subprotocol 1 for ExperimentMeasurepH " <> $SessionUUID],
				Object[Protocol, MeasurepH, "pH Subprotocol 2 for ExperimentMeasurepH " <> $SessionUUID],
				Object[Container, Vessel, "Test container 23 1000ml beaker for ExperimentMeasurepH " <> $SessionUUID],
				Object[Protocol, AdjustpH, "pH ParentProtocol for ExperimentMeasurepH " <> $SessionUUID]

			};
			(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
			(* Erase any objects that we failed to erase in the last unit test. *)
			existsFilter = DatabaseMemberQ[testObjList];

			EraseObject[PickList[testObjList, existsFilter], Force -> True, Verbose -> False];

		];
		Block[{$AllowPublicObjects = True, $DeveloperUpload = True},
			Module[
				{modelIncompat, tooAcidicModel, medCalNopHModel, anotherCalNopHModel, containerNoCalModel,
					emptyContainer1, emptyContainer2, emptyContainer3, emptyContainer4, emptyContainer5, emptyContainer6, plateSample,
					emptyContainer7, emptyContainer8, emptyContainer9, emptyContainer10, emptyContainer11, emptyContainer12,
					emptyContainer13, emptyContainer14, emptyContainer15, emptyContainer16,discardedChemical, waterSample, lowVolSample,
					invConSample, tooBigConSample, tooBigLilStickSample,incompatSample, tooAcidicSample, noVolumeSample, noCalSample,
					largeSample, milliQSample, mediumCalNopH, anotherCalNopH,modelLessSample,emptyContainer17,emptyContainer18,pH10Stock,emptyPlate,
					emptyContainer19, sample19, emptyContainer20,emptyContainer21,sample20,sample21,emptyContainer22,sample22,testBench,noGlassSample,
					emptyContainer23, subprotocol1, subprotocol2, parentProtocol,sample23},

				testBench = Upload[<|Type -> Object[Container, Bench],
					Site -> Link[$Site],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Bench for ExperimentMeasurepH tests" <> $SessionUUID,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>];

				(*Create some chemicals too corrosive for measurement as well as instrument models*)
				{modelIncompat, tooAcidicModel, medCalNopHModel, anotherCalNopHModel, containerNoCalModel} = Upload[{
					<|
						Type -> Model[Sample],
						Name -> "Test chemical model incompatible for ExperimentMeasurepH " <> $SessionUUID,
						State -> Liquid,
						Replace[Composition] -> {{Null,Null}},
						DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Append[IncompatibleMaterials] -> Glass
					|>,
					<|
						Type -> Model[Sample],
						Name -> "Test chemical model too acidic for ExperimentMeasurepH " <> $SessionUUID,
						State -> Liquid,
						Replace[Composition] -> {{Null,Null}},
						DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
					|>,
					(*Create a calibration solution model for medium with no pH value*)
					<|
						Type -> Model[Sample],
						Name -> "Test medium calibration solution model with no pH for ExperimentMeasurepH " <> $SessionUUID,
						State -> Liquid,
						Replace[Composition] -> {{Null,Null}},
						DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						pH -> Null
					|>,
					<|
						Type -> Model[Sample],
						Name -> "Another test calibration solution model with no pH for ExperimentMeasurepH " <> $SessionUUID,
						State -> Liquid,
						Replace[Composition] -> {{Null,Null}},
						DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						pH -> Null
					|>,
					(*Create container model with no calibration data*)
					<|Type -> Model[Container, Vessel],
						Name -> "Test container model with no calibration data for ExperimentMeasurepH " <> $SessionUUID,
						Deprecated -> False,
						DefaultStorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
						Dimensions -> {Quantity[0.028575`, "Meters"],
							Quantity[0.028575`, "Meters"],
							Quantity[0.1143`, "Meters"]},
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,
							MaxWidth -> Quantity[0.028575`, "Meters"],
							MaxDepth -> Quantity[0.028575`, "Meters"],
							MaxHeight -> Quantity[0.1143`, "Meters"]|>}
					|>
				}];

			(* Create some empty containers *)
			{
				emptyContainer1,
				emptyContainer2,
				emptyContainer3,
				emptyContainer4,
				emptyContainer5,
				emptyContainer6,
				emptyContainer7,
				emptyContainer8,
				emptyContainer9,
				emptyContainer10,
				emptyContainer11,
				emptyContainer12,
				emptyContainer13,
				emptyContainer14,
				emptyContainer15,
				emptyContainer16,
				emptyContainer17,
				emptyContainer18,
				emptyPlate,
				emptyContainer19,
				emptyContainer20,
				emptyContainer21,
				emptyContainer22,
				emptyContainer23
			}=
				 UploadSample[
				 {
					 Model[Container,Vessel,"50mL Tube"],
					 Model[Container,Vessel,"50mL Tube"],
					 Model[Container,Vessel,"50mL Tube"],
					 Model[Container,ReactionVessel,SolidPhaseSynthesis,"NAP 10 Gravity Cartridge"],
					 Model[Container,Vessel,"50mL Tube"],
					 Model[Container,Vessel,"10L Polypropylene Carboy"],
					 Model[Container,Vessel,"500mL Glass Bottle"],
					 Model[Container,Vessel,"50mL Tube"],
					 Model[Container,Vessel,"50mL Tube"],
					 Model[Container,Vessel,"50mL Tube"],
					 Model[Container,Vessel,"50mL Tube"],
					 containerNoCalModel,
					 Model[Container, Vessel, "1L Glass Bottle"],
					 Model[Container,Vessel,"50mL Tube"],
					 Model[Container,Vessel,"50mL Tube"],
					 Model[Container,Vessel,"50mL Tube"],
					 Model[Container,Vessel,"50mL Tube"],
					 Model[Container, Vessel, "1L Glass Bottle"],
					 Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					 Model[Container, Vessel, "id:Vrbp1jG800Zm"],
					 Model[Container,Vessel,"2mL Tube"],
					 Model[Container,Vessel,"2mL Tube"],
					 Model[Container, Vessel, "600mL Pyrex Beaker"],
					 Model[Container, Vessel, "1000mL Glass Beaker"]
				 },
				 {
					 {"Work Surface",testBench},
					 {"Work Surface",testBench},
					 {"Work Surface",testBench},
					 {"Work Surface",testBench},
					 {"Work Surface",testBench},
					 {"Work Surface",testBench},
					 {"Work Surface",testBench},
					 {"Work Surface",testBench},
					 {"Work Surface",testBench},
					 {"Work Surface",testBench},
					 {"Work Surface",testBench},
					 {"Work Surface",testBench},
					 {"Work Surface",testBench},
					 {"Work Surface",testBench},
					 {"Work Surface",testBench},
					 {"Work Surface",testBench},
					 {"Work Surface",testBench},
					 {"Work Surface",testBench},
					 {"Work Surface",testBench},
					 {"Work Surface",testBench},
					 {"Work Surface",testBench},
					 {"Work Surface",testBench},
					 {"Work Surface",testBench},
					 {"Work Surface",testBench}
				 },
				 Status->Available,
				 Name->{
					 "Test container 1 for ExperimentMeasurepH " <> $SessionUUID,
					 "Test container 2 for ExperimentMeasurepH " <> $SessionUUID,
					 "Test container 3 for ExperimentMeasurepH " <> $SessionUUID,
					 "Test container 4 invalid for ExperimentMeasurepH " <> $SessionUUID,
					 "Test container 5 with no sample for ExperimentMeasurepH " <> $SessionUUID,
					 "Test container 6 that is too big for ExperimentMeasurepH " <> $SessionUUID,
					 "Test container 7 that is too large for lil stick for ExperimentMeasurepH " <> $SessionUUID,
					 "Test container 8 with incompatible sample for ExperimentMeasurepH " <> $SessionUUID,
					 "Test container 9 with too acidic sample for ExperimentMeasurepH " <> $SessionUUID,
					 "Test container 10 with anti-Glass sample for ExperimentMeasurepH " <> $SessionUUID,
					 "Test container 11 for No Volume sample for ExperimentMeasurepH " <> $SessionUUID,
					 "Test container 12 for no calibration for ExperimentMeasurepH " <> $SessionUUID,
					 "Test container 13 for large sample volume for ExperimentMeasurepH " <> $SessionUUID,
					 "Test container 14 for MilliQ water for ExperimentMeasurepH " <> $SessionUUID,
					 "Test container 15 for medium calibration solution with no pH for ExperimentMeasurepH " <> $SessionUUID,
					 "Test container 16 for another calibration solution with no pH for ExperimentMeasurepH " <> $SessionUUID,
					 "Test container 17 for solution without a model for ExperimentMeasurepH " <> $SessionUUID,
					 "Test container 18 Stock pH 10 calibration solution for ExperimentMeasurepH " <> $SessionUUID,
					 "Test plate container for ExperimentMeasurepH " <> $SessionUUID,
					 "Test container 19 for extra large sample volume for ExperimentMeasurepH " <> $SessionUUID,
					 "Test container 20 for ExperimentMeasurepH " <> $SessionUUID,
					 Null,
					 "Test container 22 600ml beaker for ExperimentMeasurepH " <> $SessionUUID,
					 "Test container 23 1000ml beaker for ExperimentMeasurepH " <> $SessionUUID
				 }
			 ];

			(* Create some samples *)
			{discardedChemical,waterSample,lowVolSample,invConSample,tooBigConSample,tooBigLilStickSample,
				incompatSample,tooAcidicSample,noGlassSample,noVolumeSample,noCalSample,largeSample,milliQSample,
				mediumCalNopH,anotherCalNopH,modelLessSample,pH10Stock,plateSample,sample19,sample20,sample21,sample22,sample23}=UploadSample[
				{
					(*1*)Model[Sample, StockSolution, "Red Food Dye Test Solution"],
					(*2*)Model[Sample, StockSolution, "Red Food Dye Test Solution"],
					(*3*)Model[Sample, StockSolution, "Red Food Dye Test Solution"],
					(*4*)Model[Sample, StockSolution, "Red Food Dye Test Solution"],
					(*5*)Model[Sample, StockSolution, "Red Food Dye Test Solution"],
					(*6*)Model[Sample, StockSolution, "Red Food Dye Test Solution"],
					(*7*)modelIncompat,
					(*8*)tooAcidicModel,
					(*9*)Model[Sample, "id:XnlV5jK6jbk3"],
					(*10*)Model[Sample, StockSolution, "Red Food Dye Test Solution"],
					(*11*)Model[Sample, StockSolution, "Red Food Dye Test Solution"],
					(*12*)Model[Sample, StockSolution, "Red Food Dye Test Solution"],
					(*13*)Model[Sample, "Milli-Q water"],
					(*14*)medCalNopHModel,
					(*15*)anotherCalNopHModel,
					(*16*)Model[Sample, "Milli-Q water"],
					(*17*)Model[Sample, "Reference buffer, pH 10"],
					(*18*)Model[Sample, StockSolution, "Red Food Dye Test Solution"],
					(*19*)Model[Sample, StockSolution, "Red Food Dye Test Solution"],
					(*20*)Model[Sample, StockSolution, "Red Food Dye Test Solution"],
					(*21*)Model[Sample, StockSolution, "Red Food Dye Test Solution"],
					(*22*)Model[Sample, "Milli-Q water"],
					(*23*)Model[Sample, "Milli-Q water"]
				},
				{
					(*1*){"A1",emptyContainer1},
					(*2*){"A1",emptyContainer2},
					(*3*){"A1",emptyContainer3},
					(*4*){"A1",emptyContainer4},
					(*5*){"A1",emptyContainer6},
					(*6*){"A1",emptyContainer7},
					(*7*){"A1",emptyContainer8},
					(*8*){"A1",emptyContainer9},
					(*9*){"A1",emptyContainer10},
					(*10*){"A1",emptyContainer11},
					(*11*){"A1",emptyContainer12},
					(*12*){"A1",emptyContainer13},
					(*13*){"A1",emptyContainer14},
					(*14*){"A1",emptyContainer15},
					(*15*){"A1",emptyContainer16},
					(*16*){"A1",emptyContainer17},
					(*17*){"A1",emptyContainer18},
					(*18*){"A1",emptyPlate},
					(*19*){"A1",emptyContainer19},
					(*20*){"A1",emptyContainer20},
					(*21*){"A1",emptyContainer21},
					(*22*){"A1",emptyContainer22},
					(*23*){"A1",emptyContainer23}
				},
				InitialAmount->{
					(*1*)50 Milliliter,
					(*2*)50 Milliliter,
					(*3*)0.009 Milliliter,
					(*4*)1 Milliliter,
					(*5*)1Milliliter,
					(*6*)102 Milliliter,
					(*7*)50 Milliliter,
					(*8*)50 Milliliter,
					(*9*)50 Milliliter,
					(*10*)Null,
					(*11*)50 Milliliter,
					(*12*)350 Milliliter,
					(*13*)50 Milliliter,
					(*14*)50 Milliliter,
					(*15*)50 Milliliter,
					(*16*)20 Milliliter,
					(*17*)1 Liter,
					(*18*)1 Milliliter,
					(*19*)3 Liter,
					(*20*)1 Milliliter,
					(*21*)60 Microliter,
					(*22*)400 Milliliter,
					(*22*)200 Milliliter
				},
				Name->{
					(*1*)"Test discarded sample for ExperimentMeasurepH " <> $SessionUUID,
					(*2*)"Test water sample for ExperimentMeasurepH " <> $SessionUUID,
					(*3*)"Test sample with volume too low for measurement ExperimentMeasurepH " <> $SessionUUID,
					(*4*)"Test water sample for invalid container for ExperimentMeasurepH " <> $SessionUUID,
					(*5*)"Test water sample for too large container for ExperimentMeasurepH " <> $SessionUUID,
					(*6*)"Test water sample for too large container for lil stick for ExperimentMeasurepH " <> $SessionUUID,
					(*7*)"Test incompatible sample for ExperimentMeasurepH " <> $SessionUUID,
					(*8*)"Test too acidic sample for ExperimentMeasurepH " <> $SessionUUID,
					(*9*)"Test anti-Glass chemical for ExperimentMeasurepH " <> $SessionUUID,
					(*10*)"Test water sample with Volume=Null for ExperimentMeasurepH " <> $SessionUUID,
					(*11*)"Test water sample for container sans calibration data for ExperimentMeasurepH " <> $SessionUUID,
					(*12*)"Large test water sample for ExperimentMeasurepH " <> $SessionUUID,
					(*13*)"Test MilliQ water sample for ExperimentMeasurepH " <> $SessionUUID,
					(*14*)"Test Medium calibration solution with no pH value for ExperimentMeasurepH " <> $SessionUUID,
					(*15*)"Another test calibration solution with no pH Value for ExperimentMeasurepH " <> $SessionUUID,
					(*16*)"Test MilliQ water sample for sample without a model for ExperimentMeasurepH " <> $SessionUUID,
					(*17*)"Stock pH 10 calibration solution for ExperimentMeasurepH " <> $SessionUUID,
					(*18*)"Test water sample in a plate for ExperimentMeasurepH " <> $SessionUUID,
					(*19*)"Extra large test water sample for ExperimentMeasurepH " <> $SessionUUID,
					(*20*)"Test sample in tube for ExperimentMeasurepH " <> $SessionUUID,
					(*21*)"Surface probe test sample in tube for ExperimentMeasurepH " <> $SessionUUID,
					(*22*)"Water WashSolution for ExperimentMeasurepH " <> $SessionUUID,
					(*23*)"Water WasteBeaker for ExperimentMeasurepH " <> $SessionUUID
				}
			];

				(* Make some changes to our samples to make them invalid. *)

			Upload[{
				<|Object -> discardedChemical, Status -> Discarded|>,
				<|
					Object -> waterSample,
					Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]], Now}, {10 Micromolar, Link[Model[Molecule, "Uracil"]], Now}},
					pH -> 7.0
				|>,
				<|Object -> lowVolSample, pH -> 7.0|>,
				<|Object -> noVolumeSample, pH -> 7.0 |>,
				<|Object -> tooAcidicSample, pH -> -0.0001|>,
				<|Object -> largeSample, pH -> 7.0|>,
				<|Object -> modelLessSample, Model -> Null|>
			}];

				(*Create a protocol that we'll use for template testing*)
				Block[{$PersonID = Object[User, "Test user for notebook-less test protocols"]},
					(*Create a protocol that we'll use for template testing*)
					ExperimentMeasurepH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
						AliquotAmount -> 25*Milliliter,
						Name -> "pH Test Template Protocol for ExperimentMeasurepH " <> $SessionUUID]
				];

				subprotocol1 = Block[{$PersonID = Object[User, "Test user for notebook-less test protocols"]},
					(*Create a protocol that we'll use for template testing*)
					ExperimentMeasurepH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
						Name -> "pH Subprotocol 1 for ExperimentMeasurepH " <> $SessionUUID]
				];
				subprotocol2 = Block[{$PersonID = Object[User, "Test user for notebook-less test protocols"]},
					(*Create a protocol that we'll use for template testing*)
					ExperimentMeasurepH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],
						Name -> "pH Subprotocol 2 for ExperimentMeasurepH " <> $SessionUUID]
				];
				parentProtocol = Block[{$PersonID = Object[User, "Test user for notebook-less test protocols"]},
					(*Create a protocol that we'll use for template testing*)
					ExperimentAdjustpH[Object[Sample, "Test water sample for ExperimentMeasurepH " <> $SessionUUID],8,
						Name -> "pH ParentProtocol for ExperimentMeasurepH " <> $SessionUUID]
				];

				Upload[<|
					Object -> parentProtocol,
					WasteBeaker -> Link[Object[Sample, "Water WasteBeaker for ExperimentMeasurepH " <> $SessionUUID]],
					Replace[Subprotocols] -> Link[Object[Protocol, MeasurepH, "pH Subprotocol 1 for ExperimentMeasurepH " <> $SessionUUID], ParentProtocol],
					Append[Subprotocols] -> Link[Object[Protocol, MeasurepH, "pH Subprotocol 2 for ExperimentMeasurepH " <> $SessionUUID], ParentProtocol]
				|>]

			]
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];

DefineTests[
	ExperimentMeasurepHOptions,
	{
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			ExperimentMeasurepHOptions[Object[Sample,"Test water sample for ExperimentMeasurepHOptions " <> $SessionUUID]],
			_Grid
		],
		Example[{Basic,"View any potential issues with provided inputs/options displayed:"},
			ExperimentMeasurepHOptions[Object[Sample,"Test discarded sample for ExperimentMeasurepHOptions " <> $SessionUUID]],
			_Grid,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentMeasurepHOptions[Object[Sample,"Test water sample for ExperimentMeasurepHOptions " <> $SessionUUID],OutputFormat->List],
			{(_Rule|_RuleDelayed)..}
		]
	},
	TurnOffMessages :> {
		Warning::SampleMustBeMoved
	},
	SymbolSetUp:>(
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		testObjList={
			Object[Container,Vessel,"Test container 1 for ExperimentMeasurepHOptions " <> $SessionUUID],
			Object[Container,Vessel,"Test container 2 for ExperimentMeasurepHOptions " <> $SessionUUID],
			Object[Container, Vessel, "Test container 3 Stock pH 10 calibration solution for ExperimentMeasurepHOptions " <> $SessionUUID],

			Object[Sample,"Test discarded sample for ExperimentMeasurepHOptions " <> $SessionUUID],
			Object[Sample,"Test water sample for ExperimentMeasurepHOptions " <> $SessionUUID],
			Object[Sample, "Stock pH 10 calibration solution for ExperimentMeasurepHOptions " <> $SessionUUID]

		};
		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		existsFilter=DatabaseMemberQ[testObjList];

		EraseObject[PickList[testObjList,existsFilter],Force->True,Verbose->False];

		(* Create some empty containers *)
		{emptyContainer1,emptyContainer2,emptyContainer3}=Upload[{
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 1 for ExperimentMeasurepHOptions " <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 2 for ExperimentMeasurepHOptions " <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "1L Glass Bottle"],Objects],
				Name->"Test container 3 Stock pH 10 calibration solution for ExperimentMeasurepHOptions " <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>
		}];


		(* Create some samples *)
		{discardedChemical,waterSample,another}=ECL`InternalUpload`UploadSample[
			{
				Model[Sample, StockSolution, "Red Food Dye Test Solution"],
				Model[Sample, StockSolution, "Red Food Dye Test Solution"],
				Model[Sample, "Reference buffer, pH 10"]
			},
			{
				{"A1",emptyContainer1},{"A1",emptyContainer2},{"A1",emptyContainer3}
			},
			InitialAmount->{50 Milliliter,50 Milliliter,1 Liter},
			Name->{
				"Test discarded sample for ExperimentMeasurepHOptions " <> $SessionUUID,
				"Test water sample for ExperimentMeasurepHOptions " <> $SessionUUID,
				"Stock pH 10 calibration solution for ExperimentMeasurepHOptions " <> $SessionUUID
			}
		];

		(* Make some changes to our samples to make them invalid. *)

		Upload[{
			<|Object->discardedChemical,Status->Discarded,DeveloperObject->True|>,
			<|Object->waterSample,Concentration->10*Micromolar,DeveloperObject->True|>
		}]


	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];


DefineTests[
	ValidExperimentMeasurepHQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issues:"},
			ValidExperimentMeasurepHQ[Object[Sample,"Test water sample for ValidExperimentMeasurepHQ " <> $SessionUUID]],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentMeasurepHQ[Object[Sample,"Test discarded sample for ValidExperimentMeasurepHQ " <> $SessionUUID]],
			False
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentMeasurepHQ[Object[Sample,"Test water sample for ValidExperimentMeasurepHQ " <> $SessionUUID],OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentMeasurepHQ[Object[Sample,"Test water sample for ValidExperimentMeasurepHQ " <> $SessionUUID],Verbose->True],
			True
		]
	},
	TurnOffMessages :> {
		Warning::SampleMustBeMoved
	},
	SymbolSetUp:>Module[{testObjList, existsFilter, emptyContainer1, emptyContainer2, emptyContainer3, discardedChemical, waterSample, another},
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		testObjList={
			Object[Container,Vessel,"Test container 1 for ValidExperimentMeasurepHQ " <> $SessionUUID],
			Object[Container,Vessel,"Test container 2 for ValidExperimentMeasurepHQ " <> $SessionUUID],
			Object[Container, Vessel, "Test container 3 Stock pH 10 calibration solution for ValidExperimentMeasurepHQ " <> $SessionUUID],

			Object[Sample,"Test discarded sample for ValidExperimentMeasurepHQ " <> $SessionUUID],
			Object[Sample,"Test water sample for ValidExperimentMeasurepHQ " <> $SessionUUID],
			Object[Sample, "Stock pH 10 calibration solution for ValidExperimentMeasurepHQ " <> $SessionUUID]

		};
		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		existsFilter=DatabaseMemberQ[testObjList];

		EraseObject[PickList[testObjList,existsFilter],Force->True,Verbose->False];

		(* Create some empty containers *)
		{emptyContainer1,emptyContainer2,emptyContainer3}=Upload[{
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 1 for ValidExperimentMeasurepHQ " <> $SessionUUID,
				DeveloperObject->True,
				Site->Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 2 for ValidExperimentMeasurepHQ " <> $SessionUUID,
				DeveloperObject->True,
				Site->Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "1L Glass Bottle"],Objects],
				Name->"Test container 3 Stock pH 10 calibration solution for ValidExperimentMeasurepHQ " <> $SessionUUID,
				DeveloperObject->True,
				Site->Link[$Site]
			|>
		}];


		(* Create some samples *)
		{discardedChemical,waterSample,another}=ECL`InternalUpload`UploadSample[
			{
				Model[Sample, StockSolution, "Red Food Dye Test Solution"],
				Model[Sample, StockSolution, "Red Food Dye Test Solution"],
				Model[Sample, "Reference buffer, pH 10"]
			},
			{
				{"A1",emptyContainer1},{"A1",emptyContainer2},{"A1",emptyContainer3}
			},
			InitialAmount->{50 Milliliter,50 Milliliter, 1 Liter},
			Name->{
				"Test discarded sample for ValidExperimentMeasurepHQ " <> $SessionUUID,
				"Test water sample for ValidExperimentMeasurepHQ " <> $SessionUUID,
				"Stock pH 10 calibration solution for ValidExperimentMeasurepHQ " <> $SessionUUID
			}
		];

		(* Make some changes to our samples to make them invalid. *)

		Upload[{
			<|Object->discardedChemical,Status->Discarded,DeveloperObject->True|>,
			<|Object->waterSample,Concentration->10*Micromolar,DeveloperObject->True|>
		}]

	],
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];

DefineTests[
	ExperimentMeasurepHPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentMeasurepH:"},
			ExperimentMeasurepHPreview[Object[Sample,"Test water sample for ExperimentMeasurepHPreview " <> $SessionUUID]],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed, try using ExperimentMeasurepHOptions:"},
			ExperimentMeasurepHOptions[Object[Sample,"Test water sample for ExperimentMeasurepHPreview " <> $SessionUUID]],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentMeasurepHQ:"},
			ValidExperimentMeasurepHQ[Object[Sample,"Test water sample for ExperimentMeasurepHPreview " <> $SessionUUID]],
			True
		]
	},
	TurnOffMessages :> {
		Warning::SampleMustBeMoved
	},
	SymbolSetUp:>Module[{testObjList, existsFilter, emptyContainer1, emptyContainer2, emptyContainer3, discardedChemical, waterSample, another},
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		testObjList={
			Object[Container,Vessel,"Test container 1 for ExperimentMeasurepHPreview " <> $SessionUUID],
			Object[Container,Vessel,"Test container 2 for ExperimentMeasurepHPreview " <> $SessionUUID],
			Object[Container, Vessel, "Test container 3 Stock pH 10 calibration solution for ExperimentMeasurepHPreview " <> $SessionUUID],

			Object[Sample,"Test discarded sample for ExperimentMeasurepHPreview " <> $SessionUUID],
			Object[Sample,"Test water sample for ExperimentMeasurepHPreview " <> $SessionUUID],
			Object[Sample, "Stock pH 10 calibration solution for ExperimentMeasurepHPreview " <> $SessionUUID]

		};
		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		existsFilter=DatabaseMemberQ[testObjList];

		EraseObject[PickList[testObjList,existsFilter],Force->True,Verbose->False];

		(* Create some empty containers *)
		{emptyContainer1,emptyContainer2,emptyContainer3}=Upload[{
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 1 for ExperimentMeasurepHPreview " <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 2 for ExperimentMeasurepHPreview " <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "1L Glass Bottle"],Objects],
				Name->"Test container 3 Stock pH 10 calibration solution for ExperimentMeasurepHPreview " <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>
		}];


		(* Create some samples *)
		{discardedChemical,waterSample,another}=UploadSample[
			{
				Model[Sample, StockSolution, "Red Food Dye Test Solution"],
				Model[Sample, StockSolution, "Red Food Dye Test Solution"],
				Model[Sample, "Reference buffer, pH 10"]
			},
			{
				{"A1",emptyContainer1},{"A1",emptyContainer2},{"A1",emptyContainer3}
			},
			InitialAmount->{50 Milliliter,50 Milliliter,1 Liter},
			Name->{
				"Test discarded sample for ExperimentMeasurepHPreview " <> $SessionUUID,
				"Test water sample for ExperimentMeasurepHPreview " <> $SessionUUID,
				"Stock pH 10 calibration solution for ExperimentMeasurepHPreview " <> $SessionUUID
			}
		];

		(* Make some changes to our samples to make them invalid. *)

		Upload[{
			<|Object->discardedChemical,Status->Discarded,DeveloperObject->True|>,
			<|Object->waterSample,Concentration->10*Micromolar,DeveloperObject->True|>
		}]


	],
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];
