(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Misc helpers*)


(* ::Subsubsection::Closed:: *)
(*pattern*)


(* numericOrQuantityCoordinatesP = CoordinatesP | QuantityCoordinatesP[]; *)

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
	Object[Sample]->Concentration,
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


(* ::Subsection::Closed:: *)
(*AnalyzeFit*)


DefineOptions[AnalyzeFit,
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
			OptionName -> Range,
			Default -> Automatic,
			Description -> "Points outside Range will be excluded from fitting.",
			ResolutionDescription -> "Automatic resolves to All, allowing all points to be included for fitting.",
			AllowNull -> False,
			Widget -> {
						"Min" -> Widget[Type->Number, Pattern:>RangeP[-Infinity, Infinity]],
						"Max" -> Widget[Type->Number, Pattern:>RangeP[-Infinity, Infinity]]
					}
		},
		{
			OptionName -> ExcludeOutliers,
			Default -> False,
			Description -> "Determines whether or not to exclude from fitting points labeled as outliers. If the value is False, outliers will not be excluded from fitting. If value is True , any points initially identified as outliers will be excluded from fitting.  If value is Repeatedly, after fitting outliers will be recalculated and a new fitting performed with the newest outliers also exlcuded, and this process will be repeated up to 3 times.",
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
			OptionName -> PolynomialDegree,
			Default -> 1,
			Description -> "Degree of polynomial if fitType is Polynomial.",
			AllowNull -> False,
			Widget -> Widget[Type->Number, Pattern:>GreaterEqualP[0,1]]
		},
		{
			OptionName -> LogBase,
			Default -> 10,
			Description -> "Degree of polynomial if fitType is Polynomial.",
			AllowNull -> False,
			Widget -> Widget[Type->Number, Pattern:>GreaterP[0]]
		},
		{
			OptionName -> LogTransformed,
			Default -> True,
			Description -> "Applied when input fitType is LogisticFourParam, True when the input x axis is log-transformed, False otherwise.",
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>BooleanP]
		},
		{
			OptionName -> StartingValues,
			Default -> {},
			Description -> "Initial guesses for parameter values.",
			AllowNull -> False,
			Widget -> Widget[Type->Expression, Pattern:>{(_Symbol -> _?NumericQ)...}, Size->Line]
		},
		{
			OptionName -> ErrorMethod,
			Default -> Parametric,
			Description -> "Method to use for determining best fit parameter errors and confidence/prediction bands.",
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:> (Parametric | Empirical)]
		},
		{
			OptionName -> NumberOfSamples,
			Default -> 1000,
			Description -> "Number of samples to use when using Empirical ErrorMethod.",
			AllowNull -> True,
			Widget -> Widget[Type->Number, Pattern:> GreaterEqualP[0,1]]
		},
		{
			OptionName -> FitField,
			Default -> Automatic,
			Description -> "The field in given objects containing the data points that will be fit to.",
			ResolutionDescription -> "If Automatic then picks a pre-speficied field based on the object type as describes in DefaultFitField.",
			AllowNull -> True,
			Widget -> Alternatives[
						Widget[Type->Expression, Pattern:> (_Symbol | {_Symbol..}), Size->Line],
						Widget[Type->Enumeration, Pattern:>Alternatives[Null,Automatic]]
					]
		},
		{
			OptionName -> ReferenceField,
			Default -> Null,
			Description -> "The reference field in given objects containing the data points that will be fit to.",
			ResolutionDescription -> "If Automatic then picks a pre-specified field based on the object type as describes in DefaultFitField.",
			AllowNull -> True,
			Widget -> Widget[Type->Expression, Pattern:> FieldP[First /@ DefaultFitField, Output -> Short],Size->Word]
		},
		{
			OptionName -> TransformationFunction,
			Default -> Automatic,
			Description -> "A function to apply the value pulled from FitField when the input data contains objects.",
			ResolutionDescription -> "Automatic picks a pre-specified function based on the object type.",
			AllowNull -> False,
			Widget -> Widget[Type->Expression, Pattern:> (_Function | _Symbol), Size->Line]
		},
		{
			OptionName -> Method,
			Default -> Automatic,
			Description -> "Method used for fitting.",
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Automatic, NMinimize, Gradient, Newton]]
		},
		{
			OptionName -> MaxIterations,
			Default -> None,
			Description -> "Maximum number of iterations that should be tried in various built-in functions and algorithms for NonLinearModelFit. None passes Automatic to NonLinearModelFit.",
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[None]],
				Widget[Type->Number, Pattern:> GreaterEqualP[0,1]]
			],
			Category -> "Hidden"
		},
		{
			OptionName -> AccuracyGoal,
			Default -> None,
			Description -> "Specifies how many effective digits of accuracy should be sought in the final result of NonLinearModelFit. None passes Automatic to NonLinearModelFit.",
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[None]],
				Widget[Type->Number, Pattern:> GreaterEqualP[0,1]]
			],
			Category -> "Hidden"
		},
		{
			OptionName -> PrecisionGoal,
			Default -> None,
			Description -> "Specifies how many effective digits of accuracy should be sought in the final result of NonLinearModelFit. None passes Automatic to NonLinearModelFit.",
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[Type->Enumeration, Pattern:>Alternatives[None]],
				Widget[Type->Number, Pattern:> GreaterEqualP[0,1]]
			],
			Category -> "Hidden"
		},
		{
			OptionName -> Scale,
			Default -> False,
			Description -> "Whether or not to scale the data to the unit box before fitting.",
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[True,False]]
		},
		{
			OptionName -> Name,
			Default -> Null,
			Description -> "Name to be used as the name of Object[Analysis, Fit] generated by the analysis.",
			AllowNull -> True,
			Category -> "General",
			Widget -> Widget[Type->Expression,Pattern:>_String, Size -> Line]
		},
		{
			OptionName -> FitNormalization,
			Default -> False,
			Description -> "Indicates whether to normalize the coefficient of the fit expression for the Exponential, Logistic, LogisticBase10, or GeneralizedLogistic fitting.",
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[True,False]]
		},
		{
			OptionName -> ZeroIntercept,
			Default -> False,
			Description -> "Indicates whether the y intercept of a linear fit should be forced to be zero. Has no effect if fit type is not Linear.",
			AllowNull -> False,
			Category -> "General",
			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[True,False]]
		},
		OutputOption,
		UploadOption,
		AnalysisTemplateOption

	}


];

AnalyzeFit::InvalidDomain="In the Domain option, the left boundary should be less than the right boundary.";
AnalyzeFit::DataSizeMismatch="Number of data points in each dimension must be equal.";
AnalyzeFit::FitFieldResolutionFailure="Failed to resolve the FitField for `1` objects.";
AnalyzeFit::InputDataSizeMismatch="Number of input dimensions in data must match number of inputs in pure function.";
AnalyzeFit::InvalidExpressionType="Expression type `1` cannot be fit to data with `2` independent variables.";
AnalyzeFit::InvalidFitField="Specified fit field `1` is not a field in `2`.";
AnalyzeFit::InvalidFunction="Pure function input is invalid.  Function must only contain symbolic parameters and must return a numeric value when evaluated.";
AnalyzeFit::InvalidPolynomialDegree="Specified polynomial degree is too high for given data set.";
AnalyzeFit::NonPositiveValues="Excluding non-positive values for log fitting.";
AnalyzeFit::NoUnknownParameter="There is no unknown parameter to fit in the given expression.";
AnalyzeFit::NoValidData="No remaining data points after filtering based on Domain, Range, and Exclude options.";
AnalyzeFit::OverFit="You are fitting a function with `1` parameters to `2` data points.  Generally speaking, this is not a good idea.  It means there are infinite number of fits that will interpolate your data points exactly.  One such solution will be returned.  Error prediction will not be available in this case.";
AnalyzeFit::TooManyOutliers="`1` points out of `2` total points have been flagged as outliers and excluded from fitting.  This is dangerously high.  Terminating recursive outlier exclusion loop after `3` iterations.";
AnalyzeFit::CannotFit="Unable to find a satisfactory solution.  Please try specifying parameter guesses using StartingValues or change your fit type.";
AnalyzeFit::ImaginaryFitParameters="Unable to find a real valued set of fit parameters.  Please try specifying parameter guesses using StartingValues or change your fit type.";
AnalyzeFit::MachinePrecisionIssue="The fit function `1` results in numbers that are either too large or too small. Please check your input values, try specifying parameter guesses using StartingValues, or change your fit type.";
AnalyzeFit::UnusedFitNormalization="FitNormalization will rescale the equation parameters only for Exponential, Logistic, LogisticBase10, and GeneralizedLogistic.";
AnalyzeFit::ZeroInterceptIgnored="The ZeroIntercept option can only be used with fit type Linear, but fit type `1` was provided. ZeroIntercept will be ignored.";

(* ::Subsubsection:: *)
(*AnalyzeFit*)

(*analyzeFitRawDataP = (MatrixP[NumericP]|MatrixP[UnitsP[]]|MatrixP[_?DistributionParameterQ]| MatrixP[UnitsP[]|_?DistributionParameterQ] | _?QuantityMatrixQ);*)
analyzeFitObjectInputP = Alternatives[
	{{(ObjectP[]|FieldReferenceP[]|UnitsP[])..}..},
	{(ObjectP[]|FieldReferenceP[]|{ObjectP[]..}|{FieldReferenceP[]..}|{UnitsP[]..})..}
];
analyzeFitDataP = Alternatives[DataPointsP, analyzeFitObjectInputP];

