(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotSensor*)


DefineOptions[PlotSensor,
	Options :> {
		(* ELLP Options which have defaults replaced *)
		ModifyOptions[EmeraldDateListPlot,
			{
				{OptionName->ImageSize, Default->500},
				{OptionName->PlotRange, Default->Automatic},
				{OptionName->PlotLabel, Default->Automatic},
				{OptionName->Legend},
				{OptionName->Joined, Default->True},
				{OptionName->Frame, Default->{{True,True},{True,False}}},
				{OptionName->FrameStyle, Default->{{GrayLevel[0], GrayLevel[0]}, {GrayLevel[0], Automatic}}},
				{OptionName->PlotStyle, Default->RGBColor[0.368417, 0.506779, 0.709798], Category->"Hidden"},
				{OptionName->LabelStyle, Default->{12,Bold,FontFamily->"Arial"}},
				{OptionName->GridLines, Default->{Automatic, None}},
				{OptionName->Zoomable, Default-> True}
			}
		],
		(* Hidden Options *)
		{
			OptionName->yAxisLabel,
			AllowNull->True,
			Default->"Sensor Reading",
			Widget->Widget[Type->String,Pattern:>_String,Size->Word,BoxText->"Y-axis label"],
			Description->"Text to be displayed on the Y axis.",
			Category->"Hidden"
		},
		(* Hide other options *)
		ModifyOptions[EmeraldDateListPlot,
			{
				PlotRangeClipping,ClippingStyle,SecondYCoordinates,
				SecondYColors,SecondYRange,Prolog,Epilog,
				SecondYStyle,SecondYUnit,TargetUnits,ErrorBars,
				ErrorType,Scale,InterpolationOrder,Tooltip,FrameUnits
			},
			Category->"Hidden"
		]
	},
	SharedOptions :> {
		ModifyOptions["Shared",EmeraldDateListPlot,
			{DateTicksFormat,FrameLabel,FrameTicksStyle},
			Default->Automatic
		],
		ModifyOptions["Shared",EmeraldDateListPlot,{FrameTicks},Default->{{True,True},{True,True}}],
		EmeraldDateListPlot
	}
];


(* Messages *)
PlotSensor::InvalidDataObject="Error: '`1`' does not exist.";


(* List of supported data types *)
sensorDataTypeP={
	Object[Data, CarbonDioxide],
	Object[Data, LiquidLevel],
  Object[Data, pH],
  Object[Data, Pressure],
	Object[Data, RelativeHumidity],
  Object[Data, Temperature],
	Object[Data, Weight],
	Object[Data, BubbleLog],
	Object[Data, FlowRate]
};

