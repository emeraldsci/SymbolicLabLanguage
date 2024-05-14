(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Autoclave], {
	Description->"A pressure chamber for sterilizing waste, reagents and equipment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Modes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> AutoclaveModeP,
			Description -> "Type of cleaning cycles available to the autoclave.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		AutoclavePrograms -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> AutoclaveProgramP,
			Description -> "The sterilization programs the autoclave can run.",
			Category -> "Instrument Specifications"
		},
		MinPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "Minimum amount of pressure the Autoclave can provide.",
			Category -> "Operating Limits"
		},
		MaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "Maximum amount of pressure the Autoclave can provide.",
			Category -> "Operating Limits"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature the autoclave can reach.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature the autoclave can reach.",
			Category -> "Operating Limits"
		},
		MinCycleTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "Minimum time the autoclave can run for.",
			Category -> "Operating Limits"
		},
		MaxCycleTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "Maximum time the autoclave can run for.",
			Category -> "Operating Limits"
		},
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real,Real,Real},
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Units -> {Meter,Meter,Meter},
			Description -> "The measurements of the internal chamber of the autoclave in the  {X (left-to-right), Y (back-to-front), Z (bottonm-to-top)} directions.",
			Category -> "Dimensions & Positions",
			Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
		}
	}
}];
