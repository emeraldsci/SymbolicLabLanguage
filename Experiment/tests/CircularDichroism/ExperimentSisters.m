(* ::Subsection:: *)
(*ExperimentCircularDichroismPreview*)


DefineTests[
	ExperimentCircularDichroismPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentCircularDichroism:"},
			ExperimentCircularDichroismPreview[
				{
					Object[Sample, "ExperimentCircularDichroismPreview Test (-) CSA Sample" <> $SessionUUID],
					Object[Sample, "ExperimentCircularDichroismPreview Test (+) CSA Sample" <> $SessionUUID],
					Object[Sample, "ExperimentCircularDichroismPreview Test ee=+50% sample" <> $SessionUUID],
					Object[Sample, "ExperimentCircularDichroismPreview Test ee=0% sample" <> $SessionUUID],
					Object[Sample, "ExperimentCircularDichroismPreview Test ee=-50% sample" <> $SessionUUID]
				}
			],
			Null
		],
		Example[{Basic,"Any potential issues with provided inputs/options will be displayed:"},
			ExperimentCircularDichroismOptions[
				{
					Object[Sample, "ExperimentCircularDichroismPreview Test (-) CSA Sample" <> $SessionUUID],
					Object[Sample, "ExperimentCircularDichroismPreview Test (+) CSA Sample" <> $SessionUUID],
					Object[Sample, "ExperimentCircularDichroismPreview Test ee=+50% sample" <> $SessionUUID],
					Object[Sample, "ExperimentCircularDichroismPreview Test ee=0% sample" <> $SessionUUID],
					Object[Sample, "ExperimentCircularDichroismPreview Test ee=-50% sample" <> $SessionUUID]
				},
				EnantiomericExcessStandards -> {
					{Model[Sample, "Milli-Q water"], Quantity[-100, "Percent"]},
					{Object[Sample, "ExperimentCircularDichroismPreview Test (+) CSA Sample" <> $SessionUUID], Quantity[100, "Percent"]}
				}
			],
			_Grid,
			Messages:>{
				Error::CircularDichroismUnknownEnatiomericExcessStandards,
				Error::InvalidOption
			}
		],
		Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentCircularDichroismOptions[
				{
					Object[Sample, "ExperimentCircularDichroismPreview Test (-) CSA Sample" <> $SessionUUID],
					Object[Sample, "ExperimentCircularDichroismPreview Test (+) CSA Sample" <> $SessionUUID],
					Object[Sample, "ExperimentCircularDichroismPreview Test ee=+50% sample" <> $SessionUUID],
					Object[Sample, "ExperimentCircularDichroismPreview Test ee=0% sample" <> $SessionUUID],
					Object[Sample, "ExperimentCircularDichroismPreview Test ee=-50% sample" <> $SessionUUID]
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
		circularDichroismPreviewTestObjectsCleanup[];
		ClearDownload[];
		ClearMemoization[];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					fakeBench,
					container,
					sample, sample2, sample3, sample4, sample5, allObjs
				},

				fakeBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Fake bench for ExperimentCircularDichroismPreview tests" <> $SessionUUID,DeveloperObject->True|>];

				(*Build Test Containers*)
				{
					(*1*)container
				}=UploadSample[
					{
						(*1*)Model[Container, Plate, "96-well 2mL Deep Well Plate"] (*"id:KBL5DvwJ0q4k"*)

					},
					{
						(*1*){"Work Surface",fakeBench}
					},
					Name->{
						(*1*)"Fake 2mL Plate 1 for ExperimentCircularDichroismPreview tests" <> $SessionUUID
					}
				];

				{
					(*1*)sample,
					(*2*)sample2,
					(*3*)sample3,
					(*4*)sample4,
					(*5*)sample5
				}=UploadSample[
					{
						(*1*)Model[Sample, "(-)- CSA Aqueous Solution (2 gm/mL)"],
						(*2*)Model[Sample, "(+)- CSA Aqueous Solution (2 gm/mL)"],
						(*3*)Model[Sample, "75/25 (+/-)- CSA Aqueous Solution (2 gm/mL), mixture of enantiomers"],
						(*4*)Model[Sample, "50/50 (+/-)- CSA Aqueous Solution (2 gm/mL), mixture of enantiomers"],
						(*5*)Model[Sample, "25/75 (+/-)- CSA Aqueous Solution (2 gm/mL), mixture of enantiomers"]

					},
					{
						(*1*){"A1",container},
						(*2*){"A2",container},
						(*3*){"A3",container},
						(*4*){"A4",container},
						(*5*){"A5",container}

					},
					InitialAmount->{
						(*1*)1500*Microliter,
						(*2*)1500*Microliter,
						(*3*)1500*Microliter,
						(*4*)1500*Microliter,
						(*5*)1500*Microliter
					},
					Name->{
						(*1*)"ExperimentCircularDichroismPreview Test (-) CSA Sample" <> $SessionUUID,
						(*2*)"ExperimentCircularDichroismPreview Test (+) CSA Sample" <> $SessionUUID,
						(*3*)"ExperimentCircularDichroismPreview Test ee=+50% sample" <> $SessionUUID,
						(*4*)"ExperimentCircularDichroismPreview Test ee=0% sample" <> $SessionUUID,
						(*5*)"ExperimentCircularDichroismPreview Test ee=-50% sample" <> $SessionUUID
					},
					StorageCondition->Model[StorageCondition, "id:vXl9j57YlZ5N"]
				];



				allObjs = {container, sample, sample2, sample3, sample4, sample5};


				Upload[Flatten[{
					<|Object->#,DeveloperObject->True|>&/@allObjs
				}]];

			]
		]
	),
	SymbolTearDown:>Module[{},
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		circularDichroismPreviewTestObjectsCleanup[];
		Unset[$CreatedObjects]
	]
];


