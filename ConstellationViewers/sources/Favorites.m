(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: pavanshah *)
(* :Date: 2021-06-18 *)


(* doing it once saves 1/2 second *)
allAbstractFieldsJSON=GetAbstractFields[Types[]];
allAbstractFields=JSONTools`FromJSON[allAbstractFieldsJSON];

DefineOptions[
	PlotFavoriteFolder,
	Options :> {
		{OutputFormat -> Table, _String | Table, "Determine whether to export the data as a Table or a File."}
	}
];

DefineOptions[
	PlotFavoriteBookmarksOnNotebook,
	Options :> {
		{OutputFormat -> Table, _String | Table, "Determine whether to export the data as a Table or a File."}
	}
];

(* Plot Functions for favorites *)

PlotFavoriteFolder[object:ObjectP[Object[Favorite, Folder]], ops:OptionsPattern[]]:=Module[{response, objectID, tableResult,
	safeOps, outputFormat},
	safeOps=SafeOptions[PlotFavoriteFolder, ToList[ops]];
	outputFormat=Lookup[safeOps, OutputFormat];

	objectID=Download[object, ID];
	response=formatFavoritesResponseMultipleResults@ConstellationRequest[<|"Path" -> "obj/favorite-folders", "Method" -> "POST",
		"Body" -> <|"favorite_folder_ids" -> {objectID}, "summary" -> False|>|>];
	tableResult=parseFavoriteFolderResponse[response];

	Switch[outputFormat,
		Table, TableForm[tableResult],
		_String, Export[outputFormat, tableResult]
	]
];


PlotFavoriteBookmarksOnNotebook[object:ObjectP[Object[LaboratoryNotebook]], ops:OptionsPattern[]]:=Module[{notebookID, response,
	tableResult, safeOps, outputFormat},
	safeOps=SafeOptions[PlotFavoriteBookmarksOnNotebook, ToList[ops]];
	outputFormat=Lookup[safeOps, OutputFormat];

	notebookID=Download[object, ID];
	response=formatFavoritesResponseMultipleResults@ConstellationRequest[<|"Path" -> "obj/bookmark-objects", "Method" -> "POST",
		"Body" -> <|"notebook_ids" -> {notebookID}, "summary" -> False, "abstract_fields" -> allAbstractFields|>|>];
	tableResult=parseBookmarksResponse[response];

	Switch[outputFormat,
		Table, TableForm[tableResult],
		_String, Export[JSONConvertibleExpression@outputFormat, tableResult]
	]
];


parseFavoriteFolderResponse[response_]:=Catenate[parseFolderResult /@ Lookup[response, "results", {}]];
parseBookmarksResponse[response_]:=Catenate[parseBookmarkResult /@ Lookup[response, "results", {}]];

parseFolderResult[result_]:=Module[{resultTable, folderID, resultsByType,
	typeResults},
	resultTable={};
	folderID=Lookup[result, "id"];
	AppendTo[resultTable, {"Folder", ToString[Object[folderID]]}];
	AppendTo[resultTable, {"Name", Object[folderID][DisplayName]}];
	resultsByType=Lookup[result, "types"];
	typeResults=parseTypeBucket /@ resultsByType;
	Map[AppendTo[resultTable, #] &, typeResults, {2}];
	resultTable
];

parseBookmarkResult[result_]:=Module[{resultTable, notebookID, resultsByType,
	typeResults},
	resultTable={};
	notebookID=Lookup[result, "id"];
	AppendTo[resultTable, {"Notebook", ToString[Object[notebookID]]}];
	AppendTo[resultTable, {"Name", Object[notebookID][Name]}];
	resultsByType=Lookup[result, "types"];
	typeResults=parseTypeBucket /@ resultsByType;
	Map[AppendTo[resultTable, #] &, typeResults, {2}];
	resultTable
];

parseTypeBucket[typeBucket_]:=Module[{typeName, columnLabels, columns, typeTable,
	parsedObjects},
	typeTable={};
	AppendTo[typeTable, {}];
	typeName={"Type", ToString[Constellation`Private`stringToType@Lookup[typeBucket, "type"]]};
	columnLabels=Lookup[typeBucket, "column_labels", {}];
	columns=Join[{"Favorite Object"}, columnLabels];
	AppendTo[typeTable, typeName];
	AppendTo[typeTable, columns];
	parsedObjects=parseFavoriteObject[#, Lookup[typeBucket, "columns", {}]] & /@ Lookup[typeBucket, "objects", {}];
	Map[AppendTo[typeTable, #] &, parsedObjects];
	AppendTo[typeTable, {}];
	typeTable
];
parseFavoriteObject[objectInfo_, columns_]:=Module[{object, objectTable},
	objectTable={};
	object=Object[Lookup[Lookup[objectInfo, "TargetObject"], "id"]];
	objectTable=Flatten@Append[objectTable, {ToString@object}];
	AppendTo[objectTable, Lookup[objectInfo, #, ""]] & /@ columns;
	objectTable
];

(* Favorites formatting with telescope endpoint *)

favoriteFolders[rawJSON_String]:=Module[{request,response,error,responseAssociation},
	request=ImportJSONToAssociation[rawJSON];
	response=ECL`GoLink`GoCall["FavoriteFolder", request];
	error=Lookup[response, "Error", ""];
	If[Length[error]>0,
		Return[$Failed]
	];
	responseAssociation=ImportJSONToAssociation[Lookup[response, "Expression"]];

	(* Call ToExpression on the response to correctly format the units *)
	ExportAssociationToJSON[resolveQuantityAndDateStrings@responseAssociation]
];

resolveQuantityAndDateStrings[assoc_Association]:=Map[resolveQuantityAndDateStrings, assoc];
resolveQuantityAndDateStrings[list_List]:=Map[resolveQuantityAndDateStrings, list];
resolveQuantityAndDateStrings[nestedList:{_List..}]:=Module[{result},
	result=Map[resolveQuantityAndDateStrings, nestedList];
	ToString[result]
];
resolveQuantityAndDateStrings[quantity_Quantity]:=UnitForm[quantity];
resolveQuantityAndDateStrings[s_String]:=Which[
	StringContainsQ[s, "Quantity["],
	resolveQuantityAndDateStrings[ToExpression[s]],

	StringContainsQ[s,"DateObject["],
	ToExpression[s],

	True,
	s
];
resolveQuantityAndDateStrings[other_]:=other;

(* formatting functions for the favorites end points *)

formatFavoritesResponseMultipleResultsJSON[jsonResponseAsBase64_]:=Module[{asMMExpression, formattedMMExpression},
	asMMExpression=Core`Private`decodeBase64StringToAssociation[jsonResponseAsBase64];
	If[!KeyExistsQ[asMMExpression, "raw_values"], Return[ExportAssociationToJSON@asMMExpression]];
	formattedMMExpression=formatFavoritesResponseMultipleResults[asMMExpression];
	ExportAssociationToJSON[formattedMMExpression]
];

formatFavoritesResponseObjectsOnlyJSON[jsonResponseObjectsOnlyAsBase64_String] := Module[{asMMExpression, formattedMMExpression},
	asMMExpression=Core`Private`decodeBase64StringToAssociation[jsonResponseObjectsOnlyAsBase64];
	If[!KeyExistsQ[asMMExpression, "raw_values"], Return[ExportAssociationToJSON@asMMExpression]];
	formattedMMExpression=formatTypesForJSON[asMMExpression];
	ExportAssociationToJSON[formattedMMExpression]
];

(* Authors definition for ConstellationViewers`Private`formatFavoritesResponseMultipleResults *)
Authors[ConstellationViewers`Private`formatFavoritesResponseMultipleResults]:={"scicomp", "brad"};

formatFavoritesResponseMultipleResults[responseAsMMExpression_]:=Module[{formattedMMExpression},
	formattedMMExpression=Append[responseAsMMExpression,
		"results" -> formatFavoritesResult /@ Lookup[responseAsMMExpression, "results", {}]];
	JSONConvertibleExpression@NamedObject@formattedMMExpression
];

formatFavoritesResponseJSON[jsonResponseAsBase64_]:=Module[{asMMExpression, formattedMMExpression},
	asMMExpression=Core`Private`decodeBase64StringToAssociation[jsonResponseAsBase64];
	If[!KeyExistsQ[asMMExpression, "raw_values"], Return[ExportAssociationToJSON@asMMExpression]];
	formattedMMExpression=formatFavoritesResponse[asMMExpression];
	ExportAssociationToJSON[formattedMMExpression]
];

formatFavoritesResponse[responseAsMMExpression_]:=Module[{formattedMMExpression},
	formattedMMExpression=formatFavoritesResult[responseAsMMExpression];
	JSONConvertibleExpression@NamedObject@formattedMMExpression
];


formatFavoritesResult[result_]:=Append[result,
	"types" -> formatTypes /@ Lookup[result, "types", {}]];

formatTypesForJSON[typeBucket: (KeyValuePattern["objects" -> _])] := JSONConvertibleExpression@NamedObject@formatTypes[typeBucket];

formatTypes[typeBucket: (KeyValuePattern["objects" -> _])]:=Append[typeBucket,
	"objects" -> formatObjectResult /@ Lookup[typeBucket, "objects", {}]];

formatObjectResult[objectResult_]:=Module[{targetObject, type,
	keyValuePairsToFormat, formattedFieldValuePairs, formattedFieldValuePairsWithMultiplesAsStrings},
	targetObject=Lookup[objectResult, "TargetObject"];
	type=Constellation`Private`stringToType@Lookup[targetObject, "type"];
	keyValuePairsToFormat=KeyDrop[objectResult, {"TargetObject", "Path"}];
	(* convert the values and write over the initial input*)
	formattedFieldValuePairs=AssociationMap[Constellation`Private`objValueToField[type, #] &,
		keyValuePairsToFormat];
	formattedFieldValuePairsWithMultiplesAsStrings=AssociationMap[stringifyMultipleFields[type, #] &, formattedFieldValuePairs];
	Join[objectResult, formattedFieldValuePairsWithMultiplesAsStrings]
];

stringifyMultipleFields[type:Constellation`Private`typeP, Rule[key:_Symbol, value:_]]:=Module[{valueWithNamesReferencedAndUnitsFormatted},
	(* don't do anything for non-multiple fields *)
	If[!MatchQ[Quiet[LookupTypeDefinition[type, key, Format]], Multiple], Return[Rule[ToString@key, value]]];
	If[MatchQ[value, _Constellation`Private`objValueToField], Return[Rule[key, Null]]];
	valueWithNamesReferencedAndUnitsFormatted=JSONConvertibleExpression@NamedObject@value;
	(* convert this to a string early, and remove the first and last bracket *)
	(* This should work because we're guaranteed atleast a {} with a multiple field *)
	ToString[key] -> StringTake[ToString@valueWithNamesReferencedAndUnitsFormatted, {2, -2}]
];

(*AddFavoriteObject*)

Authors[AddFavoriteObject]:={"platform"};

AddFavoriteObject[targetObjects:ListableP[ObjectP[]], folder:ObjectP[Object[Favorite, Folder]]]:=Module[
	{currFavObjects, favTargets, filteredTargetObjects, currFavTargetObjects, newTargets, existingFavObjects, existingFavObjectAuthors, packets, dateCreated},

	(* Filter out objects that are of type or of subtype of Object[Favorite] *)
	favTargets=Select[targetObjects, MatchQ[ObjectP[Object[Favorite]]]];
	filteredTargetObjects=Complement[targetObjects, favTargets];

	(* Get all favorite objects from folder, compare their target objects against the input targetObject list. *)
	currFavObjects=Download[folder, FavoriteObjects];
	labNotebook=Download[folder, Notebook];
	currFavTargetObjects=Download[currFavObjects, TargetObject];
	existingFavObjects=Pick[currFavObjects, MemberQ[Link[filteredTargetObjects], Link[#]] & /@ currFavTargetObjects ];
	packets={};

	(* For targetObjects already in the folder, add $PersonID to their Authors list if not already present. *)
	Map[
		Block[{},
			existingFavObjectAuthors=Download[#, Authors];
			If[!MemberQ[Link[existingFavObjectAuthors], Link[$PersonID]],
				obj=Download[Link[#], Object];
				AppendTo[packets, <|Object -> obj, Append[Authors] -> Link[$PersonID, FavoriteObjects] |>]
			]
		]&,
		existingFavObjects
	];

	(* For targetObjects not in the folder already, create a new favorite object and add to folder *)
	newTargets=Complement[filteredTargetObjects, Download[Link[currFavTargetObjects], Object]];
	dateCreated=Now;
	Map[AppendTo[packets, <|
		Type -> Object[Favorite],
		TargetObject -> Link[#],
		FavoriteFolder -> Link[folder, FavoriteObjects],
		Notebook -> Link[labNotebook, Objects],
		Append[Authors] -> {Link[$PersonID, FavoriteObjects]}
	|>]&, newTargets];

	(* Upload the list of favorite objects that were added or updated *)
	Upload[packets, ConstellationMessage -> {}];
];
(* ::Subsection::Closed:: *)
(* RemoveFavoriteFolder *)

Authors[EraseFavoriteFolder]:={"platform"};

EraseFavoriteFolder[folders:ListableP[ObjectP[Object[Favorite, Folder]]]]:=Module[{favObjectsToRemove},

	favObjectsToRemove=Download[folders, FavoriteObjects];
	If[!MatchQ[favObjectsToRemove, Null],
		EraseObject[PickList[favObjectsToRemove, DatabaseMemberQ[favObjectsToRemove]], Force -> True, Verbose -> False]];
	EraseObject[PickList[folders, DatabaseMemberQ[folders]], Force -> True, Verbose -> False];

];

(* Authors definition for ConstellationViewers`Private`formatTypesForJSON *)
Authors[ConstellationViewers`Private`formatTypesForJSON]:={"xu.yi"};


(* Authors definition for ConstellationViewers`Private`formatTypes *)
Authors[ConstellationViewers`Private`formatTypes]:={"xu.yi"};

