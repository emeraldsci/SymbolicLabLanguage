(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Simulation, Kinetics], {
	Description->"A calculation used to simulate the time based evolution of a specified system of chemical reactions.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		ReactionMechanism -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReactionMechanismP,
			Description -> "The ReactionMechanism describing the series of reactions that are avaiable to the reactants that was simulated to generate the kinetic trajectory.",
			Category -> "General"
		},
		Species -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ReactionSpeciesP,
			Description -> "All of the participating reagents involved in the ReactionMechanism.",
			Category -> "General"
		},
		ObservedSpecies -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ReactionSpeciesP,
			Description -> "Any species of interest in the simulation that will be traced and plotted in the final output.",
			Category -> "General"
		},
		InitialState -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> StateP,
			Description -> "The beginning state of the species involved in this simulation.",
			Category -> "General"
		},
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature value used to calculate the rate constants for simulation.",
			Category -> "General"
		},
		TemperatureFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Function,
			Description -> "A pure function describing the changing temperature vs time used to calculate the rate constants during the simulation.",
			Category -> "General"
		},
		InitialVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Nanoliter,
			Description -> "The total volume of the simulated system at the beginning of the simulation (before any injections).",
			Category -> "General"
		},
		Injections -> {
			Format -> Multiple,
			Class -> {Real, Expression, Real, Real, Real},
			Pattern :> {TimeP, ReactionSpeciesP, VolumeP, FlowRateP, ConcentrationP},
			Units -> {Minute, None, Microliter, Microliter/Second, Micromolar},
			Description -> "Injections into the system.",
			Category -> "General",
			Headers -> {"Injection Start Time","Species","Injection Volume","Injection Flow Rate","Injection Concentration"}
		},
		SimulationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "The time that was specified for the end of the simulation.",
			Category -> "General"
		},
		Method -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> KineticsSimulationMethodP,
			Description -> "The numerical method (Deterministic or Stochastic) used to solve the system of differential equations that describe the kinetics model.",
			Category -> "General"
		},
		Trajectory -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TrajectoryP,
			Description -> "The combined reaction coordinates for the species involved in the simulation.",
			Category -> "Simulation Results",
			Abstract -> True
		},
		FinalState -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> StateP,
			Description -> "The state of the species at the end of the simulation.",
			Category -> "Simulation Results",
			Abstract -> True
		},
		TemperatureProfile -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Second,Celsius}],
			Units -> {Second, Celsius},
			Description -> "The trace of temperature versus time resulting from the specified TemperatureFunction.",
			Category -> "Simulation Results"
		},
		VolumeProfile -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Second, Nanoliter}],
			Units -> {Second, Nanoliter},
			Description -> "The trace of volume versus time, accounting for any injections that happen during simulation.",
			Category -> "Simulation Results"
		},
		KineticsEquations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (KineticsEquationP|_WhenEvent),
			Description -> "The equations that were simulated to generate the Trajectory.",
			Category -> "General",
			Abstract -> True
		}

	}
}];
