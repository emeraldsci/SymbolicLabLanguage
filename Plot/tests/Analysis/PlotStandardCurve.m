(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*PlotStandardCurve*)


DefineTests[PlotStandardCurve,
	{
		Example[{Basic,"Plot the results of a standard curve analysis:"},
			PlotStandardCurve[
				AnalyzeStandardCurve[{2.2, 2.5},standardCurveDataPts,FitType->Exponential]
			],
			ValidGraphicsP[],
			Stubs:>{
				AnalyzeStandardCurve[
					{2.2, 2.5},
					standardCurveDataPts,
					FitType->Exponential
				]=Analysis`Private`stripAppendReplaceKeyHeads@AnalyzeStandardCurve[
					{2.2, 2.5},
					QuantityArray[{
							{0.`,0.`},{0.2`,0.21090505138173465`},{0.4`,1.3297556155106667`},{0.6000000000000001`,0.655734453042509`},{0.8`,1.0387548280020633`},{1.`,4.02662803092734`},{1.2000000000000002`,1.7360046289478346`},
							{1.4000000000000001`,7.814553854586216`},{1.6`,6.076096924027828`},{1.8`,6.666847745200002`},{2.`,11.506123168389644`},{2.2`,10.712746494728533`},{2.4000000000000004`,16.20548235772889`},
							{2.6`,27.726752410404977`},{2.8000000000000003`,28.58867545710098`},{3.`,29.709241602059812`},{3.2`,41.115878332677234`},{3.4000000000000004`,49.786698134955074`},{3.6`,55.499559387407885`},
							{3.8000000000000003`,70.79936509566826`},{4.`,67.70154081693205`}
						},
						{1,RFU}
					],
					FitType->Exponential,
					Upload->False
				]
			}
		],
		Example[{Basic,"Add a frame and a title to the plot of a standard curve analysis:"},
			PlotStandardCurve[
				AnalyzeStandardCurve[{2.2, 2.5},standardCurveDataPts,FitType->Exponential],
				Frame->True,
				PlotLabel->"Custom Plot Title"
			],
			ValidGraphicsP[],
			Stubs:>{
				AnalyzeStandardCurve[
					{2.2, 2.5},
					standardCurveDataPts,
					FitType->Exponential
				]=Analysis`Private`stripAppendReplaceKeyHeads@AnalyzeStandardCurve[
					{2.2, 2.5},
					QuantityArray[{
							{0.`,0.`},{0.2`,0.21090505138173465`},{0.4`,1.3297556155106667`},{0.6000000000000001`,0.655734453042509`},{0.8`,1.0387548280020633`},{1.`,4.02662803092734`},{1.2000000000000002`,1.7360046289478346`},
							{1.4000000000000001`,7.814553854586216`},{1.6`,6.076096924027828`},{1.8`,6.666847745200002`},{2.`,11.506123168389644`},{2.2`,10.712746494728533`},{2.4000000000000004`,16.20548235772889`},
							{2.6`,27.726752410404977`},{2.8000000000000003`,28.58867545710098`},{3.`,29.709241602059812`},{3.2`,41.115878332677234`},{3.4000000000000004`,49.786698134955074`},{3.6`,55.499559387407885`},
							{3.8000000000000003`,70.79936509566826`},{4.`,67.70154081693205`}
						},
						{1,RFU}
					],
					FitType->Exponential,
					Upload->False
				]
			}
		],
		Example[{Basic,"Given a list of standard curve analyses, generate a list of standard curve plots:"},
			PlotStandardCurve[{obj1,obj2}],
			{ValidGraphicsP[]..}
		]
	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	SymbolSetUp:>(
		ClearMemoization[];
		$CreatedObjects={};

		Module[{allDataObjects,existingObjects},

			(* Gather all the objects and models created in SymbolSetUp *)
			allDataObjects={
				Object[Data,ELISA,"PlotStandardCurve Test ELISA Data"]
			};

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects=PickList[allDataObjects,DatabaseMemberQ[allDataObjects]];

			(* Erase any test objects and models that we failed to erase in the last unit test *)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		(* Generate some fake data *)
		SeedRandom[123];
		standardXDataELISA=10^Range[-3,0,0.2];
		standardYDataELISA=QuantityDistribution[NormalDistribution[4*(1.0-(1.0/(1 +((3.0+#)/1.4)^6)))+RandomReal[0.2],RandomReal[0.02]],RFU]&/@Range[-3,0,0.2];

		(* Upload test data objects for ELISA *)
		Upload[{
			<|
				Type->Object[Data,ELISA],
				Name->"PlotStandardCurve Test ELISA Data",
				Replace[Intensities]->standardYDataELISA,
				Replace[DilutionFactors]->standardXDataELISA,
				DeveloperObject->True
			|>
		}];

	),

	SymbolTearDown:>(
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	),

	Variables:>{
		standardCurveDataPts,obj1,obj2
	},

	SetUp:>(
		ClearMemoization[];
		standardCurveDataPts=QuantityArray[{
				{0.`,0.`},{0.2`,0.21090505138173465`},{0.4`,1.3297556155106667`},{0.6000000000000001`,0.655734453042509`},{0.8`,1.0387548280020633`},{1.`,4.02662803092734`},{1.2000000000000002`,1.7360046289478346`},
				{1.4000000000000001`,7.814553854586216`},{1.6`,6.076096924027828`},{1.8`,6.666847745200002`},{2.`,11.506123168389644`},{2.2`,10.712746494728533`},{2.4000000000000004`,16.20548235772889`},
				{2.6`,27.726752410404977`},{2.8000000000000003`,28.58867545710098`},{3.`,29.709241602059812`},{3.2`,41.115878332677234`},{3.4000000000000004`,49.786698134955074`},{3.6`,55.499559387407885`},
				{3.8000000000000003`,70.79936509566826`},{4.`,67.70154081693205`}
			},
			{1,RFU}
		];
		Pause[5];
		obj1=AnalyzeStandardCurve[{2.5 RFU},
			Object[Data,ELISA,"PlotStandardCurve Test ELISA Data"],
			StandardFields->{DilutionFactors,Intensities},
			StandardTransformationFunctions->{Log10[#]&,None},
			InversePrediction->True,
			Upload->False
		];
		obj2=AnalyzeStandardCurve[{3.0 RFU, 3.1 RFU, 2.9 RFU},
			Object[Data,ELISA,"PlotStandardCurve Test ELISA Data"],
			StandardFields->{DilutionFactors,Intensities},
			StandardTransformationFunctions->{Log10[#]&,None},
			InversePrediction->True,
			Upload->False
		];
	)
];
