(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* -------------------------------------- *)
(* --- Main Definitions and Variables --- *)
(* -------------------------------------- *)

thermalAbsorbanceUnits={Celsius,AbsorbanceUnit};
thermalFluoresenceUnits={Celsius,RFU};
thermalArbitraryUnits={Celsius,ArbitraryUnit};

meltingCurveDefaultUnits={Celsius,ArbitraryUnit};

(* Singleton input *)
inputAnalyzeMeltingPointP=Alternatives[
	ObjectP[Object[Data, MeltingCurve]],
	ObjectP[Object[Data, FluorescenceThermodynamics]],
	ObjectP[Object[Data, qPCR]],
	CoordinatesP,
	QuantityCoordinatesP[thermalAbsorbanceUnits],
	QuantityCoordinatesP[thermalFluoresenceUnits],
	QuantityCoordinatesP[thermalArbitraryUnits]
];

inputCoordsAnalyzeMeltingPointP=Alternatives[
	CoordinatesP,
	QuantityCoordinatesP[thermalAbsorbanceUnits],
	QuantityCoordinatesP[thermalFluoresenceUnits],
	QuantityCoordinatesP[thermalArbitraryUnits]
];

(* Single set of data objects each containing one data point *)
inputAnalyzeMeltingPointObjectSetP=Alternatives[
	{ObjectP[Object[Data, MeltingCurve]]..},
	{ObjectP[Object[Data, FluorescenceThermodynamics]]..}
];

(* Assign MeltingCurve or CoolingCurve based on the temperature change direction, assuming the data is already sorted by temperature *)
resolveRawDataSetField[xy_]:=If[xy[[1,1]]<xy[[-1,1]], MeltingCurve, CoolingCurve];

(* List input *)
listInputAnalyzeMeltingPointP=Alternatives[
	{inputAnalyzeMeltingPointP..},
	{inputAnalyzeMeltingPointObjectSetP..}
];

(* standard melting DataSets *)
standardMeltingDataSets={
	MeltingCurve, MeltingCurves, CoolingCurve,
	SecondaryMeltingCurve, SecondaryCoolingCurve,
	TertiaryMeltingCurve, TertiaryCoolingCurve,
	QuaternaryMeltingCurve, QuaternaryCoolingCurve,
	QuinaryMeltingCurve, QuinaryCoolingCurve,
	AggregationCurve, SecondaryAggregationCurve,
	MeltingCurve3D, CoolingCurve3D,
	SecondaryMeltingCurve3D, SecondaryCoolingCurve3D,
	TertiaryMeltingCurve3D, TertiaryCoolingCurve3D,
	QuaternaryMeltingCurve3D, QuaternaryCoolingCurve3D,
	QuinaryMeltingCurve3D, QuinaryCoolingCurve3D,
	AggregationCurve3D,DataPointsDLSAverageZDiameter,
	DataPointsSLSMolecularWeights
};


(* Custom Patterns *)
nestedFieldQ[arg:{_Symbol..}|{_Field..}]:=False;
nestedFieldQ[arg_Symbol]:=True;
nestedFieldQ[head_Symbol[arg_]]:=nestedFieldQ[arg];
nestedFieldQ[_]:=False;
nestedFieldP=_?nestedFieldQ|_Field|_Symbol;

(* Patterns of valid temperature 2D coordinates *)
temperature2DCoordinatesP=Alternatives[
	{{UnitsP["Temperature"], _} ..}
];

(* Patterns of valid temperature 3D coordinates *)
temperature3DCoordinatesP=Alternatives[
	{{UnitsP["Temperature"], _, _} ..}
];

(* Patterns of valid temperature list *)
temperatureListP=Alternatives[
	{UnitsP["Temperature"] ..}
];

(* Patterns of valid response list *)
responseListP=Alternatives[
	{UnitsP[AbsorbanceUnit] ..},
	{UnitsP[RFU] ..},
	{UnitsP[ArbitraryUnit] ..}
];

(* The default temperature field names for different type of data objects *)
DefaultTemperatureField=<|
	Object[Data, AbsorbanceIntensity]->Temperature
|>;

(* The response temperature field names for different type of data objects *)
DefaultResponseField=<|
	Object[Data, AbsorbanceIntensity]->Absorbance
|>;

(* -------------------------- *)
(* --- Option Definitions --- *)
(* -------------------------- *)

DefineOptions[AnalyzeMeltingPoint,
	Options :> {
		IndexMatching[
      		IndexMatchingInput->"main input",
			{
				OptionName -> Domain,
				Default -> Automatic,
				Description -> "Any data points whose x-value lies outside of the specified domain interval will be excluded from analysis.",
				ResolutionDescription -> "If Automatic, it includes all points.",
				AllowNull -> False,
				Widget -> {
					"Min" -> Alternatives[
						Widget[Type->Quantity, Pattern:>GreaterEqualP[0 Kelvin], Units->Alternatives[Kelvin,Celsius]],
						Widget[Type->Number, Pattern:>GreaterEqualP[0]]
					],
					"Max" -> Alternatives[
						Widget[Type->Quantity, Pattern:>GreaterEqualP[0 Kelvin], Units->Alternatives[Kelvin,Celsius]],
						Widget[Type->Number, Pattern:>GreaterEqualP[0]]
					]
				}
			},
			{
				OptionName -> Range,
				Default -> Automatic,
				Description -> "Any data points whose y-value lies outside of the specified range interval will be excluded from analysis.",
				ResolutionDescription -> "If Automatic, it includes all points.",
				AllowNull -> False,
				Widget -> {
					"Min" -> Alternatives[
						Widget[Type->Quantity, Pattern:>GreaterEqualP[0 Kelvin], Units->Alternatives[Kelvin,Celsius]],
						Widget[Type->Quantity, Pattern:>GreaterEqualP[0 ArbitraryUnit], Units->ArbitraryUnit],
						Widget[Type->Number, Pattern:>GreaterEqualP[0]]
					],
					"Max" -> Alternatives[
						Widget[Type->Quantity, Pattern:>GreaterEqualP[0 Kelvin], Units->Alternatives[Kelvin,Celsius]],
						Widget[Type->Quantity, Pattern:>GreaterEqualP[0 ArbitraryUnit], Units->ArbitraryUnit],
						Widget[Type->Number, Pattern:>GreaterEqualP[0]]
					]
				}
			},
			{
	    	(* Min/max pattern for quantity widget based on what our instrument Object[Instrument,Spectrophotometer,Calvin] can record *)
	      		OptionName -> Wavelength,
	      		Default -> Null,
	      		Description -> "For 3D melting/cooling curves, this option allows for the specification of the source wavelength. The sum of absorbance values across the specified wavelengths is used to calculate the melting point. A single wavelength, a list of wavelengths, a range of wavelengths, All, or Automatic can be specified. The Automatic option slices at 260 +/- 10 nm for DNA/RNA materials, and 280 +/- 10nm for all other material types. This option is not applicable for 2D melting/cooling curves where the source wavelength is fixed.",
	      		AllowNull -> True,
	      		Widget -> Alternatives[
	        		"Single Value"->Alternatives[
						"Quantity"->Widget[Type->Quantity, Pattern:>RangeP[190 Nanometer, 900 Nanometer], Units->Nanometer],
						"Number"->Widget[Type->Number, Pattern:>RangeP[190, 900]]
					],
	        		"Span"->Alternatives[
						"Quantity"->Span[
		          			Widget[Type->Quantity,Pattern:>RangeP[190 Nanometer, 900 Nanometer],Units->Nanometer],
		          			Widget[Type->Quantity,Pattern:>RangeP[190 Nanometer, 900 Nanometer],Units->Nanometer]
		        		],
						"Number"->Span[
		          			Widget[Type->Number,Pattern:>RangeP[190, 900]],
		          			Widget[Type->Number,Pattern:>RangeP[190, 900]]
		        		]
					],
					{
						"Numerator" -> Alternatives[
							"Quantity"->Widget[Type->Quantity, Pattern:>RangeP[190 Nanometer, 900 Nanometer], Units->Nanometer],
							"Number"->Widget[Type->Number, Pattern:>RangeP[190, 900]]
						],
						"Denominator" -> Alternatives[
							"Quantity"->Widget[Type->Quantity, Pattern:>RangeP[190 Nanometer, 900 Nanometer], Units->Nanometer],
							"Number"->Widget[Type->Number, Pattern:>RangeP[190, 900]]
						]
					},
	        		Widget[Type->Enumeration, Pattern:>Alternatives[All,Automatic]]
	      		]
			},
			{
				OptionName -> Method,
				Default -> Automatic,
				Description -> "Method used to determine melting point. Midpoint method defines melting point as midpoint between the maximum and minimum of the curve. InflectionPoint method defines melting temperature as the inflection point of the curve. Derivative method also defines melting point as the inflection of the curve, but also returns the melting transition temperature range.",
				ResolutionDescription -> "In case of analyzing fluoresenceSpectraData using the instrument MultimodeSpectrophotometer, Derivative is chosen, otherwise MidPoint.",
				AllowNull -> False,
				Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[MidPoint,InflectionPoint,Derivative]]
			},
			{
				OptionName -> DataProcessing,
				Default -> Smooth,
				Description -> "Method used to clean the data before calculating the melting point. If Smooth, data is smoothed by a Gaussian filter. If Fit, data points are fitted to a sigmoid and the melting point is calculated from the fitted sigmoid.",
				AllowNull -> False,
				Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Smooth,Fit]]
			},
			{
				OptionName -> SmoothingRadius,
				Default -> 5,
				Description -> "Radius for GaussianFilter used to smooth melting and cooling curves.",
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[Type->Quantity, Pattern:>GreaterEqualP[0 Kelvin], Units->Alternatives[Kelvin,Celsius]],
					Widget[Type->Number, Pattern:>GreaterEqualP[0,1]]
				]
			},
			{
				OptionName -> DataSet,
				Default -> Automatic,
				Description -> "The fields in the input objects where the melting curves are located.",
				ResolutionDescription -> "When using protocol or data object input, the default field references are determined by input object type.",
				AllowNull -> False,
				Widget -> Alternatives[
					"Single Custom Field" -> Widget[Type->Expression, Pattern:>None|nestedFieldP|Null, Size->Line],
					"Custom Field List" -> Adder[Widget[Type->Expression, Pattern:>None|nestedFieldP, Size->Line] ],
					"Standard Fields" -> Adder[Widget[
						Type->Expression,
						Pattern:>Alternatives[Join[All, standardMeltingDataSets]],
						Size -> Line
					]]
				]
			},
			{
	      		OptionName -> DataSetTransformationFunction,
	      		Default -> Automatic,
	      		Description -> "A pure function applied to pre-process melting curve data.",
	      		ResolutionDescription -> "By default, no transformation is applied to 2D data and Max Height to 3D data.",
	      		AllowNull -> False,
	      		Widget -> Alternatives[
					"Single Custom Field" -> Widget[Type->Expression, Pattern:>Automatic|None|_Function|Sum|BarycentricMean|GroupByWavelength|MaxHeight|Ratio, Size->Line],
					"Custom Field List" -> Adder[ Widget[Type->Expression, Pattern:>Automatic|None|_Function|Sum|BarycentricMean|GroupByWavelength|MaxHeight|Ratio, Size-> Line] ]
				]
      		},
			{
				OptionName -> TemperatureDataSet,
				Default -> Automatic,
				Description -> "The fields in the input objects where the temperature data are located.",
				AllowNull -> False,
				Widget -> Widget[Type->Expression, Pattern:>nestedFieldP|Null, Size->Line]
			},
			{
				OptionName -> TemperatureTransformationFunction,
				Default -> None,
				Description -> "A pure function applied to pre-process melting curve data.",
				ResolutionDescription -> "By default, no transformation is applied to 2D data and Max Height to 3D data.",
				AllowNull -> False,
				Widget -> Widget[Type->Expression, Pattern:>None|_Function, Size-> Line]
			},
			{
				OptionName -> ResponseDataSet,
				Default -> Automatic,
				Description -> "The fields in the input objects where the melting data are located.",
				AllowNull -> False,
				Widget -> Widget[Type->Expression, Pattern:>nestedFieldP|Null, Size->Line]
			},
			{
				OptionName -> ResponseTransformationFunction,
				Default -> None,
				Description -> "A pure function applied to pre-process melting curve data.",
				ResolutionDescription -> "By default, no transformation is applied to 2D data and Max Height to 3D data.",
				AllowNull -> False,
				Widget -> Widget[Type->Expression, Pattern:>None|_Function, Size-> Line]
			},
			{
				OptionName -> MeltingOnset,
				Default -> False,
  				Description -> "If True, the melting onset temperature is calculated for all curves specified using DataSet.",
  				AllowNull -> False,
  				Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[True,False]]
			},
			{
				OptionName -> MeltingOnsetPercent,
				Default -> 50. Percent,
				Description -> "The aggregation onset is estimated be at a temperature which has the intensity equal to this percent times the intensity at the melting temperature.",
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Quantity, Pattern:>RangeP[0 Percent, 100 Percent], Units -> Percent]
				]
			},
			{
				OptionName -> StartPointThreshold,
				Default -> 5. Percent,
				Description -> "The value that defines the beginning of the melting process. When the measured fraction of light intensity through the sample exceeds this value, it marks the onset of melting and the temperature at this point is reported as the PharmacopeiaStartPointTemperature.",
				AllowNull -> False,
				Widget -> Widget[Type -> Quantity, Pattern:>RangeP[0 Percent, 25 Percent], Units -> Percent]
			},
			{
				OptionName -> MeniscusPointThreshold,
				Default -> 40. Percent,
				Description -> "The value that defines the middle of the melting process. When the measured fraction of light intensity through the sample exceeds this value, the temperature at this point is reported as the PharmacopeiaMeniscusPointTemperature.",
				AllowNull -> False,
				Widget -> Widget[Type -> Quantity, Pattern:>RangeP[1 Percent, 99 Percent], Units -> Percent]
			},
			{
				OptionName -> ClearPointSlopeThreshold,
				Default -> 0.004 Percent / Second,
				Description -> "The value that defines the endpoint of the melting process. Near the end of the melting process, when the slope of the fraction of light intensity at the time falls below this threshold, the temperature at this point is reported as the PharmacopeiaClearPointTemperature.",
				AllowNull -> False,
				Widget -> Widget[Type -> Quantity, Pattern:>RangeP[0 Percent / Second, 0.25 Percent / Second], Units -> Percent / Second]
			},
			{
				OptionName -> PlotType,
				Default -> MeltingPoint,
				Description -> "Data to display on the preview plot.",
				AllowNull -> False,
				Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[All,MeltingPoint,Alpha,Derivative,DerivativeOverlay]]
			},
			{
				OptionName -> ApplyAll,
				Default -> False,
				Description -> "If True, applies first set of resolved options to all remaining data sets.",
				AllowNull -> False,
				Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[True,False]],
				Category -> "Hidden"
			}
		],
		OutputOption,
		UploadOption,
		AnalysisTemplateOption
	}
];

(* ------------------------------------- *)
(* --- Warning and Error Definitions --- *)
(* ------------------------------------- *)

Error::NoPacketsInInput="No packets were given in input, please input a protocol with valid data objects.";
Error::InvalidTransformedTemperature="The transformed temperature for input `1` is not a valid list of temperature values with proper units. Please check if the transformation in TemperatureTransformationFunction preserves the temperature units.";
Error::InvalidTransformedResponse="The transformed response for input `1` is not a valid list of thermal response values with proper units. Please check if the transformation in ResponseTransformationFunction preserves the valid response units; AbsorbanceUnit, RFU, or ArbitraryUnit.";
Error::InvalidDataSet="The DataSet `2` of input `1` is not a correct set of data points with temperature units for the x-axis. Please make sure that this field is not Null.";
Error::DataSetDoesntExist="The DataSet `1` was not found in the data packet `2`. Please check if the spelling is correct or select Automatic.";
Error::ObjectDoesNotExist="The object(s), `1`, can not be found in the database. Please inspect the object to ensure that the object exist in the database.";
Error::InvalidTransformationFunction="The transformation function for the dataset `2` of input `1` does not reduce to a dataset with temperature as the x-coordinate. Please double check that a linear transformation is used. ";
Error::NonMatchingTransformationFunction="The length of the transformation functions for the input `1` does not match its dataset length. Please use None for no transformation.";
Error::InvalidTemperatureResponse="The temperature or response field in the input `1` is Null. The default field might not be known for this data object. Please provide a valid name for the fields TemperatureDataSet and ResponseDataSet.";
Error::InvalidTemperatureDataSet="The temperature field in the input `1` is either not found or does not have the temperature units. Please provide a valid field name with TemperatureDataSet option.";
Error::InvalidResponseDataSet="The response field in the input `1` is either not found or does not have the response units (AbsorbanceUnit, RFU, or ArbitraryUnit). Please provide a valid field name with ResponseDataSet option.";
Error::NoMeltingCurveData="The object or data at position `1` do not have coordinates suitable for melting point analysis. Please ensure that at least one field in the data object from the following list is populated, `2`, or that the input coordinates contain x-coordinates with temperature units and y-coordinates with AbsorbanceUnit, RFU, or ArbitraryUnit units.";
Error::NoqPCRMeltingCurvesData="The qPCR data objects `1` do not have coordinates suitable for melting point analysis. Please ensure that the MeltingCurves field is populated with x-coordinates with temperature units and y-coordinates with AbsorbanceUnit, RFU, or ArbitraryUnit units.";
Error::InvalidAssayTypeForDLSProtocol="The protocol `1` needs to have the AssayType MeltingCurve to run the AnalyzeMeltingPoint function.";
Warning::MeniscusPointThresholdUnreached="The meniscus point was not found in `1` because the melting curve did not cross the MeniscusPointThreshold of `2`.";
Warning::StartPointThresholdUnreached="The start point was not found in `1` because the melting curve did not cross the StartPointThreshold of `2`.";
Warning::ClearPointSlopeThresholdUnreached="The clear point was not found in `1` because the slope of the melting curve did not cross the ClearPointSlopeThreshold of `2`.";
Warning::ObjectDoesNotContain3DCurves="The provided object/protocol does not contain data for 3D melting/cooling curves. Please provide only Object[Protocol, UVMelting] and Object[Data, MeltingCurve] that contain 3D data. Attempting to use 2D curves for this analysis.";
Warning::AllWavelengthsOutOfRange="All of the specified wavelength values specified are out of the wavelength range that the data was acquired with. Attempting to use 2D curves for this analysis. Please modify the Wavelength option to values in the range from `1` nm to `2` nm.";
Warning::SomeWavelengthsOutOfRange="At least one of the specified wavelength values is not in the wavelength range that the data has been acquired with. These wavelength values are being ignored in the analysis. The available wavelength range in this data set is from `1` nm to `2` nm.";
Warning::MeltingPointOutOfDomain="Warning: MeltingPoint is out of input Domain.";
Warning::NoDataInDomainRange="No data points remain after applying Domain and Range filtering.";
Warning::MeltingPointBadData="The `1` `2` are not monotonically increasing or decreasing. The resulting melting point may be inaccurate.";
Warning::UncertainMeltingOnset="The onset value determined for `1` might not be accurate. This is likely related to the shape of the curve which can be deviated from sigmoid-like.";
Warning::IncompatibleTransformation="A 3D transformation `1` is selected for a 2D DataSet `2`. The transformation is switched to None.";
Warning::UnusedTemperatureTransformation="The TemperatureTransformationFunction is used if TemperatureDataSet and ResponseDataSet are not Null. Please specify DataSetTransformationFunction if you wish to apply a transformation to the DataSet or specify TemperatureDataSet and ResponseDataSet if you wish to set the field that the data points should be taken from.";
Warning::UnusedResponseTransformation="The ResponseTransformationFunction is used if TemperatureDataSet and ResponseDataSet are not Null. Please specify DataSetTransformationFunction if you wish to apply a transformation to the DataSet or specify TemperatureDataSet and ResponseDataSet if you wish to set the field that the data points should be taken from.";
Warning::UnusedDataSet="The DataSet is set to Null if the temperature and response datasets are not Null or if the input pattern is {{object1,object2,..}..}. Please specify TemperatureDataSet and ResponseDataSet if you wish to set the field that the data points should be taken from.";
Warning::UnusedDataSetTransformation="The DataSetTransformationFunction is set to Null if the temperature and response datasets are not Null or if the input pattern is {{object1,object2,..}..}. Please specify TemperatureDataSet and ResponseDataSet and their TransformationFunction if you wish to set the field that the data points should be taken from.";
Warning::FitIssue="The NonlinearModelFit produced errors in fitting a logistic function to the curve `1`. \"Gradient\" method will be passed to NonLinearModelFit to improve the fit results. Please consider increasing the number of data points in the experiment by changing the temperature resolution.";

