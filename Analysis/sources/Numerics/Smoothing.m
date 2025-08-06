(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*AnalyzeSmoothing*)


(* ::Subsection::Closed:: *)
(*AnalyzeSmoothing Options*)

DefineOptions[AnalyzeSmoothing,
  Options :> {

    IndexMatching[
      IndexMatchingInput->"main input",

      {
        OptionName -> Method,
        Default -> Gaussian,
        Description -> "Indicates the method of data smoothing that is going to be applied to the data sets.",
        AllowNull ->False,
        Widget ->Widget[Type -> Enumeration, Pattern:>SmoothingMethodP],
        Category -> "Data Processing"
      },

      {
        OptionName -> CutoffFrequency,
        Default -> Automatic,
        Description -> "The distance over which the distance for each x-point in the x-coordinate for which the smoothing weight functions is going to be applied.",
        ResolutionDescription -> "The frequency will be estimated such that it is either 10% larger than the minimum if LowpassFilter is selected and 10% lower than the maximum if HighpassFilter is selected.",
        AllowNull -> False,
        Widget -> Alternatives[
          Widget[Type->Quantity, Pattern:>GreaterEqualP[0 1/Second], Units->1/Second],
          Widget[Type->Quantity, Pattern:>GreaterEqualP[0 1/Minute], Units->1/Minute],
          Widget[Type->Quantity, Pattern:>GreaterEqualP[0 1/Dalton], Units->1/Dalton],
          Widget[Type->Quantity, Pattern:>GreaterEqualP[0 ArbitraryUnit], Units->ArbitraryUnit],
          Widget[Type->Number, Pattern:>GreaterEqualP[0]]
        ],
        Category -> "Data Processing"
      },

      {
        OptionName -> Radius,
        Default -> Automatic,
        Description -> "The distance over which for each x point in the x-coordinate, the values of y-coordinate is adjusted to get a smoother {x,y} curve.",
        ResolutionDescription -> "The smoothing radius will be estimated such that there are at least 11 data points within the Radius (in the neighborhood of each data point).",
        AllowNull -> False,
        Widget -> Alternatives[
          Widget[Type->Quantity, Pattern:>GreaterEqualP[0 Second], Units->Second],
          Widget[Type->Quantity, Pattern:>GreaterEqualP[0 Minute], Units->Minute],
          Widget[Type->Quantity, Pattern:>GreaterEqualP[0 Dalton], Units->Dalton],
          Widget[Type->Quantity, Pattern:>GreaterEqualP[0 ArbitraryUnit], Units->ArbitraryUnit],
          Widget[Type->Number, Pattern:>GreaterEqualP[0]]
        ],
        Category -> "Data Processing"
      },

      {
        OptionName -> AscendingOrder,
  			Default -> True,
  			Description -> "If True, then the input coordinate data will be sorted to have a monotonicly increasing order. For spiral-like datasets, this should be set as False.",
  			AllowNull -> False,
  			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[True,False]],
  			Category -> "Data Processing"
      },

      {
        OptionName -> EqualSpacing,
  			Default -> True,
  			Description -> "If True, then the input coordinate data will be adjusted to have equal spacing.",
  			AllowNull -> False,
  			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[True,False]],
  			Category -> "Data Processing"
      },

      {
        OptionName -> BaselineAdjust,
  			Default -> False,
  			Description -> "If True, it adjusts the baseline of the curve using the EstimatedBackground before smoothing operation.",
  			AllowNull -> False,
  			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[True,False]],
  			Category -> "Data Processing"
      },

      {
        OptionName -> ReferenceField,
        Default -> Automatic,
        Description -> "The reference field in given objects containing the data points that will be fit to.",
        ResolutionDescription -> "If Automatic then picks a pre-specified field based on the object type.",
        AllowNull -> True,
        Widget -> Alternatives[
              Widget[Type->Expression, Pattern:> (_Symbol | {_Symbol..}), Size->Line],
              Widget[Type->Enumeration, Pattern:>Alternatives[Null]]
        ],
        Category -> "Data Processing"
      }
    ],

    OutputOption,
    UploadOption
    (* AnalysisTemplateOption *)

  }
];


(* ::Subsection::Closed:: *)
(*AnalyzeSmoothing Variables*)

(**)

SmoothingInputDataTypes = {
	{Object[Data, AbsorbanceSpectroscopy], AbsorbanceSpectrum},
	{Object[Data, AgaroseGelElectrophoresis], SampleElectropherogram},
	{Object[Data, AgaroseGelElectrophoresis], MarkerElectropherogram},
	{Object[Data, AgaroseGelElectrophoresis], PostSelectionElectropherogram},
	{Object[Data, Chromatography], Absorbance},
	{Object[Data, Chromatography], SecondaryAbsorbance},
	{Object[Data, Chromatography], Fluorescence},
	{Object[Data, Chromatography], SecondaryFluorescence},
	{Object[Data, Chromatography], TertiaryFluorescence},
	{Object[Data, Chromatography], QuaternaryFluorescence},
	{Object[Data, Chromatography], Scattering},
  {Object[Data, Chromatography], MultiAngleLightScattering22Degree},
  {Object[Data, Chromatography], MultiAngleLightScattering28Degree},
  {Object[Data, Chromatography], MultiAngleLightScattering32Degree},
  {Object[Data, Chromatography], MultiAngleLightScattering38Degree},
  {Object[Data, Chromatography], MultiAngleLightScattering44Degree},
  {Object[Data, Chromatography], MultiAngleLightScattering50Degree},
  {Object[Data, Chromatography], MultiAngleLightScattering57Degree},
  {Object[Data, Chromatography], MultiAngleLightScattering64Degree},
  {Object[Data, Chromatography], MultiAngleLightScattering72Degree},
  {Object[Data, Chromatography], MultiAngleLightScattering81Degree},
  {Object[Data, Chromatography], MultiAngleLightScattering90Degree},
  {Object[Data, Chromatography], MultiAngleLightScattering99Degree},
  {Object[Data, Chromatography], MultiAngleLightScattering108Degree},
  {Object[Data, Chromatography], MultiAngleLightScattering117Degree},
  {Object[Data, Chromatography], MultiAngleLightScattering126Degree},
  {Object[Data, Chromatography], MultiAngleLightScattering134Degree},
  {Object[Data, Chromatography], MultiAngleLightScattering141Degree},
  {Object[Data, Chromatography], MultiAngleLightScattering147Degree},
  {Object[Data, Chromatography], DynamicLightScattering},
  {Object[Data, Chromatography], RefractiveIndex},
  {Object[Data, Chromatography], Conductance},
  {Object[Data, Chromatography], ConductivityFlowCellTemperature},
  {Object[Data, Chromatography], pH},
  {Object[Data, Chromatography], pHFlowCellTemperature},
	{Object[Data, ChromatographyMassSpectra], Absorbance},
	{Object[Data, ChromatographyMassSpectra], IonAbundance},
	{Object[Data, ChromatographyMassSpectra], TotalIonAbundance},
	{Object[Data, ChromatographyMassSpectra], MassSpectrum},
	{Object[Data, FluorescenceSpectroscopy], ExcitationSpectrum},
	{Object[Data, FluorescenceSpectroscopy], EmissionSpectrum},
	{Object[Data, LuminescenceSpectroscopy], EmissionSpectrum},
	{Object[Data, MassSpectrometry], MassSpectrum},
	{Object[Data, NMR], NMRSpectrum},
	{Object[Data, PAGE], OptimalLaneIntensity},
	{Object[Data, Western], MassSpectrum},
	{Object[Data, TLC], Intensity},
	{Object[Data, XRayDiffraction], BlankedDiffractionPattern},
	{Object[Data, IRSpectroscopy], AbsorbanceSpectrum},
	{Object[Data, DifferentialScanningCalorimetry], HeatingCurves}
};


(* For a list of quantities as opposed to QuantityArray *)
listOfQuantitiesP=Except[CoordinatesP,{{UnitsP[], UnitsP[]} ..}];

(* QuantityCoordinatesP should not pass Quantity[Distribution]. The following definitions and the two first AnalyzeSmoothing function is to handle that. *)
(* The following definitions are due to the unfortune case of not having something like QuantityDistributionArray at the moment *)
quantityArrayWrappedDistributionsP[]:=_?quantityArrayWrappedDistributionsQ;
quantityArrayWrappedDistributionsQ[qawd:QuantityCoordinatesP[]]:=QuantityArrayQ[qawd] && MatchQ[QuantityMagnitude[qawd],DistributionCoordinatesP];

