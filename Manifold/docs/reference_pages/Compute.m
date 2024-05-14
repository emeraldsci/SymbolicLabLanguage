(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Compute*)


(* ::Subsubsection::Closed:: *)
(*Compute*)


DefineUsage[Compute,{
	BasicDefinitions->{
		{
			Definition -> {"Compute[expression]", "job"},
			Description -> "generates a Manifold 'job' notebook where the statements in 'expression' make up the contents of the job's template notebook.",
			Inputs :> {
				{
					InputName -> "expression",
					Description -> "A compound mathematica expression, with individual expressions separated by semicolons, to convert into a template job notebook.",
					Widget -> Widget[Type->Expression, Pattern:>_, Size->Paragraph]
				}
			},
			Outputs :> {
				{
					OutputName -> "job",
					Description -> "A template job notebook which may enqueue one or more computations to run on a remote, cloud-based SLL kernel.",
					Pattern :> ObjectP[Object[Notebook, Job]]
				}
			}
		},
		{
			Definition -> {"Compute[page]", "job"},
			Description -> "generates a Manifold 'job' notebook using 'page' as the job's template notebook.",
			Inputs :> {
				{
					InputName -> "page",
					Description -> "A notebook page to use as this job's template notebook.",
					Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Notebook, Page]]]
				}
			},
			Outputs :> {
				{
					OutputName -> "job",
					Description -> "A template job notebook which may enqueue one or more computations to run on a remote, cloud-based SLL kernel.",
					Pattern :> ObjectP[Object[Notebook, Job]]
				}
			}
		}
	},
	MoreInformation->{
		"Compute generates a Manifold job object, which is used to run asynchronous computations on the ECL's cloud-computing platform, Manifold.",
		"Manifold jobs are templates that generate one or more Computation objects, which represent the evaluation of a notebook page or series of SLL commands.",
		"When a Job generates a Computation, the Computation is enqueued and executed on Manifold as soon as computational threads are available.",
		"Jobs can be configured to enqueue Computations as a one-off, at scheduled times, at repeating intervals, or in response to changes in objects or types."
	},
	SeeAlso->{
		"ValidComputationQ",
		"ActivateJob",
		"DeactivateJob",
		"StopComputation",
		"AbortComputation",
		"DebugManifoldJob"
	},
	Author->{"platform"}
}];


(* ::Subsubsection::Closed:: *)
(*ValidComputationQ*)


DefineUsage[ValidComputationQ,{
	BasicDefinitions->{
		{"ValidComputationQ[expression]","updatedPage","verifies if the mathematica commands in 'expression' can be converted into a computation."},
		{"ValidComputationQ[page]","updatedPage","verifies if the provided notebook 'page' can be converted into a computation."}
	},
	MoreInformation->{},
	Input:>{
		{"expression",_,"A set of mathematica commands which will be tested to see if they can be converted into a computation."},
		{"page",ObjectP[Object[Notebook,Page]],"A notebook page which be tested to see if it can be converted into a computation."}
	},
	Output:>{
		{"updatedPage",BooleanP|ObjectP[Object[Notebook,Page]],"Either an updated notebook page with the converted computation with errors highlighted, or a boolean indicating if the input can create a valid computation."}
	},
	SeeAlso->{
		"Compute",
		"ActivateJob",
		"DeactivateJob",
		"StopComputation",
		"AbortComputation"
	},
	Author->{"platform"}
}];