(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*RestrictLabeledSamples*)

DefineTests[
	RestrictLabeledSamples,
	{
		Example[{Basic,"Restricts single object:"},
			(
				before = Download[Object[Sample, "RestrictLabeledSamples test sample 1"<>$SessionUUID], Restricted];
				RestrictLabeledSamples[Object[Sample, "RestrictLabeledSamples test sample 1"<>$SessionUUID]];
				after = Download[Object[Sample, "RestrictLabeledSamples test sample 1"<>$SessionUUID], Restricted];
				{before, after}
			),
			{Null, True},
			Variables:>{before, after}
		],
		Example[{Basic,"Restricts multiple objects:"},
			(
				before = Download[{Object[Sample, "RestrictLabeledSamples test sample 2"<>$SessionUUID], Object[Sample, "RestrictLabeledSamples test sample 3"<>$SessionUUID]}, Restricted];
				RestrictLabeledSamples[{Object[Sample, "RestrictLabeledSamples test sample 2"<>$SessionUUID], Object[Sample, "RestrictLabeledSamples test sample 3"<>$SessionUUID]}];
				after = Download[{Object[Sample, "RestrictLabeledSamples test sample 2"<>$SessionUUID], Object[Sample, "RestrictLabeledSamples test sample 3"<>$SessionUUID]}, Restricted];
				{before, after}
			),
			{{Null, Null}, {True, True}},
			Variables:>{before, after}
		],
		Example[{Basic,"Omits public objects:"},
			RestrictLabeledSamples[{Object[Sample, "RestrictLabeledSamples test sample 4"<>$SessionUUID], Object[Sample, "RestrictLabeledSamples test sample 5"<>$SessionUUID]}],
			{ObjectP[]}
		]
	},
	SymbolSetUp :> (
		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{allObjects, existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = {
				Object[LaboratoryNotebook, "RestrictLabeledSamples test notebook"<>$SessionUUID],
				Object[Sample, "RestrictLabeledSamples test sample 1"<>$SessionUUID],
				Object[Sample, "RestrictLabeledSamples test sample 2"<>$SessionUUID],
				Object[Sample, "RestrictLabeledSamples test sample 3"<>$SessionUUID],
				Object[Sample, "RestrictLabeledSamples test sample 4"<>$SessionUUID],
				Object[Sample, "RestrictLabeledSamples test sample 5"<>$SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		$CreatedObjects = {};


		(* Create objects *)
		Upload[{
			<|
				Type->Object[LaboratoryNotebook],
				Name->"RestrictLabeledSamples test notebook"<>$SessionUUID,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Sample],
				Name->"RestrictLabeledSamples test sample 1"<>$SessionUUID,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Sample],
				Name->"RestrictLabeledSamples test sample 2"<>$SessionUUID,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Sample],
				Name->"RestrictLabeledSamples test sample 3"<>$SessionUUID,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Sample],
				Name->"RestrictLabeledSamples test sample 4"<>$SessionUUID,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Sample],
				Name->"RestrictLabeledSamples test sample 5"<>$SessionUUID,
				Notebook -> Null,
				DeveloperObject->True
			|>
		}];

		(* assign Notebook to some Objects *)
		UploadNotebook[{
			Object[Sample, "RestrictLabeledSamples test sample 1"<>$SessionUUID],
			Object[Sample, "RestrictLabeledSamples test sample 2"<>$SessionUUID],
			Object[Sample, "RestrictLabeledSamples test sample 3"<>$SessionUUID],
			Object[Sample, "RestrictLabeledSamples test sample 4"<>$SessionUUID]
		},
			Object[LaboratoryNotebook, "RestrictLabeledSamples test notebook"<>$SessionUUID]]
	),
	SymbolTearDown :> (
		Module[{allObjects, existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects =Join[
				{
					Object[LaboratoryNotebook, "RestrictLabeledSamples test notebook"<>$SessionUUID],
					Object[Sample, "RestrictLabeledSamples test sample 1"<>$SessionUUID],
					Object[Sample, "RestrictLabeledSamples test sample 2"<>$SessionUUID],
					Object[Sample, "RestrictLabeledSamples test sample 3"<>$SessionUUID],
					Object[Sample, "RestrictLabeledSamples test sample 4"<>$SessionUUID],
					Object[Sample, "RestrictLabeledSamples test sample 5"<>$SessionUUID]
				},
				$CreatedObjects];

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];
		Unset[$CreatedObjects];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$ddPCRNoMultiplex = False,
		$SearchMaxDateCreated=(Now-1Day)
	}
];


(* ::Subsubsection::Closed:: *)
(*UnrestrictLabeledSamples*)

DefineTests[
	UnrestrictLabeledSamples,
	{
		Example[{Basic,"Unrestricts single object:"},
			(
				before = Download[Object[Sample, "UnrestrictLabeledSamples test sample 1"<>$SessionUUID], Restricted];
				UnrestrictLabeledSamples[Object[Sample, "UnrestrictLabeledSamples test sample 1"<>$SessionUUID]];
				after = Download[Object[Sample, "UnrestrictLabeledSamples test sample 1"<>$SessionUUID], Restricted];
				{before, after}
			),
			{True, False},
			Variables:>{before, after}
		],
		Example[{Basic,"Unrestricts multiple objects:"},
			(
				before = Download[{Object[Sample, "UnrestrictLabeledSamples test sample 2"<>$SessionUUID], Object[Sample, "UnrestrictLabeledSamples test sample 3"<>$SessionUUID]}, Restricted];
				UnrestrictLabeledSamples[{Object[Sample, "UnrestrictLabeledSamples test sample 2"<>$SessionUUID], Object[Sample, "UnrestrictLabeledSamples test sample 3"<>$SessionUUID]}];
				after = Download[{Object[Sample, "UnrestrictLabeledSamples test sample 2"<>$SessionUUID], Object[Sample, "UnrestrictLabeledSamples test sample 3"<>$SessionUUID]}, Restricted];
				{before, after}
			),
			{{True, True}, {False, False}},
			Variables:>{before, after}
		],
		Example[{Basic,"Omits public objects:"},
			UnrestrictLabeledSamples[{Object[Sample, "UnrestrictLabeledSamples test sample 4"<>$SessionUUID], Object[Sample, "UnrestrictLabeledSamples test sample 5"<>$SessionUUID]}],
			{ObjectP[]}
		]
	},
	SymbolSetUp :> (
		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{allObjects, existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = {
				Object[LaboratoryNotebook, "UnrestrictLabeledSamples test notebook"<>$SessionUUID],
				Object[Sample, "UnrestrictLabeledSamples test sample 1"<>$SessionUUID],
				Object[Sample, "UnrestrictLabeledSamples test sample 2"<>$SessionUUID],
				Object[Sample, "UnrestrictLabeledSamples test sample 3"<>$SessionUUID],
				Object[Sample, "UnrestrictLabeledSamples test sample 4"<>$SessionUUID],
				Object[Sample, "UnrestrictLabeledSamples test sample 5"<>$SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		$CreatedObjects = {};


		(* Create objects *)
		Upload[{
			<|
				Type->Object[LaboratoryNotebook],
				Name->"UnrestrictLabeledSamples test notebook"<>$SessionUUID,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Sample],
				Name->"UnrestrictLabeledSamples test sample 1"<>$SessionUUID,
				Restricted->True,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Sample],
				Name->"UnrestrictLabeledSamples test sample 2"<>$SessionUUID,
				Restricted->True,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Sample],
				Name->"UnrestrictLabeledSamples test sample 3"<>$SessionUUID,
				Restricted->True,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Sample],
				Name->"UnrestrictLabeledSamples test sample 4"<>$SessionUUID,
				Restricted->True,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Sample],
				Name->"UnrestrictLabeledSamples test sample 5"<>$SessionUUID,
				Restricted->True,
				Notebook -> Null,
				DeveloperObject->True
			|>
		}];

		(* assign Notebook to some Objects *)
		UploadNotebook[{
			Object[Sample, "UnrestrictLabeledSamples test sample 1"<>$SessionUUID],
			Object[Sample, "UnrestrictLabeledSamples test sample 2"<>$SessionUUID],
			Object[Sample, "UnrestrictLabeledSamples test sample 3"<>$SessionUUID],
			Object[Sample, "UnrestrictLabeledSamples test sample 4"<>$SessionUUID]
		},
			Object[LaboratoryNotebook, "UnrestrictLabeledSamples test notebook"<>$SessionUUID]]
	),
	SymbolTearDown :> (
		Module[{allObjects, existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects =Join[
				{
					Object[LaboratoryNotebook, "UnrestrictLabeledSamples test notebook"<>$SessionUUID],
					Object[Sample, "UnrestrictLabeledSamples test sample 1"<>$SessionUUID],
					Object[Sample, "UnrestrictLabeledSamples test sample 2"<>$SessionUUID],
					Object[Sample, "UnrestrictLabeledSamples test sample 3"<>$SessionUUID],
					Object[Sample, "UnrestrictLabeledSamples test sample 4"<>$SessionUUID],
					Object[Sample, "UnrestrictLabeledSamples test sample 5"<>$SessionUUID]
				},
				$CreatedObjects];

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];
		Unset[$CreatedObjects];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$ddPCRNoMultiplex = False,
		$SearchMaxDateCreated=(Now-1Day)
	}
];


