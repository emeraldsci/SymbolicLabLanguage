(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[UnitOperation,LabelSample],
	{
		Description->"A detailed set of parameters that labels a sample for later use in a SamplePreparation/CellPreparation experiment.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
			Label -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "The label of the samples that will use used to refer to them in other unit operations.",
				Category -> "General"
			},
			SampleLink -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Model[Sample]
				],
				Description -> "The sample that should be labeled by this primitive.",
				Category -> "General",
				Migration->SplitField
			},
			SampleString -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The sample that should be labeled by this primitive.",
				Category -> "General",
				Migration->SplitField
			},
			SampleExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
				Relation -> Null,
				Description -> "The sample that should be labeled by this primitive.",
				Category -> "General",
				Migration->SplitField
			},

			SampleModel -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Sample]
				],
				Description -> "The model that this labeled sample should point to.",
				Category -> "General"
			},

			(* NOTE: Since our unit operation can take multiple samples, Composition needs to be a N-Multiple field. *)
			Composition -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {{CompositionP, _Link}..},
				Relation -> Null,
				Description -> "Specifies the molecular composition of this sample.",
				Category -> "General"
			},

			ContainerLink -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Container],
					Model[Container]
				],
				Description -> "The container object of the sample that is to be labeled.",
				Category -> "General",
				Migration->SplitField
			},
			ContainerString -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "The container object of the sample that is to be labeled.",
				Category -> "General",
				Migration->SplitField
			},
			ContainerLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "The label of the container that will use used to refer to it in other unit operations.",
				Category -> "General"
			},

			Well -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "The well of the container that the sample is already in.",
				Category -> "General"
			},

			AmountVariableUnit -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterEqualP[0*Milliliter] | GreaterEqualP[0*Milligram],
				Description -> "The amount of that sample that will be transferred from the Source to the corresponding Destination.",
				Category -> "General",
				Migration->SplitField
			},
			AmountInteger -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterP[0, 1],
				Description -> "The amount of that sample that will be transferred from the Source to the corresponding Destination.",
				Category -> "General",
				Migration->SplitField
			},

			ExactAmount -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if the requested sample model resource can only be used at certain fixed amounts.",
				Category -> "General"
			},
			ToleranceVariableUnit -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterEqualP[0*Milliliter] | GreaterEqualP[0*Milligram],
				Description -> "The allowed tolerance when preparing the specified Amount of sample. This option can only be set if ExactAmount is set to True.",
				Category -> "General",
				Migration->SplitField
			},
			ToleranceInteger -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterEqualP[0, 1],
				Description -> "The allowed tolerance when preparing the specified Amount of sample. This option can only be set if ExactAmount is set to True.",
				Category -> "General",
				Migration->SplitField
			},

			State -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> PhysicalStateP,
				Description -> "The physical state of the sample when well solvated at room temperature and pressure.",
				Category -> "Physical Properties"
			},
			SampleHandling -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SampleHandlingP,
				Description -> "The method by which this sample should be manipulated in the lab when transfers out of the sample are requested.",
				Category -> "Physical Properties"
			},
			Density -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Gram / Milliliter],
				Units -> Gram / Milliliter,
				Description -> "The ratio of weight and volume of the sample.",
				Category -> "Physical Properties"
			},
			CellType -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> CellTypeP,
				Description -> "The primary types of cells that are contained within this sample.",
				Category -> "Physical Properties"
			},
			CultureAdhesion->{
				Format -> Multiple,
				Class -> Expression,
				Pattern :> CultureAdhesionP,
				Description -> "The type of cell culture that is currently being performed to grow these cells.",
				Category -> "Physical Properties"
			},

			IncompatibleMaterials -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> MaterialP | {MaterialP..} | None,
				Description -> "A list of materials that would be damaged if wetted by this model.",
				Category -> "Compatibility"
			},
			LiquidHandlerIncompatible -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this sample cannot be reliably aspirated or dispensed on an automated liquid handling robot.",
				Category -> "Compatibility"
			},
			UltrasonicIncompatible -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if volume measurements of this sample cannot be performed via the ultrasonic distance method due to vapors interfering with the reading.",
				Category -> "Compatibility"
			},
			PipettingMethod -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Model[Method,Pipetting],
				Description -> "The pipetting parameters used to manipulate this sample; these parameters may be overridden by direct specification of pipetting parameters in manipulation primitives.",
				Category -> "Storage Information"
			},
			Sterile -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates that this sample arrives free of both microbial contamination and any microbial cell samples from the manufacturer, or is prepared free of both microbial contamination and any microbial cell samples by employing autoclaving, sterile filtration, or mixing exclusively sterile components with aseptic techniques during experimentation and storage.",
				Category -> "Health & Safety"
			},
			RNaseFree -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates that this sample is free of any RNases.",
				Category -> "Health & Safety"
			},
			NucleicAcidFree -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this sample is presently considered to be not contaminated with DNA and RNA.",
				Category -> "Physical Properties"
			},
			PyrogenFree -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this sample is presently considered to be not contaminated with endotoxin.",
				Category -> "Physical Properties"
			},
			Radioactive -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this sample emit substantial ionizing radiation.",
				Category -> "Health & Safety"
			},
			Ventilated -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this sample must be handled in a ventilated enclosures.",
				Category -> "Health & Safety"
			},
			InertHandling -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this sample must be handled in a glove box.",
				Category -> "Health & Safety"
			},
			BiosafetyHandling -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this sample must be handled in a biosafety cabinet.",
				Category -> "Health & Safety"
			},
			AsepticHandling -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if aseptic techniques are followed for this sample. Aseptic techniques include sanitization, autoclaving, sterile filtration, mixing exclusively sterile components, and transferring in a biosafety cabinet during experimentation and storage.",
				Category -> "Health & Safety"
			},
			AutoclaveUnsafe->{
				Format->Multiple,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"Indicates if this sample cannot be safely autoclaved.",
				Category->"Health & Safety"
			},
			GloveBoxIncompatible -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "Indicates if this sample cannot be used inside of the glove box due high volatility and/or detrimental reactivity with the catalyst in the glove box that is used to remove traces of water and oxygen. Sulfur and sulfur compounds (such as H2S, RSH, COS, SO2, SO3), halides, halogen (Freon), alcohols, hydrazine, phosphene, arsine, arsenate, mercury, and saturation with water may deactivate the catalyst.",
				Category -> "Health & Safety"
			},
			GloveBoxBlowerIncompatible -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "Indicates that the glove box blower must be turned off to prevent damage to the catalyst in the glove box that is used to remove traces of water and oxygen when manipulating this sample inside of the glove box.",
				Category -> "Health & Safety"
			},
			Flammable -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this sample are easily set aflame under standard conditions.",
				Category -> "Health & Safety"
			},
			Acid -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this sample are strong acids (pH <= 2) and require dedicated secondary containment during storage.",
				Category -> "Health & Safety"
			},
			Base -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this sample are strong bases (pH >= 12) and require dedicated secondary containment during storage.",
				Category -> "Health & Safety"
			},
			Pyrophoric -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this sample can ignite spontaneously upon exposure to air.",
				Category -> "Health & Safety"
			},
			WaterReactive -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this sample react spontaneously upon exposure to water.",
				Category -> "Health & Safety"
			},
			Fuming -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this sample emit fumes spontaneously when exposed to air.",
				Category -> "Health & Safety"
			},
			Anhydrous -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this sample does not contain water.",
				Category -> "Health & Safety"
			},
			HazardousBan -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this sample are currently banned from usage in the ECL because the facility isn't yet equiped to handle them.",
				Category -> "Health & Safety"
			},
			ExpirationHazard -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this sample become hazardous once they are expired and therefore must be automatically disposed of when they pass their expiration date.",
				Category -> "Health & Safety"
			},
			ParticularlyHazardousSubstance -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if exposure to this substance has the potential to cause serious and lasting harm. A substance is considered particularly harmful if it is categorized by any of the following GHS classifications (as found on a MSDS): Reproductive Toxicity (H340, H360, H362),  Acute Toxicity (H300, H310, H330, H370, H373), Carcinogenicity (H350).",
				Category -> "Health & Safety"
			},
			DrainDisposal -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this sample may be safely disposed down a standard drain.",
				Category -> "Health & Safety"
			},
			Pungent -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this sample have a strong odor.",
				Category -> "Health & Safety"
			},
			MSDSRequired -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if an MSDS is applicable for this model.",
				Category -> "Health & Safety"
			},
			MSDSFile -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[EmeraldCloudFile],
				Description -> "PDF of the models MSDS (Materials Saftey Data Sheet).",
				Category -> "Health & Safety"
			},
			NFPA -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> NFPAP,
				Description -> "The National Fire Protection Association (NFPA) 704 hazard diamond classification for the substance.",
				Category -> "Health & Safety"
			},
			DOTHazardClass -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> DOTHazardClassP,
				Description -> "The Department of Transportation hazard classification of the substance.",
				Category -> "Health & Safety"
			},
			BiosafetyLevel -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BiosafetyLevelP,
				Description -> "The Biosafety classification of the substance.",
				Category -> "Health & Safety"
			},
			DoubleGloveRequired -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "Indication that the double gloves are required for the substance.",
				Category -> "Health & Safety",
				Developer -> True
			},

			StorageConditionLink -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[StorageCondition]
				],
				Description -> "The conditions under which this sample should be kept when not in use by an experiment.",
				Category -> "Health & Safety",
				Migration->SplitField
			},
			StorageConditionExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SampleStorageTypeP | Disposal,
				Relation -> Null,
				Description -> "The conditions under which this sample should be kept when not in use by an experiment.",
				Category -> "Health & Safety",
				Migration->SplitField
			},
			Expires -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this sample expires after a given amount of time.",
				Category -> "Health & Safety"
			},
			ExpirationDate -> {
				Format -> Multiple,
				Class -> Date,
				Pattern :> _?DateObjectQ,
				Description -> "Date after which this sample is considered expired and users will be warned about using it in protocols.",
				Category -> "Inventory"
			},
			ShelfLife -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 * Day],
				Units -> Day,
				Description -> "The length of time after DateCreated this sample is recommended for use before it should be discarded.",
				Category -> "Storage Information",
				Abstract -> True
			},
			UnsealedShelfLife -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 * Day],
				Units -> Day,
				Description -> "The length of time after DateUnsealed this sample is recommended for use before it should be discarded.",
				Category -> "Storage Information",
				Abstract -> True
			},
			LightSensitive -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates that this sample reacts or degrades in the presence of light and should be stored in the dark to avoid exposure.",
				Category -> "Storage Information"
			},
			AsepticTransportContainerType -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> AsepticTransportContainerTypeP,
				Description -> "Indicates how this sample is contained in an aseptic barrier and if it needs to be unbagged before being used in a protocol, maintenance, or qualification.",
				Category -> "Storage Information"
			},
			TransferTemperature -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0*Kelvin],
				Units -> Celsius,
				Description -> "The temperature that this sample should be at before any transfers using this sample occur.",
				Category -> "Storage Information"
			},
			TransportTemperature -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 * Kelvin],
				Units -> Celsius,
				Description -> "The temperature at which the sample should be incubated while transported between instruments during experimentation.",
				Category -> "Storage Information"
			},
			Restricted -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates whether the sample should be restricted from automatic use is any of your team's experiments that request the sample's models. (Restricted samples can only be used in experiments when specifically provided as input to the experiment functions by a team member). Setting the option to Null means the sample should be untouched. Setting the option to True or False will set the Restricted field of the sample to that value respectively.",
				Category -> "Storage Information"
			}
		}
	}
];
