(* ::Package:: *)

(* ::Section:: *)
(*Options*)


   
DefineOptions[AnalyzeFractions,
	Options :> {
		IndexMatching[
			{
				OptionName -> OverlappingPeaks,
				Default -> Automatic,
				Description -> "Selects fractions that overlap with the largest peaks. If OverlappingPeaks is Null, all fractions are returned. The TopPeaks option determines how many of the largest peaks will be used.",
				ResolutionDescription -> "Automatic will use Peaks in Object[Analysis,Peaks] from the input data object.",
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Object[Analysis,Peaks]]]
			},
			{
				OptionName -> TopPeaks,
				Default -> 0,
				Description -> "Determines which peaks will be used in the first step of fraction filtering. If TopPeaks ->n_Integer, then the n largest peaks (by area) will be used.",
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Number, Pattern :> GreaterEqualP[0, 1]],
					Widget[Type -> Enumeration, Pattern :> Alternatives[All]]
				]
			},
			{
				OptionName -> Domain,
				Default -> Automatic,
				Description -> "Automatically exclude any fractions not fully inside specified domain interval.",
				AllowNull -> False,
				Widget -> {
					"Min" -> Widget[Type -> Quantity, Pattern :> RangeP[-Infinity Second, Infinity Second], Units -> Alternatives[Second, Minute, Hour]],
					"Max" -> Widget[Type -> Quantity, Pattern :> RangeP[-Infinity Second, Infinity Second], Units -> Alternatives[Second, Minute, Hour]]
				}
			},
			{
				OptionName -> Include,
				Default -> Null,
				Description -> "Explicitly specify fractions to select. Fractions can be specified as a fraction {startTime,endTime,well}, as a position index in the FractionsCollected list, or as a time point between the startTime and endTime.",
				AllowNull -> True,
				Widget -> Adder[
					Widget[Type -> Expression, Pattern :> {}|_?NumberQ | _?TimeQ | _Integer | {_?NumericQ, _?NumericQ, _String} | _Span, Size -> Line]
				]
			},
			{
				OptionName -> Exclude,
				Default -> Null,
				Description -> "Explicitly specify fractions to exclude.  Fractions can be specified as a fraction {startTime,endTime,well}, as a position index in the FractionsCollected list, or as a time point between the startTime and endTime.",
				AllowNull -> True,
				Widget -> Alternatives[
					Adder[Widget[Type -> Expression, Pattern :> {}|_?NumberQ | _?TimeQ | _Integer | {_?NumericQ, _?NumericQ, _String} | _Span , Size -> Line]],
					Widget[Type -> Enumeration, Pattern :> Alternatives[All]]
				]
			},
			IndexMatchingInput->"Input Data"
		],
		AnalysisTemplateOption,
		OutputOption,
		UploadOption
	}
];

(* need this to trigger lazy-loading for clump definition, for now *)
Options[AnalyzeFractions];


