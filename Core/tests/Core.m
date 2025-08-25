(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection::Closed:: *)
(*SafeBinaryReadFile*)


DefineTests[SafeBinaryReadFile, {
	Example[{Basic, "Overload one function into another:"},
		Module[{file},
			file=FileNameJoin[{$TemporaryDirectory, CreateUUID[]}];
			BinaryWrite[file, {8, 97, 255}];
			Close[file];

			SafeBinaryReadFile[file, "Byte"]
		],
		_List
	]
}];

(* ::Subsection::Closed:: *)
(*Function writing functions*)


(* ::Subsubsection::Closed:: *)
(*overload*)


DefineTests[overload, {

	Example[{Basic, "Overload one function into another:"},
		overload[Unique["newFunc"], A -> ReplaceRule],
		{RuleDelayed[_HoldPattern, _ReplaceRule]...}
	],

	Example[{Basic, "Overload multiple functions function into another:"},
		overload[Unique["newFunc"], {A -> ReplaceRule, B -> DateString}],
		{{RuleDelayed[_HoldPattern, _ReplaceRule]...}, {RuleDelayed[_HoldPattern, _DateString]...}}
	],

	Example[{Basic, "Overload one function into another:"},
		overload[Unique["newFunc"], protocol[CellSplit] -> ReplaceRule],
		{RuleDelayed[_HoldPattern, _ReplaceRule]...}
	]

}];



(* ::Subsection::Closed:: *)
(*File Finding & Manipulation*)


(* ::Subsubsection::Closed:: *)
(*FastExport*)


