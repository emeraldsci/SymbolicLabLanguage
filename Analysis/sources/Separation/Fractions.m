(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*AnalyzeFractions*)


(* ::Subsubsection::Closed:: *)
(*AnalyzeFractions*)


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
				Default -> All,
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

Warning::InvalidPosition = "There is no fraction at position `1`. Only `2` fractions were collected.";
Warning::IncludeHasNoEffect = "The inclusions `1` specified in the Include option apply to fraction which have already been selected. If OverlappingPeaks is set, please use the TopPeaks option to adjust automatically selected fractions. Otherwise, ensure no domain is selected and set Exclude -> All to only select the fractions specified in Include.";
Warning::IncludeOutsideDomain = "The inclusions `1` specified in the Include option apply to fraction which are not in the Domain. Expand the domain to include the fractions selected in the Include option.";
Error::MissingCollectedFractions = "The collected fractions information is missing for: `1`.";
Error::FractionalIndexes = "Include expects positive integer values to select collected fractions by index. Alternatively, units of time can be used to select fractions within a timespan.";
Error::UnexpectedUnits = "Time units are expected for fraction selection, however the following units were encountered: `1`.";

inputPatternAnalyzeFractionsP = Alternatives[
	ObjectP[Object[Data, Chromatography]],
	ObjectP[Object[Analysis, Fractions]]
];


listInputPatternAnalyzeFractionsP = Alternatives[
	ObjectP[Object[Protocol, HPLC]],
	ObjectP[Object[Protocol, FPLC]]
];


(* AnalyzeFractions[in: inputPatternAnalyzeFractionsP, ops: OptionsPattern[]] := Module[
	{inList, pkts},
	inList = {in};
	pkts = AnalyzeFractions[inList, ops]
];
 *)

 AnalyzeFractions[in: listInputPatternAnalyzeFractionsP, ops: OptionsPattern[]] := Module[
	{inList},
	inList = resolveAnalyzeFractionsListInput[in];
	AnalyzeFractions[inList, ops]
];

myFractionsPattern = Null|ObjectP[Object[Data, Chromatography]]|ObjectP[Object[Analysis, Fractions]];

DefineAnalyzeFunction[
	AnalyzeFractions,
	<|FractionData-> myFractionsPattern|>,
	(*{
		Batch[analyzeFractionsParseInput],
		Batch[resolveAnalyzeFractionsOptions],
		analyzeFractionsPreview,
		analyzeFractionsResult
	}*)

	{
		Batch[analyzeFractionsParseInput] ,
		Batch[resolveAnalyzeFractionsOptions] ,
		analyzeFractionsPreview ,
		analyzeFractionsPacket
	}

];


(* ::Subsection::Closed:: *)
(*resolveAnalyzeFractionsOptions*)


