(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ImageProcessing: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*Image Utilities*)


(* ::Subsubsection:: *)
(*CombineFluorescentImages*)


DefineTests[CombineFluorescentImages,{
	Test[
		"If all the images are Null, return Null:",
		CombineFluorescentImages[Null,Null,Null],
		Null
	],
	Example[
		{Basic,"Combine three images as red, green and blue:"},
		CombineFluorescentImages[
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], FluorescenceImage],
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], SecondaryFluorescenceImage],
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], TertiaryFluorescenceImage]
		],
		_Image
	],
	Example[
		{Basic,"Combine two images as red and green:"},
		CombineFluorescentImages[
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], FluorescenceImage],
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], SecondaryFluorescenceImage],
			Null
		],
		_Image
	],
	Example[
		{Basic,"Combine two images as green and blue:"},
		CombineFluorescentImages[
			Null,
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], SecondaryFluorescenceImage],
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], TertiaryFluorescenceImage]
		],
		_Image
	],
	Example[
		{Basic,"Return a red colorized single image:"},
		CombineFluorescentImages[
			Download[Object[Data,Microscope,"id:O81aEB4kXLDD"], FluorescenceImage],
			Null,
			Null
		],
		_Image
	],
	Example[
		{Basic,"Return a blue colorized single image:"},
		CombineFluorescentImages[
			Null,
			Null,
			Download[Object[Data,Microscope,"id:O81aEB4kXLDD"], FluorescenceImage]
		],
		_Image
	],
	Example[
		{Additional,"Combine two images as red and blue:"},
		CombineFluorescentImages[
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], FluorescenceImage],
			Null,
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], TertiaryFluorescenceImage]
		],
		_Image
	],
	Example[
		{Additional,"Return a green colorized single image:"},
		CombineFluorescentImages[
			Null,
			Download[Object[Data,Microscope,"id:O81aEB4kXLDD"], FluorescenceImage],
			Null
		],
		_Image
	],
	Example[
		{Options,ImageDimensions,"Automatically set the dimensions of the final RGB image:"},
		CombineFluorescentImages[
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], FluorescenceImage],
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], SecondaryFluorescenceImage],
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], TertiaryFluorescenceImage],
			ImageDimensions->Automatic
		],
		_Image
	],
	Example[
		{Options,ImageDimensions,"Manually set the dimensions of the final RGB image:"},
		CombineFluorescentImages[
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], FluorescenceImage],
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], SecondaryFluorescenceImage],
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], TertiaryFluorescenceImage],
			ImageDimensions->{200,100}
		],
		_Image
	],
	Example[
		{Options,ImageDimensions,"Manually set the only the x-dimension of the final RGB image:"},
		CombineFluorescentImages[
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], FluorescenceImage],
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], SecondaryFluorescenceImage],
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], TertiaryFluorescenceImage],
			ImageDimensions->{200,Automatic}
		],
		_Image
	],
	Example[
		{Options,ImageDimensions,"Manually set the only the y-dimension of the final RGB image:"},
		CombineFluorescentImages[
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], FluorescenceImage],
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], SecondaryFluorescenceImage],
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], TertiaryFluorescenceImage],
			ImageDimensions->{Automatic,100}
		],
		_Image
	],
	Example[
		{Options,Overlay,"Return all the fluorescent images overlaid onto one image:"},
		CombineFluorescentImages[
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], FluorescenceImage],
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], SecondaryFluorescenceImage],
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], TertiaryFluorescenceImage],
			Overlay->True
		],
		_Image
	],
	Example[
		{Options,Overlay,"Return all the colorized fluorescent images individually:"},
		CombineFluorescentImages[
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], FluorescenceImage],
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], SecondaryFluorescenceImage],
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], TertiaryFluorescenceImage],
			Overlay->False
		],
		{(_Image|Null)..}
	],
	Example[
		{Options,OverlayChannels,"Create an overlaid image with all of the fluorescent channels present:"},
		CombineFluorescentImages[
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], FluorescenceImage],
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], SecondaryFluorescenceImage],
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], TertiaryFluorescenceImage],
			OverlayChannels->All
		],
		_Image
	],
	Example[
		{Options,OverlayChannels,"Create an overlaid image with only a subset of the fluorescent channels present:"},
		CombineFluorescentImages[
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], FluorescenceImage],
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], SecondaryFluorescenceImage],
			Download[Object[Data,Microscope,"id:kEJ9mqaV6XL3"], TertiaryFluorescenceImage],
			OverlayChannels->{RedImage,GreenImage}
		],
		_Image
	]
}];


