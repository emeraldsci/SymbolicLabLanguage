(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, Filter], {
	Description->"A porous material intalled on instruments to remove impurities or solid particles.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument]
			],
			Description -> "The instrument that the filter is installed on to remove impurities from air or liquid.",
			Category -> "Instrument Specifications"
		}
	}
}];
