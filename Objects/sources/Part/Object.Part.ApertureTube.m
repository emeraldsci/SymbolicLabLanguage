(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, ApertureTube], {
	Description -> "A hollow glass tube with a small aperture near the bottom. Connecting an aperture tube to the coulter counter allows for counting and sizing particles in a sample by suspending them in a conductive electrolyte solution, pumping them through an aperture, and measuring the corresponding electrical resistance change caused by particles in place of the ions passing through the aperture.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(*------------------------------Part Specifications------------------------------*)
		ApertureDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], ApertureDiameter]],
			Pattern :> GreaterP[0 Micrometer],
			Description -> "The nominal diameter of the aperture that is located in the bottom of the aperture tube, which dictates the accessible size window for particle size measurement.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		(*------------------------------Operating Limits------------------------------*)
		MaxCurrent -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxCurrent]],
			Pattern :> GreaterP[0 Microampere],
			Description -> "The maximum value of the constant current to apply to this aperture tube model during electrical resistance measurement to avoid damage.  The constant current is applied in order to register the momentary electrical resistance change per particle passage as voltage pulse to the electronics.",
			Category -> "Operating Limits"
		},
		MinParticleSize -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinParticleSize]],
			Pattern :> GreaterP[0 Micrometer],
			Description -> "The minimum particle size the coulter counter instrument can detect when this aperture tube is connected.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxParticleSize -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxParticleSize]],
			Pattern :> GreaterP[0 Micrometer],
			Description -> "The maximum particle size the coulter counter instrument can detect when this aperture tube model is connected.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		(*------------------------------Qualifications & Maintenance------------------------------*)
		CalibrationConstant -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Description -> "The current calibration constant that this aperture tube uses to convert the voltage signals measured during the sample run of ExperimentCoulterCount into the particle size signal.",
			Category -> "Qualifications & Maintenance"
		},
		CalibrationLog -> {
			Format -> Multiple,
			Class -> {Date, Real, Link},
			Pattern :> {_?DateObjectQ, GreaterEqualP[0], _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Headers -> {"Date", "Calibration Constant", "Responsible Party"},
			Description -> "A historical log of all the calibrations that were performed on this aperture tube.",
			Category -> "Qualifications & Maintenance"
		}
	}
}];

