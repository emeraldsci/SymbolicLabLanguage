(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Compute*)


(* ::Subsection::Closed:: *)
(*Messages*)

$ManifoldMaximumComputationTime=(1 Week);
Warning::DeveloperOnlyOptions="Current user does not have adequate permissions to set option(s) `1`. These option(s) will be ignored and reverted to their defaults.";
Warning::NoTrigger="Option Trigger was either not specified or set to None, so option TrackedFields will be ignored.";
Error::CloudOnlyOptions="The supplied options `1` can only be used when computing on the cloud. Please set Computation->Cloud, or remove these options from your Compute call.";
Error::EstimatedTimeExceedsMaximum="The supplied EstimatedRunTime `1` exceeds the MaximumRunTime `2`. Please adjust the MaximumRunTime option.";
Error::InvalidRepeat="Only one RepeatFrequency may be specified when Schedule is None or not provided. Please set a single RepeatFrequency, or provide multiple dates in Schedule.";
Error::InvalidSchedule="If Schedule is specified as a list, it cannot contain None. Please ensure the list is populated with dates, or set Schedule->None.";
Error::InvalidTrackedFields="The fields `1` are not valid fields of Trigger(s) `2`. Please change these types or set TrackedTypes to {All} for these Triggers.";
Error::InvalidTrackedFieldsLength="The option TrackedFields has length `2`, which does not match the number of entries in Trigger, `1`. Please ensure that Trigger and TrackedFields have the same length.";
Error::MaximumTimeTooSmall="The MaximumRunTime `1` exceeds system limitations. Please specify a maximum run time greater than 10 minutes.";
Error::MaximumTimeExceeded="The MaximumRunTime `1` is too small. Please specify a maximum run time less than `2`.";
Error::ObjectNotFound="The objects `1` in option Trigger could not be found in the database. Please ensure that all objects used in Trigger exist on Constellation.";
Error::RepeatFrequencyTooSmall="The smallest RepeatFrequency `1` is either less than 10 minutes or the MaximumRunTime for this computation, `2`, which may result in accumulating or conflicting computations. Please specify larger repeat frequencies.";
Error::ScheduledDateInPast="Dates `1` provided in option Schedule are before the current date/time `2`. Scheduled start times must be in the future.";

(* Sandbox Errors*)
Error::RepeatNotAllowed="RepeatFrequency not allowed when computing in the Sandbox environment.";
Error::TriggerNotAllowed="Triggered computations are not allowed when computing in Sandbox environment";
Error::ProductionDatabase="ProductionQ[] has evaluated to True. Cannot launch sandboxed computations in the Production Environment.";
Error::ZDriveNotAllowed="ZDrive files may not be imported when running computations in the Sandbox environment.";

(* ::Subsection::Closed:: *)
(*Options*)
DefineOptionSet[ZDriveFilePathsOptions :> {
	{
		OptionName->ZDriveFilePaths,
		Default->{},
		Description->"If computing on the cloud, a list of all Z-drive file paths used in this computation. Only file paths specified here will be accessible on Manifold.",
		AllowNull->False,
		Widget->Alternatives[
			Adder[
				Widget[Type->String,Pattern:>_String,Size->Line]
			],
			Widget[Type->Enumeration,Pattern:>Alternatives[{}]]
		],
		Category->"Hidden"
	}
}];

(* options that determine the state of the environment and hardware that the computation will run on *)
DefineOptionSet[BaseComputationKernelOptions :> {
	{
		OptionName->HardwareConfiguration,
		Default->Standard,
		Description->StringJoin[
			"If computing on the cloud, the hardware which should be used to run computations. ",
			"Standard - Fargate cluster with 8GB RAM. ",
			"HighRAM - Fargate cluster with 30GB RAM."
		],
		AllowNull->False,
		Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Standard,HighRAM]],
		Category->"Manifold Parameters"
	},
	(** Hidden options for developers only **)
	{
		OptionName->SLLVersion,
		Default->Null,
		Description->"If computing on the cloud, the version of SLL which computations should use.",
		AllowNull->True,
		Widget->Alternatives[
			Widget[Type->Enumeration,Pattern:>Alternatives[Stable,Develop]],
			"Branch Name"->Widget[Type->String,Pattern:>_String,Size->Line]
		],
		Category->"Hidden"
	},
	{
		OptionName->SLLCommit,
		Default->Null,
		Description->"If computing on the cloud, the SHA-1 hash indicating which SLL commit this Manifold job should run.",
		AllowNull->True,
		Widget->Widget[Type->String,Pattern:>_String,Size->Line],
		Category->"Hidden"
	},
	{
		OptionName->SLLPackage,
		Default->Null,
		Description->"If computing on the cloud, indicates whether SLL` or SLL`Dev` should be loaded for this computation.",
		AllowNull->True,
		Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Standard,Developer]],
		Category->"Hidden"
	},
	{
		OptionName->RunAsUser,
		Default->Null,
		Description->"If computing on the cloud, the user which Manifold should run computations as.",
		ResolutionDescription->"If not specified, the Job will run as its CreatedBy user, i.e. whoever is logged in when Compute is called.",
		AllowNull->True,
		Widget->Widget[Type->Object,Pattern:>ObjectP[Object[User]]],
		Category->"Hidden"
	},
	{
		OptionName->FargateCluster,
		Default->Null,
		Description->"Specify which Fargate cluster will be used. Note that at present, only a public and dev-only cluster are available. To use the public cluster, leave this option Null. If the dev-only cluster is needed (e.g. ZDrive access is needed), Compute will resolve this automatically.",
		ResolutionDescription->"If not specified, the public Manifold cluster will be used.",
		AllowNull->True,
		Widget->Widget[Type->String, Pattern:>_String, Size->Word],
		Category->"Hidden"
	},
	{
		OptionName->DisablePaclets,
		Default->Null,
		Description->"If True, the Mathematica kernel running this Manifold job will be launched with the -nopaclets command line option.",
		AllowNull->True,
		Widget->Widget[Type->Enumeration,Pattern:>Alternatives[True,False]],
		Category->"Hidden"
	},
	{
		OptionName->MathematicaVersion,
		Default->Null,
		Description->"Specify which Mathematica version should be used to run this Manifold job. Null defaults to 13.3.1.",
		AllowNull->True,
		Widget->Widget[Type->Enumeration,Pattern:>Alternatives["13.3.1"]],
		Category->"Hidden"
	},
	{
		OptionName -> Environment,
		Default -> Integrated,
		Description -> "Specify whether to run the computation in a local development environment.",
		AllowNull->False,
		Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Integrated, Sandbox]],
		Category->"Hidden"
	}
}];


