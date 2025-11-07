
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
			{"downloadAndValidateURL[url, fileNameIdentifier, validationFunction]", "localFile", "downloads the 'url' to a temporary file based on name 'fileNameIdentifier', memoizes, and returns the file if it passes validation."},
			{"downloadAndValidateURL[url, fileNameIdentifier]", "localFile", "downloads the 'url' to a temporary file based on name 'fileNameIdentifier', memoizes, and returns the file."},
			{"downloadAndValidateURL[url, type, fieldName]", "localFile", "downloads the 'url' to a temporary file, memoizes, and returns the file if it passes validation based on the field provided."}
		},
		MoreInformation -> {
			"Performs an HTTP request to download the file described by URL to a local file with a unique name based on fileNameIdentifier.",
			"validationFunction is then run on the downloaded file. If the validation function returns True, the valid file is returned, otherwise $Failed is returned.",
			"Function memoizes so that download and validation only occurs once.",
			"If a type and fieldName are provided, the standard validation function is looked up in fileValidationFunctions."
		},
		Input :> {
			{"url", URLP, "The path to the internet resource of interest."},
			{"fileNameIdentifier", _String, "A string with name stem and extension to base temporary file name on, such as sds.pdf."},
			{"validationFunction", _Symbol, "A function to run on the downloaded file that returns True for a valid file."},
			{"type", Alternatives[TypeP[], All], "The type of object this file will be uploaded to. All means any type."},
			{"fieldName", _Symbol, "The field name that this file will be uploaded to."}
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
			{"validateLocalFile[filepath, validationFunction]", "validatedFile", "returns the file at 'filepath' if it passes validation."},
			{"validateLocalFile[filepath, type, fieldName]", "validatedFile", "returns the file at 'filepath' if it passes validation based on the field provided."}
		},
		MoreInformation -> {
			"If the validation function returns True, the valid file is returned, otherwise $Failed is returned.",
			"Function memoizes so that validation only occurs once.",
			"If a type and fieldName are provided, the standard validation function is looked up in fileValidationFunctions."
		},
		Input :> {
			{"filepath", FilePathP, "The path to the local file of interest."},
			{"validationFunction", _Symbol, "A function to run on the file that returns True for a valid file."},
			{"type", Alternatives[TypeP[], All], "The type of object this file will be uploaded to. All means any type."},
			{"fieldName", _Symbol, "The field name that this file will be uploaded to."}
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
(* generateChangePackets *)
DefineUsage[generateChangePackets,
	{
		BasicDefinitions -> {
			{"generateChangePackets[type, resolvedOptions]", "packets", "generates change packets for uploading an object of Type 'type' based on 'resolvedOptions'. All multiple fields will have the Replace[] head. The first packet in the list is the packet for uploading the object of the specified type, and subsequent packets are required auxilliary upload packets."},
			{"generateChangePackets[type, resolvedOptions, bool]", "packets", "generates change packets for uploading an object of Type 'type' based on 'resolvedOptions'. All multiple fields will have Append[] head if 'bool' is True, or Replace[] if 'bool' is False."}
		},
		MoreInformation -> {
			"Function creates change packets based on the input resolved options. The first packet is always the primary packet for uploading the core object of the specified type. The remainder of the packets are associated packets required for uploading the object.",
			"If EmeraldCloudFile fields contain a URL or file path, this function will download the file (in the case of the URL), validate the file and then upload it to AWS. The packet(s) required to upload the Constellation object(s) are returned by this function.",
			"If file validation fails, $Failed is returned as the field value. File download, validation and upload are memoized, so subsequent calls of this function are fast.",
			"Options which values are Null, {} or Automatic will be omitted.",
			"Function can have a second output, which is list of options that exists in the resolved options but not in the field definitions. This extra output can be turned on by adding Output -> {Packet, IrrelevantFields} option."
		},
		Input :> {
			{"type", TypeP[], "The type of the change packet we are creating."},
			{"resolvedOptions", {(_Rule| _RuleDelayed)...}, "The list of resolved options from the upstream function's option resolver."},
			{"bool", BooleanP, "A Boolean to determine if all multiple fields should be appended or replaced."}
		},
		Output :> {
			{"packets", {PacketP[]..}, "The packets to upload to Constellation."}
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
(* stripChangePacket *)
DefineUsage[stripChangePacket,
	{
		BasicDefinitions -> {
			{"stripChangePacket[changePacket]", "pseudoDownloadPacket", "strips upload related field modifiers from the 'changePacket', adds empty fields and returns the 'pseudoDownloadPacket' with the information formatted as though the whole object was downloaded from Constellation."}
		},
		MoreInformation -> {
			"If the object already exists in Constellation, and the changePacket doesn't include all fields, the existing packet must be provided using the ExistingPacket option.",
			"If the existing packet is not provided, any missing fields will be populated with Null/{}."
		},
		Input :> {
			{"changePacket", _Association, "A packet formatted for upload."}
		},
		Output :> {
			{"pseudoDownloadPacket", PacketP[], "A packet for the specified object emulating the format of a Constellation download."}
		},
		SeeAlso -> {
			"generateChangePackets",
			"UploadMolecule",
			"installDefaultUploadFunction"
		},
		Author -> {"david.ascough", "thomas"}
	}
];

(* ::Subsection:: *)
(* executeDefaultUploadFunction *)
DefineUsage[executeDefaultUploadFunction,
	{
		BasicDefinitions -> {
			{"executeDefaultUploadFunction[type, options, label]", "{objects, packets}", "generates change 'packets' as well as 'objects' ID for uploading new objects of Type 'type' based on 'options'. Function will use external upload functions that's relevant to the requested 'type' to construct fields for the new objects."},
			{"executeDefaultUploadFunction[type, options, label, Object]", "objects", "output the 'objects' ID for uploading new objects of Type 'type' based on 'options'. Function will use external upload functions that's relevant to the requested 'type' to construct fields for the new objects."},
			{"executeDefaultUploadFunction[type, options, label, Packet]", "packets", "generates change 'packets' for uploading new objects of Type 'type' based on 'options'. Function will use external upload functions that's relevant to the requested 'type' to construct fields for the new objects."}
		},
		MoreInformation -> {
			"Function output the packets created by the corresponding upload functions according to the requested 'type' and 'options'.",
			"Function also extract and outputs the Object(s) of the packets.",
			"The packets created are not uploaded to Constellation.",
			"When running upload functions, executeDefaultUploadFunction always pass in Strict -> False.",
			"Function is memoized."
		},
		Input :> {
			{"type", ListableP[TypeP[]], "The type of the packet(s) this function is creating."},
			{"options", {(_Rule| _RuleDelayed)...}, "The list of resolved options to create the new objects. These options does not have to be complete."},
			{"label", BooleanP, "A string label which describes what kind of object(s) this function is creating."}
		},
		Output :> {
			{"packets", {PacketP[]..}, "The packets to upload to Constellation."}
		},
		SeeAlso -> {
			"UploadProduct",
			"generateChangePackets",
			"installDefaultUploadFunction"
		},
		Author -> {"hanming.yang"}
	}
];


(* ::Subsection:: *)
(* installDefaultUploadFunction *)
DefineUsage[installDefaultUploadFunction,
	{
		BasicDefinitions -> {
			{"installDefaultUploadFunction[functionName, targetObjectType]", "definedFunction", "defines a generic upload function for creating objects of 'targetObjectType' with name 'functionName'."}
		},
		MoreInformation -> {
			"installDefaultUploadFunction is run at SLL load time and programmatically writes the DownValues for the function requested by the inputs.",
			"By default, resolveDefaultUploadFunctionOptions is used as the option resolver which essentially just sanitizes and translates option values into field values.",
			"If no AuxilliaryPacketsFunction is provided, no auxilliary packets are generated by the placeholder generateDefaultUploadFunctionAuxilliaryPackets function.",
			"The function name needs to be added to the manifest manually if intended to be exported.",
			"Function documentation is created automatically.",
			"Function options must be defined separately using DefineOptions.",
			"Unit tests must be defined separately, either manually using DefineTests, or programmatically using InstallIdentityModelTests.",
			"installDefaultUploadFunction uses ValidObjectQ tests to perform option and input validation and conflict checking.",
			"The function creates a central listable overload and an additional singleton overload.",
			"The function performs the following actions: Input validation, option resolution, upload packet generation, auxilliary packet generation, voq style error checking.",
			"DuplicateObjectChecks option defines what happens when a duplicate object is found in the database, by supplying the fields to check and the actions to take. Actions include i) Error: Hard error after options resolution ii) Warning: Soft warning that potential duplicate exists ii) Modification: Automatically switch to modifying the existing object rather than creating a new one."
		},
		Input :> {
			{"functionName", _Symbol, "The symbol to assign the DownValues to - the name of the function."},
			{"targetObjectType", TypeP[], "The type of object that this upload function creates or modifies."}
		},
		Output :> {
			{"definedFunction", Null, "The DownValues of the function are defined."}
		},
		SeeAlso -> {
			"installDefaultOptionsFunction",
			"installDefaultValidQFunction",
			"UploadSampleModel"
		},
		Author -> {"david.ascough", "thomas"}
	}
];


(* ::Subsection:: *)
(* installDefaultOptionsFunction *)
DefineUsage[installDefaultOptionsFunction,
	{
		BasicDefinitions -> {
			{"installDefaultOptionsFunction[functionName, targetObjectType]", "definedFunction", "defines a generic options sister function for the function 'functionName', where 'functionName' is used to create objects of type 'targetObjectType'."}
		},
		MoreInformation -> {
			"installDefaultOptionsFunction is run at SLL load time and programmatically writes the DownValues for the sister function requested by the inputs.",
			"The function is created with name, `functionName <> \"Options\"`, which needs to be added to the manifest manually if intended to be exported.",
			"Function documentation and options are created automatically.",
			"Unit tests must be defined separately, either manually using DefineTests, or programmatically using InstallIdentityModelTests."
		},
		Input :> {
			{"functionName", _Symbol, "The symbol to create an options sister function for. The options function will have the same name with \"Options\" appended."},
			{"targetObjectType", TypeP[], "The type of object that the upload function creates or modifies."}
		},
		Output :> {
			{"definedFunction", Null, "The DownValues of the sister function are defined."}
		},
		SeeAlso -> {
			"installDefaultUploadFunction",
			"installDefaultValidQFunction",
			"UploadSampleModel"
		},
		Author -> {"david.ascough", "thomas"}
	}
];



(* ::Subsection:: *)
(* installDefaultValidQFunction *)
DefineUsage[installDefaultValidQFunction,
	{
		BasicDefinitions -> {
			{"installDefaultValidQFunction[functionName, targetObjectType]", "definedFunction", "defines a generic validQ sister function for the function 'functionName', where 'functionName' is used to create objects of type 'targetObjectType'."}
		},
		MoreInformation -> {
			"installDefaultValidQFunction is run at SLL load time and programmatically writes the DownValues for the sister function requested by the inputs.",
			"The function is created with name, `\"Valid\" <> functionName <> \"Q\"`, which needs to be added to the manifest manually if intended to be exported.",
			"Function documentation and options are created automatically.",
			"Unit tests must be defined separately, either manually using DefineTests, or programmatically using InstallIdentityModelTests."
		},
		Input :> {
			{"functionName", _Symbol, "The symbol to create a validQ sister function for. The validQ function will have the same name with \"Valid\" prepended and \"Q\" appended."},
			{"targetObjectType", TypeP[], "The type of object that the upload function creates or modifies."}
		},
		Output :> {
			{"definedFunction", Null, "The DownValues of the sister function are defined."}
		},
		SeeAlso -> {
			"installDefaultUploadFunction",
			"installDefaultOptionsFunction",
			"UploadSampleModel"
		},
		Author -> {"david.ascough", "thomas"}
	}
];

(* ::Subsection:: *)
(* installDefaultVerificationFunction *)
DefineUsage[installDefaultVerificationFunction,
	{
		BasicDefinitions -> {
			{"installDefaultVerificationFunction[functionName, targetObjectType]", "definedFunction", "defines a generic verification sister function for the function 'functionName', where 'functionName' is used to create objects of type 'targetObjectType'."},
			{"installDefaultVerificationFunction[functionName, inputName, targetObjectTypes]", "definedFunction", "defines a generic verification sister function for the function 'functionName', where 'functionName' is used to create objects of type(s) 'targetObjectTypes', and the allowed types can be generally described as 'inputName'."}
		},
		MoreInformation -> {
			"installDefaultVerificationFunction is run at SLL load time and programmatically writes the DownValues for the sister function requested by the inputs.",
			"The created function name is based on the input function. For input function with name UploadXX, the resulted function name is UploadVerifiedXX. The symbol needs to be added to the manifest manually if intended to be exported.",
			"Function documentation and options are created automatically.",
			"Unit tests must be defined separately, either manually using DefineTests, or programmatically using InstallIdentityModelTests."
		},
		Input :> {
			{"functionName", _Symbol, "The symbol to create a verification sister function for. The verification function will have the same name with \"Verified\" inserted between \"Upload\" or \"Define\" and the rest of function name."},
			{"targetObjectType", TypeP[], "The type of object that the upload function creates or modifies."},
			{"inputName", _String, "A short text describing the 'targetObjectTypes', which is the type(s) of object that the upload function creates or modifies."},
			{"targetObjectTypes", ListableP[TypeP[]], "The singleton or list of type(s) of object that the upload function creates or modifies."}
		},
		Output :> {
			{"definedFunction", Null, "The DownValues of the sister function are defined."}
		},
		SeeAlso -> {
			"installDefaultUploadFunction",
			"installDefaultOptionsFunction",
			"UploadSampleModel",
			"installDefaultValidQFunction"
		},
		Author -> {"hanming.yang"}
	}
];

(* ::Subsection:: *)
(* RunOptionValidationTests *)
DefineUsage[RunOptionValidationTests,
	{
		BasicDefinitions -> {
			{"RunOptionValidationTests[packet]", "test results", "Runs a group of tests for the 'packet' similar to ValidObjectQ, but with slight modifications controlled by the options."},
			{"RunOptionValidationTests[options, object]", "test results", "Construct a packet from the supplied 'options' and runs a group of tests similar to ValidObjectQ, but with slight modifications controlled by the options."}
		},
		MoreInformation -> {
			"This function is defined in additional to the regular ValidObjectQ -> RunValidQTest -> RunUnitTest framework.",
			"The main goal of this function is to serve as a universal error-checking function in the external UploadXX functions, instead of doing that individually in the option resolver.",
			"The regular ValidObjectQ function can also do the checks, but the error message and test descriptions can be hard to understand for external users.",
			"Note, this function does not do any Download. Therefore, original packet must be included in the Cache option, otherwise the function will always think we are creating a brand-new object."
		},
		Input :> {
			{"packet", PacketP[], "The new or modified packet to check."},
			{"options", {_Rule...}, "The resolved options from the UploadXX function option resolver."},
			{"object", (TypeP[] | ObjectP[]), "The Type of the object UploadXX function is attempting to create, or the existing object it's trying to modify."}
		},
		Output :> {
			{"test results", Alternatives[BooleanP, _EmeraldTestSummary], "The result of the ValidObjectQ tests."}
		},
		SeeAlso -> {
			"UploadMolecule",
			"UploadContainerModel"
		},
		Author -> {"hanming.yang"}
	}
];



(* ::Subsection:: *)
(*scrapeMoleculeData*)
DefineUsage[scrapeMoleculeData,
	{
		BasicDefinitions -> {
			{"scrapeMoleculeData[identifiers]", "data", "parses the provided molecular 'identifiers' and downloads basic information for the molecule from the PubChem database."},
			{"scrapeMoleculeData[identifierLists]", "data", "for each list of identifiers in 'identifierLists', tries the identifiers in turn and downloads basic information for the molecule from the PubChem database using the first successful identifier."}
		},
		MoreInformation -> {
			"If an individual identifier, or a list of identifiers if provided, each is treated as a separate molecule and an index matching result is returned.",
			"If a list of lists is provided, each of the inner lists represents a list of identifiers for the *same* molecule, that will be tried in turn. The first successful identifier will be used to populate the output, which index matches the outer list."
		},
		Input :> {
			{
				"identifiers",
				ListableP[Alternatives[
					MoleculeP,
					_PubChem,
					InChIP,
					InChIKeyP,
					CASNumberP,
					ThermoFisherURLP,
					MilliporeSigmaURLP,
					_String
				]],
				"Identifiers for a list of molecules."
			},
			{
				"identifierLists",
				{
					ListableP[Alternatives[
						MoleculeP,
						_PubChem,
						InChIP,
						InChIKeyP,
						CASNumberP,
						ThermoFisherURLP,
						MilliporeSigmaURLP,
						_String
					]]..
				},
				"A list of identifiers for a list of molecules."
			}
		},
		Output :> {
			{"data", ListableP[_Association], "Basic molecular information for the molecules corresponding to the supplied identifiers."}
		},
		SeeAlso -> {
			"UploadMolecule",
			"findSDS"
		},
		Author -> {"david.ascough"}
	}
];
