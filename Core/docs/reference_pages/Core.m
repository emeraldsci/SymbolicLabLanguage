(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*Function Writing Functions*)


(* ::Subsubsection::Closed:: *)
(*overload*)


(* private function *)
DefineUsage[overload,
	{
		BasicDefinitions -> {
			{"overload[parentFunc,indicator->childFunc]", "out", "adds overloads to 'parentFunc' such that: 'parentFunc'['indicator',args___] = 'childFunc'[args], for all definitions of 'childFunc'."},
			{"overload[parentFunc,redirectList]", "out", "adds overloads to 'parentFunc' for each Redirect specified in 'redirectList'."}
		},
		Input :> {
			{"parentFunc", _Symbol, "The function that will be overloaded to call 'childFunc'."},
			{"childFunc", _Symbol, "The function that will be called by 'parentFunc'."},
			{"indicator", _, "An indicator, such as a symbol, used to guide the redirects of 'parentFunc' to 'childFunc'."},
			{"redirectList", {_Rule...}, "List of rules relating indicators to child functions."}
		},
		Output :> {
			{"out", {(HoldPattern[_ * "parentFunc"] :> _ * "childFunc")...}, "List of new definitions added by 'Overload'."}
		},
		SeeAlso -> {
			"DownValues",
			"SetDelayed"
		},
		Author -> {"scicomp", "brad", "srikant"}
	}];


(* ::Subsection::Closed:: *)
(*File Finding & Manipulation*)


(* ::Subsubsection::Closed:: *)
(*FastExport*)


DefineUsage[FastExport,
	{
		BasicDefinitions -> {
			{"FastExport[filepath, content, filetype]", "file", "writes 'content' to a file at 'filepath' using the fastest method available, dictated by 'filetype'."}
		},
		MoreInformation -> {
			"If a file already exists at the filepath specified, it will be overwritten.",
			"Inherits CharacterEncoding option from OpenWrite"
		},
		Input :> {
			{"filepath", FilePathP, "Path of the file that will be exported."},
			{"content", _, "The content to be written as the exported file's contents."},
			{"filetype", FastFileTypeP, "Type of file to be exported.  Text will call OpenWrite; all others will call Export."}
		},
		Output :> {
			{"file", _, "The file that has been imported."}
		},
		SeeAlso -> {
			"FastImport",
			"OpenWrite",
			"Export"
		},
		Author -> {"robert", "alou"}
	}];



(* ::Subsubsection::Closed:: *)
(*FastImport*)


DefineUsage[FastImport,
	{
		BasicDefinitions -> {
			{"FastImport[filepath, filetype]", "file", "imports the file at 'filepath' of the given 'filetype' using the fastest method available."}
		},
		MoreInformation -> {
			"Imports CSV and TSV files by reading directly from the stream which is substantially quicker then the standard Import function.",
			"For file types that are not CSV or TSV files, FastImport will simply call Import on these files and return the result"
		},
		Input :> {
			{"filepath", FilePathP, "Path to the file that will be imported."},
			{"filetype", FastFileTypeP, "Type of file to be imported.  CSV and TSV will be faster than Import; all others will call Import."}
		},
		Output :> {
			{"file", _, "The file that has been imported."}
		},
		SeeAlso -> {
			"Import",
			"ImportCloudFile",
			"FastExport"
		},
		Author -> {"xu.yi", "hanming.yang", "steven"}
	}];


(* ::Subsubsection::Closed:: *)
(*xmlFileQ*)


DefineUsage[xmlFileQ,
	{
		BasicDefinitions -> {
			{"xmlFileQ[file]", "out", "checks if 'file' ends with the .xml extension."}
		},
		Input :> {
			{"file", _String, "A file to check for the .xml extension and existence."}
		},
		Output :> {
			{"out", BooleanP, "True if 'file' ends with .xml and exists."}
		},
		SeeAlso -> {
			"ContextQ",
			"FileExistsQ"
		},
		Author -> {
			"ben"
		}
	}];


(* ::Subsection::Closed:: *)
(*Rounding*)


(* ::Subsubsection::Closed:: *)
(*SignificantFigures*)


