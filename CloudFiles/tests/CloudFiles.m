(* ::Package:: *)


(* ::Subsection::Closed:: *)
(* RenameCloudFile *)


DefineTests[RenameCloudFile,
	{
		Example[{Basic, "Give a cloud file a new name:"},
			RenameCloudFile[Object[EmeraldCloudFile, "Test file 1 for RenameCloudFile"], "A new name!"];
			Download[Object[EmeraldCloudFile, "Test file 1 for RenameCloudFile"], FileName],
			"A new name!"
		],

		Example[{Basic, "You may rename multiple cloud files at once:"},
			RenameCloudFile[{Object[EmeraldCloudFile, "Test file 1 for RenameCloudFile"], Object[EmeraldCloudFile, "Test file 2 for RenameCloudFile"]}, {"A new name!", "Another new name!"}];
			Download[{Object[EmeraldCloudFile, "Test file 1 for RenameCloudFile"], Object[EmeraldCloudFile, "Test file 2 for RenameCloudFile"]}, FileName],
			{"A new name!", "Another new name!"}
		],

		Example[{Basic, "You may give multiple cloud files the same name:"},
			RenameCloudFile[{Object[EmeraldCloudFile, "Test file 1 for RenameCloudFile"], Object[EmeraldCloudFile, "Test file 2 for RenameCloudFile"]}, "A new name!"];
			Download[{Object[EmeraldCloudFile, "Test file 1 for RenameCloudFile"], Object[EmeraldCloudFile, "Test file 2 for RenameCloudFile"]}, FileName],
			{"A new name!", "A new name!"}
		],
		
		Example[{Messages, "InvalidFileName", "Returns $Failed and throws a message if the new name contains invalid characters:"},
			RenameCloudFile[{Object[EmeraldCloudFile, "Test file 1 for RenameCloudFile"], Object[EmeraldCloudFile, "Test file 2 for RenameCloudFile"]}, "A name / with a slash"],
			$Failed,
			Messages :> {Error::InvalidFileName, Error::InvalidInput}
		]
	},
	SymbolSetUp :> {
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
		$CreatedObjects={};

		Upload[<|
			CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "71bc46effed544e6ff716ed55b5bfa48.txt", "9RdZXv1GmNB6F10kDAK3bbDKuPNM6lGP7xqO"],
			FileName -> "Test file 1",
			FileType -> "txt",
			Type -> Object[EmeraldCloudFile],
			Name -> "Test file 1 for RenameCloudFile"
		|>];

		Upload[<|
			CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "71bc46effed544e6ff716ed55b5bfa48.txt", "9RdZXv1GmNB6F10kDAK3bbDKuPNM6lGP7xqO"],
			FileName -> "Test file 2",
			FileType -> "txt",
			Type -> Object[EmeraldCloudFile],
			Name -> "Test file 2 for RenameCloudFile"
		|>];
	},
	SymbolTearDown :> {
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
	}
];

(* ::Subsubsection::Closed:: *)
(*RenameCloudFileOptions*)


DefineTests[RenameCloudFileOptions,
	{
		Example[
			{Basic, "RenameCloudFileOptions has no options, so an empty list is returned:"},
			RenameCloudFileOptions[Object[EmeraldCloudFile, "Test file 1 for RenameCloudFileOptions"], "A new name!"],
			{}
		],
		Example[
			{Basic, "Since there is no option resolution, if an input is valid, still returns a empty list:"},
			RenameCloudFileOptions[{Object[EmeraldCloudFile, "Test file 1 for RenameCloudFileOptions"], Object[EmeraldCloudFile, "Test file 2 for RenameCloudFileOptions"]}, {"A new name!", "Another new name!", "Extra name"}],
			$Failed,
			Messages :> {Error::InputLengthMismatch}
		],
		Example[
			{Basic, "Since there is no option resolution, if an option is valid, still returns a empty list:"},
			RenameCloudFileOptions[Object[EmeraldCloudFile, "Test file 1 for RenameCloudFileOptions"], "A new name!", Upload -> Test],
			$Failed,
			Messages :> {Error::Pattern}
		],
		Example[
			{Options, OutputFormat, "Return the resolved options as a list:"},
			RenameCloudFileOptions[Object[EmeraldCloudFile, "Test file 1 for RenameCloudFileOptions"], "A new name!", OutputFormat -> List],
			{}
		]
	},
	SymbolSetUp :> {
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
		$CreatedObjects={};

		Upload[<|
			CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "71bc46effed544e6ff716ed55b5bfa48.txt", "9RdZXv1GmNB6F10kDAK3bbDKuPNM6lGP7xqO"],
			FileName -> "Test file 1",
			FileType -> "txt",
			Type -> Object[EmeraldCloudFile],
			Name -> "Test file 1 for RenameCloudFileOptions"
		|>];

		Upload[<|
			CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "71bc46effed544e6ff716ed55b5bfa48.txt", "9RdZXv1GmNB6F10kDAK3bbDKuPNM6lGP7xqO"],
			FileName -> "Test file 2",
			FileType -> "txt",
			Type -> Object[EmeraldCloudFile],
			Name -> "Test file 2 for RenameCloudFileOptions"
		|>];
	},
	SymbolTearDown :> {
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
	}
];



(* ::Subsubsection::Closed:: *)
(*RenameCloudFilePreview*)