(* ::Subsubsection::Closed:: *)
(*ImageMask*)


DefineTests[
	ImageMask,
	{
		Example[{Basic, "Remove background colors in an image:"},
			ImageMask[testExampleImage,RGBColor[0.2`,0.2`,0.2`],0.2`],
			_Image
		],

		Example[{Basic, "Remove background colors in an image:"},
			ImageMask[testExampleImage,{RGBColor[0.2`,0.1`,0.1`], RGBColor[0.8`,0.4`,0.2`]},{0.1, .15}],
			_Image
		],

		Example[{Basic, "Remove background colors in an image (replacing them with a specific mask color):"},
			ImageMask[testExampleImage,{RGBColor[0.2`,0.1`,0.1`], RGBColor[0.8`,0.4`,0.2`]},{0.1, .15}, MaskColor->RGBColor[1,1,1]],
			_Image
		],

		Example[{Options, DistanceFunction, "Remove background colors in an image using Manhattan disance metric:"},
			ImageMask[testExampleImage,{RGBColor[0.2`,0.1`,0.1`], RGBColor[0.8`,0.4`,0.2`]},{0.1, .15}, MaskColor->RGBColor[1,1,1], DistanceFunction->ManhattanDistance],
			_Image
		],

		Example[{Options, DistanceFunction, "Remove background colors in an image using Squared Euclidean disance metric:"},
			ImageMask[testExampleImage,{RGBColor[0.2`,0.1`,0.1`], RGBColor[0.8`,0.4`,0.2`]},{0.1, .15}, MaskColor->RGBColor[1,1,1], DistanceFunction->SquaredEuclideanDistance],
			_Image
		],

		Example[{Options, MaskColor, "Remove background colors in an image using a single threshold and multiple foreground colors:"},
			ImageMask[testExampleImage, {Darker[Green], Pink}, .5, MaskColor->Blue],
			 _Image
		],

		Test["Replaces pixels with the default MaskColor where DistanceFunction[pixel,selectedColor] >= colorRange:",
			Module[{img},
				img=ImageMask[testImage,RGBColor[0,0,0],1];
				ImageData[img]
			],
			{{{0`, 0`, 0`}, {0`, 0`, 0`}}, {{0`, 0`, 0`}, {0`, 0`, 0`}}}
		],

		Test["Replaces pixels with the specified MaskColor where DistanceFunction[pixel,selectedColor] >= colorRange:",
			Module[{img},
				img=ImageMask[testImage,RGBColor[0,0,0],1,MaskColor->RGBColor[1,1,1]];
				ImageData[img]
			],
			{{{1`, 1`, 1`}, {1`, 1`, 1`}}, {{0`, 0`, 0`}, {0`, 0`, 0`}}}
		],

		Test["Replaces pixels with the specified MaskColor where DistanceFunction[pixel,selectedColor] >= colorRange for all selected colors:",
			Module[{img},
				img=ImageMask[testImage,{RGBColor[1,1,0],RGBColor[0,1,1]},1,MaskColor->RGBColor[1,1,1]];
				ImageData[img]
			],
			{{{1`, 1`, 1`}, {1`, 1`, 1`}}, {{1`, 1`, 1`}, {1`, 1`, 1`}}}
		],

		Test["Replaces pixels with the specified MaskColor where DistanceFunction[pixel,selectedColor] >= colorRange for all selected color/range pairs:",
			Module[{img},
				img=ImageMask[testImage,{RGBColor[1,1,0],RGBColor[1,1,1]},{1.4,1.7},MaskColor->RGBColor[0.5,0.5,0.5]];
				ImageData[img]
			],
			{{{0`, 0`, 1`}, {0`, 0`, 1`}}, {{0.5`, 0.5`, 0.5`}, {0.5`, 0.5`, 0.5`}}}
		],

		Test["Replaces pixels with the specified MaskColor where DistanceFunction[pixel,selectedColor] >= colorRange for all selected color/range pairs using non-RGB colors:",
			Module[{img},
				img=ImageMask[testImage,{CMYKColor[0, 0, 1, 0],CMYKColor[0, 0, 0, 0]},{1.4,1.7},MaskColor->CMYKColor[0,0,0,1]];
				ImageData[img]
			],
			{{{0`, 0`, 1`}, {0`, 0`, 1`}}, {{0`, 0`, 0`}, {0`, 0`, 0`}}}
		]
	},
	Variables:>{testExampleImage,testImage},
	SetUp:>(
		testExampleImage=ImportCloudFile[Object[EmeraldCloudFile, "example-lena"]];
		testImage=Image[{{{0, 0, 1}, {0, 0, 1}}, {{0, 0, 0}, {0, 0, 0}}}];
	)
];


(* ::Subsubsection::Closed:: *)
(*ImageIntensity*)


DefineTests[ImageIntensity,
{
		Example[
			{Basic,"Average intensities vertically:"},
			ImageIntensity[ImportCloudFile[Object[EmeraldCloudFile, "example-lena-tif"]]],
			{{1,0.293396},{2,0.293982},{3,0.305308},{4,0.327552},{5,0.328668},{6,0.313094},{7,0.302344},{8,0.284517},{9,0.390917},{10,0.523439},{11,0.624003},{12,0.664593},{13,0.679502},{14,0.679761},{15,0.683029},{16,0.678995},{17,0.639599},{18,0.55755},{19,0.425423},{20,0.290703},{21,0.236646},{22,0.279648},{23,0.303831},{24,0.309139},{25,0.315021},{26,0.311821},{27,0.302885},{28,0.294715},{29,0.291729},{30,0.300192},{31,0.323101},{32,0.307967},{33,0.318357},{34,0.347656},{35,0.350473},{36,0.403629},{37,0.443036},{38,0.458339},{39,0.429637},{40,0.410908},{41,0.386286},{42,0.36501},{43,0.3635},{44,0.376944},{45,0.367951},{46,0.409263},{47,0.441379},{48,0.417568},{49,0.399437},{50,0.366081},{51,0.371287},{52,0.358756},{53,0.312711},{54,0.296788},{55,0.299189},{56,0.304339},{57,0.301623},{58,0.297735},{59,0.305139},{60,0.306705},{61,0.321197},{62,0.323169},{63,0.322932},{64,0.358722},{65,0.387075},{66,0.407009},{67,0.44378},{68,0.459612},{69,0.452366},{70,0.458857},{71,0.504057},{72,0.537277},{73,0.549437},{74,0.567681},{75,0.580088},{76,0.587751},{77,0.589599},{78,0.590297},{79,0.608001},{80,0.626854},{81,0.63819},{82,0.63197},{83,0.62638},{84,0.6206},{85,0.625479},{86,0.643306},{87,0.657088},{88,0.655792},{89,0.673394},{90,0.681339},{91,0.705082},{92,0.722403},{93,0.70844},{94,0.670453},{95,0.629615},{96,0.602806},{97,0.576335},{98,0.572605},{99,0.569506},{100,0.535057},{101,0.487232},{102,0.448355},{103,0.435069},{104,0.433908},{105,0.428781},{106,0.418627},{107,0.399279},{108,0.396146},{109,0.385114},{110,0.407809},{111,0.464221},{112,0.423214},{113,0.410886},{114,0.421602},{115,0.448118},{116,0.465765},{117,0.479333},{118,0.496383},{119,0.506998},{120,0.510322},{121,0.5024},{122,0.488427},{123,0.439959},{124,0.418413},{125,0.426211},{126,0.430832},{127,0.448794},{128,0.463917},{129,0.473913},{130,0.477316},{131,0.481587},{132,0.5016},{133,0.529885},{134,0.554147},{135,0.559308},{136,0.566734},{137,0.562396},{138,0.558891},{139,0.557573},{140,0.560525},{141,0.566002},{142,0.572335},{143,0.576347},{144,0.576189},{145,0.574093},{146,0.575986},{147,0.58002},{148,0.580302},{149,0.583604},{150,0.584336}},
			EquivalenceFunction->RoundMatchQ[6]
		],
		Example[
			{Basic,"Rotate 90 degrees before computing intensities:"},
			ImageIntensity[{ImportCloudFile[Object[EmeraldCloudFile, "example-lena-tif"]]},Rotate->True],
			{{{1,0.477525},{2,0.470466},{3,0.467773},{4,0.470902},{5,0.472122},{6,0.472357},{7,0.471329},{8,0.471155},{9,0.473481},{10,0.477481},{11,0.480139},{12,0.481264},{13,0.483765},{14,0.489865},{15,0.50251},{16,0.515085},{17,0.526684},{18,0.539529},{19,0.55295},{20,0.562614},{21,0.569499},{22,0.57295},{23,0.574588},{24,0.577107},{25,0.577394},{26,0.573081},{27,0.569569},{28,0.562336},{29,0.560845},{30,0.562362},{31,0.554492},{32,0.546039},{33,0.529603},{34,0.504235},{35,0.493464},{36,0.487259},{37,0.481926},{38,0.481342},{39,0.474597},{40,0.467852},{41,0.458013},{42,0.460749},{43,0.453481},{44,0.445743},{45,0.448436},{46,0.453473},{47,0.452932},{48,0.454379},{49,0.463007},{50,0.463834},{51,0.462379},{52,0.469168},{53,0.46258},{54,0.445743},{55,0.438153},{56,0.436837},{57,0.41288},{58,0.397107},{59,0.401002},{60,0.402135},{61,0.421795},{62,0.445656},{63,0.444131},{64,0.454318},{65,0.460993},{66,0.470231},{67,0.473664},{68,0.465638},{69,0.459294},{70,0.46149},{71,0.466458},{72,0.468837},{73,0.460009},{74,0.456453},{75,0.457595},{76,0.45044},{77,0.448784},{78,0.462832},{79,0.470832},{80,0.473908},{81,0.469325},{82,0.468898},{83,0.456932},{84,0.442083},{85,0.448061},{86,0.45702},{87,0.449638},{88,0.442039},{89,0.434937},{90,0.433865},{91,0.426937},{92,0.421081},{93,0.411102},{94,0.386118},{95,0.38373},{96,0.387486},{97,0.395773},{98,0.396436},{99,0.401769},{100,0.417699},{101,0.429089},{102,0.431861},{103,0.437307},{104,0.440122},{105,0.440837},{106,0.443233},{107,0.445237},{108,0.448688},{109,0.453438},{110,0.449455},{111,0.45349},{112,0.446684},{113,0.439503},{114,0.442031},{115,0.438693},{116,0.431129}}},
			EquivalenceFunction->RoundMatchQ[6]
		],
		Test[
			"Normalize intensities:",
			ImageIntensity[{ImportCloudFile[Object[EmeraldCloudFile, "example-lena-tif"]]},Normalize->True],
			{{{1,0.116828},{2,0.118035},{3,0.141349},{4,0.187143},{5,0.18944},{6,0.157379},{7,0.135248},{8,0.0985478},{9,0.317589},{10,0.590405},{11,0.79743},{12,0.880991},{13,0.911683},{14,0.912216},{15,0.918944},{16,0.910639},{17,0.829536},{18,0.660627},{19,0.388623},{20,0.111284},{21,0.},{22,0.088526},{23,0.13831},{24,0.149237},{25,0.161346},{26,0.154758},{27,0.136362},{28,0.119543},{29,0.113395},{30,0.130817},{31,0.17798},{32,0.146824},{33,0.168213},{34,0.22853},{35,0.234329},{36,0.343757},{37,0.424883},{38,0.456387},{39,0.3973},{40,0.358744},{41,0.308055},{42,0.264256},{43,0.261147},{44,0.288823},{45,0.27031},{46,0.355357},{47,0.421473},{48,0.372454},{49,0.335127},{50,0.266459},{51,0.277177},{52,0.25138},{53,0.156591},{54,0.123811},{55,0.128752},{56,0.139354},{57,0.133763},{58,0.12576},{59,0.141001},{60,0.144226},{61,0.174059},{62,0.178119},{63,0.177632},{64,0.251311},{65,0.309678},{66,0.350717},{67,0.426414},{68,0.459008},{69,0.444091},{70,0.457454},{71,0.550503},{72,0.618893},{73,0.643924},{74,0.681483},{75,0.707025},{76,0.7228},{77,0.726604},{78,0.728042},{79,0.764488},{80,0.803299},{81,0.826637},{82,0.813831},{83,0.802325},{84,0.790424},{85,0.800469},{86,0.837169},{87,0.865541},{88,0.862873},{89,0.899109},{90,0.915464},{91,0.964344},{92,1.},{93,0.971257},{94,0.893054},{95,0.808983},{96,0.753793},{97,0.699299},{98,0.691621},{99,0.685241},{100,0.614323},{101,0.515868},{102,0.435833},{103,0.408481},{104,0.406092},{105,0.395537},{106,0.374635},{107,0.334803},{108,0.328353},{109,0.305642},{110,0.352364},{111,0.468496},{112,0.384076},{113,0.358697},{114,0.380759},{115,0.435345},{116,0.471674},{117,0.499606},{118,0.534705},{119,0.556558},{120,0.563402},{121,0.547093},{122,0.518327},{123,0.41855},{124,0.374194},{125,0.390247},{126,0.399759},{127,0.436737},{128,0.46787},{129,0.488447},{130,0.495453},{131,0.504245},{132,0.545446},{133,0.603675},{134,0.653621},{135,0.664246},{136,0.679534},{137,0.670603},{138,0.663388},{139,0.660674},{140,0.666752},{141,0.678026},{142,0.691064},{143,0.699323},{144,0.698998},{145,0.694683},{146,0.69858},{147,0.706885},{148,0.707465},{149,0.714263},{150,0.71577}}},
			EquivalenceFunction->RoundMatchQ[6]
		],
		Example[
			{Basic,"Visualize with and without inverting:"},
			ListLinePlot[{ImageIntensity[ImportCloudFile[Object[EmeraldCloudFile, "example-lena-tif"]],InvertIntensity->False],ImageIntensity[ImportCloudFile[Object[EmeraldCloudFile, "example-lena-tif"]],InvertIntensity->True]}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,Rotate,"Visualize different rotations:"},
			ListLinePlot[{ImageIntensity[ImportCloudFile[Object[EmeraldCloudFile, "example-lena-tif"]],Rotate->False],ImageIntensity[ImportCloudFile[Object[EmeraldCloudFile, "example-lena-tif"]],Rotate->\[Pi]/2],ImageIntensity[ImportCloudFile[Object[EmeraldCloudFile, "example-lena-tif"]],Rotate->\[Pi]],ImageIntensity[ImportCloudFile[Object[EmeraldCloudFile, "example-lena-tif"]],Rotate->(3 \[Pi])/2]}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,Normalize,"Normalize:"},
			ListLinePlot[ImageIntensity[{ImportCloudFile[Object[EmeraldCloudFile, "example-lena-tif"]]},Normalize->True]],
			_?ValidGraphicsQ
		],
		Example[
			{Options,AveragingFunction,"Different averaging functions:"},
			ListLinePlot[{ImageIntensity[ImportCloudFile[Object[EmeraldCloudFile, "example-lena-tif"]]],ImageIntensity[ImportCloudFile[Object[EmeraldCloudFile, "example-lena-tif"]],AveragingFunction->First],ImageIntensity[ImportCloudFile[Object[EmeraldCloudFile, "example-lena-tif"]],AveragingFunction->Max]}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,ImageApply,"Different ImageApply functions:"},
			ListLinePlot[{ImageIntensity[ImportCloudFile[Object[EmeraldCloudFile, "example-lena-tif"]]],ImageIntensity[ImportCloudFile[Object[EmeraldCloudFile, "example-lena-tif"]],ImageApply->First],ImageIntensity[ImportCloudFile[Object[EmeraldCloudFile, "example-lena-tif"]],ImageApply->Max]}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,InvertIntensity,"Invert intensity:"},
			ImageIntensity[{ImportCloudFile[Object[EmeraldCloudFile, "example-lena-tif"]]},Rotate->False,InvertIntensity->True],
			{{{1,0.665652},{2,0.665066},{3,0.653741},{4,0.631497},{5,0.630381},{6,0.645954},{7,0.656705},{8,0.674532},{9,0.568132},{10,0.43561},{11,0.335046},{12,0.294456},{13,0.279547},{14,0.279288},{15,0.27602},{16,0.280054},{17,0.31945},{18,0.401499},{19,0.533626},{20,0.668346},{21,0.722403},{22,0.6794},{23,0.655217},{24,0.64991},{25,0.644027},{26,0.647228},{27,0.656164},{28,0.664334},{29,0.66732},{30,0.658857},{31,0.635948},{32,0.651082},{33,0.640692},{34,0.611393},{35,0.608576},{36,0.55542},{37,0.516013},{38,0.50071},{39,0.529412},{40,0.548141},{41,0.572763},{42,0.594039},{43,0.595549},{44,0.582105},{45,0.591098},{46,0.549786},{47,0.51767},{48,0.541481},{49,0.559612},{50,0.592968},{51,0.587762},{52,0.600293},{53,0.646338},{54,0.662261},{55,0.65986},{56,0.65471},{57,0.657426},{58,0.661314},{59,0.65391},{60,0.652344},{61,0.637852},{62,0.63588},{63,0.636117},{64,0.600327},{65,0.571974},{66,0.55204},{67,0.515269},{68,0.499437},{69,0.506682},{70,0.500192},{71,0.454992},{72,0.421771},{73,0.409612},{74,0.391368},{75,0.378961},{76,0.371298},{77,0.36945},{78,0.368751},{79,0.351048},{80,0.332195},{81,0.320859},{82,0.327079},{83,0.332668},{84,0.338449},{85,0.33357},{86,0.315743},{87,0.301961},{88,0.303257},{89,0.285655},{90,0.27771},{91,0.253967},{92,0.236646},{93,0.250609},{94,0.288596},{95,0.329434},{96,0.356243},{97,0.382714},{98,0.386444},{99,0.389542},{100,0.423991},{101,0.471817},{102,0.510694},{103,0.52398},{104,0.525141},{105,0.530268},{106,0.540421},{107,0.55977},{108,0.562903},{109,0.573935},{110,0.55124},{111,0.494828},{112,0.535835},{113,0.548163},{114,0.537446},{115,0.510931},{116,0.493284},{117,0.479716},{118,0.462666},{119,0.452051},{120,0.448727},{121,0.456649},{122,0.470622},{123,0.519089},{124,0.540636},{125,0.532838},{126,0.528217},{127,0.510255},{128,0.495132},{129,0.485136},{130,0.481733},{131,0.477462},{132,0.457449},{133,0.429164},{134,0.404902},{135,0.399741},{136,0.392315},{137,0.396653},{138,0.400158},{139,0.401476},{140,0.398524},{141,0.393047},{142,0.386714},{143,0.382702},{144,0.38286},{145,0.384956},{146,0.383063},{147,0.379029},{148,0.378747},{149,0.375445},{150,0.374713}}},
			EquivalenceFunction->RoundMatchQ[6]
		],
		Test[
			"Invert intensity:",
			ImageIntensity[ImportCloudFile[Object[EmeraldCloudFile, "example-lena-tif"]],Rotate->(3 \[Pi])/2,InvertIntensity->False],
			{{1,0.431129},{2,0.438693},{3,0.442031},{4,0.439503},{5,0.446684},{6,0.45349},{7,0.449455},{8,0.453438},{9,0.448688},{10,0.445237},{11,0.443233},{12,0.440837},{13,0.440122},{14,0.437307},{15,0.431861},{16,0.429089},{17,0.417699},{18,0.401769},{19,0.396436},{20,0.395773},{21,0.387486},{22,0.38373},{23,0.386118},{24,0.411102},{25,0.421081},{26,0.426937},{27,0.433865},{28,0.434937},{29,0.442039},{30,0.449638},{31,0.45702},{32,0.448061},{33,0.442083},{34,0.456932},{35,0.468898},{36,0.469325},{37,0.473908},{38,0.470832},{39,0.462832},{40,0.448784},{41,0.45044},{42,0.457595},{43,0.456453},{44,0.460009},{45,0.468837},{46,0.466458},{47,0.46149},{48,0.459294},{49,0.465638},{50,0.473664},{51,0.470231},{52,0.460993},{53,0.454318},{54,0.444131},{55,0.445656},{56,0.421795},{57,0.402135},{58,0.401002},{59,0.397107},{60,0.41288},{61,0.436837},{62,0.438153},{63,0.445743},{64,0.46258},{65,0.469168},{66,0.462379},{67,0.463834},{68,0.463007},{69,0.454379},{70,0.452932},{71,0.453473},{72,0.448436},{73,0.445743},{74,0.453481},{75,0.460749},{76,0.458013},{77,0.467852},{78,0.474597},{79,0.481342},{80,0.481926},{81,0.487259},{82,0.493464},{83,0.504235},{84,0.529603},{85,0.546039},{86,0.554492},{87,0.562362},{88,0.560845},{89,0.562336},{90,0.569569},{91,0.573081},{92,0.577394},{93,0.577107},{94,0.574588},{95,0.57295},{96,0.569499},{97,0.562614},{98,0.55295},{99,0.539529},{100,0.526684},{101,0.515085},{102,0.50251},{103,0.489865},{104,0.483765},{105,0.481264},{106,0.480139},{107,0.477481},{108,0.473481},{109,0.471155},{110,0.471329},{111,0.472357},{112,0.472122},{113,0.470902},{114,0.467773},{115,0.470466},{116,0.477525}},
			EquivalenceFunction->RoundMatchQ[6]
		]
}];


(* ::Subsubsection::Closed:: *)
(*ImageOverlay*)

DefineTests[ImageOverlay,{
	Example[{Basic, "Overlay two images:"},
		ImageOverlay[{ImportCloudFile[Object[EmeraldCloudFile, "example-ocelot-jpg"]], ImportCloudFile[Object[EmeraldCloudFile, "example-ocelot-jpg"]]}],
		_?ValidGraphicsQ
	],
	Example[{Options, Contrast, "Adjust the contrast of the first image:"},
		ImageOverlay[
			{ImportCloudFile[Object[EmeraldCloudFile, "example-ocelot-jpg"]], ImportCloudFile[Object[EmeraldCloudFile, "example-ocelot-jpg"]]},
			Contrast->{.5,0}
		],
		_?ValidGraphicsQ
	],
	Example[{Options, Contrast, "Adjust the contrast of the second image:"},
		ImageOverlay[
			{ImportCloudFile[Object[EmeraldCloudFile, "example-ocelot-jpg"]], ImportCloudFile[Object[EmeraldCloudFile, "example-ocelot-jpg"]]},
			Contrast->{0,.5}
		],
		_?ValidGraphicsQ
	],
	Example[{Options, Brightness, "Adjust the brightness of the first image:"},
		ImageOverlay[
			{ImportCloudFile[Object[EmeraldCloudFile, "example-ocelot-jpg"]], ImportCloudFile[Object[EmeraldCloudFile, "example-ocelot-jpg"]]},
			Brightness->{.5,0}
		],
		_?ValidGraphicsQ
	],
	Example[{Options, Brightness, "Adjust the brightness of the second image:"},
		ImageOverlay[
			{ImportCloudFile[Object[EmeraldCloudFile, "example-ocelot-jpg"]], ImportCloudFile[Object[EmeraldCloudFile, "example-ocelot-jpg"]]},
			Brightness->{0,.5}
		],
		_?ValidGraphicsQ
	],
	Example[{Options, Transparency, "Adjust the transparency of the first image:"},
		ImageOverlay[
			{ImportCloudFile[Object[EmeraldCloudFile, "example-ocelot-jpg"]], ImportCloudFile[Object[EmeraldCloudFile, "example-ocelot-jpg"]]},
			Transparency->{.5,0.75}
		],
		_?ValidGraphicsQ
	],
	Example[{Options, Transparency, "Adjust the transparency of the first image:"},
		ImageOverlay[
			{ImportCloudFile[Object[EmeraldCloudFile, "example-ocelot-jpg"]], ImportCloudFile[Object[EmeraldCloudFile, "example-ocelot-jpg"]]},
			Transparency->{0,.5}
		],
		_?ValidGraphicsQ
	],
	Example[{Options, ImageSize, "Adjust the size of the image:"},
		ImageOverlay[{ImportCloudFile[Object[EmeraldCloudFile, "example-ocelot-jpg"]], ImportCloudFile[Object[EmeraldCloudFile, "example-ocelot-jpg"]]}, ImageSize->700],
		_?ValidGraphicsQ
	],
	Example[{Messages, "IncosistentOptionLengths", "Providing Options with lengths that differ from the input images list throws error message:"},
		ImageOverlay[
			{ImportCloudFile[Object[EmeraldCloudFile, "example-ocelot-jpg"]], ImportCloudFile[Object[EmeraldCloudFile, "example-ocelot-jpg"]]},
			Transparency->{0}
		],
		_?ValidGraphicsQ,
		Messages:>Message[ImageOverlay::InconsistentOptionLengths]
	],
	Test["Providing Brightness optios with lengths that differ from the input images list throws error message:",
		ImageOverlay[
			{ImportCloudFile[Object[EmeraldCloudFile, "example-ocelot-jpg"]], ImportCloudFile[Object[EmeraldCloudFile, "example-ocelot-jpg"]]},
			Brightness->{0}
		],
		_?ValidGraphicsQ,
		Messages:>Message[ImageOverlay::InconsistentOptionLengths]
	],
	Example[{Messages,"InconsistentOptionLengths","Providing Contrast optios with lengths that differ from the input images list throws error message:"},
		ImageOverlay[
			{ImportCloudFile[Object[EmeraldCloudFile, "example-ocelot-jpg"]], ImportCloudFile[Object[EmeraldCloudFile, "example-ocelot-jpg"]]},
			Contrast->{0}
		],
		_?ValidGraphicsQ,
		Messages:>Message[ImageOverlay::InconsistentOptionLengths]
	]
}];
