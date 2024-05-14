(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Scripts*)

(* ::Subsubsection::Closed:: *)
(*Parallel*)

DefineUsage[
	SaveScriptOutput,
	{
		BasicDefinitions->{
			{"SaveScriptOutput[emeraldCloudFile]","scriptObject","Links the cloud file 'emeraldCloudFile' to the Output field of the currently running script set in $NotebookPage if $NotebookPage is set to a valid Object[Notebook, Script], and does nothing otherwise."}
		},
		MoreInformation->{},
		Input:>{
			{"emeraldCloudFile",ObjectP[Object[EmeraldCloudFile]], "The emerald cloud file to be linked to the Output field of the current script."}
		},
		Output:>{
			{"scriptObject",{ObjectP[Object[Notebook, Script]]..}, "The script object currently set in $NotebookPage."}
		},
		SeeAlso->{
			"RunScript",
			"PauseScript",
			"StopScript"
		},
		Author->{"scicomp", "hiren.patel"}
	}
];

DefineUsage[
	Parallel,
	{
		BasicDefinitions->{
			{"Parallel[experimentCalls]","protocols","executes the given experiment calls and runs the resulting protocol objects in parallel, when executed in a script."}
		},
		MoreInformation->{
			"Note that if using in a script where the previous protocol was Overclock -> True, all subsequent protocols inside the Parallel head will NOT be overclocked.  If relying on overclocking threads with living cell samples, please do not use the Parallel head."
		},
		Input:>{
			{"experimentCalls",_,"Experiment calls that will return the protocol objects to be executed."}
		},
		Output:>{
			{"protocols",{ObjectP[Object[Protocol]]..},"The protocol objects that should be executed in parallel."}
		},
		SeeAlso->{
			"RunScript",
			"PauseScript",
			"StopScript",
			"ValidExperimentScriptQ"
		},
		Author->{"thomas","robert","hayley"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ExperimentScript*)


DefineUsage[
	ExperimentScript,
	{
		BasicDefinitions->{
			{"ExperimentScript[expression]","newScript","generates a new script object where the statements in 'expression' make up the contents of the script's notebook."},
			{"ExperimentScript[name]","newScript","generates a new script using an existing script as a template when passed the Template option."}
		},
		MoreInformation->{},
		Input:>{
			{"expression",_,"A set of commands that will be written to a script notebook."},
			{"name",_String,"The name of the generated script."}
		},
		Output:>{
			{"newScript",ObjectP[Object[Notebook,Script]],"The new script."}
		},
		SeeAlso->{
			"RunScript",
			"PauseScript",
			"StopScript",
			"ValidExperimentScriptQ"
		},
		Author->{"tyler.pabst", "daniel.shlian", "thomas", "robert", "hayley"}
	}
];



(* ::Subsubsection::Closed:: *)
(*PauseScript*)


DefineUsage[
	PauseScript,
	{
		BasicDefinitions->{
			{"PauseScript[script]","updatedScript","prevents that script from continuing after currently running protocols have completed."}
		},
		MoreInformation->{
		},
		Input:>{
			{"script",ObjectP[Object[Notebook,Script]],"A script in the middle of execution."}
		},
		Output:>{
			{"updatedScript",ObjectP[Object[Notebook,Script]],"The paused script."}
		},
		SeeAlso->{
			"ExperimentScript",
			"RunScript",
			"StopScript",
			"ValidExperimentScriptQ"
		},
		Author->{"tyler.pabst", "daniel.shlian", "thomas", "hayley"}
	}
];



(* ::Subsubsection::Closed:: *)
(*StopScript*)


DefineUsage[
	StopScript,
	{
		BasicDefinitions->{
			{"StopScript[script]","updatedScript","cancels any script protocols which have not yet been run and stops the script from further execution."}
		},
		MoreInformation->{
		},
		Input:>{
			{"script",ObjectP[Object[Notebook,Script]],"A script in the middle of execution."}
		},
		Output:>{
			{"updatedScript",ObjectP[Object[Notebook,Script]],"The stopped script."}
		},
		SeeAlso->{
			"ExperimentScript",
			"RunScript",
			"PauseScript",
			"ValidExperimentScriptQ"
		},
		Author->{"tyler.pabst", "daniel.shlian", "thomas", "hayley"}
	}
];



(* ::Subsubsection::Closed:: *)
(*RunScript*)


DefineUsage[
	RunScript,
	{
		BasicDefinitions->{
			{"RunScript[script]","updatedScript","runs the given 'script' until a protocol is generated, an error message is thrown, or PauseScript[] is called."}
		},
		MoreInformation->{
		},
		Input:>{
			{"script",ObjectP[Object[Notebook,Script]],"The script to run."}
		},
		Output:>{
			{"updatedScript",ObjectP[Object[Notebook,Script]],"The updated script."}
		},
		SeeAlso->{
			"ExperimentScript",
			"PauseScript",
			"StopScript",
			"ValidExperimentScriptQ"
		},
		Author->{"olatunde.olademehin", "daniel.shlian", "josh.kenchel", "thomas"}
	}
];



(* ::Subsubsection::Closed:: *)
(*ValidExperimentScriptQ*)


DefineUsage[
	ValidExperimentScriptQ,
	{
		BasicDefinitions->{
			{"ValidExperimentScriptQ[functionCalls]","updatedScript","verifies that the set of function calls can be converted into script."}
		},
		MoreInformation->{
		},
		Input:>{
			{"functionCalls",_,"A series of function calls which should be run as a script."}
		},
		Output:>{
			{"result",BooleanP,"A boolean indicating if the calls can create a valid script."}
		},
		SeeAlso->{
			"ExperimentScript",
			"RunScript",
			"PauseScript",
			"StopScript"
		},
		Author->{"tyler.pabst", "daniel.shlian", "thomas", "hayley"}
	}
];