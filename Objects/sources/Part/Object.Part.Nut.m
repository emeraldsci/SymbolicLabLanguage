(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, Nut], {
	Description->"A threaded piece which is used to form a fitting at a connector.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		InstalledLocation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Plumbing][Nuts,2],
				Object[Instrument][Nuts,2],
				Object[Item][Nuts,2],
				Object[Part][Nuts,2],
				Object[Container][Nuts,2]
			],
			Description -> "The part or instrument connector upon which this nut has been installed.",
			Category -> "Plumbing Information"
		},
		Flanged -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Flanged]],
			Pattern :> BooleanP,
			Description -> "Indicates whether this model of nut is a flange nut, meaning it has a projecting collar that acts as an integrated washer.",
			Category -> "Part Specifications"
		}
	}
}];