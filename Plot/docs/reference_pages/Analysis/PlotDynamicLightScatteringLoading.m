(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*PlotDynamicLightScatteringLoading*)


DefineUsage[PlotDynamicLightScatteringLoading,
	{
		BasicDefinitions -> {
	    	{
	      		Definition -> {"PlotDynamicLightScatteringLoading[dynamicLightScatteringLoadingObject]", "plot"},
	      		Description -> "Plots the correlation curves used to determine proper loading in dynamic light scattering experiments.",
	      		Inputs :> {
	        	{
	          		InputName -> "dynamicLightScatteringLoadingObject",
	          		Description -> "The analysis object which is the output of dynamic light scattering loading analysis performed with AnalyzeDynamicLightScatteringLoading.",
	          		Widget -> Widget[Type->Object, Pattern :> ObjectP[Object[Analysis, DynamicLightScatteringLoading]]]
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
	        	"AnalyzeMeltingPoint",
	        	"PlotMeltingPoint"
		},
		Author -> {
			"scicomp",
			"derek.machalek",
			"brad"
		},
		Sync->Automatic,
		Preview->True
	}
];
