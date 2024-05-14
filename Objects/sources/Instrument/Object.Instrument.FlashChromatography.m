

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, FlashChromatography], {
	Description->"A flash chromatography instrument (also called medium pressure liquid chromatography instrument) that separates mixtures of compounds, primarily for purification.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		Detectors -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Detectors]],
			Pattern :> {ChromatographyDetectorTypeP..},
			Description -> "A list of the available chromatographic detectors on the instrument.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		DetectorLampType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],DetectorLampType]],
			Pattern :> {LampTypeP..},
			Description -> "A list of sources of illumination available for use in detection.",
			Category -> "Instrument Specifications"
		},
		AbsorbanceDetector -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],AbsorbanceDetector]],
			Pattern :> OpticalDetectorP,
			Description -> "The type of detector available to measure the absorbance.",
			Category -> "Instrument Specifications"
		},
		AbsorbanceFilterType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],AbsorbanceFilterType]],
			Pattern :> WavelengthSelectionTypeP,
			Description -> "The type of wavelength selection available for absorbance measurement.",
			Category -> "Instrument Specifications"
		},
		Mixer -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Mixer]],
			Pattern :> ChromatographyMixerTypeP,
			Description -> "The type of mixer the pump uses to generate the gradient.",
			Category -> "Instrument Specifications"
		},
		DelayVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],DelayVolume]],
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Description -> "The tubing volume between the detector and the fraction collector head.",
			Category -> "Instrument Specifications"
		},
		DelayLength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],DelayLength]],
			Pattern :> GreaterEqualP[0*Centi*Meter],
			Description -> "The length of tubing between the detector and the fraction collector.",
			Category -> "Instrument Specifications"
		},
		FlowCellVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],FlowCellVolume]],
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Description -> "The volume of the instrument's detector's flow cell.",
			Category -> "Instrument Specifications"
		},
		FlowCellPathLength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],FlowCellPathLength]],
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Description -> "The pathlength of instrument's detector's flow cell.",
			Category -> "Instrument Specifications"
		},
		TubingInnerDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TubingInnerDiameter]],
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Description -> "The diameter of the tubing in the flow path.",
			Category -> "Instrument Specifications"
		},
		ColumnConnector -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ColumnConnector]],
			Pattern :> {{ConnectorP, ThreadP | NullP, MaterialP, ConnectorGenderP, GreaterEqualP[0*Milli*Meter] | NullP, GreaterEqualP[0*Milli*Meter] | NullP}..},
			Description -> "The connector on the instrument to which a column will be attached to, in the form: {connector type, thread type, material of connector, connector gender, inner diameter, outer diameter}.",
			Category -> "Instrument Specifications"
		},
		URL -> {
			Format -> Single,
			Class -> String,
			Pattern :> URLP,
			Description -> "The uniform resource locator (URL) through which this instrument can be controlled in a web browser.",
			Category -> "Instrument Specifications"
		},
		MinSampleVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinSampleVolume]],
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Description -> "The minimum volume that can be loaded on a single injection.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxSampleVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxSampleVolume]],
			Pattern :> GreaterP[0*Micro*Liter],
			Description -> "The maximum volume that can be loaded on a single injection.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinFlowRate]],
			Pattern :> GreaterEqualP[(0*Milli*Liter)/Minute],
			Description -> "The minimum flow rate at whch the instrument can pump buffer through the system.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxFlowRate]],
			Pattern :> GreaterP[(0*Milli*Liter)/Minute],
			Description -> "The maximum flow rate at whch the instrument can pump buffer through the system.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxColumnLength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxColumnLength]],
			Pattern :> GreaterP[0*Milli*Meter],
			Description -> "The maximum column length that can be accommodated by the instrument.",
			Category -> "Operating Limits"
		},
		MinPressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinPressure]],
			Pattern :> GreaterEqualP[0*PSI],
			Description -> "The minimum pressure at which the instrument can operate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		TubingMaxPressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TubingMaxPressure]],
			Pattern :> GreaterP[0*PSI],
			Description -> "The maximum pressure the tubing in the sample flow path can tolerate.",
			Category -> "Operating Limits"
		},
		PumpMaxPressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],PumpMaxPressure]],
			Pattern :> GreaterP[0*PSI],
			Description -> "The maximum pressure at which the pump can still operate.",
			Category -> "Operating Limits"
		},
		MinAbsorbanceWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinAbsorbanceWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The minimum wavelength that the detector's monochromator can be set to for absorbance filtering.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxAbsorbanceWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxAbsorbanceWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The maximum wavelength that the detector's monochromator can be set to for absorbance filtering.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		AbsorbanceWavelengthBandpass -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],AbsorbanceWavelengthBandpass]],
			Pattern :> GreaterEqualP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The range of wavelengths centered around the desired wavelength that the absorbance detector will measure. For e.g. if the bandpass is 10nm and the desired measurement wavelength is 260nm, the detecor will measure wavelenths from 255nm - 265nm.",
			Category -> "Operating Limits"
		},
		BufferDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "The platform which contains the liquids that are used as buffers/solvents for elution by the instrument.",
			Category -> "Dimensions & Positions"
		},
		FractionCollectorDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "The platform that houses containers into which the instrument will direct the fractions into individual wells robotically.",
			Category -> "Dimensions & Positions"
		},
		BufferA1Cap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item,Cap][FlashChromatography],
			Description -> "The aspiration cap used to uptake buffer A1 from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferA2Cap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item,Cap][FlashChromatography],
			Description -> "The aspiration cap used to uptake buffer A2 from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferB1Cap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item,Cap][FlashChromatography],
			Description -> "The aspiration cap used to uptake buffer B1 from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferB2Cap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item,Cap][FlashChromatography],
			Description -> "The aspiration cap used to uptake buffer B2 from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferA1BottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer A1 volumes in bottles.",
			Category -> "Sensor Information"
		},
		BufferA2BottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer A2 volumes in bottles.",
			Category -> "Sensor Information"
		},
		BufferB1BottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer B1 volumes in bottles.",
			Category -> "Sensor Information"
		},
		BufferB2BottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer B2 volumes in bottles.",
			Category -> "Sensor Information"
		}
	}
}];
