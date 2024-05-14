doePlotP = HoldPattern[ DynamicModule[_List,   EventHandler[Panel[Row[{_Graphics, ___}]], _List], _]];


PlotDesignOfExperiment[scriptObj:ObjectP[Object[DesignOfExperiment]]]:=
	PlotDesignOfExperiment[Last[scriptObj[DesignOfExperimentAnalyses]]];


PlotDesignOfExperiment[anaObj:ObjectP[Object[Analysis,DesignOfExperiment]]]:=Module[{y,xxbest,ybest,xyTraces,posMax,exppars,pnames,objf,xyRaws,
	chosenInds={},gray=GrayLevel[0.8], pDim, objectiveFunctionPlot,xxy, dataUnits, pRanges, nSets},

	{y,xxbest,ybest,xyTraces,expparsRules,pnames,objf,pRanges} = Quiet[Download[anaObj,
		{ObjectiveValues,OptimalParameters,OptimalObjectiveValue,Data[Absorbance],ExperimentParameters,ParameterSpace,ObjectiveFunction,Reference[Ranges]}
	],{Download::MissingField}];

	(* number of design parameters *)
	pDim = Length[pnames];

	(* Placeholder if analysis hasn't finished any steps yet *)
	If[Length[y]===0,
		Return[Graphics[{}]]
	];

	(* total number of poitns in grid search *)
	If[MatchQ[pRanges,{}|$Failed], (* if no reference *)
		(
			pRanges = Table[Automatic,pDim];
			nSets = Length[y];
		),
		(
			pRanges = Unitless@Last[pRanges];
			nSets = Times@@Map[Length,pRanges];
		)
	];
	(* just the design parameter values *)
	exppars = Unitless@Lookup[expparsRules,pnames];
	dataUnits = Quantity/@xyTraces[[1]]["UnitBlock"];
	xyRaws = Unitless[#,dataUnits]&/@xyTraces;
	posMax = Ordering[Unitless[y]][[-1]];
	DynamicModule[{chosenTable,color},
		(* initialize the data plots to light gray *)
		Map[color[#]=gray;&,exppars];
		(* set hte optimal data trace to Red *)
		color[exppars[[posMax]]]=Red;

		chosenTable = Grid[{
			Prepend[pnames,objf],
			Map[Style[#,Red]&,Prepend[exppars[[posMax]],ToString@y[[posMax]]]]
			}
		];

		(*
			{ {p11,p12,p13,...,y1}, {p21,p22,p23,...,y2}, ... }
		*)
		xxy = Unitless@Transpose[Append[Transpose[exppars],y]];

		objectiveFunctionPlot = Switch[pDim,
			1,  EmeraldListLinePlot[
					xxy,
					ImageSize->{600,500},FrameLabel->Append[pnames,objf],
					Epilog -> MapThread[{Dynamic[color[#1[[{1}]]]],PointSize[0.02],Point[#]}&,{xxy}],
					PlotRange->{ MinMax[First[pRanges]], Automatic}
				],
			2, Quiet[EmeraldListContourPlot[
					If[Length[xxy]<2, Join[xxy,xxy],xxy],
					ImageSize->{Automatic,500},FrameLabel->pnames,
					Epilog -> MapThread[{Dynamic[color[#1]],PointSize[0.02],Point[#]}&,{exppars}],
					PlotRange-> Map[MinMax,pRanges],
					PlotLegends->Automatic],
				{ListContourPlot::gmat}]
		];
		EventHandler[
			Panel@Labeled[Row[{

				(* Objective Function plot *)
				Labeled[objectiveFunctionPlot,{
					SwatchLegend[{Red},{Style["Optimal "<>ToString[objf],16]},LegendMarkerSize->{16,16}]
					},{Top}],

				(* Data plot *)
				Grid[{
				{Labeled[EmeraldListLinePlot[{Null},FrameUnits -> dataUnits, ImageSize->500,PlotRange->CoordinateBounds[Flatten[xyRaws,1]],
					Epilog->MapThread[{Dynamic[color[#1]],Line[#2]}&,{exppars,xyRaws}]],
					{LineLegend[{Red},{Style["Optimal Data Set",16]}]},{Top}
				]},
				{Pane[Dynamic[chosenTable],ImageSize->{500,150},Scrollbars->{Automatic,Automatic}]}
								}]
			}],Style[If[Length[y]<nSets, "Completed "<>ToString[Length[y]]<>" out of "<>ToString[nSets], "" ],Bold,20],Top],
			{
				"MouseClicked":>With[
					{
						mp=MousePosition["Graphics"]
					},
					Module[{distances,closestInd,shiftQ=CurrentValue["ShiftKey"],coordBounds = CoordinateBounds[xxy[[;;,1;;2]]]},
						(* distance from click to all pset points, scaled *)
						distances = Norm/@Transpose[(mp - Transpose[xxy][[1;;2]])/coordBounds.{-1,1}];
						(* if close enough to a point*)
						If[Min[distances] < Infinity,
							closestInd = First[Ordering[distances]];
							If[shiftQ,
								(* add to current list *)
								chosenInds = DeleteDuplicates[Append[chosenInds,closestInd]],
								(* clear old points and just use new point *)
								chosenInds = {closestInd}
							];
						];
						chosenTable= Grid[Join[
							{Prepend[pnames,objf]},
							{Map[Style[#,Red]&,Prepend[exppars[[posMax]],ToString@y[[posMax]]]]},
							Table[
								Map[
									Style[#,Blend[{Blue,Green},ind/(Length[chosenInds]+1)]]&,
									Prepend[exppars[[chosenInds[[ind]]]],ToString@y[[chosenInds[[ind]]]]]
								],
								{ind,1,Length[chosenInds]}
							]
						]];
						Map[color[#]=gray;&,exppars];
						MapIndexed[
							With[
								{pp=exppars[[#1]]},
								color[pp] = Blend[{Blue,Green},First[#2]/(Length[chosenInds]+1)];
							]&,
							chosenInds
						];
						color[exppars[[posMax]]]=Red;
					]
				]
			}
		]
	]
]
