(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, MassSpectrometer], {
	Description->"The model for a mass spectrometer instrument used to determine the molecular weight of molecules in a sample by generating gas phase ions of the molecules and measuring their mass-to-charge ratio.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Detectors -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ChromatographyDetectorTypeP,
			Description -> "A list of the measurement modules on this instrument.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		MassAnalyzer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MassAnalyzerTypeP,
			Description -> "The type of the component of the mass spectrometer that performs ion separation based on mass-to-charge (m/z) ratio. The type of the component of the mass spectrometer that performs ion separation based on mass-to-charge (m/z) ratio. Time of flight (TOF) analyzers accelerate and resolve ions
			using an applied electrical field, thereby resolving ions by their flight path (a function of m/z). QTOF (quantitative time of flight) mass analyzer can perform two accelerations and also measure ion fragments.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		IonSources -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> IonSourceP|GCIonSourceP|ICP,
			Description -> "The type of ionization source used to generate gas phase ions from the molecules in the sample. Electrospray ionization (ESI) produces ions using an electrospray in which a high voltage is applied to a liquid to create an aerosol, and gas phase ions are formed from the fine spray of charged droplets as a result of solvent evaporation and Coulomb fission. In matrix-assisted laser desorption/ionization (MALDI), the sample is embedded in a laser energy absorbing matrix which is then irradiated with a pulsed laser, ablating and desorbing the molecules with minimal fragmentation and creating gas phase ions from the analyte molecules in the sample.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		IonModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> IonModeP,
			Description -> "The possible detection modes for ions (in Negative mode, negatively charged ions and in Positive mode, positively charged ions are generated and analyzed).",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		AcquisitionModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> AcquisitionModeP,
			Description -> "Data acquisition functions that can be performed on this instrument.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		VialAdapter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part],
			Description -> "The type of adapter used to connect any sample vials to this type of mass spectrometer during direct infusion experiments.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		MinMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "The lowest value of mass-to-charge ratio (m/z) the instrument can detect.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "The highest value of mass-to-charge ratio (m/z) the instrument can detect.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		(* For syringe pump used in the instrument *)
		SyringePumpDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter,
			Description->"The largest diameter of a syringe that can fit in the syringe pump of the mass spetrometer.",
			Category -> "Dimensions & Positions"
		},
		SyringePumpLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter,
			Description->"The longest syringe (in centimeter) that can fit in the syringe pump of the mass spetrometer.",
			Category -> "Dimensions & Positions"
		},

		(* Tandem Mass Spec (MS/MS) parameters *)
		TandemMassSpectrometry->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicate if this instrument is capable of conducting tandem mass spectrometry.",
			Category->"Operating Limits",
			Abstract-> True
		},
		MinFragmentationMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For the Mass Spectrometer that has tandem mass spectrometry feature, this value indicate the lowest value of mass-to-charge ratio (m/z) that the second mass analyzer (MS2) of instrument can detect.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxFragmentationMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For the Mass Spectrometer that has tandem mass spectrometry feature, this value indicate the highest value of mass-to-charge ratio (m/z) that the second mass analyzer (MS2) of instrument can detect.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxCollisionEnergy->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Volt,
			Description -> "For the Mass Spectrometer that has tandem mass spectrometry feature, this value indicate the highest value of voltage that could be applied to the collision cell.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinCollisionEnergy->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Volt,
			Description -> "For the Mass Spectrometer that has tandem mass spectrometry feature, this value indicate the lowest value of voltage that could be applied to the collision cell.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxCollisionCellExitVoltage->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Volt,
			Description->"For some Mass Spectrometers that has tandem mass spectrometry feature (e.g. ESI-QQQ), this value indicate the highest value of voltage that could be applied between the exit point of the collision cell and the second mass analyzer.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinCollisionCellExitVoltage->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Volt,
			Description->"For some Mass Spectrometers that has tandem mass spectrometry feature (e.g. ESI-QQQ), this value indicate the lowest value of voltage that could be applied between the exit point of the collision cell and the second mass analyzer.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		(* MALDI instrument parameters *)
		FocusingElement -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FocusingElementP,
			Description -> "The type of focusing element for the ions.",
			Category -> "Instrument Specifications"
		},
		Reflectron -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Boolean describing whether or not the TOF mass spectrometer is equipped with a ion mirror (reflectron) to increase the flight path of the ions in the flight tube and improve mass accuracy.",
			Category -> "Instrument Specifications"
		},
		LaserWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "Wavelength of the laser used for desorption/ionization.",
			Category -> "Instrument Specifications"
		},
		LaserPulseWidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nano*Second],
			Units -> Nano Second,
			Description -> "Duration of each laser pulse used for desorption/ionization.",
			Category -> "Instrument Specifications"
		},
		LaserFrequency -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Hertz],
			Units -> Hertz,
			Description -> "The shot frequency of the laser used for desorption/ionization.",
			Category -> "Instrument Specifications"
		},
		LaserPower -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Watt],
			Units -> Watt,
			Description -> "Power of the laser used for desorption/ionization.",
			Category -> "Instrument Specifications"
		},
		MinGridVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kilo*Volt],
			Units -> Kilo Volt,
			Description -> "The minimum voltage the instrument can apply to the grid electrode.",
			Category -> "Operating Limits"
		},
		MaxGridVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kilo*Volt],
			Units -> Kilo Volt,
			Description -> "The maximum voltage the instrument can apply to the grid electrode.",
			Category -> "Operating Limits"
		},
		MinLensVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kilo*Volt],
			Units -> Kilo Volt,
			Description -> "The minimum voltage that can be applied to the ion focusing lens located at the entrance of the mass analyser.",
			Category -> "Operating Limits"
		},
		MaxLensVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kilo*Volt],
			Units -> Kilo Volt,
			Description -> "The maximum voltage that can be applied  to the ion focusing lens located at the entrance of the mass analyser.",
			Category -> "Operating Limits"
		},
		MinGuideWireVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kilo*Volt],
			Units -> Kilo Volt,
			Description -> "The minimum voltage that can be applied to the guide wire used to focus the divergent ions in the mass analyzer.",
			Category -> "Operating Limits"
		},
		MaxGuideWireVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kilo*Volt],
			Units -> Kilo Volt,
			Description -> "The maximum voltage that can be applied to the guide wire used to focus the divergent ionsin the mass analyzer.",
			Category -> "Operating Limits"
		},
		MinAcceleratingVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kilo*Volt],
			Units -> Kilo Volt,
			Description -> "The minimum voltage the instrument can apply to the target plate to accelerate the ions.",
			Category -> "Operating Limits"
		},
		MaxAcceleratingVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kilo*Volt],
			Units -> Kilo Volt,
			Description -> "The maximum voltage the instrument can apply to the target plate to accelerate the ions.",
			Category -> "Operating Limits"
		},
		MinShots -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The minimum number of laser shots that can be fired at each spot.",
			Category -> "Operating Limits"
		},
		MaxShots -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The maximum number of laser shots that can be fired at each spot.",
			Category -> "Operating Limits"
		},
		MinDelayTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nano*Second],
			Units -> Nano Second,
			Description -> "The minimum delay between laser ablation and ion extraction accepted by the instrument.",
			Category -> "Operating Limits"
		},
		MaxDelayTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nano*Second],
			Units -> Nano Second,
			Description -> "The maximum delay between laser ablation and ion extraction accepted by the instrument.",
			Category -> "Operating Limits"
		},
		(* ESI MS parameters *)
		MinESICapillaryVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Volt,
			Description -> "Minimum voltage that can be applied to the stainless steel capillary from which the ion spray is generated.",
			Category -> "Operating Limits"
		},
		MaxESICapillaryVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "Maximum voltage that can be applied to the stainless steel capillary from which the ion spray is generated.",
			Category -> "Operating Limits"
		},
		MinDeclusteringVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Volt,
			Description ->"Minimum voltage that indicates the voltage between the ion block (the reduced-pressure chamber of the source block) and the stepwave ion guide (the optics before the quadrupole mass analyzer) for ESI-QTOF; Or the voltage applied between the orifice (where ions enter the mass spectrometer) and the ion guide to prevent the ionized small particles from aggregating together for ESI-QQQ.",
			Category -> "Operating Limits"
		},
		MaxDeclusteringVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Volt,
			Description ->"Maximum voltage that indicates the voltage between the ion block (the reduced-pressure chamber of the source block) and the stepwave ion guide (the optics before the quadrupole mass analyzer) for ESI-QTOF; Or the voltage applied between the orifice (where ions enter the mass spectrometer) and the ion guide to prevent the ionized small particles from aggregating together for ESI-QQQ.",
			Category -> "Operating Limits"
		},
		MinIonGuideVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Volt,
			Description -> "Minimum voltage that can be applied on the Ion guide to guides and focuses the ions through the high-pressure Ion guid region, this parameter is also labeled as Entrance Potential (EP).",
			Category -> "Operating Limits"
		},
		MaxIonGuideVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "Maximum voltage that can be applied on the Ion guide to guides and focuses the ions through the high-pressure Ion guid region, this parameter is also labeled as Entrance Potential (EP).",
			Category -> "Operating Limits"
		},
		MinSourceTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Celsius],
			Units -> Celsius,
			Description -> "The minimum temperature setting for the source block (the reduced pressure chamber holding the sample cone through which the ions travel on their way to the mass analyzer).",
			Category -> "Operating Limits"
		},
		MaxSourceTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "The maximum temperature setting for the source block (the reduced pressure chamber holding the sample cone through which the ions travel on their way to the mass analyzer).",
			Category -> "Operating Limits"
		},
		MinDesolvationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Celsius],
			Units -> Celsius,
			Description -> "The minimum temperature setting for the source desolvation heater that controls the nitrogen gas temperature used for solvent cluster evaporation before ions enter the mass spectrometer through the sampling cone.",
			Category -> "Operating Limits"
		},
		MaxDesolvationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Celsius],
			Units -> Celsius,
			Description -> "The maximum temperature setting for the source desolvation heater that controls the nitrogen gas temperature used for solvent cluster evaporation before ions enter the mass spectrometer through the sampling cone.",
			Category -> "Operating Limits"
		},
		(* New Gas flow options for ESI-QQQ *)
		MinConeGasFlow -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> (GreaterEqualP[0*Liter/Hour] | GreaterEqualP[0 PSI]),
			Units -> None,
			Description -> "The minimum nitrogen gas flow ejected around the sample inlet cone to encourage solvent cluster evaporation.",
			Category -> "Operating Limits"
		},
		MaxConeGasFlow -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> (GreaterEqualP[0*Liter/Hour] | GreaterEqualP[0 PSI]),
			Units -> None,
			Description -> "The maximum nitrogen gas flow ejected around the sample inlet cone to encourage solvent cluster evaporation.",
			Category -> "Operating Limits"
		},
		MinDesolvationGasFlow -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> (GreaterEqualP[0*Liter/Hour] | GreaterEqualP[0 PSI]),
			Units -> None,
			Description -> "The minimum nitrogen gas flow ejected around the ion source capillary to encourage solvent evaporation.",
			Category -> "Operating Limits"
		},
		MaxDesolvationGasFlow -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> (GreaterEqualP[0*Liter/Hour] | GreaterEqualP[0 PSI]),
			Units -> None,
			Description -> "The maximum nitrogen gas flow ejected around the ion source capillary to encourage solvent evaporation.",
			Category -> "Operating Limits"
		},
		MinStepwaveVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Volt,
			Description -> "Minimum voltage that between the 1st and 2nd stage of the ion guide which leads ions coming from the sample cone towards the quadrupole mass analyzer.",
			Category -> "Operating Limits"
		},
		MaxStepwaveVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "Maximum voltage that between the 1st and 2nd stage of the ion guide which leads ions coming from the sample cone towards the quadrupole mass analyzer.",
			Category -> "Operating Limits"
		},
		MinInfusionFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Milli*Liter)/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "The minimum flow rate at which the instrument can pump buffer or sample into the system via the built-in syringe pump system.",
			Category -> "Operating Limits"
		},
		MaxInfusionFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Milli*Liter)/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "The maximum flow rate at which the instrument can pump buffer or sample into the system via the built-in syringe pump system.",
			Category -> "Operating Limits"
		},
		(*ICP-MS specific fields*)
		PlasmaPower -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0* Watt],
			Units -> Watt,
			Description -> "Possible nominal power of plasma that can be set for the instrument.",
			Category -> "Instrument Specifications"
		},
		LowPowerElements -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ICPMSElementP,
			Description -> "List of elements where the plasma power is recommended to set to Low during experiment.",
			Category -> "Instrument Specifications"
		},
		SupportedElements -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ICPMSElementP,
			Description -> "List of elements which can be measured by this instrument.",
			Category -> "Instrument Specifications"
		},
		SupportedIsotopes -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> ICPMSNucleusP,
			Description -> "List of isotopes for each elements which can be measured by this instrument.",
			Category -> "Instrument Specifications"
		},
		CollisionCellGas -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ICPMSCollisionCellGasP,
			Description -> "Types of gas that can be used for collision cell to remove interferences.",
			Category -> "Instrument Specifications"
		},
		ConeDiameter -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "Indicates diameter of the vacuum interface cone that can possibly be installed on the instrument.",
			Category -> "Instrument Specifications"
		},
		Cones -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item],
			IndexMatching -> ConeDiameter,
			Description -> "For each member of ConeDiameter, Indicates the model of vacuum interface cone that can possibly be installed on the instrument.",
			Category -> "Instrument Specifications"
		},
		MaxPlasmaPower -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Watt],
			Units -> Watt,
			Description -> "Maximum electric power that can be delivered to the argon gas to form plasma by the instrument.",
			Category -> "Operating Limits"
		},
		MinCollisionCellGasFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter/Minute],
			Units -> Milliliter/Minute,
			Description -> "Minimum flow rate of gas that can be delivered to the collision cell.",
			Category -> "Operating Limits"
		},
		MaxCollisionCellGasFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter/Minute],
			Units -> Milliliter/Minute,
			Description -> "Maximum flow rate of gas that can be delivered to the collision cell.",
			Category -> "Operating Limits"
		},
		MinNebulizerGasFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Liter/Minute],
			Units -> Liter/Minute,
			Description -> "Minimum flow rate of argon gas to deliver and aerosolize liquid input sample.",
			Category -> "Operating Limits"
		},
		MaxNebulizerGasFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Liter/Minute],
			Units -> Liter/Minute,
			Description -> "Maximum flow rate of argon gas to deliver and aerosolize liquid input sample.",
			Category -> "Operating Limits"
		},
		MinAuxillaryGasFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Liter/Minute],
			Units -> Liter/Minute,
			Description -> "Minimum flow rate of argon gas to generate plasma.",
			Category -> "Operating Limits"
		},
		MaxAuxillaryGasFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Liter/Minute],
			Units -> Liter/Minute,
			Description -> "Maximum flow rate of argon gas to generate plasma.",
			Category -> "Operating Limits"
		},
		MinCoolGasFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Liter/Minute],
			Units -> Liter/Minute,
			Description -> "Minimum flow rate of argon gas to cool the wall of torch .",
			Category -> "Operating Limits"
		},
		MaxCoolGasFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Liter/Minute],
			Units -> Liter/Minute,
			Description -> "Maximum flow rate of argon gas to cool the wall of torch.",
			Category -> "Operating Limits"
		},
		MinArgonPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 PSI],
			Units -> PSI,
			Description -> "Minimum argon gas pressure measured at the inlet required by the instrument during operation.",
			Category -> "Operating Limits"
		},
		MaxArgonPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 PSI],
			Units -> PSI,
			Description -> "Maximum argon gas pressure measured at the inlet allowed by the instrument during operation.",
			Category -> "Operating Limits"
		},
		MinCollisionCellGasPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 PSI],
			Units -> PSI,
			Description -> "Minimum CollisionCellGas pressure measured at the inlet required by the instrument during operation.",
			Category -> "Operating Limits"
		},
		MaxCollisionCellGasPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 PSI],
			Units -> PSI,
			Description -> "Maximum CollisionCellGas pressure measured at the inlet allowed by the instrument during operation.",
			Category -> "Operating Limits"
		},
		MinExtractionLensVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> VoltageP,
			Units -> Volt,
			Description -> "Minimum voltage applied on ion lens to defract the beam and separate ionized particles from neutral ones, where the neutral ones collide on wall, while ionized particles continues into the instrument flow path. This concept is analogous to the step wave guide in QTOF.",
			Category -> "Operating Limits"
		},
		MaxExtractionLensVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> VoltageP,
			Units -> Volt,
			Description -> "Maximum voltage applied on ion lens to defract the beam and separate ionized particles from neutral ones, where the neutral ones collide on wall, while ionized particles continues into the instrument flow path. This concept is analogous to the step wave guide in QTOF.",
			Category -> "Operating Limits"
		},
		MinFocusLensVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> VoltageP,
			Units -> Volt,
			Description -> "Minimum voltage applied on ion lens to tighten the ionized particle beam.",
			Category -> "Operating Limits"
		},
		MaxFocusLensVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> VoltageP,
			Units -> Volt,
			Description -> "Maximum voltage applied on ion lens to tighten the ionized particle beam.",
			Category -> "Operating Limits"
		},
		MinCollisionCellLensVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> VoltageP,
			Units -> Volt,
			Description -> "Minimum voltage applied in the collision cell to focus ionized sample particles.",
			Category -> "Operating Limits"
		},
		MaxCollisionCellLensVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> VoltageP,
			Units -> Volt,
			Description -> "Maximum voltage applied in the collision cell to focus ionized sample particles.",
			Category -> "Operating Limits"
		},
		MinQuadrupoleBiasVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> VoltageP,
			Units -> Volt,
			Description -> "Minimum DC voltage in the quadrupole mass analyzer used to select ions of the target m/z ratio matching the Elements field.",
			Category -> "Operating Limits"
		},
		MaxQuadrupoleBiasVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> VoltageP,
			Units -> Volt,
			Description -> "Maximum DC voltage in the quadrupole mass analyzer used to select ions of the target m/z ratio matching the Elements field.",
			Category -> "Operating Limits"
		},
		MinSprayChamberTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature setting in the nebulizer spray chamber.",
			Category -> "Operating Limits"
		},
		MaxSprayChamberTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature setting in the nebulizer spray chamber.",
			Category -> "Operating Limits"
		},
		Chiller -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part, Chiller][Instrument],
			Description -> "The chiller model that is connected to this mass spectrometer to cool down the instrument during operation.",
			Category -> "Integrations"
		},
		SampleConsumptionRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter/Minute],
			Units -> Milliliter/Minute,
			Description -> "The rate of sample being injected into the spectrometer during continueous uptake.",
			Category -> "Instrument Specifications"
		},
		RinseSolutionConsumptionRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter/Minute],
			Units -> Milliliter/Minute,
			Description -> "The rate of consumption of rinse solution during rinsing time.",
			Category -> "Instrument Specifications",
			Developer -> True
		}
	}
}];
