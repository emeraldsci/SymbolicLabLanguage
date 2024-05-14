(* These tests are pretty sparse, because actually checking if the html looks good requires a human,
	 so for now we're just going to make sure these run without any warnings or errors.  That sounds like
	 little, but these are fairly complex notebooks, so the fact that they render to json correctly
	 is pretty cool.  Note that if the JSON fails to export properly for any reason, the functions
	 will return $Failed, so while this does not check that the JSON is correct [which is very hard
	 without looking at the output html], it does check that JSON was generated. *)
DefineTests[
	Publish,
	{
		Example[{Basic, "Publish an object:"},
			Publish[$Site[Model][Object]],
			URL["https://www.emeraldcloudlab.com/documentation/publish/object?id=" <> $Site[Model][ID]]
		],
		Example[{Basic, "Publish a notebook:"},
			Publish[testLabNotebook],
			URL["https://www.emeraldcloudlab.com/documentation/publish/notebook?id=" <> testLabNotebook[ID]]
		],
		Example[{Basic, "Publish a notebook page:"},
			Publish[testNotebookPage],
			URL["https://www.emeraldcloudlab.com/documentation/publish/notebookPage?id=" <> testNotebookPage[ID]]
		],
		Example[{Basic, "Publish a notebook script:"},
			Publish[testNotebookScript],
			URL["https://www.emeraldcloudlab.com/documentation/publish/notebookPage?id=" <> testNotebookScript[ID]]
		],
		Example[{Basic, "Publish a notebook function:"},
			Publish[testNotebookFunction],
			URL["https://www.emeraldcloudlab.com/documentation/publish/notebookPage?id=" <> testNotebookFunction[ID]]
		],
		Example[{Messages, "NotLoggedIn", "Returns $Failed and messages Publish::NotLoggedIn if you attempt to publish an object while not logged in:"},
			Publish[$Site[Model][Object]],
			$Failed,
			Messages :> {
				Publish::NotLoggedIn
			},
			Stubs :> {
				Constellation`Private`loggedInQ[]:=False
			}
		],
		Example[{Messages, "NotOnProduction", "Runs normally and messages Publish::NotOnProduction if you attempt to publish an object while not logged into Production:"},
			Publish[$Site[Model][Object]],
			URL["https://www.emeraldcloudlab.com/documentation/publish/object?id=" <> $Site[Model][ID]],
			Messages :> {
				Publish::NotOnProduction
			},
			Stubs :> {
				Constellation`Private`ConstellationDomain[Production]:="constellation.emeraldcloudlab.com"
			}
		]
	},
	SymbolSetUp :> {
		(* Create some notebooks to test on *)
		testNotebookPage = Upload[<|Type->Object[Notebook, Page], AssetFile->Link[Object[EmeraldCloudFile, "Publish test cloud file"]]|>];
		testNotebookScript = Upload[<|Type->Object[Notebook, Script], TemplateNotebookFile->Link[Object[EmeraldCloudFile, "Publish test cloud file"]]|>];
		testNotebookFunction = Upload[<|Type->Object[Notebook, Function], AssetFile->Link[Object[EmeraldCloudFile, "Publish test cloud file"]]|>];
		testLabNotebook = Upload[<|Type->Object[LaboratoryNotebook], Replace[Pages]->{Link[testNotebookPage]}, Replace[Functions]->{Link[testNotebookFunction]}, Replace[Scripts]->{Link[testNotebookScript]}|>];
	},
	Stubs:>{
		(* Make it think its on production as Publish issues a warning when on stage *)
		Constellation`Private`ConstellationDomain[Production]:=_
	}
];

DefineTests[
	Unpublish,
	{
		Example[{Basic, "Unpublish an already published object:"},
			obj = Upload[<|Type->Object[Sample]|>];
			Publish[obj];
			Unpublish[obj];
			{
				Download[obj, Published],
				Search[Object[Publication, Object], ReferenceObject == obj]
			},
			{False, {}}
		],
		Example[{Basic, "Unpublish an already published notebook page:"},
			notebookPage = Upload[<|
				Type->Object[Notebook, Page],
				AssetFile->Link[UploadCloudFile[Export[FileNameJoin[{$TemporaryDirectory,ToString[CreateUUID[]] <> ".nb"}],Notebook[{Cell["Hi!", "Text"]}]]]]
			|>];
			Publish[notebookPage];
			Unpublish[notebookPage];
			{
				Download[notebookPage, Published],
				Search[Object[Publication, NotebookPage], ReferenceNotebookPage == notebookPage]
			},
			{False, {}}
		],
		Example[{Basic, "Unpublish an object that was never published:"},
			object = Upload[<|Type->Object[Example]|>];
			Unpublish[object];
			{
				Download[object, Published],
				Search[Object[Publication, Object], ReferenceObject == object]
			},
			{False, {}}
		]
	},
	Stubs:>{
		(* Make it think its on production as Publish issues a warning when on stage *)
		Constellation`Private`ConstellationDomain[Production]:=_
	}
];


