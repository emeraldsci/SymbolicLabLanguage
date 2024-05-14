(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*ConfirmProtocol*)


(* ::Subsubsection::Closed:: *)
(*ConfirmProtocol*)


(* Singleton Input Overload *)
ConfirmProtocol[myProtocol:ObjectP[ProtocolTypes[]]]:=Module[
	{coreOutput},

	(* Call core, listable overload *)
	coreOutput = ConfirmProtocol[{myProtocol}];

	(* If core function fails, return failure (a message will already be thrown).
	Otherwise, return the protocol without the list. *)
	If[MatchQ[coreOutput,$Failed],
		$Failed,
		First[coreOutput]
	]
];

(* Core Overload: Listed Input - Pass directly to UploadProtocolStatus to Enqueue *)
ConfirmProtocol[myProtocols:{ObjectP[ProtocolTypes[]]..}]:=UploadProtocolStatus[myProtocols,OperatorStart,Upload->True,FastTrack->False,UpdatedBy->$PersonID];



(* ::Subsection::Closed:: *)
(*CancelProtocol*)


(* ::Subsubsection::Closed:: *)
(*CancelProtocol*)


(* Singleton Input Overload *)
CancelProtocol[myProtocol:ObjectP[ProtocolTypes[]]]:=Module[
	{coreOutput},

	(* Call core, listable overload *)
	coreOutput = CancelProtocol[{myProtocol}];

	(* If core function fails, return failure (a message will already be thrown).
	Otherwise, return the protocol without the list. *)
	If[MatchQ[coreOutput,$Failed],
		$Failed,
		First[coreOutput]
	]
];

(* Core Overload: Listed Input - Pass directly to UploadProtocolStatus to Cancel *)
CancelProtocol[myProtocols:{ObjectP[ProtocolTypes[]]..}]:=UploadProtocolStatus[myProtocols,Canceled,Upload->True,FastTrack->False,UpdatedBy->$PersonID];



(* ::Subsection::Closed:: *)
(*UnconfirmProtocol*)


(* ::Subsubsection::Closed:: *)
(*UnconfirmProtocol*)


(* Singleton Input Overload *)
UnconfirmProtocol[myProtocol:ObjectP[ProtocolTypes[]]]:=Module[
	{coreOutput},

	(* Call core, listable overload *)
	coreOutput = UnconfirmProtocol[{myProtocol}];

	(* If core function fails, return failure (a message will already be thrown).
	Otherwise, return the protocol without the list. *)
	If[MatchQ[coreOutput,$Failed],
		$Failed,
		First[coreOutput]
	]
];

(* Core Overload: Listed Input - Pass directly to UploadProtocolStatus for putting back into InCart *)
UnconfirmProtocol[myProtocols:{ObjectP[ProtocolTypes[]]..}]:=UploadProtocolStatus[myProtocols,InCart,Upload->True,FastTrack->False,UpdatedBy->$PersonID];
