(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*UploadMolecule*)

(* UploadMolecule and sister functions have a lot of shared text, so put in a module and share variables *)
Module[
	{
		inputDescription, inputDescriptionExisting, inputDescriptionOptions, inputValidDescription, moreInformation,
		inputNameDescription, inputAtomicStructureDescription, inputPubChemDescription, inputInChIDescription, inputInChIKeyDescription,
		inputCASDescription, inputThermoDescription, inputSigmaDescription, inputValidDescriptionOptions, inputOptionsDescription,
		inputOptionsDescriptionOptions
	},

	(* Descriptions of test inputs *)
	inputDescription[description_String] := StringJoin[
		"returns a model 'molecule' that contains information specified by the ",
		description,
		" and options and, if a known molecule, information downloaded from the PubChem database."
	];
	
	inputDescriptionExisting = "updates the 'ExistingMolecule' with information specified by the options and, if a known molecule, information downloaded from the PubChem database, returning the 'updatedMolecule'.";
	inputDescriptionOptions = "returns a model 'molecule' that contains the information specified by the options and, if a known molecule, information downloaded from the PubChem database.";

	moreInformation = {
		"Any identifiers supplied, including the common name of the molecule, are searched in the PubChem database. If the compound if known, the PubChem record is downloaded and used to populate any unspecified options.",
		"Note that while the PubChem database is an authoritative source, it is not always complete and the data may be recorded under non-standard conditions, so errors or omissions may occur.",
		"If an identifier is supplied that matches an existing Model[Molecule] in the database, that existing molecule will be updated rather than creating a duplicate."
	};

	inputValidDescription[description_String] := StringJoin[
		"returns a boolean, 'isValidMolecule', that indicates if a valid object will be generated from the input ",
		description,
		" and options and, if a known molecule, information downloaded from the PubChem database."
	];

	inputValidDescriptionOptions = "returns a boolean, 'isValidMolecule', that indicates if a valid object will be generated from the options and, if a known molecule, information downloaded from the PubChem database.";

	inputOptionsDescription[description_String] := StringJoin[
		"returns a list of 'options' as they will be resolved by UploadMolecule, that contains information specified by the ",
		description,
		" and options and, if a known molecule, information downloaded from the PubChem database."
	];

	inputOptionsDescriptionOptions = "returns a list of 'options' as they will be resolved by UploadMolecule, that contains information specified by the options and, if a known molecule, information downloaded from the PubChem database.";


	(* Description of the individual inputs *)
	inputNameDescription = "The common or internal name of this atomic structure.";
	inputAtomicStructureDescription = "The molecular structure of the substance describing the atoms and their connectivity, either drawn or explicitly given using the Molecule[\"..\"] function.";
	inputPubChemDescription = "The record number of the substance in the PubChem database, wrapped in a PubChem[...] head. (e.g. PubChem[679] is the ID of DMSO). PubChem is maintained by the National Center for Biotechnology Information (NCBI) which is part of the United States National Institutes of Health (NIH) and can be accessed at https://pubchem.ncbi.nlm.nih.gov/.";
	inputInChIDescription = "The IUPAC International Chemical Identifier (InChI) of the molecule. InChIs are a unique non-proprietary identifier derived from the structural information of a molecule. The standard is described at https://www.inchi-trust.org/.";
	inputInChIKeyDescription = "The IUPAC International Chemical Identifier Key (InChIKey) of the molecule. InChIKeys are a 27 character fixed-length identifier derived from the InChI using a hash algorithm. InChIKeys are optimized for database searching and are almost certainly unique, however this is not guaranteed. The InChI standard is described at https://www.inchi-trust.org/.";
	inputCASDescription = "The record number of the substance in the Chemical Abstracts Service (CAS) database, maintained by the American Chemical Society (ACS). The CAS registry is described at https://www.cas.org/cas-data/cas-registry.";
	inputThermoDescription = "The URL of the ThermoFisher product page for a product of the required molecule type.";
	inputSigmaDescription = "The URL of the Millipore Sigma product page for a product of the required molecule type.";


	With[
		{
			(* Input widgets - must be := to generate a unique identifier each time it's inserted *)
			moleculeNameWidget := Widget[Type -> String, Pattern :> _String, Size -> Line, PatternTooltip -> "The common or internal name of this chemical."],
			pubChemWidget := Widget[
				Type -> Expression,
				Pattern :> Alternatives[GreaterEqualP[1, 1], _PubChem],
				Size -> Line,
				PatternTooltip -> "Enter the PubChem ID of the chemical to upload, as an integer or wrapped in a PubChem[...] head. (e.g. PubChem[679] is the ID of DMSO)."
			],
			inchiWidget := Widget[
				Type -> String,
				Pattern :> InChIP,
				Size -> Paragraph,
				PatternTooltip -> "The InChI of a molecule is a string that begins with InChI=."
			],
			inchiKeyWidget := Widget[
				Type -> String,
				Pattern :> InChIKeyP,
				Size -> Line,
				PatternTooltip -> "The InChIKey of this molecule, which is in the format of **************-**********-N where * is any uppercase letter."
			],
			casWidget := Widget[
				Type -> String,
				Pattern :> CASNumberP,
				Size -> Line,
				PatternTooltip -> "The CAS registry number of a molecule is a unique identifier specified by the American Chemical Society (ACS). CAS Numbers consist of 3 groups of digits, the first containing 2-7 digits, the second containing 2 digits and the final containing 1 digit, separated by hyphens. CAS numbers therefore range from **-**-* to *******-**-* where * is a digit character."
			],
			thermoWidget := Widget[
				Type -> String,
				Pattern :> ThermoFisherURLP,
				Size -> Paragraph,
				PatternTooltip -> "The URL of the ThermoFisher product page for a product of the required molecule type."
			],
			sigmaWidget := Widget[
				Type -> String,
				Pattern :> MilliporeSigmaURLP,
				Size -> Paragraph,
				PatternTooltip -> "The URL of the Millipore Sigma product page for a product of the required molecule type."
			],
			moleculeObjectWidget := Widget[
				Type -> Object,
				Pattern :> ObjectP[Model[Molecule]],
				ObjectTypes -> {Model[Molecule]}
			],
			moleculeFunctionWidget := Widget[
				Type -> Molecule,
				Pattern :> MoleculeP
			],

			(* Outputs *)
			moleculeOutputData = {
				OutputName -> "molecule",
				Description -> "A model that represents this atomic structure. If an identifier was supplied that matches an existing Model[Molecule] in the database, that existing molecule will be updated rather than creating a duplicate.",
				Pattern :> ObjectP[Model[Molecule]]
			},
			validObjectOutputData = {
				OutputName -> "isValidmolecule",
				Description -> "A boolean that indicates if the resulting Model[Molecule] is valid.",
				Pattern :> BooleanP
			},
			optionsOutputData = {
				OutputName -> "uploadMoleculeOptions",
				Description -> "A list of resolved options as they will be resolved by UploadMolecule[].",
				Pattern :> {Rule..}
			}
		},

		DefineUsage[UploadMolecule,
			{
				BasicDefinitions -> {
					{
						Definition -> {"UploadMolecule[MoleculeName]", "molecule"},
						Description -> inputDescription["'MoleculeName'"],
						MoreInformation -> moreInformation,
						Inputs :> {
							IndexMatching[
								{
									InputName -> "MoleculeName",
									Description -> inputNameDescription,
									Widget -> moleculeNameWidget
								},
								IndexName -> "Input Data"
							]
						},
						Outputs :> {
							moleculeOutputData
						}
					},
					{
						Definition -> {"UploadMolecule[AtomicStructure]", "molecule"},
						Description -> inputDescription["'AtomicStructure'"] <> " The molecular structure can either be drawn or explicitly given using the Molecule[\"..\"] function.",
						MoreInformation -> moreInformation,
						Inputs :> {
							IndexMatching[
								{
									InputName -> "AtomicStructure",
									Description -> inputAtomicStructureDescription,
									Widget -> moleculeFunctionWidget
								},
								IndexName -> "Input Data"
							]
						},
						Outputs :> {
							moleculeOutputData
						}
					},
					{
						Definition -> {"UploadMolecule[PubChem]", "molecule"},
						Description -> inputDescription["'PubChem' identifier"],
						MoreInformation -> moreInformation,
						Inputs :> {
							IndexMatching[
								{
									InputName -> "PubChem",
									Description -> inputPubChemDescription,
									Widget -> pubChemWidget
								},
								IndexName -> "Input Data"
							]
						},
						Outputs :> {
							moleculeOutputData
						}
					},
					{
						Definition -> {"UploadMolecule[MoleculeInChI]", "molecule"},
						Description -> inputDescription["'MoleculeInChI' IUPAC International Chemical Identifier"],
						MoreInformation -> moreInformation,
						Inputs :> {
							IndexMatching[
								{
									InputName -> "MoleculeInChI",
									Description -> inputInChIDescription,
									Widget -> inchiWidget
								},
								IndexName -> "Input Data"
							]
						},
						Outputs :> {
							moleculeOutputData
						}
					},
					{
						Definition -> {"UploadMolecule[MoleculeInChIKey]", "molecule"},
						Description -> inputDescription["'MoleculeInChIKey' IUPAC International Chemical Identifier Key"],
						MoreInformation -> moreInformation,
						Inputs :> {
							IndexMatching[
								{
									InputName -> "MoleculeInChIKey",
									Description -> inputInChIKeyDescription,
									Widget -> inchiKeyWidget
								},
								IndexName -> "Input Data"
							]
						},
						Outputs :> {
							moleculeOutputData
						}
					},
					{
						Definition -> {"UploadMolecule[MoleculeCAS]", "molecule"},
						Description -> inputDescription["'MoleculeCAS' Chemical Abstracts Service registry number"],
						MoreInformation -> moreInformation,
						Inputs :> {
							IndexMatching[
								{
									InputName -> "MoleculeCAS",
									Description -> inputCASDescription,
									Widget -> casWidget
								},
								IndexName -> "Input Data"
							]
						},
						Outputs :> {
							moleculeOutputData
						}
					},
					{
						Definition -> {"UploadMolecule[ThermoFisherURL]", "molecule"},
						Description -> inputDescription["product on the webpage 'ThermoFisherURL'"],
						MoreInformation -> moreInformation,
						Inputs :> {
							IndexMatching[
								{
									InputName -> "ThermoFisherURL",
									Description -> inputThermoDescription,
									Widget -> thermoWidget
								},
								IndexName -> "Input Data"
							]
						},
						Outputs :> {
							moleculeOutputData
						}
					},
					{
						Definition -> {"UploadMolecule[MilliporeSigmaURL]", "molecule"},
						Description -> inputDescription["product on the webpage 'MilliporeSigmaURL'"],
						MoreInformation -> moreInformation,
						Inputs :> {
							IndexMatching[
								{
									InputName -> "MilliporeSigmaURL",
									Description -> inputSigmaDescription,
									Widget -> sigmaWidget
								},
								IndexName -> "Input Data"
							]
						},
						Outputs :> {
							moleculeOutputData
						}
					},
					{
						Definition -> {"UploadMolecule[ExistingMolecule]", "updatedMolecule"},
						Description -> inputDescriptionExisting,
						MoreInformation -> moreInformation,
						Inputs :> {
							IndexMatching[
								{
									InputName -> "ExistingMolecule",
									Description -> "An existing object to update.",
									Widget -> moleculeObjectWidget
								},
								IndexName -> "Input Data"
							]
						},
						Outputs :> {
							{
								OutputName -> "updatedMolecule",
								Description -> "The updated input molecule after the changes have been applied.",
								Pattern :> ObjectP[Model[Molecule]]
							}
						}
					},
					{
						Definition -> {"UploadMolecule[]", "molecule"},
						Description -> inputDescriptionOptions,
						MoreInformation -> moreInformation,
						Inputs :> {},
						Outputs :> {
							moleculeOutputData
						}
					},
					(* The following is a definition where the user can specify a list of any of the above inputs.*)
					(* We need this definition because otherwise, the user can only specify a list of the same inputs {myTemplate1, myTemplate2...} and can't do {myTemplate1, myCAS2, myInChI3...}. *)
					{
						Definition -> {"UploadMolecule[ListOfInputs]", "molecules"},
						Description -> "returns a list of 'molecules' that contains the information specified by the 'ListOfInputs' and options and, for known molecules, information downloaded from the PubChem database.",
						MoreInformation -> moreInformation,
						Inputs :> {
							IndexMatching[
								{
									InputName -> "ListOfInputs",
									Description -> "A list of inputs to base the creation of new molecule models on.",
									Widget -> Alternatives[
										moleculeNameWidget,
										pubChemWidget,
										inchiWidget,
										inchiKeyWidget,
										casWidget,
										thermoWidget,
										sigmaWidget,
										moleculeObjectWidget,
										moleculeFunctionWidget,
										(* Allow null inputs so that all information can be specified by options *)
										Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
									],
									Expandable -> True
								},
								IndexName -> "Input Data"
							]
						},
						Outputs :> {
							moleculeOutputData
						}
					}
				},
				SeeAlso -> {
					"UploadSampleModel",
					"UploadCompanySupplier",
					"UploadProduct",
					"Upload",
					"Download",
					"Inspect"
				},
				Author -> {
					"david.ascough",
					"lei.tian",
					"lige.tonggu"
				}
			}
		];


		DefineUsage[ValidUploadMoleculeQ,
			{
				BasicDefinitions -> {
					{
						Definition -> {"ValidUploadMoleculeQ[MoleculeName]", "isValidmolecule"},
						Description -> inputValidDescription["'MoleculeName'"],
						Inputs :> {
							{
								InputName -> "MoleculeName",
								Description -> inputNameDescription,
								Widget -> moleculeNameWidget
							}
						},
						Outputs :> {
							validObjectOutputData
						}
					},
					{
						Definition -> {"ValidUploadMoleculeQ[InChI]", "isValidmolecule"},
						Description -> inputValidDescription["'InChI'"],
						Inputs :> {
							{
								InputName -> "InChI",
								Description -> inputInChIDescription,
								Widget -> inchiWidget
							}
						},
						Outputs :> {
							validObjectOutputData
						}
					},
					{
						Definition -> {"ValidUploadMoleculeQ[InChIKey]", "isValidmolecule"},
						Description -> inputValidDescription["'InChIKey'"],
						Inputs :> {
							{
								InputName -> "InChIKey",
								Description -> inputInChIKeyDescription,
								Widget -> inchiKeyWidget
							}
						},
						Outputs :> {
							validObjectOutputData
						}
					},
					{
						Definition -> {"ValidUploadMoleculeQ[CASNumber]", "isValidmolecule"},
						Description -> inputValidDescription["'CASNumber'"],
						Inputs :> {
							{
								InputName -> "CASNumber",
								Description -> inputCASDescription,
								Widget -> casWidget
							}
						},
						Outputs :> {
							validObjectOutputData
						}
					},
					{
						Definition -> {"ValidUploadMoleculeQ[ThermoFisherURL]", "isValidmolecule"},
						Description -> inputValidDescription["'ThermoFisherURL'"],
						Inputs :> {
							{
								InputName -> "ThermoFisherURL",
								Description -> inputThermoDescription,
								Widget -> thermoWidget
							}
						},
						Outputs :> {
							validObjectOutputData
						}
					},
					{
						Definition -> {"ValidUploadMoleculeQ[MilliporeSigmaURL]", "isValidmolecule"},
						Description -> inputValidDescription["'MilliporeSigamURL'"],
						Inputs :> {
							{
								InputName -> "MilliporeSigmaURL",
								Description -> inputSigmaDescription,
								Widget -> sigmaWidget
							}
						},
						Outputs :> {
							validObjectOutputData
						}
					},
					{
						Definition -> {"ValidUploadMoleculeQ[]", "isValidmolecule"},
						Description -> inputValidDescriptionOptions,
						Inputs :> {},
						Outputs :> {
							validObjectOutputData
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
					"david.ascough",
					"lei.tian",
					"lige.tonggu"
				}
			}
		];


		DefineUsage[UploadMoleculeOptions,
			{
				BasicDefinitions -> {
					{
						Definition -> {"UploadMoleculeOptions[MoleculeName]", "uploadMoleculeOptions"},
						Description -> inputOptionsDescription["'MoleculeName'"],
						Inputs :> {
							{
								InputName -> "MoleculeName",
								Description -> inputNameDescription,
								Widget -> moleculeNameWidget
							}
						},
						Outputs :> {
							optionsOutputData
						}
					},
					{
						Definition -> {"UploadMoleculeOptions[InChI]", "uploadMoleculeOptions"},
						Description -> inputOptionsDescription["'InChI'"],
						Inputs :> {
							{
								InputName -> "InChI",
								Description -> inputInChIDescription,
								Widget -> inchiWidget
							}
						},
						Outputs :> {
							optionsOutputData
						}
					},
					{
						Definition -> {"UploadMoleculeOptions[InChIKey]", "uploadMoleculeOptions"},
						Description -> inputOptionsDescription["'InChIKey'"],
						Inputs :> {
							{
								InputName -> "InChIKey",
								Description -> inputInChIKeyDescription,
								Widget -> inchiKeyWidget
							}
						},
						Outputs :> {
							optionsOutputData
						}
					},
					{
						Definition -> {"UploadMoleculeOptions[CASNumber]", "uploadMoleculeOptions"},
						Description -> inputOptionsDescription["'CASNumber'"],
						Inputs :> {
							{
								InputName -> "CASNumber",
								Description -> inputCASDescription,
								Widget -> casWidget
							}
						},
						Outputs :> {
							optionsOutputData
						}
					},
					{
						Definition -> {"UploadMoleculeOptions[ThermoFisherURL]", "uploadMoleculeOptions"},
						Description -> inputOptionsDescription["'ThermoFisherURL'"],
						Inputs :> {
							{
								InputName -> "ThermoFisherURL",
								Description -> inputThermoDescription,
								Widget -> thermoWidget
							}
						},
						Outputs :> {
							optionsOutputData
						}
					},
					{
						Definition -> {"UploadMoleculeOptions[MilliporeSigmaURL]", "uploadMoleculeOptions"},
						Description -> inputOptionsDescription["'MilliporeSigmaURL'"],
						Inputs :> {
							{
								InputName -> "MilliporeSigmaURL",
								Description -> inputSigmaDescription,
								Widget -> sigmaWidget
							}
						},
						Outputs :> {
							optionsOutputData
						}
					},
					{
						Definition -> {"UploadMoleculeOptions[]", "uploadMoleculeOptions"},
						Description -> inputOptionsDescriptionOptions,
						Inputs :> {},
						Outputs :> {
							optionsOutputData
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
					"david.ascough",
					"lei.tian",
					"lige.tonggu"
				}
			}
		];

	];
];