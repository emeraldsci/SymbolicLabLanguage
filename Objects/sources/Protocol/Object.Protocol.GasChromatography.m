(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, GasChromatography], {
	Description->"A protocol describing the separation of materials using gas chromatography.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- Experiment Fields --- *)
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,GasChromatograph],
				Object[Instrument,GasChromatograph]
			],
			Description -> "The gas chromatograph used to separate analytes in a sample in the gas phase during this experiment.",
			Category -> "Instrument Specifications",
			Abstract -> False
		},
		CarrierGas -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GCCarrierGasP,
			Relation -> Null,
			Description -> "The gas to be used to push the vaporized analytes through the column during chromatographic separation of the samples injected into the GC.",
			Category -> "Instrument Specifications",
			Abstract -> False
		},
		Inlet -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GCInletP,
			Relation -> Null,
			Description -> "The inlet to be used to inject the samples onto the column.",
			Category -> "Instrument Specifications",
			Abstract -> False
		},
		InletLiner -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item,GCInletLiner],
				Object[Item,GCInletLiner]
			],
			Description -> "The inlet liner, a glass insert into which the sample is injected in the inlet, that was installed in the inlet during this experiment.",
			Category -> "Instrument Specifications",
			Abstract -> False
		},
		LinerORing -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item,ORing],
				Object[Item,ORing]
			],
			Description -> "The inlet liner O-ring, which seals the inlet volume from the septum purge volume in the inlet, to be installed in the inlet with the inlet liner during this experiment.",
			Category -> "Instrument Specifications",
			Abstract -> False
		},
		InletSeptum -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item,Septum],
				Object[Item,Septum]
			],
			Description -> "The inlet septum, which the injection syringe will penetrate to inject the sample into the inlet, to be installed in the inlet during this experiment.",
			Category -> "Instrument Specifications",
			Abstract -> False
		},
		Columns -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item,Column],
				Object[Item,Column]
			],
			Description -> "The capillary column(s), in order of installation, that SamplesIn was injected onto for separation during analysis.",
			Category -> "Instrument Specifications",
			Abstract -> False
		},
		ColumnsRequested -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item,Column],
				Object[Item,Column]
			],
			Description -> "For each member of Columns, the capillary column(s), in order of installation, that were specified by the user during creation of the protocol.",
			Category -> "Instrument Specifications",
			Abstract -> False,
			IndexMatching->Columns,
			Developer->True
		},
		TrimColumn -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of Columns, indicates whether or not a length of the inlet end of the column was removed, typically to remove suspected contamination from the column inlet if column performance begins to degrade. Trimming can be performed less frequently if a guard column is used.",
			Category -> "Instrument Specifications",
			Abstract -> False,
			IndexMatching->Columns
		},
		TrimColumnLength -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Meter],
			Units -> Meter,
			Relation -> Null,
			Description -> "For each member of Columns, the length of the inlet end of the column to remove prior to installation of the column.",
			Category -> "Instrument Setup",
			Abstract -> False,
			IndexMatching->Columns
		},
		ConditionColumn -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "Indicates whether or not the column was conditioned prior to the separation of samples.",
			Category -> "Instrument Specifications",
			Abstract -> False
		},
		(* this will become relevant when we add more carrier gas options *)
		ColumnConditioningGas -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> InertGCCarrierGasP,
			Relation -> Null,
			Description -> "The carrier gas used to purge the column(s) during the column conditioning step, which occurs when the column is installed.",
			Category -> "Instrument Setup",
			Abstract -> False
		},
		(* this doesn't seem to be a controllable option *)
		(*ColumnConditioningGasFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Liter/Minute],
			Units -> Milli*Liter/Minute,
			Relation -> Null,
			Description -> "The flow rate of carrier gas used to purge the column(s) during the column conditioning step.",
			Category -> "Instrument Setup",
			Abstract -> False
		},*)
		ColumnConditioningTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "The time for which the column was purged by the column conditioning gas prior to separation of standards and samples in the column during the experiment.",
			Category -> "Instrument Setup",
			Abstract -> False
		},
		ColumnConditioningTemperature -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[GreaterEqualP[0*Kelvin],Ambient],
			Relation -> Null,
			Description -> "The temperature at which the column was conditioned prior to separation of standards and samples in the column during the experiment.",
			Category -> "Instrument Setup",
			Abstract -> False
		},
		LiquidInjectionSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,Syringe],
				Object[Container,Syringe]
			],
			Description -> "The syringe that was used to inject liquid samples onto the column.",
			Category -> "Instrument Specifications",
			Abstract -> False
		},
		HeadspaceInjectionSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,Syringe],
				Object[Container,Syringe]
			],
			Description -> "The syringe that was used to inject headspace samples onto the column.",
			Category -> "Instrument Specifications",
			Abstract -> False
		},
		SPMEInjectionFiber -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item,SPMEFiber],
				Object[Item,SPMEFiber]
			],
			Description -> "The Solid Phase MicroExtraction (SPME) fiber that was used to inject samples onto the column.",
			Category -> "Instrument Specifications",
			Abstract -> False
		},
		LiquidHandlingSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,Syringe],
				Object[Container,Syringe]
			],
			Description -> "The syringe that was installed into the liquid handling tool on the autosampler deck.",
			Category -> "Instrument Specifications",
			Abstract -> False
		},
		Detector -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GCDetectorP,
			Relation -> Null,
			Description -> "The detector used to obtain data during this experiment.",
			Category -> "Instrument Specifications",
			Abstract -> False
		},
		FIDMakeupGas -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> InertGCCarrierGasP,
			Relation -> Null,
			Description -> "The desired capillary makeup gas flowed into the Flame Ionization Detector (FID) during sample analysis.",
			Category -> "Instrument Specifications",
			Abstract -> False
		},
		DilutionSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "Dilution solvent to be available for dilution/sample modification procedures.",
			Category -> "Instrument Specifications",
			Abstract -> False
		},
		SecondaryDilutionSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "Secondary dilution solvent to be available for dilution/sample modification procedures.",
			Category -> "Instrument Specifications",
			Abstract -> False
		},
		TertiaryDilutionSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "Tertiary dilution solvent to be available for dilution/sample modification procedures.",
			Category -> "Instrument Specifications",
			Abstract -> False
		},
		Dilute -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of SamplesIn, indicates whether or not the sample was diluted prior to sampling.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		DilutionSolventVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the volume to move from the DilutionSolvent vial into the sample vial.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		SecondaryDilutionSolventVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the volume to move from the SecondaryDilutionSolvent vial into the sample vial.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		TertiaryDilutionSolventVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the volume to move from the TertiaryDilutionSolvent vial into the sample vial.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		Agitate -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of SamplesIn, indicates whether or not the sample was mixed by swirling the container for a specified time at a specified rotational speed and temperature prior to sampling.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		AgitationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the time that each sample was incubated in the agitator prior to analysis.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		AgitationTemperature -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[GreaterEqualP[0*Kelvin],Ambient],
			Relation -> Null,
			Description -> "For each member of SamplesIn, the temperature at which each sample was incubated at in the agitator prior to analysis.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		AgitationMixRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the rate (in RPM) at which each sample was swirled at in the agitator prior to analysis.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		AgitationOnTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the amount of time for which the agitator will swirl before switching directions.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		AgitationOffTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the amount of time for which the agitator will idle while switching directions.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		Vortex -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of SamplesIn, indicates whether or not the sample was spun in place (vortexed) prior to sampling.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		VortexMixRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the rate (in RPM) at which the sample was vortexed in the vortex mixer prior to analysis.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		VortexTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the amount of time for which the sample was vortex mixed prior to analysis.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		SamplingMethod -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GCSamplingMethodP,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the sampling method that was used to extract a mixture of analytes from the sample vial and inject those analytes into the injection port.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		HeadspaceSyringeTemperature -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[GreaterEqualP[0*Kelvin],Ambient],
			Relation -> Null,
			Description -> "For each member of SamplesIn, the temperature that the headspace syringe was held at during the sampling task.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		SyringeWashSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "Syringe wash solvent to be available for dilution/sample modification procedures.",
			Category -> "Instrument Specifications",
			Abstract -> False
		},
		SecondarySyringeWashSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "Secondary syringe wash solvent to be available for dilution/sample modification procedures.",
			Category -> "Instrument Specifications",
			Abstract -> False
		},
		TertiarySyringeWashSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "Tertiary syringe wash solvent to be available for dilution/sample modification procedures.",
			Category -> "Instrument Specifications",
			Abstract -> False
		},
		QuaternarySyringeWashSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "Quaternary syringe wash solvent to be available for dilution/sample modification procedures.",
			Category -> "Instrument Specifications",
			Abstract -> False
		},
		LiquidPreInjectionSyringeWash -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of SamplesIn, indicates whether the instrument will rinse the liquid injection syringe with any of the syringe wash solvents in an attempt to remove any impurities present prior to sample aspiration.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		LiquidPreInjectionSyringeWashVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the volume of the injection syringe to fill with wash solvent during each pre-injection syringe washing step.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		LiquidPreInjectionSyringeWashRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter/Second],
			Units -> Micro*Liter/Second,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the aspiration rate that was used to draw and dispense liquid during the pre-injection syringe washing procedure.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		LiquidPreInjectionNumberOfSolventWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the number of washes to perform using WashSolvent during the pre-injection syringe washing procedure.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		LiquidPreInjectionNumberOfSecondarySolventWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the number of washes to perform using SecondaryWashSolvent during the pre-injection syringe washing procedure.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		LiquidPreInjectionNumberOfTertiarySolventWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the number of washes to perform using TertiaryWashSolvent during the pre-injection syringe washing procedure.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		LiquidPreInjectionNumberOfQuaternarySolventWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the number of washes to perform using QuaternaryWashSolvent during the pre-injection syringe washing procedure.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		LiquidSampleWash -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of SamplesIn, indicates whether the liquid injection syringe was flushed with sample prior to aspirating the sample InjectionVolume for injection.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		NumberOfLiquidSampleWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the number of washes to perform on the injection syringe using the sample during the pre-injection sample washing procedure.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		LiquidSampleWashVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the volume of the sample that was used to rinse the syringe during the pre-injection sample washing procedure.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		LiquidSampleFillingStrokes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the number of filling strokes to perform when drawing a sample for injection.",
			IndexMatching -> SamplesIn,
			Category -> "Injection",
			Abstract -> False
		},
		LiquidSampleFillingStrokesVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the volume of the filling strokes to draw when drawing a sample for injection.",
			IndexMatching -> SamplesIn,
			Category -> "Injection",
			Abstract -> False
		},
		LiquidFillingStrokeDelay -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the amount of time the injection tool will idle between filling strokes.",
			IndexMatching -> SamplesIn,
			Category -> "Injection",
			Abstract -> False
		},
		HeadspaceSyringeFlushing -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[
				Continuous,
				{Alternatives[BeforeSampleAspiration,AfterSampleInjection]..}
			],
			Relation -> Null,
			Description -> "For each member of SamplesIn, whether a stream of Helium was flowed through the cylinder of the headspace syringe without interruption between injections (Continuous), or if Helium was flowed through the cylinder of the headspace syringe before and/or after sample aspiration for specified amounts of time.",
			IndexMatching -> SamplesIn,
			Category -> "Cleaning",
			Abstract -> False
		},
		HeadspacePreInjectionFlushTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the amount of time the headspace tool will flow helium through the injection syringe (thus purging the syringe environment) before drawing a sample.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		SPMECondition -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of SamplesIn, indicates whether or not the Solid Phase MicroExtraction (SPME) tool was conditioned prior to sample adsorption.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		SPMEConditioningTemperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the temperature at which the Solid Phase MicroExtraction (SPME) fiber was treated in flowing Helium prior to exposure to the sample environment.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		SPMEPreConditioningTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the amount of time the Solid Phase MicroExtraction (SPME) tool was conditioned before adsorbing a sample.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		SPMEDerivatizingAgent -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "For each member of SamplesIn, the on-fiber derivatizing agent to be used to modify the sample during sample adsorption.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		SPMEDerivatizingAgentAdsorptionTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the amount of time the Solid Phase MicroExtraction (SPME) tool will adsorb the derivatizing agent before adsorbing a sample.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		SPMEDerivatizationPosition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (Top|Bottom),
			Relation -> Null,
			Description -> "For each member of SamplesIn, the position in the vial (Top or Bottom) at which the Solid Phase MicroExtraction (SPME) fiber was treated with the derivatizing agent during fiber preparation.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		SPMEDerivatizationPositionOffset -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Meter],
			Units -> Milli*Meter,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the distance from the SPMEDerivatizationPosition at which the Solid Phase MicroExtraction (SPME) fiber was treated with the derivatizing agent during fiber preparation.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		AgitateWhileSampling -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of SamplesIn, indicates that the sample was collected by the injection tool while the sample is being agitated at the specified AgitationTemperature, AgitationRate, ...",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		SampleVialAspirationPosition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GCVialPositionP,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the position in the vial (Top or Bottom) from which the sample was aspirated.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		SampleVialAspirationPositionOffset -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Meter],
			Units -> Milli*Meter,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the distance of the tip of the injection syringe from the top or bottom of the sample vial (set by SampleVialAspirationPosition) during sample aspiration.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		SampleVialPenetrationRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Meter /Second],
			Units -> Milli*Meter /Second,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the speed that the injection tool will penetrate the sample vial septum during sampling.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> False
		},
		InjectionVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the volume of sample to draw into the liquid or headspace tool sample syringe for introduction of the sample into the inlet.",
			IndexMatching -> SamplesIn,
			Category -> "Injection",
			Abstract -> False
		},
		LiquidSampleOverAspirationVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the volume of air to draw into the liquid sample syringe after aspirating the sample.",
			IndexMatching -> SamplesIn,
			Category -> "Injection",
			Abstract -> False
		},
		SampleAspirationRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter/Second],
			Units -> Micro*Liter/Second,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the volumetric rate at which the sample was drawn during the sampling procedure.",
			IndexMatching -> SamplesIn,
			Category -> "Injection",
			Abstract -> False
		},
		SampleAspirationDelay -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the amount of time the injection tool will idle after aspirating the sample to allow the pressures in the sample vial and syringe to equilibrate.",
			IndexMatching -> SamplesIn,
			Category -> "Injection",
			Abstract -> False
		},
		SPMESampleExtractionTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the amount of time the injection tool will leave the Solid Phase MicroExtraction (SPME) fiber in contact with the sample for adsorption of analytes onto the SPME fiber.",
			IndexMatching -> SamplesIn,
			Category -> "Injection",
			Abstract -> False
		},
		InjectionInletPenetrationDepth -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Meter],
			Units -> Milli*Meter,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the distance through the inlet septum that the injection tool will position the injection syringe tip during injection of the sample.",
			IndexMatching -> SamplesIn,
			Category -> "Injection",
			Abstract -> False
		},
		InjectionInletPenetrationRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Meter /Second],
			Units -> Milli*Meter /Second,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the speed that the injection tool will penetrate the inlet septum during injection of the sample.",
			IndexMatching -> SamplesIn,
			Category -> "Injection",
			Abstract -> False
		},
		InjectionSignalMode -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (PlungerUp|PlungerDown),
			Relation -> Null,
			Description -> "For each member of SamplesIn, indicates whether the instrument will start the run clock before or after the sample has been introduced into the vaporization chamber of the inlet by depressing the plunger of the injection tool (while the syringe has already been inserted into the inlet) during the injection.",
			IndexMatching -> SamplesIn,
			Category -> "Injection",
			Abstract -> False
		},
		PreInjectionTimeDelay -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the amount of time the syringe was held in the inlet before the plunger is depressed and the sample is introduced into the inlet.",
			IndexMatching -> SamplesIn,
			Category -> "Injection",
			Abstract -> False
		},
		SampleInjectionRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter/Second],
			Units -> Micro*Liter/Second,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the injection rate that was used to dispense a fluid sample into the inlet during the sample injection procedure.",
			IndexMatching -> SamplesIn,
			Category -> "Injection",
			Abstract -> False
		},
		SPMESampleDesorptionTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the amount of time the injection tool will leave the Solid Phase MicroExtraction (SPME) fiber exposed in the inlet vaporization chamber.",
			IndexMatching -> SamplesIn,
			Category -> "Injection",
			Abstract -> False
		},
		PostInjectionTimeDelay -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the amount of time the syringe was held in the inlet after the plunger has been completely depressed and before it is withdrawn from the inlet.",
			IndexMatching -> SamplesIn,
			Category -> "Injection",
			Abstract -> False
		},
		LiquidPostInjectionSyringeWash -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of SamplesIn, indicates whether the instrument will rinse the liquid injection syringe with any of the syringe wash solvents in an attempt to remove any impurities present after sample injection.",
			IndexMatching -> SamplesIn,
			Category -> "Cleaning",
			Abstract -> False
		},
		LiquidPostInjectionSyringeWashVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the volume of the injection syringe to fill with wash solvent during each post-injection syringe washing step.",
			IndexMatching -> SamplesIn,
			Category -> "Cleaning",
			Abstract -> False
		},
		LiquidPostInjectionSyringeWashRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter/Second],
			Units -> Micro*Liter/Second,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the aspiration rate that was used to draw and dispense liquid during the post-injection syringe washing procedure.",
			IndexMatching -> SamplesIn,
			Category -> "Cleaning",
			Abstract -> False
		},
		LiquidPostInjectionNumberOfSolventWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the number of washes to perform using the syringeWashSolvent during the post-injection syringe washing procedure.",
			IndexMatching -> SamplesIn,
			Category -> "Cleaning",
			Abstract -> False
		},
		LiquidPostInjectionNumberOfSecondarySolventWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the number of washes to perform using the SecondarySyringeWashSolvent during the post-injection syringe washing procedure.",
			IndexMatching -> SamplesIn,
			Category -> "Cleaning",
			Abstract -> False
		},
		LiquidPostInjectionNumberOfTertiarySolventWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the number of washes to perform using the TertiarySyringeWashSolvent during the post-injection syringe washing procedure.",
			IndexMatching -> SamplesIn,
			Category -> "Cleaning",
			Abstract -> False
		},
		LiquidPostInjectionNumberOfQuaternarySolventWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the number of washes to perform using the QuaternarySyringeWashSolvent during the post-injection syringe washing procedure.",
			IndexMatching -> SamplesIn,
			Category -> "Cleaning",
			Abstract -> False
		},
		PostInjectionNextSamplePreparationSteps -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (NoSteps|SolventWash|SampleWash|SampleFillingStrokes|SampleAspiration),
			Relation -> Null,
			Description -> "For each member of SamplesIn, the sample preparation step up to which the autosampling arm proceeded (as described in Figures 3.5, 3.6, 3.7, and 3.10 in the ExperimentGasChromatography help file) to prepare to inject the next sample in the injection sequence prior to the completion of the separation of the sample that has just been injected. If NoSteps are specified, the autosampler will wait until a separation is complete to begin preparing the next sample in the injection queue.",
			IndexMatching -> SamplesIn,
			Category -> "Injection Preparation",
			Abstract -> False
		},
		HeadspacePostInjectionFlushTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the amount of time the headspace tool will flow helium through the injection syringe (thus purging the syringe environment) after injecting a sample.",
			IndexMatching -> SamplesIn,
			Category -> "Cleaning",
			Abstract -> False
		},
		SPMEPostInjectionConditioningTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the amount of time the Solid Phase MicroExtraction (SPME) tool was conditioned after desorbing a sample.",
			IndexMatching -> SamplesIn,
			Category -> "Cleaning",
			Abstract -> False
		},
		SeparationMethod -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "For each member of SamplesIn, a collection of inlet, column, and oven parameters that were used to perform the chromatographic separation after the sample has been injected.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		InletSeptumPurgeFlowRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Liter/Minute],
			Units -> Milli*Liter/Minute,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the flow rate of carrier gas that was passed through the inlet septum purge valve, which will continuously flush the volume inside the inlet between the inlet septum and the inlet liner.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		InitialInletTemperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the desired inlet temperature when the InletTemperatureMode is Isothermal, or the temperature at which the InletTemperatureProfile will begin if the InletTemperature is TemperatureProfile.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		InitialInletTemperatureDuration -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the amount of time into the separation to hold the Inlet at its InitialInletTemperature before starting the InletTemperatureProfile.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		InletTemperatureProfile -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[
				{{GreaterEqualP[0*Minute],GreaterP[0*Kelvin]}..},
				{{GreaterP[0*Kelvin/Minute],GreaterP[0*Kelvin],GreaterEqualP[0*Minute]}..},
				GreaterP[0*Kelvin],
				Isothermal
			],
			Relation -> Null,
			Description -> "For each member of SamplesIn, describes how the inlet temperature will evolve as a function of time after injection of the sample into the inlet.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		InletMode -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GCInletModeP,
			Relation -> Null,
			Description -> "For each member of SamplesIn, indicates whether the inlet was used in split, splitless, pulsed split, pulsed splitless, solvent vent, or direct injection mode.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		SplitRatio -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the ratio of flow rate out of the inlet vaporization chamber that passes into the inlet split vent to the flow rate out of the inlet vaporization chamber that passes into the capillary column (see Figure 3.1 in the ExperimentGasChromatography help file). This value is equal to the theoretical ratio of the amount of injected sample that will pass onto the column to the amount of sample that was eliminated from the inlet through the split valve.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		SplitVentFlowRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Liter/Minute],
			Units -> Milli*Liter/Minute,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the desired flow rate through the inlet that will exit the inlet through the inlet split vent during sample injection.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		SplitlessTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the amount of time the split valve will remain closed after injecting the sample into the inlet.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		InitialInletPressure -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 PSI],
			Units -> PSI,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the desired pressure (in PSI gauge pressure) that was held in the inlet at the beginning of the separation.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		InitialInletTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the time after which the column head pressure was returned from the InitialInletPressure to the column setpoint following a pulsed injection.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		GasSaver -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of SamplesIn, indicates whether the gas saver was used during the experiment. The gas saver reduces flow through the split vent during sample separation, reducing Helium consumption.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		GasSaverFlowRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Liter/Minute],
			Units -> Milli*Liter/Minute,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the desired gas flow rate that the total inlet flow was reduced to when the gas saver is activated.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		GasSaverActivationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the amount of time after the beginning of each run that the gas saver was activated.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		SolventEliminationFlowRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Liter/Minute],
			Units -> Milli*Liter/Minute,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the flow rate of carrier gas that was passed through the inlet and out the split vent in an attempt to selectively remove solvent from the inlet during a solvent vented injection.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		GCColumnMode -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GCColumnModeP,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the mode that the column will operate in during sample separation.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		InitialColumnFlowRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Liter/Minute],
			Units -> Milli*Liter/Minute,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the initial column gas flow rate setpoint.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		InitialColumnPressure -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 PSI],
			Units -> PSI,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the initial column pressure (in PSI gauge pressure) setpoint.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		InitialColumnAverageVelocity -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Centi*Meter /Second],
			Units -> Centi*Meter /Second,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the initial column average linear gas velocity setpoint.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		InitialColumnResidenceTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the total time on average that a molecule of gas takes to flow from the beginning to the end of the column.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		InitialColumnSetpointDuration -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the amount of time into the method to hold the column at a specified initial column parameter (InitialColumnFlowRate, InitialColumnPressure, InitialColumnAverageVelocity, InitialColumnResidenceTime) before starting a pressure or flow rate profile.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		ColumnPressureProfile -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[
				{{GreaterEqualP[0*Minute],GreaterP[0*PSI]}..},
				{{GreaterP[0*PSI/Minute],GreaterP[0*PSI],GreaterEqualP[0*Minute]}..},
				GreaterP[0*PSI],
				ConstantPressure
			],
			Relation -> Null,
			Description -> "For each member of SamplesIn, the pressure ramping profile for the inlet that was run during sample separation in the column.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		ColumnFlowRateProfile -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[
				{{GreaterEqualP[0*Minute],GreaterP[0*Milli*Liter/Minute]}..},
				{{GreaterP[0*Milli*Liter/Minute/Minute],GreaterP[0*Milli*Liter/Minute],GreaterEqualP[0*Minute]}..},
				GreaterP[0*Milli*Liter/Minute],
				ConstantFlowRate
			],
			Relation -> Null,
			Description -> "For each member of SamplesIn, the flow rate ramping profile for the inlet that was run during sample separation in the column.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		OvenEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the time to dwell at the initial OvenTemperature before allowing the instrument to begin the next separation.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		InitialOvenTemperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the desired column oven temperature setpoint prior to the column oven temperature Profile.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		InitialOvenTemperatureDuration -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the amount of time into the separation to hold the column oven at its OvenInitialTemperature before starting the column oven temperature Profile.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		OvenTemperatureProfile -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[
				{{GreaterEqualP[0*Minute],GreaterP[0*Kelvin]}..},
				{{GreaterP[0*Kelvin/Minute],GreaterP[0*Kelvin],GreaterEqualP[0*Minute]}..},
				{GreaterP[0*Kelvin],GreaterP[0*Minute]},
				Isothermal
			],
			Relation -> Null,
			Description -> "For each member of SamplesIn, the temperature profile for the column oven that was run during sample separation in the column.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		PostRunOvenTemperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the column oven set point temperature that will be applied once the separation is completed.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		PostRunOvenTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the amount of time to hold the column at its PostRunOvenTemperature and PostRunFlowRate/PostRunPressure once the separation is completed.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		PostRunFlowRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter/Minute],
			Units -> Milliliter/Minute,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the flow rate that will be flowed through the column once the separation is completed.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},
		PostRunPressure -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 PSI],
			Units -> PSI,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the pressure that will be applied to the column once the separation is completed.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Abstract -> False
		},

		(* Detectors *)

		(* FID *)
		FIDTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Relation -> Null,
			Description -> "The temperature of the Flame Ionization Detector (FID) body during analysis of the samples.",
			Category -> "General",
			Abstract -> False
		},
		FIDAirFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Liter/Minute],
			Units -> Milli*Liter/Minute,
			Relation -> Null,
			Description -> "The flow rate of air supplied as an oxidant to the Flame Ionization Detector (FID) during sample analysis.",
			Category -> "General",
			Abstract -> False
		},
		FIDDihydrogenFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Liter/Minute],
			Units -> Milli*Liter/Minute,
			Relation -> Null,
			Description -> "The flow rate of dihydrogen gas supplied as a fuel to the Flame Ionization Detector (FID) during sample analysis.",
			Category -> "General",
			Abstract -> False
		},
		FIDMakeupGasFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Liter/Minute],
			Units -> Milli*Liter/Minute,
			Relation -> Null,
			Description -> "The desired makeup gas flow rate added to the fuel flow supplied to the Flame Ionization Detector (FID) during sample analysis.",
			Category -> "General",
			Abstract -> False
		},
		CarrierGasFlowCorrection -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> (Fuel|Makeup|None),
			Relation -> Null,
			Description -> "Specifies which (if any) of the Flame Ionization Detector (FID) gas supply flow rates (Fuel or Makeup) was adjusted as the column flow rate changed to keep the total flow into the FID constant during the separation.",
			Category -> "General",
			Abstract -> False
		},
		FIDDataCollectionFrequency -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hertz],
			Units -> Hertz,
			Relation -> Null,
			Description -> "The desired number of data points per second that was collected by the instrument.",
			Category -> "General",
			Abstract -> False
		},

		(* MS *)
		TransferLineTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Relation -> Null,
			Description -> "The temperature at which the segment of column the extends out of the column oven and into the mass spectrometer is held.",
			Category -> "General",
			Abstract -> False
		},
		IonSource -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> (ElectronIonization|ChemicalIonization),
			Relation -> Null,
			Description -> "Specifies the method by which the analytes were ionized. Electron Ionization uses a heated filament to create energetic electrons that collide with the gaseous analytes flowing into the mass spectrometer from the column, creating ionized fragments of the analytes that can be focused into the detector. Chemical ionization uses a reagent gas to intercept electrons from the filament to create primary ions that undergo subsequent reaction with the analytes flowing into the mass spectrometer from the column, ionizing the analytes more gently than the traditional Electron Ionization method, but also producing a different fragmentation pattern as a result of the chemical reactions taking place during ionization.",
			Category -> "General",
			Abstract -> False
		},
		IonMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> IonModeP,
			Relation -> Null,
			Description -> "Indicates if positively or negatively charged ions are analyzed.",
			Category -> "General",
			Abstract -> False
		},
		SourceTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Relation -> Null,
			Description -> "The temperature at which the ionization source, where the sample is ionized inside the mass spectrometer, is held.",
			Category -> "General",
			Abstract -> False
		},
		QuadrupoleTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Relation -> Null,
			Description -> "The temperature at which the parallel metal rods, which select the mass of ion to be analyzed inside the mass spectrometer, are held.",
			Category -> "General",
			Abstract -> False
		},
		SolventDelay -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "The amount of time into the separation after which the mass spectrometer will turn on its controlling voltages. This time should be set to a point in the separation after which the main solvent peak from the separation has already entered and exited the mass spectrometer to avoid damaging the filament.",
			Category -> "General",
			Abstract -> False
		},
		MassDetectionGain -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "The linear signal amplification factor applied to the ions detected in the mass spectrometer. A gain factor of 1.0 indicates a signal multiplication of 100,000 by the detector. Higher gain factors raise the signal sensitivity but can also cause a nonlinear detector response at higher ion abundances. It is recommended that the lowest possible gain that allows achieving the desired detection limits be used to avoid damaging the electron multiplier.",
			Category -> "General",
			Abstract -> False
		},
		TraceIonDetection -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Units -> None,
			Relation -> Null,
			Description -> "Indicates whether a proprietary set of algorithms to reduce noise in ion abundance measurements during spectral collection, resulting in lower detection limits for trace compounds, will be used.",
			Category -> "General",
			Abstract -> False
		},
		AcquisitionWindowStartTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "The amount of time into the separation after which the mass spectrometer will begin collecting data over the specified MassRange.",
			Category -> "General",
			Abstract -> False
		},
		MassRanges -> {
			Format -> Multiple,
			Class -> {Real,Real},
			Pattern :> {GreaterP[0],GreaterP[0]},
			Units -> {None,None},
			Relation -> {Null,Null},
			Description -> "For each member of AcquisitionWindowStartTimes, the lowest and the highest mass-to-charge ratio (m/z) to be recorded during analysis.",
			IndexMatching -> AcquisitionWindowStartTimes,
			Category -> "General",
			Headers -> {"First m/z","Last m/z"},
			Abstract -> False
		},
		MassRangeThresholds -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of AcquisitionWindowStartTimes, the ion abundance above which a data point at any given m/z must exceed to be further analyzed.",
			IndexMatching -> AcquisitionWindowStartTimes,
			Category -> "General",
			Abstract -> False
		},
		MassRangeScanSpeeds -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of AcquisitionWindowStartTimes, the speed (in m/z per second) at which the mass spectrometer will collect data.",
			IndexMatching -> AcquisitionWindowStartTimes,
			Category -> "General",
			Abstract -> False
		},
		MassSelections -> {
			Format -> Multiple,
			Class -> {Real,Real},
			Pattern :> {GreaterEqualP[0],GreaterEqualP[0 Second]},
			Units -> {None,Milli*Second},
			Relation -> {Null,Null},
			Description -> "For each member of AcquisitionWindowStartTimes, the lowest and the highest mass-to-charge ratio (m/z) to be recorded during Selected Ion Monitoring collection.",
			IndexMatching -> AcquisitionWindowStartTimes,
			Category -> "General",
			Headers ->{"m/z","Dwell time"},
			Abstract -> False
		},
		MassSelectionResolutions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Low,High],
			Relation -> Null,
			Description -> "For each member of AcquisitionWindowStartTimes, the m/z range window that may be transmitted through the quadrupole at the selected mass. Low resolution will allow a larger range of masses through the quadrupole and increase sensitivity and repeatability, but is not ideal for comparing adjacent m/z values as there may be some overlap in the measured abundances.",
			IndexMatching -> AcquisitionWindowStartTimes,
			Category -> "General",
			Abstract -> False
		},
		MassSelectionDetectionGains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of AcquisitionWindowStartTimes, the gain factor that was used during the collection of the corresponding list of selectively monitored m/z in MassSelection.",
			IndexMatching -> AcquisitionWindowStartTimes,
			Category -> "General",
			Abstract -> False
		},

		(*standards*)
		IncludeStandards -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "Indicates if samples were injected to be used for quantification of the samples being measured in this experiment.",
			Category -> "Standards"
		},
		Standards -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The reference compound(s) to inject into the instrument, often used for quantification or to check internal measurement consistency.",
			Category -> "Standards",
			Abstract -> False
		},
		StandardVial -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of Standards, the container in which the standard was prepared for injection.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardAmount -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Liter],
			Units -> Milli*Liter,
			Relation -> Null,
			Description -> "For each member of Standards, the volume or mass of standard that was placed in the StandardVial during preparation for injection.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardDilute -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of Standards, indicates whether or not the sample was diluted prior to sampling.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardDilutionSolventVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of Standards, the volume to move from the DilutionSolvent vial into the sample vial.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardSecondaryDilutionSolventVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of Standards, the volume to move from the SecondaryDilutionSolvent vial into the sample vial.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardTertiaryDilutionSolventVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of Standards, the volume to move from the TertiaryDilutionSolvent vial into the sample vial.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardAgitate -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of Standards, indicates whether or not the sample was mixed by swirling the container for a specified time at a specified rotational speed and temperature prior to sampling.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardAgitationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Standards, the time that each sample was incubated in the agitator prior to analysis.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardAgitationTemperature -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[GreaterEqualP[0*Kelvin],Ambient],
			Relation -> Null,
			Description -> "For each member of Standards, the temperature at which each sample was incubated at in the agitator prior to analysis.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardAgitationMixRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Relation -> Null,
			Description -> "For each member of Standards, the rate (in RPM) at which each sample was swirled at in the agitator prior to analysis.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardAgitationOnTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of Standards, the amount of time for which the agitator will swirl before switching directions.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardAgitationOffTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of Standards, the amount of time for which the agitator will idle while switching directions.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardVortex -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of Standards, indicates whether or not the sample was spun in place (vortexed) prior to sampling.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardVortexMixRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Relation -> Null,
			Description -> "For each member of Standards, the rate (in RPM) at which the sample was vortexed in the vortex mixer prior to analysis.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardVortexTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of Standards, the amount of time for which the sample was vortex mixed prior to analysis.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardSamplingMethod -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GCSamplingMethodP,
			Relation -> Null,
			Description -> "For each member of Standards, the sampling method that was used to extract a mixture of analytes from the sample vial and inject those analytes into the injection port.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardHeadspaceSyringeTemperature -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[GreaterEqualP[0*Kelvin],Ambient],
			Relation -> Null,
			Description -> "For each member of Standards, the temperature that the headspace syringe was held at during the sampling task.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardLiquidPreInjectionSyringeWash -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of Standards, indicates whether the instrument will rinse the liquid injection syringe with any of the syringe wash solvents in an attempt to remove any impurities present prior to sample aspiration.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardLiquidPreInjectionSyringeWashVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of Standards, the volume of the injection syringe to fill with wash solvent during each pre-injection syringe washing step.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardLiquidPreInjectionSyringeWashRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter/Second],
			Units -> Micro*Liter/Second,
			Relation -> Null,
			Description -> "For each member of Standards, the aspiration rate that was used to draw and dispense liquid during the pre-injection syringe washing procedure.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardLiquidPreInjectionNumberOfSolventWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of Standards, the number of washes to perform using WashSolvent during the pre-injection syringe washing procedure.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardLiquidPreInjectionNumberOfSecondarySolventWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of Standards, the number of washes to perform using SecondaryWashSolvent during the pre-injection syringe washing procedure.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardLiquidPreInjectionNumberOfTertiarySolventWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of Standards, the number of washes to perform using TertiaryWashSolvent during the pre-injection syringe washing procedure.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardLiquidPreInjectionNumberOfQuaternarySolventWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of Standards, the number of washes to perform using QuaternaryWashSolvent during the pre-injection syringe washing procedure.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardLiquidSampleWash -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of Standards, indicates whether the liquid injection syringe was flushed with sample prior to aspirating the sample InjectionVolume for injection.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardNumberOfLiquidSampleWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of Standards, the number of washes to perform on the injection syringe using the sample during the pre-injection sample washing procedure.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardLiquidSampleWashVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of Standards, the volume of the sample that was used to rinse the syringe during the pre-injection sample washing procedure.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardLiquidSampleFillingStrokes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of Standards, the number of filling strokes to perform when drawing a sample for injection.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardLiquidSampleFillingStrokesVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of Standards, the volume of the filling strokes to draw when drawing a sample for injection.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardLiquidFillingStrokeDelay -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of Standards, the amount of time the injection tool will idle between filling strokes.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardHeadspaceSyringeFlushing -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of Standards, whether a stream of Helium was flowed through the cylinder of the headspace syringe without interruption between injections (Continuous), or if Helium was flowed through the cylinder of the headspace syringe before and/or after sample aspiration for specified amounts of time.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardHeadspacePreInjectionFlushTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of Standards, the amount of time the headspace tool will flow helium through the injection syringe (thus purging the syringe environment) before drawing a sample.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardSPMECondition -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of Standards, indicates whether or not the Solid Phase MicroExtraction (SPME) tool was conditioned prior to sample adsorption.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardSPMEConditioningTemperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Relation -> Null,
			Description -> "For each member of Standards, the temperature at which the Solid Phase MicroExtraction (SPME) fiber was treated in flowing Helium prior to exposure to the sample environment.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardSPMEPreConditioningTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Standards, the amount of time the Solid Phase MicroExtraction (SPME) tool was conditioned before adsorbing a sample.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardSPMEDerivatizingAgent -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "For each member of Standards, the on-fiber derivatizing agent to be used to modify the sample during sample adsorption.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardSPMEDerivatizingAgentAdsorptionTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Standards, the amount of time the Solid Phase MicroExtraction (SPME) tool will adsorb the derivatizing agent before adsorbing a sample.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardSPMEDerivatizationPosition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GCVialPositionP,
			Relation -> Null,
			Description -> "For each member of Standards, the position in the vial (Top or Bottom) at which the Solid Phase MicroExtraction (SPME) fiber was treated with the derivatizing agent during fiber preparation.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardSPMEDerivatizationPositionOffset -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Meter],
			Units -> Milli*Meter,
			Relation -> Null,
			Description -> "For each member of Standards, the distance from the SPMEDerivatizationPosition at which the Solid Phase MicroExtraction (SPME) fiber was treated with the derivatizing agent during fiber preparation.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardAgitateWhileSampling -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of Standards, indicates that the headspace sample was drawn while the sample is being agitated at the specified AgitationTemperature, AgitationRate, ...",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardSampleVialAspirationPosition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GCVialPositionP,
			Relation -> Null,
			Description -> "For each member of Standards, the position in the vial (Top or Bottom) from which the sample was aspirated.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardSampleVialAspirationPositionOffset -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Meter],
			Units -> Milli*Meter,
			Relation -> Null,
			Description -> "For each member of Standards, the distance of the tip of the injection syringe from the top or bottom of the sample vial (set by SampleVialAspirationPosition) during sample aspiration.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardSampleVialPenetrationRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Meter /Second],
			Units -> Milli*Meter /Second,
			Relation -> Null,
			Description -> "For each member of Standards, the speed that the injection tool will penetrate the sample vial septum during sampling.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardInjectionVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of Standards, the volume of sample to draw into the liquid or headspace tool sample syringe for introduction of the sample into the inlet.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardLiquidSampleOverAspirationVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of Standards, the volume of air to draw into the liquid sample syringe after aspirating the sample.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardSampleAspirationRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter/Second],
			Units -> Micro*Liter/Second,
			Relation -> Null,
			Description -> "For each member of Standards, the volumetric rate at which the sample was drawn during the sampling procedure.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardSampleAspirationDelay -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of Standards, the amount of time the injection tool will idle after aspirating the sample to allow the pressures in the sample vial and syringe to equilibrate.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardSPMESampleExtractionTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Standards, the amount of time the injection tool will leave the Solid Phase MicroExtraction (SPME) fiber in contact with the sample for adsorption of analytes onto the SPME fiber.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardInjectionInletPenetrationDepth -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Meter],
			Units -> Milli*Meter,
			Relation -> Null,
			Description -> "For each member of Standards, the distance through the inlet septum that the injection tool will position the injection syringe tip during injection of the sample.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardInjectionInletPenetrationRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Meter /Second],
			Units -> Milli*Meter /Second,
			Relation -> Null,
			Description -> "For each member of Standards, the speed that the injection tool will penetrate the inlet septum during injection of the sample.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardInjectionSignalMode -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (PlungerUp|PlungerDown),
			Relation -> Null,
			Description -> "For each member of Standards, whether the instrument will start the run clock before or after the sample has been introduced into the vaporization chamber of the inlet (while the syringe has already been inserted into the inlet) during the injection.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardPreInjectionTimeDelay -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of Standards, the amount of time the syringe was held in the inlet before the plunger is depressed and the sample is introduced into the inlet.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardSampleInjectionRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter/Second],
			Units -> Micro*Liter/Second,
			Relation -> Null,
			Description -> "For each member of Standards, the injection rate that was used to dispense a fluid sample into the inlet during the sample injection procedure.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardSPMESampleDesorptionTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Standards, the amount of time the injection tool will leave the Solid Phase MicroExtraction (SPME) fiber exposed in the inlet vaporization chamber.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardPostInjectionTimeDelay -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of Standards, the amount of time the syringe was held in the inlet after the plunger has been completely depressed and before it is withdrawn from the inlet.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardLiquidPostInjectionSyringeWash -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of Standards, indicates whether the instrument will rinse the liquid injection syringe with any of the syringe wash solvents in an attempt to remove any impurities present after sample injection.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardLiquidPostInjectionSyringeWashVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter/Second],
			Units -> Micro*Liter/Second,
			Relation -> Null,
			Description -> "For each member of Standards, the volume of the injection syringe to fill with wash solvent during each post-injection syringe washing step.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardLiquidPostInjectionSyringeWashRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter/Second],
			Units -> Micro*Liter/Second,
			Relation -> Null,
			Description -> "For each member of Standards, the aspiration rate that was used to draw and dispense liquid during the post-injection syringe washing procedure.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardLiquidPostInjectionNumberOfSolventWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of Standards, the number of washes to perform using the syringeWashSolvent during the post-injection syringe washing procedure.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardLiquidPostInjectionNumberOfSecondarySolventWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of Standards, the number of washes to perform using the SecondarySyringeWashSolvent during the post-injection syringe washing procedure.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardLiquidPostInjectionNumberOfTertiarySolventWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of Standards, the number of washes to perform using the TertiarySyringeWashSolvent during the post-injection syringe washing procedure.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardLiquidPostInjectionNumberOfQuaternarySolventWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of Standards, the number of washes to perform using the QuaternarySyringeWashSolvent during the post-injection syringe washing procedure.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardPostInjectionNextSamplePreparationSteps -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (NoSteps|SolventWash|SampleWash|SampleFillingStrokes|SampleAspiration),
			Relation -> Null,
			Description -> "For each member of Standards, the sample preparation step up to which the autosampling arm proceeded (as described in Figures 3.5, 3.6, 3.7, and 3.10 in the ExperimentGasChromatography help file) to prepare to inject the next sample in the injection sequence prior to the completion of the separation of the sample that has just been injected. If NoSteps are specified, the autosampler will wait until a separation is complete to begin preparing the next sample in the injection queue.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardHeadspacePostInjectionFlushTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of Standards, the amount of time the headspace tool will flow helium through the injection syringe (thus purging the syringe environment) after injecting a sample.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardSPMEPostInjectionConditioningTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Standards, the amount of time the Solid Phase MicroExtraction (SPME) tool was conditioned after desorbing a sample.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardSeparationMethod -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "For each member of Standards, a collection of inlet, column, and oven parameters that were used to perform the chromatographic separation after the sample has been injected.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardInletMode -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GCInletModeP,
			Relation -> Null,
			Description -> "For each member of Standards, whether the inlet was used in split, splitless, pulsed split, pulsed splitless, solvent vent, or direct injection mode.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardInletSeptumPurgeFlowRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Liter/Minute],
			Units -> Milli*Liter/Minute,
			Relation -> Null,
			Description -> "For each member of Standards, the flow rate of carrier gas that was passed through the inlet septum purge valve, which will continuously flush the volume inside the inlet between the inlet septum and the inlet liner.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardInitialInletTemperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Relation -> Null,
			Description -> "For each member of Standards, the desired inlet temperature prior to the Multimode inlet (MMI) temperature profile.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardInitialInletTemperatureDuration -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Standards, the amount of time into the method to hold the Multimode inlet (MMI) at its InitialInletTemperature before starting the MMI temperature Profile.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardInletTemperatureProfile -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[
				{{GreaterEqualP[0*Minute],GreaterP[0*Kelvin]}..},
				{{GreaterP[0*Kelvin/Minute],GreaterP[0*Kelvin],GreaterEqualP[0*Minute]}..},
				GreaterP[0*Kelvin],
				Isothermal
			],
			Relation -> Null,
			Description -> "For each member of Standards, describes how the inlet temperature will evolve as a function of time after injection of the sample into the inlet.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardSplitRatio -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of Standards, the ratio of flow rate out of the inlet vaporization chamber that passes into the inlet split vent to the flow rate out of the inlet vaporization chamber that passes into the capillary column (see Figure 3.1 in the ExperimentGasChromatography help file). This value is equal to the theoretical ratio of the amount of injected sample that will pass onto the column to the amount of sample that was eliminated from the inlet through the split valve.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardSplitVentFlowRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Liter/Minute],
			Units -> Milli*Liter/Minute,
			Relation -> Null,
			Description -> "For each member of Standards, the desired flow rate through the inlet that will exit the inlet through the inlet split vent during sample injection.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardSplitlessTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Standards, the amount of time the split valve will remain closed after injecting the sample into the injector.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardInitialInletPressure -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 PSI],
			Units -> PSI,
			Relation -> Null,
			Description -> "For each member of Standards, the desired split pulse pressure (in PSI gauge pressure) that was imparted during sample injection.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardInitialInletTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Standards, the amount of time the split inlet will impart a pressure pulse after the sample has been injected into the inlet.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardGasSaver -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of Standards, indicates whether the gas saver was used during the experiment. The gas saver reduces flow through the split vent during sample separation, reducing Helium consumption.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardGasSaverFlowRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Liter/Minute],
			Units -> Milli*Liter/Minute,
			Relation -> Null,
			Description -> "For each member of Standards, the desired gas flow rate that the total inlet flow was reduced to when the gas saver is activated.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardGasSaverActivationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Standards, the amount of time after the beginning of each run that the gas saver was activated.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardSolventEliminationFlowRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Liter/Minute],
			Units -> Milli*Liter/Minute,
			Relation -> Null,
			Description -> "For each member of Standards, the flow rate that was used to vent the solvent from the Multimode inlet (MMI) during a solvent vented injection.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardGCColumnMode -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GCColumnModeP,
			Relation -> Null,
			Description -> "For each member of Standards, the mode that the column will operate in during sample separation.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardInitialColumnFlowRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Liter/Minute],
			Units -> Milli*Liter/Minute,
			Relation -> Null,
			Description -> "For each member of Standards, the initial column gas flow rate setpoint.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardInitialColumnPressure -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 PSI],
			Units -> PSI,
			Relation -> Null,
			Description -> "For each member of Standards, the initial column pressure (in PSI gauge pressure) setpoint.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardInitialColumnAverageVelocity -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Centi*Meter /Second],
			Units -> Centi*Meter /Second,
			Relation -> Null,
			Description -> "For each member of Standards, the initial column average linear gas velocity setpoint.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardInitialColumnResidenceTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Standards, the initial column holdup time setpoint.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardInitialColumnSetpointDuration -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Standards, the amount of time into the method to hold the column at a specified initial column parameter (InitialColumnFlowRate, InitialColumnPressure, InitialColumnAverageVelocity, InitialColumnResidenceTime) before starting a pressure or flow rate profile.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardColumnPressureProfile -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[
				{{GreaterEqualP[0*Minute],GreaterP[0*PSI]}..},
				{{GreaterP[0*PSI/Minute],GreaterP[0*PSI],GreaterEqualP[0*Minute]}..},
				GreaterP[0*PSI],
				ConstantPressure
			],
			Relation -> Null,
			Description -> "For each member of Standards, the pressure ramping profile for the inlet that was run during sample separation in the column.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardColumnFlowRateProfile -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[
				{{GreaterEqualP[0*Minute],GreaterP[0*Milli*Liter/Minute]}..},
				{{GreaterP[0*Milli*Liter/Minute/Minute],GreaterP[0*Milli*Liter/Minute],GreaterEqualP[0*Minute]}..},
				GreaterP[0*Milli*Liter/Minute],
				ConstantFlowRate
			],
			Relation -> Null,
			Description -> "For each member of Standards, the flow rate ramping profile for the inlet that was run during sample separation in the column.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardOvenEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Standards, the time to dwell at the initial OvenTemperature before the instrument status is set to ready.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardInitialOvenTemperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Relation -> Null,
			Description -> "For each member of Standards, the desired column oven temperature setpoint prior to the column oven temperature Profile.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardInitialOvenTemperatureDuration -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Standards, the amount of time into the separation to hold the column oven at its OvenInitialTemperature before starting the column oven temperature Profile.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardOvenTemperatureProfile -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[
				{{GreaterEqualP[0*Minute],GreaterP[0*Kelvin]}..},
				{{GreaterP[0*Kelvin/Minute],GreaterP[0*Kelvin],GreaterEqualP[0*Minute]}..},
				{GreaterP[0*Kelvin],GreaterP[0*Minute]},
				Isothermal
			],
			Relation -> Null,
			Description -> "For each member of Standards, the temperature profile for the column oven that was run during sample separation in the column.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardPostRunOvenTemperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Relation -> Null,
			Description -> "For each member of Standards, the column oven set point temperature that will be applied once the separation is completed.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardPostRunOvenTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Standards, the amount of time to hold the column at its PostRunOvenTemperature and PostRunFlowRate/PostRunPressure once the separation is completed.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Abstract -> False
		},
		StandardPostRunFlowRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter/Minute],
			Units -> Milliliter/Minute,
			Relation -> Null,
			Description -> "For each member of Standards, the flow rate that will be flowed through the column once the separation is completed.",
			IndexMatching -> Standards,
			Category -> "General",
			Abstract -> False
		},
		StandardPostRunPressure -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 PSI],
			Units -> PSI,
			Relation -> Null,
			Description -> "For each member of Standards, the pressure that will be applied to the column once the separation is completed.",
			IndexMatching -> Standards,
			Category -> "General",
			Abstract -> False
		},
		StandardFrequency -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> (None | First | Last | FirstAndLast | MethodChange),
			Relation -> Null,
			Description -> "Specify the frequency at which Standard measurements were inserted among samples.",
			Category -> "Standards",
			Abstract -> False
		},

		IncludeBlanks -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "Indicates if samples were injected as negative controls for comparison to the samples and standards.",
			Category -> "Blanking"
		},
		Blanks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The reference compound(s) to inject into the instrument, often used for quantification or to check internal measurement consistency.",
			Category -> "Blanking",
			Abstract -> False
		},
		BlankVial -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of Blanks, the container in which the blank was prepared for injection.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankAmount -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Liter],
			Units -> Milli*Liter,
			Relation -> Null,
			Description -> "For each member of Blanks, the volume or mass of blank that was placed in the BlankVial during preparation for injection.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankDilute -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of Blanks, indicates whether or not the sample was diluted prior to sampling.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankDilutionSolventVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of Blanks, the volume to move from the DilutionSolvent vial into the sample vial.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankSecondaryDilutionSolventVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of Blanks, the volume to move from the SecondaryDilutionSolvent vial into the sample vial.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankTertiaryDilutionSolventVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of Blanks, the volume to move from the TertiaryDilutionSolvent vial into the sample vial.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankAgitate -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of Blanks, indicates whether or not the sample was mixed by swirling the container for a specified time at a specified rotational speed and temperature prior to sampling.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankAgitationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Blanks, the time that each sample was incubated in the agitator prior to analysis.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankAgitationTemperature -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[GreaterEqualP[0*Kelvin],Ambient],
			Relation -> Null,
			Description -> "For each member of Blanks, the temperature at which each sample was incubated at in the agitator prior to analysis.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankAgitationMixRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Relation -> Null,
			Description -> "For each member of Blanks, the rate (in RPM) at which each sample was swirled at in the agitator prior to analysis.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankAgitationOnTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of Blanks, the amount of time for which the agitator will swirl before switching directions.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankAgitationOffTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of Blanks, the amount of time for which the agitator will idle while switching directions.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankVortex -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of Blanks, indicates whether or not the sample was spun in place (vortexed) prior to sampling.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankVortexMixRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Relation -> Null,
			Description -> "For each member of Blanks, the rate (in RPM) at which the sample was vortexed in the vortex mixer prior to analysis.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankVortexTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of Blanks, the amount of time for which the sample was vortex mixed prior to analysis.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankSamplingMethod -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GCSamplingMethodP,
			Relation -> Null,
			Description -> "For each member of Blanks, the sampling method that was used to extract a mixture of analytes from the sample vial and inject those analytes into the injection port.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankHeadspaceSyringeTemperature -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[GreaterEqualP[0*Kelvin],Ambient],
			Relation -> Null,
			Description -> "For each member of Blanks, the temperature that the headspace syringe was held at during the sampling task.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankLiquidPreInjectionSyringeWash -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of Blanks, indicates whether the instrument will rinse the liquid injection syringe with any of the syringe wash solvents in an attempt to remove any impurities present prior to sample aspiration.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankLiquidPreInjectionSyringeWashVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of Blanks, the volume of the injection syringe to fill with wash solvent during each pre-injection syringe washing step.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankLiquidPreInjectionSyringeWashRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter/Second],
			Units -> Micro*Liter/Second,
			Relation -> Null,
			Description -> "For each member of Blanks, the aspiration rate that was used to draw and dispense liquid during the pre-injection syringe washing procedure.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankLiquidPreInjectionNumberOfSolventWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of Blanks, the number of washes to perform using WashSolvent during the pre-injection syringe washing procedure.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankLiquidPreInjectionNumberOfSecondarySolventWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of Blanks, the number of washes to perform using SecondaryWashSolvent during the pre-injection syringe washing procedure.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankLiquidPreInjectionNumberOfTertiarySolventWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of Blanks, the number of washes to perform using TertiaryWashSolvent during the pre-injection syringe washing procedure.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankLiquidPreInjectionNumberOfQuaternarySolventWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of Blanks, the number of washes to perform using QuaternaryWashSolvent during the pre-injection syringe washing procedure.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankLiquidSampleWash -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of Blanks, indicates whether the liquid injection syringe was flushed with sample prior to aspirating the sample InjectionVolume for injection.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankNumberOfLiquidSampleWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of Blanks, the number of washes to perform on the injection syringe using the sample during the pre-injection sample washing procedure.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankLiquidSampleWashVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of Blanks, the volume of the sample that was used to rinse the syringe during the pre-injection sample washing procedure.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankLiquidSampleFillingStrokes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of Blanks, the number of filling strokes to perform when drawing a sample for injection.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankLiquidSampleFillingStrokesVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of Blanks, the volume of the filling strokes to draw when drawing a sample for injection.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankLiquidFillingStrokeDelay -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of Blanks, the amount of time the injection tool will idle between filling strokes.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankHeadspaceSyringeFlushing -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of Blanks, whether a stream of Helium was flowed through the cylinder of the headspace syringe without interruption between injections (Continuous), or if Helium was flowed through the cylinder of the headspace syringe before and/or after sample aspiration for specified amounts of time.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankHeadspacePreInjectionFlushTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of Blanks, the amount of time the headspace tool will flow helium through the injection syringe (thus purging the syringe environment) before drawing a sample.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankSPMECondition -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of Blanks, indicates whether or not the Solid Phase MicroExtraction (SPME) tool was conditioned prior to sample adsorption.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankSPMEConditioningTemperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Relation -> Null,
			Description -> "For each member of Blanks, the temperature at which the Solid Phase MicroExtraction (SPME) fiber was treated in flowing Helium prior to exposure to the sample environment.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankSPMEPreConditioningTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Blanks, the amount of time the Solid Phase MicroExtraction (SPME) tool was conditioned before adsorbing a sample.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankSPMEDerivatizingAgent -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "For each member of Blanks, the on-fiber derivatizing agent to be used to modify the sample during sample adsorption.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankSPMEDerivatizingAgentAdsorptionTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Blanks, the amount of time the Solid Phase MicroExtraction (SPME) tool will adsorb the derivatizing agent before adsorbing a sample.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankSPMEDerivatizationPosition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GCVialPositionP,
			Relation -> Null,
			Description -> "For each member of Blanks, the position in the vial (Top or Bottom) at which the Solid Phase MicroExtraction (SPME) fiber was treated with the derivatizing agent during fiber preparation.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankSPMEDerivatizationPositionOffset -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Meter],
			Units -> Milli*Meter,
			Relation -> Null,
			Description -> "For each member of Blanks, the distance from the SPMEDerivatizationPosition at which the Solid Phase MicroExtraction (SPME) fiber was treated with the derivatizing agent during fiber preparation.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankAgitateWhileSampling -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of Blanks, indicates that the headspace sample was drawn while the sample is being agitated at the specified AgitationTemperature, AgitationRate, ...",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankSampleVialAspirationPosition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GCVialPositionP,
			Relation -> Null,
			Description -> "For each member of Blanks, the position in the vial (Top or Bottom) from which the sample was aspirated.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankSampleVialAspirationPositionOffset -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Meter],
			Units -> Milli*Meter,
			Relation -> Null,
			Description -> "For each member of Blanks, the distance of the tip of the injection syringe from the top or bottom of the sample vial (set by SampleVialAspirationPosition) during sample aspiration.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankSampleVialPenetrationRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Meter /Second],
			Units -> Milli*Meter /Second,
			Relation -> Null,
			Description -> "For each member of Blanks, the speed that the injection tool will penetrate the sample vial septum during sampling.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankInjectionVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of Blanks, the volume of sample to draw into the liquid or headspace tool sample syringe for introduction of the sample into the inlet.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankLiquidSampleOverAspirationVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of Blanks, the volume of air to draw into the liquid sample syringe after aspirating the sample.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankSampleAspirationRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter/Second],
			Units -> Micro*Liter/Second,
			Relation -> Null,
			Description -> "For each member of Blanks, the volumetric rate at which the sample was drawn during the sampling procedure.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankSampleAspirationDelay -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of Blanks, the amount of time the injection tool will idle after aspirating the sample to allow the pressures in the sample vial and syringe to equilibrate.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankSPMESampleExtractionTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Blanks, the amount of time the injection tool will leave the Solid Phase MicroExtraction (SPME) fiber in contact with the sample for adsorption of analytes onto the SPME fiber.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankInjectionInletPenetrationDepth -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Meter],
			Units -> Milli*Meter,
			Relation -> Null,
			Description -> "For each member of Blanks, the distance through the inlet septum that the injection tool will position the injection syringe tip during injection of the sample.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankInjectionInletPenetrationRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Meter /Second],
			Units -> Milli*Meter /Second,
			Relation -> Null,
			Description -> "For each member of Blanks, the speed that the injection tool will penetrate the inlet septum during injection of the sample.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankInjectionSignalMode -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (PlungerUp|PlungerDown),
			Relation -> Null,
			Description -> "For each member of Blanks, whether the instrument will start the run clock before or after the sample has been introduced into the vaporization chamber of the inlet (while the syringe has already been inserted into the inlet) during the injection.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankPreInjectionTimeDelay -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of Blanks, the amount of time the syringe was held in the inlet before the plunger is depressed and the sample is introduced into the inlet.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankSampleInjectionRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter/Second],
			Units -> Micro*Liter/Second,
			Relation -> Null,
			Description -> "For each member of Blanks, the injection rate that was used to dispense a fluid sample into the inlet during the sample injection procedure.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankSPMESampleDesorptionTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Blanks, the amount of time the injection tool will leave the Solid Phase MicroExtraction (SPME) fiber exposed in the inlet vaporization chamber.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankPostInjectionTimeDelay -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of Blanks, the amount of time the syringe was held in the inlet after the plunger has been completely depressed and before it is withdrawn from the inlet.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankLiquidPostInjectionSyringeWash -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of Blanks, indicates whether the instrument will rinse the liquid injection syringe with any of the syringe wash solvents in an attempt to remove any impurities present after sample injection.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankLiquidPostInjectionSyringeWashVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter/Second],
			Units -> Micro*Liter/Second,
			Relation -> Null,
			Description -> "For each member of Blanks, the volume of the injection syringe to fill with wash solvent during each post-injection syringe washing step.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankLiquidPostInjectionSyringeWashRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Micro*Liter/Second],
			Units -> Micro*Liter/Second,
			Relation -> Null,
			Description -> "For each member of Blanks, the aspiration rate that was used to draw and dispense liquid during the post-injection syringe washing procedure.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankLiquidPostInjectionNumberOfSolventWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of Blanks, the number of washes to perform using the syringeWashSolvent during the post-injection syringe washing procedure.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankLiquidPostInjectionNumberOfSecondarySolventWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of Blanks, the number of washes to perform using the SecondarySyringeWashSolvent during the post-injection syringe washing procedure.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankLiquidPostInjectionNumberOfTertiarySolventWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of Blanks, the number of washes to perform using the TertiarySyringeWashSolvent during the post-injection syringe washing procedure.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankLiquidPostInjectionNumberOfQuaternarySolventWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of Blanks, the number of washes to perform using the QuaternarySyringeWashSolvent during the post-injection syringe washing procedure.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankPostInjectionNextSamplePreparationSteps -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (NoSteps|SolventWash|SampleWash|SampleFillingStrokes|SampleAspiration),
			Relation -> Null,
			Description -> "For each member of Blanks, the sample preparation step up to which the autosampling arm proceeded (as described in Figures 3.5, 3.6, 3.7, and 3.10 in the ExperimentGasChromatography help file) to prepare to inject the next sample in the injection sequence prior to the completion of the separation of the sample that has just been injected. If NoSteps are specified, the autosampler will wait until a separation is complete to begin preparing the next sample in the injection queue.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankHeadspacePostInjectionFlushTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Relation -> Null,
			Description -> "For each member of Blanks, the amount of time the headspace tool will flow helium through the injection syringe (thus purging the syringe environment) after injecting a sample.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankSPMEPostInjectionConditioningTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Blanks, the amount of time the Solid Phase MicroExtraction (SPME) tool was conditioned after desorbing a sample.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankSeparationMethod -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "For each member of Blanks, a collection of inlet, column, and oven parameters that were used to perform the chromatographic separation after the sample has been injected.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankInletMode -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GCInletModeP,
			Relation -> Null,
			Description -> "For each member of Blanks, whether the inlet was used in split, splitless, pulsed split, pulsed splitless, solvent vent, or direct injection mode.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankInletSeptumPurgeFlowRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Liter/Minute],
			Units -> Milli*Liter/Minute,
			Relation -> Null,
			Description -> "For each member of Blanks, the flow rate of carrier gas that was passed through the inlet septum purge valve, which will continuously flush the volume inside the inlet between the inlet septum and the inlet liner.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankInitialInletTemperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Relation -> Null,
			Description -> "For each member of Blanks, the desired inlet temperature prior to the Multimode inlet (MMI) temperature profile.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankInitialInletTemperatureDuration -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Blanks, the amount of time into the method to hold the Multimode inlet (MMI) at its InitialInletTemperature before starting the MMI temperature Profile.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankInletTemperatureProfile -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[
				{{GreaterEqualP[0*Minute],GreaterP[0*Kelvin]}..},
				{{GreaterP[0*Kelvin/Minute],GreaterP[0*Kelvin],GreaterEqualP[0*Minute]}..},
				GreaterP[0*Kelvin],
				Isothermal
			],
			Relation -> Null,
			Description -> "For each member of Blanks, describes how the inlet temperature will evolve as a function of time after injection of the sample into the inlet.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankSplitRatio -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of Blanks, the ratio of flow rate out of the inlet vaporization chamber that passes into the inlet split vent to the flow rate out of the inlet vaporization chamber that passes into the capillary column (see Figure 3.1 in the ExperimentGasChromatography help file). This value is equal to the theoretical ratio of the amount of injected sample that will pass onto the column to the amount of sample that was eliminated from the inlet through the split valve.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankSplitVentFlowRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Liter/Minute],
			Units -> Milli*Liter/Minute,
			Relation -> Null,
			Description -> "For each member of Blanks, the desired flow rate through the inlet that will exit the inlet through the inlet split vent during sample injection.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankSplitlessTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Blanks, the amount of time the split valve will remain closed after injecting the sample into the injector.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankInitialInletPressure -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 PSI],
			Units -> PSI,
			Relation -> Null,
			Description -> "For each member of Blanks, the desired split pulse pressure (in PSI gauge pressure) that was imparted during sample injection.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankInitialInletTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Blanks, the amount of time the split inlet will impart a pressure pulse after the sample has been injected into the inlet.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankGasSaver -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of Blanks, indicates whether the gas saver was used during the experiment. The gas saver reduces flow through the split vent during sample separation, reducing Helium consumption.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankGasSaverFlowRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Liter/Minute],
			Units -> Milli*Liter/Minute,
			Relation -> Null,
			Description -> "For each member of Blanks, the desired gas flow rate that the total inlet flow was reduced to when the gas saver is activated.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankGasSaverActivationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Blanks, the amount of time after the beginning of each run that the gas saver was activated.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankSolventEliminationFlowRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Liter/Minute],
			Units -> Milli*Liter/Minute,
			Relation -> Null,
			Description -> "For each member of Blanks, the flow rate that was used to vent the solvent from the Multimode inlet (MMI) during a solvent vented injection.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankGCColumnMode -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GCColumnModeP,
			Relation -> Null,
			Description -> "For each member of Blanks, the mode that the column will operate in during sample separation.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankInitialColumnFlowRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Liter/Minute],
			Units -> Milli*Liter/Minute,
			Relation -> Null,
			Description -> "For each member of Blanks, the initial column gas flow rate setpoint.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankInitialColumnPressure -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 PSI],
			Units -> PSI,
			Relation -> Null,
			Description -> "For each member of Blanks, the initial column pressure (in PSI gauge pressure) setpoint.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankInitialColumnAverageVelocity -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Centi*Meter /Second],
			Units -> Centi*Meter /Second,
			Relation -> Null,
			Description -> "For each member of Blanks, the initial column average linear gas velocity setpoint.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankInitialColumnResidenceTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Blanks, the initial column holdup time setpoint.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankInitialColumnSetpointDuration -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Blanks, the amount of time into the method to hold the column at a specified initial column parameter (InitialColumnFlowRate, InitialColumnPressure, InitialColumnAverageVelocity, InitialColumnResidenceTime) before starting a pressure or flow rate profile.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankColumnPressureProfile -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[
				{{GreaterEqualP[0*Minute],GreaterP[0*PSI]}..},
				{{GreaterP[0*PSI/Minute],GreaterP[0*PSI],GreaterEqualP[0*Minute]}..},
				GreaterP[0*PSI],
				ConstantPressure
			],
			Relation -> Null,
			Description -> "For each member of Blanks, the pressure ramping profile for the inlet that was run during sample separation in the column.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankColumnFlowRateProfile -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[
				{{GreaterEqualP[0*Minute],GreaterP[0*Milli*Liter/Minute]}..},
				{{GreaterP[0*Milli*Liter/Minute/Minute],GreaterP[0*Milli*Liter/Minute],GreaterEqualP[0*Minute]}..},
				GreaterP[0*Milli*Liter/Minute],
				ConstantFlowRate
			],
			Relation -> Null,
			Description -> "For each member of Blanks, the flow rate ramping profile for the inlet that was run during sample separation in the column.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankOvenEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Blanks, the time to dwell at the initial OvenTemperature before the instrument status is set to ready.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankInitialOvenTemperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Relation -> Null,
			Description -> "For each member of Blanks, the desired column oven temperature setpoint prior to the column oven temperature Profile.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankInitialOvenTemperatureDuration -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Blanks, the amount of time into the separation to hold the column oven at its OvenInitialTemperature before starting the column oven temperature Profile.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankOvenTemperatureProfile -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[
				{{GreaterEqualP[0*Minute],GreaterP[0*Kelvin]}..},
				{{GreaterP[0*Kelvin/Minute],GreaterP[0*Kelvin],GreaterEqualP[0*Minute]}..},
				{GreaterP[0*Kelvin],GreaterP[0*Minute]},
				Isothermal
			],
			Relation -> Null,
			Description -> "For each member of Blanks, the temperature profile for the column oven that was run during sample separation in the column.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankPostRunOvenTemperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Relation -> Null,
			Description -> "For each member of Blanks, the column oven set point temperature that will be applied once the separation is completed.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankPostRunOvenTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "For each member of Blanks, the amount of time to hold the column at its PostRunOvenTemperature and PostRunFlowRate/PostRunPressure once the separation is completed.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Abstract -> False
		},
		BlankPostRunFlowRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter/Minute],
			Units -> Milliliter/Minute,
			Relation -> Null,
			Description -> "For each member of Blanks, the flow rate that will be flowed through the column once the separation is completed.",
			IndexMatching -> Blanks,
			Category -> "General",
			Abstract -> False
		},
		BlankPostRunPressure -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 PSI],
			Units -> PSI,
			Relation -> Null,
			Description -> "For each member of Blanks, the pressure that will be applied to the column once the separation is completed.",
			IndexMatching -> Blanks,
			Category -> "General",
			Abstract -> False
		},
		BlankFrequency -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> (None | First | Last | FirstAndLast | MethodChange),
			Relation -> Null,
			Description -> "Specify the frequency at which Blank measurements were inserted among samples.",
			Category -> "Blanking",
			Abstract -> False
		},

		(*Injection Table*)
		InjectionTable -> {
			Format->Multiple,
			Class->{
				Type->Expression,
				Sample->Link,
				SamplingMethod->Expression,
				SamplePreparationOptions->Expression,
				SeparationMethod->Link,
				Data->Link
			},
			Pattern:>{
				Type->InjectionTableP,
				Sample->_Link,
				SamplingMethod->GCSamplingMethodP,
				SamplePreparationOptions->GCSamplePreparationOptionsP,
				SeparationMethod->_Link,
				Data->_Link
			},
			Relation->{
				Type->Null,
				Sample->Alternatives[Object[Sample],Model[Sample]],
				SamplingMethod->Null,
				SamplePreparationOptions->Null,
				SeparationMethod->Object[Method],
				Data->Object[Data]
			},
			Units->{
				Type->Null,
				Sample->None,
				SamplingMethod->None,
				SamplePreparationOptions->None,
				SeparationMethod->None,
				Data->None
			},
			Description -> "The order of Sample, Standard, and Blank sample loading into the Instrument during measurement.",
			Category -> "Injection",
			Abstract -> False
		},

		(* Caps *)
		SampleCaps -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, Cap], Model[Item, Cap]],
			Description -> "The threaded plastic/metal parts that were used to seal the samples inside their sample vials.",
			Category -> "General"
		},
		StandardCaps -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, Cap], Model[Item, Cap]],
			Description -> "The threaded plastic/metal parts that were used to seal the standards inside their sample vials.",
			Category -> "General"
		},
		BlankCaps -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, Cap], Model[Item, Cap]],
			Description -> "The threaded plastic/metal parts that were used to seal the blanks inside their sample vials.",
			Category -> "General"
		},
		SolventContainerCaps -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, Cap], Model[Item, Cap]],
			Description -> "The threaded plastic/metal parts that were used to seal the SPME derivatization agents inside their sample vials.",
			Category -> "General"
		},

		(* Instrument setup fields *)
		ReplaceColumn -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "Indicates if the currently installed column was changed during the protocol.",
			Category -> "General",
			Developer -> True
		},
		ChangeColumnInletConnection -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "Indicates if the currently installed column was moved to a different inlet on the instrument during to protocol.",
			Category -> "General",
			Developer -> True
		},
		ChangeColumnOutletConnection -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "Indicates if the currently installed column was moved to a different detector during the protocol.",
			Category -> "General",
			Developer -> True
		},
		GuardColumn -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item,Column],
				Object[Item,Column]
			],
			Description -> "Describes the length of deactivated column that was inserted into the flow path on the inlet end of the column, often used to protect the analytical column from fouling over the course of many injections.",
			Category -> "General"
		},
		WaitForColumnAvailability -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "Indicates if the protocol is currently waiting for an unavailable installed column to become available.",
			Category -> "General",
			Developer -> True
		},
		BlockingInstruments -> {
					Format -> Multiple,
					Class -> Link,
					Pattern :> _Link,
					Relation -> Alternatives[
						Model[Instrument,GasChromatograph],
						Object[Instrument,GasChromatograph]
					],
					Description -> "The gas chromatograph(s) that contain(s) columns required to complete this protocol.",
					Category -> "General",
					Abstract -> False,
			Developer -> True
				},
		ChangeIonSource -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "Indicates if the currently installed ion source was changed during the protocol.",
			Category -> "General",
			Developer -> True
		},
		CoolMassSpectrometer -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "Indicates if the mass spectrometer was cooled during the protocol.",
			Category -> "General",
			Developer -> True
		},
		VentMassSpectrometer -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "Indicates if the mass spectrometer was cooled during the protocol.",
			Category -> "General",
			Developer -> True
		},
		PumpDownMassSpectrometer -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "Indicates if the mass spectrometer was pumped down after being vented during the protocol.",
			Category -> "General",
			Developer -> True
		},
		MassSpectrometerPumpDownTime -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "The length of time for which the mass spectrometer was pumped down after being vented.",
			Category -> "General",
			Developer -> True
		},
		SeptumPlacement -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {Object[Item,Septum],Null},
			Description -> "Location to place the injection port septum on the gas chromatograph used for the separation.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object","Placement Tree"}
		},
		LinerPlacement -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {Object[Item,GCInletLiner],Null},
			Description -> "Location to place the inlet liner on the gas chromatograph used for the separation.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object","Placement Tree"}
		},
		ORingPlacement -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {Object[Item,ORing],Null},
			Description -> "Location to place the inlet liner o-ring on the gas chromatograph used for the separation.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object","Placement Tree"}
		},

		(* carryover installed hardware *)
		InstalledSeptum -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item,Septum],
			Description -> "The septum that is currently installed in the instrument, and must be removed and discarded.",
			Category -> "General"
		},
		InstalledORing -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item,ORing],
			Description -> "The O-ring that is currently installed in the instrument, and must be removed and discarded.",
			Category -> "General"
		},
		InstalledLiner -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item,GCInletLiner],
			Description -> "The inlet liner that is currently installed in the instrument, and must be removed and discarded.",
			Category -> "General"
		},
		InstalledColumnComponents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item,Column],
				Object[Plumbing,ColumnJoin]
			],
			Description -> "The column components that are currently installed in the instrument, and must be removed and stored.",
			Category -> "General"
		},

		(* column connections *)
		OldColumnInletConnection -> {
			Format -> Multiple,
			Class -> {Link,String,Link,String},
			Pattern :> {_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation -> {Object[Instrument],Null,Object[Item,Column],Null},
			Description -> "The connection information for detaching the column assembly inlet currently in the GC column oven.",
			Headers -> {"Instrument","Instrument Connector Name","Column","Column End"},
			Category -> "Column Installation",
			Developer -> True
		},
		OldColumnDetectorConnection -> {
			Format -> Multiple,
			Class -> {Link,String,Link,String},
			Pattern :> {_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation -> {Object[Instrument],Null,Object[Item,Column],Null},
			Description -> "The connection information for detaching the column assembly at the currently in the GC column oven.",
			Headers -> {"Instrument","Instrument Connector Name","Column","Column End"},
			Category -> "Column Installation",
			Developer -> True
		},
		NewColumnInletConnection -> {
			Format -> Multiple,
			Class -> {Link,String,Link,String},
			Pattern :> {_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation -> {Object[Instrument],Null,Object[Item,Column],Null},
			Description -> "The connection information for attaching the new column assembly to the GC column oven.",
			Headers -> {"Instrument","Instrument Connector Name","Column","Column End"},
			Category -> "Column Installation",
			Developer -> True
		},
		NewColumnDetectorConnection -> {
			Format -> Multiple,
			Class -> {Link,String,Link,String},
			Pattern :> {_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation -> {Object[Instrument],Null,Object[Item,Column],Null},
			Description -> "The connection information for attaching the new column assembly to the GC column oven.",
			Headers -> {"Instrument","Instrument Connector Name","Column","Column End"},
			Category -> "Column Installation",
			Developer -> True
		},
		OldColumnJoinDisconnections -> {
			Format -> Multiple,
			Class -> {Link,String,Link,String},
			Pattern :> {_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation -> {Object[Instrument],Null,Object[Item,Column],Null},
			Description -> "The connection information for disassembling the old column assembly.",
			Headers -> {"Column Join","Join Connector","Column","Column End"},
			Category -> "Column Installation",
			Developer -> True
		},
		ColumnJoinConnections -> {
			Format -> Multiple,
			Class -> {Link,String,Link,String},
			Pattern :> {_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation -> {Object[Instrument],Null,Object[Item,Column],Null},
			Description -> "The connection information for assembling the column assembly.",
			Headers -> {"Column Join","Join Connector","Column","Column End"},
			Category -> "Column Installation",
			Developer -> True
		},

		(* column pieces *)
		InstalledColumnNuts -> {
			Format -> Multiple,
			Class -> {Link,Link,String},
			Pattern :> {
				_Link,
				_Link,
				ConnectorNameP
			},
			Relation -> {
				Alternatives[Object[Part,Nut], Model[Part,Nut]],
				(Object[Item,Column]|Model[Item,Column]),
				Null
			},
			Description -> "A list containing the column nuts installed, the columns onto which they were installed, and the end of the column onto which each nut was installed.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Installed Nut","Column","Column End"}
		},
		InstalledColumnFerrules -> {
			Format -> Multiple,
			Class -> {Link,Real,Link,String},
			Pattern :> {
				_Link,
				GreaterP[0*Milli*Meter],
				_Link,
				ConnectorNameP
			},
			Relation -> {Alternatives[Object[Part,Ferrule], Model[Part,Ferrule]],Null,(Object[Item,Column]|Model[Item,Column]),Null},
			Units -> {None,Milli*Meter,None,None},
			Description -> "List of column ferrules installed, the column onto which each column fitting was installed, which end of the column onto which it was installed, and the distance from the end of the tube at which each ferrule was installed.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Installed Ferrule","Ferrule Offset","Column","Column End"}
		},
		InstalledColumnJoins -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Object[Plumbing,ColumnJoin]|Model[Plumbing,ColumnJoin]),
			Description -> "List of column joins installed in the order in which they are installed.",
			Category -> "General",
			Developer -> True
		},
		ColumnAssembly -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Description -> "All column components in their order along the flow path of the installed column.",
			Relation -> Alternatives[
				Object[Item,Column],
				Model[Item,Column],
				Object[Plumbing,ColumnJoin],
				Model[Plumbing,ColumnJoin]
			],
			Category -> "General"
		},
		InstalledColumnFittings -> {
			Format -> Multiple,
			Class -> {Link,String,Real,Link,Link,Real},
			Pattern :> {
				_Link,
				ConnectorNameP,
				GreaterEqualP[0*Meter],
				_Link,
				_Link,
				GreaterEqualP[0*Meter]
			},
			Relation -> {Object[Item,Column]|Model[Item,Column],Null,Null,Object[Part,Nut]|Model[Part,Nut],Object[Part,Ferrule]|Model[Part,Ferrule],Null},
			Units -> {None,None,Centi*Meter,None,None,Milli*Meter},
			Description -> "A list of the column fittings installed, the object and connector upon which they were installed, the offset of the ferrule (if applicable) at its installation point, and the amount of column that was trimmed during the fitting installation.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object","Connector Name","Trim Length","Installed Nut","Installed Ferrule","Ferrule Offset"}
		},
		UninstalledNuts -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part,Nut], Model[Part,Nut]],
			Description -> "A list containing the column nuts uninstalled during this protocol.",
			Category -> "General",
			Developer -> True
		},

		(* parts to grab *)
		GCMSTackleBox -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The tackle box that contains all the tiny pieces required for GCMS experiments. This object must be resource picked at the beginning of the experiment so that we can resource pick all the parts we need later.",
			Category -> "General",
			Developer->True
		},
		ColumnTrimmingTool -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item]|Model[Item],
			Description -> "The tool that was used to trim the column during this procedure.",
			Category -> "General",
			Developer->True
		},
		ColumnSwagingTool -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item]|Model[Item],
			Description -> "The tool that was used to pre-swage the column fittings during this procedure.",
			Category -> "General",
			Developer->True
		},
		MSDSwagingTool -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item]|Model[Item],
			Description -> "The tool that was used to pre-swage the MSD connector fittings during this procedure.",
			Category -> "General",
			Developer->True
		},
		GreenSeptum -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item]|Model[Item],
			Description -> "The green septum that was added the GC column, indicating the column inlet.",
			Category -> "General",
			Developer->True
		},
		RedSeptum -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item]|Model[Item],
			Description -> "The red septum that was added to the GC column, indicating the column outlet.",
			Category -> "General",
			Developer->True
		},

		(*--Autosampler information--*)

		AvailableLiquidSyringeTool -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The liquid injection syringe tool on the autosampler at the time of the experiment.",
			Category -> "General",
			Developer -> True
		},
		AvailableHeadspaceSyringeTool -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The headspace injection syringe tool on the autosampler at the time of the experiment.",
			Category -> "General",
			Developer -> True
		},
		AvailableSPMEFiberTool -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The SPME injection fiber tool on the autosampler at the time of the experiment.",
			Category -> "General",
			Developer -> True
		},
		AvailableLiquidHandlingTool -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The liquid handling syringe tool on the autosampler at the time of the experiment.",
			Category -> "General",
			Developer -> True
		},
		LiquidInjectionToolPlacement -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {Object[Container],Null},
			Description -> "Location to place the liquid injection tool on the autosampler deck.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object","Placement Tree"}
		},
		HeadspaceInjectionToolPlacement -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {Object[Container],Null},
			Description -> "Location to place the headspace injection tool on the autosampler deck.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object","Placement Tree"}
		},
		SPMEInjectionToolPlacement -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {Object[Container],Null},
			Description -> "Location to place the SPME injection tool on the autosampler deck.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object","Placement Tree"}
		},
		LiquidHandlingToolPlacement -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {Object[Container],Null},
			Description -> "Location to place the liquid handling tool on the autosampler deck.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object","Placement Tree"}
		},
		AutosamplerSamplePlacements -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {Object[Container],Null},
			Description -> "List of autosampler sample placements.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object","Placement Tree"}
		},
		AutosamplerVialSizeConfiguration -> {
			Format -> Multiple,
			Class -> {Integer,Expression},
			Pattern :> {RangeP[1, 6, 1],Tall|Short|Normal},
			Relation -> {Null,Null},
			Description -> "List of autosampler rack vial size configurations, indicating the form of container that will be placed in each autosampler rack.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Rack Index","Container Form"}
		},

		AutosamplerDilutionSolventPlacements -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {Alternatives[Object[Container],Object[Sample]],Null},
			Description -> "List of autosampler dilution solvent placements.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object","Placement Tree"}
		},
		AutosamplerWashSolventPlacements -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {Alternatives[Object[Container],Object[Sample]],Null},
			Description -> "List of autosampler wash solvent placements.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object","Placement Tree"}
		},
		AutosamplerSPMEDerivatizingAgentPlacements -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {Alternatives[Object[Container],Object[Sample]],Null},
			Description -> "List of autosampler SPME derivatizing agent placements.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object","Placement Tree"}
		},
		AutosamplerScripts -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the autosampler script file(s) informing sample preparation and injection parameters that were used in this experiment.",
			Category -> "General",
			Developer -> True
		},

		(* --- Files used by the GC computer --- *)

		SequenceName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the sequence file specifying which samples were injected.",
			Category -> "General",
			Developer -> True
		},
		SequenceDirectory -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The directory for the sequence file.",
			Category -> "General",
			Developer -> True
		},
		TuneExportFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The file path for the exporter used to move the tune file.",
			Category -> "General",
			Developer -> True
		},
		TuneFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The file path for the tune file.",
			Category -> "General",
			Developer -> True
		},

		MethodNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the method file(s) informing sample injection parameters that were used by the experiment.",
			Category -> "General",
			Developer -> True
		},
		MethodDirectory -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The directory for the method files.",
			Category -> "General",
			Developer -> True
		},

		DataFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The paths of all the data files produced by this experiment.",
			Category -> "General",
			Developer -> True
		},

		(* --- Fraction Collection -- we won't do any prep-GC for now...stay tuned! --- *)

		(* --- Experimental Results --- *)

		DataMacroPath -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The file path for the data export macro to be executed that will convert all the collected data into unencrypted formats.",
			Category -> "General",
			Developer -> True
		},
		DataExportMacro -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The macro execution code that will cause chemstation to analyze and export all the data from the acquired data set.",
			Category -> "Experimental Results",
			Developer -> True
		},
		ExportDirectory -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The directory to which data was saved.",
			Category -> "Experimental Results",
			Developer -> True
		},
		ExportScriptLocation -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The compiled file that exports the protocol's raw data to the server.",
			Category -> "Experimental Results",
			Developer -> True
		},
		StandardData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The chromatography traces generated for the standard's injection.",
			Category -> "Experimental Results"
		},
		BlankData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The chromatography traces generated for the blank's injection.",
			Category -> "Experimental Results"
		},

		(* Metadata for gases, hydrogen generator water *)
		InitialHeliumPressure -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The pressure data of the Helium gas source before starting the experiment.",
			Category -> "General"
		},
		InitialMethanePressure -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The pressure data of the Methane gas source before starting the experiment.",
			Category -> "General"
		},
		FinalHeliumPressure -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The pressure data of the Helium gas source after finishing the experiment.",
			Category -> "General"
		},
		FinalMethanePressure -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The pressure data of the Methane gas source after finishing the experiment.",
			Category -> "General"
		},
		InitialHydrogenGeneratorWaterWeight -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The pressure data of the Methane gas source before starting the experiment.",
			Category -> "General"
		},
		FinalHydrogenGeneratorWaterWeight -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The pressure data of the Helium gas source after finishing the experiment.",
			Category -> "General"
		},

		(* Shutdown method *)

		ShutdownMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The method used to shut down the instrument after the experiment has completed or in case of an Instrument error.",
			Category -> "General",
			Developer -> True
		},
		ShutdownFilename -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The specific filename used to employ the ShutdownMethod.",
			Category -> "General",
			Developer -> True
		},

		(*--- Et cetera ---*)

		SeparationTime -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterP[0*Second], (*this is changed from _?TimeQ*)
			Description -> "The estimated completion time for the protocol.",
			Category -> "General",
			Developer -> True
		}

	}
}];
