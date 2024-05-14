

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part,Balance],{
	Description->"The model of a device for measurement of weight.",
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

		Resolution->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Gram],
			Units->Gram,
			Description->"The smallest change in mass that corresponds to a change in displayed value. Also known as readability, increment, scale division.",
			Category->"Instrument Specifications"
		},
		MinWeight->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Gram],
			Units->Gram,
			Description->"Minimum mass the instrument can weigh.",
			Category->"Operating Limits",
			Abstract->True
		},
		MaxWeight->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Gram],
			Units->Gram,
			Description->"Maximum mass the instrument can weigh.",
			Category->"Operating Limits",
			Abstract->True
		}
	}
}];
