(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

(* Unset $MessagePrePrint so that messages no longer get shortened. *)
Unset[$MessagePrePrint];

(* ::Subsection::Closed:: *)
(*Session Constants*)


(* ::Subsubsection::Closed:: *)
(*$ECLApplication*)

If[!ValueQ[$ECLApplication],
	$ECLApplication = Mathematica;
];

$CCD := SameQ[$ECLApplication, Mathematica] && $VersionNumber > 12.1;


(* ::Subsubsection::Closed:: *)
(*$AllowSystemsProtocols*)


(* If $AllowSystemsProtocols is set to True, UploadProtocol will allow protocols with no Notebook to be queued *)
$AllowSystemsProtocols=False;


(* ::Subsubsection::Closed:: *)
(*$PassColor*)


(* Color scheme for when things are passing. Used in Metrics  *)
$PassColor=RGBColor[{34, 184, 147} / 255.];


(* ::Subsubsection::Closed:: *)
(*$WarningColor*)


(* Color scheme for when a warning alert needs to be issued. Used in Metrics  *)
$WarningColor=RGBColor[{245, 224, 35} / 255.];


(* ::Subsubsection::Closed:: *)
(*$ErrorColor*)


(* Color scheme for when something is in Error. Used in Metrics  *)
$ErrorColor=RGBColor[{253, 132, 132} / 255.];


(* ::Subsubsection::Closed:: *)
(*$TextColor*)


(* Color scheme for displaying text. Used in Metrics  *)
$TextColor=RGBColor[{55, 59, 66} / 255.];


(* ::Subsection::Closed:: *)
(*Function Writing Functions*)


(* ::Subsubsection::Closed:: *)
(*overload*)


(* map over redirects *)
overload[parentSymbol_Symbol, redirectList:{Rule[_, _Symbol]...}]:=overload[parentSymbol, #]& /@ redirectList;

(* base definition *)
overload[parentSymbol_Symbol, Rule[indicator_, childSymbol_Symbol]]:=Module[{oldParentDefinitions, childDefinitions},

	oldParentDefinitions=DownValues[parentSymbol];

	(* parse out definitions for child function *)
	childDefinitions=Replace[
		Replace[
			DownValues[childSymbol][[;;, 1]],
			HoldPattern -> Hold,
			{2},
			Heads -> True
		],
		childSymbol -> PatternSequence,
		{3},
		Heads -> True
	];

	(* write new definitions *)
	Map[
		With[
			{argIn=Pattern @@ Prepend[#, allArguments]},
			ReplacePart[Hold[parentSymbol[indicator, argIn], childSymbol[allArguments]], 0 -> SetDelayed]
		]&,
		childDefinitions
	];

	(* new definitions *)
	Complement[DownValues[parentSymbol], oldParentDefinitions]

];


(* ::Subsection::Closed:: *)
(*File Finding & Manipulation*)


(* ::Subsubsection::Closed:: *)
(*FastExport*)


DefineOptions[FastExport,
	Options :> {
		{CharacterEncoding -> Automatic, Alternatives @@ (Append[$CharacterEncodings, "Unicode"]), "What raw encoding to use for characters written to the file."},
		{BinaryFormat -> False, BooleanP, "Whether to use binary format for the file."},
		{CSVTextDelimiter -> Automatic, Automatic | _String, "Item separator passed to Export as \"TextDelimiter\" (defaulting to quotes)."}
	}
];

FastExport[myFilePath:FilePathP, myContent_, myFileType:FastFileTypeP, ops:OptionsPattern[FastExport]]:=Module[
	{safeOps, parentDir, outputStream, csvQuote},

	(* Get all options and verify the match patterns *)
	safeOps=SafeOptions[FastExport, ToList[ops]];

	csvQuote=Lookup[safeOps, CSVTextDelimiter, None];

	(* If the directory doesn't exist, make the file directory first. *)
	parentDir=DirectoryName[myFilePath];

	If[!DirectoryQ[parentDir],
		CreateDirectory[parentDir, CreateIntermediateDirectories -> True]
	];

	(* OpenWrite or Export file based on the specified file type *)
	(* OpenWrite has been shown to be somewhat faster for text files, so use it in those cases *)
	If[myFileType === "Text",
		(
			(* Create file if it does not already exist *)
			Quiet[CreateFile[myFilePath], {CreateFile::filex, CreateFile::eexist}];

			(* Open the stream to which the string will be written *)
			outputStream=OpenWrite[myFilePath, PassOptions[OpenWrite, safeOps]];

			(* Write input string to steam *)
			WriteString[outputStream, myContent];

			(* Close stream *)
			Close[outputStream];

			(* Return filepath *)
			myFilePath
		),
		If[myFileType === "CSV" && MatchQ[csvQuote, _String],
			Export[myFilePath, myContent, myFileType, "TextDelimiters" -> csvQuote],
			Export[myFilePath, myContent, myFileType]
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*FastImport*)


DefineOptions[FastImport,
	Options :> {
		{Retries -> 0, GreaterP[0, 1], "Indicates the number of attempts that should be made to try and detect the file."},
		{RetryDelay -> 3 Second, GreaterP[0 Second], "Indicates the length of time to pause before trying to locate the file, if a previous attempt to find the file failed."}
	}
];


FastImport::MissingFile="The file `1` could not be found. Verify you've provided the correct path and are connected to the necessary file drive.";

(* Listable filepaths overload with single filetype *)
FastImport[myFullFilePaths:{FilePathP...}, myFileType:FastFileTypeP, myOps:OptionsPattern[FastImport]]:=Map[
	FastImport[#, myFileType, myOps]&,
	myFullFilePaths
];

(* Listable overload *)
FastImport[myFullFilePaths:{FilePathP...}, myFileTypes:{FastFileTypeP...}, myOps:OptionsPattern[FastImport]]:=MapThread[
	FastImport[##, myOps]&,
	{myFullFilePaths, myFileTypes}
];

(* import a file using a method that is in some cases much faster than Mathematica's built-in Import function *)
FastImport[myFullFilePath:FilePathP, myFileType:FastFileTypeP, myOps:OptionsPattern[FastImport]]:=Module[
	{safeOps, useStream, safeFileImport, numberOfRetries, retryDelay, retryAndPause, fileData, rawFile},

	(* get all options and verify the match patterns *)
	safeOps=SafeOptions[FastImport, ToList[myOps]];

	(* Determine if we should use Import or OpenRead *)
	(* OpenRead has been shown to be much faster for TSV and CSV (and notably, NOT for raw text files), so use it in those cases *)
	useStream=MatchQ[myFileType, "CSV" | "TSV"];

	(* == Define Function: safeFileImport *)
	(* use Check to determine if either of the unique missing file messages from Import and OpenRead were thrown. If one of these messages is thrown, return $Failed *)
	(* use Quiet to suppress the Import/OpenRead messages *)
	(* Starting version 13.2, Import function will throw warning "Import::somedata" when xlsx files contains elements that cannot be parsed *)
	(* However some experiments will generate xlsx files with expected unparsable elements, so here we mute this message in the FastImport *)
	safeFileImport[]:=Quiet[
		Check[
			(* OpenRead or Import file based on useStream boolean *)
			If[useStream,
				OpenRead[myFullFilePath],
				Quiet[Import[myFullFilePath, myFileType],{Import::somedata}]
			],
			$Failed,
			{Import::nffil, OpenRead::noopen}
		],
		{Import::nffil, Import::somedata, OpenRead::noopen}
	];
	(* == == *)

	(* -- Repeatedly try and find the file -- *)
	(* get the requested number of retires *)
	numberOfRetries=Lookup[safeOps, Retries];

	(* get the retryDelay in seconds (formatting for input to Pause) *)
	retryDelay=Unitless[Lookup[safeOps, RetryDelay], Second];

	(* == Define Function: retryAndPause == *)
	(* If there are still retries left, look for the file, pause if it can't be found, then try again *)
	(* If the file is found, just return Null, ceasing recursive calls *)
	retryAndPause[myRetries:GreaterP[0, 1]]:=Module[
		{importedFile},

		(* Try to get the file *)
		importedFile=safeFileImport[];
		If[MatchQ[importedFile, $Failed],
			(* File not found, pause and try again *)
			Pause[retryDelay];
			retryAndPause[myRetries - 1],

			(* End recursion and return found file *)
			importedFile
		]
	];

	(* If there are no retries left, return results of file import *)
	retryAndPause[0]:=safeFileImport[];
	(* == == *)

	(* Repeatedly try and verify the existence of the file until it's located or until there are no retries left *)
	(* This has proved to be necessary since we've come across cases where tablets are seemingly connected to the public server, but unable to access any files on it *)
	(* Empirically adding this retry logic to give the connection a few seconds to "warm-up" removes this issue of unreachable files *)
	fileData=retryAndPause[numberOfRetries];

	(* If we never found the file, print a message and return $Failed *)
	If[MatchQ[fileData, $Failed],
		Message[FastImport::MissingFile, myFullFilePath];
		Return[$Failed]
	];

	(* Early Return: if we're not using stream, but instead just importing, we don't need to do any processing *)
	If[!useStream,
		Return[fileData]
	];

	(* -- Process InputStream object returned from OpenRead -- *)

	(* read the stream in String for if it's a text file, or list form if it's a CSV file *)
	rawFile=ReadList[fileData, String];

	(* close the stream that was opened to the file path *)
	Close[fileData];

	(* depending on the file type, split the file differently, or not at all *)
	Switch[myFileType,
		"CSV", StringSplit[rawFile, ",", All],
		"TSV", StringSplit[rawFile, "\t", All]
	]
];



(* ::Subsubsection::Closed:: *)
(*xmlFileQ*)


(* --- Core Function --- *)
xmlFileQ[string:XmlFileP]:=Quiet[FileExistsQ[string]];

(* --- Listable definition --- *)
SetAttributes[xmlFileQ, Listable];

(* --- Catch All Definition --- *)
xmlFileQ[___]:=False;


(* ::Subsection::Closed:: *)
(*Rounding*)


(* ::Subsubsection::Closed:: *)
(*SignificantFigures*)


SignificantFigures[(0 | 0.), b_Integer]:=0;
SignificantFigures[x:_?NumericQ, b_Integer]:=Round[x, 10^Floor[(Log10[x] - b + 1)]]/;x >= 0;
SignificantFigures[x_?NumericQ, b_Integer]:=-SignificantFigures[-x, b]/;x < 0;
SignificantFigures[null:ListableP[Null], _]:=null;
(* constructing a quantity is much faster than multiplying a number by a unity quantity *)
SignificantFigures[unitInput:_Quantity, b_Integer]:=Quantity[SignificantFigures[QuantityMagnitude[unitInput], b], QuantityUnit[unitInput]];
SignificantFigures[unitsInput:{(_?NumericQ | _Quantity)..}, b_Integer]:=MapThread[
	Quantity[SignificantFigures[#1, b], #2]&,
	{QuantityMagnitude[unitsInput], QuantityUnit[unitsInput]}
];



(* ::Subsection::Closed:: *)
(*String Manipulation*)


(* ::Subsubsection::Closed:: *)
(*toRegularExpression*)


toRegularExpression::usage="
	toRegularExpression[patt_] ==> regExp_RegularExpression
		Convert a mathematica string pattern 'patt' into a regular expression

MORE INFORMATION
	Uses StringPattern`PatternConvert
	Uses local memoization to remember converted patterns to keep things fast

INPUTS
	patt - a mathematica string pattern that will be transformed into an equivalent regular expression

OUTPUTS
	regExp - a RegularExpression version of 'patt'

EXAMPLES
	toRegularExpression[{\"A\",\"T\",\"C\",\"G\"}..]

AUTHORS
	Brad
";
toRegularExpression[in_]:=
	toRegularExpression[in]=
		RegularExpression[StringReplace[First[StringPattern`PatternConvert[in]], Shortest["(?:["~~meat__~~"])"] :> "["<>meat<>"]"]];


(* ::Subsubsection::Closed:: *)
(*StringFirst*)


StringFirst[string_String]:=StringTake[string, 1];
StringFirst[strings:{_String..}]:=StringFirst[#]& /@ strings;



(* ::Subsubsection::Closed:: *)
(*StringLast*)


StringLast[string_String]:=StringTake[string, -1];
StringLast[strings:{_String..}]:=StringLast[#]& /@ strings;



(* ::Subsubsection::Closed:: *)
(*StringRest*)


StringRest[string_String]:=StringDrop[string, 1];
StringRest[strings:{_String..}]:=StringRest[#]& /@ strings;



(* ::Subsubsection::Closed:: *)
(*StringMost*)


StringMost[string_String]:=StringDrop[string, -1];
StringMost[strings:{_String..}]:=StringMost[#]& /@ strings;



(* ::Subsubsection::Closed:: *)
(*StringPartitionRemainder*)


StringPartitionRemainder::InvalidPartitionSize="Partition size must be an integer greater than 0.";


StringPartitionRemainder[string_String, n_Integer?Positive]:=With[
	{
		parted=StringPartition[string, n],
		remainder=StringTake[string, -Mod[StringLength[string], n]]
	},

	If[MatchQ[parted, _List],
		Append[parted, remainder],
		{remainder}
	]
]/;Mod[StringLength[string], n] != 0;

StringPartitionRemainder[string_String, n_Integer?Positive]:=StringPartition[string, n]/;Mod[StringLength[string], n] == 0;

(*Throws an error if a non-positive partition size is given*)
StringPartitionRemainder[string_String, n:Alternatives[_Integer?Negative, 0]]:=Message[StringPartitionRemainder::InvalidPartitionSize];

SetAttributes[StringPartitionRemainder, Listable];




(* ::Subsection::Closed:: *)
(*List Manipulation*)


(* ::Subsubsection::Closed:: *)
(*Repeat*)


Repeat[{item_}, count_Integer]:=Table[item, {count}];
Repeat[item_, count_Integer]:=Table[item, {count}];


(* ::Subsubsection::Closed:: *)
(*PartitionRemainder*)


DefineOptions[PartitionRemainder,
	Options :> {
		{NegativePadding -> 0, _Integer?NonNegative, "The number of items that will be placed in the first sublist before partitioning the remaining items."}
	}];



(* --- Core function --- *)
PartitionRemainder[x_List, n_Integer?Positive, ops:OptionsPattern[PartitionRemainder]]:=PartitionRemainder[x, n, n, ops];

PartitionRemainder[list_List, n_Integer?Positive, d_Integer?Positive, ops:OptionsPattern[PartitionRemainder]]:=Module[{safeOps},

	(* Safely extract the options *)
	safeOps=SafeOptions[PartitionRemainder, ToList[ops]];

	(* If there's no negative padding, partition as normal,
		if the negative padding exceeds the list size, just return the list wrapped up,
		if the negative padding does not exceed the list size, strip off the padding then partition, then fuse it back *)
	Which[
		(NegativePadding /. safeOps) == 0, Partition[list, n, d, {1, 1}, {}],
		(NegativePadding /. safeOps) >= Length[list], {list},
		True, Module[{unpadded, partList},

		(* Drop anything in the negative padding from the front of the partition list *)
		unpadded=Drop[list, NegativePadding /. safeOps];

		(* Partition the list to maintain the remainder *)
		partList=Partition[unpadded, n, d, {1, 1}, {}];

		(* Return the partition list with the padding prepended *)
		Prepend[partList, Take[list, (NegativePadding /. safeOps)]]
	]
	]
];


PartitionRemainder[list_List, n_List, ops:OptionsPattern[PartitionRemainder]]:=Map[PartitionRemainder[list, #, ops]&, n];
PartitionRemainder[list_List, n_Integer?Positive, d_List, ops:OptionsPattern[PartitionRemainder]]:=Map[PartitionRemainder[list, n, #, ops]&, d];


(* ::Subsubsection::Closed:: *)
(*SetDifference*)


SetDifference[a_, b_]:=Union[Join[Complement[a, b], Complement[b, a]]];




(* ::Subsubsection::Closed:: *)
(*ReplaceRule*)


DefineOptions[ReplaceRule,
	Options :> {
		{Append -> True, BooleanP, "Indicates it the new rules should be added to the list if it is not currently there."}
	}];


ReplaceRule[oldRules:{(_Rule | _RuleDelayed)...}, ruleToUpdate:(_Rule | _RuleDelayed | Null), ops:OptionsPattern[]]:=ReplaceRule[oldRules, {ruleToUpdate}, ops];
ReplaceRule[oldRules:{(_Rule | _RuleDelayed)...}, rulesToUpdate:{(_Rule | _RuleDelayed | Null)...}, OptionsPattern[]]:=Module[{append, cleanedRulesToUpdate, updatedRules},
	append=OptionDefault[OptionValue[Append]];
	(* remove any Null from the update rule set *)
	cleanedRulesToUpdate=DeleteCases[rulesToUpdate, Null];
	(* This relies on mathematica's association Joining behavior which replaces any rules in the first association with rules in the second and then adds any rules from the second *)
	updatedRules=Normal@Join[Association[DeleteDuplicatesBy[oldRules, First]], Association[DeleteDuplicatesBy[cleanedRulesToUpdate, First]]];
	(* if not appending, drop any keys that didn't exist in the original rule set *)
	If[append,
		updatedRules,
		Normal@KeyDrop[updatedRules, Complement[Keys[cleanedRulesToUpdate], Keys[oldRules]]]
	]
];
ReplaceRule[oldRules:{(_Rule | _RuleDelayed)...}, {} | ListableP[Null], OptionsPattern[]]:=oldRules;


(* ::Subsubsection::Closed:: *)
(*ExtractRule*)


ExtractRule[rulies:{(_Rule | _RuleDelayed)..}, heads_List]:=
	Cases[rulies, x:(Rule | RuleDelayed)[Alternatives @@ heads, _] :> x];
ExtractRule[rulies:{(_Rule | _RuleDelayed)..}, head_]:=
	Replace[FirstOrDefault[ExtractRule[rulies, {head}]], Null -> {}, {0}];
ExtractRule[{}, _List]:={};


(* ::Subsubsection::Closed:: *)
(*PickList*)


PickList::MismatchedListLength="Expressions `1` and `2` have incompatible shapes.";

(* if no third input is given, treat it as True and pass to core function *)
PickList[list_List, sel_List]:=PickList[list, sel, True];

(* core function.  MapThread through every paired entry in list and sel.  If the entry of sel matches the pattern, include the entry in list *)
(* if the entry of sel does not match the pattern, include Nothing instead, which collapses away from the output *)
PickList[list_List, sel_List, pattern_]:=With[
	{listLength=Length[list], selLength=Length[sel]},

	(* if not the same length, return clean error message *)
	If[listLength =!= selLength,
		Message[PickList::MismatchedListLength, list, sel];
		Return[$Failed]
	];

	(* if the element of sel matches the pattern, then the corresponding element of list is passed *)
	MapThread[If[MatchQ[#2, pattern], #1, Nothing]&, {list, sel}]
];


(* ::Subsubsection::Closed:: *)
(*UnsortedComplement*)


DefineOptions[UnsortedComplement,
	Options:>{
		{SameTest->Automatic,_Symbol|_Function,"The test used to determine whether two items are considered identical."},
		{DeleteDuplicates->False,True|False,"Determines whether the output contains repeated elements in the first expression."}
	}
];

UnsortedComplement::MismatchedHeads="Heads `1` and `2` are not the same.";

(* By default Complement sorts to "canonical" order, which is fine for numbers or strings but tends to scramble other things like objects. This function will return the complement in the same order as the initial list. Additionally, Complement will also delete duplicates, and this function will not *)
UnsortedComplement[expression1_,expression2__,myOptions:OptionsPattern[UnsortedComplement]]:=Module[{safeOps,sameTest,deleteDuplicates},

	(* Get the safe options and look up the SameTest *)
	safeOps=SafeOptions[UnsortedComplement,ToList[myOptions]];
	{sameTest,deleteDuplicates}=Lookup[safeOps,{SameTest,DeleteDuplicates}];

	(* Return the output *)
	Which[

		(* If the heads are not the same, error and return $Failed *)
		!SameQ[Head[expression1],Sequence@@(Head/@{expression2})],Module[{},
			Message[UnsortedComplement::MismatchedHeads,Head[expression1],DeleteCases[Head/@{expression2},Head[expression1]]];
			$Failed
		],

		(* If the heads are Association, we need to convert to a list, do the complement and convert back to association -- this is an MM issue we have to handle. I think they defined Complement for Associations without OptionsPatterns, so if we feed it SameTest, it returns unevaluated. List doesn't have this issue so we can convert to list, complement and and convert back *)
		MatchQ[Head[expression1],Association],Module[{listedExpression1,listedExpression2},

			(* Convert the associations to lists *)
			{listedExpression1,listedExpression2}={Normal[expression1],Normal/@{expression2}};

			(* Calculate the complement, take only the elements from the first association and convert back to an association -- associations keys are unique so we can safely return the output without worrying about duplicate elements *)
			Association[SortBy[Complement[listedExpression1,Sequence@@listedExpression2,SameTest->sameTest],FirstPosition[listedExpression1,#]&]]
		],

		(* Otherwise, find the complement and sort into initial order *)
		True,Module[{complementedExpression},

			(* Calculate the complement *)
			complementedExpression=Complement[expression1,expression2,SameTest->sameTest];

			(* Take only the elements from the first expression *)
			If[
				deleteDuplicates,
				SortBy[complementedExpression,FirstPosition[expression1,#]&],
				Select[expression1,MemberQ[complementedExpression,#]&]
			]
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*UnsortedIntersection*)


DefineOptions[UnsortedIntersection,
	Options :> {
		{SameTest -> Automatic, _Symbol | _Function, "The test used to determine whether two items are considered identical."},
		{DeleteDuplicates -> False, True | False, "Determines whether the output contains repeated elements in the first expression."}
	}
];

UnsortedIntersection::MismatchedHeads = "Heads `1` and `2` are not the same.";

(* By default Complement sorts to "canonical" order, which is fine for numbers or strings but tends to scramble other things like objects. This function will return the complement in the same order as the initial list. Additionally, Complement will also delete duplicates, and this function will not *)
UnsortedIntersection[expression1_, expression2__, myOptions : OptionsPattern[UnsortedIntersection]] := Module[{safeOps, sameTest, deleteDuplicates},

	(* Get the safe options and look up the SameTest *)
	safeOps = SafeOptions[UnsortedIntersection, ToList[myOptions]];
	{sameTest, deleteDuplicates} = Lookup[safeOps, {SameTest, DeleteDuplicates}];

	(* Return the output *)
	Which[

		(* If the heads are not the same, error and return $Failed *)
		!SameQ[Head[expression1], Sequence @@ (Head /@ {expression2})],
			Module[{},
				Message[UnsortedIntersection::MismatchedHeads, Head[expression1], DeleteCases[Head /@ {expression2}, Head[expression1]]];
				$Failed
			],

		(* If the heads are Association, we need to convert to a list, do the complement and convert back to association -- this is an MM issue we have to handle. I think they defined Complement for Associations without OptionsPatterns, so if we feed it SameTest, it returns unevaluated. List doesn't have this issue so we can convert to list, complement and and convert back *)
		MatchQ[Head[expression1], Association],
			Module[{listedExpression1, listedExpression2},

				(* Convert the associations to lists *)
				{listedExpression1, listedExpression2} = {Normal[expression1], Normal /@ {expression2}};

				(* Calculate the complement, take only the elements from the first association and convert back to an association -- associations keys are unique so we can safely return the output without worrying about duplicate elements *)
				Association[SortBy[Intersection[listedExpression1, Sequence @@ listedExpression2, SameTest -> sameTest], FirstPosition[listedExpression1, #]&]]
			],

		(* Otherwise, find the complement and sort into initial order *)
		True,
			Module[{complementedExpression},

				(* Calculate the complement *)
				complementedExpression = Intersection[expression1, expression2, SameTest -> sameTest];

				(* Take only the elements from the first expression *)
				If[deleteDuplicates,
					SortBy[complementedExpression, FirstPosition[expression1, #]&],
					Select[expression1, MemberQ[complementedExpression, #]&]
				]
		]
	]
];



(* ::Subsubsection::Closed:: *)
(*RepeatedQ*)


RepeatedQ[{}]:=True;
RepeatedQ[items:{__}]:=MatchQ[items, {First[items]..}];


(* ::Subsubsection::Closed:: *)
(*SameLengthQ*)


SameLengthQ[items__]:=SameQ @@ (Length /@ {items});


(* ::Subsubsection::Closed:: *)
(*GroupByTotal*)


(*
	This function groups things such that the total of values is as close to (including) the target as possible.
	There are two types of inputs, labeled or unlabeled.
	 - unlabeled, takes in a list of values and the max total to hit, will group thing but if there are duplicate values then the
		 link between which value is which is lost
	 - labeled, takes in a list of tupples {label, value}, and will return the grouping with the labels so the link is maintained

	Output:
	 List of lists of grouping

*)


GroupByTotal::IncompatibleUnits="The units for values `1` are incompatible with the units of the target value `2`. Please make sure to use values whose units are compatible with the target value's unit.";
GroupByTotal::IncompatibleValues="The values `1` are greater then the target value `2`. Please make sure that all of the values to be grouped are equal to or less then the target value.";
GroupByTotal::UniqueLabels="The labels `1` appear multiple times. Please provide a unique label for each of the values.";

(* starts here, checks to make sure all the units are the same and that none of the values are already bigger then the target *)
GroupByTotal[myInput:Alternatives[{Alternatives[NumericP, MassP, VolumeP, AreaP]...}, {{__, Alternatives[NumericP, MassP, VolumeP, AreaP]}...}], myTargetTotal:Alternatives[NumericP, MassP, VolumeP, AreaP]]:=Module[
	{noLabels, labeledInput, internalLabels, userLabelLooup, incompatibleUnitList, badUnitList, duplicatedLabels, zeroValues, labeledInputWithoutZeroValues},

	(* Handle empty list case *)
	If[MatchQ[myInput, {}],
		Return[{}]
	];

	(* determine if any labels were provided *)
	noLabels=If[MatchQ[myInput, {{__, _}..}], False, True];

	(* make sure that all of the labels are unique*)
	duplicatedLabels=If[Not[noLabels], Cases[Tally[myInput[[All, 1;;-2]]], Except[{__, 1}]], {}];
	If[MatchQ[duplicatedLabels, Except[{}]], Message[GroupByTotal::UniqueLabels, Flatten[duplicatedLabels[[All, 1;;-2]], 1]];Return[$Failed]];

	(* if a straight list was passed in, add in some fake labels, if labels already exist, still make a labels since KnapsackSolve only takes a single label and myInput could have multiple labels per value *)
	internalLabels=Table[Unique[], Length[myInput]];
	labeledInput=If[noLabels,
		MapThread[{#1, #2}&, {internalLabels, myInput}],
		MapThread[{#1, #2[[-1]]}&, {internalLabels, myInput}]
	];

	(* get all the values that are less or equal to zero *)
	zeroValues=Select[labeledInput, Unitless[#[[2]]] <= 0&];

	(* remove the zeroValues from the list to be sorted, complement sucks in that it doesn't preserve order so do a bit of extra work to put make it so
		just to give this a better chance of giving the same grouping no matter how you run it
	 *)
	labeledInputWithoutZeroValues=Complement[labeledInput, zeroValues];

	(* if there are user provided labels, build a list that correlates the internal labels to the user provided labels*)
	userLabelLooup=If[
		Not[noLabels],
		MapThread[
			Rule[#1, Sequence @@ (#2[[1;;-2]])]&,
			{internalLabels, myInput}
		]
	];

	(*check to make sure all the units are compatible with each other*)
	incompatibleUnitList=Map[
		If[CompatibleUnitQ[#, myTargetTotal], Nothing, #]&,
		labeledInput[[All, -1]]
	];

	If[MatchQ[incompatibleUnitList, Except[{}]],
		Message[GroupByTotal::IncompatibleUnits, incompatibleUnitList, myTargetTotal];
		Return[$Failed]
	];

	(* if there were only zero values, then there is no need to go further*)
	If[Length[zeroValues] == Length[labeledInput], Return[{Flatten[myInput]}]];


	(*check to make sure that none of the values in the input aren't larger then the target total (this prevents the KnapsackSolve error which is less the informative) *)
	badUnitList=Map[
		If[MatchQ[#, LessEqualP[myTargetTotal]], Nothing, #]&,
		labeledInputWithoutZeroValues[[All, -1]]
	];

	If[
		MatchQ[badUnitList, Except[{}]],
		Message[GroupByTotal::IncompatibleValues, badUnitList, myTargetTotal];
		Return[$Failed]
	];

	(*start the recursive grouping here but passing in zeroValues for already grouped sets (which will be either an empty list, or all the values that are zero or less, remove the labels if a straight list was passed in to start *)
	If[noLabels,
		GroupByTotal[labeledInputWithoutZeroValues, {zeroValues}, myTargetTotal][[All, All, -1]],
		GroupByTotal[labeledInputWithoutZeroValues, {zeroValues}, myTargetTotal] /. userLabelLooup
	]
];

(*stops the recursion, if there are no more things to group, return all the created groups*)
GroupByTotal[myInput:{}, myGroupings_, myTargetTotal:Alternatives[NumericP, MassP, VolumeP, AreaP]]:=Module[{firstGroup, hasZero, groupingsNumber, sortedGroupings},

	(* check if the first group has zero of smaller values and merged them into the 2nd group (if it exists) *)
	firstGroup=First[myGroupings];
	hasZero=If[Length[Select[firstGroup, Unitless[#[[2]]] <= 0&]] >= 1, True, False];

	(* determine how many grouping there are*)
	groupingsNumber=Length[myGroupings];
	sortedGroupings=Join[First[myGroupings], SortBy[Rest[myGroupings], -Total[#[[All, 2]]]&]];

	(* return different things depending on whether there is a zero value and how many grouping there are *)
	Switch[{hasZero, groupingsNumber},
		{False, _}, DeleteCases[sortedGroupings, {}], (* return all the things minus the first empty list*)
		{True, 1}, sortedGroupings, (* return all the grouping, there should only be the one *)
		{True, 2}, {Partition[Flatten[sortedGroupings], 2]}, (* join the zero grouping to the nonzero grouping*)
		{True, GreaterEqualP[3]}, Join[{Partition[Flatten[{sortedGroupings[[1]], sortedGroupings[[2]]}], 2]}, sortedGroupings[[3;;]]] (* join the zero grouping to the first nonzero grouping*)
	]

];

(*recursive overload
	INPUT:
	 myInput:the list of labeled values still left to be grouped
	 myGroupings:the list of labels values that have already been grouped
	 myTargetTotal:the target total for each for the grouping (trying to hit this or lower values)

	 For each cycle of this function, this function will take myInput and run KanpsackSolve on it, which gives you a single grouping that meets that target.
	 The function then calls itself again and passes itself any ungrouped values still left (myInput) as well as a list of all already grouped values (myGroupings)
	 Once there are no more values left to group, the recursion stops
*)
GroupByTotal[myInput:{{__, Alternatives[NumericP, MassP, VolumeP, AreaP]}..}, myGroupings_, myTargetTotal:Alternatives[NumericP, MassP, VolumeP, AreaP]]:=Module[
	{groupedByValue, labeledSets, knapsack, ungrouped, ungroupedValues, grouped, groupedValues},

	(* group all the things to be bined by the value, so the same value will be represented by only a single input to the solver (speed gains) *)
	groupedByValue=GroupBy[myInput, Last];

	(* created a labeled association for the solver *)
	labeledSets=Association[Map[
		Rule[#, {#, #, Length[groupedByValue[#]]}]&,
		Keys[groupedByValue]
	]];

	(* run the knapsack solver, this will produce one group that meets the criteria *)
	knapsack=KnapsackSolve[labeledSets, myTargetTotal];

	(* take out all the things that were used in the group*)
	groupedValues=Partition[Flatten[Map[
		Take[groupedByValue[#], knapsack[#]]&,
		Keys[knapsack]
	]], 2];

	(* everything else *)
	ungroupedValues=Complement[myInput, groupedValues];

	(*run it again on the ungrouped sets, keep passing along the grouped ones*)
	GroupByTotal[ungroupedValues, Append[myGroupings, groupedValues], myTargetTotal]
];


(* ::Subsubsection::Closed:: *)
(*ExpandDimensions*)


(* given two non-lists, return 'skeleton' *)
ExpandDimensions[full:Except[_List], skeleton:Except[_List]]:=skeleton;

(* given non-list 'skeleton', put it in a list of size of 'full' *)
ExpandDimensions[full:{Except[_List]..}, skeleton:Except[_List]]:=ConstantArray[skeleton, Length[full]];

(* given two lists, pad 'skeleton' to match 'full' *)
ExpandDimensions[full:{Except[_List]..}, skeleton:{Except[_List]..}]:=PadRight[skeleton, Length[full], Last[skeleton]];

(* given nested list 'full', map self over it *)
ExpandDimensions[full_, skeleton:Except[_List]]:=Map[ExpandDimensions[#, skeleton]&, full];

(* given two nested lists, mapthread self over both padded to 'full' *)
ExpandDimensions[full_, skeleton_]:=MapThread[ExpandDimensions[#1, #2]&, {full, PadRight[skeleton, Length[full], Last[skeleton]]}]/;Length[full] >= Length[skeleton];


(* ::Subsubsection::Closed:: *)
(*Unflatten*)


Unflatten[flatList_?VectorQ, dimList_?ArrayQ]:=ArrayReshape[flatList, Dimensions[dimList]];


Unflatten[flatList_List, dimList_List]:=
	Unflatten[flatList, dimList, Null, List];

Unflatten[flatList_List, dimList_List, head_]:=
	ReplacePart[dimList, Thread[Rule[Position[dimList, head, Heads -> False], flatList]]];

Unflatten[flatList_List, dimList_List, Null, head_Symbol]:=
	ReplacePart[dimList, Thread[Rule[Position[dimList, Alternatives @@ findNonListThings[dimList]], flatList]]];

findNonListThings[list_List]:=Flatten@Map[findNonListThings, list];
findNonListThings[x_]:=x;



(* ::Subsubsection::Closed:: *)
(*Middle*)


DefineOptions[Middle,
	Options :> {
		{Output -> Left, Left | Right, "When length of 'expr' is even, Output determines whether to return element left of middle or right of middle."}
	}];


Middle::argx="Middle called with `1` arguments; 1 argument is expected.";
Middle::middle="`1` has a length of zero and no middle element.";
Middle::normal="Nonatomic expression expected at position 1 in `1`";


Middle[h_[stuff__], OptionsPattern[Middle]]:=With[
	{list={stuff}},
	Part[
		list,
		Floor[(Length[list] + Switch[OptionDefault[OptionValue[Output]], Left, 1, Right, 2]) / 2]]
];
Middle[in:h_[], OptionsPattern[Middle]]:=(Message[Middle::middle, in];Defer[Middle[in]]);
Middle[h_, g__, OptionsPattern[Middle]]:=(Message[Middle::argx, Length[{h, g}]];Defer[Middle[h, g]]);
Middle[h_, OptionsPattern[Middle]]:=(Message[Middle::normal, Defer@Middle[h]];Defer[Middle[h]]);


(* ::Subsubsection::Closed:: *)
(*RiffleAlternatives*)


(*
	this function takes in 3 list and combines them in a specific way,
	for each True element in the 3rd list it takes a value from the first list,
	for each False element take an element from the second list
*)
RiffleAlternatives::MismatchedListLength="The combined length of the first two input lists must match the length of the last input list.";
RiffleAlternatives::IncorrectBoolCounts="The length of the first list has to equal to the number of True instances in the last list, while the length of the second list has to equal to the number of False instances in the last list.";


RiffleAlternatives[myTrueList_List, myFalseList_List, myBoolList_List]:=Module[
	{listTest, boolTest, truePositions, falsePositions, trueWells},

	(* test to make sure the combined length of the first 2 input lists the same length as the 3rd list*)
	listTest=If[(Length[myTrueList] + Length[myFalseList]) != Length[myBoolList], Message[RiffleAlternatives::MismatchedListLength];True, False];

	(* test to make sure that there is a right number of items in the 1st and 2nd list based on the number of True/False in the last list*)
	boolTest=If[
		Or[Length[myTrueList] != Count[myBoolList, True], Length[myFalseList] != Count[myBoolList, False]],
		Message[RiffleAlternatives::IncorrectBoolCounts];Return[$Failed]
	];

	(* return failed is any of the tests failed, returning it here so that all error message get shown*)
	If[AnyTrue[{listTest, boolTest}, TrueQ], Return[$Failed]];

	(* get the positions at which the items from the true list should be inserted*)
	truePositions=Flatten[Position[myBoolList, True, {1}]];

	(* get the positions at which the items from the false list should be inserted*)
	falsePositions=Flatten[Position[myBoolList, False, {1}]];

	(* combine the two lists *)
	ReplacePart[myBoolList, Join[
		Thread[Rule[truePositions, myTrueList]],
		Thread[Rule[falsePositions, myFalseList]]]
	]
];



(* ::Subsection::Closed *)
(*Association Manipulation*)

(* ::Subsubsection::Closed *)
(* KeyReplace *)

(* Main Overload *)
KeyReplace[assoc_Association, rules:{_Rule...}] := KeyMap[ReplaceAll[rules], assoc];

(* Other Input Formats *)
KeyReplace[assoc_Association, rule_Rule] := KeyReplace[assoc, {rule}];
KeyReplace[assoc:{_Association..}, rule:_Rule] := KeyReplace[#, {rule}]& /@ assoc;
KeyReplace[assoc:{_Association..}, rules:{_Rule...}] := KeyReplace[#, rules]& /@ assoc;

(* ::Subsection::Closed:: *)
(*Geometry and Trigonometry*)


(* ::Subsubsection::Closed:: *)
(*TranslateCoordinates*)


TranslateCoordinates[coordinates_?(MatchQ[#, {{_, _}...}]&), offset_?(MatchQ[#, {Except[List], Except[List]}]&)]:=(# + offset&) /@ coordinates;
TranslateCoordinates[coordinates_?(MatchQ[#, {{_, _}...}]&), offsets_?(MatchQ[#, {{Except[List], Except[List]}...}]&)]:=coordinates + offsets/;Length[offsets] == Length[coordinates];
TranslateCoordinates[coordinates_?(MatchQ[#, {{{_, _}...}...}]&), offset_?(MatchQ[#, {Except[List], Except[List]}]&)]:=TranslateCoordinates[#, offset]& /@ coordinates;
TranslateCoordinates[coordinates_?(MatchQ[#, {{{_, _}...}...}]&), offsets_?(MatchQ[#, {{Except[List], Except[List]}...}]&)]:=MapThread[TranslateCoordinates[#1, #2]&, {coordinates, offsets}];


(* ::Subsubsection::Closed:: *)
(*RescaleData*)


RescaleData[Null, ___]:=Null;
RescaleData[{}, ___]:={};
RescaleData[datum_?NumericQ, {oldmin_?NumericQ, oldmax_?NumericQ}, {newmin_?NumericQ, newmax_?NumericQ}]:=(newmax - newmin)((datum - oldmin) / (oldmax - oldmin)) + newmin/;oldmax != oldmin;
RescaleData[datum_?NumericQ, {oldmin_?NumericQ, oldmax_?NumericQ}, {newmin_?NumericQ, newmax_?NumericQ}]:=datum/;oldmax == oldmin;
RescaleData[dataPts:{_?NumericQ..}, {oldmin_?NumericQ, oldmax_?NumericQ}, {newmin_?NumericQ, newmax_?NumericQ}]:=(newmax - newmin)((dataPts - oldmin) / (oldmax - oldmin)) + newmin/;oldmax != oldmin;
RescaleData[dataPts:{_?NumericQ..}, {oldmin_?NumericQ, oldmax_?NumericQ}, {newmin_?NumericQ, newmax_?NumericQ}]:=dataPts/;oldmax == oldmin;
RescaleData[datas:{{_?NumericQ..}..}, {oldmin_?NumericQ, oldmax_?NumericQ}, {newmin_?NumericQ, newmax_?NumericQ}]:=RescaleData[#, {oldmin, oldmax}, {newmin, newmax}]& /@ datas;


(* ::Subsubsection::Closed:: *)
(*RescaleY*)


RescaleY[Null, ___]:=Null;
RescaleY[{}, ___]:={};

(* --- Core Function --- *)
RescaleY[dataPts:{{_?NumericQ, _?NumericQ}..}, {oldmin_, oldmax_}, {newmin_?NumericQ, newmax_?NumericQ}]:=Module[{min, max},

	(* Compute the max and min if numbers are not provided *)
	min=Switch[oldmin,
		_?NumericQ, oldmin,
		_, Min[dataPts[[All, 2]]]
	];
	max=Switch[oldmax,
		_?NumericQ, oldmax,
		_, Max[dataPts[[All, 2]]]
	];

	Transpose[{dataPts[[All, 1]], RescaleData[dataPts[[All, 2]], {min, max}, {newmin, newmax}]}]
];

(* --- Listable --- *)
RescaleY[datas:{({{_?NumericQ, _?NumericQ}...} | Null)..}, {oldmin_, oldmax_}, {newmin_?NumericQ, newmax_?NumericQ}]:=Module[{notNulls, min, max},

	(* Pull out the nulls from the datas so we can safely determine the min and max values. *)
	notNulls=Select[datas, !MatchQ[#, Null | {Null}]&];

	(* Compute the global max and min of all the datas if numbers are not provided *)
	min=Switch[oldmin,
		_?NumericQ, oldmin,
		_, If[Length[notNulls] > 0, Min[Min /@ notNulls[[All, All, 2]]], newmin]
	];

	max=Switch[oldmax,
		_?NumericQ, oldmax,
		_, If[Length[notNulls] > 0, Max[Max /@ notNulls[[All, All, 2]]], newmax]
	];

	RescaleY[#, {min, max}, {newmin, newmax}]& /@ datas
];


(* ::Subsubsection::Closed:: *)
(*InPolygonQ*)


ECL`Authors[InPolygonQ]:={"brad"};

(*make the hidden function into a core function*)
InPolygonQ=Graphics`PolygonUtils`InPolygonQ;



(* ::Subsection::Closed:: *)
(*Compiled Functions*)


(* ::Subsubsection::Closed:: *)
(*SafeCompile*)


DefineOptions[SafeCompile,
	SharedOptions :> {
		Compile
	}];


SetAttributes[SafeCompile, HoldAll];

SafeCompile[args_, expr_, ops:OptionsPattern[]]:=
	Quiet[
		Compile[args, expr, ops],
		{
			Compile::nogen,
			CCompilerDriver`CreateLibrary::target,
			(* Add the following two for subInteractionsC *)
			Compile::cplist,
			CCompilerDriver`CreateLibrary::nocomp
		}
	];



(* ::Subsection::Closed:: *)
(*SLL Utilities*)

(* ::Subsubsection::Closed:: *)
(*SafeBinaryReadFile*)


SafeBinaryReadFile[filename_, type_, chunksize_Integer:10^6]:=Module[{fileStream, res, data},

	(*in order to used packed arrays, we need the Developer package*)
	Once[Get["Developer`"]];

	(*open the file stream*)
	fileStream=OpenRead[filename, BinaryFormat -> True];

	(*load the data by perform a binary read until it all in*)
	data=Last@Reap[
		While[
			True,
			Sow[
				res=Developer`ToPackedArray[BinaryReadList[fileStream, type, chunksize], Real]
			];
			If[Length[res] == 0, Break[]]
		]
	];

	Close[fileStream];

	(*return the data*)
	Join @@ data[[1]]
];


(* ::Subsubsection::Closed:: *)
(*AssociationMatchQ*)


DefineOptions[AssociationMatchQ,
	Options :> {
		{AllowForeignKeys -> False, BooleanP, "Indicates that the input association may contain keys that are not in the pattern association."},
		{RequireAllKeys -> True, BooleanP, "Indicates that the input association must contain all the keys that are in the pattern association."}
	}
];

AssociationMatchQ[myTestAssociation_Association, myPatternAssociation_Association, ops:OptionsPattern[]]:=Module[
	{safeOps},

	(* Validate input option values *)
	(* temporarily do this manually until we speed up SafeOptions, because this is called 20k times on load *)
	safeOps={
		AllowForeignKeys -> TrueQ[OptionValue[AllowForeignKeys]],
		RequireAllKeys -> Not[TrueQ[Not[OptionValue[RequireAllKeys]]]] (* default to True *)
	};

	(* Handle all cases of option values *)
	Switch[
		Lookup[safeOps, {AllowForeignKeys, RequireAllKeys}],
		(* Foreign keys can be present, but all keys in pattern association must exist in test association *)
		{True, True},
		(* KeyValuePattern already handles this case *)
		MatchQ[myTestAssociation, KeyValuePattern[Normal[myPatternAssociation]]],
		(* Only test that the keys that _do_ exist in the test association match patterns *)
		{True, False},
		MatchQ[
			myTestAssociation,
			(* Take the keys in the pattern association that exist in the test association *)
			KeyValuePattern[Normal[KeyTake[myPatternAssociation, Keys[myTestAssociation]]]]
		],
		(* Foreign keys can't exist and all keys in pattern association must exist in test association *)
		{False, True},
		And[
			ContainsExactly[Keys[myTestAssociation], Keys[myPatternAssociation]],
			MatchQ[myTestAssociation, KeyValuePattern[Normal[myPatternAssociation]]]
		],
		(* Foreign keys can't exist but not all pattern association keys need to exist in test association *)
		{False, False},
		And[
			(* Tests that there are no keys in test association that don't exist in pattern association *)
			ContainsOnly[Keys[myTestAssociation], Keys[myPatternAssociation]],
			MatchQ[
				myTestAssociation,
				(* Take the keys in the pattern association that exist in the test association *)
				KeyValuePattern[Normal[KeyTake[myPatternAssociation, Keys[myTestAssociation]]]]
			]
		]
	]
];



(* ::Subsubsection::Closed:: *)
(*AssociationMatchP*)


DefineOptions[
	AssociationMatchP,
	SharedOptions :> {AssociationMatchQ}
];

(* Generates a pattern using AssociationMatchQ *)
AssociationMatchP[myPatternAssociation_Association, ops:OptionsPattern[]]:=_?(AssociationMatchQ[#, myPatternAssociation, ops]&);



(* ::Subsubsection::Closed:: *)
(*LibraryFunctions*)


LibraryFunctions[package_String]:=PackageFunctions[package, Output -> Symbol];
LibraryFunctions[]:=Flatten[Map[LibraryFunctions, AvailablePackages[]]];


(* ::Subsection:: *)
(*Command Builder*)


(* ::Subsubsection::Closed:: *)
(*$ObjectBuilders*)


(* ObjectBuilders is a stash in the format of Type\[Rule]TypeGeneratorFunction. *)
$ObjectBuilders=<|
	Object[Company, Supplier] -> UploadCompanySupplier,
	Model[Sample] -> UploadSampleModel,
	Model[Molecule] -> UploadMolecule,
	Model[Molecule, Oligomer] -> UploadOligomer,
	Model[Molecule, Protein] -> UploadProtein,
	Model[Molecule, Protein, Antibody] -> UploadAntibody,
	Model[Molecule, Carbohydrate] -> UploadCarbohydrate,
	Model[Molecule, Polymer] -> UploadPolymer,
	Model[Resin] -> UploadResin,
	Model[Resin, SolidPhaseSupport] -> UploadSolidPhaseSupport,
	Model[Lysate] -> UploadLysate,
	Model[Virus] -> UploadVirus,
	Model[Cell, Mammalian] -> UploadMammalianCell,
	Model[Cell, Bacteria] -> UploadBacterialCell,
	Model[Cell, Yeast] -> UploadYeastCell,
	Model[Tissue] -> UploadTissue,
	Model[Material] -> UploadMaterial,
	Model[Species] -> UploadSpecies,
	Object[Product] -> UploadProduct,
	Model[Sample, StockSolution] -> UploadStockSolution,
	Object[Company, Service] -> UploadCompanyService,
	Object[Method, Gradient] -> UploadGradientMethod,
	Object[Report, Literature] -> UploadLiterature,
	Object[Journal] -> UploadJournal,
	Model[Item, Column] -> UploadColumn
|>;


(* ::Subsubsection:: *)
(*$CommandBuilderFunctions*)


(* CommandBuilderFunctions contains all of the functions that should show up in the command builder. *)
(* Note: Everything needs to be a string here in order for us to export to JSON. No Symbols! (As much as it pains me to have string keys). *)
$CommandBuilderFunctions=<|
	"Experiment" -> <|
		"Sample Preparation" -> {
			"ExperimentSamplePreparation",
			"ExperimentStockSolution",
			"ExperimentAliquot",
			"ExperimentTransfer",
			"ExperimentDilute",
			"ExperimentSerialDilute",
			"ExperimentFillToVolume",
			"ExperimentResuspend",
			"ExperimentIncubate",
			"ExperimentMix",
			"ExperimentCentrifuge",
			"ExperimentFilter",
			"ExperimentPellet",
			"ExperimentEvaporate",
			"ExperimentLyophilize",
			"ExperimentAutoclave",
			"ExperimentAcousticLiquidHandling",
			"ExperimentDegas",
			"ExperimentFlashFreeze",
			"ExperimentAdjustpH",
			"ExperimentMicrowaveDigestion",
			"ExperimentPCR"
		},
		"Synthesis" -> {"ExperimentBioconjugation", "ExperimentDNASynthesis", "ExperimentRNASynthesis", "ExperimentPeptideSynthesis", "ExperimentPNASynthesis"},
		"Separations" -> {"ExperimentSolidPhaseExtraction", "ExperimentLiquidLiquidExtraction", "ExperimentFPLC", "ExperimentHPLC", "ExperimentLCMS", "ExperimentSupercriticalFluidChromatography", "ExperimentAgaroseGelElectrophoresis", "ExperimentPAGE", "ExperimentTotalProteinDetection", "ExperimentWestern", "ExperimentGasChromatography", "ExperimentIonChromatography", "ExperimentFlashChromatography", "ExperimentCrossFlowFiltration", "ExperimentDialysis", "ExperimentMagneticBeadSeparation", "ExperimentCapillaryGelElectrophoresisSDS", "ExperimentCapillaryIsoelectricFocusing"},
		"Spectroscopy" -> {"ExperimentNMR", "ExperimentNMR2D", "ExperimentAbsorbanceIntensity", "ExperimentAbsorbanceSpectroscopy", "ExperimentAbsorbanceKinetics", "ExperimentIRSpectroscopy", "ExperimentFluorescenceIntensity", "ExperimentFluorescenceSpectroscopy", "ExperimentFluorescenceKinetics", "ExperimentFluorescencePolarization", "ExperimentFluorescencePolarizationKinetics", "ExperimentLuminescenceIntensity", "ExperimentLuminescenceSpectroscopy", "ExperimentLuminescenceKinetics", "ExperimentRamanSpectroscopy", "ExperimentDynamicLightScattering", "ExperimentAlphaScreen", "ExperimentCircularDichroism", "ExperimentNephelometry", "ExperimentNephelometryKinetics"},
		"Mass Spectrometry" -> {"ExperimentMassSpectrometry", "ExperimentLCMS", "ExperimentSupercriticalFluidChromatography", "ExperimentGCMS", "ExperimentICPMS"},
		"Bioassays" -> {"ExperimentTotalProteinQuantification", "ExperimentqPCR", (*"ExperimentDigitalPCR",*) "ExperimentBioLayerInterferometry", "ExperimentUVMelting", "ExperimentDifferentialScanningCalorimetry", "ExperimentThermalShift", "ExperimentCapillaryELISA", "ExperimentELISA", "ExperimentDNASequencing", "ExperimentBioconjugation", "ExperimentImageCells"},
		"Crystallography" -> {"ExperimentPowderXRD", "ExperimentGrowCrystal"},
		"Property Measurement" -> {
			"ExperimentCountLiquidParticles",
			"ExperimentCoulterCount",
			"ExperimentCyclicVoltammetry",
			"ExperimentDynamicFoamAnalysis",
			"ExperimentImageSample",
			"ExperimentMeasureConductivity",
			"ExperimentMeasureContactAngle",
			"ExperimentMeasureCount",
			"ExperimentMeasureDensity",
			"ExperimentMeasureDissolvedOxygen",
			"ExperimentMeasureOsmolality",
			"ExperimentMeasurepH",
			"ExperimentMeasureRefractiveIndex",
			"ExperimentMeasureSurfaceTension",
			"ExperimentMeasureViscosity",
			"ExperimentMeasureVolume",
			"ExperimentMeasureWeight",
			"ExperimentVisualInspection"
		},
		"Cell Biology" -> {
			"ExperimentFreezeCells",
			"ExperimentIncubateCells",
			"ExperimentThawCells",
			"ExperimentPickColonies",
			"ExperimentInoculateLiquidMedia",
			"ExperimentSpreadCells",
			"ExperimentStreakCells"
		}
	|>,
	"Sample" -> <|
		"Shipping Samples" -> {"OrderSamples", "ShipToUser", "ShipToECL", "ShipBetweenSites","DropShipSamples", "CancelTransaction"},
		"Inventory Management" -> {"StoreSamples", "ClearSampleStorageSchedule", "DiscardSamples", "CancelDiscardSamples", "RestrictSamples", "UnrestrictSamples", "SampleUsage"}
	|>,
	"Plot" -> <|
		"General" -> {
			"Inspect",
			"EmeraldListLinePlot",
			"EmeraldDateListPlot",
			"EmeraldBarChart",
			"EmeraldBoxWhiskerChart",
			"EmeraldPieChart",
			"EmeraldHistogram",
			"EmeraldSmoothHistogram",
			"EmeraldHistogram3D",
			"EmeraldSmoothHistogram3D",
			"EmeraldListContourPlot",
			"EmeraldListPointPlot3D",
			"EmeraldListPlot3D",
			"PlotDistribution",
			"PlotImage",
			"PlotTable",
			"PlotCloudFile",
			"PlotPeaks",
			"PlotObject",
			"PlotWaterfall",
			"PlotProtocolTimeline"
		},
		"Spectroscopy" -> {
			"PlotAbsorbanceQuantification",
			"PlotAbsorbanceSpectroscopy",
			"PlotAlphaScreen",
			"PlotCircularDichroism",
			"PlotFluorescenceIntensity",
			"PlotFluorescenceSpectroscopy",
			"PlotLuminescenceSpectroscopy",
			"PlotMassSpectrometry",
			"PlotNephelometry",
			"PlotNMR",
			"PlotNMR2D",
			"PlotIRSpectroscopy",
			"PlotPowderXRD",
			"PlotRamanSpectroscopy"
		},
		"Bio-layer Interferometry" -> {
			"PlotBioLayerInterferometry",
			"PlotBindingKinetics",
			"PlotBindingQuantitation",
			"PlotEpitopeBinning"
		},
		"Chromatography" -> {
			"PlotChromatography",
			"PlotChromatographyMassSpectra",
			"PlotFractions",
			"PlotGradient",
			"PlotLadder"
		},
		"Filtration" -> {
			"PlotCrossFlowFiltration"
		},
		"Flow Cytometry"->{
			"PlotGating"
		},
		"Gel Electrophoresis" -> {
			"PlotAgarose",
			"PlotPAGE",
			"PlotWestern"
		},
		"Capillary Electrophoresis" -> {
			"PlotCapillaryGelElectrophoresisSDS",
			"PlotCapillaryIsoelectricFocusing",
			"PlotCapillaryIsoelectricFocusingEvolution"
		},
		"Kinetics" -> {
			"PlotAbsorbanceKinetics",
			"PlotFluorescenceKinetics",
			"PlotLuminescenceKinetics",
			"PlotKineticRates",
			"PlotNephelometryKinetics",
			"PlotTrajectory"
		},
		"Microscopy" -> {
			"PlotCellCount",
			"PlotCellCountSummary",
			"PlotMicroscope",
			"PlotMicroscopeOverlay"
		},
		"Nucleic Acids" -> {
			"PlotProbeConcentration",
			"PlotReactionMechanism",
			"PlotState",
			"PlotPeptideFragmentationSpectra"
		},
		"PCR" -> {
			"PlotqPCR",
			"PlotCopyNumber",
			"PlotQuantificationCycle",
			"PlotDigitalPCR"
		},
		"Sample Preparation and Diagnostics" -> {
			"PlotConductivity",
			"PlotpH",
			"PlotSensor",
			"PlotVacuumEvaporation",
			"PlotVolume",
			"PlotDissolvedOxygen"
		},
		"Surface Tension" -> {
			"PlotSurfaceTension",
			"PlotCriticalMicelleConcentration"
		},
		"Foam" -> {
			"PlotDynamicFoamAnalysis"
		},
		"Thermodynamics" -> {
			"PlotAbsorbanceThermodynamics",
			"PlotDifferentialScanningCalorimetry",
			"PlotFluorescenceThermodynamics",
			"PlotMeltingPoint",
			"PlotThermodynamics"
		},
		"Physical Locations" -> {
			"PlotLocation",
			"PlotContents"
		},
		"Curve Fitting" -> {
			"PlotFit",
			"PlotPrediction",
			"PlotSmoothing",
			"PlotStandardCurve"
		},
		"Model Visualization" -> {
			"PlotProtein",
			"PlotTranscript",
			"PlotVirus"
		},
		"Bioassays" -> {
			"PlotDNASequencing",
			"PlotDNASequencingAnalysis",
			"PlotELISA"
		},
		"Cell Biology" -> {
			"PlotFreezeCells"
		}
	|>,
	"Analysis" -> <|
		"Numerics" -> {
			"AnalyzeClusters",
			"AnalyzeFit",
			"AnalyzePeaks",
			"AnalyzeSmoothing",
			"AnalyzeStandardCurve",
			"AnalyzeDownsampling",
			"AnalyzeMassSpectrumDeconvolution"
		},
		"BioAssays" -> {
			"AnalyzeBindingKinetics",
			"AnalyzeBindingQuantitation",
			"AnalyzeCompensationMatrix",
			"AnalyzeDNASequencing",
			"AnalyzeEpitopeBinning",
			"AnalyzeFlowCytometry",
			"AnalyzeTotalProteinQuantification",
			"AnalyzeQuantificationCycle",
			"AnalyzeCopyNumber",
			"AnalyzeParallelLine"
		},
		"Separation" -> {
			"AnalyzeFractions",
			"AnalyzeComposition"
		},
		"Spectroscopy" -> {
			"AnalyzeAbsorbanceQuantification",
			"AnalyzeLadder"
		},
		"Physics" -> {
			"AnalyzeCriticalMicelleConcentration",
			"AnalyzeKinetics",
			"AnalyzeThermodynamics",
			"AnalyzeMeltingPoint",
			"AnalyzeDynamicLightScattering",
			"AnalyzeDynamicLightScatteringLoading"
		},
		"Image Processing" -> {
			"AnalyzeBubbleRadius",
			"AnalyzeImageExposure",
			"AnalyzeMicroscopeOverlay",
			"AnalyzeCellCount",
            "AnalyzeColonies"
		}
	|>,
	"Simulation" -> <|
		"BiomoleculeExperiments" -> {"SimulatePeptideFragmentationSpectra"},
		"Equilibrium" -> {"SimulateEquilibrium"},
		"Folding" -> {"SimulateFolding"},
		"Hybridization" -> {"SimulateHybridization"},
		"Kinetics" -> {"SimulateKinetics"},
		"MeltingCurve" -> {"SimulateMeltingCurve"},
		"Reactivity" -> {"SimulateReactivity"},
		"Thermodynamics" -> {"SimulateEnthalpy", "SimulateEntropy", "SimulateEquilibriumConstant", "SimulateFreeEnergy", "SimulateMeltingTemperature"}
	|>,
	"Upload" -> <|
		"Updating Sample Properties" -> {"UploadName", "UploadTransportCondition", "DefineAnalytes", "DefineTags", "DefineComposition", "DefineSolvent", "DefineEHSInformation"},
		"Defining Model Fulfillment" -> {"UploadSampleModel", "UploadStockSolution", "UploadArrayCard", "UploadColumn", "UploadCapillaryELISACartridge", "UploadProduct", "UploadInventory", "UploadCompanySupplier", "UploadCompanyService", "UploadReferenceElectrodeModel"},
		"Defining Sample Components" -> {"UploadMolecule", "UploadOligomer", "UploadProtein", "UploadAntibody", "UploadCarbohydrate", "UploadVirus", "UploadMammalianCell", "UploadBacterialCell", "UploadYeastCell", "UploadTissue", "UploadLysate", "UploadSpecies", "UploadResin", "UploadSolidPhaseSupport", "UploadPolymer", "UploadMaterial", "UploadModification"},
		"Defining Methods" -> {"UploadGradientMethod", "UploadFractionCollectionMethod", "UploadPipettingMethod"},
		"Defining Literature References" -> {"UploadLiterature", "UploadJournal"},
		"Defining Manifold Jobs" -> {"Compute"}
	|>,
	"Search" -> <||>
|>;


(* Add your function here if you are testing it. It will only show up in the Command Builder for Object[User,Emerald,Developer] users. *)
$CommandBuilderFunctionsDev=<|
	"Experiment" -> <|
		"Culinary" -> {"ECL`AppHelpers`ExperimentTacoPreparation"},
		"Sample Preparation" -> {
			"ExperimentSamplePreparation",
			"ExperimentStockSolution",
			"ExperimentAliquot",
			"ExperimentTransfer",
			"ExperimentDilute",
			"ExperimentSerialDilute",
			"ExperimentFillToVolume",
			"ExperimentResuspend",
			"ExperimentIncubate",
			"ExperimentMix",
			"ExperimentCentrifuge",
			"ExperimentFilter",
			"ExperimentPellet",
			"ExperimentEvaporate",
			"ExperimentLyophilize",
			"ExperimentAutoclave",
			"ExperimentAcousticLiquidHandling",
			"ExperimentDegas",
			"ExperimentFlashFreeze",
			"ExperimentAdjustpH",
			"ExperimentMicrowaveDigestion",
			"ExperimentPCR"
		},
		"Synthesis" -> {"ExperimentBioconjugation", "ExperimentDNASynthesis", "ExperimentRNASynthesis", "ExperimentPeptideSynthesis", "ExperimentPNASynthesis"},
		"Separations" -> {"ExperimentSolidPhaseExtraction", "ExperimentLiquidLiquidExtraction", "ExperimentHPLC", "ExperimentFPLC", "ExperimentLCMS", "ExperimentSupercriticalFluidChromatography", "ExperimentAgaroseGelElectrophoresis", "ExperimentPAGE", "ExperimentTotalProteinDetection", "ExperimentWestern", "ExperimentGasChromatography", "ExperimentIonChromatography", "ExperimentCrossFlowFiltration", "ExperimentDialysis", "ExperimentMagneticBeadSeparation", "ExperimentCapillaryGelElectrophoresisSDS", "ExperimentCapillaryIsoelectricFocusing", "ExperimentFlashChromatography"},
		"Spectroscopy" -> {"ExperimentNMR", "ExperimentNMR2D", "ExperimentAbsorbanceIntensity", "ExperimentAbsorbanceSpectroscopy", "ExperimentAbsorbanceKinetics", "ExperimentIRSpectroscopy", "ExperimentFluorescenceIntensity", "ExperimentFluorescenceSpectroscopy", "ExperimentFluorescenceKinetics", "ExperimentFluorescencePolarization", "ExperimentFluorescencePolarizationKinetics", "ExperimentLuminescenceIntensity", "ExperimentLuminescenceSpectroscopy", "ExperimentLuminescenceKinetics", "ExperimentRamanSpectroscopy", "ExperimentDynamicLightScattering", "ExperimentAlphaScreen", "ExperimentCircularDichroism", "ExperimentNephelometry", "ExperimentNephelometryKinetics"},
		"Mass Spectrometry" -> {"ExperimentMassSpectrometry", "ExperimentLCMS", "ExperimentSupercriticalFluidChromatography", "ExperimentGCMS", "ExperimentICPMS"},
		"Bioassays" -> {"ExperimentTotalProteinQuantification", "ExperimentqPCR", "ExperimentDigitalPCR", "ExperimentBioLayerInterferometry", "ExperimentUVMelting", "ExperimentDifferentialScanningCalorimetry", "ExperimentThermalShift", "ExperimentCapillaryELISA", "ExperimentELISA", "ExperimentDNASequencing", "ExperimentBioconjugation", "ExperimentImageCells"},
		"Crystallography" -> {"ExperimentPowderXRD", "ExperimentGrowCrystal"},
		"Property Measurement" -> {
			"ExperimentCountLiquidParticles",
			"ExperimentCoulterCount",
			"ExperimentCyclicVoltammetry",
			"ExperimentDynamicFoamAnalysis",
			"ExperimentImageSample",
			"ExperimentMeasureConductivity",
			"ExperimentMeasureContactAngle",
			"ExperimentMeasureCount",
			"ExperimentMeasureDensity",
			"ExperimentMeasureDissolvedOxygen",
			"ExperimentMeasureOsmolality",
			"ExperimentMeasurepH",
			"ExperimentMeasureRefractiveIndex",
			"ExperimentMeasureSurfaceTension",
			"ExperimentMeasureViscosity",
			"ExperimentMeasureVolume",
			"ExperimentMeasureWeight",
			"ExperimentVisualInspection"
		},
		"Cell Biology" -> {
			"ExperimentFreezeCells",
			"ExperimentIncubateCells",
			"ExperimentThawCells",
			"ExperimentStreakCells",
			"ExperimentSpreadCells"
		}
	|>,
	"Sample" -> <|
		"Shipping Samples" -> {"OrderSamples", "ShipToUser", "ShipToECL", "ShipBetweenSites","DropShipSamples", "CancelTransaction"},
		"Inventory Management" -> {"StoreSamples", "ClearSampleStorageSchedule", "DiscardSamples", "CancelDiscardSamples", "RestrictSamples", "UnrestrictSamples", "SampleUsage"}
	|>,
	"Plot" -> <|
		"General" -> {
			"Inspect",
			"EmeraldListLinePlot",
			"EmeraldDateListPlot",
			"EmeraldBarChart",
			"EmeraldBoxWhiskerChart",
			"EmeraldPieChart",
			"EmeraldHistogram",
			"EmeraldSmoothHistogram",
			"EmeraldHistogram3D",
			"EmeraldSmoothHistogram3D",
			"EmeraldListContourPlot",
			"EmeraldListPointPlot3D",
			"EmeraldListPlot3D",
			"PlotDistribution",
			"PlotImage",
			"PlotTable",
			"PlotCloudFile",
			"PlotPeaks",
			"PlotObject",
			"PlotWaterfall",
			"PlotProtocolTimeline"
		},
		"Spectroscopy" -> {
			"PlotAbsorbanceQuantification",
			"PlotAbsorbanceSpectroscopy",
			"PlotAlphaScreen",
			"PlotCircularDichroism",
			"PlotDynamicLightScattering",
			"PlotFluorescenceIntensity",
			"PlotFluorescenceSpectroscopy",
			"PlotLuminescenceSpectroscopy",
			"PlotMassSpectrometry",
			"PlotNephelometry",
			"PlotNMR",
			"PlotNMR2D",
			"PlotIRSpectroscopy",
			"PlotPowderXRD",
			"PlotRamanSpectroscopy"
		},
		"Bio-layer Interferometry" -> {
			"PlotBioLayerInterferometry",
			"PlotBindingKinetics",
			"PlotBindingQuantitation",
			"PlotEpitopeBinning"
		},
		"Chromatography" -> {
			"PlotChromatography",
			"PlotChromatographyMassSpectra",
			"PlotFractions",
			"PlotGradient",
			"PlotLadder"
		},
		"Filtration" -> {
			"PlotCrossFlowFiltration"
		},
		"Flow Cytometry"->{
			"PlotGating"
		},
		"Gel Electrophoresis" -> {
			"PlotAgarose",
			"PlotPAGE",
			"PlotWestern"
		},
		"Capillary Electrophoresis" -> {
			"PlotCapillaryGelElectrophoresisSDS",
			"PlotCapillaryIsoelectricFocusing",
			"PlotCapillaryIsoelectricFocusingEvolution"
		},
		"Kinetics" -> {
			"PlotAbsorbanceKinetics",
			"PlotFluorescenceKinetics",
			"PlotLuminescenceKinetics",
			"PlotKineticRates",
			"PlotNephelometryKinetics",
			"PlotTrajectory"
		},
		"Microscopy" -> {
			"PlotCellCount",
			"PlotCellCountSummary",
			"PlotMicroscope",
			"PlotMicroscopeOverlay"
		},
		"Nucleic Acids" -> {
			"PlotProbeConcentration",
			"PlotReactionMechanism",
			"PlotState",
			"PlotPeptideFragmentationSpectra"
		},
		"PCR" -> {
			"PlotqPCR",
			"PlotCopyNumber",
			"PlotQuantificationCycle",
			"PlotDigitalPCR"
		},
		"Sample Preparation and Diagnostics" -> {
			"PlotConductivity",
			"PlotpH",
			"PlotSensor",
			"PlotVacuumEvaporation",
			"PlotVolume",
			"PlotDissolvedOxygen"

		},
		"Surface Tension" -> {
			"PlotSurfaceTension",
			"PlotCriticalMicelleConcentration"
		},
		"Foam" -> {
			"PlotDynamicFoamAnalysis"
		},
		"Thermodynamics" -> {
			"PlotAbsorbanceThermodynamics",
			"PlotDifferentialScanningCalorimetry",
			"PlotFluorescenceThermodynamics",
			"PlotMeltingPoint",
			"PlotThermodynamics"
		},
		"Physical Locations" -> {
			"PlotLocation",
			"PlotContents"
		},
		"Curve Fitting" -> {
			"PlotFit",
			"PlotPrediction",
			"PlotSmoothing",
			"PlotStandardCurve"
		},
		"Model Visualization" -> {
			"PlotProtein",
			"PlotTranscript",
			"PlotVirus"
		},
		"Bioassays" -> {
			"PlotDNASequencing",
			"PlotDNASequencingAnalysis",
			"PlotELISA"
		},
		"Cell Biology" -> {
			"PlotFreezeCells"
		}
	|>,
	"Analysis" -> <|
		"Numerics" -> {
			"AnalyzeClusters",
			"AnalyzeFit",
			"AnalyzePeaks",
			"AnalyzeSmoothing",
			"AnalyzeStandardCurve",
			"AnalyzeDownsampling",
			"AnalyzeMassSpectrumDeconvolution"
		},
		"BioAssays" -> {
			"AnalyzeBindingKinetics",
			"AnalyzeBindingQuantitation",
			"AnalyzeCompensationMatrix",
			"AnalyzeDNASequencing",
			"AnalyzeEpitopeBinning",
			"AnalyzeFlowCytometry",
			"AnalyzeTotalProteinQuantification",
			"AnalyzeQuantificationCycle",
			"AnalyzeCopyNumber",
			"AnalyzeParallelLine"
		},
		"Separation" -> {
			"AnalyzeFractions",
			"AnalyzeComposition"
		},
		"Spectroscopy" -> {
			"AnalyzeAbsorbanceQuantification",
			"AnalyzeLadder"
		},
		"Physics" -> {
			"AnalyzeCriticalMicelleConcentration",
			"AnalyzeKinetics",
			"AnalyzeThermodynamics",
			"AnalyzeMeltingPoint",
			"AnalyzeDynamicLightScattering",
			"AnalyzeDynamicLightScatteringLoading"
		},
		"Image Processing" -> {
			"AnalyzeBubbleRadius",
			"AnalyzeImageExposure",
			"AnalyzeMicroscopeOverlay",
			"AnalyzeCellCount",
            "AnalyzeColonies"
		}

	|>,
	"Simulation" -> <|
		"BiomoleculeExperiments" -> {"SimulatePeptideFragmentationSpectra"},
		"Equilibrium" -> {"SimulateEquilibrium"},
		"Folding" -> {"SimulateFolding"},
		"Hybridization" -> {"SimulateHybridization"},
		"Kinetics" -> {"SimulateKinetics"},
		"MeltingCurve" -> {"SimulateMeltingCurve"},
		"Reactivity" -> {"SimulateReactivity"},
		"Thermodynamics" -> {"SimulateEnthalpy", "SimulateEntropy", "SimulateEquilibriumConstant", "SimulateFreeEnergy", "SimulateMeltingTemperature"}
	|>,
	"Upload" -> <|
		"Updating Sample Properties" -> {"UploadName", "UploadTransportCondition", "DefineAnalytes", "DefineTags", "DefineComposition", "DefineSolvent", "DefineEHSInformation"},
		"Defining Model Fulfillment" -> {"UploadSampleModel", "UploadStockSolution", "UploadArrayCard", "UploadColumn", "UploadCapillaryELISACartridge", "UploadProduct", "UploadInventory", "UploadCompanySupplier", "UploadCompanyService", "UploadReferenceElectrodeModel"},
		"Defining Sample Components" -> {"UploadMolecule", "UploadOligomer", "UploadProtein", "UploadAntibody", "UploadCarbohydrate", "UploadVirus", "UploadMammalianCell", "UploadBacterialCell", "UploadYeastCell", "UploadTissue", "UploadLysate", "UploadSpecies", "UploadResin", "UploadSolidPhaseSupport", "UploadPolymer", "UploadMaterial", "UploadModification"},
		"Defining Methods" -> {"UploadGradientMethod", "UploadFractionCollectionMethod", "UploadPipettingMethod"},
		"Defining Literature References" -> {"UploadLiterature", "UploadJournal"},
		"Defining Manifold Jobs" -> {"Compute"}
	|>,
	"Search" -> <||>
|>;

(* List any experiments in beta testing or entering into beta testing here *)
(* Follow the format: functionName -> list of options to send to PlotBetaTesting *)
(* Typically no options are required for PlotBetaTesting - the most likely option to provide is SearchCriteria and Name
	- SearchCriteria is used if modifying an existing function and need to specify search conditions to find only your protocols
	- Name is often used with SearchCriteria if the exact changes are unclear (for instance if you want to indicate a specific feature added to RSP
*)
$BetaExperimentFunctions=<|
	"ExperimentDesiccate" -> {},
	"ExperimentGrind" -> {},
	"ExperimentMeasureMeltingPoint" -> {},
	"ExperimentCoulterCount" -> {},
	"ExperimentHPLC" -> {SearchCriteria->(Instrument==(Model[Instrument, HPLC, "id:R8e1Pjp1md8p"]|Object[Instrument, HPLC, "id:kEJ9mqR9prEL"]))}
|>;


(* ::Subsubsection:: *)
(*ClearMemoization*)

(* Global variable for memoization functions *)
$Memoization={};

Authors[ClearMemoization]:={"scicomp", "brad", "dima"};

DefineUsage[ClearMemoization,
	{
		BasicDefinitions -> {
			{"ClearMemoization[function]", "", "clears memoized values for the 'function'."},
			{"ClearMemoization[]", "", "clears memoization from functions that were added to $Memoization."}
		},
		MoreInformation -> {
			"$Memoization is populated every time function known to have memoization is run. Detection of those functions is not automatic and developers have to add AppendTo[$Memoization, function] in their code. Once ClearMemoization[] is run, memoizations for all known functions should be cleared."
		},
		Input :> {
			{"function", Symbol, "Function that should have memoization cleared. In case of private functions the full name should be provided (i.e. Experiment`Private`myMemoizedFunction)."}
		},
		SeeAlso -> {
			"Clear",
			"ClearAll",
			"DownValues",
			"Unset"
		},
		Author -> {
			"dima"
		}
	}];

ClearMemoization[function_]:=Module[
	{oldDownValues, newDownValues, context},

	(* get the DownValues for the functions - they contain real definition as well as memoized results *)
	oldDownValues=DownValues[Evaluate[function]];

	(* get context for the function we have memoized - if we were passed one, get it, otherwise grab it from the SymbolPackages *)
	context=If[StringContainsQ[ToString[function], "`"], (First@StringSplit[ToString[function], "`"])<>"`", ToString@First@SymbolPackages[function]];

	(* get only real definitions of the functions - they will start from Function[Context`Private`variable.. *)
	(* NOTE: ExperimentCover and ExperimentUncover aren't exported symbols but we still want the definitions to be cleared. *)
	newDownValues=Cases[
		oldDownValues,
		_?(
			And[
				StringMatchQ[ToString[#], ("HoldPattern["<>ToString[function]<>"["<>context<>"Private`"~~___) | ("HoldPattern["<>ToString[function]<>"[]")],
				!MatchQ[#[[1]], Verbatim[HoldPattern][_Symbol[Experiment`Private`ExperimentCover | Experiment`Private`ExperimentUncover, ___]]]
			]
		&)
];

	(* swap DownValues of the function to contain only definitions *)
	DownValues[Evaluate[function]]=newDownValues;

	(* delete this function from the $Memoization *)
	$Memoization = DeleteCases[$Memoization, function];

	Experiment`Private`$PrimitiveFrameworkOutputCache=<||>;
	Experiment`Private`$PrimitiveFrameworkResolverOutputCache=<||>;
];

ClearMemoization[]:=Module[
	{noDups},

	(* clear duplicate entries - we will clear each function on ly once regardless *)
	noDups=DeleteDuplicates[$Memoization];

	Map[ClearMemoization[#]&, noDups];
];
