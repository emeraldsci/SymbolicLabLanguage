(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Diffractometer], {
	Description -> "Model of a diffractometer instrument that analyzes the structure of a material from the scattering of radiation.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* --- Instrument specifications --- *)
		RadiationType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DiffractionRadiationTypeP,
			Description -> "The type of radiation used by this model of instrument to irradiate the samples to and obtain a diffraction pattern.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		AnodeMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MetalP,
			Description -> "The material of which the anode that generates the radiation is made.",
			Category -> "Instrument Specifications"
		},
		Wavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Angstrom],
			Units -> Angstrom,
			Description -> "The wavelength of the radiation generated by this model of instrument.",
			Category -> "Instrument Specifications"
		},
		DiffractionDetector -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> OpticalDetectorP,
			Description -> "The type of detector available to measure the diffraction pattern.",
			Category -> "Instrument Specifications"
		},
		DetectorPixelSize -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micrometer],
			Units -> Micrometer,
			Description -> "The size of each pixel on the detector.",
			Category -> "Instrument Specifications"
		},
		DetectorDimensions -> {
			Format -> Single,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0*Millimeter], GreaterEqualP[0*Millimeter]},
			Units -> {Millimeter, Millimeter},
			Headers -> {"Detector Width", "Detector Height"},
			Description -> "Dimensions of the active detector's surface for this model of instrument.",
			Category -> "Instrument Specifications"
		},
		NumberOfDetectorModules -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer,
			Description -> "The number of separate detector modules that together comprise the detector surface.",
			Category -> "Instrument Specifications"
		},
		DetectorModuleGapDistance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[0*Millimeter],
			Units -> Millimeter,
			Description -> "The distance between the detector modules on the detector surface.  This will area will appear as a gap on the diffraction pattern.",
			Category -> "Instrument Specifications"
		},
		Chiller -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part,Chiller][Instrument],
			Description -> "The model of recirculating water chiller used to cool this diffractometer.",
			Category -> "Instrument Specifications"
		},
		ExperimentTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> XRDExperimentTypeP,
			Description -> "Indicates the types of X-ray experiments that may be performed on this instrument.",
			Category -> "Instrument Specifications"
		},

		(* --- Operating Limits --- *)
		MinTheta -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[-180*AngularDegree],
			Units -> AngularDegree,
			Description -> "The minimum 2theta scattering angle that can be measured by this model of instrument.",
			Category -> "Operating Limits"
		},
		MaxTheta -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[-180*AngularDegree],
			Units -> AngularDegree,
			Description -> "The maximum 2theta scattering angle that can be measured by this model of instrument.",
			Category -> "Operating Limits"
		},
		MinDetectorDistance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Millimeter],
			Units -> Millimeter,
			Description -> "The minimum distance the detector can be from the sample.",
			Category -> "Operating Limits"
		},
		MaxDetectorDistance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Millimeter],
			Units -> Millimeter,
			Description -> "The maximum distance the detector can be from the sample.",
			Category -> "Operating Limits"
		},
		MaxBeamPower -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Watt],
			Units -> Watt,
			Description -> "The maximum beam power this instrument uses to generate the diffracting radiation.",
			Category -> "Operating Limits"
		},
		MaxVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Volt,
			Description -> "The maximum voltage this instrument uses to generate the diffracting radiation.",
			Category -> "Operating Limits"
		},
		MaxCurrent -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Ampere],
			Units -> Ampere,
			Description -> "The maximum current this instrument uses to generate the diffracting radiation.",
			Category -> "Operating Limits"
		}
	}
}];
