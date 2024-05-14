(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Emerald Cloud Files",
	Abstract -> "Emerald Cloud Files are files such as images or PDFs that are stored on the cloud in Constellation and referred to within fields of Constellation objects, such as say the a PSF file containing the materials safety data sheet (MSDS) in pdf form of a given chemical which might reside within the MSDS field of a constellation object representing that chemical. Because they live on the cloud, Emerald Cloud Files can be accessed from any local computer provided one has valid user credentials to the ECL.",
	Reference -> {

		"Download Information from Cloud Files" -> {
			{DownloadCloudFile, "Given an Object[EmeraldCloudFile], downloads the contents of that file to the local computer's hard drive."},
			{ImportCloudFile, "Given an Object[EmeraldCloudFile], returns the contents of that file."},
			{OpenCloudFile, "Given an Object[EmeraldCloudFile], opens that file using the local computers system."},
			{ValidRenameCloudFileQ,"Checks if new names for cloud files are valid."},
			{EmeraldCloudFileQ, "Checks if the specified file or the Amazon S3 address is a valid EmeraldCloudFile."},
			{CloudFileExistsQ, "Checks if the specified file exists in the Emerald cloud and are of a recognized format."}
		},
		
		"Generating New Cloud Files" -> {
			{EmeraldFileQ, "Checks if a given object is a file stored on the cloud or stored locally."},
			{UploadCloudFile, "Uploads a new file to be stored as an Object[EmeraldCloudFile]."},
			{ValidUploadCloudFileQ, "Checks if the provided input and options are valid for calling UploadCloudFile function."}
		}

	},
	RelatedGuides -> {
		GuideLink["WorkingWithConstellationObjects"],
		GuideLink["ObjectOntology"],
		GuideLink["IncludingLiteratureReferences"],
		GuideLink["ConstellationUtilityFunctions"]
	}
]
