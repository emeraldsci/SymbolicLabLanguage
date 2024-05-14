

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, MassSpectrometer], {
	Description->"Mass spectrometer instrument used to determine the molecular weight of molecules in a sample by generating gas phase ions of the molecules and measuring their mass-to-charge ratio.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		MassAnalyzer -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MassAnalyzer]],
			Pattern :> MassAnalyzerTypeP,
			Description -> "The type of the component of the mass spectrometer that performs ion separation based on mass-to-charge (m/z) ratio.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		IonSources -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],IonSources]],
			Pattern :> {IonSourceP|GCIonSourceP..},
			Description -> "The type of ionization source used to generate gas phase ions. Electrospray ionization (ESI) produces ions using an electrospray in which a high voltage is applied to a liquid to create an aerosol, and gas phase ions are formed from the fine spray of charged droplets as a result of solvent evaporation and Coulomb fission. In matrix-assisted laser desorption/ionization (MALDI), the sample is embedded in a laser energy absorbing matrix which is then irradiated with a pulsed laser, ablating and desorbing the molecules with minimal fragmentation and creating gas phase ions from the analyte molecules in the sample.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		IonModes -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],IonModes]],
			Pattern :> {IonModeP..},
			Description -> "The possible detection modes for ions (in Negative mode, negatively charged ions and in Positive mode, positively charged ions are generated and analyzed).",
			Category -> "Instrument Specifications"
		},
		AcquisitionModes -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],AcquisitionModes]],
			Pattern :> {AcquisitionModeP..},
			Description -> "Data acquisition functions that can be performed on this instrument.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		FocusingElement -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],FocusingElement]],
			Pattern :> FocusingElementP,
			Description -> "The type of focusing element for the ions.",
			Category -> "Instrument Specifications"
		},
		Reflectron -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Reflectron]],
			Pattern :> BooleanP,
			Description -> "Boolean describing whether or not the TOF mass spectrometer is equipped with a ion mirror (reflectron) to increase the flight path of the ions in the flight tube and improve mass accuracy.",
			Category -> "Instrument Specifications"
		},
		LaserWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],LaserWavelength]],
			Pattern :> GreaterEqualP[0*Meter*Nano],
			Description -> "Wavelength of the laser used for desorption/ionization.",
			Category -> "Instrument Specifications"
		},
		LaserPulseWidth -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],LaserPulseWidth]],
			Pattern :> GreaterEqualP[0*Nano*Second],
			Description -> "Duration of each laser pulse used for desorption/ionization.",
			Category -> "Instrument Specifications"
		},
		LaserFrequency -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],LaserFrequency]],
			Pattern :> GreaterEqualP[0*Hertz],
			Description -> "The shot frequency of the laser used for desorption/ionization.",
			Category -> "Instrument Specifications"
		},
		LaserPower -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],LaserPower]],
			Pattern :> GreaterEqualP[0*Watt],
			Description -> "Power of the laser used for desorption/ionization.",
			Category -> "Instrument Specifications"
		},
		(* Instrument specific set up file *)
		MethodTemplate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The template file with instrument specific method file that used to operate an Microflex MALDI TOF Instrument. This file will be used during exportFlexControl.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		InstrumentSettingsTemplate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The template file with instrument specific setting that used to operate an Microflex MALDI TOF Instrument. This file will be used during exportFlexControl.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		MinMass -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinMass]],
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Description -> "Minimum mass the instrument can detect.",
			Category -> "Operating Limits"
		},
		MaxMass -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxMass]],
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Description -> "Maximum mass the instrument can detect.",
			Category -> "Operating Limits"
		},
		MinGridVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinGridVoltage]],
			Pattern :> GreaterEqualP[0*Kilo*Volt],
			Description -> "The minimum voltage the instrument can apply to the grid electrode.",
			Category -> "Operating Limits"
		},
		MaxGridVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxGridVoltage]],
			Pattern :> GreaterEqualP[0*Kilo*Volt],
			Description -> "The maximum voltage the instrument can apply to the grid electrode.",
			Category -> "Operating Limits"
		},
		MinLensVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinLensVoltage]],
			Pattern :> GreaterEqualP[0*Kilo*Volt],
			Description -> "The minimum voltage that can be applied to the ion focusing lens located at the entrance of the mass analyser.",
			Category -> "Operating Limits"
		},
		MaxLensVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxLensVoltage]],
			Pattern :> GreaterEqualP[0*Kilo*Volt],
			Description -> "The maximum voltage that can be applied  to the ion focusing lens located at the entrance of the mass analyser.",
			Category -> "Operating Limits"
		},
		MinGuideWireVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinGuideWireVoltage]],
			Pattern :> GreaterEqualP[0*Kilo*Volt],
			Description -> "The minimum voltage that can be applied to the guide wire used to focus the divergent ions in the mass analyzer.",
			Category -> "Operating Limits"
		},
		MaxGuideWireVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxGuideWireVoltage]],
			Pattern :> GreaterEqualP[0*Kilo*Volt],
			Description -> "The maximum voltage that can be applied to the guide wire used to focus the divergent ionsin the mass analyzer.",
			Category -> "Operating Limits"
		},
		MinAcceleratingVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinAcceleratingVoltage]],
			Pattern :> GreaterEqualP[0*Kilo*Volt],
			Description -> "The minimum voltage the instrument can apply to the target plate to accelerate the ions.",
			Category -> "Operating Limits"
		},
		MaxAcceleratingVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxAcceleratingVoltage]],
			Pattern :> GreaterEqualP[0*Kilo*Volt],
			Description -> "The maximum voltage the instrument can apply to the target plate to accelerate the ions.",
			Category -> "Operating Limits"
		},
		MinShots -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinShots]],
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The minimum number of laser shots that can be fired at each spot.",
			Category -> "Operating Limits"
		},
		MaxShots -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxShots]],
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The maximum number of laser shots that can be fired at each spot.",
			Category -> "Operating Limits"
		},
		MinDelayTime -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinDelayTime]],
			Pattern :> GreaterEqualP[0*Nano*Second],
			Description -> "The minimum delay between laser ablation and ion extraction accepted by the instrument.",
			Category -> "Operating Limits"
		},
		MaxDelayTime -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxDelayTime]],
			Pattern :> GreaterEqualP[0*Nano*Second],
			Description -> "The maximum delay between laser ablation and ion extraction accepted by the instrument.",
			Category -> "Operating Limits"
		},
		MinESICapillaryVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinESICapillaryVoltage]],
			Pattern :> GreaterP[0*Volt, 1*Volt],
			Description -> "Minimum voltage that can be applied to the stainless steel capillary from which the ion spray is generated.",
			Category -> "Operating Limits"
		},
		MaxESICapillaryVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxESICapillaryVoltage]],
			Pattern :> GreaterP[0*Volt, 1*Volt],
			Description -> "Maximum voltage that can be applied to the stainless steel capillary from which the ion spray is generated.",
			Category -> "Operating Limits"
		},
		MinDeclusteringVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinDeclusteringVoltage]],
			Pattern :> GreaterP[0*Volt, 1*Volt],
			Description ->"Minimum voltage that indicates the voltage between the ion block (the reduced-pressure chamber of the source block) and the stepwave ion guide (the optics before the quadrupole mass analyzer) for ESI-QTOF; Or the voltage applied between the orifice (where ions enter the mass spectrometer) and the ion guide to prevent the ionized small particles from aggregating together for ESI-QQQ.",
			Category -> "Operating Limits"
		},
		MaxDeclusteringVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxDeclusteringVoltage]],
			Pattern :> GreaterP[0*Volt, 1*Volt],
			Description ->"Maximum voltage that indicates the voltage between the ion block (the reduced-pressure chamber of the source block) and the stepwave ion guide (the optics before the quadrupole mass analyzer) for ESI-QTOF; Or the voltage applied between the orifice (where ions enter the mass spectrometer) and the ion guide to prevent the ionized small particles from aggregating together for ESI-QQQ.",
			Category -> "Operating Limits"
		},
		MinSourceTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinSourceTemperature]],
			Pattern :> GreaterP[0*Celsius, 1*Celsius],
			Description -> "The minimum temperature setting for the source block (the reduced pressure chamber holding the sample cone through which the ions travel on their way to the mass analyzer).",
			Category -> "Operating Limits"
		},
		MaxSourceTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxSourceTemperature]],
			Pattern :> GreaterP[0*Celsius, 1*Celsius],
			Description -> "The maximum temperature setting for the source block (the reduced pressure chamber holding the sample cone through which the ions travel on their way to the mass analyzer).",
			Category -> "Operating Limits"
		},
		MinDesolvationTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinDesolvationTemperature]],
			Pattern :> GreaterP[0*Celsius, 1*Celsius],
			Description -> "The minimum temperature setting for the source desolvation heater that controls the nitrogen gas temperature used for solvent cluster evaporation before ions enter the mass spectrometer through the sampling cone.",
			Category -> "Operating Limits"
		},
		MaxDesolvationTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxDesolvationTemperature]],
			Pattern :> GreaterP[0*Celsius, 1*Celsius],
			Description -> "The maximum temperature setting for the source desolvation heater that controls the nitrogen gas temperature used for solvent cluster evaporation before ions enter the mass spectrometer through the sampling cone.",
			Category -> "Operating Limits"
		},
		(* ESI-QQQ New field*)
		MinConeGasFlow -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinConeGasFlow]],
			Pattern :>(GreaterEqualP[0*Liter/Hour] | GreaterEqualP[0 PSI]),
			Description -> "The minimum nitrogen gas flow ejected around the sample inlet cone to encourage solvent cluster evaporation.",
			Category -> "Operating Limits"
		},
		MaxConeGasFlow -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxConeGasFlow]],
			Pattern :> (GreaterEqualP[0*Liter/Hour] | GreaterEqualP[0 PSI]),
			Description -> "The maximum nitrogen gas flow ejected around the sample inlet cone to encourage solvent cluster evaporation.",
			Category -> "Operating Limits"
		},
		MinDesolvationGasFlow -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinDesolvationGasFlow]],
			Pattern :>(GreaterEqualP[0*Liter/Hour] | GreaterEqualP[0 PSI]),
			Description -> "The minimum nitrogen gas flow ejected around the ion source capillary to encourage solvent evaporation.",
			Category -> "Operating Limits"
		},
		MaxDesolvationGasFlow -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxDesolvationGasFlow]],
			Pattern :> (GreaterEqualP[0*Liter/Hour] | GreaterEqualP[0 PSI]),
			Description -> "The maximum nitrogen gas flow ejected around the ion source capillary to encourage solvent evaporation.",
			Category -> "Operating Limits"
		},
		MinStepwaveVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinStepwaveVoltage]],
			Pattern :> GreaterP[0*Volt, 1*Volt],
			Description -> "Minimum voltage that between the 1st and 2nd stage of the ion guide which leads ions coming from the sample cone towards the quadrupole mass analyzer.",
			Category -> "Operating Limits"
		},
		MaxStepwaveVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxStepwaveVoltage]],
			Pattern :> GreaterP[0*Volt, 1*Volt],
			Description -> "Maximum voltage that between the 1st and 2nd stage of the ion guide which leads ions coming from the sample cone towards the quadrupole mass analyzer.",
			Category -> "Operating Limits"
		},
		MinInfusionFlowRate -> {
			Format -> Computable,
			Class -> Real,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinInfusionFlowRate]],
			Pattern :> GreaterP[(0*Milli*Liter)/Minute],
			Description -> "The minimum flow rate at which the instrument can pump buffer or sample into the system via the built-in syringe pump system.",
			Category -> "Operating Limits"
		},
		MaxInfusionFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxInfusionFlowRate]],
			Pattern :> GreaterP[(0*Milli*Liter)/Minute],
			Description -> "The maximum flow rate at which the instrument can pump buffer or sample into the system via the built-in syringe pump system.",
			Category -> "Operating Limits"
		},
		MinIonGuideVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinIonGuideVoltage]],
			Pattern :> GreaterEqualP[0*Volt],
			Description -> "Minimum voltage that can be applied on the Ion guide to guides and focuses the ions through the high-pressure Ion guid region.",
			Category -> "Operating Limits"
		},
		MaxIonGuideVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxIonGuideVoltage]],
			Pattern :> GreaterP[0*Volt],
			Description -> "Maximum voltage that can be applied on the Ion guide to guides and focuses the ions through the high-pressure Ion guid region.",
			Category -> "Operating Limits"
		},
		(* Tandem Mass Spec (MS/MS) parameters *)
		TandemMassSpectrometry->{
			Format->Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TandemMassSpectrometry]],
			Pattern:>BooleanP,
			Description->"Indicate if this intrument can achieve tandem mass spectrometry features.",
			Category->"Operating Limits",
			Abstract-> True
		},
		MinFragmentationMass -> {
			Format->Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinFragmentationMass]],
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Description -> "For the Mass Spectrometer that has tandem mass spectrometry feature, this value indicate the lowest value of mass-to-charge ratio (m/z) that the first mass analyzer (MS1) of instrument can detect.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxFragmentationMass -> {
			Format->Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxFragmentationMass]],
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Description -> "For the Mass Spectrometer that has tandem mass spectrometry feature, this value indicate the highest value of mass-to-charge ratio (m/z) that the second mass analyzer (MS2) of instrument can detect.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxCollisionEnergy->{
			Format->Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxCollisionEnergy]],
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Description -> "For the Mass Spectrometer that has tandem mass spectrometry feature, this value indicate the highest value of voltage that could be applied to the collision cell.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinCollisionEnergy->{
			Format->Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinCollisionEnergy]],
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Description -> "For the Mass Spectrometer that has tandem mass spectrometry feature, this value indicate the lowest value of voltage that could be applied to the collision cell.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxCollisionCellExitVoltage->{
			Format->Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxCollisionCellExitVoltage]],
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Description->"For some Mass Spectrometers that has tandem mass spectrometry feature (e.g. ESI-QQQ), this value indicate the highest value of voltage that could be applied between the exit point of the collision cell and the second mass analyzer.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinCollisionCellExitVoltage->{
			Format->Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinCollisionCellExitVoltage]],
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Description->"For some Mass Spectrometers that has tandem mass spectrometry feature (e.g. ESI-QQQ), this value indicate the lowest value of voltage that could be applied between the exit point of the collision cell and the second mass analyzer.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		(*ICP-MS specific fields*)
		PlasmaPower -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], PlasmaPower]],
			Pattern :> GreaterP[0* Watt],
			Description -> "Possible nominal power of plasma that can be set for the instrument.",
			Category -> "Instrument Specifications"
		},
		LowPowerElements -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], LowPowerElements]],
			Pattern :> ListableP[ICPMSElementP],
			Description -> "List of elements where the plasma power is recommended to set to Low during experiment.",
			Category -> "Instrument Specifications"
		},
		SupportedElements -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], SupportedElements]],
			Pattern :> ListableP[ICPMSElementP],
			Description -> "List of elements which can be measured by this instrument.",
			Category -> "Instrument Specifications"
		},
		SupportedIsotopes -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], SupportedIsotopes]],
			Pattern :> ListableP[ICPMSNucleusP],
			Description -> "List of isotopes for each elements which can be measured by this instrument.",
			Category -> "Instrument Specifications"
		},
		CollisionCellGas -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], CollisionCellGas]],
			Pattern :> Alternatives[Helium, Oxygen],
			Description -> "Types of gas that can be used for collision cell to remove interferences.",
			Category -> "Instrument Specifications"
		},
		CollisionCellGasTankPressureSensor -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "For each member of CollisionCellGas, the sensor reading the pressure of the supply tank.",
			Category -> "Sensor Information",
			IndexMatching -> CollisionCellGas
		},
		CollisionCellGasDeliveryPressureSensor -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "For each member of CollisionCellGas, the sensor reading the delivery pressure of the gas.",
			Category -> "Sensor Information",
			IndexMatching -> CollisionCellGas
		},
		ConeDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], ConeDiameter]],
			Pattern :> GreaterP[0 Millimeter],
			Description -> "Indicates diameter of the vacuum interface cone that can possibly be installed on the instrument.",
			Category -> "Instrument Specifications"
		},
		ConeInstalled -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item],
			Description -> "Indicates the  vacuum interface cone that is currently installed on the instrument.",
			Category -> "Instrument Specifications"
		},
		MaxPlasmaPower -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxPlasmaPower]],
			Pattern :> GreaterP[0 Watt],
			Description -> "Maximum electric power that can be delivered to the argon gas to form plasma by the instrument.",
			Category -> "Operating Limits"
		},
		MinCollisionCellGasFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinCollisionCellGasFlowRate]],
			Pattern :> GreaterP[0 Milliliter/Minute],
			Description -> "Minimum flow rate of gas that can be delivered to the collision cell.",
			Category -> "Operating Limits"
		},
		MaxCollisionCellGasFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxCollisionCellGasFlowRate]],
			Pattern :> GreaterP[0 Milliliter/Minute],
			Description -> "Maximum flow rate of gas that can be delivered to the collision cell.",
			Category -> "Operating Limits"
		},
		MinNebulizerGasFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinNebulizerGasFlowRate]],
			Pattern :> GreaterP[0 Liter/Minute],
			Description -> "Minimum flow rate of argon gas to deliver and aerosolize liquid input sample.",
			Category -> "Operating Limits"
		},
		MaxNebulizerGasFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxNebulizerGasFlowRate]],
			Pattern :> GreaterP[0 Liter/Minute],
			Description -> "Maximum flow rate of argon gas to deliver and aerosolize liquid input sample.",
			Category -> "Operating Limits"
		},
		MinAuxillaryGasFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinAuxillaryGasFlowRate]],
			Pattern :> GreaterP[0 Liter/Minute],
			Description -> "Minimum flow rate of argon gas to generate plasma.",
			Category -> "Operating Limits"
		},
		MaxAuxillaryGasFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxAuxillaryGasFlowRate]],
			Pattern :> GreaterP[0 Liter/Minute],
			Description -> "Maximum flow rate of argon gas to generate plasma.",
			Category -> "Operating Limits"
		},
		MinCoolGasFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinCoolGasFlowRate]],
			Pattern :> GreaterP[0 Liter/Minute],
			Description -> "Minimum flow rate of argon gas to cool the wall of torch .",
			Category -> "Operating Limits"
		},
		MaxCoolGasFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxCoolGasFlowRate]],
			Pattern :> GreaterP[0 Liter/Minute],
			Description -> "Maximum flow rate of argon gas to cool the wall of torch.",
			Category -> "Operating Limits"
		},
		MinArgonPressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinArgonPressure]],
			Pattern :> GreaterP[0 PSI],
			Description -> "Minimum argon gas pressure measured at the inlet required by the instrument during operation.",
			Category -> "Operating Limits"
		},
		MaxArgonPressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxArgonPressure]],
			Pattern :> GreaterP[0 PSI],
			Description -> "Maximum argon gas pressure measured at the inlet allowed by the instrument during operation.",
			Category -> "Operating Limits"
		},
		MinCollisionCellGasPressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinCollisionCellGasPressure]],
			Pattern :> GreaterP[0 PSI],
			Description -> "Minimum CollisionCellGas pressure measured at the inlet required by the instrument during operation.",
			Category -> "Operating Limits"
		},
		MaxCollisionCellGasPressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxCollisionCellGasPressure]],
			Pattern :> GreaterP[0 PSI],
			Description -> "Maximum CollisionCellGas pressure measured at the inlet allowed by the instrument during operation.",
			Category -> "Operating Limits"
		},
		MinExtractionLensVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinExtractionLensVoltage]],
			Pattern :> VoltageP,
			Description -> "Minimum voltage applied on ion lens to defract the beam and separate ionized particles from neutral ones, where the neutral ones collide on wall, while ionized particles continues into the instrument flow path. This concept is analogous to the step wave guide in QTOF.",
			Category -> "Operating Limits"
		},
		MaxExtractionLensVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxExtractionLensVoltage]],
			Pattern :> VoltageP,
			Description -> "Maximum voltage applied on ion lens to defract the beam and separate ionized particles from neutral ones, where the neutral ones collide on wall, while ionized particles continues into the instrument flow path. This concept is analogous to the step wave guide in QTOF.",
			Category -> "Operating Limits"
		},
		MinFocusLensVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinFocusLensVoltage]],
			Pattern :> VoltageP,
			Description -> "Minimum voltage applied on ion lens to tighten the ionized particle beam.",
			Category -> "Operating Limits"
		},
		MaxFocusLensVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxFocusLensVoltage]],
			Pattern :> VoltageP,
			Description -> "Maximum voltage applied on ion lens to tighten the ionized particle beam.",
			Category -> "Operating Limits"
		},
		MinCollisionCellLensVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinCollisionCellLensVoltage]],
			Pattern :> VoltageP,
			Description -> "Minimum voltage applied in the collision cell to focus ionized sample particles.",
			Category -> "Operating Limits"
		},
		MaxCollisionCellLensVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxCollisionCellLensVoltage]],
			Pattern :> VoltageP,
			Description -> "Maximum voltage applied in the collision cell to focus ionized sample particles.",
			Category -> "Operating Limits"
		},
		MinQuadrupoleBiasVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinQuadrupoleBiasVoltage]],
			Pattern :> VoltageP,
			Description -> "Minimum DC voltage in the quadrupole mass analyzer used to select ions of the target m/z ratio matching the Elements field.",
			Category -> "Operating Limits"
		},
		MaxQuadrupoleBiasVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxQuadrupoleBiasVoltage]],
			Pattern :> VoltageP,
			Description -> "Maximum DC voltage in the quadrupole mass analyzer used to select ions of the target m/z ratio matching the Elements field.",
			Category -> "Operating Limits"
		},
		MinSprayChamberTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinSprayChamberTemperature]],
			Pattern :> GreaterP[0 Kelvin],
			Description -> "Minimum temperature setting in the nebulizer spray chamber.",
			Category -> "Operating Limits"
		},
		MaxSprayChamberTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxSprayChamberTemperature]],
			Pattern :> GreaterP[0 Kelvin],
			Description -> "Minimum temperature setting in the nebulizer spray chamber.",
			Category -> "Operating Limits"
		},
		(*Syringe Pump *)
		SyringePumpDiameter->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],SyringePumpDiameter]],
			Pattern:>GreaterP[0*Centimeter],
			Description->"The largest diameter of a syringe that can fit in the syringe pump of the mass spetrometer.",
			Category->"Operating Limits"
		},
		SyringePumpLength->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],SyringePumpLength]],
			Pattern:>GreaterP[0*Centimeter],
			Description->"The longest syringe (in centimeter) that can fit in the syringe pump of the mass spetrometer.",
			Category->"Operating Limits"
		},
		(*Dimension and Integragation *)
		ReservoirDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "The platform which contains the lock mass and wash buffer reservoir containers that are used by the instrument.",
			Category -> "Dimensions & Positions"
		},
		IntegratedHPLC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, HPLC][IntegratedMassSpectrometer],
			Description -> "The HPLC system that is connected to this mass spectrometer such that the analytes in the samples may be separated prior to injection and data acquisition.",
			Category -> "Integrations"
		},
		IntegratedGC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, GasChromatograph][IntegratedMassSpectrometer],
			Description -> "The gas chromatograph that is connected to this mass spectrometer such that the analytes in the samples may be separated prior to injection and data acquisition.",
			Category -> "Integrations"
		},
		IntegratedLiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, LiquidHandler][IntegratedMassSpectrometer],
			Description -> "The liquid handler that is connected to this mass spectrometer to function as autosampler.",
			Category -> "Integrations"
		},
		Chiller -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, Chiller][Instrument],
			Description -> "The chiller that is connected to this mass spectrometer to cool down the instrument during operation.",
			Category -> "Integrations"
		},
		SourceCleaningLog -> {
			Format -> Multiple,
			Class -> {Expression, Link},
			Pattern :> {_?DateObjectQ, _Link},
			Relation -> {Null, Object[User] | Object[Qualification] | Object[Maintenance] | Object[Protocol]},
			Description -> "A history of the cleaning of the ionization source.",
			Headers -> {"Date","Responsible Party"},
			Category -> "Organizational Information"
		},
		RinseWasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> ObjectP[Object[Container, Vessel]],
			Description -> "A secondary waste container to hold waste from rinsing, currently specific to ICP-MS.",
			Category -> "Instrument Specifications"
		},
		MinimumUptakeTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "The minimum time of sample uptake needed for contineuous injection before sample solution reach detector.",
			Category -> "Instrument Specifications"
		},
		SourceExhaustGasPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Pressure],
			Description -> "The sensor reading the pressure of the gas used to extract waste products from the instrument source using the Venturi effect.",
			Category -> "Sensor Information"
		},
		SourceExhaustGasPressureRegulator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, PressureRegulator],
			Description -> "The regulator that controls the pressure supplied to the instrument which is used to extract waste products from the instrument source using the Venturi effect.",
			Category -> "Sensor Information"
		},
		ConeGasPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Pressure],
			Description -> "The sensor reading the pressure of the gas flowed around the sample inlet cone used to exclude excess or unwanted signal at the cone aperture. Also known as the curtain gas for ESI-QQQ.",
			Category -> "Sensor Information"
		},
		ConeGasPressureRegulator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, PressureRegulator],
			Description -> "The regulator that controls the pressure supplied to the instrument which is used to exclude excess or unwanted signal at the cone aperture.",
			Category -> "Sensor Information"
		},
		DesolvationGasPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Pressure],
			Description -> "The sensor reading the pressure of the gas used to nebulize and desolvate the samples.",
			Category -> "Sensor Information"
		},
		DesolvationGasPressureRegulator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, PressureRegulator],
			Description -> "The regulator that controls the pressure supplied to the instrument which is used to nebulize and desolvate the samples.",
			Category -> "Sensor Information"
		}
	}
}];
