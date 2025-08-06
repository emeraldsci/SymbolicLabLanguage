(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*validModelWiringQTests*)


validModelWiringQTests[packet:PacketP[Model[Wiring]]] := {

	(* general fields that SHOULD be informed *)
	NotNullFieldTest[packet,{
		Name,
		Authors,
		ImageFile,
		MaxVoltage,
		MaxCurrent,
		MinTemperature,
		MaxTemperature,
		WiringConnectors,
		WiringDiameters,
		DefaultStorageCondition,
		Dimensions
	}],


	Test["If StickerPositionOnReceiving is populated, PositionStickerPlacementImage is also populated and vise versa",
		Lookup[packet,{StickerPositionOnReceiving,PositionStickerPlacementImage}],
		Alternatives[
			{Null,Null},
			{Except[Null],Except[Null]}
		]
	],

	Test["If StickerConnectionOnReceiving is populated, ConnectionStickerPlacementImage is also populated and vise versa",
		Lookup[packet,{StickerConnectionOnReceiving,ConnectionStickerPlacementImage}],
		Alternatives[
			{Null,Null},
			{Except[Null],Except[Null]}
		]
	],

	Test["If Deprecated is True, Products must also be Deprecated:",
		If[TrueQ[Lookup[packet,Deprecated]],
			Download[Lookup[packet,Products],Deprecated],
			Null
		],
		{True..}|Null
	],

	Test["A wiring component of this model cannot be obtained by both a normal product and a kit product (i.e., Products and KitProducts cannot both be populated):",
		Lookup[packet, {Products, KitProducts}],
		Alternatives[
			{{}, {}},
			{{ObjectP[Object[Product]]..}, {}},
			{{}, {ObjectP[Object[Product]]..}}
		]
	],

	Test["Every member of WiringConnectors also has a corresponding WiringDiameters entry:",
		MatchQ[Length[Lookup[packet,WiringConnectors]],Length[Lookup[packet,Wiring]]],
		{}
	],

	Test["If the StorageOrientation is Side|Face StorageOrientationImage must be populated:",
		Lookup[packet, {StorageOrientation, StorageOrientationImage}],
		Alternatives[
			{(Side|Face), ObjectP[]},
			{Except[(Side|Face)], _}
		]
	],

	Test["If the StorageOrientation is Upright StorageOrientationImage or ImageFile must be populated:",
		Lookup[packet, {StorageOrientation, StorageOrientationImage, ImageFile}],
		Alternatives[
			{Upright, ObjectP[], _},
			{Upright, _, ObjectP[]},
			{Except[Upright], _, _}
		]
	],

	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},Less]
	
};


(* ::Subsection:: *)
(*validModelWiringCableQTests*)

validModelWiringCableQTests[packet:PacketP[Model[Wiring,CircuitBreaker]]]:={};

(* ::Subsection:: *)
(*validModelWiringCableAdapterQTests*)

validModelWiringCableAdapterQTests[packet:PacketP[Model[Wiring,CircuitBreaker]]]:={};

(* ::Subsection:: *)
(*validModelWiringCircuitBreakerQTests*)


validModelWiringCircuitBreakerQTests[packet:PacketP[Model[Wiring,CircuitBreaker]]]:={

	NotNullFieldTest[packet,{
		CircuitBreakerType,
		BreakingCapacity,
		NumberOfSpaces
	}]

};


(* ::Subsection:: *)
(*validModelWiringNetworkHubQTests*)


validModelWiringNetworkHubQTests[packet:PacketP[Model[Wiring,NetworkHub]]]:={

	NotNullFieldTest[packet,{
		NumberOfPorts,
		PowerOverEthernet
	}]

};


(* ::Subsection:: *)
(*validModelWiringPLCComponentQTests*)


validModelWiringPLCComponentQTests[packet:PacketP[Model[Wiring,PLCComponent]]]:={

};


(* ::Subsection:: *)
(*validModelWiringPowerStripQTests*)


validModelWiringPowerStripQTests[packet:PacketP[Model[Wiring,PowerStrip]]]:={

	NotNullFieldTest[packet,{
		NumberOfOutlets,
		SurgeProtection
	}]

};


(* ::Subsection:: *)
(*validModelWiringReceptacleQTests*)


validModelWiringReceptacleQTests[packet:PacketP[Model[Wiring,Receptacle]]]:={

	NotNullFieldTest[packet,{
		OutputVoltage,
		NumberOfTerminals,
		NumberOfOutlets
	}]

};


(* ::Subsection:: *)
(*validModelWiringTransformerQTests*)


validModelWiringTransformerQTests[packet:PacketP[Model[Wiring,Transformer]]]:={

	NotNullFieldTest[packet,{
		ElectricalPhase,
		TransformerType,
		MaxVoltAmperes,
		InputVoltage,
		OutputVoltage
	}]

};


(* ::Subsection:: *)
(* Test Registration *)


registerValidQTestFunction[Model[Wiring],validModelWiringQTests];
registerValidQTestFunction[Model[Wiring,Cable],validModelWiringCableQTests];
registerValidQTestFunction[Model[Wiring,CableAdapter],validModelWiringCableAdapterQTests];
registerValidQTestFunction[Model[Wiring,CircuitBreaker],validModelWiringCircuitBreakerQTests];
registerValidQTestFunction[Model[Wiring,NetworkHub],validModelWiringNetworkHubQTests];
registerValidQTestFunction[Model[Wiring,PLCComponent],validModelWiringPLCComponentQTests];
registerValidQTestFunction[Model[Wiring,PowerStrip],validModelWiringPowerStripQTests];
registerValidQTestFunction[Model[Wiring,Receptacle],validModelWiringReceptacleQTests];
registerValidQTestFunction[Model[Wiring,Transformer],validModelWiringTransformerQTests];
