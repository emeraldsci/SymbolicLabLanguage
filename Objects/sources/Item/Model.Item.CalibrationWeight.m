(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, CalibrationWeight], {
	Description->"A reference weight of know mass used for calibration of high-precision balances.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
	
		NominalWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Gram],
			Units -> Gram,
			Description -> "The expected manufactured weight of the calibration weight.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		AllowedWeightTolerance  -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*(Milli Gram)],
			Units -> (Milli Gram),
			Description -> "The maximum permissible error (+/-) for this weight, based on its NominalWeight and WeightClass.",
			Category -> "Physical Properties",
			Abstract -> True
		},		
		Shape -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WeightShapeP,
			Description -> "The shape in which the calibration weight was manufactured.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		WeightClass -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> OIMLWeightClassP,
			Description -> "The calibration weight class of the item based on the OIML (Organisation Internationale de Metrologie Legale) standard.",
			Category -> "Physical Properties",
			Abstract -> True
		},		
		Material -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The material that the weight is made out of.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		WeightHandle -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, WeightHandle][CalibrationWeights],
				Model[Item, Tweezer][CalibrationWeights]
			],
			Description -> "The weight fork/tweezer/handle that is appropriate to move this calibration weight to and from the balance.",
			Category -> "Model Information"
		}	
		
	}
}];
