(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*PlotDynamicLightScatteringAnalysis*)


DefineTests[PlotDynamicLightScatteringAnalysis,{

	(* Basic *)
	Example[
		{Basic,"For AssayType B22kD, plot a DynamicLightScattering analysis object to show the diffusion interaction parameter fit, second virial coefficient fit, and correlation curves included in the analysis:"},
		myAnalysisObject = AnalyzeDynamicLightScattering[Object[Data, DynamicLightScattering, "id:E8zoYvNpPJ9b"]];
		PlotDynamicLightScatteringAnalysis[myAnalysisObject],
		_TabView,
		Messages :> {Warning::CurvesOutsideRangeRemoved}
	],

	Example[
		{Basic,"Plot the analysis of the first data object in a protocol:"},
		myAnalysisObject = AnalyzeDynamicLightScattering[Object[Protocol, DynamicLightScattering, "id:AEqRl9K1BrMv"]];
		PlotDynamicLightScatteringAnalysis[myAnalysisObject[[1]]],
		_TabView,
		Messages :> {Warning::CurvesOutsideRangeRemoved}
	],

	Example[
		{Options, Output,"Output set to option returns the plot:"},
		myAnalysisObject = AnalyzeDynamicLightScattering[Object[Data, DynamicLightScattering, "id:E8zoYvNpPJ9b"]];
		PlotDynamicLightScatteringAnalysis[myAnalysisObject, Output->Result],
		_TabView,
		Messages :> {Warning::CurvesOutsideRangeRemoved}
	],

	Example[
		{Additional,"For melting curve data used in thermal shift, plot a DynamicLightScattering analysis:"},
		myAnalysisObject = AnalyzeDynamicLightScattering[Object[Data,MeltingCurve,"id:dORYzZRLxE0w"]];
		PlotDynamicLightScatteringAnalysis[myAnalysisObject],
		ValidGraphicsP[]
	],

	Example[
		{Additional,"For AssayType G22, plot a DynamicLightScattering analysis:"},
		myAnalysisObject = AnalyzeDynamicLightScattering[Object[Data,DynamicLightScattering,"id:P5ZnEjd39MWR"]];
		PlotDynamicLightScatteringAnalysis[myAnalysisObject],
		_TabView
	],

	Example[
		{Additional,"For AssayType IsothermalStability, plot a DynamicLightScattering analysis:"},
		myAnalysisObject = AnalyzeDynamicLightScattering[Object[Data,DynamicLightScattering,"id:Vrbp1jKRjjzm"]];
		PlotDynamicLightScatteringAnalysis[myAnalysisObject],
		_TabView
	],

	Example[
		{Additional,"For AssayType SizingPolydispersity, plot a DynamicLightScattering analysis:"},
		myAnalysisObject = AnalyzeDynamicLightScattering[Object[Data,DynamicLightScattering,"id:eGakldJRERVe"]];
		PlotDynamicLightScatteringAnalysis[myAnalysisObject],
		ValidGraphicsP[]
	]

}];
