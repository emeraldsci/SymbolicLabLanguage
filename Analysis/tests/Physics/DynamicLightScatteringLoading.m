(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Title:: *)
(*DynamicLightScatteringLoading.m Tests*)

(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*AnalyzeDynamicLightScatteringLoading*)

DefineTests[
	AnalyzeDynamicLightScatteringLoading,
	{

		(* ---- Basic ---- *)

		Example[{Basic, "Plot the correlation curves used in the loading analysis:"},
			AnalyzeDynamicLightScatteringLoading[Object[Protocol, ThermalShift, "id:9RdZXv1eYqNX"], Output -> Preview],
			ValidGraphicsP[]
		],


		Example[{Basic, "Find the data objects that are considered properly loaded:"},
			(AnalyzeDynamicLightScatteringLoading[Object[Protocol, ThermalShift, "id:9RdZXv1eYqNX"], Upload -> True, Output -> Result])[Data][Object],
			{Object[Data, MeltingCurve, "id:wqW9BP707poO"], Object[Data, MeltingCurve, "id:J8AY5jDPDKLB"],Object[Data, MeltingCurve, "id:8qZ1VW0d0Gnn"],
			Object[Data, MeltingCurve, "id:bq9LA0JGJYwL"], Object[Data, MeltingCurve, "id:KBL5Dvw3wjEv"], Object[Data, MeltingCurve, "id:jLq9jXvkv81R"],
			Object[Data, MeltingCurve, "id:7X104vnZnO3w"], Object[Data, MeltingCurve, "id:N80DNj1w1nPX"],
			Object[Data, MeltingCurve, "id:xRO9n3B1B4z6"], Object[Data, MeltingCurve, "id:6V0npvm1mR51"], Object[Data, MeltingCurve, "id:9RdZXv1e1A0j"]}
		],


		Example[{Basic, "Plot the correlation curves used in the loading analysis for cases with multiple samples per data object:"},
			AnalyzeDynamicLightScatteringLoading[Object[Protocol, DynamicLightScattering, "id:XnlV5jK6Mn7z"], Output -> Preview],
			ValidGraphicsP[]
		],

		(* ---- Additional ---- *)

		Example[{Additional, "Find the data that is considered properly loaded without uploading:"},
			(Analysis`Private`stripAppendReplaceKeyHeads@AnalyzeDynamicLightScatteringLoading[Object[Protocol, ThermalShift, "id:9RdZXv1eYqNX"], Upload -> False, Output -> Result])[Data],
			{Link[Object[Data, MeltingCurve, "id:wqW9BP707poO"]], Link[Object[Data, MeltingCurve, "id:J8AY5jDPDKLB"]], Link[Object[Data, MeltingCurve, "id:8qZ1VW0d0Gnn"]], Link[Object[Data, MeltingCurve, "id:bq9LA0JGJYwL"]],
 			Link[Object[Data, MeltingCurve, "id:KBL5Dvw3wjEv"]], Link[Object[Data, MeltingCurve, "id:jLq9jXvkv81R"]], Link[Object[Data, MeltingCurve, "id:7X104vnZnO3w"]], Link[Object[Data, MeltingCurve, "id:N80DNj1w1nPX"]],
 			Link[Object[Data, MeltingCurve, "id:xRO9n3B1B4z6"]], Link[Object[Data, MeltingCurve, "id:6V0npvm1mR51"]], Link[Object[Data, MeltingCurve, "id:9RdZXv1e1A0j"]]}
		],

		ObjectTest[
			{Additional, "Find the data from the correlation curves used in the loading analysis for cases with multiple samples per data object:"},
			AnalyzeDynamicLightScatteringLoading[Object[Protocol, DynamicLightScattering, "id:XnlV5jK6Mn7z"]][Data],
			{LinkP[Object[Data, DynamicLightScattering, "id:P5ZnEjd39MWR"]]},
			TimeConstraint -> 1000
		],

		ObjectTest[
			{Additional, "Find the excluded data from the correlation curves used in the loading analysis:"},
			AnalyzeDynamicLightScatteringLoading[Object[Protocol, ThermalShift, "id:9RdZXv1eYqNX"]][ExcludedData],
			{LinkP[Object[Data, MeltingCurve, "id:BYDOjvGAG3qk"]], LinkP[Object[Data, MeltingCurve, "id:M8n3rx050NkO"]], LinkP[Object[Data, MeltingCurve, "id:mnk9jORDRKeK"]], LinkP[Object[Data, MeltingCurve, "id:rea9jlRrR0q3"]], LinkP[Object[Data, MeltingCurve, "id:vXl9j57n7eAm"]]},
			TimeConstraint -> 1000
		],

		(* ---- Options ---- *)

		(*CorrelationThreshold*)
		Example[{Options, CorrelationThreshold, "Plot the correlation curves used in the loading analysis with a lower CorreltionThreshold:"},
			AnalyzeDynamicLightScatteringLoadingPreview[Object[Protocol, ThermalShift, "id:9RdZXv1eYqNX"], CorrelationThreshold->0.001],
			ValidGraphicsP[]
		],

		(*CorrelationMaximum*)
		Example[{Options, CorrelationMaximum, "Plot the correlation curves used in the loading analysis with a CorrelationMaximum:"},
			AnalyzeDynamicLightScatteringLoading[Object[Protocol, ThermalShift, "id:9RdZXv1eYqNX"], CorrelationThreshold -> 0.5, CorrelationMaximum -> 0.7, Output -> Preview],
			ValidGraphicsP[]
		],

		(* CorrelationMaximum functionality *)
		Example[{Options, CorrelationMaximum, "Isolate one correlation curve between the CorrelationThreshold and CorrelationMaximum:"},
			myPacket = Analysis`Private`stripAppendReplaceKeyHeads[
				AnalyzeDynamicLightScatteringLoading[Object[Protocol,ThermalShift,"id:9RdZXv1eYqNX"],CorrelationThreshold->0.5,CorrelationMaximum->0.7, Upload -> False]
			];
			Length[Lookup[myPacket, Data]],
			1
		],

		(* Correlation Temperature *)
		Example[{Options, CorrelationTemperature, "Plot the final correlation curves used in the loading analysis:"},
			AnalyzeDynamicLightScatteringLoading[Object[Protocol, ThermalShift, "id:9RdZXv1eYqNX"], CorrelationTemperature->Final, Output -> Preview],
			ValidGraphicsP[]
		],

		(*TimeThreshold*)
		Example[{Options, TimeThreshold, "Plot the correlation curves used in the loading analysis with a longer TimeThreshold:"},
			AnalyzeDynamicLightScatteringLoading[Object[Protocol, ThermalShift, "id:9RdZXv1eYqNX"], TimeThreshold -> 0.01 Second, Output -> Preview],
			ValidGraphicsP[]
		],

		(*Include*)
		Example[{Options, Include, "Plot the correlation curves used in the loading analysis with an included data object:"},
			AnalyzeDynamicLightScatteringLoading[Object[Protocol, ThermalShift, "id:9RdZXv1eYqNX"], Include -> {Object[Data, MeltingCurve, "id:M8n3rx050NkO"]}, Output -> Preview],
			ValidGraphicsP[]
		],

		(*Exclude*)
		Example[{Options, Exclude, "Plot the correlation curves used in the loading analysis with an excluded data object:"},
			AnalyzeDynamicLightScatteringLoading[Object[Protocol, ThermalShift, "id:9RdZXv1eYqNX"], Exclude -> {Object[Data, MeltingCurve, "id:wqW9BP707poO"]}, Output -> Preview],
			ValidGraphicsP[]
		],


		(* ---- Messages ---- *)

		Example[{Messages, "AbsentIncludeExclude", "Include and exclude must already exist in the protocol:"},
			AnalyzeDynamicLightScatteringLoading[Object[Protocol, ThermalShift, "id:9RdZXv1eYqNX"], Exclude -> {Object[Data, MeltingCurve, "id:Fake"]}, Output -> Preview],
			ValidGraphicsP[],
			Messages :> {Warning::AbsentIncludeExclude}
		],

		Example[{Messages, "RemovedData ", "Non-numeric data removed from correlation curves used for thresholding analysis:"},
			AnalyzeDynamicLightScatteringLoading[Object[Protocol, ThermalShift, "id:eGakldJG6364"], Output -> Preview],
			ValidGraphicsP[],
			Messages :> {Warning::RemovedData}
		],

		Example[{Messages, "SameIncludeExclude", "Include and exclude cannot contain any of the same members:"},
			AnalyzeDynamicLightScatteringLoading[Object[Protocol, ThermalShift, "id:9RdZXv1eYqNX"], Include -> {Object[Data, MeltingCurve, "id:M8n3rx050NkO"]},
			Exclude -> {Object[Data, MeltingCurve, "id:M8n3rx050NkO"]}, Output -> Preview],
			$Failed,
			Messages :> {Error::SameIncludeExclude}
		],

		Example[{Messages, "SameIncludeExclude", "Include and exclude cannot contain any of the same members:"},
			AnalyzeDynamicLightScatteringLoading[Object[Protocol, ThermalShift, "id:9RdZXv1eYqNX"], Include -> {Object[Data, MeltingCurve, "id:M8n3rx050NkO"]},
			Exclude -> {Object[Data, MeltingCurve, "id:M8n3rx050NkO"]}, Output -> Preview],
			$Failed,
			Messages :> {Error::SameIncludeExclude}
		],

		Example[{Messages, "MissingCorrelationThermalShift", "The data objects are from the Object[Protocol, ThermalShift] do not have the dynamic light scattering corrlation curves for loading analysis:"},
			AnalyzeDynamicLightScatteringLoading[Object[Protocol, ThermalShift, "id:1ZA60vLo0O0q"]],
			$Failed,
			Messages :> {Error::MissingCorrelationThermalShift}
		],

		Example[{Messages, "MissingCorrelationDynamicLightScattering", "The data objects are from the Object[Protocol, DynamicLightScattering] do not have the dynamic light scattering corrlation curves for loading analysis:"},
			AnalyzeDynamicLightScatteringLoading[Object[Protocol, DynamicLightScattering, "id:1ZA60vLW0kdP"]],
			$Failed,
			Messages :> {Error::MissingCorrelationDynamicLightScattering}
		],

		Example[{Messages, "MinExceedsMax", "The CorrealtionThreshold cannot exceed the Correlation Minimum:"},
			AnalyzeDynamicLightScatteringLoading[Object[Protocol,DynamicLightScattering,"id:dORYzZJGmJ5G"], CorrelationMaximum -> 0.5, CorrelationThreshold->0.7],
			$Failed,
			Messages :> {Error::MinExceedsMax}
		]


		(* ---- Test ---- *)

	},

	SymbolSetUp:>{

		$CreatedObjects={};
	},

	SymbolTearDown:>{
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	}

];

