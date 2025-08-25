(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, RefillReservoir, pHMeter], {
	Description->"A protocol that refills the reservoir of a pH meter.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Probes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, pHProbe],
			Description -> "The pH probe associated with the Target of the maintenance for which the probe reservoirs and storage containers are to be filled.",
			Category -> "General"
		},
		ReservoirContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "For each member of Probes, the internal chamber containers of the pH meter Target's probes that to be filled with the storage solution (usually \"Electrolyte 3 mol/L KCl\") used to maintain stable reference electrode conditions for accurate pH measurement.",
			Category -> "Refilling",
			IndexMatching -> Probes
		},
		ProbeStorageContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "For each member of Probes, the containers secured to the bottom of the pH meter Target's probes to be filled with storage solution (usually \"Electrolyte 3 mol/L KCl\") to keep the pH probe's glass membrane and reference junction hydrated when not in use.",
			Category -> "Refilling",
			IndexMatching -> Probes
		},
		LiquidWastes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The samples in ReservoirContainers and ProbeStorageContainers that are refilled during this maintenance.",
			Category -> "General",
			Developer -> True
		}
	}
}];
