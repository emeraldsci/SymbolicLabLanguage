(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*Types*)


DefineUsage[Types,
	{
		BasicDefinitions -> {
			{"Types[]", "types", "returns a list of all defined 'types'."},
			{"Types[type]", "types", "returns a list of all defined 'types' that are a sub-type of 'type'."},
			{"Types[Object]", "objectTypes", "returns a list of all defined 'objectTypes'."},
			{"Types[Model]", "modelTypes", "returns a list of all defined 'modelTypes'."}
		},
		MoreInformation -> {
			"Given a type that does not exist, Types will return an empty list {}."
		},
		Input :> {
			{"type", (Object[__Symbol] | Model[__Symbol]), "Given Object/Model type to list sub-types for."}
		},
		Output :> {
			{"types", {(Object[__Symbol] | Model[__Symbol])...}, "List of defined types."},
			{"modelTypes", {Model[__Symbol]...}, "List of defined Model types."},
			{"objectTypes", {Object[__Symbol]...}, "List of defined Object types."}
		},
		SeeAlso -> {"TypeQ", "TypeP", "ObjectReferenceQ", "ObjectReferenceP", "Fields", "FieldQ", "FieldP"},
		Author -> {"platform"}
	}];



(* ::Subsubsection::Closed:: *)
(*TypeQ*)


DefineUsage[TypeQ,
	{
		BasicDefinitions -> {
			{"TypeQ[expression]", "bool", "returns True if 'expression' is a defined type."}
		},
		Input :> {
			{"expression", _, "Expression to check."}
		},
		Output :> {
			{"bool", True | False, "True or False."}
		},
		SeeAlso -> {"Types", "TypeP", "ObjectReferenceQ", "ObjectReferenceP", "Fields", "FieldQ", "FieldP"},
		Author -> {"platform"}
	}];



(* ::Subsubsection::Closed:: *)
(*TypeP*)


DefineUsage[TypeP,
	{
		BasicDefinitions -> {
			{"TypeP[]", "pattern", "returns a 'pattern' which matches any defined type."},
			{"TypeP[type]", "pattern", "returns a 'pattern' which matches any defined types that are a sub-type of 'type'."},
			{"TypeP[Object]", "pattern", "returns a 'pattern' which matches any defined Object types."},
			{"TypeP[Model]", "pattern", "returns a 'pattern' which matches any defined Model types."}
		},
		Input :> {
			{"type", (Object[__Symbol] | Model[__Symbol]), "Type to restrict generated pattern match against."}
		},
		Output :> {
			{"pattern", _PatternTest, "A pattern which matches defined Object/Model types."}
		},
		SeeAlso -> {"Types", "TypeQ", "ObjectReferenceQ", "ObjectReferenceP", "Fields", "FieldQ", "FieldP"},
		Author -> {"platform"}
	}];



(* ::Subsubsection::Closed:: *)
(*ObjectReferenceQ*)


DefineUsage[ObjectReferenceQ,
	{
		BasicDefinitions -> {
			{"ObjectReferenceQ[expression]", "bool", "returns True if 'expression' is an object of a defined type."}
		},
		Input :> {
			{"expression", _, "Expression to check."}
		},
		Output :> {
			{"bool", True | False, "True or False."}
		},
		SeeAlso -> {"Types", "TypeQ", "TypeP", "ObjectReferenceP", "Fields", "FieldQ", "FieldP"},
		Author -> {"platform"}
	}];



(* ::Subsubsection::Closed:: *)
(*ObjectReferenceP*)


DefineUsage[ObjectReferenceP,
	{
		BasicDefinitions -> {
			{"ObjectReferenceP[]", "pattern", "returns a 'pattern' which matches an Object/Model of any defined type."},
			{"ObjectReferenceP[type]", "pattern", "returns a 'pattern' which matches an Object/Model that is a sub-type of 'type'."},
			{"ObjectReferenceP[Object]", "pattern", "returns a 'pattern' which matches an Object of any defined Object types."},
			{"ObjectReferenceP[Model]", "pattern", "returns a 'pattern' which matches a Model of any defined Model types."},
			{"ObjectReferenceP[object]", "pattern", "returns a 'pattern' which matches any form of the given 'object'."}
		},
		Input :> {
			{"type", (Object[__Symbol] | Model[__Symbol]), "Returned pattern will only match Objects/Models which are sub-types of 'type'."},
			{"object", Object[__Symbol, _String] | Model[__Symbol, _String], "Returned pattern will only match the specific object provided (in any formy)."}
		},
		Output :> {
			{"pattern", _PatternTest, "A pattern which matches defined Object/Model types."}
		},
		SeeAlso -> {"Types", "TypeQ", "TypeP", "ObjectReferenceQ", "Fields", "FieldQ", "FieldP"},
		Author -> {"platform"}
	}];