(* For a list of distributions *)
quantityDistributionCoordinateP=Alternatives[
  {QuantityDistributionP[],QuantityDistributionP[]},
  {UnitsP[],QuantityDistributionP[]},
  {QuantityDistributionP[],UnitsP[]},
  {_?DistributionParameterQ,UnitsP[]},
  {UnitsP[],_?DistributionParameterQ},
  {QuantityDistributionP[],_?DistributionParameterQ},
  {_?DistributionParameterQ,QuantityDistributionP[]}
];
listOfQuantityDistributionsP={quantityDistributionCoordinateP..};

(* Smoothing input patterns *)
SmoothingInputP = Alternatives[
	{ObjectP[{Object[Data]}]..},
	{(CoordinatesP|QuantityCoordinatesP[]|DistributionCoordinatesP|listOfQuantityDistributionsP)..}
];

SmoothingInputDataObjectP = Alternatives[
	ObjectP[{Object[Data]}]
];

SmoothingInputDataPacketP = Alternatives[
	PacketP[]
];

(* ::Subsection::Closed:: *)
(*AnalyzeSmoothing Messages*)

(* basic pattern complient, why the pattern doesn't match. followup action. appologatic reaction, unfortunately can't find...*)

Warning::NonAscendingOrderedDataSet="{x,y} coordinates of the dataset `1` is not in monotonically increasing order. This dataset will be sorted for smoothing purposes. If you intend to not to use sorting, select AscendingOrder-> False.";
Error::MismatchedUnits="The units for the input list `1` are mismatched.";
Error::MissingReferenceField="Cannot find the reference field for the object `1`. Please double-check this using Inspect[`1`] or use the option ReferenceField to input your desired field as ReferenceField -> field.";
Error::NonCompliantPattern="The current supported pattern for the dataset is a list of {x,y} coordinates, i.e. {{x1,y1},{x2,y2},..}. Please double-check this for object `1`.";
Error::EmptyReferenceField="Cannot find non-empty information in the ReferenceField provided for object `1`. Please double-check this using Inspect[`1`].";
Warning::NonEqualSpacedDataSet="{x,y} coordinates of the dataset `1` is not equally (evenly) spaced. An equally spaced dataset will be generated for smoothing purposes. If you intend to not use equal spacing, select EqualSpacing-> False.";
Error::OutOfBoundCutoffFrequency="The selected CutoffFrequency for dataset `1` is either larger than maximum possible frequency or smaller than minimum possible frequency. Please consider using for instance CutoffFrequency -> `2`. This will be either 10% larger than the minimum frequency for LowpassFilter and 10% smaller than maximum for HighpassFilter.";
Warning::OutOfBoundRadius="The selected Radius for dataset `1` is either larger than x-coordinate range or smaller than mean distance between data points. As a result, the Radius is automatically resolved to `2`. This will contain 10 data points in the neighborhood of each data point.";
Warning::UnusedRadius="The provided radius for dataset `1` is not used. The method `2` does not take Radius information. Consider using CutoffFrequency for manual control over the smoothing strength.";
Warning::UnusedCutoffFrequency="The provided CutoffFrequency for dataset `1` is not used. The method `2` does not take CutoffFrequency information. Consider using Radius for manual control over the smoothing strength";

(* ::Subsection::Closed:: *)
(*AnalyzeSmoothing Functions*)

(* ::Subsubsection:: *)
(*converting QunatityArray[Distributions] to list of quantity distributions*)

