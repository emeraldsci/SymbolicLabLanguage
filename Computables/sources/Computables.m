(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*analysis*)


Authors[derivativeComputable]:={"pnafisi", "kelmen.low", "eddie", "george"};
Authors[structuresComputable]:={"pnafisi", "kelmen.low", "eddie", "george"};
Authors[strandsComputable]:={"pnafisi", "kelmen.low", "eddie", "george"};
Authors[reactantsComputable]:={"pnafisi", "kelmen.low", "eddie", "george"};
Authors[intermediateSpeciesComputable]:={"pnafisi", "kelmen.low", "eddie", "george"};
Authors[reactionProductsComputable]:={"pnafisi", "kelmen.low", "eddie", "george"};
Authors[partsCurrentComputable]:={"pnafisi", "kelmen.low", "eddie", "george"};
Authors[partsHistoryComputable]:={"pnafisi", "kelmen.low", "eddie", "george"};
Authors[figureComputable]:={"pnafisi", "kelmen.low", "eddie", "george"};
Authors[figureEnvironmentComputable]:={"pnafisi", "kelmen.low", "eddie", "george"};

fractionsCollected[analysis_]:=Quiet[Download[analysis, Field[Reference][[-1]][FractionsCollected]]/.{($Failed|{})->Null}];

fractionsPicked[analysis_]:=LastOrDefault[Download[analysis, FractionsPicked]];

timeElapsed[dateCompleted_, dateStarted_]:=UnitScale[dateCompleted - dateStarted];

expectedSize[standardFit_, positionUnit_, sizeUnit_]:=Quiet[QuantityFunction[Download[standardFit, BestFitFunction],positionUnit,sizeUnit]];

expectedPosition[standardFit_, positionUnit_, sizeUnit_]:=Quiet[QuantityFunction[InverseFunction[Download[standardFit, BestFitFunction]],sizeUnit,positionUnit]];

standardPeaks[standardAnalyses_]:=Apply[Rule, Lookup[Download[LastOrDefault[standardAnalyses]]/.{Null->{}}, FragmentPeaks, Null], {1}];

ladderPeaks[ladderAnalyses_]:=Apply[Rule, Lookup[Download[LastOrDefault[ladderAnalyses]]/.{Null->{}}, FragmentPeaks, Null], {1}];

allowedPositions[positions_]:=If[positions=!={},Alternatives @@ (Name /. positions),Null];

sizeFunction[ladderAnalyses_]:=If[ladderAnalyses=!={},Download[ladderAnalyses[[-1]], ExpectedSize],Null];

retentionFunction[ladderAnalyses_]:=If[ladderAnalyses=!={},Download[ladderAnalyses[[-1]], ExpectedPosition],Null];

primerProbeSets[primerFields__]:=If[!MemberQ[ToList[primerFields],{}],Transpose[ToList[primerFields]],Null];

ladderSizes[ladderAnalyses_]:=If[ladderAnalyses=!={},
    Times[
		Lookup[Download[LastOrDefault[ladderAnalyses]], Sizes],
		Lookup[Download[LastOrDefault[ladderAnalyses]], SizeUnit]
	],
	Null
];

(* ::Subsubsection:: *)
(*objectsInNotebook*)
objectsInNotebook[nb : ObjectP[Object[LaboratoryNotebook]]] :=
	(Link /@ Constellation`Private`getNotebookObjects[Download[nb, ID]]);

(* ::Subsubsection:: *)
(*peakUnits*)


peakUnits[dataRef_, refField_, sliceDims_]:=Module[{xUnit, yUnit, units},


	{xUnit, yUnit}=If[MatchQ[Download[LastOrDefault[dataRef], Object], ObjectP[Object[Data]]] && (refField /. (LegacySLL`Private`typeUnits[Download[Download[Last[dataRef], Object], Type]])) =!= refField,
		(* typeUnits lookup resolved correctly, then determine how to get units based on options *)
		With[{refUnits=refField /. (LegacySLL`Private`typeUnits[Download[Last[dataRef], Object]])},
			Which[
				(* 3D Data slicing was used *)
				Length[refUnits] > 2 && MatchQ[sliceDims, {_Integer..}],
				refUnits[[Sort@Complement[Range[Length[refUnits]], sliceDims]]],
				(* Data is three dimensional but slicing options were not used *)
				Length[refUnits] == 3,
				refUnits[[{1, 3}]],
				(* Default - just use units as is *)
				True,
				refUnits
			]
		],
		(* typeUnits lookup did not resolve, so assume there are None units *)
		{None, None}
	];

	units=Evaluate[{
		(Position -> xUnit),
		(Height -> yUnit),
		(Width -> xUnit),
		(Area -> Replace[yUnit * xUnit, None^2 -> None, {0}]),
		(PeakRangeStart -> xUnit),
		(PeakRangeEnd -> xUnit),
		(WidthRangeStart -> xUnit),
		(WidthRangeEnd -> xUnit),
		(BaselineIntercept -> yUnit),
		(BaselineSlope -> Replace[yUnit / xUnit, 1 -> None, {0}])
	}];

	units
];


(* ::Subsubsection::Closed:: *)
(*derivativeComputable*)


derivativeComputable[bestFit_Function]:=With[
	{df=D[bestFit[x$], x$]},
	Function[
		x,
		df
	]
];


