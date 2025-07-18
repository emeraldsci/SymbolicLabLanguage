(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

(* ----------------------- *)
(* --- CUSTOM PATTERNS --- *)
(* ----------------------- *)

(* Custom Patterns *)
dataPointsP={(UnitsP[]|DistributionP[])..}|_?QuantityVectorQ;
nestedFieldQ[arg_Symbol]:=True;
nestedFieldQ[head_Symbol[arg_]]:=nestedFieldQ[arg];
nestedFieldQ[_]:=False;
nestedFieldP = _?nestedFieldQ|_Field|_Symbol;

(* Input is a list of datasets. Each dataset is an object, list of objects, or coordinates *)
analyzeStandardCurveCoordinatesP={(UnitsP[]|DistributionP[])..}|_?QuantityVectorQ;
analyzeStandardCurveObjectInputP={ListableP[ObjectP[]],nestedFieldP};
analyzeStandardCurveSingleInputP=(analyzeStandardCurveObjectInputP|analyzeStandardCurveCoordinatesP);
analyzeStandardCurveStandardDataP=Alternatives[
  Automatic,
  ObjectP[Object[Analysis,Fit]],
  MatrixP[UnitsP[]|DistributionP[]]|_?QuantityMatrixQ,
  ObjectP[]|{ObjectP[],ObjectP[]},
  {ObjectP[]..},
  {{UnitsP[]|ObjectP[],UnitsP[]|ObjectP[]}..},
  FieldReferenceP[]|{FieldReferenceP[], FieldReferenceP[]}|{{FieldReferenceP[],FieldReferenceP[]}..}
];

(* ------------------------------ *)
(* --- STANDARD CURVE OPTIONS --- *)
(* ------------------------------ *)

DefineOptions[AnalyzeStandardCurve,
  Options:>{
    IndexMatching[
      IndexMatchingInput -> "Input Data",
      {
        OptionName -> InputField,
        Default -> Automatic,
        Description -> "When input is an object or list of objects, InputField indicates what field the input data is located in.",
        ResolutionDescription -> "When using protocol or data object input, default input field is determined by input object type.",
        AllowNull -> False,
        Widget -> Widget[Type->Expression,Pattern:>(None|nestedFieldP),PatternTooltip->"Default is Automatic, use None for non-object input",Size->Line],
        Category -> "Input Data Resolution"
      },
      {
        OptionName -> InputTransformationFunction,
        Default -> None,
        Description -> "A pure function applied to pre-process the input data.",
        ResolutionDescription -> "By default, no transformation is applied.",
        AllowNull -> False,
        Widget -> Widget[Type->Expression, Pattern:>None|_Function, Size-> Line],
        Category -> "Input Data Resolution"
      }
    ],
    {
      OptionName -> StandardData,
      Default -> Automatic,
      Description -> "Existing fit, or data points to fit the standard curve to.",
      ResolutionDescription -> "When using protocol input, the default location of standard data is determined by input object type.",
      AllowNull -> False,
      Widget -> Alternatives[
        "Existing Fit"->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,Fit]],PatternTooltip->"Existing standard curve to apply to data."],
        "Numerical Coordinates"->Adder[
          {
            "X"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
            "Y"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
          }
        ],
        "Coordinate Expression"->Widget[Type->Expression,Pattern:>MatrixP[UnitsP[]|DistributionP[]]|_?QuantityMatrixQ|Automatic,PatternTooltip->"The set of data points to fit to.",Size->Paragraph],
        "Object(s)"->Alternatives[
          "Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"A single object containing a list of {x,y} pairs to fit the standard curve to."],
          "List of Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]],
          "Paired Objects"->Adder[
            {
              "X"->Alternatives[
                Widget[Type->Expression,Pattern:>UnitsP[],PatternTooltip->"A number or distribution, with or without units.",Size->Word],
                Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]
              ],
              "Y"->Alternatives[
                Widget[Type->Expression,Pattern:>UnitsP[],PatternTooltip->"A number or distribution, with or without units.",Size->Word],
                Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]
              ]
            }
          ]
        ],
        "Field References" -> Widget[Type -> Expression, Pattern:>FieldReferenceP[]|{FieldReferenceP[], FieldReferenceP[]}|{{FieldReferenceP[],FieldReferenceP[]}..},Size->Line]
      ],
      Category -> "Standard Data Resolution"
    },
    {
      OptionName -> Protocol,
      Default -> Null,
      Description -> "The protocol associated with this standard curve analysis, used for linking analysis object to experimental protocol.",
      ResolutionDescription -> "When using protocol input, this option is used to create a link to the input protocol.",
      AllowNull -> True,
      Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Protocol]]],
      Category -> "Hidden"
    },
    {
      OptionName -> StandardFields,
      Default -> Automatic,
      Description -> "Pair of fields indicating where data is located in StandardData object(s).",
      ResolutionDescription -> "When using protocol or data object input, the default field references are determined by input object type.",
      AllowNull -> False,
      Widget -> {
        "X"->Widget[Type->Expression,Pattern:>None|nestedFieldP,PatternTooltip->"Default is Automatic, use None for non-object input",Size->Word],
        "Y"->Widget[Type->Expression,Pattern:>None|nestedFieldP,PatternTooltip->"Default is Automatic, use None for non-object input",Size->Word]
      },
      Category -> "Standard Data Resolution"
    },
    {
      OptionName -> StandardTransformationFunctions,
      Default -> {None, None},
      Description -> "A pair of pure functions {f1, f2} to apply to the x-values and y-values of standard curve data, respectively. None means no transform is applied.",
      ResolutionDescription -> "By default, no transformation is applied.",
      AllowNull -> False,
      Widget -> {
        "X"->Widget[Type->Expression,Pattern:>None|_Function,PatternTooltip->"Default is None",Size->Word],
        "Y"->Widget[Type->Expression,Pattern:>None|_Function,PatternTooltip->"Default is None",Size->Word]
      },
      Category -> "Standard Data Resolution"
    },
    {
      OptionName -> FitType,
      Default -> Automatic,
      Description -> "Type of expression, e.g. Polynomial or Exponential, or pure function to fit standard curve to.",
      ResolutionDescription -> "When using protocol or data object inputs, the default fit type is determined by the input object type.",
      AllowNull -> False,
      Widget -> Alternatives[
        Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,FitTypeP]],
        Widget[Type->Expression,Pattern:>_Function,PatternTooltip->"A pure function that will be used to fit standard curves.",Size->Line]
      ],
      Category -> "Curve Fitting"
    },
    {
      OptionName -> InversePrediction,
      Default -> False,
      Description -> "If set to True, the standard curve will be applied in reverse to input data, i.e. transform y-values to x-values.",
      ResolutionDescription -> "Default is False.",
      AllowNull -> False,
      Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
      Category -> "Curve Fitting"
    },

    OutputOption,
    UploadOption,
    AnalysisTemplateOption
  },

  SharedOptions :> {
    {AnalyzeFit, {Exclude, Domain, Range, ExcludeOutliers, OutlierDistance, PolynomialDegree, LogBase, LogTransformed, StartingValues, ErrorMethod, NumberOfSamples, Method, Scale}}
  }
];


(* ---------------------------- *)
(* --- MESSAGES AND ERRORS  --- *)
(* ---------------------------- *)
Warning::DefaultFitTypeUndefined="No default fit type is associated with standard data type(s) `1`. FitType has been defaulted to Linear.";
Warning::DuplicateStandardData="Multiple sets of standard data were provided for standard analyte(s) `1`. Duplicate standard data will be ignored.";
Warning::ProtocolAlreadySet="The option Protocol is redundant when the input is of type Object[Protocol]. Protocol will be ignored.";
Warning::UnspecifiedUnits="Data supplied in `1` has unspecified units, which are assumed to be compatible with units `2` in `3`. Please verify that the data supplied in `1` is correct.";
Warning::InputFieldOverride="The input field(s) for input(s) `1` (`2`) do not match the option(s) InputField, and have been defaulted to the option value(s) `3`.";
Warning::StandardFieldOverride="`1` has been doubly specified in both inputs and options. Values specified through options will take precedence.";
Warning::Extrapolation="Input datasets at indices `1` contain values outside of the range of provided standard data. Extrapolation will occur when applying standard curves.";
Error::InconsistentObjectTypes="The supplied value `1` for `2` is a list of objects with different types. Please supply object(s) with the same type.";
Error::InconsistentUnitsEach="Input dataset(s) at index `1` do not have compatible units. Please verify each datapoint in these inputs has compatible physical units.";
Error::InconsistentUnitsAll="Input datasets do not have compatible units (`1`). Please verify that each input has consistent physical units, or no specified units.";
Error::StandardDataInconsistentUnits="The resolved standard data `1` does not have self-consistent units. Please verify that each data point in the standard has compatible physical units.";
Error::StandardDataIncompatibleUnits="Independent variable in Standard Data has units `1`, which are incompatible with input units `2`. Please double check data units.";
Error::ExistingFitIncompatibleUnits="The Fit object supplied for Option StandardData has incompatible units (`1`) with input units (`2`). Please ensure that a Fit object with compatible units has been provided.";
Error::ExistingReferenceStandardCurve="The field ReferenceStandardCurve of `1` has already existed. The function can only be called when the field is empty. Please use another Object[Analysis, StandardCurve].";
Error::DefaultFieldUndefined="The object type(s) `1` do not have a default value defined for `2`. Please manually specify `2` with an input that matches FieldP[].";
Error::EmptyStandardField="One or more of the fields `1` in `2` are empty. Please double-check that the requested data is present using Inspect[`2`].";
Error::InvalidStandardField="The field(s) `1` are not valid fields in one or more of the objects `2`. Please verify the standard field selection using Inspect[`2`].";
Error::InvalidInputDataFormat="Input data at indices `1` did not resolve to a list of distributions or numeric quantities. Please check input data format, fields and/or input transformation functions.";
Error::InvalidStandardDataFormat="Standard data must be provided as a list of {x,y} coordinates, i.e. {{x1,y1},{x2,y2},..}, but resolved to `1`. Please check the supplied Standard Data and transformation functions.";
Error::InvalidStandardCurveFitField="The field StandardCurveFit of `1` is not a valid Object[Analysis, Fit]. Please use another Object[Analysis, StandardCurve]";
Error::MissingStandardData="No standard data was specified. Please verify that standard data has been provided either in the function call or through the StandardData option.";
Error::InvalidProtocolField="The field `1` is either not present or empty in protocol input `2`. Please verify that the input protocol has these fields.";
Error::AnalyzeFit="Errors were encountered fitting Standard Data. Please verify that AnalyzeFit[`1`,`2`] runs correctly with the specified options.";

(* --------------------- *)
(* --- LOOKUP TABLES --- *)
(* --------------------- *)
DefaultInputFields=<|
  Model[Sample, StockSolution, Standard]->ReferencePeaksPositiveMode,
  Object[Analysis, CellCount]->CellCount,
  Object[Analysis, CopyNumber]->CopyNumber,
  Object[Analysis, MeltingPoint]->MeltingTemperature,
  Object[Analysis, Peaks]->Position,
  Object[Analysis, QuantificationCycle]->QuantificationCycle,
	Object[Data, AbsorbanceSpectroscopy]->AbsorbanceSpectrum,
	Object[Data, AgaroseGelElectrophoresis]->{SampleElectropherogram,MarkerElectropherogram,PostSelectionElectropherogram},
	Object[Data, Chromatography]->{Absorbance,SecondaryAbsorbance,Conductance,ConductivityFlowCellTemperature,pH,pHFlowCellTemperature,Fluorescence,SecondaryFluorescence,TertiaryFluorescence,QuaternaryFluorescence,Scattering,MultiAngleLightScattering22Degree,MultiAngleLightScattering28Degree,MultiAngleLightScattering32Degree,MultiAngleLightScattering38Degree,MultiAngleLightScattering44Degree,MultiAngleLightScattering50Degree,MultiAngleLightScattering57Degree,MultiAngleLightScattering64Degree,MultiAngleLightScattering72Degree,MultiAngleLightScattering81Degree,MultiAngleLightScattering90Degree,MultiAngleLightScattering99Degree,MultiAngleLightScattering108Degree,MultiAngleLightScattering117Degree,MultiAngleLightScattering126Degree,MultiAngleLightScattering134Degree,MultiAngleLightScattering141Degree,MultiAngleLightScattering147Degree,DynamicLightScattering,RefractiveIndex},
	Object[Data, ChromatographyMassSpectra]->{Absorbance,IonAbundance,TotalIonAbundance,MassSpectrum},
	Object[Data, DifferentialScanningCalorimetry]->HeatingCurves,
  Object[Data, ELISA]->Intensities,
  Object[Data, FluorescenceIntensity]->Intensities,
  Object[Data, FluorescenceKinetics]->EmissionTrajectories,
	Object[Data, FluorescenceSpectroscopy]->{ExcitationSpectrum,EmissionSpectrum},
	Object[Data, LuminescenceSpectroscopy]->EmissionSpectrum,
  Object[Data, Microscope]->PhaseContrastCellCount,
	Object[Data, MassSpectrometry]->MassSpectrum,
	Object[Data, NMR]->NMRSpectrum,
	Object[Data, PAGE]->OptimalLaneIntensity,
	Object[Data, Western]->MassSpectrum,
	Object[Data, TLC]->Intensity,
  Object[Data, Volume]->LiquidLevel,
	Object[Data, XRayDiffraction]->BlankedDiffractionPattern,
	Object[Data, IRSpectroscopy]->AbsorbanceSpectrum,
	Object[Data, qPCR]->QuantificationCycleAnalyses[QuantificationCycle],
  Object[Sample]->Concentration,
  Object[Simulation, MeltingTemperature]->MeltingTemperature,
  Object[Simulation, Enthalpy]->Enthalpy,
  Object[Simulation, Entropy]->Entropy,
  Object[Simulation, FreeEnergy]->FreeEnergy,
  Object[Simulation, EquilibriumConstant]->EquilibriumConstant
