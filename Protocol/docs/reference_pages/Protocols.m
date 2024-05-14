(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*ConfirmProtocol*)

DefineUsage[ConfirmProtocol,
{
	BasicDefinitions -> {
		{"ConfirmProtocol[protocol]","updatedProtocol", "directs the ECL to Confirm an InCart protocol to begin running in the lab as soon as possible."}
	},
	MoreInformation -> {
		"Protocols can be put back into the cart by calling UnconfirmProtocol."
	},
	Input :> {
		{"protocol",ObjectP[ProtocolTypes[]],"Protocol objects to be confirmed."}
	},
	Output :> {
		{"updatedProtocol",ObjectP[ProtocolTypes[]],"Protocols updated to reflect their confirming."}
	},
	Behaviors -> {
		"ReverseMapping"
	},
	SeeAlso -> {
		"CancelProtocol",
		"UnconfirmProtocol",
		"UploadProtocolStatus"
	},
	Author -> {"robert", "alou"}
}];

(* ::Subsubsection::Closed:: *)
(*CancelProtocol*)

DefineUsage[CancelProtocol,
{
	BasicDefinitions -> {
		{"CancelProtocol[protocol]","updatedProtocol", "directs the ECL to remove a protocol from the cart or backlog of protocols to be run."}
	},
	MoreInformation -> {
		"A protocol that has already been confirmed can no longer be canceled."
	},
	Input :> {
		{"protocol",ObjectP[ProtocolTypes[]],"Protocol objects to be canceled."}
	},
	Output :> {
		{"updatedProtocol",ObjectP[ProtocolTypes[]],"Protocols updated to reflect their cancellation."}
	},
	Behaviors -> {
		"ReverseMapping"
	},
	SeeAlso -> {
		"ConfirmProtocol",
		"UnconfirmProtocol",
		"UploadProtocolStatus"
	},
	Author -> {"robert", "alou"}
}];


(* ::Subsubsection::Closed:: *)
(*UnconfirmProtocol*)

DefineUsage[UnconfirmProtocol,
{
	BasicDefinitions -> {
		{"UnconfirmProtocol[protocol]","updatedProtocol", "directs the ECL to put a 'protocol' back into the cart from waiting to run."}
	},
	MoreInformation -> {
		"A protocol that has already started running in the lab cannot be unconfirmed."
	},
	Input :> {
		{"protocol",ObjectP[ProtocolTypes[]],"Protocol objects to be returned to the cart."}
	},
	Output :> {
		{"updatedProtocol",ObjectP[ProtocolTypes[]],"Protocols updated to reflect their revoking."}
	},
	Behaviors -> {
		"ReverseMapping"
	},
	SeeAlso -> {
		"ConfirmProtocol",
		"CancelProtocol",
		"UploadProtocolStatus"
	},
	Author -> {"robert", "alou"}
}];