DefineTests[
	FastExport,
	{
		Example[{Basic, "Export a string to a file:"},
			file=FileNameJoin[{$TemporaryDirectory, CreateUUID[]}];
			FastExport[file, "my exported string", "Text"],
			file,
			Variables :> {file},
			TearDown :> (DeleteFile[file])
		],
		Example[{Basic, "String is written to the exported file's contents:"},
			file=FileNameJoin[{$TemporaryDirectory, CreateUUID[]}];
			FastExport[file, "my exported string", "Text"];
			Import[file, "Text"],
			"my exported string",
			Variables :> {file},
			TearDown :> (DeleteFile[file])
		],
		Example[{Basic, "Existing files are overwritten:"},
			file=FileNameJoin[{$TemporaryDirectory, CreateUUID[]}];
			FastExport[file, "my first exported string", "Text"];
			FastExport[file, "my second exported string", "Text"];
			Import[file, "Text"],
			"my second exported string",
			Variables :> {file},
			TearDown :> (DeleteFile[file])
		],
		Example[{Basic, "Non-text files are exported according to their file type specification using Export:"},
			file=FileNameJoin[{$TemporaryDirectory, CreateUUID[]}];
			FastExport[file, "{{{"My excel file ", "", "", "", "", "", "", "", "", "", "", "",
   ""}, {"", "", "", "", "", "", "", "", "", "", "", "", ""}, {"cat ",
   "dog ", "horse ", "", "frog ", "snake ", "", "bird ", "", "", "", "",
   ""}, {"taco ", "burrito ", "soup ", "salad ", "", "", "", "", "", "",
   "", "", ""}, {"", "", "", "", "", "", "", "", "", "", "", "",
   ""}, {"1", "1.25", "", "", "10", "20", "", "", "100", "101", "",
   "55", "55"}}}", "XLS"],
			file,
			Variables :> {file},
			TearDown :> (DeleteFile[file])
		],
		Example[{Additional, "FastExport should always be faster than Export:"},
			myString=StringJoin @@ Table["apple", {10000000}];
			exportFile=FileNameJoin[{$TemporaryDirectory, CreateUUID[]<>".csv"}];
			fastExportFile=FileNameJoin[{$TemporaryDirectory, CreateUUID[]<>".csv"}];
			exportSpeed=First[AbsoluteTiming[Export[exportFile, myString]]];
			fastExportSpeed=First[AbsoluteTiming[FastExport[fastExportFile, myString, "Text"]]];
			{fastExportSpeed, exportSpeed},
			_?(#[[1]] < #[[2]]&),
			Variables :> {myString, exportFile, fastExportFile, exportSpeed, fastExportSpeed},
			TearDown :> (
				DeleteFile[exportFile];
				DeleteFile[fastExportFile];
			)
		],
		Example[{Options, CharacterEncoding, "Specify the character encoding to be used in the file's content string:"},
			asciiFile=FileNameJoin[{$TemporaryDirectory, CreateUUID[]}];
			utf8File=FileNameJoin[{$TemporaryDirectory, CreateUUID[]}];
			FastExport[asciiFile, "\[RuleDelayed]", "Text", CharacterEncoding -> "ASCII"];
			FastExport[utf8File, "\[RuleDelayed]", "Text", CharacterEncoding -> "UTF8"];
			{Import[asciiFile, "Text"], Import[utf8File, "Text"]},
			{":>", "\[RuleDelayed]"},
			Variables :> {asciiFile, utf8File},
			TearDown :> (
				DeleteFile[asciiFile];
				DeleteFile[utf8File];
			)
		],
		Example[{Options, BinaryFormat, "Specifies that a write stream should be opened in binary format, so that no textual interpretation of newlines or other data is done:"},
			file=FileNameJoin[{$TemporaryDirectory, CreateUUID[]}];
			FastExport[file, "my exported string", "Text", BinaryFormat -> True],
			file,
			Variables :> {file},
			TearDown :> (DeleteFile[file])
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*FastImport*)


DefineTests[
	FastImport,
	{
		Example[{Basic, "Import a tab-separated (TSV) file:"},
			filePath=FileNameJoin[{$TemporaryDirectory, "FPLC-file-trace.ASC"}];
			DownloadCloudFile[Object[EmeraldCloudFile, "Fake cloud file 1 for FastImport unit tests"], filePath];
			FastImport[filePath, "TSV"],
			{{___String}..},
			Variables :> {filePath}
		],
		Example[{Basic, "Import a comma-separated (CSV) file:"},
			filePath=FileNameJoin[{$TemporaryDirectory, "absorbance_quantification_1.csv"}];
			DownloadCloudFile[Object[EmeraldCloudFile, "Fake cloud file 2 for FastImport unit tests"], filePath];
			FastImport[filePath, "CSV"],
			{{___String}..},
			Variables :> {filePath}
		],
		Example[{Basic, "Import a raw text file:"},
			filePath=FileNameJoin[{$TemporaryDirectory, "post_PAGE_cleanup_script.bat"}];
			DownloadCloudFile[Object[EmeraldCloudFile, "Fake cloud file 3 for FastImport unit tests"], filePath];
			FastImport[filePath, "Text"],
			_String,
			Variables :> {filePath}
		],
		Example[{Additional, "Imports a list of filepaths and filetypes:"},
			filePaths={
				FileNameJoin[{$TemporaryDirectory, "FPLC-file-trace.ASC"}],
				FileNameJoin[{$TemporaryDirectory, "absorbance_quantification_1.csv"}],
				FileNameJoin[{$TemporaryDirectory, "post_PAGE_cleanup_script.bat"}]
			};
			cloudFiles={
				Object[EmeraldCloudFile, "Fake cloud file 1 for FastImport unit tests"],
				Object[EmeraldCloudFile, "Fake cloud file 2 for FastImport unit tests"],
				Object[EmeraldCloudFile, "Fake cloud file 3 for FastImport unit tests"]
			};

			(* Move cloudfiles to local filesystem *)
			MapThread[
				DownloadCloudFile,
				{cloudFiles, filePaths}
			];
			FastImport[filePaths, {"TSV", "CSV", "Text"}],
			{{{___String}..}, {{___String}..}, _String},
			Variables :> {filePaths, cloudFiles}
		],
		Example[{Additional, "Imports a list of filepaths with the same filetype:"},
			filePaths={
				FileNameJoin[{$TemporaryDirectory, "test1.txt"}],
				FileNameJoin[{$TemporaryDirectory, "test2.txt"}]
			};
			cloudFiles={
				Object[EmeraldCloudFile, "Fake cloud file 4 for FastImport unit tests"],
				Object[EmeraldCloudFile, "Fake cloud file 5 for FastImport unit tests"]
			};

			(* Move cloudfiles to local filesystem *)
			MapThread[
				DownloadCloudFile,
				{cloudFiles, filePaths}
			];
			FastImport[filePaths, "Text"],
			{_String, _String},
			Variables :> {filePaths, cloudFiles}
		],
		Example[{Additional, "If given a file type besides TSV, CSV, or raw text, then FastImport calls Import:"},
			filePath=FileNameJoin[{$TemporaryDirectory, "PAGE_gel_image.jpg"}];
			DownloadCloudFile[Object[EmeraldCloudFile, "Fake cloud file 6 for FastImport unit tests"], filePath];
			FastImport[filePath, "JPEG"],
			_Image,
			Variables :> {filePath}
		],
		Example[{Options, Retries, "Repeatedly attempts to locate the file, pausing after each failure, until there are no remaining retries:"},
			filePath=FileNameJoin[{$TemporaryDirectory, "anExtremelyStrangeFileWhichDoesNotExist.jpg"}];
			First[AbsoluteTiming[FastImport[filePath, "JPEG", Retries -> 2]]] > 6,
			True,
			Messages :> {Message[FastImport::MissingFile]},
			Variables :> {filePath}
		],
		Example[{Messages, "MissingFile", "Prints a message and returns $Failed if the file could not be found:"},
			filePath=FileNameJoin[{$TemporaryDirectory, "anExtremelyStrangeFileWhichDoesNotExist.jpg"}];
			FastImport[filePath, "JPEG"],
			$Failed,
			Messages :> {Message[FastImport::MissingFile]},
			Variables :> {filePath}
		],
		Example[{Options, RetryDelay, "Retries and the associated delays only occur if the file cannot be found on the first attempt:"},
			filePath=FileNameJoin[{$TemporaryDirectory, "absorbance_quantification_1.csv"}];
			DownloadCloudFile[Object[EmeraldCloudFile, "Fake cloud file 2 for FastImport unit tests"], filePath];
			First[AbsoluteTiming[FastImport[filePath, "CSV", Retries -> 5, RetryDelay -> 10 Second]]] < 5,
			True,
			Variables :> {filePath}
		],
		Test["FastImport is can import XLSX files with unparsable elements without a warning:",
			FastImport[
				DownloadCloudFile[
					EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard14/d0d6babdbc64ba0b34a6b507cdc11435.xlsx", "dORYzZRDvlkPcBDm61v1OmkxiEboeO5qRkLw"],
					$TemporaryDirectory
				],
				"XLSX"
			],
			{{___..}..}
		],
		Test["FastImport is always faster than Import for TSV files:",
			importSpeed=First[AbsoluteTiming[Import[FileNameJoin[{$TemporaryDirectory, "FPLC-file-trace.ASC"}], "TSV"]]];
			fastImportSpeed=First[AbsoluteTiming[FastImport[FileNameJoin[{$TemporaryDirectory, "FPLC-file-trace.ASC"}], "TSV"]]];
			fastImportSpeed < importSpeed,
			True,
			SetUp :> {
				DownloadCloudFile[Object[EmeraldCloudFile, "Fake cloud file 1 for FastImport unit tests"], FileNameJoin[{$TemporaryDirectory, "FPLC-file-trace.ASC"}]]
			},
			Variables :> {importSpeed, fastImportSpeed}
		],
		Test["FastImport is always faster than Import for CSV files:",
			importSpeed=First[AbsoluteTiming[Import[FileNameJoin[{$TemporaryDirectory, "absorbance_quantification_1.csv"}], "CSV"]]];
			fastImportSpeed=First[AbsoluteTiming[FastImport[FileNameJoin[{$TemporaryDirectory, "absorbance_quantification_1.csv"}], "CSV"]]];
			fastImportSpeed < importSpeed,
			True,
			SetUp :> {
				DownloadCloudFile[Object[EmeraldCloudFile, "Fake cloud file 2 for FastImport unit tests"], FileNameJoin[{$TemporaryDirectory, "absorbance_quantification_1.csv"}]]
			},
			Variables :> {importSpeed, fastImportSpeed}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*xmlFileQ*)


DefineTests[
	xmlFileQ,
	{
		Example[{Basic, "Returns True if input ends with .xml and exists:"},
			xmlFileQ[TestFile],
			True
		],
		Example[{Basic, "Returns False because file does not exist:"},
			xmlFileQ["Fake.xml"],
			False
		],
		Example[{Basic, "Returns False because file does not end with .xml:"},
			xmlFileQ["EmeraldReference.nb"],
			False
		],
		Test["Testing that random symbols works properly:",
			xmlFileQ[Fish],
			False
		],
		Example[{Attributes, Listable, "Function xmlFileQ is listable:"},
			xmlFileQ[{TestFile, "Fake.xml", "asdasd", Fish}],
			{True, False, False, False}
		]
	},
	Variables :> {TestFile},
	SetUp :> (TestFile=FileNameJoin[{$PublicPath, "PDFs", "testLib.xml"}]),
	Skip -> "File Server"
];




(* ::Subsection::Closed:: *)
(*Rounding*)


(* ::Subsubsection::Closed:: *)
(*SignificantFigures*)


DefineTests[SignificantFigures,
	{
		Example[
			{Basic, "Round to one significant figure:"},
			SignificantFigures[6394.86734`, 1],
			6000
		],
		Example[
			{Basic, "Round to two significant figures:"},
			SignificantFigures[6394.86734`, 2],
			6400
		],
		Test[
			"Round to three significant figures:",
			SignificantFigures[6394.86734`, 3],
			6390
		],
		Test[
			"Round to four significant figures:",
			SignificantFigures[6394.86734`, 4],
			6395
		],
		Test[
			"Round to 5 significant figures:",
			N[SignificantFigures[6394.86734`, 5]],
			6394.9`
		],
		Test[
			"Round to 6 significant figures:",
			N[SignificantFigures[6394.86734`, 6]],
			6394.87`
		],
		Example[
			{Basic, "Round to 7 significant figures:"},
			N[SignificantFigures[6394.86734`, 7]],
			6394.867`
		],
		Test[
			"Round to 8 significant figures:",
			N[SignificantFigures[6394.86734`, 8]],
			6394.8673`
		],
		Test[
			"Round to 9 significant figures:",
			N[SignificantFigures[6394.86734`, 9]],
			6394.86734`
		],
		Example[
			{Basic, "Round to 10 significant figures:"},
			N[SignificantFigures[6394.86734`, 10]],
			6394.86734`
		],

		Test["List of numbers:",
			N[SignificantFigures[{-9.26474, 12.7203, 3.32697, 0.570094, 15.3758, 9.79555, -8.39222,
				-1.15754, 1.42789, 19.814}, 3]],
			{-9.26, 12.7, 3.33, 0.57, 15.4, 9.8, -8.39, -1.16, 1.43, 19.8}
		],
		Test["List of quantities:",
			N[SignificantFigures[{Quantity[-9.264743604857657, "Meters"], Quantity[12.72034251547899, "Kilograms"], Quantity[3.3269709639614504, "Seconds"],
				Quantity[0.5700939500390945, "Meters"], Quantity[15.37576881977688, "Meters"], Quantity[9.795552236440926, "Seconds"],
				Quantity[-8.392222458036045, "Kilograms"], Quantity[-1.157539315795674, "Seconds"], Quantity[1.4278867164805433, "Meters"],
				Quantity[19.81396508228572, "Kilograms"]}, 3]],
			{Quantity[-9.26, "Meters"], Quantity[12.7, "Kilograms"], Quantity[3.33, "Seconds"], Quantity[0.57, "Meters"], Quantity[15.4, "Meters"],
				Quantity[9.8, "Seconds"], Quantity[-8.39, "Kilograms"], Quantity[-1.16, "Seconds"], Quantity[1.43, "Meters"], Quantity[19.8, "Kilograms"]}
		],
		Test["Mixed list:",
			N[SignificantFigures[{-9.264743604857657, 12.72034251547899, Quantity[3.3269709639614504, "Meters"], Quantity[0.5700939500390945, "Meters"], 15.37576881977688,
				Quantity[9.795552236440926, "Meters"], -8.392222458036045, -1.157539315795674, 1.4278867164805433, 19.81396508228572}, 3]],
			{-9.26, 12.7, Quantity[3.33, "Meters"], Quantity[0.57, "Meters"], 15.4, Quantity[9.8, "Meters"], -8.39, -1.16, 1.43, 19.8}
		],
		Test["Negative number:", N@SignificantFigures[-12.3456, 3], -12.3],
		Test["Negative Quantity:", N@SignificantFigures[Quantity[-12.3456, "Meters"], 3], Quantity[-12.3, "Meters"]],
		Test["Null:", SignificantFigures[Null, 3], Null],
		Test["Null list:", SignificantFigures[{Null, Null, Null}, 3], {Null, Null, Null}]
	}];


(* ::Subsection::Closed:: *)
(*String Manipulation*)


(* ::Subsubsection::Closed:: *)
(*StringFirst*)


DefineTests[StringFirst, {
	Example[{Basic, "Extract the first character of a string:"},
		StringFirst["abcd"],
		"a"
	],
	Example[{Basic, "Extracts the first characters, even if they are not alphanumeric:"},
		StringFirst[{"% Percent", "\t Tab", "+ Plus"}],
		{"%", "\t", "+"}
	],
	Example[{Basic, "StringFirst is equivalent to using StringTake[str,1]:"},
		StringFirst["ABCD"] == StringTake["ABCD", 1] == "A",
		True
	],
	Example[{Additional, "Extract the first nucleotide from a DNA sequence:"},
		StringFirst["GCATA"],
		"G"
	],
	Example[{Additional, "StringFirst does not work on empty strings:"},
		StringFirst[""],
		_StringTake,
		Messages :> {StringTake::take}
	],
	Example[{Attributes, Listable, "Extracts the first character of each string in a list of strings:"},
		StringFirst[{"ATGATACA", "Hi there.", "Cats"}],
		{"A", "H", "C"}
	]
}];


(* ::Subsubsection::Closed:: *)
(*StringLast*)


DefineTests[StringLast, {
	Example[{Basic, "Extract the last character of a string:"},
		StringLast["abcd"],
		"d"
	],
	Example[{Basic, "Extracts the last characters, even if they are not alphanumeric:"},
		StringLast[{"Percent %", "Tab \t", "Plus +"}],
		{"%", "\t", "+"}
	],
	Example[{Basic, "StringLast is equivalent to using StringTake[str,-1]:"},
		StringLast["ABCD"] == StringTake["ABCD", -1] == "D",
		True
	],
	Example[{Additional, "Extract the last nucleotide from a DNA sequence:"},
		StringLast["GCATA"],
		"A"
	],
	Example[{Additional, "StringLast does not work on empty strings:"},
		StringLast[""],
		_StringTake,
		Messages :> {StringTake::take}
	],
	Example[{Attributes, Listable, "Extracts the last character of each string in a list of strings:"},
		StringLast[{"ATGATACA", "Hi there.", "Cats"}],
		{"A", ".", "s"}
	]
}];


(* ::Subsubsection::Closed:: *)
(*StringRest*)


DefineTests[StringRest, {
	Example[{Basic, "Extract all but the first character in a string:"},
		StringRest["Hello"],
		"ello"
	],
	Example[{Basic, "Extract all but the first character, even if the first characters are not alphanumeric:"},
		StringRest[{"% Percent", "\t Tab", "+ Plus"}],
		{" Percent", " Tab", " Plus"}
	],
	Example[{Basic, "Single character strings will return an empty string:"},
		StringRest["A"],
		""
	],
	Example[{Additional, "StringRest is equivalent to StringDrop[string,1]:"},
		StringRest["ABCD"] == StringDrop["ABCD", 1] == "BCD",
		True
	],
	Example[{Additional, "StringRest does not work on empty strings:"},
		StringRest[""],
		_StringDrop,
		Messages :> {StringDrop::drop}
	],
	Example[{Attributes, Listable, "Extract all but the first character from each string in a list of strings:"},
		StringRest[{"Taco", "Hi there.", "Cats"}],
		{"aco", "i there.", "ats"}
	]
}];


(* ::Subsubsection::Closed:: *)
(*StringMost*)


DefineTests[StringMost, {
	Example[{Basic, "Extract all but the last character in a string:"},
		StringMost["Goodbye"],
		"Goodby"
	],
	Example[{Basic, "Extract all but the last character, even if the last characters are not alphanumeric:"},
		StringMost[{"Percent %", "Tab \t", "Plus +"}],
		{"Percent ", "Tab ", "Plus "}
	],
	Example[{Basic, "Single character strings will return an empty string:"},
		StringMost["A"],
		""
	],
	Example[{Additional, "StringMost is equivalent to StringDrop[string,-1]:"},
		StringMost["ABCD"] == StringDrop["ABCD", -1] == "ABC",
		True
	],
	Example[{Additional, "StringMost does not work on empty strings:"},
		StringMost[""],
		_StringDrop,
		Messages :> {StringDrop::drop}
	],
	Example[{Attributes, Listable, "Extract all but the last character from each string in a list of strings:"},
		StringMost[{"Taco", "Hi there.", "Cats"}],
		{"Tac", "Hi there", "Cat"}
	]
}];


(* ::Subsubsection::Closed:: *)
(*StringPartitionRemainder*)


DefineTests[StringPartitionRemainder,
	{
		Example[{Basic, "Partition a string into substrings, with any remaining characters forming the final substring:"},
			StringPartitionRemainder["abcdefgh", 3],
			{"abc", "def", "gh"}
		],

		Example[{Basic, "If the string is evenly divisible by the partition size, equal length strings are returned:"},
			StringPartitionRemainder["abcdef", 2],
			{"ab", "cd", "ef"}
		],

		Example[{Basic, "If the parition size is larger than the length of the string, the whole string is returned:"},
			StringPartitionRemainder["abc", 5],
			{"abc"}
		],

		Example[{Attributes, Listable, "Multiple strings can be provided as inputs to be partitioned:"},
			StringPartitionRemainder[{"abc", "abcde"}, 2],
			{{"ab", "c"}, {"ab", "cd", "e"}}
		],

		Example[{Attributes, Listable, "Equal length lists of strings and partition sizes can be provided as inputs:"},
			StringPartitionRemainder[{"abcde", "abcde"}, {2, 5}],
			{{"ab", "cd", "e"}, {"abcde"}}
		],

		Example[{Messages, "InvalidPartitionSize", "The partition size must be a positive integer:"},
			StringPartitionRemainder["abc", -1],
			Null,
			Messages :> StringPartitionRemainder::InvalidPartitionSize
		]
	}];



(* ::Subsection::Closed:: *)
(*List Manipulation*)


(* ::Subsubsection::Closed:: *)
(*Repeat*)


DefineTests[Repeat,
	{
		Example[{Basic, "Generate a list of \"A\" Repeated 5 times:"},
			Repeat["A", 5],
			{"A", "A", "A", "A", "A"}
		],
		Example[{Basic, "Repeate a list of {1,2,3} 5 times:"},
			Repeat[{1, 2, 3}, 5],
			{{1, 2, 3}, {1, 2, 3}, {1, 2, 3}, {1, 2, 3}, {1, 2, 3}}
		],
		Example[{Basic, "If provided with a list of one item, Repeate repeates the item n times:"},
			Repeat[{"A"}, 5],
			{"A", "A", "A", "A", "A"}
		]
	}];


(* ::Subsubsection::Closed:: *)
(*PartitionRemainder*)


DefineTests[
	PartitionRemainder,
	{
		Example[{Basic, "The function breaks lists into evenely length sublists length 'n' with remaining items that don't devide evenly appended in a final sublist:"},
			PartitionRemainder[Range[10], 3],
			{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}, {10}}
		],
		Example[{Basic, "An offset can be provided to generate sublists with overlapping elements of length 'n' at an offset of 'd':"},
			PartitionRemainder[Range[10], 3, 1],
			{{1, 2, 3}, {2, 3, 4}, {3, 4, 5}, {4, 5, 6}, {5, 6, 7}, {6, 7, 8}, {7, 8, 9}, {8, 9, 10}, {9, 10}, {10}}
		],
		Example[{Basic, "If 'n' divides evenly into the length of the list, the function behaves like Partition:"},
			PartitionRemainder[Range[9], 3],
			{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}
		],
		Example[{Options, NegativePadding, "The NegativePadding Option can be used to seperatly partition out elements from the front of the list:"},
			PartitionRemainder[Range[9], 3, NegativePadding -> 2],
			{{1, 2}, {3, 4, 5}, {6, 7, 8}, {9}}
		],
		Example[{Attributes, "Listable", "The function is listable by 'n' and 'd':"},
			PartitionRemainder[Range[10], Range[5]],
			{{{1}, {2}, {3}, {4}, {5}, {6}, {7}, {8}, {9}, {10}}, {{1, 2}, {3, 4}, {5, 6}, {7, 8}, {9, 10}}, {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}, {10}}, {{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 10}}, {{1, 2, 3, 4, 5}, {6, 7, 8, 9, 10}}}
		],
		Test["Testing that Negative paddings larger than the list do not crash:", PartitionRemainder[Range[5], 10, NegativePadding -> 50],
			{{1, 2, 3, 4, 5}}
		],
		Test["Symbolic input remains unevaluated:",
			PartitionRemainder[taco, time],
			_PartitionRemainder
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*SetDifference*)


DefineTests[SetDifference,
	{
		Example[
			{Basic, "Two sets with same elements:"},
			SetDifference[{1, 2, 3}, {3, 1, 2}],
			{}
		],
		Example[
			{Basic, "First set is superset of second:"},
			SetDifference[{1, 2, 3}, {3, 3}],
			{1, 2}
		],
		Example[
			{Basic, "Only one common element:"},
			SetDifference[{1, 2, 3}, {3, 4, 5}],
			{1, 2, 4, 5}
		]
	}];


(* ::Subsubsection::Closed:: *)
(*ReplaceRule*)


DefineTests[
	ReplaceRule,
	{
		Example[{Basic, "Replace a single rule:"},
			ReplaceRule[{"a" -> "b", "b" -> "c", "c" -> "d"}, "b" -> "q"],
			{"a" -> "b", "b" -> "q", "c" -> "d"}
		],
		Example[{Basic, "Replace a list of rules:"},
			ReplaceRule[{"a" -> "b", "b" -> "c", "c" -> "d"}, {"b" -> "q", "c" -> "a"}],
			{"a" -> "b", "b" -> "q", "c" -> "a"}
		],
		Example[{Basic, "Like ReplaceAll, the first matching rule is used:"},
			ReplaceRule[{"a" -> "b", "b" -> "c", "c" -> "d"}, {"b" -> "q", "b" -> "z"}],
			{"a" -> "b", "b" -> "q", "c" -> "d"}
		],

		Example[{Options, Append, "Indicate if rules not in the current list should be appended to the updated list:"},
			{
				ReplaceRule[{a -> b, c -> d, e -> {f -> g}}, f -> x, Append -> False],
				ReplaceRule[{a -> b, c -> d, e -> {f -> g}}, f -> x, Append -> True]
			},
			{
				{a -> b, c -> d, e -> {f -> g}},
				{a -> b, c -> d, e -> {f -> g}, f -> x}
			}
		],

		Test["Single rule in a list:",
			ReplaceRule[{"a" -> "b", "b" -> "c", "c" -> "d"}, {"b" -> "q"}],
			{"a" -> "b", "b" -> "q", "c" -> "d"}
		],
		Test["Make sure this does nothing since there is no 'z' in the first list:",
			ReplaceRule[{"a" -> "b", "b" -> "c", "c" -> "d"}, {"z" -> "q"}, Append -> False],
			{"a" -> "b", "b" -> "c", "c" -> "d"}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ExtractRule*)


DefineTests[
	ExtractRule,
	{
		Example[{Basic, "Extract a rule from list of rules:"}, ExtractRule[{a -> 1, 2 -> 3, b -> 4}, 2], 2 -> 3],
		Example[{Basic, "Specify only left side of rule:"}, ExtractRule[{a -> 1, 2 -> 3, b -> 4, 2 -> 6}, a], a -> 1],
		Test["Extract a rule from list of rules:", ExtractRule[{a -> 1, 2 -> 3, b -> 4, 2 -> 6, a -> 6}, a], a -> 1],
		Test["Extract multiple rules from list of rules:", ExtractRule[{a -> 1, 2 -> 3, b -> 4, 2 -> 6}, {a, 2}], {a -> 1, 2 -> 3, 2 -> 6}],
		Example[{Basic, "Returns empty list of matching rule not found:"}, ExtractRule[{1 -> 2, 2 -> 3}, 4], {}],
		Example[{Basic, "Extract multiple rules:"}, ExtractRule[{a :> 2, b -> 3, a -> 4, 2 -> 6}, {a, b}], {a :> 2, b -> 3, a -> 4}]
	}
];


(* ::Subsubsection::Closed:: *)
(*PickList*)


DefineTests[
	PickList,
	{
		Example[{Basic, "PickList out only those elements where the \"selector\" list is True:"},
			PickList[{a, b, c, d}, {True, False, False, True}],
			{a, d}
		],
		Example[{Basic, "PickList out only those elements whenever a 1 appears in the \"selector\" list:"},
			PickList[{a, b, c, d, e}, {1, 0, 1, 0, 0}, 1],
			{a, c}
		],
		Example[{Basic, "PickList out only those elements whose parts match the pattern:"},
			PickList[{a, b, c, d}, {1, 2, 3, 4}, 2 | 4],
			{b, d}
		],
		Example[{Basic, "PickList out only those elements where the \"selector\" list matches the pattern:"},
			PickList[{a, b, c, d, e}, {1, 2, 3, 4, 5}, _?PrimeQ],
			{b, c, e}
		],
		Example[{Basic, "PickList out only those elements where the \"selector\" list matches the pattern, where the pattern is more complex:"},
			(
				list={Model[Sample, "id:54n6evKjdkWL"], Model[Sample, "id:BYDOjv15dqel"], Model[Sample, "id:XnlV5jmaXoD8"], Model[Sample, "id:qdkmxz0VaJla"]};
				PickList[list, Download[list, State], Liquid]
			),
			{Model[Sample, "id:54n6evKjdkWL"], Model[Sample, "id:XnlV5jmaXoD8"], Model[Sample, "id:qdkmxz0VaJla"]}
		],
		Example[{Additional, "Unlike Pick, PickList only works on lists and not arbitrary sequences:"},
			PickList[f[1, 2, 3, 4, 5, 6], {1, 0, 1, 0, 1, 1}, 1],
			_
		],
		Example[{Additional, "Unlike PickList, Pick works on arbitrary sequences:"},
			Pick[f[1, 2, 3, 4, 5, 6], {1, 0, 1, 0, 1, 1}, 1],
			f[1, 3, 5, 6]
		],
		Example[{Additional, "In cases where items in the list and sel have explicit heads, PickList looks only at the list level:"},
			PickList[{a, b, f[b]}, {1, Cos[1], Sin[1]}, 1],
			{a}
		],
		Example[{Additional, "In cases where items in the list and sel have explicit heads, Pick looks at the sequence level:"},
			Pick[{a, b, f[b]}, {1, Cos[1], Sin[1]}, 1],
			{a, f[b]}
		],
		Example[{Additional, "Unlike Pick, PickList does works only on the first level of the list:"},
			PickList[{{a, b, c}, {d, e, f}}, {{1, 0, 0}, {0, 1, 1}}, 1],
			{}
		],
		Example[{Additional, "Unlike PickList, Pick works at greater levels of depth in the expression:"},
			Pick[{{a, b, c}, {d, e, f}}, {{1, 0, 0}, {0, 1, 1}}, 1],
			{{a}, {e, f}}
		],
		Example[{Additional, "Unlike Pick, PickList does not accept sparse arrays as selectors:"},
			(
				sel=SparseArray[{1 -> True, 10 -> True, _ -> False}, 10];
				PickList[Range[10], sel]
			),
			_
		],
		Example[{Additional, "Unlike PickList, Pick does accept sparse arrays as selectors:"},
			(
				sel=SparseArray[{1 -> True, 10 -> True, _ -> False}, 10];
				Pick[Range[10], sel]
			),
			{1, 10}
		],
		Example[{Additional, "PickList is substantially slower than Pick when working with very large lists:"},
			First[AbsoluteTiming[PickList[Table[RandomReal[100], 1000000], Table[RandomInteger[1], 1000000], 1];]],
			_Real
		],
		Example[{Additional, "Pick is substantially faster than Pick when working with very large lists:"},
			First[AbsoluteTiming[Pick[Table[RandomReal[100], 1000000], Table[RandomInteger[1], 1000000], 1];]],
			_Real
		],
		Example[{Messages, "MismatchedListLength", "The \"selector\" list must be the same length as the input list:"},
			PickList[{a, b, c, d}, {True, False}],
			$Failed,
			Messages :> {PickList::MismatchedListLength}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*UnsortedComplement*)


DefineTests[
	UnsortedComplement,
	{
		Example[{Basic,"Returns elements that are in the first argument but not in the second:"},
			UnsortedComplement[{1,2,3,4,5},{2,4}],
			{1,3,5}
		],
		
		Example[{Basic,"Returns its output in the same order as the first list:"},
			UnsortedComplement[{5,4,3,2,1},{2,4}],
			{5,3,1}
		],
		
		Example[{Basic,"Handles any expression, not just lists:"},
			UnsortedComplement[testHead[5,4,3,2,1],testHead[2,4]],
			testHead[5,3,1]
		],
		
		Example[{Additional,"Duplicate elements are not removed by default:"},
			UnsortedComplement[{5,5,4,4,3,3,2,2,1,1},{2,4}],
			{5,5,3,3,1,1}
		],
		
		Example[{Additional,"Handles unlimited number of arguments:"},
			UnsortedComplement[{1,2,3,4,5,6,7,8,9,10},{1,2},{3,4},{5,6},{7,8}],
			{9,10}
		],
		
		Example[{Additional,"Handles unlimited number of any expression, not just lists:"},
			UnsortedComplement[testHead[10,9,8,7,6,5,4,3,2,1],testHead[1,2],testHead[3,4],testHead[5,6],testHead[7,8]],
			testHead[10,9]
		],
		
		Test["Handles unlimited number of associations:",
			UnsortedComplement[<|"e"->5,"d"->4,"c"->3,"b"->2,"a"->1|>,<|"e"->5,"c"->3|>,<|"d"->4,"b"->2|>],
			<|"a"->1|>
		],
		
		Test["Keeps duplicate elements in any expression:",
			UnsortedComplement[testHead[5,5,4,4,3,3,2,2,1,1],testHead[2,4]],
			testHead[5,5,3,3,1,1]
		],
		
		Test["Keeps duplicate elements with unlimited numbers of expressions:",
			UnsortedComplement[testHead[9,10,10,9,8,7,6,5,4,3,2,1],testHead[1,2],testHead[3,4],testHead[5,6],testHead[7,8]],
			testHead[9,10,10,9]
		],
		
		Example[{Options,SameTest,"Use an existing function to determine whether two items are the same:"},
			UnsortedComplement[{5,4,3,2,1},{2.,4.},SameTest->Equal],
			{5,3,1}
		],
		
		Example[{Options,SameTest,"Can be used to compare various forms of objects:"},
			UnsortedComplement[
				{Link[Object[Sample,"id:5"]],Link[Object[Sample,"id:4"]],Link[Object[Sample,"id:3"]],Link[Object[Sample,"id:2"]],Link[Object[Sample,"id:1"]]},
				{Object[Sample,"id:4"],Object[Sample,"id:2"]},
				SameTest->SameObjectQ
			],
			{Link[Object[Sample,"id:5"]],Link[Object[Sample,"id:3"]],Link[Object[Sample,"id:1"]]}
		],
		
		Example[{Options,SameTest,"Use a pure function to determine whether two items are the same:"},
			UnsortedComplement[{{1,2},{3},{4,5,6},{1,2,3},{9,5}},{{2,1},{8,4,3}},SameTest->(Total[#1]==Total[#2]&)],
			{{1,2,3},{9,5}}
		],
		
		Example[{Options,SameTest,"Find the complement of two associations by key:"},
			UnsortedComplement[<|"e"->5,"d"->4,"c"->3,"b"->2,"a"->1|>,<|"d"->6,"b"->6|>,SameTest->(First[#1]==First[#2]&)],
			<|"e"->5,"c"->3,"a"->1|>
		],
		
		Example[{Options,SameTest,"Find the complement of two associations by value:"},
			UnsortedComplement[<|"e"->5,"d"->4,"c"->3,"b"->2,"a"->1|>,<|"f"->1,"g"->2,"h"->3|>,SameTest->(Last[#1]==Last[#2]&)],
			<|"e"->5,"d"->4|>
		],
		
		Example[{Options,DeleteDuplicates,"Delete the duplicate items in the output:"},
			UnsortedComplement[{5,5,4,4,3,3,2,2,1,1},{2,4},DeleteDuplicates->True],
			{5,3,1}
		],
		
		Example[{Options,DeleteDuplicates,"Can delete duplicate items in any expression:"},
			UnsortedComplement[testHead[5,5,4,4,3,3,2,2,1,1],testHead[2,4],DeleteDuplicates->True],
			testHead[5,3,1]
		],
		
		Example[{Messages,"MismatchedHeads","An error is shown if the heads of the two input expressions do not match:"},
			UnsortedComplement[head1[1,2,3,4,5],head2[2,4]],
			$Failed,
			Messages:>{UnsortedComplement::MismatchedHeads}
		],
		
		Example[{Messages,"MismatchedHeads","An error is shown if any of the heads with multiple input expressions do not match:"},
			UnsortedComplement[head1[1,2,3,4,5],head1[1,3],head2[2,4]],
			$Failed,
			Messages:>{UnsortedComplement::MismatchedHeads}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*UnsortedIntersection*)


DefineTests[
	UnsortedIntersection,
	{
		Example[{Basic,"Returns elements that are in the first argument and in the second:"},
			UnsortedIntersection[{1,2,3,4,5},{2,4}],
			{2,4}
		],

		Example[{Basic,"Returns its output in the same order as the first list:"},
			UnsortedIntersection[{5,4,3,2,1},{2,4}],
			{4, 2}
		],

		Example[{Basic,"Handles any expression, not just lists:"},
			UnsortedIntersection[testHead[5,4,3,2,1],testHead[2,4]],
			testHead[4, 2]
		],

		Example[{Basic,"Returns the same list if there is only one list:"},
			UnsortedIntersection[{1,2,3,4,5}],
			{1,2,3,4,5}
		],

		Example[{Basic,"Returns the empty list if there is any empty list being intersected:"},
			UnsortedIntersection[{1,2,3,4,5}, {}],
			{}
		],

		Example[{Basic,"Works with any head, returns the empty format of that head if none is intersected:"},
			UnsortedIntersection[testHead[1,2,3,4,5], testHead[]],
			testHead[]
		],

		Test["Make sure OptionsPattern do not pick up the last {}:",
			UnsortedIntersection[{1,2,3,4,5}, {3, 4, 5}, {}],
			{}
		],

		Test["Make sure OptionsPattern do not pick up the last {}:",
			UnsortedIntersection[{1,2,3,4,5}, {3, 4, 5}, {}, SameTest -> GreaterEqualQ],
			{}
		],

		Example[{Basic,"Returns the same expression if there is only one in the argument, not just lists:"},
			UnsortedIntersection[testHead[5,4,3,2,1]],
			testHead[5,4,3,2,1]
		],

		Example[{Additional,"Duplicate elements are not removed by default:"},
			UnsortedIntersection[{5,5,4,4,3,3,2,2,1,1},{2,4}],
			{4,4,2,2}
		],

		Example[{Additional,"Handles unlimited number of arguments:"},
			UnsortedIntersection[{1,2,3,4,5,6,7,8,9,10},{1,2},{3,4},{5,6},{7,8}],
			{}
		],

		Example[{Additional,"Handles unlimited number of arguments where something is in common with all of them:"},
			UnsortedIntersection[{1,2,3,4,5,6,7,8,9,10},{1,2},{3,2,4},{5,2,6},{7,2,8}],
			{2}
		],

		Example[{Additional,"Handles unlimited number of any expression, not just lists:"},
			UnsortedIntersection[testHead[10,9,8,7,6,5,4,3,2,1],testHead[1,2],testHead[3,2,4],testHead[5,2,6],testHead[7,2,8]],
			testHead[2]
		],

		Test["Handles unlimited number of associations:",
			UnsortedIntersection[<|"e"->5,"d"->4,"c"->3,"b"->2,"a"->1|>,<|"e"->5,"c"->3|>,<|"d"->4,"b"->2,"e"->5|>],
			<|"e"->5|>
		],

		Test["Keeps duplicate elements in any expression:",
			UnsortedIntersection[testHead[5,5,4,4,3,3,2,2,1,1],testHead[2,4]],
			testHead[4,4,2,2]
		],

		Test["Keeps duplicate elements with unlimited numbers of expressions:",
			UnsortedIntersection[testHead[9,10,10,9,8,7,6,5,4,3,2,2,2,1],testHead[1,2],testHead[3,2,4],testHead[5,2,6],testHead[7,2,8]],
			testHead[2,2,2]
		],

		Example[{Options,SameTest,"Use an existing function to determine whether two items are the same:"},
			UnsortedIntersection[{5,4,3,2,1},{2.,4.},SameTest->Equal],
			{4, 2}
		],

		Example[{Options,SameTest,"Can be used to compare various forms of objects:"},
			UnsortedIntersection[
				{Link[Object[Sample,"id:5"]],Link[Object[Sample,"id:4"]],Link[Object[Sample,"id:3"]],Link[Object[Sample,"id:2"]],Link[Object[Sample,"id:1"]]},
				{Object[Sample,"id:4"],Object[Sample,"id:2"]},
				SameTest->SameObjectQ
			],
			{Link[Object[Sample,"id:4"]],Link[Object[Sample,"id:2"]]}
		],

		Example[{Options,SameTest,"Find the intersection of two associations by key:"},
			UnsortedIntersection[<|"e"->5,"d"->4,"c"->3,"b"->2,"a"->1|>,<|"d"->6,"b"->6|>,SameTest->(First[#1]==First[#2]&)],
			<|"d"->4,"b"->2|>
		],

		Example[{Options,SameTest,"Find the intersection of two associations by value:"},
			UnsortedIntersection[<|"e"->5,"d"->4,"c"->3,"b"->2,"a"->1|>,<|"f"->1,"g"->2,"h"->3|>,SameTest->(Last[#1]==Last[#2]&)],
			<|"c"->3,"b"->2,"a"->1|>
		],

		Example[{Options,DeleteDuplicates,"Delete the duplicate items in the output:"},
			UnsortedIntersection[{5,5,4,4,3,3,2,2,1,1},{2,4},DeleteDuplicates->True],
			{4, 2}
		],

		Example[{Options,DeleteDuplicates,"Can delete duplicate items in any expression:"},
			UnsortedIntersection[testHead[5,5,4,4,3,3,2,2,1,1],testHead[2,4],DeleteDuplicates->True],
			testHead[4, 2]
		],

		Example[{Messages,"MismatchedHeads","An error is shown if the heads of the two input expressions do not match:"},
			UnsortedIntersection[head1[1,2,3,4,5],head2[2,4]],
			$Failed,
			Messages:>{UnsortedIntersection::MismatchedHeads}
		],

		Example[{Messages,"MismatchedHeads","An error is shown if any of the heads with multiple input expressions do not match:"},
			UnsortedIntersection[head1[1,2,3,4,5],head1[1,3],head2[2,4]],
			$Failed,
			Messages:>{UnsortedIntersection::MismatchedHeads}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*RepeatedQ*)


(* ::Code::Bold:: *)
(**)


DefineTests[RepeatedQ, {
	Example[{Basic, "Returns true if every item of a list is identical:"},
		RepeatedQ[{a, a, a, a, a}],
		True
	],
	Example[{Basic, "All items must be identical to return true:"},
		RepeatedQ[{"duck", "duck", "duck", "goose"}],
		False
	],
	Example[{Additional, "Returns true for a null list:"},
		RepeatedQ[{}],
		True
	],
	Test["Must be given a list as input:",
		RepeatedQ["fish"],
		HoldPattern[RepeatedQ["fish"]]
	]
}];


(* ::Subsubsection::Closed:: *)
(*SameLengthQ*)


DefineTests[SameLengthQ,
	{
		Example[
			{Basic, "Given lists of same length:"},
			SameLengthQ[{a, b, Core`Private`c}, {1, 2, 3}, {"fish", "tacos", "great"}],
			True
		],
		Example[
			{Basic, "Given lists with different lengths:"},
			!SameLengthQ[{a, b, Core`Private`c}, {1, 2}],
			True
		],
		Example[
			{Basic, "Given atomic items:"},
			SameLengthQ[4, 5, "fish", "tacos"],
			True
		]
	}];



(* ::Subsubsection::Closed:: *)
(*GroupByTotal*)


DefineTests[GroupByTotal, {
	Example[{Basic, "A list of values will be grouped such that the total of each group will be less then or equal the asked for target total:"},
		GroupByTotal[{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3}, 8],
		{{2, 2, 2, 2}, {2, 2, 2, 2}, {2, 2, 3}, {2}}
	],
	Example[{Basic, "Each group can be labeled to keep track of duplicate values:"},
		GroupByTotal[{{"firstTwo", 2}, {"secondTwo", 2}, {"thirdTwo", 2}, {"fourthTwo", 2}, {"fifthTwo", 2}, {"sixthTwo", 2}}, 8],
		{{{"firstTwo", 2}, {"secondTwo", 2}, {"thirdTwo", 2}, {"fourthTwo", 2}}, {{"fifthTwo", 2}, {"sixthTwo", 2}}}
	],
	Example[{Basic, "GroupByTotal is aware of and works with values with units:"},
		GroupByTotal[{5.1 Milliliter, 7 Milliliter, 6 Milliliter, 1850 Microliter, .0029 Liter}, 8 Milliliter],
		{{5.1 Milliliter, .0029 Liter}, {6 Milliliter, 1850 Microliter}, {7 Milliliter}}
	],
	Example[{Additional, "If multiple labels are used for a value, the grouping will be performed on the last entry of each value:"},
		GroupByTotal[{{"a", "x", 2}, {"b", 3}, {"c", 4}, {"a", "y", 5}, {"d", 3}, {"e", 2}}, 8],
		{{{"b", 3}, {"a", "y", 5}}, {{"a", "x", 2}, {"e", 2}, {"c", 4}}, {{"d", 3}}}
	],
	Example[{Additional, "Zero values will be placed in the first available bin:"},
		GroupByTotal[{2, 2, 2, 2, 2, 2, 0}, 8],
		{{0, 2, 2, 2, 2}, {2, 2}}
	],
	Example[{Additional, "Only zero values will be placed in the first available bin:"},
		GroupByTotal[{0, 0, 0}, 8],
		{{0, 0, 0}}
	],
	Example[{Additional, "Negative values will be placed in the first available bin:"},
		GroupByTotal[{2, 2, 2, 2, 2, 2, -1}, 8],
		{{-1, 2, 2, 2, 2}, {2, 2}}
	],
	Example[{Additional, "GroupByTotal should be capable of grouping large datasets:"},
		GroupByTotal[Table[1 Milliliter, 1000], 20 Milliliter],
		{{Repeated[Quantity[1, "Milliliters"], 20]}..}
	],
	Example[{Messages, "IncompatibleUnits", "Trying to group values with incompatible units will result in an error message:"},
		GroupByTotal[{{"one", 51 Gram}, {"two", 70 Milliliter}, {"three", 60 Milliliter}, {"four", 20 Milliliter}, {"five", .0029 Liter}, {"six", 0}}, 80 Milliliter],
		$Failed,
		Messages :> {Message[GroupByTotal::IncompatibleUnits, {51 Gram, 0}, 80 Milliliter]}
	],
	Example[{Messages, "IncompatibleValues", "Trying to group values where a value already exists that is larger then the target will result in an error message:"},
		GroupByTotal[{{"one", 81 Milliliter}, {"two", 70 Milliliter}, {"three", 60 Milliliter}, {"four", 20 Milliliter}, {"five", .029 Liter}}, 80 Milliliter],
		$Failed,
		Messages :> {Message[GroupByTotal::IncompatibleValues, {81 Milliliter}, 80 Milliliter]}
	],
	Example[{Messages, "UniqueLabels", "Using non unque labels will result in an error message:"},
		GroupByTotal[{{"one", 51 Milliliter}, {"one", 70 Milliliter}, {"two", 60 Milliliter}, {"two", 20 Milliliter}, {"three", .029 Liter}}, 80 Milliliter],
		$Failed,
		Messages :> {Message[GroupByTotal::UniqueLabels, {{"one"}, {"two"}}]}
	],
	Example[{Messages, "UniqueLabels", "The restriction on label uniqueness applies to the whole label as a group:"},
		GroupByTotal[{{"one", 5}, {"one", 3}, {"two", "two", 5}, {"two", "two", 3}}, 8],
		$Failed,
		Messages :> {Message[GroupByTotal::UniqueLabels, {{"one"}, {"two", "two"}}]}
	],

	Test["If no grouping can be done,each element in the input list will form its own group:",
		GroupByTotal[{7, 7, 7}, 8],
		{{7}, {7}, {7}}
	]
}];



(* ::Subsubsection::Closed:: *)
(*ExpandDimensions*)


DefineTests[ExpandDimensions, {
	Example[{Basic, "Repeat a single element to fill the list:"},
		ExpandDimensions[{1, 2, 3, 4}, "X"],
		{"X", "X", "X", "X"}
	],
	Example[{Basic, "Pad right with last element Y:"},
		ExpandDimensions[{1, 2, 3, 4}, {"X", "Y"}],
		{"X", "Y", "Y", "Y"}
	],
	Example[{Basic, "Does nothing because the dimensions already match:"},
		ExpandDimensions[{1, 2, 3, 4}, {"X", "Y", "Z", "A"}],
		{"X", "Y", "Z", "A"}
	],
	Example[{Basic, "Repeat a single element to match a more complicated pattern:"},
		ExpandDimensions[{1, 2, {3, 4, {5}}, 6}, 9],
		{9, 9, {9, 9, {9}}, 9}
	],
	Example[{Basic, "Pad right with last element:"},
		ExpandDimensions[{1, 2, {3, 4, {5}}, 6}, {9, "Hi", Null}],
		{9, "Hi", {Null, Null, {Null}}, Null}
	]

}];



(* ::Subsubsection::Closed:: *)
(*Unflatten*)


DefineTests[
	Unflatten,
	{
		Example[
			{Basic, "Unflatten into rectangular array:"},
			Unflatten[{1, 2, 3, 4, 5, 6}, {{1, 2}, {3, 4}, {5, 6}}],
			{{1, 2}, {3, 4}, {5, 6}}
		],
		Example[
			{Basic, "Unflatten into jagged array:"},
			Unflatten[{1, 2, 3, 4, 2, 12, 5, 6, 7}, {1, 2, {3, {4}, 2, {{12}}, {5, 6}, 7}}],
			{1, 2, {3, {4}, 2, {{12}}, {5, 6}, 7}}
		],
		Example[
			{Basic, "Unflatten symbols based on integer skeleton:"},
			Unflatten[{a, b, c, d, e, f, g, h, i}, {1, 2, {3, {4}, 2, {{12}}, {5, 6}, 7}}],
			{a, b, {c, {d}, e, {{f}}, {g, h}, i}}
		],
		Example[
			{Basic, "Unflatten higher dimensional rectangular array:"},
			Unflatten[Flatten[{{{1, 5, 8, 3}, {5, 1, 1, 10}, {4, 9, 6, 10}}, {{7, 2, 8, 3}, {8, 9, 2, 4}, {4, 3, 3, 3}}}], {{{1, 5, 8, 3}, {5, 1, 1, 10}, {4, 9, 6, 10}}, {{7, 2, 8, 3}, {8, 9, 2, 4}, {4, 3, 3, 3}}}],
			{{{1, 5, 8, 3}, {5, 1, 1, 10}, {4, 9, 6, 10}}, {{7, 2, 8, 3}, {8, 9, 2, 4}, {4, 3, 3, 3}}}
		],
		Test["Given non-array:",
			Unflatten[
				{{a, 1, x}, {b, 2, x}, {c, 3, x}, {d, 4}, {e, 5}, {f, 6}},
				{{1, 2, 3}, {4, 5, 6}}
			],
			{{{a, 1, x}, {b, 2, x}, {c, 3, x}}, {{d, 4}, {e, 5}, {f, 6}}}
		],
		Test["Flat list can contain lists:",
			Unflatten[{{1, 2, 3}, {1, 2, 3}}, {1, 2}],
			{{1, 2, 3}, {1, 2, 3}}
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*ToList*)


DefineTests[ToList, {
	Example[{Basic, "Wrap a single item in a list:"},
		ToList[a],
		{a}
	],
	Example[{Basic, "Do nothing to a list:" },
		ToList[{a}],
		{a}
	],
	Example[{Additional, "Wrap in a list to if 'expr' does not match 'pattern':" },
		ToList[{a, b, c}, {_List}],
		{{a, b, c}}
	],
	Example[{Basic, "Do nothing to a list:"},
		ToList[{{a}}],
		{{a}}
	],
	Example[{Additional, "Do nothing to if 'expr' matches 'pattern':" },
		ToList[{{a, b, c}}, {_List}],
		{{a, b, c}}
	]

}];


(* ::Subsubsection::Closed:: *)
(*Middle*)


DefineTests[Middle, {
	Example[{Basic, "Return the middle element of the list:"},
		Middle[{a, b, c}],
		b
	],
	Example[{Basic, "If length of list is even, return the element immediately before the middle:"},
		Middle[{a, b, c, d}],
		b
	],
	Example[{Basic, "Middle also works with Heads other than List:"},
		Middle[f[a, b, c]],
		b
	],
	Example[{Basic, "Given list of lists, returns a list.  Note that Middle is not listable:"},
		Middle[{{1, 2}, {3, 4, 5}, {6}}],
		{3, 4, 5}
	],

	Test["Middle from even length non-List head:", Middle[f[a, b, c, d]], b],

	Example[{Options, Output, "Use Output option to return element Right of middle when length of input is even:"},
		Middle[{a, b, c, d}, Output -> Right],
		c
	],
	Example[{Messages, "middle", "Empty list throws message:"},
		Middle[{}],
		_,
		Messages :> {Middle::middle}
	],
	Test["Empty non-List thorws message:", Middle[f[]], _, Messages :> {Middle::middle}],
	Example[{Messages, "normal", "Atomic input throws message:"},
		Middle[f],
		_,
		Messages :> {Middle::normal}
	],
	Example[{Messages, "argx", "Too many arguments throws message:"},
		Middle[f, g],
		_,
		Messages :> {Middle::argx}
	]
}];


(* ::Subsubsection::Closed:: *)
(*RiffleAlternatives*)


DefineTests[RiffleAlternatives, {
	Example[{Basic, "Combines the first two lists based on the last list:"},
		RiffleAlternatives[{1, 2, 3}, {4, 5}, {False, True, False, True, True}],
		{4, 1, 5, 2, 3}
	],
	Example[{Basic, "An all True/False Bool list will return the appropriate input list:"},
		RiffleAlternatives[{1, 2, 3, 4, 5}, {}, {True, True, True, True, True}],
		{1, 2, 3, 4, 5}
	],
	Example[{Basic, "Alternating True/False will produce the same result as Riffle:"},
		RiffleAlternatives[{1, 2, 3}, {4, 5}, {True, False, True, False, True}],
		{1, 4, 2, 5, 3}
	],
	Example[{Messages, "MismatchedListLength", "The combine length of the first two input lists has to equal the length of the last list:"},
		RiffleAlternatives[{1, 2, 3}, {4, 5}, {False, True}],
		$Failed,
		Messages :> {Message[RiffleAlternatives::MismatchedListLength], Message[RiffleAlternatives::IncorrectBoolCounts]}
	],
	Example[{Messages, "IncorrectBoolCounts", "The length of the first list has to equal to the number of True instances in the last list:"},
		RiffleAlternatives[{1, 2}, {3, 4, 5}, {False, True, True, False, True}],
		$Failed,
		Messages :> {Message[RiffleAlternatives::IncorrectBoolCounts]}
	],
	Example[{Messages, "IncorrectBoolCounts", "The length of the second list has to equal to the number of False instances in the last list:"},
		RiffleAlternatives[{1, 2, 3}, {4, 5}, {True, True, True, False, True}],
		$Failed,
		Messages :> {Message[RiffleAlternatives::IncorrectBoolCounts]}
	]

}];



(* ::Subsection::Closed:: *)
(*Association Manipulation*)

(* ::Subsubsection::Closed:: *)
(*KeyReplace*)

DefineTests[KeyReplace, {
	Example[{Basic, "Replace a key in an association."},
		KeyReplace[Association[Volume -> 1, Size -> 2], Volume -> Weight],
		Association[Weight -> 1, Size -> 2]
	],
	Example[{Basic, "Replace a list of keys in an association."},
		KeyReplace[Association[Volume -> 1, Size -> 2], {Volume -> Weight, Size -> Amount}],
		Association[Weight -> 1, Amount -> 2]
	],
	Example[{Basic, "Replace a key in a list of associations."},
		KeyReplace[{Association[Volume -> 1, Size -> 2], Association[Volume -> 3, Width -> 4]}, Volume -> Weight],
		{Association[Weight -> 1, Size -> 2], Association[Weight -> 3, Width -> 4]}
	],
	Example[{Basic, "Replace a list of keys in a list of associations."},
		KeyReplace[{Association[Volume -> 1, Size -> 2], Association[Volume -> 3, Width -> 4]}, {Volume -> Weight, Size -> Amount, Width -> Length}],
		{Association[Weight -> 1, Amount -> 2], Association[Weight -> 3, Length -> 4]}
	]
}];

(* ::Subsection::Closed:: *)
(*Geometry and Trigonometry*)


(* ::Subsubsection::Closed:: *)
(*TranslateCoordinates*)


DefineTests[
	TranslateCoordinates,
	{
		Test[
			"Accepts an x translation and a y translation:",
			TranslateCoordinates[{{1, 1}, {2, 1}, {3, 2}, {4, 1}, {5, 1}, {6, 1}}, {0, 0}],
			{{1, 1}, {2, 1}, {3, 2}, {4, 1}, {5, 1}, {6, 1}}
		],
		Example[
			{Basic, "Accepts an x translation and a y translation:"},
			TranslateCoordinates[{{1, 1}, {2, 1}, {3, 2}, {4, 1}, {5, 1}, {6, 1}}, {1, 0}],
			{{2, 1}, {3, 1}, {4, 2}, {5, 1}, {6, 1}, {7, 1}}
		],
		Example[
			{Basic, "Applies each offset to each input:"},
			TranslateCoordinates[{{1, 1}, {5, 5}}, {{0, 0}, {1, 1}}],
			{{{1, 1}, {2, 2}}, {{5, 5}, {6, 6}}}
		],
		Example[
			{Basic, "Threads over the list of offsets and input coordinates:"},
			TranslateCoordinates[{{{1, 1}, {5, 5}}}, {{0, 0}, {1, 1}}],
			{{{1, 1}, {6, 6}}}
		],
		Test[
			"Works with negative numbers:",
			TranslateCoordinates[{{1, 1}, {2, 1}, {3, 2}, {4, 1}, {5, 1}, {6, 1}}, {0, -1}],
			{{1, 0}, {2, 0}, {3, 1}, {4, 0}, {5, 0}, {6, 0}}
		],
		Test["Works with symbols:",
			TranslateCoordinates[{{1, 1}, {2, 1}, {3, 2}, {4, 1}, {5, 1}, {6, 1}}, {Pi, -E}],
			{{1 + \[Pi], 1 - E}, {2 + \[Pi], 1 - E}, {3 + \[Pi], 2 - E}, {4 + \[Pi], 1 - E}, {5 + \[Pi], 1 - E}, {6 + \[Pi], 1 - E}}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*RescaleData*)


DefineTests[RescaleData,
	{
		Example[{Basic, "Scales values in a list from an old minimum and maximum value to a new minumum and maximum value:"},
			RescaleData[{1, 1, 2, 10}, {1, 10}, {-2, 1}],
			{-2, -2, -(5 / 3), 1}
		],

		Example[{Basic, "If the new minimum provided is greater than the new maximum provided, values in the list will scale accordingly:"},
			RescaleData[{1, 1, 2, 10}, {1, 10}, {1, -2}],
			{1, 1, 2 / 3, -2}
		],

		Example[{Basic, "Values in the list and minimum/maximums can be any numeric quantity:"},
			RescaleData[{1.24, Sqrt[-3], 4}, {-\[Pi], 10}, {400, 2343}],
			{1047.8236504765969`, 400 + (1943 (I Sqrt[3] + \[Pi])) / (10 + \[Pi]), 400 + (1943 (4 + \[Pi])) / (10 + \[Pi])}
		],

		Test["Does not evaluate if any values are non-numeric:",
			RescaleData[{1, 2, 3, 4, 5, 6, 7, x, 9, 10}, {1, 10}, {-1, 1}],
			HoldPattern[RescaleData[{1, 2, 3, 4, 5, 6, 7, x, 9, 10}, {1, 10}, {-1, 1}]]
		],

		Test["Works with imaginary numbers:",
			RescaleData[{0, 4, -.1, Sqrt[2], 6, -2, 3, 4, 2.3, 6, Sqrt[-1]}, {-8, -4}, {-1, 20 * Sqrt[-1]}],
			{1 + 40 I, 2 + 60 I, 0.9750000000000001` + 39.5` I, -1 + (1 / 4 + 5 I) (8 + Sqrt[2]), 5 / 2 + 70 I, 1 / 2 + 30 I, 7 / 4 + 55 I, 2 + 60 I, 1.5750000000000002` + 51.5` I, 5 / 2 + 70 I, -4 + (161 I) / 4}
		]

	}];


(* ::Subsubsection::Closed:: *)
(*RescaleY*)


DefineTests[
	RescaleY,
	{
		Example[
			{Basic, "Rescale just the y-coordinate:"},
			RescaleY[Transpose[{0.1 * Range[10], Range[10]}], {1, 10}, {-1, 1}],
			{{0.1`, -1}, {0.2`, -(7 / 9)}, {0.30000000000000004`, -(5 / 9)}, {0.4`, -(1 / 3)}, {0.5`, -(1 / 9)}, {0.6000000000000001`, 1 / 9}, {0.7000000000000001`, 1 / 3}, {0.8`, 5 / 9}, {0.9`, 7 / 9}, {1.`, 1}}
		],
		Example[
			{Basic, "Leave the min and max unspecified to use the min/max of y data points:"},
			RescaleY[Transpose[{Range[10], Range[10]}], {Null, Null}, {-1, 1}],
			{{1, -1}, {2, -(7 / 9)}, {3, -(5 / 9)}, {4, -(1 / 3)}, {5, -(1 / 9)}, {6, 1 / 9}, {7, 1 / 3}, {8, 5 / 9}, {9, 7 / 9}, {10, 1}}
		],
		Example[
			{Basic, "Rescale multiple lists of XY coordinates:"},
			Module[{data1},
				data1={{0, 1}, {1, 2}};
				RescaleY[{data1, data1}, {0, 2}, {-1, 1}]
			],
			{{{0, 0}, {1, 1}}, {{0, 0}, {1, 1}}}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*InPolygonQ*)


DefineTests[InPolygonQ,
	{
		Test[InPolygonQ[{{0, 0}, {0, 2}, {2, 0}, {2, 2}}, {1, 1}], True],
		Test[InPolygonQ[{{0, 0}, {0, 2}, {2, 0}, {2, 2}}, {1, 3}], False]
	}];


(* ::Subsection:: *)
(*Compiled Functions*)


(* ::Subsection::Closed:: *)
(*SLL Utilities*)


(* ::Subsubsection::Closed:: *)
(* AssociationMatchQ *)


DefineTests[
	AssociationMatchQ,
	{
		Example[{Basic, "Compares the values of test association with pattern association:"},
			AssociationMatchQ[
				Association[Key1 -> "a string", Key2 -> 1],
				Association[Key1 -> _String, Key2 -> _Integer]
			],
			True
		],
		Example[{Basic, "Returns False if patterns do not match:"},
			AssociationMatchQ[
				Association[Key1 -> "a string", Key2 -> 1],
				Association[Key1 -> _String, Key2 -> _String]
			],
			False
		],
		Example[{Basic, "Returns False if key is missing:"},
			AssociationMatchQ[
				Association[Key1 -> "a string", Key2 -> 1],
				Association[Key1 -> _String]
			],
			False
		],
		Example[{Additional, "KeyValuePattern will allow foreign keys in the test association whereas AssociationMatchQ by default does not:"},
			{
				MatchQ[
					Association[Key1 -> "a string", Key2 -> 1],
					KeyValuePattern[{Key1 -> _String}]
				],
				AssociationMatchQ[
					Association[Key1 -> "a string", Key2 -> 1],
					Association[Key1 -> _String]
				]
			},
			{True, False}
		],
		Example[{Options, AllowForeignKeys, "Toggle allowing the input association to have keys that do not exist in the pattern association:"},
			AssociationMatchQ[
				Association[Key1 -> "a string", Key2 -> 1],
				Association[Key1 -> _String],
				AllowForeignKeys -> True
			],
			True
		],
		Example[{Options, RequireAllKeys, "Toggle allowing the input association to not include keys that exist in the pattern association:"},
			AssociationMatchQ[
				Association[Key1 -> "a string"],
				Association[Key1 -> _String, Key2 -> 1],
				RequireAllKeys -> False
			],
			True
		]
	}
];



(* ::Subsubsection::Closed:: *)
(* AssociationMatchP *)


DefineTests[
	AssociationMatchP,
	{
		Example[{Basic, "Used as for pattern matching associations:"},
			MatchQ[
				Association[Key1 -> "a string", Key2 -> 1],
				AssociationMatchP[Association[Key1 -> _String, Key2 -> _Integer]]
			],
			True
		],
		Example[{Basic, "Takes in pattern association and builds pattern using AssociationMatchQ:"},
			AssociationMatchP[Association[Key1 -> _String, Key2 -> _Integer]],
			_PatternTest
		],
		Example[{Basic, "Returns False if patterns do not match:"},
			MatchQ[
				Association[Key1 -> "a string", Key2 -> 1],
				AssociationMatchP[Association[Key1 -> _String, Key2 -> _String]]
			],
			False
		],
		Example[{Additional, "KeyValuePattern will allow foreign keys in the test association whereas AssociationMatchQ by default does not:"},
			{
				MatchQ[
					Association[Key1 -> "a string", Key2 -> 1],
					KeyValuePattern[{Key1 -> _String}]
				],
				MatchQ[
					Association[Key1 -> "a string", Key2 -> 1],
					AssociationMatchP[Association[Key1 -> _String]]
				]
			},
			{True, False}
		],
		Example[{Options, AllowForeignKeys, "Toggle allowing the input association to have keys that do not exist in the pattern association:"},
			MatchQ[
				Association[Key1 -> "a string", Key2 -> 1],
				AssociationMatchP[
					Association[Key1 -> _String],
					AllowForeignKeys -> True
				]
			],
			True
		],
		Example[{Options, RequireAllKeys, "Toggle allowing the input association to not include keys that exist in the pattern association:"},
			MatchQ[
				Association[Key1 -> "a string"],
				AssociationMatchP[
					Association[Key1 -> _String, Key2 -> 1],
					RequireAllKeys -> False
				]
			],
			True
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*LibraryFunctions*)


DefineTests[LibraryFunctions,
	{
		Example[{Basic, "Returns a list of all function Symbols in SLL:"},
			LibraryFunctions[],
			{_Symbol..}
		],
		Example[{Basic, "Returns a list of all function Symbols in a given SLL Package:"},
			LibraryFunctions["Constellation`"],
			{_Symbol..}
		],
		Example[{Basic, "Non-existent package names return an empty list:"},
			LibraryFunctions["FooPackage`"],
			{}
		]
	}
];

(* ::Subsubsection:: *)
(*ClearMemoization*)

DefineTests[ClearMemoization,
	{
		Example[{Basic, "DownValues for memoized function are being cleared leaving the correct definition intact:"},
			{
				Length@DownValues[Experiment`Private`allCentrifugeEquipmentSearch],
				Experiment`Private`allCentrifugeEquipmentSearch["Memoization"];Length@DownValues[Experiment`Private`allCentrifugeEquipmentSearch],
				ClearMemoization[Experiment`Private`allCentrifugeEquipmentSearch];Length@DownValues[Experiment`Private`allCentrifugeEquipmentSearch]
			},
			{1, 2, 1}
		],
		Example[{Basic, "DownValues for memoized function are being cleared leaving the correct definition intact when called with no inputs:"},
			{
				Length@DownValues[Experiment`Private`allCentrifugeEquipmentSearch],
				Experiment`Private`allCentrifugeEquipmentSearch["Memoization"];Length@DownValues[Experiment`Private`allCentrifugeEquipmentSearch],
				ClearMemoization[];Length@DownValues[Experiment`Private`allCentrifugeEquipmentSearch]
			},
			{1, 2, 1}
		],
		Example[{Basic, "When the same function has several memoized inputs, clears all of them:"},
			{
				Length@DownValues[Experiment`Private`allRacksSearch],
				Experiment`Private`allRacksSearch["Memoization1"];Experiment`Private`allRacksSearch["Memoization2"];Length@DownValues[Experiment`Private`allRacksSearch],
				ClearMemoization[Experiment`Private`allRacksSearch];Length@DownValues[Experiment`Private`allRacksSearch]
			},
			{1, 3, 1}
		],
		Test["DownValues for functions where the input pattern extracts part of a more complex expression are preserved when memoization is cleared:",
			ClearMemoization[clearMemoizationTestFunction];
			Length[DownValues[clearMemoizationTestFunction]],
			1
		]
	}
];