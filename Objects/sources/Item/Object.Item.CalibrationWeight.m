(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Item, CalibrationWeight], {
	Description->"A reference weight of known mass used for calibration of high-precision balances.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		(* VOQ to check that NominalWeight should match field of same name in Model *)
		NominalWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Gram],
			Units -> Gram,
			Description -> "The expected manufactured weight of the calibration weight.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		(* actual weight as given by manufacturer *)		
		Weight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Gram],
			Units -> Gram,
			Description -> "The actual conventional mass of this calibration weight as given by the manufacturer. The conventional mass of a body is equal to the mass of a standard that balances this body under the conditions of: temperature = 20 Celsius, density of standard = 8000 kg/m^3, and density of air = 1.2 kg/m^3.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		WeightUncertainty-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Gram],
			Units -> Gram,
			Description -> "The expanded uncertainty of measurement, U, as given by the manufacturer with k = 2. The expanded uncertainty, U, is the standard uncertainty of measurement multiplied by the coverage factor, k = 2. For a normal distribution this expanded uncertainty corresponds to a coverage probability of ~95%.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		CalibrationCertificateFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "PDF of the weight's calibration cerificate.",
			Category -> "Physical Properties"
		}
	}
}];
