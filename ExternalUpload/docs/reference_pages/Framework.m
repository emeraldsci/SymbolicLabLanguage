
(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*findSDS*)
DefineUsage[findSDS,
	{
		BasicDefinitions -> {
			{"findSDS[identifier]", "output", "uses internet services to locate a pdf SDS file for the compound, 'identifier'."}
		},
		MoreInformation -> {
			"Performs a search on the Chemical Safety website to identify potential SDS files for the species with the specified identifier."
		},
		Input :> {
			{"identifier", Alternatives[CASNumberP, _String], "A CAS number or molecule name."}
		},
		Output :> {
			{"output", Alternatives[URLP, _File, ObjectP[Object[EmeraldCloudFile]]], "The URL to a pdf SDS, local filepath to a downloaded pdf, or uploaded cloud file reference."}
		},
		SeeAlso -> {
			"UploadMolecule",
			"parsePubChem"
		},
		Author -> {"david.ascough"}
	}
];


(* ::Subsection:: *)
(* downloadAndValidateURL *)
DefineUsage[downloadAndValidateURL,
	{
		BasicDefinitions -> {
			{"downloadAndValidateURL[url, fileNameIdentifier, validationFunction]", "localFile", "downloads the 'url' to a temporary file based on name 'fileNameIdentifier' and returns the file if it passes validation."}
		},
		MoreInformation -> {
			"Performs an HTTP request to download the file described by URL to a local file with a unique name based on fileNameIdentifier.",
			"validationFunction is then run on the downloaded file. If the validation function returns True, the valid file is returned, otherwise $Failed is returned.",
			"Function memoizes so that download and validation only occurs once."
		},
		Input :> {
			{"url", URLP, "The path to the internet resource of interest."},
			{"fileNameIdentifier", _String, "A string with name stem and extension to base temporary file name on, such as sds.pdf."},
			{"validationFunction", _Function, "A function to run on the downloaded file that returns True for a valid file."}
		},
		Output :> {
			{"localFile", Alternatives[_File, $Failed], "The file object of the downloaded file."}
		},
		SeeAlso -> {
			"UploadMolecule",
			"parsePubChem",
			"findSDS",
			"validateLocalFile"
		},
		Author -> {"david.ascough"}
	}
];

(* ::Subsection:: *)
(* validateLocalFile *)
DefineUsage[validateLocalFile,
	{
		BasicDefinitions -> {
			{"validateLocalFile[filepath, validationFunction]", "validatedFile", "returns the file at 'filepath' if it passes validation."}
		},
		MoreInformation -> {
			"If the validation function returns True, the valid file is returned, otherwise $Failed is returned.",
			"Function memoizes so that validation only occurs once."
		},
		Input :> {
			{"filepath", FilePathP, "The path to the local file of interest."},
			{"validationFunction", _Function, "A function to run on the file that returns True for a valid file."}
		},
		Output :> {
			{"validatedFile", Alternatives[_File, $Failed], "The file object of the input file."}
		},
		SeeAlso -> {
			"UploadMolecule",
			"parsePubChem",
			"findSDS",
			"downloadAndValidateURL"
		},
		Author -> {"david.ascough"}
	}
];

(* ::Subsection:: *)
(* pathToCloudFilePacket *)
DefineUsage[pathToCloudFilePacket,
	{
		BasicDefinitions -> {
			{"pathToCloudFilePacket[filepath]", "cloudFilePacket", "uploads the file at 'filepath' to AWS and returns a packet for uploading the corresponding cloud file to Constellation."}
		},
		MoreInformation -> {
			"If the validation function returns True, the valid file is returned, otherwise $Failed is returned.",
			"Function memoizes so that upload of the cloud file to AWS only occurs once."
		},
		Input :> {
			{"filepath", FilePathP, "The path to the local file of interest."}
		},
		Output :> {
			{"cloudFilePacket", PacketP[], "The packet to upload the cloud file to Constellation."}
		},
		SeeAlso -> {
			"UploadMolecule",
			"validateLocalFile",
			"downloadAndValidateURL"
		},
		Author -> {"david.ascough"}
	}
];