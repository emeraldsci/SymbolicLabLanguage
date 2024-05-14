
(* ::Subsection::Closed:: *)
(*App*)


(* ::Subsubsection::Closed:: *)
(*fractionsApp*)


fractionsApp[fracsCollected:{FractionP...},fracsPicked:{FractionP...},resolvedOps_List,chromatogram_,fractionLabels_, dataRef_]:=
	Module[{maxFraction,minFraction,plotRange,defPeaks,fig,defaultFractions,fracs,xrange,includes={},excludes={},outputOptions, plotLabel,
		displayPanel,controlPanel},


	outputOptions[]:=ReplaceRule[resolvedOps,{
		Domain->xrange,
		Include->includes,
		Exclude->excludes
	}];

	displayPanel[]:=Panel[If[fracsCollected==={},
		fig,
		EventHandler[
			Dynamic[
				(*a fraction must be totally outside of the range to not be displayed*)
				fracs=Select[fracs,(#[[2]]>=Min[xrange])&&(#[[1]]<=Max[xrange])&];
				ECL`PlotFractions[fracsCollected, fracs, fig, Range->xrange,FractionLabels->fractionLabels]
			],
			{{"MouseClicked",2}:>(With[{ovfrac=overlappingFraction[fracsCollected,First[MousePosition["Graphics"]]]},
				Which[
					MemberQ[excludes,ovfrac],(excludes=Complement[excludes,{ovfrac}];includes=Append[includes,ovfrac];),
					MemberQ[defaultFractions,ovfrac],(excludes=Append[excludes,ovfrac];includes=Complement[includes,{ovfrac}]),
					MemberQ[includes,ovfrac],(excludes=Append[excludes,ovfrac]; includes=Complement[includes,{ovfrac}];),
					True,Null
				];
				fracs = calculatePickedFractions[{{fracsCollected,fracs},outputOptions[]}];
				]
			)}
		]
	]];

	controlPanel[]:=Panel[If[fracsCollected=!={},Grid[{
		{Column[{"Fraction range",IntervalSlider[Dynamic[xrange,{(xrange=#)&,(xrange=#; includes=Select[includes,Function[fr,overlappingIntervalQ[Most[fr],{Span@@#}]]])&}],{minFraction,maxFraction},ImageSize->{170,Automatic}]},Center]},
		{},
		{Button["Reset All",fracs=defaultFractions;includes={}; excludes=Complement[fracsCollected,defaultFractions];xrange={minFraction,maxFraction},ImageSize->{90,40}]},
		{Button["Reset\nHighlights",fracs=defaultFractions;includes={}; excludes=Complement[fracsCollected,defaultFractions];,ImageSize->{90,48}]},
		{Button["Deselect All\nFractions",fracs={};includes={}; excludes=fracsCollected;,ImageSize->{90,48}]},
		{Button["Select All\nFractions",includes=Select[fracsCollected,overlappingIntervalQ[Most[#],{Span@@xrange}]&]; excludes={}; fracs=includes ;,ImageSize->{90,48}]},{Null}
		},Spacings->{1,1}],""],ImageSize->{200,420}
	];


	(* INITIALIZATION *)
	defPeaks= (OverlappingPeaks/.resolvedOps);
	If[Or[defPeaks===Null,(Position/.defPeaks)==={Null}],
		defPeaks=Null;
	];

	plotLabel = ToString[dataRef /. Null -> ""];

	fig=Which[
		(* no fractions, no chromatograph *)
		And[fracsCollected==={},chromatogram===Null],
			Unzoomable[ECL`PlotChromatography[{{0,0.},{1,0.}}], PlotLabel -> plotLabel],
		(* no fractions, yes chromatograph *)
		fracsCollected==={},
			Unzoomable[ECL`PlotChromatography[chromatogram], PlotLabel -> plotLabel],
		(* yes fractions, no chromatograph *)
		chromatogram===Null,
			Unzoomable[ECL`PlotChromatography[{{Min[fracsCollected[[All,1]]],0.},{Max[fracsCollected[[All,2]]],0.}}, PlotLabel -> plotLabel]],
		(* fractions & chromatograph *)
		True,
			Unzoomable[ECL`PlotChromatography[chromatogram,Display -> {Peaks},Peaks->defPeaks, PlotLabel -> plotLabel]]
	];

	plotRange=PlotRange/.AbsoluteOptions[fig,PlotRange];

	{minFraction,maxFraction}=If[fracsCollected==={},
		plotRange[[1]],
		{Min[fracsCollected[[All,1]]],Max[fracsCollected[[All,2]]]}
	];
	xrange={minFraction,maxFraction};

	(*Selects fractions where peaks have been recognized*)
	defaultFractions = calculatePickedFractions[{{fracsCollected,fracsPicked},outputOptions[]}];
	excludes=Complement[fracsCollected,defaultFractions];


	(*Set locators for fraction range*)
	fracs=defaultFractions;

	makeAppWindow[
		DisplayPanel -> displayPanel[],
		ControlPanel -> controlPanel[],
		Return :> outputOptions[],
		ReturnOptions -> {FractionsPicked, FractionsCollected, SamplesPicked, TheoreticalFractionVolumes},
		Cancel -> $Canceled,
		Skip -> Null,
		WindowSize->{875,545},
		WindowTitle->"Fractions App",
		AppTest->(AppTest/.resolvedOps)
	]


]



(* ::Subsection::Closed:: *)
(*AnalyzeFractionsApp*)


(* ::Subsubsection::Closed:: *)
(*AnalyzeFractionsApp*)


DefineOptions[AnalyzeFractionsApp,
	Options :> {
		{OverlappingPeaks -> Automatic, ObjectP[Object[Analysis,Peaks]] | Automatic | Null, "Selects fractions that overlap with the largest peaks.  If Peaks is Null, all fractions are returned.  The TopPeaks option determines how many of the largest peaks will be used."},
		{TopPeaks -> 1, None | All | _Integer?Positive, "Determines which peaks will be used in the first step of fraction filtering.  If TopPeaks ->n_Integer, then the n largest peaks (by area) will be used."},
		{Include -> {}, Null|(_?NumberQ | _?TimeQ | _Integer | {_?NumericQ, _?NumericQ, _String} | _Span) | {(_?NumberQ | _?TimeQ | _Integer | {_?NumericQ, _?NumericQ, _String} | _Span)...}, "Explicitly specify fractions to select.  Fractions can be specified as a fraction {startTime,endTime,well}, as a position index in the FractionsCollected list, or as a time point between the startTime and endTime."},
		{Exclude -> {}, Null|(_?NumberQ | _?TimeQ | _Integer | {_?NumericQ, _?NumericQ, _String} | _Span) | {(_?NumberQ | _?TimeQ | _Integer | {_?NumericQ, _?NumericQ, _String} | _Span)...}, "Explicitly specify fractions to exclude.  Fractions can be specified as a fraction {startTime,endTime,well}, as a position index in the FractionsCollected list, or as a time point between the startTime and endTime."},
		{Domain -> All, All | DomainP[_?TimeQ] | DomainP[_?NumericQ], "Automatically exclude any fractions not fully inside specified domain interval."},
		{Output -> SamplesPicked, Packet | Object | FieldP[Object[Analysis,Fractions],Output->Short] | {FieldP[Object[Analysis,Fractions],Output->Short]..}, "Determines which field(s) are returned by the function."},
		{Options -> Null, Null | ObjectP[Object[Analysis,Fractions]], "Use ResolvedOptions in given object for default option resolution in current analysis."},
		{App -> True, BooleanP, "Launches interactive app."},
		{Upload->True,BooleanP,"Upload result to database.",Category->Hidden},
		{OutputAll->False,BooleanP,"If True, also returns any other objects that were created or modified.",Category->Hidden},
		{ApplyAll->False,BooleanP,"If True, applies first set of resolved options to all remaining data sets.",Category->Hidden},
		{AppTest->False,BooleanP|Null|Cancel|Skip|Return,"If True, bypasses app, used for testing app buttons.",Category->Hidden},
		{Index->{1,1},_,"Current evaluation index, used for monitoring position in list input for app display.",Category->Hidden}
	}
];

AnalyzeFractionsApp::InvalidPosition="There is no fraction at position `1`.  Only `2` fractions were collected.";


inputPatternAnalyzeFractionsPOld = Alternatives[
	(Null|ObjectP[Object[Data, Chromatography]]|ObjectP[Object[Analysis, Fractions]]),
	ObjectP[Object[Data, Chromatography]],
	ObjectP[Object[Analysis, Fractions]]
];


listInputPatternAnalyzeFractionsPOld = Alternatives[
	{inputPatternAnalyzeFractionsPOld..},
	ObjectP[Object[Protocol, HPLC]],
	ObjectP[Object[Protocol, FPLC]]
];


AnalyzeFractionsApp[in: inputPatternAnalyzeFractionsPOld, ops: OptionsPattern[]] :=
	With[
		{tempOut = AnalyzeFractionsApp[{in}, ops]},
		If[MatchQ[tempOut,  Null | $Failed | $Canceled],
			Return[tempOut],
			First[tempOut]
		]
	];




AnalyzeFractionsApp[in: listInputPatternAnalyzeFractionsPOld, ops: OptionsPattern[]] := Block[
	(* 
		the dynamics in this app were hitting PlotFractions a bunch which is traced, 
		which was causing major slowdown to the interactivity.
		For now, just turn it off completely once we get inside the app.	
	*)
	{ECL`Web`$ECLTracing=False},
	Module[
	{
		inList, standardFieldsStart, resolvedStuff, inputLinks,
		uploadedPackets, fractionPackets, fracsFinal, safeOps
	},

	inList = resolveAnalyzeFractionsListInput[in];

	standardFieldsStart = analysisPacketStandardFieldsStart[{ops}];

	safeOps = safeAnalyzeOptions[AnalyzeFractionsApp,{ops}];

	(* { {{fracsCollected, fracsPicked}, resolvedOps} .. } *)
	resolvedStuff = appMapWrapper[resolveAnalyzeFractionsInputsAndOptionsOld,Last,inList,safeOps];

	If[MatchQ[resolvedStuff,$Failed|$Canceled],
		Return[resolvedStuff]
	];

	inputLinks = resolveFractionsInputLinks/@inList;

	fracsFinal=Map[calculatePickedFractions,resolvedStuff];

	fractionPackets = MapThread[
		formatFractionsPacketOld[standardFieldsStart,#1,#2,#3]&,
		{resolvedStuff,fracsFinal,inputLinks}
	];

	uploadedPackets = uploadAnalyzePackets[fractionPackets];

	returnAnalyzeValue[uploadedPackets]

]];



(* ::Subsubsection::Closed:: *)
(*resolveAnalyzeFractionsInputsAndOptionsOld*)


resolveAnalyzeFractionsInputsAndOptionsOld[in_,safeOps_List]:=Module[
	{dataRef,collected,picked,resolvedOps,chromatogram,fractionLabels},

	{{collected,picked},dataRef,chromatogram} = resolveAnalyzeFractionInputsOld[in];

	If[MatchQ[chromatogram,Null|$Failed],
		Return[$Failed];
	];

	{collected, picked, chromatogram} = {Unitless@collected, Unitless@picked, chromatogram};

	resolvedOps=ReplaceRule[
		safeOps,
		{
			OverlappingPeaks -> resolveAnalyzeFractionOptionPeaks[Lookup[safeOps,OverlappingPeaks],dataRef]
		}
	];

	If[MatchQ[collected,Null|{}|{{Null,Null,Null}}],Return[{{Null,Null},Null}]];

	If[TrueQ[App/.resolvedOps],
		fractionLabels = Download[Download[dataRef, SamplesOut],Object];

		resolvedOps = Quiet@fractionsApp[collected,picked,resolvedOps,chromatogram,fractionLabels, dataRef];

	];

	{{collected,picked},resolvedOps}

];



(* ::Subsubsection::Closed:: *)
(*resolveAnalyzeFractionInputsOld*)


resolveAnalyzeFractionInputsOld[fracsCollected:{FractionP..}]:={{fracsCollected,{}},{},Null};
resolveAnalyzeFractionInputsOld[fracsObj:ObjectP[Object[Analysis, Fractions]]]:=resolveAnalyzeFractionInputsOld[Download[Download[Last[Download[fracsObj,Reference]],Object], Packet[Absorbance, Fluorescence, FractionCollectionDetector, FractionPickingAnalysis, Fractions, FractionsPicked]],True];
resolveAnalyzeFractionInputsOld[obj:(ObjectReferenceP[Object[Data,Chromatography]]|LinkP[Object[Data,Chromatography]])]:=resolveAnalyzeFractionInputsOld[Download[obj, Packet[Absorbance, Fluorescence, FractionCollectionDetector, FractionPickingAnalysis, Fractions, FractionsPicked]]];
resolveAnalyzeFractionInputsOld[inf: PacketP[Object[Data, Chromatography]]]:=resolveAnalyzeFractionInputsOld[inf,False];
resolveAnalyzeFractionInputsOld[inf: PacketP[Object[Data, Chromatography]],reuse_]:=Module[{fracID,collected,picked,fractionCollectionDetector,chromatogram},
	fracID=FractionPickingAnalysis/.inf;
	collected=(Fractions/.inf)/.{x_Association :> Values[x][[{4, 5, 3}]]};
	picked=If[Or[MatchQ[fracID,Null | {}],!TrueQ[reuse]],
			{},
			Download[LastOrDefault[fracID], FractionsPicked]
	];
	picked = Replace[picked,{{Null,Null,Null}}->{}];
	fractionCollectionDetector = Lookup[inf,FractionCollectionDetector,Null];
	chromatogram = If[MatchQ[fractionCollectionDetector,Fluorescence],
		(Fluorescence/.inf),
		(Absorbance/.inf)
	];
	{{collected,picked},Object/.inf,chromatogram}
];


(* ::Subsubsection::Closed:: *)
(*formatFractionsPacketOld*)


formatFractionsPacketOld[startFields_,{{fracsCollected_,_}, resolvedOps_}, fracsFinal:Null, inputLink_]:=Null;
formatFractionsPacketOld[startFields_,{{fracsCollected:{FractionP..},_}, resolvedOps_List}, fracsFinal:{FractionP...}, inputLink:(Null|ObjectReferenceP[Object[Data,Chromatography]])]:=Module[
	{prot,sampleIn,samplesCollected,samplesPicked,updatePackets, fracPacket},

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
		}
	]
  ];

	samplesCollected = Download[inputLink, SamplesOut];

	samplesPicked = samplesPickedFromFractions[samplesCollected,fracsCollected,fracsFinal];

	If[Length[samplesPicked] > 0,
		fracPacket[Replace[SamplesPicked]] = Map[Link[#[Object]]&,samplesPicked],
		fracPacket[Replace[SamplesPicked]] = {}
	];

	fracPacket

]