DefineTests[RenameCloudFilePreview,
	{
		Example[
			{Basic, "Returns Null:"},
			RenameCloudFilePreview[Object[EmeraldCloudFile, "Test file 1 for RenameCloudFilePreview"], "A new name!"],
			Null
		],
		Example[
			{Basic, "Even if an input is invalid, returns Null:"},
			RenameCloudFilePreview[{Object[EmeraldCloudFile, "Test file 1 for RenameCloudFilePreview"], Object[EmeraldCloudFile, "Test file 2 for RenameCloudFilePreview"]}, {"A new name!", "Another new name!", "Extra name"}],
			Null,
			Messages :> {Error::InputLengthMismatch}
		],
		Example[
			{Basic, "Even if an option is invalid, returns Null:"},
			RenameCloudFilePreview[Object[EmeraldCloudFile, "Test file 1 for RenameCloudFilePreview"], "A new name!", Upload -> Test],
			Null,
			Messages :> {Error::Pattern}
		]
	},
	SymbolSetUp :> {
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
		$CreatedObjects={};

		Upload[<|
			CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "71bc46effed544e6ff716ed55b5bfa48.txt", "9RdZXv1GmNB6F10kDAK3bbDKuPNM6lGP7xqO"],
			FileName -> "Test file 1",
			FileType -> "txt",
			Type -> Object[EmeraldCloudFile],
			Name -> "Test file 1 for RenameCloudFilePreview"
		|>];

		Upload[<|
			CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "71bc46effed544e6ff716ed55b5bfa48.txt", "9RdZXv1GmNB6F10kDAK3bbDKuPNM6lGP7xqO"],
			FileName -> "Test file 2",
			FileType -> "txt",
			Type -> Object[EmeraldCloudFile],
			Name -> "Test file 2 for RenameCloudFilePreview"
		|>];

	},
	SymbolTearDown :> {
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidRenameCloudFileQ*)


DefineTests[ValidRenameCloudFileQ,
	{
		Example[
			{Basic, "Return a boolean indicating whether the call is valid:"},
			ValidRenameCloudFileQ[Object[EmeraldCloudFile, "Test file 1 for ValidRenameCloudFileQ"], "A new name!"],
			True
		],
		Example[
			{Basic, "If an input is invalid, returns False:"},
			ValidRenameCloudFileQ[{Object[EmeraldCloudFile, "Test file 1 for ValidRenameCloudFileQ"], Object[EmeraldCloudFile, "Test file 2 for ValidRenameCloudFileQ"]}, {"A new name!", "Another new name!", "Extra name"}],
			False
		],
		Example[
			{Basic, "If an option is invalid, returns False:"},
			ValidRenameCloudFileQ[Object[EmeraldCloudFile, "Test file 1 for ValidRenameCloudFileQ"], "A new name!", Upload -> Test],
			False
		],
		Example[{Options, OutputFormat, "Return a test summary of the tests run to validate the call:"},
			ValidRenameCloudFileQ[Object[EmeraldCloudFile, "Test file 1 for ValidRenameCloudFileQ"], "A new name!", OutputFormat -> TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose, "Print the test results in addition to returning a boolean indicating the validity of the call:"},
			ValidRenameCloudFileQ[Object[EmeraldCloudFile, "Test file 1 for ValidRenameCloudFileQ"], "A new name!", Verbose -> True],
			BooleanP
		]
	},
	SymbolSetUp :> {
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
		$CreatedObjects={};

		Upload[<|
			CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "71bc46effed544e6ff716ed55b5bfa48.txt", "9RdZXv1GmNB6F10kDAK3bbDKuPNM6lGP7xqO"],
			FileName -> "Test file 1",
			FileType -> "txt",
			Type -> Object[EmeraldCloudFile],
			Name -> "Test file 1 for ValidRenameCloudFileQ"
		|>];

		Upload[<|
			CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "71bc46effed544e6ff716ed55b5bfa48.txt", "9RdZXv1GmNB6F10kDAK3bbDKuPNM6lGP7xqO"],
			FileName -> "Test file 2",
			FileType -> "txt",
			Type -> Object[EmeraldCloudFile],
			Name -> "Test file 2 for ValidRenameCloudFileQ"
		|>];
	},
	SymbolTearDown :> {
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
	}
];



(* ::Subsubsection::Closed:: *)
(*UploadCloudFile*)


