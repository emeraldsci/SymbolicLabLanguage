(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*validStorageConditionQTests*)


validStorageConditionQTests[packet:PacketP[Model[StorageCondition]]] := {
	(* General fields filled in *)
	NotNullFieldTest[packet,{Name,StorageCondition,Temperature,PricingRate,StockingPrices}],

	Test["Condition fields match parameters in $StorageConditions:",
		Lookup[$StorageConditions,Lookup[packet,StorageCondition]],
		<|DeleteCases[KeyTake[packet,{Temperature,Humidity,CarbonDioxide,ShakingRate,PlateShakingRate,VesselShakingRate,ShakingRadius,UVLightIntensity,VisibleLightIntensity}],Null]|>,
		EquivalenceFunction->Equal
	],

	RequiredTogetherTest[packet,{ShakingRate,ShakingRadius}],

	Test["Incubation parameters are only present for incubation conditions:",
		If[!MatchQ[Lookup[packet,StorageCondition],(BacterialIncubation|BacterialShakingIncubation|YeastIncubation|YeastShakingIncubation|MammalianIncubation|ViralIncubation)],
			NullQ[Lookup[packet,{CarbonDioxide,ShakingRate,PlateShakingRate,VesselShakingRate,ShakingRadius}]],
			True
		],
		True
	],

	Test["Both Acid and Base cannot be True simultaneously:",
		Lookup[packet,{Acid,Base}],
		Except[{True,True}]
	],

	Test["The storage condition is included in Experiment`Private`storageConditionTemperatureLookup:",
		MemberQ[Keys[Experiment`Private`storageConditionTemperatureLookup],Lookup[packet,Object]],
		True
	],
	
	RequiredTogetherTest[packet,{Desiccated,AtmosphericCondition}]
};


registerValidQTestFunction[Model[StorageCondition],validStorageConditionQTests];
