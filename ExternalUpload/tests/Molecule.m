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
				Name -> "DMSO for UploadMolecule unit tests 1 " <> $SessionUUID,
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard",
				NFPA -> {2, 2, 0, {}}
			],
			ObjectP[Model[Molecule]]
		],
		Example[{Basic, "Upload a new Model[Molecule] of Aspartic Acid by its PubChem ID:"},
			UploadMolecule[PubChem[5960],
				Name -> "Aspartic Acid for UploadMolecule unit tests 2 " <> $SessionUUID
			],
			ObjectP[Model[Molecule]]
		],
		Example[{Basic, "Upload a new Model[Molecule] of L-Serine by its InChI:"},
			UploadMolecule["InChI=1S/C3H7NO3/c4-2(1-5)3(6)7/h2,5H,1,4H2,(H,6,7)/t2-/m0/s1",
				Name -> "L-Serine for UploadMolecule unit tests 3 " <> $SessionUUID
			],
			ObjectP[Model[Molecule]]
		],
		Example[{Basic, "Upload a new Model[Molecule] of Lysine by its CAS:"},
			UploadMolecule["56-87-1",
				Name -> "Lysine for UploadMolecule unit tests 4 " <> $SessionUUID
			],
			ObjectP[Model[Molecule]]
		],
		Example[{Basic, "Upload a new Model[Molecule] of Allylamine by its Sigma Aldrich product URL:"},
			UploadMolecule["https://www.sigmaaldrich.com/catalog/product/aldrich/145831?lang=en&region=US",
				Name -> "Allylamine for UploadMolecule unit tests 5 " <> $SessionUUID,
				NFPA -> {4, 3, 1, {}},
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard"
			],
			ObjectP[Model[Molecule]]
		],
		Example[{Basic, "Upload a new Model[Molecule] of Aspartic Acid by its PubChem ID using an integer:"},
			UploadMolecule[5960,
				Name -> "Aspartic Acid for UploadMolecule unit tests 6 " <> $SessionUUID
			],
			ObjectP[Model[Molecule]]
		],
		Example[{Additional, "Upload a new Model[Molecule] of Taxol by its InChI Key:"},
			UploadMolecule["RCINICONZNJXQF-MZXODVADSA-N",
				Name -> "Taxol for UploadMolecule unit tests 7 " <> $SessionUUID,
				NFPA -> {3, 0, 0, {}},
				Flammable -> False,
				DOTHazardClass -> "Class 0",
				State -> Solid
			],
			ObjectP[Model[Molecule]]
		],
		Example[{Additional, "Upload a new Model[Molecule] of DMSO by its ThermoFisher product URL:"},
			UploadMolecule["https://www.thermofisher.com/order/catalog/product/85190",
				Name -> "DMSO for UploadMolecule unit tests 8 " <> $SessionUUID,
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard",
				NFPA -> {2, 2, 0, {}}
			],
			ObjectP[Model[Molecule]]
		],
		Example[{Additional, "Upload a new Model[Molecule] of Water by its Molecule:"},
			UploadMolecule[Molecule["Water"],
				Name -> "Water for UploadMolecule unit tests 9 " <> $SessionUUID,
				MSDSFile -> NotApplicable,
				State -> Liquid
			],
			ObjectP[Model[Molecule]]
		],
		Example[{Additional, "Use the listable version of UploadMolecule to upload multiple chemicals:"},
			UploadMolecule[{PubChem[679], PubChem[702]},
				Name -> {"DMSO for UploadMolecule unit tests 10 " <> $SessionUUID, "Ethanol for UploadMolecule unit tests 10 " <> $SessionUUID},
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard",
				NFPA -> {2, 2, 0, {}}
			],
			{ObjectP[Model[Molecule]], ObjectP[Model[Molecule]]}
		],
		Test["Test the listable output of UploadMolecule:",
			UploadMolecule[{PubChem[679], PubChem[702]},
				Name -> {"DMSO for UploadMolecule unit tests 11 " <> $SessionUUID, "Ethanol for UploadMolecule unit tests 11 " <> $SessionUUID},
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard",
				NFPA -> {2, 2, 0, {}},
				Output -> {Result, Options, Tests}
			],
			{{ObjectP[Model[Molecule]], ObjectP[Model[Molecule]]}, {_Rule..}, {_EmeraldTest..}}
		],
		Example[{Options, "Name", "Use the Name option to set the name of this uploaded chemical:"},
			UploadMolecule[PubChem[5234],
				Name -> "Sodium Chloride for UploadMolecule unit tests 12 "<> $SessionUUID,
				NFPA -> {1, 0, 0, {}},
				DOTHazardClass -> "Class 0"
			],
			ObjectP[Model[Molecule, "Sodium Chloride for UploadMolecule unit tests 12 "<> $SessionUUID]]
		],
		Example[{Options, "Synonyms", "Use the Synonyms option to set the synonyms of this uploaded chemical:"},
			UploadMolecule["56-87-1",
				Name -> "Lysine for UploadMolecule unit tests 13 " <> $SessionUUID,
				Synonyms -> {"Lysine for UploadMolecule unit tests 13 " <> $SessionUUID, "L-lysine", "lysine", "Lysine", "56-87-1", "L lysine", "Lys", "K"}
			],
			ObjectP[Model[Molecule, "Lysine for UploadMolecule unit tests 13 " <> $SessionUUID]]
		],
		Example[{Options, "UNII", "Use the UNII option to set the UNII of this uploaded chemical:"},
			UploadMolecule["DMSO",
				Name -> "DMSO for UploadMolecule unit tests 14 " <> $SessionUUID,
				UNII -> "YOW8V9698H",
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard",
				NFPA -> {2, 2, 0, {}}
			],
			ObjectP[Model[Molecule, "DMSO for UploadMolecule unit tests 14 " <> $SessionUUID]]
		],
		Example[{Options, "InChI", "Use the InChI option to set the InChI of this uploaded chemical. InChI is a unique chemical identifier for a chemical, each chemical has a unique InChI:"},
			UploadMolecule["Sodium Chloride for UploadMolecule unit tests 15 " <> $SessionUUID,
				InChI -> "InChI=1S/ClH.Na/h1H;/q;+1/p-1",
				NFPA -> {1, 0, 0, {}},
				DOTHazardClass -> "Class 0"
			],
			ObjectP[Model[Molecule, "Sodium Chloride for UploadMolecule unit tests 15 " <> $SessionUUID]]
		],
		Example[{Options, "InChIKey", "Use the InChIKey option to set the InChIKey of this uploaded chemical. InChIKey is a unique chemical identifier for a chemical, each chemical has a unique InChIKey:"},
			UploadMolecule["Sodium Chloride for UploadMolecule unit tests 16 " <> $SessionUUID,
				InChIKey -> "FAPWRFPIFSIZLT-UHFFFAOYSA-M",
				NFPA -> {1, 0, 0, {}},
				DOTHazardClass -> "Class 0"
			],
			ObjectP[Model[Molecule, "Sodium Chloride for UploadMolecule unit tests 16 " <> $SessionUUID]]
		],
		Example[{Options, "CAS", "Use the CAS option to set the CAS number of this uploaded chemical:"},
			UploadMolecule["Sodium Chloride for UploadMolecule unit tests 17 "<> $SessionUUID,
				CAS -> "7647-14-5",
				NFPA -> {1, 0, 0, {}},
				DOTHazardClass -> "Class 0"
			],
			ObjectP[Model[Molecule, "Sodium Chloride for UploadMolecule unit tests 17 " <> $SessionUUID]]
		],
		Example[{Options, "IUPAC", "Use the IUPAC option to set the IUPAC name of this uploaded chemical:"},
			UploadMolecule["InChI=1S/C6H14N2O2/c7-4-2-1-3-5(8)6(9)10/h5H,1-4,7-8H2,(H,9,10)/t5-/m0/s1",
				IUPAC -> "(2S)-2,6-diaminohexanoic acid",
				Name -> "Lysine for UploadMolecule unit tests 18 "<> $SessionUUID
			],
			ObjectP[Model[Molecule, "Lysine for UploadMolecule unit tests 18 "<> $SessionUUID]]
		],
		Example[{Options, "MolecularFormula", "Use the MolecularFormula option to set the Molecular Formula of this uploaded chemical:"},
			UploadMolecule["Lysine",
				MolecularFormula -> "C6H14N2O2",
				Name -> "Lysine for UploadMolecule unit tests 19 " <> $SessionUUID
			],
			ObjectP[Model[Molecule, "Lysine for UploadMolecule unit tests 19 " <> $SessionUUID]]
		],
		Example[{Options, "MolecularWeight", "Use the MolecularWeight option to set the Molecular Weight of this uploaded chemical:"},
			UploadMolecule["DMF", MolecularWeight -> 73.095 Gram / Mole,
				Name -> "DMF for UploadMolecule unit tests 20 " <> $SessionUUID
			],
			ObjectP[Model[Molecule, "DMF for UploadMolecule unit tests 20 " <> $SessionUUID]]
		],
		Example[{Options, "ExactMass", "Use the ExactMass option to set the exact mass of this uploaded chemical:"},
			UploadMolecule["Thiophene",
				ExactMass -> 84.003371 Gram / Mole,
				Name -> "Thiophene for UploadMolecule unit tests 21 " <> $SessionUUID
			],
			ObjectP[Model[Molecule, "Thiophene for UploadMolecule unit tests 21 " <> $SessionUUID]]
		],
		Example[{Options, "State", "Use the State option to set the state of matter (Solid, Liquid, Gas) of this uploaded chemical:"},
			UploadMolecule["DMSO",
				State -> Liquid,
				Name -> "DMSO for UploadMolecule unit tests 22 " <> $SessionUUID,
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard",
				NFPA -> {2, 2, 0, {}}
			],
			ObjectP[Model[Molecule, "DMSO for UploadMolecule unit tests 22 " <> $SessionUUID]]
		],
		Example[{Options, "Density", "Use the Density option to set the density of this uploaded chemical:"},
			UploadMolecule["DMSO",
				Density -> 1.10 Gram / (Centimeter^3),
				State -> Liquid,
				Name -> "DMSO for UploadMolecule unit tests 23 " <> $SessionUUID,
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard",
				NFPA -> {2, 2, 0, {}}
			],
			ObjectP[Model[Molecule, "DMSO for UploadMolecule unit tests 23 " <> $SessionUUID]]
		],
		Example[{Options, "ExtinctionCoefficients", "Use the ExtinctionCoefficients option to set the Extinction Coefficient of this uploaded chemical. This field is in the format {{Wavelength,ExtinctionCoefficient}..}:"},
			UploadMolecule["Adenine",
				ExtinctionCoefficients -> {{260 Nanometer, 13400 Liter / (Centimeter * Mole)}},
				Name -> "Adenine for UploadMolecule unit tests 24 " <> $SessionUUID,
				NFPA -> {3, 1, 0, {}},
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard"
			],
			ObjectP[Model[Molecule, "Adenine for UploadMolecule unit tests 24 " <> $SessionUUID]]
		],
		Example[{Options, "StructureImageFile", "Use the StructureImageFile option to provide an image of the chemical's structure:"},
			UploadMolecule["617-45-8",
				Name -> "Aspartic Acid for UploadMolecule unit tests 25 " <> $SessionUUID,
				State -> Liquid,
				StructureImageFile -> "https://upload.wikimedia.org/wikipedia/commons/a/a1/Aspartic_Acidph.png"
			],
			ObjectP[Model[Molecule, "Aspartic Acid for UploadMolecule unit tests 25 " <> $SessionUUID]]
		],
		Example[{Options, "StructureFile", "Use the StructureFile option to provide the URL of a MOL file of the chemical's structure:"},
			UploadMolecule["Glutamic acid",
				Name -> "Glutamic acid for UploadMolecule unit tests 26 " <> $SessionUUID,
				StructureFile -> "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/33032/record/SDF/?record_type=2d&response_type=display"
			],
			ObjectP[Model[Molecule, "Glutamic acid for UploadMolecule unit tests 26 " <> $SessionUUID]]
		],
		Example[{Options, "MeltingPoint", "Use the MeltingPoint option to provide the temperature at which the solid form of Tyrosine will melt:"},
			UploadMolecule["Tyrosine",
				MeltingPoint -> 343.5 Celsius,
				Name -> "Tyrosine for UploadMolecule unit tests 27 "<> $SessionUUID,
				NFPA -> {2, 1, 0, {}},
				DOTHazardClass -> "Class 0"
			],
			ObjectP[Model[Molecule, "Tyrosine for UploadMolecule unit tests 27 " <> $SessionUUID]]
		],
		Example[{Options, "BoilingPoint", "Use the BoilingPoint option to provide the temperature at which the liquid form of DMSO will evaporate:"},
			UploadMolecule["DMSO",
				BoilingPoint -> 189 Celsius,
				Name -> "DMSO for UploadMolecule unit tests 28 " <> $SessionUUID,
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard",
				NFPA -> {2, 2, 0, {}}
			],
			ObjectP[Model[Molecule, "DMSO for UploadMolecule unit tests 28 " <> $SessionUUID]]
		],
		Example[{Options, "VaporPressure", "Use the VaporPressure option to provide the equilibrium pressure of DMSO when it is in thermodynamic equilibrium with its condensed phase:"},
			UploadMolecule["DMSO",
				Name -> "DMSO for UploadMolecule unit tests 29 " <> $SessionUUID,
				VaporPressure -> 0.049 Kilopascal ,
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard",
				NFPA -> {2, 2, 0, {}}
			],
			ObjectP[Model[Molecule, "DMSO for UploadMolecule unit tests 29 " <> $SessionUUID]]
		],
		Example[{Options, "Viscosity", "Use the Viscosity option to provide Water's internal friction, measured by the force per unit area resisting a flow between parallel layers of liquid:"},
			UploadMolecule["Water" ,
				Name -> "Water for UploadMolecule unit tests 30 " <> $SessionUUID,
				Viscosity -> 0.8949 Centipoise,
				Flammable -> False
			],
			ObjectP[Model[Molecule, "Water for UploadMolecule unit tests 30 " <> $SessionUUID]]
		],
		Example[{Options, "pKa", "Use the pKa option to specify the logarithmic acid dissociation constant of Glycine:"},
			UploadMolecule["Glycine",
				Name -> "Glycine for UploadMolecule unit tests 31 " <> $SessionUUID,
				pKa -> {2.37}
			],
			ObjectP[Model[Molecule, "Glycine for UploadMolecule unit tests 31 " <> $SessionUUID]]
		],
		Example[{Options, "Radioactive", "Use the Radioactive option to specify if the chemical sample is radioactive:"},
			UploadMolecule[PubChem[962],
				Name -> "Water for UploadMolecule unit tests 32 " <> $SessionUUID,
				Radioactive -> True,
				Flammable -> False,
				Fuming -> False
			],
			ObjectP[Model[Molecule, "Water for UploadMolecule unit tests 32 " <> $SessionUUID]]
		],
		Example[{Options, "Flammable", "Use the Flammable option to specify that the chemical is flammable:"},
			UploadMolecule[PubChem[702],
				Name -> "Ethanol for UploadMolecule unit tests 33 " <> $SessionUUID,
				Flammable -> True,
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard",
				NFPA -> {2, 3, 0, {}}
			],
			ObjectP[Model[Molecule, "Ethanol for UploadMolecule unit tests 33 " <> $SessionUUID]]
		],
		Example[{Options, "Acid", "Use the Acid option to specify that the chemical is a strong acid:"},
			UploadMolecule[PubChem[1118],
				Name -> "Sulfuric acid for UploadMolecule unit tests 34 " <> $SessionUUID,
				Acid -> True,
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard",
				NFPA -> {3, 0, 0, {}}
			],
			ObjectP[Model[Molecule, "Sulfuric acid for UploadMolecule unit tests 34 " <> $SessionUUID]]
		],
		Example[{Options, "Base", "Use the Base option to specify that the chemical is a strong base:"},
			UploadMolecule[PubChem[14798],
				Name -> "Sodium hydroxide for UploadMolecule unit tests 35 " <> $SessionUUID,
				Base -> True,
				DOTHazardClass -> "Class 8 Division 8 Corrosives Hazard",
				NFPA -> {3, 0, 1, {}}
			],
			ObjectP[Model[Molecule, "Sodium hydroxide for UploadMolecule unit tests 35 " <> $SessionUUID]]
		],
		Example[{Options, "Pyrophoric", "Use the Pyrophoric option to specify that the chemical ignites spontaneously with contact with air:"},
			UploadMolecule[PubChem[5360545],
				Name -> "Sodium for UploadMolecule unit tests 36 " <> $SessionUUID,
				Pyrophoric -> True,
				DOTHazardClass -> "Class 4 Division 4.3 Dangerous when Wet Hazard",
				NFPA -> {3, 3, 2, {WaterReactive}}
			],
			ObjectP[Model[Molecule, "Sodium for UploadMolecule unit tests 36 " <> $SessionUUID]]
		],
		Example[{Options, "WaterReactive", "Use the WaterReactive option to specify that the chemical reacts violently with contact with water:"},
			UploadMolecule[PubChem[5360545],
				WaterReactive -> True,
				Name -> "Sodium for UploadMolecule unit tests 37 " <> $SessionUUID,
				DOTHazardClass -> "Class 4 Division 4.3 Dangerous when Wet Hazard",
				NFPA -> {3, 3, 2, {WaterReactive}}
			],
			ObjectP[Model[Molecule, "Sodium for UploadMolecule unit tests 37 " <> $SessionUUID]]
		],
		Example[{Options, "Fuming", "Use the Fuming option to specify that the chemical sample produces fumes when exposed to air:"},
			UploadMolecule[PubChem[1118],
				Name -> "Sulfuric acid for UploadMolecule unit tests 38 " <> $SessionUUID,
				Fuming -> True,
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard",
				NFPA -> {3, 0, 0, {}}
			],
			ObjectP[Model[Molecule, "Sulfuric acid for UploadMolecule unit tests 38 " <> $SessionUUID]]
		],
		Example[{Options, "Ventilated", "Use the Ventilated option to specify that the chemical sample needs to be handled in a ventilated enclosure:"},
			UploadMolecule[PubChem[1118],
				Name -> "Sulfuric acid for UploadMolecule unit tests 39 " <> $SessionUUID,
				Ventilated -> True,
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard",
				NFPA -> {3, 0, 0, {}}
			],
			ObjectP[Model[Molecule, "Sulfuric acid for UploadMolecule unit tests 39 " <> $SessionUUID]]
		],
		Example[{Options, "Pungent", "Use the Pungent option to indicate that the sample has a strong odor:"},
			newMolecule = UploadMolecule[PubChem[8037],
				Name -> "TEMED for UploadMolecule unit tests 40 " <> $SessionUUID,
				Ventilated -> True,
				Pungent -> True,
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard",
				NFPA -> {2, 2, 0, {}}
			];
			Download[newMolecule, Pungent],
			True,
			Variables :> {newMolecule}
		],
		Example[{Options, "ParticularlyHazardousSubstance", "Use the ParticularlyHazardousSubstance option to specify that special precautions should be taken in handling this substance. This option should be set if the GHS Classification of the chemical is any of the following: Reproductive Toxicity (H340, H360, H362),  Acute Toxicity (H300, H310, H330, H370, H373), Carcinogenicity (H350):"},
			UploadMolecule[PubChem[712],
				ParticularlyHazardousSubstance -> True,
				Name -> "Formaldehyde for UploadMolecule unit tests 41 " <> $SessionUUID,
				DOTHazardClass -> "Class 7 Division 7 Radioactive Material Hazard",
				NFPA -> {3, 0, 0, {}},
				Flammable -> False,
				State -> Liquid,
				Synonyms -> {"Formaldehyde for UploadMolecule unit tests 41 " <> $SessionUUID, "Formaldehyde"}
			],
			ObjectP[Model[Molecule, "Formaldehyde for UploadMolecule unit tests 41 " <> $SessionUUID]]
		],
		Example[{Options, "DrainDisposal", "Use the DrainDisposal option to specify that this chemical sample can be safely disposed down a standard drain:"},
			UploadMolecule[PubChem[962],
				DrainDisposal -> True,
				Name -> "Water for UploadMolecule unit tests 42 " <> $SessionUUID,
				Flammable -> False,
				Fuming -> False
			],
			ObjectP[Model[Molecule, "Water for UploadMolecule unit tests 42 " <> $SessionUUID]]
		],
		Example[{Options, "MSDSFile", "Use the MSDSFile option to declare that an MSDS file is not required for a substance:"},
			UploadMolecule[PubChem[962],
				MSDSFile -> NotApplicable,
				Name -> "Water for UploadMolecule unit tests 43 " <> $SessionUUID
			],
			ObjectP[Model[Molecule, "Water for UploadMolecule unit tests 43 " <> $SessionUUID]]
		],
		Example[{Options, "MSDSFile", "Use the MSDSFile option to specify the URL of the MSDS PDF file for this chemical sample. The MSDSFile must be a URL that points to a PDF file. The PDF file will be downloaded and stored in Constellation on creation of this chemical model:"},
			UploadMolecule[PubChem[712],
				MSDSFile -> "http://www.sciencelab.com/msds.php?msdsId=9924095",
				Name -> "Formaldehyde for UploadMolecule unit tests 44 " <> $SessionUUID,
				ParticularlyHazardousSubstance -> True,
				DOTHazardClass -> "Class 7 Division 7 Radioactive Material Hazard",
				NFPA -> {3, 0, 0, {}},
				Flammable -> False,
				State -> Liquid,
				Synonyms -> {"Formaldehyde for UploadMolecule unit tests 44 " <> $SessionUUID, "Formaldehyde-14C", "Formaldehyde"}
			],
			ObjectP[Model[Molecule, "Formaldehyde for UploadMolecule unit tests 44 " <> $SessionUUID]]
		],
		Example[{Options, "NFPA", "Use the NFPA option to specify the National Fire Protection Association (NFPA) 704 Hazard diamond classification of this substance. This option is specified in the format {HealthRating,FlammabilityRating,ReactivityRating,SpecialConsiderationsList}. The valid symbols to include in SpecialConsiderationsList are Oxidizer|WaterReactive|Aspyxiant|Corrosive|Acid|Bio|Poisonous|Radioactive|Cryogenic|Null. The following chemical, formaldehyde, as an NFPA of {3,0,0,{Radioactive}} which means that its Health rating is 3, its Flammability rating is 0, and its Reactivity rating is 0. The special consideration of this chemical is that it is radioactive:"},
			UploadMolecule[PubChem[712],
				NFPA -> {3, 0, 0, {Radioactive}},
				ParticularlyHazardousSubstance -> True,
				Name -> "Formaldehyde for UploadMolecule unit tests 45 " <> $SessionUUID,
				DOTHazardClass -> "Class 7 Division 7 Radioactive Material Hazard",
				Flammable -> False,
				State -> Liquid,
				Synonyms -> {"Formaldehyde for UploadMolecule unit tests 45 " <> $SessionUUID, "Formaldehyde"}
			],
			ObjectP[Model[Molecule, "Formaldehyde for UploadMolecule unit tests 45 " <> $SessionUUID]]
		],
		Example[{Options, "NFPA", "Use the NFPA option to specify the National Fire Protection Association (NFPA) 704 Hazard diamond classification of this substance. This option is specified in the format {HealthRating,FlammabilityRating,ReactivityRating,SpecialConsiderationsList}. The valid symbols to include in SpecialConsiderationsList are Oxidizer|WaterReactive|Aspyxiant|Corrosive|Acid|Bio|Poisonous|Radioactive|Cryogenic|Null. The following chemical, water, has an NFPA of {0,0,0,{}} which means that its Health, Flammability, and Reactivity ratings are 0 and there are no special considerations to take into account:"},
			UploadMolecule[PubChem[962],
				NFPA -> {0, 0, 0, {}},
				Name -> "Water for UploadMolecule unit tests 46 " <> $SessionUUID,
				Flammable -> False,
				Fuming -> False
			],
			ObjectP[Model[Molecule, "Water for UploadMolecule unit tests 46 " <> $SessionUUID]]
		],
		Example[{Options, "DOTHazardClass", "Use the DOTHazardClass option to set the DOT Hazard Class of this uploaded chemical. The valid values of this option can be found by evaluating DOTHazardClassP. The following chemical is part of DOT Hazard Class 9:"},
			UploadMolecule["62-31-7",
				DOTHazardClass -> "Class 9 Miscellaneous Dangerous Goods Hazard",
				Name -> "Dopamine for UploadMolecule unit tests 47 " <> $SessionUUID,
				NFPA -> {1, 1, 0, {}},
				Flammable -> True,
				State -> Solid
			],
			ObjectP[Model[Molecule, "Dopamine for UploadMolecule unit tests 47 " <> $SessionUUID]]
		],
		Example[{Options, "BiosafetyLevel", "Use the BiosafetyLevel option to specify the biosafety level of this chemical sample, if applicable:"},
			UploadMolecule["76862-65-2",
				BiosafetyLevel -> "BSL-2",
				Name -> "Conotoxin for UploadMolecule unit tests 48 " <> $SessionUUID,
				State -> Solid,
				NFPA -> {4, 0, 0, Null},
				Flammable -> False,
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard"
			],
			ObjectP[Model[Molecule, "Conotoxin for UploadMolecule unit tests 48 " <> $SessionUUID]]
		],
		Example[{Options, "LightSensitive", "Use the LightSensitive option to specify if the chemical sample is light sensitive and special precautions should be taken to make sure that the sample is handled in a dark room:"},
			UploadMolecule["Acetonitrile",
				Name -> "Acetonitrile (test for UploadMolecule 53 " <> $SessionUUID,
				LightSensitive -> False,
				IncompatibleMaterials -> {Nitrile, Polypropylene}
			],
			ObjectP[Model[Molecule, "Acetonitrile (test for UploadMolecule 53 " <> $SessionUUID]]
		],
		Example[{Options, "IncompatibleMaterials", "Use the IncompatibleMaterials option to specify the list of materials that would become damaged if wetted by this chemical sample. Use MaterialP to see the materials that can be used in this field. Specify {None} if there are no IncompatibleMaterials:"},
			UploadMolecule["Acetonitrile",
				Name -> "Acetonitrile for UploadMolecule unit tests 49 " <> $SessionUUID,
				LightSensitive -> False,
				IncompatibleMaterials -> {Nitrile, Polypropylene}
			],
			ObjectP[Model[Molecule, "Acetonitrile for UploadMolecule unit tests 49 " <> $SessionUUID]]
		],
		Example[{Options, "IncompatibleMaterials", "Use the IncompatibleMaterials option to specify the list of materials that would become damaged if wetted by this chemical sample. Use MaterialP to see the materials that can be used in this field. Specify {None} if there are no IncompatibleMaterials:"},
			UploadMolecule[PubChem[962],
				Name -> "Water for UploadMolecule unit tests 50 " <> $SessionUUID,
				Flammable -> False,
				Fuming -> False
			],
			ObjectP[Model[Molecule, "Water for UploadMolecule unit tests 50 " <> $SessionUUID]]
		],
		Example[{Options, "HazardousBan", "Use the HazardousBan option to indicate that samples of this model are currently banned from usage in the ECL because the facility isn't yet equipped to handle them:"},
			UploadMolecule[PubChem[8376],
				HazardousBan -> True,
				Name -> "TNT (test for UploadMolecule 56 " <> $SessionUUID,
				ParticularlyHazardousSubstance -> True,
				Flammable -> True,
				DOTHazardClass -> "Class 1 Division 1.1 Mass Explosion Hazard",
				NFPA -> {2, 4, 4, {}}
			],
			ObjectP[Model[Molecule, "TNT (test for UploadMolecule 56 " <> $SessionUUID]]
		],
		Example[{Options, "Expires", "Use the Expires option to indicate if this chemical expires:"},
			UploadMolecule[PubChem[962],
				Name -> "Water for UploadMolecule unit tests 51 " <> $SessionUUID,
				Flammable -> False,
				Fuming -> False
			],
			ObjectP[Model[Molecule, "Water for UploadMolecule unit tests 51 " <> $SessionUUID]]
		],
		Example[{Options, "LiquidHandlerIncompatible", "Use the LiquidHandlerIncompatible option to specify that the chemical sample cannot be reliably aspirated or dispensed by a liquid handling robot. In the following example, Methanol cannot accurately be aspirated by a liquid handling robot so LiquidHandlerIncompatible->True:"},
			UploadMolecule[PubChem[887],
				Name -> "Methanol for UploadMolecule unit tests 52 " <> $SessionUUID,
				LiquidHandlerIncompatible -> True,
				IncompatibleMaterials -> {ABS, Polyurethane},
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard",
				NFPA -> {1, 3, 0, {}}
			],
			ObjectP[Model[Molecule, "Methanol for UploadMolecule unit tests 52 " <> $SessionUUID]]
		],
		Example[{Options, "UltrasonicIncompatible", "Use the UltrasonicIncompatible option to specify that volume measurements of samples of this model cannot be performed via the ultrasonic distance method due to vapors interfering with the reading:"},
			UploadMolecule[PubChem[3283],
				Name -> "Diethylether for UploadMolecule unit tests 53 " <> $SessionUUID,
				UltrasonicIncompatible -> True
			],
			ObjectP[Model[Molecule, "Diethylether for UploadMolecule unit tests 53 " <> $SessionUUID]]
		],
		Example[{Options, "Fluorescent", "Use the Fluorescent option to specify that the molecule is fluorescent:"},
			UploadMolecule["SYBR Green",
				Name -> "SYBR Green for UploadMolecule unit tests 54 " <> $SessionUUID,
				State -> Liquid,
				MSDSFile -> NotApplicable,
				Fluorescent -> True,
				FluorescenceExcitationMaximums -> {497 * Nanometer},
				FluorescenceEmissionMaximums -> {521 * Nanometer}
			],
			ObjectP[Model[Molecule, "SYBR Green for UploadMolecule unit tests 54 " <> $SessionUUID]]
		],
		Example[{Options, "DetectionLabel", "Indicates whether this molecule (e.g. Alexa Fluor 488) can be attached to another molecule and act as a tag that can indicate the presence and amount of the other molecule:"},
			UploadMolecule["Alexa Fluor 488 para-isomer",
				Name -> "Alexa Fluor 488 for UploadMolecule unit tests 55 " <> $SessionUUID,
				State -> Solid,
				MSDSFile -> NotApplicable,
				DetectionLabel -> True
			],
			ObjectP[Model[Molecule, "Alexa Fluor 488 for UploadMolecule unit tests 55 " <> $SessionUUID]]
		],
		Example[{Options, "AffinityLabel", "Indicates whether this molecule can be attached to another molecule and act as a tag that can indicate the presence and amount of the other molecule (e.g. His tag):"},
			UploadMolecule["His Tag",
				Name -> "His Tag for UploadMolecule unit tests 56 " <> $SessionUUID,
				IncompatibleMaterials -> {None},
				State -> Solid,
				MSDSFile -> NotApplicable,
				AffinityLabel -> True
			],
			ObjectP[Model[Molecule, "His Tag for UploadMolecule unit tests 56 " <> $SessionUUID]],
			Messages :> {Error::CompoundNotFound}
		],
		Example[{Options, "DetectionLabels", "Indicates the tags (e.g. Alexa Fluor 488) that the molecule contains, which can indicate the presence and amount of the molecule:"},
			UploadMolecule["Alexa Fluor 488-Tethered Phalloidin",
				Name -> "Alexa Fluor 488-Tethered Phalloidin for UploadMolecule unit tests 57 " <> $SessionUUID,
				IncompatibleMaterials -> {None},
				State -> Solid,
				MSDSFile -> NotApplicable,
				DetectionLabels -> {Model[Molecule, "Alexa Fluor 488 for UploadMolecule unit tests 58 " <> $SessionUUID]}
			],
			ObjectP[Model[Molecule, "Alexa Fluor 488-Tethered Phalloidin for UploadMolecule unit tests 57 " <> $SessionUUID]],
			SetUp :> {
				UploadMolecule["Alexa Fluor 488 meta-isomer",
					Name -> "Alexa Fluor 488 for UploadMolecule unit tests 58 " <> $SessionUUID,
					State -> Solid,
					MSDSFile -> NotApplicable,
					DetectionLabel -> True,
					Force -> True
				]
			},
			Messages :> {Error::CompoundNotFound}
		],
		Example[{Options, "AffinityLabels", "Indicates the tags (e.g. biotin) that the molecule contains, which has high binding capacity with other materials:"},
			UploadMolecule["Biotinylated Glycosylphosphatidylinositol",
				Name -> "Biotinylated Glycosylphosphatidylinositol for UploadMolecule unit tests 59 " <> $SessionUUID,
				IncompatibleMaterials -> {None},
				State -> Solid,
				MSDSFile -> NotApplicable,
				AffinityLabels -> {Link[Model[Molecule, "Biotin for UploadMolecule unit tests 60 " <> $SessionUUID]]}
			],
			ObjectP[Model[Molecule, "Biotinylated Glycosylphosphatidylinositol for UploadMolecule unit tests 59 " <> $SessionUUID]],
			SetUp :> {
				UploadMolecule["Biotin",
					Name -> "Biotin for UploadMolecule unit tests 60 " <> $SessionUUID,
					State -> Solid,
					MSDSFile -> NotApplicable,
					AffinityLabel -> True,
					Force -> True
				]
			},
			Messages :> {Error::CompoundNotFound}
		],
		Example[{Options, "Chiral", "If a sample is a enantiomer, that cannot be superposed on its mirror image by any combination of rotations and translations:"},
			newMolecule = UploadMolecule["5989-27-5",
				Name -> "(R)-(+)-Limonene for UploadMolecule unit tests 61 " <> $SessionUUID,
				Chiral -> True,
				Ventilated -> True,
				Pungent -> True,
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard",
				NFPA -> {3, 2, 0, {}},
				Flammable -> True
			];
			Download[newMolecule, Chiral],
			True,
			Variables :> {newMolecule}
		],
		Example[{Options, "Racemic", "If a sample is a racemic compound, this field represents equal amounts of left- and right-handed enantiomers of a chiral molecule.:"},
			newMolecule = UploadMolecule["5872-08-2",
				Name -> "Camphor-10-sulfonic acid for UploadMolecule unit tests 62 " <> $SessionUUID,
				Racemic -> True,
				Ventilated -> True,
				Pungent -> True,
				State -> Solid,
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard",
				NFPA -> {3, 1, 1, {}}
			];
			Download[newMolecule, Racemic],
			True,
			Variables :> {newMolecule}
		],
		(* EnantiomerPair *)
		Example[{Options, "EnantiomerForms", "If this molecule is racemic (Racemic -> True), indicates models for its left- and right-handed enantiomers."},
			newMolecule = UploadMolecule["5872-08-2",
				Name -> "Camphor-10-sulfonic acid for UploadMolecule unit tests 63 " <> $SessionUUID,
				Racemic -> True,
				EnantiomerForms -> {Link[Model[Molecule, "(1R)-(-)-10-camphorsulfonic acid"]], Link[Model[Molecule, "(1S)-(+)-10-Camphorsulfonic acid"]]},
				Ventilated -> True,
				Pungent -> True,
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard",
				NFPA -> {3, 1, 1, {}}
			];
			Download[newMolecule, EnantiomerForms],
			{ObjectP[Model[Molecule, "(1R)-(-)-10-camphorsulfonic acid"]], ObjectP[Model[Molecule, "(1S)-(+)-10-Camphorsulfonic acid"]]},
			Variables :> {newMolecule}
		],
		Example[{Options, "RacemicForm", "If this molecule is one of the enantiomers (Chiral -> True), indicates the model for its racemic form."},
			newMolecule = UploadMolecule["35963-20-3",
				Name -> "(1R)-(-)-10-Camphorsulfonic acid for UploadMolecule unit tests 64 " <> $SessionUUID,
				Chiral -> True,
				RacemicForm -> Link[Model[Molecule, "(1R)-(-)-10-camphorsulfonic acid"]],
				Ventilated -> True,
				Pungent -> True,
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard",
				NFPA -> {3, 1, 1, {}},
				Flammable -> True,
				State -> Solid
			];
			Download[newMolecule, RacemicForm],
			ObjectP[Model[Molecule, "(1R)-(-)-10-camphorsulfonic acid"]],
			Variables :> {newMolecule}
		],
		Example[{Options, "EnantiomerPair", "If this molecule is one of the enantiomers (Chiral -> True), indicates the model for its racemic form."},
			newMolecule = UploadMolecule["35963-20-3",
				Name -> "(1R)-(-)-10-Camphorsulfonic acid for UploadMolecule unit tests 65 " <> $SessionUUID,
				Chiral -> True,
				EnantiomerPair -> Link[Model[Molecule, "(1S)-(+)-10-Camphorsulfonic acid"]],
				Ventilated -> True,
				Pungent -> True,
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard",
				NFPA -> {3, 1, 1, {}},
				Flammable -> True,
				State -> Solid
			];
			Download[newMolecule, EnantiomerPair],
			ObjectP[Model[Molecule, "(1S)-(+)-10-Camphorsulfonic acid"]],
			Variables :> {newMolecule}
		],
		Example[{Additional, "If attempting to create a new molecule, but that molecule already exists in the database, automatically modify the existing object:"},
			molecule = UploadMolecule[
				"58-08-2",
				Name -> "Caffeine for UploadMolecule unit tests 66 " <> $SessionUUID,
				MolecularWeight -> 100.0 Dalton,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				State -> Solid
			];
			Download[
				molecule,
				{
					Object,
					Name,
					MolecularWeight,
					ExactMass
				}
			],
			{
				ObjectP[Model[Molecule, "Caffeine for UploadMolecule unit tests 66 " <> $SessionUUID]],
				"Caffeine for UploadMolecule unit tests 66 " <> $SessionUUID,
				EqualP[100 Dalton], (* From new options *)
				EqualP[99.9 Dalton] (* From original object *)
			},
			Messages :> {
				Warning::ObjectAlreadyExists
			},
			Stubs :> {
				(* Turn on duplicate checking *)
				$installDefaultUploadFunctionDuplicateChecking = True,

				(* Only find the duplicate we just created *)
				(*$RequiredSearchName = "for UploadMolecule unit tests 66 " <> $SessionUUID*)
				(* $RequiredSearchName doesn't work as we're already searching on the Name field. To be fixed *)
				(* So implement manually *)
				Search[x : Model[Molecule], y_Or, z__] = Search[x, And[y, StringContainsQ[Name, "for UploadMolecule unit tests 66 " <> $SessionUUID]], z]
			},
			SetUp :> {
				UploadMolecule[
					"58-08-2",
					Name -> "Caffeine for UploadMolecule unit tests 66 " <> $SessionUUID,
					ExactMass -> 99.9 Dalton,
					MolecularWeight -> 99.9 Dalton,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					State -> Solid,
					Force -> True
				]
			},
			Variables :> {molecule}
		],
		Example[{Messages, "VentilatedRequired", "If a sample is marked as Pungent it must be set to Ventilated:"},
			UploadMolecule[PubChem[5364519],
				Name -> "cis-5-Octen-1-ol for UploadMolecule unit tests 67 " <> $SessionUUID,
				Ventilated -> False,
				Pungent -> True,
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard",
				NFPA -> {2, 2, 0, {}}
			],
			$Failed,
			Messages :> {
				Error::VentilatedRequired,
				Error::InvalidOption
			}
		],
		Test["Test Command Builder output, options:",
			UploadMolecule[PubChem[962],
				NFPA -> {0, 0, 0, {}},
				Name -> "Water for UploadMolecule unit tests 68 " <> $SessionUUID,
				Flammable -> False,
				Fuming -> False,
				Output -> Options
			],
			{_Rule...}
		],
		Test["Test Command Builder output, results and tests:",
			UploadMolecule[PubChem[962],
				NFPA -> {0, 0, 0, {}},
				Name -> "Water for UploadMolecule unit tests 69 " <> $SessionUUID,
				Flammable -> False,
				Fuming -> False,
				Output -> {Result, Tests}
			],
			{ObjectP[Model[Molecule, "Water for UploadMolecule unit tests 69 " <> $SessionUUID]], {_EmeraldTest..}}
		],
		Test["Ensure MolecularFormula retains the correct capitalization of elements:",
			UploadMolecule["98-88-4",
				Name -> "Benzoyl chloride for UploadMolecule unit tests 70 " <> $SessionUUID,
				State -> Solid,
				DOTHazardClass -> "Class 4 Division 4.3 Dangerous when Wet Hazard",
				NFPA -> {3, 3, 1, {}}
			];
			Download[Model[Molecule, "Benzoyl chloride for UploadMolecule unit tests 70 " <> $SessionUUID], MolecularFormula],
			"C7H5ClO"
		],
		Example[{Messages, "InvalidURL", "Throw an error if the MSDS File URL doesn't return a pdf:"},
			UploadMolecule[PubChem[702],
				Name -> "ethanol for UploadMolecule unit tests 71 " <> $SessionUUID,
				MSDSFile -> "www.emeraldcloudlab.com"
			],
			$Failed,
			Messages :> {
				Error::InvalidURL,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidURL", "Throw an error if the Structure File URL doesn't return a valid structure:"},
			UploadMolecule[PubChem[702],
				Name -> "ethanol for UploadMolecule unit tests 74 " <> $SessionUUID,
				StructureFile -> "www.emeraldcloudlab.com"
			],
			$Failed,
			Messages :> {
				Error::InvalidURL,
				Error::InvalidOption
			},
			(* As structure file doesn't have any validation, we'd need an invalid URL. But that might be in flux, so just stub it to make it reliable *)
			Stubs :> {downloadAndValidateURL[_, _, StructureFile] = $Failed}
		],
		Example[{Messages, "InvalidURL", "Throw an error if the Structure Image File URL doesn't return an image:"},
			UploadMolecule[PubChem[702],
				Name -> "ethanol for UploadMolecule unit tests 73 " <> $SessionUUID,
				StructureImageFile -> "www.emeraldcloudlab.com"
			],
			$Failed,
			Messages :> {
				Error::InvalidURL,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidLocalFile", "Throw an error if the Structure File filepath doesn't return a valid structure when imported:"},
			UploadMolecule[PubChem[702],
				Name -> "ethanol for UploadMolecule unit tests 74 " <> $SessionUUID,
				StructureFile -> FileNameJoin["C:\\not\\a\\real\\path.sdf"]
			],
			$Failed,
			Messages :> {
				Error::InvalidLocalFile,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidLocalFile", "Throw an error if the Structure Image File filepath doesn't return an image when imported:"},
			UploadMolecule[PubChem[702],
				Name -> "ethanol for UploadMolecule unit tests 83 " <> $SessionUUID,
				StructureImageFile -> FileNameJoin["C:\\not\\a\\real\\path.png"]
			],
			$Failed,
			Messages :> {
				Error::InvalidLocalFile,
				Error::InvalidOption
			}
		],
		Example[{Messages, "URLNotFound", "If the given Thermo URL cannot be connected because it is invalid, throw a hard error asking the user to correct it."},
			UploadMolecule["https://www.thermofisher.com/order/catalog/product/doesnotexist", Name -> "doesnotexist1" <> $SessionUUID, NFPA -> {4, 3, 1, {}},
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard",
				State -> Liquid,
				IncompatibleMaterials -> {None},
				MSDSFile -> NotApplicable
			],
			$Failed,
			Messages :> {
				Error::URLNotFound,
				Error::InvalidInput
			}
		],
		Example[{Messages, "InvalidIdentifier", "Throws an error and returns $Failed if an invalid PubChem ID is provided as input:"},
			UploadMolecule[
				PubChem[0]
			],
			$Failed,
			Messages :> {
				Error::InvalidIdentifier,
				Error::InvalidInput
			}
		],
		Example[{Messages, "InvalidIdentifier", "Throws an error and continues if an invalid PubChem ID is provided as option:"},
			UploadMolecule[
				PubChemID -> 9999999999,
				Name -> "Test molecule for for UploadMolecule unit tests 84 " <> $SessionUUID,
				State -> Solid,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}
			],
			ObjectReferenceP[Model[Molecule]],
			Messages :> {
				Error::InvalidIdentifier
			}
		],
		Example[{Messages, "InvalidIdentifier", "Throws an error and returns $Failed if an invalid InChI is provided as input:"},
			UploadMolecule[
				"InChI=abc"
			],
			$Failed,
			Messages :> {
				Error::InvalidIdentifier,
				Error::InvalidInput
			}
		],
		Example[{Messages, "InvalidIdentifier", "Throws an error and continues if an invalid InChI is provided as option:"},
			UploadMolecule[
				InChI -> "InChI=abc",
				Name -> "Test molecule for for UploadMolecule unit tests 85 " <> $SessionUUID,
				State -> Solid,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}
			],
			ObjectReferenceP[Model[Molecule]],
			Messages :> {
				Error::InvalidIdentifier
			}
		],
		Example[{Messages, "CompoundNotFound", "Throws an error and returns $Failed if an invalid InChIKey is provided as input:"},
			UploadMolecule[
				"RYYVLZVUVIJVGH-UHFFFAOYSA-X"
			],
			$Failed,
			Messages :> {
				Error::CompoundNotFound,
				Error::InvalidInput
			}
		],
		Example[{Messages, "CompoundNotFound", "Throws an error and continues if an invalid InChIKey is provided as option:"},
			UploadMolecule[
				InChIKey -> "RYYVLZVUVIJVGH-UHFFFAOYSA-X",
				Name -> "Test molecule for for UploadMolecule unit tests 86 " <> $SessionUUID,
				State -> Solid,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}
			],
			ObjectReferenceP[Model[Molecule]],
			Messages :> {
				Error::CompoundNotFound
			}
		],
		Example[{Messages, "CompoundNotFound", "Throws an error and returns $Failed if an invalid CAS Number is provided as input:"},
			UploadMolecule[
				"00-00-0"
			],
			$Failed,
			Messages :> {
				Error::CompoundNotFound,
				Error::InvalidInput
			}
		],
		Example[{Messages, "CompoundNotFound", "Throws an error and continues if an invalid CAS Number is provided as option:"},
			UploadMolecule[
				CAS -> "00-00-0",
				Name -> "Test molecule for for UploadMolecule unit tests 79 " <> $SessionUUID,
				State -> Solid,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}
			],
			ObjectReferenceP[Model[Molecule]],
			Messages :> {
				Error::CompoundNotFound
			}
		],
		Example[{Messages, "CompoundNotFound", "Throws a warning and continues if a name is provided as input and it doesn't match a known compound:"},
			UploadMolecule[
				"Unknown compound" <> $SessionUUID,
				State -> Liquid,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}
			],
			ObjectReferenceP[Model[Molecule]],
			Messages :> {
				Error::CompoundNotFound
			}
		],
		Example[{Messages, "BadRequest", "If the given input URL cannot be connected because the server responds with 400 bad request, throw an error and return $Failed."},
			UploadMolecule["https://www.thermofisher.com/", Name -> "doesnotexist2" <> $SessionUUID, NFPA -> {4, 3, 1, {}},
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard",
				State -> Liquid,
				IncompatibleMaterials -> {None},
				MSDSFile -> NotApplicable
			],
			$Failed,
			Messages :> {
				Error::BadRequest,
				Error::InvalidInput
			},
			Stubs :> {parseThermoURL[___] := 400}
		],
		Example[{Messages, "APIRateLimit", "If the given input URL cannot be connected because the server responds with 429 rate limiting, throw an error and return $Failed."},
			UploadMolecule["https://www.thermofisher.com/", Name -> "doesnotexist3" <> $SessionUUID, NFPA -> {4, 3, 1, {}},
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard",
				State -> Liquid,
				IncompatibleMaterials -> {None},
				MSDSFile -> NotApplicable
			],
			$Failed,
			Messages :> {
				Error::APIRateLimit,
				Error::InvalidInput
			},
			Stubs :> {
				parseThermoURL[___] := 429,
				(* Skip the exponential back-off for testing *)
				Pause[___] := Null
			}
		],
		Example[{Messages, "APIUnavailable", "If the given input URL cannot be connected because the server responds with 503 server maintenance, throw an error and return $Failed."},
			UploadMolecule["https://www.thermofisher.com/", Name -> "doesnotexist4" <> $SessionUUID, NFPA -> {4, 3, 1, {}},
				DOTHazardClass -> "Class 3 Flammable Liquids Hazard",
				State -> Liquid,
				IncompatibleMaterials -> {None},
				MSDSFile -> NotApplicable
			],
			$Failed,
			Messages :> {
				Error::APIUnavailable,
				Error::InvalidInput
			},
			Stubs :> {
				parseThermoURL[___] := 503,
				(* Skip the exponential back-off for testing *)
				Pause[___] := Null
			}
		],
		Example[{Messages, "InputOptionMismatch", "Throws an error and returns $Failed if an option conflicts with the input:"},
			UploadMolecule[
				PubChem[702],
				PubChemID -> 704,
				Name -> "ethanol for UploadMolecule unit tests 83 " <> $SessionUUID
			],
			$Failed,
			Messages :> {
				Error::InputOptionMismatch,
				Error::InvalidOption
			}
		],
		Test["Result, options and tests are returned as expected when the function encounters a non-fatal but blocking error:",
			UploadMolecule[PubChem[702],
				Name -> "ethanol for UploadMolecule unit tests 81 " <> $SessionUUID,
				Ventilated -> False,
				Pungent -> True,
				IncompatibleMaterials -> {None},
				State -> Liquid,
				Output -> {Result, Options, Tests}
			],
			{
				$Failed,
				{_Rule...},
				{_EmeraldTest..}
			},
			Messages :> {
				Error::VentilatedRequired,
				Error::InvalidOption
			}
		],
		Test["Result, options and tests are returned as expected when the functions throws a warning to a user:",
			UploadMolecule["ethanol for UploadMolecule unit tests 82 " <> $SessionUUID,
				State -> Liquid,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Upload -> False,
				Output -> {Result, Options, Tests}
			],
			{
				{PacketP[]..},
				{_Rule...},
				{_EmeraldTest..}
			},
			Messages :> {
				Error::CompoundNotFound
			},
			Stubs :> {
				(* Function has fewer checks for a user, so simulate that we are a user *)
				$PersonID = Object[User, "id:TestUser"]
			}
		],
		Test["The StructureImageFile option successfully downloads an image from the internet and uploads it to constellation:",
			molecule = UploadMolecule["617-45-8",
				Name -> "Aspartic Acid for UploadMolecule unit tests 83 " <> $SessionUUID,
				State -> Liquid,
				StructureImageFile -> "https://upload.wikimedia.org/wikipedia/commons/a/a1/Aspartic_Acidph.png"
			];
			ImportCloudFile[molecule[StructureImageFile]],

			_?ImageQ,
			Variables :> {
				molecule
			}
		],
		Test["The StructureFile option successfully downloads a molecular structure from the internet and uploads it to constellation:",
			molecule = UploadMolecule["Glutamic acid",
				Name -> "Glutamic acid for UploadMolecule unit tests 84 " <> $SessionUUID,
				StructureFile -> "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/33032/record/SDF/?record_type=2d&response_type=display"
			];
			ImportCloudFile[molecule[StructureFile]],

			{{33032}, {___}..},
			Variables :> {
				molecule
			}
		],
		Test["The StructureImageFile option successfully imports an image from local storage and uploads it to constellation:",
			molecule = UploadMolecule["617-45-8",
				Name -> "Aspartic Acid for UploadMolecule unit tests 85 " <> $SessionUUID,
				State -> Liquid,
				StructureImageFile -> localFile
			];
			ImportCloudFile[molecule[StructureImageFile]],

			_?ImageQ,
			Variables :> {
				molecule,
				localFile
			},
			SetUp :> {
				localFile = DownloadCloudFile[
					EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard4/a9557e8d9b5ce7efacaa523b5e87b17a.png"],
					$TemporaryDirectory
				]
			}
		],
		Test["The StructureFile option successfully imports a molecular structure from local storage and uploads it to constellation:",
			molecule = UploadMolecule["Glutamic acid",
				Name -> "Glutamic acid for UploadMolecule unit tests 86 " <> $SessionUUID,
				StructureFile -> localFile
			];
			ImportCloudFile[molecule[StructureFile]],

			{_Molecule},
			Variables :> {
				molecule,
				localFile
			},
			SetUp :> {
				localFile = DownloadCloudFile[
					EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard10/d1df558307e9bf5b32c9a621951efe28.sdf", ""],
					$TemporaryDirectory
				]
			}
		],
		Example[{Messages, "DuplicateObjects", "If an existing object is found with the same name, the existing object if modified rather than creating a new object and a warning is thrown:"},
			molecule = UploadMolecule[
				"Caffeine for UploadMolecule unit tests 87 " <> $SessionUUID,
				MolecularWeight -> 100.0 Dalton,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				State -> Solid
			];
			Download[
				molecule,
				{
					Object,
					Name,
					MolecularWeight,
					ExactMass
				}
			],
			{
				ObjectP[Model[Molecule, "Caffeine for UploadMolecule unit tests 87 " <> $SessionUUID]],
				"Caffeine for UploadMolecule unit tests 87 " <> $SessionUUID,
				EqualP[100 Dalton], (* From new options *)
				EqualP[99.9 Dalton] (* From original object *)
			},
			Messages :> {
				Error::CompoundNotFound, (* Not found in pubchem as no identifiers provided directly *)
				Warning::ObjectAlreadyExists
			},
			Stubs :> {
				(* Turn on duplicate checking *)
				$installDefaultUploadFunctionDuplicateChecking = True,

				(* Only find the duplicate we just created *)
				(*$RequiredSearchName = "for UploadMolecule unit tests 87 " <> $SessionUUID*)
				(* $RequiredSearchName doesn't work as we're already searching on the Name field. To be fixed *)
				(* So implement manually *)
				Search[x : Model[Molecule], y_Or, z__] = Search[x, And[y, StringContainsQ[Name, "for UploadMolecule unit tests 87 " <> $SessionUUID]], z]
			},
			SetUp :> {
				Upload[
					(* Raw upload to ensure that other identifiers aren't populated so they can't match *)
					<|
						Type -> Model[Molecule],
						Name -> "Caffeine for UploadMolecule unit tests 87 " <> $SessionUUID,
						ExactMass -> 99.9 Dalton,
						MolecularWeight -> 99.9 Dalton
					|>
				]
			},
			Variables :> {molecule}
		],
		Example[{Messages, "DuplicateObjects", "If an existing object is found with the same CAS, the existing object if modified rather than creating a new object and a warning is thrown:"},
			molecule = UploadMolecule[
				"58-08-2",
				MolecularWeight -> 100.0 Dalton,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				State -> Solid
			];
			Download[
				molecule,
				{
					Object,
					Name,
					CAS,
					MolecularWeight,
					ExactMass
				}
			],
			{
				ObjectP[Model[Molecule, "Caffeine for UploadMolecule unit tests 88 " <> $SessionUUID]],
				"Caffeine for UploadMolecule unit tests 88 " <> $SessionUUID,
				"58-08-2",
				EqualP[100 Dalton], (* From new options *)
				EqualP[99.9 Dalton] (* From original object *)
			},
			Messages :> {
				Warning::ObjectAlreadyExists
			},
			Stubs :> {
				(* Turn on duplicate checking *)
				$installDefaultUploadFunctionDuplicateChecking = True,

				(* Only find the duplicate we just created *)
				(*$RequiredSearchName = "for UploadMolecule unit tests 88 " <> $SessionUUID*)
				(* $RequiredSearchName doesn't work as we're already searching on the Name field. To be fixed *)
				(* So implement manually *)
				Search[x : Model[Molecule], y_Or, z__] = Search[x, And[y, StringContainsQ[Name, "for UploadMolecule unit tests 88 " <> $SessionUUID]], z]
			},
			SetUp :> {
				Upload[
					(* Raw upload to ensure that other identifiers aren't populated so they can't match *)
					<|
						Type -> Model[Molecule],
						Name -> "Caffeine for UploadMolecule unit tests 88 " <> $SessionUUID,
						CAS -> "58-08-2",
						ExactMass -> 99.9 Dalton,
						MolecularWeight -> 99.9 Dalton
					|>
				]
			},
			Variables :> {molecule}
		],
		Example[{Messages, "DuplicateObjects", "If an existing object is found with the same InChI, the existing object if modified rather than creating a new object and a warning is thrown:"},
			molecule = UploadMolecule[
				"InChI=1S/C8H10N4O2/c1-10-4-9-6-5(10)7(13)12(3)8(14)11(6)2/h4H,1-3H3",
				MolecularWeight -> 100.0 Dalton,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				State -> Solid
			];
			Download[
				molecule,
				{
					Object,
					Name,
					InChI,
					MolecularWeight,
					ExactMass
				}
			],
			{
				ObjectP[Model[Molecule, "Caffeine for UploadMolecule unit tests 89 " <> $SessionUUID]],
				"Caffeine for UploadMolecule unit tests 89 " <> $SessionUUID,
				"InChI=1S/C8H10N4O2/c1-10-4-9-6-5(10)7(13)12(3)8(14)11(6)2/h4H,1-3H3",
				EqualP[100 Dalton], (* From new options *)
				EqualP[99.9 Dalton] (* From original object *)
			},
			Messages :> {
				Warning::ObjectAlreadyExists
			},
			Stubs :> {
				(* Turn on duplicate checking *)
				$installDefaultUploadFunctionDuplicateChecking = True,

				(* Only find the duplicate we just created *)
				(*$RequiredSearchName = "for UploadMolecule unit tests 89 " <> $SessionUUID*)
				(* $RequiredSearchName doesn't work as we're already searching on the Name field. To be fixed *)
				(* So implement manually *)
				Search[x : Model[Molecule], y_Or, z__] = Search[x, And[y, StringContainsQ[Name, "for UploadMolecule unit tests 89 " <> $SessionUUID]], z]
			},
			SetUp :> {
				Upload[
					(* Raw upload to ensure that other identifiers aren't populated so they can't match *)
					<|
						Type -> Model[Molecule],
						Name -> "Caffeine for UploadMolecule unit tests 89 " <> $SessionUUID,
						InChI -> "InChI=1S/C8H10N4O2/c1-10-4-9-6-5(10)7(13)12(3)8(14)11(6)2/h4H,1-3H3",
						ExactMass -> 99.9 Dalton,
						MolecularWeight -> 99.9 Dalton
					|>
				]
			},
			Variables :> {molecule}
		],
		Example[{Messages, "DuplicateObjects", "If an existing object is found with the same InChIKey, the existing object if modified rather than creating a new object and a warning is thrown:"},
			molecule = UploadMolecule[
				"RYYVLZVUVIJVGH-UHFFFAOYSA-N",
				MolecularWeight -> 100.0 Dalton,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				State -> Solid
			];
			Download[
				molecule,
				{
					Object,
					Name,
					InChIKey,
					MolecularWeight,
					ExactMass
				}
			],
			{
				ObjectP[Model[Molecule, "Caffeine for UploadMolecule unit tests 90 " <> $SessionUUID]],
				"Caffeine for UploadMolecule unit tests 90 " <> $SessionUUID,
				"RYYVLZVUVIJVGH-UHFFFAOYSA-N",
				EqualP[100 Dalton], (* From new options *)
				EqualP[99.9 Dalton] (* From original object *)
			},
			Messages :> {
				Warning::ObjectAlreadyExists
			},
			Stubs :> {
				(* Turn on duplicate checking *)
				$installDefaultUploadFunctionDuplicateChecking = True,

				(* Only find the duplicate we just created *)
				(*$RequiredSearchName = "for UploadMolecule unit tests 90 " <> $SessionUUID*)
				(* $RequiredSearchName doesn't work as we're already searching on the Name field. To be fixed *)
				(* So implement manually *)
				Search[x : Model[Molecule], y_Or, z__] = Search[x, And[y, StringContainsQ[Name, "for UploadMolecule unit tests 90 " <> $SessionUUID]], z]
			},
			SetUp :> {
				Upload[
					(* Raw upload to ensure that other identifiers aren't populated so they can't match *)
					<|
						Type -> Model[Molecule],
						Name -> "Caffeine for UploadMolecule unit tests 90 " <> $SessionUUID,
						InChIKey -> "RYYVLZVUVIJVGH-UHFFFAOYSA-N",
						ExactMass -> 99.9 Dalton,
						MolecularWeight -> 99.9 Dalton
					|>
				]
			},
			Variables :> {molecule}
		],
		Example[{Messages, "DuplicateObjects", "If an existing object is found with the same IUPAC name, the existing object if modified rather than creating a new object and a warning is thrown:"},
			molecule = UploadMolecule[
				"1,3,7-trimethylpurine-2,6-dione",
				MolecularWeight -> 100.0 Dalton,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				State -> Solid
			];
			Download[
				molecule,
				{
					Object,
					Name,
					IUPAC,
					MolecularWeight,
					ExactMass
				}
			],
			{
				ObjectP[Model[Molecule, "Caffeine for UploadMolecule unit tests 91 " <> $SessionUUID]],
				"Caffeine for UploadMolecule unit tests 91 " <> $SessionUUID,
				"1,3,7-trimethylpurine-2,6-dione",
				EqualP[100 Dalton], (* From new options *)
				EqualP[99.9 Dalton] (* From original object *)
			},
			Messages :> {
				Warning::ObjectAlreadyExists
			},
			Stubs :> {
				(* Turn on duplicate checking *)
				$installDefaultUploadFunctionDuplicateChecking = True,

				(* Only find the duplicate we just created *)
				(*$RequiredSearchName = "for UploadMolecule unit tests 91 " <> $SessionUUID*)
				(* $RequiredSearchName doesn't work as we're already searching on the Name field. To be fixed *)
				(* So implement manually *)
				Search[x : Model[Molecule], y_Or, z__] = Search[x, And[y, StringContainsQ[Name, "for UploadMolecule unit tests 91 " <> $SessionUUID]], z]
			},
			SetUp :> {
				Upload[
					(* Raw upload to ensure that other identifiers aren't populated so they can't match *)
					<|
						Type -> Model[Molecule],
						Name -> "Caffeine for UploadMolecule unit tests 91 " <> $SessionUUID,
						IUPAC -> "1,3,7-trimethylpurine-2,6-dione",
						ExactMass -> 99.9 Dalton,
						MolecularWeight -> 99.9 Dalton
					|>
				]
			},
			Variables :> {molecule}
		],
		Example[{Messages, "DuplicateObjects", "If an existing object is found with the same PubChemID, the existing object if modified rather than creating a new object and a warning is thrown:"},
			molecule = UploadMolecule[
				PubChem[2519],
				MolecularWeight -> 100.0 Dalton,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				State -> Solid
			];
			Download[
				molecule,
				{
					Object,
					Name,
					PubChemID,
					MolecularWeight,
					ExactMass
				}
			],
			{
				ObjectP[Model[Molecule, "Caffeine for UploadMolecule unit tests 92 " <> $SessionUUID]],
				"Caffeine for UploadMolecule unit tests 92 " <> $SessionUUID,
				2519,
				EqualP[100 Dalton], (* From new options *)
				EqualP[99.9 Dalton] (* From original object *)
			},
			Messages :> {
				Warning::ObjectAlreadyExists
			},
			Stubs :> {
				(* Turn on duplicate checking *)
				$installDefaultUploadFunctionDuplicateChecking = True,

				(* Only find the duplicate we just created *)
				(*$RequiredSearchName = "for UploadMolecule unit tests 92 " <> $SessionUUID*)
				(* $RequiredSearchName doesn't work as we're already searching on the Name field. To be fixed *)
				(* So implement manually *)
				Search[x : Model[Molecule], y_Or, z__] = Search[x, And[y, StringContainsQ[Name, "for UploadMolecule unit tests 92 " <> $SessionUUID]], z]
			},
			SetUp :> {
				Upload[
					(* Raw upload to ensure that other identifiers aren't populated so they can't match *)
					<|
						Type -> Model[Molecule],
						Name -> "Caffeine for UploadMolecule unit tests 92 " <> $SessionUUID,
						PubChemID -> 2519,
						ExactMass -> 99.9 Dalton,
						MolecularWeight -> 99.9 Dalton
					|>
				]
			},
			Variables :> {molecule}
		],
		Example[{Messages, "DuplicateObjects", "If an existing object is found with the same PubChemID when supplied as an integer, the existing object if modified rather than creating a new object and a warning is thrown:"},
			molecule = UploadMolecule[
				2519,
				MolecularWeight -> 100.0 Dalton,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				State -> Solid
			];
			Download[
				molecule,
				{
					Object,
					Name,
					PubChemID,
					MolecularWeight,
					ExactMass
				}
			],
			{
				ObjectP[Model[Molecule, "Caffeine for UploadMolecule unit tests 93 " <> $SessionUUID]],
				"Caffeine for UploadMolecule unit tests 93 " <> $SessionUUID,
				2519,
				EqualP[100 Dalton], (* From new options *)
				EqualP[99.9 Dalton] (* From original object *)
			},
			Messages :> {
				Warning::ObjectAlreadyExists
			},
			Stubs :> {
				(* Turn on duplicate checking *)
				$installDefaultUploadFunctionDuplicateChecking = True,

				(* Only find the duplicate we just created *)
				(*$RequiredSearchName = "for UploadMolecule unit tests 93 " <> $SessionUUID*)
				(* $RequiredSearchName doesn't work as we're already searching on the Name field. To be fixed *)
				(* So implement manually *)
				Search[x : Model[Molecule], y_Or, z__] = Search[x, And[y, StringContainsQ[Name, "for UploadMolecule unit tests 93 " <> $SessionUUID]], z]
			},
			SetUp :> {
				Upload[
					(* Raw upload to ensure that other identifiers aren't populated so they can't match *)
					<|
						Type -> Model[Molecule],
						Name -> "Caffeine for UploadMolecule unit tests 93 " <> $SessionUUID,
						PubChemID -> 2519,
						ExactMass -> 99.9 Dalton,
						MolecularWeight -> 99.9 Dalton
					|>
				]
			},
			Variables :> {molecule}
		],
		Example[{Messages, "DuplicateObjects", "If an existing object is found that matches multiple identifiers, this is ok and that object is modified:"},
			molecule = UploadMolecule[
				2519,
				CAS -> "58-08-2",
				MolecularWeight -> 100.0 Dalton,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				State -> Solid
			];
			Download[
				molecule,
				{
					Object,
					Name,
					CAS,
					PubChemID,
					MolecularWeight,
					ExactMass
				}
			],
			{
				ObjectP[Model[Molecule, "Caffeine for UploadMolecule unit tests 94 " <> $SessionUUID]],
				"Caffeine for UploadMolecule unit tests 94 " <> $SessionUUID,
				"58-08-2",
				2519,
				EqualP[100 Dalton], (* From new options *)
				EqualP[99.9 Dalton] (* From original object *)
			},
			Messages :> {
				Warning::ObjectAlreadyExists
			},
			Stubs :> {
				(* Turn on duplicate checking *)
				$installDefaultUploadFunctionDuplicateChecking = True,

				(* Only find the duplicate we just created *)
				(*$RequiredSearchName = "for UploadMolecule unit tests 94 " <> $SessionUUID*)
				(* $RequiredSearchName doesn't work as we're already searching on the Name field. To be fixed *)
				(* So implement manually *)
				Search[x : Model[Molecule], y_Or, z__] = Search[x, And[y, StringContainsQ[Name, "for UploadMolecule unit tests 94 " <> $SessionUUID]], z]
			},
			SetUp :> {
				Upload[
					(* Raw upload to ensure that other identifiers aren't populated so they can't match *)
					<|
						Type -> Model[Molecule],
						Name -> "Caffeine for UploadMolecule unit tests 94 " <> $SessionUUID,
						PubChemID -> 2519,
						CAS -> "58-08-2",
						ExactMass -> 99.9 Dalton,
						MolecularWeight -> 99.9 Dalton
					|>
				]
			},
			Variables :> {molecule}
		],
		Example[{Messages, "DuplicateObjects", "If multiple different existing object are found that match identifiers, an error is thrown and an object must be chosen manually to modify:"},
			UploadMolecule[
				2519,
				CAS -> "58-08-2",
				MolecularWeight -> 100.0 Dalton,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				State -> Solid
			],
			$Failed,
			Messages :> {
				Error::MultipleExistingObjects,
				Message[Error::InvalidInput, "{2519}"],
				Message[Error::InvalidOption, "{CAS, PubChemID}"]
			},
			Stubs :> {
				(* Turn on duplicate checking *)
				$installDefaultUploadFunctionDuplicateChecking = True,

				(* Only find the duplicate we just created *)
				(*$RequiredSearchName = "for UploadMolecule unit tests 95 " <> $SessionUUID*)
				(* $RequiredSearchName doesn't work as we're already searching on the Name field. To be fixed *)
				(* So implement manually *)
				Search[x : Model[Molecule], y_Or, z__] = Search[x, And[y, StringContainsQ[Name, "for UploadMolecule unit tests 95 " <> $SessionUUID]], z]
			},
			SetUp :> {
				Upload[{
					(* Raw upload to ensure that other identifiers aren't populated so they can't match *)
					<|
						Type -> Model[Molecule],
						Name -> "Caffeine for UploadMolecule unit tests 95 " <> $SessionUUID,
						PubChemID -> 2519,
						ExactMass -> 99.9 Dalton,
						MolecularWeight -> 99.9 Dalton
					|>,
					<|
						Type -> Model[Molecule],
						Name -> "Caffeine 2 for UploadMolecule unit tests 95 " <> $SessionUUID,
						CAS -> "58-08-2",
						ExactMass -> 99.9 Dalton,
						MolecularWeight -> 99.9 Dalton
					|>
				}]
			},
			Variables :> {molecule}
		]
	},
	Stubs :> {
		(* Don't fail if we create a duplicate Model[Molecule] *)
		$installDefaultUploadFunctionDuplicateChecking = False,

		(* Stub MSDS/Structure to prevent download/upload when not explicitly tested *)
		findSDS[___] := "http://www.testsdsurl.com",
		downloadAndValidateURL[Except["www.emeraldcloudlab.com"], _, MSDSFile] = "testfile.pdf",
		pathToCloudFilePacket["testfile.pdf"] = <|Object -> CreateID[Object[EmeraldCloudFile]]|>
	},
	SymbolSetUp :> {
		Module[{existingMolecules},

			existingMolecules = Search[Model[Molecule], StringContainsQ[Name, $SessionUUID]];

			EraseObject[existingMolecules, Verbose -> False, Force -> True];

			$CreatedObjects = {};
		]
	},
	SymbolTearDown :> {
		Module[{existingMolecules},

			existingMolecules = Search[Model[Molecule], StringContainsQ[Name, $SessionUUID]];

			EraseObject[existingMolecules, Verbose -> False, Force -> True];

			EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True];
			Unset[$CreatedObjects];
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*UploadMoleculeOptions*)


DefineTests[
	UploadMoleculeOptions,
	{
		Example[{Basic, "Inspect the resolved options when uploading a Model[Molecule] of caffeine by its name:"},
			UploadMoleculeOptions["Caffeine",
				Name -> "Caffeine for UploadMoleculeOptions unit tests 1 " <> $SessionUUID,
				MSDSFile -> "https://cdn.caymanchem.com/cdn/msds/14118m.pdf",
				NFPA -> {2, 0, 0, {}},
				OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Basic, "Inspect the resolved options when uploading a new Model[Molecule] of Aspartic Acid by its PubChem ID:"},
			UploadMoleculeOptions[PubChem[5960],
				Name -> "Aspartic Acid for UploadMoleculeOptions unit tests 2 " <> $SessionUUID,
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Basic, "Inspect the resolved options when uploading a new Model[Molecule] of L-Serine by its InChI:"},
			UploadMoleculeOptions["InChI=1S/C3H7NO3/c4-2(1-5)3(6)7/h2,5H,1,4H2,(H,6,7)/t2-/m0/s1",
				Name -> "L-Serine for UploadMoleculeOptions unit tests 3 " <> $SessionUUID,
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Basic, "Inspect the resolved options when uploading a new Model[Molecule] of Lysine by its CAS:"},
			UploadMoleculeOptions["56-87-1",
				Name -> "Lysine for UploadMoleculeOptions unit tests 4 " <> $SessionUUID,
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Basic, "Inspect the resolved options when uploading a new Model[Molecule] of salt by its Thermofisher product URL:"},
			UploadMoleculeOptions["https://www.thermofisher.com/order/catalog/product/85190",
				Name -> "DMSO for UploadMoleculeOptions unit tests 5 " <> $SessionUUID,
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard",
				NFPA -> {2, 2, 0, {}},
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]...}
		],
		Example[{Additional, "Inspect the resolved options when uploading a new Model[Molecule] of Taxol by its InChI Key:"},
			UploadMoleculeOptions[
				"RCINICONZNJXQF-MZXODVADSA-N",
				Name -> "Taxol for UploadMoleculeOptions unit tests 6 " <> $SessionUUID,
				NFPA -> {3, 0, 0, {}},
				Flammable -> False,
				DOTHazardClass -> "Class 0",
				State -> Solid,
				OutputFormat -> List
			],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Options, OutputFormat, "Return the resolved options as a list:"},
			UploadMoleculeOptions["DMSO",
				Name -> "DMSO for UploadMoleculeOptions unit tests 7 " <> $SessionUUID,
				OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Options, OutputFormat, "Return the resolved options as a table:"},
			UploadMoleculeOptions["DMSO",
				Name -> "DMSO for UploadMoleculeOptions unit tests 8 " <> $SessionUUID
			],
			Graphics_
		]
	},
	Stubs :> {
		(* Don't fail if we create a duplicate Model[Molecule] *)
		$installDefaultUploadFunctionDuplicateChecking = False,

		(* Stub MSDS/Structure to prevent download/upload when not explicitly tested *)
		findSDS[___] := "http://www.testsdsurl.com",
		downloadAndValidateURL[Except["www.emeraldcloudlab.com"], _, MSDSFile] = "testfile.pdf",
		pathToCloudFilePacket["testfile.pdf"] = <|Object -> CreateID[Object[EmeraldCloudFile]]|>
	},
	SymbolSetUp :> {
		$CreatedObjects = {};
	},
	SymbolTearDown :> {
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects];
	}
];



