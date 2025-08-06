(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExperimentAssembleCrossFlowFiltrationTubing*)


DefineTests[
	ExperimentAssembleCrossFlowFiltrationTubing,
	{
		Example[
			{Basic,"Enqueue a protocol to build a precut tubing:"},
			ExperimentAssembleCrossFlowFiltrationTubing[Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to FLL 0.5 Meter"]],
			ObjectP[Object[Protocol,AssembleCrossFlowFiltrationTubing]]
		],

		Example[
			{Basic,"Enqueue a protocol to build multiple precut tubings:"},
			ExperimentAssembleCrossFlowFiltrationTubing[{Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to FLL 0.5 Meter"],Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to MQD 0.5 Meter"]}],
			ObjectP[Object[Protocol,AssembleCrossFlowFiltrationTubing]]
		],

		Example[
			{Basic,"Specify a count when building a precut tubing:"},
			ExperimentAssembleCrossFlowFiltrationTubing[Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to FLL 0.5 Meter"],2],
			ObjectP[Object[Protocol,AssembleCrossFlowFiltrationTubing]]
		],

		Example[
			{Basic,"Specify counts when building multiple precut tubing:"},
			ExperimentAssembleCrossFlowFiltrationTubing[{Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to FLL 0.5 Meter"],Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to MQD 0.5 Meter"]},{2,3}],
			ObjectP[Object[Protocol,AssembleCrossFlowFiltrationTubing]]
		],

		Example[
			{Messages,"ObjectDoesNotExist","An error message is shown if the precut tubing model does not exist:"},
			ExperimentAssembleCrossFlowFiltrationTubing[Model[Plumbing,PrecutTubing,"Does Not Exist"]],
			$Failed,
			Messages:>{Error::ObjectDoesNotExist, Error::InvalidInput}
		],

		Example[
			{Messages,"deprecatedTubingModel","An error message is shown if the tubing model is deprecated:"},
			ExperimentAssembleCrossFlowFiltrationTubing[Model[Plumbing,PrecutTubing,"ExperimentAssembleCrossFlowFiltrationTubing Deprecated Test Model" <> $SessionUUID]],
			$Failed,
			Messages:>{Error::deprecatedTubingModel, Error::InvalidInput}
		],

		Example[
			{Messages,"modelCountLengthMismatch","An error message is shown if the length of specified tubing models does not match the length of counts:"},
			ExperimentAssembleCrossFlowFiltrationTubing[{Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to FLL 0.5 Meter"],Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to MQD 0.5 Meter"]},{2,3,2}],
			$Failed,
			Messages:>{Error::modelCountLengthMismatch, Error::InvalidInput}
		],

		Test[
			"If Upload->False, returns the packets:",
			ExperimentAssembleCrossFlowFiltrationTubing[Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to FLL 0.5 Meter"],Upload->False],
			{PacketP[]..}
		],

		Test[
			"Works properly when cache is provided:",
			ExperimentAssembleCrossFlowFiltrationTubing[
				Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to FLL 0.5 Meter"],
				Cache->{
					<|
						Object->Model[Plumbing,PrecutTubing,"id:4pO6dM5rv0N5"],
						ID->"id:4pO6dM5rv0N5",
						Type->Model[Plumbing,PrecutTubing],
						Deprecated->Null,
						Size->Quantity[0.5,"Meters"],
						Gauge->14,
						ParentTubing->Link[Model[Plumbing,Tubing,"id:KBL5DvwDr6Dn"],"E8zoYv8kwMVA"],
						Connectors->{{"Inlet",QuickDisconnect,None,Null,Null,Female},{"Outlet",LuerLock,None,Null,Null,Female}}
					|>
				}
			],
			ObjectP[Object[Protocol,AssembleCrossFlowFiltrationTubing]]
		],

		Test[
			"Skips error checking when FastTrack->True:",
			ExperimentAssembleCrossFlowFiltrationTubing[Model[Plumbing,PrecutTubing,"ExperimentAssembleCrossFlowFiltrationTubing Deprecated Test Model" <> $SessionUUID],FastTrack->True],
			ObjectP[Object[Protocol,AssembleCrossFlowFiltrationTubing]]
		],

		Test[
			"ParentProtocol is populated when specified:",
			Module[{},
				protocol=ExperimentAssembleCrossFlowFiltrationTubing[Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to FLL 0.5 Meter"],ParentProtocol->Object[Protocol,CrossFlowFiltration,"ExperimentAssembleCrossFlowFiltrationTubing Parent Protocol" <> $SessionUUID]];
				Download[protocol,ParentProtocol]
			],
			ObjectP[Object[Protocol,CrossFlowFiltration,"ExperimentAssembleCrossFlowFiltrationTubing Parent Protocol" <> $SessionUUID]],
			Variables:>{protocol}
		],

		Test[
			"Protocol is not confirmed when Confirm->False:",
			Module[{},
				protocol=ExperimentAssembleCrossFlowFiltrationTubing[Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to FLL 0.5 Meter"],Confirm->False];
				Download[protocol,Status]
			],
			InCart,
			Variables:>{protocol}
		],

		Test[
			"Specify the CanaryBranch on which the protocol is run:",
			Module[{},
				protocol=ExperimentAssembleCrossFlowFiltrationTubing[Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to FLL 0.5 Meter"],CanaryBranch -> "d1cacc5a-948b-4843-aa46-97406bbfc368"];
				Download[protocol, CanaryBranch]],
			"d1cacc5a-948b-4843-aa46-97406bbfc368",
			Variables:>{protocol},
			Stubs:>{GitBranchExistsQ[___] = True, $PersonID = Object[User, Emerald, Developer, "id:n0k9mGkqa6Gr"]}
		]
	},

	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		{
			Module[{namedObjects,existsFilter,prot},

				(* Initialize $CreatedObjects *)
				$CreatedObjects={};

				(* Test objects we will create *)
				namedObjects={
					Model[Plumbing,PrecutTubing,"ExperimentAssembleCrossFlowFiltrationTubing Deprecated Test Model" <> $SessionUUID],
					Object[Protocol,CrossFlowFiltration,"ExperimentAssembleCrossFlowFiltrationTubing Parent Protocol" <> $SessionUUID],
					Object[Container,Vessel,"Assemble Cross Flow Test 250 mL Bottle (I) "<>$SessionUUID],
					Object[Sample,"Assemble Cross Flow Test Sample (I) "<>$SessionUUID],
					Model[Sample,"Assemble Cross Flow Test Sample "<>$SessionUUID]
				};

				(* Check whether the names already exist in the database *)
				existsFilter=DatabaseMemberQ[namedObjects];

				(* Erase any objects that exists in the database *)
				EraseObject[PickList[namedObjects,existsFilter],Force->True,Verbose->False];

				(* make sample for crossflow protocol *)
				Upload[{
					<|
						Type->Model[Sample],
						Name->"Assemble Cross Flow Test Sample "<>$SessionUUID,
						Replace[Composition]->{
							{100 VolumePercent,Link[Model[Molecule,"Water"]]},
							{1 Molar,Link[Model[Molecule,Oligomer,"Biolytic Test 40mer"]]},
							{1 Molar,Link[Model[Molecule,Protein,"PARP"]]}
						},
						Replace[IncompatibleMaterials]->None,
						State->Liquid,
						DefaultStorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
						DeveloperObject->True
					|>,
					<|
						Type->Object[Container,Vessel],
						Name->"Assemble Cross Flow Test 250 mL Bottle (I) "<>$SessionUUID,
						Model->Link[Model[Container,Vessel,"250mL Glass Bottle"],Objects],
						DeveloperObject->True
					|>
				}];

				ECL`InternalUpload`UploadSample[
					{
						Model[Sample,"Assemble Cross Flow Test Sample "<>$SessionUUID]
					},
					{
						{"A1",Object[Container,Vessel,"Assemble Cross Flow Test 250 mL Bottle (I) "<>$SessionUUID]}
					},
					Name->{
						"Assemble Cross Flow Test Sample (I) "<>$SessionUUID
					},
					InitialAmount->{
						250 Milliliter
					},
					Status->{
						Available
					}
				];
				(* fake CrossFlow protocol *)
				ExperimentCrossFlowFiltration[Object[Sample,"Assemble Cross Flow Test Sample (I) "<>$SessionUUID], Name->"ExperimentAssembleCrossFlowFiltrationTubing Parent Protocol" <> $SessionUUID];

				(* Upload objects *)
				Upload[{
					<|
						Type->Model[Plumbing,PrecutTubing],
						Name->"ExperimentAssembleCrossFlowFiltrationTubing Deprecated Test Model" <> $SessionUUID,
						Deprecated->True,
						ParentTubing->Link[Model[Plumbing,Tubing,"id:KBL5DvwDr6Dn"]],
						Replace[Connectors]->{{"Inlet",QuickDisconnect,None,Null,Null,Female},{"Outlet",LuerLock,None,Null,Null,Female}}
					|>
				}];

			]
		}
	),

	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		(* Erase all created objects *)
		EraseObject[$CreatedObjects,Force->True,Verbose->False];

		(* Unset $CreatedObjects *)
		$CreatedObjects=.;
	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];


(* ::Subsubsection:: *)
(*ExperimentAssembleCrossFlowFiltrationTubingOptions*)


DefineTests[
	ExperimentAssembleCrossFlowFiltrationTubingOptions,
	{
		Example[
			{Basic,"Display the option values which will be used to assemble cross flow filtration tubing:"},
			ExperimentAssembleCrossFlowFiltrationTubingOptions[Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to FLL 0.5 Meter"]],
			_Grid
		],

		Example[
			{Basic,"Display the option values which will be used to assemble cross flow filtration tubing:"},
			ExperimentAssembleCrossFlowFiltrationTubingOptions[{Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to FLL 0.5 Meter"],Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to MQD 0.5 Meter"]}],
			_Grid
		],

		Example[
			{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentAssembleCrossFlowFiltrationTubingOptions[Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to FLL 0.5 Meter"],OutputFormat->List],
			{(_Rule|_RuleDelayed)..}
		]

	},

	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{namedObjects,existsFilter,prot},

			(* Initialize $CreatedObjects *)
			$CreatedObjects={};

			(* Test objects we will create *)
			namedObjects={
				Model[Plumbing,PrecutTubing,"ExperimentAssembleCrossFlowFiltrationTubing Deprecated Test Model" <> $SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[namedObjects];

			(* Erase any objects that exists in the database *)
			EraseObject[PickList[namedObjects,existsFilter],Force->True,Verbose->False];

			(* Upload objects *)
			Upload[{
				<|
					Type->Model[Plumbing,PrecutTubing],
					Name->"ExperimentAssembleCrossFlowFiltrationTubing Deprecated Test Model" <> $SessionUUID,
					Deprecated->True,
					ParentTubing->Link[Model[Plumbing,Tubing,"id:KBL5DvwDr6Dn"]],
					Replace[Connectors]->{{"Inlet",QuickDisconnect,None,Null,Null,Female},{"Outlet",LuerLock,None,Null,Null,Female}}
				|>
			}];

		]
	),

	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	),

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];



(* ::Subsubsection:: *)
(*ValidExperimentAssembleCrossFlowFiltrationTubingQ*)


DefineTests[
	ValidExperimentAssembleCrossFlowFiltrationTubingQ,
	{
		Example[
			{Basic,"Returns a Boolean indicating the validity of an assemble cross flow filtration tubing protocol:"},
			ValidExperimentAssembleCrossFlowFiltrationTubingQ[Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to FLL 0.5 Meter"]],
			True
		],

		Example[
			{Basic,"Returns a Boolean indicating the validity of an assemble cross flow filtration tubing protocol:"},
			ValidExperimentAssembleCrossFlowFiltrationTubingQ[{Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to FLL 0.5 Meter"],Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to MQD 0.5 Meter"]}],
			True
		],

		Example[
			{Basic,"Returns False indicating the invalidity of an assemble cross flow filtration tubing protocol:"},
			ValidExperimentAssembleCrossFlowFiltrationTubingQ[{Model[Plumbing,PrecutTubing,"ExperimentAssembleCrossFlowFiltrationTubing Deprecated Test Model" <> $SessionUUID],Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to MQD 0.5 Meter"]}],
			False
		],

		Example[
			{Options,Verbose,"If Verbose -> True, returns the passing and failing tests:"},
			ValidExperimentAssembleCrossFlowFiltrationTubingQ[{Model[Plumbing,PrecutTubing,"ExperimentAssembleCrossFlowFiltrationTubing Deprecated Test Model" <> $SessionUUID],Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to MQD 0.5 Meter"]}, Verbose->True],
			False
		],

		Example[
			{Options,OutputFormat,"If OutputFormat -> TestSummary, returns a test summary instead of a Boolean:"},
			ValidExperimentAssembleCrossFlowFiltrationTubingQ[Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to FLL 0.5 Meter"],OutputFormat->TestSummary],
			_EmeraldTestSummary
		]

	},

	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{namedObjects,existsFilter,prot},

			(* Initialize $CreatedObjects *)
			$CreatedObjects={};

			(* Test objects we will create *)
			namedObjects={
				Model[Plumbing,PrecutTubing,"ExperimentAssembleCrossFlowFiltrationTubing Deprecated Test Model" <> $SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[namedObjects];

			(* Erase any objects that exists in the database *)
			EraseObject[PickList[namedObjects,existsFilter],Force->True,Verbose->False];

			(* Upload objects *)
			Upload[{
				<|
					Type->Model[Plumbing,PrecutTubing],
					Name->"ExperimentAssembleCrossFlowFiltrationTubing Deprecated Test Model" <> $SessionUUID,
					Deprecated->True,
					ParentTubing->Link[Model[Plumbing,Tubing,"id:KBL5DvwDr6Dn"]],
					Replace[Connectors]->{{"Inlet",QuickDisconnect,None,Null,Null,Female},{"Outlet",LuerLock,None,Null,Null,Female}}
				|>
			}];

		]
	),

	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		(* Erase all created objects *)
		EraseObject[$CreatedObjects,Force->True,Verbose->False];

		(* Unset $CreatedObjects *)
		$CreatedObjects=.;
	),

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];

(* ::Subsubsection:: *)
(*ExperimentAssembleCrossFlowFiltrationTubingPreview*)


DefineTests[
	ExperimentAssembleCrossFlowFiltrationTubingPreview,
	{
		Example[
			{Basic,"No Preview is currently available for ExperimentAssembleCrossFlowFiltrationTubing :"},
			ExperimentAssembleCrossFlowFiltrationTubingPreview[Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to FLL 0.5 Meter"]],
			Null
		],

		Example[
			{Basic,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentAssembleCrossFlowFiltrationTubingQ:"},
			ValidExperimentAssembleCrossFlowFiltrationTubingQ[{Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to FLL 0.5 Meter"],Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to MQD 0.5 Meter"]}],
			True
		],

		Example[
			{Basic,"If you wish to understand how the experiment will be performed, try using ExperimentAssembleCrossFlowFiltrationTubingOptions:"},
			ExperimentAssembleCrossFlowFiltrationTubingOptions[{Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to FLL 0.5 Meter"],Model[Plumbing,PrecutTubing,"PharmaPure #14 FQD to MQD 0.5 Meter"]}],
			_Grid
		]

	},

	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{namedObjects,existsFilter,prot},

			(* Initialize $CreatedObjects *)
			$CreatedObjects={};

			(* Test objects we will create *)
			namedObjects={
				Model[Plumbing,PrecutTubing,"ExperimentAssembleCrossFlowFiltrationTubing Deprecated Test Model" <> $SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[namedObjects];

			(* Erase any objects that exists in the database *)
			EraseObject[PickList[namedObjects,existsFilter],Force->True,Verbose->False];

			(* Upload objects *)
			Upload[{
				<|
					Type->Model[Plumbing,PrecutTubing],
					Name->"ExperimentAssembleCrossFlowFiltrationTubing Deprecated Test Model" <> $SessionUUID,
					Deprecated->True,
					ParentTubing->Link[Model[Plumbing,Tubing,"id:KBL5DvwDr6Dn"]],
					Replace[Connectors]->{{"Inlet",QuickDisconnect,None,Null,Null,Female},{"Outlet",LuerLock,None,Null,Null,Female}}
				|>
			}];

		]
	),

	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		(* Erase all created objects *)
		EraseObject[$CreatedObjects,Force->True,Verbose->False];

		(* Unset $CreatedObjects *)
		$CreatedObjects=.;
	),

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];


(* ::Section:: *)
(*End Test Package*)
