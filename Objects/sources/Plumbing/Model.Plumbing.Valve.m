(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Plumbing,Valve], {
	Description->"Model information for a plumbing component that can direct the flow of liquids/gases through a plumbing system.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		ValvePositions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ValvePositionP,
			Description -> "The possible flow states for this valve, in the form: position name->None|{(connector group with active flow)..}.",
			Category -> "Plumbing Information",
			Abstract->True
		},
		ValveType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ValveShuttingMechanismP,
			Description -> "The mechanism employed by this model of valve to obstruct fluid flow.",
			Category -> "Plumbing Information"
		},		
		ValveOperation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ValveOperationP,
			Description -> "How the valve state is changed during normal operation.",
			Category -> "Plumbing Information"
		},
		Actuator -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ActuatorTypeP,
			Description -> "The means by which this valve is turned on and off.",
			Category -> "Part Specifications",
			Abstract -> True
		}
	}
}];
