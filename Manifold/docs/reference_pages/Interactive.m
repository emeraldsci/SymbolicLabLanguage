(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Interactive*)


(* ::Subsubsection::Closed:: *)
(*LaunchManifoldKernel*)

DefineUsage[LaunchManifoldKernel,
{
	BasicDefinitions->{
		{ "LaunchManifoldKernel[]", "kernel", "generates manifold kernel for interactive computations." },
		{ "LaunchManifoldKernel[numKernels]", "kernels", "generates 'numKernels' manifold kernel for interactive computations."}
	},
	Input:>{
		{"numKernels",_Integer,"The number of new kernels to launch."}
	},
	Output:>{
		{"kernel",ObjectP[Object[Software,ManifoldKernel]],"Object[Software,ManifoldKernel] object that was launched."},
		{"kernels",{ObjectP[Object[Software,ManifoldKernel]]..},"The Object[Software,ManifoldKernel] objects that were launched."}
	},
	MoreInformation->{
		"LaunchManifoldKernel generates one or more manifold kernel for interactive computations.  This allows users to run commands synchronously and asynchronously in the cloud rather than on his or her local machine.  Note that each active kernel will count as a running computation thread, and so cannot exceed the MaxComputationThreads of the users financing team."
	},
	SeeAlso->{
		"RunManifoldKernelCommand",
		"StopManifoldKernel",
		"AbortManifoldKernel",
		"ManifoldKernelStatus",
		"Compute"
	},
	Author->{"platform"}
}];

(* ::Subsubsection::Closed:: *)
(*AbortManifoldKernel*)

DefineUsage[AbortManifoldKernel,
{
	BasicDefinitions->{
		{"AbortManifoldKernel[]", "abortedKernels", "immediately stops all running manifold kernels."},
		{"AbortManifoldKernel[kernel]", "abortedKernel", "immediately stops the supplied kernel."},
		{"AbortManifoldKernel[kernels]", "abortedKernels", "immediately stops all supplied kernels."}
	},
	Input:> {
		{"kernel", ObjectP[Object[Software,ManifoldKernel]], "The manifold kernel to abort."},
		{"kernels", {ObjectP[Object[Software,ManifoldKernel]]..}, "The manifold kernels to abort."}
	},
	Output:>{
		{"abortedKernel",ObjectP[Object[Software,ManifoldKernel]],"The Object[Software,ManifoldKernel] object that was aborted."},
		{"abortedKernels",{ObjectP[Object[Software,ManifoldKernel]]..},"The Object[Software,ManifoldKernel] objects that were aborted."}
	},
	MoreInformation->{
		"AbortManifoldKernel immediately kills any running manifold kernels without waiting for current commands to complete."
	},
	SeeAlso->{
		"LaunchManifoldKernel",
		"RunManifoldKernelCommand",
		"StopManifoldKernel",
		"ManifoldKernelStatus",
		"Compute"
	},
	Author->{"platform"}
}];


(* ::Subsubsection::Closed:: *)
(*StopManifoldKernel*)

DefineUsage[StopManifoldKernel,
{
	BasicDefinitions->{
		{"StopManifoldKernel[]", "stoppedKernels", "stops all running manifold kernels after their current pending commands complete."},
		{"StopManifoldKernel[kernel]", "stoppedKernel", "stops the supplied kernel after its current pending commands complete."},
		{"StopManifoldKernel[kernels]", "stoppedKernels", "stops all supplied kernels after their current pending commands complete."}
	},
	Input:> {
		{"kernel", ObjectP[Object[Software,ManifoldKernel]], "The manifold kernel to stop."},
		{"kernels", {ObjectP[Object[Software,ManifoldKernel]]..}, "The manifold kernels to stop."}
	},
	Output:>{
		{"stoppedKernel",ObjectP[Object[Software,ManifoldKernel]],"The Object[Software,ManifoldKernel] object that was stopped."},
		{"stoppedKernels",{ObjectP[Object[Software,ManifoldKernel]]..},"The Object[Software,ManifoldKernel] objects that were stopped."}
	},
	MoreInformation->{
		"StopManifoldKernel kills any running manifold kernels after they complete execution of their current pending commands."
	},
	SeeAlso->{
		"LaunchManifoldKernel",
		"RunManifoldKernelCommand",
		"AbortManifoldKernel",
		"ManifoldKernelStatus",
		"Compute"
	},
	Author->{"platform"}
}];

