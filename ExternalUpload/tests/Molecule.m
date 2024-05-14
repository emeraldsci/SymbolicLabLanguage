(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*UploadMolecule*)


(* ::Subsubsection::Closed:: *)
(*UploadMolecule*)


DefineTests[
	UploadMolecule,
	{
		Example[{Basic, "Upload a new Model[Molecule] of DMSO by its name:"},
			UploadMolecule["DMSO",
				Name -> "DMSO (test for UploadMolecule) 1 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard",
				NFPA -> {2, 2, 0, {}},
				MSDSFile -> "https://www.caymanchem.com/msdss/700001m.pdf",
				IncompatibleMaterials -> {None}
			],
			ObjectP[Model[Molecule]]
		],
		Example[{Basic, "Upload a new Model[Molecule] of Aspartic Acid by its PubChem ID:"},
			UploadMolecule[PubChem[5960], Name -> "Aspartic Acid (test for UploadMolecule) 2 " <> $SessionUUID, BiosafetyLevel -> "BSL-1", IncompatibleMaterials -> {None}, MSDSRequired -> False],
			ObjectP[Model[Molecule]]
		],
		Example[{Basic, "Upload a new Model[Molecule] of L-Serine by its InChI:"},
			UploadMolecule["InChI=1S/C3H7NO3/c4-2(1-5)3(6)7/h2,5H,1,4H2,(H,6,7)/t2-/m0/s1", Name -> "L-Serine (test for UploadMolecule) 3 " <> $SessionUUID, BiosafetyLevel -> "BSL-1", IncompatibleMaterials -> {None}, MSDSRequired -> False],
			ObjectP[Model[Molecule]]
		],
		Example[{Basic, "Upload a new Model[Molecule] of Arginine by its CAS:"},
			UploadMolecule["74-79-3", Name -> "Arginine (test for UploadMolecule) 4 " <> $SessionUUID, BiosafetyLevel -> "BSL-1", IncompatibleMaterials -> {None}, MSDSRequired -> False],
			ObjectP[Model[Molecule]]
		],
		Example[{Basic, "Upload a new Model[Molecule] of Allylamine by its Sigma Aldrich product URL:"},
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/aldrich/145831?lang=en&region=US",
				Name -> "Allylamine (test for UploadMolecule) 5 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				MSDSRequired -> False,
				NFPA -> {4, 3, 1, {}},
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard"
			],
			ObjectP[Model[Molecule]]
		],
		Example[{Additional, "Upload a new Model[Molecule] of Taxol by its InChI Key:"},
			UploadMolecule[
				"RCINICONZNJXQF-MZXODVADSA-N",
				Name -> "Taxol (test for UploadMolecule) 6 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				NFPA -> {3, 0, 0, {}},
				MSDSFile -> "https://assets.thermofisher.com/TFS-Assets/LSG/SDS/P3456_MTR-NALT_EN.pdf",
				IncompatibleMaterials -> {None},
				Flammable -> False,
				DOTHazardClass -> "Class 0",
				State -> Solid
			],
			ObjectP[Model[Molecule]]
		],
		Example[{Additional, "Upload a new Model[Molecule] of DMSO by its ThermoFisher product URL:"},
			UploadMolecule["https://www.thermofisher.com/order/catalog/product/85190",
				Name -> "DMSO (test for UploadMolecule) 7 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard",
				NFPA -> {2, 2, 0, {}},
				MSDSFile -> "https://www.caymanchem.com/msdss/700001m.pdf"
			],
			ObjectP[Model[Molecule]]
		],
		Example[{Additional, "Upload a new Model[Molecule] of Water by its Molecule:"},
			UploadMolecule[Molecule["Water"],
				Name -> "Water (test for UploadMolecule) 8 " <> $SessionUUID,
				IncompatibleMaterials -> {None},
				MSDSRequired -> False,
				State -> Liquid,
				BiosafetyLevel -> "BSL-1"
			],
			ObjectP[Model[Molecule]]
		],
		Example[{Additional, "Use the listable version of UploadMolecule to upload multiple chemicals:"},
			UploadMolecule[{"DMSO", "DMSO"},
				Name -> {"DMSO (test 1 for UploadMolecule) 9 " <> $SessionUUID, "DMSO (test 2 for UploadMolecule) 10 " <> $SessionUUID},
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard",
				NFPA -> {2, 2, 0, {}},
				MSDSFile -> "https://www.caymanchem.com/msdss/700001m.pdf"
			],
			{ObjectP[Model[Molecule]], ObjectP[Model[Molecule]]}
		],
		Test["Test the listable output of UploadMolecule:",
			UploadMolecule[{"DMSO", "DMSO"},
				Name -> {"DMSO (test 1 for UploadMolecule) 11 " <> $SessionUUID, "DMSO (test 2 for UploadMolecule) 12 " <> $SessionUUID},
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard",
				NFPA -> {2, 2, 0, {}},
				MSDSFile -> "https://www.caymanchem.com/msdss/700001m.pdf",
				Output -> {Result, Options, Tests}
			],
			{{ObjectP[Model[Molecule]], ObjectP[Model[Molecule]]}, {_Rule..}, {_EmeraldTest..}}
		],
		Example[{Options, "Name", "Use the Name option to set the name of this uploaded chemical:"},
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/aldrich/145831?lang=en&region=US",
				Name -> "Allylamine (test for UploadMolecule) 13 "<> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				NFPA -> {4, 3, 1, {}},
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard"
			],
			ObjectP[Model[Molecule, "Allylamine (test for UploadMolecule) 13 " <> $SessionUUID]]
		],
		Example[{Options, "Synonyms", "Use the Synonyms option to set the synonyms of this uploaded chemical:"},
			UploadMolecule["74-79-3",
				Name -> "Arginine (test for UploadMolecule) 14 " <> $SessionUUID,
				Synonyms -> {"Arginine (test for UploadMolecule) 14 " <> $SessionUUID, "L-arginine", "arginine", "Arginine", "74-79-3", "L arginine", "Arg"},
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None}
			],
			ObjectP[Model[Molecule, "Arginine (test for UploadMolecule) 14 " <> $SessionUUID]]
		],
		Example[{Options, "UNII", "Use the UNII option to set the UNII of this uploaded chemical:"},
			UploadMolecule["DMSO",
				Name -> "DMSO (test for UploadMolecule) 15 " <> $SessionUUID,
				UNII -> "YOW8V9698H",
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard",
				NFPA -> {2, 2, 0, {}},
				MSDSFile -> "https://www.caymanchem.com/msdss/700001m.pdf"
			],
			ObjectP[Model[Molecule, "DMSO (test for UploadMolecule) 15 " <> $SessionUUID]]
		],
		Example[{Options, "InChI", "Use the InChI option to set the InChI of this uploaded chemical. InChI is a unique chemical identifier for a chemical, each chemical has a unique InChI:"},
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/aldrich/145831?lang=en&region=US",
				InChI -> "InChI=1S/C3H7N/c1-2-3-4/h2H,1,3-4H2",
				Name -> "Allylamine (test for UploadMolecule) 16 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				NFPA -> {4, 3, 1, {}},
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard"
			],
			ObjectP[Model[Molecule, "Allylamine (test for UploadMolecule) 16 " <> $SessionUUID]]
		],
		Example[{Options, "InChIKey", "Use the InChIKey option to set the InChIKey of this uploaded chemical. InChIKey is a unique chemical identifier for a chemical, each chemical has a unique InChIKey:"},
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/aldrich/145831?lang=en&region=US",
				InChIKey -> "VVJKKWFAADXIJK-UHFFFAOYSA-N",
				Name -> "Allylamine (test for UploadMolecule) 17 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",

				IncompatibleMaterials -> {None},
				NFPA -> {4, 3, 1, {}},
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard"
			],
			ObjectP[Model[Molecule, "Allylamine (test for UploadMolecule) 17 " <> $SessionUUID]]
		],
		Example[{Options, "CAS", "Use the CAS option to set the CAS number of this uploaded chemical:"},
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/aldrich/145831?lang=en&region=US",
				CAS -> "107-11-9",
				Name -> "Allylamine (test for UploadMolecule) 18 "<> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				NFPA -> {4, 3, 1, {}},
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard"
			],
			ObjectP[Model[Molecule, "Allylamine (test for UploadMolecule) 18 " <> $SessionUUID]]
		],
		Example[{Options, "IUPAC", "Use the IUPAC option to set the IUPAC name of this uploaded chemical:"},
			UploadMolecule["InChI=1S/C6H14N2O2/c7-4-2-1-3-5(8)6(9)10/h5H,1-4,7-8H2,(H,9,10)/t5-/m0/s1",
				IUPAC -> "(2S)-2,6-diaminohexanoic acid",
				BiosafetyLevel -> "BSL-1",
				Name -> "Lysine (test for UploadMolecule) 19 "<> $SessionUUID,
				IncompatibleMaterials -> {None}
			],
			ObjectP[Model[Molecule, "Lysine (test for UploadMolecule) 19 "<> $SessionUUID]]
		],
		Example[{Options, "MonomerSymbol", "Use the MonomerSymbol option to set the monomer symbol of this uploaded chemical. The MonomerSymbol field is used when constructing higher level macromolecules:"},
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/aldrich/145831?lang=en&region=US",
				Name -> "Allylamine (test for UploadMolecule) 20 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				NFPA -> {4, 3, 1, {}},
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard"
			],
			ObjectP[Model[Molecule, "Allylamine (test for UploadMolecule) 20 " <> $SessionUUID]]
		],
		Example[{Options, "MolecularFormula", "Use the MolecularFormula option to set the Molecular Formula of this uploaded chemical:"},
			UploadMolecule["Lysine",
				MolecularFormula -> "C6H14N2O2",
				Name -> "Lysine (test for UploadMolecule) 21 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None}
			],
			ObjectP[Model[Molecule, "Lysine (test for UploadMolecule) 21 " <> $SessionUUID]]
		],
		Example[{Options, "MolecularWeight", "Use the MolecularWeight option to set the Molecular Weight of this uploaded chemical:"},
			UploadMolecule["DMF", MolecularWeight -> 73.095 Gram / Mole,
				Name -> "DMF (test for UploadMolecule) 22 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				MSDSFile -> "http://www.sciencelab.com/msds.php?msdsId=9923813"
			],
			ObjectP[Model[Molecule, "DMF (test for UploadMolecule) 22 " <> $SessionUUID]]
		],
		Example[{Options, "ExactMass", "Use the ExactMass option to set the exact mass of this uploaded chemical:"},
			UploadMolecule["Thiophene",
				ExactMass -> 84.003371 Gram / Mole,
				Name -> "Thiophene (test for UploadMolecule) 23 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1", IncompatibleMaterials -> {None},
				MSDSFile -> "https://www.emdmillipore.com/US/en/product/msds/MDA_CHEM-808157"
			],
			ObjectP[Model[Molecule, "Thiophene (test for UploadMolecule) 23 " <> $SessionUUID]]
		],
		Example[{Options, "State", "Use the State option to set the state of matter (Solid, Liquid, Gas) of this uploaded chemical:"},
			UploadMolecule["DMSO",
				State -> Liquid,
				Name -> "DMSO (test for UploadMolecule) 24 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				MSDSFile -> "http://www.sciencelab.com/msds.php?msdsId=9923813",
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard",
				NFPA -> {2, 2, 0, {}}
			],
			ObjectP[Model[Molecule, "DMSO (test for UploadMolecule) 24 " <> $SessionUUID]]
		],
		Example[{Options, "Density", "Use the Density option to set the density of this uploaded chemical:"},
			UploadMolecule["DMSO", Density -> 1.10 Gram / (Centimeter^3),
				State -> Liquid,
				Name -> "DMSO (test for UploadMolecule) 25 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				MSDSFile -> "http://www.sciencelab.com/msds.php?msdsId=9923813",
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard",
				NFPA -> {2, 2, 0, {}}
			],
			ObjectP[Model[Molecule, "DMSO (test for UploadMolecule) 25 " <> $SessionUUID]]
		],
		Example[{Options, "ExtinctionCoefficients", "Use the ExtinctionCoefficients option to set the Extinction Coefficient of this uploaded chemical. This field is in the format {{Wavelength,ExtinctionCoefficient}..}:"},
			UploadMolecule["Adenine",
				ExtinctionCoefficients -> {{260 Nanometer, 13400 Liter / (Centimeter * Mole)}},
				Name -> "Adenine (test for UploadMolecule) 26 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				MSDSFile -> "https://www.fishersci.com/store/msds?partNumber=AC348550250&productDescription=ADENINE%2C+99%25+25GR&vendorId=VN00032119&countryCode=US&language=en",
				NFPA -> {3, 1, 0, {}},
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard"
			],
			ObjectP[Model[Molecule, "Adenine (test for UploadMolecule) 26 " <> $SessionUUID]]
		],
		Example[{Options, "StructureImageFile", "Use the StructureImageFile option to provide an image of the chemical's structure:"},
			UploadMolecule["617-45-8",
				Name -> "Aspartic Acid (test for UploadMolecule) 27 " <> $SessionUUID,
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				StructureImageFile -> "https://upload.wikimedia.org/wikipedia/commons/a/a1/Aspartic_Acidph.png"
			],
			ObjectP[Model[Molecule, "Aspartic Acid (test for UploadMolecule) 27 " <> $SessionUUID]]
		],
		Example[{Options, "StructureFile", "Use the StructureFile option to provide the URL of a MOL file of the chemical's structure:"},
			UploadMolecule["Glutamic acid",
				Name -> "Glutamic acid (test for UploadMolecule) 28 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",

				IncompatibleMaterials -> {None},
				StructureFile -> "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/33032/record/SDF/?record_type=2d&response_type=display"
			],
			ObjectP[Model[Molecule, "Glutamic acid (test for UploadMolecule) 28 " <> $SessionUUID]]
		],
		Example[{Options, "MeltingPoint", "Use the MeltingPoint option to provide the temperature at which the solid form of Tyrosine will melt:"},
			UploadMolecule["Tyrosine",
				MeltingPoint -> 343.5 Celsius,
				Name -> "Tyrosine (test for UploadMolecule) 29 "<> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None}
			],
			ObjectP[Model[Molecule, "Tyrosine (test for UploadMolecule) 29 " <> $SessionUUID]]
		],
		Example[{Options, "BoilingPoint", "Use the BoilingPoint option to provide the temperature at which the liquid form of DMSO will evaporate:"},
			UploadMolecule["DMSO",
				BoilingPoint -> 189 Celsius,
				Name -> "DMSO (test for UploadMolecule) 30 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard",
				NFPA -> {2, 2, 0, {}}
			],
			ObjectP[Model[Molecule, "DMSO (test for UploadMolecule) 30 " <> $SessionUUID]]
		],
		Example[{Options, "VaporPressure", "Use the VaporPressure option to provide the equilibrium pressure of DMSO when it is in thermodynamic equilibrium with its condensed phase:"},
			UploadMolecule["DMSO",
				Name -> "DMSO (test for UploadMolecule) 31 " <> $SessionUUID,
				VaporPressure -> 0.049 Kilo * Pascal ,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard",
				NFPA -> {2, 2, 0, {}},
				MSDSFile -> "https://www.caymanchem.com/msdss/700001m.pdf"
			],
			ObjectP[Model[Molecule, "DMSO (test for UploadMolecule) 31 " <> $SessionUUID]]
		],
		Example[{Options, "Viscosity", "Use the Viscosity option to provide Water's internal friction, measured by the force per unit area resisting a flow between parallel layers of liquid:"},
			UploadMolecule["Water" ,
				Name -> "Water (test for UploadMolecule) 33 " <> $SessionUUID,
				Viscosity -> Quantity[0.8949, "Centipoise"],
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				MSDSRequired -> False,
				Flammable -> False
			],
			ObjectP[Model[Molecule, "Water (test for UploadMolecule) 33 " <> $SessionUUID]]
		],
		Example[{Options, "pKa", "Use the pKa option to specify the logarithmic acid dissociation constant of Glycine:"},
			UploadMolecule["Glycine",
				Name -> "Glycine (test for UploadMolecule) 34 " <> $SessionUUID,
				pKa -> {2.37},
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None}
			],
			ObjectP[Model[Molecule, "Glycine (test for UploadMolecule) 34 " <> $SessionUUID]]
		],
		Example[{Options, "Radioactive", "Use the Radioactive option to specify if the chemical sample is radioactive:"},
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/sigma/w3500?lang=en&region=US",
				Name -> "Water (test for UploadMolecule) 35 " <> $SessionUUID,
				Radioactive -> True,
				MSDSRequired -> False,
				Flammable -> False,
				Fuming -> False,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None}
			],
			ObjectP[Model[Molecule, "Water (test for UploadMolecule) 35 " <> $SessionUUID]]
		],
		Example[{Options, "Flammable", "Use the Flammable option to specify that the chemical is flammable:"},
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/sigald/e7023?lang=en&region=US",
				Name -> "Ethanol (test for UploadMolecule) 36 " <> $SessionUUID,
				Flammable -> True,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard",
				NFPA -> {2, 3, 0, {}}
			],
			ObjectP[Model[Molecule, "Ethanol (test for UploadMolecule) 36 " <> $SessionUUID]]
		],
		Example[{Options, "Acid", "Use the Acid option to specify that the chemical is a strong acid:"},
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/aldrich/339741?lang=en&region=US",
				Name -> "Sulfuric acid (test for UploadMolecule) 37 " <> $SessionUUID,
				Acid -> True,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard",
				NFPA -> {3, 0, 0, {}}
			],
			ObjectP[Model[Molecule, "Sulfuric acid (test for UploadMolecule) 37 " <> $SessionUUID]]
		],
		Example[{Options, "Base", "Use the Base option to specify that the chemical is a strong base:"},
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/sigma/s0899?lang=en&region=US",
				Name -> "Sodium hydroxide (test for UploadMolecule) 38 " <> $SessionUUID,
				Base -> True,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				DOTHazardClass -> "Class 8 Division 8 Corrosives Hazard",
				NFPA -> {3, 0, 1, {}}
			],
			ObjectP[Model[Molecule, "Sodium hydroxide (test for UploadMolecule) 38 " <> $SessionUUID]]
		],
		Example[{Options, "Pyrophoric", "Use the Pyrophoric option to specify that the chemical ignites spontaneously with contact with air:"},
			UploadMolecule["https://www.sigmaaldrich.com/US/en/product/sial/282065?lang=en&region=US",
				Name -> "Sodium (test for UploadMolecule) 39 " <> $SessionUUID,
				Pyrophoric -> True,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				DOTHazardClass -> "Class 4 Division 4.3 Dangerous when Wet Hazard",
				NFPA -> {3, 3, 2, {WaterReactive}},
				MSDSFile -> "https://www.sigmaaldrich.com/US/en/sds/sial/282065"
			],
			ObjectP[Model[Molecule, "Sodium (test for UploadMolecule) 39 " <> $SessionUUID]]
		],
		Example[{Options, "WaterReactive", "Use the WaterReactive option to specify that the chemical reacts violently with contact with water:"},
			UploadMolecule["https://www.sigmaaldrich.com/US/en/product/sial/282065?lang=en&region=US",
				WaterReactive -> True,
				Name -> "Sodium (test for UploadMolecule) 40 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				DOTHazardClass -> "Class 4 Division 4.3 Dangerous when Wet Hazard",
				NFPA -> {3, 3, 2, {WaterReactive}},
				MSDSFile -> "https://www.sigmaaldrich.com/US/en/sds/sial/282065"
			],
			ObjectP[Model[Molecule, "Sodium (test for UploadMolecule) 40 " <> $SessionUUID]]
		],
		Example[{Options, "Fuming", "Use the Fuming option to specify that the chemical sample produces fumes when exposed to air:"},
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/aldrich/339741?lang=en&region=US",
				Name -> "Sulfuric acid (test for UploadMolecule) 41 " <> $SessionUUID,
				Fuming -> True,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard",
				NFPA -> {3, 0, 0, {}}
			],
			ObjectP[Model[Molecule, "Sulfuric acid (test for UploadMolecule) 41 " <> $SessionUUID]]
		],
		Example[{Options, "Ventilated", "Use the Ventilated option to specify that the chemical sample needs to be handled in a ventilated enclosure:"},
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/aldrich/339741?lang=en&region=US",
				Name -> "Sulfuric acid (test for UploadMolecule) 42 " <> $SessionUUID,
				Ventilated -> True,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard",
				NFPA -> {3, 0, 0, {}},
				MSDSFile -> "https://www.sigmaaldrich.com/US/en/sds/aldrich/339741"
			],
			ObjectP[Model[Molecule, "Sulfuric acid (test for UploadMolecule) 42 " <> $SessionUUID]]
		],
		Example[{Options, "Pungent", "Use the Pungent option to indicate that the sample has a strong odor:"},
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/aldrich/w372218?lang=en&region=US",
				Name -> "cis-5-Octen-1-ol (test for UploadMolecule) 44 " <> $SessionUUID,
				Ventilated -> True,
				Pungent -> True,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard",
				NFPA -> {2, 2, 0, {}},
				MSDSFile -> "https://www.sigmaaldrich.com/US/en/sds/aldrich/w372218"
			];
			Download[Model[Molecule, "cis-5-Octen-1-ol (test for UploadMolecule) 44 " <> $SessionUUID], Pungent],
			True
		],
		Example[{Options, "ParticularlyHazardousSubstance", "Use the ParticularlyHazardousSubstance option to specify that special precautions should be taken in handling this substance. This option should be set if the GHS Classification of the chemical is any of the following: Reproductive Toxicity (H340, H360, H362),  Acute Toxicity (H300, H310, H330, H370, H373), Carcinogenicity (H350):"},
			UploadMolecule["https://www.sigmaaldrich.com/US/en/substance/formaldehydesolution300350000",
				ParticularlyHazardousSubstance -> True,
				Name -> "Formaldehyde (test for UploadMolecule) 45 " <> $SessionUUID,
				DOTHazardClass -> "Class 7 Division 7 Radioactive Material Hazard",
				NFPA -> {3, 0, 0, {}},
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				State -> Liquid,
				Synonyms -> {"Formaldehyde (test for UploadMolecule) 45 " <> $SessionUUID, "Formaldehyde"},
				IncompatibleMaterials -> {None},
				MSDSFile -> "https://www.fishersci.com/store/msds?partNumber=S25329&productDescription=formaldehyde-solution-&vendorId=VN00115888&keyword=true&countryCode=US&language=en"
			],
			ObjectP[Model[Molecule, "Formaldehyde (test for UploadMolecule) 45 " <> $SessionUUID]]
		],
		Example[{Options, "DrainDisposal", "Use the DrainDisposal option to specify that this chemical sample can be safely disposed down a standard drain:"},
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/sigma/w3500?lang=en&region=US",
				DrainDisposal -> True,
				Name -> "Water (test for UploadMolecule) 46 " <> $SessionUUID,
				MSDSRequired -> False,
				Flammable -> False,
				Fuming -> False,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None}
			],
			ObjectP[Model[Molecule, "Water (test for UploadMolecule) 46 " <> $SessionUUID]]
		],
		Example[{Options, "MSDSRequired", "Use the MSDSRequired option to indicate that an MSDS file must be supplied for this chemical sample. An MSDS file is required by SLL the chemical is detected to be hazardous, however, it is best to always provide an MSDS when possible:"},
			UploadMolecule["https://www.sigmaaldrich.com/US/en/substance/formaldehydesolution300350000",
				MSDSRequired -> True,
				MSDSFile -> "http://www.sciencelab.com/msds.php?msdsId=9924095",
				Name -> "Formaldehyde (test for UploadMolecule) 47 " <> $SessionUUID,
				ParticularlyHazardousSubstance -> True,
				DOTHazardClass -> "Class 7 Division 7 Radioactive Material Hazard",
				NFPA -> {3, 0, 0, {}},
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				State -> Liquid,
				Synonyms -> {"Formaldehyde (test for UploadMolecule) 47 " <> $SessionUUID, "Formaldehyde"},
				IncompatibleMaterials -> {None}
			],
			ObjectP[Model[Molecule, "Formaldehyde (test for UploadMolecule) 47 " <> $SessionUUID]]
		],
		Example[{Options, "MSDSFile", "Use the MSDSFile option to specify the URL of the MSDS PDF file for this chemical sample. The MSDSFile must be a URL that points to a PDF file. The PDF file will be downloaded and stored in Constellation on creation of this chemical model:"},
			UploadMolecule["https://www.sigmaaldrich.com/US/en/substance/formaldehydesolution300350000",
				MSDSRequired -> True,
				MSDSFile -> "http://www.sciencelab.com/msds.php?msdsId=9924095",
				Name -> "Formaldehyde (test for UploadMolecule) 48 " <> $SessionUUID,
				ParticularlyHazardousSubstance -> True,
				DOTHazardClass -> "Class 7 Division 7 Radioactive Material Hazard",
				NFPA -> {3, 0, 0, {}},
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				State -> Liquid,
				Synonyms -> {"Formaldehyde (test for UploadMolecule) 48 " <> $SessionUUID, "Formaldehyde-14C", "Formaldehyde"},
				IncompatibleMaterials -> {None}
			],
			ObjectP[Model[Molecule, "Formaldehyde (test for UploadMolecule) 48 " <> $SessionUUID]]
		],
		Example[{Options, "NFPA", "Use the NFPA option to specify the National Fire Potection Association (NFPA) 704 Hazard diamond classification of this substance. This option is specified in the format {HealthRating,FlammabilityRating,ReactivityRating,SpecialConsiderationsList}. The valid symbols to include in SpecialConsiderationsList are Oxidizer|WaterReactive|Aspyxiant|Corrosive|Acid|Bio|Poisonous|Radioactive|Cryogenic|Null. The following chemical, formaldehyde, as an NFPA of {3,0,0,{Radioactive}} which means that its Health rating is 3, its Flammability rating is 0, and its Reactivity rating is 0. The special consideration of this chemical is that it is radioactive:"},
			UploadMolecule["https://www.sigmaaldrich.com/US/en/substance/formaldehydesolution300350000",
				NFPA -> {3, 0, 0, {Radioactive}},
				MSDSRequired -> True,
				MSDSFile -> "http://www.sciencelab.com/msds.php?msdsId=9924095",
				ParticularlyHazardousSubstance -> True,
				Name -> "Formaldehyde (test for UploadMolecule) 49 " <> $SessionUUID,
				DOTHazardClass -> "Class 7 Division 7 Radioactive Material Hazard",
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				State -> Liquid,
				Synonyms -> {"Formaldehyde (test for UploadMolecule) 49 " <> $SessionUUID, "Formaldehyde"},
				IncompatibleMaterials -> {None}
			],
			ObjectP[Model[Molecule, "Formaldehyde (test for UploadMolecule) 49 " <> $SessionUUID]]
		],
		Example[{Options, "NFPA", "Use the NFPA option to specify the National Fire Potection Association (NFPA) 704 Hazard diamond classification of this substance. This option is specified in the format {HealthRating,FlammabilityRating,ReactivityRating,SpecialConsiderationsList}. The valid symbols to include in SpecialConsiderationsList are Oxidizer|WaterReactive|Aspyxiant|Corrosive|Acid|Bio|Poisonous|Radioactive|Cryogenic|Null. The following chemical, water, has an NFPA of {0,0,0,{}} which means that its Health, Flammability, and Reactivity ratings are 0 and there are no special considerations to take into account:"},
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/sigma/w3500?lang=en&region=US",
				NFPA -> {0, 0, 0, {}},
				Name -> "Water (test for UploadMolecule) 50 " <> $SessionUUID,
				MSDSRequired -> False,
				Flammable -> False,
				Fuming -> False,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None}
			],
			ObjectP[Model[Molecule, "Water (test for UploadMolecule) 50 " <> $SessionUUID]]
		],
		Example[{Options, "DOTHazardClass", "Use the DOTHazardClass option to set the DOT Hazard Class of this uploaded chemical. The valid values of this option can be found by evaluating DOTHazardClassP. The following chemical is part of DOT Hazard Class 9:"},
			UploadMolecule["62-31-7",
				DOTHazardClass -> "Class 9 Miscellaneous Dangerous Goods Hazard",
				Name -> "Dopamine (test for UploadMolecule) 51 " <> $SessionUUID,
				NFPA -> {1, 1, 0, {}},
				Flammable -> True,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				State -> Solid,
				MSDSFile -> "https://www.caymanchem.com/msdss/21992m.pdf"
			],
			ObjectP[Model[Molecule, "Dopamine (test for UploadMolecule) 51 " <> $SessionUUID]]
		],
		Example[{Options, "BiosafetyLevel", "Use the BiosafetyLevel option to specify the biosafety level of this chemical sample. The valid value of this options can be found by evaluating BiosafetyLevelP (\"BSL-1\",\"BSL-2\",\"BSL-3\",\"BSL-4\"). The following chemical (purified water) has a classification of \"BSL-1\":"},
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/sigma/w3500?lang=en&region=US",
				BiosafetyLevel -> "BSL-1",
				Name -> "Water (test for UploadMolecule) 52 " <> $SessionUUID,
				MSDSRequired -> False,
				Flammable -> False,
				Fuming -> False,
				IncompatibleMaterials -> {None}
			],
			ObjectP[Model[Molecule, "Water (test for UploadMolecule) 52 " <> $SessionUUID]]
		],
		Example[{Options, "LightSensitive", "Use the LightSensitive option to specify if the chemical sample is light sensitive and special precautions should be taken to make sure that the sample is handled in a dark room:"},
			UploadMolecule["Acetonitrile",
				Name -> "Acetonitrile (test for UploadMolecule 53 " <> $SessionUUID,
				LightSensitive -> False,
				BiosafetyLevel -> "BSL-1",
				MSDSFile -> "https://www.fishersci.com/store/msds?partNumber=A99820SS50&productDescription=ACETONITRILE+20%25+DIWATER+80%25&vendorId=VN00033897&countryCode=US&language=en",
				IncompatibleMaterials -> {Nitrile, Polypropylene}
			],
			ObjectP[Model[Molecule, "Acetonitrile (test for UploadMolecule 53 " <> $SessionUUID]]
		],
		Example[{Options, "IncompatibleMaterials", "Use the IncompatibleMaterials option to specify the list of materials that would become damaged if wetted by this chemical sample. Use MaterialP to see the materials that can be used in this field. Specify {None} if there are no IncompatibleMaterials:"},
			UploadMolecule["Acetonitrile",
				Name -> "Acetonitrile (test for UploadMolecule) 54 " <> $SessionUUID,
				LightSensitive -> False,
				BiosafetyLevel -> "BSL-1",
				MSDSFile -> "https://www.fishersci.com/store/msds?partNumber=A99820SS50&productDescription=ACETONITRILE+20%25+DIWATER+80%25&vendorId=VN00033897&countryCode=US&language=en",
				IncompatibleMaterials -> {Nitrile, Polypropylene}
			],
			ObjectP[Model[Molecule, "Acetonitrile (test for UploadMolecule) 54 " <> $SessionUUID]]
		],
		Example[{Options, "IncompatibleMaterials", "Use the IncompatibleMaterials option to specify the list of materials that would become damaged if wetted by this chemical sample. Use MaterialP to see the materials that can be used in this field. Specify {None} if there are no IncompatibleMaterials:"},
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/sigma/w3500?lang=en&region=US",
				Name -> "Water (test for UploadMolecule) 55 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				MSDSRequired -> False,
				Flammable -> False,
				Fuming -> False,

				IncompatibleMaterials -> {None}
			],
			ObjectP[Model[Molecule, "Water (test for UploadMolecule) 55 " <> $SessionUUID]]
		],
		Example[{Options, "HazardousBan", "Use the HazardousBan option to indicate that samples of this model are currently banned from usage in the ECL because the facility isn't yet equipped to handle them:"},
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/cerillian/ert022s?lang=en&region=US",
				HazardousBan -> True,
				Name -> "TNT (test for UploadMolecule 56 " <> $SessionUUID,
				ParticularlyHazardousSubstance -> True,
				BiosafetyLevel -> "BSL-1",
				Flammable->True,
				IncompatibleMaterials -> {None},
				DOTHazardClass -> "Class 1 Division 1.1 Mass Explosion Hazard",
				NFPA -> {2, 4, 4, {}},
				MSDSFile -> "https://www.dynonobel.com/~/media/Files/Dyno/ResourceHub/Safety%20Data%20Sheets/North%20America/1145%20Seismic%20Cast%20Booster.pdf"
			],
			ObjectP[Model[Molecule, "TNT (test for UploadMolecule 56 " <> $SessionUUID]]
		],
		Example[{Options, "Expires", "Use the Expires option to indicate if this chemical expires:"},
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/sigma/w3500?lang=en&region=US",
				Name -> "Water (test for UploadMolecule) 57 " <> $SessionUUID,
				MSDSRequired -> False,
				Flammable -> False,
				Fuming -> False,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None}
			],
			ObjectP[Model[Molecule, "Water (test for UploadMolecule) 57 " <> $SessionUUID]]
		],
		Example[{Options, "LiquidHandlerIncompatible", "Use the LiquidHandlerIncompatible option to specify that the chemical sample cannot be reliably aspirated or dispensed by a liquid handling robot. In the following example, Methanol cannot accurately be aspirated by a liquid handling robot so LiquidHandlerIncompatible->True:"},
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/sial/322415?lang=en&region=US",
				Name -> "Methanol (test for UploadMolecule) 58 " <> $SessionUUID,
				LiquidHandlerIncompatible -> True,
				IncompatibleMaterials -> {ABS, Polyurethane},
				BiosafetyLevel -> "BSL-1",
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard",
				NFPA -> {1, 3, 0, {}}
			],
			ObjectP[Model[Molecule, "Methanol (test for UploadMolecule) 58 " <> $SessionUUID]]
		],
		Example[{Options, "UltrasonicIncompatible", "Use the UltrasonicIncompatible option to specify that volume measurements of samples of this model cannot be performed via the ultrasonic distance method due to vapors interfering with the reading:"},
			UploadMolecule[
				Name -> "Thermo Ultra Low Range DNA Ladder, 0.5 ug/uL (test for UploadMolecule) 59 " <> $SessionUUID,
				UltrasonicIncompatible -> True,
				Synonyms -> {
					"Thermo Ultra Low Range DNA Ladder, 0.5 ug/uL (test for UploadMolecule) 59 " <> $SessionUUID,
					"Thermo Ultra Low Range DNA Ladder, 0.5 ug/uL",
					"DNA Ladder", "10-300nt DNA Ladder"
				},
				BiosafetyLevel -> "BSL-1",
				Density -> Quantity[1.0005`, ("Grams") / ("Milliliters")],
				IncompatibleMaterials -> {None},
				NFPA -> {0, 0, 0, {Null}},
				State -> Liquid,
				MSDSRequired -> False
			],
			ObjectP[Model[Molecule, "Thermo Ultra Low Range DNA Ladder, 0.5 ug/uL (test for UploadMolecule) 59 " <> $SessionUUID]]
		],
		Example[{Options, "Fluorescent", "Use the Fluorescent option to specify that the molecule is fluorescent:"},
			UploadMolecule["SYBR Green",
				Name -> "SYBR Green (test for UploadMolecule) 60 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				State -> Liquid,
				MSDSRequired -> False,
				Fluorescent -> True,
				FluorescenceExcitationMaximums -> {497 * Nanometer},
				FluorescenceEmissionMaximums -> {521 * Nanometer}
			],
			ObjectP[Model[Molecule, "SYBR Green (test for UploadMolecule) 60 " <> $SessionUUID]]
		],
		Example[{Options, "DetectionLabel", "Indicates whether this molecule (e.g. Alexa Fluor 488) can be attached to another molecule and act as a tag that can indicate the presence and amount of the other molecule:"},
			UploadMolecule["Alexa Fluor 488",
				Name -> "Alexa Fluor 488 (test for UploadMolecule) 61 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				State -> Solid,
				MSDSRequired -> False,
				DetectionLabel -> True
			],
			ObjectP[Model[Molecule, "Alexa Fluor 488 (test for UploadMolecule) 61 " <> $SessionUUID]]
		],
		Example[{Options, "AffinityLabel", "Indicates whether this molecule can be attached to another molecule and act as a tag that can indicate the presence and amount of the other molecule (e.g. His tag):"},
			UploadMolecule["His Tag",
				Name -> "His Tag (test for UploadMolecule) 62 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				State -> Solid,
				MSDSRequired -> False,
				AffinityLabel -> True
			],
			ObjectP[Model[Molecule, "His Tag (test for UploadMolecule) 62 " <> $SessionUUID]]
		],
		Example[{Options, "DetectionLabels", "Indicates the tags (e.g. Alexa Fluor 488) that the molecule contains, which can indicate the presence and amount of the molecule:"},
			UploadMolecule["Alexa Fluor 488-Tethered Phalloidin",
				Name -> "Alexa Fluor 488-Tethered Phalloidin (test for UploadMolecule) 64 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				State -> Solid,
				MSDSRequired -> False,
				DetectionLabels -> {Link[Model[Molecule, "Alexa Fluor 488 (test for UploadMolecule) 63 " <> $SessionUUID]]}
			],
			ObjectP[Model[Molecule, "Alexa Fluor 488-Tethered Phalloidin (test for UploadMolecule) 64 " <> $SessionUUID]],
			SetUp :> {
				UploadMolecule["Alexa Fluor 488",
					Name -> "Alexa Fluor 488 (test for UploadMolecule) 63 " <> $SessionUUID,
					BiosafetyLevel -> "BSL-1",
					IncompatibleMaterials -> {None},
					State -> Solid,
					MSDSRequired -> False,
					DetectionLabel -> True
				];
			}
		],
		Example[{Options, "AffinityLabels", "Indicates the tags (e.g. biotin) that the molecule contains, which has high binding capacity with other materials:"},
			UploadMolecule["Biotinylated Glycosylphosphatidylinositol",
				Name -> "Biotinylated Glycosylphosphatidylinositol (test for UploadMolecule) 66 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				State -> Solid,
				MSDSRequired -> False,
				AffinityLabels -> {Link[Model[Molecule, "Biotin (test for UploadMolecule) 65 " <> $SessionUUID]]}
			],
			ObjectP[Model[Molecule, "Biotinylated Glycosylphosphatidylinositol (test for UploadMolecule) 66 " <> $SessionUUID]],
			SetUp :> {
				UploadMolecule["Biotin",
					Name -> "Biotin (test for UploadMolecule) 65 " <> $SessionUUID,
					BiosafetyLevel -> "BSL-1",
					IncompatibleMaterials -> {None},
					State -> Solid,
					MSDSRequired -> False,
					AffinityLabel -> True
				];
			}
		],
		Example[{Options, "Chiral", "If a sample is a enantiomer, that cannot be superposed on its mirror image by any combination of rotations and translations:"},
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/sigma/183164?lang=en&region=US&gclid=Cj0KCQiA6t6ABhDMARIsAONIYyx5mQT1mv_NJ8_-GqmmnCD5cZPK1TmxRo2Fy1oLV42m5Qp5VJfmELcaAg3WEALw_wcB",
				Name -> "(R)-(+)-Limonene (test molecule for UploadMolecule) 67 " <> $SessionUUID,
				Chiral -> True,
				Ventilated -> True,
				Pungent -> True,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard",
				NFPA -> {3, 2, 0, {}},
				Flammable -> True
			];
			Download[Model[Molecule, "(R)-(+)-Limonene (test molecule for UploadMolecule) 67 " <> $SessionUUID], Chiral],
			True
		],
		Example[{Options, "Racemic", "If a sample is a racemic compound, this field represents equal amounts of left- and right-handed enantiomers of a chiral molecule.:"},
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/aldrich/147923?lang=en&region=US&cm_sp=Insite-_-caContent_prodMerch_gruCrossEntropy-_-prodMerch10-3",
				Name -> "Camphor-10-sulfonic acid (test molecule for UploadMolecule) 68 " <> $SessionUUID,
				Racemic -> True,
				Ventilated -> True,
				Pungent -> True,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard",
				NFPA -> {3, 1, 1, {}}
			];Download[Model[Molecule, "Camphor-10-sulfonic acid (test molecule for UploadMolecule) 68 " <> $SessionUUID], Racemic],
			True
		],
		(* EnantiomerPair *)
		Example[{Options, "EnantiomerForms", "If this molecule is racemic (Racemic -> True), indicates models for its left- and right-handed enantiomers."},
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/aldrich/147923?lang=en&region=US&cm_sp=Insite-_-caContent_prodMerch_gruCrossEntropy-_-prodMerch10-3",
				Name -> "Camphor-10-sulfonic acid (test molecule for UploadMolecule) 69 " <> $SessionUUID,
				Racemic -> True,
				EnantiomerForms -> {Link[Model[Molecule, "(1R)-(-)-10-camphorsulfonic acid"]], Link[Model[Molecule, "(1S)-(+)-10-Camphorsulfonic acid"]]},
				Ventilated -> True,
				Pungent -> True,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard",
				NFPA -> {3, 1, 1, {}}
			];
			Download[Model[Molecule, "Camphor-10-sulfonic acid (test molecule for UploadMolecule) 69 " <> $SessionUUID], EnantiomerForms],
			{ObjectP[Model[Molecule, "(1R)-(-)-10-camphorsulfonic acid"]], ObjectP[Model[Molecule, "(1S)-(+)-10-Camphorsulfonic acid"]]}
		],
		Example[{Options, "RacemicForm", "If this molecule is one of the enantiomers (Chiral -> True), indicates the model for its racemic form."},
			UploadMolecule[
				"https://www.sigmaaldrich.com/catalog/product/aldrich/282146?lang=en&region=US",
				Name -> "(1R)-(−)-10-Camphorsulfonic acid (test molecule for UploadMolecule) 70 " <> $SessionUUID,
				Chiral -> True,
				RacemicForm -> Link[Model[Molecule, "Camphor-10-sulfonic acid"]],
				Ventilated -> True,
				Pungent -> True,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard",
				NFPA -> {3, 1, 1, {}},
				Flammable -> True
			];
			Download[Model[Molecule, "(1R)-(−)-10-Camphorsulfonic acid (test molecule for UploadMolecule) 70 " <> $SessionUUID], RacemicForm],
			ObjectP[Model[Molecule, "Camphor-10-sulfonic acid"]]
		],
		Example[{Options, "EnantiomerPair", "If this molecule is one of the enantiomers (Chiral -> True), indicates the model for its racemic form."},
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/aldrich/282146?lang=en&region=US",
				Name -> "(1R)-(−)-10-Camphorsulfonic acid (test molecule for UploadMolecule) 71 " <> $SessionUUID,
				Chiral -> True,
				EnantiomerPair -> Link[Model[Molecule, "(1S)-(+)-10-Camphorsulfonic acid"]],
				Ventilated -> True,
				Pungent -> True,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard",
				NFPA -> {3, 1, 1, {}},
				Flammable -> True
			];
			Download[Model[Molecule, "(1R)-(−)-10-Camphorsulfonic acid (test molecule for UploadMolecule) 71 " <> $SessionUUID], EnantiomerPair],
			ObjectP[Model[Molecule, "(1S)-(+)-10-Camphorsulfonic acid"]]
		],
		Example[{Options, ModifyInputModel, "When a Model[Molecule] is used as input, set this option to True to modify the input molecule:"},
			UploadMolecule[Model[Molecule,"Existing Glycine (test molecule for UploadMolecule) 72 " <> $SessionUUID],
        		MolecularWeight -> 100.0 Dalton,
				ModifyInputModel->True
			],
			obj:ObjectP[Model[Molecule]]/;MatchQ[
				Download[obj,{Object,MolecularWeight}],
				{
					(* Object id should be unchanged *)
					Download[Model[Molecule,"Existing Glycine (test molecule for UploadMolecule) 72 " <> $SessionUUID], Object],
					100.0 Dalton
				}
			],
			SetUp :> {
				UploadMolecule[Model[Molecule,"Glycine"],
					Name->"Existing Glycine (test molecule for UploadMolecule) 72 " <> $SessionUUID,
					ModifyInputModel->False
				];
			}
		],
		Example[{Options, ModifyInputModel, "When a Model[Molecule] is used as input, set this option to False to use the input molecule as a template and upload a new molecule object:"},
			UploadMolecule[Model[Molecule,"Glycine"],
				Name->"Glycine (test molecule for UploadMolecule) 73 " <> $SessionUUID,
				ModifyInputModel->False
			],
			obj:ObjectP[Model[Molecule]]/;With[
				{fields={UNII, State, MolecularWeight, ExactMass, Flammable, NFPA, DOTHazardClass, BiosafetyLevel}},
				And[
					MatchQ[
						Download[obj,fields],
						Download[Model[Molecule,"Glycine"],fields]
					],
					(* A new object was uploaded *)
					!MatchQ[
						Download[obj,Object],
						Download[Model[Molecule,"Glycine"],Object]
					]
				]
			]
		],
		Test["Automatic resolution of ModifyInputModel is Null for non-model inputs, True by default, and can be changed:",
			Flatten@Lookup[
				{
					UploadMolecule[Model[Molecule,"Glycine"],Name->"Test molecule for UploadMolecule 74 " <> $SessionUUID,ModifyInputModel->False,Upload->False,Output->Options],
					UploadMolecule[Model[Molecule,"Glycine"],Name->"Test molecule for UploadMolecule 74 " <> $SessionUUID,Upload->False,Output->Options],
					UploadMolecule[Molecule["Water"],Name->"Test molecule for UploadMolecule 74 " <> $SessionUUID,IncompatibleMaterials->{None},BiosafetyLevel->"BSL-1",Upload->False,Output->Options]
				},
				ModifyInputModel
			],
			{False,True,Null}
		],
		Example[{Messages, "VentilatedRequired", "If a sample is marked as Pungent it must be set to Ventilated:"},
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/aldrich/w372218?lang=en&region=US",
				Name -> "cis-5-Octen-1-ol (test for UploadMolecule) 75 " <> $SessionUUID,
				Ventilated -> False,
				Pungent -> True,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard",
				NFPA -> {2, 2, 0, {}}
			],
			Null,
			Messages :> {Error::VentilatedRequired, Error::InvalidOption}
		],
		Test["Test Command Builder output, options:",
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/sigma/w3500?lang=en&region=US",
				NFPA -> {0, 0, 0, {}},
				Name -> "Water (test for UploadMolecule) 76 " <> $SessionUUID,
				MSDSRequired -> False,
				Flammable -> False,
				Fuming -> False,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				Output -> Options
			],
			{_Rule..}
		],
		Test["Test Command Builder output, results and tests:",
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/sigma/w3500?lang=en&region=US",
				NFPA -> {0, 0, 0, {}},
				Name -> "Water (test for UploadMolecule) 77 " <> $SessionUUID,
				MSDSRequired -> False,
				Flammable -> False,
				Fuming -> False,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				Output -> {Result, Tests}
			],
			{ObjectP[Model[Molecule, "Water (test for UploadMolecule) 77 " <> $SessionUUID]], {_EmeraldTest..}}
		],
		Test["Ensure MolecularFormula retains the correct capitalization of elements:",
			UploadMolecule["100-58-3",
				Name -> "Phenylmagnesium bromide(test for UploadMolecule) 78 " <> $SessionUUID,
				State -> Solid,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None}
			];
			MatchQ["C6H5BrMg", Download[Model[Molecule, "Phenylmagnesium bromide(test for UploadMolecule) 78 " <> $SessionUUID], MolecularFormula]],
			True
		],
		Example[{Options, "Monatomic", "Indicates if this molecule contains exactly one atom."},
			UploadMolecule["7440-59-7",
				Name -> "Helium (test for UploadMolecule) 79 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				State -> Gas,
				IncompatibleMaterials -> {None},
				Monatomic -> True
			];
			Download[Model[Molecule, "Helium (test for UploadMolecule) 79 " <> $SessionUUID], Monatomic],
			True
		]
	},
	SymbolSetUp :> {
		$CreatedObjects = {};
		Off[Warning::SimilarMolecules];
		Off[Warning::APIConnection];
		Off[Upload::Warning];
	},
	SymbolTearDown :> {
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects];
		On[Warning::SimilarMolecules];
		On[Warning::APIConnection];
		On[Upload::Warning];
	}
];



(* ::Subsubsection::Closed:: *)
(*UploadMoleculeOptions*)


DefineTests[
	UploadMoleculeOptions,
	{
		Example[{Basic, "Inspect the resolved options when uploading a Model[Molecule] of DMSO by its name:"},
			UploadMoleculeOptions["DMSO",
				Name -> "DMSO (test for UploadMoleculeOptions) 1 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Basic, "Inspect the resolved options when uploading a new Model[Molecule] of Aspartic Acid by its PubChem ID:"},
			UploadMoleculeOptions[PubChem[5960],
				Name -> "Aspartic Acid (test for UploadMoleculeOptions) 2 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Basic, "Inspect the resolved options when uploading a new Model[Molecule] of L-Serine by its InChI:"},
			UploadMoleculeOptions["InChI=1S/C3H7NO3/c4-2(1-5)3(6)7/h2,5H,1,4H2,(H,6,7)/t2-/m0/s1",
				Name -> "L-Serine (test for UploadMoleculeOptions) 3 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Basic, "Inspect the resolved options when uploading a new Model[Molecule] of Arginine by its CAS:"},
			UploadMoleculeOptions["74-79-3",
				Name -> "Arginine (test for UploadMoleculeOptions) 4 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Basic, "Inspect the resolved options when uploading a new Model[Molecule] of Allylamine by its Sigma Aldrich product URL:"},
			UploadMoleculeOptions["https://www.sigmaaldrich.com/catalog/product/aldrich/145831?lang=en&region=US",
				Name -> "Allylamine (test for UploadMoleculeOptions) 5 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				NFPA -> {4, 3, 1, {}},
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard",
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Additional, "Inspect the resolved options when uploading a new Model[Molecule] of Taxol by its InChI Key:"},
			UploadMoleculeOptions[
				"RCINICONZNJXQF-MZXODVADSA-N",
				Name -> "Taxol (test for UploadMoleculeOptions) 6 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				NFPA -> {3, 0, 0, {}},
				MSDSFile -> "https://assets.thermofisher.com/TFS-Assets/LSG/SDS/P3456_MTR-NALT_EN.pdf",
				IncompatibleMaterials -> {None},
				Flammable -> False,
				DOTHazardClass -> "Class 0",
				State -> Solid,
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Options, OutputFormat, "Return the resolved options as a list:"},
			UploadMoleculeOptions["DMSO",
				Name -> "DMSO (test for UploadMoleculeOptions) 7 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None},
				OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Options, OutputFormat, "Return the resolved options as a table:"},
			UploadMoleculeOptions["DMSO",
				Name -> "DMSO (test for UploadMoleculeOptions) 8 " <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				IncompatibleMaterials -> {None}
			],
			Graphics_
		]
	},
	SymbolSetUp :> {
		$CreatedObjects = {};
		Off[Warning::SimilarMolecules];
		Off[Warning::APIConnection];
	},
	SymbolTearDown :> {
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects];
		On[Warning::SimilarMolecules];
		On[Warning::APIConnection];
	}
];



(* ::Subsubsection::Closed:: *)
(*ValidUploadMoleculeQ*)


DefineTests[
	ValidUploadMoleculeQ,
	{
		Example[{Basic, "Make sure that the resulting object will be valid when uploading a Model[Molecule] of DMSO by its name:"},
			ValidUploadMoleculeQ["DMSO", Name -> "DMSO Sample #1", BiosafetyLevel -> "BSL-1", IncompatibleMaterials -> {None}],
			True
		],
		Example[{Basic, "Make sure that the resulting object will be valid when uploading a new Model[Molecule] of Aspartic Acid by its PubChem ID:"},
			ValidUploadMoleculeQ[PubChem[5960], Name -> "Aspartic Acid Sample #2", BiosafetyLevel -> "BSL-1", IncompatibleMaterials -> {None}],
			True
		],
		Example[{Basic, "Make sure that the resulting object will be valid when uploading a new Model[Molecule] of L-Serine by its InChI:"},
			ValidUploadMoleculeQ["InChI=1S/C3H7NO3/c4-2(1-5)3(6)7/h2,5H,1,4H2,(H,6,7)/t2-/m0/s1", Name -> "L-Serine Sample #3", BiosafetyLevel -> "BSL-1", IncompatibleMaterials -> {None}],
			True
		],
		Example[{Basic, "Make sure that the resulting object will be valid when uploading a new Model[Molecule] of Arginine by its CAS:"},
			ValidUploadMoleculeQ["74-79-3", Name -> "Arginine Sample #3", BiosafetyLevel -> "BSL-1", IncompatibleMaterials -> {None}],
			True
		],
		Example[{Basic, "Make sure that the resulting object will be valid when uploading a new Model[Molecule] of Allylamine by its Sigma Aldrich product URL:"},
			ValidUploadMoleculeQ["https://www.sigmaaldrich.com/catalog/product/aldrich/145831?lang=en&region=US", Name -> "Allylamine Sample #4", BiosafetyLevel -> "BSL-1", IncompatibleMaterials -> {None}, NFPA -> {4, 3, 1, {}}, DOTHazardClass -> "Class 3 Flammable Liquids Hazard"],
			True
		],
		Example[{Additional, "Make sure that the resulting object will be valid when uploading a new Model[Molecule] of Taxol by its InChI Key:"},
			ValidUploadMoleculeQ[
				"RCINICONZNJXQF-MZXODVADSA-N",
				Name -> "Taxol Sample #5",
				BiosafetyLevel -> "BSL-1",
				NFPA -> {3, 0, 0, {}},
				MSDSFile -> "https://assets.thermofisher.com/TFS-Assets/LSG/SDS/P3456_MTR-NALT_EN.pdf",
				IncompatibleMaterials -> {None},
				Flammable -> False,
				DOTHazardClass -> "Class 0",
				State -> Solid
			],
			True
		],
		Example[{Options, "Verbose", "Set Verbose->True to see all of the tests that ValidUploadMoleculeQ is running:"},
			ValidUploadMoleculeQ["DMSO", Name -> "DMSO Sample #1", BiosafetyLevel -> "BSL-1", IncompatibleMaterials -> {None}, Verbose -> True],
			True
		],
		Example[{Options, "Verbose", "Set Verbose->Failures to see all of the tests that did not pass when running ValidUploadMoleculeQ:"},
			ValidUploadMoleculeQ["DMSO", Name -> "DMSO Sample #1", BiosafetyLevel -> "BSL-1", IncompatibleMaterials -> {None}, Verbose -> Failures],
			True
		],
		Example[{Options, "Verbose", "Set Verbose->False to see none of the tests when running ValidUploadMoleculeQ (this is the default behavior):"},
			ValidUploadMoleculeQ["DMSO", Name -> "DMSO Sample #1", BiosafetyLevel -> "BSL-1", IncompatibleMaterials -> {None}, Verbose -> False],
			True
		],
		Example[{Options, "OutputFormat", "Set OutputFormat->TestSummary to have the function return a summary of the tests that it ran. Use the Keys[...] function on this test summary to see the keys inside of it:"},
			ValidUploadMoleculeQ["DMSO", Name -> "DMSO Sample #1", BiosafetyLevel -> "BSL-1", IncompatibleMaterials -> {None}, OutputFormat -> TestSummary][Successes],
			{_EmeraldTestResult..}
		]
	},
	SymbolSetUp :> {
		Off[Warning::SimilarMolecules];
		Off[Warning::APIConnection];
	},
	SymbolTearDown :> {
		On[Warning::SimilarMolecules];
		On[Warning::APIConnection];
	}
];
