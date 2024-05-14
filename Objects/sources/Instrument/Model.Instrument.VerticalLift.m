

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, VerticalLift], {
	Description->"The model for a vertical lift storage unit (VLM) used to store samples.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		DefaultTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The room temperature the vertical lift is set to maintain.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum temperature the vertical lift can maintain.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The maximum temperature the vertical lift can maintain.",
			Category -> "Operating Limits"
		},
		MaxNumberOfTrays -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The maximum number of trays that can be installed in this vertical lift, assuming all contents fit within the height of the trays.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		TotalProductVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Foot^3],
			Units -> Foot^3,
			Description -> "The total volume that this vertical lift can store.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real,Real,Real},
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Units -> {Meter,Meter,Meter},
			Description -> "The size of one tray.",
			Category -> "Dimensions & Positions",
			Abstract -> True,
			Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
		}
	}
}];
