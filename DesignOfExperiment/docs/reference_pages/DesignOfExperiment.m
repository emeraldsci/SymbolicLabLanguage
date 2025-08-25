(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*DesignOfExperiment*)


DefineUsage[DesignOfExperiment,
	{
		BasicDefinitions -> {
    		{
    			Definition -> {"DesignOfExperiment[experiment]", "designOfExperimentObject"},
				Description -> "generates a 'designOfExperimentObject' to methodically perform 'experiment' over a range of parameters to find the desired parameter settings.",
				Inputs :> {
					{
						InputName -> "experiment",
						Description -> "An experiment function call, including inputs and options. Inputs and options to optimize are wrapped with the Variable head.",
						(*We probably need a custom widget type or FE integration for this*)
						Widget -> Widget[Type -> Expression, Pattern :> _, Size -> Paragraph]
					}
				},
				Outputs :> {
					{
						OutputName -> "designOfExperimentObject",
        				Description -> "A design of experiment object which contains a template script with the experiments to execute with alternating analysis of the design of experiment.",
        				Pattern :> ObjectP[Object[DesignOfExperiment]]
					}
				}
			}
		},
		SeeAlso -> {"ExperimentScript", "RunScriptDesignOfExperiment", "AnalyzePeaks"},
		Author -> {"xu.yi", "kevin.hou", "li.gao", "tommy.harrelson", "derek.machalek", "brad"}
	}
];

DefineUsage[RunScriptDesignOfExperiment,
	{
		BasicDefinitions -> {
    		{
    			Definition -> {"RunScriptDesignOfExperiment[Script]", "Script"},
				Description -> "executes a 'Script' for a simulation over the variable parameters determined in the design of experiment. The variable parameters are scored based on the objective function in the AnalyzeDesignOfExperiment function.",
				Inputs :> {
					{
						InputName -> "Script",
						Description -> "A template design of experiment script object which contains the experiments to execute with alternating analysis of the design of experiment.",
						Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Notebook, Script]]]
					}
				},
				Outputs :> {
					{
						OutputName -> "Script",
        				Description -> "A completed design of experiment script object which contains the executed experiments.",
        				Pattern :> ObjectP[Object[Notebook, Script]]
					},
					{
						OutputName -> "designOfExperimentAnalysis",
        				Description -> "An evaluation of the variable parameters on the objective score of experiments executed in the design of experiments script.",
        				Pattern :> ObjectP[Object[Analysis, DesignOfExperiment]]
					}
				}
			}
		},
		SeeAlso -> {"DesignOfExperiment", "RunScript", "AnalyzePeaks"},
		Author -> {"scicomp", "derek.machalek", "brad"}
	}
];