(* ::Subsubsection:: *)
(*ValidAnalyzeDynamicLightScatteringLoadingQ*)


DefineTests[ValidAnalyzeDynamicLightScatteringLoadingQ, {
	Example[{Basic,"Return test results for all the gathered tests/warning:"},
		ValidAnalyzeDynamicLightScatteringLoadingQ[Object[Protocol, ThermalShift, "id:9RdZXv1eYqNX"]],
		True
	],
	Example[{Options,OutputFormat,"Specify OutputFormat to be TestSummary:"},
		ValidAnalyzeDynamicLightScatteringLoadingQ[Object[Protocol, ThermalShift, "id:9RdZXv1eYqNX"], OutputFormat->TestSummary],
		_EmeraldTestSummary
	],
	Example[{Options,Verbose,"Specify Verbose to be True:"},
		ValidAnalyzeDynamicLightScatteringLoadingQ[Object[Protocol, ThermalShift, "id:9RdZXv1eYqNX"],Verbose->True],
		True
	]

}
];

(* ::Subsubsection:: *)
(*AnalyzeDynamicLightScatteringLoadingPreview*)


DefineTests[AnalyzeDynamicLightScatteringLoadingPreview, {
	Example[
		{Basic,"Plot a DynamicLightScattering analysis object:"},
		AnalyzeDynamicLightScatteringLoadingPreview[Object[Protocol, DynamicLightScattering, "id:aXRlGn64L0kv"]],
		ValidGraphicsP[]
	],
	Example[
		{Basic,"Plot a DynamicLightScattering analysis object with multiple curves per sample:"},
		AnalyzeDynamicLightScatteringLoadingPreview[Object[Protocol, DynamicLightScattering, "id:9RdZXv14RVlJ"]],
		ValidGraphicsP[]
	],
	Example[
		{Basic,"Plot a DynamicLightScattering analysis from a ThermalShift Protocol:"},
		AnalyzeDynamicLightScatteringLoadingPreview[Object[Protocol, ThermalShift, "id:9RdZXv1eYqNX"]],
		ValidGraphicsP[]
	]
}

];

(* ::Subsubsection:: *)
(*AnalyzeDynamicLightScatteringLoadingOptions*)


DefineTests[AnalyzeDynamicLightScatteringLoadingOptions, {
	Example[{Basic,"Return all options with Automatic resolved to a fixed value:"},
		AnalyzeDynamicLightScatteringLoadingOptions[Object[Protocol, ThermalShift, "id:9RdZXv1eYqNX"]],
		_Grid
	],
	Example[{Basic,"Return options resolved to a fixed value:"},
		AnalyzeDynamicLightScatteringLoadingOptions[Object[Protocol, ThermalShift, "id:9RdZXv1eYqNX"], CorrelationThreshold->0.1, TimeThreshold->2 Microsecond],
		_Grid
	],
	Example[{Options,OutputFormat,"Return the options as a list:"},
		AnalyzeDynamicLightScatteringLoadingOptions[Object[Protocol, ThermalShift, "id:9RdZXv1eYqNX"], OutputFormat -> List],
		_List
	]
}
];
