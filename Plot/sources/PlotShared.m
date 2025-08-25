(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*Option Resolution*)


(* ::Subsubsection::Closed:: *)
(*FindPlotRange*)


DefineOptions[FindPlotRange,
	Options :> {
		{ScaleX -> 1, _?NumericQ, "Factor by which to scale the x-axis."},
		{ScaleY -> 1.025, _?NumericQ, "Factor by which to scale the y-axis."}
	}];


FindPlotRange[rawPlotRange:(Full|All|Automatic|NumberP)|{{(Full|All|Automatic|NumberP),(Full|All|Automatic|NumberP)}|(Full|All|Automatic),{(Full|All|Automatic|NumberP),(Full|All|Automatic|NumberP)}|(Full|All|Automatic)},plotData:{NumberP..},ops:OptionsPattern[FindPlotRange]]:=Module[{xPositions,dataPositions},

	(* This assumes that the length of the list is the span of x values starting at index 1 *)
	(*all thats needs to be done is these need to turned into x,y pairs*)

	xPositions=Table[i,{i,1,Length[plotData]}];
	dataPositions=MapThread[{#1, #2}&, {xPositions, plotData}];

	FindPlotRange[rawPlotRange, dataPositions, ops]

];

(*takes in CoordinatesP datapoints*)
FindPlotRange[rawPlotRange:(Full|All|Automatic|NumberP)|{{(Full|All|Automatic|NumberP),(Full|All|Automatic|NumberP)}|(Full|All|Automatic),{(Full|All|Automatic|NumberP),(Full|All|Automatic|NumberP)}|(Full|All|Automatic)},plotData:CoordinatesP, ops:OptionsPattern[FindPlotRange]]:=Module[
	{safeOps,inputPlotRange, xData, yData, plotDataChopped, xDataChopped, yDataChopped, xmin,ymin,xmax,ymax,xminFinal,yminFinal,xmaxFinal,ymaxFinal,yrange,xrange, subsetData},

		safeOps=SafeOptions[FindPlotRange, ToList[ops]];

	(*it is easier to deal with a list of x and a list of y*)
	xData=plotData[[;;,1]];
	yData=plotData[[;;,2]];

	(*Convert rawPlotRange to a 4 value field inputPlotRange. this ensures all the downstream firsts and last are happy*)
	inputPlotRange=FullPlotRange[rawPlotRange];

	(*do fulls and all first becuase they are not dependent on anything else*)
	(*xmin must be less than xmax and ditto for y*)
	xmin=Switch[inputPlotRange[[1,1]],
			Full, 0,
			All, Min[xData],
			Automatic, Automatic,
			NumberP, If[MatchQ[inputPlotRange[[1,2]], NumberP]&&inputPlotRange[[1,2]]<inputPlotRange[[1,1]], inputPlotRange[[1,2]], inputPlotRange[[1,1]]]
			];

	xmax=Switch[inputPlotRange[[1,2]],
			All|Full, Max[xData],
			Automatic, Automatic,
			NumberP, If[MatchQ[inputPlotRange[[1,1]], NumberP]&&inputPlotRange[[1,2]]<inputPlotRange[[1,1]],  inputPlotRange[[1,1]], inputPlotRange[[1,2]]]
			];

	ymin=Switch[inputPlotRange[[2,1]],
			Full, 0,
			All, Min[yData],
			Automatic, Automatic,
			NumberP, If[MatchQ[inputPlotRange[[2,2]], NumberP]&&inputPlotRange[[2,2]]<inputPlotRange[[2,1]],  inputPlotRange[[2,2]], inputPlotRange[[2,1]]]
			];

	ymax=Switch[inputPlotRange[[2,2]],
			All|Full, Max[yData],
			Automatic, Automatic,
			NumberP, If[MatchQ[inputPlotRange[[2,1]], NumberP]&&inputPlotRange[[2,2]]<inputPlotRange[[2,1]],  inputPlotRange[[2,1]], inputPlotRange[[2,2]]]
			];

	(*everything that could be assigned now has a number. now the automatics need to be filled in. each one starts by the using the constraints*)
	(*that is done in domains which CHOPs off some of the data*)

	plotDataChopped=ECL`Domains[plotData, PlotRange->{{xmin, xmax}, {ymin, ymax}}];
	xDataChopped=plotDataChopped[[;;, 1]];
	yDataChopped=plotDataChopped[[;;, 2]];

	(*now everything automatic can be filled in, otherwise it keeps the value it had*)

	xmaxFinal=If[MatchQ[xmax, Automatic], Max[xDataChopped], xmax];
	xminFinal=If[MatchQ[xmin, Automatic], Min[xDataChopped], xmin];
	ymaxFinal=If[MatchQ[ymax, Automatic], Max[yDataChopped], ymax];
	yminFinal=If[MatchQ[ymin, Automatic], Min[yDataChopped], ymin];

	(*ranges are used for scaling*)
	xrange=xmaxFinal-xminFinal;
	yrange=ymaxFinal-yminFinal;

	(*output it as a list*)
	{{xminFinal-xrange*((ScaleX/.safeOps)-1),xmaxFinal+xrange*((ScaleX/.safeOps)-1)},
	{yminFinal-yrange*((ScaleY/.safeOps)-1),ymaxFinal+yrange*((ScaleY/.safeOps)-1)}}
];


(*takes in DateCoordinateP datapoints*)
FindPlotRange[rawPlotRange:(Full|All|Automatic|NumberP|_List),plotData:DateCoordinateP,ops:OptionsPattern[FindPlotRange]]:=Module[
	{safeOps,inputPlotRange,inputPlotRangeRaw, xData, yData, plotDataChopped, xDataChopped, yDataChopped, xmin,ymin,xmax,ymax,xminFinal,yminFinal,xmaxFinal,ymaxFinal,yrange,xrange, subsetData},

	safeOps=SafeOptions[FindPlotRange, ToList[ops]];

	(*it is easier to deal with a list of x and a list of y*)
	xData=If[MatchQ[#[[1]],_?DateObjectQ],Quiet[DateList[#[[1]]]],#[[1]]]&/@plotData;
	yData=plotData[[;;,2]];

	(*Convert rawPlotRange to a 4 value field inputPlotRange. this ensures all the downstream firsts and last are happy*)
	inputPlotRangeRaw=FullPlotRange[rawPlotRange];

	(*Convert any DateStrings in the inputPlotRangeRaw to be dateLists*)
	inputPlotRange = Table[If[MatchQ[#,_?DateObjectQ],Quiet[DateList[#]],#]&/@(inputPlotRangeRaw[[i]]),{i,1,Length[inputPlotRangeRaw]}];

	(*do fulls and all first becuase they are not dependent on anything else*)
	(*xmin must be less than xmax and ditto for y*)
	xmin=Switch[inputPlotRange[[1,1]],
			All|Full, First[Sort[xData]],
			Automatic, Automatic,
			DateListP, If[MatchQ[inputPlotRange[[1,2]],DateListP]&&QuantityMagnitude[DateDifference[inputPlotRange[[1,1]],inputPlotRange[[1,2]]]]>0, inputPlotRange[[1,1]], inputPlotRange[[1,2]]],
			_?DateObjectQ, If[MatchQ[inputPlotRange[[1,2]],_?DateObjectQ]&&QuantityMagnitude[DateDifference[inputPlotRange[[1,1]],inputPlotRange[[1,2]]]]>0, Quiet[DateList[inputPlotRange[[1,1]]]], Quiet[DateList[inputPlotRange[[1,2]]]]]
			];

	xmax=Switch[inputPlotRange[[1,2]],
			All|Full, Last[Sort[xData]],
			Automatic, Automatic,
			DateListP, If[MatchQ[inputPlotRange[[1,1]],DateListP]&&QuantityMagnitude[DateDifference[inputPlotRange[[1,1]],inputPlotRange[[1,2]]]]>0, inputPlotRange[[1,2]], inputPlotRange[[1,1]]],
			_?DateObjectQ, If[MatchQ[inputPlotRange[[1,1]],_?DateObjectQ]&&QuantityMagnitude[DateDifference[inputPlotRange[[1,1]],inputPlotRange[[1,2]]]]>0, Quiet[DateList[inputPlotRange[[1,2]]]], Quiet[DateList[inputPlotRange[[1,1]]]]]
			];

	ymin=Switch[inputPlotRange[[2,1]],
			Full, 0,
			All, Min[yData],
			Automatic, Automatic,
			NumberP, If[MatchQ[inputPlotRange[[2,2]], NumberP]&&inputPlotRange[[2,2]]<inputPlotRange[[2,1]],  inputPlotRange[[2,2]], inputPlotRange[[2,1]]]
			];

	ymax=Switch[inputPlotRange[[2,2]],
			All|Full, Max[yData],
			Automatic, Automatic,
			NumberP, If[MatchQ[inputPlotRange[[2,1]], NumberP]&&inputPlotRange[[2,2]]<inputPlotRange[[2,1]],  inputPlotRange[[2,1]], inputPlotRange[[2,2]]]
			];


	(*everything that could be assigned now has a number. now the automatics need to be filled in. each one starts by the using the constraints*)
	(*that is done in domains which CHOPs off some of the data*)

	plotDataChopped=Domains[plotData, PlotRange->{{xmin, xmax}, {ymin, ymax}}];
	xDataChopped=plotDataChopped[[;;, 1]];
	yDataChopped=plotDataChopped[[;;, 2]];

	(*now everything automatic can be filled in, otherwise it keeps the value it had*)

	xmaxFinal=If[MatchQ[xmax, Automatic], Last[Sort[xDataChopped]], xmax];
	xminFinal=If[MatchQ[xmin, Automatic], First[Sort[xDataChopped]], xmin];
	ymaxFinal=If[MatchQ[ymax, Automatic], Max[yDataChopped], ymax];
	yminFinal=If[MatchQ[ymin, Automatic], Min[yDataChopped], ymin];


	(*ranges are used for scaling*)
	xrange=QuantityMagnitude[DateDifference[xmaxFinal,xminFinal]];
	yrange=ymaxFinal-yminFinal;

	(*output it as a list*)
	{{DatePlus[xminFinal,-xrange*((ScaleX/.safeOps)-1)],DatePlus[xmaxFinal,xrange*((ScaleX/.safeOps)-1)]},
	{yminFinal-yrange*((ScaleY/.safeOps)-1),ymaxFinal+yrange*((ScaleY/.safeOps)-1)}}

];


(* ::Subsubsection::Closed:: *)
(*automaticPointSize*)


automaticPointSize[n_Integer,pmin_,pmax_,mono_]:=With[{},Clip[pmax*(pmin+Exp[-0.025*(.25+mono)*n]),{pmin,pmax}]];



(* ::Subsubsection::Closed:: *)
(*prepareNulls*)


prepareNulls[value_,length_]:=If[Length[value]==length,
	value,
	If[MatchQ[value,(Null|None)],
		Table[Null,{length}],
		If[MatchQ[value,_List],
			Message[plot::OptionLengthMismatch,length,Length[value]],
			Table[value,{length}]
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*prepareLabels*)


prepareLabels[None,length_Integer]:=Table[Null,{length}];
prepareLabels[legend:(Null|Automatic),length_Integer]:=Table[legend,{length}];
prepareLabels[label:{_String..},length_Integer]:=Table[label,{length}];
prepareLabels[labels:{{_String..}..},length_Integer]:=If[Length[labels]==length,labels,Message[plot::OptionLengthMismatch,length,Length[labels]]];



(* ::Subsection::Closed:: *)
(*Internal Helper Functions*)


(* ::Subsubsection::Closed:: *)
(*AutomaticYRange*)


AutomaticYRange[data:(DateCoordinateP|{{_?DateObjectQ, _?UnitsQ}..}|QuantityCoordinatesP[]),offset_?NumericQ]:=Module[{yAxis, minY, maxY},

	(*Extract Y data from list of{{Date,data}..}*)
	yAxis=data[[All,2]];

	(*Find the minimum*)
	minY=QuantityMagnitude[Min[yAxis]];

	(*Find the maximum*)
	maxY=QuantityMagnitude[Max[yAxis]];

	(*Return the Y range*)
	{minY-offset, maxY+offset}

];




(* ::Subsubsection::Closed:: *)
(*Plot-able Fields*)


(* Returns a list of rules linking plot-able fields to their units *)
(* By default a field is considered plot-able if it has units in a pair *)
(* Overloads can be written for data types with other plot-able fields *)
linePlotTypeUnits[typ:TypeP[]]:=Select[LegacySLL`Private`typeUnits[typ],ArrayDepth[Last[#]]>0 && MatchQ[Length[Unitless[Last[#]]],2]&];
(* AbsorbanceKinetics supports 3D plotting *)
linePlotTypeUnits[Object[Data,AbsorbanceKinetics]]:=Select[LegacySLL`Private`typeUnits[Object[Data,AbsorbanceKinetics]],ArrayDepth[Last[#]]>0 && MatchQ[Length[Unitless[Last[#]]],2|3]&];
linePlotTypeUnits[Object[Data, TLC]]:={Intensity->{Pixel,Intensity}};



imageFields[typ:TypeP[]]:={};
imageFields[Object[Data, TLC]]:={DarkroomImage,PlateImage,LaneImage};
imageFields[Object[Data, PAGE]]:={OptimalLaneImage};


peaksFields[typ:TypeP[]]:=Flatten[Cases[peakTriplets,{typ,_,_}][[All,3]]];
fractionsFields[typ:TypeP[]]:=Flatten[Cases[fractionTriplets,{typ,_,_}][[All,3]]];


linkedFields[typ:TypeP[]]:=Part[
	Select[
		Lookup[LookupTypeDefinition[typ],Fields],
		relatedToTypeQ[#,typ]&
	],
	All,
	1
];

relatedToTypeQ[_Symbol->rules:{(_Rule|_RuleDelayed)...},typ:TypeP[]]:=With[
	{relation = Lookup[rules,Relation]},

	MatchQ[
		typ,
		TypeP[
			Cases[
				relation,
				TypeP[],
				Infinity,
				Heads->True
			]
		]
	]
];

sameTypeRelations[typ_,relations_]:=Module[{},
	If[ContainsAny[List@@(StoragePattern/.(#/.(Fields/.LookupTypeDefinition[typ]))),List@@ObjectP[typ]],
		#,
		Nothing
	]&/@relations
];


(* ::Subsubsection::Closed:: *)
(*Peak and Fractions Lookups*)


(* Structure as {Type, Source Field, associated Peaks} *)
peakTriplets= {
	{Object[Data, AbsorbanceSpectroscopy], AbsorbanceSpectrum, AbsorbanceSpectrumPeaksSource},
	{Object[Data, AgaroseGelElectrophoresis], SampleElectropherogram, SampleElectropherogramPeaksAnalyses},
	{Object[Data, AgaroseGelElectrophoresis], MarkerElectropherogram, MarkerElectropherogramPeaksAnalyses},
	{Object[Data, AgaroseGelElectrophoresis], PostSelectionElectropherogram, PostSelectionPeaksAnalyses},
	{Object[Data, Chromatography], Absorbance, AbsorbancePeaksAnalyses},
	{Object[Data, Chromatography], SecondaryAbsorbance, SecondaryAbsorbancePeaksAnalyses},
	{Object[Data, Chromatography], Conductance, ConductancePeaksAnalyses},
	{Object[Data, Chromatography], Fluorescence, FluorescencePeaksAnalyses},
	{Object[Data, Chromatography], SecondaryFluorescence, SecondaryFluorescencePeaksAnalyses},
	{Object[Data, Chromatography], TertiaryFluorescence, TertiaryFluorescencePeaksAnalyses},
	{Object[Data, Chromatography], QuaternaryFluorescence, QuaternaryFluorescencePeaksAnalyses},
	{Object[Data, Chromatography], Scattering, ScatteringPeaksAnalyses},
	{Object[Data, Chromatography], Conductance, ConductancePeaksAnalyses},
	{Object[Data, Chromatography], pH, pHPeaksAnalyses},
	{Object[Data, Chromatography], RefractiveIndex, RefractiveIndexPeaksAnalysis},
	{Object[Data, ChromatographyMassSpectra], Absorbance, AbsorbancePeaksAnalyses},
	{Object[Data, ChromatographyMassSpectra], IonAbundance, IonAbundancePeaksAnalyses},
	{Object[Data, ChromatographyMassSpectra], MassSpectrum, MassSpectrumPeaksAnalyses},
	{Object[Data, CoulterCount], DiameterDistribution, DiameterPeaksAnalyses},
	{Object[Data, CoulterCount], UnblankedDiameterDistribution, DiameterPeaksAnalyses},
	{Object[Data, FluorescenceSpectroscopy], ExcitationSpectrum, ExcitationSpectrumPeaksAnalyses},
	{Object[Data, FluorescenceSpectroscopy], EmissionSpectrum, EmissionSpectrumPeaksAnalyses},
	{Object[Data, LuminescenceSpectroscopy], EmissionSpectrum, PeaksAnalyses},
	{Object[Data, MassSpectrometry], MassSpectrum, MassSpectrumPeaksAnalyses},
	{Object[Data, NMR], NMRSpectrum, NMRSpectrumPeaksAnalyses},
	{Object[Data, PAGE], OptimalLaneIntensity, LanePeaksAnalyses},
	{Object[Data, Western], MassSpectrum, MassSpectrumPeaksAnalyses},
	{Object[Data, TLC], Intensity, LanePeaksAnalyses},
	{Object[Data, XRayDiffraction], BlankedDiffractionPattern, DiffractionPeaksAnalyses},
	{Object[Data, IRSpectroscopy], AbsorbanceSpectrum, AbsorbanceSpectrumPeaksSource},
	{Object[Data, DifferentialScanningCalorimetry], HeatingCurves, HeatingCurvePeaksAnalyses}
};

(* Get all peaks for a given source within in a type *)
sourceToPeaks[typ:TypeP[],sourceField:FieldP[Output->Short]]:=sourceToPeaks[typ,sourceFields] = FirstOrDefault[Select[peakTriplets,MatchQ[{typ,sourceField},#[[1;;2]]]&][[All,3]]];
sourceToPeaks[typ:TypeP[],sourceFields:{FieldP[Output->Short]..}]:=sourceToPeaks[typ,sourceFields]=Flatten[sourceToPeaks[typ,#]&/@sourceFields];

(* Get the source given type and peaks *)
peaksToSource[typ:TypeP[],peaksField:FieldP[Output->Short]]:=peaksToSource[typ,peaksField]=FirstOrDefault[Flatten[Select[peakTriplets,MatchQ[typ,First[#]] && MatchQ[Last[#],peaksField]&][[All,2]]]];
peaksToSource[typ:TypeP[],peaksFields:{FieldP[Output->Short]..}]:=peaksToSource[typ,peaksFields]=Flatten[peaksToSource[typ,#]&/@peaksFields];


(* Structure as {Type, Source Field, {Associated Fractions}} *)
ladderTriplets={
	{Object[Data, Chromatography],Chromatogram,StandardPeaks},
	{Object[Data, PAGE],OptimalLaneIntensity,LadderPeaks},
	{Object[Data, Western],MassSpectrum,LadderPeaks}
};

(* Get the source given type and ladder *)
ladderToSource[typ:TypeP[],ladderField:FieldP[Output->Short]]:=FirstOrDefault[Flatten[Select[ladderTriplets,MatchQ[typ,First[#]] && MatchQ[Last[#],ladderField]&][[All,2]]]];
ladderToSource[typ:TypeP[],ladderFields:{FieldP[Output->Short]..}]:=Flatten[ladderToSource[typ,#]&/@ladderFields];


(* Structure as {Type, Source Field, {Associated Fractions}} *)
fractionTriplets={
	{Object[Data, Chromatography],Chromatogram,{FractionsCollected,FractionsPicked}}
};

(* Get all fractions for a given source within in a type *)
sourceToFractions[typ:TypeP[],sourceField:FieldP[Output->Short]]:=Flatten[Select[fractionTriplets,MatchQ[{typ,sourceField},#[[1;;2]]]&][[All,3]]];
sourceToFractions[typ:TypeP[],sourceFields:{FieldP[Output->Short]..}]:=sourceToFractions[typ,#]&/@sourceFields;

(* Get the source given type and fractions *)
fractionsToSource[typ:TypeP[],fracsField:FieldP[Output->Short]]:=FirstOrDefault[Flatten[Select[fractionTriplets,MatchQ[typ,First[#]] && MemberQ[Last[#],fracsField]&][[All,2]]]];
fractionsToSource[typ:TypeP[],fracsFields:{FieldP[Output->Short]..}]:=Flatten[fractionsToSource[typ,#]&/@fracsFields];


(* ::Subsection::Closed:: *)
(*epilogs*)


(* ::Subsubsection::Closed:: *)
(*molecularWeightEpilog*)


DefineUsage[molecularWeightEpilog,
{
	BasicDefinitions -> {
		{"molecularWeightEpilog[molecularWeights:{_?NumericQ|_?MolecularWeightQ|_?SequenceQ|_?StrandQ..}]", "epilog_List", "Provides an epilog that demarks expected molecular weight with tick marks.  Can take a raw number, a weight, a sequence, or a strand as inputs.  PlotRange must be explicitly provided as an option."}
	},
	Input :> {
		{"molecularWeights", _, "the number that you wish to obtain the order of magnitude of"}
	},
	Output :> {
		{"epilog", _, "an epilog to be included in a mass spec plot that provides tick marks and molecular weight labels at expected molecular weights"}
	},
	SeeAlso -> {
		"PeakEpilog"
	},
	Author -> {
		"brad"
	}
}];


DefineOptions[molecularWeightEpilog,
	Options :> {
		{PlotRange -> Automatic, {{_?NumericQ, _?NumericQ} | Automatic, {_?NumericQ, _?NumericQ} | Automatic} | Automatic, "The range of the plot.  MUST PROVIDE EXPLICIT NUMBERS."},
		{Display -> {Peaks, ExpectedMolecularWeight}, {(Peaks | PeakWidths | Intensity | LaneIntensity | OptimalLaneIntensity | ExpectedMolecularWeight)...}, "Matches the plot option.  Will only return an epilog if ExpectedMolecularWeight appears in this list."},
		{TickColor -> RGBColor[0.75, 0., 0.25], _?ColorQ, "Color for the expected molecular weight tick."},
		{TargetUnits -> {Gram/Mole, ArbitraryUnit}, {_?MolecularWeightQ, _?ArbitraryUnitQ}, "Matches the plot option.  The desired plot Units for the axes."},
		{LabelStyle -> {Bold, 12, FontFamily -> "Arial"}, _List, "The style for the text labeling the molecular weight ticks."},
		{Truncations -> 0, _Integer, "The number of truncations marks you wish to include in the epilog."},
		{TickSize -> 0.5, _Real, "The size of the truncation marks."},
		{TickStyle -> {Thickness[Large], Opacity[0.5]},_,""},
		{Samples -> Null,_,""}
	}];


molecularWeightEpilog[masses:({(_?NumericQ|_?MolecularWeightQ|Null)..}|Null),ops:OptionsPattern[]]:=Null/;!MemberQ[OptionValue[Display],ExpectedMolecularWeight];
molecularWeightEpilog[masses:({Null..}|Null),ops:OptionsPattern[]]:=Null;

molecularWeightEpilog[masses:{(_?NumericQ|_?MolecularWeightQ|Null)..},ops:OptionsPattern[]]:=Module[{colors,numbers},

	numbers=Switch[#,
		_?NumericQ,#,
		_?MolecularWeightQ,Unitless[#,First[OptionValue[TargetUnits]]],
		_,Null
	]&/@masses;

	molecularWeightGraphic[#,PassOptions[molecularWeightEpilog,molecularWeightGraphic,ops]]&/@numbers

]/;MemberQ[OptionValue[Display],ExpectedMolecularWeight];

(* --- Listable --- *)
molecularWeightEpilog[masses:{({(_?NumericQ|_?MolecularWeightQ|Null)..}|Null)..},ops:OptionsPattern[molecularWeightEpilog]]:=Module[{colors},
	colors=ColorFade[{OptionValue[TickColor]},Length[masses]];
	MapThread[molecularWeightEpilog[#1,TickColor->#2,ops]&,{masses,colors}]
];


Options[molecularWeightGraphic]={
	PlotRange->Full,
	TickColor->Blend[{Red,Purple},0.5],
	TickStyle->{Thick,Opacity[0.5]},
	TickSize->0.5,
	Label->True,
	LabelStyle->{Bold,12,FontFamily->"Arial"}
};
molecularWeightGraphic[Null,ops:OptionsPattern[molecularWeightGraphic]]:={};

molecularWeightGraphic[mass_?NumericQ,ops:OptionsPattern[molecularWeightGraphic]]:=Module[{xmin,xmax,ymin,ymax,yrange},
	{{xmin,xmax},{ymin,ymax}}=OptionValue[PlotRange];
	yrange=ymax-ymin;

	{Sequence@@OptionValue[TickStyle],OptionValue[TickColor],Line[{{mass,ymin},{mass,ymin+yrange*OptionValue[TickSize]}}],
	Switch[OptionValue[Label],True,molecularWeightGraphicLabel[mass,ymin,yrange,PassOptions[molecularWeightGraphic,ops]],_?NumericQ,molecularWeightGraphicLabel[mass,ymin,yrange,OptionValue[Label],PassOptions[molecularWeightGraphic,ops]],_,Null]}
];

molecularWeightGraphic[masses:{_?NumericQ..},ops:OptionsPattern[molecularWeightGraphic]]:=Module[{ticks,labelBools},
	ticks=Table[OptionValue[TickSize]/n,{n,1,Length[masses]}];
	labelBools=PadRight[{True},Length[masses],False];
	MapThread[molecularWeightGraphic[#1,TickSize->#2,Label->#3,ops]&,{masses,ticks,labelBools}]
];

molecularWeightGraphicLabel[mass_?NumericQ,ymin_?NumericQ,yrange_?NumericQ,OptionsPattern[molecularWeightGraphic]]:=Text[Style[ToString[mass],Background->Directive[White,Opacity[0.75]],Sequence@@OptionValue[LabelStyle]],{mass,ymin+yrange(OptionValue[TickSize]+0.03)}];
molecularWeightGraphicLabel[mass_?NumericQ,ymin_?NumericQ,yrange_?NumericQ,explicitLabel_?NumericQ,OptionsPattern[molecularWeightGraphic]]:=Text[Style[ToString[explicitLabel],Background->Directive[White,Opacity[0.75]],Sequence@@OptionValue[LabelStyle]],{mass,ymin+yrange(OptionValue[TickSize]+0.03)}];


(* ::Subsection::Closed:: *)
(*Value Formatting*)

(* ::Text:: *)
(*Careful where this goes, due to dependency issues*)

(* ::Subsubsection::Closed:: *)
(* Patterns *)

unitlessFractionP:={{_Real, _Real, _String?(StringMatchQ[#1, DigitCharacter ... ~~ LetterCharacter ~~ DigitCharacter ..] &)}..};
ladderP = {Rule[_?NumericQ,_?NumericQ]..};

oneFrameLabelP = None | Automatic | _String | _Style | _QuantityForm;
frameLabelP=Automatic|None|{Repeated[oneFrameLabelP,4]}|{{oneFrameLabelP,oneFrameLabelP},{oneFrameLabelP,oneFrameLabelP}};

oneChartDataPointP = Null | UnitsP[] | Replicates[UnitsP[]..] | PlusMinus[UnitsP[],UnitsP[]] | _?DistributionParameterQ;
oneChartDataSetP = Null|{oneChartDataPointP..}|_?QuantityVectorQ;

oneHistogramDataPointP = Null | UnitsP[] | Replicates[UnitsP[]..] | PlusMinus[UnitsP[],UnitsP[]] | _?DistributionParameterQ;
oneHistogramDataSetP = Null|{oneChartDataPointP..}|_?QuantityVectorQ | EmpiricalDistributionP[];


(* ::Subsubsection::Closed:: *)
(*lookupWithUnits*)


(* For each packet, look up all fields returning {{p1F1,p1F2,...},{p2F1,p2F2,...}} *)
lookupWithUnits[packets:{_Association..},fields_List]:=lookupWithUnits[#,fields]&/@packets;
lookupWithUnits[packet:_Association,fields_List]:=lookupWithUnits[packet,#]&/@fields;
lookupWithUnits[packets:{_Association..},field_Symbol]:=lookupWithUnits[#,field]&/@packets;

(*
	Special definitions for peak fields, because they now need to do complicated download through link
*)
lookupWithUnits[packet_Association,field:(Alternatives@@peakTriplets[[;;,3]])]:=
    If[KeyMemberQ[packet,ID],
	    unitedEpilog[
				Analysis`Private`downloadPeaksFromData[packet,field],
				packet,
				field
			],
	    Null
    ];

(*
	Add units if they are not present.
	fields will have units if they come from download, but will not in some other cases
*)
lookupWithUnits[packet_Association,field_Symbol]:=Module[{val,type,typeField,uns,un,qaUn},
	val=Lookup[packet,field,Null];
	Switch[val,
		(* These fields still need units added explicitly, even if they come from packet *)
		PacketP[Object[Analysis,Peaks]]|ladderP|unitlessFractionP,unitedEpilog[val,packet,field],
		(* Actual download packets should not need to use this function *)
		_?(KeyMemberQ[packet,ID]&),val,
		{},{},
		NullP,Null,
		_Quantity,val,
		QuantityArrayP[],val,
		{_Quantity..},val,
		_List?(MemberQ[#,_Quantity]&),val,
		{_List?(MemberQ[#,_Quantity]&)..},val,
		_,Module[{},
		type=Lookup[packet,Type];
		uns=LegacySLL`Private`typeUnits[type];
		un=Lookup[uns,field,1];
		qaUn=Replace[Lookup[uns,field,None],_Missing->{None,None}];
		typeField=type[field];
		Which[
			MatchQ[val,{CoordinatesP..}], QuantityArray[#,qaUn]&/@val,
			MatchQ[val,CoordinatesP], QuantityArray[val,qaUn],
			MatchQ[val,QuantityArrayP[]], val,
			SingleFieldQ[typeField], val,
			MultipleFieldQ[typeField] && IndexedFieldQ[typeField], Transpose[Transpose[val]*un],
			MultipleFieldQ[typeField] && !IndexedFieldQ[typeField], val*un,
			True,val
		]
	]
	]
];

lookupWithUnits[a_,b_]:=Null;
lookupWithUnits[a_]:=Null;


unitedEpilog[val:_,packet:packetOrInfoP[],field:FieldP[Output->Short]]:=Module[{sourceField,sourceUnits},
	sourceField=Switch[val,
		PacketP[Object[Analysis,Peaks]], peaksToSource[Type/.packet,field],
		ladderP, ladderToSource[Type/.packet,field],
		unitlessFractionP, fractionsToSource[Type/.packet,field]
	];
	sourceUnits=Replace[(sourceField/.LegacySLL`Private`typeUnits[Type/.packet]),sourceField->{1,1}];

	Switch[val,
		Null, Null,
		PacketP[Object[Analysis,Peaks]],addPeakUnits[val,sourceUnits],
		unitlessFractionP,addFractionUnits[val,First[sourceUnits]],
		ladderP, addLadderUnits[val,First[sourceUnits]]
	]
];

(* ::Subsubsection::Closed:: *)
(*addPeakUnits*)


addPeakUnits[pks:PacketP[Object[Analysis,Peaks]],{None,yUnit_}]:=addPeakUnits[pks,{1,yUnit}];
addPeakUnits[pks:PacketP[Object[Analysis,Peaks]],{xUnit_,None}]:=addPeakUnits[pks,{xUnit,1}];
addPeakUnits[pks:PacketP[Object[Analysis,Peaks]],{None,None}]:=addPeakUnits[pks,{1,1}];
addPeakUnits[pks:PacketP[Object[Analysis,Peaks]],{xUnit_,yUnit_}]:=Module[{},
	Join[
		pks,
		Association@Replace[
			Normal[pks],
			{
				(Position->x_):>(Position->x*xUnit),
				(Height->y_):>(Height->y*yUnit),
				(HalfHeightWidth->x_):>(HalfHeightWidth->x*xUnit),
				(Area->xy_):>(Area->xy*xUnit*yUnit),
				(PeakRangeStart->x_):>(PeakRangeStart->x*xUnit),
				(PeakRangeEnd->x_):>(PeakRangeEnd->x*xUnit),
				(WidthRangeStart->x_):>(WidthRangeStart->x*xUnit),
				(WidthRangeEnd->x_):>(WidthRangeEnd->x*xUnit),
				(BaselineIntercept->y_):>(BaselineIntercept->y*yUnit),
				(BaselineSlope->yx_):>(BaselineSlope->yx*(yUnit/xUnit)),
				(BaselineFunction->blf_):>(BaselineFunction->QuantityFunction[blf,xUnit,yUnit])
			},
			{1}
		]
	]
];
addPeakUnits[pks:PacketP[Object[Analysis,Peaks]]]:=Quiet[addPeakUnits[pks,Lookup[pks[PeakUnits],{Position,Height}]]];
addPeakUnits[pks:PacketP[Object[Analysis,Peaks]],_]:=pks;
addPeakUnits[val_]:=val;


(* ::Subsubsection::Closed:: *)
(*addFractionsUnits*)


addFractionUnits[fracs_,xUnit_]:=MapAt[#*xUnit&,fracs,{;;,1;;2}];


(* ::Subsubsection::Closed:: *)
(*addLadderUnits*)


addLadderUnits[lad_,xUnit_]:=MapAt[#*xUnit&,lad,{;;,2}];


(* ::Subsubsection::Closed:: *)
(*optionNameToFieldName*)


(* Lookup functions to resolve field name based on generic option *)
(* When options are associated with a field (e.g. peaks), the name of that field must be supplied for proper resolution *)

(* Map *)
optionNameToFieldName[optionNames:{(_Symbol)..}]:=optionNames;
optionNameToFieldName[optionNames:{_Symbol..},typ:TypeP[],assocField:_Symbol]:=optionNameToFieldName[#,typ,assocField]&/@optionNames;
optionNameToFieldName[optionNames:{_Symbol..},typ:TypeP[],assocFields:{_Symbol..}]:=optionNameToFieldName[#,typ,assocFields]&/@optionNames;
optionNameToFieldName[optionNames:_Symbol,typ:TypeP[],assocFields:{_Symbol..}]:=optionNameToFieldName[optionNames,typ,#]&/@assocFields;

(* Peaks Lookup *)
optionNameToFieldName[Peaks,typ:TypeP[],sourceField:FieldP[Output->Short]]:=optionNameToFieldName[Peaks,typ]=sourceToPeaks[typ,sourceField];

(* Ladder Lookup *)
optionNameToFieldName[Ladder,Object[Data,Chromatography],_]:=StandardPeaks;
optionNameToFieldName[Ladder,Object[Data,ChromatographyMassSpectra],_]:=Null;
optionNameToFieldName[Ladder,Object[Data,PAGE],_]:=LadderPeaks;
optionNameToFieldName[Ladder,Object[Data,Western],_]:=LadderPeaks;
optionNameToFieldName[Ladder,_,_]:=Nothing;


(* Fractions Lookup *)
optionNameToFieldName[Fractions,Object[Data,Chromatography],Chromatogram]:=FractionsCollected;
optionNameToFieldName[Fractions,Object[Data,Chromatography],Absorbance]:=Fractions;
optionNameToFieldName[Fractions,Object[Data,Chromatography],Fluorescence]:=Fractions;
optionNameToFieldName[Fractions,_,_]:=Nothing;

(* Alarms Lookup *)
optionNameToFieldName[AirAlarms,Object[Data,Chromatography],_]:=AirDetectedAlarms;

(* Generic Lookup *)
optionNameToFieldName[optionName:_Symbol]:=optionName;
optionNameToFieldName[optionName:_Symbol,typ:TypeP[],assocField:FieldP[Output->Short]]:=optionNameToFieldName[optionName,typ,assocField]=optionName;

(*Catch alls *)
optionNameToFieldName[a_]:=a;
optionNameToFieldName[a_,b_]:=a;
optionNameToFieldName[a_,b_,c_]:=a;



(* ::Subsection::Closed:: *)
(*Sequence, Strand, Structure*)


(* ::Subsubsection::Closed:: *)
(*StructureForm*)


DefineOptions[StructureForm,
	Options :> {
		{ImageSize -> Automatic, _, "Size of image.",Category->Hidden}
	},
	SharedOptions :> {
		{Graph, {AlignmentPoint, AspectRatio, Axes, AxesLabel, AxesOrigin, AxesStyle, Background, BaselinePosition, BaseStyle, ContentSelectable, DirectedEdges, EdgeCapacity, EdgeCost, EdgeLabels, EdgeLabelStyle, EdgeShapeFunction, EdgeStyle, EdgeWeight, Editable, Epilog, Frame, FrameLabel, FrameStyle, FrameTicks, FrameTicksStyle, GraphHighlight, GraphHighlightStyle, GraphLayout, GraphRoot, GraphStyle, GridLines, GridLinesStyle, ImageMargins, ImagePadding, ImageSize, LabelStyle, PerformanceGoal, PlotLabel, PlotRange, PlotRangeClipping, PlotRangePadding, PlotRegion, Prolog, Properties, RotateLabel, Ticks, TicksStyle, VertexCapacity, VertexCoordinates, VertexLabels, VertexLabelStyle, VertexShape, VertexShapeFunction, VertexSize, VertexStyle, VertexWeight}}
	}];


(* given a string *)
StructureForm[in_String,ops:OptionsPattern[StructureForm]]:=drawStructure[ToStructure[in],ops];

(* given a strand *)
StructureForm[in:StrandP,ops:OptionsPattern[StructureForm]]:=drawStructure[ToStructure[in],ops];

(* given a Structure *)
StructureForm[in:StructureP,ops:OptionsPattern[StructureForm]]:=drawStructure[in,ops];

(* given anything else *)
StructureForm[in_,ops:OptionsPattern[StructureForm]]:=in/.{c_Structure:>drawStructure[c,ops],s_Strand:>drawStructure[ToStructure[s],ops]};


(* ::Subsubsection:: *)
(*MotifForm*)


DefineOptions[MotifForm,
	Options :> {
		{ImageSize -> Automatic, _, "Size of image.",Category->Hidden}
	},
	SharedOptions :> {
		{GraphPlot, {AlignmentPoint, AspectRatio, Axes, AxesLabel, AxesOrigin, AxesStyle, Background, BaselinePosition, BaseStyle,
			 ContentSelectable, CoordinatesToolOptions, DataRange, DirectedEdges, DisplayFunction,
			 Epilog, FormatType, Frame, FrameLabel, FrameStyle, FrameTicks, FrameTicksStyle, GridLines,
			GridLinesStyle, ImageMargins, ImagePadding, ImageSize, LabelStyle, Method, MultiedgeStyle,  PlotLabel,
			PlotRange, PlotRangeClipping, PlotRangePadding, PlotRegion, PlotStyle,  Prolog, RotateLabel,
			SelfLoopStyle, Ticks, TicksStyle}}
	}];


MotifForm[c:Structure[strands:{_Strand..}, pairs:StrandBasePairBondsP],ops:OptionsPattern[MotifForm]]:=
	MotifForm[NucleicAcids`Private`reformatBonds[c,StrandMotifBase],ops];

MotifForm[c:Structure[strands:{_Strand..}, pairs:{BondP..}],ops:OptionsPattern[MotifForm]]:=
	MotifForm[NucleicAcids`Private`reformatMotifs[c]/.{Bond[{a1_,b1_,c1_Span},{a2_,b2_,c2_Span}]:>Bond[{a1,b1},{a2,b2}]},ops]/;Cases[pairs,MotifBaseBondP]=!={};
MotifForm[Structure[strands:{_Strand..}, pairs:{MotifBondP...}],ops:OptionsPattern[MotifForm]] :=
	With[{
		g = Show[FullGraphics[plotMotifDiagram[Structure[strands, pairs]]],ImageSize->OptionValue[ImageSize]]
	},
		Interpretation[
			g,(*Style[g, Selectable->False],*)
			Structure[strands, pairs]
		]
	];

MotifForm[stuff_,ops:OptionsPattern[MotifForm]] := stuff /. {x_Structure :> MotifForm[x,ops], s_Strand :> MotifForm[s,ops]};

MotifForm[seq_String,ops:OptionsPattern[MotifForm]] := MotifForm[ToStructure[seq],ops];

MotifForm[s_Strand,ops:OptionsPattern[MotifForm]] := MotifForm[ToStructure[s],ops];

MotifForm[reactions:{(_Reaction|{})..},ops:OptionsPattern[MotifForm]] :=
	TableForm[
		MotifForm[
			Cases[reactions, Reaction[in_,out_,rate_] :> {in,out,rate}],
			ops
		],
		TableHeadings->{None,Style[#,Large,Bold]&/@{"Reactants", "Products", "Rate"}}
	];

MotifForm[x_ReactionMechanism,ops:OptionsPattern[MotifForm]] :=
	MotifForm[List @@ x, ops];
