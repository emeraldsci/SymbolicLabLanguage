(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item,Electrode], {
	Description->"Model information for an electrode, which is made of conductive material(s) and inserted in various medias to deliver voltage and current.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* Electrode Information *)
		BulkMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The main material composition of this electrode model. This is the same with the WettedMaterials field if the Coated field is False.",
			Category -> "Physical Properties"
		},
		Coated -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if there is a different type of material outside the electrode other than the bulk material. If the electrode is coated, it should not be polished.",
			Category -> "Physical Properties"
		},
		CoatMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The surface material of this electrode model, if it is coated. This is the same with the WettedMaterials field if the Coated field is True.",
			Category -> "Physical Properties"
		},
		ElectrodeShape -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ElectrodeShapeP,
			Description -> "The overall shape description of the electrode.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		ElectrodePackagingMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The type of material that wraps around the conductive part of the electrode and is also in contact with the solution during experiments.",
			Category -> "Physical Properties"
		},
		MinPotential -> {
			Format -> Single,
			Class -> Real,
			Pattern :> VoltageP,
			Units -> Volt,
			Description -> "The minimum (negative) voltage that can be applied to this electrode model.",
			Category -> "Operating Limits"
		},
		MaxPotential -> {
			Format -> Single,
			Class -> Real,
			Pattern :> VoltageP,
			Units -> Volt,
			Description -> "The maximum (positive) voltage that can be applied to this electrode model.",
			Category -> "Operating Limits"
		},

		(* Polishing and Cleaning Information *)
		MaxNumberOfPolishings -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "Indicates the max number of polishings this electrode model can endure before it is discarded.",
			Category -> "Operating Limits"
		},
		PolishingSolutions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The recommended polishing solution models used to polish this electrode model.",
			Category -> "Cleaning"
		},
		PolishingPads -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, ElectrodePolishingPad],
			Description -> "The recommended polishing pad models used to polish this electrode model.",
			Category -> "Cleaning"
		},
		SonicationSensitive -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates the electrode model has components that may be damaged if it is sonication-cleaned.",
			Category -> "Cleaning"
		}
	}
}];
