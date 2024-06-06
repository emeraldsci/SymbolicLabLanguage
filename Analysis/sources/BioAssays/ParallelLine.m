(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Misc helpers*)


(* ::Subsubsection::Closed:: *)
(*pattern*)


numericOrQuantityCoordinatesP = CoordinatesP | QuantityCoordinatesP[];


fitTypeSymbolP = Polynomial | Exponential | Sigmoid | Log | Tanh | ArcTan | Erf | Logistic | SinhCosh | Exp4;


DefaultFitField = {
	Object[Analysis, Peaks]->Position,
	Model[Sample, StockSolution, Standard]->ReferencePeaksPositiveMode,
	Object[Data, AbsorbanceSpectroscopy]->AbsorbanceSpectrum,
	Object[Data, Volume]->Volume,
	Object[Data, Microscope]->PhaseContrastCellCount,
	Object[Data, qPCR]->QuantificationCycle,
	Object[Analysis, QuantificationCycle]->QuantificationCycle,
	Object[Analysis, CellCount]->CellCount,
	Object[Analysis, MeltingPoint]->MeltingTemperature,
	Object[Data, FluorescenceIntensity]->Intensities,
	Object[Data, FluorescenceKinetics]->EmissionTrajectories,
	Object[Simulation, MeltingTemperature]->MeltingTemperature,
	Object[Simulation, Enthalpy]->Enthalpy,
	Object[Simulation, Entropy]->Entropy,
	Object[Simulation, FreeEnergy]->FreeEnergy,
	Object[Simulation, EquilibriumConstant]->EquilibriumConstant
};


DefaultSecondaryFitField = {
	Object[Analysis, Peaks]->Area,
	Object[Data, Volume]->LiquidLevel,
	Object[Data, FluorescenceIntensity]->DualEmissionIntensities
};


(* ::Subsection:: *)
(*AnalyzeParallelLine*)


DefineOptions[AnalyzeParallelLine,
	Options :> {
		{
			OptionName -> Exclude,
			Default -> {},
			Description -> "List of data points, or indices of data points, to exclude from fitting.",
			AllowNull -> False,
			Widget -> Widget[Type->Expression, Pattern:>(CoordinatesP | {_Integer..} | {}), Size->Paragraph]
		},
		{
			OptionName -> Domain,
			Default -> Automatic,
			Description -> "Points outside Domain will be excluded from fitting.",
			ResolutionDescription -> "Automatic resolves to All, allowing all points to be included for fitting.",
			AllowNull -> False,
			Widget -> Alternatives[
						{
							"Min" -> Widget[Type->Number, Pattern:>RangeP[-Infinity, Infinity]],
							"Max" -> Widget[Type->Number, Pattern:>RangeP[-Infinity, Infinity]]
						},
						Adder[{
							"Min" -> Widget[Type->Number, Pattern:>RangeP[-Infinity, Infinity]],
							"Max" -> Widget[Type->Number, Pattern:>RangeP[-Infinity, Infinity]]
						}]
					]
		},
		{
			OptionName -> ExcludeOutliers,
			Default -> False,
			Description -> "Determines whether or not to exclude from fitting points labeled as outliers. If the value is False, outliers will not be excluded from fitting. If value is True , any points initially identified as outliers will be excluded from fitting.",
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>(BooleanP|Repeatedly)]
		},
		{
			OptionName -> OutlierDistance,
			Default -> 1.5,
			Description -> "Coefficient of interquartile range of the fit residuals to be used for computing outliers. A point will be considered an outlier if its residual is less that the Q1 - OutlierDistance * IQR, or greater than Q3 + OutlierDistance * IQR.",
			AllowNull -> False,
			Widget -> Widget[Type->Number, Pattern:> GreaterP[0]]
		},
		{
			OptionName -> LogTransformed,
			Default -> True,
			Description -> "True when the input x axis is log-transformed, False otherwise.",
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>BooleanP]
		},
		{
			OptionName -> LogBase,
			Default -> 2,
			Description -> "The log base used to transform concentrations to log scale.",
			AllowNull -> False,
			Widget -> Widget[Type->Number, Pattern:>GreaterP[0]]
		},
		{
			OptionName -> Name,
			Default -> Null,
			Description -> "Name to be used as the name of Object[Analysis, ParallelLine] generated by the analysis.",
			AllowNull -> True,
			Category -> "General",
			Widget -> Widget[Type->Expression,Pattern:>_String, Size -> Line]
		},
		OutputOption,
		UploadOption,
		AnalysisTemplateOption
	}


];


