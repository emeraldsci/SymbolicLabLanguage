(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, RefillReservoir, LiquidParticleCounter], {
	Description->"A protocol that refills the probe storage container of a liquid particle counter.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ProbeStorageContainerProbePosition -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Inch],
			Units -> Inch,
			Description -> "Position of probe when merge the probe into the ProbeStorageContainer.",
			Category -> "Placements",
			Developer -> True
		},
		ProbeStorageContainerPlacements ->{
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container]|Model[Container], Object[Instrument], Null},
			Description -> "List of ProbeStorage container placements.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		OldProbeStorageContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "The container with dionized water to store and protect the probe when experiments are done.",
			Developer -> True,
			Category -> "General"
		},
		ProbeStorageContainerCover  -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item, Cap]
			],
			Description -> "The special cover for ProbeStorageContainer.",
			Developer -> True,
			Category -> "General"
		}
	}
}];
