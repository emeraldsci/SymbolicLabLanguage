(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)

(* ::Subsection::Closed:: *)
(*ExperimentTotalProteinDetectionPreview*)
DefineTests[
	ExperimentTotalProteinDetectionPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentTotalProteinDetection:"},
			ExperimentTotalProteinDetectionPreview[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetectionPreview"]],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed, try using ExperimentTotalProteinDetectionOptions:"},
			ExperimentTotalProteinDetectionOptions[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetectionPreview"]],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentTotalProteinDetectionQ:"},
			ValidExperimentTotalProteinDetectionQ[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetectionPreview"]],
			True
		]
	},
	Stubs:>{
	(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>{

		(* Turn off the SamplesOutOfStock warning for unit tests *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

	(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
		allObjects=
				{
					Object[Container,Vessel,"Test 2mL Tube 1 for ExperimentTotalProteinDetectionPreview"],
					Object[Container,Vessel,"Test 2mL Tube 2 for ExperimentTotalProteinDetectionPreview"],
					Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetectionPreview"],
					Object[Sample,"Discarded Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetectionPreview"]
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
				Name->"Test 2mL Tube 1 for ExperimentTotalProteinDetectionPreview",
				DeveloperObject->True,
				Site->Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],
				Name->"Test 2mL Tube 2 for ExperimentTotalProteinDetectionPreview",
				DeveloperObject->True,
				Site->Link[$Site]
			|>
		}];

		(* Create some samples for testing purposes *)
		{lysateSample,discardedLysate}=UploadSample[
			{
				Model[Sample, "id:WNa4ZjKMrPeD"],
				Model[Sample, "id:WNa4ZjKMrPeD"]
			},
			{
				{"A1",container1},
				{"A1",container2}
			},
			Name->{
				"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetectionPreview",
				"Discarded Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetectionPreview"
			}
		];

		(* Make some changes to our samples for testing purposes *)
		Upload[{
			<|Object->lysateSample,Status->Available,DeveloperObject->True,Volume->1*Milliliter,TotalProteinConcentration->0.25*Milligram/Milliliter|>,
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
(*ExperimentTotalProteinDetectionOptions*)
DefineTests[
	ExperimentTotalProteinDetectionOptions,
	{
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			ExperimentTotalProteinDetectionOptions[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetectionOptions"]],
			_Grid
		],
		Example[{Basic,"View any potential issues with provided inputs/options displayed:"},
			ExperimentTotalProteinDetectionOptions[Object[Sample,"Discarded Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetectionOptions"]],
			_Grid,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentTotalProteinDetectionOptions[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetectionOptions"],OutputFormat->List],
			{(_Rule|_RuleDelayed)..}
		]
	},
	Stubs:>{
	(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>{

		(* Turn off the SamplesOutOfStock warning for unit tests *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
		allObjects=
				{
					Object[Container,Vessel,"Test 2mL Tube 1 for ExperimentTotalProteinDetectionOptions"],
					Object[Container,Vessel,"Test 2mL Tube 2 for ExperimentTotalProteinDetectionOptions"],
					Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetectionOptions"],
					Object[Sample,"Discarded Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetectionOptions"]
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
				Name->"Test 2mL Tube 1 for ExperimentTotalProteinDetectionOptions",
				DeveloperObject->True,
				Site->Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],
				Name->"Test 2mL Tube 2 for ExperimentTotalProteinDetectionOptions",
				DeveloperObject->True,
				Site->Link[$Site]
			|>
		}];

		(* Create some samples for testing purposes *)
		{lysateSample,discardedLysate}=UploadSample[
			{
				Model[Sample, "id:WNa4ZjKMrPeD"],
				Model[Sample, "id:WNa4ZjKMrPeD"]
			},
			{
				{"A1",container1},
				{"A1",container2}
			},
			Name->{
				"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetectionOptions",
				"Discarded Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentTotalProteinDetectionOptions"
			}
		];

		(* Make some changes to our samples for testing purposes *)
		Upload[{
			<|Object->lysateSample,Status->Available,DeveloperObject->True,Volume->1*Milliliter,TotalProteinConcentration->0.25*Milligram/Milliliter|>,
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
(*ValidExperimentTotalProteinDetectionQ*)
DefineTests[
	ValidExperimentTotalProteinDetectionQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issues:"},
			ValidExperimentTotalProteinDetectionQ[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ValidExperimentTotalProteinDetectionQ"]],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentTotalProteinDetectionQ[Object[Sample,"Discarded Test 1 mL lysate sample, 0.25 mg/mL total protein for ValidExperimentTotalProteinDetectionQ"]],
			False
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentTotalProteinDetectionQ[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ValidExperimentTotalProteinDetectionQ"],OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentTotalProteinDetectionQ[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ValidExperimentTotalProteinDetectionQ"],Verbose->True],
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
					Object[Container,Vessel,"Test 2mL Tube 1 for ValidExperimentTotalProteinDetectionQ"],
					Object[Container,Vessel,"Test 2mL Tube 2 for ValidExperimentTotalProteinDetectionQ"],
					Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ValidExperimentTotalProteinDetectionQ"],
					Object[Sample,"Discarded Test 1 mL lysate sample, 0.25 mg/mL total protein for ValidExperimentTotalProteinDetectionQ"]
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
				Name->"Test 2mL Tube 1 for ValidExperimentTotalProteinDetectionQ",
				DeveloperObject->True,
				Site->Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],
				Name->"Test 2mL Tube 2 for ValidExperimentTotalProteinDetectionQ",
				DeveloperObject->True,
				Site->Link[$Site]
			|>
		}];

		(* Create some samples for testing purposes *)
		{lysateSample,discardedLysate}=UploadSample[
			{
				Model[Sample, "id:WNa4ZjKMrPeD"],
				Model[Sample, "id:WNa4ZjKMrPeD"]
			},
			{
				{"A1",container1},
				{"A1",container2}
			},
			Name->{
				"Test 1 mL lysate sample, 0.25 mg/mL total protein for ValidExperimentTotalProteinDetectionQ",
				"Discarded Test 1 mL lysate sample, 0.25 mg/mL total protein for ValidExperimentTotalProteinDetectionQ"
			}
		];

		(* Make some changes to our samples for testing purposes *)
		Upload[{
			<|Object->lysateSample,Status->Available,DeveloperObject->True,Volume->1*Milliliter,TotalProteinConcentration->0.25*Milligram/Milliliter|>,
			<|Object->discardedLysate,Status->Discarded,DeveloperObject->True,Volume->1*Milliliter,TotalProteinConcentration->0.25*Milligram/Milliliter|>
		}];
	},
	SymbolTearDown:>{
		EraseObject[allObjects,Force->True,Verbose->False];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	}
];
