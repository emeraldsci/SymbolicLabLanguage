(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, Freezer], {
	Description->"Low and ultra-low temperature freezers used for sample storage.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The minimum temperature the Freezer can maintain.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The maximum temperature the Freezer can maintain.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		InternalDimensions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],InternalDimensions]],
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Description -> "The size of space inside the Freezer interior in the  {X (width), Y (depth), Z (height)} directions.",
			Category -> "Dimensions & Positions"
		},
		Reserved -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this freezer is not currently used for storage and is reserved for emergency use or MaintenanceDefrost.",
			Category -> "Organizational Information"
		},
		ReservedStorageCondition -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[StorageCondition],
			Description -> "The storage condition provided by this freezer when it is allowed for use. Freezers with ReservedStorageCondition populated are designated for defrost maintenances and emergency use.",
			Category -> "Organizational Information"
		}
	}
}];
