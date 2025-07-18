

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part, HandPump], {
	Description->"Model information for a manual pump used to transfer liquid out of solvent drums.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		DispenseHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter,
			Description -> "The minimum height from which this pump dispenses liquid when attached to the appropriate source container and is measured from the bottom of the hand pump tubing (intake opening) to the bottom of the container.",
			Category -> "Dimensions & Positions"
		},
		IntakeTubeLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter,
			Description -> "The length of the long cylindrical section of the pump that extends into the container, measured from the liquid intake opening to the point where it rests at the container's opening.",
			Category -> "Dimensions & Positions"
		},
		CompatibleHandPumpAdapters -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part, HandPumpAdapter][CompatibleHandPumps],
			Description -> "The part that can be used to connect this hand pump to the container in order to extend the hand pump dispense distance to properly transfer liquid from solvent drums and carboys.",
			Category -> "Model Information"
		}
	}
}];
