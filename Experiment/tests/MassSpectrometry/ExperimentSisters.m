(* ::Subsection:: *)
(*ExperimentMassSpectrometryPreview*)


DefineTests[
	ExperimentMassSpectrometryPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentMassSpectrometry:"},
			ExperimentMassSpectrometryPreview[{
				Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometryPreview"],
				Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometryPreview"]
			},IonSource->MALDI],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed try using ExperimentMassSpectrometryOptions:"},
			ExperimentMassSpectrometryOptions[{
				Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometryPreview"],
				Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometryPreview"]
			},IonSource->MALDI],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run:"},
			ValidExperimentMassSpectrometryQ[Object[Container,Plate,"Test Plate for ExperimentMassSpectrometryPreview"],
				IonSource->ESI,
				InjectionType->FlowInjection,
				Verbose->Failures],
			True
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>(
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{uploadedObjects,existsFilter},
			uploadedObjects={
			(* containers *)
				Object[Container,Plate,"Test Plate for ExperimentMassSpectrometryPreview"],
				Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometryPreview"],
				Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometryPreview"],
				Object[Sample,"Oligomer 3 Sample for ExperimentMassSpectrometryPreview"],
				Model[Molecule,Oligomer,"Fake Peptide Identity Model for MS Preview"],
				Model[Molecule,Oligomer,"Fake Oligo3 Identity Model for MS Preview"],
				Model[Molecule,Oligomer,"Fake Oligo1 Identity Model for MS Preview"],
				Model[Sample,"Fake Oligo 1 Model for MS Preview"],
				Model[Sample,"Fake Oligo 2 Model for MS Preview"],
				Model[Sample,"Fake Oligo 3 Model for MS Preview"]

			};
			(* Check whether the names we want to give below already exist in the database *)
			existsFilter=DatabaseMemberQ[uploadedObjects];
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[
				PickList[
					uploadedObjects,
					existsFilter
				],
				Force->True,
				Verbose->False
			]]
		];
		Module[{tubePacket,platePacket,numberOfTubes,uploadedObjects,tubeObjects,plateObject,testSamples,
			fakeIdentity2,fakeIdentity3,fakeIdentity1,fakeOligo2,fakeOligo3,fakeOligo1
		},

			tubePacket=<|Type->Object[Container,Vessel],Site->Link[$Site],Model->Link[Model[Container, Vessel, "2mL Tube"],Objects],DeveloperObject->True|>;
			platePacket=<|Type->Object[Container,Plate],Site->Link[$Site],Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],DeveloperObject->True|>;
			numberOfTubes=2;

			(* Create empty containers, test calibrants, existing protocol*)
			uploadedObjects=Upload[
				Join[
					(* New containers *)
					ConstantArray[tubePacket,numberOfTubes],
					{Append[platePacket,Name->"Test Plate for ExperimentMassSpectrometryPreview"]}
				]];

			(* Assign variables to uploaded objects, first N are all vessels *)
			{tubeObjects,{plateObject}}=TakeDrop[uploadedObjects,numberOfTubes];

			(* make the identity models (Model[Molecule,Oligomer] *)
			{fakeIdentity2,fakeIdentity3,fakeIdentity1}=Upload[{
			(* Fake Peptide *)
				<|Type -> Model[Molecule, Oligomer],
					Name -> "Fake Peptide Identity Model for MS Preview",
					DeveloperObject -> True,
					Molecule->ToStrand["LysAlaMetArgLysLysLys", Polymer -> Peptide],
					MolecularWeight-> 1.90051*Kilogram/Mole
					|>,
			(*Fake Oligomer 3*)
				<|Type -> Model[Molecule, Oligomer],
					Name -> "Fake Oligo3 Identity Model for MS Preview",
					DeveloperObject -> True,
					Molecule->ToStrand["CTCTCCGGTTCTCTCCGTCTCCGGTT", Polymer -> DNA, Motif -> "D'"],
					MolecularWeight->7.80697*Kilogram/Mole
				|>,
			(*Fake Oligomer 1*)
				<|Type -> Model[Molecule, Oligomer], Name -> "Fake Oligo1 Identity Model for MS Preview",
					DeveloperObject -> True,
					Molecule->ToStrand[{"CTCTCCGGTT", "CTGCTCCAGACCTGCGCCGCATAAA", "GTCCTTCTATTAGCC"}, Polymer -> DNA, Motif -> {"D'", "X'", "B'"}],
					MolecularWeight->15.1597*Kilogram/Mole
					|>
			}];

			(* Make the fake oligmer models *)
			{fakeOligo2,fakeOligo3,fakeOligo1}=Upload[{
				<|Type->Model[Sample],
					Replace[Composition]->{{100*VolumePercent,Link[Model[Molecule,Oligomer,"Fake Peptide Identity Model for MS Preview"]]}},
					DefaultStorageCondition->Link[Model[StorageCondition,"id:N80DNj1r04jW"]],
					Name-> "Fake Oligo 2 Model for MS Preview"
				|>,
				<|Type->Model[Sample],
					Replace[Composition]->{{100*VolumePercent,Link[Model[Molecule,Oligomer,"Fake Oligo3 Identity Model for MS Preview"]]}},
					DefaultStorageCondition->Link[Model[StorageCondition,"id:N80DNj1r04jW"]],
					Name-> "Fake Oligo 3 Model for MS Preview"
				|>,
				<|Type->Model[Sample],
					Replace[Composition]->{{100*VolumePercent,Link[Model[Molecule,Oligomer,"Fake Oligo1 Identity Model for MS Preview"]]}},
					DefaultStorageCondition->Link[Model[StorageCondition,"id:N80DNj1r04jW"]],
					Name-> "Fake Oligo 1 Model for MS Preview"
				|>
			}
			];

			(* Create samples from the fake oligomer models *)
			testSamples=UploadSample[
				{
					fakeOligo1,
					fakeOligo2,
					fakeOligo3
				},
				Join[
					{"A1",#}&/@tubeObjects,
					{{"A1",plateObject}}
				],
				Name->Map[
					#<>" Sample for ExperimentMassSpectrometryPreview"&,
					{
						"Oligomer 1",
						"Oligomer 2",
						"Oligomer 3"
					}
				],
				InitialAmount->Join[ConstantArray[2 Milliliter,numberOfTubes],{1.75 Milliliter}]
			];
		]
	),
	SymbolTearDown:>Module[{},
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	]
];


