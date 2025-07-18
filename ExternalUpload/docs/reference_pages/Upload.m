(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*UploadInventory*)


(* ::Subsubsection::Closed:: *)
(*UploadInventory*)


DefineUsage[UploadInventory,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadInventory[Product]", "Inventory"},
				Description -> "returns an 'Inventory' object specifying how to keep the specified 'Product' in stock.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Product",
							Description -> "The product or stock solution to keep in stock.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Sample, StockSolution], Model[Sample, Media], Model[Sample, Matrix], Object[Product]}]
							],
							Expandable -> False
						},
						IndexName -> "inputs"
					]
				},
				Outputs :> {
					{
						OutputName -> "Inventory",
						Description -> "The inventory object specifying how to keep the input product in stock.",
						Pattern :> ObjectP[Object[Inventory]]
					}
				}

			},
			{
				Definition -> {"UploadInventory[ExistingInventory]", "Inventory"},
				Description -> "returns the 'Inventory' object updated according to the specified options.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "ExistingInventory",
							Description -> "The inventory object to be updated.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[Object[Inventory]]
							],
							Expandable -> False
						},
						IndexName -> "inputs"
					]
				},
				Outputs :> {
					{
						OutputName -> "Inventory",
						Description -> "The inventory object updated according to the specified options.",
						Pattern :> ObjectP[Object[Inventory]]
					}
				}
			}
		},
		SeeAlso -> {
			"SyncInventory",
			"OrderSamples",
			"ExperimentStockSolution",
			"ValidUploadInventoryQ",
			"UploadInventoryOptions"
		},
		Author -> {"melanie.reschke", "yanzhe.zhu", "nont.kosaisawe", "steven"}
	}
];


(* ::Subsubsection::Closed:: *)
(*UploadInventoryOptions*)

DefineUsage[UploadInventoryOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadInventoryOptions[Product]", "InventoryOptions"},
				Description -> "returns an 'Inventory' object specifying how to keep the specified 'Product' in stock.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Product",
							Description -> "The product or stock solution to keep in stock.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Sample, StockSolution], Model[Sample, Media], Model[Sample, Matrix], Object[Product]}]
							],
							Expandable -> False
						},
						IndexName -> "inputs"
					]
				},
				Outputs :> {
					{
						OutputName -> "InventoryOptions",
						Description -> "A list of options as they will be resolved by UploadInventory[].",
						Pattern :> {Rule..}
					}
				}

			},
			{
				Definition -> {"UploadInventoryOptions[ExistingInventory]", "InventoryOptions"},
				Description -> "returns the 'Inventory' object updated according to the specified options.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "ExistingInventory",
							Description -> "The inventory object to be updated.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[Object[Inventory]]
							],
							Expandable -> False
						},
						IndexName -> "inputs"
					]
				},
				Outputs :> {
					{
						OutputName -> "InventoryOptions",
						Description -> "A list of options as they will be resolved by UploadInventory[].",
						Pattern :> {Rule..}
					}
				}
			}
		},
		SeeAlso -> {
			"UploadInventory",
			"SyncInventory",
			"OrderSamples",
			"ExperimentStockSolution",
			"ValidUploadInventoryQ"
		},
		Author -> {"lei.tian", "andrey.shur", "steven"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidUploadInventoryQ*)

DefineUsage[ValidUploadInventoryQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidUploadInventoryQ[Product]", "IsValidInventoryObject"},
				Description -> "returns an 'Inventory' object specifying how to keep the specified 'Product' in stock.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Product",
							Description -> "The product or stock solution to keep in stock.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Sample, StockSolution], Model[Sample, Media], Model[Sample, Matrix], Object[Product]}]
							],
							Expandable -> False
						},
						IndexName -> "inputs"
					]
				},
				Outputs :> {
					{
						OutputName -> "IsValidInventoryObject",
						Description -> "A boolean that indicates if a valid object will be generated from UploadInventory[].",
						Pattern :> BooleanP
					}
				}

			},
			{
				Definition -> {"ValidUploadInventoryQ[ExistingInventory]", "IsValidInventoryObject"},
				Description -> "returns the 'inventory' object updated according to the specified options.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "ExistingInventory",
							Description -> "The inventory object to be updated.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[Object[Inventory]]
							],
							Expandable -> False
						},
						IndexName -> "inputs"
					]
				},
				Outputs :> {
					{
						OutputName -> "IsValidInventoryObject",
						Description -> "A boolean that indicates if a valid object will be generated from UploadInventory[].",
						Pattern :> BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"UploadInventory",
			"SyncInventory",
			"OrderSamples",
			"ExperimentStockSolution",
			"UploadInventoryOptions"
		},
		Author -> {"lei.tian", "andrey.shur", "steven"}
	}
];


(* ::Subsection::Closed:: *)
(*UploadCompanySupplier*)


(* ::Subsubsection::Closed:: *)
(*Main Function*)


DefineUsage[UploadCompanySupplier,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadCompanySupplier[supplierName]", "supplierObject"},
				Description -> "returns an object 'supplierObject' that contains the information given about the supplier.",
				Inputs :> {
					{
						InputName -> "supplierName",
						Description -> "The name of the supplier.",
						Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line]
					}
				},
				Outputs :> {
					{
						OutputName -> "supplierObject",
						Description -> "The object that represents this supplier.",
						Pattern :> ObjectP[Object[Company, Supplier]]
					}
				}
			}
		},
		SeeAlso -> {
			"ValidUploadCompanySupplierQ",
			"UploadCompanySupplierOptions",
			"Upload",
			"Download",
			"Inspect"
		},
		Author -> {"lei.tian", "andrey.shur", "thomas"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidUploadCompanySupplierQ*)


DefineUsage[ValidUploadCompanySupplierQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidUploadCompanySupplierQ[supplierName]", "isValidSupplierObject"},
				Description -> "returns a boolean that indicates if a valid object will be generated from UploadCompanySupplier[].",
				Inputs :> {
					{
						InputName -> "supplierName",
						Description -> "The name of the supplier.",
						Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line]
					}
				},
				Outputs :> {
					{
						OutputName -> "isValidSupplierObject",
						Description -> "A boolean that indicates if a valid object will be generated from UploadCompanySupplier[].",
						Pattern :> BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"UploadCompanySupplier",
			"UploadCompanySupplierOptions",
			"Upload",
			"Download",
			"Inspect"
		},
		Author -> {"lei.tian", "andrey.shur", "thomas"}
	}
];


(* ::Subsubsection::Closed:: *)
(*UploadCompanySupplierOptions*)


DefineUsage[UploadCompanySupplierOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadCompanySupplierOptions[supplierName]", "supplierObjectOptions"},
				Description -> "returns a list of options as they will be resolved by UploadCompanySupplier[].",
				Inputs :> {
					{
						InputName -> "supplierName",
						Description -> "The name of the supplier.",
						Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line]
					}
				},
				Outputs :> {
					{
						OutputName -> "supplierObjectOptions",
						Description -> "A list of options as they will be resolved by UploadCompanySupplier[].",
						Pattern :> {Rule..}
					}
				}
			}
		},
		SeeAlso -> {
			"ValidUploadCompanySupplierQ",
			"UploadCompanySupplier",
			"Upload",
			"Download",
			"Inspect"
		},
		Author -> {"lei.tian", "andrey.shur", "thomas"}
	}
];


(* ::Subsection::Closed:: *)
(*UploadMolecule*)


(* ::Subsubsection::Closed:: *)
(*Main Function*)


