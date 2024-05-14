(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)

(* ::Subsection::Closed:: *)
(*ExperimentAdjustpHPreview*)

DefineTests[
	ExperimentAdjustpHPreview,
	{
		(* - ExperimentAdjustpHPreview - *)
		Example[{Basic,"No preview is currently available for ExperimentAdjustpH:"},
			ExperimentAdjustpHPreview[Object[Sample,"ExperimentAdjustpHPreview test object sample 1 available" <> $SessionUUID],9],
			Null,
			TimeConstraint->300
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed, try using ExperimentAdjustpHOptions:"},
			ExperimentAdjustpHOptions[Object[Sample,"ExperimentAdjustpHPreview test object sample 1 available" <> $SessionUUID],9],
			_Grid,
			TimeConstraint->300
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentAdjustpHQ:"},
			ValidExperimentAdjustpHQ[Object[Sample,"ExperimentAdjustpHPreview test object sample 1 available" <> $SessionUUID],9],
			True,
			TimeConstraint->300
		]
	},

	SymbolSetUp:>(
		(* Set $CreatedObjects to {} to catch all of objects created *)
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Off[Warning::NegativeDiluentVolume];

		Module[{allObjects,existingObjects},
			allObjects=
				{
					Object[Container,Bench,"Fake bench for ExperimentAdjustpHPreview tests" <> $SessionUUID],
					Object[Container,Vessel,"ExperimentAdjustpHPreview test object container 1 available" <> $SessionUUID],
					Object[Container,Vessel,"ExperimentAdjustpHPreview test object container 2 discarded" <> $SessionUUID],
					Object[Sample,"ExperimentAdjustpHPreview test object sample 1 available" <> $SessionUUID],
					Object[Sample,"ExperimentAdjustpHPreview test object sample 2 discarded" <> $SessionUUID]
				};
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];


		Block[{$AllowSystemsProtocols=True},

				(*Fake Bench Object*)
			Upload[
					<|
						Type->Object[Container,Bench],
						Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
						Name->"Fake bench for ExperimentAdjustpHPreview tests" <> $SessionUUID,
						StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
						DeveloperObject->True
					|>
				];

				(*Fake Containers*)
				UploadSample[
					{Model[Container,Vessel,"50mL Tube"],Model[Container,Vessel,"50mL Tube"]},
					{
						{"Work Surface", Object[Container,Bench,"Fake bench for ExperimentAdjustpHPreview tests" <> $SessionUUID]},
						{"Work Surface", Object[Container,Bench,"Fake bench for ExperimentAdjustpHPreview tests" <> $SessionUUID]}
					},
					Name->{
						"ExperimentAdjustpHPreview test object container 1 available" <> $SessionUUID,
						"ExperimentAdjustpHPreview test object container 2 discarded" <> $SessionUUID
					},
					StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]]
				];

			(*Fake Samples*)
			UploadSample[
				{Model[Sample, StockSolution, "id:E8zoYveRllb5"],Model[Sample, StockSolution, "id:E8zoYveRllb5"]},
				{
					{"A1", Object[Container,Vessel,"ExperimentAdjustpHPreview test object container 1 available" <> $SessionUUID]},
					{"A1", Object[Container,Vessel,"ExperimentAdjustpHPreview test object container 2 discarded" <> $SessionUUID]}
				},
				Name->{
					"ExperimentAdjustpHPreview test object sample 1 available" <> $SessionUUID,
					"ExperimentAdjustpHPreview test object sample 2 discarded" <> $SessionUUID
				},
				InitialAmount->{35Milliliter,35Milliliter},
				StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]]
			];

			UploadSampleStatus[{Object[Sample,"ExperimentAdjustpHPreview test object sample 1 available" <> $SessionUUID],Object[Sample,"ExperimentAdjustpHPreview test object sample 2 discarded" <> $SessionUUID]},
				{Available,Discarded}
			]
		]
	),


	SymbolTearDown:>{
		Module[{allObjects,existingObjects},
			allObjects=
				{
					Object[Container,Bench,"Fake bench for ExperimentAdjustpHPreview tests" <> $SessionUUID],
					Object[Container,Vessel,"ExperimentAdjustpHPreview test object container 1 available" <> $SessionUUID],
					Object[Container,Vessel,"ExperimentAdjustpHPreview test object container 2 discarded" <> $SessionUUID],
					Object[Sample,"ExperimentAdjustpHPreview test object sample 1 available" <> $SessionUUID],
					Object[Sample,"ExperimentAdjustpHPreview test object sample 2 discarded" <> $SessionUUID]

				};
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
		];
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}

];





(* ::Subsection::Closed:: *)
(*ExperimentAdjustpHOptions*)

