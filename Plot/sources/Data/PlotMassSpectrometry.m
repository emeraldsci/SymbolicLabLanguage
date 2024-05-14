(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(* PlotMassSpectrometry Options *)

DefineOptions[PlotMassSpectrometry,
	(*
	 	In order to let the x-axis showing Mass-To-Charge Ratio (m/z) as the unit, the frame label is hard coded here.
	 	Will change after we add m/z to EmeraldUnit. optionsJoin and generateSharedOptions both in SharedPlotDataOptions.
	*)
	optionsJoin[generateSharedOptions[
		Object[Data, MassSpectrometry],
		MassSpectrum,
		PlotTypes -> {LinePlot},
		Display -> {Peaks},
		DefaultUpdates -> {
			OptionFunctions -> {molecularWeightEpilogs},
			FrameUnits -> {None,None},
			FrameLabel -> {"Mass-to-Charge Ratio (m/z)", None, None, None}
		}],
	Options :>{
		{
			OptionName->ExpectedMolecularWeight,
			Default->Automatic,
			Description->"The molecular weights to be demarked on the plot. Note that the units of the provided value must be compatible with the spectra units.",
			Category->"MolecularWeightEpilog",
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Expression,Pattern:>Alternatives[NumericP,MolecularWeightP,SequenceP,StrandP,Null],Size->Line],
				Adder[Widget[Type->Expression,Pattern:>Alternatives[NumericP,MolecularWeightP,SequenceP,StrandP,Null],Size->Line]],
				Adder[
					Alternatives[
						Widget[Type->Expression,Pattern:>Alternatives[NumericP,MolecularWeightP,SequenceP,StrandP,Null],Size->Line],
						Adder[Widget[Type->Expression,Pattern:>Alternatives[NumericP,MolecularWeightP,SequenceP,StrandP,Null],Size->Line]]
					]
				],
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]]
			]
		},
		{
			OptionName->Truncations,
			Default->0,
			Description->"The number of truncations for each provided sequence or strand to demark on the plot.",
			AllowNull->False,
			Category->"MolecularWeightEpilog",
			Widget->Widget[Type->Number,Pattern:>GreaterEqualP[0]]
        },
		{
			OptionName->TickColor,
			Default-> Opacity[0.5, RGBColor[0.75, 0., 0.25]],
			Description->"The color of the molecular weight ticks.",
			Category->"MolecularWeightEpilog",
			AllowNull->True,
			Widget->Widget[Type->Expression,Pattern:>_Opacity|ColorP,Size->Line]
		},
		{
			OptionName->TickStyle,
			Default->{Thickness[Large]},
			Description->"The style for the text labeling the molecular weight ticks.",
			Category->"MolecularWeightEpilog",
			AllowNull->True,
			Widget->Adder[Widget[Type->Expression,Pattern:>LineStyleP,Size->Line]]
		},
		{
			OptionName->TickSize,
			Default-> 0.5,
			Description-> "The fraction of the plot height each primary molecular weight ticks should occupy.",
			Category->"MolecularWeightEpilog",
			AllowNull->True,
			Widget->Widget[Type->Number,Pattern:>RangeP[0,1]]
       	},
		{
			OptionName->TickLabel,
			Default-> True,
			Description->"Indicates if the primary molecular weight ticks should be labeled.",
			Category->"MolecularWeightEpilog",
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
       	}
	}
	],
	SharedOptions :> {
		ModifyOptions[ListPlotOptions,
			{
				{OptionName->Frame,Default->{True,False,False,False}},
				{OptionName->LabelStyle,Default->{Bold, 12, FontFamily -> "Arial"}},
				{OptionName->Filling,Default->Bottom}
			}
		],

		EmeraldListLinePlot
	}
];