DefineTests[
	ConvertNotebookToPackageFile,
	{
		Example[{Basic, "Converts a simple text notebook page to a simple package file:"},
			packageFileText = ConvertNotebookToPackageFile[textNbPage];
			StringContainsQ[packageFileText, "CreatedFrom"] && StringContainsQ[packageFileText, "My Title"] && StringContainsQ[packageFileText, "Some text."],
			True
		],
		Example[{Basic, "Converts a simple text notebook function to a simple package file:"},
			packageFileText = ConvertNotebookToPackageFile[textNbFunction];
			StringContainsQ[packageFileText, "CreatedFrom"] && StringContainsQ[packageFileText, "My Title"] && StringContainsQ[packageFileText, "Some text."],
			True
		],
		Example[{Basic, "Converts a simple text notebook script to a simple package file:"},
			packageFileText = ConvertNotebookToPackageFile[textNbScript];
			StringContainsQ[packageFileText, "CreatedFrom"] && StringContainsQ[packageFileText, "My Title"] && StringContainsQ[packageFileText, "Some text."],
			True
		],
		Example[{Basic, "Converts a notebook page with pictures to a simple package file:"},
			packageFileText = ConvertNotebookToPackageFile[imageNbPage];
			StringContainsQ[packageFileText, "CreatedFrom"] && StringContainsQ[packageFileText, "$PersonID[Photo]"] && !StringContainsQ[packageFileText, "GraphicsBox"],
			True
		],
		Example[{Basic, "Converts a downloaded .nb file to a simple package file:"},
			packageFileText = ConvertNotebookToPackageFile[imageNbFile, imageNbCloudFile];
			StringContainsQ[packageFileText, "CreatedFrom"] && StringContainsQ[packageFileText, "$PersonID[Photo]"] && !StringContainsQ[packageFileText, "GraphicsBox"],
			True
		]
	},
	SymbolSetUp :> {
		(* Do some tests with simple text notebooks *)
		textNbFile = Export[FileNameJoin[{$TemporaryDirectory, ToString[CreateUUID[]] <> ".nb"}], Notebook[{Cell["My Title", "Title"], Cell["Some text.", "Text"]}]];
		textNbCloudFile = UploadCloudFile[textNbFile];
		textNbPage = Upload[<|Type->Object[Notebook, Page], AssetFile->Link[textNbCloudFile]|>];
		textNbFunction = Upload[<|Type->Object[Notebook, Function], AssetFile->Link[textNbCloudFile]|>];
		textNbScript = Upload[<|Type->Object[Notebook, Script], TemplateNotebookFile->Link[textNbCloudFile]|>];

		(* Now throw an image its way *)
		imageNbCells = Notebook[{
		  Cell[CellGroupData[{
				Cell[BoxData[RowBox[{"$PersonID", "[", "Photo", "]"}]], "Input", CellLabel -> "In[48]:=", ExpressionUUID -> "ef3b6e23-18de-4418-aa24-7d4c649d6309"],
        Cell[BoxData[GraphicsBox[TagBox[RasterBox[CompressedData["1:eJzsvVdbW8u6trm7+6QP+y/0Wfe3e+299gzOJucsFEA555yzQEICSQQhCRBIBJEkRM7BOOeMA2AcpwPRnmt/fdA/oGtImMUkGXsaY68pX4/HNVQjSGjUuOsZ"]]]]]]
	  	}]]
		}];
		imageNbFile = Export[FileNameJoin[{$TemporaryDirectory, ToString[CreateUUID[]] <> ".nb"}], imageNbCells];
		imageNbCloudFile = UploadCloudFile[imageNbFile];
		imageNbPage = Upload[<|Type->Object[Notebook, Page], AssetFile->Link[imageNbCloudFile]|>];
	}
];

