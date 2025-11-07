(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)

(* ::Subsection::Closed:: *)
(*ExperimentELISAPreview*)

DefineTests[
	ExperimentELISAPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentELISA:"},
			ExperimentELISAPreview[Object[Sample,"ExperimentELISAPreview test object sample 1" <> $SessionUUID]],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed, try using ExperimentELISAOptions:"},
			ExperimentELISAOptions[Object[Sample,"ExperimentELISAPreview test object sample 1" <> $SessionUUID]],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentELISAQ:"},
			ValidExperimentELISAQ[Object[Sample,"ExperimentELISAPreview test object sample 1" <> $SessionUUID]],
			True
		]
	},

	SymbolSetUp:>(
		(* Set $CreatedObjects to {} to catch all of objects created *)
		$CreatedObjects={};
		Off[Warning::NegativeDiluentVolume];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjects,existingObjects},
			allObjects=
					{
						(* Bench *)
						Object[Container,Bench,"Test test bench for ExperimentELISAPreview tests" <> $SessionUUID],
						(*Containers*)
						Object[Container,Vessel,"ExperimentELISAPreview test container 1" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAPreview test container 2" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAPreview test container 3" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAPreview test container 4" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAPreview test container 5" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAPreview test container 6" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAPreview test container 7" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAPreview test container 8" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAPreview test container 9" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAPreview test container 10" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAPreview test container 11" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAPreview test container 12" <> $SessionUUID],


						(*Target Antigens Model molecules*)
						Model[Molecule,Protein,"ExperimentELISAPreview test target antigen model molecule 1" <> $SessionUUID],
						(*Antibody Model molecules*)
						Model[Molecule,Protein,Antibody,"ExperimentELISAPreview test antibody model molecule 1 HRP-conjugated" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISAPreview test antibody model molecule 2 non-conjugated" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISAPreview test antibody model molecule 3 non-conjugated" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISAPreview test antibody model molecule 4 tagged" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISAPreview test antibody model molecule 5 anti-tag" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISAPreview test antibody model molecule 6 HRP-conjugated secondary" <> $SessionUUID],


						(* Model samples *)
						Model[Sample,"ExperimentELISAPreview test model sample 1" <> $SessionUUID],
						(*Target Antigen Model Samples*)
						Model[Sample,"ExperimentELISAPreview test target antigen model sample 1" <> $SessionUUID],
						(* Antibody Model samples *)
						Model[Sample,"ExperimentELISAPreview test antibody model sample 1 HRP-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISAPreview test antibody model sample 2 non-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISAPreview test antibody model sample 3 non-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISAPreview test antibody model sample 4 tagged" <> $SessionUUID],
						Model[Sample,"ExperimentELISAPreview test antibody model sample 5 anti-tag" <> $SessionUUID],
						Model[Sample,"ExperimentELISAPreview test antibody model sample 6 HRP-conjugated secondary" <> $SessionUUID],


						(* Object samples *)
						Object[Sample,"ExperimentELISAPreview test object sample 1" <> $SessionUUID],
						Object[Sample,"ExperimentELISAPreview test object sample 2" <> $SessionUUID],
						Object[Sample,"ExperimentELISAPreview test object sample 3 discarded" <> $SessionUUID],
						Object[Sample,"ExperimentELISAPreview test object sample 4 solid" <> $SessionUUID],
						(*Target Antigen Object Samples*)
						Object[Sample,"ExperimentELISAPreview test target antigen object sample 1" <> $SessionUUID],
						Object[Sample,"ExperimentELISAPreview test target antigen object sample 2" <> $SessionUUID],
						(* Antibody Object samples *)
						Object[Sample,"ExperimentELISAPreview test antibody object sample 1 HRP-conjugated" <> $SessionUUID],
						Object[Sample,"ExperimentELISAPreview test antibody object sample 2 non-conjugated" <> $SessionUUID],
						Object[Sample,"ExperimentELISAPreview test antibody object sample 3 non-conjugated" <> $SessionUUID],
						Object[Sample,"ExperimentELISAPreview test antibody object sample 4 tagged" <> $SessionUUID],
						Object[Sample,"ExperimentELISAPreview test antibody object sample 5 anti-tag" <> $SessionUUID],
						Object[Sample,"ExperimentELISAPreview test antibody object sample 5 anti-tag" <> $SessionUUID],
						Object[Sample,"ExperimentELISAPreview test antibody object sample 6 HRP-conjugated secondary" <> $SessionUUID]

					};
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];


		Block[{$AllowSystemsProtocols = True},
			Module[{
				testBench,
				container1,
				container2,
				container3,
				container4,
				container5,
				container6,
				container7,
				container8,
				container9,
				container10,
				container11,
				container12,
				targetantigen1,
				antibodyMolecule1,
				antibodyMolecule2,
				antibodyMolecule3,
				antibodyMolecule4,
				antibodyMolecule5,
				antibodyMolecule6,
				antibodyModelSample1,
				antibodyModelSample2,
				antibodyModelSample3,
				antibodyModelSample4,
				antibodyModelSample5,
				antibodyModelSample6,
				testSample1,
				testSample2,
				testSample3,
				testSample4,
				testAntigenSample1,
				testAntigenSample2,
				testAntibodySample1,
				testAntibodySample2,
				testAntibodySample3,
				testAntibodySample4,
				testAntibodySample5,
				testAntibodySample6
			},
				(*Test Bench Object*)
				testBench=Upload[
					<|
						Type->Object[Container,Bench],
						Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
						Name->"Test test bench for ExperimentELISAPreview tests" <> $SessionUUID,
						StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
						DeveloperObject -> True
					|>
				];

				(*Test Containers*)
				Block[{$DeveloperUpload = True},
					{
						container1,
						container2,
						container3,
						container4,
						container5,
						container6,
						container7,
						container8,
						container9,
						container10,
						container11,
						container12
					}=UploadSample[
						ConstantArray[Model[Container,Vessel,"2mL Tube"],12],
						ConstantArray[{"Work Surface", testBench},12],
						Status->ConstantArray[Available,12],
						Name->{
							"ExperimentELISAPreview test container 1" <> $SessionUUID,
							"ExperimentELISAPreview test container 2" <> $SessionUUID,
							"ExperimentELISAPreview test container 3" <> $SessionUUID,
							"ExperimentELISAPreview test container 4" <> $SessionUUID,
							"ExperimentELISAPreview test container 5" <> $SessionUUID,
							"ExperimentELISAPreview test container 6" <> $SessionUUID,
							"ExperimentELISAPreview test container 7" <> $SessionUUID,
							"ExperimentELISAPreview test container 8" <> $SessionUUID,
							"ExperimentELISAPreview test container 9" <> $SessionUUID,
							"ExperimentELISAPreview test container 10" <> $SessionUUID,
							"ExperimentELISAPreview test container 11" <> $SessionUUID,
							"ExperimentELISAPreview test container 12" <> $SessionUUID
						},
						StorageCondition->AmbientStorage
					];
				];

				(* Target Antigens Model molecules*)
				{targetantigen1}=UploadProtein[
					{"ExperimentELISAPreview test target antigen model molecule 1" <> $SessionUUID},
					State->Solid,
					BiosafetyLevel->"BSL-1",
					Flammable->False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials->{None},
					ExpirationHazard->False
				];

				(*Antibody Model molecules*)
				{
					antibodyMolecule1,
					antibodyMolecule2,
					antibodyMolecule3,
					antibodyMolecule4,
					antibodyMolecule5,
					antibodyMolecule6

				}=UploadAntibody[
					{
						"ExperimentELISAPreview test antibody model molecule 1 HRP-conjugated" <> $SessionUUID,
						"ExperimentELISAPreview test antibody model molecule 2 non-conjugated" <> $SessionUUID,
						"ExperimentELISAPreview test antibody model molecule 3 non-conjugated" <> $SessionUUID,
						"ExperimentELISAPreview test antibody model molecule 4 tagged" <> $SessionUUID,
						"ExperimentELISAPreview test antibody model molecule 5 anti-tag" <> $SessionUUID,
						"ExperimentELISAPreview test antibody model molecule 6 HRP-conjugated secondary" <> $SessionUUID
					},
					State->Solid,
					BiosafetyLevel->"BSL-1",
					Flammable->False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials->{None},
					ExpirationHazard->False,
					Targets->{targetantigen1}
				];

				(* Model samples *)
				Upload[
					<|
						Name->"ExperimentELISAPreview test model sample 1" <> $SessionUUID,
						Type->Model[Sample],
						DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
						State->Liquid,
						Replace[Analytes]->{Link[targetantigen1]}
					|>
				];

				(*Target Antigen Model Samples*)
				Upload[
					<|
						Name->"ExperimentELISAPreview test target antigen model sample 1" <> $SessionUUID,
						Type->Model[Sample],
						DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
						State->Liquid,
						Replace[Analytes]->{Link[targetantigen1]}
					|>
				];

				(* Antibody Model samples *)


				{
					antibodyModelSample1,
					antibodyModelSample2,
					antibodyModelSample3,
					antibodyModelSample4,
					antibodyModelSample5,
					antibodyModelSample6
				}=Upload[
					<|
						Name->#,
						Type->Model[Sample],
						DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
						State->Liquid
					|>
				]&/@
						{
							"ExperimentELISAPreview test antibody model sample 1 HRP-conjugated" <> $SessionUUID,
							"ExperimentELISAPreview test antibody model sample 2 non-conjugated" <> $SessionUUID,
							"ExperimentELISAPreview test antibody model sample 3 non-conjugated" <> $SessionUUID,
							"ExperimentELISAPreview test antibody model sample 4 tagged" <> $SessionUUID,
							"ExperimentELISAPreview test antibody model sample 5 anti-tag" <> $SessionUUID,
							"ExperimentELISAPreview test antibody model sample 6 HRP-conjugated secondary" <> $SessionUUID
						};

				(*Object samples, Target Antigen Objects, Antibody Objects*)
				{
					testSample1,
					testSample2,
					testSample3,
					testSample4,
					testAntigenSample1,
					testAntigenSample2,
					testAntibodySample1,
					testAntibodySample2,
					testAntibodySample3,
					testAntibodySample4,
					testAntibodySample5,
					testAntibodySample6

				}=UploadSample[
					{
						(* Model samples *)
						Model[Sample,"ExperimentELISAPreview test model sample 1" <> $SessionUUID],
						Model[Sample,"ExperimentELISAPreview test model sample 1" <> $SessionUUID],
						Model[Sample,"ExperimentELISAPreview test model sample 1" <> $SessionUUID],
						Model[Sample,"ExperimentELISAPreview test model sample 1" <> $SessionUUID],
						(*Target Antigen Model Samples*)
						Model[Sample,"ExperimentELISAPreview test target antigen model sample 1" <> $SessionUUID],
						Model[Sample,"ExperimentELISAPreview test target antigen model sample 1" <> $SessionUUID],
						(* Antibody Model samples *)
						Model[Sample,"ExperimentELISAPreview test antibody model sample 1 HRP-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISAPreview test antibody model sample 2 non-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISAPreview test antibody model sample 3 non-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISAPreview test antibody model sample 4 tagged" <> $SessionUUID],
						Model[Sample,"ExperimentELISAPreview test antibody model sample 5 anti-tag" <> $SessionUUID],
						Model[Sample,"HRP-Conjugated Goat-Anti-Mouse-IgG Secondary Antibody"]
					},
					{
						{"A1",container1},
						{"A1",container2},
						{"A1",container3},
						{"A1",container4},
						{"A1",container5},
						{"A1",container6},
						{"A1",container7},
						{"A1",container8},
						{"A1",container9},
						{"A1",container10},
						{"A1",container11},
						{"A1",container12}
					},
					Name->{
						"ExperimentELISAPreview test object sample 1" <> $SessionUUID,
						"ExperimentELISAPreview test object sample 2" <> $SessionUUID,
						"ExperimentELISAPreview test object sample 3 discarded" <> $SessionUUID,
						"ExperimentELISAPreview test object sample 4 solid" <> $SessionUUID,
						"ExperimentELISAPreview test target antigen object sample 1" <> $SessionUUID,
						"ExperimentELISAPreview test target antigen object sample 2" <> $SessionUUID,
						"ExperimentELISAPreview test antibody object sample 1 HRP-conjugated" <> $SessionUUID,
						"ExperimentELISAPreview test antibody object sample 2 non-conjugated" <> $SessionUUID,
						"ExperimentELISAPreview test antibody object sample 3 non-conjugated" <> $SessionUUID,
						"ExperimentELISAPreview test antibody object sample 4 tagged" <> $SessionUUID,
						"ExperimentELISAPreview test antibody object sample 5 anti-tag" <> $SessionUUID,
						"ExperimentELISAPreview test antibody object sample 6 HRP-conjugated secondary" <> $SessionUUID
					},
					InitialAmount->ConstantArray[1.8Milliliter,12]
				];
				Upload/@{
					<|Object->antibodyMolecule1,
						Replace[Targets]->{Link[Model[Molecule,Protein,"ExperimentELISAPreview test target antigen model molecule 1" <> $SessionUUID],Antibodies]},
						DefaultSampleModel->Link[antibodyModelSample1],
						Replace[SecondaryAntibodies]->{Link[Model[Molecule,Protein,Antibody,"ExperimentELISAPreview test antibody model molecule 6 HRP-conjugated secondary" <> $SessionUUID],Targets]},
						Replace[DetectionLabels]-> {Link[Model[Molecule, Protein,"Horseradish Peroxidase"]]}
					|>,
					<|Object->antibodyMolecule2,
						Replace[Targets]->{Link[Model[Molecule,Protein,"ExperimentELISAPreview test target antigen model molecule 1" <> $SessionUUID],Antibodies]},
						DefaultSampleModel->Link[antibodyModelSample2],
						Replace[SecondaryAntibodies]->{Link[Model[Molecule,Protein,Antibody,"ExperimentELISAPreview test antibody model molecule 6 HRP-conjugated secondary" <> $SessionUUID],Targets]},
						Organism->Mouse
					|>,
					<|Object->antibodyMolecule3,
						Replace[Targets]->{Link[Model[Molecule,Protein,"ExperimentELISAPreview test target antigen model molecule 1" <> $SessionUUID],Antibodies]},
						DefaultSampleModel->Link[antibodyModelSample3],
						Replace[SecondaryAntibodies]->{Link[Model[Molecule,Protein,Antibody,"ExperimentELISAPreview test antibody model molecule 6 HRP-conjugated secondary" <> $SessionUUID],Targets]},
						Organism->Rabbit
					|>,
					<|Object->antibodyMolecule4,
						Replace[Targets]->{Link[Model[Molecule,Protein,"ExperimentELISAPreview test target antigen model molecule 1" <> $SessionUUID],Antibodies]},
						DefaultSampleModel->Link[antibodyModelSample4],
						Replace[SecondaryAntibodies]->{Link[Model[Molecule,Protein,Antibody,"ExperimentELISAPreview test antibody model molecule 5 anti-tag" <> $SessionUUID],Targets]},
						Replace[AffinityLabels]->{Link[Model[Molecule, Protein,"V5 Tag"]]}
					|>,
					<|Object->antibodyMolecule5,
						Replace[Targets]->{Link[Model[Molecule,Protein,"V5 Tag"],Antibodies]},
						DefaultSampleModel->Link[Model[Sample, "ExperimentELISAPreview test antibody model sample 5 anti-tag" <> $SessionUUID]]
					|>,
					<|Object->antibodyMolecule6,
						Replace[Targets]->{Link[Model[Molecule,Protein,Antibody,"ExperimentELISAPreview test antibody model molecule 2 non-conjugated" <> $SessionUUID],SecondaryAntibodies],Link[Model[Molecule,Protein,Antibody,"ExperimentELISAPreview test antibody model molecule 3 non-conjugated" <> $SessionUUID],SecondaryAntibodies]},
						DefaultSampleModel->Link[antibodyModelSample6],
						Replace[DetectionLabels]-> {Link[Model[Molecule, Protein,"Horseradish Peroxidase"]]}
					|>,
					<|Object->antibodyModelSample1,
						Replace[Analytes]->{Link[antibodyMolecule1]}
					|>,
					<|Object->antibodyModelSample2,
						Replace[Analytes]->{Link[antibodyMolecule2]}
					|>,
					<|Object->antibodyModelSample3,
						Replace[Analytes]->{Link[antibodyMolecule3]}
					|>,
					<|Object->antibodyModelSample4,
						Replace[Analytes]->{Link[antibodyMolecule4]}
					|>,
					<|Object->antibodyModelSample5,
						Replace[Analytes]->{Link[antibodyMolecule5]}
					|>,
					<|Object->antibodyModelSample6,
						Replace[Analytes]->{Link[antibodyMolecule6]}
					|>,
					<|Object->testSample1,Status->Available,State->Liquid,
						Replace[Analytes]->{Link[targetantigen1]},
						Replace[Composition]->{{Null,Link[targetantigen1],Now}}
					|>,
					<|Object->testSample2,Status->Available,State->Liquid,
						Replace[Analytes]->{Link[targetantigen1]},
						Replace[Composition]->{{Null,Link[targetantigen1],Now}}
					|>,
					<|Object->testSample3,Status->Discarded,State->Liquid,
						Replace[Analytes]->{Link[targetantigen1]},
						Replace[Composition]->{{Null,Link[targetantigen1],Now}}
					|>,
					<|Object->testSample4,Status->Available,State->Solid,
						Replace[Analytes]->{Link[targetantigen1]},
						Replace[Composition]->{{Null,Link[targetantigen1],Now}},
						Volume->Null
					|>,
					<|Object->testAntigenSample1,
						Replace[Analytes]->{Link[targetantigen1]},
						State->Liquid
					|>,
					<|Object->testAntigenSample2,
						Replace[Analytes]->{Link[targetantigen1]},
						State->Liquid
					|>,
					<|Object->targetantigen1,
						DefaultSampleModel->Link[Model[Sample, "ExperimentELISAPreview test target antigen model sample 1" <> $SessionUUID]],
						State->Solid
					|>,
					<|Object->testAntibodySample1,
						Replace[Analytes]->{Link[antibodyMolecule1]},
						State->Liquid
					|>,
					<|Object->testAntibodySample2,
						Replace[Analytes]->{Link[antibodyMolecule2]},
						State->Liquid
					|>,
					<|Object->testAntibodySample3,
						Replace[Analytes]->{Link[antibodyMolecule3]},
						State->Liquid
					|>,
					<|Object->testAntibodySample4,
						Replace[Analytes]->{Link[antibodyMolecule4]},
						State->Liquid
					|>,
					<|Object->testAntibodySample5,
						Replace[Analytes]->{Link[antibodyMolecule5]},
						State->Liquid
					|>,
					<|Object->testAntibodySample6,
						Replace[Analytes]->{Link[Model[Molecule,Protein,Antibody,"HRP-Conjugated Goat-Anti-Mouse-IgG Secondary Antibody"]]},
						State->Liquid
					|>

				}

			]
		]

	),


	SymbolTearDown:>{
		Module[{allObjects,existingObjects},
			allObjects=
					{
						(* Bench *)
						Object[Container,Bench,"Test test bench for ExperimentELISAPreview tests" <> $SessionUUID],
						(*Containers*)
						Object[Container,Vessel,"ExperimentELISAPreview test container 1" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAPreview test container 2" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAPreview test container 3" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAPreview test container 4" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAPreview test container 5" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAPreview test container 6" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAPreview test container 7" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAPreview test container 8" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAPreview test container 9" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAPreview test container 10" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAPreview test container 11" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAPreview test container 12" <> $SessionUUID],


						(*Target Antigens Model molecules*)
						Model[Molecule,Protein,"ExperimentELISAPreview test target antigen model molecule 1" <> $SessionUUID],
						(*Antibody Model molecules*)
						Model[Molecule,Protein,Antibody,"ExperimentELISAPreview test antibody model molecule 1 HRP-conjugated" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISAPreview test antibody model molecule 2 non-conjugated" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISAPreview test antibody model molecule 3 non-conjugated" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISAPreview test antibody model molecule 4 tagged" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISAPreview test antibody model molecule 5 anti-tag" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISAPreview test antibody model molecule 6 HRP-conjugated secondary" <> $SessionUUID],


						(* Model samples *)
						Model[Sample,"ExperimentELISAPreview test model sample 1" <> $SessionUUID],
						(*Target Antigen Model Samples*)
						Model[Sample,"ExperimentELISAPreview test target antigen model sample 1" <> $SessionUUID],
						(* Antibody Model samples *)
						Model[Sample,"ExperimentELISAPreview test antibody model sample 1 HRP-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISAPreview test antibody model sample 2 non-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISAPreview test antibody model sample 3 non-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISAPreview test antibody model sample 4 tagged" <> $SessionUUID],
						Model[Sample,"ExperimentELISAPreview test antibody model sample 5 anti-tag" <> $SessionUUID],
						Model[Sample,"ExperimentELISAPreview test antibody model sample 6 HRP-conjugated secondary" <> $SessionUUID],


						(* Object samples *)
						Object[Sample,"ExperimentELISAPreview test object sample 1" <> $SessionUUID],
						Object[Sample,"ExperimentELISAPreview test object sample 2" <> $SessionUUID],
						Object[Sample,"ExperimentELISAPreview test object sample 3 discarded" <> $SessionUUID],
						Object[Sample,"ExperimentELISAPreview test object sample 4 solid" <> $SessionUUID],
						(*Target Antigen Object Samples*)
						Object[Sample,"ExperimentELISAPreview test target antigen object sample 1" <> $SessionUUID],
						Object[Sample,"ExperimentELISAPreview test target antigen object sample 2" <> $SessionUUID],
						(* Antibody Object samples *)
						Object[Sample,"ExperimentELISAPreview test antibody object sample 1 HRP-conjugated" <> $SessionUUID],
						Object[Sample,"ExperimentELISAPreview test antibody object sample 2 non-conjugated" <> $SessionUUID],
						Object[Sample,"ExperimentELISAPreview test antibody object sample 3 non-conjugated" <> $SessionUUID],
						Object[Sample,"ExperimentELISAPreview test antibody object sample 4 tagged" <> $SessionUUID],
						Object[Sample,"ExperimentELISAPreview test antibody object sample 5 anti-tag" <> $SessionUUID],
						Object[Sample,"ExperimentELISAPreview test antibody object sample 5 anti-tag" <> $SessionUUID],
						Object[Sample,"ExperimentELISAPreview test antibody object sample 6 HRP-conjugated secondary" <> $SessionUUID]


					};
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			On[Warning::NegativeDiluentVolume]
		];
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];

(* ::Subsection::Closed:: *)
(*ExperimentELISAOptions*)
DefineTests[
	ExperimentELISAOptions,
	{
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			ExperimentELISAOptions[Object[Sample,"ExperimentELISAOptions test object sample 1" <> $SessionUUID]],
			_Grid
		],
		Example[{Basic,"View any potential issues with provided inputs/options displayed:"},
			ExperimentELISAOptions[Object[Sample,"ExperimentELISAOptions test object sample 3 discarded" <> $SessionUUID]],
			_Grid,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentELISAOptions[Object[Sample,"ExperimentELISAOptions test object sample 1" <> $SessionUUID],OutputFormat->List],
			{(_Rule|_RuleDelayed)..}
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
						(* Bench *)
						Object[Container,Bench,"Test test bench for ExperimentELISAOptions tests" <> $SessionUUID],
						(*Containers*)
						Object[Container,Vessel,"ExperimentELISAOptions test container 1" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAOptions test container 2" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAOptions test container 3" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAOptions test container 4" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAOptions test container 5" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAOptions test container 6" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAOptions test container 7" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAOptions test container 8" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAOptions test container 9" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAOptions test container 10" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAOptions test container 11" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAOptions test container 12" <> $SessionUUID],


						(*Target Antigens Model molecules*)
						Model[Molecule,Protein,"ExperimentELISAOptions test target antigen model molecule 1" <> $SessionUUID],
						(*Antibody Model molecules*)
						Model[Molecule,Protein,Antibody,"ExperimentELISAOptions test antibody model molecule 1 HRP-conjugated" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISAOptions test antibody model molecule 2 non-conjugated" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISAOptions test antibody model molecule 3 non-conjugated" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISAOptions test antibody model molecule 4 tagged" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISAOptions test antibody model molecule 5 anti-tag" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISAOptions test antibody model molecule 6 HRP-conjugated secondary" <> $SessionUUID],


						(* Model samples *)
						Model[Sample,"ExperimentELISAOptions test model sample 1" <> $SessionUUID],
						(*Target Antigen Model Samples*)
						Model[Sample,"ExperimentELISAOptions test target antigen model sample 1" <> $SessionUUID],
						(* Antibody Model samples *)
						Model[Sample,"ExperimentELISAOptions test antibody model sample 1 HRP-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISAOptions test antibody model sample 2 non-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISAOptions test antibody model sample 3 non-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISAOptions test antibody model sample 4 tagged" <> $SessionUUID],
						Model[Sample,"ExperimentELISAOptions test antibody model sample 5 anti-tag" <> $SessionUUID],
						Model[Sample,"ExperimentELISAOptions test antibody model sample 6 HRP-conjugated secondary" <> $SessionUUID],


						(* Object samples *)
						Object[Sample,"ExperimentELISAOptions test object sample 1" <> $SessionUUID],
						Object[Sample,"ExperimentELISAOptions test object sample 2" <> $SessionUUID],
						Object[Sample,"ExperimentELISAOptions test object sample 3 discarded" <> $SessionUUID],
						Object[Sample,"ExperimentELISAOptions test object sample 4 solid" <> $SessionUUID],
						(*Target Antigen Object Samples*)
						Object[Sample,"ExperimentELISAOptions test target antigen object sample 1" <> $SessionUUID],
						Object[Sample,"ExperimentELISAOptions test target antigen object sample 2" <> $SessionUUID],
						(* Antibody Object samples *)
						Object[Sample,"ExperimentELISAOptions test antibody object sample 1 HRP-conjugated" <> $SessionUUID],
						Object[Sample,"ExperimentELISAOptions test antibody object sample 2 non-conjugated" <> $SessionUUID],
						Object[Sample,"ExperimentELISAOptions test antibody object sample 3 non-conjugated" <> $SessionUUID],
						Object[Sample,"ExperimentELISAOptions test antibody object sample 4 tagged" <> $SessionUUID],
						Object[Sample,"ExperimentELISAOptions test antibody object sample 5 anti-tag" <> $SessionUUID],
						Object[Sample,"ExperimentELISAOptions test antibody object sample 5 anti-tag" <> $SessionUUID],
						Object[Sample,"ExperimentELISAOptions test antibody object sample 6 HRP-conjugated secondary" <> $SessionUUID]

					};
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];


		Block[{$AllowSystemsProtocols = True},
			Module[{
				testBench,
				container1,
				container2,
				container3,
				container4,
				container5,
				container6,
				container7,
				container8,
				container9,
				container10,
				container11,
				container12,
				targetantigen1,
				antibodyMolecule1,
				antibodyMolecule2,
				antibodyMolecule3,
				antibodyMolecule4,
				antibodyMolecule5,
				antibodyMolecule6,
				antibodyModelSample1,
				antibodyModelSample2,
				antibodyModelSample3,
				antibodyModelSample4,
				antibodyModelSample5,
				antibodyModelSample6,
				testSample1,
				testSample2,
				testSample3,
				testSample4,
				testAntigenSample1,
				testAntigenSample2,
				testAntibodySample1,
				testAntibodySample2,
				testAntibodySample3,
				testAntibodySample4,
				testAntibodySample5,
				testAntibodySample6
			},
				(*Test Bench Object*)
				testBench=Upload[
					<|
						Type->Object[Container,Bench],
						Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
						Name->"Test test bench for ExperimentELISAOptions tests" <> $SessionUUID,
						StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
						DeveloperObject -> True
					|>
				];

				Block[{$DeveloperUpload = True},
					(*Test Containers*)
					{
						container1,
						container2,
						container3,
						container4,
						container5,
						container6,
						container7,
						container8,
						container9,
						container10,
						container11,
						container12
					}=UploadSample[
						ConstantArray[Model[Container,Vessel,"2mL Tube"],12],
						ConstantArray[{"Work Surface", testBench},12],
						Status->ConstantArray[Available,12],
						Name->{
							"ExperimentELISAOptions test container 1" <> $SessionUUID,
							"ExperimentELISAOptions test container 2" <> $SessionUUID,
							"ExperimentELISAOptions test container 3" <> $SessionUUID,
							"ExperimentELISAOptions test container 4" <> $SessionUUID,
							"ExperimentELISAOptions test container 5" <> $SessionUUID,
							"ExperimentELISAOptions test container 6" <> $SessionUUID,
							"ExperimentELISAOptions test container 7" <> $SessionUUID,
							"ExperimentELISAOptions test container 8" <> $SessionUUID,
							"ExperimentELISAOptions test container 9" <> $SessionUUID,
							"ExperimentELISAOptions test container 10" <> $SessionUUID,
							"ExperimentELISAOptions test container 11" <> $SessionUUID,
							"ExperimentELISAOptions test container 12" <> $SessionUUID
						},
						StorageCondition->AmbientStorage
					];
				];

				(* Target Antigens Model molecules*)
				{targetantigen1}=UploadProtein[
					{"ExperimentELISAOptions test target antigen model molecule 1" <> $SessionUUID},
					State->Solid,
					BiosafetyLevel->"BSL-1",
					Flammable->False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials->{None},
					ExpirationHazard->False
				];

				(*Antibody Model molecules*)
				{
					antibodyMolecule1,
					antibodyMolecule2,
					antibodyMolecule3,
					antibodyMolecule4,
					antibodyMolecule5,
					antibodyMolecule6

				}=UploadAntibody[
					{
						"ExperimentELISAOptions test antibody model molecule 1 HRP-conjugated" <> $SessionUUID,
						"ExperimentELISAOptions test antibody model molecule 2 non-conjugated" <> $SessionUUID,
						"ExperimentELISAOptions test antibody model molecule 3 non-conjugated" <> $SessionUUID,
						"ExperimentELISAOptions test antibody model molecule 4 tagged" <> $SessionUUID,
						"ExperimentELISAOptions test antibody model molecule 5 anti-tag" <> $SessionUUID,
						"ExperimentELISAOptions test antibody model molecule 6 HRP-conjugated secondary" <> $SessionUUID
					},
					State->Solid,
					BiosafetyLevel->"BSL-1",
					Flammable->False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials->{None},
					ExpirationHazard->False,
					Targets->{targetantigen1}
				];

				(* Model samples *)
				Upload[
					<|
						Name->"ExperimentELISAOptions test model sample 1" <> $SessionUUID,
						Type->Model[Sample],
						DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
						State->Liquid,
						Replace[Analytes]->{Link[targetantigen1]}
					|>
				];

				(*Target Antigen Model Samples*)
				Upload[
					<|
						Name->"ExperimentELISAOptions test target antigen model sample 1" <> $SessionUUID,
						Type->Model[Sample],
						DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
						State->Liquid,
						Replace[Analytes]->{Link[targetantigen1]}
					|>
				];

				(* Antibody Model samples *)


				{
					antibodyModelSample1,
					antibodyModelSample2,
					antibodyModelSample3,
					antibodyModelSample4,
					antibodyModelSample5,
					antibodyModelSample6
				}=Upload[
					<|
						Name->#,
						Type->Model[Sample],
						DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
						State->Liquid
					|>
				]&/@
						{
							"ExperimentELISAOptions test antibody model sample 1 HRP-conjugated" <> $SessionUUID,
							"ExperimentELISAOptions test antibody model sample 2 non-conjugated" <> $SessionUUID,
							"ExperimentELISAOptions test antibody model sample 3 non-conjugated" <> $SessionUUID,
							"ExperimentELISAOptions test antibody model sample 4 tagged" <> $SessionUUID,
							"ExperimentELISAOptions test antibody model sample 5 anti-tag" <> $SessionUUID,
							"ExperimentELISAOptions test antibody model sample 6 HRP-conjugated secondary" <> $SessionUUID
						};

				(*Object samples, Target Antigen Objects, Antibody Objects*)
				{
					testSample1,
					testSample2,
					testSample3,
					testSample4,
					testAntigenSample1,
					testAntigenSample2,
					testAntibodySample1,
					testAntibodySample2,
					testAntibodySample3,
					testAntibodySample4,
					testAntibodySample5,
					testAntibodySample6

				}=UploadSample[
					{
						(* Model samples *)
						Model[Sample,"ExperimentELISAOptions test model sample 1" <> $SessionUUID],
						Model[Sample,"ExperimentELISAOptions test model sample 1" <> $SessionUUID],
						Model[Sample,"ExperimentELISAOptions test model sample 1" <> $SessionUUID],
						Model[Sample,"ExperimentELISAOptions test model sample 1" <> $SessionUUID],
						(*Target Antigen Model Samples*)
						Model[Sample,"ExperimentELISAOptions test target antigen model sample 1" <> $SessionUUID],
						Model[Sample,"ExperimentELISAOptions test target antigen model sample 1" <> $SessionUUID],
						(* Antibody Model samples *)
						Model[Sample,"ExperimentELISAOptions test antibody model sample 1 HRP-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISAOptions test antibody model sample 2 non-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISAOptions test antibody model sample 3 non-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISAOptions test antibody model sample 4 tagged" <> $SessionUUID],
						Model[Sample,"ExperimentELISAOptions test antibody model sample 5 anti-tag" <> $SessionUUID],
						Model[Sample,"HRP-Conjugated Goat-Anti-Mouse-IgG Secondary Antibody"]
					},
					{
						{"A1",container1},
						{"A1",container2},
						{"A1",container3},
						{"A1",container4},
						{"A1",container5},
						{"A1",container6},
						{"A1",container7},
						{"A1",container8},
						{"A1",container9},
						{"A1",container10},
						{"A1",container11},
						{"A1",container12}
					},
					Name->{
						"ExperimentELISAOptions test object sample 1" <> $SessionUUID,
						"ExperimentELISAOptions test object sample 2" <> $SessionUUID,
						"ExperimentELISAOptions test object sample 3 discarded" <> $SessionUUID,
						"ExperimentELISAOptions test object sample 4 solid" <> $SessionUUID,
						"ExperimentELISAOptions test target antigen object sample 1" <> $SessionUUID,
						"ExperimentELISAOptions test target antigen object sample 2" <> $SessionUUID,
						"ExperimentELISAOptions test antibody object sample 1 HRP-conjugated" <> $SessionUUID,
						"ExperimentELISAOptions test antibody object sample 2 non-conjugated" <> $SessionUUID,
						"ExperimentELISAOptions test antibody object sample 3 non-conjugated" <> $SessionUUID,
						"ExperimentELISAOptions test antibody object sample 4 tagged" <> $SessionUUID,
						"ExperimentELISAOptions test antibody object sample 5 anti-tag" <> $SessionUUID,
						"ExperimentELISAOptions test antibody object sample 6 HRP-conjugated secondary" <> $SessionUUID
					},
					InitialAmount->ConstantArray[1.8Milliliter,12]
				];
				Upload/@{
					<|Object->antibodyMolecule1,
						Replace[Targets]->{Link[Model[Molecule,Protein,"ExperimentELISAOptions test target antigen model molecule 1" <> $SessionUUID],Antibodies]},
						DefaultSampleModel->Link[antibodyModelSample1],
						Replace[SecondaryAntibodies]->{Link[Model[Molecule,Protein,Antibody,"ExperimentELISAOptions test antibody model molecule 6 HRP-conjugated secondary" <> $SessionUUID],Targets]},
						Replace[DetectionLabels]-> {Link[Model[Molecule, Protein,"Horseradish Peroxidase"]]}
					|>,
					<|Object->antibodyMolecule2,
						Replace[Targets]->{Link[Model[Molecule,Protein,"ExperimentELISAOptions test target antigen model molecule 1" <> $SessionUUID],Antibodies]},
						DefaultSampleModel->Link[antibodyModelSample2],
						Replace[SecondaryAntibodies]->{Link[Model[Molecule,Protein,Antibody,"ExperimentELISAOptions test antibody model molecule 6 HRP-conjugated secondary" <> $SessionUUID],Targets]},
						Organism->Mouse
					|>,
					<|Object->antibodyMolecule3,
						Replace[Targets]->{Link[Model[Molecule,Protein,"ExperimentELISAOptions test target antigen model molecule 1" <> $SessionUUID],Antibodies]},
						DefaultSampleModel->Link[antibodyModelSample3],
						Replace[SecondaryAntibodies]->{Link[Model[Molecule,Protein,Antibody,"ExperimentELISAOptions test antibody model molecule 6 HRP-conjugated secondary" <> $SessionUUID],Targets]},
						Organism->Rabbit
					|>,
					<|Object->antibodyMolecule4,
						Replace[Targets]->{Link[Model[Molecule,Protein,"ExperimentELISAOptions test target antigen model molecule 1" <> $SessionUUID],Antibodies]},
						DefaultSampleModel->Link[antibodyModelSample4],
						Replace[SecondaryAntibodies]->{Link[Model[Molecule,Protein,Antibody,"ExperimentELISAOptions test antibody model molecule 5 anti-tag" <> $SessionUUID],Targets]},
						Replace[AffinityLabels]->{Link[Model[Molecule, Protein,"V5 Tag"]]}
					|>,
					<|Object->antibodyMolecule5,
						Replace[Targets]->{Link[Model[Molecule,Protein,"V5 Tag"],Antibodies]},
						DefaultSampleModel->Link[Model[Sample, "ExperimentELISAOptions test antibody model sample 5 anti-tag" <> $SessionUUID]]
					|>,
					<|Object->antibodyMolecule6,
						Replace[Targets]->{Link[Model[Molecule,Protein,Antibody,"ExperimentELISAOptions test antibody model molecule 2 non-conjugated" <> $SessionUUID],SecondaryAntibodies],Link[Model[Molecule,Protein,Antibody,"ExperimentELISAOptions test antibody model molecule 3 non-conjugated" <> $SessionUUID],SecondaryAntibodies]},
						DefaultSampleModel->Link[antibodyModelSample6],
						Replace[DetectionLabels]-> {Link[Model[Molecule, Protein,"Horseradish Peroxidase"]]}
					|>,
					<|Object->antibodyModelSample1,
						Replace[Analytes]->{Link[antibodyMolecule1]}
					|>,
					<|Object->antibodyModelSample2,
						Replace[Analytes]->{Link[antibodyMolecule2]}
					|>,
					<|Object->antibodyModelSample3,
						Replace[Analytes]->{Link[antibodyMolecule3]}
					|>,
					<|Object->antibodyModelSample4,
						Replace[Analytes]->{Link[antibodyMolecule4]}
					|>,
					<|Object->antibodyModelSample5,
						Replace[Analytes]->{Link[antibodyMolecule5]}
					|>,
					<|Object->antibodyModelSample6,
						Replace[Analytes]->{Link[antibodyMolecule6]}
					|>,
					<|Object->testSample1,Status->Available,State->Liquid,
						Replace[Analytes]->{Link[targetantigen1]},
						Replace[Composition]->{{Null,Link[targetantigen1],Now}}
					|>,
					<|Object->testSample2,Status->Available,State->Liquid,
						Replace[Analytes]->{Link[targetantigen1]},
						Replace[Composition]->{{Null,Link[targetantigen1],Now}}
					|>,
					<|Object->testSample3,Status->Discarded,State->Liquid,
						Replace[Analytes]->{Link[targetantigen1]},
						Replace[Composition]->{{Null,Link[targetantigen1],Now}}
					|>,
					<|Object->testSample4,Status->Available,State->Solid,
						Replace[Analytes]->{Link[targetantigen1]},
						Replace[Composition]->{{Null,Link[targetantigen1],Now}},
						Volume->Null
					|>,
					<|Object->testAntigenSample1,
						Replace[Analytes]->{Link[targetantigen1]},
						State->Liquid
					|>,
					<|Object->testAntigenSample2,
						Replace[Analytes]->{Link[targetantigen1]},
						State->Liquid
					|>,
					<|Object->targetantigen1,
						DefaultSampleModel->Link[Model[Sample, "ExperimentELISAOptions test target antigen model sample 1" <> $SessionUUID]],
						State->Solid
					|>,
					<|Object->testAntibodySample1,
						Replace[Analytes]->{Link[antibodyMolecule1]},
						State->Liquid
					|>,
					<|Object->testAntibodySample2,
						Replace[Analytes]->{Link[antibodyMolecule2]},
						State->Liquid
					|>,
					<|Object->testAntibodySample3,
						Replace[Analytes]->{Link[antibodyMolecule3]},
						State->Liquid
					|>,
					<|Object->testAntibodySample4,
						Replace[Analytes]->{Link[antibodyMolecule4]},
						State->Liquid
					|>,
					<|Object->testAntibodySample5,
						Replace[Analytes]->{Link[antibodyMolecule5]},
						State->Liquid
					|>,
					<|Object->testAntibodySample6,
						Replace[Analytes]->{Link[Model[Molecule,Protein,Antibody,"HRP-Conjugated Goat-Anti-Mouse-IgG Secondary Antibody"]]},
						State->Liquid
					|>

				}

			]
		]

	),


	SymbolTearDown:>{
		Module[{allObjects,existingObjects},
			allObjects=
					{
						(* Bench *)
						Object[Container,Bench,"Test test bench for ExperimentELISAOptions tests" <> $SessionUUID],
						(*Containers*)
						Object[Container,Vessel,"ExperimentELISAOptions test container 1" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAOptions test container 2" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAOptions test container 3" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAOptions test container 4" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAOptions test container 5" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAOptions test container 6" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAOptions test container 7" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAOptions test container 8" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAOptions test container 9" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAOptions test container 10" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAOptions test container 11" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISAOptions test container 12" <> $SessionUUID],


						(*Target Antigens Model molecules*)
						Model[Molecule,Protein,"ExperimentELISAOptions test target antigen model molecule 1" <> $SessionUUID],
						(*Antibody Model molecules*)
						Model[Molecule,Protein,Antibody,"ExperimentELISAOptions test antibody model molecule 1 HRP-conjugated" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISAOptions test antibody model molecule 2 non-conjugated" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISAOptions test antibody model molecule 3 non-conjugated" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISAOptions test antibody model molecule 4 tagged" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISAOptions test antibody model molecule 5 anti-tag" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISAOptions test antibody model molecule 6 HRP-conjugated secondary" <> $SessionUUID],


						(* Model samples *)
						Model[Sample,"ExperimentELISAOptions test model sample 1" <> $SessionUUID],
						(*Target Antigen Model Samples*)
						Model[Sample,"ExperimentELISAOptions test target antigen model sample 1" <> $SessionUUID],
						(* Antibody Model samples *)
						Model[Sample,"ExperimentELISAOptions test antibody model sample 1 HRP-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISAOptions test antibody model sample 2 non-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISAOptions test antibody model sample 3 non-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISAOptions test antibody model sample 4 tagged" <> $SessionUUID],
						Model[Sample,"ExperimentELISAOptions test antibody model sample 5 anti-tag" <> $SessionUUID],
						Model[Sample,"ExperimentELISAOptions test antibody model sample 6 HRP-conjugated secondary" <> $SessionUUID],


						(* Object samples *)
						Object[Sample,"ExperimentELISAOptions test object sample 1" <> $SessionUUID],
						Object[Sample,"ExperimentELISAOptions test object sample 2" <> $SessionUUID],
						Object[Sample,"ExperimentELISAOptions test object sample 3 discarded" <> $SessionUUID],
						Object[Sample,"ExperimentELISAOptions test object sample 4 solid" <> $SessionUUID],
						(*Target Antigen Object Samples*)
						Object[Sample,"ExperimentELISAOptions test target antigen object sample 1" <> $SessionUUID],
						Object[Sample,"ExperimentELISAOptions test target antigen object sample 2" <> $SessionUUID],
						(* Antibody Object samples *)
						Object[Sample,"ExperimentELISAOptions test antibody object sample 1 HRP-conjugated" <> $SessionUUID],
						Object[Sample,"ExperimentELISAOptions test antibody object sample 2 non-conjugated" <> $SessionUUID],
						Object[Sample,"ExperimentELISAOptions test antibody object sample 3 non-conjugated" <> $SessionUUID],
						Object[Sample,"ExperimentELISAOptions test antibody object sample 4 tagged" <> $SessionUUID],
						Object[Sample,"ExperimentELISAOptions test antibody object sample 5 anti-tag" <> $SessionUUID],
						Object[Sample,"ExperimentELISAOptions test antibody object sample 5 anti-tag" <> $SessionUUID],
						Object[Sample,"ExperimentELISAOptions test antibody object sample 6 HRP-conjugated secondary" <> $SessionUUID]


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
(*ValidExperimentELISAQ*)
DefineTests[
	ValidExperimentELISAQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issues:"},
			ValidExperimentELISAQ[Object[Sample,"ValidExperimentELISAQ test object sample 1" <> $SessionUUID]],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentELISAQ[Object[Sample,"ValidExperimentELISAQ test object sample 3 discarded" <> $SessionUUID]],
			False
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentELISAQ[Object[Sample,"ValidExperimentELISAQ test object sample 1" <> $SessionUUID],OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentELISAQ[Object[Sample,"ValidExperimentELISAQ test object sample 1" <> $SessionUUID],Verbose->True],
			True
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
						(* Bench *)
						Object[Container,Bench,"Test test bench for ValidExperimentELISAQ tests" <> $SessionUUID],
						(*Containers*)
						Object[Container,Vessel,"ValidExperimentELISAQ test container 1" <> $SessionUUID],
						Object[Container,Vessel,"ValidExperimentELISAQ test container 2" <> $SessionUUID],
						Object[Container,Vessel,"ValidExperimentELISAQ test container 3" <> $SessionUUID],
						Object[Container,Vessel,"ValidExperimentELISAQ test container 4" <> $SessionUUID],
						Object[Container,Vessel,"ValidExperimentELISAQ test container 5" <> $SessionUUID],
						Object[Container,Vessel,"ValidExperimentELISAQ test container 6" <> $SessionUUID],
						Object[Container,Vessel,"ValidExperimentELISAQ test container 7" <> $SessionUUID],
						Object[Container,Vessel,"ValidExperimentELISAQ test container 8" <> $SessionUUID],
						Object[Container,Vessel,"ValidExperimentELISAQ test container 9" <> $SessionUUID],
						Object[Container,Vessel,"ValidExperimentELISAQ test container 10" <> $SessionUUID],
						Object[Container,Vessel,"ValidExperimentELISAQ test container 11" <> $SessionUUID],
						Object[Container,Vessel,"ValidExperimentELISAQ test container 12" <> $SessionUUID],


						(*Target Antigens Model molecules*)
						Model[Molecule,Protein,"ValidExperimentELISAQ test target antigen model molecule 1" <> $SessionUUID],
						(*Antibody Model molecules*)
						Model[Molecule,Protein,Antibody,"ValidExperimentELISAQ test antibody model molecule 1 HRP-conjugated" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ValidExperimentELISAQ test antibody model molecule 2 non-conjugated" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ValidExperimentELISAQ test antibody model molecule 3 non-conjugated" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ValidExperimentELISAQ test antibody model molecule 4 tagged" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ValidExperimentELISAQ test antibody model molecule 5 anti-tag" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ValidExperimentELISAQ test antibody model molecule 6 HRP-conjugated secondary" <> $SessionUUID],


						(* Model samples *)
						Model[Sample,"ValidExperimentELISAQ test model sample 1" <> $SessionUUID],
						(*Target Antigen Model Samples*)
						Model[Sample,"ValidExperimentELISAQ test target antigen model sample 1" <> $SessionUUID],
						(* Antibody Model samples *)
						Model[Sample,"ValidExperimentELISAQ test antibody model sample 1 HRP-conjugated" <> $SessionUUID],
						Model[Sample,"ValidExperimentELISAQ test antibody model sample 2 non-conjugated" <> $SessionUUID],
						Model[Sample,"ValidExperimentELISAQ test antibody model sample 3 non-conjugated" <> $SessionUUID],
						Model[Sample,"ValidExperimentELISAQ test antibody model sample 4 tagged" <> $SessionUUID],
						Model[Sample,"ValidExperimentELISAQ test antibody model sample 5 anti-tag" <> $SessionUUID],
						Model[Sample,"ValidExperimentELISAQ test antibody model sample 6 HRP-conjugated secondary" <> $SessionUUID],


						(* Object samples *)
						Object[Sample,"ValidExperimentELISAQ test object sample 1" <> $SessionUUID],
						Object[Sample,"ValidExperimentELISAQ test object sample 2" <> $SessionUUID],
						Object[Sample,"ValidExperimentELISAQ test object sample 3 discarded" <> $SessionUUID],
						Object[Sample,"ValidExperimentELISAQ test object sample 4 solid" <> $SessionUUID],
						(*Target Antigen Object Samples*)
						Object[Sample,"ValidExperimentELISAQ test target antigen object sample 1" <> $SessionUUID],
						Object[Sample,"ValidExperimentELISAQ test target antigen object sample 2" <> $SessionUUID],
						(* Antibody Object samples *)
						Object[Sample,"ValidExperimentELISAQ test antibody object sample 1 HRP-conjugated" <> $SessionUUID],
						Object[Sample,"ValidExperimentELISAQ test antibody object sample 2 non-conjugated" <> $SessionUUID],
						Object[Sample,"ValidExperimentELISAQ test antibody object sample 3 non-conjugated" <> $SessionUUID],
						Object[Sample,"ValidExperimentELISAQ test antibody object sample 4 tagged" <> $SessionUUID],
						Object[Sample,"ValidExperimentELISAQ test antibody object sample 5 anti-tag" <> $SessionUUID],
						Object[Sample,"ValidExperimentELISAQ test antibody object sample 5 anti-tag" <> $SessionUUID],
						Object[Sample,"ValidExperimentELISAQ test antibody object sample 6 HRP-conjugated secondary" <> $SessionUUID]

					};
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];


		Block[{$AllowSystemsProtocols = True},
			Module[{
				testBench,
				container1,
				container2,
				container3,
				container4,
				container5,
				container6,
				container7,
				container8,
				container9,
				container10,
				container11,
				container12,
				targetantigen1,
				antibodyMolecule1,
				antibodyMolecule2,
				antibodyMolecule3,
				antibodyMolecule4,
				antibodyMolecule5,
				antibodyMolecule6,
				antibodyModelSample1,
				antibodyModelSample2,
				antibodyModelSample3,
				antibodyModelSample4,
				antibodyModelSample5,
				antibodyModelSample6,
				testSample1,
				testSample2,
				testSample3,
				testSample4,
				testAntigenSample1,
				testAntigenSample2,
				testAntibodySample1,
				testAntibodySample2,
				testAntibodySample3,
				testAntibodySample4,
				testAntibodySample5,
				testAntibodySample6
			},
				(*Test Bench Object*)
				testBench=Upload[
					<|
						Type->Object[Container,Bench],
						Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
						Name->"Test test bench for ValidExperimentELISAQ tests" <> $SessionUUID,
						StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
						DeveloperObject -> True
					|>
				];

				Block[{$DeveloperUpload = True},
					(*Test Containers*)
					{
						container1,
						container2,
						container3,
						container4,
						container5,
						container6,
						container7,
						container8,
						container9,
						container10,
						container11,
						container12
					}=UploadSample[
						ConstantArray[Model[Container,Vessel,"2mL Tube"],12],
						ConstantArray[{"Work Surface", testBench},12],
						Status->ConstantArray[Available,12],
						Name->{
							"ValidExperimentELISAQ test container 1" <> $SessionUUID,
							"ValidExperimentELISAQ test container 2" <> $SessionUUID,
							"ValidExperimentELISAQ test container 3" <> $SessionUUID,
							"ValidExperimentELISAQ test container 4" <> $SessionUUID,
							"ValidExperimentELISAQ test container 5" <> $SessionUUID,
							"ValidExperimentELISAQ test container 6" <> $SessionUUID,
							"ValidExperimentELISAQ test container 7" <> $SessionUUID,
							"ValidExperimentELISAQ test container 8" <> $SessionUUID,
							"ValidExperimentELISAQ test container 9" <> $SessionUUID,
							"ValidExperimentELISAQ test container 10" <> $SessionUUID,
							"ValidExperimentELISAQ test container 11" <> $SessionUUID,
							"ValidExperimentELISAQ test container 12" <> $SessionUUID
						},
						StorageCondition->AmbientStorage
					];
				];

				(* Target Antigens Model molecules*)
				{targetantigen1}=UploadProtein[
					{"ValidExperimentELISAQ test target antigen model molecule 1" <> $SessionUUID},
					State->Solid,
					BiosafetyLevel->"BSL-1",
					Flammable->False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials->{None},
					ExpirationHazard->False
				];

				(*Antibody Model molecules*)
				{
					antibodyMolecule1,
					antibodyMolecule2,
					antibodyMolecule3,
					antibodyMolecule4,
					antibodyMolecule5,
					antibodyMolecule6

				}=UploadAntibody[
					{
						"ValidExperimentELISAQ test antibody model molecule 1 HRP-conjugated" <> $SessionUUID,
						"ValidExperimentELISAQ test antibody model molecule 2 non-conjugated" <> $SessionUUID,
						"ValidExperimentELISAQ test antibody model molecule 3 non-conjugated" <> $SessionUUID,
						"ValidExperimentELISAQ test antibody model molecule 4 tagged" <> $SessionUUID,
						"ValidExperimentELISAQ test antibody model molecule 5 anti-tag" <> $SessionUUID,
						"ValidExperimentELISAQ test antibody model molecule 6 HRP-conjugated secondary" <> $SessionUUID
					},
					State->Solid,
					BiosafetyLevel->"BSL-1",
					Flammable->False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials->{None},
					ExpirationHazard->False,
					Targets->{targetantigen1}
				];

				(* Model samples *)
				Upload[
					<|
						Name->"ValidExperimentELISAQ test model sample 1" <> $SessionUUID,
						Type->Model[Sample],
						DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
						State->Liquid,
						Replace[Analytes]->{Link[targetantigen1]}
					|>
				];

				(*Target Antigen Model Samples*)
				Upload[
					<|
						Name->"ValidExperimentELISAQ test target antigen model sample 1" <> $SessionUUID,
						Type->Model[Sample],
						DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
						State->Liquid,
						Replace[Analytes]->{Link[targetantigen1]}
					|>
				];

				(* Antibody Model samples *)


				{
					antibodyModelSample1,
					antibodyModelSample2,
					antibodyModelSample3,
					antibodyModelSample4,
					antibodyModelSample5,
					antibodyModelSample6
				}=Upload[
					<|
						Name->#,
						Type->Model[Sample],
						DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
						State->Liquid
					|>
				]&/@
						{
							"ValidExperimentELISAQ test antibody model sample 1 HRP-conjugated" <> $SessionUUID,
							"ValidExperimentELISAQ test antibody model sample 2 non-conjugated" <> $SessionUUID,
							"ValidExperimentELISAQ test antibody model sample 3 non-conjugated" <> $SessionUUID,
							"ValidExperimentELISAQ test antibody model sample 4 tagged" <> $SessionUUID,
							"ValidExperimentELISAQ test antibody model sample 5 anti-tag" <> $SessionUUID,
							"ValidExperimentELISAQ test antibody model sample 6 HRP-conjugated secondary" <> $SessionUUID
						};

				(*Object samples, Target Antigen Objects, Antibody Objects*)
				{
					testSample1,
					testSample2,
					testSample3,
					testSample4,
					testAntigenSample1,
					testAntigenSample2,
					testAntibodySample1,
					testAntibodySample2,
					testAntibodySample3,
					testAntibodySample4,
					testAntibodySample5,
					testAntibodySample6

				}=UploadSample[
					{
						(* Model samples *)
						Model[Sample,"ValidExperimentELISAQ test model sample 1" <> $SessionUUID],
						Model[Sample,"ValidExperimentELISAQ test model sample 1" <> $SessionUUID],
						Model[Sample,"ValidExperimentELISAQ test model sample 1" <> $SessionUUID],
						Model[Sample,"ValidExperimentELISAQ test model sample 1" <> $SessionUUID],
						(*Target Antigen Model Samples*)
						Model[Sample,"ValidExperimentELISAQ test target antigen model sample 1" <> $SessionUUID],
						Model[Sample,"ValidExperimentELISAQ test target antigen model sample 1" <> $SessionUUID],
						(* Antibody Model samples *)
						Model[Sample,"ValidExperimentELISAQ test antibody model sample 1 HRP-conjugated" <> $SessionUUID],
						Model[Sample,"ValidExperimentELISAQ test antibody model sample 2 non-conjugated" <> $SessionUUID],
						Model[Sample,"ValidExperimentELISAQ test antibody model sample 3 non-conjugated" <> $SessionUUID],
						Model[Sample,"ValidExperimentELISAQ test antibody model sample 4 tagged" <> $SessionUUID],
						Model[Sample,"ValidExperimentELISAQ test antibody model sample 5 anti-tag" <> $SessionUUID],
						Model[Sample,"HRP-Conjugated Goat-Anti-Mouse-IgG Secondary Antibody"]
					},
					{
						{"A1",container1},
						{"A1",container2},
						{"A1",container3},
						{"A1",container4},
						{"A1",container5},
						{"A1",container6},
						{"A1",container7},
						{"A1",container8},
						{"A1",container9},
						{"A1",container10},
						{"A1",container11},
						{"A1",container12}
					},
					Name->{
						"ValidExperimentELISAQ test object sample 1" <> $SessionUUID,
						"ValidExperimentELISAQ test object sample 2" <> $SessionUUID,
						"ValidExperimentELISAQ test object sample 3 discarded" <> $SessionUUID,
						"ValidExperimentELISAQ test object sample 4 solid" <> $SessionUUID,
						"ValidExperimentELISAQ test target antigen object sample 1" <> $SessionUUID,
						"ValidExperimentELISAQ test target antigen object sample 2" <> $SessionUUID,
						"ValidExperimentELISAQ test antibody object sample 1 HRP-conjugated" <> $SessionUUID,
						"ValidExperimentELISAQ test antibody object sample 2 non-conjugated" <> $SessionUUID,
						"ValidExperimentELISAQ test antibody object sample 3 non-conjugated" <> $SessionUUID,
						"ValidExperimentELISAQ test antibody object sample 4 tagged" <> $SessionUUID,
						"ValidExperimentELISAQ test antibody object sample 5 anti-tag" <> $SessionUUID,
						"ValidExperimentELISAQ test antibody object sample 6 HRP-conjugated secondary" <> $SessionUUID
					},
					InitialAmount->ConstantArray[1.8Milliliter,12]
				];
				Upload/@{
					<|Object->antibodyMolecule1,
						Replace[Targets]->{Link[Model[Molecule,Protein,"ValidExperimentELISAQ test target antigen model molecule 1" <> $SessionUUID],Antibodies]},
						DefaultSampleModel->Link[antibodyModelSample1],
						Replace[SecondaryAntibodies]->{Link[Model[Molecule,Protein,Antibody,"ValidExperimentELISAQ test antibody model molecule 6 HRP-conjugated secondary" <> $SessionUUID],Targets]},
						Replace[DetectionLabels]-> {Link[Model[Molecule, Protein,"Horseradish Peroxidase"]]}
					|>,
					<|Object->antibodyMolecule2,
						Replace[Targets]->{Link[Model[Molecule,Protein,"ValidExperimentELISAQ test target antigen model molecule 1" <> $SessionUUID],Antibodies]},
						DefaultSampleModel->Link[antibodyModelSample2],
						Replace[SecondaryAntibodies]->{Link[Model[Molecule,Protein,Antibody,"ValidExperimentELISAQ test antibody model molecule 6 HRP-conjugated secondary" <> $SessionUUID],Targets]},
						Organism->Mouse
					|>,
					<|Object->antibodyMolecule3,
						Replace[Targets]->{Link[Model[Molecule,Protein,"ValidExperimentELISAQ test target antigen model molecule 1" <> $SessionUUID],Antibodies]},
						DefaultSampleModel->Link[antibodyModelSample3],
						Replace[SecondaryAntibodies]->{Link[Model[Molecule,Protein,Antibody,"ValidExperimentELISAQ test antibody model molecule 6 HRP-conjugated secondary" <> $SessionUUID],Targets]},
						Organism->Rabbit
					|>,
					<|Object->antibodyMolecule4,
						Replace[Targets]->{Link[Model[Molecule,Protein,"ValidExperimentELISAQ test target antigen model molecule 1" <> $SessionUUID],Antibodies]},
						DefaultSampleModel->Link[antibodyModelSample4],
						Replace[SecondaryAntibodies]->{Link[Model[Molecule,Protein,Antibody,"ValidExperimentELISAQ test antibody model molecule 5 anti-tag" <> $SessionUUID],Targets]},
						Replace[AffinityLabels]->{Link[Model[Molecule, Protein,"V5 Tag"]]}
					|>,
					<|Object->antibodyMolecule5,
						Replace[Targets]->{Link[Model[Molecule,Protein,"V5 Tag"],Antibodies]},
						DefaultSampleModel->Link[Model[Sample, "ValidExperimentELISAQ test antibody model sample 5 anti-tag" <> $SessionUUID]]
					|>,
					<|Object->antibodyMolecule6,
						Replace[Targets]->{Link[Model[Molecule,Protein,Antibody,"ValidExperimentELISAQ test antibody model molecule 2 non-conjugated" <> $SessionUUID],SecondaryAntibodies],Link[Model[Molecule,Protein,Antibody,"ValidExperimentELISAQ test antibody model molecule 3 non-conjugated" <> $SessionUUID],SecondaryAntibodies]},
						DefaultSampleModel->Link[antibodyModelSample6],
						Replace[DetectionLabels]-> {Link[Model[Molecule, Protein,"Horseradish Peroxidase"]]}
					|>,
					<|Object->antibodyModelSample1,
						Replace[Analytes]->{Link[antibodyMolecule1]}
					|>,
					<|Object->antibodyModelSample2,
						Replace[Analytes]->{Link[antibodyMolecule2]}
					|>,
					<|Object->antibodyModelSample3,
						Replace[Analytes]->{Link[antibodyMolecule3]}
					|>,
					<|Object->antibodyModelSample4,
						Replace[Analytes]->{Link[antibodyMolecule4]}
					|>,
					<|Object->antibodyModelSample5,
						Replace[Analytes]->{Link[antibodyMolecule5]}
					|>,
					<|Object->antibodyModelSample6,
						Replace[Analytes]->{Link[antibodyMolecule6]}
					|>,
					<|Object->testSample1,Status->Available,State->Liquid,
						Replace[Analytes]->{Link[targetantigen1]},
						Replace[Composition]->{{Null,Link[targetantigen1],Now}}
					|>,
					<|Object->testSample2,Status->Available,State->Liquid,
						Replace[Analytes]->{Link[targetantigen1]},
						Replace[Composition]->{{Null,Link[targetantigen1],Now}}
					|>,
					<|Object->testSample3,Status->Discarded,State->Liquid,
						Replace[Analytes]->{Link[targetantigen1]},
						Replace[Composition]->{{Null,Link[targetantigen1],Now}}
					|>,
					<|Object->testSample4,Status->Available,State->Solid,
						Replace[Analytes]->{Link[targetantigen1]},
						Replace[Composition]->{{Null,Link[targetantigen1],Now}},
						Volume->Null
					|>,
					<|Object->testAntigenSample1,
						Replace[Analytes]->{Link[targetantigen1]},
						State->Liquid
					|>,
					<|Object->testAntigenSample2,
						Replace[Analytes]->{Link[targetantigen1]},
						State->Liquid
					|>,
					<|Object->targetantigen1,
						DefaultSampleModel->Link[Model[Sample, "ValidExperimentELISAQ test target antigen model sample 1" <> $SessionUUID]],
						State->Solid
					|>,
					<|Object->testAntibodySample1,
						Replace[Analytes]->{Link[antibodyMolecule1]},
						State->Liquid
					|>,
					<|Object->testAntibodySample2,
						Replace[Analytes]->{Link[antibodyMolecule2]},
						State->Liquid
					|>,
					<|Object->testAntibodySample3,
						Replace[Analytes]->{Link[antibodyMolecule3]},
						State->Liquid
					|>,
					<|Object->testAntibodySample4,
						Replace[Analytes]->{Link[antibodyMolecule4]},
						State->Liquid
					|>,
					<|Object->testAntibodySample5,
						Replace[Analytes]->{Link[antibodyMolecule5]},
						State->Liquid
					|>,
					<|Object->testAntibodySample6,
						Replace[Analytes]->{Link[Model[Molecule,Protein,Antibody,"HRP-Conjugated Goat-Anti-Mouse-IgG Secondary Antibody"]]},
						State->Liquid
					|>

				}

			]
		]

	),


	SymbolTearDown:>{
		Module[{allObjects,existingObjects},
			allObjects=
					{
						(* Bench *)
						Object[Container,Bench,"Test test bench for ValidExperimentELISAQ tests" <> $SessionUUID],
						(*Containers*)
						Object[Container,Vessel,"ValidExperimentELISAQ test container 1" <> $SessionUUID],
						Object[Container,Vessel,"ValidExperimentELISAQ test container 2" <> $SessionUUID],
						Object[Container,Vessel,"ValidExperimentELISAQ test container 3" <> $SessionUUID],
						Object[Container,Vessel,"ValidExperimentELISAQ test container 4" <> $SessionUUID],
						Object[Container,Vessel,"ValidExperimentELISAQ test container 5" <> $SessionUUID],
						Object[Container,Vessel,"ValidExperimentELISAQ test container 6" <> $SessionUUID],
						Object[Container,Vessel,"ValidExperimentELISAQ test container 7" <> $SessionUUID],
						Object[Container,Vessel,"ValidExperimentELISAQ test container 8" <> $SessionUUID],
						Object[Container,Vessel,"ValidExperimentELISAQ test container 9" <> $SessionUUID],
						Object[Container,Vessel,"ValidExperimentELISAQ test container 10" <> $SessionUUID],
						Object[Container,Vessel,"ValidExperimentELISAQ test container 11" <> $SessionUUID],
						Object[Container,Vessel,"ValidExperimentELISAQ test container 12" <> $SessionUUID],


						(*Target Antigens Model molecules*)
						Model[Molecule,Protein,"ValidExperimentELISAQ test target antigen model molecule 1" <> $SessionUUID],
						(*Antibody Model molecules*)
						Model[Molecule,Protein,Antibody,"ValidExperimentELISAQ test antibody model molecule 1 HRP-conjugated" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ValidExperimentELISAQ test antibody model molecule 2 non-conjugated" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ValidExperimentELISAQ test antibody model molecule 3 non-conjugated" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ValidExperimentELISAQ test antibody model molecule 4 tagged" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ValidExperimentELISAQ test antibody model molecule 5 anti-tag" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ValidExperimentELISAQ test antibody model molecule 6 HRP-conjugated secondary" <> $SessionUUID],


						(* Model samples *)
						Model[Sample,"ValidExperimentELISAQ test model sample 1" <> $SessionUUID],
						(*Target Antigen Model Samples*)
						Model[Sample,"ValidExperimentELISAQ test target antigen model sample 1" <> $SessionUUID],
						(* Antibody Model samples *)
						Model[Sample,"ValidExperimentELISAQ test antibody model sample 1 HRP-conjugated" <> $SessionUUID],
						Model[Sample,"ValidExperimentELISAQ test antibody model sample 2 non-conjugated" <> $SessionUUID],
						Model[Sample,"ValidExperimentELISAQ test antibody model sample 3 non-conjugated" <> $SessionUUID],
						Model[Sample,"ValidExperimentELISAQ test antibody model sample 4 tagged" <> $SessionUUID],
						Model[Sample,"ValidExperimentELISAQ test antibody model sample 5 anti-tag" <> $SessionUUID],
						Model[Sample,"ValidExperimentELISAQ test antibody model sample 6 HRP-conjugated secondary" <> $SessionUUID],


						(* Object samples *)
						Object[Sample,"ValidExperimentELISAQ test object sample 1" <> $SessionUUID],
						Object[Sample,"ValidExperimentELISAQ test object sample 2" <> $SessionUUID],
						Object[Sample,"ValidExperimentELISAQ test object sample 3 discarded" <> $SessionUUID],
						Object[Sample,"ValidExperimentELISAQ test object sample 4 solid" <> $SessionUUID],
						(*Target Antigen Object Samples*)
						Object[Sample,"ValidExperimentELISAQ test target antigen object sample 1" <> $SessionUUID],
						Object[Sample,"ValidExperimentELISAQ test target antigen object sample 2" <> $SessionUUID],
						(* Antibody Object samples *)
						Object[Sample,"ValidExperimentELISAQ test antibody object sample 1 HRP-conjugated" <> $SessionUUID],
						Object[Sample,"ValidExperimentELISAQ test antibody object sample 2 non-conjugated" <> $SessionUUID],
						Object[Sample,"ValidExperimentELISAQ test antibody object sample 3 non-conjugated" <> $SessionUUID],
						Object[Sample,"ValidExperimentELISAQ test antibody object sample 4 tagged" <> $SessionUUID],
						Object[Sample,"ValidExperimentELISAQ test antibody object sample 5 anti-tag" <> $SessionUUID],
						Object[Sample,"ValidExperimentELISAQ test antibody object sample 5 anti-tag" <> $SessionUUID],
						Object[Sample,"ValidExperimentELISAQ test antibody object sample 6 HRP-conjugated secondary" <> $SessionUUID]


					};
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			On[Warning::NegativeDiluentVolume]
		]
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
]