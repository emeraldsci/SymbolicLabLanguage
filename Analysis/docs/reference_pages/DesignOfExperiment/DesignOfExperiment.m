(* ::Section:: *)
(*DesignOfExperiment*)
DefineUsageWithCompanions[AnalyzeDesignOfExperiment,
	{
		BasicDefinitions -> {
			{"AnalyzeDesignOfExperiment[protocols, ObjectiveFunction\[Rule]objectiveFunction, ParameterSpace\[Rule]parameters]", "analysisObject", "Analyze the data objects within the list of input protocols, applying the 'objectiveFunction' to each data object, and returning an 'analysisObject' that details the 'parameters' that optimize the 'objectiveFunction' with the set of input 'protocols'."}
		},
		Input :> {
			{"protocols", ListableP[ObjectP[Object[Protocols]]], "Singleton or list of protocol objects."},
			{"parameters", {_Symbol..}, "A list of symbols describing the options that were varied across the input protocols."},
		    {"objectiveFunction", _Symbol|_Function, "A symbol corresponding to a function, or a pure function itself, that takes a list of {x,y} data, and outputs a single number, which is used to determine the quality of the experimental result."}
		},
		Output :> {
			{"analysisObject", ObjectP[Object[Analysis, DesignOfExperiment]], "The analysis object/packet that contains the information on objective function evaluations, and optimal parameters."}
		},
		SeeAlso -> {
			"AnalyzeKinetics",
			"AnalyzeFractions",
			"AnalyzeFit"
		},
		Author -> {
			"tommy.harrelson"
		},
		Provisional->True
	}]
