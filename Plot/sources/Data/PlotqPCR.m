(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotqPCR*)


(* ::Subsubsection::Closed:: *)
(*PlotqPCR Options and Messages*)


DefineOptions[PlotqPCR,
	optionsJoin[
		generateSharedOptions[
			Object[Data, qPCR],
			AmplificationCurves,
			PlotTypes -> {LinePlot},
			CategoryUpdates -> {
				PrimaryData -> "Hidden",
				SecondaryData -> "Hidden",
				Display -> "Hidden",
				IncludeReplicates -> "Hidden",
				TargetUnits -> "Hidden",
				OptionFunctions -> "Hidden",
				Boxes -> "Hidden",
				AmplificationCurves -> "Hidden",
				AmplificationReadTemperature -> "Hidden",
				MeltingCurves -> "Hidden",
				Primers -> "Hidden",
				RawAmplificationCurves -> "Hidden",
				RawMeltingCurves -> "Hidden",
				FrameLabel -> "Hidden",
				PlotLabel -> "Hidden",
				Zoomable -> "Hidden",
				Legend -> "Hidden",
				LegendPlacement -> "Hidden"
			}
		],
		Options :> {
			{
				OptionName -> BaselineDomain,
				Default -> Automatic,
				Description -> "The baseline range to use for baseline subtraction.",
				ResolutionDescription -> "Automatically set to BaselineDomain from the most recent quantification cycle analysis object, or {3 Cycle, 15 Cycle} otherwise.",
				AllowNull -> False,
				Widget -> {
					"Baseline Start Cycle" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Cycle, 1 Cycle], Units -> {Cycle, {Cycle}}],
					"Baseline End Cycle" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Cycle, 1 Cycle], Units -> {Cycle, {Cycle}}]
				},
				Category -> "Data Specifications"
			},
			{
				OptionName -> CurveType,
				Default -> PrimaryAmplicon,
				Description -> "The quantitative polymerase chain reaction (qPCR) curve type(s) to include in the plot.",
				AllowNull -> False,
				Widget -> Widget[Type -> MultiSelect, Pattern :> DuplicateFreeListableP[PrimaryAmplicon | EndogenousControl | PassiveReference]],
				Category -> "Data Specifications"
			}
		}
	],
	SharedOptions :> {
		EmeraldListLinePlot
	}
];

Error::NoqPCRMeltingCurveData= "The inputs at indices `1` do not contain melting curve data for qPCR. If the input is Object[Data, qPCR], please confirm that the MeltingCurves field is populated. If the input is Object[Analysis, MeltingPoint] please confirm that it was generated from Object[Data, qPCR] by checking the Reference Field.";


(* ::Subsubsection:: *)
(*PlotqPCR Source Code*)


(*Function definition accepting one or more sets of raw data points*)
PlotqPCR[
	primaryData : rawPlotInputP,
	inputOptions : OptionsPattern[PlotqPCR]
] := rawToPacket[
	primaryData, Object[Data, qPCR],
	PlotqPCR,
	SafeOptions[PlotqPCR, ToList[inputOptions]]
];

(*Function definition accepting one or more objects*)
PlotqPCR[
	(*myDataObjs : plotInputP,*)
	myDataObjs : ListableP[ObjectP[Object[Data,qPCR]],2],
	inputOptions : OptionsPattern[PlotqPCR]
] := qPCRPacketToELLP[
	myDataObjs,
	PlotqPCR,
	{inputOptions}
];

(*Function definition accepting one or more objects*)
PlotqPCR[
	myDataObjs : ListableP[ObjectP[Object[Analysis, MeltingPoint]],2],
	inputOptions : OptionsPattern[PlotqPCR]
] := qPCRPacketToELLP[
	myDataObjs,
	PlotqPCR,
	(* for melting point analysis the data must be melting curves *)
	ReplaceRule[ToList[inputOptions], PrimaryData->MeltingCurves]
];


(*---qPCRPacketToELLP---*)

(*Function overload accepting one or more objects*)
qPCRPacketToELLP[
	objs : (ListableP[ObjectReferenceP[], 1] | ListableP[LinkP[], 1]),
	fnc_,
	inputOptions : {(_Rule | _RuleDelayed)...}
] := qPCRPacketToELLP[
	Download[objs],
	fnc,
	inputOptions
];

