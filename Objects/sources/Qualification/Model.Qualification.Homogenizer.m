(* ::Package:: *)

DefineObjectType[Model[Qualification, Homogenizer], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a homogenizer.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
		Amplitude->{
			Format->Single,
			Class->Real,
			Units->Percent,
			Pattern:>PercentP,
			Description->"The amplitude of the sonication horn when mixing via homogenization. When using a microtip horn (ex. for 2mL and 15mL tubes), the maximum amplitude is 70 Percent, as specified by the manufacturer, in order not to damage the instrument.",
			Category->"Incubation"
		},
		Time->{
			Format->Single,
			Class->Real,
			Units->Minute,
			Pattern:>GreaterEqualP[0 Minute],
			Description->"The duration of time for which the samples will be mixed.",
			Category->"Incubation"
		},
		DutyCycleOnTime->{
			Format->Single,
			Class->Real,
			Units->Second,
			Pattern:>GreaterEqualP[0 Second],
			Description->"The On Time that specifies how the homogenizer should mix the given sample via pulsation of the sonication horn. This duty cycle is repeated indefinitely until the specified Time has elapsed.",
			Category->"Incubation"
		},
		DutyCycleOffTime->{
			Format->Single,
			Class->Real,
			Units->Second,
			Pattern:>GreaterEqualP[0 Second],
			Description->"The Off Time that specifies how the homogenizer should mix the given sample via pulsation of the sonication horn. This duty cycle is repeated indefinitely until the specified Time has elapsed.",
			Category->"Incubation"
		}
	}
}];
