(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotAbsorbanceKinetics*)


DefineOptions[PlotAbsorbanceKinetics,
	optionsJoin[
		generateSharedOptions[
			Object[Data, AbsorbanceKinetics], Automatic,
			PlotTypes -> {LinePlot}, SecondaryData -> {Temperature}, Display -> {}
		],
		Options :> {

			(* Primary data *)
			{
				OptionName->PlotType,
				Default->Automatic,
				AllowNull->False,
				Description->"Indicates how the data should be presented.",
				Widget->Widget[Type->Enumeration,Pattern:>Automatic|ListLinePlot|ContourPlot|DensityPlot|ListPlot3D],
				Category->"Primary Data"
			},
			{
				OptionName->Wavelength,
				Default->Automatic,
				AllowNull->False,
				Description->"Indicates that only data generated at this wavelength should be plotted.",
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>Automatic|ListLinePlot|ContourPlot|DensityPlot|ListPlot3D],
					Widget[Type->Quantity,Pattern:>RangeP[0 Nanometer,1000 Nanometer, 1 Nanometer],Units->Nanometer]
				],
				Category->"Primary Data"
			},
			{
				OptionName->SamplingRate,
				Default->Null,
				AllowNull->True,
				Description->"The sampling rate - this is only appended as Null - consider removing.",
				Widget->Widget[Type->Expression,Pattern:>_,Size->Word],
				Category->"Hidden"
			}

		}
	],
	SharedOptions :> {
		EmeraldListLinePlot
	}
];


(* ::Subsection::Closed:: *)
(*Messages*)


Warning::AllWavelengths="Since a 3D plot was requested, data for all available wavelengths will be shown. Please set PlotType -> ListLinePlot if you wish to see data at only a specific wavelength.";
Warning::Data2D="Since the data is two dimensional, PlotType will be set to ListLinePlot.";
Warning::WavelengthUnavailable="No data is available at the requested wavelength. Instead the data for `1` will be used.";
Warning::WavelengthRequired="To plot the data as a ListLinePlot a specific wavelength must be requested.";
Error::NoAbsorbanceKineticsDataToPlot = "The protocol object does not contain any associated absorbance kinetics data.";
Error::AbsorbanceKineticsProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotAbsorbanceKinetics or PlotObject on an individual data object to identify the missing values.";


(* Raw Definition *)
PlotAbsorbanceKinetics[primaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotAbsorbanceSpectroscopy]]:=rawToPacket[
	primaryData,
	Object[Data,AbsorbanceKinetics],
	PlotAbsorbanceKinetics,
	SafeOptions[PlotAbsorbanceKinetics, Append[ToList[inputOptions],PrimaryData->AbsorbanceTrajectories]]
];


