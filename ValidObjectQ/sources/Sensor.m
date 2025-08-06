(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *) 


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*validSensorQTests*)


validSensorQTests[packet:PacketP[Object[Sensor]]]:=Module[
	{modelPacket, productPacket},

	{modelPacket, productPacket}=If[
		MatchQ[Lookup[packet, {Model, Product}], {Null, Null}],
		{Null, Null},
		Download[Lookup[packet, Object], {Model[All], Product[All]}]];

	{
		(* required fields always*)
		NotNullFieldTest[
			packet,
			{
				Model,
				Status
			}
		],

		(* these fields should be uploaded if Status is not Stocked *)
		Test["DateInstalled is uploaded if Status is not Stocked:",
			Lookup[packet, {Status, DateInstalled}],
			Alternatives[
				{Stocked, _},
				{Except[Stocked], _?DateObjectQ}
			]
		],

		Test["SerialNumber is uploaded if Status is not Stocked:",
			Lookup[packet, {Status, SerialNumber}],
			Alternatives[
				{Stocked, _},
				{Except[Stocked], _String}
			]
		],

		Test["ImageFile is uploaded if Status is not Stocked:",
			Lookup[packet, {Status, ImageFile}],
			Alternatives[
				{Stocked, _},
				{Except[Stocked], ObjectP[Object[EmeraldCloudFile]]}
			]
		],

		Test["Name is uploaded if Status is not Stocked:",
			Lookup[packet, {Status, Name}],
			Alternatives[
				{Stocked, _},
				{Except[Stocked], _String}
			]
		],

		Test["SensorLogType is uploaded if Status is not Stocked:",
			Lookup[packet, {Status, SensorLogType}],
			Alternatives[
				{Stocked, _},
				{Except[Stocked], SensorLogTypeP}
			]
		],

		Test["PLCVariableName is uploaded if Status is not Stocked:",
			Lookup[packet, {Status, PLCVariableName}],
			Alternatives[
				{Stocked, _},
				{Except[Stocked], _String}
			]
		],

		Test["EmbeddedPC is uploaded if Status is not Stocked:",
			Lookup[packet, {Status, EmbeddedPC}],
			Alternatives[
				{Stocked, _},
				{Except[Stocked], ObjectP[Object[Part, EmbeddedPC]]}
			]
		],

		Test["ArchivedDaily is uploaded if Status is not Stocked:",
			Lookup[packet, {Status, ArchivedDaily}],
			Alternatives[
				{Stocked, _},
				{Except[Stocked], BooleanP}
			]
		],

		(* timestamps *)
		Test["If DateInstalled is informed, it is in the past:",
			Lookup[packet, DateInstalled],
			Alternatives[
				Null, {},
				_?(# <= Now&)
			]
		],
		Test["If DateDiscarded is informed, it is in the past:",
			Lookup[packet, DateDiscarded],
			Alternatives[
				Null, {},
				_?(# <= Now&)
			]
		],

		(* DateDiscarded \[GreaterEqual] DateInstalled \[GreaterEqual] DatePurchased if all are not Null *)
		FieldComparisonTest[packet, {DateDiscarded, DateInstalled}, GreaterEqual],

		(* Status and DateDiscarded *)
		Test[
			"If the Status of the sensor is Discarded or Inactive, DateDiscarded must be populated:",
			If[
				MatchQ[Lookup[packet, Status], Inactive | Discarded],
				!NullQ[packet[DateDiscarded]],
				True
			],
			True
		],

		Test["If Status is not Discarded or Inactive, Site must be populated:",
			Lookup[packet, {Status, Site}],
			Alternatives[
				{Discarded | Inactive, _},
				{Except[Discarded | Inactive], ObjectP[Object[Container, Site]]}
			]
		],

		(*If a NextQualificationDate is given,it must be for one of the qualification models specified in QualificationFrequency*)
		Test["The qualifications entered in the NextQualificationDate field are members of the QualificationFrequency field:",
			Module[{qualFrequency, nextQualDate, qualFrequencyModels, nextQualDateModels},
				{nextQualDate, qualFrequency}=Lookup[packet, {NextQualificationDate, QualificationFrequency}];

				qualFrequencyModels=If[MatchQ[qualFrequency, Alternatives[Null, {}]], {}, First /@ qualFrequency];
				nextQualDateModels=If[MatchQ[nextQualDate, Alternatives[Null, {}]], {}, First /@ nextQualDate];

				(* Check if all NextQualificationDate models are in the QualificationFrequencyModels *)
				And @@ (MemberQ[qualFrequencyModels, ObjectP[#]] & /@ nextQualDateModels)
			],
			True
		],

		(*If a NextMaintenanceDate is given,it must be for one of the maintenance models specified in MaintenanceFrequency*)
		Test["The maintenance entered in the NextMaintenanceDate field are members of the MaintenanceFrequency field:",
			Module[{maintFrequency, nextMaintDate, maintFrequencyModels, nextMaintDateModels},
				{nextMaintDate, maintFrequency}=Lookup[packet, {NextMaintenanceDate, MaintenanceFrequency}];

				maintFrequencyModels=If[MatchQ[maintFrequency, Alternatives[Null, {}]], {}, First /@ maintFrequency];
				nextMaintDateModels=If[MatchQ[nextMaintDate, Alternatives[Null, {}]], {}, First /@ nextMaintDate];

				(* Check if all NextQualificationDate models are in the QualificationFrequencyModels *)
				And @@ (MemberQ[maintFrequencyModels, ObjectP[#]] & /@ nextMaintDateModels)
			],
			True
		],

		Test["If Model has at least one Product or KitProduct, object has to have Product populated",
			Module[{modelProducts, product},
				modelProducts=Download[Flatten@Lookup[modelPacket, {Products, KitProducts}, {}], Object];
				product=Lookup[packet, Product];
				Which[
					(* if we have Product populated, we are good *)
					!NullQ[product],
					True,

					(* if we don't have any  products in the Model, we are good *)
					NullQ[product] && Length[ToList[modelProducts]] == 0,
					True,

					(* if Product is not populated but there is at least one  Product for the Model, we have a problem *)
					NullQ[product] && Length[ToList[modelProducts]] > 0,
					False
				]],
			True
		],

		Test["If Product is a Kit, KitComponents should be populated:",
			If[!NullQ[packet],
				Which[
					(* if we don't have a product, pass *)
					NullQ[Lookup[packet, Product]],
					True,

					(* we have a product but it is not a kit*)
					MatchQ[Lookup[productPacket, KitComponents], (Null | {})],
					True,

					(* product is a kit but KitComponents in the Object are not populated *)
					MatchQ[Lookup[productPacket, KitComponents], Except[Null | {}]] && MatchQ[Lookup[packet, KitComponents], (Null | {})],
					False,

					(* otherwise, pass the test *)
					True,
					True
				],
				True
			],
			True
		]
	}
];


(* ::Subsection::Closed:: *)
(*validSensorCarbonDioxideQTests*)


validSensorCarbonDioxideQTests[packet:PacketP[Object[Sensor,CarbonDioxide]]]:={};


(* ::Subsection::Closed:: *)
(*validSensorLiquidLevelQTests*)


validSensorLiquidLevelQTests[packet:PacketP[Object[Sensor,LiquidLevel]]]:={};


(* ::Subsection::Closed:: *)
(*validSensorpHQTests*)


validSensorpHQTests[packet:PacketP[Object[Sensor,pH]]]:={};


(* ::Subsection::Closed:: *)
(*validSensorPressureQTests*)


validSensorPressureQTests[packet:PacketP[Object[Sensor,Pressure]]]:={};


(* ::Subsection::Closed:: *)
(*validSensorRelativeHumidityQTests*)


validSensorRelativeHumidityQTests[packet:PacketP[Object[Sensor,RelativeHumidity]]]:={};


(* ::Subsection::Closed:: *)
(*validSensorConductivityQTests*)


validSensorConductivityQTests[packet:PacketP[Object[Sensor,Conductivity]]]:={};


(* ::Subsection::Closed:: *)
(*validSensorFlowRateQTests*)


validSensorFlowRateQTests[packet:PacketP[Object[Sensor,FlowRate]]]:={};


(* ::Subsection::Closed:: *)
(*validSensorTemperatureQTests*)


validSensorTemperatureQTests[packet:PacketP[Object[Sensor,Temperature]]]:={};


(* ::Subsection::Closed:: *)
(*validSensorVolumeQTests*)


validSensorVolumeQTests[packet:PacketP[Object[Sensor,Volume]]]:={};

(* ::Subsection::Closed:: *)
(*validSensorDistanceSensorQTests*)


validSensorDistanceSensorQTests[packet:PacketP[Object[Sensor,Distance]]]:={};

(* ::Subsection::Closed:: *)
(*validSensorWeightQTests*)


validSensorWeightQTests[packet:PacketP[Object[Sensor,Weight]]]:={};


(* ::Subsection::Closed:: *)
(*validSensorBubbleCounterQTests*)


validSensorBubbleCounterQTests[packet:PacketP[Object[Sensor,BubbleCounter]]]:={};


(* ::Subsection::Closed:: *)
(*validSensorVibrationQTests*)


validSensorVibrationQTests[packet:PacketP[Object[Sensor,Vibration]]]:={};

(* ::Subsection::Closed:: *)
(*validAccelerationSensorVibrationQTests*)


validSensorAccelerationVibrationQTests[packet:PacketP[Object[Sensor,AccelerationVibration]]]:={};

(* ::Subsection:: *)
(*validSensorLightQTests*)


validSensorLightQTests[packet:PacketP[Object[Sensor,Light]]]:={
}




(* ::Subsection:: *)
(* Test Registration *)


registerValidQTestFunction[Object[Sensor],validSensorQTests];
registerValidQTestFunction[Object[Sensor, CarbonDioxide],validSensorCarbonDioxideQTests];
registerValidQTestFunction[Object[Sensor, Conductivity],validSensorConductivityQTests];
registerValidQTestFunction[Object[Sensor, LiquidLevel],validSensorLiquidLevelQTests];
registerValidQTestFunction[Object[Sensor, pH],validSensorpHQTests];
registerValidQTestFunction[Object[Sensor, Pressure],validSensorPressureQTests];
registerValidQTestFunction[Object[Sensor, RelativeHumidity],validSensorRelativeHumidityQTests];
registerValidQTestFunction[Object[Sensor, Temperature],validSensorTemperatureQTests];
registerValidQTestFunction[Object[Sensor, FlowRate],validSensorFlowRateQTests];
registerValidQTestFunction[Object[Sensor, Volume],validSensorVolumeQTests];
registerValidQTestFunction[Object[Sensor, Distance],validSensorDistanceSensorQTests];
registerValidQTestFunction[Object[Sensor, Weight],validSensorWeightQTests];
registerValidQTestFunction[Object[Sensor, BubbleCounter],validSensorBubbleCounterQTests];
registerValidQTestFunction[Object[Sensor, AccelerationVibration],validSensorAccelerationVibrationQTests];
registerValidQTestFunction[Object[Sensor, Vibration],validSensorVibrationQTests];
registerValidQTestFunction[Object[Sensor, Light],validSensorLightQTests];
