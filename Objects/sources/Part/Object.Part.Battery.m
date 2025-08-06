(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Part, Battery], {
	Description->"A portable source of stored electrical energy that is used to power a device.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{
		MeasuredChargeCapacity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Ampere*Hour],
			Units -> Ampere*Hour,
			Description -> "The maximum measured charge that the battery can hold and discharge.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		MeasuredChargeCapacityLog -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{None, Ampere*Hour}],
			Units -> {None, Ampere*Hour},
			Description -> "A record of the maximum measured charge the battery can hold and discharge.",
			Category -> "Part Specifications",
			Abstract -> True
	}
}}];
