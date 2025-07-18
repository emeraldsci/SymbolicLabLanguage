(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentAliquot*)


DefineTests[ExperimentAliquot,
	{
		Example[{Basic, "Aliquot the full volume of a sample into a new container of the preferred container for the volume:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], All],
			ObjectP[Object[Protocol, RoboticSamplePreparation]]
		],
		Example[{Basic, "Aliquot a specific volume of a sample into a new container:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], 1 Milliliter, ContainerOut -> Model[Container, Vessel, "2mL Tube"]],
			ObjectP[Object[Protocol, RoboticSamplePreparation]]
		],
		Example[{Basic, "Aliquot a specific mass of a solid sample into a new container. Solids must be ManualSamplePreparation:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (100 mg)"<>$SessionUUID], 10 Milligram, ContainerOut -> Model[Container, Vessel, "2mL Tube"]],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Basic, "Aliquot a specific number of tablets of a sample into a new container. Tablets must be ManualSamplePreparation:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (3 Tablets)"<>$SessionUUID], 2, ContainerOut -> Model[Container, Vessel, "2mL Tube"]],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Basic, "Dilute a sample to a new target concentration:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], 50 Micromolar],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			TimeConstraint -> 500,
			Messages :> {Warning::RoundedTransferAmount}
		],
		Example[{Additional, "Containers", "Aliquot the full volume of all the samples into the PreferredContainer of that volume:"},
			ExperimentAliquot[Object[Container, Vessel, "Test container 1 for ExperimentAliquot Tests"<>$SessionUUID]],
			ObjectP[Object[Protocol, RoboticSamplePreparation]]
		],
		Example[{Additional, "Containers", "Aliquot a specific volume of the sample(s) in a specified container into a new container:"},
			ExperimentAliquot[Object[Container, Vessel, "Test container 2 for ExperimentAliquot Tests"<>$SessionUUID], 1 Milliliter, ContainerOut -> Model[Container, Vessel, "2mL Tube"]],
			ObjectP[Object[Protocol, RoboticSamplePreparation]]
		],
		Example[{Additional, "Containers", "Dilute the sample(s) in a given container to a new target concentration:"},
			ExperimentAliquot[Object[Container, Vessel, "Test container 3 for ExperimentAliquot Tests"<>$SessionUUID], 50 Micromolar],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			Messages :> {Warning::RoundedTransferAmount}
		],
		Example[{Additional, "Aliquot a specific volume of multiple samples into a new container:"},
			options = ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL)"<>$SessionUUID]}, {200 Microliter, 200 Microliter}, ContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], Output -> Options];
			Lookup[options, ContainerOut],
			{
				{1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
				{1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}
			},
			Variables :> {options}
		],
		Example[{Additional, "Aliquot the same volume from multiple source samples:"},
			options = ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL)"<>$SessionUUID]}, 200 Microliter, Output -> Options];
			Lookup[options, Amount],
			{200 * Microliter, 200 * Microliter},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Additional, "Dilute multiple samples to the same target concentration:"},
			options = ExperimentAliquot[{{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL)"<>$SessionUUID]}}, Amount -> 200 Microliter, Output -> Options];
			Lookup[options, Amount],
			200 * Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Additional, "Pooling", "Indicate if certain samples should go into the same pool by providing them as a nested list:"},
			ExperimentAliquot[{{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL, 3 mL)"<>$SessionUUID]}, {Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mg / mL)"<>$SessionUUID]}}],
			ObjectP[Object[Protocol, RoboticSamplePreparation]],
			Variables :> {options}
		],
		Example[{Additional, "Pooling", "Pool some samples while provide others as singletons:"},
			ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mg / mL)"<>$SessionUUID], {Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL, 3 mL)"<>$SessionUUID]}}],
			ObjectP[Object[Protocol, RoboticSamplePreparation]],
			Variables :> {options}
		],
		Example[{Additional, "Pooling", "If TargetConcentration is set for both samples that are being pooled, and AssayVolume is also specified, resolve the Amount option for each sample if it is possible:"},
			options = ExperimentAliquot[{{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mg / mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL, 3 mg / mL)"<>$SessionUUID]}}, TargetConcentration -> {{2.5 * Milligram / Milliliter, 0.75 * Milligram / Milliliter}}, AssayVolume -> 2.5 * Milliliter, Output -> Options];
			Lookup[options, Amount],
			{{1.25 * Milliliter, 0.625 * Milliliter}},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Additional, "Pooling", "If AssayVolume is specified but TargetConcentration and Amount are left blank for one sample when pooling more than one sample, Amount will likely not be able to be resolved:"},
			ExperimentAliquot[{{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mg / mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL, 3 mg / mL)"<>$SessionUUID]}}, TargetConcentration -> {{1.0 * Milligram / Milliliter, Automatic}}, AssayVolume -> 2.0 * Milliliter],
			$Failed,
			Messages :> {
				Error::NestedIndexMatchingVolumeAboveAssayVolume,
				Error::InvalidOption
			},
			Variables :> {options}
		],
		Example[{Additional, "Pooling", "If pooling multiple samples together, and TargetConcentration and Amount are specified for only one, resolve AssayVolume based on the specified Amount/TargetConcentration, and use the full volume of the non-specified sample:"},
			options = ExperimentAliquot[{{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mg / mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL, 3 mg / mL)"<>$SessionUUID]}}, TargetConcentration -> {{1 * Milligram / Milliliter, Automatic}}, Amount -> {{1 * Milliliter, Automatic}}, Output -> Options];
			Lookup[options, {Amount, AssayVolume, TargetConcentration}],
			{
				{{RangeP[1 * Milliliter, 1 * Milliliter], RangeP[1.8 * Milliliter, 1.8 * Milliliter]}},
				RangeP[5 * Milliliter, 5 * Milliliter],
				{{RangeP[1 * Milligram / Milliliter, 1 * Milligram / Milliliter], Null}}
			},
			Variables :> {options}
		],
		Example[{Additional, "Pooling", "If pooling multiple samples together, and TargetConcentration and Amount are specified for only one, resolve AssayVolume based on the specified Amount/TargetConcentration, and use the full volume of the non-specified sample.  Note that depending on the values specified, this may cause errors if the resolved AssayVolume is too small:"},
			ExperimentAliquot[{{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mg / mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL, 3 mg / mL)"<>$SessionUUID]}}, TargetConcentration -> {{4 * Milligram / Milliliter, Automatic}}, Amount -> {{1 * Milliliter, Automatic}}, ContainerOut -> Model[Container, Vessel, "50mL Tube"]],
			$Failed,
			Messages :> {
				Error::NestedIndexMatchingVolumeAboveAssayVolume,
				Error::InvalidOption
			},
			Variables :> {options}
		],
		Example[{Additional, "Pooling", "If pooling multiple samples where one is solid and one is liquid, the resolved AssayVolume is the sum of the volume components:"},
			options = ExperimentAliquot[{{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mg / mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (100 mg)"<>$SessionUUID]}}, Amount -> {{1 * Milliliter, 10 * Milligram}}, Output -> Options];
			Lookup[options, AssayVolume],
			1 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Test["If pooling multiple samples where one is solid and one is liquid and EnableSamplePreparation -> True, the resolved AssayVolume is the sum of the volume components without throwing errors:",
			options = ExperimentAliquot[{{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mg / mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (100 mg)"<>$SessionUUID]}}, Amount -> {{1 * Milliliter, 10 * Milligram}}, Output -> Options, EnableSamplePreparation -> True];
			Lookup[options, AssayVolume],
			1 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Additional, "Pooling", "If pooling multiple samples where one is a counted sample and one is liquid, the resolved AssayVolume is the sum of the volume components:"},
			options = ExperimentAliquot[{{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mg / mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (3 Tablets)"<>$SessionUUID]}}, Amount -> {{1 * Milliliter, 2}}, Output -> Options];
			Lookup[options, AssayVolume],
			1 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],

		Example[{Additional, "Dilute multiple samples to the same target mass concentration:"},
			options = ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mg / mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL, 3 mg / mL)"<>$SessionUUID]}, 1 * (Milligram / Milliliter), Output -> Options];
			Lookup[options, TargetConcentration],
			{1 * (Milligram / Milliliter), 1 * (Milligram / Milliliter)},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Additional, "Resolve to a valid DestinationWell if the sample has properties that would lead to ContainerOut resolve to a sterile container model:"},
			Lookup[
				ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], Output -> Options],
				DestinationWell
			],
			{WellPositionP},
			SetUp :> (Upload[<|
				Object->Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID],
				Living -> True
			|>]),
			TearDown :> (Upload[<|
				Object->Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID],
				Living -> Null
			|>])
		],

		(* --- Options testing --- *)

		(* ConsolidateAliquots is a hidden option so we can't have an example for it (but obviously need to still do testing) *)
		Test["If the same sample is aliquoted twice with the same volumes, consolidate the aliquots if ConsolidateAliquots -> True:",
			options = ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID]}, 200 Microliter, ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ContainerOut],
			{
				{1, ObjectP[Model[Container, Vessel]]},
				{1, ObjectP[Model[Container, Vessel]]}
			},
			Variables :> {options}
		],

		Test["If the same sample is aliquoted twice with the same volumes, don't consolidate the aliquots if ConsolidateAliquots -> False:",
			options = ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID]}, 200 Microliter, ConsolidateAliquots -> False, Output -> Options];
			Lookup[options, ContainerOut],
			{
				{1, ObjectP[Model[Container, Vessel]]},
				{2, ObjectP[Model[Container, Vessel]]}
			},
			Variables :> {options}
		],

		Test["If the same sample is aliquoted multiple times with the same volumes into a plate, consolidate the aliquots to the same well if ConsolidateAliquots -> True:",
			options = ExperimentAliquot[ConstantArray[Object[Sample, "ExperimentAliquot New Test Chemical 1 (25 mL)"<>$SessionUUID], 30], 200 Microliter, ContainerOut -> Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ContainerOut],
			{
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]},
				{1, ObjectP[Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]]}
			},
			Variables :> {options},
			TimeConstraint -> 500
		],

		Test["If the same sample is aliquoted multiple times with the same volumes into a plate, consolidate the aliquots to the same well if ConsolidateAliquots -> True:",
			(
				primitives = Download[ExperimentAliquot[ConstantArray[Object[Sample, "ExperimentAliquot New Test Chemical 1 (25 mL)"<>$SessionUUID], 30], 200 Microliter, ContainerOut -> Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"], DestinationWell -> "A2", ConsolidateAliquots -> True], OutputUnitOperations[[1]][RoboticUnitOperations]];
				DeleteDuplicates[Download[FirstCase[primitives, ObjectP[Object[UnitOperation, Transfer]]], DestinationLabel]]
			),
			{_String},
			Variables :> {primitives},
			TimeConstraint -> 500
		],

		Test["TargetConcentration can be specified in units of MassConcentration if Composition is populated in Concentration units in the sample:",
			options = ExperimentAliquot[
				Object[Sample, "ExperimentAliquot Test Sample with Conc Composition"<>$SessionUUID],
				TargetConcentration -> 1 Gram / Liter,
				TargetConcentrationAnalyte -> Model[Molecule, "Sodium Chloride"],
				Output -> Options
			];
			Lookup[options, TargetConcentration],
			1 Gram / Liter,
			Variables :> {options},
			EquivalenceFunction -> Equal,
			TimeConstraint -> 300
		],

		Test["TargetConcentration can be specified in units of Concentration if Composition is populated in MassConcentration units in the sample:",
			options = ExperimentAliquot[
				Object[Sample, "ExperimentAliquot Test Sample with Mass Conc Composition"<>$SessionUUID],
				TargetConcentration -> 100 Millimolar,
				TargetConcentrationAnalyte -> Model[Molecule, "Sodium Chloride"],
				Output -> Options
			];
			Lookup[options, TargetConcentration],
			100 Millimolar,
			Variables :> {options},
			EquivalenceFunction -> Equal,
			TimeConstraint -> 300
		],
		Example[{Options, WorkCell, "If aliquotting mammalian samples robotically, perform in the bioSTAR:"},
			protocol = ExperimentAliquot[
				{Model[Sample, "HEK293"]},
				PreparedModelContainer -> Model[Container, Plate, "96-well flat bottom plate, Sterile, Nuclease-Free"],
				PreparedModelAmount -> 0.25 Milliliter,
				Preparation -> Robotic
			];
			resolvedWorkCell = Download[Download[protocol, OutputUnitOperations], WorkCell];
			{
				protocol,
				resolvedWorkCell
			},
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				{bioSTAR}
			},
			Variables :> {protocol, resolvedWorkCell}
		],
		Example[{Options, WorkCell, "If aliquotting bacterial samples robotically, perform in the microbioSTAR:"},
			protocol = ExperimentAliquot[
				{Model[Sample, "E.coli MG1655"]},
				PreparedModelContainer -> Model[Container, Plate, "96-well flat bottom plate, Sterile, Nuclease-Free"],
				PreparedModelAmount -> 0.25 Milliliter,
				Preparation -> Robotic
			];
			resolvedWorkCell = Download[Download[protocol, OutputUnitOperations], WorkCell];
			{
				protocol,
				resolvedWorkCell
			},
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				{microbioSTAR}
			},
			Variables :> {protocol, resolvedWorkCell}
		],
		Example[{Options, WorkCell, "If aliquotting non-living, non-sterile samples robotically, perform in the STAR:"},
			protocol = ExperimentAliquot[
				{Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Plate, "96-well flat bottom plate, Sterile, Nuclease-Free"],
				PreparedModelAmount -> 0.25 Milliliter,
				Preparation -> Robotic
			];
			resolvedWorkCell = Download[Download[protocol, OutputUnitOperations], WorkCell];
			{
				protocol,
				resolvedWorkCell
			},
			{
				ObjectP[Object[Protocol, RoboticSamplePreparation]],
				{STAR}
			},
			Variables :> {protocol, resolvedWorkCell}
		],
		Example[{Options, WorkCell, "If aliquotting sterile samples robotically, perform in the bioSTAR:"},
			protocol = ExperimentAliquot[
				{Model[Sample, "LCMS Grade Water"]},
				PreparedModelContainer -> Model[Container, Plate, "96-well flat bottom plate, Sterile, Nuclease-Free"],
				PreparedModelAmount -> 0.25 Milliliter,
				Preparation -> Robotic
			];
			resolvedWorkCell = Download[Download[protocol, OutputUnitOperations], WorkCell];
			{
				protocol,
				resolvedWorkCell
			},
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				{bioSTAR}
			},
			Variables :> {protocol, resolvedWorkCell}
		],
		Example[{Options, WorkCell, "If Preparation is Manual, WorkCell is Null:"},
			options = ExperimentAliquot[
				{Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Plate, "id:L8kPEjkmLbvW"],
				PreparedModelAmount -> 1 Milliliter,
				Preparation -> Manual,
				Output -> Options
			];
			Lookup[options, WorkCell],
			Null,
			Variables :> {options}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentAliquot[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Plate, "id:L8kPEjkmLbvW"],
				PreparedModelAmount -> 1 Milliliter,
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
				{ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]..},
				{EqualP[1 Milliliter]..},
				{"A1", "B1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared (preparation -> robotic):"},
			options = ExperimentAliquot[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Plate, "id:L8kPEjkmLbvW"],
				PreparedModelAmount -> 1 Milliliter,
				Preparation -> Robotic,
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
				{ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]..},
				{EqualP[1 Milliliter]..},
				{"A1", "B1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "If a model input is specified, make sure the protocol object/unit operations are created properly (robotic):"},
			protocol = ExperimentAliquot[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Plate, "id:L8kPEjkmLbvW"],
				PreparedModelAmount -> 1 Milliliter,
				Preparation -> Robotic
			];
			outputUOs = Download[protocol, OutputUnitOperations[Object]];
			roboticUOs = Download[outputUOs[[1]], RoboticUnitOperations[Object]];
			{
				Download[outputUOs, Source],
				roboticUOs
			},
			{
				{{{ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]]}..}},
				{ObjectP[Object[UnitOperation, LabelSample]], ObjectP[Object[UnitOperation, LabelContainer]], ObjectP[Object[UnitOperation, Transfer]], ObjectP[Object[UnitOperation, Mix]]}
			},
			Variables :> {protocol, outputUOs, roboticUOs}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "If a model input is specified, make sure the protocol object/unit operations are created properly (manual):"},
			protocol = ExperimentAliquot[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Plate, "id:L8kPEjkmLbvW"],
				PreparedModelAmount -> 1 Milliliter,
				Preparation -> Manual
			];
			outputUOs = Download[protocol, OutputUnitOperations[Object]];
			{
				outputUOs,
				Download[outputUOs[[1]], SampleLink]
			},
			{
				{ObjectP[Object[UnitOperation, LabelSample]], ObjectP[Object[UnitOperation, LabelContainer]], ObjectP[Object[UnitOperation, Transfer]]},
				{ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]]..}
			},
			Variables :> {protocol, outputUOs}
		],
		Example[{Options, Confirm, "If Confirm -> True, Skip InCart and go directly to Processing:"},
			Download[ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], Confirm -> True], Status],
			Processing|ShippingMaterials|Backlogged,
			TimeConstraint -> 120
		],
		Example[{Options, CanaryBranch, "Specify the CanaryBranch on which the protocol is run:"},
			Download[ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], CanaryBranch -> "d1cacc5a-948b-4843-aa46-97406bbfc368"], CanaryBranch],
			"d1cacc5a-948b-4843-aa46-97406bbfc368",
			TimeConstraint -> 120,
			Stubs:>{GitBranchExistsQ[___] = True, $PersonID = Object[User, Emerald, Developer, "id:n0k9mGkqa6Gr"]}
		],

		Example[{Options, Name, "Name the protocol for aliquoting sample:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], Name -> "Moving sample somewhere else", Output -> Options];
			Lookup[options, Name],
			"Moving sample somewhere else",
			Variables :> {options}
		],
		Example[{Options, Name, "Name the protocol for aliquoting sample:"},
			Download[ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], Name -> "Moving sample somewhere else"], Name],
			"Moving sample somewhere else",
			Variables :> {options}
		],

		Example[{Options, Template, "Inherit options from a previously run protocol:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], 200 Microliter, Template -> Object[Protocol, RoboticSamplePreparation, "Previous Aliquot SamplePreparation"<>$SessionUUID], Output -> Options];
			Lookup[options, {Template, ContainerOut}],
			{
				ObjectP[Object[Protocol, RoboticSamplePreparation, "Previous Aliquot SamplePreparation"<>$SessionUUID]],
				{{1, ObjectP[Model[Container, Vessel, "15mL Tube"]]}}
			},
			Variables :> {options}
		],
		Example[{Options, Template, "Option values specified in the current experiment will override the same option from a template:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], 200 Microliter, Template -> Object[Protocol, RoboticSamplePreparation, "Previous Aliquot SamplePreparation"<>$SessionUUID], ContainerOut -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, {Template, ContainerOut}],
			{
				ObjectP[Object[Protocol, RoboticSamplePreparation, "Previous Aliquot SamplePreparation"<>$SessionUUID]],
				{{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}}
			},
			Variables :> {options}
		],

		Example[{Options, SamplesInStorageCondition, "Specify the condition in which input samples should be stored upon completion of the aliquoting experiment:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], 200 Microliter, SamplesInStorageCondition -> Freezer, Output -> Options];
			Lookup[options, SamplesInStorageCondition],
			Freezer,
			Variables :> {options}
		],

		Example[{Options, SamplesOutStorageCondition, "Specify the condition in which aliquots should be stored upon completion of the aliquoting experiment:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], 200 Microliter, SamplesOutStorageCondition -> Freezer, Output -> Options];
			Lookup[options, SamplesOutStorageCondition],
			Freezer,
			Variables :> {options}
		],
		Example[{Options, Amount, "Indicate a specific amount of sample to aliquot:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], Amount -> 200 Microliter, Output -> Options];
			Lookup[options, Amount],
			200 * Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, Amount, "Indicate a specific amount of sample to aliquot:"},
			primitives = Download[ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], Amount -> 200 Microliter], OutputUnitOperations[[1]][RoboticUnitOperations]];
			Download[FirstCase[primitives, ObjectP[Object[UnitOperation, Transfer]]], AmountVariableUnit],
			{200 * Microliter},
			EquivalenceFunction -> Equal,
			Variables :> {primitives}
		],
		Example[{Options, Amount, "Aliquot All of a sample using the Amount option:"},
			Download[ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], Amount -> All], OutputUnitOperations[[1]][Amount]],
			{{200 * Microliter}},
			EquivalenceFunction -> Equal,
			Variables :> {primitives}
		],
		Example[{Options, Amount, "If the Amount input AND the Amount options are specified, the input overrides the option:"},
			primitives = Download[ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], 150 * Microliter, Amount -> 200 * Microliter], OutputUnitOperations[[1]][RoboticUnitOperations]];
			Download[FirstCase[primitives, ObjectP[Object[UnitOperation, Transfer]]], AmountVariableUnit],
			{150 * Microliter},
			EquivalenceFunction -> Equal,
			Variables :> {primitives}
		],
		Example[{Options, Amount, "If the Amount input AND the Amount options are specified, the input overrides the option:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], 150 * Microliter, Amount -> 200 * Microliter, Output -> Options];
			Lookup[options, Amount],
			{150 * Microliter},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],

		Example[{Options, Amount, "Aliquot different amounts of different samples:"},
			options = ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL)"<>$SessionUUID]}, Amount -> {150 * Microliter, 200 Microliter}, Output -> Options];
			Lookup[options, Amount],
			{150 * Microliter, 200 Microliter},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, Amount, "If Amount is the same as AssayVolume, resolve AssayBuffer and ConcentratedBuffer to both Null:"},
			options = ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL)"<>$SessionUUID]}, Amount -> {150 * Microliter, 200 Microliter}, Output -> Options];
			Lookup[options, {AssayBuffer, ConcentratedBuffer}],
			{Null, Null},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, Amount, "If ContainerOut is specified but Amount is not, resolve to the container's MaxVolume and NOT the total volume of the sample:"},
			primitives = Download[ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (10 mL)"<>$SessionUUID], ContainerOut -> Model[Container, Vessel, "2mL Tube"]], OutputUnitOperations[[1]][RoboticUnitOperations]];
			Download[FirstCase[primitives, ObjectP[Object[UnitOperation, Transfer]]], AmountVariableUnit],
			{950 Microliter, 950 Microliter},
			EquivalenceFunction -> Equal,
			Variables :> {primitives}
		],
		Test["When All is passed as the Amount option, actual volume is stored in unit operation if robotic:",
			primitives = Download[ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], Amount -> All], OutputUnitOperations[[1]][RoboticUnitOperations]];
			Download[FirstCase[primitives, ObjectP[Object[UnitOperation, Transfer]]], AmountVariableUnit],
			{200 Microliter},
			EquivalenceFunction -> Equal,
			Variables :> {primitives}
		],
		Test["Do not set the resolved Amount option to All if the requested Amount is less than the current sample volume, or current sample volume is unknown:",
			primitives = Download[ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (no volume)"<>$SessionUUID]}, Amount -> 100 * Microliter, FastTrack -> True], OutputUnitOperations[[1]][RoboticUnitOperations]];
			Download[FirstCase[primitives, ObjectP[Object[UnitOperation, Transfer]]], AmountVariableUnit],
			{100 * Microliter, 100 * Microliter},
			EquivalenceFunction -> Equal,
			Messages :> {Warning::UnknownAmount},
			Variables :> {primitives}
		],
		Example[{Options, Amount, "Aliquot a mass of a sample. If aliquoting a solid and liquid, can set Amount to a volume and a mass:"},
			primitives = Download[ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (10 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (100 mg)"<>$SessionUUID]}, Amount -> {0.5 * Milliliter, 55 * Milligram}], OutputUnitOperations];
			Download[FirstCase[primitives, ObjectP[Object[UnitOperation, Transfer]]], AmountVariableUnit],
			{0.5 * Milliliter, 55 * Milligram},
			EquivalenceFunction -> Equal,
			Variables :> {primitives}
		],
		Example[{Options, Amount, "Aliquot the mass of a sample and dissolve it in a liquid if AssayVolume is specified:"},
			primitives = Download[ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (100 mg)"<>$SessionUUID], Amount -> 55 * Milligram, AssayVolume -> 1 * Milliliter], OutputUnitOperations];
			Download[FirstCase[primitives, ObjectP[Object[UnitOperation, Transfer]]], AmountVariableUnit],
			{1 * Milliliter, 55 * Milligram},
			EquivalenceFunction -> Equal,
			Variables :> {primitives},
			TimeConstraint -> 500
		],
		Test["If transferring solids then consolidate aliquots correctly if ConsolidateAliquots -> True:",
			primitives = Download[ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (100 mg)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (100 mg)"<>$SessionUUID]}, ConsolidateAliquots -> True], OutputUnitOperations];
			Download[FirstCase[primitives, ObjectP[Object[UnitOperation, Transfer]]], AmountVariableUnit],
			{100 * Milligram},
			EquivalenceFunction -> Equal,
			Variables :> {primitives},
			TimeConstraint -> 500
		],
		Example[{Options, AssayVolume, "Provide a total volume to be aliquoted to the new container; if no buffer options or target concentrations are supplied, this option is equivalent to the Amount input:"},
			primitives = Download[ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], AssayVolume -> 200 * Microliter], OutputUnitOperations[[1]][RoboticUnitOperations]];
			Download[FirstCase[primitives, ObjectP[Object[UnitOperation, Transfer]]], AmountVariableUnit],
			{200 * Microliter},
			EquivalenceFunction -> Equal,
			Variables :> {primitives}
		],
		Test["If given a constant AssayVolume for multiple samples, make sure the AssayVolumes field is index matched properly::",
			primitives = Download[ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (100 mg)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID]}, AssayVolume -> 200 * Microliter], OutputUnitOperations];
			Download[FirstCase[primitives, ObjectP[Object[UnitOperation, Transfer]]], AmountVariableUnit],
			{200 * Microliter, 100 Milligram, 200 * Microliter},
			EquivalenceFunction -> Equal,
			Variables :> {primitives},
			TimeConstraint -> 500
		],
		Example[{Options, AssayVolume, "Provide a total volume to be aliquoted to the new container; if no buffer options or target concentrations are supplied, this option is equivalent to the Amount input:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], AssayVolume -> 200 * Microliter, Output -> Options];
			Lookup[options, {Amount, AssayVolume}],
			{
				200 * Microliter,
				200 * Microliter
			},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "Use AssayVolume in conjunction with the Amount option to indicate that the sample aliquot should be combined with a separate buffer until the assay volume is reached:"},
			primitives = Download[ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], Amount -> 100 * Microliter, AssayVolume -> 200 * Microliter], OutputUnitOperations[[1]][RoboticUnitOperations]];
			Download[FirstCase[primitives, ObjectP[Object[UnitOperation, Transfer]]], {SourceLabel, AmountVariableUnit}],
			{
				{_?(StringMatchQ[#, "aliquot sample" ~~ ___] &), _?(StringMatchQ[#, "aliquot sample" ~~ ___] &)},
				{EqualP[100 Microliter], EqualP[100 Microliter]}
			},
			Variables :> {primitives}
		],
		Example[{Options, AssayVolume, "Use AssayVolume in conjunction with the Amount option to indicate that the sample aliquot should be combined with a separate buffer until the assay volume is reached:"},
			options = ExperimentAliquot[
				{
					Object[Sample, "ExperimentAliquot New Test Chemical 1 (100 mg)"<>$SessionUUID],
					Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID],
					Object[Sample, "ExperimentAliquot New Test Chemical 1 (3 Tablets)"<>$SessionUUID],
					Object[Sample, "ExperimentAliquot New Test Chemical 1 (3 Tablets)"<>$SessionUUID]
				},
				Amount -> {50 * Milligram, 100 * Microliter, 2 * Unit, 1},
				AssayVolume -> 200 * Microliter,
				Output -> Options
			];
			Lookup[options, {Amount, AssayVolume, AssayBuffer}],
			{
				{EqualP[50 * Milligram], EqualP[100 * Microliter], EqualP[2], EqualP[1]},
				EqualP[200 * Microliter],
				ObjectP[Model[Sample, "Milli-Q water"]]
			},
			Variables :> {options},
			TimeConstraint -> 500
		],
		Example[{Options, ContainerOut, "If specified as a singleton plate, ContainerOut resolves to a paired list with each sample in the same instance of that plate (as long as there is enough space:"},
			options = ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL)"<>$SessionUUID]}, {200 Microliter, 200 Microliter}, ContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], Output -> Options];
			Lookup[options, ContainerOut],
			{
				{1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
				{1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}
			},
			Variables :> {options}
		],
		Example[{Options, ContainerOut, "If specified as a singleton plate, ContainerOut resolves to a paired list with each sample in the same instance of that plate (as long as there is enough space):"},
			primitives = Download[ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL)"<>$SessionUUID]}, {200 Microliter, 200 Microliter}, ContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]], OutputUnitOperations[[1]][RoboticUnitOperations]];
			Download[Cases[primitives, ObjectP[Object[UnitOperation, LabelContainer]]], ContainerLink],
			{{
				ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]
			}},
			Variables :> {primitives}
		],
		Example[{Options, ContainerOut, "If specified as a singleton plate, ContainerOut resolves to a paired list with each sample in the same instance of that plate (as long as there is enough space):"},
			requiredObjects = Download[ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL)"<>$SessionUUID]}, {200 Microliter, 200 Microliter}, ContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]], LabeledObjects];
			Cases[requiredObjects, LinkP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]], Infinity],
			{ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
			Variables :> {requiredObjects}
		],
		Example[{Options, ContainerOut, "If not specified, ContainerOut resolves to the PreferredVessel for the amount being transferred, with each sample in a different container:"},
			options = ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (5 mL)"<>$SessionUUID]}, {600 Microliter, 3 Milliliter}, Output -> Options];
			Lookup[options, ContainerOut],
			{
				{1, ObjectP[Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"]]},
				{2, ObjectP[Model[Container, Vessel, "50mL Tube"]]}
			},
			Variables :> {options}
		],
		Example[{Options, ContainerOut, "If not specified, ContainerOut resolves to the PreferredVessel for the amount being transferred, with each sample in a different container:"},
			requiredObjects = Download[ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (5 mL)"<>$SessionUUID]}, {600 Microliter, 3 Milliliter}], LabeledObjects];
			Cases[requiredObjects, LinkP[{Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"], Model[Container, Vessel, "50mL Tube"]}], Infinity],
			{ObjectP[Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"]], ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {requiredObjects}
		],
		Example[{Options, ContainerOut, "If specified as a singleton non-plate container, ContainerOut resolves to a paired list with each sample in a different instance of that container:"},
			options = ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL)"<>$SessionUUID]}, {200 Microliter, 200 Microliter}, ContainerOut -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, ContainerOut],
			{
				{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
				{2, ObjectP[Model[Container, Vessel, "2mL Tube"]]}
			},
			Variables :> {options}
		],
		Example[{Options, ContainerOut, "If specified as a singleton non-plate container, ContainerOut resolves to a paired list with each sample in a different instance of that container (and this manifests itself as two separate containers in LabeledObjects):"},
			requiredObjects = Download[ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL)"<>$SessionUUID]}, {200 Microliter, 200 Microliter}, ContainerOut -> Model[Container, Vessel, "2mL Tube"]], LabeledObjects];
			Cases[requiredObjects, LinkP[Model[Container, Vessel, "2mL Tube"]], Infinity],
			{ObjectP[Model[Container, Vessel, "2mL Tube"]], ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {requiredObjects}
		],
		Example[{Options, ContainerOut, "If specified as a paired list with the indices still as Automatic, indices resolve to different integers if aliquoting into a vessel:"},
			options = ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL)"<>$SessionUUID]}, {200 Microliter, 200 Microliter}, ContainerOut -> {{Automatic, Model[Container, Vessel, "2mL Tube"]}, {Automatic, Model[Container, Vessel, "2mL Tube"]}}, Output -> Options];
			Lookup[options, ContainerOut],
			{
				{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
				{2, ObjectP[Model[Container, Vessel, "2mL Tube"]]}
			},
			Variables :> {options}
		],
		Example[{Options, ContainerOut, "If specified as a paired list with one index still as Automatic, indices resolve to different integers:"},
			options = ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL)"<>$SessionUUID]}, {200 Microliter, 200 Microliter}, ContainerOut -> {{Automatic, Model[Container, Vessel, "2mL Tube"]}, {1, Model[Container, Vessel, "2mL Tube"]}}, Output -> Options];
			Lookup[options, ContainerOut],
			{
				{2, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
				{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}
			},
			Variables :> {options}
		],
		Example[{Options, ContainerOut, "If aliquoting from the same sample and ConsolidateAliquots -> True, both indices resolve to the same container:"},
			options = ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID]}, {200 Microliter, 200 Microliter}, ContainerOut -> {{Automatic, Model[Container, Vessel, "2mL Tube"]}, {Automatic, Model[Container, Vessel, "2mL Tube"]}}, ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ContainerOut],
			{
				{1, ObjectP[Model[Container, Vessel]]},
				{1, ObjectP[Model[Container, Vessel]]}
			},
			Variables :> {options}
		],
		Example[{Options, ContainerOut, "If aliquoting from the same sample and ConsolidateAliquots -> True, both indices resolve to a bigger container if their combined volumes requires a bigger container than each individual one:"},
			options = ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (3 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (3 mL)"<>$SessionUUID]}, {1.1 * Milliliter, 1.1 * Milliliter}, ContainerOut -> {{Automatic, Automatic}, {Automatic, Automatic}}, ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ContainerOut],
			{
				{1, ObjectP[Model[Container, Vessel]]},
				{1, ObjectP[Model[Container, Vessel]]}
			},
			Variables :> {options}
		],
		Example[{Options, ContainerOut, "If aliquoting from the same sample into the same container model, but the index is specified for one but not the other, do not consolidate them:"},
			options = ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (3 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (3 mL)"<>$SessionUUID]}, {1.1 * Milliliter, 1.1 * Milliliter}, ContainerOut -> {{1, Model[Container, Vessel, "50mL Tube"]}, {Automatic, Model[Container, Vessel, "50mL Tube"]}}, ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ContainerOut],
			{
				{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
				{2, ObjectP[Model[Container, Vessel, "50mL Tube"]]}
			},
			Variables :> {options}
		],
		Example[{Options, ContainerOut, "If aliquoting from the same sample into an Automatic container model with index explicitly set to be the same and ConsolidateAliquots -> True, resolve the Automatic container model to be one that can hold both:"},
			options = ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (3 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (3 mL)"<>$SessionUUID]}, {1.1 * Milliliter, 1.1 * Milliliter}, ContainerOut -> {{1, Automatic}, {1, Automatic}}, ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ContainerOut],
			{
				{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
				{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]}
			},
			Variables :> {options}
		],
		Example[{Options, ContainerOut, "If aliquoting from the same sample into an Automatic container model with index explicitly set to be the same and ConsolidateAliquots -> False, throw an error:"},
			options = ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (3 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (3 mL)"<>$SessionUUID]}, {0.8 * Milliliter, 0.6 * Milliliter}, ContainerOut -> {{1, Automatic}, {1, Automatic}}, ConsolidateAliquots -> False, Output -> Options];
			Lookup[options, ContainerOut],
			{
				{1, ObjectP[Model[Container, Vessel]]},
				{1, ObjectP[Model[Container, Vessel]]}
			},
			Messages :> {
				Error::ContainerOverOccupied,
				Error::InvalidOption
			},
			Variables :> {options}
		],
		Example[{Options, DestinationWell, "Use the DestinationWell option to specify the positions of the aliquot samples in the ContainerOut containers:"},
			Lookup[
				ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL)"<>$SessionUUID]}, {200 Microliter, 200 Microliter}, DestinationWell -> {"B3", "H7"}, ContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], Output -> Options],
				DestinationWell
			],
			{"B3", "H7"}
		],
		Example[{Options, DestinationWell, "If left unspecified, resolves to the open positions of the specified container in order from A1 to H12:"},
			Lookup[
				ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL)"<>$SessionUUID]}, {200 Microliter, 200 Microliter}, ContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], Output -> Options],
				DestinationWell
			],
			{"A1", "A2"}
		],
		Example[{Options, TargetConcentration, "Prepare a diluted aliquot of a source sample by indicating the desired final concentration:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], TargetConcentration -> 50 Micromolar, Output -> Options];
			Lookup[options, TargetConcentration],
			50 Micromolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "Mass concentrations are also supported:"},
			options = ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mg / mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL, 3 mg / mL)"<>$SessionUUID]}, TargetConcentration -> {1 * (Milligram / Milliliter), 1 * (Milligram / Milliliter)}, Output -> Options];
			Lookup[options, TargetConcentration],
			{1 * (Milligram / Milliliter), 1 * (Milligram / Milliliter)},
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 500
		],
		Example[{Options, TargetConcentration, "If the TargetConcentration input and option are both specified, the input overrides the option:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], 40 Micromolar, TargetConcentration -> 50 Micromolar, Output -> Options];
			Lookup[options, TargetConcentration],
			{40 Micromolar},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "If TargetConcentration is set for a solid and MolecularWeight is populated for this model, calculate the volumes properly:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (100 mg)"<>$SessionUUID], TargetConcentration -> 1 * Molar, Output -> Options];
			Lookup[options, {AssayVolume, TargetConcentration}],
			{UnitsP[Microliter], UnitsP[Molar]},
			Variables :> {options},
			TimeConstraint -> 1000
		],
		Example[{Options, TargetConcentration, "If TargetConcentration is set for a solid and MolecularWeight is not populated populated for this model but a mass concentration was provided, calculate the volumes properly:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Resin 1 (100 mg)"<>$SessionUUID], TargetConcentration -> 1 * Milligram / Milliliter, Output -> Options];
			Lookup[options, {AssayVolume, TargetConcentration}],
			{UnitsP[Microliter], UnitsP[Milligram / Milliliter]},
			Variables :> {options},
			TimeConstraint -> 500
		],
		Example[{Options, TargetConcentrationAnalyte, "Specify which component of sample to set to the specified target concentration:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], TargetConcentration -> 1 * Millimolar, TargetConcentrationAnalyte -> Model[Molecule, "Methylamine"], Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			{ObjectP[Model[Molecule, "Methylamine"]]},
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "If TargetConcentrationAnalyte is not specified but TargetConcentration is, automatically set to the first component of the Analytes field, or, if not populated, the first non-water component of the Composition field:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], TargetConcentration -> 1 * Millimolar, Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, "Methylamine"]],
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "If TargetConcentrationAnalyte is specified but TargetConcentration is not, an error is thrown:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], TargetConcentrationAnalyte -> Model[Molecule, "Methylamine"]],
			$Failed,
			Messages :> {Error::NoConcentration, Error::InvalidOption}
		],
		Example[{Options, AssayBuffer, "Specify the buffer that will be added to any sample aliquots to reach the full AssayVolume:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], 1 Millimolar, AssayVolume -> 200 Microliter, AssayBuffer -> Model[Sample, StockSolution, "70% Ethanol"], Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectReferenceP[Model[Sample, StockSolution, "70% Ethanol"]],
			Variables :> {options}
		],
		(* NOTE: The order of these samples may be different due to primitive optimization. *)
		Example[{Options, AssayBuffer, "Specify the buffer that will be added to any sample aliquots to reach the full AssayVolume:"},
			primitives = Download[ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], 1 Millimolar, AssayVolume -> 200 Microliter, AssayBuffer -> Model[Sample, StockSolution, "70% Ethanol"]], OutputUnitOperations[[1]][RoboticUnitOperations]];
			Download[Cases[primitives, ObjectP[Object[UnitOperation, LabelSample]]], SampleLink],
			{OrderlessPatternSequence[{ObjectP[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID]]}, {ObjectP[Model[Sample, StockSolution, "70% Ethanol"]]}]},
			Variables :> {primitives}
		],
		Example[{Options, AssayBuffer, "If ConcentratedBuffer is not specified, AssayBuffer resolves to water:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], 1 Millimolar, AssayVolume -> 200 Microliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "If ConcentratedBuffer is specified, AssayBuffer resolves to Null:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], 1 Millimolar, AssayVolume -> 200 Microliter, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], Output -> Options];
			Lookup[options, AssayBuffer],
			Null,
			Variables :> {options}
		],

		Example[{Options, ConcentratedBuffer, "Specify a concentrated buffer that will be first diluted down to a working concentration, and then added to any sample aliquots to reach the full AssayVolume:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], 1 Millimolar, AssayVolume -> 200 Microliter, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectReferenceP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],

		Example[{Options, ConcentratedBuffer, "Ensure that if diluting the concentrated buffer and then using that to dilute any aliquots, the proper manipulations are created:"},
			primitives = Download[ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], 1 Millimolar, AssayVolume -> 200 Microliter, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"]], OutputUnitOperations[[1]][RoboticUnitOperations]];
			Download[FirstCase[primitives, ObjectP[Object[UnitOperation, Transfer]]], SourceLabel],
			{
				_?(StringMatchQ[#, "aliquot sample" ~~ ___] &),
				_?(StringMatchQ[#, "aliquot sample" ~~ ___] &),
				_?(StringMatchQ[#, "aliquot sample" ~~ ___] &)
			}
		],
		Test["If Preparation -> Manual, don't add an Incubate primitive because we are just dispense mixing in the Transfer:",
			primitives = Download[ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], 1 Millimolar, AssayVolume -> 200 Microliter, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], Preparation -> Manual], OutputUnitOperations];
			Not[MemberQ[primitives, ObjectP[{Object[UnitOperation, Mix], Object[UnitOperation, Incubate]}]]],
			True,
			Variables :> {primitives},
			TimeConstraint -> 500
		],
		Test["If the ConcentratedBuffer option is specified but the sample isn't actually getting diluted, then an error is thrown:",
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], AssayVolume -> 200 Microliter, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"]],
			$Failed,
			Messages :> {
				Warning::BufferWillNotBeUsed,
				Error::BufferDilutionFactorTooLow,
				Error::InvalidOption
			}
		],

		Example[{Options, BufferDilutionFactor, "Specify the factor by which a concentrated buffer should be pre-diluted before addition to sample aliquots to reach the full AssayVolume:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], 1 Millimolar, AssayVolume -> 200 Microliter, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], BufferDilutionFactor -> 5, Output -> Options];
			Lookup[options, BufferDilutionFactor],
			5,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],

		Example[{Options, BufferDilutionFactor, "If AssayBuffer is specified, BufferDilutionFactor resolves to Null:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], 1 Millimolar, AssayVolume -> 200 Microliter, AssayBuffer -> Model[Sample, "Milli-Q water"], Output -> Options];
			Lookup[options, BufferDilutionFactor],
			Null,
			Variables :> {options}
		],

		Example[{Options, BufferDilutionFactor, "If ConcentratedBuffer is specified, BufferDilutionFactor resolves to the ConcentratedBufferDilutionFactor:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], 1 Millimolar, AssayVolume -> 200 Microliter, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],

		Example[{Options, BufferDiluent, "Specify the diluent with which a concentrated buffer should be pre-diluted before addition to sample aliquots to reach the full AssayVolume:"},
			primitives = Download[ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], 1 Millimolar, AssayVolume -> 200 Microliter, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDiluentLabel -> "Buffer Diluent 1"], OutputUnitOperations[[1]][RoboticUnitOperations]];
			primitiveLabelPackets = Download[Cases[primitives, ObjectP[Object[UnitOperation, LabelSample]]], Packet[SampleLink, Label]];
			FirstOrDefault[PickList[Flatten[Lookup[primitiveLabelPackets, SampleLink]], Flatten[Lookup[primitiveLabelPackets, Label]], _?(StringMatchQ[#, "Buffer Diluent 1" ~~ ___]&)]],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {primitives, primitiveLabelPackets}
		],

		Example[{Options, BufferDiluent, "Specify the diluent with which a concentrated buffer should be pre-diluted before addition to sample aliquots to reach the full AssayVolume:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], 1 Millimolar, AssayVolume -> 200 Microliter, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], BufferDiluent -> Model[Sample, "Milli-Q water"], Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],

		Example[{Options, BufferDiluent, "If ConcentratedBuffer is specified, BufferDiluent resolves to water:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], 1 Millimolar, AssayVolume -> 200 Microliter, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],

		Example[{Options, BufferDiluent, "If AssayBuffer is specified, BufferDiluent resolves to Null:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], 1 Millimolar, AssayVolume -> 200 Microliter, AssayBuffer -> Model[Sample, "Milli-Q water"], Output -> Options];
			Lookup[options, BufferDiluent],
			Null,
			Variables :> {options}
		],

		Example[{Options, Preparation, "Set whether to use the liquid handlers or manual pipettes to perform this aliquot:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], Preparation -> Manual],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			Variables :> {options}
		],

		Example[{Options, Preparation, "Set whether to use the liquid handlers or manual pipettes to perform this aliquot:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], Preparation -> Manual, Output -> Options];
			Lookup[options, Preparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, Preparation, "If Preparation -> Automatic, resolves to Robotic (unless one of the containers is not compatible with the liquid handler):"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], Output -> Options];
			Lookup[options, Preparation],
			Robotic,
			Variables :> {options}
		],
		Example[{Options, Preparation, "If Preparation -> Automatic, resolves to Manual if the ContainerOut or sample containers are not compatible with the liquid handler:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], ContainerOut -> Model[Container, Vessel, "15mL Tube"], Output -> Options];
			Lookup[options, Preparation],
			Manual,
			Variables :> {options}
		],

		Example[{Options, ImageSample, "If ImageSample -> False, do not image the samples after the protocol is completed:"},
			prot = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], ImageSample -> False];
			Download[prot, ImageSample],
			False | Null,
			Variables :> {prot}
		],
		Example[{Options, MeasureVolume, "If MeasureVolume -> False, do not measure the volume of the samples after the protocol is completed:"},
			prot = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], MeasureVolume -> False];
			Download[prot, MeasureVolume],
			False | Null,
			Variables :> {prot}
		],
		Example[{Options, MeasureWeight, "If MeasureWeight -> False, do not measure the weight of the samples after the protocol is completed:"},
			prot = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], MeasureWeight -> False];
			Download[prot, MeasureWeight],
			False | Null,
			Variables :> {prot}
		],
		Example[{Options, MeasureWeight, "If sample has Living -> True, do not do post processing imaging and measurements:"},
			Lookup[
				ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], Output -> Options],
				{ImageSample, MeasureVolume, MeasureWeight}
			],
			{False, False, False},
			SetUp :> (Upload[<|
				Object->Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID],
				Living -> True
			|>]),
			TearDown :> (Upload[<|
				Object->Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID],
				Living -> Null
			|>])
		],
		Example[{Options, SourceLabel, "Specify the label given to the input sample:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], 1 Millimolar, SourceLabel -> "Sample 1", Output -> Options, Preparation -> Robotic];
			Lookup[options, SourceLabel],
			"Sample 1",
			Variables :> {options}
		],
		Example[{Options, SourceLabel, "If not specified but in a work cell resolution, automatically set to some string:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], 1 Millimolar, Output -> Options, Preparation -> Robotic];
			Lookup[options, {SourceLabel, SourceContainerLabel}],
			{_String, _String},
			Variables :> {options}
		],
		Example[{Options, SourceContainerLabel, "Specify the container label given to the input sample:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], 1 Millimolar, SourceContainerLabel -> "Container 1", Output -> Options, Preparation -> Robotic];
			Lookup[options, SourceContainerLabel],
			"Container 1",
			Variables :> {options}
		],
		Example[{Options, SampleOutLabel, "Specify the sample label given to the sample out.  If not specified, set to a string:"},
			options = ExperimentAliquot[
				{
					Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID],
					Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID]
				},
				SampleOutLabel -> {
					"SampleOut 1",
					Automatic
				},
				Output -> Options,
				Preparation -> Robotic
			];
			Lookup[options, SampleOutLabel],
			{"SampleOut 1", _String},
			Variables :> {options}
		],
		Example[{Options, ContainerOutLabel, "Specify the container label given to the container out.  If not specified, set to a string:"},
			options = ExperimentAliquot[
				{
					Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID],
					Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID]
				},
				ContainerOutLabel -> {
					"ContainerOut 1",
					Automatic
				},
				Output -> Options,
				Preparation -> Robotic
			];
			Lookup[options, ContainerOutLabel],
			{"ContainerOut 1", _String},
			Variables :> {options}
		],
		Example[{Options, AssayBufferLabel, "Specify the label given to the AssayBuffer:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], 1 Millimolar, AssayBuffer -> Model[Sample, "Milli-Q water"], AssayBufferLabel -> "Assay buffer 1", Output -> Options, Preparation -> Robotic];
			Lookup[options, AssayBufferLabel],
			"Assay buffer 1",
			Variables :> {options}
		],
		Example[{Options, AssayBufferLabel, "If not specified, set AssayBufferLabel to some string if using AssayBuffer, or Null if not:"},
			options = ExperimentAliquot[
				{
					Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID],
					Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID]
				},
				Amount -> {
					100 Microliter,
					Automatic
				},
				AssayVolume -> {
					1 Milliliter,
					Automatic
				},
				TargetConcentration -> {
					Null,
					1 Millimolar
				},
				AssayBuffer -> {
					Model[Sample, "Milli-Q water"],
					Null
				},
				ConcentratedBuffer -> {
					Null,
					Model[Sample, StockSolution, "10x UV buffer"]
				},
				Output -> Options,
				Preparation -> Robotic
			];
			Lookup[options, AssayBufferLabel],
			{_String, Null},
			Variables :> {options}
		],
		Example[{Options, BufferDiluentLabel, "Specify the label given to the BufferDiluent and ConcentratedBuffer:"},
			options = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], 1 Millimolar, BufferDiluent -> Model[Sample, "Milli-Q water"], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], BufferDiluentLabel -> "Buffer Diluent 1", ConcentratedBufferLabel -> "Concentrated Buffer 1", Output -> Options, Preparation -> Robotic];
			Lookup[options, {BufferDiluentLabel, ConcentratedBufferLabel}],
			{"Buffer Diluent 1", "Concentrated Buffer 1"},
			Variables :> {options}
		],
		Example[{Options, ConcentratedBufferLabel, "If not specified, automatically set ConcentratedBufferLabel and BufferDiluentLabel to some string label if using those options, or Null otherwise:"},
			options = ExperimentAliquot[
				{
					Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID],
					Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID]
				},
				Amount -> {
					100 Microliter,
					Automatic
				},
				AssayVolume -> {
					1 Milliliter,
					Automatic
				},
				TargetConcentration -> {
					Null,
					1 Millimolar
				},
				BufferDiluent -> {
					Null,
					Model[Sample, "Milli-Q water"]
				},
				ConcentratedBuffer -> {
					Null,
					Model[Sample, StockSolution, "10x UV buffer"]
				},
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
		Example[{Options, OptionsResolverOnly, "If OptionsResolverOnly -> True and Output -> Options, skip the resource packets and simulation functions:"},
			ExperimentAliquot[
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID],
				1 Milliliter,
				Output -> Options,
				OptionsResolverOnly -> True
			],
			{__Rule},
			(* stubbing to be False so that we return $Failed if we get here; the point of the option though is that we don't get here *)
			Stubs :> {Resources`Private`fulfillableResourceQ[___]:=(Message[Error::ShouldntGetHere];False)}
		],
		Example[{Options, OptionsResolverOnly, "If OptionsResolverOnly -> True and Output -> Result, ignore OptionsResolverOnly and you have to keep going:"},
			ExperimentAliquot[
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID],
				1 Milliliter,
				Output -> Result,
				OptionsResolverOnly -> True
			],
			$Failed,
			(* stubbing to be False so that we return $Failed; in this case, it should actually get to this point *)
			Stubs :> {Resources`Private`fulfillableResourceQ[___]:=False}
		],

		(* --- Messages --- *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentAliquot[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentAliquot[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentAliquot[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentAliquot[Object[Container, Vessel, "id:12345678"]],
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

				ExperimentAliquot[sampleID, Simulation -> simulationToPassIn, Output -> Options]
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

				ExperimentAliquot[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist for the Amount overload (name form):"},
			ExperimentAliquot[Object[Sample, "Nonexistent sample"], 1 Milliliter],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist for the Amount overload (name form):"},
			ExperimentAliquot[Object[Container, Vessel, "Nonexistent container"], 1 Milliliter],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist for the Amount overload (ID form):"},
			ExperimentAliquot[Object[Sample, "id:12345678"], 1 Milliliter],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist for the Amount overload (ID form):"},
			ExperimentAliquot[Object[Container, Vessel, "id:12345678"], 1 Milliliter],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample for the Amount overload but a simulation is specified that indicates that it is simulated:"},
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

				ExperimentAliquot[sampleID, 1 Milliliter, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container for the Amount overload but a simulation is specified that indicates that it is simulated:"},
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

				ExperimentAliquot[containerID, 1 Milliliter, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist for the Concentration overload (name form):"},
			ExperimentAliquot[Object[Sample, "Nonexistent sample"], 10 Micromolar],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist for the Concentration overload (name form):"},
			ExperimentAliquot[Object[Container, Vessel, "Nonexistent container"], 10 Micromolar],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist for the Concentration overload (ID form):"},
			ExperimentAliquot[Object[Sample, "id:12345678"], 10 Micromolar],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist for the Concentration overload (ID form):"},
			ExperimentAliquot[Object[Container, Vessel, "id:12345678"], 10 Micromolar],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample for the Concentration overload but a simulation is specified that indicates that it is simulated:"},
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
					{
						{100 Micromolar, Model[Molecule, "Sodium Chloride"]},
						{100 VolumePercent, Model[Molecule, "Water"]}
					},
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentAliquot[sampleID, 10 Micromolar, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container for the Concentration overload but a simulation is specified that indicates that it is simulated:"},
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
					{
						{100 Micromolar, Model[Molecule, "Sodium Chloride"]},
						{100 VolumePercent, Model[Molecule, "Water"]}
					},
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentAliquot[containerID, 10 Micromolar, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "InputContainsTemporalLinks", "Throw a message if given a temporal link:"},
			ExperimentAliquot[Link[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], Now - 1 Minute]],
			ObjectP[Object[Protocol, RoboticSamplePreparation]],
			Messages :> {Warning::InputContainsTemporalLinks}
		],
		Example[{Messages, "DiscardedSamples", "Discarded objects are not supported as inputs or options:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (Discarded)"<>$SessionUUID]],
			$Failed,
			Messages :> {
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "DeprecatedModels", "Deprecated models are not supported for any option value:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], 200 Microliter, ContainerOut -> Model[Container, Vessel, "1KG tall small shoulder white plasticv rectangular solid bottle, Deprecated"]],
			$Failed,
			Messages :> {
				Error::DeprecatedModels,
				Error::InvalidInput
			}
		],
		Example[{Messages, "UnknownAmount", "If a sample is to be aliquoted, a volume has been specified, but its current volume is not populated, throw a warning and an error:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (no volume)"<>$SessionUUID], 200 * Microliter],
			ObjectP[Object[Protocol, RoboticSamplePreparation]],
			Messages :> {
				Warning::UnknownAmount
			}
		],

		Example[{Messages, "OverspecifiedBuffer", "Both AssayBuffer and ConcentratedBuffer cannot be simultaneously requested:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], Amount -> 50 Microliter, AssayVolume -> 100 Microliter, AssayBuffer -> Model[Sample, StockSolution, "70% Ethanol"], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"]],
			$Failed,
			Messages :> {
				Error::OverspecifiedBuffer,
				Error::InvalidOption
			}
		],
		Example[{Messages, "OverspecifiedBuffer", "Both AssayBuffer and ConcentratedBuffer can be Null as long as Amount and AssayVolume are equal:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], AssayVolume -> 100 Microliter, Amount -> 100 Microliter, AssayBuffer -> Null, ConcentratedBuffer -> Null],
			ObjectP[Object[Protocol, RoboticSamplePreparation]]
		],
		Example[{Messages, "BufferWillNotBeUsed", "Throw a warning if AssayBuffer and/or ConcentratedBuffer are specified and Amount and AssayVolume are the same:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], AssayVolume -> 100 Microliter, Amount -> 100 Microliter, AssayBuffer -> Model[Sample, "Milli-Q water"]],
			ObjectP[Object[Protocol, RoboticSamplePreparation]],
			Messages :> {
				Warning::BufferWillNotBeUsed
			}
		],
		Example[{Messages, "BufferDilutionMismatched", "If BufferDilutionFactor and/or BufferDiluent are specified, ConcentratedBuffer must also be specified:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"]],
			$Failed,
			Messages :> {
				Error::BufferDilutionMismatched,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NonEmptyContainers", "Specifically provided non-plate containers must be empty to serve as aliquoting destinations:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], 500 Microliter, ContainerOut -> Object[Container, Vessel, "Test container 2 for ExperimentAliquot Tests"<>$SessionUUID]],
			$Failed,
			Messages :> {
				Error::NonEmptyContainers,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NonEmptyContainers", "Specifically provided containers are allowed to be partially occupied for plates:"},
			options = ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID]}, {500 Microliter, 500 Microliter}, ContainerOut -> Object[Container, Plate, "Test full plate 3 for ExperimentAliquot Tests"<>$SessionUUID], Output -> Options];
			Lookup[options, DestinationWell],
			{"B2", "B3"},
			Variables :> {options}
		],

		Example[{Messages, "ConcentrationRatioMismatch", "If TargetConcentration, AssayVolume, and Amount are specified, the ratios of target concentration and current concentration must match the ratio of volume to assay volume:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], TargetConcentration -> 1 * Millimolar, Amount -> 100 * Microliter, AssayVolume -> 200 * Microliter],
			$Failed,
			Messages :> {
				Error::ConcentrationRatioMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NoConcentration", "TargetConcentration cannot be used if current sample concentration is unknown:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], 100 Micromolar, AssayVolume -> 100 Microliter],
			$Failed,
			Messages :> {
				Error::NoConcentration,
				Error::InvalidOption
			}
		],

		Example[{Messages, "TargetConcentrationTooLarge", "A message is thrown if the target concentration exceeds the sample's current concentration; only dilutions are currently supported:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], 6 Millimolar, AssayVolume -> 100 Microliter],
			$Failed,
			Messages :> {
				Error::TargetConcentrationTooLarge,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CannotResolveAmount", "If all of a sample is to be aliquoted, but its current volume is not populated, throw an error:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (no volume)"<>$SessionUUID], All],
			$Failed,
			Messages :> {
				Warning::UnknownAmount,
				Error::CannotResolveAmount,
				Error::InvalidInput
			}
		],
		Example[{Messages, "CannotResolveAmount", "If Amount is set directly to Null but the sample is a liquid, throw CannotResolveAmount error:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (25 mL)"<>$SessionUUID], Amount -> Null],
			$Failed,
			Messages :> {
				Error::CannotResolveAmount,
				Error::InvalidInput,
				Error::StateAmountMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CannotResolveAmount", "If AssayVolume is set directly to Null but the sample is a liquid, throw CannotResolveAmount error:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (25 mL)"<>$SessionUUID], AssayVolume -> Null],
			$Failed,
			Messages :> {
				Error::CannotResolveAmount,
				Error::InvalidInput
			}
		],
		Example[{Messages, "NestedIndexMatchingConsolidateAliquotsNotSupported", "If pooling multiple samples together, ConsolidateAliquots must be False; if it is set to True, this option will be ignored and identical aliquots will not be consolidated:"},
			primitives = Download[ExperimentAliquot[
				{
					{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mg / mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL, 3 mg / mL)"<>$SessionUUID]},
					{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mg / mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL, 3 mg / mL)"<>$SessionUUID]}
				},
				ConsolidateAliquots -> True
			], OutputUnitOperations[[1]][RoboticUnitOperations]];
			DeleteDuplicates[Download[FirstCase[primitives, ObjectP[Object[UnitOperation, LabelContainer]]], Label]],
			{_String, _String},
			Messages :> {
				Warning::NestedIndexMatchingConsolidateAliquotsNotSupported
			},
			Variables :> {primitives}
		],
		Example[{Messages, "CannotResolveAssayVolume", "If TargetConcentration/Amount values for two different samples pooled together resolve to different AssayVolume values, throw the CannotResolveAssayVolume error:"},
			ExperimentAliquot[
				{{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mg / mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL, 3 mg / mL)"<>$SessionUUID]}},
				TargetConcentration -> {{1 * Milligram / Milliliter, 1 * Milligram / Milliliter}},
				Amount -> {{1 * Milliliter, 1 * Milliliter}}
			],
			$Failed,
			Messages :> {
				Error::CannotResolveAssayVolume,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NestedIndexMatchingVolumeAboveAssayVolume", "If the sum of the Amounts for all samples being pooled together is greater than the specified AssayVolume, throw the NestedIndexMatchingVolumeAboveAssayVolume error:"},
			ExperimentAliquot[
				{{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mg / mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL, 3 mg / mL)"<>$SessionUUID]}},
				Amount -> {{1.5 * Milliliter, 1.8 * Milliliter}},
				AssayVolume -> 3 * Milliliter
			],
			$Failed,
			Messages :> {
				Error::NestedIndexMatchingVolumeAboveAssayVolume,
				Error::InvalidOption
			}
		],
		Example[{Messages, "MissingMolecularWeight", "If TargetConcentration is set for a solid but MolecularWeight is not populated, throw MissingMolecularWeight error:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Resin 1 (100 mg)"<>$SessionUUID], TargetConcentration -> 1 * Micromolar, AssayVolume -> 10 * Milliliter],
			$Failed,
			Messages :> {
				Error::MissingMolecularWeight,
				Error::InvalidOption
			}
		],
		Example[{Messages, "StateAmountMismatch", "If the specified input is a solid but Amount is given in volume or count forms, throw StateAmountMismatch error:"},
			ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Resin 1 (100 mg)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Resin 1 (100 mg)"<>$SessionUUID]}, Amount -> {3 * Unit, 4 * Milliliter}],
			$Failed,
			Messages :> {
				Error::StateAmountMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TargetConcentrationNotUsed", "If given a tablet and the TargetConcentration option is specified, explicitly state that it is not going to be used with a warning:"},
			ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (3 Tablets)"<>$SessionUUID]}, Amount -> {3 * Unit}, TargetConcentration -> 5 * Milligram / Milliliter],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			Messages :> {
				Warning::TargetConcentrationNotUsed
			}
		],
		Example[{Messages, "AliquotVolumeTooLarge", "The Amount of sample being aliquoted cannot exceed the total assay volume in the aliquot destination:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], Amount -> 200 Microliter, AssayVolume -> 100 Microliter],
			$Failed,
			Messages :> {
				Error::AliquotVolumeTooLarge,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TotalAliquotVolumeTooLarge", "The Amount of sample being aliquoted cannot exceed the volume of that sample:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], Amount -> 300 * Microliter],
			ObjectP[Object[Protocol, RoboticSamplePreparation]],
			Messages :> {
				Warning::TotalAliquotVolumeTooLarge,
				Warning::OveraspiratedTransfer
			}
		],
		Example[{Messages, "VolumeOverContainerMax", "An error is thrown if the total assay volume will not fit in the desired ContainerOut:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (10 mL)"<>$SessionUUID], 5 Milliliter, ContainerOut -> Model[Container, Vessel, "2mL Tube"]],
			$Failed,
			Messages :> {
				Error::VolumeOverContainerMax,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PreparationInvalid", "If Preparation is set to Robotic, throw an error if a container cannot work with the liquid handlers and must be macro:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], Preparation -> Robotic, ContainerOut -> Model[Container, Vessel, "15mL Tube"]],
			$Failed,
			Messages :> {
				Error::PreparationInvalid,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PreparationInvalid", "If Preparation is set to Robotic, throw an error if the sample is marked as liquid handling incompatible:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot Test Sample that is Liquid Handler Incompatible"<>$SessionUUID], Amount -> 1 Milliliter, Preparation -> Robotic, ContainerOut -> Model[Container, Vessel, "50mL Tube"]],
			$Failed,
			Messages :> {
				Error::PreparationInvalid,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ContainerOutMismatchedIndex", "If specifying ContainerOut with indices, containers of different models cannot have the same index:"},
			ExperimentAliquot[
				{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL)"<>$SessionUUID]},
				{200 Microliter, 200 Microliter},
				ContainerOut -> {
					{1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
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
			ExperimentAliquot[ConstantArray[Object[Sample, "ExperimentAliquot New Test Chemical 1 (25 mL)"<>$SessionUUID], 30], 200 Microliter, ContainerOut -> ConstantArray[{1, Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]}, 30]],
			$Failed,
			Messages :> {
				Error::ContainerOverOccupied,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ContainerOverOccupied", "If more positions in the partially-filled destination container are requested than are available, throw an error:"},
			ExperimentAliquot[ConstantArray[Object[Sample, "ExperimentAliquot New Test Chemical 1 (25 mL)"<>$SessionUUID], 3], 200 Microliter, ContainerOut -> ConstantArray[{1, Object[Container, Plate, "Test full plate 3 for ExperimentAliquot Tests"<>$SessionUUID]}, 3]],
			$Failed,
			Messages :> {
				Error::ContainerOverOccupied,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DestinationWellDoesntExist", "The position specified for DestinationWell must exist in the corresponding ContainerOut:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (25 mL)"<>$SessionUUID], 200 Microliter, ContainerOut -> Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"], DestinationWell -> "E4"],
			$Failed,
			Messages :> {
				Error::DestinationWellDoesntExist,
				Error::InvalidOption
			}
		],
		Example[{Messages, "AssayVolumeAboveMaximum", "If AssayVolume is calcualted to be above $MaxTransferVolume, throw an error:"},
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)"<>$SessionUUID], 50 Nanomolar],
			$Failed,
			TimeConstraint -> 500,
			Messages :> {Error::AssayVolumeAboveMaximum, Error::InvalidOption}
		],
		Test["If the SamplesInStorageCondition option is specified, have the SamplesInStorage field be filled with the proper storage condition:",
			Download[ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (25 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (25 mL)"<>$SessionUUID]}, 200 Microliter, SamplesInStorageCondition -> Refrigerator], OutputUnitOperations[SamplesInStorageCondition]],
			{{Refrigerator}}
		],
		Test["If the SamplesOutStorageCondition option is specified, have the SamplesOutStorage field be filled with the proper storage condition:",
			Download[ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (25 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (25 mL)"<>$SessionUUID]}, 200 Microliter, SamplesOutStorageCondition -> Refrigerator], OutputUnitOperations[SamplesOutStorageCondition]],
			{{Refrigerator..}}
		],
		Test["Return a list of options if Output -> Options:",
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], Output -> Options],
			{___Rule}
		],
		Test["Return a list of options even if it doesn't resolve properly:",
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], AssayVolume -> 100 Microliter, AssayBuffer -> Model[Sample, StockSolution, "70% Ethanol"], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], Output -> Options],
			{___Rule},
			Messages :> {
				Warning::BufferWillNotBeUsed,
				Error::OverspecifiedBuffer,
				Error::BufferDilutionFactorTooLow,
				Error::InvalidOption
			}
		],
		Test["Return $Failed if the options fail to resolve:",
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], AssayVolume -> 100 Microliter, AssayBuffer -> Model[Sample, StockSolution, "70% Ethanol"], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"]],
			$Failed,
			Messages :> {
				Warning::BufferWillNotBeUsed,
				Error::OverspecifiedBuffer,
				Error::BufferDilutionFactorTooLow,
				Error::InvalidOption
			}
		],
		Test["Return a simulation blob if Output -> Simulation:",
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], Amount -> 100 Microliter, AssayVolume -> 200 Microliter, AssayBuffer -> Model[Sample, StockSolution, "70% Ethanol"], Output -> Simulation],
			_Simulation
		],
		Test["Return a simulation blob if Output -> Simulation and using a Container:",
			ExperimentAliquot[Object[Container, Vessel, "Test container 1 for ExperimentAliquot Tests" <> $SessionUUID], Amount -> 100 Microliter, AssayVolume -> 200 Microliter, AssayBuffer -> Model[Sample, StockSolution, "70% Ethanol"], Output -> Simulation],
			_Simulation
		],
		Test["Return a simulation blob if Output -> Simulation with the correct volume of sample removed:",
			simulation = ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], Amount -> 100 Microliter, AssayVolume -> 200 Microliter, AssayBuffer -> Model[Sample, StockSolution, "70% Ethanol"], Output -> Simulation];
			Download[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], Volume, Simulation -> simulation],
			EqualP[100 Microliter],
			Variables :> {simulation}
		],
		Test["Make sure the LabeledObjects and FutureLabeledObjects fields get populated properly:",
			mspProt = ExperimentManualSamplePreparation[{
				Aliquot[
					Source -> Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID],
					Amount -> 100 Microliter,
					AssayVolume -> 200 Microliter,
					AssayBuffer -> Model[Sample, StockSolution, "70% Ethanol"]
				]
			}];
			Download[
				mspProt,
				{LabeledObjects, FutureLabeledObjects}
			],
			{
				{OrderlessPatternSequence[
					{_String, ObjectP[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID]]},
					{_String, ObjectP[Download[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], Container]]}
				]},
				{OrderlessPatternSequence[
					_String -> LabelField[Field[ContainerOutLink[[1]]], 1],
					_String -> {_String, Container},
					_String -> LabelField[Field[AssayBufferLink[[1]]], 1],
					_String -> LabelField[Field[SampleOutLink[[1]]], 1]
				]}
			},
			TimeConstraint -> 1000,
			Variables :> {mspProt}
		],
		Test["Make sure the LabeledObjects and FutureLabeledObjects fields get populated properly, and that RoboticSamplePreparation doesn't do anything goofy or fancy like ManualSamplePreparation (because the framework handles it later):",
			rspProt = ExperimentRoboticSamplePreparation[{
				Aliquot[
					Source -> Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID],
					SourceLabel -> "aliquot sample 1",
					SourceContainerLabel -> "aliquot container 1",
					SampleOutLabel -> "aliquot sample out 1",
					ContainerOutLabel -> "aliquot container out 1",
					AssayBufferLabel -> "assay buffer 1",
					Amount -> 100 Microliter,
					AssayVolume -> 200 Microliter,
					AssayBuffer -> Model[Sample, StockSolution, "70% Ethanol"]
				]
			}];
			{labeledObjs, futureLabeledObjs} = Download[
				rspProt,
				{LabeledObjects, FutureLabeledObjects}
			];
			(* need to do this because at one point at least (maybe still now) there were random duplicates in LabeledObjects and FutureLabeledObjects and that was weird and not necessarily desired/permanent *)
			{
				DeleteDuplicatesBy[labeledObjs, #[[1]]&],
				DeleteDuplicatesBy[futureLabeledObjs, #[[1]]&]
			},
			{
				{OrderlessPatternSequence[
					{"aliquot sample 1", ObjectP[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID]]},
					{"aliquot container 1", ObjectP[Download[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], Container]]},
					{"aliquot container out 1", ObjectP[Model[Container, Vessel]]},
					{"assay buffer 1", ObjectP[Model[Sample]]}
				]},
				{OrderlessPatternSequence[
					"Container of assay buffer 1" -> {"assay buffer 1", Container},
					"aliquot sample out 1" -> {"aliquot container out 1", "A1"}
				]}
			},
			TimeConstraint -> 1000,
			Variables :> {rspProt, labeledObjs, futureLabeledObjs},
			SetUp :> {
				InternalUpload`Private`$UploadSampleTransferSolventDilutionLookup = Association[];
				InternalUpload`Private`$UploadSampleTransferSolventMixtureLookup = Association[];
				InternalUpload`Private`$UploadSampleTransferMediaMixtureLookup = Association[];
			}
		],
		Test["Use an Aliquot primitive to call ExperimentManualSamplePreparation and generate a protocol:",
			ExperimentManualSamplePreparation[{
				Aliquot[
					Source -> Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID],
					Amount -> 100 Microliter,
					AssayVolume -> 200 Microliter,
					AssayBuffer -> Model[Sample, StockSolution, "70% Ethanol"]
				]
			}],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			TimeConstraint -> 1000
		],
		Test["Return tests if Output -> Tests (with no messages):",
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], AssayVolume -> 100 Microliter, AssayBuffer -> Model[Sample, StockSolution, "70% Ethanol"], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], Output -> Tests],
			{__EmeraldTest}
		],
		Test["Return $Failed if the options fail to resolve even if Output -> {Result, Tests}:",
			ExperimentAliquot[Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], AssayVolume -> 100 Microliter, AssayBuffer -> Model[Sample, StockSolution, "70% Ethanol"], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], Output -> {Result, Tests}],
			{
				$Failed,
				{__EmeraldTest}
			}
		],
		Test["When consolidating aliquots, do NOT consolidate aliquots if their buffers assay buffers are different from each other:",
			primitives = Download[ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID]}, 100 * Microliter, AssayVolume -> 200 * Microliter, AssayBuffer -> {Model[Sample, "Milli-Q water"], Model[Sample, StockSolution, "10x UV buffer"]}, ConsolidateAliquots -> True], OutputUnitOperations[[1]][RoboticUnitOperations]];
			Tally[Download[FirstCase[primitives, ObjectP[Object[UnitOperation, Transfer]]], DestinationLabel]],
			{{_String, 2}, {_String, 2}},
			Variables :> {primitives}
		],
		Test["When consolidating aliquots, consolidate aliquots of the same sample that have the same volume ratio:",
			primitives = Download[ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID]}, {100 Microliter, 50 Microliter}, AssayVolume -> {200 Microliter, 100 Microliter}, ConsolidateAliquots -> True], OutputUnitOperations[[1]][RoboticUnitOperations]];
			Tally[Download[FirstCase[primitives, ObjectP[Object[UnitOperation, Transfer]]], DestinationLabel]],
			{{_String, 2}},
			Variables :> {primitives}
		],
		Test["When consolidating aliquots, consolidate aliquots of the same sample that have the same volume ratio and transfer the correct volume:",
			primitives = Download[ExperimentAliquot[{Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID], Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)"<>$SessionUUID]}, {100 Microliter, 50 Microliter}, AssayVolume -> {200 Microliter, 100 Microliter}, ConsolidateAliquots -> True], OutputUnitOperations[[1]][RoboticUnitOperations]];
			Download[FirstCase[primitives, ObjectP[Object[UnitOperation, Transfer]]], AmountVariableUnit],
			{150 Microliter, 150 Microliter},
			EquivalenceFunction -> Equal,
			Variables :> {primitives}
		],
		Test["If there aren't enough wells in a given plate, resolve the ContainerOut to be another plate:",
			options = ExperimentAliquot[ConstantArray[Object[Sample, "ExperimentAliquot New Test Chemical 1 (25 mL)"<>$SessionUUID], 7], Amount -> 2 * Milliliter, ContainerOut -> Model[Container, Plate, "6-well Tissue Culture Plate"], Output -> Options];
			Lookup[options, ContainerOut],
			{
				{1, ObjectP[Model[Container, Plate, "6-well Tissue Culture Plate"]]},
				{1, ObjectP[Model[Container, Plate, "6-well Tissue Culture Plate"]]},
				{1, ObjectP[Model[Container, Plate, "6-well Tissue Culture Plate"]]},
				{1, ObjectP[Model[Container, Plate, "6-well Tissue Culture Plate"]]},
				{1, ObjectP[Model[Container, Plate, "6-well Tissue Culture Plate"]]},
				{1, ObjectP[Model[Container, Plate, "6-well Tissue Culture Plate"]]},
				{2, ObjectP[Model[Container, Plate, "6-well Tissue Culture Plate"]]}
			},
			Variables :> {options}
		],
		Test["If aliquoting something that is incompatible with glass, don't pick a container that has glass in it:",
			Download[
				ExperimentAliquot[
					{{
						Object[Sample, "ExperimentAliquot Test Sample 1 that is incompatible with glass " <> $SessionUUID],
						Object[Sample, "ExperimentAliquot Test Sample 2 that is incompatible with glass " <> $SessionUUID]
					}}
				],
				OutputUnitOperations[[1]][ContainerLink][ContainerMaterials]
			],
			{{Polypropylene}}
		],
		Test["Generate an Object[Protocol, ManualCellPreparation] if Preparation -> Manual and a cell-containing sample is used:",
			ExperimentAliquot[
				{Object[Sample, "ExperimentAliquot Test cell Sample 1 " <> $SessionUUID]},
				Preparation -> Manual,
				ImageSample -> False,
				MeasureVolume -> False,
				MeasureWeight -> False
			],
			ObjectP[Object[Protocol, ManualCellPreparation]]
		],
		Test["Generate an Object[Protocol, RoboticCellPreparation] if Preparation -> Robotic and a cell-containing sample is used:",
			ExperimentAliquot[
				{Object[Sample, "ExperimentAliquot Test cell Sample 1 " <> $SessionUUID]},
				Preparation -> Robotic,
				ImageSample -> False,
				MeasureVolume -> False,
				MeasureWeight -> False
			],
			ObjectP[Object[Protocol, RoboticCellPreparation]]
		]
	},
	Stubs :> {
		$EmailEnabled = False,
		$AllowSystemsProtocols = True,
		$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"]
	},
	SetUp :> (ClearDownload[]; ClearMemoization[]; $CreatedObjects = {}),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::NoModelNameGiven];

		ClearDownload[];
		ClearMemoization[];
		Module[
			{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Test bench for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Protocol, HPLC, "ExperimentAliquot HPLC parent" <> $SessionUUID],
				Object[Container, Vessel, "Test container 1 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 2 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 3 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 4 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 5 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 6 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 7 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 8 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 9 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 10 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 11 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 12 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 13 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 14 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 15 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 16 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 17 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 18 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 19 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 20 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 21 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 22 (cell sample) for ExperimentAliquot Tests" <> $SessionUUID],

				Object[Container, Plate, "Test plate 1 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Plate, "Test plate 2 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Plate, "Test full plate 3 for ExperimentAliquot Tests" <> $SessionUUID],

				Model[Sample, StockSolution, "Test Concentration Stock Solution For Aliquot Tests" <> $SessionUUID],
				Model[Sample, StockSolution, "Test Mass Concentration Stock Solution For Aliquot Tests" <> $SessionUUID],

				Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL, 3 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mg / mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL, 3 mg / mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (25 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (10 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (no volume)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (5 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (3 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (Discarded)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (100 mg)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Resin 1 (100 mg)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (3 Tablets)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 in occupied plate" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 2 in occupied plate" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 3 in occupied plate" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 4 in occupied plate" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot Test Sample with Conc Composition" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot Test Sample with Mass Conc Composition" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot Test Sample that is Liquid Handler Incompatible" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot Test Sample 1 that is incompatible with glass " <> $SessionUUID],
				Object[Sample, "ExperimentAliquot Test Sample 2 that is incompatible with glass " <> $SessionUUID],
				Object[Sample, "ExperimentAliquot Test cell Sample 1 " <> $SessionUUID],

				Object[Protocol, RoboticSamplePreparation, "Previous Aliquot SamplePreparation" <> $SessionUUID]
			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					templateProt,
					molarStockSolutionModel, massConcStockSolutionModel,
					testBench,
					container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11, container12, container13, container14, container15, container16, container17, container18, container19, container20, container21, container22,
					plate1, plate2, plate3,
					sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12, sample13, sample14, sample15, sample16, sample17, sample18, sample19, sample20, sample21,
					sample22, sample23, sample24, sample25, sample26,

					allObjs
				},

				templateProt = Upload[<|
					Type -> Object[Protocol, RoboticSamplePreparation],
					DeveloperObject -> True,
					Name -> "Previous Aliquot SamplePreparation" <> $SessionUUID,
					ResolvedOptions -> {ContainerOut -> Model[Container, Vessel, "15mL Tube"]},
					UnresolvedOptions -> {ContainerOut -> Model[Container, Vessel, "15mL Tube"]}
				|>];

				(* Create stock solutions *)
				molarStockSolutionModel = UploadStockSolution[
					{{15 Gram, Model[Sample, "Sodium Chloride"]}}, Model[Sample, "Milli-Q water"], 1 Liter,
					Name -> "Test Concentration Stock Solution For Aliquot Tests" <> $SessionUUID
				];

				massConcStockSolutionModel = UploadStockSolution[
					{{15 Gram, Model[Sample, "Sodium Chloride"]}}, Model[Sample, "Milli-Q water"], 1 Liter,
					Name -> "Test Mass Concentration Stock Solution For Aliquot Tests" <> $SessionUUID,
					Composition -> {
						{100 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]},
						{15 Gram / Liter, Model[Molecule, "id:BYDOjvG676mq"]}
					}
				];

				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for ExperimentAliquot Tests" <> $SessionUUID,
					DeveloperObject -> True
				|>];
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
					container15,
					container16,
					container17,
					container18,
					container19,
					container20,
					container21,
					plate1,
					plate2,
					plate3,
					container22
				} = UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Plate, "6-well Tissue Culture Plate"],
						Model[Container, Vessel, "2mL Tube"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
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
						"Test container 1 for ExperimentAliquot Tests" <> $SessionUUID,
						"Test container 2 for ExperimentAliquot Tests" <> $SessionUUID,
						"Test container 3 for ExperimentAliquot Tests" <> $SessionUUID,
						"Test container 4 for ExperimentAliquot Tests" <> $SessionUUID,
						"Test container 5 for ExperimentAliquot Tests" <> $SessionUUID,
						"Test container 6 for ExperimentAliquot Tests" <> $SessionUUID,
						"Test container 7 for ExperimentAliquot Tests" <> $SessionUUID,
						"Test container 8 for ExperimentAliquot Tests" <> $SessionUUID,
						"Test container 9 for ExperimentAliquot Tests" <> $SessionUUID,
						"Test container 10 for ExperimentAliquot Tests" <> $SessionUUID,
						"Test container 11 for ExperimentAliquot Tests" <> $SessionUUID,
						"Test container 12 for ExperimentAliquot Tests" <> $SessionUUID,
						"Test container 13 for ExperimentAliquot Tests" <> $SessionUUID,
						"Test container 14 for ExperimentAliquot Tests" <> $SessionUUID,
						"Test container 15 for ExperimentAliquot Tests" <> $SessionUUID,
						"Test container 16 for ExperimentAliquot Tests" <> $SessionUUID,
						"Test container 17 for ExperimentAliquot Tests" <> $SessionUUID,
						"Test container 18 for ExperimentAliquot Tests" <> $SessionUUID,
						"Test container 19 for ExperimentAliquot Tests" <> $SessionUUID,
						"Test container 20 for ExperimentAliquot Tests" <> $SessionUUID,
						"Test container 21 for ExperimentAliquot Tests" <> $SessionUUID,
						"Test plate 1 for ExperimentAliquot Tests" <> $SessionUUID,
						"Test plate 2 for ExperimentAliquot Tests" <> $SessionUUID,
						"Test full plate 3 for ExperimentAliquot Tests" <> $SessionUUID,
						"Test container 22 (cell sample) for ExperimentAliquot Tests" <> $SessionUUID
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
					sample11,
					sample12,
					sample13,
					sample14,
					sample15,
					sample16,
					sample17,
					sample18,
					sample19,
					sample20,
					sample21,
					sample22,
					sample23,
					sample24,
					sample25,
					sample26
				} = UploadSample[
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Wang-ChemMatrix "],
						Model[Sample, "Test Ibuprofen tablet Model for ExperimentMeasureCount Testing"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						molarStockSolutionModel,
						massConcStockSolutionModel,
						Model[Sample, "Sulfuric acid"],
						Model[Sample, "Triethylamine trihydrofluoride"],
						Model[Sample, "Triethylamine trihydrofluoride"],
						Model[Sample, "E.coli MG1655"]
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
						{"A1", container10},
						{"A1", container11},
						{"A1", container12},
						{"A1", container13},
						{"A1", container14},
						{"A1", container15},
						{"A1", container16},
						{"A1", plate3},
						{"A2", plate3},
						{"A3", plate3},
						{"B1", plate3},
						{"A1", container17},
						{"A1", container18},
						{"A1", container19},
						{"A1", container20},
						{"A1", container21},
						{"A1", container22}
					},
					InitialAmount -> {
						200 * Microliter,
						1.5 * Milliliter,
						1.5 * Milliliter,
						1.8 * Milliliter,
						1.8 * Milliliter,
						1.5 * Milliliter,
						1.8 * Milliliter,
						25 * Milliliter,
						10 * Milliliter,
						Null,
						5 * Milliliter,
						3 * Milliliter,
						1 * Milliliter,
						100 * Milligram,
						100 * Milligram,
						3,
						3 * Milliliter,
						3 * Milliliter,
						3 * Milliliter,
						3 * Milliliter,
						3 * Milliliter,
						3 * Milliliter,
						10 * Milliliter,
						40 * Milliliter,
						40 * Milliliter,
						1 * Milliliter
					},
					Name -> {
						"ExperimentAliquot New Test Chemical 1 (200 uL)" <> $SessionUUID,
						"ExperimentAliquot New Test Chemical 1 (1.5 mL)" <> $SessionUUID,
						"ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)" <> $SessionUUID,
						"ExperimentAliquot New Test Chemical 1 (1.8 mL)" <> $SessionUUID,
						"ExperimentAliquot New Test Chemical 1 (1.8 mL, 3 mL)" <> $SessionUUID,
						"ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mg / mL)" <> $SessionUUID,
						"ExperimentAliquot New Test Chemical 1 (1.8 mL, 3 mg / mL)" <> $SessionUUID,
						"ExperimentAliquot New Test Chemical 1 (25 mL)" <> $SessionUUID,
						"ExperimentAliquot New Test Chemical 1 (10 mL)" <> $SessionUUID,
						"ExperimentAliquot New Test Chemical 1 (no volume)" <> $SessionUUID,
						"ExperimentAliquot New Test Chemical 1 (5 mL)" <> $SessionUUID,
						"ExperimentAliquot New Test Chemical 1 (3 mL)" <> $SessionUUID,
						"ExperimentAliquot New Test Chemical 1 (Discarded)" <> $SessionUUID,
						"ExperimentAliquot New Test Chemical 1 (100 mg)" <> $SessionUUID,
						"ExperimentAliquot New Test Resin 1 (100 mg)" <> $SessionUUID,
						"ExperimentAliquot New Test Chemical 1 (3 Tablets)" <> $SessionUUID,
						"ExperimentAliquot New Test Chemical 1 in occupied plate" <> $SessionUUID,
						"ExperimentAliquot New Test Chemical 2 in occupied plate" <> $SessionUUID,
						"ExperimentAliquot New Test Chemical 3 in occupied plate" <> $SessionUUID,
						"ExperimentAliquot New Test Chemical 4 in occupied plate" <> $SessionUUID,
						"ExperimentAliquot Test Sample with Conc Composition" <> $SessionUUID,
						"ExperimentAliquot Test Sample with Mass Conc Composition" <> $SessionUUID,
						"ExperimentAliquot Test Sample that is Liquid Handler Incompatible" <> $SessionUUID,
						"ExperimentAliquot Test Sample 1 that is incompatible with glass " <> $SessionUUID,
						"ExperimentAliquot Test Sample 2 that is incompatible with glass " <> $SessionUUID,
						"ExperimentAliquot Test cell Sample 1 " <> $SessionUUID
					}
				];


				allObjs = {
					plate1, plate2, plate3, container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11, container12, container13, container14, container15, container16, container17, container18, container19, container20, container21,
					sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12, sample13, sample14, sample15, sample16, sample17, sample18, sample19, sample20, sample21, sample22, sample23, sample24, sample25, sample26
				};

				(* get rid of the Model field for these samples so that we can make sure everything works when that is the case *)
				Upload[Flatten[{
					<|Object -> #, DeveloperObject -> True|>& /@ allObjs,
					<|
						Object -> sample3,
						Model -> Null,
						Replace[Composition] -> {
							{100 VolumePercent, Link[Model[Molecule, "Water"]], Now},
							{5 Millimolar, Link[Model[Molecule, "Methylamine"]], Now}
						}
					|>,
					<|
						Object -> sample5,
						Model -> Null,
						Replace[Composition] -> {
							{100 VolumePercent, Link[Model[Molecule, "Water"]], Now},
							{3 Millimolar, Link[Model[Molecule, "Methylamine"]], Now}
						}
					|>,
					<|
						Object -> sample6,
						Model -> Null,
						Replace[Composition] -> {
							{100 VolumePercent, Link[Model[Molecule, "Water"]], Now},
							{5 Milligram / Milliliter, Link[Model[Molecule, "Sodium Chloride"]], Now}
						}
					|>,
					<|
						Object -> sample7,
						Model -> Null,
						Replace[Composition] -> {
							{100 VolumePercent, Link[Model[Molecule, "Water"]], Now},
							{3 Milligram / Milliliter, Link[Model[Molecule, "Sodium Chloride"]], Now}
						}
					|>,
					<|Type -> Object[Protocol, HPLC], Name -> "ExperimentAliquot HPLC parent" <> $SessionUUID, DeveloperObject -> True|>
				}]];
				UploadSampleStatus[sample13, Discarded, FastTrack -> True];

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
				Object[Container, Bench, "Test bench for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Protocol, HPLC, "ExperimentAliquot HPLC parent" <> $SessionUUID],
				Object[Container, Vessel, "Test container 1 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 2 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 3 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 4 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 5 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 6 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 7 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 8 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 9 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 10 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 11 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 12 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 13 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 14 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 15 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 16 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 17 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 18 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 19 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 20 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 21 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 22 (cell sample) for ExperimentAliquot Tests" <> $SessionUUID],

				Object[Container, Plate, "Test plate 1 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Plate, "Test plate 2 for ExperimentAliquot Tests" <> $SessionUUID],
				Object[Container, Plate, "Test full plate 3 for ExperimentAliquot Tests" <> $SessionUUID],

				Model[Sample, StockSolution, "Test Concentration Stock Solution For Aliquot Tests" <> $SessionUUID],
				Model[Sample, StockSolution, "Test Mass Concentration Stock Solution For Aliquot Tests" <> $SessionUUID],

				Object[Sample, "ExperimentAliquot New Test Chemical 1 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL, 3 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.5 mL, 5 mg / mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (1.8 mL, 3 mg / mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (25 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (10 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (no volume)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (5 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (3 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (Discarded)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (100 mg)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Resin 1 (100 mg)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 (3 Tablets)" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 1 in occupied plate" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 2 in occupied plate" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 3 in occupied plate" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot New Test Chemical 4 in occupied plate" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot Test Sample with Conc Composition" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot Test Sample with Mass Conc Composition" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot Test Sample that is Liquid Handler Incompatible" <> $SessionUUID],
				Object[Sample, "ExperimentAliquot Test Sample 1 that is incompatible with glass " <> $SessionUUID],
				Object[Sample, "ExperimentAliquot Test Sample 2 that is incompatible with glass " <> $SessionUUID],
				Object[Sample, "ExperimentAliquot Test cell Sample 1 " <> $SessionUUID],

				Object[Protocol, RoboticSamplePreparation, "Previous Aliquot SamplePreparation" <> $SessionUUID]
			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];



(* ::Subsection:: *)
(*Aliquot*)



DefineTests[Aliquot,
	{
		Example[{Basic, "Perform quantitative aliquot:"},
			Experiment[
				{
					Aliquot[
						Source -> Object[Sample, "Aliquot New Test Chemical 1 (200 uL)"<>$SessionUUID],
						Amount -> All
					]
				}
			],
			ObjectP[Object[Protocol]]
		],
		Example[{Basic, "Aliquot multiple samples:"},
			Experiment[
				{
					Aliquot[
						Source -> {Object[Sample, "Aliquot New Test Chemical 1 (200 uL)"<>$SessionUUID], Object[Sample, "Aliquot New Test Chemical 2 (200 uL)"<>$SessionUUID], Object[Sample, "Aliquot New Test Chemical 3 (200 uL)"<>$SessionUUID]},
						Amount -> 100 Microliter
					]
				}
			],
			ObjectP[Object[Protocol]]
		],
		Example[{Basic, "Diluting a sample to a target concentration:"},
			Experiment[
				{
					Aliquot[
						Source -> Object[Sample, "Aliquot New Test Chemical 3 (200 uL)"<>$SessionUUID],
						TargetConcentration -> 1000 Micromolar,
						AssayVolume -> 200 Microliter,
						AssayBuffer -> Model[Sample, StockSolution, "70% Ethanol"]
					]
				}
			],
			ObjectP[Object[Protocol]]
		]
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		{
			Module[
				{allObjs, existingObjs},
				allObjs = {
					Object[Container, Bench, "Test bench for Aliquot tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 1 for Aliquot tests"<>$SessionUUID],
					Object[Container, Plate, "Test plate 1 for Aliquot tests"<>$SessionUUID],
					Object[Container, Plate, "Test plate 2 for Aliquot tests"<>$SessionUUID],
					Object[Sample, "Aliquot New Test Chemical 1 (200 uL)"<>$SessionUUID],
					Object[Sample, "Aliquot New Test Chemical 2 (200 uL)"<>$SessionUUID],
					Object[Sample, "Aliquot New Test Chemical 3 (200 uL)"<>$SessionUUID]
				};
				existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
				EraseObject[existingObjs, Force -> True, Verbose -> False]
			],
			Module[
				{
					fakeBench,
					container, plate1, plate2,
					sample, sample2, sample3,

					allObjs
				},

				fakeBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Test bench for Aliquot tests"<>$SessionUUID,DeveloperObject->True|>];
				{
					container,
					plate1,
					plate2
				}=UploadSample[
					{
						Model[Container,Vessel,"2mL Tube"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"]
					},
					{
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench}
					},
					Status->{
						Available,
						Available,
						Available
					},
					Name->{
						"Test container 1 for Aliquot tests"<>$SessionUUID,
						"Test plate 1 for Aliquot tests"<>$SessionUUID,
						"Test plate 2 for Aliquot tests"<>$SessionUUID
					}
				];
				{
					sample,
					sample2,
					sample3
				}=UploadSample[
					{
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"]
					},
					{
						{"A1",container},
						{"A2", plate1},
						{"B1", plate2}
					},
					InitialAmount->{
						200*Microliter,
						200*Microliter,
						200*Microliter
					},
					Name-> {
						"Aliquot New Test Chemical 1 (200 uL)"<>$SessionUUID,
						"Aliquot New Test Chemical 2 (200 uL)"<>$SessionUUID,
						"Aliquot New Test Chemical 3 (200 uL)"<>$SessionUUID
					}
				];


				allObjs = {
					container,
					sample, sample2, sample3,
					plate1, plate2
				};

				Upload[Flatten[{
					<|Object->#,DeveloperObject->True|>&/@allObjs,
					<|
						Object -> sample3,
						Concentration -> 5*Millimolar,
						Replace[Composition] -> {
							{5 Millimolar, Link[Model[Molecule, "Methylamine"]], Now},
							{100 VolumePercent, Link[Model[Molecule, "Water"]], Now}
						}
					|>
				}]];

			]
		}
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		{
			Module[
				{allObjs, existingObjs},
				allObjs = {
					Object[Container, Bench, "Test bench for Aliquot tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 1 for Aliquot tests"<>$SessionUUID],
					Object[Container, Plate, "Test plate 1 for Aliquot tests"<>$SessionUUID],
					Object[Container, Plate, "Test plate 2 for Aliquot tests"<>$SessionUUID],
					Object[Sample, "Aliquot New Test Chemical 1 (200 uL)"<>$SessionUUID],
					Object[Sample, "Aliquot New Test Chemical 2 (200 uL)"<>$SessionUUID],
					Object[Sample, "Aliquot New Test Chemical 3 (200 uL)"<>$SessionUUID]
				};
				existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
				EraseObject[existingObjs, Force -> True, Verbose -> False]
			]
		}
	)
];