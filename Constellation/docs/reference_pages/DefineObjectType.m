(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*DefineObjectType*)


DefineUsage[DefineObjectType,
	{
		BasicDefinitions -> {
			{"DefineObjectType[type,definition]", "out", "defines a type and its fields."}
		},
		MoreInformation -> {
			"If the type has multiple levels, all previous levels must have previously been defined or this function $Fails"
		},
		Input :> {
			{"type", TypeP[], "The type reference."},
			{"definition", {(_Rule | _RuleDelayed)..}, "The description and fields definitions for the type."}
		},
		Output :> {
			{"out", {(_Rule | _RuleDelayed)..} | $Failed, "Returns the full type definition."}
		},
		SeeAlso -> {
			"DefineObjectType", "LookupTypeDefinition"
		},
		Tutorials -> {"Named Fields"},
		Author -> {
			"platform"
		}
	}];
DefineObjectClass::usage="Deprecated";


(* ::Subsubsection::Closed:: *)
(*LookupTypeDefinition*)


DefineUsage[LookupTypeDefinition,
	{
		BasicDefinitions -> {
			{"LookupTypeDefinition[type]", "out", "returns the full type definition for the 'type'."},
			{"LookupTypeDefinition[type,field]", "out", "returns the definition for 'field' of the 'type'."},
			{"LookupTypeDefinition[type,field,component]", "out", "returns the 'component' of the definition for 'field' of the 'type'."}
		},
		MoreInformation -> {
			"When specified, the 'field' and 'component' can both be lists."
		},
		Input :> {
			{"type", TypeP[], "The type reference."},
			{"field", _Symbol, "The field of the type."},
			{"component", _Symbol, "The component of the field definition."}
		},
		Output :> {
			{"out", {(_Rule | _RuleDelayed)..} | $Failed, "The definition, or $Failed if the definition does not exist."}
		},
		SeeAlso -> {
			"DefineObjectType", "TypeQ"
		},
		Author -> {
			"platform"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*ValidTypeQ*)


DefineUsage[ValidTypeQ,
	{
		BasicDefinitions -> {
			{"ValidTypeQ[type]", "out", "checks that the type and its field definitions are valid."}
		},
		MoreInformation -> {
		},
		Input :> {
			{"type", TypeP[], "The type reference."}
		},
		Output :> {
			{"out", _, "Conforms to the RunValidQTest output standard."}
		},
		SeeAlso -> {
			"DefineObjectType", "LookupTypeDefinition", "RunValidQTest"
		},
		Author -> {
			"platform"
		}
	}];