DefineUsage[SignificantFigures,
	{
		BasicDefinitions -> {
			{"SignificantFigures[x,b]", "y", "returns the first 'b' significant figures of 'x'."}
		},
		Input :> {
			{"x", _?NumericQ, "The number that you want to take significant digits from."},
			{"b", _Integer, "Number of significant digits to return."}
		},
		Output :> {
			{"y", _?NumberQ, "The first 'b' significant figures of 'x'."}
		},
		SeeAlso -> {
			"RoundReals",
			"Round"
		},
		Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
	}];


(* ::Subsection::Closed:: *)
(*String Manipulation*)


(* ::Subsubsection::Closed:: *)
(*StringFirst*)


DefineUsage[StringFirst,
	{
		BasicDefinitions -> {
			{"StringFirst[string]", "firstCharacter", "returns the first character of the input 'string'."}
		},
		Input :> {
			{"string", ListableP[_String], "The string(s) to extract the first character from."}
		},
		Output :> {
			{"firstCharacter", ListableP[_String], "The first character of each input string."}
		},
		SeeAlso -> {
			"StringLast",
			"StringMost",
			"StringRest"
		},
		Author -> {"scicomp", "brad"}
	}];


(* ::Subsubsection::Closed:: *)
(*StringLast*)


DefineUsage[StringLast,
	{
		BasicDefinitions -> {
			{"StringLast[string]", "lastCharacter", "returns the last character of the input 'string'."}
		},
		Input :> {
			{"string", ListableP[_String], "The string(s) to extract the last character from."}
		},
		Output :> {
			{"lastCharacter", ListableP[_String], "The last character of each input string."}
		},
		SeeAlso -> {
			"StringFirst",
			"StringMost",
			"StringRest"
		},
		Author -> {"scicomp", "brad"}
	}];


(* ::Subsubsection::Closed:: *)
(*StringMost*)


DefineUsage[StringMost,
	{
		BasicDefinitions -> {
			{"StringMost[string]", "outputString", "returns the all but the last character from the input 'string'."}
		},
		Input :> {
			{"string", ListableP[_String], "The string(s) to extract all but the last character from."}
		},
		Output :> {
			{"outputString", ListableP[_String], "All but the last character of each input string."}
		},
		SeeAlso -> {
			"StringFirst",
			"StringRest",
			"StringLast"
		},
		Author -> {"scicomp", "brad"}
	}];


(* ::Subsubsection::Closed:: *)
(*StringRest*)


DefineUsage[StringRest,
	{
		BasicDefinitions -> {
			{"StringRest[string]", "outputString", "returns the all but the first character from the input 'string'."}
		},
		Input :> {
			{"string", ListableP[_String], "The string(s) to extract all but the first character from."}
		},
		Output :> {
			{"outputString", ListableP[_String], "All but the first character of each input string."}
		},
		SeeAlso -> {
			"StringFirst",
			"StringMost",
			"StringLast"
		},
		Author -> {"scicomp", "brad"}
	}];


(* ::Subsubsection::Closed:: *)
(*StringPartitionRemainder*)


DefineUsage[StringPartitionRemainder,
	{
		BasicDefinitions -> {
			{"StringPartitionRemainder[string,partitionSize]", "substrings", "partitions 'string' into substrings of length 'partitionSize', allowing the final substring to be shorter than 'partitionSize'."}
		},
		Input :> {
			{"string", ListableP[_String], "The string to partition."},
			{"partitionSize", ListableP[_Integer?Positive], "The maximum number of characters to place in each partitioned substring."}
		},
		Output :> {
			{"substrings", {_String..}, "A list of substrings containing 'partitionSize' characters, with the last substring potentially containing fewer characters."}
		},
		SeeAlso -> {
			"StringPartition",
			"PartitionRemainder",
			"Partition"
		},
		Author -> {"hayley", "mohamad.zandian", "wyatt"}
	}];


(* ::Subsection::Closed:: *)
(*List Manipulation*)


(* ::Subsubsection::Closed:: *)
(*Repeat*)