(* ---------------------- *)
(* --- Overload Functions --- *)
(* ---------------------- *)

(*convert protocol to data*)
AnalyzeMeltingPoint[
	myProtocol:ObjectP[{
		Object[Protocol, UVMelting],
		Object[Protocol, ThermalShift],
		Object[Protocol, DynamicLightScattering],
		Object[Protocol, FluorescenceThermodynamics],
		Object[Protocol, MeasureMeltingPoint]
	}],
	ops:OptionsPattern[AnalyzeMeltingPoint]
]:=Module[{dataObjects, assayType, matchedDataObj},

	If[MatchQ[myProtocol, ObjectP[Object[Protocol, DynamicLightScattering]]],

		(* if the protocol is DynamicLightScattering, check both Data and AssayType*)
		{dataObjects, assayType} = Download[myProtocol, {Data, AssayType}];
		If[!MatchQ[assayType, MeltingCurve],
			Message[Error::InvalidAssayTypeForDLSProtocol, myProtocol];
			Return[$Failed]
		],

		(* for other protocols, only check Data*)
		dataObjects = Download[myProtocol, Data]
	];

	(*filter out unqualified data objects*)
	matchedDataObj = Switch[myProtocol,

		ObjectP[Object[Protocol, FluorescenceThermodynamics]],
			Cases[dataObjects, ObjectP[Object[Data,FluorescenceThermodynamics]]],

		ObjectP[Object[Protocol, MeasureMeltingPoint]],
			Cases[dataObjects, ObjectP[Object[Data, MeltingPoint]]],

		_,
			Cases[dataObjects, ObjectP[Object[Data,MeltingCurve]]]
	];

	If[MatchQ[matchedDataObj, {}],
		Message[Error::NoPacketsInInput];
		Return[$Failed]
	];

	AnalyzeMeltingPoint[Flatten@matchedDataObj,ops]
];


(*Main function*)
DefineAnalyzeFunction[
	AnalyzeMeltingPoint,
	<|
		InputData -> Alternatives[
			ListableP[inputAnalyzeMeltingPointP],
			{ObjectP[Object[Data, AbsorbanceIntensity]]..},
			ListableP[ObjectP[Object[Data, MeltingPoint]]]
		]
	|>,
	{
		Batch[downloadInputsAnalyzeMeltingPoint],
		resolveInputsAnalyzeMeltingPoint,
		resolveOptionsAnalyzeMeltingPoint,
		computeAnalyzeMeltingPoint,
		Batch[previewAnalyzeMeltingPoint]
	}
];


(*overload: the inputData is a list of coordinates or quantity arrays*)
downloadInputsAnalyzeMeltingPoint[
	KeyValuePattern[{
		UnresolvedInputs -> KeyValuePattern[{
			InputData -> inputData:ListableP[inputCoordsAnalyzeMeltingPointP]
		}]
	}]
]:=Module[{packetsInTotal},

	packetsInTotal = convertCoordsToPackets[inputData];

	<|
		ResolvedInputs-> <|
			DataAsPackets -> packetsInTotal
		|>,
		Batch->True
	|>
];

(*overload: the inputData is a list of Object[Data, AbsorbanceIntensity]*)
downloadInputsAnalyzeMeltingPoint[
	KeyValuePattern[{
		UnresolvedInputs -> KeyValuePattern[{
			InputData -> inputData:{{ObjectP[Object[Data, AbsorbanceIntensity]]..}..}
		}],
		ResolvedOptions -> resolvedOptions_,
		Batch->True
	}]
]:=Module[{downloadFields, totalDownloads, packetsInTotal},

	downloadFields = resolveDownloadFields[inputData, resolvedOptions];

	(*return $Failed if there is error when resolving the field names*)
	If[MatchQ[downloadFields, $Failed], Return[$Failed]];

	totalDownloads = Quiet[Download[inputData, downloadFields]];

	(*Convert downloads to packets*)
	packetsInTotal = convertMixedDownloadsToPackets[totalDownloads, inputData, downloadFields];

	(*return $Failed if there is error when converting to packets*)
	If[MatchQ[packetsInTotal, $Failed], Return[$Failed]];

	<|
		ResolvedInputs-> <|
			DataAsPackets -> packetsInTotal
		|>,
		Batch->True
	|>

];

(*overload: the input data is other data objects*)
downloadInputsAnalyzeMeltingPoint[
	KeyValuePattern[{
		UnresolvedInputs -> KeyValuePattern[{
			InputData -> inputData:ListableP[Alternatives[
				ObjectP[Object[Data, MeltingCurve]],
				ObjectP[Object[Data, FluorescenceThermodynamics]],
				ObjectP[Object[Data, qPCR]],
				ObjectP[Object[Data, MeltingPoint]]
			]]
		}]
	}]
]:=Module[{protocol, instrument, downloadFields, totalDownloads, packetsInTotal},

	downloadFields = If[MatchQ[inputData, Alternatives[{ObjectP[Object[Data, MeltingCurve]]..},{ObjectP[Object[Data, MeltingPoint]]..}]],
		(*for MeltingCurve, the download fields depend on both protocol and instrument*)
		{protocol, instrument} = Quiet[Download[First[inputData], {Protocol, Instrument}]];
		resolveDownloadFields[inputData, protocol, instrument],

		(*for other types, only Protocol is needed*)
		protocol = Quiet[Download[First[inputData], Protocol]];
		resolveDownloadFields[inputData, protocol]
	];

	(*return $Failed if there is error when resolving the field names*)
	If[MatchQ[downloadFields, $Failed], Return[$Failed]];

	(*bulk download all fields that will be used in the analysis*)
	totalDownloads = Quiet[
		Check[
			Download[inputData, downloadFields],
			Message[Error::ObjectDoesNotExist, inputData]; Return[$Failed],
			Download::ObjectDoesNotExist
		],
		{Download::FieldDoesntExist, Download::MissingField}
	];

	(*Convert downloads to packets*)
	packetsInTotal = convertMixedDownloadsToPackets[totalDownloads, inputData, downloadFields];

	(*return $Failed if there is error when converting to packets*)
	If[MatchQ[packetsInTotal, $Failed], Return[$Failed]];

	<|
		ResolvedInputs-> <|
			DataAsPackets -> packetsInTotal
		|>,
		Batch->True
	|>
];


(*convert to packet when the input is coordinates or quantity array*)
convertCoordsToPackets[inputCoords_]:= Replace[
		inputCoords,
		{
			xy:CoordinatesP|QuantityCoordinatesP[] :> <|
				Object -> "Raw Input",
				Type -> Object[Data, FluorescenceThermodynamics],
				Name -> Null,
				Wavelength -> Null,
				(* If the temperature of the first entry in the list is less than the temperature of the last entry in the list, we have a melting curve, else it is a cooling curve *)
				resolveRawDataSetField[xy] -> xy,
				(* Get the complement curve of the previous curve *)
				PeakWavelength -> 280 Nanometer
			|>,
			qa:QuantityCoordinatesP[meltingCurveDefaultUnits] :> <|
				Object -> "Raw Input",
				Type -> Object[Data, MeltingCurve],
				Name -> Null,
				Wavelength -> Null,
				(* If the temperature of the first entry in the list is less than the temperature of the last entry in the list, we have a melting curve, else it is a cooling curve *)
				resolveRawDataSetField[qa] -> qa,
				(* Get the complement curve of the previous curve *)
				PeakWavelength -> 280 Nanometer
			|>
		},
		{1}
];

