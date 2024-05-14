(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*RunComputation*)


(* ::Subsubsection::Closed:: *)
(*RunComputation*)


DefineUsage[RunComputation,{
	BasicDefinitions->{
		{"RunComputation[computation]","successBoolean","runs the input 'computation' object, and returns a 'successBoolean' indicating whether or not the computation executed successfully."}
	},
	MoreInformation->{
		"Computations are run asynchronously on the ECL Manifold by calling RunComputation from a remote Mathematica Kernel.",
		"RunComputation may be evaluated locally, but RunAsUser will default to $PersonID and Manifold-specific settings such as SLLVersion and HardwareConfiguration will be ignored.",
		"RunComputation executes each input/code cell in the template notebook file linked from the input computation's parent job.",
		"After each cell evaluation, RunComputation updates status, pending/completed notebooks, and logs kernel state and messages."
	},
	Input:>{
		{"computation",ObjectP[Object[Notebook,Computation]],"The computation notebook to be run."}
	},
	Output:>{
		{"successBoolean",True|False,"True if the computation finishes without errors and with a status of Completed, and False otherwise."}
	},
	SeeAlso->{
		"Compute",
		"StopComputation",
		"AbortComputation"
	},
	Author->{"platform"}
}];