(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Resin], {
	Description->"Model information for a resin reagent used as support in solid phase synthesis or in chromatography.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* --- Organizational Information --- *)
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the model, in this case the brand name of the resin.",
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
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},
		CAS -> {
			Format -> Single,
			Class -> String,
			Pattern :> CASNumberP,
			Description -> "Chemical Abstracts Service (CAS) registry number for the resin.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		IUPAC -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "International Union of Pure and Applied Chemistry (IUPAC) name for the resin.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		State -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Solid | Liquid | Gas,
			Description -> "The physical state of a pure sample of this resin at room temperature and pressure.",
			Category -> "Physical Properties"
		},
		ResinFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Chromatography|SolidPhaseSynthesis,
			Description -> "The intended purpose of the resin, whether that be solid state synthesis or chromatography.",
			Category -> "Organizational Information",
			Abstract -> True
		},

		(* Resin Information *)
		ChromatographyType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ChromatographyTypeP,
			Description -> "The type of chromatography for which this resin is suitable for. HPLC, FPLC, Flash or SupercriticalFluidChromatography are options.",
			Category -> "Model Information",
			Abstract -> True
		},
		SeparationMode -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SeparationModeP,
			Description -> "The type of separation for which this resin is suitable for. Normal Phase, Reverse Phase, Ion Exchange, Size Exclusion, Affinity or Chiral are options.",
			Category -> "Model Information",
			Abstract -> True
		},
		Magnetic->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this resin has superparamagnetic properties that allow it to be separated from a suspension using a magnetic field.",
			Category->"Model Information"
		},
		PackingBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "The buffer used for packing the resin in the column.",
			Category -> "Model Information"
		},
		StorageBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample]|Model[Sample],
			Description -> "The buffer used to keep the resin wet while the column is stored.",
			Category -> "Model Information"
		},
		FunctionalGroup -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ColumnFunctionalGroupP,
			Description -> "The functional group displayed on the resin.",
			Category -> "Physical Properties"
		},

		AffinityLabels->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Molecule],
			Description->"The affinity tag(s) conjugated to the resin.",
			Category->"Physical Properties"
		},
		DetectionLabels->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Molecule],
			Description->"The detection molecules used to identify the resin.",
			Category->"Physical Properties"
		},

		Labels->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Molecule],
			Description->"The combined set of AffinityLabels and DetectionLabels.",
			Category->"Physical Properties"
		},

		MultiplexELISAUse->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this Resin is being used for ExperimentMultiplexELISA.",
			Category->"Physical Properties"
		},
		ParticleSize -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Meter * Micro],
			Units -> Meter Micro,
			Description -> "The size of the particles that make up the resin packing material.",
			Category -> "Physical Properties"
		},
		PoreSize -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Angstrom],
			Units -> Angstrom,
			Description -> "The average size of the pores within the resin packing material.",
			Category -> "Physical Properties"
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

		(* --- Physical Properties ---*)
		StructureImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image depicting the chemical structure of the resin's functional group.",
			Category -> "Physical Properties",
			Abstract -> False
		},
		ResinMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ResinMaterialP,
			Description -> "The molecular structure of the resin.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		Molecule -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MoleculeP|_?ECL`StructureQ|_?ECL`StrandQ,
			Description -> "The chemical representation of this molecule.",
			Category -> "Organizational Information"
		},
		Linker -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ResinLinkerTypeP,
			Description -> "The chemical entity used to link a compound to the resin bead during solid phase synthesis.",
			Category -> "Physical Properties",
			Abstract -> True
		},

		Linkers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule],
			Description -> "The molecule version of the Linker described in the Linker field.",
			Category -> "Physical Properties",
			Abstract -> True
		},

		Loading -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Mole)/Gram],
			Units -> Mole/Gram,
			Description -> "For each member of Labels, the ratio of active sites per weight of resin.",
			Category -> "Physical Properties",
			Abstract -> True,
			IndexMatching->Labels
		},

		ProtectingGroup -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ProtectingGroupP,
			Description -> "The protecting group blocking the terminal reactive group on the resin used during solid phase synthesis.",
			Category -> "Physical Properties"
		},
		PreferredCleavageMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method, Cleavage],
			Description -> "Method object containing the preferred parameters for cleaving synthesized strands from this resin.",
			Category -> "Model Information"
		},
		PostCouplingKaiserResult -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> KaiserResultP,
			Description -> "The expected result of a Kaiser test following monomer download. This is used to determine if the resin contains deprotected primary amines (Positive).",
			Category -> "General"
		},
		PostCappingKaiserResult -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> KaiserResultP,
			Description -> "The expected result of a Kaiser test following capping of downloaded resin. This is used to determine if the resin contains deprotected primary amines (Positive).",
			Category -> "General"
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
			Description -> "Indicates this molecule is currently banned from usage in the ECL because the facility isn't yet equiped to handle it.",
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

		(* --- Operating Limits --- *)
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The minimum temperature at which this resin can function.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The maximum temperature at which this resin can function.",
			Category -> "Operating Limits"
		},
		MinpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Units -> None,
			Description -> "The minimum pH the resin can handle.",
			Category -> "Operating Limits"
		},
		MaxpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Units -> None,
			Description -> "The maximum pH the resin can handle.",
			Category -> "Operating Limits"
		}
	}
}];
