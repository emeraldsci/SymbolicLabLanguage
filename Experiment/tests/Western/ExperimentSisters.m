(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)

(* ::Subsection::Closed:: *)
(*ExperimentWesternPreview*)
DefineTests[
	ExperimentWesternPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentWestern:"},
			ExperimentWesternPreview[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWesternPreview"<> $SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWesternPreview"<> $SessionUUID]],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed, try using ExperimentWesternOptions:"},
			ExperimentWesternOptions[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWesternPreview"<> $SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWesternPreview"<> $SessionUUID]],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentWesternQ:"},
			ValidExperimentWesternQ[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWesternPreview"<> $SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWesternPreview"<> $SessionUUID]],
			True
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>{
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
		allObjects=
      {
				Object[Container,Vessel,"Test 2mL Tube 1 for ExperimentWesternPreview"<> $SessionUUID],
				Object[Container,Vessel,"Test 2mL Tube 2 for ExperimentWesternPreview"<> $SessionUUID],
				Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWesternPreview"<> $SessionUUID],
				Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWesternPreview"<> $SessionUUID]
			};

		(* Erase any objects that we failed to erase in the last unit test *)
		existsFilter=DatabaseMemberQ[allObjects];

		Quiet[EraseObject[
			PickList[
				allObjects,
				existsFilter
			],
			Force->True,
			Verbose->False
		]];

		(* Create some empty containers *)
		{container1,container2}=Upload[{
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],
				Name->"Test 2mL Tube 1 for ExperimentWesternPreview"<> $SessionUUID,
				DeveloperObject->True,
				Site-> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],
				Name->"Test 2mL Tube 2 for ExperimentWesternPreview"<> $SessionUUID,
				DeveloperObject->True,
				Site-> Link[$Site]
			|>
		}];

		(* Create some samples for testing purposes *)
		{lysateSample,antibodySample}=UploadSample[
			{
				Model[Sample, "id:WNa4ZjKMrPeD"],
				Model[Sample, "id:54n6evLJxqqP"]
			},
			{
				{"A1",container1},
				{"A1",container2}
			},
			Name->{
				"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWesternPreview"<> $SessionUUID,
				"Test Rabbit-AntiERK-1 antibody for ExperimentWesternPreview"<> $SessionUUID
			}
		];

		(* Make some changes to our samples for testing purposes *)
		Upload[{
			<|Object->lysateSample,Status->Available,DeveloperObject->True,Volume->1*Milliliter,TotalProteinConcentration->0.25*Milligram/Milliliter|>,
			<|Object->antibodySample,Status->Available,DeveloperObject->True,Volume->1*Milliliter|>
		}];
	},
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[allObjects,Force->True,Verbose->False];
	}
];

(* ::Subsection::Closed:: *)
(*ExperimentWesternOptions*)
DefineTests[
	ExperimentWesternOptions,
	{
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			ExperimentWesternOptions[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWesternOptions"<> $SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWesternOptions"<> $SessionUUID]],
			_Grid
		],
		Example[{Basic,"View any potential issues with provided inputs/options displayed:"},
			ExperimentWesternOptions[Object[Sample,"Discarded Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWesternOptions"<> $SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWesternOptions"<> $SessionUUID]],
			_Grid,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentWesternOptions[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWesternOptions"<> $SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWesternOptions"<> $SessionUUID],OutputFormat->List],
			{(_Rule|_RuleDelayed)..}
		]
	},
	Stubs:>{
	(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>{
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

	(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
		allObjects=
				{
					Object[Container,Vessel,"Test 2mL Tube 1 for ExperimentWesternOptions"<> $SessionUUID],
					Object[Container,Vessel,"Test 2mL Tube 2 for ExperimentWesternOptions"<> $SessionUUID],
					Object[Container,Vessel,"Test 2mL Tube 3 for ExperimentWesternOptions"<> $SessionUUID],
					Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWesternOptions"<> $SessionUUID],
					Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWesternOptions"<> $SessionUUID],
					Object[Sample,"Discarded Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWesternOptions"<> $SessionUUID]
				};

		(* Erase any objects that we failed to erase in the last unit test *)
		existsFilter=DatabaseMemberQ[allObjects];

		Quiet[EraseObject[
			PickList[
				allObjects,
				existsFilter
			],
			Force->True,
			Verbose->False
		]];

		(* Create some empty containers *)
		{container1,container2,container3}=Upload[{
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],
				Name->"Test 2mL Tube 1 for ExperimentWesternOptions"<> $SessionUUID,
				DeveloperObject->True,
				Site-> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],
				Name->"Test 2mL Tube 2 for ExperimentWesternOptions"<> $SessionUUID,
				DeveloperObject->True,
				Site-> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],
				Name->"Test 2mL Tube 3 for ExperimentWesternOptions"<> $SessionUUID,
				DeveloperObject->True,
				Site-> Link[$Site]
			|>
		}];

		(* Create some samples for testing purposes *)
		{lysateSample,antibodySample,discardedLysate}=UploadSample[
			{
				Model[Sample, "id:WNa4ZjKMrPeD"],
				Model[Sample, "id:54n6evLJxqqP"],
				Model[Sample, "id:WNa4ZjKMrPeD"]
			},
			{
				{"A1",container1},
				{"A1",container2},
				{"A1",container3}
			},
			Name->{
				"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWesternOptions"<> $SessionUUID,
				"Test Rabbit-AntiERK-1 antibody for ExperimentWesternOptions"<> $SessionUUID,
				"Discarded Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWesternOptions"<> $SessionUUID
			}
		];

		(* Make some changes to our samples for testing purposes *)
		Upload[{
			<|Object->lysateSample,Status->Available,DeveloperObject->True,Volume->1*Milliliter,TotalProteinConcentration->0.25*Milligram/Milliliter|>,
			<|Object->antibodySample,Status->Available,DeveloperObject->True,Volume->1*Milliliter|>,
			<|Object->discardedLysate,Status->Discarded,DeveloperObject->True,Volume->1*Milliliter,TotalProteinConcentration->0.25*Milligram/Milliliter|>
		}];
	},
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[allObjects,Force->True,Verbose->False];
	}
];

