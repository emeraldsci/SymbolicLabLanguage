

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, pHMeter], {
	Description->"The model of a device for high precision measurement of pH.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* --- Instrument Specifications ---*)
		NumberOfChannels -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of channels available for simultaneous measurements on the instrument.",
			Category -> "Instrument Specifications"
		},
		MeterModule -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part, MeterModule][Instrument],
			Description -> "The model of module part which can be installed on this meter to expand its capability.",
			Category -> "Instrument Specifications"
		},
		Resolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The smallest change in pH that corresponds to a change in displayed value. Also known as readability, increment, scale division.",
			Category -> "Instrument Specifications"
		},
		ManufacturerRepeatability -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The variation in measurements taken under the same conditions as reported by the manufacturer.",
			Category -> "Instrument Specifications"
		},
		TemperatureCorrection -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> pHTemperatureCorrectionP,
			Description -> "A list of available temperature correction options available for the device.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		AcquisitionTimeControl -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates whether the acquistion can be temporally controlled.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},

		Probes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part, pHProbe],
			Description -> "The parts associated with this instrument that directly perform the pH measurement.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		MinpHs -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Units -> None,
			Description -> "For each member of Probes, the minimum pH the probe can measure.",
			Category -> "Operating Limits",
			IndexMatching -> Probes,
			Abstract -> True
		},
		MaxpHs -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Units -> None,
			Description -> "For each member of Probes, the maximum pH the probe can measure.",
			Category -> "Operating Limits",
			IndexMatching -> Probes,
			Abstract -> True
		},
		ProbeLengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "For each member of Probes, the length of the straight part of the sensing probe for this pH meter.",
			Category -> "Dimensions & Positions",
			IndexMatching -> Probes,
			Abstract -> True
		},
		ProbeDiameters -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "For each member of Probes, the outside diameter of the sensing probe for this pH meter.",
			Category -> "Dimensions & Positions",
			IndexMatching -> Probes,
			Abstract -> True
		},
		ProbeTypes->{
			Format->Multiple,
			Class -> Expression,
			Pattern :>pHProbeTypeP,
			Description->"For each member of Probes, the manners in which the probe exposes its sensors to the sample.",
			IndexMatching -> Probes,
			Category -> "Instrument Specifications"
		},
		MinSampleVolumes->{
			Format->Multiple,
			Class -> Real,
			Pattern :>GreaterP[0*Milli*Liter],
			Units->Liter Milli,
			Description->"For each member of Probes, the minimum required sample volume needed for instrument measurement.",
			IndexMatching -> Probes,
			Category -> "Instrument Specifications"
		},
		MinDepths->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description->"For each member of Probes, the minimum required z distance that the probe needs to be submerged for measurement.",
			IndexMatching -> Probes,
			Category -> "Instrument Specifications"
		}
	}
}];
