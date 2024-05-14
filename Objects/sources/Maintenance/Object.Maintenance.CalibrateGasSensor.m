

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Maintenance, CalibrateGasSensor], {
	Description->"A protocol that calibrates the carbon dioxide and nitrogen sensors on a plate reader instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		SampleTube -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part]
			],
			Description -> "The sample tubing part on the plate reader instrument that will be detached and reattached over the course of the maintenance.",
			Category -> "General"
		}
	}
}];