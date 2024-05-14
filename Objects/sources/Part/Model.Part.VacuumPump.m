(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part,VacuumPump],{
	Description->"The model for fluid pumping devices that generate a partial vacuum.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		Manufacturer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Company,Supplier],
			Description->"The company that originally manufactured this model of part.",
			Category->"Inventory"
		},
		UserManualFiles->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"PDFs for the manuals or instruction guides for this model of part.",
			Category->"Organizational Information"
		}
	}
}];