(* ::Subsubsection::Closed:: *)
(*Experiment`Private`SimulateResources*)

DefineTests[
	Experiment`Private`SimulateResources,
	{
		Example[{Basic,"Returns a simulation, replacing any resources with simulated samples/containers/items in the protocol object:"},
			Experiment`Private`SimulateResources[<|
				Type->Object[Protocol, Transfer],
				Object->SimulateCreateID[Object[Protocol, Transfer]],
				Replace[SamplesIn]->{
					Resource[
						Sample->Model[Sample, "Milli-Q water"],
						Amount->1 Milliliter,
						Container->Model[Container, Vessel, "2mL Tube"]
					],
					Resource[
						Sample->Model[Sample, "Methanol"],
						Amount->10 Milliliter,
						Container->Model[Container, Vessel, "50mL Tube"]
					]
				},
				Replace[UnresolvedOptions]->{},
				Replace[ResolvedOptions]->{}
			|>],
			SimulationP
		],
		Example[{Basic,"Inspect the simulated SamplesIn:"},
			Module[{transferProtocol, simulation},
				transferProtocol=SimulateCreateID[Object[Protocol, Transfer]];

				simulation=Experiment`Private`SimulateResources[<|
					Type->Object[Protocol, Transfer],
					Object->transferProtocol,
					Replace[SamplesIn]->{
						Resource[
							Sample->Model[Sample, "Milli-Q water"],
							Amount->1 Milliliter,
							Container->Model[Container, Vessel, "2mL Tube"]
						],
						Resource[
							Sample->Model[Sample, "Methanol"],
							Amount->10 Milliliter,
							Container->Model[Container, Vessel, "50mL Tube"]
						]
					},
					Replace[UnresolvedOptions]->{},
					Replace[ResolvedOptions]->{}
				|>];

				Download[transferProtocol, SamplesIn, Simulation->simulation]
			],
			{ObjectP[Object[Sample]], ObjectP[Object[Sample]]}
		],
		Example[{Basic,"Returns a simulation, replacing any resources with simulated samples/containers/items in the protocol object and works on functions with multiple inputs:"},
			Experiment`Private`SimulateResources[<|
				Type->Object[Protocol, FillToVolume],
				Object->SimulateCreateID[Object[Protocol, FillToVolume]],
				Replace[SamplesIn]->{
					Resource[
						Sample->Model[Sample, "Milli-Q water"],
						Amount->1 Milliliter,
						Container->Model[Container, Vessel, "2mL Tube"]
					]
				},
				Replace[UnresolvedOptions]->{Solvent->{Model[Sample,"Milli-Q water"]}},
				Replace[ResolvedOptions]->{Solvent->{Model[Sample,"Milli-Q water"]}},
				ResolvedOptions->{Solvent->{Model[Sample,"Milli-Q water"]}},
				TotalVolumes->{1.3Milliliter}
			|>],
			SimulationP
		],
		Example[{Additional, "If simulating a water resource, properly simulate its ContainerResource as well:"},
			testID = SimulateCreateID[Object[Maintenance, Handwash]];
			RequireResources[
				<|
					Object -> testID,
					PrimaryCleaningSolvent -> Link[Resource[Sample -> Model[Sample, "Milli-Q water"], Amount -> 20 Milliliter, Container -> Model[Container, Vessel, "50mL Tube"]]]
				|>
			];
			currentSim = Experiment`Private`SimulateResources[testID];
			{cleaningSolvent, cleaningSolventContainer} = Download[
				testID,
				{
					PrimaryCleaningSolvent[Object],
					PrimaryCleaningSolvent[Container][Object]
				},
				Simulation -> currentSim
			];
			Download[testID, RequiredResources[[All, 1]][{Sample, Status}], Simulation -> currentSim],
			{
				{ObjectP[cleaningSolvent], InUse},
				{ObjectP[cleaningSolventContainer], InUse}
			},
			Variables :> {testID, currentSim, cleaningSolvent, cleaningSolventContainer},
			SetUp :> (
				EnterSimulation[];
			),
			TearDown :> (ExitSimulation[])
		],
		Example[{Additional, "If simulating a colony handler head cassette resource, properly simulate its Container as well:"},
			testID = SimulateCreateID[Object[Protocol, RoboticCellPreparation]];
			RequireResources[
				<|
					Object -> testID,
					Replace[RequiredObjects] -> {Link[Resource[Sample -> Model[Part, ColonyHandlerHeadCassette, "1-pin spreading head"]]]}
				|>
			];
			currentSim = Experiment`Private`SimulateResources[testID];
			{headCassette, headCassetteContainer, headCassetteHolder} = Download[
				testID,
				{
					RequiredObjects[Object],
					RequiredObjects[Container][Object],
					RequiredObjects[ColonyHandlerHeadCassetteHolder][Object]
				},
				Simulation -> currentSim
			];
			Download[testID, RequiredResources[[All, 1]][{Sample, Sample[Container], Sample[ColonyHandlerHeadCassetteHolder]}], Simulation -> currentSim],
			{
				{
					ObjectP[headCassette],
					ObjectP[headCassetteHolder],
					ObjectP[headCassetteContainer]
				}
			},
			Variables :> {testID, currentSim, headCassette, headCassetteHolder, headCassetteContainer},
			SetUp :> (
				EnterSimulation[];
			),
			TearDown :> (ExitSimulation[])
		],
		Example[{Additional, "If simulating a waste bin resource, properly simulate its waste as well:"},
			testID = SimulateCreateID[Object[Protocol, RoboticCellPreparation]];
			RequireResources[
				<|
					Object -> testID,
					Replace[RequiredObjects] -> {Link[Resource[Sample -> Model[Container, WasteBin, "id:1ZA60vzK7jl8"](*Model[Container, WasteBin, "id:1ZA60vzK7jl8"]*)]]}
				|>
			];
			currentSim = Experiment`Private`SimulateResources[testID];
			{{wastebin},{waste}} = Download[
				testID,
				{
					RequiredObjects[Object],
					RequiredObjects[[1]][Contents][[All,2]]
				},
				Simulation -> currentSim
			];
			Flatten@Download[testID, RequiredResources[[All, 1]][{Sample, Sample[Contents][[All,2]]}], Simulation -> currentSim],
			{
				ObjectP[wastebin],
				ObjectP[waste]
			},
			Variables :> {testID, currentSim, wastebin,waste},
			SetUp :> (
				EnterSimulation[];
			),
			TearDown :> (ExitSimulation[])
		],
		Example[{Options, IgnoreCoverSimulation, "If IgnoreCoverSimulation -> True, then don't simulate the cover and leave the container uncovered:"},
			testID = SimulateCreateID[Object[Maintenance, Decontaminate, Incubator]];
			RequireResources[
				<|
					Object -> testID,
					WasteContainer -> Link[Resource[Sample -> Model[Container, Vessel, "50mL Tube"]]]
				|>
			];
			currentSim = Experiment`Private`SimulateResources[testID, IgnoreCoverSimulation -> True];
			Download[
				testID,
				{
					WasteContainer,
					WasteContainer[Cover]
				},
				Simulation -> currentSim
			],
			{
				ObjectP[Object[Container, Vessel]], Null
			},
			Variables :> {testID, currentSim},
			SetUp :> (
				EnterSimulation[];
			),
			TearDown :> (ExitSimulation[])
		],
		Example[{Options, IgnoreCoverSimulation, "If IgnoreCoverSimulation is automaticaly set to False and simulate the cover and leave the container uncovered:"},
			testID = SimulateCreateID[Object[Maintenance, Decontaminate, Incubator]];
			RequireResources[
				<|
					Object -> testID,
					WasteContainer -> Link[Resource[Sample -> Model[Container, Vessel, "50mL Tube"]]]
				|>
			];
			currentSim = Experiment`Private`SimulateResources[testID];
			Download[
				testID,
				{
					WasteContainer,
					WasteContainer[Cover]
				},
				Simulation -> currentSim
			],
			{
				ObjectP[Object[Container, Vessel]], ObjectP[Object[Item, Cap]]
			},
			Variables :> {testID, currentSim},
			SetUp :> (
				EnterSimulation[];
			),
			TearDown :> (ExitSimulation[])
		],
		Example[{Options, IgnoreCoverSimulation, "If IgnoreCoverSimulation is automatically set to True for RSP:"},
			testID = SimulateCreateID[Object[Protocol, RoboticSamplePreparation]];
			RequireResources[
				<|
					Object -> testID,
					SolventWasteContainer -> Link[Resource[Sample -> Model[Container, Vessel, "50mL Tube"]]]
				|>
			];
			currentSim = Experiment`Private`SimulateResources[testID];
			Download[
				testID,
				{
					SolventWasteContainer,
					SolventWasteContainer[Cover]
				},
				Simulation -> currentSim
			],
			{
				ObjectP[Object[Container, Vessel]], Null
			},
			Variables :> {testID, currentSim},
			SetUp :> (
				EnterSimulation[];
			),
			TearDown :> (ExitSimulation[])
		],
		Example[{Options, IgnoreWaterResources, "If IgnoreWaterResources -> True, then don't simulate the water resources and leave them as models:"},
			testID = SimulateCreateID[Object[Maintenance, Handwash]];
			RequireResources[
				<|
					Object -> testID,
					PrimaryCleaningSolvent -> Link[Resource[Sample -> Model[Sample, "Milli-Q water"], Amount -> 20 Milliliter, Container -> Model[Container, Vessel, "50mL Tube"]]]
				|>
			];
			currentSim = Experiment`Private`SimulateResources[testID, IgnoreWaterResources -> True];
			Download[testID, RequiredResources[[All, 1]][{Sample, Models, Status}], Simulation -> currentSim],
			{
				{Null, {ObjectP[Model[Sample, "Milli-Q water"]]}, InCart},
				{Null, {ObjectP[Model[Container, Vessel]]}, InCart}
			},
			Variables :> {testID, currentSim},
			SetUp :> (
				EnterSimulation[];
			),
			TearDown :> (ExitSimulation[])
		],
		Example[{Additional,"Returns a simulation and populate the working sample of the protocol by simulating sample transfer if there is aliquot:"},
			protocolObject = SimulateCreateID[Object[Protocol, AbsorbanceSpectroscopy]];
			resourceSimulation = Experiment`Private`SimulateResources[<|
				Type -> Object[Protocol, AbsorbanceSpectroscopy],
				Object -> protocolObject,
				Replace[SamplesIn] -> {
					Resource[
						Sample -> Object[Sample, "Test sample 1 for SimulateResources" <> $SessionUUID],
						Amount -> 10 Milliliter
					]
				},
				Replace[UnresolvedOptions] -> {AliquotContainer -> {1, Model[Container, Vessel, "id:xRO9n3vk11pw"]} (* "15mL Tube" *), AssayVolume -> {10 Milliliter}},
				Replace[ResolvedOptions] -> {AliquotContainer -> {1, Model[Container, Vessel, "id:xRO9n3vk11pw"]} (* "15mL Tube" *), AssayVolume -> {10 Milliliter}, Aliquot-> {True}},
				ResolvedOptions -> {AliquotContainer -> {1, Model[Container, Vessel, "id:xRO9n3vk11pw"]}, (* "15mL Tube" *) AssayVolume -> {10 Milliliter}, Aliquot-> {True}}
			|>];
			(* Check the source sample volume in simulation *)
			Download[
				Object[Sample, "Test sample 1 for SimulateResources" <> $SessionUUID],
				Volume,
				Simulation -> resourceSimulation
			],
			RangeP[29 Milliliter, 31 Milliliter],
			Variables :> {protocolObject, resourceSimulation},
			SetUp :> (
				$CreatedObjects={};
				Block[{$DeveloperUpload=True},
					Upload[<|
						Type->Object[Container,Vessel],
						Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
						Name->"Test container 1 for SimulateResources" <> $SessionUUID,
						DeveloperObject->True,
						Site -> Link[$Site]
					|>];
					UploadSample[
						Model[Sample,"Milli-Q water"],
						{"A1",Object[Container,Vessel, "Test container 1 for SimulateResources"<> $SessionUUID]},
						InitialAmount-> 40 Milliliter,
						Name-> "Test sample 1 for SimulateResources" <> $SessionUUID
					]
				]),
			TearDown :> (
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		]
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"],
		$SearchMaxDateCreated=(Now-1Day)
	}
];

(* ::Subsubsection::Closed:: *)
(*getAdditionalIntegrations*)
DefineTests[getAdditionalIntegrations,
	{
		Example[{Additional,"When doing not RCP, return resource blobs as they were:"},
			getAdditionalIntegrations[
				Model[Instrument,LiquidHandler,"Test LiquidHandler model for getAdditionalIntegrations "<>$SessionUUID],
				{Resource[Instrument->Model[Instrument,PlateReader,"Test PlateReader 1 for getAdditionalIntegrations "<>$SessionUUID],Time->5Minute,Name->CreateUUID[]]},
				RoboticSamplePreparation,
				5,
				0,
				5Minute,
				Cache->{}
			],
			{_Resource}
		],
		Example[{Additional,"Return early if we are not using any integrations and use small number of tips/plates:"},
			getAdditionalIntegrations[
				Model[Instrument,LiquidHandler,"Test LiquidHandler model for getAdditionalIntegrations "<>$SessionUUID],
				{},
				RoboticCellPreparation,
				5,
				0,
				5Minute,
				Cache->{}
			],
			{}
		],
		Example[{Basic,"Reserve all integrations if we are using enough tips:"},
			getAdditionalIntegrations[
				Model[Instrument,LiquidHandler,"Test LiquidHandler model for getAdditionalIntegrations "<>$SessionUUID],
				{},
				RoboticCellPreparation,
				5,
				15,
				5Minute,
				Cache->{Download[Model[Instrument,LiquidHandler,"Test LiquidHandler model for getAdditionalIntegrations "<>$SessionUUID],Packet[IntegratedInstruments]]}
			],
			{_Resource..}
		],
		Example[{Basic,"Reserve all integrations if we are using at least one of them:"},
			getAdditionalIntegrations[
				Model[Instrument,LiquidHandler,"Test LiquidHandler model for getAdditionalIntegrations "<>$SessionUUID],
				{Resource[Instrument->Model[Instrument,PlateReader,"Test PlateReader 1 for getAdditionalIntegrations "<>$SessionUUID],Time->5Minute,Name->CreateUUID[]]},
				RoboticCellPreparation,
				5,
				2,
				5Minute,
				Cache->{Download[Model[Instrument,LiquidHandler,"Test LiquidHandler model for getAdditionalIntegrations "<>$SessionUUID],Packet[IntegratedInstruments]]}
			],
			{_Resource..}
		],
		Example[{Basic,"Reserve all integrations if we are using enough plates:"},
			getAdditionalIntegrations[
				Model[Instrument,LiquidHandler,"Test LiquidHandler model for getAdditionalIntegrations "<>$SessionUUID],
				{},
				RoboticCellPreparation,
				30,
				2,
				5Minute,
				Cache->{Download[Model[Instrument,LiquidHandler,"Test LiquidHandler model for getAdditionalIntegrations "<>$SessionUUID],Packet[IntegratedInstruments]]}
			],
			{_Resource..}
		],
		Example[{Basic,"UnusedIntegratedInstrument key is populated only for new resources:"},
			Module[{newResources},
				newResources=getAdditionalIntegrations[
					Model[Instrument,LiquidHandler,"Test LiquidHandler model for getAdditionalIntegrations "<>$SessionUUID],
					{Resource[Instrument->Model[Instrument,PlateReader,"Test PlateReader 1 for getAdditionalIntegrations "<>$SessionUUID],Time->5Minute,Name->CreateUUID[]]},
					RoboticCellPreparation,
					5,
					2,
					5Minute,
					Cache->{Download[Model[Instrument,LiquidHandler,"Test LiquidHandler model for getAdditionalIntegrations "<>$SessionUUID],Packet[IntegratedInstruments]]}
				];
				Lookup[newResources[[All,1]],UnusedIntegratedInstrument,Null]
			],
			{Null,True..}
		],
		Example[{Basic,"Works with liquid handler object specified:"},
			getAdditionalIntegrations[
				Download[Object[Instrument,LiquidHandler,"Test LiquidHandler for getAdditionalIntegrations "<>$SessionUUID],Object],
				{},
				RoboticCellPreparation,
				30,
				2,
				5Minute,
				Cache->Flatten@Download[{
					{Object[Instrument,LiquidHandler,"Test LiquidHandler for getAdditionalIntegrations "<>$SessionUUID]},
					{Model[Instrument,LiquidHandler,"Test LiquidHandler model for getAdditionalIntegrations "<>$SessionUUID]}
				},
					{
						{Packet[Model]},
						{Packet[IntegratedInstruments]}
					}
				]
			],
			{_Resource..}
		]
	},
	SymbolSetUp:>{Module[{lhObject,lhModel,plateReaderID1,plateReaderID2,plateReaderID3},
		getAdditionalIntegrationsTestTearDown[];
		{lhObject,lhModel,plateReaderID1,plateReaderID2,plateReaderID3}=CreateID[{
			Object[Instrument,LiquidHandler],
			Model[Instrument,LiquidHandler],
			Model[Instrument,PlateReader],
			Model[Instrument,PlateReader],
			Model[Instrument,PlateReader]
		}];

		Upload[{
			<|
				Object->lhObject,
				Name->"Test LiquidHandler for getAdditionalIntegrations "<>$SessionUUID,
				DeveloperObject->True,
				Model->Link[lhModel,Objects]
			|>,
			<|
				Object->lhModel,
				Name->"Test LiquidHandler model for getAdditionalIntegrations "<>$SessionUUID,
				DeveloperObject->True,
				Replace[IntegratedInstruments]->Link[{plateReaderID1,plateReaderID2,plateReaderID3}]
			|>,
			<|
				Object->plateReaderID1,
				Name->"Test PlateReader 1 for getAdditionalIntegrations "<>$SessionUUID,
				DeveloperObject->True
			|>,
			<|
				Object->plateReaderID2,
				Name->"Test PlateReader 2 for getAdditionalIntegrations "<>$SessionUUID,
				DeveloperObject->True
			|>,
			<|
				Object->plateReaderID3,
				Name->"Test PlateReader 3 for getAdditionalIntegrations "<>$SessionUUID,
				DeveloperObject->True
			|>
		}]
	]},
	SymbolTearDown:>{getAdditionalIntegrationsTestTearDown[]}
];

getAdditionalIntegrationsTestTearDown[]:=Module[{allObj,existingObj},
	allObj={
		Object[Instrument,LiquidHandler,"Test LiquidHandler for getAdditionalIntegrations "<>$SessionUUID],
		Model[Instrument,LiquidHandler,"Test LiquidHandler model for getAdditionalIntegrations "<>$SessionUUID],
		Model[Instrument,PlateReader,"Test PlateReader 1 for getAdditionalIntegrations "<>$SessionUUID],
		Model[Instrument,PlateReader,"Test PlateReader 2 for getAdditionalIntegrations "<>$SessionUUID],
		Model[Instrument,PlateReader,"Test PlateReader 3 for getAdditionalIntegrations "<>$SessionUUID]
	};
	existingObj=PickList[allObj,DatabaseMemberQ[allObj]];
	Quiet[EraseObject[existingObj, Force -> True, Verbose -> False]]
];

(* ::Subsubsection::Closed:: *)
(*updateLabelFieldReferences*)
DefineTests[updateLabelFieldReferences,
	{
		Example[{Basic,"Return without changing simulation if there are no LabelFields present:"},
			Module[{simulationIn,simulationOut},
				Experiment`Private`$PrimitiveFrameworkIndexedLabelCache={};
				simulationIn = UpdateSimulation[Simulation[],Simulation[LabelFields->{}]];
				simulationOut=updateLabelFieldReferences[simulationIn,BatchedUnitOperations];
				MatchQ[simulationIn,simulationOut]
			],
			True
		],
		Example[{Basic,"Return without changing simulation if there are no overlapping labels in LabelField:"},
			Module[{simulationIn,simulationOut},
				Experiment`Private`$PrimitiveFrameworkIndexedLabelCache = {"label2"->LabelField["aaa",2]};
				simulationIn = UpdateSimulation[Simulation[],Simulation[LabelFields->{"label1"->Field[DestinationSample[[3]]]}]];
				simulationOut=updateLabelFieldReferences[simulationIn,BatchedUnitOperations];
				MatchQ[simulationIn,simulationOut]
			],
			True
		],
		Example[{Basic,"Updates the LabelField references in the LabelFields of the Simulation:"},
			Module[{simulationIn,simulationOut,oldLabelField,oldLabel,newLabelField},
				Experiment`Private`$PrimitiveFrameworkIndexedLabelCache = {"label1"->LabelField[Field[DestinationSample[[3]]],2]};
				simulationIn = Simulation[LabelFields->{"label1"->Field[DestinationSample[[3]]]}];

				oldLabelField=Lookup[simulationIn[[1]],LabelFields];
				oldLabel=oldLabelField[[1,2]];
				simulationOut=updateLabelFieldReferences[simulationIn,BatchedUnitOperations];

				newLabelField=Lookup[simulationOut[[1]],LabelFields];
				newLabelField[[1,2]]
			],
			Field[BatchedUnitOperations[[2]][DestinationSample][[3]]]
		],
		Example[{Behaviors,"(SHOULD NOT HAPPEN IN REALITY) If the LabelFields disagree with the $PrimitiveFrameworkIndexedLabelCache, use the value from $PrimitiveFrameworkIndexedLabelCache:"},
			Module[{simulationIn,simulationOut,oldLabelField,oldLabel,newLabelField},
				Experiment`Private`$PrimitiveFrameworkIndexedLabelCache = {"label1"->LabelField[Field[DestinationSample[[5]]],2]};
				simulationIn = Simulation[LabelFields->{"label1"->Field[DestinationSample[[3]]]}];

				oldLabelField=Lookup[simulationIn[[1]],LabelFields];
				oldLabel=oldLabelField[[1,2]];
				simulationOut=updateLabelFieldReferences[simulationIn,BatchedUnitOperations];

				newLabelField=Lookup[simulationOut[[1]],LabelFields];
				newLabelField[[1,2]]
			],
			Field[BatchedUnitOperations[[2]][DestinationSample][[5]]]
		],
		Example[{Behaviors,"If we provide Null instead of simulation, return Null:"},
			updateLabelFieldReferences[Null,BatchedUnitOperations],
			Null
		]
	},
	SetUp:>{Experiment`Private`$PrimitiveFrameworkIndexedLabelCache={}},
	TearDown:>{Experiment`Private`$PrimitiveFrameworkIndexedLabelCache={}}
];

(* ::Subsubsection::Closed:: *)
(*addLabelFields*)
DefineTests[addLabelFields,
	{
		Example[{Basic,"If there are no LabelFields, return things unchanged:"},
			Module[{allPrimitiveInformation,optionDefinitions,primitiveHeads,inputItems,outputItems},
				allPrimitiveInformation=Lookup[Lookup[$PrimitiveSetPrimitiveLookup, Hold[RoboticSamplePreparationP]],Primitives];
				primitiveHeads = Keys[allPrimitiveInformation];
				optionDefinitions=Map[Lookup[Lookup[allPrimitiveInformation,#],OptionDefinition]&,primitiveHeads];

				inputItems=Map[Function[{primitiveHead},Module[{inputOption},
					inputOption = Lookup[Lookup[allPrimitiveInformation,primitiveHead], InputOptions];
					(#->"non-existing label")&/@inputOption
				]],primitiveHeads];

				outputItems = MapThread[addLabelFields[#1,#2,{}]&,{inputItems,optionDefinitions}];
				MatchQ[inputItems,outputItems]
			],
			True
		],
		Example[{Basic,"Replace input samples with the linked field:"},
			Module[{allPrimitiveInformation,optionDefinitions},
				allPrimitiveInformation=Lookup[Lookup[$PrimitiveSetPrimitiveLookup, Hold[RoboticSamplePreparationP]],Primitives];
				optionDefinitions=Lookup[Lookup[allPrimitiveInformation,Mix],OptionDefinition];

				addLabelFields[
					{Sample -> {"aliquot sample out 1"}},
					optionDefinitions,
					{"aliquot sample out 1" -> LabelField[Field[RoboticUnitOperations[[3]][DestinationSample][[3]]],2]}
				]
			],
			{Sample->{LabelField[Field[RoboticUnitOperations[[3]][DestinationSample][[3]]],2]}}
		],
		Example[{Basic,"Replace input samples with another string label:"},
			Module[{allPrimitiveInformation,optionDefinitions},
				allPrimitiveInformation=Lookup[Lookup[$PrimitiveSetPrimitiveLookup, Hold[RoboticSamplePreparationP]],Primitives];
				optionDefinitions=Lookup[Lookup[allPrimitiveInformation,Mix],OptionDefinition];

				addLabelFields[
					{Sample -> {"aliquot sample out 1"}},
					optionDefinitions,
					{"aliquot sample out 1" -> LabelField["another label",2]}
				]
			],
			{Sample->{LabelField["another label",2]}}
		]
	}
];
(* ::Subsubsection::Closed:: *)
(*joinClauses*)

DefineTests[joinClauses,
	{
		Example[{Basic, "If the input is consist of a single string, return the string unchanged:"},
			joinClauses[{"This is a single input string"}],
			"This is a single input string"
		],
		Example[{Basic, "If the input is consist of 2 strings, return a combined string with And to connect:"},
			joinClauses[{"This is the first string", "that is the second string"}],
			"This is the first string and that is the second string"
		],
		Example[{Basic, "If the input is consist of 3 strings, return the combined string with both comma and And:"},
			joinClauses[{"This is the first string", "that is the second string", "here is the third string"}],
			"This is the first string, that is the second string, and here is the third string"
		],
		Example[{Basic, "If the input is consist of a single expression, return the string converted from the expression:"},
			joinClauses[{ExperimentIncubateCells}],
			"ExperimentIncubateCells"
		],
		Example[{Basic, "Input is consist of a mix of expression and string:"},
			joinClauses[{ExperimentIncubateCells, "its protocols"}],
			"ExperimentIncubateCells and its protocols"
		],
		Example[{Options, ConjunctionWord, "If the input is consist of 2 strings, automatically use And to connect:"},
			joinClauses[{"This is the first string", "that is the second string"}],
			"This is the first string and that is the second string"
		],
		Example[{Options, ConjunctionWord, "The connection word can be set to other string:"},
			joinClauses[{"This is the first string", "that is the second string"}, ConjunctionWord -> "otherwise"],
			"This is the first string otherwise that is the second string"
		],
		Example[{Options, CaseAdjustment, "If CaseAdjustment is specified as True, adjust the first letter to upper case for the first cause and lower case other causes:"},
			joinClauses[{"this is a lowercase input string", "This is an uppercase input string"}, CaseAdjustment -> True],
			"This is a lowercase input string and this is an uppercase input string"
		],
		Example[{Options, CaseAdjustment, "If CaseAdjustment is default to False if not specified:"},
			joinClauses[{"this is a lowercase input string", "This is an uppercase input string"}],
			"this is a lowercase input string and This is an uppercase input string"
		],
		Example[{Options, DuplicatesRemoval, "If DuplicatesRemoval is specified as False, keep duplicated clauses:"},
			joinClauses[{"this is a lowercase input string", "this is a lowercase input string"}, DuplicatesRemoval -> False],
			"this is a lowercase input string and this is a lowercase input string"
		],
		Example[{Options, DuplicatesRemoval, "If DuplicatesRemoval is default to True if not specified:"},
			joinClauses[{"this is a lowercase input string", "this is a lowercase input string"}],
			"this is a lowercase input string"
		],
		Example[{Additional, "If the input strings start with Object or Model, do not lower case them even if CaseAdjustment is True:"},
			joinClauses[{"this is a lowercase input string", "Object[Sample, \"id:123456\"] keeps its form"}, CaseAdjustment -> True],
			"This is a lowercase input string and Object[Sample, \"id:123456\"] keeps its form"
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*samplesForMessages*)

DefineTests[samplesForMessages,
	{
		Example[{Basic, "If the input is consist of a single sample, return the name of the sample:"},
			samplesForMessages[{Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID]}],
			StringJoin["Object[Sample, \"Test sample for samplesForMessages tests 1", ToString@$SessionUUID, "\"]"]
		],
		Example[{Basic, "If the input is consist of 2 samples, return a combined string with both names linked by and:"},
			samplesForMessages[
				{
					Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 2" <> $SessionUUID]
				}
			],
			StringJoin[
				"Object[Sample, \"Test sample for samplesForMessages tests 1", ToString@$SessionUUID,
				"\"] and Object[Sample, \"Test sample for samplesForMessages tests 2", ToString@$SessionUUID, "\"]"
			]
		],
		Example[{Basic, "If the input is consist of 3 samples, return the combined string with both comma and And:"},
			samplesForMessages[
				{
					Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 2" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 3" <> $SessionUUID]
				}
			],
			StringJoin[
				"Object[Sample, \"Test sample for samplesForMessages tests 1", ToString@$SessionUUID,
				"\"], Object[Sample, \"Test sample for samplesForMessages tests 2", ToString@$SessionUUID,
				"\"], and Object[Sample, \"Test sample for samplesForMessages tests 3", ToString@$SessionUUID, "\"]"
			]
		],
		Example[{Options, SkipNameConversion, "If the first input match the second input and the number of unique sample is 1, resolve SkipNameConversion to True and display \"the sample\":"},
			samplesForMessages[
				{
					Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID]
				},
				{
					Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID]
				}
			],
			"the sample"
		],
		Example[{Options, SkipNameConversion, "If the first input match the second input and the number of unique samples is more than 1, resolve SkipNameConversion to True and display \"all samples\":"},
			samplesForMessages[
				{
					Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 2" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 3" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 4" <> $SessionUUID]
				},
				{
					Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 2" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 3" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 4" <> $SessionUUID]
				}
			],
			"all samples"
		],
		Example[{Options, SkipNameConversion, "If the first input does not match the second input, resolve SkipNameConversion to False:"},
			samplesForMessages[
				{
					Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 2" <> $SessionUUID]
				},
				{
					Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 3" <> $SessionUUID]
				}
			],
			StringJoin[
				"Object[Sample, \"Test sample for samplesForMessages tests 1", ToString@$SessionUUID,
				"\"] and Object[Sample, \"Test sample for samplesForMessages tests 2", ToString@$SessionUUID, "\"]"
			]
		],
		Example[{Options, SkipNameConversion, "If the first input does not match the second input's length, resolve SkipNameConversion to False:"},
			samplesForMessages[
				{
					Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 2" <> $SessionUUID]
				},
				{
					Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 2" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 3" <> $SessionUUID]
				}
			],
			StringJoin[
				"Object[Sample, \"Test sample for samplesForMessages tests 1", ToString@$SessionUUID,
				"\"] and Object[Sample, \"Test sample for samplesForMessages tests 2", ToString@$SessionUUID, "\"]"
			]
		],
		Example[{Options, SkipNameConversion, "If SkipNameConversion is set to True and only 1 input sample, return \"the sample\":"},
			samplesForMessages[{Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID]}, SkipNameConversion -> True],
			"the sample"
		],
		Example[{Options, SkipNameConversion, "If SkipNameConversion is set to True and only 1 input container, return \"the container\":"},
			samplesForMessages[{Object[Container, Vessel, "Test 50mL Tube for samplesForMessages tests 1" <> $SessionUUID]}, SkipNameConversion -> True],
			"the container"
		],
		Example[{Options, SkipNameConversion, "If SkipNameConversion is set to False, return the name of sample:"},
			samplesForMessages[{Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID]}, SkipNameConversion -> False],
			StringJoin["Object[Sample, \"Test sample for samplesForMessages tests 1", ToString@$SessionUUID, "\"]"]
		],
		Example[{Options, SkipNameConversion, "If SkipNameConversion is set to True and more than 1 input sample, return \"all samples\":"},
			samplesForMessages[
				{
					Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 2" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 3" <> $SessionUUID]
				},
				SkipNameConversion -> True
			],
			"all samples"
		],
		Example[{Options, SkipNameConversion, "If SkipNameConversion is set to True and more than 1 input container, return \"all containers\":"},
			samplesForMessages[
				{
					Object[Container, Vessel, "Test 50mL Tube for samplesForMessages tests 1" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube for samplesForMessages tests 2" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube for samplesForMessages tests 3" <> $SessionUUID]
				},
				SkipNameConversion -> True
			],
			"all containers"
		],
		Example[{Options, SkipNameConversion, "If SkipNameConversion is set to True and input is a mix of sample and container, return \"all inputs\":"},
			samplesForMessages[
				{
					Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube for samplesForMessages tests 2" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube for samplesForMessages tests 3" <> $SessionUUID]
				},
				SkipNameConversion -> True
			],
			"all inputs"
		],
		Example[{Options, CollapseForDisplay, "If the first input does not match the second input and the number of input samples is less than 4, resolve CollapseForDisplay to False and display full sample names:"},
			samplesForMessages[
				{
					Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 2" <> $SessionUUID]
				},
				{
					Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 2" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 3" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 4" <> $SessionUUID]
				}
			],
			StringJoin[
				"Object[Sample, \"Test sample for samplesForMessages tests 1", ToString@$SessionUUID,
				"\"] and Object[Sample, \"Test sample for samplesForMessages tests 2", ToString@$SessionUUID, "\"]"
			]
		],
		Example[{Options, CollapseForDisplay, "If the first input does match the second input and the number of unique samples is more than 3, resolve CollapseForDisplay to True:"},
			samplesForMessages[
				{
					Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 2" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 3" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 4" <> $SessionUUID]
				},
				{
					Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 2" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 3" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 4" <> $SessionUUID],
					Object[Sample, "id:N80DNj1eYYVo"]
				}
			],
			StringJoin["four of the samples (including ", "Object[Sample, \"Test sample for samplesForMessages tests 1", ToString@$SessionUUID, "\"])"]
		],
		Example[{Options, CollapseForDisplay, "If there is no second input and the number of unique samples is more than 3, resolve CollapseForDisplay to True:"},
			samplesForMessages[
				{
					Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 2" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 3" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 4" <> $SessionUUID]
				}
			],
			StringJoin["four of the samples (including ", "Object[Sample, \"Test sample for samplesForMessages tests 1", ToString@$SessionUUID, "\"])"]
		],
		Example[{Options, CollapseForDisplay, "If CollapseForDisplay is set to True but only 1 input sample, still return the full name of the sample:"},
			samplesForMessages[{Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID]}, CollapseForDisplay -> True],
			StringJoin["Object[Sample, \"Test sample for samplesForMessages tests 1", ToString@$SessionUUID, "\"]"]
		],
		Example[{Options, CollapseForDisplay, "If CollapseForDisplay is set to False, return the name of sample:"},
			samplesForMessages[
				{
					Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 2" <> $SessionUUID]
				},
				CollapseForDisplay -> False
			],
			StringJoin[
				"Object[Sample, \"Test sample for samplesForMessages tests 1", ToString@$SessionUUID,
				"\"] and Object[Sample, \"Test sample for samplesForMessages tests 2", ToString@$SessionUUID, "\"]"
			]
		],
		Example[{Options, SkippedObjectPronouns, "If we are not converting a single object to a string, the object is replaced by 'the sample':"},
			samplesForMessages[{Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID]}, SkipNameConversion -> True],
			"the sample"
		],
		Example[{Options, SkippedObjectPronouns, "If we are not converting multiple objects to strings, the objects are replaced by 'all samples':"},
			samplesForMessages[
				{
					Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 2" <> $SessionUUID]
				},
				SkipNameConversion -> True
			],
			"all samples"
		],
		Example[{Options, SkippedObjectPronouns ,"If we are not converting a single object to a string, the object is replaced by 'the sample':"},
			samplesForMessages[{Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID]}, SkipNameConversion -> True, SkippedObjectPronouns -> {"that","those"}],
			"that sample"
		],
		Example[{Options, SkippedObjectPronouns, "If we are not converting multiple objects to strings, change the pronouns the objects are replaced by:"},
			samplesForMessages[
				{
					Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID],
					Object[Sample, "Test sample for samplesForMessages tests 2" <> $SessionUUID]
				},
				SkipNameConversion -> True,
				SkippedObjectPronouns -> {"that", "those"}
			],
			"those samples"
		],
		Example[{Options, {Cache, Simulation}, "When not given a cache or simulation, the function will download the name from Constellation:"},
			sampleObject = Download[Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID], Object];
			samplesForMessages[{sampleObject}],
			StringJoin["Object[Sample, \"Test sample for samplesForMessages tests 1", ToString@$SessionUUID, "\"]"],
			Variables :> {sampleObject}
		],
		Example[{Options, Cache, "Finding a sample in our cache returns the sample's object notation as a string:"},
			allPackets = Download[{Object[Sample, "id:N80DNj1eYYVo"]}];
			cache = Flatten[allPackets];
			ObjectToString[Object[Sample, "id:N80DNj1eYYVo"], Cache -> cache],
			"Object[Sample, \"id:N80DNj1eYYVo\"]",
			Variables :> {allPackets, cache}
		],
		Example[{Options, Simulation, "When the sample is from simulation, the function will download the name from simulation:"},
			containerPackets = UploadSample[
				Model[Container, Vessel, "50mL Tube"],
				{"Work Surface", Object[Container, Bench, "Test bench for samplesForMessages tests " <> $SessionUUID]},
				Upload -> False,
				SimulationMode -> True,
				FastTrack -> True
			];
			simulationToPassIn = Simulation[containerPackets];
			containerID = Lookup[First[containerPackets], Object];
			samplePackets = UploadSample[
				Model[Sample, "Milli-Q water"],
				{"A1", containerID},
				Name -> "Test simulated sample for samplesForMessages tests " <> $SessionUUID,
				Upload -> False,
				SimulationMode -> True,
				FastTrack -> True,
				InitialAmount -> 25 Milliliter,
				Simulation -> simulationToPassIn
			];
			sampleID = Lookup[First[samplePackets], Object];
			simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];
			samplesForMessages[{sampleID}, Simulation -> simulationToPassIn],
			StringJoin["Object[Sample, \"Test simulated sample for samplesForMessages tests ", ToString@$SessionUUID, "\"]"],
			Variables :> {containerPackets, containerID, sampleID, samplePackets, simulationToPassIn}
		]
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		ClearMemoization[];
		$CreatedObjects = {};
		Module[{allObjects, existingObjects},
			(* Gather all the objects and models created in SymbolSetUp *)
			allObjects = {
				Object[Container, Bench, "Test bench for samplesForMessages tests " <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube for samplesForMessages tests 1" <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube for samplesForMessages tests 2" <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube for samplesForMessages tests 3" <> $SessionUUID],
				Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID],
				Object[Sample, "Test sample for samplesForMessages tests 2" <> $SessionUUID],
				Object[Sample, "Test sample for samplesForMessages tests 3" <> $SessionUUID]
			};

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Block[{$DeveloperUpload = True},
			Module[{allObjects, testBench, containerModel},

				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for samplesForMessages tests " <> $SessionUUID,
					Site -> Link[$Site]
				|>];

				UploadSample[
					{
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Test 50mL Tube for samplesForMessages tests 1" <> $SessionUUID,
						"Test 50mL Tube for samplesForMessages tests 2" <> $SessionUUID,
						"Test 50mL Tube for samplesForMessages tests 3" <> $SessionUUID
					}
				];

				UploadSample[
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"]
					},
					{
						{"A1", Object[Container, Vessel, "Test 50mL Tube for samplesForMessages tests 1" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Test 50mL Tube for samplesForMessages tests 2" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Test 50mL Tube for samplesForMessages tests 3" <> $SessionUUID]}
					},
					InitialAmount -> {1Milliliter, 1Milliliter, 1Milliliter},
					Name -> {
						"Test sample for samplesForMessages tests 1" <> $SessionUUID,
						"Test sample for samplesForMessages tests 2" <> $SessionUUID,
						"Test sample for samplesForMessages tests 3" <> $SessionUUID
					}
				];

			]
		]
	),
	SymbolTearDown :> (
		Module[{allObjects},
			On[Warning::SamplesOutOfStock];
			ClearMemoization[];

			(* Gather all the objects and models created in SymbolSetUp *)
			allObjects = Cases[Flatten[{
				$CreatedObjects,
				Object[Container, Bench, "Test bench for samplesForMessages tests " <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube for samplesForMessages tests 1" <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube for samplesForMessages tests 2" <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube for samplesForMessages tests 3" <> $SessionUUID],
				Object[Sample, "Test sample for samplesForMessages tests 1" <> $SessionUUID],
				Object[Sample, "Test sample for samplesForMessages tests 2" <> $SessionUUID],
				Object[Sample, "Test sample for samplesForMessages tests 3" <> $SessionUUID]
			}], ObjectP[]];


			(* Erase all the created objects *)
			Quiet[EraseObject[allObjects, Force -> True, Verbose -> False]];
			Unset[$CreatedObjects];
		];
	)
];


