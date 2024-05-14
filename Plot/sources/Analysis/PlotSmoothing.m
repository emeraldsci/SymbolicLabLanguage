(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section::Closed:: *)
(*PlotSmoothing*)


DefineOptions[PlotSmoothing,
	Options :> {

		(*** Image Format Options ***)
		ModifyOptions[ZoomableOption,Default->False,Category->"Image Format"],

		(*** PlotStyle Options ***)
		{
			OptionName->SymbolPointsShowCutoff,
			Description->"Specifies the number of data points below which the data will be shown with symbol points connected by lines.",
			Default->20,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				Widget[Type->Number,Pattern:>GreaterEqualP[0,1]]
			],
			Category->"Plot Style"
		},
		ModifyOptions[ListPlotOptions,
			{
				{OptionName->PlotMarkers,Default->Automatic},
				{OptionName->Frame,Default->True},
				{OptionName->Joined,Default->{True,True,True}}
			}
		],

		(*** Legend Options ***)
		ModifyOptions[LegendOption,
			{
				{
					OptionName->Legend,
					Default->
						{
							"Original or equal-spaced data points",
							"Smoothed data points",
							"Smoothing local standard deviations"
						}
				}
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
		EmeraldListLinePlot
	}
];


PlotSmoothing[myPacket0: PacketP[Object[Analysis, Smoothing]],ops: OptionsPattern[PlotSmoothing]]:=Module[
	{
    mpPacket,originalOps,safeOps,output,resolvedDataSet,smoothedDataSet,smoothingLocalStandardDeviation,
		objectID,resolvedPlotMarkers,resolvedPlotStyle,plot,resolvedELLPOps,resolvedOps,internalELLPOps
  },

	myPacket=Analysis`Private`stripAppendReplaceKeyHeads[myPacket0];

	(* Convert the original option into a list *)
  originalOps=ToList[ops];

  (* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
  safeOps=SafeOptions[PlotSmoothing,checkForNullOptions[originalOps]];

  (* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
  output=Lookup[safeOps,Output];

	(* The resolved coordinate set that were prepared for smoothing *)
  resolvedDataSet = Lookup[myPacket,ResolvedDataPoints];

	(* The smoothed coordinate set -- the result of smoothing analysis *)
  smoothedDataSet = Lookup[myPacket,SmoothedDataPoints];

	(* The local standard deviation of the difference between original and smoothed data points *)
  smoothingLocalStandardDeviation = Lookup[myPacket,SmoothingLocalStandardDeviation];

	resolvedSymbolPointsShowCutoff=Switch[Lookup[safeOps,SymbolPointsShowCutoff],
		GreaterEqualP[0,1],
		Lookup[safeOps,SymbolPointsShowCutoff],

		Automatic|Null,
		20
	];

	(* The markers used if the symbols need to be included for the original curve *)
  resolvedPlotMarkers=Switch[Lookup[safeOps,PlotMarkers],
		Automatic,
		If[Length[resolvedDataSet] <= resolvedSymbolPointsShowCutoff,
    	{{Automatic,Medium},None,None},
    	{None,None,None}
  	],

		_,
		Lookup[safeOps,PlotMarkers]
	];

	(* The style of the lines for all the three lines; original curve, smoothed curve, and local standard deviation *)
  resolvedPlotStyle=Switch[Lookup[safeOps,PlotStyle],
		(* If distribution use Automatic, otherwise thick and dashed for smooth curve and standard deviation respectively *)
		Automatic,
		If[MatchQ[resolvedDataSet,DistributionCoordinatesP|listOfQuantityDistributionsP],
    	Automatic,
    	{Automatic,{Thick},{Dashed}}
		],

		_,
		Lookup[safeOps,PlotStyle]
  ];

	(* The options to pass to ELLP *)
	internalELLPOps=ReplaceRule[Select[safeOps,(!MatchQ[Keys[#],SymbolPointsShowCutoff])&],
		{
			PlotStyle->resolvedPlotStyle,
			PlotMarkers->resolvedPlotMarkers
		}
	];

	(* retruning both the main results as well as the options *)
  {plot,resolvedELLPOps}=EmeraldListLinePlot[
    {resolvedDataSet,smoothedDataSet,smoothingLocalStandardDeviation},
		Sequence@@ReplaceRule[internalELLPOps,Output->{Result,Options}]
  ];

	(* All options including ELLP resolved options and PlotSmoothing specific options *)
	resolvedOps=Join[resolvedELLPOps,
		{
			SymbolPointsShowCutoff->resolvedSymbolPointsShowCutoff
		}
	];

	(* Return the result, options, or tests according to the output option. *)
	output/.{
		Result->plot,
		Preview->plot,
		Tests->{},
		Options->resolvedOps
	}

];

(* Multiple packets overload *)
PlotSmoothing[myPackets:{PacketP[Object[Analysis, Smoothing]]...},ops: OptionsPattern[PlotSmoothing]]:=Map[PlotSmoothing[#,ops]&,myPackets];
(* Objects overload *)
PlotSmoothing[myObject: ObjectP[Object[Analysis,Smoothing]]|ObjectReferenceP[Object[Analysis,Smoothing]]|LinkP[Object[Analysis,Smoothing]],ops: OptionsPattern[]]:=PlotSmoothing[Download[myObject],ops];
PlotSmoothing[myObjects: {ObjectP[Object[Analysis,Smoothing]]...},ops: OptionsPattern[PlotSmoothing]]:=PlotSmoothing[Download[myObjects],ops];
PlotSmoothing[myObjects: {ObjectReferenceP[Object[Analysis,Smoothing]]...},ops: OptionsPattern[PlotSmoothing]]:=PlotSmoothing[Download[myObjects],ops];
PlotSmoothing[myObjects: {LinkP[Object[Analysis,Smoothing]]...},ops: OptionsPattern[PlotSmoothing]]:=PlotSmoothing[Download[myObjects],ops];
