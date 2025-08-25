

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, Balance], {
	Description->"Device for high precision measurement of weight.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		Mode -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],Mode]],
			Pattern :> BalanceModeP,
			Description -> "Type of measurement's the balance is capable of performing.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Resolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],Resolution]],
			Pattern :> GreaterP[0*Gram],
			Description -> "The smallest change in mass that corresponds to a change in displayed value.",
			Category -> "Instrument Specifications"
		},
		ManufacturerRepeatability -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],ManufacturerRepeatability]],
			Pattern :> GreaterP[0*Gram],
			Description -> "The scale's ability to show consistent results under the same conditions acording to the manufacturer.",
			Category -> "Instrument Specifications"
		},
		WeightSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Sensornet weight sensor used by this balance instrument.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		MinWeight -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinWeight]],
			Pattern :> GreaterP[0*Gram],
			Description -> "Minimum mass the instrument can weigh.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxWeight -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxWeight]],
			Pattern :> GreaterP[0*Gram],
			Description -> "Maximum mass the instrument can weigh.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		BalanceCleaningBrush -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item,Consumable],
			Description -> "The brush used to dust off any stray material from the balance.",
			Category -> "Cleaning"
		},
		WaterBasedCleaningWipes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item,Consumable],
			Description -> "The wipes used to wipe off any stray material from the balance.",
			Category -> "Cleaning"
		},
		AlcoholBasedCleaningWipes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item,Consumable],
			Description -> "The wipes used to wipe off any stray material from the balance.",
			Category -> "Cleaning"
		}
	}
}];
