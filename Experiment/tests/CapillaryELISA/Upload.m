(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*UploadCapillaryELISACartridge*)


(* ::Subsubsection:: *)
(*UploadCapillaryELISACartridge*)


DefineTests[UploadCapillaryELISACartridge,
	{
		Example[{Basic,"Create a model for a new SinglePlex72X1 capillary ELISA cartridge from an identity model:"},
			UploadCapillaryELISACartridge[
				Model[Molecule,Protein,"UploadCapillaryELISACartridge test pre-loaded analyte 5" <> $SessionUUID]
			],
			ObjectP[Model[Container,Plate,Irregular,CapillaryELISA]]
		],
		Example[{Basic,"Create a model for a new SinglePlex72X1 capillary ELISA cartridge:"},
			UploadCapillaryELISACartridge[
				"Mesothelin"
			],
			ObjectP[Model[Container,Plate,Irregular,CapillaryELISA]]
		],
		Example[{Additional,"Create a model for a new MultiAnalyte32X4 capillary ELISA cartridge from identity models:"},
			UploadCapillaryELISACartridge[
				{
					Model[Molecule,Protein,"UploadCapillaryELISACartridge test pre-loaded analyte 4" <> $SessionUUID],
					Model[Molecule,Protein,"UploadCapillaryELISACartridge test pre-loaded analyte 5" <> $SessionUUID],
					Model[Molecule,Protein,"UploadCapillaryELISACartridge test pre-loaded analyte 6" <> $SessionUUID],
					Model[Molecule,Protein,"UploadCapillaryELISACartridge test pre-loaded analyte 7" <> $SessionUUID]
				}
			],
			ObjectP[Model[Container,Plate,Irregular,CapillaryELISA]]
		],
		Example[{Additional,"Create a model for a new MultiPlex32X8 capillary ELISA cartridge from analyte names:"},
			UploadCapillaryELISACartridge[
				{"M-CSF","MAdCAM-1","MCP-1/CCL2","MCP-2/CCL8","MCP-3/CCL7","MDC/CCL22","Mesothelin","MICA"}
			],
			ObjectP[Model[Container,Plate,Irregular,CapillaryELISA]]
		],
		Example[{Additional,"The created cartridge model is valid:"},
			cartridge=UploadCapillaryELISACartridge[
				{"MIF","MAdCAM-1","MCP-1/CCL2","MCP-2/CCL8","MCP-3/CCL7","MDC/CCL22","Mesothelin","MICA"}
			];
			ValidObjectQ[cartridge],
			True,
			Variables:>{cartridge}
		],
		Example[{Options,CartridgeType,"The CartridgeType option can be used to select the type of capillary ELISA cartridge:"},
			cartridge=UploadCapillaryELISACartridge[
				{
					Model[Molecule,Protein,"UploadCapillaryELISACartridge test pre-loaded analyte 4" <> $SessionUUID],
					Model[Molecule,Protein,"UploadCapillaryELISACartridge test pre-loaded analyte 5" <> $SessionUUID],
					Model[Molecule,Protein,"UploadCapillaryELISACartridge test pre-loaded analyte 6" <> $SessionUUID],
					Model[Molecule,Protein,"UploadCapillaryELISACartridge test pre-loaded analyte 8" <> $SessionUUID]
				},
				CartridgeType->MultiAnalyte16X4
			];
			Download[cartridge,CartridgeType],
			MultiAnalyte16X4,
			Variables:>{cartridge}
		],
		Example[{Options,Species,"The Species option can be specified to select the organism of samples for this cartridge:"},
			UploadCapillaryELISACartridge[
				Model[Molecule,Protein,"UploadCapillaryELISACartridge test pre-loaded analyte 6" <> $SessionUUID],
				Species->Human
			],
			ObjectP[Model[Container,Plate,Irregular,CapillaryELISA]]
		],
		Example[{Messages,"CapillaryELISACartridgeExist","Returns the existing cartridge model from an analyte molecule if it is already available:"},
			UploadCapillaryELISACartridge[
				"M-CSF"
			],
			ObjectP[Model[Container,Plate,Irregular,CapillaryELISA,"UploadCapillaryELISACartridge SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 1" <> $SessionUUID]],
			Messages:>{
				Warning::CapillaryELISACartridgeExist
			}
		],
		Example[{Messages,"CapillaryELISACartridgeExist","Returns the existing cartridge model from an analyte name if it is already available:"},
			UploadCapillaryELISACartridge[
				Model[Molecule,Protein,"UploadCapillaryELISACartridge test pre-loaded analyte 2" <> $SessionUUID]
			],
			ObjectP[Model[Container,Plate,Irregular,CapillaryELISA,"UploadCapillaryELISACartridge SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 2" <> $SessionUUID]],
			Messages:>{
				Warning::CapillaryELISACartridgeExist
			}
		],
		Example[{Messages,"CapillaryELISACartridgeExist","Returns the existing MultiAnalyte32X4 cartridge model from analyte names if it is already available:"},
			UploadCapillaryELISACartridge[
				{"M-CSF","MAdCAM-1","MCP-1/CCL2","MCP-2/CCL8"}
			],
			ObjectP[Model[Container,Plate,Irregular,CapillaryELISA,"UploadCapillaryELISACartridge MultiAnalyte32X4 test pre-loaded cartridge model for pre-loaded analytes 1, 2, 3 and 4" <> $SessionUUID]],
			Messages:>{
				Warning::CapillaryELISACartridgeExist
			}
		],
		Test["Ensure that DeveloperObject -> True for created objects when $UploadCapillaryELISACartridgeAsDeveloperObject is True:",
			packets = UploadCapillaryELISACartridge[
				Model[Molecule,Protein,"UploadCapillaryELISACartridge test pre-loaded analyte 5" <> $SessionUUID],
				Upload -> False
			];
			Lookup[First[packets], DeveloperObject, Null],
			True,
			Variables :> {packets},
			Stubs :> {$UploadCapillaryELISACartridgeAsDeveloperObject = True}
		],
		Test["Ensure that DeveloperObject -> Null for created objects when $UploadCapillaryELISACartridgeAsDeveloperObject is False:",
			packets = UploadCapillaryELISACartridge[
				Model[Molecule,Protein,"UploadCapillaryELISACartridge test pre-loaded analyte 5" <> $SessionUUID],
				Upload -> False
			];
			Lookup[First[packets], DeveloperObject, Null],
			Null,
			Variables :> {packets},
			Stubs :> {$UploadCapillaryELISACartridgeAsDeveloperObject = False}
		]
	},
	SetUp:>($CreatedObjects={}),
	TearDown:>(
		(* doing this because a primary cause of flaky tests is these Irregular plates showing up momentarily in other searches, and then them subsequently trying to Download from them but you can't because they've been erased already.  So just don't erase them and it'll be fine *)
		(* don't want to step on toes though so names need to be cleared out *)
		EraseObject[DeleteCases[$CreatedObjects, ObjectP[Model[Container, Plate, Irregular]]],Force->True,Verbose->False];
		Upload[<|Object -> #, Name -> Null|>& /@ Cases[$CreatedObjects, ObjectP[Model[Container, Plate, Irregular]]]];
		Unset[$CreatedObjects]
	),
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"],
		(* this stub makes sure everything that is uploaded is a DeveloperObject so it doesn't mess other searches up *)
		$UploadCapillaryELISACartridgeAsDeveloperObject = True,
		(* this stubs makes DeveloperObject == True a condition in all searches *)
		$DeveloperSearch = True,
		$RequiredSearchName = $SessionUUID
	},
	SymbolSetUp:>(

		Module[{notTornDownObjects,allObjects, existingObjects},

			(* Search for the object we create in the test "The created cartridge model is valid". We can get NonUniqueName errors if this object was *)
			(* not properly erased by the previous test *)
			notTornDownObjects = Search[
				{
					Model[Container, Plate, Irregular, CapillaryELISA],
					Object[Product, CapillaryELISACartridge]
				},
				{
					StringContainsQ[Name, "Human MIF MAdCAM-1 MCP-1/CCL2 MCP-2/CCL8 MCP-3/CCL7 MDC/CCL22 Mesothelin MICA MultiPlex32X8 Cartridge"] && DeveloperObject == True,
					StringContainsQ[Name, "Human MIF MAdCAM-1 MCP-1/CCL2 MCP-2/CCL8 MCP-3/CCL7 MDC/CCL22 Mesothelin MICA MultiPlex32X8 Cartridge Kit"] && DeveloperObject == True
				}
			];
			
			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects=Cases[
				Flatten[
					{
						(* Pre-loaded Analytes *)
						Model[Molecule,Protein,"UploadCapillaryELISACartridge test pre-loaded analyte 1" <> $SessionUUID],
						Model[Molecule,Protein,"UploadCapillaryELISACartridge test pre-loaded analyte 2" <> $SessionUUID],
						Model[Molecule,Protein,"UploadCapillaryELISACartridge test pre-loaded analyte 3" <> $SessionUUID],
						Model[Molecule,Protein,"UploadCapillaryELISACartridge test pre-loaded analyte 4" <> $SessionUUID],
						Model[Molecule,Protein,"UploadCapillaryELISACartridge test pre-loaded analyte 5" <> $SessionUUID],
						Model[Molecule,Protein,"UploadCapillaryELISACartridge test pre-loaded analyte 6" <> $SessionUUID],
						Model[Molecule,Protein,"UploadCapillaryELISACartridge test pre-loaded analyte 7" <> $SessionUUID],
						Model[Molecule,Protein,"UploadCapillaryELISACartridge test pre-loaded analyte 8" <> $SessionUUID],
						Model[Molecule,Protein,"UploadCapillaryELISACartridge test pre-loaded analyte 9" <> $SessionUUID],
						Model[Molecule,Protein,"UploadCapillaryELISACartridge test pre-loaded analyte 10" <> $SessionUUID],
						Model[Molecule,Protein,"UploadCapillaryELISACartridge test pre-loaded analyte 11" <> $SessionUUID],

						(* Manufacturing Specifications *)
						Object[ManufacturingSpecification,CapillaryELISACartridge,"UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 1" <> $SessionUUID],
						Object[ManufacturingSpecification,CapillaryELISACartridge,"UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 2" <> $SessionUUID],
						Object[ManufacturingSpecification,CapillaryELISACartridge,"UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 3" <> $SessionUUID],
						Object[ManufacturingSpecification,CapillaryELISACartridge,"UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 4" <> $SessionUUID],
						Object[ManufacturingSpecification,CapillaryELISACartridge,"UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 5" <> $SessionUUID],
						Object[ManufacturingSpecification,CapillaryELISACartridge,"UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 6" <> $SessionUUID],
						Object[ManufacturingSpecification,CapillaryELISACartridge,"UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 7" <> $SessionUUID],
						Object[ManufacturingSpecification,CapillaryELISACartridge,"UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 8" <> $SessionUUID],
						Object[ManufacturingSpecification,CapillaryELISACartridge,"UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 9" <> $SessionUUID],
						Object[ManufacturingSpecification,CapillaryELISACartridge,"UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 10" <> $SessionUUID],
						Object[ManufacturingSpecification,CapillaryELISACartridge,"UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 11" <> $SessionUUID],
						Object[ManufacturingSpecification,CapillaryELISACartridge,"UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 12" <> $SessionUUID],
						Object[ManufacturingSpecification,CapillaryELISACartridge,"UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 13" <> $SessionUUID],

						(* Cartridge Object *)
						(* Create several pre-loaded cartridges so that they can be searched in our resolver using DeveloperSearch *)
						Model[Container,Plate,Irregular,CapillaryELISA,"UploadCapillaryELISACartridge SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 1" <> $SessionUUID],
						Model[Container,Plate,Irregular,CapillaryELISA,"UploadCapillaryELISACartridge SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 2" <> $SessionUUID],
						Model[Container,Plate,Irregular,CapillaryELISA,"UploadCapillaryELISACartridge MultiAnalyte32X4 test pre-loaded cartridge model for pre-loaded analytes 1, 2, 3 and 4" <> $SessionUUID],

						(* Reagent Models *)
						Model[Sample,"UploadCapillaryELISACartridge test diluent model 1" <> $SessionUUID],
						Model[Sample,"UploadCapillaryELISACartridge test diluent model 2" <> $SessionUUID],

						notTornDownObjects
					}
				],
				ObjectP[]
			];

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]

		];

		Block[{$AllowSystemsProtocols=True},
			Module[
				{
					testDiluentModel1,testDiluentModel2,
					preloadedAnalyte1,preloadedAnalyte2,preloadedAnalyte3,preloadedAnalyte4,preloadedAnalyte5,preloadedAnalyte6,preloadedAnalyte7,preloadedAnalyte8,preloadedAnalyte9,preloadedAnalyte10,preloadedAnalyte11,
					preloadedAnalyteManufacturingSpecification1,preloadedAnalyteManufacturingSpecification2,preloadedAnalyteManufacturingSpecification3,preloadedAnalyteManufacturingSpecification4,preloadedAnalyteManufacturingSpecification5,preloadedAnalyteManufacturingSpecification6,preloadedAnalyteManufacturingSpecification7,preloadedAnalyteManufacturingSpecification8,preloadedAnalyteManufacturingSpecification9,preloadedAnalyteManufacturingSpecification10,preloadedAnalyteManufacturingSpecification11,preloadedAnalyteManufacturingSpecification12,preloadedAnalyteManufacturingSpecification13,
					cartridgeModel1,cartridgeModel2,cartridgeModel3,
					allDeveloperObjects
				},

				(* Make the diluent models *)
				testDiluentModel1=Upload[
					<|
						Type->Model[Sample],
						Name->"UploadCapillaryELISACartridge test diluent model 1" <> $SessionUUID,
						DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
						State->Liquid
					|>
				];
				testDiluentModel2=Upload[
					<|
						Type->Model[Sample],
						Name->"UploadCapillaryELISACartridge test diluent model 2" <> $SessionUUID,
						DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
						State->Liquid
					|>
				];


				(* Make some analytes *)
				{
					preloadedAnalyte1,
					preloadedAnalyte2,
					preloadedAnalyte3,
					preloadedAnalyte4,
					preloadedAnalyte5,
					preloadedAnalyte6,
					preloadedAnalyte7,
					preloadedAnalyte8,
					preloadedAnalyte9,
					preloadedAnalyte10,
					preloadedAnalyte11
				}=UploadProtein[
					{
						"UploadCapillaryELISACartridge test pre-loaded analyte 1" <> $SessionUUID,
						"UploadCapillaryELISACartridge test pre-loaded analyte 2" <> $SessionUUID,
						"UploadCapillaryELISACartridge test pre-loaded analyte 3" <> $SessionUUID,
						"UploadCapillaryELISACartridge test pre-loaded analyte 4" <> $SessionUUID,
						"UploadCapillaryELISACartridge test pre-loaded analyte 5" <> $SessionUUID,
						"UploadCapillaryELISACartridge test pre-loaded analyte 6" <> $SessionUUID,
						"UploadCapillaryELISACartridge test pre-loaded analyte 7" <> $SessionUUID,
						"UploadCapillaryELISACartridge test pre-loaded analyte 8" <> $SessionUUID,
						"UploadCapillaryELISACartridge test pre-loaded analyte 9" <> $SessionUUID,
						"UploadCapillaryELISACartridge test pre-loaded analyte 10" <> $SessionUUID,
						"UploadCapillaryELISACartridge test pre-loaded analyte 11" <> $SessionUUID
					},
					State->Solid,
					BiosafetyLevel->"BSL-1",
					Flammable->False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials->{None},
					ExpirationHazard->False
				];

				(* Make Manufacturing Specifications *)
				{
					preloadedAnalyteManufacturingSpecification1,
					preloadedAnalyteManufacturingSpecification2,
					preloadedAnalyteManufacturingSpecification3,
					preloadedAnalyteManufacturingSpecification4,
					preloadedAnalyteManufacturingSpecification5,
					preloadedAnalyteManufacturingSpecification6,
					preloadedAnalyteManufacturingSpecification7,
					preloadedAnalyteManufacturingSpecification8,
					preloadedAnalyteManufacturingSpecification9
				}=MapThread[
					Upload[
						<|
							Type->Object[ManufacturingSpecification,CapillaryELISACartridge],
							Name->#1,
							AnalyteName->#2,
							AnalyteMolecule->Link[#3],
							Replace[CartridgeType]->{SinglePlex72X1,MultiAnalyte16X4,MultiAnalyte32X4,MultiPlex32X8},
							Species->Human,
							RecommendedMinDilutionFactor->0.5,
							RecommendedDiluent->Link[Model[Sample,"UploadCapillaryELISACartridge test diluent model 1" <> $SessionUUID]],
							UpperQuantitationLimit->4000Picogram/Milliliter,
							LowerQuantitationLimit->1Picogram/Milliliter
						|>
					]&,
					{
						{
							"UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 1" <> $SessionUUID,
							"UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 2" <> $SessionUUID,
							"UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 3" <> $SessionUUID,
							"UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 4" <> $SessionUUID,
							"UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 5" <> $SessionUUID,
							"UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 6" <> $SessionUUID,
							"UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 7" <> $SessionUUID,
							"UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 8" <> $SessionUUID,
							(* This is a repeated analyte manufacturing specification *)
							"UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 9" <> $SessionUUID
						},
						(* We have to randomly select some analyte names for our fake manufacturing specifications *)
						{"M-CSF","MAdCAM-1","MCP-1/CCL2","MCP-2/CCL8","MCP-3/CCL7","MDC/CCL22","Mesothelin","MICA","MIF"},
						{
							preloadedAnalyte1,
							preloadedAnalyte2,
							preloadedAnalyte3,
							preloadedAnalyte4,
							preloadedAnalyte5,
							preloadedAnalyte6,
							preloadedAnalyte7,
							preloadedAnalyte8,
							preloadedAnalyte1
						}
					}
				];

				(* For the wrong CartridgeType test *)
				preloadedAnalyteManufacturingSpecification10=Upload[
					<|
						Type->Object[ManufacturingSpecification,CapillaryELISACartridge],
						Name->"UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 10" <> $SessionUUID,
						AnalyteName->"MIG/CXCL9",
						AnalyteMolecule->Link[preloadedAnalyte9],
						Replace[CartridgeType]->{SinglePlex72X1,MultiAnalyte16X4,MultiAnalyte32X4},
						Species->Human,
						RecommendedMinDilutionFactor->0.5,
						RecommendedDiluent->Link[Model[Sample,"UploadCapillaryELISACartridge test diluent model 1" <> $SessionUUID]],
						UpperQuantitationLimit->4000Picogram/Milliliter,
						LowerQuantitationLimit->1Picogram/Milliliter
					|>
				];
				(* For the non-compatible min dilution factor test *)
				preloadedAnalyteManufacturingSpecification11=Upload[
					<|
						Type->Object[ManufacturingSpecification,CapillaryELISACartridge],
						Name->"UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 11" <> $SessionUUID,
						AnalyteName->"MMP-1",
						AnalyteMolecule->Link[preloadedAnalyte10],
						Replace[CartridgeType]->{SinglePlex72X1,MultiAnalyte16X4,MultiAnalyte32X4,MultiPlex32X8},
						Species->Human,
						RecommendedMinDilutionFactor->0.1,
						RecommendedDiluent->Link[Model[Sample,"UploadCapillaryELISACartridge test diluent model 1" <> $SessionUUID]],
						UpperQuantitationLimit->4000Picogram/Milliliter,
						LowerQuantitationLimit->1Picogram/Milliliter
					|>
				];
				(* For the non-compatible diluent test *)
				preloadedAnalyteManufacturingSpecification12=Upload[
					<|
						Type->Object[ManufacturingSpecification,CapillaryELISACartridge],
						Name->"UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 12" <> $SessionUUID,
						AnalyteName->"MMP-7",
						AnalyteMolecule->Link[preloadedAnalyte11],
						Replace[CartridgeType]->{SinglePlex72X1,MultiAnalyte16X4,MultiAnalyte32X4,MultiPlex32X8},
						Species->Human,
						RecommendedMinDilutionFactor->0.5,
						RecommendedDiluent->Link[Model[Sample,"UploadCapillaryELISACartridge test diluent model 2" <> $SessionUUID]],
						UpperQuantitationLimit->4000Picogram/Milliliter,
						LowerQuantitationLimit->1Picogram/Milliliter
					|>
				];
				(* Incompatible Analyte *)
				preloadedAnalyteManufacturingSpecification13=Upload[
					<|
						Type->Object[ManufacturingSpecification,CapillaryELISACartridge],
						Name->"UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 13" <> $SessionUUID,
						AnalyteName->"CA9",
						AnalyteMolecule->Link[preloadedAnalyte8],
						Replace[CartridgeType]->{SinglePlex72X1,MultiAnalyte16X4,MultiAnalyte32X4,MultiPlex32X8},
						Species->Human,
						RecommendedMinDilutionFactor->0.5,
						RecommendedDiluent->Link[Model[Sample,"UploadCapillaryELISACartridge test diluent model 1" <> $SessionUUID]],
						Replace[IncompatibleAnalytes]->{Link[preloadedAnalyteManufacturingSpecification7,IncompatibleAnalytes]},
						UpperQuantitationLimit->4000Picogram/Milliliter,
						LowerQuantitationLimit->1Picogram/Milliliter
					|>
				];

				(* Make Cartridges *)
				cartridgeModel1=Upload[
					<|
						Type->Model[Container,Plate,Irregular,CapillaryELISA],
						Name->"UploadCapillaryELISACartridge SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 1" <> $SessionUUID,
						Replace[AnalyteNames]->{"M-CSF"},
						Replace[AnalyteMolecules]->{Link[preloadedAnalyte1]},
						MaxNumberOfSamples->72,
						CartridgeType->SinglePlex72X1,
						MinBufferVolume->10.0Milliliter,
						MaxCentrifugationForce -> 0 GravitationalAcceleration
					|>
				];

				cartridgeModel2=Upload[
					<|
						Type->Model[Container,Plate,Irregular,CapillaryELISA],
						Name->"UploadCapillaryELISACartridge MultiAnalyte32X4 test pre-loaded cartridge model for pre-loaded analytes 1, 2, 3 and 4" <> $SessionUUID,
						Replace[AnalyteNames]->{"M-CSF","MAdCAM-1","MCP-1/CCL2","MCP-2/CCL8"},
						Replace[AnalyteMolecules]->{Link[preloadedAnalyte1],Link[preloadedAnalyte2],Link[preloadedAnalyte3],Link[preloadedAnalyte4]},
						MaxNumberOfSamples->32,
						CartridgeType->MultiAnalyte32X4,
						MinBufferVolume->16.0Milliliter,
						MaxCentrifugationForce -> 0 GravitationalAcceleration
					|>
				];

				(* long lead time warning *)
				cartridgeModel3=Upload[
					<|
						Type->Model[Container,Plate,Irregular,CapillaryELISA],
						Name->"UploadCapillaryELISACartridge SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 2" <> $SessionUUID,
						Replace[AnalyteNames]->{"MAdCAM-1"},
						Replace[AnalyteMolecules]->{Link[preloadedAnalyte2]},
						MaxNumberOfSamples->72,
						CartridgeType->SinglePlex72X1,
						MinBufferVolume->10.0Milliliter,
						MaxCentrifugationForce -> 0 GravitationalAcceleration
					|>
				];

				(* Get all objects so we can make sure they are developer objects *)
				allDeveloperObjects=Cases[
					Flatten[
						{
							testDiluentModel1,testDiluentModel2,
							preloadedAnalyte1,preloadedAnalyte2,preloadedAnalyte3,preloadedAnalyte4,preloadedAnalyte5,preloadedAnalyte6,preloadedAnalyte7,preloadedAnalyte8,preloadedAnalyte9,preloadedAnalyte10,preloadedAnalyte11,
							preloadedAnalyteManufacturingSpecification1,preloadedAnalyteManufacturingSpecification2,preloadedAnalyteManufacturingSpecification3,preloadedAnalyteManufacturingSpecification4,preloadedAnalyteManufacturingSpecification5,preloadedAnalyteManufacturingSpecification6,preloadedAnalyteManufacturingSpecification7,preloadedAnalyteManufacturingSpecification8,preloadedAnalyteManufacturingSpecification9,preloadedAnalyteManufacturingSpecification10,preloadedAnalyteManufacturingSpecification11,preloadedAnalyteManufacturingSpecification12,preloadedAnalyteManufacturingSpecification13,
							cartridgeModel1,cartridgeModel2,cartridgeModel3
						}
					],
					ObjectP[]
				];

				(* Make all the test objects and models developer objects *)
				(* There are several test objects  *)
				Upload[<|Object->#,DeveloperObject->True|>&/@allDeveloperObjects];

			]
		]

	),
	SymbolTearDown:> (
		Module[{allObjects, existingObjects},

			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects = Cases[
				Flatten[
					{
						(* Pre-loaded Analytes *)
						Model[Molecule, Protein, "UploadCapillaryELISACartridge test pre-loaded analyte 1" <> $SessionUUID],
						Model[Molecule, Protein, "UploadCapillaryELISACartridge test pre-loaded analyte 2" <> $SessionUUID],
						Model[Molecule, Protein, "UploadCapillaryELISACartridge test pre-loaded analyte 3" <> $SessionUUID],
						Model[Molecule, Protein, "UploadCapillaryELISACartridge test pre-loaded analyte 4" <> $SessionUUID],
						Model[Molecule, Protein, "UploadCapillaryELISACartridge test pre-loaded analyte 5" <> $SessionUUID],
						Model[Molecule, Protein, "UploadCapillaryELISACartridge test pre-loaded analyte 6" <> $SessionUUID],
						Model[Molecule, Protein, "UploadCapillaryELISACartridge test pre-loaded analyte 7" <> $SessionUUID],
						Model[Molecule, Protein, "UploadCapillaryELISACartridge test pre-loaded analyte 8" <> $SessionUUID],
						Model[Molecule, Protein, "UploadCapillaryELISACartridge test pre-loaded analyte 9" <> $SessionUUID],
						Model[Molecule, Protein, "UploadCapillaryELISACartridge test pre-loaded analyte 10" <> $SessionUUID],
						Model[Molecule, Protein, "UploadCapillaryELISACartridge test pre-loaded analyte 11" <> $SessionUUID],

						(* Manufacturing Specifications *)
						Object[ManufacturingSpecification, CapillaryELISACartridge, "UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 1" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 2" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 3" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 4" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 5" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 6" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 7" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 8" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 9" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 10" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 11" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 12" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "UploadCapillaryELISACartridge test pre-loaded analyte manufacturing specification 13" <> $SessionUUID],

						(* Cartridge Object *)
						(* Create several pre-loaded cartridges so that they can be searched in our resolver using DeveloperSearch *)
						Model[Container, Plate, Irregular, CapillaryELISA, "UploadCapillaryELISACartridge SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 1" <> $SessionUUID],
						Model[Container, Plate, Irregular, CapillaryELISA, "UploadCapillaryELISACartridge SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 2" <> $SessionUUID],
						Model[Container, Plate, Irregular, CapillaryELISA, "UploadCapillaryELISACartridge MultiAnalyte32X4 test pre-loaded cartridge model for pre-loaded analytes 1, 2, 3 and 4" <> $SessionUUID],

						(* Reagent Models *)
						Model[Sample, "UploadCapillaryELISACartridge test diluent model 1" <> $SessionUUID],
						Model[Sample, "UploadCapillaryELISACartridge test diluent model 2" <> $SessionUUID]

					}
				],
				ObjectP[]
			];

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]

		];
	)
];




(* ::Subsection:: *)
(*ValidUploadCapillaryELISACartridgeQ*)


(* ::Subsubsection:: *)
(*ValidUploadCapillaryELISACartridgeQ*)


DefineTests[ValidUploadCapillaryELISACartridgeQ,
	{
		Example[{Basic,"Returns a Boolean indicating the validity of a capillary ELISA experiment with a customizable cartridge:"},
			ValidUploadCapillaryELISACartridgeQ[
				Model[Molecule,Protein,"ValidUploadCapillaryELISACartridgeQ test pre-loaded analyte 2" <> $SessionUUID]
			],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidUploadCapillaryELISACartridgeQ[
				Model[Molecule,Protein,"ValidUploadCapillaryELISACartridgeQ test pre-loaded analyte 1" <> $SessionUUID]
			],
			False
		],
		Example[{Options,Verbose,"If Verbose -> True, returns the passing and failing tests:"},
			ValidUploadCapillaryELISACartridgeQ[
				Model[Molecule,Protein,"ValidUploadCapillaryELISACartridgeQ test pre-loaded analyte 2" <> $SessionUUID],
				Verbose->True
			],
			True
		],
		Example[{Options,OutputFormat,"If OutputFormat -> TestSummary, returns a test summary instead of a Boolean:"},
			ValidUploadCapillaryELISACartridgeQ[
				Model[Molecule,Protein,"ValidUploadCapillaryELISACartridgeQ test pre-loaded analyte 2" <> $SessionUUID],
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary
		]
	},

	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"],
		$DeveloperSearch=True,
		$RequiredSearchName = "ValidUploadCapillaryELISACartridgeQ"
	},
	SymbolSetUp:>{

		Module[{allObjects, existingObjects},

			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects=Cases[
				Flatten[
					{
						(* Pre-loaded Analytes *)
						Model[Molecule,Protein,"ValidUploadCapillaryELISACartridgeQ test pre-loaded analyte 1" <> $SessionUUID],
						Model[Molecule,Protein,"ValidUploadCapillaryELISACartridgeQ test pre-loaded analyte 2" <> $SessionUUID],

						(* Manufacturing Specifications *)
						Object[ManufacturingSpecification,CapillaryELISACartridge,"ValidUploadCapillaryELISACartridgeQ test pre-loaded analyte manufacturing specification 1" <> $SessionUUID],
						Object[ManufacturingSpecification,CapillaryELISACartridge,"ValidUploadCapillaryELISACartridgeQ test pre-loaded analyte manufacturing specification 2" <> $SessionUUID],

						(* Cartridge Object *)
						(* Create pre-loaded cartridges so that they can be searched in our resolver using DeveloperSearch *)
						Model[Container,Plate,Irregular,CapillaryELISA,"ValidUploadCapillaryELISACartridgeQ SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 1" <> $SessionUUID],

						(* Reagent Models *)
						Model[Sample,"ValidUploadCapillaryELISACartridgeQ test diluent model 1" <> $SessionUUID]
					}
				],
				ObjectP[]
			];

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]

		];

		Block[{$AllowSystemsProtocols=True},
			Module[
				{
					testDiluentModel1,
					preloadedAnalyte1,preloadedAnalyte2,
					preloadedAnalyteManufacturingSpecification1,preloadedAnalyteManufacturingSpecification2,
					cartridgeModel1,
					allDeveloperObjects
				},

				(* Make the diluent models *)
				testDiluentModel1=Upload[
					<|
						Type->Model[Sample],
						Name->"ValidUploadCapillaryELISACartridgeQ test diluent model 1" <> $SessionUUID,
						DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
						State->Liquid
					|>
				];

				(* Make some analytes *)
				{
					preloadedAnalyte1,
					preloadedAnalyte2
				}=UploadProtein[
					{
						"ValidUploadCapillaryELISACartridgeQ test pre-loaded analyte 1" <> $SessionUUID,
						"ValidUploadCapillaryELISACartridgeQ test pre-loaded analyte 2" <> $SessionUUID
					},
					State->Solid,
					BiosafetyLevel->"BSL-1",
					Flammable->False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials->{None},
					ExpirationHazard->False
				];

				(* Make Manufacturing Specifications *)
				{
					preloadedAnalyteManufacturingSpecification1,
					preloadedAnalyteManufacturingSpecification2
				}=MapThread[
					Upload[
						<|
							Type->Object[ManufacturingSpecification,CapillaryELISACartridge],
							Name->#1,
							AnalyteName->#2,
							AnalyteMolecule->Link[#3],
							Replace[CartridgeType]->{SinglePlex72X1,MultiAnalyte16X4,MultiAnalyte32X4,MultiPlex32X8},
							Species->Human,
							RecommendedMinDilutionFactor->0.5,
							RecommendedDiluent->Link[Model[Sample,"ValidUploadCapillaryELISACartridgeQ test diluent model 1" <> $SessionUUID]],
							UpperQuantitationLimit->4000Picogram/Milliliter,
							LowerQuantitationLimit->1Picogram/Milliliter
						|>
					]&,
					{
						{
							"ValidUploadCapillaryELISACartridgeQ test pre-loaded analyte manufacturing specification 1" <> $SessionUUID,
							"ValidUploadCapillaryELISACartridgeQ test pre-loaded analyte manufacturing specification 2" <> $SessionUUID
						},
						(* We have to randomly select some analyte names for our fake manufacturing specifications *)
						{"TREM-1","TREM-2"},
						{
							preloadedAnalyte1,
							preloadedAnalyte2
						}
					}
				];

				(* Make Cartridges *)
				cartridgeModel1=Upload[
					<|
						Type->Model[Container,Plate,Irregular,CapillaryELISA],
						Name->"ValidUploadCapillaryELISACartridgeQ SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 1" <> $SessionUUID,
						Replace[AnalyteNames]->{"TREM-1"},
						Replace[AnalyteMolecules]->{Link[preloadedAnalyte1]},
						MaxNumberOfSamples->72,
						CartridgeType->SinglePlex72X1,
						MinBufferVolume->10.0Milliliter,
						MaxCentrifugationForce -> 0 GravitationalAcceleration
					|>
				];

				(* Get all objects so we can make sure they are developer objects *)
				allDeveloperObjects=Cases[
					Flatten[
						{
							testDiluentModel1,
							preloadedAnalyte1,preloadedAnalyte2,
							preloadedAnalyteManufacturingSpecification1,preloadedAnalyteManufacturingSpecification2,
							cartridgeModel1
						}
					],
					ObjectP[]
				];

				(* Make all the test objects and models developer objects *)
				(* There are several test objects  *)
				Upload[<|Object->#,DeveloperObject->True|>&/@allDeveloperObjects];

			]
		]

	},
	SymbolTearDown:> {
		Module[{allObjects, existingObjects},

			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects=Cases[
				Flatten[
					{
						(* Pre-loaded Analytes *)
						Model[Molecule,Protein,"ValidUploadCapillaryELISACartridgeQ test pre-loaded analyte 1" <> $SessionUUID],
						Model[Molecule,Protein,"ValidUploadCapillaryELISACartridgeQ test pre-loaded analyte 2" <> $SessionUUID],

						(* Manufacturing Specifications *)
						Object[ManufacturingSpecification,CapillaryELISACartridge,"ValidUploadCapillaryELISACartridgeQ test pre-loaded analyte manufacturing specification 1" <> $SessionUUID],
						Object[ManufacturingSpecification,CapillaryELISACartridge,"ValidUploadCapillaryELISACartridgeQ test pre-loaded analyte manufacturing specification 2" <> $SessionUUID],

						(* Cartridge Object *)
						(* Create pre-loaded cartridges so that they can be searched in our resolver using DeveloperSearch *)
						Model[Container,Plate,Irregular,CapillaryELISA,"ValidUploadCapillaryELISACartridgeQ SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 1" <> $SessionUUID],

						(* Reagent Models *)
						Model[Sample,"ValidUploadCapillaryELISACartridgeQ test diluent model 1" <> $SessionUUID]
					}
				],
				ObjectP[]
			];

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]

		]
	}
];




(* ::Subsection:: *)
(*UploadCapillaryELISACartridgeOptions*)


(* ::Subsubsection:: *)
(*UploadCapillaryELISACartridgeOptions*)


DefineTests[UploadCapillaryELISACartridgeOptions,
	{
		Example[{Basic,"Display the option values which will be used to create a new pre-loaded capillary ELISA cartridge and a new capillay ELISA product kit:"},
			UploadCapillaryELISACartridgeOptions[
				Model[Molecule,Protein,"UploadCapillaryELISACartridgeOptions test pre-loaded analyte 2" <> $SessionUUID]
			],
			_Grid
		],
		Example[{Basic,"View any potential issues with provided inputs/options displayed:"},
			UploadCapillaryELISACartridgeOptions[
				Model[Molecule,Protein,"UploadCapillaryELISACartridgeOptions test pre-loaded analyte 1" <> $SessionUUID]
			],
			_Grid,
			Messages:>{
				Warning::CapillaryELISACartridgeExist
			}
		],
		Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			UploadCapillaryELISACartridgeOptions[
				Model[Molecule,Protein,"UploadCapillaryELISACartridgeOptions test pre-loaded analyte 2" <> $SessionUUID],
				OutputFormat->List
			],
			{(_Rule|_RuleDelayed)..}
		]
	},

	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"],
		$DeveloperSearch = True,
		$RequiredSearchName = "UploadCapillaryELISACartridgeOptions"
	},
	SymbolSetUp:>{

		Module[{allObjects, existingObjects},

			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects=Cases[
				Flatten[
					{
						(* Pre-loaded Analytes *)
						Model[Molecule,Protein,"UploadCapillaryELISACartridgeOptions test pre-loaded analyte 1" <> $SessionUUID],
						Model[Molecule,Protein,"UploadCapillaryELISACartridgeOptions test pre-loaded analyte 2" <> $SessionUUID],

						(* Manufacturing Specifications *)
						Object[ManufacturingSpecification,CapillaryELISACartridge,"UploadCapillaryELISACartridgeOptions test pre-loaded analyte manufacturing specification 1" <> $SessionUUID],
						Object[ManufacturingSpecification,CapillaryELISACartridge,"UploadCapillaryELISACartridgeOptions test pre-loaded analyte manufacturing specification 2" <> $SessionUUID],

						(* Cartridge Object *)
						(* Create pre-loaded cartridges so that they can be searched in our resolver using DeveloperSearch *)
						Model[Container,Plate,Irregular,CapillaryELISA,"UploadCapillaryELISACartridgeOptions SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 1" <> $SessionUUID],

						(* Reagent Models *)
						Model[Sample,"UploadCapillaryELISACartridgeOptions test diluent model 1" <> $SessionUUID]
					}
				],
				ObjectP[]
			];

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]

		];

		Block[{$AllowSystemsProtocols=True},
			Module[
				{
					testDiluentModel1,
					preloadedAnalyte1,preloadedAnalyte2,
					preloadedAnalyteManufacturingSpecification1,preloadedAnalyteManufacturingSpecification2,
					cartridgeModel1,
					allDeveloperObjects
				},

				(* Make the diluent models *)
				testDiluentModel1=Upload[
					<|
						Type->Model[Sample],
						Name->"UploadCapillaryELISACartridgeOptions test diluent model 1" <> $SessionUUID,
						DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
						State->Liquid
					|>
				];

				(* Make some analytes *)
				{
					preloadedAnalyte1,
					preloadedAnalyte2
				}=UploadProtein[
					{
						"UploadCapillaryELISACartridgeOptions test pre-loaded analyte 1" <> $SessionUUID,
						"UploadCapillaryELISACartridgeOptions test pre-loaded analyte 2" <> $SessionUUID
					},
					State->Solid,
					BiosafetyLevel->"BSL-1",
					Flammable->False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials->{None},
					ExpirationHazard->False
				];

				(* Make Manufacturing Specifications *)
				{
					preloadedAnalyteManufacturingSpecification1,
					preloadedAnalyteManufacturingSpecification2
				}=MapThread[
					Upload[
						<|
							Type->Object[ManufacturingSpecification,CapillaryELISACartridge],
							Name->#1,
							AnalyteName->#2,
							AnalyteMolecule->Link[#3],
							Replace[CartridgeType]->{SinglePlex72X1,MultiAnalyte16X4,MultiAnalyte32X4,MultiPlex32X8},
							Species->Human,
							RecommendedMinDilutionFactor->0.5,
							RecommendedDiluent->Link[Model[Sample,"UploadCapillaryELISACartridgeOptions test diluent model 1" <> $SessionUUID]],
							UpperQuantitationLimit->4000Picogram/Milliliter,
							LowerQuantitationLimit->1Picogram/Milliliter
						|>
					]&,
					{
						{
							"UploadCapillaryELISACartridgeOptions test pre-loaded analyte manufacturing specification 1" <> $SessionUUID,
							"UploadCapillaryELISACartridgeOptions test pre-loaded analyte manufacturing specification 2" <> $SessionUUID
						},
						(* We have to randomly select some analyte names for our fake manufacturing specifications *)
						{"TREM-1","TREM-2"},
						{
							preloadedAnalyte1,
							preloadedAnalyte2
						}
					}
				];

				(* Make Cartridges *)
				cartridgeModel1=Upload[
					<|
						Type->Model[Container,Plate,Irregular,CapillaryELISA],
						Name->"UploadCapillaryELISACartridgeOptions SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 1" <> $SessionUUID,
						Replace[AnalyteNames]->{"TREM-1"},
						Replace[AnalyteMolecules]->{Link[preloadedAnalyte1]},
						MaxNumberOfSamples->72,
						CartridgeType->SinglePlex72X1,
						MinBufferVolume->10.0Milliliter,
						MaxCentrifugationForce -> 0 GravitationalAcceleration
					|>
				];

				(* Get all objects so we can make sure they are developer objects *)
				allDeveloperObjects=Cases[
					Flatten[
						{
							testDiluentModel1,
							preloadedAnalyte1,preloadedAnalyte2,
							preloadedAnalyteManufacturingSpecification1,preloadedAnalyteManufacturingSpecification2,
							cartridgeModel1
						}
					],
					ObjectP[]
				];

				(* Make all the test objects and models developer objects *)
				(* There are several test objects  *)
				Upload[<|Object->#,DeveloperObject->True|>&/@allDeveloperObjects];

			]
		]

	},
	SymbolTearDown:> {
		Module[{allObjects, existingObjects},

			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects=Cases[
				Flatten[
					{
						(* Pre-loaded Analytes *)
						Model[Molecule,Protein,"UploadCapillaryELISACartridgeOptions test pre-loaded analyte 1" <> $SessionUUID],
						Model[Molecule,Protein,"UploadCapillaryELISACartridgeOptions test pre-loaded analyte 2" <> $SessionUUID],

						(* Manufacturing Specifications *)
						Object[ManufacturingSpecification,CapillaryELISACartridge,"UploadCapillaryELISACartridgeOptions test pre-loaded analyte manufacturing specification 1" <> $SessionUUID],
						Object[ManufacturingSpecification,CapillaryELISACartridge,"UploadCapillaryELISACartridgeOptions test pre-loaded analyte manufacturing specification 2" <> $SessionUUID],

						(* Cartridge Object *)
						(* Create pre-loaded cartridges so that they can be searched in our resolver using DeveloperSearch *)
						Model[Container,Plate,Irregular,CapillaryELISA,"UploadCapillaryELISACartridgeOptions SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 1" <> $SessionUUID],

						(* Reagent Models *)
						Model[Sample,"UploadCapillaryELISACartridgeOptions test diluent model 1" <> $SessionUUID]
					}
				],
				ObjectP[]
			];

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]

		]
	}
];




(* ::Subsection:: *)
(*UploadCapillaryELISACartridgePreview*)


(* ::Subsubsection:: *)
(*UploadCapillaryELISACartridgePreview*)


DefineTests[UploadCapillaryELISACartridgePreview,
	{
		Example[{Basic,"No preview is currently available for UploadCapillaryELISACartridge:"},
			UploadCapillaryELISACartridgePreview[
				Model[Molecule,Protein,"UploadCapillaryELISACartridgePreview test pre-loaded analyte" <> $SessionUUID]
			],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed, try using UploadCapillaryELISACartridgeOptions:"},
			UploadCapillaryELISACartridgeOptions[Model[Molecule,Protein,"UploadCapillaryELISACartridgePreview test pre-loaded analyte" <> $SessionUUID]],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the upload can be safely run using ValidExperimentCapillaryELISAQ:"},
			ValidUploadCapillaryELISACartridgeQ[Model[Molecule,Protein,"UploadCapillaryELISACartridgePreview test pre-loaded analyte" <> $SessionUUID]],
			True
		]
	},

	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"],
		$DeveloperSearch = True,
		$RequiredSearchName = "UploadCapillaryELISACartridgePreview"
	},
	SymbolSetUp:>{

		Module[{allObjects, existingObjects},

			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects=Cases[
				Flatten[
					{
						(* Pre-loaded Analytes *)
						Model[Molecule,Protein,"UploadCapillaryELISACartridgePreview test pre-loaded analyte" <> $SessionUUID],
						(* Manufacturing Specifications *)
						Object[ManufacturingSpecification,CapillaryELISACartridge,"UploadCapillaryELISACartridgePreview test pre-loaded analyte manufacturing specification" <> $SessionUUID],
						(* Reagent Models *)
						Model[Sample,"UploadCapillaryELISACartridgePreview test diluent model" <> $SessionUUID]
					}
				],
				ObjectP[]
			];

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]

		];

		Block[{$AllowSystemsProtocols=True},
			Module[
				{
					testDiluentModel,preloadedAnalyte,preloadedAnalyteManufacturingSpecification,
					allDeveloperObjects
				},

				(* Make the diluent models *)
				testDiluentModel=Upload[
					<|
						Type->Model[Sample],
						Name->"UploadCapillaryELISACartridgePreview test diluent model" <> $SessionUUID,
						DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
						State->Liquid
					|>
				];

				(* Make some analytes *)
				preloadedAnalyte=UploadProtein[
					"UploadCapillaryELISACartridgePreview test pre-loaded analyte" <> $SessionUUID,
					State->Solid,
					BiosafetyLevel->"BSL-1",
					Flammable->False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials->{None},
					ExpirationHazard->False
				];

				(* Make Manufacturing Specifications *)
				preloadedAnalyteManufacturingSpecification=Upload[
					<|
						Type->Object[ManufacturingSpecification,CapillaryELISACartridge],
						Name->"UploadCapillaryELISACartridgePreview test pre-loaded analyte manufacturing specification" <> $SessionUUID,
						AnalyteName->"Resistin",
						AnalyteMolecule->Link[preloadedAnalyte],
						Replace[CartridgeType]->{SinglePlex72X1,MultiAnalyte16X4,MultiAnalyte32X4,MultiPlex32X8},
						Species->Human,
						RecommendedMinDilutionFactor->0.5,
						RecommendedDiluent->Link[Model[Sample,"UploadCapillaryELISACartridgePreview test diluent model" <> $SessionUUID]],
						UpperQuantitationLimit->4000Picogram/Milliliter,
						LowerQuantitationLimit->1Picogram/Milliliter
					|>
				];

				(* Get all objects so we can make sure they are developer objects *)
				allDeveloperObjects=Cases[
					Flatten[
						{
							testDiluentModel,preloadedAnalyte,preloadedAnalyteManufacturingSpecification
						}
					],
					ObjectP[]
				];

				(* Make all the test objects and models developer objects *)
				(* There are several test objects  *)
				Upload[<|Object->#,DeveloperObject->True|>&/@allDeveloperObjects];

			]
		]

	},
	SymbolTearDown:> {
		Module[{allObjects, existingObjects},

			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects=Cases[
				Flatten[
					{
						(* Pre-loaded Analytes *)
						Model[Molecule,Protein,"UploadCapillaryELISACartridgePreview test pre-loaded analyte" <> $SessionUUID],
						(* Manufacturing Specifications *)
						Object[ManufacturingSpecification,CapillaryELISACartridge,"UploadCapillaryELISACartridgePreview test pre-loaded analyte manufacturing specification" <> $SessionUUID],
						(* Reagent Models *)
						Model[Sample,"UploadCapillaryELISACartridgePreview test diluent model" <> $SessionUUID]
					}
				],
				ObjectP[]
			];

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]

		]
	}
];