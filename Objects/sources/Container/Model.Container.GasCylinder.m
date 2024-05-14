(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container, GasCylinder], {
	Description->"A vessel used to store gases at high pressure.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		MaxCapacity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter,
			Description -> "The maximum storage capacity of this model gas cylinder.",
			Category -> "Operating Limits"
		},
		MaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The maximum operating pressure of this model gas cylinder.",
			Category -> "Operating Limits"
		},
		LiquidLevelGauge -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this gas cylinder model has a gauge that shows fill level of the cylinder.",
			Category -> "Container Specifications"
		},
		ProductsContained -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product][DefaultContainerModel],
			Description -> "The gas products that can be stored in this gas cylinder.",
			Category -> "Inventory",
			Developer->True
		},
		PlumbingImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A photo of the plumbing on top of this gas cylinder.",
			Category -> "Container Specifications",
			Developer->True
		}
	}
}];
