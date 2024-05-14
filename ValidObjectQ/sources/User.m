(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*validUserQTests*)


validUserQTests[packet:PacketP[Object[User]]]:={

	NotNullFieldTest[packet, {
		Name,
		Email,
		Status
	}],

	Test["All non-Emerald users must be part of at least one Financing or Sharing team:",
		If[MatchQ[Lookup[packet, Object], ObjectP[Object[User, Emerald]]],
			True,
			Not[MatchQ[Flatten[Lookup[packet, {SharingTeams, FinancingTeams}]], {}]]
		],
		True
	],

	(*
		TODO: Design and Outline a proper spec behind Financing and Sharing Teams.
		Previously it seems as if it was Okay for Active users to not be part of a Financing team.
		(Users allowed to view things but not actually order anything?....Not sure what the original intention was)
		But now that seems to cause more harm than good, with Users that meant to have financing team not having one. Resulting
		in this VoQ check.
	*)
	Test["All active users must be part of a Financing Team:",
		Lookup[packet, {Status, FinancingTeams}],
		Alternatives[
			{Except[Active], _},  (* If not active, there can be anything in this field *)
			{Active, Except[{}]} (* If active, ensure there is a Financing Team *)
		]
	]
};


(* ::Subsection:: *)
(*validUserEmeraldQTests*)


validUserEmeraldQTests[packet:PacketP[Object[User, Emerald]]]:={
	NotNullFieldTest[packet, {
		Department,
		HireDate,
		Position
	}],

	Test["If HireDate is informed, it is in the past:",
		Lookup[packet, HireDate],
		Alternatives[
			Null,{},
			_?(# <= Now&)
		]
	],

	FieldComparisonTest[packet, {LastWorkDate, HireDate}, GreaterEqual],

	Test["Historical users have a LastWorkDate:",
		If[MatchQ[Lookup[packet,Status],Historical],
			!MatchQ[Lookup[packet,LastWorkDate],Null],
			True
		],
		True
	],

	Test["If the user has LastWorkDate populated, they have to have Status of Historical:",
		If[!MatchQ[Lookup[packet,LastWorkDate],Null],
			MatchQ[Lookup[packet,Status],Historical],
			True
		],
		True
	],

	Test["If Status is Active, KeyCardID must be informed:",
		Lookup[packet,{Status,Department,KeyCardID}],
		Alternatives[
			{Active,Except[User],Except[NullP]},
			{Active,User,_},
			{Except[Active],_,_}
		]
	],

	Test["If Status is Active, AsanaGID must be informed:",
		Lookup[packet,{Status,Department,AsanaGID}],
		Alternatives[
			{Active,Except[User],Except[NullP]},
			{Active,User,_},
			{Except[Active],_,_}
		]
	],

	Test["If Status is Active, Site must be informed:",
		Lookup[packet,{Status,Department,Site}],
		Alternatives[
			{Active,Except[User],ObjectP[]},
			{Active,User,_},
			{Except[Active],_,_}
		]
	]
};


(* ::Subsection:: *)
(*validUserEmeraldDeveloperQTests*)


validUserEmeraldDeveloperQTests[packet:PacketP[Object[User,Emerald, Developer]]]:={};


(* ::Subsection:: *)
(*validUserEmeraldOperatorQTests*)


validUserEmeraldOperatorQTests[packet:PacketP[Object[User,Emerald, Operator]]]:={
	NotNullFieldTest[packet, {Model}]
};


(* ::Subsection::Closed:: *)
(* Test Registration *)


registerValidQTestFunction[Object[User],validUserQTests];
registerValidQTestFunction[Object[User,Emerald], validUserEmeraldQTests];
registerValidQTestFunction[Object[User,Emerald, Developer], validUserEmeraldDeveloperQTests];
registerValidQTestFunction[Object[User,Emerald, Operator], validUserEmeraldOperatorQTests];
