(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*PlotThermodynamics*)


DefineTests[PlotDynamicLightScatteringLoading,{

	(* Basic *)
	Example[
		{Basic,"Plot a DynamicLightScattering analysis object:"},
		myAnalysisObject = AnalyzeDynamicLightScatteringLoading[Object[Protocol, DynamicLightScattering, "id:aXRlGn64L0kv"]];
		PlotDynamicLightScatteringLoading[myAnalysisObject],
		ValidGraphicsP[]
	],
	Example[
		{Basic,"Plot a DynamicLightScattering analysis object with multiple curves per sample:"},
		myAnalysisObject = AnalyzeDynamicLightScatteringLoading[Object[Protocol, DynamicLightScattering, "id:9RdZXv14RVlJ"]];
		PlotDynamicLightScatteringLoading[myAnalysisObject],
		ValidGraphicsP[]
	],
	Example[
		{Basic,"Plot a DynamicLightScattering analysis packet:"},
		myAnalysisObject = AnalyzeDynamicLightScatteringLoading[Object[Protocol, ThermalShift, "id:9RdZXv1eYqNX"]];
		myPacket = Download[myAnalysisObject];
		PlotDynamicLightScatteringLoading[myPacket],
		ValidGraphicsP[]
	],
	Example[
		{Messages,"RemovedData","If non-numeric data exists in the object a warning is thrown:"},
		Quiet[myAnalysisObject = AnalyzeDynamicLightScatteringLoading[Object[Protocol, ThermalShift, "id:eGakldJG6364"]], Warning::RemovedData];
		PlotDynamicLightScatteringLoading[myAnalysisObject],
		ValidGraphicsP[],
		Messages:>{Warning::RemovedData}
	],

	(* Tests *)
	Test[
		"Given a link:",
		myAnalysisObject = AnalyzeDynamicLightScatteringLoading[Object[Protocol, DynamicLightScattering, "id:aXRlGn64L0kv"]];
		PlotDynamicLightScatteringLoading[Link[myAnalysisObject,Reference]],
		ValidGraphicsP[]
	],

	Test[
		"Setting Output to Preview displays the image:",
		myAnalysisObject = AnalyzeDynamicLightScatteringLoading[Object[Protocol, DynamicLightScattering, "id:aXRlGn64L0kv"]];
		PlotDynamicLightScatteringLoading[myAnalysisObject, Output->Preview],
		ValidGraphicsP[]
	]

}];
