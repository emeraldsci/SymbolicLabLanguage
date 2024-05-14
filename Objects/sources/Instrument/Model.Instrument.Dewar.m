

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument,Dewar],{
	Description->"A model for a liquid nitrogen immersion flash freezing dewar instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		LiquidNitrogenCapacity->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Liter],
			Units->Liter,
			Description->"The maximum volume of liquid nitrogen that the dewar can be filled with.",
			Category->"Operating Limits"
		},
		InternalDimensions->{
			Format->Single,
			Class->{Real,Real,Real},
			Pattern:>{GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Units->{Meter,Meter,Meter},
			Description->"The dimensions of the space inside the liquid nitrogen dewar in the form of: {X Direction (Width),Y Direction (Depth),Z Direction (Height)}.",
			Headers->{"Width","Depth","Height"},
			Category->"Dimensions & Positions"
		}
	}
}];