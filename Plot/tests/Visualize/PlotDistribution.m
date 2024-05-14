(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotDistribution*)


DefineTests[PlotDistribution,{

	Example[{Basic,"Plot the PDF of a parametric normal distribution:"},
		PlotDistribution[NormalDistribution[10,1]],
		ValidGraphicsP[]
	],

	Example[{Basic,"Plot the PDF histogram of an empirical distribution:"},
		PlotDistribution[RandomVariate[NormalDistribution[10,1],1000]],
		ValidGraphicsP[]
	],

	Example[{Basic,"Plot the distributions of fitted parameters in fit object:"},
		PlotDistribution[Object[Analysis, Fit, "id:7X104vKNKDv6"]],
		{{_Symbol,_Symbol}->ValidGraphicsP[]}
	],

	Test["Given fit object packet:",
		PlotDistribution[Download[Object[Analysis, Fit, "id:7X104vKNKDv6"]]],
		{{_Symbol,_Symbol}->ValidGraphicsP[]}
	],

	Test["Given fit object link:",
		PlotDistribution[Link[Object[Analysis, Fit, "id:7X104vKNKDv6"],Reference]],
		{{_Symbol,_Symbol}->ValidGraphicsP[]}
	],

	Example[{Additional,"Plot a Poisson distribution:"},
		PlotDistribution[PoissonDistribution[3]],
		ValidGraphicsP[]
	],

	Example[{Additional,"Plot a sampled Exponential distribution:"},
		PlotDistribution[RandomVariate[ExponentialDistribution[3],10000]],
		ValidGraphicsP[]
	],

	Example[{Additional,"Plot an EmpiricalDistribution with units:"},
		PlotDistribution[
			QuantityDistribution[
				DataDistribution["Empirical",
					{
						{
							0.2526499140802575`,0.3494796620679307`,0.23979943284472552`,0.10882044868418027`,
							0.03673965073392998`,0.009842910532962709`,0.0021796038193243336`,0.00041030223857186124`,
							0.00006702383563734494`,9.650826803816683`*^-6,1.2401489080823601`*^-6,
							1.4363814673263618`*^-7,1.5108256240877305`*^-8,1.4403650427750984`*^-9
						},
						{
							1683.8936577609543`,1684.8970892881714`,1685.9005220206684`,1686.9039559862892`,
							1687.9073912137337`,1688.9108277325804`,1689.9142655732967`,1690.9177047672865`,
							1691.9211453469582`,1692.9245873459392`,1693.9280308020989`,1694.9314757963427`,
							1695.934923050982`,1696.9383817721985`
						},
						False
					},
					1,
					14
				],
				Times["Grams",Power["Moles",-1]]
			]
		],
		ValidGraphicsP[]
	],

	Example[{Options,Display,"Display no epilogs, only the data:"},
		PlotDistribution[RandomVariate[NormalDistribution[10,1],1000],Display->{}],
		ValidGraphicsP[]
	],

	Example[{Options,Display,"Overlay a smoothed version of the histogram:"},
		PlotDistribution[RandomVariate[NormalDistribution[10,1],1000],Display->{SmoothHistogram}],
		ValidGraphicsP[]
	],

	Example[{Options,Display,"Display the distribution mean:"},
		PlotDistribution[RandomVariate[NormalDistribution[10,1],1000],Display->{Mean}],
		ValidGraphicsP[]
	],

	Example[{Options,Display,"Display the distribution deviations:"},
		PlotDistribution[RandomVariate[NormalDistribution[10,1],1000],Display->{Deviations}],
		ValidGraphicsP[]
	],

	Example[{Options,Display,"Display the means and deviations:"},
		PlotDistribution[RandomVariate[NormalDistribution[10,1],1000],Display->{Mean,Deviations}],
		ValidGraphicsP[]
	],

	Example[{Options,DistributionFunction,"Plot the CDF of a parametric normal distribution:"},
		PlotDistribution[NormalDistribution[10,1],DistributionFunction->CDF],
		ValidGraphicsP[]
	],

	Example[{Options,DistributionFunction,"Plot the empirical CDF of a statistical sample:"},
		PlotDistribution[RandomVariate[NormalDistribution[10,1],1000],DistributionFunction->CDF],
		ValidGraphicsP[]
	],

	Example[{Options,EstimatedDistribution,"Fit a statistical model to an empirical sample:"},
		PlotDistribution[RandomVariate[GammaDistribution[3 ,1 ],1000],Display->{FittedModel},EstimatedDistribution->GammaDistribution[\[Alpha],\[Beta]]],
		ValidGraphicsP[]
	],

	Example[{Options,Frame,"Turn on all frames, including percent ticks on top frame and counts on right frame:"},
		PlotDistribution[RandomVariate[NormalDistribution[5,2],1000],Frame->True],
		ValidGraphicsP[]
	],

	Example[{Options,PlotRange,"PlotRange specifies the domain and range:"},
		PlotDistribution[RandomVariate[PowerDistribution[1,.1],1000],PlotRange->{{0,0.3},All}],
		ValidGraphicsP[]
	],

	Example[{Options,FrameLabel,"FrameLabel specifies text displayed along each axis:"},
		PlotDistribution[RandomVariate[NormalDistribution[10,1],1000],FrameLabel->{"Number of Cells","Frequency"}],
		g_/;ValidGraphicsQ[g]&&MatchQ[FrameLabel/.Last@g,{"Number of Cells","Frequency"}]
	],

	Example[{Options,Filling,"Specify the level to which the area beneath a distribution function is filled:"},
		PlotDistribution[NormalDistribution[5,1],Filling->0.2],
		g_/;ValidGraphicsQ[g]&&Length@Cases[Normal@First@g,_Polygon,-1]>1
	],

	Example[{Options,Filling,"Turn off the filling beneath a distribution function:"},
		PlotDistribution[NormalDistribution[5,1],Filling->None],
		g_/;ValidGraphicsQ[g]&&Length@Cases[Normal@First@g,_Polygon,-1]==0
	],

	Example[{Options,FrameStyle,"Specify graphics directives to control how each axis is displayed:"},
		PlotDistribution[RandomVariate[NormalDistribution[5,1],1000],FrameStyle->{None,{Thick,Blue},None,{Dashed,Red}}],
		g_/;ValidGraphicsQ[g]&&Length@Cases[FrameStyle/.Last@g,_RGBColor,-1]==2
	],

	Example[{Options,TargetUnits,"TargetUnits sets the units of the random variable:"},
		PlotDistribution[RandomVariate[NormalDistribution[600 Minute, 45 Minute],1000],TargetUnits->Hour],
		g_/;ValidGraphicsQ[g]&&(First@Differences@First@PlotRange@g)<20
	],

	Example[{Options,GridLines,"Specify levels at which lines should be displayed on the plot:"},
		PlotDistribution[NormalDistribution[10,1],Display->None,GridLines->{{9,10,11},None}],
		g_/;ValidGraphicsQ[g]&&MatchQ[GridLines/.Last@g,{{9,10,11},None}]
	],

	Example[{Options,GridLinesStyle,"Specify directives for formatting grid lines:"},
		PlotDistribution[NormalDistribution[10,1],DistributionFunction->SurvivalFunction,Display->None,GridLines->{None,{0.1,0.5,.9}},GridLinesStyle->Directive[Dashed,Thick,Red]],
		g_/;ValidGraphicsQ[g]&&MatchQ[Cases[GridLinesStyle/.Last@g,_RGBColor,-1],{Red}]
	],


	Example[{Options,MeshFunctions,"Add mesh lines to the plot using arbitrary functional forms:"},
		PlotDistribution[MultinormalDistribution[{10,10},{{1,0.5},{0.5,1}}],MeshFunctions->{#1+#2&,#2&}],
		ValidGraphicsP[]
	],

	Example[{Options,PlotLabel,"Display title text above the plot:"},
		PlotDistribution[ExponentialDistribution[5],PlotLabel->"Example Title"],
		g_/;ValidGraphicsQ[g]&&(PlotLabel/.Last@g)=="Example Title"
	],

	Example[{Options,Axes,"Toggle the display of frame lines and tick marks:"},
		PlotDistribution[RandomVariate[ExponentialDistribution[5],1000],Axes->True],
		ValidGraphicsP[]
	],

	Example[{Options,ImageSize,"Set the size of the generated figure:"},
		PlotDistribution[RandomVariate[ExponentialDistribution[5],1000],ImageSize->750],
		ValidGraphicsP[]
	],

	Test["ImageSize sets the size of figures that plot fitted parameters:",
		ImageSize/.PlotDistribution[Object[Analysis, Fit, "id:7X104vKNKDv6"],ImageSize->400,Output->Options],
		400
	],

	Example[{Options,AspectRatio,"Set the height to width ratio of the generated figure:"},
		PlotDistribution[RandomVariate[ExponentialDistribution[5],1000],AspectRatio->1],
		ValidGraphicsP[]
	],

	Test["AspectRatio resolves to 1/GoldenRatio for 1D distributions:",
		AspectRatio/.PlotDistribution[RandomVariate[ExponentialDistribution[5],1000],Output->Options],
		1/GoldenRatio
	],

	Test["AspectRatio resolves to 1 for 2D distributions:",
		AspectRatio/.PlotDistribution[Object[Analysis, Fit, "id:7X104vKNKDv6"],Output->Options],
		1
	],

	Example[{Messages,"BadXYPoints","Uneven value and uncertainty lengths provided to computePropagatedError throws BadXYPoints error:"},
		Analysis`Private`computePropagatedError[#&,{1,1,1},{.1,.1}],
		Null,
		Messages:>{Analysis`Private`computePropagatedError::BadXYPoints}
	],

  (* Output tests *)
  Test[
    "Setting Output to Result plots the distribution:",
    PlotDistribution[NormalDistribution[0,1],Output->Result],
    _?ValidGraphicsQ
    ],

  Test[
    "Setting Output to Preview plots the distribution:",
    PlotDistribution[NormalDistribution[0,1],Output->Preview],
    _?ValidGraphicsQ
    ],

  Test[
    "Setting Output to Options returns the resolved options:",
    PlotDistribution[NormalDistribution[0,1],Output->Options],
    ops_/;MatchQ[ops,OptionsPattern[PlotDistribution]]
    ],

  Test[
    "Setting Output to Tests returns a list of tests:",
    PlotDistribution[NormalDistribution[0,1],Output->Tests],
    {(_EmeraldTest|_Example)...}
    ],

  Test[
    "Setting Output to {Result,Options} plots the distribution and returns all resolved options:",
    PlotDistribution[NormalDistribution[0,1],Output->{Result,Options}],
    output_List/;MatchQ[First@output,_?ValidGraphicsQ]&&MatchQ[Last@output,OptionsPattern[PlotDistribution]]
    ]

}];


(* ::Subsection:: *)
(*PlotDistributionPreview*)

DefineTests[PlotDistributionPreview,{
	Test[
		"Provide a preview of the distribution:",
		PlotDistributionPreview[NormalDistribution[0,1]],
		_?ValidGraphicsQ
		],

	Example[{Basic,"Preview the PDF histogram of an empirical distribution:"},
			PlotDistributionPreview[RandomVariate[NormalDistribution[10,1],1000]],
			ValidGraphicsP[]
		],

	Example[{Additional,"Plot a Poisson distribution:"},
			PlotDistributionPreview[PoissonDistribution[3]],
			ValidGraphicsP[]
		],

	Example[{Options,Display,"Display no epilogs, only the data:"},
			PlotDistributionPreview[RandomVariate[NormalDistribution[10,1],1000],Display->{}],
			ValidGraphicsP[]
		]

}];


(* ::Subsection:: *)
(*PlotDistributionOptions*)

DefineTests[PlotDistributionOptions,{
	Test[
		"Provide a list of options used to plot the distribution:",
		PlotDistributionOptions[NormalDistribution[0,1]],
		_?ListQ
		],

	Example[{Basic,"Provide list of options used to generate PDF histogram of an empirical distribution:"},
			PlotDistributionOptions[RandomVariate[NormalDistribution[10,1],1000]],
			_?ListQ
		],

	Example[{Additional,"Gives a list of options used to plot a Poisson distribution:"},
			PlotDistributionOptions[PoissonDistribution[3]],
			_?ListQ
		],

	Example[{Options,Display,"Display no epilogs, only the data:"},
			PlotDistributionOptions[RandomVariate[NormalDistribution[10,1],1000],Display->{}],
			_?ListQ
		]
}];
