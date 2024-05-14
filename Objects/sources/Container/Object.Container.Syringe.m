

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container, Syringe], {
	Description->"A device/part designed to aspirate and dispense liquid through moving a plunger inside a sealed cylinder.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		ConnectionType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], ConnectionType]],
			Pattern :> ConnectorP,
			Description -> "Indicates the way this syringe is connected to a needle.",
			Category -> "Physical Properties"
		},
		Resolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Resolution]],
			Pattern :> GreaterP[0*Liter*Micro],
			Description -> "The smallest volume interval which can be measured by this syringe.",
			Category -> "Operating Limits"
		},
		DeadVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], DeadVolume]],
			Pattern :> GreaterEqualP[0*Liter],
			Description -> "The volume of fluid that will remain in the syringe even when the plunger is fully depressed.",
			Category -> "Operating Limits"
		},
		InnerDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], InnerDiameter]],
			Pattern :> GreaterP[0*Inch],
			Description -> "The inner diameter of the cylindrical, fluid-containing portion of this syringe.",
			Category -> "Physical Properties"
		},
		OuterDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], OuterDiameter]],
			Pattern :> GreaterP[0*Inch],
			Description -> "The outer diameter of the cylindrical, fluid-containing portion of this syringe.",
			Category ->"Physical Properties"
		},
		MaxVolumeLength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxVolumeLength]],
			Pattern :> GreaterP[0*Centimeter],
			Description -> "The length of the syringe when holding the maximum allowed volumen,measured from the end of the plunger to the tip of needle adapter.",
			Category -> "Dimensions & Positions"
		}
	}
}];
