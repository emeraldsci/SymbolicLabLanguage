(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*PlotDNASequencingAnalysis*)

DefineOptions[PlotDNASequencingAnalysis,
	Options:>{
		(* Hide these ELLP options *)
		ModifyOptions[EmeraldListLinePlot,
			{
				AspectRatio,ImageSize,PlotRange,Zoomable,PlotRangeClipping,PlotStyle,ClippingStyle,ScaleX,ScaleY,
				Legend,LegendPlacement,Boxes,LegendLabel,Frame,FrameLabel,FrameUnits,FrameTicks,GridLines,GridLinesStyle,
				SecondYCoordinates,SecondYColors,SecondYRange,SecondYStyle,SecondYUnit,TargetUnits,
				ErrorBars,ErrorType,Reflected,Scale,Joined,InterpolationOrder,RotateLabel,LabelingFunction,
				PeakLabels,PeakLabelStyle,FractionColor,FractionHighlightColor,Tooltip,VerticalLine,
				Peaks,Fractions,FractionHighlights,Ladder,Prolog,Epilog,ColorFunction,ColorFunctionScaling
			},
			Category->"Hidden"
		],
		{
			OptionName->SequenceErrors,
			Default->Null,
			Description->"A list of base indices of {substitution, insertion, deletion} errors to highlight in the plot.",
			AllowNull->True,
			Widget->Widget[Type->Expression,Pattern:>{{GreaterP[0,1]...},{GreaterP[0,1]...},{GreaterP[0,1]...}},Size->Line],
			Category->"Hidden"
		}
	},
  SharedOptions:>{
		(* Inherit all other options from ELLP *)
		EmeraldListLinePlot
	}
];



(* ::Subsection::Closed:: *)
(*Command Builder Interface*)

(* For single object references and links, download the packet and pass to the next overload *)
PlotDNASequencingAnalysis[myObjects:ObjectReferenceP[Object[Analysis,DNASequencing]],myOptions:OptionsPattern[PlotDNASequencingAnalysis]]:=PlotDNASequencingAnalysis[Download[myObjects],myOptions];
PlotDNASequencingAnalysis[myObjects:LinkP[Object[Analysis,DNASequencing]],myOptions:OptionsPattern[PlotDNASequencingAnalysis]]:=PlotDNASequencingAnalysis[Download[myObjects],myOptions];

(* For a list matching ObjectP, download from object references and links, then pass the list to the listable packet overload*)
PlotDNASequencingAnalysis[
	myObjects:{ObjectP[Object[Analysis,DNASequencing]]...},
	myOptions:OptionsPattern[PlotDNASequencingAnalysis]
]:=PlotDNASequencingAnalysis[
	Download[myObjects],
	myOptions
]/;MemberQ[myObjects,ObjectReferenceP[Object[Analysis,DNASequencing]]|LinkP[Object[Analysis,DNASequencing]]];

