

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, FilterBlock], {
	Description->"Housing for filter plates used in vacuum filtration.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		MinPressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinPressure]],
			Pattern :> GreaterP[0*PSI],
			Description -> "Minimum internal pressure in the filter block (as designated by its pressure gauge).",
			Category -> "Operating Limits",
			Abstract -> True
		},
		VacuumPump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, VacuumPump][FilterBlock],
			Description -> "The vacuum pump that provides the pressure differential to create a vacuum in the filter block.",
			Category -> "Integrations"
		}
	}
}];
