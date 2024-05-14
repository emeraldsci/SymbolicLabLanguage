
(* ::Section::Closed:: *)
(*AnalyzeDifferentialScanningCalorimetry*)

(* Patterns *)

dscInputP = ObjectP[{
        Object[Data,DifferentialScanningCalorimetry],
        Object[Protocol,DifferentialScanningCalorimetry]
}];


(* Options *)


DefineOptions[
    AnalyzeDifferentialScanningCalorimetry,
    Options :> {
        {
            OptionName -> BaselineFeatureWidth,
            Default -> 10,
            AllowNull -> False,
            Description -> "The metric that approximately describes the smallest feature size captured by the global nonlinear background.",
            Widget -> Widget[Type -> Number, Pattern :> GreaterEqualP[0]]
        },
        {
            OptionName -> SmoothingRadius,
            Default -> 5,
            AllowNull -> False,
            Description -> "The distance over which the data is smoothed to prevent the assignment of spurious peaks that arises from the natural noise in the experiment.",
            Widget -> Widget[Type -> Number, Pattern :> GreaterEqualP[0]]
        },
        {
            OptionName -> Threshold,
            Default -> Automatic,
            AllowNull -> False,
            Description -> "The threshold that determines the onset temperature in the Nonlinear method.",
            Widget -> Widget[Type -> Number, Pattern :> GreaterP[0]]
        },
        {
            OptionName -> Method,
            Default -> Nonlinear,
            AllowNull -> False,
            Description -> "The method by which the onset temperature is calculated. The Nonlinear method fits a nonlinear baseline and finds the temperature that deviates past the Threshold option. The Linear method fits lines to different portions of the curve and assigns the onset temperature as the intersection point between the lines.",
            Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Nonlinear]]
        },
        UploadOption,
        OutputOption
    }
];


(* Messages *)


(* Overloads *)

AnalyzeDifferentialScanningCalorimetry[
    protocol:ObjectP[Object[Protocol,DifferentialScanningCalorimetry]],
    myOps:OptionsPattern[]
]:=AnalyzeDifferentialScanningCalorimetry[{protocol}, myOps];

AnalyzeDifferentialScanningCalorimetry[
    protocols:{ObjectP[Object[Protocol,DifferentialScanningCalorimetry]]..},
    myOps:OptionsPattern[]
]:=Module[
    {data, flattenedData},

    (* pull out the data from each of the protocols *)
    data = Download[protocols, Data];

    (* flatten data into a 1D list for further processing *)
    flattenedData = Flatten[data];

    (* pass to main overload *)
    AnalyzeDifferentialScanningCalorimetry[flattenedData, myOps]
];

(* ----- Main code ----- *)


DefineAnalyzeFunction[
    AnalyzeDifferentialScanningCalorimetry,
    (* input pattern *)
    <|InputData -> ObjectP[Object[Data,DifferentialScanningCalorimetry]]|>,
    {
        Batch[resolveDSCInputs],
        resolveDSCOptions,
        calculateMeltingParameters,
        generateDLSPreview
    }
];

