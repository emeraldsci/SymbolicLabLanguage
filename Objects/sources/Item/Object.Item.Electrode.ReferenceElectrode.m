(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Item,Electrode,ReferenceElectrode], {
	Description->"Object information for an electrode used in cyclic voltammetry measurements and acts as a fixed potential reference",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		CurrentSolutionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The current volume of reference solution filled in the glass tube of this reference electrode.",
			Category -> "Item Specifications"
		},
		ReferenceElectrodeModelLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {
				Null,
				Model[Item, Electrode, ReferenceElectrode],
				Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]
			},
			Headers -> {"Date", "Reference Electrode Model", "Responsible Party"},
			Description -> "The historical recording of this reference electrode's model.",
			Category -> "Usage Information"
		},
		RefreshLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {
				Null,
				Model[Sample],
				Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]
			},
			Headers -> {"Date", "Reference Solution Model", "Responsible Party"},
			Description -> "The historical record of reference solutions added into the glass tube of this reference electrode.",
			Category -> "Usage Information"
		}
	}
}];
