(* ::Package:: *)

(* There is not a command builder for Download/Import/Open cloud files because this functionality is present in the blobs*)

(* ::Subsubsection::Closed:: *)
(*UploadCloudFile*)

(* NOTE: This adds autocomplete for UploadCloudFile. See https://mathematica.stackexchange.com/questions/56984/argument-completions-for-user-defined-functions *)
FE`Evaluate[FEPrivate`AddSpecialArgCompletion["UploadCloudFile" -> {2}]];

DefineOptions[UploadCloudFile,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "uploads",
			{
				OptionName -> Name,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line],
				Description -> "The name to give the cloud file. Null will make the cloud file nameless.",
				ResolutionDescription -> "Automatically resolves to the name of the input file. If the input does not have a file name, resolves to Null."
			}
		],
		{
			OptionName -> Notebook,
			Default -> $Notebook,
			AllowNull -> True,
			Widget -> Widget[Type -> Object, Pattern :> ObjectP[Object[LaboratoryNotebook]]],
			Description -> "Indicates the notebook to which newly generated cloud files will belong to.",
			Category -> "Hidden"
		},
		{
			OptionName -> DeleteLocalFiles,
			Default -> False,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Description -> "Indicates if the local files should be deleted after uploading is complete."
		},
		UploadOption,
		OutputOption
	}
];

