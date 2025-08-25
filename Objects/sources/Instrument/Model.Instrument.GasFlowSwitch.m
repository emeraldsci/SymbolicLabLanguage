(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, GasFlowSwitch], {
	Description->"Model information for an instrument that is used to switch the flow of gas from two source tanks on the basis of each tank's source pressure.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		OutputPressure->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*PSI],
			Units -> PSI,
			Description->"Gas pressure delivered and maintained in the facility supply lines.",
			Category-> "Instrument Specifications",
			Abstract -> True
		},
		LowActivationPressure->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*PSI],
			Units -> PSI,
			Description->"Lowest operating pressure of the active connected cylinder, at which point the Gas Flow Switch changes to draw gas from the alternate cylinder.",
			Category-> "Instrument Specifications"
		},
		HighActivationPressure->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*PSI],
			Units -> PSI,
			Description->"Highest pressure the alternate cylinder can reach, at which point the Gas Flow Switch will change to use that cylinder to relieve pressure.",
			Category-> "Instrument Specifications"
		},
		SwitchBackPressure->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*PSI],
			Units -> PSI,
			Description->"Pressure that the alternate cylinder drops to before the Gas Flow Switch changes back to the active cylinder unless the active cylinder is empty.",
			Category-> "Instrument Specifications"
		},
		TurnsToOpen->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[1/4,5,1/4],
			Description->"The number of turns (in 1/4 turn increments) that the pressure builder valves of tanks connected to this model of gas flow switch should be opened.",
			Category->"Instrument Specifications"
		}
	}
}];
