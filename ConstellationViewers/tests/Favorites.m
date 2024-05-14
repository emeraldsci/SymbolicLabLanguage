(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: pavanshah *)
(* :Date: 2021-06-21 *)

(* ::Subsubsection::Closed:: *)
(*PlotFavoriteFolder*)

DefineTests[
	PlotFavoriteFolder,
	{
		Example[{Basic, "Basic Plot of favorite folder:"},
			Module[{notebook, folder, sampleObj, tableFormResult, nonTableResult, booleanReturn, result},
				{notebook, folder, sampleObj}=setupPlotFavoriteTestObjects[];
				tableFormResult=PlotFavoriteFolder[folder];
				nonTableResult=First@tableFormResult;

				booleanReturn=True;
				result={};
				(* Check each row one by one *)
				booleanReturn=booleanReturn && MatchQ[nonTableResult[[1]], {"Folder", ToString@folder}];
				AppendTo[result, booleanReturn];

				booleanReturn=booleanReturn && MatchQ[nonTableResult[[2]], {"Name", "Fav folder for testing plot functions"}];
				AppendTo[result, booleanReturn];

				(* empty Row for spacing *)
				booleanReturn=booleanReturn && MatchQ[nonTableResult[[3]], {}];
				AppendTo[result, booleanReturn];

				booleanReturn=booleanReturn && MatchQ[nonTableResult[[4]], {"Type", ToString@Object[Sample]}];
				AppendTo[result, booleanReturn];

				(* column names *)
				booleanReturn=booleanReturn && MatchQ[nonTableResult[[5]], {"Favorite Object", "Full Name"}];
				AppendTo[result, booleanReturn];

				(* column values *)
				booleanReturn=booleanReturn && MatchQ[nonTableResult[[6]],
					{ToString@sampleObj, "Test sample for BookmarkObject Plot Function"}];
				AppendTo[result, booleanReturn];

				result
			],
			{True, True, True, True, True, True}
		],
		Example[{Basic, "Exports as a CSV:"},
			Module[{notebook, folder, sampleObj},
				{notebook, folder, sampleObj}=setupPlotFavoriteTestObjects[];
				PlotFavoriteFolder[folder, OutputFormat -> "FavoriteFolderExportTest.csv"]
			],
			_,
			TearDown :> If[FileExistsQ["FavoriteFolderExportTest.csv"], DeleteFile["FavoriteFolderExportTest.csv"]]
		],
		Example[{Basic, "Exports as a JSON:"},
			Module[{notebook, folder, sampleObj},
				{notebook, folder, sampleObj}=setupPlotFavoriteTestObjects[];
				PlotFavoriteFolder[folder, OutputFormat -> "FavoriteFolderExportTest.json"]
			],
			_,
			TearDown :> If[FileExistsQ["FavoriteFolderExportTest.json"], DeleteFile["FavoriteFolderExportTest.json"]]
		],
		Example[{Options,OutputFormat, "Option to export the data as Table or File:"},
			Module[{notebook, folder, sampleObj},
				{notebook, folder, sampleObj}=setupPlotFavoriteTestObjects[];
				PlotFavoriteFolder[folder, OutputFormat -> Table]
			],
			_
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*PlotFavoriteBookmarksOnNotebook*)

DefineTests[
	PlotFavoriteBookmarksOnNotebook,
	{
		Example[{Basic, "Basic Plot of bookmarks:"},
			Module[{notebook, folder, sampleObj, tableFormResult, nonTableResult, booleanReturn},
				{notebook, folder, sampleObj}=setupPlotFavoriteTestObjects[];
				tableFormResult=PlotFavoriteBookmarksOnNotebook[notebook];
				nonTableResult=First@tableFormResult;

				booleanReturn=True;

				(* Check each row one by one *)
				booleanReturn=booleanReturn && MatchQ[nonTableResult[[1]], {"Notebook", ToString@notebook}];
				booleanReturn=booleanReturn && MatchQ[nonTableResult[[2]], {"Name", "Test Notebook for setupLaboratoryNotebook Favorites Plot Functions"}];
				(* empty Row for spacing *)
				booleanReturn=booleanReturn && MatchQ[nonTableResult[[3]], {}];

				booleanReturn=booleanReturn && MatchQ[nonTableResult[[4]], {"Type", ToString@Object[Sample]}];

				(* Not really testing columns because abstract fields are subject to change *)
				booleanReturn
			],
			True
		],
		Example[{Basic, "Exports as a CSV:"},
			Module[{notebook, folder, sampleObj},
				{notebook, folder, sampleObj}=setupPlotFavoriteTestObjects[];
				PlotFavoriteFolder[folder, OutputFormat -> "FavoriteBookmarksExportTest.csv"]
			],
			_,
			TearDown :> If[FileExistsQ["FavoriteBookmarksExportTest.csv"], DeleteFile["FavoriteBookmarksExportTest.csv"]]
		],
		Example[{Basic, "Exports as a JSON:"},
			Module[{notebook, folder, sampleObj},
				{notebook, folder, sampleObj}=setupPlotFavoriteTestObjects[];
				PlotFavoriteFolder[folder, OutputFormat -> "FavoriteBookmarksExportTest.json"]
			],
			_,
			TearDown :> If[FileExistsQ["FavoriteBookmarksExportTest.json"], DeleteFile["FavoriteBookmarksExportTest.json"]]
		],
		Example[{Options, "Exports as a table:"},
			Module[{notebook, folder, sampleObj},
				{notebook, folder, sampleObj}=setupPlotFavoriteTestObjects[];
				PlotFavoriteFolder[folder, OutputFormat -> Table]
			],
			_,
			TearDown :> If[FileExistsQ["FavoriteBookmarksExportTest.csv"], DeleteFile["FavoriteBookmarksExportTest.csv"]]
		],
		Example[{Options,OutputFormat, "Determine whether to export the data as a Table or File:"},
			Module[{notebook, folder, sampleObj, tableFormResult, nonTableResult, booleanReturn},
				{notebook, folder, sampleObj}=setupPlotFavoriteTestObjects[];
				tableFormResult=PlotFavoriteBookmarksOnNotebook[notebook,OutputFormat->Table];
				nonTableResult=First@tableFormResult;

				booleanReturn=True;

				(* Check each row one by one *)
				booleanReturn=booleanReturn && MatchQ[nonTableResult[[1]], {"Notebook", ToString@notebook}];
				booleanReturn=booleanReturn && MatchQ[nonTableResult[[2]], {"Name", "Test Notebook for setupLaboratoryNotebook Favorites Plot Functions"}];
				(* empty Row for spacing *)
				booleanReturn=booleanReturn && MatchQ[nonTableResult[[3]], {}];

				booleanReturn=booleanReturn && MatchQ[nonTableResult[[4]], {"Type", ToString@Object[Sample]}];

				(* Not really testing columns because abstract fields are subject to change *)
				booleanReturn
			],
			True
		]
(* )		Example[{Options, "Option to export the data as a Table or File."},
			Module[{notebook, folder, sampleObj},
				{notebook, folder, sampleObj}=setupPlotFavoriteTestObjects[];
				PlotFavoriteFolder[folder, OutputFormat -> "FavoriteBookmarksExportTest.csv"]
			],
			_,
			TearDown :> If[FileExistsQ["FavoriteBookmarksExportTest.csv"], DeleteFile["FavoriteBookmarksExportTest.csv"]]
		]*)
	}
];


(* ::Subsubsection::Closed:: *)
(*formatFavoritesResponseMultipleResults*)
DefineTests[formatTypesForJSON,
	{
		Test["FormatTypes does not contain Link heads:",
			Module[{notebook, format, sampleObj, response, folder},
				{notebook, folder, sampleObj} = setupFormatFavoriteTestObjects[];
				response = ConstellationRequest[<|"Path" -> "obj/favorite-folders", "Method" -> "POST",
					"Body" -> <|"favorite_folder_ids" -> {Download[folder, ID]}, "summary" -> False|>|>];
				StringContainsQ[ExportAssociationToJSON@formatTypesForJSON[First@Lookup[First@Lookup[response, "results"], "types"]], "Link["]
			],
			False
		]
	}
];

DefineTests[formatTypes,
	{
		Test["FormatTypes does not error:",
			Module[{notebook, format, sampleObj, response, folder},
				{notebook, folder, sampleObj} = setupFormatFavoriteTestObjects[];
				response = ConstellationRequest[<|"Path" -> "obj/favorite-folders", "Method" -> "POST",
					"Body" -> <|"favorite_folder_ids" -> {Download[folder, ID]}, "summary" -> False|>|>];
				KeyExistsQ[formatTypes[First@Lookup[First@Lookup[response, "results"], "types"]], "objects"]
			],
			True
		]
	}
];

DefineTests[
	formatFavoritesResponseMultipleResults,
	{
		Example[{Basic, "Formats units and links from the response of the favorite folders and bookmarks endpoint endpoint:"},
			Module[{notebook, folder, sampleObj, response, solventResult},
				{notebook, folder, sampleObj}=setupFormatFavoriteTestObjects[];
				response=formatFavoritesResponseMultipleResults@ConstellationRequest[<|"Path" -> "obj/favorite-folders", "Method" -> "POST",
					"Body" -> <|"favorite_folder_ids" -> {Download[folder, ID]}, "summary" -> False|>|>];
				solventResult=Lookup[Lookup[Lookup[Lookup[response, "results"][[1]], "types"][[1]], "objects"][[1]], "Solvent"];
				solventResult
			],
			"Model[Sample, StockSolution, \"5% Methanol in Water\"]"
		]
	}
];


setupPlotFavoriteTestObjects[]:=Module[{notebookName, notebookObj, sampleID, favoriteFolderObj},
	notebookName="Test Notebook for setupLaboratoryNotebook "<>"Favorites Plot Functions";
	If[!DatabaseMemberQ[Object[LaboratoryNotebook, notebookName]],
		notebookObj=setupLaboratoryNotebook["Favorites Plot Functions"];
		sampleID=Upload[<|Type -> Object[Sample], Name -> "Test sample for BookmarkObject Plot Function"|>];
		(* Setup a bookmark associated with the notebook *)
		Block[{$Notebook=notebookObj},
			BookmarkObject[{sampleID}, Status -> Active]
		];

		(* Setup a favorite folder associated with this object *)
		favoriteFolderObj=Upload[<|
			Name -> "Fav folder for testing plot functions",
			DisplayName -> "Fav folder for testing plot functions",
			Type -> Object[Favorite, Folder],
			Team -> Link[Object[Team, Financing, "Test Team for setupLaboratoryNotebook Favorites Plot Functions"],
				FavoriteFolders],
			Replace[Columns] -> { <|
				ColumnObjectType -> "Object[Sample]",
				ColumnFields -> "{Name}",
				ColumnLabels -> "{Full Name}" |>} |>];

		AddFavorite[{sampleID}, favoriteFolderObj];
	];

	(* return LabNotebook, FavFolder, and the original targetObject *)
	{
		Object[LaboratoryNotebook, notebookName][Object],
		Object[Favorite, Folder, "Fav folder for testing plot functions"][Object],
		Object[Sample, "Test sample for BookmarkObject Plot Function"][Object]
	}
];


setupFormatFavoriteTestObjects[]:=Module[{notebookName, notebookObj, sampleID, favoriteFolderObj},
	notebookName="Test Notebook for setupLaboratoryNotebook "<>"Favorites Formatted";
	If[!DatabaseMemberQ[Object[LaboratoryNotebook, notebookName]],
		notebookObj=setupLaboratoryNotebook["Favorites Formatted"];
		sampleID=Upload[<|Type -> Model[Sample, StockSolution],
			Name -> "Test sample for Favorites Formatted",
			Solvent -> Link[Model[Sample, StockSolution, "id:qdkmxzq04Vn3"]]
		|>];

		(* Setup a favorite folder associated with this object *)
		favoriteFolderObj=Upload[<|
			Name -> "Fav folder for testing formatting",
			DisplayName -> "Fav folder for testing formatting",
			Type -> Object[Favorite, Folder],
			Team -> Link[Object[Team, Financing, "Test Team for setupLaboratoryNotebook Favorites Formatted"],
				FavoriteFolders],
			Replace[Columns] -> { <|
				ColumnObjectType -> "Model[Sample, StockSolution]",
				ColumnFields -> "{Solvent}",
				ColumnLabels -> "{Solvent}" |>} |>];

		AddFavorite[{sampleID}, favoriteFolderObj];
	];

	(* return LabNotebook, FavFolder, and the original targetObject *)
	{
		Object[LaboratoryNotebook, notebookName][Object],
		Object[Favorite, Folder, "Fav folder for testing formatting"][Object],
		Model[Sample, StockSolution, "Test sample for Favorites Formatted"][Object]
	}
];

(* AddFavoriteObject *)

uploadTestFolder[randomStr_String]:=Module[
	{},
	Upload[<|
		DeveloperObject -> True,
		DisplayName -> "Favorite folder "<>randomStr,
		Type -> Object[Favorite, Folder],
		Team -> Link[Object[Team, Financing, "id:1ZA60vLeXa7a"],
			FavoriteFolders] |>]
];

uploadTestUser[randomStr_String]:=Module[
	{},
	Upload[<|Type -> Object[User, Emerald, Developer],
		DeveloperObject -> True,
		Name -> "Name"<>randomStr,
		LastName -> "LastName",
		HireDate -> Now |>]
];

setupLaboratoryNotebook[randomStr_String]:=Module[
	{site, team, notebook},
	site=Upload[<|DeveloperObject -> True,
		Type -> Object[Container, Site],
		Name -> "Test Site for setupLaboratoryNotebook "<>randomStr|>];
	team=Upload[<|DeveloperObject -> True,
		Type -> Object[Team, Financing],
		Name -> "Test Team for setupLaboratoryNotebook "<>randomStr,
		DefaultMailingAddress -> Link[site]|>];
	notebook=
		Upload[<|DeveloperObject -> True,
			Type -> Object[LaboratoryNotebook],
			Name -> "Test Notebook for setupLaboratoryNotebook "<>randomStr,
			Replace[Financers] -> {Link[team, NotebooksFinanced]},
			Replace[Administrators] -> {Link[
				Object[User, Emerald, Developer, "id:lYq9jRxwZJll"]]}|>];
	notebook
];


(* ::Subsubsection::Closed:: *)
(*AddFavoriteObject*)

DefineTests[
	AddFavoriteObject,
	{
		Example[{Basic, "Add object to an empty folder as favorite:"},
			{
				AddFavoriteObject[{testUser1}, folder1];
				Download[folder1, FavoriteObjects[TargetObject][Object]]
			},
			{{testUser1}},
			SetUp :> {
				$CreatedObjects={};
				randomStr=ToString[RandomReal[]];
				folder1=uploadTestFolder[randomStr];
				testUser1=uploadTestUser[" User 1 "<>randomStr];
			},
			TearDown :> {
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			}
		],
		Example[{Additional, "Add object to a folder where authors list on the favorite object already has the user:"},
			{
				AddFavoriteObject[{testUser1}, folder1];
				Flatten[Download[folder1, FavoriteObjects[Authors][Object]]]
			},
			{{$PersonID}},
			SetUp :> {
				$CreatedObjects={};
				randomStr=ToString[RandomReal[]];
				folder1=uploadTestFolder[randomStr];
				testUser1=uploadTestUser[" User 1 "<>randomStr];
				AddFavoriteObject[{tEraseFavoriteFolderestUser1}, folder1];
			},
			TearDown :> {
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			}
		],
		Example[{Additional, "Add object to a folder where there exists some favorite objects with different target object:"},
			{
				AddFavoriteObject[{testUser2}, folder1];
				Flatten[Download[folder1, FavoriteObjects[TargetObject][Object]]]
			},
			{{testUser1, testUser2}},
			SetUp :> {
				$CreatedObjects={};

				randomStr=ToString[RandomReal[]];
				folder1=uploadTestFolder[randomStr];
				testUser1=uploadTestUser[" User 1 "<>randomStr];
				AddFavoriteObject[{testUser1}, folder1];
				testUser2=uploadTestUser[" User 2 "<>randomStr];
			},
			TearDown :> {
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			}
		],
		Example[{Additional, "Add object to a folder which already has that object but by a different author:"},
			{
				AddFavoriteObject[{testUser1}, folder1];
				{
					Flatten[Download[folder1, FavoriteObjects[TargetObject][Object]]],
					Flatten[Download[folder1, FavoriteObjects[Authors][Object]]]
				}
			},
			{{{testUser1}, {differentAuthor, $PersonID}}},
			SetUp :> {
				$CreatedObjects={};
				randomStr=ToString[RandomReal[]];
				folder1=uploadTestFolder[randomStr];
				testUser1=uploadTestUser[" User 1 "<>randomStr];
				AddFavoriteObject[{testUser1}, folder1];
				(* Change author of the favorite object created so that we can try inserting same object with $PersonID *)
				favObj=First[Download[folder1, FavoriteObjects[Object]]];
				differentAuthor=uploadTestUser[" Different Author "<>randomStr];
				Upload[<|Object -> favObj,
					Replace[Authors] -> {Link[differentAuthor, FavoriteObjects]}|>]
			},
			TearDown :> {
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			}
		],
		Example[{Additional, "Add object to an empty folder as favorite and verify that Lab Notebook is propagated:"},
			{
				AddFavoriteObject[{testUser1}, folder1];
				favObj=First[Download[folder1, FavoriteObjects[Object]]];
				Download[Link[Download[favObj, Notebook]], Object]
			},
			{notebook},
			SetUp :> {
				$CreatedObjects={};
				randomStr=ToString[RandomReal[]];
				folder1=uploadTestFolder[randomStr];
				notebook=setupLaboratoryNotebook["Notebook"<>randomStr];
				Upload[<|Object -> folder1, Transfer[Notebook] -> Link[notebook, Objects]|>];
				testUser1=uploadTestUser[" User 1 "<>randomStr];
			},
			TearDown :> {
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			}
		],
		Example[{Additional, "Make sure objects of type Object.Favorite are not marked favorite:"},
			{
				AddFavoriteObject[{testUser1}, folder1];
				favObj=First[Download[folder1, FavoriteObjects[Object]]];
				AddFavoriteObject[{favObj, testUser2}, folder1];
				Length[Download[folder1, FavoriteObjects[Object]]]
			},
			{2},
			SetUp :> {
				$CreatedObjects={};
				randomStr=ToString[RandomReal[]];
				folder1=uploadTestFolder[randomStr];
				notebook=setupLaboratoryNotebook["Notebook"<>randomStr];
				Upload[<|Object -> folder1, Transfer[Notebook] -> Link[notebook, Objects]|>];
				testUser1=uploadTestUser[" User 1 "<>randomStr];
				testUser2=uploadTestUser[" User 2 "<>randomStr];
			},
			TearDown :> {
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			}
		]
	}];
(* ::Subsubsection::Closed:: *)
(* ::Subsection:: *)

(* EraseFavoriteFolder *)

DefineTests[
	EraseFavoriteFolder,
	{
		Example[{Basic, "Remove favorite folder and favorite objects within it, verify target object is not removed:"},
			{
				EraseFavoriteFolder[folder1];
				Download[testUser1, Object]
			},
			{testUser1},
			SetUp :> {
				$CreatedObjects={};
				randomStr=ToString[RandomReal[]];
				folder1=uploadTestFolder[randomStr];
				testUser1=uploadTestUser[" User 1 "<>randomStr];
				AddFavoriteObject[{testUser1}, folder1];
			},
			TearDown :> {
				EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			}
		],
		Example[{Additional, "Remove empty favorite folder:"},
			{
				EraseFavoriteFolder[folder1];
			},
			{Null},
			SetUp :> {
				$CreatedObjects={};
				randomStr=ToString[RandomReal[]];
				folder1=uploadTestFolder[randomStr];
			},
			TearDown :> {
				EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			}
		],
		Example[{Additional, "Remove list of favorite folders and favorite objects within it:"},
			{
				EraseFavoriteFolder[{folder1, Folder2}];
				{
					Download[testUser1, Object],
					Download[testUser2, Object]
				}
			},
			{{testUser1, testUser2}},
			SetUp :> {
				$CreatedObjects={};
				randomStr=ToString[RandomReal[]];
				folder1=uploadTestFolder[randomStr];
				folder2=uploadTestFolder[randomStr<>" folder 2"];
				testUser1=uploadTestUser[" User 1 "<>randomStr];
				testUser2=uploadTestUser[" User 2 "<>randomStr];
				AddFavoriteObject[{testUser1}, folder1];
				AddFavoriteObject[{testUser2}, folder2];
			},
			TearDown :> {
				EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			}
		]
	}
];
