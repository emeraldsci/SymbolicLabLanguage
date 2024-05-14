(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation, ICPMS], {
	Description->"A detailed set of parameters that specifies a single mass spectrometry measurement inside a ICPMS protocol.",
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
				Model[Container],
				Object[Container]
			],
			Description -> "The sample which its ICP-MS spectrum been collected during this unit operation.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The sample which its ICP-MS spectrum been collected during this unit operation.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}] | _String},
			Relation -> Null,
			Description -> "The sample which its ICP-MS spectrum been collected during this unit operation.",
			Category -> "General",
			Migration -> SplitField
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument,MassSpectrometer],
				Model[Instrument,MassSpectrometer]
			],
			Description->"Instrument which is used to atomize, ionize and analyze the elemental composition of the input analyte.",
			Category -> "General"
		},
		StandardType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[External, StandardAddition, None],
			Description->"Select whether external standard, standard addition or no standard will be used for quantification. StandardAddition are known concentrations of analytes at a given mass that are mixed into the sample prior to introduction into the instrument. External standards are secondary samples of known analytes and concentrations that are injected and measured separately with the instrument.",
			Category -> "Standards"
		},
		Digestion -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SampleLink,
			Description->"For each member of SampleLink, Indicates if microwave digestion is performed on the samples in order to fully dissolve the elements into the liquid matrix before injecting into the mass spectrometer.",
			Category -> "Digestion",
			IndexMatching -> SampleLink
		},
		SampleType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Organic, Inorganic, Tablet, Biological],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, Specifies if the sample is primarily composed of organic material (solid or liquid), inorganic material (solid or liquid), is a tablet formulation, or is biological in origin, such as tissue culture or cell culture sample.",
			Category -> "Digestion"
		},
		DigestionInstrument -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, Reactor, Microwave],
				Model[Instrument, Reactor, Microwave]
			],
			Description -> "The reactor used to perform the microwave digestion.",
			Category -> "Digestion"
		},
		SampleDigestionAmount -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterP[0 Milligram], GreaterP[0 Microliter]],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The amount of sample that is mixed with DigestionAgents to fully solublize any solid components.",
			Category -> "Digestion"
		},
		CrushSample -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, Indicates if the tablet is crushed to a powder prior to mixing with DigestionAgents.",
			Category -> "Digestion"
		},
		PreDigestionMix -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, Indicates if the reaction mixture is stirred at ambient temperature directly prior to being subjected to microwave heating. Pre-mixing can ensure that a sample is fully dissolved or suspended prior to heating.",
			Category -> "Digestion"
		},
		PreDigestionMixTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The amount of time for which the reaction mixture is stirred at ambient temperature directly prior to being subjected to microwave heating.",
			Category -> "Digestion"
		},
		PreDigestionMixRate -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[None, Low, Medium, High],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The rate at which the reaction mixture is stirred at ambient temperature directly prior to being subjected to microwave heating.",
			Category -> "Digestion"
		},
		PreparedPreDigestionSample -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, Indicates if the member of SampleIn is already mixed with an appropriate digestion agent. Setting PreparedSample -> True will change the upper limit on the SampleAmount to 20 mL, allowing it to occupy the full volume of the microwave vessel.",
			Category -> "Digestion"
		},
		DigestionAgents -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{ObjectP[Model[Sample]], VolumeP}...},
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The volume and identity of the digestion agents used to digest and dissolve the SamplesIn.",
			Category -> "Digestion"
		},
		DigestionAgentsResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The volume and identity of the digestion agents used to digest and dissolve the SamplesIn.",
			Category -> "Digestion"
		},
		DigestionTemperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> TemperatureP,
			Units -> Celsius,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The temperature to which the sample is heated for the duration of the DigestionDuration.",
			Category -> "Digestion"
		},
		DigestionDuration -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The amount of time for which the sample is incubated at the set DigestionTemperature during digestion.",
			Category -> "Digestion"
		},
		DigestionRampDuration -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The amount of time taken for the sample chamber temperature from ambient temperature to reach the DigestionTemperature.",
			Category -> "Digestion"
		},
		DigestionTemperatureProfile -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern:> {{TimeP, TemperatureP}...},
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The heating profile for the reaction mixture in the form {{Time, Target Temperature}..}. Consecutive entries with different temperatures result in a linear ramp between the temperatures, while consecutive entries with the same temperature indicate an isothermal region at the specified temperature.",
			Category -> "Digestion"
		},
		DigestionMixRateProfile -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern:> {{TimeP, Alternatives[Low, Medium, High]}...} | Low | Medium | High,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The relative rate of the magnetic stir bar rotation that will be used to mix the sample, either for the duration of the digestion (fixed), or from the designated time point to the next time point (variable). For safety reasons, the sample must be mixed during microwave heating.",
			Category -> "Digestion"
		},
		DigestionMaxPower -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Watt],
			Units -> Watt,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The maximum power of the microwave radiation output that will be used during heating.",
			Category -> "Digestion"
		},
		DigestionMaxPressure -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 PSI],
			Units -> PSI,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The pressure at which the magnetron will cease to heat the reaction vessel. If the vessel internal pressure exceeds 500 PSI, the instrument will cease heating regardless of this option.",
			Category -> "Digestion"
		},
		DigestionPressureVenting -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The pressure at which the magnetron will cease to heat the reaction vessel. If the vessel internal pressure exceeds 500 PSI, the instrument will cease heating regardless of this option.",
			Category -> "Digestion"
		},
		DigestionPressureVentingTriggers -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{PressureP, _Integer}...},
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The set point pressures at which venting will begin, and the number of times that the system will vent the vessel in an attempt to reduce the pressure by the value of TargetPressureReduction. If the pressure set points are not reached, no venting will occur. Be aware that excessive venting may result in sample evaporation, leading to dry out of sample, loss of sample and damage of reaction vessel.",
			Category -> "Digestion"
		},
		DigestionTargetPressureReduction -> {
			Format -> Multiple,
			Class -> Real,
			Pattern:> GreaterEqualP[1 PSI],
			Units -> PSI,
			Description -> "For each member of SampleLink, For each member of SamplesIn, the desired reduction in pressure during sample venting.",
			Category -> "Digestion",
			IndexMatching -> SampleLink
		},
		DigestionOutputAliquotReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern:> GreaterP[0 Milliliter],
			Units -> Milliliter,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, Indicates if the OutputAliquot is added to a specified volume (DiluentVolume) of Diluent prior to storage or use in subsequent experiments. Dilution reduces the risk and cost associated with storage of caustic/oxidizing reagents commonly employed in digestion protocols.",
			Category -> "Digestion",
			Migration -> SplitField
		},
		DigestionOutputAliquotExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern:> Alternatives[All],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, Indicates if the OutputAliquot is added to a specified volume (DiluentVolume) of Diluent prior to storage or use in subsequent experiments. Dilution reduces the risk and cost associated with storage of caustic/oxidizing reagents commonly employed in digestion protocols.",
			Category -> "Digestion",
			Migration -> SplitField
		},
		DiluteDigestionOutputAliquot -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, Indicates if the OutputAliquot is added to a specified volume (DiluentVolume) of Diluent prior to storage or use in subsequent experiments. Dilution reduces the risk and cost associated with storage of caustic/oxidizing reagents commonly employed in digestion protocols.",
			Category -> "Digestion"
		},
		PostDigestionDiluent -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The solution used to dilute the OutputAliquot of the digested sample.",
			Category -> "Digestion"
		},
		PostDigestionDiluentVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> VolumeP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The volume of diluent into which the OutputAliquot will be added.",
			Category -> "Digestion"
		},
		PostDigestionDilutionFactor -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[1],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The desired dilution factor for this mixture.",
			Category -> "Digestion"
		},
		PostDigestionSampleVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> VolumeP,
			Units -> Milliliter,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The volume of output sample after DigestionOutputAliquot has been removed, and subsequently been diluted by the DiluentVolume of the provided Diluent sample.",
			Category -> "Digestion"
		},
		DigestionContainerOutLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Vessel], Object[Container, Vessel]],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The container model into which the OutputAliquotVolume or dilutions thereof is placed as the output of digestion.",
			Category -> "Digestion",
			Migration -> SplitField
		},
		DigestionContainerOutString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			IndexMatching -> SampleLink,
			Migration -> SplitField,
			Description -> "For each member of SampleLink, The container into which the OutputAliquotVolume or dilutions thereof is placed as the output of digestion. If StandardType is set to Internal, the sample will be subjected to internal standard addition before injecting into ICPMS instrument, otherwise the sample will be directly injected to ICPMS instrument.",
			Category -> "Digestion"
		},
		SampleAmount -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> VolumeP,
			Units -> Microliter,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The amount of sample that is loaded into the ICPMS instrument for measurement, after all sample preparation procedures but before adding any InternalStandard and/or AdditionStandard.",
			Category -> "Sample Loading"
		},
		SampleLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the Sample for use in downstream unit operations.",
			Category -> "General"
		},
		SampleContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the containers of sample for use in downstream unit operations.",
			Category -> "General"
		},
		InternalStandard -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description->"Standard sample that is added to all samples, including standards, blanks and user-provided samples. InternalStandard contains elements which do not exist in any other samples, and which its detector response is measured along with other Elements to account for matrix effects and instrument drift.",
			Category -> "Standard"
		},
		InternalStandardMixRatio -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Description->"Volume ratio of InternalStandard to each sample.",
			Category -> "Standard"
		},
		Blank -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description->"Sample containing no analyte used to measure the background levels of any ions in the matrix.",
			Category -> "Blank"
		},
		Rinse -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description->"Determine whether rinse of inlet line is performed after a set number of samples.",
			Category -> "Flushing"
		},
		RinseInterval -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1],
			Description->"Indicates how many samples is run between each rinse.",
			Category -> "Flushing"
		},
		RinseSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description->"Solution for the autosampler to draw between each run to flush the system.",
			Category -> "Flushing"
		},
		RinseTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description->"Duration of time for each rinse.",
			Category -> "Flushing"
		},
		InjectionDuration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description->"Duration of the input sample being continuously injected into the instrument for each measurement.",
			Category ->"Sample Loading"
		},
		InjectionPumpSpeed -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description->"Peristaltic pump speed for drawing the liquid sample into the injector.",
			Category -> "Sample Loading"
		},
		SprayChamberTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description->"Temperature setting in the nebulizer spray chamber.",
			Category -> "Sample Loading"
		},
		ConeDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description->"Indicates diameter of the opening of vacuum interface cone. High cone diameter will allow more plasma into the vacuum chamber for analysis. For higher concentration analyte low cone diameter should be used to block more interferences to minimize noise, while for lower concentration analyte high cone diameter should be used to allow more plasma in to maximize signal.",
			Category -> "Method Information"
		},
		QuantifyElements -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Select whether concentration of individual isotopes should be calculated and presented in the result, instead of elements. This option is only valid if StandardType is set to either External or StandardAddition.",
			Category -> "Method Information"
		},
		IsotopeAbundanceThreshold -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Percent, 50 Percent],
			Units -> Percent,
			Description->"Select threshold so that isotopes whose abundance is above this value will be selected for detection besides the most abundant one. This option is only valid when Elements -> Automatic or a list of elements, will be ignored when list of isotopes is provided as entry for Elements option.",
			Category -> "Method Information"
		},
		Elements -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Alternatives @@ Join[List @@ ICPMSElementP, List @@ ICPMSNucleusP]],
			Description->"Nuclei or element to be quantified by tuning the quadrupole to select the mass of the element that matches the atomic weight. When elements are selected, only the most abundant isotope will be quantified. If Elements is set to Sweep then a full spectrum will be acquired.",
			Category -> "Method Information"
		},
		PlasmaPower -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Low, Normal],
			IndexMatching -> Elements,
			Description->"For each member of Elements, Electric power of the coil generating the Ar-ion plasma flowing through the torch.",
			Category -> "Ionization"
		},
		CollisionCellPressurization -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> Elements,
			Description->"For each member of Elements, Indicate if the collision cell should be pressurized. If the collision cell is pressurized, gas inside will collide with the analyte ions as the ion pass through it. Since polyatomic ions are larger than monoatomic ions they are more likely to collide with the gas, and therefore been blocked from entry of the quadrupole. See Figure X1 for more details.",
			Category -> "Method Information"
		},
		CollisionCellGas -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ICPMSCollisionCellGasP,
			IndexMatching -> Elements,
			Description->"For each member of Elements, Indicate which gas type collision cell should be pressurized.",
			Category -> "Method Information"
		},
		CollisionCellGasFlowRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Milliliter)/Minute],
			Units -> Milliliter/Minute,
			IndexMatching -> Elements,
			Description->"For each member of Elements, Indicates the flow rate of gas through collision cell. Refer to Figure X.",
			Category -> "Method Information"
		},
		CollisionCellBias -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> Elements,
			Description->"For each member of Elements, Indicates if bias voltage for collision cell is turned on. Refer to Figure X.",
			Category -> "Method Information"
		},
		DwellTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Millisecond],
			Units -> Millisecond,
			IndexMatching -> Elements,
			Description->"For each member of Elements, Time spend to measure a single analyte of a single sample.",
			Category -> "Method Information"
		},
		NumberOfReads -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			IndexMatching -> Elements,
			Description-> "For each member of Elements, Number of redundant readings by the instrument on each side the target mass, see Figure X2.",
			Category -> "Method Information"
		},
		ReadSpacing -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Gram/Mole],
			IndexMatching -> Elements,
			Description->"For each member of Elements, Distance of mass units between adjacent redundant readings. See Figure X2.",
			Category -> "Method Information"
		},
		Bandpass -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Normal, High],
			IndexMatching -> Elements,
			Description->"For each member of Elements, Select the bandwidth of allowed m/z ratio for each reading by the quadrupole. Normal is 0.75 amu at 10% peak height, and High is 0.3 amu at 10% peak height. Set Resolution to High can better differentiate some isotopes, with a price of reduced signal level.",
			Category -> "Method Information"
		},
		InternalStandardElement -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> Elements,
			Description->"For each member of Elements, Indicates if the particular element comes from InternalStandard, therefore should be measured but not quantified.",
			Category -> "Method Information"
		},
		QuantifyConcentration -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> Elements,
			Description->"For each member of Elements, Indicates if concentrations of the particular element in all input samples are quantified.",
			Category -> "Method Information"
		},
		MinMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Gram/Mole],
			Units -> Gram/Mole,
			Description -> "When Elements is set to Sweep, sets the lower limit of the m/z value for the quadrupole mass scanning range.",
			Category -> "Method Information"
		},
		MaxMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Gram/Mole],
			Units -> Gram/Mole,
			Description->"When Elements is set to Sweep, sets the upper limit of the m/z value for the quadrupole mass scanning range.",
			Category -> "Method Information"
		},
		ExternalStandard -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description->"Calibration standard for quantification of analyte elements or nuclei.",
			Category -> "Standard"
		},
		StandardDilutionCurve -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({VolumeP, VolumeP}|{VolumeP, _?NumberQ})...},
			IndexMatching -> ExternalStandard,
			Description->"For each member of ExternalStandard, External calibration standard for quantification of analyte elements or nuclei that is measured separately from the sample.",
			Category -> "Standard"
		},
		ExternalStandardElements -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {ICPMSElementP...}|{{ICPMSElementP, ConcentrationP|MassConcentrationP}...}|{{ICPMSNucleusP, ConcentrationP|MassConcentrationP}...},
			IndexMatching -> ExternalStandard,
			Description->"For each member of ExternalStandard, Nuclei or element present in the standard solution with known concentrations before dilution.",
			Category -> "Standard"
		},
		StandardAddedSample -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SampleLink,
			Description->"For each member of SampleLink, Indicate if the input sample has already been spiked with standard sample for concentration measurement via standard addition.",
			Category -> "Standard"
		},
		AdditionStandard -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			IndexMatching -> SampleLink,
			Description->"For each member of SampleLink, standard samples being added to the sample for standard addition.",
			Category -> "Standard"
		},
		StandardAdditionCurve -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({VolumeP, VolumeP}|{VolumeP, _?NumberQ})...},
			IndexMatching -> SampleLink,
			Description->"For each member of SampleLink, The collection of StandardAddition performed on the input sample prior to injecting the standard samples into the instrument. If StandardAddedSample is set to True for any sample, these samples will no longer be mixed with AdditionStandard again, and This option should be set to Null.",
			Category -> "Standard"
		},
		StandardAdditionElements -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {ICPMSElementP...}|{{ICPMSElementP, ConcentrationP|MassConcentrationP}...}|{{ICPMSNucleusP, ConcentrationP|MassConcentrationP}...},
			IndexMatching -> SampleLink,
			Description->"For each member of SampleLink, Nuclei or element present in the standard solution with known concentrations before dilution. For samples with StandardAddedSample set to True, concentration in this option instead refers to the value after dilution.",
			Category -> "Standard"
		}
	}
}];