(* for windows - https://stackoverflow.com/questions/1976007/what-characters-are-forbidden-in-windows-and-linux-directory-names *)
(* for mac - https://www.informit.com/articles/article.aspx?p=1144082&seqNum=5#:~:text=Like%20other%20Unixes%2C%20the%20command,down%20from%20the%20system%20root *)
(* [], {}, : are commonly restricted symbols, but they are ubiquitous in the filenames in SLL (e.g. Object[Data, "id:abc"]), if we block them we will have to blitz the uploaded file names *)
$invalidFileNameCharacters = {"/", "<", ">", "|", "?", "*"};

Error::Directory="`1` are directories. Only individual file uploads are supported.";
Error::NotFound="The files `1` could not be found.";
Error::EmptyFiles="The files `1` were empty.";
(* grow the list of problematic characters for file names *)
Error::InvalidFileName="The file names `1`, contain a character from the list that cannot be safely parsed: " <> StringTake[ToString[$invalidFileNameCharacters], {2, -2}] <> ".";
UploadCloudFile::ConflictingNotebooks="The Notebook option `1` is in conflict with the $Notebook `2`. $Notebook will be used to populate the Notebook field of the Object[CloudFile].";

(* Empty input is returned unchanged *)
UploadCloudFile[emptyInput:{}, myOptions:OptionsPattern[]]:=emptyInput;

UploadCloudFile[rawPath:FilePathP | File[FilePathP] | _Image, myOptions:OptionsPattern[]]:=Module[{result},
	result=UploadCloudFile[{rawPath}, myOptions];

	(* If they just asked for the result and got back a single object in a list, remove the object from the list *)
	If[MatchQ[result, {ObjectP[Object[EmeraldCloudFile]]}],
		First[result],
		result
	]
];

UploadCloudFile[rawPaths:{(FilePathP | File[FilePathP] | _Image) ..}, myOptions:OptionsPattern[]]:=Module[
	{
		upload, expandedPaths, listedNames, sanitizedPaths, missingFiles, emptyFiles, directories, paths,
		cloudFiles, fileSizes, fileTypes, names, resolvedNames, cloudFilePackets, safeOps, listedOptions, outputSpecification,
		output, gatherTests, safeOpsTests,conflictingNotebookTest, validLengths, validLengthTests, expandedSafeOps, uploadResult, missingFilesTest,
		directoriesTest, emptyFilesTest, notebook, resolvedNotebook, validNotebookError, problematicNames, problematicCharactersTest, cloudFileIDs
	},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output, Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOps, safeOpsTests}=If[gatherTests,
		SafeOptions[UploadCloudFile, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[UploadCloudFile, listedOptions, AutoCorrect -> False], {}}
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[UploadCloudFile, {rawPaths}, safeOps, Output -> {Result, Tests}],
		{ValidInputLengthsQ[UploadCloudFile, {rawPaths}, safeOps], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Expand and extract index-matching options *)
	{{expandedPaths}, expandedSafeOps}=ExpandIndexMatchedInputs[UploadCloudFile, {ToList[rawPaths]}, safeOps];
	{upload, listedNames, notebook}=Lookup[expandedSafeOps, {Upload, Name, Notebook}];

	(* -------------------- *)
	(* -- Error Checking -- *)
	(* -------------------- *)

	(* -- Notebook error checking --*)
	(* Transfer[Notebook]-> Link[$Notebook, Objects] is added automatically to the end of all uploads so w can only use this option if Notebook is $Notebook or if $Notebook is Null, otherwise there will be a conflict on upload *)
	(* if we want to do any other permissions based checks they can be added here *)
	{resolvedNotebook, validNotebookError} = Which[
		(*Notebook is Null - no need to do anything*)
		MatchQ[notebook, Null],
		{Null, Null},

		(*$Notebook is Null  - just use the option*)
		MatchQ[$Notebook, Null],
		{Download[notebook, Object], Null},

		(* Notebook == $Notebook - use either ($Notebook is already link stripped) *)
		MatchQ[notebook, ObjectP[$Notebook]],
		{$Notebook, Null},

		(* If both $Notebook and Notebook are populated and are not the same, we are in conflict. Use $Notebook as that is the uploaded value of the conflicting packets anyway.*)
		True,
		{$Notebook, Conflict}
	];

	(* conflicting nb tests and error messaging *)
	conflictingNotebookTest=If[gatherTests,
		If[MatchQ[validNotebookError, Conflict],
			Test["The Notebook option does not conflict with $Notebook: ", True, False],
			Test["The Notebook option does not conflict with $Notebook: ", True, True]
		],
		Nothing
	];

	If[MatchQ[validNotebookError, Conflict]&&!gatherTests,
		Message[UploadCloudFile::ConflictingNotebooks, notebook, $Notebook]
	];


	(* -- Path/File error checking -- *)

	(* Get File[] input into file path form. Get images into file path form by exporting the image to a file. *)
	sanitizedPaths=expandedPaths /. {File[x_] :> x, x_Image :> Export[FileNameJoin[{$TemporaryDirectory, CreateUUID[]<>".jpg"}], x, "Image"]};

	(* If we got a file name that is not full, expand it out using the current set directory *)
	paths=Map[ExpandFileName, sanitizedPaths];

	(* Find any input files that do not exist *)
	missingFiles=Select[
		paths,
		Not[FileExistsQ[#]]&
	];

	(* Throw an error or test and fail if any input files do not exist *)
	missingFilesTest=If[gatherTests,
		If[Length[missingFiles] > 0,
			Test["Our files could be found: "<>ToString[missingFiles]<>":", True, False],
			Test["Our files could be found: "<>ToString[missingFiles]<>":", True, True]
		],
		Nothing
	];
	If[Length[missingFiles] > 0,
		If[!gatherTests, Message[Error::NotFound, missingFiles];Message[Error::InvalidInput, missingFiles];];
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests, missingFilesTest, conflictingNotebookTest}],
			Options -> $Failed,
			Preview -> Null
		}];
	];

	(* Find any inputs that are directories instead of files *)
	directories=Select[
		paths,
		DirectoryQ
	];

	(* Throw an error and fail if any of the file paths are directories and not files *)
	directoriesTest=If[gatherTests,
		If[Length[directories] > 0,
			Test["Inputs are individual files, not directories: "<>ToString[directories]<>":", True, False],
			Test["Inputs are individual files, not directories: "<>ToString[directories]<>":", True, True]
		],
		Nothing
	];

	If[Length[directories] > 0,
		If[!gatherTests, Message[Error::Directory, directories];Message[Error::InvalidInput, directories]];
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests, missingFilesTest, directoriesTest, conflictingNotebookTest}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Find any files that are empty *)
	emptyFiles=Select[
		paths,
		FileSize[#] == Quantity[0, "Bytes"] &
	];

	(* Throw an error and fail if any file is empty *)
	emptyFilesTest=If[gatherTests,
		If[Length[emptyFiles] > 0,
			Test["Inputs files are not empty: "<>ToString[emptyFiles]<>":", True, False],
			Test["Inputs files are not empty: "<>ToString[emptyFiles]<>":", True, True]
		],
		Nothing
	];
	If[Length[emptyFiles] > 0,
		If[!gatherTests, Message[Error::EmptyFiles, emptyFiles];Message[Error::InvalidInput, emptyFiles]];
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests, missingFilesTest, directoriesTest, emptyFilesTest, conflictingNotebookTest}],
			Options -> $Failed,
			Preview -> Null
		}];
	];

	(* ---------------------- *)
	(* -- Generate packets -- *)
	(* ---------------------- *)

	(* Generate the cloud files *)
	cloudFiles=Constellation`Private`signAndUploadS3[paths];

	(* Get the type of each file *)
	fileTypes=FileExtension /@ paths /. {"" -> Null};

	(* Get the size of each file *)
	fileSizes=FileSize[#] & /@ paths;

	(* Resolve any Automatic names to be the file name (except in the cases where the input was an image and we randomly generated the file name; in this case, name the name Null). *)
	resolvedNames=MapThread[Function[{nameOption, input, path},
		Switch[{nameOption, input},
			{_String | Null, _}, nameOption, (* If the name option is non-Automatic, use the specified name option *)
			{Automatic, _Image}, Null, (* If the name option is Automatic and the input was an image, use Null*)
			{Automatic, Except[_Image]}, FileBaseName[path] (* Otherwise use the name of the input file *)
		]
	], {listedNames, expandedPaths, paths}];
	
	(* find if the file names are acceptable *)
	{problematicNames, problematicCharactersTest} = problematicFileNames[resolvedNames, gatherTests, True];
	
	(* Throw an error and fail if any of the file names have bad characters *)
	If[Length[problematicNames] > 0,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests, missingFilesTest, directoriesTest, emptyFilesTest, conflictingNotebookTest, problematicCharactersTest}],
			Options -> $Failed,
			Preview -> Null
		}];
	];
	
	(* batch create ID for cloud files, since this calls Upload *)
	cloudFileIDs = CreateID[ConstantArray[Object[EmeraldCloudFile], Length[fileSizes]]];

	(* If notebook is not Null, generate the update to the lookup table. Don't do this for cases where the name is Null. *)
	(* Make the update packet for each cloud file *)
	cloudFilePackets=MapThread[
		Function[{size, type, name, s3, cloudFileID},
			<|
				Type -> Object[EmeraldCloudFile],
				Object -> cloudFileID,
				FileName -> name,
				FileSize -> size,
				FileType -> type,
				CloudFile -> s3,
				If[MatchQ[resolvedNotebook, Except[Null]],
					Transfer[Notebook]-> Link[resolvedNotebook, Objects],
					Nothing
				]
			|>
		],
		{fileSizes, fileTypes, resolvedNames, cloudFiles, cloudFileIDs}
	];

	(* Upload if we are uploading and returning the result *)
	uploadResult=If[upload && MemberQ[output, Result],
		Upload[cloudFilePackets],
		cloudFilePackets
	];
	
	(* If DeleteLocalFiles is True, then remove the local files *)
	If[TrueQ[Lookup[safeOps, DeleteLocalFiles]],
		DeleteFile[paths]
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> uploadResult,
		Tests -> Flatten[{safeOpsTests, validLengthTests, missingFilesTest, directoriesTest, emptyFilesTest, conflictingNotebookTest, problematicCharactersTest}],
		Options -> RemoveHiddenOptions[UploadCloudFile, safeOps],
		Preview -> Null
	}
];

