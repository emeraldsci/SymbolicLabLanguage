(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*UploadResin*)


(* ::Subsubsection::Closed:: *)
(*UploadResin*)


DefineTests[
	UploadResin,
	{
		Example[{Basic, "Upload a new resin:"},
			UploadResin[
				"Test Resin 1 for UploadResin Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram
			],
			ObjectP[Model[Resin,"Test Resin 1 for UploadResin Unit Test"]]
		],
		
		Example[{Basic,"Upload multiple new resins:"},
			UploadResin[
				{"Test Resin 1 for UploadResin Unit Test","Test Resin 2 for UploadResin Unit Test"},
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram
			],
			{ObjectP[Model[Resin,"Test Resin 1 for UploadResin Unit Test"]],ObjectP[Model[Resin,"Test Resin 2 for UploadResin Unit Test"]]}
		],
		
		Example[{Additional,"Modify an existing resin:"},
			UploadResin[
				Model[Resin,"Test Resin 1 for UploadResin Unit Test"],
				Loading->5 Mole/Gram
			];
			Model[Resin,"Test Resin 1 for UploadResin Unit Test"][Loading],
			{Quantity[5.`, ("Moles")/("Grams")]} ,
			SetUp:>{
				UploadResin[
					"Test Resin 1 for UploadResin Unit Test",
					State->Solid,
					BiosafetyLevel->"BSL-1",
					Flammable->False,
					MSDSRequired->False,
					IncompatibleMaterials->{None},
					Loading->5 Mole/Gram
				]
			}
		],
		
		Example[{Options,Name,"Define a name for the resin:"},
			UploadResin[
				"New Test Resin 1 for UploadResin Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				Name->"Test Resin 1 for UploadResin Unit Test"
			];
			Model[Resin,"Test Resin 1 for UploadResin Unit Test"][Name],
			"Test Resin 1 for UploadResin Unit Test"
		],
		
		Example[{Options,Molecule,"Specify the chemical structure for the resin:"},
			UploadResin[
				"Test Resin 1 for UploadResin Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				Molecule->Molecule[{"N","H","H","H"},{Bond[{1,2},"Single"],Bond[{1,3},"Single"],Bond[{1,4},"Single"]}]
			];
			Model[Resin,"Test Resin 1 for UploadResin Unit Test"][Molecule],
			Molecule[{"N","H","H","H"},{Bond[{1,2},"Single"],Bond[{1,3},"Single"],Bond[{1,4},"Single"]}]
		],
		
		Example[{Options,DefaultSampleModel,"Specify the sample model that will be used when this resin is used in an experiment:"},
			UploadResin[
				"Test Resin 1 for UploadResin Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				DefaultSampleModel->Model[Sample,"Test Sample Model 1 for UploadResin Unit Test"]
			];
			Model[Resin,"Test Resin 1 for UploadResin Unit Test"][DefaultSampleModel],
			LinkP[Model[Sample,"Test Sample Model 1 for UploadResin Unit Test"]],
			SetUp:>{
				
				If[
					DatabaseMemberQ[Model[Sample,"Test Sample Model 1 for UploadResin Unit Test"]],
					EraseObject[Model[Sample,"Test Sample Model 1 for UploadResin Unit Test"],Force->True,Verbose->False]
				];
				
				UploadSampleModel[
					"Test Sample Model 1 for UploadResin Unit Test",
					Composition->{{100 VolumePercent,Model[Molecule,"Water"]}},
					Expires->False,
					DefaultStorageCondition->Model[StorageCondition,"Ambient Storage"],
					State->Liquid,
					BiosafetyLevel->"BSL-1",
					Flammable->False,
					MSDSRequired->False,
					IncompatibleMaterials->{None}
				]
			}
		],
		
		Example[{Options,Synonyms,"Specify the synonyms for a resin:"},
			UploadResin[
				"Test Resin 1 for UploadResin Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				Synonyms->{"Test Resin 1 for UploadResin Unit Test","Test Resin 2 for UploadResin Unit Test"}
			];
			Model[Resin,"Test Resin 1 for UploadResin Unit Test"][Synonyms],
			{"Test Resin 1 for UploadResin Unit Test","Test Resin 2 for UploadResin Unit Test"}
		],
		
		Example[{Options,CAS,"Specify the Chemical Abstracts Service (CAS) registry number for the resin:"},
			UploadResin[
				"Test Resin 1 for UploadResin Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				CAS->"7732-18-5"
			];
			Model[Resin,"Test Resin 1 for UploadResin Unit Test"][CAS],
			"7732-18-5"
		],
		
		Example[{Options,IUPAC,"Specify the International Union of Pure and Applied Chemistry (IUPAC) name for the resin:"},
			UploadResin[
				"Test Resin 1 for UploadResin Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				IUPAC->"Dichloromethane"
			];
			Model[Resin,"Test Resin 1 for UploadResin Unit Test"][IUPAC],
			"Dichloromethane"
		],
		
		Example[{Options,StructureImageFile,"Specify the StructureImageFile for the resin:"},
			UploadResin[
				"Test Resin 1 for UploadResin Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				StructureImageFile->Object[EmeraldCloudFile, "id:aXRlGn6D0KJm"]
			];
			Model[Resin,"Test Resin 1 for UploadResin Unit Test"][StructureImageFile],
			ObjectP[Object[EmeraldCloudFile]]
		],
		
		Example[{Options,State,"Specify the state of the resin:"},
			UploadResin[
				"Test Resin 1 for UploadResin Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram
			];
			Model[Resin,"Test Resin 1 for UploadResin Unit Test"][State],
			Solid
		],
		
		Example[{Options,ResinMaterial,"Specify the material of the resin:"},
			UploadResin[
				"Test Resin 1 for UploadResin Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				ResinMaterial->ControlledPoreGlass
			];
			Model[Resin,"Test Resin 1 for UploadResin Unit Test"][ResinMaterial],
			ControlledPoreGlass
		],
		
		Example[{Options,Linker,"Specify the linker structure of the resin:"},
			UploadResin[
				"Test Resin 1 for UploadResin Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				Linker->RinkAmide
			];
			Model[Resin,"Test Resin 1 for UploadResin Unit Test"][Linker],
			RinkAmide
		],
		
		Example[{Options,Loading,"Specify the active sites per weight of resin:"},
			UploadResin[
				"Test Resin 1 for UploadResin Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram
			];
			Model[Resin,"Test Resin 1 for UploadResin Unit Test"][Loading],
			{Quantity[5., ("Moles")/("Grams")]}
		],
		
		Example[{Options,ProtectingGroup,"Specify the protecting group of the resin:"},
			UploadResin[
				"Test Resin 1 for UploadResin Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				ProtectingGroup->Fmoc
			];
			Model[Resin,"Test Resin 1 for UploadResin Unit Test"][ProtectingGroup],
			Fmoc
		],
		
		Example[{Options,PreferredCleavageMethod,"Specify the method object containing the preferred parameters for cleaving synthesized strands from this resin:"},
			UploadResin[
				"Test Resin 1 for UploadResin Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				PreferredCleavageMethod->Object[Method,Cleavage,"id:jLq9jXvqmM8a"]
			];
			Model[Resin,"Test Resin 1 for UploadResin Unit Test"][PreferredCleavageMethod],
			LinkP[Object[Method,Cleavage,"id:jLq9jXvqmM8a"]]
		],
		
		Example[{Options,PostCouplingKaiserResult,"Specify the result of a Kaiser test following monomer download from this resin:"},
			UploadResin[
				"Test Resin 1 for UploadResin Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				PostCouplingKaiserResult->Negative
			];
			Model[Resin,"Test Resin 1 for UploadResin Unit Test"][PostCouplingKaiserResult],
			Negative
		],
		
		Example[{Options,PostCappingKaiserResult,"Specify the result of a Kaiser test following capping of downloaded resin:"},
			UploadResin[
				"Test Resin 1 for UploadResin Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				PostCappingKaiserResult->Positive
			];
			Model[Resin,"Test Resin 1 for UploadResin Unit Test"][PostCappingKaiserResult],
			Positive
		]
	},
	
	SetUp:>{
		Module[{objects},
			objects={Model[Resin,"Test Resin 1 for UploadResin Unit Test"],Model[Resin,"Test Resin 2 for UploadResin Unit Test"]};
			If[
				Or@@DatabaseMemberQ[objects],
				EraseObject[PickList[objects,DatabaseMemberQ[objects]],Force->True,Verbose->False]
			];
		]
	},
	
	TearDown:>{
		Module[{objects},
			objects={Model[Resin,"Test Resin 1 for UploadResin Unit Test"],Model[Resin,"Test Resin 2 for UploadResin Unit Test"]};
			If[
				Or@@DatabaseMemberQ[objects],
				EraseObject[PickList[objects,DatabaseMemberQ[objects]],Force->True,Verbose->False]
			];
		]
	}
];

DefineTests[
	UploadResinOptions,
	{
		Example[{Basic, "Upload a new resin:"},
			UploadResinOptions[
				"Test Resin 1 for UploadResinOptions Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram
			],
			_Grid
		],

		Example[{Basic,"Upload multiple new resins:"},
			UploadResinOptions[
				{"Test Resin 1 for UploadResinOptions Unit Test","Test Resin 2 for UploadResinOptions Unit Test"},
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram
			],
			_Grid
		],

		Example[{Options,Name,"Define a name for the resin:"},
			UploadResinOptions[
				"New Test Resin 1 for UploadResinOptions Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				Name->"Test Resin 1 for UploadResinOptions Unit Test"
			],
			_Grid
		],

		Example[{Options,Molecule,"Specify the chemical structure for the resin:"},
			UploadResinOptions[
				"Test Resin 1 for UploadResinOptions Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				Molecule->Molecule[{"N","H","H","H"},{Bond[{1,2},"Single"],Bond[{1,3},"Single"],Bond[{1,4},"Single"]}]
			],
			_Grid
		],

		Example[{Options,DefaultSampleModel,"Specify the sample model that will be used when this resin is used in an experiment:"},
			UploadResinOptions[
				"Test Resin 1 for UploadResinOptions Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				DefaultSampleModel->Model[Sample,"Test Sample Model 1 for UploadResinOptions Unit Test"]
			],
			_Grid,
			SetUp:>{

				If[
					DatabaseMemberQ[Model[Sample,"Test Sample Model 1 for UploadResinOptions Unit Test"]],
					EraseObject[Model[Sample,"Test Sample Model 1 for UploadResinOptions Unit Test"],Force->True,Verbose->False]
				];

				UploadSampleModel[
					"Test Sample Model 1 for UploadResinOptions Unit Test",
					Composition->{{100 VolumePercent,Model[Molecule,"Water"]}},
					Expires->False,
					DefaultStorageCondition->Model[StorageCondition,"Ambient Storage"],
					State->Liquid,
					BiosafetyLevel->"BSL-1",
					Flammable->False,
					MSDSRequired->False,
					IncompatibleMaterials->{None}
				]
			}
		],

		Example[{Options,Synonyms,"Specify the synonyms for a resin:"},
			UploadResinOptions[
				"Test Resin 1 for UploadResinOptions Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				Synonyms->{"Test Resin 1 for UploadResinOptions Unit Test","Test Resin 2 for UploadResinOptions Unit Test"}
			],
			_Grid
		],

		Example[{Options,CAS,"Specify the Chemical Abstracts Service (CAS) registry number for the resin:"},
			UploadResinOptions[
				"Test Resin 1 for UploadResinOptions Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				CAS->"7732-18-5"
			],
			_Grid
		],

		Example[{Options,IUPAC,"Specify the International Union of Pure and Applied Chemistry (IUPAC) name for the resin:"},
			UploadResinOptions[
				"Test Resin 1 for UploadResinOptions Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				IUPAC->"Dichloromethane"
			],
			_Grid
		],

		Example[{Options,StructureImageFile,"Specify the International Union of Pure and Applied Chemistry (IUPAC) name for the resin:"},
			UploadResinOptions[
				"Test Resin 1 for UploadResinOptions Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				StructureImageFile->"https://www.sigmaaldrich.com/deepweb/content/dam/sigma-aldrich/structure5/190/mfcd00003284.eps/_jcr_content/renditions/mfcd00003284-large.png"
			],
			_Grid
		],

		Example[{Options,State,"Specify the state of the resin:"},
			UploadResinOptions[
				"Test Resin 1 for UploadResinOptions Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram
			],
			_Grid
		],

		Example[{Options,ResinMaterial,"Specify the material of the resin:"},
			UploadResinOptions[
				"Test Resin 1 for UploadResinOptions Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				ResinMaterial->ControlledPoreGlass
			],
			_Grid
		],

		Example[{Options,Linker,"Specify the linker structure of the resin:"},
			UploadResinOptions[
				"Test Resin 1 for UploadResinOptions Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				Linker->RinkAmide
			],
			_Grid
		],

		Example[{Options,Loading,"Specify the active sites per weight of resin:"},
			UploadResinOptions[
				"Test Resin 1 for UploadResinOptions Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram
			],
			_Grid
		],

		Example[{Options,ProtectingGroup,"Specify the protecting group of the resin:"},
			UploadResinOptions[
				"Test Resin 1 for UploadResinOptions Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				ProtectingGroup->Fmoc
			],
			_Grid
		],

		Example[{Options,PreferredCleavageMethod,"Specify the method object containing the preferred parameters for cleaving synthesized strands from this resin:"},
			UploadResinOptions[
				"Test Resin 1 for UploadResinOptions Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				PreferredCleavageMethod->Object[Method,Cleavage,"id:jLq9jXvqmM8a"]
			],
			_Grid
		],

		Example[{Options,PostCouplingKaiserResult,"Specify the result of a Kaiser test following monomer download from this resin:"},
			UploadResinOptions[
				"Test Resin 1 for UploadResinOptions Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				PostCouplingKaiserResult->Negative
			],
			_Grid
		],

		Example[{Options,PostCappingKaiserResult,"Specify the result of a Kaiser test following capping of downloaded resin:"},
			UploadResinOptions[
				"Test Resin 1 for UploadResinOptions Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				PostCappingKaiserResult->Positive
			],
			_Grid
		]
	},

	SetUp:>{
		Module[{objects},
			objects={Model[Resin,"Test Resin 1 for UploadResinOptions Unit Test"],Model[Resin,"Test Resin 2 for UploadResinOptions Unit Test"]};
			If[
				Or@@DatabaseMemberQ[objects],
				EraseObject[PickList[objects,DatabaseMemberQ[objects]],Force->True,Verbose->False]
			];
		]
	},

	TearDown:>{
		Module[{objects},
			objects={Model[Resin,"Test Resin 1 for UploadResinOptions Unit Test"],Model[Resin,"Test Resin 2 for UploadResinOptions Unit Test"]};
			If[
				Or@@DatabaseMemberQ[objects],
				EraseObject[PickList[objects,DatabaseMemberQ[objects]],Force->True,Verbose->False]
			];
		]
	}
];

DefineTests[
	ValidUploadResinQ,
	{
		Example[{Basic, "Upload a new resin:"},
			ValidUploadResinQ[
				"Test Resin 1 for ValidUploadResinQ Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram
			],
			BooleanP
		],

		Example[{Basic,"Upload multiple new resins:"},
			ValidUploadResinQ[
				{"Test Resin 1 for ValidUploadResinQ Unit Test","Test Resin 2 for ValidUploadResinQ Unit Test"},
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram
			],
			BooleanP
		],

		Example[{Options,Name,"Define a name for the resin:"},
			ValidUploadResinQ[
				"New Test Resin 1 for ValidUploadResinQ Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				Name->"Test Resin 1 for ValidUploadResinQ Unit Test"
			],
			BooleanP
		],

		Example[{Options,Molecule,"Specify the chemical structure for the resin:"},
			ValidUploadResinQ[
				"Test Resin 1 for ValidUploadResinQ Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				Molecule->Molecule[{"N","H","H","H"},{Bond[{1,2},"Single"],Bond[{1,3},"Single"],Bond[{1,4},"Single"]}]
			],
			BooleanP
		],

		Example[{Options,DefaultSampleModel,"Specify the sample model that will be used when this resin is used in an experiment:"},
			ValidUploadResinQ[
				"Test Resin 1 for ValidUploadResinQ Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				DefaultSampleModel->Model[Sample,"Test Sample Model 1 for ValidUploadResinQ Unit Test"]
			],
			BooleanP,
			SetUp:>{

				If[
					DatabaseMemberQ[Model[Sample,"Test Sample Model 1 for ValidUploadResinQ Unit Test"]],
					EraseObject[Model[Sample,"Test Sample Model 1 for ValidUploadResinQ Unit Test"],Force->True,Verbose->False]
				];

				UploadSampleModel[
					"Test Sample Model 1 for ValidUploadResinQ Unit Test",
					Composition->{{100 VolumePercent,Model[Molecule,"Water"]}},
					Expires->False,
					DefaultStorageCondition->Model[StorageCondition,"Ambient Storage"],
					State->Liquid,
					BiosafetyLevel->"BSL-1",
					Flammable->False,
					MSDSRequired->False,
					IncompatibleMaterials->{None}
				]
			}
		],

		Example[{Options,Synonyms,"Specify the synonyms for a resin:"},
			ValidUploadResinQ[
				"Test Resin 1 for ValidUploadResinQ Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				Synonyms->{"Test Resin 1 for ValidUploadResinQ Unit Test","Test Resin 2 for ValidUploadResinQ Unit Test"}
			],
			BooleanP
		],

		Example[{Options,CAS,"Specify the Chemical Abstracts Service (CAS) registry number for the resin:"},
			ValidUploadResinQ[
				"Test Resin 1 for ValidUploadResinQ Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				CAS->"7732-18-5"
			],
			BooleanP
		],

		Example[{Options,IUPAC,"Specify the International Union of Pure and Applied Chemistry (IUPAC) name for the resin:"},
			ValidUploadResinQ[
				"Test Resin 1 for ValidUploadResinQ Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				IUPAC->"Dichloromethane"
			],
			BooleanP
		],

		Example[{Options,StructureImageFile,"Specify the International Union of Pure and Applied Chemistry (IUPAC) name for the resin:"},
			ValidUploadResinQ[
				"Test Resin 1 for ValidUploadResinQ Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				StructureImageFile->"https://www.sigmaaldrich.com/deepweb/content/dam/sigma-aldrich/structure5/190/mfcd00003284.eps/_jcr_content/renditions/mfcd00003284-large.png"
			],
			BooleanP
		],

		Example[{Options,State,"Specify the state of the resin:"},
			ValidUploadResinQ[
				"Test Resin 1 for ValidUploadResinQ Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram
			],
			BooleanP
		],

		Example[{Options,ResinMaterial,"Specify the material of the resin:"},
			ValidUploadResinQ[
				"Test Resin 1 for ValidUploadResinQ Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				ResinMaterial->ControlledPoreGlass
			],
			BooleanP
		],

		Example[{Options,Linker,"Specify the linker structure of the resin:"},
			ValidUploadResinQ[
				"Test Resin 1 for ValidUploadResinQ Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				Linker->RinkAmide
			],
			BooleanP
		],

		Example[{Options,Loading,"Specify the active sites per weight of resin:"},
			ValidUploadResinQ[
				"Test Resin 1 for ValidUploadResinQ Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram
			],
			BooleanP
		],

		Example[{Options,ProtectingGroup,"Specify the protecting group of the resin:"},
			ValidUploadResinQ[
				"Test Resin 1 for ValidUploadResinQ Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				ProtectingGroup->Fmoc
			],
			BooleanP
		],

		Example[{Options,PreferredCleavageMethod,"Specify the method object containing the preferred parameters for cleaving synthesized strands from this resin:"},
			ValidUploadResinQ[
				"Test Resin 1 for ValidUploadResinQ Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				PreferredCleavageMethod->Object[Method,Cleavage,"id:jLq9jXvqmM8a"]
			],
			BooleanP
		],

		Example[{Options,PostCouplingKaiserResult,"Specify the result of a Kaiser test following monomer download from this resin:"},
			ValidUploadResinQ[
				"Test Resin 1 for ValidUploadResinQ Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				PostCouplingKaiserResult->Negative
			],
			BooleanP
		],

		Example[{Options,PostCappingKaiserResult,"Specify the result of a Kaiser test following capping of downloaded resin:"},
			ValidUploadResinQ[
				"Test Resin 1 for ValidUploadResinQ Unit Test",
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Loading->5 Mole/Gram,
				PostCappingKaiserResult->Positive
			],
			BooleanP
		]
	},

	SetUp:>{
		Module[{objects},
			objects={Model[Resin,"Test Resin 1 for ValidUploadResinQ Unit Test"],Model[Resin,"Test Resin 2 for ValidUploadResinQ Unit Test"]};
			If[
				Or@@DatabaseMemberQ[objects],
				EraseObject[PickList[objects,DatabaseMemberQ[objects]],Force->True,Verbose->False]
			];
		]
	},

	TearDown:>{
		Module[{objects},
			objects={Model[Resin,"Test Resin 1 for ValidUploadResinQ Unit Test"],Model[Resin,"Test Resin 2 for ValidUploadResinQ Unit Test"]};
			If[
				Or@@DatabaseMemberQ[objects],
				EraseObject[PickList[objects,DatabaseMemberQ[objects]],Force->True,Verbose->False]
			];
		]
	}
];