DefineUsage[UploadMolecule,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadMolecule[MoleculeName]", "molecule"},
				Description -> "returns a model 'molecule' that contains the information given about the chemical sample.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "MoleculeName",
							Description -> "The common name of this molecule.",
							Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line]
						},
						IndexName -> "Input Data"
					]
				},
				Outputs :> {
					{
						OutputName -> "molecule",
						Description -> "The model that represents this chemical sample.",
						Pattern :> ObjectP[Model[Molecule]]
					}
				}
			},
			{
				Definition -> {"UploadMolecule[AtomicStructure]", "molecule"},
				Description -> "returns a model 'molecule' based on the provided options and the structure specified by 'myMolecule'. The molecular structure of 'myMolecule' can be either drawn or explicitly given using the Molecule[\"..\"] function.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "AtomicStructure",
							Description -> "The molecular structure of the molecule, to be either drawn or explicitly given using the Molecule[\"..\"] function. The molecule will be used as a template when determining default values for unspecified options.",
							Widget -> Widget[
								Type -> Molecule,
								Pattern :> MoleculeP
							]
						},
						IndexName -> "Input Data"
					]
				},
				Outputs :> {
					{
						OutputName -> "molecule",
						Description -> "The model that represents this chemical sample.",
						Pattern :> ObjectP[Model[Molecule]]
					}
				}
			},
			{
				Definition -> {"UploadMolecule[PubChem]", "molecule"},
				Description -> "returns a model 'molecule' that contains the information given about the chemical sample.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "PubChem",
							Description -> "Enter the PubChem identifier of the chemical to upload, wrapped in a PubChem[...] head. (Ex. PubChem[679] is the ID of DMSO).",
							Widget -> Widget[
								Type -> Expression,
								Pattern :> _PubChem,
								Size -> Line,
								PatternTooltip -> "Enter the PubChem ID of the chemical to upload, wrapped in a PubChem[...] head. (Ex. PubChem[679] is the ID of DMSO)."
							]
						},
						IndexName -> "Input Data"
					]
				},
				Outputs :> {
					{
						OutputName -> "molecule",
						Description -> "The model that represents this chemical sample.",
						Pattern :> ObjectP[Model[Molecule]]
					}
				}
			},
			{
				Definition -> {"UploadMolecule[MoleculeInChI]", "molecule"},
				Description -> "returns a model 'molecule' that contains the information given about the chemical sample.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "MoleculeInChI",
							Description -> "The International Chemical Identifier (InChI) of the molecule.",
							Widget -> Widget[
								Type -> String,
								Pattern :> InChIP,
								Size -> Line,
								PatternTooltip -> "The InChI of a molecule is a string that begins with InChI=."
							]
						},
						IndexName -> "Input Data"
					]
				},
				Outputs :> {
					{
						OutputName -> "molecule",
						Description -> "The model that represents this chemical sample.",
						Pattern :> ObjectP[Model[Molecule]]
					}
				}
			},
			{
				Definition -> {"UploadMolecule[MoleculeInChIKey]", "molecule"},
				Description -> "returns a model 'molecule' that contains the information given about the chemical sample.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "MoleculeInChIKey",
							Description -> "The International Chemical Identifier (InChI) key of the molecule.",
							Widget -> Widget[
								Type -> String,
								Pattern :> InChIKeyP,
								Size -> Line,
								PatternTooltip -> "The InChIKey of this chemical, which is in the format of XXXXXXXXXXXXXX-XXXXXXXXXX-N where X is any uppercase letter."
							]
						},
						IndexName -> "Input Data"
					]
				},
				Outputs :> {
					{
						OutputName -> "molecule",
						Description -> "The model that represents this chemical sample.",
						Pattern :> ObjectP[Model[Molecule]]
					}
				}
			},
			{
				Definition -> {"UploadMolecule[MoleculeCAS]", "molecule"},
				Description -> "returns a model 'molecule' that contains the information given about the chemical sample.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "MoleculeCAS",
							Description -> "The Chemical Abstracts Service (CAS) number of this chemical.",
							Widget -> Widget[
								Type -> String,
								Pattern :> CASNumberP,
								Size -> Line,
								PatternTooltip -> "The CAS of a chemical is a number specified by the American Chemical Society (ACS)."
							]
						},
						IndexName -> "Input Data"
					]
				},
				Outputs :> {
					{
						OutputName -> "molecule",
						Description -> "The model that represents this chemical sample.",
						Pattern :> ObjectP[Model[Molecule]]
					}
				}
			},
			{
				Definition -> {"UploadMolecule[ThermoFisherURL]", "molecule"},
				Description -> "returns a model 'molecule' that contains the information given about the chemical sample.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "ThermoFisherURL",
							Description -> "The URL of the ThermoFisher product page of this chemical.",
							Widget -> Widget[
								Type -> String,
								Pattern :> ThermoFisherURLP,
								Size -> Line,
								PatternTooltip -> "The URL of the ThermoFisher product page of this chemical."
							]
						},
						IndexName -> "Input Data"
					]
				},
				Outputs :> {
					{
						OutputName -> "molecule",
						Description -> "The model that represents this chemical sample.",
						Pattern :> ObjectP[Model[Molecule]]
					}
				}
			},
			{
				Definition -> {"UploadMolecule[MilliporeSigmaURL]", "molecule"},
				Description -> "returns a model 'molecule' that contains the information given about the chemical sample.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "MilliporeSigmaURL",
							Description -> "The URL of the MilliporeSigma product page of this chemical.",
							Widget -> Widget[
								Type -> String,
								Pattern :> MilliporeSigmaURLP,
								Size -> Line,
								PatternTooltip -> "The URL of the MilliporeSigma product page of this chemical."
							]
						},
						IndexName -> "Input Data"
					]
				},
				Outputs :> {
					{
						OutputName -> "molecule",
						Description -> "The model that represents this chemical sample.",
						Pattern :> ObjectP[Model[Molecule]]
					}
				}
			},
			{
				Definition -> {"UploadMolecule[TemplateObject]", "molecule"},
				Description -> "returns a model 'molecule' based on the provided options and the values found in 'templateObject'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "TemplateObject",
							Description -> "An object to be used as a template when determining default values for unspecified options.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[Model[Molecule]],
								ObjectTypes -> {Model[Molecule]}
							]
						},
						IndexName -> "Input Data"
					]
				},
				Outputs :> {
					{
						OutputName -> "molecule",
						Description -> "The model that represents this chemical sample.",
						Pattern :> ObjectP[Model[Molecule]]
					}
				}
			},
			{
				Definition -> {"UploadMolecule[]", "molecule"},
				Description -> "returns a model 'molecule' that contains the information given about the chemical sample.",
				Inputs :> {},
				Outputs :> {
					{
						OutputName -> "molecule",
						Description -> "The model that represents this chemical sample.",
						Pattern :> ObjectP[Model[Molecule]]
					}
				}
			},
			(* The following is a definition where the user can specify a list of any of the above inputs.*)
			(* We need this definition because otherwise, the user can only specify a list of the same inputs {myTemplate1, myTemplate2...} and can't do {myTemplate1, myCAS2, myInChI3...}. *)
			{
				Definition -> {"UploadMolecule[List]", "molecules"},
				Description -> "returns an index-matched list of 'molecules' that contains the information given about the chemical sample, based on the given list 'List'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "List",
							Description -> "A list of inputs to base the creation of new chemical models on.",
							Widget -> Alternatives[
								Widget[Type -> String, Pattern :> _String, Size -> Line, PatternTooltip -> "The common name of this chemical."],
								Widget[
									Type -> Expression,
									Pattern :> _PubChem,
									Size -> Line,
									PatternTooltip -> "Enter the PubChem ID of the chemical to upload, wrapped in a PubChem[...] head. (Ex. PubChem[679] is the ID of DMSO)."
								],
								Widget[
									Type -> String,
									Pattern :> InChIP,
									Size -> Line,
									PatternTooltip -> "The InChI of a chemical is a string that begins with InChI=."
								],
								Widget[
									Type -> String,
									Pattern :> InChIKeyP,
									Size -> Line,
									PatternTooltip -> "The InChIKey of this chemical, which is in the format of XXXXXXXXXXXXXX-XXXXXXXXXX-N where X is any uppercase letter."
								],
								Widget[
									Type -> String,
									Pattern :> CASNumberP,
									Size -> Line,
									PatternTooltip -> "The CAS of a chemical is a number specified by the American Chemical Society (ACS)."
								],
								Widget[
									Type -> String,
									Pattern :> ThermoFisherURLP,
									Size -> Line,
									PatternTooltip -> "The URL of the ThermoFisher product page of this chemical."
								],
								Widget[
									Type -> String,
									Pattern :> MilliporeSigmaURLP,
									Size -> Line,
									PatternTooltip -> "The URL of the MilliporeSigma product page of this chemical."
								],
								Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Molecule]],
									ObjectTypes -> {Model[Molecule]}
								],
								Widget[
									Type -> Molecule,
									Pattern :> MoleculeP
								],
								Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
							],
							Expandable -> True
						},
						IndexName -> "Input Data"
					]
				},
				Outputs :> {
					{
						OutputName -> "molecule",
						Description -> "The model that represents this chemical sample.",
						Pattern :> ObjectP[Model[Molecule]]
					}
				}
			}
		},
		SeeAlso -> {
			"UploadCompanySupplier",
			"UploadProduct",
			"Upload",
			"Download",
			"Inspect"
		},
		Author -> {
			"lei.tian",
			"lige.tonggu"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidUploadMoleculeQ*)


