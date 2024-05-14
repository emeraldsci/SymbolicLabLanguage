

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

DefineObjectType[Object[Container, Envelope], {
	Description->"An envelope in which samples are shipped.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		OpticalFilter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part,OpticalFilter][StorageEnvelope]],
			Description -> "The Optical Filter stored inside this envelope after it is removed from the qpix deck.",
			Category -> "General"
		}
	}
}];
