(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validCalibrationQTests*)


validCalibrationQTests[packet:PacketP[Object[Calibration]]] := {

	NotNullFieldTest[packet,
		{
			DateCreated,
			ManufacturerCalibration
		}
	],
	
	(* manufacturer calibration except Conductivity *)
	Test["Data point, unit, and fit fields need to be filled out if manufacturer calibration is false:",
		If[
			MatchQ[packet,Except@PacketP[Object[Calibration,Conductivity]]],
			Lookup[packet,{ManufacturerCalibration,Reference,Response,FitAnalysis,CalibrationFunction,CalibrationStandardDeviationFunction,CalibrationDistributionFunction}],
			{True, _, _, _, _, _, _}
		],
		{True,_,_,_,_,_,_}|{False,Except[NullP],Except[NullP],Except[NullP],Except[NullP],Except[NullP],Except[NullP]}]
};


(* ::Subsection::Closed:: *)
(*validCalibrationSensorQTests*)


validCalibrationSensorQTests[packet:PacketP[Object[Calibration,Sensor]]]:={
	(* unique fields *)
	NotNullFieldTest[packet,
		{
			Target,
			CalibrationFunction
		}
	]
};


(* ::Subsection::Closed:: *)
(*validCalibrationSensorLiquidLevelQTests*)


validCalibrationSensorLiquidLevelQTests[packet:PacketP[Object[Calibration,Sensor, LiquidLevel]]]:={
	
	(* unique fields *)
	NotNullFieldTest[packet,
		{
			CalibrationFunction
		}
	]
};


(* ::Subsection::Closed:: *)
(*validCalibrationSensorCarbonDioxideQTests*)


	
	
validCalibrationSensorCarbonDioxideQTests[packet:PacketP[Object[Calibration,Sensor, CarbonDioxide]]]:={};


(* ::Subsection::Closed:: *)
(*validCalibrationSensorCarbonDioxideQTests*)


	
	
validCalibrationConductivityQTests[packet:PacketP[Object[Calibration, Conductivity]]]:={};


(* ::Subsection::Closed:: *)
(*validCalibrationSensorpHQTests*)


validCalibrationpHQTests[packet:PacketP[Object[Calibration, pH]]]:={
	NotNullFieldTest[packet,
		{
			Instrument,Probe
		}
	];
};
	
validCalibrationSensorpHQTests[packet:PacketP[Object[Calibration,Sensor, pH]]]:={};


(* ::Subsection::Closed:: *)
(*validCalibrationSensorPressureQTests*)


	
	
validCalibrationSensorPressureQTests[packet:PacketP[Object[Calibration,Sensor, Pressure]]]:={};


(* ::Subsection::Closed:: *)
(*validCalibrationSensorRelativeHumidityQTests*)


	
	
validCalibrationSensorRelativeHumidityQTests[packet:PacketP[Object[Calibration,Sensor, RelativeHumidity]]]:={};


(* ::Subsection::Closed:: *)
(*validCalibrationSensorTemperatureQTests*)


	
	
validCalibrationSensorTemperatureQTests[packet:PacketP[Object[Calibration,Sensor, Temperature]]]:={};


(* ::Subsection::Closed:: *)
(*validCalibrationSensorWeightQTests*)


	
	
validCalibrationSensorWeightQTests[packet:PacketP[Object[Calibration,Sensor, Weight]]]:={};


(* ::Subsection::Closed:: *)
(*validCalibrationSensorWeightQTests*)


	
	
validCalibrationSensorBubbleCounterQTests[packet:PacketP[Object[Calibration,Sensor,BubbleCounter]]]:={};


(* ::Subsection::Closed:: *)
(*validCalibrationBufferbotQTests*)


	
	
validCalibrationBufferbotQTests[packet:PacketP[Object[Calibration,Bufferbot]]]:={
	(* unique fields *)
	NotNullFieldTest[packet,
		{
			SmallCylinderCalibrationFunction,
			MediumCylinderCalibrationFunction,
			LargeCylinderCalibrationFunction,
			MediumCylinderLowPosition,
			LargeCylinderLowPosition,
			MediumCylinderWashPosition,
			LargeCylinderWashPosition,
			HeaterCalibrationFunction,
			Target
		}	
	]
};


