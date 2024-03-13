(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*ValidPacketFormatQ*)


DefineUsage[ValidPacketFormatQ,
	{
		BasicDefinitions -> {
			{"ValidPacketFormatQ[packet]", "out", "checks to see if the values in 'packet' match type definitions. Header fields (Type, ID, etc.) are skipped."},
			{"ValidPacketFormatQ[packets]", "out", "checks to see if the values in 'packets' match type definitions. Header fields (Type, ID, etc.) are skipped."},
			{"ValidPacketFormatQ[packet,type]", "out", "checks to see if the values in 'packet' match type definitions and are of the given 'type'. Header fields (Type, ID, etc.) are skipped."},
			{"ValidPacketFormatQ[packets,type]", "out", "checks to see if the values in 'packets' match type definitions and are of the given 'type'. Header fields (Type, ID, etc.) are skipped."}
		},
		Input :> {
			{"packet", PacketP[], "An Object Packet."},
			{"packets", {PacketP[]...}, "A list of Object Packets."},
			{"type", TypeP[], "The type of packet expected."}
		},
		Output :> {
			{"out", _, "Conforms to the RunValidQTest output standard."}
		},
		SeeAlso -> {
			"Association",
			"DefineObjectType"
		},
		Author -> {"platform"}
	}];


(* ::Subsubsection::Closed:: *)
(*ValidUploadQ*)


DefineUsage[ValidUploadQ,
	{
		BasicDefinitions -> {
			{"ValidUploadQ[upload]", "bool", "checks whether 'upload' contains valid object creation/update rules."}
		},
		MoreInformation -> {
			"ValidUploadQ is called by Upload to ensure that the specified rules conform to the type definitions.",
			"When updating any multiple field, Append|Replace must be explicitly specified in the update rule (Append[Numbers] -> {1,2,3}).",
			"Single fields can be specified as symbols or symbols (FieldName) wrapped in Append/Replace (Replace[FieldName]). Both forms will always have the same behaviour of replacing the existing values in the objects.",
			"Cannot append a single Null value to a multiple field: Append[MultipleField] -> Null is invalid.",
			"All fields specified in the upload must match their field patterns the same as in ValidPacketFormatQ."
		},
		Input :> {
			{"upload", _Association | {___Association}, "Single update or list of updates."}
		},
		Output :> {
			{"bool", True | False, "Whether or not the upload is valid. Return value can be changed via the OutputFormat option."}
		},
		SeeAlso -> {
			"Association",
			"Upload",
			"Download",
			"RunValidQTest",
			"ValidPacketFormatQ"
		},
		Author -> {"platform"}
	}];


(* ::Subsubsection::Closed:: *)
(*SingleFieldQ*)


DefineUsage[SingleFieldQ,
	{
		BasicDefinitions -> {
			{"SingleFieldQ[definition]", "bool", "returns True if the field 'definition' is a Single field."},
			{"SingleFieldQ[rule]", "bool", "returns True if the field definition given by 'rule' is a Single field."},
			{"SingleFieldQ[field]", "bool", "returns True if the given 'field' is a Single field."}
		},
		Input :> {
			{"definition", {(_Rule | _RuleDelayed)..}, "Field definition."},
			{"rule", _Symbol -> {(_Rule | _RuleDelayed)..}, "Full field definition rule."},
			{"field", FieldP[], "Full field definition rule."}
		},
		Output :> {
			{"bool", True | False, "True if the input is a Single field."}
		},
		SeeAlso -> {
			"MultipleFieldQ",
			"IndexedFieldQ",
			"NamedFieldQ",
			"ComputableFieldQ",
			"FieldP",
			"FieldQ",
			"Fields",
			"DefineObjectType"
		},
		Author -> {"platform"}
	}];


(* ::Subsubsection::Closed:: *)
(*MultipleFieldQ*)


