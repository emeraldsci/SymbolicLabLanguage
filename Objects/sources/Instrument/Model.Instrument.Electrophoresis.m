

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, Electrophoresis], {
	Description->"A model of a device which separates nucleic acids or proteins based on their charge and size.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		ExcitationFilters -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterP[0*Meter], GreaterP[0*Meter]},
			Units -> {Meter Nano, Meter Nano},
			Description -> "Fluorescent excitation filters available to the instrument. The first distance in the list is the Center Wavelength which is the midpoint between the wavelengths where transmittance is 50% (also defined as the Full Width at Half Maximum (FWHM))) of the filter. The second distance in the list is the bandwidth or FWHM of the filter.",
			Headers -> {"Center Wavelength", "Filter Bandwidth"},
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		EmissionFilters -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterP[0*Meter], GreaterP[0*Meter]},
			Units -> {Meter Nano, Meter Nano},
			Description -> "Fluorescent emission filters available to the instrument. The first distance in the list is the Center Wavelength which is the midpoint between the wavelengths where transmittance is 50% (also defined as the Full Width at Half Maximum (FWHM))) of the filter. The second distance in the list is the bandwidth or FWHM of the filter.",
			Category -> "Instrument Specifications",
			Headers -> {"Center Wavelength", "Filter Bandwidth"},
			Abstract -> True
		},
		MinVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter Micro,
			Description -> "The minimum volume that the liquid handler can transfer accurately.",
			Category -> "Operating Limits"
		},
		MaxVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter Micro,
			Description -> "The maximum volume that the liquid handler can transfer.",
			Category -> "Operating Limits"
		},
		MinVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?VoltageQ,
			Units -> Volt,
			Description -> "The minimum voltage that can be applied during sample separation.",
			Category -> "Operating Limits"
		},
		MaxVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "The maximum voltage that can be applied during sample separation.",
			Category -> "Operating Limits"
		},
		Capacity -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of electrophoresis cartridges that fit on the instrument.",
			Category -> "Operating Limits"
		},
		ElectrodeCleaningVessel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The container used to collect liquid run-off as the electrodes are cleaned for this model.",
			Category -> "Cleaning",
			Developer -> True
		},
		MaxLanes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The maximum number of lanes across all gels that can be run in a single PAGE experiment using this model of intrument.",
			Category -> "Operating Limits"
		},
		ImageScale -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*(Pixel / Centimeter)],
			Units -> Pixel / Centimeter,
			Description -> "The scale in pixels/centimeter relating pixels of the darkroom image to real world distance for the output data of this instrument.",
			Category -> "Data Processing"
		},
		LaneTop -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer,
			Units -> None,
			Description -> "The number of pixels from the top of an image of a PAGE gel taken by this model of instrument to the top of a given lane.",
			Category -> "Data Processing",
			Developer -> True
		},
		LaneBottom -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer,
			Units -> None,
			Description -> "The number of pixels from the top of an image of a PAGE gel taken by this model of instrument to the bottom of a given lane.",
			Category -> "Data Processing",
			Developer -> True
		},
		LaneWidth -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer,
			Units -> None,
			Description -> "Width of a given lane in number of pixels for an image in a PAGE gel taken by this model of instrument.",
			Category -> "Data Processing",
			Developer -> True
		},
		LaneSeparation -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer,
			Units -> None,
			Description -> "The number of pixels separating the center of one lane from the center of the next lane for an image of a PAGE gel taken by this model of instrument.",
			Category -> "Data Processing",
			Developer -> True
		},
		LaneCenter -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer,
			Units -> None,
			Description -> "The number of pixels from the left of an image of a PAGE gel taken by this model of instrumnet to the center of the first lane.",
			Category -> "Data Processing",
			Developer -> True
		}
	}
}];
