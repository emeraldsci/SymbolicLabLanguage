(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(* Input Patterns, Options, Warnings and Error *)

(* ::Subsection:: *)
(* Input Pattern Definitions *)
deconvolutionDataTypesP = ObjectP[{
  Object[Data, MassSpectrometry],
  Object[Data, ChromatographyMassSpectra]
}];

deconvolutionProtocolTypesP = ObjectP[{
  Object[Protocol, MassSpectrometry],
  Object[Protocol, LCMS]
}];

deconvolutionInputTypesP = Join[
  deconvolutionDataTypesP,
  deconvolutionProtocolTypesP
];

(* ::Subsection:: *)
(* AnalyzeMassSpectrumDeconvolutionOptions *)

DefineOptions[AnalyzeMassSpectrumDeconvolution,
  Options :> {
    IndexMatching[

    (* Pre-processing *)
    {
      OptionName -> SmoothingWidth,
      Default -> Quantity[0.2 Dalton],
      AllowNull -> False,
      Description -> "The standard deviation of the one-dimensional Gaussian filter used for noise reduction of the data. It is recommended that the value of SmoothingWidth not exceed the distance between adjacent peaks to prevent peak blurring. A value of 0 deactivates smoothing.",
      Category -> "Pre-Processing",
      Widget -> Widget[Type->Expression, Pattern:>GreaterEqualP[0 Dalton], Size->Line]
    },
    {
      OptionName -> IntensityThreshold,
      Default -> Quantity[0.2 ArbitraryUnit],
      AllowNull -> False,
      Description -> "The intensity value below which points in the spectrum will be removed before centroiding. By default, no data points are removed.",
      Category -> "Pre-Processing",
      Widget -> Widget[Type->Expression, Pattern:>GreaterEqualP[0 ArbitraryUnit], Size->Line]
    },

    (* Peak Clustering *)
    {
      OptionName -> IsotopicPeakTolerance,
      Default -> Quantity[0.1 Dalton],
      AllowNull -> False,
      Description -> "The maximum allowed deviation from the expected position for the peaks of an isotopic cluster.",
      Category -> "Peak Clustering",
      Widget -> Widget[Type->Quantity, Pattern:>GreaterEqualP[0 Dalton], Units->Alternatives[Dalton]]
    },
    {
      OptionName -> MinCharge,
      Default -> 1,
      AllowNull -> False,
      Description -> "The minimum expected charge state of the analyte peaks to be deconvoluted.",
      Category -> "Peak Clustering",
      Widget -> Widget[Type->Expression, Pattern:>RangeP[-10,10,1], Size->Line]
    },
    {
      OptionName -> MaxCharge,
      Default -> 10,
      AllowNull -> False,
      Description -> "The maximum expected charge state of the analyte peaks to be deconvoluted.",
      Category -> "Peak Clustering",
      Widget -> Widget[Type->Expression, Pattern:>RangeP[-10,10,1], Size->Line]
    },
    {
      OptionName -> MinIsotopicPeaks,
      Default -> 2,
      AllowNull -> False,
      Description -> "The minimum number of peaks required for set of peaks to be considered an isotopic cluster.",
      Category -> "Peak Clustering",
      Widget -> Widget[Type->Expression, Pattern:>GreaterEqualP[2,1], Size->Line]
    },
    {
      OptionName -> MaxIsotopicPeaks,
      Default -> 20,
      AllowNull -> False,
      Description -> "The maximum number of peaks which can be included in a single isotopic cluster.",
      Category -> "Peak Clustering",
      Widget -> Widget[Type->Expression, Pattern:>GreaterEqualP[2,1], Size->Line]
    },
    {
      OptionName -> AveragineClustering,
      Default -> True,
      AllowNull -> False,
      Description -> "Indicates if the isotopic peak clustering algorithm should employ an intensity check using a decreasing Averagine model, which expects that the isotopic peaks of an analyte containing heavy isotopes will be less intense. The Averagine model assumes the analytes have an elemental composition proportional to C4.94 H7.76 N1.36 O1.48 S0.04 (mass of 111.1254 Da). The most common isotopes for these five elements (C-12, H-1, N-14, O-16, and S-32) are the lightest of all the isotopes for each respective element. For analytes with a small number of atoms, the assumption that isotopic peaks of increasing mass decrease in intensity is generally accurate. However, for analytes with a large number of atoms, the probability that the most intense peak corresponds to a heavy isotope of the analyte increase. It is generally advised to set this option to True, but for spectra containing large analytes, consider increasing the value of the StartIntensityCheck option, which delays the intensity check until a certain number of peaks have been added to the isotopic cluster.",
      Category -> "Peak Clustering",
      Widget -> Widget[Type->Enumeration, Pattern:>BooleanP]
    },
    {
      OptionName -> StartIntensityCheck,
      Default -> 1,
      AllowNull -> False,
      Description -> "Indicates at which peak the intensity check should start being be applied when grouping peaks into isotopic clusters. A value of 1 ensures that the first peak is the most intense peak in the cluster, with all subsequent peaks decreasing in intensity. A value of 2 ensures that either the first or second peak is the most intense peak in the cluster, and that all peaks after the second peak decrease in intensity, and so on. If AveragineClustering is set to False, this option has no effect on the results.",
      Category -> "Peak Clustering",
      Widget -> Widget[Type -> Number, Pattern :> GreaterEqualP[1, 1]]
    },

    (* Post Processing *)
    {
      OptionName -> KeepOnlyDeisotoped,
      Default -> True,
      AllowNull -> False,
      Description -> "Indicates if peaks which were not part of isotopic clusters are included in the deisotoped data.",
      Category -> "Post-Processing",
      Widget -> Widget[Type->Enumeration, Pattern:>BooleanP]
    },
    {
      OptionName -> SumIntensity,
      Default -> True,
      AllowNull -> False,
      Description -> "Indicates if the reported intensity of a monoisotopic peak is the sum of all peak intensities in the isotopic peaks cluster. If False, the reported intensity is equal to the intensity of the largest peak in the cluster.",
      Category -> "Post-Processing",
      Widget -> Widget[Type->Enumeration, Pattern:>BooleanP]
    },
    {
      OptionName -> ChargeDeconvolution,
      Default -> False,
      AllowNull -> False,
      Description -> "Indicates if deisotoped peaks with known charge states are shifted to the single charged m/z value. For example, a peak at m/z=100 with a charge of +3 would be shifted to m/z=300. Note, the listed charges in the resulting Analysis object are not impacted by this option.",
      Category -> "Post-Processing",
      Widget -> Widget[Type->Enumeration, Pattern:>BooleanP]
    },

    IndexMatchingInput -> "Input Data"

    ],

    OutputOption,
    UploadOption,
    AnalysisTemplateOption
  }
];

(* ::Subsection:: *)
(* Warnings and Errors *)
(* Pre-processing Step *)
AnalyzeMassSpectrumDeconvolution::OutputOption = "AnalyzeMassSpectrumDeconvolution does not support the Output options Preview and Result simultaneously; Must use only one at a Time. Output options Options and Tests can be used with either.";
AnalyzeMassSpectrumDeconvolution::ProtocolObject = "This function may be slow for large protocol objects. Consider using Compute.";
AnalyzeMassSpectrumDeconvolution::MassSpectrometryObject = "This function may be slow for MassSpectrometry data objects which do not yet contain an MzMLFile. Consider using Compute. The first time this function is run, an MzMLFile will be added to the data object, allowing for much faster analysis in the future.";

(* Options Resolution *)
AnalyzeMassSpectrumDeconvolution::StartIntensityCheck = "The option StartIntensityCheck has no effect on the results if the option IncludeDecreasingCheck is set to False.";
AnalyzeMassSpectrumDeconvolution::ChargeRange = "MinCharge value cannot be greater than MaxCharge value. Reverting to default value.";
AnalyzeMassSpectrumDeconvolution::IsotopicPeaksRange = "Min IsotopicPeaks value cannot be greater than Max IsotopicPeaks value. Reverting to default value.";

(* Response *)
AnalyzeMassSpectrumDeconvolution::FatalError = "Something went wrong internally. This may be due to network connectivity issues, so re-try the function call after waiting a couple of minutes.";


(* ::Section:: *)
(* Analysis Function Source Code *)

(* ::Subsection:: *)
(* Protocol Overloads *)

(* Protocol Singleton Overload*)
AnalyzeMassSpectrumDeconvolution[inputs:deconvolutionProtocolTypesP, ops:OptionsPattern[]] := Module[
  {
    listedResults, opsAssoc, outputOption,
    resultsPosition, resultsModified, listedResultsModified
  },

  (* Run the Analysis, using listable overload. *)
  listedResults = AnalyzeMassSpectrumDeconvolution[{inputs}, ops];

  (* Lookup Output option, defaulting to results, as this is before any SafeOps calls. *)
  opsAssoc = Association[ops];
  outputOption = Lookup[opsAssoc, Output, Result];

  (* Case 1: Output is Result. *)
  If[MatchQ[outputOption, Result],
    Return[First@listedResults];
  ];

  (* Case 2: Output is List, containing Result. *)
  If[ContainsAny[outputOption, {Result}],
    resultsPosition = First@Flatten[Position[outputOption, Result]];
    resultsModified = First@listedResults[[resultsPosition]];
    listedResultsModified = ReplacePart[listedResults, MapThread[#1->#2&, {resultsPosition, resultsModified}]];
    Return[listedResults];
  ];

  (* Case 3+: Output does not contain Result. *)
  Return[listedResults];

];

(* Protocol / Mixed Input Listed Overload *)
AnalyzeMassSpectrumDeconvolution[inputs:{deconvolutionInputTypesP..}, ops:OptionsPattern[]] := Module[
  {
    dataObjectInputPositions, protocolObjectInputPositions,
    inputsNewListed, inputsNewFlat,
    inputDataObjectLengths, optionsNew,
    results,
    opsAssoc, outputOption, startList, stopList, resultsRegrouped,
    resultsPosition, resultValues, listedResultsRegrouped
  },

  (* Parse the mixed inputs. Flatten the list of data objects. *)
  {dataObjectInputPositions, protocolObjectInputPositions, inputsNewListed} = parseMixedInputs[inputs];
  inputsNewFlat = Flatten[inputsNewListed];

  (* Throw warning about Protocol objects if not on Manifold. *)
  If[!MatchQ[protocolObjectInputPositions, {}] && !TrueQ[ECL`$ManifoldRuntime],
    Message[AnalyzeMassSpectrumDeconvolution::ProtocolObject]
  ];

  (* Expand any options index-matched to a protocol object and flatten the option. *)
  inputDataObjectLengths = Map[Length, inputsNewListed];
  optionsNew = expandProtocolOptions[{ops}, inputDataObjectLengths];

  (* Pass inputs/options to main (framework) overload. *)
  results = AnalyzeMassSpectrumDeconvolution[inputsNewFlat, Sequence@@optionsNew];

  (* Regroup the results portion of the output. *)
  (* Options are formatted as singletons where applicable, Tests are bugged, and Preview is automatically put into slide view. *)
  opsAssoc = Association[ops];
  outputOption = Lookup[opsAssoc, Output, Result];

  (* Generate start and stop values for Take. *)
  {startList, stopList} = generateTakeValues[inputDataObjectLengths];

  (* Case 1: Output is Result. *)
  If[MatchQ[outputOption, Result],
    resultsRegrouped = MapThread[Take[#1, {#2, #3}]&, {{results}, startList, stopList}];
    Return[resultsRegrouped];
  ];

  (* Case 2: Output is List, containing Result. *)
  If[ContainsAny[outputOption, {Result}],
    resultsPosition = First@Flatten[Position[outputOption, Result]];
    resultValues = results[[resultsPosition]];
    resultsRegrouped = MapThread[Take[#1, {#2, #3}]&, {resultValues, startList, stopList}];
    listedResultsRegrouped = ReplacePart[results, MapThread[#1->#2&, {resultsPosition, resultsRegrouped}]];
    Return[listedResultsRegrouped];
  ];

  (* Case 3+: Output does not contain Result. *)
  Return[results];

];


(* ::Subsection:: *)
(* DefineAnalyzeFunction *)
DefineAnalyzeFunction[

  (* Function Name *)
  AnalyzeMassSpectrumDeconvolution,

  (* Input Patterns *)
  <|
    InputData->deconvolutionDataTypesP
  |>,

  (* Primary Steps *)
  {
    Batch[analyzeMassSpecDeconvPreprocessing],
    resolveMassSpecDeconvolutionOptions,
    Batch[generateAndSendRequest],
    generatePacket
  },

  (* Early Exit Step for Output -> Options / Tests *)
  FinalOptionsStep -> resolveMassSpecDeconvolutionOptions,
  FinalTestsStep -> resolveMassSpecDeconvolutionOptions

];


(* ::Subsection:: *)
(* Primary Steps *)
analyzeMassSpecDeconvPreprocessing[
  KeyValuePattern[{
    UnresolvedInputs -> KeyValuePattern[{
      InputData -> inputs_
    }],
    UnresolvedOptions -> unresolvedOps_,
    Batch -> True (* Must be a batch step since we use this to redirect all inputs to the preview overload. *)
  }]
  ] := Module[
  {
    unresolvedOpsList, unresolvedOpsAssoc,
    outputOption, outputOptionListed,
    preview, previewReformatted,
    massSpectrometryInputs, mzmlFiles
  },

  (* Note, framework will create a Length[inputs]-long list of the unresolvedOptions for unresolvedOps in a Batch step, hence why we grab First. *)
  unresolvedOpsList = First[unresolvedOps];
  unresolvedOpsAssoc = Association[unresolvedOpsList];
  outputOption = Lookup[unresolvedOpsAssoc, Output];
  outputOptionListed = ToList[outputOption];

  (* If Output contains Preview and Results, throw an error and Return Failed. *)
  If[ContainsAll[outputOptionListed, {Preview, Result}],
    Message[AnalyzeMassSpectrumDeconvolution::OutputOption];
    Return[$Failed]
  ];

  (* If Output contains Preview, redirect to Preview Function. *)
  If[ContainsAny[outputOptionListed, {Preview}],
    preview = AnalyzeMassSpectrumDeconvolutionPreview[inputs, Sequence@@unresolvedOpsList];
    previewReformatted = Which[
      (* If inputs is not a list, Preview will return unlisted, breaking Batch step processing, so wrap in list. *)
      MatchQ[inputs, ObjectP[]],
      {preview},
      (* If inputs is listed with more than one entry, preview will be inside SlideView, breaking batch step processing, so remove SlideView head.*)
      MatchQ[Head[preview], SlideView],
      Sequence@@preview,
      (* All other cases (i.e., listed with one entry), return unmodified. *)
      True,
      preview
    ];

    Return[
      <|
        Preview -> previewReformatted,
        Intermediate -> <|"EarlyExit" -> ConstantArray[True, Length[inputs]]|>,
        Batch -> True
      |>
    ]
  ];

  (* Else, just continue the function as usual, and set the internal "PreviewFlag" option to False. *)
  (* But first, check if input is Object[Data, MassSpectrometry] without an existing mzML file. *)
  massSpectrometryInputs = Cases[Flatten[inputs], ObjectP[Object[Data, MassSpectrometry]]];
  If[!MatchQ[massSpectrometryInputs, {}],
    mzmlFiles = Download[massSpectrometryInputs, MzMLFile];
    If[ContainsAny[mzmlFiles, {Null}],
      Message[AnalyzeMassSpectrumDeconvolution::MassSpectrometryObject];
    ];
  ];

  <|
    Intermediate -> <|
      "PreviewFlag" -> ConstantArray[False, Length[inputs]],
      "EarlyExit" -> ConstantArray[False, Length[inputs]]
    |>,
    Batch->True
  |>

];

resolveMassSpecDeconvolutionOptions[
  KeyValuePattern[{
    UnresolvedInputs -> KeyValuePattern[{
      InputData -> input_
    }],
    UnresolvedOptions -> unresolvedOps_,
    (* Safe ResolvedOptions, not fully ResolvedOptions. *)
    ResolvedOptions -> safeOps_
  }]
  ] := Module[
  {
    minCharge, maxCharge, resolvedChargeRange, chargeTest,
    minPeaks, maxPeaks, resolvedIsotopicPeaksRange, isotopicPeaksTest,
    userSpecifiedOptions, includeDecreasingCheckValue
  },

  (* Because this is the last step for Options / Tests, and it's very quick, we will never EarlyExit on this. *)

  (* ChargeRange *)
  minCharge = Lookup[safeOps, MinCharge];
  maxCharge = Lookup[safeOps, MaxCharge];
  resolvedChargeRange = If[!(minCharge <= maxCharge),
    Message[AnalyzeMassSpectrumDeconvolution::ChargeRange];
    {
      Lookup[SafeOptions[AnalyzeMassSpectrumDeconvolution], MinCharge],
      Lookup[SafeOptions[AnalyzeMassSpectrumDeconvolution], MaxCharge]
    },
    {minCharge, maxCharge}
  ];

  (* ChargeRange Test - MinCharge must be less than or equal to MaxCharge. *)
  chargeTest = Test["The option ChargeRange has a min charge less than or equal to the max charge:",
    minCharge <= maxCharge,
    True
  ];

  (* IsotopicPeaksRange *)
  minPeaks = Lookup[safeOps, MinIsotopicPeaks];
  maxPeaks = Lookup[safeOps, MaxIsotopicPeaks];
  resolvedIsotopicPeaksRange = If[!(minPeaks <= maxPeaks),
    Message[AnalyzeMassSpectrumDeconvolution::IsotopicPeaksRange];
    {
      Lookup[SafeOptions[AnalyzeMassSpectrumDeconvolution], MinIsotopicPeaks],
      Lookup[SafeOptions[AnalyzeMassSpectrumDeconvolution], MaxIsotopicPeaks]
    },
    {minPeaks, maxPeaks}
  ];

  (* IsotopicPeaksRange Test - MinPeaks must be less than or equal to MaxPeaks. *)
  isotopicPeaksTest = Test["The option ChargeRange has a min charge less than or equal to the max charge:",
    minPeaks <= maxPeaks,
    True
  ];

  (* DecreasingModel with IntensityCheck. *)
  userSpecifiedOptions = Keys[unresolvedOps];
  includeDecreasingCheckValue = Lookup[safeOps, AveragineClustering];
  If[ContainsAll[userSpecifiedOptions, {AveragineClustering, StartIntensityCheck}] && !includeDecreasingCheckValue,
    Message[AnalyzeMassSpectrumDeconvolution::StartIntensityCheck]
  ];

  (* Return Association. *)
  Association[
    ResolvedOptions-><|
      MinCharge -> resolvedChargeRange[[1]],
      MaxCharge -> resolvedChargeRange[[2]],
      MinIsotopicPeaks -> resolvedIsotopicPeaksRange[[1]],
      MaxIsotopicPeaks -> resolvedIsotopicPeaksRange[[2]]
    |>,
    Tests -> <|
      ChargeTest -> chargeTest,
      IsotopicsPeaksTest -> isotopicPeaksTest
    |>
  ]

];

generateAndSendRequest[
  KeyValuePattern[{
    UnresolvedInputs -> KeyValuePattern[{InputData -> inputs_}],
    ResolvedOptions -> resolvedOps_,
    Intermediate -> intermediate_,
    Batch -> True
  }]
  ] := Module[
  {
    earlyExit, previewFlag, previewData,
    inputTypes, inputIDs, optionsForRequest,
    body, url, response
  },

  (* If EarlyExit is True, return empty Association. *)
  earlyExit = First[Lookup[intermediate, "EarlyExit", {False}]];
  If[earlyExit,
    (* Our "empty" association still needs the Response key in the intermediate packet for the next step's definition, also Batch->True. *)
    Return[<|
      Intermediate -> <|Response-> ConstantArray[Null, Length[inputs]]|>,
      Batch->True
    |>]
  ];

  previewFlag = First[Lookup[intermediate, "PreviewFlag", {False}]];
  previewData = Lookup[intermediate, "PreviewData", Null];

  (* Get Types IDs from Input Objects. *)
  (* Reformat the IDs to be strings with period delimiters for type checks in python. *)
  inputTypes = Map[formatObjectTypeForRequest, Download[inputs, Type]];
  inputIDs = Download[inputs, ID];

  (* Convert resolved options to the request format. *)
  optionsForRequest = formatOptionsForRequest[resolvedOps];

  (* Make the body for the http request. *)
  body = <|
    "Types" -> inputTypes,
    "IDs" -> inputIDs,
    If[previewFlag,
      "Data" -> previewData,
      Nothing
    ],
    "Options" -> optionsForRequest,
    "$ConstellationDomain" -> Global`$ConstellationDomain
  |>;

  (* Set the URL based on the environment and preview flag. *)
  url = If[previewFlag,
    (* If True, send to preview endpoint. *)
    If[ProductionQ[],
      "https://proteomics.emeraldcloudlab.com/mass_spectrum_deconvolution_preview",
      "https://proteomics-stage.emeraldcloudlab.com/mass_spectrum_deconvolution_preview"
    ],
    (* If False, send to main endpoint. *)
    If[ProductionQ[],
      "https://proteomics.emeraldcloudlab.com/mass_spectrum_deconvolution",
      "https://proteomics-stage.emeraldcloudlab.com/mass_spectrum_deconvolution"
    ]
  ];

  (* Send request to web-app. *)
  response = HTTPRequestJSON[<|
    "Method" -> "POST",
    "Headers" -> <|
      "Authorization" -> StringJoin["Bearer ", GoLink`Private`stashedJwt],
      "Content-Type" -> "application/json"
    |>,
    "URL" -> url,
    "Timeout" -> 1800000,  (*Client-side timeout in milliseconds. *)
    "Body" -> body
  |>];

  (* Parse response for errors only. *)
  If[MatchQ[Head[response], HTTPError],

    (* Failed Response *)
    Message[AnalyzeMassSpectrumDeconvolution::FatalError];
    Return[$Failed],

    (* Successful Response *)
    <|
      Intermediate -> <|Response->Values[response]|>,
      Batch -> True
    |>

  ]

];

generatePacket[
  KeyValuePattern[{
    UnresolvedInputs -> KeyValuePattern[{InputData -> input_}],
    ResolvedOptions -> resolvedOps_,
    Intermediate -> KeyValuePattern[{
      Response -> response_,
      "EarlyExit" -> earlyExit_
    }]
  }]
  ] := Module[
  {
    centroidMZMLCloudfile, deconvolutedMZMLCloudFile,
    chargeValues, isotopicPeaksCounts, dataForPacket,
    analysisPacket
  },

  (* If EarlyExit is True, return empty Association. *)
  If[earlyExit,
    Return[<||>]
  ];

  {centroidMZMLCloudfile, deconvolutedMZMLCloudFile, chargeValues, isotopicPeaksCounts, dataForPacket} = parseResponse[input, response];

  (* Create the analysis object packet. *)
  (* N.B., The mzML cloud files objects, and the links to these in the input data objects, are created/uploaded in the web app. *)
  analysisPacket = <|
    (* General *)
    Type -> Object[Analysis, MassSpectrumDeconvolution],
    Replace[Reference] -> {Link[input]},

    (* Data Fields*)
    If[MatchQ[input, ObjectP[Object[Data, MassSpectrometry]]] && (dataForPacket =!= {}),
      DeconvolutedMassSpectrum -> dataForPacket,
      Nothing
    ],
    If[MatchQ[input, ObjectP[Object[Data, ChromatographyMassSpectra]]] && (dataForPacket =!= {}),
      DeconvolutedIonAbundance3D-> dataForPacket,
      Nothing
    ],
    IsotopicClusterCharge -> chargeValues,
    IsotopicClusterPeaksCount -> isotopicPeaksCounts,

    (* mzML Files*)
    MassCentroidMzMLFile -> Link[Object[centroidMZMLCloudfile]],
    DeconvolutionMzMLFile -> Link[Object[deconvolutedMZMLCloudFile]],

    (* ResolvedOptions Individual Fields *)
    SmoothingWidth -> Lookup[resolvedOps, SmoothingWidth],
    IntensityThreshold -> Lookup[resolvedOps, IntensityThreshold],
    IsotopicPeakTolerance -> Lookup[resolvedOps, IsotopicPeakTolerance],
    MinCharge -> Lookup[resolvedOps, MinCharge],
    MaxCharge -> Lookup[resolvedOps, MaxCharge],
    MinIsotopicPeaks -> Lookup[resolvedOps, MinIsotopicPeaks],
    MaxIsotopicPeaks -> Lookup[resolvedOps, MaxIsotopicPeaks],
    AveragineClustering -> Lookup[resolvedOps, AveragineClustering],
    StartIntensityCheck -> Lookup[resolvedOps, StartIntensityCheck],
    KeepOnlyDeisotoped -> Lookup[resolvedOps, KeepOnlyDeisotoped],
    SumIntensity -> Lookup[resolvedOps, SumIntensity],
    ChargeDeconvolution -> Lookup[resolvedOps, ChargeDeconvolution]
  |>;

  (* Return the analysisPacket. *)
  (* Also remove the Response from Intermediate for slight speed up.*)
  <|
    Packet -> analysisPacket,
    Intermediate -> <|Response->Null|>
  |>

];


(* ::Subsection:: *)
(* Analysis Helper Functions *)

(* Main Analyze Function *)
formatObjectTypeForRequest[objectType_] := Module[{symbols},
  symbols = Map[Part[objectType, #]&, Range[0, Length[objectType]]];
  StringRiffle[symbols, "."]
];

formatOptionsForRequest[options_] := Module[
  {
    smoothingWidth, smoothingWidthUnitless,
    intensityThreshold, intensityThresholdUnitless,
    fragmentTolerances, fragTolMagnitudes, fragTolUnits, unitsAsBool,
    minCharges, maxCharges,
    minPeaks, maxPeaks,
    keepOnlyDeisotoped,
    includeChargeDeconvolution,
    includeDecreasingCheck,
    startIntensityCheck,
    sumIntensity,
    optionsLength,
    annotateCharges,
    annotateIsotopicPeaks,
    optionsForRequest
  },

  (* Pre-processing options *)
  smoothingWidth = Lookup[options, SmoothingWidth];
  smoothingWidthUnitless = QuantityMagnitude[UnitConvert[smoothingWidth, Dalton]];
  intensityThreshold = Lookup[options, IntensityThreshold];
  intensityThresholdUnitless = QuantityMagnitude[intensityThreshold];

  (* Peak Clustering Options. *)
  (* FragmentTolerance *)
  (* Corresponding options in python are fragment_tolerance, which is a float, and fragment_unit_ppm, which is a boolean indicating if the
  fragment_tolerance value is in units of ppm if True, and m/z units if False. *)
  fragmentTolerances = Lookup[options, IsotopicPeakTolerance];
  fragTolMagnitudes = Map[QuantityMagnitude, fragmentTolerances];
  fragTolUnits = Map[QuantityUnit, fragmentTolerances];
  unitsAsBool = Map[CompatibleUnitQ[#, PPM]&, fragTolUnits];

  (* Other peak clustering options *)
  (* All other SLL options have the same type in SLL and Python (values for floats/ints, bools for bools. ChargeRange and IsotopicPeaksRange must be
  split into min and max for each. *)
  minCharges = Lookup[options, MinCharge];
  maxCharges = Lookup[options, MaxCharge];
  minPeaks = Lookup[options, MinIsotopicPeaks];
  maxPeaks = Lookup[options, MaxIsotopicPeaks];
  keepOnlyDeisotoped = Lookup[options, KeepOnlyDeisotoped];
  includeChargeDeconvolution = Lookup[options, ChargeDeconvolution];
  includeDecreasingCheck = Lookup[options, AveragineClustering];
  startIntensityCheck = Lookup[options, StartIntensityCheck];
  sumIntensity = Lookup[options, SumIntensity];

  (* AnnotationOptions *)
  optionsLength = Length[sumIntensity];
  annotateCharges = ConstantArray[True, optionsLength];
  annotateIsotopicPeaks = ConstantArray[True, optionsLength];

  (* Generate the List of Options, Swapping Symbols for Strings. *)
  optionsForRequest = {
    "FragmentTolerance" -> fragTolMagnitudes,
    "FragmentUnit" -> unitsAsBool,
    "MinCharge" -> minCharges,
    "MaxCharge" -> maxCharges,
    "KeepOnlyDeisotoped" -> keepOnlyDeisotoped,
    "MinIsotopes" -> minPeaks,
    "MaxIsotopes" -> maxPeaks,
    "IncludeChargeDeconvolution" -> includeChargeDeconvolution,
    "AnnotateCharges" -> annotateCharges,
    "AnnotateIsotopicPeaks" -> annotateIsotopicPeaks,
    "IncludeDecreasingCheck" -> includeDecreasingCheck,
    "StartIntensityCheck" -> startIntensityCheck,
    "SumIntensity" -> sumIntensity,
    "GaussFilterWidth" -> smoothingWidthUnitless,
    "MinPeakIntensity" -> intensityThresholdUnitless
  };

  (* Return optionsForRequest*)
  optionsForRequest

];

parseResponse[input_, response_] := Module[
  {
    dataObjType, dataObjID, rawMZMLCloudFile, centroidMZMLCloudfile, deconvolutedMZMLCloudFile, dataList,
    retentionTimes, mzValues, intensityValues, chargeValues, isotopicPeaksCounts,
    retentionTimesWithUnits, mzValuesWithUnits, intensityValuesWithUnits,
    dataForPacket
  },

  (* Unpack the response. *)
  (* Note: Python code was written to support both protocol and data objects, but the framework does not handle one-to-many responses well (yet), so
  this framework definition is now for data objects only. To handle python/sll differences, we call first to convert the triply listed data
  (originally for protocol with many linked data objects, and then one list per retention time) to a doubly listed data. *)
  {dataObjType, dataObjID, rawMZMLCloudFile, centroidMZMLCloudfile, deconvolutedMZMLCloudFile, dataList} = Transpose[response];
  {dataObjType, dataObjID, rawMZMLCloudFile, centroidMZMLCloudfile, deconvolutedMZMLCloudFile, dataList} =
      Map[First[#]&, {dataObjType, dataObjID, rawMZMLCloudFile, centroidMZMLCloudfile, deconvolutedMZMLCloudFile, dataList}];

  (* Upack the lists of raw data. *)
  {retentionTimes, mzValues, intensityValues, chargeValues, isotopicPeaksCounts} = dataList;

  (* Convert data lists to QuantityArrays with appropriate units. *)
  (* Data is returned without explicit units, but match the pattern of the object. *)
  (* retentionTimes are in units of Seconds. mzValues in units of Dalton, and intensityValues in ArbitraryUnits. Rest is dimensionless. *)
  (* Also, Map instead of calling QuantitiyArray on the entire thing because QuantityArrays must be square (and the object expects this too).*)
  retentionTimesWithUnits = Map[QuantityArray[#, Minute]&, retentionTimes];
  mzValuesWithUnits = Map[QuantityArray[#, Dalton]&, mzValues];
  intensityValuesWithUnits = Map[QuantityArray[#, ArbitraryUnit]&, intensityValues];

  (* Format DeconvolutedMassSpectrum or DeconvolutedIonAbundance3D based on input type. *)
  (* Data has one list per retention time, but object wants flat lists, so flatten before MapThreading. *)
  dataForPacket = Which[
    MatchQ[input, ObjectP[Object[Data, MassSpectrometry]]],
    QuantityArray[MapThread[{#1, #2}&, {Flatten[mzValuesWithUnits], Flatten[intensityValuesWithUnits]}]],
    MatchQ[input, ObjectP[Object[Data, ChromatographyMassSpectra]]],
    createIonAbundance3DList[retentionTimesWithUnits, mzValuesWithUnits, intensityValuesWithUnits]
  ];

  (* Return the data needed for the analysis packet. *)
  (* Note, chargeValues and isotopicPeaksCount need to be flattened, since the are double listed in the response. dataForPacket is appropriately
  flattened above. *)
  {centroidMZMLCloudfile, deconvolutedMZMLCloudFile, Flatten[chargeValues], Flatten[isotopicPeaksCounts], dataForPacket}

];

createIonAbundance3DList[retentionTimesWithUnits_, mzValuesWithUnits_, intensityValuesWithUnits_] := Module[
  {
    nestedIonAbundance3D, rtExtended
  },

  nestedIonAbundance3D = MapThread[
    (
      rtExtended = ConstantArray[#1, Length[#2]];
      Transpose[{rtExtended, #2, #3}]
    )&,
    {retentionTimesWithUnits, mzValuesWithUnits, intensityValuesWithUnits}
  ];

  (* Flatten the list at the appropriate level, and convert into a QuantitiyArray. *)
  QuantityArray[Flatten[nestedIonAbundance3D, 1]]

];

(* Protocol Overloads *)
parseMixedInputs[inputs_] := Module[
  {
    dataObjectInputPositions, dataObjectInputs,
    protocolObjectInputPositions, protocolObjectInputs,
    protocolDataObjects, protocolDataObjectsLength,
    inputsNewListed
  },
  (* Separate the data and protocol object inputs. *)
  (* Position function is designed for arbitrarily nested lists, and returns lists of lists of positions, so flatten results. *)
  dataObjectInputPositions = Flatten[Position[inputs, deconvolutionDataTypesP]];
  dataObjectInputs = inputs[[dataObjectInputPositions]];
  protocolObjectInputPositions = Flatten[Position[inputs, deconvolutionProtocolTypesP]];
  protocolObjectInputs = inputs[[protocolObjectInputPositions]];

  (* Download the data objects from the protocol. *)
  protocolDataObjects = Download[protocolObjectInputs, Data];
  protocolDataObjectsLength = Map[Length, protocolDataObjects];

  (* Swap protocol inputs with corresponding data objects and flatten the input. *)
  (* Also replace data object inputs with a themselves wrapped in a list for calculating size. This makes expanding options easier. *)
  inputsNewListed = ReplacePart[inputs,
    Flatten[{
      MapThread[#1->#2&, {protocolObjectInputPositions, protocolDataObjects}],
      MapThread[#1->#2&, {dataObjectInputPositions, Map[List, dataObjectInputs]}]
    }]
  ];

  Return[{dataObjectInputPositions, protocolObjectInputPositions, inputsNewListed}]
];

expandProtocolOptions[options_, inputDataObjectLengths_] := Module[
  (* Helper function used to expand the options for a protocol input in the non-framework protocol overload. *)
  {
    optionsAssoc, optionsKeys,
    optionsIndexMatchedKeys, optionsIndexMatchedValues, optionsIndexMatchedValuesExpanded,
    optionsSingletonKeys, optionsSingletonValues, optionsSingleton
  },

  optionsAssoc = Association[options];
  optionsKeys = Keys[optionsAssoc];

  optionsIndexMatchedKeys = DeleteCases[optionsKeys, Upload|Output];
  optionsIndexMatchedValues = Lookup[optionsAssoc, optionsIndexMatchedKeys];
  optionsIndexMatchedValuesExpanded = MapThread[
    #1 -> expandOptionList[#2, inputDataObjectLengths]&,
    {optionsIndexMatchedKeys, optionsIndexMatchedValues}
  ];

  optionsSingletonKeys = DeleteCases[optionsKeys, Except[Upload|Output]];
  optionsSingletonValues = Lookup[optionsAssoc, optionsSingletonKeys];
  optionsSingleton = MapThread[#1->#2&, {optionsSingletonKeys, optionsSingletonValues}];

  Join[optionsIndexMatchedValuesExpanded, optionsSingleton]

];

expandOptionList[optionList_, inputDataObjectLengths_] := Module[{},
  (* Helper function for expanding a single list of options, used to avoid nested MapThreads. *)
  Flatten[MapThread[ConstantArray[#1, #2]&, {ToList[optionList], inputDataObjectLengths}], 1]
];

generateTakeValues[vals_] := Module[
  (* Helper function for regrouping protocol results. *)
  {
    startList, stopList
  },
  startList = Join[{1}, Map[1+#&, Most[vals]]];
  stopList = Join[MapThread[(#1+#2)&, {Most[vals], Rest[vals]}], {Total[vals]}];

  {startList, stopList}

];


(* ::Section:: *)
(* Preview Overload *)
$numPointsForPreview = 5000;  (* Maximum number of points used in preview to maintain speed. *)
$xRange = 100; (* Value in units of Dalton used to determine the PlotRange parameter. *)

(* ::Subsection:: *)
(* AMSDPreview Overloads *)
(* Singleton Overload. *)
AnalyzeMassSpectrumDeconvolutionPreview[input:deconvolutionInputTypesP, ops:OptionsPattern[AnalyzeMassSpectrumDeconvolution]] := Module[
  {res},

  (* Pass to listed overload. *)
  res = AnalyzeMassSpectrumDeconvolutionPreview[{input}, ops];

  (* Return the results, removing listedness. *)
  res[[1]]

];

(* Listed / Mixed Input Overload *)
AnalyzeMassSpectrumDeconvolutionPreview[inputs:{deconvolutionInputTypesP...}, ops:OptionsPattern[AnalyzeMassSpectrumDeconvolution]] := Module[
  {
    dataObjectInputPositions, protocolObjectInputPositions,
    inputsNewListed, inputsNewFlat
  },

  (* Parse the mixed inputs. Flatten the list of data objects. *)
  (* This is doing the same thing as the protocol overload for the main function. *)
  {dataObjectInputPositions, protocolObjectInputPositions, inputsNewListed} = parseMixedInputs[inputs];
  inputsNewFlat = Map[First, inputsNewListed];

  (* Pass inputs to Main Overload. *)
  (* No need to expand options since we are only keeping one data object per protocol. *)
  AnalyzeMassSpectrumDeconvolutionPreview[inputsNewFlat, ops]

];

(* Primary Overload - Data Objects Only. *)
AnalyzeMassSpectrumDeconvolutionPreview[inputs:{deconvolutionDataTypesP...}, ops:OptionsPattern[AnalyzeMassSpectrumDeconvolution]] := Module[
  {
    resolvedOps, previewData, requestAssoc, responsePacket, response, allPlots
  },

  (* Generate the resolved options to use in generateAndSendRequest. *)
  resolvedOps = resolvePreviewOptions[inputs, {ops}];
  If[MatchQ[resolvedOps, $Failed],
    Return[ConstantArray[$Failed, Length[inputs]]]
  ];

  (* Send the request using the generateAndSendRequest helper, with "PreviewFlag" -> True for all inputs, and preview data. *)
  previewData = downloadDataForPreview[inputs];
  requestAssoc = <|
    UnresolvedInputs -> <|InputData -> inputs|>,
    ResolvedOptions -> resolvedOps,
    Intermediate -> <|
      "PreviewFlag" -> ConstantArray[True, Length[inputs]],
      "PreviewData" -> previewData,
      "EarlyExit" -> ConstantArray[False, Length[inputs]]
    |>,
    Batch -> True
  |>;

  responsePacket = generateAndSendRequest[requestAssoc];

  (* Check response and return $Failed or Preview plot.  *)
  If[MatchQ[responsePacket, $Failed],

    (* Failed Response *)
    Return[ConstantArray[$Failed, Length[inputs]]],

    (* Successful Response - Generate the preview plots. *)
    response = Lookup[Lookup[responsePacket, Intermediate], Response];
    allPlots = generatePreviewPlots[previewData, response];

    (* Return the preview plots, using SlideView if more than one. *)
    If[Length[allPlots]>1,
      SlideView[allPlots],
      allPlots
    ]

  ]

];


(* ::Subsection:: *)
(* Preview Helper Functions *)
plotMassSpectrumDeconvolutionPreview[mzValues_, intValues_, ops:OptionsPattern[EmeraldListLinePlot]] := Module[
  {
    plotData, plotDataReformatted,
    safeOpsAssoc, safeOpsList,
    plot
  },

  (* Transform the Deconvoluted Data. *)
  plotData = MapThread[Transpose[{#1, #2}]&, {mzValues, intValues}];
  plotDataReformatted = {plotData[[1]], pointsToPeaks[plotData[[2]]]} /. {{}->Nothing};

  (* Generate SafeOptions association, remove PlotType option, which is added by PlotObject, and convert back to list. *)
  safeOpsAssoc = Association[SafeOptions[EmeraldListLinePlot, {ops}]];
  safeOpsAssoc = KeyDrop[safeOpsAssoc, PlotType];
  safeOpsList = KeyValueMap[#1->#2&, safeOpsAssoc];

  (* Generate the plot. *)
  plot = Zoomable@EmeraldListLinePlot[plotDataReformatted, Sequence@@safeOpsList];

  (* Return the plot. *)
  plot

];

pointsToPeaks[data_List] := Module[{},
  (* Helper function which takes a list of points and converts it into a modified list of points, such that the lines connecting the points are
  perfectly vertical. ex. {{10, 100}, {20, 200}} is expanded to {{10, 0}, {10, 100}, {10, 0}, {20,0}, {20,200}, {20,0}}. *)

  Flatten[
    Map[
      {
        {#[[1]], 0},  (* Left point on x-axis *)
        {#[[1]], #[[2]]}, (* Top of delta-function peak. *)
        {#[[1]], 0} (* Right point on x-axis *)
      }&,
      data
    ],
  1] (* Flatten only at first level. Still want a list of {x,y} pairs. *)

];

pointsToPeaks[data_QuantityArray] := Module[
  {
    xUnit, yUnit, dataFlat
  },

  dataFlat = Flatten[
    Map[
      (
        {xUnit, yUnit} = QuantityUnit[#];
        {
          {#[[1]], Quantity[0, yUnit]}, (* Left point on x-axis *)
          {#[[1]], #[[2]]}, (* Top of delta-function peak. *)
          {#[[1]], Quantity[0, yUnit]} (* Right point on x-axis *)
        }
      )&,
      data
    ],
  1]; (* Flatten only at first level. Still want a list of {x,y} pairs. *)

  QuantityArray[dataFlat]

];

assocOfListsToListOfAssocs[input_] := Module[
  {
    assoc, keys, values, optionsLength, newList
  },

  assoc = Association@input;
  keys = Keys[assoc];
  values = Values[assoc];

  optionsLength =If[MatchQ[First[values], _List],
    Length[First[values]],
    1
  ];
  newList = Table[
    Association[MapThread[#1 -> #2[[i]] &, {keys, values}]],
    {i, optionsLength}
  ];

  newList

];

listOfAssocsToAssocOfLists[input_] := Module[
  {
    keys, values, valuesTransposed
  },
  keys = Keys[input[[1]]];
  values = Map[Values[#]&, input];
  valuesTransposed = Transpose[values];

  MapThread[#1->#2&, {keys, valuesTransposed}]
];

resolvePreviewOptions[inputsNewFlat_, optionsNew_] := Module[
  {
    mostlySingletonSafeOps, indexMatchedSafeOps, indexMatchedSafeOpsReformatted,
    optionResolverAssocs, partialResolvedOpsList, resolvedOpsLists, resolvedOps
  },
  (* This function is effectively just recreating some of the options handling we get for free in the SciCompFramework, so that we can reuse framework
   functions in the preview overload. *)

  (* Use the expanded options to create the resolved options. *)
  mostlySingletonSafeOps = SafeOptions[AnalyzeMassSpectrumDeconvolution, optionsNew];
  indexMatchedSafeOps = SciCompFramework`Private`ExpandOptions[AnalyzeMassSpectrumDeconvolution, inputsNewFlat, mostlySingletonSafeOps, Identity];
  (* Above function will return $Failed if any options are of incorrect length. Check for $Failed and return early. *)
  If[MatchQ[indexMatchedSafeOps, $Failed],
    Return[$Failed]
  ];
  indexMatchedSafeOpsReformatted = assocOfListsToListOfAssocs[indexMatchedSafeOps];
  optionResolverAssocs = MapThread[
    <|
      UnresolvedInputs -> <|InputData -> #1|>,
      UnresolvedOptions -> optionsNew,
      ResolvedOptions -> #2,
      Intermediate -> <|"EarlyExit" -> False|>
    |>&,
    (* Just need the keys from ops/optionsNew, so no reformatting necessary. *)
    {inputsNewFlat, indexMatchedSafeOpsReformatted}
  ];
  partialResolvedOpsList = Map[Lookup[resolveMassSpecDeconvolutionOptions[#], ResolvedOptions]&, optionResolverAssocs];
  resolvedOpsLists = mapThreadAssociateTo[indexMatchedSafeOpsReformatted, partialResolvedOpsList];
  resolvedOps = listOfAssocsToAssocOfLists[resolvedOpsLists];

  (* Return the resolved options. *)
  resolvedOps

];

mapThreadAssociateTo[listOfAssocs1_, listOfAssocs2_] := Module[
  {
    listOfAssocsNew, assoc1, assoc2
  },

  listOfAssocsNew = {};
  (* This map thread will modify assoc1 in place, but not the association in listOfAssocs1.
  To save the results, we must store the modified assoc1 in a list somewhere. *)
  MapThread[
    (
      assoc1 = #1;
      assoc2 = #2;
      AssociateTo[assoc1, assoc2];
      AppendTo[listOfAssocsNew, assoc1]
    )&,
    {listOfAssocs1, listOfAssocs2}
  ];

  listOfAssocsNew

];

filterDataByRetentionTime[data_, retentionTime_] := Module[
  {
    retentionTimes, matchingRetentionTimes, dataLength
  },

  retentionTimes = QuantityMagnitude[Transpose[data][[1]]];
  (* Can't use Select with Quantities.... :/ *)
  (* This method assumes data is ordered by retention time (which it is...). *)
  matchingRetentionTimes = Select[retentionTimes, MatchQ[#, retentionTime]&];
  dataLength = Length[matchingRetentionTimes];

  (* Return the filtered data. *)
  data[[;;dataLength]]

];

checkRetentionTimeAndRemove[data_] := Module[
  {
    retentionTimes, uniqueRetentionTimes, dataNew
  },

  (* Overload to quick exit for MassSpectrometry data. This additional filtering is only needed for ChromatographyMassSpectra data. *)
  If[Length[data[[1]]] == 2,
    Return[data]
  ];

  retentionTimes = Transpose[data][[1]];
  uniqueRetentionTimes = DeleteDuplicates[QuantityMagnitude[retentionTimes]];
  (* There will almost never be more than one retention time when using a sufficiently 'small' number of data points (i.e., a few thousand), so we
  will only filter data by RT as needed, rather than every time, since it is slower than just checking if all RTs are the same. *)
  dataNew = If[Length[uniqueRetentionTimes] > 1,
    filterDataByRetentionTime[data, First@uniqueRetentionTimes],
    data
  ];

  (* Remove the RetentionTime data and return. *)
  Transpose[Transpose[dataNew][[2;;3]]]

];

partAroundIndex[list_, index_, numPoints_] := Module[
  {
    lowerIndex, lowerIndexFinal,
    upperIndex, upperIndexFinal
  },

  lowerIndex = Floor[index-numPoints/2];
  lowerIndexFinal = If[lowerIndex < 0, 1, lowerIndex];
  upperIndex = Ceiling[index+numPoints/2];
  upperIndexFinal = If[upperIndex > Length[list], Length[list], upperIndex];

  list[[lowerIndexFinal;;upperIndexFinal]]

];

downloadDataForPreview[inputs_] := First[downloadDataForPreview[{inputs}]];

downloadDataForPreview[inputs_List] := Module[
  {
    inputTypes, downloadFields,
    data, dataUnitless,
    intensityData, maxPeakIndicies,
    dataSubset, dataFiltered
  },

  (* Download data based on input type. Also, use listed syntax the fields are index-matched, rather than applied to all object. *)
  inputTypes = inputs[Type];
  downloadFields = inputTypes /. {Object[Data, MassSpectrometry] -> {MassSpectrum}, Object[Data, ChromatographyMassSpectra] -> {IonAbundance3D}};
  (* Download and remove excessive listedness. *)
  data = Flatten[Download[inputs, downloadFields], 1];
  dataUnitless = QuantityMagnitude[data];

  (* Find the maximum intensity in the data set, and then select a fixed number of neighboring points. *)
  intensityData = Map[Transpose[#][[-1]]&, dataUnitless]; (* Use -1, so we dont need to check 2xN vs 3xN data. *)
  maxPeakIndicies = Map[Ordering[#][[-1]]&, intensityData];
  dataSubset = MapThread[partAroundIndex[#1, #2, $numPointsForPreview]&, {dataUnitless, maxPeakIndicies}];

  (* IonAbundance3D is not actually structured as a 3D array, so grabbing an arbitrary number of points could possibly yield data from multiple
  retention times. We will pass the data through additional checks to ensure all data has the same retention time, then strip the retention time. *)
  (* Intentionally re-wrapping in an additional list b/c its expected by python. *)
  dataFiltered = Map[{checkRetentionTimeAndRemove[#]}&, dataSubset];
  dataFiltered

];

generatePlotRange[data_] := Module[
  {
    plotRangeMin, plotRangeMax, plotRangeMidPoint, plotRangeDifference, plotRangeResolved
  },
  (* Assuming uniformly spaced raw data. *)
  {plotRangeMin, plotRangeMax} = {Min[data], Max[data]};
  plotRangeMidPoint = Mean[{plotRangeMin, plotRangeMax}];
  plotRangeDifference = plotRangeMax-plotRangeMin;
  plotRangeResolved = If[plotRangeDifference>50,
    {plotRangeMidPoint-$xRange/2, plotRangeMidPoint+$xRange/2},
    {plotRangeMin, plotRangeMax}
  ];
  plotRangeResolved
];

parsePreviewResponse[response_] := Module[
  {
    retentionTimes, mzs, intensities, charges, peaksCount
  },

  (* Transpose list to group values by type and remove extra level of listedness that stems from having originally supported protocol objects in python. *)
  responseReformatted = Flatten[Transpose[response, 3<->1], 1];
  {retentionTimes, mzs, intensities, charges, peaksCount} = responseReformatted;

  {retentionTimes, mzs, intensities, charges, peaksCount}

];

generatePreviewPlots[previewData_, response_] := Module[
  {
    previewDataTransposed, previewDataMzs, previewDataIntensities,
    plotRanges,
    retentionTimes, mzs, intensities, charges, peaksCount,
    allMzs, allIntensities,
    rawDataColor, deconvolutedDataColor,
    fontColor, smallFontSize, mediumFontSize, largeFontSize,
    allPlots
  },

  (* Additionally manipulate the raw data. *)
  (* Map at level 2, since preview data is additionally listed. *)
  previewDataTransposed = Map[Transpose[#]&, previewData, 2];
  previewDataMzs = Map[#[[1]]&, previewDataTransposed];
  previewDataIntensities = Map[#[[2]]&, previewDataTransposed];

  (* Manipulate deconvoluted preview data from the response. *)
  {retentionTimes, mzs, intensities, charges, peaksCount} = parsePreviewResponse[response];
  allMzs = MapThread[Join[#1, #2]&, {previewDataMzs, mzs}];
  allIntensities = MapThread[Join[#1, #2]&, {previewDataIntensities, intensities}];
  plotRanges = Map[generatePlotRange, previewDataMzs];

  (* Plot Params *)
  fontColor = LCHColor[0.4, 0, 0];
  {smallFontSize, mediumFontSize, largeFontSize} = {12, 14, 16};
  rawDataColor = Lighter[LCHColor[0.6, 1, 0.7], .4];
  deconvolutedDataColor = RGBColor[183/255,2/255,3/255];

  (* Generate the plots, and slide view if necessary. *)
  (* Note, the preview function only accepts the analyze function options, no plot options. No need to fight options resolver. *)
  allPlots = MapThread[plotMassSpectrumDeconvolutionPreview[#1, #2,
    ImageSize -> 500,
    PlotStyle->{rawDataColor, deconvolutedDataColor},
    PlotRange->{#3, Automatic},
    FrameLabel -> {"Mass-To-Charge Ratio [Dalton]", "Relative Intensity\n[Arbitrary Unit]"},
    FrameStyle -> Directive[fontColor, largeFontSize, Bold],
    FrameTicks -> {{Automatic, None}, {Automatic, None}},
    FrameTicksStyle -> Directive[fontColor, smallFontSize],
    Legend -> {Style["Raw Data", fontColor, mediumFontSize], Style["Deconvoluted Data", fontColor, mediumFontSize]},
    LegendPlacement -> Right
  ]&, {allMzs, allIntensities, plotRanges}];
  allPlots

];


(* ::Section:: *)
(* PlotObject Code *)

(* ::Subsection:: *)
(* Main Plot Function *)

(* Global Plot Params *)
fontColor = LCHColor[0.4, 0, 0];
{smallFontSize, mediumFontSize, largeFontSize} = {12, 14, 16};

(* Singleton *)
plotObjectMassSpectrumDeconvolution[input:ObjectP[Object[Analysis, MassSpectrumDeconvolution]], ops:OptionsPattern[EmeraldListLinePlot]] :=
    First@First@plotObjectMassSpectrumDeconvolution[{input}, ops]; (* Remove SlideView head and List head. *)

(* Listed *)
plotObjectMassSpectrumDeconvolution[inputs:{ObjectP[Object[Analysis, MassSpectrumDeconvolution]]..}, ops:OptionsPattern[EmeraldListLinePlot]] := Module[
  {
    dataSets, resolvedTitles, allPlots
  },

  (* Download the Data. *)
  dataSets = downloadPlotDataFromObjects[inputs];

  (* Resolve the Titles *)
  (* Display Type without ID if given a packet. *)
  resolvedTitles = Map[If[MatchQ[#, PacketP[]], ToString[#[Type]], ToString[#]]&, inputs];

  (* Pass to Primary Overload. *)
  allPlots = MapThread[plotObjectMassSpectrumDeconvolution[#1, #2, ops]&, {dataSets, resolvedTitles}];

  (* Wrap the results in SlideView and Return. *)
  SlideView[allPlots]

];

(* PrimaryOverload - MS Raw Data *)
plotObjectMassSpectrumDeconvolution[massSpectrumData:QuantityArrayP[{{Dalton, ArbitraryUnit}..}], title_, userOps:OptionsPattern[EmeraldListLinePlot]] := Module[
  {
    dataReformatted, msPlotDefaultOps, resolvedOps
  },

  dataReformatted = pointsToPeaks[massSpectrumData];

  (* Default option set. *)
  msPlotDefaultOps = {

    (* Input independent default options. *)
    FrameLabel -> {"Mass-To-Charge Ratio [Dalton]", "Relative Intensity\n[Arbitrary Unit]"},
    FrameStyle -> Directive[fontColor, largeFontSize, Bold],
    ImageSize -> 600,
    FrameTicks -> {{Automatic, None}, {Automatic, None}},
    FrameTicksStyle -> Directive[fontColor, smallFontSize, Bold],

    (* Input dependent default options. *)
    PlotLabel -> Text[title, BaseStyle -> {FontColor -> fontColor, FontSize -> largeFontSize, Bold}]

  };

  resolvedOps = resolveUserAndNewDefaultOps[EmeraldListLinePlot, {userOps}, msPlotDefaultOps];

  Zoomable@EmeraldListLinePlot[dataReformatted, Sequence@@resolvedOps]

];

(* PrimaryOverload - XCMS Raw Data *)
(* TODO: ArrayPlot does not take Output as an option, and this returns nothing with PlotObject and Inspect. Fix!! *)
plotObjectMassSpectrumDeconvolution[ionAbundance3dData:QuantityArrayP[{{Minute, Dalton, ArbitraryUnit}..}], title_, userOps:OptionsPattern[ArrayPlot]] := Module[
  {
    rtData, mzData, rtRange, mzRange, rtBins,
    matrixData, matrixDataTransposed,
    colors, weights, colorFxn,
    xcmsPlotDefaultOps, resolvedOps
  },

  (* Prepare data and data ranges. *)
  (* Tested some automatic bin size selection, but ended up with more bins than pixels for mz axis, so using hard coded value. *)
  {rtData, mzData} = QuantityMagnitude[Transpose[ionAbundance3dData[[;;,{1,2}]]]];
  {rtRange, mzRange} = {{Min[rtData], Max[rtData]}, {Min[mzData], Max[mzData]}};
  rtBins = Length[DeleteDuplicates[rtData]];

  matrixData = binIonAbundance3D[ionAbundance3dData, {rtBins, 200}];
  matrixDataTransposed = Transpose[matrixData];

  (* Define color function. *)
  colors = {LCHColor[0.4, 0, 0], Darker[LCHColor[0.9, 1, 0.2], .4], LCHColor[0.9, 1, 0.2], Lighter[LCHColor[0.9, 1, 0.2], .4]};
  weights = {0.005, 0.05, 0.5, 0.9};
  colorFxn = Evaluate[Blend[Transpose[{weights, colors}], #]]&;

  (* Default option set. *)
  xcmsPlotDefaultOps = {

    (* Input independent default options. *)
    ImageSize -> {600, 600},
    AspectRatio -> 1,
    Frame -> True,
    FrameLabel -> {"Mass-To-Charge Ratio [Daltons]", "Retention Time [Minutes]"},
    FrameStyle -> Directive[fontColor, largeFontSize, Bold],
    FrameTicks -> {{Automatic, None}, {Automatic, None}},
    FrameTicksStyle -> Directive[fontColor, smallFontSize],
    PlotLegends -> Placed[
      BarLegend[
        Automatic,
        LegendMarkerSize -> 400,
        LegendMargins -> 5,
        LegendLabel -> Placed[
          Text["Relative Intensity [Arbitrary Units]", BaseStyle -> {FontColor -> fontColor, FontSize -> largeFontSize, Bold}],
          Right, Rotate[#, -90 Degree]&
        ],
        LabelStyle -> Directive[fontColor, smallFontSize, Bold]
      ],
      Right
    ],
    ColorFunction -> colorFxn,

    (* Input dependent default options *)
    DataRange -> {rtRange, mzRange},
    PlotRangeClipping -> True,
    PlotLabel -> Text[title, BaseStyle->{FontColor -> fontColor, FontSize->largeFontSize, Bold}]

  };

  resolvedOps = resolveUserAndNewDefaultOps[ArrayPlot, {userOps}, xcmsPlotDefaultOps];

  (* Generate Plot *)
  Zoomable@ArrayPlot[matrixDataTransposed, Sequence@@resolvedOps]

];


(* ::Subsection:: *)
(* General Helper Functions *)
downloadPlotDataFromObjects[inputs:{ObjectP[Object[Analysis, MassSpectrumDeconvolution]]...}] := Module[
  {
    inputsClean,
    reference, massSpectrum, ionAbundance3D,
    referenceFlat
  },

  (* Remove append replace heads in case this is called on a packet. *)
  inputsClean = Map[
    If[MatchQ[#, PacketP[]],
      Analysis`Private`stripAppendReplaceKeyHeads[#],
      #
    ]&,
    inputs
  ];

  (* Download the required fields, quieting message in case of packet without all fields. *)
  {reference, massSpectrum, ionAbundance3D} = Quiet[
    Transpose[Download[inputsClean, {Reference, DeconvolutedMassSpectrum, DeconvolutedIonAbundance3D}]],
    {Download::MissingField}
  ];

  (* Reference is a multiple field, so it comes out listed, even though there will only be one reference for this object. *)
  referenceFlat = Flatten[reference];

  (* Select the correct data set based on the reference type and return. Other field should be null or failed. *)
  MapThread[
    Which[
      MatchQ[#1, ObjectP[Object[Data, MassSpectrometry]]], #2,
      MatchQ[#1, ObjectP[Object[Data, ChromatographyMassSpectra]]], #3
    ]&,
    {referenceFlat, massSpectrum, ionAbundance3D}
  ]

];

resolveUserAndNewDefaultOps[function_, userOps_, newDefaultOps_] := Module[
  {
    userOpsAssoc, userOpsKeys, userSemiResolvedOpsAssoc,
    userResolvedOpsAssoc, newDefaultOpsAssoc, joinedOpsAssoc,
    joinedOpsList, resolvedOpsList
  },

  (*Goal of this function to replace default options in a function like EmeraldListLinePlot with new default values, and then new user options,
  but resolving any bad user ops into the new defaults, rather than the old defaults. *)
  userOpsAssoc = Association[userOps];
  userOpsKeys = Keys[userOpsAssoc];
  (* PlotObject needs output option, which is not an option for ArrayPlot. *)
  userSemiResolvedOpsAssoc = Quiet[Association[SafeOptions[function, userOps]], {Warning::UnknownOption}];
  userResolvedOpsAssoc = Association[
    Map[
      (*Check if resolved option value is unchanged, else remove.*)
      If[MatchQ[userOpsAssoc[#], userSemiResolvedOpsAssoc[#]], # -> userOpsAssoc[#], Nothing] &,
      userOpsKeys
    ]
  ];
  newDefaultOpsAssoc = Association[newDefaultOps];
  joinedOpsAssoc = AssociateTo[newDefaultOpsAssoc, userResolvedOpsAssoc];
  joinedOpsList = KeyValueMap[#1 -> #2 &, joinedOpsAssoc];
  resolvedOpsList = SafeOptions[function, joinedOpsList];

  resolvedOpsList

];


(* ::Subsection:: *)
(* XCMS Helper Functions *)
createBinPoints1D[min_, max_, numBins_] := N@Subdivide[min, max, numBins];

createBinPoints2DWithArray[xRange_List, yRange_List, numBins_List] := Module[
  {
    xMin, xMax,  yMin, yMax, xBins, yBins,
    xBinValues, yBinValues, arrayValues
  },

  {xMin, xMax} = xRange;
  {yMin, yMax} = yRange;
  {xBins, yBins} = numBins;

  xBinValues = createBinPoints1D[xMin, xMax, xBins];
  yBinValues = createBinPoints1D[yMin, yMax, yBins];
  arrayValues = ConstantArray[0, numBins];

  {xBinValues, yBinValues, arrayValues}

];

(* https://mathematica.stackexchange.com/questions/200260/finding-the-index-of-an-element-to-be-inserted-in-a-sorted-list *)
LeftNeighbor[s_] := LeftNeighborFunction[s, Nearest[s -> "Index"]];
LeftNeighbor[s_, list_List] := LeftNeighbor[s][list];
LeftNeighbor[s_, elem_] := First@LeftNeighbor[s][{elem}];
LeftNeighborFunction[s_, nf_][list_List] := With[{n = nf[list][[All, 1]]}, n - UnitStep[s[[n]] - list]];
LeftNeighborFunction[s_, nf_][elem_] := First@LeftNeighborFunction[s, nf][{elem}];

getNumBins[data_List] := Module[
  {
    uniqueVals, minVal, maxVal,
    spacings, avgSpacing, numBins
  },

  uniqueVals = Sort[DeleteDuplicates[data]];
  minVal = Min[uniqueVals];
  maxVal = Max[uniqueVals];

  spacings = Differences[uniqueVals];
  avgSpacing = Mean[spacings];
  numBins = Ceiling[(maxVal - minVal)/avgSpacing];

  Length[uniqueVals]

];

binIonAbundance3D[data_, numBins_List] := Module[
  {
    dataUnitless,
    xVals, yVals, zVals,
    xRange, yRange,
    xBinValues, yBinValues, arrValues,
    lnfx, xIndicies,
    lnfy, yIndicies
  },

  (* Strip units and unpack the values. *)
  dataUnitless = QuantityMagnitude[data];
  {xVals, yVals, zVals} = Transpose[dataUnitless];

  (* Get the data ranges, and create the bins and array. *)
  xRange = {Min[xVals], Max[xVals]};
  yRange = {Min[yVals], Max[yVals]};
  {xBinValues, yBinValues, arrValues} = createBinPoints2DWithArray[xRange, yRange, numBins];

  (* Get the x and y bin indicies of all points. *)
  lnfx = LeftNeighbor[xBinValues];
  xIndicies = lnfx[xVals] /. {0 ->1}; (*Values at  the left edge of the left bin will give a value of 0, but should be 1. *)
  lnfy = LeftNeighbor[yBinValues];
  yIndicies = lnfy[yVals] /. {0 -> 1};

  (* Add all binned intensities and return array. *)
  MapThread[(arrValues[[#1, #2]] += #3)&, {xIndicies, yIndicies, zVals}];
  arrValues

];
