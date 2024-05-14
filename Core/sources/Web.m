(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Web.m*)


(* ::Subsection::Closed:: *)
(*PageSections*)

findObjectPage[{}]:={};
findObjectPage[objects:{ObjectP[]..}]:=Module[
	{searchResults, sortedSearchResults},

	searchResults=Search[
		Apply[Sequence,
			Transpose@Map[{{Object[Notebook, Page], Object[Notebook, Script]}, Contents == #} &, objects]
		]
	];

	(* Sort each set of search results in reverse alphabetical order by Type to ensure that scripts show up first *)
	sortedSearchResults=Reverse[SortBy[#, Most]]& /@ searchResults;

	(* Take the first script or notebook from each set of results *)
	First[#, Null]& /@ sortedSearchResults
];
findObjectPage[object:ObjectP[]]:=First[findObjectPage[{object}], Null];

sectionPath[object:ObjectP[], sections:(_Association | Null)]:=Module[{objectPosition},

	If[
		MatchQ[sections, Null],
		Return[{}]
	];

	(* Find the position of our object in the page -- sections now have the form <|"Objects"->_,"BookmarkUpdates"->_"Sections"-> UUID-><|"Style"->_,"Text"->_, "CellID"->_,"Objects"->_,"BookmarkObjects"->_,"Sections"-> (UUID-> _Association).. |>|> with recursive sections. So this is going to return something along the lines of {(Key["Sections"],Key[UUID])..,Key["Objects"],_Integer}. The (Sections,UUID) part will repeat for however deep we are going. We will recursively look them up below to get the titles *)
	objectPosition=FirstPosition[sections, ToString[object, InputForm], Infinity];

	(* Return if object doesn't exist*)
	If[
		MatchQ[objectPosition, _Missing],
		Return[{}]
	];

	(* Recursively lookup the position and collect section titles along the way *)
	Flatten[Last[Reap[
		Fold[
			Function[
				{association, key},
				Module[{value},

					(* Get the value of the key we need *)
					value=Lookup[association, key];

					(* If we have a key like Sections or Objects, or we have a print cell, which doesn't have a title, just return the value of the association for the next round; otherwise save the title name and return the association *)
					If[
						MatchQ[key, Key["Sections" | "Objects"]] || MatchQ[Lookup[value, "Style"], "Print"],
						value,
						Module[{},
							Sow[Lookup[value, "Text"], sectionPath];
							value
						]
					]
				]
			],
			sections,
			Most[objectPosition]
		],
		sectionPath
	]]]
];

PageSections::InvalidJSONSections="The page `1` has invalid SectionJSON";
PageSections[{}]:={};
PageSections[objects:{ObjectReferenceP[]..}]:=Module[
	{pages, decodedSectionsJSON},

	pages=findObjectPage[objects];
	decodedSectionsJSON=decodeSectionJSON[pages];
	MapThread[
		Function[{pageObject, object, sectionJSONDecoded},
			Prepend[sectionPath[object, sectionJSONDecoded], If[pageObject === Null, Nothing, pageObject]]
		],
		{
			pages,
			objects,
			decodedSectionsJSON
		}
	]
];
PageSections[object:ObjectP[]]:=First[PageSections[{object}], Null];

(* does a de-duplication of pages so we do not do extra decoding. for each page it returns either
an decoded sections association or Null if the sections could not be parsed. *)
decodeSectionJSON[pages:{(ObjectReferenceP[{Object[Notebook, Page], Object[Notebook, Script]}] | Null)...}]:=Module[
	{deduplicatePages, rawSectionJSONs, sanitizedSectionJSONs, resultByPage},

	deduplicatePages=DeleteDuplicates[pages];

	(* Download both the standard SectionsJSON that appears in notebook pages, and the split Template and Instance SectionsJSON fields that appear in scripts 
		For Object[Notebook, Script]s, the equivalent of SectionsJSON can be reconstructed by joining the decoded Template and Instance SectionsJSON fields *)
	rawSectionJSONs=Quiet[
		Download[deduplicatePages, {SectionsJSON, TemplateSectionsJSON, InstanceSectionsJSON}],
		{Download::FieldDoesntExist}
	];

	(* Remove $Failed entries from whichever sections JSON fields above do not exist in each object, as well as any entries that are Null 
		Should now be left with {base64EncodedJSON...}*)
	sanitizedSectionJSONs=DeleteCases[rawSectionJSONs, ($Failed | Null), {2}];

	resultByPage=MapThread[
		Function[{page, encodedSectionJSON},
			page -> If[MatchQ[encodedSectionJSON, {Null..} | {""..} | {}],
				Null,
				(* else *)
				(* Join each list one or more decoded JSON associations to get a single decoded page sections assoc for each input *)
				Module[{rawDecoded},

					(* Decode each of the (possibly multiple) sections *)
					rawDecoded=decodeBase64StringToAssociation[#]& /@ encodedSectionJSON;

					If[MemberQ[rawDecoded, $Failed] || MemberQ[rawDecoded, _ImportByteArray],
						(* If decoding of any sections failed, display an error message and return Null *)
						(
							Message[PageSections::InvalidJSONSections, page];
							Null
						),
						(* Else, join all decoded sections *)
						Join @@ rawDecoded
					]
				]
			]
		],
		{deduplicatePages, sanitizedSectionJSONs}
	];

	Lookup[resultByPage, pages]
];

(* Import/Export of Base64 encoded/decoded json data to usable associations, primarily with SectionsJSON *)
(* Note: When possible these functions should be used over ExportJSON/ExportString/ImportString *)
decodeBase64StringToAssociation[string_String]:=Module[{},
	If[MatchQ[string, ""], Return[$Failed]];
	ImportByteArray[decodeBase64StringToByteArray[string], "RawJSON"]
];

encodeAssociationToBase64String[association_Association]:=Module[{byteArray},
	byteArray=exportAssociationToByteArray[ECL`AppHelpers`JSONConvertibleExpression[association]];
	encodeByteArrayToBase64String[byteArray]
];

(* Import/Export of json data to usable associations *)
DefineOptions[ExportAssociationToJSON,
	Options :> {
		{PrettyOutput -> False, BooleanP, "Indicates if the output should be a reindented JSON."}
	}
];

ExportAssociationToJSON[association_Association, ops:OptionsPattern[]]:=Module[{safeOps, byteArray},
	safeOps=SafeOptions[ExportAssociationToJSON, ToList[ops]];
	byteArray=exportAssociationToByteArray[ECL`AppHelpers`JSONConvertibleExpression[association]];
	If[TrueQ[Lookup[safeOps, PrettyOutput]],
		ByteArrayToString[byteArray],
		byteArrayToStrippedString[byteArray]
	]
];

ImportJSONToAssociation[string_String]:=Module[{sanitizedString},
	sanitizedString = StringReplace[
		string,
		Alternatives @@ AppHelpers`Private`$MMSpecialCharacters :> ""
	];
	If[MatchQ[string, ""], Return[$Failed]];
	ImportByteArray[StringToByteArray[sanitizedString], "RawJSON"]
];

(* String versions of passing around json data *)
DefineOptions[decodeBase64StringToString,
	Options :> {
		{PrettyOutput -> False, BooleanP, "Indicates if the output should be a reindented JSON."}
	}
];

decodeBase64StringToString[string_String, ops:OptionsPattern[]]:=Module[{safeOps, byteArray},
	If[MatchQ[string, ""], Return[$Failed]];
	safeOps=SafeOptions[decodeBase64StringToString, ToList[ops]];
	byteArray=decodeBase64StringToByteArray[string];
	If[TrueQ[Lookup[safeOps, PrettyOutput]],
		ByteArrayToString[byteArray],
		byteArrayToStrippedString[byteArray]
	]
];

encodeStringToBase64String[string_String]:=Module[{byteArray},
	If[MatchQ[string, ""], Return[$Failed]];
	byteArray=StringToByteArray[string];
	encodeByteArrayToBase64String[byteArray]
];

(* Internal utility functions for import/export consistency *)

byteArrayToStrippedString[byteArray_ByteArray]:=Module[{},
	StringDelete[ByteArrayToString[byteArray], "\n" | "\t" | "\r"]
];

exportAssociationToByteArray[association_Association]:=Module[{byteArray},
	byteArray=Quiet[ExportByteArray[association, "RawJSON"]];
	byteArray=If[MatchQ[byteArray, $Failed],
		Quiet[ExportByteArray[association, "JSON"]],
		byteArray
	]
];

decodeBase64StringToByteArray[string_String]:=Module[{},
	If[MatchQ[string, ""], Return[$Failed]];
	BaseDecode[string]
];

encodeByteArrayToBase64String[byteArray_ByteArray]:=Module[
	{},
	BaseEncode[byteArray]
];

(* Authors definition for Core`Private`sectionPath *)
Authors[Core`Private`sectionPath]:={"scicomp", "brad"};
