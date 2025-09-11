(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Report, Certificate, Calibration],{
	(* This object holds fields for information uploaded from a third party  certificate of calibration for certified items, parts, sensors, and instruments.*)
	Description->"Information contained in a third-party generated Certificate of Calibration document verifying calibration parameters.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		SensorCertified->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sensor][Certificates],
			Description->"The calibrated sensor with the batch number or serial number referred to in the calibration document.",
			Category->"General"
		},
		(* Identification *)
		SerialNumber -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Serial number of the calibrated sensor, part, item, instrument or instrument module.",
			Category -> "Inventory"
		},
		ModelNumber ->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"Model or part number of the calibrated sensor, part, item, instrument or instrument module.",
			Category->"Inventory"
		}
	}
}];