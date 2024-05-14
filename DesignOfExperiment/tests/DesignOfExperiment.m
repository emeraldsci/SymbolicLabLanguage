(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*DesignOfExperiment*)


DefineTests[DesignOfExperiment, {
	Example[{Basic, "Given an experiment function to perform a design of experiment, an object notebook script design of experiment is returned:"},
		script = DesignOfExperiment[
			SimulateHPLC[mySamples,
				ColumnTemperature -> Variable[{30 Celsius, 40 Celsius}],
				FlowRate -> Variable[{0.2 Milli Liter/Minute}],
				InjectionVolume -> 5 Microliter,
				GradientA -> Automatic,
				GradientB -> {{Quantity[0.`, "Minutes"], Quantity[5.`, "Percent"]}, {Quantity[5`, "Minutes"], Quantity[95.`, "Percent"]}}],
			ObjectiveFunction -> AreaOfTallestPeak],
		ObjectP[Object[DesignOfExperiment]]
	],

	(* Options *)

	Example[{Options, Method, "GridSearch method used to create a design of experiment:"},
		script = DesignOfExperiment[
			SimulateHPLC[mySamples,
				ColumnTemperature -> Variable[{30 Celsius, 40 Celsius}],
				FlowRate -> Variable[{0.2 Milli Liter/Minute}],
				InjectionVolume -> 5 Microliter,
				GradientA -> Automatic,
				GradientB -> {{Quantity[0.`, "Minutes"], Quantity[5.`, "Percent"]}, {Quantity[5`, "Minutes"], Quantity[95.`, "Percent"]}}],
			ObjectiveFunction -> AreaOfTallestPeak,Method->GridSearch],
		ObjectP[Object[DesignOfExperiment]]
	],

	Example[{Options, Method, "CustomSearch used to create a design of experiment:"},
		script = DesignOfExperiment[
			SimulateHPLC[mySamples,
				ColumnTemperature -> Variable[{30 Celsius, 40 Celsius}],
				FlowRate -> Variable[{0.2 Milli Liter/Minute, 1 Milli Liter/Minute}],
				InjectionVolume -> 5 Microliter,
				GradientA -> Automatic,
				GradientB -> {{Quantity[0.`, "Minutes"], Quantity[5.`, "Percent"]}, {Quantity[5`, "Minutes"], Quantity[95.`, "Percent"]}}],
			ObjectiveFunction -> AreaOfTallestPeak, Method->CustomSearch],
		ObjectP[Object[DesignOfExperiment]]
	],

	Example[{Options, ObjectiveFunction, "Target criteria to be optimized in a design of experiment:"},
		script = DesignOfExperiment[
			SimulateHPLC[mySamples,
				ColumnTemperature -> Variable[{30 Celsius, 40 Celsius}],
				FlowRate -> Variable[{0.2 Milli Liter/Minute}],
				InjectionVolume -> 5 Microliter,
				GradientA -> Automatic,
				GradientB -> {{Quantity[0.`, "Minutes"], Quantity[5.`, "Percent"]}, {Quantity[5`, "Minutes"], Quantity[95.`, "Percent"]}}],
			ObjectiveFunction -> MeanPeakSeparation],
		ObjectP[Object[DesignOfExperiment]]
	],
	Example[{Options, MaxExperimentThreads, "Upper limit of the total number of experiment threads that this design of experiment should not exceed (as determined by the experimenter's FinanceTeam policy):"},
		script = DesignOfExperiment[
			SimulateHPLC[mySamples,
				ColumnTemperature -> Variable[{30 Celsius, 40 Celsius}],
				FlowRate -> Variable[{0.2 Milli Liter/Minute}],
				InjectionVolume -> 5 Microliter,
				GradientA -> Automatic,
				GradientB -> {{Quantity[0.`, "Minutes"], Quantity[5.`, "Percent"]}, {Quantity[5`, "Minutes"], Quantity[95.`, "Percent"]}}],
			ObjectiveFunction -> AreaOfTallestPeak, MaxExperimentThreads->3],
		ObjectP[Object[DesignOfExperiment]]
	],
	Example[{Options, MaxExperimentNumber, "Total number of experiments allowed for this design of experiment:"},
		script = DesignOfExperiment[
			SimulateHPLC[mySamples,
				ColumnTemperature -> Variable[{30 Celsius, 40 Celsius}],
				FlowRate -> Variable[{0.2 Milli Liter/Minute}],
				InjectionVolume -> 5 Microliter,
				GradientA -> Automatic,
				GradientB -> {{Quantity[0.`, "Minutes"], Quantity[5.`, "Percent"]}, {Quantity[5`, "Minutes"], Quantity[95.`, "Percent"]}}],
			ObjectiveFunction -> AreaOfTallestPeak,MaxExperimentNumber->20],
		ObjectP[Object[DesignOfExperiment]]
	],
	Example[{Messages, "TooManyExperiments","Total number of planned experiments exceeds the total number of experiments allowed for this design of experiment:"},
		script = DesignOfExperiment[
			SimulateHPLC[mySamples,
				ColumnTemperature -> Variable[{30 Celsius, 40 Celsius, 50 Celsius, 60 Celsius}],
				FlowRate -> Variable[{0.2 Milli Liter/Minute, 0.5 Milli Liter/Minute, 1 Milli Liter/Minute, 1.5 Milli Liter/Minute}],
				InjectionVolume -> 5 Microliter,
				GradientA -> Automatic,
				GradientB -> {{Quantity[0.`, "Minutes"], Quantity[5.`, "Percent"]}, {Quantity[5`, "Minutes"], Quantity[95.`, "Percent"]}}],
			ObjectiveFunction -> AreaOfTallestPeak, MaxExperimentNumber->12],
		$Failed,
		Messages:>{DesignOfExperiment::TooManyExperiments}
	],
	Example[{Messages, "NoVariableInput","Design of experiment must have at least one 'Variable' in its options :"},
		script = DesignOfExperiment[
			SimulateHPLC[mySamples,
				ColumnTemperature -> {30 Celsius, 40 Celsius},
				FlowRate -> {0.2 Milli Liter/Minute},
				InjectionVolume -> 5 Microliter,
				GradientA -> Automatic,
				GradientB -> {{Quantity[0.`, "Minutes"], Quantity[5.`, "Percent"]}, {Quantity[5`, "Minutes"], Quantity[95.`, "Percent"]}}],
			ObjectiveFunction -> AreaOfTallestPeak, MaxExperimentNumber->12],
		$Failed,
		Messages:>{DesignOfExperiment::NoVariableInput}
	],
	Example[{Messages, "NoObjectiveFunction","Design of experiment must have an objective function :"},
		script = DesignOfExperiment[
			SimulateHPLC[mySamples,
				ColumnTemperature -> Variable[{30 Celsius, 40 Celsius}],
				FlowRate -> {0.2 Milli Liter/Minute},
				InjectionVolume -> 5 Microliter,
				GradientA -> Automatic,
				GradientB -> {{Quantity[0.`, "Minutes"], Quantity[5.`, "Percent"]}, {Quantity[5`, "Minutes"], Quantity[95.`, "Percent"]}}],
				MaxExperimentNumber->12],
		$Failed,
		Messages:>{DesignOfExperiment::NoObjectiveFunction}
	],
	Example[{Messages,"UnequalVariableLengths","The variable parameters must be the same length for CustomSearch:"},
		script = DesignOfExperiment[
			SimulateHPLC[mySamples,
				ColumnTemperature -> Variable[{30 Celsius, 40 Celsius}],
				FlowRate -> Variable[{0.2 Milli Liter/Minute}],
				InjectionVolume -> 5 Microliter,
				GradientA -> Automatic,
				GradientB -> {{Quantity[0.`, "Minutes"], Quantity[5.`, "Percent"]}, {Quantity[5`, "Minutes"], Quantity[95.`, "Percent"]}}],
			ObjectiveFunction -> AreaOfTallestPeak, Method->CustomSearch],
			$Failed,
			Messages:>{DesignOfExperiment::UnequalVariableLengths}
	],
	Example[{Attributes,HoldFirst,"The input expression is held before evaluation:"},
		script = DesignOfExperiment[
			SimulateHPLC[mySamples,
				ColumnTemperature -> Variable[{30 Celsius, 40 Celsius}],
				FlowRate -> Variable[{0.2 Milli Liter/Minute}],
				InjectionVolume -> 5 Microliter,
				GradientA -> Automatic,
				GradientB -> {{Quantity[0.`, "Minutes"], Quantity[5.`, "Percent"]}, {Quantity[5`, "Minutes"], Quantity[95.`, "Percent"]}}],
			ObjectiveFunction -> MeanPeakSeparation],
		ObjectP[Object[DesignOfExperiment]]
	]
}];


