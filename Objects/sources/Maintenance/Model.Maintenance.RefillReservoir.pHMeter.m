(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, RefillReservoir, pHMeter], {
	Description->"Definition of a set of parameters for a maintenance protocol that refills a pH meter reservoir.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Capacities->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter,
			Description -> "The maximum volumes that the reservoirs can be filled to.",
			Category -> "General"
		},
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
			Relation -> Model[Container],
			Description -> "The type of reservoir containers that are refilled in the maintenance.",
			Category -> "General"
		},
		ReservoirDeckSlotNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "Slot names of where reservoir containers are stored in the reservoir decks or racks.",
			Category -> "General"
		}
	}
}];