DefineUsage[Repeat,
	{
		BasicDefinitions -> {
			{"Repeat[item,n]", "list", "generates a list of 'n' repeated 'item's."},
			{"Repeat[{item},n]", "list", "generates a list of 'n' repeated 'item's."}
		},
		AdditionalDefinitions -> {

		},
		MoreInformation -> {
			"If provided a singleton list, removes that item from the list before repeating it."
		},
		Input :> {
			{"item", _, "Any item you wish to have repeated."},
			{"n", _Integer, "Number of times you want the item repeated."}
		},
		Output :> {
			{"list", _List, "List of the item repeated n times."}
		},
		Behaviors -> {

		},
		Guides -> {

		},
		Tutorials -> {

		},
		Sync -> Automatic,
		SeeAlso -> {
			"RepeatedQ",
			"Repeated"
		},
		Author -> {"xu.yi", "frezza"}
	}];


(* ::Subsubsection::Closed:: *)
(*PartitionRemainder*)


DefineUsage[PartitionRemainder,
	{
		BasicDefinitions -> {
			{"PartitionRemainder[list,n]", "lists", "partitions 'list' into nonoverlapping sublists of length 'n' with remaining items that don't divide evenly into a final sublist."},
			{"PartitionRemainder[list,n,d]", "lists", "generates overlapping sublists with offset 'd'."}
		},
		Input :> {
			{"list", _List, "The List to be Partitioned."},
			{"n", _Integer?Positive, "The number of elements in each partitioned group."},
			{"d", _Integer?Positive, "The offset for which each partition should be separated by."}
		},
		Output :> {
			{"lists", {_List..}, "List of sublists partitions."}
		},
		SeeAlso -> {
			"Partition",
			"Split"
		},
		Author -> {
			"Frezza"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*SetDifference*)


DefineUsage[SetDifference,
	{
		BasicDefinitions -> {
			{"SetDifference[a,b]", "c", "returns a list of objects 'c' that are not in both 'a' and 'b'."}
		},
		MoreInformation -> {
			"SetDifference[a,b] is equal to: Union[Join[Complement[a,b],Complement[b,a]]]."
		},
		Input :> {
			{"a", _List, "First list."},
			{"b", _List, "Second list."}
		},
		Output :> {
			{"c", _List, "List containing elements that are in either 'a' or 'b', but not in both."}
		},
		SeeAlso -> {
			"Complement",
			"Union"
		},
		Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
	}];


(* ::Subsubsection::Closed:: *)
(*ReplaceRule*)


DefineUsage[ReplaceRule,
	{
		BasicDefinitions -> {
			{"ReplaceRule[ listOfRules, newRule ]", "newListOfRules", "replaces in 'listOfRules' all rules of the form Rule[a,_] or RuleDelayed[a,_] with 'newRule'."},
			{"ReplaceRule[ listOfRules, newRules ]", "newListOfRules", "replaces in 'listOfRules' all rules whose left hand sides match rules in 'newRules'."}
		},
		MoreInformation -> {
			"This can be used to replace parts of SLL info, such as updating peaks in info",
			"Default is to replace only at level 1, but can use Level option to go deeper."
		},
		Input :> {
			{"listOfRules", {(_Rule | _RuleDelayed)..}, "The list of rules that will be updated."},
			{"newRule", ("a" -> _) | ("a" :> _), "The new rule that will replace things in 'listOfRules'."},
			{"newRules", {(_Rule | _RuleDelayed)..}, "The new rules that will replace things in 'listOfRules'."}
		},
		Output :> {
			{"newListOfRules", {(_Rule | _RuleDelayed)..}, "Updated list of rules."}
		},
		SeeAlso -> {
			"ExtractRule",
			"Association"
		},
		Author -> {"scicomp", "brad"}
	}];


(* ::Subsubsection::Closed:: *)
(*ExtractRule*)


DefineUsage[ExtractRule,
	{
		BasicDefinitions -> {
			{"ExtractRule[listOfRules, field]", "out", "extracts the first rule whose left side match 'field'."}
		},
		Input :> {
			{"listOfRules", {(_Rule | _RuleDelayed)..}, "A list of rules from which we will extract rules."},
			{"field", _, "The left side of rules to extract."}
		},
		Output :> {
			{"out", _Rule | _RuleDelayed, "A rule or ruledelayed from 'listOfRules' whose left side matches 'field'."}
		},
		SeeAlso -> {
			"ReplaceRule",
			"Association"
		},
		Author -> {"scicomp", "brad"}
	}];


(* ::Subsubsection::Closed:: *)
(*PickList*)


DefineUsage[PickList,
	{
		BasicDefinitions -> {
			{"PickList[list, sel]", "filteredList", "finds those elements of 'list' for which the corresponding element of 'sel' is True and returns a list of those elements."},
			{"PickList[list, sel, pattern]", "filteredList", "finds those elements of 'list' for which the corresponding element of 'sel' matches 'pattern', and returns a list of those elements."}
		},
		MoreInformation -> {
			"PickList behaves similarly to the Mathematica function Pick, except for in the following cases, where Pick can behave in unusual ways:",
			"If list = {a, b, f[b]} and sel = {1, Cos[1], Sin[1]}, that Pick[list, sel, 1] returns {a, f[b]} because it works on sequences regardless of their head.  PickList works only on the list level so, PickList[list, sel, 1] will return {a}.",
			"PickList matches only on lists and not sequences, and thus will not function at multiple depths or with arbitrary sequences.",
			"PickList does not work with SparseArrays as Pick does.",
			"PickList is substantially slower than Pick in the case of very large lists of inputs."
		},
		Input :> {
			{"list", _List, "A list of items."},
			{"sel", _List, "A list of items equal in length to 'list'."},
			{"pattern", _, "Any pattern to match the items of 'sel' to.  For those items that match, append the corresponding element of 'list' to the returned 'filteredList'."}
		},
		Output :> {
			{"filteredList", _List, "A list of items that consists only of elements 'list' for which the corresponding element of 'sele' is either True, or matches 'pattern'."}
		},
		SeeAlso -> {
			"Pick",
			"Select"
		},
		Author -> {"xu.yi", "hanming.yang", "steven"}
	}];


(* ::Subsubsection::Closed:: *)
(*UnsortedComplement*)


DefineUsage[UnsortedComplement,
	{
		BasicDefinitions->{
			{"UnsortedComplement[expression1,expression2]","outputExpression","returns the elements that are in expression1 but not in expression2, in the order they are present in expression1."}
		},
		MoreInformation->{},
		Input:>{
			{"expression1",_,"The list from which to eliminate elements of expression2."},
			{"expression2",_,"The list of elements to remove from expression1."}
		},
		Output:>{
			{"outputList",_,"The list of elements that are in expression1 but not in expression2."}
		},
		Behaviors->{},
		SeeAlso->{"PickList","PartitionRemainder","Complement"},
		Author->{"xu.yi", "hanming.yang", "thomas", "gokay.yamankurt"}
	}
];


(* ::Subsubsection::Closed:: *)
(*UnsortedIntersection*)


DefineUsage[UnsortedIntersection,
	{
		BasicDefinitions->{
			{"UnsortedIntersection[expression1, expression2, ..., expressioni]","outputExpression","returns the elements that are common to 'expression1', 'expression2', ... and 'expressioni', in the order they are present in 'expression1'."}
		},
		MoreInformation->{},
		Input:>{
			{"expression1",_,"The 1st expression to check and dictates the order of elements that are common to expression2, ... and expressioni."},
			{"expression2",_,"The 2nd expression of elements to check for common elements."},
			{"expressioni",_,"The ith expression of elements to check for common elements."}
		},
		Output:>{
			{"outputExpression",_,"The list of elements that are in expression1 and in expression2."}
		},
		Behaviors->{},
		SeeAlso->{"Intersection", "UnsortedComplement","Complement"},
		Author->{"xu.yi", "hanming.yang", "steven"}
	}
];



(* ::Subsubsection::Closed:: *)
(*RepeatedQ*)


DefineUsage[RepeatedQ,
	{
		BasicDefinitions -> {
			{"RepeatedQ[items_List]", "repeatedbooleanP", "repeatedQ returns true when all items in the provided list are identical."}
		},
		MoreInformation -> {
			"Empty lists count as repeated."
		},
		Input :> {
			{"'items'", _, "A list of things."}
		},
		Output :> {
			{"'repeated'", _, "True if all items in the list are identical."}
		},
		SeeAlso -> {
			"SameLengthQ",
			"Repeat"
		},
		Author -> {"scicomp", "brad"}
	}];


(* ::Subsubsection::Closed:: *)
(*SameLengthQ*)


DefineUsage[SameLengthQ,
	{
		BasicDefinitions -> {
			{"SameLengthQ[items]", "bool", "compares the lengths of a sequence of items.  Returns True if they are all the same length.  Non-lists are length 0, and it can safely check that all items return length 0 as well."}
		},
		Input :> {
			{"items", __, "Sequence of lists whose lengths will be compared."}
		},
		Output :> {
			{"bool", BooleanP, "True of input lists are all the same length.  False otherwise."}
		},
		SeeAlso -> {
			"Length",
			"ListQ"
		},
		Author -> {"scicomp", "brad", "Frezza"}
	}];


(* ::Subsubsection::Closed:: *)
(*GroupByTotal*)


DefineUsage[GroupByTotal,
	{
		BasicDefinitions -> {
			{"GroupByTotal[values,target]", "outGroups", "groups 'values' such that the total summation of a each grouping is as close to the 'target' value as possible without going over."},
			{"GroupByTotal[{{label, value}..},target]", "outGroups", "groups based on 'values' while perserving 'label' information in the grouping."}
		},
		MoreInformation -> {
			"GroupByTotal uses a greedy algorithm to successively construct each grouping to be individually closest to the target value and does not try to minimize the distance between all values together."
		},
		Input :> {
			{"target", Alternatives[NumericP, MassP, VolumeP, AreaP], "The target total for the groupings."},
			{"values", {Alternatives[NumericP, MassP, VolumeP, AreaP]..}, "List of values to be grouped based on the target total."},
			{"value", Alternatives[NumericP, MassP, VolumeP, AreaP], "A labeled value to grouped based on the target total."},
			{"label", __, "A label for a single value used to keep track of said value."}
		},
		Output :> {
			{"outGroups", _List, "List of groupings under target length."}
		},
		SeeAlso -> {
			"KnapsackSolve",
			"Unflatten"
		},
		Author -> {"scicomp", "brad"}
	}];


(* ::Subsubsection::Closed:: *)
(*ExpandDimensions*)


DefineUsage[ExpandDimensions,
	{
		BasicDefinitions -> {
			{"ExpandDimensions[full,partial]", "out", "expands dimensions of 'partial' to match dimensions of 'full'."}
		},
		MoreInformation -> {
			"Expands dimensions by padding right with last element of corresponding dimension of 'partial'."
		},
		Input :> {
			{"full", _, "An expression containing arbitrary depths of nested lists."},
			{"partial", _, "An expression containing arbitrary depths of nested lists."}
		},
		Output :> {
			{"out", _, "Has the same dimensions as 'full', but with elements of 'partial' inserted and expanded when necessary."}
		},
		SeeAlso -> {
			"PadRight",
			"Unflatten"
		},
		Author -> {"scicomp", "brad", "alice", "robert"}
	}];


(* ::Subsubsection::Closed:: *)
(*Unflatten*)


DefineUsage[Unflatten,
	{
		BasicDefinitions -> {
			{"Unflatten[flatList, listyList]", "out", "restructures the flat list 'flatList' so it has the same structure as 'listyList'."},
			{"Unflatten[flatList, listyList, pattern]", "out", "assumes 'listyList' is a nested list containing only things that MatchQ with 'pattern'."}
		},
		Input :> {
			{"flatList", _List, "A flat list that will be restructured to have the same shape as 'listyList'."},
			{"listyList", _List, "A nested list of lists with arbitrary list nesting."},
			{"pattern", _, "A pattern that matches all the elements of 'listyList'."}
		},
		Output :> {
			{"out", _List, "A list with the same structure as 'listyList', but containing the elements from 'flatList'."}
		},
		SeeAlso -> {
			"ArrayReshape",
			"Partition",
			"Flatten"
		},
		Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
	}];



(* ::Subsubsection::Closed:: *)
(*Middle*)


DefineUsage[Middle,
	{
		BasicDefinitions -> {
			{"Middle[expr]", "out", "returns the middle element of 'expr'."}
		},
		MoreInformation -> {
			"If the Length of 'expr' is even, returns the element immediately to the left of middle.",
			"Use Return->Right to return the element immediately right of middle in the case of even length input."
		},
		Input :> {
			{"expr", _, "A non-atomic expression with a middle element."}
		},
		Output :> {
			{"out", _, "The middle element of 'expr'."}
		},
		SeeAlso -> {
			"First",
			"Last"
		},
		Author -> {"scicomp", "brad"}
	}];


(* ::Subsubsection::Closed:: *)
(*RiffleAlternatives*)


DefineUsage[RiffleAlternatives,
	{
		BasicDefinitions -> {
			{"RiffleAlternatives[trueList,falseList,boolList]", "combinedList", "combines the elements of 'trueList' with 'falseList' by mapping over 'boolList' and selecting the next element from the 'trueList' for a True Bool or from 'falseList' for a False Bool."}
		},
		MoreInformation -> {},
		Input :> {
			{"trueList", _List, "A list of elements to be combined with 'falseList'."},
			{"falseList", _List, "A list of elements to be combined with 'trueList'."},
			{"boolList", _List, "A list of booleans that determines how the 'trueList' and 'falseList' are combined."}
		},
		Output :> {{"combinedList", _List, "The combined list."}},
		SeeAlso -> {"Position", "PickList"},
		Author -> {"scicomp", "brad"}
	}];


(* Subsection::Closed:: *)
(* Association Manipulation *)

(* Subsubsection::Closed:: *)
(* KeyReplace *)

DefineUsage[KeyReplace,
	{
		BasicDefinitions->
			{
				{"KeyReplace[assoc, rule]", "newAssoc", "returns a new association with key replaced according to the rule."},
				{"KeyReplace[assoc, listOfRules]", "newAssoc", "returns a new association with keys replaced according to the list of rules."},
				{"KeyReplace[listOfAssoc, rule]","newListOfAssoc", "returns a new list of associations with key replaced according to the rule."},
				{"KeyReplace[listOfAssoc, listOfRules]","newListOfAssoc", "returns a new list of associations with keys replaced according to the list of rules."}
			},
		Input:>
			{
				{"assoc", _Association, "The association that will be updated."},
				{"listOfAssoc", {_Association}, "The list of associations that will be updated."},
				{"rule", _Rule, "The rule contains the key in the association and the new key to replace it."},
				{"listOfRules", {_Rule...}, "The list of rules contains the keys in the association and the new keys to replace them."}
			},
		Output:>
			{
				{"newAssoc", _Association, "a new association with replaced keys."},
				{"newListOfAssoc", {_Association...}, "a list of new associations with replaced keys."}
			},
		Sync->Automatic,
		SeeAlso->
			{
				"KeyMap",
				"KeyTake",
				"KeySelect",
				"ReplaceRule"
			},
		Author->{"axu", "dirk.schild", "zechen.zhang"}
	}];

(* ::Subsection::Closed:: *)
(*Geometry and Trigonometry*)


(* ::Subsubsection::Closed:: *)
(*TranslateCoordinates*)


DefineUsage[TranslateCoordinates,
	{
		BasicDefinitions -> {
			{"TranslateCoordinates[coordinates,offset]", "newCoords", "adjusts the cartesian coordinates by the amounts specified in offset, overloaded to handle lists of offsets and lists of lists of cordinates."}
		},
		Input :> {
			{"coordinates", {{_, _}...}, "The coordinates to translate."},
			{"offset", _, "The amount each dimension will be translated."}
		},
		Output :> {
			{"newCoords", {{_, _}...}, "The translated coordinates."}
		},
		SeeAlso -> {
			"RescaleData",
			"RescaleY"
		},
		Author -> {"scicomp", "brad"}
	}];


(* ::Subsubsection::Closed:: *)
(*RescaleData*)


DefineUsage[RescaleData,
	{
		BasicDefinitions -> {
			{"RescaleData[data,{oldMin,oldMax},{newMin,newMax}]", "newData", "scales all of the values in the list to a new maximum and minimum based upon an old maximum and minimum value."}
		},
		Input :> {
			{"data", {_?NumericQ..}, "Data points to be rescaled."},
			{"oldMin", _?NumericQ, "Old minimum value."},
			{"oldMax", _?NumericQ, "Old maximum value."},
			{"newMin", _?NumericQ, "New minimum value."},
			{"newMax", _?NumericQ, "New maximum value."}
		},
		Output :> {
			{"newData", {_?NumericQ..}, "Scaled version of 'data' that varies betwen 'newMin' and 'newMax'."}
		},
		SeeAlso -> {
			"RescaleY",
			"TranslateCoordinates"
		},
		Author -> {"scicomp", "brad"}
	}];


(* ::Subsubsection::Closed:: *)
(*RescaleY*)


DefineUsage[RescaleY,
	{
		BasicDefinitions -> {
			{"RescaleY[data,{oldMin,oldMax},{newMin,newMax}]", "newData", "scales only the Y values of a set of {x,y} coordinates to a new maximum and minimum based upon an old maximum and minimum value."}
		},
		Input :> {
			{"data", {{_?NumericQ, _?NumericQ}..}, "The {x,y} data points."},
			{"oldMin", _?NumericQ, "Old minimum values."},
			{"oldMax", _?NumericQ, "Old maximum values."},
			{"newMin", _?NumericQ, "New minimum values."},
			{"newMax", _?NumericQ, "New maximum values."}
		},
		Output :> {
			{"newData", {{_?NumericQ, _?NumericQ}..}, "List of {x,y} with y scaled to the new min, max scales."}
		},
		SeeAlso -> {
			"RescaleData",
			"TranslateCoordinates"
		},
		Author -> {"scicomp", "brad"}
	}];


(* ::Subsection::Closed:: *)
(*SLL Utilities*)


(* ::Subsubsection::Closed:: *)
(*SafeBinaryReadFile*)

DefineUsage[SafeBinaryReadFile,
	{
		BasicDefinitions -> {
			{"SafeBinaryReadFile[filename,type,chunksize]", "newData", "binary reads the contents of `filename` as articulated by its `type` in `chunksize` sequences."}
		},
		MoreInformation -> {
		},
		Input :> {
			{"filename", _String, "The file location to open for binary reading."},
			{"type", _, "A singleton or tuple of byte types defining the patterns."},
			{"chunkSize", _, "The number of objects with each entry defined by the type."}
		},
		Output :> {
			{"newData", {{_?NumericQ..}..}, "The desired data in the desired format."}
		},
		Behaviors -> {},
		SeeAlso -> {"FastImport"},
		Author -> {"xu.yi", "hanming.yang", "thomas"}
	}
];


(* ::Subsubsection::Closed:: *)
(*AssociationMatchQ*)


DefineUsage[AssociationMatchQ,
	{
		BasicDefinitions -> {
			{"AssociationMatchQ[testAssociation,patternAssociation]", "boolean", "compares the key-value pairs in 'testAssociation' to the keys and patterns in 'patternAssociation' and returns True if each key-value matches the pattern specified in the 'patternAssociation'."}
		},
		MoreInformation -> {
		},
		Input :> {
			{"testAssociation", _Association, "The association to verify has correct keys and value patterns."},
			{"patternAssociation", _Association, "An association defining the correct keys and value patterns."}
		},
		Output :> {
			{"boolean", BooleanP, "True when the test association's key values match the patterns in the pattern association, otherwise False."}
		},
		Behaviors -> {},
		SeeAlso -> {"AssociationMatchP", "Association"},
		Author -> {"robert", "alou"}
	}];



(* ::Subsubsection::Closed:: *)
(*AssociationMatchP*)


DefineUsage[AssociationMatchP,
	{
		BasicDefinitions -> {
			{"AssociationMatchP[patternAssociation]", "pattern", "generates 'pattern' that matches an association with key-value patterns that match the patterns specified in 'patternAssociation'."}
		},
		MoreInformation -> {
		},
		Input :> {
			{"patternAssociation", _Association, "An association defining the correct keys and value patterns."}
		},
		Output :> {
			{"pattern", _PatternTest, "Pattern to use against a test association."}
		},
		Behaviors -> {},
		SeeAlso -> {"AssociationMatchQ", "Association"},
		Author -> {"robert", "alou"}
	}];


(* ::Subsubsection::Closed:: *)
(*LibraryFunctions*)


DefineUsage[LibraryFunctions,
	{
		BasicDefinitions -> {
			{"LibraryFunctions[]", "symbols", "lists all the exported symbols that have DownValues for all available packages."},
			{"LibraryFunctions[package]", "symbols", "lists all the exported symbols that have DownValues for the specified package."}
		},
		MoreInformation -> {
		},
		Input :> {
			{"package", _String, "The name of a valid package, as listed by Packager`AvailablePackages[]."}
		},
		Output :> {
			{"symbols", {_Symbol...}, "The exported functions for that package, or all packages."}
		},
		Behaviors -> {
		},
		SeeAlso -> {"AvailablePackages", "OpenSourceCode"},
		Author -> {"platform"}
	}];