derivativeComputable[bestFit:QuantityFunction[fcn_, unitX_, unitY_]]:=QuantityFunction[derivativeComputable[fcn], unitX, unitY / First[unitX]];


(* ::Subsubsection::Closed:: *)
(*theoreticalFractionVolumes*)


theoreticalFractionVolumes[fractionsPicked_, dataObject_]:=Module[
	{flowRate, collectionTimes},
  flowRate=Quiet@With[{resolvedData=If[MatchQ[dataObject, _List], LastOrDefault[dataObject], dataObject]},
		Lookup[Download[resolvedData], FlowRate, Null]
	];
  collectionTimes=fractionsPicked[[1;;All, {1, 2}]];
	If[MatchQ[flowRate,_Lookup]||NullQ[flowRate],
    Null,
		((collectionTimes . {-1, 1}) * Minute) * flowRate
	]
];



(* ::Subsection:: *)
(*qualification*)


(* ::Subsubsection:: *)
(*qualificationFrequency*)


Authors[qualificationFrequency]:={"pnafisi", "kelmen.low", "eddie", "george", "srikant"};


qualificationFrequency[model:NullP | ObjectP[]]:=Module[
	{qualificationFreq},

	If[
		NullQ[model],
		Null,
		(
			(* Get Qualification Frequency from model and delete duplicates *)
			qualificationFreq=DeleteDuplicates[Download[model, QualificationFrequency]];
			If[
				MatchQ[qualificationFreq, {}],
				Null,
				Cases[qualificationFreq, {x:LinkP[], y_} :> {Download[x, Object], y}]
			]
		)
	]
];


(* ::Subsubsection:: *)
(*qualificationFrequenciesComputable*)


Authors[qualificationFrequenciesComputable]:={"pnafisi", "kelmen.low", "eddie", "george", "srikant"};


