

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, CuvetteWasher], {
	Description->"Instrument which is used to wash cuvettes with solvent.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		VacuumPump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, VacuumPump][CuvetteWasher],
			Description -> "The vacuum pump that provides the pressure differential to drive wash solution into the cuvette for washing.",
			Category -> "Integrations"
		},
		CuvetteCapacity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],CuvetteCapacity]],
			Pattern :> GreaterP[0, 1],
			Description -> "The number of cuvettes that can be washed simultaneously.",
			Category -> "Instrument Specifications"
		},
		TrapCapacity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],TrapCapacity]],
			Pattern :> GreaterP[0*Milli*Liter],
			Description -> "The volume of wash solution waste that the trap flask can hold before needing to be emptied.",
			Category -> "Instrument Specifications"
		}
	}
}];