(* ::Subsubsection::Closed:: *)
(*ValidUploadMoleculeQ*)


DefineTests[
	ValidUploadMoleculeQ,
	{
		Example[{Basic, "Make sure that the resulting object will be valid when uploading a Model[Molecule] of caffeine by its name:"},
			ValidUploadMoleculeQ["Caffeine",
				Name -> "Caffeine Sample for ValidUploadMoleculeQ unit tests 1 " <> $SessionUUID,
				MSDSFile -> "https://cdn.caymanchem.com/cdn/msds/14118m.pdf",
				NFPA -> {2, 0, 0, {}}
			],
			True
		],
		Example[{Basic, "Make sure that the resulting object will be valid when uploading a new Model[Molecule] of Aspartic Acid by its PubChem ID:"},
			ValidUploadMoleculeQ[PubChem[5960],
				Name -> "Aspartic Acid for ValidUploadMoleculeQ unit tests 2 " <> $SessionUUID
			],
			True
		],
		Example[{Basic, "Make sure that the resulting object will be valid when uploading a new Model[Molecule] of L-Serine by its InChI:"},
			ValidUploadMoleculeQ["InChI=1S/C3H7NO3/c4-2(1-5)3(6)7/h2,5H,1,4H2,(H,6,7)/t2-/m0/s1",
				Name -> "L-Serine for ValidUploadMoleculeQ unit tests 3 " <> $SessionUUID
			],
			True
		],
		Example[{Basic, "Make sure that the resulting object will be valid when uploading a new Model[Molecule] of Lysine by its CAS:"},
			ValidUploadMoleculeQ["56-87-1",
				Name -> "Lysine for ValidUploadMoleculeQ unit tests 4 " <> $SessionUUID
			],
			True
		],
		Example[{Basic, "Make sure that the resulting object will be valid when uploading a new Model[Molecule] of salt by its ThermoFisher product URL:"},
			ValidUploadMoleculeQ["https://www.thermofisher.com/order/catalog/product/85190",
				Name -> "DMSO for ValidUploadMoleculeQ unit tests 5 " <> $SessionUUID,
				DOTHazardClass -> "Class 6 Division 6.1 Toxic Substances Hazard",
				NFPA -> {2, 2, 0, {}}
			],
			True
		],
		Example[{Additional, "Make sure that the resulting object will be valid when uploading a new Model[Molecule] of Taxol by its InChI Key:"},
			ValidUploadMoleculeQ[
				"RCINICONZNJXQF-MZXODVADSA-N",
				Name -> "Taxol for ValidUploadMoleculeQ unit tests 6 " <> $SessionUUID,
				NFPA -> {3, 0, 0, {}},
				Flammable -> False,
				DOTHazardClass -> "Class 0",
				State -> Solid
			],
			True
		],
		Example[{Options, "Verbose", "Set Verbose->True to see all of the tests that ValidUploadMoleculeQ is running:"},
			ValidUploadMoleculeQ["DMSO",
				Name -> "DMSO  for ValidUploadMoleculeQ unit tests 7 " <> $SessionUUID,
				Verbose -> True
			],
			True
		],
		Example[{Options, "Verbose", "Set Verbose->Failures to see all of the tests that did not pass when running ValidUploadMoleculeQ:"},
			ValidUploadMoleculeQ["DMSO",
				Name -> "DMSO for ValidUploadMoleculeQ unit tests 8 " <> $SessionUUID,
				Verbose -> Failures
			],
			True
		],
		Example[{Options, "Verbose", "Set Verbose->False to see none of the tests when running ValidUploadMoleculeQ (this is the default behavior):"},
			ValidUploadMoleculeQ["DMSO",
				Name -> "DMSO for ValidUploadMoleculeQ unit tests 9 " <> $SessionUUID,
				Verbose -> False
			],
			True
		],
		Example[{Options, "OutputFormat", "Set OutputFormat->TestSummary to have the function return a summary of the tests that it ran. Use the Keys[...] function on this test summary to see the keys inside of it:"},
			ValidUploadMoleculeQ["DMSO",
				Name -> "DMSO for ValidUploadMoleculeQ unit tests 10 " <> $SessionUUID,
				OutputFormat -> TestSummary
			][Successes],
			{_EmeraldTestResult..}
		]
	},
	Stubs :> {
		(* Don't fail if we create a duplicate Model[Molecule] *)
		$installDefaultUploadFunctionDuplicateChecking = False,

		(* Stub MSDS/Structure to prevent download/upload when not explicitly tested *)
		findSDS[___] := "http://www.testsdsurl.com",
		downloadAndValidateURL[Except["www.emeraldcloudlab.com"], _, MSDSFile] = "testfile.pdf",
		pathToCloudFilePacket["testfile.pdf"] = <|Object -> CreateID[Object[EmeraldCloudFile]]|>
	},
	SymbolSetUp :> {
		$CreatedObjects = {};
	},
	SymbolTearDown :> {
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects];
	}
];
