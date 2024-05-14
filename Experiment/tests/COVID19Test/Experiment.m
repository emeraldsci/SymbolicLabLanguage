(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentCOVID19Test: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentCOVID19Test*)


DefineTests[ExperimentCOVID19Test,
	{
		Example[{Basic,"Accepts a sample object:"},
			Quiet[
				ExperimentCOVID19Test[
					Object[Sample,"ExperimentCOVID19Test test sample 1"]
				],
				{Warning::SamplesOutOfStock}
			],
			ObjectP[Object[Protocol,COVID19Test]]
		],
		Example[{Basic,"Accepts multiple sample objects:"},
			Quiet[
				ExperimentCOVID19Test[
					{
						Object[Sample,"ExperimentCOVID19Test test sample 1"],
						Object[Sample,"ExperimentCOVID19Test test sample 2"]
					}
				],
				{Warning::SamplesOutOfStock}
			],
			ObjectP[Object[Protocol,COVID19Test]]
		],
		Example[{Basic,"Accepts a non-empty container object:"},
			Quiet[
				ExperimentCOVID19Test[
					Object[Container,Vessel,"ExperimentCOVID19Test test 50mL tube 1"]
				],
				{Warning::SamplesOutOfStock}
			],
			ObjectP[Object[Protocol,COVID19Test]]
		],
		Example[{Basic,"Accepts multiple non-empty container objects:"},
			Quiet[
				ExperimentCOVID19Test[
					{
						Object[Container,Vessel,"ExperimentCOVID19Test test 50mL tube 1"],
						Object[Container,Vessel,"ExperimentCOVID19Test test 50mL tube 2"]
					}
				],
				{Warning::SamplesOutOfStock}
			],
			ObjectP[Object[Protocol,COVID19Test]]
		]
	},


	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},


	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjects,existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container,Vessel,"ExperimentCOVID19Test test 50mL tube 1"],
				Object[Container,Vessel,"ExperimentCOVID19Test test 50mL tube 2"],
				Object[Sample,"ExperimentCOVID19Test test sample 1"],
				Object[Sample,"ExperimentCOVID19Test test sample 2"]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		Module[{allObjects},

			(*Gather all the created objects and models*)
			allObjects={
				Object[Container,Vessel,"ExperimentCOVID19Test test 50mL tube 1"],
				Object[Container,Vessel,"ExperimentCOVID19Test test 50mL tube 2"],
				Object[Sample,"ExperimentCOVID19Test test sample 1"],
				Object[Sample,"ExperimentCOVID19Test test sample 2"]
			};

			(*Make some empty test container objects*)
			Upload[{
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"ExperimentCOVID19Test test 50mL tube 1",
					Site -> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"ExperimentCOVID19Test test 50mL tube 2",
					Site -> Link[$Site]
				|>
			}];

			(*Make test model-less sample objects*)
			UploadSample[
				{
					{{100 VolumePercent,Model[Molecule,"Water"]}},
					{{100 VolumePercent,Model[Molecule,"Water"]}}
				},
				{
					{"A1",Object[Container,Vessel,"ExperimentCOVID19Test test 50mL tube 1"]},
					{"A1",Object[Container,Vessel,"ExperimentCOVID19Test test 50mL tube 2"]}
				},
				Name->{
					"ExperimentCOVID19Test test sample 1",
					"ExperimentCOVID19Test test sample 2"
				},
				InitialAmount->{
					1 Milliliter,
					1 Milliliter
				}
			];

			(*Make all the test objects and models developer objects*)
			Upload[<|Object->#,DeveloperObject->True|>&/@allObjects]
		];
	),


	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjects,existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container,Vessel,"ExperimentCOVID19Test test 50mL tube 1"],
				Object[Container,Vessel,"ExperimentCOVID19Test test 50mL tube 2"],
				Object[Sample,"ExperimentCOVID19Test test sample 1"],
				Object[Sample,"ExperimentCOVID19Test test sample 2"]
			};

			(*Check whether the created objects and models exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];
	)
];