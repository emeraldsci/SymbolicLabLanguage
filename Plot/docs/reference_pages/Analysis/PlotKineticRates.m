(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*PlotKineticRates*)


DefineUsage[PlotKineticRates,
  {
  	BasicDefinitions -> {

      {
        Definition -> {"PlotKineticRates[kineticsObject]", "plot"},
        Description -> "plots the rate fitting analysis found in the kinetics analysis 'kineticsObject'.",
        Inputs :> {
          {
            InputName -> "kineticsObject",
            Description -> "The analysis object which is the output of kinetics analysis performed with AnalyzeKinetics.",
            Widget -> Widget[Type->Object, Pattern :> ObjectP[Object[Analysis,Kinetics]]]
          }
        },
        Outputs :> {
          {
  					OutputName -> "plot",
  					Description -> "Plot showing the quality of the rate fitting analysis.",
  					Pattern :> ValidGraphicsP[]
  				}
        }
      }

  	},

  	SeeAlso -> {
      "AnalyzeKinetics",
      "SimulateKinetics",
      "PlotReactionMechanism",
      "PlotTrajectory"
  	},
  	Author -> {"dirk.schild", "amir.saadat", "brad", "alice", "qian", "thomas"},
  	Sync->Automatic,
  	Preview->True
  }
];