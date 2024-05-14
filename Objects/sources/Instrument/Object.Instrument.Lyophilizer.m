(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, Lyophilizer], {
	Description -> "An instrument that uses vacuum pressures and controlled sample freezing to induce sublimation of solvent.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		ShelfHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Centimeter,
			Description -> "The current distance between an open shelf and the shelf above it or the top of the chamber, as determined by the instrument's current DeckLayout.",
			Category -> "Operating Limits"
		},
		Probes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Part]],
			Description -> "The thermocouples parts used by the lyophilizer to monitor the temperature of samples during the run.",
			Category -> "Instrument Specifications"
		},
		VacuumPump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument,VacuumPump][Lyophilizer]],
			Description -> "The pump instrument used to generate a vacuum inside the lyophilizer by removing air and evaporated solvent from it's evaporation chamber.",
			Category -> "Instrument Specifications"
		},
		BackfillGasPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "The sensor reading the pressure of the gas supply used for providing an inert atmosphere within the instrument.",
			Category -> "Sensor Information"
		},
		StopperingGasPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "The sensor reading the pressure of the gas supply used for automatic pneumatic stoppering of vials.",
			Category -> "Sensor Information"
		}
	}
}];
