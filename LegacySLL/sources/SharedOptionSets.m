(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Shared Options*)


(* ::Subsubsection::Closed:: *)
(*VerboseOption*)


DefineOptionSet[
	VerboseOption :> {
		{
			OptionName->Verbose,
			Default->False,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[True,False,Failures]],
			Description->"Indicates if the result of all tests (True) or just failing tests (Failures) should be printed as the tests run."
		}
	}
];



(* ::Subsubsection::Closed:: *)
(*OutputFormatOption*)


DefineOptionSet[
	OutputFormatOption :> {
		{
			OptionName->OutputFormat,
			Default->Boolean,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Boolean,TestSummary]],
			Description->"Indicate how the test results should be returned."
		}
	}
];



(* ::Subsubsection::Closed:: *)
(*NameOption*)


DefineOptionSet[NameOption:>{
	{
		OptionName->Name,
		Default->Null,
		AllowNull->True,
		Widget->Widget[Type->String,Pattern:>_String,Size->Word],
		Description->"A object name which should be used to refer to the output object in lieu of an automatically generated ID number.",
		Category -> "Organizational Information"
	}
}];


(* ::Subsubsection::Closed:: *)
(*OutputOption*)


DefineOptionSet[
	OutputOption:>{
		{
			OptionName->Output,
			Default->Result,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>CommandBuilderOutputP],
				Adder[Widget[Type->Enumeration,Pattern:>CommandBuilderOutputP]]
			],
			Description->"Indicate what the function should return.",
			Category->"Hidden"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*DebugOption*)


DefineOptionSet[
	DebugOption :> {
		{
			OptionName->Debug,
			Default->False,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Description->"Indicates if the function will abstain from making any database changes, or emails/tasks being sent. If Debug -> True, there is no expectation that any output returned can be subsequently uploaded to the database to achieve the function's original goal.",
			Category->"Hidden"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*UploadOption*)


DefineOptionSet[
	UploadOption :> {
		{
			OptionName->Upload,
			Default->True,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Description->"Indicates if the database changes resulting from this function should be made immediately or if upload packets should be returned.",
			Category->"Hidden"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*CacheOptions*)


DefineOptionSet[
	CacheOption :> {
		{
			OptionName->Cache,
			Default->{},
			AllowNull->True,
			Pattern:>{(ObjectP[] | Null) ...},
			Description->"List of pre-downloaded packets to be used before checking for session cached object or downloading any object information from the server.",
			Category->"Hidden"
		}
}];

(* ::Subsubsection::Closed:: *)
(*SimulationOption*)


DefineOptionSet[
	SimulationOption :> {
		{
			OptionName->Simulation,
			Default->Null,
			AllowNull->True,
			Pattern:>Null|SimulationP,
			Description->"The Simulation that contains any simulated objects that should be used.",
			Category->"Hidden"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*FastTrackOption*)


DefineOptionSet[
	FastTrackOption :> {
		{
			OptionName->FastTrack,
			Default->False,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Description->"Indicates if validity checks on the provided input and options should be skipped for faster performance.",
			Category->"Hidden"
		}
}];


(* ::Subsubsection::Closed:: *)
(*ExportOption*)


DefineOptionSet[
	ExportOption :> {
		{
			OptionName->Export,
			Default->True,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Description->"Indicates if files should be exported to the local directory.",
			Category->"Hidden"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*OperatorOption*)


DefineOptionSet[
	OperatorOption :> {
		{
			OptionName->Operator,
			Default->Null,
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[User,Emerald],Model[User,Emerald]}],ObjectTypes->{Object[User,Emerald],Model[User,Emerald]}],
			Description->"Specifies the operator who may run this protocol. If Null, any operator may run this protocol.",
			Category->"Hidden"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*InterruptibleOption*)


DefineOptionSet[
	InterruptibleOption:>{
		{
			OptionName->Interruptible,
			Default->True,
			Description->"Indicates if this protocol can be temporarily put on hold while the operator of this protocol is assigned to another priority protocol.",
			AllowNull->True,
			Category->"Hidden",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*EmailOption*)


DefineOptionSet[
	EmailOption :> {
		{
			OptionName -> Email,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if emails should be sent for any notifications relevant to the function's output.",
			ResolutionDescription -> "Resolves to the same value as the Upload option if available; otherwise, resolves to True.",
			Category->"Hidden"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*HoldOrderOption*)


DefineOptionSet[HoldOrderOption:>{
	{
		OptionName->HoldOrder,
		Default->False,
		Description->"Indicates if the queue position of this protocol should be strictly enforced, regardless of the available resources in the lab.",
		AllowNull->False,
		Category->"Hidden",
		Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
	}
}];


(* ::Subsubsection::Closed:: *)
(*PriorityOption*)


DefineOptionSet[PriorityOption:>{
	{
		OptionName->Priority,
		Default->False,
		Description->"Indicates if (for an additional cost) this protocol will have first rights to shared lab resources before any standard protocols.",
		AllowNull->False,
		Category->"Hidden",
		Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
	}
}];


(* ::Subsubsection::Closed:: *)
(*StartDateOption*)


DefineOptionSet[StartDateOption:>{
	{
		OptionName->StartDate,
		Default->Null,
		Description->"The date at which the protocol will be targeted to start running in the lab. If StartDate->Null, the protocol will start as soon as possible.",
		AllowNull->True,
		Category->"Hidden",
		Widget->With[{now=Now},
			Widget[Type->Date,Pattern:>GreaterP[now],TimeSelector->True]
		]
	}
}];


(* ::Subsubsection::Closed:: *)
(*QueuePositionOption*)


DefineOptionSet[QueuePositionOption:>{
	{
		OptionName->QueuePosition,
		Default->Last,
		Description->"The position that this protocol will be inserted in the Financing Team's experiment queue.",
		AllowNull->False,
		Category->"Hidden",
		Widget->Alternatives[
			Widget[Type->Enumeration,Pattern:>Alternatives[First,Last]],
			Widget[Type->Number,Pattern:>GreaterP[0]]
		]
	}
}];