Clump[{
	SaveAs -> "AnalyzeFractions",
	InheritFrom -> "AnalyzeFunction",
	Clumplate->True,
	FunctionName->AnalyzeFractions,
  	(*
     	INPUTS
  	*)
	Definitions -> {
		{{{ObjectP[Object[Data, Chromatography]]..}}, {InputChromatographyDataList} , Out },
		{{ObjectP[Object[Data, Chromatography]]} ,{InputChromatographyData},  OutSingle },
		{{ObjectP[Object[Analysis, Fractions]]}, {InputExistingFractionsObjectList} , Out },
		{{ObjectP[Object[Analysis, Fractions]]}, {InputExistingFractionsObject} , OutputSingle },
		{{ObjectP[Object[Protocol, HPLC]] | ObjectP[Object[Protocol, FPLC]]}, {InputChromatographyProtocol}, Out}
	},
	{ChromatographyData, ChromatogramCoordinates, FractionLabels, OverlappingPeaks} :> Module[
		{datas},
		datas = Which[
			$This[InputChromatographyData]=!=Undefined,
				{$This[InputChromatographyData]},
			$This[InputChromatographyDataList]=!=Undefined,
				$This[InputChromatographyDataList],
			$This[InputExistingFractionsObjectList]=!=Undefined,
				Download[Download[$This[InputExistingFractionsObjectList],Reference[[-1]]],Object],
			$This[InputChromatographyProtocol]=!=Undefined,
				Cases[Download[fd,Data[Object]],ObjectReferenceP[Object[Data,Chromatography]]],
			True,
				Echo["Shouldn't be here"]
		];
		Transpose[Download[
			datas,
			{
				Object, 
				Absorbance,
				SamplesOut[Object],
				Packet[AbsorbancePeaksAnalyses[[-1]][PeaksFields]]
			}
		]]
	], 
	OutSingle :> If[MatchQ[$This[Output],{Result,___}],First[$This[Out]],$This[Out]],

	(* things derived from inputs *)
  	DataReference :> Download[$This[ChromatographyData],Object],

	ChromatogramClump -> Clump[{
		InheritFrom -> "CoordinatesListXY",
		Coordinates :> $This["Parent","ChromatogramCoordinates"]
	}],
	
	
   	(*
      OPTIONS
   	*)
	DomainResolved :> MapThread[(Replace[#1,All|Automatic->#2])&,{$This[DefaultedOptions]["Domain"],$This[ChromatogramClump, Domain]}], 
	DomainUnitless :> ReplaceAll[$This[Domain],q_Quantity:>Unitless[q,Minute]],
	Domain :> $This[DomainResolved], (* has units *)

	TopPeaks:> $This[DefaultedOptions]["TopPeaks"], 
	Include :> $This[DefaultedOptions]["Include"], 
	Exclude:>MapThread[Replace[#1,All->Range[Length[#2]]]&,{$This[DefaultedOptions]["Exclude"],$This[FractionsCollected]}], 
	Upload :> $This[DefaultedOptions]["Upload"],
	Template :> $This[DefaultedOptions]["Template"],
	Output :> $This[DefaultedOptions]["Output"],


 	FractionBoxColors :> Map[Function[ind,Map[If[MemberQ[$This[FractionsPicked,{ind}],#],Green,Red]&,$This[FractionsCollected,{ind}]]],$This[Indices]],
	
 
  	PlotLabel :> Map[ToString[# /. Null -> ""]&,$This[DataReference]],
  	PlotRange :> Map[ReplaceAll[PlotRange,AbsoluteOptions[#,PlotRange]]&,$This[StaticFigure]],
  	(* never changes unless inputs change *)
  
  	FractionsInDomain :> calcFractionsInDomain@@@Transpose[{$This[FractionsCollected],$This[DomainUnitless]}],
  
   	FractionsPicked :> MapThread[calcFractionsPicked[#1,#2,#3,#4,#5,#6,{}]&,{$This[FractionsCollected], $This[Domain], $This[OverlappingPeaks], $This[TopPeaks],$This[Include],$This[Exclude]}],

  	Packet :> MapThread[constructPacket[#1,#2,#3,#4,$This[ResolvedOptions]]&,{$This[Indices], $This[FractionsCollected], $This[FractionsPicked], $This[ChromatographyData]}],
 
  	FractionsCollected :> Map[
		Lookup[Lookup[Download[#],Fractions,<||>],{CollectionStartTime,CollectionEndTime,Position}, $Failed]&,
		$This[ChromatographyData]
	],
	FractionsCollectedRawMinutes :> ReplaceAll[$This[FractionsCollected],q_Quantity:>Unitless[q,"Minutes"]],
  
	TemplateFractionsPicked->{},
  
	(* how to automate this?? need $This[field] explicitly for parsability *)
	ResolvedOptions :> ReduceOptions[$This[FunctionName],$This[IndexLength],{Domain->$This[Domain], TopPeaks -> $This[TopPeaks], OverlappingPeaks -> $This[OverlappingPeaks], Include->$This[Include], Exclude->$This[Exclude], Upload->$This[Upload], Output -> $This[Output], Template->$This[Template]}],

	(*
		PREVIEW PIECES
	*)
	StaticFigure :> MapThread[makeChromatogramFigure[#1,#2,#3,#4]&,{$This[FractionsCollected], $This[ChromatogramClump,Coordinates], $This[OverlappingPeaks],$This[PlotLabel]}],
	<|
		Name->DynamicPrimitives,
		Static->True,
		Expression :> With[{
			xMinMaxL=ClumpGet[$This,ChromatogramClump, DomainMagnitudes],
			yMinMaxL=ClumpGet[$This,ChromatogramClump, RangeMagnitudes], 
			fracsCollectedL=ClumpGet[$This,FractionsCollectedRawMinutes], 
			plotRangeL=ClumpGet[$This,PlotRange],
			fractionLabelsL = ClumpGet[$This,FractionLabels],
			 ydiffL=ClumpGet[$This,ChromatogramClump, RangeMagnitudes].{-1,1}
		},Map[Function[ind,With[
		{xMinMax=xMinMaxL[[ind]], yMinMax=yMinMaxL[[ind]], fracsCollected = fracsCollectedL[[ind]], plotRange = plotRangeL[[ind]],
			fractionLabels = fractionLabelsL[[ind]], ydiff=ydiffL[[ind]]},
		{
			Line[{{ClumpDynamic[$This,DomainUnitless,{ind,1} ],First[yMinMax]-ydiff},{ClumpDynamic[$This,DomainUnitless,{ind,1} ],Last[yMinMax]+ydiff}}],
			Line[{{ClumpDynamic[$This,DomainUnitless,{ind,2} ],First[yMinMax]-ydiff},{ClumpDynamic[$This,DomainUnitless,{ind,2} ],Last[yMinMax]+ydiff}}],
			 Map[
				With[{fracRectanglePrimitive = {
					Opacity[0.3],
					ClumpDynamic[$This,FractionBoxColors,{ind,#}],
					Rectangle[
						{fracsCollected[[#,1]], yMinMax[[1]] - (yMinMax[[2]]-yMinMax[[1]])}, 
						{fracsCollected[[#,2]], yMinMax[[2]] + (yMinMax[[2]]-yMinMax[[1]])}
					]
				}},
				Mouseover[
					fracRectanglePrimitive,
					Append[
						fracRectanglePrimitive,
						Text[
							Style[
								fractionLabels[[#]], Black, Opacity[1], 
								14, Bold, FontFamily -> "Arial", 
								Background -> Directive[White, Opacity[0.75]]
							], 
							{Mean[{fracsCollected[[#,1]], fracsCollected[[#,2]]}], Mean[yMinMax]}
						]
					]
				]]&,
				Range[Length[fracsCollected]]
			]
			
		}
	]],$This[Indices]]]
	|>,
	<|
		Name->EventActions,
		Remember->True,
		Expression :> Map[Function[ind,{
		{"MouseClicked",1}:>Module[{mp=MousePosition["Graphics"],clickedFrac,clickedInd,
			fracsCollected = $This[FractionsCollectedRawMinutes,{ind}]},
						Which[
							mp===None,
								Null,
							CurrentValue["ShiftKey"]===True,
								(
									(* get index of clicked fraction so we can add/remove it to/from include or exclude lists *)
									clickedFrac = SelectFirst[fracsCollected,Between[First[mp],Most[#]]&];
									clickedInd = FirstPosition[fracsCollected,clickedFrac];
									If[MatchQ[clickedInd,_Missing], Return[Null]];
									clickedInd = First[clickedInd];
									Which[
										(* if already picked... *)
										MemberQ[Unitless@ClumpGet[$This,FractionsPicked,{ind}],clickedFrac],
											(* ... then remove it from Include, add to Exclude *)
											LogPreviewChanges[$This, {
												"Include"->Replace[DeleteCases[Replace[ClumpGet[$This,Include,{ind}],Null->{}],clickedInd],{}->Null],
												"Exclude" -> Append[Replace[ClumpGet[$This,Exclude,{ind}],Null->{}],clickedInd]
											},ind], 
										(* if not already picked... *)
										True,
											(* ... then remove it from Exclude, add to Include *)
											LogPreviewChanges[$This, {
												"Exclude"->Replace[DeleteCases[Replace[ClumpGet[$This,Exclude,{ind}],Null->{}],clickedInd],{}->Null],
												"Include" -> Append[Replace[ClumpGet[$This,Include,{ind}],Null->{}],clickedInd]
											}, ind]
									]
								),
							True,
								LogPreviewChanges[
									$This,
									{"Domain"->{
										(* here is where I put the units back on *)
										(* new xmin *)Quantity[First[mp],"Minutes"],
										(* here I use Domain (and not DomainUnitless) because CB wants units on it *)
										(* old xmax *)ClumpGet[$This,Domain,{ind,2}]
										}
									},
									ind
								];
						]
					],
					{"MouseClicked",2}:>With[{mp=MousePosition["Graphics"]},
						If[mp=!=None,
							LogPreviewChanges[$This,{"Domain"->{ClumpGet[$This,Domain,{ind,1}],Quantity[First[MousePosition["Graphics"]],"Minutes"]}},ind];
						]
					]
	}],$This[Indices]]
	|>

}
];
Clump["AnalyzeFractions"]["WriteDefinitions"];


(* ::Subsubsection:: *)
(*FractionsPicked*)


calcFractionsPicked[fracsCollected_, domain_, overlappingPeaks_, topPeaks_, include0_, exclude0_, templateFracsPicked_]:= Module[{resolvedFracsPicked, fracsOutsideDomain,fracsToExclude,fracsToInclude,findFractionsOutsideRange,findFractionsInsideRange,includedAlready, includedOutside, in, include = include0,exclude = exclude0},
	resolvedFracsPicked = resolvePickedFractions[fracsCollected, templateFracsPicked, overlappingPeaks, topPeaks];
	(* filter fractions outside range *)
	findFractionsOutsideRange[range:((List|Span)[_?TimeQ,_?TimeQ])]:=findFractionsOutsideRange[Unitless[#,Minute]&/@range];
	findFractionsOutsideRange[frac:FractionP]:=findFractionsOutsideRange[Most[frac]];
	findFractionsOutsideRange[range:((List|Span)[_?NumericQ,_?NumericQ])]:=Select[fracsCollected,!overlappingIntervalQ[Most[#],Span@@range]&];
	findFractionsOutsideRange[_]:={};
	findFractionsOutsideRange[{val_}]:=findFractionsOutsideRange[val];
	fracsOutsideDomain = findFractionsOutsideRange[domain];

	findFractionsInsideRange[frac:FractionP]:= findFractionsInsideRange[{Most[frac][[1]] Minute, Most[frac][[2]] Minute}];
	(*for a list or span with time units*)
	findFractionsInsideRange[range:((List|Span)[_?TimeQ,_?TimeQ])]:= Sequence@@Select[fracsCollected,overlappingIntervalQ[Most[#],Span@@(N@Unitless[range,Minute])]&];
	(*for a list or span with fraction indicies*)
	findFractionsInsideRange[range:((List|Span)[GreaterP[0, 1],GreaterP[0, 1]])]:= Module[{},

		(* If left index of span is higher than the number of fractions collected, return Null*)
		If[range[[1]]>Length[fracsCollected],
			Message[Warning::InvalidPosition,range[[1]],Length[fracsCollected]];
			Return[Null]
		];

		(* Otherwise we want to go start from the left index and take all fractions in the span *)
		If[range[[2]]>Length[fracsCollected],
			Message[Warning::InvalidPosition,range[[2]],Length[fracsCollected]];
			(*take it to the end*)
			Sequence@@fracsCollected[[range[[1]];;-1]],
			(*otherwise take the selected span*)
			Sequence@@fracsCollected[[range]]
		]
	];

	findFractionsInsideRange[pos_Integer]:=If[pos>Length[fracsCollected],
		Message[Warning::InvalidPosition,pos,Length[fracsCollected]],
		fracsCollected[[pos]]
	];
	findFractionsInsideRange[range:((List|Span)[_?NumericQ,_?NumericQ])]:= Message[Error::FractionalIndexes];
	findFractionsInsideRange[range_?NumericQ]:= Message[Error::FractionalIndexes];
	findFractionsInsideRange[range:((List|Span)[_?QuantityQ,_?QuantityQ])]:= Message[Error::UnexpectedUnits, {Units[range[[1]]], Units[range[[2]]]}];
	findFractionsInsideRange[range_?TimeQ]:= Sequence@@Select[fracsCollected,overlappingIntervalQ[Most[#],N@Unitless[range,Minute]]&];
	findFractionsInsideRange[{val_}]:=findFractionsInsideRange[val];
	(* clean up include/exclude options *)
		exclude = DeleteCases[DeleteDuplicates[ToList[(exclude)/.Null->{}],Except[FractionP,_List]],Null,{1}];
	
	include = DeleteCases[DeleteDuplicates[ToList[(include)/.Null->{}],Except[FractionP,_List]],Null,{1}];
	fracsToExclude = DeleteCases[findFractionsInsideRange/@exclude,Null];
	fracsToInclude = DeleteCases[findFractionsInsideRange/@include,Null];
	
	(*Message that included options are outside the domain*)
	If[Length[Intersection[fracsOutsideDomain, fracsToInclude]]>0,
		(*Included fractions outside of domain*)
		includedOutside = Intersection[fracsOutsideDomain, fracsToInclude];

		(*Find index of included outside of domain fractions*)
		Message[Warning::IncludeOutsideDomain, Flatten[Position[fracsCollected, #] & /@ includedOutside]]
	];

	(*Message that included options have no effect*)
	If[Length[Intersection[fracsToInclude, Complement[resolvedFracsPicked, fracsToExclude, fracsOutsideDomain]]]>0,
		(*Included fractions outside of domain*)
		includedAlready = Intersection[fracsToInclude, Complement[resolvedFracsPicked, fracsToExclude, fracsOutsideDomain]];
		(*Find index of included outside of domain fractions*)
		Message[Warning::IncludeHasNoEffect, Flatten[Position[fracsCollected, #] & /@ includedAlready]]
	];
	(* first remove things outside domain,
	then exclude things from Exclude list,
	then include things from Include list *)
	With[
		{
			fractionsExcludedOrOutsideRange = Join[fracsOutsideDomain,fracsToExclude]
		},
		Union[
			Complement[resolvedFracsPicked,fractionsExcludedOrOutsideRange],
			fracsToInclude
		]
	]
		
		
		];


(* Resolve Null or empty fracsPicked *)
resolvePickedFractions[fracsCollected:{FractionP..},fracsPicked:{FractionP..},overlappingPeaks_,topPeaks_]:=fracsPicked;
resolvePickedFractions[fracsCollected:{FractionP...},Null,overlappingPeaks_,topPeaks_]:=fracsCollected;
resolvePickedFractions[fracsCollected:{FractionP...},{},overlappingPeaks_,topPeaks_]:=Module[{fracsPeaks,pkLength,numPeaksToUse,getPeakLength,getNumberOfPeaksToUse,getFractionsFromOverlappingPeaks},

	(* number of peaks *)
	getPeakLength[peakList_Association]:=Length[peakList[Position]];
	getPeakLength[_]:=0;
	pkLength = getPeakLength[overlappingPeaks];

	(* number of peaks to use *)
	getNumberOfPeaksToUse[All|(_Integer?(#>pkLength&))]:=pkLength;
	getNumberOfPeaksToUse[numPeaks_Integer?(#<=pkLength&)]:=numPeaks;
	getNumberOfPeaksToUse[_]:=0;
	numPeaksToUse = getNumberOfPeaksToUse[topPeaks];

  (* take things overlapping with peaks *)
  (* default is no fractions*)
  getFractionsFromOverlappingPeaks[Null,_]:={};
  getFractionsFromOverlappingPeaks[_,0]:={};
  getFractionsFromOverlappingPeaks[peakList:_Association,numPeaks_Integer]:=
    Module[{peakRange, clippedPeaks,order},
	    order = Reverse[Ordering[peakList[Area]]];
      clippedPeaks = {Take[peakList[PeakRangeStart][[order]],numPeaks],Take[peakList[PeakRangeEnd][[order]],numPeaks]};
      peakRange = Transpose[clippedPeaks];

      Select[fracsCollected,overlappingIntervalQ[Most[#],Span@@@peakRange]&]
    ];

	getFractionsFromOverlappingPeaks[overlappingPeaks,numPeaksToUse]
];


(* check of two intervals overlap *)
overlappingIntervalQ[{a_?NumberQ,b_?NumberQ},{}]:=False;
(*overlappingIntervalQ[{a_?NumberQ,b_?NumberQ},{c_?NumberQ,d_?NumberQ}]:=Or[a<=c<b,a<=d<b,c<=a<d];*)
overlappingIntervalQ[{a_?NumberQ,b_?NumberQ},Span[c_?NumberQ,d_?NumberQ]]:=Or[a<=c<b,a<=d<b,c<=a<d];
overlappingIntervalQ[{a_?NumberQ,b_?NumberQ},intervals:{{_?NumberQ,_?NumberQ}|Span[_?NumberQ,_?NumberQ]..}]:=Or@@Map[overlappingIntervalQ[{a,b},#]&,intervals];
overlappingIntervalQ[{a_?NumberQ,b_?NumberQ},c_?NumberQ]:=(a<=c<b);
overlappingIntervalQ[{a_?NumberQ,b_?NumberQ},list:{_?NumberQ..}]:=Or@@Map[overlappingIntervalQ[{a,b},#]&,list];

overlappingFraction[fracs:{{_?NumberQ,_?NumberQ,_String}..},c_?NumberQ]:=FirstOrDefault[Select[fracs,overlappingIntervalQ[#[[1;;2]],c]&]];



(* ::Subsection:: *)
(*Inputs*)


(* ::Subsection:: *)
(*Packet*)

samplesPickedFromFractions[samplesCollected_,fractionsCollected_,fractionsPicked_]:=Module[
	{pickedFractionsIndices, findPickedFractionsIndicesFromCollectedFractions},
	findPickedFractionsIndicesFromCollectedFractions[fractionList:{FractionP..}] := (First[Cases[Position[fractionsCollected, #1], _Integer, {2}]] & ) /@ fractionList;
	findPickedFractionsIndicesFromCollectedFractions[_] := {};
	pickedFractionsIndices = findPickedFractionsIndicesFromCollectedFractions[fractionsPicked];
	If[Length[samplesCollected] =!= Length[fractionsCollected],
		{},
		samplesCollected[[pickedFractionsIndices]]
	]
]


resolveFractionsInputLinks[fracsCollected:{FractionP..},fracsPicked:{{Null,Null,Null}}]:=Null;
resolveFractionsInputLinks[fracsCollected:{FractionP..},fracsPicked:Null]:={Null};
resolveFractionsInputLinks[fracsCollected:{FractionP..},fracsPicked:{FractionP...}]:=Null;
resolveFractionsInputLinks[fracsCollected:{FractionP..}]:=Null;
resolveFractionsInputLinks[fracsObj:ObjectP[Object[Analysis, Fractions]]]:=resolveFractionsInputLinks[Download[Last[Download[fracsObj,Reference]],Object]];
resolveFractionsInputLinks[obj:ObjectReferenceP[Object[Data,Chromatography]]]:=obj;
resolveFractionsInputLinks[link:LinkP[]]:=link[Object];
resolveFractionsInputLinks[inf: PacketP[Object[Data,Chromatography]]] := Object/. inf;


(* ::Subsection:: *)
(*Outputs*)


makeChromatogramFigure[fracsCollected_, chromatogram_, defPeaks_, plotLabel_]:=Which[
		(* no fractions, no chromatograph *)
		And[fracsCollected==={},chromatogram===Null],
			Unzoomable[ECL`PlotChromatography[{{0,0.},{1,0.}}, PlotLabel -> plotLabel]],
		(* no fractions, yes chromatograph *)
		fracsCollected==={},
			Unzoomable[ECL`PlotChromatography[chromatogram, PlotLabel -> plotLabel]],
		(* yes fractions, no chromatograph *)
		chromatogram===Null,
			Unzoomable[ECL`PlotChromatography[{{Min[fracsCollected[[All,1]]],0.},{Max[fracsCollected[[All,2]]],0.}}, PlotLabel -> plotLabel]],
		(* fractions & chromatograph *)
		True,
			Unzoomable[ECL`PlotChromatography[chromatogram,Display -> {Peaks},Peaks->defPeaks, PlotLabel -> plotLabel]]
	]




constructPacket[ind_,fractionsCollected_, fractionsPicked_,chromData_,resolvedOps_]:=Module[
	{inputLink, prot,sampleIn, fracPacket, samplesCollected, samplesPicked},

	inputLink = resolveFractionsInputLinks[chromData];

	sampleIn = FirstOrDefault[Download[inputLink,SamplesIn]];
	sampleIn = If[MatchQ[sampleIn, ObjectP[]], Download[sampleIn,Object], {}];

	fracPacket = Association[Join[
		{Type -> Object[Analysis, Fractions]},
		{
			ResolvedOptions -> resolvedOps,
			Replace[Reference]->{Link[inputLink, FractionPickingAnalysis]},
			Replace[FractionsPicked]->Replace[fractionsPicked,{}->{{Null,Null,Null}}],
			FractionsCollected :> Evaluate[fractionsCollected],
			Replace[FractionatedSamples]->{Link[sampleIn]}
		}
	]
  ];

	samplesCollected = Download[inputLink, SamplesOut];

	samplesPicked = samplesPickedFromFractions[samplesCollected,fractionsCollected,fractionsPicked];

	If[Length[samplesPicked] > 0,
		fracPacket[Replace[SamplesPicked]] = Map[Link[#[Object]]&,samplesPicked],
		fracPacket[Replace[SamplesPicked]] = {}
	];

	fracPacket
  ]
  
calcFractionsInDomain[collected_, domain_]:= Module[{t1,t2,w},
	Select[
        collected, 
        (
   	    {t1,t2,w} = #;
        And[Between[t1,domain], Between[t2,domain]]
        )&
    ]
]
  