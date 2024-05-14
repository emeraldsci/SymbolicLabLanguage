(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*RunManifoldSmokeTest*)


(* ::Subsubsection::Closed:: *)
(*RunManifoldSmokeTest*)


DefineUsage[RunManifoldSmokeTest,{
	BasicDefinitions->{
		{"RunManifoldSmokeTest[]","jobs","Enqueues a series of Manifold 'jobs' to be used by CheckManifoldSmokeTest after completing a Manifold release."}
	},
	Input:>{},
	Output:>{
		{"jobs", _Association, "An association mapping the test type to its corresponding job."}
	},
	SeeAlso->{
		"Compute",
		"CheckManifoldSmokeTest"
	},
	Author->{"platform"}
}];


(* ::Subsubsection::Closed:: *)
(*CheckManifoldSmokeTest*)


DefineUsage[CheckManifoldSmokeTest,{
	BasicDefinitions->{
		{"CheckManifoldSmokeTest[runSmokeTestOutput]","resultString","Checks the status of jobs created by RunManifoldSmokeTest, then outputs a result string indicating the status of those tests."}
	},
	Input:>{
		{"runSmokeTestOutput", _Association, "The output of RunManifoldSmokeTest, which is an association mapping test names to Manifold jobs."}
	},
	Output:>{
		{"resultString", _String, "A message indicating the result of a smoke test."}
	},
	SeeAlso->{
		"Compute",
		"RunManifoldSmokeTest"
	},
	Author->{"platform"}
}];

(* ::Subsubsection::Closed:: *)
(*ManifoldEcho*)


DefineUsage[ManifoldEcho,{
	BasicDefinitions->{
		{"ManifoldEcho[expr]","expr","In Manifold logs, prints 'expr' and returns 'expr'. In Mathematica notebooks, only returns 'expr'."},
		{"ManifoldEcho[expr, label]","expr","In Manifold logs, prints 'expr' prepending 'label' and returns 'expr'. In Mathematica notebooks, only returns 'expr'."}
	},
	Input:>{
		{"expr", _Expression, "The inputs to Echo, which are only printed in Manifold logs."},
		{"label", _String, "The label prepended to 'expr' in the print."}
	},
	Output:>{
		{"expr", _Expression, "The input expression."}
	},
	SeeAlso->{
		"Compute"
	},
	Author->{"derek.machalek", "platform"}
}];
