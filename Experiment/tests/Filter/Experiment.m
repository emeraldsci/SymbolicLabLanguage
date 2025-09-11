(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*ExperimentFilter*)


DefineTests[ExperimentFilter,
	{
		(* ===Basic===*)
		Example[{Basic, "Sample with volumes larger than 50mL will be filtered using a peristaltic pump and a filter housing:"},
			Lookup[
				ExperimentFilter[Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID], Output -> Options],
				{Instrument, FiltrationType}
			],
			{ObjectP[Model[Instrument, PeristalticPump]], PeristalticPump}
		],
		Test["Samples with volumes larger than 50mL will be filtered using a peristaltic pump and a filter housing:", 
			Download[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID],
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
				],
				{Instruments, FiltrationTypes}
			],
			{{ObjectP[Model[Instrument, PeristalticPump]]}, {PeristalticPump}}
		],
		Example[{Basic, "Sample with volumes between 50mL and 4L will be filtered using vacuum pump and a bottle top vacuum cap if Sterile has been specified True:"},
			Lookup[
				ExperimentFilter[Object[Sample, "Filter Test Sample with 2L" <> $SessionUUID], Sterile -> True, Output -> Options],
				{Instrument, FiltrationType}
			],
			{ObjectP[Model[Instrument, VacuumPump]], Vacuum}
		],
		Test["Sample with volumes between 50mL and 4L will be filtered using vacuum pump and a bottle top vacuum cap if Sterile has been specified True:", 
			Download[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 2L" <> $SessionUUID],
					Sterile -> True,
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
				],
				{Instruments, FiltrationTypes}
			],
			{{ObjectP[Model[Instrument, VacuumPump]]}, {Vacuum}}
		],
		Example[{Basic, "Samples with volumes between 2 and 50 milliliters will be filtered using a syringe and syringe filter:"},
			Lookup[
				ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], Output -> Options],
				{Instrument, FiltrationType}
			],
			{ObjectP[Model[Instrument, SyringePump]], Syringe}
		],
		Test[
			"Samples with volumes between 2 and 50 milliliters will be filtered using a syringe and syringe filter:", 
			Download[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID],
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
				],
				{Instruments, FiltrationTypes}
			],
			{{ObjectP[Model[Instrument, SyringePump]]}, {Syringe}}
		],
		Example[{Basic, "Sample with volumes smaller than 2mL will be filtered using a centrifuge and a centrifuge filter:"},
			Lookup[
				ExperimentFilter[Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Output -> Options],
				{Instrument, FiltrationType}
			],
			{ObjectP[Model[Instrument, Centrifuge]], Centrifuge}
		],
		Test[
			"A sample less than 2mL will be filtered using a centrifuge and a centrifuge filter:", 
			Download[
				ExperimentFilter[Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]],
				{Instruments, FiltrationTypes}
			],
			{{ObjectP[Model[Instrument, Centrifuge]]}, {Centrifuge}}
		],
		Example[{Basic, "Sample with no model can be filtered:"},
			ExperimentFilter[Object[Sample, "Filter Test Sample with 3L (no model) (III)" <> $SessionUUID]],
			ObjectP[Object[Protocol]]
		],
		Example[{Basic, "If given a Model[Sample] as the input, populate PreparatoryUnitOperations to create it and use it in this experiment:"},
			ExperimentFilter[Model[Sample, "Milli-Q water"]],
			ObjectP[Object[Protocol]]
		],
		(* ===Additional=== *)
		Example[{Additional, "Input {Position, Container}:"},
			ExperimentFilter[{"A1", Object[Container, Vessel, "Filter Test Container for 1mL sample" <> $SessionUUID]}],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Additional, "Input a mixture of {Position, Container} and Samples"},
			ExperimentFilter[{{"A1", Object[Container, Vessel, "Filter Test Container for 1mL sample" <> $SessionUUID]}, Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID]}],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Additional, "Samples with small volumes (as dictated by the MaxVolume of the filter being used) can also be filtered using a filter block:"},
			Lookup[
				ExperimentFilter[Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],FiltrationType->Vacuum, Output -> Options],
				{Instrument, FilterHousing, FiltrationType}
			],
			{ObjectP[Model[Instrument, VacuumPump]], ObjectP[Model[Instrument, FilterBlock]], Vacuum}
		],
		Example[{Additional, "Filtering with BottleTop filters with a collection vessel already in place:"},
			protocol = ExperimentFilter[
				Object[Sample, "Filter Test Sample with 500 mL" <> $SessionUUID],
				Filter -> Model[Container, Vessel, Filter, "id:KBL5DvYOxMWa"],
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
			]; (*filter with a Destination container and kitted*)
			{containersOut, requiredResource} = Download[protocol, {ContainersOut, RequiredResources}];
			(*make sure that we're NOT updating the ContainersOut in RequiredResources. This will be done later by an execute task in the procedure*)
			{First@containersOut, Length[Cases[requiredResource, {_, ContainersOut, _, _}]]},
			{ObjectP[Model[Container, Vessel]], 0},
			Variables :> {protocol, containersOut, requiredResource}
		],
		(*the following example is for the Sample Manipulation filter primitives.*)
		Example[{Additional, "Filtering with BottleTop filters but with the sample already within the top of the two-part filter:"},
			protocol = ExperimentFilter[
				Object[Sample, "Filter Test Sample with 500 mL (II)" <> $SessionUUID],
				FiltrationType -> Vacuum,
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
			];
			(*make sure that the container out is the bottom receptacle container*)
			First@Download[protocol, ContainersOut],
			ObjectP[Object[Container, Vessel, "Filter Test two-part filter (bottom portion)" <> $SessionUUID]],
			Variables :> {protocol}
		],
		Example[{Additional, "Filtering with BottleTop filters with a collection vessel already in place but specify a different container out:"},
			protocol = ExperimentFilter[
				Object[Sample, "Filter Test Sample with 500 mL" <> $SessionUUID],
				Filter -> Model[Container, Vessel, Filter, "id:KBL5DvYOxMWa"],
				FiltrateContainerOut-> Model[Container, Vessel, "id:aXRlGnZmOONB"],
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
			]; (*filter with a Destination container*)
			{containersOut, requiredResource} = Download[protocol, {ContainersOut, RequiredResources}];
			{First@containersOut, Length[Cases[requiredResource, {_, ContainersOut, _, _}]]},
			{ObjectP[Model[Container, Vessel]], 1},
			Variables :> {protocol, containersOut, requiredResource}
		],
		Example[{Additional, "Filtering with filters that are part of a kit but not BottleTop filters works properly:"},
			protocol = ExperimentFilter[
				Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID],
				Filter -> Model[Container, Vessel, Filter, "id:Vrbp1jKOVYkO"],
				AliquotAmount -> 0.5 Milliliter
			];
			{containersOut, requiredResource} = Download[protocol, {ContainersOut, RequiredResources}];
			{First@containersOut, Length[Cases[requiredResource, {_, ContainersOut, _, _}]]},
			{ObjectP[Model[Container, Vessel]], 0},
			Variables :> {protocol, containersOut, requiredResource}
		],
		Example[{Additional, "Filtering with BottleTop filters WITHOUT a collection vessel already in place:"},
			protocol = ExperimentFilter[Object[Sample, "Filter Test Sample with 500 mL" <> $SessionUUID], ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID], Filter -> Model[Container, Vessel, Filter, "id:AEqRl9KmXnad"]]; (*filter without a destination container*)
			{containersOut, requiredResource} = Download[protocol, {ContainersOut, RequiredResources}];
			{First@containersOut, Length[Cases[requiredResource, {_, ContainersOut, _, _}]]},
			{ObjectP[Model[Container, Vessel]], 1},
			Variables :> {protocol, containersOut, requiredResource}
		],
		Example[{Additional, "Filtering with BottleTop filters WITHOUT a collection vessel already in place (sterile):"},
			protocol = ExperimentFilter[Object[Sample, "Filter Test Sample with 500 mL" <> $SessionUUID],ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID],Filter -> Model[Container, Vessel, Filter, "id:AEqRl9KmXnad"],Sterile -> True];
			{containersOut, requiredResource} = Download[protocol, {ContainersOut, RequiredResources}];
			{First@containersOut,Length[Cases[requiredResource, {_, ContainersOut, _, _}]]},
			{ObjectP[Model[Container, Vessel]], 1},
			Variables :> {protocol, containersOut, requiredResource}
		],
		Example[{Additional, "Filtering with vessels that have a top and bottom piece and the bottom piece is also the FiltrateContainerOut, but not a BottleTop kit:"},
			protocol = ExperimentFilter[
				Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID],
				Filter -> Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 7K MWCO, 2 mL"]
			];
			{containersOut, requiredResource} = Download[protocol, {ContainersOut, RequiredResources}];
			{First@containersOut,Length[Cases[requiredResource, {_, ContainersOut, _, _}]]},
			{ObjectP[Model[Container, Vessel]], 1},
			Variables :> {protocol, containersOut, requiredResource}
		],
		Example[{Additional, "Filtering with Buchner funnels popualtes relevant fields with it:"},
			protocol = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID], Filter -> Model[Item, Filter, "Whatman Grade 5 Filter Paper, Cellulose, 2.5um, 42.5mm"], FiltrationType -> Vacuum];
			Download[protocol, BatchedUnitOperations[[1]][{BuchnerFunnel, FilterAdapter, VacuumTubing, SchlenkLine}]],
			{
				{ObjectP[Model[Part, Funnel]]},
				{ObjectP[Model[Part, FilterAdapter]]},
				ObjectP[Model[Plumbing, Tubing]],
				ObjectP[Model[Instrument, SchlenkLine]]
			},
			Variables :> {protocol}
		],
		Example[{Additional, "Make sure that we can produce a protocol with Preparation->Robotic with Centrifuge:"},
			ExperimentFilter[
				Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
				Volume -> 300 Microliter,
				Preparation -> Robotic
			],
			ObjectP[Object[Protocol]]
		],
		Example[{Additional, "Make sure that we can produce a protocol with Preparation->Robotic with AirPressure:"},
			ExperimentFilter[
				Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
				Preparation -> Robotic
			],
			ObjectP[Object[Protocol]]
		],
		Test["We can produce an RSP filter protocol using VSpin:", 
			Download[
				ExperimentFilter[{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID]},
					Volume -> 300 Microliter,
					Preparation -> Robotic,
					FiltrationType -> Centrifuge
				],
				{
					Object,
					CalculatedUnitOperations[Instrument]
				}
			],
			{
				ObjectP[Object[Protocol, RoboticSamplePreparation]],
				{{LinkP[Model[Instrument, Centrifuge, "VSpin"]]},__}
			}
		],
		Test["We can produce an RCP filter protocol using HiG:", 
			Download[
				ExperimentFilter[{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID]},
					Volume -> 300 Microliter,
					Preparation -> Robotic,
					FiltrationType -> Centrifuge,
					WorkCell -> bioSTAR
				],
				{
					Object,
					CalculatedUnitOperations[Instrument]
				}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				{{LinkP[Model[Instrument, Centrifuge, "HiG4"]]},__}
			}

		],
		Test["Choosing plates that will result in a too-tall filter stack does not work with Preparation->Robotic:", 
			ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID]},
				Filter -> Model[Container, Plate, Filter, "Plate Filter, GlassFiber, 30.0um, 2mL"],
				CollectionContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Preparation -> Robotic,
				FiltrationType -> Centrifuge,
				WorkCell -> bioSTAR
			],
			$Failed,
			Messages :> {Error::NoUsableCentrifuge, Error::InvalidOption, Warning::SterileContainerRecommended},
			Stubs :> {$DeveloperSearch = False}
		],
		Test["Choosing plates that will result in a too-tall filter stack does not work with Preparation->Robotic, even if the centrifuge is specified:", 
			ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID]},
				Filter -> Model[Container, Plate, Filter, "Plate Filter, GlassFiber, 30.0um, 2mL"],
				CollectionContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Preparation -> Robotic,
				FiltrationType -> Centrifuge,
				Instrument-> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],
				WorkCell -> bioSTAR
			],
			$Failed,
			Messages :> {Error::NoUsableCentrifuge, Error::UnusableCentrifuge, Error::InvalidOption, Warning::SterileContainerRecommended},
			Stubs :> {$DeveloperSearch = False}
		],
		Test["Choosing filters that just barely work with the HiG's stack height works on HiG:", 
			Download[
				ExperimentFilter[{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID]},
					Filter -> Model[Container, Plate, Filter, "Plate Filter, PES, 0.22um, 0.3mL"],
					Volume -> 0.3 Milliliter,
					CollectionContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Preparation -> Robotic,
					FiltrationType -> Centrifuge,
					WorkCell -> bioSTAR
				],
				CalculatedUnitOperations[Instrument]
			],
			{{LinkP[Model[Instrument, Centrifuge, "HiG4"]]}, __},
			Stubs :> {$DeveloperSearch = False},
			Messages :> {Warning::SterileContainerRecommended}

		],
		Test["Choosing collection container without TareWeight yields an error:", 
			Download[
				ExperimentFilter[{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID]},
					Filter -> Model[Container, Plate, Filter, "Plate Filter, PES, 0.22um, 0.3mL"],
					Volume -> 0.3 Milliliter,
					CollectionContainer -> Model[Container, Plate, "Filter Test plate model without TareWeight"<>$SessionUUID],
					Preparation -> Robotic,
					FiltrationType -> Centrifuge,
					WorkCell -> bioSTAR
				],
				CalculatedUnitOperations[Instrument]
			],
			$Failed,
			Stubs :> {$DeveloperSearch = False},
			Messages :> {Warning::SterileContainerRecommended, Error::CollectionContainerNoCounterweights, Error::CollectionContainerPlateMismatch, Error::InvalidOption}
		],
		(* ===Options=== *)
		Example[{Options, Upload, "Indicates if the protocols generated should be placed InCart after execution to be confirmed at a later time:"},
			ExperimentFilter[
				Object[Sample, "Filter Test Sample with 2L" <> $SessionUUID],
				Upload -> False
			],
			{_?(ValidUploadQ[#]&)..}
		],
		Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID],
					ImageSample -> False,
					Output -> Options
				],
				ImageSample
			],
			False
		],
		Example[{Options, MeasureVolume, "Indicate if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
			Download[
				ExperimentFilter[Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID], ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID], MeasureVolume -> False],
				MeasureVolume
			],
			False
		],
		Example[{Options, MeasureWeight, "Indicate if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			Download[
				ExperimentFilter[Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID], ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID], MeasureWeight -> False],
				MeasureWeight
			],
			False
		],
		Example[{Options, Name, "An object name which should be used to refer to the output object in lieu of an automatically generated ID number:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 2L" <> $SessionUUID],
					Name -> "My Favorite Filter Test Protocol", 
					Output -> Options
				],
				Name
			],
			"My Favorite Filter Test Protocol"
		],
		Example[{Options, FiltrationType, "FiltrationType option allows specification of type of filtration to be performed:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 500 mL" <> $SessionUUID],
					FiltrationType -> Vacuum,
					Output -> Options
				],
				FiltrationType
			],
			Vacuum
		],
		Example[{Options, PreparatoryUnitOperations, "Specify prepared samples for measurement:"},
			ExperimentFilter[
				"Container", 
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "Container", 
						Container -> Model[Container, Vessel, "1L Glass Bottle"]
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Amount -> 750 Milliliter,
						Destination -> "Container"
					]
				}, Output -> Options
			],
			{_Rule..}
		],
		Example[{Options, PreparatoryUnitOperations, "Specify prepared samples for measurement that has an MSP parent:"},
			ExperimentFilter[
				"Container", 
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "Container", 
						Container -> Model[Container, Vessel, "1L Glass Bottle"]
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Amount -> 750 Milliliter,
						Destination -> "Container"
					]
				},
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, Filter]]
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentFilter[
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
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared, even if Preparation -> Robotic:"},
			protocol = ExperimentFilter[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Plate, "id:L8kPEjkmLbvW"],
				PreparedModelAmount -> 1 Milliliter,
				Preparation -> Robotic
			];
			Download[protocol, OutputUnitOperations[[1]][{SampleLink, ContainerLink, AmountVariableUnit, Well, ContainerLabel}]],
			{
				{ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]]..},
				{ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]..},
				{EqualP[1 Milliliter]..},
				{"A1", "B1"},
				{_String, _String}
			},
			Variables :> {protocol}
		],
		Test["Samples with small volumes (as dictated by the MaxVolume of the Model[Container, Vessel, Filter] being used) can also be filtered using a centrifuge:", 
			Download[
				ExperimentFilter[Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], FiltrationType -> Vacuum, ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]],
				{Instruments, FilterHousings, FiltrationTypes}
			],
			{{ObjectP[Model[Instrument, VacuumPump]]}, {ObjectP[Model[Instrument, FilterBlock]]}, {Vacuum}}
		],
		Test["If the CollectionContainer and FiltrateContainerOut are the same model, then they will just be the same resource:", 
			protocol = ExperimentFilter[Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], FiltrationType -> Vacuum, ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]];
			requiredResources = Download[protocol, RequiredResources];
			relevantResources = Cases[requiredResources, {_, CollectionContainers | FiltrateContainersOut, _, _}][[All, 1]];
			SameObjectQ @@ relevantResources,
			True,
			Variables :> {protocol, requiredResources, relevantResources}
		],
		Test["If the CollectionContainer and FiltrateContainerOut are the same model, but we're washing retentate and the wash flow through containers are different, the collection container and filtrate container are also different:", 
			protocol = ExperimentFilter[Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], FiltrationType -> Vacuum, AliquotAmount -> 0.5 Milliliter, WashRetentate -> True, FiltrateContainerLabel -> "test container 1", WashFlowThroughContainerLabel -> {{"test container2", "test container 3"}}, ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]];
			requiredResources = Download[protocol, RequiredResources];
			relevantResources = Cases[requiredResources, {_, CollectionContainers | FiltrateContainersOut, _, _}][[All, 1]];
			SameObjectQ @@ relevantResources,
			False,
			Variables :> {protocol, requiredResources, relevantResources}
		],
		Test["The CollectionContainer resources in the protocol object are the same as the resources in the unit operations:", 
			protocol = ExperimentFilter[Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], FiltrationType -> Vacuum, ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]];
			protocolRequiredResources = Download[protocol, RequiredResources];
			relevantProtocolResources = Cases[protocolRequiredResources, {_, CollectionContainers, _, _}][[All, 1]];
			unitOperationRequiredResources = Download[protocol, BatchedUnitOperations[[1]][RequiredResources]];
			relevantUOResources = Cases[unitOperationRequiredResources, {_, CollectionContainerLink, _, _}][[All, 1]];
			SameObjectQ @@ Join[relevantProtocolResources, relevantUOResources],
			True,
			Variables :> {protocol, protocolRequiredResources, relevantProtocolResources, unitOperationRequiredResources, relevantUOResources}
		],
		Test["If the CollectionContainer is an object and we're Centrifuge filtering, make the FiltrateContainerOut resolve to the same value as long as there's enough room:", 
			options = ExperimentFilter[
				Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
				FiltrationType -> Centrifuge,
				Filter -> Model[Container, Plate, Filter, "Plate Filter, Omega 30K MWCO, 350uL"],
				CollectionContainer -> Object[Container, Plate, "CollectionContainer plate 1" <> $SessionUUID],
				AliquotAmount -> 100 Microliter,
				Output -> Options
			];
			Lookup[options, {CollectionContainer, FiltrateContainerOut}],
			{
				ObjectP[Object[Container, Plate, "CollectionContainer plate 1" <> $SessionUUID]],
				{_, ObjectP[Object[Container, Plate, "CollectionContainer plate 1" <> $SessionUUID]]}
			},
			Variables :> {options}
		],
		Example[{Options, SampleLabel, "SampleLabel option labels the input samples; automatically set to a value:"},
			Download[
				ExperimentFilter[
					{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID]},
					SampleLabel -> {"Test Label 1", Automatic},
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
				],
				BatchedUnitOperations[SampleLabel]
			],
			{{"Test Label 1"}, {_String}}
		],
		Example[{Options, SampleContainerLabel, "SampleContainerLabel option labels the input samples; automatically set to a value:"},
			Download[
				ExperimentFilter[
					{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID]},
					SampleContainerLabel -> {"Test Label 2", Automatic},
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
				],
				BatchedUnitOperations[SampleContainerLabel]
			],
			{{"Test Label 2"}, {_String}}
		],
		Example[{Options, FiltrateLabel, "FiltrateLabel option labels the filtrate samples; automatically set to a generated string, or the SampleOutLabel if Target -> Filtrate:"},
			Download[
				ExperimentFilter[
					{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID], Object[Sample, "Filter Test Sample with 3L (II)" <> $SessionUUID]},
					FiltrateLabel -> {"Test Label 1", Automatic, Automatic},
					SampleOutLabel -> {Automatic, "SampleOut Label 1", "SampleOut Label 2"},
					Target -> {Filtrate, Filtrate, Retentate},
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
				],
				BatchedUnitOperations[FiltrateLabel]
			],
			{{"Test Label 1"}, {"SampleOut Label 1", Except["SampleOut Label 2", _String]}}
		],
		Example[{Options, FiltrateContainerLabel, "FiltrateContainerLabel option labels the filtrate sample containers; automatically set to a generated string, or the ContainerOutLabel if Target -> Filtrate:"},
			Download[
				ExperimentFilter[
					{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID], Object[Sample, "Filter Test Sample with 3L (II)" <> $SessionUUID]},
					FiltrateContainerLabel -> {"Test Label 2", Automatic, Automatic},
					ContainerOutLabel -> {Automatic, "ContainerOut Label 1", "ContainerOut Label 2"},
					Target -> {Filtrate, Filtrate, Retentate},
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
				],
				BatchedUnitOperations[FiltrateContainerLabel]
			],
			{{"Test Label 2"}, {"ContainerOut Label 1", Except["ContainerOut Label 2", _String]}}
		],
		Example[{Options, FiltrateContainerLabel, "If the values for FiltrateContainerLabel are the same for two samples then the corresponding indices must be the same in the RetentateContainerOut:"},
			Lookup[
				ExperimentFilter[
					{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
					FiltrateContainerLabel -> {"ContainerOut Label 1", "ContainerOut Label 1"},
					FiltrateContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					AliquotAmount -> {Null, 1.5 Milliliter},
					Output -> Options
				],
				FiltrateContainerOut
			],
			{_Integer, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}
		],
		Example[{Options, FiltrateContainerLabel, "If CollectionContainerLabel is set and the CollectionContainer and FiltrateContainerOut are set (automatically or not) to the same thing, then the FiltrateContainerLabel will be the same as the CollectionContainerLabel:"},
			Lookup[
				ExperimentFilter[
					{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
					CollectionContainerLabel -> {"ContainerOut Label 1", "ContainerOut Label 1"},
					Filter -> Model[Container, Plate, Filter, "Plate Filter, Omega 30K MWCO, 350uL"],
					CollectionContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					AliquotAmount -> {0.2 Milliliter, 0.2 Milliliter},
					Output -> Options
				],
				FiltrateContainerLabel
			],
			"ContainerOut Label 1"
		],
		Test["If multiple filters must be used, the collection container and filtrate container labels must not be resolved to the same values:", 
			(* need to do this tally nonsense because we can't systematically know what the numbers CreateUniqueLabel is going to choose will be since this test could be run in isolation or with other tests in the same evaluation *)
			(* Tally ensures that we have two of one and one of the other *)
			Tally /@ Lookup[
				ExperimentFilter[
					{
						Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
						Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
						Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID]
					},
					AliquotAmount -> 0.2 Milliliter,
					Filter -> Model[Container, Plate, Filter, "Plate Filter, PES, 0.22um, 0.3mL"],
					Intensity -> {500 RPM, 700 RPM, 500 RPM},
					Preparation -> Manual,
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID],
					Output -> Options
				],
				{
					FilterLabel,
					FiltrateContainerLabel,
					CollectionContainerLabel
				}
			],
			{
				{{_?(StringMatchQ[#, "filter" ~~ __]&), 2}, {_?(StringMatchQ[#, "filter" ~~ __]&), 1}},
				{{_?(StringMatchQ[#, "filtrate container" ~~ __]&), 2}, {_?(StringMatchQ[#, "filtrate container" ~~ __]&), 1}},
				{{_?(StringMatchQ[#, "filtrate container" ~~ __]&), 2}, {_?(StringMatchQ[#, "filtrate container" ~~ __]&), 1}}
			}
		],
		Test["If FiltrateContainerOut is set to a Model[Container, Vessel] and DestinationWell is set to A1 and two samples are sharing the same filter plate, this does NOT mean they should share the same FiltrateContainerOut:", 
			Lookup[
				ExperimentFilter[
					{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
					FiltrateContainerOut -> {Model[Container, Vessel, "100 mL Glass Bottle"], Model[Container, Vessel, "100 mL Glass Bottle"]},
					DestinationWell -> {"A1", "A1"},
					Output -> Options
				],
				FiltrateContainerOut
			],
			{
				{1, ObjectP[Model[Container, Vessel, "100 mL Glass Bottle"]]},
				{2, ObjectP[Model[Container, Vessel, "100 mL Glass Bottle"]]}
			}
		],
		Example[{Options, RetentateLabel, "RetentateLabel option labels the retentate samples; automatically set to a generated string if collecting retentate but Target -> Filtrate, or the SampleOutLabel if Target -> Retentate, or Null if not collecting retentate:"},
			Download[
				ExperimentFilter[
					{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID], Object[Sample, "Filter Test Sample with 3L (II)" <> $SessionUUID]},
					RetentateLabel -> {"Test Label 1", Automatic, Automatic, Automatic},
					SampleOutLabel -> {Automatic, "SampleOut Label 1", "SampleOut Label 2", "SampleOut Label 3"},
					Target -> {Filtrate, Filtrate, Retentate, Filtrate},
					CollectRetentate -> {True, False, True, True},
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
				],
				BatchedUnitOperations[RetentateLabel]
			],
			{{"Test Label 1"}, {Null}, {"SampleOut Label 2", Except["SampleOut Label 3", _String]}}
		],
		Example[{Options, RetentateContainerLabel, "RetentateContainerLabel option labels the retentate sample containers; automatically set to a generated string if collecting retentate but Target -> Filtrate, or the ContainerOutLabel if Target -> Retentate, or Null if not collecting retentate:"},
			Download[
				ExperimentFilter[
					{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID], Object[Sample, "Filter Test Sample with 3L (II)" <> $SessionUUID]},
					RetentateContainerLabel -> {"Test Label 2", Automatic, Automatic, Automatic},
					ContainerOutLabel -> {Automatic, "ContainerOut Label 1", "ContainerOut Label 2", "ContainerOut Label 3"},
					Target -> {Filtrate, Filtrate, Retentate, Filtrate},
					CollectRetentate -> {True, False, True, True},
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
				],
				BatchedUnitOperations[RetentateContainerLabel]
			],
			{{"Test Label 2"}, {Null}, {"ContainerOut Label 2", Except["ContainerOut Label 3", _String]}}
		],
		Example[{Options, RetentateContainerLabel, "If the values for RetentateContainerLabel are the same for two samples then the corresponding indices must be the same in the RetentateContainerOut:"},
			Lookup[
				ExperimentFilter[
					{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
					RetentateContainerLabel -> {"ContainerOut Label 1", "ContainerOut Label 1"},
					CollectRetentate -> {True, True},
					RetentateContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Output -> Options
				],
				RetentateContainerOut
			],
			{_Integer, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}
		],
		Example[{Options, SampleOutLabel, "SampleOutLabel option labels the SamplesOut; whether this refers to Retentate or Filtrate dpeends on the Target option:"},
			Download[
				ExperimentFilter[
					{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID], Object[Sample, "Filter Test Sample with 3L (II)" <> $SessionUUID]},
					RetentateLabel -> {"Test Label 1", Automatic, Automatic, Automatic},
					SampleOutLabel -> {Automatic, "SampleOut Label 1", "SampleOut Label 2", "SampleOut Label 3"},
					FiltrateLabel -> {"Test Filtrate Label 1", Automatic, Automatic, Automatic},
					Target -> {Filtrate, Filtrate, Retentate, Filtrate},
					CollectRetentate -> {True, False, True, True},
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
				],
				BatchedUnitOperations[SampleOutLabel]
			],
			{{"Test Filtrate Label 1"}, {"SampleOut Label 1"}, {"SampleOut Label 2", "SampleOut Label 3"}}
		],
		Example[{Options, ContainerOutLabel, "ContainerOutLabel option labels the ContainersOut; whether this refers to Retentate or Filtrate dpeends on the Target option:"},
			Download[
				ExperimentFilter[
					{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID], Object[Sample, "Filter Test Sample with 3L (II)" <> $SessionUUID]},
					RetentateContainerLabel -> {"Test Label 1", Automatic, Automatic, Automatic},
					ContainerOutLabel -> {Automatic, "ContainerOut Label 1", "ContainerOut Label 2", "ContainerOut Label 3"},
					FiltrateContainerLabel -> {"Test Filtrate Label 1", Automatic, Automatic, Automatic},
					Target -> {Filtrate, Filtrate, Retentate, Filtrate},
					CollectRetentate -> {True, False, True, True},
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
				],
				BatchedUnitOperations[ContainerOutLabel]
			],
			{{"Test Filtrate Label 1"}, {"ContainerOut Label 1"}, {"ContainerOut Label 2", "ContainerOut Label 3"}}
		],
		Example[{Options, Target, "Target option indicates whether the filtrate or retentate will become this protocol's SamplesOut:"},
			Download[
				ExperimentFilter[
					{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID], Object[Sample, "Filter Test Sample with 3L (II)" <> $SessionUUID]},
					FiltrateLabel -> {"Test Label 1", Automatic, Automatic},
					SampleOutLabel -> {Automatic, "SampleOut Label 1", "SampleOut Label 2"},
					Target -> {Filtrate, Filtrate, Retentate},
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
				],
				Target
			],
			{Filtrate, Filtrate, Retentate}
		],
		Example[{Options, CollectRetentate, "CollectRetentate option indicates if the retentate ought to be kept or discarded:"},
			Download[
				ExperimentFilter[
					{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID], Object[Sample, "Filter Test Sample with 3L (II)" <> $SessionUUID]},
					FiltrateLabel -> {"Test Label 1", Automatic, Automatic},
					SampleOutLabel -> {Automatic, "SampleOut Label 1", "SampleOut Label 2"},
					Target -> {Filtrate, Filtrate, Retentate},
					CollectRetentate -> {True, False, True},
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
				],
				BatchedUnitOperations[CollectRetentate]
			],
			{{True}, {False, True}}
		],
		Example[{Options, WashRetentate, "WashRetentate option indicates if additional buffer should be sent through the filter to wash the solid that has been retained:"},
			options = ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
				FiltrationType -> Vacuum,
				WashRetentate -> True,
				Output -> Options
			];
			Lookup[options, WashRetentate],
			True,
			Variables :> {options}
		],
		Example[{Options, RetentateWashBuffer, "RetentateWashBuffer option indicates what buffer to send through the filter to wash the solid that has been retained. This may be more than one buffer per sample:"},
			options = ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
				FiltrationType -> Vacuum,
				RetentateWashBuffer -> {
					Model[Sample, "Milli-Q water"],
					{
						Model[Sample, "Acetone, Reagent Grade"],
						Model[Sample, "Milli-Q water"]
					}
				},
				Output -> Options
			];
			Lookup[options, RetentateWashBuffer],
			{
				{ObjectP[Model[Sample, "Milli-Q water"]]},
				{
					ObjectP[Model[Sample, "Acetone, Reagent Grade"]],
					ObjectP[Model[Sample, "Milli-Q water"]]
				}
			},
			Variables :> {options}
		],
		Example[{Options, RetentateWashBuffer, "If doing a one-by-one filtering method, the RetentateWashBuffer field is populated in series since we have to do the washing in series:"},
			protocol = ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 500 mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
				FiltrationType -> Vacuum,
				RetentateWashBuffer -> {
					Model[Sample, StockSolution, "90% methanol"],
					{
						Model[Sample, "Acetone, Reagent Grade"],
						Model[Sample, "Milli-Q water"]
					}
				},
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
			];
			Download[protocol, BatchedUnitOperations[[1]][{WashRetentate, RetentateWashBufferResources, RetentateWashBatchLengths}]],
			{
				{
					True,
					True
				},
				{
					ObjectP[Model[Sample, StockSolution, "90% methanol"]],
					ObjectP[Model[Sample, "Acetone, Reagent Grade"]],
					ObjectP[Model[Sample, "Milli-Q water"]]
				},
				{1, 2}
			},
			Variables :> {protocol},
			TimeConstraint -> 300
		],
		Example[{Options, RetentateWashBuffer, "If doing a parallel filtering method, the RetentateWashBuffer field is populated in parallel since we do each step of washing at the same time:"},
			protocol = ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
				FiltrationType -> Centrifuge,
				AliquotAmount -> 0.6 Milliliter,
				RetentateWashBuffer -> {
					Model[Sample, StockSolution, "90% methanol"],
					{
						Model[Sample, "Acetone, Reagent Grade"],
						Model[Sample, "Milli-Q water"]
					}
				},
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
			];
			Download[protocol, BatchedUnitOperations[[1]][{WashRetentate, RetentateWashBufferResources, RetentateWashBatchLengths}]],
			{
				{
					True,
					True,
					False,
					True
				},
				{
					ObjectP[Model[Sample, StockSolution, "90% methanol"]],
					ObjectP[Model[Sample, "Acetone, Reagent Grade"]],
					Null,
					ObjectP[Model[Sample, "Milli-Q water"]]
				},
				{2, 2}
			},
			Variables :> {protocol},
			TimeConstraint -> 300
		],
		Example[{Options, RetentateWashBufferLabel, "RetentateWashBufferLabel indicates the label of the RetentateWashBuffer:"},
			options = ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
				FiltrationType -> Centrifuge,
				AliquotAmount -> 0.6 Milliliter,
				RetentateWashBuffer -> {
					Model[Sample, StockSolution, "90% methanol"],
					{
						Model[Sample, "Acetone, Reagent Grade"],
						Model[Sample, "Milli-Q water"]
					}
				},
				Output -> Options
			];
			Lookup[options, RetentateWashBufferLabel],
			{
				{_String},
				{_String, _String}
			},
			Variables :> {options}
		],
		Example[{Options, RetentateWashBufferContainerLabel, "RetentateWashBufferContainerLabel indicates the label of the container of RetentateWashBuffer:"},
			options = ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
				FiltrationType -> Centrifuge,
				AliquotAmount -> 0.6 Milliliter,
				RetentateWashBuffer -> {
					Model[Sample, StockSolution, "90% methanol"],
					{
						Model[Sample, "Acetone, Reagent Grade"],
						Model[Sample, "Milli-Q water"]
					}
				},
				Output -> Options
			];
			Lookup[options, RetentateWashBufferContainerLabel],
			{
				{_String},
				{_String, _String}
			},
			Variables :> {options}
		],
		Example[{Options, RetentateWashVolume, "RetentateWashVolume option indicates how much buffer to send through the filter to wash the solid that has been retained. This may be more than one volume per sample:"},
			options = ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
				FiltrationType -> Vacuum,
				RetentateWashBuffer -> {
					Model[Sample, "Milli-Q water"],
					{
						Model[Sample, "Acetone, Reagent Grade"],
						Model[Sample, "Milli-Q water"]
					}
				},
				RetentateWashVolume -> {
					0.3 Milliliter,
					{
						0.1 Milliliter,
						0.1 Milliliter
					}
				},
				Output -> Options
			];
			Lookup[options, RetentateWashVolume],
			{
				{EqualP[0.3 Milliliter]},
				{
					EqualP[0.1 Milliliter],
					EqualP[0.1 Milliliter]
				}
			},
			Variables :> {options}
		],
		Example[{Options, NumberOfRetentateWashes, "NumberOfRetentateWashes option indicates how many times per buffer that the buffer should be sent through the filter to wash the solid that has been retained:"},
			options = ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
				FiltrationType -> Vacuum,
				RetentateWashBuffer -> {
					Model[Sample, "Milli-Q water"],
					{
						Model[Sample, "Acetone, Reagent Grade"],
						Model[Sample, "Milli-Q water"]
					}
				},
				NumberOfRetentateWashes -> {
					2,
					{
						1,
						1
					}
				},
				RetentateWashVolume -> {
					0.1 Milliliter,
					{
						0.1 Milliliter,
						0.1 Milliliter
					}
				},
				Output -> Options
			];
			Lookup[options, NumberOfRetentateWashes],
			{
				{EqualP[2]},
				{
					EqualP[1],
					EqualP[1]
				}
			},
			Variables :> {options}
		],
		Example[{Options, NumberOfRetentateWashes, "Manual retentate washing works with multiple retentate washes for one sample:"},
			ExperimentFilter[
				Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
				FiltrationType -> Centrifuge,
				AliquotAmount -> 300 Microliter,
				Preparation -> Manual,
				NumberOfRetentateWashes -> 3,
				Filter -> Model[Container, Plate, Filter, "Plate Filter, Omega 3K MWCO, 350uL"],
				Target -> Retentate,
				CollectRetentate -> True,
				RetentateContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				FiltrateContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				ResuspensionVolume -> 250 Microliter,
				Intensity -> 1500 GravitationalAcceleration,
				Time -> 45 Minute,
				WashRetentate -> True,
				RetentateWashVolume -> 50 Microliter,
				RetentateWashDrainTime -> 15 Minute,
				Centrifuge -> True
			],
			ObjectP[Object[Protocol, Filter]]
		],
		Example[{Options, NumberOfRetentateWashes, "Manual retentate washing works with multiple retentate washes for multiple samples:"},
			ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID]},
				AliquotAmount -> {0.2 Milliliter, 0.2 Milliliter},
				Preparation -> Manual,
				FiltrationType -> Centrifuge,
				RetentateWashBuffer -> {
					Model[Sample, "Milli-Q water"],
					{
						Model[Sample, "Acetone, Reagent Grade"],
						Model[Sample, "Milli-Q water"]
					}
				},
				NumberOfRetentateWashes -> {
					2,
					{
						2,
						1
					}
				},
				RetentateWashVolume -> {
					0.01 Milliliter,
					{
						0.01 Milliliter,
						0.01 Milliliter
					}
				},
				WashFlowThroughContainer -> {
					Automatic,
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"]
					}
				},
				FiltrateLabel -> {
					"filtrate sample 1", 
					"filtrate sample 2"
				},
				WashFlowThroughLabel -> {
					Automatic,
					{
						"wash flow through 1", 
						"wash flow through 2"
					}
				},
				ResuspensionVolume -> 0.1 Milliliter
			],
			ObjectP[Object[Protocol, Filter]],
			TimeConstraint -> 300
		],
		Example[{Options, NumberOfRetentateWashes, "Robotic retentate washing works with multiple retentate washes for multiple samples:"},
			ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID]},
				Volume -> {0.2 Milliliter, 0.2 Milliliter},
				Preparation -> Robotic,
				FiltrationType -> Centrifuge,
				RetentateWashBuffer -> {
					Model[Sample, "Milli-Q water"],
					{
						Model[Sample, "Acetone, Reagent Grade"],
						Model[Sample, "Milli-Q water"]
					}
				},
				NumberOfRetentateWashes -> {
					2,
					{
						2,
						1
					}
				},
				RetentateWashVolume -> {
					0.01 Milliliter,
					{
						0.01 Milliliter,
						0.01 Milliliter
					}
				},
				WashFlowThroughContainer -> {
					Automatic,
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"]
					}
				},
				FiltrateLabel -> {
					"filtrate sample 1", 
					"filtrate sample 2"
				},
				WashFlowThroughLabel -> {
					Automatic,
					{
						"wash flow through 1", 
						"wash flow through 2"
					}
				},
				ResuspensionVolume -> 0.1 Milliliter
			],
			ObjectP[Object[Protocol, RoboticSamplePreparation]],
			TimeConstraint -> 450
		],
		Example[{Options, NumberOfRetentateWashes, "Robotic retentate washing works with multiple retentate washes for one sample:"},
			ExperimentFilter[
				Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
				FiltrationType -> Centrifuge,
				Volume -> 300 Microliter,
				Preparation -> Robotic,
				NumberOfRetentateWashes -> 3,
				Filter -> Model[Container, Plate, Filter, "Plate Filter, Omega 3K MWCO, 350uL"],
				Target -> Retentate,
				CollectRetentate -> True,
				RetentateContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				FiltrateContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				ResuspensionVolume -> 250 Microliter,
				Intensity -> 1000 GravitationalAcceleration,
				Time -> 45 Minute,
				WashRetentate -> True,
				RetentateWashVolume -> 50 Microliter,
				RetentateWashDrainTime -> 15 Minute,
				Centrifuge -> True
			],
			ObjectP[Object[Protocol, RoboticSamplePreparation]]
		],
		Test["Populate the NumberOfResuspensionTADMCurves, NumberOfLoadingTADMCurves, and NumberOfRetentateWashTADMCurves fields in the OutputUnitOperations:", 
			protocol = ExperimentFilter[
				{
					Object[Sample, "Filter Sample 1 in filter plate 2" <> $SessionUUID],
					Object[Sample, "Filter Sample 2 in filter plate 2" <> $SessionUUID],
					Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
					Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]
				},
				CollectRetentate -> {
					True,
					False,
					True,
					True
				},
				RetentateWashBuffer -> {
					Automatic,
					{Model[Sample, "Acetone, Reagent Grade"], Model[Sample, "Milli-Q water"]},
					Automatic,
					{Model[Sample, "Milli-Q water"]}
				},
				RetentateWashVolume -> {
					Automatic,
					{0.1 Milliliter, 0.1 Milliliter},
					Automatic,
					{0.1 Milliliter}
				},
				Volume -> {Automatic, Automatic, Automatic, 0.2 Milliliter},
				FiltrateContainerOut -> {
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "2mL Tube"]
				},
				WashFlowThroughContainer -> {
					Automatic,
					{Model[Container, Plate, "96-well 2mL Deep Well Plate"], Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
					Automatic,
					{Model[Container, Plate, "96-well 2mL Deep Well Plate"]}
				},
				FilterLabel -> {
					"filter 1", 
					"filter 1", 
					"filter 2", 
					"filter 2"
				},
				CollectionContainerLabel -> {
					"collection container 1", 
					"collection container 1", 
					"collection container 2", 
					"collection container 2"
				},
				WashFlowThroughContainerLabel -> {
					Automatic,
					{"plate 1", "plate 1"},
					Automatic,
					{"plate 2"}
				},
				Preparation -> Robotic
			];
			Download[protocol, OutputUnitOperations[[1]][{NumberOfLoadingTADMCurves, NumberOfRetentateWashTADMCurves, NumberOfResuspensionTADMCurves}]],
			{
				{4, 4, 8, 4},
				{0, 8, 0, 4},
				{4, 0, 8, 4}
			},
			Variables :> {protocol}
		],
		Test["Populate the correct number of tips in the output unit operations:", 
			protocol = ExperimentFilter[
				{
					Object[Sample, "Filter Sample 1 in filter plate 2" <> $SessionUUID],
					Object[Sample, "Filter Sample 2 in filter plate 2" <> $SessionUUID],
					Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
					Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]
				},
				CollectRetentate -> {
					True,
					False,
					True,
					True
				},
				RetentateWashBuffer -> {
					Automatic,
					{Model[Sample, "Acetone, Reagent Grade"], Model[Sample, "Milli-Q water"]},
					Automatic,
					{Model[Sample, "Milli-Q water"]}
				},
				RetentateWashVolume -> {
					Automatic,
					{0.1 Milliliter, 0.1 Milliliter},
					Automatic,
					{0.1 Milliliter}
				},
				Volume -> {Automatic, Automatic, Automatic, 0.2 Milliliter},
				FiltrateContainerOut -> {
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "2mL Tube"]
				},
				WashFlowThroughContainer -> {
					Automatic,
					{Model[Container, Plate, "96-well 2mL Deep Well Plate"], Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
					Automatic,
					{Model[Container, Plate, "96-well 2mL Deep Well Plate"]}
				},
				Filter -> {
					Automatic,
					Automatic,
					Model[Container, Plate, Filter, "Plate Filter, PTFE, 0.22um, 1.5mL"],
					Model[Container, Plate, Filter, "Plate Filter, PTFE, 0.22um, 1.5mL"]
				},
				FilterLabel -> {
					"filter 1", 
					"filter 1", 
					"filter 2", 
					"filter 2"
				},
				CollectionContainerLabel -> {
					"collection container 1", 
					"collection container 1", 
					"collection container 2", 
					"collection container 2"
				},
				WashFlowThroughContainerLabel -> {
					Automatic,
					{"plate 1", "plate 1"},
					Automatic,
					{"plate 2"}
				},
				Preparation -> Robotic
			];
			requiredResources = Download[protocol, OutputUnitOperations[[1]][RequiredResources]];
			tipsResources = DeleteDuplicates[Select[requiredResources, MatchQ[#[[2]], Tips]&][[All, 1]][Object]];
			washAndResuspensionResources = DeleteDuplicates[Select[requiredResources, MatchQ[#[[2]], WashAndResuspensionTips]&][[All, 1]][Object]];
			filtrateContainerOutTipResources = DeleteDuplicates[Select[requiredResources, MatchQ[#[[2]], FiltrateContainerOutTips]&][[All, 1]][Object]];
			Download[
				{
					tipsResources,
					washAndResuspensionResources,
					filtrateContainerOutTipResources
				},
				Amount
			],
			{
				{OrderlessPatternSequence[EqualP[20 Unit], EqualP[26 Unit]]},
				{OrderlessPatternSequence[EqualP[26 Unit], EqualP[20 Unit]]},
				{OrderlessPatternSequence[EqualP[26 Unit], EqualP[20 Unit]]}
			},
			Variables :> {protocol, requiredResources, tipsResources, washAndResuspensionResources, filtrateContainerOutTipResources}
		],
		Example[{Options, RetentateWashDrainTime, "RetentateWashDrainTime option indicates how much buffer to send through the filter to wash the solid that has been retained. This may be more than one volume per sample:"},
			options = ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
				FiltrationType -> Vacuum,
				RetentateWashBuffer -> {
					Model[Sample, "Milli-Q water"],
					{
						Model[Sample, "Acetone, Reagent Grade"],
						Model[Sample, "Milli-Q water"]
					}
				},
				RetentateWashVolume -> {
					0.3 Milliliter,
					{
						0.1 Milliliter,
						0.1 Milliliter
					}
				},
				RetentateWashDrainTime -> {
					5 Minute,
					6 Minute
				},
				Output -> Options
			];
			Lookup[options, RetentateWashDrainTime],
			{
				{EqualP[5 Minute]},
				{EqualP[6 Minute], EqualP[6 Minute]}
			},
			Variables :> {options}
		],
		Example[{Options, RetentateWashMix, "RetentateWashMix option indicates whether the retentate-buffer combination ought to be mixed after RetentateWashBuffer is added and before it is drained:"},
			options = ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
				FiltrationType -> Vacuum,
				RetentateWashBuffer -> {
					Model[Sample, "Milli-Q water"],
					{
						Model[Sample, "Acetone, Reagent Grade"],
						Model[Sample, "Milli-Q water"]
					}
				},
				RetentateWashVolume -> {
					0.3 Milliliter,
					{
						0.1 Milliliter,
						0.1 Milliliter
					}
				},
				RetentateWashMix -> {
					True,
					False
				},
				Output -> Options
			];
			Lookup[options, RetentateWashMix],
			{
				{True},
				{False, False}
			},
			Variables :> {options}
		],
		Example[{Options, NumberOfRetentateWashMixes, "NumberOfRetentateWashMixes option indicates how many times the retentate-wash buffer combination ought to be mixed after RetentateWashBuffer is added and before it is drained:"},
			options = ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
				FiltrationType -> Vacuum,
				RetentateWashBuffer -> {
					Model[Sample, "Milli-Q water"],
					{
						Model[Sample, "Acetone, Reagent Grade"],
						Model[Sample, "Milli-Q water"]
					}
				},
				RetentateWashVolume -> {
					0.3 Milliliter,
					{
						0.1 Milliliter,
						0.1 Milliliter
					}
				},
				RetentateWashMix -> {
					True,
					False
				},
				NumberOfRetentateWashMixes -> {
					4,
					Automatic
				},
				Output -> Options
			];
			Lookup[options, NumberOfRetentateWashMixes],
			{
				{EqualP[4]},
				Null
			},
			Variables :> {options}
		],
		Example[{Options, RetentateWashCentrifugeIntensity, "RetentateWashCentrifugeIntensity option indicates the intensity of the centrifuge draining the RetentateWashBuffer:"},
			options = ExperimentFilter[
				Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
				FiltrationType -> Centrifuge,
				RetentateWashBuffer -> Model[Sample, "Milli-Q water"],
				RetentateWashVolume -> 0.1 Milliliter,
				RetentateWashCentrifugeIntensity -> 1000 RPM,
				Output -> Options
			];
			Lookup[options, RetentateWashCentrifugeIntensity],
			{EqualP[1000 RPM]},
			Variables :> {options}
		],
		Example[{Options, RetentateContainerOut, "RetentateContainerOut option indicates the container that the retentate is moved to after filtration has completed:"},
			options = ExperimentFilter[
				Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
				FiltrationType -> Centrifuge,
				RetentateWashBuffer -> Model[Sample, "Milli-Q water"],
				RetentateWashVolume -> 0.1 Milliliter,
				RetentateContainerOut -> Model[Container, Vessel, "2mL Tube"],
				Output -> Options
			];
			Lookup[options, RetentateContainerOut],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, RetentateDestinationWell, "RetentateDestinationWell option indicates the position in the container that the retentate is moved to after filtration has completed:"},
			options = ExperimentFilter[
				Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
				FiltrationType -> Centrifuge,
				RetentateWashBuffer -> Model[Sample, "Milli-Q water"],
				RetentateWashVolume -> 0.1 Milliliter,
				RetentateCollectionMethod -> Resuspend,
				RetentateDestinationWell -> "A3", 
				RetentateContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Output -> Options
			];
			Lookup[options, RetentateDestinationWell],
			"A3", 
			Variables :> {options}
		],
		Example[{Options, RetentateCollectionMethod, "RetentateCollectionMethod option indicates how to recover the retentate after filtering:"},
			options = ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
				FiltrationType -> Vacuum,
				RetentateCollectionMethod -> {Resuspend, Transfer},
				Output -> Options
			];
			Lookup[options, RetentateCollectionMethod],
			{Resuspend, Transfer},
			Variables :> {options}
		],
		Example[{Options, RetentateCollectionMethod, "If using centrifuge filters that can be inverted and centrifuged again to retrieve the retentate and we are collecting retentate, RetentateCollectionMethod is automatically set to Centrifuge:"},
			options = ExperimentFilter[
				Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
				Filter -> Object[Container, Vessel, Filter, "Filter Test Invertable Centrifuge Filter" <> $SessionUUID],
				CollectRetentate -> True,
				Output -> Options,
				AliquotAmount -> 0.5 Milliliter
			];
			Lookup[options, RetentateCollectionMethod],
			Centrifuge,
			Variables :> {options}
		],
		Example[{Options, RetentateCollectionMethod, "If RetentateCollectionMethod is set to Centrifuge, Filter is automatically set to a filter that can collect retentate via centrifugation:"},
			options = ExperimentFilter[
				Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
				RetentateCollectionMethod -> Centrifuge,
				Output -> Options,
				AliquotAmount -> 0.5 Milliliter
			];
			Download[Lookup[options, Filter], RetentateCollectionContainerModel],
			ObjectP[Model[Container, Vessel]],
			Variables :> {options}
		],
		Example[{Options, RetentateCollectionMethod, "If RetentateCollectionMethod is Centrifuge, then RetentateCollectionContainers field is populated:"},
			protocol = ExperimentFilter[
				Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
				Filter -> Object[Container, Vessel, Filter, "Filter Test Invertable Centrifuge Filter" <> $SessionUUID],
				CollectRetentate -> True,
				AliquotAmount -> 0.5 Milliliter,
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
			];
			Download[protocol, BatchedUnitOperations[RetentateCollectionContainerLink]],
			{{ObjectP[Model[Container, Vessel]]}},
			Variables :> {protocol}
		],
		Example[{Messages, "RetentateCollectionContainerMismatch", "If RetentateCollectionMethod is Centrifuge, RetentateCollectionContainer must not be Null:"},
			ExperimentFilter[
				Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
				Filter -> Object[Container, Vessel, Filter, "Filter Test Invertable Centrifuge Filter" <> $SessionUUID],
				RetentateCollectionContainer -> Null,
				RetentateCollectionMethod -> Centrifuge,
				AliquotAmount -> 0.5 Milliliter
			],
			$Failed,
			Messages :> {Error::RetentateCollectionContainerMismatch, Error::InvalidOption}
		],
		Example[{Messages, "RetentateCollectionMethodPlateError", "If RetentateCollectionMethod is Transfer, RetentateContainerOut must not be a plate:"},
			ExperimentFilter[
				Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID],
				FiltrationType -> Vacuum,
				RetentateCollectionMethod -> Transfer,
				RetentateContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]
			],
			$Failed,
			Messages :> {Error::RetentateCollectionMethodPlateError, Error::InvalidOption}
		],
		Example[{Messages, "RetentateCollectionMethodTransferMismatch", "If RetentateCollectionMethod is Transfer, can only do centrifuge tube, non-VacuCap BottleTop, or membrane-vacuum filtration:"},
			ExperimentFilter[
				Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID],
				FiltrationType -> PeristalticPump,
				RetentateCollectionMethod -> Transfer
			],
			$Failed,
			Messages :> {Error::RetentateCollectionMethodTransferMismatch, Error::InvalidOption}
		],
		Example[{Options, RetentateCollectionMethod, "If RetentateCollectionMethod is set to Transfer, then the Spatula field is populated in the primitives:"},
			protocol = ExperimentFilter[
				Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID],
				FiltrationType -> Vacuum,
				RetentateCollectionMethod -> Transfer,
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
			];
			Download[protocol, BatchedUnitOperations[Spatula]],
			{ObjectP[Model[Item, Spatula]]},
			Variables :> {protocol}
		],
		Example[{Options, CollectOccludingRetentate, "Indicate that if the filter becomes clogged or occluded such that nothing further can be passed through, the occluding retentate should be collected in a separate container:"},
			protocol = ExperimentFilter[
				Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID],
				FiltrationType -> Syringe,
				CollectOccludingRetentate -> True,
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
			];
			Download[protocol, BatchedUnitOperations[[1]][CollectOccludingRetentate]],
			{True},
			Variables :> {protocol}
		],
		Example[{Options, OccludingRetentateContainer, "OccludingRetentateContainer allows you to specify the container into which the occluding retentate is stored, if an occlusion occurs:"},
			protocol = ExperimentFilter[
				Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID],
				FiltrationType -> Syringe,
				CollectOccludingRetentate -> True,
				OccludingRetentateContainer -> Model[Container, Vessel, "50mL Tube"],
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
			];
			Download[protocol, BatchedUnitOperations[[1]][OccludingRetentateContainerLink]],
			{ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {protocol}
		],
		Example[{Options, OccludingRetentateDestinationWell, "OccludingRetentateDestinationWell allows you to specify the position in the container into which the occluding retentate is stored, if an occlusion occurs:"},
			protocol = ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
				FiltrationType -> Syringe,
				CollectOccludingRetentate -> True,
				OccludingRetentateContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
			];
			Download[protocol, BatchedUnitOperations[[1]][OccludingRetentateDestinationWell]],
			{"A1", "A2"},
			Variables :> {protocol}
		],
		Example[{Options, OccludingRetentateContainerLabel, "OccludingRetentateContainerLabel allows you to specify the label of the container into which the occluding retentate is stored, if an occlusion occurs:"},
			protocol = ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
				FiltrationType -> Syringe,
				CollectOccludingRetentate -> True,
				OccludingRetentateContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				OccludingRetentateContainerLabel -> {"plate1", "plate2"},
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
			];
			Download[protocol, BatchedUnitOperations[[1]][{OccludingRetentateDestinationWell, OccludingRetentateContainerLink, OccludingRetentateContainerLabel}]],
			{
				{"A1", "A1"},
				{ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]], ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
				{"plate1", "plate2"}
			},
			Variables :> {protocol}
		],
		Example[{Options, WashFlowThroughLabel, "WashFlowThroughLabel option indicates the label of the samples prepared from retentate washes.  If not specified, it will resolve to the same value as FiltrateLabel:"},
			protocol = ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
				FiltrationType -> Vacuum,
				RetentateWashBuffer -> {
					Model[Sample, "Milli-Q water"],
					{
						Model[Sample, "Acetone, Reagent Grade"],
						Model[Sample, "Milli-Q water"]
					}
				},
				NumberOfRetentateWashes -> {
					2,
					{
						1,
						1
					}
				},
				RetentateWashVolume -> {
					0.1 Milliliter,
					{
						0.1 Milliliter,
						0.1 Milliliter
					}
				},
				WashFlowThroughContainer -> {
					Automatic,
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"]
					}
				},
				FiltrateLabel -> {
					"filtrate sample 1", 
					"filtrate sample 2"
				},
				WashFlowThroughLabel -> {
					Automatic,
					{
						"wash flow through 1", 
						"wash flow through 2"
					}
				},
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
			];
			Download[protocol, BatchedUnitOperations[WashFlowThroughLabel]],
			{
				{
					"filtrate sample 1", 
					"filtrate sample 1"
				},
				{
					"wash flow through 1", 
					"wash flow through 2"
				}
			},
			Variables :> {protocol}
		],
		Example[{Options, WashFlowThroughContainerLabel, "WashFlowThroughLabel option indicates the label of the samples prepared from retentate washes.  If not specified, it will resolve to the same value as FiltrateLabel:"},
			protocol = ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID],
				FiltrationType -> Vacuum,
				RetentateWashBuffer -> {
					Model[Sample, "Milli-Q water"],
					{
						Model[Sample, "Acetone, Reagent Grade"],
						Model[Sample, "Milli-Q water"]
					}
				},
				NumberOfRetentateWashes -> {
					2,
					{
						1,
						1
					}
				},
				RetentateWashVolume -> {
					0.1 Milliliter,
					{
						0.1 Milliliter,
						0.1 Milliliter
					}
				},
				WashFlowThroughContainer -> {
					Automatic,
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"]
					}
				},
				FiltrateContainerLabel -> {
					"filtrate container sample 1", 
					"filtrate container sample 2"
				},
				WashFlowThroughContainerLabel -> {
					Automatic,
					{
						"wash flow through container 1", 
						"wash flow through container 2"
					}
				}
			];
			Download[protocol, BatchedUnitOperations[WashFlowThroughContainerLabel]],
			{
				{
					"filtrate container sample 1", 
					"filtrate container sample 1"
				},
				{
					"wash flow through container 1", 
					"wash flow through container 2"
				}
			},
			Variables :> {protocol}
		],
		Example[{Options, WashFlowThroughContainer, "WashFlowThroughContainer option indicates the containers into which the retentate washes will be transferred.  If not specified, it will resolve to the same value as FiltrateContainerOut:"},
			protocol = ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID],
				FiltrationType -> Vacuum,
				RetentateWashBuffer -> {
					Model[Sample, "Milli-Q water"],
					{
						Model[Sample, "Acetone, Reagent Grade"],
						Model[Sample, "Milli-Q water"]
					}
				},
				NumberOfRetentateWashes -> {
					2,
					{
						1,
						1
					}
				},
				RetentateWashVolume -> {
					0.1 Milliliter,
					{
						0.1 Milliliter,
						0.1 Milliliter
					}
				},
				WashFlowThroughContainer -> {
					Automatic,
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"]
					}
				}
			];
			Download[protocol, BatchedUnitOperations[WashFlowThroughContainer]],
			{
				{
					ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
					ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]
				},
				{
					ObjectP[Model[Container, Vessel, "2mL Tube"]],
					ObjectP[Model[Container, Vessel, "2mL Tube"]]
				}
			},
			Variables :> {protocol}
		],
		Example[{Options, WashFlowThroughContainerLabel, "If any WashFlowThrough option is specified that necessitates the filtrate and wash flow through containers be different, WashFlowThroughContainerLabel resolves to be different from FiltrateContainerLabel:"},
			protocol = ExperimentFilter[
				Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID],
				FiltrationType -> Centrifuge,
				Instrument -> Model[Instrument, Centrifuge, "Avanti J-15R"],
				Intensity -> 4000 GravitationalAcceleration,
				Time -> 15 Minute,
				WashRetentate -> True,
				RetentateWashBuffer -> {
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"]
					}
				},
				RetentateWashVolume -> {
					{
						10 Milliliter,
						10 Milliliter,
						10 Milliliter,
						10 Milliliter,
						10 Milliliter,
						10 Milliliter,
						10 Milliliter
					}
				},
				WashFlowThroughStorageCondition -> Disposal,
				CollectRetentate -> True,
				RetentateCollectionMethod -> Transfer
			];
			Download[protocol, OutputUnitOperations[[1]][{WashFlowThroughContainerLabel, FiltrateContainerLabel}]],
			{
				{{
					_?(StringMatchQ[#, "wash flow through container" ~~ __]&)..
				}},
				{
					_?(StringMatchQ[#, "filtrate container" ~~ __]&)
				}
			},
			Variables :> {protocol}
		],
		Example[{Options, WashFlowThroughDestinationWell, "WashFlowThroughDestinationWell option indicates the position in the containers into which the retentate washes will be transferred.  If not specified, it will resolve to the same value as FiltrateContainerOut:"},
			protocol = ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID],
				FiltrationType -> Vacuum,
				RetentateWashBuffer -> {
					Model[Sample, "Milli-Q water"],
					{
						Model[Sample, "Acetone, Reagent Grade"],
						Model[Sample, "Milli-Q water"]
					}
				},
				NumberOfRetentateWashes -> {
					2,
					{
						1,
						1
					}
				},
				RetentateWashVolume -> {
					0.1 Milliliter,
					{
						0.1 Milliliter,
						0.1 Milliliter
					}
				},
				WashFlowThroughDestinationWell -> {
					"A2", 
					{
						Automatic,
						Automatic
					}
				},
				WashFlowThroughContainer -> {
					Automatic,
					{
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"]
					}
				}
			];
			Download[protocol, BatchedUnitOperations[WashFlowThroughDestinationWell]],
			{
				{
					"A2", 
					"A2"
				},
				{
					"A3", 
					"A4"
				}
			},
			Variables :> {protocol}
		],
		Example[{Options, WashFlowThroughStorageCondition, "WashFlowThroughStorageCondition option indicates the storage condition of the retentate wash flow through samples:"},
			protocol = ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID],
				FiltrationType -> Vacuum,
				RetentateWashBuffer -> {
					Model[Sample, "Milli-Q water"],
					{
						Model[Sample, "Acetone, Reagent Grade"],
						Model[Sample, "Milli-Q water"]
					}
				},
				NumberOfRetentateWashes -> {
					2,
					{
						1,
						1
					}
				},
				RetentateWashVolume -> {
					0.1 Milliliter,
					{
						0.1 Milliliter,
						0.1 Milliliter
					}
				},
				WashFlowThroughDestinationWell -> {
					"A2", 
					{
						Automatic,
						Automatic
					}
				},
				WashFlowThroughContainer -> {
					Automatic,
					{
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"]
					}
				},
				WashFlowThroughStorageCondition -> {
					Disposal,
					Automatic
				}
			];
			Download[protocol, BatchedUnitOperations[WashFlowThroughStorageCondition]],
			{
				{
					Disposal,
					Disposal
				},
				{
					Null
				}
			},
			Variables :> {protocol}
		],
		Test["Wash flow-through and retentate options accept singleton values:",
			ExperimentFilter[
				{
					Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
					Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]
				},
				FiltrationType -> Centrifuge,
				RetentateWashBuffer -> Model[Sample, "Milli-Q water"],
				RetentateWashVolume -> 10 Milliliter,
				NumberOfRetentateWashes -> 3,
				RetentateWashDrainTime -> 1 Minute,
				RetentateWashCentrifugeIntensity -> 1000 GravitationalAcceleration,
				RetentateWashMix -> True,
				NumberOfRetentateWashMixes -> 10,
				WashFlowThroughContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				WashFlowThroughDestinationWell -> "A1",
				WashFlowThroughStorageCondition -> Refrigerator,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					RetentateWashBuffer -> {ObjectP[Model[Sample, "Milli-Q water"]]},
					RetentateWashVolume -> {EqualP[10 Milliliter]},
					NumberOfRetentateWashes -> {3},
					RetentateWashDrainTime -> {EqualP[1 Minute]},
					RetentateWashCentrifugeIntensity -> {EqualP[1000 GravitationalAcceleration]},
					RetentateWashMix -> {True},
					NumberOfRetentateWashMixes -> {10},
					WashFlowThroughContainer -> {ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
					WashFlowThroughDestinationWell -> {"A1"},
					WashFlowThroughStorageCondition -> {Refrigerator}
				}]
			}
		],
		Test["Wash flow-through and retentate options accept index-matched values:",
			ExperimentFilter[
				{
					Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
					Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]
				},
				FiltrationType -> Centrifuge,
				RetentateWashBuffer -> {Model[Sample, "Milli-Q water"], Model[Sample, "Acetone, Reagent Grade"]},
				RetentateWashVolume -> {10 Milliliter, 2 Milliliter},
				NumberOfRetentateWashes -> {3, 6},
				RetentateWashDrainTime -> {1 Minute, 2 Minute},
				RetentateWashCentrifugeIntensity -> {1000 GravitationalAcceleration, 500 GravitationalAcceleration},
				RetentateWashMix -> {True, False},
				NumberOfRetentateWashMixes -> {10, Null},
				RetentateWashBufferLabel -> {"wash buffer 1", "wash buffer 2"},
				RetentateWashBufferContainerLabel -> {"wash buffer container 1", "wash buffer container 2"},
				WashFlowThroughLabel -> {"wash flowthrough sample 1", "wash flowthrough sample 2"},
				WashFlowThroughContainerLabel -> {"wash flowthrough container 1", "wash flowthrough container 2"},
				WashFlowThroughContainer -> {Model[Container, Plate, "96-well 2mL Deep Well Plate"], Model[Container, Plate, "96-well Clear Wall V-Bottom Plate"]},
				WashFlowThroughDestinationWell -> {"A1", "B1"},
				WashFlowThroughStorageCondition -> {Refrigerator, Freezer},
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					RetentateWashBuffer -> {{ObjectP[Model[Sample, "Milli-Q water"]]}, {ObjectP[Model[Sample, "Acetone, Reagent Grade"]]}},
					RetentateWashVolume -> {{EqualP[10 Milliliter]}, {EqualP[2 Milliliter]}},
					NumberOfRetentateWashes -> {{3}, {6}},
					RetentateWashDrainTime -> {{EqualP[1 Minute]}, {EqualP[2 Minute]}},
					RetentateWashCentrifugeIntensity -> {{EqualP[1000 GravitationalAcceleration]}, {EqualP[500 GravitationalAcceleration]}},
					RetentateWashMix -> {{True}, {False}},
					NumberOfRetentateWashMixes -> {{10}, Null},
					RetentateWashBufferLabel -> {{"wash buffer 1"}, {"wash buffer 2"}},
					RetentateWashBufferContainerLabel -> {{"wash buffer container 1"}, {"wash buffer container 2"}},
					WashFlowThroughLabel -> {{"wash flowthrough sample 1"}, {"wash flowthrough sample 2"}},
					WashFlowThroughContainerLabel -> {{"wash flowthrough container 1"}, {"wash flowthrough container 2"}},
					WashFlowThroughContainer -> {{ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}, {ObjectP[Model[Container, Plate, "96-well Clear Wall V-Bottom Plate"]]}},
					WashFlowThroughDestinationWell -> {{"A1"}, {"B1"}},
					WashFlowThroughStorageCondition -> {{Refrigerator}, {Freezer}}
				}]
			}

		],
		Test["Wash flow-through and retentate options accept multiple, non-indexed values:",
			ExperimentFilter[
				{
					Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
					Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]
				},
				FiltrationType -> Centrifuge,
				RetentateWashBuffer -> {Model[Sample, "Milli-Q water"], Model[Sample, "Acetone, Reagent Grade"], Model[Sample, "Milli-Q water"]},
				RetentateWashVolume -> {10 Milliliter, 2 Milliliter, 10 Milliliter},
				NumberOfRetentateWashes -> {3, 6, 9},
				RetentateWashDrainTime -> {1 Minute, 2 Minute, 3 Minute},
				RetentateWashCentrifugeIntensity -> {1000 GravitationalAcceleration, 500 GravitationalAcceleration, 250 GravitationalAcceleration},
				RetentateWashMix -> {True, False, True},
				NumberOfRetentateWashMixes -> {10, Null, 5},
				WashFlowThroughContainer -> {Model[Container, Plate, "96-well 2mL Deep Well Plate"], Model[Container, Plate, "96-well Clear Wall V-Bottom Plate"], Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
				WashFlowThroughDestinationWell -> {"A1", "B1", "C1"},
				WashFlowThroughStorageCondition -> {Refrigerator, Freezer, Refrigerator},
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					RetentateWashBuffer -> {ObjectP[Model[Sample, "Milli-Q water"]], ObjectP[Model[Sample, "Acetone, Reagent Grade"]], ObjectP[Model[Sample, "Milli-Q water"]]},
					RetentateWashVolume -> {EqualP[10 Milliliter], EqualP[2 Milliliter], EqualP[10 Milliliter]},
					NumberOfRetentateWashes -> {3, 6, 9},
					RetentateWashDrainTime -> {EqualP[1 Minute], EqualP[2 Minute], EqualP[3 Minute]},
					RetentateWashCentrifugeIntensity -> {EqualP[1000 GravitationalAcceleration], EqualP[500 GravitationalAcceleration], EqualP[250 GravitationalAcceleration]},
					RetentateWashMix -> {True, False, True},
					NumberOfRetentateWashMixes -> {10, Null, 5},
					WashFlowThroughContainer -> {ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]], ObjectP[Model[Container, Plate, "96-well Clear Wall V-Bottom Plate"]], ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
					WashFlowThroughDestinationWell -> {"A1", "B1", "C1"},
					WashFlowThroughStorageCondition -> {Refrigerator, Freezer, Refrigerator}
				}]
			}
		],
		Example[{Options, PrewetFilter, "If PrewetFilter is set to True, then run PrewetFilterBuffer through the filter and set aside its filtrate prior to running the sample through it:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 500 mL" <> $SessionUUID],
					PrewetFilter -> True,
					Output -> Options
				],
				PrewetFilter
			],
			True
		],
		Example[{Options, PrewetFilter, "If PrewetFilter is set to True, then populate all the fields in the relevant unit operation:"},
			Download[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 500 mL" <> $SessionUUID],
					PrewetFilter -> True,
					FiltrationType -> Vacuum
				],
				OutputUnitOperations[[1]][{PrewetFilter, PrewetFilterTime, PrewetFilterBufferVolume, PrewetFilterBufferLink, PrewetFilterBufferLabel, PrewetFilterContainerOutLink, PrewetFilterContainerLabel}]
			],
			{
				{True},
				{Null},
				{VolumeP},
				{ObjectP[Model[Sample]]},
				{_String},
				{ObjectP[Model[Container]]},
				{_String}
			}
		],
		Example[{Options, PrewetFilter, "If PrewetFilter is set to True, then populate all the fields in the relevant unit operation:"},
			Download[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 500 mL" <> $SessionUUID],
					PrewetFilter -> True,
					FiltrationType -> Vacuum,
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
				],
				BatchedUnitOperations[[1]][{PrewetFilter, PrewetFilterTime, PrewetFilterBufferVolume, PrewetFilterBufferLink, PrewetFilterBufferLabel, PrewetFilterContainerOutLink, PrewetFilterContainerLabel}]
			],
			{
				{True},
				{Null},
				{VolumeP},
				{ObjectP[Model[Sample]]},
				{_String},
				{ObjectP[Model[Container]]},
				{_String}
			}
		],
		Example[{Options, PrewetFilter, "If Filter is set to a filter with StorageBuffer -> True, then PrewetFilter is automatically set to True (and NumberOfFilterPrewettings is automatically set to 3, and PrewetFilterBufferVolume is set to the StorageBufferVolume):"},
			Download[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
					Filter -> Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 7K MWCO, 2 mL"],
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
				],
				BatchedUnitOperations[[1]][{PrewetFilter, NumberOfFilterPrewettings, PrewetFilterBufferVolume}]
			],
			{
				{True},
				{EqualP[3]},
				{EqualP[700 Microliter]}
			}
		],
		Example[{Options, NumberOfFilterPrewettings, "Use the NumberOfFilterPrewettings option to indicate how many iterations of prewetting should be done before the sample is run through the filter:"},
			Download[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
					Filter -> Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 7K MWCO, 2 mL"],
					NumberOfFilterPrewettings -> 2,
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
				],
				BatchedUnitOperations[[1]][NumberOfFilterPrewettings]
			],
			{EqualP[2]}
		],
		Example[{Options, PrewetFilterBufferVolume, "Use the PrewetFilterVolume option to indicate how much PrewetFilterBuffer to pass through the filter prior to the sample:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 500 mL" <> $SessionUUID],
					PrewetFilterBufferVolume -> 20 Milliliter,
					Output -> Options
				],
				PrewetFilterBufferVolume
			],
			EqualP[20 Milliliter]
		],
		Example[{Options, PrewetFilterTime, "Use the PrewetFilterTime option to indicate for how long PrewetFilterBuffer should be passed through the filter prior to the sample:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 500 mL" <> $SessionUUID],
					PrewetFilterTime -> 10 Minute,
					Output -> Options
				],
				PrewetFilterTime
			],
			EqualP[10 Minute]
		],
		Example[{Options, PrewetFilterCentrifugeIntensity, "Use the PrewetFilterCentrifugeIntensity option to indicate the centrifuge intensity for running PrewetFilterBuffer through the filter prior to the sample:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
					FiltrationType -> Centrifuge,
					PrewetFilterTime -> 10 Minute,
					PrewetFilterCentrifugeIntensity -> 1000 RPM,
					Output -> Options
				],
				PrewetFilterCentrifugeIntensity
			],
			EqualP[1000 RPM]
		],
		Example[{Options, PrewetFilterBuffer, "Use the PrewetFilterBuffer option to indicate what to run through the filter prior to the sample:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
					PrewetFilterBuffer -> Model[Sample, "Methanol"],
					Output -> Options
				],
				PrewetFilterBuffer
			],
			ObjectP[Model[Sample, "Methanol"]]
		],
		Example[{Options, PrewetFilterBufferLabel, "Use the PrewetFilterBufferLabel option to indicate the label of the sample to run through the filter prior to the sample:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
					PrewetFilterBuffer -> Model[Sample, "Methanol"],
					PrewetFilterBufferLabel -> "prewet filter buffer label 1", 
					Output -> Options
				],
				PrewetFilterBufferLabel
			],
			"prewet filter buffer label 1"
		],
		Example[{Options, PrewetFilterContainerOut, "Use the PrewetFilterContainerOut option to indicate the container into which the filtered PrewetFilterBuffer flows.  If using a BottleTop filter, automatically set to the CollectionContainer:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 500 mL" <> $SessionUUID],
					PrewetFilter -> True,
					Output -> Options
				],
				PrewetFilterContainerOut
			],
			ObjectP[Model[Container, Vessel]]
		],
		Example[{Options, PrewetFilterContainerLabel, "Use the PrewetFilterContainerLabel option to indicate the label of the container into which the filtered PrewetFilterBuffer flows:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 500 mL" <> $SessionUUID],
					PrewetFilter -> True,
					Output -> Options
				],
				PrewetFilterContainerLabel
			],
			_String
		],
		Example[{Options, Instrument, "Instrument option allows specification of instrument to use for filtration:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID],
					Instrument -> Model[Instrument, PeristalticPump, "VWR Peristaltic Variable Pump PP3400"],
					Output -> Options
				],
				Instrument
			],
			ObjectP[Model[Instrument, PeristalticPump, "VWR Peristaltic Variable Pump PP3400"]]
		],
		Example[{Options, Instrument, "Instrument option will implicitly result in the filtration type being resolved to one appropriate to the instrument selected:"},
			Lookup[
				ExperimentFilter[
					{
						Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID],
						Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]
					},
					Instrument -> {
						Model[Instrument, PeristalticPump, "VWR Peristaltic Variable Pump PP3400"],
						Model[Instrument, VacuumPump, "Rocker 300 for Filtration, Non-sterile"]
					},
					Output -> Options
				],
				{Instrument, FiltrationType}
			],
			{
				{
					ObjectP[Model[Instrument, PeristalticPump, "VWR Peristaltic Variable Pump PP3400"]],
					ObjectP[Model[Instrument, VacuumPump, "Rocker 300 for Filtration, Non-sterile"]]
				},
				{PeristalticPump, Vacuum}
			}
		],
		Example[{Options, FilterHousing, "FilterHousing option allows specification of filtration housing to use:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID],
					FilterHousing->Object[Instrument, FilterHousing, "Battlestar Galactica"],
					Output -> Options
				],
				FilterHousing
			],
			ObjectP[Object[Instrument, FilterHousing, "Battlestar Galactica"]]
		],
		Example[{Options, FilterHousing, "If FilterHousing is specified but FiltrationType is not, resolve the FiltrationType based on that value:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
					FilterHousing-> Model[Instrument, FilterBlock, "Filter Block"],
					Output -> Options
				],
				FiltrationType
			],
			Vacuum
		],
		Example[{Options, Filter, "Filter option allows specification of type of filter to use:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID],
					Filter -> Model[Item, Filter, "id:lYq9jRxnrKxY"],
					Output -> Options
				],
				Filter
			],
			ObjectP[Model[Item, Filter, "id:lYq9jRxnrKxY"]]
		],
		Example[{Options, Filter, "Filter option allows resolving to the same container if samples are already in a filter plate:"},
			Lookup[
				ExperimentFilter[
					Object[Container, Plate, Filter, "Filter plate 2" <> $SessionUUID],
					Filter -> Model[Container, Plate, Filter, "Plate Filter, PES, 0.22um, 0.3mL"],
					Output -> Options
				],
				Filter
			],
			ObjectP[Object[Container, Plate, Filter, "Filter plate 2" <> $SessionUUID]]
		],
		Example[{Options, Filter, "Filter option allows resolving to a new filter if samples are in a different filter model:"},
			Lookup[
				ExperimentFilter[
					Object[Container, Plate, Filter, "Filter plate 2" <> $SessionUUID],
					Filter -> Model[Container, Plate, Filter, "Slit Cut 96 Well-Plate Filter Plate"],
					Output -> Options
				],
				Filter
			],
			ObjectP[Model[Container, Plate, Filter, "Slit Cut 96 Well-Plate Filter Plate"]]
		],
		Example[{Options, Filter, "Filter option allows resolving to the same filter vessel tube:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 500 mL (II)" <> $SessionUUID],
					Filter -> Object[Container, Vessel, Filter, "Filter Test two-part filter (top portion)" <> $SessionUUID],
					Output -> Options
				],
				Filter
			],
			ObjectP[Object[Container, Vessel, Filter, "Filter Test two-part filter (top portion)" <> $SessionUUID]]
		],
		Example[{Options, FilterPosition, "FilterPosition option allows specification of specific positions in the in which to load the sample:"},
			protocol = ExperimentFilter[
				Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
				FilterPosition -> "A4",
				Filter -> Model[Container, Plate, Filter, "Plate Filter, PTFE, 0.22um, 1.5mL"],
				Preparation -> Robotic
			];
			Download[protocol, OutputUnitOperations[[1]][FilterPosition]],
			{"A4"}
		],
		Example[{Options, FilterPosition, "If not specified, FilterPosition automatically set to the first empty position in the specified filter for each sample:"},
			protocol = ExperimentFilter[
				Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
				Filter -> Object[Container, Plate, Filter, "Filter plate 1" <> $SessionUUID],
				Volume -> 0.2 Milliliter,
				Preparation -> Robotic
			];
			Download[protocol, OutputUnitOperations[[1]][FilterPosition]],
			{"A2"}
		],
		Example[{Options, FilterPosition, "If specifically requested with FilterPosition, can filter sample into a position that is already occupied:"},
			protocol = ExperimentFilter[
				Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
				Filter -> Object[Container, Plate, Filter, "Filter plate 1" <> $SessionUUID],
				Volume -> 0.05 Milliliter,
				FilterPosition -> "A1",
				Preparation -> Robotic
			];
			Download[protocol, OutputUnitOperations[[1]][FilterPosition]],
			{"A1"}
		],
		Example[{Options, FilterPosition, "If using two different filters because of different filtering conditions, resolve FilterPosition independently:"},
			protocol = ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID]},
				AliquotAmount -> 0.2 Milliliter,
				Filter -> Model[Container, Plate, Filter, "Plate Filter, PES, 0.22um, 0.3mL"],
				Intensity -> {500 RPM, 700 RPM},
				Preparation -> Manual,
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
			];
			Download[protocol, BatchedUnitOperations[FilterPosition]],
			{{"A1", "A1"}}
		],
		Example[{Options, FilterPosition, "If not specified, and the sample is already in a filter, FilterPosition is set to the position the sample is already in (Manual):"},
			protocol = ExperimentFilter[
				{Object[Sample, "Filter Sample 1 in filter plate 2" <> $SessionUUID], Object[Sample, "Filter Sample 2 in filter plate 2" <> $SessionUUID]},
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID],
				Preparation -> Manual
			];
			Download[protocol, BatchedUnitOperations[[1]][FilterPosition]],
			{"A2", "A3"},
			Variables :> {protocol}
		],
		Example[{Options, FilterPosition, "If not specified, and the sample is already in a filter, FilterPosition is set to the position the sample is already in (Robotic):"},
			protocol = ExperimentFilter[
				{Object[Sample, "Filter Sample 1 in filter plate 2" <> $SessionUUID], Object[Sample, "Filter Sample 2 in filter plate 2" <> $SessionUUID]},
				Preparation -> Robotic
			];
			Download[protocol, OutputUnitOperations[[1]][FilterPosition]],
			{"A2", "A3"},
			Variables :> {protocol}
		],
		Example[{Options, Syringe, "Syringe option allows specification of model of syringe to be used to use:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID],
					Syringe -> Model[Container, Syringe, "id:AEqRl9Kz1VD1"],
					Output -> Options
				],
				Syringe
			],
			ObjectP[Model[Container, Syringe, "id:AEqRl9Kz1VD1"]]
		],
		Test["If doing syringe filtering into a non-self-standing tube, populate the DestinationRacks field of the primitives:",
			protocol = ExperimentFilter[
				Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID],
				Syringe -> Model[Container, Syringe, "id:AEqRl9Kz1VD1"],
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
			];
			Download[protocol, BatchedUnitOperations[[1]][DestinationRack]],
			{ObjectP[Model[Container, Rack]]},
			Variables :> {protocol}
		],
		Example[{Options, FlowRate, "FlowRate option allows the specification of the rate at which liquid is dispensed from the syringe into the filter:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID],
					Syringe -> Model[Container, Syringe, "id:AEqRl9Kz1VD1"],
					FlowRate -> 5 Milliliter / Minute,
					Output -> Options
				],
				FlowRate
			],
			EqualP[5 Milliliter / Minute]
		],
		Example[{Options, FlowRate, "If not specified and doing syringe filtering, FlowRate is automatically set to 0.2 * MaxVolume / Minute of the syringe:"},
			protocol = ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID]},
				Syringe -> {Model[Container, Syringe, "id:AEqRl9Kz1VD1"], Automatic},
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
			];
			Download[protocol, BatchedUnitOperations[FlowRate]],
			{
				{0.2 * Download[Model[Container, Syringe, "id:AEqRl9Kz1VD1"], MaxVolume] / Minute},
				{Null}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, FiltrateContainerOut, "FiltrateContainerOut option allows specification of the model of the destination container to be used:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 2L" <> $SessionUUID],
					FiltrateContainerOut -> Model[Container, Vessel, "Filter Test Container with 4L Max Volume" <> $SessionUUID],
					Output -> Options
				],
				FiltrateContainerOut
			],
			{1, ObjectP[Model[Container, Vessel, "Filter Test Container with 4L Max Volume" <> $SessionUUID]]}
		],
		Example[
			{Options, FiltrateContainerOut, "If the FiltrateContainerOut is resolved automatically during Centrifuge filtration, the samples will remain in the collection portion of the filter:"},
			Lookup[
				ExperimentFilter[
					{
						Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID],
						Object[Container, Vessel, "Filter Test Container for 1mL sample" <> $SessionUUID]
					},
					FiltrationType -> Centrifuge,
					Output -> Options
				],
				{Filter, FiltrateContainerOut}
			],
			{
				{
					ObjectP[],
					ObjectP[]
				},
				{
					{_, ObjectP[]},
					{_, ObjectP[]}
				}
			}
		],
		Example[
			{Options, FiltrateDestinationWell, "FiltrateDestinationWell option indicates the position in the FiltrateContainerOut that the sample should end up with:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 2L" <> $SessionUUID],
					FiltrateContainerOut -> Model[Container, Vessel, "Filter Test Container with 4L Max Volume" <> $SessionUUID],
					FiltrateDestinationWell -> "A1",
					Output -> Options
				],
				FiltrateDestinationWell
			],
			"A1"
		],
		Example[{Options, FiltrateDestinationWell, "If FilterPosition is specified and the FiltrateDestinationWell is not, then resolve the values to be the same if the CollectionContainer and FiltrateContainerOut are also going to be the same:"},
			protocol = ExperimentFilter[
				Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
				FilterPosition -> "A4",
				Filter -> Model[Container, Plate, Filter, "Plate Filter, PTFE, 0.22um, 1.5mL"],
				Preparation -> Robotic
			];
			Download[protocol, OutputUnitOperations[[1]][FiltrateDestinationWell]],
			{"A4"}
		],
		Example[
			{Options, MembraneMaterial, "An appropriate filter will be selected when the filter membrane material is specified:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 2L" <> $SessionUUID],
					MembraneMaterial -> PES,
					Output -> Options
				],
				{MembraneMaterial}
			],
			{PES}
		],
		Example[
			{Options, PrefilterMembraneMaterial, "An appropriate filter will be selected when the prefilter membrane material is specified:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID],
					MembraneMaterial -> PTFE,
					PrefilterMembraneMaterial -> GxF,
					Output -> Options
				],
				{PrefilterMembraneMaterial}
			],
			{GxF}
		],
		Example[{Options, PoreSize, "An appropriate filter will be selected when the pore size is specified:"},
			Download[Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 2L" <> $SessionUUID],
					PoreSize -> .22 Micron,
					Output -> Options
				], Filter
			], PoreSize
			],
			.22 Micron
		],
		Example[{Options, PrefilterPoreSize, "An appropriate filter will be selected when the prefilter pore size is specified:"},
			Download[Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID],
					MembraneMaterial->PTFE,
					PrefilterPoreSize-> 1. Micron,
					Output -> Options
				], Filter
			], {PrefilterPoreSize, PrefilterMembraneMaterial}
			],
			{1. Micron, GxF}
		],

		Example[{Options, MolecularWeightCutoff, "An appropriate filter will be selected when the molecular weight cutoff is specified:"},
			Lookup[
				ExperimentFilter[
					Object[Container, Vessel, "Filter Test Container for 1mL sample" <> $SessionUUID],
					MolecularWeightCutoff -> 100 Kilo Dalton,
					Output -> Options
				], {PoreSize, MolecularWeightCutoff}
			],
			{Null, EqualP[100 Kilodalton]}
		],
		Example[{Options, MolecularWeightCutoff, "Specifying a filter with a molecular weight cutoff will automatically resolve the MolecularWeightCutoff option to that value:"},
			Lookup[
				ExperimentFilter[
					Object[Container, Vessel, "Filter Test Container for 1mL sample" <> $SessionUUID],
					Filter -> Model[Container, Vessel, Filter, "Centrifuge Filter, PES, 100K MWCO, 20mL filter"],
					Output -> Options
				],{PoreSize, MolecularWeightCutoff}
			],
			{Null, 100. Kilo Dalton}
		],
		Example[{Options, Intensity, "The intensity at which the samples should be spun when using centrifuge filtration:"},
			Lookup[ExperimentFilter[
				{
					Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID],
					Object[Container, Vessel, "Filter Test Container for 1mL sample" <> $SessionUUID]
				},
				FiltrationType -> Centrifuge,
				Intensity -> {2000 GravitationalAcceleration, 1000 RPM},
				Output -> Options
			], Intensity],
			{2000 GravitationalAcceleration, 1000 RPM}
		],
		Example[{Options, Counterweight, "Specify the label for the counterweight, and resolve to a counterweight model:"},
			options = ExperimentFilter[
				Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
				FiltrationType -> Centrifuge,
				Volume -> 300 Microliter,
				Preparation -> Robotic,
				Filter -> Model[Container, Plate, Filter, "Plate Filter, Omega 3K MWCO, 350uL"],
				FiltrateContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Intensity -> 1500 GravitationalAcceleration,
				Time -> 45 Minute,
				Counterweight -> Model[Item, Counterweight, "Deep-well plate counterweight, 93.7 gram"],
				Output -> Options
			];
			Lookup[options, Counterweight],
			{ObjectP[Model[Item, Counterweight, "Deep-well plate counterweight, 93.7 gram"]]},
			Variables :> {options},
			Messages :> {Warning::SterileContainerRecommended}
		],
		Example[{Options, Time, "The time for which the samples should be spun when using centrifuge filtration:"},
			Lookup[ExperimentFilter[
				Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID],
				FiltrationType -> Centrifuge,
				Time -> 10 Minute,
				Output -> Options
			], Time],
			10 Minute
		],
		Example[{Options, FilterUntilDrained, "Indicates if the sample should be filtered until all sample has been drained through:"},
			Lookup[ExperimentFilter[
				Object[Container, Vessel, "Filter Test Container for 1mL sample" <> $SessionUUID],
				FiltrationType -> Vacuum,
				Time -> 10 Minute,
				FilterUntilDrained -> True,
				Output -> Options
			], FilterUntilDrained],
			True
		],
		Example[{Options, MaxTime, "Indicates the maximum time the sample should be filtered when FilterUntilDrained -> True, beyond which filtering will be stopped even if not fully drained:"},
			Lookup[ExperimentFilter[
				Object[Container, Vessel, "Filter Test Container for 1mL sample" <> $SessionUUID],
				FiltrationType -> Vacuum,
				Time -> 10 Minute,
				MaxTime -> 30 Minute,
				FilterUntilDrained -> True,
				Output -> Options
			], MaxTime],
			EqualP[30 Minute]
		],
		Example[{Options, Temperature, "The temperature at which the samples should be spun when using centrifuge filtration:"},
			Lookup[ExperimentFilter[
				Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID],
				FiltrationType -> Centrifuge,
				Temperature -> 12 Celsius,
				Output -> Options
			], Temperature],
			12 Celsius
		],
		Example[{Options, Sterile, "An appropriate instrument will be selected when the Sterile option is used:"},
			Download[Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID],
					FiltrationType-> Vacuum,
					Sterile -> True,
					Output -> Options
				],Instrument
			],Name
			],
			"Rocker 300 for Filtration, Sterile"
		],
		Example[{Options, ResuspensionVolume, "ResuspensionVolume option indicates the amount of liquid to resuspend retentate before transferring it to a new container:"},
			Lookup[
				ExperimentFilter[
					Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID],
					Filter -> Model[Container, Vessel, Filter, "Centrifuge Filter, PES, 100K MWCO, 20mL filter"],
					ResuspensionVolume -> 15 Milliliter,
					Output -> Options
				],
				ResuspensionVolume
			],
			15 Milliliter
		],
		Example[{Options, ResuspensionBuffer, "ResuspensionBuffer option indicates liquid in which to resuspend retentate before transferring it to a new container:"},
			Lookup[
				ExperimentFilter[
					Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID],
					Filter -> Model[Container, Vessel, Filter, "Centrifuge Filter, PES, 100K MWCO, 20mL filter"],
					ResuspensionBuffer -> Model[Sample, "Milli-Q water"],
					ResuspensionVolume -> 15 Milliliter,
					Output -> Options
				],
				ResuspensionBuffer
			],
			ObjectP[Model[Sample, "Milli-Q water"]]
		],
		Example[{Options, NumberOfResuspensionMixes, "NumberOfResuspensionMixes option indicates the number of mixes to resuspend the retentate in the buffer before transferring it to a new container:"},
			Lookup[
				ExperimentFilter[
					Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID],
					Filter -> Model[Container, Vessel, Filter, "Centrifuge Filter, PES, 100K MWCO, 20mL filter"],
					ResuspensionBuffer -> Model[Sample, "Milli-Q water"],
					ResuspensionVolume -> 15 Milliliter,
					NumberOfResuspensionMixes -> 4,
					Output -> Options
				],
				NumberOfResuspensionMixes
			],
			4
		],
		Example[{Options, ResuspensionBufferLabel, "ResuspensionBufferLabel option indicates the label of the ResuspensionBuffer:"},
			Lookup[
				ExperimentFilter[
					{Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID], Object[Container, Vessel, "Filter Test Container for 1mL sample" <> $SessionUUID]},
					Filter -> Model[Container, Vessel, Filter, "Centrifuge Filter, PES, 100K MWCO, 20mL filter"],
					ResuspensionBuffer -> Model[Sample, "Milli-Q water"],
					ResuspensionVolume -> 15 Milliliter,
					ResuspensionBufferLabel -> {"Resuspension Buffer 1", Automatic},
					Output -> Options
				],
				ResuspensionBufferLabel
			],
			{"Resuspension Buffer 1", _String}
		],
		Example[{Options, ResuspensionBufferContainerLabel, "ResuspensionBufferContainerLabel option indicates the label of the container of the ResuspensionBuffer:"},
			Lookup[
				ExperimentFilter[
					{
						Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID],
						Object[Container, Vessel, "Filter Test Container for 1mL sample" <> $SessionUUID]
					},
					Filter -> Model[Container, Vessel, Filter, "Centrifuge Filter, PES, 100K MWCO, 20mL filter"],
					ResuspensionBuffer -> Model[Sample, "Milli-Q water"],
					ResuspensionVolume -> 15 Milliliter,
					ResuspensionBufferContainerLabel -> {"Resuspension Buffer Container 1", Automatic},
					Output -> Options
				],
				ResuspensionBufferContainerLabel
			],
			{"Resuspension Buffer Container 1", _String}
		],
		Example[{Options, FilterStorageCondition, "The storage condition at which the filter should be stored after the end of the protocol:"},
			Lookup[
				ExperimentFilter[
					{
						Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID],
						Object[Container, Vessel, "Filter Test Container for 1mL sample" <> $SessionUUID]
					},
					FiltrationType -> Centrifuge,
					Output -> Options,
					FilterStorageCondition -> {Disposal, Refrigerator}
				],
				FilterStorageCondition
			],
			{Disposal, Refrigerator}
		],
		Example[{Options, SamplesOutStorageCondition, "The storage condition at which the samples should be stored after the end of the protocol:"},
			Lookup[ExperimentFilter[
				{
					Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID],
					Object[Container, Vessel, "Filter Test Container for 1mL sample" <> $SessionUUID]
				},
				FiltrationType -> Centrifuge,
				Output -> Options,
				SamplesOutStorageCondition -> {AmbientStorage, Refrigerator}
			], SamplesOutStorageCondition],
			{AmbientStorage, Refrigerator}
		],
		Example[{Options, Template, "A template protocol whose methodology should be reproduced in running this experiment. Option values will be inherited from the template protocol, but can be individually overridden by directly specifying values for those options to this Experiment function:"},
			(* Create an initial protocol *)
			templateFilterProtocol = ExperimentFilter[
				Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID],
				FiltrationType -> Centrifuge,Time->23 Minute,
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID],
				Name -> "Filter Test Template Protocol" <> $SessionUUID
			];

			(* Create another protocol which will exactly repeat the first *)
			repeatProtocol = ExperimentFilter[
				Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID],
				Template->templateFilterProtocol,
				Intensity->2200 GravitationalAcceleration,
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
			];

			Download[
				{templateFilterProtocol,repeatProtocol},
				{Intensity,Times,Temperatures}
			],
			{
				{
					{RPMP},
					{EqualP[Quantity[23.`, "Minutes"]]},
					{EqualP[$AmbientTemperature]}
				},
				{
					{EqualP[Quantity[2200.`, "StandardAccelerationOfGravity"]]},
					{EqualP[Quantity[23.`, "Minutes"]]},
					{EqualP[$AmbientTemperature]}
				}
			},
			Variables :> {templateFilterProtocol, repeatProtocol}
		],
		(* ExperimentIncubate tests. *)
		Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], IncubationTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], IncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], MaxIncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], IncubationInstrument -> Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], AnnealingTime -> 40*Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], IncubateAliquot -> 1.5*Milliliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			1.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotDestinationWell, "Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "50mL Tube"], IncubateAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options, IncubateAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],

		Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], MixType -> Shake, Output -> Options];
			Lookup[options, MixType],
			Shake,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix FiltrationType), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],

		(* ExperimentCentrifuge *)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Avanti J-15R"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], CentrifugeTime -> 10*Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			10*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should bCentrifugeInstrumente held while the samples are being centrifuged prior to starting the experiment:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], CentrifugeTemperature -> 10*Celsius, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], CentrifugeAliquot -> 1.5*Milliliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			1.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 300
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options},
			TimeConstraint -> 300
		],
		Example[{Options, CentrifugeAliquotDestinationWell, "Indicates the desired position in the corresponding CentrifugeAliquotDestinationWell in which the aliquot samples will be placed:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Vessel, "50mL Tube"], CentrifugeAliquotDestinationWell-> "A1", Output -> Options];
			Lookup[options, CentrifugeAliquotDestinationWell],
			"A1",
			Variables :> {options},
			TimeConstraint -> 300
		],

		(* aliquot options *)
		Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], Aliquot -> True, Output -> Options];
			Lookup[options, Aliquot],
			True,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], AliquotAmount -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], AssayVolume -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], TargetConcentration -> 1*Millimolar, Output -> Options];
			Lookup[options, TargetConcentration],
			1*Millimolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "The analyte whose desired final concentration is specified:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], TargetConcentration -> 5 Micromolar, TargetConcentrationAnalyte -> Model[Molecule, "Uracil"], Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, "Uracil"]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], AssayVolume -> 5 Milliliter, AliquotAmount-> 2 Milliliter, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], AssayVolume -> 5 Milliliter, AliquotAmount-> 2 Milliliter,BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], AssayVolume -> 5 Milliliter, AliquotAmount-> 2 Milliliter,BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], AssayVolume -> 5 Milliliter, AliquotAmount-> 2 Milliliter, AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"], Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], Aliquot->True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], AliquotContainer -> Model[Container, Plate, "In Situ-1 Crystallization Plate"], Output -> Options];
			Lookup[options, AliquotContainer],
			{{1, ObjectP[Model[Container, Plate, "In Situ-1 Crystallization Plate"]]}},
			Variables :> {options}
		],
		Example[{Options, DestinationWell, "The desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentFilter[
				Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID],
				AliquotContainer -> Model[Container, Plate, "In Situ-1 Crystallization Plate"],
				DestinationWell -> "A2",
				Output -> Options
			];
			Lookup[options, DestinationWell],
			{"A2"},
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options = ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options, OptionsResolverOnly, "If OptionsResolverOnly -> True and Output -> Options, skip the resource packets and simulation functions:"},
			ExperimentFilter[
				Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID],
				Output -> Options,
				OptionsResolverOnly -> True
			],
			{__Rule},
			(* stubbing to be False so that we return $Failed if we get here; the point of the option though is that we don't get here *)
			Stubs :> {Resources`Private`fulfillableResourceQ[___]:=(Message[Error::ShouldntGetHere];False)}
		],
		Example[{Options, OptionsResolverOnly, "If OptionsResolverOnly -> True and Output -> Result, ignore OptionsResolverOnly and you have to keep going:"},
			ExperimentFilter[
				Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID],
				Output -> Result,
				OptionsResolverOnly -> True
			],
			$Failed,
			(* stubbing to be False so that we return $Failed; in this case, it should actually get to this point *)
			Stubs :> {Resources`Private`fulfillableResourceQ[___]:=False}
		],
		Test["ExperimentFilter is called properly with the Experiment head and Filter primitives:",
			Experiment[{
				Filter[
					Sample -> Object[Sample, "Filter Test Sample with 2L" <> $SessionUUID],
					FiltrateLabel -> "Filtrate sample 1"
				],
				Transfer[
					Source -> "Filtrate sample 1",
					Destination -> Model[Container, Vessel, "2mL Tube"],
					Amount -> 1 Milliliter,
					DestinationLabel -> "Transferred Filtered Sample 1"
				],
				Filter[Sample -> "Transferred Filtered Sample 1"]
			}],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			TimeConstraint -> 600
		],
		Test["ExperimentFilter returns a simulation blob if Output -> Simulation:",
			ExperimentFilter[Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID], Output -> Simulation],
			SimulationP
		],
		(*== Messages ==*)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentFilter[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentFilter[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentFilter[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentFilter[Object[Container, Vessel, "id:12345678"]],
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

				ExperimentFilter[sampleID, Simulation -> simulationToPassIn, Output -> Options]
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

				ExperimentFilter[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "OccludingRetentateMismatch", "If CollectOccludingRetentate is set to False, then OccludingRetentateContainer, OccludingRetentateDestinationWell, and OccludingRetentateContainerLabel must not be specified:"},
			ExperimentFilter[
				Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID],
				FiltrationType -> Syringe,
				CollectOccludingRetentate -> False,
				OccludingRetentateContainer -> Model[Container, Vessel, "50mL Tube"]
			],
			$Failed,
			Messages :> {
				Error::OccludingRetentateMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "OccludingRetentateNotSupported", "If FiltrationType is not set to Syringe, then CollectOccludingRetentate cannot be True:"},
			ExperimentFilter[
				Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID],
				FiltrationType -> Vacuum,
				CollectOccludingRetentate -> True
			],
			$Failed,
			Messages :> {
				Error::OccludingRetentateNotSupported,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PrewetFilterMismatch", "Throw an error if PrewetFilter is set to False but a prewetting option is specified:"},
			ExperimentFilter[
				Object[Sample, "Filter Test Sample with 500 mL" <> $SessionUUID],
				PrewetFilter -> False,
				PrewetFilterBuffer -> Model[Sample, "Methanol"]
			],
			$Failed,
			Messages :> {Error::PrewetFilterMismatch, Error::InvalidOption}
		],
		Example[{Messages, "PrewetFilterCentrifugeIntensityTypeMismatch", "Throw an error if PrewetFilterCentrifugeIntensity is specified but FiltrationType is not Centrifuge:"},
			ExperimentFilter[
				Object[Sample, "Filter Test Sample with 500 mL" <> $SessionUUID],
				PrewetFilterCentrifugeIntensity -> 1000 RPM
			],
			$Failed,
			Messages :> {Error::PrewetFilterCentrifugeIntensityTypeMismatch, Error::InvalidOption}
		],
		Example[{Messages, "FiltrationTypeAndInstrumentMismatch", "A mismatch between an instrument and filtration type will product an error message:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID],
					Instrument -> Model[Instrument, PeristalticPump, "VWR Peristaltic Variable Pump PP3400"],
					FiltrationType->Vacuum,
					Output -> Options
				],
				{FiltrationType,Instrument}
			],
			{Vacuum, ObjectP[Model[Instrument, PeristalticPump, "VWR Peristaltic Variable Pump PP3400"]]},
			Messages :> {Error::FiltrationTypeAndInstrumentMismatch, Error::InvalidOption}
		],
		Example[{Messages, "FiltrationTypeAndFilterHousingMismatch", "FilterHousing option cannot be set to Null for PeristalticPump filtrations:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID],
					FiltrationType -> PeristalticPump,
					FilterHousing -> Null,
					Output -> Options
				],
				FilterHousing
			],
			Null,
			Messages :> {Error::FiltrationTypeAndFilterHousingMismatch, Error::InvalidOption}
		],
		Example[{Messages, "FiltrationTypeAndFilterHousingMismatch", "FilterHousing option only needs to be provided to PeristalticPump, Vacuum, or Gravity filtrations (and they have to have the correct type):"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID],
					FilterHousing -> Object[Instrument, FilterHousing, "Battlestar Galactica"],
					FiltrationType -> Vacuum,
					Output -> Options
				],
				FilterHousing
			],
			ObjectP[Object[Instrument, FilterHousing, "Battlestar Galactica"]],
			Messages :> {Error::FiltrationTypeAndFilterHousingMismatch, Error::InvalidOption}
		],
		Example[{Messages, "FilterPositionDoesNotExist", "An error is thrown if FilterPosition is set to a position that does not exist in the indicated filter:"},
			ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID]},
				AliquotAmount -> 0.2 Milliliter,
				Filter -> Model[Container, Plate, Filter, "Plate Filter, PES, 0.22um, 0.3mL"],
				FilterPosition -> {"H13", "A2"}
			],
			$Failed,
			Messages :> {
				Error::FilterPositionDoesNotExist,
				Error::DestinationWellDoesntExist,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FilterPositionInvalid", "An error is thrown if the sample is already in the specified Filter and the FilterPosition is set to a position besides the position the sample is currently in:"},
			ExperimentFilter[
				{Object[Sample, "Filter Sample 1 in filter plate 2" <> $SessionUUID], Object[Sample, "Filter Sample 2 in filter plate 2" <> $SessionUUID]},
				Preparation -> Robotic,
				FilterPosition -> {"D4", "D5"}
			],
			$Failed,
			Messages :> {
				Error::FilterPositionInvalid,
				Error::FilterPositionDestinationWellConflict,
				Error::InvalidOption
			}
		],
		Test["Generate an Object[Protocol, ManualCellPreparation] if Preparation -> Manual and a cell-containing sample is used:",
			ExperimentFilter[
				{Object[Sample, "Filter Test cell sample 1 " <> $SessionUUID]},
				Preparation -> Manual,
				ImageSample -> False,
				FiltrationType -> Vacuum,
				MeasureVolume -> False,
				MeasureWeight -> False
			],
			ObjectP[Object[Protocol, ManualCellPreparation]]
		],
		Test["Generate an Object[Protocol, RoboticCellPreparation] if Preparation -> Robotic and a cell-containing sample is used:",
			ExperimentFilter[
				{Object[Sample, "Filter Test cell sample 1 " <> $SessionUUID]},
				Preparation -> Robotic,
				ImageSample -> False,
				MeasureVolume -> False,
				MeasureWeight -> False
			],
			ObjectP[Object[Protocol, RoboticCellPreparation]]
		],
		Test["If using the same model of plate filter but have different filtering parameters (Intensity and Time), make different resources for these filters and populate the FilterPositions field properly in the manipulations:", 
			protocol = ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID], Object[Sample, "Filter Test Sample with 3L (II)" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
				AliquotAmount -> 0.5 Milliliter,
				Filter -> Model[Container, Plate, Filter, "id:6V0npvK7MMW1"],
				FiltrationType -> Centrifuge,
				Time -> {5 Minute, 5 Minute, 7 Minute},
				WashRetentate -> True,
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
			];
			requiredResources = Download[protocol, RequiredResources];
			{
				Download[protocol, BatchedUnitOperations[FilterPosition]],
				DeleteDuplicates[Cases[requiredResources, {resource_, Filters, _, _} :> Download[resource, Object]]]
			},
			{
				{{"A1", "A2", "A1"}},
				{ObjectP[Object[Resource, Sample]], ObjectP[Object[Resource, Sample]]}
			},
			Variables :> {protocol, requiredResources}
		],
		Test["If using the same model of plate filter when centrifuging and everything is going into the same collection container plate, make sure the collection container shares the same resource both in the protocol object and in the unit operation:", 
			protocol = ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID], Object[Sample, "Filter Test Sample with 3L (II)" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
				AliquotAmount -> 0.5 Milliliter,
				Filter -> Model[Container, Plate, Filter, "id:6V0npvK7MMW1"],
				FiltrationType -> Centrifuge,
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID]
			];
			{protRequiredResources, unitOpRequiredResources} = Download[protocol, {RequiredResources, BatchedUnitOperations[[1]][RequiredResources]}];
			{
				collectionContainerResources,
				unitOpCollectionContainerResources
			} = {
				Cases[protRequiredResources, {resource:ObjectP[], CollectionContainers, _, _} :> Download[resource, Object]],
				Cases[unitOpRequiredResources, {resource:ObjectP[], CollectionContainerLink, _, _} :> Download[resource, Object]]
			};
			Length[DeleteDuplicates[collectionContainerResources]] == 1 && Length[DeleteDuplicates[unitOpCollectionContainerResources]] == 1 && collectionContainerResources === unitOpCollectionContainerResources,
			True,
			Variables :> {protocol, protRequiredResources, unitOpRequiredResources, collectionContainerResources, unitOpCollectionContainerResources}
		],
		Example[{Messages, "CentrifugeFilterDestinationRequired", "If Filter is set to a centrifuge filter where DestinationContainerModel is not populated, then an error is thrown:"},
			ExperimentFilter[
				Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
				(* importantly, this filter is supposed to not have DestinationContainerModel populated; if it gets it ever, then this test will fail*)
				Filter -> Model[Container,Vessel,Filter,"Centrifuge Filter, PES, 0.22um, 20mL"]
			],
			$Failed,
			Messages :> {Error::CentrifugeFilterDestinationRequired, Error::InvalidOption}
		],
		Example[{Messages, "FiltrationTypeMismatch", "An error will be thrown if FlowRate is specified but not doing syringe filtering:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID],
					FiltrationType->Vacuum,
					FlowRate -> 3 Milliliter / Minute,
					FiltrateContainerOut -> Model[Container, Vessel, "50mL Tube"],
					Output -> Options
				],
				FlowRate
			],
			EqualP[3 Milliliter / Minute],
			Messages :> {Error::FiltrationTypeMismatch, Error::InvalidOption}
		],
		Example[{Messages, "FiltrationTypeAndSyringeMismatch", "An error will be shown if a syringe is specified, but non-syringe filtration type is selected:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID],
					FiltrationType->Vacuum,
					Syringe -> Model[Container, Syringe, "id:AEqRl9Kz1VD1"],
					FiltrateContainerOut -> Model[Container, Vessel, "50mL Tube"],
					Output -> Options
				],
				Syringe
			],
			ObjectP[Model[Container, Syringe, "id:AEqRl9Kz1VD1"]],
			Messages :> {Error::FiltrationTypeAndSyringeMismatch, Error::InvalidOption}
		],
		Example[{Messages, "FilterMaxVolume", "An error will be shown if a filter is specified with a MaxVolume smaller then the volume of the sample:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID],
					Filter-> Model[Item,Filter, "Filter Test Membrane Filter" <> $SessionUUID],
					Output -> Options
				],
				Filter
			],
			ObjectP[Model[Item,Filter, "Filter Test Membrane Filter" <> $SessionUUID]],
			Messages :> {Error::FilterMaxVolume, Error::InvalidOption}
		],
		Example[{Messages, "FilterOptionMismatch", "An error will be shown if a filter and filter physical characteristics are specified that are in conflict:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 2L" <> $SessionUUID],
					Filter-> Model[Item,Filter, "Filter Test Membrane Filter" <> $SessionUUID],
					MembraneMaterial->PTFE,
					Output -> Options
				],
				Filter
			],
			ObjectP[Model[Item,Filter, "Filter Test Membrane Filter" <> $SessionUUID]],
			Messages :> {Error::FilterOptionMismatch, Error::InvalidOption}
		],
		Example[{Messages, "FilterInletConnectionType", "An error will be shown if a filter and filter physical characteristics are specified that are in conflict:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID],
					Filter-> Model[Item,Filter, "Filter Test Membrane Filter with LuerSlip" <> $SessionUUID],
					Output -> Options
				],
				Filter
			],
			ObjectP[Model[Item,Filter, "Filter Test Membrane Filter with LuerSlip" <> $SessionUUID]],
			Messages :> {Error::FilterInletConnectionType, Error::InvalidOption}
		],
		Example[{Messages, "SterileOptionMismatch", "Instrument option allows specification of instrument to use for filtration:"},
			Lookup[
				ExperimentFilter[
					Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID],
					Instrument -> Model[Instrument, PeristalticPump, "VWR Peristaltic Variable Pump PP3400"],
					Sterile -> True,
					Output -> Options
				],
				Instrument
			],
			ObjectP[Model[Instrument, PeristalticPump, "VWR Peristaltic Variable Pump PP3400"]],
			Messages :> {Error::SterileOptionMismatch, Error::InvalidOption}
		],
		Example[{Messages, "TargetLabelMismatch", "If Target -> Retentate, then RetentateLabel and SampleOutLabel must be the same value; if Target -> Filtrate, then FiltrateLabel and SampleOutLabel must be the same value:"},
			ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
				RetentateLabel -> {"Test Label 1", Automatic},
				SampleOutLabel -> {"Test Label Not 1", "Test Label Not 2"},
				FiltrateLabel -> {Automatic, "Test Label 2"},
				Target -> {Retentate, Filtrate},
				CollectRetentate -> {True, False}
			],
			$Failed,
			Messages :> {
				Message[Error::TargetLabelMismatch, SampleOutLabel, RetentateLabel, FiltrateLabel, "{Object[Sample, \"Filter Test Sample with 1mL"<>$SessionUUID<>"\"], Object[Sample, \"Filter Test Sample with 15mL"<>$SessionUUID<>"\"]}"],
				Error::InvalidOption
			}
		],
		Example[{Messages, "TargetLabelMismatch", "If Target -> Retentate, then RetentateContainerLabel and ContainerOutLabel must be the same value; if Target -> Filtrate, then FiltrateContainerLabel and ContainerOutLabel must be the same value:"},
			ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
				RetentateContainerLabel -> {"Test Label 1", Automatic},
				ContainerOutLabel -> {"Test Label Not 1", "Test Label Not 2"},
				FiltrateContainerLabel -> {Automatic, "Test Label 2"},
				Target -> {Retentate, Filtrate},
				CollectRetentate -> {True, False}
			],
			$Failed,
			Messages :> {
				(* doing this and not just Error::TargetLabelMismatch because I want both objects to be caught by this *)
				Message[Error::TargetLabelMismatch, ContainerOutLabel, RetentateContainerLabel, FiltrateContainerLabel, "{Object[Sample, \"Filter Test Sample with 1mL"<>$SessionUUID<>"\"], Object[Sample, \"Filter Test Sample with 15mL"<>$SessionUUID<>"\"]}"],
				Error::InvalidOption
			}
		],
		Example[{Messages, "LabelContainerOutIndexMismatch", "For all values of RetentateContainerLabel that are replicated, the corresponding integer indices in RetentateContainerOut are also be replicated in the same positions:"},
			ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
				RetentateContainerLabel -> {"Test Label 1", "Test Label 1"},
				RetentateContainerOut -> {{1, Model[Container, Vessel, "50mL Tube"]}, {2, Model[Container, Vessel, "50mL Tube"]}},
				CollectRetentate -> {True, True}
			],
			$Failed,
			Messages :> {
				Error::LabelContainerOutIndexMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "LabelContainerOutIndexMismatch", "For all values of FiltrateContainerLabel that are replicated, the corresponding integer indices in FiltrateContainerOut are also be replicated in the same positions:"},
			ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
				FiltrateContainerLabel -> {"Test Label 1", "Test Label 1"},
				FiltrateContainerOut -> {{1, Automatic}, {2, Automatic}},
				CollectRetentate -> {True, True}
			],
			$Failed,
			Messages :> {
				Error::LabelContainerOutIndexMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FilterPositionDestinationWellConflict", "If FilterPosition and FiltrateDestinationWell are not the same but the FiltrateContainerOut and CollectionContainer are the same, an error is thrown:"},
			ExperimentFilter[
				Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
				FilterPosition -> "A4", 
				FiltrateDestinationWell -> "A1", 
				Filter -> Model[Container, Plate, Filter, "Plate Filter, PTFE, 0.22um, 1.5mL"],
				Preparation -> Robotic
			],
			$Failed,
			Messages :> {
				Error::FilterPositionDestinationWellConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PoreSizeAndMolecularWeightCutoff", "PoreSize and MolecularWeightCutoff cannot be both specified for the same filtration:"},
			Quiet[Lookup[
				ExperimentFilter[
					Object[Container, Vessel, "Filter Test Container for 1mL sample" <> $SessionUUID],
					MolecularWeightCutoff -> 100 Kilo Dalton,
					PoreSize -> .22 Micron,
					FiltrateContainerOut -> Model[Container, Vessel, "2mL Tube"],
					Output -> Options
				],
				{PoreSize, MolecularWeightCutoff}
			], {Error::FilterOptionMismatch, Error::NoFilterAvailable}],
			{.22 Micron, 100 Kilo Dalton},
			EquivalenceFunction -> Equal,
			Messages :> {Error::PoreSizeAndMolecularWeightCutoff, Error::InvalidOption}
		],
		Example[{Messages, "PoreSizeAndMolecularWeightCutoff", "PoreSize and MolecularWeightCutoff cannot be both specified as Null:"},
			Quiet[Lookup[
				ExperimentFilter[
					Object[Container, Vessel, "Filter Test Container for 1mL sample" <> $SessionUUID],
					MolecularWeightCutoff -> Null,
					PoreSize -> Null,
					FiltrateContainerOut -> Model[Container, Vessel, "2mL Tube"],
					Output -> Options
				],
				{PoreSize, MolecularWeightCutoff}
			], {Error::FilterOptionMismatch, Error::NoFilterAvailable}],
			{Null, Null},
			Messages :> {Error::PoreSizeAndMolecularWeightCutoff, Error::InvalidOption}
		],
		Example[{Messages, "PoreSizeAndMolecularWeightCutoff", "PoreSize and MolecularWeightCutoff can be both Null if a filter is specified:"},
			Lookup[
				ExperimentFilter[
					Object[Container, Vessel, "Filter Test Container for 1mL sample" <> $SessionUUID],
					Filter -> Model[Container, Plate, Filter, "id:8qZ1VWZeAw8p"] (*HisPur Ni-NTA Spin Plates*),
					MolecularWeightCutoff -> Null,
					PoreSize -> Null,
					FiltrateContainerOut -> Model[Container, Vessel, "2mL Tube"],
					Output -> Options
				],
				{PoreSize, MolecularWeightCutoff}
			],
			{Null, Null}
		],
		Example[{Messages, "NoFilterAvailable", "An error will be returned if there is currently no filter in stock capable of performing the filtration requested:"},
			Lookup[
				ExperimentFilter[
					Object[Container, Vessel, "Filter Test Container for 1mL sample" <> $SessionUUID],
					MolecularWeightCutoff -> 100 Kilo Dalton,
					PoreSize-> 100. Micron,
					Output -> Options
				],
				{PoreSize,MolecularWeightCutoff}
			],
			{EqualP[100. Micron], EqualP[100 Kilo Dalton]},
			Messages :> {
				Error::PoreSizeAndMolecularWeightCutoff,
				Error::NoFilterAvailable,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FilterPlateDimensionsExceeded", "An error will be thrown if the filter plate exceeds the size limit of the Filter Plate Slot on the AirPressure filtration instrument:"},
			ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID]},
				Filter -> Model[Container, Plate, Filter, "Filter Test Large Plate Filter Model" <> $SessionUUID],
				Preparation -> Robotic
			],
			$Failed,
			Messages :> {Error::FilterPlateDimensionsExceeded, Error::NoFilterAvailable, Error::InvalidOption}
		],
		Example[{Messages, "FilterPlateDimensionsExceeded", "An error will be thrown in RSP if the filter plate exceeds the size limit of the Filter Plate Slot on the AirPressure filtration instrument:"},
			ExperimentRoboticSamplePreparation[
				{
					LabelContainer[Label -> "myPlate", Container -> Model[Container, Plate, Filter, "Filter Test Large Plate Filter Model" <> $SessionUUID]],
					Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> {{"A1", "myPlate"}}, Amount -> 200 Microliter],
					Filter[Sample -> "myPlate", Time -> 2 Minute, Pressure -> 200 PSI]
				}
			],
			$Failed,
			Messages :> {Error::NoAvailableModel, Error::FilterPlateDimensionsExceeded, Error::InvalidInput}
		],
		Example[{Messages, "NoUsableCentrifuge", "An error will be thrown if no centrifuge is available to perform the specified filtration:"},
			Lookup[ExperimentFilter[
				{
					Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID],
					Object[Container, Vessel, "Filter Test Container for 1mL sample" <> $SessionUUID]
				},
				FiltrationType -> Centrifuge,
				Intensity -> {200000 GravitationalAcceleration, 100000 RPM},
				Output -> Options
			], Intensity],
			{200000 GravitationalAcceleration, 100000 RPM},
			Messages :> {Error::NoUsableCentrifuge, Error::InvalidOption}
		],
		Example[{Messages, "UnusableCentrifuge", "An error will be thrown if the specified centrifuge is not capable of performing the filtration:"},
			Lookup[ExperimentFilter[
				{
					Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID],
					Object[Container, Vessel, "Filter Test Container for 1mL sample" <> $SessionUUID]
				},
				Instrument-> Model[Instrument, Centrifuge, "id:jLq9jXY4kGJx"],
				Output -> Options
			],Instrument],
			ObjectP[Model[Instrument, Centrifuge, "id:jLq9jXY4kGJx"]],
			Messages :> {Error::UnusableCentrifuge, Error::InvalidOption}
		],
		Example[{Messages, "FiltrationTypeMismatch", "An error will be thrown if the filtration type is Centrifuge but the Intensity is Null:"},
			Lookup[ExperimentFilter[
				{
					Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID],
					Object[Container, Vessel, "Filter Test Container for 1mL sample" <> $SessionUUID]
				},
				FiltrationType -> Centrifuge,
				Output -> Options,
				Intensity->Null
			],Intensity],
			Null,
			Messages :> {Error::FiltrationTypeMismatch, Error::InvalidOption}
		],
		Example[{Messages, "FiltrationTypeMismatch", "An error will be thrown if the filtration type is anything but Syringe or Centrifuge but the Temperature is specified:"},
			Lookup[
				ExperimentFilter[
					Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID],
					FiltrationType -> Vacuum,
					Output -> Options,
					Temperature -> 30 Celsius
				],
				Temperature
			],
			30 Celsius,
			Messages :> {Error::FiltrationTypeMismatch, Error::InvalidOption}
		],
		Example[{Messages, "FilterUntilDrainedIncompatibleWithFilterType", "An error will be thrown if the filtration type is incompatible with the FilterUntilDrained options:"},
			Lookup[
				ExperimentFilter[
					Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID],
					FilterUntilDrained -> True,
					FiltrationType -> Centrifuge,
					Output -> Options
				],
				FilterUntilDrained
			],
			True,
			Messages :> {Error::FilterUntilDrainedIncompatibleWithFilterType, Error::InvalidOption}
		],
		Example[{Messages, "IncompatibleFilterTimes", "An error will be thrown if the Time, MaxTime, and FilterUntilDrained options are in conflict with each other:"},
			Lookup[
				ExperimentFilter[
					Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID],
					FiltrationType -> Vacuum,
					Time -> 5 Minute,
					FilterUntilDrained -> True,
					MaxTime -> Null,
					Output -> Options
				],
				Time
			],
			5 Minute,
			Messages :> {Error::IncompatibleFilterTimes, Error::InvalidOption}
		],
		Example[{Messages, "RetentateWashCentrifugeIntensityTypeMismatch", "An error will be thrown if RetentateWashCentrifugeIntensity is specified but FiltrationType is not Centrifuge:"},
			Lookup[
				ExperimentFilter[
					Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID],
					FiltrationType -> Vacuum,
					RetentateWashCentrifugeIntensity -> 500 RPM,
					Output -> Options
				],
				RetentateWashCentrifugeIntensity
			],
			{500 RPM},
			Messages :> {Error::RetentateWashCentrifugeIntensityTypeMismatch, Error::InvalidOption}
		],
		Example[{Messages, "RetentateWashCentrifugeIntensityTypeMismatch", "An error will be thrown if RetentateWashCentrifugeIntensity is specified but FiltrationType is not Centrifuge:"},
			Lookup[
				ExperimentFilter[
					Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID],
					FiltrationType -> Syringe,
					WashRetentate -> True,
					Output -> Options
				],
				WashRetentate
			],
			True,
			Messages :> {Error::WashRetentateTypeMismatch, Error::InvalidOption}
		],
		Example[{Messages, "RetentateWashCentrifugeIntensityTypeMismatch", "An error will be thrown if RetentateWashMix is False but the other RetentateWashMix options are specified:"},
			Lookup[
				ExperimentFilter[
					Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID],
					FiltrationType -> Vacuum,
					WashRetentate -> True,
					RetentateWashMix -> False,
					NumberOfRetentateWashMixes -> 4,
					Output -> Options
				],
				WashRetentate
			],
			True,
			Messages :> {Error::RetentateWashMixMismatch, Error::InvalidOption}
		],
		Example[{Messages, "WashRetentateMismatch", "An error will be thrown if WashRetentate is False but the other retentate washing options are specified:"},
			Lookup[
				ExperimentFilter[
					Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID],
					FiltrationType -> Vacuum,
					WashRetentate -> False,
					NumberOfRetentateWashes -> 4,
					Output -> Options
				],
				WashRetentate
			],
			False,
			Messages :> {Error::WashRetentateMismatch, Error::InvalidOption}
		],
		Example[{Messages, "ResuspensionVolumeTooHigh", "An error will be thrown if ResuspensionVolume is greater than the MaxVolume of the filter:"},
			Lookup[
				ExperimentFilter[
					Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID],
					Filter -> Model[Container, Vessel, Filter, "Centrifuge Filter, PES, 100K MWCO, 20mL filter"],
					ResuspensionVolume -> 40 Milliliter,
					Output -> Options
				],
				ResuspensionVolume
			],
			40 Milliliter,
			Messages :> {Error::ResuspensionVolumeTooHigh, Error::InvalidOption}
		],
		Example[{Messages, "PrefilterOptionsMismatch", "If a prefilter is being requested, than neither PrefilterPoreSize nor PrefilterMembraneMaterial can be specified as Null:"},
			ExperimentFilter[
				{Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID], Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID]},
				MembraneMaterial -> PTFE,
				PrefilterPoreSize-> {1. Micron,Null},
				PrefilterMembraneMaterial->{Null,GxF},
				FiltrateContainerOut -> {Model[Container, Vessel, "2mL Tube"], Model[Container, Vessel, "50mL Tube"]},
				Output -> Options
			],
			{__Rule},
			Messages :> {Error::PrefilterOptionsMismatch, Error::NoFilterAvailable, Error::InvalidOption}
		],


		Example[{Messages, "CollectionContainerPlateMismatch", "If Filter and CollectionContainer are specified, if one is a plate and one is not, an error is thrown:"},
			ExperimentFilter[
				Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
				Filter -> Model[Container, Plate, Filter, "id:6V0npvK7MMW1"],
				CollectionContainer -> Model[Container, Vessel, "2mL Tube"]
			],
			$Failed,
			Messages :> {Error::CollectionContainerPlateMismatch, Error::NoUsableCentrifuge, Error::InvalidOption}
		],
		(* NOTE: Error messages *)
		Example[{Messages, "SterileContainerRecommended", "If the provided FiltrateContainerOut option was for a non-sterile container, but sterile filtration was requested, the container will still be used but a message will be shown:"},
			Lookup[
				ExperimentFilter[
					Object[Container, Vessel, "Filter Test Container for 500 mL sample" <> $SessionUUID],
					FiltrateContainerOut -> Model[Container, Vessel, "1L Glass Bottle"],
					Sterile -> True,
					Output -> Options
				],
				{
					FiltrateContainerOut,
					Sterile
				}
			],
			{
				{1, ObjectP[Model[Container, Vessel, "id:zGj91aR3ddXJ"]]},
				True
			},
			Messages :> {Warning::SterileContainerRecommended}
		],
		Example[{Messages, "VolumeTooLargeForContainerOut", "If the provided FiltrateContainerOut option was for a container which MaxVolume is less then the volume of the sample, then an appropriate container will be picked and a message will be shown:"},
			ExperimentFilter[
				Object[Container, Vessel, "Filter Test Container for 3L sample (I)" <> $SessionUUID],
				FiltrateContainerOut-> Model[Container, Vessel, "500mL Glass Bottle"],
				Output -> Options
			],
			_,
			Messages :> {Error::VolumeTooLargeForContainerOut, Error::InvalidOption}
		],
		Example[{Messages, "VolumeTooLargeForCollectionContainer", "If the provided CollectionContainer option was for a container which MaxVolume is less then the volume of the sample, then an appropriate container will be picked and a message will be shown:"},
			ExperimentFilter[
				Object[Container, Vessel, "Filter Test Container for 3L sample (I)" <> $SessionUUID],
				CollectionContainer-> Model[Container, Vessel, "500mL Glass Bottle"],
				Output -> Options
			],
			_,
			Messages :> {Error::VolumeTooLargeForCollectionContainer, Error::InvalidOption}
		],
		Example[{Messages, "VolumeTooLargeForContainerOut", "If the volume of the sample + the retentate washes is too large for the collection container, don't throw an error because we'll just move the liquid to a different container between cycles so it can fit:"},
			ExperimentFilter[
				Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID],
				Filter -> Model[Container, Vessel, Filter, "Centrifuge Filter, PES, 100K MWCO, 20mL filter"],
				RetentateWashBuffer -> Model[Sample, "Milli-Q water"],
				RetentateWashVolume -> 10 Milliliter,
				NumberOfRetentateWashes -> 3,
				Output -> Options
			],
			{__Rule}
		],
		Example[{Messages, "MissingVolumeInformation", "If the sample to be filtered does not have its Volume populated, the MaxVolume of the container it is in will be used to determine the type of filtration method possible:"},
			ExperimentFilter[
				Object[Sample, "Filter Test Sample without volume" <> $SessionUUID],
				Output -> Options
			],
			_,
			Messages :> {Warning::MissingVolumeInformation}
		],
		Example[{Messages, "VolumeTooLargeForSyringe", "The MaxVolume of a specified syringe has to be greater then the volume of the sample to be filtered:"},
			ExperimentFilter[
				Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID],
				Syringe -> Model[Container, Syringe, "10mL Syringe with Luer-Lok\[RegisteredTrademark] Tip"],
				Output -> Options
			],
			_,
			Messages :> {Error::VolumeTooLargeForSyringe, Error::InvalidOption}
		],
		Example[{Messages, "IncorrectSyringeConnection", "The ConnectionType of a specified syringe has to be a LeurLock:"},
			ExperimentFilter[
				Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID],
				Syringe -> Model[Container, Syringe, "50mL All-Plastic Disposable Luer-Slip Syringe"],
				Output -> Options
			],
			_,
			Messages :> {Error::IncorrectSyringeConnection, Error::InvalidOption}
		],
		Example[{Messages, "NumberOfFilterPrewettingsTooHigh", "NumberOfFilterPrewettings cannot be greater than 1 for PeristalticPump or BottleTop filters:"},
			ExperimentFilter[
				Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID],
				FiltrationType -> PeristalticPump,
				NumberOfFilterPrewettings -> 3
			],
			$Failed,
			Messages :> {Error::NumberOfFilterPrewettingsTooHigh, Error::InvalidOption}
		],
		Example[{Messages, "PrewetFilterIncompatibleWithFilterType", "Cannot perform filter prewetting for syringe or filter block filters:"},
			ExperimentFilter[
				Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID],
				FiltrationType -> Syringe,
				PrewetFilter -> True
			],
			$Failed,
			Messages :> {Error::PrewetFilterIncompatibleWithFilterType, Error::InvalidOption}
		]
	},
	Parallel -> True,
	SetUp :> (
		$CreatedObjects = {};
		ClearMemoization[];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::DeprecatedProduct];
		Off[Warning::NoModelNameGiven];
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::DeprecatedProduct];
		On[Warning::NoModelNameGiven];
	),
	SymbolSetUp :> (
		Module[{objects, existsFilter},
			(* list of test objects*)
			objects = {
				Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID],
				Object[Sample, "Filter Test Sample with 3L (II)" <> $SessionUUID],
				Object[Sample, "Filter Test Sample with 3L (no model) (III)" <> $SessionUUID],
				Object[Container, Vessel, "Filter Test Container for 3L sample (I)" <> $SessionUUID],
				Object[Container, Vessel, "Filter Test Container for 3L sample (II)" <> $SessionUUID],
				Object[Container, Vessel, "Filter Test Container for 3L sample (III)" <> $SessionUUID],

				Object[Sample, "Filter Test Sample with 2L" <> $SessionUUID],
				Object[Container, Vessel, "Filter Test Container for 2L sample" <> $SessionUUID],

				Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID],
				Object[Sample, "Filter Test Sample with 500 mL (II)" <> $SessionUUID],
				Object[Sample, "Filter Test Sample with 500 mL" <> $SessionUUID],
				Object[Container, Vessel, "Filter Test Container for 500 mL sample" <> $SessionUUID],
				Object[Container, Vessel, Filter, "Filter Test two-part filter (top portion)" <> $SessionUUID],
				Object[Container, Vessel, "Filter Test two-part filter (bottom portion)" <> $SessionUUID],

				Object[Container, Vessel, Filter, "Filter Test Invertable Centrifuge Filter" <> $SessionUUID],
				Object[Container, Vessel, "Filter Test Invertable Centrifuge Filter Collection Tube 1" <> $SessionUUID],
				Object[Container, Vessel, "Filter Test Invertable Centrifuge Filter Collection Tube 2" <> $SessionUUID],

				Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID],

				Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
				Object[Container, Vessel, "Filter Test Container for 1mL sample" <> $SessionUUID],

				Object[Sample, "Filter Test Sample without volume" <> $SessionUUID],
				Object[Container, Vessel, "Filter Test Container for volume-less sample" <> $SessionUUID],

				Model[Instrument, PeristalticPump, "Filter Test Peristaltic Pump" <> $SessionUUID],
				Model[Container, Vessel, "Filter Test Container with 4L Max Volume" <> $SessionUUID],
				Model[Item, Filter, "Filter Test Membrane Filter" <> $SessionUUID],
				Model[Item, Filter, "Filter Test Membrane Filter with LuerSlip" <> $SessionUUID],
				Model[Container, Plate, Filter, "Filter Test Large Plate Filter Model" <> $SessionUUID],

				Object[Protocol, Filter, "Filter Test Template Protocol" <> $SessionUUID],

				Object[Container, Plate, Filter, "Filter plate 1" <> $SessionUUID],
				Object[Container, Plate, Filter, "Filter plate 2" <> $SessionUUID],

				Object[Container, Plate, "CollectionContainer plate 1" <> $SessionUUID],

				Object[Sample, "Filter Sample in filter plate 1" <> $SessionUUID],
				Object[Sample, "Filter Sample 1 in filter plate 2" <> $SessionUUID],
				Object[Sample, "Filter Sample 2 in filter plate 2" <> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID],

				Model[Container, Plate, "Filter Test plate model without counterweights"<>$SessionUUID],
				Model[Container, Plate, "Filter Test plate model without TareWeight"<>$SessionUUID],
				Model[Container, Plate, "Filter Test tall plate model"<>$SessionUUID],
				Model[Container, Plate, "Filter Test heavy plate model"<>$SessionUUID],

				Object[Container, Plate, "Filter Test plate without counterweights"<>$SessionUUID],
				Object[Container, Plate, "Filter Test plate without TareWeight"<>$SessionUUID],
				Object[Container, Plate, "Filter Test tall plate"<>$SessionUUID],
				Object[Container, Plate, "Filter Test heavy plate"<>$SessionUUID],

				Object[Container, Vessel, "Filter Test tube with cell sample " <> $SessionUUID],
				Object[Sample, "Filter Test cell sample 1 " <> $SessionUUID]
			};

			(* Check whether the names we want to give below already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];

		];
		Module[{objectID1, objectID2, objectID3, objectID4, firstUpload, secondUpload},

			(*create an ID that we'll use for the kitting*)
			{
				objectID1,
				objectID2,
				objectID3,
				objectID4
			} = CreateID[{
				Object[Container, Vessel, Filter],
				Object[Container, Vessel, Filter],
				Object[Container, Vessel],
				Object[Container, Vessel]
			}];


			firstUpload = Upload[
				{
					Association[
						Type -> Object[Container, Vessel],
						Model -> Link[Model[Container, Vessel, "5L Glass Bottle"], Objects],
						Name -> "Filter Test Container for 3L sample (I)" <> $SessionUUID,
						DeveloperObject -> True,
						Site -> Link[$Site]
					],
					Association[
						Type -> Object[Container, Vessel],
						Model -> Link[Model[Container, Vessel, "5L Glass Bottle"], Objects],
						Name -> "Filter Test Container for 3L sample (II)" <> $SessionUUID,
						DeveloperObject -> True,
						Site -> Link[$Site]
					],
					Association[
						Type -> Object[Container, Vessel],
						Model -> Link[Model[Container, Vessel, "5L Glass Bottle"], Objects],
						Name -> "Filter Test Container for 3L sample (III)" <> $SessionUUID,
						DeveloperObject -> True,
						Site -> Link[$Site]
					],
					Association[
						Type -> Object[Container, Vessel],
						Model -> Link[Model[Container, Vessel, "2L Glass Bottle"], Objects],
						Name -> "Filter Test Container for 2L sample" <> $SessionUUID,
						DeveloperObject -> True,
						Site -> Link[$Site]
					],
					Association[
						Type -> Object[Container, Vessel],
						Model -> Link[Model[Container, Vessel, "1L Glass Bottle"], Objects],
						Name -> "Filter Test Container for 500 mL sample" <> $SessionUUID,
						DeveloperObject -> True,
						Site -> Link[$Site]
					],
					Association[
						Type -> Object[Container, Vessel],
						Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
						Name -> "Filter Test Container for 15mL sample" <> $SessionUUID,
						DeveloperObject -> True,
						Site -> Link[$Site]
					],
					Association[
						Type -> Object[Container, Vessel],
						Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
						Name -> "Filter Test Container for 1mL sample" <> $SessionUUID,
						DeveloperObject -> True,
						Site -> Link[$Site]
					],
					Association[
						Type -> Object[Container, Vessel],
						Model -> Link[Model[Container, Vessel, "15mL Tube"], Objects],
						Name -> "Filter Test Container for volume-less sample" <> $SessionUUID,
						DeveloperObject -> True,
						Site -> Link[$Site]
					],

					Association[
						Type -> Model[Container, Vessel],
						Name -> "Filter Test Container with 4L Max Volume" <> $SessionUUID,
						DeveloperObject -> True,
						MaxVolume -> 4 Liter,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null, MaxWidth -> Quantity[0.06985, "Meters"], MaxDepth -> Quantity[0.06985, "Meters"], MaxHeight -> Null|>}
					],
					Association[
						Type -> Model[Instrument, PeristalticPump],
						Name -> "Filter Test Peristaltic Pump" <> $SessionUUID,
						AsepticHandling -> False,
						DeveloperObject -> True
					],
					Association[
						Type -> Model[Item, Filter],
						Name -> "Filter Test Membrane Filter" <> $SessionUUID,
						FilterType -> Membrane,
						MembraneMaterial -> PES,
						PoreSize -> .22 Micron,
						Diameter -> 142 Millimeter,
						MinVolume -> 500 Milliliter,
						MaxVolume -> 2.5 Liter
					],
					Association[
						Type -> Model[Item, Filter],
						Name -> "Filter Test Membrane Filter with LuerSlip" <> $SessionUUID,
						FilterType -> Disk,
						InletConnectionType -> SlipLuer,
						MembraneMaterial -> PES,
						PoreSize -> .22 Micron,
						Diameter -> 142 Millimeter,
						MinVolume -> 50 Milliliter,
						MaxVolume -> 2.5 Liter
					],
					Association[
						Object -> objectID1,
						Type -> Object[Container, Vessel, Filter],
						Model -> Link[Model[Container, Vessel, Filter, "id:KBL5DvYOxMWa"], Objects],
						Name -> "Filter Test two-part filter (top portion)" <> $SessionUUID,
						DeveloperObject -> True,
						Site -> Link[$Site]
					],
					Association[
						Type -> Object[Container, Vessel],
						Model -> Link[Model[Container, Vessel, "id:AEqRl954GGbp"], Objects],
						Name -> "Filter Test two-part filter (bottom portion)" <> $SessionUUID,
						Replace[KitComponents] -> {Link[objectID1, KitComponents]},
						DeveloperObject -> True,
						Site -> Link[$Site]
					],
					Association[
						Type -> Object[Container, Plate, Filter],
						Model -> Link[Model[Container, Plate, Filter, "id:eGakld0955Lo"], Objects],
						Name -> "Filter plate 1" <> $SessionUUID,
						DeveloperObject -> True,
						Site -> Link[$Site]
					],
					Association[
						Type -> Object[Container, Plate, Filter],
						Model -> Link[Model[Container, Plate, Filter, "id:eGakld0955Lo"], Objects],
						Name -> "Filter plate 2" <> $SessionUUID,
						DeveloperObject -> True,
						Site -> Link[$Site]
					],
					Association[
						Type -> Object[Container, Plate],
						Model -> Link[Model[Container, Plate, "96-well UV-Star Plate"], Objects],
						Name -> "CollectionContainer plate 1" <> $SessionUUID,
						DeveloperObject -> True,
						Site -> Link[$Site]
					],
					Association[
						Object -> objectID2,
						Type -> Object[Container, Vessel, Filter],
						Model -> Link[Model[Container, Vessel, Filter, "0.5 mL Ultracel 50k Centrifuge Filter"], Objects],
						Name -> "Filter Test Invertable Centrifuge Filter" <> $SessionUUID,
						Replace[KitComponents] -> {Link[objectID3, KitComponents], Link[objectID4, KitComponents]},
						DeveloperObject -> True,
						Site -> Link[$Site]
					],
					Association[
						Object -> objectID3,
						Type -> Object[Container, Vessel],
						Model -> Link[Model[Container, Vessel, "1.5mL Microcentrifuge Tube for Centrifugation Filtering Kit"], Objects],
						Name -> "Filter Test Invertable Centrifuge Filter Collection Tube 1" <> $SessionUUID,
						Replace[KitComponents] -> {Link[objectID2, KitComponents], Link[objectID4, KitComponents]},
						DeveloperObject -> True,
						Site -> Link[$Site]
					],
					Association[
						Object -> objectID4,
						Type -> Object[Container, Vessel],
						Model -> Link[Model[Container, Vessel, "1.5mL Microcentrifuge Tube for Centrifugation Filtering Kit"], Objects],
						Name -> "Filter Test Invertable Centrifuge Filter Collection Tube 2" <> $SessionUUID,
						Replace[KitComponents] -> {Link[objectID2, KitComponents], Link[objectID3, KitComponents]},
						DeveloperObject -> True,
						Site -> Link[$Site]
					],
					Association[
						DeveloperObject->True,
						Type->Object[Container, Vessel],
						Model->Link[Model[Container, Vessel, "2mL Tube"], Objects],
						Name -> "Filter Test tube with cell sample "<>$SessionUUID,
						DeveloperObject -> True,
						Site -> Link[$Site]
					],
					Association[
						DeveloperObject->True,
						Type-> Model[Container, Plate],
						Name -> "Filter Test plate model without counterweights"<>$SessionUUID,
						NumberOfWells->6,
						AspectRatio->3/2,
						Footprint->Plate,
						Dimensions->{Quantity[0.12776`, "Meters"],Quantity[0.08548`, "Meters"],Quantity[0.016059999999999998`, "Meters"]},
						Replace[Positions]->{
							<|Name -> "A1", Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>,
							<|Name -> "A2", Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>,
							<|Name -> "A3", Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>,
							<|Name -> "B1", Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>,
							<|Name -> "B2", Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>,
							<|Name -> "B3", Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>
						},
						Replace[PositionPlotting]->{
							<|Name -> "A1", XOffset->0.024765 Meter,YOffset->0.062295 Meter,ZOffset->0.00254 Meter, CrossSectionalShape->Circle,Rotation->0.|>,
							<|Name -> "A2", XOffset->0.063885 Meter,YOffset->0.062295 Meter,ZOffset->0.00254 Meter, CrossSectionalShape->Circle,Rotation->0.|>,
							<|Name -> "A3", XOffset->0.103005 Meter,YOffset->0.062295 Meter,ZOffset->0.00254 Meter, CrossSectionalShape->Circle,Rotation->0.|>,
							<|Name -> "B1", XOffset->0.024765 Meter,YOffset->0.023175 Meter,ZOffset->0.00254 Meter, CrossSectionalShape->Circle,Rotation->0.|>,
							<|Name -> "B2", XOffset->0.063885 Meter,YOffset->0.023175 Meter,ZOffset->0.00254 Meter, CrossSectionalShape->Circle,Rotation->0.|>,
							<|Name -> "B3", XOffset->0.103005 Meter,YOffset->0.023175 Meter,ZOffset->0.00254 Meter, CrossSectionalShape->Circle,Rotation->0.|>
						},
						WellDiameter->35.1 Millimeter,
						WellDepth->13 Millimeter,
						Columns->3,
						HorizontalMargin->7.045 Millimeter,
						HorizontalPitch->39.12 Millimeter,
						MaxCentrifugationForce->10000 GravitationalAcceleration,
						TareWeight->33.19 Gram,
						Rows->2,
						VerticalMargin->5.445 Millimeter,
						VerticalPitch->39.12 Millimeter,
						DepthMargin->1.27 Millimeter
					],
					Association[
						DeveloperObject->True,
						Type-> Model[Container, Plate],
						Name -> "Filter Test plate model without TareWeight"<>$SessionUUID,
						NumberOfWells->6,
						AspectRatio->3/2,
						Footprint->Plate,
						Dimensions->{Quantity[0.12776`, "Meters"],Quantity[0.08548`, "Meters"],Quantity[0.016059999999999998`, "Meters"]},
						Replace[Positions]->{
							<|Name -> "A1", Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>,
							<|Name -> "A2", Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>,
							<|Name -> "A3", Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>,
							<|Name -> "B1", Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>,
							<|Name -> "B2", Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>,
							<|Name -> "B3", Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>
						},
						Replace[PositionPlotting]->{
							<|Name -> "A1", XOffset->0.024765 Meter,YOffset->0.062295 Meter,ZOffset->0.00254 Meter, CrossSectionalShape->Circle,Rotation->0.|>,
							<|Name -> "A2", XOffset->0.063885 Meter,YOffset->0.062295 Meter,ZOffset->0.00254 Meter, CrossSectionalShape->Circle,Rotation->0.|>,
							<|Name -> "A3", XOffset->0.103005 Meter,YOffset->0.062295 Meter,ZOffset->0.00254 Meter, CrossSectionalShape->Circle,Rotation->0.|>,
							<|Name -> "B1", XOffset->0.024765 Meter,YOffset->0.023175 Meter,ZOffset->0.00254 Meter, CrossSectionalShape->Circle,Rotation->0.|>,
							<|Name -> "B2", XOffset->0.063885 Meter,YOffset->0.023175 Meter,ZOffset->0.00254 Meter, CrossSectionalShape->Circle,Rotation->0.|>,
							<|Name -> "B3", XOffset->0.103005 Meter,YOffset->0.023175 Meter,ZOffset->0.00254 Meter, CrossSectionalShape->Circle,Rotation->0.|>
						},
						MaxVolume->2 Milliliter,
						WellDiameter->35.1 Millimeter,
						WellDepth->13 Millimeter,
						Columns->3,
						HorizontalMargin->7.045 Millimeter,
						HorizontalPitch->39.12 Millimeter,
						MaxCentrifugationForce->10000 GravitationalAcceleration,
						Rows->2,
						LiquidHandlerPrefix-> "withoutTare1", 
						VerticalMargin->5.445 Millimeter,
						VerticalPitch->39.12 Millimeter,
						DepthMargin->1.27 Millimeter
					],
					Association[
						DeveloperObject->True,
						Type-> Model[Container, Plate],
						Name -> "Filter Test tall plate model"<>$SessionUUID,
						NumberOfWells->6,
						AspectRatio->3/2,
						Footprint->Plate,
						Dimensions->{Quantity[0.12776`, "Meters"],Quantity[0.08548`, "Meters"],Quantity[50`, "Millimeters"]},
						Replace[Positions]->{
							<|Name -> "A1", Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>,
							<|Name -> "A2", Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>,
							<|Name -> "A3", Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>,
							<|Name -> "B1", Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>,
							<|Name -> "B2", Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>,
							<|Name -> "B3", Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>
						},
						Replace[PositionPlotting]->{
							<|Name -> "A1", XOffset->0.024765 Meter,YOffset->0.062295 Meter,ZOffset->0.00254 Meter, CrossSectionalShape->Circle,Rotation->0.|>,
							<|Name -> "A2", XOffset->0.063885 Meter,YOffset->0.062295 Meter,ZOffset->0.00254 Meter, CrossSectionalShape->Circle,Rotation->0.|>,
							<|Name -> "A3", XOffset->0.103005 Meter,YOffset->0.062295 Meter,ZOffset->0.00254 Meter, CrossSectionalShape->Circle,Rotation->0.|>,
							<|Name -> "B1", XOffset->0.024765 Meter,YOffset->0.023175 Meter,ZOffset->0.00254 Meter, CrossSectionalShape->Circle,Rotation->0.|>,
							<|Name -> "B2", XOffset->0.063885 Meter,YOffset->0.023175 Meter,ZOffset->0.00254 Meter, CrossSectionalShape->Circle,Rotation->0.|>,
							<|Name -> "B3", XOffset->0.103005 Meter,YOffset->0.023175 Meter,ZOffset->0.00254 Meter, CrossSectionalShape->Circle,Rotation->0.|>
						},
						WellDiameter->35.1 Millimeter,
						WellDepth->13 Millimeter,
						Columns->3,
						HorizontalMargin->7.045 Millimeter,
						HorizontalPitch->39.12 Millimeter,
						MaxCentrifugationForce->10000 GravitationalAcceleration,
						TareWeight->33.19 Gram,
						Rows->2,
						VerticalMargin->5.445 Millimeter,
						VerticalPitch->39.12 Millimeter,
						DepthMargin->1.27 Millimeter
					],
					Association[
						DeveloperObject->True,
						Type-> Model[Container, Plate],
						Name -> "Filter Test heavy plate model"<>$SessionUUID,
						NumberOfWells->6,
						AspectRatio->3/2,
						Footprint->Plate,
						Dimensions->{Quantity[0.12776`, "Meters"],Quantity[0.08548`, "Meters"],Quantity[0.016059999999999998`, "Meters"]},
						Replace[Positions]->{
							<|Name -> "A1", Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>,
							<|Name -> "A2", Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>,
							<|Name -> "A3", Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>,
							<|Name -> "B1", Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>,
							<|Name -> "B2", Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>,
							<|Name -> "B3", Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>
						},
						Replace[PositionPlotting]->{
							<|Name -> "A1", XOffset->0.024765 Meter,YOffset->0.062295 Meter,ZOffset->0.00254 Meter, CrossSectionalShape->Circle,Rotation->0.|>,
							<|Name -> "A2", XOffset->0.063885 Meter,YOffset->0.062295 Meter,ZOffset->0.00254 Meter, CrossSectionalShape->Circle,Rotation->0.|>,
							<|Name -> "A3", XOffset->0.103005 Meter,YOffset->0.062295 Meter,ZOffset->0.00254 Meter, CrossSectionalShape->Circle,Rotation->0.|>,
							<|Name -> "B1", XOffset->0.024765 Meter,YOffset->0.023175 Meter,ZOffset->0.00254 Meter, CrossSectionalShape->Circle,Rotation->0.|>,
							<|Name -> "B2", XOffset->0.063885 Meter,YOffset->0.023175 Meter,ZOffset->0.00254 Meter, CrossSectionalShape->Circle,Rotation->0.|>,
							<|Name -> "B3", XOffset->0.103005 Meter,YOffset->0.023175 Meter,ZOffset->0.00254 Meter, CrossSectionalShape->Circle,Rotation->0.|>
						},
						WellDiameter->35.1 Millimeter,
						WellDepth->13 Millimeter,
						Columns->3,
						HorizontalMargin->7.045 Millimeter,
						HorizontalPitch->39.12 Millimeter,
						MaxCentrifugationForce->10000 GravitationalAcceleration,
						TareWeight->320 Gram,
						Rows->2,
						VerticalMargin->5.445 Millimeter,
						VerticalPitch->39.12 Millimeter,
						DepthMargin->1.27 Millimeter
					],
					Association[
						Type -> Model[Container, Plate, Filter],
						Name -> "Filter Test Large Plate Filter Model" <> $SessionUUID,
						AspectRatio -> 3/2,
						Columns -> 12,
						CrossSectionalShape -> Rectangle,
						DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
						DepthMargin -> Quantity[1.08, "Millimeters"],
						Dimensions -> {Quantity[0.128, "Meters"], Quantity[0.1, "Meters"], Quantity[0.033, "Meters"]},
						Footprint -> Plate,
						HorizontalMargin -> Quantity[10.75, "Millimeters"],
						HorizontalOffset -> Quantity[0., "Millimeters"],
						HorizontalPitch -> Quantity[8.96727, "Millimeters"],
						LiquidHandlerPrefix -> "AcroPrep_1mL", 
						MaxTemperature -> Quantity[40., "DegreesCelsius"],
						MaxVolume -> Quantity[1., "Milliliters"],
						MembraneMaterial -> PES,
						MinTemperature -> Quantity[-20., "DegreesCelsius"],
						MinVolume -> Quantity[0.05, "Milliliters"],
						NozzleHeight -> Quantity[0., "Millimeters"],
						NumberOfWells -> 96,
						PlateColor -> Natural,
						(* Avoid finding a real filter. Use a random PoreSize *)
						PoreSize -> Quantity[0.987654, "Micrometers"],
						RecommendedFillVolume -> Quantity[900., "Microliters"],
						Reusable -> False,
						Rows -> 8,
						SkirtHeight -> Quantity[35., "Millimeters"],
						Treatment -> PolyethersulfoneFilter,
						VerticalMargin -> Quantity[7.62, "Millimeters"],
						VerticalOffset -> Quantity[0., "Millimeters"],
						VerticalPitch -> Quantity[9.01571, "Millimeters"],
						WellBottom -> FlatBottom, WellColor -> Natural,
						WellDepth -> Quantity[31.48, "Millimeters"],
						WellDiameter -> Quantity[7.4, "Millimeters"],
						Replace[CoverFootprints] -> {LidSBSUniversal, SealSBS, SBSPlateLid},
						Replace[CoverTypes] -> {Seal, Place},
						Replace[ContainerMaterials] -> {Polypropylene},
						Replace[PositionPlotting] -> Download[Model[Container, Plate, Filter, "id:eGakld0955Lo"], PositionPlotting],
						Replace[Positions] -> Download[Model[Container, Plate, Filter, "id:eGakld0955Lo"], Positions],
						DeveloperObject -> True
					]

				}
			];

			secondUpload = ECL`InternalUpload`UploadSample[
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
					Model[Sample, "E.coli MG1655"]
				},
				{
					{"A1", Object[Container, Vessel, "Filter Test Container for 3L sample (I)" <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "Filter Test Container for 3L sample (II)" <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "Filter Test Container for 3L sample (III)" <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "Filter Test Container for 2L sample" <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "Filter Test Container for 500 mL sample" <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "Filter Test Container for 1mL sample" <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "Filter Test Container for volume-less sample" <> $SessionUUID]},
					{"A1", Object[Container, Plate, Filter, "Filter plate 1" <> $SessionUUID]},
					{"A2", Object[Container, Plate, Filter, "Filter plate 2" <> $SessionUUID]},
					{"A3", Object[Container, Plate, Filter, "Filter plate 2" <> $SessionUUID]},
					{"A1", Object[Container, Vessel, Filter, "Filter Test two-part filter (top portion)" <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "Filter Test tube with cell sample " <> $SessionUUID]}
				},
				InitialAmount -> {
					3 Liter,
					3 Liter,
					3 Liter,
					2 Liter,
					0.5 Liter,
					15 Milliliter,
					1 Milliliter,
					Null,
					0.2 Milliliter,
					0.2 Milliliter,
					0.2 Milliliter,
					0.5 Liter,
					1 Milliliter
				},
				Name -> {
					"Filter Test Sample with 3L (I)" <> $SessionUUID,
					"Filter Test Sample with 3L (II)" <> $SessionUUID,
					"Filter Test Sample with 3L (no model) (III)" <> $SessionUUID,
					"Filter Test Sample with 2L" <> $SessionUUID,
					"Filter Test Sample with 500 mL" <> $SessionUUID,
					"Filter Test Sample with 15mL" <> $SessionUUID,
					"Filter Test Sample with 1mL" <> $SessionUUID,
					"Filter Test Sample without volume" <> $SessionUUID,
					"Filter Sample in filter plate 1" <> $SessionUUID,
					"Filter Sample 1 in filter plate 2" <> $SessionUUID,
					"Filter Sample 2 in filter plate 2" <> $SessionUUID,
					"Filter Test Sample with 500 mL (II)" <> $SessionUUID,
					"Filter Test cell sample 1 " <> $SessionUUID
				}
			];

			Upload[
				{
					Association[
						Object -> Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID],
						Replace[Composition] -> {
							{100 VolumePercent, Link[Model[Molecule, "Water"]],Now},
							{5 Millimolar, Link[Model[Molecule, "Uracil"]],Now}
						},
						DeveloperObject -> True
					],
					Association[Object -> Object[Sample, "Filter Sample in filter plate 1" <> $SessionUUID], DeveloperObject -> True],
					Association[Object -> Object[Sample, "Filter Sample 1 in filter plate 2" <> $SessionUUID], DeveloperObject -> True],
					Association[Object -> Object[Sample, "Filter Sample 2 in filter plate 2" <> $SessionUUID], DeveloperObject -> True],
					Association[Object -> Object[Sample, "Filter Test Sample with 3L (no model) (III)" <> $SessionUUID], Model -> Null, DeveloperObject -> True],
					Association[
						DeveloperObject->True,
						Type->Object[Container, Plate],
						Model->Link[Model[Container, Plate, "Filter Test plate model without counterweights"<>$SessionUUID], Objects],
						Name -> "Filter Test plate without counterweights"<>$SessionUUID
					],
					Association[
						DeveloperObject->True,
						Type->Object[Container, Plate],
						Model->Link[Model[Container, Plate, "Filter Test plate model without TareWeight"<>$SessionUUID], Objects],
						Name -> "Filter Test plate without TareWeight"<>$SessionUUID
					],
					Association[
						DeveloperObject->True,
						Type->Object[Container, Plate],
						Model->Link[Model[Container, Plate, "Filter Test tall plate model"<>$SessionUUID], Objects],
						Name -> "Filter Test tall plate"<>$SessionUUID
					],
					Association[
						DeveloperObject->True,
						Type->Object[Container, Plate],
						Model->Link[Model[Container, Plate, "Filter Test heavy plate model"<>$SessionUUID], Objects],
						Name -> "Filter Test heavy plate"<>$SessionUUID
					]
				}
			];
		];

		(* make an MSP protocol to use as a ParentProtocol so we can interrogate the actual Object[Protocol, Filter]. *)
		ExperimentManualSamplePreparation[
			{
				LabelSample[Label -> "cool sample", Sample-> Model[Sample, "Milli-Q water"], Amount -> 1 Milliliter, Container -> Model[Container, Vessel, "50mL Tube"]]
			},
			Name -> "Test MSP for ExperimentFilter unit tests" <> $SessionUUID
		]
	),
	SymbolTearDown :> Module[{objects, existsFilter},
		(* list of test objects*)
		objects = {
			Object[Sample, "Filter Test Sample with 3L (I)" <> $SessionUUID],
			Object[Sample, "Filter Test Sample with 3L (II)" <> $SessionUUID],
			Object[Sample, "Filter Test Sample with 3L (no model) (III)" <> $SessionUUID],
			Object[Container, Vessel, "Filter Test Container for 3L sample (I)" <> $SessionUUID],
			Object[Container, Vessel, "Filter Test Container for 3L sample (II)" <> $SessionUUID],
			Object[Container, Vessel, "Filter Test Container for 3L sample (III)" <> $SessionUUID],

			Object[Sample, "Filter Test Sample with 2L" <> $SessionUUID],
			Object[Container, Vessel, "Filter Test Container for 2L sample" <> $SessionUUID],

			Object[Sample, "Filter Test Sample with 15mL" <> $SessionUUID],
			Object[Sample, "Filter Test Sample with 500 mL (II)" <> $SessionUUID],
			Object[Sample, "Filter Test Sample with 500 mL" <> $SessionUUID],
			Object[Container, Vessel, "Filter Test Container for 500 mL sample" <> $SessionUUID],
			Object[Container, Vessel, Filter, "Filter Test two-part filter (top portion)" <> $SessionUUID],
			Object[Container, Vessel, "Filter Test two-part filter (bottom portion)" <> $SessionUUID],

			Object[Container, Vessel, Filter, "Filter Test Invertable Centrifuge Filter" <> $SessionUUID],
			Object[Container, Vessel, "Filter Test Invertable Centrifuge Filter Collection Tube 1" <> $SessionUUID],
			Object[Container, Vessel, "Filter Test Invertable Centrifuge Filter Collection Tube 2" <> $SessionUUID],

			Object[Container, Vessel, "Filter Test Container for 15mL sample" <> $SessionUUID],

			Object[Sample, "Filter Test Sample with 1mL" <> $SessionUUID],
			Object[Container, Vessel, "Filter Test Container for 1mL sample" <> $SessionUUID],

			Object[Sample, "Filter Test Sample without volume" <> $SessionUUID],
			Object[Container, Vessel, "Filter Test Container for volume-less sample" <> $SessionUUID],

			Model[Instrument, PeristalticPump, "Filter Test Peristaltic Pump" <> $SessionUUID],
			Model[Container, Vessel, "Filter Test Container with 4L Max Volume" <> $SessionUUID],
			Model[Item, Filter, "Filter Test Membrane Filter" <> $SessionUUID],
			Model[Item, Filter, "Filter Test Membrane Filter with LuerSlip" <> $SessionUUID],
			Model[Container, Plate, Filter, "Filter Test Large Plate Filter Model" <> $SessionUUID],

			Object[Protocol, Filter, "Filter Test Template Protocol" <> $SessionUUID],

			Object[Container, Plate, Filter, "Filter plate 1" <> $SessionUUID],
			Object[Container, Plate, Filter, "Filter plate 2" <> $SessionUUID],

			Object[Container, Plate, "CollectionContainer plate 1" <> $SessionUUID],

			Object[Sample, "Filter Sample in filter plate 1" <> $SessionUUID],
			Object[Sample, "Filter Sample 1 in filter plate 2" <> $SessionUUID],
			Object[Sample, "Filter Sample 2 in filter plate 2" <> $SessionUUID],
			Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentFilter unit tests" <> $SessionUUID],

			Object[Container, Vessel, "Filter Test tube with cell sample " <> $SessionUUID],
			Object[Sample, "Filter Test cell sample 1 " <> $SessionUUID]
		};

		(* Check whether the names we want to give below already exist in the database *)
		existsFilter = DatabaseMemberQ[objects];

		(* Erase any objects that we failed to erase in the last unit test. *)
		Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];

	]
];

(* ::Subsection::Closed:: *)
(*ExperimentFilterOptions*)


DefineTests[
	ExperimentFilterOptions,
	{
	(* --- Basic Examples --- *)
		Example[{Basic, "Generate a table of resolved options for an ExperimentFilter call to filter a single sample:"},
			ExperimentFilterOptions[Object[Sample, "Filter Test Sample for ExperimentFilterOptions (I)"]],
			_Grid
		],
		Example[{Basic, "Generate a table of resolved options for an ExperimentFilter call to filter a single container:"},
			ExperimentFilterOptions[Object[Container, Vessel, "Filter Test Container for ExperimentFilterOptions (I)"]],
			_Grid
		],
		Example[{Basic, "Generate a table of resolved options for an ExperimentFilter call to filter a sample and a container the same time:"},
			ExperimentFilterOptions[{
				Object[Sample, "Filter Test Sample for ExperimentFilterOptions (I)"],
				Object[Container, Vessel, "Filter Test Container for ExperimentFilterOptions (II)"]
			}],
			_Grid
		],


	(* --- Options Examples --- *)
		Example[{Options, OutputFormat, "Generate a resolved list of options for an ExperimentFilter call to filter a single container:"},
			ExperimentFilterOptions[Object[Sample, "Filter Test Sample for ExperimentFilterOptions (I)"], OutputFormat->List],
			_?(MatchQ[
				Check[SafeOptions[ExperimentFilter, #], $Failed, {Error::Pattern}],
				{(_Rule|_RuleDelayed)..}
			]&)
		]
	},
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		$CreatedObjects = {};
		Module[{objects, existsFilter},
			(* list of test objects*)
			objects = {
				Object[Sample, "Filter Test Sample for ExperimentFilterOptions (I)"],
				Object[Container, Vessel, "Filter Test Container for ExperimentFilterOptions (I)"],
				Object[Sample, "Filter Test Sample for ExperimentFilterOptions (II)"],
				Object[Container, Vessel, "Filter Test Container for ExperimentFilterOptions (II)"]
			};
	
			(* Check whether the names we want to give below already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];
	
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force->True, Verbose-> False]];
			Upload[
				{
					Association[
						Type->Object[Container, Vessel],
						Model->Link[Model[Container, Vessel, "50mL Tube"], Objects],
						Name -> "Filter Test Container for ExperimentFilterOptions (I)", 
						DeveloperObject->True,
						Site -> Link[$Site]
					],
					Association[
						Type->Object[Container, Vessel],
						Model->Link[Model[Container, Vessel, "50mL Tube"], Objects],
						Name -> "Filter Test Container for ExperimentFilterOptions (II)", 
						DeveloperObject->True,
						Site -> Link[$Site]
					]
				}
			];
	
			ECL`InternalUpload`UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				{
					{"A1", Object[Container, Vessel, "Filter Test Container for ExperimentFilterOptions (I)"]},
					{"A1", Object[Container, Vessel, "Filter Test Container for ExperimentFilterOptions (II)"]}
				},
				InitialAmount -> 15 Milliliter,
				Name -> {
					"Filter Test Sample for ExperimentFilterOptions (I)", 
					"Filter Test Sample for ExperimentFilterOptions (II)"
				}
			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
	)
];



(* ::Subsection::Closed:: *)
(*ExperimentFilterPreview*)


DefineTests[
	ExperimentFilterPreview,
	{
	(* --- Basic Examples --- *)
		Example[{Basic, "Generate a preview for an ExperimentFilter call to filter a single container (will always be Null:"},
			ExperimentFilterPreview[Object[Container, Vessel, "Filter Test Container for ExperimentFilterPreview (I)"]],
			Null
		],
		Example[{Basic, "Generate a preview for an ExperimentFilter call to filter two containers at the same time:"},
			ExperimentFilterPreview[{
				Object[Sample, "Filter Test Sample for ExperimentFilterPreview (I)"],
				Object[Container, Vessel, "Filter Test Container for ExperimentFilterPreview (II)"]
			}],
			Null
		],
		Example[{Basic, "Generate a preview for an ExperimentFilter call to filter a single sample:"},
			ExperimentFilterPreview[Object[Sample, "Filter Test Sample for ExperimentFilterPreview (I)"]],
			Null
		]
	},
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		$CreatedObjects = {};
    Module[{objects , existsFilter},
			(* list of test objects*)
			objects = {
				Object[Sample, "Filter Test Sample for ExperimentFilterPreview (I)"],
				Object[Container, Vessel, "Filter Test Container for ExperimentFilterPreview (I)"],
				Object[Sample, "Filter Test Sample for ExperimentFilterPreview (II)"],
				Object[Container, Vessel, "Filter Test Container for ExperimentFilterPreview (II)"]
			};

			(* Check whether the names we want to give below already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force->True, Verbose-> False]];
			Upload[
				{
					Association[
						Type -> Object[Container, Vessel],
						Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
						Name -> "Filter Test Container for ExperimentFilterPreview (I)",
						DeveloperObject -> True,
						Site -> Link[$Site]
					],
					Association[
						Type->Object[Container, Vessel],
						Model->Link[Model[Container, Vessel, "50mL Tube"], Objects],
						Name -> "Filter Test Container for ExperimentFilterPreview (II)",
						DeveloperObject->True,
						Site -> Link[$Site]
					]
				}
			];

			ECL`InternalUpload`UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				{
					{"A1", Object[Container, Vessel, "Filter Test Container for ExperimentFilterPreview (I)"]},
					{"A1", Object[Container, Vessel, "Filter Test Container for ExperimentFilterPreview (II)"]}
				},
				InitialAmount->15 Milliliter,
				Name -> {
					"Filter Test Sample for ExperimentFilterPreview (I)",
					"Filter Test Sample for ExperimentFilterPreview (II)"
				}
			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
	)
];


(* ::Subsection::Closed:: *)
(*ValidExperimentFilterQ*)


DefineTests[
	ValidExperimentFilterQ,
	{
	(* --- Basic Examples --- *)
		Example[{Basic, "Validate an ExperimentFilter call to filter a single container:"},
			ValidExperimentFilterQ[Object[Container, Vessel, "Filter Test Container for ExperimentValidExperimentFilterQ (I)" <> $SessionUUID]],
			True
		],
		Example[{Basic, "Validate an ExperimentFilter call to filter two containers at the same time:"},
			ValidExperimentFilterQ[{
				Object[Sample, "Filter Test Sample for ExperimentValidExperimentFilterQ (I)" <> $SessionUUID],
				Object[Container, Vessel, "Filter Test Container for ExperimentValidExperimentFilterQ (II)" <> $SessionUUID]
			}],
			True
		],
		Example[{Basic, "Validate an ExperimentFilter call to filter a single sample:"},
			ValidExperimentFilterQ[Object[Sample, "Filter Test Sample for ExperimentValidExperimentFilterQ (I)" <> $SessionUUID]],
			True
		],

	(* --- Options Examples --- *)
		Example[{Options, OutputFormat, "Validate an ExperimentFilter call to filter a single container, returning an ECL Test Summary:"},
			ValidExperimentFilterQ[Object[Container, Vessel, "Filter Test Container for ExperimentValidExperimentFilterQ (I)" <> $SessionUUID], OutputFormat -> TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose, "Validate an ExperimentFilter call to filter a single container, printing a verbose summary of tests as they are run:"},
			ValidExperimentFilterQ[Object[Container, Vessel, "Filter Test Container for ExperimentValidExperimentFilterQ (I)" <> $SessionUUID], Verbose -> True],
			True
		]
	},
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		$CreatedObjects = {};
    Module[{objects, existsFilter},
			(* list of test objects*)
			objects = {
				Object[Sample, "Filter Test Sample for ExperimentValidExperimentFilterQ (I)" <> $SessionUUID],
				Object[Container, Vessel, "Filter Test Container for ExperimentValidExperimentFilterQ (I)" <> $SessionUUID],
				Object[Sample, "Filter Test Sample for ExperimentValidExperimentFilterQ (II)" <> $SessionUUID],
				Object[Container, Vessel, "Filter Test Container for ExperimentValidExperimentFilterQ (II)" <> $SessionUUID]
			};

			(* Check whether the names we want to give below already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force->True, Verbose-> False]];
			Upload[
				{
					Association[
						Type->Object[Container, Vessel],
						Model->Link[Model[Container, Vessel, "50mL Tube"], Objects],
						Name -> "Filter Test Container for ExperimentValidExperimentFilterQ (I)" <> $SessionUUID,
						DeveloperObject->True,
						Site -> Link[$Site]
					],
					Association[
						Type->Object[Container, Vessel],
						Model->Link[Model[Container, Vessel, "50mL Tube"], Objects],
						Name -> "Filter Test Container for ExperimentValidExperimentFilterQ (II)" <> $SessionUUID,
						DeveloperObject->True,
						Site -> Link[$Site]
					]
				}
			];

			ECL`InternalUpload`UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				{
					{"A1", Object[Container, Vessel, "Filter Test Container for ExperimentValidExperimentFilterQ (I)" <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "Filter Test Container for ExperimentValidExperimentFilterQ (II)" <> $SessionUUID]}
				},
				InitialAmount -> 15 Milliliter,
				Name -> {
					"Filter Test Sample for ExperimentValidExperimentFilterQ (I)" <> $SessionUUID,
					"Filter Test Sample for ExperimentValidExperimentFilterQ (II)" <> $SessionUUID
				}
			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects, Force->True, Verbose-> False];
	)
];


(* ::Subsection::Closed:: *)
(*resolveFilterMethod*)

DefineTests[resolveFilterMethod,
	{
		Test["If everything is normal, then allow robotic and manual sample preparations:",
			resolveFilterMethod[{Object[Sample, "resolveFilterMethod Normal Sample 1" <> $SessionUUID], Object[Sample, "resolveFilterMethod Normal Sample 2" <> $SessionUUID]}],
			{Manual, Robotic}
		],
		Test["Properly resolves if input is {Automatic} (when function is called inside ValidateUnitOperationsJSON for Command Builder or during pre-resolution of Unit Operation inputs):",
			resolveFilterMethod[{Automatic}],
			{Manual, Robotic}
		],
		Test["Do not allow robotic preparation if the input sample does not have a liquid handler compatible footprint:", 
			resolveFilterMethod[Object[Sample, "resolveFilterMethod Sample in Non-LiquidHandler-Compatible Container 1" <> $SessionUUID]],
			Manual
		],
		Test["Do not allow robotic preparation if a sample in the options (in this case, ResuspensionBuffer) does not have a liquid handler compatible footprint:", 
			resolveFilterMethod[Object[Sample, "resolveFilterMethod Normal Sample 1" <> $SessionUUID], ResuspensionBuffer -> Object[Sample, "resolveFilterMethod Sample in Non-LiquidHandler-Compatible Container 2" <> $SessionUUID]],
			Manual
		],
		Test["Do not allow RoboticSamplePreparation if a sample needs too much volume transferred:", 
			resolveFilterMethod[Object[Sample, "resolveFilterMethod Sample With High Volume (40 mL)" <> $SessionUUID]],
			Manual
		],
		Test["Do not allow RoboticSamplePreparation if a sample is itself liquid handler incompatible:", 
			resolveFilterMethod[Object[Sample, "resolveFilterMethod Sample that is LiquidHandler-Incompatible 1" <> $SessionUUID]],
			Manual
		],
		Test["Properly resolves if taking in a plate and a sample (in this case a plate has a liquid handler incompatible sample in it):", 
			resolveFilterMethod[{Object[Container, Plate, "resolveFilterMethod Plate 1" <> $SessionUUID], Object[Sample, "resolveFilterMethod Normal Sample 1" <> $SessionUUID]}],
			Manual
		],
		Test["If FiltrationType is only supported by manual preparation (in this case, PeristalticPump), then only allow manaul sample preparations:", 
			resolveFilterMethod[{Object[Sample, "resolveFilterMethod Normal Sample 1" <> $SessionUUID], Object[Sample, "resolveFilterMethod Normal Sample 2" <> $SessionUUID]},FiltrationType->PeristalticPump],
			Manual
		],
		Test["If FiltrationType is only supported by robotic preparation (in this case, AirPressure), then only allow robotic sample preparations:", 
			resolveFilterMethod[{Object[Sample, "resolveFilterMethod Normal Sample 1" <> $SessionUUID], Object[Sample, "resolveFilterMethod Normal Sample 2" <> $SessionUUID]},FiltrationType->AirPressure],
			Robotic
		]
		
		(* Test for where a sample is liquid handler incompatible *)
		(* Test where we're using a plate *)
	},
	SymbolSetUp :> (
		Module[{objects, existsFilter},
			objects = {
				Object[Sample, "resolveFilterMethod Normal Sample 1" <> $SessionUUID],
				Object[Sample, "resolveFilterMethod Normal Sample 2" <> $SessionUUID],
				Object[Sample, "resolveFilterMethod Normal Sample 3" <> $SessionUUID],
				Object[Sample, "resolveFilterMethod Sample in Non-LiquidHandler-Compatible Container 1" <> $SessionUUID],
				Object[Sample, "resolveFilterMethod Sample in Non-LiquidHandler-Compatible Container 2" <> $SessionUUID],
				Object[Sample, "resolveFilterMethod Sample With High Volume (40 mL)" <> $SessionUUID],
				Object[Sample, "resolveFilterMethod Sample that is LiquidHandler-Incompatible 1" <> $SessionUUID],
				
				Object[Container, Vessel, "resolveFilterMethod Vessel 1" <> $SessionUUID],
				Object[Container, Vessel, "resolveFilterMethod Vessel 2" <> $SessionUUID],
				Object[Container, Vessel, "resolveFilterMethod Vessel 3 (LiquidHandler-Incompatible)" <> $SessionUUID],
				Object[Container, Vessel, "resolveFilterMethod Vessel 4 (LiquidHandler-Incompatible)" <> $SessionUUID],
				Object[Container, Vessel, "resolveFilterMethod Vessel 5" <> $SessionUUID],
				
				Object[Container, Plate, "resolveFilterMethod Plate 1" <> $SessionUUID]
			};
			
			(* Check whether the names we want to give below already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];
			
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
		
		];
		Module[{vessel1, vessel2, vessel3, vessel4, vessel5, sample1, sample2, sample3, sample4, sample5, sample6, sample7, plate1},
			{
				vessel1,
				vessel2,
				vessel3,
				vessel4,
				vessel5,
				plate1
			} = Upload[{
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
					Name -> "resolveFilterMethod Vessel 1" <> $SessionUUID, 
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
					Name -> "resolveFilterMethod Vessel 2" <> $SessionUUID, 
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "1mL clear glass ampule"], Objects],
					Name -> "resolveFilterMethod Vessel 3 (LiquidHandler-Incompatible)" <> $SessionUUID, 
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "1mL clear glass ampule"], Objects],
					Name -> "resolveFilterMethod Vessel 4 (LiquidHandler-Incompatible)" <> $SessionUUID, 
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "resolveFilterMethod Vessel 5" <> $SessionUUID, 
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Name -> "resolveFilterMethod Plate 1" <> $SessionUUID, 
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>
			}];
			
			{
				sample1,
				sample2,
				sample3,
				sample4,
				sample5,
				sample6,
				sample7
			} = UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Sulfuric acid"]
				},
				{
					{"A1", vessel1},
					{"A1", vessel2},
					{"A1", plate1},
					{"A1", vessel3},
					{"A1", vessel4},
					{"A1", vessel5},
					{"A2", plate1}
				},
				InitialAmount -> {
					1 Milliliter,
					1 Milliliter,
					1 Milliliter,
					1 Milliliter,
					1 Milliliter,
					40 Milliliter,
					1 Milliliter
				},
				Name -> {
					"resolveFilterMethod Normal Sample 1" <> $SessionUUID, 
					"resolveFilterMethod Normal Sample 2" <> $SessionUUID, 
					"resolveFilterMethod Normal Sample 3" <> $SessionUUID, 
					"resolveFilterMethod Sample in Non-LiquidHandler-Compatible Container 1" <> $SessionUUID, 
					"resolveFilterMethod Sample in Non-LiquidHandler-Compatible Container 2" <> $SessionUUID, 
					"resolveFilterMethod Sample With High Volume (40 mL)" <> $SessionUUID, 
					"resolveFilterMethod Sample that is LiquidHandler-Incompatible 1" <> $SessionUUID
				},
				FastTrack -> True
			];
			
			Upload[<|Object -> #, DeveloperObject -> True|>& /@ {sample1, sample2, sample3, sample4, sample5, sample6, sample7}]
		
		]
	),
	SymbolTearDown :> (
		Module[{objects, existsFilter},
			objects = {
				Object[Sample, "resolveFilterMethod Normal Sample 1" <> $SessionUUID],
				Object[Sample, "resolveFilterMethod Normal Sample 2" <> $SessionUUID],
				Object[Sample, "resolveFilterMethod Normal Sample 3" <> $SessionUUID],
				Object[Sample, "resolveFilterMethod Sample in Non-LiquidHandler-Compatible Container 1" <> $SessionUUID],
				Object[Sample, "resolveFilterMethod Sample in Non-LiquidHandler-Compatible Container 2" <> $SessionUUID],
				Object[Sample, "resolveFilterMethod Sample With High Volume (40 mL)" <> $SessionUUID],
				Object[Sample, "resolveFilterMethod Sample that is LiquidHandler-Incompatible 1" <> $SessionUUID],
				
				Object[Container, Vessel, "resolveFilterMethod Vessel 1" <> $SessionUUID],
				Object[Container, Vessel, "resolveFilterMethod Vessel 2" <> $SessionUUID],
				Object[Container, Vessel, "resolveFilterMethod Vessel 3 (LiquidHandler-Incompatible)" <> $SessionUUID],
				Object[Container, Vessel, "resolveFilterMethod Vessel 4 (LiquidHandler-Incompatible)" <> $SessionUUID],
				Object[Container, Vessel, "resolveFilterMethod Vessel 5" <> $SessionUUID],
				
				Object[Container, Plate, "resolveFilterMethod Plate 1" <> $SessionUUID]
			};
			
			(* Check whether the names we want to give below already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];
			
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
		
		]
	)
];



(* ::Subsection::Closed:: *)
(*Filter*)


DefineTests[
	Filter,
	{
	(* --- Basic Examples --- *)
		Example[{Basic, "Filter a single sample:"},
			ExperimentManualSamplePreparation[{Filter[Sample -> Object[Sample, "Filter Test Sample for Filter (I)"<>$SessionUUID]]}],
			ObjectP[Object[Protocol]]
		],
		Example[{Basic, "Filter a single container:"},
			ExperimentManualSamplePreparation[{Filter[Sample -> Object[Container, Vessel, "Filter Test Container for Filter (I)"<>$SessionUUID]]}],
			ObjectP[Object[Protocol]]
		],
		Example[{Basic, "Filter a sample and a container the same time:"},
			ExperimentManualSamplePreparation[{Filter[Sample -> {
				Object[Sample, "Filter Test Sample for Filter (I)"<>$SessionUUID],
				Object[Container, Vessel, "Filter Test Container for Filter (II)"<>$SessionUUID]
			}]}],
			ObjectP[Object[Protocol]]
		]
	},
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		$CreatedObjects = {};
		Module[{objects, existsFilter},
			(* list of test objects*)
			objects = {
				Object[Sample, "Filter Test Sample for Filter (I)"<>$SessionUUID],
				Object[Container, Vessel, "Filter Test Container for Filter (I)"<>$SessionUUID],
				Object[Sample, "Filter Test Sample for Filter (II)"<>$SessionUUID],
				Object[Container, Vessel, "Filter Test Container for Filter (II)"<>$SessionUUID]
			};

			(* Check whether the names we want to give below already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force->True, Verbose-> False]];
			Upload[
				{
					Association[
						Type->Object[Container, Vessel],
						Model->Link[Model[Container, Vessel, "50mL Tube"], Objects],
						Name -> "Filter Test Container for Filter (I)"<>$SessionUUID,
						DeveloperObject->True,
						Site -> Link[$Site]
					],
					Association[
						Type->Object[Container, Vessel],
						Model->Link[Model[Container, Vessel, "50mL Tube"], Objects],
						Name -> "Filter Test Container for Filter (II)"<>$SessionUUID,
						DeveloperObject->True,
						Site -> Link[$Site]
					]
				}
			];

			ECL`InternalUpload`UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				{
					{"A1", Object[Container, Vessel, "Filter Test Container for Filter (I)"<>$SessionUUID]},
					{"A1", Object[Container, Vessel, "Filter Test Container for Filter (II)"<>$SessionUUID]}
				},
				InitialAmount -> 15 Milliliter,
				Name -> {
					"Filter Test Sample for Filter (I)"<>$SessionUUID,
					"Filter Test Sample for Filter (II)"<>$SessionUUID
				}
			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
	)
];




(* ::Section:: *)
(*End Private*)