DefineUsage[ValidUploadMoleculeQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidUploadMoleculeQ[ChemicalName]", "isValidmolecule"},
				Description -> "returns a boolean that indicates if a valid object will be generated from the inputs of this function.",
				Inputs :> {
					{
						InputName -> "ChemicalName",
						Description -> "The common name of this chemical.",
						Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line]
					}
				},
				Outputs :> {
					{
						OutputName -> "isValidmolecule",
						Description -> "A boolean that indicates if the resulting Model[Molecule] is valid.",
						Pattern :> BooleanP
					}
				}
			},
			{
				Definition -> {"ValidUploadMoleculeQ[InChI]", "isValidmolecule"},
				Description -> "returns a boolean that indicates if a valid object will be generated from the inputs of this function.",
				Inputs :> {
					{
						InputName -> "InChI",
						Description -> "The International Chemical Identifier (InChI) of the chemical.",
						Widget -> Widget[
							Type -> String,
							Pattern :> InChIP,
							Size -> Line,
							PatternTooltip -> "The InChI of a chemical is a string that begins with InChI=."
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "isValidmolecule",
						Description -> "A boolean that indicates if the resulting Model[Molecule] is valid.",
						Pattern :> BooleanP
					}
				}
			},
			{
				Definition -> {"ValidUploadMoleculeQ[InChIKey]", "isValidmolecule"},
				Description -> "returns a boolean that indicates if a valid object will be generated from the inputs of this function.",
				Inputs :> {
					{
						InputName -> "InChIKey",
						Description -> "The International Chemical Identifier (InChI) key of the chemical.",
						Widget -> Widget[
							Type -> String,
							Pattern :> InChIKeyP,
							Size -> Line,
							PatternTooltip -> "The InChIKey of this chemical, which is in the format of XXXXXXXXXXXXXX-XXXXXXXXXX-N where X is any uppercase letter."
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "isValidmolecule",
						Description -> "A boolean that indicates if the resulting Model[Molecule] is valid.",
						Pattern :> BooleanP
					}
				}
			},
			{
				Definition -> {"ValidUploadMoleculeQ[CAS]", "isValidmolecule"},
				Description -> "returns a boolean that indicates if a valid object will be generated from the inputs of this function.",
				Inputs :> {
					{
						InputName -> "CAS",
						Description -> "The Chemical Abstracts Service (CAS) number of this chemical.",
						Widget -> Widget[
							Type -> String,
							Pattern :> CASNumberP,
							Size -> Line,
							PatternTooltip -> "The CAS of a chemical is a number specified by the American Chemical Society (ACS)."
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "isValidmolecule",
						Description -> "A boolean that indicates if the resulting Model[Molecule] is valid.",
						Pattern :> BooleanP
					}
				}
			},
			{
				Definition -> {"ValidUploadMoleculeQ[ThermoFisherURL]", "isValidmolecule"},
				Description -> "returns a boolean that indicates if a valid object will be generated from the inputs of this function.",
				Inputs :> {
					{
						InputName -> "ThermoFisherURL",
						Description -> "The URL of the ThermoFisher product page of this chemical.",
						Widget -> Widget[
							Type -> String,
							Pattern :> ThermoFisherURLP,
							Size -> Line,
							PatternTooltip -> "The URL of the ThermoFisher product page of this chemical."
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "isValidmolecule",
						Description -> "A boolean that indicates if the resulting Model[Molecule] is valid.",
						Pattern :> BooleanP
					}
				}
			},
			{
				Definition -> {"ValidUploadMoleculeQ[MilliporeSigmaURL]", "isValidmolecule"},
				Description -> "returns a boolean that indicates if a valid object will be generated from the inputs of this function.",
				Inputs :> {
					{
						InputName -> "MilliporeSigmaURL",
						Description -> "The URL of the MilliporeSigma product page of this chemical.",
						Widget -> Widget[
							Type -> String,
							Pattern :> MilliporeSigmaURLP,
							Size -> Line,
							PatternTooltip -> "The URL of the MilliporeSigma product page of this chemical."
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "isValidmolecule",
						Description -> "A boolean that indicates if the resulting Model[Molecule] is valid.",
						Pattern :> BooleanP
					}
				}
			},
			{
				Definition -> {"ValidUploadMoleculeQ[]", "isValidmolecule"},
				Description -> "returns a boolean that indicates if a valid object will be generated from the inputs of this function.",
				Inputs :> {},
				Outputs :> {
					{
						OutputName -> "isValidmolecule",
						Description -> "A boolean that indicates if the resulting Model[Molecule] is valid.",
						Pattern :> BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"UploadMolecule",
			"ValidUploadMoleculeQ",
			"UploadMoleculeOptions",
			"Upload",
			"Download",
			"Inspect"
		},
		Author -> {
			"lei.tian",
			"lige.tonggu"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*UploadMoleculeOptions*)


DefineUsage[UploadMoleculeOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadMoleculeOptions[ChemicalName]", "UploadMoleculeOptions"},
				Description -> "returns a list of options as they will be resolved by UploadMolecule[].",
				Inputs :> {
					{
						InputName -> "ChemicalName",
						Description -> "The common name of this chemical.",
						Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line]
					}
				},
				Outputs :> {
					{
						OutputName -> "UploadMoleculeOptions",
						Description -> "A list of resolved options as they will be resolved by UploadMolecule[].",
						Pattern :> {Rule..}
					}
				}
			},
			{
				Definition -> {"UploadMoleculeOptions[InChI]", "UploadMoleculeOptions"},
				Description -> "returns a list of options as they will be resolved from UploadMolecule[].",
				Inputs :> {
					{
						InputName -> "InChI",
						Description -> "The International Chemical Identifier (InChI) of the chemical.",
						Widget -> Widget[
							Type -> String,
							Pattern :> InChIP,
							Size -> Line,
							PatternTooltip -> "The InChI of a chemical is a string that begins with InChI=."
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "UploadMoleculeOptions",
						Description -> "A list of resolved options as they will be resolved by UploadMolecule[].",
						Pattern :> {Rule..}
					}
				}
			},
			{
				Definition -> {"UploadMoleculeOptions[InChIKey]", "UploadMoleculeOptions"},
				Description -> "returns a list of options as they will be resolved from UploadMolecule[].",
				Inputs :> {
					{
						InputName -> "InChIKey",
						Description -> "The International Chemical Identifier (InChI) key of the chemical.",
						Widget -> Widget[
							Type -> String,
							Pattern :> InChIKeyP,
							Size -> Line,
							PatternTooltip -> "The InChIKey of this chemical, which is in the format of XXXXXXXXXXXXXX-XXXXXXXXXX-N where X is any uppercase letter."
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "UploadMoleculeOptions",
						Description -> "A list of resolved options as they will be resolved by UploadMolecule[].",
						Pattern :> {Rule..}
					}
				}
			},
			{
				Definition -> {"UploadMoleculeOptions[CAS]", "UploadMoleculeOptions"},
				Description -> "returns a list of options as they will be resolved from UploadMolecule[].",
				Inputs :> {
					{
						InputName -> "CAS",
						Description -> "The Chemical Abstracts Service (CAS) number of this chemical.",
						Widget -> Widget[
							Type -> String,
							Pattern :> CASNumberP,
							Size -> Line,
							PatternTooltip -> "The CAS of a chemical is a number specified by the American Chemical Society (ACS)."
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "UploadMoleculeOptions",
						Description -> "A list of resolved options as they will be resolved by UploadMolecule[].",
						Pattern :> {Rule..}
					}
				}
			},
			{
				Definition -> {"UploadMoleculeOptions[ThermoFisherURL]", "UploadMoleculeOptions"},
				Description -> "returns a list of options as they will be resolved from UploadMolecule[].",
				Inputs :> {
					{
						InputName -> "ThermoFisherURL",
						Description -> "The URL of the ThermoFisher product page of this chemical.",
						Widget -> Widget[
							Type -> String,
							Pattern :> ThermoFisherURLP,
							Size -> Line,
							PatternTooltip -> "The URL of the ThermoFisher product page of this chemical."
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "UploadMoleculeOptions",
						Description -> "A list of resolved options as they will be resolved by UploadMolecule[].",
						Pattern :> {Rule..}
					}
				}
			},
			{
				Definition -> {"UploadMoleculeOptions[MilliporeSigmaURL]", "UploadMoleculeOptions"},
				Description -> "returns a list of options as they will be resolved from UploadMolecule[].",
				Inputs :> {
					{
						InputName -> "MilliporeSigmaURL",
						Description -> "The URL of the MilliporeSigma product page of this chemical.",
						Widget -> Widget[
							Type -> String,
							Pattern :> MilliporeSigmaURLP,
							Size -> Line,
							PatternTooltip -> "The URL of the MilliporeSigma product page of this chemical."
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "UploadMoleculeOptions",
						Description -> "A list of resolved options as they will be resolved by UploadMolecule[].",
						Pattern :> {Rule..}
					}
				}
			},
			{
				Definition -> {"UploadMoleculeOptions[]", "UploadMoleculeOptions"},
				Description -> "returns a list of options as they will be resolved from UploadMolecule[].",
				Inputs :> {},
				Outputs :> {
					{
						OutputName -> "UploadMoleculeOptions",
						Description -> "A list of resolved options as they will be resolved by UploadMolecule[].",
						Pattern :> {Rule..}
					}
				}
			}
		},
		SeeAlso -> {
			"UploadMolecule",
			"ValidUploadMoleculeQ",
			"Upload",
			"Download",
			"Inspect"
		},
		Author -> {
			"lei.tian",
			"lige.tonggu"
		}
	}
];


(* ::Subsection::Closed:: *)
(*UploadProduct*)


(* ::Subsubsection::Closed:: *)
(*Main Function*)


DefineUsage[UploadProduct,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadProduct[ThermoFisherURL]", "productObject"},
				Description -> "returns an object 'productObject' that contains the information given about the product from the ThermoFisher product URL.",
				Inputs :> {
					{
						InputName -> "ThermoFisherURL",
						Description -> "The URL of the ThermoFisher product page of this product object.",
						Widget -> Widget[
							Type -> String,
							Pattern :> ThermoFisherURLP,
							Size -> Line,
							PatternTooltip -> "The URL of the ThermoFisher product page of this product object."
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "productObject",
						Description -> "The object that represents this product.",
						Pattern :> ObjectP[Object[Product]]
					}
				}
			},
			{
				Definition -> {"UploadProduct[MilliporeSigmaURL]", "productObject"},
				Description -> "returns an object 'productObject' that contains the information given about the product from the MilliporeSigma product URL.",
				Inputs :> {
					{
						InputName -> "MilliporeSigmaURL",
						Description -> "The URL of the MilliporeSigma product page of this product object.",
						Widget -> Widget[
							Type -> String,
							Pattern :> MilliporeSigmaURLP,
							Size -> Line,
							PatternTooltip -> "The URL of the MilliporeSigma product page of this product object."
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "productObject",
						Description -> "The object that represents this product.",
						Pattern :> ObjectP[Object[Product]]
					}
				}
			},
			{
				Definition -> {"UploadProduct[FisherScientificURL]", "productObject"},
				Description -> "returns an object 'productObject' that contains the information given about the product from the Fisher Scientific product URL.",
				Inputs :> {
					{
						InputName -> "FisherScientificURL",
						Description -> "The URL of the Fisher Scientific product page of this product object.",
						Widget -> Widget[
							Type -> String,
							Pattern :> FisherScientificURLP,
							Size -> Line,
							PatternTooltip -> "The URL of the Fisher Scientific product page of this product object."
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "productObject",
						Description -> "The object that represents this product.",
						Pattern :> ObjectP[Object[Product]]
					}
				}
			},
			{
				Definition -> {"UploadProduct[]", "productObject"},
				Description -> "returns an object 'productObject' that contains the information given about the product.",
				Inputs :> {},
				Outputs :> {
					{
						OutputName -> "productObject",
						Description -> "The object that represents this product.",
						Pattern :> ObjectP[Object[Product]]
					}
				}
			}
		},
		SeeAlso -> {
			"ValidUploadProductQ",
			"UploadProductOptions",
			"UploadMolecule",
			"UploadCompanySupplier",
			"Upload",
			"Download",
			"Inspect"
		},
		Author -> {"lei.tian", "andrey.shur", "thomas", "wyatt"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidUploadProductQ*)


DefineUsage[ValidUploadProductQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidUploadProductQ[ThermoFisherURL]", "isValidProductObject"},
				Description -> "returns a boolean that indicates if a valid object will be generated from the inputs of this function.",
				Inputs :> {
					{
						InputName -> "ThermoFisherURL",
						Description -> "The URL of the ThermoFisher product page of this product object.",
						Widget -> Widget[
							Type -> String,
							Pattern :> ThermoFisherURLP,
							Size -> Line,
							PatternTooltip -> "The URL of the ThermoFisher product page of this product object."
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "isValidProductObject",
						Description -> "A boolean that indicates if a valid object will be generated from the inputs of this function.",
						Pattern :> BooleanP
					}
				}
			},
			{
				Definition -> {"ValidUploadProductQ[MilliporeSigmaURL]", "isValidProductObject"},
				Description -> "returns a boolean that indicates if a valid object will be generated from the inputs of this function.",
				Inputs :> {
					{
						InputName -> "MilliporeSigmaURL",
						Description -> "The URL of the MilliporeSigma product page of this product object.",
						Widget -> Widget[
							Type -> String,
							Pattern :> MilliporeSigmaURLP,
							Size -> Line,
							PatternTooltip -> "The URL of the MilliporeSigma product page of this product object."
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "isValidProductObject",
						Description -> "A boolean that indicates if a valid object will be generated from the inputs of this function.",
						Pattern :> BooleanP
					}
				}
			},
			{
				Definition -> {"UploadProduct[FisherScientificURL]", "productObject"},
				Description -> "returns an object 'productObject' that contains the information given about the product from the Fisher Scientific product URL.",
				Inputs :> {
					{
						InputName -> "FisherScientificURL",
						Description -> "The URL of the Fisher Scientific product page of this product object.",
						Widget -> Widget[
							Type -> String,
							Pattern :> FisherScientificURLP,
							Size -> Line,
							PatternTooltip -> "The URL of the Fisher Scientific product page of this product object."
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "productObject",
						Description -> "The object that represents this product.",
						Pattern :> ObjectP[Object[Product]]
					}
				}
			},
			{
				Definition -> {"ValidUploadProductQ[]", "isValidProductObject"},
				Description -> "returns a boolean that indicates if a valid object will be generated from the inputs of this function.",
				Inputs :> {},
				Outputs :> {
					{
						OutputName -> "isValidProductObject",
						Description -> "A boolean that indicates if a valid object will be generated from the inputs of this function.",
						Pattern :> BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"UploadProduct",
			"UploadProductOptions",
			"UploadMolecule",
			"UploadCompanySupplier",
			"Upload",
			"Download",
			"Inspect"
		},
		Author -> {"lei.tian", "andrey.shur", "thomas"}
	}
];


(* ::Subsubsection::Closed:: *)
(*UploadProductOptions*)


DefineUsage[UploadProductOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadProductOptions[ThermoFisherURL]", "resolvedProductObjectOptions"},
				Description -> "returns a list of options as they will be resolved by UploadProduct[].",
				Inputs :> {
					{
						InputName -> "ThermoFisherURL",
						Description -> "The URL of the ThermoFisher product page of this product object.",
						Widget -> Widget[
							Type -> String,
							Pattern :> ThermoFisherURLP,
							Size -> Line,
							PatternTooltip -> "The URL of the ThermoFisher product page of this product object."
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "resolvedProductObjectOptions",
						Description -> "A list of resolved options as they will be resolved by UploadMolecule[].",
						Pattern :> {Rule..}
					}
				}
			},
			{
				Definition -> {"UploadProductOptions[MilliporeSigmaURL]", "resolvedProductObjectOptions"},
				Description -> "returns a list of options as they will be resolved by UploadProduct[].",
				Inputs :> {
					{
						InputName -> "MilliporeSigmaURL",
						Description -> "The URL of the MilliporeSigma product page of this product object.",
						Widget -> Widget[
							Type -> String,
							Pattern :> MilliporeSigmaURLP,
							Size -> Line,
							PatternTooltip -> "The URL of the MilliporeSigma product page of this product object."
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "resolvedProductObjectOptions",
						Description -> "A list of resolved options as they will be resolved by UploadMolecule[].",
						Pattern :> {Rule..}
					}
				}
			},
			{
				Definition -> {"UploadProduct[FisherScientificURL]", "productObject"},
				Description -> "returns an object 'productObject' that contains the information given about the product from the Fisher Scientific product URL.",
				Inputs :> {
					{
						InputName -> "FisherScientificURL",
						Description -> "The URL of the Fisher Scientific product page of this product object.",
						Widget -> Widget[
							Type -> String,
							Pattern :> FisherScientificURLP,
							Size -> Line,
							PatternTooltip -> "The URL of the Fisher Scientific product page of this product object."
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "productObject",
						Description -> "The object that represents this product.",
						Pattern :> ObjectP[Object[Product]]
					}
				}
			},
			{
				Definition -> {"UploadProductOptions[]", "resolvedProductObjectOptions"},
				Description -> "returns a list of options as they will be resolved by UploadProduct[].",
				Inputs :> {},
				Outputs :> {
					{
						OutputName -> "resolvedProductObjectOptions",
						Description -> "A list of resolved options as they will be resolved by UploadMolecule[].",
						Pattern :> {Rule..}
					}
				}
			}
		},
		SeeAlso -> {
			"UploadProduct",
			"ValidUploadProductQ",
			"UploadMolecule",
			"UploadCompanySupplier",
			"Upload",
			"Download",
			"Inspect"
		},
		Author -> {"lei.tian", "andrey.shur", "thomas"}
	}
];


(* ::Subsection::Closed:: *)
(*UploadCompanyService*)


(* ::Subsubsection::Closed:: *)
(*UploadCompanyService*)


DefineUsage[UploadCompanyService,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadCompanyService[companyName]", "companyObject"},
				Description -> "creates a new 'companyObject' with Name: 'companyName' that synthesizes custom-made samples as a service.",
				Inputs :> {
					{
						InputName -> "companyName",
						Widget -> Widget[
							Type -> String,
							Pattern :> _String,
							Size -> Line
						],
						Description -> "The name of the company."
					}
				},
				Outputs :> {
					{
						OutputName -> "companyObject",
						Pattern :> ObjectP[Object[Company, Service]],
						Description -> "The newly-created company."
					}
				}
			}
		},
		MoreInformation -> {

		},
		SeeAlso -> {
			"UploadCompanySupplier",
			"UploadProduct",
			"UploadCompanySupplierOptions"
		},
		Author -> {"lei.tian", "andrey.shur", "thomas"}
	}
];


(* ::Subsubsection::Closed:: *)
(*UploadCompanyServiceOptions*)


DefineUsage[UploadCompanyServiceOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadCompanyServiceOptions[companyName]", "resolvedOptions"},
				Description -> "returns the resolve options when calling UploadCompanyService.",
				Inputs :> {
					{
						InputName -> "companyName",
						Widget -> Widget[
							Type -> String,
							Pattern :> _String,
							Size -> Line
						],
						Description -> "The name of the company."
					}
				},
				Outputs :> {
					{
						OutputName -> "resolvedOptions",
						Description -> "Resolved options when UploadCompanyService is called on the input.",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {

		},
		SeeAlso -> {
			UploadCompanyService,
			ValidUploadCompanySupplierQ,
			UploadProduct
		},
		Author -> {"lei.tian", "andrey.shur", "thomas"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidUploadCompanyServiceQ*)


DefineUsage[ValidUploadCompanyServiceQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidUploadCompanyServiceQ[companyName]", "bool"},
				Description -> "checks whether the provided 'companyName' and specified options are valid for calling UploadCompanyService.",
				Inputs :> {
					{
						InputName -> "companyName",
						Widget -> Widget[
							Type -> String,
							Pattern :> _String,
							Size -> Line
						],
						Description -> "The name of the company."
					}
				},
				Outputs :> {
					{
						OutputName -> "bool",
						Description -> "Whether or not the UploadCompanyService call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary | BooleanP
					}
				}
			}
		},
		MoreInformation -> {

		},
		SeeAlso -> {
			UploadCompanyService,
			UploadCompanyServiceOptions,
			UploadProduct
		},
		Author -> {"lei.tian", "andrey.shur", "thomas"}
	}
];


(* ::Subsection::Closed:: *)
(*UploadLiterature*)


(* ::Subsubsection::Closed:: *)
(*UploadLiterature*)


DefineUsage[UploadLiterature,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadLiterature[pubMedID]", "literatureObject"},
				Description -> "uploads an Object[Report,Literature] from the given PubMed ID.",
				Inputs :> {
					{
						InputName -> "pubMedID",
						Description -> "The PubMed ID of this piece of literature.",
						Widget -> Widget[Type -> Expression, Pattern :> _PubMed, Size -> Line, PatternTooltip -> "The PubMed ID of this piece of literature (e.g. PubMed[17322918])."]
					}
				},
				Outputs :> {
					{
						OutputName -> "literatureObject",
						Description -> "The object that represents this piece of literature.",
						Pattern :> ObjectP[Object[Report, Literature]]
					}
				}
			},
			{
				Definition -> {"UploadLiterature[endNoteFile]", "literatureObject"},
				Description -> "uploads an Object[Report,Literature] from the given EndNote XML file.",
				Inputs :> {
					{
						InputName -> "endNoteFile",
						Description -> "A path or URL to the EndNote XML file that represents this piece of literature.",
						Widget -> Widget[Type -> String, Pattern :> XmlFileP, Size -> Line, PatternTooltip -> "A path or URL to the EndNote XML file that represents this piece of literature."]
					}
				},
				Outputs :> {
					{
						OutputName -> "literatureObject",
						Description -> "The object that represents this piece of literature.",
						Pattern :> ObjectP[Object[Report, Literature]]
					}
				}
			},
			{
				Definition -> {"UploadLiterature[endNoteList]", "literatureObject"},
				Description -> "uploads an Object[Report,Literature] from the imported EndNote information.",
				Inputs :> {
					{
						InputName -> "endNoteList",
						Description -> "The imported EndNote XML file (in list form) that represents this piece of literature.",
						Widget -> Widget[Type -> Expression, Pattern :> _, Size -> Line, PatternTooltip -> "The imported EndNote XML file (in list form) that represents this piece of literature."]
					}
				},
				Outputs :> {
					{
						OutputName -> "literatureObject",
						Description -> "The object that represents this piece of literature.",
						Pattern :> ObjectP[Object[Report, Literature]]
					}
				}
			},
			{
				Definition -> {"UploadLiterature[]", "literatureObject"},
				Description -> "uploads an Object[Report,Literature].",
				Inputs :> {
				},
				Outputs :> {
					{
						OutputName -> "literatureObject",
						Description -> "The object that represents this piece of literature.",
						Pattern :> ObjectP[Object[Report, Literature]]
					}
				}
			}
		},
		SeeAlso -> {
			"UploadLiteratureOptions",
			"ValidUploadLiteratureQ",
			"Upload",
			"Download",
			"Inspect"
		},
		Author -> {"lei.tian", "andrey.shur", "thomas"}
	}
];


(* ::Subsubsection::Closed:: *)
(*UploadLiteratureOptions*)


DefineUsage[UploadLiteratureOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadLiteratureOptions[pubMedID]", "resolvedOptions"},
				Description -> "returns the resolved options when uploading an Object[Report,Literature] from a given PubMed ID.",
				Inputs :> {
					{
						InputName -> "pubMedID",
						Description -> "The PubMed ID of this piece of literature.",
						Widget -> Widget[Type -> Expression, Pattern :> _PubMed, Size -> Line, PatternTooltip -> "The PubMed ID of this piece of literature (e.g. PubMed[17322918])."]
					}
				},
				Outputs :> {
					{
						OutputName -> "resolvedOptions",
						Description -> "The resolved options from UploadLiterature for the provided PubMed ID.",
						Pattern :> {Rule[_Symbol, Except[Automatic]]..}
					}
				}
			},
			{
				Definition -> {"UploadLiteratureOptions[endNoteFile]", "resolvedOptions"},
				Description -> "returns the resolved options when uploading an Object[Report,Literature] from the given EndNote XML file.",
				Inputs :> {
					{
						InputName -> "endNoteFile",
						Description -> "A path or URL to the EndNote XML file that represents this piece of literature.",
						Widget -> Widget[Type -> String, Pattern :> XmlFileP, Size -> Line, PatternTooltip -> "A path or URL to the EndNote XML file that represents this piece of literature."]
					}
				},
				Outputs :> {
					{
						OutputName -> "resolvedOptions",
						Description -> "The resolved options from UploadLiterature for the provided EndNote XML file.",
						Pattern :> {Rule[_Symbol, Except[Automatic]]..}
					}
				}
			},
			{
				Definition -> {"UploadLiteratureOptions[endNoteList]", "resolvedOptions"},
				Description -> "returns the resolved options when uploading an Object[Report,Literature] from the imported EndNote information.",
				Inputs :> {
					{
						InputName -> "endNoteList",
						Description -> "The imported EndNote XML file (in list form) that represents this piece of literature.",
						Widget -> Widget[Type -> Expression, Pattern :> _, Size -> Line, PatternTooltip -> "The imported EndNote XML file (in list form) that represents this piece of literature."]
					}
				},
				Outputs :> {
					{
						OutputName -> "resolvedOptions",
						Description -> "The resolved options from UploadLiterature for the provided imported EndNote XML file.",
						Pattern :> {Rule[_Symbol, Except[Automatic]]..}
					}
				}
			},
			{
				Definition -> {"UploadLiteratureOptions[]", "resolvedOptions"},
				Description -> "returns the resolved options when uploading an Object[Report,Literature].",
				Inputs :> {
				},
				Outputs :> {
					{
						OutputName -> "resolvedOptions",
						Description -> "The resolved options from UploadLiterature for the provided options.",
						Pattern :> {Rule[_Symbol, Except[Automatic]]..}
					}
				}
			}
		},
		SeeAlso -> {
			"UploadLiterature",
			"ValidUploadLiteratureQ",
			"Upload",
			"Download",
			"Inspect"
		},
		Author -> {"lei.tian", "andrey.shur", "thomas"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidUploadLiteratureQ*)


DefineUsage[ValidUploadLiteratureQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidUploadLiteratureQ[pubMedID]", "boolean"},
				Description -> "returns a boolean indicating if the uploaded Object[Report,Literature] will be valid from the given PubMed ID.",
				Inputs :> {
					{
						InputName -> "pubMedID",
						Description -> "The PubMed ID of this piece of literature.",
						Widget -> Widget[Type -> Expression, Pattern :> _PubMed, Size -> Line, PatternTooltip -> "The PubMed ID of this piece of literature (e.g. PubMed[17322918])."]
					}
				},
				Outputs :> {
					{
						OutputName -> "boolean",
						Description -> "A boolean that indicates if the uploaded Object[Report,Literature] will be valid.",
						Pattern :> _EmeraldTestSummary | BooleanP
					}
				}
			},
			{
				Definition -> {"ValidUploadLiteratureQ[endNoteFile]", "boolean"},
				Description -> "returns a boolean indicating if the uploaded Object[Report,Literature] will be valid from the given EndNote XML file.",
				Inputs :> {
					{
						InputName -> "endNoteFile",
						Description -> "A path or URL to the EndNote XML file that represents this piece of literature.",
						Widget -> Widget[Type -> String, Pattern :> XmlFileP, Size -> Line, PatternTooltip -> "A path or URL to the EndNote XML file that represents this piece of literature."]
					}
				},
				Outputs :> {
					{
						OutputName -> "boolean",
						Description -> "A boolean that indicates if the uploaded Object[Report,Literature] will be valid.",
						Pattern :> _EmeraldTestSummary | BooleanP
					}
				}
			},
			{
				Definition -> {"ValidUploadLiteratureQ[endNoteList]", "boolean"},
				Description -> "returns a boolean indicating if the uploaded Object[Report,Literature] will be valid from the imported EndNote information.",
				Inputs :> {
					{
						InputName -> "endNoteList",
						Description -> "The imported EndNote XML file (in list form) that represents this piece of literature.",
						Widget -> Widget[Type -> Expression, Pattern :> _, Size -> Line, PatternTooltip -> "The imported EndNote XML file (in list form) that represents this piece of literature."]
					}
				},
				Outputs :> {
					{
						OutputName -> "boolean",
						Description -> "A boolean that indicates if the uploaded Object[Report,Literature] will be valid.",
						Pattern :> _EmeraldTestSummary | BooleanP
					}
				}
			},
			{
				Definition -> {"ValidUploadLiteratureQ[]", "boolean"},
				Description -> "returns a boolean indicating if the uploaded Object[Report,Literature] will be valid.",
				Inputs :> {
				},
				Outputs :> {
					{
						OutputName -> "boolean",
						Description -> "A boolean that indicates if the uploaded Object[Report,Literature] will be valid.",
						Pattern :> _EmeraldTestSummary | BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"UploadLiterature",
			"UploadLiteratureOptions",
			"Upload",
			"Download",
			"Inspect"
		},
		Author -> {"lei.tian", "andrey.shur", "thomas"}
	}
];


(* ::Subsection::Closed:: *)
(*UploadFractionCollectionMethod*)


(* ::Subsubsection::Closed:: *)
(*UploadFractionCollectionMethod*)


DefineUsage[UploadFractionCollectionMethod,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadFractionCollectionMethod[]", "methodFractionCollection"},
				Description -> "creates a new 'methodFractionCollection' based on the provided options.",
				Inputs :> {},
				Outputs :> {
					{
						OutputName -> "methodFractionCollection",
						Description -> "The newly-created fraction collection method.",
						Pattern :> ObjectP[Object[Method, FractionCollection]]
					}
				}
			},
			{
				Definition -> {"UploadFractionCollectionMethod[templateObject]", "methodFractionCollection"},
				Description -> "creates a new 'methodFractionCollection' based on the provided options and the values found in the 'templateObject'.",
				Inputs :> {
					{
						InputName -> templateObject,
						Description -> "An object to be used as a template when determining default values for unspecified options.",
						Widget -> Widget[
							Type -> Object,
							Pattern :> ObjectP[Object[Method, FractionCollection]],
							ObjectTypes -> {Object[Method, FractionCollection]}
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "methodFractionCollection",
						Description -> "The newly-created fraction collection method.",
						Pattern :> ObjectP[Object[Method, FractionCollection]]
					}
				}
			}
		},
		MoreInformation -> {

		},
		SeeAlso -> {
			"ExperimentHPLC",
			"ValidObjectQ",
			"UploadFractionCollectionMethodOptions",
			"ValidUploadFractionCollectionMethodQ"
		},
		Author -> {"lei.tian", "andrey.shur", "steven", "wyatt"}
	}
];


(* ::Subsubsection::Closed:: *)
(*UploadFractionCollectionMethodOptions*)


DefineUsage[UploadFractionCollectionMethodOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadFractionCollectionMethodOptions[]", "resolvedOptions"},
				Description -> "returns the resolved options when calling UploadFractionCollectionMethod.",
				Inputs :> {
					(* This function currently takes no inputs *)
				},
				Outputs :> {
					{
						OutputName -> "resolvedOptions",
						Description -> "Resolved options when UploadFractionCollectionMethod is called on the input.",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			},
			{
				Definition -> {"UploadFractionCollectionMethodOptions[templateObject]", "methodFractionCollection"},
				Description -> "returns the resolved options when calling UploadFractionCollectionMethod['templateObject'].",
				Inputs :> {
					{
						InputName -> templateObject,
						Description -> "An object to be used as a template when determining default values for unspecified options.",
						Widget -> Widget[
							Type -> Object,
							Pattern :> ObjectP[Object[Method, FractionCollection]],
							ObjectTypes -> {Object[Method, FractionCollection]}
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "methodFractionCollection",
						Description -> "The newly-created fraction collection method.",
						Pattern :> ObjectP[Object[Method, FractionCollection]]
					}
				}
			}
		},
		MoreInformation -> {

		},
		SeeAlso -> {
			"UploadFractionCollectionMethod",
			"ValidUploadFractionCollectionMethodQ",
			"ExperimentHPLC",
			"ValidObjectQ"
		},
		Author -> {"lei.tian", "andrey.shur", "steven", "wyatt"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidUploadFractionCollectionMethodQ*)


DefineUsage[ValidUploadFractionCollectionMethodQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidUploadFractionCollectionMethodQ[]", "bool"},
				Description -> "checks whether the specified options are valid for calling UploadFractionCollectionMethod.",
				Inputs :> {
					(* This function currently takes no inputs *)
				},
				Outputs :> {
					{
						OutputName -> "bool",
						Description -> "Whether or not the UploadFractionCollectionMethod call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> (_EmeraldTestSummary | BooleanP)
					}
				}
			},
			{
				Definition -> {"ValidUploadFractionCollectionMethodQ[templateObject]", "methodFractionCollection"},
				Description -> "checks whether the specified options are valid for calling UploadFractionCollectionMethod['templateObject'].",
				Inputs :> {
					{
						InputName -> templateObject,
						Description -> "An object to be used as a template when determining default values for unspecified options.",
						Widget -> Widget[
							Type -> Object,
							Pattern :> ObjectP[Object[Method, FractionCollection]],
							ObjectTypes -> {Object[Method, FractionCollection]}
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "methodFractionCollection",
						Description -> "The newly-created fraction collection method.",
						Pattern :> ObjectP[Object[Method, FractionCollection]]
					}
				}
			}
		},
		MoreInformation -> {

		},
		SeeAlso -> {
			"UploadFractionCollectionMethod",
			"UploadFractionCollectionMethodOptions",
			"ExperimentHPLC",
			"ValidObjectQ"
		},
		Author -> {"lei.tian", "andrey.shur", "steven", "wyatt"}
	}
];


(* ::Subsection::Closed:: *)
(*UploadPipettingMethod*)


(* ::Subsubsection::Closed:: *)
(*UploadPipettingMethod*)


DefineUsage[UploadPipettingMethod,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadPipettingMethod[methodName]", "methodObject"},
				Description -> "returns an object 'methodObject' that contains the information given about the pipetting parameters.",
				Inputs :> {
					{
						InputName -> "methodName",
						Description -> "The name of the pipetting method.",
						Widget -> Widget[
							Type -> String,
							Pattern :> _String,
							Size -> Line
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "methodObject",
						Description -> "The object that represents this gradient.",
						Pattern :> ObjectP[Model[Method, Pipetting]]
					}
				}
			},
			{
				Definition -> {"UploadPipettingMethod[]", "methodObject"},
				Description -> "returns an object 'methodObject' that contains the information given about the pipetting parameters.",
				Inputs :> {},
				Outputs :> {
					{
						OutputName -> "methodObject",
						Description -> "The object that represents this pipetting method.",
						Pattern :> ObjectP[Model[Method, Pipetting]]
					}
				}
			}
		},
		SeeAlso -> {
			"UploadPipettingMethodModelOptions",
			"UploadPipettingMethodModelPreview",
			"ValidUploadPipettingMethodModelQ",
			"ExperimentSamplePreparation"
		},
		Author -> {"robert", "alou"}
	}
];



(* ::Subsubsection::Closed:: *)
(*UploadPipettingMethodModelOptions*)


DefineUsage[UploadPipettingMethodModelOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadPipettingMethodModelOptions[methodName]", "methodOptions"},
				Description -> "returns a list of options as they will be resolved by UploadPipettingMethodModelOptions[].",
				Inputs :> {
					{
						InputName -> "methodName",
						Description -> "The name of the pipetting method.",
						Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line]
					}
				},
				Outputs :> {
					{
						OutputName -> "methodOptions",
						Description -> "A list of options as they will be resolved by UploadPipettingMethodModelOptions[].",
						Pattern :> {Rule..}
					}
				}
			},
			{
				Definition -> {"UploadPipettingMethodModelOptions[]", "methodOptions"},
				Description -> "returns a list of options as they will be resolved by UploadPipettingMethodModelOptions[].",
				Inputs :> {},
				Outputs :> {
					{
						OutputName -> "methodOptions",
						Description -> "A list of options as they will be resolved by UploadPipettingMethodModelOptions[].",
						Pattern :> {Rule..}
					}
				}
			}
		},
		SeeAlso -> {
			"UploadPipettingMethod",
			"UploadPipettingMethodModelPreview",
			"ValidUploadPipettingMethodModelQ",
			"ExperimentSamplePreparation"
		},
		Author -> {"robert", "alou"}
	}
];



