(* ::Subsubsection::Closed:: *)
(*UploadCloudFile*)

DefineUsage[UploadCloudFile,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadCloudFile[file]", "cloudFile"},
				Description -> "uploads the file given by 'file' and creates 'cloudFile'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "file",
							Description -> "Local file path to file to be uploaded or an image to be uploaded.",
							Widget -> Alternatives[
								Widget[Type -> String, Pattern :> _String, Size -> Line],
								Widget[<|
									Type -> Expression,
									Pattern :> _Image,
									Size -> Line,
									PatternTooltip -> "Expression must match the pattern: _Image.",
									BoxText -> "Image to upload"
								|>],
								Widget[<|
									Type -> Expression,
									Pattern :> _File,
									Size -> Line,
									PatternTooltip -> "Expression must match the pattern: _File.",
									BoxText -> "Local file path to file, wrapped in the File head."
								|>]
							],
							Expandable -> False
						},
						IndexName -> "uploads"
					]
				},
				Outputs :> {
					{
						OutputName -> "cloudFile",
						Description -> "The object that contains the uploaded file or image, file name, and other information about the file.",
						Pattern :> ObjectP[Object[EmeraldCloudFile]]
					}
				}
			}
		},
		SeeAlso -> {
			"ImportCloudFile",
			"OpenCloudFile",
			"DownloadCloudFile",
			"UploadCloudFileOptions",
			"ValidUploadCloudFileQ"
		},
		Tutorials -> {"EmeraldCloudFiles"},
		Author -> {"scicomp", "brad", "thomas"}
	}
];

DefineUsage[ValidUploadCloudFileQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidUploadCloudFileQ[file]", "boolean"},
				Description -> "checks whether the provided input and options are valid for calling UploadCloudFile.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "file",
							Description -> "Local file path to file to be uploaded or an image to be uploaded.",
							Widget -> Alternatives[
								Widget[Type -> String, Pattern :> _String, Size -> Line],
								Widget[<|
									Type -> Expression,
									Pattern :> _Image,
									Size -> Line,
									PatternTooltip -> "Expression must match the pattern: _Image.",
									BoxText -> "Image to upload"
								|>]
							],
							Expandable -> False
						},
						IndexName -> "uploads"
					]
				},
				Outputs :> {
					{
						OutputName -> "boolean",
						Description -> "Whether or not the UploadCloudFile call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary | BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ImportCloudFile",
			"OpenCloudFile",
			"DownloadCloudFile",
			"UploadCloudFile",
			"UploadCloudFileOptions"
		},
		Tutorials -> {"EmeraldCloudFiles"},
		Author -> {"scicomp", "brad", "thomas"}
	}
];

DefineUsage[UploadCloudFilePreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadCloudFilePreview[file]", "preview"},
				Description -> "returns Null, as there is no graphical preview of the output of UploadCloudFile.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "file",
							Description -> "Local file path to file to be uploaded or an image to be uploaded.",
							Widget -> Alternatives[
								Widget[Type -> String, Pattern :> _String, Size -> Line],
								Widget[<|
									Type -> Expression,
									Pattern :> _Image,
									Size -> Line,
									PatternTooltip -> "Expression must match the pattern: _Image.",
									BoxText -> "Image to upload"
								|>]
							],
							Expandable -> False
						},
						IndexName -> "uploads"
					]
				},
				Outputs :> {
					{
						OutputName -> "preview",
						Description -> "Graphical preview representing the output of UploadCloudFile.  This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"ImportCloudFile",
			"OpenCloudFile",
			"DownloadCloudFile",
			"UploadCloudFile",
			"UploadCloudFileOptions",
			"ValidUploadCloudFileQ"
		},
		Tutorials -> {"EmeraldCloudFiles"},
		Author -> {"scicomp", "brad", "thomas"}
	}
];

DefineUsage[UploadCloudFileOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadCloudFileOptions[file]", "resolvedOptions"},
				Description -> "returns the resolved options from calling UploadCloudFile with the given inputs and options.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "file",
							Description -> "Local file path to file to be uploaded or an image to be uploaded.",
							Widget -> Alternatives[
								Widget[Type -> String, Pattern :> _String, Size -> Line],
								Widget[<|
									Type -> Expression,
									Pattern :> _Image,
									Size -> Line,
									PatternTooltip -> "Expression must match the pattern: _Image.",
									BoxText -> "Image to upload"
								|>]
							],
							Expandable -> False
						},
						IndexName -> "uploads"
					]
				},
				Outputs :> {
					{
						OutputName -> "resolvedOptions",
						Description -> "Resolved options when UploadCloudFile is called on the inputs.",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		SeeAlso -> {
			"ImportCloudFile",
			"OpenCloudFile",
			"DownloadCloudFile",
			"UploadCloudFile",
			"ValidUploadCloudFileQ"
		},
		Tutorials -> {"EmeraldCloudFiles"},
		Author -> {"scicomp", "brad", "thomas"}
	}
];


