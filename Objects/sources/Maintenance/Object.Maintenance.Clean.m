(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, Clean], {
	Description->"A protocol that cleans the exterior of the maintenance target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		LabArea -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LabAreaP,
			Description -> "Indicates the area of the lab in which this maintenance occurs.",
			Category -> "Cleaning"
		},
		BlowGun-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "Indicates the blow gun used to clean or dry a surface.",
			Category -> "Cleaning",
			Developer->True
		},
		Instruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "Instruments cleaned during this maintenance.",
			Category -> "Cleaning"
		},
		Benches -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "Benches cleaned during this maintenance.",
			Category -> "Cleaning"
		},
		Enclosures -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of Benches, Indicates if there is a plexiglass enclosure that needs cleaning.",
			IndexMatching-> Benches,
			Category -> "Cleaning",
			Developer -> True
		},
		Enclosure -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if there is a plexiglass enclosure that needs cleaning.",
			Category -> "Cleaning",
			Developer -> True
		},
		FlammableCabinets -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "Flammable cabinets cleaned during this maintenance.",
			Category -> "Cleaning"
		},
		Centrifuges -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "Centrifuge Instruments cleaned during this maintenance.",
			Category -> "Cleaning"
		},
		WorkSurface -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The location where the Target is cleaned.",
			Category -> "Cleaning",
			Developer -> True
		},
		WaterPurifier -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "Source of purified water used to rinse the labware.",
			Category -> "Cleaning"
		},
		LiquidHandlers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, LiquidHandler],
				Model[Instrument, LiquidHandler]
			],
			Description -> "Instruments cleaned during this maintenance.",
			Category -> "Cleaning"
		},
		GilsonSPERacks -> {
			Format -> Multiple,
			Class -> {
				LiquidHandlers -> Link,
				GilsonRack1 -> Link,
				GilsonRack2 -> Link,
				GilsonRack3 -> Link,
				GilsonRack4 -> Link
			},
			Pattern :> {
				LiquidHandlers -> _Link,
				GilsonRack1 -> _Link,
				GilsonRack2 -> _Link,
				GilsonRack3 -> _Link,
				GilsonRack4 -> _Link
			},
			Units -> {LiquidHandlers -> None, GilsonRack1 -> None, GilsonRack2 -> None, GilsonRack3 -> None, GilsonRack4 -> None},
			Relation -> {
				LiquidHandlers -> Object[Instrument],
				GilsonRack1 -> Object[Container],
				GilsonRack2 -> Object[Container],
				GilsonRack3 -> Object[Container],
				GilsonRack4 -> Object[Container]
			},
			Description -> "Associations of Gilson SPE instruments with their respective racks.",
			Category -> "Cleaning"
		}
	}
}];
