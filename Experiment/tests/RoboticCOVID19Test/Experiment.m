(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentRoboticCOVID19Test: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentRoboticCOVID19Test*)


DefineTests[ExperimentRoboticCOVID19Test,
	{
		Example[{Basic,"Accepts samples from multiple shifts:"},
			Quiet[
				ExperimentRoboticCOVID19Test[
					Object[Sample,"ExperimentRoboticCOVID19Test test sample 1"],
					DaySamples -> {
						Object[Sample,"ExperimentRoboticCOVID19Test test sample 1"][Container]
					},
					NightSamples -> {
						Object[Sample,"ExperimentRoboticCOVID19Test test sample 2"][Container]
					},
					EnvironmentalSample->Object[Container,Vessel,"ExperimentRoboticCOVID19Test test 50mL tube 1"],
					ExternalSamples->Object[Container,Vessel,"ExperimentRoboticCOVID19Test test 50mL tube 2"]
				],
				{Warning::SamplesOutOfStock}
			],
			ObjectP[Object[Protocol,RoboticCOVID19Test]]
		],
		Example[{Basic,"Accepts a non-empty container object:"},
			Quiet[
				ExperimentRoboticCOVID19Test[
					Object[Container,Vessel,"ExperimentRoboticCOVID19Test test 50mL tube 1"],
					DaySamples -> {Object[Container,Vessel,"ExperimentRoboticCOVID19Test test 50mL tube 1"]},
					EnvironmentalSample->Object[Container,Vessel,"ExperimentRoboticCOVID19Test test 50mL tube 2"]
				],
				{Warning::SamplesOutOfStock}
			],
			ObjectP[Object[Protocol,RoboticCOVID19Test]]
		],
		Example[{Basic,"Accepts multiple non-empty container objects:"},
			Quiet[
				ExperimentRoboticCOVID19Test[
					{
						Object[Container,Vessel,"ExperimentRoboticCOVID19Test test 50mL tube 1"],
						Object[Container,Vessel,"ExperimentRoboticCOVID19Test test 50mL tube 2"]
					},
					DaySamples -> {
						Object[Container,Vessel,"ExperimentRoboticCOVID19Test test 50mL tube 1"]
					},
					EnvironmentalSample->Object[Container,Vessel,"ExperimentRoboticCOVID19Test test 50mL tube 2"]
				],
				{Warning::SamplesOutOfStock}
			],
			ObjectP[Object[Protocol,RoboticCOVID19Test]]
		],
		Example[{Options,EnvironmentalSample,"Takes in a single environmental sample:"},
			Quiet[ExperimentRoboticCOVID19Test[
				{Object[Container,Vessel,"ExperimentRoboticCOVID19Test test 50mL tube 1"]},
				DaySamples -> {
					Object[Container,Vessel,"ExperimentRoboticCOVID19Test test 50mL tube 1"]
				},
				EnvironmentalSample->Object[Container,Vessel,"ExperimentRoboticCOVID19Test test 50mL tube 2"]
			],{Warning::SamplesOutOfStock}],
			ObjectP[Object[Protocol,RoboticCOVID19Test]]
		],
		Test["Copies over expected positives from the previous protocol:",
			Module[{protocol},
				protocol = Quiet[
					ExperimentRoboticCOVID19Test[
						{Object[Container,Vessel,"ExperimentRoboticCOVID19Test test 50mL tube 1"]},
						DaySamples -> {
							Object[Container,Vessel,"ExperimentRoboticCOVID19Test test 50mL tube 1"]
						},
						EnvironmentalSample->Object[Container,Vessel,"ExperimentRoboticCOVID19Test test 50mL tube 2"]
					],
					{Warning::SamplesOutOfStock}
				];
				Download[protocol,ExpectedPositives]
			],
			{ObjectP[Object[Container,Vessel]]},
			Stubs:>{
				$DeveloperSearch=True
			}
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
				Object[Container,Vessel,"ExperimentRoboticCOVID19Test test 50mL tube 1"],
				Object[Container,Vessel,"ExperimentRoboticCOVID19Test test 50mL tube 2"],
				Object[Sample,"ExperimentRoboticCOVID19Test test sample 1"],
				Object[Sample,"ExperimentRoboticCOVID19Test test sample 2"],
				Object[Container,Vessel,"ExperimentRoboticCOVID19Test test expected positive"]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		Module[{allObjects},

			(*Gather all the created objects and models*)
			allObjects={
				Object[Container,Vessel,"ExperimentRoboticCOVID19Test test 50mL tube 1"],
				Object[Container,Vessel,"ExperimentRoboticCOVID19Test test 50mL tube 2"],
				Object[Sample,"ExperimentRoboticCOVID19Test test sample 1"],
				Object[Sample,"ExperimentRoboticCOVID19Test test sample 2"]
			};

			(*Make some empty test container objects*)
			Upload[{
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"ExperimentRoboticCOVID19Test test 50mL tube 1",
					Site -> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"ExperimentRoboticCOVID19Test test 50mL tube 2",
					Site -> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"ExperimentRoboticCOVID19Test test expected positive",
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
					{"A1",Object[Container,Vessel,"ExperimentRoboticCOVID19Test test 50mL tube 1"]},
					{"A1",Object[Container,Vessel,"ExperimentRoboticCOVID19Test test 50mL tube 2"]}
				},
				Name->{
					"ExperimentRoboticCOVID19Test test sample 1",
					"ExperimentRoboticCOVID19Test test sample 2"
				},
				InitialAmount->{
					1 Milliliter,
					1 Milliliter
				}
			];

			(*Make all the test objects and models developer objects*)
			Upload[
				Join[
					<|Object->#,DeveloperObject->True|>&/@allObjects,
					{<|
						Type->Object[Protocol,RoboticCOVID19Test],
						DeveloperObject->True,
						Status->Completed,
						Replace[ExpectedPositives]->{Link[Object[Container,Vessel,"ExperimentRoboticCOVID19Test test expected positive"]]}
					|>}
				]
			]
		];
	),


	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjects,existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container,Vessel,"ExperimentRoboticCOVID19Test test 50mL tube 1"],
				Object[Container,Vessel,"ExperimentRoboticCOVID19Test test 50mL tube 2"],
				Object[Sample,"ExperimentRoboticCOVID19Test test sample 1"],
				Object[Sample,"ExperimentRoboticCOVID19Test test sample 2"],
				Object[Container,Vessel,"ExperimentRoboticCOVID19Test test expected positive"]
			};

			(*Check whether the created objects and models exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];
	)
];

