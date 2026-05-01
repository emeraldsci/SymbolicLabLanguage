

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, BottleRoller], {
	Description->"A bottle roller instrument used to continuously mix reagent or stock solution bottles.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		MaxRotationRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxRotationRate]],
			Pattern :> GreaterP[0*RPM],
			Description -> "The fastest rotational speed at which the instrument rollers can operate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinRotationRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinRotationRate]],
			Pattern :> GreaterP[0*RPM],
			Description -> "The slowest rotational speed at which the instrument rollers can operate.",
			Category -> "Operating Limits"
		},
		MaxLoad -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxLoad]],
			Pattern :> GreaterP[0*Kilo*Gram],
			Description -> "The maximum mass of material the bottle roller can handle.",
			Category -> "Operating Limits"
		},
		RollerDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],RollerDiameter]],
			Pattern :> GreaterP[0*Centi*Meter],
			Description -> "The diameter of the rolling pins of the instrument.",
			Category -> "Dimensions & Positions"
		},
		RollerSpacing -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],RollerSpacing]],
			Pattern :> GreaterP[0*Centi*Meter],
			Description -> "The center-to-center distance between adjacent rolling pins of the instrument.",
			Category -> "Dimensions & Positions"
		},
		Wrench -> {
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Item,Wrench],Object[Item,Wrench]],
			Description->"The wrench used to loosen and tighten the rolling pins of the instrument.",
			Category->"General"
		}
	}
}];
