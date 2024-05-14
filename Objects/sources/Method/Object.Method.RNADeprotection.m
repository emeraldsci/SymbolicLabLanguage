(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

DefineObjectType[Object[Method, RNADeprotection], {
	Description->"A set of method parameters for removing 2-OH protection group from RNA after solid phase synthesis and cleavage.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- Resuspension --- *)
		RNADeprotectionResuspensionSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of StrandModels, the solution used to dissolve oligomer before the removal of the 2-OH protective group.",
			Category -> "Resuspension"
		},
		RNADeprotectionResuspensionSolutionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Milli * Liter],
			Units -> Liter Milli,
			Description -> "For each member of StrandModels, the solution used to dissolve oligomer before the removal of the 2-OH protective group.",
			Category -> "Resuspension"
		},
		RNADeprotectionResuspensionTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Hour],
			Units -> Hour,
			Description -> "For each member of StrandModels, the time that the oligomer will be incubated solution used for resuspension.",
			Category -> "Resuspension"
		},
		RNADeprotectionResuspensionTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Celsius],
			Units -> Celsius,
			Description -> "For each member of StrandModels, the temperature at which the oligomer will be incubated solition for resuspension.",
			Category -> "Resuspension"
		},

		(* --- Deprotection --- *)
		RNADeprotectionSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Sample, StockSolution]
			],
			Description -> "The solution that is used to remove 2-OH protective group from oligomers.",
			Category -> "Deprotection"
		},
		RNADeprotectionSolutionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Liter],
			Units -> Liter Milli,
			Description -> "The volume of solution that is used to remove 2-OH protective group from oligomers.",
			Category -> "Deprotection"
		},
		RNADeprotectionTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Celsius],
			Units -> Celsius,
			Description -> "The temperature at which the strands are incubated during 2-OH protective group removal.",
			Category -> "Deprotection"
		},
		RNADeprotectionTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Hour,
			Description -> "The amount of time for which the strands are incubated in 2-OH protective group removal solution.",
			Category -> "Deprotection"
		},

		RNADeprotectionQuenchingSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Sample, StockSolution]
			],
			Description -> "The solution for quenching the 2-OH protective group deprotection reaction.",
			Category -> "Deprotection"
		},
		RNADeprotectionQuenchingSolutionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Liter],
			Units -> Liter Milli,
			Description -> "The volume of quenching solution that is used to stop 2-OH protective group removal.",
			Category -> "Deprotection"
		}
	}
}];
