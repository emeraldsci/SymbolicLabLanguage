

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, FlashChromatography], {
	Description->"The model for a flash chromatography instrument (also called medium pressure liquid chromatography instrument) for medium pressure, high flow chromatographic separations.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Detectors -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ChromatographyDetectorTypeP, (* Absorbance *)
			Description -> "A list of the available chromatographic detectors on the instrument that measure properties of the separated sample as it moves through the flow path.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		DetectorLampType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> LampTypeP,
			Description -> "A list of sources of illumination available to shine through the flow path, enabling the measurement of absorption values from the separate sample.",
			Category -> "Instrument Specifications"
		},
		AbsorbanceDetector -> { (* CCDArray *)
			Format -> Single,
			Class -> Expression,
			Pattern :> OpticalDetectorP,
			Description -> "The type of detector available to measure the absorbance of light shown through the separated sample. Diode measures overall absorbance of light going through the flow path. CCDArray splits the light and measures the absorbance of different wavelengths with different pixels in an array.",
			Category -> "Instrument Specifications"
		},
		AbsorbanceFilterType -> { (* BandpassArray *)
			Format -> Single,
			Class -> Expression,
			Pattern :> WavelengthSelectionTypeP,
			Description -> "The method by which certain wavelengths of light are selected for absorbance measurement. Filter restricts the measured wavelengths to those that can pass through a filter. Monochrometer uses an optical device that dynamically restricts the measured wavelengths to a very narrow band. With Array, the light is split, different pixels in an array measure the absorbance of different wavelengths of light, and the measurements from each pixel are recorded. BandpassArray also splits the light as an array does, but only records average absorbance from pixels collecting specified wavelength ranges.",
			Category -> "Instrument Specifications"
		},
		Mixer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ChromatographyMixerTypeP,
			Description -> "The type of mixer the pump uses to combine buffers to generate the gradient. The mixer can be Dynamic: a stir bar or other actively powered process mixes the liquid coming from each source, or Static: the liquid is mixed by running the combined current through unmoving agitators.",
			Category -> "Instrument Specifications"
		},
		DelayVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The total volume of the tubing between the detector and the fraction collector head.",
			Category -> "Instrument Specifications"
		},
		DelayLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Centi*Meter],
			Units -> Centi Meter,
			Description -> "The total length of the tubing between the detector and the fraction collector.",
			Category -> "Instrument Specifications"
		},
		FlowCellVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The volume of the chamber in the instrument through which separated sample flows as it is exposed to the detector.",
			Category -> "Instrument Specifications"
		},
		FlowCellPathLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The distance that light from the lamp travels through the liquid sample prior to hitting the detector. By taking the logarithm of the ratio between the radiant power of light before and after it travels through the sample, we get the absorbance which is proportional to the path length and the concentration of the sample by Beer's law.",
			Category -> "Instrument Specifications"
		},
		TubingInnerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The diameter of the tubing in the flow path of the instrument except within the flow cell.",
			Category -> "Instrument Specifications"
		},
		MinSampleVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The minimum volume of liquid sample that can be loaded by injection into the instrument. Set by the lowest volume that can reasonably be injected into the sample injection assembly by a compatible syringe.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxSampleVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The maximum volume of liquid sample that can be loaded by injection into the instrument. Set by the highest volume of liquid sample that can be loaded into the largest model of column compatible with the instrument.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinSampleMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Gram],
			Units -> Gram,
			Description -> "The minimum mass of solid sample that can be loaded into the instrument through a solid sample cartridge. Set by the lowest mass of sample that can be manipulated into a solid sample cartridge.", (* Are there lower limits for solid sample transfers in ExperimentTransfer? *)
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxSampleMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "The maximum mass of solid sample that can be loaded into the instrument through a solid sample cartridge. Set by the highest mass of sample that can be loaded into the largest model of solid sample cartridge compatible with this instrument.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Milli*Liter)/Minute],
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
		CartridgeCapConnector -> {
			Format -> Multiple,
			Class -> {Expression, String, Expression, Expression, Real, Real},
			Pattern :> {ConnectorP, ThreadP, MaterialP, ConnectorGenderP, GreaterEqualP[0*Milli*Meter], GreaterEqualP[0*Milli*Meter]},
			Units -> {None, None, None, None, Meter Milli, Meter Milli},
			Description -> "The types of connectors on the instrument to which an adjustable solid load cartridge cap will be attached. In the form: {Connector Type, Thread Type, Material, Gender, Inner Diameter, Outer Diameter}.",
			Headers -> {"Connector Type", "Thread Type", "Material", "Gender", "Inner Diameter", "Outer Diameter"},
			Category -> "Instrument Specifications"
		},
		CartridgeConnector -> {
			Format -> Multiple,
			Class -> {Expression, String, Expression, Expression, Real, Real},
			Pattern :> {ConnectorP, ThreadP, MaterialP, ConnectorGenderP, GreaterEqualP[0*Milli*Meter], GreaterEqualP[0*Milli*Meter]},
			Units -> {None, None, None, None, Meter Milli, Meter Milli},
			Description -> "The types of connectors on the instrument to which a solid load cartridge will be attached. In the form: {Connector Type, Thread Type, Material, Gender, Inner Diameter, Outer Diameter}.",
			Headers -> {"Connector Type", "Thread Type", "Material", "Gender", "Inner Diameter", "Outer Diameter"},
			Category -> "Instrument Specifications"
		},
		ColumnConnector -> {
			Format -> Multiple,
			Class -> {Expression, String, Expression, Expression, Real, Real},
			Pattern :> {ConnectorP, ThreadP, MaterialP, ConnectorGenderP, GreaterEqualP[0*Milli*Meter], GreaterEqualP[0*Milli*Meter]},
			Units -> {None, None, None, None, Meter Milli, Meter Milli},
			Description -> "The types of connectors on the instrument to which a column will be attached. In the form: {Connector Type, Thread Type, Material, Gender, Inner Diameter, Outer Diameter}.",
			Headers -> {"Connector Type", "Thread Type", "Material", "Gender", "Inner Diameter", "Outer Diameter"},
			Category -> "Instrument Specifications"
		},
		MaxColumnDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The maximum diameter of the column that can be attached to the instrument. Set by the distance between the column connectors and the body of the instrument.",
			Category -> "Operating Limits"
		},
		MaxCartridgeCapDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The maximum diameter of cartridge cap that can be attached to the instrument. Set by the distance between the cartridge cap connectors and the body of the instrument.",
			Category -> "Operating Limits"
		},
		InjectionValveLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The length of the injection valve in the direction parallel to column and solid sample cartridge mounting.",
			Category -> "Operating Limits"
		},
		MaxInjectionAssemblyLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The maximum length of the combined injection assembly including a column, the injection valve, and an optional solid sample cartridge that the instrument can accommodate.",
			Category -> "Operating Limits"
		},
		MinPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PSI],
			Units -> PSI,
			Description -> "The minimum pressure at which the instrument can operate. Set by manufacturer software limits.",
			Category -> "Operating Limits"
		},
		SystemMaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The maximum pressure that the weakest link in the system's flow path can tolerate.",
			Category -> "Operating Limits"
		},
		PumpMaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The maximum pressure at which the pump can operate.",
			Category -> "Operating Limits"
		},
		MinAbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The minimum wavelength of light from which the instrument's detector can measure an absorbance value.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxAbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The maximum wavelength of light from which the instrument's detector can measure an absorbance value.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		AbsorbanceWavelengthBandpass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The range of wavelengths centered around the desired wavelength that the absorbance detector will measure. For example, if the bandpass is 10nm and the desired measurement wavelength is 260nm, the detector will measure the average absorbance from 255nm - 265nm.",
			Category -> "Operating Limits"
		}
	}
}];