(* ::Subsubsection:: *)
(*circularDichroismPreviewTestObjectsCleanup*)

circularDichroismPreviewTestObjectsCleanup[]:=Module[
	{allObjs, existingObjs},

	allObjs = {
		Object[Container, Bench, "Fake bench for ExperimentCircularDichroismPreview tests" <> $SessionUUID],
		Object[Container, Plate, "Fake 2mL Plate 1 for ExperimentCircularDichroismPreview tests" <> $SessionUUID],
		Object[Sample, "ExperimentCircularDichroismPreview Test (-) CSA Sample" <> $SessionUUID],
		Object[Sample, "ExperimentCircularDichroismPreview Test (+) CSA Sample" <> $SessionUUID],
		Object[Sample, "ExperimentCircularDichroismPreview Test ee=+50% sample" <> $SessionUUID],
		Object[Sample, "ExperimentCircularDichroismPreview Test ee=0% sample" <> $SessionUUID],
		Object[Sample, "ExperimentCircularDichroismPreview Test ee=-50% sample" <> $SessionUUID]
	};

	existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
	EraseObject[existingObjs, Force -> True, Verbose -> False]
];


(* ::Subsection:: *)
(*ExperimentCircularDichroismOptions*)

DefineTests[
	ExperimentCircularDichroismOptions,
	{
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			ExperimentCircularDichroismOptions[
				{
					Object[Sample, "ExperimentCircularDichroismOptions Test (-) CSA Sample" <> $SessionUUID],
					Object[Sample, "ExperimentCircularDichroismOptions Test (+) CSA Sample" <> $SessionUUID],
					Object[Sample, "ExperimentCircularDichroismOptions Test ee=+50% sample" <> $SessionUUID],
					Object[Sample, "ExperimentCircularDichroismOptions Test ee=0% sample" <> $SessionUUID],
					Object[Sample, "ExperimentCircularDichroismOptions Test ee=-50% sample" <> $SessionUUID]
				}
			],
			_Grid
		],
		Example[{Basic,"Any potential issues with provided inputs/options will be displayed:"},
			ExperimentCircularDichroismOptions[
				{
					Object[Sample, "ExperimentCircularDichroismOptions Test (-) CSA Sample" <> $SessionUUID],
					Object[Sample, "ExperimentCircularDichroismOptions Test (+) CSA Sample" <> $SessionUUID],
					Object[Sample, "ExperimentCircularDichroismOptions Test ee=+50% sample" <> $SessionUUID],
					Object[Sample, "ExperimentCircularDichroismOptions Test ee=0% sample" <> $SessionUUID],
					Object[Sample, "ExperimentCircularDichroismOptions Test ee=-50% sample" <> $SessionUUID]
				},
				EnantiomericExcessStandards -> {
					{Model[Sample, "Milli-Q water"], Quantity[-100, "Percent"]},
					{Object[Sample, "ExperimentCircularDichroismOptions Test (+) CSA Sample" <> $SessionUUID], Quantity[100, "Percent"]}
				}
			],
			_Grid,
			Messages:>{
				Error::CircularDichroismUnknownEnatiomericExcessStandards,
				Error::InvalidOption
			}
		],
		Example[
			{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentCircularDichroismOptions[
				{
					Object[Sample, "ExperimentCircularDichroismOptions Test (-) CSA Sample" <> $SessionUUID],
					Object[Sample, "ExperimentCircularDichroismOptions Test (+) CSA Sample" <> $SessionUUID],
					Object[Sample, "ExperimentCircularDichroismOptions Test ee=+50% sample" <> $SessionUUID],
					Object[Sample, "ExperimentCircularDichroismOptions Test ee=0% sample" <> $SessionUUID],
					Object[Sample, "ExperimentCircularDichroismOptions Test ee=-50% sample" <> $SessionUUID]
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
		circularDichroismOptionTestObjectsCleanup[];
		ClearDownload[];
		ClearMemoization[];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					fakeBench,
					container,
					sample, sample2, sample3, sample4, sample5, allObjs
				},

				fakeBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Fake bench for ExperimentCircularDichroismOptions tests" <> $SessionUUID,DeveloperObject->True|>];

				(*Build Test Containers*)
				{
					(*1*)container
				}=UploadSample[
					{
						(*1*)Model[Container, Plate, "96-well 2mL Deep Well Plate"] (*"id:KBL5DvwJ0q4k"*)

					},
					{
						(*1*){"Work Surface",fakeBench}
					},
					Name->{
						(*1*)"Fake 2mL Plate 1 for ExperimentCircularDichroismOptions tests" <> $SessionUUID
					}
				];

				{
					(*1*)sample,
					(*2*)sample2,
					(*3*)sample3,
					(*4*)sample4,
					(*5*)sample5
				}=UploadSample[
					{
						(*1*)Model[Sample, "(-)- CSA Aqueous Solution (2 gm/mL)"], 
						(*2*)Model[Sample, "(+)- CSA Aqueous Solution (2 gm/mL)"], 
						(*3*)Model[Sample, "75/25 (+/-)- CSA Aqueous Solution (2 gm/mL), mixture of enantiomers"],
						(*4*)Model[Sample, "50/50 (+/-)- CSA Aqueous Solution (2 gm/mL), mixture of enantiomers"],
						(*5*)Model[Sample, "25/75 (+/-)- CSA Aqueous Solution (2 gm/mL), mixture of enantiomers"]
			
					},
					{
						(*1*){"A1",container},
						(*2*){"A2",container},
						(*3*){"A3",container},
						(*4*){"A4",container},
						(*5*){"A5",container}
				
					},
					InitialAmount->{
						(*1*)1500*Microliter,
						(*2*)1500*Microliter,
						(*3*)1500*Microliter,
						(*4*)1500*Microliter,
						(*5*)1500*Microliter
					},
					Name->{
						(*1*)"ExperimentCircularDichroismOptions Test (-) CSA Sample" <> $SessionUUID,
						(*2*)"ExperimentCircularDichroismOptions Test (+) CSA Sample" <> $SessionUUID,
						(*3*)"ExperimentCircularDichroismOptions Test ee=+50% sample" <> $SessionUUID,
						(*4*)"ExperimentCircularDichroismOptions Test ee=0% sample" <> $SessionUUID,
						(*5*)"ExperimentCircularDichroismOptions Test ee=-50% sample" <> $SessionUUID
					},
					StorageCondition->Model[StorageCondition, "id:vXl9j57YlZ5N"]
				];



				allObjs = {container, sample, sample2, sample3, sample4, sample5};


				Upload[Flatten[{
					<|Object->#,DeveloperObject->True|>&/@allObjs
				}]];

			]
		]
	),
	SymbolTearDown:>Module[{},
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		circularDichroismOptionTestObjectsCleanup[];
		Unset[$CreatedObjects]
	]
];


