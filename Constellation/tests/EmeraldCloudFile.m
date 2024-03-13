(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*uploadCloudFile*)


DefineTests[uploadCloudFile,
	{
		Example[{Basic, "Upload a new cloud file:"},
			With[{file=Export[FileNameJoin[{$TemporaryDirectory, "text.txt"}], "Hello World!", "Text"]},
				uploadCloudFile[file]
			],
			EmeraldCloudFileP
		],

		Example[{Basic, "Upload an Image as a cloud file:"},
			uploadCloudFile[Import["ExampleData/rose.gif"]],
			EmeraldCloudFileP
		],

		Example[{Basic, "Upload a list of images as new cloud files:"},
			uploadCloudFile[{Import["ExampleData/rose.gif"], Import["ExampleData/rose.gif"]}],
			{EmeraldCloudFileP, EmeraldCloudFileP}
		],

		Example[{Basic, "Upload a list of new files:"},
			With[
				{
					file1=Export[FileNameJoin[{$TemporaryDirectory, "text.txt"}], "Hello World!", "Text"],
					file2=Export[FileNameJoin[{$TemporaryDirectory, "text2.txt"}], "Some other message!", "Text"]
				},

				uploadCloudFile[{file1, file2}]
			],
			{EmeraldCloudFileP, EmeraldCloudFileP}
		],

		Test["File paths are normalized:",
			With[
				{file=Export[FileNameJoin[{$HomeDirectory, "testing-sample-text-file.txt"}], "Hello World!", "Text"]},
				uploadCloudFile[File[If[$OperatingSystem === "Windows",
					FileNameJoin@{$HomeDirectory, ".\\something\\..\\testing-sample-text-file.txt"},
					"~/./something/../testing-sample-text-file.txt"
				]]]
			],
			EmeraldCloudFileP?(#[[1]] =!= "" && #[[2]] =!= "" &)
		],

		Test["File extensions are normalized so, e.g., uppercase image file extensions do not cause erroneous mismatches of MIME type:",
			Module[
				{turtle, t1, t2, t3, t4},
				turtle=FindFile["ExampleData/turtle.jpg"];
				t1=turtle;
				t2=CopyFile[turtle, FileNameJoin@{$TemporaryDirectory, "turtle.jpeg"}, OverwriteTarget -> True];
				t3=CopyFile[turtle, FileNameJoin@{$TemporaryDirectory, "turtle.JPG"}, OverwriteTarget -> True];
				t4=CopyFile[turtle, FileNameJoin@{$TemporaryDirectory, "turtle.JPEG"}, OverwriteTarget -> True];

				uploadCloudFile[{t1, t2, t3, t4}]
			],
			{ImageFileP, ImageFileP, ImageFileP, ImageFileP}
		],

		Example[{Messages, "Directory", "Returns $Failed and throws a message if the path is a directory:"},
			uploadCloudFile[$TemporaryDirectory],
			$Failed,
			Messages :> {
				Message[uploadCloudFile::Directory, {$TemporaryDirectory}]
			}
		],

		Example[{Messages, "UploadFailed", "Returns $Failed and throws a message if the upload does not succeed:"},
			With[
				{file=Export[FileNameJoin[{$TemporaryDirectory, "sample.txt"}], "Hello World!", "Text"]},
				uploadCloudFile[file]
			],
			$Failed,
			Messages :> {
				uploadCloudFile::UploadFailed
			},
			Stubs :> {
				GoCall["UploadCloudFile", _]={<| "Error" -> "This is a dummy error." |>}
			}
		],

		Example[{Messages, "EmptyFiles", "Returns $Failed and throws a message if the file to upload is empty:"},
			With[
				{file=Export[FileNameJoin[{$TemporaryDirectory, "sample_empty.txt"}], "", "Text"]},
				uploadCloudFile[file]
			],
			$Failed,
			Messages :> {
				uploadCloudFile::EmptyFiles
			}
		],

		Example[{Messages, "UploadFailed", "When uploading silently fails, error:"},
			With[{file=Export[FileNameJoin[{$TemporaryDirectory, "text.txt"}], "Hello World!", "Text"]},
				uploadCloudFile[file]
			],
			$Failed,
			Messages :> {
				uploadCloudFile::UploadFailed
			},
			Stubs :> {
				GoCall["UploadCloudFile", _]={<|
					"Path" -> "C:\\Users\\kevin\\AppData\\Local\\Temp\\text.txt",
					"Bucket" -> "",
					"Key" -> ""
				|>}
			}
		],

		Example[{Messages, "NotFound", "Returns $Failed and throws a message if the path isn't an existing file:"},
			uploadCloudFile[FileNameJoin[{$TemporaryDirectory, "this/does/not/exist.jpg"}]],
			$Failed,
			Messages :> {
				Message[uploadCloudFile::NotFound, {
					FileNameJoin[{$TemporaryDirectory, "this/does/not/exist.jpg"}]
				}]
			}
		],

		Example[{Messages, "NotLoggedIn", "Returns $Failed and throws a message if not logged in:"},
			uploadCloudFile[Import["ExampleData/rose.gif"]],
			$Failed,
			Messages :> {
				uploadCloudFile::NotLoggedIn
			},
			Stubs :> {
				loggedInQ[]:=False
			}
		]
	}
];

(* ::Subsubsection::Closed:: *)
(* EmeraldCloudFileP *)
DefineTests["EmeraldCloudFileP",
	{
		Example[{Basic, "EmeraldCloudFileP matches EmeraldCloudFile pattern without ID:"},
			MatchQ[EmeraldCloudFile["AmazonS3", "bucket", "key"], EmeraldCloudFileP],
			True
		],
		Example[{Basic, "EmeraldCloudFileP matches EmeraldCloudFile pattern with ID:"},
			MatchQ[EmeraldCloudFile["AmazonS3", "bucket", "key", "ID"], EmeraldCloudFileP],
			True
		],
		Example[{Basic, "EmeraldCloudFileP matches EmeraldCloudFile pattern with ID none:"},
			MatchQ[EmeraldCloudFile["AmazonS3", "bucket", "key", None], EmeraldCloudFileP],
			True
		],
		Example[{Basic, "EmeraldCloudFileP doesn't match with non EmeraldCloudFile pattern:"},
			MatchQ[File[FindFile["ExampleData/turtle.jpg"]], EmeraldCloudFileP],
			False
		]
	}
];



(* ::Subsubsection::Closed:: *)
(* EmeraldFileP *)

DefineTests["EmeraldFileP",
	{
		Example[{Basic, "EmeraldFileP matches EmeraldCloudFileP:"},
			MatchQ[EmeraldCloudFile["AmazonS3", "bucket", "key"],EmeraldFileP],
			True
		],
		Example[{Basic, "EmeraldFileP matches File pattern:"},
			MatchQ[File[FindFile["ExampleData/turtle.jpg"]],EmeraldFileP],
			True
		],
		Example[{Basic, "EmeraldFileP doesn't match with non file pattern:"},
			MatchQ["non file pattern",EmeraldFileP],
			False
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*"FilePathP"*)


DefineTests[
	"FilePathP",
	{
		(* windows *)
		Example[{Basic, "Matches on folders"},
			MatchQ["C:\\Windows", FilePathP],
			True
		],
		Example[{Basic, "Matches root folder"},
			MatchQ["C:\\", FilePathP],
			True
		],
		Example[{Basic, "Matches on files"},
			MatchQ["C:\\Windows\\System32\\zh-CN\\cdosys.dll.mui", FilePathP],
			True
		],
		Example[{Basic, "Matches on network folders and files"},
			MatchQ[$PublicPath<>"Instrument Methods\\Gilson\\Log Files\\GilsonTestLog.txt", FilePathP],
			True
		],
		Example[{Basic, "Matches on all Windows-acceptable path names"},
			MatchQ["ZD:\\W1n $0}w5\\^   {}&\\$!@#~ ;;\\qq.sd2=34.txt", FilePathP],
			True
		],
		Example[{Basic, "Infers path if no path specified"},
			MatchQ["i-have-no-path.txt", FilePathP],
			True
		],
		Example[{Basic, "Infers path if there is a path but no root (a non-absolute path)"},
			MatchQ["subDir\\i-have-no-path.txt", FilePathP],
			True
		],
		Test["Matches match path anyways if path specified does not follow Windows conventions",
			MatchQ["I:\\have an illegal?\tt:path\\", FilePathP],
			True
		],
		(* unix / os x *)
		Example[{Basic, "Unix paths."},
			MatchQ["/Users/albert/.ssh/", FilePathP],
			True
		],
		Example[{Basic, "Infers unix home path shortcuts."},
			MatchQ["~/.ssh/", FilePathP],
			True
		],
		Example[{Basic, "Unix root paths."},
			MatchQ["/", FilePathP],
			True
		],
		Example[{Basic, "Unix files."},
			MatchQ["/Users/albert/.ssh/authorized_hosts", FilePathP],
			True
		],
		Example[{Basic, "Unix files with spaces."},
			MatchQ["/home/ubuntu/some awesome script.sh", FilePathP],
			True
		],
		Example[{Basic, "Unix complete spacees in path."},
			MatchQ["/home/ubuntu/some awesome script.sh", FilePathP],
			True
		],
		Example[{Basic, "Infers paths without root (a non-absolute path)."},
			MatchQ["subDir/some awesome script.sh", FilePathP],
			True
		]
	}
];




(* ::Subsubsection::Closed:: *)
(*EmeraldFileQ*)


DefineTests[EmeraldFileQ, {
	Example[{Basic, "EmeraldFileQ matches File[path]:"},
		EmeraldFileQ[File["C:\\some\\path.jpg"]],
		True
	],
	Example[{Basic, "EmeraldFileQ matches EmeraldCloudFile:"},
		{
			EmeraldFileQ[EmeraldCloudFile["AmazonS3", "bucket", "key"]],
			EmeraldFileQ[EmeraldCloudFile["AmazonS3", "bucket", "key", None]],
			EmeraldFileQ[EmeraldCloudFile["AmazonS3", "bucket", "key", "id"]]
		},
		{True, True, True}
	],
	Example[{Basic, "EmeraldFileQ doesn't match nonsense:"},
		EmeraldFileQ[Banana],
		False
	]
}];



(* ::Subsubsection:: *)
(*EmeraldCloudFileQ*)


DefineTests[EmeraldCloudFileQ, {
	Example[{Basic, "EmeraldCloudFileQ doesn't match File[path]:"},
		EmeraldCloudFileQ[File["C:\\some\\path.jpg"]],
		False
	],
	Example[{Basic, "EmeraldCloudFileQ matches EmeraldCloudFile:"},
		{
			EmeraldCloudFileQ[EmeraldCloudFile["AmazonS3", "bucket", "key"]],
			EmeraldCloudFileQ[EmeraldCloudFile["AmazonS3", "bucket", "key", None]],
			EmeraldCloudFileQ[EmeraldCloudFile["AmazonS3", "bucket", "key", "id"]]
		},
		{True, True, True}
	],
	Example[{Basic, "EmeraldCloudFileQ doesn't match nonsense:"},
		EmeraldCloudFileQ[Banana],
		False
	],
	Test["EmeraldCloudFileP matches Object[EmeraldCloudFile] inputs:",
		Object[EmeraldCloudFile, "id:N80DNj149v1o"],
		EmeraldCloudFileP
	]
}];



(* ::Subsubsection::Closed:: *)
(*emeraldFileFormatP*)


DefineTests[emeraldFileFormatP, {
	Example[{Basic, "Pattern emeraldFileFormatP matches an image's _File:"},
		With[
			{turtlepath=FindFile["ExampleData/turtle.jpg"]},
			MatchQ[File[turtlepath], emeraldFileFormatP["JPEG"]]
		],
		True
	],
	Example[{Basic, "Pattern emeraldFileFormatP matches an image's _EmeraldCloudFile:"},
		With[
			{turtle=uploadCloudFile[Import["ExampleData/turtle.jpg"]]},
			MatchQ[turtle, emeraldFileFormatP["JPEG" | "PNG"]]
		],
		True
	],
	Example[{Basic, "Pattern emeraldFileFormatP doesn't match a _File with a different type specified:"},
		With[
			{turtlepath=FindFile["ExampleData/turtle.jpg"]},
			MatchQ[turtlepath, emeraldFileFormatP["PDF"]]
		],
		False
	],
	Example[{Basic, "Pattern emeraldFileFormatP doesn't match an _EmeraldCloudFile with a different type specified:"},
		With[
			{turtle=uploadCloudFile[Import["ExampleData/turtle.jpg"]]},
			MatchQ[turtle, emeraldFileFormatP["PDF"]]
		],
		False
	],
	Example[{Additional, "Pattern emeraldFileFormatP matches a _File of an un-supported file type as Indeterminate:"},
		Module[
			{actuallyGXL, uploadedGXL},

			(* the contents of an GXL are easy to write as text *)
			actuallyGXL=Export[FileNameJoin[{$TemporaryDirectory, "just-an-empty.gxl"}], "<gxl></gxl>", "Text"];

			MatchQ[File[actuallyGXL], emeraldFileFormatP[Indeterminate]]
		],
		True
	],
	Example[{Additional, "Pattern emeraldFileFormatP matches an _EmeraldCloudFile of an un-supported file type as Indeterminate:"},
		Module[
			{actuallyGXL, uploadedGXL},

			(* the contents of an GXL are easy to write as text *)
			actuallyGXL=Export[FileNameJoin[{$TemporaryDirectory, "just-an-empty.gxl"}], "<gxl></gxl>", "Text"];

			(* and we can upload it directly *)
			uploadedGXL=uploadCloudFile[actuallyGXL];

			MatchQ[uploadedGXL, emeraldFileFormatP[Indeterminate]]
		],
		True
	],
	Test["Pattern emeraldFileFormatP is not defined for un-supported file types (when given directly, not as Indeterminate):",
		Module[
			{turtlepath, turtle, actuallyGXL, uploadedGXL},

			turtlepath=FindFile["ExampleData/turtle.jpg"];
			turtle=uploadCloudFile[Import["ExampleData/turtle.jpg"]];

			(* the contents of an GXL are easy to write as text *)
			actuallyGXL=Export[FileNameJoin[{$TemporaryDirectory, "just-an-empty.gxl"}], "<gxl></gxl>", "Text"];

			(* and upload allows this *)
			uploadedGXL=uploadCloudFile[actuallyGXL];

			{
				(* emeraldFileFormatP works for supported types *)
				MatchQ[turtle, emeraldFileFormatP["JPEG"]],
				MatchQ[File[turtlepath], emeraldFileFormatP["PDF"]],
				MatchQ[File[actuallyGXL], emeraldFileFormatP[Indeterminate]],
				MatchQ[uploadedGXL, emeraldFileFormatP[Indeterminate]],

				(* emeraldFileFormatP isn't defined for "GXL" *)
				emeraldFileFormatP["GXL"]
			}
		],
		{
			True,
			False,
			True,
			True,
			_emeraldFileFormatP
		}
	],
	Test["FileFormat (used by emeraldFileFormatP) does resolve unsupported file types of _File, but not of _EmeraldCloudFile:",
		Module[
			{turtlepath, turtle, actuallyGXL, uploadedGXL},

			turtlepath=FindFile["ExampleData/turtle.jpg"];
			turtle=uploadCloudFile[Import["ExampleData/turtle.jpg"]];
			actuallyGXL=Export[FileNameJoin[{$TemporaryDirectory, "just-an-empty.gxl"}], "<gxl></gxl>", "Text"];
			uploadedGXL=uploadCloudFile[actuallyGXL];

			{
				FileFormat[File[turtlepath]],
				FileFormat[turtle],
				FileFormat[File[actuallyGXL]],
				FileFormat[uploadedGXL]
			}
		],
		{
			"JPEG",
			"JPEG",
			"GXL",
			Indeterminate
		}
	],
	Example[{Attributes, Protected, "This symbol is protected:"},
		emeraldFileFormatP=7,
		7,
		Messages :> {
			Message[Set::wrsym]
		}
	]
}];



(* ::Subsubsection::Closed:: *)
(*emeraldFileFormatQ*)


DefineTests[emeraldFileFormatQ, {
	Example[{Basic, "Function emeraldFileFormatQ matches an image's _File:"},
		With[
			{turtlepath=FindFile["ExampleData/turtle.jpg"]},
			emeraldFileFormatQ[File[turtlepath], "JPEG"]
		],
		True
	],
	Example[{Basic, "Function emeraldFileFormatQ matches an image's _EmeraldCloudFile:"},
		With[
			{turtle=uploadCloudFile[Import["ExampleData/turtle.jpg"]]},
			emeraldFileFormatQ[turtle, "JPEG" | "PNG"]
		],
		True
	],
	Example[{Basic, "Function emeraldFileFormatQ doesn't match a _File with a different type specified:"},
		With[
			{turtlepath=FindFile["ExampleData/turtle.jpg"]},
			emeraldFileFormatQ[turtlepath, "PDF"]
		],
		False
	],
	Example[{Basic, "Function emeraldFileFormatQ doesn't match an _EmeraldCloudFile with a different type specified:"},
		With[
			{turtle=uploadCloudFile[Import["ExampleData/turtle.jpg"]]},
			emeraldFileFormatQ[turtle, "PDF"]
		],
		False
	],
	Example[{Additional, "Function emeraldFileFormatQ matches a _File of an un-supported file type as Indeterminate:"},
		Module[
			{actuallyGXL, uploadedGXL},

			(* the contents of an GXL are easy to write as text *)
			actuallyGXL=Export[FileNameJoin[{$TemporaryDirectory, "just-an-empty.gxl"}], "<gxl></gxl>", "Text"];

			emeraldFileFormatQ[File[actuallyGXL], Indeterminate]
		],
		True
	],
	Example[{Additional, "Function emeraldFileFormatQ matches an _EmeraldCloudFile of an un-supported file type as Indeterminate:"},
		Module[
			{actuallyGXL, uploadedGXL},

			(* the contents of an GXL are easy to write as text *)
			actuallyGXL=Export[FileNameJoin[{$TemporaryDirectory, "just-an-empty.gxl"}], "<gxl></gxl>", "Text"];

			(* and we can upload it directly *)
			uploadedGXL=uploadCloudFile[actuallyGXL];

			emeraldFileFormatQ[uploadedGXL, Indeterminate]
		],
		True
	],
	Example[{Additional, "Function emeraldFileFormatQ is not defined for un-supported file types (when given directly, not as Indeterminate):"},
		Module[
			{actuallyGXL, uploadedGXL},

			(* the contents of an GXL are easy to write as text *)
			actuallyGXL=Export[FileNameJoin[{$TemporaryDirectory, "just-an-empty.gxl"}], "<gxl></gxl>", "Text"];

			(* and upload allows this *)
			uploadedGXL=uploadCloudFile[actuallyGXL];

			{
				(* emeraldFileFormatQ isn't defined for "GXL" *)
				emeraldFileFormatQ[File[actuallyGXL], "GXL"],
				emeraldFileFormatQ[uploadedGXL, "GXL"]
			}
		],
		{
			_emeraldFileFormatQ,
			_emeraldFileFormatQ
		}
	]
}];


(* ::Subsubsection::Closed:: *)
(* ImageFileP *)

DefineTests["ImageFileP",
	{
		Example[{Basic,"ImageFileP matches with image file formats (jpeg, png, tiff, bmp, svg):"},
			With[
				{
					imgFile1=FindFile["ExampleData/turtle.jpg"],
					imgFile2=FindFile["ExampleData/glasses.png"],
					imgFile3=FindFile["ExampleData/flowers.tiff"],
					imgFile4=FindFile["ExampleData/spikey3.bmp"],
					imgFile5=Export["disk.svg",
						Graphics[{Opacity[0.5], Blue, Disk[], Yellow, Disk[{1, 0}]}]]
				},
				{
					MatchQ[File[imgFile1],ImageFileP],
					MatchQ[File[imgFile2],ImageFileP],
					MatchQ[File[imgFile3],ImageFileP],
					MatchQ[File[imgFile4],ImageFileP],
					MatchQ[File[imgFile5],ImageFileP]
				}
			],
			{True,True,True,True,True}
		],
		Example[{Basic, "ImageFileP doesn't match with non-image file formats (txt, .m, xml, json, .nb):"},
			With[
				{
					notImageFile1=FindFile["ExampleData/test.tex"],
					notImageFile2=FindFile["ExampleData/simple.m"],
					notImageFile3=FindFile["ExampleData/methane.xml"],
					notImageFile4=FindFile["ExampleData/temperatures.json"],
					notImageFile5=FindFile["ExampleData/document.nb"]
				},
				{
					MatchQ[File[notImageFile1],ImageFileP],
					MatchQ[File[notImageFile2],ImageFileP],
					MatchQ[File[notImageFile3],ImageFileP],
					MatchQ[File[notImageFile4],ImageFileP],
					MatchQ[File[notImageFile5],ImageFileP]
				}
			],
			{False,False,False,False,False}
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*ImageFileQ*)


DefineTests[ImageFileQ, {
	Example[{Basic, "ImageFileQ matches an image's File[path]:"},
		With[
			{turtlepath=FindFile["ExampleData/turtle.jpg"]},
			ImageFileQ[File[turtlepath]]
		],
		True
	],
	Example[{Basic, "ImageFileQ matches an image's EmeraldCloudFile:"},
		With[
			{turtle=uploadCloudFile[Import["ExampleData/turtle.jpg"]]},
			ImageFileQ[turtle]
		],
		True
	],
	Example[{Basic, "ImageFileQ doesn't match non-images:"},
		With[
			{gasdoc=First[Model[Container, GasCylinder, "id:1ZA60vwjbbWD"][ProductDocumentationFiles][CloudFile]]},
			ImageFileQ[gasdoc]
		],
		False
	],
	Test["File paths are normalized:",
		Module[
			{rawTarget},
			CopyFile[
				FindFile["ExampleData/turtle.jpg"],
				FileNameJoin@{$HomeDirectory, "testing-sample-turtle.jpeg"},
				OverwriteTarget -> True
			];

			rawTarget=If[$OperatingSystem === "Windows",
				FileNameJoin@{$HomeDirectory, ".\\testing-sample-turtle.jpeg"},
				"~/./testing-sample-turtle.jpeg"
			];

			If[FileExistsQ[rawTarget],
				ImageFileQ[File[rawTarget]],
				True
			]
		],
		True
	]
}];



(* ::Subsubsection::Closed:: *)
(*PDFFileQ*)


DefineTests[PDFFileQ, {
	Example[{Basic, "PDFFileQ matches a PDF's File[path]:"},
		With[
			{gasdocpath=DownloadCloudFile[
				First[Model[Container, GasCylinder, "id:1ZA60vwjbbWD"][ProductDocumentationFiles]],
				Evaluate@FileNameJoin@{$TemporaryDirectory, "gasdoc.pdf"}
			]},
			PDFFileQ[File[gasdocpath]]
		],
		True
	],
	Example[{Basic, "PDFFileQ matches a PDF's EmeraldCloudFile:"},
		With[
			{gasdoc=First[Model[Container, GasCylinder, "id:1ZA60vwjbbWD"][ProductDocumentationFiles][CloudFile]]},
			PDFFileQ[gasdoc]
		],
		True
	],
	Example[{Basic, "PDFFileQ doesn't match non-PDFs:"},
		With[
			{turtlepath=FindFile["ExampleData/turtle.jpg"]},
			PDFFileQ[File[turtlepath]]
		],
		False
	]
}];


(* ::Subsection::Closed:: *)
(* openCloudFile *)


DefineTests[openCloudFile, {
	Example[{Basic, "A cloud file can be opened externally (e.g., in Windows Photo Viewer):"},
		openCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "0d5260cdf8c9fd68596ac7dbbe569224.jpg"]],
		Null,
		Stubs :> {
			SystemOpen[_]:=Null
		}
	],

	Example[{Messages, "DownloadFailed", "Downloads of invalid cloud files can fail:"},
		openCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "not-a-file-at-all.pdf"]],
		$Failed,
		Messages :> {
			EmeraldCloudFileFormat::Failed,
			Constellation`Private`downloadCloudFile::NotFound,
			Constellation`Private`openCloudFile::DownloadFailed
		}
	],

	Example[{Attributes, Listable, "A list of cloud files can be opened externally:"},
		openCloudFile[{
			EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "0d5260cdf8c9fd68596ac7dbbe569224.jpg"],
			EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "0d5260cdf8c9fd68596ac7dbbe569224.jpg"]
		}],
		{Null, Null},
		Stubs :> {
			SystemOpen[_]:=Null
		}
	]

}];


(* ::Subsection::Closed:: *)
(* importCloudFile *)


DefineTests[importCloudFile,
	{
		Example[{Basic, "Cloud files can be imported:"},
			importCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "0d5260cdf8c9fd68596ac7dbbe569224.jpg"]],
			_Image
		],

		Example[{Options, Format, "Cloud files can be imported, overriding the import format:"},
			importCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "0d5260cdf8c9fd68596ac7dbbe569224.jpg"], Format -> "JPEG"],
			_Image
		],

		If[First[StringSplit[$Version]] === "11.1.1",
			Example[{Options, Format, "Cloud files can be imported, overriding the import format.  When given the wrong (but supported) format, it fails:"},
				(* note do not change this to PNG, because in MM 11.1 libpng throws an error on the console with breaks part of our test runner *)
				importCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "0d5260cdf8c9fd68596ac7dbbe569224.jpg"], Format -> "TIFF"],
				$Failed
			],
			Example[{Options, Format, "Cloud files can be imported, overriding the import format.  When given the wrong (but supported) format, it fails:"},
				(* note do not change this to PNG, because in MM 11.1 libpng throws an error on the console with breaks part of our test runner *)
				importCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "0d5260cdf8c9fd68596ac7dbbe569224.jpg"], Format -> "TIFF"],
				$Failed,
				Messages :> {
					Import::fmterr (* added in 11.2 *)
				}
			]
		],

		Example[{Options, Format, "Cloud files can be imported, overriding the import format.  When given another mismatched format it falls back to Automatic:"},
			importCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "0d5260cdf8c9fd68596ac7dbbe569224.jpg"], Format -> "JPG"],
			_Image,
			Messages :> {
				Warning::OptionPattern
			}
		],

		Example[{Options, Force, "Cloud files can be imported, skipping the cache:"},
			importCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "0d5260cdf8c9fd68596ac7dbbe569224.jpg"], Force -> True],
			_Image
		],

		Example[{Messages, "DownloadFailed", "Imports of cloud files can fail if there are external problems:"},
			importCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "0d5260cdf8c9fd68596ac7dbbe569224.jpg"]],
			$Failed,
			Stubs :> {
				GoCall["DownloadCloudFile", _]=<| "Error" -> "This is a dummy error." |>
			},
			Messages :> {
				downloadCloudFile::DownloadFailed,
				importCloudFile::DownloadFailed
			}
		],

		Example[{Messages, "NotFound", "Imports of invalid cloud files will fail:"},
			importCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "does-not-exist-sample-for-importCloudFile.jpg"]],
			$Failed,
			Messages :> {
				EmeraldCloudFileFormat::Failed,
				Constellation`Private`importCloudFile::NotFound
			}
		]

	}];


