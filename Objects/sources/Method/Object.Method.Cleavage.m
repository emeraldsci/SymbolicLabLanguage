

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

DefineObjectType[Object[Method, Cleavage], {
	Description->"A set of method parameters for cleaving oligomer strands from their resin support following solid phase synthesis.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		(* --- Swelling --- *)
		SwellSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Sample, StockSolution]
			],
			Description -> "The solution used to swell the resin after synthesis and before cleavage of the strands from the resin.",
			Category -> "Swelling"
		},
		SwellVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Milli,
			Description -> "The volume of swell solution used to swell the resin after synthesis and before cleavage of the strands from the resin.",
			Category -> "Swelling"
		},
		SwellTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "The length of time for which swell solution is used to swell the resin after synthesis and before cleavage of the strands from the resin.",
			Category -> "Swelling"
		},
		
		(* --- Cleavage --- *)
		CleavageSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Sample, StockSolution]
			],
			Description -> "The solution that is used to cleave the synthesized strands from the resin.",
			Category -> "Cleavage"
		},
		CleavageSolutionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Milli,
			Description -> "The volume of cleavage solution that is used to cleave the strands from the resin.",
			Category -> "Cleavage"
		},
		CleavageTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Hour,
			Description -> "The amount of time for which the strands are incubated in cleavage solution.",
			Category -> "Cleavage"
		},
		CleavageTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the strands are incubated during cleavage.",
			Category -> "Cleavage"
		},
		CleavageWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Sample, StockSolution]
			],
			Description -> "The solution that is used to wash the resin following cleavage.",
			Category -> "Cleavage"
		},
		CleavageWashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Milli,
			Description -> "The volume of cleavage wash solution that is used to wash the resin following cleavage.",
			Category -> "Cleavage"
		},
		NumberOfCleavageCycles -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "The number of times the resin is incubated with the cleavage solution.",
			Category -> "Cleavage"
		}
	}
}];