(* Listable packet overloads  *)
PlotDNASequencingAnalysis[myPackets:{PacketP[Object[Analysis,DNASequencing]]|$Failed|Null},myOptions:OptionsPattern[PlotDNASequencingAnalysis]]:=PlotDNASequencingAnalysis[First[myPackets],myOptions];
PlotDNASequencingAnalysis[myPackets:{(PacketP[Object[Analysis,DNASequencing]]|$Failed|Null)..},myOptions:OptionsPattern[PlotDNASequencingAnalysis]]:=Module[
	{safeOptions,output,listedOutputs,results,previews,resOps},

	(* Convert options to a list *)
	safeOptions=SafeOptions[PlotDNASequencingAnalysis,ToList[myOptions]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOptions,Output];

	(* Collect results, previews, and options from each mapped call *)
	{results,previews,resOps}=Transpose@Map[
		PlotDNASequencingAnalysis[#,ReplaceRule[ToList[myOptions],{Output->{Result,Preview,Options}}]]&,
		myPackets
	];

	(* Return the selected outputs *)
	output/.{
		Result->results,
		Preview->SlideView[previews],
		Options->First[resOps],
		Tests->{}
	}
];

(* Single packet overload *)
PlotDNASequencingAnalysis[
	myPacket:PacketP[Object[Analysis,DNASequencing]],
	myOptions:OptionsPattern[PlotDNASequencingAnalysis]
]:=Module[
	{
		safePacket,originalOps,safeOptions,output,orderedTraces,
		untrimmedSeqPosBase,untrimmedQualityVals,trimmedSeqPosBase,
		plot,resolvedOps
	},

	(* Remove lingering Replace[] or Append[] syntax from myPacket *)
	safePacket=Analysis`Private`stripAppendReplaceKeyHeads[myPacket];

	(* Get the original options passed to the function *)
	originalOps=ToList[myOptions];

	(* Convert options to a list *)
	safeOptions=SafeOptions[PlotDNASequencingAnalysis,originalOps];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOptions,Output];

	(* Download the raw traces from the data in alphabetical order by base *)
	orderedTraces=Lookup[safePacket,
		{
			SequencingElectropherogramTraceA,
			SequencingElectropherogramTraceC,
			SequencingElectropherogramTraceG,
			SequencingElectropherogramTraceT
		}
	];

	(* Get pairs of peak position and sequence bases prior to trimming for the plot *)
	untrimmedSeqPosBase=Transpose@Lookup[safePacket,{UntrimmedSequencePeakPositions,UntrimmedSequenceBases}];

	(* Untrimmed quality values *)
	untrimmedQualityVals=Lookup[safePacket,UntrimmedQualityValues];

	(* Get pairs of peak position and sequence bases aftertrimming for the plot *)
	trimmedSeqPosBase=Transpose@Lookup[safePacket,{SequencePeakPositions,SequenceBases}];

	(* Generate plots by passing to the hidden overload for sequencing intermediates *)
	{plot,resolvedOps}=PlotDNASequencingAnalysis[
		orderedTraces,
		untrimmedSeqPosBase,
		untrimmedQualityVals,
		trimmedSeqPosBase,
		ReplaceRule[safeOptions,{Output->{Result,Options}}]
	];

	(* Return the requested output *)
	output/.{
		Result->plot,
		Preview->plot,
		Options->resolvedOps,
		Tests->{}
	}
];

(* Error state *)
PlotDNASequencingAnalysis[$Failed|Null,ops:OptionsPattern[PlotDNASequencingAnalysis]]:=Module[
	{safeOptions,output},

	(* Populate default options *)
	safeOptions=SafeOptions[PlotDNASequencingAnalysis,ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOptions,Output];

	(* Return appropriate fail states  *)
	output/.{
		Result->$Failed,
		Preview->Null,
		Options->safeOptions,
		Tests->{}
	}
];



(* ::Subsection::Closed:: *)
(*Core Function*)

