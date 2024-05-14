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
		testExampleImage=Import["ExampleData/lena.tif"];
		testImage=Image[{{{0, 0, 1}, {0, 0, 1}}, {{0, 0, 0}, {0, 0, 0}}}];
	)
];


(* ::Subsubsection::Closed:: *)
(*ImageIntensity*)


DefineTests[ImageIntensity,
{
		Example[
			{Basic,"Average intensities vertically:"},
			ImageIntensity[Import["ExampleData/lena.tif"]],
			{{1,0.29159341897678587`},{2,0.29146946134775736`},{3,0.30569078205995015`},{4,0.32944557133198077`},{5,0.3264593193599276`},{6,0.31718503493351347`},{7,0.2987491548343472`},{8,0.28743520396664374`},{9,0.3919314852377733`},{10,0.5278679287807082`},{11,0.6156186612576064`},{12,0.664750957854406`},{13,0.6815190443993691`},{14,0.6792540004507552`},{15,0.6805273833671397`},{16,0.6754901960784314`},{17,0.6361730899256254`},{18,0.5539553752535498`},{19,0.43282623394185216`},{20,0.2900270453008786`},{21,0.2396551724137926`},{22,0.27807076853729973`},{23,0.3013297272932162`},{24,0.3067387874690107`},{25,0.3130268199233717`},{26,0.3119675456389454`},{27,0.30376380437232353`},{28,0.2961347757493803`},{29,0.29377958079783617`},{30,0.2977124183006534`},{31,0.3212418300653593`},{32,0.30519495154383586`},{33,0.31635113815641214`},{34,0.3483209375704305`},{35,0.34945909398242064`},{36,0.40173540680640096`},{37,0.4436894297949067`},{38,0.45829389226955175`},{39,0.43737885958981326`},{40,0.41094207798061777`},{41,0.3848884381338744`},{42,0.3644241604687852`},{43,0.36796258733378395`},{44,0.37331530313274724`},{45,0.37274059048906905`},{46,0.40863195853053835`},{47,0.4410187063331076`},{48,0.41903313049357643`},{49,0.40036060401171936`},{50,0.36787243633085437`},{51,0.3710389903087674`},{52,0.3566486364660807`},{53,0.3135226504394858`},{54,0.2917511832319134`},{55,0.2922019382465631`},{56,0.30622041920216364`},{57,0.30193824656299284`},{58,0.29753211629479376`},{59,0.30513860716700486`},{60,0.3069190894748706`},{61,0.3195064232589591`},{62,0.3238562091503271`},{63,0.32011494252873585`},{64,0.36022086995717867`},{65,0.3874352039666444`},{66,0.40826008564345295`},{67,0.4401397340545414`},{68,0.45848546315077765`},{69,0.45116069416272303`},{70,0.458677034032004`},{71,0.5021861618210507`},{72,0.5367928780707686`},{73,0.5497295469912102`},{74,0.568582375478927`},{75,0.5788370520622041`},{76,0.5886522425061979`},{77,0.5912215460897001`},{78,0.5910074374577419`},{79,0.6051273382916386`},{80,0.6265832769889566`},{81,0.6371985575839532`},{82,0.6335474419652918`},{83,0.6269438810006762`},{84,0.6235294117647057`},{85,0.6271579896326349`},{86,0.646258733378409`},{87,0.6536173089925625`},{88,0.6583615055217488`},{89,0.6708474194275413`},{90,0.6808091052512958`},{91,0.7044286680189316`},{92,0.7232814965066482`},{93,0.7121929231462695`},{94,0.6703403200360603`},{95,0.6311471715122834`},{96,0.6018255578093309`},{97,0.5778453910299755`},{98,0.5745436105476673`},{99,0.5680865449628127`},{100,0.5326121253098941`},{101,0.4897340545413571`},{102,0.4478814514311474`},{103,0.436443542934415`},{104,0.4332319134550371`},{105,0.4251521298174444`},{106,0.4204755465404554`},{107,0.3943768311922476`},{108,0.3959432048681548`},{109,0.3882803696191125`},{110,0.4096799639395989`},{111,0.45909398242055427`},{112,0.4233265720081134`},{113,0.40984899707009226`},{114,0.4248027946810908`},{115,0.4471151679062429`},{116,0.46486364660806845`},{117,0.4786342123056119`},{118,0.4964503042596348`},{119,0.5065697543385169`},{120,0.5101983322064456`},{121,0.5045188190218616`},{122,0.488990308767185`},{123,0.4408384043272484`},{124,0.4202389001577645`},{125,0.4261325219743071`},{126,0.4309217940049586`},{127,0.4474306964164977`},{128,0.46197881451431166`},{129,0.4730223123732253`},{130,0.47771016452558057`},{131,0.4839981969799415`},{132,0.5031440162271805`},{133,0.5297272932161371`},{134,0.5535722334910976`},{135,0.5606828938471942`},{136,0.5663286004056792`},{137,0.5622605363984674`},{138,0.5603560964615729`},{139,0.5595560063105701`},{140,0.5602321388325444`},{141,0.5669371196754566`},{142,0.5725152129817443`},{143,0.5775411313950869`},{144,0.5760761775974759`},{145,0.5728307414919994`},{146,0.5768311922470136`},{147,0.5789272030651342`},{148,0.5809556006310569`},{149,0.582195176921343`},{150,0.5858012170385396`}}
		],
		Example[
			{Basic,"Rotate 90 degrees before computing intensities:"},
			ImageIntensity[{Import["ExampleData/lena.tif"]},Rotate->True],
			{{{1,0.47703703703703715`},{2,0.4707015250544663`},{3,0.46697167755991303`},{4,0.4711285403050108`},{5,0.4733856209150327`},{6,0.47122440087145967`},{7,0.471503267973856`},{8,0.4718954248366013`},{9,0.4728627450980394`},{10,0.47621786492374707`},{11,0.479520697167756`},{12,0.4812984749455339`},{13,0.482291938997821`},{14,0.48833115468409594`},{15,0.5029368191721134`},{16,0.5148758169934637`},{17,0.5279389978213506`},{18,0.5385446623093681`},{19,0.5504400871459698`},{20,0.5628061002178646`},{21,0.5693943355119822`},{22,0.5722788671023963`},{23,0.5735860566448799`},{24,0.5776296296296293`},{25,0.5770718954248364`},{26,0.572235294117647`},{27,0.568061002178649`},{28,0.56318082788671`},{29,0.560888888888889`},{30,0.5598954248366013`},{31,0.5565490196078435`},{32,0.5453507625272334`},{33,0.5302396514161218`},{34,0.5049673202614378`},{35,0.49285403050108934`},{36,0.48677995642701544`},{37,0.48334640522875816`},{38,0.4802091503267973`},{39,0.4750501089324622`},{40,0.46694553376906345`},{41,0.45749019607843167`},{42,0.4602004357298475`},{43,0.45322875816993485`},{44,0.44580392156862747`},{45,0.4482614379084966`},{46,0.4526100217864923`},{47,0.4534814814814815`},{48,0.4565751633986929`},{49,0.4638518518518519`},{50,0.4650021786492377`},{51,0.4631372549019608`},{52,0.46820043572984765`},{53,0.4632156862745098`},{54,0.4444618736383445`},{55,0.43778649237472783`},{56,0.4349281045751637`},{57,0.4123660130718956`},{58,0.3974901960784315`},{59,0.400174291938998`},{60,0.40618736383442267`},{61,0.4224313725490197`},{62,0.44595206971677576`},{63,0.4444705882352941`},{64,0.4549629629629633`},{65,0.46084531590413935`},{66,0.4713551198257082`},{67,0.47677559912854045`},{68,0.464583877995643`},{69,0.45986056644880186`},{70,0.4616296296296299`},{71,0.4653246187363837`},{72,0.46874074074074096`},{73,0.4596165577342053`},{74,0.4557211328976039`},{75,0.45705446623093726`},{76,0.44907189542483716`},{77,0.4495773420479305`},{78,0.4614379084967322`},{79,0.473368191721133`},{80,0.47445751633986966`},{81,0.46996949891067563`},{82,0.46834858387799605`},{83,0.4571851851851855`},{84,0.43923311546841`},{85,0.4499172113289765`},{86,0.45884095860566493`},{87,0.4491938997821355`},{88,0.4425533769063183`},{89,0.43593899782135104`},{90,0.43519825708061055`},{91,0.4283137254901965`},{92,0.42054901960784347`},{93,0.4087058823529415`},{94,0.3890283224400878`},{95,0.38153376906318104`},{96,0.3888104575163401`},{97,0.3952505446623098`},{98,0.39500653594771284`},{99,0.400592592592593`},{100,0.4166448801742923`},{101,0.42732897603485875`},{102,0.43456209150326836`},{103,0.43824836601307227`},{104,0.4392766884531594`},{105,0.43998257080610065`},{106,0.44233551198257126`},{107,0.4453333333333336`},{108,0.44743355119825773`},{109,0.4525838779956429`},{110,0.45035294117647096`},{111,0.4515729847494558`},{112,0.4469281045751638`},{113,0.4395729847494559`},{114,0.4406013071895429`},{115,0.4412549019607847`},{116,0.4289324618736387`}}},
			EquivalenceFunction->RoundMatchQ[8]
		],
		Test[
			"Normalize intensities:",
			ImageIntensity[{Import["ExampleData/lena.tif"]},Normalize->True],
			{{{1,0.10739334063424799`},{2,0.10713703194538368`},{3,0.1365426287951166`},{4,0.18566069389752352`},{5,0.17948598457487755`},{6,0.16030943448982984`},{7,0.12218934221870158`},{8,0.0987953491623368`},{9,0.31486357387515546`},{10,0.5959410023999834`},{11,0.7773842533261885`},{12,0.8789756972761382`},{13,0.9136472726425436`},{14,0.9089638138732916`},{15,0.9115968031316265`},{16,0.9011813500477676`},{17,0.8198848940979107`},{18,0.6498823310110223`},{19,0.39942214041055996`},{20,0.10415453083859563`},{21,0.`},{22,0.07943239275811499`},{23,0.12752522310506445`},{24,0.13870960225551765`},{25,0.15171144301791947`},{26,0.1495211687676226`},{27,0.13255819372276798`},{28,0.11678355896265001`},{29,0.11191369387422292`},{30,0.12004566954819834`},{31,0.1686977188526697`},{32,0.13551739403965882`},{33,0.15858517603746897`},{34,0.22468951697462644`},{35,0.22704289675420114`},{36,0.3351352610853523`},{37,0.4218841018710549`},{38,0.45208192557727855`},{39,0.4088356595288597`},{40,0.3541720064310195`},{41,0.30030058018966976`},{42,0.25798634573712137`},{43,0.26530279376470933`},{44,0.2763706689656787`},{45,0.275182328680943`},{46,0.34939534450217896`},{47,0.41636181466551736`},{48,0.3709019735769046`},{49,0.3322925647179444`},{50,0.2651163874455358`},{51,0.27166390940653035`},{52,0.24190880070834503`},{53,0.1527366777733768`},{54,0.10771955169280328`},{55,0.1086515832886747`},{56,0.13763776592026575`},{57,0.1287834657594899`},{58,0.1196728569098502`},{59,0.13540089009017534`},{60,0.13908241489386636`},{61,0.16510939720856713`},{62,0.17410350210872308`},{63,0.1663676398629928`},{64,0.24929515110562428`},{65,0.30556655870634164`},{66,0.3486264184355863`},{67,0.4145443530535695`},{68,0.45247803900552347`},{69,0.43733252557261887`},{70,0.4528741524337693`},{71,0.5428385022252272`},{72,0.6143952279982301`},{73,0.6411445347997305`},{74,0.6801267562970389`},{75,0.7013304751031068`},{76,0.7216254631032001`},{77,0.726938043199665`},{78,0.7264953281916269`},{79,0.7556912179322889`},{80,0.8000559218957533`},{81,0.8220052659785176`},{82,0.8144558100519614`},{83,0.8008015471724502`},{84,0.793741407833726`},{85,0.8012442621804893`},{86,0.840739101055527`},{87,0.8559545168581224`},{88,0.8657641494046654`},{89,0.8915814246102955`},{90,0.9121793228790462`},{91,0.9610177785026918`},{92,0.9999999999999999`},{93,0.9770720227415707`},{94,0.8905328890649399`},{95,0.8094927418039487`},{96,0.7488640864925336`},{97,0.699280005592191`},{98,0.6924528741524346`},{99,0.6791015215415812`},{100,0.6057506349465257`},{101,0.5170911293892879`},{102,0.43055199571265607`},{103,0.4069016939674262`},{104,0.4002609688468447`},{105,0.38355430249085576`},{106,0.373884474683693`},{107,0.31991984528275724`},{108,0.3231586550784095`},{109,0.3073141179486005`},{110,0.35156231796258003`},{111,0.4537362816599489`},{112,0.3797795745275771`},{113,0.35191182981103125`},{114,0.3828319780040552`},{115,0.42896754199967463`},{116,0.4656662860870992`},{117,0.4941398513409614`},{118,0.5309784001677665`},{119,0.5519025094950726`},{120,0.5594053638418348`},{121,0.5476617657338592`},{122,0.5155532772560999`},{123,0.41598900202717026`},{124,0.37339515809586094`},{125,0.38558147121187536`},{126,0.3954843069180061`},{127,0.42961996411678466`},{128,0.45970128387352466`},{129,0.4825360579723665`},{130,0.49222918656942616`},{131,0.5052310273318278`},{132,0.5448190693664524`},{133,0.5997856327329507`},{134,0.6490901041545318`},{135,0.6637929025793986`},{136,0.6754665983176833`},{137,0.6670550131649471`},{138,0.6631171796723914`},{139,0.6614628235897204`},{140,0.6628608709835271`},{141,0.6767248409721102`},{142,0.6882587319710145`},{143,0.6986508842649777`},{144,0.6956217815783966`},{145,0.6889111540881251`},{146,0.6971829345014803`},{147,0.7015168814222814`},{148,0.7057110236037007`},{149,0.7082741104923461`},{150,0.7157303632593155`}}}
		],
		Example[
			{Basic,"Visualize with and without inverting:"},
			ListLinePlot[{ImageIntensity[Import["ExampleData/lena.tif"],InvertIntensity->False],ImageIntensity[Import["ExampleData/lena.tif"],InvertIntensity->True]}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,Rotate,"Visualize different rotations:"},
			ListLinePlot[{ImageIntensity[Import["ExampleData/lena.tif"],Rotate->False],ImageIntensity[Import["ExampleData/lena.tif"],Rotate->\[Pi]/2],ImageIntensity[Import["ExampleData/lena.tif"],Rotate->\[Pi]],ImageIntensity[Import["ExampleData/lena.tif"],Rotate->(3 \[Pi])/2]}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,Normalize,"Normalize:"},
			ListLinePlot[ImageIntensity[{Import["ExampleData/lena.tif"]},Normalize->True]],
			_?ValidGraphicsQ
		],
		Example[
			{Options,AveragingFunction,"Different averaging functions:"},
			ListLinePlot[{ImageIntensity[Import["ExampleData/lena.tif"]],ImageIntensity[Import["ExampleData/lena.tif"],AveragingFunction->First],ImageIntensity[Import["ExampleData/lena.tif"],AveragingFunction->Max]}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,ImageApply,"Different ImageApply functions:"},
			ListLinePlot[{ImageIntensity[Import["ExampleData/lena.tif"]],ImageIntensity[Import["ExampleData/lena.tif"],ImageApply->First],ImageIntensity[Import["ExampleData/lena.tif"],ImageApply->Max]}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,InvertIntensity,"Invert intensity:"},
			ImageIntensity[{Import["ExampleData/lena.tif"]},Rotate->False,InvertIntensity->True],
			{{{1,0.6713432499436549`},{2,0.6714672075726834`},{3,0.6572458868604907`},{4,0.63349109758846`},{5,0.6364773495605132`},{6,0.6457516339869274`},{7,0.6641875140860936`},{8,0.675501464953797`},{9,0.5710051836826675`},{10,0.4350687401397326`},{11,0.3473180076628344`},{12,0.29818571106603486`},{13,0.2814176245210718`},{14,0.2836826684696856`},{15,0.28240928555330114`},{16,0.2874464728420094`},{17,0.32676357899481545`},{18,0.40898129366689107`},{19,0.5301104349785887`},{20,0.6729096236195622`},{21,0.7232814965066482`},{22,0.6848659003831411`},{23,0.6616069416272246`},{24,0.6561978814514301`},{25,0.649909848997069`},{26,0.6509691232814954`},{27,0.6591728645481173`},{28,0.6668018931710605`},{29,0.6691570881226047`},{30,0.6652242506197874`},{31,0.6416948388550815`},{32,0.6577417173766049`},{33,0.6465855307640287`},{34,0.6146157313500104`},{35,0.6134775749380201`},{36,0.5612012621140399`},{37,0.519247239125534`},{38,0.5046427766508891`},{39,0.5255578093306276`},{40,0.5519945909398231`},{41,0.5780482307865664`},{42,0.5985125084516556`},{43,0.5949740815866569`},{44,0.5896213657876935`},{45,0.5901960784313718`},{46,0.5543047103899025`},{47,0.5219179625873333`},{48,0.5439035384268643`},{49,0.5625760649087215`},{50,0.5950642325895864`},{51,0.5918976786116734`},{52,0.6062880324543601`},{53,0.649414018480955`},{54,0.6711854856885274`},{55,0.6707347306738777`},{56,0.6567162497182771`},{57,0.660998422357448`},{58,0.665404552625647`},{59,0.6577980617534359`},{60,0.6560175794455702`},{61,0.6434302456614817`},{62,0.6390804597701137`},{63,0.642821726391705`},{64,0.6027157989632621`},{65,0.5755014649537964`},{66,0.5546765832769879`},{67,0.5227969348658994`},{68,0.5044512057696632`},{69,0.5117759747577177`},{70,0.5042596348884368`},{71,0.46075050709939014`},{72,0.42614379084967224`},{73,0.4132071219292306`},{74,0.39435429344151385`},{75,0.3840996168582367`},{76,0.374284426414243`},{77,0.3717151228307407`},{78,0.37192923146269896`},{79,0.35780933062880227`},{80,0.3363533919314843`},{81,0.32573811133648767`},{82,0.32938922695514905`},{83,0.3359927879197646`},{84,0.33940725715573516`},{85,0.3357786792878059`},{86,0.31667793554203183`},{87,0.3093193599278783`},{88,0.30457516339869206`},{89,0.2920892494928995`},{90,0.28212756366914504`},{91,0.25850800090150927`},{92,0.2396551724137926`},{93,0.25074374577417136`},{94,0.2925963488843806`},{95,0.33178949740815744`},{96,0.36111111111110994`},{97,0.3850912778904654`},{98,0.3883930583727735`},{99,0.3948501239576281`},{100,0.43032454361054673`},{101,0.47320261437908373`},{102,0.5150552174892934`},{103,0.5264931259860258`},{104,0.5297047554654037`},{105,0.5377845391029964`},{106,0.5424611223799854`},{107,0.5685598377281932`},{108,0.566993464052286`},{109,0.5746562993013283`},{110,0.5532567049808419`},{111,0.5038426864998865`},{112,0.5396100969123274`},{113,0.5530876718503486`},{114,0.53813387423935`},{115,0.5158215010141979`},{116,0.4980730223123724`},{117,0.48430245661482896`},{118,0.46648636466080595`},{119,0.4563669145819239`},{120,0.4527383367139952`},{121,0.45841784989857925`},{122,0.47394636015325575`},{123,0.5220982645931924`},{124,0.5426977687626763`},{125,0.5368041469461337`},{126,0.5320148749154822`},{127,0.5155059725039431`},{128,0.5009578544061292`},{129,0.4899143565472155`},{130,0.48522650439486026`},{131,0.4789384719404993`},{132,0.4597926526932603`},{133,0.43320937570430373`},{134,0.4093644354293432`},{135,0.40225377507324667`},{136,0.3966080685147616`},{137,0.4006761325219734`},{138,0.4025805724588679`},{139,0.4033806626098707`},{140,0.4027045300878964`},{141,0.39599954924498426`},{142,0.3904214559386965`},{143,0.38539553752535394`},{144,0.38686049132296496`},{145,0.3901059274284414`},{146,0.3861054766734272`},{147,0.3840094658553066`},{148,0.38198106828938394`},{149,0.3807414919990978`},{150,0.37713545188190123`}}}
		],
		Test[
			"Invert intensity:",
			ImageIntensity[Import["ExampleData/lena.tif"],Rotate->(3 \[Pi])/2,InvertIntensity->False],
			{{1,0.4289324618736384`},{2,0.4412549019607842`},{3,0.44060130718954243`},{4,0.4395729847494552`},{5,0.44692810457516335`},{6,0.4515729847494551`},{7,0.45035294117647057`},{8,0.45258387799564254`},{9,0.4474335511982568`},{10,0.4453333333333332`},{11,0.4423355119825708`},{12,0.43998257080610026`},{13,0.439276688453159`},{14,0.43824836601307177`},{15,0.4345620915032677`},{16,0.4273289760348583`},{17,0.41664488017429185`},{18,0.40059259259259256`},{19,0.3950065359477125`},{20,0.39525054466230924`},{21,0.3888104575163399`},{22,0.3815337690631807`},{23,0.38902832244008695`},{24,0.40870588235294103`},{25,0.4205490196078432`},{26,0.42831372549019603`},{27,0.43519825708060994`},{28,0.43593899782135065`},{29,0.4425533769063178`},{30,0.44919389978213503`},{31,0.45884095860566426`},{32,0.44991721132897583`},{33,0.4392331154684095`},{34,0.45718518518518514`},{35,0.46834858387799555`},{36,0.46996949891067535`},{37,0.4744575163398693`},{38,0.4733681917211327`},{39,0.46143790849673183`},{40,0.44957734204793015`},{41,0.44907189542483666`},{42,0.457054466230937`},{43,0.45572113289760363`},{44,0.4596165577342049`},{45,0.46874074074074057`},{46,0.4653246187363833`},{47,0.4616296296296296`},{48,0.45986056644880186`},{49,0.46458387799564244`},{50,0.47677559912854006`},{51,0.471355119825708`},{52,0.46084531590413935`},{53,0.4549629629629631`},{54,0.4444705882352941`},{55,0.44595206971677553`},{56,0.42243137254901947`},{57,0.4061873638344226`},{58,0.4001742919389979`},{59,0.3974901960784314`},{60,0.4123660130718954`},{61,0.4349281045751637`},{62,0.4377864923747277`},{63,0.444461873638344`},{64,0.46321568627450965`},{65,0.4682004357298474`},{66,0.4631372549019608`},{67,0.4650021786492373`},{68,0.4638518518518517`},{69,0.4565751633986927`},{70,0.4534814814814815`},{71,0.45261002178649223`},{72,0.4482614379084967`},{73,0.44580392156862747`},{74,0.45322875816993446`},{75,0.46020043572984726`},{76,0.45749019607843117`},{77,0.466945533769063`},{78,0.47505010893246163`},{79,0.4802091503267972`},{80,0.48334640522875827`},{81,0.48677995642701516`},{82,0.49285403050108945`},{83,0.504967320261438`},{84,0.5302396514161216`},{85,0.545350762527233`},{86,0.5565490196078432`},{87,0.5598954248366016`},{88,0.5608888888888888`},{89,0.56318082788671`},{90,0.5680610021786484`},{91,0.572235294117647`},{92,0.5770718954248365`},{93,0.5776296296296293`},{94,0.5735860566448799`},{95,0.5722788671023961`},{96,0.5693943355119822`},{97,0.5628061002178648`},{98,0.5504400871459689`},{99,0.5385446623093679`},{100,0.5279389978213505`},{101,0.514875816993464`},{102,0.5029368191721135`},{103,0.48833115468409555`},{104,0.4822919389978214`},{105,0.4812984749455337`},{106,0.4795206971677562`},{107,0.47621786492374746`},{108,0.47286274509803916`},{109,0.471895424836601`},{110,0.4715032679738558`},{111,0.47122440087145995`},{112,0.4733856209150327`},{113,0.47112854030501117`},{114,0.4669716775599131`},{115,0.4707015250544661`},{116,0.47703703703703687`}},
			EquivalenceFunction->RoundMatchQ[8]
		]
}];