(* helper that finds if names will cause file system problems *)
problematicFileNames[resolvedNames_, gatherTests_, optionBoolean_]:= Module[
	{
		problematicNames, problematicCharactersTest
	},
	
	(* Name error checking that it does not contain any symbols from $invalidFileNameCharacters *)
	(* Images automatically have the name Null, which will not be selected as a problematic name *)
	problematicNames = Select[resolvedNames, StringContainsQ[ToString[#], $invalidFileNameCharacters]&];
	
	(* Gather tests for problematic characters *)
	problematicCharactersTest=If[gatherTests,
		If[Length[problematicNames] > 0,
			Test["Inputs have acceptable file names: "<>ToString[resolvedNames]<>":", True, False],
			Test["Inputs have acceptable file names: "<>ToString[resolvedNames]<>":", True, True]
		],
		Null
	];
	
	(* if there are issues throw an error *)
	If[Length[problematicNames] > 0  && !gatherTests,
		Message[Error::InvalidFileName, problematicNames];
		If[optionBoolean,
			Message[Error::InvalidOption, Name],
			Message[Error::InvalidInput, problematicNames]
		]
	];

	(* return problematic names, tests *)
	{problematicNames, problematicCharactersTest}

];


(* ::Subsubsection::Closed:: *)
(*UploadCloudFileOptions*)


DefineOptions[UploadCloudFileOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
			Description -> "Determines whether the function returns a table or a list of the options."
		}

	},
	SharedOptions :> {UploadCloudFile}];

UploadCloudFileOptions[myInputs:ListableP[(FilePathP | File[FilePathP] | _Image) | _String], myOptions:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output and OutputFormat option before passing to the core function because it doens't make sense here *)
	noOutputOptions=DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* get only the options for UploadCloudFile *)
	options=UploadCloudFile[myInputs, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, UploadCloudFile],
		options
	]
];



