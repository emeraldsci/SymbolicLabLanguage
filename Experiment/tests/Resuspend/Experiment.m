(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentResuspend*)


DefineTests[ExperimentResuspend,
	{
		Example[{Basic, "Generate a new protocol to resuspend a sample:"},
			ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 100 Microliter],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Basic, "Generate a new protocol to resuspend a sample robotically:"},
			ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 100 Microliter,MixType->Pipette],
			ObjectP[Object[Protocol, RoboticSamplePreparation]]
		],
		Example[{Basic, "Generate a new protocol to resuspend multiple samples:"},
			ExperimentResuspend[{Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Object[Sample, "ExperimentResuspend New Test Chemical 2 (100 mg)"<> $SessionUUID]}, Volume -> 100 Microliter],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Basic, "Generate a new protocol to resuspend multiple specified as containers:"},
			ExperimentResuspend[{Object[Container, Vessel, "Fake container 1 for ExperimentResuspend tests"<> $SessionUUID], Object[Container, Vessel, "Fake container 2 for ExperimentResuspend tests"<> $SessionUUID], Object[Container, Vessel, "Fake container 3 for ExperimentResuspend tests"<> $SessionUUID]}, Volume -> 100 Microliter],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Test["Ensure that manipulations are properly generated when resuspending in the current container:",
			prot = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 100 Microliter];
			Download[prot, OutputUnitOperations],
			_?(And[
				MemberQ[#, ObjectP[Object[UnitOperation, LabelContainer]]],
				MemberQ[#, ObjectP[Object[UnitOperation, LabelSample]]],
				MemberQ[#, ObjectP[Object[UnitOperation, Transfer]]],
				MemberQ[#, ObjectP[{Object[UnitOperation, Mix],Object[UnitOperation, Incubate]}]]
			]&),
			Variables :> {prot},
			TimeConstraint -> 1000
		],
		Test["Ensure that robotic OutputUnitOperations are properly generated:",
			prot = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], MixType -> Pipette, Volume -> 100 Microliter];
			Download[prot, OutputUnitOperations],
			{ObjectP[Object[UnitOperation, Resuspend]]},
			Variables :> {prot},
			TimeConstraint -> 1000
		],
		Test["Ensure that robotic manipulations are properly generated when resuspending in the current container:",
			prot = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], MixType -> Pipette, Volume -> 100 Microliter];
			Download[prot, OutputUnitOperations[[1]][RoboticUnitOperations]],
			_?(And[
				MemberQ[#, ObjectP[Object[UnitOperation, LabelContainer]]],
				MemberQ[#, ObjectP[Object[UnitOperation, LabelSample]]],
				MemberQ[#, ObjectP[Object[UnitOperation, Transfer]]]
			]&),
			Variables :> {prot},
			TimeConstraint -> 1000
		],
		Test["If resuspending two things in the same container and MixOrder -> Parallel, only do one Incubate primitive for the both of them (but a separate one for a separate sample):",
			prot = ExperimentResuspend[
				{
					Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID],
					Object[Sample, "ExperimentResuspend New Test Chemical In Plate 2 (100 mg)"<> $SessionUUID],
					Object[Sample, "ExperimentResuspend New Test Chemical In Plate 3 (100 mg)"<> $SessionUUID]
				},
				Volume -> 100 Microliter,
				MixOrder -> Parallel
			];
			Download[prot, OutputUnitOperations],
			_?(And[
				MemberQ[#, ObjectP[Object[UnitOperation, LabelContainer]]],
				MemberQ[#, ObjectP[Object[UnitOperation, LabelSample]]],
				MemberQ[#, ObjectP[Object[UnitOperation, Transfer]]],
				MemberQ[#, ObjectP[{Object[UnitOperation, Mix],Object[UnitOperation, Incubate]}]]
			]&),
			Variables :> {prot},
			TimeConstraint -> 1000
		],
		Test["Ensure that manipulations are properly generated when resuspending in the a different container:",
			prot = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Amount -> 50 Milligram, Volume -> 100 Microliter];
			Download[prot, OutputUnitOperations],
			_?(And[
				MemberQ[#, ObjectP[Object[UnitOperation, LabelContainer]]],
				MemberQ[#, ObjectP[Object[UnitOperation, LabelSample]]],
				MemberQ[#, ObjectP[Object[UnitOperation, Transfer]]],
				MemberQ[#, ObjectP[{Object[UnitOperation, Mix],Object[UnitOperation, Incubate]}]]
			]&),
			Variables :> {prot},
			TimeConstraint -> 1000
		],
		Test["Ensure that manipulations are properly generated when resuspending in a different container and check the amounts:",
			prot = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Amount -> 50 Milligram, Volume -> 200 Microliter];
			manips = Download[prot, OutputUnitOperations];
			{transferManip1, transferManip2} = Cases[manips, ObjectP[Object[UnitOperation, Transfer]]];
			{transferManip1[Amount], transferManip2[Amount]},
			{{400 Microliter}, {200 Microliter}},
			EquivalenceFunction -> Equal,
			Variables :> {prot, manips, transferManip1, transferManip2},
			TimeConstraint -> 1000
		],
		Test["Ensure that manipulations are properly generated when resuspending two different samples, one in the same container and one in another:",
			prot = ExperimentResuspend[
				{Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Object[Sample, "ExperimentResuspend New Test Chemical 2 (100 mg)"<> $SessionUUID]},
				Amount -> {All, 50Milligram},
				Volume -> 100 Microliter
			];
			Download[prot, OutputUnitOperations],
			_?(And[
				MemberQ[#, ObjectP[Object[UnitOperation, LabelContainer]]],
				MemberQ[#, ObjectP[Object[UnitOperation, LabelSample]]],
				MemberQ[#, ObjectP[Object[UnitOperation, Transfer]]],
				MemberQ[#, ObjectP[{Object[UnitOperation, Mix],Object[UnitOperation, Incubate]}]]
			]&),
			Variables :> {prot},
			TimeConstraint -> 1000
		],
		Test["Ensure that manipulations are properly generated when mixing by pipette:",
			prot = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 100 Microliter, MixType -> Pipette];
			Download[prot, OutputUnitOperations[[1]][RoboticUnitOperations]],
			_?(And[
				MemberQ[#, ObjectP[Object[UnitOperation, LabelContainer]]],
				MemberQ[#, ObjectP[Object[UnitOperation, LabelSample]]],
				MemberQ[#, ObjectP[Object[UnitOperation, Transfer]]]
			]&),
			Variables :> {prot},
			TimeConstraint -> 1000
		],
		Example[{Options, Amount, "Specify how much sample to resuspend:"},
			options=ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Amount -> 50 Milligram, Volume -> 100 Microliter,Output->Options];
			Lookup[options, Amount],
			50 Milligram,
			Variables :> {options},
			EquivalenceFunction -> Equal
		],
		Example[{Options, Amount, "If Amount is not specified, automatically set to the full amount of the sample:"},
			options=ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 100 Microliter,Output->Options];
			Lookup[options, Amount],
			100 Milligram,
			Variables :> {options},
			EquivalenceFunction -> Equal
		],
		Example[{Options, TargetConcentration, "If TargetConcentration is set for a solid and MolecularWeight is populated for this model, calculate the volumes properly:"},
			options = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], TargetConcentration -> 1 Molar, Output -> Options];
			Lookup[options, {TargetConcentration, Volume}],
			{1 Molar, VolumeP},
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "If TargetConcentration is set for a solid and MolecularWeight is not populated populated for this model but a mass concentration was provided, calculate the volumes properly:"},
			options = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Resin 1 (100 mg)"<> $SessionUUID], TargetConcentration -> 100*Milligram/Milliliter, Output -> Options];
			Lookup[options, {TargetConcentration, Volume}],
			{100*Milligram/Milliliter, VolumeP},
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "Specify which component of sample to set to the specified target concentration:"},
			options = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], TargetConcentration -> 1 Molar, TargetConcentrationAnalyte -> Model[Molecule, "Sodium Chloride"], Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, "Sodium Chloride"]],
			Variables :> {options}
		],
		Example[{Options, Volume, "Specify the amount of liquid to add to the samples:"},
			prot = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 1 Milliliter];
			FirstCase[Download[prot, OutputUnitOperations], ObjectP[Object[UnitOperation, Transfer]]][Amount],
			{1 Milliliter},
			Variables :> {prot},
			EquivalenceFunction -> Equal
		],
		Example[{Options, ContainerOut, "Specify the container in which to resuspend the samples:"},
			prot = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], ContainerOut -> Model[Container, Vessel, "50mL Tube"], Volume -> 1.5 Milliliter];
			FirstCase[Download[prot, OutputUnitOperations], ObjectP[Object[UnitOperation, LabelContainer]]][Container],
			{ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {prot},
			TimeConstraint -> 1000
		],
		Example[{Options, ContainerOut, "If not specified, ContainerOut is automatically set to the current container of the specified samples:"},
			options = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 1 Milliliter,Output->Options];
			Lookup[options, ContainerOut],
			{1,ObjectP[Object[Container, Vessel, "Fake container 1 for ExperimentResuspend tests"<> $SessionUUID]]},
			Variables :> {options}
		],
		Example[{Options, ContainerOut, "If not specified, ContainerOut is automatically set to the current container of the specified samples:"},
			prot = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 1 Milliliter];
			FirstCase[Download[prot, OutputUnitOperations], ObjectP[Object[UnitOperation, LabelContainer]]][Container],
			{ObjectP[Object[Container, Vessel, "Fake container 1 for ExperimentResuspend tests"<> $SessionUUID]]},
			Variables :> {prot}
		],
		Example[{Options, DestinationWell, "Specify the position in the specified container in which to resuspend the samples:"},
			options = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], DestinationWell -> "A2", ContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], Volume -> 1 Milliliter, Output -> Options];
			Lookup[options, DestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, Diluent, "Specify the solvent in which to dissolve the provided sample:"},
			prot = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Resin 1 (100 mg)"<> $SessionUUID], Diluent -> Model[Sample, "Methanol"], Volume -> 1 Milliliter];
			LookupLabeledObject[prot,FirstCase[Download[prot, OutputUnitOperations], ObjectP[Object[UnitOperation, Transfer]]][Source]],
			{ObjectP[Model[Sample, "Methanol"]]},
			Variables :> {prot}
		],
		Example[{Options, ConcentratedBuffer, "Specify the concentrated buffer to be diluted that should dissolve the provided sample:"},
			prot = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Resin 1 (100 mg)"<> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], Volume -> 1 Milliliter];
			LookupLabeledObject[prot,FirstCase[Download[prot, OutputUnitOperations], ObjectP[Object[UnitOperation, Transfer]]][Source][[2]]],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {prot},
			TimeConstraint -> 1000
		],
		Example[{Options, BufferDiluent, "Specify the sample to dilute the concentrated buffer that should dissolve the provided sample:"},
			prot = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Resin 1 (100 mg)"<> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], BufferDiluent -> Model[Sample, "Milli-Q water"], Volume -> 1 Milliliter];
			LookupLabeledObject[prot,FirstCase[Download[prot, OutputUnitOperations], ObjectP[Object[UnitOperation, Transfer]]][Source][[1]]],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {prot}
		],
		Example[{Options, BufferDilutionFactor, "Specify the factor by which to dilute the concentrated buffer that should dissolve the provided sample:"},
			prot = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Resin 1 (100 mg)"<> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, Volume -> 1 Milliliter];
			(FirstCase[Download[prot, OutputUnitOperations], ObjectP[Object[UnitOperation, Transfer]]][Amount][[2]] + FirstCase[Download[prot, OutputUnitOperations], ObjectP[Object[UnitOperation, Transfer]]][Amount][[1]])/ FirstCase[Download[prot, OutputUnitOperations], ObjectP[Object[UnitOperation, Transfer]]][Amount][[2]],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {prot},
			TimeConstraint -> 1000
		],
		Example[{Options, Mix, "Indicate if the samples should (or should not) be mixed after addition of liquid:"},
			options = ExperimentResuspend[{Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Object[Sample, "ExperimentResuspend New Test Chemical 1 (3 Tablets)"<> $SessionUUID]}, Mix -> {False, True}, Volume -> 1 Milliliter, Output -> Options];
			Lookup[options, Mix],
			{False, True},
			Variables :> {options}
		],
		Example[{Options, MixType, "Indicate by what method the samples should be mixed after the addition of liquid:"},
			options = ExperimentResuspend[{Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Object[Sample, "ExperimentResuspend New Test Chemical 1 (3 Tablets)"<> $SessionUUID]}, MixType -> {Pipette, Vortex}, Volume -> 1 Milliliter, Output -> Options];
			Lookup[options, MixType],
			{Pipette, Vortex},
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Indicate if the samples should be mixed until they are dissolved:"},
			options = ExperimentResuspend[{Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Object[Sample, "ExperimentResuspend New Test Chemical 1 (3 Tablets)"<> $SessionUUID]}, MixUntilDissolved -> True, MixType -> Vortex, Volume -> 1 Milliliter, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],
		Example[{Options, NumberOfMixes, "Indicate how many times the samples should be mixed:"},
			options = ExperimentResuspend[{Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Object[Sample, "ExperimentResuspend New Test Chemical 1 (3 Tablets)"<> $SessionUUID]}, Volume -> 0.9 Milliliter, MixType -> Pipette, NumberOfMixes -> 5, Output -> Options];
			Lookup[options, NumberOfMixes],
			5,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Indicates the length of time samples should be mixed and/or heated:"},
			options = ExperimentResuspend[{Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Object[Sample, "ExperimentResuspend New Test Chemical 1 (3 Tablets)"<> $SessionUUID]}, IncubationTime -> 10 Minute, Volume -> 1 Milliliter, Output -> Options];
			Lookup[options, IncubationTime],
			10 Minute,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Indicates the maximum length of time samples should be mixed and/or heated when mixing until dissolving:"},
			options = ExperimentResuspend[{Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Object[Sample, "ExperimentResuspend New Test Chemical 1 (3 Tablets)"<> $SessionUUID]}, IncubationTime -> 10 Minute,  MixUntilDissolved -> True, MaxIncubationTime -> 30 Minute, Volume -> 1 Milliliter, Output -> Options];
			Lookup[options, MaxIncubationTime],
			30 Minute,
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Indicates the minimum duration for which the sample should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed:"},
			options = ExperimentResuspend[{Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Object[Sample, "ExperimentResuspend New Test Chemical 1 (3 Tablets)"<> $SessionUUID]}, IncubationTime -> 10 Minute, AnnealingTime -> 30 Minute, Volume -> 1 Milliliter, Output -> Options];
			Lookup[options, AnnealingTime],
			30 Minute,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Indicates the temperature at which the specified samples should be held during incubation/mixing:"},
			options = ExperimentResuspend[{Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Object[Sample, "ExperimentResuspend New Test Chemical 1 (3 Tablets)"<> $SessionUUID]}, IncubationTime -> 10 Minute, IncubationTemperature -> {Ambient, 40 Celsius}, Volume -> 1 Milliliter, Output -> Options];
			Lookup[options, IncubationTemperature],
			{Ambient, 40 Celsius},
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "Indicates the instrument to use during mixing and/or incubating:"},
			options = ExperimentResuspend[{Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Object[Sample, "ExperimentResuspend New Test Chemical 1 (3 Tablets)"<> $SessionUUID]}, IncubationInstrument -> Model[Instrument, Shaker, "Genie Temp-Shaker 300"], Volume -> 1 Milliliter, Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument, Shaker, "Genie Temp-Shaker 300"]],
			Variables :> {options}
		],
		Example[{Options, Name, "Specify the name of the protocol object to be generated:"},
			prot = ExperimentResuspend[{Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Object[Sample, "ExperimentResuspend New Test Chemical 1 (3 Tablets)"<> $SessionUUID]}, Name -> "ExperimentResuspend Protocol 1", Volume -> 1 Milliliter];
			Download[prot, Name],
			"ExperimentResuspend Protocol 1",
			Variables :> {prot},
			TimeConstraint -> 1000
		],
		Example[{Options, Template, "Specify a protocol whose options to use for the current protocol:"},
			options = ExperimentResuspend[{Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID]}, Template -> Object[Protocol, ManualSamplePreparation, "Existing ExperimentResuspend Protocol"<> $SessionUUID], Output->Options];
			Lookup[options, Volume],
			123 Microliter,
			Variables :> {options}
		],
		Example[{Options, SamplesOutStorageCondition, "Specify the condition in which samples should be stored upon completion of the resuspension experiment:"},
			options = ExperimentResuspend[{Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Object[Sample, "ExperimentResuspend New Test Chemical 1 (3 Tablets)"<> $SessionUUID]}, Volume -> 1 Milliliter, SamplesOutStorageCondition -> Freezer, Output -> Options];
			Lookup[options, SamplesOutStorageCondition],
			Freezer,
			Variables :> {options}
		],
		Example[{Options, MixOrder, "Specify whether the samples should be mixed after the liquid is added for all the samples (Parallel) or after liquid is added to each sample (Serial):"},
			options = ExperimentResuspend[{Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Object[Sample, "ExperimentResuspend New Test Chemical 1 (3 Tablets)"<> $SessionUUID]}, Amount -> {All, 2}, Volume -> 100 Microliter, MixOrder -> Parallel,Output->Options];
			Lookup[options, MixOrder],
			Parallel,
			Variables :> {options},
			TimeConstraint -> 1000
		],
		Example[{Options, MixOrder, "Specify whether the samples should be mixed after the liquid is added for all the samples (Parallel) or after liquid is added to each sample (Serial):"},
			prot = ExperimentResuspend[{Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Object[Sample, "ExperimentResuspend New Test Chemical 2 (100 mg)"<> $SessionUUID]}, Amount -> {All, 50Milligram}, Volume -> 100 Microliter, MixOrder -> Parallel];
			Download[prot, OutputUnitOperations],
			_?(And[
				MemberQ[#, ObjectP[Object[UnitOperation, LabelContainer]]],
				MemberQ[#, ObjectP[Object[UnitOperation, LabelSample]]],
				MemberQ[#, ObjectP[Object[UnitOperation, Transfer]]],
				MemberQ[#, ObjectP[{Object[UnitOperation, Mix],Object[UnitOperation, Incubate]}]]
			]&),
			Variables :> {prot},
			TimeConstraint -> 1000
		],
		Example[{Options, ImageSample, "If ImageSample -> False, do not image the samples after the protocol is completed:"},
			prot = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 1 Milliliter, ImageSample -> False];
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
			prot = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 1 Milliliter, MeasureVolume -> False];
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
			prot = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 1 Milliliter, MeasureWeight -> False];
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
			options = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 100 Microliter, SampleLabel -> "Sample 1", Output -> Options, Preparation -> Robotic];
			Lookup[options, SampleLabel],
			"Sample 1",
			Variables :> {options}
		],
		Example[{Options, SampleLabel, "If not specified but in a work cell resolution, automatically set to some string:"},
			options = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 100 Microliter,Output -> Options, Preparation -> Robotic];
			Lookup[options, {SampleLabel, SampleContainerLabel}],
			{_String, _String},
			Variables :> {options}
		],
		Example[{Options, SampleContainerLabel, "Specify the container label given to the input sample:"},
			options = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 100 Microliter, SampleContainerLabel -> "Container 1", Output -> Options, Preparation -> Robotic];
			Lookup[options, SampleContainerLabel],
			"Container 1",
			Variables :> {options}
		],
		Example[{Options, SampleOutLabel, "Specify the sample label given to the sample out.  If not specified, set to a string:"},
			options = ExperimentResuspend[
				{
					Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID],
					Object[Sample, "ExperimentResuspend New Test Chemical 2 (100 mg)"<> $SessionUUID]
				},
				SampleOutLabel -> {
					"SampleOut 1",
					Automatic
				},
				Volume -> 100 Microliter,
				Output -> Options,
				Preparation -> Robotic
			];
			Lookup[options, SampleOutLabel],
			{"SampleOut 1", _String},
			Variables :> {options}
		],
		Example[{Options, ContainerOutLabel, "Specify the container label given to the container out.  If not specified, set to a string:"},
			options = ExperimentResuspend[
				{
					Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID],
					Object[Sample, "ExperimentResuspend New Test Chemical 2 (100 mg)"<> $SessionUUID]
				},
				ContainerOutLabel -> {
					"ContainerOut 1",
					Automatic
				},
				Volume -> 100 Microliter,
				Output -> Options,
				Preparation -> Robotic
			];
			Lookup[options, ContainerOutLabel],
			{"ContainerOut 1", _String},
			Variables :> {options}
		],
		Example[{Options, DiluentLabel, "Specify the label given to the AssayBuffer:"},
			options = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 100 Microliter, Diluent -> Model[Sample, "Milli-Q water"], DiluentLabel -> "Diluent 1", Output -> Options, Preparation -> Robotic];
			Lookup[options, DiluentLabel],
			"Diluent 1",
			Variables :> {options}
		],
		Example[{Options, DiluentLabel, "If not specified, set DiluentLabel to some string if using Diluent, or Null if not:"},
			options = ExperimentResuspend[
				{
					Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID],
					Object[Sample, "ExperimentResuspend New Test Chemical 2 (100 mg)"<> $SessionUUID]
				},
				Diluent -> {
					Model[Sample, "Milli-Q water"],
					Null
				},
				ConcentratedBuffer -> {
					Null,
					Model[Sample, StockSolution, "10x UV buffer"]
				},
				Volume -> 100 Microliter,
				Output -> Options,
				Preparation -> Robotic
			];
			Lookup[options, DiluentLabel],
			{_String, Null},
			Variables :> {options}
		],
		Example[{Options, BufferDiluentLabel, "Specify the label given to the BufferDiluent and ConcentratedBuffer:"},
			options = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 100 Microliter,BufferDiluent -> Model[Sample, "Milli-Q water"], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], BufferDiluentLabel -> "Buffer Diluent 1", ConcentratedBufferLabel -> "Concentrated Buffer 1", Output -> Options, Preparation -> Robotic];
			Lookup[options, {BufferDiluentLabel, ConcentratedBufferLabel}],
			{"Buffer Diluent 1", "Concentrated Buffer 1"},
			Variables :> {options}
		],
		Example[{Options, ConcentratedBufferLabel, "If not specified, automatically set ConcentratedBufferLabel and BufferDiluentLabel to some string label if using those options, or Null otherwise:"},
			options = ExperimentResuspend[
				{
					Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID],
					Object[Sample, "ExperimentResuspend New Test Chemical 2 (100 mg)"<> $SessionUUID]
				},
				BufferDiluent -> {
					Null,
					Model[Sample, "Milli-Q water"]
				},
				ConcentratedBuffer -> {
					Null,
					Model[Sample, StockSolution, "10x UV buffer"]
				},
				Volume->800Microliter,
				MixType->Pipette,
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
		Example[{Options, Preparation, "Set whether to use the liquid handlers or manual pipettes to perform this resuspension:"},
			options = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume->1Milliliter, Output -> Options, Preparation -> Manual];
			Lookup[options, Preparation],
			Manual,
			Variables :> {options}
		],
		Example[{Messages, "ResuspendPreparationInvalid", "Thow an error if the specified preparation cannot be performed:"},
			ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume->1Milliliter,Preparation -> Robotic, MixType->Vortex],
			$Failed,
			Messages:>{
				Error::MixInstrumentTypeMismatch,
				Error::ResuspendPreparationInvalid,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ObjectDoesNotExist","If an object does not exist, throw an error and return $Failed immediately:"},
			ExperimentResuspend[{Object[Sample, "Chemical that doesn't exist at all for ExperimentResuspend testing"<>$SessionUUID], Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID]}],
			$Failed,
			Messages:>{
				Download::ObjectDoesNotExist
			}
		],
		Example[{Messages, "InputContainsTemporalLinks", "Throw a message if given a temporal link:"},
			ExperimentResuspend[Link[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Now - 1 Minute], Volume -> 1 Milliliter],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			Messages :> {Warning::InputContainsTemporalLinks}
		],
		Example[{Messages,"DiscardedSamples","Discarded objects are not supported as inputs or options:"},
			ExperimentResuspend[Object[Sample,"ExperimentResuspend New Test Chemical 1 (Discarded)"<> $SessionUUID], Volume -> 1 Milliliter],
			$Failed,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"DeprecatedModels","Deprecated models are not supported for any option value:"},
			ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 200 Microliter, ContainerOut -> Model[Container, Vessel, "1KG tall small shoulder white plasticv rectangular solid bottle, Deprecated"]],
			$Failed,
			Messages:>{
				Error::DeprecatedModels,
				Error::InvalidInput
			}
		],
		Example[{Messages,"UnknownAmount","If a sample is being resuspended but doesn't have a mass or count populated, throw a warning but proceed:"},
			ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (no amount)"<> $SessionUUID], Amount -> 10 Milligram, Volume -> 200*Microliter],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			Messages:>{
				Warning::UnknownAmount
			}
		],
		Example[{Messages, "SampleStateInvalid", "If the input sample is a liquid, it cannot be resuspended:"},
			ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemcial 1 (200 uL)"<> $SessionUUID], Volume -> 1 Milliliter],
			$Failed,
			Messages :> {
				Error::SampleStateInvalid,
				Error::CannotResolveAmount,
				Error::InvalidInput
			}
		],
		Example[{Messages, "DuplicateName", "If the specified name already exists for a Resuspend protocol, an error is thrown:"},
			ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 200 Microliter, Name -> "Existing ExperimentResuspend Protocol"<> $SessionUUID],
			$Failed,
			Messages :> {
				Error::DuplicateName,
				Error::InvalidOption
			}
		],
		Example[{Messages, "MissingMolecularWeight", "If TargetConcentration is set for a solid but MolecularWeight is not populated, throw MissingMolecularWeight error:"},
			ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Resin 1 (100 mg)"<> $SessionUUID], TargetConcentration -> 1*Micromolar, Volume -> 1*Milliliter],
			$Failed,
			Messages :> {
				Error::MissingMolecularWeight,
				Error::InvalidOption
			}
		],
		Example[{Messages, "StateAmountMismatch", "The Amount option must reflect the state of the sample: tablets must be provided in discrete quantities:"},
			ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (3 Tablets)"<> $SessionUUID], Volume -> 1 Milliliter, Amount -> 2 Milligram],
			$Failed,
			Messages :> {
				Error::StateAmountMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "StateAmountMismatch", "The Amount option must reflect the state of the sample: non-tablets cannot be specified in discrete quantities:"},
			ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 1 Milliliter, Amount -> 2],
			$Failed,
			Messages :> {
				Error::StateAmountMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TargetConcentrationNotUsed", "If TargetConcentration is specified for a counted item, it is ignored and not used:"},
			ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (3 Tablets)"<> $SessionUUID], Amount -> 2, Volume -> 200*Microliter, TargetConcentration -> 1 Micromolar],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			Messages:>{
				Warning::TargetConcentrationNotUsed
			},
			TimeConstraint -> 1000
		],
		Example[{Messages,"CannotResolveAmount","If a sample has no amount populated in its Mass/Count fields and no Amount is specified, throw an error:"},
			ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (no amount)"<> $SessionUUID], Volume -> 200*Microliter],
			$Failed,
			Messages:>{
				Warning::UnknownAmount,
				Error::CannotResolveAmount,
				Error::InvalidInput
			}
		],
		Example[{Messages, "ConcentrationRatioMismatch", "If Amount, Volume, and TargetConcentation are all specified, they must not be conflicting:"},
			ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 0.9 Milliliter, Amount -> 100 Milligram, TargetConcentration -> 1 Micromolar],
			$Failed,
			Messages :> {
				Error::ConcentrationRatioMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CannotResolveVolume", "If Volume is not specified and cannot be resolved from TargetConcentration, an error is thrown:"},
			ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Amount -> 100 Milligram],
			$Failed,
			Messages :> {
				Error::CannotResolveVolume,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DestinationWellDoesntExist", "If DestinationWell is specified, it must be an existing position in the specified or resolved ContainerOut:"},
			ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Amount -> 100 Milligram, Volume -> 1 Milliliter, DestinationWell -> "A3"],
			$Failed,
			Messages :> {
				Error::DestinationWellDoesntExist,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ContainerOutMismatchedIndex", "If specifying ContainerOut with indices, containers of different models cannot have the same index:"},
			ExperimentResuspend[
				{Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID],Object[Sample, "ExperimentResuspend New Test Chemical 1 (3 Tablets)"<> $SessionUUID]},
				Volume -> 1 Milliliter,
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
			ExperimentResuspend[{Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID],Object[Sample, "ExperimentResuspend New Test Chemical 1 (3 Tablets)"<> $SessionUUID]}, Amount -> {50 Milligram, 3}, Volume -> 100 Microliter, ContainerOut -> {{1, Model[Container, Vessel, "2mL Tube"]}, {1, Model[Container, Vessel, "2mL Tube"]}}],
			$Failed,
			Messages :> {
				Error::ContainerOverOccupied,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ResuspendVolumeOverContainerMax", "If the specified Volume is greater than the specified or resolved ContainerOut, throw an error:"},
			ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Amount -> 100 Milligram, Volume -> 10 Milliliter],
			$Failed,
			Messages :> {
				Error::ResuspendInitialVolumeOverContainerMax,
				Error::ResuspendVolumeOverContainerMax,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ResuspendInitialVolumeOverContainerMax", "If transferring to a new container, the volume needed to resuspend in the source container first must be less than the MaxVolume of the source container:"},
			ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (3 Tablets)"<> $SessionUUID], Amount -> 2, Volume -> 49.8 Milliliter],
			$Failed,
			Messages :> {
				Error::ResuspendInitialVolumeOverContainerMax,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PartialResuspensionContainerInvalid", "If the ContainerOut is set to the current container, Amount must be equal to the full Mass/Count of the specified sample:"},
			ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Amount -> 10 Milligram, ContainerOut -> Object[Container, Vessel, "Fake container 1 for ExperimentResuspend tests"<> $SessionUUID], Volume -> 1 Milliliter],
			$Failed,
			Messages :> {
				Error::ResuspendInitialVolumeOverContainerMax,
				Error::PartialResuspensionContainerInvalid,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DuplicateSampleConflictingConditions", "If the same sample is specified more than once, it will only be resuspended once.  In this case, all the options for these samples must be identical:"},
			ExperimentResuspend[{Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID]}, Amount -> {60 Milligram, 80 Milligram}, Volume -> 1 Milliliter],
			$Failed,
			Messages :> {
				Error::DuplicateSampleConflictingConditions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "BufferDilutionMismatched", "If BufferDilutionFactor and/or BufferDiluent are specified, ConcentratedBuffer must also be specified:"},
			ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Resin 1 (100 mg)"<> $SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], Volume -> 1 Milliliter],
			$Failed,
			Messages :> {
				Error::BufferDilutionMismatched,
				Error::InvalidOption
			}
		],
		Example[{Messages,"OverspecifiedBuffer","Both Diluent and ConcentratedBuffer cannot be simultaneously requested:"},
			ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Resin 1 (100 mg)"<> $SessionUUID], Volume->100 Microliter, Diluent -> Model[Sample,StockSolution,"70% Ethanol"], ConcentratedBuffer -> Model[Sample,StockSolution,"10x UV buffer"]],
			$Failed,
			Messages:>{
				Error::OverspecifiedBuffer,
				Error::InvalidOption
			},
			TimeConstraint -> 1000
		],
		Example[
			{Messages,"MixInstrumentTypeMismatch","If the IncubationInstrument and MixType options do not agree, an error is thrown:"},
			ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 100 Microliter,IncubationInstrument->Model[Instrument,Vortex,"id:dORYzZn0o45q"],MixType->Pipette],
			$Failed,
			Messages:>{
				Error::MixInstrumentTypeMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "MixTypeNumberOfMixesMismatch", "Thow an error if NumberOfMixes is specified for incubation types:"},
			ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume->1Milliliter,NumberOfMixes -> 20, MixType->Vortex],
			$Failed,
			Messages:>{
				Error::MixTypeNumberOfMixesMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ResuspendMixTypeIncubationMismatch", "Thow an error if Incubation options are specified for Pipette/Swirl/Invert mix types:"},
			ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume->100Microliter,IncubationTime->20Minute, MixType->Pipette],
			$Failed,
			Messages:>{
				Error::ResuspendMixTypeIncubationMismatch,
				Error::InvalidOption
			}
		],
		Test["Use a Resuspend primitive to call ExperimentManualSamplePreparation and generate a protocol:",
			ExperimentManualSamplePreparation[{
				Resuspend[
					Sample -> Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID],
					Volume -> 1000 Microliter
				]
			}],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			TimeConstraint -> 1000
		],
		Test["Use a Resuspend primitive to call ExperimentRoboticSamplePreparation and generate a protocol:",
			ExperimentRoboticSamplePreparation[{
				Resuspend[
					Sample -> Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID],
					Volume -> 100 Microliter,
					MixType->Pipette
				]
			}],
			ObjectP[Object[Protocol, RoboticSamplePreparation]],
			TimeConstraint -> 1000
		],
		Test["Use a Resuspend primitive to call ExperimentRoboticSamplePreparation with a pre-labeled buffer and generate a protocol:",
			ExperimentRoboticSamplePreparation[{
				LabelSample[
					Label->"buffer",
					Sample->Model[Sample, "Milli-Q water"],
					Container->Model[Container, Plate, "200mL Polypropylene Robotic Reservoir, non-sterile"],
					Amount->200 Milliliter
				],
				Resuspend[
					Sample -> Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID],
					Volume -> 100 Microliter,
					Diluent->"buffer",
					MixType->Pipette
				]
			}],
			ObjectP[Object[Protocol, RoboticSamplePreparation]],
			TimeConstraint -> 1000
		],
		Test["Use a Resuspend primitive to call ExperimentSamplePreparation and generate a protocol:",
			ExperimentSamplePreparation[{
				Resuspend[
					Sample -> Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID],
					Volume -> 1000 Microliter
				]
			}],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			TimeConstraint -> 1000
		],
		Test["Return a simulation blob if Output -> Simulation:",
			ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 100 Microliter, Output -> Simulation],
			_Simulation,
			TimeConstraint -> 3000
		],
		Test["Return a simulation blob if Output -> Simulation with the correct volume of sample removed:",
			simulation = ExperimentResuspend[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 100 Microliter, Output -> Simulation];
			Download[Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume, Simulation -> simulation],
			EqualP[200.3 Microliter],
			Variables :> {simulation},
			TimeConstraint -> 3000
		]
	},
	Stubs:>{
		$EmailEnabled=False,
		$AllowSystemsProtocols = True,
		$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"]
	},
	SetUp:>(
		$CreatedObjects={};
	),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
	),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[
			{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Fake bench for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 1 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 2 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 4 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 5 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 6 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 7 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 8 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 9 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 10 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 11 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 12 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 13 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Plate, "Fake plate 1 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspend New Test Resin 1 (100 mg)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspend New Test Chemical 1 (3 Tablets)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspend New Test Chemical 1 (Discarded)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspend New Test Chemical 1 (no amount)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspend New Test Chemcial 1 (200 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspend New Test Chemical 2 (100 mg)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspend New Test Chemical 2 (0.01 mg)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspend New Test Chemical In Plate 2 (100 mg)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspend New Test Chemical In Plate 3 (100 mg)"<> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "Existing ExperimentResuspend Protocol"<> $SessionUUID]
			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					fakeBench,
					container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11, container12, container13, plate1,
					sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10,
					allObjs, templateProtocol
				},

				fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for ExperimentResuspend tests"<> $SessionUUID, DeveloperObject -> True|>];
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
					plate1
				} = UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
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
						Available
					},
					Name -> {
						"Fake container 1 for ExperimentResuspend tests"<> $SessionUUID,
						"Fake container 2 for ExperimentResuspend tests"<> $SessionUUID,
						"Fake container 3 for ExperimentResuspend tests"<> $SessionUUID,
						"Fake container 4 for ExperimentResuspend tests"<> $SessionUUID,
						"Fake container 5 for ExperimentResuspend tests"<> $SessionUUID,
						"Fake container 6 for ExperimentResuspend tests"<> $SessionUUID,
						"Fake container 7 for ExperimentResuspend tests"<> $SessionUUID,
						"Fake container 8 for ExperimentResuspend tests"<> $SessionUUID,
						"Fake container 9 for ExperimentResuspend tests"<> $SessionUUID,
						"Fake container 10 for ExperimentResuspend tests"<> $SessionUUID,
						"Fake container 11 for ExperimentResuspend tests"<> $SessionUUID,
						"Fake container 12 for ExperimentResuspend tests"<> $SessionUUID,
						"Fake container 13 for ExperimentResuspend tests"<> $SessionUUID,
						"Fake plate 1 for ExperimentResuspend tests"<> $SessionUUID
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
					sample10
				} = UploadSample[
					{
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Wang-ChemMatrix "],
						Model[Sample, "Test Ibuprofen tablet Model for ExperimentMeasureCount Testing"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Sodium Chloride"]
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
						{"A1", plate1},
						{"A2", plate1}
					},
					InitialAmount -> {
						100 * Milligram,
						100 * Milligram,
						3,
						100 * Milligram,
						Null,
						200 Microliter,
						100 * Milligram,
						0.01 * Milligram,
						100 * Milligram,
						100 * Milligram
					},
					Name -> {
						"ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID,
						"ExperimentResuspend New Test Resin 1 (100 mg)"<> $SessionUUID,
						"ExperimentResuspend New Test Chemical 1 (3 Tablets)"<> $SessionUUID,
						"ExperimentResuspend New Test Chemical 1 (Discarded)"<> $SessionUUID,
						"ExperimentResuspend New Test Chemical 1 (no amount)"<> $SessionUUID,
						"ExperimentResuspend New Test Chemcial 1 (200 uL)"<> $SessionUUID,
						"ExperimentResuspend New Test Chemical 2 (100 mg)"<> $SessionUUID,
						"ExperimentResuspend New Test Chemical 2 (0.01 mg)"<> $SessionUUID,
						"ExperimentResuspend New Test Chemical In Plate 2 (100 mg)"<> $SessionUUID,
						"ExperimentResuspend New Test Chemical In Plate 3 (100 mg)"<> $SessionUUID
					}
				];


				(* make a new protocol object for templating *)
				templateProtocol = ExperimentResuspend[sample7, Volume -> 123 Microliter, Name -> "Existing ExperimentResuspend Protocol"<> $SessionUUID];

				allObjs = Cases[Flatten[{
					container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11, container12, container13, plate1,
					sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10,
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
				Object[Container, Bench, "Fake bench for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 1 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 2 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 4 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 5 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 6 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 7 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 8 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 9 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 10 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 11 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 12 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 13 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Container, Plate, "Fake plate 1 for ExperimentResuspend tests"<> $SessionUUID],
				Object[Sample, "ExperimentResuspend New Test Chemical 1 (100 mg)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspend New Test Resin 1 (100 mg)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspend New Test Chemical 1 (3 Tablets)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspend New Test Chemical 1 (Discarded)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspend New Test Chemical 1 (no amount)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspend New Test Chemcial 1 (200 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspend New Test Chemical 2 (100 mg)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspend New Test Chemical 2 (0.01 mg)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspend New Test Chemical In Plate 2 (100 mg)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspend New Test Chemical In Plate 3 (100 mg)"<> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "Existing ExperimentResuspend Protocol"<> $SessionUUID]
			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];


(* ::Subsection::Closed:: *)
(*ExperimentResuspendPreview*)

DefineTests[ExperimentResuspendPreview,
	{
		Example[{Basic, "Always returns Null:"},
			ExperimentResuspendPreview[Object[Sample, "ExperimentResuspendPreview New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 100 Microliter],
			Null
		],
		Example[{Basic, "Always returns Null:"},
			ExperimentResuspendPreview[{Object[Sample, "ExperimentResuspendPreview New Test Chemical 1 (100 mg)"<> $SessionUUID], Object[Sample, "ExperimentResuspendPreview New Test Chemical 1 (3 Tablets)"<> $SessionUUID]}, Volume -> 100 Microliter],
			Null
		],
		Example[{Basic, "Always returns Null:"},
			ExperimentResuspendPreview[{Object[Container, Vessel, "Fake container 1 for ExperimentResuspendPreview tests"<> $SessionUUID], Object[Container, Vessel, "Fake container 2 for ExperimentResuspendPreview tests"<> $SessionUUID], Object[Container, Vessel, "Fake container 3 for ExperimentResuspendPreview tests"<> $SessionUUID]}, Volume -> 100 Microliter],
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
		Module[
			{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Fake bench for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 1 for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 2 for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 4 for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 5 for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 6 for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 7 for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 8 for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 9 for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 10 for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 11 for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 12 for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Container, Plate, "Fake plate 1 for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendPreview New Test Chemical 1 (100 mg)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendPreview New Test Resin 1 (100 mg)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendPreview New Test Chemical 1 (3 Tablets)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendPreview New Test Chemical 1 (Discarded)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendPreview New Test Chemical 1 (no amount)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendPreview New Test Chemcial 1 (200 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendPreview New Test Chemical 2 (100 mg)"<> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "Existing ExperimentResuspendPreview Protocol"<> $SessionUUID]
			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					fakeBench,
					container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11, container12, plate1,
					sample, sample2, sample3, sample4, sample5, sample6, sample7,
					allObjs
				},

				fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for ExperimentResuspendPreview tests"<> $SessionUUID, DeveloperObject -> True|>];
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
					plate1
				} = UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
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
						Available
					},
					Name -> {
						"Fake container 1 for ExperimentResuspendPreview tests"<> $SessionUUID,
						"Fake container 2 for ExperimentResuspendPreview tests"<> $SessionUUID,
						"Fake container 3 for ExperimentResuspendPreview tests"<> $SessionUUID,
						"Fake container 4 for ExperimentResuspendPreview tests"<> $SessionUUID,
						"Fake container 5 for ExperimentResuspendPreview tests"<> $SessionUUID,
						"Fake container 6 for ExperimentResuspendPreview tests"<> $SessionUUID,
						"Fake container 7 for ExperimentResuspendPreview tests"<> $SessionUUID,
						"Fake container 8 for ExperimentResuspendPreview tests"<> $SessionUUID,
						"Fake container 9 for ExperimentResuspendPreview tests"<> $SessionUUID,
						"Fake container 10 for ExperimentResuspendPreview tests"<> $SessionUUID,
						"Fake container 11 for ExperimentResuspendPreview tests"<> $SessionUUID,
						"Fake container 12 for ExperimentResuspendPreview tests"<> $SessionUUID,
						"Fake plate 1 for ExperimentResuspendPreview tests"<> $SessionUUID
					}
				];
				{
					sample,
					sample2,
					sample3,
					sample4,
					sample5,
					sample6,
					sample7
				} = UploadSample[
					{
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Wang-ChemMatrix "],
						Model[Sample, "Test Ibuprofen tablet Model for ExperimentMeasureCount Testing"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Sodium Chloride"]
					},
					{
						{"A1", container},
						{"A1", container2},
						{"A1", container3},
						{"A1", container4},
						{"A1", container5},
						{"A1", container6},
						{"A1", container7}
					},
					InitialAmount -> {
						100 * Milligram,
						100 * Milligram,
						3,
						100 * Milligram,
						Null,
						200 Microliter,
						100 * Milligram
					},
					Name -> {
						"ExperimentResuspendPreview New Test Chemical 1 (100 mg)"<> $SessionUUID,
						"ExperimentResuspendPreview New Test Resin 1 (100 mg)"<> $SessionUUID,
						"ExperimentResuspendPreview New Test Chemical 1 (3 Tablets)"<> $SessionUUID,
						"ExperimentResuspendPreview New Test Chemical 1 (Discarded)"<> $SessionUUID,
						"ExperimentResuspendPreview New Test Chemical 1 (no amount)"<> $SessionUUID,
						"ExperimentResuspendPreview New Test Chemcial 1 (200 uL)"<> $SessionUUID,
						"ExperimentResuspendPreview New Test Chemical 2 (100 mg)"<> $SessionUUID
					}
				];

				allObjs = Cases[Flatten[{
					container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11, container12, plate1,
					sample, sample2, sample3, sample4, sample5, sample6, sample7
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
				Object[Container, Bench, "Fake bench for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 1 for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 2 for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 4 for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 5 for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 6 for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 7 for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 8 for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 9 for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 10 for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 11 for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 12 for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Container, Plate, "Fake plate 1 for ExperimentResuspendPreview tests"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendPreview New Test Chemical 1 (100 mg)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendPreview New Test Resin 1 (100 mg)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendPreview New Test Chemical 1 (3 Tablets)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendPreview New Test Chemical 1 (Discarded)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendPreview New Test Chemical 1 (no amount)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendPreview New Test Chemcial 1 (200 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendPreview New Test Chemical 2 (100 mg)"<> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "Existing ExperimentResuspendPreview Protocol"<> $SessionUUID]
			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];

(* ::Subsection::Closed:: *)
(*ExperimentResuspendOptions*)

DefineTests[ExperimentResuspendOptions,
	{
		Example[{Basic, "Generate a new protocol to resuspend a sample:"},
			ExperimentResuspendOptions[Object[Sample, "ExperimentResuspendOptions New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 100 Microliter, OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Basic, "Generate a new protocol to resuspend multiple samples:"},
			ExperimentResuspendOptions[{Object[Sample, "ExperimentResuspendOptions New Test Chemical 1 (100 mg)"<> $SessionUUID], Object[Sample, "ExperimentResuspendOptions New Test Chemical 1 (3 Tablets)"<> $SessionUUID]}, Volume -> 100 Microliter, OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Basic, "Generate a new protocol to resuspend multiple specified as containers:"},
			ExperimentResuspendOptions[{Object[Container, Vessel, "Fake container 1 for ExperimentResuspendOptions tests"<> $SessionUUID], Object[Container, Vessel, "Fake container 2 for ExperimentResuspendOptions tests"<> $SessionUUID], Object[Container, Vessel, "Fake container 3 for ExperimentResuspendOptions tests"<> $SessionUUID]}, Volume -> 100 Microliter, OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Options, OutputFormat, "Return the resolved options for each sample as a list:"},
			ExperimentResuspendOptions[Object[Sample, "ExperimentResuspendOptions New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 1 Milliliter, OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Options, OutputFormat, "Return the resolved options for each sample as a table:"},
			ExperimentResuspendOptions[Object[Sample, "ExperimentResuspendOptions New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 1 Milliliter],
			Graphics_
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
		Module[
			{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Fake bench for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 1 for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 2 for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 4 for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 5 for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 6 for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 7 for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 8 for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 9 for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 10 for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 11 for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 12 for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Container, Plate, "Fake plate 1 for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendOptions New Test Chemical 1 (100 mg)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendOptions New Test Resin 1 (100 mg)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendOptions New Test Chemical 1 (3 Tablets)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendOptions New Test Chemical 1 (Discarded)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendOptions New Test Chemical 1 (no amount)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendOptions New Test Chemcial 1 (200 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendOptions New Test Chemical 2 (100 mg)"<> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "Existing ExperimentResuspendOptions Protocol"<> $SessionUUID]
			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					fakeBench,
					container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11, container12, plate1,
					sample, sample2, sample3, sample4, sample5, sample6, sample7,
					allObjs, templateProtocol
				},

				fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for ExperimentResuspendOptions tests"<> $SessionUUID, DeveloperObject -> True|>];
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
					plate1
				} = UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
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
						Available
					},
					Name -> {
						"Fake container 1 for ExperimentResuspendOptions tests"<> $SessionUUID,
						"Fake container 2 for ExperimentResuspendOptions tests"<> $SessionUUID,
						"Fake container 3 for ExperimentResuspendOptions tests"<> $SessionUUID,
						"Fake container 4 for ExperimentResuspendOptions tests"<> $SessionUUID,
						"Fake container 5 for ExperimentResuspendOptions tests"<> $SessionUUID,
						"Fake container 6 for ExperimentResuspendOptions tests"<> $SessionUUID,
						"Fake container 7 for ExperimentResuspendOptions tests"<> $SessionUUID,
						"Fake container 8 for ExperimentResuspendOptions tests"<> $SessionUUID,
						"Fake container 9 for ExperimentResuspendOptions tests"<> $SessionUUID,
						"Fake container 10 for ExperimentResuspendOptions tests"<> $SessionUUID,
						"Fake container 11 for ExperimentResuspendOptions tests"<> $SessionUUID,
						"Fake container 12 for ExperimentResuspendOptions tests"<> $SessionUUID,
						"Fake plate 1 for ExperimentResuspendOptions tests"<> $SessionUUID
					}
				];
				{
					sample,
					sample2,
					sample3,
					sample4,
					sample5,
					sample6,
					sample7
				} = UploadSample[
					{
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Wang-ChemMatrix "],
						Model[Sample, "Test Ibuprofen tablet Model for ExperimentMeasureCount Testing"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Sodium Chloride"]
					},
					{
						{"A1", container},
						{"A1", container2},
						{"A1", container3},
						{"A1", container4},
						{"A1", container5},
						{"A1", container6},
						{"A1", container7}
					},
					InitialAmount -> {
						100 * Milligram,
						100 * Milligram,
						3,
						100 * Milligram,
						Null,
						200 Microliter,
						100 * Milligram
					},
					Name -> {
						"ExperimentResuspendOptions New Test Chemical 1 (100 mg)"<> $SessionUUID,
						"ExperimentResuspendOptions New Test Resin 1 (100 mg)"<> $SessionUUID,
						"ExperimentResuspendOptions New Test Chemical 1 (3 Tablets)"<> $SessionUUID,
						"ExperimentResuspendOptions New Test Chemical 1 (Discarded)"<> $SessionUUID,
						"ExperimentResuspendOptions New Test Chemical 1 (no amount)"<> $SessionUUID,
						"ExperimentResuspendOptions New Test Chemcial 1 (200 uL)"<> $SessionUUID,
						"ExperimentResuspendOptions New Test Chemical 2 (100 mg)"<> $SessionUUID
					}
				];


				(* make a new protocol object for templating *)
				templateProtocol = ExperimentResuspend[sample7, Volume -> 123 Microliter, Name -> "Existing ExperimentResuspendOptions Protocol"<> $SessionUUID];

				allObjs = Cases[Flatten[{
					container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11, container12, plate1,
					sample, sample2, sample3, sample4, sample5, sample6, sample7,
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
				Object[Container, Bench, "Fake bench for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 1 for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 2 for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 4 for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 5 for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 6 for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 7 for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 8 for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 9 for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 10 for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 11 for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 12 for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Container, Plate, "Fake plate 1 for ExperimentResuspendOptions tests"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendOptions New Test Chemical 1 (100 mg)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendOptions New Test Resin 1 (100 mg)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendOptions New Test Chemical 1 (3 Tablets)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendOptions New Test Chemical 1 (Discarded)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendOptions New Test Chemical 1 (no amount)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendOptions New Test Chemcial 1 (200 uL)"<> $SessionUUID],
				Object[Sample, "ExperimentResuspendOptions New Test Chemical 2 (100 mg)"<> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "Existing ExperimentResuspendOptions Protocol"<> $SessionUUID]
			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];

(* ::Subsection::Closed:: *)
(*ValidExperimentResuspendQ*)

DefineTests[ValidExperimentResuspendQ,
	{
		Example[{Basic, "Generate a new protocol to resuspend a sample:"},
			ValidExperimentResuspendQ[
				Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (100 mg)"<> $SessionUUID],
				Volume -> 100 Microliter],
			True
		],
		Example[{Basic, "Generate a new protocol to resuspend multiple samples:"},
			ValidExperimentResuspendQ[{Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (100 mg)"<> $SessionUUID], Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (3 Tablets)"<> $SessionUUID]}, Volume -> 100 Microliter],
			True
		],
		Example[{Basic, "Generate a new protocol to resuspend multiple specified as containers:"},
			ValidExperimentResuspendQ[{Object[Container, Vessel, "Fake container 1 for ValidExperimentResuspendQ tests"<> $SessionUUID], Object[Container, Vessel, "Fake container 2 for ValidExperimentResuspendQ tests"<> $SessionUUID], Object[Container, Vessel, "Fake container 3 for ValidExperimentResuspendQ tests"<> $SessionUUID]}, Volume -> 100 Microliter],
			True
		],
		Example[{Options,Verbose,"Indicate whether all tests, no tests, or failures only are shown:"},
			ValidExperimentResuspendQ[Object[Sample,"ValidExperimentResuspendQ New Test Chemical 1 (Discarded)"<> $SessionUUID], Volume -> 1 Milliliter, Verbose -> Failures],
			False
		],
		Example[{Messages,"DiscardedSamples","Discarded objects are not supported as inputs or options:"},
			ValidExperimentResuspendQ[Object[Sample,"ValidExperimentResuspendQ New Test Chemical 1 (Discarded)"<> $SessionUUID], Volume -> 1 Milliliter],
			False
		],
		Example[{Options, OutputFormat, "Return a test summary if OutputFormat -> TestSummary:"},
			ValidExperimentResuspendQ[Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 100 Microliter, OutputFormat -> TestSummary],
			_EmeraldTestSummary
		],
		Example[{Messages,"DeprecatedModels","Deprecated models are not supported for any option value:"},
			ValidExperimentResuspendQ[Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 200 Microliter, ContainerOut -> Model[Container, Vessel, "1KG tall small shoulder white plasticv rectangular solid bottle, Deprecated"]],
			False
		],
		Example[{Messages,"UnknownAmount","If a sample is being resuspended but doesn't have a mass or count populated, throw a warning but proceed:"},
			ValidExperimentResuspendQ[Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (no amount)"<> $SessionUUID], Amount -> 10 Milligram, Volume -> 200*Microliter],
			True
		],
		Example[{Messages, "SampleStateInvalid", "If the input sample is a liquid, it cannot be resuspended:"},
			ValidExperimentResuspendQ[Object[Sample, "ValidExperimentResuspendQ New Test Chemcial 1 (200 uL)"<> $SessionUUID], Volume -> 1 Milliliter],
			False
		],
		Example[{Messages, "DuplicateName", "If the specified name already exists for a Resuspend protocol, an error is thrown:"},
			ValidExperimentResuspendQ[Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 200 Microliter, Name -> "Existing ValidExperimentResuspendQ Protocol"<> $SessionUUID],
			False
		],
		Example[{Messages, "MissingMolecularWeight", "If TargetConcentration is set for a solid but MolecularWeight is not populated, throw MissingMolecularWeight error:"},
			ValidExperimentResuspendQ[Object[Sample, "ValidExperimentResuspendQ New Test Resin 1 (100 mg)"<> $SessionUUID], TargetConcentration -> 1*Micromolar, Volume -> 1*Milliliter],
			False
		],
		Example[{Messages, "StateAmountMismatch", "The Amount option must reflect the state of the sample: tablets must be provided in discrete quantities:"},
			ValidExperimentResuspendQ[Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (3 Tablets)"<> $SessionUUID], Volume -> 1 Milliliter, Amount -> 2 Milligram],
			False
		],
		Example[{Messages, "StateAmountMismatch", "The Amount option must reflect the state of the sample: non-tablets cannot be specified in discrete quantities:"},
			ValidExperimentResuspendQ[Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 1 Milliliter, Amount -> 2],
			False
		],
		Example[{Messages, "TargetConcentrationNotUsed", "If TargetConcentration is specified for a counted item, it is ignored and not used:"},
			ValidExperimentResuspendQ[Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (3 Tablets)"<> $SessionUUID], Amount -> 2, Volume -> 200*Microliter, TargetConcentration -> 1 Micromolar],
			True
		],
		Example[{Messages,"CannotResolveAmount","If a sample has no amount populated in its Mass/Count fields and no Amount is specified, throw an error:"},
			ValidExperimentResuspendQ[Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (no amount)"<> $SessionUUID], Volume -> 200*Microliter],
			False
		],
		Example[{Messages, "ConcentrationRatioMismatch", "If Amount, Volume, and TargetConcentation are all specified, they must not be conflicting:"},
			ValidExperimentResuspendQ[Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (100 mg)"<> $SessionUUID], Volume -> 1 Milliliter, Amount -> 100 Milligram, TargetConcentration -> 1 Micromolar],
			False
		],
		Example[{Messages, "CannotResolveVolume", "If Volume is not specified and cannot be resolved from TargetConcentration, an error is thrown:"},
			ValidExperimentResuspendQ[Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (100 mg)"<> $SessionUUID], Amount -> 100 Milligram],
			False
		],
		Example[{Messages, "DestinationWellDoesntExist", "If DestinationWell is specified, it must be an existing position in the specified or resolved ContainerOut:"},
			ValidExperimentResuspendQ[Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (100 mg)"<> $SessionUUID], Amount -> 100 Milligram, Volume -> 1 Milliliter, DestinationWell -> "A3"],
			False
		],
		Example[{Messages, "ContainerOutMismatchedIndex", "If specifying ContainerOut with indices, containers of different models cannot have the same index:"},
			ValidExperimentResuspendQ[
				{Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (100 mg)"<> $SessionUUID],Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (3 Tablets)"<> $SessionUUID]},
				Volume -> 1 Milliliter,
				ContainerOut->{
					{1, Model[Container,Plate,"96-well 2mL Deep Well Plate"]},
					{1, Model[Container, Vessel, "2mL Tube"]}
				}
			],
			False
		],
		Example[{Messages, "ContainerOverOccupied", "If more positions in the destination container are requested than are available, throw an error:"},
			ValidExperimentResuspendQ[{Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (100 mg)"<> $SessionUUID],Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (3 Tablets)"<> $SessionUUID]}, Amount -> {1 Milligram, 3}, Volume -> 100 Microliter, ContainerOut -> {{1, Model[Container, Vessel, "2mL Tube"]}, {1, Model[Container, Vessel, "2mL Tube"]}}],
			False
		],
		Example[{Messages, "ResuspendVolumeOverContainerMax", "If the specified Volume is greater than the specified or resolved ContainerOut, throw an error:"},
			ValidExperimentResuspendQ[Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (100 mg)"<> $SessionUUID], Amount -> 100 Milligram, Volume -> 10 Milliliter],
			False
		],
		Example[{Messages, "PartialResuspensionContainerInvalid", "If the ContainerOut is set to the current container, Amount must be equal to the full Mass/Count of the specified sample:"},
			ValidExperimentResuspendQ[Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (100 mg)"<> $SessionUUID], Amount -> 10 Milligram, ContainerOut -> Object[Container, Vessel, "Fake container 1 for ValidExperimentResuspendQ tests"<> $SessionUUID], Volume -> 1 Milliliter],
			False
		],
		Example[{Messages, "DuplicateSampleConflictingConditions", "If the same sample is specified more than once, it will only be resuspended once.  In this case, all the options for these samples must be identical:"},
			ValidExperimentResuspendQ[{Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (100 mg)"<> $SessionUUID], Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (100 mg)"<> $SessionUUID]}, Amount -> {10 Milligram, 20 Milligram}, Volume -> 1 Milliliter],
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
		Module[
			{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Fake bench for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 1 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 2 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 4 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 5 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 6 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 7 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 8 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 9 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 10 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 11 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 12 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 13 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Plate, "Fake plate 1 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (100 mg)"<> $SessionUUID],
				Object[Sample, "ValidExperimentResuspendQ New Test Resin 1 (100 mg)"<> $SessionUUID],
				Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (3 Tablets)"<> $SessionUUID],
				Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (Discarded)"<> $SessionUUID],
				Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (no amount)"<> $SessionUUID],
				Object[Sample, "ValidExperimentResuspendQ New Test Chemcial 1 (200 uL)"<> $SessionUUID],
				Object[Sample, "ValidExperimentResuspendQ New Test Chemical 2 (100 mg)"<> $SessionUUID],
				Object[Sample, "ValidExperimentResuspendQ New Test Chemical 2 (0.01 mg)"<> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "Existing ValidExperimentResuspendQ Protocol"<> $SessionUUID]
			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					fakeBench,
					container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11, container12, container13, plate1,
					sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8,
					allObjs, templateProtocol
				},

				fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for ValidExperimentResuspendQ tests"<> $SessionUUID, DeveloperObject -> True|>];
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
					plate1
				} = UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
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
						Available
					},
					Name -> {
						"Fake container 1 for ValidExperimentResuspendQ tests"<> $SessionUUID,
						"Fake container 2 for ValidExperimentResuspendQ tests"<> $SessionUUID,
						"Fake container 3 for ValidExperimentResuspendQ tests"<> $SessionUUID,
						"Fake container 4 for ValidExperimentResuspendQ tests"<> $SessionUUID,
						"Fake container 5 for ValidExperimentResuspendQ tests"<> $SessionUUID,
						"Fake container 6 for ValidExperimentResuspendQ tests"<> $SessionUUID,
						"Fake container 7 for ValidExperimentResuspendQ tests"<> $SessionUUID,
						"Fake container 8 for ValidExperimentResuspendQ tests"<> $SessionUUID,
						"Fake container 9 for ValidExperimentResuspendQ tests"<> $SessionUUID,
						"Fake container 10 for ValidExperimentResuspendQ tests"<> $SessionUUID,
						"Fake container 11 for ValidExperimentResuspendQ tests"<> $SessionUUID,
						"Fake container 12 for ValidExperimentResuspendQ tests"<> $SessionUUID,
						"Fake container 13 for ValidExperimentResuspendQ tests"<> $SessionUUID,
						"Fake plate 1 for ValidExperimentResuspendQ tests"<> $SessionUUID
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
					sample8
				} = UploadSample[
					{
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Wang-ChemMatrix "],
						Model[Sample, "Test Ibuprofen tablet Model for ExperimentMeasureCount Testing"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Sodium Chloride"]
					},
					{
						{"A1", container},
						{"A1", container2},
						{"A1", container3},
						{"A1", container4},
						{"A1", container5},
						{"A1", container6},
						{"A1", container7},
						{"A1", container8}
					},
					InitialAmount -> {
						100 * Milligram,
						100 * Milligram,
						3,
						100 * Milligram,
						Null,
						200 Microliter,
						100 * Milligram,
						0.01 * Milligram
					},
					Name -> {
						"ValidExperimentResuspendQ New Test Chemical 1 (100 mg)"<> $SessionUUID,
						"ValidExperimentResuspendQ New Test Resin 1 (100 mg)"<> $SessionUUID,
						"ValidExperimentResuspendQ New Test Chemical 1 (3 Tablets)"<> $SessionUUID,
						"ValidExperimentResuspendQ New Test Chemical 1 (Discarded)"<> $SessionUUID,
						"ValidExperimentResuspendQ New Test Chemical 1 (no amount)"<> $SessionUUID,
						"ValidExperimentResuspendQ New Test Chemcial 1 (200 uL)"<> $SessionUUID,
						"ValidExperimentResuspendQ New Test Chemical 2 (100 mg)"<> $SessionUUID,
						"ValidExperimentResuspendQ New Test Chemical 2 (0.01 mg)"<> $SessionUUID
					}
				];


				(* make a new protocol object for templating *)
				templateProtocol = ExperimentResuspend[sample7, Volume -> 123 Microliter, Name -> "Existing ValidExperimentResuspendQ Protocol"<> $SessionUUID];

				allObjs = Cases[Flatten[{
					container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11, container12, container13, plate1,
					sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8,
					templateProtocol, Download[templateProtocol, {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]
				}], ObjectP[]];

				(* get rid of the Model field for these samples so that we can make sure everything works when that is the case *)
				Upload[Flatten[{
					<|Object -> #, DeveloperObject -> True|>& /@ PickList[allObjs, DatabaseMemberQ[allObjs]]
				}]];
				UploadSampleStatus[{sample4, container4}, Discarded, FastTrack -> True]

			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[
			{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Fake bench for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 1 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 2 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 4 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 5 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 6 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 7 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 8 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 9 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 10 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 11 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 12 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Vessel, "Fake container 13 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Container, Plate, "Fake plate 1 for ValidExperimentResuspendQ tests"<> $SessionUUID],
				Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (100 mg)"<> $SessionUUID],
				Object[Sample, "ValidExperimentResuspendQ New Test Resin 1 (100 mg)"<> $SessionUUID],
				Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (3 Tablets)"<> $SessionUUID],
				Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (Discarded)"<> $SessionUUID],
				Object[Sample, "ValidExperimentResuspendQ New Test Chemical 1 (no amount)"<> $SessionUUID],
				Object[Sample, "ValidExperimentResuspendQ New Test Chemcial 1 (200 uL)"<> $SessionUUID],
				Object[Sample, "ValidExperimentResuspendQ New Test Chemical 2 (0.01 mg)"<> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "Existing ValidExperimentResuspendQ Protocol"<> $SessionUUID]
			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];