(* ::Subsubsection::Closed:: *)
(*UploadPipettingMethodModelPreview*)


DefineUsage[UploadPipettingMethodModelPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadPipettingMethodModelPreview[methodName]", "methodPreview"},
				Description -> "returns Null as the preview of the output from UploadPipettingMethod[].",
				Inputs :> {
					{
						InputName -> "methodName",
						Description -> "The name of the gradient method.",
						Widget -> Widget[
							Type -> String,
							Pattern :> _String,
							Size -> Line
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "methodPreview",
						Description -> "The preview output of UploadPipettingMethodModelPreview[].",
						Pattern :> Null
					}
				}
			},
			{
				Definition -> {"UploadPipettingMethodModelPreview[]", "methodPreview"},
				Description -> "returns Null as the preview of the output from UploadPipettingMethod[].",
				Inputs :> {},
				Outputs :> {
					{
						OutputName -> "methodPreview",
						Description -> "The preview output of UploadPipettingMethod[].",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"UploadPipettingMethod",
			"UploadPipettingMethodModelOptions",
			"ValidUploadPipettingMethodModelQ",
			"ExperimentSamplePreparation"
		},
		Author -> {"robert", "alou"}
	}
];



(* ::Subsubsection::Closed:: *)
(*ValidUploadPipettingMethodModelQ*)


DefineUsage[ValidUploadPipettingMethodModelQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidUploadPipettingMethodModelQ[methodName]", "isValidMethodObject"},
				Description -> "returns a boolean that indicates if a valid object will be generated from UploadPipettingMethod[].",
				Inputs :> {
					{
						InputName -> "methodName",
						Description -> "The name of the gradient method.",
						Widget -> Widget[
							Type -> String,
							Pattern :> _String,
							Size -> Line
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "isValidMethodObject",
						Description -> "A boolean that indicates if a valid object will be generated from UploadPipettingMethod[].",
						Pattern :> BooleanP
					}
				}
			},
			{
				Definition -> {"ValidUploadPipettingMethodModelQ[]", "isValidMethodObject"},
				Description -> "returns a boolean that indicates if a valid object will be generated from UploadPipettingMethod[].",
				Inputs :> {},
				Outputs :> {
					{
						OutputName -> "isValidMethodObject",
						Description -> "A boolean that indicates if a valid object will be generated from UploadPipettingMethod[].",
						Pattern :> BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"UploadPipettingMethod",
			"UploadPipettingMethodModelOptions",
			"UploadPipettingMethodModelPreview",
			"ExperimentSamplePreparation"
		},
		Author -> {"robert", "alou"}
	}
];


(* ::Subsection::Closed:: *)
(*UploadGradientMethod*)


(* ::Subsubsection::Closed:: *)
(*UploadGradientMethod*)


DefineUsage[UploadGradientMethod,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadGradientMethod[methodName]", "methodObject"},
				Description -> "returns an object 'methodObject' that contains the information given about the gradient.",
				Inputs :> {
					{
						InputName -> "methodName",
						Description -> "The name of the gradient method.",
						Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line]
					}
				},
				Outputs :> {
					{
						OutputName -> "methodObject",
						Description -> "The object that represents this gradient.",
						Pattern :> ObjectP[Object[Method, Gradient]]
					}
				}
			},
			{
				Definition -> {"UploadGradientMethod[]", "methodObject"},
				Description -> "returns an object 'methodObject' that contains the information given about the gradient.",
				Inputs :> {},
				Outputs :> {
					{
						OutputName -> "methodObject",
						Description -> "The object that represents this gradient.",
						Pattern :> ObjectP[Object[Method, Gradient]]
					}
				}
			}

		},
		SeeAlso -> {
			"ValidUploadGradientMethodQ",
			"UploadGradientMethodOptions",
			"Upload",
			"Download",
			"Inspect"
		},
		Author -> {"xu.yi", "andrey.shur", "lei.tian", "jihan.kim"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidUploadGradientMethodQ*)


DefineUsage[ValidUploadGradientMethodQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidUploadGradientMethodQ[methodName]", "isValidMethodObject"},
				Description -> "returns a boolean that indicates if a valid object will be generated from UploadGradientMethod[].",
				Inputs :> {
					{
						InputName -> "methodName",
						Description -> "The name of the gradient method.",
						Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line]
					}
				},
				Outputs :> {
					{
						OutputName -> "isValidMethodObject",
						Description -> "A boolean that indicates if a valid object will be generated from UploadGradientMethod[].",
						Pattern :> BooleanP
					}
				}
			},
			{
				Definition -> {"ValidUploadGradientMethodQ[]", "isValidMethodObject"},
				Description -> "returns a boolean that indicates if a valid object will be generated from UploadGradientMethod[].",
				Inputs :> {},
				Outputs :> {
					{
						OutputName -> "isValidMethodObject",
						Description -> "A boolean that indicates if a valid object will be generated from UploadGradientMethod[].",
						Pattern :> BooleanP
					}
				}
			}

		},
		SeeAlso -> {
			"UploadGradientMethod",
			"UploadGradientMethodOptions",
			"Upload",
			"Download",
			"Inspect"
		},
		Author -> {
			"yanzhe.zhu", "ben", "dima"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*UploadGradientMethodOptions*)