(* ::Subsubsection::Closed:: *)
(*ValidUploadCloudFileQ*)


DefineOptions[ValidUploadCloudFileQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {UploadCloudFile}
];


ValidUploadCloudFileQ[myInputs:ListableP[(FilePathP | File[FilePathP] | _Image) | _String], myOptions:OptionsPattern[]]:=Module[
	{listedOptions, preparedOptions, UploadCloudFileTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions=DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for UploadCloudFile *)
	UploadCloudFileTests=UploadCloudFile[myInputs, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests=If[MatchQ[UploadCloudFileTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, testResults},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest=Test[initialTestDescription, True, True];

			(* get all the tests/warnings *)
			Flatten[{initialTest, UploadCloudFileTests}]
		]
	];
	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidUploadCloudFileQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidUploadCloudFileQ"]
];



(* ::Subsubsection::Closed:: *)
(*UploadCloudFilePreview*)


DefineOptions[UploadCloudFilePreview,
	SharedOptions :> {UploadCloudFile}
];

UploadCloudFilePreview[myInputs:ListableP[(FilePathP | File[FilePathP] | _Image) | _String], myOptions:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it does't make sense here *)
	noOutputOptions=DeleteCases[listedOptions, Output -> _];

	(* Call UploadCloudFile with Output->Preview *)
	UploadCloudFile[myInputs, Append[noOutputOptions, Output -> Preview]]

];

DefineOptions[RenameCloudFile,
	Options :> {
		UploadOption,
		OutputOption
	}
];

(* Empty input is returned unchanged *)
RenameCloudFile[emptyInput:{}, myOptions:OptionsPattern[]]:=emptyInput;

RenameCloudFile[cloudFiles:ListableP[ObjectP[Object[EmeraldCloudFile]]], newNames:ListableP[_String | Null], myOptions:OptionsPattern[]]:=Module[{listedOptions,
	outputSpecification, output, gatherTests, safeOps, safeOpsTests, validLengths, validLengthTests, expandedCloudFiles,
	expandedNames, expandedSafeOps, upload, packets, uploadResult, problematicNames, problematicCharactersTest
},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output, Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOps, safeOpsTests}=If[gatherTests,
		SafeOptions[RenameCloudFile, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[RenameCloudFile, listedOptions, AutoCorrect -> False], {}}
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];
	
	(* check if names are acceptable *)
	{problematicNames, problematicCharactersTest} = problematicFileNames[ToList[newNames], gatherTests, False];
	
	(* if there are any bad file names, return failures *)
	If[Length[problematicNames]>0,
		Return[ReplaceAll[outputSpecification,
			{
				Result -> $Failed,
				Tests -> Flatten[{safeOpsTests, problematicCharactersTest}],
				Options -> $Failed,
				Preview -> Null
			}
		]]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[RenameCloudFile, {ToList[cloudFiles], newNames}, safeOps, Output -> {Result, Tests}],
		{ValidInputLengthsQ[RenameCloudFile, {ToList[cloudFiles], newNames}, safeOps], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests, problematicCharactersTest}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Expand index-matching options *)
	{{expandedCloudFiles, expandedNames}, expandedSafeOps}=ExpandIndexMatchedInputs[RenameCloudFile, {ToList[cloudFiles], newNames}, safeOps];

	(* Determine whether to upload *)
	upload=Lookup[expandedSafeOps, Upload];

	(* Make the upload packets *)
	packets=MapThread[
		<|
			Object -> #1,
			FileName -> #2
		|>&, {expandedCloudFiles, expandedNames}
	];

	(* Upload if we are uploading and returning the result *)
	uploadResult=If[upload && MemberQ[output, Result],
		Upload[packets],
		packets
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> uploadResult,
		Tests -> Flatten[{safeOpsTests, validLengthTests, problematicCharactersTest}],
		Options -> RemoveHiddenOptions[RenameCloudFile, safeOps],
		Preview -> Null
	}
];


