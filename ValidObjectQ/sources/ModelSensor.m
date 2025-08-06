

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section::Closed:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validModelSensorQTests*)


validModelSensorQTests[packet:PacketP[Model[Sensor]]]:={
	(* required fields *)
	NotNullFieldTest[
		packet,
		{Authors,Manufacturer,UserManualFiles,Dimensions,PLCVariableType,
		CrossSectionalShape,SensorOutputSignal,ImageFile,PowerInput,Method,Name,
		DefaultStorageCondition}
	],

	Test["If StickerPositionOnReceiving is populated, PositionStickerPlacementImage is also populated and vise versa",
		Lookup[packet, {StickerPositionOnReceiving, PositionStickerPlacementImage}],
		Alternatives[
			{Null, Null},
			{Except[Null], Except[Null]}
		]
	],

	Test["If StickerConnectionOnReceiving is populated, ConnectionStickerPlacementImage is also populated and vise versa",
		Lookup[packet, {StickerConnectionOnReceiving, ConnectionStickerPlacementImage}],
		Alternatives[
			{Null, Null},
			{Except[Null], Except[Null]}
		]
	]
};


(* ::Subsection::Closed:: *)
(*validModelSensorCarbonDioxideQTests*)


validModelSensorCarbonDioxideQTests[packet:PacketP[Model[Sensor,CarbonDioxide]]]:={

	(* not null unique fields *)
	NotNullFieldTest[packet,MaxCO2],
	NotNullFieldTest[packet,MinCO2],
	NotNullFieldTest[packet,Resolution],
	NotNullFieldTest[packet,ManufacturerUncertainty],

	(* min/max comparison *)
	FieldComparisonTest[packet,{MinCO2,MaxCO2},LessEqual],
	FieldComparisonTest[packet,{Resolution,MaxCO2},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelSensorLiquidLevelQTests*)


validModelSensorLiquidLevelQTests[packet:PacketP[Model[Sensor,LiquidLevel]]]:={

	(* not null unique fields *)
	NotNullFieldTest[packet,MaxLiquidLevel],
	NotNullFieldTest[packet,MinLiquidLevel],
	NotNullFieldTest[packet,Resolution],
	NotNullFieldTest[packet,ManufacturerUncertainty],

	(* min/max comparison *)
	FieldComparisonTest[packet,{MinLiquidLevel,MaxLiquidLevel},LessEqual],
	FieldComparisonTest[packet,{Resolution,MaxLiquidLevel},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelSensorpHQTests*)


validModelSensorpHQTests[packet:PacketP[Model[Sensor,pH]]]:={

	(* not null unique fields *)
	NotNullFieldTest[packet,MaxpH],
	NotNullFieldTest[packet,MinpH],
	NotNullFieldTest[packet,Resolution],
	NotNullFieldTest[packet,ManufacturerUncertainty],

	(* min/max comparison *)
	FieldComparisonTest[packet,{MinpH,MaxpH},LessEqual],
	FieldComparisonTest[packet,{Resolution,MaxpH},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelSensorPressureQTests*)


validModelSensorPressureQTests[packet:PacketP[Model[Sensor,Pressure]]]:={

	(* not null unique fields *)
	NotNullFieldTest[packet,MaxPressure],
	NotNullFieldTest[packet,MinPressure],
	NotNullFieldTest[packet,Resolution],
	NotNullFieldTest[packet,ManufacturerUncertainty],

	(* min/max comparison *)
	FieldComparisonTest[packet,{MinPressure,MaxPressure},LessEqual],
	FieldComparisonTest[packet,{Resolution,MaxPressure},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelSensorRelativeHumidityQTests*)


validModelSensorRelativeHumidityQTests[packet:PacketP[Model[Sensor,RelativeHumidity]]]:={

	(* not null unique fields *)
	NotNullFieldTest[packet,MaxRelativeHumidity],
	NotNullFieldTest[packet,MinRelativeHumidity],
	NotNullFieldTest[packet,Resolution],
	NotNullFieldTest[packet,ManufacturerUncertainty],

	(* min/max comparison *)
	FieldComparisonTest[packet,{MinRelativeHumidity,MaxRelativeHumidity},LessEqual],
	FieldComparisonTest[packet,{Resolution,MaxRelativeHumidity},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelSensorConductivityQTests*)


validModelSensorConductivityQTests[packet:PacketP[Model[Sensor,Conductivity]]]:={

	(* not null unique fields *)
	NotNullFieldTest[packet,MaxConductivity],
	NotNullFieldTest[packet,MinConductivity],
	NotNullFieldTest[packet,Resolution],
	NotNullFieldTest[packet,ManufacturerUncertainty],

	(* min/max comparison *)
	FieldComparisonTest[packet,{MinConductivity,MaxConductivity},LessEqual],
	FieldComparisonTest[packet,{Resolution,MaxConductivity},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelSensorTemperatureQTests*)


validModelSensorTemperatureQTests[packet:PacketP[Model[Sensor,Temperature]]]:={

	(* not null unique fields *)
	NotNullFieldTest[packet,MaxTemperature],
	NotNullFieldTest[packet,MinTemperature],
	NotNullFieldTest[packet,Resolution],
	NotNullFieldTest[packet,ManufacturerUncertainty],

	(* min/max comparison *)
	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},LessEqual]
};



(* ::Subsection::Closed:: *)
(*validModelSensorFlowRateQTests*)


validModelSensorFlowRateQTests[packet:PacketP[Model[Sensor,FlowRate]]]:={

	(* not null unique fields *)
	NotNullFieldTest[packet,MaxFlowRate],
	NotNullFieldTest[packet,MinFlowRate],
	NotNullFieldTest[packet,Resolution],
	NotNullFieldTest[packet,ManufacturerUncertainty],

	(* min/max comparison *)
	FieldComparisonTest[packet,{MinFlowRate,MaxFlowRate},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelSensorVolumeQTests*)


validModelSensorVolumeQTests[packet:PacketP[Model[Sensor,Volume]]]:={

	(* Required Together test *)
	RequiredTogetherTest[packet,{MinVolume, MaxVolume}],
	RequiredTogetherTest[packet,{MinDistance, MaxDistance}],	
	
	(* min/max comparison *)
	FieldComparisonTest[packet,{MinVolume,MaxVolume},LessEqual],	
	FieldComparisonTest[packet,{MinDistance,MaxDistance},LessEqual]
};

(* ::Subsection::Closed:: *)
(*validModelSensorDistanceSensorQTests*)


validModelSensorDistanceSensorQTests[packet:PacketP[Model[Sensor,Distance]]]:={

	(* Required Together test *)
	RequiredTogetherTest[packet,{MinDistance, MaxDistance}],

	(* min/max comparison *)
	FieldComparisonTest[packet,{MinDistance,MaxDistance},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelSensorWeightQTests*)


validModelSensorWeightQTests[packet:PacketP[Model[Sensor,Weight]]]:={

	(* not null unique fields *)
	NotNullFieldTest[packet,MaxWeight],
	NotNullFieldTest[packet,MinWeight],
	NotNullFieldTest[packet,Resolution],
	NotNullFieldTest[packet,ManufacturerUncertainty],

	(* min/max comparison *)
	FieldComparisonTest[packet,{MinWeight,MaxWeight},LessEqual]
};



(* ::Subsection::Closed:: *)
(*validModelSensorBubbleCounterQTests*)


validModelSensorBubbleCounterQTests[packet:PacketP[Model[Sensor,BubbleCounter]]]:={

(* not null unique fields *)
NotNullFieldTest[packet,MaxBubbleCount],
NotNullFieldTest[packet,MinBubbleCount],
NotNullFieldTest[packet,Resolution],
NotNullFieldTest[packet,ManufacturerUncertainty],

(* min/max comparison *)
FieldComparisonTest[packet,{MinBubbleCount,MaxBubbleCount},LessEqual]
};


(* ::Subsection::Closed:: *)
(*FvalidModelSensorVibrationQTests*)


validModelSensorVibrationQTests[packet:PacketP[Model[Sensor,Vibration]]]:={

	(* not null unique fields *)
	NotNullFieldTest[packet,MaxVibration],
	NotNullFieldTest[packet,MinVibration],
	NotNullFieldTest[packet,Resolution],
	NotNullFieldTest[packet,ManufacturerUncertainty],

	(* min/max comparison *)
	FieldComparisonTest[packet,{MinVibration,MaxVibration},LessEqual],
	FieldComparisonTest[packet,{Resolution,MaxVibration},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelSensorLightQTests*)


validModelSensorLightQTests[packet:PacketP[Model[Sensor,Light]]]:={

	(* not null unique fields *)
	NotNullFieldTest[packet,MaxLux],
	NotNullFieldTest[packet,MinLux],
	NotNullFieldTest[packet,Resolution],
	NotNullFieldTest[packet,ManufacturerUncertainty],

	(* min/max comparison *)
	FieldComparisonTest[packet,{MinLux,MaxLux},LessEqual],
	FieldComparisonTest[packet,{Resolution,MaxLux},LessEqual]
}




(* ::Subsection::Closed:: *)
(* Test Registration *)
validModelSensorFlowRateQTests;

registerValidQTestFunction[Model[Sensor],validModelSensorQTests];
registerValidQTestFunction[Model[Sensor, CarbonDioxide],validModelSensorCarbonDioxideQTests];
registerValidQTestFunction[Model[Sensor, Conductivity],validModelSensorConductivityQTests];
registerValidQTestFunction[Model[Sensor, LiquidLevel],validModelSensorLiquidLevelQTests];
registerValidQTestFunction[Model[Sensor, pH],validModelSensorpHQTests];
registerValidQTestFunction[Model[Sensor, Pressure],validModelSensorPressureQTests];
registerValidQTestFunction[Model[Sensor, RelativeHumidity],validModelSensorRelativeHumidityQTests];
registerValidQTestFunction[Model[Sensor, Temperature],validModelSensorTemperatureQTests];
registerValidQTestFunction[Model[Sensor, FlowRate],validModelSensorFlowRateQTests];
registerValidQTestFunction[Model[Sensor, Volume],validModelSensorVolumeQTests];
registerValidQTestFunction[Model[Sensor, Distance],validModelSensorDistanceSensorQTests];
registerValidQTestFunction[Model[Sensor, Weight],validModelSensorWeightQTests];
registerValidQTestFunction[Model[Sensor, BubbleCounter],validModelSensorBubbleCounterQTests];
registerValidQTestFunction[Model[Sensor, Vibration],validModelSensorVibrationQTests];
registerValidQTestFunction[Model[Sensor, Light],validModelSensorLightQTests];
