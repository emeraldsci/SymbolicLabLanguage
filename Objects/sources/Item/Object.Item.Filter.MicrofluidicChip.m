(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Item, Filter, MicrofluidicChip], {
	Description->"A physical filter chip with membrane used to filter particles above a certain size from a sample in the Formulatrix uPulse system.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		VolumeOfUses -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Liter],
			Units -> Liter Milli,
			Description -> "The total volume of liquid that has been filtered using this object of the filter.",
			Category -> "Filtration"
		},
		FiltrationLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Real, Link},
			Pattern :> {_?DateObjectQ, _Link, GreaterP[0*Milli*Liter], _Link},
			Relation -> {
				Null,
				Alternatives[
					Object[Sample]
				],
				Null,
				Alternatives[
					Object[Protocol]
				]
			},
			Headers -> {"Date", "Sample Filtered", "Volume Filtered", "Protocols"},
			Description -> "The filtration connection history of this item.",
			Category -> "Filtration"
		}
	}
}];
