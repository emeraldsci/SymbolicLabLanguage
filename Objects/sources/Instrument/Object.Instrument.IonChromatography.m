(* ::Package:: *)

DefineObjectType[Object[Instrument, IonChromatography], {
	Description->"A Ion Chromatography instrument that is used to resolve electrically-charged species from mixture.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		(*--- Instrument Specifications ---*)
		AnalysisChannels->{
			Format->Multiple,
			Class->Expression,
			Pattern:>AnalysisChannelP,
			Description->"The number of distinct flow paths in the instrument for analyzing anions and cations separately.",
			Category->"Instrument Specifications",
			Abstract->True
		},
		AnionNumberOfBuffers->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[1, 1],
			Units->None,
			Description->"The number of different Buffers that can be connected to the pump system for anion channel. Refer to AnionPumpType for the number of solvents that can actually be mixed simultaneously.",
			Category->"Instrument Specifications",
			Abstract->True
		},
		CationNumberOfBuffers->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[1, 1],
			Units->None,
			Description->"Rhe number of different Buffers that can be connected to the pump system for cation channel. Refer to CationPumpType for the number of solvents that can actually be mixed simultaneously.",
			Category->"Instrument Specifications",
			Abstract->True
		},
		NumberOfBuffers->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[1, 1],
			Units->None,
			Description->"The number of different Buffers that can be connected to the pump system. Refer to PumpType for the number of solvents that can actually be mixed simultaneously.",
			Category->"Instrument Specifications",
			Abstract->True
		},
		AnionPumpType->{
			Format->Single,
			Class->Expression,
			Pattern:>IonChromatographyPumpTypeP,
			Description->"The number of solvents that can be blended with each other at a ratio for anion channel during the gradient (e.g. binary can mix 2 solvents and isocratic cannot mix multiple solvents).",
			Category->"Instrument Specifications",
			Abstract->True
		},
		CationPumpType->{
			Format->Single,
			Class->Expression,
			Pattern:>IonChromatographyPumpTypeP,
			Description->"The number of solvents that can be blended with each other at a ratio for anion channel during the gradient (e.g. binary can mix 2 solvents and isocratic cannot mix multiple solvents).",
			Category->"Instrument Specifications",
			Abstract->True
		},
		PumpType->{
			Format->Single,
			Class->Expression,
			Pattern:>IonChromatographyPumpTypeP,
			Description->"The number of solvents that can be blended with each other at a ratio during the gradient (e.g. binary can mix 2 solvents and isocratic cannot mix multiple solvents).",
			Category->"Instrument Specifications",
			Abstract->True
		},
		AnionMixer->{
			Format->Single,
			Class->Expression,
			Pattern:>ChromatographyMixerTypeP,
			Description->"The type of mixer the pump uses to generate the gradient for anion channel.",
			Category->"Instrument Specifications"
		},
		CationMixer->{
			Format->Single,
			Class->Expression,
			Pattern:>ChromatographyMixerTypeP,
			Description->"The type of mixer the pump uses to generate the gradient for anion channel.",
			Category->"Instrument Specifications"
		},
		Mixer->{
			Format->Single,
			Class->Expression,
			Pattern:>ChromatographyMixerTypeP,
			Description->"The type of mixer the pump uses to generate the gradient.",
			Category->"Instrument Specifications"
		},
		AnionDetector->{
			Format->Single,
			Class->Expression,
			Pattern:>IonChromatographyDetectorTypeP,
			Description->"A list of the available detectors on the instrument for anion channel.",
			Category->"Instrument Specifications",
			Abstract->True
		},
		CationDetector->{
			Format->Single,
			Class->Expression,
			Pattern:>IonChromatographyDetectorTypeP,
			Description->"A list of the available detectors on the instrument for cation channel.",
			Category->"Instrument Specifications",
			Abstract->True
		},
		Detectors->{
			Format->Multiple,
			Class->Expression,
			Pattern:>IonChromatographyDetectorTypeP,
			Description->"A list of the available detectors on the Ion Chromatography instrument.",
			Category->"Instrument Specifications",
			Abstract->True
		},
		FlowCell->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Part,FlowCell][IonChromatographySystem],
			Description->"The flow cell installed on the Ion Chromatography instrument.",
			Category->"Instrument Specifications",
			Abstract->True
		},
		DetectorLampType->{
			Format->Multiple,
			Class->Expression,
			Pattern:>LampTypeP,
			Description->"A list of sources of illumination available for use in detection.",
			Category->"Instrument Specifications"
		},
		ElectrochemicalDetectionMode->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ElectrochemicalDetectionModeP,
			Description->"The mode of operation supported by the electrochemical detector, including DC Amperometric Detection, Pulsed Amperometric Detection, and Integrated Pulsed Amperometric Detection. In DC Amperometric Detection, a constant voltage is applied. In contrast, Pulsed Amperometric Detections first apply a working potential followed by higher or lower potentials that are used for cleaning the electrode. Further, Integrated Amperometric Detection integrates current over a single potential whereas Integrated Pulsed Amperometric Detection integrates current over two or more potentials.",
			Category->"Instrument Specifications"
		},
		ReferenceElectrode->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Part,ReferenceElectrode],
			Description->"The electrode used as a reference with a constant potential difference.",
			Category->"Instrument Specifications"
		},
		IntegratedEluentGenerator->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Part, EluentGenerator][Instrument],
			Description->"A cartridge that automatically generates eluent in the flow path of Ion Chromatography instrument through electrolysis of water.",
			Category->"Instrument Specifications",
			Abstract->True
		},
		AnionSuppressor->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Part,Suppressor][Instrument],
			Description->"The suppressor that converts high ionic strength buffers into water prior to detection that is integrated in the flow path of anion channel in the Ion Chromatography system.",
			Category->"Instrument Specifications",
			Abstract->True
		},
		CationSuppressor->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Part,Suppressor][Instrument],
			Description->"The suppressor that converts high ionic strength buffers into water prior to detection that is integrated in the flow path of cation channel in the Ion Chromatography system.",
			Category->"Instrument Specifications",
			Abstract->True
		},
		SampleLoop->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Micro*Liter],
			Units->Liter Micro,
			Description->"The maximum volume of sample that can be put in the injection loop, before it is transferred into the flow path.",
			Category->"Instrument Specifications"
		},
		BufferLoop->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Micro*Liter],
			Units->Liter Micro,
			Description->"The volume of tubing between the syringe and the injection valve that is used to provide system fluid to the autosampler syringe.",
			Category->"Instrument Specifications"
		},
		
		ColumnConnector->{
			Format->Multiple,
			Class->{Expression, String, Expression, Expression, Real, Real},
			Pattern:>{ConnectorP, ThreadP, MaterialP, ConnectorGenderP, GreaterEqualP[0*Milli*Meter], GreaterEqualP[0*Milli*Meter]},
			Units->{None, None, None, None, Meter Milli, Meter Milli},
			Description->"The connector on the instrument to which a column will be attached to.",
			Category->"Instrument Specifications",
			Headers->{"Connector Type", "Thread Type", "Material", "Gender", "Inner Diameter", "Outer Diameter"}
		},
		ColumnJoins->{
			Format->Multiple,
			Class->{Link,Link},
			Pattern:>{_Link,_Link},
			Relation->{
				Object[Item,Column],
				Object[Plumbing,Tubing]
			},
			Description->"Column joins that stay connected to the tubings of the instrument.",
			Headers->{"Column Join","Connected plumbing"},
			Category->"Instrument Specifications",
			Developer->True
		},
		TubingInnerDiameter->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Milli*Meter],
			Units->Meter Milli,
			Description->"The diameter of the tubing in the flow path.",
			Category->"Instrument Specifications"
		},
		WastePump->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Instrument, VacuumPump][IonChromatographySystem],
			Description->"Vacuum pump that drains waste liquid into the carboy.",
			Category->"Instrument Specifications"
		},
		EluentGeneratorInletSolutionInlet->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Plumbing,Tubing][IonChromatographySystem]|Object[Plumbing,Tubing],
			Description->"The tubing of eluent generator inlet solution, typically deionized water, used to uptake from the reservoir to the instrument pump.",
			Category->"Instrument Specifications"
		},
		BufferAInlet->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Plumbing, Tubing][IonChromatographySystem]|Object[Plumbing, Tubing],
			Description->"The Buffer A inlet tubing used to uptake Buffer A from buffer container to the instrument pump.",
			Category->"Instrument Specifications"
		},
		BufferBInlet->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Plumbing, Tubing][IonChromatographySystem]|Object[Plumbing, Tubing],
			Description->"The Buffer B inlet tubing used to uptake Buffer B from buffer container to the instrument pump.",
			Category->"Instrument Specifications"
		},
		BufferCInlet->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Plumbing, Tubing][IonChromatographySystem]|Object[Plumbing, Tubing],
			Description->"The Buffer C inlet tubing used to uptake Buffer B from buffer container to the instrument pump.",
			Category->"Instrument Specifications"
		},
		BufferDInlet->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Plumbing, Tubing][IonChromatographySystem]|Object[Plumbing, Tubing],
			Description->"The Buffer D inlet tubing used to uptake Buffer B from buffer container to the instrument pump.",
			Category->"Instrument Specifications"
		},
		NeedleWashSolutionInlet->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Plumbing, Tubing][IonChromatographySystem]|Object[Plumbing, Tubing],
			Description->"The needle wash solution inlet tubing used to uptake needle wash solution from container to the autosampler.",
			Category->"Instrument Specifications"
		},
		EluentGeneratorInletSolutionCap->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Item,Cap][IonChromatographySystem]|Object[Plumbing,AspirationCap][IonChromatographySystem],
			Description->"The aspiration cap used to uptake EluentGeneratorInletSolution from the container to the instrument pump.",
			Category->"Instrument Specifications"
		},
		BufferACap->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Item,Cap][IonChromatographySystem]|Object[Plumbing,AspirationCap][IonChromatographySystem],
			Description->"The aspiration cap used to uptake Buffer A from Buffer container to the instrument pump.",
			Category->"Instrument Specifications"
		},
		BufferBCap->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Item,Cap][IonChromatographySystem]|Object[Plumbing,AspirationCap][IonChromatographySystem],
			Description->"The aspiration cap used to uptake Buffer B from buffer container to the instrument pump.",
			Category->"Instrument Specifications"
		},
		BufferCCap->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Item,Cap][IonChromatographySystem]|Object[Plumbing,AspirationCap][IonChromatographySystem],
			Description->"The aspiration cap used to uptake Buffer C from Buffer container to the instrument pump.",
			Category->"Instrument Specifications"
		},
		BufferDCap->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Item,Cap][IonChromatographySystem]|Object[Plumbing,AspirationCap][IonChromatographySystem],
			Description->"The aspiration cap used to uptake Buffer D from buffer container to the instrument pump.",
			Category->"Instrument Specifications"
		},
		NeedleWashSolutionCap->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Item,Cap][IonChromatographySystem]|Object[Plumbing,AspirationCap][IonChromatographySystem],
			Description->"The aspiration cap used to uptake needle wash solution from container to the autosampler.",
			Category->"Instrument Specifications"
		},
		EluentGeneratorInletSolutionReservoir->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container,Vessel],
			Description->"The container that holds reservoir liquid for eluent generator inlet solution.",
			Category->"Instrument Specifications",
			Developer->True
		},
		BufferAReservoir->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container, Vessel],
			Description->"The container that holds reservoir liquid for Buffer A.",
			Category->"Instrument Specifications",
			Developer->True
		},
		BufferBReservoir->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container, Vessel],
			Description->"The container that holds reservoir liquid for Buffer B.",
			Category->"Instrument Specifications",
			Developer->True
		},
		BufferCReservoir->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container, Vessel],
			Description->"The container that holds reservoir liquid for Buffer C.",
			Category->"Instrument Specifications",
			Developer->True
		},
		BufferDReservoir->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container, Vessel],
			Description->"The container that holds reservoir liquid for Buffer D.",
			Category->"Instrument Specifications",
			Developer->True
		},
		NeedleWashSolutionReservoir->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container, Vessel],
			Description->"The container that holds reservoir liquid for needle wash solution.",
			Category->"Instrument Specifications",
			Developer->True
		},

		(* --- Operating Limits --- *)
		MinSampleVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Micro*Liter],
			Units->Liter Micro,
			Description->"The minimum sample volume required for a single run.",
			Category->"Operating Limits",
			Abstract->True
		},
		MaxSampleVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Micro*Liter],
			Units->Liter Micro,
			Description->"The maximum sample volume that that can be injected in a single run.",
			Category->"Operating Limits",
			Abstract->True
		},
		MinSampleTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Kelvin],
			Units->Celsius,
			Description->"The minimum possible temperature of the chamber where the samples are stored. Null indicates that temperature control for the sample chamber is not possible.",
			Category->"Operating Limits",
			Abstract->True
		},
		MaxSampleTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Kelvin],
			Units->Celsius,
			Description->"The maximum possible temperature of the chamber where the samples are stored. Null indicates that temperature control for the sample chamber is not possible.",
			Category->"Operating Limits",
			Abstract->True
		},
		MinFlowRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[(0*Milli*Liter)/Minute],
			Units->(Liter Milli)/Minute,
			Description->"The minimum flow rate at which the instrument can pump Buffer through the system.",
			Category->"Operating Limits",
			Abstract->True
		},
		MaxFlowRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[(0*Milli*Liter)/Minute],
			Units->(Liter Milli)/Minute,
			Description->"The maximum flow rate at which the instrument can pump Buffer through the system absent any pressure limitations.",
			Category->"Operating Limits",
			Abstract->True
		},
		AnionMinColumnTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Kelvin],
			Units->Celsius,
			Description->"The minimum temperature at which the column oven can incubate for anion channel.",
			Category->"Operating Limits",
			Abstract->True
		},
		CationMinColumnTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Kelvin],
			Units->Celsius,
			Description->"The minimum temperature at which the column oven can incubate for cation channel.",
			Category->"Operating Limits",
			Abstract->True
		},
		MinColumnTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Kelvin],
			Units->Celsius,
			Description->"The minimum temperature at which the column oven can incubate.",
			Category->"Operating Limits",
			Abstract->True
		},
		AnionMaxColumnTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Kelvin],
			Units->Celsius,
			Description->"The maximum temperature at which the column oven can incubate for anion channel.",
			Category->"Operating Limits",
			Abstract->True
		},
		CationMaxColumnTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Kelvin],
			Units->Celsius,
			Description->"The maximum temperature at which the column oven can incubate for cation channel.",
			Category->"Operating Limits",
			Abstract->True
		},
		MaxColumnTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Kelvin],
			Units->Celsius,
			Description->"The maximum temperature at which the column oven can incubate.",
			Category->"Operating Limits",
			Abstract->True
		},
		AnionMaxColumnLength->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Milli*Meter],
			Units-> Meter Milli,
			Description->"The maximum column length that can be accommodated inside of the column oven for anion channel.",
			Category->"Operating Limits"
		},
		CationMaxColumnLength->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Milli*Meter],
			Units-> Meter Milli,
			Description->"The maximum column length that can be accommodated inside of the column oven for cation channel.",
			Category->"Operating Limits"
		},
		MaxColumnLength->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Milli*Meter],
			Units-> Meter Milli,
			Description->"The maximum column length that can be accommodated inside of the column oven.",
			Category->"Operating Limits"
		},
		AnionMaxColumnOutsideDiameter->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Milli*Meter],
			Units->Meter Milli,
			Description->"The maximum column outside diameter that can be accommodated inside of the detector/chromatography module for anion channel.",
			Category->"Operating Limits"
		},
		CationMaxColumnOutsideDiameter->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Milli*Meter],
			Units->Meter Milli,
			Description->"The maximum column outside diameter that can be accommodated inside of the detector/chromatography module for cation channel.",
			Category->"Operating Limits"
		},
		MaxColumnOutsideDiameter->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Milli*Meter],
			Units->Meter Milli,
			Description->"The maximum column outside diameter that can be accommodated inside of the detector/chromatography module.",
			Category->"Operating Limits"
		},
		MinPressure->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*PSI],
			Units->PSI,
			Description->"The minimum pressure at which the instrument can operate.",
			Category->"Operating Limits"
		},
		AnionPumpMinPressure->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*PSI],
			Units->PSI,
			Description->"The minimum pressure at which the pump can operate for anion channel.",
			Category->"Operating Limits"
		},
		AnionPumpMaxPressure->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*PSI],
			Units->PSI,
			Description->"The maximum pressure at which the pump can operate for anion channel.",
			Category->"Operating Limits"
		},
		CationPumpMinPressure->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*PSI],
			Units->PSI,
			Description->"The minimum pressure at which the pump can operate for cation channel.",
			Category->"Operating Limits"
		},
		CationPumpMaxPressure->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*PSI],
			Units->PSI,
			Description->"The maximum pressure at which the pump can operate for cation channel.",
			Category->"Operating Limits"
		},
		PumpMinPressure->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*PSI],
			Units->PSI,
			Description->"The minimum pressure at which the pump can operate.",
			Category->"Operating Limits"
		},
		PumpMaxPressure->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*PSI],
			Units->PSI,
			Description->"The maximum pressure at which the pump can operate.",
			Category->"Operating Limits"
		},
		TubingMaxPressure->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*PSI],
			Units->PSI,
			Description->"The maximum pressure the tubing in the sample flow path can tolerate.",
			Category->"Operating Limits"
		},
		AnionMinDetectionTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Kelvin],
			Units->Celsius,
			Description->"The minimum temperature at which the detector can incubate for anion channel.",
			Category->"Operating Limits",
			Abstract->True
		},
		CationMinDetectionTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Kelvin],
			Units->Celsius,
			Description->"The minimum temperature at which the detector can incubate for cation channel.",
			Category->"Operating Limits",
			Abstract->True
		},
		MinDetectionTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Kelvin],
			Units->Celsius,
			Description->"The minimum temperature at which the detector can incubate.",
			Category->"Operating Limits",
			Abstract->True
		},
		AnionMaxDetectionTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Kelvin],
			Units->Celsius,
			Description->"The maximum temperature at which the detector can incubate for anion channel.",
			Category->"Operating Limits",
			Abstract->True
		},
		CationMaxDetectionTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Kelvin],
			Units->Celsius,
			Description->"The maximum temperature at which the detector can incubate for cation channel.",
			Category->"Operating Limits",
			Abstract->True
		},
		MaxDetectionTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Kelvin],
			Units->Celsius,
			Description->"The maximum temperature at which the detector can incubate.",
			Category->"Operating Limits",
			Abstract->True
		},
		MinAbsorbanceWavelength->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Nano*Meter],
			Units->Meter Nano,
			Description->"The minimum wavelength that the absorbance detector can monitor.",
			Category->"Operating Limits",
			Abstract->True
		},
		MaxAbsorbanceWavelength->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Nano*Meter],
			Units->Meter Nano,
			Description->"The Maximum wavelength that the absorbance detector can monitor.",
			Category->"Operating Limits",
			Abstract->True
		},
		AbsorbanceWavelengthBandpass->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Nano*Meter],
			Units->Meter Nano,
			Description->"The range of wavelengths centered around the desired wavelength that the absorbance detector will measure. For e.g. if the bandpass is 10nm and the desired measurement wavelength is 260nm, the detector will measure wavelengths from 255nm - 265nm.",
			Category->"Operating Limits"
		},
		MinDetectionVoltage->{
			Format->Single,
			Class->Real,
			Pattern:>VoltageP,
			Units->Volt,
			Description->"The minimum potential different that the electrochemical detector can supply.",
			Category->"Operating Limits"
		},
		MaxDetectionVoltage->{
			Format->Single,
			Class->Real,
			Pattern:>VoltageP,
			Units->Volt,
			Description->"The maximum potential different that the electrochemical detector can supply.",
			Category->"Operating Limits"
		},
		MinFlowCellpH->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0,14],
			Description->"The minimum pH value that the electrochemical detector can monitor.",
			Category->"Operating Limits"
		},
		MaxFlowCellpH->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0,14],
			Description->"The maximum pH value that the electrochemical detector can monitor.",
			Category->"Operating Limits"
		},
		
		(* --- Dimensions & Positions --- *)
		AutosamplerDeck->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container, Deck][Instruments],
			Description->"The platform from which samples are robotically aspirated and injected onto the column.",
			Category->"Dimensions & Positions"
		},
		BufferDeck->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container, Deck][Instruments],
			Description->"The platform which contains the liquids that are used as Buffers/solvents for elution by the instrument.",
			Category->"Dimensions & Positions"
		},
		WashBufferDeck->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container, Deck][Instruments],
			Description->"The platform which contains solvents used to flush and clean the fluid lines of the instrument.",
			Category->"Dimensions & Positions"
		},
		ColumnCapRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Rack],
			Description -> "The rack which contains the column caps and joins while the columns themselves are being used by the instrument.",
			Category -> "Dimensions & Positions"
		},
		
		(* --- Qualifications & Maintenance---*)
		AutomaticWasteEvacuation->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if the pump specified in the WastePump field will be remotely activated to evacuate waste on a schedule of once every hour for 5 minutes.",
			Category->"Qualifications & Maintenance",
			Developer->True
		},
		AnionSystemPrimeLog->{
			Format->Multiple,
			Class->{Date, Link, Link},
			Pattern:>{_?DateObjectQ, _Link, _Link},
			Relation->{Null,Object[Data], Object[Protocol]},
			Description->"A historical record of chromatography data generated for the system prime runs on this instrument for anion channel.",
			Category->"Qualifications & Maintenance",
			Headers->{"Date", "Chromatogram", "Protocol"}
		},
		CationSystemPrimeLog->{
			Format->Multiple,
			Class->{Date, Link, Link},
			Pattern:>{_?DateObjectQ, _Link, _Link},
			Relation->{Null,Object[Data], Object[Protocol]},
			Description->"A historical record of chromatography data generated for the system prime runs on this instrument for cation channel.",
			Category->"Qualifications & Maintenance",
			Headers->{"Date", "Chromatogram", "Protocol"}
		},
		SystemPrimeLog->{
			Format->Multiple,
			Class->{Date, Link, Link},
			Pattern:>{_?DateObjectQ, _Link, _Link},
			Relation->{Null,Object[Data], Object[Protocol]},
			Description->"A historical record of chromatography data generated for the system prime runs on this instrument.",
			Category->"Qualifications & Maintenance",
			Headers->{"Date", "Chromatogram", "Protocol"}
		},
		AnionSystemFlushLog->{
			Format->Multiple,
			Class->{Date, Link, Link},
			Pattern:>{_?DateObjectQ, _Link, _Link},
			Relation->{Null, Object[Data], Object[Protocol]},
			Description->"A historical record of chromatography data generated for the system flush runs on this instrument for anion channel.",
			Category->"Qualifications & Maintenance",
			Headers->{"Date", "Chromatogram", "Protocol"}
		},
		CationSystemFlushLog->{
			Format->Multiple,
			Class->{Date, Link, Link},
			Pattern:>{_?DateObjectQ, _Link, _Link},
			Relation->{Null, Object[Data], Object[Protocol]},
			Description->"A historical record of chromatography data generated for the system flush runs on this instrument for cation channel.",
			Category->"Qualifications & Maintenance",
			Headers->{"Date", "Chromatogram", "Protocol"}
		},
		SystemFlushLog->{
			Format->Multiple,
			Class->{Date, Link, Link},
			Pattern:>{_?DateObjectQ, _Link, _Link},
			Relation->{Null, Object[Data], Object[Protocol]},
			Description->"A historical record of chromatography data generated for the system flush runs on this instrument.",
			Category->"Qualifications & Maintenance",
			Headers->{"Date", "Chromatogram", "Protocol"}
		},
		WorkingElectrodeLog->{
			Format->Multiple,
			Class->{Date,Link,Link},
			Pattern:>{_?DateObjectQ,_Link,_Link},
			Relation->{Null,Object[Item,Electrode],Object[Protocol]},
			Description->"A historical record of working electrodes that has been installed and used on this instrument.",
			Category->"Qualifications & Maintenance",
			Headers->{"Date","Working Electrode","Protocol"}
		},
		ReferenceElectrodeLog->{
			Format->Multiple,
			Class->{Date,Link,Link},
			Pattern:>{_?DateObjectQ,_Link,_Link},
			Relation->{Null,Object[Part,ReferenceElectrode],Object[Protocol]},
			Description->"A historical record of reference electrodes that has been installed and used on this instrument.",
			Category->"Qualifications & Maintenance",
			Headers->{"Date","Reference Electrode","Maintenance Protocol"}
		},
		FlowCellLog->{
			Format->Multiple,
			Class->{Date,Link,Link},
			Pattern:>{_?DateObjectQ,_Link,_Link},
			Relation->{Null,Object[Part,FlowCell],Object[Maintenance]},
			Description->"A historical record of flow cells that has been installed on this instrument.",
			Category->"Qualifications & Maintenance",
			Headers->{"Date","Flow Cell","Maintenance Protocol"}
		},

		(* Sensors *)
		EluentGeneratorInletSolutionBottleSensor->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sensor,Volume],
			Description->"The ultrasonic liquid level sensor used to assess eluent generator inlet solution volumes in bottles.",
			Category->"Sensor Information"
		},
		BufferABottleSensor->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sensor, Volume],
			Description->"The ultrasonic liquid level sensor used to assess Buffer A volumes in bottles.",
			Category->"Sensor Information"
		},
		BufferBBottleSensor->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sensor, Volume],
			Description->"The ultrasonic liquid level sensor used to assess Buffer B volumes in bottles.",
			Category->"Sensor Information"
		},
		BufferCBottleSensor->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sensor, Volume],
			Description->"The ultrasonic liquid level sensor used to assess Buffer C volumes in bottles.",
			Category->"Sensor Information"
		},
		BufferDBottleSensor->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sensor, Volume],
			Description->"The ultrasonic liquid level sensor used to assess Buffer D volumes in bottles.",
			Category->"Sensor Information"
		},
		NeedleWashSolutionBottleSensor->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sensor, Volume],
			Description->"The ultrasonic liquid level sensor used to assess needle wash solution volumes in bottles.",
			Category->"Sensor Information"
		}
	}
}];
