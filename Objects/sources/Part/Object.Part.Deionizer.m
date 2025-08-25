(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, Deionizer], {
	Description -> "A machine that works to minimize static-potential build-up on ungrounded items.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {
		HandlingStation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, HandlingStation][Deionizer],
			Description -> "The instrument that provides the handling environment that this deionizer services in order to deionize samples during transfer.",
			Category -> "Part Specifications"
		}
	}
}];