DefineTests[
	ExperimentAdjustpHOptions,
	{

		(* - ExperimentAdjustpHOptions - *)
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			ExperimentAdjustpHOptions[Object[Sample,"ExperimentAdjustpHOptions test object sample 1 available" <> $SessionUUID],9],
			_Grid,
			TimeConstraint->300
		],
		Example[{Basic,"View any potential issues with provided inputs/options displayed:"},
			ExperimentAdjustpHOptions[Object[Sample,"ExperimentAdjustpHOptions test object sample 2 discarded" <> $SessionUUID],9],
			_Grid,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			},
			TimeConstraint->300
		],
		Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentAdjustpHOptions[Object[Sample,"ExperimentAdjustpHOptions test object sample 1 available" <> $SessionUUID],9,OutputFormat->List],
			{(_Rule|_RuleDelayed)..},
			TimeConstraint->300
		]
	},

	SymbolSetUp:>(
		(* Set $CreatedObjects to {} to catch all of objects created *)
		$CreatedObjects={};
		Off[Warning::NegativeDiluentVolume];

		Module[{allObjects,existingObjects},
			allObjects=
				{
					Object[Container,Bench,"Fake bench for ExperimentAdjustpHOptions tests" <> $SessionUUID],
					Object[Container,Vessel,"ExperimentAdjustpHOptions test object container 1 available" <> $SessionUUID],
					Object[Container,Vessel,"ExperimentAdjustpHOptions test object container 2 discarded" <> $SessionUUID],
					Object[Sample,"ExperimentAdjustpHOptions test object sample 1 available" <> $SessionUUID],
					Object[Sample,"ExperimentAdjustpHOptions test object sample 2 discarded" <> $SessionUUID]
				};
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];


		Block[{$AllowSystemsProtocols=True},

			(*Fake Bench Object*)
			Upload[
				<|
					Type->Object[Container,Bench],
					Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
					Name->"Fake bench for ExperimentAdjustpHOptions tests" <> $SessionUUID,
					StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
					DeveloperObject->True
				|>
			];

			(*Fake Containers*)
			UploadSample[
				{Model[Container,Vessel,"50mL Tube"],Model[Container,Vessel,"50mL Tube"]},
				{
					{"Work Surface", Object[Container,Bench,"Fake bench for ExperimentAdjustpHOptions tests" <> $SessionUUID]},
					{"Work Surface", Object[Container,Bench,"Fake bench for ExperimentAdjustpHOptions tests" <> $SessionUUID]}
				},
				Name->{
					"ExperimentAdjustpHOptions test object container 1 available" <> $SessionUUID,
					"ExperimentAdjustpHOptions test object container 2 discarded" <> $SessionUUID
				},
				StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]]
			];

			(*Fake Samples*)
			UploadSample[
				{Model[Sample, StockSolution, "id:E8zoYveRllb5"],Model[Sample, StockSolution, "id:E8zoYveRllb5"]},
				{
					{"A1", Object[Container,Vessel,"ExperimentAdjustpHOptions test object container 1 available" <> $SessionUUID]},
					{"A1", Object[Container,Vessel,"ExperimentAdjustpHOptions test object container 2 discarded" <> $SessionUUID]}
				},
				Name->{
					"ExperimentAdjustpHOptions test object sample 1 available" <> $SessionUUID,
					"ExperimentAdjustpHOptions test object sample 2 discarded" <> $SessionUUID
				},
				InitialAmount->{35Milliliter,35Milliliter},
				StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]]
			];

			UploadSampleStatus[{Object[Sample,"ExperimentAdjustpHOptions test object sample 1 available" <> $SessionUUID],Object[Sample,"ExperimentAdjustpHOptions test object sample 2 discarded" <> $SessionUUID]},
				{Available,Discarded}
			]
		]
	),


	SymbolTearDown:>{
		Module[{allObjects,existingObjects},
			allObjects=
				{
					Object[Container,Bench,"Fake bench for ExperimentAdjustpHOptions tests" <> $SessionUUID],
					Object[Container,Vessel,"ExperimentAdjustpHOptions test object container 1 available" <> $SessionUUID],
					Object[Container,Vessel,"ExperimentAdjustpHOptions test object container 2 discarded" <> $SessionUUID],
					Object[Sample,"ExperimentAdjustpHOptions test object sample 1 available" <> $SessionUUID],
					Object[Sample,"ExperimentAdjustpHOptions test object sample 2 discarded" <> $SessionUUID]

				};
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			On[Warning::SamplesOutOfStock]
		];
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}

];



(* ::Subsection::Closed:: *)
(*ExperimentAdjustpHPreview*)