(* ::Subsection::Closed:: *)
(* DownloadCoudFile *)


DefineTests[downloadCloudFile, {
	Example[{Basic, "A cloud file can be downloaded into a directory:"},
		If[FileExistsQ[FileNameJoin@{$TemporaryDirectory, "0d5260cdf8c9fd68596ac7dbbe569224.jpg"}],
			DeleteFile[FileNameJoin@{$TemporaryDirectory, "0d5260cdf8c9fd68596ac7dbbe569224.jpg"}];
		];

		downloadCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "0d5260cdf8c9fd68596ac7dbbe569224.jpg"], $TemporaryDirectory],
		FileNameJoin@{$TemporaryDirectory, "0d5260cdf8c9fd68596ac7dbbe569224.jpg"}
	],

	Example[{Basic, "A cloud file can be downloaded and will be saved to a file:"},
		FileExistsQ[downloadCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "0d5260cdf8c9fd68596ac7dbbe569224.jpg"], $TemporaryDirectory]],
		True
	],

	Example[{Basic, "A cloud file can be downloaded into a specific file path:"},
		If[FileExistsQ[FileNameJoin@{$TemporaryDirectory, "downloaded-sample-turtle.jpg"}],
			DeleteFile[FileNameJoin@{$TemporaryDirectory, "downloaded-sample-turtle.jpg"}];
		];

		downloadCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "0d5260cdf8c9fd68596ac7dbbe569224.jpg"], FileNameJoin@{$TemporaryDirectory, "downloaded-sample-turtle.jpg"}],
		FileNameJoin@{$TemporaryDirectory, "downloaded-sample-turtle.jpg"}
	],

	Test["Normalized names work, too:",
		If[FileExistsQ[FileNameJoin@{$HomeDirectory, "testing-downloaded-sample-turtle.jpg"}],
			DeleteFile[FileNameJoin@{$HomeDirectory, "testing-downloaded-sample-turtle.jpg"}];
		];

		downloadCloudFile[
			EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "0d5260cdf8c9fd68596ac7dbbe569224.jpg"],
			If[$OperatingSystem === "Windows",
				FileNameJoin@{$HomeDirectory, ".\\blah\\..\\testing-downloaded-sample-turtle.jpg"},
				"~/./blah/../testing-downloaded-sample-turtle.jpg"
			]
		],
		FileNameJoin@{$HomeDirectory, "testing-downloaded-sample-turtle.jpg"}
	],

	Example[{Messages, "DestinationPath", "If the target path's directory is invalid, fail:"},
		downloadCloudFile[
			EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "0d5260cdf8c9fd68596ac7dbbe569224.jpg"],
			FileNameJoin@{$TemporaryDirectory, "this-should-not-exist-but-is-a-dummy-path/0d5260cdf8c9fd68596ac7dbbe569224.jpg"}
		],
		$Failed,
		Messages :> {
			downloadCloudFile::DestinationPath
		}
	],

	Example[{Messages, "NotFound", "Downloads of invalid cloud files will fail:"},
		downloadCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "not-a-file-at-all.pdf"], $TemporaryDirectory],
		$Failed,
		Messages :> {
			EmeraldCloudFileFormat::Failed,
			downloadCloudFile::NotFound
		}
	],

	Example[{Messages, "DownloadFailed", "Downloads of cloud files can fail if there are external problems:"},
		downloadCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "0d5260cdf8c9fd68596ac7dbbe569224.jpg"], $TemporaryDirectory],
		$Failed,
		Stubs :> {
			GoCall["DownloadCloudFile", _]=<| "Error" -> "This is a dummy error." |>
		},
		Messages :> {
			downloadCloudFile::DownloadFailed
		}
	];

}];


