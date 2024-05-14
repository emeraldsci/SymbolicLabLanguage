(* ::Subsection:: *)
(*ExperimentCountLiquidParticlesPreview*)


DefineTests[
	ExperimentCountLiquidParticlesPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentCountLiquidParticles:"},
			ExperimentCountLiquidParticlesPreview[
				{
					Object[Container, Vessel, "Test container 1 for ExperimentCountLiquidParticlesPreview"<>$SessionUUID],
					Object[Container, Vessel, "Test container 2 for ExperimentCountLiquidParticlesPreview"<>$SessionUUID],
					Object[Container, Vessel, "Test container 3 for ExperimentCountLiquidParticlesPreview"<>$SessionUUID]
				}
			],
			Null
		],
		Example[{Basic,"Any potential issues with provided inputs/options will be displayed:"},
			ExperimentCountLiquidParticlesOptions[
				{
					Object[Container, Vessel, "Test container 1 for ExperimentCountLiquidParticlesPreview"<>$SessionUUID],
					Object[Container, Vessel, "Test container 2 for ExperimentCountLiquidParticlesPreview"<>$SessionUUID],
					Object[Container, Vessel, "Test container 3 for ExperimentCountLiquidParticlesPreview"<>$SessionUUID]
				},
				Syringe->Model[Part,Syringe,"10 mL HIAC Injection Syringe"],
				SyringeSize->1Milliliter
			],
			_Grid,
			Messages:>{
				Error::SyringeAndSyringeSizeMismatchedForCountLiquidParticles,
				Error::InvalidOption
			}
		],
		Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentCountLiquidParticlesOptions[
				{
					Object[Container, Vessel, "Test container 1 for ExperimentCountLiquidParticlesPreview"<>$SessionUUID],
					Object[Container, Vessel, "Test container 2 for ExperimentCountLiquidParticlesPreview"<>$SessionUUID],
					Object[Container, Vessel, "Test container 3 for ExperimentCountLiquidParticlesPreview"<>$SessionUUID]
				},
				OutputFormat->List
			],
			{(_Rule|_RuleDelayed)..}
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		CleanMemoization[];
		CleanDownload[];
		
		$CreatedObjects={};
		
		(* Clean up test objects *)
		countLiquidParticlesCleanUp[];
		
		Module[
			{
				fakeBench,emptyContainer1,emptyContainer2,
				waterSample1,emptyContainer3,particleSample5Micro1,
				particleSample10Micro1
			},
			
			fakeBench=Upload[
				<|Type->Object[Container,Bench],
					Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
					Name->"Test bench for ExperimentCountLiquidParticlesPreview Unit Tests"<>$SessionUUID,
					DeveloperObject->True|>
			];
			
			(*Build Test Containers*)
			{
				
				emptyContainer1,
				emptyContainer2,
				emptyContainer3
			}=UploadSample[
				{
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"]
				},
				{
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench}
				},
				Name->{
					"Test container 1 for ExperimentCountLiquidParticlesPreview"<>$SessionUUID,
					"Test container 2 for ExperimentCountLiquidParticlesPreview"<>$SessionUUID,
					"Test container 3 for ExperimentCountLiquidParticlesPreview"<>$SessionUUID
				},
				Status->Available
			];
			
			(* Create some samples *)
			
			{
				waterSample1,
				particleSample5Micro1,
				particleSample10Micro1
			}=UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (5 microMeter, Duke Standards)"],(*Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (5 microMeter, Duke Standards)"]*)
					Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (10 microMeter, Duke Standards)"](*Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (10 microMeter, Duke Standards)"]*)
				},
				{
					{"A1",emptyContainer1},
					{"A1",emptyContainer2},
					{"A1",emptyContainer3}
				},
				InitialAmount->{
					18 Milliliter,
					18 Milliliter,
					18 Milliliter
				},
				Name->{
					"Test water sample 1 for ExperimentCountLiquidParticlesPreview"<> $SessionUUID,
					"Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticlesPreview"<> $SessionUUID,
					"Test 10 micro meter particle sample 1 for ExperimentCountLiquidParticlesPreview"<> $SessionUUID
				},
				Status->Available,
				StorageCondition->Model[StorageCondition, "Ambient Storage"]
			];
			
			
			(* Make some changes to the samples *)
			Upload[
				Flatten[
					{
						<|Object->waterSample1,ExpirationDate -> Now + 1 Year,DeveloperObject->True|>,
						<|Object->particleSample5Micro1,ExpirationDate -> Now + 1 Year,DeveloperObject->True|>,
						<|Object->particleSample10Micro1,ExpirationDate -> Now + 1 Year,DeveloperObject->True|>
					}
				]
			];
		
		]
	),
	SymbolTearDown:>Module[{},
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		countLiquidParticlesPreviewTestObjectsCleanup[];
		Unset[$CreatedObjects]
	]
];