(* ::Subsection:: *)
(*ExperimentMassSpectrometryOptions*)

DefineTests[
	ExperimentMassSpectrometryOptions,
	{
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			ExperimentMassSpectrometryOptions[{Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometryOptions"]},IonSource->MALDI],
			_Grid
		],
		Example[{Basic,"Any potential issues with provided inputs/options will be displayed:"},
			ExperimentMassSpectrometryOptions[{Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometryOptions"]},
				IonSource->MALDI,
				(* InjectionType is an ESI specific option so it can't be specified while IonSource is set to MALDI *)
				InjectionType->FlowInjection
			],
			_Grid,
			Messages:>{Error::UnneededOptions,Error::InvalidOption}
		],
		Example[
			{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentMassSpectrometryOptions[Object[Container,Plate,"Test Plate for ExperimentMassSpectrometryOptions"],
				IonSource->ESI,
				InjectionType->FlowInjection,
				OutputFormat->List],
			{(_Rule|_RuleDelayed)..}
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>(
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{uploadedObjects,existsFilter},
			uploadedObjects={
			(* containers *)
				Object[Container,Plate,"Test Plate for ExperimentMassSpectrometryOptions"],
				Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometryOptions"],
				Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometryOptions"],
				Object[Sample,"Oligomer 3 Sample for ExperimentMassSpectrometryOptions"],
				Model[Molecule,Oligomer,"Fake Peptide Identity Model for MS Options"],
				Model[Molecule,Oligomer,"Fake Oligo3 Identity Model for MS Options"],
				Model[Molecule,Oligomer,"Fake Oligo1 Identity Model for MS Options"],
				Model[Sample,"Fake Oligo 1 Model for MS Options"],
				Model[Sample,"Fake Oligo 2 Model for MS Options"],
				Model[Sample,"Fake Oligo 3 Model for MS Options"]

			};
			(* Check whether the names we want to give below already exist in the database *)
			existsFilter=DatabaseMemberQ[uploadedObjects];
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[
				PickList[
					uploadedObjects,
					existsFilter
				],
				Force->True,
				Verbose->False
			]]
		];
		Module[{tubePacket,platePacket,numberOfTubes,uploadedObjects,tubeObjects,plateObject,testSamples,
			fakeIdentity2,fakeIdentity3,fakeIdentity1,fakeOligo2,fakeOligo3,fakeOligo1},

			tubePacket=<|Type->Object[Container,Vessel],Site->Link[$Site],Model->Link[Model[Container, Vessel, "2mL Tube"],Objects],DeveloperObject->True|>;
			platePacket=<|Type->Object[Container,Plate],Site->Link[$Site],Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],DeveloperObject->True|>;
			numberOfTubes=2;

			(* Create empty containers, test calibrants, existing protocol*)
			uploadedObjects=Upload[
				Join[
				(* New containers *)
					ConstantArray[tubePacket,numberOfTubes],
					{Append[platePacket,Name->"Test Plate for ExperimentMassSpectrometryOptions"]}
				]];

			(* Assign variables to uploaded objects, first N are all vessels *)
			{tubeObjects,{plateObject}}=TakeDrop[uploadedObjects,numberOfTubes];

			{fakeIdentity2,fakeIdentity3,fakeIdentity1}=Upload[{
				<|Type -> Model[Molecule, Oligomer],
					Name -> "Fake Peptide Identity Model for MS Options",
					DeveloperObject -> True,
					Molecule->ToStrand["LysAlaMetArgLysLysLys", Polymer -> Peptide],
					MolecularWeight-> 1.90051*Kilogram/Mole
				|>,
			(*Fake Oligomer 3*)
				<|Type -> Model[Molecule, Oligomer],
					Name -> "Fake Oligo3 Identity Model for MS Options",
					DeveloperObject -> True,
					Molecule->ToStrand["CTCTCCGGTTCTCTCCGTCTCCGGTT", Polymer -> DNA, Motif -> "D'"],
					MolecularWeight->7.80697*Kilogram/Mole
				|>,
			(*Fake Oligomer 1*)
				<|Type -> Model[Molecule, Oligomer], Name -> "Fake Oligo1 Identity Model for MS Options",
					DeveloperObject -> True,
					Molecule->ToStrand[{"CTCTCCGGTT", "CTGCTCCAGACCTGCGCCGCATAAA", "GTCCTTCTATTAGCC"}, Polymer -> DNA, Motif -> {"D'", "X'", "B'"}],
					MolecularWeight->15.1597*Kilogram/Mole
				|>
			}];

			(* Make fake oligmer models so that we can create samples below *)
			{fakeOligo2,fakeOligo3,fakeOligo1}=Upload[{
				<|Type->Model[Sample],
					Replace[Composition]->{{100*VolumePercent,Link[Model[Molecule,Oligomer,"Fake Peptide Identity Model for MS Options"]]}},
					DefaultStorageCondition->Link[Model[StorageCondition,"id:N80DNj1r04jW"]],
					Name-> "Fake Oligo 2 Model for MS Options"|>,
				<|Type->Model[Sample],
					Replace[Composition]->{{100*VolumePercent,Link[Model[Molecule,Oligomer,"Fake Oligo3 Identity Model for MS Options"]]}},
					DefaultStorageCondition->Link[Model[StorageCondition,"id:N80DNj1r04jW"]],
					Name-> "Fake Oligo 3 Model for MS Options"|>,
				<|Type->Model[Sample],
					Replace[Composition]->{{100*VolumePercent,Link[Model[Molecule,Oligomer,"Fake Oligo1 Identity Model for MS Options"]]}},
					DefaultStorageCondition->Link[Model[StorageCondition,"id:N80DNj1r04jW"]],
					Name-> "Fake Oligo 1 Model for MS Options"|>
			}
			];


			(* Create samples using the fake oligomer models *)
			testSamples=UploadSample[
				{
					fakeOligo1,
					fakeOligo2,
					fakeOligo3
				},
				Join[
					{"A1",#}&/@tubeObjects,
					{{"A1",plateObject}}
				],
				Name->Map[
					#<>" Sample for ExperimentMassSpectrometryOptions"&,
					{
						"Oligomer 1",
						"Oligomer 2",
						"Oligomer 3"
					}
				],
				InitialAmount->Join[ConstantArray[2 Milliliter,numberOfTubes],{1.75 Milliliter}]
			];
		]
	),
	SymbolTearDown:>Module[{},
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	]
];


(* ::Subsection:: *)
(*ValidExperimentMassSpectrometryQ*)


DefineTests[
	ValidExperimentMassSpectrometryQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issue:"},
			ValidExperimentMassSpectrometryQ[{
				Object[Sample,"Oligomer 1 Sample for ValidExperimentMassSpectrometryQ"],
				Object[Sample,"Oligomer 2 Sample for ValidExperimentMassSpectrometryQ"]
			},
			IonSource->MALDI
			],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentMassSpectrometryQ[{
				Object[Sample,"Oligomer 1 Sample for ValidExperimentMassSpectrometryQ"],
				Object[Sample,"Oligomer 2 Sample for ValidExperimentMassSpectrometryQ"]},
				MassDetection->Span[15000 Dalton, 15500 Dalton],
				IonSource->MALDI
			],
			False
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentMassSpectrometryQ[
				Object[Sample,"Oligomer 1 Sample for ValidExperimentMassSpectrometryQ"],
				IonSource->MALDI,
				OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentMassSpectrometryQ[Object[Container,Plate,"Test Plate for ValidExperimentMassSpectrometryQ"],
				IonSource->ESI,
				InjectionType->FlowInjection,
				Verbose->True],
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
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{uploadedObjects,existsFilter},
			uploadedObjects={
			(* containers *)
				Object[Container,Plate,"Test Plate for ValidExperimentMassSpectrometryQ"],
				Object[Sample,"Oligomer 1 Sample for ValidExperimentMassSpectrometryQ"],
				Object[Sample,"Oligomer 2 Sample for ValidExperimentMassSpectrometryQ"],
				Object[Sample,"Oligomer 3 Sample for ValidExperimentMassSpectrometryQ"],
				Model[Molecule,Oligomer,"Fake Peptide Identity Model for MS ValidQ"],
				Model[Molecule,Oligomer,"Fake Oligo3 Identity Model for MS ValidQ"],
				Model[Molecule,Oligomer,"Fake Oligo1 Identity Model for MS ValidQ"],
				Model[Sample,"Fake Oligo 1 Model for MS ValidQ"],
				Model[Sample,"Fake Oligo 2 Model for MS ValidQ"],
				Model[Sample,"Fake Oligo 3 Model for MS ValidQ"]

			};
			(* Check whether the names we want to give below already exist in the database *)
			existsFilter=DatabaseMemberQ[uploadedObjects];
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[
				PickList[
					uploadedObjects,
					existsFilter
				],
				Force->True,
				Verbose->False
			]]
		];
		Module[{tubePacket,platePacket,numberOfTubes,uploadedObjects,tubeObjects,plateObject,testSamples,
			fakeIdentity2,fakeIdentity3,fakeIdentity1,fakeOligo2,fakeOligo3,fakeOligo1},
			tubePacket=<|Type->Object[Container,Vessel],Site->Link[$Site],Model->Link[Model[Container, Vessel, "2mL Tube"],Objects],DeveloperObject->True|>;
			platePacket=<|Type->Object[Container,Plate],Site->Link[$Site],Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],DeveloperObject->True|>;
			numberOfTubes=2;

			(* Create empty containers, test calibrants, existing protocol*)
			uploadedObjects=Upload[
				Join[
				(* New containers *)
					ConstantArray[tubePacket,numberOfTubes],
					{Append[platePacket,Name->"Test Plate for ValidExperimentMassSpectrometryQ"]}
				]];

			(* Assign variables to uploaded objects, first N are all vessels *)
			{tubeObjects,{plateObject}}=TakeDrop[uploadedObjects,numberOfTubes];

			{fakeIdentity2,fakeIdentity3,fakeIdentity1}=Upload[{
				<|Type -> Model[Molecule, Oligomer],
					Name -> "Fake Peptide Identity Model for MS ValidQ",
					DeveloperObject -> True,
					Molecule->ToStrand["LysAlaMetArgLysLysLys", Polymer -> Peptide],
					MolecularWeight-> 1.90051*Kilogram/Mole
				|>,
			(*Fake Oligomer 3*)
				<|Type -> Model[Molecule, Oligomer],
					Name -> "Fake Oligo3 Identity Model for MS ValidQ",
					DeveloperObject -> True,
					Molecule->ToStrand["CTCTCCGGTTCTCTCCGTCTCCGGTT", Polymer -> DNA, Motif -> "D'"],
					MolecularWeight->7.80697*Kilogram/Mole
				|>,
			(*Fake Oligomer 1*)
				<|Type -> Model[Molecule, Oligomer], Name -> "Fake Oligo1 Identity Model for MS ValidQ",
					DeveloperObject -> True,
					Molecule->ToStrand[{"CTCTCCGGTT", "CTGCTCCAGACCTGCGCCGCATAAA", "GTCCTTCTATTAGCC"}, Polymer -> DNA, Motif -> {"D'", "X'", "B'"}],
					MolecularWeight->15.1597*Kilogram/Mole
				|>
			}];

			{fakeOligo2,fakeOligo3,fakeOligo1}=Upload[{
			(*Fake oligmer models*)
				<|Type->Model[Sample],
					Replace[Composition]->{{100*VolumePercent,Link[Model[Molecule,Oligomer,"Fake Peptide Identity Model for MS ValidQ"]]}},
					DefaultStorageCondition->Link[Model[StorageCondition,"id:N80DNj1r04jW"]],
					Name-> "Fake Oligo 2 Model for MS ValidQ"|>,
				<|Type->Model[Sample],
					Replace[Composition]->{{100*VolumePercent,Link[Model[Molecule,Oligomer,"Fake Oligo3 Identity Model for MS ValidQ"]]}},
					DefaultStorageCondition->Link[Model[StorageCondition,"id:N80DNj1r04jW"]],
					Name-> "Fake Oligo 3 Model for MS ValidQ"|>,
				<|Type->Model[Sample],
					Replace[Composition]->{{100*VolumePercent,Link[Model[Molecule,Oligomer,"Fake Oligo1 Identity Model for MS ValidQ"]]}},
					DefaultStorageCondition->Link[Model[StorageCondition,"id:N80DNj1r04jW"]],
					Name-> "Fake Oligo 1 Model for MS ValidQ"|>
			}
			];


			(* Create samples *)
			testSamples=UploadSample[
				{
					fakeOligo1,
					fakeOligo2,
					fakeOligo3},
				Join[
					{"A1",#}&/@tubeObjects,
					{{"A1",plateObject}}
				],
				Name->Map[
					#<>" Sample for ValidExperimentMassSpectrometryQ"&,
					{
						"Oligomer 1",
						"Oligomer 2",
						"Oligomer 3"
					}
				],
				InitialAmount->Join[ConstantArray[2 Milliliter,numberOfTubes],{1.75 Milliliter}]
			];
		]
	),
	SymbolTearDown:>Module[{},
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	]
];