(* ::Subsubsection::Closed:: *)
(* PacketP *)


DefineUsage[PacketP, {
	BasicDefinitions -> {
		{
			"PacketP[]",
			"pattern",
			"returns a 'pattern' which describes a packet that can be uploaded to modify an object or model."
		},
		{
			"PacketP[types]",
			"pattern",
			"returns a 'pattern' which describes a packet that can be uploaded to modify an object that is one of 'types' or their sub-types."
		},
		{
			"PacketP[types, fields]",
			"pattern",
			"returns a 'pattern' which describes a packet that can be uploaded to modify an object of 'types', and contains 'fields'."
		},
		{
			"PacketP[type]",
			"pattern",
			"returns a 'pattern' which describes a packet that can be uploaded to modify an object or model of 'type' or it's sub-types."
		},
		{
			"PacketP[types, field]",
			"pattern",
			"returns a 'pattern' which describes a packet that can be uploaded to modify an object or model that is one of 'types' or their sub-types, and contains the 'field'."
		},
		{
			"PacketP[Object]",
			"pattern",
			"returns a 'pattern' which describes a packet that can be uploaded to modify an object."
		},
		{
			"PacketP[Model]",
			"pattern",
			"returns a 'pattern' which describes a packet that can be uploaded to modify a model."
		}

	},
	MoreInformation -> {
		"A Packet must contain either an Object or Type field."
	},
	Input :> {
		{
			"type",
			TypeP[],
			"A category of data that may be uploaded to the server."
		},
		{
			"types",
			{TypeP[]...},
			"A list of types."
		},
		{
			"field",
			_Symbol | Append[_Symbol] | Replace[_Symbol] | Erase[_Symbol] | EraseCases[_Symbol],
			"A field or operation that may be used to modify an object."
		},
		{
			"fields",
			{_Symbol | Append[_Symbol] | Replace[_Symbol] | Erase[_Symbol] | EraseCases[_Symbol]...},
			"A list of fields and operations."
		}
	},
	Output :> {
		{"pattern", _KeyValuePattern, "A pattern that describes an uploadable packet with one of the given types."}
	},
	SeeAlso -> {
		"PacketP",
		"Upload",
		"Types",
		"TypeQ",
		"TypeP",
		"ObjectReferenceQ",
		"Fields",
		"FieldQ",
		"FieldP",
		"ObjectReferenceP"
	},
	Author -> {"platform"}
}];


(* ::Subsubsection::Closed:: *)
(*Fields*)


DefineUsage[Fields,
	{
		BasicDefinitions -> {
			{"Fields[type]", "fields", "returns a list of all 'fields' for the given 'type'."},
			{"Fields[object]", "fields", "returns a list of all non-empty 'fields' for the given 'object'."}
		},
		Input :> {
			{"type", (Object[__Symbol] | Model[__Symbol]), "Type to query fields for."},
			{"object", ObjectP[], "An object to query non-empty fields for."}
		},
		Output :> {
			{"fields", {((Object | Model)[__Symbol][_Symbol, Repeated[_Symbol | _Integer, {0, 1}]])...}, "List of fields."}
		},
		SeeAlso -> {"Types", "TypeQ", "TypeP", "ObjectReferenceQ", "ObjectReferenceP", "FieldQ", "FieldP"},
		Author -> {"hanming.yang", "thomas"}
	}];



(* ::Subsubsection::Closed:: *)
(*FieldQ*)


DefineUsage[FieldQ,
	{
		BasicDefinitions -> {
			{"FieldQ[expression]", "bool", "returns True if 'expression' is a field in a defined type."}
		},
		Input :> {
			{"expression", _, "Expression to check."}
		},
		Output :> {
			{"bool", True | False, "True or False."}
		},
		SeeAlso -> {"Types", "TypeQ", "TypeP", "ObjectReferenceQ", "ObjectReferenceP", "Fields", "FieldP"},
		Author -> {"platform"}
	}];



