

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Sensor, Volume], {
	Description->"Model of a device for measuring Volume.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		MaxVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "Maximum Volume that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		MinVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "Minimum Volume that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		MaxDistance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "In the case of volume sensors using UltrasonicDistance as measurement method, maximum distance that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		MinDistance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Centi*Meter],
			Units -> Meter Milli,
			Description -> "In the case of volume sensors using UltrasonicDistance as measurement method, minimum distance that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		}
	}
}];