DefineUsage[UploadGradientMethodOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadGradientMethodOptions[methodName]", "methodOptions"},
				Description -> "returns a list of options as they will be resolved by UploadGradientMethod[].",
				Inputs :> {
					{
						InputName -> "methodName",
						Description -> "The name of the gradient method.",
						Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line]
					}
				},
				Outputs :> {
					{
						OutputName -> "methodOptions",
						Description -> "A list of options as they will be resolved by UploadGradientMethod[].",
						Pattern :> {Rule..}
					}
				}
			},
			{
				Definition -> {"UploadGradientMethodOptions[]", "methodOptions"},
				Description -> "returns a list of options as they will be resolved by UploadGradientMethod[].",
				Inputs :> {},
				Outputs :> {
					{
						OutputName -> "methodOptions",
						Description -> "A list of options as they will be resolved by UploadGradientMethod[].",
						Pattern :> {Rule..}
					}
				}
			}

		},
		SeeAlso -> {
			"ValidUploadGradientMethodQ",
			"UploadGradientMethod",
			"Upload",
			"Download",
			"Inspect"
		},
		Author -> {"xu.yi", "andrey.shur", "lei.tian", "jihan.kim"}
	}
];


(* ::Subsubsection::Closed:: *)
(*UploadGradientMethodPreview*)


