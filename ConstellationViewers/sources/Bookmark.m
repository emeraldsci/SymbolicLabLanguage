(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)
(*BookmarkObject*)

Authors[BookmarkObject]:={"platform", "padmaja.nadkarni"};

Error::NoCellFound="There is no cell for given BookmarkLocationIdentifier `1`. Please verify given inputs and try again.";
Error::NoLaboratoryNotebook="There is no $Notebook variable set to current laboratory notebook. Please verify given inputs and try again.";
Error::CouldNotUploadBookmark="Could not upload the provided object(s) as bookmark(s). Please verify given inputs and try again.";
Error::NoBookmarkLocationIdentifier="BookmarkLocationIdentifier cannot be empty. Please verify given inputs and try again.";

PrintBookmarkObjectMessageCell[targetObjects:ListableP[ObjectP[]], notebook_NotebookObject, uuid_String, bookmarkObjectIds_List]:=Module[
	{newCell, runningAScript},
	newCell=With[{insertMe=Constellation`Private`bookmarkImage[$ConstellationIconSize]},
		Cell[
			BoxData[
				MakeBoxes[
					Row[{
						insertMe,
						Spacer[10],
						"Following objects will be marked as bookmarks:",
						Spacer[10],
						Short[targetObjects],
						Spacer[10],
						Button[Mouseover["(Copy IDs)", Style["(Copy IDs)", Bold]], CopyToClipboard[targetObjects], Appearance -> None, BaseStyle -> "Hyperlink"]
					}]
				]
			],
			"Print",
			ExpressionUUID -> uuid,
			CellTags -> bookmarkObjectIds
		]
	];
	If[Packager`Private`isPrivateCloud[],
		(* TODO: Revisit once CloudCommandCenter has support for currently skipped: $FrontEnd and SelectAfterCell *)
		CellPrint[newCell],
		runningAScript=Not@MatchQ[notebook, EvaluationNotebook[]];
		If[runningAScript,
			Quiet[
				(* Move to the end of the past notebook. *)
				UsingFrontEnd[SelectionMove[notebook, After, Notebook]];
				(* Insert our message. *)
				UsingFrontEnd[NotebookWrite[notebook, newCell]];,
				{FrontEndObject::notavail}
			],
			Quiet[
				UsingFrontEnd[
					CellPrint[newCell];
				],
				{FrontEndObject::notavail}
			];
		];
	];
];

DefineOptions[
	BookmarkObject,
	Options :> {
		{Status -> Inactive, Active | Inactive, "Whether or not to make bookmark for the target object active."}
	}
];

$outputNotebook=Null;

defaultNotebookToPrintBookmarks[]:=If[
	(* there is no evaluation notebook in Engine *)
	NullQ[$outputNotebook],
	EvaluationNotebook[],
	$outputNotebook
];


BookmarkObject[targetObject:ObjectP[], ops:OptionsPattern[]]:=BookmarkObject[{targetObject}, ops];

BookmarkObject[targetObjects:{ObjectP[]...}, ops:OptionsPattern[]]:=Module[{bookmarkLocationIdentifier, notebook, bookmarkPath},
	bookmarkLocationIdentifier=CreateUUID[];
	notebook=Quiet[defaultNotebookToPrintBookmarks[], {FrontEndObject::notavail}];
	bookmarkPath="";
	BookmarkObject[targetObjects, notebook, bookmarkPath, bookmarkLocationIdentifier, ops]
];

BookmarkObject[targetObjects:{ObjectP[]...}, notebook_NotebookObject, ops:OptionsPattern[]]:=Module[{bookmarkLocationIdentifier, bookmarkPath},
	bookmarkLocationIdentifier=CreateUUID[];
	bookmarkPath="";
	BookmarkObject[targetObjects, notebook, bookmarkPath, bookmarkLocationIdentifier, ops]
];

BookmarkObject[targetObjects:{ObjectP[]...}, notebook_NotebookObject, bookmarkPath_String, ops:OptionsPattern[]]:=Module[{bookmarkLocationIdentifier},
	bookmarkLocationIdentifier=CreateUUID[];
	BookmarkObject[targetObjects, notebook, bookmarkPath, bookmarkLocationIdentifier, ops]
];

