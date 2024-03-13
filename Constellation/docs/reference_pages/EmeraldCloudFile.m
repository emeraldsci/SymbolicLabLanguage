(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(* EmeraldCloudFileQ *)


DefineUsage[EmeraldCloudFileQ,
	{
		BasicDefinitions ->
			{
				{"EmeraldCloudFileQ[input]", "out", "returns True if 'input' in a properly formatted EmeraldCloudFile, False otherwise."}
			},
		Input :>
			{
				{"input", _, "Input to test if it is an instance of an EmeraldCloudFile."}
			},
		Output :>
			{
				{"out", True | False, "Boolean value representing if the cloud file is formated correctly."}
			},
		Sync -> Automatic,
		SeeAlso -> {
			"UploadCloudFile",
			"ImportCloudFile",
			"displayCloudFile",
			"CloudFileExistsQ"
		},
		Tutorials -> {},
		Author -> {"platform"}
	}];

(* ::Subsubsection::Closed:: *)
(*uploadCloudFile*)


DefineUsage[uploadCloudFile,
	{
		BasicDefinitions ->
			{
				{"uploadCloudFile[filePath]", "cloudFile", "uploads the file given by 'filePath' returns a reference to 'cloudFile'."},
				{"uploadCloudFile[filePath]", "$Failed", "returns $Failed if the file could not be uploaded."},
				{"uploadCloudFile[image]", "cloudFile", "uploads the given image in .jpg format and returns a reference to 'cloudFile'."}
			},
		MoreInformation -> {
			"Caches uploaded file paths. Uses the FileHash of the given file compared to the hash of the cached CloudFile to determine whether to proceed with an upload or return the cached version."
		},
		Input :>
			{
				{"filePath", _String, "Local file path to file to be uploaded."},
				{"image", _Image, "Image to be uploaded."}
			},
		Output :>
			{
				{"cloudFile", _EmeraldCloudFile, "Reference to the uploaded file in the cloud."}
			},
		Sync -> Automatic,
		Behaviors -> {"Listable"},
		SeeAlso -> {
			"CloudFileExistsQ",
			"EmeraldCloudFileQ",
			"importCloudFile",
			"openCloudFile"
		},
		Author -> {"platform", "cheri"}
	}];


(* ::Subsubsection::Closed:: *)
(*CloudFileExistsQ*)
DefineUsage[CloudFileExistsQ,
	{
		BasicDefinitions ->
			{
				{"CloudFileExistsQ[cloudFile]", "out", "returns True if the instance of 'cloudFile' exists in the Emerald cloud and is of a recognized format, False otherwise."}
			},
		Input :>
			{
				{"cloudFile", EmeraldCloudFileP, "Reference to test for existence in the Emerald cloud."}
			},
		Output :>
			{
				{"out", True | False, "Boolean value representing if the cloud file is formated correctly."}
			},
		Sync -> Automatic,
		SeeAlso -> {
			"EmeraldCloudFileQ",
			"UploadCloudFile",
			"ImportCloudFile",
			"OpenCloudFile"
		},
		Author -> {"platform"}
	}];

(* ::Subsubsection::Closed:: *)
(*openCloudFile*)


DefineUsage[openCloudFile,
	{
		BasicDefinitions ->
			{
				{"openCloudFile[cloudFile]", "out", "downloads & opens 'cloudFile'."}
			},
		MoreInformation -> {
			"Downloads the 'cloudFile' to a temporary file in $TemporaryDirectory.",
			"Opens the downloaded file with the default program for that file type (as configured in the host operating system)."
		},
		Input :>
			{
				{"cloudFile", _EmeraldCloudFile, "Reference to a file in the Emerald cloud."}
			},
		Output :> {
			{"out", Null | $Failed, "Either Null if successful or $Failed if something went wrong."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"importCloudFile",
			"uploadCloudFile",
			"CloudFileExistsQ",
			"EmeraldCloudFileQ",
			"SystemOpen"
		},
		Author -> {"platform"}
	}];


(* ::Subsubsection::Closed:: *)
(*importCloudFile*)


DefineUsage[importCloudFile,
	{
		BasicDefinitions ->
			{
				{"importCloudFile[cloudFile]", "expression", "returns the imported 'expression' after downloading 'cloudFile'."},
				{"importCloudFile[cloudFile]", "$Failed", "returns $Failed if an error occurs while importing the 'cloudFile'."}
			},
		Input :>
			{
				{"cloudFile", EmeraldCloudFileP, "Reference to test for existence in the Emerald cloud."}
			},
		Output :>
			{
				{"expression", _, "Imported Mathematica expression."}
			},
		Sync -> Automatic,
		Behaviors -> {"Caching"},
		SeeAlso -> {
			"EmeraldCloudFileQ",
			"CloudFileExistsQ",
			"uploadCloudFile",
			"openCloudFile"
		},
		Author -> {"platform"}
	}];


(* ::Subsubsection::Closed:: *)
(*downloadCloudFile*)


DefineUsage[downloadCloudFile,
	{
		BasicDefinitions -> {
			{"downloadCloudFile[cloudFile, targetPath]", "path", "returns the local 'path' to the file after downloading 'cloudFile' to the specified 'targetPath'."},
			{"downloadCloudFile[cloudFile, targetPath]", "$Failed", "returns $Failed if an error occurs while downloading the 'cloudFile'."}
		},
		MoreInformation -> {
			"If given a directory as a path, uses part of the cloud file URL to construct the full path to the resulting file."
		},
		Input :> {
			{"cloudFile", EmeraldCloudFileP, "An EmeraldCloudFile reference to be downloaded."},
			{"targetPath", _String, "Local directory path or file path to save the 'cloudFile' in."}
		},
		Output :> {
			{"path", _String, "Local file path 'cloudFile' was downloaded to."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"EmeraldCloudFileQ",
			"CloudFileExistsQ",
			"uploadCloudFile",
			"openCloudFile",
			"importCloudFile"
		},
		Author -> {"platform"}
	}];

(* ::Subsubsection::Closed:: *)
(*FilePathP*)

DefineUsage[FilePathP,
	{
		BasicDefinitions -> {
			{"FilePathP", None, "matches a string which represents an absolute file path on Windows and UNIX / OSX system."}
		},
		SeeAlso -> {
			"MFileP",
			"ContextP"
		},
		Author -> {"platform", "Yang"}
	}];

(* ::Subsubsection::Closed:: *)
(* EmeraldFileP *)

DefineUsage[EmeraldFileP, {
	BasicDefinitions -> {
		{"EmeraldFileP", "pattern", "a pattern for matching either File[FilePathP] or EmeraldCloudFile."}
	},
	Input :> {
	},
	Output :> {
		{"pattern", _PatternTest, "A pattern."}
	},
	Sync -> Automatic,
	SeeAlso -> {"EmeraldFileQ", "EmeraldCloudFileQ"},
	Author -> {"platform"}
}];

(* ::Subsubsection::Closed:: *)
(* EmeraldFileQ *)

DefineUsage[EmeraldFileQ, {
	BasicDefinitions -> {
		{"EmeraldFileQ[file]", "bool", "returns True if the 'file' matches either a File[FilePathP] or EmeraldCloudFile."}
	},
	Input :> {
		{"file", _, "An expression to check."}
	},
	Output :> {
		{"bool", True | False, "True or False."}
	},
	Sync -> Automatic,
	SeeAlso -> {"UploadCloudFile", "EmeraldCloudFileQ"},
	Author -> {"platform"}
}];

(* ::Subsubsection::Closed:: *)
(* EmeraldCloudFileP *)

DefineUsage[EmeraldCloudFileP, {
	BasicDefinitions -> {
		{"EmeraldCloudFileP", "pattern", "a pattern for matching EmeraldCloudFile."}
	},
	Input :> {
	},
	Output :> {
		{"pattern", _PatternTest, "A pattern."}
	},
	Sync -> Automatic,
	SeeAlso -> {"EmeraldCloudFileQ", "EmeraldFileQ"},
	Author -> {"platform"}
}];

(* ::Subsubsection::Closed:: *)
(* EmeraldCloudFileQ *)

DefineUsage[EmeraldCloudFileQ, {
	BasicDefinitions -> {
		{"EmeraldCloudFileQ[file]", "bool", "returns True if the 'file' matches an EmeraldCloudFile."}
	},
	Input :> {
		{"file", _, "An expression to check."}
	},
	Output :> {
		{"bool", True | False, "True or False."}
	},
	Sync -> Automatic,
	SeeAlso -> {"DeleteDuplicates", "Upload", "Download"},
	Author -> {"platform"}
}];

(* ::Subsubsection::Closed:: *)
(* emeraldFileFormatP *)

DefineUsage[emeraldFileFormatP, {
	BasicDefinitions -> {
		{"emeraldFileFormatP[formatPattern]", "pattern", "given a 'formatPattern' which specifies certain types of EmeraldCloudFile, return a 'pattern' to match a File or EmeraldCloudFile of that type."}
	},
	Input :> {
		{"formatPattern", formatsP, "A file format pattern, for example \"JPEG\" | \"PNG\", to match one or more of the supported formats."}
	},
	Output :> {
		{"pattern", _PatternTest, "A pattern matching any EmeraldCloudFile for which FileFormat matches that 'formatPattern'."}
	},
	Sync -> Automatic,
	SeeAlso -> {"emeraldFileFormatQ", "FileFormat"},
	Author -> {"platform"}
}];

(* ::Subsubsection::Closed:: *)
(* emeraldFileFormatQ *)

DefineUsage[emeraldFileFormatQ, {
	BasicDefinitions -> {
		{"emeraldFileFormatQ[file, formatPattern]", "bool", "returns True if the 'file' matches the 'formatPattern' specifying certain types of EmeraldCloudFile."}
	},
	Input :> {
		{"file", _, "An expression to check."},
		{"formatPattern", formatsP, "A file format pattern, for example \"JPEG\" | \"PNG\", to match one or more of the supported formats."}
	},
	Output :> {
		{"bool", True | False, "True or False."}
	},
	Sync -> Automatic,
	SeeAlso -> {"FileFormat", "EmeraldCloudFileQ", "EmeraldFileQ"},
	Author -> {"platform"}
}];

(* ::Subsubsection::Closed:: *)
(* ImageFileP *)

DefineUsage[ImageFileP, {
	BasicDefinitions -> {
		{"ImageFileP", "pattern", "a pattern for matching any EmeraldCloudFile which is an image."}
	},
	Input :> {
	},
	Output :> {
		{"pattern", _PatternTest, "A pattern."}
	},
	Sync -> Automatic,
	SeeAlso -> {"ImageFileQ", "PDFFileQ"},
	Author -> {"platform"}
}];

(* ::Subsubsection::Closed:: *)
(* ImageFileQ *)

DefineUsage[ImageFileQ, {
	BasicDefinitions -> {
		{"ImageFileQ[file]", "bool", "returns True if the 'file' matches an EmeraldCloudFile which is an image."}
	},
	Input :> {
		{"file", _, "An expression to check."}
	},
	Output :> {
		{"bool", True | False, "True or False."}
	},
	Sync -> Automatic,
	SeeAlso -> {"PDFFileQ", "EmeraldCloudFileQ", "EmeraldFileQ"},
	Author -> {"platform"}
}];

(* ::Subsubsection::Closed:: *)
(* PDFFileP *)

DefineUsage[PDFFileP, {
	BasicDefinitions -> {
		{"PDFFileP", "pattern", "a pattern for matching an EmeraldCloudFile which is a PDF."}
	},
	Input :> {
	},
	Output :> {
		{"pattern", _PatternTest, "A pattern."}
	},
	Sync -> Automatic,
	SeeAlso -> {"ImageFileQ", "PDFFileQ"},
	Author -> {"platform"}
}];

(* ::Subsubsection::Closed:: *)
(* PDFFileQ *)

DefineUsage[PDFFileQ, {
	BasicDefinitions -> {
		{"PDFFileQ[file]", "bool", "returns True if the 'file' matches an EmeraldCloudFile which is a PDF."}
	},
	Input :> {
		{"file", _, "An expression to check."}
	},
	Output :> {
		{"bool", True | False, "True or False."}
	},
	Sync -> Automatic,
	SeeAlso -> {"ImageFileQ", "EmeraldCloudFileQ", "EmeraldFileQ"},
	Author -> {"platform"}
}];
