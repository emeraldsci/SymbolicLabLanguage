(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* Search *)
DefineUsage[Search,
	{
		BasicDefinitions -> {
			{"Search[types]", "objects", "returns all 'objects' of the given 'types'."},
			{"Search[types, conditions]", "objects", "returns 'objects' of the given 'types' which satisfy the specified 'conditions'."},
			{"Search[typesList]", "objectsLists", "returns a list of all the objects for each list of types in 'typesList'."},
			{"Search[typesList, conditionsList]", "objects", "returns a list of 'objects' for each set of types/condition pair."}
		},
		MoreInformation -> {
			"The conditions given to Search must be a boolean logical expression constructed using field names and various conditional operators (such as '&&', '||') and comparison operators (such as '!=', '==', '>', '<', '>=', '<=').",
			"When using the Alternatives syntax `|` in Search, parentheses must enclose the Alternatives. For example, Status==(InUse|Available).",
			"By default, if the DeveloperObject field is not specified as a condition, Search will only return objects which have DeveloperObject!=True.",
			"When lists of types or conditions are specified, the lengths of the lists must match."
		},
		Input :> {
			{"types", TypeP[] | {TypeP[]...}, "Type(s) of object to search for."},
			{"conditions", Except[_List], "A search expression which will be true for each object of corresponding type(s) returned."},
			{"typesList", {{TypeP[]...}..}, "A list of sets of type(s) to search for."},
			{"conditionsList", {Except[_List]}, "A list of conditions to limit results by."}
		},
		Output :> {
			{"objects", {ObjectReferenceP[] ...} | {{ObjectReferenceP[] ...} ...}, "A list of objects or sets of lists of objects matching the given search conditions."}
		},
		SeeAlso -> {"Download", "Upload", "Object", "Link"},
		Author -> {"platform", "thomas"}
	}];
