(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container, Basket], {
	Description->"Information for a mesh basket that prevents pills from floating during the dissolution experiment while tansmitting the rotational energy to the dissolution medium.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		CleanRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The rack used to store this basket when it is clean.",
			Category -> "Placements"
		},
		DirtyRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The rack used to store this basket when it is dirty and will be cleaned.",
			Category -> "Placements"
		},
		SerialNumber -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The manufacturer provided serial number of the basket.",
			Category -> "Container Specifications"
		},
		DesignatedDissolutionShaft->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container,DissolutionShaft],
			Description->"The mixing implement that is used with this basket. It is considered best practice to use the same mixing implement for each experiment with the same dissolution shaft to keep the number of variables between experiments to a minimum.",
			Category->"Dimensions & Positions"
		}
	}
}];