|>;

DefaultOutputFields=<|
  Model[Sample, StockSolution, Standard]->ReferencePeaksPositiveMode,
  Object[Analysis, CellCount]->CellCount,
  Object[Analysis, CopyNumber]->CopyNumber,
  Object[Analysis, MeltingPoint]->MeltingTemperature,
  Object[Analysis, Peaks]->Area,
  Object[Analysis, QuantificationCycle]->QuantificationCycle,
  Object[Data, AbsorbanceSpectroscopy]->AbsorbanceSpectrum,
  Object[Data, AgaroseGelElectrophoresis]->{SampleElectropherogram,MarkerElectropherogram,PostSelectionElectropherogram},
	Object[Data, Chromatography]->{Absorbance,SecondaryAbsorbance,Conductance,ConductivityFlowCellTemperature,pH,pHFlowCellTemperature,Fluorescence,SecondaryFluorescence,TertiaryFluorescence,QuaternaryFluorescence,Scattering,MultiAngleLightScattering22Degree,MultiAngleLightScattering28Degree,MultiAngleLightScattering32Degree,MultiAngleLightScattering38Degree,MultiAngleLightScattering44Degree,MultiAngleLightScattering50Degree,MultiAngleLightScattering57Degree,MultiAngleLightScattering64Degree,MultiAngleLightScattering72Degree,MultiAngleLightScattering81Degree,MultiAngleLightScattering90Degree,MultiAngleLightScattering99Degree,MultiAngleLightScattering108Degree,MultiAngleLightScattering117Degree,MultiAngleLightScattering126Degree,MultiAngleLightScattering134Degree,MultiAngleLightScattering141Degree,MultiAngleLightScattering147Degree,DynamicLightScattering,RefractiveIndex},
  Object[Data, ChromatographyMassSpectra]->{Absorbance,IonAbundance,TotalIonAbundance,MassSpectrum},
  Object[Data, DifferentialScanningCalorimetry]->HeatingCurves,
  Object[Data, ELISA]->DilutionFactors,
  Object[Data, FluorescenceIntensity]->DualEmissionIntensities,
  Object[Data, FluorescenceKinetics]->EmissionTrajectories,
  Object[Data, FluorescenceSpectroscopy]->{ExcitationSpectrum,EmissionSpectrum},
  Object[Data, LuminescenceSpectroscopy]->EmissionSpectrum,
  Object[Data, Microscope]->PhaseContrastCellCount,
  Object[Data, MassSpectrometry]->MassSpectrum,
  Object[Data, NMR]->NMRSpectrum,
  Object[Data, PAGE]->OptimalLaneIntensity,
  Object[Data, Western]->MassSpectrum,
  Object[Data, TLC]->Intensity,
  Object[Data, Volume]->Volume,
  Object[Data, XRayDiffraction]->BlankedDiffractionPattern,
  Object[Data, IRSpectroscopy]->AbsorbanceSpectrum,
  Object[Data, qPCR]->CopyNumberAnalyses[CopyNumber],
  Object[Sample]->Concentration,
  Object[Simulation, MeltingTemperature]->MeltingTemperature,
  Object[Simulation, Enthalpy]->Enthalpy,
  Object[Simulation, Entropy]->Entropy,
  Object[Simulation, FreeEnergy]->FreeEnergy,
  Object[Simulation, EquilibriumConstant]->EquilibriumConstant
|>;

DefaultFitTypes=<|
	{Object[Data,ELISA]}->LogisticBase10
|>;