DefineUsage[UploadGradientMethodPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadGradientMethodPreview[methodName]", "methodPreview"},
				Description -> "returns Null as the preview of the output from UploadGradientMethod[].",
				Inputs :> {
					{
						InputName -> "methodName",
						Description -> "The name of the gradient method.",
						Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line]
					}
				},
				Outputs :> {
					{
						OutputName -> "methodPreview",
						Description -> "The preview output of UploadGradientMethod[].",
						Pattern :> Null
					}
				}
			},
			{
				Definition -> {"UploadGradientMethodPreview[]", "methodPreview"},
				Description -> "returns Null as the preview of the output from UploadGradientMethod[].",
				Inputs :> {},
				Outputs :> {
					{
						OutputName -> "methodPreview",
						Description -> "The preview output of UploadGradientMethod[].",
						Pattern :> Null
					}
				}
			}

		},
		SeeAlso -> {
			"ValidUploadGradientMethodQ",
			"UploadGradientMethod",
			"UploadGradientMethodOptions",
			"Upload",
			"Download",
			"Inspect"
		},
		Author -> {
			"yanzhe.zhu", "ben", "dima"
		}
	}
];



(* ::Subsection::Closed:: *)
(*UploadJournal*)


(* ::Subsubsection::Closed:: *)
(*UploadJournal*)