DefineTests[ValidExperimentAdjustpHQ,
	{

		(* - ValidExperimentAdjustpHQ - *)
		Example[{Basic,"Verify that the experiment can be run without issues:"},
			ValidExperimentAdjustpHQ[Object[Sample,"ValidExperimentAdjustpHQ test object sample 1 available" <> $SessionUUID],9],
			True,
			TimeConstraint->300
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentAdjustpHQ[Object[Sample,"ValidExperimentAdjustpHQ test object sample 2 discarded" <> $SessionUUID],9],
			False,
			TimeConstraint->300
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentAdjustpHQ[Object[Sample,"ValidExperimentAdjustpHQ test object sample 1 available" <> $SessionUUID],9,OutputFormat->TestSummary],
			_EmeraldTestSummary,
			TimeConstraint->300
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentAdjustpHQ[Object[Sample,"ValidExperimentAdjustpHQ test object sample 1 available" <> $SessionUUID],9,Verbose->True],
			True,
			TimeConstraint->300
		]
	},

	SymbolSetUp:>(
		(* Set $CreatedObjects to {} to catch all of objects created *)
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::NegativeDiluentVolume];
		ClearMemoization[];

		Module[{allObjects,existingObjects},
			allObjects=
				{
					Object[Container,Bench,"Fake bench for ValidExperimentAdjustpHQ tests" <> $SessionUUID],
					Object[Container,Vessel,"ValidExperimentAdjustpHQ test object container 1 available" <> $SessionUUID],
					Object[Container,Vessel,"ValidExperimentAdjustpHQ test object container 2 discarded" <> $SessionUUID],
					Object[Sample,"ValidExperimentAdjustpHQ test object sample 1 available" <> $SessionUUID],
					Object[Sample,"ValidExperimentAdjustpHQ test object sample 2 discarded" <> $SessionUUID]
				};
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];


		Block[{$AllowSystemsProtocols=True},

			(*Fake Bench Object*)
			Upload[
				<|
					Type->Object[Container,Bench],
					Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
					Name->"Fake bench for ValidExperimentAdjustpHQ tests" <> $SessionUUID,
					StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
					DeveloperObject->True
				|>
			];

			(*Fake Containers*)
			UploadSample[
				{Model[Container,Vessel,"50mL Tube"],Model[Container,Vessel,"50mL Tube"]},
				{
					{"Work Surface", Object[Container,Bench,"Fake bench for ValidExperimentAdjustpHQ tests" <> $SessionUUID]},
					{"Work Surface", Object[Container,Bench,"Fake bench for ValidExperimentAdjustpHQ tests" <> $SessionUUID]}
				},
				Name->{
					"ValidExperimentAdjustpHQ test object container 1 available" <> $SessionUUID,
					"ValidExperimentAdjustpHQ test object container 2 discarded" <> $SessionUUID
				},
				StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]]
			];

			(*Fake Samples*)
			UploadSample[
				{Model[Sample, StockSolution, "id:E8zoYveRllb5"],Model[Sample, StockSolution, "id:E8zoYveRllb5"]},
				{
					{"A1", Object[Container,Vessel,"ValidExperimentAdjustpHQ test object container 1 available" <> $SessionUUID]},
					{"A1", Object[Container,Vessel,"ValidExperimentAdjustpHQ test object container 2 discarded" <> $SessionUUID]}
				},
				Name->{
					"ValidExperimentAdjustpHQ test object sample 1 available" <> $SessionUUID,
					"ValidExperimentAdjustpHQ test object sample 2 discarded" <> $SessionUUID
				},
				InitialAmount->{35Milliliter,35Milliliter},
				StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]]
			];

			Map[Upload[<|Object->#,DeveloperObject->True|>]&,
				{
					Object[Sample,"ValidExperimentAdjustpHQ test object sample 1 available" <> $SessionUUID],
					Object[Sample,"ValidExperimentAdjustpHQ test object sample 2 discarded" <> $SessionUUID],
					Object[Container,Vessel,"ValidExperimentAdjustpHQ test object container 1 available" <> $SessionUUID],
					Object[Container,Vessel,"ValidExperimentAdjustpHQ test object container 2 discarded" <> $SessionUUID]
				}
			];

			UploadSampleStatus[{Object[Sample,"ValidExperimentAdjustpHQ test object sample 1 available" <> $SessionUUID],Object[Sample,"ValidExperimentAdjustpHQ test object sample 2 discarded" <> $SessionUUID]},
				{Available,Discarded}
			]
		]
	),


	SymbolTearDown:>{
		Module[{allObjects,existingObjects},
			allObjects=
				{
					Object[Container,Bench,"Fake bench for ValidExperimentAdjustpHQ tests" <> $SessionUUID],
					Object[Container,Vessel,"ValidExperimentAdjustpHQ test object container 1 available" <> $SessionUUID],
					Object[Container,Vessel,"ValidExperimentAdjustpHQ test object container 2 discarded" <> $SessionUUID],
					Object[Sample,"ValidExperimentAdjustpHQ test object sample 1 available" <> $SessionUUID],
					Object[Sample,"ValidExperimentAdjustpHQ test object sample 2 discarded" <> $SessionUUID]
				};
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			On[Warning::SamplesOutOfStock];
			On[Warning::NegativeDiluentVolume];
		];
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
]