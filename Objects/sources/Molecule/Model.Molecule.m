(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Molecule], {
	Description->"Model information for a group of atoms held together via covalent and/or ionic bonds.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- Organizational Information --- *)
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the model.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Synonyms -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "A list of alternative names for this molecule.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Authors -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The people who created this model.",
			Category -> "Organizational Information"
		},
		Molecule -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MoleculeP|_?ECL`StructureQ|_?ECL`StrandQ,
			Description -> "The chemical structure that represents this molecule.",
			Category -> "Organizational Information"
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},
		Verified -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the information in this model has been reviewed for accuracy by an ECL employee.",
			Category -> "Organizational Information"
		},
		VerifiedLog -> {
			Format -> Multiple,
			Class -> {Boolean, Link, Date},
			Pattern :> {BooleanP, _Link, _?DateObjectQ},
			Relation -> {Null, Object[User], Null},
			Headers -> {"Verified", "Responsible person", "Date"},
			Description -> "Records the history of changes to the Verified field, along with when the change occured, and the person responsible.",
			Category -> "Organizational Information"
		},
		LegacyObject -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample]|Object[Product],
			Description -> "The pre-samplefest object that this model was migrated from.",
			Category -> "Migration Support",
			Developer -> True
		},


		(* --- Inventory ---*)
		DefaultSampleModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Specifies the model of sample that will be used if this molecule model is specified to be used in an experiment.",
			Category -> "Inventory"
		},

		(* -- Identifiers -- *)
		UNII -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Unique Ingredient Identifier of this molecule, as given by the unified identification scheme of the FDA.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		InChI -> {
			Format -> Single,
			Class -> String,
			Pattern :> InChIP,
			Description -> "The International Chemical Identifier (InChI) that uniquely identifies this molecule.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		InChIKey -> {
			Format -> Single,
			Class -> String,
			Pattern :> InChIKeyP,
			Description -> "The hashed version of the International Chemical Identifier (InChI) that uniquely identifies this molecule.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		PubChemID -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer,
			Description -> "The PubChem Compound ID that uniquely identifies this molecule in the PubChem database.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		CAS -> {
			Format -> Single,
			Class -> String,
			Pattern :> CASNumberP,
			Description -> "Chemical Abstracts Service (CAS) registry number for this molecule.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		IUPAC -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "International Union of Pure and Applied Chemistry (IUPAC) name for this molecule.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		MolecularFormula -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Chemical formula of this molecule (e.g. H2O, NH3, etc.).",
			Category -> "Physical Properties",
			Abstract -> True
		},
		Monatomic -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this molecule consists of exactly one atom (e.g. He).",
			Category -> "Physical Properties"
		},
		DetectionLabel -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether this molecule can be attached to another molecule and act as a tag for detection and quantification of that molecule through methods that don't require physical binding, such as fluorescence (e.g. Alexa Fluor 488).",
			Category -> "Physical Properties"
		},
		AffinityLabel -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether this molecule can be attached to another molecule and act as a tag for detection and quantification of that molecule through physical binding (e.g. His tag).",
			Category -> "Physical Properties"
		},
		DetectionLabels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[Model[Molecule]],
			Relation -> Model[Molecule],
			Description -> "The tags that this molecule contains which enable detection and quantification of the molecule through methods that don't require physical binding, such fluorescence (e.g. Alexa Fluor 488). Molecules can be used as DetectionLabels when they have DetectionLabel->True.",
			Category -> "Physical Properties"
		},
		AffinityLabels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[Model[Molecule]],
			Relation -> Model[Molecule],
			Description -> "The tags that this molecule contains which enable detection and quantification of the molecule through physical binding (e.g. His tag). Molecules can be used as DetectionLabels when they have AffinityLabel->True.",
			Category -> "Physical Properties"
		},
		Targets -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Molecule, Protein][Antibodies],
				Model[Molecule, Protein, Antibody][SecondaryAntibodies],
				Model[Molecule]
			],
			Description -> "Target molecules (e.g. proteins or antibodies) to which this molecule binds selectively.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		(* --- Physical Properties --- *)
		State -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Solid | Liquid | Gas,
			Description -> "The physical state of a pure sample of this molecule at room temperature and pressure.",
			Category -> "Physical Properties"
		},
		Density -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Liter Milli],
			Units -> Gram/(Liter Milli),
			Description -> "The weight of sample per amount of volume for this molecule at room temperature and pressure.",
			Category -> "Physical Properties"
		},
		ExtinctionCoefficients -> {
			Format -> Multiple,
			Class -> {Wavelength->VariableUnit, ExtinctionCoefficient->VariableUnit},
			Pattern :> {Wavelength->GreaterP[0*Nanometer], ExtinctionCoefficient->(GreaterP[0 Liter/(Centimeter*Mole)] | GreaterP[0 Milli Liter /(Milli Gram * Centimeter)])},
			Description -> "A measure of how strongly this molecule absorbs light at a particular wavelength.",
			Category -> "Physical Properties"
		},
		Fluorescent ->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this molecule can re-emit light upon excitation.",
			Category->"Physical Properties"
		},
		FluorescenceExcitationMaximums -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*Nanometer],
			Units->Nanometer,
			Description->"The wavelengths corresponding to the highest peak of each Fluorescent moiety's excitation spectrum.",
			Category->"Physical Properties"
		},
		FluorescenceEmissionMaximums -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*Nanometer],
			Units->Nanometer,
			Description->"For each member of FluorescenceExcitationMaximums, the corresponding highest peak of the fluorescent moiety's emission spectrum.",
			IndexMatching -> FluorescenceExcitationMaximums,
			Category->"Physical Properties"
		},
		MolecularWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "The molecular weight of this molecule (the mass of one mole of the molecule).",
			Category -> "Physical Properties",
			Abstract -> True
		},
		ExactMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "The most abundant mass of the molecule calculated using the natural abundance of isotopes on Earth.",
			Category -> "Physical Properties"
		},
		StructureImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[Object[EmeraldCloudFile]],
			Relation->Object[EmeraldCloudFile],
			Description -> "An image depicting the molecule's chemical structure.",
			Category -> "Physical Properties"
		},
		StructureFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[Object[EmeraldCloudFile]],
			Relation->Object[EmeraldCloudFile],
			Description -> "A file that contains the molecule's chemical structure.",
			Category -> "Physical Properties"
		},
		MeltingPoint -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which bulk sample of this molecule transitions from solid to liquid at atmospheric pressure.",
			Category -> "Physical Properties",
			Abstract -> False
		},
		BoilingPoint -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which bulk sample of this molecule transitions from condensed phase to gas at atmospheric pressure. This occurs when the vapor pressure of the sample equals atmospheric pressure.",
			Category -> "Physical Properties",
			Abstract -> False
		},
		VaporPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kilo*Pascal],
			Units -> Kilo Pascal,
			Description -> "The pressure of the vapor in thermodynamic equilibrium with condensed phase for this molecule in a closed system at room temperature.",
			Category -> "Physical Properties",
			Abstract -> False
		},
		Viscosity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Pascal*Second],
			Units -> Pascal Second,
			Description -> "The dynamic viscosity of samples of this substance at room temperature and pressure, indicating how resistant it is to flow when an external force is applied.",
			Category -> "Physical Properties",
			Abstract -> False
		},
		LogP -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?NumericQ,
			Description -> "The logarithm of the partition coefficient, which is the ratio of concentrations of a solute between the aqueous and organic phases of an octanol-water biphasic system.",
			Category -> "Physical Properties",
			Abstract -> False
		},
		pKa -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> NumericP,
			Units -> None,
			Description -> "The logarithmic acid dissociation constants of the substance at room temperature in water.",
			Category -> "Physical Properties",
			Abstract -> False
		},
		NMRSolventPeak -> {
			Format -> Multiple,
			Class -> {
				Nucleus-> String,
				ChemicalShift-> Real
			},
			Pattern :> {
				Nucleus -> NucleusP,
				ChemicalShift -> ChemicalShiftP
			},
			Units -> {
				Nucleus -> None,
				ChemicalShift -> PPM
			},
			Description -> "The known chemical shift for a given nucleus in this molecule.",
			Category -> "Physical Properties"
		},

		(* --- Chiral Properties ---*)
		Chiral->{
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this molecule is a enantiomer, that cannot be superposed on its mirror image by any combination of rotations and translations.",
			Category -> "Physical Properties"
		},
		Racemic->{
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this molecule represents a mixture of equal amounts of the two enantiomers of a chiral molecule.",
			Category -> "Physical Properties"
		},
		EnantiomerForms->{(*Only in Racemic->True*)
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule],
			Description -> "If this model molecule is racemic (Racemic -> True), indicates the two models for the enantiomerically pure forms.",
			Category -> "Physical Properties"
		},
		RacemicForm->{(*Only in Chiral->True*)
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule],
			Description -> "If this molecule represents one of a pair of enantiomers (Chiral -> True), indicates the model for its racemic form.",
			Category -> "Physical Properties"
		},
		EnantiomerPair->{(*Only one, single field*)
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule],
			Description -> "If this molecule represents one of a pair of enantiomers (Chiral -> True), indicates the model for the alternative enantiomer of this molecule.",
			Category -> "Physical Properties"
		},

		(* --- Health & Safety --- *)
		Radioactive -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this molecule emits substantial ionizing radiation.",
			Category -> "Health & Safety"
		},
		Ventilated -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if a pure sample of this molecule must be handled in a ventilated enclosures.",
			Category -> "Health & Safety"
		},
		Flammable -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if a pure sample of this molecule is easily set aflame at room temperature and pressure.",
			Category -> "Health & Safety"
		},
		Acid -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this molecule forms strongly acidic solutions when dissolved in water (typically pKa <= 4).",
			Category -> "Health & Safety"
		},
		Base -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this molecule forms strongly basic solutions when dissolved in water (typically pKaH >= 11).",
			Category -> "Health & Safety"
		},
		Pyrophoric -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if pure samples of this molecule can ignite spontaneously upon exposure to air.",
			Category -> "Health & Safety"
		},
		WaterReactive -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if pure samples of this molecule react spontaneously upon exposure to water.",
			Category -> "Health & Safety"
		},
		Fuming -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if pure samples of this molecule emit fumes spontaneously when exposed to air.",
			Category -> "Health & Safety"
		},
		HazardousBan -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates this molecule is currently banned from usage in the ECL because the facility isn't yet equipped to handle it.",
			Category -> "Health & Safety"
		},
		ExpirationHazard -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if pure samples of this molecule become hazardous once they are expired and must be automatically disposed of when they pass their expiration date.",
			Category -> "Health & Safety"
		},
		ParticularlyHazardousSubstance -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if exposure to this substance has the potential to cause serious and lasting harm. A substance is considered particularly harmful if it is categorized by any of the following GHS classifications (as found on a MSDS): Reproductive Toxicity (H340, H360, H362),  Acute Toxicity (H300, H310, H330, H370, H373), Carcinogenicity (H350).",
			Category -> "Health & Safety"
		},
		DrainDisposal -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this molecule may be safely disposed down a standard drain.",
			Category -> "Health & Safety"
		},
		Pungent -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if pure samples of this molecule have a strong odor.",
			Category -> "Health & Safety"
		},
		MSDSRequired -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if an MSDS is required for this molecule.",
			Category -> "Health & Safety"
		},
		MSDSFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The PDF of the MSDS (Materials Safety Data Sheet) of this molecule.",
			Category -> "Health & Safety"
		},
		NFPA -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> NFPAP,
			Description -> "The National Fire Protection Association (NFPA) 704 hazard diamond classification for this molecule.",
			Category -> "Health & Safety"
		},
		DOTHazardClass -> {
			Format -> Single,
			Class -> String,
			Pattern :> DOTHazardClassP,
			Description -> "The Department of Transportation hazard classification for this molecule.",
			Category -> "Health & Safety"
		},
		BiosafetyLevel -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BiosafetyLevelP,
			Description -> "The Biosafety classification for this molecule.",
			Category -> "Health & Safety"
		},
		AutoclaveUnsafe->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this sample cannot be safely autoclaved.",
			Category->"Health & Safety"
		},
		DoubleGloveRequired -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if working with this molecule requires to wear two pairs of gloves.",
			Category -> "Health & Safety",
			Developer -> True
		},

		LightSensitive -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this molecule reacts or degrades in the presence of light.",
			Category -> "Storage Information"
		},

		(* --- Compatibility --- *)
		IncompatibleMaterials -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MaterialP|None,
			Description -> "A list of materials that would be damaged if wetted by this molecule.",
			Category -> "Compatibility"
		},
		LiquidHandlerIncompatible -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if pure samples of this molecule cannot be reliably aspirated or dispensed on an automated liquid handling robot.",
			Category -> "Compatibility"
		},
		PipettingMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Method,Pipetting],
			Description -> "The pipetting parameters used to manipulate pure samples of this model.",
			Category -> "Compatibility"
		},
		UltrasonicIncompatible -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if pure samples of this molecule cannot be performed via the ultrasonic distance method due to vapors interfering with the reading.",
			Category -> "Compatibility"
		},
		FluorescenceLabelingTarget ->{
			Format->Multiple,
			Class->Expression,
			Pattern:>FluorescenceLabelingTargetTypeP,
			Description->"The types of molecules that cause fluorescence enhancement upon binding to this fluorophore.",
			Category->"Compatibility"
		},

		(* -- Reference Data -- *)
		ReferenceNMR -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "Data that exemplify the expected NMR spectrum for this molecule.",
			Category -> "Experimental Results",
			Abstract -> False
		},
		ReferenceMassSpectra -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "Data that exemplify the expected mass spectrometry spectrum for this molecule.",
			Category -> "Experimental Results",
			Abstract -> False
		},
		ReferenceChromatographs -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "Data that exemplify expected analytical HPLC traces for this molecule.",
			Category -> "Experimental Results",
			Abstract -> False
		},
		ReferenceTLC -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "Data that exemplify expected thin layer chromatography results for this molecule.",
			Category -> "Experimental Results",
			Abstract -> False
		},
		LiteratureReferences -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Report, Literature][References],
			Description -> "Literature references that discuss this molecule.",
			Category -> "Analysis & Reports"
		},
		AdditionalInformation -> {
			Format -> Multiple,
			Class -> {String, Date},
			Pattern :> {_String, _?DateObjectQ},
			Description -> "Supplementary information recorded from the UploadMolecule function. These information usually records the user supplied input and options, providing additional information for verification.",
			Headers -> {"Information", "Date Added"},
			Category -> "Hidden"
		}
	}
}];