(* Supported patterns *)
sensorDataPacketP=Alternatives@@(packetOrInfoP[#]&/@sensorDataTypeP);
sensorObjectDataP=Join[
	Alternatives@@(ObjectReferenceP[#]&/@sensorDataTypeP),
	Alternatives@@(LinkP[#]&/@sensorDataTypeP)
];

(*Overload for data objects object*)
PlotSensor[mySensorDataObject:(sensorObjectDataP),myOps:OptionsPattern[PlotSensor]]:= Module[{},

	(*Throw an error if the instrument does not exist*)
	If[!DatabaseMemberQ[mySensorDataObject], Return[Message[PlotSensor::InvalidDataObject,mySensorDataObject]]];

	PlotSensor[Download[mySensorDataObject], myOps]
];


(*Overload for data sensor info packets*)
PlotSensor[mySensorDataPacket:sensorDataPacketP,myOps:OptionsPattern[PlotSensor]]:=Module[
	{measurand, sensorObject, logFieldName, dataObject,sensorPlotLabel,safeOps},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotSensor,ToList[myOps]];

	(*Pick sensor object*)
	sensorObject=Lookup[mySensorDataPacket, Sensor][Object];

	dataObject=Lookup[mySensorDataPacket, Object];

	If[dataObject==Missing["KeyAbsent", Object],dataObject=""];

	(*REsolve the name of the log field from the data sensor object, e.g. TEmperatureLog*)
	logFieldName=resolveSensorDataLogField[Download[sensorObject]];

	measurand=If[sensorObject===Null,
		"Sensor Information",

		(*Extract the measurand from the sensor object*)
		sensorObjectToMeasurand[sensorObject]
	];

	(* allow user input for plot label *)
	sensorPlotLabel= Switch[(PlotLabel/. safeOps),
		Automatic, ToString@dataObject,
		(* This option can't be null, but the prepareNulls trick blow returns nulls so we need to manage them *)
		Null, "",
		Except[Automatic], (PlotLabel/. safeOps)
	];

	(*Plot the calibrated data*)
	PlotSensor[Lookup[mySensorDataPacket,logFieldName], ReplaceRule[ToList[myOps],{yAxisLabel->measurand,PlotLabel->sensorPlotLabel}] ]
];


(*SuperListable on Data Object*)
PlotSensor[
	mySensorDataObject:{(sensorObjectDataP)..},
	myOps:OptionsPattern[PlotSensor]
]:=Module[{rawOutput},

	(* Map the function over the inputs *)
	rawOutput=MapThread[
		PlotSensor[#1, ReplaceRule[ToList[myOps],{PlotLabel->#2, yAxisLabel->#3}] ]&,
		{
			mySensorDataObject,
			prepareNulls[OptionValue[PlotLabel],Length[mySensorDataObject]],
			sensorObjectToMeasurand[Lookup[#,Sensor][Object]]&/@ (Download@mySensorDataObject)
		}
	];

	(* Return consolidated outputs for the command builder *)
	consolidateRawListedOutputs[rawOutput,PlotSensor,myOps]
];

(*SuperListable on info*)
PlotSensor[
	mySensorDataPacket:{sensorDataPacketP..},
	myOps:OptionsPattern[PlotSensor]
]:=Module[{rawOutput},

	(* Map the function over the inputs *)
	rawOutput=MapThread[
		PlotSensor[#1, ReplaceRule[ToList[myOps],{PlotLabel->#2, yAxisLabel->#3}] ]&,
		{
			mySensorDataPacket,
			prepareNulls[OptionValue[PlotLabel],Length[mySensorDataPacket]],
			sensorObjectToMeasurand[Lookup[#,Sensor][Object]]&/@ mySensorDataPacket
		}
	];

	(* Return consolidated outputs for the command builder *)
	consolidateRawListedOutputs[rawOutput,PlotSensor,myOps]
];

(*SuperListable on Data*)
PlotSensor[
	mySensorData:{(DateCoordinateP|{{_?DateObjectQ, _?UnitsQ}..}|QuantityCoordinatesP[]|_?NullQ)..},
	myOps:OptionsPattern[PlotSensor]
]:=Module[{rawOutput},

	(* Map the function over the inputs *)
	rawOutput=MapThread[
		PlotSensor[#1, ReplaceRule[ToList[myOps],{PlotLabel->#2, yAxisLabel->#3}] ]&,
		{
			mySensorData,
			prepareNulls[OptionValue[PlotLabel],Length[mySensorData]],
			prepareNulls[OptionValue[yAxisLabel],Length[mySensorData]]
		}
	];

	(* Return consolidated outputs for the command builder *)
	consolidateRawListedOutputs[rawOutput,PlotSensor,myOps]
];

(*PlotSensor function*)
PlotSensor[mySensorData:(DateCoordinateP|{{_?DateObjectQ, _?UnitsQ}..}|QuantityCoordinatesP[]|_?NullQ),myOps:OptionsPattern[PlotSensor]]:=Module[

	{originalOps,safeOps,output,plot,sensorPlotRange,plotOptions,mostlyResolvedOps,resolvedOps,AxisUnits,
		sensorDateTicksFormat,sensorFrameLabel,	sensorFrameTicksStyle,sensorPlotLabel},

	(* Convert the original options into a list *)
	originalOps=ToList[myOps];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotSensor,ToList[myOps]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(*If given a Null input, returns unevaluated*)
	If[mySensorData===Null, Return[]];

	(*Capture and format the vertical axis title*)
	If[(TargetUnits/.safeOps)===Automatic,
		AxisUnits= " ("<>ToString[QuantityUnit[mySensorData[[1]][[2]]], FormatType->StandardForm]<>")";,

		AxisUnits= "(" <>(ToString[TargetUnits/.safeOps])<>")";
	];

	(* Safe options with resolved options from the underlying plot function (plot range, frame, etc.) subbed in *)
	(* Get the plotRange, to make nicer and more relevant range *)
	sensorPlotRange = If[MatchQ[(PlotRange/. safeOps),Automatic],
		(*If the PlotRange is not specified, uses AutomaticYRange*)
		{Automatic, AutomaticYRange[mySensorData,10]},
		(*If specified, use it*)
		(PlotRange/. safeOps)
	];

	(* get DateTicksFormat, if passed *)
	sensorDateTicksFormat = If[MatchQ[(DateTicksFormat/. safeOps),Automatic],
		{"MonthShort", "/", "DayShort","/","YearShort" ,"-" ,"Hour24",":","Minute"},
		(DateTicksFormat/. safeOps)
	];

	(* get FrameLabel, if passed *)
	sensorFrameLabel = If[MatchQ[(FrameLabel/. safeOps),Automatic],
		{"Time",Style[(yAxisLabel/. safeOps )<>" "<>AxisUnits,(PlotStyle/. safeOps)],"",""},
		(FrameLabel/. safeOps)
	];

	(* get FrameLabel, if passed *)
	sensorFrameTicksStyle = If[MatchQ[(FrameTicksStyle/.safeOps),Automatic],
		{{Directive[11], Directive[11]}, {Directive[9.5, Black] , Automatic}},
		(FrameTicksStyle/.safeOps)
	];

	(* allow user input for plot label *)
	sensorPlotLabel= Switch[(PlotLabel/. safeOps),
		Automatic, ToString@dataObject,
		(* This option can't be null, but the prepareNulls trick blow returns nulls so we need to manage them *)
		Null, "",
		Except[Automatic], (PlotLabel/. safeOps)
	];

	(* Collate resolved options *)
	plotOptions = ReplaceRule[ToList[stringOptionsToSymbolOptions@PassOptions[PlotSensor,EmeraldDateListPlot,safeOps]],
			{
				DateTicksFormat->sensorDateTicksFormat,
				FrameLabel->sensorFrameLabel,
				FrameTicksStyle->sensorFrameTicksStyle,
				PlotRange->sensorPlotRange,
				PlotLabel->sensorPlotLabel
			}
	];

	(* We plot a second time with all resolved options to allow them to take effect.. *)
	{plot,mostlyResolvedOps}=EmeraldDateListPlot[
		mySensorData,
		ReplaceRule[
			plotOptions,
			{Output->{Result,Options}}
		]
	];

	resolvedOps=ReplaceRule[mostlyResolvedOps,{Output->output}];

	(* Return the requested outputs *)
	output/.{
		Result->plot,
		Options->resolvedOps,
		Preview->If[Lookup[resolvedOps,Zoomable,False],
			Pane[plot,ImageSize->Full,Alignment->Center,ImageSizeAction->"ShrinkToFit"],
			Show[plot,ImageSize->Full]
		],
		Tests->{}
	}

];

(*Function taking sensor object and extract the measurand*)
sensorObjectToMeasurand[sensorObject:ObjectP[Object[Sensor]]]:=Module[{FamilyName, measurand},

	(*Get info from sensors*)
	FamilyName= sensorObject[[2]];
	(*Sets the right output depending of measurand*)
	measurand=Switch[FamilyName,
			Temperature,
				"Temperature",
			RelativeHumidity,
				"Relative Humidity",
			CarbonDioxide,
				"Carbon Dioxide Level",
			Pressure,
				"Pressure",
			LiquidLevel,
				"Liquid Level",
			pH,
				"pH",
			BubbleCounter,
				"Bubbles Detected",
			FlowRate,
				"Flow Rate",
			_,
				"Sensor Reading"
	];

	(*output the measurand*)
	measurand
];


(*Function that resolves the data fields as a function of the sensor measurement method, returns a list of symbols corresponding to the fields to be informed *)
resolveSensorDataLogField[sensorPacket:PacketP[Object[Sensor]]]:=Module[

{measurementMethod,logField},

	(*Get info from sensors*)
	measurementMethod=Lookup[sensorPacket,Method];

	logField=Switch[measurementMethod,
			Temperature,
				TemperatureLog,
			RelativeHumidity,
				RelativeHumidityLog,
			CarbonDioxide,
				CarbonDioxideLog,
			Pressure,
				PressureLog,
			LiquidLevel,
				LiquidLevelLog,
			pH,
				pHLog,
			Weight,
				WeightLog,
			UltrasonicDistance,
				LiquidLevelLog,
			Counter,
				BubbleLog,
			FlowRate,
				FlowRateLog
	];

		(*output the list of fields to be returned*)
	logField
];
