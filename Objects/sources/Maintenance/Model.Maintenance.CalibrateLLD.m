(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, CalibrateLLD], {
	Description->"Definition of a set of parameters for a maintenance protocol that generates a new calibration function for an ultrasonic liquid level detector.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Distances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The distances at which to set the sensor arm height of the LLD in order to calibrate the instrument.",
			Category -> "General"
		},
		SensorArmHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Millimeter],
			Units -> Millimeter,
			Description -> "The height to raise or lower the ultrasonic sensor to prior to taking any measurements, for calibrations that use gage blocks only.",
			Category -> "General"
		}
	}
}];
