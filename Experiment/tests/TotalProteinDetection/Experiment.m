(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentTotalProteinDetection: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection:: *)
(*ExperimentTotalProteinDetection*)

DefineTests[
	ExperimentTotalProteinDetection,
	{
		(* Basic Examples *)
		Example[{Basic, "Accepts a sample object:"},
			ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID]],
			ObjectP[Object[Protocol, TotalProteinDetection]]
		],
		Example[{Basic, "Accepts a non-empty container object:"},
			ExperimentTotalProteinDetection[Object[Container, Vessel, "Test 2mL Tube 1 containing lysate sample for ExperimentTotalProteinDetection" <> $SessionUUID]],
			ObjectP[Object[Protocol, TotalProteinDetection]]
		],
		Example[{Basic, "Accepts a mixture of sample objects and non-empty container objects:"},
			ExperimentTotalProteinDetection[{Object[Sample, "Test 1 mL lysate sample, 0.5 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Object[Container, Vessel, "Test 2mL Tube 1 containing lysate sample for ExperimentTotalProteinDetection" <> $SessionUUID]}],
			ObjectP[Object[Protocol, TotalProteinDetection]]
		],
		(* Additional *)
		Example[{Additional, "Specify the Aliquot options to dilute an input sample with Model[Sample,StockSolution,\"Simple Western 0.1X Sample Buffer\"]:"},
			ExperimentTotalProteinDetection[
				{Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID]},
				Aliquot -> {True, False}, AliquotAmount -> {50 * Microliter, Automatic}, AssayVolume -> {100 * Microliter, Automatic}, AssayBuffer -> {Model[Sample, StockSolution, "Simple Western 0.1X Sample Buffer"], Automatic}
			],
			ObjectP[Object[Protocol, TotalProteinDetection]]
		],
		Example[{Additional, "Accepts a Model-less sample:"},
			ExperimentTotalProteinDetection[Object[Sample, "Test Modelless 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID]],
			ObjectP[Object[Protocol, TotalProteinDetection]]
		],
		(* Error Messages before option resolution *)
		Example[{Messages, "DiscardedSamples", "The input sample cannot have a Status of Discarded:"},
			ExperimentTotalProteinDetection[Object[Sample, "Test discarded lysate sample for ExperimentTotalProteinDetection" <> $SessionUUID]],
			$Failed,
			Messages :> {
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "TooManyInputsForWes", "A maximum of 24 input samples can be run in one protocol:"},
			ExperimentTotalProteinDetection[{Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID]}],
			$Failed,
			Messages :> {
				Error::TooManyInputsForWes,
				Error::InvalidInput
			}
		],
		Example[{Messages, "NumberOfReplicatesTooHighForNumberOfWesInputSamples", "The number of input samples times the NumberOfReplicates cannot be larger than 24:"},
			ExperimentTotalProteinDetection[{Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID]}, NumberOfReplicates -> 13],
			$Failed,
			Messages :> {
				Error::NumberOfReplicatesTooHighForNumberOfWesInputSamples,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingWesDenaturingOptions", "The Denaturing, DenaturingTemperature, and DenaturingTime options must not conflict:"},
			ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Denaturing -> True, DenaturingTemperature -> Null],
			$Failed,
			Messages :> {
				Error::ConflictingWesDenaturingOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "WesternLoadingVolumeTooLarge", "For each input, the LoadingVolume must be smaller than the sum of the SampleVolume and the LoadingBufferVolume:"},
			ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], SampleVolume -> 7 * Microliter, LoadingBufferVolume -> 1 * Microliter, LoadingVolume -> 9 * Microliter],
			$Failed,
			Messages :> {
				Error::WesternLoadingVolumeTooLarge,
				Error::InvalidOption
			}
		],
		(* Messages during option resolution *)
		Example[{Messages, "WesHighDynamicRangeImagingNotPossible", "The supplied SignalDetectionTimes need to be the default values for High Dynamic Range (HDR) image processing to occur:"},
			Lookup[ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				SignalDetectionTimes -> {1, 2, 3, 4, 5, 6, 7, 8, 9} * Second, MolecularWeightRange -> MidMolecularWeight, Output -> Options],
				MolecularWeightRange
			],
			MidMolecularWeight,
			Messages :> {
				Warning::WesHighDynamicRangeImagingNotPossible
			}
		],
		Example[{Messages, "WesLadderNotOptimalForMolecularWeightRange", "The supplied Ladder should be the default Ladder for the MolecularWeightRange:"},
			Lookup[ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				Ladder -> Model[Sample, StockSolution, "Simple Western Biotinylated Ladder Solution (MW 66-440 kDa) - EZ Standard Pack 3"], MolecularWeightRange -> MidMolecularWeight, Output -> Options],
				MolecularWeightRange
			],
			MidMolecularWeight,
			Messages :> {
				Warning::WesLadderNotOptimalForMolecularWeightRange
			}
		],
		Example[{Messages, "WesWashBufferNotOptimal", "The supplied WashBuffer should be the default WashBuffer:"},
			Lookup[ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				WashBuffer -> Model[Sample, "Simple Western Milk-Free Antibody Diluent"], Output -> Options],
				WashBuffer
			],
			ObjectReferenceP[Model[Sample, "Simple Western Milk-Free Antibody Diluent"]],
			Messages :> {
				Warning::WesWashBufferNotOptimal
			}
		],
		Example[{Messages, "WesConcentratedLoadingBufferNotOptimal", "The supplied ConcentratedLoadingBuffer should be the default ConcentratedLoadingBuffer for the MolecularWeightRange:"},
			Lookup[ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				ConcentratedLoadingBuffer -> Model[Sample, StockSolution, "Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 26 kDa System Control - EZ Standard Pack 5"], MolecularWeightRange -> MidMolecularWeight, Output -> Options],
				ConcentratedLoadingBuffer
			],
			ObjectReferenceP[Model[Sample, StockSolution, "Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 26 kDa System Control - EZ Standard Pack 5"]],
			Messages :> {
				Warning::WesConcentratedLoadingBufferNotOptimal
			}
		],
		Example[{Messages, "InputContainsTemporalLinks", "A Warning is thrown if any inputs contain temporal links:"},
			ExperimentTotalProteinDetection[Link[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Now]
			],
			ObjectP[Object[Protocol, TotalProteinDetection]],
			Messages :> {
				Warning::InputContainsTemporalLinks
			}
		],
		Example[{Messages, "NotEnoughWesLoadingBuffer", "The sum of the ConcentratedLoadingBufferVolume and DenaturantVolume or WaterVolume options should be larger than the LoadingBuffer required for the experiment (all 24 potential sample capillaries):"},
			ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				ConcentratedLoadingBufferVolume -> 10 * Microliter, DenaturantVolume -> 10 * Microliter, LoadingBufferVolume -> 2 * Microliter],
			$Failed,
			Messages :> {
				Error::NotEnoughWesLoadingBuffer,
				Error::InvalidOption
			}
		],
		Example[{Messages, "WesInputsShouldBeDiluted", "If a lysate input sample has a TotalProteinConcentration greater than 3 mg/mL, it should be diluted with Model[Sample,StockSolution,\"Simple Western 0.1X Sample Buffer\"] using the sample preparation aliquot options:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 5 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				Output -> Options];
			Lookup[options, MolecularWeightRange],
			MidMolecularWeight,
			Variables :> {options},
			Messages :> {
				Warning::WesInputsShouldBeDiluted
			}
		],
		(* -- Option Unit Tests -- *)
		(* - Option Precision Tests - *)
		Example[{Options, DenaturingTemperature, "Rounds specified DenaturingTemperature to the nearest 1 Celsius:"},
			roundedDenaturingTemperatureOptions = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], DenaturingTemperature -> 94.9 * Celsius, Output -> Options];
			Lookup[roundedDenaturingTemperatureOptions, DenaturingTemperature],
			95.0 * Celsius,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Options, DenaturingTime, "Rounds specified DenaturingTime to the nearest 1 Second:"},
			roundedDenaturingTimeOptions = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], DenaturingTime -> 299.7 * Second, Output -> Options];
			Lookup[roundedDenaturingTimeOptions, DenaturingTime],
			300.0 * Second,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Options, SeparatingMatrixLoadTime, "Rounds specified SeparatingMatrixLoadTime to the nearest 0.1 Second:"},
			roundedSeparatingMatrixLoadTimeOptions = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], SeparatingMatrixLoadTime -> 200.01 * Second, Output -> Options];
			Lookup[roundedSeparatingMatrixLoadTimeOptions, SeparatingMatrixLoadTime],
			200.0 * Second,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Options, StackingMatrixLoadTime, "Rounds specified StackingMatrixLoadTime to the nearest 0.1 Second:"},
			roundedStackingMatrixLoadTimeOptions = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], StackingMatrixLoadTime -> 12.02 * Second, Output -> Options];
			Lookup[roundedStackingMatrixLoadTimeOptions, StackingMatrixLoadTime],
			12.0 * Second,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Options, SampleVolume, "Rounds specified SampleVolume to the nearest 0.1 Microliter:"},
			roundedSampleVolumeOptions = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], SampleVolume -> 7.99 * Microliter, Output -> Options];
			Lookup[roundedSampleVolumeOptions, SampleVolume],
			8.0 * Microliter,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Options, ConcentratedLoadingBufferVolume, "Rounds specified ConcentratedLoadingBufferVolume to the nearest 0.1 Microliter:"},
			roundedConcentratedLoadingBufferVolumeOptions = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], ConcentratedLoadingBufferVolume -> 39.99 * Microliter, Output -> Options];
			Lookup[roundedConcentratedLoadingBufferVolumeOptions, ConcentratedLoadingBufferVolume],
			40.0 * Microliter,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Options, DenaturantVolume, "Rounds specified DenaturantVolume to the nearest 0.1 Microliter:"},
			roundedConcentratedDenaturantVolumeOptions = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], DenaturantVolume -> 39.99 * Microliter, Output -> Options];
			Lookup[roundedConcentratedDenaturantVolumeOptions, DenaturantVolume],
			40.0 * Microliter,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Options, WaterVolume, "Rounds specified WaterVolume to the nearest 0.1 Microliter:"},
			roundedWaterVolumeOptions = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Denaturing -> False, WaterVolume -> 39.99 * Microliter, Output -> Options];
			Lookup[roundedWaterVolumeOptions, WaterVolume],
			40.0 * Microliter,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Options, LoadingBufferVolume, "Rounds specified LoadingBufferVolume to the nearest 0.1 Microliter:"},
			roundedLoadingBufferVolumeOptions = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], LoadingBufferVolume -> 1.97 * Microliter, Output -> Options];
			Lookup[roundedLoadingBufferVolumeOptions, LoadingBufferVolume],
			2.0 * Microliter,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Options, LoadingVolume, "Rounds specified LoadingVolume to the nearest 0.1 Microliter:"},
			roundedLoadingVolumeOptions = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Denaturing -> False, LoadingVolume -> 5.97 * Microliter, Output -> Options];
			Lookup[roundedLoadingVolumeOptions, LoadingVolume],
			6.0 * Microliter,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Options, LadderVolume, "Rounds specified LadderVolume to the nearest 0.1 Microliter:"},
			roundedLadderVolumeOptions = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Denaturing -> False, LadderVolume -> 5.01 * Microliter, Output -> Options];
			Lookup[roundedLadderVolumeOptions, LadderVolume],
			5.0 * Microliter,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Options, SampleLoadTime, "Rounds specified SampleLoadTime to the nearest 0.1 Second:"},
			roundedSampleLoadTimeOptions = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], SampleLoadTime -> 8.99 * Second, Output -> Options];
			Lookup[roundedSampleLoadTimeOptions, SampleLoadTime],
			9.0 * Second,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Options, SeparationTime, "Rounds specified SeparationTime to the nearest 0.1 Second:"},
			roundedSeparationTimeOptions = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], SeparationTime -> 1500.01 * Second, Output -> Options];
			Lookup[roundedSeparationTimeOptions, SeparationTime],
			1500.0 * Second,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Options, UVExposureTime, "Rounds specified UVExposureTime to the nearest 0.1 Second:"},
			roundedUVExposureTimeOptions = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], UVExposureTime -> 199.98 * Second, Output -> Options];
			Lookup[roundedUVExposureTimeOptions, UVExposureTime],
			200.0 * Second,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Options, WashBufferVolume, "Rounds specified WashBufferVolume to the nearest 0.1 Microliter:"},
			roundedWashBufferVolumeOptions = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], WashBufferVolume -> 499.96 * Microliter, Output -> Options];
			Lookup[roundedWashBufferVolumeOptions, WashBufferVolume],
			500.0 * Microliter,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Options, LuminescenceReagentVolume, "Rounds specified LuminescenceReagentVolume to the nearest 0.1 Microliter:"},
			roundedLuminescenceReagentVolumeOptions = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], LuminescenceReagentVolume -> 14.99 * Microliter, Output -> Options];
			Lookup[roundedLuminescenceReagentVolumeOptions, LuminescenceReagentVolume],
			15.0 * Microliter,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Options, SignalDetectionTimes, "Rounds specified SignalDetectionTimes to the nearest 0.1 Second:"},
			roundedSignalDetectionTimesOptions = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], SignalDetectionTimes -> {1 * Second, 2 * Second, 4 * Second, 8 * Second, 16 * Second, 32.02 * Second, 64 * Second, 128 * Second, 512 * Second}, Output -> Options];
			Lookup[roundedSignalDetectionTimesOptions, SignalDetectionTimes],
			{1 * Second, 2 * Second, 4 * Second, 8 * Second, 16 * Second, 32 * Second, 64 * Second, 128 * Second, 512 * Second},
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Options, BlockingBufferVolume, "Rounds specified BlockingBufferVolume to the nearest 0.1 Microliter:"},
			roundedBlockingBufferVolumeOptions = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], BlockingBufferVolume -> 9.99 * Microliter, Output -> Options];
			Lookup[roundedBlockingBufferVolumeOptions, BlockingBufferVolume],
			10.0 * Microliter,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Options, BlockingTime, "Rounds specified BlockingTime to the nearest 0.1 Second:"},
			roundedBlockingTimeOptions = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], BlockingTime -> 1800.01 * Second, Output -> Options];
			Lookup[roundedBlockingTimeOptions, BlockingTime],
			1800.0 * Second,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Options, LabelingReagentVolume, "Rounds specified LabelingReagentVolume to the nearest 0.1 Microliter:"},
			roundedLabelingReagentVolumeOptions = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], LabelingReagentVolume -> 9.97 * Microliter, Output -> Options];
			Lookup[roundedLabelingReagentVolumeOptions, LabelingReagentVolume],
			10.0 * Microliter,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Options, LabelingTime, "Rounds specified LabelingTime to the nearest 0.1 Second:"},
			roundedLabelingTimeOptions = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], LabelingTime -> 1800.01 * Second, Output -> Options];
			Lookup[roundedLabelingTimeOptions, LabelingTime],
			1800.0 * Second,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Options, PeroxidaseReagentVolume, "Rounds specified PeroxidaseReagentVolume to the nearest 0.1 Microliter:"},
			roundedPeroxidaseReagentVolumeOptions = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], PeroxidaseReagentVolume -> 8.02 * Microliter, Output -> Options];
			Lookup[roundedPeroxidaseReagentVolumeOptions, PeroxidaseReagentVolume],
			8.0 * Microliter,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Options, PeroxidaseIncubationTime, "Rounds specified PeroxidaseIncubationTime to the nearest 0.1 Second:"},
			roundedPeroxidaseIncubationTimeOptions = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], PeroxidaseIncubationTime -> 1800.01 * Second, Output -> Options];
			Lookup[roundedPeroxidaseIncubationTimeOptions, PeroxidaseIncubationTime],
			1800.0 * Second,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Options, LadderBlockingBufferVolume, "Rounds specified PeroxidaseIncubationTime to the nearest 0.1 Microliter:"},
			roundedLadderBlockingBufferVolumeOptions = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], LadderBlockingBufferVolume -> 9.97 * Microliter, Output -> Options];
			Lookup[roundedLadderBlockingBufferVolumeOptions, LadderBlockingBufferVolume],
			10 * Microliter,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		(* - Options with Defaults Tests - *)
		Example[{Options, Instrument, "The Instrument option defaults to Model[Instrument,Western,\"Wes\"]:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Output -> Options];
			Lookup[options, Instrument],
			ObjectReferenceP[Model[Instrument, Western, "Wes"]],
			Variables :> {options}
		],
		Example[{Options, Instrument, "The function accepts an appropriate Instrument Object:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Instrument -> Object[Instrument, Western, "Test Wes Instrument for ExperimentTotalProteinDetection Tests" <> $SessionUUID], Output -> Options];
			Lookup[options, Instrument],
			ObjectReferenceP[Object[Instrument, Western, "Test Wes Instrument for ExperimentTotalProteinDetection Tests" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, NumberOfReplicates, "The product of the NumberOfReplicates and the number of input samples cannot be greater than 24:"},
			ExperimentTotalProteinDetection[{Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID]}, NumberOfReplicates -> 19],
			$Failed,
			Messages :> {
				Error::NumberOfReplicatesTooHighForNumberOfWesInputSamples,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DuplicateName", "If the Name option is specified, it cannot be identical to an existing Object[Protocol,TotalProteinDetection] Name:"},
			ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Name -> "Fake protocol object for parseTotalProteinDetection unit tests"],
			$Failed,
			Messages :> {
				Error::DuplicateName,
				Error::InvalidOption
			}
		],
		Example[{Options, WashBuffer, "The WashBuffer option defaults to Model[Sample,\"Simple Western Wash Buffer\"]:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Output -> Options];
			Lookup[options, WashBuffer],
			ObjectReferenceP[Model[Sample, "Simple Western Wash Buffer"]],
			Variables :> {options}
		],
		Example[{Options, LabelingReagent, "The LabelingReagent option defaults to Model[Sample,StockSolution,\"Simple Western Total Protein Labeling Solution - Total Protein Kit\"]:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Output -> Options];
			Lookup[options, LabelingReagent],
			ObjectReferenceP[Model[Sample, StockSolution, "Simple Western Total Protein Labeling Solution - Total Protein Kit"]],
			Variables :> {options}
		],
		Example[{Options, BlockingBuffer, "The BlockingBuffer option defaults to Model[Sample,\"Simple Western Antibody Diluent 2 - Total Protein Kit\"]:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Output -> Options];
			Lookup[options, BlockingBuffer],
			ObjectReferenceP[Model[Sample, "Simple Western Antibody Diluent 2 - Total Protein Kit"]],
			Variables :> {options}
		],
		Example[{Options, LadderBlockingBuffer, "The LadderBlockingBuffer option defaults to Model[Sample,\"Simple Western Antibody Diluent 2 - Total Protein Kit\"]:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Output -> Options];
			Lookup[options, LadderBlockingBuffer],
			ObjectReferenceP[Model[Sample, "Simple Western Antibody Diluent 2 - Total Protein Kit"]],
			Variables :> {options}
		],
		Example[{Options, PeroxidaseReagent, "The PeroxidaseReagent option defaults to Model[Sample,\"Simple Western Total Protein Streptavidin-HRP - Total Protein Kit\"]:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Output -> Options];
			Lookup[options, PeroxidaseReagent],
			ObjectReferenceP[Model[Sample, "Simple Western Total Protein Streptavidin-HRP - Total Protein Kit"]],
			Variables :> {options}
		],
		Example[{Options, PeroxidaseReagentStorageCondition, "The PeroxidaseReagentStorageCondition is used to indicate how the PeroxidaseReagent should be stored after the experiemnt:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], PeroxidaseReagentStorageCondition -> AmbientStorage, Output -> Options];
			Lookup[options, PeroxidaseReagentStorageCondition],
			AmbientStorage,
			Variables :> {options}
		],
		Example[{Options, LuminescenceReagent, "The LuminescenceReagent option defaults to Model[Sample,StockSolution,\"SimpleWestern Luminescence Reagent - Total Protein Kit\"]:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Output -> Options];
			Lookup[options, LuminescenceReagent],
			Model[Sample, StockSolution, "SimpleWestern Luminescence Reagent - Total Protein Kit"],
			Variables :> {options}
		],
		(* - Option Resolution Tests - *)
		Example[{Options, MolecularWeightRange, "When MolecularWeightRange->Automatic and the Ladder is set to one of the default Ladder Models, the option resolves based on the input Ladder:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Ladder -> Model[Sample, StockSolution, "Simple Western Biotinylated Ladder Solution (MW 2-40 kDa) - EZ Standard Pack 5"], Output -> Options];
			Lookup[options, MolecularWeightRange],
			LowMolecularWeight,
			Variables :> {options}
		],
		Example[{Options, MolecularWeightRange, "When MolecularWeightRange->Automatic and the Ladder is not set to one of the default Ladder Models, the option resolves to MidMolecularWeight:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Output -> Options];
			Lookup[options, MolecularWeightRange],
			MidMolecularWeight,
			Variables :> {options}
		],
		Example[{Options, Denaturing, "When Denaturing->Automatic, the option resolves to True unless either DenaturingTemperature, DenaturingTime, or Denaturant is set to Null:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Output -> Options];
			Lookup[options, Denaturing],
			True,
			Variables :> {options}
		],
		Example[{Options, Denaturing, "When Denaturing->Automatic, the option resolves to False if either DenaturingTemperature or DenaturingTime, or Denaturant is set to Null:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], DenaturingTime -> Null, Output -> Options];
			Lookup[options, Denaturing],
			False,
			Variables :> {options}
		],
		Example[{Options, Denaturing, "When Denaturing->Automatic, the option resolves to False if either DenaturingTemperature or DenaturingTime, or Denaturant is set to Null:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Denaturant -> Null, Output -> Options];
			Lookup[options, Denaturing],
			False,
			Variables :> {options}
		],
		Example[{Options, DenaturingTemperature, "When DenaturingTemperature->Automatic, the option resolves to Null if Denaturing is False:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Denaturing -> False, Output -> Options];
			Lookup[options, DenaturingTemperature],
			Null,
			Variables :> {options}
		],
		Example[{Options, DenaturingTemperature, "When DenaturingTemperature->Automatic, the option resolves to 95 Celsius if Denaturing is True:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Denaturing -> True, Output -> Options];
			Lookup[options, DenaturingTemperature],
			95 * Celsius,
			Variables :> {options}
		],
		Example[{Options, DenaturingTime, "When DenaturingTime->Automatic, the option resolves to Null if Denaturing is False:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Denaturing -> False, Output -> Options];
			Lookup[options, DenaturingTime],
			Null,
			Variables :> {options}
		],
		Example[{Options, DenaturingTime, "When DenaturingTime->Automatic, the option resolves to 5 minutes if Denaturing is True:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Denaturing -> True, Output -> Options];
			Lookup[options, DenaturingTime],
			5 * Minute,
			Variables :> {options}
		],
		Example[{Options, Ladder, "When Ladder->Automatic, the option resolves based on the ConcentratedLoadingBuffer:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], ConcentratedLoadingBuffer -> Model[Sample, StockSolution, "Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 29 kDa System Control - EZ Standard Pack 1"], Output -> Options];
			Lookup[options, Ladder],
			ObjectReferenceP[Model[Sample, StockSolution, "Simple Western Biotinylated Ladder Solution (MW 12-230 kDa) - EZ Standard Pack 1"]],
			Variables :> {options}
		],
		Example[{Options, Ladder, "When Ladder->Automatic, the option resolves based on the ConcentratedLoadingBuffer:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], ConcentratedLoadingBuffer -> Model[Sample, StockSolution, "Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 180 kDa System Control - EZ Standard Pack 2"], Output -> Options];
			Lookup[options, Ladder],
			ObjectReferenceP[Model[Sample, StockSolution, "Simple Western Biotinylated Ladder Solution (MW 12-230 kDa) - EZ Standard Pack 2"]],
			Variables :> {options}
		],
		Example[{Options, Ladder, "When Ladder->Automatic, the option resolves based on the MolecularWeightRange option if the ConcentratedLoadingBuffer is left as Automatic or is not one of the standard loading buffers:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], MolecularWeightRange -> LowMolecularWeight, Output -> Options];
			Lookup[options, Ladder],
			ObjectReferenceP[Model[Sample, StockSolution, "Simple Western Biotinylated Ladder Solution (MW 2-40 kDa) - EZ Standard Pack 5"]],
			Variables :> {options}
		],
		Example[{Options, Ladder, "When Ladder->Automatic, the option resolves based on the MolecularWeightRange option if the ConcentratedLoadingBuffer is left as Automatic or is not one of the standard loading buffers:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], MolecularWeightRange -> MidMolecularWeight, Output -> Options];
			Lookup[options, Ladder],
			ObjectReferenceP[Model[Sample, StockSolution, "Simple Western Biotinylated Ladder Solution (MW 12-230 kDa) - EZ Standard Pack 1"]],
			Variables :> {options}
		],
		Example[{Options, Ladder, "When Ladder->Automatic, the option resolves based on the MolecularWeightRange option if the ConcentratedLoadingBuffer is left as Automatic or is not one of the standard loading buffers:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], MolecularWeightRange -> HighMolecularWeight, Output -> Options];
			Lookup[options, Ladder],
			ObjectReferenceP[Model[Sample, StockSolution, "Simple Western Biotinylated Ladder Solution (MW 66-440 kDa) - EZ Standard Pack 3"]],
			Variables :> {options}
		],
		Example[{Options, StackingMatrixLoadTime, "When StackingMatrixLoadTime->Automatic, the option resolves to 15 seconds when the MolecularWeightRange is set to MidMolecularWeight:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], MolecularWeightRange -> MidMolecularWeight, Output -> Options];
			Lookup[options, StackingMatrixLoadTime],
			15 * Second,
			Variables :> {options}
		],
		Example[{Options, StackingMatrixLoadTime, "When StackingMatrixLoadTime->Automatic, the option resolves to 12 seconds when the MolecularWeightRange is set to anything other than MidMolecularWeight:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], MolecularWeightRange -> LowMolecularWeight, Output -> Options];
			Lookup[options, StackingMatrixLoadTime],
			12 * Second,
			Variables :> {options}
		],
		Example[{Options, SampleLoadTime, "When SampleLoadTime->Automatic, the option resolves to 8 seconds when the MolecularWeightRange is set to HighMolecularWeight:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], MolecularWeightRange -> HighMolecularWeight, Output -> Options];
			Lookup[options, SampleLoadTime],
			8 * Second,
			Variables :> {options}
		],
		Example[{Options, SampleLoadTime, "When SampleLoadTime->Automatic, the option resolves to 9 seconds when the MolecularWeightRange is set to anything other than HighMolecularWeight:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], MolecularWeightRange -> MidMolecularWeight, Output -> Options];
			Lookup[options, SampleLoadTime],
			9 * Second,
			Variables :> {options}
		],
		Example[{Options, Voltage, "When Voltage->Automatic, the option resolves to 475 volts when the MolecularWeightRange is set to HighMolecularWeight:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], MolecularWeightRange -> HighMolecularWeight, Output -> Options];
			Lookup[options, Voltage],
			475 * Volt,
			Variables :> {options}
		],
		Example[{Options, Voltage, "When Voltage->Automatic, the option resolves to 375 volts when the MolecularWeightRange is set to anything other than HighMolecularWeight:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], MolecularWeightRange -> MidMolecularWeight, Output -> Options];
			Lookup[options, Voltage],
			375 * Volt,
			Variables :> {options}
		],
		Example[{Options, SeparationTime, "When SeparationTime->Automatic, the option resolves to 1,800 seconds when the MolecularWeightRange is set to HighMolecularWeight:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], MolecularWeightRange -> HighMolecularWeight, Output -> Options];
			Lookup[options, SeparationTime],
			1800 * Second,
			Variables :> {options}
		],
		Example[{Options, SeparationTime, "When SeparationTime->Automatic, the option resolves to 1,500 seconds when the MolecularWeightRange is set to MidMolecularWeight:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], MolecularWeightRange -> MidMolecularWeight, Output -> Options];
			Lookup[options, SeparationTime],
			1500 * Second,
			Variables :> {options}
		],
		Example[{Options, SeparationTime, "When SeparationTime->Automatic, the option resolves to 1,620 second when the MolecularWeightRange is set to LowMolecularWeight:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], MolecularWeightRange -> LowMolecularWeight, Output -> Options];
			Lookup[options, SeparationTime],
			1620 * Second,
			Variables :> {options}
		],
		Example[{Options, UVExposureTime, "When UVExposureTime->Automatic, the option resolves to 150 seconds when the MolecularWeightRange is set to HighMolecularWeight:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], MolecularWeightRange -> HighMolecularWeight, Output -> Options];
			Lookup[options, UVExposureTime],
			150 * Second,
			Variables :> {options}
		],
		Example[{Options, UVExposureTime, "When UVExposureTime->Automatic, the option resolves to 200 seconds when the MolecularWeightRange is set to anything other than HighMolecularWeight:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], MolecularWeightRange -> MidMolecularWeight, Output -> Options];
			Lookup[options, UVExposureTime],
			200 * Second,
			Variables :> {options}
		],
		Example[{Options, ConcentratedLoadingBuffer, "When ConcentratedLoadingBuffer->Automatic, the option resolves based on the Ladder:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Ladder -> Model[Sample, StockSolution, "Simple Western Biotinylated Ladder Solution (MW 12-230 kDa) - EZ Standard Pack 1"], Output -> Options];
			Lookup[options, ConcentratedLoadingBuffer],
			ObjectReferenceP[Model[Sample, StockSolution, "Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 29 kDa System Control - EZ Standard Pack 1"]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedLoadingBuffer, "When ConcentratedLoadingBuffer->Automatic, the option resolves based on the Ladder:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Ladder -> Model[Sample, StockSolution, "Simple Western Biotinylated Ladder Solution (MW 66-440 kDa) - EZ Standard Pack 3"], Output -> Options];
			Lookup[options, ConcentratedLoadingBuffer],
			ObjectReferenceP[Model[Sample, StockSolution, "Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 90 kDa System Control - EZ Standard Pack 3"]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedLoadingBuffer, "When ConcentratedLoadingBuffer->Automatic, the option resolves based on the Ladder:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Ladder -> Model[Sample, StockSolution, "Simple Western Biotinylated Ladder Solution (MW 2-40 kDa) - EZ Standard Pack 5"], Output -> Options];
			Lookup[options, ConcentratedLoadingBuffer],
			ObjectReferenceP[Model[Sample, StockSolution, "Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 26 kDa System Control - EZ Standard Pack 5"]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedLoadingBuffer, "When ConcentratedLoadingBuffer->Automatic, the option resolves based on the MolecularWeightRange option if the Ladder option is left as Automatic or is not one of the standard ladders:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], MolecularWeightRange -> LowMolecularWeight, Output -> Options];
			Lookup[options, ConcentratedLoadingBuffer],
			ObjectReferenceP[Model[Sample, StockSolution, "Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 26 kDa System Control - EZ Standard Pack 5"]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedLoadingBuffer, "When ConcentratedLoadingBuffer->Automatic, the option resolves based on the MolecularWeightRange option if the Ladder option is left as Automatic or is not one of the standard ladders:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], MolecularWeightRange -> MidMolecularWeight, Output -> Options];
			Lookup[options, ConcentratedLoadingBuffer],
			ObjectReferenceP[Model[Sample, StockSolution, "Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 29 kDa System Control - EZ Standard Pack 1"]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedLoadingBuffer, "When ConcentratedLoadingBuffer->Automatic, the option resolves based on the MolecularWeightRange option if the Ladder option is left as Automatic or is not one of the standard ladders:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], MolecularWeightRange -> HighMolecularWeight, Output -> Options];
			Lookup[options, ConcentratedLoadingBuffer],
			ObjectReferenceP[Model[Sample, StockSolution, "Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 90 kDa System Control - EZ Standard Pack 3"]],
			Variables :> {options}
		],
		Example[{Options, Denaturant, "When Denaturant->Automatic, and Denaturaing is set to or has resolved to True, the option resolves based on the ConcentratedLoadingBuffer:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Denaturing -> True, ConcentratedLoadingBuffer -> Model[Sample, StockSolution, "Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 180 kDa System Control - EZ Standard Pack 2"], Output -> Options];
			Lookup[options, Denaturant],
			ObjectReferenceP[Model[Sample, StockSolution, "Simple Western 400 mM DTT - EZ Standard Pack 2"]],
			Variables :> {options}
		],
		Example[{Options, Denaturant, "When Denaturant->Automatic, and Denaturaing is set to or has resolved to True, the option resolves based on the ConcentratedLoadingBuffer:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Denaturing -> True, ConcentratedLoadingBuffer -> Model[Sample, StockSolution, "Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 200 kDa System Control - EZ Standard Pack 4"], MolecularWeightRange -> HighMolecularWeight, Output -> Options];
			Lookup[options, Denaturant],
			ObjectReferenceP[Model[Sample, StockSolution, "Simple Western 400 mM DTT - EZ Standard Pack 4"]],
			Variables :> {options}
		],
		Example[{Options, Denaturant, "When Denaturant->Automatic, and Denaturaing is set to or has resolved to True, the option resolves based on the MolecularWeightRange if the ConcentratedLoadingBuffer is left as Automatic:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Denaturing -> True, ConcentratedLoadingBuffer -> Automatic, MolecularWeightRange -> MidMolecularWeight, Output -> Options];
			Lookup[options, Denaturant],
			ObjectReferenceP[Model[Sample, StockSolution, "Simple Western 400 mM DTT - EZ Standard Pack 1"]],
			Variables :> {options}
		],
		Example[{Options, Denaturant, "When Denaturant->Automatic, the option resolves to Null if Denaturing is set to False:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Denaturing -> False, Output -> Options];
			Lookup[options, Denaturant],
			Null,
			Variables :> {options}
		],
		Example[{Options, DenaturantVolume, "When DenaturantVolume->Automatic, the option resolves to 40 uL when the Denaturant is not Null:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Denaturant -> Model[Sample, StockSolution, "Simple Western 400 mM DTT - EZ Standard Pack 1"], Output -> Options];
			Lookup[options, DenaturantVolume],
			40 * Microliter,
			Variables :> {options}
		],
		Example[{Options, DenaturantVolume, "When DenaturantVolume->Automatic, the option resolves to Null when the Denaturant is set to or has resolved to Null:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Denaturant -> Null, Output -> Options];
			Lookup[options, DenaturantVolume],
			Null,
			Variables :> {options}
		],
		Example[{Options, WaterVolume, "When WaterVolume->Automatic, the option resolves to 40 uL when Denaturing is set to False:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Denaturing -> False, Output -> Options];
			Lookup[options, WaterVolume],
			40 * Microliter,
			Variables :> {options}
		],
		Example[{Options, WaterVolume, "When WaterVolume->Automatic, the option resolves to Null when Denaturing is set to True:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Denaturing -> True, Output -> Options];
			Lookup[options, WaterVolume],
			Null,
			Variables :> {options}
		],
		Example[{Options, Name, "Name the protocol for TotalProteinDetection:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Name -> "Super cool test protocol", Output -> Options];
			Lookup[options, Name],
			"Super cool test protocol",
			Variables :> {options}
		],
		Example[{Options, Template, "Inherit options from a previously run protocol:"},
			options = Quiet[ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Template -> Object[Protocol, TotalProteinDetection, "Test TotalProteinDetection option template protocol" <> $SessionUUID], Output -> Options], Warning::InstrumentUndergoingMaintenance];
			Lookup[options, Instrument],
			Object[Instrument, Western, "id:Z1lqpMGje9p5"],
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureVolume, "Indicates if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], MeasureVolume -> True, Output -> Options];
			Lookup[options, MeasureVolume],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureWeight, "Indicates if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], MeasureWeight -> True, Output -> Options];
			Lookup[options, MeasureWeight],
			True,
			Variables :> {options}
		],
		Example[{Options, SamplesInStorageCondition, "Indicates how the input samples of the experiment should be stored:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], SamplesInStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, SamplesInStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		(* --- Sample Prep unit tests --- *)
		Example[{Options, PreparatoryPrimitives, "Specify prepared samples to be run on a capillary-based total protein detection assay:"},
			options = ExperimentTotalProteinDetection["Lysate Container",
				PreparatoryPrimitives -> {
					Define[
						Name -> "Lysate Container",
						Container -> Model[Container, Vessel, "id:3em6Zv9NjjN8"]
					],
					Transfer[
						Source -> Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
						Amount -> 50 * Microliter,
						Destination -> {"Lysate Container", "A1"}
					]
				},
				Output -> Options
			];
			Lookup[options, MolecularWeightRange],
			MidMolecularWeight,
			Variables :> {options}
		],
		Example[{Options, PreparatoryUnitOperations, "Specify prepared samples to be run on a capillary-based total protein detection assay:"},
			options = ExperimentTotalProteinDetection["Lysate Container",
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "Lysate Container",
						Container -> Model[Container, Vessel, "id:3em6Zv9NjjN8"]
					],
					Transfer[
						Source -> Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
						Amount -> 50 * Microliter,
						Destination -> "Lysate Container"
					]
				},
				Output -> Options
			];
			Lookup[options, MolecularWeightRange],
			MidMolecularWeight,
			Variables :> {options}
		],
		(* THIS TEST IS BRUTAL BUT DO NOT REMOVE IT. MAKE SURE YOUR FUNCTION DOESN'T BUG ON THIS. *)
		Example[{Additional, "Use the sample preparation options to prepare samples before the main experiment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Incubate -> True, Centrifuge -> True, Filtration -> True, Aliquot -> True, Output -> Options];
			{Lookup[options, Incubate], Lookup[options, Centrifuge], Lookup[options, Filtration], Lookup[options, Aliquot]},
			{True, True, True, True},
			Variables :> {options},
			TimeConstraint -> 240
		],
		(* ExperimentIncubate tests. *)
		Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], IncubationTemperature -> 40 * Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40 * Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], IncubationTime -> 40 * Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], MaxIncubationTime -> 40 * Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		(* Note: This test requires your sample to be in some type of 50mL tube or 96-well plate. Definitely not bigger than a 250mL bottle. *)
		Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], IncubationInstrument -> Model[Instrument, HeatBlock, "id:WNa4ZjRDVw64"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument, HeatBlock, "id:WNa4ZjRDVw64"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], AnnealingTime -> 40 * Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], IncubateAliquot -> 0.5 * Milliliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			0.5 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],

		Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		(* Note: You CANNOT be in a plate for the following test. *)
		Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], MixType -> Shake, Output -> Options];
			Lookup[options, MixType],
			Shake,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],
		(* ExperimentCentrifuge *)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		(* Note: Put your sample in a 2mL tube for the following test. *)
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Microfuge 16"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], CentrifugeIntensity -> 1000 * RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000 * RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		(* Note: CentrifugeTime cannot go above 5Minute without restricting the types of centrifuges that can be used. *)
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], CentrifugeTime -> 5 * Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			5 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], CentrifugeTemperature -> 30 * Celsius, CentrifugeAliquotContainer -> Model[Container, Vessel, "50mL Tube"], AliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeTemperature],
			30 * Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], CentrifugeAliquot -> 0.5 * Milliliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			0.5 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		(* filter options *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Filter -> Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Available test 25 mL water sample in a 50mL tube for ExperimentTotalProteinDetection" <> $SessionUUID], FilterMaterial -> PES, FilterContainerOut -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Available test 25 mL water sample in a 50mL tube for ExperimentTotalProteinDetection" <> $SessionUUID], PrefilterMaterial -> GxF, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Available test 25 mL water sample in a 50mL tube for ExperimentTotalProteinDetection" <> $SessionUUID], FilterPoreSize -> 0.22 * Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22 * Micrometer,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Available test 25 mL water sample in a 50mL tube for ExperimentTotalProteinDetection" <> $SessionUUID], PrefilterPoreSize -> 1. * Micrometer, FilterMaterial -> PTFE, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1. * Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Available test 25 mL water sample in a 50mL tube for ExperimentTotalProteinDetection" <> $SessionUUID], FiltrationType -> PeristalticPump, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], Output -> Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000 * RPM, Output -> Options];
			Lookup[options, FilterIntensity],
			1000 * RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20 * Minute, Output -> Options];
			Lookup[options, FilterTime],
			20 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTemperature -> 10 * Celsius, Output -> Options];
			Lookup[options, FilterTemperature],
			10 * Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options},
			Messages :> {
				Warning::AliquotRequired
			}
		],
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], FilterAliquot -> 0.5 * Milliliter, Output -> Options];
			Lookup[options, FilterAliquot],
			0.5 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		(* aliquot options *)
		Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Aliquot -> True, Output -> Options];
			Lookup[options, Aliquot],
			True,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], AliquotAmount -> 0.5 * Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.5 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], AssayVolume -> 0.5 * Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.5 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "10 kDa test protein sample for ExperimentTotalProteinDetection" <> $SessionUUID], TargetConcentration -> 5.5 * Micromolar, Output -> Options];
			Lookup[options, TargetConcentration],
			5.5 * Micromolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "Set the TargetConcentrationAnalyte option:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "10 kDa test protein sample for ExperimentTotalProteinDetection" <> $SessionUUID], TargetConcentration -> 5.5 * Micromolar, TargetConcentrationAnalyte -> Model[Molecule, Protein, "Test 10 kDa Model[Molecule,Protein] for ExperimentTotalProteinDetection Tests" <> $SessionUUID], Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectReferenceP[Model[Molecule, Protein, "Test 10 kDa Model[Molecule,Protein] for ExperimentTotalProteinDetection Tests" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				ConcentratedBuffer -> Model[Sample, StockSolution, "Simple Western 0.1X Sample Buffer"],
				BufferDilutionFactor -> 2,
				BufferDiluent -> Model[Sample, "Milli-Q water"],
				AliquotAmount -> 0.2 * Milliliter,
				AssayVolume -> 0.5 * Milliliter,
				Output -> Options
			];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "Simple Western 0.1X Sample Buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, "Simple Western 10X Sample Buffer"],
				BufferDiluent -> Model[Sample, "Milli-Q water"],
				AliquotAmount -> 0.1 * Milliliter,
				AssayVolume -> 0.8 * Milliliter,
				Output -> Options
			];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				BufferDiluent -> Model[Sample, "Milli-Q water"],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, "Simple Western 10X Sample Buffer"],
				AliquotAmount -> 0.2 * Milliliter,
				AssayVolume -> 0.8 * Milliliter,
				Output -> Options
			];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "Simple Western 0.1X Sample Buffer"], AliquotAmount -> 0.2 * Milliliter, AssayVolume -> 0.8 * Milliliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "Simple Western 0.1X Sample Buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], AliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, AliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotDestinationWell, "Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], IncubateAliquotDestinationWell -> "A1", AliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotDestinationWell, "Indicates the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], CentrifugeAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options, CentrifugeAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],
		Example[{Options, FilterAliquotDestinationWell, "Indicates the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], FilterAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options, FilterAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],
		Example[{Options, DestinationWell, "Indicates the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentTotalProteinDetection[Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID], DestinationWell -> "A1", Output -> Options];
			Lookup[options, DestinationWell],
			"A1",
			Variables :> {options}
		]
	},
	Parallel -> True,
	SetUp :> (
		Off[Warning::SamplesOutOfStock];
		$CreatedObjects = {}),
	TearDown :> (
		On[Warning::SamplesOutOfStock];
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		(* Turn off the SamplesOutOfStock warning for unit tests *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjects, existsFilter},
			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects = {
				Object[Container, Vessel, "Test 2mL Tube 1 containing lysate sample for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 2 for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 3 for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 4 for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 5 for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 6 for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 7 for ExperimentTotalProteinDetection" <> $SessionUUID],

				Object[Instrument, Western, "Test Wes Instrument for ExperimentTotalProteinDetection Tests" <> $SessionUUID],

				Model[Molecule, Protein, "Test 10 kDa Model[Molecule,Protein] for ExperimentTotalProteinDetection Tests" <> $SessionUUID],

				Object[Container, Vessel, "Test 50mL Tube with 25mL water sample inside for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Test discarded lysate sample for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Test 1 mL lysate sample, TotalProteinConcentration not informed for ExperimentTotalProteinDetection" <> $SessionUUID],
				Model[Sample, "10 kDa test protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "10 kDa test protein sample for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Test 1 mL lysate sample, 5 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Available test 25 mL water sample in a 50mL tube for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Test 1 mL lysate sample, 0.5 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Test Modelless 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Protocol, TotalProteinDetection, "Test TotalProteinDetection option template protocol" <> $SessionUUID]
			};

			(* Erase any objects that we failed to erase in the last unit test *)
			existsFilter = DatabaseMemberQ[allObjects];

			Quiet[EraseObject[
				PickList[allObjects, existsFilter],
				Force -> True,
				Verbose -> False
			]];
		];
		Module[
			{
				emptyContainer1, emptyContainer2, emptyContainer3, emptyContainer4, emptyContainer5, emptyContainer6, emptyContainer7, emptyContainer8, fakeInstrument,
				availableLysateSample, discardedLysateSample, availableLysateSampleNoTotal, proteinSample10kDa, tooConcLysate, waterSample, lysateSample2, modellessSample
			},
			(* Create some empty containers, and a fake Instrument *)
			{emptyContainer1, emptyContainer2, emptyContainer3, emptyContainer4, emptyContainer5, emptyContainer6, emptyContainer7, emptyContainer8, fakeInstrument} = Upload[{
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"], Objects],
					Name -> "Test 2mL Tube 1 containing lysate sample for ExperimentTotalProteinDetection" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"], Objects],
					Name -> "Test 2mL Tube 2 for ExperimentTotalProteinDetection" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"], Objects],
					Name -> "Test 2mL Tube 3 for ExperimentTotalProteinDetection" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"], Objects],
					Name -> "Test 2mL Tube 4 for ExperimentTotalProteinDetection" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"], Objects],
					Name -> "Test 2mL Tube 5 for ExperimentTotalProteinDetection" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:bq9LA0dBGGR6"], Objects],
					Name -> "Test 50mL Tube with 25mL water sample inside for ExperimentTotalProteinDetection" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"], Objects],
					Name -> "Test 2mL Tube 6 for ExperimentTotalProteinDetection" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"], Objects],
					Name -> "Test 2mL Tube 7 for ExperimentTotalProteinDetection" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Instrument, Western],
					Model -> Link[Model[Instrument, Western, "Wes"], Objects],
					Name -> "Test Wes Instrument for ExperimentTotalProteinDetection Tests" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>
			}];

			(* Create a test Model[Molecule,Protein] to populate the Composition field of the test protein input for the TargetConcentration unit test *)
			Upload[
				<|
					Type -> Model[Molecule, Protein],
					Name -> "Test 10 kDa Model[Molecule,Protein] for ExperimentTotalProteinDetection Tests" <> $SessionUUID,
					MolecularWeight -> 10 * (Kilogram / Mole),
					DeveloperObject -> True
				|>
			];

			(* Create test protein Models *)
			Upload[{
				<|
					Type -> Model[Sample],
					Name -> "10 kDa test protein for ExperimentTotalProteinDetection" <> $SessionUUID,
					Replace[Authors] -> {Link[Object[User, Emerald, Developer, "spencer.clark"]]},
					DeveloperObject -> True,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
					Replace[Composition] -> {
						{20 * Micromolar, Link[Model[Molecule, Protein, "Test 10 kDa Model[Molecule,Protein] for ExperimentTotalProteinDetection Tests" <> $SessionUUID]]},
						{100 * VolumePercent, Link[Model[Molecule, "Water"]]}
					}
				|>
			}];

			(* Create some samples for testing purposes *)
			{availableLysateSample, discardedLysateSample, availableLysateSampleNoTotal, proteinSample10kDa, tooConcLysate, waterSample, lysateSample2, modellessSample} = UploadSample[
				{
					Model[Sample, "id:WNa4ZjKMrPeD"],
					Model[Sample, "id:WNa4ZjKMrPeD"],
					Model[Sample, "id:WNa4ZjKMrPeD"],
					Model[Sample, "10 kDa test protein for ExperimentTotalProteinDetection" <> $SessionUUID],
					Model[Sample, "id:WNa4ZjKMrPeD"],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "id:WNa4ZjKMrPeD"],
					Model[Sample, "id:WNa4ZjKMrPeD"]
				},
				{
					{"A1", emptyContainer1},
					{"A1", emptyContainer2},
					{"A1", emptyContainer3},
					{"A1", emptyContainer4},
					{"A1", emptyContainer5},
					{"A1", emptyContainer6},
					{"A1", emptyContainer7},
					{"A1", emptyContainer8}
				},
				Name -> {
					"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID,
					"Test discarded lysate sample for ExperimentTotalProteinDetection" <> $SessionUUID,
					"Test 1 mL lysate sample, TotalProteinConcentration not informed for ExperimentTotalProteinDetection" <> $SessionUUID,
					"10 kDa test protein sample for ExperimentTotalProteinDetection" <> $SessionUUID,
					"Test 1 mL lysate sample, 5 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID,
					"Available test 25 mL water sample in a 50mL tube for ExperimentTotalProteinDetection" <> $SessionUUID,
					"Test 1 mL lysate sample, 0.5 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID,
					"Test Modelless 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID
				}
			];

			(* Make a test protocol for the Template option unit test *)
			Upload[
				{
					<|
						Type -> Object[Protocol, TotalProteinDetection],
						DeveloperObject -> True,
						Name -> "Test TotalProteinDetection option template protocol" <> $SessionUUID,
						ResolvedOptions -> {Instrument -> Object[Instrument, Western, "id:Z1lqpMGje9p5"]},
						Site -> Link[$Site]
					|>
				}
			];

			(* Make some changes to our samples for testing purposes *)
			Upload[{
				<|Object -> availableLysateSample, Status -> Available, DeveloperObject -> True, Volume -> 1 * Milliliter, TotalProteinConcentration -> 0.25 * Milligram / Milliliter|>,
				<|Object -> discardedLysateSample, Status -> Discarded, DeveloperObject -> True, Volume -> 1 * Milliliter, TotalProteinConcentration -> 0.25 * Milligram / Milliliter|>,
				<|Object -> availableLysateSampleNoTotal, Status -> Available, DeveloperObject -> True, Volume -> 1 * Milliliter|>,
				<|Object -> proteinSample10kDa, Status -> Available, DeveloperObject -> True, Volume -> 1 * Milliliter, Concentration -> 11 * Micromolar|>,
				<|Object -> tooConcLysate, Status -> Available, DeveloperObject -> True, Volume -> 1 * Milliliter, TotalProteinConcentration -> 5 * Milligram / Milliliter|>,
				<|Object -> waterSample, Status -> Available, DeveloperObject -> True, Volume -> 25 * Milliliter|>,
				<|Object -> lysateSample2, Status -> Available, DeveloperObject -> True, Volume -> 1 * Milliliter, TotalProteinConcentration -> 0.5 * Milligram / Milliliter|>,
				<|Object -> modellessSample, Status -> Available, Model -> Null, DeveloperObject -> True, Volume -> 1 * Milliliter, TotalProteinConcentration -> 0.25 * Milligram / Milliliter|>
			}];
		];

	),

	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{allObjects, existsFilter},
			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects = {
				Object[Container, Vessel, "Test 2mL Tube 1 containing lysate sample for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 2 for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 3 for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 4 for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 5 for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 6 for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 7 for ExperimentTotalProteinDetection" <> $SessionUUID],

				Object[Instrument, Western, "Test Wes Instrument for ExperimentTotalProteinDetection Tests" <> $SessionUUID],

				Model[Molecule, Protein, "Test 10 kDa Model[Molecule,Protein] for ExperimentTotalProteinDetection Tests" <> $SessionUUID],

				Object[Container, Vessel, "Test 50mL Tube with 25mL water sample inside for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Test discarded lysate sample for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Test 1 mL lysate sample, TotalProteinConcentration not informed for ExperimentTotalProteinDetection" <> $SessionUUID],
				Model[Sample, "10 kDa test protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "10 kDa test protein sample for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Test 1 mL lysate sample, 5 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Available test 25 mL water sample in a 50mL tube for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Test 1 mL lysate sample, 0.5 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Sample, "Test Modelless 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetection" <> $SessionUUID],
				Object[Protocol, TotalProteinDetection, "Test TotalProteinDetection option template protocol" <> $SessionUUID]
			};

			(* Erase any objects that we failed to erase in the last unit test *)
			existsFilter = DatabaseMemberQ[allObjects];

			Quiet[EraseObject[
				PickList[allObjects, existsFilter],
				Force -> True,
				Verbose -> False
			]];
		];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];