(* protocol overload *)
PlotAbsorbanceKinetics[
	obj:ObjectP[Object[Protocol,AbsorbanceKinetics]],
	ops:OptionsPattern[PlotAbsorbanceKinetics]
] := Module[{safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotAbsorbanceKinetics, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, {ObjectP[Object[Data, AbsorbanceKinetics]]..}],
		Message[Error::NoAbsorbanceKineticsDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotAbsorbanceKinetics[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotAbsorbanceKinetics[#, Sequence @@ ReplaceRule[safeOps, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::AbsorbanceKineticsProtocolDataNotPlotted];
		Return[$Failed],
		Nothing
	];

	(* If Result was requested, output the plots in slide view, unless there is only one plot then we can just show it not in slide view. *)
	outputPlot = If[MemberQ[output, Result],
		If[Length[plots] > 1,
			SlideView[plots],
			First[plots]
		]
	];

	(* If Options were requested, just take the first set of options since they are the same for all plots. Make it a List first just in case there is only one option set. *)
	outputOptions = If[MemberQ[output, Options],
		First[ToList[resolvedOptions]]
	];

	(* Prepare our final result *)
	finalResult = output /. {
		Result -> outputPlot,
		Options -> outputOptions,
		Preview -> previewPlot,
		Tests -> {}
	};

	(* Return the result *)
	If[
		Length[finalResult] == 1,
		First[finalResult],
		finalResult
	]
];

PlotAbsorbanceKinetics[input:ListableP[ObjectP[Object[Data,AbsorbanceKinetics]]],inputOptions:OptionsPattern[]]:=Module[
	{
		listedOptions,outputSpecification,output,gatherTests,outputOptions,safeOptions,safeOptionTests,dataObjects,
		requestedPlotType,requestedWavelength,requestedPrimaryData,requestedDisplay,plotTypes3D,downloadFields,rawPackets,
		packets,wavelengths,minWavelength,maxWavelength,absorbanceTrajectoriesLists,unblankedTrajectoriesLists,
		absorbanceTrajectory3DLists,unblankedTrajectory3DLists,
		resolvedPrimaryData,resolvedPlotType,requestedWavelengthInRange,resolvedWavelength,
		resolvedOps,result,options
	},

	(* Make sure we're working with a list of options *)
	listedOptions = ToList[inputOptions];

	(* Determine the requested return value from the function *)
	outputSpecification = OptionValue[Output];
	output = ToList[OptionValue[Output]];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Determine if we should output the resolved options *)
	outputOptions = MemberQ[output, Options];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests}=If[gatherTests,
		SafeOptions[PlotAbsorbanceKinetics,listedOptions,Output->{Result,Test},AutoCorrect->False],
		{SafeOptions[PlotAbsorbanceKinetics,listedOptions,AutoCorrect->False],Null}
	];

	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	dataObjects = ToList[input];

	(* Don't call safeOps since packetToELLP will distribute listed options *)
	requestedPlotType = OptionDefault[OptionValue[PlotType]];
	requestedWavelength = OptionDefault[OptionValue[Wavelength]];
	requestedPrimaryData = OptionDefault[OptionValue[PrimaryData]];
	requestedDisplay=OptionDefault[OptionValue[Display]];

	plotTypes3D = ContourPlot|DensityPlot|ListPlot3D;

	(* Quiet MissingField error since raw data will be put in a packet which will not necessarily have all these fields *)
	rawPackets =Quiet[
		Download[dataObjects,Packet[
			AbsorbanceTrajectories,AbsorbanceTrajectory3D,
			UnblankedAbsorbanceTrajectories,UnblankedAbsorbanceTrajectory3D,Wavelengths,
			MinWavelength,MaxWavelength
		]],
		Download::MissingField
	];

	(* Drop Object key if $Failed, since packetToELLP can't handle this *)
	packets = If[MatchQ[Lookup[rawPackets,Object],{$Failed..}],
		KeyDrop[rawPackets,Object],
		rawPackets
	];

	{wavelengths,minWavelength,maxWavelength} = Lookup[First[packets],{Wavelengths,MinWavelength,MaxWavelength}];
	absorbanceTrajectoriesLists = Lookup[packets,AbsorbanceTrajectories];
	unblankedTrajectoriesLists = Lookup[packets,UnblankedAbsorbanceTrajectories];
	absorbanceTrajectory3DLists = Lookup[packets,AbsorbanceTrajectory3D];
	unblankedTrajectory3DLists = Lookup[packets,UnblankedAbsorbanceTrajectory3D];

	resolvedPrimaryData=Which[
		!MatchQ[requestedPrimaryData,Automatic],requestedPrimaryData,
		MatchQ[absorbanceTrajectoriesLists,{{}...}],AbsorbanceTrajectory3D,
		True,AbsorbanceTrajectories
	];

	(* -- Resolve PlotType -- *)
	resolvedPlotType = Which[
		(* Resolve Automatic *)
		MatchQ[requestedPlotType,Automatic]&&MatchQ[resolvedPrimaryData,ListableP[AbsorbanceTrajectory3D|UnblankedAbsorbanceTrajectory3D]]&&!MatchQ[requestedWavelength,DistanceP],
			ContourPlot,
		MatchQ[requestedPlotType, Automatic],
			ListLinePlot,
		(* No 3D data, can't do a 3D plot, roll on and do a 2D plot. *)
		And[
			Or[
				MatchQ[absorbanceTrajectory3DLists, {Null..}],
				MatchQ[First[absorbanceTrajectory3DLists], $Failed]
			],
			MatchQ[requestedPlotType, plotTypes3D]
		],
			Module[{},
				Message[Warning::Data2D];
				Message[Error::InvalidOption,"PlotType"];
				ListLinePlot
			],

		True,requestedPlotType
	];

	(* -- Resolve Wavelength -- *)

	requestedWavelengthInRange = Or[
		MatchQ[requestedWavelength,Automatic|All],
		MemberQ[Round[wavelengths],Round[requestedWavelength]],
		RangeQ[requestedWavelength,{minWavelength,maxWavelength}]
	];

	resolvedWavelength = Which[
		(* 3D plot, shouldn't specify wavelength *)
		MatchQ[resolvedPlotType,plotTypes3D]&&MatchQ[requestedWavelength,DistanceP],Message[Warning::AllWavelengths],

		MatchQ[resolvedPlotType,plotTypes3D],Null,

		(* 2D plot, specified wavelength in range *)
		MatchQ[resolvedPlotType,ListLinePlot]&&MatchQ[requestedWavelength,DistanceP|All]&&requestedWavelengthInRange,requestedWavelength,

		(* 2D plot, specified wavelength out of range *)
		MatchQ[resolvedPlotType,ListLinePlot]&&MatchQ[requestedWavelength,DistanceP]&&!requestedWavelengthInRange,Module[{closestWavelength},
			closestWavelength = Round@First[MinimalBy[Join[wavelengths,{minWavelength,maxWavelength}],Abs[requestedWavelength-#]&]];
			Message[Warning::WavelengthUnavailable,closestWavelength];
			Message[Error::InvalidOption,"Wavelength"];
			closestWavelength
		],

		(* Asked for a 2D plot but using 3D so a wavelength is required *)
		MatchQ[resolvedPlotType,ListLinePlot]&&MatchQ[requestedWavelength,All],Module[{},
			Message[Warning::WavelengthRequired,requestedWavelength];
			Round@First[MinimalBy[Join[wavelengths,{minWavelength,maxWavelength}],Abs[requestedWavelength-#]&]]
		],

		(* Resolve automatic *)

		(* Just plot all the wavelengths if we have 2d data *)
		MatchQ[resolvedPlotType,ListLinePlot]&&MatchQ[resolvedPrimaryData,ListableP[AbsorbanceTrajectories|UnblankedAbsorbanceTrajectories]],All,

		True,If[RangeQ[280 Nanometer,{minWavelength,maxWavelength}],
			(* Use 280 if in range *)
			280 Nanometer,
			(* Otherwise find the wavelength in the center of the range *)
			Round[Mean[{minWavelength,maxWavelength}]]
		]
	];

	(*pass the resolved Primary Data in *)
	resolvedOps = ReplaceRule[ToList[inputOptions],{PrimaryData->resolvedPrimaryData}];

	{result,options}=Which[
		(* Are we dealing with a ListLinePlot? *)
		MatchQ[resolvedPlotType,ListLinePlot],Module[
			{updatedPackets,optionLegend,resolvedLegend,finalLegend,resolvedOpsWithOutput,ellpResult,listLinePlot,listLinePlotOptions,fullOptions,absOptions,allResolvedOptions,validResolvedOptions},

			(* we may have to update our packets depending on the absorbance data *)
			updatedPackets = Map[
				Function[packet,
					Which[
						(*if all the values are failed then just leave as is -- this done during the raw data transformation*)
						MatchQ[Values[KeyDrop[packet, {Type, ID}]], {$Failed ..}],packet,

						(* plotting all 3D data *)
						MatchQ[resolvedPlotType,plotTypes3D],packet,

						(* pick the requested wavelength *)
						MatchQ[resolvedPrimaryData,AbsorbanceTrajectories|UnblankedAbsorbanceTrajectories]&&!MatchQ[resolvedWavelength,All],Module[{trajectory},
							trajectory = First[
								PickList[
									Lookup[packet,resolvedPrimaryData],
									Round/@wavelengths,
									Round[resolvedWavelength]
								]
							];
							Append[packet,resolvedPrimaryData->trajectory]
						],

						(* extract wavelength of interest *)
						MatchQ[resolvedPrimaryData,AbsorbanceTrajectory3D|UnblankedAbsorbanceTrajectory3D],Module[{absorbanceUnitless,wavelengthUnitless,trajectory},
							absorbanceUnitless = MapAt[Round,QuantityMagnitude[Lookup[packet,resolvedPrimaryData],{Second, Nanometer, AbsorbanceUnit}],{All,2}];
							wavelengthUnitless = Unitless[resolvedWavelength,Nanometer];
							trajectory = QuantityArray[Cases[absorbanceUnitless,{_,wavelengthUnitless,_}][[All,{1,3}]],{Second,AbsorbanceUnit}];
							Append[packet,resolvedPrimaryData->trajectory]
						],

						(*otherwise, don't need to do anything*)
						True,packet
					]
				],
				packets
			];

			(* If we're plotting the trajectories make our legend point to the relevant wavelengths *)
			resolvedLegend = If[MatchQ[resolvedPrimaryData,AbsorbanceTrajectories|UnblankedAbsorbanceTrajectories]&&MatchQ[wavelengths,{DistanceP..}],
				Flatten@Map[
					Function[{packet},
						Module[{object,wls},
							{object,wls}=If[MatchQ[resolvedWavelength,All],
								Lookup[packet,{Object,Wavelengths}],
								{Lookup[packet,Object],{resolvedWavelength}}
							];
							Map[
								(ToString[Lookup[packet, Object]] <> " - " <>ToString[Unitless[#1, Nanometer]] <> "nm")&,
								wls
							]
						]
					],
					packets
				],
				Automatic
			];

			(* The value of the legend taken from the provided options *)
			optionLegend=Lookup[resolvedOps,Legend];

			(* Make sure the legends provided in options take precedence *)
			finalLegend=If[MatchQ[optionLegend,_Missing|Automatic],
				resolvedLegend,
				optionLegend
			];

			(* Force output of Result and Options *)
			resolvedOpsWithOutput=ReplaceRule[resolvedOps,{Legend->finalLegend,Output->{Result,Options}}];

			(* Call EmeraldListLinePlot with these resolved options, forcing Output\[Rule]{Result,Options}. *)
			ellpResult=packetToELLP[updatedPackets,PlotAbsorbanceKinetics,resolvedOpsWithOutput];

			(* If the result from ELLP was Null or $Failed, return $Failed. *)
			If[MatchQ[ellpResult,Null|$Failed],
				Return[$Failed];
			];

			(* Check to see if we're mapping. If so, then we have to Transpose our result. *)
			{listLinePlot,listLinePlotOptions}=If[OptionValue[Map],
				Module[{transposedResult,plots,ellpOptions},
					transposedResult=Transpose[ellpResult];

					(* The plots are simply the first element in the list. *)
					plots=First[transposedResult];

					(* We are given back a list of options. (Options for each plot). We can't really return multiple so just pick the first. *)
					ellpOptions=transposedResult[[2]][[1]];

					{plots,ellpOptions}
				],
				(* There is no mapping going on. Don't transpose anything. *)
				If[Not[MatchQ[ellpResult,_List]],
					{ellpResult,{}},
					ellpResult
				]
			];

			(* Before we return, make sure that we include all of our safe options. *)
			(* Overwrite our SafeOptions with our resolved EmeraldListLinePlot options. *)
			fullOptions=Normal[Join[Association[safeOptions],<|PlotType->resolvedPlotType,Wavelength->resolvedWavelength|>,Association[listLinePlotOptions],<|SamplingRate->Null|>]];

			(* Return our result and options. *)
			{listLinePlot,fullOptions}
		],

		(* Are we dealing with a 3D Plot? *)
		MatchQ[resolvedPlotType,plotTypes3D],Module[
			{trajectories,targetUnits,unitlessConvertedData,sideLabels,options3D,full3DOptions,timeUnit,wavelengthUnit,absorbanceUnit,unitlessPlotRange,optionsWithRange,plots,plotListCorrect,zoomablePlot,allResolvedOptions,validResolvedOptions},

			trajectories=Lookup[packets,resolvedPrimaryData];

			targetUnits=Lookup[safeOptions,TargetUnits]/.Automatic->{Automatic,Automatic,Automatic};

			{{unitlessConvertedData},{timeUnit,wavelengthUnit,absorbanceUnit}}=convertAndStripData[PlotAbsorbanceKinetics,{trajectories},targetUnits,Numerical];

			(* Standard 3D plotting options *)
			sideLabels = MapThread[
				makeFrameLabel[#1,#2,defaultLabelColor]&,
				{
					{safeUnitDimension[timeUnit], "Wavelength", safeUnitDimension[absorbanceUnit]},
					{timeUnit, wavelengthUnit, absorbanceUnit}
				}
			];

			options3D = Association[
				PlotLabel -> autoResolvePlotLabel[ToString[Download[Replace[dataObjects,{singleItem_}:>singleItem],Object], InputForm],{Bold, 14, FontFamily -> "Arial"},600],
				If[MatchQ[resolvedPlotType,ContourPlot|DensityPlot],
					FrameLabel -> sideLabels[[{1,2}]],
					AxesLabel -> sideLabels
				],
				PlotLegends -> Placed[BarLegend[Automatic, LegendLabel -> Placed[Rotate[sideLabels[[3]],Pi/2],Right],LabelStyle -> {Bold, 14, FontFamily -> "Arial",defaultLabelColor}],Right],
				PlotRange -> All,
				LabelStyle -> {Bold, 14, FontFamily -> "Arial"},
				AspectRatio -> 1/GoldenRatio,
				ImageSize -> 600
			];

			(* Use 3D options only if something else wasn't specified in the input *)
			full3DOptions = Normal@Join[options3D,Association[ToList[inputOptions]/.{Null -> {}}]];

			(* There's a MM bug which causes plot ranges with units to be ignored (instead range gets set from -1..1)
				Replace any units with their unitless counterparts
			*)

			unitlessPlotRange=ReplaceAll[Lookup[full3DOptions,PlotRange],{
				x:TimeP:>Unitless[x,timeUnit],
				y:UnitsP[AbsorbanceUnit]:>Unitless[y,absorbanceUnit],
				z:DistanceP:>Unitless[z,wavelengthUnit]
			}];
			optionsWithRange=ReplaceRule[full3DOptions,PlotRange->unitlessPlotRange];

			plots = Switch[resolvedPlotType,
				ContourPlot, EmeraldListContourPlot[QuantityArray[#,{timeUnit,wavelengthUnit,absorbanceUnit}],Sequence@@DeleteCases[{PassOptions[PlotAbsorbanceKinetics,EmeraldListContourPlot,optionsWithRange]},Rule[PlotTheme|"PlotTheme",_]]]&/@unitlessConvertedData,
				DensityPlot, ListDensityPlot[QuantityArray[#,{timeUnit,wavelengthUnit,absorbanceUnit}],PassOptions[PlotAbsorbanceKinetics,ListDensityPlot,optionsWithRange]]&/@unitlessConvertedData,
				(* Sending in full options from PassOptions makes the plot appear bizarre *)
				ListPlot3D, ListPlot3D[QuantityArray[#,{timeUnit,wavelengthUnit,absorbanceUnit}],Normal@KeyTake[optionsWithRange,Keys[Options[ListPlot3D]]]]&/@unitlessConvertedData
			];

			plotListCorrect = If[MatchQ[input,ObjectP[]],
				First[plots],
				plots
			];

			zoomablePlot=If[TrueQ[OptionDefault[OptionValue[Zoomable]]],
				Zoomable[plotListCorrect],
				plotListCorrect
			];


			(* Get the resolved options from the plot. *)
			absOptions=Quiet[AbsoluteOptions[First[plots]]];
			allResolvedOptions=Normal[Join[Association[safeOptions],
				If[MatchQ[absOptions,{(_Rule|_RuleDelayed)..}],Association[absOptions],Association[]]
			]];
			validResolvedOptions=(ToExpression[#[[1]]]->#[[2]]&)/@ToList[PassOptions[PlotAbsorbanceKinetics,allResolvedOptions]];

			(* Force output of Result and Options *)
			{zoomablePlot,validResolvedOptions}
		],

		True,$Failed
	];

	outputSpecification/.{
		Result->result,
		Preview->result,
		Options->options,
		Tests->Join[
			safeOptionTests,
			{
				Test["Specified wavelength must be available in input data.", MatchQ[resolvedPlotType,ListLinePlot]&&MatchQ[requestedWavelength,DistanceP]&&!requestedWavelengthInRange, False],
				Test["Wavelength option should not be specified if doing 3D plot.", MatchQ[resolvedPlotType,plotTypes3D]&&MatchQ[requestedWavelength,DistanceP], False],
				Test["If a plot of 3D absorbance data was requested, 3D data is available.", MatchQ[Lookup[packets,resolvedPrimaryData],{Null..}] && MatchQ[requestedPlotType,plotTypes3D], False]
			}
		]
	}
];
