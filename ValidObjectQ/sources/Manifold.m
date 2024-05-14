(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)
(*Source Code*)


(* ::Subsection:: *)
(*validManifoldComputationQTests*)


validNotebookQTests[packet:PacketP[Object[Notebook]]]:={
	NotNullFieldTest[packet, {DateCreated}]
};


(* ::Subsection:: *)
(*validManifoldComputationQTests*)


validManifoldComputationQTests[packet:PacketP[Object[Notebook,Computation]]]:={
	(* Shared fields which should be Null *)
	NullFieldTest[packet,{
		AssetFile,
		AssetFileLog,
		Protocols
	}],

	(* Fields which must not be Null *)
	NotNullFieldTest[packet,{
		Status,
		DateEnqueued,
		Job,
		TemplateSectionsJSON
	}],

	Test["Parent Job passes ValidObjectQ:",
		ValidObjectQ[Download[Lookup[packet, Job]]],
		True
	],

	Test["If Status is Running, then DateStarted is populated:",
		If[MatchQ[Lookup[packet, Status], Running],
			FreeQ[Lookup[packet, {DateStarted}], Null, 1],
			True
		],
		True
	],

	Test["If Status is Completed or Stopped, all tracking fields are populated:",
		If[MatchQ[Lookup[packet, Status], Completed|Stopped],
			FreeQ[
				Lookup[packet,
					{
						DateStarted,
						DateCompleted,
						ActualRunTime,
						History,
						CompletedNotebookFile,
						CompletedNotebookFileLog,
						PendingNotebookFile,
						PendingNotebookFileLog
					}
				],
				Null|{},
				1
			],
			True
		],
		True
	]

};


(* ::Subsection::Closed:: *)
(*validManifoldJobQTests*)


validManifoldJobQTests[packet:PacketP[Object[Notebook,Job]]]:={
	(* Shared fields which should be Null *)
	NullFieldTest[packet,{
		AssetFile,
		AssetFileLog,
		Protocols
	}],

	(* Fields which must be informed *)
	NotNullFieldTest[packet,{
		Status,
		JobType,
		HardwareConfiguration,
		EstimatedRunTime,
		MaximumRunTime,
		MaximumThreads,
		ComputationFinancingTeam,
		TemplateSectionsJSON
	}],

	(* at least one of these fields must be informed *)
	AnyInformedTest[packet,{TemplateNotebookFile, TemplateNotebook}],

	Test["If JobType is OneTime, no other job types are specified:",
		If[MemberQ[Lookup[packet,JobType],OneTime],
			MatchQ[Lookup[packet,JobType],{OneTime}],
			True
		],
		True
	],

	Test["If JobType includes Scheduled, then scheduled start dates are populated:",
		If[MemberQ[Lookup[packet,JobType],Scheduled],
			!MatchQ[Lookup[packet,{ScheduledStartDates}],Null|{}],
			True
		],
		True
	],

	Test["If repeat frequencies are provided, then they are larger than the maximum run time:",
		If[!MatchQ[Lookup[packet,ComputationFrequency],Null|{}],
			And@@(#>=Lookup[packet,MaximumRunTime]&/@Lookup[packet,ComputationFrequency]),
			True
		],
		True
	],

	Test["If JobType includes triggered, then EITHER object-tracking or type-tracking fields are provided:",
		If[MemberQ[Lookup[packet,JobType], Triggered],
			Xor[
				!MatchQ[Lookup[packet,TrackedTypeChanges], Null|{}],
				!MatchQ[Lookup[packet,TrackedObjectChanges], Null|{}]
			],
			True
		],
		True
	],

	Test["If tracked type fields are provided, fields are valid for their corresponding types:",
		If[!MatchQ[Lookup[packet,TrackedTypeFieldChanges],Null|{}],
			With[{fields=Lookup[packet,TrackedTypeFieldChanges], types=Lookup[packet,TrackedTypeChanges]},
				And@@MapThread[
					Function[{type,fields},
						Or[
							MatchQ[fields,{All}],
							MatchQ[type[#]&/@fields,{FieldP[type]..}]
						]
					],
					{types,fields}
				]
			],
			True
		],
		True
	],

	Test["If tracked object fields are provided, fields are valid for their corresponding objects:",
		If[!MatchQ[Lookup[packet,TrackedObjectFieldChanges],Null|{}],
			With[{fields=Lookup[packet,TrackedObjectFieldChanges], types=Download[Lookup[packet,TrackedObjectChanges],Type]},
				And@@MapThread[
					Function[{type,fields},
						Or[
							MatchQ[fields,{All}],
							MatchQ[type[#]&/@fields,{FieldP[type]..}]
						]
					],
					{types,fields}
				]
			],
			True
		],
		True
	],

	Test["Estimated run time is less than the maximum run time:",
		Lookup[packet,EstimatedRunTime] <= Lookup[packet, MaximumRunTime],
		True
	],

	Test["MaximumThreads is greater than zero:",
		Lookup[packet,MaximumThreads] > 0,
		True
	],

	Test["Maximum run time is between one minute and one week: ",
		And[Lookup[packet, MaximumRunTime] >= (1 Minute), Lookup[packet, MaximumRunTime] <= (1 Week)],
		True
	],

	Test["If the Author is not a superuser, then superuser-only fields are empty:",
		If[!MatchQ[Lookup[packet, CreatedBy], ObjectP[Object[User,Emerald]]],
			And[
				MatchQ[Lookup[packet, SLLCommit], Null],
				MatchQ[Lookup[packet, SLLVersion], Null],
				MatchQ[Lookup[packet, SLLPackage], Null],
				MatchQ[Lookup[packet, ZDriveFilePaths], Null|{}],
				MatchQ[Lookup[packet, RunAsUser], Null],
				MatchQ[Lookup[packet, FargateCluster], Null]
			],
			True
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*Test Registration*)


registerValidQTestFunction[Object[Notebook], validNotebookQTests];
registerValidQTestFunction[Object[Notebook, Computation], validManifoldComputationQTests];
registerValidQTestFunction[Object[Notebook, Job], validManifoldJobQTests];