qualificationFrequenciesComputable[  targetsLinkList:{} | {LinkP[]..}, modelQualification:NullP | ObjectP[Model[Qualification]]]:=Module[
	{
		targetsList,
		prunedTargets, qualificationFreqLists, qualificationFreqListsDuplicatesRemoved, selQualificationFreqList, validQualificationFreqList, finalQualificationFreq
	},

	targetsList=If[
		MatchQ[targetsLinkList, {}],
		Null,
		Download[targetsLinkList, Object]
	];


	If[
		(NullQ[targetsList] || MatchQ[targetsList, {Null...}] || NullQ[modelQualification]),
		Null,
		(
			(* Delete any duplicate targets and Null entries *)
			prunedTargets=DeleteDuplicates[Cases[targetsList, ObjectP[]]];
			(* Get Qualification Frequency for each Target. Remove any $Failed. output = {{target, {{modelQualification Link/Object, time}..}}..} *)
			qualificationFreqLists=Cases[Download[prunedTargets, {Object, QualificationFrequency}], { ObjectP[], {{ObjectReferenceP[] | LinkP[], GreaterP[0 * Second] | NullP}..}}];
			(* Convert any Links to objects. We need to convert to objects to remove duplicates. output: {{target, {{modelQualification Object, time}..}}..} *)
			qualificationFreqListsDuplicatesRemoved={#[[1]], DeleteDuplicates[Cases[#[[2]], {x:ObjectReferenceP[] | LinkP[], y:GreaterP[0 * Second] | NullP} :> {Download[x, Object], y}]]}& /@ qualificationFreqLists;
			(* for each target, select only the modelQualification that matches input to function. output = {{ target, {modelQualification, time}}..}*)
			selQualificationFreqList={#[[1]], Flatten[Cases[#[[2]], {modelQualification, GreaterP[0 * Second] | NullP}], 1]}& /@ qualificationFreqListsDuplicatesRemoved;
			(* remove those targets for which no matching modelQualification frequency could be found. i.e. remove empty lists *)
			validQualificationFreqList=Cases[selQualificationFreqList, {ObjectP[], {ObjectP[], GreaterP[0 * Second] | NullP}}];
			(* final output in form {{target, time}...} *)
			finalQualificationFreq={#[[1]], #[[2]][[2]]}& /@ validQualificationFreqList;
			(* return *)
			finalQualificationFreq /. {} -> Null
		)
	]

];



(* ::Subsection:: *)
(*data*)


(* ::Subsubsection:: *)
(*cellCountComputable*)


Authors[cellCountComputable]:={"pnafisi", "eddie", "george", "srikant","lei.tian"};

cellCountComputable[cellCountAnalyses:{ObjectP[Object[Analysis, CellCount]]...} | NullP, imageType:ImageTypeP | NullP]:=Module[
	{
		appropriateCellCountAnalysesInfo, latestAppropriateCellCountAnalysisInfo
	},

	If[
		Or[MatchQ[cellCountAnalyses,NullP|{}], NullQ[imageType]],
		(* if null, return Null *)
		Null,
		(
			(* select cell count analyses of the same ImageType *)
			appropriateCellCountAnalysesInfo=Select[Download[cellCountAnalyses], MatchQ[Lookup[#, ImageSource], imageType]&];
			(* choose the lates cell count analysis of the selected imageType *)
			latestAppropriateCellCountAnalysisInfo=LastOrDefault[appropriateCellCountAnalysesInfo, Null];
			(* return CellCount. Note this will return Null if latestAppropriateCellCountAnalysisInfo = Null *)
			If[!MatchQ[latestAppropriateCellCountAnalysisInfo, Null], CellCount /. latestAppropriateCellCountAnalysisInfo, Null]
		)
	]

];


(* ::Subsubsection:: *)
(*forwardScatterChannel*)


forwardScatterChannel[obj:ObjectP[Object[Data, FlowCytometry]]]:=Module[
	{objInfo},

	objInfo=Download[obj];

	{
		Laser -> ForwardScatterLaser,
		GainStage -> ForwardScatterGainStage,
		Gain -> ForwardScatterGain,
		Height -> ForwardScatterHeight,
		Area -> ForwardScatterArea,
		Width -> SignalWidth
	} /. objInfo

];


(* ::Subsubsection:: *)
(*sideScatterChannel*)


sideScatterChannel[obj:ObjectP[Object[Data, FlowCytometry]]]:=Module[
	{objInfo},

	objInfo=Download[obj];

	{
		Laser -> SideScatterLaser,
		Gain -> SideScatterGain,
		Height -> SideScatterHeight,
		Area -> SideScatterArea,
		Width -> SignalWidth
	} /. objInfo

];


(* ::Subsubsection:: *)
(*fluorescenceChannels*)


fluorescenceChannels::MismatchedLists="One or more of the following fields does not match the others in length: {Laser, EmissionWavelength, EmissionBandwidth, Gain, Height, Area}.";


fluorescenceChannels[obj:ObjectP[Object[Data, FlowCytometry]](*lasers_List, emWavelengths_List, emBandwidths_List, gains_List, heights_List, areas_List, units_List*)]:=Module[
	{objInfo, units, allFields, lengths, signalWidth, channelName},

	objInfo=Download[obj];
	units=Units /. objInfo;
	allFields={FluorescenceLaser, FluorescenceEmissionWavelength, FluorescenceEmissionBandwidth, FluorescenceGain, FluorescenceHeight, FluorescenceArea, FluorescenceChannelName} /. objInfo;
	lengths=Length /@ allFields;
	signalWidth=SignalWidth /. objInfo;

	If[!(Equal @@ lengths),
		Return[Message[fluorescenceChannels::MismatchedLists]]
	];

	MapThread[
		{
			ChannelName -> #7,
			Laser -> #1,
			EmissionWavelength -> #2,
			EmissionBandwidth -> #3,
			Gain -> #4,
			Height -> #5,
			Area -> #6,
			Width -> signalWidth
		}&,
		allFields
	]
];



(* ::Subsubsection:: *)
(*maintenanceFrequency*)


Authors[maintenanceFrequency]:={"pnafisi", "kelmen.low", "eddie", "george", "srikant"};


maintenanceFrequency[model:NullP | ObjectP[]]:=Module[
	{maintFreq, maintUnits},

	If[
		NullQ[model],
		Null,
		(
			(* Get Maintenance Frequency from model and delete duplicates *)
			maintFreq=DeleteDuplicates[Download[model, MaintenanceFrequency]];
			If[
				MatchQ[maintFreq, {}],
				Null,
				Cases[maintFreq, {x:LinkP[], y_} :> {Download[x, Object], y}]
			]
		)
	]
];


(* ::Subsubsection:: *)
(*maintenanceFrequenciesComputable*)


Authors[maintenanceFrequenciesComputable]:={"pnafisi", "kelmen.low", "eddie", "george", "srikant"};


maintenanceFrequenciesComputable[  targetsLinkList:{} | {LinkP[]..}, modelMaintenance:NullP | ObjectP[Model[Maintenance]]]:=Module[
	{
		targetsList,
		prunedTargets, maintFreqLists, maintFreqListsDuplicatesRemoved, selMaintenanceFreqList, validMaintenanceFreqList, finalMaintFreq
	},

	targetsList=If[
		MatchQ[targetsLinkList, {}],
		Null,
		Download[targetsLinkList, Object]
	];


	If[
		(NullQ[targetsList] || MatchQ[targetsList, {Null...}] || NullQ[modelMaintenance]),
		Null,
		(
			(* Delete any duplicate targets and Null entries *)
			prunedTargets=DeleteDuplicates[Cases[targetsList, ObjectP[]]];
			(* Get Maintenance Frequency for each Target. Remove any $Failed. output = {{target, {{modelMaintenance Link/Object, time}..}}..} *)
			maintFreqLists=Cases[Download[prunedTargets, {Object, MaintenanceFrequency}], { ObjectP[], {{ObjectReferenceP[] | LinkP[], GreaterP[0 * Second] | NullP}..}}];
			(* Convert any Links to objects. We need to convert to objects to remove duplicates. output: {{target, {{modelMaintenance Object, time}..}}..} *)
			maintFreqListsDuplicatesRemoved={#[[1]], DeleteDuplicates[Cases[#[[2]], {x:ObjectReferenceP[] | LinkP[], y:GreaterP[0 * Second] | NullP} :> {Download[x, Object], y}]]}& /@ maintFreqLists;
			(* for each target, select only the modelMaintenance that matches input to function. output = {{ target, {modelMaintenance, time}}..}*)
			selMaintenanceFreqList={#[[1]], Flatten[Cases[#[[2]], {modelMaintenance, GreaterP[0 * Second] | NullP}], 1]}& /@ maintFreqListsDuplicatesRemoved;
			(* remove those targets for which no matching modelMaintenance frequency could be found. i.e. remove empty lists *)
			validMaintenanceFreqList=Cases[selMaintenanceFreqList, {ObjectP[], {ObjectP[], GreaterP[0 * Second] | NullP}}];
			(* final output in form {{target, time}...} *)
			finalMaintFreq={#[[1]], #[[2]][[2]]}& /@ validMaintenanceFreqList;
			(* return *)
			finalMaintFreq /. {} -> Null
		)
	]

];


(* ::Subsection::Closed:: *)
(*chemical*)


(* ::Subsubsection::Closed:: *)
(*mixtureNFPAComputable*)


mixtureNFPAComputable[givenNFPA:NFPAP, formula_]:=givenNFPA;

mixtureNFPAComputable[givenNFPA:NullP, formula:(NullP|{})]:=Null;

(* If NFPA is not defined but formula is, calculate NFPA from the formula *)
mixtureNFPAComputable[givenNFPA:NullP, formula:{{_Quantity|NullP, LinkP[Model[Sample]]|LinkP[List@@IdentityModelTypeP]|NullP}..}]:=Module[
	{allComponents, allNFPA},

	allComponents=formula[[All, 2]];

	allNFPA=DeleteCases[Download[allComponents, NFPA], Null];

	If[MatchQ[allNFPA, {}],
		Null,
		{
			Health -> Max[Health /. allNFPA],
			Flammability -> Max[Flammability /. allNFPA],
			Reactivity -> Max[Reactivity /. allNFPA],
			Special -> Union[Special /. allNFPA]
		}
	]
];


(* ::Subsubsection::Closed:: *)
(*componentsMSDSComputable*)


componentsMSDSComputable[formula:{{_Quantity, LinkP[Model[Sample]]}..}]:=Module[
	{allComponents, chemicalComponents, stockSolutionComponents, collectedMSDS},

	allComponents=formula[[All, 2]];

	chemicalComponents=Cases[
		allComponents,
		ObjectP[Model[Sample]]
	];

	stockSolutionComponents=Cases[
		allComponents,
		ObjectP[Model[Sample, StockSolution]]
	];

	(* note: cloud files with the same contents but different IDs will be distinct *)
	DeleteDuplicates[
		Cases[
			Flatten[
				Join[
					Download[chemicalComponents, MSDSFile],
					Download[stockSolutionComponents, {MSDSFile, ComponentsMSDSFiles}]
				]
			],
			ObjectP[Object[EmeraldCloudFile]]
		]
	]
];

(* overload that can do the same based on composition (for unit operations based stock solutions where no formula is available) *)
componentsMSDSComputable[formula:{{_Quantity, LinkP[Model[Sample]]}...}, composition:{{_Quantity|NullP, LinkP[List@@IdentityModelTypeP]|NullP}...}]:=Module[
	{allComponents, chemicalComponents, stockSolutionComponents, collectedMSDS},

	(* if either of the fields is an empty list, return Null *)
	If[MatchQ[formula,{}]||MatchQ[composition,{}],Return[Null]];

	allComponents=If[!MatchQ[formula, {}],
		formula[[All, 2]],
		composition[[All, 2]]
	];

	chemicalComponents=If[!MatchQ[formula, {}],
		Cases[allComponents,ObjectP[Model[Sample]]],
		Cases[allComponents,ObjectP[Model[Molecule]]]
	];

	stockSolutionComponents=Cases[
		allComponents,
		ObjectP[Model[Sample, StockSolution]]
	];

	(* note: cloud files with the same contents but different IDs will be distinct *)
	DeleteDuplicates[
		Cases[
			Flatten[
				Join[
					Download[chemicalComponents, MSDSFile],
					Download[stockSolutionComponents, {MSDSFile, ComponentsMSDSFiles}]
				]
			],
			ObjectP[Object[EmeraldCloudFile]]
		]
	]
];



(* ::Subsubsection::Closed:: *)
(*structuresComputable*)


structuresComputable[mech:ReactionMechanismP]:=DeleteDuplicates[Cases[mech[Species], _Structure, {1}]];
structuresComputable[Null]:={Null};


(* ::Subsubsection::Closed:: *)
(*strandsComputable*)


strandsComputable[mech:ReactionMechanismP]:=DeleteDuplicates[Flatten[#[Strands]& /@ structuresComputable[mech]]];
strandsComputable[Null]:={Null};


(* ::Subsubsection::Closed:: *)
(*reactantsComputable*)


reactantsComputable[mech:ReactionMechanismP]:=Module[{allReactants, allProducts},
	allReactants=DeleteDuplicates[Flatten[mech[Reactants]]];
	allProducts=DeleteDuplicates[Flatten[mech[Products]]];
	Complement[allReactants, allProducts]
];
reactantsComputable[Null]:={Null};


(* ::Subsubsection::Closed:: *)
(*intermediateSpeciesComputable*)


intermediateSpeciesComputable[mech:ReactionMechanismP]:=Module[{allReactants, allProducts},
	allReactants=DeleteDuplicates[Flatten[mech[Reactants]]];
	allProducts=DeleteDuplicates[Flatten[mech[Products]]];
	Intersection[allReactants, allProducts]
];
intermediateSpeciesComputable[Null]:={Null};


(* ::Subsubsection::Closed:: *)
(*reactionProductsComputable*)


reactionProductsComputable[mech:ReactionMechanismP]:=Module[{allReactants, allProducts},
	allReactants=DeleteDuplicates[Flatten[mech[Reactants]]];
	allProducts=DeleteDuplicates[Flatten[mech[Products]]];
	Complement[allProducts, allReactants]
];
reactionProductsComputable[Null]:={Null};


(* ::Subsection:: *)
(*modelInstrument*)


(* ::Subsubsection:: *)
(*getMicroscopeObjectiveMagnifications*)


Authors[getMicroscopeObjectiveMagnifications]:={"varoth.lilascharoen", "eddie", "george", "parsa", "srikant"};

getMicroscopeObjectiveMagnifications[ objectives:NullP | {(ObjectP[{Model[Part, Objective], Object[Part, Objective]}] | NullP)...}]:=Module[
	{
		racks, rackContents, downContainers, objectiveList, magnifications
	},

	If[
		NullQ[objectives],
		{},
		(
			(* get objectives *)
			objectiveList=DeleteDuplicates[DeleteCases[objectives, _?NullQ]];
			(* Get magnifications *)
			magnifications=Cases[Download[objectiveList, Magnification], GreaterEqualP[0]]
		)
	]
];


(* ::Subsubsection:: *)
(*getFluorescenceFilters*)


Authors[getFluorescenceFilters]:={"varoth.lilascharoen", "eddie", "george", "parsa", "srikant"};

getFluorescenceFilters[ opticModules:NullP | {(ObjectP[{Model[Part, OpticModule], Object[Part, OpticModule]}] | NullP)...}]:=Module[
	{
		reducedOpticModules, fluorescenceFilters
	},

	If[
		NullQ[opticModules],
		{},
		(
			(* get opticModules *)
			reducedOpticModules=DeleteDuplicates[DeleteCases[opticModules, _?NullQ]];
			(* Get filters*)
			fluorescenceFilters=Cases[Download[reducedOpticModules, {ExcitationFilterWavelength, EmissionFilterWavelength}], {GreaterP[0 Nano Meter, 1 Nano Meter] | _?NullQ, GreaterP[0 Nano Meter, 1 Nano Meter] | _?NullQ}]
		)
	]
];


(* ::Subsection:: *)
(*instrument*)


(* ::Subsubsection::Closed:: *)
(*getPDUPort*)

getPDUPort[obj:(ObjectP[Object[Instrument]] | ObjectP[Object[Part]] | ObjectP[Object[Plumbing]]), Null, _]:=Null;

getPDUPort[obj:(ObjectP[Object[Instrument]] | ObjectP[Object[Part]] | ObjectP[Object[Plumbing]]), pdu:LinkP[Object[Part, PowerDistributionUnit]], PDUFieldType:PDUFieldsP]:=Module[
	{stuffOnPDU, matchingPDU},

	stuffOnPDU=Download[pdu, ConnectedInstruments];

	matchingPDU=Select[stuffOnPDU, MatchQ[#, {LinkP[obj], PDUPortP, PDUFieldType}]&];

	If[Length[matchingPDU] =!= 0,
		Flatten[matchingPDU][[2]],
		Null
	]
];


(* ::Subsubsection:: *)
(*getOpticModules*)


Authors[getOpticModules]:={"varoth.lilascharoen", "eddie", "george", "parsa", "srikant"};

getOpticModules[inst:ObjectP[]]:=Module[
	{
		contents, opticModuleTurret, opticModuleTurretContents, opticModules
	},

	contents=Download[inst, Contents];

	opticModuleTurret=SelectFirst[
		contents,
		MatchQ[First[#], "Optic Module Turret Slot" | "Optic Module Slot"] &,
		{Null, Null}
	][[2]];

	If[
		NullQ[opticModuleTurret],
		Return[Null]
	];

	opticModuleTurretContents=Download[opticModuleTurret, Contents][[All, 2]];
	opticModules=Cases[opticModuleTurretContents, ObjectP[Object[Part, OpticModule]]];
	If[
		opticModules == {},
		(* If no optic modules return Null *)
		Null,
		opticModules
	]

];


(* ::Subsubsection:: *)
(*getMicroscopeObjectives*)


Authors[getMicroscopeObjectives]:={"varoth.lilascharoen", "eddie", "george", "parsa", "srikant"};

getMicroscopeObjectives[ contents:NullP | {{LocationPositionP, ObjectP[{Object[Sample], Object[Container], Object[Part], Object[Instrument], Object[Sensor], Object[Item]}]}...}]:=Module[
	{
		objectiveTurret, objectiveTurretContents, objectives
	},

	If[
		NullQ[contents],
		Null,
		(
			(* Get objective turret *)
			objectiveTurret=FirstOrDefault[Cases[contents, {x:"Objective Turret Slot", y:ObjectP[Object[Container]]} :> y]];
			If[
				NullQ[objectiveTurret],
				Null,
				(
					(* get contents of objective turret *)
					objectiveTurretContents=Contents /. Download[objectiveTurret];
					(* get objectives *)
					objectives=Cases[objectiveTurretContents, {x_, y:ObjectP[Object[Part]]} :> y];
					If[
						objectives == {},
						(* If no objectives return Null *)
						Null,
						objectives
					]
				)
			]
		)
	]

];


(* ::Subsection::Closed:: *)
(*part*)


(* ::Subsubsection::Closed:: *)
(*partsCurrentComputable*)


partsCurrentComputable[contentsLog:Null | {{_?DateObjectQ | Null, In | Out | Null, ObjectP[{Object[Sample], Object[Container], Object[Instrument], Object[Part], Object[Item], Object[Plumbing], Object[Wiring], Object[Sensor]}] | Null, _String | Null, ObjectP[{Object[User], Object[Qualification], Object[Maintenance], Object[Protocol]}] | Null}...}, contents:{{LocationPositionP | Null, LinkP[] | Null}...}]:=Module[
	{
		currentParts, partsContentsLog, partInstalledPairs, numberOfHours, partTriples
	},

	If[
		NullQ[contents] || MatchQ[contents, {}],
		Null,
		(
			(* get the current parts *)
			currentParts=DeleteDuplicates[Cases[contents, {_, part:ObjectP[Object[Part]]} :> Download[part, Object] ]];

			(* select only part entries in Contents Log and look at only first 3 columns *)
			partsContentsLog=Cases[contentsLog, {a_?DateObjectQ, b:(In | Out), c:ObjectP[Object[Part]], _, _} :> {a, b, Download[c, Object]}];

			(* get the part and date installed on instrument: {part, installTime} *)
			(* If the part was somehow removed from the instrument and installed back, go with the first date to be safe *)
			partInstalledPairs=Function[
				{part},
				FirstCase[partsContentsLog, {installTime:_?DateObjectQ, In, part} :> {part, installTime}]
			] /@ currentParts;

			numberOfHours=Download[currentParts,NumberOfHours];

			(* get the part triples, {part, install time, how long it's been installed}
			  If the part has NumberOfHours uploaded (e.g. for lamps), the install time will be the usage time *)
			partTriples = MapThread[
				If[NullQ[#1],
					{
						#2[[1]],
						#2[[2]],
						If[DateObjectQ[#2[[2]]], DateDifference[#2[[2]], Now, "Day"],Null]},
					{
						#2[[1]],
						#2[[2]],
						#1
					}
				] &,
				{numberOfHours, partInstalledPairs}
			];

			(* return Null if empty *)
			If[MatchQ[partTriples, {}],
				Null,
				partTriples
			]

		)
	]
];


(* ::Subsubsection::Closed:: *)
(*partsHistoryComputable*)


partsHistoryComputable[contentsLog:Null | {{_?DateObjectQ | Null, In | Out | Null, ObjectP[{Object[Sample], Object[Container], Object[Instrument], Object[Part], Object[Item], Object[Plumbing], Object[Wiring], Object[Sensor]}] | Null, _String | Null, ObjectP[{Object[User], Object[Qualification], Object[Maintenance], Object[Protocol]}] | Null}...} , partsCurrent:Null | {{ObjectP[Object[Part]], _?DateObjectQ | Null, _?TimeQ | Null}...} ]:=Module[
	{
		partsContentsLog, prunedParts, currentParts, historicalParts,
		partsLog, sortedPartsLog
	},

	If[
		NullQ[contentsLog] || MatchQ[contentsLog, {}],
		Null,
		(
			(* select only part entries in Contents Log and look at only first 3 columns *)
			partsContentsLog=Cases[contentsLog, {a_?DateObjectQ, b:(In | Out), c:ObjectP[Object[Part]], _, _} :> {a, b, Download[c, Object]}];

			(* get the parts only from the log *)
			prunedParts=DeleteDuplicates[partsContentsLog[[All, 3]]];

			(* get the current parts on instrument *)
			currentParts=If[(NullQ[partsCurrent] || MatchQ[partsCurrent, {}]),
				{},
				DeleteDuplicates[Download[partsCurrent[[All, 1]], Object]]
			];
			(* the complement is the historical parts on instrument *)
			historicalParts=Complement[prunedParts, currentParts];

			(* for the historical parts, get the In and Out times and create a partsLog: {Object, Date installed, Date Removed} *)
			partsLog=Flatten[
				Function[
					{part},
					SequenceCases[partsContentsLog, {{installTime:_?DateObjectQ, In, part}, ___, {removeTime:_?DateObjectQ, Out, part}} :> {part, installTime, removeTime}]
				] /@ historicalParts,
				1
			];

			(* sort by date Installed *)
			sortedPartsLog=SortBy[partsLog, #[[2]]&];

			(* return Null if empty *)
			If[MatchQ[sortedPartsLog, {}],
				Null,
				sortedPartsLog
			]
		)
	]
];


(* ::Subsubsection::Closed:: *)
(*itemUnitDescription*)


(*itemUnitDescription*)
itemUnitDescription[prod:ObjectP[Object[Product]]]:=Module[
	{itemType, numSamps, sampleType, sampleAmount, firstPart, num, amount, unit},

	(* take the necessary info from the product to construct the description *)
	{itemType, numSamps, sampleType, sampleAmount}=Download[prod, {Packaging, NumberOfItems, SampleType, Amount}];

	(* now construct the string *)
	firstPart=Switch[itemType,
		Single, "",
		Pack, "1 Pack of ",
		_, "1 Case of "
	];
	amount=Which[
		NullQ[sampleAmount], Null,
		MatchQ[sampleAmount, UnitsP[Unit]], Unitless[sampleAmount],
		True, sampleAmount
	];

	(* return the completed description *)
	If[!NullQ[amount],
		firstPart<>ToString[numSamps]<>" x "<>UnitForm[amount, Brackets -> False]<>" "<>ToString[sampleType],
		firstPart<>ToString[numSamps]<>" x "<>ToString[sampleType]
	]
];


(* ::Subsubsection::Closed:: *)
(*figureComputable*)


figureComputable[figExpression_]:=(
	SetAttributes[holdingWrapper, HoldAllComplete];
	With[
		{expression=figExpression},
		Apply[
			Module,
			ReleaseHold[
				ReleaseHold[
					ReleaseHold[
						holdingWrapper[
							{},
							expression
						]
					]
				]
			]
		]
	]
);


(* ::Subsubsection::Closed:: *)
(*figureEnvironmentComputable*)


figureEnvironmentComputable[figExpression_]:=(
	SetAttributes[holdingWrapper, HoldAllComplete];
	CellPrint[
		Cell[
			BoxData[
				RowBox[
					Map[
						(\(\ * ToBoxes[#1]\) & ),
Append[
	{},
	Apply[
		Defer,
		ReleaseHold[
			Apply[
				holdingWrapper,
				figExpression
			]
		]
	]
]
]
]
],
"Input"
] /. {x___, aLine:PatternSequence[RowBox[_List], ";"], y___} :> {x, Sequence[aLine, "\r"], y}
]
);



(* ::Subsubsection::Closed:: *)
(*latestAppearance*)


(* pulls the latest Appearnace data from Data field of a sample object and return the attached image *)
latestAppearance[obj:ObjectReferenceP[{Object[Sample], Object[Container]}]]:=Module[
	{appData},

	appData=LastOrDefault[Cases[Download[obj, Data], LinkP[Object[Data, Appearance]]]];

	If[MatchQ[appData, Null],
		Null,
		Download[appData, Image]
	]
];


(* ::Subsubsection:: *)
(*fractionContainerReplacement*)

DefineOptions[fractionContainerReplacement,
	Options:>{
		UploadOption
	}
];

(* pointed to by computable field used in hplc procedure *)
fractionContainerReplacement[object:ObjectP[Object[Protocol, HPLC]],myOptions:OptionsPattern[]]:=With[
	{packet=Download[object]},
	fractionContainerReplacement[packet,myOptions]
];
fractionContainerReplacement[object:ObjectP[Object[Protocol, HPLC]],myOptions:OptionsPattern[]]:=Module[
	{
		upload,autosamplerSmallRackModel,autosamplerLargeRackModel,smallRackPositions, numberOfSmallRackPositions,largeRackPositions, numberOfLargeRackPositions,
		fractionContainersFull, replacementContainers, replacementContainersModel, existingContainersOut, existingContainersOutModel,
		smallRackPositionNames, largeRackPositionNames,
		fractionCollector, autosamplerDeckPlacements, fractionCollectorPlacements,
		numFracContainer,instrumentTimebase, instrumentScale, uploadPacket
	},

	upload=Lookup[ToList[myOptions],Upload,True];

	(* Agilent Small rack for 15 mL tubes *)
	autosamplerSmallRackModel=Experiment`Private`$SmallAgilentHPLCAutosamplerRack;
	(* Agilent Large rack for 50 mL tubes *)
	autosamplerLargeRackModel=Experiment`Private`$LargeAgilentHPLCAutosamplerRack;

	{
		{
			fractionContainersFull,
			replacementContainers,
			replacementContainersModel,
			existingContainersOut,
			existingContainersOutModel,
			fractionCollector,
			autosamplerDeckPlacements,
			fractionCollectorPlacements,
			numFracContainer,
			instrumentTimebase,
			instrumentScale
		},
		{smallRackPositions, numberOfSmallRackPositions},
		{largeRackPositions, numberOfLargeRackPositions}
	}=Quiet[Download[
		{
			object,
			autosamplerSmallRackModel,
			autosamplerLargeRackModel
		},
		{
			{
				AwaitingFractionContainers,
				ReplacementFractionContainers,
				ReplacementFractionContainers[Model][Object],
				ContainersOut,
				ContainersOut[Model][Object],
				Instrument[FractionCollectorDeck],
				AutosamplerDeckPlacements,
				FractionContainerPlacements,
				NumberOfFractionContainers,
				(* Use Scale to tell Dionex and Agilent SemiPreparative and Agilent Preparative *)
				Instrument[Timebase],
				Instrument[Scale]
			},
			{Positions, NumberOfPositions},
			{Positions, NumberOfPositions}
		}
	], {Download::FieldDoesntExist}];

	If[
		Not[TrueQ[fractionContainersFull]],
		Return[{{Null, Null, Null}}]
	];

	fractionCollector=Download[fractionCollector, Object];
	replacementContainers=Download[replacementContainers, Object];
	smallRackPositionNames=(Name /. smallRackPositions);
	largeRackPositionNames=(Name /. largeRackPositions);

	uploadPacket=Which[
		!NullQ[instrumentTimebase],
		(* Dionex *)
		Module[
			{allPositions, requiredPositions, placements},
			allPositions=Apply[
				List,
				Download[
					fractionCollector,
					AllowedPositions
				]
			];

			requiredPositions=allPositions[[;;Length[replacementContainers]]];

			placements=MapThread[
				Function[
					{replacementContainer, position},
					{
						Link[replacementContainer],
						Link[fractionCollector],
						position
					}
				],
				{
					replacementContainers,
					requiredPositions
				}
			];

			Association[
				Object -> object,
				Replace[FractionContainerReplacement] -> placements,
				Append[FractionContainerPlacements] -> placements,
				Append[FractionContainers] -> Link[replacementContainers],
				Replace[ReplacementFractionContainers] -> Table[
					(* 96-well 2mL Deep Well Plate *)
					Link[First[replacementContainersModel]],
					numFracContainer
				]
			]
		],

		(* Agilent SemiPreparative *)
		MatchQ[instrumentScale,SemiPreparative],
		Module[
			{allPositions, requiredPositions, placements},
			allPositions=Apply[
				List,
				Download[
					fractionCollector,
					AllowedPositions
				]
			];

			requiredPositions=allPositions[[;;Length[replacementContainers]]];

			placements=MapThread[
				Function[
					{replacementContainer, position},
					{
						Link[replacementContainer],
						Link[fractionCollector],
						position
					}
				],
				{
					replacementContainers,
					requiredPositions
				}
			];

			Association[
				Object -> object,
				Replace[FractionContainerReplacement] -> placements,
				Append[FractionContainerPlacements] -> placements,
				Append[FractionContainers] -> Link[replacementContainers],
				Replace[CurrentFractionContainers] -> Link[replacementContainers],
				Replace[ReplacementFractionContainers] -> Table[
					(* 96-well 2mL Deep Well Plate *)
					Link[First[replacementContainersModel]],
					numFracContainer
				]
			]
		],

		True,
		(* Agilent Preparative *)
		Module[
			{fractionContainerRackModel,requiredRackNumber,requiredRacks,groupedFractionContainers,vesselPlacements},
			(* Get the model to hold FractionContainers *)
			fractionContainerRackModel=If[MatchQ[FirstOrDefault[replacementContainersModel],Model[Container, Vessel, "id:bq9LA0dBGGR6"]|Model[Container, Vessel, "id:bq9LA0dBGGrd"]],
				(* {Model[Container, Vessel, "50mL Tube"],  Model[Container, Vessel, "50mL Light Sensitive Centrifuge Tube"]} - Large *)
				autosamplerLargeRackModel,
				(* {Model[Container, Vessel, "15mL Tube"], Model[Container, Vessel, "15mL Light Sensitive Centrifuge Tube"]} - Small *)
				autosamplerSmallRackModel
			];
			requiredRackNumber=If[MatchQ[fractionContainerRackModel,autosamplerLargeRackModel],
				numFracContainer/numberOfLargeRackPositions,
				numFracContainer/numberOfSmallRackPositions
			];
			(* Start from the end, we have the fraction containers *)
			requiredRacks=Take[autosamplerDeckPlacements[[All,1]],-requiredRackNumber];
			(* Group the fraction containers *)
			groupedFractionContainers = If[MatchQ[FirstOrDefault[replacementContainersModel],Model[Container, Vessel, "id:bq9LA0dBGGR6"]|Model[Container, Vessel, "id:bq9LA0dBGGrd"]],
				(* {Model[Container, Vessel, "50mL Tube"],  Model[Container, Vessel, "50mL Light Sensitive Centrifuge Tube"]} - Large *)
				PartitionRemainder[replacementContainers,numberOfLargeRackPositions],
				(* {Model[Container, Vessel, "15mL Tube"], Model[Container, Vessel, "15mL Light Sensitive Centrifuge Tube"]} - Small *)
				PartitionRemainder[replacementContainers,numberOfSmallRackPositions]
			];
			vesselPlacements=Join@@MapThread[
				Function[
					{containers,rack},
					Module[
						{rackModel,rackPositionNames},
						rackPositionNames=If[MatchQ[fractionContainerRackModel,autosamplerSmallRackModel],
							smallRackPositionNames,
							largeRackPositionNames
						];
						(* Put each vessel into the position *)
						MapThread[
							{Link[#1],Link[rack],#2}&,
							{containers,Take[rackPositionNames,Length[containers]]}
						]
					]
				],
				{groupedFractionContainers,requiredRacks}
			];
			Association[
				Object -> object,
				Replace[FractionContainerReplacement] -> vesselPlacements,
				Append[FractionContainerPlacements] -> vesselPlacements,
				(* Prep Agilent shares the same autosampler and fraction collection deck. Populate this field so that we can easily pick or store the newest on-deck containers. Not necessary for semi-prep HPLC *)
				Replace[CurrentFractionContainers] -> Link[replacementContainers],
				Append[FractionContainers] -> Link[replacementContainers],
				Replace[ReplacementFractionContainers] -> Table[
					Link[First[replacementContainersModel]],
					numFracContainer
				]
			]
		]

	];

	If[upload,Upload[uploadPacket],uploadPacket]

	(* Return placements for procedure usage *)
	(* Now that this function is called in a stand alone execute task, there's no need to return a value *)
	(*placements*)
];


vacuumEvaporationHoursAndMinutesTimeDisplay[time:TimeP]:=Module[
	{timeHours, timeMinutes, stringHours, stringMinutes},

	timeHours=Floor[Convert[time, Hour]];

	timeMinutes=Mod[time, 60 Minute];

	stringHours=Switch[timeHours,
		LessP[10 Hour],
		"0"<>ToString[Unitless[timeHours]],
		_,
		ToString[Unitless[timeHours]]
	];

	stringMinutes=Switch[timeMinutes,
		LessP[10 Minute],
		"0"<>ToString[Unitless[timeMinutes]],
		_,
		ToString[Unitless[timeMinutes]]
	];

	stringHours<>":"<>stringMinutes

];