(* ::Subsubsection::Closed:: *)
(*RunManifoldKernelCommand*)

DefineUsage[RunManifoldKernelCommand,
{
	BasicDefinitions->{
		{ "RunManifoldKernelCommand[command]", "kernelCommand", "Run the supplied 'command' on the a kernel from the kernel pool." },
		{ "RunManifoldKernelCommand[command, kernel]", "kernelCommand", "Run the supplied 'command' on the supplied 'kernel'."}
	},
	Input:>{
		{"command",_Expression,"The expression to run the manifold kernel."},
		{"kernel",ObjectP[Object[Software,ManifoldKernel]],"The kernel to run the command on."}
	},
	Output:>{
		{"kernelCommand",ObjectP[Object[Software,ManifoldKernelCommand]],"The Object[Software,ManifoldKernelCommand] that was generated."}
	},
	MoreInformation->{
		"Before calling this, you must have launched one or more manifold kernels via LaunchManifoldKernel[]."
	},
	SeeAlso->{
		"LaunchManifoldKernel",
		"StopManifoldKernel",
		"AbortManifoldKernel",
		"ManifoldKernelStatus",
		"Compute"
	},
	Author->{"platform"}
}];

(* ::Subsubsection::Closed:: *)
(*ManifoldKernelStatus*)

DefineUsage[ManifoldKernelStatus,
{
	BasicDefinitions->{
		{ "ManifoldKernelStatus[kernel]", "status", "Determine the status of the manifold kernel." }
	},
	Input:>{
		{"kernel",ObjectP[Object[Software,ManifoldKernel]],"The kernel to check the status of."}
	},
	Output:>{
		{"status",Queued|Stage|WaitingForDistro|Ready|Running|Completed, "The current status of the kernel."}
	},
	MoreInformation->{
		"A manifold kernel can be in the following states:  ",
		"Queued - the manifold job is in the queue and has not yet begun.  ",
		"Staged - the manifold job is in the process of starting up.  ",
		"WaitingForDistro - the manifold job is loading the requested version of SLL.  ",
		"Ready - The kernel is able to take comands.  ",
		"Running - the kernel is currently running a command.  ",
		"Completed - the kernel has finished running and is no longer able to take commands.  "
	},
	SeeAlso->{
		"LaunchManifoldKernel",
		"RunManifoldKernelCommand",
		"StopManifoldKernel",
		"AbortManifoldKernel",
		"Compute"
	},
	Author->{"platform"}
}];

(* ::Subsubsection::Closed:: *)
(*WaitForManifoldKernelCommand*)

DefineUsage[WaitForManifoldKernelCommand,
	{
		BasicDefinitions->{
			{ "WaitForManifoldKernelCommand[command]", "status", "Waits for the execution of a command to finish and returns the result." }
		},
		Input:>{
			{"kernel",ObjectP[Object[Software,ManifoldKernelCommand]],"The command to wait for."}
		},
		Output:>{
			{"result",_, "The result of the command."}
		},
		MoreInformation->{
			"If the command is never run or never completes, this function will hang."
		},
		SeeAlso->{
			"LaunchManifoldKernel",
			"RunManifoldKernelCommand",
			"StopManifoldKernel",
			"AbortManifoldKernel",
			"ManifoldKernelStatus",
			"Compute"
		},
		Author->{"platform"}
	}];