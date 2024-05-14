(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part,PeristalticPump],{
	Description->"The model for Low pressure, low volume liquid pumping devices for continuous liquid transfers.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		
		Manufacturer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Company,Supplier],
			Description->"The company that originally manufactured this model of instrument.",
			Category->"Inventory"
		},
		
		UserManualFiles->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"PDFs for the manuals or instruction guides for this model of instrument.",
			Category->"Organizational Information"
		},
		
		TubingType->{
			Format->Single,
			Class->Expression,
			Pattern:>TubingTypeP,
			Description->"Material type the peristaltic pump is composed of.",
			Category->"Instrument Specifications",
			Abstract->True
		},
		
		MinFlowRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[(0*(Liter*Milli))/Minute],
			Units->(Liter Milli)/Minute,
			Description->"Minimum flow rate the pump can deliver.",
			Category->"Operating Limits",
			Abstract->True
		},
		
		MaxFlowRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[(0*(Liter*Milli))/Minute],
			Units->(Liter Milli)/Minute,
			Description->"Maximum flow rate the pump can deliver.",
			Category->"Operating Limits",
			Abstract->True
		}
	}
}];