(* additional options as part of the computation kernel that are unrelated to hardware *)

DefineOptionSet[ComputationKernelOptions :> {
	BaseComputationKernelOptions,
	ZDriveFilePathsOptions
}];

(** Options for scheduling timed and repeat jobs **)
DefineOptionSet[scheduledOptions :> {
	IndexMatching[
		{
			OptionName->Schedule,
			Default->None,
			Description->"If computing on the cloud, specify a list of dates and times at which this computation should be run.",
			ResolutionDescription->"This computation can be set to repeat at regular intervals by additionally setting the RepeatFrequency option.",
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[None]],
				Widget[Type->Date, Pattern:>_?DateObjectQ, TimeSelector->True]
			],
			Category->"Scheduling"
		},
		{
			OptionName->RepeatFrequency,
			Default->None,
			Description->"If computing on the cloud, specify the frequency at which this computation should be repeated.",
			ResolutionDescription->StringJoin[
				"If the Schedule option is also specified, this computation will be repeated from each of the specified dates. ",
				"For example, if Schedule is set to Monday, Wednesday, and Friday at 1:00 PM, setting RepeatFrequency->(1 Week) will create a repeating task ",
				"which starts every Monday, Wednesday, and Friday at 1:00 PM."
			],
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[None]],
				Widget[Type->Quantity, Pattern:>GreaterP[0.0 Day], Units->Alternatives[Day,Week,Hour]]
			],
			Category->"Scheduling"
		},
		IndexMatchingParent->Schedule
	]
}];

(** Options for computations triggered by changes **)
DefineOptionSet[triggeredComputationOptions :> {
	{
		OptionName->Trigger,
		Default->None,
		Description->"If computing on the cloud, specify a list of object(s) or type(s) which, upon creation or modification, should trigger this computation to run. The list of triggering objects may be referenced within your computation using the variable $TrackedObjects.",
		AllowNull->False,
		Widget->Alternatives[
			Widget[Type->Enumeration, Pattern:>Alternatives[None]],
			"Type(s)"->Adder[
				Widget[Type->Expression, Pattern:>TypeP[], Size->Line]
			],
			"Object(s)"->Adder[
				Widget[Type->Object, Pattern:>ObjectP[Object[]]]
			]
		],
		Category->"Triggering Conditions"
	},
	{
		OptionName->TrackedFields,
		Default->Automatic,
		Description->"When Trigger is set, specify one or more fields in the tracked type(s)/object(s) which should trigger this computation.",
		ResolutionDescription->"Defaults to All if Trigger is set, and Null otherwise.",
		AllowNull->True,
		Widget->Adder[
			Adder[Widget[Type->Expression, Pattern:>_Symbol, Size->Word, PatternTooltip->"One or more fields in the tracked object(s) and/or type(s)."]]
		],
		Category->"Triggering Conditions"
	}
}];

(** Options which set job parameters related to code execution**)
DefineOptionSet[computationParameterOptions :> {
	ComputationKernelOptions,
	{
		OptionName->MaximumRunTime,
		Default->(24 Hour),
		Description->"If computing on the cloud, the maximum amount of time computation will be allowed to run for.",
		AllowNull->False,
		Widget->Widget[Type->Quantity,Pattern:>GreaterP[0.0 Minute],Units->Alternatives[Minute,Hour,Day]],
		Category->"Manifold Parameters"
	},
	{
		OptionName->EstimatedRunTime,
		Default->Automatic,
		Description->"The estimated amount of time that this computation will take to complete.",
		ResolutionDescription->"Defaults to the MaximumRunTime if not specified.",
		AllowNull->False,
		Widget->Widget[Type->Quantity,Pattern:>GreaterP[0.0 Minute],Units->Alternatives[Minute,Hour,Day]],
		Category->"Manifold Parameters"
	},
	{
		OptionName->MaximumThreads,
		Default->1,
		Description->"Specify the maximum number of computational thread that this job can use.",
		AllowNull->False,
		Widget->Widget[Type->Number,Pattern:>GreaterP[0,1]],
		Category->"General"
	}
}];

(* Options which determine how the computation will get executed *)
DefineOptionSet[ComputationExecutionOptions :> {
	{
		OptionName->Computation,
		Default->Cloud,
		Description->"Specify if the expressions within Compute should be evaluated in the current Notebook or on the cloud.",
		AllowNull->False,
		Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Notebook,Cloud]],
		Category->"General"
	},
	{
		OptionName->WaitForComputation,
		Default->Automatic,
		Description->"Specify if the evaluation should halt until the current computation has completed, or if the computation should be run asynchronously.",
		ResolutionDescription->"Defaults to True if computation is Local, and False if computation is on the cloud.",
		AllowNull->False,
		Widget->Widget[Type->Enumeration,Pattern:>Alternatives[True,False]],
		Category->"General"
	}
}];


(* Set the HoldFirst attribute so raw expressions can be passed *)
SetAttributes[Compute,HoldFirst];

(* Option Definitions *)
DefineOptions[Compute,
	Options:>{
		ComputationExecutionOptions,
		computationParameterOptions,
		scheduledOptions,
		triggeredComputationOptions,
		{
			OptionName->DestinationNotebook,
			Default->Automatic,
			Description->"The notebook in which all Computation pages spawned from the job will be deposited.",
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[Object[LaboratoryNotebook]]],
			Category->"Organizational Information"
		},
		{
			OptionName->DestinationNotebookNamingFunction,
			Default->Automatic,
			Description->"A pure function to generate the names of the new computation notebook pages spawned from this job.",
			AllowNull->True,
			Widget->Widget[Type->Expression,Pattern:>_Function,Size->Line],
			Category->"Organizational Information"
		},
		UploadOption,
		NameOption
	}
];

developerOptions[] := {
	ZDriveFilePaths,
	SLLVersion,
	SLLCommit,
	SLLPackage,
	RunAsUser,
	FargateCluster,
	DisablePaclets,
	MathematicaVersion,
	Environment
};


(* ::Subsection::Closed:: *)
(*Main Function Body*)