(* ::Subsubsection::Closed:: *)
(*RenameCloudFile*)

DefineUsage[RenameCloudFile,
	{
		BasicDefinitions -> {
			{
				Definition -> {"RenameCloudFile[cloudFile, newName]", "cloudFile"},
				Description -> "renames the 'cloudFile' to have the name 'newName'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "cloudFile",
							Description -> "The cloud file to rename.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[Object[EmeraldCloudFile]]
							],
							Expandable -> False
						},
						{
							InputName -> "newName",
							Description -> "The name to give the cloud file.",
							Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line],
							Expandable -> True
						},
						IndexName -> "uploads"
					]
				},
				Outputs :> {
					{
						OutputName -> "cloudFile",
						Description -> "The cloud file that was renamed.",
						Pattern :> ObjectP[Object[EmeraldCloudFile]]
					}
				}
			}
		},
		SeeAlso -> {
			"UploadCloudFile",
			"ImportCloudFile",
			"OpenCloudFile",
			"DownloadCloudFile",
			"RenameCloudFileOptions",
			"ValidRenameCloudFileQ"
		},
		Tutorials -> {"EmeraldCloudFiles"},
		Author -> {"scicomp", "brad", "thomas"}
	}
];


DefineUsage[ValidRenameCloudFileQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidRenameCloudFileQ[cloudFile, newName]", "boolean"},
				Description -> "checks whether the provided input and options are valid for calling RenameCloudFile.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "cloudFile",
							Description -> "The cloud file to rename.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[Object[EmeraldCloudFile]]
							],
							Expandable -> False
						},
						{
							InputName -> "newName",
							Description -> "The name to give the cloud file.",
							Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line],
							Expandable -> True
						},
						IndexName -> "uploads"
					]
				},
				Outputs :> {
					{
						OutputName -> "boolean",
						Description -> "Whether or not the RenameCloudFile call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary | BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ImportCloudFile",
			"OpenCloudFile",
			"DownloadCloudFile",
			"RenameCloudFile",
			"RenameCloudFileOptions"
		},
		Tutorials -> {"EmeraldCloudFiles"},
		Author -> {"scicomp", "brad", "thomas"}
	}
];


DefineUsage[RenameCloudFilePreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"RenameCloudFilePreview[cloudFile, newName]", "preview"},
				Description -> "returns Null, as there is no graphical preview of the output of RenameCloudFile.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "cloudFile",
							Description -> "The cloud file to rename.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[Object[EmeraldCloudFile]]
							],
							Expandable -> False
						},
						{
							InputName -> "newName",
							Description -> "The name to give the cloud file.",
							Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line],
							Expandable -> True
						},
						IndexName -> "uploads"
					]
				},
				Outputs :> {
					{
						OutputName -> "preview",
						Description -> "Graphical preview representing the output of RenameCloudFile.  This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"ImportCloudFile",
			"OpenCloudFile",
			"DownloadCloudFile",
			"RenameCloudFile",
			"RenameCloudFileOptions",
			"ValidRenameCloudFileQ"
		},
		Tutorials -> {"EmeraldCloudFiles"},
		Author -> {"scicomp", "brad", "thomas"}
	}
];

DefineUsage[RenameCloudFileOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"RenameCloudFileOptions[cloudFile, newName]", "resolvedOptions"},
				Description -> "returns the resolved options from calling RenameCloudFile with the given inputs and options.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "cloudFile",
							Description -> "The cloud file to rename.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[Object[EmeraldCloudFile]]
							],
							Expandable -> False
						},
						{
							InputName -> "newName",
							Description -> "The name to give the cloud file.",
							Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line],
							Expandable -> True
						},
						IndexName -> "uploads"
					]
				},
				Outputs :> {
					{
						OutputName -> "resolvedOptions",
						Description -> "Resolved options when RenameCloudFile is called on the inputs.",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		SeeAlso -> {
			"ImportCloudFile",
			"OpenCloudFile",
			"DownloadCloudFile",
			"RenameCloudFile",
			"ValidRenameCloudFileQ"
		},
		Tutorials -> {"EmeraldCloudFiles"},
		Author -> {"scicomp", "brad", "thomas"}
	}
];