(* ::Subsection::Closed:: *)
(*validCalibrationPathLengthQTests*)


validCalibrationPathLengthQTests[packet:PacketP[Object[Calibration,PathLength]]]:={
	(* unique fields *)
	NotNullFieldTest[packet,
		{
			LiquidLevelDetector,
			PlateReader,
			PlateModel,
			BufferModel,
			LiquidHandler,
			CalibrationFunction
		}
	]
};


(* ::Subsection::Closed:: *)
(*validCalibrationVolumeQTests*)


validCalibrationVolumeQTests[packet:PacketP[Object[Calibration, Volume]]]:={
	
	(* unique fields *)
	NotNullFieldTest[packet,{ContainerModels,BufferModel}],
	
	AnyInformedTest[packet,{LiquidLevelDetectorModel,VolumeSensorModel}],
	RequiredTogetherTest[packet,{LiquidLevelDetector,LiquidLevelDetectorModel}],

	Test["LayoutFileName field needs to be filled out if LiquidLevelDetectorModel is VolumeCheck:",
		Lookup[packet, {LiquidLevelDetectorModel, LayoutFileName}],
		Alternatives[
			{
				ObjectP@Link[Model[Instrument, LiquidLevelDetector, "id:9RdZXvKBee8x"]](*vc50*)|
				ObjectP@Link[Model[Instrument, LiquidLevelDetector, "id:zGj91aR3d5b6"]](*vc100*)|
				ObjectP@Link[Model[Instrument, LiquidLevelDetector, "id:8qZ1VW0VaMVD"]](*vc384*),
				_String
			},
			{
				Except[
					ObjectP@Link[Model[Instrument, LiquidLevelDetector, "id:9RdZXvKBee8x"]](*vc50*)|
					ObjectP@Link[Model[Instrument, LiquidLevelDetector, "id:zGj91aR3d5b6"]](*vc100*)|
					ObjectP@Link[Model[Instrument, LiquidLevelDetector, "id:8qZ1VW0VaMVD"]](*vc384*)
				],
				Null
			}
		]
	],

	Test["SensorArmHeight field needs to be filled out if LiquidLevelDetectorModel is not VolumeCheck and not Bottle Cap's Sensor:",
		Lookup[packet, {LiquidLevelDetectorModel,VolumeSensorModel, SensorArmHeight}],
		Alternatives[
			{
				ObjectP@Link[Model[Instrument, LiquidLevelDetector, "id:9RdZXvKBee8x"]](*vc50*)|
				ObjectP@Link[Model[Instrument, LiquidLevelDetector, "id:zGj91aR3d5b6"]](*vc100*)|
				ObjectP@Link[Model[Instrument, LiquidLevelDetector, "id:8qZ1VW0VaMVD"]](*vc384*),
				Null,
				Null
			},
			{
				Except[
					ObjectP@Link[Model[Instrument, LiquidLevelDetector, "id:9RdZXvKBee8x"]](*vc50*)|
					ObjectP@Link[Model[Instrument, LiquidLevelDetector, "id:zGj91aR3d5b6"]](*vc100*)|
					ObjectP@Link[Model[Instrument, LiquidLevelDetector, "id:8qZ1VW0VaMVD"]](*vc384*)
				],
				_,
				DistanceP
			},
			{
				Null,
				ObjectP[Model[Sensor, Volume]],
				Null
			}
		]
	],

	Test["RackModel field needs to be filled out if LiquidLevelDetectorModel is VolumeCheck and ContainerModels are Vessel:",
		Lookup[packet,{LiquidLevelDetectorModel,ContainerModels, RackModel}],
		Alternatives[
			{
				ObjectP@Link[Model[Instrument, LiquidLevelDetector, "id:9RdZXvKBee8x"]](*vc50*)|
				ObjectP@Link[Model[Instrument, LiquidLevelDetector, "id:zGj91aR3d5b6"]](*vc100*)|
				ObjectP@Link[Model[Instrument, LiquidLevelDetector, "id:8qZ1VW0VaMVD"]](*vc384*),
				{ObjectP@Model[Container, Vessel] ..},
				ObjectP[Model[Container, Rack]]
			},
			{
				ObjectP@Link[Model[Instrument, LiquidLevelDetector, "id:9RdZXvKBee8x"]](*vc50*)|
				ObjectP@Link[Model[Instrument, LiquidLevelDetector, "id:zGj91aR3d5b6"]](*vc100*)|
				ObjectP@Link[Model[Instrument, LiquidLevelDetector, "id:8qZ1VW0VaMVD"]](*vc384*),
				{ObjectP@Model[Container, Plate] ..},
				__
			},
			{
				Except[
					ObjectP@Link[Model[Instrument, LiquidLevelDetector, "id:9RdZXvKBee8x"]](*vc50*)|
					ObjectP@Link[Model[Instrument, LiquidLevelDetector, "id:zGj91aR3d5b6"]](*vc100*)|
					ObjectP@Link[Model[Instrument, LiquidLevelDetector, "id:8qZ1VW0VaMVD"]](*vc384*)
				],
				__,__
			}
			]
		],

	If[
		MatchQ[Lookup[packet,LiquidLevelDetectorModel],ObjectP@Link[Model[Instrument, LiquidLevelDetector, "id:eGakld01zVoG"]]],
		Test["RackModel field needs to be filled out if LiquidLevelDetectorModel is Emerald Macro Volume Check for Small Vessels unless the container is self-standing:",
			{Lookup[packet,ContainerModels][SelfStanding],Lookup[packet,RackModel]},
			Alternatives[
				{{Except[False]..},_},
				{_,ObjectP@Link[Model[Container, Rack, "id:vXl9j5qk0qDN"]]|ObjectP@Link[Model[Container, Rack, "id:9RdZXvK8OKXZ"]]}
			]
		],
		Nothing
	],

	Test["Either one of EmptyDistanceDistribution or WellEmptyDistanceDistributions is informed:",
		Lookup[packet,{EmptyDistanceDistribution,WellEmptyDistanceDistributions}],
		{Except[Null],Alternatives[Null,{}]}|{Null,Except[Alternatives[Null,{}]]}
	],

	Test["If multiple container models are provided, they have the same wells:",
		CountDistinct[Lookup[Name]/@Download[Lookup[packet,ContainerModels],Positions]],
		1
	],

	If[!MatchQ[Lookup[packet,WellEmptyDistanceDistributions,{}],Alternatives[Null,{}]],
		Test["If WellEmptyDistanceDistribution is informed, the wells listed correspond to the wells of the container models:",
			Lookup[Download[Lookup[packet,ContainerModels,{}][[1]],Positions,{}],Name,Null],
			Lookup[Lookup[packet,WellEmptyDistanceDistributions,{}],Name,Null]
		],
		Nothing
	]
};