DefineTests[UploadCloudFile,
	{
		Example[{Basic, "Upload a new cloud file:"},
			With[{file=Export[FileNameJoin[{$TemporaryDirectory, "text.txt"}], "Hello World!", "Text"]},
				UploadCloudFile[file]
			],
			ObjectP[Object[EmeraldCloudFile]]
		],

		Example[{Basic, "Upload an Image as a cloud file:"},
			UploadCloudFile[Import[FileNameJoin[{$TemporaryDirectory, "Image Test for UploadCloudFile.jpg"}]]],
			ObjectP[Object[EmeraldCloudFile]]
		],

		Example[{Basic, "Upload a list of images as new cloud files:"},
			UploadCloudFile[{Import[FileNameJoin[{$TemporaryDirectory, "Image Test for UploadCloudFile.jpg"}]], Import[FileNameJoin[{$TemporaryDirectory, "Image Test for UploadCloudFile 2.jpg"}]]}],
			{ObjectP[Object[EmeraldCloudFile]], ObjectP[Object[EmeraldCloudFile]]}
		],

		Example[{Basic, "Upload a list of new files:"},
			With[
				{
					file1=Export[FileNameJoin[{$TemporaryDirectory, "text.txt"}], "Hello World!", "Text"],
					file2=Export[FileNameJoin[{$TemporaryDirectory, "text2.txt"}], "Some other message!", "Text"]
				},

				UploadCloudFile[{file1, file2}]
			],
			{ObjectP[Object[EmeraldCloudFile]], ObjectP[Object[EmeraldCloudFile]]}
		],

		Example[{Options, Name, "Give each cloud file a name:"},
			With[
				{
					file1=Export[FileNameJoin[{$TemporaryDirectory, "text.txt"}], "Hello World!", "Text"],
					file2=Export[FileNameJoin[{$TemporaryDirectory, "text2.txt"}], "Some other message!", "Text"]
				},

				Download[UploadCloudFile[{file1, file2}, Name -> {"my first named file", "another named file"}], FileName]
			],
			{"my first named file", "another named file"}
		],
		Example[{Options, Name, "Give each cloud file a name when uploading images directly:"},
			Download[UploadCloudFile[{Import[FileNameJoin[{$TemporaryDirectory, "Image Test for UploadCloudFile.jpg"}]], Import[FileNameJoin[{$TemporaryDirectory, "Image Test for UploadCloudFile 2.jpg"}]]}, Name -> {"my spkiey", "my rose"}], FileName],
			{"my spkiey", "my rose"}
		],

		Example[{Options, Name, "Name will automatically resolve from the file path:"},
			With[
				{
					file1=Export[FileNameJoin[{$TemporaryDirectory, "text.txt"}], "Hello World!", "Text"],
					file2=Export[FileNameJoin[{$TemporaryDirectory, "text2.txt"}], "Some other message!", "Text"]
				},

				Download[UploadCloudFile[{file1, file2}], FileName]
			],
			{"text", "text2"}
		],

		Example[{Options, Name, "Mixed name options may be specified. If a name is specified as a string, that name will be used. If a name is specified as Null, the file will be uploaded but not associated with a name. If a name is specified as Automatic, the file path of the input file will be used:"},
			With[
				{
					file1=Export[FileNameJoin[{$TemporaryDirectory, "text.txt"}], "Hello World!", "Text"],
					file2=Export[FileNameJoin[{$TemporaryDirectory, "text2.txt"}], "Some other message!", "Text"],
					file3=Export[FileNameJoin[{$TemporaryDirectory, "text3.txt"}], "A third message!", "Text"]
				},

				Download[UploadCloudFile[{file1, file2, file3, Import[FileNameJoin[{$TemporaryDirectory, "Image Test for UploadCloudFile.jpg"}]], Import[FileNameJoin[{$TemporaryDirectory, "Image Test for UploadCloudFile 2.jpg"}]], Import[FileNameJoin[{$TemporaryDirectory, "Image Test for UploadCloudFile 2.jpg"}]]},
					Name -> {"Named file", Null, Automatic, "Named file 2", Null, Automatic}
				], FileName]
			],
			{"Named file", Null, "text3", "Named file 2", Null, Null}
		],

		Example[{Additional, "If an empty list is given, an empty list is returned:"},
			UploadCloudFile[{}],
			{}
		],

		Test["File extensions are normalized so, e.g., uppercase image file extensions do not cause erroneous mismatches of MIME type:",
			Module[
				{turtle, t1, t2, t3, t4},
				turtle=FindFile["ExampleData/turtle.jpg"];
				t1=turtle;
				t2=CopyFile[turtle, FileNameJoin@{$TemporaryDirectory, "turtle.jpeg"}, OverwriteTarget -> True];
				t3=CopyFile[turtle, FileNameJoin@{$TemporaryDirectory, "turtle.JPG"}, OverwriteTarget -> True];
				t4=CopyFile[turtle, FileNameJoin@{$TemporaryDirectory, "turtle.JPEG"}, OverwriteTarget -> True];

				UploadCloudFile[{t1, t2, t3, t4}]
			],
			{ObjectP[Object[EmeraldCloudFile]], ObjectP[Object[EmeraldCloudFile]], ObjectP[Object[EmeraldCloudFile]], ObjectP[Object[EmeraldCloudFile]]}
		],

		Example[{Messages, "Directory", "Returns $Failed and throws a message if the path is a directory:"},
			UploadCloudFile[$TemporaryDirectory],
			$Failed,
			Messages :> {Error::Directory, Error::InvalidInput}
		],


		Example[{Messages, "EmptyFiles", "Returns $Failed and throws a message if the file to upload is empty:"},
			With[
				{file=Export[FileNameJoin[{$TemporaryDirectory, "sample_empty.txt"}], "", "Text"]},
				UploadCloudFile[file]
			],
			$Failed,
			Messages :> {Error::EmptyFiles, Error::InvalidInput}
		],
		
		Example[{Messages, "InvalidFileName", "Returns $Failed and throws a message if the filename contains problematic characters:"},
			With[
				{file=Export[FileNameJoin[{$TemporaryDirectory, "sample_empty.txt"}], "Hello World!", "Text"]},
				UploadCloudFile[file, Name-> "has a / forward slash"]
			],
			$Failed,
			Messages :> {Error::InvalidFileName, Error::InvalidOption}
		],

		Example[{Messages, "NotFound", "Returns $Failed and throws a message if the path isn't an existing file:"},
			UploadCloudFile[FileNameJoin[{$TemporaryDirectory, "this/does/not/exist.jpg"}]],
			$Failed,
			Messages :> {Error::NotFound, Error::InvalidInput}
		],

		Example[{Messages, "InputLengthMismatch", "Errors if there is not a 1:1 relationship between the inputs and the file names:"},
			With[
				{
					file1=Export[FileNameJoin[{$TemporaryDirectory, "text.txt"}], "Hello World!", "Text"],
					file2=Export[FileNameJoin[{$TemporaryDirectory, "text2.txt"}], "Some other message!", "Text"]
				},

				UploadCloudFile[{file1, file2}, Name -> {"File1", "File2", "File3"}]
			],
			$Failed,
			Messages :> {Error::InputLengthMismatch}
		],
		Example[{Messages, "ConflictingNotebooks", "If the specified Notebook is in conflict with $Notebook, a warning is shown but and Notebook is set to $Notebook:"},
			With[{file1=Export[FileNameJoin[{$TemporaryDirectory, "text10.txt"}], "Hello World!", "Text"]},
				Download[
					UploadCloudFile[{file1}, Name -> {"Named file"}, Notebook -> Object[LaboratoryNotebook, "Test notebook 2 for UploadCloudFile tests"<>$SessionUUID]],
					Notebook
				]
			],
			{ObjectP[Object[LaboratoryNotebook, "Test notebook 1 for UploadCloudFile tests"<>$SessionUUID]]},
			Messages:>{UploadCloudFile::ConflictingNotebooks},
			Stubs:>{$Notebook = Download[Object[LaboratoryNotebook, "Test notebook 1 for UploadCloudFile tests"<>$SessionUUID], Object]}
		],
		Test["When $Notebook is Null, the Notebook field can be set with the Notebook option:",
			With[{file1=Export[FileNameJoin[{$TemporaryDirectory, "text20.txt"}], "Hello World!", "Text"]},
				Download[
					UploadCloudFile[{file1}, Name -> {"Named file"}, Notebook -> Object[LaboratoryNotebook, "Test notebook 2 for UploadCloudFile tests"<>$SessionUUID]],
					Notebook
				]
			],
			{ObjectP[Object[LaboratoryNotebook, "Test notebook 2 for UploadCloudFile tests"<>$SessionUUID]]}
		]
	},
	SymbolSetUp :> {
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[LaboratoryNotebook, "Test notebook 1 for UploadCloudFile tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test notebook 2 for UploadCloudFile tests"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
		$CreatedObjects={};
		Upload[{
			<|Type -> Object[LaboratoryNotebook], DeveloperObject -> True, Name -> "Test notebook 1 for UploadCloudFile tests"<>$SessionUUID|>,
			<|Type -> Object[LaboratoryNotebook], DeveloperObject -> True, Name -> "Test notebook 2 for UploadCloudFile tests"<>$SessionUUID|>
		}];

		DownloadCloudFile[
			<|
				CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "119acb96b2046007cb40a077e8f7b8f0.jpg", "n0k9mG87OdGJS9JmZXp6GaxWcEW1rxmlAvrp"],
				FileName -> Null,
				FileType -> "jpg",
				Type -> Object[EmeraldCloudFile]
			|>,
			FileNameJoin[{$TemporaryDirectory, "Image Test for UploadCloudFile.jpg"}]
		];

		DownloadCloudFile[
			<|
				CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "a6e9c02208233f23ec3350ebcb5d00c3.jpg", "N80DNj14evGviRlWZV50jjp0TNO8K0mNrl14"],
				FileName -> Null,
				FileType -> "jpg",
				Type -> Object[EmeraldCloudFile]
			|>,
			FileNameJoin[{$TemporaryDirectory, "Image Test for UploadCloudFile 2.jpg"}]
		];

	},
	SymbolTearDown :> {
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[LaboratoryNotebook, "Test notebook 1 for UploadCloudFile tests"<>$SessionUUID],
					Object[LaboratoryNotebook, "Test notebook 2 for UploadCloudFile tests"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	}
];