DefineUsage[MultipleFieldQ,
	{
		BasicDefinitions -> {
			{"MultipleFieldQ[definition]", "bool", "returns True if the field 'definition' is a Multiple field."},
			{"MultipleFieldQ[rule]", "bool", "returns True if the field definition given by 'rule' is a Multiple field."},
			{"MultipleFieldQ[field]", "bool", "returns True if the given 'field' is a Multiple field."}
		},
		Input :> {
			{"definition", {(_Rule | _RuleDelayed)..}, "Field definition."},
			{"rule", _Symbol -> {(_Rule | _RuleDelayed)..}, "Full field definition rule."},
			{"field", FieldP[], "Full field definition rule."}
		},
		Output :> {
			{"bool", True | False, "True if the input is a Multiple field."}
		},
		SeeAlso -> {
			"SingleFieldQ",
			"IndexedFieldQ",
			"NamedFieldQ",
			"ComputableFieldQ",
			"FieldP",
			"FieldQ",
			"Fields",
			"DefineObjectType"
		},
		Author -> {"platform"}
	}];

(* ::Subsubsection::Closed:: *)
(*IndexedFieldQ*)


DefineUsage[IndexedFieldQ,
	{
		BasicDefinitions -> {
			{"IndexedFieldQ[definition]", "bool", "returns True if the field 'definition' is an Indexed field."},
			{"IndexedFieldQ[rule]", "bool", "returns True if the field definition given by 'rule' is an Indexed field."},
			{"IndexedFieldQ[field]", "bool", "returns True if the given 'field' is an Indexed field."}
		},
		Input :> {
			{"definition", {(_Rule | _RuleDelayed)..}, "Field definition."},
			{"rule", _Symbol -> {(_Rule | _RuleDelayed)..}, "Full field definition rule."},
			{"field", FieldP[], "Full field definition rule."}
		},
		Output :> {
			{"bool", True | False, "True if the input is an Indexed field."}
		},
		SeeAlso -> {
			"SingleFieldQ",
			"MultipleFieldQ",
			"NamedFieldQ",
			"ComputableFieldQ",
			"FieldP",
			"FieldQ",
			"Fields",
			"DefineObjectType"
		},
		Author -> {"platform"}
	}];

DefineUsage[NamedFieldQ, {
	BasicDefinitions -> {
		{"NamedFieldQ[definition]", "bool", "returns True if the field 'definition' is a named field."},
		{"NamedFieldQ[rule]", "bool", "returns True if the field definition given by 'rule' is a named field."},
		{"NamedFieldQ[field]", "bool", "returns True if the given 'field' is a named field."}
	},
	Input :> {
		{"definition", {(_Rule | _RuleDelayed) ..}, "Field definition."},
		{"rule", _Symbol -> {(_Rule | _RuleDelayed) ..}, "Full field definition rule."},
		{"field", FieldP[], "Full field definition rule."}
	},
	Output :> {
		{"bool", True | False, "True if the input is a named field."}
	},
	SeeAlso -> {
		"SingleFieldQ",
		"MultipleFieldQ",
		"IndexedFieldQ",
		"ComputableFieldQ",
		"FieldP",
		"FieldQ",
		"Fields",
		"DefineObjectType"
	},
	Author -> {"platform"}
}];


(* ::Subsubsection::Closed:: *)
(*ComputableFieldQ*)


DefineUsage[ComputableFieldQ,
	{
		BasicDefinitions -> {
			{"ComputableFieldQ[definition]", "bool", "returns True if the field 'definition' is a Computable field."},
			{"ComputableFieldQ[rule]", "bool", "returns True if the field definition given by 'rule' is a Computable field."},
			{"ComputableFieldQ[field]", "bool", "returns True if the given 'field' is a Computable field."}
		},
		MoreInformation -> {
			"Returns False for Single fields."
		},
		Input :> {
			{"definition", {(_Rule | _RuleDelayed)..}, "Field definition."},
			{"rule", _Symbol -> {(_Rule | _RuleDelayed)..}, "Full field definition rule."},
			{"field", FieldP[], "Full field definition rule."}
		},
		Output :> {
			{"bool", True | False, "True if the input is a Computable field."}
		},
		SeeAlso -> {
			"SingleFieldQ",
			"MultipleFieldQ",
			"IndexedFieldQ",
			"NamedFieldQ",
			"FieldP",
			"FieldQ",
			"Fields",
			"DefineObjectType"
		},
		Author -> {"platform"}
	}];

