(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)

(* ::Subsection:: *)
(*ExperimentMeasureVolume*)

DefineTests[
	ExperimentMeasureVolume,
	{
		(* --- Basic Examples --- *)
		Example[{Basic,"Measure the volume of a single sample:"},
			ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID]],
			ObjectP[Object[Protocol,MeasureVolume]]
		],

		Example[{Basic,"Measure the volumes of multiple samples:"},
			ExperimentMeasureVolume[{Object[Sample,"Measure Volume Test Sample" <> $SessionUUID],Object[Sample,"Measure Volume Test Water Sample" <> $SessionUUID]}],
			ObjectP[Object[Protocol,MeasureVolume]]
		],

		Example[{Basic,"Measure the volumes of all samples in a container:"},
			ExperimentMeasureVolume[Object[Container,Plate,"Measure Volume Test Plate" <> $SessionUUID]],
			ObjectP[Object[Protocol,MeasureVolume]]
		],

		(* --- Option Resolution --- *)
		(* Method *)
		Example[{Options,Method,"Method controls which measurement technique and associated instruments are used to measure the sample's volume:"},
			Lookup[ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Water Sample" <> $SessionUUID], Method -> Ultrasonic, Output -> Options], Method],
			Ultrasonic
		],

		Example[{Options,Method,"Method will first try to default to Gravimetric if the sample has a density, and is in a tared container:"},
			Lookup[ExperimentMeasureVolume[sampleWithDensity1, Method -> Automatic, Output -> Options], Method],
			Gravimetric
		],

		Example[{Options,Method,"Method will then default to Ultrasonic if Gravimetric measurement isn't immediately possible:"},
			Lookup[ExperimentMeasureVolume[untaredTube, Method -> Automatic, Output -> Options], Method],
			Ultrasonic
		],

		(* MeasureDensity *)
		Example[{Options,MeasureDensity,"MeasureDensity controls whether the sample's density is measured by a MeasureDensity protocol prior to having its volume measured:"},
			Lookup[ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample No Density" <> $SessionUUID], MeasureDensity -> True, Output -> Options], MeasureDensity],
			True
		],

		(* MeasurementVolume *)
		Example[{Options,MeasurementVolume,"MeasurementVolume controls how much volume of sample will be weighed to determine a sample's density:"},
			Lookup[ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample No Density" <> $SessionUUID], MeasurementVolume -> 250 Microliter, MeasureDensity -> True, Output -> Options], MeasurementVolume],
			250 Microliter
		],

		(* ErrorTolerance *)
		Test["ErrorTolerance determines what's considered an acceptable percent difference between expected volume and measured volume:",
			Lookup[First[ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample No Density" <> $SessionUUID], ErrorTolerance -> 40*Percent, Upload -> False]], ErrorTolerance],
			40*Percent
		],

		(* RecoupSample *)
		Example[{Options,RecoupSample,"RecoupSample controls whether the material that is used to measure the sample's density is returned to its original container or disposed of:"},
			Lookup[ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample No Density" <> $SessionUUID], RecoupSample -> True, MeasureDensity -> True, Output -> Options],RecoupSample],
			True
		],

		(* SamplesInStorageCondition *)
		Example[{Options,SamplesInStorageCondition, "Indicates how the input samples of the experiment should be stored:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID],
				SamplesInStorageCondition -> Refrigerator,
				Output -> Options];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],

		(* --- Invalid Input Tests --- *)
		Example[{Messages,"DiscardedSamples","Discarded samples will cause Errors:"},
			ExperimentMeasureVolume[discardedChemical,Upload->False],
			$Failed,
			Messages:>{Error::DiscardedSamples,Error::InvalidInput}
		],

		Example[{Messages,"EmptyContainers","Empty containers will cause Errors:"},
			ExperimentMeasureVolume[emptyContainer,Upload->False],
			$Failed,
			Messages:>{Error::EmptyContainers(*,Error::InvalidInput*)(*This should be a thing though, should it not?*)}
		],

		Example[{Messages,"SolidSamplesNotAllowed","Solid samples cannot have their volume measured and will cause Errors:"},
			ExperimentMeasureVolume[solidSample,Upload->False],
			$Failed,
			Messages:>{Error::SolidSamplesUnsupported,Error::InvalidInput}
		],

		(* Parent Protocol *)
		Test["If ParentProtocol is provided, solid samples will not cause Errors, but will be ignored during protocol creation:",
			Download[
				ExperimentMeasureVolume[{solidSample,waterSample},ParentProtocol->Object[Protocol,SampleManipulation,"A test Parent Protocol for ExperimentMeasureVolume testing" <> $SessionUUID]],
				{Object,SamplesIn}
			],
			{
				ObjectP[Object[Protocol,MeasureVolume]],
				{ObjectP[waterSample]}
			}
		],
		Test["If ParentProtocol is a Qualification, solid samples will not cause Errors, but will be ignored during protocol creation:",
			Download[
				ExperimentMeasureVolume[{solidSample,waterSample},ParentProtocol->Object[Qualification,HPLC,"A test Parent Qualification for ExperimentMeasureVolume testing" <> $SessionUUID]],
				{Object,SamplesIn}
			],
			{
				ObjectP[Object[Protocol,MeasureVolume]],
				{ObjectP[waterSample]}
			}
		],
		Test["If ParentProtocol is provided and the SamplesIn provided is a chemical and stocksolution that must have their density measured, they will not be skipped:",
			Download[
				ExperimentMeasureVolume[{waterSample,Object[Sample,"Measure Volume Test Sample No Density" <> $SessionUUID]},ParentProtocol->Object[Protocol,SampleManipulation,"A test Parent Protocol for ExperimentMeasureVolume testing" <> $SessionUUID]],
				{Object,SamplesIn,DensityMeasurementSamples}
			],
			{
				ObjectP[Object[Protocol,MeasureVolume]],
				{ObjectP[waterSample],ObjectP[Object[Sample,"Measure Volume Test Sample No Density" <> $SessionUUID]]},
				{ObjectP[Object[Sample,"Measure Volume Test Sample No Density" <> $SessionUUID]]}
			}
		],

		(* --- Option Precision Tests --- *)
		Example[{Messages,"InstrumentPrecision","If MeasurementVolume is specified to a precision we cannot resolve in the lab, ExperimentMeasureVolume rounds the value and throws a warning:"},
			ExperimentMeasureVolume[waterSample, MeasurementVolume -> 75.0000000025 Microliter],
			ObjectP[Object[Protocol,MeasureVolume]],
			Messages:>{Warning::InstrumentPrecision}
		],

		(* --- Conflicting Option Tests --- *)
		(*Example[{Messages,"IgnoredOption","If MeasureDensity -> False, NumberOfMeasureDensityReplicates must be Null or Automatic or an Error is thrown:"},
			ExperimentMeasureVolume[{waterSample,waterSample}, MeasureDensity -> False, NumberOfMeasureDensityReplicates -> 5, Upload -> False],
			$Failed,
			Messages:>{Error::MeasureDensityReplicatesMismatch,Error::InvalidOption}
		],*)

		Test["If SamplesIn are in the same container, their SamplesInStorageCondition must be the same:",
			ExperimentMeasureVolume[
				{Object[Sample,"Test Plate Sample 1" <> $SessionUUID],Object[Sample,"Test Plate Sample 3" <> $SessionUUID]},
				SamplesInStorageCondition->{AmbientStorage,Freezer},
				Upload->False
			],
			$Failed,
			Messages:>{Error::SharedContainerStorageCondition,Error::InvalidOption}
		],
		Test["If MeasureDensity -> False, MeasurementVolume must be Null or Automatic or an Error is thrown:",
			ExperimentMeasureVolume[{waterSample,waterSample}, MeasureDensity -> False, MeasurementVolume -> 250 Microliter, Upload -> False],
			$Failed,
			Messages:>{Error::DensityMeasurementVolumeMismatch,Error::InvalidOption}
		],

		Test["If MeasureDensity -> False, RecoupSample must be Null or Automatic or an Error is thrown:",
			ExperimentMeasureVolume[{waterSample,waterSample}, MeasureDensity -> False, RecoupSample -> False, Upload -> False],
			$Failed,
			Messages:>{Error::DensityRecoupSampleMismatch,Error::InvalidOption}
		],

		(* Unresolvable Option Tests *)
		(* MeasureDensityRequired Error *)
		Example[{Messages,"MeasureDensityRequired","If Method -> Gravimetric, the sample has no Density and MeasureDensity -> False, an Error is thrown:"},
			ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample No Density" <> $SessionUUID], Method->Gravimetric, MeasureDensity -> False, Upload -> False],
			$Failed,
			Messages:>{Error::MeasureDensityRequired,Error::InvalidOption}
		],

		(* UnmeasurableDensity Error *)
		Example[{Messages,"InsufficientMeasureDensityVolume","If MeasureDensity -> True but the sample does not have ExpeirmentMeasureDensity's minimum volume requirement, an Error is thrown:"},
			ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample No Density And Low Volume" <> $SessionUUID], Method -> Gravimetric, MeasureDensity -> True, Upload -> False],
			$Failed,
			Messages:>{Error::InsufficientMeasureDensityVolume,Error::InvalidInput}
		],

		(* CentrifugeRecommended Warning *)
		Example[{Messages,"CentrifugeRecommended","If Method -> Ultrasonic but Centrifuge -> False, throw a Warning:"},
			ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Water Sample" <> $SessionUUID], Method -> Ultrasonic, Centrifuge -> False],
			ObjectP[Object[Protocol,MeasureVolume]],
			Messages:>{Warning::CentrifugeRecommended}
		],

		(* TODO The logic for what is/is not a centrifugeable container is not yet established in ExpMeasureVolume. Once it is, uncomment this
		(* NonCentrifugeableContainer Error *)
		Example[{Messages,"NonCentrifugeableContainer","If Centrifuge -> True but the sample is in a container that is not allowed by ExperimentCentrifuge, an Error is thrown:"},
			ExperimentMeasureVolume[nonCentrifugeableSample, Method->Ultrasonic, Upload->False],
			$Failed,
			Messages:>{Error::NonCentrifugeableContainer,Error::InvalidOptions}
		]
		*)

		(* SampleUltrasonicIncompatible Error *)
		Example[{Messages,"SampleUltrasonicIncompatible","If Method is set to Ultrasonic for UltrasonicIncompatible samples, an Error is thrown:"},
			ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Acetone Sample" <> $SessionUUID], Method -> Ultrasonic, Upload -> False],
			$Failed,
			Messages:>{Error::SampleUltrasonicIncompatible,Error::InvalidOption}
		],

		Example[{Messages,"UnmeasurableSample","If an UltrasonicIncompatible sample has a low volume that prevents it from being density measured, an Error is thrown:"},
			ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample No Density And Low Volume" <> $SessionUUID],Upload -> False],
			$Failed,
			Messages:>{Error::UnmeasurableSample,Error::InvalidInput}
		],

		(* UnmeasurableSample Error *)
		(* TODO There is exactly one way this could come up, but we currently have no models in the lab for it to arise. Create a model that..
			 TODO ..would cause this error then uncomment this
		Example[{Messages,"NonCentrifugeableContainer","If Centrifuge -> True but the sample is in a container that is not allowed by ExperimentCentrifuge, an Error is thrown:"},
			ExperimentMeasureVolume[unmeasurableSample, Method->Ultrasonic, Upload->False],
			$Failed,
			Messages:>{Error::NonCentrifugeableContainer,Error::InvalidOptions}
		]
		*)

		(* UnmeasurableContainer *)
(*
		Example[{Messages,"UnmeasurableContainer","If the sample is in a container that cannot be measured by the Method specified, an Error is thrown:"},
			ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample In Bad Container" <> $SessionUUID], Method -> Ultrasonic, Upload -> False],
			$Failed,
			Messages:>{Error::UnmeasurableContainer,Error::InvalidOption}
		],
*)

		Example[{Messages,"VolumeCalibrationsMissing","If a sample is in a plate that has no VolumeCalibration information, throw an UnmeasurableContainer error:"},
			ExperimentMeasureVolume[{Object[Sample,"MeasureVolume Sample in Plate Without Calibration" <> $SessionUUID],Object[Sample,"MeasureVolume Sample in Plate Without Calibration 2"<> $SessionUUID]}, Method -> Ultrasonic, Upload -> False],
			$Failed,
			Messages:>{Error::VolumeCalibrationsMissing,Error::InvalidInput}
		],
		Example[{Messages,"VolumeCalibrationsMissing","If a sample is in a plate that has no VolumeCalibration information, throw an UnmeasurableContainer error even if Method -> Automatic:"},
			ExperimentMeasureVolume[{Object[Sample,"MeasureVolume Sample in Plate Without Calibration" <> $SessionUUID],Object[Sample,"MeasureVolume Sample in Plate Without Calibration 2"<> $SessionUUID]}, Upload -> False],
			$Failed,
			Messages:>{Error::VolumeCalibrationsMissing,Error::InvalidInput}
		],
		(* TODO: Add a test for a sample in a plate that doesn't have a calibration *)
		Test["If a sample is in a plate and Method -> Gravimetric, throw an UnmeasurableContainer error:",
			ExperimentMeasureVolume[Object[Sample,"Test Plate Sample 1" <> $SessionUUID], Method -> Gravimetric, Upload -> False],
			$Failed,
			Messages:>{Error::UnmeasurableContainer,Error::InvalidOption}
		],
		Test["If a sample is in a plate and Method -> Gravimetric, throw an UnmeasurableContainer error (Plate with only one content):",
			ExperimentMeasureVolume[Object[Sample,"Test Plate Sample 2" <> $SessionUUID], Method -> Gravimetric, Upload -> False],
			$Failed,
			Messages:>{Error::UnmeasurableContainer,Error::InvalidOption}
		],
		(* --- Input Sample Filtering Testing --- *)
		Test["If given Discarded samples that do not have containers, don't explode with errors:",
			ExperimentMeasureVolume[{Object[Sample,"Measure Volume Test Water Sample" <> $SessionUUID],Object[Sample,"Test Discarded Sample No Container" <> $SessionUUID]}],
			$Failed,
			Messages:>{Error::DiscardedSamples,Error::InvalidInput}
		],
		Test["Silently removes any immobile containers if there is a parent protocol:",
			Download[
				ExperimentMeasureVolume[
					{Object[Container,Vessel,"Measure Volume Immobile Container"<> $SessionUUID],Object[Container,Vessel,"Measure Volume Non Immobile Container"<> $SessionUUID]},
					ParentProtocol->Object[Protocol,HPLC,"Parent Protocol for ExperimentMeasureVolume testing" <> $SessionUUID]
				],
				ContainersIn
			],
			{ObjectP[]},
			Messages:>{}
		],
		Example[{Messages,ImmobileSamples,"Immobile containers cannot have their volumes measured:"},
			ExperimentMeasureVolume[
				{Object[Container,Vessel,"Measure Volume Immobile Container 2" <> $SessionUUID],Object[Container,Vessel,"Measure Volume Non Immobile Container 2" <> $SessionUUID]}
			],
			$Failed,
			Messages:>{Error::ImmobileSamples,Error::InvalidInput}
		],

		(* --- FastTrack Option Testing --- *)
		Test["FastTrack allows the function to move past UltrasonicIncompatible that would otherwise halt progress when Method -> Ultrasonic:",
			{
				ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Acetone Sample" <> $SessionUUID],Method->Ultrasonic],
				ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Acetone Sample" <> $SessionUUID],Method->Ultrasonic,FastTrack->True]
			},
			{$Failed,ObjectP[Object[Protocol,MeasureVolume]]},
			Messages:>{Error::SampleUltrasonicIncompatible,Error::InvalidOption}
		],

		(* --- MeasureDensity Error Handling Testing --- *)
		Test["FastTrack allows the function to move past UltrasonicIncompatible that would otherwise halt progress when Method MUST default to Ultrasonic:",
			{
				ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Bad Sample" <> $SessionUUID],Method->Automatic],
				ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Bad Sample" <> $SessionUUID],Method->Automatic,FastTrack->True]
			},
			{$Failed,ObjectP[Object[Protocol,MeasureVolume]]},
			Messages:>{Error::UnmeasurableSample,Error::InvalidInput}
		],
		Test["Can successfully designate one sample for MeasureDensity and leave the rest as Ultrasonic:",
			Lookup[
				ExperimentMeasureVolume[
					{
						Object[Sample,"Measure Volume Test Sample No Density" <> $SessionUUID],
						Object[Sample,"Test Plate Sample 1" <> $SessionUUID],
						Object[Sample,"Test Plate Sample 2" <> $SessionUUID],
						Object[Sample,"Test Plate Sample 3" <> $SessionUUID]
					},
					MeasureDensity->{True,Automatic,Automatic,Automatic},
					Output -> Options
				],
				{MeasureDensity,(*NumberOfMeasureDensityReplicates,*)RecoupSample,MeasurementVolume}
			],
			{
			(* MeasureDensity *){True,False,False,False},
			(*(* Replicates *){_Integer,Null,Null,Null},*)
			(* RecoupSample *){BooleanP,Null,Null,Null},
			(* MeasurementVolume *){VolumeP,Null,Null,Null}
			}
		],
		Test["Mismatched MeasureDensity options cause errors:",
			ExperimentMeasureVolume[
				{
					Object[Sample,"Measure Volume Test Sample No Density" <> $SessionUUID],
					Object[Sample,"Test Plate Sample 1" <> $SessionUUID],
					Object[Sample,"Test Plate Sample 2" <> $SessionUUID],
					Object[Sample,"Test Plate Sample 3" <> $SessionUUID]
				},
				MeasureDensity -> {True,Automatic,Automatic,Automatic},(*
				NumberOfMeasureDensityReplicates->{Null,Null,Null,Null},*)
				RecoupSample -> {Null,Null,Null,Null},
				MeasurementVolume -> {Null,Null,Null,Null}
			],
			$Failed,
			Messages :> {(*Error::MeasureDensityReplicatesMismatch,*)Error::DensityRecoupSampleMismatch,Error::DensityMeasurementVolumeMismatch,Error::InvalidOption}
		],
		Test["If an input sample is provided twice, two readings of the sample will be taken in different batches:",
			Lookup[
				First@ExperimentMeasureVolume[
					{
						Object[Sample,"Measure Volume Test Water Sample" <> $SessionUUID],
						Object[Sample,"Measure Volume Test Water Sample" <> $SessionUUID],
						Object[Sample,"Measure Volume Test Sample In Tube Without Tare" <> $SessionUUID]
					},
					Method->Ultrasonic,
					Upload->False
				],
				{
					Replace[BatchLengths],
					Replace[BatchedContainerIndexes]
				}
			],
			{
				{2,1},
				{1,2,1}(*Working containers is duplicate free, so there will only be two containers in WorkingContainers after SamplePrep *)
			}
		],

		(* --- Sticky Rack Testing --- *)
		Test["Make sure sticky racks properly assign tubes to each other:",
			protObj = ExperimentMeasureVolume[{Object[Container,Vessel,"MeasureVolume Water Tube" <> $SessionUUID],Object[Container,Vessel,"MeasureVolume Water Tube2" <> $SessionUUID]},Method->Ultrasonic];
			Download[protObj,TubeRackPlacements],
			{
				{LinkP[Download[Object[Container,Vessel,"MeasureVolume Water Tube" <> $SessionUUID],Object]],LinkP[Download[Object[Container,Rack,"MeasureVolume Test Sticky Rack" <> $SessionUUID],Object]],"B1"},
				{LinkP[Download[Object[Container,Vessel,"MeasureVolume Water Tube2" <> $SessionUUID],Object]],LinkP[Download[Object[Container,Rack,"MeasureVolume Test Sticky Rack" <> $SessionUUID],Object]],"B2"}
			},
			Variables :> {protObj}
		],
		Test["Will generate partition batches of 2mL tubes into 48 containers per batch:",
			protObj = ExperimentMeasureVolume[myMV2mLTubes,Method->Ultrasonic];
			{myBatches,myResources} = Download[protObj,{BatchedMeasurementDevices,RequiredResources}];
			myTubeRackResources = Download[
				Cases[
					myResources,
					{_,BatchedMeasurementDevices,_,TubeRack}
				][[All,1]],
				Object
			];
			{Length[myBatches],DuplicateFreeQ[myTubeRackResources]},
			{2,True},
			Variables:>{protObj,myBatches,myResources,myTubeRackResources}
		],
		Test["Will generate unique resources for 2mL racks but consolidate 50mL rack resources:",
			protObj = ExperimentMeasureVolume[Join[myMV2mLTubes,{waterContainer2,waterContainer3}],Method->Ultrasonic];
			{myBatches,myResources} = Download[protObj,{BatchedMeasurementDevices,RequiredResources}];
			myTubeRackResources = Download[
				Cases[
					myResources,
					{_,BatchedMeasurementDevices,_,TubeRack}
				][[All,1]],
				Object
			];
			{Length[myBatches],Length[DeleteDuplicates[myTubeRackResources]],Download[protObj,BatchedContainerIndexes],Download[protObj,ContainersIn]},
			{3,3,_,_},
			Variables:>{protObj,myBatches,myResources,myTubeRackResources}
		],

		(* --- InSitu Testing --- *)
		Test["InSitu protocol will pick the TubeRack the tubes are in for its instrument resource:",
			protObj = ExperimentMeasureVolume[{Object[Container,Vessel,"MeasureVolume Water Tube" <> $SessionUUID],Object[Container,Vessel,"MeasureVolume Water Tube2" <> $SessionUUID]},InSitu->True];
			Download[protObj,BatchedMeasurementDevices[[All,TubeRack]][Object]],
			{Download[Object[Container,Rack,"MeasureVolume Test Sticky Rack" <> $SessionUUID],Object]},
			Variables :> {protObj}
		],
		Test["InSitu option will upload InSitu to the protocol object:",
			protObj = ExperimentMeasureVolume[{Object[Container,Vessel,"MeasureVolume Water Tube" <> $SessionUUID],Object[Container,Vessel,"MeasureVolume Water Tube2" <> $SessionUUID]},InSitu->True];
			Download[protObj,InSitu],
			True,
			Variables :> {protObj}
		],
		Test["InSitu protocol will pick the Instrument the tubes are in for its instrument resource:",
			protObj = ExperimentMeasureVolume[{Object[Container,Vessel,"MeasureVolume Water Tube" <> $SessionUUID],Object[Container,Vessel,"MeasureVolume Water Tube2" <> $SessionUUID]},InSitu->True];
			Download[protObj,BatchedMeasurementDevices[[All,LiquidLevelDetector]][Object]],
			{Download[Object[Instrument,LiquidLevelDetector,"MeasureVolume Test VolumeCheck" <> $SessionUUID],Object]},
			Variables :> {protObj}
		],
		Test["InSitu option causes an Error if a method that is incompatible with the samples' location is chosen:",
			ExperimentMeasureVolume[{Object[Container,Vessel,"MeasureVolume Water Tube" <> $SessionUUID],Object[Container,Vessel,"MeasureVolume Water Tube2" <> $SessionUUID]},InSitu->True,Method->Gravimetric],
			$Failed,
			Messages :> {Error::InvalidInSituMethod,Error::InvalidOption}
		],
		Test["InSitu option causes an Error if MeasureDensity is also requested:",
			ExperimentMeasureVolume[{Object[Container,Vessel,"MeasureVolume Water Tube" <> $SessionUUID],Object[Container,Vessel,"MeasureVolume Water Tube2" <> $SessionUUID]},InSitu->True,MeasureDensity->True],
			$Failed,
			Messages :> {Error::InvalidInSituMeasureDensity,Error::InvalidOption}
		],
		Test["InSitu option causes an Error if the samples location is not currently on an instrument:",
			ExperimentMeasureVolume[{Object[Sample,"Measure Volume Test Acetone Sample" <> $SessionUUID]},InSitu->True],
			$Failed,
			Messages :> {Error::InSituImpossible,Error::InvalidOption}
		],

		(* --- Test VolumeMeasurementDevices --- *)
		Test["VolumeMeasurementDevices properly selects instruments and containers from the container input:",
			VolumeMeasurementDevices[{Object[Container,Vessel,"MeasureVolume Water Tube" <> $SessionUUID],Object[Container,Vessel,"MeasureVolume Water Tube2" <> $SessionUUID]}],
			{
				Repeated[
					{ObjectP[{Object[Instrument],Model[Instrument],Object[Container],Model[Container]}]..},
					2
				]
			}
		],
		Test["VolumeMeasurementDevices properly selects instruments and containers from the sample input:",
			VolumeMeasurementDevices[{Object[Sample,"Test Plate Sample 1" <> $SessionUUID],Object[Sample,"Test Plate Sample 2" <> $SessionUUID],Object[Sample,"Test Plate Sample 3" <> $SessionUUID]}],
			{
				Repeated[
					{ObjectP[{Object[Instrument],Model[Instrument],Object[Container],Model[Container]}]..},
					3
				]
			}
		],

		(* --- Other Tests --- *)
		Test["Instruments is informed as a duplicate-free list:",
			protObj = ExperimentMeasureVolume[Join[myMV2mLTubes,{waterContainer3,waterContainer2,Object[Container,Plate,"Measure Volume Test Plate" <> $SessionUUID]}], Method->Ultrasonic];
			rawInsts = Download[protObj,Instruments];
			batchedInsts = Lookup[Download[protObj,BatchedMeasurementDevices],LiquidLevelDetector];
			{Length[rawInsts],Length[batchedInsts],Download[protObj,BatchedContainerIndexes],Download[protObj,ContainersIn]},
			{2,4,_,_},
			Variables :> {protObj,rawInsts,batchedInsts}
		],
		(* This experiment call previously generated the batch number order {1,2,4,3}. New grouping logic should put the batch numbers back in the correct order *)
		Test["Batch numbers are informed in the correct order:",
			(
				protObj = ExperimentMeasureVolume[Join[myMV2mLTubes,{waterContainer3,waterContainer2,Object[Container,Plate,"Measure Volume Test Plate" <> $SessionUUID]}], Method->Ultrasonic];
				batches = Download[protObj,BatchedMeasurementDevices];
				Lookup[batches,BatchNumber]
			),
			Range[Length[batches]],
			Variables :> {protObj,batches}
		],
		Test["If ParentProtocol is provided, samples in Ampoules will not cause Errors, but will be ignored during protocol creation:",
			Download[
				ExperimentMeasureVolume[{ampouleSamp,waterSample},ParentProtocol->Object[Protocol,SampleManipulation,"A test Parent Protocol for ExperimentMeasureVolume testing" <> $SessionUUID]],
				{Object,SamplesIn}
			],
			{
				ObjectP[Object[Protocol,MeasureVolume]],
				{ObjectP[waterSample]}
			}
		],
		Test["Even if a sample has no Density and is ultrasonic incompatible, it can still have its density measured if it's in a tared vessel:",
			Lookup[ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample No Density" <> $SessionUUID],Method->Automatic,Output->Options],{Method,MeasureDensity}],
			{Gravimetric,True}
		],
		Test["Works seemlessly on samples not tied to models:",
			ExperimentMeasureVolume[{Object[Sample,"MeasureVolume Model-less Sample1" <> $SessionUUID],Object[Sample,"MeasureVolume Model-less Sample2" <> $SessionUUID]}],
			ObjectP[Object[Protocol,MeasureVolume]]
		],
		Test["Informs Densities that will be used for converting gravimetric measurement into volume measurement:",
			Download[ExperimentMeasureVolume[{sampleWithDensity1,sampleWithDensity2}, Method -> Automatic], Densities],
			{DensityP..}
		],
		Test["Picks a tuberack and informs TubeRackPlacements for 0.5mL Tubes with 2mL skirt:",
			myProt=ExperimentMeasureVolume[Object[Container,Vessel,"MeasureVolume Test 0.5mL Tube" <> $SessionUUID],Method->Ultrasonic];
			{batchInfo,rackPlacements}=Download[myProt,{BatchedMeasurementDevices,TubeRackPlacements}];
			{
				(* Should have a model rack available for this 0.5mL tube *)
				Lookup[First[batchInfo],TubeRack],
				rackPlacements
			},
			{
				ObjectP[Model[Container,Rack]],
				{{ObjectP[Object[Container,Vessel]],ObjectP[Model[Container,Rack]],"A1"}}
			},
			Variables :> {myProt,batchInfo,rackPlacements}
		],
		Test["When provided with a non-volume checkable container whose model has no VolumeCalibrations field, it filters the out, does not throw an error, and returns $Failed:",
			ExperimentMeasureVolume[Object[Container,ProteinCapillaryElectrophoresisCartridge,"MeasureVolume Cartridge"<> $SessionUUID], ParentProtocol->Object[Protocol,HPLC,"Parent Protocol for ExperimentMeasureVolume testing" <> $SessionUUID]],
			$Failed
		],

		(* -------------------------------------------------------- *)
		(* -------------------------------------------------------- *)
		(* ------------ FUNTOPIA SHARED OPTION TESTING ------------ *)
		(* -------------------------------------------------------- *)
		(* -------------------------------------------------------- *)
		Example[{Options,PreparatoryPrimitives,"Transfer water to a tube and make sure the amount transfer matches what was requested:"},
			ExperimentMeasureVolume[
				"My 2mL Tube",
				PreparatoryPrimitives -> {
					Define[
						Name -> "My 2mL Tube",
						Container -> Model[Container, Vessel, "2mL Tube"]
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Destination -> "My 2mL Tube",
						Amount -> 1.75 Milliliter
					]
				},
				Method -> Gravimetric
			],
			ObjectP[Object[Protocol,MeasureVolume]]
		],
		Example[
			{Options,PreparatoryPrimitives,"Add ethanol to a 50 milliliter tube, fill to 45 milliliters with dH2O, and then measure the volume:"},
			ExperimentMeasureVolume[
				{"My 50mL Tube"},
				PreparatoryPrimitives -> {
					Define[
						Name -> "My 50mL Tube",
						Container -> Model[Container, Vessel, "50mL Tube"]
					],
					Transfer[
						Source -> {Model[Sample, "Ethanol, Reagent Grade"]},
						Destination -> "My 50mL Tube",
						Volume -> 7.5 Milliliter
					],
					FillToVolume[
						Source -> Model[Sample, "Milli-Q water"],
						FinalVolume -> 45 Milliliter,
						Destination -> "My 50mL Tube"
					],
					Mix[
						Sample -> "My 50mL Tube",
						MixType -> Vortex
					]
				}
			],
			ObjectP[Object[Protocol,MeasureVolume]]
		],
		Example[
			{Options,PreparatoryPrimitives,"Add a stocksolution to a bottle for preparation, then aliquot from it and measure the volume on those aliquots:"},
			ExperimentMeasureVolume[
				{"My 4L Bottle","My 4L Bottle","My 4L Bottle"},
				PreparatoryPrimitives -> {
					Define[
						Name -> "My 4L Bottle",
						Container -> Model[Container, Vessel, "Amber Glass Bottle 4 L"]
					],
					Transfer[
						Source -> {Model[Sample, StockSolution, "id:R8e1PjpR1k0n"]},
						Destination -> "My 4L Bottle",
						Volume -> 3.5 Liter
					]
				},
				Aliquot -> True,
				AssayVolume -> {45 Milliliter, 45 Milliliter, 1 Liter},
				AliquotContainer -> {
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "Amber Glass Bottle 4 L"]
				}
			],
			ObjectP[Object[Protocol,MeasureVolume]]
		],
		Example[{Options,PreparatoryUnitOperations,"Transfer water to a tube and make sure the amount transfer matches what was requested:"},
			ExperimentMeasureVolume[
				"My 2mL Tube",
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "My 2mL Tube",
						Container -> Model[Container, Vessel, "2mL Tube"]
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Destination -> "My 2mL Tube",
						Amount -> 1.75 Milliliter
					]
				},
				Method -> Gravimetric
			],
			ObjectP[Object[Protocol,MeasureVolume]]
		],
		Example[
			{Options,PreparatoryUnitOperations,"Add ethanol to a 50 milliliter tube, fill to 45 milliliters with dH2O, and then measure the volume:"},
			ExperimentMeasureVolume[
				{"My 50mL Tube"},
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "My 50mL Tube",
						Container -> Model[Container, Vessel, "50mL Tube"]
					],
					Transfer[
						Source -> {Model[Sample, "Ethanol, Reagent Grade"]},
						Destination -> "My 50mL Tube",
						Amount -> 7.5 Milliliter
					],
					FillToVolume[
						Sample -> "My 50mL Tube",
						Solvent -> Model[Sample, "id:8qZ1VWNmdLBD"],
						TotalVolume -> 45 Milliliter
					],
					Mix[
						Sample -> "My 50mL Tube",
						MixType -> Vortex
					]
				}
			],
			ObjectP[Object[Protocol,MeasureVolume]]
		],
		Example[
			{Options,PreparatoryUnitOperations,"Add a stocksolution to a bottle for preparation, then aliquot from it and measure the volume on those aliquots:"},
			ExperimentMeasureVolume[
				{"My 4L Bottle","My 4L Bottle","My 4L Bottle"},
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "My 4L Bottle",
						Container -> Model[Container, Vessel, "Amber Glass Bottle 4 L"]
					],
					Transfer[
						Source -> {Model[Sample, StockSolution, "id:o1k9jAGPOW1x"]},
						Destination -> "My 4L Bottle",
						Amount -> 3.5 Liter
					]
				},
				Aliquot -> True,
				AssayVolume -> {45 Milliliter, 45 Milliliter, 1 Liter},
				AliquotContainer -> {
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "Amber Glass Bottle 4 L"]
				}
			],
			ObjectP[Object[Protocol,MeasureVolume]]
		],
		Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], IncubationTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], IncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], MaxIncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], IncubationInstrument -> Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], AnnealingTime -> 40*Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], IncubateAliquot -> 1.5*Milliliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			1.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],

		Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], MixType -> Shake, Output -> Options];
			Lookup[options, MixType],
			Shake,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],

		(* ExperimentCentrifuge *)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Water Sample" <> $SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Microfuge 16"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Water Sample" <> $SessionUUID], CentrifugeTime -> 40*Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], CentrifugeTemperature -> 10*Celsius, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], CentrifugeAliquot -> 1.5*Milliliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			1.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],

		(* filter options *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filter prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Water Sample" <> $SessionUUID], Filter -> Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], FilterMaterial -> PES, Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], FilterMaterial -> PTFE, PrefilterMaterial -> GxF, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], FilterPoreSize -> 0.22*Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], FilterMaterial->PTFE, PrefilterPoreSize -> 1.*Micrometer, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Water Sample" <> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], FiltrationType -> PeristalticPump, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], Output -> Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Water Sample" <> $SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, FilterContainerOut -> Model[Container,Vessel,"2mL Tube"],Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Water Sample" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20*Minute, FilterContainerOut -> Model[Container,Vessel,"2mL Tube"],Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Water Sample" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTemperature -> 10*Celsius, FilterContainerOut -> Model[Container,Vessel,"2mL Tube"], Output -> Options];
			Lookup[options, FilterTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options}
		],
		Example[{Options,FilterAliquot,"The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options=ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"50mL Tube"],FilterAliquot->1.5*Milliliter,Output->Options];
			Convert[Lookup[options,FilterAliquot],Milliliter],
			1.5*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterAliquotContainer,"The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Water Sample" <> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"50mL Tube"],FilterAliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,FilterAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options}
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options}
		],
		(* aliquot options *)
		Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], Aliquot -> True, Output -> Options];
			Lookup[options, Aliquot],
			True,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], AliquotAmount -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], AssayVolume -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureVolume[Object[Sample,"MeasureVolume Samp With Concentration" <> $SessionUUID], TargetConcentration -> 2.5*Micromolar, AssayVolume -> 30Microliter, AliquotAmount -> 15Microliter, Output -> Options];
			Convert[Lookup[options, TargetConcentration],Micromolar],
			2.5*Micromolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AssayVolume -> 30Microliter, AliquotAmount -> 15Microliter, Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AssayVolume -> 30Microliter, AliquotAmount -> 15Microliter, Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AssayVolume -> 30Microliter, AliquotAmount -> 15Microliter, Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AssayVolume -> 30Microliter, AliquotAmount -> 15Microliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], AliquotContainer -> Model[Container,Vessel,"50mL Tube"], Output -> Options];
			Lookup[options, AliquotContainer],
			{_Integer, ObjectP[Model[Container,Vessel,"50mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options, Template, "Use a previous MeasureVolume protocol as a template for a new one:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID],
				Template->Object[Protocol, MeasureVolume, "Parent Protocol for Template ExperimentMeasureVolume tests" <> $SessionUUID],
				Output -> Options];
			Lookup[options, Template],
			ObjectP[Object[Protocol,MeasureVolume]],
			Variables :> {options}
		],
		Example[{Options, Name, "Specify the Name of the created MeasureVolume object:"},
			options = ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID], Name -> "My special MeasureVolume object name", Output -> Options];
			Lookup[options, Name],
			"My special MeasureVolume object name",
			Variables :> {options}
		],
		Example[{Options,NumberOfReplicates,"Indicate that each measurement should be repeated 3 times and the results should be averaged:"},
			Download[
				ExperimentMeasureVolume[
					{
						Object[Sample,"Measure Volume Test Sample" <> $SessionUUID],
						Object[Sample,"Measure Volume Test Sample2" <> $SessionUUID]
					},
					NumberOfReplicates->3
				],
				SamplesIn[Name]
			],
			{
				"Measure Volume Test Sample" <> $SessionUUID,
				"Measure Volume Test Sample" <> $SessionUUID,
				"Measure Volume Test Sample" <> $SessionUUID,
				"Measure Volume Test Sample2" <> $SessionUUID,
				"Measure Volume Test Sample2" <> $SessionUUID,
				"Measure Volume Test Sample2" <> $SessionUUID
			}
		],
		Example[{Options,IncubateAliquotDestinationWell,"Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID],IncubateAliquotDestinationWell->"A1",AliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotDestinationWell,"Indicates the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID],CentrifugeAliquotDestinationWell->"A1",Output->Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,FilterAliquotDestinationWell,"Indicates the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID],FilterAliquotDestinationWell->"A1",Output->Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,TargetConcentrationAnalyte,"Set the TargetConcentrationAnalyte option:"},
			options=ExperimentMeasureVolume[Object[Sample,"MeasureVolume Samp With Concentration" <> $SessionUUID],TargetConcentration->1*Micromolar,TargetConcentrationAnalyte->Model[Molecule,"id:eGakldJvLvbB"],AssayVolume->0.5*Milliliter,Output->Options];
			Lookup[options,TargetConcentrationAnalyte],
			ObjectP[Model[Molecule,"id:eGakldJvLvbB"]],
			Variables:>{options}
		],
		Example[{Options,DestinationWell,"Indicates the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentMeasureVolume[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID],DestinationWell->"A1",Output->Options];
			Lookup[options,DestinationWell],
			"A1",
			Variables:>{options}
		]
	},
	SymbolSetUp:>{
		$CreatedObjects = {};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects={
				Object[Sample,"MeasureVolume Model-less Sample1" <> $SessionUUID],
				Object[Sample,"MeasureVolume Model-less Sample2" <> $SessionUUID],
				Object[Container,Vessel,"MeasureVolume Container for Model-less Sample1" <> $SessionUUID],
				Object[Container,Vessel,"MeasureVolume Container for Model-less Sample2" <> $SessionUUID],
				Object[Container,Plate,"Measure Volume Test Plate" <> $SessionUUID],
				Object[Container,Plate,"Measure Volume Test Plate2" <> $SessionUUID],
				Object[Sample,"Measure Volume Test Sample" <> $SessionUUID],
				Object[Sample,"Measure Volume Test Sample2" <> $SessionUUID],
				Object[Sample,"Measure Volume Test Water Sample" <> $SessionUUID],
				Object[Sample,"Measure Volume Another Water Samp" <> $SessionUUID],
				Object[Sample,"Measure Volume Another Water Samp in 0.5mL Tube" <> $SessionUUID],
				Object[Sample,"Test Plate Sample 1" <> $SessionUUID],
				Object[Sample,"Test Plate Sample 2" <> $SessionUUID],
				Object[Sample,"Test Plate Sample 3" <> $SessionUUID],
				Object[Sample,"Measure Volume Test Sample No Density" <> $SessionUUID],
				Object[Sample,"Measure Volume Test Sample No Density And Low Volume" <> $SessionUUID],
				Object[Sample,"Measure Volume Test Acetone Sample" <> $SessionUUID],
				Object[Sample,"Measure Volume Test Sample In Bad Container" <> $SessionUUID],
				Object[Sample,"Test Discarded Sample No Container" <> $SessionUUID],
				Object[Sample,"Measure Volume Test Sample Null CalibrationContainer" <> $SessionUUID],
				Object[Sample,"Measure Volume Test Sample In Tube Without Tare" <> $SessionUUID],
				Object[Sample,"Measure Volume Ampoule Samp" <> $SessionUUID],
				Object[Protocol,SampleManipulation,"A test Parent Protocol for ExperimentMeasureVolume testing" <> $SessionUUID],
				Model[Sample,"MeasureVolume Test Model No Density" <> $SessionUUID],
				Model[Container,Vessel,"Measure Volume Untared Vessel Model" <> $SessionUUID],
				Object[Calibration,Volume,"Measure Volume Test Valid Volume Calibration" <> $SessionUUID],
				Object[Sample,"Measure Volume Test Bad Sample" <> $SessionUUID],
				Model[Sample,StockSolution,"MeasureVolume Bad Test Model" <> $SessionUUID],
				Object[Qualification,HPLC,"A test Parent Qualification for ExperimentMeasureVolume testing" <> $SessionUUID],
				Object[Container,Rack,"MeasureVolume Test Sticky Rack" <> $SessionUUID],
				Object[Container,Vessel,"MeasureVolume Water Tube" <> $SessionUUID],
				Object[Container,Vessel,"MeasureVolume Water Tube2" <> $SessionUUID],
				Object[Instrument,LiquidLevelDetector,"MeasureVolume Test VolumeCheck" <> $SessionUUID],
				Object[Container,Vessel,"Measure Volume Immobile Container"<> $SessionUUID],
				Object[Container,Vessel,"Measure Volume Non Immobile Container"<> $SessionUUID],
				Object[Container,Vessel,"Measure Volume Immobile Container 2" <> $SessionUUID],
				Object[Container,Vessel,"Measure Volume Non Immobile Container 2" <> $SessionUUID],
				Object[Protocol,HPLC,"Parent Protocol for ExperimentMeasureVolume testing" <> $SessionUUID],
				Object[Protocol, MeasureVolume, "Parent Protocol for Template ExperimentMeasureVolume tests" <> $SessionUUID],
				Object[Container,Vessel,VolumetricFlask,"MeasureVolume Ethanol Tube" <> $SessionUUID],
				Object[Sample,"Measure Volume Ethanol Samp" <> $SessionUUID],
				Model[Sample,StockSolution,"Measure Volume Ethanol StockSolution" <> $SessionUUID],
				Object[Sample,"MeasureVolume Samp With Concentration" <> $SessionUUID],
				Object[Container,Vessel,"MeasureVolume Tube for Samp With Concentration" <> $SessionUUID],
				Object[Container,Vessel,"MeasureVolume Test 0.5mL Tube" <> $SessionUUID],
				Model[Container,Plate,"MeasureVolume Test Model Plate No Volume Calibrations" <> $SessionUUID],
				Object[Container,Plate,"MeasureVolume Test Plate No Volume Calibrations" <> $SessionUUID],
				Object[Sample,"MeasureVolume Sample in Plate Without Calibration" <> $SessionUUID],
				Object[Sample,"MeasureVolume Sample in Plate Without Calibration 2"<> $SessionUUID],
				Object[Container,ProteinCapillaryElectrophoresisCartridge,"MeasureVolume Cartridge"<> $SessionUUID],
				Object[Sample,"MeasureVolume Cartridge Sample" <> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects,DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];
		Module[{
			testNewModelID,testNewPlateModelID,testNewPlateID,modelContainerNoTareWeight,waterContainer1,solidContainer,
			taredTube,taredTube2,taredTube3,taredTube4,taredTube5,taredTube6,untaredTube2,ultrasonicIncompatibleTube,
			testPlate,testPlate2,opaqueTubeNullCalibration,testProtocolID,testQualificationID,modelNoDensity,badTestModel,
			validTestCalibration,test2mlRack,testLLD,ampoule1,untaredTube3,testStockSModel,vesselForModellessSamp1,
			vesselForModellessSamp2,vesselForSampleWithConc,testModelPlateNoCal,testPlateNoCal,test0p5mlTube,
			cartridgeContainer,waterSample2,waterSampleInContainerNullCalibration,sampleInTubeWithoutTare,
			sampleWithoutDensity,sampleNoDensityLowVol,ultrasonicIncompatibleSample,ultrasonicIncompatibleSample2,
			sampleInUltrasonicIncompatibleTube,plateSamp1,plateSamp2,plateSamp3,waterSamp3,ethSamp,modLessSamp1,
			modLessSamp2,sampWithConc,waterSampPlateNoCalibration,waterSampPlateNoCalibration2,waterIn0p5mLTube,
			cartridgeSample,myMV2mLSet,immobileSetUp,immobileSetUp2
		},
			(* Create an ID for the Model[Container,Vessel] we're gonna make below*)
			{testNewModelID,testNewPlateModelID,testNewPlateID}=CreateID[
				{
					Model[Container,Vessel],
					Model[Container,Plate],
					Object[Container,Plate]
				}
			];

			Upload[
				<|
					Type->Object[Protocol,MeasureVolume],
					Name->"Parent Protocol for Template ExperimentMeasureVolume tests"<>$SessionUUID,
					Site->Link[$Site],
					DeveloperObject->True
				|>
			];

			(* Create some containers *)
			{
				(*1*)modelContainerNoTareWeight,
				(*2*)emptyContainer,
				(*3*)waterContainer1,
				(*4*)waterContainer2,
				(*5*)waterContainer3,
				(*6*)solidContainer,
				(*7*)taredTube,
				(*8*)taredTube2,
				(*9*)taredTube3,
				(*10*)taredTube4,
				(*11*)taredTube5,
				(*12*)taredTube6,
				(*13*)untaredTube,
				(*14*)untaredTube2,
				(*15*)ultrasonicIncompatibleTube,
				(*16*)testPlate,
				(*17*)testPlate2,
				(*18*)opaqueTubeNullCalibration,
				(*19*)testProtocolID,
				(*20*)testQualificationID,
				(*21*)modelNoDensity,
				(*22*)badTestModel,
				(*23*)validTestCalibration,
				(*24*)test2mlRack,
				(*25*)testLLD,
				(*26*)ampoule1,
				(*27*)untaredTube3,
				(*28*)testStockSModel,
				(*29*)vesselForModellessSamp1,
				(*30*)vesselForModellessSamp2,
				(*31*)vesselForSampleWithConc,
				(*32*)testModelPlateNoCal,
				(*33*)testPlateNoCal,
				(*34*)test0p5mlTube,
				(*35*)cartridgeContainer
			}=Upload[{
				(*1*)<|Type->Model[Container,Vessel],Object->testNewModelID,Name->"Measure Volume Untared Vessel Model"<>$SessionUUID,Replace[Positions]->{<|Name->"A1",Footprint->Null,MaxWidth->(0.0111125 * Meter),MaxDepth->(0.0111125 * Meter),MaxHeight->(0.047625 * Meter)|>},Replace[Dimensions]->{0.0111125 * Meter,0.0111125 * Meter,0.047625 * Meter},DeveloperObject->True|>,
				(*2*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Position->"A1",Site->Link[$Site],DeveloperObject->True|>,
				(*3*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Position->"A2",Site->Link[$Site],DeveloperObject->True|>,
				(*4*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Position->"A12",Site->Link[$Site],DeveloperObject->True|>,
				(*5*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Position->"A3",Site->Link[$Site],DeveloperObject->True|>,
				(*6*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Position->"A4",Site->Link[$Site],DeveloperObject->True|>,
				(*7*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Name->"MeasureVolume Water Tube"<>$SessionUUID,Position->"B1",DeveloperObject->True,TareWeight->1.27 * Gram,Site->Link[$Site]|>,
				(*8*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Name->"MeasureVolume Water Tube2"<>$SessionUUID,Position->"B2",DeveloperObject->True,TareWeight->1.27 * Gram,Site->Link[$Site]|>,
				(*9*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Position->"B3",DeveloperObject->True,Site->Link[$Site],TareWeight->1.27 * Gram|>,
				(*10*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Position->"B4",DeveloperObject->True,Site->Link[$Site],TareWeight->1.27 * Gram|>,
				(*11*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Position->"B5",DeveloperObject->True,Site->Link[$Site],TareWeight->1.27 * Gram|>,
				(*12*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],DeveloperObject->True,Site->Link[$Site],TareWeight->1.27 * Gram|>,
				(*13*)<|Type->Object[Container,Vessel],Model->Link[testNewModelID,Objects],Site->Link[$Site],DeveloperObject->True|>,
				(*14*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Position->"B6",Site->Link[$Site],DeveloperObject->True|>,
				(*15*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:qdkmxz0A88LM"],Objects],Position->"C1",Site->Link[$Site],DeveloperObject->True|>,
				(*16*)<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],Name->"Measure Volume Test Plate"<>$SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
				(*17*)<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],Name->"Measure Volume Test Plate2"<>$SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
				(*18*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:6V0npvmKLK9q"],Objects],Position->"D1",Site->Link[$Site],DeveloperObject->True|>,
				(*19*)<|Type->Object[Protocol,SampleManipulation],Name->"A test Parent Protocol for ExperimentMeasureVolume testing"<>$SessionUUID,Status->Processing,Site->Link[$Site],DeveloperObject->True|>,
				(*20*)<|Type->Object[Qualification,HPLC],Name->"A test Parent Qualification for ExperimentMeasureVolume testing"<>$SessionUUID,Status->Processing,Site->Link[$Site],DeveloperObject->True|>,
				(*21*)<|Type->Model[Sample],DefaultStorageCondition->Link[Model[StorageCondition,"id:7X104vnR18vX"]],Name->"MeasureVolume Test Model No Density"<>$SessionUUID,Replace[Composition]->{{Null,Null}},UltrasonicIncompatible->True,DeveloperObject->True|>,
				(*22*)<|Type->Model[Sample,StockSolution],DefaultStorageCondition->Link[Model[StorageCondition,"id:7X104vnR18vX"]],Name->"MeasureVolume Bad Test Model"<>$SessionUUID,Replace[Composition]->{{Null,Null}},UltrasonicIncompatible->True,Density->(1Kilogram / Meter^3),DeveloperObject->True|>,
				(*23*)<|Type->Object[Calibration,Volume],Replace[ContainerModels]->{Link[testNewModelID,VolumeCalibrations]},Name->"Measure Volume Test Valid Volume Calibration"<>$SessionUUID,LiquidLevelDetector->Link[Object[Instrument,LiquidLevelDetector,"id:AEqRl954G3lW"]],LiquidLevelDetectorModel->Link[Model[Instrument,LiquidLevelDetector,"id:zGj91aR3d5b6"]]|>,
				(*24*)<|Type->Object[Container,Rack],Model->Link[Model[Container,Rack,"id:BYDOjv1VAAml"],Objects],Site->Link[$Site],DeveloperObject->True|>,
				(*25*)<|Type->Object[Instrument,LiquidLevelDetector],Model->Link[Model[Instrument,LiquidLevelDetector,"VolumeCheck 100"],Objects],Status->Running,Site->Link[$Site],DeveloperObject->True|>,
				(*26*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:o1k9jAKOwwwm"],Objects],Site->Link[$Site],DeveloperObject->True|>,
				(*27*)<|Type->Object[Container,Vessel,VolumetricFlask],Model->Link[Model[Container,Vessel,VolumetricFlask,"id:E8zoYvNOYlnA"],Objects],Site->Link[$Site],Name->"MeasureVolume Ethanol Tube"<>$SessionUUID,DeveloperObject->True,TareWeight->1.27 * Gram|>,
				(*28*)<|Type->Model[Sample,StockSolution],DefaultStorageCondition->Link[Model[StorageCondition,"id:7X104vnR18vX"]],Name->"Measure Volume Ethanol StockSolution"<>$SessionUUID,Replace[Composition]->{{Null,Null}},UltrasonicIncompatible->True,Density->Null,DeveloperObject->True|>,
				(*29*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Name->"MeasureVolume Container for Model-less Sample1"<>$SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
				(*30*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Name->"MeasureVolume Container for Model-less Sample2"<>$SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
				(*31*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Name->"MeasureVolume Tube for Samp With Concentration"<>$SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
				(*32*)<|Type->Model[Container,Plate],Object->testNewPlateModelID,Name->"MeasureVolume Test Model Plate No Volume Calibrations"<>$SessionUUID,Replace[Positions]->{<|Name->"A1",Footprint->Null,MaxWidth->0.00825Meter,MaxDepth->0.00825Meter,MaxHeight->0.0374Meter|>,<|Name->"B1",Footprint->Null,MaxWidth->0.00825Meter,MaxDepth->0.00825Meter,MaxHeight->0.0374Meter|>},Footprint->Plate,DeveloperObject->True|>,
				(*33*)<|Type->Object[Container,Plate],Object->testNewPlateID,Model->Link[testNewPlateModelID,Objects],Name->"MeasureVolume Test Plate No Volume Calibrations"<>$SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
				(*34*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:bq9LA0JPKJE6"],Objects],(*"0.5mL Tube with 2mL Tube Skirt (Deprecated)"*)Name->"MeasureVolume Test 0.5mL Tube"<>$SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
				(*35*)<|Type->Object[Container,ProteinCapillaryElectrophoresisCartridge],Model->Link[Model[Container,ProteinCapillaryElectrophoresisCartridge,"id:Z1lqpMz7q8n9"],Objects],Site->Link[$Site],Name->"MeasureVolume Cartridge"<>$SessionUUID,DeveloperObject->True|>
			}];

			(* Create some samples *)
			{
				(*1*)discardedChemical,
				(*2*)waterSample,
				(*3*)waterSample2,
				(*4*)waterSampleInContainerNullCalibration,
				(*5*)sampleWithDensity1,
				(*6*)sampleWithDensity2,
				(*7*)sampleInTubeWithoutTare,
				(*8*)sampleWithoutDensity,
				(*9*)sampleNoDensityLowVol,
				(*10*)ultrasonicIncompatibleSample,
				(*11*)ultrasonicIncompatibleSample2,
				(*12*)sampleInUltrasonicIncompatibleTube,
				(*13*)plateSamp1,
				(*14*)plateSamp2,
				(*15*)plateSamp3,
				(*16*)solidSample,
				(*17*)ampouleSamp,
				(*18*)waterSamp3,
				(*19*)ethSamp,
				(*20*)modLessSamp1,
				(*21*)modLessSamp2,
				(*22*)sampWithConc,
				(*23*)waterSampPlateNoCalibration,
				(*24*)waterSampPlateNoCalibration2,
				(*25*)waterIn0p5mLTube,
				(*26*)cartridgeSample
			}=ECL`InternalUpload`UploadSample[
				{
					(*1*)Model[Sample,"Milli-Q water"],
					(*2*)Model[Sample,"Milli-Q water"],
					(*3*)Model[Sample,"Milli-Q water"],
					(*4*)Model[Sample,"Milli-Q water"],
					(*5*)Model[Sample,"Milli-Q water"],
					(*6*)Model[Sample,"Milli-Q water"],
					(*7*)Model[Sample,"Milli-Q water"],
					(*8*)Model[Sample,"MeasureVolume Test Model No Density"<>$SessionUUID],
					(*9*)Model[Sample,"Milli-Q water"],
					(*10*)Model[Sample,"Acetone, Reagent Grade"],
					(*11*)Model[Sample,StockSolution,"MeasureVolume Bad Test Model"<>$SessionUUID],
					(*12*)Model[Sample,"Milli-Q water"],
					(*13*)Model[Sample,"Milli-Q water"],
					(*14*)Model[Sample,"Milli-Q water"],
					(*15*)Model[Sample,"id:rea9jl1X4N3b"],
					(*16*)Model[Sample,"Ammonium Bicarbonate"],
					(*17*)Model[Sample,"Milli-Q water"],
					(*18*)Model[Sample,"Milli-Q water"],
					(*19*)Model[Sample,StockSolution,"Measure Volume Ethanol StockSolution"<>$SessionUUID],
					(*20*)Model[Sample,"Milli-Q water"],
					(*21*)Model[Sample,"MeasureVolume Test Model No Density"<>$SessionUUID],
					(*22*)Model[Sample,StockSolution,"Red Food Dye Test Solution"],
					(*23*)Model[Sample,"Milli-Q water"],
					(*24*)Model[Sample,"Milli-Q water"],
					(*25*)Model[Sample,"Milli-Q water"],
					(*26*)Model[Sample,"Milli-Q water"]
				},
				{
					(*1*){"A1",waterContainer1},
					(*2*){"A1",waterContainer2},
					(*3*){"A1",waterContainer3},
					(*4*){"A1",opaqueTubeNullCalibration},
					(*5*){"A1",taredTube},
					(*6*){"A1",untaredTube},
					(*7*){"A1",untaredTube2},
					(*8*){"A1",taredTube6},
					(*9*){"A1",taredTube3},
					(*10*){"A1",taredTube4},
					(*11*){"A1",testPlate2},
					(*12*){"A1",ultrasonicIncompatibleTube},
					(*13*){"A1",testPlate},
					(*14*){"A2",testPlate2},
					(*15*){"A3",testPlate},
					(*16*){"A1",solidContainer},
					(*17*){"A1",ampoule1},
					(*18*){"A1",taredTube2},
					(*19*){"A1",untaredTube3},
					(*20*){"A1",vesselForModellessSamp1},
					(*21*){"A1",vesselForModellessSamp2},
					(*22*){"A1",vesselForSampleWithConc},
					(*23*){"A1",testPlateNoCal},
					(*24*){"B1",testPlateNoCal},
					(*25*){"A1",test0p5mlTube},
					(*26*){"H+ Slot",cartridgeContainer}
				},
				InitialAmount->{
					(*1*)45 Milliliter,
					(*2*)50 Milliliter,
					(*3*)40 Milliliter,
					(*4*)50 Milliliter,
					(*5*)1.5 Milliliter,
					(*6*)1.5 Milliliter,
					(*7*)1.25 Milliliter,
					(*8*)351 Microliter,
					(*9*)6 Microliter,
					(*10*)1.5 Milliliter,
					(*11*)1.5 Milliliter,
					(*12*)1.5 Milliliter,
					(*13*)1.5 Milliliter,
					(*14*)1 Milliliter,
					(*15*)0.5 Milliliter,
					(*16*)5 Gram,
					(*17*)0.75 Milliliter,
					(*18*)1.75 Milliliter,
					(*19*)1Milliliter,
					(*20*)1Milliliter,
					(*21*)1Milliliter,
					(*22*)1Milliliter,
					(*23*)1Milliliter,
					(*24*)1Milliliter,
					(*25*)0.4Milliliter,
					(*26*)10Microliter
				},
				StorageCondition->Refrigerator
			];

			(* Secondary uploads *)
			Upload[{
				<|
					Type->Object[Calibration,Volume],
					BufferModel->Link[Model[Sample,"Milli-Q water"]],
					CalibrationDistributionFunction->QuantityFunction[Function[{x},x],{Millimeter},1],
					CalibrationFunction->QuantityFunction[Function[{x},x],{Millimeter},Milliliter],
					Append[ContainerModels]->{Link[Model[Container,Vessel,"id:6V0npvmKLK9q"],VolumeCalibrations]},
					ManufacturerCalibration->True,
					VolumeSensorModel->Link[Model[Sensor,Volume,"id:eGakld0bbMVq"]]
				|>,
				<|Object->waterSample,Name->"Measure Volume Test Sample"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				<|Object->waterSampleInContainerNullCalibration,Name->"Measure Volume Test Sample Null CalibrationContainer"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				<|Object->sampleWithDensity1,Name->"Measure Volume Test Water Sample"<>$SessionUUID,Density->1 * (Gram / Milliliter),Status->Available,DeveloperObject->True|>,
				<|Object->sampleInTubeWithoutTare,Name->"Measure Volume Test Sample In Tube Without Tare"<>$SessionUUID,Density->1 * (Gram / Milliliter),Status->Available,DeveloperObject->True|>,
				<|Object->sampleWithDensity2,Density->1 * (Gram / Milliliter),Status->Available,DeveloperObject->True|>,
				<|Object->sampleWithoutDensity,Name->"Measure Volume Test Sample No Density"<>$SessionUUID,Volume->350 * Microliter,Status->Available,DeveloperObject->True|>,
				<|Object->sampleNoDensityLowVol,Name->"Measure Volume Test Sample No Density And Low Volume"<>$SessionUUID,Density->Null,Volume->5 * Microliter,Model->Null,Status->Available,UltrasonicIncompatible->True,DeveloperObject->True|>,
				<|Object->ultrasonicIncompatibleSample,Name->"Measure Volume Test Acetone Sample"<>$SessionUUID,Density->0.791 * (Gram / Milliliter),Status->Available,DeveloperObject->True|>,
				<|Object->ultrasonicIncompatibleSample2,Name->"Measure Volume Test Bad Sample"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				<|Object->sampleInUltrasonicIncompatibleTube,Name->"Measure Volume Test Sample In Bad Container"<>$SessionUUID,Density->0.791 * (Gram / Milliliter),Status->Available,DeveloperObject->True|>,
				<|Object->plateSamp1,Name->"Test Plate Sample 1"<>$SessionUUID,Density->1 * (Gram / Milliliter),Status->Available,DeveloperObject->True|>,
				<|Object->plateSamp2,Name->"Test Plate Sample 2"<>$SessionUUID,Density->1 * (Gram / Milliliter),Status->Available,DeveloperObject->True|>,
				<|Object->plateSamp3,Name->"Test Plate Sample 3"<>$SessionUUID,State->Liquid,Concentration->10 * Micromolar,Status->Available,DeveloperObject->True|>,
				<|Type->Object[Sample],Name->"Test Discarded Sample No Container"<>$SessionUUID,Volume->1.5Milliliter,Density->1 * (Gram / Milliliter),Model->Link[Model[Sample,"Milli-Q water"],Objects],Status->Discarded,DeveloperObject->True|>,
				<|Object->discardedChemical,Status->Discarded,DeveloperObject->True|>,
				<|Object->test2mlRack,Name->"MeasureVolume Test Sticky Rack"<>$SessionUUID,Status->InUse,Position->"Plate Slot",Replace[Contents]->{{"B1",Link[taredTube,Container]},{"B2",Link[taredTube2,Container]}}|>,
				<|Object->testLLD,Name->"MeasureVolume Test VolumeCheck"<>$SessionUUID,Append[Contents]->{{"Plate Slot",Link[test2mlRack,Container]}},Site->Link[$Site]|>,
				<|Object->waterSample2,Name->"Measure Volume Test Sample2"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				<|Object->ampouleSamp,Name->"Measure Volume Ampoule Samp"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				<|Object->waterSamp3,Name->"Measure Volume Another Water Samp"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				<|Object->ethSamp,Name->"Measure Volume Ethanol Samp"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				<|Object->modLessSamp1,Name->"MeasureVolume Model-less Sample1"<>$SessionUUID,Model->Null,DeveloperObject->True|>,
				<|Object->modLessSamp2,Name->"MeasureVolume Model-less Sample2"<>$SessionUUID,Model->Null,DeveloperObject->True|>,
				<|Object->waterSampPlateNoCalibration,Name->"MeasureVolume Sample in Plate Without Calibration"<>$SessionUUID,Model->Null,DeveloperObject->True|>,
				<|Object->waterSampPlateNoCalibration2,Name->"MeasureVolume Sample in Plate Without Calibration 2"<>$SessionUUID,Model->Null,DeveloperObject->True|>,
				<|Object->waterIn0p5mLTube,Name->"Measure Volume Another Water Samp in 0.5mL Tube"<>$SessionUUID,DeveloperObject->True|>,
				<|
					Object->sampWithConc,
					Name->"MeasureVolume Samp With Concentration"<>$SessionUUID,
					Replace[Composition]->{
						{100 VolumePercent,Link[Model[Molecule,"Water"]]},
						{5 Micromolar,Link[Model[Molecule,"Uracil"]]}
					},
					DeveloperObject->True
				|>,
				<|Object->cartridgeSample,Name->"MeasureVolume Cartridge Sample"<>$SessionUUID,Status->Available,DeveloperObject->True|>
			}];

			(* Upload 50 2ml tubes for batching checks *)
			myMV2mLSet=ConstantArray[
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True|>,
				50
			];

			myMV2mLTubes=Upload[myMV2mLSet];

			ECL`InternalUpload`UploadSample[
				ConstantArray[Model[Sample,"Milli-Q water"],Length[myMV2mLTubes]],
				{"A1",#}&/@myMV2mLTubes,
				InitialAmount->ConstantArray[300 * Microliter,Length[myMV2mLTubes]],
				StorageCondition->Refrigerator
			];

			immobileSetUp=Module[{modelVesselID,model,vessel1,vessel2,protocol},

				modelVesselID=CreateID[Model[Container,Vessel]];
				{model,vessel1,vessel2,protocol}=Upload[{
					<|
						Object->modelVesselID,
						Replace[Positions]->{<|Name->"A1",Footprint->Null,MaxWidth->.1 Meter,MaxDepth->.1 Meter,MaxHeight->.1 Meter|>},
						Immobile->True
					|>,
					<|
						Type->Object[Container,Vessel],
						Model->Link[modelVesselID,Objects],
						DeveloperObject->True,
						Site->Link[$Site],
						Name->"Measure Volume Immobile Container"<>$SessionUUID
					|>,
					<|
						Type->Object[Container,Vessel],
						Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],
						DeveloperObject->True,
						Site->Link[$Site],
						Name->"Measure Volume Non Immobile Container"<>$SessionUUID
					|>,
					<|
						Type->Object[Protocol,HPLC],
						Name->"Parent Protocol for ExperimentMeasureVolume testing"<>$SessionUUID,
						Site->Link[$Site]
					|>
				}];

				UploadSample[{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},{{"A1",vessel1},{"A1",vessel2}}];
			];

			immobileSetUp2=Module[{modelVesselID,model,vessel1,vessel2},

				modelVesselID=CreateID[Model[Container,Vessel]];
				{model,vessel1,vessel2}=Upload[{
					<|
						Object->modelVesselID,
						Replace[Positions]->{<|Name->"A1",Footprint->Null,MaxWidth->.1 Meter,MaxDepth->.1 Meter,MaxHeight->.1 Meter|>},
						Immobile->True
					|>,
					<|
						Type->Object[Container,Vessel],
						Model->Link[modelVesselID,Objects],
						DeveloperObject->True,
						Site->Link[$Site],
						Name->"Measure Volume Immobile Container 2"<>$SessionUUID,
						TareWeight->10 Gram
					|>,
					<|
						Type->Object[Container,Vessel],
						Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],
						DeveloperObject->True,
						Site->Link[$Site],
						Name->"Measure Volume Non Immobile Container 2"<>$SessionUUID,
						TareWeight->10 Gram
					|>
				}];

				UploadSample[{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},{{"A1",vessel1},{"A1",vessel2}}];
			];
		]
	},
	Stubs :> {$PersonID = Object[User, "Test user for notebook-less test protocols"]},

	SymbolTearDown :> {
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		(* Erase all objects that were created in the course of these tests *)
		EraseObject[
			PickList[$CreatedObjects,
				DatabaseMemberQ[$CreatedObjects]
			],
			Force->True,
			Verbose->False
		];
		(* Cleanse $CreatedObjects *)
		Unset[$CreatedObjects];
	},
	HardwareConfiguration->HighRAM
	(*,
	Variables:>{
			emptyContainer,
			waterContainer1,
			waterContainer2,
			solidContainer,
			taredTube,
			taredTube2,
			taredTube3,
			taredTube4,
			untaredTube,
			untaredTube2,
			ultrasonicIncompatibleTube,
			testPlate,
			testPlate2,
			opaqueTubeNullCalibration,
			testProtocolID,
			modelNoDensity,
			modelContainerNoTareWeight,
			validTestCalibration

	}*)
];

DefineTests[VolumeMeasurementDevices,
	{
		Test["VolumeMeasurementDevices properly selects instruments and containers from the container input:",
			VolumeMeasurementDevices[{Object[Container,Vessel,"Water Tube 1 for VolumeMeasurementDevices "<> $SessionUUID],Object[Container,Vessel,"Water Tube 2 for VolumeMeasurementDevices "<> $SessionUUID]}],
			{
				Repeated[
					{ObjectP[{Object[Instrument],Model[Instrument],Object[Container],Model[Container]}]..},
					2
				]
			}
		],
		Test["VolumeMeasurementDevices properly selects instruments and containers from the sample input:",
			VolumeMeasurementDevices[{Object[Sample,"Test Plate Sample 1 for VolumeMeasurementDevices "<>$SessionUUID],Object[Sample,"Test Plate Sample 2 for VolumeMeasurementDevices "<>$SessionUUID],Object[Sample,"Test Plate Sample 3 for VolumeMeasurementDevices "<>$SessionUUID]}],
			{
				Repeated[
					{ObjectP[{Object[Instrument],Model[Instrument],Object[Container],Model[Container]}]..},
					3
				]
			}
		]
	},
	SymbolSetUp:>(
		$CreatedObjects = {};
		ClearMemoization[];
		ClearDownload[];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects={
				Object[Container,Plate,"Test Plate 1 for VolumeMeasurementDevices "<>$SessionUUID],
				Object[Container,Plate,"Test Plate 2 for VolumeMeasurementDevices " <>$SessionUUID],
				Object[Sample,"Test Plate Sample 1 for VolumeMeasurementDevices "<>$SessionUUID],
				Object[Sample,"Test Plate Sample 2 for VolumeMeasurementDevices "<>$SessionUUID],
				Object[Sample,"Test Plate Sample 3 for VolumeMeasurementDevices "<>$SessionUUID],
				Object[Container,Vessel,"Water Tube 1 for VolumeMeasurementDevices "<>$SessionUUID],
				Object[Container,Vessel,"Water Tube 2 for VolumeMeasurementDevices "<>$SessionUUID],
				Object[Sample,"Test Water Sample 1 for VolumeMeasurementDevices "<>$SessionUUID],
				Object[Sample,"Test Water Sample 2 for VolumeMeasurementDevices "<>$SessionUUID]
			};

			EraseObject[
				PickList[namedObjects,DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];

		(* Index number are referencing to SymbolSetUp in ExperimentMeasureVolume *)
		(* Create an ID for the Model[Container,Vessel] we're gonna make below*)
		Module[{taredTube,taredTube2,testPlate,testPlate2,plateSamp1,plateSamp2,plateSamp3,waterSample1,waterSample2},

			(* Create some containers *)
			{
				(*7*)taredTube,
				(*8*)taredTube2,
				(*16*)testPlate,
				(*17*)testPlate2
			} = Upload[{
				(*7*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Name->"Water Tube 1 for VolumeMeasurementDevices "<>$SessionUUID,Position->"B1",DeveloperObject->True,TareWeight->1.27*Gram|>,
				(*8*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Name->"Water Tube 2 for VolumeMeasurementDevices "<>$SessionUUID,Position->"B2",DeveloperObject->True,TareWeight->1.27*Gram|>,
				(*16*)<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],Name->"Test Plate 1 for VolumeMeasurementDevices "<>$SessionUUID,DeveloperObject->True|>,
				(*17*)<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],Name->"Test Plate 2 for VolumeMeasurementDevices "<>$SessionUUID,DeveloperObject->True|>
			}];

			(* Create some samples *)
			{
				(*5*)waterSample1,
				(*13*)plateSamp1,
				(*14*)plateSamp2,
				(*15*)plateSamp3,
				(*18*)waterSample2
			} = ECL`InternalUpload`UploadSample[
				{
					(*5*)Model[Sample,"Milli-Q water"],
					(*13*)Model[Sample,"Milli-Q water"],
					(*14*)Model[Sample,"Milli-Q water"],
					(*15*)Model[Sample,"id:rea9jl1X4N3b"],
					(*18*)Model[Sample,"Milli-Q water"]
				},
				{
					(*5*){"A1",taredTube},
					(*13*){"A1",testPlate},
					(*14*){"A2",testPlate2},
					(*15*){"A3",testPlate},
					(*18*){"A1",taredTube2}
				},
				InitialAmount->{
					(*5*)1.5 Milliliter,
					(*13*)1.5 Milliliter,
					(*14*)1 Milliliter,
					(*15*)0.5 Milliliter,
					(*18*)1.75 Milliliter
				},
				StorageCondition -> Refrigerator
			];

			(* Secondary uploads *)
			Upload[{
				<|Object->waterSample1,Name->"Test Water Sample 1 for VolumeMeasurementDevices " <> $SessionUUID,Density->1*(Gram/Milliliter),Status->Available,DeveloperObject->True|>,
				<|Object->plateSamp1,Name->"Test Plate Sample 1 for VolumeMeasurementDevices "<>$SessionUUID,Density->1*(Gram/Milliliter),Status->Available,DeveloperObject->True|>,
				<|Object->plateSamp2,Name->"Test Plate Sample 2 for VolumeMeasurementDevices "<>$SessionUUID,Density->1*(Gram/Milliliter),Status->Available,DeveloperObject->True|>,
				<|Object->plateSamp3,Name->"Test Plate Sample 3 for VolumeMeasurementDevices "<>$SessionUUID,State->Liquid,Concentration->10*Micromolar,Status->Available,DeveloperObject->True|>,
				<|Object->waterSample2,Name->"Test Water Sample 2 for VolumeMeasurementDevices " <> $SessionUUID,Status->Available,DeveloperObject->True|>
			}];
		]
	),
	Stubs :> {$PersonID = Object[User, "Test user for notebook-less test protocols"]},
	SymbolTearDown :> {
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		(* Erase all objects that were created in the course of these tests *)
		EraseObject[
			PickList[$CreatedObjects,
				DatabaseMemberQ[$CreatedObjects]
			],
			Force->True,
			Verbose->False
		];
		(* Cleanse $CreatedObjects *)
		Unset[$CreatedObjects];
	}
];

(* ::Subsection:: *)
(*ExperimentMeasureVolumeOptions*)

DefineTests[ExperimentMeasureVolumeOptions,
	{
		Example[{Basic, "Return a list of options in table form for one sample:"},
			ExperimentMeasureVolumeOptions[Object[Container,Plate,"Measure Volume Test Plate" <> $SessionUUID]],
			Graphics_
		],
		Example[{Basic, "Return a list of options in table form for multiple samples:"},
			ExperimentMeasureVolumeOptions[{Object[Sample,"Measure Volume Test Sample" <> $SessionUUID],Object[Sample,"Measure Volume Test Sample2" <> $SessionUUID]}],
			Graphics_
		],
		Example[{Options, OutputFormat, "If OutputFormat -> List, return a list of options rather than a table:"},
			ExperimentMeasureVolumeOptions[{Object[Sample,"Measure Volume Test Sample" <> $SessionUUID],Object[Sample,"Measure Volume Test Sample2" <> $SessionUUID]}, OutputFormat -> List],
			{__Rule}
		]
	},
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>{
		$CreatedObjects = {};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects={
				Object[Container,Plate,"Measure Volume Test Plate" <> $SessionUUID],
				Object[Sample,"Measure Volume Test Sample" <> $SessionUUID],
				Object[Sample,"Measure Volume Test Sample2" <> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects,DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];

		(* Create an ID for the Model[Container,Vessel] we're gonna make below*)
		testNewModelID = CreateID[Model[Container,Vessel]];

		(* Create some containers *)
		{
			waterContainer1
		} = Upload[{
			<|Type->Object[Container,Plate],Model->Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Objects],Name->"Measure Volume Test Plate" <> $SessionUUID,Site -> Link[$Site],DeveloperObject->True|>
		}];

		(* Create some samples *)
		{
			waterSample,
			waterSample2
		} = ECL`InternalUpload`UploadSample[
			{
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"]
			},
			{
				{"A1",waterContainer1},
				{"A2",waterContainer1}
			},
			InitialAmount->{
				1.5 Milliliter,
				500 Microliter
			},
			StorageCondition -> Refrigerator
		];

		(* Secondary uploads *)
		Upload[{
			<|Object->waterSample,Name->"Measure Volume Test Sample" <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->waterSample2,Name->"Measure Volume Test Sample2" <> $SessionUUID,Status->Available,DeveloperObject->True|>
		}];
	},
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Container,Plate,"Measure Volume Test Plate" <> $SessionUUID],
					Object[Sample,"Measure Volume Test Sample" <> $SessionUUID],
					Object[Sample,"Measure Volume Test Sample2" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];


(* ::Subsection:: *)
(*ExperimentMeasureVolumePreview*)

DefineTests[ExperimentMeasureVolumePreview,
	{
		Example[{Basic, "Return Null for one sample:"},
			ExperimentMeasureVolumePreview[Object[Container,Plate,"Measure Volume Preview Test Plate" <> $SessionUUID]],
			Null
		],
		Example[{Basic, "Return  Null for multiple samples:"},
			ExperimentMeasureVolumePreview[{
				Object[Sample,"Measure Volume Preview Test Sample" <> $SessionUUID],
				Object[Sample,"Measure Volume Preview Test Sample2" <> $SessionUUID]
			}
			],
			Null
		],
		Example[{Basic, "Return  Null for samples and options:"},
			ExperimentMeasureVolumePreview[{
				Object[Sample,"Measure Volume Preview Test Sample" <> $SessionUUID],
				Object[Sample,"Measure Volume Preview Test Sample2" <> $SessionUUID]
			}, Method->Ultrasonic,Upload->False
			],
			Null
		]
	},
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp:> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects = {
				Object[Container, Plate, "Measure Volume Preview Test Plate" <> $SessionUUID],
				Object[Sample, "Measure Volume Preview Test Sample" <> $SessionUUID],
				Object[Sample, "Measure Volume Preview Test Sample2" <> $SessionUUID]
			};

			EraseObject[PickList[namedObjects, DatabaseMemberQ[namedObjects]], Force -> True, Verbose -> False]
		];

		Module[{testNewModelID,waterContainer1,waterSample,waterSample2},

			(* Create an ID for the Model[Container,Vessel] we're gonna make below*)
			testNewModelID = CreateID[Model[Container, Vessel]];

			(* Create some containers *)
			{waterContainer1} = Upload[{
				<|
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Name -> "Measure Volume Preview Test Plate" <> $SessionUUID,
					DeveloperObject -> True
				|>
			}];

			(* Create some samples *)
			{
				waterSample,
				waterSample2
			} = ECL`InternalUpload`UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				{
					{"A1", waterContainer1},
					{"A2", waterContainer1}
				},
				InitialAmount -> {
					1.5 Milliliter,
					500 Microliter
				},
				StorageCondition -> Refrigerator
			];

			(* Secondary uploads *)
			Upload[{
				<|Object -> waterSample, Name -> "Measure Volume Preview Test Sample" <> $SessionUUID, Site -> Link[$Site], Status -> Available, DeveloperObject -> True|>,
				<|Object -> waterSample2, Name -> "Measure Volume Preview Test Sample2" <> $SessionUUID, Site -> Link[$Site],Status -> Available, DeveloperObject -> True|>,
				<|Object -> waterContainer1, Name -> "Measure Volume Preview Test Plate" <> $SessionUUID, Site -> Link[$Site],Status -> Available, DeveloperObject -> True|>
			}]
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	)

];


(* ::Subsection:: *)
(*ValidExperimentMeasureVolumeQ*)

DefineTests[
	ValidExperimentMeasureVolumeQ,
	{
		(* --- Basic Examples --- *)
		Example[{Basic,"Measure the volume of a single sample:"},
			ValidExperimentMeasureVolumeQ[Object[Sample,"Measure Volume Test Sample" <> $SessionUUID]],
			True
		],

		Example[{Basic,"Measure the volumes of multiple samples:"},
			ValidExperimentMeasureVolumeQ[{Object[Sample,"Measure Volume Test Sample" <> $SessionUUID],Object[Sample,"Measure Volume Test Water Sample" <> $SessionUUID]}],
			True
		],

		Example[{Basic,"Measure the volumes of all samples in a container:"},
			ValidExperimentMeasureVolumeQ[Object[Container,Plate,"Measure Volume Test Plate" <> $SessionUUID]],
			True
		],

		(* --- Options --- *)
		Example[{Options,Verbose,"If Verbose -> True, returns the passing and failing tests:"},
			ValidExperimentMeasureVolumeQ[
				Object[Sample,"Measure Volume Test Sample" <> $SessionUUID],
				Verbose->True
			],
			True,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,OutputFormat,"If OutputFormat -> TestSummary, returns a test summary instead of a Boolean:"},
			ValidExperimentMeasureVolumeQ[
				Object[Sample,"Measure Volume Test Sample" <> $SessionUUID],
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* --- Invalid Input Tests --- *)
		Example[{Messages,"DiscardedSamples","Discarded samples will cause Errors:"},
			ValidExperimentMeasureVolumeQ[discardedChemical,Upload->False],
			False,
			Messages:>{}
		],

		Example[{Messages,"EmptyContainers","Empty containers will cause Errors:"},
			ValidExperimentMeasureVolumeQ[emptyContainer,Upload->False],
			False,
			Messages:>{}
		],

		(* TODO: Figure out what throws SolidSamplesNotAllowed so that we can make this call return False (currently returns True) *)
		(*Example[{Messages,"SolidSamplesNotAllowed","Solid samples cannot have their volume measured and will cause Errors:"},
			ValidExperimentMeasureVolumeQ[solidSample,Upload->False],
			False,
			Messages:>{}
		],*)

		(* --- Option Precision Tests --- *)
		Example[{Messages,"InstrumentPrecision","If MeasurementVolume is specified to a precision we cannot resolve in the lab, ExperimentMeasureVolume rounds the value and throws a warning:"},
			ValidExperimentMeasureVolumeQ[waterSample, MeasurementVolume -> 75.0000000025 Microliter],
			True,
			Messages:>{}
		],

		(* --- Conflicting Option Tests --- *)

		Test["If MeasureDensity -> False, MeasurementVolume must be Null or Automatic or an Error is thrown:",
			ValidExperimentMeasureVolumeQ[{waterSample,waterSample}, MeasureDensity -> False, MeasurementVolume -> 250 Microliter, Upload -> False],
			False,
			Messages:>{}
		],

		Test["If MeasureDensity -> False, RecoupSample must be Null or Automatic or an Error is thrown:",
			ValidExperimentMeasureVolumeQ[{waterSample,waterSample}, MeasureDensity -> False, RecoupSample -> False, Upload -> False],
			False,
			Messages:>{}
		],

		(* Unresolvable Option Tests *)
		(* MeasureDensityRequired Error *)
		Example[{Messages,"MeasureDensityRequired","If Method -> Gravimetric, the sample has no Density and MeasureDensity -> False, an error would be thrown resulting in the ValidExperimentMeasureVolumeQ returning False:"},
			ValidExperimentMeasureVolumeQ[Object[Sample,"Measure Volume Test Sample No Density" <> $SessionUUID], Method->Gravimetric, MeasureDensity -> False, Upload -> False],
			False,
			Messages:>{}
		],

		(* UnmeasurableDensity Error *)
		Example[{Messages,"InsufficientMeasureDensityVolume","If MeasureDensity -> True but the sample does not have ExpeirmentMeasureDensity's minimum volume requirement, an Error is thrown:"},
			ValidExperimentMeasureVolumeQ[Object[Sample,"Measure Volume Test Sample No Density And Low Volume" <> $SessionUUID], MeasureDensity -> True, Upload -> False],
			False,
			Messages:>{}
		],

		(* CentrifugeRecommended Warning *)
		Example[{Messages,"CentrifugeRecommended","If Method -> Ultrasonic but Centrifuge -> False, throw a Warning:"},
			ValidExperimentMeasureVolumeQ[Object[Sample,"Measure Volume Test Sample No Density And Low Volume" <> $SessionUUID], Method -> Ultrasonic, Centrifuge -> False],
			True,
			Messages:>{}
		],
		(* SampleUltrasonicIncompatible Error *)
		Example[{Messages,"SampleUltrasonicIncompatible","If Method is set to Ultrasonic for UltrasonicIncompatible samples, an Error is thrown:"},
			ValidExperimentMeasureVolumeQ[Object[Sample,"Measure Volume Test Acetone Sample" <> $SessionUUID], Method -> Ultrasonic, Upload -> False],
			False,
			Messages:>{}
		],

(*		*)(* UnmeasurableContainer *)(*
		Example[{Messages,"UnmeasurableContainer","If the sample is in a container that cannot be measured by the Method specified, an Error is thrown:"},
			ValidExperimentMeasureVolumeQ[Object[Sample,"Measure Volume Test Sample In Bad Container" <> $SessionUUID], Method -> Ultrasonic, Upload -> False],
			False,
			Messages:>{}
		],*)

		Example[{Messages,"VolumeCalibrationsMissing","If a sample is in a plate that has no VolumeCalibration information, throw an UnmeasurableContainer error:"},
			ValidExperimentMeasureVolumeQ[{Object[Sample,"MeasureVolume Sample in Plate Without Calibration" <> $SessionUUID],Object[Sample,"MeasureVolume Sample in Plate Without Calibration 2"<> $SessionUUID]}, Method -> Ultrasonic, Upload -> False],
			False,
			Messages:>{}
		],

		Test["If a sample is in a plate and Method -> Gravimetric, throw an UnmeasurableContainer error:",
			ValidExperimentMeasureVolumeQ[Object[Sample,"Test Plate Sample 1" <> $SessionUUID], Method -> Gravimetric, Upload -> False],
			False,
			Messages:>{}
		],
		Test["If a sample is in a plate and Method -> Gravimetric, throw an UnmeasurableContainer error (Plate with only one content):",
			ValidExperimentMeasureVolumeQ[Object[Sample,"Test Plate Sample 2" <> $SessionUUID], Method -> Gravimetric, Upload -> False],
			False,
			Messages:>{}
		],
		Test["Silently removes any immobile containers if there is a parent protocol:",
			ValidExperimentMeasureVolumeQ[
				{Object[Container,Vessel,"Measure Volume Immobile Container"<> $SessionUUID],Object[Container,Vessel,"Measure Volume Non Immobile Container"<> $SessionUUID]},
				ParentProtocol->Object[Protocol,HPLC,"Parent Protocol for ExperimentMeasureVolume testing" <> $SessionUUID]
			],
			True,
			Messages:>{}
		],
		Example[{Messages,ImmobileSamples,"Immobile containers cannot have their volumes measured:"},
			ValidExperimentMeasureVolumeQ[
				{Object[Container,Vessel,"Measure Volume Immobile Container 2" <> $SessionUUID],Object[Container,Vessel,"Measure Volume Non Immobile Container 2" <> $SessionUUID]}
			],
			False,
			Messages:>{}
		],
		Example[{Options,PreparatoryUnitOperations,"Transfer water to a tube and make sure the amount transfer matches what was requested:"},
			ValidExperimentMeasureVolumeQ[
				"My 2mL Tube",
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "My 2mL Tube",
						Container -> Model[Container, Vessel, "2mL Tube"]
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Destination -> "My 2mL Tube",
						Amount -> 1.75 Milliliter
					]
				},
				Method -> Gravimetric
			],
			True
		],
		Example[
			{Options,PreparatoryUnitOperations,"Add ethanol to a 50 milliliter tube, fill to 45 milliliters with dH2O, and then measure the volume:"},
			ValidExperimentMeasureVolumeQ[
				{"My 50mL Tube"},
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "My 50mL Tube",
						Container -> Model[Container, Vessel, "50mL Tube"]
					],
					Transfer[
						Source -> {Model[Sample, "Ethanol, Reagent Grade"]},
						Destination -> "My 50mL Tube",
						Amount -> 7.5 Milliliter
					],
					FillToVolume[
						Sample -> "My 50mL Tube",
						Solvent -> Model[Sample, "id:8qZ1VWNmdLBD"],
						TotalVolume -> 45 Milliliter
					],
					Mix[
						Sample -> "My 50mL Tube",
						MixType -> Vortex
					]
				}
			],
			True
		],
		Example[
			{Options,PreparatoryUnitOperations,"Add a stocksolution to a bottle for preparation, then aliquot from it and measure the volume on those aliquots:"},
			ValidExperimentMeasureVolumeQ[
				{"My 4L Bottle","My 4L Bottle","My 4L Bottle"},
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "My 4L Bottle",
						Container -> Model[Container, Vessel, "Amber Glass Bottle 4 L"]
					],
					Transfer[
						Source -> {Model[Sample, StockSolution, "id:o1k9jAGPOW1x"]},
						Destination -> "My 4L Bottle",
						Amount -> 3.5 Liter
					]
				},
				Aliquot -> True,
				AssayVolume -> {45 Milliliter, 45 Milliliter, 1 Liter},
				AliquotContainer -> {
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "Amber Glass Bottle 4 L"]
				}
			],
			True
		]
	},
	SymbolSetUp:>{
		$CreatedObjects = {};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects={
				Object[Container,Plate,"Measure Volume Test Plate" <> $SessionUUID],
				Object[Container,Plate,"Measure Volume Test Plate2" <> $SessionUUID],
				Object[Sample,"Measure Volume Test Sample" <> $SessionUUID],
				Object[Sample,"Measure Volume Test Sample2" <> $SessionUUID],
				Object[Sample,"Measure Volume Test Water Sample" <> $SessionUUID],
				Object[Sample,"Measure Volume Another Water Samp" <> $SessionUUID],
				Object[Sample,"Test Plate Sample 1" <> $SessionUUID],
				Object[Sample,"Test Plate Sample 2" <> $SessionUUID],
				Object[Sample,"Test Plate Sample 3" <> $SessionUUID],
				Object[Sample,"Measure Volume Test Sample No Density" <> $SessionUUID],
				Object[Sample,"Measure Volume Test Sample No Density And Low Volume" <> $SessionUUID],
				Object[Sample,"Measure Volume Test Acetone Sample" <> $SessionUUID],
				Object[Sample,"Measure Volume Test Sample In Bad Container" <> $SessionUUID],
				Object[Sample,"Test Discarded Sample No Container" <> $SessionUUID],
				Object[Sample,"Measure Volume Test Sample Null CalibrationContainer" <> $SessionUUID],
				Object[Sample,"Measure Volume Test Sample In Tube Without Tare" <> $SessionUUID],
				Object[Sample,"Measure Volume Ampoule Samp" <> $SessionUUID],
				Object[Protocol,SampleManipulation,"A test Parent Protocol for ExperimentMeasureVolume testing" <> $SessionUUID],
				Model[Sample,"MeasureVolume Test Model No Density" <> $SessionUUID],
				Model[Container,Vessel,"Measure Volume Untared Vessel Model" <> $SessionUUID],
				Object[Calibration,Volume,"Measure Volume Test Valid Volume Calibration" <> $SessionUUID],
				Object[Sample,"Measure Volume Test Bad Sample" <> $SessionUUID],
				Model[Sample,StockSolution,"MeasureVolume Bad Test Model" <> $SessionUUID],
				Object[Qualification,HPLC,"A test Parent Qualification for ExperimentMeasureVolume testing" <> $SessionUUID],
				Object[Container,Rack,"MeasureVolume Test Sticky Rack" <> $SessionUUID],
				Object[Container,Vessel,"MeasureVolume Water Tube" <> $SessionUUID],
				Object[Container,Vessel,"MeasureVolume Water Tube2" <> $SessionUUID],
				Object[Instrument,LiquidLevelDetector,"MeasureVolume Test VolumeCheck" <> $SessionUUID],
				Object[Container,Vessel,"Measure Volume Immobile Container"<> $SessionUUID],
				Object[Container,Vessel,"Measure Volume Non Immobile Container"<> $SessionUUID],
				Object[Container,Vessel,"Measure Volume Immobile Container 2" <> $SessionUUID],
				Object[Container,Vessel,"Measure Volume Non Immobile Container 2" <> $SessionUUID],
				Object[Protocol,HPLC,"Parent Protocol for ExperimentMeasureVolume testing" <> $SessionUUID],
				Object[Container,Vessel,VolumetricFlask,"MeasureVolume Ethanol Tube" <> $SessionUUID],
				Object[Sample,"Measure Volume Ethanol Samp" <> $SessionUUID],
				Model[Sample,StockSolution,"Measure Volume Ethanol StockSolution" <> $SessionUUID],
				Object[Sample,"MeasureVolume Sample in Plate Without Calibration" <> $SessionUUID],
				Object[Sample,"MeasureVolume Sample in Plate Without Calibration 2"<> $SessionUUID],
				Model[Container,Plate,"MeasureVolume Test Model Plate No Volume Calibrations" <> $SessionUUID],
				Object[Container,Plate,"MeasureVolume Test Plate No Volume Calibrations" <> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects,DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];

		(* Create an ID for the Model[Container,Vessel] we're gonna make below*)
		{testNewModelID,testNewPlateModelID,testNewPlateID} = CreateID[
			{
				Model[Container,Vessel],
				Model[Container,Plate],
				Object[Container,Plate]
			}
		];

		(* Create some containers *)
		{
			(*1*)modelContainerNoTareWeight,
			(*2*)emptyContainer,
			(*3*)waterContainer1,
			(*4*)waterContainer2,
			(*5*)waterContainer3,
			(*6*)solidContainer,
			(*7*)taredTube,
			(*8*)taredTube2,
			(*9*)taredTube3,
			(*10*)taredTube4,
			(*11*)taredTube5,
			(*12*)taredTube6,
			(*13*)untaredTube,
			(*14*)untaredTube2,
			(*15*)ultrasonicIncompatibleTube,
			(*16*)testPlate,
			(*17*)testPlate2,
			(*18*)opaqueTubeNullCalibration,
			(*19*)testProtocolID,
			(*20*)testQualificationID,
			(*21*)modelNoDensity,
			(*22*)badTestModel,
			(*23*)validTestCalibration,
			(*24*)test2mlRack,
			(*25*)testLLD,
			(*26*)ampoule1,
			(*27*)untaredTube3,
			(*28*)testStockSModel,
			(*29*)testModelPlateNoCal,
			(*30*)testPlateNoCal
		} = Upload[{
			(*1*)<|Type->Model[Container,Vessel],Object->testNewModelID,Name->"Measure Volume Untared Vessel Model" <> $SessionUUID,Replace[Positions]->{<|Name->"A1",Footprint->Null,MaxWidth->(0.0111125*Meter),MaxDepth->(0.0111125*Meter),MaxHeight->(0.047625*Meter)|>},Replace[Dimensions]->{0.0111125*Meter,0.0111125*Meter,0.047625*Meter},DeveloperObject->True|>,
			(*2*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Position->"A1",Site->Link[$Site],DeveloperObject->True|>,
			(*3*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Position->"A2",Site->Link[$Site],DeveloperObject->True|>,
			(*4*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Position->"A12",Site->Link[$Site],DeveloperObject->True|>,
			(*5*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Position->"A3",Site->Link[$Site],DeveloperObject->True|>,
			(*6*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Position->"A4",Site->Link[$Site],DeveloperObject->True|>,
			(*7*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Name->"MeasureVolume Water Tube" <> $SessionUUID,Position->"B1",Site->Link[$Site],DeveloperObject->True,TareWeight -> 1.27*Gram|>,
			(*8*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Name->"MeasureVolume Water Tube2" <> $SessionUUID,Position->"B2",Site->Link[$Site],DeveloperObject->True,TareWeight -> 1.27*Gram|>,
			(*9*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Position->"B3",Site->Link[$Site],DeveloperObject->True,TareWeight -> 1.27*Gram|>,
			(*10*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Position->"B4",Site->Link[$Site],DeveloperObject->True,TareWeight -> 1.27*Gram|>,
			(*11*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Position->"B5",Site->Link[$Site],DeveloperObject->True,TareWeight -> 1.27*Gram|>,
			(*12*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,TareWeight -> 1.27*Gram|>,
			(*13*)<|Type->Object[Container,Vessel],Model->Link[testNewModelID,Objects],Site->Link[$Site],DeveloperObject->True|>,
			(*14*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Position->"B6",Site->Link[$Site],DeveloperObject->True|>,
			(*15*)<|Type->Object[Container,Vessel],Model->Link[Model[Container, Vessel, "id:qdkmxz0A88LM"],Objects],Position->"C1",Site->Link[$Site],DeveloperObject->True|>,
			(*16*)<|Type->Object[Container,Plate],Model->Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Objects],Name->"Measure Volume Test Plate" <> $SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
			(*17*)<|Type->Object[Container,Plate],Model->Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Objects],Name->"Measure Volume Test Plate2" <> $SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
			(*18*)<|Type->Object[Container,Vessel],Model->Link[Model[Container, Vessel, "id:6V0npvmKLK9q"],Objects],Position->"D1",Site->Link[$Site],DeveloperObject->True|>,
			(*19*)<|Type->Object[Protocol,SampleManipulation],Name->"A test Parent Protocol for ExperimentMeasureVolume testing" <> $SessionUUID,Status->Processing,DeveloperObject->True|>,
			(*20*)<|Type->Object[Qualification,HPLC],Name->"A test Parent Qualification for ExperimentMeasureVolume testing" <> $SessionUUID,Status->Processing,DeveloperObject->True|>,
			(*21*)<|Type->Model[Sample],DefaultStorageCondition->Link[Model[StorageCondition,"id:7X104vnR18vX"]],Name->"MeasureVolume Test Model No Density" <> $SessionUUID,UltrasonicIncompatible->True,DeveloperObject->True|>,
			(*22*)<|Type->Model[Sample,StockSolution],DefaultStorageCondition->Link[Model[StorageCondition,"id:7X104vnR18vX"]],Name->"MeasureVolume Bad Test Model" <> $SessionUUID,UltrasonicIncompatible->True,Density->(1Kilogram/Meter^3),DeveloperObject->True|>,
			(*23*)<|Type->Object[Calibration,Volume],Replace[ContainerModels]->{Link[testNewModelID,VolumeCalibrations]},Name->"Measure Volume Test Valid Volume Calibration" <> $SessionUUID,LiquidLevelDetector->Link[Object[Instrument,LiquidLevelDetector,"id:AEqRl954G3lW"]],LiquidLevelDetectorModel->Link[Model[Instrument,LiquidLevelDetector,"id:zGj91aR3d5b6"]]|>,
			(*24*)<|Type->Object[Container,Rack],Model->Link[Model[Container,Rack,"id:BYDOjv1VAAml"],Objects],Site->Link[$Site],DeveloperObject->True|>,
			(*25*)<|Type->Object[Instrument,LiquidLevelDetector],Model->Link[Model[Instrument,LiquidLevelDetector,"VolumeCheck 100"],Objects],Status->Running,Site->Link[$Site],DeveloperObject->True|>,
			(*26*)<|Type->Object[Container,Vessel],Model->Link[Model[Container, Vessel, "id:o1k9jAKOwwwm"],Objects],Site->Link[$Site],DeveloperObject->True|>,
			(*27*)<|Type->Object[Container,Vessel,VolumetricFlask],Model->Link[Model[Container, Vessel, VolumetricFlask, "id:E8zoYvNOYlnA"],Objects],Name -> "MeasureVolume Ethanol Tube" <> $SessionUUID,Site->Link[$Site],DeveloperObject->True,TareWeight -> 1.27*Gram|>,
			(*28*)<|Type->Model[Sample,StockSolution],DefaultStorageCondition->Link[Model[StorageCondition,"id:7X104vnR18vX"]],Name->"Measure Volume Ethanol StockSolution" <> $SessionUUID,UltrasonicIncompatible->True,Density->Null,DeveloperObject->True|>,
			(*29*)<|Type->Model[Container,Plate],Object->testNewPlateModelID,Name->"MeasureVolume Test Model Plate No Volume Calibrations" <> $SessionUUID,Replace[Positions]->{<|Name->"A1",Footprint->Null,MaxWidth->0.00825Meter,MaxDepth->0.00825Meter,MaxHeight->0.0374Meter|>, <|Name->"B1",Footprint->Null,MaxWidth->0.00825Meter,MaxDepth->0.00825Meter,MaxHeight->0.0374Meter|>},Footprint->Plate,DeveloperObject->True|>,
			(*30*)<|Type->Object[Container,Plate],Object->testNewPlateID,Model->Link[testNewPlateModelID,Objects],Name->"MeasureVolume Test Plate No Volume Calibrations" <> $SessionUUID,Site->Link[$Site],DeveloperObject->True|>
		}];

		(* Create some samples *)
		{
			(*1*)discardedChemical,
			(*2*)waterSample,
			(*3*)waterSample2,
			(*4*)waterSampleInContainerNullCalibration,
			(*5*)sampleWithDensity1,
			(*6*)sampleWithDensity2,
			(*7*)sampleInTubeWithoutTare,
			(*8*)sampleWithoutDensity,
			(*9*)sampleNoDensityLowVol,
			(*10*)ultrasonicIncompatibleSample,
			(*11*)ultrasonicIncompatibleSample2,
			(*12*)sampleInUltrasonicIncompatibleTube,
			(*13*)plateSamp1,
			(*14*)plateSamp2,
			(*15*)plateSamp3,
			(*16*)solidSample,
			(*17*)ampouleSamp,
			(*18*)waterSamp3,
			(*19*)ethSamp,
			(*20*)waterSampPlateNoCalibration,
			(*21*)waterSampPlateNoCalibration2
		} = ECL`InternalUpload`UploadSample[
			{
				(*1*)Model[Sample,"Milli-Q water"],
				(*2*)Model[Sample,"Milli-Q water"],
				(*3*)Model[Sample,"Milli-Q water"],
				(*4*)Model[Sample,"Milli-Q water"],
				(*5*)Model[Sample,"Milli-Q water"],
				(*6*)Model[Sample,"Milli-Q water"],
				(*7*)Model[Sample,"Milli-Q water"],
				(*8*)Model[Sample,"MeasureVolume Test Model No Density" <> $SessionUUID],
				(*9*)Model[Sample,"Milli-Q water"],
				(*10*)Model[Sample,"Acetone, Reagent Grade"],
				(*11*)Model[Sample,StockSolution,"MeasureVolume Bad Test Model" <> $SessionUUID],
				(*12*)Model[Sample,"Milli-Q water"],
				(*13*)Model[Sample,"Milli-Q water"],
				(*14*)Model[Sample,"Milli-Q water"],
				(*15*)Model[Sample,"id:rea9jl1X4N3b"],
				(*16*)Model[Sample,"Ammonium Bicarbonate"],
				(*17*)Model[Sample,"Milli-Q water"],
				(*18*)Model[Sample,"Milli-Q water"],
				(*19*)Model[Sample, StockSolution,"Measure Volume Ethanol StockSolution" <> $SessionUUID],
				(*20*)Model[Sample,"Milli-Q water"],
				(*21*)Model[Sample,"Milli-Q water"]
			},
			{
				(*1*){"A1",waterContainer1},
				(*2*){"A1",waterContainer2},
				(*3*){"A1",waterContainer3},
				(*4*){"A1",opaqueTubeNullCalibration},
				(*5*){"A1",taredTube},
				(*6*){"A1",untaredTube},
				(*7*){"A1",untaredTube2},
				(*8*){"A1",taredTube6},
				(*9*){"A1",taredTube3},
				(*10*){"A1",taredTube4},
				(*11*){"A1",testPlate2},
				(*12*){"A1",ultrasonicIncompatibleTube},
				(*13*){"A1",testPlate},
				(*14*){"A2",testPlate2},
				(*15*){"A3",testPlate},
				(*16*){"A1",solidContainer},
				(*17*){"A1",ampoule1},
				(*18*){"A1",taredTube2},
				(*19*){"A1",untaredTube3},
				(*20*){"A1",testPlateNoCal},
				(*21*){"B1",testPlateNoCal}
			},
			InitialAmount->{
				(*1*)45 Milliliter,
				(*2*)50 Milliliter,
				(*3*)40 Milliliter,
				(*4*)50 Milliliter,
				(*5*)1.5 Milliliter,
				(*6*)1.5 Milliliter,
				(*7*)1.25 Milliliter,
				(*8*)351 Microliter,
				(*9*)6 Microliter,
				(*10*)1.5 Milliliter,
				(*11*)1.5 Milliliter,
				(*12*)1.5 Milliliter,
				(*13*)1.5 Milliliter,
				(*14*)1 Milliliter,
				(*15*)0.5 Milliliter,
				(*16*)5 Gram,
				(*17*)0.75 Milliliter,
				(*18*)1.75 Milliliter,
				(*19*)1Milliliter,
				(*20*)1Milliliter,
				(*21*)1Milliliter
			},
			StorageCondition -> Refrigerator
		];

		(* Secondary uploads *)
		Upload[{
			<|
				Type -> Object[Calibration, Volume],
				BufferModel -> Link[Model[Sample, "Milli-Q water"]],
				CalibrationDistributionFunction -> QuantityFunction[Function[{x}, x], {Millimeter}, 1],
				CalibrationFunction -> QuantityFunction[Function[{x}, x], {Millimeter}, Milliliter],
				Append[ContainerModels] -> {Link[Model[Container, Vessel, "id:6V0npvmKLK9q"], VolumeCalibrations]},
				ManufacturerCalibration -> True,
				VolumeSensorModel -> Link[Model[Sensor, Volume, "id:eGakld0bbMVq"]]
			|>,
			<|Object->waterSample,Name->"Measure Volume Test Sample" <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->waterSampleInContainerNullCalibration,Name->"Measure Volume Test Sample Null CalibrationContainer" <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->sampleWithDensity1,Name->"Measure Volume Test Water Sample" <> $SessionUUID,Density->1*(Gram/Milliliter),Status->Available,DeveloperObject->True|>,
			<|Object->sampleInTubeWithoutTare,Name->"Measure Volume Test Sample In Tube Without Tare" <> $SessionUUID,Density->1*(Gram/Milliliter),Status->Available,DeveloperObject->True|>,
			<|Object->sampleWithDensity2,Density->1*(Gram/Milliliter),Status->Available,DeveloperObject->True|>,
			<|Object->sampleWithoutDensity,Name->"Measure Volume Test Sample No Density" <> $SessionUUID,Volume->350*Microliter,Status->Available,DeveloperObject->True|>,
			<|Object->sampleNoDensityLowVol,Name->"Measure Volume Test Sample No Density And Low Volume" <> $SessionUUID,Volume->5*Microliter,Status->Available,DeveloperObject->True|>,
			<|Object->ultrasonicIncompatibleSample,Name->"Measure Volume Test Acetone Sample" <> $SessionUUID,Density->0.791*(Gram/Milliliter),Status->Available,DeveloperObject->True|>,
			<|Object->ultrasonicIncompatibleSample2,Name->"Measure Volume Test Bad Sample" <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->sampleInUltrasonicIncompatibleTube,Name->"Measure Volume Test Sample In Bad Container" <> $SessionUUID,Density->0.791*(Gram/Milliliter),Status->Available,DeveloperObject->True|>,
			<|Object->plateSamp1,Name->"Test Plate Sample 1" <> $SessionUUID,Density->1*(Gram/Milliliter),Status->Available,DeveloperObject->True|>,
			<|Object->plateSamp2,Name->"Test Plate Sample 2" <> $SessionUUID,Density->1*(Gram/Milliliter),Status->Available,DeveloperObject->True|>,
			<|Object->plateSamp3,Name->"Test Plate Sample 3" <> $SessionUUID,Concentration->10*Micromolar,Status->Available,DeveloperObject->True|>,
			<|Type->Object[Sample],Name->"Test Discarded Sample No Container" <> $SessionUUID,Volume->1.5Milliliter,Density->1*(Gram/Milliliter),Model->Link[Model[Sample,"Milli-Q water"],Objects],Status->Discarded,DeveloperObject->True|>,
			<|Object->discardedChemical,Status->Discarded,DeveloperObject->True|>,
			<|Object->test2mlRack,Name->"MeasureVolume Test Sticky Rack" <> $SessionUUID,Status->InUse,Position->"Plate Slot",Replace[Contents]->{{"B1",Link[taredTube,Container]},{"B2",Link[taredTube2,Container]}}|>,
			<|Object->testLLD,Name->"MeasureVolume Test VolumeCheck" <> $SessionUUID,Append[Contents]->{{"Plate Slot",Link[test2mlRack,Container]}}|>,
			<|Object->waterSample2,Name->"Measure Volume Test Sample2" <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->ampouleSamp,Name->"Measure Volume Ampoule Samp" <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->waterSamp3,Name->"Measure Volume Another Water Samp" <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->ethSamp,Name->"Measure Volume Ethanol Samp" <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->waterSampPlateNoCalibration,Name->"MeasureVolume Sample in Plate Without Calibration" <> $SessionUUID,Model->Null,DeveloperObject->True|>,
			<|Object->waterSampPlateNoCalibration2,Name->"MeasureVolume Sample in Plate Without Calibration 2"<> $SessionUUID,Model->Null,DeveloperObject->True|>
		}];

		(* Upload 50 2ml tubes for batching checks *)
		myMV2mLSet = ConstantArray[
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True|>,
			50
		];

		myMV2mLTubes = Upload[myMV2mLSet];

		ECL`InternalUpload`UploadSample[
			ConstantArray[Model[Sample,"Milli-Q water"],Length[myMV2mLTubes]],
			{"A1",#}&/@myMV2mLTubes,
			InitialAmount -> ConstantArray[300*Microliter,Length[myMV2mLTubes]],
			StorageCondition -> Refrigerator
		];

		immobileSetUp = Module[{modelVesselID,model,vessel1,vessel2,protocol},

			modelVesselID=CreateID[Model[Container,Vessel]];
			{model,vessel1,vessel2,protocol}=Upload[{
				<|
					Object->modelVesselID,
					Replace[Positions] ->{<|Name -> "A1", Footprint -> Null,MaxWidth -> .1 Meter,MaxDepth -> .1 Meter,MaxHeight -> .1 Meter|>},
					Immobile->True
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[modelVesselID,Objects],
					DeveloperObject->True,
					Name->"Measure Volume Immobile Container"<> $SessionUUID,
					Site->Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],
					DeveloperObject->True,
					Name->"Measure Volume Non Immobile Container"<> $SessionUUID,
					Site->Link[$Site]
				|>,
				<|
					Type->Object[Protocol,HPLC],
					Name->"Parent Protocol for ExperimentMeasureVolume testing" <> $SessionUUID
				|>
			}];

			UploadSample[{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},{{"A1",vessel1},{"A1",vessel2}}];
		];

		immobileSetUp2 = Module[{modelVesselID,model,vessel1,vessel2},

			modelVesselID=CreateID[Model[Container,Vessel]];
			{model,vessel1,vessel2}=Upload[{
				<|
					Object->modelVesselID,
					Replace[Positions] ->{<|Name -> "A1", Footprint -> Null,MaxWidth -> .1 Meter,MaxDepth -> .1 Meter,MaxHeight -> .1 Meter|>},
					Immobile->True
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[modelVesselID,Objects],
					DeveloperObject->True,
					Name->"Measure Volume Immobile Container 2" <> $SessionUUID,
					TareWeight->10 Gram,
					Site -> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],
					DeveloperObject->True,
					Name->"Measure Volume Non Immobile Container 2" <> $SessionUUID,
					TareWeight->10 Gram,
					Site -> Link[$Site]
				|>
			}];

			UploadSample[{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},{{"A1",vessel1},{"A1",vessel2}}];
		];
	},
	Stubs :> {$PersonID = Object[User, "Test user for notebook-less test protocols"]},

	SymbolTearDown :> {
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		(* Erase all objects that were created in the course of these tests *)
		EraseObject[
			PickList[	$CreatedObjects,
				DatabaseMemberQ[$CreatedObjects]
			],
			Force->True,
			Verbose->False
		];
		(* Cleanse $CreatedObjects *)
		Unset[$CreatedObjects];
	}
]