(* ::Subsubsection::Closed:: *)
(*DownloadCloudFile*)


DefineUsage[DownloadCloudFile,
	{
		BasicDefinitions -> {
			{
				Definition -> {"DownloadCloudFile[cloudFile,targetPath]", "path"},
				Description -> "returns the local 'path' to the file after downloading 'cloudFile' to the specified 'targetPath'.",
				Inputs :> {
					{
						InputName -> "cloudFile",
						Description -> "The cloud file to download.",
						Widget -> Widget[
							Type -> Object,
							Pattern :> ObjectP[Object[EmeraldCloudFile]]
						],
						Expandable -> False
					},
					{
						InputName -> "targetPath",
						Description -> "Local directory path or file path where the 'cloudFile' will be saved.",
						Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line],
						Expandable -> False
					}
				},
				Outputs :> {
					{
						OutputName -> "path",
						Description -> "Local file path 'cloudFile' was downloaded to.",
						Pattern :> _String
					}
				}
			}
		},
		MoreInformation -> {
		},
		Tutorials -> {"EmeraldCloudFiles"},
		Sync -> Automatic,
		SeeAlso -> {
			"UploadCloudFile",
			"OpenCloudFile",
			"ImportCloudFile"
		},
		Author -> {"scicomp", "brad", "thomas"}
	}
];


(* ::Subsubsection::Closed:: *)
(*OpenCloudFile*)


DefineUsage[OpenCloudFile,
	{
		BasicDefinitions -> {
			{
				Definition -> {"OpenCloudFile[cloudFile]", "openedFile"},
				Description -> "downloads and opens 'cloudFile'.",
				Inputs :> {
					{
						InputName -> "cloudFile",
						Description -> "The cloud file to download and open.",
						Widget -> Widget[
							Type -> Object,
							Pattern :> ObjectP[Object[EmeraldCloudFile]]
						],
						Expandable -> False
					}
				},
				Outputs :> {
					{
						OutputName -> "openedFile",
						Description -> "Opens the file and returns Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {
			"Downloads the 'cloudFile' to a temporary file in $TemporaryDirectory.",
			"Opens the downloaded file with the default program for that file type (as configured in the host operating system)."
		},
		Tutorials -> {"EmeraldCloudFiles"},
		Sync -> Automatic,
		SeeAlso -> {
			"ImportCloudFile",
			"UploadCloudFile",
			"DownloadCloudFile",
			"SystemOpen"
		},
		Author -> {"scicomp", "brad", "thomas"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ImportCloudFile*)


DefineUsage[ImportCloudFile,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ImportCloudFile[cloudFile]", "expression"},
				Description -> "returns the imported 'expression' after downloading 'cloudFile'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "cloudFile",
							Description -> "The cloud file to download and import.",
							Widget -> Alternatives[
								Widget[
									Type -> Object,
									Pattern :> ObjectP[Object[EmeraldCloudFile]]
								],
								Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[NullP]
								]
							],
							Expandable -> False
						},
						IndexName -> "imports"
					]
				},
				Outputs :> {
					{
						OutputName -> "expression",
						Description -> "Imported Mathematica expression.",
						Pattern :> _
					}
				}
			}
		},
		MoreInformation -> {
			"Downloads the 'cloudFile' to a temporary file in $TemporaryDirectory."
		},
		Tutorials -> {"EmeraldCloudFiles"},
		Sync -> Automatic,
		SeeAlso -> {
			"OpenCloudFile",
			"UploadCloudFile",
			"DownloadCloudFile"
		},
		Author -> {"scicomp", "brad", "thomas"}
	}
];

DefineUsage[convertCloudFile,
	{
		BasicDefinitions ->
			{
				{"convertCloudFile[cloudFile]", "cloudFileObject", "converts the S3 'cloudFile' into an object."}
			},
		Input :>
			{
				{"cloudFile", ListableP[_EmeraldCloudFile], "Cloud file to convert."}
			},
		Output :>
			{
				{"cloudFileObject", ListableP[ObjectP[Object[EmeraldCloudFile]]], "Cloud file object that was created."}
			},
		SeeAlso -> {
			"UploadCloudFile",
			"CloudFileExistsQ",
			"EmeraldCloudFileQ"
		},
		Author -> {"scicomp", "brad", "thomas"}
	}];