(* ::Subsubsection::Closed:: *)
(*fieldToPart*)

DefineUsage[fieldToPart,
	{
		BasicDefinitions -> {
			{"fieldToPart[field]", "part", "returns the 'part' for the given 'field'."}
		},
		MoreInformation -> {
			"Returns $Failed if field has no index."
		},
		Input :> {
			{"field", FieldP[], "Field to extract index from."}
		},
		Output :> {
			{"part", _Integer | _Symbol, "Index of an indexed field, or column name of a named field."}
		},
		SeeAlso -> {
			"fieldToType",
			"fieldToSymbol",
			"SingleFieldQ",
			"MultipleFieldQ",
			"IndexedFieldQ",
			"FieldP",
			"FieldQ",
			"Fields",
			"DefineObjectType"
		},
		Author -> {"platform"}
	}];

(* ::Subsubsection::Closed:: *)
(*fieldToType*)

DefineUsage[fieldToType,
	{
		BasicDefinitions -> {
			{"fieldToType[field]", "type", "returns the 'type' for the given 'field'."}
		},
		Input :> {
			{"field", FieldP[], "Field to extract index from."}
		},
		Output :> {
			{"type", TypeP[], "Type for the given field."}
		},
		SeeAlso -> {
			"fieldToPart",
			"fieldToSymbol",
			"SingleFieldQ",
			"MultipleFieldQ",
			"IndexedFieldQ",
			"FieldP",
			"FieldQ",
			"Fields",
			"DefineObjectType"
		},
		Author -> {"platform"}
	}];

(* ::Subsubsection::Closed:: *)
(*fieldToSymbol*)

DefineUsage[fieldToSymbol,
	{
		BasicDefinitions -> {
			{"fieldToSymbol[field]", "symbol", "returns the 'symbol' for the given 'field'."}
		},
		Input :> {
			{"field", FieldP[], "Field to extract symbol from."}
		},
		Output :> {
			{"symbol", _Symbol, "Symbol for the given field."}
		},
		SeeAlso -> {
			"fieldToPart",
			"SingleFieldQ",
			"MultipleFieldQ",
			"IndexedFieldQ",
			"FieldP",
			"FieldQ",
			"Fields",
			"DefineObjectType"
		},
		Author -> {"platform"}
	}];


(* ::Subsubsection::Closed:: *)
(*packetToType*)

DefineUsage[packetToType,
	{
		BasicDefinitions -> {
			{"packetToType[packet]", "type", "returns the object 'type' for the given 'packet'."}
		},
		MoreInformation -> {
			"Will return $Failed if given an Association missing both Object & Type keys."
		},
		Input :> {
			{"packet", _Association, "Packet to extract type from."}
		},
		Output :> {
			{"type", TypeP[], "Type for the given packet."}
		},
		SeeAlso -> {},
		Author -> {"platform"}
	}];


(* ::Subsubsection::Closed:: *)
(*fieldReferenceToObject*)

DefineUsage[fieldReferenceToObject,
	{
		BasicDefinitions -> {
			{"fieldReferenceToObject[reference]", "object", "extracts the 'object' from a 'reference'."}
		},
		Input :> {
			{"reference", FieldReferenceP[], "A reference to a field in a specific object."}
		},
		Output :> {
			{"object", ObjectReferenceP[], "The object this field reference points to."}
		},
		SeeAlso -> {
			"FieldReferenceP",
			"fieldReferenceToField",
			"fieldReferenceToSymbol",
			"fieldReferenceToColumn"
		},
		Author -> {"platform"}
	}];