(* ::Subsubsection::Closed:: *)
(*BigQuantityArrayP*)

DefineUsage[BigQuantityArrayP,
	{
		BasicDefinitions -> {
			{"BigQuantityArrayP[units]", "pattern", "returns a 'pattern' which matches a field of any defined type."}
		},
		Input :> {
			{"units", _List, "Returned pattern will only match fields of the given 'type'."}
		},
		Output :> {
			{"pattern", _PatternTest, "A pattern which matches defined Object/Model fields."}
		},
		TestsRequired -> False,
		SeeAlso -> {"Types", "TypeQ", "TypeP", "ObjectReferenceQ", "ObjectReferenceP", "Fields", "FieldP", "FieldQ"},
		Author -> {"platform"}
	}];

(* ::Subsubsection::Closed:: *)
(*FieldP*)


DefineUsage[FieldP,
	{
		BasicDefinitions -> {
			{"FieldP[]", "pattern", "returns a 'pattern' which matches a field of any defined type."},
			{"FieldP[type]", "pattern", "returns a 'pattern' which matches a field of the defined 'type'."},
			{"FieldP[Object]", "pattern", "returns a 'pattern' which matches a field of any Object type."},
			{"FieldP[Model]", "pattern", "returns a 'pattern' which matches a field of any Model type."}
		},
		Input :> {
			{"type", (Object[__Symbol] | Model[__Symbol]), "Returned pattern will only match fields of the given 'type'."}
		},
		Output :> {
			{"pattern", _PatternTest, "A pattern which matches defined Object/Model fields."}
		},
		SeeAlso -> {"Types", "TypeQ", "TypeP", "ObjectReferenceQ", "ObjectReferenceP", "Fields", "FieldQ"},
		Author -> {"platform"}
	}];


(* ::Subsubsection::Closed:: *)
(*LinkP*)


DefineUsage[LinkP,
	{
		BasicDefinitions -> {
			{"LinkP[]", "pattern", "returns a 'pattern' which matches a link to any object."},
			{"LinkP[types]", "pattern", "returns a 'pattern' which matches an link to any object of the given 'types'."},
			{"LinkP[types,fields]", "pattern", "returns a 'pattern' which matches an link to any object of the given 'fields' in the given 'types'."},
			{"LinkP[types,fields,indices]", "pattern", "returns a 'pattern' which matches an link to any object of the given 'fields' in the given 'types' at the specific 'indices'."},
			{"LinkP[objects]", "pattern", "returns a 'pattern' which matches a link to any of the specified 'objects'."},
			{"LinkP[head]", "pattern", "returns a 'pattern' which matches a link to any object with the given 'head'."}
		},
		Input :> {
			{"types", ListableP[TypeP[]], "Returned pattern will only match Objects/Models which are sub-types of these types."},
			{"fields", ListableP[_Symbol], "Returned pattern will only match Objects/Models which are links to one of these fields."},
			{"indices", ListableP[_Integer], "Returned pattern will only match Objects/Models which are linked to a field at one of these indices."},
			{"objects", ListableP[ObjectReferenceP[]], "Returned pattern will only match Objects/Models which are linked specifically to one of these objects."},
			{"head", Object | Model, "Returned pattern will only match either Objects or Models."}
		},
		Output :> {
			{"pattern", _PatternTest, "A pattern which matches a link to a field in an object."}
		},
		SeeAlso -> {"Types", "TypeQ", "TypeP", "ObjectReferenceQ", "Fields", "FieldQ", "FieldP", "ObjectReferenceP"},
		Author -> {"platform"}
	}];

(* ::Subsubsection::Closed:: *)
(*TemporalLinkP*)