(*overload: if the input is list of list data objects, and each data object contains a single data point, resolve the download fields with options*)
resolveDownloadFields[inputData:{{ObjectP[Object[Data, AbsorbanceIntensity]]..}..}, ops_]:=Module[
	{
		lookupField,allInputTypes,temperatureFields,responseFields,resolvedTemperatureFields,resolvedResponseFields,
		validTemperatureResponseQ,invalidTemperatureResponseIndices
	},

	(* <<< Reading Temperature and Response Dataset Fields >>> *)

	(* Searches for type in table, returning None if type is none or not found *)
	lookupField[table_Association,type:None|TypeP[]]:=If[KeyExistsQ[table,type],
		Lookup[table,type],
		Null
	];

	(* List of objects use Type of first object, assuming that all objects have the same Type *)
	allInputTypes=(First[#][Type])&/@inputData;

	(* Object fields that store temperature information *)
	{temperatureFields,responseFields}=Lookup[ops,{TemperatureDataSet,ResponseDataSet}];

	(*both fields have the same length as input data*)
	temperatureFields = If[Length[ToList[temperatureFields]]===1,
		ConstantArray[First[ToList[temperatureFields]], Length[allInputTypes]],
		temperatureFields
	];

	responseFields = If[Length[ToList[responseFields]]===1,
		ConstantArray[First[ToList[responseFields]], Length[allInputTypes]],
		responseFields
	];

	(* Resolve temperature fields based on user supplied options *)
	resolvedTemperatureFields=MapThread[
		Which[
			(* If Automatic, look for a default field. *)
			MatchQ[#1,Automatic], lookupField[DefaultTemperatureField,#2],
			(* If not Automatic, it has been explicitly specified *)
			MatchQ[#1,Except[Automatic]], #1
		]&,
		{temperatureFields,allInputTypes}
	];

	(* Resolve response fields based on user supplied options *)
	resolvedResponseFields=MapThread[
		Which[
			(* If Automatic, look for a default field. *)
			MatchQ[#1,Automatic], lookupField[DefaultResponseField,#2],
			(* If not Automatic, it has been explicitly specified *)
			MatchQ[#1,Except[Automatic]], #1
		]&,
		{responseFields,allInputTypes}
	];

	(* None of the {temperatureFields,responseFields} with this type of input shall be Null *)
	validTemperatureResponseQ=MapThread[
		(* Both fields are either automatic or customized and should not be Null or {} *)
		!MatchQ[{#1,#2},( {Null|{},_} | {_,Null|{}} ) ]&,
		{resolvedTemperatureFields,resolvedResponseFields}
	];

	(* The index of allInputs that do not have valid temperature and response dataset *)
	invalidTemperatureResponseIndices=Position[validTemperatureResponseQ,False];

	(* If not gathering tests, exit with an error if the fields for either temperature or response not found *)
	If[Count[validTemperatureResponseQ,False]>0,
		Message[Error::InvalidTemperatureResponse,Flatten[invalidTemperatureResponseIndices]];
		Message[Error::InvalidOption,{TemperatureDataSet,ResponseDataSet}];
		Return[$Failed]
	];

	Transpose[{
		ConstantArray[Type, Length[allInputTypes]],
		ConstantArray[Name, Length[allInputTypes]],
		resolvedTemperatureFields,
		resolvedResponseFields
	}]
];

(*overload: if the input is a list of other data objects, resolve the download fields*)
resolveDownloadFields[inputData_, protocol_, instrument___]:=Module[
	{
		commonFields, fieldsForDLS, fieldsForSLS
	},

	commonFields = {Object,Type,Name,StaticLightScatteringExcitation,ExcitationWavelength,Instrument,ID,SamplesIn,SamplesIn[PolymerType]};
	fieldsForDLS = {
		DLSHeatingCurve, SecondaryDLSHeatingCurve, TertiaryDLSHeatingCurve,
		DLSCoolingCurve, SecondaryDLSCoolingCurve, TertiaryDLSCoolingCurve
	};
	fieldsForSLS = {EstimatedMolecularWeights};

	(*if input data type is MeltingPoint, the data fields are different from others*)
	If[MatchQ[inputData, {ObjectP[Object[Data, MeltingPoint]]..}],
		Return[{Object, Type, Name, Instrument, CapillaryVideoFile, MeltingCurve, StartTemperature, EndTemperature, TemperatureRampRate, MeasurementMethod}]
	];

	(*for other data types, melting data fields are different among protocols. standardMeltingDataSets is a general list that covers all cases. *)
	If[MatchQ[inputData, {ObjectP[Object[Data, MeltingCurve]]..}] && MatchQ[protocol, ObjectP[Object[Protocol, DynamicLightScattering]]],

		(*if the inputData is Object[Data, MeltingCurve], the download fields depend on the instrument*)
		Switch[instrument,
			ObjectP[Object[Instrument, MultimodeSpectrophotometer]], Join[commonFields, standardMeltingDataSets],
			ObjectP[Object[Instrument, DLSPlateReader]], Join[commonFields, fieldsForDLS, fieldsForSLS]
		],

		(*if the inputData is other types, the download fields depends on the protocol*)
		Switch[protocol,
			ObjectP[Object[Protocol, UVMelting]], Join[commonFields, standardMeltingDataSets],
			ObjectP[Object[Protocol, FluorescenceThermodynamics]], Join[commonFields, standardMeltingDataSets],
			ObjectP[Object[Protocol, ThermalShift]], Join[commonFields, standardMeltingDataSets],
			ObjectP[Object[Protocol, qPCR]], {Object,Type,Name,Instrument,ID, MeltingCurves},
			_, Join[commonFields, standardMeltingDataSets]
		]
	]

];


(* convert downloaded list of list data to a packet*)
(* overload: Object[Data, MeltingPoint]*)
convertMixedDownloadsToPackets[bulkDownload_, inputData : {ObjectP[Object[Data, MeltingPoint]]..}, ___] := createAssociationList[
	{Object, Type, Name, Instrument, CapillaryVideoFile, MeltingCurve, StartTemperature, EndTemperature, TemperatureRampRate, MeasurementMethod},
	Transpose[bulkDownload]
];


(* overload: Object[Data, qPCR] *)
convertMixedDownloadsToPackets[bulkDownload_, inputData:{ObjectP[Object[Data, qPCR]]..}, ___]:=Module[
	{
		myPackets, noMeltingCurvesIndices, inputDataObjects, noMeltingCurvesObjects,
		meltingCurvePackets
	},

	myPackets = createAssociationList[
		{Object,Type,Name,Instrument,ID, MeltingCurves},
		Transpose[bulkDownload]
	];

	(* helper that checks if MeltingCurves is empty *)
	associationDataCheck[tempAssoc_]:=Module[{assoc},
		assoc = tempAssoc;
		If[MatchQ[assoc[MeltingCurves], {}],
			(* if it is empty, return failed *)
			$Failed,
			(* if ti is not empty take the first melting curve *)
			assoc[MeltingCurves] = First[assoc[MeltingCurves]];
			assoc
		]
	];

	(* if melting curves do not have data, return failed, otherwise take the first MeltingCurves data *)
	meltingCurvePackets = Map[
		associationDataCheck,
		myPackets
	];

	(* return error for failed curves *)
	(* find failed packet indices *)
	noMeltingCurvesIndices = Flatten[Position[meltingCurvePackets, $Failed]];

	(* send message about all problematic objects *)
	If[Length[noMeltingCurvesIndices]>0,
		(* pull out all data objects *)
		inputDataObjects = (Lookup[#, Object])&/@myPackets;
		(* pull out the obes at bad indices and send an error *)
		noMeltingCurvesObjects = inputDataObjects[[noMeltingCurvesIndices]];
		Message[Error::NoqPCRMeltingCurvesData, noMeltingCurvesObjects]
	];

	(* return the packets with cleaned melting curves *)
	meltingCurvePackets

];

(*overload: convert downloaded list of list data to a packet for Object[Data, AbsorbanceIntensity] *)
convertMixedDownloadsToPackets[bulkDownload_, inputData:{{ObjectP[Object[Data, AbsorbanceIntensity]]..}..}, downloadFields_]:=Module[
	{
		allObjects,allNames,allInputTypes,resolvedTemperatureFields,resolvedResponseFields,allTemperatureData,allResponseData,
		validTemperatureFieldQ,validResponseFieldQ,invalidTemperatureIndices,invalidResponseIndices,validTemperatureDataQ,
		invalidTemperatureDataIndices,validResponseDataQ,invalidResponseDataIndices,meltingCurves
	},

	(*the bulkDownload has the format {{{Type, Name, TemperatureValue, ResponseValue}}..}*)
	allInputTypes = First[First[#]]&/@bulkDownload;

	{allObjects, allNames, allTemperatureData, allResponseData} = Transpose[
		Transpose[#]&/@bulkDownload
	];

	{resolvedTemperatureFields,resolvedResponseFields} = Transpose[downloadFields][[3;;4]];

	(* None of the {temperatureFields,responseFields} with this type of input shall be Null *)
	{validTemperatureFieldQ,validResponseFieldQ}=
			(* Both fields are either automatic or customized and should not be Null or {} *)
			Transpose@MapThread[
				Function[{temperatureData,responseData},
					(* Making sure that none of the temperature or response values is missing or returned failed from the download call *)
					{AllTrue[temperatureData,(!MissingQ[#] && !MatchQ[#,$Failed])&],AllTrue[responseData,(!MissingQ[#] && !MatchQ[#,$Failed])&]}
				],
				{allTemperatureData,allResponseData}
			];

	(* The index of allInputs that do not have valid temperature and response dataset *)
	{invalidTemperatureIndices,invalidResponseIndices}=
			Position[#,False]&/@{validTemperatureFieldQ,validResponseFieldQ};

	(* If not gathering tests, exit with an error if the fields for temperature not found *)
	If[Count[validTemperatureFieldQ,False]>0,
		Message[Error::InvalidTemperatureDataSet,Flatten[invalidTemperatureIndices]];
		Message[Error::InvalidOption,TemperatureDataSet];
		Return[$Failed]
	];

	(* If not gathering tests, exit with an error if the fields for response not found *)
	If[Count[validResponseFieldQ,False]>0,
		Message[Error::InvalidResponseDataSet,Flatten[invalidResponseIndices]];
		Message[Error::InvalidOption,ResponseDataSet];
		Return[$Failed]
	];

	(* True if the temperature data is a list with temperature units *)
	validTemperatureDataQ=
			Map[
				(MatchQ[#,temperatureListP] ||
						(MatchQ[#,_?QuantityArrayQ] && MatchQ[Units[#],temperatureListP]))&,
				allTemperatureData
			];

	(* The index of allInputs that do not have valid temperature data *)
	invalidTemperatureDataIndices=Position[validTemperatureDataQ,False];

	(* Error and return if temperature data is not a valid list of quantities with temperature units *)
	If[Count[validTemperatureDataQ,False]>0,
		Message[Error::InvalidTemperatureDataSet,Flatten[invalidTemperatureDataIndices]];
		Message[Error::InvalidOption,TemperatureDataSet];
		Return[$Failed]
	];

	(* True if the response data is a list with response units *)
	validResponseDataQ=
			Map[
				(MatchQ[#,responseListP] ||
						(MatchQ[#,_?QuantityArrayQ] && MatchQ[Units[#],responseListP]))&,
				allResponseData
			];

	(* The index of allInputs that do not have valid temperature data *)
	invalidResponseDataIndices=Position[validResponseDataQ,False];

	(* Error and return if response data is not a valid list of quantities with response units *)
	If[Count[validResponseDataQ,False]>0,
		Message[Error::InvalidResponseDataSet,Flatten[invalidResponseDataIndices]];
		Message[Error::InvalidOption,ResponseDataSet];
		Return[$Failed]
	];

	(* Combine the temperature and the response to make the final dataset *)
	meltingCurves=MapThread[
		Module[{unitlessTemperatureData,unitlessResponseData},
			temperatureUnit=Units[#1[[1]]];
			responseUnit=Units[#2[[1]]];
			(* Converting the units to the unit of the first element and then making unitless *)
			unitlessTemperatureData=Unitless[#1,temperatureUnit];
			(* Converting the units to the unit of the first element and then making unitless *)
			unitlessResponseData=Unitless[#2,responseUnit];
			QuantityArray[Transpose[{unitlessTemperatureData,unitlessResponseData}],{temperatureUnit,responseUnit}]
		]&,
		{allTemperatureData,allResponseData}
	];

	(* Construct and send back the object made of the packet we made above *)
	MapThread[
		rawDataToPacketHelper[#1,#2,#3,#4,#5]&,
		{inputData,meltingCurves,resolvedTemperatureFields,resolvedResponseFields,allInputTypes}
	]
];

(* Replace the coords with a mock object and give the Null peak wavelength, this fits in with the original code *)
(* For quantity coordinates, we accept all units for the y-axis but only temperature for the x-axis *)
rawDataToPacketHelper[
	myObjects:{ObjectP[Object[Data]]..},xy:(CoordinatesP|QuantityCoordinatesP[]),temperatureField:nestedFieldP,responseField:nestedFieldP,type_
]:=Module[
	{safeTemperatureField,safeResponseField,temperatureValues,responseValues,safeTemperatureData,safeResponseData},

	(* Scrape off the field if that is specified for the temperature or response fields *)
	(* The temperature values based on whether the input is quantities or not *)
	temperatureValues=Switch[xy,
		CoordinatesP, QuantityArray[xy[[All,1]], Celsius],
		QuantityCoordinatesP[], xy[[All,1]]
	];

	(* The response values based on whether the input is quantities or not *)
	responseValues=Switch[xy,
		CoordinatesP, QuantityArray[xy[[All,2]], ArbitraryUnit],
		QuantityCoordinatesP[], xy[[All,2]]
	];
	(** Note: consider removing. it is not needed to have the second and third branch now, cause the data is read directly from object in thermoCurveCoordinatesRules **)
	{safeTemperatureField,safeTemperatureData}=Switch[temperatureField,
		(* Keep symbols intact *)
		_Symbol,{temperatureField,temperatureValues},

		(* Use the actual field as the name of the field *)
		_Field,
		Switch[temperatureField,
			(* If only a symbol inside the field, just use the symbol *)
			Field[x_Symbol], {temperatureField,temperatureValues} /. (Field[x_] :> x),

			(* If part is selected, use Null for the rest of the fields except the part that is use to store the values *)
			Field[x[[i_Integer]]],
			Module[{argument,part,size,nullArray},
				(* The actual argument that wraps the part specification *)
				argument=temperatureField /. (Field[x[[i_Integer]]] :> x);
				(* The part specified in the Field argument *)
				part=responseField /. (Field[x[[i_Integer]]] :> i);
				(* Size of the field *)
				size=Length[First[myObjects][temperatureField]];
				(* Create the same size as the original field *)
				nullArray=ConstantArray[Null,size];
				{argument,ReplacePart[nullArray,{part->temperatureValues}]}
			]
		]
	];
	(** Note: consider removing. it is not needed to have the second and third branch now, cause the data is read directly from object in thermoCurveCoordinatesRules **)
	{safeResponseField,safeResponseData}=Switch[responseField,
		(* Keep symbols intact *)
		_Symbol,{responseField,responseValues},

		(* Use the actual field as the name of the field *)
		_Field,
		Switch[responseField,
			(* If only a symbol inside the field, just use the symbol *)
			Field[x_Symbol], {responseField,responseValues} /. (Field[x_] :> x),

			(* If part is selected, use Null for the rest of the fields except the part that is use to store the values *)
			Field[x[[i_Integer]]],
			Module[{argument,part,size,nullArray},
				(* The actual argument that wraps the part specification *)
				argument=responseField /. (Field[x[[i_Integer]]] :> x);
				(* The part specified in the Field argument *)
				part=responseField /. (Field[x[[i_Integer]]] :> i);
				(* Size of the field *)
				size=Length[First[myObjects][responseField]];
				(* Create the same size as the original field *)
				nullArray=ConstantArray[Null,size];
				{argument,ReplacePart[nullArray,{part->responseValues}]}
			]
		]
	];

	<|
		Object -> myObjects,
		Type -> Object[Data, MeltingCurve],
		Name -> Null,
		Wavelength -> Null,
		safeTemperatureField -> safeTemperatureData,
		safeResponseField -> safeResponseData,
		inputType -> type,
		PeakWavelength -> Null
	|>

];

(*overload: convert downloaded list of MeltingCurve data to a packet*)
convertMixedDownloadsToPackets[bulkDownload_, inputData_, ___]:=Module[
	{
		meltingCurvesBoolean,listPackets, sampleIns, polymerType, oligomersList, dnaBools, peakWavelengths,
		instruments, allExcitationWavelengths,listPacketsWithWaveLength
	},

	(*retrieve some fields values to use later*)
	(*the complete field lists are from the helper function resolveDownloadFields*)
	{instruments, allExcitationWavelengths, sampleIns, polymerType} = Part[Transpose[bulkDownload], {6, 5, 8, 9}];

	(*create a list of packets from downloaded data*)
	listPackets = createPacketList[bulkDownload, inputData, First[instruments]];

	(* check if all melting curve fields are Null or $Failed *)
	meltingCurvesBoolean = MatchQ[Lookup[#, standardMeltingDataSets], {Null|$Failed..}]&/@listPackets;
	(* return error if any objects have no melting curves *)
	If[Or@@meltingCurvesBoolean,
		Message[Error::NoMeltingCurveData, Flatten@Position[meltingCurvesBoolean, True], standardMeltingDataSets];
		Return[$Failed]
	];

	(* Get all PolymerP EXCEPT Peptide, if any, to differentiate between 260 nm peak vs 280 nm peak *)
	oligomersList=Cases[Cases[#, PolymerP], Except[Peptide]]& /@ polymerType;
	(* Any non-empty packets is set to True, else False *)
	dnaBools=Replace[oligomersList, {{__} -> True, {} -> False}, {1}];

	(*
	All in PolymerP EXCEPT Peptide will be assigned a peak wavelength of 260 Nanometers in the original experimental protocol, while all other samples are assigned 280 nm.
	We follow this convention when determining the peak wavelengths for this analysis.
	For the case of fluoresence spectra analysis, the instrument is multimode Spectrophotometer and the excitation wavelength is present and we don't need PeakWavelength
	*)
	peakWavelengths=MapThread[
		Function[{instrument,excitationWavelength,dnaBool},
			Which[
				MatchQ[instrument, ObjectP[Object[Instrument, MultimodeSpectrophotometer]]] && MatchQ[excitationWavelength,GreaterP[0*Nanometer]], Null,
				dnaBool, 260 Nanometer,
				True, 280 Nanometer
			]
		],
		{instruments,allExcitationWavelengths,dnaBools}
	];
	(* Append the peak wavelengths to each of the Packets for easy access later *)
	listPacketsWithWaveLength=MapThread[Append[#1, PeakWavelength -> #2] &, {listPackets, peakWavelengths}];

	(* Remove the key SamplesIn and PolyerType*)
	MapThread[KeyDrop[#1, {SamplesIn, PolymerType}]&, {listPacketsWithWaveLength}]

];

(*create a list of associations from the download data. The field names could be different depending on the input data types*)
createPacketList[bulkDownload_,inputData_,instrument_]:=Module[{fieldNamesMeltingCurve, fieldNamesMeltingCurveDLS},

	fieldNamesMeltingCurve = Join[
		{
		Object, Type, Name, StaticLightScatteringExcitation, ExcitationWavelength, Instrument, ID, SamplesIn, PolymerType
		},
		standardMeltingDataSets
	];
	fieldNamesMeltingCurveDLS = {
		Object, Type, Name, StaticLightScatteringExcitation, ExcitationWavelength, Instrument, ID, SamplesIn, PolymerType,
		DLSHeatingCurve, SecondaryDLSHeatingCurve, TertiaryDLSHeatingCurve,
		DLSCoolingCurve, SecondaryDLSCoolingCurve, TertiaryDLSCoolingCurve,
		EstimatedMolecularWeights
	};

	(*return list of packets*)
	If[MatchQ[inputData,{ObjectP[Object[Data, MeltingCurve]]..}] && MatchQ[instrument,ObjectP[Object[Instrument, DLSPlateReader]]],
		helperCreateAssociationList[fieldNamesMeltingCurveDLS, Transpose[bulkDownload]],
		helperCreateAssociationList[fieldNamesMeltingCurve, Transpose[bulkDownload]]
	]

];

(*
	Define a helper function that can generate a list of associations. e.g. value1={v1, v2, v3}, value2={v4, v5. v6},
  keyList = {key1, key2}, valuesNestedList = {value1, value2}. This function will generate a list of association
  {<|key1->v1, key2->v4|>, <|key1->v2, key2->v5|>, <|key1->v3, key2->v6|>}.
  Requirement: Length[keyList]===Length[valuesNestedList]
*)
helperCreateAssociationList[keyList_, valuesNestedList_]:=Map[AssociationThread[keyList, #]&, Transpose[valuesNestedList]];


(*resolve inputs for failed packet*)
resolveInputsAnalyzeMeltingPoint[KeyValuePattern[{
	ResolvedInputs -> KeyValuePattern[{
		DataAsPackets -> $Failed
	}],
	ResolvedOptions -> resolvedOptions_
}]]:=$Failed;

(*resolve inputs in preparation for calculation*)
resolveInputsAnalyzeMeltingPoint[KeyValuePattern[{
	ResolvedInputs -> KeyValuePattern[{
		DataAsPackets -> packet_
	}],
	ResolvedOptions -> resolvedOptions_
}]
]:=Module[
	{
		useAlphasBool, resolvedInputsData, resolvedInputsTestList, resolvedTemperatureDataSet, resolvedResponseDataSet,
		resolvedDataSets,resolvedFunctions,coordinateSetsID,coordinateSets,curvesTransform,resolvedMethod,curveDLS,curveSLS,
		newPacket, thisType, thisInstrument, meltingCurve, startT, endT, rampRate,
		measurementMethod
	},

	(*If the data type is Object[Data, MeltingPoint], the resolving input algorithm is different. *)
	If[MatchQ[Lookup[packet, Type], Object[Data, MeltingPoint]],

		{meltingCurve, startT, endT, rampRate, thisInstrument, measurementMethod} = Lookup[packet, {MeltingCurve, StartTemperature, EndTemperature,TemperatureRampRate, Instrument, MeasurementMethod}];

		Return[
			<|
				ResolvedInputs -> <|
					MeltingVideo -> Lookup[packet, CapillaryVideoFile],
					MeltingCurve -> meltingCurve,
					StartTemperature -> startT,
					EndTemperature -> endT,
					TemperatureRampRate -> rampRate,
					Instrument -> thisInstrument,
					MeasurementMethod -> measurementMethod
				|>
			|>
		];
	];

	(* In case the instrument is multimode Spectrophotometer and  we have ExcitationWavelength, we don't want to use alpha *)
	useAlphasBool=
		Module[{fluoresenceSpectraInstrument},
			fluoresenceSpectraInstrument=MatchQ[Lookup[packet,Instrument,Null], ObjectP[Object[Instrument, MultimodeSpectrophotometer]]];
			If[fluoresenceSpectraInstrument && MatchQ[Lookup[packet,ExcitationWavelength,Null],GreaterP[0*Nanometer]],
				False,
				True
			]
		];

	thisType = Lookup[packet, Type];
	thisInstrument = Lookup[packet, Instrument];
	newPacket = packet;

	(*if the data type is Object[Data, MeltingCurve] and generated from DLSPlateReader, both DLS and SLS data will be preprocessed using a helper function*)
	If[MatchQ[thisType, Object[Data, MeltingCurve]] && MatchQ[thisInstrument,ObjectP[Object[Instrument, DLSPlateReader]]],

		{curveDLS, curveSLS} = meltingCurveDLSPreprocess[newPacket];
		(*only existing data points will be added to the packet*)
		If[!MatchQ[curveDLS, {}], newPacket[DataPointsDLSAverageZDiameter] = curveDLS];
		If[!MatchQ[curveSLS, {}], newPacket[DataPointsSLSMolecularWeights] = curveSLS]
	];

	(*this helper function will resolve packet to proper data format for calculation*)
	{resolvedInputsData,resolvedInputsTestList} = resolveAnalyzeMeltingPointInputs[newPacket, Normal[resolvedOptions]];

	(*return $Failed if the input data is not resolved correctly*)
	If[MemberQ[resolvedInputsData, $Failed],
		Return[$Failed]
	];

	If[Length[resolvedInputsData]===0,
		(* If we have no possible inputs, we return $Failed *)
		Message[Error::NoPacketsInInput];
		(* Return $Failed and also all tests so far *)
		Return[$Failed]
	];

	(* assign resolved values to variables *)
	{
		resolvedTemperatureDataSet,resolvedResponseDataSet,resolvedDataSets,resolvedFunctions,coordinateSetsID,
		coordinateSets,curvesTransform,resolvedMethod
	} = resolvedInputsData;

	<|
		ResolvedInputs -> <|
			TemperatureDataSets -> resolvedTemperatureDataSet,
			ResponseDataSets -> resolvedResponseDataSet,
			DataSets -> resolvedDataSets,
			Functions -> resolvedFunctions,
			CoordinateSetsID -> coordinateSetsID,
			CoordinateSets -> coordinateSets,
			CurvesTransform	-> curvesTransform,
			UseAlphasBool -> useAlphasBool
		|>,
		Intermediate -> <|
			CurrentMethod -> resolvedMethod
		|>,
		ResolvedOptions -> <|
			Method -> resolvedMethod
		|>,
		Tests -> <|
			ResolvedInputsTestList -> resolvedInputsTestList
		|>
	|>
];

(*use moving average to aggregate all 6 curves into one for DLS curve data*)
meltingCurveDLSPreprocess[packet_]:=Module[{curveSLS, curveDLS, finalCurveDLS, curveDLSValue, baseUnit, maCurveDLSValue, finalCurveSLS},

	(*SLS curve is molecular weights vs. temperature*)
	curveSLS = Lookup[packet, EstimatedMolecularWeights];
	finalCurveSLS = If[MatchQ[curveSLS, Null|$Failed], {}, QuantityArray[curveSLS]];

	(*DLS curve is Z-average diameter vs. temperature, with aggregation of 6 curves*)
	curveDLS = Join@@Lookup[
		packet,
		{DLSHeatingCurve,SecondaryDLSHeatingCurve,TertiaryDLSHeatingCurve,DLSCoolingCurve,SecondaryDLSCoolingCurve,TertiaryDLSCoolingCurve}
	];
	(*use MovingAverage to make an average of the 6 curves to reduce the noise*)
	curveDLSValue = QuantityMagnitude[curveDLS];
	baseUnit = QuantityUnit[First[curveDLS]];
	maCurveDLSValue = MovingAverage[Sort[curveDLSValue], 6];
	finalCurveDLS = QuantityArray[maCurveDLSValue, baseUnit];

	{finalCurveDLS, finalCurveSLS}
];


(*resolve options for AnalyzeMeltingPoint*)
(*overload: the input data is Object[Data, MeltingPoint]*)
resolveOptionsAnalyzeMeltingPoint[KeyValuePattern[{
	UnresolvedInputs -> KeyValuePattern[{
		InputData -> inputData:ObjectP[Object[Data, MeltingPoint]]
	}],
	ResolvedOptions -> KeyValuePattern[{
		StartPointThreshold -> startPoint_,
		MeniscusPointThreshold -> meniscusPoint_,
		ClearPointSlopeThreshold -> clearPointSlope_
	}]
}]
]:= <||>;


(*overload: the input data is all other cases*)
resolveOptionsAnalyzeMeltingPoint[KeyValuePattern[{
	ResolvedInputs -> KeyValuePattern[{
		DataAsPackets -> packetList_,
		TemperatureDataSets -> resolvedTemperatureDataSet_,
		ResponseDataSets -> resolvedResponseDataSet_,
		DataSets -> resolvedDataSets_,
		Functions -> resolvedFunctions_,
		CoordinateSets -> coordinateSets_
	}],
	Intermediate -> KeyValuePattern[{
		CurrentMethod -> resolvedMethod_
	}],
	ResolvedOptions -> combinedOptions_
}]
]:=Module[{resolvedOptions,resolvedOptionsTests},

	(*Use the helper function to resolve options*)
	{resolvedOptions,resolvedOptionsTests} = resolveAnalyzeMeltingPointOptions[
		{packetList}, {resolvedMethod}, {resolvedTemperatureDataSet}, {resolvedResponseDataSet}, {resolvedDataSets},
		{resolvedFunctions}, {coordinateSets}, Normal[combinedOptions], Output->{Result,Tests}
	];

	<|
		ResolvedOptions -> Join[combinedOptions, Association[resolvedOptions]],
		Tests -> <|
			ResolvedOptionsTests -> resolvedOptionsTests
		|>
	|>

];


(*calculations of onset temperature*)
(*overload: the input data is Object[Data, MeltingPoint]*)
computeAnalyzeMeltingPoint[KeyValuePattern[{
	UnresolvedInputs -> KeyValuePattern[{
		InputData -> inputData:ObjectP[Object[Data, MeltingPoint]]
	}],
	ResolvedInputs -> KeyValuePattern[{
		MeltingVideo -> meltingVideo_,
		MeltingCurve -> meltingData_,
		StartTemperature -> startT_,
		EndTemperature -> endT_,
		TemperatureRampRate -> rate_,
		Instrument -> thisInstrument_,
		MeasurementMethod -> measurementMethod_
	}],
	ResolvedOptions -> resolvedOps: KeyValuePattern[{
		StartPointThreshold -> startPointThreshold_,
		MeniscusPointThreshold -> meniscusPointThreshold_,
		ClearPointSlopeThreshold -> clearPointSlope_
	}]
}]]:=Module[
	{
		resolvedOpsList, startPositionList, meniscusPositionList, startPosition, meniscusPosition, startPointTemp, meniscusPointTemp, clearPointTemp, allTemp, timeSeconds,
		percents, derivatives, largestPosition, clearPointPositionList, clearPointPosition, finalPosition, packet, magStartPointThres, magMeniscusPointThres, magClearPointSlope,
		magMeltingData, magRate
	},

	resolvedOpsList = Normal[First[resolvedOps], Association];

	$DefaultPacket = <|
		Packet -> <|
			Type -> Object[Analysis, MeltingPoint],
			Instrument -> Link[thisInstrument],
			ResolvedOptions -> resolvedOpsList,
			Append[Reference] -> {Link[inputData, MeltingAnalyses]},
			PharmacopeiaStartPointTemperature -> Null,
			PharmacopeiaMeniscusPointTemperature -> Null,
			PharmacopeiaClearPointTemperature -> Null,
			ThermodynamicMeltingTemperature -> Null,
			USPharmacopeiaMeltingRange -> {Null, Null},
			BritishPharmacopeiaMeltingTemperature -> Null,
			JapanesePharmacopeiaMeltingTemperature -> Null
		|>,
		Intermediate -> <|
			PreviewQ -> True
		|>
	|>;

	{magMeltingData, magStartPointThres, magMeniscusPointThres, magClearPointSlope, magRate} = QuantityMagnitude[
		{meltingData, startPointThreshold, meniscusPointThreshold, clearPointSlope, rate}
	];

	(*Often, meltingData is not single-valued.  It typically occurs at the start of the dataset.*)
	(*Delete duplicates by the x-values*)
	magMeltingData = DeleteDuplicatesBy[magMeltingData, First];

	(*find the first position that the transmission percentage is greater than the threshold point for all data*)
	startPositionList = FirstPosition[magMeltingData, {x_, y_}/; y>magStartPointThres];
	meniscusPositionList = FirstPosition[magMeltingData, {x_, y_}/; y>magMeniscusPointThres];

	If[startPositionList === Missing["NotFound"],
		Message[Warning::StartPointThresholdUnreached, Download[inputData, Object], magStartPointThres];
		Return[$DefaultPacket]];
	If[meniscusPositionList === Missing["NotFound"],
		Message[Warning::MeniscusPointThresholdUnreached, Download[inputData, Object], magMeniscusPointThres];
		Return[$DefaultPacket]];

	startPosition = First[startPositionList];
	meniscusPosition = First[meniscusPositionList];

	(*get the temperature at the position*)
	startPointTemp =  magMeltingData[[startPosition, 1]];
	meniscusPointTemp = magMeltingData[[meniscusPosition, 1]];

	allTemp = Transpose[magMeltingData][[1]];

	(*
		By definition, the clear point is the temperature at which the intensity of slope is below a threshold at the end of melting.
		The given threshold has the unit of percent of changes per second. The algorithm is
			(1) convert temperature to time in seconds (x-axis)
			(2) calculate the derivative (percent change per second) and find the largest one. The clear point should be after that
			(3) after the largest derivative, find the first position when the slope is below the threshold
			(4) return the temperature of that position
	*)

	timeSeconds = (allTemp - allTemp[[1]]) / magRate * 60;

	(*calculate the derivative*)
	percents = Transpose[magMeltingData][[2]];
	derivatives = MapThread[If[#2 == 0, 0, (#1/#2)]&, {Differences[percents], Differences[timeSeconds]}];

	(*find the position of largest derivatives*)
	largestPosition = First[Ordering[derivatives, -1]];

	(*target temperature position should be after the largest position*)
	clearPointPositionList = FirstPosition[
		derivatives[[largestPosition;;]],
		x_/; x<=magClearPointSlope
	];
	If[clearPointPositionList === Missing["NotFound"],
		Message[Warning::ClearPointSlopeThresholdUnreached, Download[inputData, Object], magClearPointSlope];
		Return[$DefaultPacket]
	];

	clearPointPosition = First[clearPointPositionList];
	finalPosition  = largestPosition + clearPointPosition - 1;

	(*return the current temperature at this position*)
	clearPointTemp = magMeltingData[[finalPosition, 1]];

	(* updated packet *)
	packet = If[
		MatchQ[measurementMethod, Thermodynamic],
		<|
			Type -> Object[Analysis, MeltingPoint],
			Instrument -> Link[thisInstrument],
			ResolvedOptions -> resolvedOpsList,
			Append[Reference] -> {Link[inputData, MeltingAnalyses]},
			ThermodynamicMeltingTemperature -> meniscusPointTemp * Celsius,
			MeasurementMethod -> measurementMethod
		|>,
		<|
			Type -> Object[Analysis, MeltingPoint],
			Instrument -> Link[thisInstrument],
			ResolvedOptions -> resolvedOpsList,
			Append[Reference] -> {Link[inputData, MeltingAnalyses]},
			PharmacopeiaStartPointTemperature -> startPointTemp * Celsius,
			PharmacopeiaMeniscusPointTemperature -> meniscusPointTemp * Celsius,
			PharmacopeiaClearPointTemperature -> clearPointTemp * Celsius,
			USPharmacopeiaMeltingRange -> {startPointTemp, clearPointTemp} * Celsius,
			BritishPharmacopeiaMeltingTemperature -> clearPointTemp * Celsius,
			JapanesePharmacopeiaMeltingTemperature -> clearPointTemp * Celsius,
			MeasurementMethod -> measurementMethod
		|>
	];

	<|
		Packet -> packet,
		Intermediate -> <|PreviewQ -> True|>
	|>
];


(*overload: the input data is all other cases*)
computeAnalyzeMeltingPoint[KeyValuePattern[{
	ResolvedInputs -> KeyValuePattern[{
		DataAsPackets -> packetList_,
		CoordinateSets -> coordinateSets_,
		CoordinateSetsID -> coordinateSetsID_,
		CurvesTransform	-> curvesTransform_,
		UseAlphasBool -> useAlphasBool_
	}],
	ResolvedOptions -> resolvedOptions_
}]
]:=Module[{meltingPointFieldsList,meltingPointFieldsListTestList,meltingPointPacketsList,optionLists,checkPreview,previewQ},

	optionLists = Normal[resolvedOptions];

	(* Calls the main function to calculate the melting points for each pair of coordinateSet/curve *)
	(*In the case the given Domain contains no data points, the Preview will be Null*)
	checkPreview=Check[
		{meltingPointFieldsList, meltingPointFieldsListTestList} = calculateMeltingPointFields[
			coordinateSetsID,coordinateSets,curvesTransform,useAlphasBool,optionLists,Lookup[packetList,Object], {Output->{Result,Tests}}
		],
		noPreview,
		Warning::NoDataInDomainRange
	];
	(*if checkPreview is noPreview, previewQ will be set to False*)
	previewQ = Not[MatchQ[checkPreview, noPreview]];

	(* construct the full packets *)
	meltingPointPacketsList = formatMeltingPointPacket[packetList,optionLists,meltingPointFieldsList];

	<|
		Packet -> meltingPointPacketsList,
		Tests -> <|
			MeltingPointFieldsListTests -> meltingPointFieldsListTestList
		|>,
		Intermediate -> <|
			PreviewQ -> previewQ
		|>
	|>
];


(*generating plots for preview*)
(*Since all data objects in a protocol are superimposed onto one plot, we only need to take the first data object*)
previewAnalyzeMeltingPoint[in: KeyValuePattern[{
	Packet -> packet_,
	ResolvedOptions -> KeyValuePattern[{
		PlotType -> plotType_,
		Output -> output_
	}],
	ResolvedInputs -> KeyValuePattern[{
		DataAsPackets -> inputPacket_List
	}],
	Intermediate -> KeyValuePattern[{
		PreviewQ -> previewQ_
	}]
}]]:=Module[{bt, length, result},


	bt = BatchTranspose[in];

	length = Length[bt];



	result = makeMeltingPointPreview[First[bt]];

	(*The preview still needs to be a List of length equal to the size of the input list.*)
	(*So produce a List padded with Nulls*)
	<|
		Preview -> PadRight[{Lookup[result, Preview]}, length, Null],
		Batch->True
	|>
];

(*generating plots for preview*)
makeMeltingPointPreview[KeyValuePattern[{
	Packet -> packet_,
	ResolvedOptions -> KeyValuePattern[{
		PlotType -> plotType_,
		Output -> output_
	}],
	ResolvedInputs -> KeyValuePattern[{
		DataAsPackets -> inputPacket_
	}],
	Intermediate -> KeyValuePattern[{
		PreviewQ -> previewQ_
	}]
}]]:=Module[
	{
		fig, previewRequestQ, inputObject
	},

	(* check if preview is a member of the requested output *)
	previewRequestQ = MemberQ[ToList[output], Preview];

	(*preview will be set to Null under some situation, e.g. Domain is outside of plotted region or a preview was not requested *)
	fig = If[previewQ && previewRequestQ,

		(* find input object to determine plot type *)
		inputObject = Lookup[inputPacket, Object];

		(* Switch plot type based on data *)
		Switch[inputObject,
			ObjectP[Object[Data, qPCR]],
			PlotqPCR[packet, PrimaryData->MeltingCurves],
			_,
			PlotMeltingPoint[packet, PlotType->plotType]
		],

		Null
	];

	<|
		Preview -> fig
	|>
];

resolveAnalyzeMeltingPointInputs[packet_,expandedOptions_]:=Module[
	{
		curves,inputsTests,collectTestsBoolean,myPacketRequiredOptions,
		absUnits,flUnits,arbUnits,dataSetResolved,curvesProcessed,curvesNullBool,curvesNullTest,allTests,molecularWeightUnits,
		method,resolvedMethod,fluoresenceSpectraInstrument,fluoresenceSpectraDataQ,requiredOptions,
		temperatureDataSetResolved,responseDataSetResolved,resolvedFunctions,curvesID,curvesTransform,
		qPCRDataQ
	},

	(* Do we want to collect tests *)
	collectTestsBoolean=MemberQ[Lookup[expandedOptions, Output],Tests];

	(* In case the instrument is multimode Spectrophotometer, we need to process the 3D fluoresence spectra data *)
	fluoresenceSpectraInstrument=MatchQ[Lookup[packet,Instrument,Null], ObjectP[Object[Instrument, MultimodeSpectrophotometer]]];
	fluoresenceSpectraDataQ=fluoresenceSpectraInstrument && MatchQ[Lookup[packet,ExcitationWavelength,Null],GreaterP[0*Nanometer]];

	(* This is the method used for calculating the melting temperature *)
	method = Lookup[expandedOptions, Method];

	(* check if input packet is qPCR, to default method to Derivative *)
	qPCRDataQ = MatchQ[Lookup[packet, Object], ObjectP[Object[Data, qPCR]]];

	resolvedMethod=Which[
		(* For fluoresenceSpectraDataQ and qPCRData, we set the method to Derivative *)
		(method===Automatic && (fluoresenceSpectraDataQ||qPCRDataQ)), Derivative,
		(* For other automatic cases, method is set to MidPoint *)
		(method===Automatic && !fluoresenceSpectraDataQ), MidPoint,
		(* For all other conditions, choose MidPoint *)
		True,method
	];

	(* resolveMeltingPointInput needs these options *)
	requiredOptions=
		{
			Wavelength,DataSet,DataSetTransformationFunction,
			TemperatureDataSet,TemperatureTransformationFunction,ResponseDataSet,ResponseTransformationFunction
		};

	(* We need to pass my packet options to resolveMeltingPointInput *)
	myPacketRequiredOptions = MapThread[#1->#2&, {requiredOptions, Lookup[expandedOptions, requiredOptions]}];
	{temperatureDataSetResolved,responseDataSetResolved,dataSetResolved,resolvedFunctions,curvesID,curves,curvesTransform,inputsTests}=If[collectTestsBoolean,
		N[resolveMeltingPointInput[packet,True,myPacketRequiredOptions]],
		N[resolveMeltingPointInput[packet,False,myPacketRequiredOptions]]
	];

	(* Return early if the error messages showed up in resolveMeltingPointInput *)
	If[{temperatureDataSetResolved,responseDataSetResolved,dataSetResolved,resolvedFunctions,curvesID,curves,curvesTransform}===ConstantArray[$Failed,7],
		If[collectTestsBoolean,
			Return[{{$Failed,$Failed,$Failed,$Failed,$Failed,$Failed,$Failed,resolvedMethod},inputsTests}],
			Return[{{$Failed,$Failed,$Failed,$Failed,$Failed,$Failed,$Failed,resolvedMethod},{}}]
		]
	];

	(* All expected units for coordinateSets *)
	absUnits={Celsius,AbsorbanceUnit};
	flUnits={Celsius,RFU};
	arbUnits={Celsius,ArbitraryUnit};
	molecularWeightUnits={Celsius,Gram/Mole};

	(* Making the coordinateSets unitless to prepare for calculateMeltingPointFields *)
	curvesProcessed=Map[
		Function[curve,
			Switch[curve,
				QuantityCoordinatesP[absUnits], Unitless[curve,absUnits],
				QuantityCoordinatesP[flUnits], Unitless[curve,flUnits],
				QuantityCoordinatesP[arbUnits], Unitless[curve,arbUnits],
				QuantityCoordinatesP[molecularWeightUnits], Unitless[curve,molecularWeightUnits],
				_, curve
			]
		],
		curves
	];

	curvesNullBool=MatchQ[curves,{Null|{}...}];
	curvesNullTest=If[curvesNullBool,
		Test["There is at least one valid curve.", True, False],
		Test["There is at least one valid curve.", True, True]
	];
	allTests=Join[{curvesNullTest},inputsTests];

	(* exit if no data available *)
	Which[collectTestsBoolean,
		{{temperatureDataSetResolved,responseDataSetResolved,dataSetResolved,resolvedFunctions,curvesID,curvesProcessed,curvesTransform,resolvedMethod},allTests},
		curvesNullBool,
		Message[Error::MeltingPointEmptyData];
		Message[Error::InvalidInput,Lookup[packet, Type]];
		{{temperatureDataSetResolved,responseDataSetResolved,dataSetResolved,resolvedFunctions,curvesID,curvesProcessed,curvesTransform,resolvedMethod},{}},
		True,
		{{temperatureDataSetResolved,responseDataSetResolved,dataSetResolved,resolvedFunctions,curvesID,curvesProcessed,curvesTransform,resolvedMethod},{}}
	]
];



resolveMeltingPointInput[thermoPacket: PacketP[Object[Data]], collectTestBool_, myOptions_]:=Module[
	{resolvedTemperatureDataSet,resolvedResponseDataSet,resolvedDataSets,coordRules,coordTests,resolvedFunctions,curvesTransform},

	{{resolvedTemperatureDataSet,resolvedResponseDataSet,resolvedDataSets,resolvedFunctions,coordRules,curvesTransform},coordTests}=If[collectTestBool,
		thermoCurveCoordinatesRules[thermoPacket, {Result,Tests}, myOptions],
		{thermoCurveCoordinatesRules[thermoPacket, Result, myOptions],{}}
	];

	(* Return Null for datasets and melting curves to resolveMeltingPointInputs if failed in thermoCurveCoordinatesRules *)
	If[{resolvedTemperatureDataSet,resolvedResponseDataSet,resolvedDataSets,resolvedFunctions,coordRules,curvesTransform}===ConstantArray[$Failed,6],
		If[collectTestBool,
			Return[{$Failed,$Failed,$Failed,$Failed,$Failed,$Failed,$Failed,coordTests}],
			Return[{$Failed,$Failed,$Failed,$Failed,$Failed,$Failed,$Failed,{}}]
		]
	];

	(* Return the resolved data sets and resolved transformed melting curves *)
	{
		resolvedTemperatureDataSet,
		resolvedResponseDataSet,
		resolvedDataSets,
		resolvedFunctions,
		Keys[coordRules],
		Values[coordRules],
		ToList[curvesTransform],
		coordTests
	}
];



(* Overload for FluorescenceThermodynamics data objects *)
thermoCurveCoordinatesRules[flThermoPacket:PacketP[Object[Data,FluorescenceThermodynamics]],resultOps_,options: OptionsPattern[]]:= Module[
	{
		listedOptions,wavelength,output,listedOutput,collectTestsBoolean,threeDCurvesTest,resultPacket,resultTest,allTests
	},

	listedOptions=ToList[options];
	wavelength=Lookup[listedOptions, Wavelength, Null];

	(* Get the user requested output *)
	output=resultOps;
	listedOutput=ToList[output];

	collectTestsBoolean=MemberQ[listedOutput,Tests];

	(* Test automatically fails because we don't have any 3D curves for FlurorescenceThermodynamics*)
	threeDCurvesTest=If[collectTestsBoolean,
		Test["There is at least one 3D curve.", True, False],
		{}
	];

	(* Pack up the packet and test *)
	{resultPacket,resultTest}= Module[{mc,cc,packet},
		mc=Lookup[flThermoPacket, MeltingCurve];
		cc=Lookup[flThermoPacket, CoolingCurve];
		(* Only take the melting and cooling if they are not Null *)
		packet=DeleteCases[
			Association[
				MeltingCurve -> If[MissingQ[mc], Null, mc],
				CoolingCurve -> If[MissingQ[cc], Null, cc]
			],Null
		];

		Which[
			wavelength=!=Null,
			If[collectTestsBoolean,
				{packet,{threeDCurvesTest}},
				Message[Warning::ObjectDoesNotContain3DCurves];{packet,{}}
			],
			True,{packet,{}}
		]
	];

	(* Yup, just one test for now *)
	allTests=resultTest;

	(* Set the resolvedTemperatureDataSet and resolvedResponseDataSet to Null *)
	output/.{Result->{Null,Null,Keys[resultPacket],ConstantArray[None,Length[resultPacket]],resultPacket,ConstantArray[None,Length[resultPacket]]},Tests->allTests}
];

(* Overload for MeltingCurve and all other data objects *)
thermoCurveCoordinatesRules[thermoPacket:PacketP[Object[Data]],resultOps_,options: OptionsPattern[]]:=Module[
	{
		listedOptions,wavelength,output,listedOutput,collectTestsBoolean,allTests,resolveWavelengthInput,resolvedWavelengths,allWavelengths,
		meltingCurve3D, coolingCurve3D, aggregationCurve3D, threeDCurvesExistsBool, threeDCurvesTest, use2DDataQ, use2DDataQTests, resultPacket,
		fluoresenceSpectraDataQ,slsWavelengths,fluoresenceSpectraInstrument,
		temperatureDataSet,responseDataSet,dataSets,
		dataSetTransformationFunctions,resolvedDataSets,resolvedMeltingCurves,meltingCurves3D,meltingCurves2D,
		standardDataSetRules,showMessages,validDataSetTransformationFunctionsQ,resolvedTransformationFunctions,
		standardDataSetCurves,inquireDataSets,resolvedTransformedMeltingCurves,automaticTransformationHelper,
		validTransformedDataSetQ,invalidTransformedDataSetIndices,validTransformedDataSetTest,applyTransformHelper,
		validDataSetTransformationFunctionsTest,positionDuplicatesHelper,renameDuplicatesHelper,positionInDataSet,
		reorderedResolvedTransformedDataSets,reorderedResolvedTransformedTransformationFunctions,reorderedResolvedTransformedMeltingCurves,
		safeDuplicatesResolevedTransformedDataSet,twoDDataSetsPosition,
		transformableResolvedDataSets,transformableResolvedMeltingCurves,transformableDataSetTransformationFunctions,validDataSetQ,
		invalidDataSetIndices,validDataSetTest,inquireDataSetResult,inquireDataSetTest,lookupField,resolvedTemperatureDataSet,
		resolvedResponseDataSet,type,temperatureData,responseData,meltingTransformationResults,resolvedTransformedDataSets,
		validTemperatureFieldQ,validResponseFieldQ,validTemperatureFieldTest,validResponseFieldTest,combinedTemperatureResponseData,
		listedDataSets,temperatureTransformationFunction,responseTransformationFunction,transformedTemperatureData,transformedResponseData,
		validTransformedTempretureDataSetQ,validTransformedResponseDataSetQ,validTransformedTempretureDataSetTest,validTransformedResponseDataSetTest,
		transformedTemperatureResponseData,listedDataSetTransformationFunctions,resolvedTransformedTransformationFunctions,safeLookup,
		validTemperatureDataQ,validTemperatureDataTest,validResponseDataQ,validResponseDataTest, thisObject
	},

	(*get the current object*)
	thisObject = Lookup[thermoPacket, Object];

	(* Lookup the wavelength option for thermoPacket *)
	listedOptions=ToList[options];

	(* Get the user requested output *)
	output=resultOps;
	listedOutput=ToList[output];

	(* Is collecting tests requested for the output? *)
	collectTestsBoolean=MemberQ[listedOutput,Tests];
	showMessages=!collectTestsBoolean;

	(* In case the instrument is multimode Spectrophotometer and we have ExcitationWavelength, we need to process the 3D fluoresence spectra data *)
	fluoresenceSpectraInstrument=MatchQ[Lookup[thermoPacket,Instrument,Null], ObjectP[Object[Instrument, MultimodeSpectrophotometer]]];
	fluoresenceSpectraDataQ= fluoresenceSpectraInstrument && MatchQ[Lookup[thermoPacket,ExcitationWavelength,Null],GreaterP[0*Nanometer]];

	(* <<< Resolving Temperature and Response Dataset Fields >>> *)

	(* The type of the data object to lookup the automatic temperature and response fields *)
	type=Lookup[thermoPacket,inputType,Null];

	(* Searches for type in table, returning None if type is none or not found *)
	lookupField[table_Association,type:None|Null|TypeP[]]:=If[KeyExistsQ[table,type]||!MatchQ[type,Null],
		Lookup[table,type],
		Null
	];

	(* Object fields that store temperature information *)
	{temperatureDataSet,responseDataSet}=Lookup[listedOptions,{TemperatureDataSet,ResponseDataSet}];

	(* Resolve temperature fields based on user supplied options *)
	resolvedTemperatureDataSet=
		Which[
			(* If Automatic, look for a default field. *)
			MatchQ[temperatureDataSet,Automatic], lookupField[DefaultTemperatureField,type],
			(* If not Automatic, it has been explicitly specified *)
			MatchQ[temperatureDataSet,Except[Automatic]], temperatureDataSet
		];

	(* Resolve response fields based on user supplied options *)
	resolvedResponseDataSet=
		Which[
			(* If Automatic, look for a default field. *)
			MatchQ[responseDataSet,Automatic], lookupField[DefaultResponseField,type],
			(* If not Automatic, it has been explicitly specified *)
			MatchQ[responseDataSet,Except[Automatic]], responseDataSet
		];

	(* Helper function: safely looks up the field if it is a symbol or Field[symbol] *)
	safeLookup[packet:PacketP[],field:nestedFieldP]:=Module[{newField},
		Switch[field,
			(* If it is a symbol, only search the packet *)
			_Symbol, Lookup[packet,field],

			(* If it is Field[], look up the name inside the Field*)
			_Field,
				newField = field/.{Field[name_]:>name, Field[]:>{}};
				Lookup[packet, newField]
		]
	];
	safeLookup[packet:PacketP[],fields:{nestedFieldP..}]:=safeLookup[packet,#]& /@ fields;

	(* Take temperature and response from all of their packets *)
	{temperatureData,responseData}=Switch[{resolvedTemperatureDataSet,resolvedResponseDataSet},

		(* If TemperatureDataSet and ResponseDataSet are resolved to Null set the data to Null *)
		{Null,Null},
		{Null,Null},

		(* If from {TemperatureDataSet,ResponseDataSet} one is Null and the other in non Null set the whole thing to Null and throw error *)
		({Null,Except[Null]}||{Null,Except[Null]}),
		{Null,Null},

		(* If TemperatureDataSet and ResponseDataSet are resolved to non Null find them in thermoPacket *)
		{Except[Null],Except[Null]},
		Quiet[safeLookup[thermoPacket,{resolvedTemperatureDataSet,resolvedResponseDataSet}],{Download::MissingField,Download::FieldDoesntExist}]

	];

	(* Making sure that none of the temperature or response values is missing or failed due to not being present in the download call *)
	{validTemperatureFieldQ,validResponseFieldQ}={!MissingQ[temperatureData]||temperatureData===$Failed,!MissingQ[responseData]||responseData===$Failed};

	(* Test if valid fields for temperature are found *)
	validTemperatureFieldTest=If[collectTestsBoolean,
		Test["None of the temperature fields are missing.",
			validTemperatureFieldQ===False,
			False
		],
		{}
	];

	(* Test if valid fields for temperature are found *)
	validResponseFieldTest=If[collectTestsBoolean,
		Test["None of the temperature fields are missing.",
			validResponseFieldQ===False,
			False
		],
		{}
	];

	(* If not gathering tests, exit with an error if the fields for temperature not found *)
	If[showMessages&&validTemperatureFieldQ===False,
		Message[Error::InvalidTemperatureDataSet,thisObject];
		Message[Error::InvalidOption,TemperatureDataSet];
		Return[ConstantArray[$Failed,6]]
	];

	(* If not gathering tests, exit with an error if the fields for response not found *)
	If[showMessages&&validResponseFieldQ===False,
		Message[Error::InvalidResponseDataSet,thisObject];
		Message[Error::InvalidOption,ResponseDataSet];
		Return[ConstantArray[$Failed,6]]
	];

	(* True if the temperature data is a list with temperature units *)
	validTemperatureDataQ=If[
		MatchQ[{resolvedTemperatureDataSet,resolvedResponseDataSet},{Null,Null}],
		(* True if TemperatureDataSet and ResponseDataSet are resolved to non Null *)
		True,
		MatchQ[temperatureData,temperatureListP] ||
		(MatchQ[temperatureData,_?QuantityArrayQ] && MatchQ[Units[temperatureData],temperatureListP])
	];

	(* Test if the temperature data has the valid pattern *)
	validTemperatureDataTest=If[collectTestsBoolean,
		Test["Temperatrure data is a valid list of values with temperature units.",
			validTemperatureDataQ===False,
			False
		],
		{}
	];

	(* Error and return if temperature data is not a valid list of quantities with temperature units *)
	If[showMessages&&validTemperatureDataQ===False,
		Message[Error::InvalidTemperatureDataSet,thisObject];
		Message[Error::InvalidOption,TemperatureDataSet];
		Return[ConstantArray[$Failed,6]]
	];

	(* True if the response data is a list with response units *)
	validResponseDataQ=If[
		MatchQ[{resolvedTemperatureDataSet,resolvedResponseDataSet},{Null,Null}],
		(* True if TemperatureDataSet and ResponseDataSet are resolved to non Null *)
		True,
		MatchQ[responseData,responseListP] ||
		(MatchQ[responseData,_?QuantityArrayQ] && MatchQ[Units[responseData],responseListP])
	];

	(* Test if the response data has the valid pattern *)
	validResponseDataTest=If[collectTestsBoolean,
		Test["Response data is a valid list of values with response units.",
			validResponseDataQ===False,
			False
		],
		{}
	];

	(* Error and return if response data is not a valid list of quantities with response units *)
	If[showMessages&&validResponseDataQ===False,
		Message[Error::InvalidResponseDataSet,thisObject];
		Message[Error::InvalidOption,ResponseDataSet];
		Return[ConstantArray[$Failed,6]]
	];

	(* Combine the temperature and the response to make the final dataset *)
	combinedTemperatureResponseData=Switch[{resolvedTemperatureDataSet,resolvedResponseDataSet},

		(* If TemperatureDataSet and ResponseDataSet are resolved to Null set the data to Null *)
		{Null,Null},
		Null,

		(* If TemperatureDataSet and ResponseDataSet are resolved to non Null combine the corresponding data *)
		{Except[Null],Except[Null]},
		Module[{unitlessTemperatureData,unitlessResponseData},

			temperatureUnit=Units[temperatureData[[1]]];

			responseUnit=Units[responseData[[1]]];

			(* Converting the units to the unit of the first element and then making unitless *)
			unitlessTemperatureData=Unitless[temperatureData,temperatureUnit];

			(* Converting the units to the unit of the first element and then making unitless *)
			unitlessResponseData=Unitless[responseData,responseUnit];

			QuantityArray[Transpose[{unitlessTemperatureData,unitlessResponseData}],{temperatureUnit,responseUnit}]

		]
	];

	(* <<< Resolving Dataset Fields >>> *)

	(* Curves associated with standard datasets *)
	standardDataSetCurves=Lookup[thermoPacket,#,Null]&/@standardMeltingDataSets;

	(* Rules associated with the standard datasets *)
	standardDataSetRules=MapThread[
		(#1->#2)&,
		{standardMeltingDataSets,standardDataSetCurves}
	];

	(* Object fields that store all melting dataset information *)
	dataSets=Lookup[listedOptions,DataSet];

	(* Warn that if the TemperatureDataSet and ResponseDataSet are resolved to non Null, DataSet will be set to Null *)
	If[!MatchQ[{resolvedTemperatureDataSet,resolvedResponseDataSet},{Null,Null}]&&!MatchQ[dataSets,Automatic|Null],
		Message[Warning::UnusedDataSet]
	];

	(* Put dataSets in a list if not already and Null if TemperatureDataSet and ResponseDataSet are non Null *)
	listedDataSets=Which[

		(* If TemperatureDataSet and ResponseDataSet are resolved to non Null set listedDataSets to Null *)
		!MatchQ[{resolvedTemperatureDataSet,resolvedResponseDataSet},{Null,Null}],Null,

		(* Don't put it in a list if Automatic is chosen for DataSet *)
		MatchQ[dataSets,Automatic],Automatic,

		(* Otherwise always use list wrapper *)
		MatchQ[dataSets,Except[Automatic]],ToList[dataSets]
	];

	(* Ask if the datasets exist in the packet and throw error if not *)
	inquireDataSets[myPacket_,dataSets_]:=
		Module[{inquiredDataSetCurves},
			inquiredDataSetCurves=Quiet[safeLookup[myPacket,dataSets],{Download::MissingField,Download::FieldDoesntExist}];

			Transpose@MapThread[
				(* Inquired data set is not present in the packet or returned $Failed in download call *)
				If[(MissingQ[#2]||#2===$Failed),
					Message[Error::DataSetDoesntExist,#1,Lookup[myPacket, Type]];
					Message[Error::InvalidOption,DataSet];{#1,Null},
					{#1,#2}
				]&,
				{dataSets,inquiredDataSetCurves}
			]
		];

	(* The resolved dataset fields and the corresponding melting curves *)
	inquireDataSetResult=Check[
		{resolvedDataSets,resolvedMeltingCurves}=
			Switch[listedDataSets,

				(* If TemperatureDataSet and ResponseDataSet are resolved to non Null set listedDataSets to Null *)
				Null,
				{Null,Null},

				(* Default only takes the standardMeltingDataSets that are not Null or $Failed (MeltingCurves from qPCR) *)
				Automatic|All,
				{
					PickList[standardMeltingDataSets,standardDataSetCurves,Except[Null|$Failed]],Cases[standardDataSetCurves,Except[Null|$Failed]]
				},
				(* If a specific list of fields is inquired using DataSets *)
				{nestedFieldP..},
				{
					Sequence@@inquireDataSets[thermoPacket,listedDataSets]
				}
			],
		$Failed,
		Error::InvalidOption
	];

	(* The test to check if all dataset fields were found in the input packet *)
	inquireDataSetTest=If[collectTestsBoolean,
		If[inquireDataSetResult===$Failed,
			Test["All dataset fields were found in the input.", True, False],
			Test["All dataset fields were found in the input.", True, True]
		],
		{}
	];

	(* If not gathering tests, exit with an error if one or more dataset fields were not found *)
	If[showMessages&&inquireDataSetResult===$Failed,
		Return[ConstantArray[$Failed,6]]
	];

	(* True if the melting curve dataset is a 2D/3D dataset with temperature coordinates *)
	validDataSetQ=If[
		MatchQ[{resolvedTemperatureDataSet,resolvedResponseDataSet},{Null,Null}],
		Map[
			(
				MatchQ[#,temperature2DCoordinatesP] ||
				(MatchQ[#,_?QuantityArrayQ] && MatchQ[Units[#],temperature2DCoordinatesP]) ||
				MatchQ[#,temperature3DCoordinatesP] ||
				(MatchQ[#,_?QuantityArrayQ] && MatchQ[Units[#],temperature3DCoordinatesP])
			)&,
			resolvedMeltingCurves
		],
		(* True if TemperatureDataSet and ResponseDataSet are resolved to non Null *)
		True
	];

	(* Get the indices of any invalid input datasets *)
	invalidDataSetIndices=Flatten@Position[validDataSetQ,False];

	(* Test if the resolved melting curve has the valid coordinate pattern *)
	validDataSetTest=If[collectTestsBoolean,
		Test["Melting curve is a valid list of coordinates with temperature as one of the independent variables.",
			Count[validDataSetQ,False]>0,
			False
		],
		{}
	];

	(* Error and return if melting curve is not a valid list of quantities with temperature as the x-coordinate *)
	If[showMessages&&Count[validDataSetQ,False]>0,
		Message[Error::InvalidDataSet,thisObject,resolvedDataSets[[invalidDataSetIndices]]];
		Message[Error::InvalidOption,DataSet];
		Return[ConstantArray[$Failed,6]]
	];

	(* All 3D melting curves *)
	meltingCurves3D=If[
		MatchQ[{resolvedTemperatureDataSet,resolvedResponseDataSet},{Null,Null}],
		MapThread[
			If[( MatchQ[#2,temperature3DCoordinatesP] || (MatchQ[#2,_?QuantityArrayQ] && MatchQ[Units[#2],temperature3DCoordinatesP]) ),#1->#2,Nothing]&,
			{resolvedDataSets,resolvedMeltingCurves}
		],
		(* {} if TemperatureDataSet and ResponseDataSet are resolved to non Null *)
		{}
	];

	(* All 2D melting curves *)
	meltingCurves2D=If[
		MatchQ[{resolvedTemperatureDataSet,resolvedResponseDataSet},{Null,Null}],
		MapThread[
			If[( MatchQ[#2,temperature2DCoordinatesP] || (MatchQ[#2,_?QuantityArrayQ] && MatchQ[Units[#2],temperature2DCoordinatesP]) ),#1->#2,Nothing]&,
			{resolvedDataSets,resolvedMeltingCurves}
		],
		(* {} if TemperatureDataSet and ResponseDataSet are resolved to non Null *)
		{}
	];

	(* Check if there are any 3D curves in the object *)
	threeDCurvesExistsBool=!(meltingCurves3D==={});
	threeDCurvesTest=If[collectTestsBoolean,
		If[!threeDCurvesExistsBool,
			If[!MatchQ[meltingCurves2D,{}],
				Test["There is at least one 2D curve.", True, True]
			],
			Test["There is at least one 3D curve.", True, True]
		],
		{}
	];

	(* Try to get the melting or cooling or aggregation curves *)
	meltingCurve3D=Lookup[thermoPacket,MeltingCurve3D,$Failed];
	coolingCurve3D=Lookup[thermoPacket,CoolingCurve3D,$Failed];
	aggregationCurve3D=Lookup[thermoPacket,AggregationCurve3D,$Failed];

	(* <<< Resolving Wavelength >>> *)

	(* In case of fluoresenceSpectraDataQ, then the wavelength should be Automatic *)
	wavelength=If[threeDCurvesExistsBool || fluoresenceSpectraDataQ,
		Replace[Lookup[listedOptions, Wavelength, Automatic],Null->Automatic],
		Lookup[listedOptions, Wavelength, Null]
	];

	(* Get all wavelengths of either the melting or cooling curve, if any is available. *)
	allWavelengths=Which[
		meltingCurves3D==={},{},
		MemberQ[meltingCurves3D,MeltingCurve3D],Union[Round[Analysis`Private`unitsAndMagnitudes[meltingCurve3D][[2]][[;;,2]],0.000001]],
		MemberQ[meltingCurves3D,CoolingCurve3D],Union[Round[Analysis`Private`unitsAndMagnitudes[coolingCurve3D][[2]][[;;,2]],0.000001]],
		True,Union[Round[Analysis`Private`unitsAndMagnitudes[First@Values[meltingCurves3D]][[2]][[;;,2]],0.000001]]
	];

	(* The wavelength used in the static light scattering instrument *)
	slsWavelengths=Lookup[thermoPacket,StaticLightScatteringExcitation,Null];

	(* Helper functions to turn wavelength option input into a list of valid wavelengths *)
	resolveWavelengthInput[Automatic,myAllWavelengths_List,myPacket:PacketP[Object[Data,MeltingCurve]]] := Module[{peakWavelength,mySpanStartUnitless,mySpanEndUnitless},
		(* Get the start and end based on the PeakWavelength parameter and send to the span version of resolveWavelengthInput *)
		(* For the case of fluoresence spectra analysis, PeakWavelength will be Null *)
		peakWavelength=Lookup[myPacket,PeakWavelength,Null];
		{mySpanStartUnitless,mySpanEndUnitless}=Switch[peakWavelength,
			GreaterP[0*Nanometer],{peakWavelength-10 Nanometer,peakWavelength+ 10 Nanometer},
			Null,{300 Nanometer,450 Nanometer}
		];
		resolveWavelengthInput[mySpanStartUnitless;;mySpanEndUnitless,myAllWavelengths,myPacket]
	];
	resolveWavelengthInput[myWavelengthRange_Span,myAllWavelengths_List,myPacket:PacketP[Object[Data,MeltingCurve]]] := Module[{mySpanStartUnitless,mySpanEndUnitless},
		(* This is the main function that does the most work *)
		(* First round the start and end wavelengths of the specified range and then select all wavelengths that are within the range *)
		mySpanStartUnitless=Round[QuantityMagnitude[First[myWavelengthRange]], 0.000001];
		mySpanEndUnitless=Round[QuantityMagnitude[Last[myWavelengthRange]], 0.000001];
		Cases[myAllWavelengths, _?(mySpanStartUnitless <= # <= mySpanEndUnitless &)]
	];
	(* For Ratio transoformation function, the wavelength is a pair value {wavelength1,wavelength2} *)
	resolveWavelengthInput[myWavelengthRange: ConstantArray[UnitsP[],2],myAllWavelengths_List,myPacket:PacketP[Object[Data,MeltingCurve]]]:=
		Module[{myStartUnitless,myEndUnitless},
			myStartUnitless=
				If[MatchQ[Units[First[myWavelengthRange]],1],
					Round[First[myWavelengthRange], 0.000001],
					Round[Unitless[First[myWavelengthRange]], 0.000001]
				];
			myEndUnitless=
				If[MatchQ[Units[Last[myWavelengthRange]],1],
					Round[Last[myWavelengthRange], 0.000001],
					Round[Unitless[Last[myWavelengthRange]], 0.000001]
				];
			{myStartUnitless,myEndUnitless}
		];
	(* 2D data option gives nothing *)
	resolveWavelengthInput[Null,myAllWavelengths_List,myPacket:PacketP[Object[Data,MeltingCurve]]]:={};
	resolveWavelengthInput[All,myAllWavelengths_List,myPacket:PacketP[Object[Data,MeltingCurve]]] := myAllWavelengths;
	(* Get a single wavelength by setting the starting and ending wavelengths of the span to be the same *)
	resolveWavelengthInput[myWavelength_Quantity,myAllWavelengths_List,myPacket:PacketP[Object[Data,MeltingCurve]]] := resolveWavelengthInput[myWavelength;;myWavelength,myAllWavelengths,myPacket];
	(* Get a list of two quantities for wavelength by setting the starting and ending wavelengths of the span to be the same *)
	resolveWavelengthInput[myWavelength_{Quantity,Quantity},myAllWavelengths_List,myPacket:PacketP[Object[Data,MeltingCurve]]] := resolveWavelengthInput[myWavelength[[1]];;myWavelength[[2]],myAllWavelengths,myPacket];

	(* Get the valid wavelengths *)
	resolvedWavelengths=resolveWavelengthInput[wavelength,allWavelengths,thermoPacket];

	(* If wavelength is Null, or if Temperature and Response DataSet are resolved to non Null, or if all of the resolvedDataSets are 2D, just use the default 2D. *)
	{use2DDataQ,use2DDataQTests}=If[MatchQ[wavelength,Null] || !MatchQ[{resolvedTemperatureDataSet,resolvedResponseDataSet},{Null,Null}],

		If[collectTestsBoolean,
			{True,Test["Only 2D datasets are analyzed.", True, True]},
			{True,{}}
		],

		(* Make sure a 3D field exists. *)
		If[!threeDCurvesExistsBool,
			If[collectTestsBoolean,
				{True,{threeDCurvesTest}},
				Message[Warning::ObjectDoesNotContain3DCurves];
				{True,{}}
			],
			Module[
				{
					minValidWavelength,maxValidWavelength,
					allWavelengthsOutOfRangeBool,allWavelengthsOutOfRangeTest,someWavelengthsOutOfRangeBool,someWavelengthsOutOfRangeTest
				},

				minValidWavelength=First[allWavelengths];
				maxValidWavelength=Last[allWavelengths];

				(* Check if all or part of the wavelengths are out of range *)
				allWavelengthsOutOfRangeBool=Length[resolvedWavelengths]===0;
				allWavelengthsOutOfRangeTest=If[allWavelengthsOutOfRangeBool,
					Test["There is at least one valid user-specified wavelength.", True, False],
					Test["There is at least one valid user-specified wavelength.", True, True]
				];

				(* Can only have some out of range if user specified a range *)
				someWavelengthsOutOfRangeBool=MatchQ[Head[wavelength],Span]&&(QuantityMagnitude[First[wavelength]] < minValidWavelength || QuantityMagnitude[Last[wavelength]] > maxValidWavelength);
				someWavelengthsOutOfRangeTest=If[someWavelengthsOutOfRangeBool,
					Warning["All user-specified wavelengths are valid.", True, False],
					Warning["All user-specified wavelengths are valid.", True, True]
				];

				Which[

					(* If there is only AggregationCurve3D *)
					SubsetQ[{AggregationCurve3D},resolvedDataSets],
					{False,{threeDCurvesTest}},

					allWavelengthsOutOfRangeBool,
					If[collectTestsBoolean,
						{True,{allWavelengthsOutOfRangeTest,threeDCurvesTest}},
						Message[Warning::AllWavelengthsOutOfRange, minValidWavelength, maxValidWavelength];
						{True,{}}
					],
					someWavelengthsOutOfRangeBool,
					If[collectTestsBoolean,
						{False,{someWavelengthsOutOfRangeTest,allWavelengthsOutOfRangeTest,threeDCurvesTest}},
						Message[Warning::SomeWavelengthsOutOfRange, minValidWavelength, maxValidWavelength];
						{False,{}}
					],
					True,
					If[collectTestsBoolean,
						{False,{someWavelengthsOutOfRangeTest,allWavelengthsOutOfRangeTest,threeDCurvesTest}},
						{False,{}}
					]
				]
			]
		]
	];

	(* Find the position of 2D melting curves in the dataset *)
	twoDDataSetsPosition=Flatten@(Position[resolvedDataSets,#]& /@ DeleteDuplicates[Keys[meltingCurves2D]]);

	(* If the wavelength is not specified properly, 3D dataSets can not be transformed *)
	transformableResolvedDataSets=If[use2DDataQ,
		(* If there are only 3D plots, use resolvedDataSets *)
		If[!MatchQ[meltingCurves3D,{}] && SubsetQ[Keys[meltingCurves3D],resolvedDataSets],
			resolvedDataSets,
			(resolvedDataSets[[#]]& /@ twoDDataSetsPosition)
		],
		resolvedDataSets
	];

	(* If the wavelength is not specified properly, 3D melting curves can not be transformed *)
	transformableResolvedMeltingCurves=If[use2DDataQ,
		(* If there are only 3D plots, use resolvedMeltingCurves *)
		If[!MatchQ[meltingCurves3D,{}] && SubsetQ[Keys[meltingCurves3D],resolvedDataSets],
			resolvedMeltingCurves,
			(resolvedMeltingCurves[[#]]& /@ twoDDataSetsPosition)
		],
		resolvedMeltingCurves
	];

	(* <<< Resolve Transformation Functions >>> *)

	(* Helper function: apply a transformation function if it is valid, do nothing if None *)
	applyTransformHelper[f:_Function|None,val_]:=If[MatchQ[f,None],val,f[val]];

	(* Object fields that store temperature information *)
	{temperatureTransformationFunction,responseTransformationFunction}=
		Lookup[listedOptions,{TemperatureTransformationFunction,ResponseTransformationFunction}];

	(* Warn if TemperatureTransformationFunction is set but the TemperatureDataSet and ResponseDataSet is set to Null*)
	If[MatchQ[{resolvedTemperatureDataSet,resolvedResponseDataSet},{Null,Null}]&&!MatchQ[temperatureTransformationFunction,None],
		Message[Warning::UnusedTemperatureTransformation]
	];

	(* Warn if ResponseTransformationFunction is set but the TemperatureDataSet and ResponseDataSet is set to Null*)
	If[MatchQ[{resolvedTemperatureDataSet,resolvedResponseDataSet},{Null,Null}]&&!MatchQ[responseTransformationFunction,None],
		Message[Warning::UnusedResponseTransformation]
	];

	(* Apply transformation to the TemperatureDataSet or Null if no transformation *)
	transformedTemperatureData=applyTransformHelper[temperatureTransformationFunction,temperatureData];

	(* Apply transformation to the ResponseDataSet or Null if no transformation *)
	transformedResponseData=applyTransformHelper[responseTransformationFunction,responseData];

	(* True if the transformed temperature dataset is a valid list with temperature units *)
	validTransformedTempretureDataSetQ=If[
		!MatchQ[{resolvedTemperatureDataSet,resolvedResponseDataSet},{Null,Null}],
		MatchQ[transformedTemperatureData,temperatureListP] || (MatchQ[transformedTemperatureData,_?QuantityArrayQ] && MatchQ[Units[transformedTemperatureData],temperatureListP]),
		(* True, if Temperature and Response DataSet are resolved to Null*)
		True
	];

	(* Test if the resolved transformed melting curve has the valid coordinate pattern *)
	validTransformedTempretureDataSetTest=If[collectTestsBoolean,
		Test["Transformed transformed temperature is a valid list with temperature units.",
			validTransformedTempretureDataSetQ===False,
			False
		],
		{}
	];

	(* Error and return if transformed melting curve is not a valid list of quantities with temperature as the x-coordinate *)
	If[showMessages&&validTransformedTempretureDataSetQ===False,
		Message[Error::InvalidTransformedTemperature,thisObject];
		Message[Error::InvalidOption,TemperatureTransformationFunction];
		Return[ConstantArray[$Failed,6]]
	];

	(* True if the transformed temperature dataset is a valid list with temperature units *)
	validTransformedResponseDataSetQ=If[
		!MatchQ[{resolvedTemperatureDataSet,resolvedResponseDataSet},{Null,Null}],
		MatchQ[transformedResponseData,responseListP] || (MatchQ[transformedResponseData,_?QuantityArrayQ] && MatchQ[Units[transformedResponseData],responseListP]),
		(* True, if Temperature and Response DataSet are resolved to Null*)
		True
	];

	(* Test if the resolved transformed melting curve has the valid coordinate pattern *)
	validTransformedResponseDataSetTest=If[collectTestsBoolean,
		Test["Transformed transformed temperature is a valid list of with temperature units.",
			validTransformedResponseDataSetQ===False,
			False
		],
		{}
	];

	(* Error and return if transformed melting curve is not a valid list of quantities with temperature as the x-coordinate *)
	If[showMessages&&validTransformedResponseDataSetQ===False,
		Message[Error::InvalidTransformedResponse,thisObject];
		Message[Error::InvalidOption,ResponseTransformationFunction];
		Return[ConstantArray[$Failed,6]]
	];

	(* Combine the temperature and the response to make the final dataset *)
	transformedTemperatureResponseData=Switch[{transformedTemperatureData,transformedResponseData},

		(* If TemperatureDataSet and ResponseDataSet are resolved to Null set the data to Null *)
		{Null,Null},
		Null,

		(* If TemperatureDataSet and ResponseDataSet are resolved to non Null combine the corresponding data *)
		{Except[Null],Except[Null]},
		Module[{unitlessTemperatureData,unitlessResponseData},

			temperatureUnit=Units[transformedTemperatureData[[1]]];

			responseUnit=Units[transformedResponseData[[1]]];

			(* Converting the units to the unit of the first element and then making unitless *)
			unitlessTemperatureData=Unitless[transformedTemperatureData,temperatureUnit];

			(* Converting the units to the unit of the first element and then making unitless *)
			unitlessResponseData=Unitless[transformedResponseData,responseUnit];

			QuantityArray[Transpose[{unitlessTemperatureData,unitlessResponseData}],{temperatureUnit,responseUnit}]

		]
	];

	dataSetTransformationFunctions=Lookup[listedOptions,DataSetTransformationFunction];

	(* If TemperatureDataSet and ResponseDataSet are resolved to non Null, make sure dataSetTransformationFunctions is listed *)
	listedDataSetTransformationFunctions=Which[
		(* If TemperatureDataSet and ResponseDataSet are resolved to Null set the dataSetTransformationFunctions to Null *)
		!MatchQ[{resolvedTemperatureDataSet,resolvedResponseDataSet},{Null,Null}],
		Null,

		(* Don't put it in a list if Automatic is chosen for DataSetTransformationFunction *)
		MatchQ[dataSetTransformationFunctions,Automatic],
		Automatic,

		(* Keep the listed form if it is already expanded *)
		MatchQ[dataSetTransformationFunctions,_List],
		dataSetTransformationFunctions,

		(* Otherwise expand the option to be listed *)
		MatchQ[dataSetTransformationFunctions,Except[Automatic]],
		ConstantArray[dataSetTransformationFunctions,Length[transformableResolvedDataSets]]
	];

	(* If TemperatureDataSet and ResponseDataSet are resolved to Null throw a warning *)
	If[
		!MatchQ[{resolvedTemperatureDataSet,resolvedResponseDataSet},{Null,Null}]&&!MatchQ[dataSetTransformationFunctions,Automatic|Null],
		Message[Warning::UnusedDataSetTransformation]
	];

	(* Checks if the transformation functions have the same length as the fields *)
	validDataSetTransformationFunctionsQ=
		Switch[{listedDataSets,listedDataSetTransformationFunctions},
			(* True if TemperatureDataSet and ResponseDataSet are resolved to Null *)
			{Null,Null}, True,
			(* True if both of them are Automatic *)
			{Automatic|All,Automatic}, True,
			(* True if Transformation is Automatic even if the dataset is customized *)
			{{nestedFieldP..},Automatic},True,
			(* The length of the transformation should match that of dataset field *)
			{{nestedFieldP..},Except[Automatic]},Length[listedDataSetTransformationFunctions] === Length[transformableResolvedDataSets]
		];

	(* Test if the resolved transformed melting curve has the valid coordinate pattern *)
	validDataSetTransformationFunctionsTest=If[collectTestsBoolean,
		Test["DataSetTransformationFunctions should match the length of the provided DataSet.",
			validDataSetTransformationFunctionsQ,
			True
		],
		{}
	];

	(* If not gathering tests, exit with an error if the standard units are inconsistent *)
	If[showMessages&&!validDataSetTransformationFunctionsQ,
		Message[Error::NonMatchingTransformationFunction,thisObject];
		Message[Error::InvalidOption,DataSetTransformationFunction];
		Return[ConstantArray[$Failed,6]]
	];

	(* If the wavelength is not specified properly, 3D melting curves can not be transformed *)
	transformableDataSetTransformationFunctions=If[use2DDataQ,
		Switch[listedDataSetTransformationFunctions,
			(* Null if TemperatureDataSet and ResponseDataSet are resolved to Null *)
			Null,
			Null,

			(* Remains Automatic if the whole datasets should be treated automatically *)
			Automatic,
			Automatic,

			(* Only 2D datasets are taken if not automatic *)
			Except[Automatic],
			(* If there are only 3D plots, use listedDataSetTransformationFunctions *)
			If[!MatchQ[meltingCurves3D,{}] && SubsetQ[Keys[meltingCurves3D],resolvedDataSets],
				listedDataSetTransformationFunctions,
				(listedDataSetTransformationFunctions[[#]]& /@ twoDDataSetsPosition)
			]
		],
		listedDataSetTransformationFunctions
	];

	(* Helper function: performs automatic transformation based on the dataset *)
	automaticTransformationHelper[dataSet_,meltingCurve_]:=
		Which[
			(* No transformation for 2D data *)
			MemberQ[Keys[meltingCurves2D],dataSet],
			{None,dataSet,None,meltingCurve},

			(* If 3D and data from MultimodeSpectrophotometer and specifically from static light scattering *)
			(MemberQ[Keys[meltingCurves3D],dataSet] && fluoresenceSpectraDataQ && StringContainsQ[SymbolName[dataSet],"Aggregation"]),
			Sequence@@(groupByWavelengthTransformHelper[dataSet,meltingCurve]),

			(* If 3D and data from MultimodeSpectrophotometer *)
			(MemberQ[Keys[meltingCurves3D],dataSet] && fluoresenceSpectraDataQ),
			{BarycentricMean,dataSet,BarycentricMean,barycentricMeanTransformHelper[meltingCurve,resolvedWavelengths]},

			(* If 3D and data from MultimodeSpectrophotometer *)
			(MemberQ[Keys[meltingCurves3D],dataSet] && !fluoresenceSpectraDataQ),
			{Sum,dataSet,Sum,sumTransformHelper[meltingCurve,resolvedWavelengths]}
		];

	(* Transformation results for all melting curves *)
	meltingTransformationResults=Transpose[Switch[transformableDataSetTransformationFunctions,

		(* Null if TemperatureDataSet and ResponseDataSet are resolved to Null *)
		Null,
		{{},{},{},{}},

		(* Default only takes the standardMeltingDataSets that are not Null *)
		Automatic,
		MapThread[
			automaticTransformationHelper[#1,#2]&,
			{transformableResolvedDataSets,transformableResolvedMeltingCurves}
		],

		(* Transformation is applied directly to the resolvedMeltingCurves if None *)
		Except[Automatic],
		MapThread[
			Which[
				(* The transformation is given but is set to Automatic *)
				MatchQ[#3,Automatic],
				automaticTransformationHelper[#1,#2],

				(* The transformation is given and is GroupByWavelength *)
				(* kjhou 11/3 hotfix: from what I can tell, the aggregation curve fields should always be grouped by wavelength *)
				(* The other transformation functions fail on these data fields, so for the time being they will always default to this helper *)
				StringContainsQ[SymbolName[#1],"Aggregation"]&&MatchQ[Last[Dimensions[#2]],3],Sequence@@groupByWavelengthTransformHelper[#1,#2],

				(* The transformation is given and is None *)
				MatchQ[#3,None],{None,#1,None,#2},

				(* No transformation for 2D data *)
				MemberQ[Keys[meltingCurves2D],#1] && MatchQ[#3,Sum|BarycentricMean|Ratio],
				Message[Warning::IncompatibleTransformation,thisObject,#1];{None,#1,None,#2},

				(* The transformation is given and is Sum *)
				MatchQ[#3,Sum],{Sum,#1,Sum,sumTransformHelper[#2,resolvedWavelengths]},

				(* The transformation is given and is BarycentricMean *)
				MatchQ[#3,BarycentricMean],{BarycentricMean,#1,BarycentricMean,barycentricMeanTransformHelper[#2,resolvedWavelengths]},

				(* The transformation is given and is Ratio *)
				MatchQ[#3,Ratio],{Ratio,#1,Ratio,ratioTransformHelper[#2,resolvedWavelengths]},

				(* The transformation is given and is GroupByWavelength *)
				MatchQ[#3,GroupByWavelength],Sequence@@groupByWavelengthTransformHelper[#1,#2],

				(* Any valid transformation function is given and is not Automatic, None, Sum, BarycentricMean *)
				True,{#3,#1,#3,applyTransformHelper[#3,#2]}
			]&,
			{transformableResolvedDataSets,transformableResolvedMeltingCurves,transformableDataSetTransformationFunctions}
		]

	]];

	(* Inquired (or automatic) transformation functions in the thermoPacket remove duplicates of GroupByWavelength after splitting *)
	resolvedTransformationFunctions=If[MatchQ[meltingTransformationResults,{}],
		(* Null if TemperatureDataSet and ResponseDataSet are resolved to Null *)
		Null,
		Module[{splittedList},
			(* Splitting to groups so all duplicates are placed in one list *)
			splittedList=Split[meltingTransformationResults[[1]]];
			Flatten@Map[
				(* Only adding one GroupByWavelength for all wavelengths *)
				If[MatchQ[#,{GroupByWavelength..}],
					GroupByWavelength,
					#
				]&,
				splittedList
			]
		]
	];

	(* Inquired (or automatic) transformed DataSet *)
	resolvedTransformedDataSets=If[MatchQ[meltingTransformationResults,{}],
		(* Null if TemperatureDataSet and ResponseDataSet are resolved to Null *)
		Null,
		meltingTransformationResults[[2]]
	];

	(* Inquired (or automatic) transformation functions in the thermoPacket *)
	resolvedTransformedTransformationFunctions=If[MatchQ[meltingTransformationResults,{}],
		(* Null if TemperatureDataSet and ResponseDataSet are resolved to Null *)
		Null,
		meltingTransformationResults[[3]]
	];

	(* Inquired (or automatic) transformed melting curves in the thermoPacket *)
	resolvedTransformedMeltingCurves=If[MatchQ[meltingTransformationResults,{}],
		(* Null if TemperatureDataSet and ResponseDataSet are resolved to Null *)
		Null,
		meltingTransformationResults[[4]]
	];

	(* True if the transformed melting curve dataset is a 2D dataset with temperature coordinates *)
	validTransformedDataSetQ=
		Map[
			( MatchQ[#,temperature2DCoordinatesP] || (MatchQ[#,_?QuantityArrayQ] && MatchQ[Units[#],temperature2DCoordinatesP]) )&,
			resolvedTransformedMeltingCurves
		];

	(* Get the indices of any invalid transformed input datasets *)
	invalidTransformedDataSetIndices=Flatten@Position[validTransformedDataSetQ,False];

	(* Test if the resolved transformed melting curve has the valid coordinate pattern *)
	validTransformedDataSetTest=If[collectTestsBoolean,
		Test["Transformed melting curve is a valid list of coordinates with temperature as one of the independent variables.",
			Count[validTransformedDataSetQ,False]>0,
			False
		],
		{}
	];

	(* Error and return if transformed melting curve is not a valid list of quantities with temperature as the x-coordinate *)
	If[showMessages&&Count[validTransformedDataSetQ,False]>0,
		Message[Error::InvalidTransformationFunction,thisObject,resolvedTransformedDataSets[[invalidTransformedDataSetIndices]]];
		Message[Error::InvalidOption,DataSetTransformationFunction];
		Return[ConstantArray[$Failed,6]]
	];

	(* To avoid naming clashes, duplicate datasets are found and renamed to ASet1 ASet2 etc. *)

	(* Helper Function: to find the position of the duplicates in the resolvedDataSet list *)
	positionDuplicatesHelper[list_] := GatherBy[Range@Length[list], list[[#]] &];

	(* Helper Function: to rename the duplicates element of the list using ASet1 ASet2 etc. *)
	renameDuplicatesHelper[list_] :=
		Flatten@Map[
			Function[duplicateList,
				(* The list contains duplicated elements *)
				If[Length[duplicateList]>1,
					MapIndexed[
						Symbol[SymbolName[#1] <> "Set" <> ToString[First[#2]]] &,
						duplicateList
					],
					duplicateList
				]
		  ],
		 	Split[list]
		];

	(* Rename the transformed datasets that have the same names *)
	positionInDataSet=positionDuplicatesHelper[resolvedTransformedDataSets];

	(* Reordered datasets based on the grouping and the number of duplicates *)
	{
		reorderedResolvedTransformedDataSets,
		reorderedResolvedTransformedTransformationFunctions,
		reorderedResolvedTransformedMeltingCurves
	}=
	If[
		MatchQ[{resolvedTemperatureDataSet,resolvedResponseDataSet},{Null,Null}],
		Transpose@Map[
			{
				resolvedTransformedDataSets[[#]],
				resolvedTransformedTransformationFunctions[[#]],
				resolvedTransformedMeltingCurves[[#]]
			}&,
			Flatten[positionInDataSet]
		],
		(* Null if TemperatureDataSet and ResponseDataSet are resolved to non Null *)
		{Null,Null,Null}
	];

	(* Renaming the duplicates found in positionInDataSet *)
	safeDuplicatesResolevedTransformedDataSet=If[
		MatchQ[{resolvedTemperatureDataSet,resolvedResponseDataSet},{Null,Null}],
		renameDuplicatesHelper[reorderedResolvedTransformedDataSets],
		(* Null if TemperatureDataSet and ResponseDataSet are resolved to non Null *)
		Null
	];

	(* The rules to return to resolve inputs *)
	resultPacket=If[
		MatchQ[{resolvedTemperatureDataSet,resolvedResponseDataSet},{Null,Null}],
		Association@MapThread[
			Switch[#2,
				(* If there is no transformation, don't change the final dataset name *)
				None,(#1->#3),
				(* If the data was transformed, add a prefix to the dataset name *)
				Except[None],Symbol["Transformed"<>SymbolName[#1]]->#3
			]&,
			{safeDuplicatesResolevedTransformedDataSet,reorderedResolvedTransformedTransformationFunctions,reorderedResolvedTransformedMeltingCurves}
		],
		(* If TemperatureDataSet and ResponseDataSet are resolved to non Null *)
		<|
			MeltingCurve->transformedTemperatureResponseData
		|>
	];

	allTests=Join[{
		use2DDataQTests,
		validTemperatureFieldTest,
		validResponseFieldTest,
		inquireDataSetTest,
		validDataSetTest,
		threeDCurvesTest,
		validTransformedTempretureDataSetTest,
		validTransformedResponseDataSetTest,
		validDataSetTransformationFunctionsTest,
		validTransformedDataSetTest
	}];

	output/.{Result->{resolvedTemperatureDataSet,resolvedResponseDataSet,resolvedDataSets,resolvedTransformationFunctions,resultPacket,reorderedResolvedTransformedTransformationFunctions},Tests->allTests}
];

(* Null inputs and outputs *)
thermoCurveCoordinatesRules[_,resultOps_]:=Module[{output,listedOutput},
	(* Get the user requested output *)
	output=resultOps;
	listedOutput=ToList[output];
	output/.{Result->{MeltingCurve->Null,CoolingCurve->Null},Tests->{}}
];
thermoCurveCoordinatesRules[_]:={MeltingCurve->Null,CoolingCurve->Null};

(* <<< Helper function to transform melting curve 3D to a 2D curve for finding the melting temperature >>> *)
(* Inputs:
	data3D: the unitless 3 dimensional inputs
	wavelengths: the wavelength range which is used to transform 3D results to 2D
*)
sumTransformHelper[data3D_, wavelengths_] := Module[
	{unitlessData3D,units,allWavelengths, wlPositions, selectedData, groupedByWavelength, groupedVals},

	(* Unitless data *)
	unitlessData3D=QuantityMagnitude[data3D];
	(* Units of the data *)
	units=Units[data3D[[1]]];

	(* part slice is faster than Transpose *)
	allWavelengths=Round[unitlessData3D[[;;,2]],0.000001];
	(* position + Extract is faster than Select *)
	wlPositions=Position[allWavelengths, Alternatives@@wavelengths];

	selectedData=Extract[unitlessData3D, wlPositions];
	(* Group the selected data by their wavelength, extracting only the temperatures and absorbance values *)

	groupedByWavelength=GroupBy[selectedData, #[[2]] &, #[[;; , {1, 3}]] &];

	groupedVals=Values[groupedByWavelength];
	QuantityArray[
		Transpose[{First /@ (Transpose[groupedVals][[;; , 1]]), Last /@ Total[groupedVals]}],units[[1;;3;;2]]
	]
];

(* <<< Helper function for barycentricMean transform melting curve 3D to a 2D curve for finding the melting temperature >>> *)
(* Inputs:
	data3D: the unitless 3 dimensional inputs
	wavelengths: the wavelength range which is used to transform 3D results to 2D
*)
barycentricMeanTransformHelper[data3D_, wavelengths_] := Module[
	{
		allWavelengths, wlPositions, selectedData,units,uniqueTemperatures,groupedByTemperature,
		groupedWavelengths,groupedIntensities,barycentricMean,unitlessData3D
	},

	(* Return with Null if the wavelength does not contain more than 2 entries *)
	If[Length[wavelengths]<=2,Return[Null]];

	(* Unitless data *)
	unitlessData3D=QuantityMagnitude[data3D];

	(* Units of the data *)
	units=Units[data3D[[1]]];

	(* Finding all wavelength values *)
	allWavelengths=Round[unitlessData3D[[;;,2]],0.000001];

	(** Note: position + Extract is faster than Select **)
	wlPositions=Position[allWavelengths, Alternatives@@wavelengths];
	selectedData=Extract[unitlessData3D, wlPositions];

	(* Group data based on the temperature *)
	groupedByTemperature = GatherBy[selectedData, First];
	uniqueTemperatures = Flatten[groupedByTemperature[[All, 1, 1]]];
	groupedWavelengths=groupedByTemperature[[All, All, 2]];
	groupedIntensities=groupedByTemperature[[All, All, 3]];

	(* BarycentricMean based on the grouped data *)
	barycentricMean = Total[groupedWavelengths*groupedIntensities, {2}] / Total[groupedIntensities, {2}];

	(* The choice of ArbitraryUnit is to make the representation consistent with intensity data *)
	QuantityArray[Transpose[{uniqueTemperatures, barycentricMean}], {units[[1]],ArbitraryUnit}]
];

(* <<< Helper function for ratio transform melting curve 3D to a 2D curve for finding the melting temperature >>> *)
(* Inputs:
	data3D: the unitless 3 dimensional inputs
	wavelengths: the wavelength range which is used to transform 3D results to 2D
*)
ratioTransformHelper[data3D_, wavelengths_] := Module[
	{
		units,uniqueTemperatures,groupedByTemperature,myMean,numerator,denominator,
		groupedWavelengths,groupedIntensities,unitlessData3D,intensityRatio,wlPositions
	},

	(* Unitless data *)
	unitlessData3D=QuantityMagnitude[data3D];

	(* Units of the data *)
	units=Units[data3D[[1]]];

	(* Helper function to ensure that the mean of a single number is itself *)
	myMean[x_?NumericQ]:=x;
	myMean[x:{_?NumericQ..}]:=Mean[x];

	(* Group data based on the temperature *)
	groupedByTemperature=GatherBy[unitlessData3D,First];

	(* A signle list of temperature for the whole data *)
	uniqueTemperatures=Flatten[groupedByTemperature[[All,1,1]]];

	(* The wavelength list corresponding with each temperature *)
	groupedWavelengths=groupedByTemperature[[All,All,2]];

	(* The intensity list corresponding with each temperature *)
	groupedIntensities=groupedByTemperature[[All,All,3]];

	(* The numerator and denominator are the first and last components of the wavelength *)
	{numerator,denominator}=wavelengths[[1;;2]];

	(* For each temperature, the position of the datapoint that has the wavelength closest to numerator and denominator *)
	wlPositions=Flatten@Nearest[#->"Index",{numerator,denominator}] & /@ groupedWavelengths;

	(* The ratio of the intensity at the two wavelengths - if two values are returned for the position, the average of intensity is taken *)
	intensityRatio=MapThread[
		If[!MatchQ[#2,{}],
	    (myMean[#1[[Last[#2]]]]/myMean[#1[[First[#2]]]]),
	    Null
		]&,
	  {groupedIntensities,wlPositions}
	];

	(* The choice of ArbitraryUnit is to make the representation consistent with intensity data *)
	QuantityArray[Transpose[{uniqueTemperatures, intensityRatio}], {units[[1]],ArbitraryUnit}]
];

(* <<< Helper function for groupByWavelength transform melting curve 3D to a 2D curve for finding the melting temperature >>> *)
(* Inputs:
	data3D: the unitless 3 dimensional inputs
*)
groupByWavelengthTransformHelper[dataName_Symbol,data3D_] := Module[
	{
		unitlessList,units,groupingRules,wavelengths,groupedList,name
	},

	(* Unitless data *)
	unitlessList=QuantityMagnitude[data3D];

	(* Units of the data *)
	units=Units[data3D[[1]]];

	(* The list is grouped by the second column that is the wavelength *)
	groupingRules=GroupBy[unitlessList, #[[2]]&, #[[;; , {1, 3}]]& ];

	(* Finding wavelength values *)
	wavelengths=Keys[groupingRules];

	(* The 2D list of data points at each wavelength *)
	groupedList=Values[groupingRules];

	(* Remove 3D from the name of the dataset if it exists *)
	name=StringDelete[SymbolName[dataName],"3D"];

	MapThread[
		{GroupByWavelength,Symbol[name<>ToString[Round[#1]]],None,QuantityArray[#2,units[[1;;3;;2]]]}&,
		{wavelengths,groupedList}
	]
];


DefineOptions[resolveAnalyzeMeltingPointOptions,
	Options:>{
		{Output->Result,ListableP[Result|Tests],"Indicates the return value of the function."}
	}
];

resolveAnalyzeMeltingPointOptions[packetList_, resolvedMethod_, resolvedTemperatureDataSet_, resolvedResponseDataSet_, resolvedDataSets_, resolvedFunctions_, coordinateSets_, combinedOptions_, ops: OptionsPattern[]]:= Module[
	{
		output, listedOutput, collectTestsBoolean, partiallyResolvedOptions, resolvedOpsSets,
		allTests, domain,domainTestDescription,domainTest, actualDataSets
	},

	output=OptionDefault[OptionValue[Output]];
	listedOutput=ToList[output];
	collectTestsBoolean=MemberQ[listedOutput,Tests];

	(* In case resolvedTemperatureDataSet,resolvedResponseDataSet are not null, actual DataSet is Null. It was set to MeltingCurve just to use MeltingCurve data object. *)
	actualDataSets=MapThread[
		If[MatchQ[{#1,#2},{Null,Null}],#3,Null]&,
		{resolvedTemperatureDataSet,resolvedResponseDataSet,resolvedDataSets}
	];

	(* Replace the combinedOptions with the resolved DataSets *)
	partiallyResolvedOptions=MapThread[
		ReplaceRule[combinedOptions,{Method->#1,TemperatureDataSet->#2,ResponseDataSet->#3,DataSet->#4,DataSetTransformationFunction->#5}]&,
		{resolvedMethod,resolvedTemperatureDataSet,resolvedResponseDataSet,actualDataSets,resolvedFunctions}
	];

	(* resolve inputs and options, in form {inputs,resolvedOps} *)
	resolvedOpsSets=Map[
		resolveAnalyzeMeltingPointOptionsSingle[#[[1]],#[[2]],#[[3]]]&,
		Transpose[{packetList,coordinateSets,partiallyResolvedOptions}]
	];

	(* Check if Domain has valid span *)
	domain=Lookup[First[resolvedOpsSets],Domain];

	domainTestDescription="The left boundary is greater than or equal to the right boundary in the specified domain:";
	domainTest=analyzeMeltingPointTestOrNull[Domain, collectTestsBoolean, domainTestDescription, First[domain]<=Last[domain]];

	allTests=If[collectTestsBoolean,
		{domainTest},
		Null
	];

	output/.{Tests->allTests,Result->resolvedOpsSets}
];



resolveAnalyzeMeltingPointOptionsSingle[packet_,curves_,safeOps_List]:=Module[{},

	ReplaceRule[
		safeOps,
		{
			Domain -> resolveMeltingPointDomain[curves, Lookup[safeOps, Domain]],
			Range -> resolveMeltingPointRange[curves, Lookup[safeOps, Range]],
			SmoothingRadius -> Replace[Lookup[safeOps,SmoothingRadius],x:TemperatureP:>Unitless[x,Celsius]],
			(* TemperatureDataSet was already resolved, so just use that *)
			TemperatureDataSet -> Lookup[safeOps, TemperatureDataSet],
			(* ResponseDataSet was already resolved, so just use that *)
			ResponseDataSet -> Lookup[safeOps, ResponseDataSet],
			(* DataSet was already resolved, so just use that *)
			DataSet -> Lookup[safeOps, DataSet],
			DataSetTransformationFunction -> Lookup[safeOps, DataSetTransformationFunction],
			Method -> Lookup[safeOps, Method],
			Upload -> resolveInformOption[Lookup[safeOps,Upload],AnalyzeMeltingPoint]
		}
	]
];



analyzeMeltingPointTestOrNull[opsName_, makeTest:BooleanP, description_, expression_]:=If[makeTest,
	Test[description,expression,True],
	If[TrueQ[expression],
		Null,
		Message[Error::InvalidOption, opsName]
	]
];



resolveMeltingPointDomain[curves_, domainOps: (All | Automatic)] := resolveDomainAsOption[Flatten[DeleteCases[curves, Null], 1], domainOps];
resolveMeltingPointDomain[curves_, domain_] := Replace[domain, temp: TemperatureP :> Unitless[temp, Celsius], 1];


resolveDomainAsOption[coords_, domain: {_?NumericQ, _?NumericQ}] := domain;
resolveDomainAsOption[coords_, (All | Automatic)] := resolveDomain[coords];


resolveMeltingPointRange[curves_, rangeOps: (All | Automatic)] := resolveRangeAsOption[Flatten[DeleteCases[curves, Null], 1], rangeOps];
resolveMeltingPointRange[curves_, range_] := Replace[range, q: AbsorbanceUnitP :> Unitless[q, ArbitraryUnit], 1];


resolveRangeAsOption[coords_, range: {_?NumericQ, _?NumericQ}] := range;
resolveRangeAsOption[coords_, (All | Automatic)] := resolveRange[coords];



(* Handles Null case *)
calculateMeltingPointFields[xysID:{nestedFieldP..},xys_,xysTransform:{(None|_Symbol|_Function)..},useAlpha: BooleanP,resolvedOps:Null,dataId_,outputOptions_List]:= Module[{output},
  output=Lookup[outputOptions,Output,Result];
  output/.{Tests->{},Result->Null}
];
calculateMeltingPointFields[xysID:{nestedFieldP..},Null|{},xysTransform:{(None|_Symbol|_Function)..},_,resolvedOps_,dataId_,outputOptions_List]:= Module[{output},
	output=Lookup[outputOptions,Output,Result];
	output/.{Tests->{},Result->emptyMeltingFields[]}
];

(* Takes in multiple coordinates lists *)
calculateMeltingPointFields[xysID:{nestedFieldP..},xys:{(CoordinatesP|Null)..},xysTranfrom:{(None|_Symbol|_Function)..},useAlpha: BooleanP,resolvedOps_List,dataId_,outputOptions_List]:=Module[
	{output,listedOutput,collectTestsBool,mpPackets,mpPacketsTests,mpFields,curveNames,inds,paddedCurveNames},

	(* Check if we are collecting tests *)
	output=Lookup[outputOptions,Output,Result];
  listedOutput=ToList[output];
  collectTestsBool=MemberQ[listedOutput,Tests];

	(* Pad curveNames with Null if they are not specified in the options *)
	curveNames=xysID;
	inds=Position[xys, Except[Null], {1}, Heads -> False];
	paddedCurveNames=If[Length[inds]===Length[curveNames],
		ReplacePart[
			Table[Null, Length[xys]],
			Thread[Rule[Position[xys, Except[Null], {1}, Heads -> False], curveNames]]
		],
		Table[Null,Length[xys]]
	];

	(* Call the calculation for each of the curves *)
  {mpPackets,mpPacketsTests}=If[collectTestsBool,
    Transpose@MapThread[
      calculateMeltingPointFields[#1,useAlpha,#2,resolvedOps,dataId,outputOptions]&,
      {xys,paddedCurveNames}
    ],
    {MapThread[
      calculateMeltingPointFields[#1,useAlpha,#2,resolvedOps,dataId,outputOptions]&,
      {xys,paddedCurveNames}
    ],{}}
  ];

	mpFields=formatMeltingPointFields[mpPackets,xysID,xysTranfrom,useAlpha, dataId, resolvedOps];

  output/.{Tests->Join@@mpPacketsTests,Result->mpFields}
];

(* Used by the multiple coordinates case above *)
calculateMeltingPointFields[xy0:CoordinatesP,useAlpha: BooleanP,curveName_,resolvedOps_List,dataId_,outputOptions_List] := Module[
	{
		output,listedOutput,collectTestsBool,x,y,xdy,alpha,domain,range,xy,noDataInDomainBool,noDataInDomainTest,
		duplicatedDataPointsBool,duplicatedDataPointsTest,n,meltingPoint,sigmoidFit,sigmoidFitPrime,alphaSigmoidFit,xx,
		bestFitParams, increasingBool, xyCurve, xdyCurve,alphaCurve,meltingPointStdDev,meltingPointDist,
		meltingPointOutOfDomainBool,meltingPointOutOfDomainTest,fitPacket,xyDD,resultPacket,
		meltingPointValue,meltingPointStdDevValue,peakPack,positions,heights,meltingTransitions,
		onset,onsetPercent,meltingOnsetPointUnitless,meltingOnsetPoint,meltingTransitionsUnitless,
		finiteDifferencesX, finiteDifferencesY, coordinatesX, derivativeCurves
	},

	(* Check if we are collecting tests *)
  output=Lookup[outputOptions,Output,Result];
  listedOutput=ToList[output];
  collectTestsBool=MemberQ[listedOutput,Tests];

  (*  <<< Data Processing >>> *)

	{domain, range, onset, onsetPercent}=Lookup[resolvedOps, {Domain, Range, MeltingOnset, MeltingOnsetPercent}];
	(* select subset of points that lie within domain AND range contstraints *)
	xy=Sort[selectInDomainAndRange[xy0, domain, range]];

	(* if no data points in the specified domain/range, then return empty packet *)
  noDataInDomainBool=MatchQ[xy, {}];
  noDataInDomainTest=If[noDataInDomainBool,
		Message[Warning::NoDataInDomainRange];
    Warning["There is at least one data point in the given domain for this curve.", True, False],
    Warning["There is at least one data point in the given domain for this curve.", True, True]
  ];
  If[noDataInDomainBool,
    Return[output/.{Tests->{noDataInDomainTest},Result->emptyMeltingFields[]}]
  ];

	(* make sure no duplicated points (there shouldn't be) *)
	xyDD=DeleteDuplicatesBy[xy,First];
  duplicatedDataPointsBool=Length[xy]>Length[xyDD];
  duplicatedDataPointsTest=If[duplicatedDataPointsBool,
    xy=xyDD;
		Message[Warning::MeltingPointBadData,curveName,If[MatchQ[dataId,ObjectP[]],"from "<>ToString[dataId],""]];
    Warning["All x-data points in this curve are unique.", True, False],
    Warning["All x-data points in this curve are unique.", True, True]
  ];

	(* <<< PreCalculation >>> *)

	(* numerical derivative of the melting curve without smoothing *)
	xdy=If[Length[xy]==1,xy,finiteDifferences2D[xy]];

	(* rescale data to range from 0-1 -- this is the 'alpha curve' *)
	alpha=RescaleY[xy, Last[CoordinateBounds[xy]], {1, 0}];

	{x, y}=Transpose[xy];
	n=Length[xy];
	increasingBool=increaseOrNot[xy, n];

	(* <<< CoreCalculation >>> *)

  	(* calculate the melting point values based on the DataProcessing and the Method *)
	{
		meltingTransitionsUnitless,
		meltingPoint,
		meltingPointDist,
		meltingPointStdDev
	}=Switch[Lookup[resolvedOps, DataProcessing],
		(* smooth data processing *)
		Smooth,

			(* xyCurve, xdyCurve, alphaCurve are calculated the same regardless of method *)

			(* smooth the xy curve to get a cleaner analysis and derivative *)
			xyCurve=gaussianSmooth1D[xy, Lookup[resolvedOps, SmoothingRadius]];

			(* use Finite Difference to calculate the derivative *)
			(*
				there are multiple ways to take the derivative.
				It was originally finiteDifferences, then switched to the MM function DerivativeFilter,
				and now switched back to finite differences so we have full control over what is happening
				(e.g. numerical order, and smoothing)
			*)
			xdyCurve=If[Length[xyCurve]===1,
				xyCurve,

				(* forward differences, first order *)
				(*Compute finite differences from the X and Y data series, and determine the derivative*)
				finiteDifferencesX = Differences[xyCurve[[ All, 1]]];
				finiteDifferencesY = Differences[xyCurve[[ All, 2]]];

				finiteDerivatives = finiteDifferencesY/finiteDifferencesX;

				(*Pull out X coordinates, drop the last one since we have one fewer derivative from taking differences *)
				coordinatesX = xyCurve[[ ;; -2, 1]];

				(*Construct the derivatives*)
				derivativeCurves = Transpose[{coordinatesX, finiteDerivatives}];

				(*Need to smooth the noisy curves after taking derivatives*)
				Lookup[AnalyzeSmoothing[derivativeCurves, EqualSpacing -> False, Upload -> False, Output -> Result], SmoothedDataPoints]
			];

			(* if the data object is qPCR we use the negative derivative *)
			xdyCurve = If[MatchQ[dataId, ObjectP[Object[Data, qPCR]]],
				(* make the y-corrdinate negative *)
				Map[
					{1,-1}*#&,
					xdyCurve
				],
				xdyCurve
			];

			alphaCurve=RescaleY[xyCurve, Last[CoordinateBounds[xyCurve]], {1, 0}];

			(* calculate key values based on the selected method *)
			Switch[Lookup[resolvedOps, Method],
				MidPoint,
					{
						Null,
						If[Length[xyCurve]==1,xyCurve[[1,1]],sigmoidMidPoint[alphaCurve, 0., 1.]],
						Null,
						Null
					},

				InflectionPoint,
					{
						Null,
						If[Length[xyCurve]==1,xyCurve[[1,1]],XAtExtremeY[xdyCurve, If[increasingBool, Max, Min]]],
						Null,
						Null
					},

				Derivative,

					peakPack=AnalyzePeaks[xdyCurve,Upload->False];
					positions=peakPack[Replace[Position]];
					heights=peakPack[Replace[Height]];
					{
						positions,
						If[Length[positions]>0,First[ positions[[ Ordering[heights,-1] ]],Null ]],
						Null,Null
					}
			],

		(* fitting a sigmoid function *)
		Fit,
			(* values regardless of method *)
			fitPacket=analyzeFitLogisticCurve[xy,curveName,XAtExtremeY[finiteDifferences2D[xy], If[increasingBool, Max, Min]]];
			{sigmoidFit, bestFitParams}=packetLookup[fitPacket, {BestFitFunction, BestFitParameters}];
			sigmoidFitPrime=D[sigmoidFit[xx], xx];
			alphaSigmoidFit=Function[Evaluate[ReplaceAll[Rescale[#, Last[CoordinateBounds[xy]], {1, 0}], # -> sigmoidFit[#]]]];
			xyCurve=Transpose[{x, sigmoidFit[x]}];
			xdyCurve=Table[{xx, sigmoidFitPrime}, {xx, x}];
			alphaCurve=Transpose[{x, alphaSigmoidFit[x]}];
			Switch[Lookup[resolvedOps, Method],
				MidPoint,
					{Null,midPointFromFunction[alphaSigmoidFit, 0., 1.],Null,Null},

				InflectionPoint,
					{meltingPointValue,meltingPointStdDevValue}=First[Cases[bestFitParams,{InflectionPoint,val_,stdDev_,___}:>{val,stdDev}]];
					{
						Null,
						meltingPointValue,
						QuantityDistribution[NormalDistribution[meltingPointValue,meltingPointStdDevValue],Celsius],
						meltingPointStdDevValue*Celsius
					}
			]

	];

	(* <<< PostCalculation >>> *)

	(* throw warning message if melting point is out of domain *)
  meltingPointOutOfDomainBool=Or[meltingPoint < First[domain], meltingPoint > Last[domain]];
  meltingPointOutOfDomainTest=If[meltingPointOutOfDomainBool,
		Message[Warning::MeltingPointOutOfDomain];
  	Warning["The calculated melting point for this curve is within domain.", True, False],
  	Warning["The calculated melting point for this curve is within domain.", True, True]
  ];


	(* The melting onset point is defined as the temperature at which we deviate certain percent away from initial asymptotic linear line *)
	meltingOnsetPointUnitless=
		If[onset,
			Quiet[
				Module[{onsetPoint},
					If[Length[xyCurve]==1,
						xyCurve[[1,1]],
						Check[
							onsetPoint=meltingOnsetPointHelper[xyCurve,meltingPoint,onsetPercent],
							Message[Warning::UncertainMeltingOnset,curveName],
							(* the sszero and dmval message have been wildly inconsistent on manifold *)
							{NonlinearModelFit::cvmit,FindRoot::lstol}
						];
						onsetPoint
					]
				],
				{NonlinearModelFit::cvmit,NonlinearModelFit::sszero,InterpolatingFunction::dmval,FindRoot::lstol,FindRoot::sszero,General::stop,Message::msgl}
			],
			Null
		];

  (* add back units *)
	meltingPoint=If[NumericQ[meltingPoint],
		N[meltingPoint] * Celsius,
		Null
	];
	If[meltingPoint < 0*Kelvin,
		meltingPoint=Null
	];

	(* Making sure that meltingTransitionsUnitless is an array of numeric values *)
	meltingTransitions=If[MatchQ[meltingTransitionsUnitless,{_?NumericQ..}],
		QuantityArray[Select[meltingTransitionsUnitless,#>0&],Celsius],
		Null
	];

	meltingOnsetPoint=If[NumericQ[meltingOnsetPointUnitless],
		N[meltingOnsetPointUnitless] * Celsius,
		Null
	];
	If[meltingOnsetPoint < 0*Kelvin,
		meltingOnsetPoint=Null
	];

	(* add derivative units back if data was qPCR because we store the data in the analysis object *)
	xdyCurve = If[MatchQ[dataId, ObjectP[Object[Data, qPCR]]],
		QuantityArray[xdyCurve, {Celsius, RFU/Celsius}],
		(* otherwise don't add units because we don't store this value *)
		xdyCurve
	];

	resultPacket=
		<|
			Derivative->xdy,
			Alpha->alpha,
			MeltingTransitions->meltingTransitions,
			MeltingPoint->meltingPoint,
			MeltingPointStandardDeviation->meltingPointStdDev,
			MeltingPointDistribution->meltingPointDist,
			XYCurve->xyCurve,
			DerivativeCurve->xdyCurve,
			AlphaCurve->alphaCurve,
			MeltingOnsetPoint->meltingOnsetPoint
	  |>;

	output/.{Tests->{noDataInDomainTest,duplicatedDataPointsTest,meltingPointOutOfDomainTest},Result->resultPacket}
];

(* Helper Function: to find the onset of melting for the melting curves *)
meltingOnsetPointHelper[xyList:{{_?NumericQ, _?NumericQ} ..}, meltingPoint_?NumericQ, Quantity[onsetPercent_?NumericQ, "Percent"]]:= Module[
	{f,fit,deflectionPoint,lowerAsymptoteyValue,a1,b1,a2,a3,xa,xb,x,xyInterpolated,root},

	(* A piecewise function to fit the initial rise of the melting curve *)
	f[x_]:= Piecewise[{
		{a1 x + b1, Min@x <= x < xa},
		{a1*xa + b1 + a2*(x - xa), xa <= x <= xb},
		{a1*xa + b1 + a2*(xb - xa) + a3*(x - xb), xb <= x <= Max@x}
	}];

	(* Fitting the data to the piecewise and estimating the first deflection as 0.2 percent lower than melting and the second as 20 percent higher *)
	(* to make sure warning message is generated, choose 0 as starting point for all parameters except xa and xb *)
	fit = NonlinearModelFit[SetPrecision[xyList, 15],{f[x]},{{a1,0}, {b1,0}, {a2,0}, {a3,0}, {xa,meltingPoint-0.2*meltingPoint}, {xb,meltingPoint+0.2*meltingPoint}},x];

	(* The point at the junction of the first two linear lines *)
	deflectionPoint = xa /. fit["BestFitParameters"];

	(* The estimated y-value of the deflection point *)
	lowerAsymptoteyValue = fit[deflectionPoint];

	(* Interpolated function to the xy list *)
	xyInterpolated = Interpolation[xyList,InterpolationOrder->1];

	(* Onset as defined based on onsetPercent deviation from the y-value of the first deflection point *) (*Method->{"Newton", "StepControl" -> "TrustRegion"}*)
	root = T /. FindRoot[xyInterpolated[T] == 0.01*onsetPercent*lowerAsymptoteyValue + lowerAsymptoteyValue, {T,deflectionPoint},Method->{"Newton", "StepControl" -> "TrustRegion"}];

	(* If a valid root is not found, return the deflection point *)
	If[root < 0 || root < deflectionPoint || root > meltingPoint,
		deflectionPoint,
		root
	]
];


(* This needs to be set if a key is added in resultPacket association above *)
emptyMeltingFields[]:=
	<|
		Derivative->Null,
		Alpha->Null,
		MeltingTransitions->Null,
		MeltingPoint->Null,
		MeltingPointStandardDeviation->Null,
		MeltingPointDistribution->Null,
		XYCurve->Null,
		DerivativeCurve->Null,
		AlphaCurve->Null,
		MeltingOnsetPoint->Null
	|>;


(* try to determine if the melting curve is increasing or decreasing, by comparing first fifth of the points to last fifth *)
increaseOrNot[xy_, n_] := Module[
	{nleft, nright, increasingBool},
	nleft=Ceiling[n / 5];
	nright=Floor[n * 4 / 5];
	increasingBool=Mean[xy[[1;;nleft, 2]]] < Mean[xy[[nright;;n, 2]]];
	increasingBool
];

(* Core overload called in AnalyzeMeltingPoint for passing curveNames *)
analyzeFitLogisticCurve[xy_, curveName_, rootguess_]:=Module[
	{xmin,xmax,ymin,ymax,expr,fitPacket},
	{{xmin,xmax},{ymin,ymax}}=CoordinateBounds[xy];
	expr=Minimum + Maximum/(1+Exp[-InflectionSlope*(#-InflectionPoint)])&;
	fitPacket=
		Quiet[
			Check[
				AnalyzeFit[xy,expr,
					StartingValues->{Minimum->ymin,Maximum->ymax-ymin,InflectionSlope->1.,InflectionPoint->rootguess},Upload->False
				],
				(**
					NOTE: Gradient method seems to give the best result in case we have a few number of datapoints
					MaxIterations is increased as in some cases 100 did not seem to reach to required accuracy, at
					the same time, AccuracyGoal is reduced as in some cases the default produced fmmp error telling
					that the required accuracy can not be achieved given MachinePrecision
				**)
				(* Rerun AnalyzeFit with adjusted parameters in case we get cvmit, sszero, or fmmp error *)
				(* Throw the warning message about the fit issue only when the ECLApplication is not Engine *)
				(
					If[!MatchQ[$ECLApplication,Engine],Message[Warning::FitIssue,curveName]];
					AnalyzeFit[xy,expr,
						StartingValues->{Minimum->ymin,Maximum->ymax-ymin,InflectionSlope->1.,InflectionPoint->rootguess},Upload->False,
						Method->Gradient,MaxIterations->1000,AccuracyGoal->4
					]
				),
				{NonlinearModelFit::cvmit,NonlinearModelFit::sszero,NonlinearModelFit::fmmp}
			],
			{NonlinearModelFit::cvmit,NonlinearModelFit::sszero,NonlinearModelFit::fmmp}
		];
	fitPacket
];

(* Overload for no curveNames used in AnalyzeQuantificationCycle *)
analyzeFitLogisticCurve[xy_, rootguess_]:=Module[
	{xmin,xmax,ymin,ymax,expr,fitPacket},
	{{xmin,xmax},{ymin,ymax}}=CoordinateBounds[xy];
	expr=Minimum + Maximum/(1+Exp[-InflectionSlope*(#-InflectionPoint)])&;
	fitPacket=AnalyzeFit[xy,expr,StartingValues->{Minimum->ymin,Maximum->ymax-ymin,InflectionSlope->1.,InflectionPoint->rootguess},Upload->False];
	fitPacket
];


formatMeltingPointPacket[packet_,Null,meltingPointFields_]:=Null;

(* combine together packet and melting point fields *)
formatMeltingPointPacket[packet_,resolvedOps_,meltingPointFields_]:=Module[
	{
		ref, inputDataObject, curvesData, instrument, outList, staticLightScatteringExcitation,
		excitationWavelength, finalInstrument, finalStatic, finalExcitation, dataMeltingCurveQ, instrumentDLSQ
	},

	inputDataObject = Lookup[packet, Object];
	instrument = Lookup[packet, Instrument, Null];
	staticLightScatteringExcitation = Lookup[packet, StaticLightScatteringExcitation, Null];
	excitationWavelength = Lookup[packet, ExcitationWavelength, Null];

	(*replace $Failed by Null in the output packet*)
	{finalInstrument, finalStatic, finalExcitation} = {instrument, staticLightScatteringExcitation, excitationWavelength}/.{$Failed->Null};

	(* format the reference link based on input data *)
	ref=Switch[inputDataObject,
		ObjectP[Object[Data, MeltingCurve]],
			{Link[inputDataObject, MeltingAnalyses]},
		ObjectP[Object[Data, qPCR]],
			{Link[inputDataObject, MeltingPointAnalyses]},
		_,
			{}
	];

	curvesData = Lookup[meltingPointFields, Replace[MeltingCurvesDataPoints]];

  (* formulate the association with the melting point fields *)
	outList = Join[
		{
			Type -> Object[Analysis, MeltingPoint],
			Instrument -> Link[finalInstrument],
			Replace[StaticLightScatteringExcitation] -> finalStatic,
			ExcitationWavelength -> finalExcitation,
			ResolvedOptions -> resolvedOps,
			Append[Reference] -> ref
		},
		ExtractRule[resolvedOps,{Method}],
		meltingPointFields
	];

	dataMeltingCurveQ = MatchQ[inputDataObject, ObjectP[Object[Data, MeltingCurve]]];
	instrumentDLSQ = MatchQ[instrument, ObjectP[Object[Instrument, DLSPlateReader]]];

	(* add extra fields if the data is from DLS MeltingCurve *)
	If[dataMeltingCurveQ && instrumentDLSQ,
		Association[Join[
			outList,
			If[Length[curvesData]==1,
				{
					Replace[DataPointsDLSAverageZDiameter] -> QuantityArray[QuantityMagnitude[First[curvesData]], {Celsius, Nanometer}]
				},
				{
					Replace[DataPointsDLSAverageZDiameter] -> QuantityArray[QuantityMagnitude[curvesData[[1]]], {Celsius, Nanometer}],
					Replace[DataPointsSLSMolecularWeights] -> QuantityArray[QuantityMagnitude[curvesData[[2]]], {Celsius, Gram / Mole}]
				}
			]
		]],
		Association[outList]
	]

];



formatMeltingPointFields[
	packets_,
	meltingCurvesID:{nestedFieldP..},
	meltingCurvesTranfrom:{(None|_Symbol|_Function)..},
	useAlpha:BooleanP,
	dataId_,
	resolvedOps_List
] := Module[
	{
		mtrans,mps,mpstddevs,mpdists, goodInds, alphas, mpMean,mpStdDev,mpDist,xycurves,
		monsets, smoothedDerivatives
	},

	(* pull values out of the packets *)
	mtrans=Lookup[packets,MeltingTransitions];
	mps=Lookup[packets,MeltingPoint];
	mpstddevs=Lookup[packets,MeltingPointStandardDeviation];
	mpdists=Lookup[packets,MeltingPointDistribution];
	alphas=Lookup[packets,Alpha];
	xycurves=Lookup[packets,XYCurve];
	monsets=Lookup[packets,MeltingOnsetPoint];
	smoothedDerivatives=Lookup[packets,Analysis`Private`DerivativeCurve];

	(* find good indices *)
	goodInds=Flatten@Position[mps,Except[Null],{1},Heads->False];

	{mpMean,mpStdDev,mpDist}=Which[
		(* no curves *)
		MatchQ[goodInds,{}],
		{Null,Null,Null},
		(* at least 1 distribution *)
		MatchQ[mpdists,Except[{Null..}]],
		Module[{vars},
			vars=Table[Unique[x],Length[goodInds]];
			Lookup[
				PropagateUncertainty[
					Evaluate[Total[vars]/Length[vars]],
					MapThread[Distributed[#1,#2]&,{vars,mpdists[[goodInds]]}],
					Output->All
				],
				{Mean,StandardDeviation,Distribution}
			]
		],
		(* no distributions *)
		True,
		{Mean[mps[[goodInds]]],Null,Null}
	];

	Join[

		{
			Replace[MeltingCurves] -> meltingCurvesID,
			Replace[MeltingCurvesTransformation] -> meltingCurvesTranfrom,
			Replace[MeltingTransitions] -> mtrans,
			Replace[MeltingTemperatures] -> mps,
			Replace[MeltingTemperatureStandardDeviations] -> mpstddevs,
			Replace[MeltingTemperatureDistributions] -> mpdists,
			Replace[MeltingOnsetTemperatures] -> monsets,

			MeanMeltingTemperature->mpMean,
			MeltingTemperatureStandardDeviation->mpStdDev,
			MeltingTemperatureDistribution->mpDist,

			(*Options added as output fields*)
			Domain->Lookup[resolvedOps, Domain, Null]*Celsius,
			MeltingPlotRange->Lookup[resolvedOps, Range, Null],
			Wavelength->Lookup[resolvedOps, Wavelength, Null],
			DataProcessing->Lookup[resolvedOps, DataProcessing, Null],
			SmoothingRadius->Lookup[resolvedOps, SmoothingRadius, Null],
			Replace[DataSet]->Lookup[resolvedOps, DataSet, Null],
			PlotType->Lookup[resolvedOps, PlotType, Null],
			ApplyAll->Lookup[resolvedOps, ApplyAll, Null],
			Replace[Output]->Lookup[resolvedOps, Output, Null],
			Upload->Lookup[resolvedOps, Upload, Null],
			Template->Lookup[resolvedOps, Template, Null],
			Replace[MeltingCurvesDataPoints] -> (safeMeltingCurve[#, dataId]& /@ xycurves)
		},

		If[useAlpha,
			{
				Replace[MeltingCurvesFractionBound] -> (safeFractionBound[#]& /@ alphas)
			},
			{}
		],

		(* If we pulled cures from qPCR we also want to save the derivatives *)
		If[MatchQ[dataId, ObjectP[Object[Data, qPCR]]],
			{
				Replace[MeltingCurvesDerivativePoints] -> smoothedDerivatives
			},
			{}
		]

	]
];

safeFractionBound[Null]:=Null;
safeFractionBound[vals_]:=QuantityArray[vals,{Celsius,None}];

safeMeltingCurve[Null, _]:=Null;
safeMeltingCurve[vals_, _]:=QuantityArray[vals,{Celsius,ArbitraryUnit}];
safeMeltingCurve[vals_, ObjectP[Object[Data, qPCR]]]:=QuantityArray[vals,{Celsius,RFU}];
