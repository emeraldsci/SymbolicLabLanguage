(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotVibration*)


DefineOptions[PlotVibration,
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
PlotVibration::InvalidDataObject="Error: '`1`' does not exist.";


(* List of supported data types *)
sensorDataTypeP={
	Object[Data,Vibration]
};

(* Supported patterns *)
sensorDataPacketP=Alternatives@@(packetOrInfoP[#]&/@sensorDataTypeP);
sensorObjectDataP=Join[
	Alternatives@@(ObjectReferenceP[#]&/@sensorDataTypeP),
	Alternatives@@(LinkP[#]&/@sensorDataTypeP)
];

(*Overload for data objects object*)
PlotVibration[mySensorDataObject:(sensorObjectDataP),myOps:OptionsPattern[PlotVibration]]:= Module[{},

	(*Throw an error if the instrument does not exist*)
	If[!DatabaseMemberQ[mySensorDataObject], Return[Message[PlotVibration::InvalidDataObject,mySensorDataObject]]];

	PlotVibration[Download[mySensorDataObject], myOps]
];


(*Overload for data sensor info packets*)
PlotVibration[mySensorDataPacket:sensorDataPacketP,myOps:OptionsPattern[PlotVibration]]:=Module[
	{measurand, sensorObject, logFieldName, dataObject,sensorPlotLabel,safeOps,sensorDataType,rawDataLog},

	(*Find the sensor data type*)
	sensorDataType=Download[mySensorDataPacket,Object][[2]];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotVibration,ToList[myOps]];

	(*Pick sensor object*)
	sensorObject=Download[mySensorDataPacket, Sensor][Object];

	dataObject=Download[mySensorDataPacket, Object];

	dataName = If[MissingQ[dataObject],"", ToString[dataObject]];

	(*Resolve the name of the log field from the data sensor object, e.g. TemperatureLog*)
	logFieldName=resolveSensorDataLogFieldVibration[Download[sensorObject]];

	(*Resolve raw data log*)
	rawDataLog=Flatten[Download[dataObject,RawData],1][[2]];

	measurand=If[sensorObject===Null,
		"Sensor Information",

		(*Extract the measurand from the sensor object*)
		sensorObjectToMeasurand[sensorObject]
	];

	(* allow user input for plot label *)
	sensorPlotLabel= Switch[(PlotLabel/. safeOps),
		Automatic, ToString@dataObject,
		(* This option can't be null, but the prepareNulls trick below returns nulls so we need to manage them *)
		Null, "",
		Except[Automatic], (PlotLabel/. safeOps)
	];

	(*Plot the calibrated data. Plot the RawData if the datatype is ReedSwitch*)
	Which[
		    MatchQ[sensorDataType,Alternatives[Vibration]],
	      PlotVibration[Lookup[mySensorDataPacket,logFieldName], ReplaceRule[ToList[myOps],{yAxisLabel->measurand,PlotLabel->sensorPlotLabel}]]
		]
];

(*SuperListable on Data Object*)
PlotVibration[
	mySensorDataObject:{(sensorObjectDataP)..},
	myOps:OptionsPattern[PlotVibration]
]:=Module[{rawOutput},

	(* Map the function over the inputs *)
	rawOutput=MapThread[
		PlotVibration[#1, ReplaceRule[ToList[myOps],{PlotLabel->#2, yAxisLabel->#3}] ]&,
		{
			mySensorDataObject,
			prepareNulls[OptionValue[PlotLabel],Length[mySensorDataObject]],
			sensorObjectToMeasurand[Lookup[#,Sensor][Object]]&/@ (Download@mySensorDataObject)
		}
	];

	(* Return consolidated outputs for the command builder *)
	consolidateRawListedOutputs[rawOutput,PlotVibration,myOps]
];

(*SuperListable on info*)
PlotVibration[
	mySensorDataPacket:{sensorDataPacketP..},
	myOps:OptionsPattern[PlotVibration]
]:=Module[{rawOutput},

	(* Map the function over the inputs *)
	rawOutput=MapThread[
		PlotVibration[#1, ReplaceRule[ToList[myOps],{PlotLabel->#2, yAxisLabel->#3}] ]&,
		{
			mySensorDataPacket,
			prepareNulls[OptionValue[PlotLabel],Length[mySensorDataPacket]],
			sensorObjectToMeasurand[Lookup[#,Sensor][Object]]&/@ mySensorDataPacket
		}
	];

	(* Return consolidated outputs for the command builder *)
	consolidateRawListedOutputs[rawOutput,PlotVibration,myOps]
];

(*SuperListable on Data*)
PlotVibration[
	mySensorData:{(DateCoordinateP|{{_?DateObjectQ, _?UnitsQ}..}|QuantityCoordinatesP[]|_?NullQ)..},
	myOps:OptionsPattern[PlotVibration]
]:=Module[{rawOutput},

	(* Map the function over the inputs *)
	rawOutput=MapThread[
		PlotVibration[#1, ReplaceRule[ToList[myOps],{PlotLabel->#2, yAxisLabel->#3}] ]&,
		{
			mySensorData,
			prepareNulls[OptionValue[PlotLabel],Length[mySensorData]],
			prepareNulls[OptionValue[yAxisLabel],Length[mySensorData]]
		}
	];

	(* Return consolidated outputs for the command builder *)
	consolidateRawListedOutputs[rawOutput,PlotVibration,myOps]
];

(*PlotVibration function*)
PlotVibration[mySensorData:(DateCoordinateP|{{_?DateObjectQ, _?UnitsQ}..}|QuantityCoordinatesP[]|_?NullQ),myOps:OptionsPattern[PlotVibration]]:=Module[

	{originalOps,safeOps,output,plot,sensorPlotRange,plotOptions,mostlyResolvedOps,resolvedOps,AxisUnits,
		sensorDateTicksFormat,sensorFrameLabel,	sensorFrameTicksStyle,sensorPlotLabel},

	(* Convert the original options into a list *)
	originalOps=ToList[myOps];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotVibration,ToList[myOps]];

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
		Automatic, "",
		(* This option can't be null, but the prepareNulls trick blow returns nulls so we need to manage them *)
		Null, "",
		Except[Automatic], (PlotLabel/. safeOps)
	];

	(* Collate resolved options *)
	plotOptions = ReplaceRule[ToList[stringOptionsToSymbolOptions@PassOptions[PlotVibration,EmeraldDateListPlot,safeOps]],
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
		  Vibration,
		    "Vibration",
		    _,
            	"Sensor Reading"
	];

	(*output the measurand*)
	measurand
];


(*Function that resolves the data fields as a function of the vibration sensor type, returns a list of symbols corresponding to the fields to be informed *)
resolveSensorDataLogFieldVibration[sensorPacket:PacketP[Object[Sensor]]]:=Module[

{measurementMethod,logField},

	(*Get info from sensors*)
	measurementMethod=Lookup[sensorPacket,VibrationSensorType];

	logField=Switch[measurementMethod,
			Accelerometer,
			    AccelerometerVibrationLog,
			Speedometer,
			    SpeedometerVibrationLog
	];

		(*output the list of fields to be returned*)
	logField
];
