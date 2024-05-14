(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotCellCount*)


DefineOptions[PlotCellCount,
	Options :> {

		{
			OptionName->PlotType,
			Description->"Specifies whether to generate an Overlay, PieChart, or Text.",
			ResolutionDescription->"When set to Automatic, PlotType defaults to Overlay. If the input anything other than a single Object[Analysis,CellCount] object, a BarChart is shown.",
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>Automatic|All|Overlay|PieChart|Text],
			Category->"Plot Type"
		},

		{
			OptionName->SingleCell,
			Description->"If set to True, only single-celled components will be labeled.",
			Default->False,
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Category->"Data Specifications"
		},

		{
			OptionName->DisplayCellCount,
			Description->"If set to True, the size of each component will be included in its tooltip.",
			Default->True,
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Category->"Data Specifications"
		},

		{
			OptionName->CellCount,
			Description->"CellCount specifies the number of cells in the BrightField image, and is used to estimate the size of each component.",
			Default->0,
			AllowNull->True,
			Widget->Widget[Type->Number,Pattern:>GreaterEqualP[0]],
			Category->"Data Specifications"
		},

		{
			OptionName->CellCountError,
			Description->"The error associated with the number of cells in the BrightField image.",
			Default->0,
			AllowNull->True,
			Widget->Widget[Type->Number,Pattern:>GreaterEqualP[0]],
			Category->"Data Specifications"
		},

		{
			OptionName->MinSingleCellArea,
			Description->"The minimum size for a component to be considered a single cell.",
			Default->500,
			AllowNull->True,
			Widget->Widget[Type->Number,Pattern:>GreaterEqualP[0]],
			Category->"Data Specifications"
		},

		{
			OptionName->MaxSingleCellArea,
			Description->"The maximum size for a component to be considered a single cell.",
			Default->5000,
			AllowNull->True,
			Widget->Widget[Type->Number,Pattern:>GreaterEqualP[0]],
			Category->"Data Specifications"
		},

		(* ImageSize option *)
		ModifyOptions[ListPlotOptions,{ImageSize},Default->500,AllowNull->True],

		(* Set default AspectRatio to Automatic (1/Golden for BarChart, 1 for PieChart *)
		ModifyOptions[ListPlotOptions,
			{
				{
					OptionName->AspectRatio,
					Default->Automatic,
					AllowNull->True
				},
				{
					OptionName->TargetUnits,
					Category->"Hidden"
				}
			}
		],

		(* Legend option *)
		ModifyOptions[LegendOption,
			Default->None,
			Description->"Sets the text descriptions of each item in the plot. When set to Automatic, the component names are used.",
			AllowNull->True,
			Category->"Plot Labeling"
		],

		(* PlotLabel option *)
		ModifyOptions[ListPlotOptions,{PlotLabel},AllowNull->True],

		(* FrameLabel option *)
		ModifyOptions[FrameLabelOption,
			AllowNull->True,
			Category->"Plot Labeling"
		],

		(* Chart options *)
		ModifyOptions[ChartOptions,
			{
				{
					OptionName->ChartLabels,
					Default->None,
					AllowNull->True,
					Widget->Alternatives[
						Widget[Type->Enumeration,Pattern:>Alternatives[None]],
						"Specify Labels:"->Adder[
							Alternatives[
								"Integer"->Widget[Type->Number,Pattern:>GreaterEqualP[0,1]],
								"String"->Widget[Type->String,Pattern:>_String,Size->Word]
							]
						]
					],
					Category->"Plot Labeling"
				},
				{
					OptionName->ChartLayout,
					AllowNull->True,
					Category->"Plot Style"
				},
				{
					OptionName->ChartBaseStyle,
					AllowNull->True,
					Category->"Plot Style"
				},
				{
					OptionName->ChartStyle,
					AllowNull->True,
					Category->"Plot Style"
				},
				{
					OptionName->ChartElements,
					Category->"Hidden"
				},
				{
					OptionName->ChartElementFunction,
					Category->"Hidden"
				},
				{
					OptionName->ChartLegends,
					Category->"Hidden"
				},
				{
					OptionName->LegendAppearance,
					Category->"Hidden"
				}
			}
		],

		(* ChartLabelOrientation option *)
		{
			OptionName->ChartLabelOrientation,
			Default->Automatic,
			Description->"Specifies whether labels are positioned vertically or horizontally.",
			ResolutionDescription->"If set to Automatic and the ChartLabels are integers, orientation is set to Horizontal. If the ChartLabels are strings, the orientation is set to Vertical.",
			AllowNull->True,
			Category->"Plot Labeling",
			Widget->Widget[Type->Enumeration,Pattern:>Automatic|Horizontal|Vertical]
		},

		(* LabelStyle and LabelingFunction options *)
		ModifyOptions[ListPlotOptions,{LabelStyle},AllowNull->True],
		ModifyOptions[EmeraldPieChart,{LabelingFunction},AllowNull->True],

		(* Overlay options *)
		{
			OptionName->BlendingFraction,
			Description->"The fraction used for alpha blending the colorized components into the cell image.",
			Default->0.35,
			AllowNull->True,
			Widget->Widget[Type->Number,Pattern:>RangeP[0, 1],Min->0,Max->1],
			Category->"Plot Style"
		},

		(* Pie Chart options *)
		ModifyOptions[PieChartOptions,
			{
				{
					OptionName->SectorOrigin,
					Default->Automatic,
					AllowNull->True,
					Category->"Plot Style"
				},
				{
					OptionName->SectorSpacing,
					Category->"Hidden"
				}
			}
		],

		(* Bar Chart options *)
		ModifyOptions[BarChartOptions,
			{
				{
					OptionName->BarSpacing,
					AllowNull->True,
					Category->"Plot Style"
				},
				{
					OptionName->BarOrigin,
					Category->"Hidden"
				}
			}
		],

		(* Inherit options without modification *)
		MapOption,
		FastTrackOption,

		(* Hidden options *)
		{
			OptionName->Orientation,
			Description->"Orientation of the plot.",
			Default->Row,
			AllowNull->False,
			Widget->Widget[Type->Expression,Pattern:>_,Size->Word],
			Category->"Hidden"
		},

		{
			OptionName->ScaleY,
			Description->"Scale y values.",
			Default->False,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Category->"Hidden"
		},

		(* Set default Boxes to True *)
		ModifyOptions[BoxesOption,Default->True,Category->"Hidden"],

		(* Set all plotting options to allow Null so they can be hidden depending on PlotType *)
		ModifyOptions[ListPlotOptions,{FrameTicks,FrameTicksStyle,PlotRange},AllowNull->True],
		ModifyOptions[EmeraldPieChart,{Background,ColorFunction,ColorFunctionScaling,GridLines,GridLinesStyle},AllowNull->True],

		ModifyOptions[EmeraldPieChart,
			{
				{
					OptionName->Frame,
					Default->Automatic,
					AllowNull->True
				},
				{
					OptionName->FrameStyle,
					AllowNull->True
				},
				{
					OptionName->Prolog,
					AllowNull->True
				},
				{
					OptionName->Epilog,
					Default->Automatic,
					AllowNull->True
				}
			}
		],

		OutputOption

	},

	SharedOptions :> {

		(* Include additional options without modification *)
		{ListPlotOptions,{FrameTicks,FrameTicksStyle,PlotRange}},

		(* Inherit remaining PieChart options from EmeraldPieChart (Keys@SafeOptions@PieChart) *)
		{EmeraldPieChart,{AlignmentPoint,AspectRatio,Axes,AxesLabel,AxesOrigin,AxesStyle,Background,BaselinePosition,BaseStyle,ChartBaseStyle,ChartElementFunction,ChartLabels,ChartLayout,ChartLegends,ChartStyle,ColorFunction,ColorFunctionScaling,ColorOutput,ContentSelectable,CoordinatesToolOptions,DisplayFunction,FormatType,Frame,FrameLabel,FrameStyle,GridLines,GridLinesStyle,ImageMargins,ImagePadding,ImageSize,ImageSizeRaw,LabelingFunction,LabelingSize,LabelStyle,LegendAppearance,Method,PerformanceGoal,PlotLabel,PlotRange,PlotRangeClipping,PlotRangePadding,PlotRegion,PlotTheme,PolarAxes,PolarAxesOrigin,PolarGridLines,PolarTicks,PreserveImageOptions,Prolog,RotateLabel,SectorOrigin,SectorSpacing,TargetUnits,Ticks,TicksStyle}}

	}
];


