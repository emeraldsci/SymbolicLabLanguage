

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*mFileWrite*)

mFileWrite::FileAlreadyOpen="The package '`1`' cannot be modified because it is currently open. Please close the file and try again.";
mFileWrite::InvalidLines="The ending line number, `1` is greater than the number of lines in the provided file, `2`.";
mFileWrite::InvalidRange="The beginning of the insertion range, `1`, is greater than or equal to the end of the insertion range, `2`.";

mFileWrite[file_String,startPos:_Integer?Positive,endPos:_Integer?Positive,newLines:{_String..},ops:OptionsPattern[]] := Module[
	{fileLines,before,after,toWrite,fh},

	(* Find out whether Literature.m is already open, and return an error if so *)
	If[MemberQ[Quiet[NotebookFileName/@Notebooks[]],file],Return[Message[mFileWrite::FileAlreadyOpen,file]]];

	(* Read in the existing file *)
	fileLines = ReadList[file,Record,NullRecords->True];

	(* Make sure the provided line numbers are valid *)
	If[endPos>Length[fileLines],Return[Message[mFileWrite::InvalidLines,endPos,Length[fileLines]]]];
	If[endPos<=startPos,Return[Message[mFileWrite::InvalidRange,startPos,endPos]]];

	(* Isolate the stuff before and the stuff after the stuff you want to replace *)
	before = fileLines[[;;startPos]];
	after = fileLines[[endPos;;]];

	(* Assemble the block of text that will be written to the .m file *)
	toWrite = Join[before,newLines,after];

	(* Open the file for writing *)
	fh = OpenWrite[file];

	(* Write all lines of toWrite, adding newlines to the end of each *)
	WriteString[fh,StringJoin[(#<>"\n")&/@toWrite]];

	(* Close the file *)
	Close[fh];
];


(* ::Subsubsection::Closed:: *)
(*Helper function: validKeywordFormatQ*)


validKeywordFormatQ[keyword_] :=
	If[MatchQ[keyword,_String],StringMatchQ[keyword,((_?LowerCaseQ|DigitCharacter)..)~~(("_"|"-")~~(_?LowerCaseQ|DigitCharacter)..)...],False];

SetAttributes[validKeywordFormatQ,Listable];


(* ::Subsubsection::Closed:: *)
(*FindJournal*)

DefineOptions[FindJournal,
	Options :> {
		{ExactMatch -> False, BooleanP, "In cases where there is no exact match, determines whether the function will pop out a lookupDialog window or simply return 'JOURNAL LOOKUP FAILED'."}
	}];


FindJournal[jour:_String,ops:OptionsPattern[]] := Module[{safeOps,nearestStr,trimmed,currentJournalP,nearest,entry,dialogSize,headingStyle},
	(* Get those sweet safe options *)
	safeOps = OptionDefaults[FindJournal, ToList[ops]];

	(* Trim the input string to remove whitespace or punctuation *)
	trimmed = StringTrim[jour,(WhitespaceCharacter|"."|","|"_"|"-"|"!"|"?")...];

	(* Get a list of the journals currently listed in JournalP *)
	currentJournalP = List@@JournalP;

	(* If 'jour' already has an entry in JournalP or JournalConversions, return the raw or converted journal name *)
	If[MemberQ[currentJournalP,trimmed/.JournalConversions],
		Return[trimmed/.JournalConversions],

		If["ExactMatch"/.safeOps,
			(* If there's no exact match and ExactMatch\[Rule]True, return '$Failed' *)
			entry = $Failed,
			(* Allow the user to select a match from JournalP *)
			entry = lookupDialog[trimmed,currentJournalP,LibraryName->"JournalP"]
		]
	];

	(* Return *)
	entry

];


DefineOptions[
	lookupDialog,
	Options:>{
		{WindowSize->400,_Integer,"Specifies the size of the dialog window."},
		{HeadingStyle->{Bold,Underlined,14},StyleP|{StyleP..},"Specifies the style of the headings in the dialog window."},
		{LibraryName->"the provided library",_String,"Specifies the name of the library being searched, for cosmetic purposes."},
		{ValidityFunction->Function[True],_Function,"A function that can be used to determine whether user input is valid for the pattern expected in 'library'."}
	}
];

lookupDialog[item:_String,library:{_String..},ops:OptionsPattern[]] := Module[
	{safeOps,nearestStr,nearest,windowSize,headingStyle,libName,validityFunction},

	(* Get those sweet safe options *)
	safeOps = OptionDefaults[lookupDialog, ToList[ops]];
	validityFunction = "ValidityFunction"/.safeOps;
	Print[validityFunction];

	(* Check to see whether 'item' already exists in 'library', and return 'item' if it does *)
	If[MemberQ[library,item],Return[item]];

	(* Find the nearest ten matches for 'item' in 'library' *)
	nearest = nearestString[item,library,ComparisonFunction->SmithWatermanSimilarity,MaxResults->10];

	(* Define a couple of variables that will be used repeatedly to define sizes and styles *)
	windowSize = "WindowSize"/.safeOps;
	headingStyle = Sequence@@("HeadingStyle"/.safeOps);
	libName = "LibraryName"/.safeOps;

	(* Pop out a dialog for the user to choose the desired match to 'item' in 'library' *)
	EmeraldDialog[DynamicModule[{known=item,sel},
		Grid[{
			{Item[Style["No exact match was found in "<>libName<>" for:",Bold,Darker[Red],14],Alignment->Left],SpanFromLeft},
			{Pane[Style["'"<>item<>"'",Darker[Red],14],Alignment->Left,ImageSize->windowSize]},
			(*{},
			{Item[Style["Please find a match or add a new entry below.",Bold,Black,14],Alignment->Left],SpanFromLeft},*)
			{(* Empty line for spacing *)},
			{Panel[
				Grid[{
					{Item[Style["Please find a match or add a new entry below:",headingStyle],Alignment->Left]},
					{(* Empty line for spacing *)},
					{Item[InputField[Dynamic[known],String,ContinuousAction->True,FieldHint->"Search "<>libName],Alignment->Left],SpanFromLeft},
					{Item[Dynamic[With[{res=nearestString[known/.JournalConversions,library,ComparisonFunction->SmithWatermanSimilarity,MaxResults->10]},

							Grid[Join[
								{
									{Item[RadioButton[Dynamic[sel],item],ItemSize->1],Item[Style["Add original query: \""<>item<>"\"",Darker[Darker[Green]]],Alignment->Left]},
									{Item[RadioButton[Dynamic[sel],known],ItemSize->1],Item[Style["Add new custom entry: \""<>First@Dynamic[known]<>"\"",Darker[Darker[Green]]],Alignment->Left]}
								},
								If[Length[res]>0,Table[{Item[RadioButton[Dynamic[sel],res[[i]]],ItemSize->1],Item["\""<>res[[i]]<>"\"",Alignment->Left]},{i,1,Length[res]}],{}]
							]]

					]],Alignment->Left]},
					{},
					{Item[Grid[{{Item[Style["Selected entry: ",Bold],Alignment->Left,ItemSize->Full],Item[Style[Dynamic[sel],Darker[Blue]],Alignment->Left,ItemSize->Full]}}],Alignment->Left]}

				}]
			,ImageSize->windowSize]},
			{(* Empty line for spacing *)},
			{
				Grid[{{
					Item[Button["Confirm selection",EmeraldDialogReturn[sel],Enabled->Dynamic[validityFunction[sel]]],ItemSize->Full],
					Item[Button["Cancel",EmeraldDialogReturn[$Failed]],ItemSize->Full],
					Item[Button[Style["Google it!",Darker[Blue],Bold],SafeOpen["https://www.google.com/#q="<>item]],ItemSize->Full]
				}}]
			},
			{(* Empty line for spacing *)}
		}]
	],WindowSize->All,Background->White,KernelModal->True]

];


(* ::Subsubsection::Closed:: *)
(*nearestString*)


DefineOptions[nearestString,
	Options :> {
		{Unique -> False, BooleanP, "When set to True, will return only one of the nearest strings in the library rather than a list of nearest strings."},
		{MaxResults -> {1}, _Integer?Positive | {_Integer?Positive}, "Specifies how many of the top matches should be returned. A levelspec, 'L', will return the top L levels, while an integer, 'N', will return the top N results overall."},
		{ComparisonFunction -> SmithWatermanSimilarity, SmithWatermanSimilarity | EditDistance | DamerauLevenshteinDistance | NeedlemanWunschSimilarity | HammingDistance, "Which string comparison function should be used to determine the best matches."},
		{IgnoreCase -> True, BooleanP, "Determines whether or not case is taken into account when string similarity/distance is calculated."}
	}];

nearestString::NotUnique="The Unique Option is active and more than one string has been found nearest to the input.  Will choose only the first of these possibilities.";


(* --- Core Definiition --- *)
nearestString[str_String,library:{_String..},ops:OptionsPattern[nearestString]]:=Module[
{grouped,safeOps,compFcn,distancePairs,groupedAndSorted,results},

	(* Safely extract the options *)
	safeOps=OptionDefaults[nearestString, ToList[ops]];

	(* Define the comparison function based on whether it measures similarity or distance *)
	compFcn = Switch[ToString["ComparisonFunction"/.safeOps],

		(* Apply distance functions straight-up *)
		_?(StringMatchQ[#,(___~~"Distance")]&),
			(("ComparisonFunction"/.safeOps)[#1,#2,IgnoreCase->("IgnoreCase"/.safeOps)]&),

		(* Take the inverse of similarity functions, so sort order is the same as for distance functions *)
		_?(StringMatchQ[#,(___~~"Similarity")]&),
			(1/(("ComparisonFunction"/.safeOps)[#1,#2,IgnoreCase->("IgnoreCase"/.safeOps)])&)
	];

	(* Determine the distance from str to each string in the library and pair them with the string in the library *)
	(* Quiet to avoid DivideByZero errors *)
	distancePairs={#,Quiet@compFcn[str,#]}&/@library;

	(* Sort by distance (low to high) and then group *)
	groupedAndSorted=GatherBy[SortBy[distancePairs,Last],Last]/.{s_String,_?InfiniteNumericQ|ComplexInfinity}:>s;

	(* Decide which results to return based on the MaxResults option *)
	results = If[Length["MaxResults"/.safeOps]>0,

		(* If MaxResults is a levelspec, return the first N levels *)
		Flatten[groupedAndSorted[[;;Min[Length[groupedAndSorted],First["MaxResults"/.safeOps]]]]],

		(* If MaxResults has been specified, give that number of results (or everything, if MaxResults is greater in length than Library) *)
		Flatten[groupedAndSorted][[;;Min[Length[Flatten[groupedAndSorted]],"MaxResults"/.safeOps]]]
	];

	(* Throw an error message if Unique is on and there are more than one results *)
	If[("Unique"/.safeOps)&&Length[results]>1,Message[nearestString::NotUnique]];

	(* If unique is on pull out only the first, otherwise return all of the results *)
	If[("Unique"/.safeOps),
		results/.{x_,___}:>x,
		results
	]
];
Authors[nearestString]:={"scicomp", "brad"};
nearestString[strs:{_String..},library:{_String..},ops:OptionsPattern[nearestString]]:=
	Map[nearestString[#,library,ops]&,strs];

nearestString[str_String,libraries:{{_String..}..},ops:OptionsPattern[nearestString]]:=
	Map[nearestString[str,#,ops]&,libraries];


(* Overload to allow for finding of nearest strings in a grouped-multiple configuration, so that the strings found can be returned with associated information *)

nearestString[str_String,library:{{___,_String,___}..},pos_Integer,ops:OptionsPattern[nearestString]] := Module[
	{safeOps,compFcn,distancePairs,groupedAndSorted,results},

	(* Safely extract the options *)
	safeOps=OptionDefaults[nearestString, ToList[ops]];

	(* Define the comparison function based on whether it measures similarity or distance *)
	compFcn = Switch[ToString["ComparisonFunction"/.safeOps],

		(* Apply distance functions straight-up *)
		_?(StringMatchQ[#,(___~~"Distance")]&),
			(("ComparisonFunction"/.safeOps)[#1,#2,IgnoreCase->("IgnoreCase"/.safeOps)]&),

		(* Take the inverse of similarity functions, so sort order is the same as for distance functions *)
		_?(StringMatchQ[#,(___~~"Similarity")]&),
			(1/(("ComparisonFunction"/.safeOps)[#1,#2,IgnoreCase->("IgnoreCase"/.safeOps)])&)
	];

	(* Determine the distance from str to each string in the library and pair them with the string in the library *)
	(* Quiet to avoid DivideByZero errors *)
	distancePairs={#,Quiet@compFcn[str,#[[pos]]]}&/@library;

	(* Sort by distance (low to high) and then group *)
	groupedAndSorted=GatherBy[SortBy[distancePairs,Last],Last]/.{s:{___,_String,___},_?InfiniteNumericQ|ComplexInfinity}:>s;

	(* Decide which results to return based on the MaxResults option *)
	results = If[Length["MaxResults"/.safeOps]>0,

		(* If MaxResults is a levelspec, return the first N levels *)
		Flatten[groupedAndSorted[[;;Min[Length[groupedAndSorted],First["MaxResults"/.safeOps]]]],1],

		(* If MaxResults has been specified, give that number of results (or everything, if MaxResults is greater in length than Library) *)
		Flatten[groupedAndSorted,1][[;;Min[Length[Flatten[groupedAndSorted,1]],"MaxResults"/.safeOps]]]
	];

	(* Throw an error message if Unique is on and there are more than one results *)
	If[("Unique"/.safeOps)&&Length[results]>1,Message[nearestString::NotUnique]];

	(* If unique is on pull out only the first, otherwise return all of the results *)
	If[("Unique"/.safeOps),
		results/.{x_,___}:>x,
		results
	]
];

(* ::Subsubsection::Closed:: *)
(*FindKeyword*)

DefineOptions[FindKeyword,
	Options :> {
		{ExactMatch -> False, BooleanP, "In cases where there is no exact match, determines whether the function will pop out a lookupDialog window or simply return 'KEYWORD LOOKUP FAILED'."}
	}];


FindKeyword[word:_String,ops:OptionsPattern[]] := Module[{safeOps,nearestStr,trimmed,currentKeywordP,nearest,entry,dialogSize,headingStyle},

	(* Get those sweet safe options *)
	safeOps = OptionDefaults[FindKeyword, ToList[ops]];

	(* Trim the input string to remove whitespace or punctuation *)
	trimmed = StringTrim[word,(WhitespaceCharacter|"."|","|"_"|"-"|"!"|"?")...];

	(* Get a list of the journals currently listed in JournalP *)
	currentKeywordP = List@@KeywordP;

	(* If 'jour' already has an entry in JournalP or JournalConversions, return the raw or converted journal name *)
	If[MemberQ[currentKeywordP,trimmed],
		Return[trimmed],

		If["ExactMatch"/.safeOps,
			(* If there's no exact match and ExactMatch\[Rule]True, return 'JOURNAL LOOKUP FAILED' *)
			entry = $Failed,
			(* Allow the user to select a match from KeywordP *)
			entry = lookupDialog[trimmed,currentKeywordP,LibraryName->"KeywordP",ValidityFunction->(validKeywordFormatQ[#]&)]
		]
	];

	(* Return *)
	entry
];