(* Null preview if no peaks were called *)
PlotDNASequencingAnalysis[data_,{},{},{},___]:=Null;
PlotDNASequencingAnalysis[data_,calledPks_,qualityVals_,trimmedCalledPks_,plotOps:OptionsPattern[PlotDNASequencingAnalysis]]:=Module[
	{
		listedOps,output,qualityColor,unitlessData,xmax,ymax,avgSpacing,first50Calls,windowSize,numWindows,
		imgSize,baseLineEpilogs,baseLetterEpilogs,qualityTextEpilogs,sequenceErrors,basePositions,
		qualityEpilogs,trimEpilogs,errorEpilogs,customTicks,widePlot,paneGraphic,finalPlot,ellpOps
	},

	(* Ensure the options are in a list *)
	listedOps=ToList[plotOps];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[listedOps,Output,Result];

	(* Map quality value to the color of the bar it should appear as *)
	qualityColor[qv_Integer]:=Switch[qv,
		_?(#>20&),Darker@Green,
		_?(#>14&),RGBColor[1.,0.82,0.02],
		_,Gray
	];

	(* Strip units for performance. Data is assumed to be in A,C,G,T order *)
	unitlessData=Unitless[data];

	(* The maximum signal value among all four electropherograms *)
	xmax=Max[Max[First/@#]&/@unitlessData];
	ymax=Max[Max[Last/@#]&/@unitlessData];

	(* Average spacing between called peaks *)
	avgSpacing=Mean@Differences[First/@calledPks];

	(* X-values of the first 100 calls *)
	first50Calls=First/@Part[calledPks,;;Min[50,Length[calledPks]]];

	(* Show about 80 bases per horizontal screen *)
	windowSize=Last[first50Calls]-First[first50Calls];
	numWindows=(xmax/windowSize);
	imgSize=1200*numWindows;

	(* Create vertical dotted lines for each base assignment *)
	baseLineEpilogs=Map[
		Style[
			Line[{{First[#],-0.025*ymax},{First[#],1.0*ymax}}],
			Directive[Dashed,baseColor[Last[#]]]
		]&,
		calledPks
	];

	(* Create letter labels for each of the base line epilogs *)
	baseLetterEpilogs=Map[
		Text[
			Style[Last[#],14,baseColor[Last[#]]],
			{First[#],-0.11*ymax}
		]&,
		calledPks
	];

	(* Create little bars for each quality value *)
	qualityTextEpilogs=MapThread[
		Text[
			Style[#2,10,Lighter@Gray],
			{First[#1],1.06*ymax}
		]&,
		{calledPks,qualityVals}
	];

	(* Create little bars for each quality value *)
	qualityEpilogs=MapThread[
		Style[
			Rectangle[
				{First[#1]-windowSize/800.0,1.12*ymax},
				{First[#1]+windowSize/800.0,(1.12+0.15*Min[#2/40.0,1.0])*ymax}
			],
			qualityColor[#2]
		]&,
		{calledPks,qualityVals}
	];

	(* Shade trimmed regions in transparent gray *)
	trimEpilogs={
		Style[
			Rectangle[
				{0,-0.20*ymax},
				{Min[First/@trimmedCalledPks]-avgSpacing/2.0,1.3*ymax}
			],
			Directive[Gray,Opacity[0.3]]
		],
		Style[
			Rectangle[
				{Max[First/@trimmedCalledPks]+avgSpacing/2.0,-0.20*ymax},
				{1.1*Max[First/@calledPks],1.3*ymax}
			],
			Directive[Gray,Opacity[0.3]]
		]
	};

	(* Value of the SequenceErrors option, defaulting to Null if not present *)
	sequenceErrors=Lookup[listedOps,SequenceErrors,Null];

	(* The positions, in units of cycle reads, of each called peak *)
	basePositions=First/@calledPks;

	(* Highlight substitution/insertion/deletion errors *)
	errorEpilogs=If[MatchQ[sequenceErrors,Null],
		{},
		Join@@MapThread[
			Function[{indices,color},
				Style[
					Rectangle[{basePositions[[#]]-avgSpacing/2.0,-0.20*ymax},{basePositions[[#]]+avgSpacing/2.0,1.3*ymax}],
					Directive[color,Opacity[0.3]]
				]&/@indices
			],
			{sequenceErrors,{Orange,Darker@Green,Red}}
		]
	];

	(* Custom tick marks to denote the position of each called base *)
	customTicks=MapIndexed[
		If[Mod[First[#2],5]===0,
			{#1,First[#2],{4.2/imgSize,0.0}},
			{#1,"",{1.0/imgSize,0.0}}
		]&,
		basePositions
	];

	(* Generate the graphic - makle it very wide *)
	{widePlot,ellpOps}=EmeraldListLinePlot[
		unitlessData,
		ReplaceRule[
			DeleteCases[listedOps,Rule[SequenceErrors,_]],
			{
				Epilog->Join[baseLineEpilogs,baseLetterEpilogs,qualityTextEpilogs,qualityEpilogs,trimEpilogs,errorEpilogs],
				PlotStyle->baseColor[{"A","C","G","T"}],
				PlotRange->{All,{-0.10*ymax,1.15*ymax}},
				AspectRatio->225.0/(imgSize),
				ImageSize->imgSize,
				Frame->{{True,True},{True,False}},
				FrameLabel->{{"Fluorescence Intensity (RFU)",None},{None,None}},
				FrameTicks->{{Automatic,Automatic},{customTicks,None}},
				Output->{Result,Options}
			}
		]
	];

	(* Wrap the whole thing in a Pane with a horizontal scrollbar*)
	paneGraphic=Framed[
		Pane[widePlot,Scrollbars->{True,False},ImageSize->Full],
		FrameStyle->White
	];

	(* Use grid to add an x-axis label which does not scroll *)
	finalPlot=Grid[{
		{paneGraphic},
		{Style["Base Index",Directive[14,RGBColor[{0.33,0.33,0.33}],Bold,FontFamily->"Arial"]]}
	}];

	(* Return the requested output *)
	output/.{
		Result->finalPlot,
		Preview->finalPlot,
		Options->ellpOps,
		Tests->{}
	}
];


(* ::Subsection::Closed:: *)
(*Miscellaneous Helper Functions*)

(* Define the canonical color for each base *)
baseColor[bases:{_String..}]:=baseColor/@bases;
baseColor[base_String]:=Switch[base,
	"A",ColorData[97][2],
	"C",ColorData[97][4],
	"G",ColorData[97][1],
	"T",ColorData[97][3],
	"N",Gray
];
