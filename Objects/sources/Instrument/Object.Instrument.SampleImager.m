

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, SampleImager], {
	Description->"An imager that takes brightfield images of vessels ranging from small conical tubes to large carboys.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		SmallCamera -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, Camera][SampleImager],
			Description -> "Fixed lens camera part of this sample imager that is used to image short vessel.",
			Category -> "Instrument Specifications"
		},
		MediumCamera -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, Camera][SampleImager],
			Description -> "Fixed lens camera part of this sample imager that is used to image medium size vessels.",
			Category -> "Instrument Specifications"
		},
		LargeCamera -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, Camera][SampleImager],
			Description ->"Fixed lens camera part of this sample imager that is used to image large vessels.",
			Category -> "Instrument Specifications"
		},
		TopLight -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, Lamp][ConnectedInstrument],
			Description -> "Lamp that provides top illumination for this sample imager.",
			Category -> "Instrument Specifications"
		},
		BottomLight -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, Lamp][ConnectedInstrument],
			Description -> "Lamp that provides bottom illumination for this sample imager.",
			Category -> "Instrument Specifications"
		}
	}
}];