DefineTests[
	ConvertPackageFileToNotebook,
	{
		Example[{Basic, "Losslessly converts a package file to a notebook when the notebook cloud file exists:"},
			convertedNotebookPath = ConvertPackageFileToNotebook[
				Export[
					FileNameJoin[{$TemporaryDirectory, ToString[CreateUUID[]]<>".m"}],
					"(* CreatedFrom " <> ToString[InputForm[textNotebookCloudFile[Object]]] <> " on " <> DateString[] <> "*)\n(* ::Package:: *)\n\n(* ::Title:: *)\nMyTitle\n\n(* ::Text:: *)\nSome text.\n",
					"String"
				]
			];
			notebookMatchQ[convertedNotebookPath, textNotebookFile],
			True
		],
		Example[{Basic, "Converts a package file to a notebook when the notebook cloud file cannot be found:"},
			convertedNotebookPath = ConvertPackageFileToNotebook[
				Export[
					FileNameJoin[{$TemporaryDirectory, ToString[CreateUUID[]]<>".m"}],
					"(* CreatedFrom Object[EmeraldCloudFile, \"id:notrealid\"] on " <> DateString[] <> "*)\n(* ::Package:: *)\n\n(* ::Title:: *)\nMy Title\n\n(* ::Text:: *)\nSome text.\n",
					"String"
				]
			];
			notebookMatchQ[convertedNotebookPath, textNotebookFile],
			True
		],
		Example[{Basic, "Losslessly converts a package file even when it has images to a notebook when the notebook cloud file exists:"},
			convertedNotebookPath = ConvertPackageFileToNotebook[
				Export[
					FileNameJoin[{$TemporaryDirectory, ToString[CreateUUID[]]<>".m"}],
					"(* CreatedFrom " <> ToString[InputForm[imageNotebookCloudFile[Object]]] <> " on " <> DateString[] <> "*)\n(* ::Package:: *)\n\n(* ::Input:: *)\n$PersonID[Photo]\n",
					"String"
				]
			];
			notebookMatchQ[convertedNotebookPath, imageNotebookFile],
			True
		],
		Example[{Basic, "Inverts ConvertNotebookToPackageFile without any loss of details:"},
			convertedNotebookPath = ConvertPackageFileToNotebook[
				Export[
					FileNameJoin[{$TemporaryDirectory, ToString[CreateUUID[]]<>".m"}],
					ConvertNotebookToPackageFile[imageNotebookPage],
					"String"
				]
			];
			notebookMatchQ[convertedNotebookPath, imageNotebookFile],
			True
		]
	},
	SymbolSetUp :> {
		(* Create an existing cloud file with simple text we can use for tests *)
		textNotebook = Notebook[{Cell["My Title", "Title"], Cell["Some text.", "Text"]}];
		textNotebookFile = Export[FileNameJoin[{$TemporaryDirectory, ToString[CreateUUID[]] <> ".nb"}], textNotebook];
		textNotebookCloudFile = UploadCloudFile[textNotebookFile];

		(* Now throw an image its way *)
		imageData = "1:eJxTTMoPSmNiYGAo5gASQYnljkVFiZXBAkBOaF5xZnpeaopnXklqemqRRRIzUFAJiEGSIPb/UTCUwbv3HzZt3ZFbXBmbkr1i9Xo8Ko+dPJ2QlusVGAlHcxcuxaN+w+btyIoJqv/379+fP38hKDopk6B6ZBAzqn54qf/+48enz5/hKDoxA6h+6qx5cJGv374hq584dRZaYkNDSRn5yOqBRuFXH5+aQ6RfRgFNAQCnyt1h";
		imageNotebook = Notebook[{
			Cell[CellGroupData[{
				Cell[BoxData[RowBox[{"$PersonID", "[", "Photo", "]"}]], "Input", CellLabel -> "In[48]:="],
				Cell[BoxData[GraphicsBox[TagBox[RasterBox[CompressedData[imageData],
							{{0, 17.}, {8., 0}}, {0, 255}, ColorFunction -> RGBColor,
					     ImageResolution -> 144.],
					    BoxForm`ImageTag["Byte", ColorSpace -> "RGB",
					     Interleaving -> True], Selectable -> False],
					   DefaultBaseStyle -> "ImageGraphics", ImageSizeRaw -> {8., 17.},
					   PlotRange -> {{0, 8.}, {0, 17.}}]], "Input"
				]
			}, Open]]
		}];
		imageNotebookFile = Export[FileNameJoin[{$TemporaryDirectory, ToString[CreateUUID[]] <> ".nb"}], imageNotebook];
		imageNotebookCloudFile = UploadCloudFile[imageNotebookFile];
		imageNotebookPage = Upload[<|Type->Object[Notebook, Page], AssetFile->Link[imageNotebookCloudFile]|>];
	}
];

(* Notebook definitions are very much MM version dependent, and so we add a helper function
   here to make sure the notebooks match according to the supplied version.  Note that versions
   earlier than 13.2 are not supported for these tests *)
notebookMatchQ[actualPath_, expectedPath_]:=Module[
	{actualNotebook, expectedNotebook},
	(* If its earlier than 13.2, always return true so we skip the test *)
	If[$VersionNumber < 13.2, Return[True]];
	(* Check that the paths actually exist *)
	If[!FileExistsQ[actualPath] || !FileExistsQ[expectedPath], Return[False]];
	(* Load the actual notebook *)
	actualNotebook = Import[actualPath] //. (ExpressionUUID -> _) -> Nothing;
	(* Load the expected notebook *)
	expectedNotebook = Import[expectedPath] //. (ExpressionUUID -> _)  -> Nothing;

	(* There's a ton of random metadata that is not related to whether the notebooks match or not,
     so we're going to string compare the content cells only *)
	MatchQ[StringTrim[ToString[First[actualNotebook]]], StringTrim[ToString[First[expectedNotebook]]]]
];
