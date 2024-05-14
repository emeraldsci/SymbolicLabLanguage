(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*updateParallelComputationFields*)

DefineUsage[
	updateParallelComputationFields,
	{
		BasicDefinitions -> {
			{"updateParallelComputationFields[]", "updatedProtocols", "finds all protocols where ComputationsOutstanding is set to True and checks whether those computations are still outstanding, completed, or had some error."}
		},
		MoreInformation -> {
			"This function will flip the ComputationsOutstanding Boolean from True to False if all computations in ParallelComputations have been completed.  Jobs that are in ErroneousComputations are counted as completed for this purpose.",
			"If a job has had an error thrown or in any way failed, an asana task is created for sci ops to figure out why the job errored out and to fix it."
		},
		Input :> {},
		Output :> {
			{"updatedProtocols", {ObjectP[ProtocolTypes[]]...}, "All protocols that previously had ComputationsOutstanding"}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"ProcedureFramework`Private`parallelExecuteAssociation",
			"CreateAsanaTask"
		},
		Author -> {"waseem.vali", "malav.desai", "steven"}
	}
];