(* ::Subsubsection::Closed:: *)
(*RenameCloudFileOptions*)


DefineOptions[RenameCloudFileOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
			Description -> "Determines whether the function returns a table or a list of the options."
		}

	},
	SharedOptions :> {RenameCloudFile}];

RenameCloudFileOptions[cloudFiles:ListableP[ObjectP[Object[EmeraldCloudFile]]], newNames:ListableP[_String | Null], myOptions:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output and OutputFormat option before passing to the core function because it doens't make sense here *)
	noOutputOptions=DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* get only the options for RenameCloudFile *)
	options=RenameCloudFile[cloudFiles, newNames, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, RenameCloudFile],
		options
	]
];



(* ::Subsubsection::Closed:: *)
(*ValidRenameCloudFileQ*)


DefineOptions[ValidRenameCloudFileQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {RenameCloudFile}
];


ValidRenameCloudFileQ[cloudFiles:ListableP[ObjectP[Object[EmeraldCloudFile]]], newNames:ListableP[_String | Null], myOptions:OptionsPattern[]]:=Module[
	{listedOptions, preparedOptions, RenameCloudFileTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions=DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for RenameCloudFile *)
	RenameCloudFileTests=RenameCloudFile[cloudFiles, newNames, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests=If[MatchQ[RenameCloudFileTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, testResults},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest=Test[initialTestDescription, True, True];

			(* get all the tests/warnings *)
			Flatten[{initialTest, RenameCloudFileTests}]
		]
	];
	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidRenameCloudFileQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidRenameCloudFileQ"]
];



(* ::Subsubsection::Closed:: *)
(*RenameCloudFilePreview*)


DefineOptions[RenameCloudFilePreview,
	SharedOptions :> {RenameCloudFile}
];

RenameCloudFilePreview[cloudFiles:ListableP[ObjectP[Object[EmeraldCloudFile]]], newNames:ListableP[_String | Null], myOptions:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it does't make sense here *)
	noOutputOptions=DeleteCases[listedOptions, Output -> _];

	(* Call RenameCloudFile with Output->Preview *)
	RenameCloudFile[cloudFiles, newNames, Append[noOutputOptions, Output -> Preview]]

];

(* ::Subsubsection::Closed:: *)
(*DownloadCloudFile*)


DownloadCloudFile::NotFound="Cloud file does not exist: `1`.";
DownloadCloudFile::DestinationPath="Destination path does not exist: `1`.";

DownloadCloudFile[cloudFile:EmeraldCloudFile["AmazonS3", bucket_String, key_String, cloudFileId:(_String | None):None], rawPath_String]:=Constellation`Private`downloadCloudFile[cloudFile, rawPath];

DownloadCloudFile[object:ObjectP[Object[EmeraldCloudFile]], rawPath:_String]:=FirstOrDefault[ToList[DownloadCloudFile[{object}, {rawPath}]]];