DefineTests[RunScriptDesignOfExperiment, {
	Example[
		{Basic, "Given a design of experiment script, a design of experiment object and design of experiment analysis are returned:"},
		doeObject = DesignOfExperiment[DesignOfExperiment`Private`SimulateHPLC[mySamples, ColumnTemperature -> Variable[{40 Celsius, 50 Celsius}]],ObjectiveFunction -> AreaOfTallestPeak];
		RunScriptDesignOfExperiment[First[doeObject[Script]]],
		{ObjectP[Object[DesignOfExperiment]], ObjectP[Object[Analysis, DesignOfExperiment]]}
	],

	Example[
		{Basic, "Given a design of experiment object, a design of experiment object and design of experiment analysis are returned:"},
		doeObject = DesignOfExperiment[DesignOfExperiment`Private`SimulateHPLC[mySamples, ColumnTemperature -> Variable[{40 Celsius, 50 Celsius}]],ObjectiveFunction -> AreaOfTallestPeak];
		RunScriptDesignOfExperiment[doeObject],
		{ObjectP[Object[DesignOfExperiment]], ObjectP[Object[Analysis, DesignOfExperiment]]}
	],

	Example[
		{Basic, "The the length of the completed protocols matches the number of protocols created in the script:"},
		doeObject = DesignOfExperiment[DesignOfExperiment`Private`SimulateHPLC[mySamples, ColumnTemperature -> Variable[{40 Celsius, 50 Celsius}]],ObjectiveFunction -> AreaOfTallestPeak];
		RunScriptDesignOfExperiment[doeObject];
		Length[doeObject[CompletedProtocols]],
		2,
		TimeConstraint -> 1000
	],

	Example[
		{Basic, "Variables from the script are returned to the kernel:"},
		RunScriptDesignOfExperiment[doeScript];
		DesignOfExperiment`Private`var1,
		10,
		TimeConstraint -> 1000,
		SetUp:>(
			script = ExperimentScript[var1 = 10; var2 = 55;];
			analysisObject = Upload[Association[Type -> Object[Analysis, DesignOfExperiment], DeveloperObject -> True]];
			doeScript = Upload[
				Association[Type -> Object[DesignOfExperiment],
				Script -> Link[script, DesignOfExperiment],
				Replace[DesignOfExperimentAnalyses] -> Link[analysisObject, Reference],
				DeveloperObject -> True]
			];
		)
	],

	Example[
		{Messages, "NoAnalysis", "No analysis object is linked to the design of experiment script:"},
		RunScriptDesignOfExperiment[doeScript],
		$Failed,
		Messages :> {Message[RunScriptDesignOfExperiment::NoAnalysis]},
		TimeConstraint -> 1000,
		SetUp:>(
			script = ExperimentScript[var1 = 10; var2 = 55;];
			doeScript = Upload[
				Association[Type -> Object[DesignOfExperiment],
				Script -> Link[script, DesignOfExperiment],
				DeveloperObject -> True]
			];
		)
	],

	Example[
		{Messages, "ScriptExecution", "The script stops when an error is thrown:"},
		RunScriptDesignOfExperiment[doeScript],
		{ObjectP[Object[DesignOfExperiment]], LinkP[Object[Analysis, DesignOfExperiment]]},
		Messages :> {Message[Power::infy, HoldForm[0^(-1)]], Message[Error::ScriptException]},
		TimeConstraint -> 1000,
		SetUp:> (
			script = ExperimentScript[var1 = 1/0; var2 = 55;];
			analysisObject = Upload[Association[Type -> Object[Analysis, DesignOfExperiment], DeveloperObject -> True]];
			doeScript = Upload[
				Association[Type -> Object[DesignOfExperiment],
				Script -> Link[script, DesignOfExperiment],
				Replace[DesignOfExperimentAnalyses] -> Link[analysisObject, Reference],
				DeveloperObject -> True]
			];
		)
	],

	Example[
		{Additional, "Resume script after it was stopped, because an error was thrown:"},
		{doeScript,anaObj} = RunScriptDesignOfExperiment[doeScript];
		RunScriptDesignOfExperiment[doeScript],
		{ObjectP[Object[DesignOfExperiment]], ObjectP[Object[Analysis, DesignOfExperiment]]},
		Messages :> {Message[Power::infy, HoldForm[0^(-1)]], Message[Error::ScriptException]},
		TimeConstraint -> 1000,
		SetUp:> (
			script = ExperimentScript[var1 = 1/0; var2 = 55;];
			analysisObject = Upload[Association[Type -> Object[Analysis, DesignOfExperiment], DeveloperObject -> True]];
			doeScript = Upload[
				Association[Type -> Object[DesignOfExperiment],
				Script -> Link[script, DesignOfExperiment],
				Replace[DesignOfExperimentAnalyses] -> Link[analysisObject, Reference],
				DeveloperObject -> True]
			];
		)
	],

	Example[
		{Options, PlotAnalysis, "PlotAnalysis option shows the design of experiment plot during the run:"},
		script = DesignOfExperiment[DesignOfExperiment`Private`SimulateHPLC[mySamples, ColumnTemperature -> Variable[{40 Celsius}]],ObjectiveFunction -> AreaOfTallestPeak];
		RunScriptDesignOfExperiment[script, PlotAnalysis -> True],
		{ObjectP[Object[DesignOfExperiment]], ObjectP[Object[Analysis, DesignOfExperiment]]},
		TimeConstraint -> 1000
	]
}];
