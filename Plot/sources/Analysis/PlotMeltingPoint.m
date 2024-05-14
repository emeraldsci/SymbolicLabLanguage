(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*PlotMeltingPoint*)


DefineOptions[PlotMeltingPoint,
	Options	:> {

		(*** Data Specifications Options ***)
		{
			OptionName -> PlotType,
			Default -> MeltingPoint,
			Description -> "Different types of plot to show in the final figure.",
			AllowNull -> False,
			Widget -> Alternatives[
				"Single Type"->Widget[Type->Enumeration, Pattern:>Alternatives[All,MeltingPoint,Alpha,Derivative,DerivativeOverlay]],
				"Multiple Types"->Adder[
					Widget[Type->Enumeration, Pattern:>Alternatives[All,MeltingPoint,Alpha,Derivative,DerivativeOverlay]]
				]
			],
			Category->"Data Specifications"
		},
		{
			OptionName -> ConfidenceLevel,
			Default -> 0.95,
			Description -> "Confidence level(s) used to compute confidence bands.",
			AllowNull -> False,
			Widget -> Widget[Type->Number, Pattern:>RangeP[0,1]],
			Category->"Data Specifications"
		},
		{
			OptionName -> MeltingDisplay,
			Default -> {MeltingPoint, Interval, MeltingOnsetPoint},
			Description -> "Elements to display on the plot.",
			AllowNull -> False,
			Widget -> Alternatives[
				"Single Element"->Widget[Type->Enumeration, Pattern:>Alternatives[MeltingPoint,Interval,MeltingOnsetPoint,Domain,Range]],
				"Multiple Elements"->Adder[Widget[Type->Enumeration, Pattern:>Alternatives[MeltingPoint,Interval,MeltingOnsetPoint,Domain,Range]]],
				"Other"->Widget[Type->Enumeration,Pattern:>Alternatives[{}]]
			],
			Category->"Data Specifications"
		},
		{
			OptionName -> MeltingCurves,
			Default -> Automatic,
			Description -> "The curve to plot, where All plots all melting curves, for instance, Melting and Cooling curves.",
			AllowNull -> False,
			Widget -> Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[All,Automatic]],
				Widget[Type->Expression, Pattern:>ListableP[None|Analysis`Private`nestedFieldP], Size->Line]
			],
			Category->"Data Specifications"
		},

		(*** General Options ***)
		{
			OptionName->Epilog,
			Default->{},
			AllowNull->False,
			Widget->Widget[Type->Expression, Pattern:>_, Size->Paragraph, BoxText->"A list of graphics primitives or graphics-like objects to render before the main plot."],
			Description->"Primitives rendered after the main plot .",
			Category->"General"
		},
		{
			OptionName->LaserPowerDisplay,
			Default->False,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[True, False]],
			Description->"Specifies whether to show the results of FluorescenceLaserPowerOptimizationResult.",
			Category->"General"
		},

		(*** Legend Options ***)
		LegendOption,
		ModifyOptions[LegendPlacementOption,
			{
        {OptionName->LegendPlacement,Default->Bottom}
			}
		],
		ModifyOptions[BoxesOption,
			{
				{OptionName->Boxes,Default->True}
			}
		],

		(*** Output Option ***)
		OutputOption
	},
	SharedOptions :> {

    (*** Frame Options ***)
    ModifyOptions["Shared",ListPlotOptions,
      {
        {OptionName->Frame,Default->{{True, True}, {True, True}}},
        {OptionName->FrameStyle,Default->Automatic},
				{OptionName->FrameLabel}
      }
    ],

    (*** Plot Labeling Options ***)
    ModifyOptions["Shared",ListPlotOptions,{PlotLabel,LabelStyle}],

    (*** Plot Style Options ***)
    ModifyOptions["Shared",ListPlotOptions,
      {
        {OptionName->Joined,Default->False}
      }
    ],

    (*** Rest of ELLP Options ***)
		EmeraldListLinePlot
	}
];

Error::EmptyData="No data is present for the provided DataSet.";
Warning::SwitchedPlotType="The PlotType `1` is not available, and will be switched to the one that is available in the analysis packet.";

