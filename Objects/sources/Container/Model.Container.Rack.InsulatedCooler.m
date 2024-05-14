

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container,Rack,InsulatedCooler],{
	Description->"A model of a container for freezing cells in a mechanical freezer with a coolant.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		
		DefaultContainer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Container,Vessel],
			Description->"The vessel that the rack is placed into during a cooling procedure.",
			Category->"Container Specifications"
		}
	}
}];
