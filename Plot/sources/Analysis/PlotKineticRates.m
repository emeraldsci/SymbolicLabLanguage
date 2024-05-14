(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*PlotKineticRates*)


DefineOptions[PlotKineticRates,
	Options :> {
    {
        OptionName -> TotalConcentration,
        Default -> False,
        Description -> "Whether to plot a single predicted trajectory corresponding to the sum of concentrations over all species.",
        AllowNull -> False,
        Widget -> Widget[Type->Enumeration, Pattern:>BooleanP]
    },
    (*** Data Specifications Options ***)
    {
      OptionName -> PlotType,
      Default -> {Log,Log},
      Description -> "Scaling of axes in goodness of fit plot.",
      AllowNull -> False,
      Widget ->
      {
        "X"->Widget[Type->Enumeration, Pattern:>Alternatives[Linear,Log]],
        "Y"->Widget[Type->Enumeration, Pattern:>Alternatives[Linear,Log]]
      },
      Category->"Data Specifications"
    },
    {
      OptionName -> PlotStyle,
      Default -> Trajectories,
      Description -> "Type of plot to create.",
      AllowNull -> False,
      Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Trajectories,GoodnessOfFit]],
      Category->"Data Specifications"
    },
    {
      OptionName -> FeatureDisplay,
      Default -> {BestFit},
      Description -> "Features to display on the goodness of fit plot.",
      AllowNull -> True,
      Widget -> Alternatives[
        "Single Feature"->Widget[Type->Enumeration, Pattern:>Alternatives[BestFit, SampleMinimum]],
        "Multiple Features"->Adder[Widget[Type->Enumeration, Pattern:>Alternatives[BestFit, SampleMinimum]]],
        "Other"->Widget[Type->Enumeration,Pattern:>Alternatives[{}]]
      ],
      Category->"Data Specifications"
    },
    {
      OptionName -> Rates,
      Default -> Automatic,
      Description -> "The rates to be varied in the goodness of fit plot, along with their values or ranges.",
      AllowNull -> False,
      Widget -> Alternatives[
        Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
        Widget[Type->Expression,Pattern:>_,Size->Word]
      ],
      Category->"Data Specifications"
    },

    (*** Output Option ***)
    OutputOption

	},
	SharedOptions :> {

    (*** Legend Options ***)
    ModifyOptions["Shared",LegendOption,
      {
        {OptionName->Legend,Default->None,AllowNull->True}
      }
    ],

    (*** Frame Options ***)
    ModifyOptions["Shared",ListPlotOptions,
      {
        {OptionName->Frame,Default->{True,True,False,False}},
        {OptionName->FrameStyle,Default->Automatic},
        {OptionName->FrameLabel}
      }
    ],

    (*** Plot Labeling Options ***)
    ModifyOptions["Shared",ListPlotOptions,
      {
        {OptionName->PlotLabel,Default->Automatic},
        {OptionName->LabelStyle}
      }
    ],

    (* Note the order of the functions so the shared option values would take precedence from top to bottom *)
    PlotTrajectory,
		EmeraldListLinePlot,
    EmeraldListContourPlot

	}
];


