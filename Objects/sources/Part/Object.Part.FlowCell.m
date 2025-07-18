(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, FlowCell], {
	Description->"A fluid channel transparent for chromatography detectors.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		FPLC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, FPLC][DefaultFlowCell]
			],
			Description -> "The FPLC instrument that is connected to this part.",
			Category -> "Instrument Specifications"
		},
		IonChromatographySystem -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, IonChromatography][FlowCell]
			],
			Description -> "The IonChromatography instrument that is connected to this part.",
			Category -> "Instrument Specifications"
		}
	}
}];