PlotCellCount::imageNotFound="No image was found in this packet.";
PlotCellCount::NoCounts="One or more of your inputs does not have calculated cell counts.  Please use AnalyzeCellCount to count the cells for your image or exclude your image from plotting if no cells can be counted.";


(* ::Text:: *)
(*Base raw definitions*)

(* PlotCellCount[_]=$Failed;
PlotCellCount[_,_]=$Failed;
PlotCellCount[_,_,_]=$Failed;
PlotCellCount[___]=$Failed; *)

(* Overlay/PieChart/Text *)
PlotCellCount[image_Image, components:{{_?NumericQ...}...}?MatrixQ, ops:OptionsPattern[]]:=Module[
	{safeOps,plotType,output,finalPlot,hiddenOps,frame},
	safeOps=SafeOptions[PlotCellCount,ToList[ops]];

	(* Resolve plot type *)
	plotType=Replace[Lookup[safeOps,PlotType],Automatic->Overlay];

	(* Specify which options to hide *)
	hiddenOps=Rule[#,Null]&/@Switch[plotType,
		Overlay,{CellCountError,SectorOrigin,Legend,ChartLayout,ChartBaseStyle,ChartStyle,Background,ColorFunction,ColorFunctionScaling,ChartLabels,ChartLabelOrientation,BarSpacing,FrameLabel,PlotRange,LabelStyle,PlotLabel,LabelingFunction,FrameTicks,FrameTicksStyle,Frame,FrameStyle,GridLines,GridLinesStyle},
		PieChart,{CellCountError,BlendingFraction,ChartLayout,ChartLabelOrientation,BarSpacing,FrameLabel,PlotRange,FrameTicks,FrameTicksStyle,Frame,FrameStyle},
		Text,{SingleCell,DisplayCellCount,SectorOrigin,Legend,ChartLayout,ChartBaseStyle,ChartStyle,Background,ColorFunction,ColorFunctionScaling,ChartLabels,ChartLabelOrientation,BarSpacing,FrameLabel,PlotRange,LabelStyle,PlotLabel,LabelingFunction,FrameTicks,FrameTicksStyle,Frame,FrameStyle,GridLines,GridLinesStyle,BlendingFraction,AspectRatio,ImageSize,Prolog,Epilog}
	];

	(* Generate final plot *)
	finalPlot=plotCellCountImage[image,components,ReplaceRule[safeOps,{Frame->False,PlotType->plotType,Output->Result}]];

	(* Return specified output *)
	output=Lookup[safeOps,Output];
	output/.{
		Result->finalPlot,
		Tests->{},

		(* Resize Preview to fill command builder window *)
		Preview->If[SameQ[plotType,Text],finalPlot,Show[finalPlot,ImageSize->Full]],

		(* Return safe options merged with any options resolved downstream *)
		Options:>ReplaceRule[safeOps,
			(* Merge resolved PlotType with options pulled from final plot Graphics *)
			Join[
				{PlotType->plotType},
				hiddenOps,
				If[MatchQ[plotType,Text],{},Cases[ToList@finalPlot,_Graphics,-1][[1,2]]]
			],
			Append->False
		]
	}
];