DefineUsage[TemporalLinkP,
	{
		BasicDefinitions -> {
			{"TemporalLinkP[]", "pattern", "returns a 'pattern' which matches a link to any object from a historical point in time (aka a temporal link)."},
			{"TemporalLinkP[types]", "pattern", "returns a 'pattern' which matches a temporal link to any object of the given 'types'."},
			{"TemporalLinkP[types,fields]", "pattern", "returns a 'pattern' which matches temporal link to any historical object of the given 'fields' in the given 'types'."},
			{"TemporalLinkP[types,fields,indices]", "pattern", "returns a 'pattern' which matches a temporal link to any object of the given 'fields' in the given 'types' at the specific 'indices'."},
			{"TemporalLinkP[objects]", "pattern", "returns a 'pattern' which matches a temporal link to any of the specified 'objects'."},
			{"TemporalLinkP[head]", "pattern", "returns a 'pattern' which matches a temporal link to any object with the given 'head'."}
		},
		Input :> {
			{"types", ListableP[TypeP[]], "Returned pattern will only match Objects/Models which are sub-types of these types."},
			{"fields", ListableP[_Symbol], "Returned pattern will only match Objects/Models which are links to one of these fields."},
			{"indices", ListableP[_Integer], "Returned pattern will only match Objects/Models which are linked to a field at one of these indices."},
			{"objects", ListableP[ObjectReferenceP[]], "Returned pattern will only match Objects/Models which are linked specifically to one of these objects."},
			{"head", Object | Model, "Returned pattern will only match either Objects or Models."}
		},
		Output :> {
			{"pattern", _PatternTest, "A pattern which matches a link to a field in an object."}
		},
		SeeAlso -> {"Types", "TypeQ", "TypeP", "ObjectReferenceQ", "Fields", "FieldQ", "FieldP", "ObjectReferenceP"},
		Author -> {"platform"}
	}];

(* ::Subsubsection::Closed:: *)
(*TemporalLinkDate*)

DefineUsage[TemporalLinkDate,
	{
		BasicDefinitions -> {
			{"TemporalLinkDate[temporalLink]", "date", "returns the `date` Object associated with the temporal link."}
		},
		Input :> {
			{"temporalLink", TemporalLinkP[], "Pattern matches all temporal links."}
		},
		Output :> {
			{"date", _?DateObjectQ, "A valid dateObject."}
		},
		SeeAlso -> {"LinkP", "TemporalLinkP", "Link"},
		Author -> {"platform"}

	}];

(* ::Subsubsection::Closed:: *)
(*LinkedObject*)

DefineUsage[LinkedObject,
	{
		BasicDefinitions -> {
			{"LinkedObject[link]", "object", "returns the `object` associated with the link."}
		},
		Input :> {
			{"temporalLink", LinkP[IncludeTemporalLinks -> True], "Pattern matches all links."}
		},
		Output :> {
			{"object", ObjectP[], "A cosntellation object."}
		},
		SeeAlso -> {"LinkP", "TemporalLinkP", "Link"},
		Author -> {"platform"}

	}];

(* ::Subsubsection::Closed:: *)
(*RemoveLinkID*)

DefineUsage[RemoveLinkID,
	{
		BasicDefinitions -> {
			{"RemoveLinkID[link]", "Link", "returns a `Link` with its ID stripped."},
			{"RemoveLinkID[link]", "Link", "returns a `TemporalLink` with its ID stripped but date intact."}

		},
		Input :> {
			{"link", LinkP[IncludeTemporalLinks -> True], "Pattern matches all Links."}
		},
		Output :> {
			{"Link", LinkP[IncludeTemporalLinks -> True], "Returns id-less links."}
		},
		SeeAlso -> {"LinkP", "TemporalLinkP", "Link"},
		Author -> {"platform"}

	}];

(* ::Subsubsection::Closed:: *)
(*RemoveLinkID*)

DefineUsage[LinkID,
	{
		BasicDefinitions -> {
			{"LinkID[temporalLink]", "id", "returns the id of the temporal link."},
			{"LinkID[link]", "id", "returns the id of the link."}
		},
		Input :> {
			{"temporalLink", TemporalLinkP[], "Pattern matches all temporal links."},
			{"link", LinkP[IncludeTemporalLinks -> False], "Pattern matches all links."}
		},
		Output :> {
			{"id", _String, "Returns the unique id of the link."}
		},
		TestsRequired -> False,
		SeeAlso -> {"LinkP", "TemporalLinkP", "Link"},
		Author -> {"platform"}

	}];


(* ::Subsubsection::Closed:: *)
(*FieldReferenceP*)

