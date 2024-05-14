(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ValidExperimentAliquotQ*)


DefineTests[ValidExperimentAliquotQ,
	{
		Example[{Basic, "Aliquot the full volume of a sample into a new container of the preferred container for the volume:"},
			ValidExperimentAliquotQ[Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (200 uL)"], All],
			True,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],
		Example[{Basic, "Aliquot a specific volume of a sample into a new container:"},
			ValidExperimentAliquotQ[Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.5 mL)"], 1 Milliliter, ContainerOut -> Model[Container, Vessel, "2mL Tube"]],
			True,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],
		Example[{Basic, "Dilute a sample to a new target concentration:"},
			ValidExperimentAliquotQ[Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.5 mL, 5 mM)"], 50 Micromolar],
			True,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],
		Example[{Additional, "Containers", "Aliquot the full volume of a all the samples into a new container of the same type as the sample's current container:"},
			ValidExperimentAliquotQ[Object[Container, Vessel, "Fake container 1 for ValidExperimentAliquotQ tests"]],
			True,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],
		Example[{Additional, "Containers", "Aliquot a specific volume of the sample(s) in a specified container into a new container:"},
			ValidExperimentAliquotQ[Object[Container, Vessel, "Fake container 2 for ValidExperimentAliquotQ tests"], 1 Milliliter, ContainerOut -> Model[Container, Vessel, "2mL Tube"]],
			True,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],
		Example[{Additional, "Containers", "Dilute the sample(s) in a given container to a new target concentration:"},
			ValidExperimentAliquotQ[Object[Container, Vessel, "Fake container 3 for ValidExperimentAliquotQ tests"], 50 Micromolar],
			True,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],
		Example[{Additional, "Aliquot a specific volume of multiple samples into a new container:"},
			ValidExperimentAliquotQ[{Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.5 mL)"], Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.8 mL)"]}, {200 Microliter, 200 Microliter}, ContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
			True,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],
		Example[{Additional, "Aliquot the same volume from multiple source samples:"},
			ValidExperimentAliquotQ[{Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.5 mL)"], Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.8 mL)"]}, 200 Microliter],
			True,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],
		Example[{Additional, "Dilute multiple samples to the same target concentration:"},
			ValidExperimentAliquotQ[{Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.5 mL, 5 mM)"], Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.8 mL, 3 mM)"]}, 10 Micromolar],
			True,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],

		(* --- Messages --- *)

		Example[{Messages, "DiscardedSamples", "Discarded objects are not supported as inputs or options:"},
			ValidExperimentAliquotQ[Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (Discarded)"]],
			False,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],
		Example[{Messages, "DeprecatedModels", "Deprecated models are not supported for any option value:"},
			ValidExperimentAliquotQ[Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (200 uL)"], 200 Microliter, ContainerOut -> Model[Container, Vessel, "1KG tall small shoulder white plasticv rectangular solid bottle, Deprecated"]],
			False,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],
		Example[{Messages, "NoVolume", "If a sample is to be aliquoted, a volume has been specified, but its current volume is not populated, throw a warning and possibly an error:"},
			ValidExperimentAliquotQ[Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (no volume)"], 200 * Microliter],
			True,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],

		Example[{Messages, "OverspecifiedBuffer", "Both AssayBuffer and ConcentratedBuffer cannot be simultaneously requested:"},
			ValidExperimentAliquotQ[Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.5 mL, 5 mM)"], AssayVolume -> 100 Microliter, AssayBuffer -> Model[Sample, StockSolution, "70% Ethanol"], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"]],
			False,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],
		Example[{Messages, "BufferDilutionMismatched", "If BufferDilutionFactor and/or BufferDiluent are specified, ConcentratedBuffer must also be specified:"},
			ValidExperimentAliquotQ[Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.5 mL, 5 mM)"], BufferDiluent -> Model[Sample, "Milli-Q water"]],
			False,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],
		Example[{Messages, "NonEmptyContainers", "Specifically provided containers must be empty to serve as aliquoting destinations:"},
			ValidExperimentAliquotQ[Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.5 mL)"], 500 Microliter, ContainerOut -> Object[Container, Vessel, "Fake container 2 for ValidExperimentAliquotQ tests"]],
			False,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],

		Example[{Messages, "ConcentrationRatioMismatch", "If TargetConcentration, AssayVolume, and Amount are specified, the ratios of target concentration and current concentration must match the ratio of volume to assay volume:"},
			ValidExperimentAliquotQ[Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.5 mL, 5 mM)"], TargetConcentration -> 1 * Millimolar, Amount -> 100 * Microliter, AssayVolume -> 200 * Microliter],
			False,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],
		Example[{Messages, "NoConcentration", "TargetConcentration cannot be used if current sample concentration is unknown:"},
			ValidExperimentAliquotQ[Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.5 mL)"], 100 Micromolar, AssayVolume -> 100 Microliter],
			False,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],
		Example[{Messages, "NoConcentration", "TargetConcentration may not be specified in units of MassConcentration if only Concentration is populated in the sample (and vice versa):"},
			ValidExperimentAliquotQ[Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.5 mL, 5 mM)"], 1 * (Milligram / Milliliter), AssayVolume -> 100 Microliter],
			False,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],
		Example[{Messages, "TargetConcentrationTooLarge", "A message is thrown if the target concentration exceeds the sample's current concentration; only dilutions are currently supported:"},
			ValidExperimentAliquotQ[Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.5 mL, 5 mM)"], 6 Millimolar, AssayVolume -> 100 Microliter],
			False,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],
		Example[{Messages, "CannotResolveVolume", "If all of a sample is to be aliquoted, but its current volume is not populated, throw an error:"},
			ValidExperimentAliquotQ[Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (no volume)"], All],
			False,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],
		Example[{Messages, "AliquotVolumeTooLarge", "The Amount of sample being aliquoted cannot exceed the total assay volume in the aliquot destination:"},
			ValidExperimentAliquotQ[Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (200 uL)"], Amount -> 200 Microliter, AssayVolume -> 100 Microliter],
			False,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],
		Example[{Messages, "TotalAliquotVolumeTooLarge", "The Amount of sample being aliquoted cannot exceed the volume of that sample:"},
			ValidExperimentAliquotQ[Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (200 uL)"], Amount -> 300 * Microliter],
			True,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],
		Example[{Messages, "VolumeOverContainerMax", "An error is thrown if the total assay volume will not fit in the desired ContainerOut:"},
			ValidExperimentAliquotQ[Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (10 mL)"], 5 Milliliter, ContainerOut -> Model[Container, Vessel, "2mL Tube"]],
			False,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],
		Example[{Messages, "PreparationInvalid", "If Preparation is set to Robotic, throw an error if a container cannot work with the liquid handlers and must be macro:"},
			ValidExperimentAliquotQ[Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (200 uL)"], Preparation -> Robotic, ContainerOut -> Model[Container, Vessel, "15mL Tube"]],
			False,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],
		Example[{Messages, "ContainerOutMismatchedIndex", "If specifying ContainerOut with indices, containers of different models cannot have the same index:"},
			ValidExperimentAliquotQ[
				{Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.5 mL)"], Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.8 mL)"]},
				{200 Microliter, 200 Microliter},
				ContainerOut -> {
					{1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
					{1, Model[Container, Vessel, "2mL Tube"]}
				}
			],
			False,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],
		Example[{Messages, "ContainerOverOccupied", "If more positions in the destination container are requested than are available, throw an error:"},
			ValidExperimentAliquotQ[ConstantArray[Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (25 mL)"], 30], 200 Microliter, ContainerOut -> ConstantArray[{1, Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]}, 30]],
			False,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],
		Example[{Options, OutputFormat, "Return a test summary if OutputFormat -> TestSummary:"},
			ValidExperimentAliquotQ[Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (200 uL)"], OutputFormat -> TestSummary],
			_EmeraldTestSummary,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		],
		Example[{Options, Verbose, "If Verbose -> Failures, show the failing tests or warnings:"},
			ValidExperimentAliquotQ[Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (no volume)"], 200 * Microliter, Verbose -> Failures],
			True,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 180
		]
	},
	Stubs :> {
		$EmailEnabled = False,
		ValidObjectQ[x_List, ___]:=ConstantArray[True, Length[x]]
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		{
			Module[
				{allObjs, existingObjs},
				allObjs = {
					Object[Container, Bench, "Fake bench for ValidExperimentAliquotQ tests"],
					Object[Protocol, HPLC, "ValidExperimentAliquotQ HPLC parent"],
					Object[Container, Vessel, "Fake container 1 for ValidExperimentAliquotQ tests"],
					Object[Container, Vessel, "Fake container 2 for ValidExperimentAliquotQ tests"],
					Object[Container, Vessel, "Fake container 3 for ValidExperimentAliquotQ tests"],
					Object[Container, Vessel, "Fake container 4 for ValidExperimentAliquotQ tests"],
					Object[Container, Vessel, "Fake container 5 for ValidExperimentAliquotQ tests"],
					Object[Container, Vessel, "Fake container 6 for ValidExperimentAliquotQ tests"],
					Object[Container, Vessel, "Fake container 7 for ValidExperimentAliquotQ tests"],
					Object[Container, Vessel, "Fake container 8 for ValidExperimentAliquotQ tests"],
					Object[Container, Vessel, "Fake container 9 for ValidExperimentAliquotQ tests"],
					Object[Container, Vessel, "Fake container 10 for ValidExperimentAliquotQ tests"],
					Object[Container, Vessel, "Fake container 11 for ValidExperimentAliquotQ tests"],
					Object[Container, Vessel, "Fake container 12 for ValidExperimentAliquotQ tests"],
					Object[Container, Vessel, "Fake container 13 for ValidExperimentAliquotQ tests"],
					Object[Container, Plate, "Fake plate 1 for ValidExperimentAliquotQ tests"],
					Object[Container, Plate, "Fake plate 2 for ValidExperimentAliquotQ tests"],
					Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (200 uL)"],
					Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.5 mL)"],
					Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.5 mL, 5 mM)"],
					Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.8 mL)"],
					Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.8 mL, 3 mM)"],
					Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.5 mL, 5 mg / mL)"],
					Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.8 mL, 3 mg / mL)"],
					Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (25 mL)"],
					Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (10 mL)"],
					Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (no volume)"],
					Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (5 mL)"],
					Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (3 mL)"],
					Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (Discarded)"]
				};
				existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
				EraseObject[existingObjs, Force -> True, Verbose -> False]
			],
			Module[
				{
					fakeBench,
					container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11, container12, container13, plate1, plate2,
					sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12, sample13,

					allObjs
				},

				fakeBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Fake bench for ValidExperimentAliquotQ tests",DeveloperObject->True|>];
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
					plate1,
					plate2
				}=UploadSample[
					{
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Vessel,"2mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"]
					},
					{
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench}
					},
					Status->{
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
					Name->{
						"Fake container 1 for ValidExperimentAliquotQ tests",
						"Fake container 2 for ValidExperimentAliquotQ tests",
						"Fake container 3 for ValidExperimentAliquotQ tests",
						"Fake container 4 for ValidExperimentAliquotQ tests",
						"Fake container 5 for ValidExperimentAliquotQ tests",
						"Fake container 6 for ValidExperimentAliquotQ tests",
						"Fake container 7 for ValidExperimentAliquotQ tests",
						"Fake container 8 for ValidExperimentAliquotQ tests",
						"Fake container 9 for ValidExperimentAliquotQ tests",
						"Fake container 10 for ValidExperimentAliquotQ tests",
						"Fake container 11 for ValidExperimentAliquotQ tests",
						"Fake container 12 for ValidExperimentAliquotQ tests",
						"Fake container 13 for ValidExperimentAliquotQ tests",
						"Fake plate 1 for ValidExperimentAliquotQ tests",
						"Fake plate 2 for ValidExperimentAliquotQ tests"
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
					sample13
				}=UploadSample[
					{
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"]
					},
					{
						{"A1",container},
						{"A1",container2},
						{"A1",container3},
						{"A1",container4},
						{"A1",container5},
						{"A1",container6},
						{"A1",container7},
						{"A1",container8},
						{"A1",container9},
						{"A1",container10},
						{"A1",container11},
						{"A1",container12},
						{"A1",container13}
					},
					InitialAmount->{
						200*Microliter,
						1.5*Milliliter,
						1.5*Milliliter,
						1.8*Milliliter,
						1.8*Milliliter,
						1.5*Milliliter,
						1.8*Milliliter,
						25*Milliliter,
						10*Milliliter,
						Null,
						5*Milliliter,
						3*Milliliter,
						1*Milliliter
					},
					Name->{
						"ValidExperimentAliquotQ New Test Chemical 1 (200 uL)",
						"ValidExperimentAliquotQ New Test Chemical 1 (1.5 mL)",
						"ValidExperimentAliquotQ New Test Chemical 1 (1.5 mL, 5 mM)",
						"ValidExperimentAliquotQ New Test Chemical 1 (1.8 mL)",
						"ValidExperimentAliquotQ New Test Chemical 1 (1.8 mL, 3 mM)",
						"ValidExperimentAliquotQ New Test Chemical 1 (1.5 mL, 5 mg / mL)",
						"ValidExperimentAliquotQ New Test Chemical 1 (1.8 mL, 3 mg / mL)",
						"ValidExperimentAliquotQ New Test Chemical 1 (25 mL)",
						"ValidExperimentAliquotQ New Test Chemical 1 (10 mL)",
						"ValidExperimentAliquotQ New Test Chemical 1 (no volume)",
						"ValidExperimentAliquotQ New Test Chemical 1 (5 mL)",
						"ValidExperimentAliquotQ New Test Chemical 1 (3 mL)",
						"ValidExperimentAliquotQ New Test Chemical 1 (Discarded)"
					}
				];


				allObjs = {
					container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11, container12, container13,
					sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12, sample13,
					plate1, plate2
				};

				Upload[Flatten[{
					<|Object->#,DeveloperObject->True|>&/@allObjs,
					<|
						Object -> sample3,
						Concentration -> 5*Millimolar,
						Replace[Composition] -> {
							{5 Millimolar, Link[Model[Molecule, "Methylamine"]]},
							{100 VolumePercent, Link[Model[Molecule, "Water"]]}
						}
					|>,
					<|
						Object -> sample5,
						Concentration -> 3*Millimolar,
						Replace[Composition] -> {
							{3 Millimolar, Link[Model[Molecule, "Methylamine"]]},
							{100 VolumePercent, Link[Model[Molecule, "Water"]]}
						}
					|>,
					<|
						Object -> sample6,
						MassConcentration -> 5*(Milligram/Milliliter),
						Replace[Composition] -> {
							{5 Milligram/Milliliter, Link[Model[Molecule, "Methylamine"]]},
							{100 VolumePercent, Link[Model[Molecule, "Water"]]}
						}
					|>,
					<|
						Object -> sample7,
						MassConcentration -> 3*(Milligram/Milliliter),
						Replace[Composition] -> {
							{3 Milligram/Milliliter, Link[Model[Molecule, "Methylamine"]]},
							{100 VolumePercent, Link[Model[Molecule, "Water"]]}
						}
					|>,
					<|Type -> Object[Protocol, HPLC], Name -> "ValidExperimentAliquotQ HPLC parent", DeveloperObject -> True|>
				}]];
				UploadSampleStatus[sample13, Discarded, FastTrack -> True]

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
					Object[Container, Bench, "Fake bench for ValidExperimentAliquotQ tests"],
					Object[Protocol, HPLC, "ValidExperimentAliquotQ HPLC parent"],
					Object[Container, Vessel, "Fake container 1 for ValidExperimentAliquotQ tests"],
					Object[Container, Vessel, "Fake container 2 for ValidExperimentAliquotQ tests"],
					Object[Container, Vessel, "Fake container 3 for ValidExperimentAliquotQ tests"],
					Object[Container, Vessel, "Fake container 4 for ValidExperimentAliquotQ tests"],
					Object[Container, Vessel, "Fake container 5 for ValidExperimentAliquotQ tests"],
					Object[Container, Vessel, "Fake container 6 for ValidExperimentAliquotQ tests"],
					Object[Container, Vessel, "Fake container 7 for ValidExperimentAliquotQ tests"],
					Object[Container, Vessel, "Fake container 8 for ValidExperimentAliquotQ tests"],
					Object[Container, Vessel, "Fake container 9 for ValidExperimentAliquotQ tests"],
					Object[Container, Vessel, "Fake container 10 for ValidExperimentAliquotQ tests"],
					Object[Container, Vessel, "Fake container 11 for ValidExperimentAliquotQ tests"],
					Object[Container, Vessel, "Fake container 12 for ValidExperimentAliquotQ tests"],
					Object[Container, Vessel, "Fake container 13 for ValidExperimentAliquotQ tests"],
					Object[Container, Plate, "Fake plate 1 for ValidExperimentAliquotQ tests"],
					Object[Container, Plate, "Fake plate 2 for ValidExperimentAliquotQ tests"],
					Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (200 uL)"],
					Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.5 mL)"],
					Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.5 mL, 5 mM)"],
					Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.8 mL)"],
					Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.8 mL, 3 mM)"],
					Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.5 mL, 5 mg / mL)"],
					Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (1.8 mL, 3 mg / mL)"],
					Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (25 mL)"],
					Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (10 mL)"],
					Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (no volume)"],
					Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (5 mL)"],
					Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (3 mL)"],
					Object[Sample, "ValidExperimentAliquotQ New Test Chemical 1 (Discarded)"]
				};
				existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
				EraseObject[existingObjs, Force -> True, Verbose -> False]
			]
		}
	)
];