(* ----------------------------------------- *)
(* --- CAPILLARY ELISA PROTOCOL OVERLOAD --- *)
(* ----------------------------------------- *)
AnalyzeStandardCurve[
	myProtocol:ObjectP[Object[Protocol,CapillaryELISA]],
	ops:OptionsPattern[AnalyzeStandardCurve]
]:=Module[
	{
		listedOptions,outputSpecification,output,gatherTests,showMessages,safeOptions,safeOptionsTests,
		templatedOptions,templateTests,combinedOptions,myData,myStandardData,
		validDataQ,validStandardDataQ,validDataTest,validStandardDataTest,processMultiplexData,providedStandardAnalytes,
		standardCurveOptions,standardCurveOptionAssociation,standardAnalyteNames,
		appendFieldHelper,matchIDHelper,selectMatchingInputs,
		standardCurveResults,analyteNames,myResults,myPreviews,myTests,
		optionsRule,testsRule,previewRule,resultRule
	},

	(* Ensure that options are in a list *)
	listedOptions=ToList[ops];

	(* Determine the requested function return value *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if a list of tests should be maintained *)
	gatherTests=MemberQ[output,Tests];
	showMessages=!gatherTests;

	(* SafeOptions ensures all options are populated and match pattern *)
	{safeOptions,safeOptionsTests}=If[gatherTests,
		SafeOptions[AnalyzeStandardCurve,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[AnalyzeStandardCurve,listedOptions,AutoCorrect->False],Null}
	];

	(* Return $Failed (and tests to this point) if specified options do not match patterns *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Options -> $Failed,
			Preview -> Null,
			Tests -> safeOptionsTests
		}]
	];

	(* Use template options to get values for options that were not specified in ops *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[AnalyzeStandardCurve,{myProtocol},listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[AnalyzeStandardCurve,{myProtocol},listedOptions],Null}
	];

	(* Return $Failed if the template object does not exist *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Options -> $Failed,
			Preview -> Null,
			Tests -> Join[safeOptionsTests,templateTests]
		}]
	];

	(* Replace any unspecified safe options with inherited options from the template *)
	combinedOptions=ReplaceRule[safeOptions,templatedOptions];

  (* Warn the user that the Protocol option will be unused if the input is of type Protocol *)
  If[MatchQ[Lookup[combinedOptions,Protocol],Except[Null]],
    Message[Warning::ProtocolAlreadySet]
  ];

	(* Obtain links to data objects in the input protocol *)
	{myData,myStandardData}=Quiet@Download[myProtocol,{Data,StandardData}];

	(* The Protocol data is invalid if the Data field is missing or empty *)
	validDataQ=!MatchQ[myData,$Failed|{}];

	(* The protocol standard data is invalid if StandardData is missing or empty *)
	validStandardDataQ=!MatchQ[myStandardData,$Failed|{}];

	(* If generating tests, check if the protocol has valid standard curve data *)
	validStandardDataTest=If[gatherTests,
		Test["Input protocol must have a non-empty field 'StandardData' containing data to fit a standard curve to.",
			validStandardDataQ,
			True
		],
		Nothing
	];

	(* If generating tests, check if the protocol has valid data to analyze *)
	validDataTest=If[gatherTests,
		Test["Input protocol must have a non-empty field 'Data' containing input data to analyze.",
			validDataQ,
			True
		],
		Nothing
	];

	(* Return an error message if protocol has invalid StandardData field *)
	If[showMessages&&!validStandardDataQ,
		Message[Error::InvalidProtocolField,"StandardData",myProtocol];
		Message[Error::InvalidInput,myProtocol]
	];

	(* Return an error message if protocol has invalid Data field *)
	If[showMessages&&validStandardDataQ&&!validDataQ,
		Message[Error::InvalidProtocolField,"Data",myProtocol];
		Message[Error::InvalidInput,myProtocol]
	];

	(* Return $Failed if the input protocol is missing either Data or StandardData fields *)
	If[!(validDataQ&&validStandardDataQ),
		Return[outputSpecification/.{
			Result -> $Failed,
			Options -> $Failed,
			Preview -> Null,
			Tests -> Join[safeOptionsTests,templateTests,validDataTest,validStandardDataTest]
		}]
	];

	(* Given a standard data object for which Field Multiplex is True, return an association linking analytes to options for AnalyzeStandardCurve calls *)
	processMultiplexData[standardObj_]:=Module[{standardAnalytes,standardCompositions,standardIntensityMap,multiplexStandardData},
		(* Get a list of analytes in the multiplex standard and their known compositions *)
		{standardAnalytes,standardCompositions}=Transpose@standardObj[StandardCompositions];

		(* Create an association mapping each standard analyte ID its corresponding intensity data *)
		standardIntensityMap=Association[First[#][ID]->Last[#]&/@standardObj[MultiplexIntensities]];

		(* Construct a paired list of standard data for each standard analyte with known composition *)
		multiplexStandardData=MapThread[
			Transpose@{Lookup[standardIntensityMap,#1],standardObj[DilutionFactors]*#2}&,
			{standardAnalytes[ID],standardCompositions}
		];

		(* Return a list of associations mapping analyte IDs to standard data options for AnalyzeStandardCurve *)
		MapThread[
			<|#1->ReplaceRule[combinedOptions,StandardData->#2]|>&,
			{standardAnalytes[ID],multiplexStandardData}
		]
	];

	(* For each standard analyte in myStandardData, generate options for a AnalyzeStandardCurve call *)
	standardCurveOptions=Flatten@Map[
		Module[{standardAnalyte,standardComposition},
			If[#[Multiplex],
				(* Multiplex Data, i.e. each StandardData object contains multiple analytes with standard data *)
				processMultiplexData[#],

				(* Singleplex Data, i.e. each StandardData object corresponds to a single standard curve. *)
				{standardAnalyte,standardComposition}=Flatten[#[StandardCompositions]];
				<|standardAnalyte[ID]->ReplaceRule[combinedOptions,{StandardData->#[Object],StandardTransformationFunctions->{None,Function[{x},(x*standardComposition)]}}]|>
			]
		]&,
		myStandardData
	];

	(* Get a list of analytes for which standard data has been found in the input protocol *)
	providedStandardAnalytes=Flatten[Keys/@standardCurveOptions];

	(* Throw a warning message if multiple sets of standard data were provided for the same analyte *)
	If[showMessages&&!DuplicateFreeQ[providedStandardAnalytes],
		Message[Warning::DuplicateStandardData, First/@Select[Tally[providedStandardAnalytes],Last[#]>1&]]
	];

	(* Join individual associations to create a lookup table mapping analytes to standard curve options *)
	standardCurveOptionAssociation=Join[Sequence@@standardCurveOptions];

	(* Obtain a list of the analyte names *)
	standardAnalyteNames=Map[Object[#][Name]&,Keys[standardCurveOptionAssociation]];

	(* Helper function converts input into {input,field} pair *)
	appendFieldHelper[field_]:=Function[{obj},{obj,field}];

	(* Creates a pure function which returns True if the input matches the supplied ID *)
	matchIDHelper[matchID_]:=Function[{obj},MatchQ[obj[Analyte][ID],matchID]];

	(* Given an input ID corresponding to a standard analyte, select all inputs and fields which correspond to that analyte *)
	selectMatchingInputs[inputData_,standardID_]:=Module[
		{singleplexData,multiplexData,processedSingleplex,multiplexAnalyteIDs,multiplexIndices,multiplexFields,processedMultiplex},
		(* Split inputData into single and multiplex data *)
		multiplexData=Select[inputData,#[Multiplex]&];
		singleplexData=Select[inputData,!#[Multiplex]&];

		(* Select each singleplex dataset with an analyte that matches standardID *)
		processedSingleplex=Map[
			If[(matchIDHelper[standardID])[#],
				appendFieldHelper[Automatic][#],
				Nothing
			]&,
			singleplexData
		];

		(* For each multiplex input, get the ID number of the analyte in each channel *)
		multiplexAnalyteIDs=Download[multiplexData, MultiplexAnalytes[ID]];

		(* For each multiplex input, get the index in multiplexIntensities corresponding to data which matches standardID analyte *)
		multiplexIndices=Flatten@Position[#,standardID]&/@multiplexAnalyteIDs;

		(* Generate a field specification for each of these matched indices *)
		multiplexFields=Field[ MultiplexIntensities[[#,-1]] ]&/@(First/@multiplexIndices);

		(* Generate AnalyzeStandardCurve inputs for each multiplex input matching the standard data *)
		processedMultiplex=MapThread[
			First@Download[#2, MultiplexIntensities][[#1,-1]]&,
			{multiplexIndices,multiplexData}
		];

		(* Join singleplex and multiplex datasets *)
		Join[processedSingleplex,processedMultiplex]
	];

	(* Map over the input data, grouping the input data sets by analyte type and matching to the corresponding standard curve *)
	standardCurveResults=KeyValueMap[
		If[gatherTests,
			(* Gathering Tests *)
			AnalyzeStandardCurve[
				selectMatchingInputs[myData,#1],
				ReplaceRule[#2,{Output->{Result,Tests},Protocol->myProtocol[Object]}]
			],

			(* Not gathering tests *)
			{AnalyzeStandardCurve[
				selectMatchingInputs[myData,#1],
				ReplaceRule[#2,{Output->Result,Protocol->myProtocol[Object]}]
			],Null}
		]&,
		standardCurveOptionAssociation
	];

	(* Collect results, previews, and tests from individual calls. Do not collect options, because we want options for the protocol ASC call. *)
	{myResults,myTests}=Transpose[standardCurveResults];

	(* TODO: Update Data objects (Multiplex pre-generates concentrations; throw a warning if predicted values deviate by a lot) *)

	(* Prepare the Options result if we were asked to do so *)
	optionsRule=Options->If[MemberQ[output,Options],
		combinedOptions,
		Null
	];

	(* Prepare the Preview result if we were asked to do so *)
	previewRule=Preview->If[MemberQ[output,Preview],
		SlideView@MapThread[
			Zoomable[PlotStandardCurve[#1,PlotLabel->#2]]&,
			{myResults,standardAnalyteNames}
		],
		Null
	];

	(* Prepare the Tests result if we were asked to do so *)
	testsRule=Tests->If[MemberQ[output,Tests],
		Flatten@{
			myTests,validDataTest,validStandardDataTest
		},
		Null
	];

	(* Prepare standard output. Upload to Constellation if Option Upload\[Rule]True *)
	resultRule=Result->If[MemberQ[output,Result],
		myResults,
		Null
	];

	(* Return the specified outputs *)
	outputSpecification/.{previewRule,optionsRule,testsRule,resultRule}
];

(* -------------------------------------------------------------------- *)
(* --- OVERLOAD FOR Object[Analysis, StandardCurve] AS STANDARDDATA --- *)
(* -------------------------------------------------------------------- *)
AnalyzeStandardCurve[
	myInputs_,
	myStandardData:ObjectP[Object[Analysis, StandardCurve]],
	ops:OptionsPattern[AnalyzeStandardCurve]
]:=Module[{listedOptions,outputSpecification,standardCurveFitObj, output,gatherTests,optionUpdates},

	(* Ensure that options are in a list *)
	listedOptions=ToList[ops];

	(* Determine the requested function return value *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if a list of tests should be maintained *)
	gatherTests=MemberQ[output,Tests];

	(* Warn the user if StandardData has already been specified *)
	If[KeyExistsQ[listedOptions,StandardData]&&(!gatherTests),Message[Warning::StandardFieldOverride,"Standard Data"]];

	standardCurveFitObj = Download[myStandardData, StandardCurveFit];

	(* Update options, keeping the existing StandardData option if it was specified *)
	optionUpdates=ReplaceRule[{StandardData->myStandardData},listedOptions,Append->True];

	(* Call the primary function body *)
	AnalyzeStandardCurve[myInputs,Sequence@@optionUpdates]
];






(* ---------------------------- *)
(* --- OVERLOADS FOR INPUTS --- *)
(* ---------------------------- *)

(* Input is a single numeric and StandardData is an option *)
AnalyzeStandardCurve[
  singleNumericInput:(UnitsP[]|DistributionP[]),
  ops:OptionsPattern[AnalyzeStandardCurve]
]:=AnalyzeStandardCurve[{singleNumericInput},ops];

(* Input is a single object and StandardData is an option *)
AnalyzeStandardCurve[
  singleObjInput:ObjectP[],
  ops:OptionsPattern[AnalyzeStandardCurve]
]:=AnalyzeStandardCurve[{singleObjInput},ops];

(* Input is a list of objects or list of list of objects and StandardData is an option *)
AnalyzeStandardCurve[
  listedObjectInput:{ListableP[ObjectP[Object[]]]..},
  ops:OptionsPattern[AnalyzeStandardCurve]
]:=AnalyzeStandardCurve[{#,Automatic}&/@listedObjectInput,ops];

(* StandardData is specified at input *)
AnalyzeStandardCurve[
  myInputs_,
  myStandardData:analyzeStandardCurveStandardDataP,
  ops:OptionsPattern[AnalyzeStandardCurve]
]:=Module[{listedOptions,outputSpecification,output,gatherTests,optionUpdates},

  (* Ensure that options are in a list *)
  listedOptions=ToList[ops];

  (* Determine the requested function return value *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if a list of tests should be maintained *)
	gatherTests=MemberQ[output,Tests];

  (* Warn the user if StandardData has already been specified *)
  If[KeyExistsQ[listedOptions,StandardData]&&(!gatherTests),Message[Warning::StandardFieldOverride,"Standard Data"]];

  (* Update options, keeping the existing StandardData option if it was specified *)
  optionUpdates=ReplaceRule[{StandardData->myStandardData},listedOptions,Append->True];

  (* Call the primary function body *)
  AnalyzeStandardCurve[myInputs,Sequence@@optionUpdates]
];

(* StandardData is specified along with fields at input *)
AnalyzeStandardCurve[
  myInputs_,
  myStandardDataWithFields:{analyzeStandardCurveStandardDataP,{None|nestedFieldP, None|nestedFieldP}},
  ops:OptionsPattern[AnalyzeStandardCurve]
]:=Module[{listedOptions,outputSpecification,output,gatherTests,myData,myFields,optionUpdates},

  (* Ensure that options are in a list *)
  listedOptions=ToList[ops];

  (* Determine the requested function return value *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if a list of tests should be maintained *)
	gatherTests=MemberQ[output,Tests];

  (* Warn the user if StandardData has already been specified *)
  If[KeyExistsQ[listedOptions,StandardData]&&(!gatherTests),Message[Warning::StandardFieldOverride,"Standard data"]];

  (* Warn the user if StandardFields have already been specified *)
  If[KeyExistsQ[listedOptions,StandardFields]&&(!gatherTests),Message[Warning::StandardFieldOverride,"Standard fields"]];

  (* The standard data input is a {data,field} tuple *)
  {myData,myFields}=myStandardDataWithFields;

  (* Update options, keeping the existing StandardData option if it was specified *)
  optionUpdates=ReplaceRule[{StandardData->myData,StandardFields->myFields},listedOptions,Append->True];

  (* Call the primary function body *)
  AnalyzeStandardCurve[myInputs,Sequence@@optionUpdates]
];


(* -------------------------- *)
(* --- MAIN FUNCTION BODY --- *)
(* -------------------------- *)
AnalyzeStandardCurve[
	ops:OptionsPattern[AnalyzeStandardCurve]
]:=Module[
	{
		listedInputs,listedOptions,outputSpecification,output,gatherTests,safeOptions,safeOptionsTests,
		inputsForValidLengths,validLengths,validLengthTests,templatedOptions,templateTests,combinedOptions,
		resolvedOptionsResult,resolvedInputs,resolvedStandardData,resolvedOptions,resolvedOptionsTests,existingFitQ,
		standardCurveFitPacket,standardCurveUnits,standardXUnitlessQ,standardYUnitlessQ,standardXData,standardYData,safeMean,
		standardXMinMax,standardYMinMax,inputMinMaxes,safeGreater,safeLess,inputExtrapolationQList,applyStandard,applyInverseStandard,outputValues,
		sharedFieldsWithFit,sharedMultipleFields,sharedFieldValues,formattedSharedFields,sharedFieldsPacket,
		standardCurveFitObject,analysisPacket,joinedAnalysisPacket,resolutionPacket,finalPacket,
		previewRule,optionsRule,testsRule,resultRule
	},

	(* Determine the requested function return value *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if a list of tests should be maintained *)
	gatherTests=MemberQ[output,Tests];

	(* Ensure that options are in a list *)
	listedOptions=ToList[ops];

	(* Use a number as inputData *)
	listedInputs={{0.017}};

	(* Check for temporal links, warning the user if any were detected in inputs and options. *)
	checkTemporalLinks[listedInputs,listedOptions];

	(* SafeOptions ensures all options are populated and match pattern *)
	{safeOptions,safeOptionsTests}=If[gatherTests,
		SafeOptions[AnalyzeStandardCurve,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[AnalyzeStandardCurve,listedOptions,AutoCorrect->False],Null}
	];

	(* Return $Failed (and tests to this point) if specified options do not match patterns *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Options -> $Failed,
			Preview -> Null,
			Tests -> safeOptionsTests
		}]
	];

	(* Append the StandardData option to match the definition of AnalyzeStandardCurves from DefineUsage *)
	inputsForValidLengths={listedInputs,Lookup[safeOptions,StandardData]};

	(* Verify that index-matched inputs are the correct length. *)
	{validLengths, validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[AnalyzeStandardCurve,inputsForValidLengths,safeOptions,Output->{Result,Tests}],
		{ValidInputLengthsQ[AnalyzeStandardCurve,inputsForValidLengths,safeOptions],Null}
	];


	(* If index-matched options are not matched to inputs, return $Failed. Return tests up to this point. *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Options -> $Failed,
			Preview -> Null,
			Tests -> Join[safeOptionsTests, validLengthTests]
		}]
	];

	(* Use template options to get values for options that were not specified in ops *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[AnalyzeStandardCurve,inputsForValidLengths,listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[AnalyzeStandardCurve,inputsForValidLengths,listedOptions],Null}
	];

	(* Return $Failed if the template object does not exist *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Options -> $Failed,
			Preview -> Null,
			Tests -> Join[safeOptionsTests, validLengthTests, templateTests]
		}]
	];

	(* Replace any unspecified safe options with inherited options from the template *)
	combinedOptions=ReplaceRule[safeOptions,templatedOptions];

	(* Obtain resolved inputs, resolved options, and resolved option tests *)
	resolvedOptionsResult=If[gatherTests,
		(* If gathering tests, messages are silenced. *)
		{
			{resolvedInputs,resolvedStandardData,resolutionPacket,standardCurveFitPacket,resolvedOptions},
			resolvedOptionsTests
		}=resolveAnalyzeStandardCurveOptions[listedInputs,combinedOptions,Output->{Result,Tests}];

		(* Must run tests to see if a failure has been encountered *)
		If[RunUnitTest[<|"resolvedOptionsTests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* Not gathering tests - check for Error::InvalidInput and Error::InvalidOption *)
		Check[
			{
				{resolvedInputs,resolvedStandardData,resolutionPacket,standardCurveFitPacket,resolvedOptions},
				resolvedOptionsTests
			}={resolveAnalyzeStandardCurveOptions[listedInputs,combinedOptions,Output->Result],Null};,
			$Failed,
			{Error::InvalidInput,Error::InvalidOption,Error::AnalyzeFit}
		]
	];

	(* Return early if options resolution failed *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Options->resolvedOptions,
			Preview->Null,
			Tests->Join[safeOptionsTests,validLengthTests,templateTests,resolvedOptionsTests]
		}]
	];

	(* True if standard data was provided as a Fit object *)
	existingFitQ=MatchQ[resolvedStandardData,ObjectP[Object[Analysis,Fit]]];

	(* Units of standard curve object *)
	standardCurveUnits=Lookup[stripAppendReplaceKeyHeads[standardCurveFitPacket],DataUnits];

	(* True if the standard curve has a unitless independent variable *)
	{standardXUnitlessQ,standardYUnitlessQ}=MatchQ[#,1]&/@standardCurveUnits;

	(* Get the independent values of the standard curve data *)
	{standardXData,standardYData}=Transpose@Lookup[standardCurveFitPacket,DataPoints];

	(* Define a safeMean helper to process distributions *)
	safeMean[x:DistributionP[]]:=Mean[x];
	safeMean[x_]:=x;

	(* Minimum and maximum values of the independent variable in standard curve data *)
	standardXMinMax=MinMax[safeMean/@standardXData];

	(* Minimum and maximum values of the independent variable in standard curve data *)
	standardYMinMax=MinMax[safeMean/@standardYData];

	(* Minimum and maximum values of the independent variable in each input data set *)
	inputMinMaxes=Map[
		MinMax[safeMean/@#]&,
		resolvedInputs
	];

	(* Safe comparisons in case units of arguments don't match *)
	safeGreater[x_,y_]:=If[CompatibleUnitQ[x,y],
		x>y,
		safeQuantityMagnitude[x]>safeQuantityMagnitude[y]
	];
	safeLess[x_,y_]:=If[CompatibleUnitQ[x,y],
		x<y,
		safeQuantityMagnitude[x]<safeQuantityMagnitude[y]
	];

	(* List of booleans matching the length of inputs, True if the corresponding input contains values outside of the standard curve domain *)
	inputExtrapolationQList=If[Lookup[resolvedOptions,InversePrediction],
		Map[
			safeLess[First[#],First[standardYMinMax]]||safeGreater[Last[#],Last[standardYMinMax]]&,
			inputMinMaxes
		],
		Map[
			safeLess[First[#],First[standardXMinMax]]||safeGreater[Last[#],Last[standardXMinMax]]&,
			inputMinMaxes
		]
	];

	(* Warn the user if extrapolation is occurring *)
(*	If[ContainsAny[inputExtrapolationQList,{True}],*)
(*		Message[Warning::Extrapolation,Flatten@Position[inputExtrapolationQList,True]]*)
(*	];*)

	(* Helper applies standard curve to data, and ignores input units if the standard curve is unitless. *)
	applyStandard[xlist_]:=If[standardXUnitlessQ&&!MatchQ[Lookup[resolutionPacket,InputDataUnits],1],
		(* Standard curve is unitless but data has units *)
		SinglePrediction[standardCurveFitPacket,safeQuantityMagnitude[#]]&/@xlist,

		(* Units are compatible*)
		SinglePrediction[standardCurveFitPacket,#]&/@xlist
	];

	(* Helper applies the inverse standard curve to data using InversePrediction, and ignores input units if the standard curve is unitless. *)
	applyInverseStandard[xlist_]:=If[standardYUnitlessQ&&!MatchQ[Lookup[resolutionPacket,InputDataUnits],1],
		(* Standard curve is unitless but data has units *)
		InversePrediction[standardCurveFitPacket,safeQuantityMagnitude[#]]&/@xlist,

		(* Units are compatible*)
		InversePrediction[standardCurveFitPacket,#]&/@xlist
	];

	(* Use the pure function form of the Fit object to transform input data *)
	outputValues=If[Lookup[resolvedOptions,InversePrediction],
		applyInverseStandard/@resolvedInputs,
		applyStandard/@resolvedInputs
	];

	(*** Construct the Analysis object packet ***)

	(* List of fields that are shared with the Fit Analysis object which represents the standard curve *)
	sharedFieldsWithFit={
		SymbolicExpression,ExpressionType,BestFitFunction,BestFitExpression,
		BestFitParameters,BestFitParametersDistribution,MarginalBestFitDistribution,BestFitVariables,
		ANOVATable,ANOVAOfModel,ANOVAOfError,ANOVAOfTotal,FStatistic,FCritical,FTestPValue,
		RSquared,AdjustedRSquared,AIC,AICc,BIC,EstimatedVariance,SumSquaredError,StandardDeviation
	};

	(* Subset of shared fields which are multiples *)
	sharedMultipleFields={
		BestFitParameters,MarginalBestFitDistribution,BestFitVariables,ANOVAOfModel,ANOVAOfError,ANOVAOfTotal
	};

	(* Grab the values from the standardCurveFitPacket *)
	sharedFieldValues=KeyTake[standardCurveFitPacket,Join[sharedFieldsWithFit,Replace[#]&/@sharedFieldsWithFit]];

	(* If we downloaded the Fit packet, format it to account for multiple fields (e.g. with Replace[] or Append[] syntax) *)
	formattedSharedFields=If[MatchQ[resolvedStandardData,ObjectP[Object[Analysis,Fit]]],
		Normal[sharedFieldValues]/.(key_/;MemberQ[sharedMultipleFields,key]->Replace[key]),
		Null
	];

	(* Convert back into an association if we formatted a downloaded packet *)
	sharedFieldsPacket=If[!MatchQ[formattedSharedFields,Null],
		Association[formattedSharedFields],
		sharedFieldValues
	];

	(* Upload the Fit object if Upload->True and Result was requested *)
	standardCurveFitObject=If[Lookup[resolvedOptions,Upload]&&MemberQ[output,Result]&&!existingFitQ,
		Upload[standardCurveFitPacket],
		Null
	];

	(* Construct the packet for the StandardCurve Analysis object *)
	analysisPacket=<|
		Type->Object[Analysis,StandardCurve],
		Author->Link[$PersonID],
		UnresolvedOptions->listedOptions,
		ResolvedOptions->resolvedOptions,
		Protocol->Link[Lookup[resolvedOptions,Protocol]],
		InversePrediction->Lookup[resolvedOptions,InversePrediction],
		ReferenceStandardCurve->Null,
		Replace[PredictedValues]->If[Length[outputValues]==1,First[outputValues],outputValues],
		Replace[StandardDataUnits]->If[existingFitQ,
			Lookup[standardCurveFitPacket,DataUnits],
			Lookup[standardCurveFitPacket,Replace[DataUnits]]
		],
		Replace[StandardCurveDomain]->standardXMinMax,
		Replace[StandardCurveRange]->standardYMinMax,
		Replace[StandardDataPoints]->Lookup[standardCurveFitPacket,DataPoints],
		StandardCurveFit->If[Lookup[resolvedOptions,Upload],
			Link[standardCurveFitObject],
			Null
		]
	|>;

	(* Add shared fields to the analysis Packet *)
	joinedAnalysisPacket=Join[resolutionPacket,analysisPacket,sharedFieldsPacket];

	finalPacket = Join[joinedAnalysisPacket,
		<|
			Replace[InputData]->Null,
			Replace[PredictedValues]->Null,
			Replace[InputDataPoints]->Null,
			InputDataUnits->Null
		|>
	];
	(*** Generate rules covering for each possible output value ***)

	(* Prepare the Options result if we were asked to do so *)
	optionsRule=Options->If[MemberQ[output,Options],
		resolvedOptions,
		Null
	];

	(* Prepare the Preview result if we were asked to do so *)
	previewRule=Preview->If[MemberQ[output,Preview],
		PlotStandardCurve[joinedAnalysisPacket],
		Null
	];

	(* Prepare the Tests result if we were asked to do so *)
	testsRule=Tests->If[MemberQ[output,Tests],
		Join[safeOptionsTests,validLengthTests,templateTests,resolvedOptionsTests],
		Null
	];

	(* Prepare standard output. Upload to Constellation if Option Upload\[Rule]True *)
	resultRule=Result->If[MemberQ[output,Result],
		If[Lookup[resolvedOptions,Upload],
			Upload[finalPacket],
			finalPacket
		],
		Null
	];

	(* Return the specified outputs *)
	outputSpecification/.{previewRule,optionsRule,testsRule,resultRule}
];

AnalyzeStandardCurve[
	myInputs___,
	ops:OptionsPattern[AnalyzeStandardCurve]
]:=Module[
  {
    listedInputs,listedOptions,outputSpecification,output,gatherTests,safeOptions,safeOptionsTests,
    inputsForValidLengths,validLengths,validLengthTests,templatedOptions,templateTests,combinedOptions,
    resolvedOptionsResult,resolvedInputs,resolvedStandardData,resolvedOptions,resolvedOptionsTests,existingFitQ,
    standardCurveFitPacket,standardCurveUnits,standardXUnitlessQ,standardYUnitlessQ,standardXData,standardYData,safeMean,
    standardXMinMax,standardYMinMax,inputMinMaxes,safeGreater,safeLess,inputExtrapolationQList,applyStandard,applyInverseStandard,outputValues,
    sharedFieldsWithFit,sharedMultipleFields,sharedFieldValues,formattedSharedFields,sharedFieldsPacket,
    standardCurveFitObject,analysisPacket,joinedAnalysisPacket,resolutionPacket,finalPacket,
    previewRule,optionsRule,testsRule,resultRule, optionUpdates, checkStandardData, checkTemplate
  },

	(* Determine the requested function return value *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if a list of tests should be maintained *)
	gatherTests=MemberQ[output,Tests];

	(* Ensure that options are in a list *)
	listedOptions=ToList[ops];

	(* Since a single input can be a list, converting inputs to a list requires pattern matching. *)
	listedInputs=If[MatchQ[myInputs,analyzeStandardCurveSingleInputP],
		{myInputs},
		myInputs
	];

	(* Check for temporal links, warning the user if any were detected in inputs and options. *)
	checkTemporalLinks[listedInputs,listedOptions];

	(* SafeOptions ensures all options are populated and match pattern *)
	{safeOptions,safeOptionsTests}=If[gatherTests,
		SafeOptions[AnalyzeStandardCurve,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[AnalyzeStandardCurve,listedOptions,AutoCorrect->False],Null}
	];

	(* Return $Failed (and tests to this point) if specified options do not match patterns *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Options -> $Failed,
			Preview -> Null,
			Tests -> safeOptionsTests
		}]
	];

{checkStandardData, checkTemplate} = Lookup[safeOptions, {StandardData, Template}];

	(* Treat myInputs as StandardData*)
If[MatchQ[checkStandardData, Automatic]&&MatchQ[checkTemplate, Null]&&!MatchQ[checkStandardData,ObjectP[Object[Analysis, StandardCurve]]],
	optionUpdates=ReplaceRule[{StandardData->myInputs},listedOptions,Append->True];
	Return[AnalyzeStandardCurve[Sequence@@optionUpdates]]
];

  (* Append the StandardData option to match the definition of AnalyzeStandardCurves from DefineUsage *)
  inputsForValidLengths={listedInputs,Lookup[safeOptions,StandardData]};

	(* Verify that index-matched inputs are the correct length. *)
	{validLengths, validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[AnalyzeStandardCurve,inputsForValidLengths,safeOptions,Output->{Result,Tests}],
		{ValidInputLengthsQ[AnalyzeStandardCurve,inputsForValidLengths,safeOptions],Null}
	];

	(* If index-matched options are not matched to inputs, return $Failed. Return tests up to this point. *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Options -> $Failed,
			Preview -> Null,
			Tests -> Join[safeOptionsTests, validLengthTests]
		}]
	];

	(* Use template options to get values for options that were not specified in ops *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[AnalyzeStandardCurve,inputsForValidLengths,listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[AnalyzeStandardCurve,inputsForValidLengths,listedOptions],Null}
	];

	(* Return $Failed if the template object does not exist *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Options -> $Failed,
			Preview -> Null,
			Tests -> Join[safeOptionsTests, validLengthTests, templateTests]
		}]
	];

	(* Replace any unspecified safe options with inherited options from the template *)
	combinedOptions=ReplaceRule[safeOptions,templatedOptions];

	(* Obtain resolved inputs, resolved options, and resolved option tests *)
	resolvedOptionsResult=If[gatherTests,
		(* If gathering tests, messages are silenced. *)
		{
      {resolvedInputs,resolvedStandardData,resolutionPacket,standardCurveFitPacket,resolvedOptions},
      resolvedOptionsTests
    }=resolveAnalyzeStandardCurveOptions[listedInputs,combinedOptions,Output->{Result,Tests}];

		(* Must run tests to see if a failure has been encountered *)
		If[RunUnitTest[<|"resolvedOptionsTests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
      {resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* Not gathering tests - check for Error::InvalidInput and Error::InvalidOption *)
		Check[
			{
        {resolvedInputs,resolvedStandardData,resolutionPacket,standardCurveFitPacket,resolvedOptions},
        resolvedOptionsTests
      }={resolveAnalyzeStandardCurveOptions[listedInputs,combinedOptions,Output->Result],Null};,
			$Failed,
			{Error::InvalidInput,Error::InvalidOption,Error::AnalyzeFit,Error::ExistingReferenceStandardCurve,Error::InvalidStandardCurveFitField}
		]
	];

	(* Return early if options resolution failed *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Options->resolvedOptions,
			Preview->Null,
			Tests->Join[safeOptionsTests,validLengthTests,templateTests,resolvedOptionsTests]
		}]
	];

	(* True if standard data was provided as a Fit object *)
	existingFitQ=MatchQ[resolvedStandardData,ObjectP[Object[Analysis,Fit]]];

	(* Units of standard curve object *)
	standardCurveUnits=Lookup[stripAppendReplaceKeyHeads[standardCurveFitPacket],DataUnits];

	(* True if the standard curve has a unitless independent variable *)
	{standardXUnitlessQ,standardYUnitlessQ}=MatchQ[#,1]&/@standardCurveUnits;

  (* Get the independent values of the standard curve data *)
  {standardXData,standardYData}=Transpose@Lookup[standardCurveFitPacket,DataPoints];

  (* Define a safeMean helper to process distributions *)
	safeMean[x:DistributionP[]]:=Mean[x];
	safeMean[x_]:=x;

  (* Minimum and maximum values of the independent variable in standard curve data *)
  standardXMinMax=MinMax[safeMean/@standardXData];

  (* Minimum and maximum values of the independent variable in standard curve data *)
  standardYMinMax=MinMax[safeMean/@standardYData];

  (* Minimum and maximum values of the independent variable in each input data set *)
  inputMinMaxes=Map[
    MinMax[safeMean/@#]&,
    resolvedInputs
  ];

  (* Safe comparisons in case units of arguments don't match *)
  safeGreater[x_,y_]:=If[CompatibleUnitQ[x,y],
    x>y,
    safeQuantityMagnitude[x]>safeQuantityMagnitude[y]
  ];
  safeLess[x_,y_]:=If[CompatibleUnitQ[x,y],
    x<y,
    safeQuantityMagnitude[x]<safeQuantityMagnitude[y]
  ];

  (* List of booleans matching the length of inputs, True if the corresponding input contains values outside of the standard curve domain *)
  inputExtrapolationQList=If[Lookup[resolvedOptions,InversePrediction],
    Map[
      safeLess[First[#],First[standardYMinMax]]||safeGreater[Last[#],Last[standardYMinMax]]&,
      inputMinMaxes
    ],
    Map[
      safeLess[First[#],First[standardXMinMax]]||safeGreater[Last[#],Last[standardXMinMax]]&,
      inputMinMaxes
    ]
  ];

  (* Warn the user if extrapolation is occurring *)
  If[ContainsAny[inputExtrapolationQList,{True}&&myInputs=!={{0.017}}],
    Message[Warning::Extrapolation,Flatten@Position[inputExtrapolationQList,True]]
  ];

	(* Helper applies standard curve to data, and ignores input units if the standard curve is unitless. *)
	applyStandard[xlist_]:=If[standardXUnitlessQ&&!MatchQ[Lookup[resolutionPacket,InputDataUnits],1],
		(* Standard curve is unitless but data has units *)
    SinglePrediction[standardCurveFitPacket,safeQuantityMagnitude[#]]&/@xlist,

		(* Units are compatible*)
    SinglePrediction[standardCurveFitPacket,#]&/@xlist
	];

  (* Helper applies the inverse standard curve to data using InversePrediction, and ignores input units if the standard curve is unitless. *)
  applyInverseStandard[xlist_]:=If[standardYUnitlessQ&&!MatchQ[Lookup[resolutionPacket,InputDataUnits],1],
    (* Standard curve is unitless but data has units *)
    InversePrediction[standardCurveFitPacket,safeQuantityMagnitude[#]]&/@xlist,

    (* Units are compatible*)
    InversePrediction[standardCurveFitPacket,#]&/@xlist
  ];

	(* Use the pure function form of the Fit object to transform input data *)
	outputValues=If[Lookup[resolvedOptions,InversePrediction],
    applyInverseStandard/@resolvedInputs,
    applyStandard/@resolvedInputs
  ];

	(*** Construct the Analysis object packet ***)

	(* List of fields that are shared with the Fit Analysis object which represents the standard curve *)
	sharedFieldsWithFit={
		SymbolicExpression,ExpressionType,BestFitFunction,BestFitExpression,
		BestFitParameters,BestFitParametersDistribution,MarginalBestFitDistribution,BestFitVariables,
		ANOVATable,ANOVAOfModel,ANOVAOfError,ANOVAOfTotal,FStatistic,FCritical,FTestPValue,
		RSquared,AdjustedRSquared,AIC,AICc,BIC,EstimatedVariance,SumSquaredError,StandardDeviation
	};

	(* Subset of shared fields which are multiples *)
	sharedMultipleFields={
		BestFitParameters,MarginalBestFitDistribution,BestFitVariables,ANOVAOfModel,ANOVAOfError,ANOVAOfTotal
	};

	(* Grab the values from the standardCurveFitPacket *)
	sharedFieldValues=KeyTake[standardCurveFitPacket,Join[sharedFieldsWithFit,Replace[#]&/@sharedFieldsWithFit]];

	(* If we downloaded the Fit packet, format it to account for multiple fields (e.g. with Replace[] or Append[] syntax) *)
	formattedSharedFields=If[MatchQ[resolvedStandardData,ObjectP[Object[Analysis,Fit]]],
		Normal[sharedFieldValues]/.(key_/;MemberQ[sharedMultipleFields,key]->Replace[key]),
		Null
	];

	(* Convert back into an association if we formatted a downloaded packet *)
	sharedFieldsPacket=If[!MatchQ[formattedSharedFields,Null],
		Association[formattedSharedFields],
		sharedFieldValues
	];

	(* Upload the Fit object if Upload->True and Result was requested *)
	standardCurveFitObject=If[Lookup[resolvedOptions,Upload]&&MemberQ[output,Result]&&!existingFitQ,
		Upload[standardCurveFitPacket],
		Null
	];

	(* Construct the packet for the StandardCurve Analysis object *)
	analysisPacket=<|
		Type->Object[Analysis,StandardCurve],
    Author->Link[$PersonID],
		UnresolvedOptions->listedOptions,
		ResolvedOptions->resolvedOptions,
    Protocol->Link[Lookup[resolvedOptions,Protocol]],
    InversePrediction->Lookup[resolvedOptions,InversePrediction],
		Replace[PredictedValues]->If[Length[outputValues]==1,First[outputValues],outputValues],
		Replace[StandardDataUnits]->If[existingFitQ,
			Lookup[standardCurveFitPacket,DataUnits],
			Lookup[standardCurveFitPacket,Replace[DataUnits]]
		],
    Replace[StandardCurveDomain]->standardXMinMax,
    Replace[StandardCurveRange]->standardYMinMax,
		Replace[StandardDataPoints]->Lookup[standardCurveFitPacket,DataPoints],
		StandardCurveFit->If[existingFitQ,
			Link[resolvedStandardData],
			If[Lookup[resolvedOptions,Upload], Link[standardCurveFitObject], Null]
			]
	|>;

	(* Add shared fields to the analysis Packet *)
	joinedAnalysisPacket=Join[resolutionPacket,analysisPacket,sharedFieldsPacket];

	(*If StandardData is Object[Analysis, StandCurve], add reference link to it in the field ReferenceStandardCurve*)
	finalPacket = If[MatchQ[Lookup[safeOptions, StandardData], ObjectP[Object[Analysis, StandardCurve]]],
		Join[joinedAnalysisPacket,
			<|
				ReferenceStandardCurve->Link[Lookup[safeOptions, StandardData]]
			|>
		],
		joinedAnalysisPacket
	];

	(*** Generate rules covering for each possible output value ***)

	(* Prepare the Options result if we were asked to do so *)
	optionsRule=Options->If[MemberQ[output,Options],
		resolvedOptions,
		Null
	];

	(* Prepare the Preview result if we were asked to do so *)
	previewRule=Preview->If[MemberQ[output,Preview],
		PlotStandardCurve[finalPacket],
		Null
	];

	(* Prepare the Tests result if we were asked to do so *)
	testsRule=Tests->If[MemberQ[output,Tests],
		Join[safeOptionsTests,validLengthTests,templateTests,resolvedOptionsTests],
		Null
	];

	(* Prepare standard output. Upload to Constellation if Option Upload\[Rule]True *)
	resultRule=Result->If[MemberQ[output,Result],
		If[Lookup[resolvedOptions,Upload],
			Upload[finalPacket],
			finalPacket
		],
		Null
	];

	(* Return the specified outputs *)
	outputSpecification/.{previewRule,optionsRule,testsRule,resultRule}
];


(* ::Subsubsection:: *)
(*resolveAnalyzeStandardCurveInputs*)


DefineOptions[resolveAnalyzeStandardCurveOptions,
	Options:>{
		CacheOption,
		HelperOutputOption
	}
];


resolveAnalyzeStandardCurveOptions[
	myInputs:ListableP[analyzeStandardCurveSingleInputP],
	myOptions:{_Rule..},
	myResolutionOptions:OptionsPattern[resolveAnalyzeStandardCurveOptions]
]:=Module[
	{
		outputSpecification,output,gatherTests,showMessages,inputsForValidLengths,expandedOptions,inverseQ,applyTransform,
		consistentUnitsEachQ,allInputUnits,uniqueUnits,consistentUnitsAllQ,safeUnits,safeQuantityMagnitude,safeUnitConvert,
		validUnitsEachTest,validUnitsAllTest,inputUnitType,myInputFieldInputs,myInputFieldOptions,inputFieldOverrideQList,inputFieldOverrideIndices,
		defaultAutomaticInputFieldQ,invalidInputFieldIndices,automaticInputFieldTest,deList,
		validTransformedInputDataQ,invalidTransformedInputIndices,validTransformedInputTest,
		myInputTypes,inputDataTypeChecks,uniqueInputTypes,inconsistentInputIndices,consistentInputTypesTest,
		resolvedInputFields,resolvedInputs,numericalInputData,inputTransformationFunctions,transformedInputData,
		existingFitQ,existingFitUnitsTest,existingFitUnits,existingFitInputUnits,existingFitCompatibleUnitsQ,
		myStandardData,getTypeHelper,standardXTypes,standardYTypes,uniqueStandardXTypes,uniqueStandardYTypes,consistentStandardTypeTest,
		standardDataType,lookupField,xValueField,yValueField,standardXUnit,standardYUnit,
		consistentStandardXUnitQ,consistentStandardYUnitQ,consistentStandardUnitsQ,consistentStandardUnitsTest,compatibleStandardUnitsTest,
		automaticStandardFieldXTest,automaticStandardFieldYTest,standardXObjectQ,standardYObjectQ,automaticStandardFieldsQ,
		emptyStandardFieldQ,invalidStandardFieldQ,validTransformedStandardDataQ,validStandardDataQ,
		emptyFieldTest,invalidFieldTest,validStandardDataTest,standardInputUnits,compatibleStandardUnitsQ,
		safeTranspose,mixedDataDownload,numericalStandardData,standardXTransform,standardYTransform,transformedStandardData,resolvedStandardData,
		fitTypeAutomaticQ,defaultFitExistsQ,resolvedFitType,convertNoneToIdentity,transformX,transformY,
		inputPacketList,standardXPacketList,standardYPacketList,quietCollectRes,quietCollectInput,quietCollectMessages,
    analyzeFitResolvedOptions,fitPacket,resolutionPacket,
		testsRule,resultRule,resolvedOptions,collapsedOptions,joinedResolvedOptions,analyzeFitSuceededTest,
		objectAnalysisStandardCurveQ,currentReferenceSC,currentSCF
	},

	(* Determine the requested return value for the option resolver *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	showMessages=!gatherTests;

  (* Append the StandardData option to inputs to match the DefineUsage format *)
  inputsForValidLengths={myInputs,Lookup[myOptions,StandardData]};

	(* Expand singleton index-matched options, e.g., A \[Rule] {A,A,..} *)
	expandedOptions=Quiet[Last[ExpandIndexMatchedInputs[AnalyzeStandardCurve,inputsForValidLengths,myOptions]]];

  (* True if InversePrediction should be used to map y-to-x instead of x-to-y using the standard curve *)
  inverseQ=Lookup[expandedOptions,InversePrediction];

	(*** Input Resolution ***)

	(* Searches for type in table, returning None if type is none or not found *)
	lookupField[table_Association,type:None|TypeP[]]:=If[KeyExistsQ[table,type],
		Lookup[table,type],
		None
	];

	(* If input was an object or list of objects, take the user-specified field *)
	myInputFieldInputs=Map[
		If[MatchQ[First[#],ListableP[ObjectP[]]],
			Last[#],
			None
		]&,
		myInputs
	];

	(* User supplied InputFields options, which are index matched against inputs *)
	myInputFieldOptions=Lookup[expandedOptions,InputField];

	(* If input is object, get its type, otherwise return None *)
	getTypeHelper=If[MatchQ[#,ObjectP[]],#[Type],None]&;

	(* For each input, if the input is a list of objects check that each object is the same type *)
	inputDataTypeChecks=If[MatchQ[First[#],{ObjectP[]..}],
		Map[getTypeHelper,First[#]],
		{None}
	]&/@myInputs;

	(* For each input, get a list of the number of unique types, excluding occurrences of None *)
	uniqueInputTypes=DeleteCases[Union[#],None]&/@inputDataTypeChecks;

	(* Get the indices of inputs which have more than one unique type *)
	inconsistentInputIndices=Flatten@Position[uniqueInputTypes,types_/;Length[types]>1,1];

	(* If generating tests, ensure that all inputs have consistent types *)
	consistentInputTypesTest=If[gatherTests,
		Test["Each dataset provided as input is either a list of numerical values, or objects with consistent types.",
			Length[inconsistentInputIndices]>1,
			False
		],
		Nothing
	];

	(* Return early with an error message if any of the input data sets have inconsistent types *)
	If[showMessages&&Length[inconsistentInputIndices]>0,
		Message[Error::InconsistentObjectTypes,First/@myInputs[[inconsistentInputIndices]],"Input Data indices"<>ToString[inconsistentInputIndices]];
		Message[Error::InvalidInput,inconsistentInputIndices];
		Return[Repeat[$Failed,5]];
	];

	(* Determine the Type of each Input, setting Type to None if the input is not an object *)
	myInputTypes=Which[
		(* Single object - return its type *)
		MatchQ[First[#],ObjectP[]], First[#][Type],

		(* List of objects - use Type of first object, assuming that all objects have the same Type *)
		MatchQ[First[#],{ObjectP[]..}], First[First[#]][Type],

		(* All other inputs - InputType is None *)
		True, None
	]&/@myInputs;

	(* Resolve Input fields based on user supplied options *)
	resolvedInputFields=MapThread[
		Which[
			(* If InputField Option is not Automatic, i.e. it has been explicitly specified *)
			MatchQ[#2,Except[Automatic]], #2,

			(* If InputField Option was not set, and Input provides a field use that *)
			MatchQ[#1,Except[Automatic]]&&MatchQ[#2,Automatic], #1,

			(* If InputField Option was not set and Input provides Automatic, look for a default field. *)
			MatchQ[#1,Automatic]&&MatchQ[#2,Automatic], If[inverseQ,lookupField[DefaultOutputFields,#3],lookupField[DefaultInputFields,#3]]
		]&,
		{myInputFieldInputs,myInputFieldOptions,myInputTypes}
	];

  (* For each input, True if the field specified by the input {obj,field} format does NOT match the option InputField *)
  inputFieldOverrideQList=MapThread[
    And[MatchQ[#1,Except[Automatic|None]],MatchQ[#2,Except[Automatic|None]],(!MatchQ[#1,#2])]&,
    {myInputFieldInputs,myInputFieldOptions}
  ];

  (* Indices of the inputs for which there is an input field mismatch *)
  inputFieldOverrideIndices=Flatten@Position[inputFieldOverrideQList,True];

  (* Warn the user if the InputField option overrides the field specified through input. This overriding is intended to allow users to update field selection during option resolution. *)
  If[ContainsAny[inputFieldOverrideQList,{True}],
    Message[Warning::InputFieldOverride,inputFieldOverrideIndices,myInputFieldInputs[[inputFieldOverrideIndices]],myInputFieldOptions[[inputFieldOverrideIndices]]]
  ];

	(* For each input, True if automatic input resolution succeeded *)
	defaultAutomaticInputFieldQ=MapThread[
		If[MatchQ[#1,Automatic]&&MatchQ[#2,Automatic],
			MatchQ[#3,Except[None]],
			True
		]&,
		{myInputFieldInputs,myInputFieldOptions,resolvedInputFields}
	];

	(* Get the indices of input datasets for which automatic field resolution failed *)
	invalidInputFieldIndices=Flatten@Position[defaultAutomaticInputFieldQ,False];

	(* Generate a test to see if all automatic input fields could be resolved ot default values. *)
	automaticInputFieldTest=If[gatherTests,
		Test["All input data with field specification 'Automatic' have default fields from which to download data.",
			Count[defaultAutomaticInputFieldQ,False]>0,
			False
		],
		Nothing
	];

	(* If we are not gathering tests, throw an error and stop early if no default input field could be resolved *)
	If[showMessages&&Count[defaultAutomaticInputFieldQ,False]>0,
		Message[Error::DefaultFieldUndefined,myInputTypes[[invalidInputFieldIndices]],"x-value field"];
		Message[Error::InvalidInput,invalidInputFieldIndices];
		Return[Repeat[$Failed,5]];
	];

  (* Recursive helper function for de-listing fields with extraneous list nesting *)
  deList[myList_]:=If[MatchQ[myList,_List]&&MatchQ[Length[myList],1],deList[First[myList]],myList];

	(* Download numerical data from object inputs *)
	numericalInputData=MapThread[
		Which[
			(* Input dataset is a singular object *)
			MatchQ[First[#1],ObjectP[]],deList@Download[First[#1],#2],

			(* Input dataset is a list of objects, each assumed to be the same type *)
			MatchQ[First[#1],{ObjectP[]..}],deList/@Download[First[#1],#2],

			(* All other dataset formats are assumed to be numerical and returned unchanged *)
			True, #1
		]&,
		{myInputs,resolvedInputFields}
	];

	(* Get index-matched list of Input transformation functions *)
	inputTransformationFunctions=Lookup[expandedOptions,InputTransformationFunction];

	(* Helper function: apply a transformation function if it is valid, do nothing if None *)
	applyTransform[f:_Function|None,val_]:=If[MatchQ[f,None],val,f[val]];

	(* Apply InputTransformationFunction to input data. If statement ensures that the numerical input can be mapped over. *)
	transformedInputData=MapThread[
		Map[Function[{x},applyTransform[#2,x]],If[MatchQ[#1,QuantityArrayP[]],#1,ToList[#1]]]&,
		{numericalInputData,inputTransformationFunctions}
	];

	(* True if the transformed input data is a valid dataset *)
	validTransformedInputDataQ=MatchQ[#,analyzeStandardCurveCoordinatesP]&/@transformedInputData;

	(* Get the indices of any invalid transformed input datasets *)
	invalidTransformedInputIndices=Flatten@Position[validTransformedInputDataQ,False];

	(* Test if the resolved numerical standard data is a valid set of coordinates *)
	validTransformedInputTest=If[gatherTests,
		Test["Transformed input data is a valid list of numerical values or quantities.",
			Count[validTransformedInputDataQ,False]>0,
			False
		],
		Nothing
	];

	(* Throw and error and return early if transformed input data is not a valid list of numerical values or quantities *)
	If[showMessages&&Count[validTransformedInputDataQ,False]>0,
		Message[Error::InvalidInputDataFormat,invalidTransformedInputIndices];
		Message[Error::InvalidInput,invalidTransformedInputIndices];
		Return[Repeat[$Failed,5]];
	];

	(* Convert each input from expandedInputs list into a QuantityArray *)
	resolvedInputs=Map[
		If[MatchQ[#,{UnitsP[]..}],
			QuantityArray[#],
			#
		]&,
    (* Convert all units into SI defaults in case they are different, but compatible *)
		safeUnitConvert[transformedInputData]
	];

	(* Format the input objects, fields, and transformation functions for the analysis object *)
	inputPacketList=MapThread[
		Which[
			(* Input is a single object *)
			MatchQ[#2,ObjectP[]], {#1,Link[#2],#3,If[#4===None,Identity,#4]},

			(* Input is a list of objects *)
			MatchQ[#2,{ObjectP[]..}], Sequence@@Map[Function[{obj},{#1,Link[obj],#3,If[#4===None,Identity,#4]}],#2],

			(* Input is not associated with objects  *)
			True, {#1,Null,Null,If[#4===None,Identity,#4]}
		]&,
		{Range[Length[myInputs]],First/@myInputs,resolvedInputFields,inputTransformationFunctions}
	];

	(* Units doesn't work on unitless distributions, so use a helper function to avoid errors *)
	safeUnits[xList:{__}]:=safeUnits/@xList;
	safeUnits[x_]:=If[MatchQ[x,DistributionP[]]&&!MatchQ[x,QuantityDistributionP[]],
		1,
		Units[x]
	];

  (* QuantityMagnitude doesn't work on unitless distributions, so use a helper function to avoid errors *)
  safeQuantityMagnitude[xList:{__}]:=safeQuantityMagnitude/@xList;
  safeQuantityMagnitude[x_]:=If[MatchQ[x,DistributionP[]]&&!MatchQ[x,QuantityDistributionP[]],
    x,
    QuantityMagnitude[x]
  ];

  (* UnitConvert doesn't work on unitless distributions, so use a helper to avoid errors *)
  safeUnitConvert[xList:{__}]:=safeUnitConvert/@xList;
  safeUnitConvert[x_]:=If[MatchQ[x,DistributionP[]]&&!MatchQ[x,QuantityDistributionP[]],
    x,
    (* Temporary fix for UnitConvert bug. If UnitConvert would return 0 with units stripped, manually add the units back in. *)
    If[MatchQ[N@UnitConvert[x],(0|0.0)],
      Quantity[0.0,Units[UnitConvert[Units[x]]]],
      N@UnitConvert[x]
    ]
  ];

	(* True if each input dataset has self-consistent units *)
	consistentUnitsEachQ=Apply[SameQ,#]&/@safeUnits[resolvedInputs];

	(* Find all unit types which appear in the user-supplied input *)
	allInputUnits=Union[Flatten@safeUnits[resolvedInputs]];

	(* Remove "DimensionlessUnits", which are placeholders used when units are not specified *)
	uniqueUnits=DeleteCases[allInputUnits,1];

	(* True if all input datasets have the same units *)
	consistentUnitsAllQ=(Length[uniqueUnits]<2);

	(* Make sure each input dataset has compatible units *)
	validUnitsEachTest=If[gatherTests,
		Test["Each input dataset has the same units for each data point.",
			Count[consistentUnitsEachQ,False],
			0
		],
		Nothing
	];

	(* Check that all input data has the same units *)
	validUnitsAllTest=If[gatherTests,
		Test["All input datasets have the same units.",
			(Count[consistentUnitsEachQ,False]==0)&&consistentUnitsAllQ,
			True
		],
		Nothing
	];

	(* Throw messages for input unit checking if tests are not being gathered. *)
	Which[
		Count[consistentUnitsEachQ,False]>0&&showMessages,
			Message[Error::InconsistentUnitsEach,Flatten@Position[consistentUnitsEachQ,False]];
			Message[Error::InvalidInput,Part[myInputs,Flatten@Position[consistentUnitsEachQ,False]]],
		!consistentUnitsAllQ&&showMessages,
			Message[Error::InconsistentUnitsAll,(First/@safeUnits[resolvedInputs])];
			Message[Error::InvalidInput,myInputs]
	];

	(* Get the input unit type for further option resolution *)
	inputUnitType=If[uniqueUnits=={},
		1,
		First[uniqueUnits]
	];

	(*** StandardData Option ***)

	(* Look up the StandardData value from options *)
	myStandardData=Lookup[expandedOptions,StandardData];

  (* Return an error if StandardData is Automatic, i.e. no standard was supplied. Automatic is only used in protocol overload. *)
  If[MatchQ[myStandardData,Automatic],
    Message[Error::MissingStandardData];
		Message[Error::InvalidOption,StandardData];
    Return[Repeat[$Failed,5]];
  ];

	(*If StandardData is an object Object[Analysis, StandardCurve], check fields ReferenceStandardCurve and StandardCurveFit*)
	objectAnalysisStandardCurveQ = MatchQ[myStandardData, ObjectP[Object[Analysis, StandardCurve]]];
	If[objectAnalysisStandardCurveQ,
		{currentReferenceSC, currentSCF} = Quiet[Download[myStandardData, {ReferenceStandardCurve, StandardCurveFit}]];
		(*if ReferenceStandardCurve has existing value, return error*)
		If[!MatchQ[currentReferenceSC, ($Failed|Null)],
			Message[Error::ExistingReferenceStandardCurve, myStandardData];
			Return[Repeat[$Failed, 5]];
		];
		(*if StandardCurveFit is not a valid Fit object, return error*)
		If[!MatchQ[currentSCF, ObjectP[Object[Analysis, Fit]]],
			Message[Error::InvalidStandardCurveFitField, myStandardData];
			Return[Repeat[$Failed, 5]];
		];
	];

	(*Now assign myStandardData to Object[Analysis, Fit]*)
	myStandardData = If[objectAnalysisStandardCurveQ, currentSCF, myStandardData];

	(* If StandardData is an existing fit *)
	existingFitQ=MatchQ[myStandardData,ObjectP[Object[Analysis,Fit]]];

	(* Units of StandardData, if StandardData is an existing fit *)
	existingFitUnits=If[existingFitQ,
		safeUnits/@(myStandardData[DataUnits]),
		{None,None}
	];

  (* Select the unit/dimension which must be matched with the input *)
  existingFitInputUnits=If[inverseQ,Last[existingFitUnits],First[existingFitUnits]];

	(* Condition which is true if the provided existing fit has compatible units with input data *)
	existingFitCompatibleUnitsQ=If[consistentUnitsAllQ&&existingFitQ,
		CompatibleUnitQ[existingFitInputUnits,inputUnitType]||(existingFitInputUnits===1)||(inputUnitType===1),
		False
	];

	(* If object is an existing fit, check/test that the fit object has compatible units *)
	existingFitUnitsTest=If[gatherTests&&existingFitQ,
		Test["The Fit object specified for option StandardCurve has consistent units with the input data.",
			existingFitCompatibleUnitsQ,
			True
		],
		Nothing
	];

	(* Throw messages if we are not gathering tests *)
	If[showMessages&&consistentUnitsAllQ&&existingFitQ&&(!existingFitCompatibleUnitsQ),
		Message[Error::ExistingFitIncompatibleUnits,existingFitInputUnits,inputUnitType];
		Message[Error::InvalidOption,StandardData]
	];

	(* Obtain a list of types of standard objects to check for consistency *)
	{standardXTypes,standardYTypes}=Which[
		(* Input is a list of single objects *)
		MatchQ[myStandardData,{ObjectP[]..}],
		{getTypeHelper/@myStandardData,getTypeHelper/@myStandardData},

		(* Input is a list of paired objects/numerics *)
		MatchQ[myStandardData,{{UnitsP[]|ObjectP[],UnitsP[]|ObjectP[]}..}],
		{Map[getTypeHelper,First/@myStandardData],Map[getTypeHelper,Last/@myStandardData]},

		(* Existing fit input does not need to be checked *)
		True,
		{{None},{None}}
	];

	(* Count the number of unique object types in the standard X and Y Data, excluding the value None *)
	uniqueStandardXTypes=DeleteCases[Union[standardXTypes],None];
	uniqueStandardYTypes=DeleteCases[Union[standardYTypes],None];

	(* Generate tests if the standard data types are inconsistent. *)
	consistentStandardTypeTest=If[gatherTests,
		Test["Each standard data object/value provided for the independent variable has the same type:",
			Length[uniqueStandardXTypes]>1||Length[uniqueStandardYTypes]>1,
			False
		],
		Nothing
	];

	(* Print an error message if objects provided for standard data option have inconsistent types *)
	If[showMessages&&(Length[uniqueStandardXTypes]>1||Length[uniqueStandardYTypes]),
		Message[Error::InconsistentObjectTypes,myStandardData,"StandardData"];
		Message[Error::InvalidOption,StandardFields];
		Return[Repeat[$Failed,5]];
	];

	(* Identify the type of standard data *)
	standardDataType=Which[
		(* If StandardData was provided as a Fit, then set type to None *)
		existingFitQ,{None},

		(* If StandardData is a single object, get its type *)
		MatchQ[myStandardData,ObjectP[]],{myStandardData[Type]},

		(* If list of objects, get the type of the first one, assuming all objects have the same type *)
		MatchQ[myStandardData,{ObjectP[]..}],{First[myStandardData][Type]},

		(* If list of paired objects, then get {xtype,ytpe}, where None is used for numeric inputs paired with objects *)
		MatchQ[myStandardData,{{UnitsP[]|ObjectP[],UnitsP[]|ObjectP[]}..}],getTypeHelper/@First[myStandardData],

		(* All other cases set type to None *)
		True,{None}
	];

	(* True if automatic resolution is required for the fields of standard data *)
	automaticStandardFieldsQ=MatchQ[Lookup[expandedOptions,StandardFields],Automatic];

	(* True if the standard data types are objects *)
	standardXObjectQ=MatchQ[First[standardDataType],Except[None]];
	standardYObjectQ=MatchQ[Last[standardDataType],Except[None]];

	(* If StandardFields is Automatic, pick defaults based on standardDataType *)
  {xValueField,yValueField}=If[automaticStandardFieldsQ,
		{lookupField[DefaultInputFields,First[standardDataType]],lookupField[DefaultOutputFields,Last[standardDataType]]},
		Lookup[expandedOptions,StandardFields]
	];

	(* If standard X data was provided as object(s) and StandardFields were Automatic, check if default fields are defined. *)
	automaticStandardFieldXTest=If[gatherTests&&automaticStandardFieldsQ&&standardXObjectQ,
		Test["Default field for standard X data has a default value.",
			!MatchQ[xValueField,None],
			True
		],
		Nothing
	];

	(* If standard Y data was provided as object(s) and StandardFields were Automatic, check if default fields are defined. *)
	automaticStandardFieldYTest=If[gatherTests&&automaticStandardFieldsQ&&standardYObjectQ,
		Test["Default field for standard Y data has a default value.",
			!MatchQ[yValueField,None],
			True
		],
		Nothing
	];

	(* If we are not gathering tests, throw an error if no default X-field could be resolved *)
	If[showMessages&&automaticStandardFieldsQ&&standardXObjectQ&&MatchQ[xValueField,None],
		Message[Error::DefaultFieldUndefined,First[standardDataType],"x-value field"];
		Message[Error::InvalidOption,StandardFields];
		Return[Repeat[$Failed,5]];
	];

	(* If we are not gathering tests, throw an error if no default Y-field could be resolved *)
	If[showMessages&&automaticStandardFieldsQ&&standardYObjectQ&&MatchQ[yValueField,None],
		Message[Error::DefaultFieldUndefined,Last[standardDataType],"y-value field"];
		Message[Error::InvalidOption,StandardFields];
		Return[Repeat[$Failed,5]];
	];

  (* Helper function for transposing data which may have invalid dimensions, without generating error *)
  safeTranspose[x_]:=If[(Length[x]===2)&&(Length[First[x]]===Length[Last[x]]),
    Transpose[x],
    $Failed
  ];

	(* Helper function for downloading fields from {{obj,obj}..}, {{x,obj}..} or {{obj,y}..} data *)
	mixedDataDownload[xdata_,ydata_,xfield_,yfield_]:=Transpose[{
		If[MatchQ[xdata,{ObjectP[]..}],
			Flatten@Download[xdata,xfield],
			xdata
		],
		If[MatchQ[ydata,{ObjectP[]..}],
			Flatten@Download[ydata,yfield],
			ydata
		]
	}];

	(* Download numerical data from objects *)
	numericalStandardData=Quiet@Which[
		(* If StandardData was provided as a Fit, then set the type to None *)
		existingFitQ,
		None,

		(* If StandardData matches one of the numerical input patterns, return it unchanged *)
		MatchQ[myStandardData,MatrixP[UnitsP[]|DistributionP[]]|_?QuantityMatrixQ],
		myStandardData,

		(* StandardData is a single object *)
		MatchQ[myStandardData,ObjectP[]],
		safeTranspose[Download[myStandardData,{xValueField,yValueField}]],

		(* StandardData is a list of objects *)
		MatchQ[myStandardData,{ObjectP[]..}],
		Apply[Sequence,Download[myStandardData,{xValueField,yValueField}],{2}],

		(* StandardData is paired or mixed objects *)
		MatchQ[myStandardData,{{UnitsP[]|ObjectP[],UnitsP[]|ObjectP[]}..}],
		mixedDataDownload[First/@myStandardData,Last/@myStandardData,xValueField,yValueField],

		(* Default value is $Failed, since this case should not occur *)
		True,
		{{$Failed,$Failed}}
	];

	(* True if the field specification supplied points to an empty field *)
	emptyStandardFieldQ=MatchQ[numericalStandardData,{({Null,_}|{_,Null})..}];

	(* True if either the object or field supplied could not be found *)
	invalidStandardFieldQ=MatchQ[numericalStandardData,{({$Failed,_}|{_,$Failed})..}];

	(* Test if standard fields in standard objects are non-empty. *)
	emptyFieldTest=If[gatherTests&&!existingFitQ,
		Test["The standard fields of provided standard data objects are non-empty",
			!emptyStandardFieldQ,
			True
		],
		Nothing
	];

  (* Throw an error and return early if standard fields in standard data are empty *)
	If[showMessages&&!existingFitQ&&emptyStandardFieldQ,
		Message[Error::EmptyStandardField,{xValueField,yValueField},"StandardData"];
		Message[Error::InvalidOption,StandardFields];
		Return[Repeat[$Failed,5]];
	];

	(* Test if standard fields are present in standard objects. *)
	invalidFieldTest=If[gatherTests&&!existingFitQ,
		Test["The standard fields supplied are existing fields of standard data objects.",
			!invalidStandardFieldQ,
			True
		],
		Nothing
	];

	(* Throw an error and return early if standard fields are not present in standard data *)
	If[showMessages&&!existingFitQ&&invalidStandardFieldQ,
		Message[Error::InvalidStandardField,{xValueField,yValueField},"StandardData"];
		Message[Error::InvalidOption,StandardFields];
		Return[Repeat[$Failed,5]];
	];

	(* Pull Standard Transformation Functions *)
	{standardXTransform,standardYTransform}=Lookup[expandedOptions,StandardTransformationFunctions];

	(* Apply StandardTransformationFunctions *)
	transformedStandardData=If[MatchQ[numericalStandardData,{{_,_}..}|QuantityArrayP[]],
    Map[
      {applyTransform[standardXTransform,First[#]],applyTransform[standardYTransform,Last[#]]}&,
      numericalStandardData
    ],
    numericalStandardData
	];

	(* True if the standard data is a valid dataset *)
	validTransformedStandardDataQ=MatchQ[transformedStandardData,MatrixP[UnitsP[]|DistributionP[]]|_?QuantityMatrixQ];

	(* Test if the resolved numerical standard data is a valid set of coordinates *)
	validStandardDataTest=If[gatherTests&&!existingFitQ,
		Test["The resolved numerical standard data is a valid set of coordinates.",
			validTransformedStandardDataQ,
			True
		],
		Nothing
	];

	(* Throw an error and return early if the resolved standard data is not a valid list of coordinates *)
	If[showMessages&&!existingFitQ&&!validTransformedStandardDataQ,
		Message[Error::InvalidStandardDataFormat,transformedStandardData];
		Message[Error::InvalidOption,StandardData];
		Return[Repeat[$Failed,5]];
	];

	(* resolvedStandard Data is either the supplied existing Fit object, or the transformed standard data *)
	resolvedStandardData=If[existingFitQ,
		myStandardData,
    (* Convert to SI defaults in case data has been provided as compatible but different units *)
		safeUnitConvert[transformedStandardData]
	];

	(* If standard data was supplied as data points to fit, check that all x-values have consistent units *)
	consistentStandardXUnitQ=If[!existingFitQ&&validTransformedStandardDataQ,
		Apply[SameQ,safeUnits[First/@resolvedStandardData]],
		True
	];

	(* If standard data was supplied as data points to fit, check that all y-values have consistent units *)
	consistentStandardYUnitQ=If[!existingFitQ&&validTransformedStandardDataQ,
		Apply[SameQ,safeUnits[Last/@resolvedStandardData]],
		True
	];

	(* Both X and Y values of standard data must have consistent units *)
	consistentStandardUnitsQ=consistentStandardXUnitQ&&consistentStandardYUnitQ;

	(* If gathering tests, if standard data was numerical, check unit consistency *)
	consistentStandardUnitsTest=If[gatherTests&&validTransformedStandardDataQ&&!existingFitQ,
		Test["Resolved standard data must have self-consistent units",
			consistentStandardUnitsQ,
			True
		],
		Nothing
	];

	(* If not gathering tests, exit with an error if the standard units are inconsistent *)
	If[showMessages&&!existingFitQ&&validTransformedStandardDataQ&&!consistentStandardUnitsQ,
		Message[Error::StandardDataInconsistentUnits,resolvedStandardData];
		Message[Error::InvalidOption,StandardData];
	];

	(* Assuming that standard data has self consistent units, get the x-y units of resolved standard data *)
	{standardXUnit,standardYUnit}=Which[
    (* If standard data was provided as an existing fit object *)
    existingFitQ,existingFitUnits,

    (* If standard data was provided as numerical data or objects and field *)
    !existingFitQ&&validTransformedStandardDataQ&&consistentStandardUnitsQ,safeUnits/@First[resolvedStandardData],

    (* Standard data is invalid *)
    True,{None,None}
  ];

  (* Select the unit/dimension which must be matched with the input *)
  standardInputUnits=If[inverseQ,standardYUnit,standardXUnit];

	(* True if the independent units of standard data are compatible with input data *)
	compatibleStandardUnitsQ=CompatibleUnitQ[standardInputUnits,inputUnitType]||standardInputUnits===1||inputUnitType===1;

	(* If gathering tests, check if the standard x-units match input unit *)
	compatibleStandardUnitsTest=If[gatherTests&&validTransformedStandardDataQ&&consistentStandardUnitsQ&&!existingFitQ,
		Test["The units of the independent variable of standard data must match units of input data:",
			compatibleStandardUnitsQ,
			True
		],
		Nothing
	];

	(* If not gathering tests, exit with an error *)
	If[showMessages&&consistentStandardUnitsQ&&validTransformedStandardDataQ&&!existingFitQ&&!compatibleStandardUnitsQ,
		Message[Error::StandardDataIncompatibleUnits,standardInputUnits,inputUnitType];
		Message[Error::InvalidOption,StandardData];
	];

  (* Warn the user if the standard data is unitless but the input has units *)
  If[showMessages&&consistentStandardUnitsQ&&(standardInputUnits===1)&&(inputUnitType=!=1),
    Message[Warning::UnspecifiedUnits,StandardData,inputUnitType,Input]
  ];

  (* Warn the user if input data is unitless, but the standard data has units *)

  If[showMessages&&consistentStandardUnitsQ&&(standardInputUnits=!=1)&&(inputUnitType===1)&&(myInputs=!={{0.017}}),
    Message[Warning::UnspecifiedUnits,Input,standardInputUnits,StandardData]
  ];

	(* If the transformation function is None, convert it to Identity *)
	convertNoneToIdentity=Function[{tf},If[tf===None,Identity,tf]];

	(* Format the standard transformation functions for the Analysis object packet *)
	transformX=convertNoneToIdentity[standardXTransform];
	transformY=convertNoneToIdentity[standardYTransform];

	(* Populate fields related to Standard Data in the Analysis object packet *)
	{standardXPacketList,standardYPacketList}=Which[
		(* If StandardData was provided as a Fit, then leave these lists blank *)
		existingFitQ,
		{
			{{Null,Null,Null}},
			{{Null,Null,Null}}
		},

		(* StandardData is a single object *)
		MatchQ[myStandardData,ObjectP[]],
		{
			{{Link[myStandardData],xValueField,transformX}},
			{{Link[myStandardData],yValueField,transformY}}
		},

		(* StandardData is a list of objects *)
		MatchQ[myStandardData,{ObjectP[]..}],
		{
			{Link[#],xValueField,transformX}&/@myStandardData,
			{Link[#],yValueField,transformY}&/@myStandardData
		},

		(* StandardData is paired or mixed objects *)
		MatchQ[myStandardData,{{UnitsP[]|ObjectP[],UnitsP[]|ObjectP[]}..}],
		{
			{If[MatchQ[First[#],ObjectP[]],Link[First[#]],Null],xValueField,transformX}&/@myStandardData,
			{If[MatchQ[Last[#],ObjectP[]],Link[Last[#]],Null],yValueField,transformY}&/@myStandardData
		},

		(* If data was not associated with objects, leave these packets empty *)
		True,
		{
			{{Null,Null,transformX}},
			{{Null,Null,transformY}}
		}
	];

	(* True if the user-supplied fitType was Automatic *)
	fitTypeAutomaticQ=MatchQ[Lookup[expandedOptions,FitType],Automatic];

	(* True if a default fit type is associated with standardDataType *)
	defaultFitExistsQ=KeyExistsQ[DefaultFitTypes,standardDataType];

	(* Throw a warning message if there is no default fit type *)
	If[showMessages&&fitTypeAutomaticQ&&!defaultFitExistsQ&&!MatchQ[standardDataType,{None}|{None,None}],
		Message[Warning::DefaultFitTypeUndefined,standardDataType];
	];

	(* Resolve the default Fit Type *)
	resolvedFitType=Which[
		(* Fit type is Automatic and default fit model is defined for standard object type *)
		fitTypeAutomaticQ&&defaultFitExistsQ,DefaultFitTypes[standardDataType],

		(* Fit type is Automatic but no default fit model is defined *)
		fitTypeAutomaticQ&&!defaultFitExistsQ,Linear,

		(* Fit type was explicitly defined. *)
		!fitTypeAutomaticQ,Lookup[expandedOptions,FitType]
	];

	(* Construct the resolution packet, which contains Analysis object contents determined during option resolution *)
	resolutionPacket=<|
		Replace[InputData]->inputPacketList,
		Replace[StandardIndependentVariableData]->standardXPacketList,
		Replace[StandardDependentVariableData]->standardYPacketList,
		InputDataUnits->Quantity[1,inputUnitType],
		Replace[InputDataPoints]->If[Length[resolvedInputs]==1,First[resolvedInputs],resolvedInputs]
	|>;

	(* Update resolved Options with any changed values (from resolving Automatic) *)
	resolvedOptions=ReplaceRule[myOptions,
		{
			InputField->resolvedInputFields,
			StandardFields->{xValueField,yValueField},
			FitType->resolvedFitType
		}
	];

	(* Collapse duplicate index-matched options *)
	collapsedOptions=Quiet[
		CollapseIndexMatchedOptions[AnalyzeStandardCurve,resolvedOptions],
		{Warning::CannotCollapse}
	];

	(* True if the resolved standard data is a valid input to AnalyzeFit *)
	validStandardDataQ=validTransformedStandardDataQ&&consistentStandardUnitsQ;

  (* These quantities are used to group AnalyzeFit errors into a message blob. Set to Null for now. *)
  (* This is necessary for stability until AnalyzeFit errors have been resolved *)
  {quietCollectRes,quietCollectMessages}={Null,Null};

	(* Call AnalyzeFit to fit the StandardCurve, propagating any options set by the user *)
	{fitPacket,analyzeFitResolvedOptions}=Which[
		(* Standard Curve was provided as an existing fit object *)
		existingFitQ,

    (* Download the packet for the supplied fit object and its options *)
		{Download[resolvedStandardData],resolvedStandardData[ResolvedOptions]},

		(* Standard curve should be fit to data *)
		!existingFitQ&&validStandardDataQ,

    (* Quiet the AnalyzeFit call (see Utilities.m for quietAndCollect), but save the exact input of the call and any messages generated for debugging *)
		First@({quietCollectRes,quietCollectMessages}=quietAndCollect[
      Check[
        AnalyzeFit[
          resolvedStandardData,
          resolvedFitType,
          PassOptions[AnalyzeStandardCurve,AnalyzeFit,ReplaceRule[resolvedOptions,{Output->{Result,Options},Upload->False}]]
        ],
        (* Fail to resolve if AnalyzeFit fails to resolve *)
        {<||>,{}}
      ]
    ]),

		(* Standard Data did not resolve to a valid input to AnalyzeFit *)
		True,
		{<||>,{}}
	];

  (* The fitPacket is valid if it is non-empty and if it passes ValidPacketFormatQ *)
  validFitPacketQ=And[
      MatchQ[fitPacket,Except[<||>]],
      ValidPacketFormatQ[stripAppendReplaceKeyHeads[fitPacket]]
  ];

  (* If gathering tests, check if AnalyzeFit[] completed successfully *)
	analyzeFitSuceededTest=If[gatherTests&&validStandardDataQ,
		Test["Resolved standard data was successfully fit with AnalyzeFit[]",
			validFitPacketQ,
			True
		],
		Nothing
	];

	(* If not gathering tests, exit with an error if AnalyzeFit did not complete successfully *)
	If[showMessages&&validStandardDataQ&&(!validFitPacketQ),
    Message[Warning::SystemMessages,
      OpenerView[{
        "The following messages were generated by AnalyzeFit:",
        StringReplace[ToString@quietCollectMessages,{"\r\n\r\n" -> "\n", "\r\n" -> ""}]
      }]
    ];
		Message[Error::AnalyzeFit,resolvedStandardData,resolvedFitType]
	];

	(* Joined the resolvedOptions from StandardCurve with resolved options from Fit *)
	joinedResolvedOptions=ReplaceRule[collapsedOptions,
		DeleteCases[analyzeFitResolvedOptions,Rule[Output|Upload,_]],
		Append->False
	];

	(*** Return requested values ***)

	(* Construct Tests output (Null if Tests weren't requested) *)
	testsRule=Tests->If[MemberQ[output,Tests],
		{
			consistentInputTypesTest,automaticInputFieldTest,validTransformedInputTest,validUnitsEachTest,validUnitsAllTest,
			existingFitUnitsTest,consistentStandardTypeTest,automaticStandardFieldXTest,automaticStandardFieldYTest,
			compatibleStandardUnitsTest,consistentStandardUnitsTest,emptyFieldTest,invalidFieldTest,validStandardDataTest,
      analyzeFitSuceededTest
		},
		Null
	];

	(* Construct the Result output *)
	resultRule=Result->{resolvedInputs,resolvedStandardData,resolutionPacket,fitPacket,joinedResolvedOptions};

	(* Use the rules to return the requested outputs *)
	outputSpecification/.{testsRule,resultRule}
];


(* ::Subsection::Closed:: *)
(*AnalyzeStandardCurveOptions*)


DefineOptions[AnalyzeStandardCurveOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
			Description->"Indicates whether the function returns a table or a list of the options."
		}
	},
	SharedOptions:>{
		AnalyzeStandardCurve
	}
];

AnalyzeStandardCurveOptions[
	myInputs_,
	myOptions:OptionsPattern[AnalyzeStandardCurveOptions]
]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the OutputFormat option and change the Output option to "Options" *)
	preparedOptions=Normal@Append[KeyDrop[listedOptions,{Output,OutputFormat}],Output->Options];

	(* Get resolved Options from AnalyzeStandardCurve *)
	resolvedOptions=AnalyzeStandardCurve[myInputs,preparedOptions];

	(*Return the option as a list or table*)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table],
		LegacySLL`Private`optionsToTable[resolvedOptions,AnalyzeStandardCurve],
		resolvedOptions
	]
];


AnalyzeStandardCurveOptions[
	myInputs_,
  myStandard_,
	myOptions:OptionsPattern[AnalyzeStandardCurveOptions]
]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the OutputFormat option and change the Output option to "Options" *)
	preparedOptions=Normal@Append[KeyDrop[listedOptions,{Output,OutputFormat}],Output->Options];

	(* Get resolved Options from AnalyzeStandardCurve *)
	resolvedOptions=AnalyzeStandardCurve[myInputs,myStandard,preparedOptions];

	(*Return the option as a list or table*)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table],
		LegacySLL`Private`optionsToTable[resolvedOptions,AnalyzeStandardCurve],
		resolvedOptions
	]
];


(* ::Subsection::Closed:: *)
(*AnalyzeStandardCurvePreview*)

DefineOptions[AnalyzeStandardCurvePreview,
	SharedOptions:>{
		AnalyzeStandardCurve
	}
];

AnalyzeStandardCurvePreview[
	myInputs_,
	myOptions:OptionsPattern[AnalyzeStandardCurvePreview]
]:=Module[{listedOptions},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Call AnalyzeStandardCurve with Output\[Rule]Preview *)
	AnalyzeStandardCurve[myInputs,ReplaceRule[listedOptions,Output->Preview]]
];

AnalyzeStandardCurvePreview[
	myInputs_,
  myStandard_,
	myOptions:OptionsPattern[AnalyzeStandardCurvePreview]
]:=Module[{listedOptions},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Call AnalyzeStandardCurve with Output\[Rule]Preview *)
	AnalyzeStandardCurve[myInputs,myStandard,ReplaceRule[listedOptions,Output->Preview]]
];

(* ::Subsection::Closed:: *)
(*ValidAnalyzeStandardCurveQ*)

DefineOptions[ValidAnalyzeStandardCurveQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions:>{
		AnalyzeStandardCurve
	}
];

ValidAnalyzeStandardCurveQ[
	myInputs_,
	myOptions:OptionsPattern[ValidAnalyzeStandardCurveQ]
]:=Module[
	{listedOptions,preparedOptions,analyzeStandardCurveTests,initialTestDescription,allTests,verbose,outputFormat},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Remove ValidAnalyzeStandardCurveQ specific options, and append Option\[Rule]Tests *)
	preparedOptions=Normal@Append[KeyDrop[listedOptions,{Verbose,OutputFormat,Output}],Output->Tests];

	(* Get the tests for AnalyzeStandardCurve *)
	analyzeStandardCurveTests=AnalyzeStandardCurve[myInputs,preparedOptions];

	(* Define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(*Make a list of all the tests, including the blanket test*)
	allTests=If[MatchQ[analyzeStandardCurveTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[{initialTest,validObjectBooleans,voqWarnings},

			(* Generate the initial test, which has been Passed if we made it this far *)
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[Cases[Flatten[myInputs],ObjectP[]],OutputFormat->Boolean];

			voqWarnings=MapThread[
				Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{Cases[Flatten[myInputs],ObjectP[]],validObjectBooleans}
			];

			(* Return all Tests and Warnings *)
			Flatten[{initialTest,analyzeStandardCurveTests,voqWarnings}]
		]
	];

	(* Lookup options for running tests *)
	{verbose,outputFormat}=OptionDefault[OptionValue[{Verbose,OutputFormat}]];

	(* Run the tests as requested *)
	Lookup[RunUnitTest[<|"ValidAnalyzeStandardCurveQ"->allTests|>,Verbose->verbose,OutputFormat->outputFormat],"ValidAnalyzeStandardCurveQ"]
];


ValidAnalyzeStandardCurveQ[
	myInputs_,
  myStandard_,
	myOptions:OptionsPattern[ValidAnalyzeStandardCurveQ]
]:=Module[
	{listedOptions,preparedOptions,analyzeStandardCurveTests,initialTestDescription,allTests,verbose,outputFormat},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Remove ValidAnalyzeStandardCurveQ specific options, and append Option\[Rule]Tests *)
	preparedOptions=Normal@Append[KeyDrop[listedOptions,{Verbose,OutputFormat,Output}],Output->Tests];

	(* Get the tests for AnalyzeStandardCurve *)
	analyzeStandardCurveTests=AnalyzeStandardCurve[myInputs,myStandard,preparedOptions];

	(* Define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(*Make a list of all the tests, including the blanket test*)
	allTests=If[MatchQ[analyzeStandardCurveTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[{initialTest,validObjectBooleans,voqWarnings},

			(* Generate the initial test, which has been Passed if we made it this far *)
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[Cases[Flatten[myInputs],ObjectP[]],OutputFormat->Boolean];

			voqWarnings=MapThread[
				Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{Cases[Flatten[myInputs],ObjectP[]],validObjectBooleans}
			];

			(* Return all Tests and Warnings *)
			Flatten[{initialTest,analyzeStandardCurveTests,voqWarnings}]
		]
	];

	(* Lookup options for running tests *)
	{verbose,outputFormat}=OptionDefault[OptionValue[{Verbose,OutputFormat}]];

	(* Run the tests as requested *)
	Lookup[RunUnitTest[<|"ValidAnalyzeStandardCurveQ"->allTests|>,Verbose->verbose,OutputFormat->outputFormat],"ValidAnalyzeStandardCurveQ"]
];