DefineUsage[FieldReferenceP,
	{
		BasicDefinitions -> {
			{"FieldReferenceP[]", "pattern", "returns a 'pattern' which matches any field reference."},
			{"FieldReferenceP[type]", "pattern", "returns a 'pattern' which matches any field reference of the given 'type'."},
			{"FieldReferenceP[type,field]", "pattern", "returns a 'pattern' which matches any field reference of the given 'type' and 'field'."},
			{"FieldReferenceP[type,field,index]", "pattern", "returns a 'pattern' which matches any field reference of the given 'type' and 'index' of the given 'field'."}
		},
		MoreInformation -> {
			"A 'field reference' is a reference to a specific field in a given object.",
			"Downloading a 'field reference' will fetch the value of the field from the given object."
		},
		Input :> {
			{"type", TypeP[] | {TypeP[]...}, "The type(s) of object to restrict pattern match to."},
			{"field", _Symbol | {___Symbol}, "The specific field(s) in the reference to restrict the pattern match to."},
			{"index", _Integer | {___Integer}, "The specific indices of the field in the reference to restrict the pattern match to."}
		},
		Output :> {
			{"pattern", _PatternTest, "A pattern which matches a field reference."}
		},
		SeeAlso -> {
			"ObjectReferenceP",
			"TypeP",
			"LinkP"
		},
		Author -> {"platform"}
	}];


(* ::Subsubsection::Closed:: *)
(*ObjectQ*)


DefineUsage[ObjectQ,
	{
		BasicDefinitions -> {
			{"ObjectQ[expression]", "bool", "returns True if 'expression' is an object, model, link, or packet of a defined type."}
		},
		Input :> {
			{"expression", _, "Expression to check."}
		},
		Output :> {
			{"bool", True | False, "True or False."}
		},
		SeeAlso -> {"Types", "TypeQ", "TypeP", "ObjectReferenceP", "ObjectP", "Fields", "FieldQ", "FieldP"},
		Author -> {"platform", "brad"}
	}];



(* ::Subsubsection::Closed:: *)
(*ObjectP*)


DefineUsage[ObjectP,
	{
		BasicDefinitions -> {
			{"ObjectP[]", "pattern", "returns a 'pattern' which matches an object, model, link, or packet of any defined type."},
			{"ObjectP[type]", "pattern", "returns a 'pattern' which matches an object, model, link, or packet that is a sub-type of 'type'."},
			{"ObjectP[type, fields]", "pattern", "returns a 'pattern' which matches an object, model, or link that is a sub-type of 'type, or a packet that is a sub-type of 'type' and includes the keys in 'fields'."},
			{"ObjectP[Object]", "pattern", "returns a 'pattern' which matches an object, link containing an object, or packet of an object of any defined Object types."},
			{"ObjectP[Model]", "pattern", "returns a 'pattern' which matches a model, link containing a model, or packet of a model of any defined Model types."},
			{"ObjectP[reference]", "pattern", "returns a 'pattern' which matches an object, link containing an object, or packet of a model for the specific 'reference'."},
			{"ObjectP[link]", "pattern", "returns a 'pattern' which matches an object, link containing an object, or packet of a model for the specific 'link'."}
		},
		Input :> {
			{"type", (Object[__Symbol] | Model[__Symbol]), "Returned pattern will only match objects/models/links/packets which are sub-types of 'type'."},
			{"fields", {___Symbol} | _Symbol, "A symbol or list of symbols that are required as keys in any matching packets."},
			{"reference", ObjectReferenceP[], "Returned pattern will only match objects/models/links/packets which point to the specific reference."},
			{"link", LinkP[], "Returned pattern will only match objects/models/links/packets which point to the reference of the specific link."}
		},
		Output :> {
			{"pattern", _PatternTest, "A pattern which matches defined object/model/link/packet types."}
		},
		SeeAlso -> {"Types", "TypeQ", "TypeP", "ObjectReferenceQ", "ObjectQ", "Fields", "FieldQ", "FieldP"},
		Author -> {"platform", "brad"}
	}];


(* ::Subsubsection::Closed:: *)
(*SameObjectQ*)


