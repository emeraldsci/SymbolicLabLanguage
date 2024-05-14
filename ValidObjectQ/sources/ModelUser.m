(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validModelUserQTests*)


validModelUserQTests[packet:PacketP[Model[User]]] := {

	(* General fields filled in *)
	NotNullFieldTest[packet,{Name}]

};


(* ::Subsection::Closed:: *)
(*validModelUserEmeraldQTests*)


validModelUserEmeraldQTests[packet:PacketP[Model[User, Emerald]]] := {};


(* ::Subsection::Closed:: *)
(*validModelUserEmeraldOperatorQTests*)


validModelUserEmeraldOperatorQTests[packet:PacketP[Model[User, Emerald, Operator]]] := {
	NotNullFieldTest[packet, {QualificationLevel,ProtocolPermissions}]
};


(* ::Subsection::Closed:: *)
(*validModelUserEmeraldDeveloperQTests*)


validModelUserEmeraldDeveloperQTests[packet:PacketP[Model[User, Emerald, Developer]]] := {};


(* ::Subsection:: *)
(* Test Registration *)


registerValidQTestFunction[Model[User],validModelUserQTests];
registerValidQTestFunction[Model[User, Emerald],validModelUserEmeraldQTests];
registerValidQTestFunction[Model[User, Emerald, Operator],validModelUserEmeraldOperatorQTests];
registerValidQTestFunction[Model[User, Emerald, Developer],validModelUserEmeraldDeveloperQTests];

(* ::Section:: *)
(*End*)