DefineUsage[UploadJournal,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadJournal[journalName]", "journalObject"},
				Description -> "creates a new 'journalObject' based on the provided 'journalName' and options.",
				Inputs :> {
					{
						InputName -> "journalName",
						Widget -> Widget[
							Type -> String,
							Pattern :> _String,
							Size -> Line
						],
						Description -> "The name of this journal."
					}
				},
				Outputs :> {
					{
						OutputName -> "journalObject",
						Description -> "The newly-created journal object.",
						Pattern :> ObjectP[Object[Journal]]
					}
				}
			}
		},
		MoreInformation -> {

		},
		SeeAlso -> {
			"UploadLiteratureObject",
			"UploadMolecule",
			"UploadStockSolution",
			"UploadJournalOptions",
			"ValidUploadJournalQ"
		},
		Author -> {"lei.tian", "andrey.shur", "thomas"}
	}
];


(* ::Subsubsection::Closed:: *)
(*UploadJournalOptions*)


DefineUsage[UploadJournalOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadJournalOptions[journalName]", "resolvedOptions"},
				Description -> "returns the resolve options when calling UploadJournal.",
				Inputs :> {
					{
						InputName -> "journalName",
						Widget -> Widget[
							Type -> String,
							Pattern :> _String,
							Size -> Line
						],
						Description -> "The name of this journal."
					}
				},
				Outputs :> {
					{
						OutputName -> "resolvedOptions",
						Description -> "Resolved options when UploadJournal is called on the input.",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {

		},
		SeeAlso -> {
			"UploadJournal",
			"ValidUploadJournalQ",
			"UploadMolecule",
			"UploadStockSolution"
		},
		Author -> {"mohamad.zandian", "hayley", "thomas"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidUploadJournalQ*)


DefineUsage[ValidUploadJournalQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidUploadJournalQ[journalName]", "bool"},
				Description -> "checks whether the provided 'journalName' is valid for calling UploadJournal.",
				Inputs :> {
					{
						InputName -> "journalName",
						Widget -> Widget[
							Type -> String,
							Pattern :> _String,
							Size -> Line
						],
						Description -> "The name of this journal."
					}
				},
				Outputs :> {
					{
						OutputName -> "bool",
						Description -> "Whether or not the UploadJournal call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary | BooleanP
					}
				}
			}
		},
		MoreInformation -> {

		},
		SeeAlso -> {
			"UploadJournal",
			"UploadMolecule",
			"UploadStockSolution"
		},
		Author -> {"mohamad.zandian", "hayley", "thomas"}
	}
];



(* ::Subsubsection::Closed:: *)
(*ExportReport*)


DefineUsage[ExportReport,
	{
		BasicDefinitions -> {
			{"ExportReport[filePath,reportContents]", "report", "returns a 'report' containing the specified 'reportContents'."}
		},
		Input :> {
			{"filePath", FilePathP, "The file path or file name that the report should be saved to."},
			{"reportContents", {({ReportStyleP, _} | _)..}, "The data to include in the report, with any desired styling."}
		},
		Output :> {
			{"report", FilePathP | EmeraldCloudFileP | Null, "Depending on the options, returns a file path, a cloud file, and/or a new notebook page."}
		},
		SeeAlso -> {
			"PlotTable",
			"PlotObject",
			"Download",
			"Inspect"
		},
		Author -> {"hayley", "mohamad.zandian"}
	}];



(* ::Subsection::Closed:: *)
(*UploadSite*)


(* ::Subsubsection::Closed:: *)
(*Main Function*)


DefineUsage[UploadSite,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadSite[team]", "site"},
				Description -> "create a 'site' that contains address information for 'team'.",
				Inputs :> {
					{
						InputName -> "team",
						Description -> "The team that this site belongs to.",
						Widget -> Widget[
							Type -> Object,
							Pattern :> ObjectP[Object[Team, Financing]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "site",
						Description -> "The new site.",
						Pattern :> ObjectP[Object[Container, Site]]
					}
				}
			},
			{
				Definition -> {"UploadSite[team,site]", "site"},
				Description -> "edit an existing 'site' for 'team'.",
				Inputs :> {
					{
						InputName -> "site",
						Description -> "The site to edit.",
						Widget -> Widget[
							Type -> Object,
							Pattern :> ObjectP[Object[Container, Site]]
						]
					},
					{
						InputName -> "team",
						Description -> "The team that this site belongs to.",
						Widget -> Widget[
							Type -> Object,
							Pattern :> ObjectP[Object[Team, Financing]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "site",
						Description -> "The edited site.",
						Pattern :> ObjectP[Object[Container, Site]]
					}
				}
			}
		},
		SeeAlso -> {
			"Upload",
			"Download",
			"Inspect",
			"ShipToUser"
		},
		Author -> {"mohamad.zandian", "hayley", "thomas"}
	}
];


(* ::Subsubsection::Closed:: *)
(*GetAddressLookupTableJSON*)


DefineUsage[GetAddressLookupTableJSON,
	{
		BasicDefinitions -> {
			{"GetAddressLookupTableJSON[]", "output", "create a lookup up table in JSON format that contains all address for all countries."}
		},
		Input :> {
			{
				"nothing",_,"No input required for this function"
			}
		},
		Output :> {
			{"output",_String,"The format requirements for coutries in the JSON format."}
		},
		SeeAlso -> {
			"UploadSite",
			"Upload",
			"Download",
			"ShipToUser"
		},
		Author -> {
			"weiran.wang"
		}
	}
];


(* ::Subsection::Closed:: *)
(*UploadStorageProperties*)


(* ::Subsubsection::Closed:: *)
(*UploadStorageProperties*)


DefineUsage[UploadStorageProperties,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadStorageProperties[model]", "model"},
				Description -> "updates 'model' with storage parameters specified in the options.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "model",
							Description -> "The model to update storage properties of.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Container], Model[Item], Model[Part], Model[Plumbing], Model[Wiring]}]
							],
							Expandable -> False
						},
						IndexName -> "inputs"
					]
				},
				Outputs :> {
					{
						OutputName -> "model",
						Description -> "The updated model.",
						Pattern :> ObjectP[{Model[Container], Model[Item], Model[Part], Model[Plumbing], Model[Wiring]}]
					}
				}
			}
		},
		SeeAlso -> {
			"OrderSamples",
			"ExperimentStockSolution"
		},
		Author -> {"robert", "alou"}
	}
];