(* ::Subsection::Closed:: *)
(*ExperimentAliquotOptions*)


DefineTests[ExperimentAliquotOptions,
	{
		Example[{Basic,"Aliquot the full volume of a sample into a new container of the preferred container for the volume:"},
			ExperimentAliquotOptions[Object[Sample,"ExperimentAliquotOptions New Test Chemical 1 (200 uL)" <> $SessionUUID], All],
			_Grid,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic,"Aliquot a specific volume of a sample into a new container:"},
			ExperimentAliquotOptions[Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (1.5 mL)" <> $SessionUUID], 1 Milliliter, ContainerOut -> Model[Container, Vessel, "2mL Tube"]],
			_Grid,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic,"Dilute a sample to a new target concentration:"},
			ExperimentAliquotOptions[Object[Sample,"ExperimentAliquotOptions New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID], 50 Micromolar],
			_Grid,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional, "Containers", "Aliquot the full volume of a all the samples into a new container of the same type as the sample's current container:"},
			ExperimentAliquotOptions[Object[Container,Vessel,"Fake container 1 for ExperimentAliquotOptions tests" <> $SessionUUID]],
			_Grid,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional, "Containers", "Aliquot a specific volume of the sample(s) in a specified container into a new container:"},
			ExperimentAliquotOptions[Object[Container,Vessel,"Fake container 2 for ExperimentAliquotOptions tests" <> $SessionUUID], 1 Milliliter, ContainerOut -> Model[Container, Vessel, "2mL Tube"]],
			_Grid,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional, "Containers", "Dilute the sample(s) in a given container to a new target concentration:"},
			ExperimentAliquotOptions[Object[Container,Vessel,"Fake container 3 for ExperimentAliquotOptions tests" <> $SessionUUID], 50 Micromolar],
			_Grid,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"Aliquot a specific volume of multiple samples into a new container:"},
			options = ExperimentAliquotOptions[{Object[Sample,"ExperimentAliquotOptions New Test Chemical 1 (1.5 mL)" <> $SessionUUID],Object[Sample,"ExperimentAliquotOptions New Test Chemical 1 (1.8 mL)" <> $SessionUUID]},{200 Microliter,200 Microliter},ContainerOut->Model[Container,Plate,"96-well 2mL Deep Well Plate"], OutputFormat -> List];
			Lookup[options, ContainerOut],
			{
				{1, ObjectP[Model[Container,Plate,"96-well 2mL Deep Well Plate"]]},
				{1, ObjectP[Model[Container,Plate,"96-well 2mL Deep Well Plate"]]}
			},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			Variables :> {options}
		],
		Example[{Additional,"If aliquoting the same sample multiple times, resolve aliquot volume to be the total volume divided across the number of duplicates:"},
			options = ExperimentAliquotOptions[{Object[Sample,"ExperimentAliquotOptions New Test Chemical 1 (1.5 mL)" <> $SessionUUID],Object[Sample,"ExperimentAliquotOptions New Test Chemical 1 (1.5 mL)" <> $SessionUUID], Object[Sample,"ExperimentAliquotOptions New Test Chemical 1 (1.5 mL)" <> $SessionUUID]},OutputFormat -> List];
			Lookup[options, Amount],
			500*Microliter,
			EquivalenceFunction -> Equal,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			Variables :> {options}
		],
		Example[{Additional,"Aliquot the same volume from multiple source samples:"},
			options = ExperimentAliquotOptions[{Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (1.5 mL)" <> $SessionUUID], Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (1.8 mL)" <> $SessionUUID]}, 200 Microliter, OutputFormat -> List];
			Lookup[options, Amount],
			{200*Microliter, 200*Microliter},
			EquivalenceFunction -> Equal,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			Variables :> {options}
		],
		Example[{Additional,"Dilute multiple samples to the same target concentration:"},
			options = ExperimentAliquotOptions[{Object[Sample,"ExperimentAliquotOptions New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID], Object[Sample,"ExperimentAliquotOptions New Test Chemical 1 (1.8 mL, 3 mM)" <> $SessionUUID]}, 10 Micromolar, OutputFormat -> List];
			Lookup[options, TargetConcentration],
			{10*Micromolar, 10*Micromolar},
			EquivalenceFunction -> Equal,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			Variables :> {options}
		],

		Example[{Additional,"Dilute multiple samples to the same target mass concentration:"},
			options = ExperimentAliquotOptions[{Object[Sample,"ExperimentAliquotOptions New Test Chemical 1 (1.5 mL, 5 mg / mL)" <> $SessionUUID], Object[Sample,"ExperimentAliquotOptions New Test Chemical 1 (1.8 mL, 3 mg / mL)" <> $SessionUUID]}, 1*(Milligram/Milliliter), OutputFormat -> List];
			Lookup[options, TargetConcentration],
			{1*(Milligram/Milliliter), 1*(Milligram/Milliliter)},
			EquivalenceFunction -> Equal,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			Variables :> {options}
		],

		Example[{Options, OutputFormat, "If OutputFormat -> List, return a list of rules:"},
			ExperimentAliquotOptions[{Object[Sample,"ExperimentAliquotOptions New Test Chemical 1 (1.5 mL, 5 mg / mL)" <> $SessionUUID], Object[Sample,"ExperimentAliquotOptions New Test Chemical 1 (1.8 mL, 3 mg / mL)" <> $SessionUUID]}, 1*(Milligram/Milliliter), OutputFormat -> List],
			{__Rule},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		]
	},
	Stubs :> {
		$EmailEnabled = False
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		{
			Module[
				{allObjs, existingObjs},
				allObjs = {
					Object[Container, Bench, "Fake bench for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Fake container 1 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Fake container 2 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Fake container 3 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Fake container 4 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Fake container 5 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Fake container 6 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Fake container 7 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Fake container 8 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Fake container 9 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Fake container 10 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Fake container 11 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Fake container 12 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Fake container 13 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Plate, "Fake plate 1 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Plate, "Fake plate 2 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (200 uL)" <> $SessionUUID],
					Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID],
					Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (1.8 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (1.8 mL, 3 mM)" <> $SessionUUID],
					Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (1.5 mL, 5 mg / mL)" <> $SessionUUID],
					Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (1.8 mL, 3 mg / mL)" <> $SessionUUID],
					Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (25 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (10 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (no volume)" <> $SessionUUID],
					Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (5 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (3 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (Discarded)" <> $SessionUUID]
				};
				existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
				EraseObject[existingObjs, Force -> True, Verbose -> False]
			],
			Module[
				{
					fakeBench,
					container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11, container12, container13, plate1, plate2,
					sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12, sample13,

					allObjs
				},

				fakeBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Fake bench for ExperimentAliquotOptions tests" <> $SessionUUID,DeveloperObject->True|>];
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
					plate1,
					plate2
				}=UploadSample[
					{
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Vessel,"2mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"]
					},
					{
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench}
					},
					Status->{
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
					Name->{
						"Fake container 1 for ExperimentAliquotOptions tests" <> $SessionUUID,
						"Fake container 2 for ExperimentAliquotOptions tests" <> $SessionUUID,
						"Fake container 3 for ExperimentAliquotOptions tests" <> $SessionUUID,
						"Fake container 4 for ExperimentAliquotOptions tests" <> $SessionUUID,
						"Fake container 5 for ExperimentAliquotOptions tests" <> $SessionUUID,
						"Fake container 6 for ExperimentAliquotOptions tests" <> $SessionUUID,
						"Fake container 7 for ExperimentAliquotOptions tests" <> $SessionUUID,
						"Fake container 8 for ExperimentAliquotOptions tests" <> $SessionUUID,
						"Fake container 9 for ExperimentAliquotOptions tests" <> $SessionUUID,
						"Fake container 10 for ExperimentAliquotOptions tests" <> $SessionUUID,
						"Fake container 11 for ExperimentAliquotOptions tests" <> $SessionUUID,
						"Fake container 12 for ExperimentAliquotOptions tests" <> $SessionUUID,
						"Fake container 13 for ExperimentAliquotOptions tests" <> $SessionUUID,
						"Fake plate 1 for ExperimentAliquotOptions tests" <> $SessionUUID,
						"Fake plate 2 for ExperimentAliquotOptions tests" <> $SessionUUID
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
					sample13
				}=UploadSample[
					{
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"]
					},
					{
						{"A1",container},
						{"A1",container2},
						{"A1",container3},
						{"A1",container4},
						{"A1",container5},
						{"A1",container6},
						{"A1",container7},
						{"A1",container8},
						{"A1",container9},
						{"A1",container10},
						{"A1",container11},
						{"A1",container12},
						{"A1",container13}
					},
					InitialAmount->{
						200*Microliter,
						1.5*Milliliter,
						1.5*Milliliter,
						1.8*Milliliter,
						1.8*Milliliter,
						1.5*Milliliter,
						1.8*Milliliter,
						25*Milliliter,
						10*Milliliter,
						Null,
						5*Milliliter,
						3*Milliliter,
						1*Milliliter
					},
					Name->{
						"ExperimentAliquotOptions New Test Chemical 1 (200 uL)" <> $SessionUUID,
						"ExperimentAliquotOptions New Test Chemical 1 (1.5 mL)" <> $SessionUUID,
						"ExperimentAliquotOptions New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID,
						"ExperimentAliquotOptions New Test Chemical 1 (1.8 mL)" <> $SessionUUID,
						"ExperimentAliquotOptions New Test Chemical 1 (1.8 mL, 3 mM)" <> $SessionUUID,
						"ExperimentAliquotOptions New Test Chemical 1 (1.5 mL, 5 mg / mL)" <> $SessionUUID,
						"ExperimentAliquotOptions New Test Chemical 1 (1.8 mL, 3 mg / mL)" <> $SessionUUID,
						"ExperimentAliquotOptions New Test Chemical 1 (25 mL)" <> $SessionUUID,
						"ExperimentAliquotOptions New Test Chemical 1 (10 mL)" <> $SessionUUID,
						"ExperimentAliquotOptions New Test Chemical 1 (no volume)" <> $SessionUUID,
						"ExperimentAliquotOptions New Test Chemical 1 (5 mL)" <> $SessionUUID,
						"ExperimentAliquotOptions New Test Chemical 1 (3 mL)" <> $SessionUUID,
						"ExperimentAliquotOptions New Test Chemical 1 (Discarded)" <> $SessionUUID
					}
				];


				allObjs = {
					container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11, container12, container13,
					sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12, sample13,
					plate1, plate2
				};

				Upload[Flatten[{
					<|Object->#,DeveloperObject->True|>&/@allObjs,
					<|
						Object -> sample3,
						Concentration -> 5*Millimolar,
						Replace[Composition] -> {
							{5 Millimolar, Link[Model[Molecule, "Methylamine"]]},
							{100 VolumePercent, Link[Model[Molecule, "Water"]]}
						}
					|>,
					<|
						Object -> sample5,
						Concentration -> 3*Millimolar,
						Replace[Composition] -> {
							{3 Millimolar, Link[Model[Molecule, "Methylamine"]]},
							{100 VolumePercent, Link[Model[Molecule, "Water"]]}
						}
					|>,
					<|
						Object -> sample6,
						MassConcentration -> 5*(Milligram/Milliliter),
						Replace[Composition] -> {
							{5 Milligram/Milliliter, Link[Model[Molecule, "Methylamine"]]},
							{100 VolumePercent, Link[Model[Molecule, "Water"]]}
						}
					|>,
					<|
						Object -> sample7,
						MassConcentration -> 3*(Milligram/Milliliter),
						Replace[Composition] -> {
							{3 Milligram/Milliliter, Link[Model[Molecule, "Methylamine"]]},
							{100 VolumePercent, Link[Model[Molecule, "Water"]]}
						}
					|>
				}]];
				UploadSampleStatus[sample13, Discarded, FastTrack -> True]

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
					Object[Container, Bench, "Fake bench for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Fake container 1 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Fake container 2 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Fake container 3 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Fake container 4 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Fake container 5 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Fake container 6 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Fake container 7 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Fake container 8 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Fake container 9 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Fake container 10 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Fake container 11 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Fake container 12 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Fake container 13 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Plate, "Fake plate 1 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Container, Plate, "Fake plate 2 for ExperimentAliquotOptions tests" <> $SessionUUID],
					Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (200 uL)" <> $SessionUUID],
					Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID],
					Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (1.8 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (1.8 mL, 3 mM)" <> $SessionUUID],
					Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (1.5 mL, 5 mg / mL)" <> $SessionUUID],
					Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (1.8 mL, 3 mg / mL)" <> $SessionUUID],
					Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (25 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (10 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (no volume)" <> $SessionUUID],
					Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (5 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (3 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentAliquotOptions New Test Chemical 1 (Discarded)" <> $SessionUUID]
				};
				existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
				EraseObject[existingObjs, Force -> True, Verbose -> False]
			]
		}
	)
];


(* ::Subsection::Closed:: *)
(*ExperimentAliquotPreview*)


DefineTests[ExperimentAliquotPreview,
	{
		Example[{Basic, "Returns Null when called on one sample with quantitative transfer:"},
			ExperimentAliquotPreview[Object[Sample, "ExperimentAliquotPreview New Test Chemical 1 (200 uL)"], All],
			Null
		],
		Example[{Basic, "Returns Null when called on multiple samples:"},
			ExperimentAliquotPreview[{Object[Sample, "ExperimentAliquotPreview New Test Chemical 1 (200 uL)"], Object[Sample, "ExperimentAliquotPreview New Test Chemical 2 (200 uL)"], Object[Sample, "ExperimentAliquotPreview New Test Chemical 3 (200 uL)"]}, 100 Microliter],
			Null
		],
		Example[{Basic, "Returns Null if diluting a sample to a target concentration:"},
			ExperimentAliquotPreview[Object[Sample, "ExperimentAliquotPreview New Test Chemical 3 (200 uL)"], 1000 Micromolar, AssayVolume -> 200 Microliter, AssayBuffer -> Model[Sample, StockSolution, "70% Ethanol"]],
			Null
		]
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		{
			Module[
				{allObjs, existingObjs},
				allObjs = {
					Object[Container, Bench, "Fake bench for ExperimentAliquotPreview tests"],
					Object[Container, Vessel, "Fake container 1 for ExperimentAliquotPreview tests"],
					Object[Container, Plate, "Fake plate 1 for ExperimentAliquotPreview tests"],
					Object[Container, Plate, "Fake plate 2 for ExperimentAliquotPreview tests"],
					Object[Sample, "ExperimentAliquotPreview New Test Chemical 1 (200 uL)"],
					Object[Sample, "ExperimentAliquotPreview New Test Chemical 2 (200 uL)"],
					Object[Sample, "ExperimentAliquotPreview New Test Chemical 3 (200 uL)"]
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

				fakeBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Fake bench for ExperimentAliquotPreview tests",DeveloperObject->True|>];
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
						"Fake container 1 for ExperimentAliquotPreview tests",
						"Fake plate 1 for ExperimentAliquotPreview tests",
						"Fake plate 2 for ExperimentAliquotPreview tests"
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
						"ExperimentAliquotPreview New Test Chemical 1 (200 uL)",
						"ExperimentAliquotPreview New Test Chemical 2 (200 uL)",
						"ExperimentAliquotPreview New Test Chemical 3 (200 uL)"
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
							{5 Millimolar, Link[Model[Molecule, "Methylamine"]]},
							{100 VolumePercent, Link[Model[Molecule, "Water"]]}
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
					Object[Container, Bench, "Fake bench for ExperimentAliquotPreview tests"],
					Object[Container, Vessel, "Fake container 1 for ExperimentAliquotPreview tests"],
					Object[Container, Plate, "Fake plate 1 for ExperimentAliquotPreview tests"],
					Object[Container, Plate, "Fake plate 2 for ExperimentAliquotPreview tests"],
					Object[Sample, "ExperimentAliquotPreview New Test Chemical 1 (200 uL)"],
					Object[Sample, "ExperimentAliquotPreview New Test Chemical 2 (200 uL)"],
					Object[Sample, "ExperimentAliquotPreview New Test Chemical 3 (200 uL)"]
				};
				existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
				EraseObject[existingObjs, Force -> True, Verbose -> False]
			]
		}
	)
];
