(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Maintenance, RefillReservoir, Chiller], {
	Description->"A protocol that refills the reservoir tank on the chiller of an instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		Chiller -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> ObjectP[Object[Part, Chiller]],
			Description -> "The chiller which reservoir should be refilled.",
			Category -> "General"
		}
	}
}];