PlotKineticRates[fittedRatePacket0: ObjectP[Object[Analysis, Kinetics]],ops:OptionsPattern[PlotKineticRates]]:= Module[

  {
    fittedRatePacket,safeOps,resolvedOps,originalOps,output,internalPlotOps,fig,returnedOps
  },

  (* Convert the original option into a list *)
  originalOps=ToList[ops];

  (* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
  safeOps=SafeOptions[PlotKineticRates,originalOps];

  (* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
  output=Lookup[safeOps,Output];

	fittedRatePacket = Download[Analysis`Private`stripAppendReplaceKeyHeads[fittedRatePacket0]];

  (* Options to pass to internal plot functions *)
	internalPlotOps = ReplaceRule[
		safeOps,
		{
			Rates->resolvePlotKineticRatesRateOption[Lookup[safeOps,Rates],fittedRatePacket],
			(* make sure it's a list *)
			FeatureDisplay -> Flatten[{Lookup[safeOps,FeatureDisplay]}]
		}
	];

  (* Figures and options from the underlying plot functions *)
	{fig,returnedOps}=Switch[Lookup[safeOps,PlotStyle],
	  Trajectories,
			plotKineticRatesTrajectories[fittedRatePacket,internalPlotOps],
	  GoodnessOfFit,
	    plotKineticRatesObjectiveFunction[fittedRatePacket,internalPlotOps]
	 ];

   (* The final resolved options based on safeOps and the return from underlying plot functions *)
   resolvedOps=ReplaceRule[safeOps,Prepend[returnedOps,Output->output]];

   (* Return the result, options, or tests according to the output option. *)
   output/.{
     Result->fig,
     Preview->fig,
     Tests->{},
     Options->resolvedOps
   }
];


plotKineticRatesTrajectories[fittedRatePacket_,safeOps_List]:=Module[

  {
    rawLegend,trainingPlots,testingPlots,specs,colorRules,trainingTrajs,predTrajs,specLists,
    internalTrainingPlotOps,internalTestingPlotOps,internalShowOps,finalPlot,returnedOps,
    trainingOps,testingOps
  },

	(* training data trajectories *)
 	trainingTrajs = Transpose[Analysis`Private`packetLookup[Association[fittedRatePacket],TrainingData]][[3]];

  (* predicted trajectories *)
	predTrajs = PredictedTrajectories/.fittedRatePacket;

  (* species list from each training trajectory *)
  specLists = #[Species]&/@trainingTrajs;

  (* complete unique species across all training sets *)
  specs = DeleteDuplicates[Flatten[specLists]];

  (* link colors to species for consistent coloring *)
	colorRules = MapIndexed[#1->ColorData[97][First[#2]]&,specs];

  (* legend *)
  rawLegend=resolvePlotKineticRatesLegend[Legend/.safeOps,specLists,specs];

  (* The options passed to PlotTrajectory for training *)
	internalTrainingPlotOps=ToList@PassOptions[PlotKineticRates,ECL`PlotTrajectory,
		ReplaceRule[safeOps,
      {
        PlotLabel->If[MatchQ[Lookup[safeOps,PlotLabel],Automatic],
          None,
          Lookup[safeOps,PlotLabel]
        ],
        Joined->False,
        Legend->Null,
        PlotStyle->Automatic,
        Output->{Result,Options}
      }
    ]
  ];

  (* The options passed to PlotTrajectory for training *)
  internalTestingPlotOps=ToList@PassOptions[PlotKineticRates,ECL`PlotTrajectory,
    ReplaceRule[safeOps,
      {
        PlotLabel->If[MatchQ[Lookup[safeOps,PlotLabel],Automatic],
          None,
          Lookup[safeOps,PlotLabel]
        ],
        Legend->rawLegend,
        PlotStyle->Automatic,
        Output->{Result,Options}
      }
    ]
  ];

  (* plot training data as dots *)
  {trainingPlots,trainingOps} = Unzoomable[ECL`PlotTrajectory[trainingTrajs,internalTrainingPlotOps]];

	(* plot predicted data as lines *)
  {testingPlots,testingOps} = Unzoomable[ECL`PlotTrajectory[predTrajs,internalTestingPlotOps]];

  (* Options are aggregated into a single list by preserving those that were resolved to the same value for all inputs. Any options resolved to different values between inputs are set to Automatic. *)
  mergedReturnedOps=MapThread[
    If[CountDistinct[List@##]>1,First@#->Automatic,First@DeleteDuplicates[List@##]]&,
    {trainingOps,testingOps}
  ];

  (* The options to pass to Show *)
	internalShowOps=
    {
      PlotRange->All
    };

  (* combine the plots *)
  finalPlot=Show[Flatten[{trainingPlots,testingPlots}],internalShowOps];

  (* The final resolved options based on safeOps and the return from PlotFit giving precedence to internalShowOps. Override the options returned from the plot calls by the one used in Show *)
  returnedOps=ReplaceRule[
    mergedReturnedOps,
    internalShowOps
  ];

  {finalPlot,returnedOps}

];

resolvePlotKineticRatesLegend[Automatic,specLists_,specs_]:=Module[{specRules},
	specRules = MapIndexed[Function[s,s -> ToString[s]<> " - training set "<>ToString[First[#2]]]/@#1&,specLists];
	Transpose[Map[Replace[specs,Append[#,_->Null],{1}]&,specRules]]
];
resolvePlotKineticRatesLegend[legend_,specLists_,specs_]:=legend;


(* ::Subsubsection:: *)
(*plotKineticRatesObjectiveFunction*)


plotKineticRatesObjectiveFunction[fittedRatePacket_,resolvedOps_List]:=Module[{
		objTable,optimum,rxs,kts,fixedRates,kRanges,allRates,allRateVals,
		variableRates,fixedRateRules,variableRateRules,allRateRules,kvars
	},

	kts = TrainingData/.fittedRatePacket;

	rxs = FitMechanism/.fittedRatePacket;

	(* all rates from unfitted mechanism (will have some symbolic rates) *)
	allRates = Flatten@rxs[Rates];

	(* all rates from fitted mechanism (all numeric rates) *)
	allRateVals = Flatten@(ReactionMechanism/.fittedRatePacket)[Rates];

	(* rules linking rate to its value *)
	allRateRules = Thread[Rule[allRates,allRateVals]];

	(* ranges of rate sampling *)
	kRanges = Rates/.resolvedOps;

	(* log everytyhing *)
	kRanges = N@MapAt[Log10,kRanges,{;;,2}];

	(* make sure sampled rates exist in mechanism *)
	If[!ContainsAll[allRates,kRanges[[;;,1]]],
		Message[PlotKineticRates::UnknownRates];
		Return[Null]
	];

	(* the rates being sampled *)
	variableRates = kRanges[[;;,1]];

	(* the rates that are being held constant *)
	fixedRates = Complement[allRates,variableRates];
	fixedRateRules = Select[allRateRules,MemberQ[fixedRates,#[[1]]]&];

	(* the rates being varied, as rules *)
	variableRateRules = Select[allRateRules,MemberQ[variableRates,#[[1]]]&];

	(* set of reactions *)
	rxs = NucleicAcids`Private`mechanismToImplicitReactions[rxs] /. fixedRateRules;

	(* the optimum solution *)
	optimum = Log10[kRanges[[;;,1]]/.allRateRules];

	(* evaluate the error function at all the rate values *)
	objTable = SortBy[Analysis`Private`ObjectiveFunctionTable[rxs,kts,kRanges,AdditionalPoints->{optimum}],Last];

	(* symbolic rates from reactions *)
	kvars=Cases[Flatten[rxs[[;;,2;;]]],Except[_?NumberQ]];

	(* make the plot. the type of plot depends on number of rates *)
 	plotKineticRatesObjectiveFunction[rxs,objTable,kvars,10^optimum,resolvedOps]

];

(*
	1D listline plot
*)
plotKineticRatesObjectiveFunction[rxs_,objVals:{{_?NumberQ,_?NumberQ}..},kvars_,{solvedOpt_},safeOps_List]:=Module[
	{xTransformed,yTransformed,xLabel,yLabel,epilogs,display,internalELLPOps},

	display = Lookup[safeOps,FeatureDisplay];

	(* take log, if desired *)
	{{xTransformed,yTransformed},xLabel,yLabel}=
    transformForPlotType[Transpose[objVals],{kvars,"Fit Error"},Lookup[safeOps,PlotType]];

  (* The options passed to ELLP *)
 	internalELLPOps=ToList@PassOptions[PlotKineticRates,EmeraldListLinePlot,
 		ReplaceRule[safeOps,
      {
        Epilog->
          {
            (* minimum from sampled points *)
            If[MemberQ[display,SampleMinimum],
              optimumPointEpilog[MinimalBy[objVals,Last],Lookup[safeOps,PlotType],RGBColor[{0, .85, 0}]],
              Nothing
            ],
            (* minimum found by solver *)
            If[MemberQ[display,BestFit],
              optimumPointEpilog[Cases[objVals,{solvedOpt,_}],Lookup[safeOps,PlotType],Red],
              Nothing
            ],
            (* Add all extra epilogs from the user *)
            Sequence@@(ToList@Lookup[safeOps,Epilog])
          },
        PlotLegends->
          If[MatchQ[Lookup[safeOps,PlotLegends],Automatic],
            BarLegend[Automatic,LabelStyle -> Directive[Bold,Medium]],
            Lookup[safeOps,PlotLegends]
          ],
        FrameLabel->
          If[MatchQ[Lookup[safeOps,FrameLabel],Automatic],
            Map[ToString,{xLabel,yLabel}],
            Lookup[safeOps,FrameLabel]
          ],
        PlotLabel->
          If[MatchQ[Lookup[safeOps,PlotLabel],Automatic],
            Row[{
              Style["Error function for fitting to ",15],
              Tooltip[Style["the reactions",15],Column[Style[#,15]&/@rxs]]
            }],
            Lookup[safeOps,PlotLabel]
          ],
        FrameStyle ->
          If[MatchQ[Lookup[safeOps,FrameStyle],Automatic],
            Directive[Bold, Medium],
            Lookup[safeOps,FrameStyle]
          ],
        Output->{Result,Options}
      }
    ]
  ];

  (* Return ELLP and the associated options *)
	EmeraldListLinePlot[
		SortBy[Transpose[{xTransformed,yTransformed}],First],
		Sequence@@internalELLPOps
	]

];

(*
	2D contour plot
*)
plotKineticRatesObjectiveFunction[rxs_,objVals:{{_?NumberQ,_?NumberQ,_?NumberQ}..},kvars_,solvedOpt_,safeOps_List]:=Module[
	{xTransformed,yTransformed,xLabel,yLabel,display,internalELCPOps},
	(* take log, if desired *)

	display = Lookup[safeOps,FeatureDisplay];

	{{xTransformed,yTransformed},xLabel,yLabel}=
    transformForPlotType[Transpose[objVals][[1;;2]],kvars,Lookup[safeOps,PlotType]];

  (* The options passed to EmeraldListContourPlot *)
  internalELCPOps=ToList@PassOptions[PlotKineticRates,EmeraldListContourPlot,
 		ReplaceRule[safeOps,
      {
        Contours->50,
    		Epilog->{
    			(* minimum from sampled points *)
    			If[MemberQ[display,SampleMinimum],
    				optimumPointEpilog[MinimalBy[objVals,Last][[;;,;;-2]],Lookup[safeOps,PlotType],RGBColor[{0, .85, 0}]],
    				Nothing
    			],
    			(* minimum found by solver *)
    			If[MemberQ[display,BestFit],
    				optimumPointEpilog[{solvedOpt},Lookup[safeOps,PlotType],Red],
    				Nothing
    			],
          (* Add all extra epilogs from the user *)
          Sequence@@(ToList@Lookup[safeOps,Epilog])
    		},
    		PlotLegends->
          If[MatchQ[Lookup[safeOps,PlotLegends],Automatic],
            BarLegend[Automatic,LabelStyle -> Directive[Bold,Medium]],
            Lookup[safeOps,PlotLegends]
          ],
    		FrameLabel->
          If[MatchQ[Lookup[safeOps,FrameLabel],Automatic],
            {xLabel,yLabel},
            Lookup[safeOps,FrameLabel]
          ],
    		PlotLabel->
          If[MatchQ[Lookup[safeOps,PlotLabel],Automatic],
            Row[{
              Style["Error function for fitting to ",15],
              Tooltip[Style["the reactions",15],Column[Style[#,15]&/@rxs]]
            }],
            Lookup[safeOps,PlotLabel]
          ],
        FrameStyle ->
          If[MatchQ[Lookup[safeOps,FrameStyle],Automatic],
            Directive[Bold, Medium],
            Lookup[safeOps,FrameStyle]
          ],
        Output->{Result,Options}
      }
    ]
  ];

  (* Return ELCP and the associated options *)
	EmeraldListContourPlot[
		Transpose[{xTransformed,yTransformed,objVals[[;;,-1]]}],
    Sequence@@internalELCPOps
	]
];


plotKineticRatesObjectiveFunction[rxs_,objVals_,kvars_,safeOps_List]:=Module[{optimum,kvarPairs},
	kvarPairs = Subsets[Range[Length[kvars]],{2}] ;
	TabView[Map[kvars[[#]]->plotKineticRatesObjectiveFunction[rxs,objVals[[;;,Append[#,-1]]],kvars[[#]],safeOps]&,kvarPairs]]
];


(*
	makes a Point epilog for the GoodnessOfFit plot.  Log the values if needed
*)
optimumPointEpilog[pts_,{Log,Log},color_]:={PointSize[Large],color,Point[Log10/@#]}&/@pts;
optimumPointEpilog[pts_,{Log,Linear},color_]:={PointSize[Large],color,Point[{Log10[First[#]],Last[#]}]}&/@pts;
optimumPointEpilog[pts_,{Linear,Log},color_]:={PointSize[Large],color,Point[{First[#],Log10[Last[#]]}]}&/@pts;
optimumPointEpilog[pts_,{Linear,Linear},color_]:={PointSize[Large],color,Point[#]}&/@pts;

(*
	Log x and/or y data as needed
*)
transformForPlotType[{xVals_,yVals_},{kx_,ky_},{Linear,Linear}]:={{xVals,yVals},ToString[kx],ToString[ky]};
transformForPlotType[{xVals_,yVals_},{kx_,ky_},{Linear,Log}]:={{xVals,Log10[yVals]},ToString[kx],StringForm["Log10[ `` ]",ky]};
transformForPlotType[{xVals_,yVals_},{kx_,ky_},{Log,Linear}]:={{Log10[xVals],yVals},StringForm["Log10[ `` ]",kx],ToString[ky]};
transformForPlotType[{xVals_,yVals_},{kx_,ky_},{Log,Log}]:={{Log10[xVals],Log10[yVals]},StringForm["Log10[ `` ]",kx],StringForm["Log10[ `` ]",ky]};

(*
	resolve Rate option to list of values for each rate
*)
symbolicRateFormatP = Except[_List|_Rule|_Equilibrium|_?NumericQ|Automatic|Null];
resolvePlotKineticRatesRateOption[Automatic,pac_]:=resolvePlotKineticRatesRateOption[Analysis`Private`packetLookup[pac,Rates][[;;,1]],pac];
resolvePlotKineticRatesRateOption[rate:symbolicRateFormatP,pac_]:=resolvePlotKineticRatesRateOption[{rate},pac];
resolvePlotKineticRatesRateOption[rate:{symbolicRateFormatP,_?NumericQ,_?NumericQ},pac_]:=resolvePlotKineticRatesRateOption[{rate},pac];
resolvePlotKineticRatesRateOption[rate:{symbolicRateFormatP,_?NumericQ,_?NumericQ,Linear|Log},pac_]:=resolvePlotKineticRatesRateOption[{rate},pac];
resolvePlotKineticRatesRateOption[rate:{symbolicRateFormatP,_?NumericQ,_?NumericQ,_?NumericQ},pac_]:=resolvePlotKineticRatesRateOption[{rate},pac];
resolvePlotKineticRatesRateOption[rate:{symbolicRateFormatP,_?NumericQ,_?NumericQ,_?NumericQ,Linear|Log},pac_]:=resolvePlotKineticRatesRateOption[{rate},pac];
resolvePlotKineticRatesRateOption[rate:{symbolicRateFormatP,{_?NumericQ..}},pac_]:=resolvePlotKineticRatesRateOption[{rate},pac];
resolvePlotKineticRatesRateOption[rateOption_List,fittedRatePacket_]:=Module[{rateRules},
		rateRules = Rule@@@Analysis`Private`packetLookup[fittedRatePacket,Rates];
		Map[resolveOneRateOptionValue[#,rateRules,Length[rateOption]]&,rateOption]
];
(* if no range given, use even log-spaced sampling *)
resolveOneRateOptionValue[rate_,rateRules_,m_]:=With[{r=rate/.rateRules},resolveOneRateOptionValue[{rate,Sequence@@Sort[{r^(1/1.75),r^1.75}],Log},rateRules,m]];
(*  *)
resolveOneRateOptionValue[{rate_,min_,max_},rateRules_,m_]:=resolveOneRateOptionValue[{rate,Subdivide[min,max,Max[{5,Ceiling[20/m]}]]},rateRules,m];
resolveOneRateOptionValue[{rate_,min_,max_,Log},rateRules_,m_]:=resolveOneRateOptionValue[{rate,10^Subdivide[Log10[min],Log10[max],Max[{5,Ceiling[20/m]}]]},rateRules,m];
(* linear-spaced *)
resolveOneRateOptionValue[{rate_,min_,max_,num_Integer},rateRules_,m_]:=resolveOneRateOptionValue[{rate,Subdivide[min,max,num-1]},rateRules,m];
resolveOneRateOptionValue[{rate_,min_,max_,del_},rateRules_,m_]:=resolveOneRateOptionValue[{rate,Range[min,max,del]},rateRules,m];
(* log-spaced *)
resolveOneRateOptionValue[{rate_,min_,max_,num_Integer,Log},rateRules_,m_]:=resolveOneRateOptionValue[{rate,10^Subdivide[Log10[min],Log10[max],num-1]},rateRules,m];
resolveOneRateOptionValue[{rate_,min_,max_,del_,Log},rateRules_,m_]:=resolveOneRateOptionValue[{rate,10^Range[Log10[min],Log10[max],Log10[del]]},rateRules,m];
(* already list of values *)
resolveOneRateOptionValue[in:{rate:RateFormatP,_List},rateRules_,m_]:=in;