AnalyzeSmoothing[myInput: quantityArrayWrappedDistributionsP[]|{quantityArrayWrappedDistributionsP[]..}, myOptions: OptionsPattern[AnalyzeSmoothing]] := Module[
  {listedInputs,result,unitlessInputs,units,listOfQuantityDistributions},

  listedInputs=Switch[myInput,
    quantityArrayWrappedDistributionsP[],{myInput},
    {quantityArrayWrappedDistributionsP[]..},myInput];

  (* Converting to a list of quantity distributions array *)
  unitlessInputs=Map[
    Unitless[#, Units[#[[1]]]]&,
    listedInputs];
  units=Map[Units[#[[1]]]&,listedInputs];

  listOfQuantityDistributions=MapThread[
    myQuantityArray[#1,#2]&,
    {unitlessInputs,units}];

  result=AnalyzeSmoothing[listOfQuantityDistributions, myOptions];
  If[Length[result]>1 || MatchQ[result,$Failed],
    result,
    First[result]
  ]
];

(* ::Subsubsection:: *)
(*converting a list of quantities to a QuantityArray *)

AnalyzeSmoothing[myInput: listOfQuantitiesP|{listOfQuantitiesP..}, myOptions: OptionsPattern[AnalyzeSmoothing]] := Module[
  {listedInputs,unitChecks,units,quantityArrayInputs,result},

  listedInputs=Switch[myInput,
    listOfQuantitiesP,{myInput},
    {listOfQuantitiesP..},myInput];

  unitChecks=MapThread[
    If[SameQ@@UnitDimension[#1],
      True,
      Message[Error::MismatchedUnits,#2];False
    ]&,
    {listedInputs,Range[Length[listedInputs]]}
  ];

  If[MemberQ[unitChecks,False],
    Return[$Failed]
  ];

  (* Converting to a quantity array *)
  unitlessInputs=Map[
    Unitless[#, Units[#[[1]]]]&,
    listedInputs];
  units=Map[Units[#[[1]]]&,listedInputs];

  quantityArrayInputs=MapThread[
    QuantityArray[#1,#2]&,
    {unitlessInputs,units}];

  result=AnalyzeSmoothing[quantityArrayInputs, myOptions];
  If[Length[result]>1 || MatchQ[result,$Failed],
    result,
    First[result]
  ]
];

(* ::Subsubsection:: *)
(*single dataset list overload*)

AnalyzeSmoothing[myInput: (CoordinatesP|QuantityCoordinatesP[]|DistributionCoordinatesP|listOfQuantityDistributionsP), myOptions: OptionsPattern[AnalyzeSmoothing]] := Module[{result},
	result=AnalyzeSmoothing[{myInput}, myOptions];
	If[!MatchQ[result,_List] || Length[result]>1 || MatchQ[result,$Failed],
		result,
		First[result]
	]
];

(* ::Subsubsection:: *)
(*a single data object*)

AnalyzeSmoothing[myInput: SmoothingInputDataObjectP, myOptions: OptionsPattern[AnalyzeSmoothing]] := Module[{result},
	result=AnalyzeSmoothing[{myInput}, myOptions];
	If[!MatchQ[result,_List] || Length[result]>1 || MatchQ[result,$Failed],
		result,
		First[result]
	]
];

(* ::Subsubsection:: *)
(*a single protocol object*)

AnalyzeSmoothing[myProtocolObject: ObjectP[Object[Protocol]], myOptions: OptionsPattern[AnalyzeSmoothing]] := Module[
	{output},
	output = AnalyzeSmoothing[myProtocolObject[Data], myOptions]
];

(* ::Subsubsection:: *)
(*multiple protocol objects*)

AnalyzeSmoothing[myProtocolObjects: {ObjectP[Object[Protocol]]..}, myOptions: OptionsPattern[AnalyzeSmoothing]] := Module[
	{output},
	output = AnalyzeSmoothing[Flatten[myProtocolObjects[Data],1], myOptions]
];

(* ::Subsubsection:: *)
(*list of data object or a list of coordinates*)


AnalyzeSmoothing[myInputs: SmoothingInputP, myOptions: OptionsPattern[AnalyzeSmoothing]]:=Module[
  {
    listedInputs,listedOptions,outputSpecification,output,gatherTests,resolvedDataSets,safeOptions,
    safeOptionTests,tests,resultRule,unresolvedOptions,templateTests,combinedOptions,resolvedOptionsResult,
    resolvedOptions,resolvedOptionsTests,previewRule,testsRule,standardFieldsStart,analysisPacket,
    smoothedDataSets,smoothingPackets,smoothedResults,smoothedDataSetsStDev,smoothingResiduals,references,
    resolvedPackets
  },

  (* Make sure we're working with a list of options *)
	listedInputs=ToList[myInputs];
	listedOptions=ToList[myOptions];

  (* Determine the requested return value from the function *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Resolve standard start field *)
	standardFieldsStart = analysisPacketStandardFieldsStart[listedOptions];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];

  (* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests}=If[gatherTests,
		SafeOptions[AnalyzeSmoothing,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[AnalyzeSmoothing,listedOptions,AutoCorrect->False],Null}
	];

  (* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
  If[MatchQ[safeOptions,$Failed],
    Return[$Failed]
  ];

  (* Call ValidInputLengthsQ to make sure all options are the right length *)
  (* Silence the missing option errors *)
  {validLengths,validLengthTests}=Quiet[
    (* Valid length doesn't work fine for these two patterns *)
    If[!MatchQ[listedInputs, {{{UnitsP[],_?DistributionParameterQ|QuantityDistributionP[]}..}..}|{{{QuantityDistributionP[]|_?DistributionParameterQ,UnitsP[]}..}..}],
      If[gatherTests,
        ValidInputLengthsQ[AnalyzeSmoothing,{listedInputs},listedOptions,Output->{Result,Tests}],
        {ValidInputLengthsQ[AnalyzeSmoothing,{listedInputs},listedOptions],Null}
      ],
      {True,Null}
    ],
    Warning::IndexMatchingOptionMissing
  ];

  (* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[$Failed]
	];

  (* --- Resolve options --- *)

  (* Use any template options to get values for options not specified in myOptions *)
	{unresolvedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[AnalyzeSmoothing,{listedInputs},listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[AnalyzeSmoothing,{listedInputs},listedOptions],Null}
	];

  combinedOptions=ReplaceRule[safeOptions,unresolvedOptions];

  (* Call resolve<Function>Inputs *)
	(* Check will return $Failed if InvalidInput is thrown, indicating we can't actually return the standard result *)
	resolvedOptionsResult=Check[
		{{resolvedPackets,resolvedDataSets,resolvedOptions},resolvedOptionsTests}=If[gatherTests,
			resolveAnalyzeSmoothingOptions[listedInputs,combinedOptions,Output->{Result,Tests}],
			{resolveAnalyzeSmoothingOptions[listedInputs,combinedOptions],Null}
		],
		$Failed,
		{Error::InvalidInput,Error::InvalidOption}
	];

  (* -- Handling the core smoothing analysis -- *)

  (* Smoothing all of the datasets one by one *)
  smoothedResults=MapIndexed[smoothDataSet[#1,First[#2],resolvedOptions]&,resolvedDataSets];
  (* Extracting the information from the output of the smoothDataSet function *)
  smoothedDataSets=smoothedResults[[All,1]];
  smoothingResiduals=smoothedResults[[All,2]];
  smoothedDataSetsStDev=smoothedResults[[All,3]];

  (* -- Handling Output -- *)

  (* The original references that is used for smoothing analysis *)
  references=Map[
    Function[resolvedPacket,
      Switch[resolvedPacket,
        PacketP[], Replace[Lookup[resolvedPacket,Object],Except[ObjectReferenceP[]]->Null],
        _, Null
      ]
    ],
    resolvedPackets
  ];

  (* Format Smoothing packets *)
  smoothingPackets=MapThread[
    Function[{resolvedDataSet,frequency,radius,smoothedDataSet,smoothingResidual,smoothedDataSetStDev,reference},
      <|
        Type -> Object[Analysis, Smoothing],
        ResolvedDataPoints -> resolvedDataSet,
        CutoffFrequency -> frequency,
        Radius -> radius,
        SmoothedDataPoints -> smoothedDataSet,
        Residuals -> smoothingResidual,
        TotalResidual ->
          Which[
            MatchQ[resolvedDataSet,Null|{}],Null,
            Length[resolvedDataSet]==1,0,
            True,N@Sqrt[Mean[smoothingResidual^2]]
          ],
        SmoothingLocalStandardDeviation -> smoothedDataSetStDev,
        UnresolvedOptions -> unresolvedOptions,
        ResolvedOptions -> resolvedOptions,
        Append[Reference] -> DeleteCases[{Link[reference, SmoothingAnalyses]},Null]
      |>
    ],
    {
      resolvedDataSets,Lookup[resolvedOptions,CutoffFrequency],Lookup[resolvedOptions,Radius],
      smoothedDataSets,smoothingResiduals,smoothedDataSetsStDev,references
    }
  ];

  (* Prepare the Preview result if we were asked to do so *)
  previewRule=Preview->If[MemberQ[output,Preview],
    Module[{plots},
      plots = PlotSmoothing[smoothingPackets,Zoomable->True];
      If[Length[plots] === 1, First[plots], SlideView[plots]]
    ],
    Null
  ];

  (* If User requested for Result, either Upload the packet and return constellation messsage (if Upload->True) OR give the upload packet list (if Upload->False) *)
	resultRule=Result->If[MemberQ[output,Result],
    Which[
      MatchQ[resolvedOptionsResult,$Failed], $Failed,
      Lookup[resolvedOptions,Upload], Upload[smoothingPackets],
      True, smoothingPackets
    ],
    Null
  ];

  (* Prepare the Test result if we were asked to do so *)
  testsRule=Tests->If[MemberQ[output,Tests],
    (* Join all exisiting tests generated by helper functions with any additional tests *)
    Join[safeOptionTests,validLengthTests,templateTests,resolvedOptionsTests],
    Null
  ];

  outputSpecification/.{resultRule,testsRule,Options->resolvedOptions,previewRule}

];

(* ::Subsubsection:: *)
(*resolveAnalyzeSmoothingOptions*)


DefineOptions[resolveAnalyzeSmoothingOptions,
	Options:>{
		{Output->Result,ListableP[Result|Tests],"Indicates the return value of the function."}
	}
];


resolveAnalyzeSmoothingOptions[myInputs: SmoothingInputP,combinedOptions: {(_Rule|_RuleDelayed)..},myOptions: OptionsPattern[resolveAnalyzeSmoothingOptions]]:=Module[
	{
    listedInputs,output,listedOutput,collectTestsBoolean,messagesBoolean,dataSets,
    allTests,dataSetsPatternTestDescription,dataSetsPatternTestTuples,patternCheckedDataSets,
    dataSetsPatternTests,dataSetsEqualSpacingTestTuples,equalSpacedDataSets,dataSetsEqualSpacingTests,
    unitlessDataSets,equalSpacings,equalSpacing,referenceFieldTestDescription,referenceFieldsTuples,
    myPackets,resolvedReferenceFields,referenceFieldTests,methods,radii,frequencies,validCutoffFrequencyDescription,
    validRadiusDescription,resolvedSmoothingRangeTuples,resolvedCutoffFrequency,validCutoffFrequencyTest,
    resolvedRadius,validRadiusTest,ascendingOrders,dataSetsAscendingOrderTestDescription,dataSetsAscendingOrderTestTuples,
    ascendingOrderedDataSets,dataSetsAscendingOrderTests
  },

  (* get Output value *)
  output=OptionDefault[OptionValue[Output]];
  listedOutput=ToList[output];
  collectTestsBoolean=MemberQ[listedOutput,Tests];

  (* Print messages whenever we're not getting tests instead *)
	messagesBoolean=!collectTestsBoolean;

  expandedOptions=Last[ExpandIndexMatchedInputs[AnalyzeSmoothing,{myInputs},combinedOptions]];

  (* Data objects packets *)
  myPackets = If[MatchQ[myInputs,ListableP[ObjectP[]]],Download[myInputs],ConstantArray[Null,Length[myInputs]]];
  referenceFields=Lookup[expandedOptions,ReferenceField];

  (* --- Resolve object ReferenceFields --- *)
  referenceFieldTestDescription="The ReferenceFields should be non-empty.";
  referenceFieldsTuples=MapThread[
    Function[{myInput,myPacket,referenceField,inputIndex},
      Switch[{myInput,referenceField},

        {SmoothingInputDataObjectP,Automatic},
        {lookupReferenceField[myInput,myPacket],testOrNull[collectTestsBoolean,referenceFieldTestDescription,True]},

        {SmoothingInputDataObjectP,Except[Automatic]},
        If[checkReferenceField[myPacket,referenceField],
          {referenceField,testOrNull[collectTestsBoolean,referenceFieldTestDescription,True]},
          Module[{},
  					If[messagesBoolean,Message[Error::EmptyReferenceField,referenceField];Message[Error::InvalidOption,myInput]];
            {Null,testOrNull[collectTestsBoolean,referenceFieldTestDescription,False]}
          ]
        ],

        {Except[SmoothingInputDataObjectP],_},
        {Null,testOrNull[collectTestsBoolean,referenceFieldTestDescription,True]}
      ]
    ],
    {myInputs,myPackets,referenceFields,Range[Length[myInputs]]}
  ];

  resolvedReferenceFields=Replace[referenceFieldsTuples[[All,1]],{}->Null,{0}];
  referenceFieldTests=referenceFieldsTuples[[All,2]];

  (* Parsing the object packets found in the previous part, to find the datasets *)
  dataSets=MapThread[
    Function[{myInput,myPacket,resolvedReferenceField,inputIndex},
      Switch[{myInput,myPacket,resolvedReferenceField},
        {SmoothingInputDataObjectP,$Failed|Null|{},_},Message[Error::InvalidInput,inputIndex];Null,

        {SmoothingInputDataObjectP,Except[$Failed|Null|{}],$Failed|Null|{}},Null,

        {SmoothingInputDataObjectP,Except[$Failed|Null|{}],Except[$Failed|Null|{}]},
        Lookup[myPacket,resolvedReferenceField],

        {Except[SmoothingInputDataObjectP],_,_},myInput
      ]
    ],
    {myInputs,myPackets,resolvedReferenceFields,Range[Length[myInputs]]}
  ];

  (* --- Check dataset patterns --- *)

  dataSetsPatternTestDescription="DataSet is assumed to be {{x1,y1},{x2,y2},..} for now and later it will be extended to multi-dimensions.";
  dataSetsPatternTestTuples=MapThread[
    Function[{myInput,dataSet,inputIndex},
      Switch[{myInput,dataSet},
        {_,Null|{}},
        {dataSet,testOrNull[collectTestsBoolean,dataSetsPatternTestDescription,False]},

        {(CoordinatesP|QuantityCoordinatesP[]|DistributionCoordinatesP|listOfQuantityDistributionsP),Except[Null|{}]},
        {dataSet,testOrNull[collectTestsBoolean,dataSetsPatternTestDescription,True]},

        {SmoothingInputDataObjectP,(CoordinatesP|QuantityCoordinatesP[]|DistributionCoordinatesP|listOfQuantityDistributionsP)},
        {dataSet,testOrNull[collectTestsBoolean,dataSetsPatternTestDescription,True]},

        {SmoothingInputDataObjectP,Except[(CoordinatesP|QuantityCoordinatesP[]|DistributionCoordinatesP|listOfQuantityDistributionsP)]},
        Module[{},
					If[messagesBoolean,Message[Error::NonCompliantPattern,inputIndex];Message[Error::InvalidOption,myInput]];
          {Null,testOrNull[collectTestsBoolean,dataSetsPatternTestDescription,False]}
        ]
      ]
    ],
    {myInputs,dataSets,Range[Length[myInputs]]}
  ];

  patternCheckedDataSets=Replace[dataSetsPatternTestTuples[[All,1]],{}->Null,{0}];
  dataSetsPatternTests=dataSetsPatternTestTuples[[All,2]];

  (* --- Check dataset ascending order --- *)

  ascendingOrders=Lookup[expandedOptions,AscendingOrder];

  dataSetsAscendingOrderTestDescription=" {x,y} coordinates of the datasets are assumed to be in ascending order. Otherwise, we sort them.";
  dataSetsAscendingOrderTestTuples=
    MapThread[
      Function[{myInput,dataSet,inputIndex,ascendingOrder},
        If[!MatchQ[dataSet,Null|{}],
          Which[
            ascendingOrdered[dataSet],
            {dataSet,warningOrNull[collectTestsBoolean,dataSetsAscendingOrderTestDescription,True]},

            !ascendingOrdered[dataSet] && !ascendingOrder,
            {dataSet,warningOrNull[collectTestsBoolean,dataSetsAscendingOrderTestDescription,True]},

            !ascendingOrdered[dataSet] && ascendingOrder,
            Message[Warning::NonAscendingOrderedDataSet,inputIndex];
            {makeAscendingOrdered[dataSet],warningOrNull[collectTestsBoolean,dataSetsAscendingOrderTestDescription,False]}
          ],
          {Null,warningOrNull[collectTestsBoolean,dataSetsAscendingOrderTestDescription,False]}
        ]
      ],
      {myInputs,patternCheckedDataSets,Range[Length[myInputs]],ascendingOrders}
    ];

  ascendingOrderedDataSets=Replace[dataSetsAscendingOrderTestTuples[[All,1]],{}->Null,{0}];
  dataSetsAscendingOrderTests=dataSetsAscendingOrderTestTuples[[All,2]];

  (* --- Check dataset equal spacing --- *)

  equalSpacings=Lookup[expandedOptions,EqualSpacing];

  dataSetsEqualSpacingTestDescription=" {x,y} coordinates of the datasets are assumed to be equally spaced. Otherwise, we make them equally spaced.";
  dataSetsEqualSpacingTestTuples=
    MapThread[
      Function[{myInput,dataSet,inputIndex,equalSpacing},
        If[!MatchQ[dataSet,Null|{}],
          Which[
            !equalSpacing,
            {dataSet,warningOrNull[collectTestsBoolean,dataSetsEqualSpacingTestDescription,True]},

            equalSpaced[dataSet],
            {dataSet,warningOrNull[collectTestsBoolean,dataSetsEqualSpacingTestDescription,True]},

            True,
            Message[Warning::NonEqualSpacedDataSet,inputIndex];
            {makeEqualSpaced[dataSet],warningOrNull[collectTestsBoolean,dataSetsEqualSpacingTestDescription,False]}
          ],
          {Null,warningOrNull[collectTestsBoolean,dataSetsEqualSpacingTestDescription,False]}
        ]
      ],
      {myInputs,ascendingOrderedDataSets,Range[Length[myInputs]],equalSpacings}
    ];

  equalSpacedDataSets=Replace[dataSetsEqualSpacingTestTuples[[All,1]],{}->Null,{0}];
  dataSetsEqualSpacingTests=dataSetsEqualSpacingTestTuples[[All,2]];

  (* --- Resolve CutoffFrequency and Radius --- *)

  methods=Lookup[expandedOptions,Method];
  radii=Lookup[expandedOptions,Radius];
  frequencies=Lookup[expandedOptions,CutoffFrequency];

  validCutoffFrequencyDescription="The cutoff frequency should be between 1/domain range of x-coordinates and 1/distance of the two data points.";
  validRadiusDescription="The smoothing radius should be between distance of the two data points and the domain range of the x-coordinates.";

  resolvedSmoothingRangeTuples=MapThread[
    Function[{equalSpaceddataSet,method,frequency,radius,inputIndex},
      Switch[method,
        (LowpassFilter|HighpassFilter),
        If[!MatchQ[radius,Automatic|Null|{}],Message[Warning::UnusedRadius,inputIndex,method]];
        Switch[{equalSpaceddataSet,frequency},
          {Null|{},_},
          {frequency,testOrNull[collectTestsBoolean,validRadiusDescription,False],Null,Null},

          {Except[Null|{}],Automatic},
      		{resolveCutoffFrequency[equalSpaceddataSet,method],testOrNull[collectTestsBoolean,validRadiusDescription,True],Null,Null},

          {Except[Null|{}],_?NumericQ|_Quantity},
          Module[{},
            If[checkCutoffFrequency[equalSpaceddataSet,frequency,method],
              {frequency,testOrNull[collectTestsBoolean,validCutoffFrequencyDescription,True],Null,Null},
              If[messagesBoolean,Message[Error::OutOfBoundCutoffFrequency,inputIndex,resolveCutoffFrequency[equalSpaceddataSet,method]];Message[Error::InvalidOption,CutoffFrequency]];
              {frequency,testOrNull[collectTestsBoolean,validRadiusDescription,False],Null,Null}
            ]
          ]
        ],

        Except[(LowpassFilter|HighpassFilter)],
        If[!MatchQ[frequency,Automatic|Null|{}],Message[Warning::UnusedCutoffFrequency,inputIndex,method]];
        Switch[{equalSpaceddataSet,radius},
          {Null|{},_},
          {Null,Null,radius,testOrNull[collectTestsBoolean,validCutoffFrequencyDescription,False]},

          {Except[Null|{}],Automatic},
      		{Null,Null,resolveRadius[equalSpaceddataSet,method],testOrNull[collectTestsBoolean,validCutoffFrequencyDescription,True]},

          {Except[Null|{}],_?NumericQ|_Quantity},
          Module[{},
            If[checkRadius[equalSpaceddataSet,radius],
              {Null,Null,radius,testOrNull[collectTestsBoolean,validRadiusDescription,True]},
              If[messagesBoolean,
                Message[Warning::OutOfBoundRadius,inputIndex,resolveRadius[equalSpaceddataSet,method]];
              ];
              {Null,Null,resolveRadius[equalSpaceddataSet,method],testOrNull[collectTestsBoolean,validRadiusDescription,False]}
            ]
          ]
        ]
      ]
    ],
    {equalSpacedDataSets,methods,frequencies,radii,Range[Length[equalSpacedDataSets]]}
  ];

  (* Parsing out the result of the previous section to find each of the resolvedCutoffFrequency and resolvedRadius *)
  resolvedCutoffFrequency=resolvedSmoothingRangeTuples[[All,1]];
  validCutoffFrequencyTest=resolvedSmoothingRangeTuples[[All,2]];
  resolvedRadius=resolvedSmoothingRangeTuples[[All,3]];
  validRadiusTest=resolvedSmoothingRangeTuples[[All,4]];

  (* Gather all the tests (this will be a list of Nulls if !Output->Test) *)
  allTests=Join[referenceFieldTests,dataSetsPatternTests,dataSetsAscendingOrderTests,dataSetsEqualSpacingTests,validCutoffFrequencyTest,validRadiusTest];

  (* Update options *)
  resolvedOptions=ReplaceRule[combinedOptions,
    {
      CutoffFrequency -> resolvedCutoffFrequency,
      Radius -> resolvedRadius,
      ReferenceField -> resolvedReferenceFields
    }
  ];

  output/.{Tests->allTests,Result->{myPackets,equalSpacedDataSets,resolvedOptions}}

];

(* ::Subsubsection:: *)
(*Helpers for resolveAnalyzeSmoothingOptions*)

(* checkReferenceField: Check if the reference field exists and is not empty *)
(* Input:
	myPacket - the packet associated with the input objects in the code
  field - the field which is provided by the user directly
*)
checkReferenceField[myPacket: SmoothingInputDataPacketP, field_Symbol]:=KeyExistsQ[myPacket,field] && !MatchQ[Lookup[myPacket,field], $Failed | Null | {}];

(* lookupReferenceField: Finds the fields that are not Null in the input objects *)
(* Input:
  myObject - the input objects to lookup the fields for
	myPacket - the packet associated with the input objects in the code
*)
lookupReferenceField[myObject: SmoothingInputDataObjectP, myPacket: SmoothingInputDataPacketP]:=Module[{type,field},
  type=Lookup[myPacket,Type];
  (* All possible fields *)
  possibleFields=Flatten[Cases[SmoothingInputDataTypes,{type,_}][[All,2]]];
  (* The field is the only one that is not Null or {}. The assumption is that there is only one. Revisit later!!! *)
  field=Select[possibleFields,
    ! MatchQ[Lookup[myPacket,#], $Failed | Null] &
  ];
  (* Note that the first matching field will be taken, but the user can specify ReferenceField to get it explicitly *)
  Which[
    MatchQ[field,{}|Null],Message[Error::MissingReferenceField,myObject];Message[Error::InvalidInput,myObject],
    True,First[field]
  ]
];

(* testOrNull: Simple helper that returns a Test whose expected value is True if makeTest->True, Null otherwise *)
(* Input:
	makeTest - Boolean indicating if we should create a test
	description - test description
	expression - value we expect to be True
*)
testOrNull[makeTest:BooleanP,description_,expression_]:=If[makeTest,
	Test[description,expression,True],
	Null
];

(* warningOrNull: Simple helper that returns a Warning if makeTest->True, Null otherwise *)
(* Input:
	makeTest - Boolean indicating if we should create a warning
	description - warning description
	expression - value we expect to be True
*)
warningOrNull[makeTest:BooleanP,description_,expression_]:=If[makeTest,
	Warning[description,expression,True],
	Null
];

(* myQuantityMagnitude: to be able to work on distributions *)
(* Input:
	dataSet - a list of coordinates or quantity array or distributions
*)
myQuantityMagnitude[dataSet: (CoordinatesP|QuantityCoordinatesP[]|DistributionCoordinatesP|listOfQuantityDistributionsP)]:=Module[{},
  Switch[dataSet,
    (* QuantityMagnitude works fine for these *)
    Alternatives[
      CoordinatesP,
      QuantityCoordinatesP[],
      {{QuantityDistributionP[],QuantityDistributionP[]}..},
      {{UnitsP[],QuantityDistributionP[]}..},
      {{QuantityDistributionP[],UnitsP[]}..}
    ],
    QuantityMagnitude[dataSet],

    (* Nondimensional distribution at x *)
    Alternatives[
      {{_?DistributionParameterQ,QuantityDistributionP[]}..},
      {{_?DistributionParameterQ,UnitsP[]}..}
    ],
    Transpose[{dataSet[[All,1]],QuantityMagnitude[dataSet[[All,2]]]}],

    (* Nondimensional distribution at y *)
    Alternatives[
      {{QuantityDistributionP[],_?DistributionParameterQ}..},
      {{UnitsP[],_?DistributionParameterQ}..}
    ],
    Transpose[{QuantityMagnitude[dataSet[[All,1]]],dataSet[[All,2]]}]
  ]
];

(* myQuantityArray: to be able to work on distributions *)
(* Input:
	dataSet - a list of coordinates or quantity array or distributions
*)
myQuantityArray[dataSet: (CoordinatesP|DistributionCoordinatesP), units_List]:=Module[{},
  Switch[dataSet,
    (* Coordinates is good here *)
    CoordinatesP,
    QuantityArray[dataSet,units],

    (* For distributions *)
    {{_?NumericQ,_?DistributionParameterQ}..},Map[{Quantity[#[[1]],units[[1]]],QuantityDistribution[#[[2]],units[[2]]]}&,dataSet],
    {{_?DistributionParameterQ,_?NumericQ}..},Map[{QuantityDistribution[#[[1]],units[[1]]],Quantity[#[[2]],units[[2]]]}&,dataSet],
    {{_?DistributionParameterQ,_?DistributionParameterQ}..},Map[{QuantityDistribution[#[[1]],units[[1]]],QuantityDistribution[#[[2]],units[[2]]]}&,dataSet]
  ]
];

myUnits[coordinate: (_?QuantityArrayQ|{(UnitsP[]|_?DistributionParameterQ|QuantityDistributionP[]),(UnitsP[]|_?DistributionParameterQ|QuantityDistributionP[])})]:=Module[{},
  Switch[coordinate,
    (* Coordinates is good here *)
    (_?QuantityArrayQ|{(UnitsP[]|QuantityDistributionP[]),(UnitsP[]|QuantityDistributionP[])}),
    Units[coordinate],

    (* For distributions *)
    {_?DistributionParameterQ,_},
    {1,Units[coordinate[[2]]]},

    {_,_?DistributionParameterQ},
    {Units[coordinate[[1]]],1}
  ]
];

(* separateXY: to be able to work on distributions *)
(* Input:
	dataSet - a list of coordinates or quantity array or distributions
*)
separateXY[dataSet: (CoordinatesP|QuantityCoordinatesP[]|DistributionCoordinatesP|listOfQuantityDistributionsP)]:=Module[{},
  Switch[dataSet,
    (* Coordinates is good here *)
    CoordinatesP,Transpose[dataSet],
    (* For distributions *)
    {{_?DistributionParameterQ,_?DistributionParameterQ}..},{Map[Mean,dataSet[[All,1]]],Map[Mean,dataSet[[All,2]]]},
    {{_?NumericQ,_?DistributionParameterQ}..},{dataSet[[All,1]],Map[Mean,dataSet[[All,2]]]},
    {{_?DistributionParameterQ,_?NumericQ}..},{Map[Mean,dataSet[[All,1]]],dataSet[[All,2]]}
  ]
];

(* ascendingOrdered: helper that checks if the datapoints in the dataset provided is in ascending order *)
(* Input:
	dataSet - a list of coordinates or quantity array
*)
ascendingOrdered[dataSet: (CoordinatesP|QuantityCoordinatesP[]|DistributionCoordinatesP|listOfQuantityDistributionsP)]:=Module[{unitlessDataSet,xVals},

  (* Preparing the input dataset *)
  unitlessDataSet=myQuantityMagnitude[dataSet];

  (* The mean value of x coordinates *)
  xVals=If[MatchQ[unitlessDataSet[[1,1]],_?DistributionParameterQ],
    Mean[unitlessDataSet[[All,1]]],
    unitlessDataSet[[All,1]]
  ];

  OrderedQ[unitlessDataSet]
];

(* makeAscendingOrdered: helper that transforms the dataset to ensure that they are in ascending order *)
(* Input:
	dataSet - a list of coordinates or quantity array
*)
makeAscendingOrdered[dataSet: (CoordinatesP|QuantityCoordinatesP[]|DistributionCoordinatesP|listOfQuantityDistributionsP)]:=Module[
  {unitlessDataSet,dataSetUnit,ascendingOrderedDataSet},

  (* Preparing the input dataset *)
  unitlessDataSet=myQuantityMagnitude[dataSet];

  (* The units of the dataset *)
  dataSetUnit=myUnits[First[dataSet]];

  (* Making the equal spaced set of coordinates which prevserves the same total number of data points *)
  ascendingOrderedDataSet=SortBy[unitlessDataSet,First];

  (* Retaining the units *)
  myQuantityArray[ascendingOrderedDataSet,dataSetUnit]
];

(* equalSpaced: helper that checks if the datapoints in the dataset provided is equally (evenly) spaced *)
(* Input:
	dataSet - a list of coordinates or quantity array
*)
equalSpaced[dataSet: (CoordinatesP|QuantityCoordinatesP[]|DistributionCoordinatesP|listOfQuantityDistributionsP)]:=Module[{xVals,diff},

  (* If we have only one data point *)
  If[Length[dataSet]==1,Return[dataSet]];

  (* The mean value of x coordinates *)
  xVals=If[MatchQ[dataSet[[1,1]],_?DistributionParameterQ],
    Mean[dataSet[[All,1]]],
    dataSet[[All,1]]
  ];

  (* Distance between the data points rounded to 4 significant digits *)
  diff = Round[Abs[Differences[xVals]],0.0001];

  (* Check if all elements are the same *)
  If[Equal@@diff,True,False]
];

(* makeEqualSpaced: helper that transforms the dataset to ensure that they are equally (evenly) spaced *)
(* Input:
	dataSet - a list of coordinates or quantity array
*)
makeEqualSpaced[dataSet: (CoordinatesP|QuantityCoordinatesP[]|DistributionCoordinatesP|listOfQuantityDistributionsP)]:=Module[
  {arcLength,xVals,yVals,xInterp,yInterp,unitlessDataSet,dataSetUnit,equalSpacedDataSet},

  (* If we have only one data point *)
  If[Length[dataSet]==1,Return[dataSet]];

  (* Preparing the input dataset *)
  unitlessDataSet=myQuantityMagnitude[dataSet];

  (* The units of the dataset *)
  dataSetUnit=myUnits[First[dataSet]];

  (* Separating x and y values *)
  {xVals, yVals} = separateXY[unitlessDataSet];

  (* Method 1: Making a function which gives y values as a function of x                              *)
  (* Making the equal spaced set of coordinates which prevserves the same total number of data points *)
  (* Method 2: when data is not sorted: If we want to interpolate based on the arcLength              *)
  (* The arc length along the curve which is made from the {x,y} coordinates                          *)
  (* Making a function which gives x/y values as a function of the arclength across the {x,y} line    *)
  (* The second approach is used, so the data doesn't fold back on itself which causes interp issue   *)
  (* arcLength uses transpose of xVals and yVals to ensure the correct behavior for distributions     *)

  equalSpacedDataSet=Module[{arcLength,xInterp,yInterp},
    arcLength = Rescale@Prepend[0]@Accumulate[Norm /@ Differences[Transpose[{xVals,yVals}]]];
    xInterp = Interpolation[Transpose[{arcLength, xVals}], InterpolationOrder -> 1];

    yInterp=If[ascendingOrdered[dataSet],
      Interpolation[Transpose[{xVals, yVals}], InterpolationOrder -> 1],
      Interpolation[Transpose[{arcLength, yVals}], InterpolationOrder -> 1]
    ];
    If[ascendingOrdered[dataSet],
      Table[{x,N@yInterp[x]}, {x, Min[xVals], Max[xVals], (Max[xVals]-Min[xVals])/(Length[dataSet]-1)}],
      Table[Through[{N@xInterp, N@yInterp}[t]], {t, 0, 1, 1/(Length[dataSet]-1)}]
    ]
  ];

  (* Retaining the units *)
  QuantityArray[equalSpacedDataSet,dataSetUnit]
];

(* checkCutoffFrequency: checks whether the CutoffFrequency is within the proper bound *)
(* Input:
	dataSet - a list of coordinates or quantity array
  frequency - the CutoffFrequency that is provided by the user
  method - eitehr LowpassFilter or HighpassFilter
*)
checkCutoffFrequency[dataSet: (CoordinatesP|QuantityCoordinatesP[]|DistributionCoordinatesP|listOfQuantityDistributionsP), frequency: (_?NumericQ|_Quantity), method: SmoothingMethodP]:=Module[
  {xVals,quantityFrequency,interDistance,largestFrequency,smallestFrequency},

  (* If we have only one data point *)
  If[Length[dataSet]==1,Return[False]];

  (* The mean value of x coordinates *)
  xVals=If[MatchQ[dataSet[[1,1]],_?DistributionParameterQ],
    Mean[dataSet[[All,1]]],
    dataSet[[All,1]]
  ];

  (* the distance between the data points *)
  interDistance = Mean[Abs[Differences[xVals]]];

  (* The proper units for the frequency should be selected based on the pair of the interDistance and frequency *)
  quantityFrequency = Switch[{frequency,interDistance},
    {_Quantity,_Quantity},frequency,
    {_?NumericQ,_?NumericQ},frequency,
    {_Quantity,_?NumericQ},Unitless[frequency],
    {_?NumericQ,_Quantity},Quantity[frequency,Units[1/interDistance]]
  ];
  (* Largest and smallest possible values of the frequency is determined based on the dataset. *)
  largestFrequency = 1/interDistance;
  smallestFrequency = 1/(interDistance*Length[dataSet]);
  If[quantityFrequency < smallestFrequency || quantityFrequency > largestFrequency,
    False,
    True
  ]
];

(* resolveCutoffFrequency: resolves the CutoffFrequency *)
(* Input:
	dataSet - a list of coordinates or quantity array
  method - eitehr LowpassFilter or HighpassFilter
*)
resolveCutoffFrequency[dataSet: (CoordinatesP|QuantityCoordinatesP[]|DistributionCoordinatesP|listOfQuantityDistributionsP), method: SmoothingMethodP]:=Module[
  {xVals,interDistance,largestFrequency,smallestFrequency},

  (* If we have only one data point *)
  If[Length[dataSet]==1,Return[0]];

  (* The mean value of x coordinates *)
  xVals=If[MatchQ[dataSet[[1,1]],_?DistributionParameterQ],
    Mean[dataSet[[All,1]]],
    dataSet[[All,1]]
  ];

  (* the distance between the data points *)
  interDistance = Mean[Abs[Differences[xVals]]];

  (* Largest and smallest possible values of the frequency is determined based on the dataset. *)
  largestFrequency = 1/interDistance;
  smallestFrequency = 1/(interDistance*Length[dataSet]);

  (* A choice of 10% larger than smallest possible frequency or 10% smaller than largest possible frequency for LowpassFilter and HighpassFilter, respectively *)
  Switch[method,
    LowpassFilter,smallestFrequency+0.1*smallestFrequency,
    HighpassFilter,largestFrequency-0.1*largestFrequency
  ]
];

(* checkRadius: checks whether the Radius is within the proper bound *)
(* Relies on the data being in ascending (or descending) order *)
(* Input:
	dataSet - a list of coordinates or quantity array
  radius - the Radius provided by the user
*)
checkRadius[dataSet: (CoordinatesP|QuantityCoordinatesP[]|DistributionCoordinatesP|listOfQuantityDistributionsP), radius: (_?NumericQ|_Quantity)]:=Module[
  {xVals,domainRange,interDistance,quantityRadius},

  (* If we have only one data point *)
  If[Length[dataSet]==1,Return[False]];

  (* The mean value of x coordinates *)
  xVals=If[MatchQ[dataSet[[1,1]],_?DistributionParameterQ],
    Mean[dataSet[[All,1]]],
    dataSet[[All,1]]
  ];

  (* The range of x-coordinate based on the input dataset *)
  domainRange = MinMax[xVals] /. {x_,y_} :> y-x;
  (* The distance between the data points. Since the data is in ascending order we can calculate the
  mean distance using the first and last data points *)
  interDistance = Abs[Last[xVals] - First[xVals]] / (Length[xVals] - 1);

  (* The proper units for the radius should be selected based on the pair of the interDistance and radius *)
  quantityRadius = Switch[{radius,interDistance},
    {_Quantity,_Quantity},radius,
    {_?NumericQ,_?NumericQ},radius,
    {_Quantity,_?NumericQ},Unitless[radius],
    {_?NumericQ,_Quantity},Quantity[radius,Units[interDistance]]
  ];
  If[quantityRadius < interDistance || quantityRadius >= domainRange,
    False,
    True
  ]
];

(* resolveRadius: resolves the radius such that there is at least 20 data points in the neightborhood of each datapoint *)
(* Input:
	dataSet - a list of coordinates or quantity array
*)
resolveRadius[dataSet: (CoordinatesP|QuantityCoordinatesP[]|DistributionCoordinatesP|listOfQuantityDistributionsP), method: SmoothingMethodP]:=Module[
  {xVals,interDistance},

  (* If we have only one data point *)
  If[Length[dataSet]==1,Return[0]];

  (* The mean value of x coordinates *)
  xVals=If[MatchQ[dataSet[[1,1]],_?DistributionParameterQ],
    Mean[dataSet[[All,1]]],
    dataSet[[All,1]]
  ];

  interDistance = Mean[Abs[Differences[xVals]]];
  10*interDistance
];


(* ::Subsubsection:: *)
(*smooth a single data-set here*)

(* smoothDataSet: the core function which runs the Mathematica intrinsic filter functions to smooth the data *)
(* Input:
	dataSets - the lists of the dataSets each contain a list of coordinates or quantity array
  index - the index of the dataSet lists
  resolvedOptions - the resolved options
*)

smoothDataSet[dataSet: CoordinatesP|QuantityCoordinatesP[]|DistributionCoordinatesP|listOfQuantityDistributionsP,index_Integer,resolvedOptions:{(_Rule|_RuleDelayed)..}]:= Module[
  {unitlessDataSet,unitlessDependent,unitlessIndependent,interDistance,dataSetUnit,method,radius,radiusInteger,frequency,
  smoothedDependent,smoothedDataSet,smoothedDependentStDev,smoothedDataSetStDev,smoothedDependentResiduals,baselineAdjust,
  adjustedDependent},

  (* If we have only one data point, return itself *)
  If[Length[dataSet]==1,Return[{dataSet,0,dataSet}]];

  (* Preparing a list of unitless input datasets *)
  unitlessDataSet=myQuantityMagnitude[dataSet];

  (* Separating x and y values *)
  {unitlessIndependent, unitlessDependent} = separateXY[unitlessDataSet];

  interDistance=Mean[Abs[Differences[unitlessIndependent]]];

  dataSetUnit=myUnits[First[dataSet]];

  (* --- Smoothing --- *)

  (* Right now is SG is with degree 3 later will correct that *)

  (* The method that should be used for smoothing *)
  method=Module[{method0},
    method0=ToList[Lookup[resolvedOptions,Method]];
    If[Length[method0]==1,First[method0],method0[[index]]]
  ];
  (* Whether we need to baseline adjust prior to smoothing *)
  baselineAdjust=Module[{baselineAdjust0},
    baselineAdjust0=ToList[Lookup[resolvedOptions,BaselineAdjust]];
    If[Length[baselineAdjust0]==1,First[baselineAdjust0],baselineAdjust0[[index]]]
  ];

  (* Convert radius based on the units of the x-values and finally to an integer number of data points *)
  radius=Module[{radiusQuantity},
    radiusQuantity=Part[Lookup[resolvedOptions,Radius],index];
    Switch[{radiusQuantity,dataSetUnit[[1]]},
      {_Quantity,_Quantity},Convert[radiusQuantity,dataSetUnit[[1]]],
      {_?NumericQ,_?NumericQ},radiusQuantity,
      {_Quantity,_?NumericQ},Unitless[radiusQuantity],
      {_?NumericQ,_Quantity},radiusQuantity,
      {_,_},radiusQuantity
    ]
  ];
  (* If the interDistance is close to zero, replace the roundedRadius/radiusInteger with 1 *)
  (* The zero interDistance can only occur if the data points are all vertical *)
  radiusInteger=Module[{roundedRadius},
    roundedRadius=If[MatchQ[First[Threshold[{interDistance},10^-10]],0|0.],
      1,
      IntegerPart@Unitless[SafeRound[(radius /. {Null -> 1})/interDistance, 1, AvoidZero -> True]]
    ];
    If[roundedRadius<=0,1,roundedRadius]
  ];
  (* First convert frequency to 1/unit of x-values and then make it unitless the way the LowpassFilter is expecting *)
  frequency=Module[{frequencyQuantity},
    frequencyQuantity=Part[Lookup[resolvedOptions,CutoffFrequency],index];
    Switch[{frequencyQuantity,dataSetUnit[[1]]},
      {_Quantity,_Quantity},Unitless[Convert[frequencyQuantity,1/dataSetUnit[[1]]]],
      {_?NumericQ,_?NumericQ},frequencyQuantity,
      {_Quantity,_?NumericQ},Unitless[frequencyQuantity],
      {_?NumericQ,_Quantity},frequencyQuantity,
      {_,_},frequencyQuantity
    ]
  ];
  (* Do we need to Baseline adjust the dataset? *)
  adjustedDependent=If[baselineAdjust,
    EstimatedBackground[unitlessDependent,radiusInteger],
    unitlessDependent
  ];
  (* Smoothing the dependent variable based on the choice of the method *)
  smoothedDependent=Switch[method,

    Mean, MeanFilter[adjustedDependent, radiusInteger],
    Median, MedianFilter[adjustedDependent, radiusInteger],
    Gaussian, GaussianFilter[adjustedDependent, radiusInteger],
    Bilateral, BilateralFilter[adjustedDependent, radiusInteger, radiusInteger, MaxIterations -> 10],
    TrimmedMean, ArrayFilter[TrimmedMean, adjustedDependent, radiusInteger],
    MeanShift, MeanShiftFilter[adjustedDependent, radiusInteger, 10, MaxIterations -> 10],
    SavitzkyGolay, ListConvolve[SavitzkyGolayMatrix[{radiusInteger}, 3], ArrayPad[adjustedDependent, radiusInteger, "Fixed"]],
    LowpassFilter, LowpassFilter[adjustedDependent, frequency],
    HighpassFilter, HighpassFilter[adjustedDependent, frequency]

  ];
  smoothedDataSet=Transpose[{unitlessIndependent,smoothedDependent}];

  (* The residual of the smoothed dependent relative to the original values *)
  smoothedDependentResiduals = smoothedDependent-unitlessDependent;

  (* Standard deviation of each data points based on the number of data points in its radiusInteger vicinity *)
  (* If only one element, StandardDeviationFilter throws an error *)
  smoothedDependentStDev = If[Length[dataSet]==1,
    smoothedDependentResiduals,
    StandardDeviationFilter[smoothedDependentResiduals, radiusInteger]];

  (* Construct the whole dataset given xvalues and the smoothed dependent values *)
  smoothedDataSetStDev=Transpose[{unitlessIndependent,smoothedDependentStDev}];

  (* Retaining the units *)
  {
    QuantityArray[smoothedDataSet,dataSetUnit],
    smoothedDependentResiduals,
    QuantityArray[smoothedDataSetStDev,dataSetUnit]
  }
];


(* ::Section::Closed:: *)
(*Sister Functions*)

(* ::Subsection:: *)
(*AnalyzeSmoothingOptions*)

DefineOptions[AnalyzeSmoothingOptions,
	SharedOptions :> {AnalyzeSmoothing},
	{
		OptionName -> OutputFormat,
		Default -> Table,
		AllowNull -> False,
		Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
		Description -> "Determines whether the function returns a table or a list of the options."
	}
];


AnalyzeSmoothingOptions[myInput: (CoordinatesP|QuantityCoordinatesP[]), myOptions: OptionsPattern[AnalyzeSmoothingOptions]] := Module[{result},
	result=AnalyzeSmoothingOptions[{myInput}, myOptions];
	If[!MatchQ[result,_List] || Length[result]>1,
		result,
		First[result]
	]
];

(* ::Subsubsection:: *)
(*a single data object*)

AnalyzeSmoothingOptions[myInput: SmoothingInputDataObjectP, myOptions: OptionsPattern[AnalyzeSmoothingOptions]] := Module[{result},
	result=AnalyzeSmoothingOptions[{myInput}, myOptions];
	If[!MatchQ[result,_List] || Length[result]>1 || MatchQ[result,$Failed],
		result,
		First[result]
	]
];

(* ::Subsubsection:: *)
(*a single protocol object*)

AnalyzeSmoothingOptions[myProtocolObject: ObjectP[Object[Protocol]], myOptions: OptionsPattern[AnalyzeSmoothingOptions]] := Module[
	{output},
	output = AnalyzeSmoothingOptions[myProtocolObject[Data], myOptions]
];

(* ::Subsubsection:: *)
(*multiple protocol objects*)

AnalyzeSmoothingOptions[myProtocolObjects: {ObjectP[Object[Protocol]]..}, myOptions: OptionsPattern[AnalyzeSmoothingOptions]] := Module[
	{output},
	output = AnalyzeSmoothingOptions[Flatten[myProtocolObjects[Data],1], myOptions]
];

AnalyzeSmoothingOptions[myInputs: SmoothingInputP, myOptions: OptionsPattern[AnalyzeSmoothingOptions]]:=Module[
	{listedOptions, noOutputOptions, options},

	listedOptions = ToList[myOptions];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

	options = AnalyzeSmoothing[myInputs,Append[noOutputOptions,Output->Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,AnalyzeSmoothing],
		options
	]
];


(* ::Subsection:: *)
(*AnalyzeSmoothingPreview*)

DefineOptions[AnalyzeSmoothingPreview,
	SharedOptions :> {AnalyzeSmoothing}
];

AnalyzeSmoothingPreview[myInput: (CoordinatesP|QuantityCoordinatesP[]), myOptions: OptionsPattern[AnalyzeSmoothingOptions]] := Module[{result},
	result=AnalyzeSmoothingPreview[{myInput}, myOptions];
	If[!MatchQ[result,_List] || Length[result]>1,
		result,
		First[result]
	]
];

(* ::Subsubsection:: *)
(*a single data object*)

AnalyzeSmoothingPreview[myInput: SmoothingInputDataObjectP, myOptions: OptionsPattern[AnalyzeSmoothingPreview]] := Module[{result},
	result=AnalyzeSmoothingPreview[{myInput}, myOptions];
	If[!MatchQ[result,_List] || Length[result]>1 || MatchQ[result,$Failed],
		result,
		First[result]
	]
];

(* ::Subsubsection:: *)
(*a single protocol object*)

AnalyzeSmoothingPreview[myProtocolObject: ObjectP[Object[Protocol]], myOptions: OptionsPattern[AnalyzeSmoothingPreview]] := Module[
	{output},
	output = AnalyzeSmoothingPreview[myProtocolObject[Data], myOptions]
];

(* ::Subsubsection:: *)
(*multiple protocol objects*)

AnalyzeSmoothingPreview[myProtocolObjects: {ObjectP[Object[Protocol]]..}, myOptions: OptionsPattern[AnalyzeSmoothingPreview]] := Module[
	{output},
	output = AnalyzeSmoothingPreview[Flatten[myProtocolObjects[Data],1], myOptions]
];

AnalyzeSmoothingPreview[myInputs: SmoothingInputP, myOptions: OptionsPattern[AnalyzeSmoothingPreview]]:=Module[
	{preview},

	preview = AnalyzeSmoothing[myInputs,Append[ToList[myOptions],Output->Preview]];

	If[MatchQ[preview, $Failed|Null],
		Null,
		preview
	]
];



(* ::Subsection:: *)
(*ValidAnalyzeSmoothingQ*)


DefineOptions[ValidAnalyzeSmoothingQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {AnalyzeSmoothing}
];


(* ::Subsubsection:: *)
(*single dataset list overload*)

ValidAnalyzeSmoothingQ[myInput: (CoordinatesP|QuantityCoordinatesP[]), myOptions: OptionsPattern[ValidAnalyzeSmoothingQ]] := Module[{result},
	result=ValidAnalyzeSmoothingQ[{myInput}, myOptions];
	If[!MatchQ[result,_List] || Length[result]>1,
		result,
		First[result]
	]
];

(* ::Subsubsection:: *)
(*a single data object*)

ValidAnalyzeSmoothingQ[myInput: SmoothingInputDataObjectP, myOptions: OptionsPattern[ValidAnalyzeSmoothingQ]] := Module[{result},
	result=ValidAnalyzeSmoothingQ[{myInput}, myOptions];
	If[!MatchQ[result,_List] || Length[result]>1,
		result,
		First[result]
	]
];

(* ::Subsubsection:: *)
(*a single protocol object*)

ValidAnalyzeSmoothingQ[myProtocolObject: ObjectP[Object[Protocol]], myOptions: OptionsPattern[ValidAnalyzeSmoothingQ]] := Module[
	{output},
	output = ValidAnalyzeSmoothingQ[myProtocolObject[Data], myOptions]
];

(* ::Subsubsection:: *)
(*multiple protocol objects*)

ValidAnalyzeSmoothingQ[myProtocolObjects: {ObjectP[Object[Protocol]]..}, myOptions: OptionsPattern[ValidAnalyzeSmoothingQ]] := Module[
	{output},
	output = ValidAnalyzeSmoothingQ[Flatten[myProtocolObjects[Data],1], myOptions]
];


ValidAnalyzeSmoothingQ[myInputs: SmoothingInputP,myOptions: OptionsPattern[ValidAnalyzeSmoothingQ]]:=Module[
	{listedInputs,listedOptions,preparedOptions,functionTests,initialTestDescription,allTests,safeOptions,verbose,
  outputFormat,result,objectInputs},

	listedInputs=ToList[myInputs];
	listedOptions=ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Tests],{Verbose,OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=AnalyzeSmoothing[listedInputs,preparedOptions];

	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[functionTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[{initialTest,validObjectBooleans,voqWarnings,testResults},
			initialTest=Test[initialTestDescription,True,True];

      (* Object inputs *)
      objectInputs = Cases[Flatten[listedInputs,1], _Object | _Model];
      If[!MatchQ[objectInputs, {}],
  			(* Create warnings for invalid objects *)
  			validObjectBooleans=ValidObjectQ[objectInputs,OutputFormat->Boolean];
        voqWarnings=MapThread[
  				Warning[ToString[#1,InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
  					#2,
  					True
  				]&,
  				{objectInputs,validObjectBooleans}
  			];
  			(* Get all the tests/warnings *)
  			Join[{initialTest},functionTests,voqWarnings],

        functionTests
      ]
		]
	];

	(* Lookup test running options *)
	safeOptions=SafeOptions[ValidAnalyzeSmoothingQ,Normal@KeyTake[listedOptions,{Verbose,OutputFormat}]];
	{verbose,outputFormat}=Lookup[safeOptions,{Verbose,OutputFormat}];

	(* Run the tests as requested and return just the summary not the assocition if OutputFormat->TestSummary*)
	result=RunUnitTest[{AnalyzeSmoothing->DeleteCases[allTests,Null]},Verbose->verbose,OutputFormat->outputFormat];
	Lookup[result,AnalyzeSmoothing]
];
