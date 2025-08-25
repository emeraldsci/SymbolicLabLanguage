(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Calibration, Conductivity], {
	Description->"A calibration for converting raw electrical signal(amperometric/potentiomeric) into the conductivity.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ConductivityProbe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part,ConductivityProbe],
			Description -> "The designated conductivity probe that this calibration is intended to service.",
			Category -> "Qualifications & Maintenance"
		},
		Temperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of Conductivity, the recorded temperature of the calibration standard during the course of the calibration.",
			Category -> "Qualifications & Maintenance",
			IndexMatching -> Conductivity
		},
		ReferenceTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The conductivity reading directly corrected to the set ReferenceTemperature. This is the temperature at which manufacturer calibration  was performed.", (**)
			Category -> "Qualifications & Maintenance"
		},
		CellConstant -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 1/Centimeter],
			Units -> 1/Centimeter,
			Description -> "For each member of Conductivity, the ratio of the distance between the electrode plates to the surface area of the plate determined by the calibration against conductivity standard.",
			Category -> "Qualifications & Maintenance",
			IndexMatching -> Conductivity
		},
		Conductivity -> {
			Format -> Multiple,
			Class ->  Real,
			Pattern :> GreaterEqualP[0 Micro Siemens/Centimeter],
			Units -> Micro Siemens/Centimeter,
			Description -> "The conductivity of calibration standard against of which probe was calibrated.",
			Category -> "Qualifications & Maintenance"
		},
		DataFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[EmeraldCloudFile],
			Description -> "The file containing data collected during the conductivity calibration.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		}
	}
}];
