(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument,ControlledRateFreezer],{
	Description->"A model for a freezer that cools at a controlled ramp rate to freeze cells for storage.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		
		MaxCoolingRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Celsius/Minute],
			Units->Celsius/Minute,
			Description->"The fastest decrease in temperature that can be achieved per unit time.",
			Category->"Operating Limits",
			Abstract->True
		},
		
		MinCoolingRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Celsius/Minute],
			Units->Celsius/Minute,
			Description->"The slowest decrease in temperature that can be achieved per unit time.",
			Category->"Operating Limits",
			Abstract->True
		},
		
		MinTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Kelvin],
			Units->Celsius,
			Description->"The lowest temperature the instrument can cool samples placed within its rack.",
			Category->"Operating Limits"
		},
		
		InternalDimensions->{
			Format->Single,
			Class->{Real,Real,Real},
			Pattern:>{GreaterP[0 Meter],GreaterP[0 Meter],GreaterP[0 Meter]},
			Units->{Meter,Meter,Meter},
			Description->"The size of the space inside the controlled rate freezer.",
			Category->"Dimensions & Positions",
			Headers->{"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
		}
	}
}];
