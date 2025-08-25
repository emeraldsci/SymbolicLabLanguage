(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*validModelPlumbingQTests*)


validModelPlumbingQTests[packet:PacketP[Model[Plumbing]]] := {

	(* general fields that SHOULD be informed *)
	NotNullFieldTest[packet,{
		Name,
		Authors,
		ImageFile,
		MinTemperature,
		MaxTemperature,
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

	Test["A plumbing component of this model cannot be obtained by both a normal product and a kit product (i.e., Products and KitProducts cannot both be populated):",
		Lookup[packet, {Products, KitProducts}],
		Alternatives[
			{{}, {}},
			{{ObjectP[Object[Product]]..}, {}},
			{{}, {ObjectP[Object[Product]]..}}
		]
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

	FieldComparisonTest[packet,{MinPressure,MaxPressure},Less],
	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},Less],

	(* The name for each non-Null ConnectorGrip entry matches the name of the index-matched Connector. *)
	Test["The name of each non-Null ConnectorGrip matches that the name of the index-matched Connector",
		Module[{connectors, connectorGrips},
			{connectors, connectorGrips} = Lookup[packet, {Connectors, ConnectorGrips}, {}];

			If[MatchQ[connectorGrips, {}],
				True,
				(* Name is the first index of both Connectors and ConnectorGrips *)
				And @@ (MatchQ[#[[1,1]], #[[2,1]]]& /@ PickList[Transpose[{connectors, connectorGrips}], connectorGrips, Except[Null]])
			]
		],
		True
	],

	(* Min is less than Max for ConnectorGrip torque. *)
	Test["Each ConnectorGrip Min Torque is less than or equal to its Max Torque:",
		Module[{connectorGrips, minTorques, maxTorques},
			connectorGrips = Cases[Lookup[packet, ConnectorGrips], {_, _, _, Except[Null], Except[Null]}];

			If[MatchQ[connectorGrips, {}],
				True,

				(* Pull out the min and max torques for the field. *)
				minTorques = connectorGrips[[All, 4]];
				maxTorques = connectorGrips[[All, 5]];

				(* Name is the first index of both Connectors and ConnectorGrips *)
				And @@ MapThread[LessEqualQ[#1, #2]&, {minTorques, maxTorques}]
			]
		],
		True
	]
	
};


(* ::Subsection:: *)
(*validModelPlumbingAspirationCapQTests*)


validModelPlumbingAspirationCapQTests[packet:PacketP[Model[Plumbing, AspirationCap]]] := {

	(* shared fields that should NOT be informed *)
	NullFieldTest[packet,{
		Size
	}],
	
	(* shared fields that SHOULD be informed *)
	NotNullFieldTest[packet, {
		WettedMaterials,
		InnerDiameter,
		OuterDiameter,
		Connectors,
		DeadVolume,
		FluidCategory,
		MinPressure,
		MaxPressure
	}],
	
	FieldComparisonTest[packet,{InnerDiameter,OuterDiameter},Less]

};


(* ::Subsection:: *)
(*validModelPlumbingCableQTests*)


validModelPlumbingCableQTests[packet:PacketP[Model[Plumbing, Cable]]]:={

	(* fields that should NOT be informed *)
	NullFieldTest[packet,{
		WettedMaterials,
		DeadVolume,
		FluidCategory,
		MinPressure,
		MaxPressure,
		PreferredWashBin,
		CleaningMethod
	}],
	
	(* fields that SHOULD be informed *)
	NotNullFieldTest[packet, {
		Size,
		OuterDiameter
	}]
	
};


(* ::Subsection:: *)
(*validModelPlumbingCapQTests*)


validModelPlumbingCapQTests[packet:PacketP[Model[Plumbing,Cap]]]:={

	(* fields that should NOT be informed *)
	NullFieldTest[packet,{
		Size,
		InnerDiameter,
		OuterDiameter,
		DeadVolume,
		MinPressure,
		MaxPressure
	}],
	
	(* fields that SHOULD be informed *)
	NotNullFieldTest[packet, {
		WettedMaterials,
		Connectors,
		FluidCategory
	}]

};


(* ::Subsection:: *)
(*validModelPlumbingColumnJoinQTests*)


validModelPlumbingColumnJoinQTests[packet:PacketP[Model[Plumbing, ColumnJoin]]] := {

	(* fields that should NOT be informed *)
	NullFieldTest[packet,{
		Size,
		PreferredWashBin,
		CleaningMethod
	}],
	
	(* fields that SHOULD be informed *)
	NotNullFieldTest[packet, {
		WettedMaterials,
		InnerDiameter,
		Connectors,
		FluidCategory,
		MinPressure,
		MaxPressure
	}]

};


(* ::Subsection:: *)
(*validModelPlumbingFittingQTests*)


validModelPlumbingFittingQTests[packet:PacketP[Model[Plumbing,Fitting]]]:={

	(* fields that should NOT be informed *)
	NullFieldTest[packet,{
		Size,
		OuterDiameter,
		DeadVolume,
		PreferredWashBin,
		CleaningMethod
	}],

	(* fields that SHOULD be informed *)
	NotNullFieldTest[packet,{
		Valved,
		Angle,
		InnerDiameter,
		Connectors,
		MinPressure,
		MaxPressure
	}]

};

(* ::Subsection:: *)
(*validModelPlumbing,GasDispersionTubeQTests*)


validModelPlumbingGasDispersionTubeQTests[packet:PacketP[Model[Plumbing,GasDispersionTube]]]:={

	(* fields that SHOULD be informed *)
	NotNullFieldTest[packet,{
		Size,
		OuterDiameter,
		MinFritPoreSize,
		MaxFritPoreSize
	}]

};


(* ::Subsection:: *)
(*validModelPlumbingFerruleQTests*)


validModelPlumbingFerruleQTests[packet:PacketP[Model[Plumbing,Ferrule]]]:={

	(* fields that should NOT be informed *)
	NullFieldTest[packet,{
		Size,
		OuterDiameter,
		DeadVolume,
		PreferredWashBin,
		CleaningMethod
	}],

	(* fields that SHOULD be informed *)
	NotNullFieldTest[packet,{
		InnerDiameter,
		MaxPressure
	}]

};


(* ::Subsection:: *)
(*validModelPlumbingFerruleNutQTests*)


validModelPlumbingFerruleNutQTests[packet:PacketP[Model[Plumbing,FerruleNut]]]:={

	(* fields that should NOT be informed *)
	NullFieldTest[packet,{
		Size,
		OuterDiameter,
		DeadVolume,
		PreferredWashBin,
		CleaningMethod
	}],

	(* fields that SHOULD be informed *)
	NotNullFieldTest[packet,{
		InnerDiameter
	}]

};


(* ::Subsection:: *)
(*validModelPlumbingManifoldQTests*)


validModelPlumbingManifoldQTests[packet:PacketP[Model[Plumbing,Manifold]]]:={

	(* fields that should NOT be informed *)
	NullFieldTest[packet,{
		Size,
		OuterDiameter,
		PreferredWashBin,
		CleaningMethod
	}],
	
	(* fields that SHOULD be informed *)
	NotNullFieldTest[packet,{
		WettedMaterials,
		InnerDiameter,
		Connectors,
		FluidCategory,
		MinPressure,
		MaxPressure
	}]

};


(* ::Subsection:: *)
(*validModelPlumbingPipeQTests*)


validModelPlumbingPipeQTests[packet:PacketP[Model[Plumbing,Pipe]]]:={

	(* fields that should NOT be informed *)
	NullFieldTest[packet,{
		DeadVolume,
		PreferredWashBin,
		CleaningMethod
	}],
	
	(* fields that SHOULD be informed *)
	NotNullFieldTest[packet, {
		Size,
		WettedMaterials,
		InnerDiameter,
		OuterDiameter,
		Connectors,
		FluidCategory,
		MinPressure,
		MaxPressure
	}],

	FieldComparisonTest[packet,{InnerDiameter,OuterDiameter},Less]

};

(* ::Subsection:: *)
(*validModelPlumbingSampleLoopQTests*)


validModelPlumbingSampleLoopQTests[packet:PacketP[Model[Plumbing,SampleLoop]]]:={

	(* fields that should NOT be informed *)
	NullFieldTest[packet,{
		DeadVolume,
		PreferredWashBin,
		CleaningMethod
	}],

	(* fields that SHOULD be informed *)
	NotNullFieldTest[packet, {
		MaxVolume,
		Size,
		WettedMaterials,
		InnerDiameter,
		OuterDiameter,
		Connectors,
		FluidCategory
	}],

	FieldComparisonTest[packet,{InnerDiameter,OuterDiameter},Less]

};


(* ::Subsection:: *)
(*validModelPlumbingTubingQTests*)


validModelPlumbingTubingQTests[packet:PacketP[Model[Plumbing,Tubing]]]:={

	(* fields that should NOT be informed *)
	NullFieldTest[packet,{
		DeadVolume,
		PreferredWashBin,
		CleaningMethod
	}],
	
	(* fields that SHOULD be informed *)
	NotNullFieldTest[packet, {
		Size,
		WettedMaterials,
		InnerDiameter,
		OuterDiameter,
		Connectors,
		FluidCategory,
		MinPressure,
		MaxPressure
	}],

	FieldComparisonTest[packet,{InnerDiameter,OuterDiameter},Less]

};

(* ::Subsection:: *)
(*validModelPlumbingPrecutTubingQTests*)


validModelPlumbingPrecutTubingQTests[packet:PacketP[Model[Plumbing,PrecutTubing]]]:={
	
	(* fields that should NOT be informed *)
	NullFieldTest[packet,{
		DeadVolume,
		PreferredWashBin,
		CleaningMethod
	}],
	
	(* fields that SHOULD be informed *)
	NotNullFieldTest[packet,{
		Size,
		WettedMaterials,
		InnerDiameter,
		OuterDiameter,
		Connectors,
		FluidCategory,
		MinPressure,
		MaxPressure,
		Gauge,
		ParentTubing
	}],
	
	FieldComparisonTest[packet,{InnerDiameter,OuterDiameter},Less]
	
};



(* ::Subsection:: *)
(*validModelPlumbingValveQTests*)


validModelPlumbingValveQTests[packet:PacketP[Model[Plumbing,Valve]]]:={

	(* fields that should NOT be informed *)
	NullFieldTest[packet,{
		Size,
		OuterDiameter,
		PreferredWashBin,
		CleaningMethod
	}],
	
	(* fields that SHOULD be informed *)
	NotNullFieldTest[packet,{
		ValveType,
		ValveOperation,
		ValvePositions,
		Actuator,
		WettedMaterials,
		InnerDiameter,
		Connectors,
		FluidCategory,
		MinPressure,
		MaxPressure
	}],

	Test["If ValveType is Check, there is only one ValvePosition",
		Lookup[packet,{ValveType,ValvePositions}],
		{Check,{ValvePositionP}}|{Except[Check],_}
	]
	
};


(* ::Subsection:: *)
(* Test Registration *)


registerValidQTestFunction[Model[Plumbing],validModelPlumbingQTests];
registerValidQTestFunction[Model[Plumbing,AspirationCap],validModelPlumbingAspirationCapQTests];
registerValidQTestFunction[Model[Plumbing,Cable],validModelPlumbingCableQTests];
registerValidQTestFunction[Model[Plumbing,Cap],validModelPlumbingCapQTests];
registerValidQTestFunction[Model[Plumbing,ColumnJoin],validModelPlumbingColumnJoinQTests];
registerValidQTestFunction[Model[Plumbing,Ferrule],validModelPlumbingFerruleQTests];
registerValidQTestFunction[Model[Plumbing,FerruleNut],validModelPlumbingFerruleNutQTests];
registerValidQTestFunction[Model[Plumbing,Fitting],validModelPlumbingFittingQTests];
registerValidQTestFunction[Model[Plumbing,GasDispersionTube],validModelPlumbingGasDispersionTubeQTests];
registerValidQTestFunction[Model[Plumbing,Manifold],validModelPlumbingManifoldQTests];
registerValidQTestFunction[Model[Plumbing,Pipe],validModelPlumbingPipeQTests];
registerValidQTestFunction[Model[Plumbing,SampleLoop],validModelPlumbingSampleLoopQTests];
registerValidQTestFunction[Model[Plumbing,Tubing],validModelPlumbingTubingQTests];
registerValidQTestFunction[Model[Plumbing,PrecutTubing],validModelPlumbingPrecutTubingQTests];
registerValidQTestFunction[Model[Plumbing,Valve],validModelPlumbingValveQTests];
