(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, RefillReservoir, pHMeter], {
	Description->"A protocol that refills the reservoir of a pH meter.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		FillVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter,
			Description -> "The volumes to which the reservoirs should be filled.",
			Category -> "General",
			Abstract -> True
		},
		ReservoirContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The container that holds reservoir liquid.",
			Category -> "Refilling"
		}
	}
}];
