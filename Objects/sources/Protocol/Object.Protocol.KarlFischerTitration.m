(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, KarlFischerTitration], {
	Description -> "A Karl Fischer titration experiment where samples have their water content measured.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, KarlFischerTitrator] | Model[Instrument, KarlFischerTitrator],
			Description -> "The instrument used to measure the water content of samples.",
			Category -> "General"
		},
		Technique -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> KarlFischerTechniqueP,
			Description -> "Indicates how this protocol introduces Karl Fischer reagent to the sample.  If Volumetric, the Karl Fischer reagent mixture is introduced via buret in small increments. If set to Coulometric, molecular iodine is generated in situ by applying a pulse of electric current on a sample of iodide ions.",
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
			Description -> "For each member of SamplesIn, the amount of sample that is tested for its water content.",
			IndexMatching -> SamplesIn,
			Category -> "Sampling"
		},
		SampleTareTolerance -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterP[0 Gram],
			Description -> "The acceptable mass variation of the measured SampleTareWeight (either of an empty weighing funnel or an empty syringe and needle).",
			Category -> "Standards",
			Developer -> True
		},
		SampleTolerance -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterP[0 Gram],
			Description -> "For each member of SampleAmount, the acceptable mass variation of the measured sample before it is added to the reaction vessel for titration.",
			Category -> "Sampling",
			IndexMatching -> SampleAmount,
			Developer -> True
		},
		SamplingMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> KarlFischerSamplingMethodP,
			Description -> "The process by which the sample is introduced to the Karl Fischer reagent.",
			Category -> "Sampling"
		},
		Temperatures -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GreaterP[0 Kelvin] | Ambient,
			Description -> "For each member of SamplesIn, indicates the temperature to which the sample is heated in order to release its water in headspace gas that is bubbled into the Karl Fischer reagent.",
			IndexMatching -> SamplesIn,
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
			Description -> "For each member of SamplesIn, indicates the solvent in which the sample is dissolved for the Karl Fischer reaction to occur.",
			IndexMatching -> SamplesIn,
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
			Description -> "The sample used to validate the instrument as a whole by measuring the Karl Fischer reagent's rate of reaction, and water content drift.",
			Category -> "Standards"
		},
		StandardAmount -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> GreaterP[0 Gram] | GreaterP[0 Milliliter],
			Description -> "The amount of standard to use to validate the instrument as a whole by measuring the Karl Fischer reagent's rate of reaction, and water content drift.",
			Category -> "Standards"
		},
		StandardTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "Indicates the temperature to which the standard is heated in order to release its water in headspace gas that is bubbled into the Karl Fischer reagent.",
			Category -> "Standards"
		},
		StandardTareTolerance -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> GreaterP[0 Gram],
			Description -> "The acceptable mass variation of the measured StandardTareWeight (either of an empty weighing funnel or an empty syringe and needle).",
			Category -> "Standards",
			Developer -> True
		},
		StandardTolerance -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> GreaterP[0 Gram],
			Description -> "The acceptable mass variation of the measured StandardAmount.",
			Category -> "Standards",
			Developer -> True
		},
		StandardWaterContent -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 MassPercent, 100 MassPercent],
			Units -> MassPercent,
			Description -> "The measured water content for the standard used in this protocol.",
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
		SamplePlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of placements used to move all samples and standards on to the Karl Fischer autosampler.",
			Headers -> {"Sample Container", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		HeadspaceVials -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Vessel],
				Object[Container, Vessel]
			],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the containers in which the samples are placed for heating and headspace sampling.",
			Category -> "Operations Information",
			Developer -> True
		},
		StandardHeadspaceVials -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Vessel],
				Object[Container, Vessel]
			],
			Description -> "The containers in which the standard samples are placed for heating and headspace sampling.",
			Category -> "Operations Information",
			Developer -> True
		},
		ConditioningHeadspaceVial -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Vessel],
				Object[Container, Vessel]
			],
			Description -> "The empty container used to condition the reaction vessel and remove any residual water prior to every blank, standard, and sample to be titrated while running a Coulometric protocol.",
			Category -> "Operations Information",
			Developer -> True
		},
		SystemPrepHeadspaceVial -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Vessel],
				Object[Container, Vessel]
			],
			Description -> "The empty container that is dried prior to any blanks, standards, or samples, in a headspace-sampling protocol.",
			Category -> "Operations Information",
			Developer -> True
		},
		SystemPrepSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Syringe],
				Object[Container, Syringe]
			],
			Description -> "The syringe used to inject liquid standard into the Karl Fischer reaction vessel prior to the titer calculation standard injections.",
			Category -> "Operations Information",
			Developer -> True
		},
		SystemPrepNeedle -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Needle],
				Object[Item, Needle]
			],
			Description -> "The needle used to inject liquid standard into the Karl Fischer reaction vessel prior to the titer calculation standard injections.",
			Category -> "Operations Information",
			Developer -> True
		},
		SystemPrepWeighingFunnel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, WeighBoat, WeighingFunnel],
				Object[Item, WeighBoat, WeighingFunnel]
			],
			Description -> "The weighing funnel used to measure and transfer solid standard into the Karl Fischer reaction vessel prior to the titer calculation standard additions.",
			Category -> "Operations Information",
			Developer -> True
		},
		SystemPrepSpatula -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Spatula],
				Object[Item, Spatula]
			],
			Description -> "The spatula used to measure the solid standard into the weighing funnel to add to the Karl Fischer reaction vessel prior to the titer calculation standard additions.",
			Category -> "Operations Information",
			Developer -> True
		},
		BlankHeadspaceVials -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Vessel],
				Object[Container, Vessel]
			],
			Description -> "The empty containers that are tested to determine the water content of the surroundings.",
			Category -> "Operations Information",
			Developer -> True
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
		StandardSyringes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Syringe],
				Object[Container, Syringe]
			],
			Description -> "The syringes used to inject liquid standard into the Karl Fischer reaction vessel.",
			Category -> "Standards",
			Developer -> True
		},
		StandardNeedles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Needle],
				Object[Item, Needle]
			],
			Description -> "For each member of StandardSyringes, the needle attached to the syringe used to inject liquid standard into the Karl Fischer reaction vessel.",
			Category -> "Standards",
			Developer -> True,
			IndexMatching -> StandardSyringes
		},
		StandardWeighingFunnels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, WeighBoat, WeighingFunnel],
				Object[Item, WeighBoat, WeighingFunnel]
			],
			Description -> "The weighing funnel used to measure and transfer the solid standard to add to the Karl Fischer reaction vessel.",
			Category -> "Standards",
			Developer -> True
		},
		StandardSpatulas -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Spatula],
				Object[Item, Spatula]
			],
			Description -> "For each member of StandardWeighingFunnels, the spatula used to measure the solid standard into the weighing funnel to add to the Karl Fischer reaction vessel.",
			IndexMatching -> StandardWeighingFunnels,
			Category -> "Standards",
			Developer -> True
		},
		SampleSyringes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Syringe],
				Object[Container, Syringe]
			],
			Description -> "For each member of SamplesIn, the syringes used to inject liquid sample into the Karl Fischer reaction vessel.",
			IndexMatching -> SamplesIn,
			Category -> "Operations Information",
			Developer -> True
		},
		SampleNeedles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Needle],
				Object[Item, Needle]
			],
			Description -> "For each member of SamplesIn, the needle attached to the syringe used to inject liquid sample into the Karl Fischer reaction vessel.",
			IndexMatching -> SamplesIn,
			Category -> "Operations Information",
			Developer -> True
		},
		SampleWeighingFunnels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, WeighBoat, WeighingFunnel],
				Object[Item, WeighBoat, WeighingFunnel]
			],
			Description -> "For each member of SamplesIn, the weighing funnel used to measure and transfer the solid sample to add to the Karl Fischer reaction vessel.",
			IndexMatching -> SamplesIn,
			Category -> "Operations Information",
			Developer -> True
		},
		SampleSpatulas -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Spatula],
				Object[Item, Spatula]
			],
			Description -> "For each member of SamplesIn, the spatula used to measure the solid sample into the weighing funnel to add to the Karl Fischer reaction vessel.",
			IndexMatching -> SamplesIn,
			Category -> "Operations Information",
			Developer -> True
		},
		AmpouleOpener -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part, AmpouleOpener],
				Object[Part, AmpouleOpener]
			],
			Description -> "The part used to open any ampoules used during the course of this experiment, either in samples or standards.",
			Category -> "Operations Information",
			Developer -> True
		},
		ExpectedSystemPrepTareWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[0 Gram],
			Units -> Gram,
			Description -> "The expected value of the weighing step prior to measurment of system prep standard when Technique is set to Volumetric.  For syringes, this value is the weight of the syringe (and needle, if applicable) being used.  For weighing funnels, this value is the TareWeight of the model of the StandardWeighingFunnel.  Note that after obtaining the tare, this field value is updated by updateExpectedSampleTareWeight.",
			Category -> "Experimental Results",
			Developer -> True
		},
		ExpectedSystemPrepWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[0 Gram],
			Units -> Gram,
			Description -> "The expected value of the weight of the dispensing container with system prep standard in it when Technique is set to Volumetric.  For syringes and weighing funnels, this value is always the TareWeight of the loading container plus the StandardAmount (converted to units of mass if necessary).  Note that after obtaining the weight of the weighing container, this field value is updated by updateExpectedSampleTareWeight.",
			Category -> "Experimental Results",
			Developer -> True
		},
		ExpectedSystemPrepEmptyWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[0 Gram],
			Units -> Gram,
			Description -> "The expected value of the empty dispensing container after system prep standard has been added to the ReactionVessel when Technique is set to Volumetric.  For both syringes and weighing funnels, this is the always the TareWeight of the model of the dispensing container. Note that after obtaining the weight of the weighing container containing the standard, this field value is updated by updateExpectedSampleTareWeight.",
			Category -> "Experimental Results",
			Developer -> True
		},
		ExpectedStandardTareWeight -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[0 Gram],
			Units -> Gram,
			IndexMatching -> StandardWeighingFunnels,
			Description -> "For each member of StandardWeighingFunnels, the expected value of the weighing step prior to measurment of standard when Technique is set to Volumetric.  For syringes, this value is the weight of the syringe (and needle, if applicable) being used.  For weighing funnels, this value is the TareWeight of the model of the StandardWeighingFunnel.  Note that after obtaining the tare, this field value is updated by updateExpectedSampleTareWeight.",
			Category -> "Experimental Results",
			Developer -> True
		},
		ExpectedStandardWeight -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[0 Gram],
			Units -> Gram,
			IndexMatching -> StandardWeighingFunnels,
			Description -> "For each member of StandardWeighingFunnels, the expected value of the weight of the dispensing container with standard in it when Technique is set to Volumetric.  For syringes and weighing funnels, this value is always the TareWeight of the loading container plus the StandardAmount (converted to units of mass if necessary).  Note that after obtaining the weight of the weighing container, this field value is updated by updateExpectedSampleTareWeight.",
			Category -> "Experimental Results",
			Developer -> True
		},
		ExpectedStandardEmptyWeight -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[0 Gram],
			Units -> Gram,
			IndexMatching -> StandardWeighingFunnels,
			Description -> "For each member of StandardWeighingFunnels, the expected value of the empty dispensing container after standard has been added to the ReactionVessel when Technique is set to Volumetric.  For both syringes and weighing funnels, this is the always the TareWeight of the model of the dispensing container. Note that after obtaining the weight of the weighing container containing the standard, this field value is updated by updateExpectedSampleTareWeight.",
			Category -> "Experimental Results",
			Developer -> True
		},
		ExpectedSampleTareWeight -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[0 Gram],
			Units -> Gram,
			Description -> "For each member of SamplesIn, the expected value of the weighing step prior to measurment of sample when Technique is set to Volumetric.  For syringes, this value is the weight of the syringe (and needle, if applicable) being used.  For weighing funnels, this value is the TareWeight of the model of the SampleWeighingFunnel.  Note that after obtaining the tare, this field value is updated by updateExpectedSampleTareWeight.",
			IndexMatching -> SamplesIn,
			Category -> "Experimental Results",
			Developer -> True
		},
		ExpectedSampleWeight -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[0 Gram],
			Units -> Gram,
			Description -> "For each member of SamplesIn, the expected value of the weight of the dispensing container with sample in it when Technique is set to Volumetric.  For syringes and weighing funnels, this value is always the TareWeight of the loading container plus the SampleAmount (converted to units of mass if necessary).  Note that after obtaining the weight of the weighing container, this field value is updated by updateExpectedSampleTareWeight.",
			IndexMatching -> SamplesIn,
			Category -> "Experimental Results",
			Developer -> True
		},
		ExpectedSampleEmptyWeight -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[0 Gram],
			Units -> Gram,
			Description -> "For each member of SamplesIn, the expected value of the empty dispensing container after sample has been added to the ReactionVessel when Technique is set to Volumetric.  For both syringes and weighing funnels, this is the always the TareWeight of the model of the dispensing container. Note that after obtaining the weight of the weighing container containing the sample, this field value is updated by updateExpectedSampleTareWeight.",
			IndexMatching -> SamplesIn,
			Category -> "Experimental Results",
			Developer -> True
		},
		(*Grind*)
		Grind -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicates if the sample is ground into smaller particles via a grinder before measuring water content.",
			Category -> "Grinding"
		},
		GrindAmount -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the amount of sample to grind into a fine powder whose water content is then measured.",
			Category -> "Grinding"
		},
		GrinderType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GrinderTypeP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the method for reducing the size of the powder particles (grinding the sample into a fine powder). Options include BallMill, KnifeMill, and automated MortarGrinder. BallMill consists of a rotating or vibrating grinding container with sample and hard balls inside in which the size reduction occurs through impact/friction of hard balls on/with the solid particles. KnifeMill consists of rotating sharp blades in which size reduction occurs through cutting of the solid particles into smaller pieces. Automated MortarGrinder consists of a rotating bowl (mortar) with the sample inside and an angled revolving column (pestle) in which size reduction occurs through pressure and friction between mortar, pestle, and sample particles.",
			Category -> "Grinding"
		},
		Grinder -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument, Grinder], Model[Instrument, Grinder]],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the instrument that is used for reducing the size of the powder particles of the sample by mechanical actions.",
			Category -> "Grinding"
		},
		Fineness -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Millimeter],
			Units -> Millimeter,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the approximate length of the largest particle of the sample.",
			Category -> "Grinding"
		},
		BulkDensity -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Gram / Milliliter],
			Units -> Gram / Milliliter,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the mass of a volume unit of the powder. The volume for calculating BulkDensity includes the volumes of particles, internal pores, and inter-particle void spaces. This parameter is used to calculate the volume of a powder from its mass (Amount). The volume, in turn, is used along with the fineness in PreferredGrinder to determine a suitable grinder instrument if Instrument is not specified.",
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
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the container that the sample is transferred into during the grinding process if Grind is set to True. Refer to the table in the instrumentation section of the help files for more information about the containers that are used for each model of grinders.",
			Category -> "Grinding"
		},
		GrindingBead -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item], Model[Item]],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the grinding beads or grinding balls that are used along with the sample inside the grinding container to beat and crush the sample into fine particles as a result rapid mechanical movements of the grinding container.",
			Category -> "Grinding"
		},
		NumberOfGrindingBeads -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the number of grinding beads or grinding balls that are used along with the sample inside the grinding container to beat and crush the sample into fine particles.",
			Category -> "Grinding"
		},
		GrindingRate -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 RPM] | GreaterEqualP[0 Hertz],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the speed of the circular motion of the grinding tool at which the sample is ground into a fine powder.",
			Category -> "Grinding"
		},
		GrindingTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the duration for which the solid substance is ground into a fine powder in the grinder.",
			Category -> "Grinding"
		},
		NumberOfGrindingSteps -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, how many times the grinding process is interrupted for cool down to completely grind the sample and prevent excessive heating of the sample. Between each grinding step there is a cooling time that the grinder is switched off to cool down the sample and prevent excessive rise in sample's temperature.",
			Category -> "Grinding"
		},
		CoolingTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the duration of time that the grinder is switched off between after each grinding step to cool down the sample and prevent overheating.",
			Category -> "Grinding"
		},
		GrindingProfile -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[
				{{Alternatives[Grinding, Cooling], Alternatives[GreaterEqualP[0 RPM], GreaterEqualP[0 Hertz]], GreaterEqualP[0 Minute]}..},
				{Alternatives[{GreaterEqualP[0 RPM] | GreaterEqualP[0 Hertz], GreaterEqualP[0 Minute]}, {GreaterEqualP[0 Minute]}]..}
			],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, determines the grinding activity (Grinding/GrindingRate or Cooling) over the course of time, in the form of {{Grinding, GrindingRate, Time}..}.",
			Category -> "Grinding"
		},
		GrindProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, Grind],
			Description -> "The subprotocols run to grind up each sample for which Grind was set to True prior to measuring water content.  Typically one protocol is run per sample, in order to ensure that the sample is tested as quickly after it is ground as possible.",
			Category -> "Grinding",
			Developer -> True
		},
		HeadspaceVialUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "A set of intructions specifying how the headspace vials that hold sample and standard are prepared prior to being run on the instrument.",
			Category -> "Grinding",
			Developer -> True
		},
		SyringeRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Rack],
				Object[Container, Rack]
			],
			Description -> "The rack used to hold the syringe that is weighed before and after liquid sample is injected into the reaction vessel.",
			Category -> "Operations Information",
			Developer -> True
		},
		StandardEmptyBalanceData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			Description -> "The weight data of the balance prior to the presence of any syringe or weighing funnel during the standard titration step.  Note that for syringe weighing, the syringe rack will be on the balance for this step.",
			Category -> "Standards",
			Developer -> True
		},
		StandardTareData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			Description -> "The weight data of the standard transfer device prior to measuring the weight of the standards. If using weighing funnels, this is the weight of the empty weighing funnel prior to measurement of solid weight.  If using syringes, this is the weight of the empty syringe on the syringe rack.",
			Category -> "Standards",
			Developer -> True
		},
		StandardWeightData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			Description -> "The weight deta of the full standard syringe or weighing container when it is filled with StandardAmount of Standard prior to addition to the reaction vessel. If using weighing funnels, this value refers to the weight only of the solid because the balance is tared prior to filling the weighing funnel.  If using syringes, this value refers to the weight of the syringe plus the weight of the syringe contents.",
			Category -> "Standards",
			Developer -> True
		},
		StandardEmptyContainerWeightData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			Description -> "The weight deta of the empty standard syringe or weighing container after its contents have been added to the reaction vessel.",
			Category -> "Standards",
			Developer -> True
		},
		StandardWeight -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Gram],
			Units -> Gram,
			Description -> "For each member of StandardWeightData, the weight of standard that was actually added into the reaction vessel to be titrated.  This value is measured by weighing the container, syringe, or weighing funnel holding the standard before and after addition into the reaction vessel.",
			Category -> "Standards",
			Developer -> True
		},
		SampleEmptyBalanceData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			Description -> "The weight data of the balance prior to the presence of any syringe or weighing funnel during the sample titration step.  Note that for syringe weighing, the syringe rack will be on the balance for this step.",
			Category -> "Standards",
			Developer -> True
		},
		SampleTareData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			Description -> "The weight data of the sample transfer device prior to measuring the weight of the samples. If using weighing funnels, this is the weight of the empty weighing funnel prior to measurement of solid weight.  If using syringes, this is the weight of the empty syringe on the syringe rack.",
			Category -> "Experimental Results",
			Developer -> True
		},
		SampleWeightData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			Description -> "The weight deta of the full sample syringe or weighing container when it is filled with SampleAmount of Sample prior to addition to the reaction vessel. This value refers to the weight of the syringe and needle or the weighing funnel plus the weight of their contents.",
			Category -> "Experimental Results",
			Developer -> True
		},
		SampleEmptyContainerWeightData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			Description -> "The weight deta of the empty sample syringe or weighing container after its contents have been injected into the reaction vessel.",
			Category -> "Experimental Results",
			Developer -> True
		},
		SampleWeight -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Gram],
			Units -> Gram,
			Description -> "For each member of SampleWeightData, the weight of sample that was actually added into the reaction vessel to be titrated.  This value is measured by weighing the container, syringe, or weighing funnel holding the sample before and after addition into the reaction vessel.",
			Category -> "Experimental Results",
			Developer -> True
		},
		ReplaceMolecularSievesUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "A set of intructions specifying how the molecular sieve containers are emptied of saturated beads and filled with new ones.",
			Category -> "Desiccation",
			Developer -> True
		},
		ReplacementMolecularSieveContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "The containers attached to the instrument whose molecular sieves are replaced because their contents had been saturated.",
			Category -> "Desiccation",
			Developer -> True
		},
		ReplacementMolecularSieves -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The molecular sieves that are used to replace the saturated molecular sieves that were on the instrument at the beginning of the experiment.",
			Category -> "Desiccation",
			Developer -> True
		},
		ReplacementMolecularSievesSpatula -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Spatula],
				Object[Item, Spatula]
			],
			Description -> "The spatula that is used to scoop replacement molecular sieves into their containers.",
			Category -> "Desiccation",
			Developer -> True
		},
		MolecularSieveConnections -> {
			Format -> Multiple,
			Class -> {Link,String,Link,String},
			Pattern :> {_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation -> {Object[Container],Null,Object[Container] | Object[Instrument] | Object[Item],Null},
			Description -> "The connection information for attaching tubes containing new molecular sieves to the instrument.",
			Headers -> {"Molecular Sieve Tube","Molecular Sieve Tube Connector Name","Instrument","Instrument Connector Name"},
			Category -> "Desiccation",
			Developer -> True
		},
		MethodFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path for the sample list which sets the measurement parameters and begins the experimental run.",
			Category -> "General",
			Developer -> True
		},
		MethodFileName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the protocol file containing the run parameters.",
			Category -> "General",
			Developer -> True
		},
		DataFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path for the directory containing the raw data generated during this experimental run.",
			Category -> "General",
			Developer -> True
		},
		ScreenCaptureFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path for the directory containing the screen captures of the instrument computer while it was being accessed with VNC during this experimental run.",
			Category -> "General",
			Developer -> True
		},
		RawDataFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The raw experiment data generated by the titration instrument.",
			Category -> "Experimental Results",
			Developer -> True
		},
		DataFiles -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The paths to the raw data and videos of activity on the instrument computer on the shared drive prior to being uploaded to cloud files.",
			Category -> "Experimental Results",
			Developer -> True
		},
		BlankData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The conditioning and titration data of the headspace of all empty vials run in this protocol prior to the titration of standards and samples.",
			Category -> "Experimental Results",
			Developer -> True
		},
		SystemPrepData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The conditioning and titration data of the system prep injection prior to the titration of standards and samples.",
			Category -> "Experimental Results",
			Developer -> True
		},
		StandardData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The conditioning and titration data of all standards run in this protocol prior to the titration of samples.",
			Category -> "Experimental Results",
			Developer -> True
		},
		KarlFischerReagentWeightTare -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			Description -> "The weight data of the KarlFischerReagent before the titration is started for each sample.  If SamplingMethod is set to Liquid, once the protocol is completed, this field should have the same length as SamplesIn.",
			Category -> "Sensor Information",
			Developer -> True
		},
		KarlFischerReagentWeight -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			Description -> "The weight data of the KarlFischerReagent after the titration is completed for each sample.  If SamplingMethod is set to Liquid, once the protocol is completed, this field should have the same length as SamplesIn.",
			Category -> "Sensor Information",
			Developer -> True
		},
		MediumWeightTare -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			Description -> "The weight data of the Medium before the titration is started for each sample.  If SamplingMethod is set to Liquid, once the protocol is completed, this field should have the same length as SamplesIn.",
			Category -> "Sensor Information",
			Developer -> True
		},
		MediumWeight -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			Description -> "The weight data of the Medium after the titration is completed for each sample.  If SamplingMethod is set to Liquid, once the protocol is completed, this field should have the same length as SamplesIn.",
			Category -> "Sensor Information",
			Developer -> True
		},
		Ampoules -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The samples and standards used in this protocol that are in ampoules and thus must be disposed of at the end of the protocol.",
			Category -> "Operations Information",
			Developer -> True
		},
		ReplacementSeptum -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Septum],
				Object[Item, Septum]
			],
			Description -> "The silicon rubber seal used to replace the existing seal on the Instrument if it has been pierced enough times to no longer be airtight.",
			Category -> "Operations Information",
			Developer -> True
		},
		SystemPrepEmptyBalanceData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			Description -> "The weight data of the balance prior to the presence of any syringe or weighing system prep standard.  Note that for syringe weighing, the syringe rack will be on the balance for this step.",
			Category -> "Standards",
			Developer -> True
		},
		SystemPrepTareData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			Description -> "The weight data of the standard transfer device prior to measuring the weight of the system prep standard. If using weighing funnels, this is the weight of the empty weighing funnel prior to measurement of solid weight.  If using syringes, this is the weight of the empty syringe on the syringe rack.",
			Category -> "Standards",
			Developer -> True
		},
		SystemPrepWeightData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			Description -> "The weight deta of the full standard syringe or weighing container when it is filled system prep standard StandardAmount of Standard prior to addition to the reaction vessel. If using weighing funnels, this value refers to the weight only of the solid because the balance is tared prior to filling the weighing funnel.  If using syringes, this value refers to the weight of the syringe plus the weight of the syringe contents.",
			Category -> "Standards",
			Developer -> True
		},
		SystemPrepEmptyContainerWeightData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			Description -> "The weight deta of the empty standard syringe or weighing container after its contents have system prep standard added to the reaction vessel.",
			Category -> "Standards",
			Developer -> True
		},
		SystemPrepWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Gram],
			Units -> Gram,
			Description -> "The weight of standard that was actually added into the reaction vessel to be titrated for the system prep injection.  This value is measured by weighing the container, syringe, or weighing funnel holding the standard before and after addition into the reaction vessel.",
			Category -> "Standards",
			Developer -> True
		}
	}
}];