AnalyzeFit[xy:analyzeFitDataP,expr:_Symbol|_Function,ops:OptionsPattern[]]:=Module[
	{
		listedOptions, output, outputSpecification, gatherTests, safeOptions, safeOptionTests, standardFieldsStart, validLengths,validLengthTests,
		suppliedCache, downloadedPackets, cache, unresolvedOptions,templateTests, combinedOptions, exprResolved, resolvedInputsResult,
		resolvedOptionsResult, resolvedOptions,resolvedOptionsTests, optionsRule, previewRule, testsRule, resultRule,
		exprList,fitFields, xyResolved, inputUnit, outputUnit, firstOpsSet,xyStdDevs,safeOps,safeCombinedOptions,
		coordinates,stdDevs,expressions,resolvedOpsSets,dataFields
	},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[ops];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Check for temporal links in input *)
	checkTemporalLinks[xy,listedOptions];

	(* resolve standard start field *)
	standardFieldsStart = analysisPacketStandardFieldsStart[listedOptions];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests}=If[gatherTests,
		{SafeOptions[AnalyzeFit,listedOptions,AutoCorrect->False],{}},
		{SafeOptions[AnalyzeFit,listedOptions,AutoCorrect->False],Null}
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
		{ValidInputLengthsQ[AnalyzeFit,{xy,expr},listedOptions],{}},
		{ValidInputLengthsQ[AnalyzeFit,{xy,expr},listedOptions],Null}
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
		{ApplyTemplateOptions[AnalyzeFit,{xy,expr},listedOptions],{}},
		{ApplyTemplateOptions[AnalyzeFit,{xy,expr},listedOptions],Null}
	];

	combinedOptions=ReplaceRule[safeOptions,unresolvedOptions];

	(* resolve the inputs first before Options *)
	resolvedInputsResult = Check[
		{xyResolved, exprResolved, xyStdDevs, inputUnit, outputUnit, firstOpsSet, dataFields} = resolveAnalyzeFitInputs[{xy, expr}, combinedOptions],
		$Failed
	];

	(* Warning message if zeroIntercept was used with an invalid fit type *)
	If[!MatchQ[exprResolved,Linear]&&Lookup[combinedOptions,ZeroIntercept,False],
		Message[AnalyzeFit::ZeroInterceptIgnored,expr]
	];

	(* Call resolve<Function>Options *)
	(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating we can't actually return the standard result *)
	resolvedOptionsResult=Check[
		{resolvedOptions,resolvedOptionsTests}=If[gatherTests,
			resolveAnalyzeFitOptions[xyResolved,expr,inputUnit,outputUnit,firstOpsSet,combinedOptions,dataFields,Output->{Result,Tests}],
			{resolveAnalyzeFitOptions[xyResolved,expr,inputUnit,outputUnit,firstOpsSet,combinedOptions,dataFields],Null}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	If[MemberQ[{resolvedInputsResult, resolvedOptionsResult}, $Failed], Return[$Failed]];

	(* --- core computation to get the fit function --- *)
	fitFields = calculateFitFields[xyResolved, xyStdDevs, exprResolved, Append[resolvedOptions, Method->Automatic]];

	(* check for failed fitting or null output *)
	If[MatchQ[fitFields,$Failed|Null], Return[$Failed]];

	(* --- Generate rules for each possible Output value ---  *)

	(* Prepare the Options result if we were asked to do so *)
	optionsRule=Options->If[MemberQ[output,Options],
		RemoveHiddenOptions[AnalyzeFit,ReplaceRule[resolvedOptions, {Exclude->Lookup[fitFields,Exclude]}]],
		Null
	];

	cntForFitName = 0;
	(* Prepare the Preview result if we were asked to do so *)
	previewRule=Preview->If[MemberQ[output,Preview],
		With[{fitPckt = formatFitPacket[standardFieldsStart, resolvedOptions, fitFields, dataFields]},
			If[Cases[Flatten[DataPoints/.fitPckt], _DataDistribution]=!={},
				PlotFit[fitPckt, Output->Preview, Display->{DataError}],
				PlotFit[fitPckt, Output->Preview]
			]
		],
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
			With[{res = wrapFitUploadPacket[standardFieldsStart, resolvedOptions, fitFields, dataFields]},
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


(* ::Text:: *)
(*No model specified*)


AnalyzeFit[xy:analyzeFitDataP,ops:OptionsPattern[]]:=Module[{},

	AnalyzeFit[xy,Automatic,ops]

];


(*AnalyzeFit[xy:ListableP[analyzeFitDataP],ops:OptionsPattern[]]:=Module[{},

	AnalyzeFit[xy,Automatic,ops]

];*)


(* ::Subsection:: *)
(*Resolution*)


(* ::Subsubsection::Closed:: *)
(*resolveAnalyzeFitInputs*)


resolveAnalyzeFitInputs[{xyIn0_, expression0_}, safeOps_List]:= Module[
	{failExpr, xyIn,expression,firstOpsSet,sourceDataFields, xyMeansQ,xStdDevs,yStdDevs, dataUnits, xy, xyStdDevs,
	referenceField, referenceID, relationVal, dataFields, inputUnits, outputUnit},

	failExpr = Table[Null,7];

	(* pull data points from objects, if objects *)
	{xyIn,expression,firstOpsSet,sourceDataFields} = resolveAnalyzeFitInputsExpressionRef[xyIn0,expression0,safeOps];

	If[MatchQ[xyIn,Null],
		Return[failExpr]
	];

	(* turn distributions into means and standard deviations *)
	{xyMeansQ,xStdDevs,yStdDevs} = resolveDistributionInputs[xyIn];

	(* get base units and raw coordinates *)
	{dataUnits, xy} = unitsAndMagnitudes[xyMeansQ];


	(*
		this should probably be removed once all the source data links are finalized
	*)
	referenceField = Lookup[safeOps, ReferenceField];
	referenceID = With[{ref = Lookup[safeOps, Reference,Null]},
		If[MatchQ[ref,_List],
			ref,
			{ref}
		]
	];
	relationVal = formatFitRelation[referenceID, referenceField];

	(* these will go into the packet at the end *)
	dataFields = Join[
		{
			DataUnits -> dataUnits,
			DataPoints -> xyIn
		},
		{
			Reference -> DeleteCases[(relationVal),Null],
			ReferenceField -> refField[referenceField]
		},
		sourceDataFields
	];

	(* find input units, convert x errors to that, then strip off unit *)
	inputUnits = dataUnits[[1;;-2]];
	xStdDevs = Transpose[MapThread[unitlessErrorList,{Transpose[xStdDevs],inputUnits}]];

	(* find output unit, convert x errors to that, then strip off unit *)
	outputUnit = Last[dataUnits];
	yStdDevs = unitlessErrorList[yStdDevs,outputUnit];

	xyStdDevs = Flatten/@Transpose[{xStdDevs,yStdDevs}];

	{xy, expression, xyStdDevs, inputUnits, outputUnit, firstOpsSet, dataFields}

];


refField[referenceField:FieldReferenceP[]]:= Last[referenceField];
refField[referenceField_]:= referenceField;


(* ::Subsubsection::Closed:: *)
(*resolveAnalyzeFitOptions*)


DefineOptions[resolveAnalyzeFitOptions,
	Options:>{
		{Output->Result,ListableP[Result|Tests],"Indicates the return value of the function."}
	}
];


resolveAnalyzeFitOptions[xyMags_, expr_, inputUnit_, outputUnit_, firstOpsSet_, myOptions:{(_Rule|_RuleDelayed)..}, dataFields_, ops:OptionsPattern[]]:= Module[
	{output, listedOutput, collectTestsBoolean, messagesBoolean, domain, domainTestDescription, domainResolved, domainTest,
	range, rangeTestDescription, rangeResolved, rangeTest, exclude, excludeResolved, degree, degreeTestDescription, degreeTestExpr, degreeResolved, degreeTest,
	name, nameTestDescription, nameTest, resolvedOptions, collapsedOptions, allTests,methodResolved},

	(* From resolveAnalyzeFitOptions's options, get Output value *)
	output=OptionDefault[OptionValue[Output]];
	listedOutput=ToList[output];
	collectTestsBoolean=MemberQ[listedOutput,Tests];

	(* Print messages whenever we're not getting tests instead *)
	messagesBoolean=!collectTestsBoolean;

	(* if resolve input xy failed, cannot further resolve the following options *)
	If[MatchQ[xyMags, Null],
		Return[output/.{Tests->Null,Result->myOptions}];
	];

	(* --- Resolve Domain --- *)
	domain=Lookup[myOptions,Domain];
	domainTestDescription="The left boundary is greater than or equal to the right boundary in the specified domain:";
	domainResolved = Quiet[resolveN1DomainWithUnits[xyMags,inputUnit,domain]];
	domainTest = FitTestOrNull[Domain, collectTestsBoolean, domainTestDescription, MemberQ[domainResolved, _?(First[#]<=Last[#]&)]];


	(* --- Resolve Range --- *)
	range=Lookup[myOptions,Range];
	rangeTestDescription="The left boundary is greater than or equal to the right boundary in the specified Range:";
	rangeResolved = Quiet[resolveRangeWithUnits[xyMags,outputUnit,range]];
	rangeTest = FitTestOrNull[Range, collectTestsBoolean, rangeTestDescription, First[rangeResolved]<=Last[rangeResolved]];

	(* --- Resolve Exclude --- *)
	exclude=Lookup[myOptions,Exclude];
	excludeResolved = resolvedAnalyzeFitExcludeOption[exclude,xyMags,{inputUnit,outputUnit}];

	(* --- Resolve PolynomialDegree --- *)
	degree=Lookup[myOptions,PolynomialDegree];
	degreeTestDescription="Check if specified polygnomial degree is too high for given data set:";
	degreeTestExpr = degree<=Length[xyMags];
	{degreeResolved, degreeTest} = {degree, FitTestOrNull[PolynomialDegree, collectTestsBoolean, degreeTestDescription, degreeTestExpr]};

	(* --- Resolve Method --- *)

	method=Lookup[myOptions,Method];

	(* If automatic then set NMinimize for Exponential and Logistic - they tend to be more successful *)
	methodResolved=If[MatchQ[method,Automatic],
		Switch[expr,
			Exponential | Logistic | LogisticBase10 | GeneralizedLogistic,
			NMinimize,
			_,
			Automatic
		],
		method
	];

	(* --- Check if Name existed in DB --- *)
	name = Lookup[myOptions, Name];
	nameTestDescription="Check if the given Name already existed in the database:";
	nameTest = If[StringQ[name],
		FitTestOrNull[Name, collectTestsBoolean, nameTestDescription, Length[Search[Object[Analysis, Fit], Name=name]] == 0 ],
		FitTestOrNull[Name, collectTestsBoolean, nameTestDescription, True]
	];


	resolvedOptions = ReplaceRule[myOptions,
		{
			Domain -> domainResolved,
			Range -> rangeResolved,
			Exclude-> excludeResolved,
			PolynomialDegree->degreeResolved,
			FitField -> (FitField/.firstOpsSet),
			TransformationFunction -> (TransformationFunction/.firstOpsSet),
			ReferenceField -> (ReferenceField/.dataFields),
			StartingValues -> Switch[expr,
				LogisticFourParam, If[Lookup[myOptions, LogTransformed],
					{Bottom->Min[Last/@xyMags],Top->Max[Last/@xyMags],InflectionPoint->Mean[First/@xyMags]},
					{Bottom->Min[Last/@xyMags],Top->Max[Last/@xyMags],InflectionPoint->Log2@Mean[First/@xyMags]}
				],
				_, Lookup[myOptions, StartingValues]
			],
			Method->methodResolved
		}
	];


	allTests=Join[{domainTest},{rangeTest},{degreeTest},{nameTest}];

	output/.{Tests->allTests,Result->resolvedOptions}

];


FitTestOrNull[option_,makeTest:BooleanP,description_,expression_]:=If[makeTest,
	Test[description,expression,True],
	(* if tests are not requested to be returned, throw an error when fail *)
	If[expression,
		Null,
		(*Message[MessageName[AnalyzeFit,"Invalid"<>ToString[option]]];*)
		If[MatchQ[option, Domain], Message[AnalyzeFit::InvalidDomain]];
		If[MatchQ[option, PolynomialDegree], Message[AnalyzeFit::InvalidPolynomialDegree]];
		If[MatchQ[option, Name], Message[Error::DuplicateName, "AnalyzeFit object"]];
		Message[Error::InvalidOption,option]
	]
];


(* ::Subsubsection::Closed:: *)
(*resolveAnalyzeFitInputsExpressionRef*)


resolveAnalyzeFitInputsExpressionRef[xy:DataPointsP,expr_,opsList_]:=Module[{},
	{
		xy,
		analyzeFitObjectDefaultExpression[expr,Null],
		{
			Reference->{},
			FitField->Null,
			TransformationFunction -> transformationFunction[Lookup[opsList,TransformationFunction],Null]
		},
		{}
	}
];


resolveAnalyzeFitInputsExpressionRef[in0_,expr_,resolvedOps_]:=Module[{
		objs,ptsSets,fitFieldsFromOption,transformationFunctionsFromOption,inputsByDimension,numIndVars,
		fitFields,fitExpression,failedExpr={Null,Null,Null,Null},sourceLinksSets,sourceDataFields,sourceData
	},

	(* Rearrange input data into format { xpts, ypts, zpts, ... } *)
	inputsByDimension = rearrangePointsByDimension[in0];

	numIndVars = Length[inputsByDimension]-1;

	(* must have rectangular array of inputs *)
	If[MatchQ[inputsByDimension,Null], Return[failedExpr]];

	fitFieldsFromOption = PadRight[ToList[Lookup[resolvedOps,FitField]],Length[inputsByDimension],Automatic];
	transformationFunctionsFromOption = PadRight[ToList[Lookup[resolvedOps,TransformationFunction]],Length[inputsByDimension],Automatic];
	(* pull the data from the appropriate fields in the objects *)
	(* raw data comes out in form { xpts, ypts, zpts, ... } *)
	{ptsSets,fitFields,sourceLinksSets} = Transpose[
		MapThread[
			Function[{pts,field,transf,ind},resolveAnalyzeFitOneInputCoordinate[pts,field,transf,ind]],
			{inputsByDimension,fitFieldsFromOption,transformationFunctionsFromOption,Range[Length[inputsByDimension]]}
		]
	];

	(* make sure all dimensions resolved *)
	If[MemberQ[ptsSets,Null],Return[failedExpr]];
	(* make sure all fit fields resolved to correctly sized values *)
	If[!SameQ@@Map[Length,ptsSets],Message[AnalyzeFit::DataSizeMismatch]; Return[failedExpr]];

	(* list of objects for links *)
	objs = Cases[inputsByDimension,{obj:ObjectP[]:>Download[obj,Object],objf:FieldReferenceP[]:>Constellation`Private`fieldReferenceToObject[objf]},{2}];

	(* find expression from data type (if Automatic) *)
	fitExpression = analyzeFitObjectDefaultExpression[expr,objs];

	sourceData = DeleteCases[Flatten[sourceLinksSets,1],{Null,__}];

	(* format the links for the input objects *)
	sourceDataFields = {
		IndependentVariableData -> formatSourceDataLink[sourceData,1],
		SecondaryIndependentVariableData -> formatSourceDataLink[sourceData,If[numIndVars<2,Null,2]],
		TertiaryIndependentVariableData -> formatSourceDataLink[sourceData,If[numIndVars<3,Null,3]],
		DependentVariableData -> formatSourceDataLink[sourceData,numIndVars+1]
	};

	{
		QuantityArray[Transpose[ptsSets]],
		fitExpression,
		{
			Reference->objs,
			FitField->DeleteCases[fitFields,Null],
			TransformationFunction->transformationFunction[transformationFunctionsFromOption]
		},
		sourceDataFields
	}
];


formatSourceDataLink[sourceData_,dim_]:=Replace[Cases[sourceData,{obj_,field_,dim,tf_}:>{obj,field,tf}],{}->{{Null,Null,Null}}];



(* Inputs specified one point at a time *)
rearrangePointsByDimension[in:{{(ObjectP[]|FieldReferenceP[]|UnitsP[])..}..}]:=Transpose[in]; /; SameQ@@Map[Length,in];
(* Inputs specified one dimension at a time *)
rearrangePointsByDimension[in:{(ObjectP[]|FieldReferenceP[]|{ObjectP[]..}|{FieldReferenceP[]..}|{UnitsP[]..})..}]:=in;
(* else *)
rearrangePointsByDimension[in_]:=Message[AnalyzeFit::DataSizeMismatch];



resolvedInputFailExpr = {Null,Null,{Null,Null,Null}};

resolveAnalyzeFitOneInputCoordinate[objs:{ObjectP[]..},field0_,transf0_,ind_]:=Module[{fields},
	fields = Map[resolveAnalyzeFitFitField[field0,#[Type]]&,Download[objs,Object]];
	resolveAnalyzeFitOneInputCoordinate[objs,fields,transf0,ind]
];
resolveAnalyzeFitOneInputCoordinate[objfs:{FieldReferenceP[]..},field0_,transf0_,ind_]:=Module[{fields},
	fields = Map[resolveAnalyzeFitFitField[Constellation`Private`fieldReferenceToSymbol[#],Constellation`Private`fieldReferenceToObject[#][Type]]&,objfs];
	resolveAnalyzeFitOneInputCoordinate[Constellation`Private`fieldReferenceToObject/@objfs,Constellation`Private`fieldReferenceToSymbol/@objfs,transf0,ind]
];
resolveAnalyzeFitOneInputCoordinate[objs:{ObjectP[]..},fitFields_List,transf_,ind_]:=Module[
	{types,transfs,vals,unit,sourceDataLinks},
	If[MemberQ[fitFields,Null],Return[resolvedInputFailExpr]];
	types = Download[objs,Type];
	transfs = Map[transformationFunction[transf,#]&,types];
	vals = MapThread[Download[#1,#2]&,{Download[objs,Object],fitFields}];
	vals = MapThread[#1[#2]&,{transfs,vals}];
	sourceDataLinks = Thread[{Map[Link[#]&,Download[objs,Object]],fitFields,ind,transfs}];
	{vals,fitFields,sourceDataLinks}
];


resolveAnalyzeFitOneInputCoordinate[_,Null|{Null..},_,_]:=resolvedInputFailExpr;
resolveAnalyzeFitOneInputCoordinate[___]:=(
	Message[AnalyzeFit::DataSizeMismatch];
	resolvedInputFailExpr
);


resolveAnalyzeFitOneInputCoordinate[objf:FieldReferenceP[],field0_,transf0_,ind_]:=Module[{field},
	field = resolveAnalyzeFitFitField[Constellation`Private`fieldReferenceToSymbol[objf],Constellation`Private`fieldReferenceToObject[objf][Type]];
	resolveAnalyzeFitOneInputCoordinate[Constellation`Private`fieldReferenceToObject[objf],Constellation`Private`fieldReferenceToSymbol[objf],transf0,ind]
];
resolveAnalyzeFitOneInputCoordinate[obj:ObjectP[],fitField0_,transf0_,ind_]:=Module[
	{type,inf,transf,vals,unit,sourceDataLinks,fitField},
	type = obj[Type];
	fitField = resolveAnalyzeFitFitField[fitField0,type];
	If[MatchQ[fitField,Null],Return[resolvedInputFailExpr]];
	transf = transformationFunction[transf0,type];
	vals = Download[obj,fitField];
	vals = transf[vals];
	sourceDataLinks = {{Link[obj[Object]],fitField,ind,transf}};
	{vals,fitField,sourceDataLinks}
];

resolveAnalyzeFitOneInputCoordinate[pts:{UnitsP[]..},field0_,transf0_,ind_]:={pts,Null,{{Null,Null,Null,Null}}};


(* fix this to not strip units after Absorbance updated to handle QAs *)
transformationFunction[Automatic, Object[Data, AbsorbanceSpectroscopy]]=Function[{x},Absorbance[Unitless[x],OptionValue[AnalyzeTotalProteinQuantification,Wavelength]]];
transformationFunction[Automatic, Object[Data, FluorescenceIntensity]]=Function[{x},If[QuantityQ[x],x,First[x]]];
transformationFunction[Automatic, Object[Data, FluorescenceKinetics]]=Function[{x},
	Mean[
		If[MatchQ[x,{QuantityArrayP[]..}],First[x],x][[;;,2]]
	]
];
transformationFunction[Automatic,_]:=Identity;
transformationFunction[inList:{Automatic..}]:=ConstantArray[Identity,Length[inList]];
transformationFunction[f_,_]:=f;

resolveAnalyzeFitFitField[fitField:Except[_List],types_List]:=Map[resolveAnalyzeFitFitField[fitField,#]&,types];
resolveAnalyzeFitFitField[fitFields_List,types_List]:=MapThread[resolveAnalyzeFitFitField[#1,#2]&,{fitFields,types}];
resolveAnalyzeFitFitField[Automatic, obj:Alternatives@@(First/@DefaultFitField)]:=obj/.DefaultFitField;

resolveAnalyzeFitFitField[fitField_,type_]:=If[FieldQ[type[fitField]],
	fitField,
	(
		Message[AnalyzeFit::InvalidFitField,fitField,type];
		Message[Error::InvalidOption,FitField];
	(*	resolveAnalyzeFitFitField[Automatic,type]*)
		Null
	)
];
resolveAnalyzeFitFitField[Automatic,type_]:=(Message[AnalyzeFit::FitFieldResolutionFailure,type];Message[Error::InvalidOption,FitField]);

analyzeFitObjectDefaultExpression[expr:Automatic,obj:objectOrLinkP[]]:=analyzeFitObjectDefaultExpression[expr,obj[Type]];
analyzeFitObjectDefaultExpression[expr:Automatic,objs:{objectOrLinkP[]..}]:=analyzeFitObjectDefaultExpression[expr,objs[Type]];
analyzeFitObjectDefaultExpression[Automatic, Object[Analysis, Peaks]]=Linear;
analyzeFitObjectDefaultExpression[Automatic, Object[Data, AbsorbanceSpectroscopy]]=Linear;
analyzeFitObjectDefaultExpression[Automatic, Object[Data, qPCR]]=LinearLog;
analyzeFitObjectDefaultExpression[Automatic, Object[Analysis, QuantificationCycle]]=LinearLog;
analyzeFitObjectDefaultExpression[Automatic, Object[Data, FluorescenceIntensity]]=Linear;
analyzeFitObjectDefaultExpression[Automatic,_]:=Linear;
analyzeFitObjectDefaultExpression[fitExpression_,_]:=fitExpression;

analyzeFitObjectFieldUnit[type_,fitField_]:= With[{allUnits=Lookup[LegacySLL`Private`typeUnits[type],fitField,Null]},
	Switch[allUnits,
		UnitsP[], allUnits,
		{UnitsP[],UnitsP[]}, Last[allUnits],
		Null, 1,
		_, Message[]
	]
];


(* ::Subsubsection::Closed:: *)
(*resolveRangeWithUnits*)


resolveRangeWithUnits[xy_,yUnit_,range:{_?NumericQ,_?NumericQ}]:=range;

resolveRangeWithUnits[xy_,yUnit_,range:{left_Quantity,right_}]:=resolveRangeWithUnits[xy,yUnit,{Unitless[left,yUnit],right}];
resolveRangeWithUnits[xy_,yUnit_,range:{left_,right_Quantity}]:=resolveRangeWithUnits[xy,yUnit,{left,Unitless[right,yUnit]}];

resolveRangeWithUnits[xy_,yUnit_,range:{left:(All|Automatic),right_}]:=resolveRangeWithUnits[xy,yUnit,{Min[xy[[;;,-1]]],right}];
resolveRangeWithUnits[xy_,yUnit_,range:{left_,right:(All|Automatic)}]:=resolveRangeWithUnits[xy,yUnit,{left,Max[xy[[;;,-1]]]}];

resolveRangeWithUnits[xy_,yUnit_,range:(All|Automatic)]:=resolveRangeWithUnits[xy,yUnit,{All,All}];


(* ::Subsubsection::Closed:: *)
(*resolveDomainWithUnits*)


resolveDomainWithUnits[xy_,xUnit_,domain:{_?NumericQ,_?NumericQ}]:=domain;

resolveDomainWithUnits[xy_,xUnit_,domain:{left_Quantity,right_}]:=resolveDomainWithUnits[xy,xUnit,{Unitless[left,xUnit],right}];
resolveDomainWithUnits[xy_,xUnit_,domain:{left_,right_Quantity}]:=resolveDomainWithUnits[xy,xUnit,{left,Unitless[right,xUnit]}];

resolveDomainWithUnits[xy_,xUnit_,domain:{left:(All|Automatic),right_}]:=resolveDomainWithUnits[xy,xUnit,{Min[xy[[;;,1]]],right}];
resolveDomainWithUnits[xy_,xUnit_,domain:{left_,right:(All|Automatic)}]:=resolveDomainWithUnits[xy,xUnit,{left,Max[xy[[;;,1]]]}];

resolveDomainWithUnits[xy_,xUnit_,domain:(All|Automatic)]:=resolveDomainWithUnits[xy,xUnit,{All,All}];


(* ::Subsubsection::Closed:: *)
(*resolveN1DomainWithUnits*)


resolveN1DomainWithUnits[xy_,xUnits_,domain:{_?NumericQ,_?NumericQ}]:=Table[domain,{Length[xUnits]}];
resolveN1DomainWithUnits[xy_,xUnits_,domain:{{_?NumericQ,_?NumericQ}..}]:=domain;
resolveN1DomainWithUnits[xy_,xUnits:{UnitsP[]},domain_]:={resolveDomainWithUnits[xy,First[xUnits],domain]}; (* call 1D resolution *)
resolveN1DomainWithUnits[xy_,xUnits_,domain:(All|Automatic)]:=Transpose[{Min/@Transpose[xy[[;;,1;;-2]]],Max/@Transpose[xy[[;;,1;;-2]]]}];


(* ::Subsection::Closed:: *)
(*fitting core*)


(* ::Subsubsection::Closed:: *)
(*calculateFitFields*)


calculateFitFields[xy0_, xyStdDevs0_, expression_, Null] := Null;
(* core fitting function for single list of data and single expression  *)
calculateFitFields[xy0_, xyStdDevs0_, expression_, resolvedOps_]:=Module[{fitInfo,xy,excludeOutliers,referenceID,range,
	sig,fcn,dy,outies={},newouties={},count=0,outies0,excludedPoints,allPoints,fitFunctionPacket,domain,n0,badPoints={},
	bfpr,expr,bfv,hd,dm,bfp,excludeInds,xyStdDevs,filtered,inputDim, cm,mbfd},


	inputDim=Length[First[xy0]]-1;
	domain = Lookup[resolvedOps, Domain];
	range = Lookup[resolvedOps,Range];
	excludeOutliers = Replace[Lookup[resolvedOps, ExcludeOutliers],{True->1,False->0,Repeatedly->3}];

	(* Exclude points which fall outside of the domain and range, or are specified in the Exclude option *)
	filtered = Complement[
		Select[Transpose[{xy0,xyStdDevs0}], And@@Map[Function[ind,domain[[ind,1]]<=#[[1,ind]]<=domain[[ind,2]]],Range[Length[domain]]] && First[range]<=#[[1,-1]]<=Last[range]&],
		Lookup[resolvedOps, Exclude],
		SameTest->(SameQ[#1[[1]],#2]&)
	];

	If[MatchQ[filtered,{}],
		Message[AnalyzeFit::NoValidData];Return[Null];,
		{xy,xyStdDevs} = Transpose[filtered];
	];

	outies = Complement[xy0, xy];
	outies0 = outies;
	If[MatchQ[expression,Log|LogLinear|LogPolynomial],
		badPoints=Join[badPoints,Select[xy,Min[#[[1;;inputDim]]]<=0&]];
		If[badPoints=!={},
			(
				outies0=Join[outies0,badPoints];
				filtered=Complement[Transpose[{xy,xyStdDevs}],badPoints,SameTest->(SameQ[#1[[1]],#2]&)];
				If[MatchQ[filtered,{}],
					Message[AnalyzeFit::NoValidData];Return[Null];,
					{xy,xyStdDevs} = Transpose[filtered];
				]
			)
		]
	];

	If[MatchQ[expression,LinearLog|Log],
		badPoints=Join[badPoints,Select[xy,#[[-1]]<=0&]];
		If[badPoints=!={},
			(
				outies0=Join[outies0,badPoints];
				filtered=Complement[Transpose[{xy,xyStdDevs}],badPoints,SameTest->(SameQ[#1[[1]],#2]&)];
				If[MatchQ[filtered,{}],
					Message[AnalyzeFit::NoValidData];Return[Null];,
					{xy,xyStdDevs} = Transpose[filtered];
				]
			)
		]
	];

	If[!MatchQ[badPoints,{}],
		Message[AnalyzeFit::NonPositiveValues];
	];

	n0=Length[xy];

	While[True,
		count++;

		(* fit current set of valid data points *)
		fitFunctionPacket=fitFunction[xy,xyStdDevs,expression,resolvedOps];

		(* If[MatchQ[fitFunctionPacket,Null], Return[Null]]; *)
		If[MatchQ[fitFunctionPacket,Null|$Failed], Return[fitFunctionPacket]];
		fcn=BestFitFunction/.fitFunctionPacket;
		If[fcn===Null,Return[{_->Null}]];

		(* error of fit *)
		(* checking if the function values result in very large values *)
		dy=
			Quiet[
				Check[
					xy[[;;,2]]-(fcn@@@xy[[;;,1;;-2]]),
					(
						(* precision issue found when using the fitted model *)
						Message[AnalyzeFit::MachinePrecisionIssue,fcn];
						$Failed
					),
					(* we are checking the following messages from mathematica *)
					{General::munfl}
				],
				(* quiet the messages *)
				{General::munfl}
			];

		If[dy === $Failed,Return[$Failed]];

		sig=If[Length[dy]<2,Null,StandardDeviation[dy]];
		(* find outliers from current fit *)
		{bfpr, expr, bfv, cm} = Lookup[fitFunctionPacket, {BestFitParameterRules, SymbolicExpression, BestFitVariables,CovarianceMatrix}];
		dm = designMatrix[Grad[expr,bfpr[[;;,1]]]/.bfpr,bfv,xy];
		(*		hd = hatDiagonal[dm];*)
		hd = Quiet[Check[Lookup[fitFunctionPacket,FittedModel]["HatDiagonal"],Null]];
		newouties=xy[[outlierPositions[dy, {HatDiagonal -> hd, OutlierDistance -> Lookup[resolvedOps, OutlierDistance], Method -> IQR}]]];

		(* if too many outliers, quit with warning *)
		If[(Length[outies]-Length[outies0])>0.5*n0,Message[AnalyzeFit::TooManyOutliers,Length[outies],n0,count];Break[]];

		If[excludeOutliers<count,Break[]];

		outies=Join[outies,newouties];

		(* get new data set excluding those outliers *)
		(*xy=Complement[xy0,outies];*)
		{xy,xyStdDevs}=Transpose[Complement[Transpose[{xy0,xyStdDevs0}],outies,SameTest->(SameQ[#1[[1]],#2]&)]];

		(* if no new outliers, then done.*)
		If[newouties==={},Break[]];
	];

	If[MatchQ[fitFunctionPacket,Null], Return[Null]];

	(* simplify the expression *)
	fcn=Evaluate[(Simplify[fcn@@Map[Slot,Range[Length[bfv]]]])]&;

	(* format Log terms if present *)
	fcn=formatLogFunction[fcn,Lookup[resolvedOps, LogBase],expression,inputDim];

	excludedPoints = DeleteDuplicates[Join[badPoints,Complement[outies,newouties]]];

	Module[{bfe,response,fitResponse,fitResiduals,n,k,fitStats,bfpd},
		bfe = Lookup[fitFunctionPacket,BestFitExpression];
		n=Length[xy];
		k=Length[bfpr];
		response = xy[[;;,-1]];
		fitResponse = fcn@@@xy[[;;,1;;-2]];
		fitResiduals = (response-fitResponse);
		fitStats = Quiet[
			fitStatistics[expr,fcn,bfv,bfpr,xy,response,fitResponse,n,k,Lookup[resolvedOps,ErrorMethod],dm,cm],
			{Power::infy,Infinity::indet}
		];

		bfp = Transpose[{
			bfpr[[;;,1]],
			bfpr[[;;,2]],
			Replace[Lookup[fitStats,ParameterErrors],Null->Table[Null,{k}]]
		}];

		bfpd = fitParameterDistributions[Lookup[resolvedOps,ErrorMethod],xy,expr,bfpr,bfv,Lookup[fitStats,CovarianceMatrix],Lookup[resolvedOps,NumberOfSamples]];

		(* marginal best fit parameter distributions *)
		mbfd = If[MatchQ[bfpd,Except[Null]],
			Transpose[{
				bfpr[[;;,1]],
				Map[MarginalDistribution[bfpd,#]&,Range[Length[bfp]]]
			}],
			Null
		];

		Join[
			{
				BestFitFunction->fcn,
				BestFitExpression->bfe,
				SymbolicExpression -> expr,
				BestFitParameters->bfp,
				BestFitParametersDistribution->bfpd,
				MarginalBestFitDistribution->mbfd,
				BestFitVariables->bfv,
				ExpressionType -> Lookup[fitFunctionPacket,ExpressionType],
				BestFitResiduals->fitResiduals,
				Response->response,
				PredictedResponse->fitResponse,
				ANOVATable -> Lookup[fitFunctionPacket,ANOVATable],
				Replace[ANOVAOfModel] -> Lookup[fitFunctionPacket,Replace[ANOVAOfModel]],
				Replace[ANOVAOfError] -> Lookup[fitFunctionPacket,Replace[ANOVAOfError]],
				Replace[ANOVAOfTotal] -> Lookup[fitFunctionPacket,Replace[ANOVAOfTotal]],
				FStatistic -> Lookup[fitFunctionPacket,FStatistic],
				FCritical -> Lookup[fitFunctionPacket,FCritical],
				FTestPValue -> Lookup[fitFunctionPacket,FTestPValue]
			},
			FilterRules[fitStats,Keys[Object[Analysis, Fit]]],
			{
				HatDiagonal->hd
			},
			{
				Exclude->excludedPoints,
				Outliers->newouties,
				MinDomain -> First[Transpose[domain]],
				MaxDomain -> Last[Transpose[domain]]
			}
		]
	]
];

formatLogFunction[fcn_,base:Except[E],Log|LogLinear|LinearLog|LogLog,1]:=Evaluate[(Simplify[fcn[Slot[1]]])/.{Log[Slot[1]]->(Log[base]*Log[Slot[1]])}]&/.{Log[Slot[1]]:>Log[base,Slot[1]]};
formatLogFunction[fcn_,base_,_,_]:=fcn;


(* ::Subsubsection::Closed:: *)
(*fit statistics*)


(*
	y - training data (response)
	yhat - prediction from fitted function (fitResponse)
	n - # of training points
	k - # of parameters in fit
*)
fitStatistics[expr_,f_,vars_,parRules_,xy_,y_,yhat_,n_,k_,errorMethod_,dm_,cmTheirs_]:=Module[
	{df,ess,tss,rss,cm, hd, sig,estv,pars,grad,mpeF,speF,tVal,
		mpdF, spdF, pe},

	df=n-k;
	pars=parRules[[;;,1]];
	rss = RSS[y,yhat];
	tss = TSS[y];
	estv = ESTV[rss,n,k];
	sig = If[MatchQ[estv,Null],Null,Sqrt[estv]];
	grad = Grad[expr,pars]/.parRules;
	(*	dm = designMatrix[grad,vars,xy];*)
	cm = covarianceMatrix[dm,sig];
	pe = parameterErrors[cm];
	(*	hd = hatDiagonal[dm];*)
	mpeF = meanPredictionError[grad,cm,vars];
	speF = singlePredictionError[mpeF,vars,sig];
	mpdF = predictionDistribution[f,mpeF,vars];
	spdF = predictionDistribution[f,speF,vars];
	tVal = Quiet[StudentTCI[0,1,df],{StudentTDistribution::posprm}];


	{
		RSquared -> RSQ[rss,tss],
		AdjustedRSquared -> ARSQ[rss,tss,n,k],
		BIC -> bic[rss,n,k],
		AIC -> aic[rss,n,k],
		AICc -> aicc[rss,n,k],
		EstimatedVariance -> estv,
		StandardDeviation -> If[MatchQ[estv,Null],Null,Sqrt[estv]],
		SumSquaredError -> rss,
		(*		DesignMatrix -> dm,*)
		CovarianceMatrix -> cm,
		ParameterErrors -> pe,
		(*		HatDiagonal -> hd,*)
		MeanPredictionError -> mpeF,
		SinglePredictionError -> speF,
		MeanPredictionInterval -> meanPredictionInterval[f,mpeF,vars,tVal],
		SinglePredictionInterval -> singlePredictionInterval[f,speF,vars,tVal],
		MeanPredictionDistribution -> mpdF,
		SinglePredictionDistribution -> spdF
	}
];

RSS[y_,yhat_]:=Total[(y-yhat)^2];
TSS[y_]:=Total[(y-Mean[y])^2];
ESS[y_,yhat_]:=Total[(yhat-Mean[y])^2];

RSQ[0|0.,tss_]:=1.;
RSQ[0|0.,0|0.]:=1.;
RSQ[rss_,0|0.]:=0.;
RSQ[rss_,tss_]:=1-rss/tss;

ARSQ[0|0.,_,n_,k_]:=1.;
ARSQ[_,0|0.,n_,k_]:=0.;
ARSQ[rss_,tss_,n_,k_]:=Null /; n<=k;
ARSQ[rss_,tss_,n_,k_]:=1. - (rss/(n-k)) / (tss/(n-1));

aic[0|0.,n_,k_]:=0.;
aic[rss_,n_,k_]:=n*Log[rss/n]+2*(k+1) + n*Log[2*Pi] + n;

aicc[0|0.,n_,k_]:=0.;
aicc[rss_,n_,k_]:=0./;(n-k-2<=0);
aicc[rss_,n_,k_]:= aic[rss,n,k] + (2*(k+1)*(k+2))/(n-k-2);

bic[0|0.,n_,k_]:=0.;
bic[rss_,n_,k_]:=n*Log[rss/n]+(k+1)*Log[n]+n*Log[2*Pi]+n;

(* EstimatedVariance *)
ESTV[0|0.,n_,k_]:=0.;
ESTV[rss_,n_,k_]:=Null /; n<=k;  (* case where more parameters than sampling points *)
ESTV[rss_,n_,k_]:=rss/(n-k);

designMatrix[grad_,vars_,xy_]:=Table[grad/.Thread[vars->xone],{xone,xy[[;;,1;;-2]]}];
(*covarianceMatrix[designMatrix_,sig_]:=sig^2 * Inverse[Transpose[designMatrix].designMatrix];*) (* numerically unstable *)
(* add a piece to force SPD-ness *)
covarianceMatrix[designMatrix_,sig:(Null)]:=Null;
covarianceMatrix[designMatrix_,sig:(0|0.)]:= 10.^-15 * IdentityMatrix[Length[designMatrix[[1]]]]; (* teeny tiny matrix *)
covarianceMatrix[designMatrix_,sig_]:= Module[{cm},
	Quiet[
		Check[
			cm=LinearSolve[Transpose[designMatrix].designMatrix,sig^2*N@IdentityMatrix[Dimensions[designMatrix][[2]]]],
			Return[Null],
			{LinearSolve::nosol}
		],
		{LinearSolve::nosol,LinearSolve::luc,LinearSolve::sing1}
	];

	(* To make the covariance matrix symmetric *)
	If[!SymmetricMatrixQ[cm], cm=(cm+Transpose[cm])/2];
	If[!PositiveDefiniteMatrixQ[cm], cm=NearestCorrelationMatrix[cm]];

	(* The precision is set 16 in Mathematica but the accuracy of small number becomes larger than 16 *)
	(* This causes some incorrect digits for {i,j} and {j,i} elements and produces non-symmetric cm *)
	(* Round[cm,0.000000000001] *)
	cm
];

hatDiagonal[designMatrix_] := Diagonal[designMatrix.PseudoInverse[designMatrix]];

meanPredictionError[grad_,Null,vars_]:=Null;
meanPredictionError[grad_,cov_,vars_]:= With[{mpe=Sqrt[grad.cov.grad]},Function[Evaluate[vars],mpe]];

singlePredictionError[Null,vars_,sig_]:=Null;
singlePredictionError[mpeF_Function,vars_,sig_]:= With[
		{thing=Sqrt[sig^2 + (mpeF@@vars)^2 ] },
		Function[Evaluate[vars],thing]
	];

meanPredictionInterval[_,Null,___]:=Null;
meanPredictionInterval[f_Function,mpeF_Function,vars_,tVal_]:= With[
		{thing=Evaluate[(f@@vars)+(mpeF@@vars)*tVal] },
	(* need these Evaluates around vars, otherwise replicates the vars with $ and they are wrong *)
		Function[Evaluate[vars],thing]
	];

singlePredictionInterval[_,Null,___]:=Null;
singlePredictionInterval[f_Function,speF_Function,vars_,tVal_]:= With[
		{thing=Evaluate[(f@@vars)+(speF@@vars)*tVal] },
		Function[Evaluate[vars],thing]
	];

predictionDistribution[f_,Null,vars_]:=Null;
predictionDistribution[f_,mpeF_,vars_]:= With[
	{m=f@@vars,s=mpeF@@vars},
	Function[Evaluate[vars],NormalDistribution[m,s]]
];

parameterErrors[cm:Null]:=Null;
parameterErrors[cm_]:=Sqrt[Diagonal[cm]];



(* ::Subsubsection::Closed:: *)
(*fitFunction*)


fitFunction[xy_,xyStdDevs_,type:(_Symbol|_Function), resolvedOps_]:=Module[
	{xyTrans,scale,shift,fitResult,fitFunc,stddev,pars,fitInfo,normFunc,fitExpr,symbExpr,fittedModel,inputDims,
	xTrans,yTrans,xScale,xShift,yScale,yShift,verbose=False,xvars, weights,varianceEstimatorFunction, anovaFields,
	maxIterations,accuracyGoal,precisionGoal,fitExpressionResult},

	inputDims = Length[xy[[1]]]-1;
	xvars = Switch[inputDims,
		1, {x},
		_, Table[Symbol["x"<>ToString[ix]],{ix,1,inputDims}]
	];

	(* If Exponential and fit normalization requested we are going to find an equation for rescaled x and y *)
	fitExpressionResult=Which[
		MatchQ[type,Exponential|Logistic|LogisticBase10|GeneralizedLogistic] && Lookup[resolvedOps,FitNormalization],
		fitExpressionLookup[type, xy, xvars, resolvedOps],

		(* If not any of the exponential based function, fit normalization is not expected to help *)
		Lookup[resolvedOps,FitNormalization],
		Message[AnalyzeFit::UnusedFitNormalization];
		fitExpressionLookup[type, xvars, resolvedOps],

		True,
		fitExpressionLookup[type, xvars, resolvedOps]
	];

	fitInfo=ReplaceRule[{Expression->Null,Parameters->Null,Box->({{-1,1},{-1,1}}&)}, fitExpressionResult,Append->False];

	If[MatchQ[Lookup[fitInfo,Expression],Null],Return[Null]];
	If[MatchQ[Lookup[fitInfo, Parameters], Function[{}]], Message[AnalyzeFit::NoUnknownParameter]; Return[Null]];

	normFunc=Lookup[resolvedOps, Objective]/.{L1->(Norm[#,1]&),L2->(Norm[#,2]&),LInfinity->(Norm[#,Infinity]&)};
	(* return Null if bad input *)
	If[!MatchQ[Expression/.fitInfo,_Function],Return[Null]];

	If[TrueQ[Lookup[resolvedOps,Scale]],
		(* we will fit to yy = ff[xx]], where xx=g[x], and yy=h[y] *)
		{xTrans,xScale,xShift}=transformDataNew[xy[[;;,1]],N@First[(Box/.fitInfo)[xy]]];
		If[verbose,Print[xTrans]];
		{yTrans,yScale,yShift}=transformDataNew[xy[[;;,2]],N@Last[(Box/.fitInfo)[xy]]];
		If[verbose,Print[yTrans]];
		xyTrans=Transpose[{xTrans,yTrans}];,
		(* else *)
		xyTrans = xy;
	];

	pars = (Parameters/.fitInfo)[xyTrans];
	If[Length[pars]>Length[xy],Message[AnalyzeFit::OverFit,Length[pars],Length[xy]]];

	(* MaxIterations to be used for NonLinearModelFit *)
	maxIterations=Switch[Lookup[resolvedOps,MaxIterations],
		None,
		Automatic,
		_,
		Lookup[resolvedOps,MaxIterations]
	];

	(* AccuracyGoal to be used for NonLinearModelFit *)
	accuracyGoal=Switch[Lookup[resolvedOps,AccuracyGoal],
		None,
		Automatic,
		_,
		Lookup[resolvedOps,AccuracyGoal]
	];

	(* PrecisionGoal to be used for NonLinearModelFit *)
	precisionGoal=Switch[Lookup[resolvedOps,PrecisionGoal],
		None,
		Automatic,
		_,
		Lookup[resolvedOps,PrecisionGoal]
	];

(*	{weights,varianceEstimatorFunction} = Which[
		MatchQ[Transpose[xyStdDevs],{{Null..}..}],
			{Automatic,Automatic},
		MemberQ[Flatten[xyStdDevs],0|0.],
			{Automatic,Automatic},
		True,
			{ 1/Total[Transpose[Replace[xyStdDevs,Null->0,{2}]]^2], (1&)}
	];*)

	fittedModel =
		Quiet[
			Check[
				Check[
					NonlinearModelFit[xyTrans,(Expression/.fitInfo)@@xvars,pars,xvars,
						Weights -> Automatic,VarianceEstimatorFunction->Automatic,Method->Lookup[resolvedOps, Method],
						MaxIterations->maxIterations,AccuracyGoal->accuracyGoal,PrecisionGoal->precisionGoal
					],
					(
						(* a proper fit has not been found *)
						Message[AnalyzeFit::CannotFit];
						$Failed
					),
					(* messages from NonLinearModelFit that we are checking for *)
					{NonlinearModelFit::fitm,FindFit::fitm,NonlinearModelFit::nrlnum(*,NonlinearModelFit::cvmit*)}
				],
				(
					Message[AnalyzeFit::MachinePrecisionIssue,(Expression/.fitInfo)@@xvars];
					$Failed
				),
				(* Catch messages that indicate there was numerica overflow or underflow *)
				{NonlinearModelFit::nrjnum,General::ovfl,General::munfl}
			],
			(* quiet these messages *)
			{NonlinearModelFit::fitm,FindFit::fitm,NonlinearModelFit::nrlnum,NonlinearModelFit::nrjnum,General::ovfl,General::munfl(*,NonlinearModelFit::cvmit*)}
	];

	(* checking if a good fit was not obtained *)
	If[fittedModel === $Failed, Return[$Failed]];

	fitResult=Quiet[fittedModel["BestFitParameters"]];

	(* checking if we get complex variables for the fit *)
	If[
		!AllTrue[fitResult,Internal`RealValuedNumericQ[Last[#]] &],
		Message[AnalyzeFit::ImaginaryFitParameters];
		Return[$Failed]
	];

	(* compute ANOVA analysis *)
	anovaFields = Quiet[anovaStats[fittedModel, inputDims]];

	symbExpr = (Expression/.fitInfo)@@xvars;
	If[TrueQ[Lookup[resolvedOps,Scale]],
		symbExpr = transformExpressionX[symbExpr,xvars,xScale,xShift];
		symbExpr = transformExpressionY[symbExpr,yScale,yShift];
	];
	fitExpr = symbExpr/.fitResult;
	fitFunc = Function[Evaluate[xvars],Evaluate[fitExpr]];

	Join[
		{
			BestFitFunction->fitFunc,
			BestFitExpression->fitExpr,
			SymbolicExpression->symbExpr,
			BestFitParameterRules->fitResult,
			BestFitVariables->xvars,
			ExpressionType->Replace[type,_Function->Other],
			FittedModel -> fittedModel,
			CovarianceMatrix -> Quiet[fittedModel["CovarianceMatrix"]]
		},
		fitInfo,
		anovaFields
	]

];

anovaStats[fittedModel_, inputDims_]:= Module[
	{modelDF, modelSS, modelMS, DF, SS, MS, errorDF, errorSS, errorMS, anovaTable, FStats, FCritical95, FPValue},

	Needs["HypothesisTesting`"];

	(* since NonLinearModelFit was used, need to correct for the first row in ANOVA table generated *)
	modelDF = inputDims;
	modelSS = Total[#^2&/@(fittedModel["PredictedResponse"] - Mean[fittedModel["Response"]])];
	modelMS = modelSS/modelDF;

	errorDF = Length[fittedModel["Response"]] - 2;
	errorSS = Total[#^2&/@((fittedModel["PredictedResponse"])- (fittedModel["Response"]))];
	errorMS = errorSS/errorDF;

	(* return Null if ANOVA cannot be computed *)
	If[errorDF<=0, Return[{ANOVATable->PlotTable[{{"The number of data points is insufficient to compute the ANOVA analysis table."}}], Replace[ANOVAOfModel]->Null, Replace[ANOVAOfError]->Null, Replace[ANOVAOfTotal]->Null, FStatistic->Null, FCritical->Null, FTestPValue->Null}]];

	DF = {modelDF, errorDF, errorDF+1};
	SS = {modelSS, errorSS, modelSS+errorSS};
	MS = {modelMS, errorMS};
	FStats = If[MS[[2]]===0., Null, MS[[1]]/MS[[2]]];
	FCritical95 = Quantile[FRatioDistribution[modelDF, DF[[2]]], 0.95];
	FPValue = If[FStats===Null, Null, OneSidedPValue/.FRatioPValue[FStats, modelDF, DF[[2]]]];


	anovaTable = Flatten[{DF, roundSciForm[SS], roundSciForm[MS], roundSciForm[{FStats}], roundSciForm[{FCritical95}], roundSciForm[{FPValue}]}, {2}];

	{
		ANOVATable -> PlotTable[{{"Source of Variation","DF","Sum of Squares","Mean Squares","F-Statistic","F-Critical (95%)","P-Value"}, Prepend[InputForm/@anovaTable[[1]], "Model"], Prepend[InputForm/@anovaTable[[2]], "Error"], Prepend[InputForm/@anovaTable[[3]], "Total"]}, Alignment->Center],
		Replace[ANOVAOfModel] -> anovaTable[[1]],
		Replace[ANOVAOfError] -> anovaTable[[2]],
		Replace[ANOVAOfTotal] -> anovaTable[[3]],
		FStatistic -> FStats,
		FCritical -> FCritical95,
		FTestPValue -> FPValue
	}


];


roundSciForm[num:{0.`..}]:= num;
roundSciForm[num:Null]:= Null;
roundSciForm[num:{Null..}]:= num;
roundSciForm[num:{__}]:=roundSciForm/@num;
roundSciForm[num:0|0.`]:=0.`;
roundSciForm[num_]:= N[Round[num, 10^(Floor[Log10[num]]-5)]];


(* ::Subsubsection::Closed:: *)
(*fitParameterDistributions*)


fitParameterDistributions[_,xy_,expr_,parRules_,vars_,cm:Null,numSamps_]:=Null;


fitParameterDistributions[Parametric,xy_,expr_,parRules_,vars_,cm_,numSamps_]:=Module[{ps,pMeans,pStdDevs},
	{ps,pMeans} = Transpose[List@@@parRules];
	MultinormalDistribution[parRules[[;;,2]],cm]
];




fitParameterDistributions[Empirical,xy_,expr_,parRules_,vars_,cm_,numSamps_]:=Module[{ps,pMeans,psets},
	{ps,pMeans} = Transpose[List@@@parRules];
	psets = bootstrapSet[findBestParameters[#,expr,Transpose[{ps,pMeans}],vars]&,xy,NumberOfSamples->numSamps];
	EmpiricalDistribution[psets]
];

findBestParameters[xy_,expr_,pars_,vars_]:=NonlinearModelFit[xy,expr,pars,vars]["BestFitParameters"][[;;,2]];


(* ::Subsubsection::Closed:: *)
(*fitExpressionLookup*)


fitExpressionLookup[Linear,xvars_, resolvedOps_]:=If[Lookup[resolvedOps,ZeroIntercept,False],
	Module[{a=Unique["a"]},
		{
			Expression->(a*#&),
			Parameters->({{a,0}}&),
			Box->({{-1,1},{-1,1}}&)
		}
	],
	fitExpressionLookup[Polynomial, xvars, ReplaceRule[resolvedOps, PolynomialDegree->1]]
];

fitExpressionLookup[Cubic,xvars_, resolvedOps_]:=
	fitExpressionLookup[Polynomial,xvars, ReplaceRule[resolvedOps, PolynomialDegree->3]];

fitExpressionLookup[Polynomial,xvars:{_Symbol},resolvedOps_]:=With[{pars=Table[Unique["p"],{Lookup[resolvedOps, PolynomialDegree]+1}]},{
	Expression->(Evaluate[pars.(#^Range[0,Lookup[resolvedOps, PolynomialDegree]])]&),
	Parameters->(Evaluate[pars]&),
	Box->({{-1,1},{-1,1}}&)
}];

fitExpressionLookup[Polynomial,xvars_,resolvedOps_]:=With[
	{basis = polynomialBasis[xvars,Lookup[resolvedOps, PolynomialDegree]]},
	With[
		{pars=Table[Unique["p"],{ix,1,Length[basis]}]},
		{
			Expression->(Evaluate[pars.basis]&),
			Parameters->(Evaluate[pars]&),
			Box->(Null&)
		}
	]
];

polynomialBasis[vars_List,degree_Integer]:=DeleteDuplicates[Flatten[Table[TensorProduct@@Table[vars,{m}],{m,0,degree}]]];

(* Exponential fit expression if the fit normalization is true will rescale the expression *)
fitExpressionLookup[Exponential,xy_,xvars:{_Symbol},resolvedOps_]:=Module[
	{a=Unique["a"],b=Unique["b"],c=Unique["c"],
	xmin,xmax,ymin,ymax,equation,normalizedEquation},

	(* Finding the min and max of the xy data *)
	{xmin,xmax,ymin,ymax}=Flatten[Through[{Min,Max}[#]]&/@Transpose@xy];

	(* The basic form of the exponential equation *)
	equation= y==a+b*Exp[c*x];

	(* First rescale x and y and then solve for y (move the coefficient to rhs) *)
	normalizedEquation = First[
		y/.Solve[equation /.
			{y->Rescale[y,{ymin, ymax}],x->Rescale[x,{xmin, xmax}]},
			y
		]
	];

	{
		Expression->Function[x,Evaluate@normalizedEquation],
		Parameters->({a,b,c}&),
		Box->(Null&)
	}
];

fitExpressionLookup[Exponential,xvars:{_Symbol},resolvedOps_]:=Module[{a=Unique["a"],b=Unique["b"],c=Unique["c"]},{
	Expression->(a + Exp[b(#-c)]&),
	Parameters->({{a,0},{b,1},{c,0}}&),
	Box->(With[{n=Length[#],x=#[[;;,1]],y=#[[;;,2]]},
		With[{n1=Max[{1,Round[n/3]}],n2=Clip[Round[n/2],{1,n}],n3=Min[{n,Round[2n/3]}]},
			If[Or[n===1,n1===n2,n2===n3,Abs[(Mean[y[[n1;;n3]]]-Mean[y[[;;n1]]])/(x[[n2]]-x[[1]])]>Abs[(Mean[y[[n3;;]]]-Mean[y[[n1;;n3]]])/((x[[-1]]-x[[n2]]))]],
				{{1,0},{Exp[1],1}},
				{{0,1},{1,Exp[1]}}
			]
		]
	]&)
}];

fitExpressionLookup[Exponential,xvars_,resolvedOps_]:=Module[{a=Unique["a"],b=Unique["b"],c=Unique["c"]},With[
	{pars=Table[Unique["p"],{ix,1,Length[xvars]}]},
	{
		Expression->(Evaluate[a + Exp[b + pars.xvars]]&),
		Parameters->(Evaluate[Join[{a,b,c},pars]]&),
		Box->(Null&)
	}
]];


fitExpressionLookup[Log,xvars:{_Symbol},resolvedOps_]:=Module[{a,b},{
	Expression->(Lookup[resolvedOps, LogBase]^(a+b*Log[Lookup[resolvedOps, LogBase],#])&),
	Parameters->({{a,0},{b,1}}&),
	Box->({{Null,Null},{Null,Null}}&)
}];
fitExpressionLookup[Log,xvars_,resolvedOps_]:=Module[{a=Unique["a"]},With[
	{pars=Table[Unique["p"],{ix,1,Length[xvars]}]},
	{
		Expression->(Evaluate[Lookup[resolvedOps, LogBase]^(a+pars.Table[Log[Lookup[resolvedOps, LogBase],xv],{xv,xvars}])]&),
		Parameters->(Evaluate[Join[{a},pars]]&),
		Box->(Null&)
	}
]];

(*  Given {x,y}, fit y = a*z+b, where z=Log[x].  Then return y = a*Log[x]+b  *)
fitExpressionLookup[LogLinear,xvars:{_Symbol},resolvedOps_]:=Module[{a,b},{
	Expression->(a+b*Log[Lookup[resolvedOps, LogBase],#]&),
	Parameters->({{a,0},{b,1}}&),
	Box->({{Null,Null},{Null,Null}}&)
}];
fitExpressionLookup[LogLinear,xvars_,resolvedOps_]:=Module[{a=Unique["a"]},With[
	{pars=Table[Unique["p"],{ix,1,Length[xvars]}]},
	{
		Expression->(Evaluate[a+pars.Table[Log[Lookup[resolvedOps, LogBase],xv],{xv,xvars}]]&),
		Parameters->(Evaluate[Join[{a},pars]]&),
		Box->(Null&)
	}
]];

fitExpressionLookup[LogPolynomial,xvars:{_Symbol},resolvedOps_]:=With[{pars=Table[Unique["p"],{Lookup[resolvedOps, PolynomialDegree]+1}]},{
	Expression->(Evaluate[pars.(Log[Lookup[resolvedOps, LogBase],#]^Range[0, Lookup[resolvedOps, PolynomialDegree]])]&),
	Parameters->(Evaluate[pars]&),
	Box->({{Null,Null},{Null,Null}}&)
}];

fitExpressionLookup[LinearLog,xvars:{_Symbol},resolvedOps_]:=Module[{a,b},{
	Expression->(Lookup[resolvedOps, LogBase]^(a+b*#)&),
	Parameters->({{a,0},{b,1}}&),
	Box->({{Null,Null},{Null,Null}}&)
}];
fitExpressionLookup[LinearLog,xvars_,resolvedOps_]:=Module[{a=Unique["a"]},With[
	{pars=Table[Unique["p"],{ix,1,Length[xvars]}]},
	{
		Expression->(Evaluate[Lookup[resolvedOps, LogBase]^(a+pars.xvars)]&),
		Parameters->(Evaluate[Join[{a},pars]]&),
		Box->(Null&)
	}
]];



fitExpressionLookup[Exp4,xvars:{_Symbol},resolvedOps_]:=Module[{a,b,c,d,e,f,g,h,i,j},{
	Expression->(Evaluate[a + ( b * (Exp[c(#-d)]-Exp[e(#-f)])/(Exp[g(#-h)]+Exp[i(#-j)]))]&),
	Parameters->(Evaluate[{{a,0},{d,0},b,c,e,f,g,h,i,j}]&),
	Box->({{-1,1},{-1,1}}&)
}];

fitExpressionLookup[SinhCosh,xvars:{_Symbol},resolvedOps_]:=Module[{a,b,c,d,e,f},{
	Expression->(Evaluate[a+b*Sinh[c*#+d]/Cosh[e*#-f]]&),
	Parameters->(Evaluate[{{a,0},{d,0},b,c,e,f}]&),
	Box->({{-1,1},{-1,1}}&)
}];

fitExpressionLookup[Erf,xvars:{_Symbol},resolvedOps_]:=Module[{a,b,c,d},{
	Expression->(Evaluate[a + b * Erf[c # - d]]&),
	Parameters->(Evaluate[{{a,0},{d,0},b,c}]&),
	Box->({{-1,1},{-1,1}}&)
}];

fitExpressionLookup[Logistic,xvars:{_Symbol},resolvedOps_]:=Module[{a,b,c,d},{
	Expression->(Evaluate[a + b / (1 + Exp[c*(# - d)])]&),
	Parameters->(Evaluate[{a,d,b,c}]&),
	Box->({{-1,1},{-1,1}}&)
}];

(* Logistic fit expression if the fit normalization is true will rescale the expression *)
fitExpressionLookup[Logistic,xy_,xvars:{_Symbol},resolvedOps_]:=Module[
	{a=Unique["a"],b=Unique["b"],c=Unique["c"],d=Unique["d"],
	xmin,xmax,ymin,ymax,equation,normalizedEquation},

	(* Finding the min and max of the xy data *)
	{xmin,xmax,ymin,ymax}=Flatten[Through[{Min,Max}[#]]&/@Transpose@xy];

	(* The basic form of the logistic equation *)
	equation= y==a+b/(1+Exp[c*(x-d)]);

	(* First rescale x and y and then solve for y (move the coefficient to rhs) *)
	normalizedEquation = First[
		y/.Solve[equation /.
			{y->Rescale[y,{ymin, ymax}],x->Rescale[x,{xmin, xmax}]},
			y
		]
	];

	{
		Expression->Function[x,Evaluate@normalizedEquation],
		Parameters->({a,b,c,d}&),
		Box->(Null&)
	}
];

(* making sure the slope remain positive *)
fitExpressionLookup[LogisticBase10,xvars:{_Symbol},resolvedOps_]:=Module[{},{
	Expression->(Evaluate[asymptote2 + (asymptote1-asymptote2) / (1 + 10^(slope*(intercept-#)))]&),
	Parameters->(Evaluate[{asymptote1,asymptote2,slope,intercept}]&),
	Box->({{-1,1},{-1,1}}&)
}];

(* LogisticBase10 fit expression if the fit normalization is true will rescale the expression *)
fitExpressionLookup[LogisticBase10,xy_,xvars:{_Symbol},resolvedOps_]:=Module[
	{xmin,xmax,ymin,ymax,equation,normalizedEquation},

	(* Finding the min and max of the xy data *)
	{xmin,xmax,ymin,ymax}=Flatten[Through[{Min,Max}[#]]&/@Transpose@xy];

	(* The basic form of the exponential equation *)
	equation= y==asymptote2+(asymptote1-asymptote2)/(1+10^(slope*(intercept-x)));

	(* First rescale x and y and then solve for y (move the coefficient to rhs) *)
	normalizedEquation = First[
		y/.Solve[equation /.
			{y->Rescale[y,{ymin, ymax}],x->Rescale[x,{xmin, xmax}]},
			y
		]
	];

	{
		Expression->Function[x,Evaluate@normalizedEquation],
		Parameters->({asymptote1,asymptote2,slope,intercept}&),
		Box->(Null&)
	}
];

fitExpressionLookup[GeneralizedLogistic,xvars:{_Symbol},resolvedOps_]:=Module[{a,b,c,d,e},{
	Expression->(Evaluate[a + b / (e + Exp[c # - d])]&),
	Parameters->(Evaluate[{a,d,b,c,e}]&),
	Box->({{-1,1},{-1,1}}&)
}];

(* GeneralizedLogistic fit expression if the fit normalization is true will rescale the expression *)
fitExpressionLookup[GeneralizedLogistic,xy_,xvars:{_Symbol},resolvedOps_]:=Module[
	{a,b,c,d,e,xmin,xmax,ymin,ymax,equation,normalizedEquation},

	(* Finding the min and max of the xy data *)
	{xmin,xmax,ymin,ymax}=Flatten[Through[{Min,Max}[#]]&/@Transpose@xy];

	(* The basic form of the logistic equation *)
	equation= y==a+b/(e+Exp[c*x-d]);

	(* First rescale x and y and then solve for y (move the coefficient to rhs) *)
	normalizedEquation = First[
		y/.Solve[equation /.
			{y->Rescale[y,{ymin, ymax}],x->Rescale[x,{xmin, xmax}]},
			y
		]
	];

	{
		Expression->Function[x,Evaluate@normalizedEquation],
		Parameters->({a,b,c,d,e}&),
		Box->(Null&)
	}
];

fitExpressionLookup[ArcTan,xvars:{_Symbol},resolvedOps_]:=Module[{a=Unique["a"],b=Unique["b"],c=Unique["c"],d=Unique["d"]},{
	Expression->(Evaluate[a +b * ArcTan[c # - d]]&),
	Parameters->(Evaluate[{{a,0},{d,0},b,c}]&),
	Box->({{-1,1},{-1,1}}&)
}];

fitExpressionLookup[Tanh,xvars:{_Symbol},resolvedOps_]:=Module[{a=Unique["a"],b=Unique["b"],c=Unique["c"],d=Unique["d"]},{
	Expression->(Evaluate[a +b * Tanh[c # - d]]&),
	Parameters->(Evaluate[{{a,0},{d,0},b,c}]&),
	Box->({{-1,1},{-1,1}}&)
}];

fitExpressionLookup[Gaussian,xvars:{_Symbol},resolvedOps_]:=Module[{a,b,c,d},{
	Expression->(Evaluate[a + b*Exp[-(#-c)^2/d]]&),
	Parameters->({{a,0},{b,1},{c,0},{d,1}}&),
	Box->({{-1,1},{0,1}}&)
}];
fitExpressionLookup[Gaussian,xvars_,resolvedOps_]:=Module[{a=Unique["a"],b=Unique["b"],d=Unique["d"],cpars},
	cpars = Table[Symbol["c"<>ToString[ix]],{ix,1,Length[xvars]}];
	{
		Expression->(Evaluate[a + b*Exp[-Total[MapThread[Function[{x,c},(x-c)^2],{xvars,cpars}]]/d]]&),
		Parameters->(Evaluate[{{a,0},{b,1},{d,1},Sequence@@Table[{c,0},{c,cpars}]}]&),
		Box->({{-1,1},{0,1}}&)
	}
];


fitExpressionLookup[fcn_Function,xvars_,resolvedOps_]:=Module[{fcnWithoutXs, subRules,pars},
	(* make sure number of variables in function matches size of data *)
	fcnWithoutXs = Quiet[Check[Evaluate[fcn@@Map[Slot,Range[Length[xvars]]]]&,Null],{Function::slotn}];
	If[MatchQ[fcnWithoutXs,Null],Return[Message[AnalyzeFit::InputDataSizeMismatch]]];
	subRules = Map[#[[1]]->{#[[1]],#[[2]]}&,Lookup[resolvedOps, StartingValues]];
	pars = DeleteDuplicates@Replace[Cases[{N[fcnWithoutXs]},Except[E|Pi,_Symbol],Infinity],subRules,{1}];
	(* make sure evaluating the function on input data returns something numeric *)
	If[!functionIsValidQ[fcnWithoutXs,Length[xvars]],
		Message[AnalyzeFit::InvalidFunction];
		Return[Null];
	];
{
	Expression->fcnWithoutXs,
	Parameters->(Evaluate[pars]&),
	Box->({{Null,Null},{Null,Null}}&)
}];

fitExpressionLookup[LogisticFourParam,xvars:{_Symbol},resolvedOps_]:=Module[{a=Top,b=Slope,c=InflectionPoint,d=Bottom},
	If[Lookup[resolvedOps, LogTransformed],
		fitExpressionLookup[d + (a-d) / (1+(2^#/c)^b)&, xvars, resolvedOps],
		fitExpressionLookup[d + (a-d) / (1+(#/c)^b)&, xvars, resolvedOps]
	]
];


fitExpressionLookup[Sigmoid,xvars_List,resolvedOps_]:= fitExpressionLookup[ArcTan, xvars, resolvedOps];

fitExpressionLookup[exprType_Symbol,xvars_List,___]:=Module[{},
	Message[AnalyzeFit::InvalidExpressionType,exprType,Length[xvars]];
	{}
];


functionSymbolPars[f_]:=DeleteDuplicates@Cases[{N[f]},Except[E|Pi,_Symbol],Infinity];
functionMatchesDataQ[f_,n_]:=Quiet[Check[Evaluate[f@@Map[Slot,Range[n]]]&; True,False]];
functionIsValidQ[f_Function,n_]:=Quiet[MatchQ[Check[N[f@@RandomReal[{0,1},n]/.Map[#->RandomReal[]&,functionSymbolPars[f]]],Null],_?NumericQ]];
functionIsValidQ[___]:=False;


(* ::Subsubsection::Closed:: *)
(*outlierPositions*)


Options[outlierPositions]={
		OutlierDistance -> 1.5,
		HatDiagonal -> Null,
		Method -> Both (* Can be HatDiagonal, IQR, or Both *)
};
outlierPositions::MissingHatDiagonal="Method was specified as HatDiagonal or Both, but no HatDiagonal was provided.";

outlierPositions[pts0:{_?NumericQ..}, ops:OptionsPattern[outlierPositions]] := Module[{pts = Cases[pts0,_Real], safeOps = SafeOptions[outlierPositions, ToList[ops]]},
	If[Length[pts]<2,
		Return[{}],
		Switch[Lookup[safeOps, Method],
			Both, DeleteDuplicates@Join[outlierPositions[pts,ReplaceRule[safeOps,{Method -> HatDiagonal}]],outlierPositions[pts,ReplaceRule[safeOps,{Method->IQR}]]],
			HatDiagonal, If[Lookup[safeOps, HatDiagonal] === Null,
				(Message[outlierPositions::MissingHatDiagonal]; {}),
				Select[Transpose[{Range[Length[pts]],Lookup[safeOps, HatDiagonal]}], #[[2]] > 2*Total[Lookup[safeOps, HatDiagonal]]/Length[pts] &][[;;,1]]
			],
			IQR, Module[{q1,q3,iqr},
				{q1,q3}=Quantile[pts,{0.25,0.75}];
				iqr=q3-q1;
				Select[Transpose[{Range[Length[pts]],pts}],Or[#[[2]]<(q1-Lookup[safeOps, OutlierDistance]*iqr),#[[2]]>(q3+Lookup[safeOps, OutlierDistance]*iqr)]&][[;;,1]]
			]
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*computeFitError*)
Authors[computeFitError]:={"scicomp", "brad"};


computeFitError[g:FunctionP,dataPts:{{_?NumericQ,_?NumericQ}}]:=0;
computeFitError[g:FunctionP,dataPts_List]:= StandardDeviation[g[dataPts[[All,1]]]-dataPts[[All,2]]];


(* ::Subsubsection::Closed:: *)
(*transformData*)


transformData::usage="
DEFINITION
	transformData[dataPts:{_?NumericQ..},range:({min_,max_}|Null)]==>{newData, scale, shift}
		Shift and scale given dataPts so that the transformed dataPts goes from min to max.

MORE INFORMATION
	If range is not specified, the range is set to {0,1}.  If range is Null, no transformation is done.
	This function is called by internal fitting functions, such as fitFunction, and used for transformFunction.

INPUTS
	'data' - List of {x,y} data pairs
	'range' - a pair of numbers or Null, range of points to scale and shift to.

OUTPUTS
	'newData' - transformed version of data
	'scale' - The amount the data was scaled by
	'shift' - the amount the data was shifted by

SEE ALSO
	transformFunction

AUTHORS
	Brad
";

transformDataNew[vec:NVectorP,Null]:=vec;
transformDataNew[vec:NVectorP,{Null,Null}]:={vec,Null,Null};
transformDataNew[vec:NVectorP,{a_?NumericQ,b_?NumericQ}]:=Module[{scale,shift,min,max,upward},
	{min,max}=MinMax[vec];
	If[min===max,Return[{vec,1,0}]];
	upward=(vec[[-1]]-vec[[1]])/Length[vec]/Max[Abs[{min,max}]];
	scale = (b-a) / If[upward>-10^-6,(max-min),(min-max)] ;
(*	shift = a - scale * If[vec[[-1]]>vec[[1]],min,max]; *)
	shift = a - scale * If[upward>-10^-6,min,max];
	{vec*scale+shift,scale,shift}
];



(* ::Subsubsection::Closed:: *)
(*transformFunction*)


(* Note: do not set patterns for scale, because they can be expressions... *)
Authors[transformFunction]:={"scicomp", "brad"};
transformFunction[f_Function,{xscale_,yscale_},{xshift_,yshift_}]:=
	Function[Evaluate[(f[xscale*#+xshift]-yshift)/yscale]];


(* no trans *)
transformExpressionX[expr_,xvar_,Null,Null]:=expr;
transformExpressionY[expr_,Null,Null]:=expr;

(* linear shift *)
transformExpressionX[expr_,xvar_,xscale_?NumericQ,0|0.]:=ReplaceAll[expr,xvar->(xvar*xscale)];
transformExpressionX[expr_,xvar_,xscale_?NumericQ,xshift_?NumericQ]:=ReplaceAll[expr,xvar->(xvar*xscale+xshift)];
transformExpressionY[expr_,yscale_?NumericQ,yshift_?NumericQ]:=((expr-yshift)/yscale);


(* no trans *)
transformFunctionX[f_Function,Null,Null]:=f;
transformFunctionY[f_Function,Null,Null]:=f;

(* linear shift *)
transformFunctionX[f_Function,xscale_?NumericQ,0|0.]:=
	(Evaluate[f[Slot[1]]/.{Slot[1]:>(xscale*Slot[1])}]&);
transformFunctionX[f_Function,xscale_?NumericQ,xshift_?NumericQ]:=
	(Evaluate[f[Slot[1]]/.{Slot[1]:>(xscale*Slot[1]+xshift)}]&);
transformFunctionY[f_Function,yscale_?NumericQ,yshift_?NumericQ]:=
	(Evaluate[(f[Slot[1]]-yshift)/yscale]&);


(* ::Subsubsection::Closed:: *)
(*NearestCovarianceMatrix*)


 ProjectSemiPositiveDefinite[A_?MatrixQ] := Module[{values, vectors,positiveValues, ANew},
	{values,vectors} = Eigensystem[N[A]];

	(*Mathematica sucks and returns eigenvectors \[UndirectedEdge] values in a non-traditional order - see http://mathematica.stackexchange.com/questions/6420/how-do-i-keep-the-right-ordering-of-eigenvalues-using-eigensystem god damn it mathematica*)

	values = Reverse[values];
	vectors = Transpose[Reverse[vectors]];

	positiveValues = Max[#,0]& /@ values; (*Zero out any non positive eigenvalues*)

	ANew = vectors.DiagonalMatrix[positiveValues].Transpose[vectors];
	ANew = (ANew + Transpose[ANew]) / 2;

	ANew
];

ProjectUnitDiagonal[A_?MatrixQ] := Module[{ANew, diagIndex},
	ANew = A;
	For[diagIndex=  1, diagIndex <= Length[A], diagIndex++,
		ANew[[diagIndex]][[diagIndex]]= 1;
	];
	ANew
];

NearestCorrelationMatrix[A_?MatrixQ] := Module[{weights, tolerance, X, Y, differenceX, differenceY, differenceXY, sqrtWeights, numIteration, numMaxIterations, XOld, R, RWeighted, dS, YOld, NormX, NormY},

	(*The input matrix is assumed to be symmetric*)
	If[!SymmetricMatrixQ[A], (*Return["Error! Input Matrix is not symmetric!"]*) Return[Null]];

	(*Unless specified input weights, assume all of the input weights to be one*)
	weights = ConstantArray[1, Length[A]];

	tolerance = $MachineEpsilon * Length[A];

	X = A;
	Y = A;
	differenceX = Infinity;
	differenceY = Infinity;
	differenceXY = Infinity;

	dS = ConstantArray[0, {Length[A], Length[A[[1]]]}];
	sqrtWeights = Sqrt[Outer[Times, weights, weights]];

	numIteration = 0;
	numMaxIterations = 100;

	While[Max[differenceX, differenceY, differenceXY] > tolerance,
	If[numIteration > numMaxIterations,
		(*Return["Error: Too many iterations!"];*)
		Return[Null]
	];

	XOld = X;
	R = Y - dS;
	RWeighted = sqrtWeights *R;
	X = ProjectSemiPositiveDefinite[RWeighted];
	X = X / sqrtWeights;
	dS = X - R;
	YOld = Y;
	Y = ProjectUnitDiagonal[X];
	NormX = Norm[X, "Frobenius"];
	NormY = Norm[Y, "Frobenius"];
	differenceX = Norm[X - XOld, "Frobenius"]/NormX;
	differenceY = Norm[Y - YOld, "Frobenius"]/NormY;
	differenceXY = Norm[Y-X, "Frobenius"] /NormY;

	numIteration ++;
	];
	X
];


covarianceToCorrelation[cov_]:=With[{sds=Sqrt[Diagonal[cov]]},cov/(Transpose[{sds}].{sds})];

correlationToCovariance[corr_,sds_]:=corr*(Transpose[{sds}].{sds});

NearestCovarianceMatrix[cov_]:=Module[{sds,corr,corrNew,covNew},
	sds = Sqrt[Diagonal[cov]];
	corr=correlationToCovariance[cov,sds];
	corrNew = NearestCorrelationMatrix[corr];
	covNew = correlationToCovariance[corrNew,sds];
	covNew
];


(* ::Subsection::Closed:: *)
(*Formatting packet*)


(* ::Subsubsection:: *)
(*formatFitPacket*)


formatFitPacket[standardFieldsStart_, resolvedOps_, fitCorePacket:Null, dataFields_]:=<||>;

formatFitPacket[standardFieldsStart_, resolvedOps_, fitCorePacket_, dataFields_] := Module[
	{dataUnits,vars,packet},

	dataUnits = Lookup[dataFields,DataUnits];
	vars = Lookup[fitCorePacket,BestFitVariables];

	cntForFitName = cntForFitName + 1;

	packet = Association[
		Join[
			standardFieldsStart,
			FilterRules[dataFields,{
				DataPoints,FitField,TransformationFunction,ReferenceField
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
				Type -> Object[Analysis, Fit],
				ResolvedOptions -> resolvedOps,
				(*  *)
				Replace[Reference] -> Lookup[dataFields,Reference],
				Replace[IndependentVariableData] -> Lookup[dataFields,IndependentVariableData,{}],
				Replace[SecondaryIndependentVariableData] -> Lookup[dataFields,SecondaryIndependentVariableData,{}],
				Replace[TertiaryIndependentVariableData] -> Lookup[dataFields,TertiaryIndependentVariableData,{}],
				Replace[DependentVariableData] -> Lookup[dataFields,DependentVariableData,{}],
				Replace[DataUnits] -> dataUnits,
				Replace[BestFitVariables] -> Lookup[dataFields,BestFitVariables],

				(*  *)
				Replace[MinDomain] -> Lookup[fitCorePacket,MinDomain],
				Replace[MaxDomain] -> Lookup[fitCorePacket,MaxDomain],
				BestFitFunction -> wrapUnitFunction[Lookup[fitCorePacket,BestFitFunction],dataUnits],
				BestFitExpression->Lookup[fitCorePacket,BestFitExpression],
				SymbolicExpression -> Lookup[fitCorePacket,SymbolicExpression],
				Replace[BestFitParameters]->Lookup[fitCorePacket,BestFitParameters],
				BestFitParametersDistribution->Lookup[fitCorePacket,BestFitParametersDistribution],
				(* should it be Replace?? *)
				Replace[MarginalBestFitDistribution]->Lookup[fitCorePacket,MarginalBestFitDistribution],
				Replace[BestFitVariables]->vars,
				ExpressionType -> Lookup[fitCorePacket,ExpressionType],
				BestFitResiduals->Lookup[fitCorePacket,BestFitResiduals],
				Response->QuantityArray[Lookup[fitCorePacket,Response],Last[dataUnits]],
				PredictedResponse->QuantityArray[Lookup[fitCorePacket,PredictedResponse],Last[dataUnits]],

				MeanPredictionError -> wrapUnitFunction[Lookup[fitCorePacket,MeanPredictionError],dataUnits],
				MeanPredictionInterval -> wrapUnitFunction[Lookup[fitCorePacket,MeanPredictionInterval],dataUnits],
				MeanPredictionDistribution -> wrapUnitFunctionDistribution[Lookup[fitCorePacket,MeanPredictionDistribution],dataUnits,vars],
				SinglePredictionError -> wrapUnitFunction[Lookup[fitCorePacket,SinglePredictionError],dataUnits],
				SinglePredictionInterval -> wrapUnitFunction[Lookup[fitCorePacket,SinglePredictionInterval],dataUnits],
				SinglePredictionDistribution -> wrapUnitFunctionDistribution[Lookup[fitCorePacket,SinglePredictionDistribution],dataUnits,vars]

			},
			FilterRules[fitCorePacket,{
				ANOVATable,Replace[ANOVAOfModel],Replace[ANOVAOfError],Replace[ANOVAOfTotal],FStatistic,FCritical,FTestPValue,
				AIC,AICc,AdjustedRSquared,RSquared,BIC,CovarianceMatrix,
				Exclude,Outliers,HatDiagonal,StandardDeviation,SumSquaredError,EstimatedVariance
			}]
		]
	]

];

wrapUnitFunction[Null,_]:=Null;
wrapUnitFunction[f_,dataUnits_]:=QuantityFunction[f,Most[dataUnits],Last[dataUnits]];

wrapUnitFunctionDistribution[Null,_,_]:=Null;
wrapUnitFunctionDistribution[f_Function,dataUnits_,vars_]:=With[
	{qf = QuantityDistribution[f@@vars,Last[dataUnits]]},
	QuantityFunction[Function[Evaluate[vars],qf],Most[dataUnits],1]
];


(* ::Subsubsection:: *)
(*wrapFitUploadPacket*)


wrapFitUploadPacket[standardFieldsStart_, resolvedOptions_, fitFields_, dataFields_]:= Module[
	{fitPackets, uploadedPackets},

	fitPackets = formatFitPacket[standardFieldsStart, resolvedOptions, fitFields, dataFields];
	uploadedPackets = uploadAnalyzePackets[{{fitPackets, {}}}];

	First[First[uploadedPackets]]

];


(* ::Subsection::Closed:: *)
(*AnalyzeFitOptions*)


DefineOptions[AnalyzeFitOptions,
	SharedOptions :> {AnalyzeFit},
	{
		OptionName -> OutputFormat,
		Default -> Table,
		AllowNull -> False,
		Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
		Description -> "Determines whether the function returns a table or a list of the options."
	}];


AnalyzeFitOptions[xy:analyzeFitDataP,expr:_Symbol|_Function,ops:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions, options},

	listedOptions = ToList[ops];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

	options = AnalyzeFit[xy,expr,Append[noOutputOptions,Output->Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,AnalyzeFit],
		options
	]
];


AnalyzeFitOptions[xy:analyzeFitDataP,ops:OptionsPattern[]]:=Module[
	{},

	AnalyzeFitOptions[xy, Automatic, ops]
];


(* ::Subsection::Closed:: *)
(*AnalyzeFitPreview*)


DefineOptions[AnalyzeFitPreview,
	SharedOptions :> {AnalyzeFit}
];


AnalyzeFitPreview[xy:analyzeFitDataP,expr:_Symbol|_Function,ops:OptionsPattern[]]:=Module[
	{preview},

	preview = AnalyzeFit[xy,expr,Append[ToList[ops],Output->Preview]];

	If[MatchQ[preview, $Failed|Null],
		Null,
		preview
	]
];


AnalyzeFitPreview[xy:analyzeFitDataP,ops:OptionsPattern[]]:=Module[
	{},

	AnalyzeFitPreview[xy, Automatic, ops]
];


(* ::Subsection::Closed:: *)
(*ValidAnalyzeFitQ*)


DefineOptions[ValidAnalyzeFitQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {AnalyzeFit}
];


ValidAnalyzeFitQ[xy:analyzeFitDataP,expr:_Symbol|_Function,ops:OptionsPattern[]]:=Module[
	{preparedOptions,functionTests,initialTestDescription,allTests,verbose, outputFormat},

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[ToList[ops],Output->Tests],{Verbose,OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=AnalyzeFit[xy,preparedOptions];

	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[functionTests,$Failed],
		{Test[initialTestDescription,False,True]},

		Module[{initialTest,validObjectBooleans,inputObjs,voqWarnings,testResults},
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			inputObjs = Cases[Flatten[xy,1], _Object | _Model];

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
	RunUnitTest[<|"ValidAnalyzeFitQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose]["ValidAnalyzeFitQ"]
];


ValidAnalyzeFitQ[xy:analyzeFitDataP,ops:OptionsPattern[]]:= Module[{},

	ValidAnalyzeFitQ[xy, Automatic, ops]
];


(* ::Subsection::Closed:: *)
(*ConvertGradient*)


DefineOptions[ConvertGradient,
	Options:>{
		{SamplingRate -> 0.1, RangeP[0,1], "The sampling frequency (per minute) across each curve."}
	}
];


Error::InvalidTotalPercent = "The sum of the input percentages is not equal to 100. Please adjust the input percentages to sum to 100.";


ConvertGradient[gradientInputs:{{_?TimeQ, {_?PercentQ, _?PercentQ, _?PercentQ, _?PercentQ}, GreaterP[0 Milliliter/Minute], _?(MemberQ[Range[1,11],#]&) | Null}..}, ops:OptionsPattern[]]:= Module[
	{safeOps, samplingRate, endPoint, intervals, intervalPercents},

	safeOps = SafeOptions[ConvertGradient, List[ops]];
	samplingRate = Lookup[safeOps, SamplingRate];

	(* process each interval of gradient change, also take into account of the end point *)
	endPoint = Prepend[Rest[Last[gradientInputs]],First[Last[gradientInputs]] + samplingRate*Minute];
	intervals = Transpose/@Partition[Append[gradientInputs, endPoint], 2, 1];

	intervalPercents = convertGradientCore[Sequence[Most[Most[#]], First[#[[-2]]], Last[Last[#]], samplingRate]]& /@ intervals;

	Map[{
		Quantity[#[[1]],"Minutes"],
		Quantity[#[[2]],"Percent"],
		Quantity[#[[3]],"Percent"],
		Quantity[#[[4]],"Percent"],
		Quantity[#[[5]],"Percent"],
		Quantity[#[[6]],"Milliliters"/"Minutes"]
	}&, Flatten[intervalPercents, 1]]


];

convertGradientCore[{{sTime_, eTime_}, {sPercents_, ePercents_}}, flowRate_, curveNumber_, samplingRate_] := Module[
	{sTimeUL, eTimeUL, flowRateUL, percentPairs, curveFunction, samplingTimes, flowRates, resultA, resultB, resultC, resultD},

	(* check the percentages sum to 100 *)
	If[Total[sPercents]!=100 Percent || Total[ePercents]!=100 Percent,
		Message[Error::InvalidTotalPercent];
		Return[$Failed]
	];

	{sTimeUL, eTimeUL} = Unitless[{sTime, eTime}, Minute];
	percentPairs = Unitless[Transpose[{sPercents, ePercents}]];
	flowRateUL = Unitless[flowRate, Milliliter/Minute];


	curveFunction = Switch[curveNumber,
		1 | 11, stepGradient,
		RangeP[2,5], convexGradient,
		RangeP[6,10], concaveGradient
	];

	(* sampling *)
	samplingTimes = Most[Range[sTimeUL, eTimeUL, samplingRate]];
	flowRates = flowRateUL&/@samplingTimes;

	{resultB, resultC, resultD} = Map[
		(curveFunction[{sTimeUL, eTimeUL}, #, curveNumber]/@samplingTimes)&,
		Rest[percentPairs]
	];

	resultA = 100- (resultB + resultC + resultD);

	Transpose[{samplingTimes, resultA, resultB, resultC, resultD, flowRates}]

	(*{
		QuantityArray[resultA, Percent],
		QuantityArray[resultB, Percent],
		QuantityArray[resultC, Percent],
		QuantityArray[resultD, Percent]
	}*)

];


stepGradient[{sTime_, eTime_}, {sPercent_, ePercent_}, 1]:= ePercent&;
stepGradient[{sTime_, eTime_}, {sPercent_, ePercent_}, 11]:= sPercent&;


convexGradient[{sTime_, eTime_}, {sPercent_, ePercent_}, curveNumber_]:= Module[
	{mapping, fcn, Ti, Tf, Ci, Cf},

	(* Curve index to power of N mapping *)
	mapping = <|2->8, 3->5, 4->3, 5->2|>;

	(* Initialize parameters *)
	{Ti, Tf} = {sTime, eTime};
	{Ci, Cf} = {sPercent, ePercent};

	(* fitting function *)
	Cf-(Cf-Ci)*((Tf-#)/(Tf-Ti))^(mapping[curveNumber])&

];


concaveGradient[{sTime_, eTime_}, {sPercent_, ePercent_}, curveNumber_]:= Module[
	{mapping, fcn, Ti, Tf, Ci, Cf},

	(* Curve index to power of N mapping *)
	mapping=<|6->1, 7->2, 8->3, 9->5, 10->8|>;

	(* Initialize parameters *)
	{Ti, Tf} = {sTime, eTime};
	{Ci, Cf} = {sPercent, ePercent};

	(* fitting function *)
	Ci+(Cf-Ci)*((#-Ti)/(Tf-Ti))^(mapping[curveNumber])&

];




resolveDistributionInputs[xy : QuantityArrayP[]] :=
  With[{qm = QuantityMagnitude[xy]},
   		If[MatrixQ[qm, NumericQ],
    			{
     				xy,
     				Table[Null, {Length[qm]}, {Length[First[qm]] - 1}],
     				Table[Null, {Length[qm]}]
     			},
    			{
     				Map[meanOrValue, xy, {2}],
     				Map[stdDevOrValue, xy[[;; , 1 ;; -2]], {2}],
     				Map[stdDevOrValue, xy[[;; , -1]]]
     			}
    		]
   ];

(* if no distributions, return Null for all standard deviations *)
resolveDistributionInputs[
   xy : (_Replicates | _?(MatrixQ[#, NumericQ] &))] :=
      {
   	    xy,
   	    Table[Null, {Length[xy]}, {Length[First[xy]] - 1}],
   	    Table[Null, {Length[xy]}]
       };


resolveDistributionInputs[xy_] := Module[{},
   	{
    		Map[meanOrValue, xy, {2}],
    		Map[stdDevOrValue, xy[[;; , 1 ;; -2]], {2}],
    		Map[stdDevOrValue, xy[[;; , -1]]]
    	}
   ];

meanOrValue[val : Null] := val;
meanOrValue[val_?NumericQ] := val;
meanOrValue[val_Quantity] := val;
meanOrValue[dist_] := Mean[dist];

stdDevOrValue[val : Null] := Null;
stdDevOrValue[val_?NumericQ] := Null;
stdDevOrValue[val_Quantity] := Null;
stdDevOrValue[dist_] := StandardDeviation[dist];



unitlessErrorList[in : {Null ..}, unit_] := in;
unitlessErrorList[in_, unit_] := Unitless[in, unit];


formatFitRelation[in : {objectOrLinkP[] ...}, referenceField_List] :=
  MapThread[formatOneFitRelation, {in, referenceField}];
formatFitRelation[in : {objectOrLinkP[] ...}, referenceField_] :=
  formatOneFitRelation[#, referenceField] & /@ in;
formatFitRelation[in : objectOrLinkP[],
   referenceField_] := {Link[in,
    fitRelationField[in, referenceField]]};
formatFitRelation[in_, _] := in;

formatOneFitRelation[in : objectOrLinkP[], referenceField_] :=
  Link[in, fitRelationField[in, referenceField]];
formatOneFitRelation[in_, _] := in;


resolvedAnalyzeFitExcludeOption[exclude:({}|Null),xyMags_,{inputUnit_,outputUnit_}]:={};
resolvedAnalyzeFitExcludeOption[exclude:{_Integer..},xyMags_,{inputUnit_,outputUnit_}]:=xyMags[[exclude]];
resolvedAnalyzeFitExcludeOption[exclude:{{_,_}..},xyMags_,{inputUnit_,outputUnit_}]:=unitlessOrIdentityOnCoordinates[{inputUnit,outputUnit},exclude];

unitlessOrIdentityOnCoordinates[{inputUnit_,outputUnit_},ptsList:CoordinatesP]:=ptsList;
unitlessOrIdentityOnCoordinates[{inputUnit_,outputUnit_},ptsList_]:=QuantityMagnitude[UnitConvert[ptsList,{inputUnit,outputUnit}]];