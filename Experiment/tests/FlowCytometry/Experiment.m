(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentFlowCytometry: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentFlowCytometry*)

DefineTests[
	ExperimentFlowCytometry,
	{
		(* Ya Basic *)
		Example[{Basic,"Takes a sample object:"},
			ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID]],
			ObjectP[Object[Protocol, FlowCytometry]]
		],
		Example[{Basic,"Accepts a list of sample objects:"},
			ExperimentFlowCytometry[{Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], Object[Sample, "sample 2 in 50mL tube for ExperimentFlowCytometry testing"<> $SessionUUID]}],
			ObjectP[Object[Protocol, FlowCytometry]]
		],
		Example[{Basic,"Generate protocol for flowing samples in a plate object:"},
			ExperimentFlowCytometry[Object[Container,Plate, "plate for ExperimentFlowCytometry tests"<> $SessionUUID]],
			ObjectP[Object[Protocol, FlowCytometry]]
		],
		Example[{Basic,"Accepts a list of plate objects:"},
			ExperimentFlowCytometry[{Object[Container,Plate, "plate for ExperimentFlowCytometry tests"<> $SessionUUID],Object[Container,Plate, "plate for ExperimentFlowCytometry tests"<> $SessionUUID]}],
			ObjectP[Object[Protocol, FlowCytometry]]
		],
		Example[{Basic,"Takes a sample object with a severed model:"},
			ExperimentFlowCytometry[Object[Sample,"sample with no model in 50mL tube for ExperimentFlowCytometry testing"<> $SessionUUID]],
			ObjectP[Object[Protocol, FlowCytometry]]
		],
		Example[{Additional,"Accepts {Position,Plate}}:"},
			ExperimentFlowCytometry[{"A1",Object[Container,Plate, "plate for ExperimentFlowCytometry tests"<> $SessionUUID]}],
			ObjectP[Object[Protocol, FlowCytometry]]
		],
		Example[{Additional,"Accepts a list of plate objects:"},
			ExperimentFlowCytometry[{{"A1",Object[Container,Plate, "plate for ExperimentFlowCytometry tests"<> $SessionUUID]},Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID]}],
			ObjectP[Object[Protocol, FlowCytometry]]
		],
		(* --- InValidOptions --- *)
		Example[{Messages, "ConflictingContinuousModeFlowRateOptions", "If a Continuous injection mode is selected the flow rate must be the same for each sample and 0.5-2.5 µl/sec:"},
			ExperimentFlowCytometry[
				{
					Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
					Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID]
				},
				InjectionMode -> Continuous,
				FlowRate -> {1 Microliter/Second, 1.5 Microliter/Second}
			],
			$Failed,
			Messages :> {
				Error::ConflictingContinuousModeFlowRateOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingContinuousModeFlowRateOptions", "If a Continuous injection mode is selected the flow rate must be the same for each sample and 0.5-2.5 µl/sec:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				InjectionMode -> Continuous,
				FlowRate -> 3 Microliter/Second
			],
			$Failed,
			Messages :> {
				Error::ConflictingContinuousModeFlowRateOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingContinuousModeLimitOptions", "If a Continuous injection mode is selected the flow rate must be the same for each sample and 0.5-2.5 µl/sec:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				InjectionMode -> Continuous,
				MaxEvents -> 1000
			],
			$Failed,
			Messages :> {
				Error::ConflictingContinuousModeLimitOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingContinuousModeLimitOptions", "If a Continuous injection mode is selected the flow rate must be the same for each sample and 0.5-2.5 µl/sec:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				InjectionMode -> Continuous,
				MaxGateEvents -> 1000
			],
			$Failed,
			Messages :> {
				Error::ConflictingContinuousModeLimitOptions,
				Error::ConflictingGateOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingFlushInjectionOptions", "If Flush is selected CellCount and Continuous injection mode are not selected:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				InjectionMode -> Continuous,
				Flush -> True
			],
			$Failed,
			Messages :> {
				Error::ConflictingFlushInjectionOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingContinuousModeOptions", "If a Continuous InjectionMode is selected and CellCount is True, throw an error:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				InjectionMode->Continuous,
				CellCount->True
			],
			$Failed,
			Messages :> {
				Error::ConflictingContinuousModeOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingContinuousModeOptions", "If a Continuous InjectionMode is selected and RecoupSample is True, throw an error:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				InjectionMode->Continuous,
				RecoupSample->True
			],
			$Failed,
			Messages :> {
				Error::ConflictingContinuousModeOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingPreparedPlateReagentOptions", "If a PreparedPlate is selected and Reagent addition options are selected, throw an error:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 10 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
				PreparedPlate->True,
				AddReagent->True
			],
			$Failed,
			Messages :> {
				Error::ConflictingPreparedPlateReagentOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingPreparedPlateBlankOptions", "If a PreparedPlate is selected and Blank options are selected, throw an error:"},
			ExperimentFlowCytometry[
				Object[Sample,"sample 10 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
				PreparedPlate->True,
				Blank->Model[Sample,"Milli-Q water"]
			],
			$Failed,
			Messages :> {
				Error::ConflictingPreparedPlateBlankOptions,
				Error::ConflictingFlowInjectionTableBlankOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingPreparedPlateUnstainedSampleOptions", "If a PreparedPlate is selected and UnstainedSample options are selected, throw an error:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 10 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
				PreparedPlate->True,
				UnstainedSample->Model[Sample,"Milli-Q water"]
			],
			$Failed,
			Messages :> {
				Error::ConflictingPreparedPlateUnstainedSampleOptions,
				Error::ConflictingPreparedPlateInjectionOrder,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingPreparedPlateAdjustmentSampleOptions", "If a PreparedPlate is selected and AdjustmentSample options are selected, throw an error:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 10 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
				PreparedPlate->True,
				AdjustmentSample->Model[Sample,"Milli-Q water"]
			],
			$Failed,
			Messages :> {
				Error::ConflictingPreparedPlateAdjustmentSampleOptions,
				Error::ConflictingPreparedPlateInjectionOrder,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingPreparedPlateInjectionOrder", "If a PreparedPlate is selected and the samples positions in the injection table, throw an error:"},
			ExperimentFlowCytometry[
				{Object[Sample, "sample 9 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
					Object[Sample, "sample 10 in plate for ExperimentFlowCytometry testing"<> $SessionUUID]},
				PreparedPlate -> True,
				InjectionTable -> {
					{Sample, Object[Sample, "sample 10 in plate for ExperimentFlowCytometry testing"<> $SessionUUID], 40*Microliter, 10 Second},
					{Sample, Object[Sample, "sample 9 in plate for ExperimentFlowCytometry testing"<> $SessionUUID], 40*Microliter, 10 Second}}
			],
			$Failed,
			Messages :> {
				Error::ConflictingPreparedPlateInjectionOrder,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingAgitationOptions", "If a AgitationFrequency is given, Agitation is not selected:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				AgitationFrequency->1,
				Agitate->False
			],
			$Failed,
			Messages :> {
				Error::ConflictingAgitationOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "MustSpecifyAgitationTime", "If a Agitate is specified, AgitationTime is not Null:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				AgitationTime->Null,
				Agitate->True
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyAgitationTime,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingFlushOptions", "If a Flush is specified, FlushFrequency, FlushSample and FlushSpeed are not Null:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Flush->True,
				FlushFrequency->Null
			],
			$Failed,
			Messages :> {
				Error::ConflictingFlushOptions,
				Error::InvalidOption
			}
		],
		(*)
		Example[{Messages, "ConflictingDetectorsAndFluorophores", "The Detector matches the excitation and emission wavelengths of a fuorophore present on an input sample:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Detector -> "488 692/80"
			],
			ObjectP[Object[Protocol,FlowCytometry]],
			Messages :> {
				Warning::ConflictingDetectorsAndFluorophores,
				Warning::FlowCytometryDetectorNotRecommended
			}
		],*)(*)
		Example[{Messages, "ConflictingDetecorAndDetectionLabel", "The Detector matches the excitation and emission wavelengths of the DetectionLabel:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Detector -> "488 692/80",
				DetectionLabel->Model[Molecule, "id:Vrbp1jK1LPom"]
			],
			ObjectP[Object[Protocol,FlowCytometry]],
			Messages :> {
				Warning::ConflictingDetectorsAndFluorophores,
				Warning::ConflictingDetecorAndDetectionLabel,
				Warning::FlowCytometryDetectorNotRecommended
			}
		],*)
		Example[{Messages, "ConflictingExcitationWavelengthDetector", "The ExcitationWaveLength Matches the detector:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Detector -> "488 525/35",
				ExcitationWavelength -> 405 Nanometer
			],
			$Failed,
			Messages :> {
				Error::ConflictingExcitationWavelengthDetector,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingNeutralDensityFilter", "The ExcitationWaveLength Matches the detector:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Detector -> "488 525/35",
				NeutralDensityFilter -> True
			],
			$Failed,
			Messages :> {
				Error::ConflictingNeutralDensityFilter,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FlowCytometerLaserPowerTooHigh", "The ExcitationPower is too high, throw an error:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 7 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
				Detector -> "355 387/11",
				ExcitationWavelength -> 355 Nanometer,
				ExcitationPower -> 70 Milli*Watt
			],
			$Failed,
			Messages :> {
				Error::FlowCytometerLaserPowerTooHigh,
				Error::InvalidOption
			}
		],
		Example[{Messages, "GainOptimizationOptions", "AdjustmentSample or TargetSaturationPercentage are Null if and only if Gains is not Auto:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Gain -> 50Volt,
				TargetSaturationPercentage -> 70 Percent
			],
			$Failed,
			Messages :> {
				Error::GainOptimizationOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingSecondaryTriggerOptions", "SecondaryTriggerDetector is Null if and only if SecondaryTriggerThreshold is Null:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				SecondaryTriggerDetector -> "488 FSC",
				SecondaryTriggerThreshold -> Null
			],
			$Failed,
			Messages :> {
				Error::ConflictingSecondaryTriggerOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingGateOptions", "MaxGateEvents is None if and only if GateRegion is Null:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				MaxGateEvents -> 80000,
				GateRegion -> Null
			],
			$Failed,
			Messages :> {
				Error::ConflictingGateOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "MustSpecifyAdjustmentSamplesForCompensation", "If IncludeCompensationSamples is True, AdjustmentSamples are provided:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				IncludeCompensationSamples -> True,
				Detector -> {"488 FSC", "488 SSC", "488 525/35"},
				AdjustmentSample -> Null,
				Gain -> 50 Volt
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyAdjustmentSamplesForCompensation,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingAddReagentOptions", "AddReagent is False if and only if  Reagent addition options are Null:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				AddReagent -> False,
				ReagentVolume->100Microliter
			],
			$Failed,
			Messages :> {
				Error::ConflictingAddReagentOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingNeedleWashOptions", "NeedleWash is False if and only if  NeedleWash  options are Null:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				NeedleWash -> True,
				NeedleInsideWashTime -> Null
			],
			$Failed,
			Messages :> {
				Error::ConflictingNeedleWashOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingBlankOptions", "If no InjectionTable is provided, Blank is Null if and only if BlankInjectionVolume and BlankFrequency are Null:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Blank -> Null,
				BlankFrequency -> 1
			],
			$Failed,
			Messages :> {
				Error::ConflictingBlankOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingCellCountMaxEvents", "If CellCount is True, only a VolumeLimit can be used:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				CellCount -> True,
				MaxEvents -> 1000
			],
			$Failed,
			Messages :> {
				Error::ConflictingCellCountMaxEvents,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FlowCytometryTooManySamples", "The number of input samples cannot fit onto the instrument in a single protocol:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				NumberOfReplicates->97
			],
			$Failed,
			Messages :> {
				Error::FlowCytometryTooManySamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "ConflictingFlushOptions", "If Flush is True, and FlushSample is Null, throw an error:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Flush -> True,
				FlushSample -> Null
			],
			$Failed,
			Messages :> {
				Error::ConflictingFlushOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingFlowInjectionTableBlankOptions", "If the Blank and BlankFrequency options do not match the provided InjectionTable, throw an error:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				NumberOfReplicates->2,
				Blank->Null,
				InjectionTable->{
					{Sample, Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], 40*Microliter, 10 Second},
					{Blank, Model[Sample, StockSolution, "Filtered PBS, Sterile"], 200*Microliter, 0 Second},
					{Sample, Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], 40 Microliter, 5 Second}
				}
			],
			$Failed,
			Messages :> {
				Error::ConflictingFlowInjectionTableBlankOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingFlowInjectionTable", "If the Types and Samples in the provided InjectionTable do not match the Samples, UnstainedSample and AdjustmentSamples, throw an error:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				InjectionTable->{
					{AdjustmentSample, Model[Sample, "id:AEqRl9Klv356"], 40*Microliter, 10 Second},
					{Sample, Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], 40*Microliter, 10 Second},
					{Sample, Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], 40*Microliter, 10 Second}
				}
			],
			$Failed,
			Messages :> {
				Error::ConflictingFlowInjectionTable,
				Error::InvalidOption
			}
		],
		Example[{Messages, "UnresolvableFlowCytometryDetector", "If the provided DetectionLabel did not match any of the detectors for this instrument, throw a warning:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				DetectionLabel->{Model[Molecule, "Test fluorophore with odd excitation and emission for ExperimentFlowCytometry tests"<> $SessionUUID]}
			],
			ObjectP[Object[Protocol,FlowCytometry]],
			Messages :> {
				Warning::UnresolvableFlowCytometryDetector
			}
		],
		Example[{Messages, "FlowCytometryInvalidPreparedPlateContainer", "If PreparedPlate is True, the samples are in an appropriate container:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				PreparedPlate->True
			],
			$Failed,
			Messages :> {
				Error::FlowCytometryInvalidPreparedPlateContainer,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FlowCytometryInvalidPreparedPlateContainer", "If PreparedPlate is True, the samples are in an appropriate container:"},
			ExperimentFlowCytometry[
				{Object[Sample, "sample 8 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
					Object[Sample, "sample 9 in plate for ExperimentFlowCytometry testing"<> $SessionUUID]},
				PreparedPlate->True
			],
			$Failed,
			Messages :> {
				Error::FlowCytometryInvalidPreparedPlateContainer,
				Error::InvalidOption
			}
		],
		Example[{Messages, "UnresolvableFlowCytometerInjectionTable", "If the automatics are not able to resolve in the provided InjectionTable, throw an error:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				NumberOfReplicates -> 2,
				InjectionTable -> {
					{Sample, Object[Sample, "sample 2 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], 40*Microliter, Automatic},
					{Sample, Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], 40*Microliter, 10 Second}
				}
			],
			$Failed,
			Messages :> {
				Error::UnresolvableFlowCytometerInjectionTable,
				Error::ConflictingFlowInjectionTable,
				Error::InvalidOption
			}
		],
		(*Example[{Messages, "FlowCytometryDetectorNotRecommended", "If the provided Detector is not recommended for the detection labels, throw a warning:"},
			ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				DetectionLabel -> {Null, Null, Model[Molecule, "Cy5"]},
				Detector -> {"488 FSC", "488 SSC", "488 525/35"}],
			ObjectP[Object[Protocol,FlowCytometry]],
			Messages :> {
				Warning::ConflictingDetecorAndDetectionLabel,
				Warning::FlowCytometryDetectorNotRecommended
			}
		],*)
		Example[{Options, Flush, "Specify if a sample line flush is performed after a selected number of samples have been processed:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Flush->True,
				Output->Options
			];
			Lookup[options, Flush],
			True
		],
		Example[{Options, FlushFrequency, "Specify the frequency at which the flushed after samples have been processed:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				FlushFrequency->6,
				Flush->True,
				Output->Options
			];
			Lookup[options, FlushFrequency],
			6
		],
		Example[{Options, FlushFrequency, "Resolve the frequency at which the flushed after samples have been processed:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				NumberOfReplicates->5,
				Flush->True,
				Output->Options
			];
			Lookup[options, FlushFrequency],
			5
		],
		Example[{Options, FlushSample, "Specify the liquid used to flush the instrument:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Flush->True,
				FlushSample->Model[Sample,"Milli-Q water"],
				Output->Options
			];
			Lookup[options, FlushSample],
			ObjectP[Model[Sample,"Milli-Q water"]]
		],
		Example[{Options, FlushSample, "Specify the liquid used to flush the instrument:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Flush->True,
				FlushSample->Model[Sample,"Milli-Q water"]
			];
			Download[prot, FlushSample],
			ObjectP[Model[Sample,"Milli-Q water"]]
		],
		Example[{Options, FlushSample, "Specify the speed of FlushSample used to flush the instrument:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				NumberOfReplicates->5,
				Flush->True,
				FlushSpeed->1Microliter/Second,
				Output->Options
			];
			Lookup[options, FlushSpeed],
			1Microliter/Second,
			EquivalenceFunction -> Equal
		],
		Example[{Options, FlushSpeed, "Specify the speed of FlushSample used to flush the instrument:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				NumberOfReplicates->5,
				Flush->True,
				FlushSpeed->1Microliter/Second,
				Output->Options
			];
			Lookup[options, FlushSpeed],
			1Microliter/Second,
			EquivalenceFunction -> Equal
		],
		Example[{Options, FlushSpeed, "Specify the speed of FlushSample used to flush the instrument:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				NumberOfReplicates->5,
				Flush->True,
				FlushSpeed->1Microliter/Second
			];
			Download[prot, FlushSpeed],
			1Microliter/Second,
			EquivalenceFunction -> Equal
		],
		Example[{Options, FlushSpeed, "Resolve the speed of FlushSample used to flush the instrument:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				NumberOfReplicates->5,
				Flush->True,
				Output->Options
			];
			Lookup[options, FlushSpeed],
			0.5Microliter/Second,
			EquivalenceFunction -> Equal
		],
		Example[{Options, NeedleWash, "Specify if sheath fluid will be used to wash the injection needle after every sample measurement:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				NeedleWash->False,
				Output->Options
			];
			Lookup[options, NeedleWash],
			False
		],
		Example[{Options, NeedleInsideWashTime, "Specify the amount of time the sheath fluid will be used to wash the inside of the injection needle after every sample measurement:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				NeedleInsideWashTime->0.5 Second,
				Output->Options
			];
			Lookup[options, NeedleInsideWashTime],
			0.5 Second,
			EquivalenceFunction -> Equal
		],
		Example[{Options, NeedleInsideWashTime, "Specify the amount of time the sheath fluid will be used to wash the inside of the injection needle after every sample measurement:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				NeedleInsideWashTime->0.5 Second
			];
			Download[prot, NeedleInsideWashTimes],
			{0.5 Second},
			EquivalenceFunction -> Equal
		],
		Example[{Options, NeedleInsideWashTime, "Resolve the amount of time the sheath fluid will be used to wash the inside of the injection needle after every sample measurement:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Output->Options
			];
			Lookup[options, NeedleInsideWashTime],
			1Second
		],
		Example[{Options, AgitationFrequency, "Specify the frequency at which the loader is shaked to resuspend samples between the injections:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				NumberOfReplicates->5,
				AgitationFrequency->2,
				Output->Options
			];
			Lookup[options, AgitationFrequency],
			2
		],
		Example[{Options, AgitationFrequency, "Resolve the frequency at which the loader is shaked to resuspend samples between the injections:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				NumberOfReplicates->5,
				Output->Options
			];
			Lookup[options, AgitationFrequency],
			3
		],
		Example[{Options, AgitationFrequency, "Resolve the frequency at which the loader is shaked to resuspend samples between the injections:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				NumberOfReplicates->5,
				Agitate->True,
				Output->Options
			];
			Lookup[options, AgitationFrequency],
			Null
		],
		Example[{Options, Detectors, "Specify the detectors which should be used to detect light scattered off the samples:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Detector -> {"488 FSC", "488 SSC", "488 525/35"},
				Output->Options
			];
			Lookup[options, Detector],
			{"488 FSC", "488 SSC", "488 525/35"}
		],
		Example[{Options, Detectors, "Specify the detectors which should be used to detect light scattered off the samples:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Detector -> {"488 FSC", "488 SSC", "488 525/35"}
			];
			Download[prot, Detectors],
			{"488 FSC", "488 SSC", "488 525/35"}
		],
		Example[{Options, DetectionLabels, "Specify the fluorescent tag, attached to the samples that will be analyzed:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Detector -> {"488 FSC", "488 SSC", "488 525/35"},
				DetectionLabel -> {Null, Null, Model[Molecule, "id:Vrbp1jK1LPom"]},
				Output->Options
			];
			Lookup[options, DetectionLabel],
			{Null, Null, Model[Molecule, "id:Vrbp1jK1LPom"]}
		],
		Example[{Options, Detector, "Resolve the detectors which should be used to detect light scattered off the samples from the DetectionLabel option:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				DetectionLabel -> {Model[Molecule, "id:Vrbp1jK1LPom"]},
				Output->Options
			];
			Lookup[options, Detector],
			{"488 FSC","488 SSC","488 525/35"}
		],
		Example[{Options, Detector, "Resolve the detectors which should be used to detect light scattered off the samples from the sample composition:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Output->Options
			];
			Lookup[options, Detector],
			{"488 FSC","488 SSC","488 525/35"}
		],
		Example[{Options, DetectionLabel, "Resolve the fluorescent tag, attached to the samples that will be analyzed from the sample composition:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Output->Options
			];
			Lookup[options, DetectionLabel],
			{Null, Null, Model[Molecule, "id:Vrbp1jK1LPom"]}
		],
		Example[{Options, ExcitationWavelength, "Specify the wavelength that should be used to excite fluorescence and scatter off the samples:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Detector -> {"488 FSC", "488 SSC", "488 525/35"},
				ExcitationWavelength -> 488Nanometer,
				Output->Options
			];
			Lookup[options, ExcitationWavelength],
			488Nanometer,
			EquivalenceFunction -> Equal
		],
		Example[{Options, ExcitationWavelength, "Specify the wavelengths which should be used to excite fluorescence and scatter off the samples:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Detector -> {"488 FSC", "488 SSC", "488 525/35"},
				ExcitationWavelength -> 488Nanometer
			];
			Download[prot, ExcitationWavelengths],
			{488Nanometer},
			EquivalenceFunction -> Equal
		],
		Example[{Options, ExcitationWavelength, "Resolve the wavelengths which should be used to excite fluorescence and scatter off the samples:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Detector -> {"488 FSC", "488 SSC", "488 525/35"},
				Output->Options
			];
			Lookup[options, ExcitationWavelength],
			488Nanometer,
			EquivalenceFunction -> Equal
		],
		Example[{Options, ExcitationPower, "Specify the laser powers which should be used to excite fluorescence and scatter off the samples.:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				ExcitationWavelength -> 488Nanometer,
				ExcitationPower->50Milli*Watt,
				Detector -> {"488 FSC", "488 SSC", "488 525/35"},
				Output->Options
			];
			Lookup[options, ExcitationPower],
			50Milli*Watt,
			EquivalenceFunction -> Equal
		],
		Example[{Options, ExcitationPower, "Specify the laser powers which should be used to excite fluorescence and scatter off the samples.:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				ExcitationWavelength -> 488Nanometer,
				ExcitationPower->50Milli*Watt,
				Detector -> {"488 FSC", "488 SSC", "488 525/35"}
			];
			Download[prot, ExcitationPowers],
			{50Milli*Watt},
			EquivalenceFunction -> Equal
		],
		Example[{Options, ExcitationPower, "Resolve the laser powers which should be used to excite fluorescence and scatter off the samples.:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				ExcitationWavelength -> 488Nanometer,
				Detector -> {"488 FSC", "488 SSC", "488 525/35"},
				Output->Options
			];
			Lookup[options, ExcitationPower],
			100Milli*Watt,
			EquivalenceFunction -> Equal
		],
		Example[{Options, Blank, "Specify a sample containing wash solution used an extra wash between samples:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Blank->Model[Sample,"Milli-Q water"],
				NumberOfReplicates->5,
				Output->Options
			];
			Lookup[options, Blank],
			ObjectP[Model[Sample,"Milli-Q water"]]
		],
		Example[{Options, Blank, "Specify a sample containing wash solution used an extra wash between samples:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				NumberOfReplicates->5,
				BlankFrequency->2,
				Blank->Model[Sample,"Milli-Q water"]
			];
			Download[prot, Blanks],
			Table[ObjectP[Model[Sample,"Milli-Q water"]],2]
		],
		Example[{Options, Blank, "Resolve a sample containing wash solution used an extra wash between samples:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				BlankInjectionVolume->1Milliliter,
				NumberOfReplicates->5,
				Output->Options
			];
			Lookup[options, Blank],
			ObjectP[Model[Sample,StockSolution,"Filtered PBS, Sterile"]]
		],
		Example[{Options, BlankInjectionVolume, "Specify the volume of each Blank to inject:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				BlankInjectionVolume->1Milliliter,
				NumberOfReplicates->5,
				Output->Options
			];
			Lookup[options, BlankInjectionVolume],
			1Milliliter,
			EquivalenceFunction -> Equal
		],
		Example[{Options, BlankInjectionVolume, "Specify the volume of each Blank to inject:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				NumberOfReplicates->6,
				BlankInjectionVolume->1Milliliter
			];
			Download[prot, BlankInjectionVolumes],
			{1Milliliter},
			EquivalenceFunction -> Equal
		],
		Example[{Options, BlankInjectionVolume, "Resolve the volume of each Blank to inject:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Blank->Model[Sample,"Milli-Q water"],
				NumberOfReplicates->5,
				Output->Options
			];
			Lookup[options, BlankInjectionVolume],
			40Microliter,
			EquivalenceFunction -> Equal
		],
		Example[{Options, BlankFrequency, "Specify the frequency at which Blank samples will be inserted in the measurement sequence.:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				BlankFrequency->3,
				NumberOfReplicates->5,
				Output->Options
			];
			Lookup[options, BlankFrequency],
			3
		],
		Example[{Options, BlankFrequency, "Resolve the frequency at which Blank samples will be inserted in the measurement sequence.:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Blank->Model[Sample,"Milli-Q water"],
				NumberOfReplicates->6,
				Output->Options
			];
			Lookup[options, BlankFrequency],
			5
		],
		Example[{Options, RecoupSample, "Specify if the excess sample in the injection line returns to the into the container that they were in prior to the measurement:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				RecoupSample->False,
				Output->Options
			];
			Lookup[options, RecoupSample],
			False
		],
		Example[{Options, RecoupSample, "Specify if the excess sample in the injection line returns to the into the container that they were in prior to the measurement:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				RecoupSample->False
			];
			Download[prot, RecoupSamples],
			{False}
		],
		Example[{Options, RecoupSample, "Resolve if the excess sample in the injection line returns to the into the container that they were in prior to the measurement:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				InjectionMode->Individual,
				Output->Options
			];
			Lookup[options, RecoupSample],
			True
		],
		Example[{Options, Agitate, "Specify if the sample should be shaked prior to the measurement:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Agitate->False,
				Output->Options
			];
			Lookup[options, Agitate],
			False
		],
		Example[{Options, Agitate, "Specify if the sample should be shaked prior to the measurement:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Agitate->False
			];
			Download[prot, Agitate],
			{False}
		],
		Example[{Options, Agitate, "Resolve if thesample should be shaked prior to the measurement:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				AgitationFrequency->First,
				Output->Options
			];
			Lookup[options, Agitate],
			True
		],
		Example[{Options, AgitationTime, "Specify the time sample should be shaked prior to the measurement:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				AgitationTime->5Second,
				Output->Options
			];
			Lookup[options, AgitationTime],
			5Second,
			EquivalenceFunction -> Equal
		],
		Example[{Options, AgitationTime, "Specify the time sample should be shaked prior to the measurement:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				AgitationTime->5Second
			];
			Download[prot, AgitationTimes],
			{5Second},
			EquivalenceFunction -> Equal
		],
		Example[{Options, AgitationTime, "Resolve the time sample should be shaked prior to the measurement:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Agitate->True,
				Output->Options
			];
			Lookup[options, AgitationTime],
			5Second,
			EquivalenceFunction -> Equal
		],
		Example[{Options, MaxVolume, "Specify the volume limit used for a stopping condition:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				MaxVolume->100Microliter,
				Output->Options
			];
			Lookup[options, MaxVolume],
			100Microliter,
			EquivalenceFunction -> Equal
		],
		Example[{Options, MaxVolume, "Specify the volume limit used for a stopping condition:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				MaxVolume->100Microliter
			];
			Download[prot, MaxVolume],
			{100Microliter},
			EquivalenceFunction -> Equal
		],
		Example[{Options, MaxVolume, "Resolve the volume limit used for a stopping condition:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Output->Options
			];
			Lookup[options, MaxVolume],
			40*Microliter,
			EquivalenceFunction -> Equal
		],
		Example[{Options, MaxVolume, "Resolve the volume limit used for a stopping condition when CellCount is True:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				CellCount->True,
				Output->Options
			];
			Lookup[options, MaxVolume],
			10*Microliter,
			EquivalenceFunction -> Equal
		],
		Example[{Options, AddReagent, "Specify if a reagent should be added to the sample before injection:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				AddReagent->True,
				Output->Options
			];
			Lookup[options, AddReagent],
			True
		],
		Example[{Options, AddReagent, "Resolve if a reagent should be added to the sample before injection:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				ReagentMix->True,
				Output->Options
			];
			Lookup[options, AddReagent],
			True
		],
		Example[{Options, Reagent, "Specify a reagent that should be added to the sample before injection:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Reagent->Model[Sample,StockSolution,"Filtered PBS, Sterile"],
				Output->Options
			];
			Lookup[options, Reagent],
			ObjectP[Model[Sample,StockSolution,"Filtered PBS, Sterile"]]
		],
		Example[{Options, Reagent, "Specify a reagent that should be added to the sample before injection:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Reagent->Model[Sample,StockSolution,"Filtered PBS, Sterile"]
			];
			Download[prot, Reagents],
			{ObjectP[Model[Sample,StockSolution,"Filtered PBS, Sterile"]]}
		],
		Example[{Options, Reagent, "Resolve a reagent that should be added to the sample before injection:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				AddReagent->True,
				Output->Options
			];
			Lookup[options, Reagent],
			ObjectP[Model[Sample,"Milli-Q water"]]
		],
		Example[{Options, ReagentVolume, "Specify a reagent volume that should be added to the sample before injection:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				ReagentVolume->1Milliliter,
				Output->Options
			];
			Lookup[options, ReagentVolume],
			1Milliliter,
			EquivalenceFunction -> Equal
		],
		Example[{Options, ReagentVolume, "Specify a reagent volume that should be added to the sample before injection:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				ReagentVolume->1Milliliter
			];
			Download[prot, ReagentVolumes],
			{1Milliliter},
			EquivalenceFunction -> Equal
		],
		Example[{Options, ReagentVolume, "Resolve a reagent volume that should be added to the sample before injection:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				AddReagent->True,
				Output->Options
			];
			Lookup[options, ReagentVolume],
			10Microliter,
			EquivalenceFunction -> Equal
		],
		Example[{Options, ReagentMix, "Specify if a reagent added to the sample before injection should be mixed:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				ReagentMix->True,
				Output->Options
			];
			Lookup[options, ReagentMix],
			True
		],
		Example[{Options, ReagentMix, "Specify if a reagent added to the sample before injection should be mixed:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				ReagentMix->True
			];
			Download[prot, ReagentMix],
			{True}
		],
		Example[{Options, ReagentMix, "Resolve if a reagent added to the sample before injection should be mixed:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				AddReagent->False,
				Output->Options
			];
			Lookup[options, ReagentMix],
			Null
		],
		Example[{Options, InjectionMode, "Specify the mode in which samples are loaded into the flow cell:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				InjectionMode->Continuous,
				Output->Options
			];
			Lookup[options, InjectionMode],
			Continuous
		],
		Example[{Options, InjectionMode, "Specify the mode in which samples are loaded into the flow cell:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				InjectionMode->Continuous
			];
			Download[prot, InjectionModes],
			{Continuous}
		],
		Example[{Options, Instrument, "Specify the instrument used:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Instrument->Object[Instrument,FlowCytometer, "test instrument for ExperimentFlowCytometry tests"<> $SessionUUID],
				Output->Options
			];
			Lookup[options, Instrument],
			ObjectP[Object[Instrument, FlowCytometer,"test instrument for ExperimentFlowCytometry tests"<> $SessionUUID]]
		],
		Example[{Options, Instrument, "Specify the instrument used:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Instrument->Object[Instrument,FlowCytometer, "test instrument for ExperimentFlowCytometry tests"<> $SessionUUID]
			];
			Download[prot, Instrument],
			ObjectP[Object[Instrument, FlowCytometer,"test instrument for ExperimentFlowCytometry tests"<> $SessionUUID]]
		],
		Example[{Additional, "Resolve the instrument used:"},
			prot = ExperimentFlowCytometry[
				Object[Sample, "sample 5 in plate for ExperimentFlowCytometry testing"<> $SessionUUID]
			];
			Download[Download[prot, BatchedUnitOperations], Instrument],
			{ObjectP[Model[Instrument,FlowCytometer]]}
		],
		Example[{Options, FlowCytometryMethod, "Specify the flow cytometry method object which describes the optics settings of the instrument:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				FlowCytometryMethod->Object[Method, FlowCytometry, "test method for ExperimentFlowCytometry tests"<> $SessionUUID],
				Output->Options
			];
			Lookup[options, FlowCytometryMethod],
			ObjectP[Object[Method, FlowCytometry, "test method for ExperimentFlowCytometry tests"<> $SessionUUID]]
		],
		Example[{Options, PreparedPlate, "Specify if the container containing the samples for the flow cytometry experiment has been previously prepared and will be loaded directly onto the instrument.:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 7 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
				PreparedPlate->True,
				Output->Options
			];
			Lookup[options, PreparedPlate],
			True
		],
		Example[{Options, PreparedPlate, "Specify if the container containing the samples for the flow cytometry experiment has been previously prepared and will be loaded directly onto the instrument.:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 8 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
				PreparedPlate->True
			];
			Download[prot, PreparedPlate],
			True
		],
		Example[{Options, PreparedPlate, "Specify if the container containing the samples and reagents for the flow cytometry experiment has been previously prepared and will be loaded directly onto the instrument.:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 9 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
				Reagent -> Object[Sample, "sample 10 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
				PreparedPlate -> True
			];
			Download[prot, Reagents],
			{ObjectP[Object[Sample]]}
		],
		Example[{Options, PreparedPlate, "Specify if the container containing the samples and blanks for the flow cytometry experiment has been previously prepared and will be loaded directly onto the instrument.:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 7 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
				Blank -> Object[Sample, "sample 11 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
				InjectionTable -> {
					{Blank, Object[Sample, "sample 11 in plate for ExperimentFlowCytometry testing"<> $SessionUUID], 40*Microliter, 10 Second},
					{Sample, Object[Sample, "sample 7 in plate for ExperimentFlowCytometry testing"<> $SessionUUID], 40*Microliter, 10 Second}
				},
				PreparedPlate -> True
			];
			Download[prot, Blanks],
			{ObjectP[Object[Sample]]..}
		],
		Example[{Options, PreparedPlate, "Specify if the container containing the samples and UnstainedSample for the flow cytometry experiment has been previously prepared and will be loaded directly onto the instrument.:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 10 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
				UnstainedSample -> Object[Sample, "sample 9 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
				PreparedPlate -> True
			];
			Download[prot, UnstainedSample],
			ObjectP[Object[Sample]]
		],
		Example[{Options, PreparedPlate, "Specify if the container containing the samples and AdjustmentSamples for the flow cytometry experiment has been previously prepared and will be loaded directly onto the instrument.:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 7 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
				AdjustmentSample -> Object[Sample, "sample 11 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
				PreparedPlate -> True
			];
			Download[prot, AdjustmentSamples],
			{ObjectP[Object[Sample]]..}
		],
		Example[{Options, SampleVolume, "Specify the amount of the input sample that is aliquoted from its original container:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				SampleVolume->100Microliter,
				Output->Options
			];
			Lookup[options, SampleVolume],
			100Microliter
		],
		Example[{Options, Temperature, "Specify the temperature of the autosampler where the samples sit prior to being injected into the flow cytometer:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Temperature->35Celsius,
				Output->Options
			];
			Lookup[options, Temperature],
			35Celsius
		],
		Example[{Options, Temperature, "Specify the temperature of the autosampler where the samples sit prior to being injected into the flow cytometer:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Temperature->35Celsius
			];
			Download[prot, Temperature],
			35Celsius
		],
		Example[{Options, FlowRate, "Specify the volume per time in which the sample is flowed through the flow cytometer.:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				FlowRate->3Microliter/Second,
				Output->Options
			];
			Lookup[options, FlowRate],
			3Microliter/Second
		],
		Example[{Options, FlowRate, "Specify the volume per time in which the sample is flowed through the flow cytometer.:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				FlowRate->3Microliter/Second
			];
			Download[prot, FlowRates],
			{3Microliter/Second}
		],
		Example[{Options, FlowRate, "Specify the number of trigger events per time in which the sample is flowed through the flow cytometer.:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				FlowRate->1000Event/Second,
				Output->Options
			];
			Lookup[options, FlowRate],
			1000Event/Second
		],
		Example[{Options, CellCount, "Specify if the number of cells per volume of the sample will be measured:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				CellCount->True,
				Output->Options
			];
			Lookup[options, CellCount],
			True
		],
		Example[{Options, CellCount, "Specify if the number of cells per volume of the sample will be measured:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				CellCount->True
			];
			Download[prot, CellCount],
			{True}
		],
		Example[{Options, NeutralDensityFilter, "Specify if a neutral density filter with an optical density of 2.0 should be used lower the intensity of scattered light that hits the detector:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Detector -> {"488 FSC", "488 SSC", "488 525/35"},
				NeutralDensityFilter->{True,False,False},
				Output->Options
			];
			Lookup[options, NeutralDensityFilter],
			{True,False,False}
		],
		Example[{Options, NeutralDensityFilter, "Specify if a neutral density filter with an optical density of 2.0 should be used lower the intensity of scattered light that hits the detector:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Detector -> {"488 FSC", "488 SSC", "488 525/35"},
				NeutralDensityFilter->{True,False,False}
			];
			Download[prot, NeutralDensityFilters],
			{True,False,False}
		],
		Example[{Options, NeutralDensityFilter, "Resolve if a neutral density filter with an optical density of 2.0 should be used lower the intensity of scattered light that hits the detector:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Detector -> {"488 FSC", "488 SSC", "488 525/35"},
				Output->Options
			];
			Lookup[options, NeutralDensityFilter],
			False
		],
		Example[{Options, Gain, "Specify the voltage the PhotoMultiplier Tube (PMT) should be set to to detect the scattered light off the sample:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Detector -> {"488 FSC", "488 SSC", "488 525/35"},
				Gain->{50*Volt,60*Volt,40*Volt},
				Output->Options
			];
			Lookup[options, Gain],
			{50*Volt,60*Volt,40*Volt}
		],
		Example[{Options, Gain, "Specify the voltage the PhotoMultiplier Tube (PMT) should be set to to detect the scattered light off the sample:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Detector -> {"488 FSC", "488 SSC", "488 525/35"},
				Gain->{50*Volt,60*Volt,40*Volt}
			];
			Download[prot, Gains],
			{50*Volt,60*Volt,40*Volt}
		],
		Example[{Options, Gain, "Resolve  voltage the PhotoMultiplier Tube (PMT) should be set to to detect the scattered light off the sample:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Detector -> {"488 FSC", "488 SSC", "488 525/35"},
				Output->Options
			];
			Lookup[options, Gain],
			QualityControl
		],
		Example[{Options, AdjustmentSample, "Specify the sample used for gain optimization:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Detector -> {"488 FSC", "488 SSC", "488 525/35"},
				AdjustmentSample -> {Model[Sample, "id:rea9jlRjVD1B"], Model[Sample, "id:rea9jlRjVD1B"], Model[Sample, "id:AEqRl9Klv356"]},
				Output->Options
			];
			Lookup[options, AdjustmentSample],
			{ObjectP[Model[Sample, "id:rea9jlRjVD1B"]], ObjectP[Model[Sample, "id:rea9jlRjVD1B"]], ObjectP[Model[Sample, "id:AEqRl9Klv356"]]}
		],
		Example[{Options, AdjustmentSample, "Specify the sample used for gain optimization:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Detector -> {"488 FSC", "488 SSC", "488 525/35"},
				AdjustmentSample -> {Model[Sample, "id:rea9jlRjVD1B"], Model[Sample, "id:rea9jlRjVD1B"], Model[Sample, "id:AEqRl9Klv356"]}
			];
			Download[prot, AdjustmentSamples],
			{ObjectP[Model[Sample, "id:rea9jlRjVD1B"]], ObjectP[Model[Sample, "id:rea9jlRjVD1B"]], ObjectP[Model[Sample, "id:AEqRl9Klv356"]]}
		],
		Example[{Options, AdjustmentSample, "Resolve the sample used for gain optimization:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Detector -> {"488 FSC", "488 SSC", "488 525/35"},
				Gain->Auto,
				Output->Options
			];
			Lookup[options, AdjustmentSample],
			ObjectP[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID]]
		],
		Example[{Options, AdjustmentSample, "Resolve the sample used for compensation:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Detector -> {"488 FSC", "488 SSC", "488 525/35"},
				IncludeCompensationSamples -> True,
				Output->Options
			];
			Lookup[options, AdjustmentSample],
			{Null, Null, ObjectP[Model[Sample, "id:AEqRl9Klv356"]]}
		],
		Example[{Options, TargetSaturationPercentage, "Specify the percent saturation the intensity of positive population is centered around:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				TargetSaturationPercentage->{65Percent,70Percent,75Percent},
				Output->Options
			];
			Lookup[options, TargetSaturationPercentage],
			{65Percent,70Percent,75Percent},
			EquivalenceFunction -> Equal
		],
		Example[{Options, TargetSaturationPercentage, "Specify the percent saturation the intensity of positive population is centered around:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				TargetSaturationPercentage->{65Percent,70Percent,75Percent}
			];
			Download[prot, TargetSaturationPercentages],
			{65Percent,70Percent,75Percent},
			EquivalenceFunction -> Equal
		],
		Example[{Options, TargetSaturationPercentage, "Resolve the percent saturation the intensity of positive population is centered around:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Gain->Auto,
				Output->Options
			];
			Lookup[options, TargetSaturationPercentage],
			75Percent
		],
		Example[{Options, TriggerDetector, "Specify the detector used to determine what signals count as an event:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				TriggerDetector->"405 FSC",
				Output->Options
			];
			Lookup[options, TriggerDetector],
			"405 FSC"
		],
		Example[{Options, TriggerDetector, "Specify the detector used to determine what signals count as an event:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				TriggerDetector->"405 FSC"
			];
			Download[prot, TriggerDetector],
			"405 FSC"
		],
		Example[{Options, TriggerThreshold, "Specify the level of the intensity detected by TriggerDetector must fall above to be classified as an event:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				TriggerThreshold->15Percent,
				Output->Options
			];
			Lookup[options, TriggerThreshold],
			15Percent,
			EquivalenceFunction -> Equal
		],
		Example[{Options, TriggerThreshold, "Specify the level of the intensity detected by TriggerDetector must fall above to be classified as an event:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				TriggerThreshold->15Percent
			];
			Download[prot, TriggerThreshold],
			15Percent,
			EquivalenceFunction -> Equal
		],
		Example[{Options, SecondaryTriggerDetector, "Specify the additional detector  used to determine what signals count as an event:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				SecondaryTriggerDetector->"488 SSC",
				Output->Options
			];
			Lookup[options, SecondaryTriggerDetector],
			"488 SSC"
		],
		Example[{Options, SecondaryTriggerDetector, "Specify the additional detector  used to determine what signals count as an event:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				SecondaryTriggerDetector->"488 SSC"
			];
			Download[prot, SecondaryTriggerDetector],
			"488 SSC"
		],
		Example[{Options, SecondaryTriggerThreshold, "Specify the level of the intensity detected by SecondaryTriggerDetector must fall above to be classified as an event:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				SecondaryTriggerThreshold->20Percent,
				Output->Options
			];
			Lookup[options, SecondaryTriggerThreshold],
			20Percent,
			EquivalenceFunction -> Equal
		],
		Example[{Options, SecondaryTriggerThreshold, "Specify the level of the intensity detected by SecondaryTriggerDetector must fall above to be classified as an event:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				SecondaryTriggerThreshold->20Percent
			];
			Download[prot, SecondaryTriggerThreshold],
			20Percent,
			EquivalenceFunction -> Equal
		],
		Example[{Options, MaxEvents, "Specify the maximum number of trigger events that will flow through the flow cytometer:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				MaxEvents->1000000,
				Output->Options
			];
			Lookup[options, MaxEvents],
			1000000
		],
		Example[{Options, MaxEvents, "Specify the maximum number of trigger events that will flow through the flow cytometer:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				MaxEvents->1000000
			];
			Download[prot, MaxEvents],
			{1000000}
		],
		Example[{Options, MaxGateEvents, "Specify the maximum events falling into a specific Gate that will flow through the instrument:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				MaxGateEvents->1000000,
				GateRegion->{"488 FSC",Span[20Percent,80Percent],"488 525/35",Span[20Percent,80Percent]},
				Output->Options
			];
			Lookup[options, MaxGateEvents],
			1000000
		],
		Example[{Options, MaxGateEvents, "Specify the maximum events falling into a specific Gate that will flow through the instrument:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				MaxGateEvents->1000000,
				GateRegion->{"488 FSC",Span[20Percent,80Percent],"488 525/35",Span[20Percent,80Percent]}
			];
			Download[prot, MaxGateEvents],
			{1000000}
		],
		Example[{Options, GateRegion, "Specify the conditions given to categorize the gate for the MaxGateEvents:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				MaxGateEvents->1000000,
				GateRegion->{"488 FSC",Span[10Percent,80Percent],"488 525/35",Span[20Percent,80Percent]},
				Output->Options
			];
			Lookup[options, GateRegion],
			{"488 FSC",10Percent;;80Percent,"488 525/35",20Percent;;80Percent}
		],
		Example[{Options, GateRegion, "Specify the conditions given to categorize the gate for the MaxGateEvents:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				MaxGateEvents->1000000,
				GateRegion->{"488 FSC",Span[10Percent,80Percent],"488 525/35",Span[20Percent,80Percent]}
			];
			Download[prot, GateRegions],
			{{"488 FSC",10Percent;;80Percent,"488 525/35",20Percent;;80Percent}}
		],
		Example[{Options, IncludeCompensationSamples, "Specify if a compensation matrix will be created to compensate for spillover of DetectionLabel into other detectors:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				IncludeCompensationSamples->False,
				Output->Options
			];
			Lookup[options, IncludeCompensationSamples],
			False
		],
		Example[{Options, IncludeCompensationSamples, "Specify if a compensation matrix will be created to compensate for spillover of DetectionLabel into other detectors:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				IncludeCompensationSamples->False
			];
			Download[prot, CompensationSamplesIncluded],
			False
		],
		Example[{Options, UnstainedSample, "Specify an unstained sample to be used as negative control when calculating the background of the compensation matrix for the experiment:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				UnstainedSample->Model[Sample, "id:rea9jlRjVD1B"],
				Output->Options
			];
			Lookup[options, UnstainedSample],
			ObjectP[Model[Sample, "id:rea9jlRjVD1B"]]
		],
		Example[{Options, UnstainedSample, "Specify an unstained sample to be used as negative control when calculating the background of the compensation matrix for the experiment:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				UnstainedSample->Model[Sample, "id:rea9jlRjVD1B"]
			];
			Download[prot, UnstainedSample],
			ObjectP[Model[Sample, "id:rea9jlRjVD1B"]]
		],
		Example[{Options, InjectionTable, "Specify the order of Sample, AdjustmentSample, UnstainedSample and Blank sample loading into the flow cytometer:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				AdjustmentSample -> Model[Sample, "id:AEqRl9Klv356"],
				NumberOfReplicates->2,
				InjectionTable->{
					{AdjustmentSample, Model[Sample, "id:AEqRl9Klv356"], 40*Microliter, 10 Second},
					{Sample, Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], 40*Microliter, 10 Second},
					{Blank, Model[Sample,StockSolution,"Filtered PBS, Sterile"], 40*Microliter, 10 Second},
					{Sample, Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], 40*Microliter, 10 Second}
				},
				Output->Options
			];
			Lookup[options, InjectionTable],
			{
				{AdjustmentSample, ObjectP[Model[Sample, "id:AEqRl9Klv356"]], 40*Microliter, 10 Second},
				{Sample, ObjectP[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID]], 40*Microliter, 10 Second},
				{Blank, ObjectP[Model[Sample,StockSolution,"Filtered PBS, Sterile"]], 40*Microliter, 10 Second},
				{Sample, ObjectP[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID]], 40*Microliter, 10 Second}
			}
		],
		Example[{Options, InjectionTable, "Specify the order of Sample, AdjustmentSample, UnstainedSample and Blank sample loading into the flow cytometer:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				NumberOfReplicates->2,
				InjectionTable->{
					{Sample, Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], 40*Microliter, 10 Second},
					{Blank, Model[Sample,StockSolution,"Filtered PBS, Sterile"], 40*Microliter, 10 Second},
					{Sample, Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], 40*Microliter, 10 Second}
				}
			];
			Length[Cases[
				Download[prot, InjectionTable],
				KeyValuePattern[Type->Sample]
			]],
			2,
			EquivalenceFunction -> Equal
		],
		Example[{Options, InjectionTable, "Resolve the order of Sample, AdjustmentSample, UnstainedSample and Blank sample loading into the flow cytometer:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Blank -> Model[Sample, "Milli-Q water"],
				BlankFrequency -> 3,
				NumberOfReplicates -> 5,
				Output->Options
			];
			Lookup[options, InjectionTable],
			{
				{Sample, ObjectP[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID]],40Microliter,5Second},
				{Sample, ObjectP[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID]],40Microliter,5Second},
				{Sample, ObjectP[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID]],40Microliter,5Second},
				{Blank, ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],40Microliter, 0Second},
				{Sample, ObjectP[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID]],40Microliter,5Second},
				{Sample, ObjectP[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID]],40Microliter,5Second}
			}
		],
		Example[{Options, NumberOfReplicates, "Specify the number of aliquots to generate from every sample as input to the flow cytometry experiment:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				NumberOfReplicates->5,
				Output->Options
			];
			Lookup[options, NumberOfReplicates],
			5
		],
		Example[{Options, NumberOfReplicates, "Specify the number of aliquots to generate from every sample as input to the flow cytometry experiment:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				NumberOfReplicates->5
			];
			Download[prot, NumberOfReplicates],
			5
		],
		Example[{Options, SamplesInStorageCondition, "Specify the number of aliquots to generate from every sample as input to the flow cytometry experiment:"},
			options=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				SamplesInStorageCondition->Freezer,
				Output->Options
			];
			Lookup[options, SamplesInStorageCondition],
			Freezer
		],
		Example[{Options, SamplesInStorageCondition, "Specify the number of aliquots to generate from every sample as input to the flow cytometry experiment:"},
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				SamplesInStorageCondition->Freezer
			];
			Download[prot, SamplesInStorage],
			{Freezer}
		],

		(* --- Additional option tests --- *)

		(* --- Sample prep option tests --- *)

		Example[
			{Options,Template,"Specify a template protocol whose methodology should be reproduced in running this experiment:"},
			protocol=ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], Template -> Null];
			Download[protocol,Template],
			Null
		],
		Example[
			{Options,Name,"Specify a name which should be used to refer to the output object in lieu of an automatically generated ID number:"},
			protocol=ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], Name->"My particular ExperimentFlowCytometry protocol" <> $SessionUUID];
			Download[protocol,Name],
			"My particular ExperimentFlowCytometry protocol" <> $SessionUUID
		],
		Example[{Options, PreparatoryUnitOperations, "Use the PreparatoryUnitOperations option to prepare samples from models before the experiment is run:"},
			protocol = ExperimentFlowCytometry[
				{"salty sample 1", "salty sample 2"},
				PreparatoryUnitOperations -> {
					LabelSample[Label -> "salty sample 1", Sample -> Model[Sample, StockSolution, "NaCl Solution in Water"], Container -> Model[Container, Vessel, "2mL Tube"], Amount->1 Milliliter],
					LabelSample[Label -> "salty sample 2", Sample -> Model[Sample, StockSolution, "NaCl Solution in Water"], Container -> Model[Container, Vessel, "2mL Tube"], Amount->1 Milliliter]
				}
			];
			Download[protocol, PreparatoryUnitOperations],
			{SamplePreparationP..}
		],
		Example[{Options, Incubate, "Set the Incubate option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True
		],
		Example[{Options, IncubationTemperature, "Set the IncubationTemperature option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], IncubationTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal
		],
		Example[{Options, IncubationTime, "Set the IncubationTime option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], IncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal
		],
		Example[{Options, MaxIncubationTime, "Set the MaxIncubationTime option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], MaxIncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal
		],
		Example[{Options, IncubationInstrument, "Set the IncubationInstrument option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], IncubationInstrument -> Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]]
		],
		Example[{Options, AnnealingTime, "Set the AnnealingTime option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], AnnealingTime -> 40*Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40*Minute,
			EquivalenceFunction -> Equal
		],
		Example[{Options, IncubateAliquot, "Set the IncubateAliquot option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], IncubateAliquot -> 400 Microliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			400 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[{Options, IncubateAliquotContainer, "Set the IncubateAliquotContainer option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}
		],
		Example[{Options, IncubateAliquotDestinationWell, "Set the IncubateAliquotDestinationWell option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], IncubateAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], IncubateAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, IncubateAliquotDestinationWell],
			"A2"
		],
		Example[{Options, Mix, "Set the Mix option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True
		],
		Example[{Options, MixType, "Set the MixType option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], MixType -> Vortex, Output -> Options];
			Lookup[options, MixType],
			Vortex
		],
		Example[{Options, MixUntilDissolved, "Set the MixUntilDissolved option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True
		],

		(* centrifuge options *)
		Example[{Options, Centrifuge, "Set the Centrifuge option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], Centrifuge -> True, CentrifugeInstrument -> Model[Instrument, Centrifuge, "Avanti J-15R"], Output -> Options];
			Lookup[options, Centrifuge],
			True
		],
		Example[{Options, CentrifugeInstrument, "Set the CentrifugeInstrument option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Avanti J-15R"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R"]]
		],
		Example[{Options, CentrifugeIntensity, "Set the CentrifugeIntensity option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal
		],
		Example[{Options, CentrifugeTime, "Set the CentrifugeTime option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], CentrifugeTime -> 40*Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			40*Minute,
			EquivalenceFunction -> Equal
		],
		Example[{Options, CentrifugeTemperature, "Set the CentrifugeTemperature option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], CentrifugeTemperature -> 10*Celsius, AliquotAmount -> 1*Milliliter, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal
		],
		Example[{Options, CentrifugeAliquot, "Set the CentrifugeAliquot option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], CentrifugeAliquot -> 400 Microliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			400 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[{Options, CentrifugeAliquotContainer, "Set the CentrifugeAliquotContainer option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}
		],
		Example[{Options, CentrifugeAliquotDestinationWell, "Set the CentrifugeAliquotDestinationWell option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], CentrifugeAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, CentrifugeAliquotDestinationWell],
			"A2"
		],
		(* filter options *)
		Example[{Options, Filtration, "Set the Filtration option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True
		],
		Example[{Options, FiltrationType, "Set the FiltrationType option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe
		],
		Example[{Options, FilterInstrument, "Set the FilterInstrument option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]]
		],
		Example[{Options, Filter, "Set the Filter option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], Filter -> Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]]
		],
		Example[{Options, FilterMaterial, "Set the FilterMaterial option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], FilterMaterial -> PES, AliquotAmount -> 400 Microliter, Output -> Options];
			Lookup[options, FilterMaterial],
			PES
		],
		Example[{Options, PrefilterMaterial, "Set the PrefilterMaterial option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 2 in 50mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], PrefilterMaterial -> GxF, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF
		],
		Example[{Options, PrefilterPoreSize, "Set the PrefilterPoreSize option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 2 in 50mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],  PrefilterPoreSize -> 1.*Micrometer, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer
		],
		Example[{Options, FilterPoreSize, "Set the FilterPoreSize option:"},
			options = ExperimentFlowCytometry[{Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentFlowCytometry testing"<> $SessionUUID]}, FilterPoreSize -> 0.22*Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer
		],
		Example[{Options, FilterSyringe, "Set the FilterSyringe option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]]
		],
		Example[{Options, FilterHousing, "FilterHousing option resolves to Null because it can't be used reasonably for volumes we would use in this experiment:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], Output -> Options];
			Lookup[options, FilterHousing],
			Null
		],
		Example[{Options, FilterIntensity, "Set the FilterIntensity option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal
		],
		Example[{Options, FilterTime, "Set the FilterTime option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20*Minute, Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal
		],
		Example[{Options, FilterTemperature, "Set the FilterTemperature option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], FiltrationType -> Centrifuge, FilterTemperature -> 10*Celsius, AssayVolume -> 200*Microliter, Output -> Options];
			Lookup[options, FilterTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal
		],
		Example[{Options, FilterSterile, "Set the FilterSterile option:"},
			options = ExperimentFlowCytometry[{Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentFlowCytometry testing"<> $SessionUUID]}, FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True
		],
		Example[{Options, FilterAliquot, "Set the FilterAliquot option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], FilterAliquot -> 400 Microliter, Output -> Options];
			Lookup[options, FilterAliquot],
			400 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[{Options, FilterAliquotContainer, "Set the FilterAliquotContainer option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}
		],
		Example[{Options, FilterAliquotDestinationWell, "Set the FilterAliquotDestinationWell option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], FilterAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], FilterAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, FilterAliquotDestinationWell],
			"A2"
		],
		Example[{Options, FilterContainerOut, "Set the FilterContainerOut option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]}
		],
		(* aliquot options *)
		Example[{Options, Aliquot, "Set the Aliquot option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], Aliquot -> True, Output -> Options];
			Lookup[options, Aliquot],
			True
		],
		Example[{Options, AliquotAmount, "Set the AliquotAmount option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], AliquotAmount -> 400 Microliter, Output -> Options];
			Lookup[options, AliquotAmount],
			400 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[{Options, AssayVolume, "Set the AssayVolume option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], AssayVolume -> 400 Microliter, Output -> Options];
			Lookup[options, AssayVolume],
			400 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[{Options, TargetConcentration, "Set the TargetConcentration option:"},
			options = ExperimentFlowCytometry[Object[Sample,"sample 4 in 2mL tube for ExperimentFlowCytometry testing with concentration"<> $SessionUUID], TargetConcentration -> 1*Millimolar, AssayVolume -> 400 Microliter, Output -> Options];
			Lookup[options, TargetConcentration],
			1*Millimolar,
			EquivalenceFunction -> Equal
		],
		Example[{Options, TargetConcentrationAnalyte, "Set the TargetConcentrationAnalyte option:"},
			options = ExperimentFlowCytometry[Object[Sample,"sample 4 in 2mL tube for ExperimentFlowCytometry testing with concentration"<> $SessionUUID],
				TargetConcentration -> 500 Micromolar,
				TargetConcentrationAnalyte -> Model[Molecule, "Acetone"],
				Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, "Acetone"]]
		],
		Example[{Options, ConcentratedBuffer, "Set the ConcentratedBuffer option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 200*Microliter, AssayVolume -> 400 Microliter, Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]]
		],
		Example[{Options, BufferDilutionFactor, "Set the BufferDilutionFactor option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 200*Microliter, AssayVolume -> 400 Microliter, Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal
		],
		Example[{Options, BufferDiluent, "Set the BufferDiluent option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 50*Microliter, AssayVolume -> 400*Microliter, Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]]
		],
		Example[{Options, AssayBuffer, "Set the AssayBuffer option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 200*Microliter, AssayVolume -> 400 Microliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]]
		],
		Example[{Options, AliquotSampleStorageCondition, "Set the AliquotSampleStorageCondition option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator
		],
		Example[{Options, ConsolidateAliquots, "Set the ConsolidateAliquots option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True
		],
		Example[{Options, AliquotPreparation, "Set the AliquotPreparation option:"},
			options = ExperimentFlowCytometry[
				{Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentFlowCytometry testing"<> $SessionUUID]},
				Aliquot -> True,
				AliquotPreparation -> Manual,
				Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual
		],
		Example[{Options, AliquotContainer, "Set the AliquotContainer option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], AliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, AliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]}
		],
		Example[{Options, DestinationWell, "Set the DestinationWell option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], AliquotContainer -> Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"], DestinationWell -> "A2", Output -> Options];
			Lookup[options, DestinationWell],
			"A2"
		],
		Example[{Options, ImageSample, "Set the ImageSample option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True
		],
		Example[{Options, MeasureWeight, "Set the MeasureWeight option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], MeasureWeight -> True, Output -> Options];
			Lookup[options, MeasureWeight],
			True
		],
		Example[{Options, MeasureVolume, "Set the MeasureVolume option:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], MeasureVolume -> True, Output -> Options];
			Lookup[options, MeasureVolume],
			True
		],
		Example[{Options, SamplesInStorageCondition, "Use the SamplesInStorageCondition option to set the StorageCondition to which the SamplesIn will be set at the end of the protocol:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], SamplesInStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, SamplesInStorageCondition],
			Refrigerator
		],
		Example[{Options, SamplesOutStorageCondition, "Use the SamplesOutStorageCondition option to set the StorageCondition to which the SamplesOut will be set at the end of the protocol:"},
			options = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], SamplesOutStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, SamplesOutStorageCondition],
			Refrigerator
		],
		Example[{Options, SamplesOutStorageCondition, "Use the SamplesOutStorageCondition option to set the StorageCondition to which the SamplesOut will be set at the end of the protocol:"},
			prot = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], SamplesOutStorageCondition -> Refrigerator];
			Download[prot, SamplesOutStorage],
			{Refrigerator}
		],
		Example[{Options, SamplesInStorageCondition, "Use the SamplesOutStorageCondition option to set the StorageCondition to which the SamplesOut will be set at the end of the protocol:"},
			prot = ExperimentFlowCytometry[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID], SamplesInStorageCondition -> Refrigerator];
			Download[prot, SamplesInStorage],
			{Refrigerator}
		],
		Example[{Options, SamplesInStorageCondition, "If multiple specified samples are in the same container but have different SamplesInStorageCondition values set, throw an error:"},
			ExperimentFlowCytometry[
				{Object[Sample, "sample 5 in plate for ExperimentFlowCytometry testing"<> $SessionUUID], Object[Sample, "sample 6 in plate for ExperimentFlowCytometry testing"<> $SessionUUID]},
				SamplesInStorageCondition -> {Refrigerator, Freezer}
			],
			$Failed,
			Messages :> {Error::SharedContainerStorageCondition, Error::InvalidOption}
		],
		Test["Flow simulation with some labels:",
			ExperimentFlowCytometry[
				Object[Sample, "sample 5 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
				SampleLabel -> "best sample ever",
				SampleContainerLabel -> "best container ever",
				Output -> {Simulation, Options}
			],
			{
				SimulationP,
				_List
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Test["Populate the BatchedUnitOperations field:",
			prot=ExperimentFlowCytometry[
				Object[Sample, "sample 5 in plate for ExperimentFlowCytometry testing"<> $SessionUUID]
			];
			Download[prot,BatchedUnitOperations],
			{
				ObjectP[Object[UnitOperation, FlowCytometry]]
			}
		],
		(* -- SampleLabel -- *)
		Example[{Options, SampleLabel, "Label of the samples that are being analyzed:"},
			options = ExperimentFlowCytometry[
				Object[Sample, "sample 5 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
				SampleLabel -> "fancy sample",
				Output -> Options
			];
			Lookup[options, SampleLabel],
			"fancy sample",
			Variables :> {options}
		],

		(* -- SampleContainerLabel -- *)
		Example[{Options, SampleContainerLabel, "Label of the sample container that are being analyzed:"},
			options = ExperimentFlowCytometry[
				Object[Sample, "sample 5 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
				SampleContainerLabel -> "This is where we store the fancy sample",
				Output -> Options
			];
			Lookup[options, SampleContainerLabel],
			"This is where we store the fancy sample",
			Variables :> {options}
		]
	},
	Stubs :> {
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID = Object[User, "ExperimentFLowCytometry all site user" <> $SessionUUID]
	},
	SetUp :> (
		$CreatedObjects = {};
		ClearDownload[];
		ClearMemoization[];
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjs, existingObjects},
			allObjs = Flatten[{
				Object[Container, Bench, "Test bench for ExperimentFlowCytometry tests"<> $SessionUUID],

				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Object[Sample, "sample 2 in 50mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Object[Sample, "sample 3 in 2L bottle for ExperimentFlowCytometry testing"<> $SessionUUID],
				Object[Sample, "sample 4 in 2mL tube for ExperimentFlowCytometry testing with concentration"<> $SessionUUID],

				Object[Sample, "sample with no model in 50mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Object[Sample, "discarded sample in 50mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
				Object[Sample, "sample 5 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
				Object[Sample, "sample 6 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
				Object[Sample, "sample 7 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
				Object[Sample, "sample 8 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
				Object[Sample, "sample 9 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
				Object[Sample, "sample 10 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
				Object[Sample, "sample 11 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],

				Object[Container, Vessel, "2mL tube 1 for ExperimentFlowCytometry tests"<> $SessionUUID],
				Object[Container, Vessel, "50mL tube 1 for ExperimentFlowCytometry tests"<> $SessionUUID],
				Object[Container, Vessel, "2L bottle for ExperimentFlowCytometry tests"<> $SessionUUID],
				Object[Container, Vessel, "tube for ExperimentFlowCytometry PreparedPlate tests"<> $SessionUUID],
				Object[Container, Vessel, "tube 2 for ExperimentFlowCytometry PreparedPlate tests"<> $SessionUUID],

				Object[Container, Vessel, "discarded 50mL tube for ExperimentFlowCytometry tests"<> $SessionUUID],
				Object[Container, Vessel, "no model 50mL tube for ExperimentFlowCytometry tests"<> $SessionUUID],
				Object[Container, Vessel,"2mL vessel for ExperimentFlowCytometry tests with conc"<> $SessionUUID],
				Object[Container,Plate, "plate for ExperimentFlowCytometry tests"<> $SessionUUID],
				Object[Container,Plate, "plate for ExperimentFlowCytometry PreparedPlate tests"<> $SessionUUID],
				Object[Container,Plate, "plate 2 for ExperimentFlowCytometry PreparedPlate tests"<> $SessionUUID],

				Object[Protocol,FlowCytometry, "test protocol for ExperimentFlowCytometry tests"<> $SessionUUID],
				Object[Method, FlowCytometry, "test method for ExperimentFlowCytometry tests"<> $SessionUUID],
				Object[Instrument,FlowCytometer, "test instrument for ExperimentFlowCytometry tests"<> $SessionUUID],

				Model[Molecule, "Test fluorophore with odd excitation and emission for ExperimentFlowCytometry tests"<> $SessionUUID],

				Object[User, "ExperimentFLowCytometry all site user" <> $SessionUUID],
				Object[Team, Financing, "all site financing team" <> $SessionUUID],
				Object[LaboratoryNotebook, "ExperimentFLowCytometry all site user notebook" <> $SessionUUID]
			}];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjs, DatabaseMemberQ[allObjs]];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];


		Block[{$DeveloperUpload = True},
			Module[
				{
					testBench, vessel1, vessel2, vessel3, vesseldiscarded, vesselnomodel, vesselconc, plate1, vesselPP, vesselPP2, platePP, platePP2,
					sample1, sample2, sample3, sample4, sample5, sample6, sample7, sample8, samplediscarded, samplenomodel, sampleconc, sampleplate1,
					sampleplate2, allSiteUser, allSiteFinancingTeam, allSiteNotebook
				},

				(* create a user that has access to all site *)
				allSiteUser = Upload[<|
					Type -> Object[User],
					FirstName -> "AllSite",
					LastName -> "User",
					Status -> Active,
					Name -> "ExperimentFLowCytometry all site user" <> $SessionUUID,
					Email -> "ExperimentFLowCytometryAllSiteUser" <> $SessionUUID <> "@emeraldcloudlab.com"
				|>];

				allSiteNotebook = Upload[<|
					Replace[Administrators] -> {Link[Object[User, "ExperimentFLowCytometry all site user" <> $SessionUUID]]},
					Type -> Object[LaboratoryNotebook],
					Name -> "ExperimentFLowCytometry all site user notebook" <> $SessionUUID
				|>];

				allSiteFinancingTeam = Upload[<|
					Replace[Administrators] -> {Link[Object[User, "ExperimentFLowCytometry all site user" <> $SessionUUID]]},
					DefaultMailingAddress -> Link[Object[Container, Site, "ECL-2"]],
					Replace[ExperimentSites] -> {
						Link[Object[Container, Site, "ECL-1"], FinancingTeams],
						Link[Object[Container, Site, "ECL-2"], FinancingTeams],
						Link[Object[Container, Site, "ECL-CMU"], FinancingTeams]
					},
					MaxComputationThreads -> 5,
					MaxThreads -> 0,
					Replace[Members] -> {Link[Object[User, "ExperimentFLowCytometry all site user" <> $SessionUUID], FinancingTeams]},
					Replace[NotebooksFinanced] -> {Link[Object[LaboratoryNotebook, "ExperimentFLowCytometry all site user notebook" <> $SessionUUID], Financers]},
					Type -> Object[Team, Financing],
					Name -> "all site financing team" <> $SessionUUID|>];

				(*perform the fist upload*)
				{testBench}=Upload[{
					<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Test bench for ExperimentFlowCytometry tests"<> $SessionUUID|>
				}];

				{
					vessel1,
					vessel2,
					vessel3,
					vesseldiscarded,
					vesselnomodel,
					vesselconc,
					plate1,
					vesselPP,
					platePP,
					platePP2,
					vesselPP2
				}=UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "2L Glass Bottle"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Vessel, "5mL Tube"],
						Model[Container, Plate, "96-well Round Bottom Plate"],
						Model[Container, Plate, "96-well Round Bottom Plate"],
						Model[Container, Vessel, "5mL Tube"]
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
						{"Work Surface",testBench}
					},
					FastTrack -> True,
					Name -> {
						"2mL tube 1 for ExperimentFlowCytometry tests"<> $SessionUUID,
						"50mL tube 1 for ExperimentFlowCytometry tests"<> $SessionUUID,
						"2L bottle for ExperimentFlowCytometry tests"<> $SessionUUID,
						"discarded 50mL tube for ExperimentFlowCytometry tests"<> $SessionUUID,
						"no model 50mL tube for ExperimentFlowCytometry tests"<> $SessionUUID,
						"2mL vessel for ExperimentFlowCytometry tests with conc"<> $SessionUUID,
						"plate for ExperimentFlowCytometry tests"<> $SessionUUID,
						"tube for ExperimentFlowCytometry PreparedPlate tests"<> $SessionUUID,
						"plate for ExperimentFlowCytometry PreparedPlate tests"<> $SessionUUID,
						"plate 2 for ExperimentFlowCytometry PreparedPlate tests"<> $SessionUUID,
						"tube 2 for ExperimentFlowCytometry PreparedPlate tests"<> $SessionUUID
					}
				];

				{
					sample1,
					sample2,
					sample3,
					samplediscarded,
					samplenomodel,
					sampleconc,
					sampleplate1,
					sampleplate2,
					sample4,
					sample5,
					sample6,
					sample7,
					sample8
				} = UploadSample[
					{
						Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
						Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
						Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
						Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
						Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
						Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
						Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
						Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
						Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
						Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
						Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
						Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
						Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"]
					},
					{
						{"A1", vessel1},
						{"A1", vessel2},
						{"A1", vessel3},
						{"A1", vesseldiscarded},
						{"A1", vesselnomodel},
						{"A1", vesselconc},
						{"A1", plate1},
						{"A2", plate1},
						{"A1", vesselPP},
						{"A1", platePP},
						{"A1", platePP2},
						{"A2", platePP2},
						{"A1", vesselPP2}
					},
					Name -> {
						"sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID,
						"sample 2 in 50mL tube for ExperimentFlowCytometry testing"<> $SessionUUID,
						"sample 3 in 2L bottle for ExperimentFlowCytometry testing"<> $SessionUUID,
						"discarded sample in 50mL tube for ExperimentFlowCytometry testing"<> $SessionUUID,
						"sample with no model in 50mL tube for ExperimentFlowCytometry testing"<> $SessionUUID,
						"sample 4 in 2mL tube for ExperimentFlowCytometry testing with concentration"<> $SessionUUID,
						"sample 5 in plate for ExperimentFlowCytometry testing"<> $SessionUUID,
						"sample 6 in plate for ExperimentFlowCytometry testing"<> $SessionUUID,
						"sample 7 in plate for ExperimentFlowCytometry testing"<> $SessionUUID,
						"sample 8 in plate for ExperimentFlowCytometry testing"<> $SessionUUID,
						"sample 9 in plate for ExperimentFlowCytometry testing"<> $SessionUUID,
						"sample 10 in plate for ExperimentFlowCytometry testing"<> $SessionUUID,
						"sample 11 in plate for ExperimentFlowCytometry testing"<> $SessionUUID
					},
					InitialAmount -> {
						1500*Microliter,
						35*Milliliter,
						1*Liter,
						35*Milliliter,
						35*Milliliter,
						2Milliliter,
						1*Milliliter,
						1*Milliliter,
						200Microliter,
						200Microliter,
						200Microliter,
						200Microliter,
						200Microliter
					}
				];

				Upload[Flatten[{
					<|
						Object -> Object[Sample, "sample with no model in 50mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
						Model -> Null
					|>,
					<|
						Object -> Object[Sample, "sample 4 in 2mL tube for ExperimentFlowCytometry testing with concentration"<> $SessionUUID],
						Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]]}, {5 Millimolar, Link[Model[Molecule, "Acetone"]]}}
					|>
				}]];
				UploadSampleStatus[samplediscarded, Discarded, FastTrack -> True];

				Upload[<|Type->Object[Protocol,FlowCytometry],Name->"test protocol for ExperimentFlowCytometry tests"<> $SessionUUID|>];


				Upload[<|Type-> Object[Method,FlowCytometry],
					Replace[Detector]->{"488 FSC", "488 SSC", "488 525/35"},
					Replace[DetectionLabel]->{Null, Null, Link[Model[Molecule, "id:Vrbp1jK1LPom"]]},
					Replace[ExcitationWavelength]->{488*Nanometer},
					Replace[ExcitationPower]->{100*Milli*Watt},
					Replace[Gain]->{50*Milli*Volt,50*Milli*Volt,50*Milli*Volt},
					Replace[NeutralDensityFilter]->{False,False,False},
					Name->"test method for ExperimentFlowCytometry tests"<> $SessionUUID
				|>];

				Upload[<|
					Type-> Object[Instrument,FlowCytometer],
					Model -> Link[Model[Instrument, FlowCytometer, "ZE5 Cell Analyzer"], Objects],
					Name->"test instrument for ExperimentFlowCytometry tests"<> $SessionUUID,
					Site -> Link[$Site]
				|>];

				Upload[<|
					Type-> Model[Molecule],
					Fluorescent->True,
					Replace[FluorescenceExcitationMaximums]->{65*Nanometer},
					Replace[FluorescenceEmissionMaximums]->{80*Nanometer},
					Name->"Test fluorophore with odd excitation and emission for ExperimentFlowCytometry tests"<> $SessionUUID
				|>];
			];
		];

	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objects, existingObjects},
			objects = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for ExperimentFlowCytometry tests"<> $SessionUUID],

					Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
					Object[Sample, "sample 2 in 50mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
					Object[Sample, "sample 3 in 2L bottle for ExperimentFlowCytometry testing"<> $SessionUUID],
					Object[Sample, "sample 4 in 2mL tube for ExperimentFlowCytometry testing with concentration"<> $SessionUUID],

					Object[Sample, "sample with no model in 50mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
					Object[Sample, "discarded sample in 50mL tube for ExperimentFlowCytometry testing"<> $SessionUUID],
					Object[Sample, "sample 5 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
					Object[Sample, "sample 6 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
					Object[Sample, "sample 7 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
					Object[Sample, "sample 8 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
					Object[Sample, "sample 9 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
					Object[Sample, "sample 10 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],
					Object[Sample, "sample 11 in plate for ExperimentFlowCytometry testing"<> $SessionUUID],

					Object[Container, Vessel, "2mL tube 1 for ExperimentFlowCytometry tests"<> $SessionUUID],
					Object[Container, Vessel, "50mL tube 1 for ExperimentFlowCytometry tests"<> $SessionUUID],
					Object[Container, Vessel, "2L bottle for ExperimentFlowCytometry tests"<> $SessionUUID],
					Object[Container, Vessel, "tube for ExperimentFlowCytometry PreparedPlate tests"<> $SessionUUID],
					Object[Container, Vessel, "tube 2 for ExperimentFlowCytometry PreparedPlate tests"<> $SessionUUID],

					Object[Container, Vessel, "discarded 50mL tube for ExperimentFlowCytometry tests"<> $SessionUUID],
					Object[Container, Vessel, "no model 50mL tube for ExperimentFlowCytometry tests"<> $SessionUUID],
					Object[Container, Vessel,"2mL vessel for ExperimentFlowCytometry tests with conc"<> $SessionUUID],
					Object[Container,Plate, "plate for ExperimentFlowCytometry tests"<> $SessionUUID],
					Object[Container,Plate, "plate for ExperimentFlowCytometry PreparedPlate tests"<> $SessionUUID],
					Object[Container,Plate, "plate 2 for ExperimentFlowCytometry PreparedPlate tests"<> $SessionUUID],

					Object[Protocol,FlowCytometry, "test protocol for ExperimentFlowCytometry tests"<> $SessionUUID],
					Object[Method, FlowCytometry, "test method for ExperimentFlowCytometry tests"<> $SessionUUID],
					Object[Instrument,FlowCytometer, "test instrument for ExperimentFlowCytometry tests"<> $SessionUUID],

					Model[Molecule, "Test fluorophore with odd excitation and emission for ExperimentFlowCytometry tests"<> $SessionUUID],

					Object[User, "ExperimentFLowCytometry all site user" <> $SessionUUID],
					Object[Team, Financing, "all site financing team" <> $SessionUUID],
					Object[LaboratoryNotebook, "ExperimentFLowCytometry all site user notebook" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False];
		];
	)
];

(* ::Subsection:: *)
(*ExperimentFlowCytometryOptions*)

DefineTests[
	ExperimentFlowCytometryOptions,
	{
		Example[{Basic, "Return a list of options in table form for one sample:"},
			ExperimentFlowCytometryOptions[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometryOptions testing"<> $SessionUUID]],
			Graphics_
		],
		Example[{Basic, "Return a list of options in table form for multiple samples together:"},
			ExperimentFlowCytometryOptions[{Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometryOptions testing"<> $SessionUUID],
				Object[Sample, "sample 2 in 50mL tube for ExperimentFlowCytometryOptions testing"<> $SessionUUID]}],
			Graphics_
		],
		Example[{Options, OutputFormat, "If OutputFormat -> List, return a list of rules:"},
			ExperimentFlowCytometryOptions[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometryOptions testing"<> $SessionUUID], OutputFormat -> List],
			{__Rule}
		]
	},
	Stubs :> {
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SetUp :> (
		$CreatedObjects = {};
		ClearDownload[];
		ClearMemoization[];
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjs, existingObjects},
			allObjs = Flatten[{
				Object[Container, Bench, "Test bench for ExperimentFlowCytometryOptions tests"<> $SessionUUID],

				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometryOptions testing"<> $SessionUUID],
				Object[Sample, "sample 2 in 50mL tube for ExperimentFlowCytometryOptions testing"<> $SessionUUID],
				Object[Sample, "sample 3 in 2L bottle for ExperimentFlowCytometryOptions testing"<> $SessionUUID],
				Object[Sample, "sample 4 in 2mL tube for ExperimentFlowCytometryOptions testing with concentration"<> $SessionUUID],

				Object[Sample, "sample with no model in 50mL tube for ExperimentFlowCytometryOptions testing"<> $SessionUUID],
				Object[Sample, "discarded sample in 50mL tube for ExperimentFlowCytometryOptions testing"<> $SessionUUID],
				Object[Sample, "sample 5 in plate for ExperimentFlowCytometryOptions testing"<> $SessionUUID],
				Object[Sample, "sample 6 in plate for ExperimentFlowCytometryOptions testing"<> $SessionUUID],

				Object[Container, Vessel, "2mL tube 1 for ExperimentFlowCytometryOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "50mL tube 1 for ExperimentFlowCytometryOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "2L bottle for ExperimentFlowCytometryOptions tests"<> $SessionUUID],

				Object[Container, Vessel, "discarded 50mL tube for ExperimentFlowCytometryOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "no model 50mL tube for ExperimentFlowCytometryOptions tests"<> $SessionUUID],
				Object[Container, Vessel,"2mL vessel for ExperimentFlowCytometryOptions tests with conc"<> $SessionUUID],
				Object[Container,Plate, "plate for ExperimentFlowCytometryOptions tests"<> $SessionUUID],

				Object[Protocol,FlowCytometry, "test protocol for ExperimentFlowCytometryOptions tests"<> $SessionUUID],
				Object[Method, FlowCytometry, "test method for ExperimentFlowCytometryOptions tests"<> $SessionUUID],
				Object[Instrument,FlowCytometer, "test instrument for ExperimentFlowCytometryOptions tests"<> $SessionUUID],

				Model[Molecule, "Test fluorophore with odd excitation and emission for ExperimentFlowCytometryOptions tests"<> $SessionUUID]
			}];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjs, DatabaseMemberQ[allObjs]];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];


		Module[
			{
				testBench,

				vessel1,
				vessel2,
				vessel3,
				vesseldiscarded,
				vesselnomodel,
				vesselconc,
				plate1,

				sample1,
				sample2,
				sample3,
				samplediscarded,
				samplenomodel,
				sampleconc,
				sampleplate1,
				sampleplate2,

				containerPackets,

				allObjs

			},
			(*perform the fist upload*)
			{testBench}=Upload[{
				<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Test bench for ExperimentFlowCytometryOptions tests"<> $SessionUUID, DeveloperObject -> True|>
			}];

			{
				vessel1,
				vessel2,
				vessel3,
				vesseldiscarded,
				vesselnomodel,
				vesselconc,
				plate1
			}=UploadSample[
				{
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "2L Glass Bottle"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"]
				},
				{
					{"Work Surface",testBench},
					{"Work Surface",testBench},
					{"Work Surface",testBench},
					{"Work Surface",testBench},
					{"Work Surface",testBench},
					{"Work Surface",testBench},
					{"Work Surface",testBench}
				},
				FastTrack -> True,
				Name -> {
					"2mL tube 1 for ExperimentFlowCytometryOptions tests"<> $SessionUUID,
					"50mL tube 1 for ExperimentFlowCytometryOptions tests"<> $SessionUUID,
					"2L bottle for ExperimentFlowCytometryOptions tests"<> $SessionUUID,
					"discarded 50mL tube for ExperimentFlowCytometryOptions tests"<> $SessionUUID,
					"no model 50mL tube for ExperimentFlowCytometryOptions tests"<> $SessionUUID,
					"2mL vessel for ExperimentFlowCytometryOptions tests with conc"<> $SessionUUID,
					"plate for ExperimentFlowCytometryOptions tests"<> $SessionUUID
				}
			];

			{
				sample1,
				sample2,
				sample3,
				samplediscarded,
				samplenomodel,
				sampleconc,
				sampleplate1,
				sampleplate2
			} = UploadSample[
				{
					Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
					Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
					Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
					Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
					Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
					Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
					Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
					Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"]
				},
				{
					{"A1", vessel1},
					{"A1", vessel2},
					{"A1", vessel3},
					{"A1", vesseldiscarded},
					{"A1", vesselnomodel},
					{"A1", vesselconc},
					{"A1", plate1},
					{"A2", plate1}
				},
				Name -> {
					"sample 1 in 2mL tube for ExperimentFlowCytometryOptions testing"<> $SessionUUID,
					"sample 2 in 50mL tube for ExperimentFlowCytometryOptions testing"<> $SessionUUID,
					"sample 3 in 2L bottle for ExperimentFlowCytometryOptions testing"<> $SessionUUID,
					"discarded sample in 50mL tube for ExperimentFlowCytometryOptions testing"<> $SessionUUID,
					"sample with no model in 50mL tube for ExperimentFlowCytometryOptions testing"<> $SessionUUID,
					"sample 4 in 2mL tube for ExperimentFlowCytometryOptions testing with concentration"<> $SessionUUID,
					"sample 5 in plate for ExperimentFlowCytometryOptions testing"<> $SessionUUID,
					"sample 6 in plate for ExperimentFlowCytometryOptions testing"<> $SessionUUID
				},
				InitialAmount -> {
					1500*Microliter,
					35*Milliliter,
					1*Liter,
					35*Milliliter,
					35*Milliliter,
					2Milliliter,
					1*Milliliter,
					1*Milliliter
				}
			];

			allObjs = Flatten[{
				vessel1, vessel2, vesseldiscarded,vesselconc,
				sample1, sample2, samplediscarded, sampleconc
			}];

			Upload[Flatten[{
				<|Object -> #, DeveloperObject -> True|>& /@ allObjs,
				<|
					Object -> Object[Sample, "sample with no model in 50mL tube for ExperimentFlowCytometryOptions testing"<> $SessionUUID],
					Model -> Null
				|>,
				<|
					Object -> Object[Sample, "sample 4 in 2mL tube for ExperimentFlowCytometryOptions testing with concentration"<> $SessionUUID],
					Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]]}, {5 Millimolar, Link[Model[Molecule, "Acetone"]]}}
				|>
			}]];
			UploadSampleStatus[samplediscarded, Discarded, FastTrack -> True];

			Upload[<|Type->Object[Protocol,FlowCytometry],Name->"test protocol for ExperimentFlowCytometryOptions tests"<> $SessionUUID|>];


			Upload[<|Type-> Object[Method,FlowCytometry],
				Replace[Detector]->{"488 FSC", "488 SSC", "488 525/35"},
				Replace[DetectionLabel]->{Null, Null, Link[Model[Molecule, "id:Vrbp1jK1LPom"]]},
				Replace[ExcitationWavelength]->{488*Nanometer},
				Replace[ExcitationPower]->{100*Milli*Watt},
				Replace[Gain]->{50*Milli*Volt,50*Milli*Volt,50*Milli*Volt},
				Replace[NeutralDensityFilter]->{False,False,False},
				Name->"test method for ExperimentFlowCytometryOptions tests"<> $SessionUUID
			|>];

			Upload[<|
				Type-> Object[Instrument,FlowCytometer],
				Model -> Link[Model[Instrument, FlowCytometer, "ZE5 Cell Analyzer"], Objects],
				Name->"test instrument for ExperimentFlowCytometryOptions tests"<> $SessionUUID
			|>];

			Upload[<|
				Type-> Model[Molecule],
				Fluorescent->True,
				Replace[FluorescenceExcitationMaximums]->{65*Nanometer},
				Replace[FluorescenceEmissionMaximums]->{80*Nanometer},
				Name->"Test fluorophore with odd excitation and emission for ExperimentFlowCytometryOptions tests"<> $SessionUUID
			|>];
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	)
];

(* ::Subsection:: *)
(*ExperimentFlowCytometryPreview*)

DefineTests[
	ExperimentFlowCytometryPreview,
	{
		Example[{Basic, "Return Null for one sample:"},
			ExperimentFlowCytometryPreview[Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometryPreview testing"<> $SessionUUID]],
			Null
		],
		Example[{Basic, "Return Null for mulitple samples:"},
			ExperimentFlowCytometryPreview[{Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometryPreview testing"<> $SessionUUID], Object[Sample, "sample 2 in 50mL tube for ExperimentFlowCytometryPreview testing"<> $SessionUUID]}],
			Null
		],
		Example[{Basic, "Return Null for a container:"},
			ExperimentFlowCytometryPreview[Object[Container, Vessel, "2mL tube 1 for ExperimentFlowCytometryPreview tests"<> $SessionUUID]],
			Null
		]
	},
	Stubs :> {
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SetUp :> (
		$CreatedObjects = {};
		ClearDownload[];
		ClearMemoization[];
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjs, existingObjects},
			allObjs = Flatten[{
				Object[Container, Bench, "Test bench for ExperimentFlowCytometryPreview tests"<> $SessionUUID],

				Object[Sample, "sample 1 in 2mL tube for ExperimentFlowCytometryPreview testing"<> $SessionUUID],
				Object[Sample, "sample 2 in 50mL tube for ExperimentFlowCytometryPreview testing"<> $SessionUUID],
				Object[Sample, "sample 3 in 2L bottle for ExperimentFlowCytometryPreview testing"<> $SessionUUID],
				Object[Sample, "sample 4 in 2mL tube for ExperimentFlowCytometryPreview testing with concentration"<> $SessionUUID],

				Object[Sample, "sample with no model in 50mL tube for ExperimentFlowCytometryPreview testing"<> $SessionUUID],
				Object[Sample, "discarded sample in 50mL tube for ExperimentFlowCytometryPreview testing"<> $SessionUUID],
				Object[Sample, "sample 5 in plate for ExperimentFlowCytometryPreview testing"<> $SessionUUID],
				Object[Sample, "sample 6 in plate for ExperimentFlowCytometryPreview testing"<> $SessionUUID],

				Object[Container, Vessel, "2mL tube 1 for ExperimentFlowCytometryPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "50mL tube 1 for ExperimentFlowCytometryPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "2L bottle for ExperimentFlowCytometryPreview tests"<> $SessionUUID],

				Object[Container, Vessel, "discarded 50mL tube for ExperimentFlowCytometryPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "no model 50mL tube for ExperimentFlowCytometryPreview tests"<> $SessionUUID],
				Object[Container, Vessel,"2mL vessel for ExperimentFlowCytometryPreview tests with conc"<> $SessionUUID],
				Object[Container,Plate, "plate for ExperimentFlowCytometryPreview tests"<> $SessionUUID],

				Object[Protocol,FlowCytometry, "test protocol for ExperimentFlowCytometryPreview tests"<> $SessionUUID],
				Object[Method, FlowCytometry, "test method for ExperimentFlowCytometryPreview tests"<> $SessionUUID],
				Object[Instrument,FlowCytometer, "test instrument for ExperimentFlowCytometryPreview tests"<> $SessionUUID],

				Model[Molecule, "Test fluorophore with odd excitation and emission for ExperimentFlowCytometryPreview tests"<> $SessionUUID]
			}];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjs, DatabaseMemberQ[allObjs]];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];


		Module[
			{
				testBench,

				vessel1,
				vessel2,
				vessel3,
				vesseldiscarded,
				vesselnomodel,
				vesselconc,
				plate1,

				sample1,
				sample2,
				sample3,
				samplediscarded,
				samplenomodel,
				sampleconc,
				sampleplate1,
				sampleplate2,

				containerPackets,

				allObjs

			},
			(*perform the fist upload*)
			{testBench}=Upload[{
				<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Test bench for ExperimentFlowCytometryPreview tests"<> $SessionUUID, DeveloperObject -> True|>
			}];

			{
				vessel1,
				vessel2,
				vessel3,
				vesseldiscarded,
				vesselnomodel,
				vesselconc,
				plate1
			}=UploadSample[
				{
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "2L Glass Bottle"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"]
				},
				{
					{"Work Surface",testBench},
					{"Work Surface",testBench},
					{"Work Surface",testBench},
					{"Work Surface",testBench},
					{"Work Surface",testBench},
					{"Work Surface",testBench},
					{"Work Surface",testBench}
				},
				FastTrack -> True,
				Name -> {
					"2mL tube 1 for ExperimentFlowCytometryPreview tests"<> $SessionUUID,
					"50mL tube 1 for ExperimentFlowCytometryPreview tests"<> $SessionUUID,
					"2L bottle for ExperimentFlowCytometryPreview tests"<> $SessionUUID,
					"discarded 50mL tube for ExperimentFlowCytometryPreview tests"<> $SessionUUID,
					"no model 50mL tube for ExperimentFlowCytometryPreview tests"<> $SessionUUID,
					"2mL vessel for ExperimentFlowCytometryPreview tests with conc"<> $SessionUUID,
					"plate for ExperimentFlowCytometryPreview tests"<> $SessionUUID
				}
			];

			{
				sample1,
				sample2,
				sample3,
				samplediscarded,
				samplenomodel,
				sampleconc,
				sampleplate1,
				sampleplate2
			} = UploadSample[
				{
					Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
					Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
					Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
					Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
					Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
					Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
					Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
					Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"]
				},
				{
					{"A1", vessel1},
					{"A1", vessel2},
					{"A1", vessel3},
					{"A1", vesseldiscarded},
					{"A1", vesselnomodel},
					{"A1", vesselconc},
					{"A1", plate1},
					{"A2", plate1}
				},
				Name -> {
					"sample 1 in 2mL tube for ExperimentFlowCytometryPreview testing"<> $SessionUUID,
					"sample 2 in 50mL tube for ExperimentFlowCytometryPreview testing"<> $SessionUUID,
					"sample 3 in 2L bottle for ExperimentFlowCytometryPreview testing"<> $SessionUUID,
					"discarded sample in 50mL tube for ExperimentFlowCytometryPreview testing"<> $SessionUUID,
					"sample with no model in 50mL tube for ExperimentFlowCytometryPreview testing"<> $SessionUUID,
					"sample 4 in 2mL tube for ExperimentFlowCytometryPreview testing with concentration"<> $SessionUUID,
					"sample 5 in plate for ExperimentFlowCytometryPreview testing"<> $SessionUUID,
					"sample 6 in plate for ExperimentFlowCytometryPreview testing"<> $SessionUUID
				},
				InitialAmount -> {
					1500*Microliter,
					35*Milliliter,
					1*Liter,
					35*Milliliter,
					35*Milliliter,
					2Milliliter,
					1*Milliliter,
					1*Milliliter
				}
			];

			allObjs = Flatten[{
				vessel1, vessel2, vesseldiscarded,vesselconc,
				sample1, sample2, samplediscarded, sampleconc
			}];

			Upload[Flatten[{
				<|Object -> #, DeveloperObject -> True|>& /@ allObjs,
				<|
					Object -> Object[Sample, "sample with no model in 50mL tube for ExperimentFlowCytometryPreview testing"<> $SessionUUID],
					Model -> Null
				|>,
				<|
					Object -> Object[Sample, "sample 4 in 2mL tube for ExperimentFlowCytometryPreview testing with concentration"<> $SessionUUID],
					Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]]}, {5 Millimolar, Link[Model[Molecule, "Acetone"]]}}
				|>
			}]];
			UploadSampleStatus[samplediscarded, Discarded, FastTrack -> True];

			Upload[<|Type->Object[Protocol,FlowCytometry],Name->"test protocol for ExperimentFlowCytometryPreview tests"<> $SessionUUID|>];


			Upload[<|Type-> Object[Method,FlowCytometry],
				Replace[Detector]->{"488 FSC", "488 SSC", "488 525/35"},
				Replace[DetectionLabel]->{Null, Null, Link[Model[Molecule, "id:Vrbp1jK1LPom"]]},
				Replace[ExcitationWavelength]->{488*Nanometer},
				Replace[ExcitationPower]->{100*Milli*Watt},
				Replace[Gain]->{50*Milli*Volt,50*Milli*Volt,50*Milli*Volt},
				Replace[NeutralDensityFilter]->{False,False,False},
				Name->"test method for ExperimentFlowCytometryPreview tests"<> $SessionUUID
			|>];

			Upload[<|
				Type-> Object[Instrument,FlowCytometer],
				Model -> Link[Model[Instrument, FlowCytometer, "ZE5 Cell Analyzer"], Objects],
				Name->"test instrument for ExperimentFlowCytometryPreview tests"<> $SessionUUID
			|>];

			Upload[<|
				Type-> Model[Molecule],
				Fluorescent->True,
				Replace[FluorescenceExcitationMaximums]->{65*Nanometer},
				Replace[FluorescenceEmissionMaximums]->{80*Nanometer},
				Name->"Test fluorophore with odd excitation and emission for ExperimentFlowCytometryPreview tests"<> $SessionUUID
			|>];
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	)
];

(* ::Subsection:: *)
(*ValidExperimentFlowCytometryQ*)

DefineTests[
	ValidExperimentFlowCytometryQ,
	{
		Example[{Basic, "Determine the validity of a flow cytometry call on one sample:"},
			ValidExperimentFlowCytometryQ[
				Object[Sample, "sample 1 in 2mL tube for ValidExperimentFlowCytometryQ testing"<> $SessionUUID]
			],
			True
		],
		Example[{Basic, "Determine the validity of a flow cytometry call on multiple samples:"},
			ValidExperimentFlowCytometryQ[
				{
					Object[Sample, "sample 1 in 2mL tube for ValidExperimentFlowCytometryQ testing"<> $SessionUUID],
					Object[Sample, "sample 2 in 50mL tube for ValidExperimentFlowCytometryQ testing"<> $SessionUUID]
				}
			],
			True
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TestSummary, return a test summary instead of a Boolean:"},
			ValidExperimentFlowCytometryQ[
				{
					Object[Sample, "sample 1 in 2mL tube for ValidExperimentFlowCytometryQ testing"<> $SessionUUID],
					Object[Sample, "sample 2 in 50mL tube for ValidExperimentFlowCytometryQ testing"<> $SessionUUID]
				},
				OutputFormat -> TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose, "If Verbose -> Failures, print the failing tests:"},
			ValidExperimentFlowCytometryQ[
				Object[Sample, "sample 1 in 2mL tube for ValidExperimentFlowCytometryQ testing"<> $SessionUUID],
				Flush->True,
				FlushFrequency->Null,
				Verbose -> Failures
			],
			False
		]
	},
	Stubs :> {
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SetUp :> (
		$CreatedObjects = {};
		ClearDownload[];
		ClearMemoization[];
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjs, existingObjects},
			allObjs = Flatten[{
				Object[Container, Bench, "Test bench for ValidExperimentFlowCytometryQ tests"<> $SessionUUID],

				Object[Sample, "sample 1 in 2mL tube for ValidExperimentFlowCytometryQ testing"<> $SessionUUID],
				Object[Sample, "sample 2 in 50mL tube for ValidExperimentFlowCytometryQ testing"<> $SessionUUID],
				Object[Sample, "sample 3 in 2L bottle for ValidExperimentFlowCytometryQ testing"<> $SessionUUID],
				Object[Sample, "sample 4 in 2mL tube for ValidExperimentFlowCytometryQ testing with concentration"<> $SessionUUID],

				Object[Sample, "sample with no model in 50mL tube for ValidExperimentFlowCytometryQ testing"<> $SessionUUID],
				Object[Sample, "discarded sample in 50mL tube for ValidExperimentFlowCytometryQ testing"<> $SessionUUID],
				Object[Sample, "sample 5 in plate for ValidExperimentFlowCytometryQ testing"<> $SessionUUID],
				Object[Sample, "sample 6 in plate for ValidExperimentFlowCytometryQ testing"<> $SessionUUID],

				Object[Container, Vessel, "2mL tube 1 for ValidExperimentFlowCytometryQ tests"<> $SessionUUID],
				Object[Container, Vessel, "50mL tube 1 for ValidExperimentFlowCytometryQ tests"<> $SessionUUID],
				Object[Container, Vessel, "2L bottle for ValidExperimentFlowCytometryQ tests"<> $SessionUUID],

				Object[Container, Vessel, "discarded 50mL tube for ValidExperimentFlowCytometryQ tests"<> $SessionUUID],
				Object[Container, Vessel, "no model 50mL tube for ValidExperimentFlowCytometryQ tests"<> $SessionUUID],
				Object[Container, Vessel,"2mL vessel for ValidExperimentFlowCytometryQ tests with conc"<> $SessionUUID],
				Object[Container,Plate, "plate for ValidExperimentFlowCytometryQ tests"<> $SessionUUID],

				Object[Protocol,FlowCytometry, "test protocol for ValidExperimentFlowCytometryQ tests"<> $SessionUUID],
				Object[Method, FlowCytometry, "test method for ValidExperimentFlowCytometryQ tests"<> $SessionUUID],
				Object[Instrument,FlowCytometer, "test instrument for ValidExperimentFlowCytometryQ tests"<> $SessionUUID],

				Model[Molecule, "Test fluorophore with odd excitation and emission for ValidExperimentFlowCytometryQ tests"<> $SessionUUID]
			}];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjs, DatabaseMemberQ[allObjs]];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];


		Module[
			{
				testBench,

				vessel1,
				vessel2,
				vessel3,
				vesseldiscarded,
				vesselnomodel,
				vesselconc,
				plate1,

				sample1,
				sample2,
				sample3,
				samplediscarded,
				samplenomodel,
				sampleconc,
				sampleplate1,
				sampleplate2,

				containerPackets,

				allObjs

			},
			(*perform the fist upload*)
			{testBench}=Upload[{
				<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Test bench for ValidExperimentFlowCytometryQ tests"<> $SessionUUID, DeveloperObject -> True|>
			}];

			{
				vessel1,
				vessel2,
				vessel3,
				vesseldiscarded,
				vesselnomodel,
				vesselconc,
				plate1
			}=UploadSample[
				{
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "2L Glass Bottle"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"]
				},
				{
					{"Work Surface",testBench},
					{"Work Surface",testBench},
					{"Work Surface",testBench},
					{"Work Surface",testBench},
					{"Work Surface",testBench},
					{"Work Surface",testBench},
					{"Work Surface",testBench}
				},
				FastTrack -> True,
				Name -> {
					"2mL tube 1 for ValidExperimentFlowCytometryQ tests"<> $SessionUUID,
					"50mL tube 1 for ValidExperimentFlowCytometryQ tests"<> $SessionUUID,
					"2L bottle for ValidExperimentFlowCytometryQ tests"<> $SessionUUID,
					"discarded 50mL tube for ValidExperimentFlowCytometryQ tests"<> $SessionUUID,
					"no model 50mL tube for ValidExperimentFlowCytometryQ tests"<> $SessionUUID,
					"2mL vessel for ValidExperimentFlowCytometryQ tests with conc"<> $SessionUUID,
					"plate for ValidExperimentFlowCytometryQ tests"<> $SessionUUID
				}
			];

			{
				sample1,
				sample2,
				sample3,
				samplediscarded,
				samplenomodel,
				sampleconc,
				sampleplate1,
				sampleplate2
			} = UploadSample[
				{
					Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
					Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
					Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
					Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
					Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
					Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
					Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
					Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"]
				},
				{
					{"A1", vessel1},
					{"A1", vessel2},
					{"A1", vessel3},
					{"A1", vesseldiscarded},
					{"A1", vesselnomodel},
					{"A1", vesselconc},
					{"A1", plate1},
					{"A2", plate1}
				},
				Name -> {
					"sample 1 in 2mL tube for ValidExperimentFlowCytometryQ testing"<> $SessionUUID,
					"sample 2 in 50mL tube for ValidExperimentFlowCytometryQ testing"<> $SessionUUID,
					"sample 3 in 2L bottle for ValidExperimentFlowCytometryQ testing"<> $SessionUUID,
					"discarded sample in 50mL tube for ValidExperimentFlowCytometryQ testing"<> $SessionUUID,
					"sample with no model in 50mL tube for ValidExperimentFlowCytometryQ testing"<> $SessionUUID,
					"sample 4 in 2mL tube for ValidExperimentFlowCytometryQ testing with concentration"<> $SessionUUID,
					"sample 5 in plate for ValidExperimentFlowCytometryQ testing"<> $SessionUUID,
					"sample 6 in plate for ValidExperimentFlowCytometryQ testing"<> $SessionUUID
				},
				InitialAmount -> {
					1500*Microliter,
					35*Milliliter,
					1*Liter,
					35*Milliliter,
					35*Milliliter,
					2Milliliter,
					1*Milliliter,
					1*Milliliter
				}
			];

			allObjs = Flatten[{
				vessel1, vessel2, vesseldiscarded,vesselconc,
				sample1, sample2, samplediscarded, sampleconc
			}];

			Upload[Flatten[{
				<|Object -> #, DeveloperObject -> True|>& /@ allObjs,
				<|
					Object -> Object[Sample, "sample with no model in 50mL tube for ValidExperimentFlowCytometryQ testing"<> $SessionUUID],
					Model -> Null
				|>,
				<|
					Object -> Object[Sample, "sample 4 in 2mL tube for ValidExperimentFlowCytometryQ testing with concentration"<> $SessionUUID],
					Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]]}, {5 Millimolar, Link[Model[Molecule, "Acetone"]]}}
				|>
			}]];
			UploadSampleStatus[samplediscarded, Discarded, FastTrack -> True];

			Upload[<|Type->Object[Protocol,FlowCytometry],Name->"test protocol for ValidExperimentFlowCytometryQ tests"<> $SessionUUID|>];


			Upload[<|Type-> Object[Method,FlowCytometry],
				Replace[Detector]->{"488 FSC", "488 SSC", "488 525/35"},
				Replace[DetectionLabel]->{Null, Null, Link[Model[Molecule, "id:Vrbp1jK1LPom"]]},
				Replace[ExcitationWavelength]->{488*Nanometer},
				Replace[ExcitationPower]->{100*Milli*Watt},
				Replace[Gain]->{50*Milli*Volt,50*Milli*Volt,50*Milli*Volt},
				Replace[NeutralDensityFilter]->{False,False,False},
				Name->"test method for ValidExperimentFlowCytometryQ tests"<> $SessionUUID
			|>];

			Upload[<|
				Type-> Object[Instrument,FlowCytometer],
				Model -> Link[Model[Instrument, FlowCytometer, "ZE5 Cell Analyzer"], Objects],
				Name->"test instrument for ValidExperimentFlowCytometryQ tests"<> $SessionUUID
			|>];

			Upload[<|
				Type-> Model[Molecule],
				Fluorescent->True,
				Replace[FluorescenceExcitationMaximums]->{65*Nanometer},
				Replace[FluorescenceEmissionMaximums]->{80*Nanometer},
				Name->"Test fluorophore with odd excitation and emission for ValidExperimentFlowCytometryQ tests"<> $SessionUUID
			|>];
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	)
];

(* ::Subsection:: *)
(*FlowCytometry Unit Op*)

DefineTests[
	FlowCytometry,
	{
		Example[
			{Basic,"Generate an ExperimentManualCellPreparation protocol based on a single FlowCytometry unit operation with a single sample:"},
			ExperimentManualCellPreparation[
				FlowCytometry[
					Sample->{Object[Sample,"Test sample 1 in 2mL Tube for FlowCytometry" <> $SessionUUID]}
				]
			],
			ObjectP[Object[Protocol,ManualCellPreparation]]
		],
		Example[
			{Basic,"Generate an ExperimentManualCellPreparation protocol based on a single FlowCytometry unit operation with multiple samples:"},
			ExperimentManualCellPreparation[
				FlowCytometry[
					Sample->{Object[Sample,"Test sample 1 in 2mL Tube for FlowCytometry" <> $SessionUUID],Object[Sample,"Test sample 2 in 2mL Tube for FlowCytometry" <> $SessionUUID]}
				]
			],
			ObjectP[Object[Protocol,ManualCellPreparation]]
		],
		Example[
			{Basic,"Generate an ExperimentManualCellPreparation protocol based on a single FlowCytometry unit operation with a single sample using ExperimentCellPreparation:"},
			ExperimentCellPreparation[
				FlowCytometry[
					Sample->{Object[Sample,"Test sample 1 in 2mL Tube for FlowCytometry" <> $SessionUUID]}
				]
			],
			ObjectP[Object[Protocol,ManualCellPreparation]]
		],
		Example[
			{Messages,"InvalidUnitOperationHeads","Canont perform this UnitOpertion Robotically:"},
			ExperimentRoboticCellPreparation[
				FlowCytometry[
					Sample->Object[Sample,"Test sample 1 in 2mL Tube for FlowCytometry" <> $SessionUUID]
				]
			],
			$Failed,
			Messages:>{Error::InvalidUnitOperationHeads,Error::InvalidInput}
		],
		Example[
			{Additional,"Label the sample and then perform the FlowCytometry unit operation:"},
			ExperimentCellPreparation[
				{
					LabelSample[
						Label -> "my FC sample",
						Sample -> Object[Sample, "Test sample 1 in 2mL Tube for FlowCytometry"<> $SessionUUID]
					],
					FlowCytometry[
						Sample -> {"my FC sample"}
					]
				}
			],
			ObjectP[{Object[Protocol,ManualCellPreparation], Object[Notebook, Script]}]
		]
	},
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[
			{allObjects,existsFilter,vessel1,vessel2,sample1,sample2},
			(* Define a list of all of the objects that are created in the SymbolSetUp *)
			allObjects = {
				Object[Container,Vessel,"Test Vessel 1 for FlowCytometry" <> $SessionUUID],
				Object[Container,Vessel,"Test Vessel 2 for FlowCytometry" <> $SessionUUID],
				Object[Sample,"Test sample 1 in 2mL Tube for FlowCytometry" <> $SessionUUID],
				Object[Sample,"Test sample 2 in 2mL Tube for FlowCytometry" <> $SessionUUID]
			};

			(* Erase any Objects that we failed to erase in the last unit test *)
			existsFilter=DatabaseMemberQ[allObjects];

			Quiet[EraseObject[
				PickList[
					allObjects,
					existsFilter
				],
				Force->True,
				Verbose->False
			]];

			(* Create some empty containers. *)
			{vessel1,vessel2}=Upload[{
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
					Name -> "Test Vessel 1 for FlowCytometry" <> $SessionUUID,
					Site -> Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
					Name -> "Test Vessel 2 for FlowCytometry" <> $SessionUUID,
					Site -> Link[$Site],
					DeveloperObject -> True
				|>
			}];

			(* Create some samples for testing purposes *)
			{sample1,sample2}=UploadSample[
				{
					Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"],
					Model[Sample, "Submicron particle size reference kit0.1 micron fluroescent microspheres"]
				},
				{
					{"A1",vessel1},
					{"A1",vessel2}
				},
				Name->{
					"Test sample 1 in 2mL Tube for FlowCytometry" <> $SessionUUID,
					"Test sample 2 in 2mL Tube for FlowCytometry" <> $SessionUUID
				},
				InitialAmount->{
					1500 Microliter,
					1000 Microliter
				}
			];

			(* Make some changes to our samples for testing purposes *)
			Upload[{
				<|Object->sample1,DeveloperObject->True|>,
				<|Object->sample2,DeveloperObject->True|>
			}];
		];
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjects},

			(* Make sure this is the same list as allObjects in the symbolSetUp *)
			allObjects = {
				Object[Container,Vessel,"Test Vessel 1 for FlowCytometry" <> $SessionUUID],
				Object[Container,Vessel,"Test Vessel 2 for FlowCytometry" <> $SessionUUID],
				Object[Sample,"Test sample 1 in 2mL Tube for FlowCytometry" <> $SessionUUID],
				Object[Sample,"Test sample 2 in 2mL Tube for FlowCytometry" <> $SessionUUID]
			};

			Quiet[EraseObject[allObjects,Force->True,Verbose->False]];
		];)
]