(* BarChart *)
PlotCellCount[counts:ListableP[NumericP,3],ops:OptionsPattern[]]:=Module[
	{safeOps,hiddenOps,output,finalPlot,labelOrientation,chartLabels,resolvedChartLabels,frame},

	safeOps=SafeOptions[PlotCellCount,ToList[ops]];

	(* Resolve frame *)
	frame=Replace[Lookup[safeOps,Frame],Automatic->{{True,False},{True,False}}];

	(* Resolve ChartLabelsOrientation *)
	chartLabels=Lookup[safeOps,ChartLabels];
	labelOrientation=Replace[Lookup[safeOps,ChartLabelOrientation],Automatic->If[MatchQ[chartLabels,{_Integer..}],Horizontal,Vertical]];

	(* Generate final plot *)
	finalPlot=plotCellCountBarChart[counts,ReplaceRule[safeOps,{Frame->frame,ChartLabelOrientation->labelOrientation,Output->Result}]];

	(* Define hidden options for Command Builder *)
	hiddenOps=Rule[#,Null]&/@{SingleCell,DisplayCellCount,CellCount,CellCountError,MinSingleCellArea,MaxSingleCellArea,PlotType,BlendingFraction,SectorOrigin,Legend};

	(* Return specified output *)
	output=Lookup[safeOps,Output];
	output/.{
		Result->finalPlot,

		Preview->Show[finalPlot,ImageSize->Full],

		Tests->{},

		(* Return safe options merged with resolved bar chart labels and any options resolved downstream by EmeraldBarChart *)
		Options:>ReplaceRule[safeOps,
			Join[
				{ChartLabels->chartLabels,ChartLabelOrientation->labelOrientation},
				Cases[ToList@finalPlot,_Graphics,-1][[1,2]],
				hiddenOps
			],
			Append->False
		]
	}
];


(* ::Text:: *)
(*Given objects*)


PlotCellCount[id:objectOrLinkP[Object[Analysis,CellCount]]|objectOrLinkP[Object[Data,Microscope]], ops:OptionsPattern[]]:=
	PlotCellCount[Download[id],ops];

PlotCellCount[id:ListableP[objectOrLinkP[Object[Analysis,CellCount]],3]|ListableP[objectOrLinkP[Object[Data,Microscope]],3], ops:OptionsPattern[]]:=
	PlotCellCount[Download/@id,ops];


(* ::Text:: *)
(*Given Object[Data,Microscope]*)


(*
	Given Object[Data,Microscope], pull the latest analysis[CellCount] and use those
*)
PlotCellCount[microscopeDataPackets:ListableP[PacketP[Object[Data, Microscope]],3],opts:OptionsPattern[]]:=Module[
	{analysisObjects},

	(* pull out the peaks and peak data *)
	analysisObjects = ReplaceAll[
		microscopeDataPackets,
		packet:PacketP[Object[Data, Microscope]]:>LastOrDefault[CellCountAnalyses/.packet]
	];

	(* pass to core function if analysis objects are present *)
	If[
		MemberQ[Flatten[ToList[analysisObjects]],Null],
		Message[PlotCellCount::NoCounts],
		PlotCellCount[
			Unflatten[
				Download[Flatten[ToList[analysisObjects]],Object],
				ToList[analysisObjects]
			],
			opts
		]
	]
];


(* ::Text:: *)
(*Given Object[Analysis,CellCount]*)


(*---SLLified on Object[Analysis,CellCount]----*)
PlotCellCount[
	myPacket:PacketP[Object[Analysis, CellCount]],
	myOptions:OptionsPattern[PlotCellCount]
]:=Module[
	{
		safeOps,output,microscopeDataPacket,referenceImages,adjustedImages,highlightedCells,components,packet,ref,
		cellCount,cellCountError,plotType,finalPlot,minSingleCellSize,maxSingleCellSize
	},

	safeOps=SafeOptions[PlotCellCount,ToList[myOptions]];

	output=Lookup[safeOps,Output];

	(* Remove the Replace and Append headers *)
	packet=Analysis`Private`stripAppendReplaceKeyHeads[myPacket];

	ref = Analysis`Private`packetLookup[packet,Reference];
	If[MatchQ[ref,  Null|{Null}], Message[PlotCellCount::imageNotFound]; Return[Null]];

	(* Download the reference microscope data object packet *)
	microscopeDataPacket=Download[ref];

	(* plotType *)
	plotType=Lookup[safeOps,PlotType];

	(* All original images that we analyzed *)
	referenceImages = ImportCloudFile[Lookup[packet,ReferenceImage]];

	(* Images after performing the adjustment steps *)
	adjustedImages= ImportCloudFile[Lookup[packet,AdjustedImage]];

	(* Images after performing the adjustment and segmentation steps *)
	highlightedCells = ImportCloudFile[Lookup[packet,HighlightedCells]];

	If[MatchQ[image,  Null], Message[PlotCellCount::imageNotFound]; Return[Null]];

	(* The components asscoiated with each of the segemented images *)
	components=Replace[ImageComponents/.packet, Null|{Null}->{{}}];

	(* cell count *)
	cellCount=Mean/@Replace[NumberOfCells/.packet, Null|{Null}->{{}}];
	cellCountError=StandardDeviation/@Replace[NumberOfCells/.packet, Null|{Null}->{{}}];

	(* cell size *)
	{minSingleCellSize,maxSingleCellSize}=Lookup[safeOps,{MinSingleCellArea,MaxSingleCellArea}];

	finalPlot=Switch[plotType,
		PieChart|Text,
			PlotCellCount[First[adjustedImages], components, Sequence@@ReplaceRule[ToList[myOptions],{CellCount->First@cellCount,CellCountError->First@cellCountError,MinSingleCellArea->minSingleCellSize,MaxSingleCellArea->maxSingleCellSize}]],

		_,
			TabView[

				MapThread[
					Rule,
					{
						{"Raw Image","Adjusted Image","Analyzed Image"},
						Map[
							Function[imageList,
								(* Use slide view for multiple images *)
								If[Length[imageList]>1,
									SlideView[MapThread[PlotImage[#1,PlotLabel->"Image "<>ToString[#2]]&,{imageList,Range[Length[imageList]]}]],
									PlotImage[imageList]
								]
							],
							{referenceImages,adjustedImages,highlightedCells}
						]
					}
				]

			]
	];

	(* Return specified output *)
	output=Lookup[safeOps,Output];
	output/.{
		Result->finalPlot,

		Preview->finalPlot,

		Tests->{},

		Options->safeOps
	}

];


PlotCellCount[countObjs:ListableP[{PacketP[Object[Analysis, CellCount]]..},2],ops:OptionsPattern[]]:=Module[
	{counts},
	counts = Flatten[NumberOfComponents/.countObjs,2];
	PlotCellCount[counts,ops]
];


(* ::Subsubsection::Closed:: *)
(*fromOptionOrPacket*)


(*if an option is specified use that instead of the value from the packet*)
fromOptionOrPacket[field_, packet:PacketP[], ops:OptionsPattern[PlotCellCount]]:=Module[{},
	If[MemberQ[List[ops], Rule[field, _]]||MatchQ[field/.packet, field|Null|{Null}],
		OptionValue[field],
		field/.packet
	]
];


(* ::Subsubsection::Closed:: *)
(*plotCellCountImage*)


(*core function*)
plotCellCountImage[image_Image, components_,  safeOps_List]:=Module[
	{areas,boundingDisks,boundingDiskLabels,totalArea,singleCellAreas,
	componentLabels,componentMeasurements,componentsToPlot,totalCount,minSingleCellSize,maxSingleCellSize,
	plotType
	},

	totalCount=CellCount/.safeOps;
	minSingleCellSize=MinSingleCellArea/.safeOps;
	maxSingleCellSize=MaxSingleCellArea/.safeOps;

	(*sometimes we only want to plot and label single celled components*)
	componentsToPlot=If[(SingleCell/.safeOps)&&MatchQ[PlotType/.safeOps, Overlay],
		SelectComponents[components, "Area", (minSingleCellSize)<#<(maxSingleCellSize)&],
		components
	];

	componentMeasurements=SortBy[ComponentMeasurements[componentsToPlot,{"Area", "BoundingDiskCenter", "BoundingDiskRadius"}], #[[2,1]]&];
	areas = componentMeasurements[[All,2,1]];

	singleCellAreas= Select[areas,(minSingleCellSize)<#<(maxSingleCellSize)&];

	(*total area always needs to a true total even if just using single cells*)
	totalArea=Total[areas];

	(*the labels should Convert area to number of cells*)
	componentLabels=Table[
		("Component "<> ToString[i] <> If[DisplayCellCount/.safeOps,
				 "\n" <>ToString[Round[Unitless[(areas[[i]]*(totalCount)/totalArea)], .1]]<>" Cell",
				""
				]),
		{i,1, Length[areas]}
	];

	(*
		FIND A BETTER WAY TO DO THIS
	*)
	(*create disks that approxomate cell clumps to label for tooltips*)
	boundingDisks=componentMeasurements[[All,2,2;;3]];
	boundingDiskLabels=Table[Tooltip[Disk[boundingDisks[[i,1]], boundingDisks[[i,2]]], componentLabels[[i]]], {i,1,Length[boundingDisks]}];

	Switch[Lookup[safeOps,PlotType],
		Overlay,
			plotCellCountOverlay[components,image,componentsToPlot,boundingDiskLabels,safeOps],
		PieChart,
			plotCellCountPieChart[areas,{minSingleCellSize,maxSingleCellSize},componentLabels,singleCellAreas,safeOps],
		Text,
			plotCellCountText[totalCount,areas,singleCellAreas,safeOps]
	]
];


(* ::Subsubsection::Closed:: *)
(*plotCellCountOverlay*)


plotCellCountOverlay[components:({}|{{}}),image_,componentsToPlot_,boundingDiskLabels_,safeOps_List]:=
	Show[image,ImageSize->Lookup[safeOps,ImageSize]];

plotCellCountOverlay[components_,image_,componentsToPlot_,boundingDiskLabels_,safeOps_List]:=Module[
	{imageSize,compImage,labelGraphics,blendingFraction,epilog},
	imageSize = Lookup[safeOps,ImageSize];
	compImage = Colorize[componentsToPlot];
	blendingFraction = Lookup[safeOps,BlendingFraction];
	labelGraphics = Graphics[Prepend[boundingDiskLabels, Opacity[0]]];
	epilog=Replace[Lookup[safeOps,Epilog],Automatic->{}];
	Show[ImageCompose[image,{compImage,blendingFraction}], labelGraphics, PassOptions[Graphics,{Epilog->epilog,ImageSize->imageSize,Sequence@@safeOps}]]
];


(* ::Subsubsection:: *)
(*plotCellCountBarChart*)


plotCellCountBarChart[counts_,safeOps_List]:=Module[
	{countsToPlot,chartLabelOpt,frameLabelOpt,labelOrientation,chartLabels,frameLabels,epilog},
	countsToPlot = counts;
	(* pull out some option values *)
	chartLabelOpt = ChartLabels/.safeOps;
	frameLabelOpt = FrameLabel/.safeOps;
	labelOrientation=ChartLabelOrientation/.safeOps;

	(* set the chart labels *)
	chartLabels = If[
		(NullQ[chartLabelOpt]||MatchQ[chartLabelOpt,None]),
		{},
		If[
			MatchQ[labelOrientation,Vertical],
			Placed[ToString/@(chartLabelOpt),Axis,Rotate[#,Pi/2] &],
			chartLabelOpt
		]
	];

	(* set the frame labels *)
	frameLabels = If[MatchQ[frameLabelOpt,Automatic],
		{None,ToString[CellCount]},
		frameLabelOpt
	];

	If[MemberQ[Flatten[ToList[countsToPlot]],Null],
		Message[PlotCellCount::NoCounts];
		Return[];
	];

	If[MatchQ[countsToPlot,{{UnitsP[]..}..}],
		countsToPlot = Replicates@@@countsToPlot;
	];

	If[MatchQ[countsToPlot,UnitsP[]],
		countsToPlot = {countsToPlot};
	];

	(* Resolve epilog *)
	epilog=Replace[Lookup[safeOps,Epilog],Automatic->{}];

	(* plot the bar chart *)
	EmeraldBarChart[countsToPlot,
		PassOptions[EmeraldBarChart,
			FrameLabel->frameLabels,
			AspectRatio->Replace[AspectRatio/.safeOps,Automatic->1/GoldenRatio],
			PlotRangeClipping->True,
			Frame->Automatic,
			ChartLabels->chartLabels,
			Epilog->epilog,
			Sequence@@safeOps
		]
	]

];



(* ::Subsubsection::Closed:: *)
(*plotCellCountPieChart*)


plotCellCountPieChart[areas_,{minSingleCellSize_,maxSingleCellSize_},componentLabels_,singleCellAreas_,safeOps_List]:=Module[
	{singleCellBool,legend,epilog},

	legend = If[Lookup[safeOps,Legend]===Automatic,componentLabels,Lookup[safeOps,Legend]];
	legend = Core`Private`resolvePlotLegends[legend,PassOptions[PlotCellCount,Core`Private`resolvePlotLegends,safeOps]];

	(* Resolve epilog *)
	epilog=Replace[
		Lookup[safeOps,AspectRatio],
		Automatic->If[
			singleCellBool&&Length[singleCellAreas]>0,
			{Text[Style["Single Cell Component", Cyan,Bold,14, FontFamily->"Arial"],{0,-1.1}]},
			{}
		]
	];

	singleCellBool=Lookup[safeOps,SingleCell];
	Show[
		PieChart[
			Table[
				Tooltip[
					(*if it's a single cell highlight piechart*)
					If[singleCellBool&&areas[[i]]>minSingleCellSize&&areas[[i]]<maxSingleCellSize,
						Style[areas[[i]], EdgeForm[{Thick,Cyan}]],
						areas[[i]]
					],
					componentLabels[[i]]
				],
				{i,1,Length[areas]}
			],
			Epilog->epilog,
			ChartLegends->legend,
			AspectRatio->Replace[Lookup[safeOps,AspectRatio],Automatic->1],
			PassOptions[PieChart,safeOps]
		],
		ImageSize->Lookup[safeOps,ImageSize]
	]
];


(* ::Subsubsection::Closed:: *)
(*plotCellCountText*)


plotCellCountText[totalCount_,areas_,singleCellAreas_,safeOps_List]:= Module[
	{cellDiameter,countError,averageSingleArea},

	averageSingleArea =
		If[MatchQ[singleCellAreas,{}],
			0,
			Mean[singleCellAreas]
		];
	cellDiameter=(2*Sqrt[averageSingleArea/\[Pi]]);
	countError=CellCountError/.safeOps;

	Column[{
		Row[{
			Style["Number of Cells: ", Black,Bold,14, FontFamily->"Arial"],
			Style[ToString[totalCount], Black,14, FontFamily->"Arial"]
		}],
		Row[{
			Style["Count Error: ",Black,Bold,14, FontFamily->"Arial"],
			Style["+/- "<>ToString[countError],Black,14, FontFamily->"Arial"]
		}],
		Row[{
			Style["Number of Cell Components: ",Black,Bold,14, FontFamily->"Arial"],
			Style[ToString[Length[areas]],Black,14, FontFamily->"Arial"]
		}],
		Row[{
			Style["Number of Single Cell Components: ",Black,Bold,14, FontFamily->"Arial"],
			Style[ToString[Length[singleCellAreas]],Black,14, FontFamily->"Arial"]
		}],
		Row[{
			Style["Average Single Cell Area: ",Black,Bold,14, FontFamily->"Arial"],
			Style[ToString[averageSingleArea]<>" \!\(\*SuperscriptBox[\(Pixel\), \(2\)]\)",Black,14, FontFamily->"Arial"]
		}],
		Row[{
			Style["Average Single Cell Diameter: ",Black,Bold, 14, FontFamily->"Arial"],
			Style[ToString[cellDiameter]<>" Pixel",Black ,14, FontFamily->"Arial"]
		}]
	}]
];
