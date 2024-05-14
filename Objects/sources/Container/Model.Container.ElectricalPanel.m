(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container, ElectricalPanel], {
	Description->"A model of an electrical panel in which circuit breakers are installed.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		MaxSinglePoleVoltage -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "The maximum voltage allowed to run through a single-pole circuit breaker installed in this panel. Obtained from the lower value of the slash-rated voltage on the electrical panel.",
			Category -> "Operating Limits"
		},

		MaxMultiPoleVoltage -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "The maximum voltage allowed to run through a multi-pole circuit breaker installed in this panel. Obtained from the higher value of the slash-rated voltage on the electrical panel.",
			Category -> "Operating Limits"
		},

		MaxCurrent -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Ampere],
			Units -> Ampere,
			Description -> "Maximum current that can be tolerated by this wiring component without damage or safety concerns.",
			Category -> "Operating Limits"
		},

		TotalNumberOfSpaces -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The total number of slots that this electrical panel has for circuit breaker switches to be installed in.",
			Category -> "Container Specifications"
		}
    }
}];
