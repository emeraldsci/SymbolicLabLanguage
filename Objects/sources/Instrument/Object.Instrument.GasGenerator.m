(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, GasGenerator], {
	Description->"A gas generator used to generate a supply of a desired gas.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- Instrument Specifications ---*)
		GasGenerated -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> (ZeroAir|Dihydrogen), (* GasesP? *)
			Description -> "The gas that this gas generator generates.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		DeliveryPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Description -> "The pressure at which the gas generator delivers the generated gas.",
			Category -> "Instrument Specifications",
			Units -> PSI,
			Abstract -> True
		},
		GasOutputPurity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0*Percent,100*Percent],
			Description -> "The nominal purity of the gas that will be generated by this gas generator.",
			Category -> "Instrument Specifications",
			Units -> Percent,
			Abstract -> True
		},
		GasOutletConnections -> {
			Format -> Multiple,
			Class -> {Expression, String, Expression, Expression, Real, Real},
			Pattern :> {ConnectorP, ThreadP, MaterialP, ConnectorGenderP, GreaterEqualP[0*Milli*Meter], GreaterEqualP[0*Milli*Meter]},
			Units -> {None, None, None, None, Meter Milli, Meter Milli},
			Description -> "The connector(s) through which the gas generator delivers the gas supply.",
			Headers -> {"Connector Type", "Thread Type", "Material", "Gender", "Inner Diameter", "Outer Diameter"},
			Category -> "Instrument Specifications"
		},
		RequiredInputs -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (Air|MilliQWater), (* MaterialP? *)
			Description -> "The resource(s) required to generate the gas.",
			Category -> "Instrument Specifications",
			Abstract -> True
		}

	}
}];
