

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container,Rack,InsulatedCooler], {
	Description->"A container for freezing cells in a mechanical freezer with a coolant.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		DefaultContainer->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],DefaultContainer]],
			Pattern:>_Link,
			Relation->Model[Container,Vessel],
			Description->"The vessel that the rack is placed into during a cooling procedure.",
			Category->"Container Specifications"
		}
	}
}];