(* ::Subsubsection::Closed:: *)
(*fieldReferenceToField*)

DefineUsage[fieldReferenceToField,
	{
		BasicDefinitions -> {
			{"fieldReferenceToField[reference]", "field", "extracts the 'field' from a 'reference'."}
		},
		Input :> {
			{"reference", FieldReferenceP[], "A reference to a field in a specific object."}
		},
		Output :> {
			{"field", Field[], "The field this field reference points to."}
		},
		SeeAlso -> {
			"FieldReferenceP",
			"fieldReferenceToObject",
			"fieldReferenceToSymbol",
			"fieldReferenceToColumn"
		},
		Author -> {"platform"}
	}];


(* ::Subsubsection::Closed:: *)
(*fieldReferenceToSymbol*)

DefineUsage[fieldReferenceToSymbol,
	{
		BasicDefinitions -> {
			{"fieldReferenceToSymbol[reference]", "symbol", "extracts the 'symbol' from a 'reference'."}
		},
		Input :> {
			{"reference", FieldReferenceP[], "A reference to a field in a specific object."}
		},
		Output :> {
			{"symbol", _Symbol, "The field symbol this field reference points to."}
		},
		SeeAlso -> {
			"FieldReferenceP",
			"fieldReferenceToObject",
			"fieldReferenceToField",
			"fieldReferenceToColumn"
		},
		Author -> {"platform"}
	}];


(* ::Subsubsection::Closed:: *)
(*fieldReferenceToColumn*)

DefineUsage[fieldReferenceToColumn,
	{
		BasicDefinitions -> {
			{"fieldReferenceToColumn[reference]", "column", "extracts the 'column' of a field from a 'reference'."}
		},
		MoreInformation -> {
			"Returns $Failed if there is no column."
		},
		Input :> {
			{"reference", FieldReferenceP[], "A reference to a field in a specific object."}
		},
		Output :> {
			{"column", _Integer | _Symbol, "The column from the field reference."}
		},
		SeeAlso -> {
			"FieldReferenceP",
			"fieldReferenceToObject",
			"fieldReferenceToField",
			"fieldReferenceToSymbol"
		},
		Author -> {"platform"}
	}];


(* ::Subsubsection::Closed:: *)
(*Link*)

DefineUsage[Link,
	{
		BasicDefinitions -> {
			{"Link[object]", "link", "returns a one-way 'link' to the 'object'."},
			{"Link[object,field]", "link", "returns a two-way 'link' to the 'field' in 'object'."},
			{"Link[object,field,index]", "link", "returns a two-way 'link' to the 'field' at 'index' in 'object'."},
			{"Link[objects]", "links", "returns a list of one-way 'links' to the given 'objects'."},
			{"Link[objects,field]", "links", "returns a list of two-way 'links' to the 'field' in each of the 'objects'."},
			{"Link[objects,field,index]", "links", "returns a list of two-way 'links' to the 'index' of 'field' in each of the 'objects'."}
		},
		MoreInformation -> {
			"Returns Null if object/link are given as Null.",
			"Returns $Failed if given a packet that does not have an Object key"
		},
		Input :> {
			{"field", _Symbol, "The field in the object to link to."},
			{"index", _Integer, "The index in the field of the object to link to."},
			{"object", ObjectP[], "An object to link to."},
			{"objects", {ObjectP[]...}, "A list of objects to link to."}
		},
		Output :> {
			{"link", LinkP[], "A link to an object."},
			{"links", {LinkP[]...}, "A list of links to objects."}
		},
		SeeAlso -> {
			"ObjectP",
			"ObjectReferenceP",
			"LinkP",
			"Download",
			"Upload"
		},
		Author -> {"platform"}
	}];
