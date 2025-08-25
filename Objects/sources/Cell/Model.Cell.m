(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Cell], {
	Description->"Model information for a cell line.",
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
			Description -> "List of possible alternative names this model goes by.",
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
		ATCCID -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The American Type Culture Collection (ATCC) identifying number of this cell line.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Species -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Species][Cells],
			Description -> "The species that this cell was originally cultivated from.",
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

		(* --- Inventory ---*)
		DefaultSampleModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Specifies the model of sample that will be used if this model is specified to be used in an experiment.",
			Category -> "Inventory"
		},

		Diameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Micrometer],
			Units -> Micrometer,
			Description -> "The average diameter of an individual cell.",
			Category -> "Physical Properties"
		},
		DoublingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Hour],
			Units -> Hour,
			Description -> "The average period of time it takes for a population of these cells to double in number during their exponential growth phase in its preferred media.",
			Category -> "Physical Properties"
		},
		DetectionLabels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[Model[Molecule]],
			Relation -> Model[Molecule],
			Description -> "Indicate the tags (e.g. GFP, Alexa Fluor 488) that the cell contains, which can indicate the presence and amount of particular features or molecules in the cell.",
			Category -> "Physical Properties"
		},
		Viruses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Virus],
			Description -> "Viruses that are known to be carried by this cell line.",
			Category -> "Organizational Information"
		},
		cDNAs -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule,cDNA][Cells],
			Description -> "The cDNA models that this cell line produces.",
			Category -> "Organizational Information"
		},
		Transcripts -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule,Transcript][Cells],
			Description -> "The transcript models that this cell line produces.",
			Category -> "Organizational Information"
		},
		Lysates -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Lysate][Cell],
			Description -> "The model of the contents of this cell when lysed.",
			Category -> "Organizational Information"
		},
		PreferredLiquidMedia -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample, Media][CellTypes],
			Description -> "The recommended liquid media for the growth of the cells.",
			Category -> "Growth Media"
		},
		PreferredSolidMedia -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample, Media][CellTypes],
			Description -> "The recommended solid media for the growth of the cells.",
			Category -> "Growth Media"
		},
		PreferredFreezingMedia -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample, Media][CellTypes],
			Description -> "The recommended media for cryopreservation of these cells, often containing additives that protect the cells during freezing.",
			Category -> "Growth Media"
		},
		CellType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CellTypeP,
			Description -> "The primary types of cells that are contained within this sample.",
			Category -> "Physical Properties"
		},
		CultureAdhesion->{
			Format -> Single,
			Class -> Expression,
			Pattern :> CultureAdhesionP,
			Description -> "The default type of cell culture (adherent or suspension) that should be performed when growing these cells. If a cell line can be cultured via an adherent or suspension culture, this is set to the most common cell culture type for the cell line.",
			Category -> "Growth Information"
		},
		ThawCellsMethod->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method, ThawCells],
			Description -> "The default method by which to thaw cryovials of this cell line.",
			Category -> "Thawing"
		},
		WashCellsMethod->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method, WashCells],
			Description -> "The default method by which to wash cultures of this cell line.",
			Category -> "Washing"
		},
		ChangeMediaMethod->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method, ChangeMedia],
			Description -> "The default method by which to change the media for cultures of this cell line.",
			Category -> "Media Addition and Plating"
		},
		SplitCellsMethod->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method, SplitCells],
			Description -> "The default method by which to split this cell line.",
			Category -> "Splitting"
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
		pH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0,14],
			Units -> None,
			Description -> "The logarithmic concentration of hydrogen ions of a pure sample of this molecule at room temperature and pressure.",
			Category -> "Physical Properties",
			Abstract -> False
		},
		Acid -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if pure samples of this molecule are strong acids (pH <= 2).",
			Category -> "Health & Safety"
		},
		Base -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if pure samples of this molecule are strong acids (pH >= 12).",
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
			Description -> "The PDF of the MSDS (Materials Saftey Data Sheet) of this molecule.",
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

		ReferenceImages -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "Reference microscope images exemplifying the typical appearance of this cell line.",
			Category -> "Experimental Results"
		},
		StandardCurves -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis,StandardCurve],
			Description -> "The standard curves used to convert between a combination of cell concentration units, Cell/Milliliter, OD600, CFU/Milliliter, RelativeNephelometricUnit, NephelometricTurbidityUnit, FormazinTurbidityUnit, and FormazinNephelometricUnit. If there exist multiple standard curves between the same units, the more recently generated curve will be used in calculations.",
			Category -> "Analysis & Reports"
		},
		StandardCurveProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol,Nephelometry],Object[Protocol,AbsorbanceIntensity]],
			Description -> "For each member of StandardCurves, the protocol that generated the data used to determine the standard curve.",
			IndexMatching -> StandardCurves,
			Category -> "Analysis & Reports"
		},
		PreferredColonyHandlerHeadCassettes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Part,ColonyHandlerHeadCassette]],
			Description -> "The ColonyHandlerHeadCassettes that are designed to pick this cell type from a solid gel.",
			Category -> "Media Addition and Plating"
		},
		FluorescentExcitationWavelength -> {
			Format -> Single,
			Class -> {Real,Real},
			Pattern :> {GreaterP[0 Nanometer],GreaterP[0 Nanometer]},
			Units -> {Nanometer, Nanometer},
			Headers -> {"Minimum Wavelength", "Maximum Wavelength"},
			Description -> "The range of wavelengths that causes the cell to be in an excited state.",
			Category->"Physical Properties"
		},
		FluorescentEmissionWavelength -> {
			Format -> Single,
			Class -> {Real,Real},
			Pattern :> {GreaterP[0 Nanometer],GreaterP[0 Nanometer]},
			Units -> {Nanometer, Nanometer},
			Headers -> {"Minimum Wavelength", "Maximum Wavelength"},
			Description -> "The detectable range of wavelengths this cell will emit through fluorescence after being put into an excited state.",
			Category->"Physical Properties"
		}
	}
}];
