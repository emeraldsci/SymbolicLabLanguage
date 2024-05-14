

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Maintenance, CalibrateWeight], {
	Description->"Definition of a set of parameters for a maintenance protocol that calibrates a weight sensor.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		ManufacturerCalibration -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that the calibration function for this sensor is provided by sensor's manufacturer or a calibration service company.",
			Category -> "General",
			Abstract -> True
		}
	}
}];
