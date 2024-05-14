(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* setupLaboratoryNotebook helper function *)
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

(*BookmarkObject*)

DefineTests[
	BookmarkObject,
	{
		Example[{Basic, "Create bookmark for a target object when notebook is not provided:"},
			With[{nbObj=CreateDocument[{TextCell["Text cell 1"], TextCell["Text cell 2"]}]},
				Module[{randomStr, labNotebook, testSample},
					randomStr=ToString[RandomReal[]];
					(* create laboratory  notebook object *)
					labNotebook=setupLaboratoryNotebook[randomStr];
					testSample=
						Upload[<|Type -> Object[Sample], DeveloperObject -> True,
							Name -> "Test sample for BookmarkObject "<>randomStr |>];
					{
						Block[{$Notebook=labNotebook},
							BookmarkObject[{testSample}]
						],
						Search[Object[Favorite, Bookmark], Notebook == labNotebook],
						NotebookClose[nbObj]
					}
				]
			],
			{Null, {ObjectP[Object[Favorite, Bookmark]]}, Null}
		],
		Example[{Basic, "Create bookmark for a target object when cell UUID is not specified:"},
			With[{nbObj=CreateDocument[{TextCell["Text cell 1"], TextCell["Text cell 2"]}]},
				Module[{randomStr, labNotebook, testSample},
					randomStr=ToString[RandomReal[]];
					(* create laboratory  notebook object *)
					labNotebook=setupLaboratoryNotebook[randomStr];
					testSample=
						Upload[<|Type -> Object[Sample], DeveloperObject -> True,
							Name -> "Test sample for BookmarkObject "<>randomStr |>];
					{
						Block[{$Notebook=labNotebook},
							BookmarkObject[{testSample}, nbObj, "notebook>page>section"]
						],
						Search[Object[Favorite, Bookmark], Notebook == labNotebook],
						NotebookClose[nbObj]
					}
				]
			],
			{Null, {ObjectP[Object[Favorite, Bookmark]]}, Null}
		],
		Example[{Basic, "Create bookmark for a target object when cell UUID is specified:"},
			With[{nbObj=CreateDocument[{TextCell["Text cell 1"], TextCell["Text cell 2"]}]},
				Module[{randomStr, labNotebook, testSample},
					randomStr=ToString[RandomReal[]];
					(* create laboratory  notebook object *)
					labNotebook=setupLaboratoryNotebook[randomStr];
					testSample=
						Upload[<|Type -> Object[Sample], DeveloperObject -> True,
							Name -> "Test sample for BookmarkObject "<>randomStr |>];
					{
						Block[{$Notebook=labNotebook},
							BookmarkObject[{testSample}, nbObj, "notebook>page>section", CreateUUID[]]
						],
						Search[Object[Favorite, Bookmark], Notebook == labNotebook],
						NotebookClose[nbObj]
					}
				]
			],
			{Null, {ObjectP[Object[Favorite, Bookmark]]}, Null}
		],
		Example[{Options, Status, "Status specifies if the bookmark object's status should be set as Active or Inactive:"},
			With[{nbObj=CreateDocument[{TextCell["Text cell 1"], TextCell["Text cell 2"]}]},
				Module[{randomStr, labNotebook, testSample},
					randomStr=ToString[RandomReal[]];
					(* create laboratory  notebook object *)
					labNotebook=setupLaboratoryNotebook[randomStr];
					testSample=
						Upload[<|Type -> Object[Sample], DeveloperObject -> True,
							Name -> "Test sample for BookmarkObject "<>randomStr |>];
					{
						Block[{$Notebook=labNotebook},
							BookmarkObject[{testSample}, Status -> Active]
						],
						Download[Search[Object[Favorite, Bookmark], Notebook == labNotebook], Status],
						NotebookClose[nbObj]
					}
				]
			],
			{Null, {Active}, Null}
		],
		Example[{Messages, "NoLaboratoryNotebook", "Returns $Failed if $Notebook cannot be fetched:"},
			{
				Module[{randomStr, labNotebook, nbObj, testSample},
					randomStr=ToString[RandomReal[]];
					(* create laboratory  notebook object *)
					labNotebook=setupLaboratoryNotebook[randomStr];
					(* Call bookmarkobject without $Notebook *)
					nbObj=CreateDocument[];
					testSample=
						Upload[<|Type -> Object[Sample], DeveloperObject -> True,
							Name -> "Test sample for BookmarkObject "<>randomStr |>];
					BookmarkObject[{testSample}, nbObj, "notebook>page>section", "cell"]]
			},
			{$Failed},
			Messages :> {Message[Error::NoLaboratoryNotebook]},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				NotebookClose[nbObj];
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		]
	}
];

(* ::Subsubsection::Closed:: *)

(*GetAbstractFields*)

DefineTests[
	GetAbstractFields,
	{
		Example[{Basic, "Given a SLL type verify that fields with Abstract -> True are returned:"},
			{
				GetAbstractFields[Object[LaboratoryNotebook]]
			},
			{
				ExportAssociationToJSON[Association[Object[LaboratoryNotebook] -> {Name, Financers, Public}]]
			}
		],
		Example[{Additional, "Given a list of SLL types verify that fields with Abstract -> True are returned for those types:"},
			{
				GetAbstractFields[{Object[LaboratoryNotebook], Object[Team, Financing]}]
			},
			{
				ExportAssociationToJSON[Association[Object[LaboratoryNotebook] -> {Name, Financers, Public}, Object[Team, Financing] -> {Name, Website, Status, Backlog, Queue, DefaultExperimentSite}]]
			}
		],
		Example[{Additional, "If subtype does not have abstract fields defined on it, returns supertype or default abstract fields:"},
			{
				GetAbstractFields[Model[Software]]
			},
			{
				ExportAssociationToJSON[Association[Model[Software] -> {Name}]]
			}
		],
		Test["An empty list returns a valid JSON response:",
			GetAbstractFields[{}],
			"{}"
		]
	}
];

(* ::Subsubsection::Closed:: *)

(*GetBookmarkObjects*)

DefineTests[
	GetBookmarkObjects,
	{
		Test["A notebook page returns a list of bookmarked objects",
			Module[{labNotebook, nobPage},
				labNotebook = (Search[Object[Favorite, Bookmark], Status == Active && Length[Notebook[Pages]] > 0, MaxResults -> 1] // First)[Notebook];
				nobPage = Search[Object[Notebook, Page], Notebook == labNotebook] // First;
				MatchQ[GetBookmarkObjects[nobPage], _List]
			],
			True
		],
		Test["A notebook page returns at least one bookmarked object.",
			Module[
			{bookmark, nobSllId},
				bookmark = (Search[Object[Favorite, Bookmark], Status == Active && BookmarkPath != Null && BookmarkPath != "", MaxResults -> 1] // First);
				nobSllId = ToExpression[
					ImportJSONToAssociation[
						Core`Private`decodeBase64StringToString[
							bookmark[BookmarkPath]
							]
						]
						["NobSllId"]
					];
				Length[GetBookmarkObjects[nobSllId]] > 0
			],
			True
		],
		Test["An empty list returns when the notebook does not exist",
			GetBookmarkObjects[Object[Notebook, Page, "id:ThisIsNotReal"]],
			{}
		]
	}
];

(* ::Subsubsection::Closed:: *)