DownloadCloudFile[objects:{ObjectP[Object[EmeraldCloudFile]]..}, rawPaths:{_String..}]:=Module[{cloudFiles, names,
	extensions, paths, s3Keys, s3Names, s3Extensions, calculatedExtensions, calculatedNames, calculatedFullNames,
	completePaths, pathFoundBools, cloudFileExistsBools},

	(* Download the S3 bucket and file name and type *)
	{cloudFiles, names, extensions}=Transpose[Download[objects, {CloudFile, FileName, FileType}]];

	(* Expand the file paths *)
	paths=ExpandFileName[#] & /@ rawPaths;

	(* Get the s3 names and extensions *)
	s3Keys=cloudFiles[[All, 3]];
	s3Names=FileBaseName[#]& /@ s3Keys;
	s3Extensions=FileExtension[#] & /@ s3Keys;

	(* Determine what extension to use in the event that the user didn't provide on in the path.
	Preferentially use the extension found in the object over the one in the s3 bucket. *)
	calculatedExtensions=MapThread[Function[{extension, s3Extension},
		Which[
			!MatchQ[extension, "" | Null], extension,
			!MatchQ[s3Extension, "" | Null], s3Extension,
			True, Null
		]], {extensions, s3Extensions}];

	(* Determine what name to use in the event that the user didn't provide on in the path.
Preferentially use the name found in the object over the one in the s3 bucket.
If we don't know the name, call it Untitled_UUID.extension *)
	calculatedNames=MapThread[Function[{name, s3Name},
		Which[
			!MatchQ[name, "" | Null], name,
			!MatchQ[s3Name, "" | Null], s3Name,
			True, StringJoin["Untitled_", StringReplace[CreateUUID[], "-" -> ""]]
		]], {names, s3Names}];

	(* Determine what name+extension to use in the event that the user didn't provide on in the path. *)
	calculatedFullNames=MapThread[Function[{name, extension},
		If[NullQ[extension],
			name,
			name<>"."<>extension
		]], {calculatedNames, calculatedExtensions}
	];
	
	(*
		mathematica represents / as " : " in file path names on macs,
		however on windows forward slash gets converted to a backward in the file name.
		To be consistent and open and file in the same way on both OSes we replace "/"
		with "_"
	*)
	calculatedFullNames = StringReplace[calculatedFullNames, {$invalidFileNameCharacters -> "_"}];
	
	(* Get the name + extension to use if we have to make a name *)
	completePaths=MapThread[Function[{path, name, extension},
		Which[
			(* If they just gave us a directory, and we know the name and extension from the object, append the cloud file ID as the file name and extension*)
			DirectoryQ[path], FileNameJoin[{path, name}],

			(* If they didn't provide a file extension and we know the extension, append the extension *)
			MatchQ[FileExtension[path], ""] && !NullQ[extension], StringJoin[path, ".", extension],

			(* Otherwise, use the given path*)
			True, path
		]], {paths, calculatedFullNames, calculatedExtensions}];

	(* If the directory does not exist, error *)
	pathFoundBools=FileExistsQ[DirectoryName[#]]& /@ completePaths;
	
	If[MemberQ[pathFoundBools, False],
		Message[DownloadCloudFile::DestinationPath, DirectoryName[#]& /@ PickList[completePaths, pathFoundBools, False]];
		Return[$Failed];
	];

	(* If the cloud file does not exist, error *)
	cloudFileExistsBools=CloudFileExistsQ[#]& /@ cloudFiles;
	If[MemberQ[cloudFileExistsBools, False],
		Message[DownloadCloudFile::NotFound, PickList[objects, cloudFileExistsBools, False]];
		Return[$Failed];
	];

	MapThread[Constellation`Private`signAndDownloadS3[#1, #2]&, {cloudFiles, completePaths}]

];


(* ::Subsubsection::Closed:: *)
(*OpenCloudFile*)


OpenCloudFile::DownloadFailed="An error occurred while attempting to download the cloud file: `1`.";

OpenCloudFile[cloudFiles:ListableP[ObjectP[Object[EmeraldCloudFile]]]]:=Module[
	{files},

	(* Download the cloud files. If a name was given but multiple files with the same name were found, we will have multiple file paths returned. *)
	files=DownloadCloudFile[ToList[cloudFiles], ConstantArray[$TemporaryDirectory, Length[ToList[cloudFiles]]]];

	(* If any returned values are not strings, throw a message and fail *)
	If[!MatchQ[files, {_String..}],
		Message[OpenCloudFile::DownloadFailed, cloudFiles];
		Return[$Failed]
	];

	(* Must use SafeOpen so files open correctly in the ISE and desktop Mathematica. Return singleton value if only one file. *)
	(SafeOpen[#]& /@ files) /. If[Length[files] == 1, x_ :> FirstOrDefault[x], x_ :> x]
];

OpenCloudFile[cloudFile:EmeraldCloudFileP]:=Constellation`Private`openCloudFile[cloudFile];





(* ::Subsubsection::Closed:: *)
(*ImportCloudFile*)


importCache;
initImportCache[]:=With[{}, importCache=Association[];];
initImportCache[];

OnLoad[
	initImportCache[];
];


DefineOptions[ImportCloudFile,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "imports",
			{
				OptionName -> Format,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> String, Pattern :> _String?(MemberQ[$ImportFormats, #]&), Size -> Line],
				Description -> "Format to import the EmeraldCloudFile instance as.",
				ResolutionDescription -> "Automatically resolves to the format that the cloud file was uploaded as."
			}
		],
		{
			OptionName -> Force,
			Default -> False,
			Description -> "When True, fetches directly from the web and ignores cached results.",
			AllowNull -> False,
			Category -> "Method",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		}
	}
];

(* Since we are encouraging the user to use the UI buttons, ImportCloudFile does not have the Output options or sister functions (ValidImportCloudFileQ, ImportCloudFilePreview, ImportCloudFileOptions *)
ImportCloudFile::NotFound="Cloud file does not exist: `1`.";

ImportCloudFile[Null]:=Null;

ImportCloudFile[$Failed]:=$Failed;

ImportCloudFile[cloudFile:EmeraldCloudFileP, ops:OptionsPattern[]]:=Constellation`Private`importCloudFile[cloudFile, ops];

ImportCloudFile[cloudFileObject:ObjectP[Object[EmeraldCloudFile]], myOptions:OptionsPattern[]]:=FirstOrDefault[ImportCloudFile[{cloudFileObject}, myOptions]];

ImportCloudFile[cloudFileObjects:{(ObjectP[Object[EmeraldCloudFile]] | Null)..}, myOptions:OptionsPattern[]]:=Module[
	{listedInputs, listedOptions, safeOps, expr, formatOptions, force, path, cloudFiles, validLengths, expandedSafeOps, fileTypes},

	(* Make sure we're working with a list of options and inputs *)
	listedOptions=ToList[myOptions];
	listedInputs=ToList[cloudFileObjects];

	(* Get the option values *)
	safeOps=SafeOptions[ImportCloudFile, listedOptions];

	validLengths=ValidInputLengthsQ[ImportCloudFile, {listedInputs}, safeOps];
	If[!validLengths,
		Return[$Failed]
	];

	(* Expand index-matching options *)
	expandedSafeOps=ExpandIndexMatchedInputs[ImportCloudFile, {listedInputs}, safeOps, Messages -> False][[2]];
	formatOptions=Lookup[expandedSafeOps, Format];
	force=Lookup[expandedSafeOps, Force];

	(* Download the S3 bucket  *)
	{cloudFiles, fileTypes}=Transpose[Download[listedInputs, {CloudFile, FileType}] /. Null -> {Null, Null}];

	MapThread[Function[{cloudFile, formatOption, fileType},
		Which[

			(* Return Null if Null *)
			NullQ[cloudFile],
			Null,

			(* return cached version if available *)
			Not[force] && KeyExistsQ[importCache, cloudFile],
			importCache[{cloudFile, formatOption}],

			(* Otherwise download from S3 *)
			True,
			Module[{resolvedFormat},

				(* Figure out the default based on the content type (aka CloudFileFormat)*)
				resolvedFormat=If[!MatchQ[formatOption, Automatic],
					formatOption,
					If[MatchQ[fileType, "txt"],
						"Text",
						SelectFirst[$ImportFormats, ToLowerCase[#] == ToLowerCase[fileType]&, Indeterminate]
					]
				];

				(* If we couldn't infer the file format, return $Failed. (FileFormat will throw a message.) *)
				If[MatchQ[resolvedFormat, $Failed],
					Return[$Failed, Module]
				];

				(*Download file to temporary path and Import it*)
				(* Use the privatized version since we already downloaded the S3 bucket from SLL and we don't want to do more downloading *)
				(* If the file doesn't exist, give an error and $Failed for that index *)
				path=Quiet[
					Check[
						Constellation`Private`downloadCloudFile[cloudFile, FileNameJoin[{$TemporaryDirectory, CreateUUID[]}]],
						Message[ImportCloudFile::NotFound, cloudFile];
						Return[$Failed, Module],
						Constellation`Private`downloadCloudFile::NotFound
					],
					Constellation`Private`downloadCloudFile::NotFound
				];
				If[path === $Failed,
					Message[ImportCloudFile::DownloadFailed, cloudFile];
					Return[$Failed, Module];
				];

				(*Block the $ContextPath during Import as it may add GeneralUtilities` which conflicts with Search*)
				With[{contextPath=$ContextPath},
					Block[
						{$ContextPath=contextPath},

						expr=Check[
							If[MatchQ[resolvedFormat, Indeterminate],
								Import[path],
								Import[path, resolvedFormat]
							],
							Return[$Failed, Module]
						]
					]
				];

				(*Clean up temporary file*)
				Quiet[DeleteFile[path]];

				(*cache result for subsequent calls*)
				If[expr =!= $Failed,
					AppendTo[importCache, {cloudFile, resolvedFormat} -> expr]
				];
				expr
			]
		]], {cloudFiles, formatOptions, fileTypes}
	]
];



(* ::Subsubsection::Closed:: *)
(*convertCloudFile*)


DefineOptions[convertCloudFile,
	Options :> {
		UploadOption,
		{FileName -> Null, ListableP[_String | Null], "The name to give the resulting cloud file object."},
		{Notebook -> $Notebook, ListableP[Null | ObjectP[Object[LaboratoryNotebook]]], "A laboratory notebook to which the cloud files should be associated."}
	}
];

(* Helper function to convert cloud file to an object *)
convertCloudFile[cloudFiles:ListableP[EmeraldCloudFileP], myOptions:OptionsPattern[]]:=TraceExpression["convertCloudFile", Module[{listedOptions, upload, names,
	listedFiles, listedNames, packets, notebooks, listedNotebooks, newObjects},

	(* Get the option values *)
	listedOptions=ToList[myOptions];
	upload=Lookup[listedOptions, Upload, True];
	names=Lookup[listedOptions, FileName, Null];
	notebooks=Lookup[listedOptions, Notebook, $Notebook];

	(* If the input is a singleton, get it into a list. If one input is a list and the other is a singleton, expand out the singleton to match the length of the list.  *)
	{listedFiles, listedNames}=Switch[{cloudFiles, names},
		{_List, _List}, {cloudFiles, names},
		{Except[_List], Except[_List]}, {ToList[cloudFiles], ToList[names]},
		{_List, Except[_List]}, {cloudFiles, ConstantArray[names, Length[cloudFiles]]},
		{Except[_List], _List}, {ConstantArray[cloudFiles, Length[names]], names}
	];

	(* Validate that the input files list and names list are the same length. If not, return an error and $Failed. *)
	If[!SameLengthQ[listedFiles, listedNames],
		Message[Error::InputLengthMismatch, listedFiles, Length[listedFiles], names, Length[listedNames]];
		Return[$Failed]
	];

	(*Expand the notebook option as needed *)
	listedNotebooks=If[MatchQ[notebooks, _List],
		notebooks,
		ConstantArray[notebooks, Length[listedFiles]]
	];

	(* Validate that the input files list and notebooks list are the same length. If not, return an error and $Failed. *)
	If[!SameLengthQ[listedFiles, listedNotebooks],
		Message[Error::InputLengthMismatch, listedFiles, Length[listedFiles], notebooks, Length[listedNotebooks]];
		Return[$Failed]
	];

	(* Use the listable version of CreateID to make the IDs here instead of calling it for each packet *)
	newObjects=CreateID[ConstantArray[Object[EmeraldCloudFile], Length[listedFiles]]];

	packets=MapThread[Function[{type, s3, name, notebook, object}, <|
		Type -> Object[EmeraldCloudFile],
		Object -> object,
		FileType -> type,
		CloudFile -> s3,
		FileName -> name,
		If[!NullQ[notebook],
			Transfer[Notebook] -> Link[notebook, Objects],
			Transfer[Notebook] -> Null
		]
	|>], {FileExtension[#[[3]]] & /@ listedFiles, listedFiles, listedNames, listedNotebooks, newObjects}];

	(* Upload if we are uploading *)
	If[upload,
		Upload[packets, Verbose -> False],
		packets
	]

] /. If[MatchQ[cloudFiles, _List], x_ :> x, x_ :> FirstOrDefault[x]]]; (* Convert the output to a singleton if the input was a singleton *)
