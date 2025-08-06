
(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*findSDS*)
DefineUsage[parsePubChem,
	{
		BasicDefinitions -> {
			{"parsePubChem[id]", "data", "downloads the record from PubChem for the specified PubChem 'id'."}
		},
		Input :> {
			{"id", _PubChem, "A PubChem ID."}
		},
		Output :> {
			{"data", _Association, "The association of PubChem data."}
		},
		SeeAlso -> {
			"findSDS",
			"scrapeMoleculeData"
		},
		Author -> {"david.ascough"}
	}
];

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

(* ::Subsection:: *)
(* pathToCloudFilePacket *)
DefineUsage[generateChangePacket,
	{
		BasicDefinitions -> {
			{"generateChangePacket[type, resolvedOptions]", "packet", "generates a change packet of Type 'type' based on 'resolvedOptions'. All multiple fields will have the Replace[] head."},
			{"generateChangePacket[type, resolvedOptions, bool]", "packet", "generates a change packet of Type 'type' based on 'resolvedOptions'. All multiple fields will have Append[] head if 'bool' is True, or Replace[] if 'bool' is False."}
		},
		MoreInformation -> {
			"Function creates a change packet based on the input resolved options.",
			"Options which values are Null, {} or Automatic will be omitted.",
			"Function can have a second output, which is list of options that exists in the resolved options but not in the field definitions. This extra output can be turned on by adding Output -> {Packet, IrrelevantFields} option."
		},
		Input :> {
			{"type", TypeP[], "The type of the change packet we are creating."},
			{"resolvedOptions", {(_Rule| _RuleDelayed)...}, "The list of resolved options from the upstream function's option resolver."},
			{"bool", BooleanP, "A Boolean to determine if all multiple fields should be appended or replaced."}
		},
		Output :> {
			{"packet", PacketP[], "The packet to upload to Constellation."}
		},
		SeeAlso -> {
			"UploadMolecule",
			"validateLocalFile",
			"downloadAndValidateURL",
			"installDefaultUploadFunction"
		},
		Author -> {"hanming.yang"}
	}
];


(* ::Subsection:: *)
(* InstallDefaultUploadFunction *)
DefineUsage[InstallDefaultUploadFunction,
	{
		BasicDefinitions -> {
			{"InstallDefaultUploadFunction[functionName, targetObjectType]", "definedFunction", "defines a generic upload function for creating objects of 'targetObjectType' with name 'functionName'."}
		},
		MoreInformation -> {
			"InstallDefaultUploadFunction is run at SLL load time and programmatically writes the DownValues for the function requested by the inputs.",
			"By default, resolveDefaultUploadFunctionOptions is used as the option resolver which essentially just sanitizes and translates option values into field values.",
			"If no AuxilliaryPacketsFunction is provided, no auxilliary packets are generated by the placeholder generateDefaultUploadFunctionAuxilliaryPackets function.",
			"The function name needs to be added to the manifest manually if intended to be exported.",
			"Function documentation is created automatically.",
			"Function options must be defined separately using DefineOptions.",
			"Unit tests must be defined separately, either manually using DefineTests, or programmatically using InstallIdentityModelTests.",
			"InstallDefaultUploadFunction uses ValidObjectQ tests to perform option and input validation and conflict checking.",
			"The function creates a central listable overload and an additional singleton overload.",
			"The function performs the following actions: Input validation, option resolution, upload packet generation, auxilliary packet generation, voq style error checking."
		},
		Input :> {
			{"functionName", _Symbol, "The symbol to assign the DownValues to - the name of the function."},
			{"targetObjectType", ObjectReferenceP[], "The type of object that this upload function creates or modifies."}
		},
		Output :> {
			{"definedFunction", Null, "The DownValues of the function are defined."}
		},
		SeeAlso -> {
			"InstallOptionsFunction",
			"InstallValidQFunction",
			"UploadSampleModel"
		},
		Author -> {"david.ascough", "thomas"}
	}
];