(* ::Subsection::Closed:: *)
(*ValidExperimentWesternQ*)
DefineTests[
	ValidExperimentWesternQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issues:"},
			ValidExperimentWesternQ[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ValidExperimentWesternQ"<> $SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ValidExperimentWesternQ"<> $SessionUUID]],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentWesternQ[Object[Sample,"Discarded Test 1 mL lysate sample, 0.25 mg/mL total protein for ValidExperimentWesternQ"<> $SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ValidExperimentWesternQ"<> $SessionUUID]],
			False
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentWesternQ[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ValidExperimentWesternQ"<> $SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ValidExperimentWesternQ"<> $SessionUUID],OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentWesternQ[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ValidExperimentWesternQ"<> $SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ValidExperimentWesternQ"<> $SessionUUID],Verbose->True],
			True
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>{
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
		allObjects=
				{
					Object[Container,Vessel,"Test 2mL Tube 1 for ValidExperimentWesternQ"<> $SessionUUID],
					Object[Container,Vessel,"Test 2mL Tube 2 for ValidExperimentWesternQ"<> $SessionUUID],
					Object[Container,Vessel,"Test 2mL Tube 3 for ValidExperimentWesternQ"<> $SessionUUID],
					Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ValidExperimentWesternQ"<> $SessionUUID],
					Object[Sample,"Test Rabbit-AntiERK-1 antibody for ValidExperimentWesternQ"<> $SessionUUID],
					Object[Sample,"Discarded Test 1 mL lysate sample, 0.25 mg/mL total protein for ValidExperimentWesternQ"<> $SessionUUID]
				};

		(* Erase any objects that we failed to erase in the last unit test *)
		existsFilter=DatabaseMemberQ[allObjects];

		Quiet[EraseObject[
			PickList[
				allObjects,
				existsFilter
			],
			Force->True,
			Verbose->False
		]];

		(* Create some empty containers *)
		{container1,container2,container3}=Upload[{
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],
				Name->"Test 2mL Tube 1 for ValidExperimentWesternQ"<> $SessionUUID,
				DeveloperObject->True,
				Site-> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],
				Name->"Test 2mL Tube 2 for ValidExperimentWesternQ"<> $SessionUUID,
				DeveloperObject->True,
				Site-> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],
				Name->"Test 2mL Tube 3 for ValidExperimentWesternQ"<> $SessionUUID,
				DeveloperObject->True,
				Site-> Link[$Site]
			|>
		}];

		(* Create some samples for testing purposes *)
		{lysateSample,antibodySample,discardedLysate}=UploadSample[
			{
				Model[Sample, "id:WNa4ZjKMrPeD"],
				Model[Sample, "id:54n6evLJxqqP"],
				Model[Sample, "id:WNa4ZjKMrPeD"]
			},
			{
				{"A1",container1},
				{"A1",container2},
				{"A1",container3}
			},
			Name->{
				"Test 1 mL lysate sample, 0.25 mg/mL total protein for ValidExperimentWesternQ"<> $SessionUUID,
				"Test Rabbit-AntiERK-1 antibody for ValidExperimentWesternQ"<> $SessionUUID,
				"Discarded Test 1 mL lysate sample, 0.25 mg/mL total protein for ValidExperimentWesternQ"<> $SessionUUID
			}
		];

		(* Make some changes to our samples for testing purposes *)
		Upload[{
			<|Object->lysateSample,Status->Available,DeveloperObject->True,Volume->1*Milliliter,TotalProteinConcentration->0.25*Milligram/Milliliter|>,
			<|Object->antibodySample,Status->Available,DeveloperObject->True,Volume->1*Milliliter|>,
			<|Object->discardedLysate,Status->Discarded,DeveloperObject->True,Volume->1*Milliliter,TotalProteinConcentration->0.25*Milligram/Milliliter|>
		}];
	},
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[allObjects,Force->True,Verbose->False];
	}
];
