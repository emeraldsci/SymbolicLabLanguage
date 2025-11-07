(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*UploadArrayCard*)


(* ::Subsubsection:: *)
(*UploadArrayCard*)


DefineTests[UploadArrayCard,
	{
		Example[{Basic,"Creates a new array card model from qPCR detection reagents:"},
			UploadArrayCard[
				{
					{Model[Molecule,Oligomer,"UploadArrayCard test forward primer 1"<>$SessionUUID],Model[Molecule,Oligomer,"UploadArrayCard test reverse primer 1"<>$SessionUUID]},
					{Model[Molecule,Oligomer,"UploadArrayCard test forward primer 2"<>$SessionUUID],Model[Molecule,Oligomer,"UploadArrayCard test reverse primer 2"<>$SessionUUID]}
				},
				{
					Model[Molecule,Oligomer,"UploadArrayCard test probe 1"<>$SessionUUID],
					Model[Molecule,Oligomer,"UploadArrayCard test probe 2"<>$SessionUUID]
				}
			],
			ObjectP[Model[Container,Plate,Irregular,ArrayCard]],
			Stubs:>{
				$DeveloperSearch=True
			}
		],
		(* use CreateUUID instead of $SessionUUID because we don't actually clean up new Model[Container, Plate, Irregular] in the TearDown and so we need unique names for real *)
		With[{name = "Test" <> CreateUUID[]},
			Example[{Options,Name,"Specify the name of the new model:"},
				arrayCard=UploadArrayCard[
					{
						{Model[Molecule,Oligomer,"UploadArrayCard test forward primer 1"<>$SessionUUID],Model[Molecule,Oligomer,"UploadArrayCard test reverse primer 1"<>$SessionUUID]}
					},
					{Model[Molecule,Oligomer,"UploadArrayCard test probe 1"<>$SessionUUID]},
					Name->name
				];
				Download[arrayCard,Name],
				name,
				Stubs:>{
					$DeveloperSearch=True
				},
				Variables:>{arrayCard}
			]
		],
		Example[{Messages,"TooManyInputsForArrayCard","The number of inputs cannot exceed 384:"},
			UploadArrayCard[
				Table[{Model[Molecule,Oligomer,"UploadArrayCard test forward primer 1"<>$SessionUUID],Model[Molecule,Oligomer,"UploadArrayCard test reverse primer 1"<>$SessionUUID]},385],
				Table[Model[Molecule,Oligomer,"UploadArrayCard test probe 1"<>$SessionUUID],385]
			],
			$Failed,
			Messages:>{
				Error::TooManyInputsForArrayCard,
				Error::InvalidInput
			},
			Stubs:>{
				$DeveloperSearch=True
			}
		],
		Example[{Messages,"ArrayCardExists","Returns the existing array card model if one already exists for the given inputs:"},
			UploadArrayCard[
				{
					{Model[Molecule,Oligomer,"UploadArrayCard test forward primer 2"<>$SessionUUID],Model[Molecule,Oligomer,"UploadArrayCard test reverse primer 2"<>$SessionUUID]}
				},
				{Model[Molecule,Oligomer,"UploadArrayCard test probe 2"<>$SessionUUID]}
			],
			ObjectP[Model[Container,Plate,Irregular,ArrayCard,"UploadArrayCard test existing array card"<>$SessionUUID]],
			Messages:>{
				Warning::ArrayCardExists
			},
			Stubs:>{
				$DeveloperSearch=True
			}
		],
		Example[{Messages,"DuplicateName","The specified Name cannot already exist for another array card:"},
			UploadArrayCard[
				{
					{Model[Molecule,Oligomer,"UploadArrayCard test forward primer 1"<>$SessionUUID],Model[Molecule,Oligomer,"UploadArrayCard test reverse primer 1"<>$SessionUUID]}
				},
				{Model[Molecule,Oligomer,"UploadArrayCard test probe 1"<>$SessionUUID]},
				Name->"UploadArrayCard test named array card"<>$SessionUUID
			],
			$Failed,
			Messages:>{
				Error::DuplicateName,
				Error::InvalidOption
			},
			Stubs:>{
				$DeveloperSearch=True
			}
		]
	},


	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SetUp:>($CreatedObjects={}),
	TearDown:>(
		(* doing this because a primary cause of flaky tests is these Irregular plates showing up momentarily in other searches, and then them subsequently trying to Download from them but you can't because they've been erased already.  So just don't erase them and it'll be fine *)
		EraseObject[DeleteCases[$CreatedObjects, ObjectP[Model[Container, Plate, Irregular]]],Force->True,Verbose->False];
		Upload[<|Object -> #, Name -> Null|>& /@ Cases[$CreatedObjects, ObjectP[Model[Container, Plate, Irregular]]]];
		Unset[$CreatedObjects]
	),

	SymbolSetUp:>(
		Module[{allObjects,existingObjects},

			(*Gather all the objects created in SymbolSetUp*)
			allObjects={
				(*Detection reagents*)
				Model[Molecule,Oligomer,"UploadArrayCard test forward primer 1"<>$SessionUUID],
				Model[Molecule,Oligomer,"UploadArrayCard test reverse primer 1"<>$SessionUUID],
				Model[Molecule,Oligomer,"UploadArrayCard test probe 1"<>$SessionUUID],
				Model[Molecule,Oligomer,"UploadArrayCard test forward primer 2"<>$SessionUUID],
				Model[Molecule,Oligomer,"UploadArrayCard test reverse primer 2"<>$SessionUUID],
				Model[Molecule,Oligomer,"UploadArrayCard test probe 2"<>$SessionUUID],
				(*Array cards*)
				Model[Container,Plate,Irregular,ArrayCard,"UploadArrayCard test existing array card"<>$SessionUUID],
				Model[Container,Plate,Irregular,ArrayCard,"UploadArrayCard test named array card"<>$SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		Block[{$AllowSystemsProtocols=True},
			Module[{allObjects},

				(*Gather all the created objects*)
				allObjects={
					(*Detection reagents*)
					Model[Molecule,Oligomer,"UploadArrayCard test forward primer 1"<>$SessionUUID],
					Model[Molecule,Oligomer,"UploadArrayCard test reverse primer 1"<>$SessionUUID],
					Model[Molecule,Oligomer,"UploadArrayCard test probe 1"<>$SessionUUID],
					Model[Molecule,Oligomer,"UploadArrayCard test forward primer 2"<>$SessionUUID],
					Model[Molecule,Oligomer,"UploadArrayCard test reverse primer 2"<>$SessionUUID],
					Model[Molecule,Oligomer,"UploadArrayCard test probe 2"<>$SessionUUID],
					(*Array cards*)
					Model[Container,Plate,Irregular,ArrayCard,"UploadArrayCard test existing array card"<>$SessionUUID],
					Model[Container,Plate,Irregular,ArrayCard,"UploadArrayCard test named array card"<>$SessionUUID]
				};

				(*Make some detection reagents*)
				UploadOligomer[
					{
						"UploadArrayCard test forward primer 1"<>$SessionUUID ,
						"UploadArrayCard test reverse primer 1"<>$SessionUUID ,
						"UploadArrayCard test probe 1"<>$SessionUUID ,
						"UploadArrayCard test forward primer 2"<>$SessionUUID ,
						"UploadArrayCard test reverse primer 2"<>$SessionUUID ,
						"UploadArrayCard test probe 2"<>$SessionUUID
					},
					PolymerType->DNA,
					MolecularWeight->5 Kilogram/Mole,
					State->Solid,
					BiosafetyLevel->"BSL-1",
					Flammable->False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials->{None},
					ExpirationHazard->False
				];

				(*Make some array cards*)
				Upload[{
					<|
						Type->Model[Container,Plate,Irregular,ArrayCard],
						Name->"UploadArrayCard test existing array card"<>$SessionUUID ,
						Replace[ForwardPrimers]->Link[Model[Molecule,Oligomer,"UploadArrayCard test forward primer 2"<>$SessionUUID]],
						Replace[ReversePrimers]->Link[Model[Molecule,Oligomer,"UploadArrayCard test reverse primer 2"<>$SessionUUID]],
						Replace[Probes]->Link[Model[Molecule,Oligomer,"UploadArrayCard test probe 2"<>$SessionUUID]]
					|>,
					<|
						Type->Model[Container,Plate,Irregular,ArrayCard],
						Name->"UploadArrayCard test named array card"<>$SessionUUID
					|>
				}];

				(*Make all the test objects developer objects*)
				Upload[<|Object->#,DeveloperObject->True|>&/@allObjects]
			]
		];
	),


	SymbolTearDown:>(
		Module[{allObjects,existingObjects},

			(*Gather all the objects created in SymbolSetUp*)
			allObjects={
				(*Detection reagents*)
				Model[Molecule,Oligomer,"UploadArrayCard test forward primer 1"<>$SessionUUID],
				Model[Molecule,Oligomer,"UploadArrayCard test reverse primer 1"<>$SessionUUID],
				Model[Molecule,Oligomer,"UploadArrayCard test probe 1"<>$SessionUUID],
				Model[Molecule,Oligomer,"UploadArrayCard test forward primer 2"<>$SessionUUID],
				Model[Molecule,Oligomer,"UploadArrayCard test reverse primer 2"<>$SessionUUID],
				Model[Molecule,Oligomer,"UploadArrayCard test probe 2"<>$SessionUUID],
				(*Array cards*)
				Model[Container,Plate,Irregular,ArrayCard,"UploadArrayCard test existing array card"<>$SessionUUID],
				Model[Container,Plate,Irregular,ArrayCard,"UploadArrayCard test named array card"<>$SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase all the created objects*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];
	)
];


(* ::Subsection::Closed:: *)
(*UploadArrayCardOptions*)


DefineTests[UploadArrayCardOptions,
	{
		Example[{Basic,"Returns the options in table form:"},
			UploadArrayCardOptions[
				{
					{Model[Molecule,Oligomer,"UploadArrayCardOptions test forward primer 1 " <> $SessionUUID],Model[Molecule,Oligomer,"UploadArrayCardOptions test reverse primer 1 " <> $SessionUUID]}
				},
				{Model[Molecule,Oligomer,"UploadArrayCardOptions test probe 1 " <> $SessionUUID]}
			],
			_Grid,
			Stubs:>{
				$DeveloperSearch=True
			}
		],
		Example[{Options,OutputFormat,"If OutputFormat -> List, returns the options as a list of rules:"},
			UploadArrayCardOptions[
				{
					{Model[Molecule,Oligomer,"UploadArrayCardOptions test forward primer 1 " <> $SessionUUID],Model[Molecule,Oligomer,"UploadArrayCardOptions test reverse primer 1 " <> $SessionUUID]}
				},
				{Model[Molecule,Oligomer,"UploadArrayCardOptions test probe 1 " <> $SessionUUID]},
				OutputFormat->List
			],
			{(_Rule|_RuleDelayed)..},
			Stubs:>{
				$DeveloperSearch=True
			}
		]
	},


	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},


	SymbolSetUp:>(
		Module[{allObjects,existingObjects},

			(*Gather all the objects created in SymbolSetUp*)
			allObjects={
				(*Detection reagents*)
				Model[Molecule,Oligomer,"UploadArrayCardOptions test forward primer 1 " <> $SessionUUID],
				Model[Molecule,Oligomer,"UploadArrayCardOptions test reverse primer 1 " <> $SessionUUID],
				Model[Molecule,Oligomer,"UploadArrayCardOptions test probe 1 " <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		Block[{$AllowSystemsProtocols=True},
			Module[{allObjects},

				(*Gather all the created objects*)
				allObjects={
					(*Detection reagents*)
					Model[Molecule,Oligomer,"UploadArrayCardOptions test forward primer 1 " <> $SessionUUID],
					Model[Molecule,Oligomer,"UploadArrayCardOptions test reverse primer 1 " <> $SessionUUID],
					Model[Molecule,Oligomer,"UploadArrayCardOptions test probe 1 " <> $SessionUUID]
				};

				(*Make some detection reagents*)
				UploadOligomer[
					{
						"UploadArrayCardOptions test forward primer 1 " <> $SessionUUID,
						"UploadArrayCardOptions test reverse primer 1 " <> $SessionUUID,
						"UploadArrayCardOptions test probe 1 " <> $SessionUUID
					},
					PolymerType->DNA,
					MolecularWeight->5 Kilogram/Mole,
					State->Solid,
					BiosafetyLevel->"BSL-1",
					Flammable->False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials->{None},
					ExpirationHazard->False
				];

				(*Make all the test objects developer objects*)
				Upload[<|Object->#,DeveloperObject->True|>&/@allObjects]
			]
		];
	),


	SymbolTearDown:>(
		Module[{allObjects,existingObjects},

			(*Gather all the objects created in SymbolSetUp*)
			allObjects={
				(*Detection reagents*)
				Model[Molecule,Oligomer,"UploadArrayCardOptions test forward primer 1 " <> $SessionUUID],
				Model[Molecule,Oligomer,"UploadArrayCardOptions test reverse primer 1 " <> $SessionUUID],
				Model[Molecule,Oligomer,"UploadArrayCardOptions test probe 1 " <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase all the created objects*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];
	)
];


(* ::Subsection::Closed:: *)
(*UploadArrayCardPreview*)


DefineTests[UploadArrayCardPreview,
	{
		Example[{Basic,"No preview is currently available for UploadArrayCard:"},
			UploadArrayCardPreview[
				{
					{Model[Molecule,Oligomer,"UploadArrayCardPreview test forward primer 1 " <> $SessionUUID],Model[Molecule,Oligomer,"UploadArrayCardPreview test reverse primer 1 " <> $SessionUUID]}
				},
				{Model[Molecule,Oligomer,"UploadArrayCardPreview test probe 1 " <> $SessionUUID]}
			],
			Null,
			Stubs:>{
				$DeveloperSearch=True
			}
		]
	},


	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},


	SymbolSetUp:>(
		Module[{allObjects,existingObjects},

			(*Gather all the objects created in SymbolSetUp*)
			allObjects={
				(*Detection reagents*)
				Model[Molecule,Oligomer,"UploadArrayCardPreview test forward primer 1 " <> $SessionUUID],
				Model[Molecule,Oligomer,"UploadArrayCardPreview test reverse primer 1 " <> $SessionUUID],
				Model[Molecule,Oligomer,"UploadArrayCardPreview test probe 1 " <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		Block[{$AllowSystemsProtocols=True},
			Module[{allObjects},

				(*Gather all the created objects*)
				allObjects={
					(*Detection reagents*)
					Model[Molecule,Oligomer,"UploadArrayCardPreview test forward primer 1 " <> $SessionUUID],
					Model[Molecule,Oligomer,"UploadArrayCardPreview test reverse primer 1 " <> $SessionUUID],
					Model[Molecule,Oligomer,"UploadArrayCardPreview test probe 1 " <> $SessionUUID]
				};

				(*Make some detection reagents*)
				UploadOligomer[
					{
						"UploadArrayCardPreview test forward primer 1 " <> $SessionUUID,
						"UploadArrayCardPreview test reverse primer 1 " <> $SessionUUID,
						"UploadArrayCardPreview test probe 1 " <> $SessionUUID
					},
					PolymerType->DNA,
					MolecularWeight->5 Kilogram/Mole,
					State->Solid,
					BiosafetyLevel->"BSL-1",
					Flammable->False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials->{None},
					ExpirationHazard->False
				];

				(*Make all the test objects developer objects*)
				Upload[<|Object->#,DeveloperObject->True|>&/@allObjects]
			]
		];
	),


	SymbolTearDown:>(
		Module[{allObjects,existingObjects},

			(*Gather all the objects created in SymbolSetUp*)
			allObjects={
				(*Detection reagents*)
				Model[Molecule,Oligomer,"UploadArrayCardPreview test forward primer 1 " <> $SessionUUID],
				Model[Molecule,Oligomer,"UploadArrayCardPreview test reverse primer 1 " <> $SessionUUID],
				Model[Molecule,Oligomer,"UploadArrayCardPreview test probe 1 " <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase all the created objects*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];
	)
];


(* ::Subsection::Closed:: *)
(*ValidUploadArrayCardQ*)


DefineTests[ValidUploadArrayCardQ,
	{
		Example[{Basic,"Returns a Boolean indicating the validity of an array card:"},
			ValidUploadArrayCardQ[
				{
					{Model[Molecule,Oligomer,"ValidUploadArrayCardQ test forward primer 1 " <> $SessionUUID],Model[Molecule,Oligomer,"ValidUploadArrayCardQ test reverse primer 1 " <> $SessionUUID]}
				},
				{Model[Molecule,Oligomer,"ValidUploadArrayCardQ test probe 1 " <> $SessionUUID]}
			],
			True,
			Stubs:>{
				$DeveloperSearch=True
			}
		],
		Example[{Options,Verbose,"If Verbose -> True, returns the passing and failing tests:"},
			ValidUploadArrayCardQ[
				{
					{Model[Molecule,Oligomer,"ValidUploadArrayCardQ test forward primer 1 " <> $SessionUUID],Model[Molecule,Oligomer,"ValidUploadArrayCardQ test reverse primer 1 " <> $SessionUUID]}
				},
				{Model[Molecule,Oligomer,"ValidUploadArrayCardQ test probe 1 " <> $SessionUUID]},
				Verbose->True
			],
			True,
			Stubs:>{
				$DeveloperSearch=True
			}
		],
		Example[{Options,OutputFormat,"If OutputFormat -> TestSummary, returns a test summary instead of a Boolean:"},
			ValidUploadArrayCardQ[
				{
					{Model[Molecule,Oligomer,"ValidUploadArrayCardQ test forward primer 1 " <> $SessionUUID],Model[Molecule,Oligomer,"ValidUploadArrayCardQ test reverse primer 1 " <> $SessionUUID]}
				},
				{Model[Molecule,Oligomer,"ValidUploadArrayCardQ test probe 1 " <> $SessionUUID]},
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary,
			Stubs:>{
				$DeveloperSearch=True
			}
		]
	},


	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},


	SymbolSetUp:>(
		Module[{allObjects,existingObjects},

			(*Gather all the objects created in SymbolSetUp*)
			allObjects={
				(*Detection reagents*)
				Model[Molecule,Oligomer,"ValidUploadArrayCardQ test forward primer 1 " <> $SessionUUID],
				Model[Molecule,Oligomer,"ValidUploadArrayCardQ test reverse primer 1 " <> $SessionUUID],
				Model[Molecule,Oligomer,"ValidUploadArrayCardQ test probe 1 " <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		Block[{$AllowSystemsProtocols=True},
			Module[{allObjects},

				(*Gather all the created objects*)
				allObjects={
					(*Detection reagents*)
					Model[Molecule,Oligomer,"ValidUploadArrayCardQ test forward primer 1 " <> $SessionUUID],
					Model[Molecule,Oligomer,"ValidUploadArrayCardQ test reverse primer 1 " <> $SessionUUID],
					Model[Molecule,Oligomer,"ValidUploadArrayCardQ test probe 1 " <> $SessionUUID]
				};

				(*Make some detection reagents*)
				UploadOligomer[
					{
						"ValidUploadArrayCardQ test forward primer 1 " <> $SessionUUID,
						"ValidUploadArrayCardQ test reverse primer 1 " <> $SessionUUID,
						"ValidUploadArrayCardQ test probe 1 " <> $SessionUUID
					},
					PolymerType->DNA,
					MolecularWeight->5 Kilogram/Mole,
					State->Solid,
					BiosafetyLevel->"BSL-1",
					Flammable->False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials->{None},
					ExpirationHazard->False
				];

				(*Make all the test objects developer objects*)
				Upload[<|Object->#,DeveloperObject->True|>&/@allObjects]
			]
		];
	),


	SymbolTearDown:>(
		Module[{allObjects,existingObjects},

			(*Gather all the objects created in SymbolSetUp*)
			allObjects={
				(*Detection reagents*)
				Model[Molecule,Oligomer,"ValidUploadArrayCardQ test forward primer 1 " <> $SessionUUID],
				Model[Molecule,Oligomer,"ValidUploadArrayCardQ test reverse primer 1 " <> $SessionUUID],
				Model[Molecule,Oligomer,"ValidUploadArrayCardQ test probe 1 " <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase all the created objects*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];
	)
];