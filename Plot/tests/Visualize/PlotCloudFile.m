(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotCloudFile*)


DefineTests[PlotCloudFile,{

	Example[{Basic,"Create a zoomable image of a cloud file that contains an image:"},
		PlotCloudFile[Object[EmeraldCloudFile, "IMG Test for PlotCloudFile.jpg"]],
		ZoomableP
	],
	Example[{Basic,"Create a zoomable image of the first page of a pdf file:"},
		PlotCloudFile[Object[EmeraldCloudFile, "PDF Test for PlotCloudFile.pdf"]],
		ZoomableP
	],
	Example[{Basic,"Create a snippet of a text file:"},
		PlotCloudFile[Object[EmeraldCloudFile, "TXT Test for PlotCloudFile.txt"]],
		_String
	],
	Example[{Additional,"Works on a list of files:"},
		PlotCloudFile[{Object[EmeraldCloudFile, "IMG Test for PlotCloudFile.jpg"],Object[EmeraldCloudFile, "PDF Test for PlotCloudFile.pdf"],Object[EmeraldCloudFile, "TXT Test for PlotCloudFile.txt"],Object[EmeraldCloudFile, "XLSX Test for PlotCloudFile.xlsx"]}],
		{ZoomableP,ZoomableP,_String,Null}
	],
	Example[{Additional,"If a file type cannot be converted to an image or snippet, returns Null:"},
		PlotCloudFile[Object[EmeraldCloudFile, "XLSX Test for PlotCloudFile.xlsx"]],
		Null
	],
	Test["Wolfram notebooks files can't be previewed:",
		PlotCloudFile[Object[EmeraldCloudFile, "NB Test for PlotCloudFile.nb"]],
		Null
	],
	Test["Microscoft document files can't be previewed:",
		PlotCloudFile[Object[EmeraldCloudFile, "DOCX Test for PlotCloudFile.docx"]],
		Null
	],
	Test["Excel files can't be previewed:",
		PlotCloudFile[Object[EmeraldCloudFile, "XLSX Test for PlotCloudFile.xlsx"]],
		Null
	],

	(* Options *)

	Example[{Options,RulerPlacement,"Place a ruler only on the left frame:"},
		PlotCloudFile[Object[EmeraldCloudFile, "IMG Test for PlotCloudFile.jpg"],RulerPlacement->Left],
		ZoomableP
	],
	
	Example[{Options,RulerType,"Relative ruler type resets each ruler to start at zero during every zoom:"},
		PlotCloudFile[Object[EmeraldCloudFile, "Test for PlotCloudFile - Landscape.jpg"],RulerPlacement->{Left,Top},RulerType->Relative],
		ZoomableP
	],
	Example[{Options,RulerType,"Absolute ruler type preserves the absolute positions in the image during zooming:"},
		PlotCloudFile[Object[EmeraldCloudFile, "IMG Test for PlotCloudFile.jpg"],RulerPlacement->{Left,Top},RulerType->Absolute],
		ZoomableP
	],
	
	Example[{Options,ImageSize,"Specify the width and height for the final plot -- Note that the size of the background is changed rather than the image itself. Use AspectRatio is you would like to control the height-to-width ratio of the image:"},
		PlotCloudFile[Object[EmeraldCloudFile, "Test for PlotCloudFile - Bird.jpg"], ImageSize -> {300,200}],
		ZoomableP
	],

	Example[{Options,MeasurementLines,"Add a measurement line to the image.  Use RightClick+Dragging to move the points:"},
		PlotCloudFile[Object[EmeraldCloudFile, "Test for PlotCloudFile - Bird.jpg"],RulerPlacement->{Top,Bottom},MeasurementLines->{{{48,32},{144,32}}}],
		ZoomableP
	],

	Example[{Options,MeasurementLines,"Measurement line labels appear on mouseover:"},
		PlotCloudFile[Object[EmeraldCloudFile, "Test for PlotCloudFile - Landscape.jpg"],MeasurementLines->{{{48,32},{144,32}},{{150,60},{150,100}}},MeasurementLabel->False],
		{},
		EquivalenceFunction->(MatchQ[Cases[Staticize[#1],_Text,Infinity],#2]&)
	],

	Example[{Options,MeasurementLabel,"Remove measurement line labels -- they appear on mouseover:"},
		PlotCloudFile[Object[EmeraldCloudFile, "Test for PlotCloudFile - Landscape.jpg"],MeasurementLines->{{{48,32},{144,32}},{{150,60},{150,100}}},MeasurementLabel->False],
		{},
		EquivalenceFunction->(MatchQ[Cases[Staticize[#1],_Text,Infinity],#2]&)
	],


	Example[{Options,Background,"The background style. For nontransparent images, the image needs to become transparent first for the background to be effective:"},
		PlotCloudFile[Object[EmeraldCloudFile, "Test for PlotCloudFile - Landscape.jpg"],Prolog->Disk[{150,150},10],BaseStyle->{Opacity[0.50],Yellow}],
		ZoomableP
	],

	Example[{Options,PlotLabel,"The title of the plot:"},
		PlotCloudFile[Object[EmeraldCloudFile, "PDF Test for PlotCloudFile.pdf"],PlotLabel->"My Data"],
		ZoomableP
	],

	Example[{Options,Prolog,"Prolog can be any valid graphic primitive and is rendered before the main image, therefore only appearing if the image is transparent:"},
		PlotCloudFile[Object[EmeraldCloudFile, "Test for PlotCloudFile - Landscape.jpg"],Prolog->Disk[{150,150},10],BaseStyle->{Opacity[0.50],Yellow}],
		ZoomableP
	],

	Example[{Options,Epilog,"Epilog can be any valid graphic primitive and is rendered after the main image:"},
		PlotCloudFile[Object[EmeraldCloudFile, "Test for PlotCloudFile - Landscape.jpg"],Epilog->Disk[{150,150},10],BaseStyle->Yellow],
		ZoomableP
	],

	(* Output tests *)
  Test[
    "Setting Output to Result displays the image:",
    PlotCloudFile[Object[EmeraldCloudFile, "Test for PlotCloudFile - Bird.jpg"],Output->Result],
    ZoomableP
  ],

  Test[
    "Setting Output to Preview displays the image:",
    PlotCloudFile[Object[EmeraldCloudFile, "Test for PlotCloudFile - Bird.jpg"],Output->Preview],
    ZoomableP
  ],

  Test[
    "Setting Output to Options returns the resolved options:",
    PlotCloudFile[Object[EmeraldCloudFile, "Test for PlotCloudFile - Bird.jpg"],Output->Options],
    ops_/;MatchQ[ops,OptionsPattern[PlotCloudFile]]
  ],

  Test[
    "Setting Output to Tests returns a list of tests or Null if it is empty:",
    PlotCloudFile[Object[EmeraldCloudFile, "Test for PlotCloudFile - Bird.jpg"],Output->Tests],
    {(_EmeraldTest|_Example)...}|Null
  ],

  Test[
    "Setting Output to {Result,Options} displays the image and returns all resolved options:",
    PlotCloudFile[Object[EmeraldCloudFile, "Test for PlotCloudFile - Bird.jpg"],Output->{Result,Options}],
    output_List/;MatchQ[First@output,ZoomableP]&&MatchQ[Last@output,OptionsPattern[PlotCloudFile]]
  ],

	(* Flag controlled tests by ECL`$CCD *)
	Sequence@@If[Not@ECL`$CCD,
		(* Old Zoomable Tests *)
		{
			Example[{Options,TargetUnits,"Display the side rulers in Inches and the top and bottom rulers in Centimeters. Note that the Scale needs to be specified together with the TargetUnits:"},
				PlotCloudFile[Object[EmeraldCloudFile, "Test for PlotCloudFile - Landscape.jpg"],RulerPlacement->{Top,Left},Scale->72*Pixel/Inch,TargetUnits->{Inch,Centimeter}],
				{{{Style["Inches", GrayLevel[0], Bold, 13], Style["Inches", GrayLevel[0], Bold, 13]}, {Style["Centimeters", GrayLevel[0], Bold, 13], Style["Centimeters", GrayLevel[0], Bold, 13]}}},
				EquivalenceFunction->(MatchQ[Cases[Staticize[#1],Rule[FrameLabel,f_]:>f,Infinity],#2]&)
			],
			Example[{Options,MeasurementLines,"Label measurement lines with distance:"},
				PlotCloudFile[Object[EmeraldCloudFile, "IMG Test for PlotCloudFile.jpg"],MeasurementLines->{{{48,32},{144,32}},{{150,60},{150,100}}},MeasurementLabel->True],
				{Text[Row[{" ", _NumberForm, " "}], {96,32}, Background -> GrayLevel[1]],
					Text[Row[{" ", _NumberForm, " "}], {150,80}, Background -> GrayLevel[1]]},
				EquivalenceFunction->(MatchQ[Cases[Staticize[#1],_Text,Infinity],#2]&)
			],
			Example[{Options,RulerPlacement,"Place rulers on the top and right frames:"},
				PlotCloudFile[Object[EmeraldCloudFile, "Test for PlotCloudFile - Bird.jpg"],RulerPlacement->{Top,Right}],
				{{{False,True},{False,True}}},
				EquivalenceFunction->(MatchQ[Cases[Staticize[#1],Rule[Frame,f_]:>f,Infinity],#2]&)
			],
			Example[{Options,TargetUnits,"Specify a different distance unit for each frame ruler. Note that the Scale needs to be specified together with the TargetUnits:"},
				PlotCloudFile[Object[EmeraldCloudFile, "Test for PlotCloudFile - Landscape.jpg"],Scale->72*Pixel/Inch,TargetUnits->{{Centimeter,Meter},{Inch,Foot}}],
				{{{Style["Centimeters", GrayLevel[0], Bold, 13], Style["Meters", GrayLevel[0], Bold, 13]}, {Style["Inches", GrayLevel[0], Bold, 13], Style["Feet", GrayLevel[0], Bold, 13]}}},
				EquivalenceFunction->(MatchQ[Cases[Staticize[#1],Rule[FrameLabel,f_]:>f,Infinity],#2]&)
			],
			Example[{Options,ImageSize,"Specify different image size for the final plots:"},
				{
					PlotCloudFile[Object[EmeraldCloudFile, "Test for PlotCloudFile - Bird.jpg"], ImageSize -> 100],
					PlotCloudFile[Object[EmeraldCloudFile, "Test for PlotCloudFile - Bird.jpg"], ImageSize -> 400]
				},
				ConstantArray[ZoomableP,2]
			],
			Example[{Options,TargetUnits,"Specify distance unit for frame rulers. Note that the Scale needs to be specified together with the TargetUnits:"},
				PlotCloudFile[Object[EmeraldCloudFile, "Test for PlotCloudFile - Landscape.jpg"],RulerPlacement->{Top,Left},Scale->72*Pixel/Inch,TargetUnits->Inch],
				{{{Style["Inches", GrayLevel[0], Bold, 13], Style["Inches", GrayLevel[0], Bold, 13]}, {Style["Inches", GrayLevel[0], Bold, 13], Style["Inches", GrayLevel[0], Bold, 13]}}},
				EquivalenceFunction->(MatchQ[Cases[Staticize[#1],Rule[FrameLabel,f_]:>f,Infinity],#2]&)
			],
			Example[{Options,AspectRatio,"Specify the height-to-width ratio of the image:"},
				Table[PlotCloudFile[Object[EmeraldCloudFile, "Test for PlotCloudFile - Bird.jpg"],AspectRatio->ar],{ar,{0.5,2}}],
				{g1_,g2_}/;And@@MapThread[
					(MatchQ[#1,ZoomableP]&&(First@Cases[Staticize[#1],Rule[AspectRatio,ar_]:>ar,Infinity])==#2)&,
					{{g1,g2},{0.5,2}}
				]
			],
			Example[{Options,Scale,"Specify the scale of the image in terms of pixels/distance. This can be found using Options[Import[\"address\\of\\the\\file\"],ImageResolution]:"},
				PlotCloudFile[Object[EmeraldCloudFile, "Test for PlotCloudFile - Bird.jpg"],Scale->72*Pixel/Inch],
				{{{Style["Inches", GrayLevel[0], Bold, 13], Style["Inches", GrayLevel[0], Bold, 13]}, {Style["Inches", GrayLevel[0], Bold, 13], Style["Inches", GrayLevel[0], Bold, 13]}}},
				EquivalenceFunction->(MatchQ[Cases[Staticize[#1],Rule[FrameLabel,f_]:>f,Infinity],#2]&)
			],
			Example[{Options,MeasurementLines,"Specify two measurement lines.  Use Ctrl+LeftClick to add or Ctrl+RightClick to remove measurement lines:"},
				PlotCloudFile[Object[EmeraldCloudFile, "Test for PlotCloudFile - Landscape.jpg"],MeasurementLines->{{{48,32},{144,32}},{{150,60},{150,100}}}],
				{Disk[{48,32},2.005`],Disk[{144,32},2.005`],Disk[{150,60},2.005`],Disk[{150,100},2.005`]},
				EquivalenceFunction->(MatchQ[Cases[Staticize[#1],_Disk,Infinity],#2]&)
			]
		}
	]

},
	SymbolSetUp:>{
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
		$CreatedObjects = {};

		Module[{nbS3,txtS3,pdfS3,imgS3,docS3,xlsS3,objects},

			(* S3 buckets *)
			nbS3=EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "76cd5dcd63dd0b66f485ee0cb4a8bb9e.nb", "L8kPEjnezORNsqRVbp1NJJXlF3mKJNv3ozWj"];
			txtS3=EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "71bc46effed544e6ff716ed55b5bfa48.txt", "9RdZXv1GmNB6F10kDAK3bbDKuPNM6lGP7xqO"];
			pdfS3=EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "9fdc0b33f7fffb7d39e25ab2a296165b.pdf", "o1k9jAGEaoXmFA7VlPmXGGnKskD4ZBAk8o9K"];
			imgS3=EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "a6e9c02208233f23ec3350ebcb5d00c3.jpg", "N80DNj14evGviRlWZV50jjp0TNO8K0mNrl14"];
			docS3=EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "becd23c3d86687ed945e4ee55458529d.docx", "qdkmxzqEvG5vizYv9rK5EEN8HlPzG7KlkRxO"];
			xlsS3=EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "65e782e51167533d7024aec71b4f61f1.xlsx", "9RdZXv1GmNrDU10kDAK3bbowuPNM6lGP7V36"];

			(* Make files *)
			DownloadCloudFile[nbS3, FileNameJoin[{$TemporaryDirectory, "NB Test for PlotCloudFile.nb"}]];
			DownloadCloudFile[txtS3, FileNameJoin[{$TemporaryDirectory, "TXT Test for PlotCloudFile.txt"}]];
			DownloadCloudFile[pdfS3, FileNameJoin[{$TemporaryDirectory, "PDF Test for PlotCloudFile.pdf"}]];
			DownloadCloudFile[imgS3, FileNameJoin[{$TemporaryDirectory, "IMG Test for PlotCloudFile.jpg"}]];
			DownloadCloudFile[docS3, FileNameJoin[{$TemporaryDirectory, "DOCX Test for PlotCloudFile.docx"}]];
			DownloadCloudFile[xlsS3, FileNameJoin[{$TemporaryDirectory, "XLSX Test for PlotCloudFile.xlsx"}]];

			(* Make Objects *)
			objects=UploadCloudFile[{
				FileNameJoin[{$TemporaryDirectory, "NB Test for PlotCloudFile.nb"}],
				FileNameJoin[{$TemporaryDirectory, "TXT Test for PlotCloudFile.txt"}],
				FileNameJoin[{$TemporaryDirectory, "PDF Test for PlotCloudFile.pdf"}],
				FileNameJoin[{$TemporaryDirectory, "IMG Test for PlotCloudFile.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "DOCX Test for PlotCloudFile.docx"}],
				FileNameJoin[{$TemporaryDirectory, "XLSX Test for PlotCloudFile.xlsx"}]
			}];

			(* Name Objects *)
			Upload[MapThread[<|Object->#1,Name->#2|>&,{objects,{"NB Test for PlotCloudFile.nb","TXT Test for PlotCloudFile.txt","PDF Test for PlotCloudFile.pdf","IMG Test for PlotCloudFile.jpg","DOCX Test for PlotCloudFile.docx","XLSX Test for PlotCloudFile.xlsx"}}]];
		];
	},
	SymbolTearDown:>{
		
		Module[{allObjects, existingObjects},
		
			(* Make a list of all of the fake objects we uploaded for these tests *)
			allObjects = {
				Object[EmeraldCloudFile, "NB Test for PlotCloudFile.nb"],
				Object[EmeraldCloudFile, "TXT Test for PlotCloudFile.txt"],
				Object[EmeraldCloudFile, "PDF Test for PlotCloudFile.pdf"],
				Object[EmeraldCloudFile, "IMG Test for PlotCloudFile.jpg"],
				Object[EmeraldCloudFile, "DOCX Test for PlotCloudFile.docx"],
				Object[EmeraldCloudFile, "XLSX Test for PlotCloudFile.xlsx"]
			};
			
			(*Check whether the created objects and models exist in the database*)
			existingObjects = Join[$CreatedObjects, allObjects];
			
			EraseObject[PickList[existingObjects,DatabaseMemberQ[existingObjects]],Force->True,Verbose->False];
			Unset[$CreatedObjects]
			
		]
	}
];


(* ::Section::Closed:: *)
(*End Test Package*)