PlotMeltingPoint[mpPacket0: PacketP[Object[Analysis, MeltingPoint]],ops: OptionsPattern[PlotMeltingPoint]]:=Module[
	{
		originalOps,safeOps,alphaCurves,dataSet,dataRef,resolvedOps,mpPacket, plotType, figs,
		fluorescenceSpectraDataQ,staticLightScatteringDataQ,bcmYFrameLabel,slsYFrameLabel,
		dataPoints,staticLightScatteringWavelengths,fluorescenceSpectraInstrument,laserStatus,
		validDataSetQ,meltingBarycentricMeanIndices,meltingIntensityIndices,aggregationIndices,
		dataSetTransformationFunctions,nonbcmYFrameLabel,meltingIndices,genericYFrameLabel,slsSecondYFrameLabel,
		bcmSecondYFrameLabel,nonbcmSecondYFrameLabel,plotTypeBase,meltingCurves,alphaCurvesBase,dataPointsBase,
		dataSetTransformationFunctionsBase,dataSetIndices,plotResults,returnedPlotOps,mergedReturnedOps,thisInstrument,
		thisExcitationWavelength, thisStaticLightScatteringExcitation,temperatureDataSet,responseDataSet,actualDataSet,
		meltingShow,helperOptions,myFig,dlsAndSLSDataQ,dlsLegends,finalPlot
	},

	(* Convert the original option into a list *)
	originalOps=ToList[ops];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
	safeOps=SafeOptions[PlotMeltingPoint,originalOps];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	mpPacket=Analysis`Private`stripAppendReplaceKeyHeads[mpPacket0];

	dataRef=LastOrDefault[Lookup[mpPacket,Reference]];

	{thisInstrument, thisExcitationWavelength, thisStaticLightScatteringExcitation} = If[
		MatchQ[dataRef, Null],
		{Null, Null, Null},
		(*Instrument, ExcitationWavelength, StaticLightScatteringExcitation are new fields added to Analysis object. For older analysis object, we have to download them from Data object*)
		If[!MatchQ[Lookup[mpPacket, Instrument, Null], Null],
			Lookup[mpPacket, {Instrument, ExcitationWavelength, StaticLightScatteringExcitation}],
			Quiet[Download[dataRef, {Instrument, ExcitationWavelength, StaticLightScatteringExcitation}]]
			]
	];

	(*If the Instrument is MeltingPointApparatus, the plot is very different from other instruments.*)
	If[MatchQ[thisInstrument, ObjectP[Object[Instrument, MeltingPointApparatus]]],
		If[$VersionNumber > 13.,
			Return[plotMeasureMeltingPointHelper[mpPacket0]],
			Return[plotMeasureMeltingPointHelperV12[mpPacket0]]
		]
	];

	dlsAndSLSDataQ = !MatchQ[Lookup[mpPacket, DataPointsDLSAverageZDiameter, {}], {}];

	dlsLegends = {"DLS - Estimated Sizes", "SLS - Molecular Weights"};

	(* In case the instrument is multimode Spectrophotometer and, we need to process the 3D fluorescence spectra data *)
	fluorescenceSpectraInstrument=If[MatchQ[dataRef,Null|{}],
		False,
		MatchQ[thisInstrument, ObjectP[Object[Instrument, MultimodeSpectrophotometer]]]
	];
	fluorescenceSpectraDataQ = fluorescenceSpectraInstrument && MatchQ[thisExcitationWavelength,GreaterP[0*Nanometer]];


	(* The result of the laser power optimization *)
	laserStatus=If[fluorescenceSpectraDataQ && Lookup[safeOps,LaserPowerDisplay],
		First[mpPacket[Reference][FluorescenceLaserPowerOptimizationResult]],
		Null
	];

	(* The static light scattering wavelengths in case of fluoresenceSpectraData *)
	staticLightScatteringWavelengths=If[MatchQ[dataRef,Null|{}],
		Null,
		thisStaticLightScatteringExcitation
	];
	staticLightScatteringDataQ=MatchQ[staticLightScatteringWavelengths,GreaterP[0*Nanometer]|{GreaterP[0*Nanometer]..}];

	(* The name of the datasets in mpPacket that stores that curves *)
	temperatureDataSet=safeNullListLookup[Lookup[mpPacket,ResolvedOptions],TemperatureDataSet];
	responseDataSet=safeNullListLookup[Lookup[mpPacket,ResolvedOptions],ResponseDataSet];

	(* The name of the melting curves in mpPacket that stores that curves *)
	meltingCurves=Lookup[mpPacket,MeltingCurves,Null];

	(* The index of the dataset selected for plotting *)
	dataSetIndices=
		If[MatchQ[Lookup[safeOps,MeltingCurves],Automatic|All],
			All,
			Flatten[Position[meltingCurves,#]& /@ ToList[Lookup[safeOps,MeltingCurves]],2]
		];

	(* resolved DataSet based on the input to PlotMeltingPoint *)
	dataSet=If[MatchQ[dataSetIndices,All],
		meltingCurves,
		If[dataSetIndices==={},
			Null,
			meltingCurves[[dataSetIndices]]
		]
	];

	(* In case {TemperatureDataSet,ResponseDataSet} are not null, actual DataSet is {MeltingCurve}. It was set to MeltingCurve just to use MeltingCurve data object. *)
	actualDataSet=
		If[!MatchQ[{temperatureDataSet,responseDataSet},{Null,Null}|{{},{}}],
			{MeltingCurve},
			dataSet
		];

	(* All alpha curves available in mpPacket *)
	alphaCurvesBase=Unitless[Lookup[mpPacket,MeltingCurvesFractionBound,Null]];

	(* All melting data points available in mpPacket *)
	dataPointsBase=Unitless[Lookup[mpPacket,MeltingCurvesDataPoints,Null]];

	(* The name of all dataset transoformation functions in mpPacket *)
	dataSetTransformationFunctionsBase=Lookup[mpPacket,MeltingCurvesTransformation];

	(* When analyzing non fluorescence spectra data, the final dataset is stored here *)
	{alphaCurves,dataPoints,dataSetTransformationFunctions}=Which[

		(* All dataset needs to be plotted *)
		MatchQ[actualDataSet,meltingCurves],
		{alphaCurvesBase,dataPointsBase,dataSetTransformationFunctionsBase},

		(* A specific dataset needs to be plotted *)
		!MatchQ[actualDataSet,meltingCurves] && !MatchQ[actualDataSet,Null|{}],
		{
			If[!MatchQ[alphaCurvesBase,Null|{}],alphaCurvesBase[[dataSetIndices]],alphaCurvesBase],
			If[!MatchQ[dataPointsBase,Null|{}],dataPointsBase[[dataSetIndices]],dataPointsBase],
			If[!MatchQ[dataSetTransformationFunctionsBase,Null|{}],dataSetTransformationFunctionsBase[[dataSetIndices]],dataSetTransformationFunctionsBase]
		},

		(* A specific dataset needs to be plotted *)
		!MatchQ[actualDataSet,meltingCurves] && MatchQ[actualDataSet,Null|{}],
		{Null,Null,Null}
	];

	(* For fluorescence spectra analysis, we order the plots as melting curve (anything non-aggregation) + aggregation curves *)
	{meltingIndices,meltingBarycentricMeanIndices,aggregationIndices}=
		If[
			fluorescenceSpectraDataQ,
			{
				(* All melting curves *)
				MapThread[
					If[!(StringContainsQ[SymbolName[#1],"Aggregation"]),#2,Nothing]&,
					{actualDataSet,Range[Length[actualDataSet]]}
				],
				(* If the transoformation is Barycentric mean, the melting curves will be transformed using BarycentricMean *)
				If[dataSetTransformationFunctions===Automatic,
					MapThread[
						If[(!(StringContainsQ[SymbolName[#1],"Aggregation"])),#2,Nothing]&,
						{actualDataSet,Range[Length[actualDataSet]]}
					],
					MapThread[
						If[(!(StringContainsQ[SymbolName[#1],"Aggregation"]) && MatchQ[#2,BarycentricMean]),#3,Nothing]&,
						{actualDataSet,dataSetTransformationFunctions,Range[Length[actualDataSet]]}
					]
				],
				(* Aggregation curves *)
				MapIndexed[
					If[StringContainsQ[SymbolName[#1],"Aggregation"],First[#2],Nothing]&,
					actualDataSet
				]
			},
			(* For other than fluorescence spectra data, we don't utilize the indices *)
			{{},{},{}}
		];

	(* All melting curves with non BarycentricMean transformation *)
	meltingIntensityIndices=Complement[meltingIndices,meltingBarycentricMeanIndices];

	(* Throw an error if the dataset is empty *)
	validDataSetQ=If[MatchQ[actualDataSet,Null],Return[Message[Error::EmptyData];$Failed]];

	(* Extra options to pass the PlotMeltingPoint helper function *)
	helperOptions=plotHelperOptions[mpPacket,dataSetIndices];

	(* PlotType option primarily selected *)
	plotTypeBase=Lookup[safeOps,PlotType];

	(* Change the selected plottype if there is no datapoints to show *)
	plotType=Which[
		(* If we have datapoints, use them *)
		!MatchQ[dataPoints,Null|{}] && !MatchQ[alphaCurves,Null|{}],
		plotTypeBase,

		(* Melting|Derivative|DerivativeOverlay will require dataPoints that is not available *)
		MatchQ[dataPoints,Null|{}] && !MatchQ[alphaCurves,Null|{}] && MatchQ[plotTypeBase,MeltingPoint|Derivative|DerivativeOverlay],
		Message[Warning::SwitchedPlotType,plotTypeBase];Alpha,

		(* Alpha is fine if we have alphaCurves available *)
		MatchQ[dataPoints,Null|{}] && !MatchQ[alphaCurves,Null|{}],
		plotTypeBase,

		(* Alpha will require alphaCurves that is not available *)
		!MatchQ[dataPoints,Null|{}] && MatchQ[alphaCurves,Null|{}] && MatchQ[plotTypeBase,Alpha],
		Message[Warning::SwitchedPlotType,plotTypeBase];MeltingPoint,

		(* PlotTypes other than Alpha should be fine if we have dataPoints *)
		!MatchQ[dataPoints,Null|{}] && MatchQ[alphaCurves,Null|{}],
		plotTypeBase,

		(* If none of these cases, then there is no curve available. This should be caught in EmptyData *)
		MatchQ[dataPoints,Null|{}] && MatchQ[alphaCurves,Null|{}],
		Return[$Failed]
	];

	plotResults={};

	(* Y frames to show for different types of melting curves and aggregation curves *)
	bcmYFrameLabel="BarycentricMean "<>UnitForm[Nanometer,Number->False];
	nonbcmYFrameLabel="Y-axis "<>UnitForm[ArbitraryUnit,Number->False];
	slsYFrameLabel="Intensity "<>UnitForm[ArbitraryUnit,Number->False];
	bcmSecondYFrameLabel="BCM Derivative "<>UnitForm[Nanometer/Celsius,Number->False];
	nonbcmSecondYFrameLabel="Y2-axis "<>UnitForm[ArbitraryUnit/Celsius,Number->False];
	slsSecondYFrameLabel="Intensity Derivative "<> UnitForm[ArbitraryUnit/Celsius,Number->False];
	genericYFrameLabel={
		"Intensity "<>UnitForm[ArbitraryUnit,Number->False],
		"Absorbance Derivative "<> UnitForm[ArbitraryUnit/Celsius,Number->False]
	};

	(* The way to present melting results for the fluorescence spectra analysis*)
	meltingShow=Which[
		(* By default only BarycentricMean is presented *)
		(Length[meltingBarycentricMeanIndices]>0 && plotType=!=All),
		{meltingBarycentricMeanIndices,bcmYFrameLabel,bcmSecondYFrameLabel},

		(* If all is selected, all melting curves will be presented *)
		(Length[meltingBarycentricMeanIndices]>0 && plotType===All),
		{meltingIndices,nonbcmYFrameLabel,nonbcmSecondYFrameLabel},

		(* All melting curves will be  presented *)
		Length[meltingBarycentricMeanIndices]==0,
		{meltingIndices,nonbcmYFrameLabel,nonbcmSecondYFrameLabel}
	];

	(* Make a list of plots to be shown in the output. They will be aggregated using TabView. *)
	myFig = If[dlsAndSLSDataQ,

		(*if the input data contains both SLS and DLS data, only one plot will be used*)
		List[plotDLSMeltingCurve[dataPoints, dlsLegends, helperOptions, safeOps]],

		(*for other cases, plots will be chosen accordingly*)
		List[
			appendFigMeltingPointMeltingIdx[plotType, fluorescenceSpectraDataQ, staticLightScatteringDataQ, meltingIndices, dataPoints, meltingShow, dataSet, laserStatus, helperOptions, safeOps],
			appendFigMeltingPointAggreIdx[plotType, fluorescenceSpectraDataQ, staticLightScatteringDataQ, aggregationIndices, dataPoints, staticLightScatteringWavelengths, slsYFrameLabel, laserStatus, helperOptions, safeOps],
			appendFigMeltingPoint[plotType, fluorescenceSpectraDataQ, staticLightScatteringDataQ, dataPoints, meltingShow, dataSet, laserStatus, helperOptions, safeOps],
			appendFigAlpha[plotType, fluorescenceSpectraDataQ, alphaCurves, dataSet, helperOptions, safeOps],
			appendFigDerivative[plotType, fluorescenceSpectraDataQ, dataPoints, dataSet, helperOptions, safeOps],
			appendFigDerivativeOverlayMeltingIdx[plotType, fluorescenceSpectraDataQ, staticLightScatteringDataQ, meltingIndices, dataPoints, meltingShow, dataSet, helperOptions, safeOps],
			appendFigDerivativeOverlayAggreIdx[plotType, fluorescenceSpectraDataQ, staticLightScatteringDataQ, aggregationIndices, dataPoints, staticLightScatteringWavelengths, slsYFrameLabel, slsSecondYFrameLabel, helperOptions, safeOps],
			appendFigDerivativeOverlay[plotType, fluorescenceSpectraDataQ, staticLightScatteringDataQ, dataPoints, meltingShow, dataSet, genericYFrameLabel, helperOptions, safeOps]
		]
	];

	(* Extract the figures and options from plotResults *)
  figs=myFig[[;;,1]];
  returnedPlotOps=myFig[[;;,2]];

	(* make final plots using overload function*)
  finalPlot = Which[
  	(* if the reference is qPCR use the qPCR specific plotting *)
		MatchQ[FirstOrDefault[dataRef], ObjectP[Object[Data, qPCR]]],
		PlotqPCR[mpPacket0, PrimaryData->MeltingCurves],
    
    (* other reference will return a merged plot*)
    True,
    finalPlot = mergePlots[figs, plotType, fluorescenceSpectraDataQ, staticLightScatteringDataQ, dlsAndSLSDataQ, meltingIndices, aggregationIndices, meltingIntensityIndices, meltingBarycentricMeanIndices]

  ];

	(* Options are aggregated into a single list by preserving those that were resolved to the same value for all inputs. Any options resolved to different values between inputs are set to Automatic. *)
  mergedReturnedOps=MapThread[If[CountDistinct[List@##]>1,First@#->Automatic,First@DeleteDuplicates[List@##]]&,returnedPlotOps];

  (* The final resolved options based on safeOps and the returned options from ELLP calls *)
  resolvedOps=ReplaceRule[safeOps,Prepend[mergedReturnedOps,Output->output]];

  (* Return the result, options, or tests according to the output option. *)
  output/.{
    Result->finalPlot,
    Preview->finalPlot,
    Tests->{},
    Options->resolvedOps
  }

];

PlotMeltingPoint[mpObj:ObjectReferenceP[Object[Analysis,MeltingPoint]]|LinkP[Object[Analysis,MeltingPoint]],ops:OptionsPattern[]]:=PlotMeltingPoint[Download[mpObj],ops];
PlotMeltingPoint[mpObjs:{(ObjectReferenceP[Object[Analysis,MeltingPoint]])...},ops:OptionsPattern[]]:=PlotMeltingPoint[Download[mpObjs],ops];
PlotMeltingPoint[mpPackets:{PacketP[Object[Analysis, MeltingPoint]]...},ops:OptionsPattern[]]:=Module[

	{plotLabels,plots,names,mergedReturnedOps,originalOps,safeOps,output,resolvedOps},

	(* Convert the original option into a list *)
	originalOps=ToList[ops];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
	safeOps=SafeOptions[PlotMeltingPoint,originalOps];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(* Names associated with the data packets. Use a single Download call to get all names. *)
	names = Download[
		FirstOrDefault[#]&/@Lookup[mpPackets, Append[Reference], {}],
		Name
	];

	(* The label based on the name of the object. If singlet, no label is used *)
	plotLabels=If[Length[plots] === 1,
		Automatic,
		If[MatchQ[#,Null|{}|Name]||MissingQ[#],Automatic,#]&/@names
	];

	(* Place all figures into a slide show *)
	{plots,returnedPlotOps}=Transpose[
		MapIndexed[
			PlotMeltingPoint[#1,Sequence@@ReplaceRule[safeOps,{PlotLabel->plotLabels[[First[#2]]],Output->{Result,Options}}]]&,
			mpPackets
		]
	];

	(* Options are aggregated into a single list by preserving those that were resolved to the same value for all inputs. Any options resolved to different values between inputs are set to Automatic. *)
	mergedReturnedOps=MapThread[If[CountDistinct[List@##]>1,First@#->Automatic,First@DeleteDuplicates[List@##]]&,returnedPlotOps];

	(* The final resolved options based on safeOps and the returned options from ELLP calls *)
	resolvedOps=ReplaceRule[safeOps,
		Prepend[mergedReturnedOps,
			{
				Output->output,
				Epilog->Lookup[safeOps,Epilog],
				Prolog->Lookup[safeOps,Prolog]
			}
		]
	];

	(* Return the result, options, or tests according to the output option. *)
	output/.{
		Result-> (If[Length[plots] === 1, Zoomable@First[plots], SlideView[Zoomable@plots]]),
		Preview->(If[Length[plots] === 1, Zoomable@First[plots], SlideView[Zoomable@plots]]),
		Tests->{},
		Options->resolvedOps
	}

];

(* Options to pass to the helper plot functions *)
plotHelperOptions[mpPacket_,inds_]:=Module[{},
  {
    MeltingTransitions->Lookup[mpPacket,MeltingTransitions][[inds]],
    MeltingPoint->Lookup[mpPacket,MeltingTemperatures][[inds]],
    MeltingPointStandardDeviation->Lookup[mpPacket,MeltingTemperatureStandardDeviations][[inds]],
    MeltingOnsetPoint->Lookup[mpPacket,MeltingOnsetTemperatures][[inds]]
  }
];

safeNullListLookup[Null|{Null},field_]:={};
safeNullListLookup[ruleList_,field_]:=Lookup[ruleList,field,Null];

plotMeasureMeltingPointHelper[analysisPacket_] := Module[
	{
		mpPacket, protocol, protocolObj, pointUSP, pointBP, pointJP, downloadFields, totalDownloads, allIDs, allDataObjs, tooltippedIDs,
		startTs, endTs, curves, videoFiles, pointsUSP, pointsBP, pointsJP,
		allLineValues, labeledPointsXY, pointsUnitlessUSP, pointsUnitlessBP, pointsUnitlessJP,
		videoStream, duration, startTemp, endTemp, graphicsRange, allColors, imageSizeCalculation, allStandardsP,
		minPercent, maxPercent, plotRangeXMin, plotRangeXMax, plotRangeYMin, plotRangeYMax, plotImageSize, plotImagePadding,
		dataObjList, analysisObjList, sampleNumber
	},
	mpPacket=Analysis`Private`stripAppendReplaceKeyHeads[analysisPacket];

	protocol = Last@Download[mpPacket, Reference[Protocol]];
	protocolObj = protocol[Object];
	{dataObjList, analysisObjList} = Download[protocol, {Data, Data[MeltingAnalyses]}];

	{pointUSP, pointBP, pointJP} = Download[analysisPacket,
		{USPharmacopeiaMeltingRange, BritishPharmacopeiaMeltingPoint, JapanesePharmacopeiaMeltingPoint}
	];

	(*Download all other necessary information for the plot*)
	downloadFields = {
		Object, StartTemperature, EndTemperature, MeltingCurve, CapillaryVideoFile,
		MeltingAnalyses[USPharmacopeiaMeltingRange], MeltingAnalyses[BritishPharmacopeiaMeltingPoint], MeltingAnalyses[JapanesePharmacopeiaMeltingPoint]
	};
	totalDownloads = Download[protocol, Data[downloadFields]];
	{allDataObjs, startTs, endTs, curves, videoFiles, pointsUSP, pointsBP, pointsJP} = Transpose[totalDownloads];
	(* these need to be in lists to conform with legacy code below, consider refactoring to simplify *)
	pointsUSP = ConstantArray[pointUSP, Length[startTs]];
	pointsBP = ConstantArray[pointBP, Length[startTs]];
	pointsJP = ConstantArray[pointJP, Length[startTs]];

	allIDs = allDataObjs[[All, -1]];
	tooltippedIDs = MapThread[Tooltip, {allIDs, allDataObjs}];


	{pointsUnitlessUSP, pointsUnitlessBP, pointsUnitlessJP} = QuantityMagnitude[{pointsUSP, pointsBP, pointsJP}];

	(*In theory, starting and ending temperatures should be the same for all samples, due to measuring noise they could still be different.*)
	startTemp = QuantityMagnitude[Min[startTs]];
	endTemp = QuantityMagnitude[Max[endTs]];

	allLineValues = QuantityMagnitude[curves];

	(*calculate PlotRange. These will be integers slightly larger than the real data range.*)
	(*Find minimum/maximum percentage among all line values.*)
	minPercent = Min[#[[2]]& /@ Flatten[allLineValues, 1]];
	maxPercent = Max[#[[2]]& /@ Flatten[allLineValues, 1]];

	plotRangeXMin = Floor[startTemp];
	plotRangeXMax = Ceiling[endTemp];

	(*In theory, the percentage is always from 0 to 100%, here to give it a bit larger range for noise and nicer plot.*)
	plotRangeYMin = Min[-5, Floor[minPercent]];
	plotRangeYMax = Max[105, Ceiling[maxPercent]];

	graphicsRange = {{plotRangeXMin, plotRangeXMax}, {plotRangeYMin, plotRangeYMax}};

	(*Create an association for the plot. The desired format for labeledPointsXY is
   <|
      1-> <|"USP"->{point1, point2}, "BP"->{point1}, "JP"->{point1}|>,
      2-> <|"USP"->{point1, point2}, "BP"->{point1}, "JP"->{point1}|>,
      3-> <|"USP"->{point1, point2}, "BP"->{point1}, "JP"->{point1}|>
   |>, and each point is {x, y}.
   *)
	labeledPointsXY = coordinatesAssociation[allLineValues, pointsUnitlessUSP, pointsUnitlessBP, pointsUnitlessJP];
	sampleNumber = Length[labeledPointsXY];

	(*Import video*)
	(*There will be a warning General::sysffmpeg from MM if the operation system did not install FFmpeg decoder. And it only appears once for fresh loaded SLL.*)
	videoStream = Quiet[VideoStream[DownloadCloudFile[First[videoFiles], $TemporaryDirectory], ImageSize->300], {General::sysffmpeg}];
	duration = QuantityMagnitude[videoStream["Duration"], Second];

	(*all colors chosen for display data*)
	allColors = {
		LCHColor[0.6, 1, 0.5], LCHColor[0.9, 1, 0.2], LCHColor[0.7, 0.9, 1],
		LCHColor[0.6, 1, 0.7], LCHColor[0.7, 1, 0.1], LCHColor[0.8, 0.6, 0.2]
	};

	emeraldPlotDefaultGray = RGBColor["#5E6770"];
	emeraldPlotDefaultDarkerGray = RGBColor["#3e454c"];

	(*use the helper function to determine interactive plot parameters, {400, 350} is ImageSize, {{50, 15}, {50, 10}} is padding.*)
	plotImageSize = {400, 350};
	plotImagePadding = {{50, 15}, {50, 10}};
	imageSizeCalculation = SciCompFramework`Private`resolveImageSize[plotImageSize,plotImagePadding];


	(* Overview of plot components*)
	(* -------------------------------------------------------*)
	(* -        Title                                        -*)
	(* -        popupMenu                    interactiveGuide-*)
	(* -------------------------------------------------------*)
	(* -        -                         -   selectIcon     -*)
	(* -        -                         -                  -*)
	(* -        -   interactivePlot       -   Video          -*)
	(* -        -                         -                  -*)
	(* - Legend -                         -   slider/buttons -*)
	(* -------------------------------------------------------*)

	(*DynamicModule[{closedInteractionGuide, ___}, ___] was used to pattern match in command center preview - AppHelpers`Private`makeGraphicSizeFull,
  remember to update the pattern accordingly if any changes made here. *)
	DynamicModule[
		{
			closedInteractionGuide, startState, hoverState, endState, multipleSelection = {1}, standardSelection = "USP",
			timeUnitless = 0,  vLineX = startTemp*1.1
		},

		(*Components of the plot*)
		componentTitle[title_] := Style[
			Text[title, BaseStyle -> {FontFamily -> "Helvetica", Bold}],
			FontSize -> 18, FontColor -> emeraldPlotDefaultDarkerGray
		];

		componentPopupMenu := popupMenuSelectStandard[Dynamic[standardSelection], {"USP", "BP", "JP"}];

		componentInteractiveGuide := AttachCell[
			EvaluationBox[],
			(*Interactive Instructions*)
			{startState, hoverState, endState} = SciCompFramework`Private`makeInteractiveGuideToggler[{
				{Description -> "Click zoom the image", ButtonSet -> "'LeftClick' + 'Drag'"},
				{Description -> "Scroll zoom the image", ButtonSet -> "'MouseWheel'"},
				{Description -> "Zoom out", ButtonSet -> "'LeftClick'"},
				{Description -> "Pan across the image", ButtonSet -> "'Shift' + 'LeftClick'+'Drag'"}
			}];
			(*Event handler to open and close the interaction guide*)
			closedInteractionGuide = True;
			EventHandler[Dynamic[
				If[closedInteractionGuide,
					If[CurrentValue["MouseOver"], hoverState, startState],
					endState
				],
				TrackedSymbols :> {closedInteractionGuide}
			],
				"MouseClicked" :> (closedInteractionGuide = Not[closedInteractionGuide])],
			(*Location of the attached cell*)
			Top, Offset[{625, -20}, 0], {Right, Top}
		];

		(*Create legend using EmeraldSelectionBar*)
		componentSelectionBar := ECL`SciCompFramework`EmeraldSelectionBar[
			Dynamic[multipleSelection],

			# -> ECL`SciCompFramework`EmeraldMenuItem[{
				Dynamic[menuIcon[allColors[[#]], White, MemberQ[multipleSelection, #]], TrackedSymbols :> {multipleSelection}],
				tooltippedIDs[[#]]
			}]&
					/@ Range[sampleNumber],

			Style -> "EmeraldSelectionBarPlotMeltingPoint", FieldSize -> 9
		];


		(*Plot a labeled point on the curve, given the index (1/2/3), standard (USP/BP/JP), and point number (USP has two points, and BP/JP has one point).
    The points have outer circle white, and inner circle consistent with line color*)
		(*This helper function was used in both labeled points on the curve, and on the slider.*)
		allStandardsP = "USP" | "BP" | "JP";
		helperCurvePoints[pointsCoordinates_, Dynamic[traceCurve_], Dynamic[traceStandard_], curveIdx_, standard:allStandardsP, standardPointIdx_] :=
				Dynamic[
					If[MemberQ[traceCurve, curveIdx] && traceStandard == standard,
						{
							Style[Point[pointsCoordinates[curveIdx][standard][[standardPointIdx]]], PointSize[0.025], White],
							Style[Point[pointsCoordinates[curveIdx][standard][[standardPointIdx]]], PointSize[0.02], Darker[allColors[[curveIdx]]]]
						},
						{}
					],
					TrackedSymbols :> {traceCurve, traceStandard}
				];

		(*plot a single line and its labeled points given the line index*)
		helperPlotCurveWithPoints[allLineV_, Dynamic[multipleS_], Dynamic[standardS_], idx_]:= {
			Dynamic[
				If[MemberQ[multipleS, idx],
					Style[Line[allLineV[[idx]]], allColors[[idx]], Thickness[0.007]],
					{}
				],
				TrackedSymbols :> {multipleS}
			],

			(*USP has two points, BP and JP has one point each*)
			helperCurvePoints[labeledPointsXY, Dynamic[multipleS], Dynamic[standardS], idx, Sequence@@#]& /@ {{"USP", 1}, {"USP", 2}, {"BP", 1}, {"JP", 1}}
		};

		(*When mouse move in or out of the labeled points, use EventHandler to change show epilog status.*)
		helperEventHandler[Dynamic[traceCurve_], Dynamic[traceStandard_], curveIdx_]:= DynamicModule[{traceEpilog1=False, traceEpilog2=False},
			{
				(*depending on the showEpilog1 or showEpilog2, return the epilog or empty primitive*)
				(*This primitive has to be on top of the EventHandler, otherwise the epilog will keep blinking when mouse hovers on it.*)
				Dynamic[
					Which[
						traceEpilog2,
						singlePointEpilog[labeledPointsXY[curveIdx][traceStandard][[1]], plotRangeXMin, plotRangeYMin, Darker[allColors[[curveIdx]]]],
						traceEpilog1 && traceStandard == "USP",
						singlePointEpilog[labeledPointsXY[curveIdx][traceStandard][[2]], plotRangeXMin, plotRangeYMin, Darker[allColors[[curveIdx]]]],
						traceEpilog1 && (traceStandard == "BP" || traceStandard=="JP"),
						singlePointEpilog[labeledPointsXY[curveIdx][traceStandard][[1]], plotRangeXMin, plotRangeYMin, Darker[allColors[[curveIdx]]]],
						True,
						{}
					],
					TrackedSymbols :> {traceStandard, traceEpilog1, traceEpilog2}
				],

				EventHandler[
					Dynamic[
						If[MemberQ[traceCurve, curveIdx] && traceStandard == "USP",
							Style[Point[labeledPointsXY[curveIdx]["USP"][[1]]], PointSize[0.03], Opacity[0]],
							{}
						],
						TrackedSymbols :> {traceCurve, traceStandard}
					],
					{
						"MouseEntered" :> (traceEpilog2 = If[MemberQ[traceCurve, curveIdx] && traceStandard == "USP", True, False]),
						"MouseExited" :> (traceEpilog2 = False)
					}
				],
				EventHandler[
					Dynamic[
						If[MemberQ[traceCurve, curveIdx] && (traceStandard == "JP" || traceStandard == "BP" || traceStandard == "USP"),
							Style[Point[labeledPointsXY[curveIdx]["USP"][[2]]], PointSize[0.03], Opacity[0]],
							{}
						],
						TrackedSymbols :> {traceCurve, traceStandard}
					],
					{
						"MouseEntered" :> (traceEpilog1 = If[MemberQ[traceCurve, curveIdx] && (traceStandard == "JP" || traceStandard == "BP" || traceStandard == "USP"), True, False]),
						"MouseExited" :> (traceEpilog1 = False)
					}
				]
			}];

		(*interactive plot*)
		componentLinePlots = DynamicModule[
			{
				SciCompFramework`Private`xMin = plotRangeXMin, SciCompFramework`Private`xMax = plotRangeXMax,
				SciCompFramework`Private`yMin = plotRangeYMin, SciCompFramework`Private`yMax = plotRangeYMax,
				zoomFactor = {1.0, 1.0}
			},
			Graphics[
				{
					(*plot melting data lines with labeled points*)
					helperPlotCurveWithPoints[allLineValues, Dynamic[multipleSelection], Dynamic[standardSelection], #]& /@Range[sampleNumber],

					(*zoom layer*)
					SciCompFramework`Private`clickZoomLayer[True, graphicsRange, {0, 0}, False],

					(*When mouse move in or out of the labeled points, use EventHandler to change showEpilog status.*)
					helperEventHandler[Dynamic[multipleSelection], Dynamic[standardSelection], #]& /@ Range[sampleNumber],

					(*drag vertical line*)
					EventHandler[
						(*the vertical line stretches a little bit to look nicer*)
						Dynamic[Style[Line[{
							{startTemp + QuantityMagnitude[videoStream["Position"], Second] / duration*(endTemp - startTemp), -10},
							{startTemp + QuantityMagnitude[videoStream["Position"], Second] / duration*(endTemp - startTemp), 110}
						}], Thickness[0.0075], Dashing[{0.03, 0.01}]]],

						{"MouseDragged" :> (
							(*update key variables here upon dragging*)
							(*set boundary values if mouse position is out of range*)
							vLineX = Which[
								MousePosition["Graphics"][[1]] >= endTemp,
								endTemp,
								MousePosition["Graphics"][[1]] <= startTemp,
								startTemp,
								True,
								MousePosition["Graphics"][[1]]
							];
							videoStream["Position"] = Quantity[duration*(vLineX - startTemp)/(endTemp - startTemp), "Seconds"];
							timeUnitless = duration*(vLineX - startTemp)/(endTemp - startTemp)
						)}
					],

					(*panning layer*)
					SciCompFramework`Private`panningLayer[graphicsRange, "ShiftKey"]

				},
				Frame -> {True, True, True, True},
				FrameLabel -> {"Temperature (\[Degree]C)", "Transmission(%)"},
				FrameStyle -> Directive[16, emeraldPlotDefaultGray, Thickness[0.003]],
				LabelStyle -> Plain,
				ImageSize -> imageSizeCalculation,
				PlotRangePadding -> None,
				PlotRangeClipping -> True,
				ImagePadding -> plotImagePadding,
				PlotRange -> Dynamic[{{SciCompFramework`Private`xMin, SciCompFramework`Private`xMax}, {SciCompFramework`Private`yMin, SciCompFramework`Private`yMax}}],
				AspectRatio -> Full
			] // (*ZoomWrapper to concatenate all*)
					SciCompFramework`Private`scrollZoomWrapper[True, graphicsRange, {0, 0}, imageSizeCalculation, {False, False}]
		];


		(*component to show video*)
		componentVideo = Grid[{
			(*Overlay the video, selection icons with background*)
			{Overlay[{
				Graphics[
					{
						(*Background black rectangle*)
						{Black, Rectangle[{0, 0}, {600, 360}]},

						(*Three selection icons on top of video. For 6 sample cases, the coordinates need to be updated accordingly.*)
						MapThread[Dynamic[iconPrimitive[#1, 330, 20, allColors[[#2]], MemberQ[multipleSelection, #2]]]&, {{193, 293, 393}, Range[sampleNumber]}]

					},
					ImageSize -> {600, 360}, PlotRange -> {{0, 600}, {0, 360}}
				],
				(*Show video*)
				Dynamic[videoStream["CurrentFrame"]],
				(*Thin background underneath the video*)
				Graphics[{{Black, Rectangle[{0, 0}, {600, 10}]}}, ImageSize -> {600, 10}, PlotRange -> {{0, 600}, {0, 10}}]
			},
				Alignment -> {Center, Bottom}]
			},

			(*slider bar and play/pause button underneath the overlay*)
			{Framed[
				Grid[{
					{
						interactiveSlider[
							0, duration, startTemp, endTemp, labeledPointsXY, Dynamic[timeUnitless],
							Dynamic[videoStream["Position"]], Dynamic[multipleSelection], Dynamic[standardSelection]
						],

						ClickPane[
							Dynamic[If[videoStream["Status"] === "Playing",
								buttonPlay[emeraldPlotDefaultGray, White, {30, 30}],
								If[CurrentValue["MouseOver"],
									buttonPlay[emeraldPlotDefaultGray, White, {30, 30}],
									buttonPlay[White, emeraldPlotDefaultGray, {30, 30}]]
							]],
							(If[videoStream["Status"]==="Paused" || videoStream["Status"]==="Stopped", VideoPlay[videoStream]]) &
						],

						ClickPane[
							Dynamic[If[videoStream["Status"] != "Playing",
								buttonPause[emeraldPlotDefaultGray, White, {30, 30}],
								If[CurrentValue["MouseOver"],
									buttonPause[emeraldPlotDefaultGray, White, {30, 30}],
									buttonPause[White, emeraldPlotDefaultGray, {30, 30}]]
							]],
							VideoPause[videoStream] &
						]
					}
				}, Alignment -> {Center, Center, Center}],
				FrameMargins -> {{0, 0}, {-1, 10}}, FrameStyle -> None
			]}
		},
			Alignment -> {Center, Center}, Spacings -> {2, 0.2}];

		(*The slider is similar to zSelector in interactive framework*)
		interactiveSlider[
			timeStart_, timeEnd_, temperatureStart_, temperatureEnd_, labeledPts_,
			Dynamic[currentTime_], Dynamic[streamPosition_], Dynamic[multipleSel_], Dynamic[standardSel_]
		]:=DynamicModule[
			{
				boxMiddle, activeXPos, xPos, yPos, mouseMover, zMinX, zMaxX, zBoxHalfHeight, zMouseMover, boxMax, boxMin,
				unitString, fontSize, fontFamily, smallThickness, largeThickness, tickLengths, sliderLineThickness,
				sliderBoxThickness, sliderLineColor, arrowSteepness, fontColor, alignment, sliderFaceColor, sliderFontColor,
				assoSliderPoints
			},
			(*initialize parameters*)
			boxMiddle = 1+currentTime/duration*9;
			zMouseMover = False;
			sliderFaceColor = White;
			sliderFontColor = emeraldPlotDefaultGray;
			(*set range for ticks*)
			boxMin = 1;
			boxMax = 10;
			(*axis parameters*)
			smallThickness = 0.005;
			largeThickness = 0.005;
			tickLengths = 0.15;
			(*parameters for custom Z selector slider*)
			zMinX = tickLengths + 0.1;
			zMaxX = zMinX + 1.6;
			zBoxHalfHeight = 0.3;
			sliderLineThickness = 0.04;
			sliderBoxThickness = 0.03;
			sliderLineColor = emeraldPlotDefaultGray;
			alignment = -0.6;
			(*font settings*)
			fontSize = 16;
			fontFamily = "Helvetica";
			fontColor = sliderLineColor;
			(*parameter that determines how sharply the arrow points up*)
			arrowSteepness = 1.1;

			(*helper to make one side*)
			axisObjectSide[side : Left | Right | Up | Down] := AxisObject[
				{"Horizontal", 0, {1, 10}},
				TickDirection -> side,
				TickLabels -> None,
				TickPositions -> {{Range[2, 9]}, {{1, 10}}},
				TicksStyle -> {{emeraldPlotDefaultGray, Thickness[smallThickness]}, {emeraldPlotDefaultGray, Thickness[largeThickness]}},
				TickLengths -> tickLengths,
				AxisStyle -> {emeraldPlotDefaultGray, Thick}
			];

			(*helper to convert all numbers to having 2 decimal*)
			formatNumber[number_] := NumberForm[number*1., {Infinity, 2}];

			(*helper to format the number based on font styles*)
			displayNumber[number_, fontColor_] := Style[
				Text[ToString[formatNumber[number]] <> unitString, BaseStyle -> {FontFamily -> "Helvetica"}],
				FontSize -> fontSize,
				FontColor -> fontColor
			];

			(*helper to format text based on font styles and image sizes*)
			displayText[string_] := Pane[
				Style[Text[string, BaseStyle -> {FontFamily -> "Helvetica"}], FontSize -> fontSize, FontColor -> fontColor],
				Alignment -> alignment,
				ImageSize -> {100, 20}
			];

			(*slider box containing numbers function to make different colors*)
			boxContaining[boxMiddleVal_, sliderColor_, fontColor_] := {{
				EdgeForm[{emeraldPlotDefaultGray, AbsoluteThickness[2]}],
				FaceForm[sliderColor],
				poly2[boxMiddleVal]
			}};

			(*convert coordinates to real time in seconds (e.g the real time is from 0 second to 299 seconds)*)
			convertToTime[currentV_] := timeStart + (currentV - 1)/9*(timeEnd - timeStart);

			(*convert temperature points to points on slider*)
			convertLabelPoints[asso_] := AssociationMap[helper2F, asso];
			convertToSlider[value_] := {
				Max[
					boxMin,
					boxMin + (value - temperatureStart)/(temperatureEnd - temperatureStart)*(boxMax - boxMin)
				], 0
			};
			helper2F[key_ -> value_] := key -> AssociationMap[helperF, value];
			helperF[key_ -> value_] := key -> (convertToSlider[First[#]] & /@ value);

			(*points on slider for a single data object*)
			helperSliderLinePoints[assoPoints_, Dynamic[curveTrace_], Dynamic[standardTrace_], curveIdx_]:=
					helperCurvePoints[assoPoints, Dynamic[curveTrace], Dynamic[standardTrace], curveIdx, Sequence@@#]&
							/@ {{"BP", 1}, {"JP", 1}, {"USP", 1}, {"USP", 2}};


			(*main code for the slider*)
			sliderEventHandler[] := EventHandler[
				Graphics[{

					(*Gray Shading*)
					{RGBColor[ConstantArray[0.94, 3]], Rectangle[{1, -tickLengths}, {10, tickLengths + 0.02}]},

					(*Identical axis objects one for left and right*)
					axisObjectSide[Up],
					axisObjectSide[Down],

					helperSliderLinePoints[assoSliderPoints, Dynamic[multipleSel], Dynamic[standardSel], #]& /@ Range[sampleNumber],

					(*Display slider icon*)
					Dynamic[
						If[CurrentValue["MouseOver"],
							boxContaining[boxMiddle, emeraldPlotDefaultGray, White],
							boxContaining[boxMiddle, sliderFaceColor, sliderFontColor]
						],
						TrackedSymbols :> {videoStream["Position"], boxMiddle, sliderFaceColor, sliderFontColor}
					],
					{
						EdgeForm[{Thickness[0.008], Black}],
						White,
						Dynamic[
							boxMiddle = 1 + currentTime/duration*9;
							Style[poly2[boxMiddle], FaceForm[sliderFaceColor], EdgeForm[Directive[Thickness[0.006], emeraldPlotDefaultGray]]],
							TrackedSymbols :> {currentTime, sliderFaceColor}
						]
					}
				},
					ImageSize -> {520, 30},
					PlotRange -> {{0.85, 10.15}, {-0.3, 0.35}},
					AspectRatio -> 1/19,
					ImagePadding -> {{0, 0}, {0, 0}}
				],
				{
					"MouseDown" :> (
						{xPos, yPos} = MousePosition["Graphics"];
						If[And[-1 < xPos < 11, -0.2 < yPos < 0.4],
							(*turn on mouse movement and change the font color*)
							mouseMover = True;
							sliderFontColor = emeraldPlotDefaultGray;
							sliderFaceColor = emeraldPlotDefaultGray
						]),
					"MouseDragged" :> (
						If[mouseMover,
							activeXPos = If[MatchQ[MousePosition["Graphics"], None], boxMiddle, MousePosition["Graphics"][[1]]];
							(*put guard rails on where the sliding can happen*)
							boxMiddle = Max[boxMin, Min[activeXPos, boxMax]];
							currentTime = convertToTime[boxMiddle];
							streamPosition = Quantity[currentTime, Second];
						]),
					"MouseUp" :> (
						(*turn off mouse highlighting and coloring*)
						mouseMover = False;
						sliderFontColor = emeraldPlotDefaultGray;
						sliderFaceColor = White;
					)
				}
			];

			(*main part of the function*)
			Framed[sliderEventHandler[], ImageSize -> {520, 30}, FrameStyle -> None, FrameMargins -> {{0, 0}, {0, 0}}],
			Initialization :> (assoSliderPoints = convertLabelPoints[labeledPts])
		];


		(*Make the main plot*)
		Grid[{
			{
				Framed[componentTitle[protocolObj], FrameMargins -> {{222, 0}, {0, 0}}, FrameStyle -> None], SpanFromLeft, SpanFromLeft
			},
			{
				Framed[componentPopupMenu, FrameMargins -> {{222, 0}, {0, 0}}, FrameStyle -> None], SpanFromLeft, SpanFromLeft
			},
			{
				Framed[componentSelectionBar, FrameMargins -> {{0, 0}, {0, 240}}, FrameStyle -> None],
				componentLinePlots,
				Framed[componentVideo, FrameMargins -> {{0, 0}, {-4, 0}}, FrameStyle -> None]
			}
		},
			Alignment -> {
				{Left, Center, Center},
				{Center, Center, Bottom},
				{{3, 1} -> {Center, Center}}
			},
			ItemSize -> Full
		],
		Initialization :> componentInteractiveGuide
	]
];

plotMeasureMeltingPointHelperV12[analysisObject_] := Module[
	{
		mpPacket, protocol, protocolObj, downloadFields, totalDownloads, allIDs, allDataObjs, tooltippedIDs, startTs, endTs, curves, videoFiles, pointsUSP, pointsBP, pointsJP,
		allLineValues, labeledPointsXY, pointsUnitlessUSP, pointsUnitlessBP, pointsUnitlessJP,
		startTemp, endTemp, graphicsRange, allColors, imageSizeCalculation, allStandardsP,
		minPercent, maxPercent, plotRangeXMin, plotRangeXMax, plotRangeYMin, plotRangeYMax, plotImageSize, plotImagePadding,
		sampleNumber
	},

	mpPacket = If[MatchQ[analysisObject, _Association],
		Analysis`Private`stripAppendReplaceKeyHeads[analysisPacket],
		analysisObject
	];
	protocol = Download[analysisObject, Reference[Protocol]];
	protocolObj = protocol[Object];

	(*Download all necessary information for the plot*)
	downloadFields = {
		Object, StartTemperature, EndTemperature, MeltingCurve, CapillaryVideoFile,
		MeltingAnalyses[USPharmacopeiaMeltingRange], MeltingAnalyses[BritishPharmacopeiaMeltingPoint], MeltingAnalyses[JapanesePharmacopeiaMeltingPoint]
	};
	totalDownloads = Download[protocol, Data[downloadFields]];
	{allDataObjs, startTs, endTs, curves, videoFiles, pointsUSP, pointsBP, pointsJP} = Transpose[totalDownloads];

	{pointsUnitlessUSP, pointsUnitlessBP, pointsUnitlessJP} = QuantityMagnitude[{pointsUSP, pointsBP, pointsJP}];

	allIDs = allDataObjs[[All, -1]];
	tooltippedIDs = MapThread[Tooltip, {allIDs, allDataObjs}];


	(*In theory, starting and ending temperatures should be the same for all samples, due to measuring noise they could still be different.*)
	startTemp = QuantityMagnitude[Min[startTs]];
	endTemp = QuantityMagnitude[Max[endTs]];

	allLineValues = QuantityMagnitude[curves];

	(*calculate PlotRange. These will be integers slightly larger than the real data range.*)
	(*Find minimum/maximum percentage among all line values.*)
	minPercent = Min[#[[2]]& /@ Flatten[allLineValues, 1]];
	maxPercent = Max[#[[2]]& /@ Flatten[allLineValues, 1]];

	plotRangeXMin = Floor[startTemp];
	plotRangeXMax = Ceiling[endTemp];

	(*In theory, the percentage is always from 0 to 100%, here to give it a bit larger range for noise and nicer plot.*)
	plotRangeYMin = Min[-5, Floor[minPercent]];
	plotRangeYMax = Max[105, Ceiling[maxPercent]];

	graphicsRange = {{plotRangeXMin, plotRangeXMax}, {plotRangeYMin, plotRangeYMax}};

	(*The desired format for labeledPointsXY is
   <|
      1-> <|"USP"->{point1, point2}, "BP"->{point1}, "JP"->{point1}|>,
      2-> <|"USP"->{point1, point2}, "BP"->{point1}, "JP"->{point1}|>,
      3-> <|"USP"->{point1, point2}, "BP"->{point1}, "JP"->{point1}|>
   |>, and each point is {x, y}.
   *)
	labeledPointsXY = coordinatesAssociation[allLineValues, pointsUnitlessUSP, pointsUnitlessBP, pointsUnitlessJP];
	sampleNumber = Length[labeledPointsXY];

	(*all colors chosen for display data*)
	allColors = {
		LCHColor[0.6, 1, 0.5], LCHColor[0.9, 1, 0.2], LCHColor[0.7, 0.9, 1],
		LCHColor[0.6, 1, 0.7], LCHColor[0.7, 1, 0.1], LCHColor[0.8, 0.6, 0.2]
	};

	emeraldPlotDefaultGray = RGBColor["#5E6770"];
	emeraldPlotDefaultDarkerGray = RGBColor["#3e454c"];

	(*use the helper function to determine interactive plot parameters, {400, 350} is ImageSize, {{50, 15}, {50, 10}} is padding.*)
	plotImageSize = {400, 350};
	plotImagePadding = {{50, 15}, {50, 10}};
	imageSizeCalculation = SciCompFramework`Private`resolveImageSize[plotImageSize,plotImagePadding];


	(* Overview of plot components*)
	(* --------------------------------*)
	(* -        title                 -*)
	(* -        popupMenu             -*)
	(* --------------------------------*)
	(* -        -                     -*)
	(* -        -                     -*)
	(* -        -   interactivePlot   -*)
	(* -        -                     -*)
	(* - Legend -                     -*)
	(* --------------------------------*)

	(*DynamicModule[{closedInteractionGuide, ___}, ___] was used to pattern match in command center preview - AppHelpers`Private`makeGraphicSizeFull,
  remember to update the pattern accordingly if any changes made here. *)
	DynamicModule[
		{
			closedInteractionGuide, startState, hoverState, endState, multipleSelection = {1}, standardSelection = "USP",
			vLineX = startTemp*1.1
		},

		(*Components of the plot*)
		componentTitle[title_] := Style[
			Text[title, BaseStyle -> {FontFamily -> "Helvetica", Bold}],
			FontSize -> 18, FontColor -> emeraldPlotDefaultDarkerGray
		];

		componentPopupMenu := popupMenuSelectStandard[Dynamic[standardSelection], {"USP", "BP", "JP"}];

		componentSelectionBar := ECL`SciCompFramework`EmeraldSelectionBar[
			Dynamic[multipleSelection],
			# -> ECL`SciCompFramework`EmeraldMenuItem[{
				Dynamic[menuIcon[allColors[[#]], White, MemberQ[multipleSelection, #]], TrackedSymbols :> {multipleSelection}],
				tooltippedIDs[[#]]
			}]&
					/@ Range[sampleNumber],
			Style -> "EmeraldSelectionBarPlotMeltingPoint", FieldSize -> 9
		];


		(*Plot a labeled point on the curve, given the index (1/2/3), standard (USP/BP/JP), and point number (USP has two points, and BP/JP has one point).
    The points have outer circle white, and inner circle consistent with line color*)
		allStandardsP = "USP" | "BP" | "JP";
		helperCurvePoints[pointsCoordinates_, Dynamic[traceCurve_], Dynamic[traceStandard_], curveIdx_, standard:allStandardsP, standardPointIdx_] :=
				Dynamic[
					If[MemberQ[traceCurve, curveIdx] && traceStandard == standard,
						{
							Style[Point[pointsCoordinates[curveIdx][standard][[standardPointIdx]]], PointSize[0.025], White],
							Style[Point[pointsCoordinates[curveIdx][standard][[standardPointIdx]]], PointSize[0.02], Darker[allColors[[curveIdx]]]]
						},
						{}
					],
					TrackedSymbols :> {traceCurve, traceStandard}
				];

		(*plot a single line and its labeled points given the line index*)
		helperPlotCurveWithPoints[allLineV_, Dynamic[multipleS_], Dynamic[standardS_], idx_]:= {
			Dynamic[
				If[MemberQ[multipleS, idx],
					Style[Line[allLineV[[idx]]], allColors[[idx]], Thickness[0.007]],
					{}
				],
				TrackedSymbols :> {multipleS}
			],

			(*USP has two points, BP and JP has one point each*)
			helperCurvePoints[labeledPointsXY, Dynamic[multipleS], Dynamic[standardS], idx, Sequence@@#]& /@ {{"USP", 1}, {"USP", 2}, {"BP", 1}, {"JP", 1}}
		};

		(*When mouse move in or out of the labeled points, use EventHandler to change show epilog status.*)
		helperEventHandler[Dynamic[traceCurve_], Dynamic[traceStandard_], curveIdx_]:= DynamicModule[{traceEpilog1=False, traceEpilog2=False},
			{
				(*depending on the showEpilog1 or showEpilog2, return the epilog or empty primitive*)
				(*This primitive has to be on top of the EventHandler, otherwise the epilog will keep blinking when mouse hovers on it.*)
				Dynamic[
					Which[
						traceEpilog2,
						singlePointEpilog[labeledPointsXY[curveIdx][traceStandard][[1]], plotRangeXMin, plotRangeYMin, Darker[allColors[[curveIdx]]]],
						traceEpilog1 && traceStandard == "USP",
						singlePointEpilog[labeledPointsXY[curveIdx][traceStandard][[2]], plotRangeXMin, plotRangeYMin, Darker[allColors[[curveIdx]]]],
						traceEpilog1 && (traceStandard == "BP" || traceStandard=="JP"),
						singlePointEpilog[labeledPointsXY[curveIdx][traceStandard][[1]], plotRangeXMin, plotRangeYMin, Darker[allColors[[curveIdx]]]],
						True,
						{}
					],
					TrackedSymbols :> {traceStandard, traceEpilog1, traceEpilog2}
				],

				EventHandler[
					Dynamic[
						If[MemberQ[traceCurve, curveIdx] && traceStandard == "USP",
							Style[Point[labeledPointsXY[curveIdx]["USP"][[1]]], PointSize[0.03], Opacity[0]],
							{}
						],
						TrackedSymbols :> {traceCurve, traceStandard}
					],
					{
						"MouseEntered" :> (traceEpilog2 = If[MemberQ[traceCurve, curveIdx] && traceStandard == "USP", True, False]),
						"MouseExited" :> (traceEpilog2 = False)
					}
				],
				EventHandler[
					Dynamic[
						If[MemberQ[traceCurve, curveIdx] && (traceStandard == "JP" || traceStandard == "BP" || traceStandard == "USP"),
							Style[Point[labeledPointsXY[curveIdx]["USP"][[2]]], PointSize[0.03], Opacity[0]],
							{}
						],
						TrackedSymbols :> {traceCurve, traceStandard}
					],
					{
						"MouseEntered" :> (traceEpilog1 = If[MemberQ[traceCurve, curveIdx] && (traceStandard == "JP" || traceStandard == "BP" || traceStandard == "USP"), True, False]),
						"MouseExited" :> (traceEpilog1 = False)
					}
				]
			}];

		(*interactive plot*)
		componentLinePlots = DynamicModule[
			{
				SciCompFramework`Private`xMin = plotRangeXMin, SciCompFramework`Private`xMax = plotRangeXMax,
				SciCompFramework`Private`yMin = plotRangeYMin, SciCompFramework`Private`yMax = plotRangeYMax
			},
			Graphics[
				{
					(*plot curves with labeled points*)
					helperPlotCurveWithPoints[allLineValues, Dynamic[multipleSelection], Dynamic[standardSelection], #]& /@Range[sampleNumber],

					(*zoom layer*)
					SciCompFramework`Private`clickZoomLayer[True, graphicsRange, {0, 0}, False],

					(*mouse hover special points, show epilog and the text will on top of the curves*)
					helperEventHandler[Dynamic[multipleSelection], Dynamic[standardSelection], #]& /@ Range[sampleNumber],

					(*panning layer*)
					SciCompFramework`Private`panningLayer[graphicsRange, "ShiftKey"]

				},
				Frame -> {True, True, True, True},
				FrameLabel -> {"Temperature (\[Degree]C)", "Transmission(%)"},
				FrameStyle -> Directive[16, emeraldPlotDefaultGray, Thickness[0.003]],
				LabelStyle -> Plain,
				ImageSize -> imageSizeCalculation,
				PlotRangePadding -> None,
				PlotRangeClipping -> True,
				ImagePadding -> plotImagePadding,
				PlotRange -> Dynamic[{{SciCompFramework`Private`xMin, SciCompFramework`Private`xMax}, {SciCompFramework`Private`yMin, SciCompFramework`Private`yMax}}],
				AspectRatio -> Full
			] // (*ZoomWrapper to concatenate all*)
					SciCompFramework`Private`scrollZoomWrapper[True, graphicsRange, {0, 0}, imageSizeCalculation, {False, False}]
		];


		(*Make the main plot*)
		Grid[{
			{Framed[componentTitle[protocolObj], FrameMargins -> {{222, 0}, {0, 0}}, FrameStyle -> None], SpanFromLeft, SpanFromLeft},
			{Framed[componentPopupMenu, FrameMargins -> {{222, 0}, {0, 0}}, FrameStyle -> None], SpanFromLeft, SpanFromLeft},
			{
				Framed[componentSelectionBar, FrameMargins -> {{0, 0}, {0, 240}}, FrameStyle -> None],
				componentLinePlots,
				Framed[Graphics[{}, ImageSize->{300, 400}], FrameMargins -> {{0, 0}, {-4, 0}}, FrameStyle -> None]
			}
		},
			Alignment -> {
				{Left, Center, Center},
				{Center, Center, Bottom},
				{{3, 1} -> {Center, Center}}
			},
			ItemSize -> Full
		]
	]

];

(* ::Subsubsection:: *)
(*plotMeltingCurveMelting*)

(* the case to plot DLS Melting curve analysis result, only DLS data is available*)
plotDLSMeltingCurve[xys0_List/;Length[xys0]===1,legends_,helperOps:{(_Rule|_RuleDelayed)..},safeOps:{(_Rule|_RuleDelayed)..}]:=Module[
	{
		dlsData, plotRangeDLS, mpX, mpYDLS, y1min, y1max, temperatureUnit, epilogList, internalELLPOps
	},

	dlsData = xys0[[1]];
	temperatureUnit = Celsius;

	(* The Epilog option needs to use the coordinates of the melting points. When there are two y-axis, we need to map the second y coordinates to the first one on the plot. *)
	plotRangeDLS = AbsoluteOptions[EmeraldListLinePlot[dlsData], PlotRange];

	(*plotRangeDLS/plotRangeSLS has the format {PlotRange->{{xmin, xmax}, {ymin, ymax}}}.*)
	{y1min, y1max} = First[Values[plotRangeDLS]][[2]];

	mpX = Unitless[Lookup[helperOps, MeltingPoint]];

	{mpYDLS} = MapThread[If[Length[#1]==1,#1,Analysis`Private`InterpolateXYAtX[#1,#2]]&,{{dlsData},mpX}];

	epilogList = mpEpilog[y1min, {mpX, {mpYDLS}}, Length[dlsData], temperatureUnit, "Melting Point "];

	internalELLPOps=ToList@PassOptions[PlotMeltingPoint,EmeraldListLinePlot,
		ReplaceRule[safeOps,
			{
				Epilog->{
					epilogList,
					Sequence@@(ToList@Lookup[safeOps,Epilog])
				},
				FrameUnits->{1 Celsius, 1 Nanometer, None, 1 Gram/Mole},
				FrameLabel->
						If[MatchQ[Lookup[safeOps,FrameLabel],Automatic],
							{
								"Temperature "<> UnitForm[temperatureUnit,Number->False],
								"ZAverage Diameter "<> UnitForm[Nanometer,Number->False]
							},
							Lookup[safeOps,FrameLabel]
						],
				Legend ->
						If[MatchQ[Lookup[safeOps,Legend],Automatic],
							legends,
							Lookup[safeOps,Legend]
						],
				Output->{Result,Options}
			}
		]
	];

	Zoomable@EmeraldListLinePlot[
		dlsData,
		Sequence[internalELLPOps]
	]
];

(* function to plot the case to plot DLS Melting curve analysis result, both DLS and SLS data are available *)
plotDLSMeltingCurve[xys0_List/;Length[xys0]===2,legends_,helperOps:{(_Rule|_RuleDelayed)..},safeOps:{(_Rule|_RuleDelayed)..}]:=Module[
	{
		dlsData, slsData, plotRangeDLS, plotRangeSLS, mpX, mpYDLS, mpYSLS, y1min, y1max, y2min, y2max, mappedYSLS, temperatureUnit, epilogList,
		internalELLPOps,mappedSLSData
	},

	{dlsData, slsData} = xys0;

	temperatureUnit = Celsius;

	(* The Epilog option needs to use the coordinates of the melting points. When there are two y-axis, we need to map the second y coordinates to the first one on the plot. *)
	plotRangeDLS = AbsoluteOptions[EmeraldListLinePlot[dlsData], PlotRange];
	plotRangeSLS = AbsoluteOptions[EmeraldListLinePlot[slsData], PlotRange];

	(*plotRangeDLS/plotRangeSLS has the format {PlotRange->{{xmin, xmax}, {ymin, ymax}}}.*)
	{y1min, y1max} = First[Values[plotRangeDLS]][[2]];
	{y2min, y2max} = First[Values[plotRangeSLS]][[2]];

	mpX = Unitless[Lookup[helperOps, MeltingPoint]];

	{mpYDLS, mpYSLS} = MapThread[If[Length[#1]==1,#1,Analysis`Private`InterpolateXYAtX[#1,#2]]&,{{dlsData, slsData},mpX}];

	(*For SLS curve, its melting point y coordinates are mapped on DLS curve, in order to make the epilog *)
	mappedYSLS = y1min + (mpYSLS-y2min)/(y2max-y2min)*(y1max-y1min);

	mappedSLSData = {#[[1]], y1min + (#[[2]]-y2min)/(y2max-y2min)*(y1max-y1min)}&/@slsData;

	epilogList = mpEpilog[y1min, {mpX, {mpYDLS, mappedYSLS}}, Length[dlsData], temperatureUnit, "Melting Point "];

	internalELLPOps=ToList@PassOptions[PlotMeltingPoint,EmeraldListLinePlot,
		ReplaceRule[safeOps,
			{
				SecondYCoordinates->slsData,
				SecondYStyle->Thin,
				Epilog->{
					epilogList,
					Sequence@@(ToList@Lookup[safeOps,Epilog])
				},
				CoordinatesToolOptions -> {"DisplayFunction" -> None},
				FrameUnits->{1 Celsius, 1 Nanometer, None, 1 Gram/Mole},
				FrameLabel->
						If[MatchQ[Lookup[safeOps,FrameLabel],Automatic],
							{
								{
									"ZAverage Diameter "<> UnitForm[Nanometer,Number->False],
									"Molecular Weights "<> UnitForm[Gram/Mole,Number->False]
								},
								{"Temperature "<> UnitForm[temperatureUnit,Number->False],
									None
								}
							},
							Lookup[safeOps,FrameLabel]
						],
				FrameTicks->{{Automatic, Automatic}, {Automatic, None}},
				Legend ->
						If[MatchQ[Lookup[safeOps,Legend],Automatic],
							legends,
							Lookup[safeOps,Legend]
						],
				Output->{Result,Options}
			}
		]
	];

	Zoomable@EmeraldListLinePlot[
		{dlsData,mappedSLSData},
		Sequence[internalELLPOps]
	]

];

(* function to plot melting curve *)
plotMeltingCurveMelting[xys0_List,legends:{_String..},helperOps:{(_Rule|_RuleDelayed)..},safeOps:{(_Rule|_RuleDelayed)..}]:=Module[
	{
		display,mpxList,mpyList,epilogsList,xys,xmin,ymin,temperatureUnit,mpdxList,cl,tval,
		plot,plotrange,monsetxList,monsetyList,internalELLPOps
	},

	xys= DeleteDuplicatesBy[#,First]&/@Unitless[N@Replace[xys0,Null->{},{1}]];

	(* Finding the Automatic plotrange for using in Epilog *)
	plot=EmeraldListLinePlot[xys];
	plotrange=If[xys==={},{},AbsoluteOptions[plot, PlotRange]];

	(* Extracting the Automatic plotRange and the ymin value*)
	{xmin,ymin}=If[xys==={},{{},{}},First[#]& /@ (PlotRange/.plotrange)];

	display=Lookup[safeOps,MeltingDisplay];
	temperatureUnit=Celsius;
	mpxList=Unitless[Lookup[helperOps,MeltingPoint],temperatureUnit];
	mpyList=
		MapThread[
			Which[
				MatchQ[#1,{}|Null],Null,
				Length[#1]==1,#1,
				True,Analysis`Private`InterpolateXYAtX[#1,#2]
			]&,{xys,mpxList}
		];
	mpdxList=Replace[Unitless[Lookup[helperOps,MeltingPointStandardDeviation],temperatureUnit],Automatic->Table[Null,{Length[mpxList]}]];

	cl=Lookup[safeOps,ConfidenceLevel];

	cl=Unitless[cl,1];
	tval= Quiet[NormalCI[0,1,ConfidenceLevel->cl],{StudentTDistribution::posprm}];

	(* X and Y coordinates of the aggregation onset temperature *)
	monsetxList=Unitless[Lookup[helperOps,MeltingOnsetPoint],temperatureUnit];
	monsetyList=
		MapThread[
			Which[
				MatchQ[#1,{}|Null],Null,
				Length[#1]==1,#1,
				True,Analysis`Private`InterpolateXYAtX[#1,#2]
			]&,{xys,monsetxList}
		];

	epilogsList=MapThread[
		{
			If[MemberQ[display,Interval],dmpEpilogMelting[ymin,{#2,#3},#4,#5,tval,temperatureUnit]],
			If[MemberQ[display,MeltingPoint],mpEpilog[ymin,{#2,#3},#4,temperatureUnit, "Melting Point: "]],
			If[MemberQ[display,MeltingOnsetPoint],mpEpilog[ymin,{#6,#7},#4,temperatureUnit, "Melting Onset: "]]
		}&,
		{xys,mpxList,mpyList,Range[Length[xys]],mpdxList,monsetxList,monsetyList}
	];

	(* The options passed to EmeraldListLinePlot *)
	internalELLPOps=ToList@PassOptions[PlotMeltingPoint,EmeraldListLinePlot,
		ReplaceRule[safeOps,
			{
        Epilog->{
          epilogsList,
          If[MemberQ[display,Domain],domainEpilogMelting[Lookup[safeOps,Domain],Lookup[safeOps,Range]]],
          If[MemberQ[display,Range],rangeEpilogMelting[Lookup[safeOps,Range],Lookup[safeOps,Domain]]],
          Sequence@@(ToList@Lookup[safeOps,Epilog])
        },
        FrameLabel->
					If[MatchQ[Lookup[safeOps,FrameLabel],Automatic],
						{
		          "Temperature "<>UnitForm[temperatureUnit,Number->False],
		          "Absorbance "<>UnitForm[ArbitraryUnit,Number->False]
		        },
						Lookup[safeOps,FrameLabel]
					],
        Legend ->
					If[MatchQ[Lookup[safeOps,Legend],Automatic],
						legends,Lookup[safeOps,Legend]
					],
        Output->{Result,Options}
      }
		]
	];

	EmeraldListLinePlot[
    xys,
    Sequence@@internalELLPOps
  ]

];

(* ::Subsubsection:: *)
(*plotMeltingCurveMeltingAggregation*)

(* function to plot aggregation melting curve*)
plotMeltingCurveMeltingAggregation[xys0_List,xys0Index:{_Integer..},legends:{_String..}|Null,yFrameLabel:(_String|_Symbol),laserStatus:_Symbol|Null,helperOps:{(_Rule|_RuleDelayed)..},safeOps:{(_Rule|_RuleDelayed)..}]:=Module[
	{
		nonEmptyxys0,display,mpxList,mpyList,epilogsList,xys,xmin,ymin,temperatureUnit,mpdxList,cl,tval,
		monsetxList,monsetyList,xmax,ymax,laserPosition,plot,plotrange,internalELLPOps
	},

	nonEmptyxys0=Select[xys0, UnsameQ[#, Null] &];
	xys= Part[DeleteDuplicatesBy[#,First]&/@Unitless[N@Replace[nonEmptyxys0,Null->{},{1}]],xys0Index];

	(* Finding the Automatic PlotRange for using in Epilog *)
	plot=EmeraldListLinePlot[xys];
	plotrange=AbsoluteOptions[plot, PlotRange];

	(* Extracting the Automatic PlotRange and the ymin value*)
	{{xmin,xmax},{ymin,ymax}}=PlotRange/.plotrange;

	(* Position of the laser power result shown as an Epilog *)
	laserPosition={xmin+0.1*(xmax-xmin), ymax-0.1*(ymax-ymin)};

	display=Lookup[safeOps,MeltingDisplay];
	temperatureUnit=Celsius;
	mpxList=Part[Unitless[Lookup[helperOps,MeltingPoint],temperatureUnit],xys0Index];
	mpyList=
		MapThread[
			Which[
				MatchQ[#1,{}|Null],Null,
				Length[#1]==1,#1,
				True,Analysis`Private`InterpolateXYAtX[#1,#2]
			]&,{xys,mpxList}
		];
	mpdxList=Replace[Part[Unitless[Lookup[helperOps,MeltingPointStandardDeviation],temperatureUnit],xys0Index],Automatic->Table[Null,{Length[mpxList]}]];
	cl=Lookup[safeOps,ConfidenceLevel];
	cl=Unitless[cl,1];
	tval= Quiet[NormalCI[0,1,ConfidenceLevel->cl],{StudentTDistribution::posprm}];

	(* X and Y coordinates of the aggregation onset temperature *)
	monsetxList=Part[Unitless[Lookup[helperOps,MeltingOnsetPoint],temperatureUnit],xys0Index];
	monsetyList=
		MapThread[
			Which[
				MatchQ[#1,{}|Null],Null,
				Length[#1]==1,#1,
				True,Analysis`Private`InterpolateXYAtX[#1,#2]
			]&,{xys,monsetxList}
		];

	epilogsList=MapThread[
		{
			If[MemberQ[display,Interval],dmpEpilogMelting[ymin,{#2,#3},#4,#5,tval,temperatureUnit]],
			If[MemberQ[display,MeltingPoint],mpEpilog[ymin,{#2,#3},#4,temperatureUnit,"Melting Point: "]],
			If[MemberQ[display,MeltingOnsetPoint],mpEpilog[ymin,{#6,#7},#4,temperatureUnit,"Melting Onset: "]]
		}&,
		{xys,mpxList,mpyList,Range[Length[xys]],mpdxList,monsetxList,monsetyList}
	];

  (* The options passed to EmeraldListLinePlot *)
	internalELLPOps=ToList@PassOptions[PlotMeltingPoint,EmeraldListLinePlot,
		ReplaceRule[safeOps,
			{
        Epilog->{
    			epilogsList,
    			If[MemberQ[display,Domain],domainEpilogMelting[Lookup[safeOps,Domain],Lookup[safeOps,Range]]],
    			If[MemberQ[display,Range],rangeEpilogMelting[Lookup[safeOps,Range],Lookup[safeOps,Domain]]],
    			If[Lookup[safeOps,LaserPowerDisplay],
    				laserEpilog[laserStatus,laserPosition],
    				Null
    			],
    			Sequence@@(ToList@Lookup[safeOps,Epilog])
    		},
    		FrameLabel->
					If[MatchQ[Lookup[safeOps,FrameLabel],Automatic],
						{
		    			"Temperature "<>UnitForm[temperatureUnit,Number->False],
		    			yFrameLabel
		    		},
						Lookup[safeOps,FrameLabel]
					],
        Legend ->
					If[MatchQ[Lookup[safeOps,Legend],Automatic],
						legends,Lookup[safeOps,Legend]
					],
        Output->{Result,Options}
      }
    ]
  ];

	EmeraldListLinePlot[
		xys,
		Sequence@@internalELLPOps
	]
];


(* ::Subsubsection:: *)
(*plotMeltingCurveAlpha*)

(* function to plot plotType Alpha *)
plotMeltingCurveAlpha[xys0_List,legends:{_String..},helperOps:{(_Rule|_RuleDelayed)..},safeOps:{(_Rule|_RuleDelayed)..}]:=Module[
	{
    display,mpxList,mpyList,epilogsList,xys,xmin,ymin,temperatureUnit,mpdxList,cl,tval,plot,plotrange,
    internalELLPOps
  },

	xys= DeleteDuplicatesBy[#,First]&/@N@DeleteCases[xys0,Null];

	(* Finding the Automatic plotrange for using in Epilog *)
	plot=EmeraldListLinePlot[xys];
	plotrange=AbsoluteOptions[plot, PlotRange];

	(* Extracting the Automatic plotRange and the ymin value*)
	{xmin,ymin}=First[#]& /@ (PlotRange/.plotrange);

	display=Lookup[safeOps,MeltingDisplay];
	temperatureUnit=Celsius;
	mpxList=Unitless[DeleteCases[Lookup[helperOps,MeltingPoint],Null],Celsius];
	mpyList=MapThread[If[Length[#1]==1,#1,Analysis`Private`InterpolateXYAtX[#1,#2]]&,{xys,mpxList}];
	mpdxList=Unitless[Lookup[helperOps,MeltingPointStandardDeviation],temperatureUnit];
	cl=Lookup[safeOps,ConfidenceLevel];
	cl=Unitless[cl,1];
	tval= Quiet[NormalCI[0,1,ConfidenceLevel->cl],{StudentTDistribution::posprm}];
	epilogsList=MapThread[
		{
			If[MemberQ[display,MeltingPoint],crossingEpilogMelting[xmin,{#2,#3}]],
			If[MemberQ[display,Interval],dmpEpilogMelting[ymin,{#2,#3},#4,#5,tval,temperatureUnit]],
			If[MemberQ[display,MeltingPoint],mpEpilog[ymin,{#2,#3},#4,temperatureUnit,"Melting Point: "]]
		}&,
		{xys,mpxList,mpyList,Range[Length[xys]],mpdxList}
	];

  (* The options passed to EmeraldListLinePlot *)
	internalELLPOps=ToList@PassOptions[PlotMeltingPoint,EmeraldListLinePlot,
		ReplaceRule[safeOps,
			{
        Epilog->{
    			epilogsList,
    			Sequence@@(ToList@Lookup[safeOps,Epilog])
    		},
    		FrameLabel->
					If[MatchQ[Lookup[safeOps,FrameLabel],Automatic],
						{
		    			"Temperature "<>UnitForm[temperatureUnit,Number->False],
		    			"Fraction Bound (\[Alpha])"
		    		},
						Lookup[safeOps,FrameLabel]
					],
        Legend ->
					If[MatchQ[Lookup[safeOps,Legend],Automatic],
						legends,Lookup[safeOps,Legend]
					],
        Output->{Result,Options}
      }
    ]
  ];

	EmeraldListLinePlot[
		xys,
		Sequence@@internalELLPOps
	]
];


(* ::Subsubsection:: *)
(*plotMeltingCurveDerivative*)

(* function to plot plotType Derivative *)
plotMeltingCurveDerivative[xys0_List,legends:{_String..},helperOps:{(_Rule|_RuleDelayed)..},safeOps:{(_Rule|_RuleDelayed)..}]:=Module[
	{
    display,mpxList,mpyList,epilogsList,xys,xmin,ymin,temperatureUnit,plot,plotrange,
    internalELLPOps
  },
	xys= N@DeleteCases[xys0,Null];
	xmin=Min[xys[[;;,;;,1]]];
	ymin=Min[xys[[;;,;;,2]]];

	(* Finding the Automatic plotrange for using in Epilog *)
	plot=EmeraldListLinePlot[xys];
	plotrange=AbsoluteOptions[plot, PlotRange];

	(* Extracting the Automatic plotRange and the ymin value*)
	{xmin,ymin}=First[#]& /@ (PlotRange/.plotrange);

	display=Lookup[safeOps,MeltingDisplay];

	temperatureUnit=Celsius;
	mpxList=Unitless[DeleteCases[Lookup[helperOps,MeltingPoint],Null],Celsius];
	mpyList=MapThread[If[Length[#1]==1,#1,Analysis`Private`InterpolateXYAtX[#1,#2]]&,{xys,mpxList}];
	epilogsList=MapThread[
		{
			If[MemberQ[display,MeltingPoint],mpEpilog[ymin,{#2,#3},#4,temperatureUnit,"Melting Point: "]]
		}&,
		{xys,mpxList,mpyList,Range[Length[xys]]}
	];

  (* The options passed to EmeraldListLinePlot *)
	internalELLPOps=ToList@PassOptions[PlotMeltingPoint,EmeraldListLinePlot,
		ReplaceRule[safeOps,
			{
        Epilog->{
    			epilogsList,
    			Sequence@@(ToList@Lookup[safeOps,Epilog])
    		},
    		FrameUnits->{Celsius,ArbitraryUnit/Celsius},
    		FrameLabel->
					If[MatchQ[Lookup[safeOps,FrameLabel],Automatic],
						{
		    			"Temperature "<>UnitForm[temperatureUnit,Number->False],
		    			"Absorbance Derivative "<> UnitForm[ArbitraryUnit/Celsius,Number->False]
		    		},
						Lookup[safeOps,FrameLabel]
					],
        Legend ->
					If[MatchQ[Lookup[safeOps,Legend],Automatic],
						legends,Lookup[safeOps,Legend]
					],
        Output->{Result,Options}
      }
    ]
  ];

	EmeraldListLinePlot[
		xys,
		Sequence@@internalELLPOps
	]
];

(* ::Subsubsection:: *)
(*plotMeltingCurveDerivativeOverlay*)

(* function to plot plotType DerivativeOverlay *)
plotMeltingCurveDerivativeOverlay[xys0_List,xys0Index:{_Integer..},legends:{_String..}|Null,yFrameLabel: ListableP[(_String|_Symbol)],helperOps:{(_Rule|_RuleDelayed)..},safeOps:{(_Rule|_RuleDelayed)..}]:=Module[
	{
		nonEmptyxys0,display,mtransxList,mtransyList,epilogsList,xys,xmin,ymin,temperatureUnit,xdys,plot,
    plotrange,internalELLPOps
	},

	nonEmptyxys0=Select[xys0, UnsameQ[#, Null] &];
	xys= Part[N@DeleteCases[nonEmptyxys0,Null],xys0Index];

	xdys=
		Part[
			Map[
				If[Length[#]==1,
					QuantityMagnitude[#],
					Analysis`Private`finiteDifferences2D[DeleteDuplicatesBy[QuantityMagnitude[#],First]]
				]&,
				nonEmptyxys0
			],
			xys0Index
		];

	(* Finding the Automatic PlotRange for using in Epilog *)
	plot=EmeraldListLinePlot[xys,SecondYCoordinates->xdys];

	(* The x domain and y range of the plot that is automatically set *)
	plotrange=AbsoluteOptions[plot, PlotRange];

	(* Extracting the Automatic plotRange and the ymin value *)
	{xmin,ymin}=First[#]& /@ (PlotRange/.plotrange);

	display=Lookup[safeOps,MeltingDisplay];
	temperatureUnit=Celsius;

	mtransxList=Part[Unitless[Lookup[helperOps,MeltingTransitions],Celsius],xys0Index];
	mtransyList=
		MapThread[
			Which[
				Length[#1]==1,#1,
				MatchQ[mtransxList,Null|{}],Null,
				True,Analysis`Private`InterpolateXYAtX[#1,#2]
			]&,
			{xys,mtransxList}
		];

	epilogsList=MapThread[
		{
			If[MemberQ[display,MeltingPoint],mpEpilog[ymin,{#2,#3},#4,temperatureUnit,"Melting Transition: "]]
		}&,
		{xys,mtransxList,mtransyList,Range[Length[xys]]}
	];

  (* The options passed to EmeraldListLinePlot *)
	internalELLPOps=ToList@PassOptions[PlotMeltingPoint,EmeraldListLinePlot,
		ReplaceRule[safeOps,
      {
        SecondYCoordinates->xdys,
    		(* SecondYColors->{Gray}, *)
    		SecondYColors->(ColorData[97][#]& /@ Range[Length[xdys]]),
    		Epilog->{
    			epilogsList,
    			Sequence@@(ToList@Lookup[safeOps,Epilog])
    		},
    		FrameUnits->{Celsius,Nanometer,None,Nanometer/Celsius},
    		FrameLabel->
					If[MatchQ[Lookup[safeOps,FrameLabel],Automatic],
						{
		    			{yFrameLabel[[1]],If[Length[yFrameLabel]>1,yFrameLabel[[2]],None]},
		    			{"Temperature "<>UnitForm[temperatureUnit,Number->False],None}
		    		},
						Lookup[safeOps,FrameLabel]
					],
        Legend ->
					If[MatchQ[Lookup[safeOps,Legend],Automatic],
						legends,Lookup[safeOps,Legend]
					],
    		FrameTicks ->
					If[MatchQ[Lookup[safeOps,FrameTicks],Automatic],
						{
		    			{
		    				Automatic,
		    				If[
		    					Length[yFrameLabel]>1,
		    					Automatic,
		    					None
		    				]
		    			},
		    			{Automatic, None}
		    		},
						Lookup[safeOps,FrameTicks]
					],
        Output->{Result,Options}
      }
    ]
  ];

	EmeraldListLinePlot[
		xys,
		Sequence@@internalELLPOps
	]

];


(* ::Subsubsection:: *)
(*epilogs*)


curveEpilogMelting[Null,colorInd_]:=Null;
curveEpilogMelting[xy_,colorInd_]:={ColorData[97][colorInd],Line[xy]};

domainEpilogMelting[Null,_]:=Null;
domainEpilogMelting[{xmin_,xmax_},{ymin_,ymax_}]:={Black,Line[{{xmin,ymin},{xmin,ymax}}],Line[{{xmax,ymin},{xmax,ymax}}]};

rangeEpilogMelting[Null,_]:=Null;
rangeEpilogMelting[{ymin_,ymax_},{xmin_,xmax_}]:={Black,Line[{{xmin,ymin},{xmax,ymin}}],Line[{{xmin,ymax},{xmax,ymax}}]};

mpEpilog[ymin_,{mpx_List,mpy_List},colorInd_,xUnit_,text_]:=MapThread[mpEpilog[ymin,{#1,#2},colorInd,xUnit,text]&,{mpx,mpy}];
mpEpilog[ymin_,{mpx:NumericP,mpy:NumericP},colorInd_,xUnit_,text_]:={
	Red,Dashed,Thick,Tooltip[Line[{{mpx,ymin},{mpx,mpy}}],Style[text<>TextString[mpx*xUnit],15]],
	Red,PointSize[0.0275],Point[{mpx,mpy}],
	ColorData[97][colorInd],PointSize[0.02],Tooltip[Point[{mpx,mpy}],Style[text<>TextString[mpx*xUnit],15]]
};
mpEpilog[ymin_,_,colorInd_,xUnit_,text_]:=Null;


crossingEpilogMelting[xmin_,{mpx_List,mpy_List}]:=MapThread[crossingEpilogMelting[xmin,{#1,#2}]&,{mpx,mpy}];
crossingEpilogMelting[xmin_,{mpx:NumericP,mpy:NumericP}]:={
	Red,Dashed,Thick,Line[{{xmin,mpy},{mpx,mpy}}]
};
crossingEpilogMelting[xmin_,_]:=Null;


dmpEpilogMelting[ymin_,{mpx_List,mpy_List},colorInd_,dmpx_List,tval_,xUnit_]:=MapThread[dmpEpilogMelting[ymin,{#1,#2},colorInd,#3,tval,xUnit]&,{mpx,mpy,dmpx}];
dmpEpilogMelting[ymin_,{mpx_,mpy_},colorInd_,dmpx:Null,_,xUnit_]:={};
dmpEpilogMelting[ymin_,{mpx_,mpy_},colorInd_,dmpx_,tval_,xUnit_]:=Module[{mpxm,mpxp},
	mpxm=mpx-First[tval]*Unitless[dmpx];
	mpxp=mpx-Last[tval]*Unitless[dmpx];
	{
		{
			Lighter[Gray],Opacity[0.15],
			Tooltip[Rectangle[{mpxm,ymin},{mpxp,mpy}],Style[{mpxp,mpxm}*xUnit,15]]
		},
		{
			Red,Dashed,
			Tooltip[Line[{{mpxm,ymin},{mpxm,mpy}}],Style[mpxm*xUnit,15]],
			Tooltip[Line[{{mpxp,ymin},{mpxp,mpy}}],Style[mpxp*xUnit,15]]
		}
	}
];

laserEpilog[status_Symbol,pos_List]=Switch[status,
	Success,{Green,PointSize[0.05],Tooltip[Point[pos],Style[Success,15]]},
	FailureSaturatedSignal,{Yellow,PointSize[0.05],Tooltip[Point[pos],Style[FailureSaturatedSignal,15]]},
	FailureLowSignal,{Red,PointSize[0.05],Tooltip[Point[pos],Style[FailureLowSignal,15]]}
];


(* Use overload to separate cases of different plots*)
(*overload: cases to generate Aggregation plot*)
appendFigMeltingPointMeltingIdx[___]:=Nothing;
appendFigMeltingPointMeltingIdx[pType:All|MeltingPoint, fssDataQ:True, slsDataQ:True, meltingIdx_/;Positive[Length[meltingIdx]],
	dataPoints_, meltingShow_, dataSet_, laserStatus_, helperOptions_, safeOps_]:=
		plotMeltingCurveMeltingAggregation[
			dataPoints,
			meltingShow[[1]],
			(SymbolName[#]&/@dataSet[[meltingShow[[1]]]]),
			meltingShow[[2]],
			laserStatus,
			helperOptions,
			safeOps
		];
appendFigMeltingPointAggreIdx[___]:=Nothing;
appendFigMeltingPointAggreIdx[pType:All|MeltingPoint, fssDataQ:True, slsDataQ:True, aggreIdx_/;Positive[Length[aggreIdx]],
	dataPoints_,staticLightScatteringWavelengths_,slsYFrameLabel_,laserStatus_,helperOptions_,safeOps_]:=
			plotMeltingCurveMeltingAggregation[
				dataPoints,
				aggreIdx,
				Map[("Aggregation at " <> ToString[#])&, staticLightScatteringWavelengths],
				slsYFrameLabel,
				laserStatus,
				helperOptions,
				safeOps
			];
appendFigMeltingPoint[___]:=Nothing;
appendFigMeltingPoint[pType:All|MeltingPoint, fssDataQ:True, slsData:False,
	dataPoints_,meltingShow_,dataSet_,laserStatus_,helperOptions_,safeOps_]:=
	plotMeltingCurveMeltingAggregation[
		dataPoints,
		meltingShow[[1]],
		(ToString[#]& /@ dataSet[[meltingShow[[1]]]]),
		meltingShow[[2]],
		laserStatus,
		helperOptions,
		safeOps
	];

(*overload: cases to generate DLS and SLS Melting plot*)
appendFigMeltingPoint[pType:All|MeltingPoint, fssDataQ:False, slsData_,
	dataPoints_, meltingShow_, dataSet_,laserStatus_,helperOptions_,safeOps_]:=
		plotMeltingCurveMelting[
			dataPoints,
			(ToString[#]& /@ dataSet),
			helperOptions,
			safeOps
		];

(*overload: cases to generate Alpha plot*)
appendFigAlpha[___]:=Nothing;
appendFigAlpha[pType:All|Alpha, fssDataQ:False, alphaCurves_, dataSet_, helperOptions_, safeOps_]:=
	plotMeltingCurveAlpha[
		alphaCurves,
		(ToString[#]& /@ dataSet),
		helperOptions,
		safeOps
	];

(*overload: cases to generate Derivative plot*)
appendFigDerivative[___]:=Nothing;
appendFigDerivative[pType:All|Derivative, fssDataQ:False, dataPoints_, dataSet_, helperOptions_, safeOps_]:=
		plotMeltingCurveDerivative[
			Map[Analysis`Private`finiteDifferences2D[DeleteDuplicatesBy[QuantityMagnitude[#], First]]&, dataPoints],
			(ToString[#]& /@ dataSet),
			helperOptions,
			safeOps
		];

(*overload: cases to generate the Overlay plot*)
appendFigDerivativeOverlayMeltingIdx[___]:=Nothing;
appendFigDerivativeOverlayMeltingIdx[pType:All|DerivativeOverlay, fssDataQ:True, slsDataQ:True, meltingIdx_/;Positive[Length[meltingIdx]],
	dataPoints_, meltingShow_, dataSet_, helperOptions_, safeOps_]:=
		plotMeltingCurveDerivativeOverlay[
			dataPoints,
			meltingShow[[1]],
			(ToString[#]& /@ dataSet[[meltingShow[[1]]]]),
			meltingShow[[2 ;; 3]],
			helperOptions,
			safeOps
		];
appendFigDerivativeOverlayAggreIdx[___]:=Nothing;
appendFigDerivativeOverlayAggreIdx[pType:All|DerivativeOverlay, fssDataQ:True, slsDataQ:True, aggreIdx_/;Positive[Length[aggreIdx]],
	dataPoints_,staticLightScatteringWavelengths_, slsYFrameLabel_, slsSecondYFrameLabel_, helperOptions_, safeOps_]:=
		plotMeltingCurveDerivativeOverlay[
			dataPoints,
			aggreIdx,
			Map[("Aggregation at " <> ToString[#])&, staticLightScatteringWavelengths],
			{slsYFrameLabel, slsSecondYFrameLabel},
			helperOptions,
			safeOps
		];
appendFigDerivativeOverlay[___]:=Nothing;
appendFigDerivativeOverlay[pType:All|DerivativeOverlay, fssDataQ:True, slsDataQ:False,
	dataPoints_, meltingShow_, dataSet_, genericYFrameLabel_, helperOptions_, safeOps_]:=
		plotMeltingCurveDerivativeOverlay[
			dataPoints,
			meltingShow[[1]],
			(ToString[#]& /@ dataSet[[meltingShow[[1]]]]),
			meltingShow[[2 ;; 3]],
			helperOptions,
			safeOps
		];
appendFigDerivativeOverlay[pType:DerivativeOverlay, fssDataQ:False, slsDataQ_,
	dataPoints_, meltingShow_, dataSet_, genericYFrameLabel_, helperOptions_, safeOps_]:=
		plotMeltingCurveDerivativeOverlay[
			dataPoints,
			{1},
			(ToString[#]& /@ dataSet[[1]]),
			genericYFrameLabel,
			helperOptions,
			safeOps
		];

(*use overloads to merge plots under various conditions.
	fssDataQ: fluorescenceSpectraDataQ,
	slsDataQ: staticLightScatteringDataQ,
	dlsMeltingDataQ: dlsAndSLSDataQ
*)
mergePlots[figs_, pType_, fssDataQ_, slsDataQ_, dlsMeltingDataQ_, meltingIdx_, aggreIdx_, meltingIntensityIdx_, meltingBaryIdx_]:=First[figs];

(* If the data is DLS Melting Curve, only melting point plot will be shown*)
mergePlots[figs_, pType_, fssDataQ:False, slsDataQ:False, dlsMeltingDataQ:True, meltingIdx_, aggreIdx_, meltingIntensityIdx_, meltingBaryIdx_]:=First[figs];

(*For all other types of data*)
mergePlots[figs_, pType:All, fssDataQ:False, slsDataQ:False, dlsMeltingDataQ:False, meltingIdx_, aggreIdx_, meltingIntensityIdx_, meltingBaryIdx_]:=
    TabView[MapThread[Rule,{{"Melting Curves","Alpha Curve","Derivative"},figs}]];

(* No SLS results are available and all plots are shown *)
mergePlots[figs_, pType:All, fssDataQ:True, slsDataQ:False, dlsMeltingDataQ:False, meltingIdx_, aggreIdx_, meltingIntensityIdx_, meltingBaryIdx_]:=
    TabView[MapThread[Rule,{{"Melting Curves","DerivativeOverlay"},figs}]];

(* No melting transformation is used but aggregation curves are available *)
mergePlots[figs_, pType:All, fssDataQ:True, slsDataQ:True, dlsMeltingDataQ:False, meltingIdx_/;Length[meltingIdx]==0, aggreIdx_/;Length[aggreIdx]>0, meltingIntensityIdx_, meltingBaryIdx_]:=
		TabView[MapThread[Rule,{{"Aggregation Curves","DerivativeOverlay"},{figs[[1]],figs[[2]]}}]];

(* Aggregation curves are available *)
mergePlots[figs_, pType:All, fssDataQ:True, slsDataQ:True, dlsMeltingDataQ:False, meltingIdx_, aggreIdx_/;Length[aggreIdx]>0, meltingIntensityIdx_, meltingBaryIdx_]:=
		TabView[MapThread[Rule,{{"Melting Curves","DerivativeOverlay","Aggregation Curves","DerivativeOverlay"},{figs[[1]],figs[[3]],figs[[2]],figs[[4]]}}]];

(* SLS results are presented but aggregation curves not analyzed *)
mergePlots[figs_, pType:All, fssDataQ:True, slsDataQ:True, dlsMeltingDataQ:False, meltingIdx_, aggreIdx_/;Length[aggreIdx]==0, meltingIntensityIdx_, meltingBaryIdx_]:=
		TabView[MapThread[Rule,{{"Melting Curves","DerivativeOverlay"},{figs[[1]],figs[[2]]}}]];

(* No SLS results are available and only melting will be shown *)
mergePlots[figs_, pType:Except[All], fssDataQ:True, slsDataQ:False, dlsMeltingDataQ:False, meltingIdx_, aggreIdx_, meltingIntensityIdx_, meltingBaryIdx_]:= First[figs];

(* Only Barycentric transformation has been used *)
mergePlots[figs_, pType:Except[All], fssDataQ:True, slsDataQ:True, dlsMeltingDataQ:False, meltingIdx_, aggreIdx_/;Length[aggreIdx]==0, meltingIntensityIdx_/;Length[meltingIntensityIdx]==0, meltingBaryIdx_/;Length[meltingBaryIdx]>0]:= First[figs];

(* Only non BarycentricMean transformation has been used *)
mergePlots[figs_, pType:Except[All], fssDataQ:True, slsDataQ:True, dlsMeltingDataQ:False, meltingIdx_, aggreIdx_/;Length[aggreIdx]==0, meltingIntensityIdx_/;Length[meltingIntensityIdx]>0, meltingBaryIdx_/;Length[meltingBaryIdx]==0]:=First[figs];

(* Only aggregation data is available *)
mergePlots[figs_, pType:Except[All], fssDataQ:True, slsDataQ:True, dlsMeltingDataQ:False, meltingIdx_, aggreIdx_/;Length[aggreIdx]>0, meltingIntensityIdx_/;Length[meltingIntensityIdx]==0, meltingBaryIdx_/;Length[meltingBaryIdx]==0]:=First[figs];

(* Both BarycentricMean and non BarycentricMean transformation have been used *)
mergePlots[figs_, pType:Except[All], fssDataQ:True, slsDataQ:True, dlsMeltingDataQ:False, meltingIdx_, aggreIdx_/;Length[aggreIdx]==0, meltingIntensityIdx_/;Length[meltingIntensityIdx]>0, meltingBaryIdx_/;Length[meltingBaryIdx]>0]:=First[figs];

(* Barycentric transformation and aggregation results are available *)
mergePlots[figs_, pType:Except[All], fssDataQ:True, slsDataQ:True, dlsMeltingDataQ:False, meltingIdx_, aggreIdx_/;Length[aggreIdx]>0, meltingIntensityIdx_/;Length[meltingIntensityIdx]==0, meltingBaryIdx_/;Length[meltingBaryIdx]>0]:=
		TabView[MapThread[Rule,{{"Melting Curves","Aggregation Curves"},figs}]];

(* Non barycentric transformation and aggregation results are available *)
mergePlots[figs_, pType:Except[All], fssDataQ:True, slsDataQ:True, dlsMeltingDataQ:False, meltingIdx_, aggreIdx_/;Length[aggreIdx]>0, meltingIntensityIdx_/;Length[meltingIntensityIdx]>0, meltingBaryIdx_/;Length[meltingBaryIdx]==0]:=
		TabView[MapThread[Rule,{{"Melting Curve","Aggregation Curves"},figs}]];
