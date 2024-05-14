(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotGasChromatographyMethod*)


DefineUsage[PlotGasChromatographyMethod,
	{
		BasicDefinitions -> {
			{"PlotGasChromatographyMethod[method]", "fig", "plots the flows, pressures and temperatures of the 'method' vs. time."}
		},
		Input :> {
			{"method", ListableP[ObjectP[Object[Method,GasChromatography]]], "Gas chromotography object(s)."}
		},
		Output :> {
			{"fig", _ValidGraphicsQ, "Plot displaying the method."}
		},
		SeeAlso -> {
			"ExperimentGasChromatography"
		},
		Author -> {"jireh.sacramento", "xu.yi", "cgullekson"}
	}];