DefineUsage[SameObjectQ,
	{
		BasicDefinitions -> {
			{"SameObjectQ[expressions]", "bool", "returns True if all 'expressions' refer to the same object."}
		},
		MoreInformation -> {
			"Any objects with names will be converted to their fully qualified Object forms before comparison.",
			"Any links will be compared based on the object they point to.",
			"If any non-object expressions appear as argument, SameObjectQ will return False."
		},
		Input :> {
			{"expressions", ___, "Sequence of expressions to check if they are the same object."}
		},
		Output :> {
			{"bool", True | False, "True if all expressions are the same object."}
		},
		SeeAlso -> {"ObjectReferenceP", "ObjectP", "LinkP", "ObjectQ", "ObjectReferenceQ"},
		Author -> {"hanming.yang", "thomas"}
	}];


(* ::Subsubsection::Closed:: *)
(*Object*)


DefineUsage[Object,
	{
		BasicDefinitions -> {
			{"Object[id]", "reference", "returns the fully qualified object 'reference' with the given 'id'."},
			{"Object[symbols,id]", "reference", "represents a fully qualified 'reference' to an object in the ECL system."},
			{"Object[symbols,name]", "reference", "represents the fully qualified object 'reference' with the given 'name' (if it exists)."},
			{"Object[symbols]", "type", "represents a 'type' of object in the ECL system."}
		},
		MoreInformation -> {
			"When using a name to identify an object that name must be unique across all objects of the same type."
		},
		Input :> {
			{"id", _String?(StringMatchQ[#, "id:"~~__]&), "A unique ID for an object reference."},
			{"name", _String, "A name uniquely identifying an object."},
			{"symbols", ___Symbol, "A set of symbols that define a unique type in the ECL system."}
		},
		Output :> {
			{"reference", ObjectReferenceP[], "A unique reference to an object in the ECL system."},
			{"type", TypeP[], "An existing type in the ECL system."}
		},
		SeeAlso -> {"Model", "Download", "Upload", "Search", "TypeQ", "TypeP", "ObjectReferenceQ", "ObjectReferenceP", "Fields", "FieldQ", "FieldP"},
		Author -> {"platform"}
	}];



(* ::Subsubsection::Closed:: *)
(*Model*)


DefineUsage[Model,
	{
		BasicDefinitions -> {
			{"Model[id]", "reference", "returns the fully qualified model object 'reference' with the given 'id'."},
			{"Model[symbols,id]", "reference", "represents a fully qualified object 'reference' to an model in the ECL system."},
			{"Model[symbols,name]", "reference", "represents the fully qualified model object 'reference' with the given 'name' (if it exists)."},
			{"Model[symbols]", "type", "represents a 'type' of model object in the ECL system."}
		},
		MoreInformation -> {
			"When using a name to identify an object that name must be unique across all objects of the same type.",
			"Models can be used the same as Objects but have a special 1-to-1 relationship with Objects.",
			"Every Object can (optionally) have exactly 1 Model (linked via the Model field)."
		},
		Input :> {
			{"id", _String?(StringMatchQ[#, "id:"~~__]&), "A unique ID for an object reference."},
			{"name", _String, "A name uniquely identifying an object."},
			{"symbols", ___Symbol, "A set of symbols that define a unique type in the ECL system."}
		},
		Output :> {
			{"reference", ObjectReferenceP[], "A unique reference to an object in the ECL system."},
			{"type", TypeP[], "An existing type in the ECL system."}
		},
		SeeAlso -> {"Object", "Download", "Upload", "Search", "TypeQ", "TypeP", "ObjectReferenceQ", "ObjectReferenceP", "Fields", "FieldQ", "FieldP"},
		Author -> {"platform"}
	}];


(* ::Subsubsection::Closed:: *)
(*ObjectIDQ*)


DefineUsage[ObjectIDQ,
	{
		BasicDefinitions -> {
			{"ObjectIDQ[expression]", "bool", "returns True if 'expression' is an object ID string."}
		},
		MoreInformation -> {
			"Returns False for non-strings and uses StringMatchQ to compare strings to the string pattern ObjectIDStringP."
		},
		Input :> {
			{"expression", _, "Expression to check."}
		},
		Output :> {
			{"bool", True | False, "True or False."}
		},
		SeeAlso -> {"Types", "TypeQ", "TypeP", "ObjectReferenceP", "ObjectP", "ObjectQ", "Fields", "FieldQ", "FieldP"},
		Author -> {"platform", "brad"}
	}
];