(* ::Subsection::Closed:: *)
(* CloudFileExistsQ *)


DefineTests[CloudFileExistsQ,
	{
		Example[{Basic, "Cloud files without IDs can be tested for existence:"},
			CloudFileExistsQ[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "0d5260cdf8c9fd68596ac7dbbe569224.jpg"]],
			True
		],

		Example[{Basic, "Cloud files with IDs can be tested for existence:"},
			CloudFileExistsQ[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "bad2d0a619a8b5377d048cd542262d33.jpg", "WNa4ZjKW4vmkTP4mal4G85p6swK0m9KYRbEM"]],
			True
		],

		Example[{Basic, "Cloud files with nonsense keys can be tested for existence (and naturally do not exist):"},
			CloudFileExistsQ[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "nonsense-sample-for-cloudfileexistsq.jpg"]],
			False,
			Messages :> {
				EmeraldCloudFileFormat::Failed
			}
		]
	}
];

(* ::Subsection::Closed:: *)
(* CloudFileExistsQ *)


DefineTests["PDFFileP",
	{
		Example[{Basic, "A pattern to match if a cloud file that stores on the AWS is a pdf file: "},
			MatchQ[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-dev", "3e6f7bae20cb38f4b9688742b363fabb.pdf", "J8AY5jDZPY4xC0ErldBjW73GHX4xNkD6WqAA"], PDFFileP],
			True
		],
		Example[{Basic, "A pattern to match if a cloud file that stores on the AWS is a pdf file: "},
			MatchQ[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "0d5260cdf8c9fd68596ac7dbbe569224.jpg"], PDFFileP],
			False
		],
		Example[{Basic, "A pattern that will return True for PDFFileQ:"},
			PDFFileQ[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-dev", "3e6f7bae20cb38f4b9688742b363fabb.pdf", "J8AY5jDZPY4xC0ErldBjW73GHX4xNkD6WqAA"]]==MatchQ[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-dev", "3e6f7bae20cb38f4b9688742b363fabb.pdf", "J8AY5jDZPY4xC0ErldBjW73GHX4xNkD6WqAA"], PDFFileP],
			True
		]
	}
];
