(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, RefillReservoir, NMR], {
	Description->"A protocol that refills the liquid nitrogen reservoir of an NMR spectrometer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		HeatGun->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item, HeatGun],
				Model[Item, HeatGun]
			],
			Description -> "The heat gun used to warm and defrost a surface.",
			Category -> "General",
			Developer->True
		},

		FaceShield->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item, FaceShield],
				Model[Item, FaceShield]
			],
			Description -> "The face shield worn to protect the face from chemical splashes/airborne debris.",
			Category -> "General",
			Developer->True
		},

		CryoGlove->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item, Glove],
				Model[Item, Glove]
			],
			Description -> "The cryo gloves worn to the hands from ultra low temperature surfaces/fluids.",
			Category -> "General",
			Developer->True
		},

		HeatSinkFillPlacement->{
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Part]|Object[Item], Object[Instrument], Null},
			Description -> "Placement for the heat sink onto the fill turret.",
			Headers->{"Movement Part", "Destination Instrument", "Destination Position"},
			Category -> "Placements",
			Developer -> True
		},

		HeatSinkExhaustPlacement->{
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Part]|Object[Item], Object[Instrument], Null},
			Description -> "Placement for the heat sink onto the Exhaust turret.",
			Headers->{"Movement Part", "Destination Instrument", "Destination Position"},
			Category -> "Placements",
			Developer -> True
		},

		HeatSinkFillRemovalPlacement->{
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Part]|Object[Item], Object[Instrument], Null},
			Description -> "Placement for removal of the heat sink from the fill turret.",
			Headers->{"Movement Part", "Destination Instrument", "Destination Position"},
			Category -> "Placements",
			Developer -> True
		},

		HeatSinkExhaustRemovalPlacement->{
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Part]|Object[Item], Object[Instrument], Null},
			Description -> "Placement for removal of the heat sink from the Exhaust turret.",
			Headers->{"Movement Part", "Destination Instrument", "Destination Position"},
			Category -> "Placements",
			Developer -> True
		},
		
		HeliumLevel->{
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0,100],
			Units -> Percent,
			Description -> "The percentage of helium remaining in the helium reservoir.",
			Category -> "Sensor Information",
			Developer -> True
		}
	}
}];
