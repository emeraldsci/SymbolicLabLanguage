(* ::Package:: *)

DefineObjectType[Object[Part, EluentGenerator], {
	Description->"The cartridge that automatically generates eluent in the flow path for Ion Chromatography experiments.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{
	
		(* --- Method Information--- *)
		Instrument->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Description->"The Ion Chromatography instrument that is compatible with this model of the Buffer generator.",
			Relation->Object[Instrument, IonChromatography][IntegratedEluentGenerator],
			Category->"Physical Properties",
			Abstract->True
		},
		NumberOfInjections->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0, 1],
			Units->None,
			Description->"The number of injections that have previously been run with this Buffer generator cartridge, including standards, analytes, and blanks.",
			Category -> "General"
		},
		InjectionLog->{
			Format->Multiple,
			Class->{
				DateInjected->Date,
				Sample->Link,
				Column->Link,
				Protocol->Link,
				Type->Expression,
				Gradient->Link,
				InjectionVolume->Real,
				Data->Link
			},
			Pattern:>{
				DateInjected->_?DateObjectQ,
				Sample->ObjectP[{Object[Sample],Model[Sample]}],
				Column->Link,
				Protocol->_Link,
				Type->InjectionTableP,
				Gradient->ObjectP[Object[Method]],
				InjectionVolume->GreaterEqualP[0*Micro Liter],
				Data->_Link
			},
			Relation->{
				DateInjected->Null,
				Sample->Alternatives[
					Object[Sample],
					Model[Sample]
				],
				Column->Alternatives[
					Object[Sample],
					Model[Sample]
				],
				Protocol->Object[Protocol],
				Type->Null,
				Gradient->Object[Method],
				InjectionVolume->Null,
				Data->Object[Data]
			},
			Units->{
				DateInjected->None,
				Sample->None,
				Column->None,
				Protocol->None,
				Type->Null,
				Gradient->None,
				InjectionVolume->Micro Liter,
				Data->None
			},
			Description->"The historical usage of the eluent generator.",
			Category -> "General"
		}
	}
}];
