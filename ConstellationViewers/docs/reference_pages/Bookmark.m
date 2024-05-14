(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(*BookmarkObject*)

DefineUsage[BookmarkObject,
	{
		BasicDefinitions -> {
			{"BookmarkObject[targetObjects, notebook, bookmarkPath, bookmarkLocationIdentifier]", "Null",
				"creates a bookmark object for the object or model specified by the user."}
		},
		MoreInformation -> {
			"This is used in the CommandCenter to keep track of objects bookmarked by user.",
			"Tags the input cell with a CellTag that is hidden from user but contains sll id of newly created bookmark object references.",
			"This information will be used to display information in bookmark or  favorite dashboard."
		},
		Input :> {
			{"targetObjects", ListableP[ObjectP[]], "Objects that need to be bookmarked."},
			{"notebook", _NotebookObject, "The Wolfram notebook within which to scroll ."},
			{"bookmarkPath", _String, "The path of the cell to locate within notebook , this can include page, section and subsection information."},
			{"bookmarkLocationIdentifier", _String, "The ExpressionUUID of the cell to locate."}
		},
		SeeAlso -> {
			"Upload",
			"Download",
			"Cells",
			"CellTags"
		},
		Author -> {
			"platform"
		}
	}];

(* GetAbstractFields *)

DefineUsage[GetAbstractFields,
	{
		BasicDefinitions -> {
			{"GetAbstractFields[types]", "abstractFields",
				"returns all abstract fields for a given list of SLL types."}
		},
		MoreInformation -> {
			"This is used to get abstract fields for given type.",
			"Subtypes will include supertype abstract fields.",
			"This information will be used to display information in bookmark dashboard."
		},
		Input :> {
			{"types", ListableP[TypeP[]], "SLL types for which abstract fields need to be obtained."}
		},
		Output :> {
			{"abstractFields", _String, "Returns a JSON form of an association with type names as the key and abstract fields as the value."}
		},
		SeeAlso -> {
			"Inspect",
			"Download",
			"BookmarkObject"
		},
		Author -> {
			"platform"
		}
	}];

	(*GetBookmarkObjects*)

DefineUsage[GetBookmarkObjects,
	{
		BasicDefinitions -> {
			{"GetBookmarkObjects[notebook]", "bookmarks",
				"returns all bookmarked objects defined with the specified notebook page, function, or script."}
		},
		MoreInformation -> {
			"This is used in the CommandCenter to list objects bookmarked within a notebook."
		},
		Input :> {
			{"notebook", _NotebookObject, "The Wolfram notebook which contains bookmarked objects."}
		},
		SeeAlso -> {
			"BookmarkObject"
		},
		Author -> {
			"platform"
		}
	}];
