(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*PlotDynamicLightScatteringAnalysis*)

DefineUsage[PlotDynamicLightScatteringAnalysis,
	{
		BasicDefinitions -> {
	    	{
	      		Definition -> {"PlotDynamicLightScatteringAnalysis[DynamicLightScatteringAnalysis]", "plot"},
	      		Description -> "Plots the diffusion interaction fit, second virial coefficient fit, and correlation curves used in dynamic light scattering analysis.",
	      		Inputs :> {
	        	    {
	          		    InputName -> "DynamicLightScatteringAnalysis",
	          		    Description -> "The analysis object which is the output of dynamic light scattering analysis performed with AnalyzeDynamicLightScattering.",
	          		    Widget -> Widget[Type->Object, Pattern :> ObjectP[Object[Analysis, DynamicLightScattering]]]
	        	    }
	      		},
	      		Outputs :> {
	        	{
				OutputName -> "plot",
				Description -> "Plot of the correlation curves from the data objects in AnalyzeDynamicLightScatteringLoading.",
				Pattern :> ValidGraphicsP[]
			}
	      		}
	    	}
        	},

		SeeAlso -> {
            	"AnalyzeDynamicLightScatteringLoading",
	        	"AnalyzeDynamicLightScattering"
		},
		Author -> {"taylor.hochuli", "derek.machalek", "tommy.harrelson"},
		Sync->Automatic,
		Preview->True
	}
];