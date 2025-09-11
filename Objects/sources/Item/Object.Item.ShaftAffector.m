(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Item, ShaftAffector], {
	Description->"Information for a shaft attachment used to mix media during a dissolution experiment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		DesignatedDissolutionShaft->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Item,DissolutionShaft],
			Description->"The mixing implement that is used with this shaft affector. It is considered best practice to use the same mixing implement for each experiment with the same dissolution shaft to keep the number of variables between experiments to a minimum.",
			Category->"Dimensions & Positions"
		}
	}
}];