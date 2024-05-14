(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)
(*AddFavorite*)

DefineUsage[AddFavoriteObject,
	{
		BasicDefinitions -> {
			{"AddFavoriteObject[targetObjects, folder]", "Null",
				"creates a favorite object for the object or model specified by the user inside provided folder."}
		},
		MoreInformation -> {
			"This is used in the Command Center to keep track of objects marked as favorites by user.",
			"If folder already contains the target object then it appends authors list if it is a different user than from existing authors list.",
			"If folder does not contain the target object, then it create a favorite object and adds to the folder.",
			"This information will be used to display information in favorite dashboard."
		},
		Input :> {
			{"targetObjects", ListableP[ObjectP[]], "Objects that need to be marked as favorite."},
			{"folder", ObjectP[Object[Favorite, Folder]], "The Favorite folder under which the favorite object needs to be created."}
		},
		SeeAlso -> {
			"Upload",
			"Download",
			"MemberQ"
		},
		Author -> {
			"platform"
		}
	}];

(* ::Subsubsection::Closed:: *)
(*RemoveFavoriteFolder*)

DefineUsage[EraseFavoriteFolder,
	{
		BasicDefinitions -> {
			{"EraseFavoriteFolder[folders]", "Null",
				"remove the favorite folder(s) and all the favorite objects within them."}
		},
		MoreInformation -> {
			"This is used in the Command Center to keep track of objects marked as favorites by user.",
			"If folder is empty, it simply deletes it.",
			"If folder contains favorite objects, it deletes them first and then deletes the folder.",
			"This information will be used to display information in favorite dashboard."
		},
		Input :> {
			{"folders", ListableP[ObjectP[Object[Favorite, Folder]]], "The Favorite folders which need to be deleted."}
		},
		SeeAlso -> {
			"Upload",
			"Download",
			"EraseObject",
			"AddFavorite"
		},
		Author -> {
			"platform"
		}
	}];


	(* ::Subsubsection::Closed:: *)
	(*PlotFavoriteFolder*)


	DefineUsage[PlotFavoriteFolder,
		{
			BasicDefinitions -> {
				{"PlotFavoriteFolder[folders]","Null","displays information about user's favorite folder."}
			},
			MoreInformation -> {
				"This is used in the Command Center to keep track of objects marked as favorites by user."
			},
			Input :> {
				{"folders", ObjectP[Object[Favorite,Folder]], "The folder marked as favorite by user."}
			},
			SeeAlso -> {
				"Upload",
				"Download",
				"EraseObject",
				"AddFavorite",
				"PlotFavoriteBookmarksOnNotebook"
			},
			Author -> {
				"platform"
			}
		}];

	(* ::Subsubsection::Closed:: *)
	(*PlotFavoriteBookmarksOnNotebook*)


	DefineUsage[PlotFavoriteBookmarksOnNotebook,
		{
			BasicDefinitions -> {
				{"PlotFavoriteBookmarksOnNotebook[LaboratoryNotebook]","Null","displays user's favorite bookmark on LaboratoryNotebook."}
			},
			MoreInformation -> {
				"This is used in the Command Center to keep track of objects marked as favorites by user."
			},
			Input :> {
				{"LaboratoryNotebook", ObjectP[Object[LaboratoryNotebook]], "The Laboratory Note Book marked as favorite by user."}
			},
			SeeAlso -> {
				"Upload",
				"Download",
				"EraseObject",
				"AddFavorite"
			},
			Author -> {
				"platform"
			}
		}];