(* ::Subsubsection::Closed:: *)
(*pluralize*)

DefineTests[pluralize,
	{
		Example[{Basic, "If the input is consist of a single sample, return the singular form of the verb:"},
			pluralize[{Object[Sample, "Test sample for pluralize tests 1" <> $SessionUUID]}, "have"],
			"has"
		],
		Example[{Basic, "If the input is consist of a single sample, return the singular form of the noun:"},
			pluralize[{Object[Sample, "Test sample for pluralize tests 1" <> $SessionUUID]}, "this sample", "these samples"],
			"this sample"
		],
		Example[{Basic, "If the input is consist of 2 samples, return the plural form of the verb:"},
			pluralize[
				{
					Object[Sample, "Test sample for pluralize tests 1" <> $SessionUUID],
					Object[Sample, "Test sample for pluralize tests 2" <> $SessionUUID]
				},
				"have"
			],
			"have"
		],
		Example[{Basic, "If the input is consist of 2 samples, return the plural form of the noun:"},
			pluralize[
				{Object[Sample, "Test sample for pluralize tests 1" <> $SessionUUID]},
				"the sample model and use an alternative sample with a non-deprecated model",
				"the sample models and use alternative samples with non-deprecated models"
			],
			"the sample model and use an alternative sample with a non-deprecated model"
		],
		Example[{Additional "If the input verb is uncommon, return as it is:"},
			pluralize[
				{
					Object[Sample, "Test sample for pluralize tests 1" <> $SessionUUID],
					Object[Sample, "Test sample for pluralize tests 2" <> $SessionUUID]
				},
				"play"
			],
			"play"
		],
		Example[{Basic, "If the input verb is singular form but 2 samples, return the plural form:"},
			pluralize[
				{
					Object[Sample, "Test sample for pluralize tests 1" <> $SessionUUID],
					Object[Sample, "Test sample for pluralize tests 2" <> $SessionUUID]
				},
				"is"
			],
			"are"
		],
		Example[{Additional, "If the input is consist of a single sample and two long strings as singular/plural form, return the singular form:"},
			hasOrHave[{Object[Sample, "Test sample for pluralize tests 1" <> $SessionUUID]}],
			"has"
		],
		Example[{Additional, "If the input is consist of a single sample and verb is have, return has:"},
			hasOrHave[{Object[Sample, "Test sample for pluralize tests 1" <> $SessionUUID]}],
			"has"
		],
		Example[{Additional, "If the input is consist of a single sample and verb is be, return is:"},
			isOrAre[{Object[Sample, "Test sample for pluralize tests 1" <> $SessionUUID]}],
			"is"
		],
		Example[{Additional, "If the input is consist of 2 samples and verb is be, return are:"},
			isOrAre[
				{
					Object[Sample, "Test sample for pluralize tests 1" <> $SessionUUID],
					Object[Sample, "Test sample for pluralize tests 2" <> $SessionUUID]
				}
			],
			"are"
		]
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		ClearMemoization[];
		$CreatedObjects = {};
		Module[{allObjects, existingObjects},
			(* Gather all the objects and models created in SymbolSetUp *)
			allObjects = {
				Object[Container, Bench, "Test bench for pluralize tests " <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube for pluralize tests 1" <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube for pluralize tests 2" <> $SessionUUID],
				Object[Sample, "Test sample for pluralize tests 1" <> $SessionUUID],
				Object[Sample, "Test sample for pluralize tests 2" <> $SessionUUID]
			};

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Block[{$DeveloperUpload = True},
			Module[{allObjects, testBench, containerModel},

				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for pluralize tests " <> $SessionUUID,
					Site -> Link[$Site]
				|>];

				UploadSample[
					{
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Test 50mL Tube for pluralize tests 1" <> $SessionUUID,
						"Test 50mL Tube for pluralize tests 2" <> $SessionUUID
					}
				];

				UploadSample[
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"]
					},
					{
						{"A1", Object[Container, Vessel, "Test 50mL Tube for pluralize tests 1" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Test 50mL Tube for pluralize tests 2" <> $SessionUUID]}
					},
					InitialAmount -> {1Milliliter, 1Milliliter},
					Name -> {
						"Test sample for pluralize tests 1" <> $SessionUUID,
						"Test sample for pluralize tests 2" <> $SessionUUID
					}
				];

			]
		]
	),
	SymbolTearDown :> (
		Module[{allObjects},
			On[Warning::SamplesOutOfStock];
			ClearMemoization[];

			(* Gather all the objects and models created in SymbolSetUp *)
			allObjects = Cases[Flatten[{
				$CreatedObjects,
				Object[Container, Bench, "Test bench for pluralize tests " <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube for pluralize tests 1" <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube for pluralize tests 2" <> $SessionUUID],
				Object[Sample, "Test sample for pluralize tests 1" <> $SessionUUID],
				Object[Sample, "Test sample for spluralize tests 2" <> $SessionUUID]
			}], ObjectP[]];


			(* Erase all the created objects *)
			Quiet[EraseObject[allObjects, Force -> True, Verbose -> False]];
			Unset[$CreatedObjects];
		];
	)
];


(* ::Subsection:: *)
(*ValidOpenPathsQ*)
DefineTests[ValidOpenPathsQ,
  {
    Example[{Basic, "Indicates if OpenPaths is specified properly in all options for the specified function:"},
      Module[{testFunction},
        DefineOptions[testFunction,
          Options :> {
            {
              OptionName -> Tips,
              Default -> Automatic,
              AllowNull -> True,
              Widget -> Widget[
                Type -> Object,
                Pattern :> ObjectP[{
                  Model[Item, Tips],
                  Object[Item, Tips]
                }],
                OpenPaths -> {
                  {
                    Object[Catalog, "Root"],
                    "Labware",
                    "Pipette Tips"
                  }
                }
              ],
              Description -> "The pipette tips used to aspirate and dispense the retentate wash and resuspension buffers."
            }
          }
        ];
        testFunction[]:=Null;
        ValidOpenPathsQ[testFunction]
      ],
      True
    ],
    Example[{Basic, "If OpenPaths is not specified at all for an option that takes models, products, or methods, returns False:"},
      Module[{testFunction},
        DefineOptions[testFunction,
          Options :> {
            {
              OptionName -> Tips,
              Default -> Automatic,
              AllowNull -> True,
              Widget -> Widget[
                Type -> Object,
                Pattern :> ObjectP[{
                  Model[Item, Tips],
                  Object[Item, Tips]
                }]
              ],
              Description -> "The pipette tips used to aspirate and dispense the retentate wash and resuspension buffers."
            }
          }
        ];
        testFunction[]:=Null;
        ValidOpenPathsQ[testFunction]
      ],
      False
    ],
    Example[{Options, OutputFormat, "If OutputFormat is set to Options instead of Boolean, a list of options that are failing ValidOpenPathsQ is returned:"},
      Module[{testFunction},
        DefineOptions[testFunction,
          Options :> {
            {
              OptionName -> Tips,
              Default -> Automatic,
              AllowNull -> True,
              Widget -> Widget[
                Type -> Object,
                Pattern :> ObjectP[{
                  Model[Item, Tips],
                  Object[Item, Tips]
                }]
              ],
              Description -> "The pipette tips used to aspirate and dispense the retentate wash and resuspension buffers."
            }
          }
        ];
        testFunction[]:=Null;
        ValidOpenPathsQ[testFunction, OutputFormat -> Options]
      ],
      {Tips}
    ],
    Example[{Additional, "Hidden options don't need to have OpenPaths specified:"},
      Module[{testFunction},
        DefineOptions[testFunction,
          Options :> {
            {
              OptionName -> Tips,
              Default -> Automatic,
              AllowNull -> True,
              Widget -> Widget[
                Type -> Object,
                Pattern :> ObjectP[{
                  Model[Item, Tips],
                  Object[Item, Tips]
                }]
              ],
              Description -> "The pipette tips used to aspirate and dispense the retentate wash and resuspension buffers.",
              Category -> "Hidden"
            }
          }
        ];
        testFunction[]:=Null;
        ValidOpenPathsQ[testFunction]
      ],
      True
    ],
    Example[{Additional, "Also check the usage and return False if we don't have open paths there:"},
      Module[{testFunction},
        DefineUsage[testFunction,
          {
            BasicDefinitions -> {
              {
                Definition -> {"testFunction[Sample]", "Null"},
                Description -> "always returns Null.",
                Inputs :> {
                  IndexMatching[
                    {
                      InputName -> "Sample",
                      Description -> "The input Model[Sample]",
                      Widget -> Widget[
                        Type -> Object,
                        Pattern :> ObjectP[Model[Sample]]
                      ],
                      Expandable -> False
                    },
                    IndexName -> "experiment samples"
                  ]
                },
                Outputs :> {
                  {
                    OutputName -> "Null",
                    Description -> "Always returns Null.",
                    Pattern :> Null
                  }
                }
              }
            },
            MoreInformation -> {},
            SeeAlso -> {
              "PickList",
              "ExperimentNMR",
              "WhyCantIPickThisSample"
            },
            Author -> {"steven"}
          }
        ];
        DefineOptions[testFunction,
          Options :> {
            {
              OptionName -> Tips,
              Default -> Automatic,
              AllowNull -> True,
              Widget -> Widget[
                Type -> Object,
                Pattern :> ObjectP[{
                  Model[Item, Tips],
                  Object[Item, Tips]
                }],
                OpenPaths -> {
                  {
                    Object[Catalog, "Root"],
                    "Labware",
                    "Pipette Tips"
                  }
                }
              ],
              Description -> "The pipette tips used to aspirate and dispense the retentate wash and resuspension buffers.",
              Category -> "Hidden"
            }
          }
        ];
        testFunction[ObjectP[]]:=Null;
        ValidOpenPathsQ[testFunction]
      ],
      False
    ]
  }
];