BookmarkObject[targetObjects:{ObjectP[]...}, notebook_NotebookObject, bookmarkPath_String, bookmarkLocationIdentifier_String, ops:OptionsPattern[]]:=Module[
	{packets, bookmarkObjectIds, bookmarkObjects, safeOps, status, dedupedTargetObjects},
	If[Or[!Constellation`Private`enableAutomaticBookmarks, NullQ[notebook]],
		Return[]
	];

	If[!MatchQ[$Notebook, ObjectP[Object[LaboratoryNotebook]]],
		Message[Error::NoLaboratoryNotebook];
		Return[$Failed]
	];

	If[MatchQ[bookmarkLocationIdentifier, ""] || MatchQ[bookmarkLocationIdentifier, Null],
		Message[Error::NoBookmarkLocationIdentifier];
		Return[$Failed]
	];

	(* Grab the status option *)
	safeOps=OptionDefaults[BookmarkObject, ToList[ops]];
	status=Lookup[safeOps, "Status"];

	(* Dedup target objects before bookmarking *)
	dedupedTargetObjects=DeleteDuplicates[ToList[targetObjects]];
	bookmarkObjects={};
	packets={};
	Map[AppendTo[packets, <|
		Type -> Object[Favorite, Bookmark],
		Status -> status,
		BookmarkPath -> bookmarkPath,
		BookmarkLocationIdentifier -> bookmarkLocationIdentifier,
		TargetObject -> Link[#],
		Notebook -> Link[$Notebook, Objects],
		Append[Authors] -> {Link[$PersonID, FavoriteObjects]}
	|>]&, dedupedTargetObjects];

	(* Create bookmark objects, but suppress the object creation messages. We will instead show the target object ids
	   later in a new message cell *)
	bookmarkObjects=Upload[packets, ConstellationMessage -> {}];
	If[MatchQ[bookmarkObjects, $Failed],
		Message[Error::CouldNotUploadBookmark];
		Return[$Failed]
	];
	bookmarkObjectIds=Download[bookmarkObjects, ID];
	PrintBookmarkObjectMessageCell[dedupedTargetObjects, notebook, bookmarkLocationIdentifier, bookmarkObjectIds]
];

(* GetAbstractFields *)

Authors[GetAbstractFields]:={"platform", "padmaja.nadkarni"};

getAbstractFields[type:TypeP[]]:=Keys[Select[ECL`Fields /. LookupTypeDefinition[type], MemberQ[Last[#], Abstract -> True]&]];

GetAbstractFields[types:{} | ListableP[TypeP[]]]:=
	Module[{result, fields},
		result=<||>;

		If[Length[types] > 0,
			(* Loop over each type and retrieve list of abstract fields and add to association *)
			Map[With[{type=#},
				fields=getAbstractFields[type];
				result[type]=fields;
			]&, ToList[types]];
		];

		ExportAssociationToJSON[result]
	];

(* GetBookmarkObjects *)
Authors[GetBookmarkObjects]:={"platform"};

GetBookmarkObjects[
  notebook : ObjectP[{Object[Notebook, Page], Object[Notebook, Script], Object[Notebook, Function]}]
] := Module[
  {labNotebook, bookmarks, bookmarkPaths},
  labNotebook = Quiet@notebook[Notebook];
	If[MatchQ[labNotebook, $Failed], Return[{}]];
  bookmarks = Quiet@Download[
	  Search[
  	  Object[Favorite, Bookmark],
      Notebook == labNotebook && Length[BookmarkPath] > 0
    ],
    {TargetObject, BookmarkPath}
  ];
	If[MatchQ[bookmarks, $Failed], Return[{}]];
  bookmarkPaths = Quiet@<|
		"Path" -> BaseDecode[#[[2]]],
    "TargetObject" -> #[[1]]
	|>& /@ bookmarks;
  bookmarkPaths = If[MatchQ[Lookup[#, "Path"], _ByteArray], #, Nothing]& /@ bookmarkPaths;
  bookmarkPaths = <|
  	"Nob" -> Quiet@
			ToExpression[
				Lookup[
					ImportJSONToAssociation[
						ByteArrayToString[Lookup[#, "Path"]]
					],
					"NobSllId"
				]
			],
      "TargetObject" -> Lookup[#, "TargetObject"]
		|> & /@ bookmarkPaths;
  bookmarkPaths = If[MatchQ[Lookup[#, "Nob", $Failed], $Failed], Nothing, #]& /@ bookmarkPaths;
  If[Lookup[#, "Nob"][ID] == notebook[ID], Lookup[#, "TargetObject"], Nothing]& /@ bookmarkPaths
];
