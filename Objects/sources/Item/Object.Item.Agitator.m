(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Item, Agitator], {
	Description->"Information for a shaft attachment used to mix media during a dissolution experiment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		DesignatedDissolutionShaft->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container,DissolutionShaft],
			Description->"The mixing implement that is used with this agitator. It is considered best practice to use the same mixing implement for each experiment with the same dissolution shaft to keep the number of variables between experiments to a minimum.",
			Category->"Dimensions & Positions"
		},
		MixingStrategy->{
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MixingStrategy]],
			Pattern :> DissolutionStrategyP,
			Description->"The type of the stirrer implement used to mix the samples during the dissolution experiment. By convention, the USP apparatus 1 is ofter referred to as a Paddle, and the USP apparatus 2 is often referred to as a Basket.",
			Category->"Physical Properties"
		},
		CleanRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Rack],
			Description -> "The rack used to store this agitator when it is clean.",
			Category -> "Placements"
		}
	}
}];