(* ::Subsection::Closed:: *)
(* Test Registration *)


registerValidQTestFunction[Object[Calibration, Sensor],validCalibrationSensorQTests];
registerValidQTestFunction[Object[Calibration],validCalibrationQTests];
registerValidQTestFunction[Object[Calibration, PathLength],validCalibrationPathLengthQTests];
registerValidQTestFunction[Object[Calibration, Volume],validCalibrationVolumeQTests];
registerValidQTestFunction[Object[Calibration, Sensor, LiquidLevel],validCalibrationSensorLiquidLevelQTests];
registerValidQTestFunction[Object[Calibration, Sensor, CarbonDioxide],validCalibrationSensorCarbonDioxideQTests];
registerValidQTestFunction[Object[Calibration, Conductivity],validCalibrationConductivityQTests];
registerValidQTestFunction[Object[Calibration, pH],validCalibrationpHQTests];
registerValidQTestFunction[Object[Calibration, Sensor, pH],validCalibrationSensorpHQTests];
registerValidQTestFunction[Object[Calibration, Sensor, Pressure],validCalibrationSensorPressureQTests];
registerValidQTestFunction[Object[Calibration, Sensor, RelativeHumidity],validCalibrationSensorRelativeHumidityQTests];
registerValidQTestFunction[Object[Calibration, Sensor, Temperature],validCalibrationSensorTemperatureQTests];
registerValidQTestFunction[Object[Calibration, Sensor, Weight],validCalibrationSensorWeightQTests];
registerValidQTestFunction[Object[Calibration, Bufferbot],validCalibrationBufferbotQTests];
registerValidQTestFunction[Object[Calibration, Sensor, BubbleCounter],validCalibrationSensorBubbleCounterQTests];