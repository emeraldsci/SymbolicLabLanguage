(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*AnalyzeAirBubbleLikelihood*)


(* ::Subsubsection::Closed:: *)
(*AnalyzeAirBubbleLikelihood*)

(* The function is currently used in all parsers for LC experiments. However, it is not exported for public use yet (we can export it once the publication is online) *)

(* The current Liquid Chromatography Air Bubble Anomaly Detector Machine Learning Model *)
(* Object[EmeraldCloudFile, "Liquid Chromatography Air Bubble Anomaly Detector Machine Learning Model"] *)
(* Currently Object[EmeraldCloudFile, "id:01G6nvDooBBY"] *)
$AirBubbleLikelihoodModel=Object[EmeraldCloudFile, "Liquid Chromatography Air Bubble Anomaly Detector Machine Learning Model"];

(* Import $AirBubbleLikelihoodModel and memoize the value as a function because it takes some time *)
(* ImportCloudFile isn't able to import a specific element directly (as allowed by the second input to Import) *)
(* Note that Import as "NetExternalObject" is only brought into MM after 13.2. See "https://reference.wolfram.com/language/ref/NetExternalObject.html" so this only works on MM 13.2 or later *)
airBubbleLikelihoodPredictionModel[placeHolderString:_String] := airBubbleLikelihoodPredictionModel[placeHolderString] = Module[{},
	(*Add airBubbleLikelihoodPredictionModel to list of Memoized functions*)
	AppendTo[$Memoization,Analysis`Private`airBubbleLikelihoodPredictionModel];
	If[TrueQ[$VersionNumber >= 13.2],
		(* Import as NetExternalObject is only supported after MM 13.2 *)
		Import[
			DownloadCloudFile[
				$AirBubbleLikelihoodModel,
				$TemporaryDirectory
			],
			"NetExternalObject"
		],
		Null
	]
];

DefineOptions[AnalyzeAirBubbleLikelihood,
	Options :> {
		UploadOption,
		CacheOption
	}
];

Warning::NoPressureData="There are no Pressure trace(s) in the data `1` so we cannot predict the air bubble likelihood(s). These data object(s) will not be updated.";

(* Data overload *)
AnalyzeAirBubbleLikelihood[data:ListableP[ObjectP[{Object[Data,Chromatography],Object[Data,ChromatographyMassSpectra]}]], ops: OptionsPattern[]] := Module[
	{safeOps, cache, upload, downloadResult, noPressureDownloadResult, filteredDownloadResult, airBubbleLikelihoodPredictions, airBubbleLikelihoodUploadPackets,listedResult},

	safeOps = SafeOptions[AnalyzeAirBubbleLikelihood,ToList[ops]];
	{cache, upload} = Lookup[safeOps, {Cache, Upload}];
	downloadResult = Download[
		ToList[data],
		Packet[Pressure],
		Cache -> cache
	];

	(* Check if we have any data missing Pressure *)
	noPressureDownloadResult = Cases[
		downloadResult,
		KeyValuePattern[Pressure->Null]
	];

	(* Throw warning to skip data without Pressure *)
	If[!MatchQ[noPressureDownloadResult,{}]&&!MatchQ[$ECLApplication,Engine],
		Message[Warning::NoPressureData,ECL`InternalUpload`ObjectToString[Lookup[noPressureDownloadResult,Object,{}],Cache->cache]]
	];

	(* Get the data with Pressure *)
	filteredDownloadResult = DeleteCases[
		downloadResult,
		KeyValuePattern[Pressure->Null]
	];

	(* Return early if we don't have anything to predict *)
	If[MatchQ[filteredDownloadResult,{}],Return[data]];

	(* Get the air bubble likelihood from the main overload *)
	airBubbleLikelihoodPredictions=AnalyzeAirBubbleLikelihood[Lookup[downloadResult,Pressure], ops];

	(* Put together the packets for Upload to update AirBubbleLikelihood field *)
	airBubbleLikelihoodUploadPackets=MapThread[
		<|
			Object -> Lookup[#1,Object],
			AirBubbleLikelihood -> #2
		|>&,
		{downloadResult,airBubbleLikelihoodPredictions}
	];

	(* Upload or return the result based on Upload option *)
	listedResult=If[TrueQ[upload],
		Upload[airBubbleLikelihoodUploadPackets],
		airBubbleLikelihoodUploadPackets
	];

	(* Return single result if we had single input *)
	If[MatchQ[data,ObjectP[]],
		listedResult[[1]],
		listedResult
	]
];

(* Pressure/Time Tuple (Pressure Chromatogram) Overload *)
pressureInputSingleP = Alternatives[
	{{TimeP,PressureP}..},
	QuantityCoordinatesP[{Minute, PSI}],
	BigQuantityArrayP[{Minute, PSI}]
];

(* Pressure/Time Tuple (Pressure Chromatogram) Overload *)
AnalyzeAirBubbleLikelihood[in:ListableP[(pressureInputSingleP|Null)], ops: OptionsPattern[]] := Module[
	{singletonInputQ, listedInput, predictionModel, pressuresRaw, pressuresTrimmedAndPadded, nullPressurePositions, pressuresTrimmedAndPaddedNoNull, airBubbleLikelihoodPredictions, airBubbleLikelihoodPredictionsInserted},

	(* See if we have singleton input and this will decide our final output *)
	singletonInputQ = MatchQ[in, pressureInputSingleP];
	(* Expand the input to be a list *)
	listedInput = If[singletonInputQ, {in}, in];

	(* Get our prediction model from cloud file *)
	predictionModel = airBubbleLikelihoodPredictionModel["Memoization"];

	(* If no prediction model (MM<13.2), we just return Null for every input *)
	If[NullQ[predictionModel],
		If[MatchQ[in,pressureInputSingleP],
			Return[Null],
			Return[ConstantArray[Null,Length[in]]]
		]
	];

	(* Extract the raw pressure traces (without time) and strip units and convert to Real (instead of Integer) *)
	pressuresRaw = Map[
		If[NullQ[#],
			Null,
			N[Unitless[#[[All,2]]]]
		]&,
		listedInput
	];

	(* Drop the first 40 points to eliminate bad bubble calls based on initial pressure fluctuations (unless there are fewer than 40 data points to start with) *)
	(* The model requires 1000 points, so we have to pad to 1000 total points with zeroes *)
	pressuresTrimmedAndPadded = Map[
		Which[
			NullQ[#],Null,
			Length[#] < 40, PadLeft[#, 1000, 0.][[;; 1000]],
			True,PadLeft[Drop[#, 40], 1000, 0.][[;; 1000]]
		]&,
		pressuresRaw
	];

	(* Remove the Null inputs (this happens when we have a list of input and pressure data somehow were missing for some of the inputs) *)
	nullPressurePositions = Position[pressuresTrimmedAndPadded,Null,1];
	pressuresTrimmedAndPaddedNoNull = Delete[pressuresTrimmedAndPadded,nullPressurePositions];

	(* Make predictions *)
	(* The model's input format requires addition of an extra list around each list of pressures *)
	(* The return value also has an extra layer of list that we will flatten out *)
	(* Note for this overload, Cache/Upload options do not make any difference *)
	airBubbleLikelihoodPredictions = If[MatchQ[pressuresTrimmedAndPaddedNoNull,{}],
		(* Do not call our prediction model if we don't have valid data *)
		{},
		Flatten[predictionModel[List/@pressuresTrimmedAndPaddedNoNull]] * 100 Percent
	];

	(* Insert back the Null position *)
	airBubbleLikelihoodPredictionsInserted = Fold[Insert[#1, Null, #2]&, airBubbleLikelihoodPredictions, nullPressurePositions];

	(* Return a single value if we are given a single input *)
	If[singletonInputQ,airBubbleLikelihoodPredictionsInserted[[1]],airBubbleLikelihoodPredictionsInserted]

];

(* Pressure Overload *)
AnalyzeAirBubbleLikelihood[in:ListableP[({PressureP..}|Null)], ops: OptionsPattern[]] := Module[
	{singletonInputQ, listedInput, predictionModel, pressuresRaw, pressuresTrimmedAndPadded, nullPressurePositions, pressuresTrimmedAndPaddedNoNull, airBubbleLikelihoodPredictions, airBubbleLikelihoodPredictionsInserted},

	(* See if we have singleton input and this will decide our final output *)
	singletonInputQ = MatchQ[in, {PressureP..}];
	(* Expand the input to be a list *)
	listedInput = If[singletonInputQ, {in}, in];

	(* Get our prediction model from cloud file *)
	predictionModel = airBubbleLikelihoodPredictionModel["Memoization"];

	(* If no prediction model (MM<13.2), we just return Null for every input *)
	(* If no prediction model (MM<13.2), we just return Null for every input *)
	If[NullQ[predictionModel],
		If[MatchQ[in,{PressureP..}],
			Return[Null],
			Return[ConstantArray[Null,Length[in]]]
		]
	];
	(* Extract the raw pressure traces (without time) and strip units and convert to Real (instead of Integer) *)
	pressuresRaw = N[Unitless[listedInput]];

	(* Drop the first 40 points to eliminate bad bubble calls based on initial pressure fluctuations (unless there are fewer than 40 data points to start with) *)
	(* The model requires 1000 points, so we have to pad to 1000 total points with zeroes *)
	pressuresTrimmedAndPadded = Map[
		Which[
			NullQ[#],Null,
			Length[#] < 40, PadLeft[#, 1000, 0.][[;; 1000]],
			True,PadLeft[Drop[#, 40], 1000, 0.][[;; 1000]]
		]&,
		pressuresRaw
	];

	(* Remove the Null inputs (this happens when we have a list of input and pressure data somehow were missing for some of the inputs) *)
	nullPressurePositions = Position[pressuresTrimmedAndPadded,Null,1];
	pressuresTrimmedAndPaddedNoNull = Delete[pressuresTrimmedAndPadded,nullPressurePositions];

	(* Make predictions *)
	(* The model's input format requires addition of an extra list around each list of pressures *)
	(* The return value also has an extra layer of list that we will flatten out *)
	(* Note for this overload, Cache/Upload options do not make any difference *)
	airBubbleLikelihoodPredictions = If[MatchQ[pressuresTrimmedAndPaddedNoNull,{}],
		(* Do not call our prediction model if we don't have valid data *)
		{},
		Flatten[predictionModel[List/@pressuresTrimmedAndPaddedNoNull]] * 100 Percent
	];

	(* Insert back the Null position *)
	airBubbleLikelihoodPredictionsInserted = Fold[Insert[#1, Null, #2]&, airBubbleLikelihoodPredictions, nullPressurePositions];

	(* Return a single value if we are given a single input *)
	If[singletonInputQ,airBubbleLikelihoodPredictionsInserted[[1]],airBubbleLikelihoodPredictionsInserted]

];