(* ::Subsubsection:: *)
(*circularDichroismOptionTestObjectsCleanup*)

circularDichroismOptionTestObjectsCleanup[]:=Module[
	{allObjs, existingObjs},

	allObjs = {
		Object[Container, Bench, "Fake bench for ExperimentCircularDichroismOptions tests" <> $SessionUUID],
		Object[Container, Plate, "Fake 2mL Plate 1 for ExperimentCircularDichroismOptions tests" <> $SessionUUID],
		Object[Sample, "ExperimentCircularDichroismOptions Test (-) CSA Sample" <> $SessionUUID],
		Object[Sample, "ExperimentCircularDichroismOptions Test (+) CSA Sample" <> $SessionUUID],
		Object[Sample, "ExperimentCircularDichroismOptions Test ee=+50% sample" <> $SessionUUID],
		Object[Sample, "ExperimentCircularDichroismOptions Test ee=0% sample" <> $SessionUUID],
		Object[Sample, "ExperimentCircularDichroismOptions Test ee=-50% sample" <> $SessionUUID]
	};

	existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
	EraseObject[existingObjs, Force -> True, Verbose -> False]
];



(* ::Subsection:: *)
(*ValidExperimentCircularDichroismQ*)


DefineTests[
	ValidExperimentCircularDichroismQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issue:"},
			ValidExperimentCircularDichroismQ[
				{
					Object[Sample, "ValidExperimentCircularDichroismQ Test (-) CSA Sample" <> $SessionUUID],
					Object[Sample, "ValidExperimentCircularDichroismQ Test (+) CSA Sample" <> $SessionUUID],
					Object[Sample, "ValidExperimentCircularDichroismQ Test ee=+50% sample" <> $SessionUUID],
					Object[Sample, "ValidExperimentCircularDichroismQ Test ee=0% sample" <> $SessionUUID],
					Object[Sample, "ValidExperimentCircularDichroismQ Test ee=-50% sample" <> $SessionUUID]
				}
			],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentCircularDichroismQ[
				{
					Object[Sample, "ValidExperimentCircularDichroismQ Test (-) CSA Sample" <> $SessionUUID],
					Object[Sample, "ValidExperimentCircularDichroismQ Test (+) CSA Sample" <> $SessionUUID],
					Object[Sample, "ValidExperimentCircularDichroismQ Test ee=+50% sample" <> $SessionUUID],
					Object[Sample, "ValidExperimentCircularDichroismQ Test ee=0% sample" <> $SessionUUID],
					Object[Sample, "ValidExperimentCircularDichroismQ Test ee=-50% sample" <> $SessionUUID]
				},
				EnantiomericExcessStandards -> {
					{Model[Sample, "Milli-Q water"], Quantity[-100, "Percent"]},
					{Object[Sample, "ValidExperimentCircularDichroismQ Test (+) CSA Sample" <> $SessionUUID], Quantity[100, "Percent"]}
				}
			],
			False
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentCircularDichroismQ[
				{
					Object[Sample, "ValidExperimentCircularDichroismQ Test (-) CSA Sample" <> $SessionUUID],
					Object[Sample, "ValidExperimentCircularDichroismQ Test (+) CSA Sample" <> $SessionUUID],
					Object[Sample, "ValidExperimentCircularDichroismQ Test ee=+50% sample" <> $SessionUUID],
					Object[Sample, "ValidExperimentCircularDichroismQ Test ee=0% sample" <> $SessionUUID],
					Object[Sample, "ValidExperimentCircularDichroismQ Test ee=-50% sample" <> $SessionUUID]
				},
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentCircularDichroismQ[
				{
					Object[Sample, "ValidExperimentCircularDichroismQ Test (-) CSA Sample" <> $SessionUUID],
					Object[Sample, "ValidExperimentCircularDichroismQ Test (+) CSA Sample" <> $SessionUUID],
					Object[Sample, "ValidExperimentCircularDichroismQ Test ee=+50% sample" <> $SessionUUID],
					Object[Sample, "ValidExperimentCircularDichroismQ Test ee=0% sample" <> $SessionUUID],
					Object[Sample, "ValidExperimentCircularDichroismQ Test ee=-50% sample" <> $SessionUUID]
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
		validCircularDichroismQObjectsCleanup[];
		ClearDownload[];
		ClearMemoization[];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					fakeBench,
					container,
					sample, sample2, sample3, sample4, sample5, allObjs
				},

				fakeBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Fake bench for ValidExperimentCircularDichroismQ tests" <> $SessionUUID,DeveloperObject->True|>];

				(*Build Test Containers*)
				{
					(*1*)container
				}=UploadSample[
					{
						(*1*)Model[Container, Plate, "96-well 2mL Deep Well Plate"] (*"id:KBL5DvwJ0q4k"*)

					},
					{
						(*1*){"Work Surface",fakeBench}
					},
					Name->{
						(*1*)"Fake 2mL Plate 1 for ValidExperimentCircularDichroismQ tests" <> $SessionUUID
					}
				];

				{
					(*1*)sample,
					(*2*)sample2,
					(*3*)sample3,
					(*4*)sample4,
					(*5*)sample5
				}=UploadSample[
					{
						(*1*)Model[Sample, "(-)- CSA Aqueous Solution (2 gm/mL)"],
						(*2*)Model[Sample, "(+)- CSA Aqueous Solution (2 gm/mL)"],
						(*3*)Model[Sample, "75/25 (+/-)- CSA Aqueous Solution (2 gm/mL), mixture of enantiomers"],
						(*4*)Model[Sample, "50/50 (+/-)- CSA Aqueous Solution (2 gm/mL), mixture of enantiomers"],
						(*5*)Model[Sample, "25/75 (+/-)- CSA Aqueous Solution (2 gm/mL), mixture of enantiomers"]

					},
					{
						(*1*){"A1",container},
						(*2*){"A2",container},
						(*3*){"A3",container},
						(*4*){"A4",container},
						(*5*){"A5",container}

					},
					InitialAmount->{
						(*1*)1500*Microliter,
						(*2*)1500*Microliter,
						(*3*)1500*Microliter,
						(*4*)1500*Microliter,
						(*5*)1500*Microliter
					},
					Name->{
						(*1*)"ValidExperimentCircularDichroismQ Test (-) CSA Sample" <> $SessionUUID,
						(*2*)"ValidExperimentCircularDichroismQ Test (+) CSA Sample" <> $SessionUUID,
						(*3*)"ValidExperimentCircularDichroismQ Test ee=+50% sample" <> $SessionUUID,
						(*4*)"ValidExperimentCircularDichroismQ Test ee=0% sample" <> $SessionUUID,
						(*5*)"ValidExperimentCircularDichroismQ Test ee=-50% sample" <> $SessionUUID
					},
					StorageCondition->Model[StorageCondition, "id:vXl9j57YlZ5N"]
				];



				allObjs = {container, sample, sample2, sample3, sample4, sample5};


				Upload[Flatten[{
					<|Object->#,DeveloperObject->True|>&/@allObjs
				}]];

			]
		]
	),
	SymbolTearDown:>Module[{},
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		validCircularDichroismQObjectsCleanup[];
		Unset[$CreatedObjects]
	]
];

(* ::Subsubsection:: *)
(*validCircularDichroismQObjectsCleanup*)

validCircularDichroismQObjectsCleanup[]:=Module[
	{allObjs, existingObjs},

	allObjs = {
		Object[Container, Bench, "Fake bench for ValidExperimentCircularDichroismQ tests" <> $SessionUUID],
		Object[Container, Plate, "Fake 2mL Plate 1 for ValidExperimentCircularDichroismQ tests" <> $SessionUUID],
		Object[Sample, "ValidExperimentCircularDichroismQ Test (-) CSA Sample" <> $SessionUUID],
		Object[Sample, "ValidExperimentCircularDichroismQ Test (+) CSA Sample" <> $SessionUUID],
		Object[Sample, "ValidExperimentCircularDichroismQ Test ee=+50% sample" <> $SessionUUID],
		Object[Sample, "ValidExperimentCircularDichroismQ Test ee=0% sample" <> $SessionUUID],
		Object[Sample, "ValidExperimentCircularDichroismQ Test ee=-50% sample" <> $SessionUUID]
	};

	existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
	EraseObject[existingObjs, Force -> True, Verbose -> False]
]