(* input resolver *)
resolveDSCInputs[KeyValuePattern[{
    UnresolvedInputs -> KeyValuePattern[{InputData->inputDataObjects_}],
    Batch->True
}]]:=Module[
    {
        listedDataObjects, packets, protocols, uniqueProtocols, data,
        dscUnitsAndMagnitudes, unitlessData, dataUnits
    },

    (* list data objects if not already listed *)
    listedDataObjects = ToList[inputDataObjects];

    (* download the actual data coordinates from the objects and the protocols *)
    packets = Download[listedDataObjects];
    data = Lookup[packets, HeatingCurves];
    protocols = Lookup[packets, Protocol];

    (* delete duplicates of protocols for storage in the packet *)
    uniqueProtocols = DeleteDuplicates[protocols];

    (* split the units and magnitudes of the data for faster processing *)
    dscUnitsAndMagnitudes = Map[unitsAndMagnitudes, data];
    {dataUnits, unitlessData} = Transpose[dscUnitsAndMagnitudes];

    (* return the unitless data and the data units for further processing *)
    <|
        ResolvedInputs -> <|Data -> data|>,
        Intermediate -> <|
            UnitlessData -> unitlessData,
            DataUnits -> dataUnits,
            DataPackets -> packets
        |>,
        Packet -> <|
            Replace[Protocol] -> (Link /@ protocols),
            Replace[Reference] -> (Link[#, Analyses]& /@ listedDataObjects)
        |>,
        Batch -> True
    |>
];


(* resolve the options *)
resolveDSCOptions[KeyValuePattern[{
    ResolvedOptions -> resolvedOps_
}]]:=Module[
    {resolvedMethodOption},

    (* replace the automatic method with the nonlinear method *)
    resolvedMethodOption = Replace[Lookup[resolvedOps, Method], Automatic->Nonlinear, {1}];

    (* return the updated options *)
    <|
        ResolvedOptions -> <|
            Method -> resolvedMethodOption
        |>,
        (* TODO: report bug here that Tests -> <||> gets processed strangely and returns errors *)
        Tests -> <|Inputs -> {}|>
    |>
];

(* calculate the onset temperature *)
calculateMeltingParameters[KeyValuePattern[{
    ResolvedOptions -> resolvedOps_,
    Intermediate -> KeyValuePattern[{
        UnitlessData -> data_,
        DataUnits -> units_
    }]
}]]:=Module[
    {
        resultPacket, peaksObject, xUnits, yUnits,
        onsetDE, onsetTemp
    },

    (* switch based on method *)
    resultPacket = Switch[Lookup[resolvedOps, Method],
        Nonlinear, nonlinearMethod[data, resolvedOps],
        Linear, linearMethod[data, resolvedOps]
    ];

    (* upload the analysis object if applicable *)
    (* TODO: figure out how to batch this upload *)
    peaksObject = If[Lookup[resolvedOps, Upload],
        Upload[Lookup[resultPacket, PeaksPacket]],
        Null
    ];

    (* unpack units to use in returning the packet *)
    {xUnits, yUnits} = units;

    (* pull out onset temperature from result packet *)
    onsetTemp = Lookup[resultPacket, OnsetTemperature];
    onsetDE = Lookup[resultPacket, OnsetEnthalpy];

    (* return the results *)
    <|
        Packet -> <|
            Type -> Object[Analysis, DifferentialScanningCalorimetry],
            Replace[MeltingTemperatures] -> Quantity[Lookup[resultPacket, MeltingTemperatures], xUnits],
            Replace[MeltingDifferentialEnthalpies] -> Quantity[Lookup[resultPacket, MeltingEnthalpies], yUnits],
            If[Not[MatchQ[onsetTemp,Null]],
                Replace[OnsetTemperature] -> Quantity[onsetTemp, xUnits],
                Replace[OnsetTemperature] -> Null
            ],
            Replace[OnsetDifferentialEnthalpy] -> If[Not[MatchQ[onsetDE,Null]],
                Quantity[onsetDE, yUnits],
                Null
            ],
            If[MatchQ[peaksObject, Null],
                Nothing,
                Append[PeaksAnalyses] -> Link[peaksObject]
            ]
        |>
    |>
];

nonlinearMethod[rawData_, ops_]:=Module[
    {
        (* necessary options *)
        backgroundFrequency, smoothingRadius, threshold, resolvedThreshold, relThreshold,
        (* peaks data *)
        peaksPacketWithKeyHeads, peaksPacket, backgroundFunction, backgroundValues,
        (* data processing *)
        data, xvals, yvals, yRange, noBackgroundData,
        (* results *)
        onsetTemp, peakPositions
    },

    (* NOTE: this assumes there is only one heating curve in the data packet, which appears to always be the case for now *)
    (* TODO: come up with a strategy for handling a datapacket with multiple heating curves *)
    data = First[rawData];

    (* get the background frequency and smoothing radius from the options *)
    {backgroundFrequency, smoothingRadius} = Lookup[ops, {BaselineFeatureWidth, SmoothingRadius}];

    (* get the threshold from the options *)
    threshold = Lookup[ops, Threshold];

    (* find the relative threshold from the range of the data *)
    yvals = Last /@ data;
    yRange = Max[yvals] - Min[yvals];
    relThreshold = yRange / 5.;

    (* use analyze peaks on the data with appropriate options to get the nonlinear background *)
    peaksPacketWithKeyHeads = AnalyzePeaks[
        data,
        SmoothingRadius -> {smoothingRadius},
        Baseline -> DomainNonlinear,
        BaselineFeatureWidth -> backgroundFrequency,
        RelativeThreshold -> {relThreshold},
        Upload -> False
    ];

    (* strip off the append and replace heads from the packet for easy access *)
    peaksPacket = stripAppendReplaceKeyHeads[peaksPacketWithKeyHeads];

    (* get the background from the returned packet *)
    backgroundFunction = Lookup[peaksPacket, BaselineFunction];

    (* subtract the background from the data by evaluating the background function
    at each x-point in the data, and subtracting from the y-vals *)
    xvals = First /@ data;
    backgroundValues = backgroundFunction /@ xvals;
    noBackgroundDataValues = yvals - backgroundValues;
    noBackgroundData = Transpose[{xvals, noBackgroundDataValues}];

    (* if threshold is automatic at this point, set it to 5% of the max peak height *)
    resolvedThreshold = If[MatchQ[threshold,Automatic],
        0.1 * Max[noBackgroundDataValues],
        threshold
    ];

    (* using the threshold find the first temperature that deviates from the background *)
    onsetTemp = findFirstTempOverThreshold[noBackgroundData, resolvedThreshold];

    (* get the differential enthalpy at the onset temp *)
    onsetDiffEnthalpy = First[PickList[yvals, xvals, onsetTemp], Null];

    (* get the peak positions, peak heights, and baseline function from the packet *)
    {peakPositions, relativeHeights, baselineFunction} = Lookup[peaksPacket, {Position, Height, BaselineFunction}];

    (* add the baseline to the relative heights to get the raw peak heights *)
    peakHeights = MapThread[#1 + baselineFunction[#2]&, {relativeHeights, peakPositions}];

    (* return the onset temperature and peak positions as a list *)
    <|
        OnsetTemperature -> onsetTemp,
        OnsetEnthalpy -> onsetDiffEnthalpy,
        MeltingTemperatures -> peakPositions,
        MeltingEnthalpies -> peakHeights,
        PeaksPacket -> peaksPacketWithKeyHeads
    |>
];

(* helper that finds the first temperature over the threshold *)
findFirstTempOverThreshold[data_, threshold_]:=Module[
    {tempResult},

    (* wrap a catch statement to grab the first throw of the inner function *)
    tempResult = Catch[Map[checkThreshold[#, threshold]&, data]];

    (* in case that no temp was found, we get a list of nulls *)
    (* in this case, return just 1 null *)
    If[MatchQ[tempResult, {Null..}],
        First[tempResult],
        tempResult
    ]
];

(* second helper that throws the first temperature over the threshold *)
checkThreshold[dataPoint_, threshold_]:=Module[
    {},
    (* check if y-val of the data is greater than the threshold *)
    If[Last[dataPoint] > threshold,
    (* if it is throw the x-val and exit the loop *)
        Throw[First[dataPoint]]
    ]
];

linearMethod[data_, ops_]:=Module[
    {},

    (* use analyze peaks with the appropriate options to find the tangent points *)

    (* get the relevant tangent data from the peaks packet *)

    (* intersect the tangent lines to find the onset temp *)

    (* return the onset temp and peak positions as a list *)
    $Failed
];


(* ----- PREVIEW helper ----- *)
generateDLSPreview[KeyValuePattern[{
    (* TODO: stopping point, but finish this *)
    Intermediate -> KeyValuePattern[{DataPackets -> dataPacket_}],
    Packet -> packetWithKeyHeads_
}]]:=Module[
    {packet, updatedDataPacket, plot},

    (* remove the Append and Replace key heads *)
    packet = stripAppendReplaceKeyHeads[packetWithKeyHeads];

    (* add packet to existing data object to mimic linked field *)
    updatedDataPacket = Join[dataPacket, <|Analyses->{packet}|>];

    (* call to plot function to get basic plot *)
    plot = PlotDifferentialScanningCalorimetry[updatedDataPacket];

    (* TODO: add stuff to preview plot depending on method option *)
    (* for now just return the normal plot *)
    <|
        Preview -> plot
    |>
];
