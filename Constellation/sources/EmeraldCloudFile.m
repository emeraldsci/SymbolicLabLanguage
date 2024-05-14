(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


General::NotLoggedIn="Not logged in.";

(* ::Subsubsection::Closed:: *)
(* FileFormat *)


EmeraldCloudFileFormat::Failed="`1`";
EmeraldCloudFile/:FileFormat[EmeraldCloudFile["AmazonS3", bucket_String, key_String, cloudFileId:(_String | None):None]]:=Module[
	{response, error},
	response=GoCall["HeadCloudFile", <|
		"Key" -> key,
		"Bucket" -> bucket,
		"Retries" -> 5
	|>];

	error=Lookup[response, "Error"];
	If[MatchQ[error, _String],
		(
			Message[EmeraldCloudFileFormat::Failed, error];
			$Failed
		),
		Replace[
			Lookup[response, "ContentType"],
			formatConversions,
			{0}
		]
	]
];


formatConversions={
	"image/png" -> "PNG",
	"image/jpeg" -> "JPEG",
	"image/gif" -> "GIF",
	"image/tiff" -> "TIFF",
	"image/svg+xml" -> "SVG",
	"application/pdf" -> "PDF",
	"image/bmp" -> "BMP",
	"text/plain" -> "Text",
	_ -> Indeterminate
};



(* ::Subsubsection:: *)
(*CloudFileFormatP*)


$CloudFileFormats=formatConversions[[All, 2]];
formatP:=Apply[Alternatives, $CloudFileFormats];
formatsP=formatP | Verbatim[Alternatives][formatP..];
asSupportedFormat[format:_String | Indeterminate]:=If[MatchQ[format, formatP],
	format,
	Indeterminate
];

(* Patterns *)

Unprotect[FilePathP];
FilePathP:=_String;
Protect[FilePathP];

(* remote only *)
Unprotect[EmeraldCloudFileP];
EmeraldCloudFileP=Alternatives[
	EmeraldCloudFile["AmazonS3", (* bucket *) _String, (* key *) _String, (* cloudFileId *) (_String | None)],
	EmeraldCloudFile["AmazonS3", (* bucket *) _String, (* key *) _String],
	ObjectP[Object[EmeraldCloudFile]]
];
Protect[EmeraldCloudFileP];
EmeraldCloudFileQ[EmeraldCloudFileP]:=True;
EmeraldCloudFileQ[_]:=False;

(* local or remote *)
Unprotect[EmeraldFileP];
EmeraldFileP=Alternatives[
	File[FilePathP],
	EmeraldCloudFileP
];
Protect[EmeraldFileP];
EmeraldFileQ[EmeraldFileP]:=True;
EmeraldFileQ[_]:=False;

(* given one of the supported cloud file formats, construct another pattern which, given a file, will check the results of FileFormat *)
Unprotect[emeraldFileFormatP];
emeraldFileFormatP[formatPattern:formatsP]=PatternTest[
	EmeraldFileP,
	MatchQ[asSupportedFormat[FileFormat[#]], formatPattern]&
];
Protect[emeraldFileFormatP];
emeraldFileFormatQ[file_, formatPattern:formatsP]:=MatchQ[file, emeraldFileFormatP[formatPattern]];

(* local or remote *)
Unprotect[ImageFileP];
ImageFileP=emeraldFileFormatP["JPEG" | "PNG" | "TIFF" | "BMP" | "SVG"];
Protect[ImageFileP];
ImageFileQ[ImageFileP]:=True;
ImageFileQ[_]:=False;

(* local or remote *)
Unprotect[PDFFileP];
PDFFileP=emeraldFileFormatP["PDF"];
Protect[PDFFileP];
PDFFileQ[PDFFileP]:=True;
PDFFileQ[_]:=False;



(* ::Subsubsection::Closed:: *)
(*signAndUploadS3*)


(*Args are the file paths, number of retries, an max-in-flight uploads*)
signAndUploadS3[paths:{___String}]:=Map[
	parseUploadResult,
	GoCall["UploadCloudFile", <|
		"Paths" -> paths,
		"Retries" -> 4,
		"Concurrency" -> 5
	|>]
];

parseUploadResult[assoc_Association]:=With[
	{
		error=Lookup[assoc, "Error"],
		path=Lookup[assoc, "Path"],
		bucket=Lookup[assoc, "Bucket"],
		key=Lookup[assoc, "Key"]
	},

	If[MatchQ[error, _String],
		Message[uploadCloudFile::UploadFailed, path, error];
		Return[$Failed]
	];

	If[bucket === "" || key === "",
		Message[uploadCloudFile::UploadFailed, path, "Unexpected upload failure: no server message."];
		Return[$Failed]
	];

	EmeraldCloudFile["AmazonS3", bucket, key]
];

signAndDownloadS3[
	EmeraldCloudFile["AmazonS3", bucket_String, key_String, cloudFileId:(_String | None):None],
	path_String
]:=Module[
	{remoteFileOptions, localContentSize, result, error},

	(* Build the options for the download *)
	remoteFileOptions=<|
		"Bucket" -> bucket,
		"Key" -> key,
		"Retries" -> 4
	|>;

	(* We're going to see if what's on disk matches what's on the remote.  Normally we'd do that with a hash, but AWS doesn't always give us that, so we'll use the content size instead, which is what we use elsewhere *)
	If[FileExistsQ[path],
		(* If the content size matches what we have locally, then call it day and avoid redownloading *)
		If[MatchQ[ToString[FileByteCount[path]], Lookup[GoCall["HeadCloudFile", remoteFileOptions], "ContentSize"]],
			Return[path];
		];
	];

	(* Download the file *)
	result=GoCall["DownloadCloudFile", Join[<|"Path"->path|>, remoteFileOptions]];

	(* Check for any errors *)
	error=Lookup[result, "Error"];

	(* Construct the result *)
	If[MatchQ[error, _String],
		(
			Message[downloadCloudFile::DownloadFailed, error];
			$Failed
		),
		path
	]
];


(* ::Subsubsection:: *)
(*uploadCloudFile*)


uploadCloudFile::UploadFailed="Error uploading `1`: `2`.";
uploadCloudFile::Directory="`1` are directories. Only individual file uploads are supported.";
uploadCloudFile::NotFound="The files `1` could not be found.";
uploadCloudFile::EmptyFiles="The files `1` were empty.";

uploadCloudFile[{}]:={};
uploadCloudFile[image_Image]:=First[
	uploadCloudFile[{image}]
];
uploadCloudFile[images:{__Image}]:=With[
	{
		tempFiles=Map[
			Export[
				FileNameJoin[{$TemporaryDirectory, CreateUUID[]<>".jpg"}],
				#,
				"Image"
			]&,
			images
		]
	},

	uploadCloudFile[tempFiles]
];

uploadCloudFile[cloudFile:EmeraldCloudFileP]:=cloudFile;

uploadCloudFile[File[path:FilePathP]]:=uploadCloudFile[path];

uploadCloudFile[files:{File[FilePathP]..}]:=uploadCloudFile[ files[[All, 1]] ];

uploadCloudFile[path_String]:=First[
	uploadCloudFile[{path}]
];
uploadCloudFile[rawPaths:{__String}]:=Module[
	{missingFiles, emptyFiles, directories, paths},

	If[!loggedInQ[],
		Message[uploadCloudFile::NotLoggedIn];
		Return[Table[$Failed, Length[rawPaths]]]
	];

	paths=Map[ExpandFileName, rawPaths];

	missingFiles=Select[
		paths,
		Not[FileExistsQ[#]]&
	];
	If[Length[missingFiles] > 0,
		Message[uploadCloudFile::NotFound, missingFiles];
		Return[Table[$Failed, Length[paths]]];
	];

	directories=Select[
		paths,
		DirectoryQ
	];
	If[Length[directories] > 0,
		Message[uploadCloudFile::Directory, directories];
		Return[Table[$Failed, Length[paths]]];
	];

	emptyFiles=Select[
		paths,
		FileSize[#] == Quantity[0, "Bytes"] &
	];
	If[Length[emptyFiles] > 0,
		Message[uploadCloudFile::EmptyFiles, emptyFiles];
		Return[Table[$Failed, Length[paths]]];
	];

	signAndUploadS3[paths]
];



(* ::Subsubsection:: *)
(*CloudFileExistsQ*)


CloudFileExistsQ[Null]:=Null;

CloudFileExistsQ[cloudFile:EmeraldCloudFileP]:=UnsameQ[
	FileFormat[cloudFile],
	$Failed
];


(* ::Subsubsection::Closed:: *)
(*downloadCloudFile -- privatized version that uses S3 buckets and no objects *)


downloadCloudFile::NotFound="Cloud file does not exist: `1`.";
downloadCloudFile::DestinationPath="Destination path does not exist: `1`.";
downloadCloudFile::DownloadFailed="`1`";

downloadCloudFile[Null, _]:=Null;
downloadCloudFile[$Failed, _]:=$Failed;
downloadCloudFile[
	cloudFile:EmeraldCloudFile["AmazonS3", bucket_String, key_String, cloudFileId:(_String | None):None],
	rawPath_String
]:=Module[
	{completePath, keyEnd, path},

	path=ExpandFileName[rawPath];

	If[!loggedInQ[],
		Message[downloadCloudFile::NotLoggedIn];
		Return[$Failed]
	];

	keyEnd=FileNameTake[key, -1];

	completePath=If[DirectoryQ[path],
		(* If the file already exists, add a (#) to the end of the filename so we don't get permissions issues on Windows. *)
		If[!FileExistsQ[FileNameJoin[{path, keyEnd}]],
			FileNameJoin[{path, keyEnd}],
			Module[{i},
				i=1;
				
				(* Add the lowest # to the file name, break out if we've already gone all the way up to 100. *)
				(* That means that something is probably wrong and we don't want to infinite loop. *)
				While[i < 100 && FileExistsQ[FileNameJoin[{path, FileBaseName[keyEnd]<>" ("<>ToString[i]<>")."<>FileExtension[keyEnd]}]],
					i=i + 1;
				];

				FileNameJoin[{path, FileBaseName[keyEnd]<>" ("<>ToString[i]<>")."<>FileExtension[keyEnd]}]
			]

		],
		path
	];

	If[!FileExistsQ[DirectoryName[completePath]],
		Message[downloadCloudFile::DestinationPath, DirectoryName[completePath]];
		Return[$Failed];
	];

	If[!CloudFileExistsQ[cloudFile],
		Message[downloadCloudFile::NotFound, cloudFile];
		Return[$Failed];
	];

	signAndDownloadS3[cloudFile, completePath]
];



(* ::Subsubsection:: *)
(*openCloudFile*)


openCloudFile::DownloadFailed="An error occurred while attempting to download the cloud file: `1`.";
openCloudFile[cloudFile:EmeraldCloudFileP]:=Module[
	{file},

	If[!loggedInQ[],
		Message[openCloudFile::NotLoggedIn];
		Return[$Failed]
	];

	file=downloadCloudFile[cloudFile, $TemporaryDirectory];
	If[!MatchQ[file, _String],
		Message[openCloudFile::DownloadFailed, cloudFile];
		Return[$Failed]
	];

	(*Must use SafeOpen so files open correctly in the ISE and desktop Mathematica.*)
	SafeOpen[file]
];

SetAttributes[openCloudFile, Listable];



(* ::Subsubsection:: *)
(*importCloudFile*)


importCache;
initImportCache[]:=With[{}, importCache=Association[];];
initImportCache[];

importCloudFile::NotFound="Cloud file does not exist: `1`.";
importCloudFile::DownloadFailed="There was an error retrieving the cloud file: `1`.";

importCloudFile[Null]:=Null;
importCloudFile[$Failed]:=$Failed;
importCloudFile[cloudFile:EmeraldCloudFileP, ops:OptionsPattern[]]:=Module[
	{expr, format, force, path, docxFilePaths, importedDocxFiles},

	format=OptionDefault[OptionValue["Format"]];
	force=OptionDefault[OptionValue["Force"]];

	If[!loggedInQ[],
		Message[importCloudFile::NotLoggedIn];
		Return[$Failed]
	];

	(*check for cached versions*)
	If[Not[force] && KeyExistsQ[importCache, cloudFile],
		Return[importCache[{cloudFile, format}]]
	];

	If[!CloudFileExistsQ[cloudFile],
		Message[importCloudFile::NotFound, cloudFile];
		Return[$Failed];
	];

	(* TODO(cmaloney): This requires an extra round trip / request. If we're
		downloading anyways, just use the ContentType header returned as a header
		on the actual download response. *)
	(* Figure out the default based on the content type (aka CloudFileFormat)*)
	If[format === Automatic,
		format=FileFormat[cloudFile];
		If[format === $Failed,
			(* rely on FileFormat to do any Messages*)
			Return[$Failed];
		];
	];
	
	(*
		if the fileFormat is still indeterminate, check for .xlsx files to specify format for MM 12.3.1 on Manifold
		Import[cloudfile (xlsx format)] will timeout, but Import[cloudfile (xlsx format), "XLSX"] will work fine.
		Also check for docx files which are treated as zip files and need special treatment in MM > 12.0.1
	*)
	checkS3Format[format_, _]:=format;
	checkS3Format[Indeterminate, EmeraldCloudFile["AmazonS3", bucket_String, key_String, cloudFileId:(_String | None):None]]:=Module[
		{keyExtension},
		(* find the file extension from the key *)
		keyExtension = FileExtension[key];
		
		(* if the extension is xlsx, update the Format, otherwise leave Indeterminate *)
		Switch[keyExtension,
				"xlsx", "XLSX",
				"docx", "docxFile",
				_, Indeterminate
			
		]
	];
	format = checkS3Format[format, cloudFile];

	(*Download file to temporary path and Import it*)
	path=downloadCloudFile[cloudFile, FileNameJoin[{$TemporaryDirectory, CreateUUID[]}]];
	If[path === $Failed,
		Message[importCloudFile::DownloadFailed, cloudFile];
		Return[$Failed];
	];

	(*Block the $ContextPath during Import as it may add GeneralUtilities` which conflicts with Search*)
	With[
		{contextPath=$ContextPath},
		Block[
			{$ContextPath=contextPath},

			expr=Check[
				Switch[format,
					(* indeterminate, do not specify file type *)
					Indeterminate,
						Import[path],
					(* docx files are treated as Zip files which must be extracted then imported for MM >= 12.0.1 *)
					"docxFile",
						docxFilePaths = ExtractArchive[path, FileNameJoin[{$TemporaryDirectory, CreateUUID[]}]];
						importedDocxFiles = Import/@docxFilePaths;
						(* clean up the extracted files *)
						Quiet[DeleteFile[docxFilePaths]];
						importedDocxFiles,
					(* anything else, import that format specifically *)
					_,
						Import[path, format]
				],
				$Failed
			]
		]
	];

	(*Clean up temporary file*)
	Quiet[DeleteFile[path]];

	(*cache result for subsequent calls*)
	If[expr =!= $Failed,
		AppendTo[importCache, {cloudFile, format} -> expr]
	];
	expr
];

DefineOptions[
	importCloudFile,
	Options :> {
		{Format -> Automatic, Automatic | _String?(MemberQ[$ImportFormats, #]&), "Format to import the EmeraldCloudFile instance as."},
		{Force -> False, True | False, "When True, fetches directly from the web and ignores cached results."}
	}
];



(* ::Subsubsection::Closed:: *)
(*OnLoads*)


OnLoad[
	defineMakeBoxesForECF[];
	initUploadCache[];
	initImportCache[];
];
