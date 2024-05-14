(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineTests[CheckManifoldSmokeTest,
	{
		Example[{Basic,"Start and check a manifold smoke test:"},
			mySmokeTest=RunManifoldSmokeTest[];

			CheckManifoldSmokeTest[mySmokeTest],
			BooleanP
		]
	},
	Skip -> "Manifold"
];

DefineTests[RunManifoldSmokeTest,
	{
		Example[{Basic,"Run a manifold smoke test:"},
			mySmokeTest=RunManifoldSmokeTest[];

			CheckManifoldSmokeTest[mySmokeTest],
			BooleanP
		]
	},
	Skip -> "Manifold"
];

(* ::Subsection::Closed:: *)
(*ActivateJob*)


DefineTests[ActivateJob,
	{
		Example[{Basic,"Activate a single Manifold job by changing its Status field to Active, and return the activated job's object reference:"},
			ActivateJob[Object[Notebook,Job,"Inactive Job 1 for AJ"]],
			ObjectP[Object[Notebook,Job]]
		],
		Example[{Basic,"Activate multiple Manifold jobs by changing their Status fields to Active, and return all activated objects:"},
			ActivateJob[{
				Object[Notebook,Job,"Inactive Job 2 for AJ"],
				Object[Notebook,Job,"Active Job 3 for AJ"],
				Object[Notebook,Job,"Inactive Job 4 for AJ"]
			}],
			{ObjectP[Object[Notebook,Job]]..},
			Messages:>{Warning::NoStatusChange}
		],
		Test["Activated jobs have a status of Active:",
			Download[
				ActivateJob[{
					Object[Notebook,Job,"Inactive Job 6 for AJ"]
				}],
				Status
			],
			{Active}
		],
		Example[{Messages,"JobNotFound","Warning is shown if one or more input objects cannot be found in the database. This can occur if the object does not exist, or if you do not have permissions to view/modify the input object:"},
			ActivateJob[{Object[Notebook,Job,"Inactive Job 5 for AJ"],Object[Notebook,Job,"This job does not exist"]}],
			{ObjectP[Object[Notebook,Job]],$Failed},
			Messages:>{Warning::JobNotFound}
		],
		Example[{Messages,"NoStatusChange","Warning is shown if one or more input jobs already had a Status of Active. These jobs will remain unchanged:"},
			ActivateJob[{Object[Notebook,Job,"Active Job 7 for AJ"], Object[Notebook,Job,"Inactive Job 8 for AJ"]}],
			{ObjectP[Object[Notebook,Job]]..},
			Messages:>{Warning::NoStatusChange}
		]
	},

	(* Create Test Objects *)
	SymbolSetUp:>Module[{allTestObjects,existingObjects},
		(* Initiate object tracking *)
		$CreatedObjects={};

		(* All named objects used by these unit tests *)
		allTestObjects={
			Object[Notebook,Job,"Inactive Job 1 for AJ"],
			Object[Notebook,Job,"Inactive Job 2 for AJ"],
			Object[Notebook,Job,"Active Job 3 for AJ"],
			Object[Notebook,Job,"Inactive Job 4 for AJ"],
			Object[Notebook,Job,"Inactive Job 5 for AJ"],
			Object[Notebook,Job,"Inactive Job 6 for AJ"],
			Object[Notebook,Job,"Active Job 7 for AJ"],
			Object[Notebook,Job,"Inactive Job 8 for AJ"]
		};

		(* Grab any test objects which are already in database *)
		existingObjects=PickList[allTestObjects,DatabaseMemberQ[allTestObjects]];

		(* Erase any objects which we failed to erase from the last unit test *)
		Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

		(* Upload test objects *)
		Upload[{
			<|Type->Object[Notebook,Job], Name->"Inactive Job 1 for AJ", Status->Inactive, DeveloperObject->True|>,
			<|Type->Object[Notebook,Job], Name->"Inactive Job 2 for AJ", Status->Inactive, DeveloperObject->True|>,
			<|Type->Object[Notebook,Job], Name->"Active Job 3 for AJ", Status->Active, DeveloperObject->True|>,
			<|Type->Object[Notebook,Job], Name->"Inactive Job 4 for AJ", Status->Inactive, DeveloperObject->True|>,
			<|Type->Object[Notebook,Job], Name->"Inactive Job 5 for AJ", Status->Inactive, DeveloperObject->True|>,
			<|Type->Object[Notebook,Job], Name->"Inactive Job 6 for AJ", Status->Inactive, DeveloperObject->True|>,
			<|Type->Object[Notebook,Job], Name->"Active Job 7 for AJ", Status->Active, DeveloperObject->True|>,
			<|Type->Object[Notebook,Job], Name->"Inactive Job 8 for AJ", Status->Inactive, DeveloperObject->True|>
		}];
	],

	(* Erase all test objects created during these unit tests *)
	SymbolTearDown:>Module[{},
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
	]
];


(* ::Subsection::Closed:: *)
(*DeactivateJob*)


DefineTests[DeactivateJob,
	{
		Example[{Basic,"Deactivate a single Manifold job by changing its Status field to Inactive, and return the deactivated job's object reference:"},
			DeactivateJob[Object[Notebook,Job,"Active Job 1 for DJ"]],
			ObjectP[Object[Notebook,Job]]
		],
		Example[{Basic,"Deactivate multiple Manifold jobs by changing their Status fields to Inactive, and return all inactivated objects:"},
			DeactivateJob[{
				Object[Notebook,Job,"Active Job 2 for DJ"],
				Object[Notebook,Job,"Inactive Job 3 for DJ"],
				Object[Notebook,Job,"Active Job 4 for DJ"]
			}],
			{ObjectP[Object[Notebook,Job]]..},
			Messages:>{Warning::NoStatusChange}
		],
		Example[{Messages,"JobNotFound","Warning is shown if one or more input objects cannot be found in the database. This can occur if the object does not exist, or if you do not have permissions to view/modify the input object:"},
			DeactivateJob[{Object[Notebook,Job,"Active Job 5 for DJ"],Object[Notebook,Job,"This job does not exist"]}],
			{ObjectP[Object[Notebook,Job]],$Failed},
			Messages:>{Warning::JobNotFound}
		],
		Example[{Messages,"NoStatusChange","Warning is shown if one or more input jobs already had a Status of Inactive. These jobs will remain unchanged:"},
			ActivateJob[{Object[Notebook,Job,"Inactive Job 7 for DJ"], Object[Notebook,Job,"Active Job 8 for DJ"]}],
			{ObjectP[Object[Notebook,Job]]..},
			Messages:>{Warning::NoStatusChange}
		]
	},

	(* Create Test Objects *)
	SymbolSetUp:>Module[{allTestObjects,existingObjects},
		(* Initiate object tracking *)
		$CreatedObjects={};

		(* All named objects used by these unit tests *)
		allTestObjects={
			Object[Notebook,Job,"Active Job 1 for DJ"],
			Object[Notebook,Job,"Active Job 2 for DJ"],
			Object[Notebook,Job,"Inactive Job 3 for DJ"],
			Object[Notebook,Job,"Active Job 4 for DJ"],
			Object[Notebook,Job,"Active Job 5 for DJ"],
			Object[Notebook,Job,"Active Job 6 for DJ"],
			Object[Notebook,Job,"Inactive Job 7 for DJ"],
			Object[Notebook,Job,"Active Job 8 for DJ"]
		};

		(* Grab any test objects which are already in database *)
		existingObjects=PickList[allTestObjects,DatabaseMemberQ[allTestObjects]];

		(* Erase any objects which we failed to erase from the last unit test *)
		Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

		(* Upload test objects *)
		Upload[{
			<|Type->Object[Notebook,Job], Name->"Active Job 1 for DJ", Status->Active, DeveloperObject->True|>,
			<|Type->Object[Notebook,Job], Name->"Active Job 2 for DJ", Status->Active, DeveloperObject->True|>,
			<|Type->Object[Notebook,Job], Name->"Inactive Job 3 for DJ", Status->Inactive, DeveloperObject->True|>,
			<|Type->Object[Notebook,Job], Name->"Active Job 4 for DJ", Status->Active, DeveloperObject->True|>,
			<|Type->Object[Notebook,Job], Name->"Active Job 5 for DJ", Status->Active, DeveloperObject->True|>,
			<|Type->Object[Notebook,Job], Name->"Active Job 6 for DJ", Status->Active, DeveloperObject->True|>,
			<|Type->Object[Notebook,Job], Name->"Inactive Job 7 for DJ", Status->Inactive, DeveloperObject->True|>,
			<|Type->Object[Notebook,Job], Name->"Active Job 8 for DJ", Status->Active, DeveloperObject->True|>
		}];
	],

	SymbolTearDown:>Module[{},
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
	]
];

(* ::Subsection::Closed:: *)
(*AbortJob*)


DefineTests[AbortJob,
	{
		Example[{Basic,"Abort a Manifold job. Aborting a manifold job will set the status of the job to Aborted which stops future computations from being spun off:"},
			AbortJob[Object[Notebook,Job,"Active Job 1 for AbortJob"]],
			Object[Notebook,Job,"Active Job 1 for AbortJob"]
		],
		Example[{Basic,"Aborting a Manifold job will also abort any of the job's computations that are current running or getting ready to run:"},
			Module[{},
				AbortJob[Object[Notebook,Job,"Active Job 2 for AbortJob"]];

				Download[Object[Notebook,Job,"Active Job 2 for AbortJob"], Computations[Status]]
			],
			{(Aborting|Aborted)..}
		],
		Example[{Basic,"Jobs cannot be Aborted again if they've already been Aborted:"},
			AbortJob[{
				Object[Notebook,Job,"Aborted Job 3 for AbortJob"]
			}],
			{$Failed},
			Messages:>{Warning::JobNotAborted}
		],
		Example[{Messages,"JobNotFound","Warning is shown if one or more input objects cannot be found in the database. This can occur if the object does not exist, or if you do not have permissions to view/modify the input object:"},
			AbortJob[{Object[Notebook,Job,"This Job Does Not Exist"]}],
			{$Failed},
			Messages:>{Warning::JobNotFound}
		]
	},

	(* Create Test Objects *)
	SymbolSetUp:>Module[{allTestObjects,existingObjects,computations},
		(* Initiate object tracking *)
		$CreatedObjects={};

		(* All named objects used by these unit tests *)
		allTestObjects={
			Object[Notebook,Job,"Active Job 1 for AbortJob"],
			Object[Notebook,Job,"Active Job 2 for AbortJob"],
			Object[Notebook,Job,"Aborted Job 3 for AbortJob"],
			Object[Notebook,Computation,"Running Computation 1 for AbortJob"],
			Object[Notebook,Computation,"Running Computation 2 for AbortJob"],
			Object[Notebook,Computation,"Running Computation 3 for AbortJob"],
			Object[Notebook,Computation,"Running Computation 4 for AbortJob"]
		};

		(* Grab any test objects which are already in database *)
		existingObjects=PickList[allTestObjects,DatabaseMemberQ[allTestObjects]];

		(* Erase any objects which we failed to erase from the last unit test *)
		Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

		(* Upload test objects *)
		computations=Upload[{
			<|Type->Object[Notebook,Computation], Name->"Running Computation 1 for AbortJob", Status->Running, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Running Computation 2 for AbortJob", Status->Running, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Running Computation 3 for AbortJob", Status->Running, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Running Computation 4 for AbortJob", Status->Running, DeveloperObject->True|>
		}];

		Upload[{
			<|
				Type->Object[Notebook, Job],
				Name->"Active Job 1 for AbortJob",
				Replace[Computations]->{Link[computations[[1]], Job]},
				Status->Active,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Notebook, Job],
				Name->"Active Job 2 for AbortJob",
				Replace[Computations]->{Link[computations[[2]], Job], Link[computations[[3]], Job]},
				Status->Active,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Notebook, Job],
				Name->"Aborted Job 3 for AbortJob",
				Replace[Computations]->{Link[computations[[4]], Job]},
				Status->Aborted,
				DeveloperObject->True
			|>
		}];
	],

	(* Erase all test objects created during these unit tests *)
	SymbolTearDown:>Module[{},
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
	]
];