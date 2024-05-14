

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, FPLC], {
	Description->"The model for a fast protein liquid chromatography instrument that is used to analyze or purify mixtures of biomolecules.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Detectors -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ChromatographyDetectorTypeP,
			Description -> "A list of the available chromatographic detectors on the instrument.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		DetectorLampType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> LampTypeP,
			Description -> "A list of sources of illumination available for use in detection.",
			Category -> "Instrument Specifications"
		},
		AbsorbanceDetector -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> OpticalDetectorP,
			Description -> "The type of detector available to measure the absorbance.",
			Category -> "Instrument Specifications"
		},
		AbsorbanceFilterType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WavelengthSelectionTypeP,
			Description -> "The type of wavelength selection available for absorbance measurement.",
			Category -> "Instrument Specifications"
		},
		AutosamplerDeckModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container,Deck],
			Description -> "The model of container used to house samples.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		AutosamplerTubingDeadVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The total volume of the tubes that connect the ends of the sample loop in the autosampler to the injection valve of the FPLC instrument.",
			Category -> "Instrument Specifications"
		},
		BufferDeckModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container,Deck],
			Description -> "The model of container used to house buffers.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		Mixer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ChromatographyMixerTypeP,
			Description -> "The type of mixer the pump uses to generate the gradient.",
			Category -> "Instrument Specifications"
		},
		DefaultMixer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part,Mixer]
			],
			Description -> "The typical homogenization chamber in the device.",
			Category -> "General"
		},
		SampleLoop -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The maximum volume of sample that should be loaded in the injection loop, before it is transferred into the flow path.",
			Category -> "Instrument Specifications"
		},
		DelayVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The tubing volume between the detector and the fraction collector head.",
			Category -> "Instrument Specifications"
		},
		DelayLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Centi*Meter],
			Units -> Centi Meter,
			Description -> "The length of tubing between the detector and the fraction collector.",
			Category -> "Instrument Specifications"
		},
		FlowCellVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The volume of the instrument's detector's flow cell.",
			Category -> "Instrument Specifications"
		},
		FlowCellPathLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The pathlength of instrument's detector's flow cell.",
			Category -> "Instrument Specifications"
		},
		TubingInnerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The diameter of the tubing in the flow path.",
			Category -> "Instrument Specifications"
		},
		ColumnConnector -> {
			Format -> Multiple,
			Class -> {Expression, String, Expression, Expression, Real, Real},
			Pattern :> {ConnectorP, ThreadP, MaterialP, ConnectorGenderP, GreaterEqualP[0*Milli*Meter], GreaterEqualP[0*Milli*Meter]},
			Units -> {None, None, None, None, Meter Milli, Meter Milli},
			Description -> "The connector on the instrument to which a column will be attached to.",
			Headers -> {"Connector Type", "Thread Type", "Material", "Gender", "Inner Diameter", "Outer Diameter"},
			Category -> "Instrument Specifications"
		},
		MinSampleVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The minimum volume that can be loaded on a single injection.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxSampleVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The maximum volume that can be loaded on a single injection.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Milli*Liter)/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "The minimum flow rate at which the instrument can pump buffer through the system.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Milli*Liter)/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "The maximum flow rate at which the instrument can pump buffer through the system.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinAbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The minimum wavelength that the detector's monochromator can be set to for absorbance filtering.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxAbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The maximum wavelength that the detector's monochromator can be set to for absorbance filtering.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		AbsorbanceWavelengthBandpass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The range of wavelengths centered around the desired wavelength that the absorbance detector will measure. For e.g. if the bandpass is 10nm and the desired measurement wavelength is 260nm, the detector will measure wavelengths from 255nm - 265nm.",
			Category -> "Operating Limits"
		},
		MinPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PSI],
			Units -> PSI,
			Description -> "The minimum pressure at which the instrument can operate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		TubingMaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The maximum pressure the tubing in the sample flow path can tolerate.",
			Category -> "Operating Limits"
		},
		PumpMaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The maximum pressure that the pump can tolerate.",
			Category -> "Operating Limits"
		},
		FlowCellMaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PSI],
			Units -> PSI,
			Description -> "The maximum pressure the detector's flow cell can tolerate.",
			Category -> "Operating Limits"
		},
		SystemPrimeGradients -> {
			Format -> Multiple,
			Class -> {Expression,Link},
			Pattern :> {SeparationModeP,_Link},
			Relation -> {Null,Object[Method]},
			Description -> "List of the gradients used to purge the instrument lines at the start of an FPLC protocol for each chromatography type.",
			Category -> "Instrument Specifications",
			Abstract -> True,
			Headers->{"Chromatography Type","Gradient Method"}
		},
		SystemFlushGradients -> {
			Format -> Multiple,
			Class -> {Expression,Link},
			Pattern :> {SeparationModeP,_Link},
			Relation -> {Null,Object[Method]},
			Description -> "List of the gradients used to purge the instrument lines at the end of an FPLC protocol for each chromatography type.",
			Category -> "Instrument Specifications",
			Abstract -> True,
			Headers->{"Chromatography Type","Gradient Method"}
		}
	}
}];
