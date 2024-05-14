(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, Ferrule], {
	Description->"A compressible ring used to form a seal around tubing or pipes while connecting them to a fitting.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		InstalledLocation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Plumbing][Ferrules,2],
				Object[Instrument][Ferrules,2],
				Object[Item][Ferrules,2],
				Object[Part][Ferrules,2],
				Object[Container][Ferrules,2]
			],
			Description -> "The part or instrument connector upon which this ferrule has been installed.",
			Category -> "Plumbing Information"
		}
	}
}];