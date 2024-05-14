(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(*
    Code Organization
        Multi-modal analysis (to be implemented)
        Options
        Protocol Overloads
        Data DynamicLightScattering (kdB22) - V1 Framework
        Data MeltingCurve (thermal shift) - V1 Framework
        Helper Functions
            Cumulants Method for particle sizes
            kD calculations
            ColloidalStability (B22/G22) calculations
*)


(* ---------------------------------------- FOR DEREK ---------------------------------------- *)
(*
    below is a rudimentary implementation of linear expansion of exponentials in
    which the expansion coefficients are fit with non-negative least squares and a
    L1 (LASSO) regularizer.

    I don't exactly know the API you're going for, but I copied some inputs from the
    cumulant method so there should be some consistency.
*)

regularizedLeastSquares[
    correlationCurve_QuantityArray,
    gammaValues_,
    (* NOTE: these should be "LASSO" and 1 by default to get similar plots to my notebook *)
    (* I'm leaving this general so that we can use other regularizers in the future *)
    (* The allowed regularizers by MM are "Tikhonov", "LASSO", "Variation", "TotalVariation", "Curvature" *)
    (* they do allow the input of a general regularizer function, but let's ignore that *)
    regularizer_,
    regularizerHyperparameter_
]:=Module[
    {
        (* data pre-processing *)
        unitlessData,
        (* fitting inputs and details *)
        coeffSymbols, expressionTerms, expression, constraints,
        (* fitting results and post-processing *)
        fitResult, error, coefficients, fittedCoeffValues, midPointValues,
        innerGammaWeights, gammaWeights
    },

    (* strip the units off the correlation curve for performance *)
    unitlessData = Unitless[correlationCurve];

    (* programmatically create the coefficient symbols based on the length of the gamma values *)
    (* the symbols will be c1, c2, ..., cN where N is the length of gammaValues *)
    coeffSymbols = Map[Symbol["c" <> ToString[#]] &, Range[Length[gammaValues]]];

    (* create the expression that will be used for fitting *)
    (* the resulting expression will be c1*e^(-g1*t)+c2*e^(-g2*t)+... *)
    expressionTerms = MapThread[#1*Exp[-#2*time]&, {coeffSymbols, gammaValues}];

    (* convert the list of terms into a sum by converting the list head into a plus *)
    expression = expressionTerms /. {List -> Plus};

    (* build the set of constraints necessary to keep the coefficients positive or 0 *)
    constraints = Map[(# >= 0) &, coeffSymbols];

    (* use the constraints, the expression, and the fitting coefficients to
    find the sparse solution to the problem *)
    (* the coefficients will be in the form {c1->val1, c2->val2, ...} *)
    fitResult = FindFit[
        unitlessData,
        {expression, constraints},
        coeffSymbols,
        time,
        FitRegularization -> {regularizer, regularizerHyperparameter}
    ];

    (* get the coefficient values from the coefficient rules *)
    fittedCoeffValues = Last /@ fitResult;

    (* create the distribution function from the fitted coefficients and the gamma values *)
    midPointValues = findMidPointValuesBetweenPoints[gammaValues];

    (* define the weights associated with each coefficient at a specific gamma by the distance between midpoint values *)
    (* this is analogous to deltaGamma in evenly spaced gamma grids, but suffers from less of the bias included in uneven grids *)
    (*
        we could have used Differences[gammaValues], and prepended gammaValues[[1]] to get naive weights
        but this biases the prob distribution to the "left", as each coefficient corresponds to a rectangle
        to the left of the gamma value, and its width spans to the next adjacent gamma point to the left
        Using  the differences of midpoint values ensures that our rectangles are most centered on the gamma
        grid points, which minimizes the discretization error of our choice in the finite gamma grid.
    *)
    innerGammaWeights = Differences[midPointValues];

    (* prepend the first value of midpoint vals, and append the last of the inner gamma weights *)
    (* this is necessary to get a list of weights that is the same length as gammaValues *)
    gammaWeights = Prepend[
        Append[innerGammaWeights, Last[innerGammaWeights]],
        First[midPointValues]
    ];

    (* use gamma values, gamma weights, and associated coefficient values to create the gamma probability distribution *)
    createProbabilityDistribution[fittedCoeffValues, gammaValues, gammaWeights]
];

(* helper that finds the midpoints between a list of numbers *)
findMidPointValuesBetweenPoints[numbers:{_?NumericQ..}]:=Module[
    {copy1, copy2},

    (* easiest way to do this is to duplicate the list, remove the first from one
    copy, remove the last element from the other, and element-wise average the lists *)
    copy1 = Most[numbers];
    copy2 = Rest[numbers];
    (copy1 + copy2)/2
];

(* helper that creates a probability distribution given the grid, values, and weights *)
(* useful to think of each of these as probability[gridPoint]*weight = value *)
createProbabilityDistribution[values_List, gridPoints_List, weights_List]:=Module[
    {contributions, normalization, probabilities},

    (* multiply vals by weights to get unnormalized probs for each grid point *)
    contributions = values / weights;

    (* total the contributions to get the normalization factor *)
    normalization = Total[values];

    (* normalize contributions to convert to probabilities *)
    probabilities = contributions / normalization;

    (* return as a list of {grid, probability} pairs *)
    Transpose[{gridPoints, probabilities}]
];

(* -------------------------------- END -------------------------------- *)


(*log space range generation *)
logspace[a_,b_,n_]:=10.0^Range[a,b,(b-a)/(n-1)];

(* Define function options *)
DefineOptions[AnalyzeDynamicLightScattering,

    Options :> {
        {
            OptionName -> Method,
            Default -> Automatic,
            Description -> "The method used to determine the particle sizes.",
            ResolutionDescription -> "If the protocol instrument is the Dynamic Light Scattering Plate Reader, the default Method is Cumulants and if the protocol instrument is MultimodeSpectrophotometer, the default Method is Instrument.",
            AllowNull -> False,
            Category -> "General",
            Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Instrument, Cumulants]]
        },
        {
            OptionName -> PolynomialDegree,
            Default -> 3,
            Description -> "The order of the polynomial used in the cumulants method.",
            AllowNull -> False,
            Category -> "General",
            Widget -> Widget[Type -> Number, Pattern :> RangeP[2, 4, 1]]
        },
        {
            OptionName -> ConvergenceTimeThreshold,
            Default -> 1000000 Microsecond,
            Description -> "The time before which the correlation curves must drop to the ConvergenceCorrelationThreshold fraction of the initial value to be considered in the data analysis.",
            AllowNull -> False,
            Category -> "General",
            Widget -> Widget[Type->Quantity,Pattern:>GreaterP[0 Microsecond], Units -> Alternatives[Microsecond, Second]]
        },
        {
            OptionName -> ConvergenceCorrelationThreshold,
            Default -> 0.05,
            Description -> "The value that the correlation curve must drop below for the convergence before the ConvergenceTimeThreshold to be considered in the data analysis.",
            AllowNull -> False,
            Category -> "General",
            Widget -> Widget[Type->Number,Pattern:>GreaterP[0]]
        },
        {
            OptionName -> InitialTimeThreshold,
            Default -> 3 Microsecond,
            Description -> "The point in time before which the average correlation data must exceed the InitialCorrelationMinimumThreshold and remain below the InitialCorrelationMaximumThreshold for the correlation curve to be considered in the analysis.",
            AllowNull -> False,
            Category -> "General",
            Widget -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0 Microsecond], Units -> Alternatives[Microsecond|Millisecond|Second]]
        },
        {
            OptionName -> InitialCorrelationMinimumThreshold,
            Default -> 0.7,
            Description -> "The value that the average correlation data must exceed before the TimeThreshold for the correlation curve to be considered in the analysis.",
            AllowNull -> False,
            Category -> "General",
            Widget -> Widget[Type->Number,Pattern:>GreaterP[0.01]]
        },
        {
            OptionName -> InitialCorrelationMaximumThreshold,
            Default -> 1.05,
            Description -> "The value that the average correlation data must be below before the TimeThreshold for the correlation curve to be considered in the analysis.",
            AllowNull -> False,
            Category -> "General",
            Widget -> Widget[Type->Number,Pattern:>GreaterEqualP[1]]
        },
        {
            OptionName -> CorrelationMinimumValue,
            Default -> 0.02,
            Description -> "The value the correlation curve data must exceed to be included in the correlation curve fitting. This is used to eliminate fitting noise near zero.",
            AllowNull -> False,
            Category -> "General",
            Widget -> Widget[Type->Number,Pattern:>RangeP[0,0.2]]
        },
        {
            OptionName -> CorrelationMinimumMethod,
            Default -> Absolute,
            Description ->  "The method used to calculate the CorrelationThresholdValue. The absolute threshold uses the value directly and the relative threshold scales the value by the initial correlation curve measurement.",
            AllowNull -> False,
            Category -> "General",
            Widget -> Widget[Type->Enumeration,Pattern:>Alternatives[Absolute|Relative]]
        },
        {
            OptionName -> OpticalConstant,
            Default -> Automatic,
            Description ->  "The optical constant used in the fitting procedure to estimate the second virial coefficient. Either the OpticalConstant or RefractiveIndexConcentrationDerivative can be specified, but not both.",
            AllowNull -> False,
            Category -> "General",
            Widget -> Widget[Type->Quantity,Pattern :> RangeP[0 Centimeter^2*Mole/Gram^2, 1*10^-5 Centimeter^2*Mole/Gram^2], Units -> Alternatives[Centimeter^2*Mole/Gram^2]]
        },
        {
            OptionName -> RefractiveIndexConcentrationDerivative,
            Default -> Automatic,
            Description ->  "The derivative of the refractive index with respect to the concentration. This value is used to estimate the optical constant used in the estimate of the second virial coefficeint. Either the OpticalConstant or RefractiveIndexConcentrationDerivative can be specified, but not both.",
            AllowNull -> False,
            Category -> "General",
            Widget -> Widget[Type->Quantity,Pattern :> RangeP[0 Centimeter^3/Gram, 1 Centimeter^3/Gram], Units -> Alternatives[Centimeter^3/Gram]]
        },
        {
            OptionName -> CalibrationStandardIntensity,
            Default -> Automatic,
            Description ->  "The measured intensity of the standard used in the calibration of the instrument.",
            AllowNull -> False,
            Category -> "General",
            Widget -> Widget[Type->Number,Pattern:>GreaterP[0]]
        },
        OutputOption,
        UploadOption
    }

];

(* Warnings and errors *)
Error::OverSpecifiedOpticalConstant = "The OpticalConstant and RefractiveIndexConcentrationDerivative cannot both be specified.";
Error::UnsupportedProtocol = "Only melting curve data generated from the ThermalShift protocol is supported.";
Error::MinExceedsMax = "The InitialCorrelationMinimumThreshold, `1`, exceeds the initialCorrelationMaximumThreshold, `2`, please adjust the options so that the minimum threshold is less than the maximum threshold.";
Error::UseCumulantsMethod = "When the instrument is DLSPlateReader, it uses Cumulants method (ISO 22412) for autocorrelation function. The option value of Method should be Cumulants";

Warning::BadInstrumentData = "In data object, `1`, non-numeric instrument data was detected in row `2` of the data files. The data was removed from further dynamic light scattering analysis.";
Warning::NonSpecificationOption = "The option(s), `1`, are outside of the suggested value for ISO documentation or the instrument manufacturer recommendation.";
Warning::CurvesOutsideRange = "In data object, `1`, the first part of correlation curve(s) was outside the expected range of `2` to `3`, which may indicate improper loading or sampling. The estimated particle size properties may not be accurate.";
Warning::CurvesOutsideRangeRemoved = "In data object, `1`, the first part of a correlation curve(s) at assay condition, `2`, was outside the expected range of `3` to `4`, which may indicate improper loading or sampling. The correlation curves were removed from further analysis. To expand the acceptable range, please increase the InitialCorrelationMaximumThreshold, `4`, and lower the InitialCorrelationMinimumThreshold, `3`";
Warning::UnknownSolventViscosity = "The solvent, `1`, does not have viscosity information available. The calculation will use water viscosity instead.";
(* FUNCTION OVERLOADS *)

(* DLS Protocol *)
AnalyzeDynamicLightScattering[myProtocol:ObjectP[Object[Protocol, DynamicLightScattering]], ops:OptionsPattern[AnalyzeDynamicLightScattering]]:=Module[
    {},
    AnalyzeDynamicLightScattering[myProtocol[Data], ops]
];

(* Thermal Shift Protocol *)
AnalyzeDynamicLightScattering[myProtocol:ObjectP[Object[Protocol, ThermalShift]], ops:OptionsPattern[AnalyzeDynamicLightScattering]]:=Module[
    {},
    AnalyzeDynamicLightScattering[myProtocol[Data], ops]
];


(* Main function *)
(*Define Analyze Function which breaks down the key steps*)
DefineAnalyzeFunction[
	AnalyzeDynamicLightScattering,
	<|
        InputData -> ObjectP[Object[Data, DynamicLightScattering]]
	|>,
	{
        analyzeDownloadInstrument,
        analyzeDownloadInputDynamicLightScattering,
        analyzeResolveInputDynamicLightScattering,
        analyzeResolveOptionsDynamicLightScattering,
        analyzeResolveAssayOptionsDynamicLightScattering,
        analyzeCalculateDynamicLightScattering,
        analyzePreviewDynamicLightScattering
	}

];

DefineAnalyzeFunction[
	AnalyzeDynamicLightScattering,
	<|
        InputData -> ObjectP[Object[Data, MeltingCurve]]
	|>,
	{
        analyzeProtocolMeltingCurve,
        analyzeDownloadInstrument,
        analyzeDownloadInputDynamicLightScattering,
        analyzeResolveOptionsDynamicLightScattering,
        analyzeCalculateDynamicLightScattering,
        analyzePreviewDynamicLightScattering
	}

];


(* For Object[Data, MeltingCurve], only the data from ThermalShift protocol is allowed. *)
analyzeProtocolMeltingCurve[
    KeyValuePattern[{
        UnresolvedInputs->KeyValuePattern[{
            InputData->inputData:ObjectP[Object[Data, MeltingCurve]]
        }]
    }]
]:=Module[{protocol},
    protocol = Download[inputData, Protocol];
    If[!MatchQ[protocol, ObjectP[Object[Protocol, ThermalShift]]],
        Message[Error::UnsupportedProtocol];
        Return[$Failed]
    ];
    <|
        Intermediate-><|
            ThisProtocol->protocol
        |>
    |>
];

(* Download instrument information for overload in next steps. *)
analyzeDownloadInstrument[
    KeyValuePattern[{
        UnresolvedInputs->KeyValuePattern[{
            InputData->inputData_
        }]
    }]
]:=Module[{instrument},
    instrument = Download[inputData, Instrument];
	
    <|
        Intermediate-><|
            ThisInstrument -> instrument
        |>
    |>
];

(*Download inputs for MultimodeSpectrophotometer (Uncle) - download all the same fields for each Assay Type *)
analyzeDownloadInputDynamicLightScattering[
	KeyValuePattern[{
		UnresolvedInputs->KeyValuePattern[{
			InputData -> inputData:ObjectP[Object[Data, DynamicLightScattering]]
		}],
        Intermediate->KeyValuePattern[{
            ThisInstrument -> thisInstrument:ObjectP[Object[Instrument, MultimodeSpectrophotometer]]
        }]
	}]
]:= Module[
    {
        wavelengthList, correlationCurvesData, correlationCurveData,
        temperatureValue, tolueneLightIntensityValue, rawDataFiles, assayType,
        calibrationDate, molecularWeight, protocol, protocolData, uncleFullDataTable,
        viscosityList, dynamicViscosity, solventRefractiveIndexList, solventRefractionIndex,
        detectionAngle, wavelengthValue, wavelengthNanometer, scatteringVector,
        diffusionToGamma, zAverageDiameters, isothermalStabilityTimes, downloadFieldName, inputDataObject
    },

    (* Batch download all fields up front *)
    {
	inputDataObject,
        wavelengthList,
        correlationCurvesData,
        correlationCurveData,
        temperatureValue,
        tolueneLightIntensityValue,
        rawDataFiles,
        assayType,
        calibrationDate,
        protocol,
        protocolData,
        zAverageDiameters
    } = Quiet[Download[
        inputData,
		{
			Object,
            		Protocol[Instrument][DynamicLightScatteringWavelengths],
            		CorrelationCurves,
            		CorrelationCurve,
            		Temperature,
            		Protocol[CalibrationStandardIntensity],
           		RawDataFiles,
            		Protocol[AssayType],
            		Protocol[Instrument][RecentQualifications],
            		Protocol,
            		Protocol[Data],
            		ZAverageDiameters
		}
	], {Download::MissingField}];
	
    (* "Analyte" is the new field name that does not exist in previous data object.*)
    downloadFieldName = If[Quiet[MatchQ[Download[inputData, Analyte], $Failed|Null]],
        AssayProtein[MolecularWeight],
        Analyte[MolecularWeight]
    ];
    (* Download with the proper field name*)
    molecularWeight = Download[inputData, downloadFieldName];

    isothermalStabilityTimes = zAverageDiameters[[;;,1]];

    (*
        There are many raw data files in the Data object. The number depends on
        the AssayType. However, we only use the first one
    *)

    (* resolve common values for all assay types *)
    (*Download the first raw data file which contains the summary info from the experiment *)
    uncleFullDataTable = ImportCloudFile[rawDataFiles[[1]]];

    (* for viscosity and refractive index, assume they are constant *)
    viscosityList = ToExpression[Rest[uncleFullDataTable[[1]][[;; , -5]]]];
    dynamicViscosity = Mean[viscosityList] * Centipoise;

    solventRefractiveIndexList = ToExpression[Rest[uncleFullDataTable[[1]][[;; , -4]]]];
    solventRefractionIndex = Mean[solventRefractiveIndexList];

    (* The detection angle is hard coded *)
    (* https://www.youtube.com/watch?v=byoPIbzZ9XE, states that Uncle uses a 90 degree angle *)
    detectionAngle = Pi/2;

    (* Pull wavelength value out of the list, assumed to be length one *)
    wavelengthValue = First[wavelengthList];
    wavelengthNanometer = Convert[wavelengthValue, Nanometer];

    (* The scattering vector is in units of nanometers *)
    scatteringVector = 4*Pi*solventRefractionIndex*Sin[detectionAngle/2]/wavelengthNanometer;

    (* conversion between gamma and diffusion, gamma = 2q^2*diffusion, q is the scattering vector *)
    diffusionToGamma = 2*scatteringVector^2;

    (* Convert temperature to Kelvin *)
    temperatureValue = Convert[temperatureValue, Kelvin];

    <|
        ResolvedInputs-><|
	    InputDataObject -> inputDataObject,
            WavelengthNanometer -> wavelengthNanometer,
            DynamicViscosity -> dynamicViscosity,
            SolventRefractionIndex -> solventRefractionIndex,
            DiffusionToGamma -> diffusionToGamma,
            TemperatureValue -> temperatureValue,
            AssayType -> assayType,
            UncleFullDataTable -> uncleFullDataTable,
            ProtocolData -> protocolData,
            CorrelationCurvesData -> correlationCurvesData,
            CorrelationCurveData -> correlationCurveData,
            TolueneLightIntensityValue -> tolueneLightIntensityValue,
            MolecularWeight -> molecularWeight,
            RawDataFiles -> rawDataFiles,
            IsothermalStabilityTimes -> isothermalStabilityTimes
        |>,
        Packet -> <|
            Type -> Object[Analysis, DynamicLightScattering],
            Replace[Protocols] -> Link[protocol],
            Replace[Reference] -> Link[inputData, DynamicLightScatteringAnalyses],
            RefractiveIndex -> solventRefractionIndex,
            AverageViscosity -> dynamicViscosity,
            CalibrationDate -> calibrationDate[[1]][[1]]
        |>
    |>
];

(*Download inputs for DLSPlateReader (DynaPro) - download all the same fields for each Assay Type *)
analyzeDownloadInputDynamicLightScattering[
    KeyValuePattern[{
        UnresolvedInputs->KeyValuePattern[{
            InputData -> inputData:ObjectP[Object[Data, DynamicLightScattering]]
        }],
        Intermediate->KeyValuePattern[{
            ThisInstrument -> thisInstrument:ObjectP[Object[Instrument, DLSPlateReader]]
        }]
    }]
]:= Module[
    {
        wavelengthList, correlationCurvesData, correlationCurveData, temperatureValue, tolueneLightIntensityValue, assayType,
        calibrationDate, molecularWeight, protocol, protocolData, viscosityCentipoise, solventRefractionIndex,
        detectionAngle, wavelengthValue, wavelengthNanometer, scatteringVector,
        diffusionToGamma, zAverageDiameter, zAverageDiameters, polyDispersityIndex,polyDispersityIndices,
        viscosity, zAverageDiffusionCoefficient, estimatedMolecularWeight, linkedField, samplesInComposition, solvent
    },

    (* Batch download all fields up front *)
    {
        wavelengthList,
        correlationCurvesData,
        correlationCurveData,
        temperatureValue,
        tolueneLightIntensityValue,
        assayType,
        calibrationDate,
        molecularWeight,
        protocol,
        protocolData,
        samplesInComposition,
        zAverageDiameter,
        zAverageDiameters,
        zAverageDiffusionCoefficient,
        polyDispersityIndex,
        polyDispersityIndices,
        solventRefractionIndex,
        estimatedMolecularWeight
    } = Download[
        inputData,
        {
            Protocol[Instrument][DynamicLightScatteringWavelengths], (*sizingPolyDispersity, isoThermalStability*)
            CorrelationCurves, (*isoThermalStability*)
            CorrelationCurve, (*sizingPolyDispersity*)
            Temperature, (*sizingPolyDispersity, isoThermalStability*)
            Protocol[CalibrationStandardIntensity],
            Protocol[AssayType],
            Protocol[Instrument][RecentQualifications],
            Analyte[MolecularWeight],
            Protocol,
            Protocol[Data],
            Protocol[SamplesIn][Composition],
            ZAverageDiameter, (*sizingPolyDispersity*)
            ZAverageDiameters, (*isoThermalStability*)
            ZAverageDiffusionCoefficient, (*all*)
            PolydispersityIndex, (*sizingPolyDispersity*)
            PolydispersityIndices, (*isoThermalStability*)
            SolventRefractiveIndex, (*all*)
            EstimatedMolecularWeight
        }
    ];

    (* for viscosity and refractive index, assume they are constant *)
    (* get the solvent name*)
    solvent = getSolvent[samplesInComposition];

    (* Get viscosity from interpolation of given table *)
    viscosity = viscosityCalculation[solvent, temperatureValue];
    viscosityCentipoise = Quantity[viscosity, Centipoise];

    detectionAngle = Pi/2;

    (* Pull wavelength value out of the list, assumed to be length one *)
    wavelengthValue = First[wavelengthList];
    wavelengthNanometer = Convert[wavelengthValue, Nanometer];

    (* The scattering vector is in units of nanometers *)
    scatteringVector = 4*Pi*solventRefractionIndex*Sin[detectionAngle/2]/wavelengthNanometer;

    (* conversion between gamma and diffusion, gamma = 2q^2*diffusion, q is the scattering vector *)
    diffusionToGamma = 2*scatteringVector^2;

    (* Convert temperature to Kelvin *)
    temperatureValue = Convert[temperatureValue, Kelvin];

    <|
        ResolvedInputs-><|
            WavelengthNanometer -> wavelengthNanometer,
            DynamicViscosity -> viscosityCentipoise,
            DiffusionToGamma -> diffusionToGamma,
            TemperatureValue -> temperatureValue,
            AssayType -> assayType,
            UncleFullDataTable -> {},
            ProtocolData -> protocolData,
            CorrelationCurvesData -> correlationCurvesData,
            CorrelationCurveData -> correlationCurveData,
            TolueneLightIntensityValue -> tolueneLightIntensityValue,
            MolecularWeight -> molecularWeight,
            RawDataFiles -> {},
            ZAverageDiameter -> zAverageDiameter,
            ZAverageDiameters -> zAverageDiameters,
            ZAverageDiffusion -> zAverageDiffusionCoefficient,
            PolydispersityIndex -> polyDispersityIndex,
            PolydispersityIndices -> polyDispersityIndices,
            SolventRefractionIndex -> solventRefractionIndex,
            ApparentMolecularWeight -> estimatedMolecularWeight
        |>,
        Packet -> <|
            Type -> Object[Analysis, DynamicLightScattering],
            Replace[Protocols] -> Link[protocol],
            Replace[Reference] -> Link[inputData, DynamicLightScatteringAnalyses],
            RefractiveIndex -> solventRefractionIndex,
            AverageViscosity -> viscosityCentipoise,
            CalibrationDate -> calibrationDate[[1]][[1]]
        |>
    |>
];


(* for IsothermalStability the correlation curve data needs to be parsed *)
correlationCurveParser[rawCorrelation_]:=Module[
	{correlationCurve},

	(* the first three data points are meta info *)
	correlationCurve = rawCorrelation[[4;;]];

	(* get the first two columns. the first data in each sample has two extra empty columns *)
	correlationCurve = correlationCurve[[;; , ;;2]];

	(* add units *)
	QuantityArray[correlationCurve, {Second, ArbitraryUnit}]
];


(* Uncle: Resolve inputs IsothermalStability *)
analyzeResolveInputDynamicLightScattering[
    KeyValuePattern[{
        UnresolvedInputs->KeyValuePattern[{
            InputData->inputData:ObjectP[Object[Data, DynamicLightScattering]]
        }],
        Intermediate->KeyValuePattern[{
            ThisInstrument -> thisInstrument:ObjectP[Object[Instrument, MultimodeSpectrophotometer]]
        }],
        ResolvedInputs->KeyValuePattern[{
            AssayType -> assayType:IsothermalStability,
            UncleFullDataTable -> uncleFullDataTable_,
            ProtocolData -> protocolData_,
            RawDataFiles -> rawDataFiles_,
            IsothermalStabilityTimes -> isothermalStabilityTimes_,
			CorrelationCurvesData -> correlationCurvesData_
        }]
    }]
]:= Module[
    {
        dataIndex, zAverageDiameter, zAverageDiffusion,
        polydispersityIndex, peakOneDiameter, correlationCurvesRaw, timeIncrements,
        correlationCurveSpan, fullDataInidices, correlationCurvesDataOnly,
	correlationCurvesDataRaw
    },

    correlationCurvesRaw = ImportCloudFile[rawDataFiles[[3]]];

    (* find index of data object in the protocol *)
    dataIndex = Position[protocolData, inputData];
    dataIndex = If[MatchQ[dataIndex, {}], 1, First[Flatten[dataIndex]]];

    (* find length of time in data set *)
    timeIncrements = Length[isothermalStabilityTimes];

    (* pull off the index match isothermal stability times and keep only the correlation curves *)
    correlationCurvesDataOnly = correlationCurvesData[[;;,2]];

    (* if the curve data is not present parse from the raw data *)
    correlationCurvesDataOnly = If[MatchQ[correlationCurvesDataOnly, {}],
		
		(*
        		find index of input data for the correlation curves (backwards from uncleFullDataTable)
        		there is an empty list at the end of correlations curves, after that the samples are counted from the bottom.
        		starting with (data 1, time 1), (data 1, time 2), ...
    		*)
		correlationCurveSpan = Span[
			(-(dataIndex)*timeIncrements-1),
			(-(dataIndex-1)*timeIncrements-2)
		];
		
		(* pull out relevant correlation curves *)
		correlationCurvesDataRaw = correlationCurvesRaw[[correlationCurveSpan]];
		
		(* clean up the relevant correlation curves *)
		correlationCurveParser/@correlationCurvesDataRaw,
		
		(* otherwise keep data as is *)
		correlationCurvesDataOnly
		
    ];

    (* find index of data in the base data set *)
    fullDataInidices = Span[
        (dataIndex-1)*timeIncrements+1,
        (dataIndex)*timeIncrements
    ];

    (* pull out the parameters for SizingPolydispersity *)
    {
        zAverageDiameter,
        zAverageDiffusion,
        polydispersityIndex,
        peakOneDiameter
    } = Map[
        uncleTableRowExtract[uncleFullDataTable, #, fullDataInidices]&,
        (* rows to pull *)
        {5, 6, 8, 11}
    ];

    (* Reformat the extracted values by units *)
    zAverageDiameter  = Quantity[zAverageDiameter, Nanometer];
    peakOneDiameter   = Quantity[peakOneDiameter, Nanometer];

    (* Diffusion coefficient has to be reformatted before adding units *)
    zAverageDiffusion = diffusionParse/@zAverageDiffusion;
    zAverageDiffusion = Quantity[zAverageDiffusion, Meter^2/Second];

	<|
        	ResolvedInputs-><|
            		CorrelationCurvesData -> correlationCurvesDataOnly,
            		ZAverageDiameter -> zAverageDiameter,
            		ZAverageDiffusion -> zAverageDiffusion,
            		PolydispersityIndex -> polydispersityIndex,
            		PeakOneDiameter -> peakOneDiameter
        	|>
	|>
];


(* Uncle: Resolve inputs SizingPolydispersity *)
analyzeResolveInputDynamicLightScattering[
    KeyValuePattern[{
        UnresolvedInputs->KeyValuePattern[{
            InputData->inputData:ObjectP[Object[Data, DynamicLightScattering]]
        }],
        Intermediate->KeyValuePattern[{
            ThisInstrument -> thisInstrument:ObjectP[Object[Instrument, MultimodeSpectrophotometer]]
        }],
        ResolvedInputs->KeyValuePattern[{
            AssayType -> assayType:SizingPolydispersity,
            UncleFullDataTable -> uncleFullDataTable_,
            ProtocolData -> protocolData_,
            CorrelationCurveData -> correlationCurveData_
        }]
    }]
]:= Module[
    {
        dataIndex, zAverageDiameter, zAverageDiffusion, polydispersityIndex, peakOneDiameter
    },
	

    (* find index of data object in the protocol *)
    dataIndex = Position[protocolData, inputData];
    dataIndex = If[MatchQ[dataIndex, {}], 1, First[Flatten[dataIndex]]];

    (* pull out the parameters for SizingPolydispersity *)
    {
        zAverageDiameter,
        zAverageDiffusion,
        polydispersityIndex,
        peakOneDiameter
    } = Map[
        uncleTableRowExtract[uncleFullDataTable, #, dataIndex]&,
        (* rows to pull from *)
        {5, 6, 8, 11}
    ];

    (* Reformat the extracted values by units *)
    zAverageDiameter  = Quantity[zAverageDiameter, Nanometer];
    peakOneDiameter   = Quantity[peakOneDiameter, Nanometer];

    (* Diffusion coefficient has to be reformatted before adding units *)
    zAverageDiffusion = diffusionParse[zAverageDiffusion];
    zAverageDiffusion = Quantity[zAverageDiffusion, Meter^2/Second];

	<|
	        ResolvedInputs-><|
	            CorrelationCurveData -> correlationCurveData,
	            ZAverageDiameter -> zAverageDiameter,
	            ZAverageDiffusion -> zAverageDiffusion,
	            PolydispersityIndex -> polydispersityIndex,
	            PeakOneDiameter -> peakOneDiameter
	        |>
	|>
];


(* Uncle: Resolve inputs B22kd and G22, or ColloidalStability*)
analyzeResolveInputDynamicLightScattering[
	KeyValuePattern[{
        UnresolvedInputs->KeyValuePattern[{
            InputData -> inputData:ObjectP[Object[Data, DynamicLightScattering]]
        }],
        Intermediate->KeyValuePattern[{
            ThisInstrument -> thisInstrument:ObjectP[Object[Instrument, MultimodeSpectrophotometer]]
        }],
        ResolvedInputs->KeyValuePattern[{
            AssayType -> assayType:Alternatives[ColloidalStability, B22kD, G22], (*backward compatibility with previous assay types*)
            UncleFullDataTable -> uncleFullDataTable_,
            ProtocolData -> protocolData_,
            CorrelationCurvesData -> correlationCurvesData_,
            TolueneLightIntensityValue -> tolueneLightIntensityValue_,
            MolecularWeight -> molecularWeight_
		}]
	}]
]:= Module[
    {
        concentrationsListZero, concentrationsList, correlationCurvesList,
        uncleDataTableConcentrations, zeroPositions, dataIndex, dataToPull, zAverageDiameterList, zAverageDiffusionList,
        polydispersityIndexList, peakOneDiameterList, peakOneDiffusionList, peakTwoDiameterList, peakThreeDiameterList, dataToPullIntensity,
        derivedIntensityList, derivedLightIntensityData, derivedBufferLightIntensityData, totalSamples,
        sampleCount, dataToPullwithZero, zerosToPull, concentrationGathering, derivedBufferLightIntensity, correlationCurvesDataNonZero
    },

    (* Pull out the concentrations including 0 mg/ml to use later to pull out the buffer in light intensity *)
    concentrationsListZero = correlationCurvesData[[;;,1]];

	(*Delete correlation curve data with 0 concentration*)
    correlationCurvesDataNonZero = DeleteCases[correlationCurvesData, _?(#[[1]] <= 0 Milligram/Milliliter&)];

    (* pull out concentrations and correlation curves *)
    concentrationsList = correlationCurvesDataNonZero[[;;,1]];
    correlationCurvesList = correlationCurvesDataNonZero[[;;,2]];

    (*
        Extract values from the full data table.
        Use Rest because the initial value is the row title.
        Pulled in values are strings so use ToExpression
    *)
    (* split up by sample concentrations *)
    uncleDataTableConcentrations = ToExpression[Rest[uncleFullDataTable[[1]][[;; , 3]]]];

    (* find index of 0 concentrations, that is the end of the sample *)
    zeroPositions = Position[ToExpression[Rest[uncleFullDataTable[[1]][[;; , 3]]]], 0];
    zeroPositions = Flatten[zeroPositions];

    (* remove the messy format from uncle *)
    uncleDataTableConcentrations = concentrationParse/@uncleDataTableConcentrations;

    (* add back in units of mg/ml *)
    uncleDataTableConcentrations = Quantity[uncleDataTableConcentrations, Milligram/Milliliter];

    (* find index of data object in the protocol *)
    dataIndex = Position[protocolData, inputData];
    dataIndex = If[MatchQ[dataIndex, {}], 1, First[Flatten[dataIndex]]];

    (* find range of the data to pull based on sample index *)
    (* it is assumed that the samples are always loaded 16 at a time *)
    totalSamples = Length[uncleFullDataTable[[1,;;]]]-1;
    sampleCount = totalSamples/Length[protocolData];
    dataToPullwithZero = Range[(dataIndex-1)*sampleCount+1,(dataIndex)*sampleCount];

    (* Find the zero value that is in the data to pull *)
    zerosToPull = Select[zeroPositions, MemberQ[dataToPullwithZero, #] &];

    (* Remove the zero to pull from the zeros to pull *)
    dataToPull = DeleteCases[dataToPullwithZero, Alternatives @@ zerosToPull];

    (*
        Extract values from the table by row.
        Because of the way samples are run, the raw data contains results from all data in protocol.
        As a result we need to parse the values we are interested in based on the data index above.
    *)
    {
        zAverageDiameterList,
        zAverageDiffusionList,
        polydispersityIndexList,
        peakOneDiameterList,
        peakOneDiffusionList,
        peakTwoDiameterList,
        peakThreeDiameterList
    } = Map[
        uncleTableRowExtract[uncleFullDataTable, #, dataToPull]&,
        (* rows to pull*)
        {5, 6, 8, 11, 15, 16, 20}
    ];


    (* for the derived intensity we want to pull out the value at concentration 0, because it is the buffer, so we will add the length of zero concentration data to the samples range *)
    dataToPullIntensity = Join[dataToPull, dataToPull[[-1]]+Range[1,Length[concentrationsListZero]-Length[correlationCurvesData]]];

    derivedIntensityList = uncleTableRowExtract[uncleFullDataTable, -3, dataToPullwithZero];

    (* create a data set of the concentrations from the uncle table and the derived intensity list *)
    derivedLightIntensityData = Transpose[{uncleDataTableConcentrations[[dataToPullwithZero]], derivedIntensityList}];

    (* Pull out buffer intensity (where concentration is 0) from scattered light intensity data and keep the data with non zero concentrations*)
    concentrationGathering = GroupBy[derivedLightIntensityData, #[[1]]>0 Milligram/Milliliter&];
    {derivedLightIntensityData, derivedBufferLightIntensityData} = {Lookup[concentrationGathering, True], Lookup[concentrationGathering, False]};

    (* The assumption is 1 buffer intensity, but if there are more average together the buffer intensities *)
    derivedBufferLightIntensity = Mean[derivedBufferLightIntensityData[[;;,2]]];

    (* Seprate the scattered light intensity into concentrations and intensities *)
    derivedIntensityList = derivedLightIntensityData[[;;,2]];

    (* Reformat the extracted values by units *)
    zAverageDiameterList  = Quantity[zAverageDiameterList, Nanometer];
    peakOneDiameterList   = Quantity[peakOneDiameterList, Nanometer];
    peakTwoDiameterList   = Quantity[peakTwoDiameterList, Nanometer];
    peakThreeDiameterList = Quantity[peakThreeDiameterList, Nanometer];

    (* Diffusion coefficient has to be reformatted before adding units *)
    zAverageDiffusionList = diffusionParse/@zAverageDiffusionList;
    zAverageDiffusionList = Quantity[zAverageDiffusionList, Meter^2/Second];

    peakOneDiffusionList = diffusionParse/@peakOneDiffusionList;
    peakOneDiffusionList = Quantity[peakOneDiffusionList, Meter^2/Second];

	<|
		ResolvedInputs-><|
	            (* Lists *)
	            ConcentrationsList -> concentrationsList,
	            CorrelationCurvesList -> correlationCurvesList,
	            ZAverageDiameterList -> zAverageDiameterList,
	            ZAverageDiffusionList -> zAverageDiffusionList,
	            PolydispersityIndexList -> polydispersityIndexList,
	            PeakOneDiameterList -> peakOneDiameterList,
	            PeakOneDiffusionList -> peakOneDiffusionList,
	            DerivedIntensityList -> derivedIntensityList,
	            PeakTwoDiameterList -> peakTwoDiameterList,
	            PeakThreeDiameterList -> peakThreeDiameterList,
	
	            (*Constants *)
	            DerivedBufferLightIntensity -> derivedBufferLightIntensity,
	            TolueneLightIntensityValue -> tolueneLightIntensityValue,
	            MolecularWeight -> molecularWeight
		|>,
		Tests -> <|
			ResolvedInputTests -> {}
		|>
	|>
];


(* DynaPro: Resolve inputs IsothermalStability *)
analyzeResolveInputDynamicLightScattering[
    KeyValuePattern[{
        UnresolvedInputs->KeyValuePattern[{
            InputData->inputData:ObjectP[Object[Data, DynamicLightScattering]]
        }],
        Intermediate->KeyValuePattern[{
            ThisInstrument -> thisInstrument:ObjectP[Object[Instrument, DLSPlateReader]]
        }],
        ResolvedInputs->KeyValuePattern[{
            AssayType -> assayType:IsothermalStability,
            ZAverageDiameters -> zAverageDiameters_,
            CorrelationCurvesData -> correlationCurvesData_
        }]
    }]
]:= Module[{resultZAverageDiameters, resultIsoThermalStabilityTimes},

    (* The input of ZAverageDiameters is a 2D list. The first column is time, the second column is the diameter. *)
    resultZAverageDiameters = zAverageDiameters[[;;, 2]];
    resultIsoThermalStabilityTimes = zAverageDiameters[[;;, 1]];

    <|
        ResolvedInputs-><|
            ZAverageDiameters -> resultZAverageDiameters,
            IsothermalStabilityTimes -> resultIsoThermalStabilityTimes
        |>
    |>
];


(* DynaPro: Resolve inputs SizingPolydispersity *)
analyzeResolveInputDynamicLightScattering[
    KeyValuePattern[{
        UnresolvedInputs->KeyValuePattern[{
            InputData->inputData:ObjectP[Object[Data, DynamicLightScattering]]
        }],
        Intermediate->KeyValuePattern[{
            ThisInstrument -> thisInstrument:ObjectP[Object[Instrument,DLSPlateReader]]
        }],
        ResolvedInputs->KeyValuePattern[{
            AssayType -> assayType:SizingPolydispersity,
            ZAverageDiameter -> zAverageDiameter_
        }]
    }]
]:= Module[{resultZAverageDiameter},

    (* ZAverageDiameter is a number or empty. This is the value from instrument output. Currently it is calculated
    in later steps from Cumulants method. We keep it here for other possible methods in the future. *)
    resultZAverageDiameter = zAverageDiameter;

    <|
        ResolvedInputs -> <|
            ZAverageDiameter -> resultZAverageDiameter
        |>
    |>
];


(* DynaPro: Resolve inputs B22kd and G22, or ColloidalStability*)
analyzeResolveInputDynamicLightScattering[
    KeyValuePattern[{
        UnresolvedInputs->KeyValuePattern[{
            InputData -> inputData:ObjectP[Object[Data, DynamicLightScattering]]
        }],
        Intermediate->KeyValuePattern[{
            ThisInstrument -> thisInstrument:ObjectP[Object[Instrument,DLSPlateReader]]
        }],
        ResolvedInputs->KeyValuePattern[{
            AssayType -> assayType:Alternatives[ColloidalStability, B22kD, G22],
            CorrelationCurvesData -> correlationCurvesData_
        }]
    }]
]:= Module[{concentrationsListZero, concentrationsList, correlationCurvesList, correlationCurvesDataNonZero},

    (* Pull out the concentrations including 0 mg/ml to use later to pull out the buffer in light intensity *)
    concentrationsListZero = correlationCurvesData[[;;,1]];

    (*Delete correlation curve data with 0 concentration*)
    correlationCurvesDataNonZero = DeleteCases[correlationCurvesData, _?(#[[1]] <= 0 Milligram/Milliliter&)];

    (* pull out concentrations and correlation curves *)
    concentrationsList = correlationCurvesDataNonZero[[;;,1]];
    correlationCurvesList = correlationCurvesDataNonZero[[;;,2]];

	<|
		ResolvedInputs-><|
	            (* Lists *)
	            ConcentrationsList -> concentrationsList,
	            CorrelationCurvesList -> correlationCurvesList
		|>,
		Tests -> <|
			ResolvedInputTests -> {}
		|>
	|>
];

(* Resolve options for all assay types and melting curve *)
analyzeResolveOptionsDynamicLightScattering[
	KeyValuePattern[{
      UnresolvedInputs->KeyValuePattern[{
          InputData -> inputData_
      }],
      Intermediate->KeyValuePattern[{
          ThisInstrument -> thisInstrument_
      }],
      ResolvedInputs->KeyValuePattern[{
          TolueneLightIntensityValue -> tolueneLightIntensityValue_
      }],
      ResolvedOptions -> KeyValuePattern[{
          PolynomialDegree -> polynomialDegree_,
          CorrelationMinimumValue -> correlationMinimumValue_,
          CorrelationMinimumMethod -> correlationMinimumMethod_,
          InitialCorrelationMinimumThreshold -> initialCorrelationMinimumThreshold_,
          InitialCorrelationMaximumThreshold -> initialCorrelationMaximumThreshold_,
          Method -> method_,
          CalibrationStandardIntensity -> calibrationStandardIntensity_
    	}]
	}]
]:= Module[
    {
        resolvedPolynomialDegree, resolvedCorrelationMinimumMethod, resolvedCorrelationMinimumValue,
        resolvedCalibrationStandardIntensity, thisMethod
    },

    (* check min threshold option does not exceed max threshold option *)
    If[initialCorrelationMinimumThreshold > initialCorrelationMaximumThreshold,
        Message[
            Error::MinExceedsMax,
            initialCorrelationMinimumThreshold,
            initialCorrelationMaximumThreshold
        ];
        Return[$Failed]
    ];

    (* resolve Method value based on the instruments *)
    thisMethod = If[MatchQ[thisInstrument, ObjectP[Object[Instrument, MultimodeSpectrophotometer]]],

        (*If the instrument is MultimodeSpectrophotometer, the default method is Instrument*)
        If[MatchQ[method, Automatic], Instrument, method],

        (*Othwewise, if the instrument is DLSPlateReader, the default method is Cumulants. There is no other method *)
        If[MatchQ[thisInstrument, ObjectP[Object[Instrument, DLSPlateReader]]],
            If[MatchQ[method, Automatic]||MatchQ[method, Cumulants],
                Cumulants,
                Message[Error::UseCumulantsMethod];
                Return[$Failed]
            ]
        ]
    ];

    (* Set options irrelevant to Instrument Method to Null *)
    (* It always uses Cumulants method, unless when the instrument is MultimodeSpectrophotometer and the method option is Instrument*)
    {
        resolvedPolynomialDegree,
        resolvedCorrelationMinimumMethod,
        resolvedCorrelationMinimumValue
    } = If[MatchQ[thisMethod, Instrument] && MatchQ[thisInstrument, ObjectP[Object[Instrument, MultimodeSpectrophotometer]]],

        (* Instrument *)
        ConstantArray[Null, 3],

        (* Cumulants method *)
        {
            polynomialDegree,
            correlationMinimumMethod,
            correlationMinimumValue
        }
    ];

    (* ISO warnings helper, nothing is returned because it only exists to issue warnings *)
    warningISO[
        thisMethod,
        correlationMinimumValue,
        initialCorrelationMinimumThreshold,
        initialCorrelationMaximumThreshold
    ];

    (* resolve calibration standard intensity to input value or to downloaded calibration standard intensity from the data *)
    resolvedCalibrationStandardIntensity = If[MatchQ[calibrationStandardIntensity, Automatic],
        tolueneLightIntensityValue,
        calibrationStandardIntensity
    ];

	<|
		ResolvedOptions-><|
        Method -> thisMethod,
        PolynomialDegree -> resolvedPolynomialDegree,
        CorrelationMinimumValue -> resolvedCorrelationMinimumValue,
        CorrelationMinimumMethod -> resolvedCorrelationMinimumMethod,
        CalibrationStandardIntensity -> resolvedCalibrationStandardIntensity
    |>
	|>
];

(* Overload to skip resolving extra options - return an empty association *)
analyzeResolveAssayOptionsDynamicLightScattering[__]:= <||>;

(* Resolve extra options by assay type options *)
analyzeResolveAssayOptionsDynamicLightScattering[
	KeyValuePattern[{
	      UnresolvedInputs->KeyValuePattern[{
	          InputData -> inputData:ObjectP[Object[Data, DynamicLightScattering]]
      }],
      ResolvedInputs -> KeyValuePattern[{
          WavelengthNanometer -> wavelengthNanometer_,
          SolventRefractionIndex -> solventRefractionIndex_,
          TolueneLightIntensityValue -> tolueneLightIntensityValue_,
          (*backward compatibility with previous assay types*)
          AssayType -> assayType:Alternatives[ColloidalStability, B22kD, G22]
    	}],
      ResolvedOptions -> KeyValuePattern[{
          OpticalConstant -> opticalConstant_,
          RefractiveIndexConcentrationDerivative -> refractiveIndexConcentrationDerivative_,
          CalibrationStandardIntensity -> calibrationStandardIntensity_
    	}]
	}]
]:= Module[
    {
        resolvedRefractiveIndexConcentrationDerivative, resolvedOpticalConstant, resolvedCalibrationStandardIntensity, dndc
    },

    (* Optical constant for the protein *)
    {resolvedRefractiveIndexConcentrationDerivative, resolvedOpticalConstant} = If[MatchQ[opticalConstant, Automatic],

        dndc = If[MatchQ[refractiveIndexConcentrationDerivative, Automatic],

            (* if both are automatic *)
            0.185 Centimeter^3/Gram,

            (* if refractive index is specified **)
            refractiveIndexConcentrationDerivative
        ];

        {dndc, opticalConstantCalculation[solventRefractionIndex, dndc, wavelengthNanometer]},


        If[MatchQ[refractiveIndexConcentrationDerivative, Automatic],

            (* if refractive index is automatic *)
            {Automatic, opticalConstant},

            (* both are specified *)
            Message[Error::OverSpecifiedOpticalConstant];
            {$Failed, $Failed}
        ]

    ];

    (* resolve calibration standard intensity to input value or to downloaded calibration standard intensity from the data *)
    resolvedCalibrationStandardIntensity = If[MatchQ[calibrationStandardIntensity, Automatic],
        tolueneLightIntensityValue,
        calibrationStandardIntensity
    ];

	<|
		ResolvedOptions-><|
           	RefractiveIndexConcentrationDerivative -> resolvedRefractiveIndexConcentrationDerivative,
           	OpticalConstant -> resolvedOpticalConstant,
            CalibrationStandardIntensity -> resolvedCalibrationStandardIntensity
       	|>
	|>
];

(*Overload: Calculation for both instruments and assayType is IsothermalStability*)
analyzeCalculateDynamicLightScattering[
	KeyValuePattern[{
      UnresolvedInputs->KeyValuePattern[{
            InputData -> inputData:ObjectP[Object[Data, DynamicLightScattering]]
      }],
      Intermediate->KeyValuePattern[{
            ThisInstrument -> thisInstrument:Alternatives[ObjectP[Object[Instrument, MultimodeSpectrophotometer]], ObjectP[Object[Instrument, DLSPlateReader]]]
      }],
      ResolvedInputs -> KeyValuePattern[{
            AssayType->assayType:IsothermalStability,
            CorrelationCurvesData -> correlationCurvesData_,
            ZAverageDiameter -> zAverageDiameter_,
            ZAverageDiffusion -> zAverageDiffusion_,
            PolydispersityIndex -> polydispersityIndex_,
            TemperatureValue -> temperatureValue_,
            DynamicViscosity -> dynamicViscosity_,
            DiffusionToGamma -> diffusionToGamma_,
            IsothermalStabilityTimes -> isothermalStabilityTimes_
    	}],
      ResolvedOptions -> KeyValuePattern[{
            PolynomialDegree -> polynomialDegree_,
            CorrelationMinimumValue -> correlationMinimumValue_,
            CorrelationMinimumMethod -> correlationMinimumMethod_,
            Method -> method_,
            ConvergenceTimeThreshold -> convergenceTimeThreshold_,
            ConvergenceCorrelationThreshold -> convergenceCorrelationThreshold_,
            InitialTimeThreshold -> initialTimeThreshold_,
            InitialCorrelationMinimumThreshold -> initialCorrelationMinimumThreshold_,
            InitialCorrelationMaximumThreshold -> initialCorrelationMaximumThreshold_
    	}]
	}]
]:= Module[
    {
        curveScores, abnormalCurves, resultZAverageDiameter, resultZAverageDiffusionCoefficient,
        resultPolydispersityIndex, dataTable, badConditions, badIndexPositions, resultIsothermalStabilityTimes,
        resultCorrelationCurvesData, resultZAverageDiffusion
    },

    (* data table of all the z average diameter, diffusion, pdi, time, and correlation curves. It is different under instruments. *)
    dataTable = If[MatchQ[thisInstrument, ObjectP[Object[Instrument, MultimodeSpectrophotometer]]],
        (*for Uncle*)
        Transpose[{
            isothermalStabilityTimes,
            correlationCurvesData,
            zAverageDiameter,
            zAverageDiffusion,
            polydispersityIndex
        }],
        (*for DynaPro*)
        Transpose[{
            isothermalStabilityTimes,
            correlationCurvesData
        }]
    ];

    (* check that the correlation curves are properly loaded *)
    (*
        filter data again based on initial value
        find the average initial value of the curves
        this helper function is from DynamicLightScatteringLoading
    *)
    curveScores = scoreFromOneCurve[#, initialTimeThreshold]&/@correlationCurvesData;

    (* select the bad curves *)
    abnormalCurves = Select[ToList[curveScores], !(#>initialCorrelationMinimumThreshold && #<initialCorrelationMaximumThreshold)&];

    (* find positions of bad data and the time of those bad conditions *)
    badIndexPositions = Position[curveScores, Alternatives@@abnormalCurves];
    badConditions = dataTable[[;;,1]][[Flatten[badIndexPositions]]];

    (* issue a warning that one of the correlation curves is low or high *)
    dataTable = If[Length[abnormalCurves]>0,
        Message[
            Warning::CurvesOutsideRangeRemoved,
            inputData,
            badConditions,
            initialCorrelationMinimumThreshold,
            initialCorrelationMaximumThreshold
        ];
        Delete[dataTable, badIndexPositions],

        (* otherwise stay the same *)
        dataTable
    ];

    (* pull out the filtered data *)
    If[MatchQ[thisInstrument, ObjectP[Object[Instrument, MultimodeSpectrophotometer]]],
        (*for Uncle*)
        {
            resultIsothermalStabilityTimes,
            resultCorrelationCurvesData,
            resultZAverageDiameter,
            resultZAverageDiffusionCoefficient,
            resultPolydispersityIndex
        } = Transpose[dataTable],
        (*for DynaPro*)
        {
            resultIsothermalStabilityTimes,
            resultCorrelationCurvesData
        } = Transpose[dataTable]
    ];

    (* If method is instrument, return the current values, otherwise use the cumulants method *)
    (* Pull out initial values - includes diameter, PDI, and diffusion *)
    {
        resultZAverageDiameter,
        resultZAverageDiffusionCoefficient,
        resultPolydispersityIndex
    } = If[MatchQ[method, Cumulants],
        (* Map the cumulants calculation over each correlation curve *)
        Transpose[
            MapThread[
                oneCurveCumulants[
                    #1,
                    diffusionToGamma,
                    polynomialDegree,
                    correlationMinimumValue,
                    correlationMinimumMethod,
                    temperatureValue,
                    dynamicViscosity,
   		    inputData,
		    #2
                ]&,
  		{resultCorrelationCurvesData, dataTable[[;;,1]]}
            ]
        ],

        (* Instrument values from protocol *)
        {
            resultZAverageDiameter,
            resultZAverageDiffusionCoefficient,
            resultPolydispersityIndex
        }
    ];

	<|
		Tests -> <|
			ResolvedInputTests -> {}
		|>,
	        Packet -> <|
	            (* Index matched data *)
	            Replace[DiffusionCoefficients] -> resultZAverageDiffusionCoefficient,
	            Replace[ZAverageDiameters] -> resultZAverageDiameter,
	            Replace[PolyDispersityIndices] -> resultPolydispersityIndex,
	            Replace[CorrelationCurves] -> resultCorrelationCurvesData,
	            Replace[AssayConditions] -> resultIsothermalStabilityTimes
	        |>
	|>
];

(* Overload: Calculation for both instruments and assayType is SizingPolydispersity *)
analyzeCalculateDynamicLightScattering[
	KeyValuePattern[{
        UnresolvedInputs->KeyValuePattern[{
            InputData -> inputData:ObjectP[Object[Data, DynamicLightScattering]]
        }],
        Intermediate->KeyValuePattern[{
            ThisInstrument -> thisInstrument:Alternatives[ObjectP[Object[Instrument, MultimodeSpectrophotometer]], ObjectP[Object[Instrument, DLSPlateReader]]]
        }],
        ResolvedInputs -> KeyValuePattern[{
            AssayType -> assayType:SizingPolydispersity,
            CorrelationCurveData -> correlationCurveData_,
            ZAverageDiameter -> zAverageDiameter_,
            ZAverageDiffusion -> zAverageDiffusion_,
            PolydispersityIndex -> polydispersityIndex_,
            TemperatureValue -> temperatureValue_,
            DynamicViscosity -> dynamicViscosity_,
            DiffusionToGamma -> diffusionToGamma_
    	}],
        ResolvedOptions -> KeyValuePattern[{
            PolynomialDegree -> polynomialDegree_,
            CorrelationMinimumValue -> correlationMinimumValue_,
            CorrelationMinimumMethod -> correlationMinimumMethod_,
            Method -> method_,
            ConvergenceTimeThreshold -> convergenceTimeThreshold_,
            ConvergenceCorrelationThreshold -> convergenceCorrelationThreshold_,
            InitialTimeThreshold -> initialTimeThreshold_,
            InitialCorrelationMinimumThreshold -> initialCorrelationMinimumThreshold_,
            InitialCorrelationMaximumThreshold -> initialCorrelationMaximumThreshold_
    	}]
	}]
]:= Module[
    {
        curveScores, abnormalCurves, resultZAverageDiameter,correlationParameters,
        resultZAverageDiffusionCoefficient, resultPolydispersityIndex
    },

    (* check that the correlation curves are properly loaded *)
    (*
        filter data again based on initial value
        find the average initial value of the curves
        this helper function is from DynamicLightScatteringLoading
    *)

    curveScores = scoreFromOneCurve[correlationCurveData, initialTimeThreshold];

    (* keep the curves between the cutoff *)
    abnormalCurves = Select[ToList[curveScores], !(#>initialCorrelationMinimumThreshold && #<initialCorrelationMaximumThreshold)&];

    (* issue a warning that one of the correlation curves is low or high *)
    If[Length[abnormalCurves]>0,
        Message[Warning::CurvesOutsideRange, inputData, initialCorrelationMinimumThreshold, initialCorrelationMaximumThreshold]
    ];

    (* If method is instrument, return the current values, otherwise use the cumulants method *)
    (* Pull out initial values - includes diameter, PDI, and diffusion *)
    correlationParameters = If[MatchQ[method, Cumulants],
        oneCurveCumulants[
            correlationCurveData,
            diffusionToGamma,
            polynomialDegree,
            correlationMinimumValue,
            correlationMinimumMethod,
            temperatureValue,
            dynamicViscosity,
	    inputData,
	    SizingPolydispersity
        ],

        (* Instrument values from protocol *)
        {
            zAverageDiameter,
            zAverageDiffusion,
            polydispersityIndex
        }
    ];

    (* transpose together final an initial parameters to group parameter calculations *)
    {
        resultZAverageDiameter,
        resultZAverageDiffusionCoefficient,
        resultPolydispersityIndex
    } = Transpose[{correlationParameters}];

	<|
		Tests -> <|
			ResolvedInputTests -> {}
		|>,
	        Packet -> <|
	            (* Index matched data *)
	            Replace[DiffusionCoefficients] -> resultZAverageDiffusionCoefficient,
	            Replace[ZAverageDiameters] -> resultZAverageDiameter,
	            Replace[PolyDispersityIndices] -> resultPolydispersityIndex,
	            Replace[CorrelationCurves] -> correlationCurveData
	
	        |>
	|>
];

(*Overload: Calculation for Uncle and assayType is ColloidalStability (B22kD/G22)*)
analyzeCalculateDynamicLightScattering[
	KeyValuePattern[{
        UnresolvedInputs->KeyValuePattern[{
            InputData -> inputData:ObjectP[Object[Data, DynamicLightScattering]]
        }],
        Intermediate->KeyValuePattern[{
            ThisInstrument -> thisInstrument:ObjectP[Object[Instrument, MultimodeSpectrophotometer]]
        }],
        ResolvedInputs -> KeyValuePattern[{
            (*backward compatible with previous assay types*)
            AssayType -> assayType:Alternatives[ColloidalStability, B22kD, G22],

            (* Lists *)
            ConcentrationsList -> concentrationsList_,
            CorrelationCurvesList -> correlationCurvesList_,
            ZAverageDiameterList -> zAverageDiameterList_,
            ZAverageDiffusionList -> zAverageDiffusionList_,
            PolydispersityIndexList -> polydispersityIndexList_,
            PeakOneDiameterList -> peakOneDiameterList_,
            PeakOneDiffusionList -> peakOneDiffusionList_,
            DerivedIntensityList -> derivedIntensityList_,
            PeakTwoDiameterList -> peakTwoDiameterList_,
            PeakThreeDiameterList -> peakThreeDiameterList_,

            (* Constants *)
            WavelengthNanometer -> wavelengthNanometer_,
            TemperatureValue -> temperatureValue_,
            DerivedBufferLightIntensity -> derivedBufferLightIntensity_,
            TolueneLightIntensityValue -> tolueneLightIntensityValue_,
            DynamicViscosity -> dynamicViscosity_,
            SolventRefractionIndex -> solventRefractionIndex_,
            DiffusionToGamma -> diffusionToGamma_,
            MolecularWeight -> molecularWeight_
        }],
        ResolvedOptions -> KeyValuePattern[{
            Method -> method_,
            ConvergenceTimeThreshold -> convergenceTimeThreshold_,
            ConvergenceCorrelationThreshold -> convergenceCorrelationThreshold_,
            InitialTimeThreshold -> initialTimeThreshold_,
            InitialCorrelationMinimumThreshold -> initialCorrelationMinimumThreshold_,
            InitialCorrelationMaximumThreshold -> initialCorrelationMaximumThreshold_,
            PolynomialDegree -> polynomialDegree_,
            CorrelationMinimumValue -> correlationMinimumValue_,
            CorrelationMinimumMethod -> correlationMinimumMethod_,
            OpticalConstant -> opticalConstant_,
            CalibrationStandardIntensity -> calibrationStandardIntensity_
        }]
	}]
]:= Module[
    {
        dataTable, resultsTable, individualPeaksList, resultsIndividualPeaksList, averageDiffusionInteractionStatistics,
        averageDiffusionInteractionFitPacket, firstPeakDiffusionInteractionStatistics, firstPeakDiffusionInteractionFitPacket,
        secondViralCoefficentStatistics, secondViralCoefficentFitPacket, solventRayleighRatioList, kirkwoodBuffIntegralStatistics,
        kirkwoodBuffIntegralFitPacket, averageDiffusionInteractionFitObject,
        secondViralCoefficentFitObject, kirkwoodBuffIntegralFitObject, multiModalFields, resultConcentrationList,
        resultCorrelationCurveList, resultDerivedIntensityList, resultAverageParticleSizeList, resultDiffusionList,
        resultPolyDisperistyIndexList, resultFirstPeakparticleSizeList, resultFirstPeakDiffusionList, secondViralCoefficentAssociation,
        averageDiffusionInteractionAssociation, kirkwoodBuffIntegralAssociation, firstPeakDiffusionInteractionFitObject,trueMolecularWeight
    },

    individualPeaksList = Transpose[{peakOneDiameterList, peakTwoDiameterList, peakThreeDiameterList}];

    (* Create a master table of all the data *)
    dataTable = Transpose[
        {
            concentrationsList,
            correlationCurvesList,
            derivedIntensityList,
            zAverageDiameterList,
            zAverageDiffusionList,
            polydispersityIndexList,
            peakOneDiameterList,
            peakOneDiffusionList,
            individualPeaksList
        }
    ];

    (* The first step for all methods is to filter the data *)
    dataTable = removeBadCorrelations[
        dataTable,
        convergenceTimeThreshold,
        convergenceCorrelationThreshold,
        initialTimeThreshold,
        initialCorrelationMinimumThreshold,
        initialCorrelationMaximumThreshold,
        method,
        inputData
    ];

    (*
        The method determines how we acquire Z average diameter, diffusion, peakOne, and polydispersity.
        The method also determines how we do data filtration of the correlation curves.
            If we use the instrument data we proceed with the data table as is.
            If we do in-house particle size estimates, we calculate starting from correlation curves
    *)
    resultsTable = Switch[method,

        Instrument,
            (* if we are using the instrument table, just return all the info *)
            dataTable,

        Cumulants,
            (* call the cumulants function to estimate particle sizes based on the method specified in the ISO documention *)
            cumulantsMethod[
                thisInstrument,
                dataTable,
                diffusionToGamma,
                polynomialDegree,
                correlationMinimumValue,
                correlationMinimumMethod,
                temperatureValue,
                dynamicViscosity,
		inputData,
		dataTable[[;;,1]]
            ]
    ];

	(* filter out rows with $Failed values *)
	resultsTable = Select[resultsTable, Not[MemberQ[#, $Failed|Quantity[$Failed, _]]]&];

    (* Split the results table by column *)
    {
        resultConcentrationList,
        resultCorrelationCurveList,
        resultDerivedIntensityList,
        resultAverageParticleSizeList,
        resultDiffusionList,
        resultPolyDisperistyIndexList,
        resultFirstPeakparticleSizeList,
        resultFirstPeakDiffusionList,
        resultsIndividualPeaksList
    } = Transpose[resultsTable];

    (* delete $Failed values from multiple peaks *)
    resultsIndividualPeaksList = Cases[#, Except[Quantity[$Failed, _]], 1] & /@ resultsIndividualPeaksList;

    (*calculate the diffusion interaction parameter, with concentration and diffusion (average and first peak) *)
    {averageDiffusionInteractionStatistics, averageDiffusionInteractionFitPacket}  = diffusionInteractionCalculation[
        resultConcentrationList,
        resultDiffusionList,
        temperatureValue,
        dynamicViscosity
    ];

    (* create an association out of named multiple and statistics *)
    averageDiffusionInteractionAssociation = AssociationThread[
        {DiffusionInteractionParameter, Slope, Intercept, RSquared, HydrodynamicDiameter},
        averageDiffusionInteractionStatistics
    ];

    {firstPeakDiffusionInteractionStatistics, firstPeakDiffusionInteractionFitPacket}  = diffusionInteractionCalculation[
        resultConcentrationList,
        resultFirstPeakDiffusionList,
        temperatureValue,
        dynamicViscosity
    ];

    (* calculate the second virial coefficient *)
    {secondViralCoefficentStatistics, secondViralCoefficentFitPacket, solventRayleighRatioList} = secondVirialCoefficientCalculation[
        thisInstrument,
        resultConcentrationList,
        resultDerivedIntensityList,
        derivedBufferLightIntensity,
        calibrationStandardIntensity,
        solventRefractionIndex,
        opticalConstant
    ];

    (* create an association out of named multiple and statistics *)
    secondViralCoefficentAssociation = AssociationThread[
        {SecondVirialCoefficient, Slope, Intercept, RSquared, TrueMolecularWeight},
        secondViralCoefficentStatistics
    ];

    (* store fitted true Molecular weight in packet *)
    trueMolecularWeight = Lookup[secondViralCoefficentAssociation, TrueMolecularWeight];

    (* Calculate the Kirkwood Buff Integral *)
    {kirkwoodBuffIntegralStatistics, kirkwoodBuffIntegralFitPacket} = kirkwoodBuffIntegralCalculation[
        resultConcentrationList,
        solventRayleighRatioList,
        opticalConstant,
        molecularWeight
    ];

    (* create an association out of named multiple and statistics *)
    kirkwoodBuffIntegralAssociation = AssociationThread[
        {
            KirkwoodBuffIntegral,
            Slope,
            Intercept,
            RSquared,
            TrueMolecularWeight
        },
        kirkwoodBuffIntegralStatistics
    ];

    (* Batch upload the fit packets *)
    {
        averageDiffusionInteractionFitObject,
        firstPeakDiffusionInteractionFitObject,
        secondViralCoefficentFitObject,
        kirkwoodBuffIntegralFitObject
    } = Upload[
        {
            averageDiffusionInteractionFitPacket,
            firstPeakDiffusionInteractionFitPacket,
            secondViralCoefficentFitPacket,
            kirkwoodBuffIntegralFitPacket
        }
    ];

    (*
        Extra fields are added to the packet if it is multimodal,
        if it is Cumulants then nothing
    *)
    multiModalFields = If[MatchQ[method, Cumulants],
        (* Nothing  is added in this case *)
        Nothing,

        (* Create a list of the extra fields to add *)
        {
            Replace[PeakSpecificDiameters] -> resultFirstPeakparticleSizeList,
            Replace[DominantPeakDiffusionInteractionParameterStatistics] -> firstPeakDiffusionInteractionStatistics,
            Replace[PeakSpecificDiameters]-> resultsIndividualPeaksList,
            DominantPeakDiffusionInteractionParameterFit -> Link[firstPeakDiffusionInteractionFitObject]
        }
    ];

	<|
		Tests -> <|
			ResolvedInputTests -> {}
		|>,
	        Packet -> <|
	
	            (* Index matched data *)
	            Replace[AssayConditions] -> resultConcentrationList,
	            Replace[DiffusionCoefficients] -> resultDiffusionList,
	            Replace[ZAverageDiameters] -> resultAverageParticleSizeList,
	            Replace[PolyDispersityIndices] -> resultPolyDisperistyIndexList,
	            Replace[CorrelationCurves] -> resultCorrelationCurveList,
	            Replace[SolventRayleighRatios] -> solventRayleighRatioList,
	            Replace[DerivedScatteredLightIntensities] -> resultDerivedIntensityList,
	
	            (* Diffusion fit statistics *)
	            DiffusionInteractionParameterStatistics -> averageDiffusionInteractionAssociation,
	            DiffusionInteractionParameterFit -> Link[averageDiffusionInteractionFitObject],
	
	            (* Virial Coefficient Statistics and parameters *)
	            SecondVirialCoefficientStatistics -> secondViralCoefficentAssociation,
	            SecondVirialCoefficientFit -> Link[secondViralCoefficentFitObject],
	            CalibrationStandardIntensity -> calibrationStandardIntensity,
	            BufferDerivedLightIntensity -> derivedBufferLightIntensity,
	            OpticalConstantValue -> opticalConstant,
	
	            (* Estimated Molecular Weight*)
	            EstimatedMolecularWeight -> trueMolecularWeight,
	
	            (* Kirkwood Buff integral statistics *)
	            KirkwoodBuffIntegralStatistics -> kirkwoodBuffIntegralAssociation,
	            KirkwoodBuffIntegralFit -> Link[kirkwoodBuffIntegralFitObject],
	
	            (* Data for multimodal analysis *)
	            Sequence@@multiModalFields
	
	        |>
	|>
];

(*Overload: Calculation for DynaPro and assayType is ColloidalStability*)
analyzeCalculateDynamicLightScattering[
    KeyValuePattern[{
        UnresolvedInputs->KeyValuePattern[{
            InputData -> inputData:ObjectP[Object[Data, DynamicLightScattering]]
        }],
        Intermediate->KeyValuePattern[{
            ThisInstrument -> thisInstrument:ObjectP[Object[Instrument, DLSPlateReader]]
        }],
        ResolvedInputs -> KeyValuePattern[{
            AssayType->assayType:Alternatives[ColloidalStability, B22kD, G22],

            (* Lists *)
            ConcentrationsList -> concentrationsList_,
            CorrelationCurvesList -> correlationCurvesList_,
            ApparentMolecularWeight -> apparentMolecularWeight_,

            (* Constants *)
            WavelengthNanometer -> wavelengthNanometer_,
            TemperatureValue -> temperatureValue_,
            TolueneLightIntensityValue -> tolueneLightIntensityValue_,
            DynamicViscosity -> dynamicViscosity_,
            SolventRefractionIndex -> solventRefractionIndex_,
            DiffusionToGamma -> diffusionToGamma_,
            MolecularWeight -> molecularWeight_
        }],
        ResolvedOptions -> KeyValuePattern[{
            Method -> method_,
            ConvergenceTimeThreshold -> convergenceTimeThreshold_,
            ConvergenceCorrelationThreshold -> convergenceCorrelationThreshold_,
            InitialTimeThreshold -> initialTimeThreshold_,
            InitialCorrelationMinimumThreshold -> initialCorrelationMinimumThreshold_,
            InitialCorrelationMaximumThreshold -> initialCorrelationMaximumThreshold_,
            PolynomialDegree -> polynomialDegree_,
            CorrelationMinimumValue -> correlationMinimumValue_,
            CorrelationMinimumMethod -> correlationMinimumMethod_,
            OpticalConstant -> opticalConstant_,
            CalibrationStandardIntensity -> calibrationStandardIntensity_
        }]
    }]
]:= Module[
    {
        dataTable, resultsTable, resultsIndividualPeaksList, averageDiffusionInteractionStatistics,
        averageDiffusionInteractionFitPacket, secondViralCoefficentStatistics, secondViralCoefficentFitPacket,
        solventRayleighRatioList, kirkwoodBuffIntegralStatistics, kirkwoodBuffIntegralFitPacket,
        averageDiffusionInteractionFitObject, secondViralCoefficentFitObject, kirkwoodBuffIntegralFitObject,
        resultConcentrationList, resultCorrelationCurveList, resultAverageParticleSizeList, resultDiffusionList,
        resultPolyDisperistyIndexList, secondViralCoefficentAssociation, averageDiffusionInteractionAssociation,
        kirkwoodBuffIntegralAssociation, trueMolecularWeight
    },


    (* Create a master table of all the data *)
    dataTable = Transpose[
        {
            concentrationsList,
            correlationCurvesList
        }
    ];

    (* The first step for all methods is to filter the data *)
    dataTable = removeBadCorrelations[
        dataTable,
        convergenceTimeThreshold,
        convergenceCorrelationThreshold,
        initialTimeThreshold,
        initialCorrelationMinimumThreshold,
        initialCorrelationMaximumThreshold,
        method,
        inputData
    ];

    (*
        The method determines how we acquire Z average diameter, diffusion, peakOne, and polydispersity.
        The method also determines how we do data filtration of the correlation curves.
        By default Cumulants method is used. i.e. We calculate starting from correlation curves.
    *)
    (* call the cumulants function to estimate particle sizes based on the method specified in the ISO documentation *)
    resultsTable = cumulantsMethod[
        thisInstrument,
        dataTable,
        diffusionToGamma,
        polynomialDegree,
        correlationMinimumValue,
        correlationMinimumMethod,
        temperatureValue,
        dynamicViscosity,
	inputData,
	dataTable[[;;,1]]
    ];

    (* Split the results table by column *)
    {
        resultConcentrationList,
        resultCorrelationCurveList,
        resultAverageParticleSizeList,
        resultDiffusionList,
        resultPolyDisperistyIndexList
    } = Transpose[resultsTable];

    (* delete $Failed values from multiple peaks *)
    resultsIndividualPeaksList = Cases[#, Except[Quantity[$Failed, _]], 1] & /@ resultsIndividualPeaksList;

    (*calculate the diffusion interaction parameter, with concentration and diffusion (average and first peak) *)
    {averageDiffusionInteractionStatistics, averageDiffusionInteractionFitPacket}  = diffusionInteractionCalculation[
        resultConcentrationList,
        resultDiffusionList,
        temperatureValue,
        dynamicViscosity
    ];

    (* create an association out of named multiple and statistics *)
    averageDiffusionInteractionAssociation = AssociationThread[
        {DiffusionInteractionParameter, Slope, Intercept, RSquared, HydrodynamicDiameter},
        averageDiffusionInteractionStatistics
    ];

    (* calculate the second virial coefficient and molecular weight*)
    {secondViralCoefficentStatistics, secondViralCoefficentFitPacket, solventRayleighRatioList} = secondVirialCoefficientCalculation[
        thisInstrument,
        resultConcentrationList,
        opticalConstant,
        apparentMolecularWeight
    ];

    (* create an association out of named multiple and statistics *)
    secondViralCoefficentAssociation = AssociationThread[
        {SecondVirialCoefficient, Slope, Intercept, RSquared, TrueMolecularWeight},
        secondViralCoefficentStatistics
    ];

    (* store fitted true molecular weight in packet*)
    trueMolecularWeight = Lookup[secondViralCoefficentAssociation, TrueMolecularWeight];

    (* Calculate the Kirkwood Buff Integral *)
    {kirkwoodBuffIntegralStatistics, kirkwoodBuffIntegralFitPacket} = kirkwoodBuffIntegralCalculation[
        resultConcentrationList,
        solventRayleighRatioList,
        opticalConstant,
        molecularWeight
    ];

    (* create an association out of named multiple and statistics *)
    kirkwoodBuffIntegralAssociation = AssociationThread[
        {KirkwoodBuffIntegral, Slope, Intercept, RSquared, TrueMolecularWeight},
        kirkwoodBuffIntegralStatistics
    ];

    (* Batch upload the fit packets *)
    {
        averageDiffusionInteractionFitObject,
        secondViralCoefficentFitObject,
        kirkwoodBuffIntegralFitObject
    } = Upload[
        {
            averageDiffusionInteractionFitPacket,
            secondViralCoefficentFitPacket,
            kirkwoodBuffIntegralFitPacket
        }
    ];


    <|
        Tests -> <|
            ResolvedInputTests -> {}
        |>,
        Packet -> <|

            (* Index matched data *)
            Replace[AssayConditions] -> resultConcentrationList,
            Replace[DiffusionCoefficients] -> resultDiffusionList,
            Replace[ZAverageDiameters] -> resultAverageParticleSizeList,
            Replace[PolyDispersityIndices] -> resultPolyDisperistyIndexList,
            Replace[CorrelationCurves] -> resultCorrelationCurveList,
            Replace[SolventRayleighRatios] -> solventRayleighRatioList,

            (* Diffusion fit statistics *)
            DiffusionInteractionParameterStatistics -> averageDiffusionInteractionAssociation,
            DiffusionInteractionParameterFit -> Link[averageDiffusionInteractionFitObject],

            (* Virial Coefficient Statistics and parameters *)
            SecondVirialCoefficientStatistics -> secondViralCoefficentAssociation,
            SecondVirialCoefficientFit -> Link[secondViralCoefficentFitObject],
            CalibrationStandardIntensity -> calibrationStandardIntensity,
            OpticalConstantValue -> opticalConstant,

            (* Estimated Molecular Weight*)
            EstimatedMolecularWeight -> trueMolecularWeight,

            (* Kirkwood Buff integral statistics *)
            KirkwoodBuffIntegralStatistics -> kirkwoodBuffIntegralAssociation,
            KirkwoodBuffIntegralFit -> Link[kirkwoodBuffIntegralFitObject]
        |>
    |>
];




(*Preview function to plot analysis*)
(* The same plot function is used for both functions *)
analyzePreviewDynamicLightScattering[
    KeyValuePattern[{
		Packet -> packet_,
        ResolvedOptions -> KeyValuePattern[{
            Output -> output_
        }]
    }]
]:=Module[{newPacket, fig, previewRequestQ},

    previewRequestQ = MemberQ[ToList[output], Preview];

    fig = If[previewRequestQ,
        newPacket = Analysis`Private`stripAppendReplaceKeyHeads[packet];
        PlotObject[newPacket],

        Null
    ];

	<|
		Preview->fig
	|>
];

(* ---------- Object[Data, MeltingCurve] --------- *)

(* Resolve inputs *)
analyzeDownloadInputDynamicLightScattering[
	KeyValuePattern[{
		UnresolvedInputs->KeyValuePattern[{
			InputData -> inputData:ObjectP[Object[Data, MeltingCurve]]
		}],
        Intermediate->KeyValuePattern[{
            ThisProtocol -> protocol_
        }]
	}]
]:= Module[
    {
        initialZAverageDiameter, initialZAverageDiffusionCoefficient, initialPolydispersityIndex, initialCorrelationCurve,
        finalZAverageDiameter, finalZAverageDiffusionCoefficient, finalPolydispersityIndex, finalCorrelationCurve,
        initialDynamicLightScatteringTemperature, finalDynamicLightScatteringTemperature, rawDataFiles, wavelengthList,
        resolvedInitialTemeprature, resolvedFinalTemeprature, uncleFullDataTable, viscosityList, dynamicViscosity,
        solventRefractiveIndexList, solventRefractionIndex, detectionAngle, wavelengthValue, wavelengthNanometer,
        scatteringVector, diffusionToGamma
    },


    (* Batch download all fields up front *)
	{
        initialZAverageDiameter,
        initialZAverageDiffusionCoefficient,
        initialPolydispersityIndex,
        initialCorrelationCurve,
        initialDynamicLightScatteringTemperature,
        finalZAverageDiameter,
        finalZAverageDiffusionCoefficient,
        finalPolydispersityIndex,
        finalCorrelationCurve,
        finalDynamicLightScatteringTemperature,
        rawDataFiles,
        wavelengthList
	} = Download[
        inputData,
		{
            InitialZAverageDiameter,
            InitialZAverageDiffusionCoefficient,
            InitialPolydispersityIndex,
            InitialCorrelationCurve,
            InitialDynamicLightScatteringTemperature,
            FinalZAverageDiameter,
            FinalZAverageDiffusionCoefficient,
            FinalPolydispersityIndex,
            FinalCorrelationCurve,
            FinalDynamicLightScatteringTemperature,
            RawDataFiles,
            Protocol[Instrument][DynamicLightScatteringWavelengths]
		}
	];

    (* convert temperature to Kelvin *)
    resolvedInitialTemeprature = Convert[initialDynamicLightScatteringTemperature, Kelvin];
    resolvedFinalTemeprature = Convert[finalDynamicLightScatteringTemperature, Kelvin];

    (*Download the first raw data file which contains the summary info from the experiment *)
    uncleFullDataTable = ImportCloudFile[rawDataFiles[[1]]];

    (* for viscosity and refractive index, assume they are constant by sample and average across all samples *)
    viscosityList = ToExpression[Rest[uncleFullDataTable[[1]][[;; , -5]]]];
    dynamicViscosity = Mean[viscosityList] * Centipoise;

    solventRefractiveIndexList = ToExpression[Rest[uncleFullDataTable[[1]][[;; , -4]]]];
	  solventRefractionIndex = Mean[solventRefractiveIndexList];

    (* The detection angle is hard coded *)
    detectionAngle = Pi/2; (* https://www.youtube.com/watch?v=byoPIbzZ9XE, states that Uncle uses a 90 degree angle *)

    (* Pull wavelength value out of the list, assumed to be length one *)
	  wavelengthValue = First[wavelengthList];
    wavelengthNanometer = Convert[wavelengthValue, Nanometer];

    (* The scattering vector is in units of nanometers *)
    scatteringVector = 4*Pi*solventRefractionIndex*Sin[detectionAngle/2]/wavelengthNanometer;

    (* conversion between gamma and diffusion, gamma = 2q^2*diffusion, q is the scattering vector *)
    diffusionToGamma = 2*scatteringVector^2;

    <|
        ResolvedInputs-><|
            InitialZAverageDiameter -> initialZAverageDiameter,
            InitialZAverageDiffusionCoefficient -> initialZAverageDiffusionCoefficient,
            InitialPolydispersityIndex -> initialPolydispersityIndex,
            InitialCorrelationCurve -> initialCorrelationCurve,
            InitialDynamicLightScatteringTemperature -> resolvedInitialTemeprature,
            FinalZAverageDiameter -> finalZAverageDiameter,
            FinalZAverageDiffusionCoefficient -> finalZAverageDiffusionCoefficient,
            FinalPolydispersityIndex -> finalPolydispersityIndex,
            FinalCorrelationCurve -> finalCorrelationCurve,
            FinalDynamicLightScatteringTemperature -> resolvedFinalTemeprature,
            WavelengthNanometer -> wavelengthNanometer,
            DynamicViscosity -> dynamicViscosity,
            SolventRefractionIndex -> solventRefractionIndex,
            DiffusionToGamma -> diffusionToGamma,
            (* use this as a place holder because the code for Data DLS depends on it in the shared option resolution code *)
            TolueneLightIntensityValue -> Null
        |>,
        Tests -> <|
            ResolvedInputTests -> {}
        |>,
        Packet -> <|
            Type -> Object[Analysis, DynamicLightScattering],
            Replace[Protocols] -> Link[protocol],
            Replace[Reference] -> Link[inputData, DynamicLightScatteringAnalyses],
            RefractiveIndex -> solventRefractionIndex,
            AverageViscosity -> dynamicViscosity
        |>
    |>
];

(*Calculate dynamic light scattering parameters for the melting curve*)
analyzeCalculateDynamicLightScattering[
	KeyValuePattern[{
        UnresolvedInputs->KeyValuePattern[{
            InputData -> inputData:ObjectP[Object[Data, MeltingCurve]]
		}],
        ResolvedInputs -> KeyValuePattern[{
            (*constants*)
            InitialZAverageDiameter -> initialZAverageDiameter_,
            InitialZAverageDiffusionCoefficient -> initialZAverageDiffusionCoefficient_,
            InitialPolydispersityIndex -> initialPolydispersityIndex_,
            InitialCorrelationCurve -> initialCorrelationCurve_,
            InitialDynamicLightScatteringTemperature -> initialDynamicLightScatteringTemperature_,
            FinalZAverageDiameter -> finalZAverageDiameter_,
            FinalZAverageDiffusionCoefficient -> finalZAverageDiffusionCoefficient_,
            FinalPolydispersityIndex -> finalPolydispersityIndex_,
            FinalCorrelationCurve -> finalCorrelationCurve_,
            FinalDynamicLightScatteringTemperature -> finalDynamicLightScatteringTemperature_,
            (*list*)
            DynamicViscosity -> dynamicViscosity_,
            DiffusionToGamma -> diffusionToGamma_
    	}],
        ResolvedOptions -> KeyValuePattern[{
            PolynomialDegree -> polynomialDegree_,
            CorrelationMinimumValue -> correlationMinimumValue_,
            CorrelationMinimumMethod -> correlationMinimumMethod_,
            Method -> method_,
            ConvergenceTimeThreshold -> convergenceTimeThreshold_,
            ConvergenceCorrelationThreshold -> convergenceCorrelationThreshold_,
            InitialTimeThreshold -> initialTimeThreshold_,
            InitialCorrelationMinimumThreshold -> initialCorrelationMinimumThreshold_,
            InitialCorrelationMaximumThreshold -> initialCorrelationMaximumThreshold_
    	}]
	}]
]:= Module[
    {
        curveScores, abnormalCurves, initialCorrelationParameters, finalCorrelationParameters,
		resultAverageParticleSizeList, resultDiffusionList, resultPolyDisperistyIndexList,
		resultCorrelationCurveList
    },

    (* check that the correlation curves are properly loaded *)
    (*
        filter data again based on initial value
        find the average initial value of the curves
        this helper function is from DynamicLightScatteringLoading
    *)
    curveScores = scoreFromOneCurve[#, initialTimeThreshold]&/@{initialCorrelationCurve, finalCorrelationCurve};

    (* keep the curves between the cuttoff *)
    abnormalCurves = Select[curveScores, !(#>initialCorrelationMinimumThreshold && #<initialCorrelationMaximumThreshold)&];

    (* issue a warning that one of the correlation curves is low or high *)
    If[Length[abnormalCurves]>0,
        Message[Warning::CurvesOutsideRange, inputData, initialCorrelationMinimumThreshold, initialCorrelationMaximumThreshold]
    ];

    (* If method is instrument, return the current values, otherwise use the cumulants method *)
    (* Pull out initial values - includes diameter, PDI, and diffusion *)
    initialCorrelationParameters = If[MatchQ[method, Cumulants],
        oneCurveCumulants[
            initialCorrelationCurve,
            diffusionToGamma,
            polynomialDegree,
            correlationMinimumValue,
            correlationMinimumMethod,
            initialDynamicLightScatteringTemperature,
            dynamicViscosity,
	    inputData,
	    Initial
        ],

        (* Instrument values from protocol *)
        {
            initialZAverageDiameter,
            initialZAverageDiffusionCoefficient,
            initialPolydispersityIndex
        }
    ];

    (* Pull final values *)
    finalCorrelationParameters = If[MatchQ[method, Cumulants],
        oneCurveCumulants[
            finalCorrelationCurve,
            diffusionToGamma,
            polynomialDegree,
            correlationMinimumValue,
            correlationMinimumMethod,
            finalDynamicLightScatteringTemperature,
            dynamicViscosity,
	    inputData,
	    Final
        ],

        (* Instrument values from protocol *)
        {
            finalZAverageDiameter,
            finalZAverageDiffusionCoefficient,
            finalPolydispersityIndex
        }
    ];

    (* transpose together final an initial parameters to group parameter calculations *)
    {
        resultAverageParticleSizeList,
        resultDiffusionList,
        resultPolyDisperistyIndexList
    } = Transpose[{initialCorrelationParameters, finalCorrelationParameters}];

    resultCorrelationCurveList = {initialCorrelationCurve, finalCorrelationCurve};

	<|
	      Tests -> <|
				      ResolvedInputTests -> {}
	      |>,
	      Packet -> <|
	            (* Index matched data *)
	            Replace[AssayConditions] -> {Initial, Final},
	            Replace[DiffusionCoefficients] -> resultDiffusionList,
	            Replace[ZAverageDiameters] -> resultAverageParticleSizeList,
	            Replace[PolyDispersityIndices] -> resultPolyDisperistyIndexList,
	            Replace[CorrelationCurves] -> resultCorrelationCurveList
	      |>
	|>
];


uncleTableRowExtract[table_, row_, sampleRanges_]:=Module[{myRow},

    (* pull out the full row, except the first value which is a header *)
    myRow = Quiet[
        ToExpression[Rest[table[[1]][[;; , row]]]],
        {ToExpression::sntx, ToExpression::sntxi}
    ];

    (* pull out only the samples desired *)
    myRow[[sampleRanges]]

];

(*concnetration parser *)
(* numbers show up like 9.8 mg sample_/ml *)
(* general case *)
concentrationParse[Times[val_?NumericQ, __]] := val;
(* the 1 in the times disappears, if there is no number, it is assumed to be a 1 *)
concentrationParse[Times[___]] := 1;
(* this is for zeros or when only a number without units is presented *)
concentrationParse[x_?NumericQ] := x;

(* reformat how the diffusion values are stored from Uncle to our data *)
diffusionParse[Plus[exponent_, Times[base_Real, __]]] := base*10^exponent;
diffusionParse[value_?NumericQ] := value;
diffusionParse[__] := 0;

opticalConstantCalculation[solventRefraction_, dndc_, wavelength_]:=Module[
    {avogadrosNumber},

    (*Molecules per mole *)
    avogadrosNumber = 6.022*10^23 * 1 / Mole;

    2*Pi^2*solventRefraction*dndc^2/(avogadrosNumber*wavelength^4)

];


(* Overload: Second Virial Coefficient calculation for Uncle *)
secondVirialCoefficientCalculation[
    thisInstrument:ObjectP[Object[Instrument, MultimodeSpectrophotometer]],
    proteinConcentrationList:{UnitsP[Gram/Liter]..},
    derivedIntensity_List,
    bufferIntensity_,
    tolueneIntensity_,
    solventRefraction_,
    opticalConstant_
]:=Module[
	{
        tolueneRefractionAngle, tolueneRayleighRatio, intensityDifferenceList, rayleighRatioList,
        secondVirialY, secondVirialData, secondVirialCoefficientFit, yIntercept, slopeValue,
        yUnit, xUnit, molecularWeightApparent, virialCoefficient
	},

	(* Sources *)
	(* https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2518745/#FD2*)
	(* https://www.cordouan-tech.com/wp-content/uploads/2018/02/NT02-VASCO-Molecular-weight_EN_V01-.pdf *)
	(* http://www.appliedpolymertechnology.org/uploads/1/0/8/8/108867241/rayleighfactorreview2010.pdf - Rayleigh Ratio for Toluene and Benzene *)
	(* https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5572220/#:~:text=The%20specific%20refractive%20index%20increment,to%20size%2Dbased%20separation%20techniques. dn/dc values for polymers *)
	(* https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6387658/ dn/dc values for proteins 0.185 ml/g is a generic value but can be calculated using amino acids or measured with the device *)

    (* CONSTANTS *)
    tolueneRefractionAngle = 1.492;

    (* From Corduan tech source, user spreadsheet says 1.15e*10^-5, applied polymer technology has a function, also from Uncle notes *)
    tolueneRayleighRatio = 1.15*10^-5 * 1/Centimeter;

	(* Difference from buffer *)
	intensityDifferenceList = derivedIntensity - bufferIntensity;

	(* Rayleigh ratio for solvent compared to toluene *)
	rayleighRatioList = tolueneRayleighRatio*intensityDifferenceList*solventRefraction^2/(tolueneIntensity*tolueneRefractionAngle^2);

	(* y - value for the plot in units of mol/g symbolic form is Kc/R0 *)
	secondVirialY = opticalConstant * proteinConcentrationList / rayleighRatioList;

	(*Units are stripped off and data is paried into points for fitting *)
	secondVirialData = Transpose[{proteinConcentrationList, secondVirialY}];

    (* find the cumulant fit, by default it fits a line *)
	secondVirialCoefficientFit = AnalyzeFit[
        secondVirialData,
        Upload->False
    ];

    (* Pull out the slope and intercept *)
	{
        yIntercept,
        slopeValue
    } = Part[
        Lookup[
            secondVirialCoefficientFit,
            Replace[BestFitParameters]
        ],
        All, 2
    ];

    (* calculate x and y units *)
    yUnit = QuantityUnit[opticalConstant*proteinConcentrationList/rayleighRatioList][[1]];
    xUnit = QuantityUnit[proteinConcentrationList][[1]];

    (* add units to intercept and slope *)
    yIntercept = Quantity[yIntercept, yUnit];
    slopeValue = Quantity[slopeValue, yUnit/xUnit];

	(*Calculate MW and virialCoefficient from the fit *)
	molecularWeightApparent = 1/yIntercept;
	virialCoefficient = slopeValue/2;

    (* Return the fit statistice (value, slope, intercept) and the Rayleigh Ratio *)
    (* Add units of the optical constant/rayleigh ratio from zimmEquationY. Since the slope has a concentration in the y and x, those units will cancel *)
	{
        (* statistics for the object *)
        {
            Convert[virialCoefficient, Milliliter*Mole/Gram^2],
            Convert[slopeValue, Milliliter*Mole/Gram^2],
            Convert[yIntercept, Mole/Gram],
            secondVirialCoefficientFit[RSquared],
            Convert[molecularWeightApparent, Gram/Mole]
        },
        secondVirialCoefficientFit,
        rayleighRatioList
    }

];

(* Overload: Second Virial Coefficient calculation for DynaPro *)
secondVirialCoefficientCalculation[
    thisInstrument:ObjectP[Object[Instrument, DLSPlateReader]],
    proteinConcentrationList:{UnitsP[Gram/Liter]..},
    opticalConstant_,
    apparentMW_
]:=Module[
    {
        rayleighRatioList, secondVirialCoefficientFit, virialCoefficient,
        trueMolecularWeightData, trueMolecularWeightFitIntercept,
        trueMolecularWeightFitSlope, xUnitMWFit, yUnitMWFit, trueMolecularWeight,
        fittedIntercept, fittedSlope
    },

    (*  DynaPro provided apparent molecular weight. We could use AnalyzeFit to do the fitting directly.
        The equation to fit data:
        M_apparent = R(\theta)/(K*c) = M_true - 2*A2*M_true^2*c
    T   The formula is Eq.#A-12, from DYNAMICS 8 Users's Guide (M1408 Rev D).pdf, page 315
    *)

    trueMolecularWeightData = Transpose[{proteinConcentrationList, apparentMW}];

    (* Fit a line given the equation above*)
    secondVirialCoefficientFit = AnalyzeFit[trueMolecularWeightData, Upload->False];

    (* Pull out the slope and intercept *)
    {fittedIntercept, fittedSlope} = Part[
        Lookup[secondVirialCoefficientFit, Replace[BestFitParameters]],
        All, 2
    ];

    xUnitMWFit = QuantityUnit[First[proteinConcentrationList]];
    yUnitMWFit = QuantityUnit[First[apparentMW]];

    (* add units to intercept and slope*)
    trueMolecularWeightFitIntercept = Quantity[fittedIntercept, yUnitMWFit];
    trueMolecularWeightFitSlope = Quantity[fittedSlope, yUnitMWFit/xUnitMWFit];

    (* this intercept is true molecular weight*)
    trueMolecularWeight = trueMolecularWeightFitIntercept;
    (*A2 is calculated from equation slope=-2*A2*trueMolecularWeight*)
    virialCoefficient = -trueMolecularWeightFitSlope/(2*trueMolecularWeight^2);

    (* Rayleigh Ratio is R(\theta), which is M_apparent*K*c *)
    rayleighRatioList = apparentMW * opticalConstant * proteinConcentrationList;

    (* Return the fit statistic (value, slope, intercept) and the Rayleigh Ratio *)
    (* Add units of the optical constant/rayleigh ratio from Zimm's Equation. Since the slope has a concentration in the y and x, those units will cancel *)
    {
        (* statistics for the object *)
        {
            Convert[virialCoefficient, Milliliter*Mole/Gram^2],
            Convert[trueMolecularWeightFitSlope, Milliliter/Mole],
            Convert[trueMolecularWeightFitIntercept, Gram/Mole],
            secondVirialCoefficientFit[RSquared],
            Convert[trueMolecularWeight, Gram/Mole]
        },
        (* fit packet *)
        secondVirialCoefficientFit,
        (* Rayleigh Ratio List*)
        rayleighRatioList
    }
];


(* Diffusion interaction (kD) *)
diffusionInteractionCalculation[
    proteinConcentrationList:{UnitsP[Gram/Liter]..},
    diffusionList:{UnitsP[Meter^2/Second]..},
    temperature_,
    viscosity_
]:=Module[
    {
        diffusionData, kD, slopeValue, xUnits, yUnits, yIntercept, diffusionInteractionFit, hydrodynamicDiameter
    },

	(*Convert protein concentrations to units of g/mL*)
    xUnits = Units[proteinConcentrationList[[1]]];

	(*Convert diffusion data to m2/s *)
    yUnits = Units[diffusionList[[1]]];

	(*Units are converted first and then stripped off here*)
	diffusionData = Transpose[{QuantityMagnitude[proteinConcentrationList], QuantityMagnitude[diffusionList]}];

    diffusionData = Transpose[{proteinConcentrationList, diffusionList}];

    (* find the cumulant fit, by default it fits a line *)
	diffusionInteractionFit = AnalyzeFit[
        diffusionData,
        Upload->False
    ];

    (* Pull out the slope and intercept *)
	{
        yIntercept,
        slopeValue
    } = Part[
        Lookup[
            diffusionInteractionFit,
            Replace[BestFitParameters]
        ],
        All, 2
    ];

    (* add units *)
    slopeValue = Quantity[slopeValue, yUnits/xUnits];
    yIntercept = Quantity[yIntercept, yUnits];

	(* Calculate kd which is the ratio of the slope to the intercept *)
	kD = slopeValue/yIntercept;

    (* calculate hydrodynamic diameter using average diffusion at conc. = 0 *)
    hydrodynamicDiameter = stokesEinsteinDiameter[
       temperature,
       viscosity,
       yIntercept
    ];

	(*Add units to kD, slope and y-intercept *)
	{
        (* statistics for the object *)
        {
            kD,
            slopeValue,
            yIntercept,
            diffusionInteractionFit[RSquared],
            hydrodynamicDiameter
        },
        diffusionInteractionFit
    }
];

(* G22 *)
kirkwoodBuffIntegralCalculation[
    proteinConcentrationList:{UnitsP[Gram/Liter]..},
    rayleighRatios_,
    opticalConstant_,
    molecularWeight_
]:=Module[
    {
        xUnits, yValues, yUnits, kirkwoodBuffData, kirkwoodBuffIntegralFit, molecularWeightApparent, secondOrderTerm,
        kirkwoodBuffIntegral
    },

    (* Sources
        https://pubs.acs.org/doi/pdf/10.1021/jp412301h - Eq. 4 - only uses MW apparent
            EQ -> R90/K = MWapp*C(1+G22*C )
        http://www.chayon.co.kr/wp-content/uploads/2019/04/Application%20Note%20-%20Assess%20aggregation%20risk%20at%20higher%20protein%20concentrations%20with%20G22.pdf - Instrument source
            EQ -> R90/K = MWapp*c + MW*G22*c^2
        based on: https://academic.oup.com/peds/article/29/6/231/2223253
    *)

	(* Pull out protein concentration units *)
    xUnits = Units[proteinConcentrationList[[1]]];

	(* y values are the ratio of R90 (Rayleigh ratio) to the optical constant *)
    yValues = rayleighRatios/opticalConstant;
    yUnits = Units[yValues][[1]];

	(*Units are converted first and then stripped off here*)
	kirkwoodBuffData = Transpose[{proteinConcentrationList, yValues}];

    (* find the cumulant fit, by default it fits a line *)
	kirkwoodBuffIntegralFit = AnalyzeFit[
        kirkwoodBuffData,
        coeff1 * #1 + coeff2 * #1^2 &,
        Upload->False
    ];

    (* Pull out the first order term (MW apparent) and second order term (MW*G22) *)
	{
        molecularWeightApparent,
        secondOrderTerm
    } = Part[
        Lookup[
            kirkwoodBuffIntegralFit,
            Replace[BestFitParameters]
        ],
        All, 2
    ];

    (* add units to the fit terms *)
    molecularWeightApparent = molecularWeightApparent * yUnits/xUnits;
    secondOrderTerm = secondOrderTerm * yUnits/xUnits^2;

	(* Calculate G22 by dividing out the molecular weight *)
	kirkwoodBuffIntegral = secondOrderTerm/molecularWeight;

	(*Add units to kD, slope and y-intercept *)
	{
        (* statistics for the object *)
        {
            Convert[kirkwoodBuffIntegral, Milliliter/Gram],
            Convert[molecularWeightApparent, Gram/Mole],
            Convert[secondOrderTerm, Milliliter/Mole],
            Lookup[kirkwoodBuffIntegralFit, RSquared],
            Convert[molecularWeightApparent, Gram/Mole]
        },
        (* parameter fit *)
        kirkwoodBuffIntegralFit
    }
];


(* Delete rows where the correlation curve has not dropped by 90% before the time cutoff, this indicates significant noise or disturbance *)
removeBadCorrelations[
    masterTable_,
    convergenceTimeCutOff_,
    convergenceCorrelationCutOff_,
    intialTimeCutOff_,
    initialCorrelationMinimum_,
    initialCorrelationMaximum_,
    method_,
    inputData_
]:=Module[
	{
        firstPointFunction, firstPointData, newTable, curveScores,
        numericMasterTable, badBooleans, badRows
    },

    (* If the method is Instrument, check if the filled in data is appropriate *)
    (* Make sure from the third column to the end passes NumericQ, otherwise delete the row *)

    numericMasterTable = If[MatchQ[method, Instrument],

        badBooleans = Map[
            NumericQ[QuantityMagnitude[#]] &,
            masterTable[[;; , 3;;-2]],
            {2}
        ];

        (*Find the offending row *)
        badRows = Position[badBooleans, False][[;; , 1]];

        (* remove bad rows from the master table *)
        If[Length[badRows]>0,
            Message[Warning::BadInstrumentData, inputData, badRows];
            Delete[masterTable, badRows],
            masterTable
        ],

        (* otherwise just return the table as is, other methods will fill it out as needed *)
        masterTable

    ];

	(* Pure function to find the first point where the convergenceCorrelationCutOff is crossed *)
	firstPointFunction = Function[{correlationCurve},
        SelectFirst[
            QuantityMagnitude[correlationCurve],#[[2]]<convergenceCorrelationCutOff*QuantityMagnitude[correlationCurve[[1,2]]]&
        ]
    ];

	(* Find the first point where the crossing of the converge occures. Correlation curves are the second column *)
	firstPointData = firstPointFunction[#[[2]]]&/@numericMasterTable;

	(* Delete the cases where the x value is less than the timeCutOff *)
	newTable = PickList[numericMasterTable, firstPointData, _?(#[[1]]<QuantityMagnitude[convergenceTimeCutOff]&)];

    (*
        filter data again based on initial value
        find the average initial value of the curves
        this helper function is from DynamicLightScatteringLoading
    *)
    curveScores = scoreFromOneCurve[#[[2]], intialTimeCutOff]&/@newTable;

    (* keep the curves between the cuttoff *)
    abnormalCurves = Select[ToList[curveScores], !(#>initialCorrelationMinimum && #<initialCorrelationMaximum)&];

    (* find concentrations of the abnormal curves *)
    badIndexPositions = Flatten[Position[curveScores, Alternatives@@abnormalCurves]];
    badConditions = numericMasterTable[[;;,1]][[badIndexPositions]];

    (* issue a warning that one of the correlation curves is low or high and was removed *)
    If[Length[abnormalCurves]>0,
        Message[
            Warning::CurvesOutsideRangeRemoved,
            inputData,
            badConditions,
            initialCorrelationMinimum,
            initialCorrelationMaximum
        ]
    ];

    (* keep the curves above the cutoff *)
    newTable = PickList[newTable, curveScores, _?((#>initialCorrelationMinimum && #<initialCorrelationMaximum)&)]

];


(*Overload: Cumulants method for Uncle*)
cumulantsMethod[
    thisInstrument:ObjectP[Object[Instrument, MultimodeSpectrophotometer]],
    dataTable_,
    diffusionToGamma_,
    polynomialDegree_,
    thresholdValue_,
    thresholdMethod_,
    temperature_,
    viscosity_,
    inputData_,
    assayConditions_
]:=Module[
    {
        correlationCurves, zDiffusionDiameter, zDiffusionCoefficientQuantity, polydispersityIndex,
        cumulantTable, oneCurveOutputs
    },

    (*
        The table is consisted row wise is
        1) concentration
        2) correlation curve
        3) derived intensity
        4) z average particle size
        5) diffusion
        6) polydisperisty index
        7) first peak particle size
        8) first peak diffusion coefficient
     *)

     (*
        We need to replace rows 5-9 with our calculations.
        In the cumulants method, the first peak is the same as the z-average.
    *)

    (* pull out the correlation curves *)
    correlationCurves = dataTable[[;;,2]];

    (* calculate the diameters, diffusions, and PDIs with the cumulants method *)
    oneCurveOutputs = MapThread[
        oneCurveCumulants[#1, diffusionToGamma, polynomialDegree, thresholdValue, thresholdMethod, temperature, viscosity, inputData, #2]&,
		{correlationCurves, assayConditions}
    ];

    {
        zDiffusionDiameter,
        zDiffusionCoefficientQuantity,
        polydispersityIndex
    } = Transpose[oneCurveOutputs];

    (* insert the new values into the table *)
    cumulantTable = dataTable;
    cumulantTable[[;;,4]] = zDiffusionDiameter;
    cumulantTable[[;;,5]] = zDiffusionCoefficientQuantity;
    cumulantTable[[;;,6]] = polydispersityIndex;
    cumulantTable[[;;,7]] = zDiffusionDiameter;
    cumulantTable[[;;,8]] = zDiffusionCoefficientQuantity;

    cumulantTable
];


(*Overload: Cumulants method for DynaPro*)
cumulantsMethod[
    thisInstrument:ObjectP[Object[Instrument, DLSPlateReader]],
    dataTable_,
    diffusionToGamma_,
    polynomialDegree_,
    thresholdValue_,
    thresholdMethod_,
    temperature_,
    viscosity_,
	inputData_,
	assayConditions_
]:=Module[
    {
        correlationCurves, zDiffusionDiameter, zDiffusionCoefficientQuantity, polydispersityIndex,
        oneCurveOutputs, resultCumulantTable
    },

    (*
        The table is consisted row wise is
        1) concentration
        2) correlation curve
     *)

    (*
       We need to add columns with our calculations.
       In the cumulants method, the first peak is the same as the z-average so only the average is returned.
   *)

    (* pull out the correlation curves *)
    correlationCurves = dataTable[[;;,2]];

    (* calculate the diameters, diffusions, and PDIs with the cumulants method *)
    oneCurveOutputs = MapThread[
        oneCurveCumulants[#1, diffusionToGamma, polynomialDegree, thresholdValue, thresholdMethod, temperature, viscosity, inputData, #2]&,
		{correlationCurves, assayConditions}
    ];

    {
        zDiffusionDiameter,
        zDiffusionCoefficientQuantity,
        polydispersityIndex
    } = Transpose[oneCurveOutputs];

    (* insert the new values into the table *)
    resultCumulantTable = dataTable;
    resultCumulantTable = MapThread[Append, {resultCumulantTable, zDiffusionDiameter}];
    resultCumulantTable = MapThread[Append, {resultCumulantTable, zDiffusionCoefficientQuantity}];
    resultCumulantTable = MapThread[Append, {resultCumulantTable, polydispersityIndex}];

    resultCumulantTable
];


oneCurveCumulants[
    correlationCurve_,
    diffusionToGamma_,
    polynomialDegree_,
    thresholdValue_,
    thresholdMethod_,
    temperature_,
    viscosity_,
    inputData_,
    assayCondition_
]:=Module[
    {
        xUnits, xValues, measuredValues, thresholdScale, pdiPoints, cumulantFit,
        cumulantBestFitParameters, yIntercept, negativeFirstCumulant, secondCumulant,
        firstCumulant, zDiffusionCoefficient, zDiffusionCoefficientQuantity, zDiffusionDiameter,
        gamma, mu, polydispersityIndex
    },

	(*Sources*)
	(* https://arxiv.org/pdf/1504.06502.pdf *)
	(* https://www.iso.org/standard/40942.html *)
	(* https://www.eng.uc.edu/~beaucag/Classes/Characterization/DLS/PaulRussoLSU2012DLS_Minicourse.pdf pg. 11-16 - this is the best resource *)

	(*Save time units for later conversions *)
	xUnits = Units[correlationCurve[[;;,1]][[1]]];

	(* Pull out experimental correlation data and strip units *)
	xValues = QuantityMagnitude[correlationCurve[[;;,1]]];
	measuredValues = QuantityMagnitude[correlationCurve[[;;,2]]];

    (* If the threshold method is relative scale by first value, otherwise by 1 *)
    (* move this to option resolution *)
    thresholdScale = If[MatchQ[thresholdMethod, Absolute],
        1,
        measuredValues[[1]]
    ];

	(* calculate how many data points to include in the analysis *)
	pdiPoints = First@FirstPosition[measuredValues, x_ /; x < thresholdValue*thresholdScale];

    (* find the cumulant fit*)
	cumulantFit = AnalyzeFit[
        Transpose[{xValues, Log[measuredValues]}][[;;pdiPoints]],
        Polynomial,
        PolynomialDegree->polynomialDegree,
        Upload->False
    ];

    (* pull out all best fit parameters *)
    cumulantBestFitParameters = Part[
        Lookup[
            cumulantFit,
            Replace[BestFitParameters]
        ],
        All, 2
    ];

	(* Pull out the first 3 values, since that is all that is needed for diameter and diffusion analysis *)
	{
        yIntercept,
        negativeFirstCumulant,
        secondCumulant
    } = Part[
        cumulantBestFitParameters,
        ;;3
    ];

	(* Change the first cumulant to the negative of itself since the cumulants function form assumes it is negative already *)
    (* add units of inverse xUnits because the firstCumulant*time must be unitless in the exponent *)
	firstCumulant = -negativeFirstCumulant*1/xUnits;

	(*Calculate the diffusion coefficient from the initial gamma value*)
	zDiffusionCoefficient = (firstCumulant/(diffusionToGamma));

	(* Convert dffusions to m2/s *)
	zDiffusionCoefficientQuantity = Convert[zDiffusionCoefficient, Meter^2/Second];

    zDiffusionDiameter = stokesEinsteinDiameter[temperature, viscosity, zDiffusionCoefficientQuantity];

	(* pull out parameters for PDI *)
	gamma = firstCumulant;
	mu = 2*secondCumulant*1/xUnits^2;

	polydispersityIndex = mu/gamma^2;

	{
        zDiffusionDiameter,
        zDiffusionCoefficientQuantity,
        (* make sure PDI is at least 0 *)
        Max[polydispersityIndex, 0]
    }
];

(* Calculate the particle size using the Stokes-Einstein relationship *)
stokesEinsteinDiameter[
    temperature:UnitsP[Kelvin],
    dynamicViscosity:UnitsP[Pascal Second],
    diffusionCoefficient:UnitsP[Meter^2/Second]
]:=Module[
	{
        boltzmannConstant, diameter
    },

	(*Constants*)
	boltzmannConstant = 1.3806*10^-23 Meter^2*Kilogram/(Second^2)/Kelvin;

	(*Stokes-Einstein relationship*)
	diameter = (boltzmannConstant*temperature)/(3*Pi*dynamicViscosity*diffusionCoefficient);

	(*Convert to Nanometer*)
	Convert[diameter, Nanometer]
];

(* Calculate the particle diffusion using the Stokes-Einstein relationship *)
stokesEinsteinDiffusion[
    temperature:UnitsP[Kelvin],
    dynamicViscosity:UnitsP[Pascal Second],
    diameter:UnitsP[Meter]
]:=Module[
	{
        boltzmannConstant, diffusionCoefficient
    },

	(*Constants*)
	boltzmannConstant = 1.3806*10^-23 Meter^2*Kilogram/(Second^2)/Kelvin;

	(*Stokes-Einstein relationship*)
	diffusionCoefficient = (boltzmannConstant*temperature)/(3*Pi*dynamicViscosity*diameter);

	(*Convert to M2/S*)
	diffusionCoefficient = Convert[diffusionCoefficient, Meter^2/Second]
];

(* Helper for warnings of being out of spec *)
warningISO[
    method_,
    correlationMinimumValue_,
    initialCorrelationMinimumThreshold_,
    initialCorrelationMaximumThreshold_
]:=Module[
    {},

    (* If CorrelationMinimumValue is too high we are no longer doing the ISO Cumulants method *)
    If[correlationMinimumValue > 0.05 && !MatchQ[method, Instrument],
        Message[Warning::NonSpecificationOption, CorrelationMinimumValue]
    ];

    (* If InitialCorrelationMinimumThreshold is too low, we are no longer doing the ISO Cumulants method *)
    If[initialCorrelationMinimumThreshold < 0.6,
        Message[Warning::NonSpecificationOption, InitialCorrelationMinimumThreshold]
    ];

    (* If InitialCorrelationMaximumThreshold is too high we are no longer doing the ISO Cumulants method *)
    If[initialCorrelationMaximumThreshold > 1.2,
        Message[Warning::NonSpecificationOption, InitialCorrelationMaximumThreshold]
    ];

];

(* Helper function to find solvent name from samplesIn*)
getSolvent[samplesInComposition_]:=Module[{comp, compWithoutNull, volumeMagnitude, solventIndex},
    (*The solvent is the maximum volume component in the sample*)

    comp = First[samplesInComposition];
    (*sometimes there is null in Composition, replace it with 0 first*)
    compWithoutNull = comp[[;;, 1]]/.x_/;MatchQ[x, Null]->0;
    (*remove units to find the maximum position*)
    volumeMagnitude = QuantityMagnitude[compWithoutNull];
    (*get the maximum volume index and based on the index find the solvent name*)
    solventIndex = Position[volumeMagnitude, Max[volumeMagnitude]];
    solventName = comp[[;;, 2]][[Flatten[solventIndex]]][Name];
    solventName

];

(* Helper function to return viscosity. It uses Interpolation function to get viscosity by given temperature *)
viscosityCalculation[solventName_, temperature_]:=Module[{
    viscosityWaterTable, viscosityTolueneTable,interpolateFunctionWater,interpolateFunctionToluene
    },

    (* the viscosity table has the unit Celsius and Centipoise*)
    (* this table is from https://www.engineeringtoolbox.com/absolute-dynamic-viscosity-water-d_575.html*)
    viscosityWaterTable = {{0, 1.794}, {4.4, 1.546}, {10.0, 1.310}, {15.6, 1.129}, {21.1, 0.982}, {26.7, 0.862},
        {32.2, 0.764}, {37.8, 0.682}, {48.9, 0.559}, {60.0, 0.470}, {71.1, 0.401}, {82.2, 0.347}, {93.3, 0.305}
    };
    (* this table is from https://www.engineeringtoolbox.com/toluene-thermal-properties-d_1763.html*)
    viscosityTolueneTable = {{0, 0.773}, {20, 0.583}, {50, 0.419}, {100, 0.269}, {200, 0.133}};

    interpolateFunctionWater = Interpolation[viscosityWaterTable];
    interpolateFunctionToluene = Interpolation[viscosityTolueneTable];

    viscosityMagnitude = Which[
        (*the solvent is water*)
        MatchQ[solventName, ListableP["Water"]],
        interpolateFunctionWater[QuantityMagnitude[temperature]],
        (*the solvent is toluene*)
        MatchQ[solventName, ListableP["Toluene"]],
        interpolateFunctionToluene[QuantityMagnitude[temperature]],
        (*if the solvent is other than water and toluene, it will set viscosity the same as water and a warning message*)
        True,
        Message[Warning::UnknownSolventViscosity, solventName];
        interpolateFunctionWater[QuantityMagnitude[temperature]]
    ];
    viscosityMagnitude

];