(* ::Subsection::Closed:: *)
(* PrepareExperimentRoboticCOVID19Test *)
DefineTests[PrepareExperimentRoboticCOVID19Test,
    {
		Example[{Additional,"Accepts day shift samples:"},
			Quiet[
				PrepareExperimentRoboticCOVID19Test[
					DaySamples -> {
						Object[Sample,"PrepareExperimentRoboticCOVID19Test test sample 1" <> $SessionUUID][Container]
					},
					EnvironmentalSample->Object[Container,Vessel,"PrepareExperimentRoboticCOVID19Test test 50mL tube 2" <> $SessionUUID]
				],
				{Warning::SamplesOutOfStock}
			],
			ObjectP[Object[Protocol,RoboticCOVID19Test]]
		],
		Example[{Additional,"Accepts swing shift samples:"},
			Quiet[
				PrepareExperimentRoboticCOVID19Test[
					SwingSamples -> {
						Object[Sample,"PrepareExperimentRoboticCOVID19Test test sample 1" <> $SessionUUID][Container]
					},
					EnvironmentalSample->Object[Container,Vessel,"PrepareExperimentRoboticCOVID19Test test 50mL tube 2" <> $SessionUUID]
				],
				{Warning::SamplesOutOfStock}
			],
			ObjectP[Object[Protocol,RoboticCOVID19Test]]
		],
		Example[{Additional,"Accepts night shift samples:"},
			Quiet[
				PrepareExperimentRoboticCOVID19Test[
					NightSamples -> {
						Object[Sample,"PrepareExperimentRoboticCOVID19Test test sample 1" <> $SessionUUID][Container]
					},
					EnvironmentalSample->Object[Container,Vessel,"PrepareExperimentRoboticCOVID19Test test 50mL tube 2" <> $SessionUUID]
				],
				{Warning::SamplesOutOfStock}
			],
			ObjectP[Object[Protocol,RoboticCOVID19Test]]
		],
		Example[{Additional,"Accepts samples from non-operations teams:"},
			Quiet[
				PrepareExperimentRoboticCOVID19Test[
					OtherSamples -> {
						Object[Sample,"PrepareExperimentRoboticCOVID19Test test sample 1" <> $SessionUUID][Container]
					},
					EnvironmentalSample->Object[Container,Vessel,"PrepareExperimentRoboticCOVID19Test test 50mL tube 2" <> $SessionUUID]
				],
				{Warning::SamplesOutOfStock}
			],
			ObjectP[Object[Protocol,RoboticCOVID19Test]]
		],
		Example[{Messages,"OutdatedCovidTestCall","Returns $Failed if the old enqueuing format is used:"},
			PrepareExperimentRoboticCOVID19Test[
				{Object[Sample,"PrepareExperimentRoboticCOVID19Test test sample 2" <> $SessionUUID][Container]},
				EnvironmentalSample->Object[Container,Vessel,"PrepareExperimentRoboticCOVID19Test test 50mL tube 1" <> $SessionUUID]
			],
			$Failed,
			Messages:>{Error::OutdatedCovidTestCall}
		]
    },
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjects,existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container,Vessel,"PrepareExperimentRoboticCOVID19Test test 50mL tube 1" <> $SessionUUID],
				Object[Container,Vessel,"PrepareExperimentRoboticCOVID19Test test 50mL tube 2" <> $SessionUUID],
				Object[Sample,"PrepareExperimentRoboticCOVID19Test test sample 1" <> $SessionUUID],
				Object[Sample,"PrepareExperimentRoboticCOVID19Test test sample 2" <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		Module[{allObjects},

			(*Gather all the created objects and models*)
			allObjects={
				Object[Container,Vessel,"PrepareExperimentRoboticCOVID19Test test 50mL tube 1" <> $SessionUUID],
				Object[Container,Vessel,"PrepareExperimentRoboticCOVID19Test test 50mL tube 2" <> $SessionUUID],
				Object[Sample,"PrepareExperimentRoboticCOVID19Test test sample 1" <> $SessionUUID],
				Object[Sample,"PrepareExperimentRoboticCOVID19Test test sample 2" <> $SessionUUID]
			};

			(*Make some empty test container objects*)
			Upload[{
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"PrepareExperimentRoboticCOVID19Test test 50mL tube 1" <> $SessionUUID,
					Site -> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"PrepareExperimentRoboticCOVID19Test test 50mL tube 2" <> $SessionUUID,
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
					{"A1",Object[Container,Vessel,"PrepareExperimentRoboticCOVID19Test test 50mL tube 1" <> $SessionUUID]},
					{"A1",Object[Container,Vessel,"PrepareExperimentRoboticCOVID19Test test 50mL tube 2" <> $SessionUUID]}
				},
				Name->{
					"PrepareExperimentRoboticCOVID19Test test sample 1" <> $SessionUUID,
					"PrepareExperimentRoboticCOVID19Test test sample 2" <> $SessionUUID
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
				Object[Container,Vessel,"PrepareExperimentRoboticCOVID19Test test 50mL tube 1" <> $SessionUUID],
				Object[Container,Vessel,"PrepareExperimentRoboticCOVID19Test test 50mL tube 2" <> $SessionUUID],
				Object[Sample,"PrepareExperimentRoboticCOVID19Test test sample 1" <> $SessionUUID],
				Object[Sample,"PrepareExperimentRoboticCOVID19Test test sample 2" <> $SessionUUID]
			};

			(*Check whether the created objects and models exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];
	)
];

DefineTests[poolCovidSamples,
	{
		Example[
			{Basic,"Generates the pooled list of samples:"},
			poolCovidSamples[<|DaySamples->Range[1,10],NightSamples->Range[11,20],SwingSamples->Range[21,30],OtherSamples->Range[31,40]|>,20],
			{__List}
		],
		
		Example[
			{Additional,"Does not pool any samples if the max number is greater than the number of samples:"},
			poolCovidSamples[<|DaySamples->Range[1,10],NightSamples->Range[11,20],SwingSamples->Range[21,30],OtherSamples->Range[31,40]|>,96],
			List/@Range[40]
		],
		
		Example[
			{Additional,"Pools samples to generate the specified number of samples:"},
			Length[poolCovidSamples[<|DaySamples->Range[1,10],NightSamples->Range[11,20],SwingSamples->Range[21,30],OtherSamples->Range[31,40]|>,20]],
			20
		],
		
		(* We have 40 samples but room for 39 so one of the four shifts will randomly get a pool of 2. We are generating 5 comparisons to ensure we don't get lucky with both calls putting the pool in the same shift *)
		Example[
			{Additional,"Pooling is randomly distributed across shifts:"},
			And@@(MatchQ[
				poolCovidSamples[<|DaySamples->Range[1,10],NightSamples->Range[11,20],SwingSamples->Range[21,30],OtherSamples->Range[31,40]|>,39],
				poolCovidSamples[<|DaySamples->Range[1,10],NightSamples->Range[11,20],SwingSamples->Range[21,30],OtherSamples->Range[31,40]|>,39]
			]&/@Range[5]),
			False
		],
		
		Example[
			{Messages,"TooManySamplesToPool","Returns $Failed if the samples cannot be pooled without either exceeding $MaxCovidPoolSize or pooling samples across shifts:"},
			poolCovidSamples[<|DaySamples->Range[1,20],NightSamples->Range[21,40],SwingSamples->Range[41,60],OtherSamples->Range[61,80]|>,10],
			$Failed,
			Messages:>{Error::TooManySamplesToPool}
		]
	},
	
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
]