(* Primary overload handles all inputs *)
Compute[computeInput_, ops:OptionsPattern[Compute]]:=Module[
	{
		originalOps,publicOps,safeOps,expandedOps,notebookInputQ,resolvedOps,
		notebookCloudFile,developerKeys,
		developerOps,jobPacket,uploadResult, notebook,
		notebookCloudFilePath, userNotebooks, defaultNotebooks,
		assetFile, validLengths, cloudFileInputQ, realAssetFile
	},

	developerKeys = developerOptions[];

	(* Convert the options to a list *)
	originalOps=ToList[ops];

	(* Drop developer-only options for now *)
	publicOps=Normal@KeyDrop[originalOps,
		developerKeys
	];

	developerOps=Normal@KeyTake[originalOps,
		developerKeys
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	validLengths=Quiet[
		ValidInputLengthsQ[Compute,{{"Dummy"}},originalOps],
		{Warning::IndexMatchingOptionMissing}
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[$Failed]
	];

	(* Enforce options patterns and set unspecified options to defaults *)
	safeOps=SafeOptions[Compute,publicOps,AutoCorrect->False];

	(* Return $Failed if options could not be defaulted *)
	If[MatchQ[safeOps,$Failed],
		Return[$Failed]
	];

	(* Expand index-matched options *)
	expandedOps=Last[ExpandIndexMatchedInputs[Compute,{{"Dummy"}},safeOps]];

	(* True if the input was a notebook page, False otherwise *)
	notebookInputQ=MatchQ[Hold[computeInput],Hold[Object[Notebook,Page,_String]]];

	(* True if the input was a cloud file, False otherwise *)
	cloudFileInputQ = MatchQ[Hold[computeInput],Hold[Object[EmeraldCloudFile, _String]]];

	(* Resolve options and throw any warnings or errors if needed *)
	(* also return resolved notebooks and asset file if the input is a notebook, which are used later *)
	(* computeInput needs to be held because it can be an expression (e.g. ManinfoldRunUnitTest[AnalyzePeaks]) that we do not want to evaluate early *)
	{resolvedOps, userNotebooks, defaultNotebooks, assetFile} = resolveOptionsDownload[expandedOps,originalOps,notebookInputQ, Hold[computeInput]];

	(* if the input is an Object[EmeraldCloudFile], assume it's meant to be the template file and use it as the assetFile. *)
	realAssetFile = If[cloudFileInputQ,
		computeInput,
		assetFile
	];

	(* Early fail state if option resolution could not be completed *)
	If[MatchQ[resolvedOps,$Failed],
		Return[$Failed];
	];

	(* Short-circuit: If Computation->Local, then just release the held expression *)
	If[MatchQ[Lookup[resolvedOps,Computation],Notebook]&&!notebookInputQ,
		Return@TimeConstrained[
			computeInput,
			Unitless[Lookup[resolvedOps,MaximumRunTime],Second]
		]
	];

	(* If the input is an expression, convert it to a notebook and upload as a cloud file. *)
	(* If the input is a notebook, just get the object reference for its AssetFile *)
	{notebookCloudFile, notebookCloudFilePath} = If[notebookInputQ || cloudFileInputQ,
		{ realAssetFile, Null },
		(* this returns both *)
		convertExpressionToNotebook[computeInput,Lookup[resolvedOps,Upload]]
	];

	(*
		store the input in a variable to pass to the job formatting helper if the input is
		a notebook page
	*)
	notebook = If[notebookInputQ, computeInput, Null];

	(* Format the Object[Notebook,Job] packet *)
	jobPacket=formatJobPacket[resolvedOps, notebookCloudFile, notebook, notebookCloudFilePath, userNotebooks, defaultNotebooks];

	(* Upload the job packet if requested *)
	uploadResult=If[Lookup[resolvedOps,Upload],
		Upload[jobPacket],
		jobPacket
	];

	(* TODO: How to handle waiting for computation to finish *)
	If[Lookup[resolvedOps,WaitForComputation]&&Lookup[resolvedOps,Upload],
		PrintTemporary["Waiting for computation "<>ToString[uploadResult]<>" to finish..."];
	];

	(* Return the uploaded result *)
	uploadResult
];



(* ::Subsection::Closed:: *)
(*Option Resolver*)

resolveDeveloperOnlyOptions[originalOps_] := Module[{superUserQ, userSetDevOps, resolvedCluster, developerOps},
	(* True if the current user has superuser privileges *)
	superUserQ=MatchQ[$PersonID,ObjectP[Object[User,Emerald]]];

	(* Select all developer-only options that were specified *)
	userSetDevOps=Select[originalOps,
		MatchQ[
			First[#],
			Alternatives@@developerOptions[]
		]&
	];

	(* Warn user that these options cannot be set unless you are a developer *)
	If[!superUserQ&&Length[userSetDevOps]>0,
		Message[Warning::DeveloperOnlyOptions,First/@userSetDevOps];
	];

	(* If ZDrive paths were set but the cluster wasn't, default the cluster to develop *)
	resolvedCluster=Lookup[userSetDevOps,FargateCluster,Null]/.{
		(* If the cluster wasn't set, default it to the developer cluster based on $PersonID *)
		(* If someone tries to spoof their $PersonID, Constellation will reject the job upload *)
		Null->If[superUserQ, "manifold-mm-cluster", Null]
	};

	(* Developer only options. Empty list (resolves to defaults) if user does not have permissions. *)
	developerOps=If[superUserQ,
		ReplaceRule[userSetDevOps,{FargateCluster->resolvedCluster, SLLPackage->Lookup[userSetDevOps,SLLPackage,Developer]}],
		{}
	];
	developerOps
];

resolveOptionsDownload[safeOps_,originalOps_,notebookQ_, Hold[computeInput_]]:=Module[
	{
		cloudOnlyOps,localQ,waitQ,originalCloudOps,fieldsToCheck,
		resolvedMaxTime,resolvedEstimatedTime,computationOps,
		requestedJobTypes,resolvedJobType,validFields,typesToCheck,typesForMessage,
		triggerOption,trackedFieldsOption,resolvedTrackedFields,
		resolvedTrackedTypes,resolvedTypeFields,userTeams,devTeam,
		resolvedNotebook,resolvedNotebookPageName,notebookDropOps,
		resolvedTrackedObjects,resolvedObjectFields,jobOps,resolvedFinancingTeam,
		name,destinationNotebook,destinationNotebookNamingFunction,
		scheduleOption,repeatOption,pastDates,listedRepeats,resolvedSchedule,resolvedRepeats,
		superUserQ,userSetDevOps,resolvedCluster,developerOps, 
		userNotebooks, defaultNotebooks, failOutput, assetFile, sandboxQ

	},

	(* 
		using symbol because the size of the return has changed a few times, 
		and it appears many times in this function
	*)
	failOutput = {$Failed, $Failed, $Failed, $Failed};

	(* List of options which are only supported on the cloud *)
	cloudOnlyOps={
		Schedule,
		RepeatFrequency,
		Trigger,
		TrackedFields,
		HardwareConfiguration,
		EstimatedRunTime,
		MaximumThreads,
		ZDriveFilePaths,
		DisablePaclets,
		MathematicaVersion,
		SLLVersion,
		SLLCommit,
		SLLPackage,
		RunAsUser,
		FargateCluster,
		Environment
	};

	(* True if we are supposed to compute locally *)
	localQ=MatchQ[Lookup[safeOps,Computation],Notebook];

	(* True if we should wait for the computation to evaluate *)
	waitQ=Lookup[safeOps,WaitForComputation]/.{
		(* Automatic defaults to True if computing locally, and false otherwise *)
		Automatic->localQ
	};

	(* Any cloud-only options specified explicitly by the user *)
	originalCloudOps=Select[originalOps,MemberQ[cloudOnlyOps,First[#]]&];

	(* Warn the user if Computation->Notebook and options other than MaximumRunTime are set, since they won't do anything *)
	If[localQ&&Length[originalCloudOps]>0,
		Message[Error::CloudOnlyOptions,originalCloudOps];
		Return[failOutput]
	];


	(*** Run-Time parameter evaluation ***)

	(* The maximum run time of this computation *)
	resolvedMaxTime=Lookup[safeOps,MaximumRunTime];

	If[!localQ&&resolvedMaxTime<(10.0 Minute),
    Message[Error::MaximumTimeTooSmall,resolvedMaxTime];
		Return[failOutput];
	];

	(* The estimated run time will default to the maximum run time if not specified *)
	resolvedEstimatedTime=Lookup[safeOps,EstimatedRunTime]/.{
		Automatic->resolvedMaxTime
	};

	(* Error state if the maximum run time limit is exceeded *)
	If[resolvedMaxTime>$ManifoldMaximumComputationTime,
		Message[Error::MaximumTimeExceeded,resolvedMaxTime,$ManifoldMaximumComputationTime];
		Return[failOutput]
	];

	(* Error state if the estimated run time exceeds the maximum run time *)
	If[resolvedEstimatedTime>resolvedMaxTime,
		Message[Error::EstimatedTimeExceedsMaximum,resolvedEstimatedTime,resolvedMaxTime];
		Return[failOutput]
	];

	(* Options related to run time*)
	computationOps={
		MaximumRunTime->resolvedMaxTime,
		EstimatedRunTime->resolvedEstimatedTime
	};

	(*** Check developer-only options ***)

	developerOps = resolveDeveloperOnlyOptions[originalOps];

	(*** Run-Time parameter evaluation ***)

	(* Job types requested inferred from options *)
	requestedJobTypes={
		If[MatchQ[Lookup[safeOps,Schedule],Except[None|{None..}]]||MatchQ[Lookup[safeOps,RepeatFrequency],Except[None|{None..}]], Scheduled, Nothing],
		If[MatchQ[Lookup[safeOps,Trigger],Except[None]], Triggered, Nothing]
	};

	(* Resolve the job type. If none of the above are set, then default to OneTime *)
	resolvedJobType=If[MatchQ[requestedJobTypes,{}],
		{OneTime},
		requestedJobTypes
	];

	(* Lookup the trigger option and tracked fields options *)
	{triggerOption,trackedFieldsOption}=Lookup[safeOps,{Trigger,TrackedFields}];

	(* Resolve the tracked fields option *)
	resolvedTrackedFields=trackedFieldsOption/.{
		Automatic->If[!MatchQ[triggerOption,None],
			Repeat[All,Length[triggerOption]],
			Null
		]
	};

	(* Warn user that triggering fields will be unused if Trigger is set to None *)
	If[MatchQ[triggerOption,None|{}]&&!MatchQ[resolvedTrackedFields,Null],
		Message[Warning::NoTrigger];
	];

	(* Resolve tracked types *)
	resolvedTrackedTypes=If[MatchQ[triggerOption,{TypeP[]..}],
		triggerOption,
		Null
	];

	(* Resolve fields associated with those types *)
	resolvedTypeFields=If[!MatchQ[resolvedTrackedTypes,Null]&&!MatchQ[resolvedTrackedFields,Null],
		Replace[resolvedTrackedFields,All->{All},1],
		Null
	];

	(* Resolve tracked objects *)
	resolvedTrackedObjects=If[MatchQ[triggerOption,{ObjectP[]..}],
		triggerOption,
		Null
	];

	(* Error if not all of the objects are members of the database *)
	If[!(And@@(DatabaseMemberQ/@resolvedTrackedObjects)),
		Message[Error::ObjectNotFound,Select[resolvedTrackedObjects,!DatabaseMemberQ[#]&]];
		Return[failOutput]
	];

	(* Resolve fields associated with those types *)
	resolvedObjectFields=If[!MatchQ[resolvedTrackedObjects,Null]&&!MatchQ[resolvedTrackedFields,Null],
		Replace[resolvedTrackedFields,All->{All},1],
		Null
	];

	(* Get types to check *)
	typesToCheck=If[!MatchQ[resolvedObjectFields,Null],
		Download[resolvedTrackedObjects,Type],
		resolvedTrackedTypes
	];

	(* Types for output message *)
	typesForMessage=If[!MatchQ[resolvedObjectFields,Null],
		resolvedTrackedObjects,
		resolvedTrackedTypes
	];

	(* Get fields to check *)
	fieldsToCheck=If[!MatchQ[resolvedObjectFields,Null],
		resolvedObjectFields,
		resolvedTypeFields
	];

	(* Check that the fields corresponding to each tracked type are the right length, and that index matched fields are valid fields *)
	validFields=Which[
		(* True if the validFields option is not used *)
		MatchQ[fieldsToCheck,Null],
			{True},
		(* Check for invalid index-matching *)
		Length[typesToCheck]!=Length[fieldsToCheck],
			Message[Error::InvalidTrackedFieldsLength,Length[typesForMessage],Length[fieldsToCheck]];
			Return[failOutput],
		(* Make sure fields are either All or valid fields of that type *)
		True,
			MapThread[
				Function[{type,fields},
					Or[
						MatchQ[fields,{All}],
						MatchQ[type[#]&/@fields,{FieldP[type]..}]
					]
				],
				{typesToCheck,fieldsToCheck}
			]
	];

	(* Error message if tracked type fields are inactive *)
	If[!(And@@validFields),
		Message[Error::InvalidTrackedFields,
			MapThread[
				Function[{type,fields},
					Select[fields,!MatchQ[type[#],FieldP[type]]&]
				],
				{PickList[typesToCheck,Not/@validFields],PickList[fieldsToCheck,Not/@validFields]}
			],
			PickList[typesForMessage,Not/@validFields]
		];
		Return[failOutput]
	];

	(* Lookup the trigger option and tracked fields options *)
	{scheduleOption,repeatOption}=Lookup[safeOps,{Schedule,RepeatFrequency}];

	(* Any provided schedules which are in the past *)
	pastDates=Cases[scheduleOption, _DateObject?(#<(Now-10Second)&), 1];

	(* Error if any scheduled dates are in the past *)
	If[Length[pastDates] > 0,
		Message[Error::ScheduledDateInPast, pastDates, Now];
		Return[failOutput]
	];

	(* Cannot use Multiple RepeatFrequency options if Schedule is None  *)
	If[MatchQ[scheduleOption,None|{None..}]&&MatchQ[repeatOption,_List?(Length[#]>=2&)],
		Message[Error::InvalidRepeat,repeatOption];
		Return[failOutput]
	];

	(* Schedule should not contain more than one None *)
	If[!MatchQ[scheduleOption,None|{None}]&&MemberQ[scheduleOption,None],
		Message[Error::InvalidSchedule,scheduleOption];
		Return[failOutput]
	];

	(* Listed repeat option for error checking *)
	listedRepeats=ToList[repeatOption]/.{None->Nothing};

	(* Error if the smallest repeat frequency is less than the maximum run time *)
	If[(Length[listedRepeats]>=1)&&(Min[listedRepeats]<resolvedMaxTime||Min[listedRepeats]<(10 Minute)),
		Message[Error::RepeatFrequencyTooSmall,Min[listedRepeats],resolvedMaxTime];
		Return[failOutput]
	];

	(* Resolve the schedule option *)
	resolvedSchedule=ToList[scheduleOption]/.{None->Now};
	resolvedRepeats=ToList[repeatOption]/.{{None..}->Null};

	(* List of financing teams that the RunAsUser belongs to *)
	{{userTeams, userNotebooks, defaultNotebooks},{devTeam}, {assetFile}}=Quiet@Download[
		{
			Download[Lookup[developerOps, RunAsUser, $PersonID], Object],
			Object[Team,Financing,"Development"],
			(* if the input is a notebook, download off of it, otherwise use $Failed so that Download still evaluates *)
			If[notebookQ, computeInput, $Failed]
		},
		{
			{FinancingTeams[Object], FinancingTeams[Notebooks][Object], FinancingTeams[DefaultNotebook][Object]},
			{Object},
			{AssetFile[Object]}
		}
	];

	(* Resolve the financing team which should run computations created by this job *)
	resolvedFinancingTeam=If[MemberQ[userTeams,devTeam],
		devTeam,
		FirstOrDefault[userTeams]
	];

	(* Grab out notebook options detailing where computations will be stored *)
	{name,destinationNotebook,destinationNotebookNamingFunction}=Lookup[safeOps,{Name,DestinationNotebook,DestinationNotebookNamingFunction}];

	(* Determine DestinationNotebook based on DestinationNotebookNamingFunction *)
	resolvedNotebook=Which[
		(* Use specified *)
		MatchQ[destinationNotebook,ObjectP[]],destinationNotebook,

		(* Automatic case, use the notebook we're currently in if unspecified - but user gave us page names *)
		MatchQ[destinationNotebookNamingFunction,_String],$Notebook,

		(* Don't use this feature if not requested since it could make tons of unexpected pages *)
		True,Null
	];

	(* Use the notebook we're currently in if unspecified *)
	resolvedNotebookPageName=Which[
		(* Use specified *)
		MatchQ[destinationNotebookNamingFunction,_Function],destinationNotebookNamingFunction,

		(* Automatic, set to append time to Name, or give generic name *)
		(* Note this will go in the DisplayName of the Object[Notebook, Page] and doesn't have to be unique *)
		MatchQ[destinationNotebook,ObjectP[]],Function[If[MatchQ[name,Null],"Compute Job ",name<>" "]<>StringReplace[DateString[],":"->"_"]],

		(* Not using this feature *)
		True,Null
	];

	notebookDropOps={
		DestinationNotebook->resolvedNotebook,
		DestinationNotebookNamingFunction->resolvedNotebookPageName
	};

	(* Options related to job scheduling *)
	jobOps={
		WaitForComputation->waitQ,
		JobType->resolvedJobType,
		TrackedFields->resolvedTrackedFields,
		Schedule->resolvedSchedule,
		RepeatFrequency->resolvedRepeats,

		(* Bundle in output packet values as well. *)
		ComputationFinancingTeam->resolvedFinancingTeam,
		ScheduledStartDates->resolvedSchedule,
		ComputationFrequency->resolvedRepeats/.{None->Null},
		TrackedTypeChanges->resolvedTrackedTypes,
		TrackedTypeFieldChanges->resolvedTypeFields,
		TrackedObjectChanges->Download[resolvedTrackedObjects,Object],
		TrackedObjectFieldChanges->resolvedObjectFields
	};

	(*
		True if we are supposed if the computation ought to run in
	 	a local development environment.
	 *)
	sandboxQ=MatchQ[Lookup[developerOps,Environment], Sandbox];

	(* There are additional restrictions associated within the Sandbox Environment *)
	If[TrueQ[sandboxQ] && !MatchQ[resolvedRepeats, Null],
		Message[Error::RepeatNotAllowed];
		Return[failOutput]
	];

	If[TrueQ[sandboxQ] && ProductionQ[],
		Message[Error::ProductionDatabase];
		Return[failOutput]
	];

	If[TrueQ[sandboxQ] && !MatchQ[triggerOption,None|{}],
		Message[Error::TriggerNotAllowed];
		Return[failOutput]
	];

	If[TrueQ[sandboxQ] && Length[Lookup[developerOps, ZDriveFilePaths, {}]] > 0,
		Message[Error::ZDriveNotAllowed];
		Return[failOutput]
	];

	(* Return the resolved options *)
	{
		ReplaceRule[safeOps,
			Join[
				jobOps,
				computationOps,
				developerOps,
				notebookDropOps
			]
		],
		(* also returning these two things as they are needed later *)
		userNotebooks, 
		defaultNotebooks,
		assetFile
	}
];



(* ::Subsection::Closed:: *)
(*Helper Functions*)


(* ::Subsubsection::Closed:: *)
(*convertExpressionToNotebook*)

(* Convert a held expression into a notebook *)
SetAttributes[convertExpressionToNotebook,HoldFirst];
convertExpressionToNotebook[genericExpression_, uploadOption:True|False]:=Module[
	{convertedNotebook,notebookObject, templateNotebookFileName},

	If[Not[ValidComputationQ[genericExpression]],
		Return[{$Failed, $Failed}];
	];

	templateNotebookFileName=FileNameJoin[{$TemporaryDirectory,CreateUUID[]<>".nb"}];

	(* Convert the expression to a notebook *)
	convertedNotebook=Scripts`Private`splitExpressionToNotebook[genericExpression];

	UsingFrontEnd[NotebookSave[convertedNotebook,templateNotebookFileName]];
	
	notebookObject = Block[{$DisableVerbosePrinting = True},
		(* 
			Blocking $DisableVerbosePrinting is a hack equivalent to passing 
			the ConstealltionMessages->{} option to Upload 
		*)
		UploadCloudFile[templateNotebookFileName,Upload->uploadOption]
	];

	(* Close the local converted notebook *)
	UsingFrontEnd[NotebookClose[convertedNotebook]];

	(* Return the notebook object *)
	{notebookObject, templateNotebookFileName}
];



(* ::Subsubsection::Closed:: *)
(*makeBlankNotebook*)

makeBlankNotebook[]:=makeBlankNotebook[Null];
(* Create a blank notebook object *)
makeBlankNotebook[ownerNotebook:(ObjectP[Object[LaboratoryNotebook]]|Null)] := Module[
	{emptyNotebookFile, emptyNotebook},

	(* Make a temporary unique file path and export a blank notebook. *)
	emptyNotebookFile=Export[FileNameJoin[{$TemporaryDirectory,CreateUUID[]<>".nb"}]," "];

	(* Open our blank notebook. *)
	emptyNotebook=UsingFrontEnd[NotebookOpen[emptyNotebookFile,Visible->False]];

	(* Delete any cells in the notebook. Creating a notebook sometimes makes a blank cell we don't want. *)
	UsingFrontEnd[NotebookDelete[Cells[emptyNotebook]]];

	(* Save and close the notebook *)
	UsingFrontEnd[NotebookSave[emptyNotebook,emptyNotebookFile]];
	UsingFrontEnd[NotebookClose[emptyNotebook]];

	(* Upload the notebook as a cloud file and return it as an object reference *)
	UploadCloudFile[emptyNotebookFile, Notebook -> ownerNotebook]
];


(* ::Subsubsection::Closed:: *)
(*formatJobPacket*)

(* Given resolved options, template notebook, and Manifold m file, prepare a Object[Notebook,Job] packet *)
formatJobPacket[resolvedOps_, template_, notebook_, notebookCloudFilePath_, userNotebooks_, defaultNotebooks_]:=Module[
	{
		resolvedJobType,templateNotebookFile,templateNotebook,sectionsJSON,packetStart,triggerFields,
		validLabNotebooks,resolvedNotebook, userObj
	},

	(* Resolved job type from the option resolver *)
	resolvedJobType=Lookup[resolvedOps,JobType];

	userObj = Lookup[resolvedOps,RunAsUser] /. Null -> $PersonID;

	(* Download the notebook cloud files to local disc *)
	templateNotebookFile = If[notebookCloudFilePath === Null ,
		DownloadCloudFile[template,FileNameJoin[{$TemporaryDirectory,CreateUUID[]}]],
		notebookCloudFilePath
	];

	(* Open the notebook object *)
	templateNotebook=UsingFrontEnd[NotebookOpen[templateNotebookFile]];

	(* Parse the notebook to generate a sections JSON *)
	sectionsJSON=Quiet[UsingFrontEnd[ParseNotebookNew[templateNotebook]]];

	(* List of laboratory notebooks the RunAsUser has access to. Only evaluates if the RunAsUser is NOT a superuser *)
	validLabNotebooks=Flatten[userNotebooks];

	(* Assign a notebook to the job. If it's the default *)
	resolvedNotebook=Which[
		(* Use the current notebook if the RunAsUser has access to it *)
		MemberQ[validLabNotebooks, $Notebook],
		Link[$Notebook, Objects],
		(* Otherwise, use the default notebook for the RunAsUser *)
		True,
		Link[
			FirstOrDefault@defaultNotebooks,
			Objects
		]
	];

	(* Close the notebook *)
	UsingFrontEnd[NotebookClose[templateNotebook]];

	(* Populate all fields except the scheduling fields *)
	packetStart=<|
		(* Type Definition and assets *)
		Type->Object[Notebook,Job],
		Author->Link[$PersonID],
		Name->Lookup[resolvedOps,Name],
		Notebook->resolvedNotebook,
		Replace[JobType]->resolvedJobType,
		Status->Active,
		ComputationFinancingTeam->Link[Lookup[resolvedOps,ComputationFinancingTeam], ManifoldJobs],
		If[MatchQ[notebook, Null],
			TemplateNotebookFile -> Link[template],
			TemplateNotebook -> Link[notebook, ManifoldJobs]
		],
		TemplateSectionsJSON->ExportString[
			StringReplace[
				sectionsJSON,
				Alternatives@@AppHelpers`Private`$SpecialCharacters:>""
			],
			"Base64"
		],

		(* Manifold job triggering fields *)
		Replace[ScheduledStartDates]->{},
		Replace[ComputationFrequency]->{},
		Replace[TrackedTypeChanges]->{},
		Replace[TrackedTypeFieldChanges]->{},
		Replace[TrackedObjectChanges]->{},
		Replace[TrackedObjectFieldChanges]->{},

		(* Notebook-linking fields *)
		DestinationNotebook->Link[Lookup[resolvedOps,DestinationNotebook]],
		DestinationNotebookNamingFunction->Lookup[resolvedOps,DestinationNotebookNamingFunction],

		(* other Manifold fields *)
		HardwareConfiguration->Lookup[resolvedOps,HardwareConfiguration],
		EstimatedRunTime->Lookup[resolvedOps,EstimatedRunTime],
		MaximumRunTime->Lookup[resolvedOps,MaximumRunTime],
		MaximumThreads->Lookup[resolvedOps,MaximumThreads],

		(* AdminWriteOnly fields *)
		Sequence@@(
			{
				Replace[ZDriveFilePaths]->Lookup[resolvedOps,ZDriveFilePaths],
				SLLVersion->Lookup[resolvedOps,SLLVersion],
				SLLCommit->Lookup[resolvedOps,SLLCommit],
				SLLPackage->Lookup[resolvedOps,SLLPackage],
				RunAsUser->Link[Download[Lookup[resolvedOps,RunAsUser],Object]],
				FargateCluster->Lookup[resolvedOps,FargateCluster],
				DisablePaclets->Lookup[resolvedOps,DisablePaclets],
				MathematicaVersion->Lookup[resolvedOps,MathematicaVersion]
			}/.{
				(* Any Null or empty list uploads should be removed from the sequence *)
				Rule[_,Null|{}]->Nothing
			}
		),

		(* Metadata *)
		Archive->False,
		OriginalSLLCommit->getOriginalSLLCommit[],

		(* Sandbox *)
		Environment -> Lookup[resolvedOps, Environment]
	|>;

	(* Resolve the triggering fields based on the job type *)
	triggerFields=Association@@Map[
		Sequence@@Switch[#,
			Scheduled,
				{
					Replace[ScheduledStartDates]->Lookup[resolvedOps,ScheduledStartDates],
					Replace[ComputationFrequency]->Lookup[resolvedOps,ComputationFrequency]
				},
			Triggered,
				{
					Replace[TrackedTypeChanges]->Lookup[resolvedOps,TrackedTypeChanges],
					Replace[TrackedTypeFieldChanges]->Lookup[resolvedOps,TrackedTypeFieldChanges],
					Replace[TrackedObjectChanges]->Lookup[resolvedOps,TrackedObjectChanges]/.{o:ObjectReferenceP[]:>Link[o]},
					Replace[TrackedObjectFieldChanges]->Lookup[resolvedOps,TrackedObjectFieldChanges]
				},
			OneTime|_,
				{}
		]&,
		resolvedJobType
	];

	(* Join the two parts of the packet together *)
	Join[packetStart,triggerFields]
];
getOriginalSLLCommit[] := If[MatchQ[$Distro,ObjectP[Object[Software,Distro]]],
	Download[$Distro,Commit],
	Quiet[GitCommitHash[$EmeraldPath]]/.{$Failed->Null}
];
(* ::Subsubsection::Closed:: *)
(*enqueueOneTimeComputation*)

(* Helper function for unit testing *)
enqueueOneTimeComputation[job:ObjectP[Object[Notebook,Job]]]:=Module[
	{jobObj,financeTeamID,name},

	(* Object reference for the input job *)
	{jobObj,financeTeamID,name}=Download[job,{Object,ComputationFinancingTeam[Object],Name}];

	(* Upload a new computation object *)
	Upload[{
		<|Object->jobObj, Status->Inactive|>,
		<|
			Type->Object[Notebook,Computation],
			Name->name,
			Status->Queued,
			DateEnqueued->Now,
			Job->Link[jobObj,Computations],
			ComputationFinancingTeam->Link[financeTeamID,ComputationQueue]
		|>
	}]
];



(* ::Section::Closed:: *)
(*ValidComputationQ*)


(* ::Subsection::Closed:: *)
(*Messages*)


(* ::Subsection::Closed:: *)
(*Options*)


(* Set the HoldFirst attribute so raw expressions can be passed *)
SetAttributes[ValidComputationQ,HoldFirst];

(* Option Definitions *)
DefineOptions[ValidComputationQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	}
];


(* ::Subsection::Closed:: *)
(*Main Function Body*)

(* This performs a subset of the checks of ValidExperimentScriptQ *)
ValidComputationQ[expr_,ops:OptionsPattern[ValidComputationQ]]:=Module[
	{safeOps,verbose,outputFormat,computationNotebook,result},

	(* Get options indicating what to return *)
	safeOps=SafeOptions[ValidComputationQ,ToList[ops]];
	{verbose,outputFormat}=Lookup[safeOps,{Verbose,OutputFormat}];

	(*
		Do fast simple check -- does expression contain "Experiment" in it?
		If not, computation is fine.
		If yes, proceed with stricter check to see if it's an actual experiment call
	*)
	If[
		StringFreeQ[ToString[HoldComplete[expr],InputForm], "Experiment"] && MatchQ[outputFormat, Boolean],
		Return[True]
	];


	(*  Convert our raw script code to a mathematica notebook. *)
	(* Note: Our JSON function will insert red error cells in the given NotebookObject[...] but we're going to throw away the notebook so we don't care. *)
	computationNotebook=Scripts`Private`splitExpressionToNotebook[expr];

	(* Check validity *)
	result=If[MatchQ[outputFormat,TestSummary]||MatchQ[verbose,True|Failures],
		Module[{tests},
			(* Get a list of tests to run *)
			tests=ValidComputationQJSON[
				computationNotebook,
				Output->Tests
			];

			(* Run the tests and return the result in the requested format *)
			Lookup[
				RunUnitTest[
					<|"ValidComputationQ"->tests|>,
					Verbose->verbose,
					OutputFormat->outputFormat
				],
				"ValidComputationQ"
			]
		],
		(* Otherwise, throw messages and return a boolean *)
		ValidComputationQJSON[
			computationNotebook,
			Messages->True
		]
	];

	(* Close the notebook before we return our result. *)
	UsingFrontEnd[NotebookClose[computationNotebook]];

	(* Return our result. *)
	result
];


(* ::Subsubsubsection::Closed:: *)
(*ValidComputationQJSON*)


(* Frontend gives us a NotebookObject[...] of the Future (or Template when initializing) notebook, we check it for nested statements with experiment functions. *)
DefineOptions[ValidComputationQJSON,
	Options :> {
		{Messages -> False, BooleanP, "Indicates if messages should be thrown in addition to highlighting cells."},
		{Output -> Result, ListableP[Result | Tests], "Indicates what the function should return."}
	}
];

Authors[ValidComputationQJSON]:={"kevin.hou", "platform"};
Warning::ExperimentCallInComputation="An experiment function call was detected inside of your computation. Unlike scripts, computations will not wait for protocols to finish executing in the laboratory before continuing to the next cell of the computation. If you want this functionality, please use a Script instead (you can enqueue a script inside of a computation job).";


(* Overload when there is no past notebook. *)
ValidComputationQJSON[myFutureNotebook_NotebookObject, ops:OptionsPattern[ValidComputationQJSON]]:=ValidComputationQJSON[myFutureNotebook, Null, ops];

(* Overload with a future and past notebook (which may be Null if the script hasn't started). *)
ValidComputationQJSON[myFutureNotebook_NotebookObject, myPastNotebook:(Null | _NotebookObject), ops:OptionsPattern[ValidComputationQJSON]]:=Module[
	{
		messages, output, gatherTests, rawCells, notebooks, cells, expressionCellQ, expressionCells,
		heldExpressions, allExperimentFunctions, experimentFunctionCallsPerCell,
		experimentFunctionSetsPerCell, computationCellsContainExperimentFunctionQ,
		experimentCallCells, experimentCallNotebooks, experimentTest
	},

	(* Determine if we're going to throw messages *)
	messages=OptionValue[Messages];

	(* Determine the return value of the function *)
	output=OptionValue[Output];

	(* Determine if we should make tests *)
	gatherTests=MemberQ[ToList[output], Tests];

	(* Get all of the cells in the future and past notebook (if one is given). *)
	(* These two variables are index matched so we know what notebook to write to in the case of an invalid error cell. *)
	{rawCells, notebooks}=If[MatchQ[myPastNotebook, Null],
		With[{futureNotebookCells=UsingFrontEnd[Cells[myFutureNotebook]]},
			{futureNotebookCells, ConstantArray[myFutureNotebook, Length[futureNotebookCells]]}
		],
		With[{futureNotebookCells=UsingFrontEnd[Cells[myFutureNotebook]], pastNotebookCells=UsingFrontEnd[Cells[myPastNotebook]]},
			{Join[futureNotebookCells, pastNotebookCells], Join[ConstantArray[myFutureNotebook, Length[futureNotebookCells]], ConstantArray[myPastNotebook, Length[pastNotebookCells]]]}
		]
	];
	cells=UsingFrontEnd[NotebookRead[rawCells]];

	(* Get all of the input or code cells in this notebook. *)
	(* These are the cells that we're going to run in the script. *)
	expressionCellQ=MatchQ[#, Cell[_, "Input" | "Code", ___]]& /@ cells;
	expressionCells=PickList[cells, expressionCellQ];

	(* Parse out the expression in these cells, put them in Hold[...] heads so they don't evaluate. *)
	heldExpressions=(ToExpression[First[#], StandardForm, Hold]&) /@ expressionCells;

	(* Get all of our experiment functions. Developers KEEP FORGETTING to put their experiment function in $CommandBuilderFunctions so do a namespace search instead to be totally foolproof. *)
	allExperimentFunctions = getAllExperimentFunctions[];

	(* For each expression cell, get all occurances of experiment function calls. *)
	(* Ex. {Verbatim[ExperimentHPLC][HoldPattern[mySamples]]} *)
	(* Note: The HoldPattern is important when we MemberQ down below because we don't want symbols to evaluate, otherwise they won't match in the heldExpression. *)
	experimentFunctionCallsPerCell=Cases[#, experimentCall:(function:(Alternatives @@ (Verbatim /@ allExperimentFunctions)))[inputs___] :> HoldPattern[function[inputs]], Infinity]& /@ heldExpressions;

	(* Make sure that if there are multiple experiment calls, they are within a Set or within the use of the Parallel head (or on a single condition of an If, Swithc, or Which). -- *)
	(* TODO: We are currently looking into a way to save the execution stack of a single MM cell if there are multiple experiment calls so this is no longer a restriction. Waiting for a response from Stephen Wolfram. *)
	experimentFunctionSetsPerCell=Cases[
		#,
		pattern:Alternatives[
			(* Single set. *)
			Verbatim[Set][_, ___, (Alternatives @@ (Verbatim /@ allExperimentFunctions))[___], ___],
			(* Multiple set, without a parallel head. *)
			Verbatim[Set][_, {___, (Alternatives @@ (Verbatim /@ allExperimentFunctions))[___], ___}],
			(* Parallel head, yanks it out of the set if it finds it in there. *)
			Verbatim[Parallel][___, (Alternatives @@ (Verbatim /@ allExperimentFunctions))[___], ___],
			(* If *)
			Verbatim[If][___, (Alternatives @@ (Verbatim /@ allExperimentFunctions))[___], ___],
			(* Switch *)
			Verbatim[Switch][___, (Alternatives @@ (Verbatim /@ allExperimentFunctions))[___], ___],
			(* Which *)
			Verbatim[Which][___, (Alternatives @@ (Verbatim /@ allExperimentFunctions))[___], ___]
		] :> Hold[pattern],
		Infinity
	]& /@ heldExpressions;

	(* In Manifold Computations, experiment function calls will not wait for completion unliked scripts. Warn the user about this. *)
	computationCellsContainExperimentFunctionQ=MapThread[
		Function[{functionCalls, functionSets},
			(* The cell is only valid if there are no experiment function calls or sets *)
			And[Length[functionCalls] == 0, Length[functionSets] == 0]
		],
		{experimentFunctionCallsPerCell, experimentFunctionSetsPerCell}
	];

	(* Get all of the expression cell pointers with problems. *)
	(* We want expression cells that are not valid *)
	{experimentCallCells, experimentCallNotebooks}={
		PickList[PickList[rawCells, expressionCellQ, True], computationCellsContainExperimentFunctionQ, False],
		PickList[PickList[notebooks, expressionCellQ, True], computationCellsContainExperimentFunctionQ, False]
	};

	(* Highlight the cells that are problematic in pink and put an error message after the cell. *)
	MapThread[
		(
			UsingFrontEnd[SetOptions[#1, Background -> Pink]];
			UsingFrontEnd[SelectionMove[#1, After, Cell]];
			UsingFrontEnd[NotebookWrite[
				#2,
				Cell["Warning: Unlike scripts, computations will not wait for protocols to finish executing in the laboratory before continuing to the next cell of the computation. If you want this functionality, please use a Script instead (you can enqueue a script inside of a computation job).", "Message", "MSG"]
			]];
		)&,
		{experimentCallCells, experimentCallNotebooks}
	];

	If[messages&&!MatchQ[experimentCallCells, {}],
		Message[Warning::ExperimentCallInComputation]
	];

	(* Create a test if we're returning tests. *)
	experimentTest=If[gatherTests,
		Warning["The computation contains no calls to experiment functions:", MatchQ[experimentCallCells, {}], True],
		Nothing
	];

	(* Return the requested outputs *)
	(* NOTE: Right now, there's no way to create an invalid computation so this is always True. *)
	output/.{
		Tests -> {experimentTest},
		Result -> True
	}
];


getAllExperimentFunctions[] := getAllExperimentFunctions[] = Module[
	{allExperimentSymbolNames, allExperimentFunctions},

	allExperimentSymbolNames=Names["ECL`Experiment*"];
	
	allExperimentFunctions=ToExpression /@ PickList[
		allExperimentSymbolNames,
		Map[
			(* These are the substrings that denote that something is NOT actually an experiment function. *)
			StringFreeQ[#, {"Valid", "Options", "Preview", "Experimentally", "ExperimentType", "ExperimentFile", "ExperimentFilePaths", "ExperimentScript"}]& ,
			allExperimentSymbolNames 
		]
	];

	allExperimentFunctions

];
