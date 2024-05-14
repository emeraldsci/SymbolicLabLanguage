(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, FPLC], {
	Description->"A Fast Protein Liquid Chromatography (FPLC) instrument that is used to analyze or purify mixtures of proteins.",
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
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part,Mixer][FPLC]
			],
			Description -> "A module used to homogenize liquid passing through.",
			Category -> "Instrument Specifications"
		},
		ColumnJoins -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Plumbing, ColumnJoin]
			],
			Description -> "Column joins that stay installed on the instrument.",
			Category -> "Instrument Specifications"
		},
		AutosamplerTubingDeadVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],AutosamplerTubingDeadVolume]],
			Pattern :> GreaterEqualP[0 Milliliter],
			Description -> "The total volume of the tubes that connect the ends of the sample loop in the autosampler to the injection valve of the FPLC instrument.",
			Category -> "Instrument Specifications"
		},
		SampleLoop -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],SampleLoop]],
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Description -> "The maximum volume of sample that can fit in the injection loop, before it is transferred into the flow path.",
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
		FlowCell -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part,FlowCell][FPLC]
			],
			Description -> "The default part where absorbance is measured for the mobile phase.",
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
			Pattern :> GreaterP[(0*Milli*Liter)/Minute],
			Description -> "The minimum flow rate at which the instrument can pump buffer through the system.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxFlowRate]],
			Pattern :> GreaterP[(0*Milli*Liter)/Minute],
			Description -> "The maximum flow rate at which the instrument can pump buffer through the system.",
			Category -> "Operating Limits",
			Abstract -> True
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
			Description -> "The range of wavelengths centered around the desired wavelength that the absorbance detector will measure. For e.g. if the bandpass is 10nm and the desired measurement wavelength is 260nm, the detector will measure wavelengths from 255nm - 265nm.",
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
			Description -> "The maximum pressure that the pump can tolerate.",
			Category -> "Operating Limits"
		},
		FlowCellMaxPressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],FlowCellMaxPressure]],
			Pattern :> GreaterEqualP[0*PSI],
			Description -> "The maximum pressure the detector's flow cell can tolerate.",
			Category -> "Operating Limits"
		},
		AutosamplerDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "The platform from which samples are robotically aspirated and injected onto the column.",
			Category -> "Dimensions & Positions"
		},
		BufferDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container, Deck][Instruments],
				Object[Container]
			],
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
		WashFluidDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "The platform which contains solvents used to flush and clean the fluid lines of the instrument.",
			Category -> "Dimensions & Positions"
		},
		ColumnCapRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Rack],
			Description -> "The rack which contains the column caps and joins while the columns themselves are being used by the instrument.",
			Category -> "Dimensions & Positions"
		},
		BufferPumpWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The current solution used for the pump seals for the buffer inlet.",
			Category -> "Cleaning",
			Developer -> True
		},
		BufferPumpWashLog -> {
			Format -> Multiple,
			Class -> {Expression, Link, Expression, Link},
			Pattern :> {_?DateObjectQ, _Link, In | Out, _Link},
			Relation -> {Null, Object[Sample] , Null, Object[User] | Object[Qualification] | Object[Maintenance] | Object[Protocol]},
			Description -> "A history of changes made to the instrument's BufferPumpWashSolution.",
			Headers -> {"Date","Sample","Status","Responsible Party"},
			Category -> "Organizational Information",
			Developer -> True
		},
		SamplePumpWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The current solution used for the pump seals for the sample inlet.",
			Category -> "Cleaning",
			Developer -> True
		},
		SamplePumpWashLog -> {
			Format -> Multiple,
			Class -> {Expression, Link, Expression, Link},
			Pattern :> {_?DateObjectQ, _Link, In | Out, _Link},
			Relation -> {Null, Object[Sample] , Null, Object[User] | Object[Qualification] | Object[Maintenance] | Object[Protocol]},
			Description -> "A history of changes made to the instrument's SamplePumpWashSolution.",
			Headers -> {"Date","Sample","Status","Responsible Party"},
			Category -> "Cleaning",
			Developer -> True
		},
		PumpSealReplacementLog -> {
			Format -> Multiple,
			Class -> {Expression, Link, Expression, Link},
			Pattern :> {_?DateObjectQ, _Link, LCPumpP, _Link},
			Relation -> {Null, Object[Item] , Null, Object[User] | Object[Qualification] | Object[Maintenance] | Object[Protocol]},
			Description -> "A history of changes made to the instrument's seals.",
			Headers -> {"Date","Seal Kit","Pump Changed","Responsible Party"},
			Category -> "Cleaning",
			Developer -> True
		},
		BufferLineReservoir -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The container in which the buffer caps of this instrument should be stored in when the instrument is not running.",
			Category -> "Cleaning",
			Developer -> True
		},
		SampleInlet1 -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][FPLC]|Object[Plumbing, Tubing],
			Description -> "The tubing used to draw sample directly into the system in position 1.",
			Category -> "Instrument Specifications"
		},
		SampleInlet2 -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][FPLC]|Object[Plumbing, Tubing],
			Description -> "The tubing used to draw sample directly into the system in position 2.",
			Category -> "Instrument Specifications"
		},
		SampleInlet3 -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][FPLC]|Object[Plumbing, Tubing],
			Description -> "The tubing used to draw sample directly into the system in position 3.",
			Category -> "Instrument Specifications"
		},
		SampleInlet4 -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][FPLC]|Object[Plumbing, Tubing],
			Description -> "The tubing used to draw sample directly into the system in position 4.",
			Category -> "Instrument Specifications"
		},
		SampleInlet5 -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][FPLC]|Object[Plumbing, Tubing],
			Description -> "The tubing used to draw sample directly into the system in position 5.",
			Category -> "Instrument Specifications"
		},
		BufferInletA1 -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][FPLC]|Object[Plumbing, Tubing],
			Description -> "The buffer A1 inlet tubing used to uptake buffer A from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferInletA2 -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][FPLC]|Object[Plumbing, Tubing],
			Description -> "The buffer A2 inlet tubing used to uptake buffer A from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferInletA3 -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][FPLC]|Object[Plumbing, Tubing],
			Description -> "The buffer A3 inlet tubing used to uptake buffer A from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferInletA4 -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][FPLC]|Object[Plumbing, Tubing],
			Description -> "The buffer A4 inlet tubing used to uptake buffer A from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferInletB1 -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][FPLC]|Object[Plumbing, Tubing],
			Description -> "The buffer B1 inlet tubing used to uptake buffer B from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferInletB2 -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][FPLC]|Object[Plumbing, Tubing],
			Description -> "The buffer B2 inlet tubing used to uptake buffer B from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferInletB3 -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][FPLC]|Object[Plumbing, Tubing],
			Description -> "The buffer B3 inlet tubing used to uptake buffer A from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferInletB4 -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][FPLC]|Object[Plumbing, Tubing],
			Description -> "The buffer B4 inlet tubing used to uptake buffer A from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferACap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item,Cap][FPLC],
				Object[Plumbing,AspirationCap][FPLC]
			],
			Description -> "The aspiration cap used to uptake buffer A from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferBCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item,Cap][FPLC],
				Object[Plumbing,AspirationCap][FPLC]
			],
			Description -> "The aspiration cap used to uptake buffer B from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},


		(* Sensors *)
		BufferA1CarboySensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer A1 volumes in carboys.",
			Category -> "Sensor Information"
		},
		BufferA1BottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer A1 volumes in bottles.",
			Category -> "Sensor Information"
		},
		BufferA2CarboySensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer A2 volumes in carboys.",
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
		BufferA3CarboySensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer A3 volumes in carboys.",
			Category -> "Sensor Information"
		},
		BufferA3BottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer A3 volumes in bottles.",
			Category -> "Sensor Information"
		},
		BufferA4CarboySensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer A4 volumes in carboys.",
			Category -> "Sensor Information"
		},
		BufferA4BottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer A4 volumes in bottles.",
			Category -> "Sensor Information"
		},
		BufferB1CarboySensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer B1 volumes in carboys.",
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
		BufferB2CarboySensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer B2 volumes in carboys.",
			Category -> "Sensor Information"
		},
		BufferB2BottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer B2 volumes in bottles.",
			Category -> "Sensor Information"
		},
		BufferB3CarboySensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer B3 volumes in carboys.",
			Category -> "Sensor Information"
		},
		BufferB3BottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer B3 volumes in bottles.",
			Category -> "Sensor Information"
		},
		BufferB4CarboySensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer B4 volumes in carboys.",
			Category -> "Sensor Information"
		},
		BufferB4BottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer B4 volumes in bottles.",
			Category -> "Sensor Information"
		},
		WastePump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, VacuumPump][FPLC],
			Description -> "Vacuum pump that drains waste liquid into the carboy.",
			Category -> "Instrument Specifications"
		},
		Sample1TubeSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Sample 1 volumes in tubes.",
			Category -> "Sensor Information"
		},
		Sample1BottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Sample 1 volumes in bottles.",
			Category -> "Sensor Information"
		},
		Sample2TubeSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Sample 2 volumes in tubes.",
			Category -> "Sensor Information"
		},
		Sample2BottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Sample 2 volumes in bottles.",
			Category -> "Sensor Information"
		},
		Sample3TubeSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Sample 3 volumes in tubes.",
			Category -> "Sensor Information"
		},
		Sample3BottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Sample 3 volumes in bottles.",
			Category -> "Sensor Information"
		},
		Sample4TubeSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Sample 4 volumes in tubes.",
			Category -> "Sensor Information"
		},
		Sample4BottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Sample 4 volumes in bottles.",
			Category -> "Sensor Information"
		},
		Sample5TubeSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Sample 5 volumes in tubes.",
			Category -> "Sensor Information"
		},
		Sample5BottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Sample 5 volumes in bottles.",
			Category -> "Sensor Information"
		}
	}
}];
