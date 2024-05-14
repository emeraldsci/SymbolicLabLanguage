(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*KineticSimulation: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*Simulation*)

(* ::Subsubsection:: *)
(*ReactionEquations*)

DefineTests[ReactionEquations,
	{
		Example[{Basic, "Derive the ODEs for the given reactions:"},
			ReactionEquations[{A -> B, B -> C}],
			List[
				Verbatim[Equal][Derivative[1][A][t], Verbatim[Times][-1, _Symbol, A[t]]],
				Verbatim[Equal][Derivative[1][B][t], Verbatim[Plus][Verbatim[Times][_Symbol, A[t]], Verbatim[Times][-1, _Symbol, B[t]]]],
				Verbatim[Equal][Derivative[1][C][t], Verbatim[Times][_Symbol, B[t]]]
			]
		]
	}
];

(* ::Subsubsection:: *)
(*SimulateKinetics*)


DefineTestsWithCompanions[
	SimulateKinetics,
	{
		Example[{Basic,"Simulate a hybridization reaction for 60 seconds:"},
			PlotTrajectory[SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",10^5,10^-5}},{"a"->4Micromolar,"b"->3Micromolar},60*Second]],
			ValidGraphicsP[],
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",10^5,10^-5}},{"a"->4Micromolar,"b"->3Micromolar},60*Second] =
				SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",10^5,10^-5}},{"a"->4Micromolar,"b"->3Micromolar},60*Second, Upload->False]
			}
		],

		Example[{Basic,"Simulate an irreversible reaction for 60 seconds:"},
			PlotTrajectory[SimulateKinetics[{{"a"+"b"->"c",10^5}},{"a"->4Micromolar,"b"->3Micromolar},60*Second]],
			ValidGraphicsP[],
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[{{"a"+"b"->"c",10^5}},{"a"->4Micromolar,"b"->3Micromolar},60*Second] =
				SimulateKinetics[{{"a"+"b"->"c",10^5}},{"a"->4Micromolar,"b"->3Micromolar},60*Second, Upload->False]
			}
		],

		Example[{Basic,"Simulation time without units defaults to seconds:"},
			PlotTrajectory[SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",10^5,10^-5}},{"a"->4Micromolar,"b"->3Micromolar},60]],
			ValidGraphicsP[],
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",10^5,10^-5}},{"a"->4Micromolar,"b"->3Micromolar},60] =
				SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",10^5,10^-5}},{"a"->4Micromolar,"b"->3Micromolar},60, Upload->False]
			}
		],

		Example[{Basic,"Allows list of numeric initial conditions:"},
			PlotTrajectory[SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",10^5,10^-5}},{4 10^-6,3 10^-6,0},60*Second]],
			ValidGraphicsP[],
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",10^5,10^-5}},{4^-6,3^-6,0},60] =
				SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",10^5,10^-5}},{4^-6,3^-6,0},60, Upload->False]
			}
		],

		Test["Simulate a pairing reaction for 60 seconds, check packet:",
			SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",10^5,10^-5}}, {"a"->4Micromolar,"b"->3Micromolar}, 60*Second, Upload->False],
			Simulation`Private`validSimulationPacketP[Object[Simulation,Kinetics],{
				InitialState-> State[{"a", Quantity[4, "Micromolar"]}, {"b", Quantity[3, "Micromolar"]}, {"c", Quantity[0, "Micromolar"]}],
				FinalState-> State[{"a", 1.0021555273677474*^-6}, {"b", 2.1555273677500377*^-9}, {"c", 2.9978444726322515*^-6}],
				Temperature->37.*Celsius,
				ReactionMechanism -> ReactionMechanism[Reaction[{"a", "b"}, {"c"}, 100000, 1/100000]],
				Append[ObservedSpecies]->{"a","b","c"},
				SimulationTime->60.*Second,
				InitialVolume->150000Nanoliter,
				Method->Deterministic,
				Trajectory->TrajectoryP,
				TemperatureProfile->QuantityCoordinatesP[{Second,Celsius}],
				VolumeProfile -> QuantityCoordinatesP[{Second,Liter}],
				TemperatureFunction->(Rational[6203, 20]&),
				UnresolvedOptions->{Upload->False}
			},
			ResolvedOptions->{Volume->150*Microliter,Noise->Null,Method->Deterministic,NumberOfPoints->50,ObservedSpecies->{"a","b","c"},Injections->{},Template->Null,NumberOfTrajectories->Null,Vectorized->True, Output->Result,Jacobian->True,AccuracyGoal->6,PrecisionGoal->8,MaxStepFraction->1/100},
			Round->3],
			TimeConstraint -> 200
		],

		Test["Enter initial conditions as a paired list as in Command Center:",
			SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",10^5,10^-5}}, {{"a",4Micromolar},{"b",3Micromolar}}, 60*Second, Upload->False],
			Simulation`Private`validSimulationPacketP[Object[Simulation,Kinetics],{
				InitialState-> State[{"a", Quantity[4, "Micromolar"]}, {"b", Quantity[3, "Micromolar"]}, {"c", Quantity[0, "Micromolar"]}],
				FinalState-> State[{"a", 1.0021555273677474*^-6}, {"b", 2.1555273677500377*^-9}, {"c", 2.9978444726322515*^-6}],
				Temperature->37.*Celsius,
				ReactionMechanism -> ReactionMechanism[Reaction[{"a", "b"}, {"c"}, 100000, 1/100000]],
				Append[ObservedSpecies]->{"a","b","c"},
				SimulationTime->60.*Second,
				InitialVolume->150000Nanoliter,
				Method->Deterministic,
				Trajectory->TrajectoryP,
				TemperatureProfile->QuantityCoordinatesP[{Second,Celsius}],
				VolumeProfile -> QuantityCoordinatesP[{Second,Liter}],
				TemperatureFunction->(Rational[6203, 20]&),
				UnresolvedOptions->{Upload->False}
			},
			ResolvedOptions->{Volume->150*Microliter,Noise->Null,Method->Deterministic,NumberOfPoints->50,ObservedSpecies->{"a","b","c"},Injections->{},Template->Null,NumberOfTrajectories->Null,Vectorized->True, Output->Result,Jacobian->True,AccuracyGoal->6,PrecisionGoal->8,MaxStepFraction->1/100},
			Round->3],
			TimeConstraint -> 200
		],

		Example[{Basic,"Simulate the kinetics of the a mechanism from the given initial state:"},
			PlotTrajectory[SimulateKinetics[hybridizationMechanism,initialState, 1 Hour]],
			ValidGraphicsP[],
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[hybridizationMechanism,initialState,1 Hour] =
				SimulateKinetics[hybridizationMechanism,initialState,1 Hour, Upload->False]
			}
		],

		Example[{Additional,"Given differential equation directly:"},
			PlotTrajectory[SimulateKinetics[{X'[t] == -2*X[t]}, {X -> Meter}, 10*Second]],
			ValidGraphicsP[]
		],

		Example[{Additional,"A first order irreversible reaction can have multiple products:"},
			PlotTrajectory[SimulateKinetics[{{a -> b + c + d, 1}, {b -> bz, .5}, {c -> cz, .1}}, {a -> 1}, 45 Second]],
			ValidGraphicsP[],
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[{{a -> b + c + d, 1}, {b -> bz, .5}, {c -> cz, .1}}, {a -> 1}, 45 Second] =
				SimulateKinetics[{{a -> b + c + d, 1}, {b -> bz, .5}, {c -> cz, .1}}, {a -> 1}, 45 Second, Upload->False]
			}
		],

		Example[{Additional,"A second order irreversible reaction can have multiple products:"},
			PlotTrajectory[SimulateKinetics[{{a + f -> b + c + d, 1}, {b -> bz, .5}, {c -> cz, .1}}, {a -> 1, f -> 0.9}, 45 Second]],
			ValidGraphicsP[],
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[{{a + f -> b + c + d, 1}, {b -> bz, .5}, {c -> cz, .1}}, {a -> 1, f -> 0.9}, 45 Second] =
				SimulateKinetics[{{a + f -> b + c + d, 1}, {b -> bz, .5}, {c -> cz, .1}}, {a -> 1, f -> 0.9}, 45 Second, Upload->False]
			}
		],

		Example[{Additional,"Return the final state:"},
			SimulateKinetics[{{"a" + "b" \[Equilibrium] "c", 10^5, 1/10^5}}, {"a" -> 4 Micromolar,"b" -> 3 Micromolar},60 Second][FinalState],
			StateP,
			TimeConstraint -> 200
		],

		Example[{Basic,"Input can be specified as a ReactionMechanism object:"},
			PlotTrajectory[SimulateKinetics[Object[Simulation,ReactionMechanism,"id:N80DNj1rM6Dq"],{Structure[{Strand[DNA["CATAGCGTTGTCGTCGCCTATGTATGG"]]}, {}]->Micromolar, Structure[{Strand[DNA["CCATACATAGGCGACGACAACGCTATG"]]}, {}] -> Micromolar},200 Second]],
			ValidGraphicsP[],
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[Object[Simulation,ReactionMechanism,"id:N80DNj1rM6Dq"],{Structure[{Strand[DNA["CATAGCGTTGTCGTCGCCTATGTATGG"]]}, {}]->Micromolar, Structure[{Strand[DNA["CCATACATAGGCGACGACAACGCTATG"]]}, {}] -> Micromolar},200 Second] =
				SimulateKinetics[Object[Simulation,ReactionMechanism,"id:N80DNj1rM6Dq"],{Structure[{Strand[DNA["CATAGCGTTGTCGTCGCCTATGTATGG"]]}, {}]->Micromolar, Structure[{Strand[DNA["CCATACATAGGCGACGACAACGCTATG"]]}, {}] -> Micromolar},200 Second, Upload->False]
			}
		],

		Example[{Options,Temperature,"Simulate the kinetics of the mechanism at specified temperature:"},
			PlotTrajectory[SimulateKinetics[hybridizationMechanism,initialState,60 Second,Temperature->60Celsius]],
			ValidGraphicsP[],
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[hybridizationMechanism,initialState,60 Second,Temperature->60Celsius] =
				SimulateKinetics[hybridizationMechanism,initialState,60 Second,Temperature->60Celsius, Upload->False]
			}
		],

		Example[{Options,Temperature,"Temperature can be a function of time, which varies along with the simulation:"},
			PlotTrajectory[SimulateKinetics[hybridizationMechanism,initialState,200 Second,Temperature->(273+30+#/3&)]],
			ValidGraphicsP[],
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[hybridizationMechanism,initialState,200 Second, Temperature->(273+30+#/3&)] =
				SimulateKinetics[hybridizationMechanism,initialState,200 Second, Temperature->(273+30+#/3&), Upload->False]
			}
		],

		Example[{Options,Temperature,"Periodic heating and cooling causes weaker structures to slow get consumed by the stronger structures:"},
			PlotTrajectory[SimulateKinetics[hybridizationMechanism,initialState,60 Second,Temperature->(273+35*Sin[0.4*#1]&),AccuracyGoal->8]],
			ValidGraphicsP[],
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[hybridizationMechanism,initialState,60 Second,Temperature->(273+35*Sin[0.4*#1]&),AccuracyGoal->8] =
				SimulateKinetics[hybridizationMechanism,initialState,60 Second,Temperature->(273+35*Sin[0.4*#1]&),AccuracyGoal->8, Upload->False]
			}
		],

		Example[{Options,Volume,"Simulate the system with small number of molecules:"},
			PlotTrajectory[SimulateKinetics[hybridizationMechanism,initialState,1 Hour,Volume->.005Pico Liter]],
			ValidGraphicsP[],
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[hybridizationMechanism,initialState,1 Hour,Volume->.005Pico Liter] =
				SimulateKinetics[hybridizationMechanism,initialState,1 Hour,Volume->.005Pico Liter, Upload->False]
			}
		],

		Example[{Options,Volume,"Specify a small Volume to conduct a stochastic simulation on individual level:"},
			PlotTrajectory[
				SimulateKinetics[{{"a" + "b" \[Equilibrium] "c", 10^5, 10^-5}, {"c" -> "d", 10^2}}, {"a" -> .4 Micromolar, "b" -> .3 Micromolar}, 100 Second, Volume -> .001 Pico Liter, Method -> Stochastic]
			],
			ValidGraphicsP[],
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[{{"a" + "b" \[Equilibrium] "c", 10^5, 10^-5}, {"c" -> "d", 10^2}}, {"a" -> .4 Micromolar, "b" -> .3 Micromolar}, 100 Second, Volume -> .001 Pico Liter, Method -> Stochastic] =
				SimulateKinetics[{{"a" + "b" \[Equilibrium] "c", 10^5, 10^-5}, {"c" -> "d", 10^2}}, {"a" -> .4 Micromolar, "b" -> .3 Micromolar}, 100 Second, Volume -> .001 Pico Liter, Method -> Stochastic, Upload->False]
			}
		],

		Example[{Options,Noise,"Specify a noise distribution and it will be sampled and injected into the simulation output:"},
			PlotTrajectory[SimulateKinetics[hybridizationMechanism,initialState,0.8 Hour,Noise->NormalDistribution[0,10^-8]]],
			ValidGraphicsP[],
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[hybridizationMechanism,initialState,0.8 Hour, Noise->NormalDistribution[0,10^-8]] =
				SimulateKinetics[hybridizationMechanism,initialState,0.8 Hour, Noise->NormalDistribution[0,10^-8], Upload->False]
			}
		],

		Example[{Options,Noise,"Specify noise as a percentage of the maximum value in the initial state:"},
			PlotTrajectory[SimulateKinetics[{{"a" + "b" \[Equilibrium] "c", 10^5, 1/10^5}}, {"a" -> 5 Micromolar,"b" -> 3 Micromolar},60 Second,Noise->1.5*Percent]],
			ValidGraphicsP[],
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[{{"a" + "b" \[Equilibrium] "c", 10^5, 1/10^5}}, {"a" -> 5 Micromolar,"b" -> 3 Micromolar},60 Second,Noise->1.5*Percent] =
				SimulateKinetics[{{"a" + "b" \[Equilibrium] "c", 10^5, 1/10^5}}, {"a" -> 5 Micromolar,"b" -> 3 Micromolar},60 Second,Noise->1.5*Percent, Upload->False]
			}
		],

		Example[{Options,Noise,"A specified concentration value will be used as the standard deviation in a NormalDistribution with zero mean:"},
			PlotTrajectory[SimulateKinetics[{{"a" + "b" \[Equilibrium] "c", 5, 1}, {"c" \[Equilibrium] "d", 1, 0.25}}, {"c" -> 5 Micromolar,"b" -> 3 Micromolar},20 Second,Noise->1.5*Percent]],
			ValidGraphicsP[],
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[{{"a" + "b" \[Equilibrium] "c", 5, 1}, {"c" \[Equilibrium] "d", 1, 0.25}}, {"c" -> 5 Micromolar,"b" -> 3 Micromolar},20 Second,Noise->1.5*Percent] =
				SimulateKinetics[{{"a" + "b" \[Equilibrium] "c", 5, 1}, {"c" \[Equilibrium] "d", 1, 0.25}}, {"c" -> 5 Micromolar,"b" -> 3 Micromolar},20 Second,Noise->1.5*Percent, Upload->False]
			}
		],

		Test["Use a different distribution to describe the noise:",
			PlotTrajectory[SimulateKinetics[hybridizationMechanism,initialState,0.8 Hour,Noise->UniformDistribution[{-1,1}*10^-8]]],
			ValidGraphicsP[],
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[hybridizationMechanism,initialState,0.8 Hour, Noise->UniformDistribution[{-1,1}*10^-8]] =
				SimulateKinetics[hybridizationMechanism,initialState,0.8 Hour, Noise->UniformDistribution[{-1,1}*10^-8], Upload->False]
			}
		],

		Example[{Options,Method,"Use analytic solution instead of stochastic simulation, which is only available for certain types of reaction networks:"},
			PlotTrajectory[SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",2,1}},{"a"->1.,"b"->0.75},10Second,Method->Analytic]],
			ValidGraphicsP[],
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",2,1}},{"a"->1.,"b"->0.75},10Second,Method->Analytic] =
				SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",2,1}},{"a"->1.,"b"->0.75},10Second,Method->Analytic, Upload->False]
			}
		],

		Example[{Options,Method,"Use the stochastic method to simulate the concentration changes:"},
			PlotTrajectory[SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",10^5,10^-5}},{"a"->4*10^-6,"b"->3*10^-6},20Second,Volume->10^-4*Picoliter,Method->Stochastic]],
			ValidGraphicsP[],
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",10^5,10^-5}},{"a"->4*10^-6,"b"->3*10^-6},20Second,Volume->10^-4*Picoliter,Method->Stochastic] =
				SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",10^5,10^-5}},{"a"->4*10^-6,"b"->3*10^-6},20Second,Volume->10^-4*Picoliter,Method->Stochastic, Upload->False]
			}
		],

		Example[{Options,Method,"Compare deterministic and stochastic simulation by overlaying the trajectories from both methods on top of each other:"},
			PlotTrajectory[List[
				SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",10^5,10^-5}},{"a"->4*10^-6,"b"->3*10^-6},20Second,Volume->10^-3*Picoliter,Method->Deterministic],
				SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",10^5,10^-5}},{"a"->4*10^-6,"b"->3*10^-6},20Second,Volume->10^-3*Picoliter,Method->Stochastic]
			]],
			ValidGraphicsP[],
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",10^5,10^-5}},{"a"->4*10^-6,"b"->3*10^-6},20Second,Volume->10^-3*Picoliter,Method->Deterministic] =
				SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",10^5,10^-5}},{"a"->4*10^-6,"b"->3*10^-6},20Second,Volume->10^-3*Picoliter,Method->Deterministic, Upload->False],

				SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",10^5,10^-5}},{"a"->4*10^-6,"b"->3*10^-6},20Second,Volume->10^-3*Picoliter,Method->Stochastic] =
				SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",10^5,10^-5}},{"a"->4*10^-6,"b"->3*10^-6},20Second,Volume->10^-3*Picoliter,Method->Stochastic, Upload->False]
			}
		],

		Example[{Options,NumberOfTrajectories,"Conduct 3 stochastic simulations of the same system and overlay them in the same plot:"},
			PlotTrajectory[SimulateKinetics[{{A -> B, 0.1 Second^-1}, {B + C -> D, 10^5 Molar^-1 Second^-1}},{A -> 1 Micro Molar, C -> 850 Nano Molar},Minute,Volume->Femtoliter,NumberOfTrajectories->3,Method->Stochastic]],
			ValidGraphicsP[],
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[{{A -> B, 0.1 Second^-1}, {B + C -> D, 10^5 Molar^-1 Second^-1}},{A -> 1 Micro Molar, C -> 850 Nano Molar},Minute,Volume->Femtoliter,NumberOfTrajectories->3,Method->Stochastic] =
				SimulateKinetics[{{A -> B, 0.1 Second^-1}, {B + C -> D, 10^5 Molar^-1 Second^-1}},{A -> 1 Micro Molar, C -> 850 Nano Molar},Minute, Volume->Femtoliter, NumberOfTrajectories->3, Method->Stochastic, Upload->False]
			}
		],

		Example[{Options,NumberOfPoints,"Specify number of points to sample solution at (which decides the sampling interval) when using Analytic solution method:"},
			SimulateKinetics[{{"a" + "b" \[Equilibrium] "c", 10^5, 1/10^5}}, {"a" -> 4 Micromolar, "b" -> 3 Micromolar}, 60 Second, NumberOfPoints -> 10, Method -> Analytic][Trajectory][Times],
			{Repeated[_?NumericQ,10]},
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[{{"a" + "b" \[Equilibrium] "c", 10^5, 1/10^5}}, {"a" -> 4 Micromolar, "b" -> 3 Micromolar}, 60 Second, NumberOfPoints -> 10, Method -> Analytic] =
				SimulateKinetics[{{"a" + "b" \[Equilibrium] "c", 10^5, 1/10^5}}, {"a" -> 4 Micromolar, "b" -> 3 Micromolar}, 60 Second, NumberOfPoints -> 10, Method -> Analytic, Upload->False]
			}
		],

		Example[{Options,Injections,"Injections to the system can be fully specified with FlowRate:"},
			PlotTrajectory[SimulateKinetics[{{"a"+"b"\[Equilibrium]"ab",10^5,0.1`},{"ab"+"c"\[Equilibrium]"a"+"bc",5*10^5,0.05`}},{"a"->10^-4.`},20.` Second, Injections->{{6. Second,"b",2Microliter,(1Microliter)/Second,.003 Molar},{12. Second,"c",3Microliter,(1Microliter)/Second,.002 Molar}},Volume->40Microliter]],
			ValidGraphicsP[],
			TimeConstraint -> 200,
			Stubs :> {
				 SimulateKinetics[{{"a"+"b"\[Equilibrium]"ab",10^5,0.1`},{"ab"+"c"\[Equilibrium]"a"+"bc",5*10^5,0.05`}},{"a"->10^-4.`},20.` Second, Injections->{{6. Second,"b",2Microliter,(1Microliter)/Second,.003 Molar},{12. Second,"c",3Microliter,(1Microliter)/Second,.002 Molar}},Volume->40Microliter] =
				 SimulateKinetics[{{"a"+"b"\[Equilibrium]"ab",10^5,0.1`},{"ab"+"c"\[Equilibrium]"a"+"bc",5*10^5,0.05`}},{"a"->10^-4.`},20.` Second, Injections->{{6. Second,"b",2Microliter,(1Microliter)/Second,.003 Molar},{12. Second,"c",3Microliter,(1Microliter)/Second,.002 Molar}},Volume->40Microliter, Upload->False],
				Message[Reduce::ratnz,___]:=Null
			}
		],

		Example[{Options,Injections,"Without specifying FlowRate the injections are treated as instantaneous:"},
			PlotTrajectory[SimulateKinetics[{{"a"+"b"\[Equilibrium]"ab",10^5,0.1`},{"ab"+"c"\[Equilibrium]"a"+"bc",5*10^5,0.05`}},{"a"->10^-4.`},20.` Second, Injections->{{6. Second,"b",2Microliter,.003 Molar},{12. Second,"c",3Microliter,.002 Molar}},Volume->40Microliter]],
			ValidGraphicsP[],
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[{{"a"+"b"\[Equilibrium]"ab",10^5,0.1`},{"ab"+"c"\[Equilibrium]"a"+"bc",5*10^5,0.05`}},{"a"->10^-4.`},20.` Second, Injections->{{6. Second,"b",2Microliter,.003 Molar},{12. Second,"c",3Microliter,.002 Molar}},Volume->40Microliter] =
						SimulateKinetics[{{"a"+"b"\[Equilibrium]"ab",10^5,0.1`},{"ab"+"c"\[Equilibrium]"a"+"bc",5*10^5,0.05`}},{"a"->10^-4.`},20.` Second, Injections->{{6. Second,"b",2Microliter,.003 Molar},{12. Second,"c",3Microliter,.002 Molar}},Volume->40Microliter, Upload->False]
			}
		],

		Example[{Options,Injections,"Comparing the injections and slow injection models by overlaying trajectories on the same plot:"},
			PlotTrajectory[{
				SimulateKinetics[catchReleaseMechanism,{"a"->1.},20.*Second,Injections->{{1 Second,"b",2Microliter,10 Molar},{10 Second,"c",11*Microliter,10 Molar}},Volume->5*Microliter,ObservedSpecies->{"ab"}],
				SimulateKinetics[catchReleaseMechanism,{"a"->1.},20.*Second,Injections->{{1 Second,"b",2Microliter,(1Microliter)/Second,10 Molar},{10 Second,"c",11*Microliter,(1 Microliter)/Second,10 Molar}},Volume->5*Microliter,ObservedSpecies->{"ab"}]
			}, Legend->{"Fast Injections","Slow Injections"}],
			ValidGraphicsP[],
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[catchReleaseMechanism,{"a"->1.},20.*Second,Injections->{{1 Second,"b",2Microliter,10 Molar},{10 Second,"c",11*Microliter,10 Molar}},Volume->5*Microliter,ObservedSpecies->{"ab"}] =
				SimulateKinetics[catchReleaseMechanism,{"a"->1.},20.*Second,Injections->{{1 Second,"b",2Microliter,10 Molar},{10 Second,"c",11*Microliter,10 Molar}},Volume->5*Microliter,ObservedSpecies->{"ab"}, Upload->False],

				SimulateKinetics[catchReleaseMechanism,{"a"->1.},20.*Second,Injections->{{1 Second,"b",2Microliter,(1Microliter)/Second,10 Molar},{10 Second,"c",11*Microliter,(1 Microliter)/Second,10 Molar}},Volume->5*Microliter,ObservedSpecies->{"ab"}] =
				SimulateKinetics[catchReleaseMechanism,{"a"->1.},20.*Second,Injections->{{1 Second,"b",2Microliter,(1Microliter)/Second,10 Molar},{10 Second,"c",11*Microliter,(1 Microliter)/Second,10 Molar}},Volume->5*Microliter,ObservedSpecies->{"ab"}, Upload->False]
			}
		],

		Example[{Options,ObservedSpecies,"Specify species that are observed and recorded in the returned trajectory:"},
			PlotTrajectory[SimulateKinetics[{{"a"\[Equilibrium]"b",1,2},{"b"->"c",3}},{"a"->1},60*Second,ObservedSpecies->{"b","c"}]],
			_?ValidGraphicsQ,
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[{{"a"\[Equilibrium]"b",1,2},{"b"->"c",3}},{"a"->1},60*Second,ObservedSpecies->{"b","c"}] =
				SimulateKinetics[{{"a"\[Equilibrium]"b",1,2},{"b"->"c",3}},{"a"->1},60*Second, ObservedSpecies->{"b","c"}, Upload->False]
			}
		],

		Test["Specify species that are observed and recorded in the returned trajectory, test:",
			SimulateKinetics[{{"a"\[Equilibrium]"b",1,2},{"b"->"c",3}},{"a"->1},60*Second,ObservedSpecies->{"b","c"}][Trajectory][Species],
			{"b","c"},
			TimeConstraint -> 200
		],


		Example[{Options,Template,"A template simulation (Object Reference) whose methodology should be reproduced in running this simulation. Option values will be inherited from the template simulation, but can be individually overridden by directly specifying values for those options to this simulation function:"},
			PlotTrajectory[SimulateKinetics[{{"a" + "b" \[Equilibrium] "c", 10^5, 1/10^5}}, {"a" -> 2 Micromolar}, 60 Second, Template -> Object[Simulation, Kinetics, theTemplateObjectID, ResolvedOptions]]],
			ValidGraphicsP[],
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[{{"a" + "b" \[Equilibrium] "c", 10^5, 1/10^5}}, {"a" -> 2 Micromolar}, 60 Second, Template -> Object[Simulation, Kinetics, theTemplateObjectID, ResolvedOptions]] =
				SimulateKinetics[{{"a" + "b" \[Equilibrium] "c", 10^5, 1/10^5}}, {"a" -> 2 Micromolar}, 60 Second, Template -> Object[Simulation, Kinetics, theTemplateObjectID, ResolvedOptions], Upload->False]
			},
			SetUp :> (
				theTemplateObject = Upload[<|Type -> Object[Simulation, Kinetics], UnresolvedOptions -> {Injections -> {{Quantity[6., "Seconds"], "b",    Quantity[200, "Microliters"], Quantity[3, "Micromolar"]}}, Upload -> True},
		 		ResolvedOptions -> {Temperature -> Quantity[310, "Kelvin"], Volume -> Quantity[150,  "Microliters"], Noise -> Null, Method -> Deterministic, NumberOfPoints -> 50, ObservedSpecies -> {"a", "b", "c"}, Injections -> {{Quantity[6., "Seconds"], "b", Quantity[200, "Microliters"], Null, Quantity[3, "Micromolar"]}}, Template -> Null, Output -> Result, NumberOfTrajectories -> Null, Vectorized -> True, Upload -> True}, DeveloperObject -> True|>];
				theTemplateObjectID = theTemplateObject[ID];
			),
			TearDown :> (
				If[DatabaseMemberQ[theTemplateObject], EraseObject[theTemplateObject, Force -> True, Verbose -> False]];
			)
		],

		Example[{Options,Template,"A template simulation (Object) whose methodology should be reproduced in running this simulation. Option values will be inherited from the template simulation, but can be individually overridden by directly specifying values for those options to this simulation function:"},
			PlotTrajectory[SimulateKinetics[{{"a" + "b" \[Equilibrium] "c", 10^5, 1/10^5}}, {"a" -> 2 Micromolar}, 60 Second, Template -> Object[Simulation, Kinetics, theTemplateObjectID]]],
			ValidGraphicsP[],
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[{{"a" + "b" \[Equilibrium] "c", 10^5, 1/10^5}}, {"a" -> 2 Micromolar}, 60 Second, Template -> Object[Simulation, Kinetics, theTemplateObjectID]] =
				SimulateKinetics[{{"a" + "b" \[Equilibrium] "c", 10^5, 1/10^5}}, {"a" -> 2 Micromolar}, 60 Second, Template -> Object[Simulation, Kinetics, theTemplateObjectID], Upload->False]
			},
			SetUp :> (
				theTemplateObject = Upload[<|Type -> Object[Simulation, Kinetics], UnresolvedOptions -> {Injections -> {{Quantity[6., "Seconds"], "b",    Quantity[200, "Microliters"], Quantity[3, "Micromolar"]}}, Upload -> True},
		 		ResolvedOptions -> {Temperature -> Quantity[310, "Kelvin"], Volume -> Quantity[150,  "Microliters"], Noise -> Null, Method -> Deterministic, NumberOfPoints -> 50, ObservedSpecies -> {"a", "b", "c"}, Injections -> {{Quantity[6., "Seconds"], "b", Quantity[200, "Microliters"], Null, Quantity[3, "Micromolar"]}}, Template -> Null, Output -> Result,NumberOfTrajectories -> Null, Vectorized -> True, Upload -> True}, DeveloperObject -> True|>];
				theTemplateObjectID = theTemplateObject[ID];
			),
			TearDown :> (
				If[DatabaseMemberQ[theTemplateObject], EraseObject[theTemplateObject, Force -> True, Verbose -> False]];
			)
		],

		Example[{Options,AccuracyGoal,"Increase accuracy:"},
			PlotTrajectory[
				SimulateKinetics[pairFoldMech, pairFoldIC, 30 Minute,
					Temperature -> (273 + 30*Sin[.01*#] &),
					Vectorized -> False, MaxStepFraction -> 1/1000, AccuracyGoal -> 8]],
			ValidGraphicsP[],
			TimeConstraint -> 200
		],

		Example[{Options,PrecisionGoal,"Increase precision:"},
			PlotTrajectory[
				SimulateKinetics[pairFoldMech, pairFoldIC, 30 Minute,
					Temperature -> (273 + 30*Sin[.01*#] &),
					Vectorized -> False, MaxStepFraction -> 1/1000, AccuracyGoal -> 8, PrecisionGoal -> 14]],
			ValidGraphicsP[],
			TimeConstraint -> 200
		],

		Example[{Options,MaxStepFraction,"Increase max step fraction:"},
			PlotTrajectory[
				SimulateKinetics[pairFoldMech, pairFoldIC, 30 Minute,
					Temperature -> (273 + 30*Sin[.01*#] &),
					Vectorized -> False, MaxStepFraction -> 1/1000, AccuracyGoal -> 8]],
			ValidGraphicsP[],
			TimeConstraint -> 200
		],

		Example[{Messages,"BadObservableSpecies","Specifying invalid species to observe causes warning and the observed species to be set to all valid species:"},
			PlotTrajectory[SimulateKinetics[{{"a"\[Equilibrium]"b",1,2},{"b"->"c",3}},{"a"->1},60*Second,ObservedSpecies->{"b","Z"}]],
			_?ValidGraphicsQ,
			Messages:>{Warning::BadObservableSpecies},
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[{{"a"\[Equilibrium]"b",1,2},{"b"->"c",3}},{"a"->1},60*Second,ObservedSpecies->{"b","c"}] =
				SimulateKinetics[{{"a"\[Equilibrium]"b",1,2},{"b"->"c",3}},{"a"->1},60*Second, ObservedSpecies->{"b","c"}, Upload->False]
			}
		],

		Example[{Messages,"NegativeConcentration","Simulations sometimes fail and return unrealistic negative concentrations:"},
		PlotTrajectory[SimulateKinetics[pairFoldMech, pairFoldIC, 30 Minute,Temperature -> (273 + 28*Sin[.02*#] &), Vectorized -> False,MaxStepFraction -> 1/100, AccuracyGoal -> 2, PrecisionGoal -> 2]],
			ValidGraphicsP[],
			Messages:>{Warning::NegativeConcentration},
			TimeConstraint -> 200
		],

		Example[{Messages,"FailedToComplete","Simulations sometimes fail and do not run to completion:"},
		PlotTrajectory[SimulateKinetics[pairFoldMech, pairFoldIC, 30 Minute,Temperature -> (273 + 28*Sin[.2*#] &), Vectorized -> False,MaxStepFraction -> 1/100, AccuracyGoal -> 2, PrecisionGoal -> 2]],
			ValidGraphicsP[],
			Messages:>{Warning::FailedToComplete,Warning::NegativeConcentration},
			TimeConstraint -> 200
		],

		Example[{Messages,"FailedToComplete","Increase accuracy and precision and decrease step size:"},
			PlotTrajectory[
				SimulateKinetics[pairFoldMech, pairFoldIC, 30 Minute,
					Temperature -> (273 + 40*Sin[.01*#] &),
					Vectorized -> False, MaxStepFraction -> 1/500, AccuracyGoal -> 8]],
			ValidGraphicsP[],
			TimeConstraint -> 200
		],

		Example[{Messages,"IncompleteModel","Cannot perform simulation if mechanism does not have valid rates or rate types:"},
			SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",kf,1/Second}},{"a"->4Micromolar,"b"->3Micromolar},60*Second],
			$Failed,
			Messages:>{Error::IncompleteModel,Error::InvalidInput},
			TimeConstraint -> 200,
			Stubs :> {
				kf := Undefined
			},
			TearDown :> (
				ClearAll[kf]
			)
		],

		Example[{Messages,"InitialConditionPadding","Warns when integer list (not-species labeled) of initial conditions needs to be padded with zeros:"},
			PlotTrajectory[SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",10^5,10^-5}},{4^-6,3^-6},60]],
			ValidGraphicsP[],
			Messages:>{Warning::InitialConditionPadding},
			TimeConstraint -> 200,
			Stubs :> {
				SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",10^5,10^-5}},{4 10^-6,3 10^-6},60] =
				SimulateKinetics[{{"a"+"b"\[Equilibrium]"c",10^5,10^-5}},{4 10^-6,3 10^-6},60, Upload->False]
			}
		],

		Example[{Messages,"InconsistentInitialConditionUnits","Units incompatible with an initial condition:"},
			SimulateKinetics[{{"a" + "b" \[Equilibrium] "c", 10^5, 10^-5}}, {"a" -> 4 Micromolar, "b" -> 3 Meter}, 60*Second],
			$Failed,
			Messages:>{Error::InconsistentInitialConditionUnits, Error::InvalidInput},
			TimeConstraint -> 200
		],

		Example[{Messages,"InvalidOptionLength","Volume length and number of wells should be the same:"},
		SimulateKinetics[{{"a" + "b" \[Equilibrium] "c", 10^5, 10^-5}}, {"a" -> 4 Micromolar, "b" -> 3 Micromolar}, 60*Second, Volume -> {150*Microliter, 150*Microliter}],
			$Failed,
			Messages:>{Error::InvalidOptionLength, Error::InvalidOption},
			TimeConstraint -> 200
		],

(*		Example[{Options,AccuracyGoal,"A large AccuracyGoal makes the solver take smaller time steps:"},*)
		Test["A large AccuracyGoal makes the solver take smaller time steps:",
			Module[{tr1,tr2},
				tr1=SimulateKinetics[
					ReactionMechanism[Reaction[{Structure[{Strand[DNA[5,"A"]]},{}]},{Structure[{Strand[DNA[5,"B"]]},{}]},1,2],Reaction[{Structure[{Strand[DNA[5,"B"]]},{}]},{Structure[{Strand[DNA[5,"C"]]},{}]},3]], State[{Structure[{Strand[DNA[5,"A"]]},{}],Quantity[1,"Micromolar"]},{Structure[{Strand[DNA[5,"B"]]},{}],Quantity[0,"Micromolar"]},{Structure[{Strand[DNA[5,"C"]]},{}],Quantity[0,"Micromolar"]}], 60Second, AccuracyGoal->10
				][Trajectory];
				tr2=SimulateKinetics[
					ReactionMechanism[Reaction[{Structure[{Strand[DNA[5,"A"]]},{}]},{Structure[{Strand[DNA[5,"B"]]},{}]},1,2],Reaction[{Structure[{Strand[DNA[5,"B"]]},{}]},{Structure[{Strand[DNA[5,"C"]]},{}]},3]], State[{Structure[{Strand[DNA[5,"A"]]},{}],Quantity[1,"Micromolar"]},{Structure[{Strand[DNA[5,"B"]]},{}],Quantity[0,"Micromolar"]},{Structure[{Strand[DNA[5,"C"]]},{}],Quantity[0,"Micromolar"]}], 60Second, AccuracyGoal->2
				][Trajectory];
				{Length[tr1[Time]],Length[tr2[Time]]}
			],
			{a_Integer, b_Integer} /; a > b,
			TimeConstraint -> 200
		],

(*		Example[{Options,PrecisionGoal,"A large PrecisionGoal makes the solver take smaller time steps:"},*)
		Test["A large PrecisionGoal makes the solver take smaller time steps:",
			Module[{tr1,tr2},
				tr1=SimulateKinetics[
					ReactionMechanism[Reaction[{Structure[{Strand[DNA[5,"A"]]},{}]},{Structure[{Strand[DNA[5,"B"]]},{}]},1,2],Reaction[{Structure[{Strand[DNA[5,"B"]]},{}]},{Structure[{Strand[DNA[5,"C"]]},{}]},3]],
					State[{Structure[{Strand[DNA[5,"A"]]},{}],Quantity[1,"Micromolar"]},{Structure[{Strand[DNA[5,"B"]]},{}],Quantity[0,"Micromolar"]},{Structure[{Strand[DNA[5,"C"]]},{}],Quantity[0,"Micromolar"]}],
					60Second,PrecisionGoal->14
				][Trajectory];
				tr2=SimulateKinetics[
					ReactionMechanism[Reaction[{Structure[{Strand[DNA[5,"A"]]},{}]},{Structure[{Strand[DNA[5,"B"]]},{}]},1,2],Reaction[{Structure[{Strand[DNA[5,"B"]]},{}]},{Structure[{Strand[DNA[5,"C"]]},{}]},3]],
					State[{Structure[{Strand[DNA[5,"A"]]},{}],Quantity[1,"Micromolar"]},{Structure[{Strand[DNA[5,"B"]]},{}],Quantity[0,"Micromolar"]},{Structure[{Strand[DNA[5,"C"]]},{}],Quantity[0,"Micromolar"]}],
					60Second,PrecisionGoal->2
				][Trajectory];
				{Length[tr1[Time]],Length[tr2[Time]]}
			],
			{a_Integer, b_Integer} /; a > b,
			TimeConstraint -> 200
		],


	(*TESTS*)

		Test["Given mechanism:",
			SimulateKinetics[hybridizationMechanism, initialState, 60*Second, Upload->False],
			validSimulationPacketP[Object[Simulation, Kinetics],
				{
					InitialState -> State[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Quantity[1, "Micromolar"]}, {Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}], Quantity[1, "Micromolar"]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1 ;; 25}, {2, 1 ;; 25}]}], Quantity[0, "Micromolar"]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {Bond[{1, 14 ;; 19}, {2, 14 ;; 19}]}], Quantity[0, "Micromolar"]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {Bond[{1, 5 ;; 7}, {1, 23 ;; 25}]}], Quantity[0, "Micromolar"]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {Bond[{1, 6 ;; 8}, {1, 13 ;; 15}]}], Quantity[0, "Micromolar"]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {Bond[{1, 8 ;; 11}, {1, 17 ;; 20}]}], Quantity[0, "Micromolar"]}, {Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 7 ;; 12}, {2, 7 ;; 12}]}], Quantity[0, "Micromolar"]}, {Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1 ;; 3}, {1, 19 ;; 21}]}], Quantity[0, "Micromolar"]}, {Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 6 ;; 9}, {1, 15 ;; 18}]}], Quantity[0, "Micromolar"]}, {Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 11 ;; 13}, {1, 18 ;; 20}]}], Quantity[0, "Micromolar"]}],
					ReactionMechanism -> ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1 ;; 25}, {2, 1 ;; 25}]}]}, Quantity[350000.0000000007, 1/("Molar"*"Seconds")], Quantity[9.605874884730626*^-16, "Seconds"^(-1)]], Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {Bond[{1, 14 ;; 19}, {2, 14 ;; 19}]}]}, Quantity[350000.0000000007, 1/("Molar"*"Seconds")], Quantity[63.446096977555214, "Seconds"^(-1)]], Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {Bond[{1, 5 ;; 7}, {1, 23 ;; 25}]}]}, Quantity[14000., "Seconds"^(-1)], Quantity[125031.67335398086, "Seconds"^(-1)]], Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {Bond[{1, 6 ;; 8}, {1, 13 ;; 15}]}]}, Quantity[14000., "Seconds"^(-1)], Quantity[49630.75351283127, "Seconds"^(-1)]], Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {Bond[{1, 8 ;; 11}, {1, 17 ;; 20}]}]}, Quantity[14000., "Seconds"^(-1)], Quantity[994.3911334535436, "Seconds"^(-1)]], Reaction[{Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 7 ;; 12}, {2, 7 ;; 12}]}]}, Quantity[350000.0000000007, 1/("Molar"*"Seconds")], Quantity[63.446096977555214, "Seconds"^(-1)]], Reaction[{Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1 ;; 3}, {1, 19 ;; 21}]}]}, Quantity[14000., "Seconds"^(-1)], Quantity[106305.46163940955, "Seconds"^(-1)]], Reaction[{Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 6 ;; 9}, {1, 15 ;; 18}]}]}, Quantity[14000., "Seconds"^(-1)], Quantity[845.4594396464454, "Seconds"^(-1)]], Reaction[{Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 11 ;; 13}, {1, 18 ;; 20}]}]}, Quantity[14000., "Seconds"^(-1)], Quantity[49630.753512831565, "Seconds"^(-1)]]],
					Trajectory->TrajectoryP,
					Temperature->37.*Celsius,
					TemperatureFunction -> _Function,
					Method -> Deterministic,
					SimulationTime -> Quantity[60., "Seconds"],
					TemperatureProfile->QuantityCoordinatesP[]
				},
				Round->3
			],
			TimeConstraint -> 200
		],

		Test["Vectorized vs nonvectorized return same result:",
			Quiet@Module[{times, traj1, traj2, conc1, conc2},
				traj1 = SimulateKinetics[{{"a" + "b" \[Equilibrium] "ab", 10^5, 0.1`}, {"ab" + "c" \[Equilibrium] "a" + "bc", 5*10^5, 0.05`}}, {"a" -> 10^-4.`}, 20.` Second,
					Injections -> {{6. Second, "b", 2 Microliter, (1 Microliter)/Second, .003 Molar}, {12. Second, "c", 3 Microliter, (1 Microliter)/Second, .002 Molar}},
					Volume -> 40 Microliter, Vectorized -> True, AccuracyGoal -> 5, PrecisionGoal -> 5, Upload->False][Trajectory];
				traj2 = SimulateKinetics[{{"a" + "b" \[Equilibrium] "ab", 10^5, 0.1`}, {"ab" + "c" \[Equilibrium] "a" + "bc", 5*10^5, 0.05`}}, {"a" -> 10^-4.`}, 20.` Second,
					Injections -> {{6. Second, "b",  2 Microliter, (1 Microliter)/Second, .003 Molar}, {12. Second, "c", 3 Microliter, (1 Microliter)/Second, .002 Molar}},
					Volume -> 40 Microliter, Vectorized -> False, AccuracyGoal -> 5, PrecisionGoal -> 5, Upload->False][Trajectory];
				times = traj1[Times];
				conc1 = TrajectoryRegression[traj1, times];
				conc2 = TrajectoryRegression[traj2, times];
				Norm[conc1 - conc2]/Norm[conc1] < 10^-2
			],
			True,
			TimeConstraint -> 200
		],

		Test["UnresolvedOptions fails simulation:",
			SimulateKinetics[{{"a"\[Equilibrium]"b",1,2},{"b"->"c",3}},{"a"->1}, 60*Second, Horse->True, NumberOfPoints->"string"],
			$Failed,
			Messages:>{OptionValue::nodef,Error::UnknownOption,Error::Pattern},
			TimeConstraint -> 200
		],

		Test["Reaction a->many, vectorized and non-vectorized give similar results:",
			Module[{mech,traj1,traj2,conc1,conc2},
				mech={{a -> b + c + d,1}, {b -> bz, .5}, {c -> cz, .1}};
				traj1 = SimulateKinetics[mech, {a -> 1}, 45 Second, Vectorized->False, Upload->False][Trajectory];
				traj2 = SimulateKinetics[mech, {a -> 1}, 45 Second, Vectorized->True, Upload->False][Trajectory];
				conc1=Map[traj1[#] &, Range[0, 45, 5]*Second];
				conc2=Map[traj2[#] &, Range[0, 45, 5]*Second];
				Norm[conc1-conc2]/Norm[conc1] < 10^-5
			],
			True,
			TimeConstraint -> 200
		],

		Test["Reaction a+b->many, vectorized and non-vectorized give similar results:",
			Module[{mech,traj1,traj2,conc1,conc2},
				mech={{a + f -> b + c + d, 1}, {b -> bz, .5}, {c -> cz, .1}};
				traj1 = SimulateKinetics[mech, {a -> 1, f -> 0.9}, 45 Second, Vectorized->False, Upload->False][Trajectory];
				traj2 = SimulateKinetics[mech, {a -> 1, f -> 0.9}, 45 Second, Vectorized->True, Upload->False][Trajectory];
				conc1=Map[traj1[#] &, Range[0, 45, 5]*Second];
				conc2=Map[traj2[#] &, Range[0, 45, 5]*Second];
				Norm[conc1-conc2]/Norm[conc1] < 10^-5
			],
			True,
			TimeConstraint -> 200
		],

		Test["Slow injection:",
			SimulateKinetics[{{"a"+"b"\[Equilibrium]"ab",10^5,0.1`},{"ab"+"c"\[Equilibrium]"a"+"bc",5*10^5,0.05`}},{"a"->10^-4.`},20.` Second,
				Injections->{
					{6. Second,"b",2Microliter,(1Microliter)/Second,.003 Molar},
					{12. Second,"c",3Microliter,(1Microliter)/Second,.002 Molar}
				},
				Volume->40Microliter,
				Upload->False
			],
			validSimulationPacketP[Object[Simulation, Kinetics],
				{
					Trajectory -> TrajectoryP,
					InitialVolume -> Quantity[40000, "Nanoliters"],
					Append[Injections]->{{Quantity[0.1, "Minutes"], "b", Quantity[2, "Microliters"], 1, Quantity[3000., "Micromolar"]}, {Quantity[0.2, "Minutes"], "c", Quantity[3, "Microliters"], 1, Quantity[2000., "Micromolar"]}},
					VolumeProfile->QuantityCoordinatesP[]
				},
				NullFields -> {},
				Round->12
			],
			TimeConstraint -> 200,
			Stubs :> {
				Message[Reduce::ratnz,___]:=Null
			}
		]

	},
	SetUp:>(
		$CreatedObjects = {};
		initialState=State[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]},{}],Micro Molar},{Structure[{Strand[DNA[ReverseComplementSequence["GGATTAGTCTGTACTGCAGAAGCTA"]]]},{}],Micro Molar}];
		hybridizationMechanism=ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation], Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {Bond[{1, 1, 14 ;; 19}, {2, 1, 14 ;; 19}]}]}, Hybridization, Dissociation], Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {Bond[{1, 1, 5 ;; 7}, {1, 1, 23 ;; 25}]}]}, Folding, Melting], Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {Bond[{1, 1, 6 ;; 8}, {1, 1, 13 ;; 15}]}]}, Folding, Melting], Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {Bond[{1, 1, 8 ;; 11}, {1, 1, 17 ;; 20}]}]}, Folding, Melting], Reaction[{Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 7 ;; 12}, {2, 1, 7 ;; 12}]}]}, Hybridization, Dissociation], Reaction[{Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 3}, {1, 1, 19 ;; 21}]}]}, Folding, Melting], Reaction[{Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 6 ;; 9}, {1, 1, 15 ;; 18}]}]}, Folding, Melting], Reaction[{Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 11 ;; 13}, {1, 1, 18 ;; 20}]}]}, Folding, Melting]];
		catchReleaseMechanism = {{"a"+"b"\[Equilibrium]"ab",2,.1},{"ab"+"c"\[Equilibrium]"a"+"bc",3,.05}};
		pairFoldMech=ReactionMechanism[Reaction[{Structure[{Strand[DNA["TATATTGTGATTCGCGAATATA"]]}, {}]},
			{Structure[{Strand[DNA["TATATTGTGATTCGCGAATATA"]]}, {Bond[{1, 1 ;; 6}, {1, 17 ;; 22}]}]}, Folding,
			Melting], Reaction[{Structure[{Strand[DNA["TATATTCGCGAATCACAATATA"]]}, {}]},
			{Structure[{Strand[DNA["TATATTCGCGAATCACAATATA"]]}, {Bond[{1, 1 ;; 6}, {1, 17 ;; 22}]}]}, Folding,
			Melting], Reaction[{Structure[{Strand[DNA["TATATTCGCGAATCACAATATA"]]}, {}],
			Structure[{Strand[DNA["TATATTGTGATTCGCGAATATA"]]}, {}]},
			{Structure[{Strand[DNA["TATATTCGCGAATCACAATATA"]], Strand[DNA["TATATTGTGATTCGCGAATATA"]]},
				{Bond[{1, 1 ;; 22}, {2, 1 ;; 22}]}]}, Hybridization, Dissociation]];
		pairFoldIC = {Structure[{Strand[DNA["TATATTGTGATTCGCGAATATA"]]}, {}] -> Quantity[1, "Micromolar"],
			Structure[{Strand[DNA["TATATTCGCGAATCACAATATA"]]}, {}] -> Quantity[1.5, "Micromolar"]};
	),
	TearDown :> (
		EraseObject[Pick[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
	)
];




(* ::Section:: *)
(*End Test Package*)