(*Function overload accepting doubly listed objects*)
qPCRPacketToELLP[
	objs : (ListableP[ObjectReferenceP[], {2}] | ListableP[LinkP[], {2}]),
	fnc_,
	inputOptions : {(_Rule | _RuleDelayed)...}
] := Module[{packets},

	packets = Download[Flatten[objs]];
	qPCRPacketToELLP[
		Map[Download[#, Cache -> Session]&, objs],
		fnc,
		inputOptions
	]
];

(*Function overload accepting a packet*)
qPCRPacketToELLP[
	initialPacket : packetOrInfoP[],
	fnc_,
	inputOptions : {(_Rule | _RuleDelayed)...}
] := qPCRPacketToELLP[
	{initialPacket},
	fnc,
	inputOptions
];

resolveOptions[fnc_, inputOptions_, initialPackets_]:= Module[
	{
		initialOps, opsWithDisplay, linkedObjects, linkedPackets,
		joinedPackets, overriddenPackets, optionsFunctions, newOptionRules,
		plotFunctionOps, userSpecifiedOptions, initialOpsNames, initialOpsValues,
		safeUserOptions, ops, positionsOfUserOps
	},
	
	(*Format options*)
	initialOps = Association[SafeOptions[fnc, ToList[inputOptions]]];
	initialOps[PrimaryData] = Flatten[{Lookup[initialOps, PrimaryData, {}]}];
	opsWithDisplay = Association[updateDisplayOptionsToShowSpecified[initialOps, First[Type /. initialPackets]]];
	
	(*Modify packets and list of packets to include linked and/or user specified data*)
	linkedObjects = DeleteDuplicatesBy[Cases[opsWithDisplay[LinkedObjects] /. initialPackets, ObjectP[], Infinity], #[Object]&];
	linkedPackets = DeleteDuplicatesBy[Download[linkedObjects], #[Object]&]; (*need this b/c duplicated objects can sneak into linkedObjects as objects vs links*)
	joinedPackets = Join[initialPackets, linkedPackets];
	overriddenPackets = overrideFieldsWithSpecified[joinedPackets, opsWithDisplay];
	
	(*Run functions to specially determine plot style options for a given parent plot type*)
	optionsFunctions = Lookup[opsWithDisplay, OptionFunctions, {}];
	
	newOptionRules = Flatten[#[overriddenPackets, opsWithDisplay]& /@ optionsFunctions, 1];
	
	plotFunctionOps = Association[ReplaceRule[Normal[opsWithDisplay], newOptionRules, Append -> False]];
	
	(*Ultimately override all options with safe user options.*)
	userSpecifiedOptions = inputOptions[[All, 1]];
	initialOpsNames = (Normal@initialOps)[[All, 1]];
	initialOpsValues = (Normal@initialOps)[[All, 2]];
	positionsOfUserOps = Flatten[Position[initialOpsNames, #]& /@ userSpecifiedOptions];
	safeUserOptions = Association[MapThread[(#1 -> #2)&, {initialOpsNames[[positionsOfUserOps]], initialOpsValues[[positionsOfUserOps]]}]];
	
	(*In an association with repeated keys, the last key-value pair is used*)
	ops = Join[plotFunctionOps, safeUserOptions];
	
	{initialOps, ops, overriddenPackets}
];


(* if the packets are melting point packets and reference qPCR, return them *)
getAnalysisPacket[initialPackets:ObjectP[Object[Analysis, MeltingPoint]]] := Module[
	{reference},
	
	(* find the packet reference *)
	(* string append/replace because sometimes we have a raw packet and sometimes a downloaded one *)
	reference = First[Lookup[
		Analysis`Private`stripAppendReplaceKeyHeads[initialPackets],
		Reference]
	];
	
	(* if the packet reference is not qPCR return failed *)
	If[MatchQ[reference, ObjectP[Object[Data, qPCR]]],
		initialPackets,
		$Failed
	]
];

(* if the initial packets are not analysis, calculate the analysis or follow the link *)
getAnalysisPacket[initialPackets_]:= Module[
	{
		analysisLink, analysisLinkQ
	},
	
	(* pull out analysis link *)
	analysisLink = Lookup[
		Analysis`Private`stripAppendReplaceKeyHeads[initialPackets],
		MeltingPointAnalyses
	];
	
	(* check if data object has analysis link *)
	analysisLinkQ = MatchQ[analysisLink, Except[Null|{}]];
	
	(* calculate the analysis packet or look up the link if it exists *)
	If[Not[analysisLinkQ],
		(* calculate a fresh packet *)
		Quiet[ECL`AnalyzeMeltingPoint[Lookup[initialPackets, Object], Upload->False]],
		
		(* use the most recent analysis link *)
		Download[First[analysisLink]]
	]
	
];

(* find the legend objects *)
legendObjects[initialPackets:ObjectP[Object[Analysis, MeltingPoint]]]:= Module[
	{reference},
	
	(* look up packet reference *)
	reference = Lookup[
		Analysis`Private`stripAppendReplaceKeyHeads[initialPackets],
		Reference
	];
	
	(* helper to pull reference object from link or list *)
	(* listedness depends on in the packet is downloaded or raw *)
	removeLink[ref_List]:= First[First[ref]];
	removeLink[ref_Link]:= First[ref];
	
	removeLink[reference]
];

legendObjects[initialPackets_]:=Lookup[initialPackets, Object];

(* Main function accepting a list of packets for melting curves *)
qPCRPacketToELLP[
	initialPackets : {packetOrInfoP[]..},
	fnc_,
	inputOptions : KeyValuePattern[{PrimaryData->MeltingCurves}]
]:= Module[
	{
		analysisLinkQ, analysisPackets, derivativeCurves, initialOps, ops,
		labelRule, legendRule, plotOptions, inputObjects,
		finalPlot, resolvedOptions, outputSpecification, failedPositions,
		maxDerivativeEpilog, maxPoints
	},
	
	(* check if data object has analysis link *)
	analysisLinkQ = False;
	
	(* calculate the analysis packet or look up the link if it exists *)
	analysisPackets = getAnalysisPacket/@initialPackets;
	
	(* add a warning for failed packets *)
	failedPositions = Flatten[Position[analysisPackets, $Failed]];
	If[Length[failedPositions]>0,
		Message[Error::NoqPCRMeltingCurveData, failedPositions]
	];
	
	(* keep the non-failed packets *)
	analysisPackets = Cases[analysisPackets, Except[$Failed]];
	
	(* if all packets failed return $Failed *)
	If[MatchQ[Length[analysisPackets], 0],
		Return[$Failed]
	];
	
	(* pull out the derivative curves *)
	derivativeCurves = Lookup[
		(* string append/replace because sometimes we have a raw packet and sometimes a downloaded one *)
		Analysis`Private`stripAppendReplaceKeyHeads[analysisPackets],
		MeltingCurvesDerivativePoints
	];
	
	(* resolve options *)
	{initialOps, ops}= Part[resolveOptions[fnc, inputOptions, initialPackets], {1,2}];
	
	(* resolve labels *)
	labelRule = If[ops[PlotLabel] === Automatic,
		
		Sequence@@{
			PlotLabel -> "Melting Curve Data",
			FrameLabel -> {"Temperature (\[Degree]C)", "-d(RFU) / dT"}
		},
		
		PlotLabel -> ops[PlotLabel]
	];
	
	(* pull out input objects and convert to objects for the legend *)
	inputObjects = legendObjects/@initialPackets;
	inputObjects = ToString/@inputObjects;
	
	(* delete the input objects of for failed packets *)
	inputObjects = Delete[inputObjects, List/@failedPositions];
	
	(*Define the Legend rule*)
	legendRule = If[Lookup[ops, Legend] === Automatic,
		Legend -> inputObjects,
		Legend -> Lookup[ops, Legend]
	];
	
	(* combine all options together *)
	plotOptions = Join[
		{
			labelRule,
			legendRule
		},
		FilterRules[Normal[ops], inputOptions],
		Normal[ops]
	];
	
	(* find the largest y-coordinate. use flatten to reduce one list *)
	maximalDerivativePoint[curve_] := First@MaximalBy[
		Flatten[QuantityMagnitude[curve], 1],
		Last
	];
	
	(* map over derivative curves *)
	maxPoints = maximalDerivativePoint/@derivativeCurves;
	
	pointPrimitive[point_] := {
		(* red point at max *)
		{
			(* directives *)
			Red, PointSize[0.015],
			(* primitives *)
			Point[point]
		},
		(* red dashed line down *)
		{
			(* directives *)
			Red, Thick, Dashed,
			(* primitives *)
			Line[{point, Scaled[{0, -1}, point]}]
		}
	};
	
	(* builds the mouse over epilog for a single max point on the derivative curve *)
	(* epilog that shows the max point as a red dot and shows the value when hovered over *)
	singleDerivativeEpilog[point_] := Module[
		{
			stringPoint
		},
		
		(* convert the point to a string *)
		stringPoint = ToString[
			(* add quiet for padding error *)
			Quiet[NumberForm[point[[1]], {4, 2}], {NumberForm::reqsigz}]
		];
		
		Mouseover[
			(*mouse off *)
			pointPrimitive[point],
			
			(* mouse on  *)
			{
				pointPrimitive[point],
				
				(* point text *)
				Text[
					(* string take to pull off the lists *)
					Framed[Style[stringPoint <> " \[Degree]C", FontSize->14]],
					(* show point below *)
					point,
					Background -> White
				]
			}
		]
	];
	
	maxDerivativeEpilog = singleDerivativeEpilog/@maxPoints;
	
	(* call ELLP on the derivative curves *)
	{finalPlot, resolvedOptions} = EmeraldListLinePlot[
		derivativeCurves,
		ReplaceRule[
			{stringOptionsToSymbolOptions[PassOptions[EmeraldListLinePlot, plotOptions]]},
			{
				Output -> {Result, Options},
				Epilog -> maxDerivativeEpilog
			}
		]
	];
	
	(*grab output option*)
	outputSpecification = Lookup[initialOps, Output];
	
	(* return output *)
	outputSpecification /. {
		Result -> finalPlot,
		Preview -> finalPlot,
		Tests -> {},
		Options -> resolvedOptions
	}
];


(*Main function accepting a list of packets for quantification cycles *)
qPCRPacketToELLP[
	initialPackets : {packetOrInfoP[]..},
	fnc_,
	inputOptions : {(_Rule | _RuleDelayed)...}
] := Module[
	{
		dataTypes, dataType, initialOps, overriddenPackets, ops,
		includeReplicates, replicates, primaryDataField, secondaryDataField, type, primaryMultipleQ, secondaryMultipleQ, primaryData, flatPrimaryData, secondaryDataRule, flatSecondaryDataRule,
		baselineDomain, curveTypes, curveIndexedFields, allCurveIndexedFields, curveTypePositions, specifiedCurveIndexedFields, threadedSpecifiedCurveIndexedFields,
		cqAnalysisObjects, cqAnalysisPackets, latestCqAnalyisPacket, resolvedBaselineDomain, smoothedCurves, curves, curvesInBaselineDomain, meanBaselineFluor, correctedFluor, correctedCurves, threadedCorrectedCurves,
		finiteDifferencesX, finiteDifferencesY, coordinatesX, finiteDerivatives, derivativeCurves, specifiedWavelengths, threadedSpecifiedWavelengths, specifiedWavelengthCqAnalysisPackets, specifiedWavelengthCnAnalysisPackets,
		flatThreadedCorrectedCurves, flatSpecifiedWavelengthCqValues, flatThreadedCorrectedCurveFuncs, flatSpecifiedWavelengthCqYValues, flatSpecifiedWavelengthCnValues, epilogRule,
		dataObjects, numberOfSpecifiedCurvesPerData, expandedDataObjects, expandedDataObjectsWithWavelengths, legendRule, imageRule, labelRule, ellpOps,
		outputSpecification, finalPlot, mostlyResolvedOptions, resolvedOps, finalResolvedOps
	},

	dataTypes = Lookup[#, Type]& /@ initialPackets;

	If[Length[DeleteDuplicates[dataTypes]] > 1,
		(
			Message[Warning::MixedDataTypes, dataTypes];
			Return[]
		),
		dataType = First[dataTypes]
	];
	
	{initialOps, ops, overriddenPackets}=resolveOptions[fnc, inputOptions, initialPackets];
	
	(*grab output option*)
	outputSpecification = Lookup[initialOps, Output];

	(*pull out the IncludeReplicates option and Replicates field*)
	(*somehow, sometimes the IncludeReplicates option isn't included at all and so we need to default to False if it isn't there*)
	includeReplicates = Lookup[ops, IncludeReplicates, False];
	replicates = Lookup[overriddenPackets, Replicates];

	(*figure out if each PrimaryData and SecondaryData fields are multiple or not*)
	{primaryDataField, secondaryDataField} = Lookup[ops, {PrimaryData, SecondaryData}, {}];
	type = Lookup[First[overriddenPackets], Type];
	primaryMultipleQ = Map[
		MatchQ[Lookup[LookupTypeDefinition[type, #], Format], Multiple]&,
		primaryDataField
	];
	secondaryMultipleQ = Map[
		MatchQ[Lookup[LookupTypeDefinition[type, #], Format], Multiple]&,
		secondaryDataField
	];

	(*--Pull core data set from packet--*)

	(*If IncludeReplicates is set to true, get the primary data in all associated Replicates*)
	primaryData = MapThread[
		If[includeReplicates && Not[MatchQ[#2, Null | {}]],
			Module[
				{replicatePackets, correctedReplicatePackets, replicateRawData},

				replicatePackets = Download[#2];

				(*Add special handling for AbsThermo replicates - which need their spectrum extracted*)
				correctedReplicatePackets = If[MatchQ[replicatePackets, {PacketP[Object[Data, MeltingCurve]]..}],
					addCoordinatesToAbsThermoPackets[replicatePackets],
					replicatePackets
				];
				replicateRawData = Transpose[lookupWithUnits[correctedReplicatePackets, ops[PrimaryData]]];
				Replicates @@ #1& /@ replicateRawData
			],
			lookupWithUnits[#1, ops[PrimaryData]]
		]&,
		{overriddenPackets, replicates}
	];

	(*semi-flatten the primary data if we are dealing with a multiple primary data field*)
	flatPrimaryData = If[MatchQ[primaryMultipleQ, {True..}],
		Sequence @@@ primaryData,
		primaryData
	];

	If[MatchQ[flatPrimaryData, {{Null ..} ..}],
		Message[
			Error::NullPrimaryData,
			ops[PrimaryData],
			Complement[linePlotTypeUnits[dataType][[All, 1]], ops[PrimaryData]]
		];
		Return[];
	];

	(*--Pull all secondary data and add units--*)
	secondaryDataRule = SecondYCoordinates -> (lookupWithUnits[#, ops[SecondaryData]]& /@ overriddenPackets);

	(*semi-flatten the secondary data if we are dealing with a multiple secondary field*)
	flatSecondaryDataRule = If[MatchQ[secondaryMultipleQ, {True..}],
		SecondYCoordinates -> Sequence @@@ Last[secondaryDataRule],
		secondaryDataRule
	];

	(*--Extract the curves matching CurveType and their index-matched options--*)

	(*Look up the specified or defaulted option values*)
	{baselineDomain, curveTypes} = Lookup[ops, {BaselineDomain, CurveType}];

	(*Stitch together the fields index-matched to AmplificationCurves*)
	curveIndexedFields = Map[
		Lookup[#, {AmplificationCurveTypes, ExcitationWavelengths, EmissionWavelengths, Primers, Probes}]&,
		overriddenPackets
	];

	(*Append curveIndexedFields to flatPrimaryData*)
	allCurveIndexedFields = MapThread[
		Join[{#1}, #2]&,
		{flatPrimaryData, curveIndexedFields}
	];

	(*Get the positions of the specified curve types in the curve-index-matched AmplificationCurveTypes lists*)
	curveTypePositions = GatherBy[
		Position[
			allCurveIndexedFields,
			Switch[Length[curveTypes],
				0, curveTypes,
				1, First@curveTypes,
				2, First@curveTypes | Last@curveTypes,
				3, First@curveTypes | curveTypes[[2]] | Last@curveTypes
			]
		],
		First
	][[All, All, 3]];

	(*Get the curves matching the specified curve types and their index-matched options*)
	specifiedCurveIndexedFields = Quiet[Check[
		MapThread[
			#1[[All, #2]]&,
			{allCurveIndexedFields, curveTypePositions}
		],
		(*If there is no data, a part error is issued, and should be swapped out for ECL's error message.*)
		Message[Error::NoData];
		Return[$Failed]],{Part::partw}];

	(*Thread the specified curves and their index-matched options - outer list is index-matched to CurveType*)
	threadedSpecifiedCurveIndexedFields = Map[
		specifiedCurveIndexedFields[[All, All, #]]&,
		Range[Length[ToList[curveTypes]]]
	];

	(*--Get the Cq analysis information--*)

	(*Look up the Cq analysis objects*)
	cqAnalysisObjects = Map[
		Download[Lookup[#, QuantificationCycleAnalyses], Object]&,
		overriddenPackets
	];

	(*Download the Cq analysis packets - outer list is index-matched to data objects*)
	cqAnalysisPackets = Download[
		cqAnalysisObjects,
		Packet[BaselineDomain, Template, ForwardPrimer, ReversePrimer, Probe, ExcitationWavelength, EmissionWavelength, QuantificationCycle, CopyNumberAnalyses, DateCreated]
	];

	(*Find the most recent Cq analysis packet of all if there's at least one packet*)
	latestCqAnalyisPacket = If[MatchQ[cqAnalysisPackets, {{}..}],
		Null,
		Last@Sort[Flatten[cqAnalysisPackets], Lookup[#2, DateCreated] > Lookup[#1, DateCreated]&]
	];

	(*If BaselineDomain->Automatic and there's at least one Cq analysis, set it to BaselineDomain from latestCqAnalyisPacket; if not, set it to {3 Cycle,15 Cycle}*)
	resolvedBaselineDomain = If[MatchQ[baselineDomain, Automatic],
		If[!NullQ[latestCqAnalyisPacket],
			Lookup[latestCqAnalyisPacket, BaselineDomain],
			{3 Cycle, 15 Cycle}
		],
		baselineDomain
	];

	(*--Baseline subtraction (for amplification curves only)--*)

	(*Isolate the ampliciation/melting curves*)
	curves = Unitless@threadedSpecifiedCurveIndexedFields[[All, All, 1]];
	
	threadedCorrectedCurves = Switch[primaryDataField,
		(*ARM 1 of Switch statement*)
		{AmplificationCurves}|{RawAmplificationCurves},

			(*If amplification curves, isolate the baseline domain*)
			curvesInBaselineDomain = Map[
				selectInDomain[#, Unitless[resolvedBaselineDomain]]&,
				curves,
				{2}
			];
	
			ECL`Authors[selectInDomain] := {"brad"};
	
			(*Helper function to select the domain in data*)
			selectInDomain[
				curve_,
				domain : {xmin_, xmax_}
			] := Select[
				curve,
				LessEqual[xmin, #[[1]]] && LessEqual[#[[1]], xmax]&
			];
	
			(*For each curve, find the mean baseline fluorescence value*)
			meanBaselineFluor = Map[
				Mean@#[[All, 2]]&,
				curvesInBaselineDomain,
				{2}
			];
	
			(*For each curve, subtract the mean baseline fluorescence value*)
			correctedFluor = MapThread[
				#1 - #2&,
				{curves[[All, All, All, 2]], meanBaselineFluor}
			];
	
			(*Reassemble the corrected fluorescence values with the cycle numbers - outer list is index-matched to CurveType*)
			correctedCurves = Map[
				Function[correctedFluorPerCurve,
	
					MapThread[
						{#1, #2}&,
						{Range[1, Length[correctedFluorPerCurve]], correctedFluorPerCurve}
					]
	
				],
				correctedFluor,
				{2}
			];
	
			(*Thread correctedCurves - outer list is index-matched to data objects*)
			MapThread[
				Switch[Length[correctedCurves],
					1, {#1}&,
					2, {#1, #2}&,
					3, {#1, #2, #3}&
				],
				correctedCurves
			],
		
		(*ARM 3 of Switch statement -- general case*)
		_,
			curves
	];

	(*--Extract the Cq analysis packets with ex/em wavelength pairs matching those of curves--*)

	(*Look up the ex/em wavelengths for the specified curves - outer list is index-matched to CurveType*)
	specifiedWavelengths = Map[
		{#[[3]], #[[4]]}&,
		threadedSpecifiedCurveIndexedFields,
		{2}
	];

	(*Thread specifiedWavelengths - outer list is index-matched to data objects*)
	threadedSpecifiedWavelengths = MapThread[
		Switch[Length[specifiedWavelengths],
			1, {#1}&,
			2, {#1, #2}&,
			3, {#1, #2, #3}&
		],
		specifiedWavelengths
	];

	(*Find the most recent Cq analysis packet matching each of threadedSpecifiedWavelengths*)
	specifiedWavelengthCqAnalysisPackets = MapThread[
		Function[
			{cqAnalysisPacketsPerDataObject, threadedSpecifiedWavelengthsPerDataObject},

			Map[
				Module[{packetsPerWavelengthPair},
					packetsPerWavelengthPair = Cases[cqAnalysisPacketsPerDataObject, KeyValuePattern[{ExcitationWavelength -> First@#, EmissionWavelength -> Last@#}]];
					If[MatchQ[packetsPerWavelengthPair, {}],
						packetsPerWavelengthPair,
						Last@packetsPerWavelengthPair
					]
				]&,
				threadedSpecifiedWavelengthsPerDataObject
			]

		],
		{cqAnalysisPackets, threadedSpecifiedWavelengths}
	] /. {} -> Null;

	(*--Get the copy number analysis information--*)

	(*Get the most recent copy number analysis packets for each of specifiedWavelengthCqAnalysisPackets*)
	specifiedWavelengthCnAnalysisPackets = Map[
		If[NullQ[#],
			Null,
			If[NullQ[Lookup[#, CopyNumberAnalyses]],
				Null,
				Download[
					Last@Lookup[#, CopyNumberAnalyses],
					Packet[CopyNumber]
				]
			]
		]&,
		specifiedWavelengthCqAnalysisPackets,
		{2}
	];

	(*--Resolve plot options--*)

	(*-Resolve Epilog-*)

	(*Flatten threadedCorrectedCurves to sets of data points*)
	flatThreadedCorrectedCurves = Flatten[threadedCorrectedCurves, 1];

	(*Flatten specifiedWavelengthCqAnalysisPackets and replace packets with unitless Cq values*)
	flatSpecifiedWavelengthCqValues = Unitless@Flatten[specifiedWavelengthCqAnalysisPackets] /. x : PacketP[] :> Lookup[x, QuantificationCycle];

	(*Get the fluorescence values corresponding to flatSpecifiedWavelengthCqValues, using the interpolating functions*)
	flatThreadedCorrectedCurveFuncs = Interpolation /@ flatThreadedCorrectedCurves;
	flatSpecifiedWavelengthCqYValues = Quiet[MapThread[
		If[NullQ[#2],
			Null,
			#1[#2]
		]&,
		{flatThreadedCorrectedCurveFuncs, flatSpecifiedWavelengthCqValues}
	], InterpolatingFunction::dmval];

	(*Flatten specifiedWavelengthCnAnalysisPackets and replace packets with Cn values*)
	flatSpecifiedWavelengthCnValues = Flatten[specifiedWavelengthCnAnalysisPackets] /. x : PacketP[] :> Lookup[x, CopyNumber];

	(*Define the Epilog rule - each curves gets no mouseover, mouseover with Cq value, or mouseover with both Cq and Cn values*)
	epilogRule = Epilog -> {
		MapThread[

			If[NullQ[#1],
				Null,
				If[NullQ[#3],
					Mouseover[
						{ColorData[97][#4], PointSize[0.02], Tooltip[Point[{#1, #2}], "Quantification Cycle: " <> ToString[#1 Cycle]]},
						{ColorData[97][#4], PointSize[0.03], Tooltip[Point[{#1, #2}], "Quantification Cycle: " <> ToString[#1 Cycle]]}
					],
					Mouseover[
						{ColorData[97][#4], PointSize[0.02], Tooltip[Point[{#1, #2}], "Quantification Cycle: " <> ToString[#1 Cycle] <> "\nCopy Number: " <> ToString@#3]},
						{ColorData[97][#4], PointSize[0.03], Tooltip[Point[{#1, #2}], "Quantification Cycle: " <> ToString[#1 Cycle] <> "\nCopy Number: " <> ToString@#3]}
					]
				]
			]&,

			{flatSpecifiedWavelengthCqValues, flatSpecifiedWavelengthCqYValues, flatSpecifiedWavelengthCnValues, Range[Length[flatSpecifiedWavelengthCqYValues]]}
		]
	};

	(*-Resolve legend-*)

	(*Get the input data objects*)
	dataObjects = Map[Lookup[#, Object]&, initialPackets];

	(*Get the number of wavelengths plotted per data object*)
	numberOfSpecifiedCurvesPerData = Length /@ specifiedWavelengthCqAnalysisPackets;

	(*Expand dataObjects by the respective number of wavelengths*)
	expandedDataObjects = Flatten@MapThread[
		ConstantArray[#1, #2]&,
		{dataObjects, numberOfSpecifiedCurvesPerData}
	];

	(*Append the wavelengths to each of expandedDataObjects*)
	expandedDataObjectsWithWavelengths = MapThread[
		ToString@#1 <> " - Excitation " <> ToString@First@Round@Unitless@#2 <> " nm, Emission " <> ToString@Last@Round@Unitless@#2 <> " nm"&,
		{expandedDataObjects, Flatten[threadedSpecifiedWavelengths, 1]}
	];

	(*Define the Legend rule*)
	legendRule = If[Lookup[ops, Legend] === Automatic,
		Legend -> expandedDataObjectsWithWavelengths,
		Legend -> Lookup[ops, Legend]
	];

	(*-Resolve InsetImages-*)
	imageRule = InsetImages -> Flatten[Lookup[overriddenPackets, ops[Images], Null]];

	(*-Resolve PlotLabel-*)
	labelRule = If[ops[PlotLabel] === Automatic,

		Switch[
			primaryDataField,
			{AmplificationCurves}|{RawAmplificationCurves},

			Sequence@@{
				PlotLabel -> "Amplification Curve Data",
				FrameLabel -> {"Cycle", "\[CapitalDelta]Rn (RFU)"}
			},

			_,
			Sequence@@{
				PlotLabel -> SymbolName[primaryDataField[[1]]],
				FrameLabel -> {"", ""}
			}
		],

		PlotLabel -> ops[PlotLabel]
	];

	(*Join all plot options*)
	ellpOps = Join[
		{
			epilogRule,
			legendRule,
			imageRule,
			labelRule
		},
		FilterRules[Normal[ops], inputOptions],
		Normal[ops]
	];

	(*--Call the plot function with the resolved options--*)
	{finalPlot, mostlyResolvedOptions} = EmeraldListLinePlot[
		flatThreadedCorrectedCurves,
		ReplaceRule[{stringOptionsToSymbolOptions[PassOptions[EmeraldListLinePlot, ellpOps]]},
			{Output -> {Result, Options}}
		]
	];

	(* Safe options with resolved options from the underlying plot function (plot range, frame, etc.) subbed in *)
	resolvedOps = ReplaceRule[SafeOptions[fnc, ToList[inputOptions]], mostlyResolvedOptions, Append -> False];

	(* Any special resolutions specific to your plot (which are not covered by underlying plot function) *)
	finalResolvedOps = ReplaceRule[resolvedOps,
		(* Any custom options which need special resolution *)
		ellpOps,
		Append -> False
	];

	(* return output *)
	outputSpecification /. {
		Result -> finalPlot,
		Preview -> finalPlot /. If[MemberQ[initialOps, ImageSize -> _], {}, {Rule[ImageSize, _] :> Rule[ImageSize, Full]}],
		Tests -> {},
		Options -> finalResolvedOps
	}
];

(*Function overload to map over outer lists*)
qPCRPacketToELLP[
	infs : {{packetOrInfoP[]..}..},
	fnc_,
	inputOptions : {(_Rule | _RuleDelayed)...}
] := (qPCRPacketToELLP[#, fnc, inputOptions]& /@ infs);

(*Function overload to map over inner lists when specified*)
qPCRPacketToELLP[
	infs : {packetOrInfoP[]..},
	fnc_,
	inputOptions : {(_Rule | _RuleDelayed)...}
] := Module[
	{mappedOptions, optionsForEachPlot},

	mappedOptions = qPCRupdateOptionsForMapping[fnc, Length[infs], inputOptions];
	optionsForEachPlot = ReplaceRule[#, {Map -> False}]& /@ mappedOptions;
	MapThread[qPCRPacketToELLP[#1, fnc, #2]&, {infs, optionsForEachPlot}]
] /; (Map /. inputOptions);

qPCRupdateOptionsForMapping[functionName_, numberOfPlots_, ops_] := Module[
	{optionNames, paddedOptions, specifiedOptionsForEachPlot},

	optionNames = ops[[All, 1]];
	paddedOptions = qPCRpadOptionForMapping[functionName, #, numberOfPlots, ops]& /@ optionNames;
	specifiedOptionsForEachPlot = Transpose[paddedOptions]
];

(*This is the little helper function to recreate the OptionPatterns of old SLL2*)
qPCRoptionPatterns[functionName_] := Module[
	{optionDef, allOptions, allPatterns, oldOptionPatternsOutput},

	optionDef = OptionDefinition[functionName];
	allOptions = Map[ToExpression[#["OptionName"]]&, optionDef];
	allPatterns = Map[
		If[KeyExistsQ[#, "SingletonPattern"],
			ReleaseHold[#["SingletonPattern"]],
			ReleaseHold[#["Pattern"]]
		]&,
		optionDef
	];

	oldOptionPatternsOutput = MapThread[#1 -> #2&, {allOptions, allPatterns}]
];

qPCRpadOptionForMapping[functionName_, optionName_, numberOfPlots_, ops_] := Module[
	{optionValue, optionList, pattern},

	optionValue = optionName /. ops;
	pattern = optionName /. Join[qPCRoptionPatterns[functionName], qPCRoptionPatterns[EmeraldListLinePlot]];
	optionList =
		optionList = Switch[{optionValue, Length[optionValue]},
			{pattern | singleOptionValues | Except[_List], _}, ConstantArray[optionValue, numberOfPlots],
			{{pattern..}, numberOfPlots}, optionValue,
			{_, _}, Message[Warning::NonMappableOption, optionName];Nothing
		];
	(optionName -> #)& /@ optionList
];

singleOptionValues = Alternatives[{#1&}, {}];
