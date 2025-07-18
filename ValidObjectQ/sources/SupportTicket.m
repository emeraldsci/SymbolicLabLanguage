(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *) 


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validSupportTicketQTests*)


validSupportTicketQTests[packet:PacketP[Object[SupportTicket]]]:={
	(* General fields filled in *)
	NotNullFieldTest[packet,
		{
			DateCreated,
			Headline
		}
	],
	(* If Resolved, DateResolved is informed *)
	Test[
		"If Status is Resolved, DateResolved is informed:",
		If[
			TrueQ[Lookup[packet, Resolved]],
			!NullQ[Lookup[packet, DateResolved]],
			True
		],
		True
	],

	Test[
		"If ErrorCategory is \"Individual Mistake (Internal)\", ReportedOperatorError has to be populated:",
		Or[
			And[
				MatchQ[Lookup[packet, ErrorCategory],"Individual Mistake (Internal)"],
				MatchQ[Lookup[packet, ReportedOperatorError], True|False]],
			And[
				MatchQ[Lookup[packet, ErrorCategory],Except["Individual Mistake (Internal)"]],
				MatchQ[Lookup[packet, ReportedOperatorError], Null]]
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validSupportTicketUserCommunicationQTests*)


validSupportTicketUserCommunicationQTests[packet:PacketP[Object[SupportTicket,UserCommunication]]]:={
	(* Specific fields filled in *)
	NotNullFieldTest[packet,
		{
			ReportedBy,
			SupportTicketSource,
			Description
		}
	],
	
	Test[
		"If the report has no Notebook, then the AffectedProtocol's and AffectedTransaction's Notebook must be Null and the reporter and followers must be Emerald users:",
		If[NullQ[Lookup[packet,Notebook]],
			And[
				MatchQ[Download[Lookup[packet,{AffectedProtocol,AffectedTransaction}],Notebook],{Null,Null}],
				MatchQ[Lookup[packet,ReportedBy],LinkP[Object[User,Emerald]]],
				MatchQ[Lookup[packet,Followers],{LinkP[Object[User,Emerald]]...}]
			],
			True
		],
		True
	],
	
	Test[
		"If SupportTicketSource is Protocol, AffectedProtocol is informed:",
		If[
			MatchQ[Lookup[packet, SupportTicketSource],Protocol],
			!NullQ[Lookup[packet, AffectedProtocol]],
			True
		],
		True
	],
	
	Test[
		"If SupportTicketSource is Application, AffectedApplication is informed:",
		If[
			MatchQ[Lookup[packet, SupportTicketSource],Application],
			!NullQ[Lookup[packet, AffectedApplication]],
			True
		],
		True
	],
	
	Test[
		"If SupportTicketSource is Function, AffectedFunction is informed:",
		If[
			MatchQ[Lookup[packet, SupportTicketSource],Function],
			!NullQ[Lookup[packet, AffectedFunction]],
			True
		],
		True
	]
		
};



(* ::Subsection::Closed:: *)
(*validSupportTicketOperationsQTests*)


validSupportTicketOperationsQTests[packet:PacketP[Object[SupportTicket,Operations]]]:={
	
	NotNullFieldTest[packet,
		{
			ReportedBy,
			Blocked,
			Suspended,
			Maintenance,
			Description,
			SupportTicketSource
		}
	],
	
	Test[
		"If SupportTicketSource is Protocol, AffectedProtocol is informed:",
		If[
			MatchQ[Lookup[packet, SupportTicketSource],Protocol],
			!NullQ[Lookup[packet, AffectedProtocol]],
			True
		],
		True
	]
	
};


(* ::Subsection::Closed:: *)
(* Test Registration *)


registerValidQTestFunction[Object[SupportTicket],validSupportTicketQTests];
registerValidQTestFunction[Object[SupportTicket, UserCommunication],validSupportTicketUserCommunicationQTests];
registerValidQTestFunction[Object[SupportTicket, Operations],validSupportTicketOperationsQTests];
