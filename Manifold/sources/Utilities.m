(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*RunManifoldSmokeTest*)

(* Test that immediate, scheduled, and triggered jobs work *)
RunManifoldSmokeTest[]:=Module[
	{immediateJob, scheduledJob, triggeredJob},

	(* Create an immediate job *)
	immediateJob = Compute[1+1, MaximumRunTime->(10 Minute)];

	(* Create a triggered job *)
	triggeredJob = Compute[
		$TrackedObjects,
		Trigger->{immediateJob},
		TrackedFields->{{Name}},
		MaximumRunTime->(10 Minute)
	];

	(* Create a scheduled job *)
	scheduledJob = With[{job=immediateJob},
		Compute[
			Upload[<|Object->job, Name->"manifold smoke test "<>CreateUUID[]|>],
			Schedule->(Now + 5 Minute),
			MaximumRunTime->(10 Minute)
		]
	];

	(* Output the jobs *)
	<|
		"immediate" -> immediateJob,
		"scheduled" -> scheduledJob,
		"triggered" -> triggeredJob
	|>
];


(* ::Section:: *)
(*CheckManifoldSmokeTest*)

(* Make sure the test was correct, delete objects if they are *)
CheckManifoldSmokeTest[runSmokeTestOutput_Association]:=Module[
	{
		allTestObjects, immediateJob, scheduledJob, triggeredJob,
		immediateComp, scheduledComp, triggeredComp,
		immediateStatus, scheduledStatus, triggeredStatus
	},

	(* Pull jobs from the input association *)
	immediateJob = Lookup[runSmokeTestOutput, "immediate"];
	scheduledJob = Lookup[runSmokeTestOutput, "scheduled"];
	triggeredJob = Lookup[runSmokeTestOutput, "triggered"];

	(* Pull most recent computation out *)
	immediateComp = LastOrDefault[Download[immediateJob, Computations], Null];
	scheduledComp = LastOrDefault[Download[scheduledJob, Computations], Null];
	triggeredComp = LastOrDefault[Download[triggeredJob, Computations], Null];

	(* Get statuses *)
	immediateStatus = Download[immediateComp, Status];
	scheduledStatus = Download[scheduledComp, Status];
	triggeredStatus = Download[triggeredComp, Status];

	(* LIst of all objects made from the test *)
	allObjects=Flatten@Join[
		{immediateJob, scheduledJob, triggeredJob},
		Flatten@Download[{immediateJob, scheduledJob, triggeredJob}, Computations]
	];

	If[MemberQ[{immediateComp, scheduledComp, triggeredComp}, Null]||MemberQ[{immediateStatus, scheduledStatus, triggeredStatus}, Queued|Running|Staged],
		Return[StringJoin[
			"Smoke test running: Please check again in a few minutes. If you have been waiting for more than 15 minutes, ",
			"please verify the queue is open and that Manifold components are working correctly in CloudWatch."
		]]
	];

	(* If we pass then erase the objects and let the person know *)
	If[MatchQ[{immediateStatus, scheduledStatus, triggeredStatus}, {Completed..}],
		EraseObject[allObjects, Force->True];
		Return["Smoke test passed! Test objects have been deleted."]
	];

	If[MemberQ[{immediateStatus, scheduledStatus, triggeredStatus}, Error|Aborted|Stopped],
		Echo[allObjects, "allObjects"];
		Return[StringJoin[
			"Smoke test failed! Please rerun the smoke test, or if you believe that Manifold is broken, ",
			"revert the manifold deployment as soon as possible."
		]]
	];

	Return["Smoke test exited unexpectedly - please take a look at the test code in SLL/Manifold/sources/Utilities.m"]
];

(* ::Section:: *)
(* ManifoldEcho *)

(* ManifoldEcho reproduces Echo inside of Manifold and returns nothing to the User or in an MM notebook *)
(* ECL` context must be used on ManifoldEcho, otherwise the symbol will be unrecognized *)
(* If outside $ManifoldRunTime, return the first argument as Echo does, but without printing *)
ManifoldEcho[expr_]:= If[TrueQ[ECL`$ManifoldRuntime],
	Echo[expr],
	expr
];
ManifoldEcho[expr_, label_]:= If[TrueQ[ECL`$ManifoldRuntime],
	Echo[expr, label],
	expr
];