resolveAnalyzeFractionsOptions[KeyValuePattern[{
	ResolvedInputs -> KeyValuePattern[{DataReference->dr_, Chromatogram->chrom_}],
	ResolvedOptions -> ro_,
	OutputList -> ol_,
	Batch->True
}]]:= Module[{opsAsRules},
	opsAsRules = Normal[KeyDrop[#,Batch]]&/@BatchTranspose[ro];
	resolveAnalyzeFractionsOptions[dr, chrom, opsAsRules, ol]
];

resolveAnalyzeFractionsOptions[dataRef_, chromatograms_, safeOps:{_List..}, outputLists_] := Module[
	{collectTestsBoolean, resolvedOptions, tests},

	collectTestsBoolean = MemberQ[#, Tests]& /@ outputLists;

	{resolvedOptions, tests} = Transpose @ MapThread[resolveAnalyzeFractionsOptionsSingle[#1, #2, #3, #4] &, {dataRef,chromatograms,safeOps, collectTestsBoolean}];
	MapThread[<|
		ResolvedOptions ->Association[#1],
		Tests -> <|OptionTests->#2|>,
		Batch->False
	|>&,{resolvedOptions,tests}]
];


resolveAnalyzeFractionsOptionsSingle[dataRef_, chromatogram_, safeOps_List, collectTestsBoolean_]:=Module[
	{domains, domainTests, exclude, resolvedOps},

	exclude = Replace[Lookup[safeOps,Exclude],All->Range[Length[dataRef[Fractions]]]];

	domains = Replace[Lookup[safeOps,Domain],All->MinMax[chromatogram[[;;,1]]]];
	domainTests = {fractionsTestOrNull[Domain, collectTestsBoolean, "Domains are valid intervals with left bound smaller than right bound.", TrueQ[Or[MatchQ[domains, All], domains[[1]] <= domains[[2]]]]]};

	resolvedOps = ReplaceRule[safeOps, {
		OverlappingPeaks -> resolveAnalyzeFractionOptionPeaks[Lookup[safeOps, OverlappingPeaks], dataRef],
		Domain -> domains,
		Exclude -> exclude
	}];

	{resolvedOps, domainTests}
];


fractionsTestOrNull[opsName_, makeTest:BooleanP,description_,expression_]:=If[makeTest,
	Test[description,expression,True],
	If[TrueQ[expression],
		Null,
		Message[Error::InvalidOption, opsName]
	]
];


(* ::Subsection::Closed:: *)
(*analyzeFractionsPreview*)


analyzeFractionsPreview[KeyValuePattern[{
	ResolvedInputs -> KeyValuePattern[{Collected -> collected_, Picked -> picked_, Chromatogram -> chrom_, Labels->labels_, DataReference -> dr_}],
	ResolvedOptions -> ro_,
	OutputList -> outputList_

}]]:= <|
	Preview -> If[MemberQ[outputList,Preview],
		AdjustForCCD[analyzeFractionsPreview[collected, picked, Normal[ro], chrom, labels, dr], AnalyzeFractions],
		Null
	]
|>



analyzeFractionsPreview[fracsCollected:{FractionP...},fracsPicked:{FractionP...},resolvedOps_List,chromatogram_,fractionLabels_, dataRef_] := Module[
	{defPeaks, plotLabel, fig, plotRange, minFraction, maxFraction, xrange, defaultFractions,ymin,ymax,
		defaultIndices},

	(* INITIALIZATION *)
	defPeaks= (OverlappingPeaks/.resolvedOps);
	If[Or[defPeaks===Null,(Position/.defPeaks)==={Null}],
		defPeaks=Null;
	];
	plotLabel = ToString[dataRef /. Null -> ""];

	fig = Which[
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
	];

	plotRange = PlotRange/.AbsoluteOptions[fig,PlotRange];
	{ymin,ymax} = plotRange[[2]];

	{minFraction, maxFraction}=If[fracsCollected==={},
		plotRange[[1]],
		{Min[fracsCollected[[All,1]]],Max[fracsCollected[[All,2]]]}
	];

	xrange = Unitless[Lookup[resolvedOps,Domain],Units[chromatogram[[1,1]]]];
	(*Selects fractions where peaks have been recognized*)
	defaultFractions = calculatePickedFractions[{{fracsCollected,fracsPicked},resolvedOps}];

	(*a fraction must be totally outside of the range to not be displayed*)
	If[Length[defaultFractions]>0,
		defaultFractionsDomain = Select[defaultFractions,(#[[2]]>=Min[xrange])&&(#[[1]]<=Max[xrange])&],
		defaultFractionsDomain = {}
	];

	(* indices of fractions selected by default. Need this for click-adding and -removing *)
	defaultIndices = Flatten[{Map[Position[fracsCollected,#]&,defaultFractionsDomain]}];

	If[MatchQ[fracsCollected,{}|{{Null,Null,Null}}],
		Return[fig]
	];
	(*
		- When the app is loaded in command center, dv must be stored as a kernel variable and NOT
			a dynamicmodule variable for things to work. However, this means the graphic will cease to
			function after a kernel restart
		- Therefore, switch on $ECLApplication
			- If $CommandCenter, then dv lives in the kernel
			- Otherwise, dv is a DynamicModule variable
	*)

	(* initialize *)
	zoomableInitialization[dv,plotRange];

	staticFigure = Unzoomable[ECL`PlotFractions[fracsCollected, defaultFractionsDomain, fig, Range->Null,FractionLabels->fractionLabels, Zoomable->False]];

	internalVariables = {
		IncludeInternal->{},
		ExcludeInternal->{},
		OldInclude -> Replace[Lookup[resolvedOps,Include],Null->{}],
		OldExclude -> Replace[Lookup[resolvedOps,Exclude],Null->{}],
		Defaults -> defaultIndices,
		FractionsCollected -> fracsCollected
	};

	epilogPrimitives = {
		fractionRectanglePrimitives,
		zoomablePrimitives,
		domainSliderPrimitives
	};

	eventActions = {
		zoomableEventActions,
		domainSliderEventActions,
		{"MouseClicked",2,"ShiftKey"} ->	fractionIncludeExclude
	};

	makeInteractivePreviewXY[
		AnalyzeFractions,
		chromatogram,
		staticFigure,
		resolvedOps,
		internalVariables,
		eventActions,
		epilogPrimitives
	]

];


fractionRectanglePrimitives[dv_Symbol]:=With[{fc=dv[FractionsCollected]},
	MapThread[
	{
		If[MemberQ[dv[IncludeInternal],#2], RGBColor[0, 0.5, 0], Red],
		(* change opacity if state different from default *)
		If[MemberQ[Union[dv[IncludeInternal],dv[ExcludeInternal]],#2],Opacity[0.5], Opacity[0]],
		Rectangle[{#1[[1]],PreviewValue[dv,YMin,YUnit]},{#1[[2]],PreviewValue[dv,YMax,YUnit]}]
	}&,
	{fc,Range[Length[fc]]}
	]
];

fractionIncludeExclude[dv_Symbol]:=With[{xpos=First[MousePosition["Graphics"],Null]},
	Module[{ind,clicked,tmp,wasPicked,newInclude,newExclude},
		(* index of clicked fraction *)
		ind = First@FirstPosition[Map[Between[xpos,#]&,dv[FractionsCollected][[;;,1;;2]]],True,{Null}];

		dv[Clicked]=ind; (* just logged for debugging *)
		(* start off with the things from the option and any pending changes from previous clicks *)
		newInclude = Union[dv[OldInclude],dv[IncludeInternal]];
		newExclude = Union[dv[OldExclude],dv[ExcludeInternal]];

		Which[
			(* clicked fraction already in Include list => remove it and add to exclude *)
			MemberQ[newInclude, ind],
				dv[OldInclude] = DeleteCases[dv[OldInclude],ind];
				dv[IncludeInternal] = DeleteCases[dv[IncludeInternal],ind];
				dv[ExcludeInternal] = Append[dv[ExcludeInternal],ind];,
			(* clicked fraction already in Exclude list => remove it and add to include *)
			MemberQ[newExclude,ind],
				dv[OldExclude] = DeleteCases[dv[OldExclude],ind];
				dv[ExcludeInternal] = DeleteCases[dv[ExcludeInternal],ind];
				dv[IncludeInternal] = Append[dv[IncludeInternal],ind];,
			(* clicked fraction already selected in defaults => add to Exclude list *)
			MemberQ[dv[Defaults], ind],
				dv[ExcludeInternal] = Append[dv[ExcludeInternal],ind];,
				dv[Defaults] = DeleteCases[dv[Defaults],ind];
			(* clicked fraction not assigned, add it to include *)
			True,
				dv[IncludeInternal] = Append[dv[IncludeInternal],ind];
		];

		newInclude = Union[dv[OldInclude],dv[IncludeInternal]];
		newExclude = Union[dv[OldExclude],dv[ExcludeInternal]];

		If[ind=!=Null,
			(* update Include & Exclude options *)
			{
				Include->{Replace[DeleteCases[newInclude,Null],{}->Null]},
				Exclude->{Replace[DeleteCases[newExclude,Null],{}->Null]}
			},
			{}
		]
	]
]



(* ::Subsection::Closed:: *)
(*analyzeFractionsResult*)


analyzeFractionsPacket[KeyValuePattern[{
	Packet->packet_,
	ResolvedInputs -> KeyValuePattern[{Collected->collected_, Picked->picked_}],
	UnresolvedInputs -> KeyValuePattern[{FractionData->fd_}],
	ResolvedOptions -> ro_
}]]:=analyzeFractionsPacket[packet, collected, picked, ro, fd];
analyzeFractionsPacket[standardFieldsStart_, fracsCollected_, fracsPicked_, resolvedOps_, in_] := Module[
	{fracs, fracsPackets, uploadedPackets},

	fracs = calculatePickedFractions[{{fracsCollected, fracsPicked}, Normal@resolvedOps}];
	fracsPackets = formatFractionsPacket[Normal@standardFieldsStart, {{fracsCollected, fracsPicked}, Normal@resolvedOps}, fracs, in];

	<|
		Packet -> fracsPackets
	|>

];


(* ::Subsection::Closed:: *)
(*Resolution*)


(* ::Subsubsection::Closed:: *)
(*resolveAnalyzeFractionsListInput*)


resolveAnalyzeFractionsListInput[prot:ObjectP[{Object[Protocol,HPLC],Object[Protocol,FPLC]}]]:=
		Cases[Download[prot,Data[Object]],ObjectReferenceP[Object[Data,Chromatography]]];
resolveAnalyzeFractionsListInput[other_]:= other;



(* ::Subsubsection::Closed:: *)
(*analyzeFractionsParseInput*)

Options[analyzeFractionsParseInput] = {Reuse->False,Labels->Null};

analyzeFractionsParseInput[KeyValuePattern[{
	UnresolvedInputs->KeyValuePattern[{FractionData->fractionData_}],
	Batch->True
}]]:= Module[{fd,out},

	fd = fractionData;
	If[MatchQ[fd, ObjectP[{Object[Protocol,HPLC],Object[Protocol,FPLC]}]],
		fd = Cases[Download[fd,Data[Object]],ObjectReferenceP[Object[Data,Chromatography]]];
	];

	out = analyzeFractionsParseInput /@ fd;

	BatchTranspose[out]
];


analyzeFractionsParseInput[fracsCollected:{FractionP..}] := KeyValuePattern[{
	ResolvedInputs -> KeyValuePattern[{
		Collected -> Unitless /@ fracsCollected,
		Picked -> {},
		DataReference -> Null,
		Chromatogram -> {},
		Labels -> Null
	}]
}];

analyzeFractionsParseInput[fracsObj:ObjectP[Object[Analysis, Fractions]]]:=analyzeFractionsParseInput[Download[fracsObj,Reference[[-1]][Object]],Reuse->True];

analyzeFractionsParseInput[obj:(ObjectReferenceP[Object[Data,Chromatography]]|LinkP[Object[Data,Chromatography]])]:=Module[{pac,fractionsPicked,samplesOut,fracObj},
	(* Because both Absorbance and Fluorescence can be used for fraction collection, download data for both and also FractionCollectionDetector *)
	{pac,fracObj, fractionsPicked,samplesOut} = Quiet[Download[obj, {Packet[Object, Absorbance, Fluorescence,Fractions, FractionCollectionDetector],FractionPickingAnalysis[[-1]],FractionPickingAnalysis[[-1]][FractionsPicked], SamplesOut[Object]}],{Download::Part}];
	pac[FractionsPicked] = fractionsPicked;
	pac[FractionPickingAnalysis] = {fracObj};
	analyzeFractionsParseInput[pac,Labels->samplesOut,Reuse->False]
];

analyzeFractionsParseInput[inf: PacketP[Object[Data, Chromatography]],OptionsPattern[]]:=Module[
	{fracID,fractionCollectionDetector,collected,picked, dataRef, fractionLabels, reuse, labels, chromatogram},
	{reuse, labels} = OptionValue[{Reuse,Labels}];
	fracID=FractionPickingAnalysis/.inf;

	collected = Lookup[Lookup[inf,Fractions,<||>],{CollectionStartTime,CollectionEndTime,Position}];
	(*Look up fractions, but if anything is missing default it to $Failed*)
	collected = Lookup[Lookup[inf,Fractions,<||>],{CollectionStartTime,CollectionEndTime,Position}, $Failed];

	(*If there is a failure in collected, return an error*)
	If[MemberQ[collected, $Failed],

		(*Send error about where $Failed was found with collected fractions*)
		Message[Error::MissingCollectedFractions, Pick[{CollectionStartTime, CollectionEndTime, Position}, MatchQ[#, $Failed] & /@ collected]];
		Return[$Failed]

	];

	(*check which channel is used for FractionCollection*)
	fractionCollectionDetector=Lookup[inf,FractionCollectionDetector,Null];

	(*take the chromatogram*)
	chromatogram=If[MatchQ[fractionCollectionDetector,Fluorescence],
		Fluorescence/.inf,
		Absorbance/.inf
	];

	picked=If[Or[MatchQ[fracID,Null | {}],!TrueQ[reuse]],
			{},
			inf[FractionsPicked]
	];
	picked = Replace[picked,{{Null,Null,Null}}->{}];
	dataRef = Object /. inf;
	fractionLabels = If[labels===Null,
		Download[dataRef, SamplesOut[Object]],
		labels
	];
	<| ResolvedInputs -> <|
		Collected -> Unitless /@ collected,
		Picked -> Unitless /@ picked,
		DataReference -> dataRef,
		Chromatogram -> chromatogram,
		Labels -> fractionLabels
	|>|>
];


(* ::Subsubsection::Closed:: *)
(*resolveAnalyzeFractionOptionPeaks*)


resolveAnalyzeFractionOptionPeaks[pks:Null,dataRef_]:=pks;
resolveAnalyzeFractionOptionPeaks[obj:ObjectP[Object[Analysis, Peaks]],dataRef_]:=Quiet[Download[obj,Evaluate[Packet @@ PeaksFields]],Download::MissingField];
resolveAnalyzeFractionOptionPeaks[Automatic,dataRef:ObjectP[Object[Data, Chromatography]]]:=downloadPeaksFromData[dataRef,AbsorbancePeaksAnalyses]/.{$Failed->Null};


(* ::Subsubsection::Closed:: *)
(*resolveFractionsInputLinks*)


resolveFractionsInputLinks[fracsCollected:{FractionP..},fracsPicked:{{Null,Null,Null}}]:=Null;
resolveFractionsInputLinks[fracsCollected:{FractionP..},fracsPicked:Null]:={Null};
resolveFractionsInputLinks[fracsCollected:{FractionP..},fracsPicked:{FractionP...}]:=Null;
resolveFractionsInputLinks[fracsCollected:{FractionP..}]:=Null;
resolveFractionsInputLinks[fracsObj:ObjectP[Object[Analysis, Fractions]]]:=resolveFractionsInputLinks[Download[Last[Download[fracsObj,Reference]],Object]];
resolveFractionsInputLinks[obj:ObjectReferenceP[Object[Data,Chromatography]]]:=obj;
resolveFractionsInputLinks[link:LinkP[]]:=link[Object];
resolveFractionsInputLinks[inf: PacketP[Object[Data,Chromatography]]] := Object/. inf;


(* ::Subsection::Closed:: *)
(*calculate*)


(* ::Subsubsection::Closed:: *)
(*calculatePickedFractions*)


(* pick out desireresolveAnalyzeFractionsOptionsd fractions *)
calculatePickedFractions[{{fracsCollected:(Null|{}),fracsPicked_},resolvedOps_}]:=Null;
calculatePickedFractions[{{fracsCollected_,fracsPicked:Null},resolvedOps_}]:=Null;
calculatePickedFractions[{{fracsCollected_,fracsPicked_},resolvedOps:Null}]:=Null;
calculatePickedFractions[{{fracsCollected:{FractionP..},fracsPicked:{FractionP...}},resolvedOps_List}]:=Module[
	{resolvedFracsPicked, fracsOutsideDomain,fracsToExclude,fracsToInclude,include,exclude,findFractionsOutsideRange,findFractionsInsideRange},

	resolvedFracsPicked = resolvePickedFractions[fracsCollected, fracsPicked, resolvedOps];

	(* filter fractions outside range *)
	findFractionsOutsideRange[range:((List|Span)[_?TimeQ,_?TimeQ])]:=findFractionsOutsideRange[Unitless[#,Minute]&/@range];
	findFractionsOutsideRange[frac:FractionP]:=findFractionsOutsideRange[Most[frac]];
	findFractionsOutsideRange[range:((List|Span)[_?NumericQ,_?NumericQ])]:=Select[fracsCollected,!overlappingIntervalQ[Most[#],Span@@range]&];
	findFractionsOutsideRange[_]:={};
	findFractionsOutsideRange[{val_}]:=findFractionsOutsideRange[val];
	fracsOutsideDomain = findFractionsOutsideRange[Domain/.resolvedOps];

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
	exclude = DeleteCases[DeleteDuplicates[ToList[(Exclude/.resolvedOps)/.Null->{}],Except[FractionP,_List]],Null,{1}];
	include = DeleteCases[DeleteDuplicates[ToList[(Include/.resolvedOps)/.Null->{}],Except[FractionP,_List]],Null,{1}];

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
resolvePickedFractions[fracsCollected:{FractionP..},fracsPicked:{FractionP..},resolvedOps_List]:=fracsPicked;
resolvePickedFractions[fracsCollected:{FractionP...},Null,resolvedOps_List]:=fracsCollected;
resolvePickedFractions[fracsCollected:{FractionP...},{},resolvedOps_List]:=Module[{fracsPeaks,pkLength,numPeaksToUse,allPeaks,getPeakLength,getNumberOfPeaksToUse,getFractionsFromOverlappingPeaks},

	(* pull peaks from options *)
	allPeaks = OverlappingPeaks/.resolvedOps;

	(* number of peaks *)
	getPeakLength[peakList_Association]:=Length[peakList[Position]];
	getPeakLength[_]:=0;
	pkLength = getPeakLength[allPeaks];

	(* number of peaks to use *)
	getNumberOfPeaksToUse[All|(_Integer?(#>pkLength&))]:=pkLength;
	getNumberOfPeaksToUse[numPeaks_Integer?(#<=pkLength&)]:=numPeaks;
	getNumberOfPeaksToUse[_]:=0;
	numPeaksToUse = getNumberOfPeaksToUse[TopPeaks/.resolvedOps];

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

	getFractionsFromOverlappingPeaks[allPeaks,numPeaksToUse]
];


(* check of two intervals overlap *)
overlappingIntervalQ[{a_?NumberQ,b_?NumberQ},{}]:=False;
(*overlappingIntervalQ[{a_?NumberQ,b_?NumberQ},{c_?NumberQ,d_?NumberQ}]:=Or[a<=c<b,a<=d<b,c<=a<d];*)
overlappingIntervalQ[{a_?NumberQ,b_?NumberQ},Span[c_?NumberQ,d_?NumberQ]]:=Or[a<=c<b,a<=d<b,c<=a<d];
overlappingIntervalQ[{a_?NumberQ,b_?NumberQ},intervals:{{_?NumberQ,_?NumberQ}|Span[_?NumberQ,_?NumberQ]..}]:=Or@@Map[overlappingIntervalQ[{a,b},#]&,intervals];
overlappingIntervalQ[{a_?NumberQ,b_?NumberQ},c_?NumberQ]:=(a<=c<b);
overlappingIntervalQ[{a_?NumberQ,b_?NumberQ},list:{_?NumberQ..}]:=Or@@Map[overlappingIntervalQ[{a,b},#]&,list];

overlappingFraction[fracs:{{_?NumberQ,_?NumberQ,_String}..},c_?NumberQ]:=FirstOrDefault[Select[fracs,overlappingIntervalQ[#[[1;;2]],c]&]];


(* ::Subsection::Closed:: *)
(*formatting*)


(* ::Subsubsection:: *)
(*formatFractionsPacket*)


formatFractionsPacket[startFields_,{{fracsCollected_,_}, resolvedOps_}, fracsFinal:Null, in_]:=Null;
formatFractionsPacket[startFields_,{{fracsCollected:{FractionP..},_}, resolvedOps_List}, fracsFinal:{FractionP...}, in_]:=Module[
	{inputLink, prot, sampleIn, fracPacket, finalPacket},

	inputLink = resolveFractionsInputLinks[in];

	sampleIn = FirstOrDefault[Download[inputLink,SamplesIn]];
	sampleIn = If[MatchQ[sampleIn, ObjectP[]], Download[sampleIn,Object], {}];

	fracPacket = Association[Join[
		{Type -> Object[Analysis, Fractions]},
		startFields,
			{
				ResolvedOptions -> resolvedOps,
				Replace[Reference]->{Link[inputLink, FractionPickingAnalysis]},
				Replace[FractionsPicked]->Replace[fracsFinal,{}->{{Null,Null,Null}}],
				FractionsCollected :> Evaluate[fracsCollected],
				Replace[FractionatedSamples]->{Link[sampleIn]}
			}]
		];

	samplesCollected = Download[inputLink, SamplesOut];

	samplesPicked = samplesPickedFromFractions[samplesCollected,fracsCollected,fracsFinal];

	If[Length[samplesPicked] > 0,
		fracPacket[Replace[SamplesPicked]] = Map[Link[#[Object]]&,samplesPicked],
		fracPacket[Replace[SamplesPicked]] = {}
	];

	fracPacket
];


(* ::Subsubsection::Closed:: *)
(*samplesPickedFromFractions*)


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
