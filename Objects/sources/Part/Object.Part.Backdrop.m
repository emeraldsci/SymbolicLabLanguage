(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part,Backdrop], {
	Description->"A backdrop used to change the background color in the sample instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		SampleInspector -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, SampleInspector][Backdrops],
			Description -> "The sample inspector instrument for which this backdrop provides a monochromatic background for sample agitation and recording.",
			Category -> "Instrument Specifications"
		},
		BackgroundColor -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BackdropColorP,
			Description -> "The color of the backdrop board.",
			Category -> "Part Specifications"
		}
	}
}];
