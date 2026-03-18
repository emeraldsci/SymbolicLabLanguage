

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

(* ::Title:: *)
(*ExperimentWaterPreparation : Tests*)


(* ::Section::Closed:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentWaterPreparation*)


(* ::Subsubsection::Closed:: *)
(*ExperimentWaterPreparation*)


DefineTests[ExperimentWaterPreparation,
	{
		Example[{Basic,"Generate a WaterPreparation Protocol with single inputs:"},
			ExperimentWaterPreparation[
				Model[Sample, "id:8qZ1VWNmdLBD"],
				Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				25 Milliliter
			],
			ObjectP[Object[Protocol,WaterPreparation]]
		],
		Example[{Basic, "WaterPreparation is allowed from one source to multiple destination with multiple amounts:"},
			ExperimentWaterPreparation[
				Model[Sample, "Milli-Q water"],
				{
					Model[Container, Vessel, "id:bq9LA0dBGGR6"],
					Model[Container, Vessel, "id:bq9LA0dBGGR6"]
				},
				{
					20 Milliliter,
					30 Milliliter
				}
			],
			ObjectP[Object[Protocol, WaterPreparation]]
		],
		Example[{Additional, "WaterPreparation automatically expand source/destination/amount singletons to match the length of the listed input:"},
			{
				(* a, b, {c, c} *)
				ExperimentWaterPreparation[
					Model[Sample, "Milli-Q water"],
					Model[Container, Vessel, "id:bq9LA0dBGGR6"],
					{20 Milliliter, 30 Milliliter}
				],
				(* a, {b, b}, c *)
				ExperimentWaterPreparation[
					Model[Sample, "Milli-Q water"],
					{Model[Container, Vessel, "id:bq9LA0dBGGR6"], Model[Container, Vessel, "id:bq9LA0dBGGR6"]},
					25 Milliliter
				],
				(* {a, a}, b, c *)
				ExperimentWaterPreparation[
					{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
					Model[Container, Vessel, "id:bq9LA0dBGGR6"],
					20 Milliliter
				],
				(* a, {b, b}, {c, c} *)
				ExperimentWaterPreparation[
					Model[Sample, "Milli-Q water"],
					{Model[Container, Vessel, "id:bq9LA0dBGGR6"], Model[Container, Vessel, "id:bq9LA0dBGGR6"]},
					{20 Milliliter, 30 Milliliter}
				],
				(* {a, a}, b, {c, c} *)
				ExperimentWaterPreparation[
					{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
					Model[Container, Vessel, "id:bq9LA0dBGGR6"],
					{20 Milliliter, 30 Milliliter}
				],
				(* {a, a}, {b, b}, c *)
				ExperimentWaterPreparation[
					{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
					{Model[Container, Vessel, "id:bq9LA0dBGGR6"], Model[Container, Vessel, "id:bq9LA0dBGGR6"]},
					25 Milliliter
				]
			},
			{ObjectP[Object[Protocol, WaterPreparation]]..}
		],

		Example[{Options, Confirm, "Indicates if the protocols generated should be confirmed for execution immediately upon creation and skip the InCart status:"},
			Module[
				{myProtocol},
				myProtocol = ExperimentWaterPreparation[
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Container, Vessel, "id:bq9LA0dBGGR6"],
					25 Milliliter,
					Confirm->True
				];
				Download[myProtocol,Status]
			],
			Processing|ShippingMaterials|Backlogged
		],

		Example[{Options, CanaryBranch, "Specify the CanaryBranch on which the protocol is run:"},
			Module[
				{myProtocol},
				myProtocol = ExperimentWaterPreparation[
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Container, Vessel, "id:bq9LA0dBGGR6"],
					25 Milliliter,
					CanaryBranch->"d1cacc5a-948b-4843-aa46-97406bbfc368"];
				Download[myProtocol,CanaryBranch]
			],
			"d1cacc5a-948b-4843-aa46-97406bbfc368",
			Stubs:>{GitBranchExistsQ[___] = True, InternalUpload`Private`sllDistroExistsQ[___] = True, $PersonID = Object[User, Emerald, Developer, "id:n0k9mGkqa6Gr"]}
		],
		
		Example[{Options,WaterSourceInstrument,"Specify the Water Purifier or Sink that will be used in water preparation:"},
			Lookup[
				ExperimentWaterPreparation[
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Container, Vessel, "id:bq9LA0dBGGR6"],
					25 Milliliter,
					WaterSourceInstrument->Model[Instrument, WaterPurifier, "id:AEqRl9qA8WZa"],
					Output->Options
				],WaterSourceInstrument],
			ObjectP[Model[Instrument, WaterPurifier, "id:AEqRl9qA8WZa"]]
		],
		Example[{Options,WaterSourceInstrumentFlushTime,"Specify the WaterInstrumentFlushTime that is used in water preparation:"},
			Lookup[
				ExperimentWaterPreparation[
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Container, Vessel, "id:bq9LA0dBGGR6"],
					25 Milliliter,
					WaterSourceInstrumentFlushTime->45 Second,
					Output->Options
				],WaterSourceInstrumentFlushTime],
			EqualP[45 Second]
		],
		Example[{Options,RinseContainer,"Specify the containers are rinsed prior to dispensing in water preparation:"},
			Lookup[
				ExperimentWaterPreparation[
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Container, Vessel, "id:bq9LA0dBGGR6"],
					25 Milliliter,
					RinseContainer->True,
					Output->Options
				],RinseContainer],
			True
		],
		Example[{Options,RinseContainerTime,"Specify the RinseContainerTime that is used in water preparation:"},
			Lookup[
				ExperimentWaterPreparation[
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Container, Vessel, "id:bq9LA0dBGGR6"],
					25 Milliliter,
					RinseContainerTime->45 Second,
					Output->Options
				],RinseContainerTime],
			EqualP[45 Second]
		],
		Example[{Options,NumberOfContainerRinses,"Specify the NumberOfContainerRinses that is used in water preparation:"},
			Lookup[
				ExperimentWaterPreparation[
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Container, Vessel, "id:bq9LA0dBGGR6"],
					25 Milliliter,
					NumberOfContainerRinses->4,
					Output->Options
				],NumberOfContainerRinses],
			EqualP[4]
		],
		Example[{Options,RinseCap,"Specify the caps are rinsed prior to dispensing in water preparation:"},
			Lookup[
				ExperimentWaterPreparation[
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Container, Vessel, "id:bq9LA0dBGGR6"],
					25 Milliliter,
					RinseCap->True,
					Output->Options
				],RinseCap],
			True
		],
		Example[{Options,RinseCapTime,"Specify the RinseCapTime that is used in water preparation:"},
			Lookup[
				ExperimentWaterPreparation[
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Container, Vessel, "id:bq9LA0dBGGR6"],
					25 Milliliter,
					RinseCapTime->45 Second,
					Output->Options
				],RinseCapTime],
			EqualP[45 Second]
		],
		Example[{Options,NumberOfCapRinses,"Specify the NumberOfCapRinses that is used in water preparation:"},
			Lookup[
				ExperimentWaterPreparation[
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Container, Vessel, "id:bq9LA0dBGGR6"],
					25 Milliliter,
					NumberOfCapRinses->4,
					Output->Options
				],NumberOfCapRinses],
			EqualP[4]
		],
		Example[{Options,PreparedResources,"Specify the PreparedResources to be fulfilled by the experiment:"},
			Download[
				ExperimentWaterPreparation[
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Container, Vessel, "id:bq9LA0dBGGR6"],
					25 Milliliter,
					PreparedResources->Object[Resource,Sample,"Test Resource Sample 1 for ExperimentWaterPreparation"<>$SessionUUID]
				],PreparedResources],
			{ObjectP[Object[Resource,Sample,"Test Resource Sample 1 for ExperimentWaterPreparation"<>$SessionUUID]]}
		],

		(*Messages: Warnings*)
		Example[{Messages,"InvalidWaterSourceInstrument","An Error is thrown if the WaterSourceInstrument specified is not compatible with the water model requested:"},
			ExperimentWaterPreparation[
				Model[Sample, "id:8qZ1VWNmdLBD"],
				Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				25 Milliliter,
				WaterSourceInstrument->Model[Instrument, Sink, "id:zGj91a7av4JE"]
			],
			$Failed,
			Messages :> {
				Error::InvalidWaterSourceInstrument,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidRinseContainerTime","An Error is thrown if RinseContainerTime is specified as a quantity and RinseContainer is False:"},
			ExperimentWaterPreparation[
				Model[Sample, "id:8qZ1VWNmdLBD"],
				Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				25 Milliliter,
				RinseContainer->False,
				RinseContainerTime->45 Second
			],
			$Failed,
			Messages :> {
				Error::InvalidRinseContainerTime,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidRinseContainerTime","An Error is thrown if RinseContainerTime is specified as Null and RinseContainer is True:"},
			ExperimentWaterPreparation[
				Model[Sample, "id:8qZ1VWNmdLBD"],
				Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				25 Milliliter,
				RinseContainerTime->Null
			],
			$Failed,
			Messages :> {
				Error::InvalidRinseContainerTime,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidNumberOfContainerRinses","An Error is thrown if NumberOfContainerRinses is specified as a number and RinseContainer is False:"},
			ExperimentWaterPreparation[
				Model[Sample, "id:8qZ1VWNmdLBD"],
				Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				25 Milliliter,
				RinseContainer->False,
				NumberOfContainerRinses->4
			],
			$Failed,
			Messages :> {
				Error::InvalidNumberOfContainerRinses,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidNumberOfContainerRinses","An Error is thrown if NumberOfContainerRinses is specified as Null and RinseContainer is True:"},
			ExperimentWaterPreparation[
				Model[Sample, "id:8qZ1VWNmdLBD"],
				Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				25 Milliliter,
				NumberOfContainerRinses->Null
			],
			$Failed,
			Messages :> {
				Error::InvalidNumberOfContainerRinses,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidRinseCapTime","An Error is thrown if RinseCapTime is specified as a quantity and RinseCap is False:"},
			ExperimentWaterPreparation[
				Model[Sample, "id:8qZ1VWNmdLBD"],
				Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				25 Milliliter,
				RinseCap->False,
				RinseCapTime->45 Second
			],
			$Failed,
			Messages :> {
				Error::InvalidRinseCapTime,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidRinseCapTime","An Error is thrown if RinseCapTime is specified as Null and RinseCap is True:"},
			ExperimentWaterPreparation[
				Model[Sample, "id:8qZ1VWNmdLBD"],
				Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				25 Milliliter,
				RinseCapTime->Null
			],
			$Failed,
			Messages :> {
				Error::InvalidRinseCapTime,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidNumberOfCapRinses","An Error is thrown if NumberOfCapRinses is specified as a number and RinseCap is False:"},
			ExperimentWaterPreparation[
				Model[Sample, "id:8qZ1VWNmdLBD"],
				Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				25 Milliliter,
				RinseCap->False,
				NumberOfCapRinses->4
			],
			$Failed,
			Messages :> {
				Error::InvalidNumberOfCapRinses,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidNumberOfCapRinses","An Error is thrown if NumberOfCapRinses is specified as Null and RinseCap is True:"},
			ExperimentWaterPreparation[
				Model[Sample, "id:8qZ1VWNmdLBD"],
				Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				25 Milliliter,
				NumberOfCapRinses->Null
			],
			$Failed,
			Messages :> {
				Error::InvalidNumberOfCapRinses,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidPreparedResources","An Error is thrown if PreparedResources is not appropriate with the input model:"},
			ExperimentWaterPreparation[
				Model[Sample, "id:8qZ1VWNmdLBD"],
				Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				25 Milliliter,
				PreparedResources->Object[Resource,Sample,"Test Resource Sample 2 for ExperimentWaterPreparation"<>$SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::InvalidPreparedResources,
				Error::InvalidOption
			}
		],
		Example[{Messages,"OverfilledContainer","An Error is thrown if the amount specified is greater than the MaxVolume of the container specified:"},
			ExperimentWaterPreparation[
				Model[Sample, "id:8qZ1VWNmdLBD"],
				Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				100 Milliliter
			],
			$Failed,
			Messages :> {
				Error::OverfilledContainer,
				Error::InvalidInput
			}
		]
	},
	SymbolSetUp:>Module[
		{
			createdObjects
			
		},

		$CreatedObjects = {};
		ClearMemoization[];

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		createdObjects={
			Object[Resource,Sample,"Test Resource Sample 1 for ExperimentWaterPreparation"<>$SessionUUID],
			Object[Resource,Sample,"Test Resource Sample 2 for ExperimentWaterPreparation"<>$SessionUUID]
		};

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		EraseObject[
			PickList[createdObjects,DatabaseMemberQ[createdObjects]],
			Force->True,
			Verbose->False
		];
		
		Upload[{
			<|
				Type->Object[Resource,Sample],
				Name->"Test Resource Sample 1 for ExperimentWaterPreparation"<>$SessionUUID,
				Replace[Models]->{Link[Model[Sample, "id:8qZ1VWNmdLBD"]]}
			|>,
			<|
				Type->Object[Resource,Sample],
				Name->"Test Resource Sample 2 for ExperimentWaterPreparation"<>$SessionUUID,
				Replace[Models]->{Link[Model[Sample, "id:1ZA60vwjbbea"]]}
			|>
		}]
	],

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
];

(* ::Subsection::Closed:: *)
(*ExperimentWaterPreparationOptions*)

DefineTests[
	ExperimentWaterPreparationOptions,
	{
		Example[{Basic,"Display the option values which will be used in the WaterPreparation experiment:"},
			ExperimentWaterPreparationOptions[
				Model[Sample, "id:8qZ1VWNmdLBD"],
				Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				25 Milliliter
			],
			_Grid
		],
		Example[{Basic,"View any potential issues with provided inputs/options displayed:"},
			ExperimentWaterPreparationOptions[
				Model[Sample, "id:8qZ1VWNmdLBD"],
				Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				25 Milliliter,
				RinseContainerTime->Null
			],
			_Grid,
			Messages:>{
				Error::InvalidRinseContainerTime,
				Error::InvalidOption
			}
		],
		Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentWaterPreparationOptions[
				Model[Sample, "id:8qZ1VWNmdLBD"],
				Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				25 Milliliter,
				OutputFormat->List
			],
			{(_Rule|_RuleDelayed)..}
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	)
];

(* ::Subsection::Closed:: *)
(*ValidExperimentWaterPreparationQ*)

DefineTests[
	ValidExperimentWaterPreparationQ,
	{
		Example[{Basic,"Returns a Boolean indicating the validity of a WaterPreparation experiment:"},
			ValidExperimentWaterPreparationQ[
				Model[Sample, "id:8qZ1VWNmdLBD"],
				Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				25 Milliliter
			],
			True,
			Stubs:>{
			}
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentWaterPreparationQ[
				Model[Sample, "id:8qZ1VWNmdLBD"],
				Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				25 Milliliter,
				RinseContainerTime->Null
			],
			False
		],
		Example[{Options,Verbose,"If Verbose -> True, returns the passing and failing tests:"},
			ValidExperimentWaterPreparationQ[
				Model[Sample, "id:8qZ1VWNmdLBD"],
				Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				25 Milliliter,
				RinseContainerTime->Null,
				Verbose->True
			],
			False
		],
		Example[{Options,OutputFormat,"If OutputFormat -> TestSummary, returns a test summary instead of a Boolean:"},
			ValidExperimentWaterPreparationQ[
				Model[Sample, "id:8qZ1VWNmdLBD"],
				Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				25 Milliliter,
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	)
];

(* ::Subsection::Closed:: *)
(*ExperimentWaterPreparationPreview*)

DefineTests[
	ExperimentWaterPreparationPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentWaterPreparation:"},
			ExperimentWaterPreparationPreview[
				Model[Sample, "id:8qZ1VWNmdLBD"],
				Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				25 Milliliter
			],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed, try using ExperimentWaterPreparationOptions:"},
			ExperimentWaterPreparationOptions[
				Model[Sample, "id:8qZ1VWNmdLBD"],
				Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				25 Milliliter
			],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentWaterPreparationQ:"},
			ValidExperimentWaterPreparationQ[
				Model[Sample, "id:8qZ1VWNmdLBD"],
				Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				25 Milliliter
			],
			True
		]
	},
	Stubs:>{ (* Set global Variables *)
		$EmailEnabled=False,
		$AllowSystemsProtocols=True
	},
	SetUp:>( (* before and after EVERY test *)
		$CreatedObjects={}
	),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		(* Turn off the SamplesOutOfStock warning for unit tests *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::AliquotRequired];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::AliquotRequired];
		ClearMemoization[];
	)

];

(* ::Section::Closed:: *)
(*End Test Package*)
