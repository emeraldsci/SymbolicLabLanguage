(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[TransportCondition],{
	Description->"Specifies how samples should be transported when in used in the laboratory.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		TransportLightSensitive->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this sample should be transported with a light sensitive cover when used in the laboratory.",
			Category->"Model Information",
			Abstract->True
		},
		
		TransportTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description->"The temperature at which this sample should be transported in the lab in a portable cooler/heater. If this field is Null, the sample will be transported at Ambient temperature.",
			Category->"Model Information",
			Abstract->True
		},
		
		TransportCondition->{
			Format->Single,
			Class->Expression,
			Pattern:>TransportConditionP,
			Description->"The shortcut symbol that refers to the genre of transport provided by this object.",
			Category->"Model Information",
			Abstract->True
		},
		
		Deprecated->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this item model is historical and no longer used in the lab.",
			Category->"Organizational Information",
			Abstract->True
		},
		
		DeveloperObject->{
			Format->Single,
			Class->Expression,
			Pattern:>True|False,
			Description->"True if a developer object (will be filtered out of searches).",
			Category->"Organizational Information",
			Developer->True
		}
	}
}];
