(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Simulation, MeltingCurve], {
	Description->"A simulation to predict the melting and cooling curves for a given nucleic acid.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		UnboundState -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> StateP,
			Description -> "The initial unbound state of the strands and their concentrations.",
			Category -> "General",
			Abstract -> True
		},
		HighTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The maximum temperature used in the simulation.",
			Category -> "General"
		},
		LowTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum temperature used in the simulation.",
			Category -> "General"
		},
		TemperatureStep -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "The stepwise change in temperature from one temperature point in the simulation to the next temperature point.",
			Category -> "General"
		},
		TemperatureRampRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Celsius)/Second],
			Units -> Celsius/Second,
			Description -> "The rate of change from one temperature point in the simulation to the next temperature point.",
			Category -> "General"
		},
		EquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The length of time for which kinetics were simulated at the high and low temperature extremes, to allow for equilibration.",
			Category -> "General"
		},
		StepEquilibriumTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The length of time for which kinetics were simulated at each temperature point during the up and down temperature sweeps.",
			Category -> "General"
		},
		LabeledStructures -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> StructureP,
			Description -> "The structures of interest that have been selected to be plotted by this simulation.",
			Category -> "General"
		},
		ReactionMechanism -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReactionMechanismP,
			Description -> "The ReactionMechanism being simulated over the temperature ranges.",
			Category -> "General"
		},
		MeltingCurve -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> ThermodynamicTrajectoryP,
			Units -> None,
			Description -> "Simulated thermodynamic trajectory of the melting curve of an oligomer with rising temperature.",
			Category -> "Simulation Results",
			Abstract -> True
		},
		CoolingCurve -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> ThermodynamicTrajectoryP,
			Units -> None,
			Description -> "Simulated thermodynamic trajectory of the cooling curve of an oligomer with falling temperature.",
			Category -> "Simulation Results",
			Abstract -> True
		},
		ExperimentalData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, FluorescenceThermodynamics][Simulations],
			Description -> "Data from experiments where the molocules and conditions match this simulation.",
			Category -> "Experimental Results"
		}
	}
}];