(* ::Subsubsection::Closed:: *)
(*ImageOverlay*)

DefineTests[ImageOverlay,{
	Example[{Basic, "Overlay two images:"},
		ImageOverlay[{Import["ExampleData/lena.tif"], Import["ExampleData/rose.gif"]}],
		_?ValidGraphicsQ
	],
	Example[{Options, Contrast, "Adjust the contrast of the first image:"},
		ImageOverlay[
			{Import["ExampleData/lena.tif"], Import["ExampleData/rose.gif"]},
			Contrast->{.5,0}
		],
		_?ValidGraphicsQ
	],
	Example[{Options, Contrast, "Adjust the contrast of the second image:"},
		ImageOverlay[
			{Import["ExampleData/lena.tif"], Import["ExampleData/rose.gif"]},
			Contrast->{0,.5}
		],
		_?ValidGraphicsQ
	],
	Example[{Options, Brightness, "Adjust the brightness of the first image:"},
		ImageOverlay[
			{Import["ExampleData/lena.tif"], Import["ExampleData/rose.gif"]},
			Brightness->{.5,0}
		],
		_?ValidGraphicsQ
	],
	Example[{Options, Brightness, "Adjust the brightness of the second image:"},
		ImageOverlay[
			{Import["ExampleData/lena.tif"], Import["ExampleData/rose.gif"]},
			Brightness->{0,.5}
		],
		_?ValidGraphicsQ
	],
	Example[{Options, Transparency, "Adjust the transparency of the first image:"},
		ImageOverlay[
			{Import["ExampleData/lena.tif"], Import["ExampleData/rose.gif"]},
			Transparency->{.5,0.75}
		],
		_?ValidGraphicsQ
	],
	Example[{Options, Transparency, "Adjust the transparency of the first image:"},
		ImageOverlay[
			{Import["ExampleData/lena.tif"], Import["ExampleData/rose.gif"]},
			Transparency->{0,.5}
		],
		_?ValidGraphicsQ
	],
	Example[{Options, ImageSize, "Adjust the size of the image:"},
		ImageOverlay[{Import["ExampleData/lena.tif"], Import["ExampleData/rose.gif"]}, ImageSize->700],
		_?ValidGraphicsQ
	],
	Example[{Messages, "IncosistentOptionLengths", "Providing Options with lengths that differ from the input images list throws error message:"},
		ImageOverlay[
			{Import["ExampleData/lena.tif"], Import["ExampleData/rose.gif"]},
			Transparency->{0}
		],
		_?ValidGraphicsQ,
		Messages:>Message[ImageOverlay::InconsistentOptionLengths]
	],
	Test["Providing Brightness optios with lengths that differ from the input images list throws error message:",
		ImageOverlay[
			{Import["ExampleData/lena.tif"], Import["ExampleData/rose.gif"]},
			Brightness->{0}
		],
		_?ValidGraphicsQ,
		Messages:>Message[ImageOverlay::InconsistentOptionLengths]
	],
	Example[{Messages,"InconsistentOptionLengths","Providing Contrast optios with lengths that differ from the input images list throws error message:"},
		ImageOverlay[
			{Import["ExampleData/lena.tif"], Import["ExampleData/rose.gif"]},
			Contrast->{0}
		],
		_?ValidGraphicsQ,
		Messages:>Message[ImageOverlay::InconsistentOptionLengths]
	]
}];