(* ::Subsubsection::Closed:: *)
(*UploadCloudFileOptions*)


DefineTests[UploadCloudFileOptions,
	{
		Example[
			{Basic, "Return the resolved options:"},
			With[{file=Export[FileNameJoin[{$TemporaryDirectory, "text.txt"}], "Hello World!", "Text"]},
				UploadCloudFileOptions[file]
			],
			Graphics_
		],
		Example[
			{Basic, "Even if an input is invalid, returns as many of the options as could be resolved:"},
			UploadCloudFileOptions[$TemporaryDirectory],
			Graphics_,
			Messages :> {Error::Directory, Error::InvalidInput}
		],
		Example[
			{Basic, "Even if an option is invalid, returns as many of the options as could be resolved:"},
			With[
				{
					file1=Export[FileNameJoin[{$TemporaryDirectory, "text.txt"}], "Hello World!", "Text"],
					file2=Export[FileNameJoin[{$TemporaryDirectory, "text2.txt"}], "Some other message!", "Text"]
				},

				UploadCloudFileOptions[{file1, file2}, Name -> {"File1", "File2", "File3"}]
			],
			Graphics_,
			Messages :> {Error::InputLengthMismatch}
		],
		Example[
			{Options, OutputFormat, "Return the resolved options as a list:"},
			With[
				{
					file1=Export[FileNameJoin[{$TemporaryDirectory, "text.txt"}], "Hello World!", "Text"],
					file2=Export[FileNameJoin[{$TemporaryDirectory, "text2.txt"}], "Some other message!", "Text"]
				},

				UploadCloudFileOptions[{file1, file2},
					OutputFormat -> List
				]
			],
			{_Rule ..}
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*UploadCloudFilePreview*)


DefineTests[UploadCloudFilePreview,
	{
		Example[
			{Basic, "Returns Null:"},
			With[{file=Export[FileNameJoin[{$TemporaryDirectory, "text.txt"}], "Hello World!", "Text"]},
				UploadCloudFilePreview[file]
			],
			Null
		],
		Example[
			{Basic, "Even if an input is invalid, returns Null:"},
			UploadCloudFilePreview[$TemporaryDirectory],
			Null,
			Messages :> {Error::Directory, Error::InvalidInput}
		],
		Example[
			{Basic, "Even if an option is invalid, returns Null:"},
			With[
				{
					file1=Export[FileNameJoin[{$TemporaryDirectory, "text.txt"}], "Hello World!", "Text"],
					file2=Export[FileNameJoin[{$TemporaryDirectory, "text2.txt"}], "Some other message!", "Text"]
				},

				UploadCloudFilePreview[{file1, file2}, Name -> {"File1", "File2", "File3"}]
			],
			Null,
			Messages :> {Error::InputLengthMismatch}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidUploadCloudFileQ*)


DefineTests[ValidUploadCloudFileQ,
	{
		Example[
			{Basic, "Return a boolean indicating whether the call is valid:"},
			With[{file=Export[FileNameJoin[{$TemporaryDirectory, "text.txt"}], "Hello World!", "Text"]},
				ValidUploadCloudFileQ[file]
			],
			True
		],
		Example[
			{Basic, "If an input is invalid, returns False:"},
			ValidUploadCloudFileQ[$TemporaryDirectory],
			False
		],
		Example[
			{Basic, "If an option is invalid, returns False:"},
			With[
				{
					file1=Export[FileNameJoin[{$TemporaryDirectory, "text.txt"}], "Hello World!", "Text"],
					file2=Export[FileNameJoin[{$TemporaryDirectory, "text2.txt"}], "Some other message!", "Text"]
				},

				ValidUploadCloudFileQ[{file1, file2}, Name -> {"File1", "File2", "File3"}]
			],
			False
		],
		Example[{Options, OutputFormat, "Return a test summary of the tests run to validate the call:"},
			With[{file=Export[FileNameJoin[{$TemporaryDirectory, "text.txt"}], "Hello World!", "Text"]},
				ValidUploadCloudFileQ[file, OutputFormat -> TestSummary]
			],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose, "Print the test results in addition to returning a boolean indicating the validity of the call:"},
			With[{file=Export[FileNameJoin[{$TemporaryDirectory, "text.txt"}], "Hello World!", "Text"]},
				ValidUploadCloudFileQ[file, Verbose -> True]
			],
			BooleanP
		]
	}
];




(* ::Subsection::Closed:: *)
(* DownloadCloudFile *)


DefineTests[DownloadCloudFile,
	{
		Example[{Basic, "A cloud file can be downloaded into a directory:"},
			DownloadCloudFile[Object[EmeraldCloudFile, "Test file 1 for DownloadCloudFile"], $TemporaryDirectory],
			FileNameJoin@{$TemporaryDirectory, "Test file 1.txt"}
		],

		Example[{Basic, "A cloud file can be downloaded and will be saved in a specified directory:"},
			FileExistsQ[DownloadCloudFile[Object[EmeraldCloudFile, "Test file 1 for DownloadCloudFile"], $TemporaryDirectory]],
			True
		],

		Example[{Basic, "A cloud file can be downloaded into a specific file path:"},
			DownloadCloudFile[Object[EmeraldCloudFile, "Test file 1 for DownloadCloudFile"], FileNameJoin@{$TemporaryDirectory, "test download.txt"}],
			FileNameJoin@{$TemporaryDirectory, "test download.txt"}
		],

		Example[{Basic, "Multiple cloud files can be downloaded:"},
			DownloadCloudFile[{Object[EmeraldCloudFile, "Test file 1 for DownloadCloudFile"], Object[EmeraldCloudFile, "Test file 2 for DownloadCloudFile"]}, {FileNameJoin@{$TemporaryDirectory, "test download 2.txt"}, FileNameJoin@{$TemporaryDirectory, "test download 3.txt"}}],
			{FileNameJoin@{$TemporaryDirectory, "test download 2.txt"}, FileNameJoin@{$TemporaryDirectory, "test download 3.txt"}}
		],

		Example[{Basic, "Very long file name can be hashed and downloaded:"},
			DownloadCloudFile[Object[EmeraldCloudFile, "Cloud file with very long file name"], $TemporaryDirectory],
			FileNameJoin@{$TemporaryDirectory, "29a6bee12196d1cf.txt"}
		],

		Example[{Messages, "DestinationPath", "If the target path's directory is invalid, fail:"},
			DownloadCloudFile[
				Object[EmeraldCloudFile, "Test file 1 for DownloadCloudFile"],
				FileNameJoin@{$TemporaryDirectory, "this-should-not-exist-but-is-a-dummy-path/0d5260cdf8c9fd68596ac7dbbe569224.txt"}
			],
			$Failed,
			Messages :> {
				DownloadCloudFile::DestinationPath
			}
		],

		Example[{Messages, "NotFound", "Downloads of invalid cloud files will fail:"},
			DownloadCloudFile[Object[EmeraldCloudFile, "False cloud file"], $TemporaryDirectory],
			$Failed,
			Messages :> {
				EmeraldCloudFileFormat::Failed,
				DownloadCloudFile::NotFound
			}
		],

		Test["Cloud files are cached when they do not change:",
			(* Download the file once, wait a bit and then download it again, and make sure the file modified date does not change *)
			filePath=FileNameJoin@{$TemporaryDirectory, CreateUUID[]};
			DownloadCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "0d5260cdf8c9fd68596ac7dbbe569224.jpg"], filePath];
			originalFileDate=FileDate[filePath];
			Pause[3];
			DownloadCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "0d5260cdf8c9fd68596ac7dbbe569224.jpg"], filePath];
			MatchQ[originalFileDate, FileDate[filePath]],
			True
		],

		Test["Cloud file cache is busted when the file is different:",
			(* Put a different file into place, and make sure it redownloads *)
			filePath=FileNameJoin@{$TemporaryDirectory, CreateUUID[] <> ".txt"};
			Export[filePath, "Definitely not a turtle"];
			DownloadCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "0d5260cdf8c9fd68596ac7dbbe569224.jpg"], filePath];
			(* The turtle is 5kB and the not a turtle string is 23 bytes - so it better be the turtle *)
			MatchQ[FileByteCount[filePath], 5136],
			True
		]

	},
	SymbolSetUp :> {
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
		$CreatedObjects={};

		With[{files={FileNameJoin@{$TemporaryDirectory, "Test file 1.txt"},
			FileNameJoin@{$TemporaryDirectory, "test download.txt"},
			FileNameJoin@{$TemporaryDirectory, "test download 2.txt"},
			FileNameJoin@{$TemporaryDirectory, "test download 3.txt"},
			FileNameJoin@{$HomeDirectory, "test download 4.txt"}}},
			DeleteFile[PickList[files, (FileExistsQ[#] & /@ files)]]];

		Upload[<|
			CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "71bc46effed544e6ff716ed55b5bfa48.txt", "9RdZXv1GmNB6F10kDAK3bbDKuPNM6lGP7xqO"],
			FileName -> "Test file 1",
			FileType -> "txt",
			Type -> Object[EmeraldCloudFile],
			Name -> "Test file 1 for DownloadCloudFile"
		|>];

		Upload[<|
			CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "71bc46effed544e6ff716ed55b5bfa48.txt", "9RdZXv1GmNB6F10kDAK3bbDKuPNM6lGP7xqO"],
			FileName -> "Test file 2",
			FileType -> "txt",
			Type -> Object[EmeraldCloudFile],
			Name -> "Test file 2 for DownloadCloudFile"
		|>];

		Upload[<|
			CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "not-a-file-at-all.txt"],
			FileName -> "False cloud file",
			FileType -> "txt",
			Type -> Object[EmeraldCloudFile],
			Name -> "False cloud file"
		|>];

		Upload[<|
			CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "71bc46effed544e6ff716ed55b5bfa48.txt", "9RdZXv1GmNB6F10kDAK3bbDKuPNM6lGP7xqO"],
			FileName -> StringJoin[Table["ExtraSuperLongTestString_", {14}]] <> ".txt",
			FileType -> "txt",
			Type -> Object[EmeraldCloudFile],
			Name -> "Cloud file with very long file name"
		|>];
	},
	SymbolTearDown :> {
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
		With[{files={FileNameJoin@{$TemporaryDirectory, "Test file 1.txt"},
			FileNameJoin@{$TemporaryDirectory, "test download.txt"},
			FileNameJoin@{$TemporaryDirectory, "test download 2.txt"},
			FileNameJoin@{$TemporaryDirectory, "test download 3.txt"},
			FileNameJoin@{$HomeDirectory, "test download 4.txt"},
			FileNameJoin@{$TemporaryDirectory, "29a6bee12196d1cf.txt"}}},
			DeleteFile[PickList[files, (FileExistsQ[#] & /@ files)]]]
	}
];


(* ::Subsection::Closed:: *)
(* OpenCloudFile *)


DefineTests[OpenCloudFile,
	{
		Example[{Basic, "A cloud file can be opened externally (e.g., in Windows Photo Viewer):"},
			OpenCloudFile[Object[EmeraldCloudFile, "Test file 1 for OpenCloudFile"]],
			Null,
			Stubs :> {
				SystemOpen[x_]:=Null
			}
		],

		Example[{Messages, "DownloadFailed", "Downloads of invalid cloud files can fail:"},
			OpenCloudFile[Object[EmeraldCloudFile, "False cloud file for OpenCloudFile"]],
			$Failed,
			Messages :> {
				EmeraldCloudFileFormat::Failed,
				DownloadCloudFile::NotFound,
				OpenCloudFile::DownloadFailed
			}
		],

		Example[{Attributes, Listable, "A list of cloud files can be opened externally:"},
			OpenCloudFile[{
				Object[EmeraldCloudFile, "Test file 1 for OpenCloudFile"],
				Object[EmeraldCloudFile, "Test file 2 for OpenCloudFile"]
			}],
			{Null, Null},
			Stubs :> {
				SystemOpen[_]:=Null
			}
		]
	},
	SymbolSetUp :> {
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
		$CreatedObjects={};

		Upload[<|
			CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "71bc46effed544e6ff716ed55b5bfa48.txt", "9RdZXv1GmNB6F10kDAK3bbDKuPNM6lGP7xqO"],
			FileName -> "Test file 1 for OpenCloudFile",
			FileType -> "txt",
			Type -> Object[EmeraldCloudFile],
			Name -> "Test file 1 for OpenCloudFile"
		|>];

		Upload[<|
			CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "71bc46effed544e6ff716ed55b5bfa48.txt", "9RdZXv1GmNB6F10kDAK3bbDKuPNM6lGP7xqO"],
			FileName -> "Test file 2 for OpenCloudFile",
			FileType -> "txt",
			Type -> Object[EmeraldCloudFile],
			Name -> "Test file 2 for OpenCloudFile"
		|>];

		Upload[<|
			CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "not-a-file-at-all.txt"],
			FileName -> "False cloud file for OpenCloudFile",
			FileType -> "txt",
			Type -> Object[EmeraldCloudFile],
			Name -> "False cloud file for OpenCloudFile"
		|>];
	},
	SymbolTearDown :> {
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
		With[{files={
			FileNameJoin@{$TemporaryDirectory, "Test file 1 for OpenCloudFile.txt"},
			FileNameJoin@{$TemporaryDirectory, "Test file 2 for OpenCloudFile.txt"}
		}},
			DeleteFile[PickList[files, (FileExistsQ[#] & /@ files)]]]
	}
];



(* ::Subsection::Closed:: *)
(* ImportCloudFile *)


DefineTests[ImportCloudFile,
	{
		Example[{Basic, "Cloud files can be imported:"},
			ImportCloudFile[Object[EmeraldCloudFile, "Test file 1 for ImportCloudFile"]],
			_Image
		],

		Example[{Basic, "Multiple cloud files can be imported:"},
			ImportCloudFile[{Object[EmeraldCloudFile, "Test file 1 for ImportCloudFile"], Object[EmeraldCloudFile, "Test file 2 for ImportCloudFile"]}],
			{_Image, _String}
		],

		Test["Importing Null will return Null:",
			ImportCloudFile[{Object[EmeraldCloudFile, "Test file 1 for ImportCloudFile"], Null, Object[EmeraldCloudFile, "Test file 2 for ImportCloudFile"]}],
			{_Image, Null, _String}
		],

		Test["Importing a list of Nulls will return a list of Nulls:",
			ImportCloudFile[{Null, Null, Null}],
			{Null, Null, Null}
		],

		Example[{Options, Format, "Cloud files can be imported, overriding the import format:"},
			ImportCloudFile[Object[EmeraldCloudFile, "Test file 1 for ImportCloudFile"], Format -> "JPEG"],
			_Image
		],

		If[First[StringSplit[$Version]] === "11.1.1",
			Example[{Options, Format, "Cloud files can be imported, overriding the import format.  When given the wrong (but supported) format, it fails:"},
				(* note do not change this to PNG, because in MM 11.1 libpng throws an error on the console with breaks part of our test runner *)
				ImportCloudFile[Object[EmeraldCloudFile, "Test file 1 for ImportCloudFile"], Format -> "TIFF"],
				$Failed
			],
			Example[{Options, Format, "Cloud files can be imported, overriding the import format.  When given the wrong (but supported) format, it fails:"},
				(* note do not change this to PNG, because in MM 11.1 libpng throws an error on the console with breaks part of our test runner *)
				ImportCloudFile[Object[EmeraldCloudFile, "Test file 1 for ImportCloudFile"], Format -> "TIFF"],
				$Failed,
				Messages :> {
					Import::fmterr (* added in 11.2 *)
				}
			]
		],

		Example[{Options, Format, "Cloud files can be imported, overriding the import format.  When given another mismatched format it falls back to Automatic:"},
			ImportCloudFile[Object[EmeraldCloudFile, "Test file 1 for ImportCloudFile"], Format -> "JPG"],
			_Image,
			Messages :> {
				Warning::OptionPattern
			}
		],

		Example[{Options, Force, "Cloud files can be imported, skipping the cache:"},
			ImportCloudFile[Object[EmeraldCloudFile, "Test file 1 for ImportCloudFile"], Force -> True],
			_Image
		],

		Example[{Messages, "NotFound", "Imports of invalid cloud files will fail:"},
			ImportCloudFile[Object[EmeraldCloudFile, "False cloud file for ImportCloudFile"]],
			$Failed,
			Messages :> {
				EmeraldCloudFileFormat::Failed,
				ImportCloudFile::NotFound
			}
		]

	},
	SymbolSetUp :> {
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
		$CreatedObjects={};

		Upload[<|
			CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "a6e9c02208233f23ec3350ebcb5d00c3.jpg", "N80DNj14evGviRlWZV50jjp0TNO8K0mNrl14"],
			FileName -> "Test file 1 for ImportCloudFile",
			FileType -> "jpg",
			Type -> Object[EmeraldCloudFile],
			Name -> "Test file 1 for ImportCloudFile"
		|>];

		Upload[<|
			CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "71bc46effed544e6ff716ed55b5bfa48.txt", "9RdZXv1GmNB6F10kDAK3bbDKuPNM6lGP7xqO"],
			FileName -> "Test file 2 for ImportCloudFile",
			FileType -> "txt",
			Type -> Object[EmeraldCloudFile],
			Name -> "Test file 2 for ImportCloudFile"
		|>];

		Upload[<|
			CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "not-a-file-at-all.txt"],
			FileName -> "False cloud file for ImportCloudFile",
			FileType -> "txt",
			Type -> Object[EmeraldCloudFile],
			Name -> "False cloud file for ImportCloudFile"
		|>];
	},
	SymbolTearDown :> {
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
		With[{files={
			FileNameJoin@{$TemporaryDirectory, "Test file 1 for ImportCloudFile.txt"},
			FileNameJoin@{$TemporaryDirectory, "Test file 2 for ImportCloudFile.txt"}
		}},
			DeleteFile[PickList[files, (FileExistsQ[#] & /@ files)]]]
	}
];

DefineTests[convertCloudFile,
	{
		Example[{Basic, "Convert a single cloud file:"},
			convertCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "da8d7faa75776e3aa52f354e0ae8e30f.txt", "wqW9BP7dzebwhVBZDO54e15KIL9eajRd0BlA"]],
			ObjectP[Object[EmeraldCloudFile]]
		],

		Example[{Basic, "Convert a list of cloud files:"},
			convertCloudFile[{EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "da8d7faa75776e3aa52f354e0ae8e30f.txt", "wqW9BP7dzebwhVBZDO54e15KIL9eajRd0BlA"], EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "da8d7faa75776e3aa52f354e0ae8e30f.txt", "wqW9BP7dzebwhVBZDO54e15KIL9eajRd0BlA"]}],
			{ObjectP[Object[EmeraldCloudFile]], ObjectP[Object[EmeraldCloudFile]]}
		],

		Example[{Options, FileName, "Give names to the cloud files:"},
			Download[
				convertCloudFile[{
					EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "da8d7faa75776e3aa52f354e0ae8e30f.txt", "wqW9BP7dzebwhVBZDO54e15KIL9eajRd0BlA"],
					EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "da8d7faa75776e3aa52f354e0ae8e30f.txt", "wqW9BP7dzebwhVBZDO54e15KIL9eajRd0BlA"],
					EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "da8d7faa75776e3aa52f354e0ae8e30f.txt", "wqW9BP7dzebwhVBZDO54e15KIL9eajRd0BlA"]},
					FileName -> {"file 1", Null, "file 2"}
				],
				FileName
			],
			{"file 1", Null, "file 2"}
		],

		Example[{Options, Notebook, "Specify which notebook the cloud files should belong to:"},
			Download[
				convertCloudFile[{
					EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "da8d7faa75776e3aa52f354e0ae8e30f.txt", "wqW9BP7dzebwhVBZDO54e15KIL9eajRd0BlA"],
					EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "da8d7faa75776e3aa52f354e0ae8e30f.txt", "wqW9BP7dzebwhVBZDO54e15KIL9eajRd0BlA"],
					EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "da8d7faa75776e3aa52f354e0ae8e30f.txt", "wqW9BP7dzebwhVBZDO54e15KIL9eajRd0BlA"]},
					Notebook -> Object[LaboratoryNotebook, "Test notebook for convertCloudFile"]
				],
				Notebook
			],
			{ObjectP[Object[LaboratoryNotebook, "Test notebook for convertCloudFile"]], ObjectP[Object[LaboratoryNotebook, "Test notebook for convertCloudFile"]], ObjectP[Object[LaboratoryNotebook, "Test notebook for convertCloudFile"]]}
		],

		Example[{Options, Notebook, "Specify that the cloud files should belong to different notebooks:"},
			Download[
				convertCloudFile[{
					EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "da8d7faa75776e3aa52f354e0ae8e30f.txt", "wqW9BP7dzebwhVBZDO54e15KIL9eajRd0BlA"],
					EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "da8d7faa75776e3aa52f354e0ae8e30f.txt", "wqW9BP7dzebwhVBZDO54e15KIL9eajRd0BlA"],
					EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "da8d7faa75776e3aa52f354e0ae8e30f.txt", "wqW9BP7dzebwhVBZDO54e15KIL9eajRd0BlA"]},
					Notebook -> {Object[LaboratoryNotebook, "Test notebook for convertCloudFile"], Null, Object[LaboratoryNotebook, "Test notebook for convertCloudFile 2"]}
				],
				Notebook
			],
			{ObjectP[Object[LaboratoryNotebook, "Test notebook for convertCloudFile"]], Null, ObjectP[Object[LaboratoryNotebook, "Test notebook for convertCloudFile 2"]]}
		],

		Example[{Options, Upload, "Specify whether the cloud file objects should be uploaded:"},
			convertCloudFile[{
				EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "da8d7faa75776e3aa52f354e0ae8e30f.txt", "wqW9BP7dzebwhVBZDO54e15KIL9eajRd0BlA"],
				EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "da8d7faa75776e3aa52f354e0ae8e30f.txt", "wqW9BP7dzebwhVBZDO54e15KIL9eajRd0BlA"]},
				Upload -> False
			],
			{PacketP[Object[EmeraldCloudFile]], PacketP[Object[EmeraldCloudFile]]}
		],

		Example[{Messages, "InputLengthMismatch", "Give names to the cloud files:"},
			convertCloudFile[{
				EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "da8d7faa75776e3aa52f354e0ae8e30f.txt", "wqW9BP7dzebwhVBZDO54e15KIL9eajRd0BlA"],
				EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "da8d7faa75776e3aa52f354e0ae8e30f.txt", "wqW9BP7dzebwhVBZDO54e15KIL9eajRd0BlA"],
				EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "da8d7faa75776e3aa52f354e0ae8e30f.txt", "wqW9BP7dzebwhVBZDO54e15KIL9eajRd0BlA"]},
				FileName -> {"file 1", "file 2"}
			],
			$Failed,
			Messages :> {Error::InputLengthMismatch}
		]
	},
	SymbolSetUp :> {
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
		$CreatedObjects={};
		Upload[<|
			Type -> Object[LaboratoryNotebook],
			Name -> "Test notebook for convertCloudFile"
		|>];
		Upload[<|
			Type -> Object[LaboratoryNotebook],
			Name -> "Test notebook for convertCloudFile 2"
		|>];
	}
]
