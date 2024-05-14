

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, VacuumPump], {
	Description->"The model of an instrument that removes gas from a sealed volume in order to create a partial vacuum.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		PumpType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> VacuumPumpTypeP,
			Description -> "Type of vacuum pump. Options include Oil, Diaphragm, Rocker, or Scroll.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		VacuumPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0*Atmosphere, 1*Atmosphere],
			Units -> Torr,
			Description -> "Minimum absolute pressure (zero-referenced against perfect vacuum) that this pump can achieve.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		MaxFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Liter)/Minute],
			Units -> Liter/Minute,
			Description -> "Maximum amount of air that the pump can displace for a given time under ideal circumstances.",
			Category -> "Instrument Specifications"
		},
		TubingInnerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "Internal diameter of the vacuum tubing that connects to the instrument.",
			Category -> "Instrument Specifications"
		},
		RotaryEvaporator -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _Link,
			Relation -> Model[Instrument,RotaryEvaporator][VacuumPump],
			Description -> "The model of rotovap this vacuum pump connects to.",
			Category -> "Instrument Specifications"
		}
	}
}];
