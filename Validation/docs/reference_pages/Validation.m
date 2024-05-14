(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*ValidQ Functions*)


(* ::Subsubsection::Closed:: *)
(*RunValidQTest*)


DefineUsage[RunValidQTest,
{
	BasicDefinitions->
		{
			{"RunValidQTest[items,lookupFunctions]","bools","returns True/False for each of 'items' based on excuting the tests for that item given by 'lookupFunctions'."},
			{"RunValidQTest[item,lookupFunctions]","bool","returns True/False based on excuting the tests for given 'item' given by 'lookupFunctions'."}
		},
	MoreInformation->{
		"lookupFunctions are expected to take an 'item' as input and return a list of TestP|ExampleP.",
		"If OutputFormat -> Test, no tests are executed."
	},
	Input:>
		{
			{"items",_List,"List of entities to call lookup functions on to retrieve tests."},
			{"item",_,"Input to lookupFunctions to get tests to be executed."},
			{"lookupFunctions",{(_Symbol|_Function)...},"List of functions to call on the list of entities to retrieve tests for."}
		},
	Output:>
		{
			{"bools",{(True|False)...},"A list of True|False for each tested item."},
			{"bool",True|False,"True|False depending on whether all tests pass."}
		},
	SeeAlso->{"RunUnitTest","Association"},
	Author->{"pnafisi", "melanie.reschke", "josh.kenchel", "steven", "platform"}
}];