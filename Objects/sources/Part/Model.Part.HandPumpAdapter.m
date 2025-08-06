(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, HandPumpAdapter], {
	Description->"Model information for an adapter that can be used to connect a handpump to the container in order to extend the hand pump dispense distance to properly transfer liquid from solvent drums and carboys.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		CompatibleHandPumps -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part, HandPump][CompatibleHandPumpAdapters],
			Description -> "The manual pump models that can be attached to the adapter and used to transfer liquid from solvent drums and carboys.",
			Category -> "Model Information"
		}
	}
}];