(* ::Subsubsection:: *)
(*countLiquidParticlesPreviewTestObjectsCleanup*)

countLiquidParticlesPreviewTestObjectsCleanup[]:=Module[
	{allObjs, existingObjs},

	allObjs = {
		Object[Container,Bench,"Test bench for ExperimentCountLiquidParticlesPreview Unit Tests"<>$SessionUUID],
		
		Object[Container, Vessel, "Test container 1 for ExperimentCountLiquidParticlesPreview"<>$SessionUUID],
		Object[Container, Vessel, "Test container 2 for ExperimentCountLiquidParticlesPreview"<>$SessionUUID],
		Object[Container, Vessel, "Test container 3 for ExperimentCountLiquidParticlesPreview"<>$SessionUUID],
		
		Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticlesPreview"<> $SessionUUID],
		Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticlesPreview"<> $SessionUUID],
		Object[Sample, "Test 10 micro meter particle sample 1 for ExperimentCountLiquidParticlesPreview"<> $SessionUUID]
	};

	existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
	EraseObject[existingObjs, Force -> True, Verbose -> False]
];


(* ::Subsection:: *)
(*ExperimentCountLiquidParticlesOptions*)

DefineTests[
	ExperimentCountLiquidParticlesOptions,
	{
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			ExperimentCountLiquidParticlesOptions[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticlesOptions"<> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticlesOptions"<> $SessionUUID],
					Object[Sample, "Test 10 micro meter particle sample 1 for ExperimentCountLiquidParticlesOptions"<> $SessionUUID]
				}
			],
			_Grid
		],
		Example[{Basic,"Any potential issues with provided inputs/options will be displayed:"},
			ExperimentCountLiquidParticlesOptions[
				{
					Object[Container, Vessel, "Test container 1 for ExperimentCountLiquidParticlesOptions"<>$SessionUUID],
					Object[Container, Vessel, "Test container 2 for ExperimentCountLiquidParticlesOptions"<>$SessionUUID],
					Object[Container, Vessel, "Test container 3 for ExperimentCountLiquidParticlesOptions"<>$SessionUUID]
				},
				Syringe->Model[Part,Syringe,"10 mL HIAC Injection Syringe"],
				SyringeSize->1Milliliter
			],
			_Grid,
			Messages:>{
				Error::SyringeAndSyringeSizeMismatchedForCountLiquidParticles,
				Error::InvalidOption
			}
		],
		Example[
			{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentCountLiquidParticlesOptions[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticlesOptions"<> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticlesOptions"<> $SessionUUID],
					Object[Sample, "Test 10 micro meter particle sample 1 for ExperimentCountLiquidParticlesOptions"<> $SessionUUID]
				},
				OutputFormat->List
			],
			{(_Rule|_RuleDelayed)..}
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		CleanMemoization[];
		CleanDownload[];
		
		$CreatedObjects={};
		
		(* Clean up test objects *)
		countLiquidParticlesCleanUp[];
		
		Module[
			{
				fakeBench,emptyContainer1,emptyContainer2,
				waterSample1,emptyContainer3,particleSample5Micro1,
				particleSample10Micro1
			},
			
			fakeBench=Upload[
				<|Type->Object[Container,Bench],
					Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
					Name->"Test bench for ExperimentCountLiquidParticlesOptions Unit Tests"<>$SessionUUID,
					DeveloperObject->True|>
			];
			
			(*Build Test Containers*)
			{
				
				emptyContainer1,
				emptyContainer2,
				emptyContainer3
			}=UploadSample[
				{
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"]
				},
				{
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench}
				},
				Name->{
					"Test container 1 for ExperimentCountLiquidParticlesOptions"<>$SessionUUID,
					"Test container 2 for ExperimentCountLiquidParticlesOptions"<>$SessionUUID,
					"Test container 3 for ExperimentCountLiquidParticlesOptions"<>$SessionUUID
				},
				Status->Available
			];
			
			(* Create some samples *)
			
			{
				waterSample1,
				particleSample5Micro1,
				particleSample10Micro1
			}=UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (5 microMeter, Duke Standards)"],(*Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (5 microMeter, Duke Standards)"]*)
					Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (10 microMeter, Duke Standards)"](*Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (10 microMeter, Duke Standards)"]*)
				},
				{
					{"A1",emptyContainer1},
					{"A1",emptyContainer2},
					{"A1",emptyContainer3}
				},
				InitialAmount->{
					18 Milliliter,
					18 Milliliter,
					18 Milliliter
				},
				Name->{
					"Test water sample 1 for ExperimentCountLiquidParticlesOptions"<> $SessionUUID,
					"Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticlesOptions"<> $SessionUUID,
					"Test 10 micro meter particle sample 1 for ExperimentCountLiquidParticlesOptions"<> $SessionUUID
				},
				Status->Available,
				StorageCondition->Model[StorageCondition, "Ambient Storage"]
			];
			
			
			(* Make some changes to the samples *)
			Upload[
				Flatten[
					{
						<|Object->waterSample1,ExpirationDate -> Now + 1 Year,DeveloperObject->True|>,
						<|Object->particleSample5Micro1,ExpirationDate -> Now + 1 Year,DeveloperObject->True|>,
						<|Object->particleSample10Micro1,ExpirationDate -> Now + 1 Year,DeveloperObject->True|>
					}
				]
			];
		
		]
	),
	SymbolTearDown:>Module[{},
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		countLiquidParticlesOptionTestObjectsCleanup[];
		Unset[$CreatedObjects]
	]
];