(* ::Subsubsection:: *)
(*AnalyzeParallelLine*)


(*analyzeFitRawDataP = (MatrixP[NumericP]|MatrixP[UnitsP[]]|MatrixP[_?DistributionParameterQ]| MatrixP[UnitsP[]|_?DistributionParameterQ] | _?QuantityMatrixQ);
analyzeFitObjectInputP = Alternatives[
	{{(ObjectP[]|FieldReferenceP[]|UnitsP[])..}..},
	{(ObjectP[]|FieldReferenceP[]|{ObjectP[]..}|{FieldReferenceP[]..}|{UnitsP[]..})..}
];
analyzeFitDataP = Alternatives[analyzeFitRawDataP, analyzeFitObjectInputP];*)
analyzeParallelLineDataP = Alternatives[DataPointsP, ObjectP[Object[Analysis, Fit]]];


AnalyzeParallelLine[xySTD:analyzeParallelLineDataP, xyAnalyte:analyzeParallelLineDataP, ops:OptionsPattern[]]:=Module[
	{
		listedOptions, output, outputSpecification, gatherTests, safeOptions, safeOptionTests, standardFieldsStart, validLengths,validLengthTests,
		unresolvedOptions,templateTests,combinedOptions,pcktSTD, optionsSTD, testsSTD,pcktAnalyte, optionsAnalyte, testsAnalyte, resolvedOptionsResult,
		resolvedOptions,resolvedOptionsTests,resolvedInputsResult,optionsRule,previewRule,testsRule,resultRule, xySTDResolved, xyAnalyteResolved, referenceSTD, 
		referenceAnalyte, references
	},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[ops];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* resolve standard start field *)
	standardFieldsStart = analysisPacketStandardFieldsStart[listedOptions];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests}=If[gatherTests,
		{SafeOptions[AnalyzeParallelLine,listedOptions,AutoCorrect->False],{}},
		{SafeOptions[AnalyzeParallelLine,listedOptions,AutoCorrect->False],Null}
	];

	(* If the specified options don't match their patterns return $Failed *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		{ValidInputLengthsQ[AnalyzeParallelLine,{xySTD,xyAnalyte},listedOptions],{}},
		{ValidInputLengthsQ[AnalyzeParallelLine,{xySTD,xyAnalyte},listedOptions],Null}
	];

	(* If option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOptionTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{unresolvedOptions,templateTests}=If[gatherTests,
		{ApplyTemplateOptions[AnalyzeParallelLine,{xySTD,xyAnalyte},listedOptions],{}},
		{ApplyTemplateOptions[AnalyzeParallelLine,{xySTD,xyAnalyte},listedOptions],Null}
	];

	combinedOptions=ReplaceRule[safeOptions,unresolvedOptions];

	(* resolve the inputs first before Options *)
	{xySTDResolved, referenceSTD} = Switch[xySTD,
		ObjectP[Object[Analysis, Fit]], {Download[xySTD, DataPoints], Link[xySTD, ParallelLineAnalyses]},
		_, {xySTD, Null}
	];
					
	{xyAnalyteResolved, referenceAnalyte} = Switch[xyAnalyte,
		ObjectP[Object[Analysis, Fit]], {Download[xyAnalyte, DataPoints], Link[xyAnalyte, ParallelLineAnalyses]},
		_, {xyAnalyte, Null}
	];
	
	references = If[MatchQ[{referenceSTD, referenceAnalyte}, {Null..}],
		{},
		{referenceSTD, referenceAnalyte}
	];

	resolvedInputsResult = Check[
		(* call AnalyzeFit to get resilved options, tests and packet *)
		{pcktSTD, optionsSTD, testsSTD} = AnalyzeFit[xySTDResolved, LogisticFourParam, ReplaceRule[combinedOptions, {Upload->False, Output->{Result, Options, Tests}}]];
		{pcktAnalyte, optionsAnalyte, testsAnalyte} = AnalyzeFit[xyAnalyteResolved, LogisticFourParam, ReplaceRule[combinedOptions, {Upload->False, Output->{Result, Options, Tests}}]],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* Call resolve<Function>Options *)
	(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating we can't actually return the standard result *)
	resolvedOptionsResult=Check[
		{resolvedOptions,resolvedOptionsTests}=If[gatherTests,
			resolveAnalyzeParallelLineOptions[optionsSTD, testsSTD, optionsAnalyte, testsAnalyte, combinedOptions, Output->{Result,Tests}],
			{resolveAnalyzeParallelLineOptions[optionsSTD, testsSTD, optionsAnalyte, testsAnalyte, combinedOptions], Null}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	If[MemberQ[{resolvedInputsResult, resolvedOptionsResult}, $Failed], Return[$Failed]];

	(* --- Generate rules for each possible Output value ---  *)

	(* Prepare the Options result if we were asked to do so *)
	optionsRule=Options->If[MemberQ[output,Options],
		RemoveHiddenOptions[AnalyzeParallelLine,resolvedOptions],
		Null
	];

	cntForFitName = 0;
	(* Prepare the Preview result if we were asked to do so *)
	previewRule=Preview->If[MemberQ[output,Preview],
		drawParallelLinePreview[pcktSTD, pcktAnalyte],
		Null
	];

	(* Prepare the Test result if we were asked to do so *)
	testsRule=Tests->If[MemberQ[output,Tests],
		(* Join all exisiting tests generated by helper functions with any additional tests *)
		Join[safeOptionTests,validLengthTests,templateTests,resolvedOptionsTests],
		Null
	];

	cntForFitName = 0;
	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule=Result->If[MemberQ[output,Result],
		If[MatchQ[resolvedOptionsResult,$Failed],
			$Failed,
			With[{res = wrapParallelLineUploadPacket[standardFieldsStart, resolvedOptions, pcktSTD, pcktAnalyte, references]},
				If[Lookup[resolvedOptions, Upload],
					Object/.res,
					res
				]
			]
		],
		Null
	];

	outputSpecification/.{previewRule,optionsRule,testsRule,resultRule}

];


AnalyzeParallelLine[xySTD:analyzeParallelLineDataP, xyAnalytes:{analyzeParallelLineDataP..}, ops:OptionsPattern[]]:= AnalyzeParallelLine[xySTD, #, ops]&/@xyAnalytes;


drawParallelLinePreview[pcktSTD_, pcktAnalyte_]:= Module[
	{bestFitExprSTD, bestFitExprAnalyte, EC50STD, EC50Analyte, EC50DashedLine},
	
	{bestFitExprSTD, bestFitExprAnalyte, EC50STD, EC50Analyte} = {
		pcktSTD[BestFitExpression],
		pcktAnalyte[BestFitExpression],
		selectInflectionPoint[pcktSTD[Replace[BestFitParameters]]][[1,2]],
		selectInflectionPoint[pcktAnalyte[Replace[BestFitParameters]]][[1,2]]

	};

	EC50DashedLine = Graphics[
		{
			Dashed, Orange, Thickness[0.005], Line[{{EC50STD, 0}, {EC50STD, bestFitExprSTD/.{x->EC50STD}}}],
			Orange, Thickness[0.005], Arrow[{{EC50STD, bestFitExprSTD/.{x->EC50STD}}, {EC50Analyte, bestFitExprAnalyte/.{x->EC50Analyte}}}],
			Dashed, Orange, Thickness[0.005], Line[{{EC50Analyte, 0}, {EC50Analyte, bestFitExprAnalyte/.{x->EC50Analyte}}}]
		}
	];

	Zoomable@Show[
		PlotFit[pcktSTD, Display->{DataError}], 
		PlotFit[pcktAnalyte, Display->{DataError}], 
		EC50DashedLine
	]

];


selectInflectionPoint[params_]:= Select[params, First[#]==InflectionPoint&];


(* ::Subsection:: *)
(*Resolution*)


(* ::Subsubsection:: *)
(*resolveAnalyzeParallelLineOptions*)


DefineOptions[resolveAnalyzeParallelLineOptions,
	Options:>{
		{Output->Result,ListableP[Result|Tests],"Indicates the return value of the function."}
	}
];


resolveAnalyzeParallelLineOptions[optionsSTD_, testsSTD_, optionsAnalyte_, testsAnalyte_, combinedOptions_, ops:OptionsPattern[]]:= Module[
	{output, listedOutput, collectTestsBoolean, resolvedOptions, allTests},

	(* From resolveAnalyzeFitOptions's options, get Output value *)
	output=OptionDefault[OptionValue[Output]];
	listedOutput=ToList[output];
	collectTestsBoolean=MemberQ[listedOutput,Tests];

	resolvedOptions = ReplaceRule[combinedOptions, 
		{
			Exclude-> Join[Lookup[optionsSTD, Exclude], Lookup[optionsAnalyte, Exclude]],
			Domain -> {
						{Min[Lookup[optionsSTD, Domain][[1]][[1]], Lookup[optionsAnalyte, Domain][[1]][[1]]],
						Max[Lookup[optionsSTD, Domain][[1]][[2]], Lookup[optionsAnalyte, Domain][[1]][[2]]]}
					},
			ExcludeOutliers -> Lookup[optionsSTD, ExcludeOutliers],
			OutlierDistance -> Lookup[optionsSTD, OutlierDistance],
			Name -> Lookup[optionsSTD, Name]
		}
	];


	allTests=If[collectTestsBoolean,
		Flatten[{First[#], Last[#]}&/@{testsSTD, testsAnalyte}],
		Null
	];

	output/.{Tests->allTests,Result->resolvedOptions}

];


(* ::Subsection:: *)
(*Formatting packet*)


(* ::Subsubsection:: *)
(*formatParallelLinePacket*)


(*formatParallelLinePacket[standardFieldsStart_, resolvedOps_, pcktSTD_, pcktAnalyte_, references_]:=<||>;*)

formatParallelLinePacket[standardFieldsStart_, resolvedOps_, pcktSTD_, pcktAnalyte_, references_] := Module[
	{dataUnits,vars,packet,relativePotencyDist, ids},

	cntForFitName = cntForFitName + 1;

	relativePotencyDist = PropagateUncertainty[
							A/B,
							{A\[Distributed] NormalDistribution[Lookup[pcktSTD,Replace[BestFitParameters]][[2,2]], Lookup[pcktSTD,Replace[BestFitParameters]][[2,3]]], 
							 B \[Distributed] NormalDistribution[Lookup[pcktAnalyte,Replace[BestFitParameters]][[2,2]], Lookup[pcktAnalyte,Replace[BestFitParameters]][[2,3]]]},
							 Method->Empirical
						];

	ids = CreateID[{Object[Analysis,ParallelLine]}];

	packet = Association[
		Join[
			standardFieldsStart,
			FilterRules[Normal@pcktSTD,{
				Replace[DataUnits],ExpressionType,SymbolicExpression
			}],
			{
				Name -> If[MatchQ[Lookup[resolvedOps, Name], Null],
					Null,
					If[cntForFitName==1,
						Lookup[resolvedOps, Name],
						Lookup[resolvedOps, Name] <> " " <> ToString[cntForFitName]
					]
				]
			},
			{
				Object -> First[ids],
				Type -> Object[Analysis, ParallelLine],
				ResolvedOptions -> resolvedOps,
				Replace[Reference] -> references,
				
				DataPointsStandard -> Lookup[pcktSTD, DataPoints],
				DataPointsAnalyte -> Lookup[pcktAnalyte, DataPoints],
				Exclude -> Lookup[resolvedOps, Exclude],
				Replace[MinDomain] -> First/@Lookup[resolvedOps,Domain],
				Replace[MaxDomain] -> Last/@Lookup[resolvedOps,Domain],
				
				Outliers -> Join[Lookup[pcktSTD, Outliers], Lookup[pcktAnalyte, Outliers]],
				Replace[RSquared] -> {Lookup[pcktSTD, RSquared], Lookup[pcktAnalyte, RSquared]},
				Replace[AdjustedRSquared] -> {Lookup[pcktSTD, AdjustedRSquared], Lookup[pcktAnalyte, AdjustedRSquared]},
				
				ANOVATableStandard -> Lookup[pcktSTD, ANOVATable],
				ANOVATableAnalyte -> Lookup[pcktAnalyte, ANOVATable],
				Replace[ANOVAOfModel] -> {
											Prepend[Lookup[pcktSTD, Replace[ANOVAOfModel]], Standard],
											Prepend[Lookup[pcktAnalyte, Replace[ANOVAOfModel]], Analyte]
										},
				Replace[ANOVAOfError] -> {
											Prepend[Lookup[pcktSTD, Replace[ANOVAOfError]], Standard],
											Prepend[Lookup[pcktAnalyte, Replace[ANOVAOfError]], Analyte]
										},
				Replace[ANOVAOfTotal] -> {
											Prepend[Lookup[pcktSTD, Replace[ANOVAOfTotal]], Standard],
											Prepend[Lookup[pcktAnalyte, Replace[ANOVAOfTotal]], Analyte]
										},
				
				Replace[FStatistic] -> {Lookup[pcktSTD, FStatistic], Lookup[pcktAnalyte, FStatistic]},
				Replace[FCritical] -> {Lookup[pcktSTD, FCritical], Lookup[pcktAnalyte, FCritical]},
				Replace[FTestPValue] -> {Lookup[pcktSTD, FTestPValue], Lookup[pcktAnalyte, FTestPValue]},
				Replace[BestFitFunction] -> {Lookup[pcktSTD,BestFitFunction], Lookup[pcktAnalyte,BestFitFunction]},
				Replace[BestFitExpression] -> {Lookup[pcktSTD,BestFitExpression], Lookup[pcktAnalyte,BestFitExpression]},
				Replace[BestFitParametersStandard]->Lookup[pcktSTD,Replace[BestFitParameters]],
				Replace[BestFitParametersAnalyte]->Lookup[pcktAnalyte,Replace[BestFitParameters]],
				
				RelativePotency -> Mean[relativePotencyDist],
				RelativePotencyDistribution -> relativePotencyDist
			}
		]
	]

];


(* ::Subsubsection:: *)
(*wrapParallelLineUploadPacket*)


wrapParallelLineUploadPacket[standardFieldsStart_, resolvedOptions_, pcktSTD_, pcktAnalyte_, references_]:= Module[
	{parallelLinePackets, fitPackets, uploadedPackets},
	
	parallelLinePackets = formatParallelLinePacket[standardFieldsStart, resolvedOptions, pcktSTD, pcktAnalyte, references];

	fitPackets = <|
		Object -> #[Object],
		Append[ParallelLineAnalyses] -> Link[parallelLinePackets[Object], Reference]
	|>&/@references;
	
	If[Lookup[resolvedOptions, Upload] && fitPackets=!={}, Upload[fitPackets]];

	uploadedPackets = uploadAnalyzePackets[{{parallelLinePackets, {}}}];

	First[First[uploadedPackets]]

];


(* ::Subsection:: *)
(*AnalyzeParallelLineOptions*)


DefineOptions[AnalyzeParallelLineOptions,
	SharedOptions :> {AnalyzeParallelLine},
	{
		OptionName -> OutputFormat,
		Default -> Table,
		AllowNull -> False,
		Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
		Description -> "Determines whether the function returns a table or a list of the options."
	}];


AnalyzeParallelLineOptions[xySTD:analyzeParallelLineDataP, xyAnalyte:analyzeParallelLineDataP, ops:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions, options},

	listedOptions = ToList[ops];

	(* remove the Output and OutputFormat option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

	options = AnalyzeParallelLine[xySTD,xyAnalyte,Append[noOutputOptions,Output->Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,AnalyzeParallelLine],
		options
	]
];


AnalyzeParallelLineOptions[xySTD:analyzeParallelLineDataP, xyAnalytes:{analyzeParallelLineDataP..}, ops:OptionsPattern[]]:= AnalyzeParallelLineOptions[xySTD, #]&/@xyAnalytes;


(* ::Subsection:: *)
(*AnalyzeParallelLinePreview*)


DefineOptions[AnalyzeParallelLinePreview,
	SharedOptions :> {AnalyzeParallelLine}
];


AnalyzeParallelLinePreview[xySTD:analyzeParallelLineDataP, xyAnalyte:analyzeParallelLineDataP, ops:OptionsPattern[]]:=Module[
	{preview},

	preview = AnalyzeParallelLine[xySTD,xyAnalyte,Append[ToList[ops],Output->Preview]];

	If[MatchQ[preview, $Failed|Null],
		Null,
		preview
	]
];


AnalyzeParallelLinePreview[xySTD:analyzeParallelLineDataP, xyAnalytes:{analyzeParallelLineDataP..}, ops:OptionsPattern[]]:= AnalyzeParallelLinePreview[xySTD, #]&/@xyAnalytes;


(* ::Subsection:: *)
(*ValidAnalyzeParallelLineQ*)


DefineOptions[ValidAnalyzeParallelLineQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {AnalyzeParallelLine}
];


ValidAnalyzeParallelLineQ[xySTD:analyzeParallelLineDataP, xyAnalyte:analyzeParallelLineDataP,ops:OptionsPattern[]]:=Module[
	{preparedOptions,functionTests,initialTestDescription,allTests,verbose, outputFormat},

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[ToList[ops],Output->Tests],{Verbose,OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=AnalyzeParallelLine[xySTD,xyAnalyte,preparedOptions];

	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[functionTests,$Failed],
		{Test[initialTestDescription,False,True]},

		Module[{initialTest,validObjectBooleans,inputObjs,voqWarnings,testResults},
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			inputObjs = Cases[Flatten[{xySTD, xyAnalyte}], _Object | _Model];

			If[!MatchQ[inputObjs, {}],
				validObjectBooleans=ValidObjectQ[inputObjs,OutputFormat->Boolean];

				voqWarnings=MapThread[
					Warning[ToString[#1,InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
						#2,
						True
					]&,
					{inputObjs,validObjectBooleans}
				];

				(* Get all the tests/warnings *)
				Join[functionTests,voqWarnings],

				functionTests
			]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = OptionDefault[OptionValue[{Verbose, OutputFormat}]];

	(* TODO: update to call with options or use different function once that's worked out*)
	(* Run the tests as requested *)
	RunUnitTest[<|"ValidAnalyzeParallelLineQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose]["ValidAnalyzeParallelLineQ"]
];


ValidAnalyzeParallelLineQ[xySTD:analyzeParallelLineDataP, xyAnalytes:{analyzeParallelLineDataP..},ops:OptionsPattern[]]:= ValidAnalyzeParallelLineQ[xySTD, #]&/@xyAnalytes;