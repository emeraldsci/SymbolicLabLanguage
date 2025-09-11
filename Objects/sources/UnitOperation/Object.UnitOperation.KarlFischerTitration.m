(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation, KarlFischerTitration], {
	Description -> "The operational information of how to perform a karl fischer titration operation using the same instrument on one or multiple samples.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* Sample-related fields *)
		SampleLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Object[Container],
				Model[Container]
			],
			Description -> "Sample to be measured for water content.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "Sample to be measured for water content.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}] | _String},
			Relation -> Null,
			Description -> "Sample to be measured for water content.",
			Category -> "General",
			Migration -> SplitField
		},
		(* This is either Sample or the corresponding WorkingSamples after aliquoting etc. *)
		WorkingSample -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of SampleLink, the samples to be measured for water content after any aliquoting, if applicable.",
			Category -> "General",
			IndexMatching -> SampleLink,
			Developer -> True
		},
		WorkingContainer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "For each member of SampleLink, the containers holding the samples to be measured for water content after any aliquoting, if applicable.",
			Category -> "General",
			IndexMatching -> SampleLink,
			Developer -> True
		},
		SampleLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleLink, the label of the sample whose water content is measured.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		SampleContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleLink, the label of the sample's container whose water content is measured.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, KarlFischerTitrator],
				Object[Instrument, KarlFischerTitrator]
			],
			Description -> "The instrument that is used to measure the water content of a sample by measuring the consumption of iodine in a  Karl Fischer reaction.",
			Category -> "General"
		},
		Technique -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> KarlFischerTechniqueP,
			Description -> "Indicates how this unit operation introduces Karl Fischer reagent to the sample.  If Volumetric, the Karl Fischer reagent mixture is introduced via buret in small increments. If set to Coulometric, molecular iodine is generated in situ by applying a pulse of electric current on a sample of iodide ions.",
			Category -> "General"
		},
		KarlFischerReagent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The mixture of chemicals (usually containing sulfur dioxide, iodine, organic base, and organic solvent) in which the Karl Fischer reaction occurs.",
			Category -> "General"
		},
		SampleAmount -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterP[0 Gram] | GreaterP[0 Milliliter],
			Description -> "For each member of SampleLink, the amount of sample that is tested for its water content.",
			IndexMatching -> SampleLink,
			Category -> "Sampling"
		},
		SamplingMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> KarlFischerSamplingMethodP,
			Description -> "The process by which the sample is introduced to the Karl Fischer reagent.",
			Category -> "Sampling"
		},
		TemperatureReal -> {
			Format -> Multiple,
			Class -> Real,
			Units -> Celsius,
			Pattern :> GreaterP[0 Kelvin],
			Description -> "For each member of SampleLink, indicates the temperature to which the sample is heated in order to release its water in headspace gas that is bubbled into the Karl Fischer reagent.",
			IndexMatching -> SampleLink,
			Migration -> SplitField,
			Category -> "Sampling"
		},
		TemperatureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Ambient | Auto,
			Description -> "For each member of SampleLink, indicates the temperature to which the sample is heated in order to release its water in headspace gas that is bubbled into the Karl Fischer reagent.",
			IndexMatching -> SampleLink,
			Migration -> SplitField,
			Category -> "Sampling"
		},
		MinRampTemperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "For each member of SampleLink, indicates the start temperature when using constant heating to determine the temperature at which the sample's water is released.",
			IndexMatching -> SampleLink,
			Category -> "Sampling"
		},
		MaxRampTemperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "For each member of SampleLink, indicates the end temperature when using constant heating to determine the temperature at which the sample's water is released.",
			IndexMatching -> SampleLink,
			Category -> "Sampling"
		},
		TemperatureRampRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Celsius / Minute],
			Units -> Celsius / Minute,
			Description -> "For each member of SampleLink, indicates the rate at which the samples are heated when determining the temperature at which the sample's water is released.",
			IndexMatching -> SampleLink,
			Category -> "Sampling"
		},
		Medium -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "For each member of SampleLink, indicates the solvent in which the sample is dissolved for the Karl Fischer reaction to occur.",
			IndexMatching -> SampleLink,
			Category -> "Sampling"
		},
		MediumVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "For each member of SampleLink, the amount of medium that is added to the reaction vessel or headspace vial in addition to the sample.",
			IndexMatching -> SampleLink,
			Category -> "Sampling"
		},
		Standard -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The water sample used to validate the instrument as a whole by measuring the Karl Fischer reagent's rate of reaction, and water content drift.",
			Category -> "Standards"
		},
		StandardAmount -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> GreaterP[0 Gram] | GreaterP[0 Milliliter],
			Description -> "The amount of standard to use to validate the instrument as a whole by measuring the Karl Fischer reagent's rate of reaction, and water content drift.",
			Category -> "Standards"
		},
		GasFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter / Minute],
			Units -> Milliliter / Minute,
			Description -> "Indicates the rate at which nitrogen flows to carry the headspace gas from the sample into the Karl Fischer reagent.",
			Category -> "Operations Information"
		},
		NumberOfStandards -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			Description -> "Indicates the number of Standard samples whose water content is measured to validate the titration instrument.",
			Category -> "Standards"
		},
		NumberOfBlanks -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			Description -> "Indicates the number of empty vials samples whose water content is measured to quantify the water content of the surrounding atmosphere.",
			Category -> "Blanks"
		},
		(*Grind*)
		Grind -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, indicates if the sample is ground into smaller particles via a grinder before measuring water content.",
			Category -> "Grinding"
		},
		GrindAmount -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the amount of sample to grind into a fine powder whose water content is then measured.",
			Category -> "Grinding"
		},
		GrinderType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GrinderTypeP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the method for reducing the size of the powder particles (grinding the sample into a fine powder). Options include BallMill, KnifeMill, and automated MortarGrinder. BallMill consists of a rotating or vibrating grinding container with sample and hard balls inside in which the size reduction occurs through impact/friction of hard balls on/with the solid particles. KnifeMill consists of rotating sharp blades in which size reduction occurs through cutting of the solid particles into smaller pieces. Automated MortarGrinder consists of a rotating bowl (mortar) with the sample inside and an angled revolving column (pestle) in which size reduction occurs through pressure and friction between mortar, pestle, and sample particles.",
			Category -> "Grinding"
		},
		Grinder -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument, Grinder], Model[Instrument, Grinder]],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the instrument that is used for reducing the size of the powder particles of the sample by mechanical actions.",
			Category -> "Grinding"
		},
		Fineness -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Millimeter],
			Units -> Millimeter,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the approximate length of the largest particle of the sample.",
			Category -> "Grinding"
		},
		BulkDensity -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Gram / Milliliter],
			Units -> Gram / Milliliter,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the mass of a volume unit of the powder. The volume for calculating BulkDensity includes the volumes of particles, internal pores, and inter-particle void spaces. This parameter is used to calculate the volume of a powder from its mass (Amount). The volume, in turn, is used along with the fineness in PreferredGrinder to determine a suitable grinder instrument if Instrument is not specified.",
			Category -> "Grinding"
		},
		GrindingContainer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the container that the sample is transferred into during the grinding process if Grind is set to True. Refer to the table in the instrumentation section of the help files for more information about the containers that are used for each model of grinders.",
			Category -> "Grinding"
		},
		GrindingBead -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item], Model[Item]],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the grinding beads or grinding balls that are used along with the sample inside the grinding container to beat and crush the sample into fine particles as a result rapid mechanical movements of the grinding container.",
			Category -> "Grinding"
		},
		NumberOfGrindingBeads -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the number of grinding beads or grinding balls that are used along with the sample inside the grinding container to beat and crush the sample into fine particles.",
			Category -> "Grinding"
		},
		GrindingRate -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 RPM] | GreaterEqualP[0 Hertz],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the speed of the circular motion of the grinding tool at which the sample is ground into a fine powder.",
			Category -> "Grinding"
		},
		GrindingTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the duration for which the solid substance is ground into a fine powder in the grinder.",
			Category -> "Grinding"
		},
		NumberOfGrindingSteps -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, how many times the grinding process is interrupted for cool down to completely grind the sample and prevent excessive heating of the sample. Between each grinding step there is a cooling time that the grinder is switched off to cool down the sample and prevent excessive rise in sample's temperature.",
			Category -> "Grinding"
		},
		CoolingTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the duration of time that the grinder is switched off between after each grinding step to cool down the sample and prevent overheating.",
			Category -> "Grinding"
		},
		GrindingProfile -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[
				{{Alternatives[Grinding, Cooling], Alternatives[GreaterEqualP[0 RPM], GreaterEqualP[0 Hertz]], GreaterEqualP[0 Minute]}..},
				{Alternatives[{GreaterEqualP[0 RPM] | GreaterEqualP[0 Hertz], GreaterEqualP[0 Minute]}, {GreaterEqualP[0 Minute]}]..}
			],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, determines the grinding activity (Grinding/GrindingRate or Cooling) over the course of time, in the form of {{Grinding, GrindingRate, Time}..}.",
			Category -> "Grinding"
		}
	}
}];