(* ::Subsubsection:: *)
(*countLiquidParticlesOptionTestObjectsCleanup*)

countLiquidParticlesOptionTestObjectsCleanup[]:=Module[
	{allObjs, existingObjs},

	allObjs = {
		Object[Container,Bench,"Test bench for ExperimentCountLiquidParticlesOptions Unit Tests"<>$SessionUUID],
		
		Object[Container, Vessel, "Test container 1 for ExperimentCountLiquidParticlesOptions"<>$SessionUUID],
		Object[Container, Vessel, "Test container 2 for ExperimentCountLiquidParticlesOptions"<>$SessionUUID],
		Object[Container, Vessel, "Test container 3 for ExperimentCountLiquidParticlesOptions"<>$SessionUUID],
		
		Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticlesOptions"<> $SessionUUID],
		Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticlesOptions"<> $SessionUUID],
		Object[Sample, "Test 10 micro meter particle sample 1 for ExperimentCountLiquidParticlesOptions"<> $SessionUUID]
	};

	existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
	EraseObject[existingObjs, Force -> True, Verbose -> False]
];



(* ::Subsection:: *)
(*ValidExperimentCountLiquidParticlesQ*)

DefineTests[
	ValidExperimentCountLiquidParticlesQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issue:"},
			ValidExperimentCountLiquidParticlesQ[
				{
					Object[Sample, "Test water sample 1 for ValidExperimentCountLiquidParticlesQ"<> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ValidExperimentCountLiquidParticlesQ"<> $SessionUUID],
					Object[Sample, "Test 10 micro meter particle sample 1 for ValidExperimentCountLiquidParticlesQ"<> $SessionUUID]
				}
			],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentCountLiquidParticlesQ[
				{
					Object[Sample, "Test water sample 1 for ValidExperimentCountLiquidParticlesQ"<> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ValidExperimentCountLiquidParticlesQ"<> $SessionUUID],
					Object[Sample, "Test 10 micro meter particle sample 1 for ValidExperimentCountLiquidParticlesQ"<> $SessionUUID]
				},
				Syringe->Model[Part,Syringe,"10 mL HIAC Injection Syringe"],
				SyringeSize->1Milliliter
			],
			False
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentCountLiquidParticlesQ[
				{
					Object[Sample, "Test water sample 1 for ValidExperimentCountLiquidParticlesQ"<> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ValidExperimentCountLiquidParticlesQ"<> $SessionUUID],
					Object[Sample, "Test 10 micro meter particle sample 1 for ValidExperimentCountLiquidParticlesQ"<> $SessionUUID]
				},
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentCountLiquidParticlesQ[
				{
					Object[Sample, "Test water sample 1 for ValidExperimentCountLiquidParticlesQ"<> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ValidExperimentCountLiquidParticlesQ"<> $SessionUUID],
					Object[Sample, "Test 10 micro meter particle sample 1 for ValidExperimentCountLiquidParticlesQ"<> $SessionUUID]
				},
				Verbose->True
			],
			True
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"],

		(* ValidObjectQ is super slow so just doing this here *)
		ValidObjectQ[objs_,OutputFormat->Boolean]:=ConstantArray[True,Length[objs]]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		CleanMemoization[];
		CleanDownload[];
		
		$CreatedObjects={};
		
		(* Clean up test objects *)
		countLiquidParticlesCleanUp[];
		
		Module[
			{
				fakeBench,emptyContainer1,emptyContainer2,
				waterSample1,emptyContainer3,particleSample5Micro1,
				particleSample10Micro1
			},
			
			fakeBench=Upload[
				<|Type->Object[Container,Bench],
					Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
					Name->"Test bench for ValidExperimentCountLiquidParticlesQ Unit Tests"<>$SessionUUID,
					DeveloperObject->True|>
			];
			
			(*Build Test Containers*)
			{
				
				emptyContainer1,
				emptyContainer2,
				emptyContainer3
			}=UploadSample[
				{
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"]
				},
				{
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench}
				},
				Name->{
					"Test container 1 for ValidExperimentCountLiquidParticlesQ"<>$SessionUUID,
					"Test container 2 for ValidExperimentCountLiquidParticlesQ"<>$SessionUUID,
					"Test container 3 for ValidExperimentCountLiquidParticlesQ"<>$SessionUUID
				},
				Status->Available
			];
			
			(* Create some samples *)
			
			{
				waterSample1,
				particleSample5Micro1,
				particleSample10Micro1
			}=UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (5 microMeter, Duke Standards)"],(*Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (5 microMeter, Duke Standards)"]*)
					Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (10 microMeter, Duke Standards)"](*Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (10 microMeter, Duke Standards)"]*)
				},
				{
					{"A1",emptyContainer1},
					{"A1",emptyContainer2},
					{"A1",emptyContainer3}
				},
				InitialAmount->{
					18 Milliliter,
					18 Milliliter,
					18 Milliliter
				},
				Name->{
					"Test water sample 1 for ValidExperimentCountLiquidParticlesQ"<> $SessionUUID,
					"Test 5 micro meter particle sample 1 for ValidExperimentCountLiquidParticlesQ"<> $SessionUUID,
					"Test 10 micro meter particle sample 1 for ValidExperimentCountLiquidParticlesQ"<> $SessionUUID
				},
				Status->Available,
				StorageCondition->Model[StorageCondition, "Ambient Storage"]
			];
			
			
			(* Make some changes to the samples *)
			Upload[
				Flatten[
					{
						<|Object->waterSample1,ExpirationDate -> Now + 1 Year,DeveloperObject->True|>,
						<|Object->particleSample5Micro1,ExpirationDate -> Now + 1 Year,DeveloperObject->True|>,
						<|Object->particleSample10Micro1,ExpirationDate -> Now + 1 Year,DeveloperObject->True|>
					}
				]
			];
		
		]
	),
	SymbolTearDown:>Module[{},
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		validCountLiquidParticlesQObjectsCleanup[];
		Unset[$CreatedObjects]
	]
];

(* ::Subsubsection:: *)
(*validCountLiquidParticlesQObjectsCleanup*)

validCountLiquidParticlesQObjectsCleanup[]:=Module[
	{allObjs, existingObjs},

	allObjs = {
		Object[Container,Bench,"Test bench for ValidExperimentCountLiquidParticlesQ Unit Tests"<>$SessionUUID],
		
		Object[Container, Vessel, "Test container 1 for ValidExperimentCountLiquidParticlesQ"<>$SessionUUID],
		Object[Container, Vessel, "Test container 2 for ValidExperimentCountLiquidParticlesQ"<>$SessionUUID],
		Object[Container, Vessel, "Test container 3 for ValidExperimentCountLiquidParticlesQ"<>$SessionUUID],
		
		Object[Sample, "Test water sample 1 for ValidExperimentCountLiquidParticlesQ"<> $SessionUUID],
		Object[Sample, "Test 5 micro meter particle sample 1 for ValidExperimentCountLiquidParticlesQ"<> $SessionUUID],
		Object[Sample, "Test 10 micro meter particle sample 1 for ValidExperimentCountLiquidParticlesQ"<> $SessionUUID]
	};

	existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
	EraseObject[existingObjs, Force -> True, Verbose -> False]
]
