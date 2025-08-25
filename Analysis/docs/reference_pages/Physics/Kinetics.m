(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*AnalyzeKinetics*)


DefineUsageWithCompanions[AnalyzeKinetics,
{
	BasicDefinitions -> {
		{
			Definition -> {"AnalyzeKinetics[trajectories, reactions]", "object"},
			Description -> "solves for kinetic rates such that the model described by 'reactions' fits the training data 'trajectories'.",
			Inputs :> {
				{
					InputName -> "trajectories",
					Description -> "List of trajectories to fit to.",
					Widget -> Widget[Type->Expression, Pattern:>{TrajectoryP..}, PatternTooltip->"A list of trajectories which is in the format of Trajectory[species, time, concentration, units], please refer to TrajectoryP for further details.", Size->Paragraph]
				},
				{
					InputName -> "reactions",
					Description -> "Proposed mechanism to fit to.  Must contain at least one unknown symbolic rate.",
					Widget -> Widget[Type->Expression, Pattern:>reactionsP, PatternTooltip->"Could be a Equilibrium or a ReactionMechanism.",Size->Paragraph]
				}
			},
			Outputs :> {
				{
					OutputName -> "object",
					Description -> "The object containing analysis results from solving the kinetic rates.",
					Pattern :> ObjectP[Object[Analysis, Kinetics]]
				}
			}
		},

		{
			Definition -> {"AnalyzeKinetics[kineticData, reactions]", "object"},
			Description -> "fits to the trajectories in the given kinetics data objects or protocol.",
			Inputs :> {
				{
					InputName -> "kineticData",
					Description -> "Kinetics data or protocol containing trajectories.",
					Widget -> Alternatives[
						"Objects"->Adder[
							Widget[Type->Object, Pattern:>ObjectP[{
								Object[Data, AbsorbanceKinetics],
								Object[Data, FluorescenceKinetics],
								Object[Data, LuminescenceKinetics]
								(*)
								Object[Data, FluorescencePolarizationKinetics],
								Object[Data, NephelometryKinetics]
								*)
							}]]
						],
						"Protocol"->Widget[Type->Object, Pattern:>ObjectP[{
							Object[Protocol, AbsorbanceKinetics],
							Object[Protocol, FluorescenceKinetics],
							Object[Protocol, LuminescenceKinetics]
							(*
							Object[Protocol, FluorescencePolarizationKinetics],
							Object[Protocol, NephelometryKinetics]
							*)
						}]]
					]
				},
				{
					InputName -> "reactions",
					Description -> "Proposed mechanism to fit to.  Must contain at least one unknown symbolic rate.",
					Widget -> Widget[Type->Expression, Pattern:>reactionsP, PatternTooltip->"Could be a Equilibrium or a ReactionMechanism.",Size->Paragraph]
				}
			},
			Outputs :> {
				{
					OutputName -> "object",
					Description -> "The object containing analysis results from solving the kinetic rates.",
					Pattern :> ObjectP[Object[Analysis, Kinetics]]
				}
			}
		}

	},
	MoreInformation -> {
		"Uses least-squares optimization to solve for the unknown kinetic rates in the given reactions such that the predicted trajectories from the resulting mechanism best fit the training trajectories.",
		"Global optimization uses NMinimize, while Local optimization uses FindMinimum.",
		"Simulated trajectories are generated during optimization using SimulateKinetics, which uses NDSolve to numerically solve the differential equations describing the reaction network."
	},
	SeeAlso -> {
		"PlotKineticRates",
		"SimulateKinetics",
		"PlotTrajectory",
		"NMinimize",
		"FindMinimum"
	},
	Author -> {
		"scicomp"
	},
	Guides -> {
		"AnalysisCategories",
		"ExperimentAnalysis"
	},
	Preview->True
}];

