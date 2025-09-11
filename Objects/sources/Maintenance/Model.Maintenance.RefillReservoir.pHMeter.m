(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, RefillReservoir, pHMeter], {
	Description->"Definition of a set of parameters for a maintenance protocol that refills a pH meter reservoir.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ReservoirDeckSlotNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "Slot names of where reservoir containers and probe storage containers are stored in the reservoir decks or racks.",
			Category -> "General"
		},
		ReservoirContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "For each member of ReservoirDeckSlotNames, the type of internal chamber containers of the pH meter Target's probes that to be filled with the storage solution (usually \"Electrolyte 3 mol/L KCl\") used to maintain stable reference electrode conditions for accurate pH measurement.",
			Category -> "General",
			IndexMatching -> ReservoirDeckSlotNames
		},
		ProbeStorageContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Vessel],
			Description -> "For each member of ReservoirDeckSlotNames, the type of containers secured to the bottom of the pH meter Target's probes to be filled with storage solution (usually \"Electrolyte 3 mol/L KCl\") to keep the pH probe's glass membrane and reference junction hydrated when not in use.",
			Category -> "General",
			IndexMatching -> ReservoirDeckSlotNames
		},
		Capacities->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter,
			Description -> "For each member of ReservoirDeckSlotNames, the maximum volumes that the pH probe internal reservoirs can be filled to.",
			Category -> "General"
		},
		FillVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter,
			Description -> "For each member of ReservoirDeckSlotNames, the volumes to which the pH probe internal reservoirs should be filled.",
			Category -> "General",
			IndexMatching -> ReservoirDeckSlotNames
		},
		ProbeStorageContainerFillVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter,
			Description -> "For each member of ReservoirDeckSlotNames, the volumes to which the pH probe storage containers should be filled.",
			Category -> "General",
			IndexMatching -> ReservoirDeckSlotNames
		}
	}
}];