(* ::Section:: *)
(* PlotMassSpectrometry Primary Definitions *)
PlotMassSpectrometry[myInput:rawPlotInputP, myOps:OptionsPattern[PlotMassSpectrometry]] := Module[
	{
		originalOps,safeOps,specificOptions,plotOutputs
	},

	(* Convert the original options into a list *)
	originalOps = ToList[myOps];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotMassSpectrometry,ToList[myOps]];

	(* Options specific to your function which do not get passed directly to the underlying plot *)
	specificOptions=Normal@KeyTake[safeOps,{ExpectedMolecularWeight,Truncations,TickColor,TickStyle,TickSize,TickLabel}];

	(* Call rawToPacket[] *)
	plotOutputs = rawToPacket[
		myInput,
		Object[Data,MassSpectrometry],
		PlotMassSpectrometry,
		(* NOTE - rawToPacket takes safeOps, not originalOps *)
		safeOps
	];

	(* Use the processELLPOutput helper *)
	processELLPOutput[plotOutputs,safeOps,specificOptions]

];

(* Replace EmeraldPlotBlah with the name of your plot function *)
(* PlotMassSpectrometry[myInput:plotInputP, myOps:OptionsPattern[PlotMassSpectrometry]]:= *)
PlotMassSpectrometry[
	myInput:ListableP[ObjectP[{
		Object[Data,MassSpectrometry],
		Object[Data, ChromatographyMassSpectra],
		Object[Data,LCMS],
		Object[Data, TotalProteinDetection]
	}],2],
	myOps:OptionsPattern[PlotMassSpectrometry]
] := Module[
	{
		originalOps, safeOps, specificOptions,
		packets, scanMode, replacedOptionRules, resolvedOptionRules
	},

	(* Convert the original options into a list *)
	originalOps = ToList[myOps];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps = SafeOptions[PlotMassSpectrometry, ToList[myOps]];

	(* Options specific to your function which do not get passed directly to the underlying plot *)
	specificOptions = Normal@KeyTake[safeOps,{ExpectedMolecularWeight,Truncations,TickColor,TickStyle,TickSize,TickLabel}];

	packets = Download[Flatten[ToList[myInput]]];

	(* Get the AssayTypes *)
	scanMode = First@Lookup[packets,ScanMode];

	(*For SelectedIonMonitoring, we will use IonMonitoringIntensity as the data field*)
	replacedOptionRules = If[MatchQ[scanMode,SelectedIonMonitoring],
		{
			PrimaryData->IonMonitoringIntensity,
			Joined->False,
			FrameLabel -> {"Mass-to-Charge Ratio (m/z)", "Arbitrary Unit", None, None}
		},
		{}
	];

	(*Replace rules for SelectedIonMonitoringScan Mode*)
	resolvedOptionRules=ReplaceRule[originalOps,replacedOptionRules];

	(* Call packetToELLP or rawToPacket[] *)
	If[
		MatchQ[scanMode,MultipleReactionMonitoring],

		Module[
			{mrmRawData,firstMass,secondMass,intensity,stringCouple,mrmSafeOps},

			(* Extract the MultipleReactionMonitoring Data*)
			mrmRawData=Flatten[Lookup[packets,ReactionMonitoringIntensity],1];

			(* Extract the first mass selection value (MS1)*)
			firstMass = mrmRawData[[All, 1]];

			(* Extract the second mass selection value (MS2)*)
			secondMass = mrmRawData[[All, 2]];

			(* Collect the MRM intensity*)
			intensity = mrmRawData[[All, 3]];

			(* Generate ms1/ms3 as the chart legend for the bar chart *)
			stringCouple =MapThread[(ToString[Unitless[#1]] <> "/" <>ToString[Unitless[#2]]) &, {firstMass, secondMass}];

			(* Transfer all options to the EmeraldBarChard *)
			mrmSafeOps=ReplaceRule[SafeOptions[EmeraldBarChart,ToList[myOps]],{ChartLabels -> stringCouple}];

			(* Export the MultipleReactionMonitoring graph as a barchart*)
			EmeraldBarChart[intensity, mrmSafeOps]
		],

		Module[
			{plotOutputs},

			plotOutputs = packetToELLP[
				myInput,
				PlotMassSpectrometry,
				(* NOTE - packetToELLP takes originalOps, not safeOps *)
				resolvedOptionRules
			];
			(* Use the processELLPOutput helper *)
			processELLPOutput[plotOutputs,safeOps,specificOptions]
		]

	]

];


(* ::Subsubsection:: *)
(* Helper Functions *)

molecularWeightEpilogs[infs:_, ops:_] := Module[
	{
		masses, rawEpilogs
	},

	masses = getMolecularWeights[infs, ops[ExpectedMolecularWeight], ops];
	rawEpilogs = DeleteCases[epilog[masses,ops],NullP];
	VerticalLine->((Cases[{rawEpilogs},{(_?NumericQ|MolecularWeightP),RangeP[0,1],_Style|_String,(_Opacity|_?ColorQ),___},Infinity])/.{{}->Null})
];

getMolecularWeights[infs:_, molecularWeightOption:_, ops:_] := Module[{},
	Switch[molecularWeightOption,
		Automatic, getMolecularWeights[infs, lookupMassesOrStrands[infs,ops[Truncations]], ops],
		StrandP, ExactMass[Truncate[molecularWeightOption,ops[Truncations]]],
		{StrandP..}, ExactMass[Truncate[#,ops[Truncations]]]&/@molecularWeightOption,
		SequenceP, ExactMass[Truncate[molecularWeightOption,ops[Truncations]]],
		{SequenceP..}, ExactMass[Truncate[#,ops[Truncations]]]&/@molecularWeightOption,
		(_?NumericQ), {molecularWeightOption*Gram/Mole},
		{(_?NumericQ)..}, {#*Gram/Mole}&/@molecularWeightOption,
		{(MolecularWeightP)..}, {#}&/@molecularWeightOption,
		_, molecularWeightOption
	]
];

lookupMassesOrStrands[infs_, truncs_] := Module[
	{
		downloadPacket,
		analyteObjects, analyteMolecularWeights, compositionObjects,
		ionModes, positiveReferencePeaks, negativeReferencePeaks,
		analyteWeights, compositionWeights,
		referencePeaks, flattenSortPeaks, ionizedPeaks
	},

	(* Download MS data. *)
	downloadPacket = Quiet[
		Download[
			infs,
			{
				SamplesIn[Analytes][Object],
				SamplesIn[Analytes][MolecularWeight],
				SamplesIn[Composition][[All,2]],
				IonMode,
				SamplesIn[Model][ReferencePeaksPositiveMode],
				SamplesIn[Model][ReferencePeaksNegativeMode]

			}
		],
		{Download::FieldDoesntExist,Download::MissingField}
	];

	(* Unpack the downloaded data. *)
	analyteObjects = downloadPacket[[All,1]];
	analyteMolecularWeights = downloadPacket[[All,2]]; (* Molecular weights of Analytes (if defined, empty list otherwise) *)
	compositionObjects = downloadPacket[[All,3]]  /. {Null->Nothing};
	ionModes = downloadPacket[[All,4]]/.Null->Nothing;
	positiveReferencePeaks = downloadPacket[[All,5]];
	negativeReferencePeaks = downloadPacket[[All,6]];

	(* Early Exit for no analyte and no composition Objects. *)
	If[MatchQ[analyteObjects, {{}}] && MatchQ[compositionObjects, {{}}],
		Return[{}]
	];

	(*Resolve the analyte and composition weights. *)
	analyteWeights = resolveAnalyteWeights[analyteObjects, analyteMolecularWeights, truncs];

	(*
	This part gets wierd in two scenarios:
			1. When there are multiple input objects with Map->False (overlaid plots),
			2. When the input is raw mass spectrum data.

	Solutions to each are:
			1. Map over the composition objects.
			2. The $Failed overloads for resolveCompositionWeights.
	*)
	compositionWeights = Map[resolveCompositionWeights[#, truncs]&, compositionObjects];

	(* Generate the reference, flattenSortPeaks(?), and ionized peak sets. *)
	referencePeaks = generateReferencePeaks[ionModes, positiveReferencePeaks, negativeReferencePeaks];
	flattenSortPeaks = generateFlattenSortPeaks[analyteWeights, compositionWeights, referencePeaks];
	ionizedPeaks = generateIonizedPeaks[ionModes, flattenSortPeaks];

	(* Generate final peaks set and return. *)
	generateFinalPeaks[referencePeaks, ionizedPeaks]

];

resolveAnalyteWeights[analyteObjects_, analyteMolecularWeights_, truncs_] := Module[
	{
		analyteExactMass, analyteWeights
	},

	(* Calculate ExactMass*)
	analyteExactMass = Map[
		If[MatchQ[#[Molecule],ListableP[StrandP|SequenceP|StructureP]],
			Quiet[
				ExactMass[Flatten@Truncate[#[Molecule],truncs], ExactMassResolution->0.1 Dalton],
				{Warning::MoleculeNotFound}
			],
			ExactMass[#, ExactMassResolution->0.1 Dalton]
		]&,
		analyteObjects,
		{2}
	] /. {$Failed->{}};

	(*If we can extract Exact Mass we use exact mass, otherwise we use molecular weight*)
	analyteWeights = If[Length[Flatten[analyteExactMass]]>0,
		analyteExactMass,
		analyteMolecularWeights
	];

	analyteWeights

];


resolveCompositionWeights[$Failed, truncs_] := {{{$Failed}}};
resolveCompositionWeights[{$Failed..}, truncs_] := {{{{$Failed}}}};
resolveCompositionWeights[compositionObjects_, truncs_] := Module[
	{
		compositionMolecules, compositionMolecularWeights,
		moleculeDuplicatePositions, uniqueMoleculePositions, uniqueMolecules, uniqueMolecularWeights,
		compositionWeights,
		expandedArrayDisordered, expandedArrayDisorderedReformatted, expandedArrayOrdered
	},

	(* Get a list of all unique composition objects, and remove duplicates. *)
	{compositionMolecules, compositionMolecularWeights} = Transpose[Download[Flatten[compositionObjects], {Molecule, MolecularWeight}]];
	moleculeDuplicatePositions = positionDuplicates[compositionMolecules];
	uniqueMoleculePositions = Map[First, moleculeDuplicatePositions];
	uniqueMolecules = Map[compositionMolecules[[#]]&, uniqueMoleculePositions];
	uniqueMolecularWeights = Map[compositionMolecularWeights[[#]]&, uniqueMoleculePositions];

	(* Molecular weights of the Models in the composition of SamplesIn *)
	compositionWeights = MapThread[
		If[MatchQ[#1,StrandP|SequenceP|StructureP],
			{Sequence@@Quiet[
				ExactMass[ToList[Truncate[#1,truncs]], ExactMassResolution->0.1 Dalton]
			]},
			{#2}
		]&,
		{uniqueMolecules, uniqueMolecularWeights}
	];

	(* Expand compositionWeights to match the length and listedness of the composition objects. *)
	expandedArrayDisordered = MapThread[
		ConstantArray[#1, Length[#2]]&,
		{compositionWeights, moleculeDuplicatePositions}
	];
	expandedArrayDisorderedReformatted = Map[Sequence@@#&, expandedArrayDisordered];
	expandedArrayOrdered = {{expandedArrayDisorderedReformatted[[Flatten[moleculeDuplicatePositions]]]}};

	(* Return the ordered expanded array. *)
	expandedArrayOrdered

];

generateReferencePeaks[ionModes_, positiveReferencePeaks_, negativeReferencePeaks_] := Module[
	{
		referencePeaks
	},

	(*Generate reference peaks based on the IonMode, positive for ReferencePeaksPositiveMode, negative for ReferencePeaksNegativeMode*)
	referencePeaks = If[Length[ionModes]>0,
		MapThread[
			Function[{eachIonMode,eachPositiveReferencePeak,eachNegativeReferencePeak},
				If[MatchQ[eachIonMode,Positive],
					(*Extract the ReferencePeaksPositiveMode for Positive IonMode and ReferencePeaksNegativeMode for Negative IonMode*)
					SafeRound[#,0.1]&/@eachPositiveReferencePeak,
					SafeRound[#,0.1]&/@eachNegativeReferencePeak
				]
			],
			{ionModes,positiveReferencePeaks,negativeReferencePeaks}
		],
		{}
	];

	(* Return the referencePeaks *)
	referencePeaks

];

generateFlattenSortPeaks[analyteWeights_, compositionWeights_, referencePeaks_] := Module[
	{
		compositionAnalytesMolecularWeights, flattenRefPeaks,
		sortedMolecularWeights, flattenSortPeaks
	},

	(* Construct the analyte's mass packet *)
	compositionAnalytesMolecularWeights = Transpose[{analyteWeights, compositionWeights}];

	(* Flatten all values by 1 level to make sure the length of the list is matching the length of the infs *)
	flattenRefPeaks = Flatten[referencePeaks,1];

	(* pull the analytes field if there otherwise populate with the composition information *)
	sortedMolecularWeights = If[MatchQ[#[[1]],Except[{{}}]],
		#[[1]] /. Null->Nothing,
		#[[2]] /. Null->Nothing
	]& /@ compositionAnalytesMolecularWeights;

	(* Flatten the sort peaks by 1 level to match the length and return. *)
	flattenSortPeaks = Flatten[sortedMolecularWeights,1]

];

generateIonizedPeaks[ionModes_, flattenSortPeaks_] := Module[
	{
		ionizedPeaks
	},

	(* Based on the IonMode, adjust the peaks by +1 for [M+H]+ and -1 for [M-H]-. *)
	ionizedPeaks = If[(Length[ionModes]===Length[flattenSortPeaks] && Length[ionModes]>0),
		MapThread[
			If[
				MatchQ[#1,Positive],
				(#2 + 1 Gram/Mole),
				(#2 - 1 Gram/Mole)
			]&,
			{ionModes,flattenSortPeaks}
		],
		flattenSortPeaks
	];

	(* Return the ionizedPeaks. *)
	ionizedPeaks
];

generateFinalPeaks[referencePeaks_, ionizedPeaks_] := Module[
	{
		finalPeaksBasedOnReference, finalPeaks
	},

	(*Export the final mass peaks for the analysis, if we have reference peaks for the SamplesIn[Model], we use reference peak, else we use ionized peaks.*)
	finalPeaksBasedOnReference = MapThread[
		If[Length[#1]==0||!FreeQ[#1,$Failed]||NullQ[#1],
			#2,
			#1
		]&,
		{referencePeaks,ionizedPeaks}
	];

	finalPeaks = Flatten[finalPeaksBasedOnReference]/.Null->Nothing

];

positionDuplicates[list_] := GatherBy[Range@Length[list], list[[#]]&];


(* ::Section:: *)
(* PlotPrimative Helper Functions *)
epilog[masses:{(_?NumericQ|MolecularWeightP|NullP)..}, ops_] := MapThread[
	If[MatchQ[#1,NullP],
		Null,
		{#1, #2, #3, ops[TickColor], Sequence@@(ops[TickStyle])}
	]&,
	{masses, tickSize[masses,ops], label[masses,ops]}
];

epilog[doubleListedMasses:{(NullP|{(_?NumericQ|MolecularWeightP|NullP)..})..}, ops_] := epilog[#,ops]&/@doubleListedMasses;
epilog[mass:(_?NumericQ|MolecularWeightP),ops_] := First[epilog[{mass},ops]];
epilog[a_,b_] := Null;
epilog[a_] := Null;


tickSize[doubleListedMasses:{{(_?NumericQ|MolecularWeightP|Null)..}..},ops_] := tickSize[#,ops]&/@doubleListedMasses;
tickSize[masses:{(_?NumericQ|MolecularWeightP|Null)..},ops_] := Table[ops[TickSize]/n,{n,1,Length[masses]}];
tickSize[mass:(_?NumericQ|MolecularWeightP|Null),ops_] := ops[TickSize];
tickSize[a_,b_] := Null;
tickSize[a_] := Null;


label[doubleListedMasses:{{(_?NumericQ|MolecularWeightP|Null)..}..},ops_] := label[#,ops]&/@doubleListedMasses;
label[masses:{(_?NumericQ|MolecularWeightP|Null)..},ops_] := Flatten[{labelString[First[masses],ops],ConstantArray["",Length[Rest[masses]]]}];
label[mass:(_?NumericQ|MolecularWeightP),ops_] := labelString[mass,ops];
labelString[mass_,ops_] := If[MatchQ[ops[TickLabel],True],
	Style[ToString[Unitless[mass,Dalton]],Sequence@@ops[LabelStyle]],
	""
];
label[a_,b_] := Null;
label[a_] := Null;
