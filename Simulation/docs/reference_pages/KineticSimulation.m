(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineUsage[ReactionEquations,
	{
		BasicDefinitions -> {
			{"ReactionEquations[reactionEquations]", "odes", "returns the Ordinary Differential Equations (ODEs) that correspond to the given reaction equations."}
		},
		Input :> {
			{"reactionEquations",{_Rule..},"The reaction equations for which to derive ODEs for."}
		},
		Output :> {
			{"odes", _List, "The Ordinary Differential Equations (ODEs) that correspond to the given reaction equations."}
		},
		SeeAlso -> {
			"SimulateKinetics"
		},
		Author -> {
			"brad"
		}
	}
];

(* ::Subsubsection:: *)
(*SimulateKinetics*)


DefineUsageWithCompanions[SimulateKinetics,{
	BasicDefinitions -> {
		{
			Definition->{"SimulateKinetics[reactionModel, initialCondition, simulationDuration]", "trajectory"},
			Description->"performs kinetic simulation of reaction network described by 'reactionModel', starting from initial condition 'initialCondition', until the time 'simulationDuration'.",
			Inputs:>{
				{
					InputName->"reactionModel",
					Widget->Alternatives[
						Widget[Type->Object, Pattern:> ObjectP[{Model[ReactionMechanism], Object[Simulation,ReactionMechanism]}]],
						Widget[Type->Expression, Pattern:> {ImplicitReactionP..} | ReactionMechanismP | {_?ArrayQ, _?ArrayQ, _?ListQ, _?ListQ} , PatternTooltip->"A reaction mechanism like ReactionMechanism[Reaction[{\"a\"+\"b\"\[Equilibrium]\"c\",10^5,10^-5}]], or {sparse array, sparse array, list, list}.", Size->Line],
						Adder[Widget[Type->Expression, Pattern:> ImplicitReactionP, PatternTooltip->"An implicit reaction like {\"a\"+\"b\"\[Equilibrium]\"c\",10^5,10^-5}.", Size->Line]],
						Adder[Widget[Type->Expression, Pattern:> KineticsEquationP, PatternTooltip->"A first-order ODE like X'[t] = -10*X[t].", Size->Line]]
					],
					Expandable->False,
					Description->"A model describing the reaction network to simulate."
				},
				{
					InputName->"initialCondition",
					Widget->Alternatives[
						Adder[{
							"Species"->Widget[Type->String, Pattern:>  _?StringQ, Size -> Word],
							"Concentration"->Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Picomolar], Units-> Picomolar | Nanomolar | Micromolar | Millimolar | Molar]
						}, Orientation -> Vertical],
						Widget[Type->Expression, Pattern:> StateP | ListableP[InitialConditionP,2], PatternTooltip->"A state like State[{Structure[...],concentration}..]}] or one or a list of initial conditions like {\"a\"->4 Micromolar,\"b\"->3 Micromolar}.", Size->Line],
						Adder[
							Widget[Type->Number, Pattern:> GreaterEqualP[0], PatternTooltip->"Concentration in Molar for each species in order like 4 10^-6"]
						]
					],
					Expandable->False,
					Description->"Initial state of the system.  Unspecified initial concentrations are set to 0 by default.  If no Units specified, simulator assumes Molar."
				},
				{
					InputName->"simulationDuration",
					Widget->Widget[Type->Quantity, Pattern:> GreaterP[0 Second], Units-> Second | Minute | Hour | Day ],
					Expandable->False,
					Description->"Length of the time to run the simulation.  If no Units specified, simulator assumes 'simulationDuration' is in seconds."
				}
			},
			Outputs:> {
				{
					OutputName->"trajectory",
					Pattern:> TrajectoryP | Packet | ObjectP[Object[Simulation, Kinetics]],
					Description->"A Trajectory containing the simulated results."
				}
			}
		},
		{
			Definition->{"SimulateKinetics[initialCondition, simulationDuration]", "out"},
			Description->"generates a mechanism from initial condition and then simulates its kinetics until the time 'simulationDuration'.",
			Inputs:>{
				{
					InputName->"initialCondition",
					Widget->Alternatives[
						Adder[{
							"Species"->Widget[Type->String, Pattern:>  _?StringQ, Size -> Word],
							"Concentration"->Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Picomolar], Units-> Picomolar | Nanomolar | Micromolar | Millimolar | Molar]
						}, Orientation -> Vertical],
						Widget[Type->Expression, Pattern:> StateP | ListableP[InitialConditionP,2], PatternTooltip->"A state like State[{Structure[...],concentration}..]}] or one or a list of initial conditions like  {\"a\"->4 Micromolar,\"b\"->3 Micromolar}.", Size->Line],
						Adder[
							Widget[Type->Number, Pattern:> GreaterEqualP[0], PatternTooltip->"Concentration in Molar for each species in order like 4 10^-6"]
						]
					],
					Expandable->False,
					Description->"Initial state of the system.  Unspecified initial concentrations are set to 0 by default.  If no Units specified, simulator assumes Molar."
				},
				{
					InputName->"simulationDuration",
					Widget->Widget[Type->Quantity, Pattern:> GreaterP[0 Second], Units-> Second | Minute | Hour | Day ],
					Expandable->False,
					Description->"Length of the time to run the simulation.  If no Units specified, simulator assumes 'simulationDuration' is in seconds."
				}
			},
			Outputs:> {
				{
					OutputName->"trajectory",
					Pattern:> TrajectoryP | Packet | ObjectP[Object[Simulation, Kinetics]],
					Description->"A Trajectory containing the simulated results."
				}
			}
		}
	},
	MoreInformation -> {
		"There are two different injection models: slow and fast/instantaneous.  Fast injections have the form {TimeP,Species,Volume,Concentration} | {TimeP,Species,Volume,Null,Concentration} where in the latter case Null implies instantaneous injection of the full volume.  Slow injections have the form {TimeP,Species,Volume,Rate,Concentration}.  The full form is for a list of injections, one for each species added."
	},
	SeeAlso -> {
		"SimulateReactivity",
		"PlotTrajectory"
	},
	Author -> {
		"brad",
		"david.hattery",
		"qian",
		"alice"
	},
	Preview -> True
}];
