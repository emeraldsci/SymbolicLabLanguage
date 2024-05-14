(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentDilute*)


DefineTests[ExperimentDilute,
	{
		Example[{Basic, "Generate a new protocol to dilute a sample:"},
			ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume -> 200 Microliter],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Basic, "Generate a new protocol to dilute a sample robotically:"},
			ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume -> 200 Microliter,MixType->Pipette],
			ObjectP[Object[Protocol, RoboticSamplePreparation]]
		],
		Example[{Basic, "Generate a new protocol to dilute multiple samples:"},
			ExperimentDilute[{Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID]}, TotalVolume -> 200 Microliter],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Basic, "Generate a new protocol to dilute multiple specified as containers:"},
			ExperimentDilute[{Object[Container, Vessel, "Fake container 1 for ExperimentDilute tests"<> $SessionUUID], Object[Container, Vessel, "Fake container 2 for ExperimentDilute tests"<> $SessionUUID], Object[Container, Vessel, "Fake container 3 for ExperimentDilute tests"<> $SessionUUID]}, TotalVolume -> 300 Microliter],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Test["Ensure that manipulations are properly generated when diluting in the current container:",
			prot = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume -> 200 Microliter];
			Download[prot, OutputUnitOperations],
			_?(And[
				MemberQ[#, ObjectP[Object[UnitOperation, LabelContainer]]],
				MemberQ[#, ObjectP[Object[UnitOperation, LabelSample]]],
				MemberQ[#, ObjectP[Object[UnitOperation, Transfer]]],
				MemberQ[#, ObjectP[{Object[UnitOperation, Mix],Object[UnitOperation, Incubate]}]]
			]&),
			Variables :> {prot}
		],
		Test["Ensure that robotic manipulations are properly generated when diluting in the current container:",
			prot = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume -> 200 Microliter,MixType->Pipette];
			Download[prot, OutputUnitOperations[[1]][RoboticUnitOperations]],
			_?(And[
				MemberQ[#, ObjectP[Object[UnitOperation, LabelContainer]]],
				MemberQ[#, ObjectP[Object[UnitOperation, LabelSample]]],
				MemberQ[#, ObjectP[Object[UnitOperation, Transfer]]]
			]&),
			Variables :> {prot}
		],
		Test["If diluting two things in the same container and MixOrder -> Parallel, only do one Incubate primitive for the both of them (but a separate one for a separate sample):",
			prot = ExperimentDilute[
				{
					Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID],
					Object[Sample, "ExperimentDilute New Test Chemical In Plate 2 (100 uL)"<> $SessionUUID],
					Object[Sample, "ExperimentDilute New Test Chemical In Plate 3 (100 uL)"<> $SessionUUID]
				},
				TotalVolume -> 200 Microliter,
				MixOrder -> Parallel
			];
			Download[prot, OutputUnitOperations],
			_?(And[
				MemberQ[#, ObjectP[Object[UnitOperation, LabelContainer]]],
				MemberQ[#, ObjectP[Object[UnitOperation, LabelSample]]],
				MemberQ[#, ObjectP[Object[UnitOperation, Transfer]]],
				MemberQ[#, ObjectP[{Object[UnitOperation, Mix],Object[UnitOperation, Incubate]}]]
			]&),
			Variables :> {prot}
		],
		Test["Ensure that manipulations are properly generated when diluting in the a different container:",
			prot = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Amount -> 50 Microliter, TotalVolume -> 200 Microliter];
			Download[prot, OutputUnitOperations],
			_?(And[
				MemberQ[#, ObjectP[Object[UnitOperation, LabelContainer]]],
				MemberQ[#, ObjectP[Object[UnitOperation, LabelSample]]],
				MemberQ[#, ObjectP[Object[UnitOperation, Transfer]]],
				MemberQ[#, ObjectP[{Object[UnitOperation, Mix],Object[UnitOperation, Incubate]}]]
			]&),
			Variables :> {prot}
		],
		Test["Ensure that manipulations are properly generated when diluting in a different container and check the volumes:",
			prot = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Amount -> 50 Microliter, TotalVolume -> 200 Microliter];
			manips = Download[prot, OutputUnitOperations];
			{transferManip1, transferManip2} = Cases[manips, ObjectP[Object[UnitOperation, Transfer]]];
			{transferManip1[Amount], transferManip2[Amount]},
			{{350 Microliter}, {200 Microliter}},
			EquivalenceFunction -> Equal,
			Variables :> {prot, manips, transferManip1, transferManip2}
		],
		Test["Ensure that manipulations are properly generated when diluting two different samples, one in the same container and one in another:",
			prot = ExperimentDilute[{Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID]}, Amount -> {All, 20 Microliter}, TotalVolume -> 200 Microliter];
			Download[prot, OutputUnitOperations],
			_?(And[
				MemberQ[#, ObjectP[Object[UnitOperation, LabelContainer]]],
				MemberQ[#, ObjectP[Object[UnitOperation, LabelSample]]],
				MemberQ[#, ObjectP[Object[UnitOperation, Transfer]]],
				MemberQ[#, ObjectP[{Object[UnitOperation, Mix],Object[UnitOperation, Incubate]}]]
			]&),
			Variables :> {prot}
		],
		Test["Ensure that manipulations are properly generated when mixing by pipette:",
			prot = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume -> 200 Microliter, MixType -> Pipette];
			Download[prot, OutputUnitOperations[RoboticUnitOperations]],
			{_?(And[
				MemberQ[#, ObjectP[Object[UnitOperation, LabelContainer]]],
				MemberQ[#, ObjectP[Object[UnitOperation, LabelSample]]],
				MemberQ[#, ObjectP[Object[UnitOperation, Transfer]]]
			]&)},
			Variables :> {prot}
		],
		Example[{Options, Amount, "Specify how much sample to dilute:"},
			options = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Amount -> 50 Microliter, TotalVolume -> 100 Microliter,Output->Options];
			Lookup[options, Amount],
			50 Microliter,
			Variables :> {options},
			EquivalenceFunction -> Equal
		],
		Example[{Options, Amount, "If Amount is not specified, automatically set to the full amount of the sample:"},
			options = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume -> 200 Microliter,Output->Options];
			Lookup[options, Amount],
			100 Microliter,
			Variables :> {options},
			EquivalenceFunction -> Equal
		],
		Example[{Options, TargetConcentration, "If TargetConcentration is set for a sample with an analyte in it that is a molar concentration, calculate the volumes properly:"},
			options = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 3 (200 uL)"<> $SessionUUID], TargetConcentration -> 100 Millimolar, TargetConcentrationAnalyte -> Model[Molecule, "Dibasic Sodium Phosphate"], Output -> Options];
			Lookup[options, {TargetConcentration, TotalVolume}],
			{100 Millimolar, VolumeP},
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "If TargetConcentration is set for a solid and MolecularWeight is not populated populated for this model but a mass concentration was provided, calculate the volumes properly:"},
			options = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 9 (200 uL)"<> $SessionUUID], TargetConcentration -> 0.04 *Milligram/Milliliter, TargetConcentrationAnalyte -> Model[Molecule, Protein, "T7 RNA Polymerase"], Output -> Options];
			Lookup[options, {TargetConcentration, TotalVolume}],
			{0.04 *Milligram/Milliliter, VolumeP},
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "Specify which component of sample to set to the specified target concentration:"},
			options = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 9 (200 uL)"<> $SessionUUID], TargetConcentration -> 25 Millimolar, TargetConcentrationAnalyte -> Model[Molecule, "Tris-Hydrochloride"], Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, "Tris-Hydrochloride"]],
			Variables :> {options}
		],
		Example[{Options, TotalVolume, "Specify the amount of liquid to add to the samples:"},
			options = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume -> 1 Milliliter,Output->Options];
			Lookup[options, TotalVolume],
			1 Milliliter,
			Variables :> {options},
			EquivalenceFunction -> Equal
		],
		Example[{Options, TotalVolume, "Specify the amount of liquid to add to the samples:"},
			prot = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume -> 1 Milliliter];
			FirstCase[Download[prot, OutputUnitOperations], ObjectP[Object[UnitOperation, Transfer]]][Amount],
			{900 Microliter},
			Variables :> {prot},
			EquivalenceFunction -> Equal
		],
		Example[{Options, ContainerOut, "Specify the container in which to dilute the samples:"},
			options = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], ContainerOut -> Model[Container, Vessel, "50mL Tube"], TotalVolume -> 1.5 Milliliter,Output->Options];
			Lookup[options, ContainerOut],
			{1,ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, ContainerOut, "Specify the container in which to dilute the samples:"},
			prot = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], ContainerOut -> Model[Container, Vessel, "50mL Tube"], TotalVolume -> 1.5 Milliliter];
			FirstCase[Download[prot, OutputUnitOperations], ObjectP[Object[UnitOperation, LabelContainer]]][Container],
			{ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {prot}
		],
		Example[{Options, ContainerOut, "If not specified, ContainerOut is automatically set to the current container of the specified samples:"},
			prot = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume -> 1 Milliliter];
			FirstCase[Download[prot, OutputUnitOperations], ObjectP[Object[UnitOperation, LabelContainer]]][Container],
			{ObjectP[Object[Container, Vessel, "Fake container 1 for ExperimentDilute tests"<> $SessionUUID]]},
			Variables :> {prot}
		],
		Example[{Options, DestinationWell, "Specify the position in the specified container in which to dilute the samples:"},
			options = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], DestinationWell -> "A2", ContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], TotalVolume -> 1 Milliliter, Output -> Options];
			Lookup[options, DestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, Diluent, "Specify the solvent in which to dissolve the provided sample:"},
			prot = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID], Diluent -> Model[Sample, "Methanol"], TotalVolume -> 1 Milliliter];
			LookupLabeledObject[prot,FirstCase[Download[prot, OutputUnitOperations], ObjectP[Object[UnitOperation, Transfer]]][Source]],
			{ObjectP[Model[Sample, "Methanol"]]},
			Variables :> {prot}
		],
		Example[{Options, ConcentratedBuffer, "Specify the concentrated buffer to be diluted that should dilute the provided sample:"},
			prot = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], TotalVolume -> 1 Milliliter];
			LookupLabeledObject[prot,FirstCase[Download[prot, OutputUnitOperations], ObjectP[Object[UnitOperation, Transfer]]][Source][[2]]],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {prot}
		],
		Example[{Options, BufferDiluent, "Specify the sample to dilute the concentrated buffer that should dissolve the provided sample:"},
			prot = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], BufferDiluent -> Model[Sample, "Milli-Q water"], TotalVolume -> 1 Milliliter];
			LookupLabeledObject[prot,FirstCase[Download[prot, OutputUnitOperations], ObjectP[Object[UnitOperation, Transfer]]][Source][[1]]],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {prot},
			SetUp :> {
				InternalUpload`Private`$UploadSampleTransferSolventDilutionLookup = Association[];
				InternalUpload`Private`$UploadSampleTransferSolventMixtureLookup = Association[];
				InternalUpload`Private`$UploadSampleTransferMediaMixtureLookup = Association[];
			}
		],
		Example[{Options, BufferDilutionFactor, "Specify the factor by which to dilute the concentrated buffer that should dissolve the provided sample:"},
			prot = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, TotalVolume -> 1 Milliliter];
			(Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID][Volume] + FirstCase[Download[prot, OutputUnitOperations], ObjectP[Object[UnitOperation, Transfer]]][Amount][[2]] + FirstCase[Download[prot, OutputUnitOperations], ObjectP[Object[UnitOperation, Transfer]]][Amount][[1]])/ FirstCase[Download[prot, OutputUnitOperations], ObjectP[Object[UnitOperation, Transfer]]][Amount][[2]],
			10.`,
			EquivalenceFunction -> Equal,
			Variables :> {prot},
			SetUp :> {
				InternalUpload`Private`$UploadSampleTransferSolventDilutionLookup = Association[];
				InternalUpload`Private`$UploadSampleTransferSolventMixtureLookup = Association[];
				InternalUpload`Private`$UploadSampleTransferMediaMixtureLookup = Association[];
			}
		],
		Example[{Options, Mix, "Indicate if the samples should (or should not) be mixed after addition of liquid:"},
			options = ExperimentDilute[{Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID]}, Mix -> {False, True}, TotalVolume -> 1 Milliliter, Output -> Options];
			Lookup[options, Mix],
			{False, True},
			Variables :> {options}
		],
		Example[{Options, MixType, "Indicate by what method the samples should be mixed after the addition of liquid:"},
			options = ExperimentDilute[{Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID]}, MixType -> {Pipette, Vortex}, TotalVolume -> 1 Milliliter, Output -> Options];
			Lookup[options, MixType],
			{Pipette, Vortex},
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Indicate if the samples should be mixed until they are dissolved:"},
			options = ExperimentDilute[{Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID]}, MixUntilDissolved -> True, MixType -> Vortex, TotalVolume -> 1 Milliliter, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],
		Example[{Options, NumberOfMixes, "Indicate how many times the samples should be mixed:"},
			options = ExperimentDilute[{Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID]}, TotalVolume -> 0.9 Milliliter, MixType -> Pipette, NumberOfMixes -> 5, Output -> Options];
			Lookup[options, NumberOfMixes],
			5,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Indicates the length of time samples should be mixed and/or heated:"},
			options = ExperimentDilute[{Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID]}, IncubationTime -> 10 Minute, TotalVolume -> 1 Milliliter, Output -> Options];
			Lookup[options, IncubationTime],
			10 Minute,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Indicates the maximum length of time samples should be mixed and/or heated when mixing until dissolving:"},
			options = ExperimentDilute[{Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID]}, IncubationTime -> 10 Minute, MaxIncubationTime -> 30 Minute, TotalVolume -> 1 Milliliter, Output -> Options];
			Lookup[options, MaxIncubationTime],
			30 Minute,
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Indicates the minimum duration for which the sample should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed:"},
			options = ExperimentDilute[{Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID]}, IncubationTime -> 10 Minute, AnnealingTime -> 30 Minute, TotalVolume -> 1 Milliliter, Output -> Options];
			Lookup[options, AnnealingTime],
			30 Minute,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Indicates the temperature at which the specified samples should be held during incubation/mixing:"},
			options = ExperimentDilute[{Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID]}, IncubationTime -> 10 Minute, IncubationTemperature -> {Ambient, 40 Celsius}, TotalVolume -> 1 Milliliter, Output -> Options];
			Lookup[options, IncubationTemperature],
			{Ambient, 40 Celsius},
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "Indicates the instrument to use during mixing and/or incubating:"},
			options = ExperimentDilute[{Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID]}, IncubationInstrument -> Model[Instrument, Shaker, "Genie Temp-Shaker 300"], TotalVolume -> 1 Milliliter, Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument, Shaker, "Genie Temp-Shaker 300"]],
			Variables :> {options}
		],
		Example[{Options, Name, "Specify the name of the protocol object to be generated:"},
			prot = ExperimentDilute[{Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID]}, Name -> "ExperimentDilute Protocol 1", TotalVolume -> 1 Milliliter];
			Download[prot, Name],
			"ExperimentDilute Protocol 1",
			Variables :> {prot}
		],
		Example[{Options, Template, "Specify a protocol whose options to use for the current protocol:"},
			options = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Template -> Object[Protocol, ManualSamplePreparation, "Existing ExperimentDilute Protocol"<> $SessionUUID],Output->Options];
			Lookup[options, TotalVolume],
			123 Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, SamplesOutStorageCondition, "Specify the condition in which samples should be stored upon completion of the dilution experiment:"},
			options = ExperimentDilute[{Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID]}, TotalVolume -> 1 Milliliter, SamplesOutStorageCondition -> Freezer, Output -> Options];
			Lookup[options, SamplesOutStorageCondition],
			Freezer,
			Variables :> {options}
		],
		Example[{Options, MixOrder, "Specify whether the samples should be mixed after the liquid is added for all the samples (Parallel) or after liquid is added to each sample (Serial) 1:"},
			options = ExperimentDilute[{Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID]}, Amount -> {All, 50 Microliter}, TotalVolume -> 150 Microliter, MixOrder -> Parallel,Output->Options];
			Lookup[options, MixOrder],
			Parallel,
			Variables :> {options},
			SetUp :> {
				InternalUpload`Private`$UploadSampleTransferSolventDilutionLookup = Association[];
				InternalUpload`Private`$UploadSampleTransferSolventMixtureLookup = Association[];
				InternalUpload`Private`$UploadSampleTransferMediaMixtureLookup = Association[];
			}
		],
		Example[{Options, MixOrder, "Specify whether the samples should be mixed after the liquid is added for all the samples (Parallel) or after liquid is added to each sample (Serial) 2:"},
			prot = ExperimentDilute[{Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID]}, Amount -> {All, 50 Microliter}, TotalVolume -> 150 Microliter, MixOrder -> Parallel];
			Download[prot, OutputUnitOperations],
			_?(And[
				MemberQ[#, ObjectP[Object[UnitOperation, LabelContainer]]],
				MemberQ[#, ObjectP[Object[UnitOperation, LabelSample]]],
				MemberQ[#, ObjectP[Object[UnitOperation, Transfer]]],
				MemberQ[#, ObjectP[{Object[UnitOperation, Mix],Object[UnitOperation, Incubate]}]]
			]&),
			Variables :> {prot},
			SetUp :> {
				InternalUpload`Private`$UploadSampleTransferSolventDilutionLookup = Association[];
				InternalUpload`Private`$UploadSampleTransferSolventMixtureLookup = Association[];
				InternalUpload`Private`$UploadSampleTransferMediaMixtureLookup = Association[];
			}
		],
		Example[{Options, MixOrder, "Specify whether the samples should be mixed after the liquid is added for all the samples (Parallel) or after liquid is added to each sample (Serial) 3:"},
			prot = ExperimentDilute[{Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID]}, Amount -> {All, 50 Microliter}, TotalVolume -> 150 Microliter, MixOrder -> Parallel];
			Length@FirstCase[Download[prot, OutputUnitOperations], ObjectP[Object[UnitOperation, Transfer]]][Destination],
			2,
			Variables :> {prot},
			SetUp :> {
				InternalUpload`Private`$UploadSampleTransferSolventDilutionLookup = Association[];
				InternalUpload`Private`$UploadSampleTransferSolventMixtureLookup = Association[];
				InternalUpload`Private`$UploadSampleTransferMediaMixtureLookup = Association[];
			}
		],
		Example[{Options, ImageSample, "If ImageSample -> False, do not image the samples after the protocol is completed:"},
			prot = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume -> 1 Milliliter, ImageSample -> False];
			Download[prot, ImageSample],
			False|Null,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables :> {prot}
		],
		Example[{Options, MeasureVolume, "If MeasureVolume -> False, do not measure the volume of the samples after the protocol is completed:"},
			prot = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume -> 1 Milliliter, MeasureVolume -> False];
			Download[prot, MeasureVolume],
			False|Null,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables :> {prot}
		],
		Example[{Options, MeasureWeight, "If MeasureWeight -> False, do not measure the weight of the samples after the protocol is completed:"},
			prot = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume -> 1 Milliliter, MeasureWeight -> False];
			Download[prot, MeasureWeight],
			False|Null,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables :> {prot}
		],
		Example[{Options, SampleLabel, "Specify the label given to the input sample:"},
			options = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID],  TotalVolume -> 0.5 Milliliter,MixType -> Pipette,SampleLabel -> "Sample 1", Output -> Options, Preparation -> Robotic];
			Lookup[options, SampleLabel],
			"Sample 1",
			Variables :> {options}
		],
		Example[{Options, SampleLabel, "If not specified but in a work cell resolution, automatically set to some string:"},
			options = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID],  TotalVolume -> 0.5 Milliliter,Output -> Options, Preparation -> Robotic];
			Lookup[options, {SampleLabel, SampleContainerLabel}],
			{_String, _String},
			Variables :> {options}
		],
		Example[{Options, SampleContainerLabel, "Specify the container label given to the input sample:"},
			options = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], SampleContainerLabel -> "Container 1", TotalVolume->500Microliter,Output -> Options, Preparation -> Robotic];
			Lookup[options, SampleContainerLabel],
			"Container 1",
			Variables :> {options}
		],
		Example[{Options, SampleOutLabel, "Specify the sample label given to the sample out.  If not specified, set to a string:"},
			options = ExperimentDilute[
				{
					Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID],
					Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID]
				},
				SampleOutLabel -> {
					"SampleOut 1",
					Automatic
				},
				TotalVolume->0.9Milliliter,
				Output -> Options,
				Preparation -> Robotic
			];
			Lookup[options, SampleOutLabel],
			{"SampleOut 1", _String},
			Variables :> {options}
		],
		Example[{Options, ContainerOutLabel, "Specify the container label given to the container out.  If not specified, set to a string:"},
			options = ExperimentDilute[
				{
					Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID],
					Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID]
				},
				ContainerOutLabel -> {
					"ContainerOut 1",
					Automatic
				},
				TotalVolume->500Microliter,
				Output -> Options,
				Preparation -> Robotic
			];
			Lookup[options, ContainerOutLabel],
			{"ContainerOut 1", _String},
			Variables :> {options}
		],
		Example[{Options, DiluentLabel, "Specify the label given to the AssayBuffer:"},
			options = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Diluent -> Model[Sample, "Milli-Q water"], TotalVolume->500Microliter,DiluentLabel -> "Diluent 1", Output -> Options,Preparation -> Robotic];
			Lookup[options, DiluentLabel],
			"Diluent 1",
			Variables :> {options}
		],
		Example[{Options, DiluentLabel, "If not specified, set DiluentLabel to some string:"},
			options = ExperimentDilute[
				{
					Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID]
				},
				Diluent -> {
					Model[Sample, "Milli-Q water"]
				},
				TotalVolume -> 500 Microliter,
				Output -> Options,
				Preparation -> Robotic
			];
			Lookup[options, DiluentLabel],
			_String,
			Variables :> {options}
		],
		Example[{Options, BufferDiluentLabel, "Specify the label given to the BufferDiluent and ConcentratedBuffer:"},
			options = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume -> 500 Microliter, BufferDiluent -> Model[Sample, "Milli-Q water"], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], BufferDiluentLabel -> "Buffer Diluent 1", ConcentratedBufferLabel -> "Concentrated Buffer 1",Output -> Options, Preparation -> Robotic];
			Lookup[options, {BufferDiluentLabel, ConcentratedBufferLabel}],
			{"Buffer Diluent 1", "Concentrated Buffer 1"},
			Variables :> {options}
		],
		Example[{Options, ConcentratedBufferLabel, "If not specified, automatically set ConcentratedBufferLabel and BufferDiluentLabel to some string label if using those options, or Null otherwise:"},
			options = ExperimentDilute[
				{
					Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID],
					Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID]
				},
				BufferDiluent -> {
					Null,
					Model[Sample, "Milli-Q water"]
				},
				ConcentratedBuffer -> {
					Null,
					Model[Sample, StockSolution, "10x UV buffer"]
				},
				TotalVolume->500Microliter,
				MixType -> Pipette,
				Output -> Options,
				Preparation -> Robotic
			];
			Lookup[options, {BufferDiluentLabel, ConcentratedBufferLabel}],
			{
				{Null, _String},
				{Null, _String}
			},
			Variables :> {options}
		],
		Example[{Options, Preparation, "Set whether to use the liquid handlers or manual pipettes to perform this dilution:"},
			options = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume->1Milliliter, Output -> Options, Preparation -> Manual];
			Lookup[options, Preparation],
			Manual,
			Variables :> {options}
		],
		Example[{Messages, "DilutePreparationInvalid", "Thow an error if the specified preparation cannot be performed:"},
			ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume->1Milliliter, Preparation -> Robotic, MixType->Vortex],
			$Failed,
			Messages:>{
				Error::MixInstrumentTypeMismatch,
				Error::DilutePreparationInvalid,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ObjectDoesNotExist","If an object does not exist, throw an error and return $Failed immediately:"},
			ExperimentDilute[{Object[Sample, "Chemical that doesn't exist at all for ExperimentDilute testing"<>$SessionUUID], Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID]}],
			$Failed,
			Messages:>{
				Download::ObjectDoesNotExist
			}
		],
		Example[{Messages, "InputContainsTemporalLinks", "Throw a message if given a temporal link:"},
			ExperimentDilute[Link[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Now - 1 Minute], TotalVolume -> 1 Milliliter],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			Messages :> {Warning::InputContainsTemporalLinks}
		],
		Example[{Messages,"DiscardedSamples","Discarded objects are not supported as inputs or options:"},
			ExperimentDilute[Object[Sample,"ExperimentDilute New Test Chemical 4 (Discarded)"<> $SessionUUID], TotalVolume -> 1 Milliliter],
			$Failed,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"DeprecatedModels","Deprecated models are not supported for any option value:"},
			ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume -> 200 Microliter, ContainerOut -> Model[Container, Vessel, "1KG tall small shoulder white plasticv rectangular solid bottle, Deprecated"]],
			$Failed,
			Messages:>{
				Error::DeprecatedModels,
				Error::InvalidInput
			}
		],
		Example[{Messages,"UnknownAmount","If a sample is being diluted but doesn't have a mass or count populated, throw a warning but proceed:"},
			ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 5 (no amount)"<> $SessionUUID], Amount -> 10 Microliter, TotalVolume -> 200*Microliter],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			Messages:>{
				Warning::UnknownAmount,
				Warning::OveraspiratedTransfer
			}
		],
		Example[{Messages, "SampleStateInvalid", "If the input sample is a solid, it cannot be diluted:"},
			ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemcial 6 (100 mg)"<> $SessionUUID], TotalVolume -> 1 Milliliter],
			$Failed,
			Messages :> {
				Error::SampleStateInvalid,
				Error::CannotResolveAmount,
				Error::InvalidInput
			}
		],
		Example[{Messages, "DuplicateName", "If the specified name already exists for a Dilute protocol, an error is thrown:"},
			ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume -> 200 Microliter, Name -> "Existing ExperimentDilute Protocol"<> $SessionUUID],
			$Failed,
			Messages :> {
				Error::DuplicateName,
				Error::InvalidOption
			}
		],
		Example[{Messages,"CannotResolveAmount","If a sample has no amount populated in its Volume field and no Amount is specified, throw an error:"},
			ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 5 (no amount)"<> $SessionUUID], TotalVolume -> 200*Microliter],
			$Failed,
			Messages:>{
				Warning::UnknownAmount,
				Error::CannotResolveAmount,
				Error::InvalidInput
			}
		],
		Example[{Messages, "ConcentrationRatioMismatch", "If Amount, TotalVolume, and TargetConcentation are all specified, they must not be conflicting:"},
			ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 3 (200 uL)"<> $SessionUUID], TotalVolume -> 0.9 Milliliter, Amount -> 100 Microliter, TargetConcentration -> 1 Micromolar, TargetConcentrationAnalyte -> Model[Molecule, "Dibasic Sodium Phosphate"]],
			$Failed,
			Messages :> {
				Error::ConcentrationRatioMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CannotResolveTotalVolume", "If TotalVolume is not specified and cannot be resolved from TargetConcentration, an error is thrown:"},
			ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Amount -> 100 Microliter],
			$Failed,
			Messages :> {
				Error::CannotResolveTotalVolume,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DestinationWellDoesntExist", "If DestinationWell is specified, it must be an existing position in the specified or resolved ContainerOut:"},
			ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Amount -> 100 Microliter, TotalVolume -> 1 Milliliter, DestinationWell -> "A3"],
			$Failed,
			Messages :> {
				Error::DestinationWellDoesntExist,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ContainerOutMismatchedIndex", "If specifying ContainerOut with indices, containers of different models cannot have the same index:"},
			ExperimentDilute[
				{Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID],Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID]},
				TotalVolume -> 1 Milliliter,
				ContainerOut->{
					{1, Model[Container,Plate,"96-well 2mL Deep Well Plate"]},
					{1, Model[Container, Vessel, "2mL Tube"]}
				}
			],
			$Failed,
			Messages :> {
				Error::ContainerOutMismatchedIndex,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ContainerOverOccupied", "If more positions in the destination container are requested than are available, throw an error:"},
			ExperimentDilute[{Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID],Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID]}, Amount -> {50 Microliter, 50 Microliter}, TotalVolume -> 100 Microliter, ContainerOut -> {{1, Model[Container, Vessel, "2mL Tube"]}, {1, Model[Container, Vessel, "2mL Tube"]}}],
			$Failed,
			Messages :> {
				Error::ContainerOverOccupied,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DiluteTotalVolumeOverContainerMax", "If the specified TotalVolume is greater than the specified or resolved ContainerOut, throw an error:"},
			ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Amount -> 100 Microliter, TotalVolume -> 10 Milliliter],
			$Failed,
			Messages :> {
				Error::DiluteInitialVolumeOverContainerMax,
				Error::DiluteTotalVolumeOverContainerMax,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DiluteInitialVolumeOverContainerMax", "If transferring to a new container, the volume needed to dilute in the source container first must be less than the MaxVolume of the source container:"},
			ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Amount -> 50 Microliter, TotalVolume -> 1.8 Milliliter],
			$Failed,
			Messages :> {
				Error::DiluteInitialVolumeOverContainerMax,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PartialResuspensionContainerInvalid", "If the ContainerOut is set to the current container, Amount must be equal to the full Volume of the specified sample:"},
			ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Amount -> 10 Microliter, ContainerOut -> Object[Container, Vessel, "Fake container 1 for ExperimentDilute tests"<> $SessionUUID], TotalVolume -> 1 Milliliter],
			$Failed,
			Messages :> {
				Error::DiluteInitialVolumeOverContainerMax,
				Error::PartialResuspensionContainerInvalid,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DuplicateSampleConflictingConditions", "If the same sample is specified more than once, it will only be diluted once.  In this case, all the options for these samples must be identical:"},
			ExperimentDilute[{Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID]}, Amount -> {60 Microliter, 80 Microliter}, TotalVolume -> 1 Milliliter],
			$Failed,
			Messages :> {
				Error::DuplicateSampleConflictingConditions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "BufferDilutionMismatched", "If BufferDilutionFactor and/or BufferDiluent are specified, ConcentratedBuffer must also be specified:"},
			ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], TotalVolume -> 1 Milliliter],
			$Failed,
			Messages :> {
				Error::BufferDilutionMismatched,
				Error::InvalidOption
			}
		],
		Example[{Messages,"OverspecifiedBuffer","Both Diluent and ConcentratedBuffer cannot be simultaneously requested:"},
			ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID], TotalVolume->1200 Microliter, Diluent -> Model[Sample,StockSolution,"70% Ethanol"], ConcentratedBuffer -> Model[Sample,StockSolution,"10x UV buffer"]],
			$Failed,
			Messages:>{
				Error::OverspecifiedBuffer,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"MixInstrumentTypeMismatch","If the IncubationInstrument and MixType options do not agree, an error is thrown:"},
			ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume -> 200 Microliter,IncubationInstrument->Model[Instrument,Vortex,"id:dORYzZn0o45q"],MixType->Pipette],
			$Failed,
			Messages:>{
				Error::MixInstrumentTypeMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "MixTypeNumberOfMixesMismatch", "Thow an error if NumberOfMixes is specified for incubation types:"},
			ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume -> 200 Microliter,NumberOfMixes -> 20, MixType->Vortex],
			$Failed,
			Messages:>{
				Error::MixTypeNumberOfMixesMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ResuspendMixTypeIncubationMismatch", "Thow an error if Incubation options are specified for Pipette/Swirl/Invert mix types:"},
			ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume -> 200 Microliter,IncubationTime->20Minute, MixType->Pipette],
			$Failed,
			Messages:>{
				Error::ResuspendMixTypeIncubationMismatch,
				Error::InvalidOption
			}
		],
		Test["Use an Dilute primitive to call ExperimentManualSamplePreparation and generate a protocol:",
			ExperimentManualSamplePreparation[{
				Dilute[
					Sample -> Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID],
					TotalVolume -> 1000 Microliter
				]
			}],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			TimeConstraint -> 1000
		],
		Test["Use an Dilute primitive to call ExperimentRoboticSamplePreparation and generate a protocol:",
			ExperimentRoboticSamplePreparation[{
				Dilute[
					Sample -> Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID],
					TotalVolume -> 200 Microliter,
					MixType->Pipette
				]
			}],
			ObjectP[Object[Protocol, RoboticSamplePreparation]],
			TimeConstraint -> 1000
		],
		Test["Use an Dilute primitive to call ExperimentSamplePreparation and generate a protocol:",
			ExperimentSamplePreparation[{
				Dilute[
					Sample -> Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID],
					TotalVolume -> 1000 Microliter
				]
			}],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			TimeConstraint -> 1000
		],
		Test["Return a simulation blob if Output -> Simulation:",
			ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume -> 200 Microliter, Output -> Simulation],
			_Simulation,
			TimeConstraint -> 1000
		],
		Test["Return a simulation blob if Output -> Simulation with the correct volume of sample removed:",
			simulation = ExperimentDilute[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume -> 200 Microliter, Output -> Simulation];
			Download[Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID], Volume, Simulation -> simulation],
			EqualP[200 Microliter],
			Variables :> {simulation},
			TimeConstraint -> 1000
		]
	},

	(* TODO try to add a test that goes down the hairy bits of potentialVolume logic in the shared resolver *)
	(* TODO also the big Amount/TotalVolume switch after that is hairy too so make tests for those *)
	Stubs:>{
		$EmailEnabled=False,
		$AllowSystemsProtocols = True,
		$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"]
	},
	SetUp:>($CreatedObjects={}),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[
			{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Fake bench for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 1 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 2 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 4 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 5 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 6 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 7 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 8 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 9 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 10 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 11 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 12 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 13 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 14 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Plate, "Fake plate 1 for ExperimentDilute tests"<> $SessionUUID],
				Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentDilute New Test Chemical 3 (200 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentDilute New Test Chemical 4 (Discarded)"<> $SessionUUID],
				Object[Sample, "ExperimentDilute New Test Chemical 5 (no amount)"<> $SessionUUID],
				Object[Sample, "ExperimentDilute New Test Chemcial 6 (100 mg)"<> $SessionUUID],
				Object[Sample, "ExperimentDilute New Test Chemical 7 (0.01 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentDilute New Test Chemical 8 (120 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentDilute New Test Chemical 9 (200 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentDilute New Test Chemical In Plate 2 (100 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentDilute New Test Chemical In Plate 3 (100 uL)"<> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "Existing ExperimentDilute Protocol"<> $SessionUUID]
			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					fakeBench,
					container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11, container12, container13, container14, plate1,
					sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11,
					allObjs, templateProtocol
				},

				fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for ExperimentDilute tests"<> $SessionUUID, DeveloperObject -> True|>];
				{
					container,
					container2,
					container3,
					container4,
					container5,
					container6,
					container7,
					container8,
					container9,
					container10,
					container11,
					container12,
					container13,
					container14,
					plate1
				} = UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"]
					},
					{
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench}
					},
					Status -> {
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available
					},
					Name -> {
						"Fake container 1 for ExperimentDilute tests"<> $SessionUUID,
						"Fake container 2 for ExperimentDilute tests"<> $SessionUUID,
						"Fake container 3 for ExperimentDilute tests"<> $SessionUUID,
						"Fake container 4 for ExperimentDilute tests"<> $SessionUUID,
						"Fake container 5 for ExperimentDilute tests"<> $SessionUUID,
						"Fake container 6 for ExperimentDilute tests"<> $SessionUUID,
						"Fake container 7 for ExperimentDilute tests"<> $SessionUUID,
						"Fake container 8 for ExperimentDilute tests"<> $SessionUUID,
						"Fake container 9 for ExperimentDilute tests"<> $SessionUUID,
						"Fake container 10 for ExperimentDilute tests"<> $SessionUUID,
						"Fake container 11 for ExperimentDilute tests"<> $SessionUUID,
						"Fake container 12 for ExperimentDilute tests"<> $SessionUUID,
						"Fake container 13 for ExperimentDilute tests"<> $SessionUUID,
						"Fake container 14 for ExperimentDilute tests"<> $SessionUUID,
						"Fake plate 1 for ExperimentDilute tests"<> $SessionUUID
					}
				];
				{
					sample,
					sample2,
					sample3,
					sample4,
					sample5,
					sample6,
					sample7,
					sample8,
					sample9,
					sample10,
					sample11
				} = UploadSample[
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Acetone, Reagent Grade"],
						Model[Sample, StockSolution, "10x UV buffer"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "T7 RNA Polymerase"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"]
					},
					{
						{"A1", container},
						{"A1", container2},
						{"A1", container3},
						{"A1", container4},
						{"A1", container5},
						{"A1", container6},
						{"A1", container7},
						{"A1", container8},
						{"A1", container9},
						{"A1", plate1},
						{"A2", plate1}
					},
					InitialAmount -> {
						100 Microliter,
						100 Microliter,
						200 Microliter,
						100 Microliter,
						Null,
						100 Milligram,
						0.01 Microliter,
						120 Microliter,
						200 Microliter,
						100 Microliter,
						100 Microliter
					},
					Name -> {
						"ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID,
						"ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID,
						"ExperimentDilute New Test Chemical 3 (200 uL)"<> $SessionUUID,
						"ExperimentDilute New Test Chemical 4 (Discarded)"<> $SessionUUID,
						"ExperimentDilute New Test Chemical 5 (no amount)"<> $SessionUUID,
						"ExperimentDilute New Test Chemcial 6 (100 mg)"<> $SessionUUID,
						"ExperimentDilute New Test Chemical 7 (0.01 uL)"<> $SessionUUID,
						"ExperimentDilute New Test Chemical 8 (120 uL)"<> $SessionUUID,
						"ExperimentDilute New Test Chemical 9 (200 uL)"<> $SessionUUID,
						"ExperimentDilute New Test Chemical In Plate 2 (100 uL)"<> $SessionUUID,
						"ExperimentDilute New Test Chemical In Plate 3 (100 uL)"<> $SessionUUID
					}
				];


				(* make a new protocol object for templating *)
				templateProtocol = ExperimentDilute[sample8, TotalVolume -> 123 Microliter, Name -> "Existing ExperimentDilute Protocol"<> $SessionUUID];

				allObjs = Cases[Flatten[{
					container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11, container12, container13, container14, plate1,
					sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11,
					templateProtocol, Download[templateProtocol, {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]
				}], ObjectP[]];

				(* get rid of the Model field for these samples so that we can make sure everything works when that is the case *)
				Upload[Flatten[{
					<|Object -> #, DeveloperObject -> True|>& /@ PickList[allObjs, DatabaseMemberQ[allObjs]]
				}]];
				UploadSampleStatus[sample4, Discarded, FastTrack -> True]

			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::NoModelNameGiven];

		Module[
			{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Fake bench for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 1 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 2 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 4 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 5 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 6 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 7 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 8 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 9 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 10 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 11 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 12 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 13 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 14 for ExperimentDilute tests"<> $SessionUUID],
				Object[Container, Plate, "Fake plate 1 for ExperimentDilute tests"<> $SessionUUID],
				Object[Sample, "ExperimentDilute New Test Chemical 1 (100 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentDilute New Test Chemical 2 (100 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentDilute New Test Chemical 3 (200 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentDilute New Test Chemical 4 (Discarded)"<> $SessionUUID],
				Object[Sample, "ExperimentDilute New Test Chemical 5 (no amount)"<> $SessionUUID],
				Object[Sample, "ExperimentDilute New Test Chemcial 6 (100 mg)"<> $SessionUUID],
				Object[Sample, "ExperimentDilute New Test Chemical 7 (0.01 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentDilute New Test Chemical 8 (120 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentDilute New Test Chemical 9 (200 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentDilute New Test Chemical In Plate 2 (100 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentDilute New Test Chemical In Plate 3 (100 uL)"<> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "Existing ExperimentDilute Protocol"<> $SessionUUID]
			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];


(* ::Subsection::Closed:: *)
(*ExperimentDilutePreview*)

DefineTests[ExperimentDilutePreview,
	{
		Example[{Basic, "Always returns Null:"},
			ExperimentDilutePreview[Object[Sample, "ExperimentDilutePreview New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume -> 300 Microliter],
			Null
		],
		Example[{Basic, "Always returns Null:"},
			ExperimentDilutePreview[{Object[Sample, "ExperimentDilutePreview New Test Chemical 1 (100 uL)"<> $SessionUUID], Object[Sample, "ExperimentDilutePreview New Test Chemical 2 (100 uL)"<> $SessionUUID]}, TotalVolume -> 300 Microliter],
			Null
		],
		Example[{Basic, "Always returns Null:"},
			ExperimentDilutePreview[{Object[Container, Vessel, "Fake container 1 for ExperimentDilutePreview tests"<> $SessionUUID], Object[Container, Vessel, "Fake container 2 for ExperimentDilutePreview tests"<> $SessionUUID], Object[Container, Vessel, "Fake container 3 for ExperimentDilutePreview tests"<> $SessionUUID]}, TotalVolume -> 300 Microliter],
			Null
		]
	},
	Stubs:>{
		$EmailEnabled=False,
		$AllowSystemsProtocols = True,
		$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"]
	},
	SetUp:>($CreatedObjects={}),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::NoModelNameGiven];

		Module[
			{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Fake bench for ExperimentDilutePreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 1 for ExperimentDilutePreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 2 for ExperimentDilutePreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for ExperimentDilutePreview tests"<> $SessionUUID],
				Object[Sample, "ExperimentDilutePreview New Test Chemical 1 (100 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentDilutePreview New Test Chemical 2 (100 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentDilutePreview New Test Chemical 3 (200 uL)"<> $SessionUUID]
			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					fakeBench, container, container2, container3, sample, sample2, sample3, allObjs
				},

				fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for ExperimentDilutePreview tests"<> $SessionUUID, DeveloperObject -> True|>];
				{
					container,
					container2,
					container3
				} = UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"]
					},
					{
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench}
					},
					Status -> {
						Available,
						Available,
						Available
					},
					Name -> {
						"Fake container 1 for ExperimentDilutePreview tests"<> $SessionUUID,
						"Fake container 2 for ExperimentDilutePreview tests"<> $SessionUUID,
						"Fake container 3 for ExperimentDilutePreview tests"<> $SessionUUID
					}
				];
				{
					sample,
					sample2,
					sample3
				} = UploadSample[
					{
						Model[Sample, "Methanol"],
						Model[Sample, "Methanol"],
						Model[Sample, "Methanol"]
					},
					{
						{"A1", container},
						{"A1", container2},
						{"A1", container3}
					},
					InitialAmount -> {
						100 * Microliter,
						100 * Microliter,
						200 * Microliter
					},
					Name -> {
						"ExperimentDilutePreview New Test Chemical 1 (100 uL)"<> $SessionUUID,
						"ExperimentDilutePreview New Test Chemical 2 (100 uL)"<> $SessionUUID,
						"ExperimentDilutePreview New Test Chemical 3 (200 uL)"<> $SessionUUID
					}
				];

				allObjs = Cases[Flatten[{
					container, container2, container3,
					sample, sample2, sample3
				}], ObjectP[]];

				(* get rid of the Model field for these samples so that we can make sure everything works when that is the case *)
				Upload[Flatten[{
					<|Object -> #, DeveloperObject -> True|>& /@ PickList[allObjs, DatabaseMemberQ[allObjs]]
				}]];
			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[
			{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Fake bench for ExperimentDilutePreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 1 for ExperimentDilutePreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 2 for ExperimentDilutePreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for ExperimentDilutePreview tests"<> $SessionUUID],
				Object[Sample, "ExperimentDilutePreview New Test Chemical 1 (100 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentDilutePreview New Test Chemical 2 (100 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentDilutePreview New Test Chemical 3 (200 uL)"<> $SessionUUID]
			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];


(* ::Subsection::Closed:: *)
(*ExperimentDiluteOptions*)

DefineTests[ExperimentDiluteOptions,
	{
		Example[{Basic, "Return all resolved options as a table:"},
			ExperimentDiluteOptions[Object[Sample, "ExperimentDiluteOptions New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume -> 300 Microliter],
			_Grid
		],
		Example[{Basic, "Return all resolved options as a list:"},
			ExperimentDiluteOptions[{Object[Sample, "ExperimentDiluteOptions New Test Chemical 1 (100 uL)"<> $SessionUUID], Object[Sample, "ExperimentDiluteOptions New Test Chemical 2 (100 uL)"<> $SessionUUID]}, TotalVolume -> 300 Microliter, OutputFormat -> List],
			{__Rule}
		],
		Example[{Basic, "If an error is thrown, still return the list of options:"},
			ExperimentDiluteOptions[Object[Sample, "ExperimentDiluteOptions New Test Chemical 1 (100 uL)"<> $SessionUUID], Amount -> 100 Microliter, TotalVolume -> 1 Milliliter, DestinationWell -> "A3", OutputFormat -> List],
			{__Rule},
			Messages :> {
				Error::DestinationWellDoesntExist,
				Error::InvalidOption
			}
		],
		Example[{Options, OutputFormat, "OuptutFormat indicates if the optiosn should be returned as a list or table:"},
			ExperimentDiluteOptions[{Object[Sample, "ExperimentDiluteOptions New Test Chemical 1 (100 uL)"<> $SessionUUID], Object[Sample, "ExperimentDiluteOptions New Test Chemical 2 (100 uL)"<> $SessionUUID]}, TotalVolume -> 300 Microliter, OutputFormat -> List],
			{__Rule}
		]
	},
	Stubs:>{
		$EmailEnabled=False,
		$AllowSystemsProtocols = True,
		$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"]
	},
	SetUp:>($CreatedObjects={}),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[
			{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Fake bench for ExperimentDiluteOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 1 for ExperimentDiluteOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 2 for ExperimentDiluteOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for ExperimentDiluteOptions tests"<> $SessionUUID],
				Object[Sample, "ExperimentDiluteOptions New Test Chemical 1 (100 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentDiluteOptions New Test Chemical 2 (100 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentDiluteOptions New Test Chemical 3 (200 uL)"<> $SessionUUID]
			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					fakeBench, container, container2, container3, sample, sample2, sample3, allObjs
				},

				fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for ExperimentDiluteOptions tests"<> $SessionUUID, DeveloperObject -> True|>];
				{
					container,
					container2,
					container3
				} = UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"]
					},
					{
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench}
					},
					Status -> {
						Available,
						Available,
						Available
					},
					Name -> {
						"Fake container 1 for ExperimentDiluteOptions tests"<> $SessionUUID,
						"Fake container 2 for ExperimentDiluteOptions tests"<> $SessionUUID,
						"Fake container 3 for ExperimentDiluteOptions tests"<> $SessionUUID
					}
				];
				{
					sample,
					sample2,
					sample3
				} = UploadSample[
					{
						Model[Sample, "Methanol"],
						Model[Sample, "Methanol"],
						Model[Sample, "Methanol"]
					},
					{
						{"A1", container},
						{"A1", container2},
						{"A1", container3}
					},
					InitialAmount -> {
						100 * Microliter,
						100 * Microliter,
						200 * Microliter
					},
					Name -> {
						"ExperimentDiluteOptions New Test Chemical 1 (100 uL)"<> $SessionUUID,
						"ExperimentDiluteOptions New Test Chemical 2 (100 uL)"<> $SessionUUID,
						"ExperimentDiluteOptions New Test Chemical 3 (200 uL)"<> $SessionUUID
					}
				];

				allObjs = Cases[Flatten[{
					container, container2, container3,
					sample, sample2, sample3
				}], ObjectP[]];

				(* get rid of the Model field for these samples so that we can make sure everything works when that is the case *)
				Upload[Flatten[{
					<|Object -> #, DeveloperObject -> True|>& /@ PickList[allObjs, DatabaseMemberQ[allObjs]]
				}]];
			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[
			{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Fake bench for ExperimentDiluteOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 1 for ExperimentDiluteOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 2 for ExperimentDiluteOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for ExperimentDiluteOptions tests"<> $SessionUUID],
				Object[Sample, "ExperimentDiluteOptions New Test Chemical 1 (100 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentDiluteOptions New Test Chemical 2 (100 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentDiluteOptions New Test Chemical 3 (200 uL)"<> $SessionUUID]
			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];

(* ::Subsection::Closed:: *)
(*ValidExperimentDiluteQ*)

DefineTests[ValidExperimentDiluteQ,
	{
		Example[{Basic, "Generate a new protocol to dilute a sample:"},
			ValidExperimentDiluteQ[Object[Sample, "ValidExperimentDiluteQ New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume -> 200 Microliter],
			True
		],
		Example[{Basic, "Generate a new protocol to dilute multiple samples:"},
			ValidExperimentDiluteQ[{Object[Sample, "ValidExperimentDiluteQ New Test Chemical 1 (100 uL)"<> $SessionUUID], Object[Sample, "ValidExperimentDiluteQ New Test Chemical 2 (100 uL)"<> $SessionUUID]}, TotalVolume -> 200 Microliter],
			True
		],
		Example[{Basic, "Generate a new protocol to dilute multiple specified as containers:"},
			ValidExperimentDiluteQ[{Object[Container, Vessel, "Fake container 1 for ValidExperimentDiluteQ tests"<> $SessionUUID], Object[Container, Vessel, "Fake container 2 for ValidExperimentDiluteQ tests"<> $SessionUUID], Object[Container, Vessel, "Fake container 3 for ValidExperimentDiluteQ tests"<> $SessionUUID]}, TotalVolume -> 300 Microliter],
			True
		],
		Example[{Options, Verbose, "Verbose option indicates if tests should be printed:"},
			ValidExperimentDiluteQ[Object[Sample, "ValidExperimentDiluteQ New Test Chemical 5 (no amount)"<> $SessionUUID], TotalVolume -> 200*Microliter, Verbose -> Failures],
			False
		],
		Example[{Options, OutputFormat, "OutputFormat option indicates if the output should be a Boolean or a test summary:"},
			ValidExperimentDiluteQ[Object[Sample, "ValidExperimentDiluteQ New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume -> 200 Microliter, OutputFormat -> TestSummary],
			_EmeraldTestSummary
		],
		Example[{Messages,"DiscardedSamples","Discarded objects are not supported as inputs or options:"},
			ValidExperimentDiluteQ[Object[Sample,"ValidExperimentDiluteQ New Test Chemical 4 (Discarded)"<> $SessionUUID], TotalVolume -> 1 Milliliter],
			False
		],
		Example[{Messages,"DeprecatedModels","Deprecated models are not supported for any option value:"},
			ValidExperimentDiluteQ[Object[Sample, "ValidExperimentDiluteQ New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume -> 200 Microliter, ContainerOut -> Model[Container, Vessel, "1KG tall small shoulder white plasticv rectangular solid bottle, Deprecated"]],
			False
		],
		Example[{Messages,"UnknownAmount","If a sample is being diluted but doesn't have a mass or count populated, throw a warning but proceed:"},
			ValidExperimentDiluteQ[Object[Sample, "ValidExperimentDiluteQ New Test Chemical 5 (no amount)"<> $SessionUUID], Amount -> 10 Microliter, TotalVolume -> 200*Microliter],
			True
		],
		Example[{Messages, "SampleStateInvalid", "If the input sample is a solid, it cannot be diluted:"},
			ValidExperimentDiluteQ[Object[Sample, "ValidExperimentDiluteQ New Test Chemcial 6 (100 mg)"<> $SessionUUID], TotalVolume -> 1 Milliliter],
			False
		],
		Example[{Messages, "DuplicateName", "If the specified name already exists for a Dilute protocol, an error is thrown:"},
			ValidExperimentDiluteQ[Object[Sample, "ValidExperimentDiluteQ New Test Chemical 1 (100 uL)"<> $SessionUUID], TotalVolume -> 200 Microliter, Name -> "Existing ValidExperimentDiluteQ Protocol"<> $SessionUUID],
			False
		],
		Example[{Messages,"CannotResolveAmount","If a sample has no amount populated in its Volume field and no Amount is specified, throw an error:"},
			ValidExperimentDiluteQ[Object[Sample, "ValidExperimentDiluteQ New Test Chemical 5 (no amount)"<> $SessionUUID], TotalVolume -> 200*Microliter],
			False
		],
		Example[{Messages, "ConcentrationRatioMismatch", "If Amount, TotalVolume, and TargetConcentation are all specified, they must not be conflicting:"},
			ValidExperimentDiluteQ[Object[Sample, "ValidExperimentDiluteQ New Test Chemical 3 (200 uL)"<> $SessionUUID], TotalVolume -> 0.9 Milliliter, Amount -> 100 Microliter, TargetConcentration -> 1 Micromolar, TargetConcentrationAnalyte -> Model[Molecule, "Dibasic Sodium Phosphate"]],
			False
		],
		Example[{Messages, "CannotResolveTotalVolume", "If TotalVolume is not specified and cannot be resolved from TargetConcentration, an error is thrown:"},
			ValidExperimentDiluteQ[Object[Sample, "ValidExperimentDiluteQ New Test Chemical 1 (100 uL)"<> $SessionUUID], Amount -> 100 Microliter],
			False
		],
		Example[{Messages, "DestinationWellDoesntExist", "If DestinationWell is specified, it must be an existing position in the specified or resolved ContainerOut:"},
			ValidExperimentDiluteQ[Object[Sample, "ValidExperimentDiluteQ New Test Chemical 1 (100 uL)"<> $SessionUUID], Amount -> 100 Microliter, TotalVolume -> 1 Milliliter, DestinationWell -> "A3"],
			False
		],
		Example[{Messages, "ContainerOutMismatchedIndex", "If specifying ContainerOut with indices, containers of different models cannot have the same index:"},
			ValidExperimentDiluteQ[
				{Object[Sample, "ValidExperimentDiluteQ New Test Chemical 1 (100 uL)"<> $SessionUUID],Object[Sample, "ValidExperimentDiluteQ New Test Chemical 2 (100 uL)"<> $SessionUUID]},
				TotalVolume -> 1 Milliliter,
				ContainerOut->{
					{1, Model[Container,Plate,"96-well 2mL Deep Well Plate"]},
					{1, Model[Container, Vessel, "2mL Tube"]}
				}
			],
			False
		],
		Example[{Messages, "ContainerOverOccupied", "If more positions in the destination container are requested than are available, throw an error:"},
			ValidExperimentDiluteQ[{Object[Sample, "ValidExperimentDiluteQ New Test Chemical 1 (100 uL)"<> $SessionUUID],Object[Sample, "ValidExperimentDiluteQ New Test Chemical 2 (100 uL)"<> $SessionUUID]}, Amount -> {50 Microliter, 50 Microliter}, TotalVolume -> 100 Microliter, ContainerOut -> {{1, Model[Container, Vessel, "2mL Tube"]}, {1, Model[Container, Vessel, "2mL Tube"]}}],
			False
		],
		Example[{Messages, "DiluteTotalVolumeOverContainerMax", "If the specified TotalVolume is greater than the specified or resolved ContainerOut, throw an error:"},
			ValidExperimentDiluteQ[Object[Sample, "ValidExperimentDiluteQ New Test Chemical 1 (100 uL)"<> $SessionUUID], Amount -> 100 Microliter, TotalVolume -> 10 Milliliter],
			False
		],
		Example[{Messages, "DiluteInitialVolumeOverContainerMax", "If transferring to a new container, the volume needed to dilute in the source container first must be less than the MaxVolume of the source container:"},
			ValidExperimentDiluteQ[Object[Sample, "ValidExperimentDiluteQ New Test Chemical 1 (100 uL)"<> $SessionUUID], Amount -> 50 Microliter, TotalVolume -> 1.8 Milliliter],
			False
		],
		Example[{Messages, "PartialResuspensionContainerInvalid", "If the ContainerOut is set to the current container, Amount must be equal to the full Volume of the specified sample:"},
			ValidExperimentDiluteQ[Object[Sample, "ValidExperimentDiluteQ New Test Chemical 1 (100 uL)"<> $SessionUUID], Amount -> 10 Microliter, ContainerOut -> Object[Container, Vessel, "Fake container 1 for ValidExperimentDiluteQ tests"<> $SessionUUID], TotalVolume -> 1 Milliliter],
			False
		],
		Example[{Messages, "DuplicateSampleConflictingConditions", "If the same sample is specified more than once, it will only be diluted once.  In this case, all the options for these samples must be identical:"},
			ValidExperimentDiluteQ[{Object[Sample, "ValidExperimentDiluteQ New Test Chemical 1 (100 uL)"<> $SessionUUID], Object[Sample, "ValidExperimentDiluteQ New Test Chemical 1 (100 uL)"<> $SessionUUID]}, Amount -> {60 Microliter, 80 Microliter}, TotalVolume -> 1 Milliliter],
			False
		],
		Example[{Messages, "BufferDilutionMismatched", "If BufferDilutionFactor and/or BufferDiluent are specified, ConcentratedBuffer must also be specified:"},
			ValidExperimentDiluteQ[Object[Sample, "ValidExperimentDiluteQ New Test Chemical 2 (100 uL)"<> $SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], TotalVolume -> 1 Milliliter],
			False
		],
		Example[{Messages,"OverspecifiedBuffer","Both Diluent and ConcentratedBuffer cannot be simultaneously requested:"},
			ValidExperimentDiluteQ[Object[Sample, "ValidExperimentDiluteQ New Test Chemical 2 (100 uL)"<> $SessionUUID], TotalVolume->1200 Microliter, Diluent -> Model[Sample,StockSolution,"70% Ethanol"], ConcentratedBuffer -> Model[Sample,StockSolution,"10x UV buffer"]],
			False
		]
	},
	Stubs:>{
		$EmailEnabled=False,
		$AllowSystemsProtocols = True,
		$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"]
	},
	SetUp:>($CreatedObjects={}),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[
			{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Fake bench for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 1 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 2 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 4 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 5 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 6 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 7 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 8 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 9 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 10 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 11 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 12 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 13 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 14 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Plate, "Fake plate 1 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Sample, "ValidExperimentDiluteQ New Test Chemical 1 (100 uL)"<> $SessionUUID],
				Object[Sample, "ValidExperimentDiluteQ New Test Chemical 2 (100 uL)"<> $SessionUUID],
				Object[Sample, "ValidExperimentDiluteQ New Test Chemical 3 (200 uL)"<> $SessionUUID],
				Object[Sample, "ValidExperimentDiluteQ New Test Chemical 4 (Discarded)"<> $SessionUUID],
				Object[Sample, "ValidExperimentDiluteQ New Test Chemical 5 (no amount)"<> $SessionUUID],
				Object[Sample, "ValidExperimentDiluteQ New Test Chemcial 6 (100 mg)"<> $SessionUUID],
				Object[Sample, "ValidExperimentDiluteQ New Test Chemical 7 (0.01 uL)"<> $SessionUUID],
				Object[Sample, "ValidExperimentDiluteQ New Test Chemical 8 (120 uL)"<> $SessionUUID],
				Object[Sample, "ValidExperimentDiluteQ New Test Chemical 9 (200 uL)"<> $SessionUUID],
				Object[Sample, "ValidExperimentDiluteQ New Test Chemical In Plate 2 (100 uL)"<> $SessionUUID],
				Object[Sample, "ValidExperimentDiluteQ New Test Chemical In Plate 3 (100 uL)"<> $SessionUUID],
				Object[Protocol, ManualSamplePreparation "Existing ValidExperimentDiluteQ Protocol"<> $SessionUUID]
			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					fakeBench,
					container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11, container12, container13, container14, plate1,
					sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11,
					allObjs, templateProtocol
				},

				fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for ValidExperimentDiluteQ tests"<> $SessionUUID, DeveloperObject -> True|>];
				{
					container,
					container2,
					container3,
					container4,
					container5,
					container6,
					container7,
					container8,
					container9,
					container10,
					container11,
					container12,
					container13,
					container14,
					plate1
				} = UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"]
					},
					{
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench}
					},
					Status -> {
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available
					},
					Name -> {
						"Fake container 1 for ValidExperimentDiluteQ tests"<> $SessionUUID,
						"Fake container 2 for ValidExperimentDiluteQ tests"<> $SessionUUID,
						"Fake container 3 for ValidExperimentDiluteQ tests"<> $SessionUUID,
						"Fake container 4 for ValidExperimentDiluteQ tests"<> $SessionUUID,
						"Fake container 5 for ValidExperimentDiluteQ tests"<> $SessionUUID,
						"Fake container 6 for ValidExperimentDiluteQ tests"<> $SessionUUID,
						"Fake container 7 for ValidExperimentDiluteQ tests"<> $SessionUUID,
						"Fake container 8 for ValidExperimentDiluteQ tests"<> $SessionUUID,
						"Fake container 9 for ValidExperimentDiluteQ tests"<> $SessionUUID,
						"Fake container 10 for ValidExperimentDiluteQ tests"<> $SessionUUID,
						"Fake container 11 for ValidExperimentDiluteQ tests"<> $SessionUUID,
						"Fake container 12 for ValidExperimentDiluteQ tests"<> $SessionUUID,
						"Fake container 13 for ValidExperimentDiluteQ tests"<> $SessionUUID,
						"Fake container 14 for ValidExperimentDiluteQ tests"<> $SessionUUID,
						"Fake plate 1 for ValidExperimentDiluteQ tests"<> $SessionUUID
					}
				];
				{
					sample,
					sample2,
					sample3,
					sample4,
					sample5,
					sample6,
					sample7,
					sample8,
					sample9,
					sample10,
					sample11
				} = UploadSample[
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Acetone, Reagent Grade"],
						Model[Sample, StockSolution, "10x UV buffer"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "T7 RNA Polymerase"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"]
					},
					{
						{"A1", container},
						{"A1", container2},
						{"A1", container3},
						{"A1", container4},
						{"A1", container5},
						{"A1", container6},
						{"A1", container7},
						{"A1", container8},
						{"A1", container9},
						{"A1", plate1},
						{"A2", plate1}
					},
					InitialAmount -> {
						100 Microliter,
						100 Microliter,
						200 Microliter,
						100 Microliter,
						Null,
						100 Milligram,
						0.01 Microliter,
						120 Microliter,
						200 Microliter,
						100 Microliter,
						100 Microliter
					},
					Name -> {
						"ValidExperimentDiluteQ New Test Chemical 1 (100 uL)"<> $SessionUUID,
						"ValidExperimentDiluteQ New Test Chemical 2 (100 uL)"<> $SessionUUID,
						"ValidExperimentDiluteQ New Test Chemical 3 (200 uL)"<> $SessionUUID,
						"ValidExperimentDiluteQ New Test Chemical 4 (Discarded)"<> $SessionUUID,
						"ValidExperimentDiluteQ New Test Chemical 5 (no amount)"<> $SessionUUID,
						"ValidExperimentDiluteQ New Test Chemcial 6 (100 mg)"<> $SessionUUID,
						"ValidExperimentDiluteQ New Test Chemical 7 (0.01 uL)"<> $SessionUUID,
						"ValidExperimentDiluteQ New Test Chemical 8 (120 uL)"<> $SessionUUID,
						"ValidExperimentDiluteQ New Test Chemical 9 (200 uL)"<> $SessionUUID,
						"ValidExperimentDiluteQ New Test Chemical In Plate 2 (100 uL)"<> $SessionUUID,
						"ValidExperimentDiluteQ New Test Chemical In Plate 3 (100 uL)"<> $SessionUUID
					}
				];


				(* make a new protocol object for templating *)
				templateProtocol = ExperimentDilute[sample8, TotalVolume -> 123 Microliter, Name -> "Existing ValidExperimentDiluteQ Protocol"<> $SessionUUID];

				allObjs = Cases[Flatten[{
					container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11, container12, container13, container14, plate1,
					sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11,
					templateProtocol, Download[templateProtocol, {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]
				}], ObjectP[]];

				(* get rid of the Model field for these samples so that we can make sure everything works when that is the case *)
				Upload[Flatten[{
					<|Object -> #, DeveloperObject -> True|>& /@ PickList[allObjs, DatabaseMemberQ[allObjs]]
				}]];
				UploadSampleStatus[sample4, Discarded, FastTrack -> True]

			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[
			{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Fake bench for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 1 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 2 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 4 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 5 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 6 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 7 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 8 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 9 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 10 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 11 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 12 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 13 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 14 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Container, Plate, "Fake plate 1 for ValidExperimentDiluteQ tests"<> $SessionUUID],
				Object[Sample, "ValidExperimentDiluteQ New Test Chemical 1 (100 uL)"<> $SessionUUID],
				Object[Sample, "ValidExperimentDiluteQ New Test Chemical 2 (100 uL)"<> $SessionUUID],
				Object[Sample, "ValidExperimentDiluteQ New Test Chemical 3 (200 uL)"<> $SessionUUID],
				Object[Sample, "ValidExperimentDiluteQ New Test Chemical 4 (Discarded)"<> $SessionUUID],
				Object[Sample, "ValidExperimentDiluteQ New Test Chemical 5 (no amount)"<> $SessionUUID],
				Object[Sample, "ValidExperimentDiluteQ New Test Chemcial 6 (100 mg)"<> $SessionUUID],
				Object[Sample, "ValidExperimentDiluteQ New Test Chemical 7 (0.01 uL)"<> $SessionUUID],
				Object[Sample, "ValidExperimentDiluteQ New Test Chemical 8 (120 uL)"<> $SessionUUID],
				Object[Sample, "ValidExperimentDiluteQ New Test Chemical 9 (200 uL)"<> $SessionUUID],
				Object[Sample, "ValidExperimentDiluteQ New Test Chemical In Plate 2 (100 uL)"<> $SessionUUID],
				Object[Sample, "ValidExperimentDiluteQ New Test Chemical In Plate 3 (100 uL)"<> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "Existing ValidExperimentDiluteQ Protocol"<> $SessionUUID]
			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];

(* ::Subsection:: *)
(*Dilute Unit Op*)

DefineTests[
	Dilute,
	{
		Example[
			{Basic,"Use an Dilute primitive to call ExperimentManualSamplePreparation and generate a protocol:"},
			ExperimentManualSamplePreparation[{
				LabelContainer[
					Label -> "My Dilution Plate 1",
					Container -> Model[Container, Plate, "96-well UV-Star Plate"]
				],
				Transfer[
					Source -> Model[Sample, "Milli-Q water"],
					Destination -> "My Dilution Plate 1",
					Amount -> 20 Microliter
				],
				Dilute[
					Sample -> "My Dilution Plate 1",
					TotalVolume -> 300 Microliter
				]
			}],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		],
		Test["Use an Dilute primitive to call ExperimentRoboticSamplePreparation and generate a protocol:",
			ExperimentRoboticSamplePreparation[{
				Dilute[
					Sample -> Object[Sample, "Dilute New Test Chemical 1 (100 uL)"<> $SessionUUID],
					TotalVolume -> 200 Microliter,
					MixType->Pipette
				]
			}],
			ObjectP[Object[Protocol, RoboticSamplePreparation]],
			TimeConstraint -> 1000
		],
		Test["Use an Dilute primitive to call ExperimentSamplePreparation and generate a protocol:",
			ExperimentSamplePreparation[{
				LabelContainer[
					Label -> "My Dilution Tube 1",
					Container -> Model[Container, Vessel, "2mL Tube"]
				],
				Transfer[
					Source -> Model[Sample, "Milli-Q water"],
					Destination -> "My Dilution Tube 1",
					Amount -> 100 Microliter
				],
				Dilute[
					Sample -> "My Dilution Tube 1",
					TotalVolume -> 1000 Microliter
				]
			}],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			TimeConstraint -> 1000
		]
	},
	Stubs:>{
		$EmailEnabled=False,
		$AllowSystemsProtocols = True,
		$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"]
	},
	SetUp:>($CreatedObjects={}),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[
			{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Fake bench for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 1 for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 2 for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 4 for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 5 for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 6 for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 7 for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 8 for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 9 for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 10 for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 11 for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 12 for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 13 for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 14 for Dilute tests"<> $SessionUUID],
				Object[Container, Plate, "Fake plate 1 for Dilute tests"<> $SessionUUID],
				Object[Sample, "Dilute New Test Chemical 1 (100 uL)"<> $SessionUUID],
				Object[Sample, "Dilute New Test Chemical 2 (100 uL)"<> $SessionUUID],
				Object[Sample, "Dilute New Test Chemical 3 (200 uL)"<> $SessionUUID],
				Object[Sample, "Dilute New Test Chemical 4 (Discarded)"<> $SessionUUID],
				Object[Sample, "Dilute New Test Chemical 5 (no amount)"<> $SessionUUID],
				Object[Sample, "Dilute New Test Chemcial 6 (100 mg)"<> $SessionUUID],
				Object[Sample, "Dilute New Test Chemical 7 (0.01 uL)"<> $SessionUUID],
				Object[Sample, "Dilute New Test Chemical 8 (120 uL)"<> $SessionUUID],
				Object[Sample, "Dilute New Test Chemical 9 (200 uL)"<> $SessionUUID],
				Object[Sample, "Dilute New Test Chemical In Plate 2 (100 uL)"<> $SessionUUID],
				Object[Sample, "Dilute New Test Chemical In Plate 3 (100 uL)"<> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "Existing Dilute Protocol"<> $SessionUUID]
			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					fakeBench,
					container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11, container12, container13, container14, plate1,
					sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11,
					allObjs, templateProtocol
				},

				fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for Dilute tests"<> $SessionUUID, DeveloperObject -> True|>];
				{
					container,
					container2,
					container3,
					container4,
					container5,
					container6,
					container7,
					container8,
					container9,
					container10,
					container11,
					container12,
					container13,
					container14,
					plate1
				} = UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"]
					},
					{
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench}
					},
					Status -> {
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available
					},
					Name -> {
						"Fake container 1 for Dilute tests"<> $SessionUUID,
						"Fake container 2 for Dilute tests"<> $SessionUUID,
						"Fake container 3 for Dilute tests"<> $SessionUUID,
						"Fake container 4 for Dilute tests"<> $SessionUUID,
						"Fake container 5 for Dilute tests"<> $SessionUUID,
						"Fake container 6 for Dilute tests"<> $SessionUUID,
						"Fake container 7 for Dilute tests"<> $SessionUUID,
						"Fake container 8 for Dilute tests"<> $SessionUUID,
						"Fake container 9 for Dilute tests"<> $SessionUUID,
						"Fake container 10 for Dilute tests"<> $SessionUUID,
						"Fake container 11 for Dilute tests"<> $SessionUUID,
						"Fake container 12 for Dilute tests"<> $SessionUUID,
						"Fake container 13 for Dilute tests"<> $SessionUUID,
						"Fake container 14 for Dilute tests"<> $SessionUUID,
						"Fake plate 1 for Dilute tests"<> $SessionUUID
					}
				];
				{
					sample,
					sample2,
					sample3,
					sample4,
					sample5,
					sample6,
					sample7,
					sample8,
					sample9,
					sample10,
					sample11
				} = UploadSample[
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Acetone, Reagent Grade"],
						Model[Sample, StockSolution, "10x UV buffer"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "T7 RNA Polymerase"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"]
					},
					{
						{"A1", container},
						{"A1", container2},
						{"A1", container3},
						{"A1", container4},
						{"A1", container5},
						{"A1", container6},
						{"A1", container7},
						{"A1", container8},
						{"A1", container9},
						{"A1", plate1},
						{"A2", plate1}
					},
					InitialAmount -> {
						100 Microliter,
						100 Microliter,
						200 Microliter,
						100 Microliter,
						Null,
						100 Milligram,
						0.01 Microliter,
						120 Microliter,
						200 Microliter,
						100 Microliter,
						100 Microliter
					},
					Name -> {
						"Dilute New Test Chemical 1 (100 uL)"<> $SessionUUID,
						"Dilute New Test Chemical 2 (100 uL)"<> $SessionUUID,
						"Dilute New Test Chemical 3 (200 uL)"<> $SessionUUID,
						"Dilute New Test Chemical 4 (Discarded)"<> $SessionUUID,
						"Dilute New Test Chemical 5 (no amount)"<> $SessionUUID,
						"Dilute New Test Chemcial 6 (100 mg)"<> $SessionUUID,
						"Dilute New Test Chemical 7 (0.01 uL)"<> $SessionUUID,
						"Dilute New Test Chemical 8 (120 uL)"<> $SessionUUID,
						"Dilute New Test Chemical 9 (200 uL)"<> $SessionUUID,
						"Dilute New Test Chemical In Plate 2 (100 uL)"<> $SessionUUID,
						"Dilute New Test Chemical In Plate 3 (100 uL)"<> $SessionUUID
					}
				];


				(* make a new protocol object for templating *)
				templateProtocol = ExperimentDilute[sample8, TotalVolume -> 123 Microliter, Name -> "Existing Dilute Protocol"<> $SessionUUID];

				allObjs = Cases[Flatten[{
					container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11, container12, container13, container14, plate1,
					sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11,
					templateProtocol, Download[templateProtocol, {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]
				}], ObjectP[]];

				(* get rid of the Model field for these samples so that we can make sure everything works when that is the case *)
				Upload[Flatten[{
					<|Object -> #, DeveloperObject -> True|>& /@ PickList[allObjs, DatabaseMemberQ[allObjs]]
				}]];
				UploadSampleStatus[sample4, Discarded, FastTrack -> True]

			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[
			{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Fake bench for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 1 for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 2 for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 4 for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 5 for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 6 for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 7 for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 8 for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 9 for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 10 for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 11 for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 12 for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 13 for Dilute tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 14 for Dilute tests"<> $SessionUUID],
				Object[Container, Plate, "Fake plate 1 for Dilute tests"<> $SessionUUID],
				Object[Sample, "Dilute New Test Chemical 1 (100 uL)"<> $SessionUUID],
				Object[Sample, "Dilute New Test Chemical 2 (100 uL)"<> $SessionUUID],
				Object[Sample, "Dilute New Test Chemical 3 (200 uL)"<> $SessionUUID],
				Object[Sample, "Dilute New Test Chemical 4 (Discarded)"<> $SessionUUID],
				Object[Sample, "Dilute New Test Chemical 5 (no amount)"<> $SessionUUID],
				Object[Sample, "Dilute New Test Chemcial 6 (100 mg)"<> $SessionUUID],
				Object[Sample, "Dilute New Test Chemical 7 (0.01 uL)"<> $SessionUUID],
				Object[Sample, "Dilute New Test Chemical 8 (120 uL)"<> $SessionUUID],
				Object[Sample, "Dilute New Test Chemical 9 (200 uL)"<> $SessionUUID],
				Object[Sample, "Dilute New Test Chemical In Plate 2 (100 uL)"<> $SessionUUID],
				Object[Sample, "Dilute New Test Chemical In Plate 3 (100 uL)"<> $SessionUUID]
			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
]