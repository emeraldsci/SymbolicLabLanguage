(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validModelItemQTests*)


validModelItemQTests[packet : PacketP[Model[Item]]] := With[
	{
		prodPackets = Download[Lookup[packet, Products], Packet[Deprecated,CountPerSample]]
	},
	{

		(* General fields filled in *)
		(* Note: If you add field here, also add it to the Column VOQ tests so it throws a message. *)
		(* NOTE: removed Name and Synonyms from NotNullFieldTest and moved related Tests in subtypes *)
		NotNullFieldTest[packet, {Authors, DefaultStorageCondition, Dimensions, DefaultStorageCondition}],

		(* If Expires \[Equal] True, then either ShelfLife or UnsealedShelfLife must be informed. If either ShelfLife or UnsealedShelfLife is informed, then Expires must \[Equal] True. *)
		Test["Either ShelfLife or UnsealedShelfLife must be informed if Expires == True; if either ShelfLife or UnsealedShelfLife is informed, Expires must equal True:",
			Lookup[packet, {Expires, ShelfLife, UnsealedShelfLife}],
			Alternatives[{True, Except[NullP | {}], NullP | {}}, {True, NullP | {}, Except[NullP | {}]}, {True, Except[NullP | {}], Except[NullP | {}]}, {Except[True], NullP | {}, NullP | {}}]
		],

		Test["If Deprecated is True, Products must also be Deprecated:",
			If[MatchQ[Lookup[packet, Deprecated], True],
				Lookup[prodPackets, Deprecated, {}],
				Null
			],
			{True..} | Null
		],

		Test["A sample of this model cannot be obtained by both a normal product and a kit product (i.e., Products and KitProducts cannot both be populated):",
			Lookup[packet, {Products, KitProducts}],
			Alternatives[
				{{}, {}},
				{{ObjectP[Object[Product]]..}, {}},
				{{}, {ObjectP[Object[Product]]..}}
			]
		],


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

		Test["If MSDSRequired is True, then MSDSFile must be informed:",
			Lookup[packet, {MSDSRequired, MSDSFile}],
			{True, Except[NullP | {}]} | {False | Null, _}
		],
		Test["If MSDSRequired is True, then Flammable must be informed:",
			Lookup[packet, {MSDSRequired, Flammable}],
			{True, Except[NullP | {}]} | {False | Null, _}
		],
		Test["If MSDSRequired is True, then NFPA must be informed:",
			Lookup[packet, {MSDSRequired, NFPA}],
			{True, Except[NullP | {}]} | {False | Null, _}
		],
		Test["If MSDSRequired is True, then DOTHazardClass must be informed:",
			Lookup[packet, {MSDSRequired, DOTHazardClass}],
			{True, Except[NullP | {}]} | {False | Null, _}
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
		Test["If the item is marked as Counted, then all non-deprecated products must have CountPerSample set:",
			{
				Lookup[Select[prodPackets,!TrueQ[Lookup[#,Deprecated]]&],CountPerSample,{}],
				Lookup[packet, Counted]
			},
			{{_Integer...},True} | {{Null...},False|Null}
		],

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
	}
];

errorToOptionMap[Model[Item]]:={};


(* ::Subsection::Closed:: *)
(*validModelItemArrayCardSealerQTests*)


validModelItemArrayCardSealerQTests[packet:PacketP[Model[Item,ArrayCardSealer]]]:={};


(* ::Subsection::Closed:: *)
(*validModelItemBLIProbeQTests*)


validModelItemBLIProbeQTests[packet : PacketP[Model[Item, BLIProbe]]] := {

	(*Unique fields that should be informed*)
	NotNullFieldTest[packet,
		{
			ProbeSurfaceComposition,
			RecommendedApplication,
			IntendedAnalyte
		}
	],

	(*Unique fields that should all be informed or all be Null*)
	RequiredTogetherTest[packet,
		{
			RegenerationSolutions,
			RegenerationDuration,
			RegenerationShakeRate,
			RegenerationCycles
		}
	],

	(*Shared fields that should be informed*)
	NotNullFieldTest[packet,
		{
			Name,
			Synonyms,
			Expires
		}
	],

	(*Shared fields that should not be informed*)
	NullFieldTest[packet,
		{
			Flammable,
			IncompatibleMaterials,
			MSDSRequired,
			NFPA,
			DOTHazardClass,
			Radioactive,
			Ventilated,
			DrainDisposal
		}
	],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	],

	(*tests to check that if Kinetics or Quantitation is informed, so is the relevant regeneration information*)
	Test["The KineticsRegeneration or QuantitationRegeneration field must be informed when RecommendedApplication contains Kinetics or Quantitation:",
		Module[{recommendedApplication, kineticsRegeneration, quantitationRegeneration, containsKinetics, containsQuantitation},
			{recommendedApplication, kineticsRegeneration, quantitationRegeneration} =
				Lookup[packet, {RecommendedApplication, KineticsRegeneration, QuantitationRegeneration}];
		If[MemberQ[ToList[recommendedApplication], Kinetics], containsKinetics = True];
		If[MemberQ[ToList[recommendedApplication], Quantitation], containsQuantitation = True];
		{containsKinetics, containsQuantitation, kineticsRegeneration, quantitationRegeneration}
		],
		Alternatives[
			{True, _, Except[NullP], _},
			{_, True, _, Except[NullP]},
			{True, True, Except[NullP], Except[NullP]}
		]
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemClampQTests*)


validModelItemClampQTests[packet:PacketP[Model[Item,Clamp]]]:={
	NotNullFieldTest[
		packet,
		{
			InnerDiameter
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemConsumableQTests*)


validModelItemConsumableQTests[packet:PacketP[Model[Item,Consumable]]]:={

	(* Fields that should be filled in *)
	NotNullFieldTest[packet,{Name, Synonyms}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemConsumableBladeQTests*)


validModelItemConsumableBladeQTests[packet:PacketP[Model[Item,Consumable,Blade]]]:=
{
	(* Fields that should be filled in *)
	NotNullFieldTest[packet,{BladeMaterial,BladeLength,BladeWidth}]
};


(* ::Subsection::Closed:: *)
(*validModelItemConsumableSandpaperQTests*)


validModelItemConsumableSandpaperQTests[packet:PacketP[Model[Item,Consumable,Sandpaper]]]:=
	{
		(* Fields that should be filled in *)
		NotNullFieldTest[packet,{Grit}]
	};


(* ::Subsection::Closed:: *)
(*validModelItemCapQTests*)


validModelItemCapQTests[packet:PacketP[Model[Item, Cap]]]:={

	NullFieldTest[packet,
		{
			MSDSFile,
			MSDSRequired,
			NFPA,
			DOTHazardClass,
			BiosafetyLevel,
			TransportTemperature,
			Flammable,
			IncompatibleMaterials,
			LightSensitive
		}
	],

	(* unique fields *)
	NotNullFieldTest[packet,{CoverType,CoverFootprint,Name,Synonyms,ImageFile}],

	Test["CrimpingPressure cannot be filled out if CoverType is not Crimp:",
		Lookup[packet, {CrimpingPressure, CoverType}],
		{UnitsP[PSI], Crimp}|{Null, _}
	],

	Test["If CoverType->Crimp, CrimpType is informed:",
		Lookup[packet, {CoverType, CrimpType}],
		{Crimp, Except[Null]}|{Except[Crimp], _}
	],

	Test["If CoverType->Crimp, Reusable is False:",
		Lookup[packet, {CoverType, Reusable}],
		{Crimp, False}|{Except[Crimp], _}
	],

	Test["If CoverType->Crimp, Pierceable is informed:",
		Lookup[packet, {CoverType, Pierceable}],
		{Crimp, Except[Null]}|{Except[Crimp], _}
	],

	Test["If CoverType->Crimp, SeptumRequired is informed:",
		Lookup[packet, {CoverType, SeptumRequired}],
		{Crimp, Except[Null]}|{Except[Crimp], _}
	],

	Test["CoverType cannot be Seal:",
		Lookup[packet, CoverType],
		Except[Seal]
	],

	Test["If the width and depth of the Cap are under 41mm, Barcode should NOT be True (since it won't fit on the cover):",
		If[MatchQ[Lookup[packet, Dimensions][[1;;2]], {LessP[41 Millimeter], LessP[41 Millimeter]}],
			!MatchQ[Lookup[packet, Barcode], True],
			True
		],
		True
	],

	Test["If the width or depth of the Cap is over 54mm (the diameter of a GL45 cap), Barcode should be True:",
		If[MemberQ[Lookup[packet, Dimensions][[1;;2]], GreaterP[54 Millimeter]],
			MatchQ[Lookup[packet, Barcode], True],
			True
		],
		True
	],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	],
	RequiredTogetherTest[packet, {InnerDiameter, OuterDiameter}],
	FieldComparisonTest[packet,{InnerDiameter,OuterDiameter},Less],
	RequiredTogetherTest[packet, {Positions, PositionPlotting}]
};


(* ::Subsection::Closed:: *)
(*validModelItemStopperQTests*)


validModelItemStopperQTests[packet:PacketP[Model[Item, Stopper]]]:={

	NullFieldTest[packet,{
		MSDSFile,
		MSDSRequired,
		NFPA,
		DOTHazardClass,
		BiosafetyLevel,
		TransportTemperature,
		Flammable,
		IncompatibleMaterials,
		LightSensitive
	}
	],

	(* unique fields *)
	NotNullFieldTest[packet,{CoverFootprint}]
};



(* ::Subsection::Closed:: *)
(*validModelItemPlateSealQTests*)


validModelItemPlateSealQTests[packet : PacketP[Model[Item, PlateSeal]]] := {

	NullFieldTest[packet, {
		MSDSFile,
		MSDSRequired,
		NFPA,
		DOTHazardClass,
		BiosafetyLevel,
		TransportTemperature,
		Flammable,
		IncompatibleMaterials,
		LightSensitive
	}],

	(* unique fields *)
	NotNullFieldTest[packet, {CoverType, CoverFootprint, SealType, Name, Synonyms, ImageFile, Pierceable, MinTemperature, MaxTemperature, RestingOrientation}],

	Test["CoverType must be Seal:",
		Lookup[packet, CoverType],
		Seal
	],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	],

	RequiredTogetherTest[packet, {Positions, PositionPlotting}],
	FieldComparisonTest[packet, {MaxTemperature, MinTemperature}, GreaterEqual]
};


(* ::Subsection::Closed:: *)
(*validModelItemCapElectrodeCapQTests*)


validModelItemCapElectrodeCapQTests[packet:PacketP[Model[Item,Cap,ElectrodeCap]]]:={

	(* Non-Shared Field Not Null: *)
	NotNullFieldTest[packet,{
		ElectrodeCapType,
		MaxNumberOfUses
	}]
};


(* ::Subsection::Closed:: *)
(*validModelItemCapElectrodeCapCalibrationCapQTests*)


validModelItemCapElectrodeCapCalibrationCapQTests[packet:PacketP[Model[Item,Cap,ElectrodeCap,CalibrationCap]]]:={
};


(* ::Subsection::Closed:: *)
(*validModelItemBlankQTests*)


validItemBlankQTests[packet:PacketP[Model[Item, Blank]]]:={

	(*Fields that should be informed*)
	NotNullFieldTest[packet,{Name, Synonyms, Model,CrossSectionalShape,BlankMaterial}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemCrossFlowFilterQTests*)


validModelItemCrossFlowFilterQTests[packet:PacketP[Model[Item,CrossFlowFilter]]]:={

	NullFieldTest[packet,{
		MSDSFile,
		MSDSRequired,
		NFPA,
		DOTHazardClass,
		BiosafetyLevel,
		TransportTemperature,
		Flammable,
		LightSensitive
	}],

	(* Unique fields *)
	NotNullFieldTest[packet,{
		Name,
		Synonyms,
		ModuleFamily,
		SizeCutoff,
		MembraneMaterial,
		FilterSurfaceArea,
		ModuleCondition,
		MinVolume,
		MaxVolume,
		DefaultFlowRate,
		FilterType
	}],

	(* Required together *)
	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	],

	Test[
		"Object has at least three connectors with names \"Feed Pressure Sensor Inlet\", \"Retentate Pressure Sensor Outlet\" and \"Permeate Pressure Sensor Inlet\":",
		MemberQ[Lookup[packet,Connectors][[All,1]],#]&/@{"Feed Pressure Sensor Inlet","Retentate Pressure Sensor Outlet","Permeate Pressure Sensor Inlet"},
		{True,True,True}
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemDialysisMembraneQTests*)


validModelItemDialysisMembraneQTests[packet:PacketP[Model[Item, DialysisMembrane]]]:={

    NullFieldTest[packet,{
            MSDSFile,
            MSDSRequired,
            NFPA,
            DOTHazardClass,
            BiosafetyLevel,
						TransportTemperature,
            Flammable,
            IncompatibleMaterials,
            LightSensitive
        }
    ],

	(* unique fields *)
	NotNullFieldTest[packet,{
		Name,
		Synonyms,
		MolecularWeightCutoff,
		MembraneMaterial,
		FlatWidth,
		VolumePerLength,
		MinTemperature,
		MaxTemperature,
		MinpH,
		MaxpH
	}
	],

	(*Required Together*)
	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemLidQTests*)


validModelItemLidQTests[packet : PacketP[Model[Item, Lid]]] := {

	NullFieldTest[packet,
		{
			MSDSFile,
			MSDSRequired,
			NFPA,
			DOTHazardClass,
			BiosafetyLevel,
			TransportTemperature,
			Flammable,
			IncompatibleMaterials,
			LightSensitive
		}
	],

	(* unique fields *)
	NotNullFieldTest[packet, {CoverType, CoverFootprint, Name, Synonyms, CondensationRings, ImageFile, RestingOrientation}],

	RequiredTogetherTest[packet, {NumberOfRings, Rows, Columns, AspectRatio}],

	Test["CoverType cannot be Crimp, Seal, Screw, or Pry:",
		Lookup[packet, CoverType],
		Except[Crimp | Seal | Screw | Pry]
	],

	Test["If and only if Columns is greater than 1, HorizontalPitch and HorizontalMargin are informed:",
		Lookup[packet, {Columns, HorizontalPitch, HorizontalMargin}],
		{GreaterP[1], Except[NullP], Except[NullP]} | {Except[GreaterP[1]], _, _}
	],

	Test["If and only if Rows is greater than 1, VerticalPitch and VerticalMargin area informed:",
		Lookup[packet, {Rows, VerticalPitch, VerticalMargin}],
		{GreaterP[1], Except[NullP], Except[NullP]} | {Except[GreaterP[1]], _, _}
	],

	Test["If both Rows and Columns are non-Null, then AspectRatio must be informed and must be equal to Columns/Rows. Otherwise, AspectRatio cannot be informed:",
		Lookup[packet, {Rows, Columns, AspectRatio}],
		Alternatives[
			{Except[NullP], Except[NullP], _?(Equal[Rationalize[#], Divide @@ Lookup[packet, {Columns, Rows} ]]&)},
			{NullP, NullP, NullP}
		]
	],

	Test["If both Rows and Columns are non-Null, then NumberOfRings must be equal to Rows*Columns:",
		Lookup[packet, {Rows, Columns, NumberOfRings}],
		Alternatives[
			{Except[NullP], Except[NullP], Times @@ Lookup[packet, {Rows, Columns}]},
			{NullP, NullP, NullP}
		]
	],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemLidSpacerQTests*)


validModelItemLidSpacerQTests[packet:PacketP[Model[Item, LidSpacer]]]:={

	NullFieldTest[packet,{
			MSDSFile,
			MSDSRequired,
			NFPA,
			DOTHazardClass,
			BiosafetyLevel,
			TransportTemperature,
			Flammable,
			IncompatibleMaterials,
			LightSensitive
		}
	],

	(* unique fields *)
	NotNullFieldTest[packet,{Name, Synonyms, Material}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemCartridgeQTests*)


validModelItemCartridgeQTests[packet:PacketP[Model[Item,Cartridge]]]:={

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,{Name,Synonyms,CartridgeType,CartridgeType}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};



(* ::Subsection::Closed:: *)
(*validModelItemCartridgeColumnQTests*)


validModelItemCartridgeColumnQTests[packet:PacketP[Model[Item,Cartridge,Column]]]:={

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,{MaxPressure,MaxFlowRate,SeparationMode,Name,Synonyms,MaxNumberOfUses,PreferredGuardColumn,Diameter}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	],

	RequiredTogetherTest[packet,{InletFilterThickness,InletFilterMaterial}],

	(* Inequality tests *)
	FieldComparisonTest[packet,{ParticleSize,PoreSize},GreaterEqual],
	FieldComparisonTest[packet,{MaxPressure,MinPressure},GreaterEqual],
	FieldComparisonTest[packet,{MaxFlowRate,MinFlowRate},GreaterEqual],
	FieldComparisonTest[packet,{MaxFlowRate,NominalFlowRate},GreaterEqual],
	FieldComparisonTest[packet,{NominalFlowRate,MinFlowRate},GreaterEqual],
	FieldComparisonTest[packet,{MaxTemperature,MinTemperature},GreaterEqual],
	FieldComparisonTest[packet,{MaxpH,MinpH},GreaterEqual]
};


(* ::Subsection::Closed:: *)
(*validModelItemColumnQTests*)


validModelItemColumnQTests[packet : PacketP[Model[Item, Column]]] := With[
	{
		identifier = FirstCase[Lookup[packet, {Name, Object}], Except[_Missing], packet],
		guardCartridgePacket = Download[
			Lookup[packet, PreferredGuardCartridge, Null],
			Packet[SeparationMode, MaxpH, MaxPressure, MaxTemperature, MinFlowRate, MinpH, MinPressure, MinTemperature, NominalFlowRate, MaxFlowRate, PackingMaterial]
		]
	},

	{

		(* Safety fields should be Null, as it is not required *)
		NullFieldTest[packet, {LightSensitive, Flammable, IncompatibleMaterials, MSDSRequired, NFPA, DOTHazardClass, BiosafetyLevel, Radioactive, Ventilated, DrainDisposal}],

		(* Fields that SHOULD be informed, ie should NOT be Null*)
		NotNullFieldTest[packet, {Authors, Name, Synonyms, MaxPressure, MaxFlowRate, PackingType, ColumnType, MaxNumberOfUses, Name, Synonyms}, Message -> Hold[Error::RequiredOptions], MessageArguments -> {identifier}],

		Test["The contents of the Name field is a member of the Synonyms field:",
			MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
			True,
			Message -> Hold[Error::NameIsNotPartOfSynonymsColumn],
			MessageArguments -> {identifier}
		],
		Test["SeparationMode should be informed if the ColumnType is not a Join, unless ChromatographyType is GasChromatography:",
			Lookup[packet, {ColumnType, SeparationMode, ChromatographyType}],
			Alternatives[
				{Join, _, _},
				{_, _, GasChromatography},
				{Except[Join], Except[Null], Except[GasChromatography]}
			],
			Message -> Hold[Error::SeparationMode],
			MessageArguments -> {identifier}
		],
		Test["ChromatographyType must be GasChromatography if the SeparationMode is GasChromatography:",
			Lookup[packet, {SeparationMode, ChromatographyType}],
			Alternatives[
				{GasChromatography, GasChromatography},
				{Except[GasChromatography], Except[GasChromatography]}
			],
			Message -> Hold[Error::ChromatographyType],
			MessageArguments -> {identifier}
		],
		Test["Connectors must contain entries for 'Column Inlet' and 'Column Outlet' if ChromatographyType is GasChromatography:",
			If[MatchQ[Lookup[packet, ChromatographyType], GasChromatography],
				MemberQ[Lookup[packet, Connectors], {"Column Inlet", ___}] && MemberQ[Lookup[packet, Connectors], {"Column Outlet", ___}],
				True
			],
			True,
			Message -> Hold[Error::ColumnConnectors],
			MessageArguments -> {identifier}
		],
		(*The FilmThickness Option must be filled out if Model's Chromatography Type is GasChromatography*)
		Test["FilmThickness Option must be filled out if Model's Chromatography Type is GasChromatography:",
			If[MatchQ[Lookup[packet,Model],GasChromatography],
				!NullQ[packet,FilmThickness],
				True
			],
			True
		],
		Test["ProtectedColumns can only be informed if ColumnType->Guard:",
			Lookup[packet, {ColumnType, ProtectedColumns}],
			{Guard, _} | {Except[Guard], NullP | {}},
			Message -> Hold[Error::OnlyGuardProtectedColumns],
			MessageArguments -> {identifier}
		],
		Test["PreferredGuardColumn can only be informed if ColumnType is not Guard:",
			Lookup[packet, {ColumnType, PreferredGuardColumn}],
			{Except[Guard], _} | {Guard, NullP | {}},
			Message -> Hold[Error::PreferredGuardColumn],
			MessageArguments -> {identifier}
		],

		Test["The options InletFilterThickness and InletFilterMaterial should be informed together:",
			Lookup[packet, {ColumnType, ProtectedColumns}, Null],
			{Null, Null} | {Except[Null], Except[Null]},
			Message -> Hold[Error::InletOptionsRequiredTogether],
			MessageArguments -> {identifier}
		],

		If[MatchQ[Lookup[packet, {ColumnType, PackingType}], {Guard, Cartridge}],
			Nothing,
			NotNullFieldTest[packet, {WettedMaterials, Diameter}, Message -> Hold[Error::RequiredOptions], MessageArguments -> {identifier}]
		],

		(* Inequality tests *)
		Test["The option ParticleSize must have values greater than or equal to the respective option PoreSize:",
			If[MatchQ[Lookup[packet, ParticleSize, Null], Except[Null]] && MatchQ[Lookup[packet, PoreSize, Null], Except[Null]],
				GreaterEqual[Lookup[packet, ParticleSize], Lookup[packet, PoreSize]],
				True
			],
			True,
			Message -> Hold[Error::WettedMaterialsSpecified],
			MessageArguments -> {identifier}
		],
		Test["The option MaxPressure must have values greater than or equal to the respective option MinPressure:",
			If[MatchQ[Lookup[packet, MaxPressure, Null], Except[Null]] && MatchQ[Lookup[packet, MinPressure, Null], Except[Null]],
				GreaterEqual[Lookup[packet, MaxPressure], Lookup[packet, MinPressure]],
				True
			],
			True,
			Message -> Hold[Error::MaxMinPressureInvalidInequalityOptions],
			MessageArguments -> {identifier}
		],
		Test["The option MaxFlowRate must have values greater than or equal to the respective option MinFlowRate:",
			If[MatchQ[Lookup[packet, MaxFlowRate, Null], Except[Null]] && MatchQ[Lookup[packet, MinFlowRate, Null], Except[Null]],
				GreaterEqual[Lookup[packet, MaxFlowRate], Lookup[packet, MinFlowRate]],
				True
			],
			True,
			Message -> Hold[Error::MaxMinFlowRateInvalidInequalityOptions],
			MessageArguments -> {identifier}
		],
		Test["The option MaxFlowRate must have values greater than or equal to the respective option NominalFlowRate:",
			If[MatchQ[Lookup[packet, MaxFlowRate, Null], Except[Null]] && MatchQ[Lookup[packet, NominalFlowRate, Null], Except[Null]],
				GreaterEqual[Lookup[packet, MaxFlowRate], Lookup[packet, NominalFlowRate]],
				True
			],
			True,
			Message -> Hold[Error::MaxNominalFlowRateInvalidInequalityOptions],
			MessageArguments -> {identifier}
		],
		Test["The option NominalFlowRate must have values greater than or equal to the respective option MinFlowRate:",
			If[MatchQ[Lookup[packet, NominalFlowRate, Null], Except[Null]] && MatchQ[Lookup[packet, MinFlowRate, Null], Except[Null]],
				GreaterEqual[Lookup[packet, NominalFlowRate], Lookup[packet, MinFlowRate]],
				True
			],
			True,
			Message -> Hold[Error::NominalMinFlowRateInvalidInequalityOptions],
			MessageArguments -> {identifier}
		],
		Test["The option MaxTemperature must have values greater than or equal to the respective option MinTemperature:",
			If[MatchQ[Lookup[packet, MaxTemperature, Null], Except[Null]] && MatchQ[Lookup[packet, MinTemperature, Null], Except[Null]],
				GreaterEqual[Lookup[packet, MaxTemperature], Lookup[packet, MinTemperature]],
				True
			],
			True,
			Message -> Hold[Error::MaxMinTemperatureInvalidInequalityOptions],
			MessageArguments -> {identifier}
		],
		Test["The option MaxpH must have values greater than or equal to the respective option MinpH:",
			If[MatchQ[Lookup[packet, MaxpH, Null], Except[Null]] && MatchQ[Lookup[packet, MinpH, Null], Except[Null]],
				GreaterEqual[Lookup[packet, MaxpH], Lookup[packet, MinpH]],
				True
			],
			True,
			Message -> Hold[Error::MaxMinpHInvalidInequalityOptions],
			MessageArguments -> {identifier}
		],

		(* Only guard columns may be cartridge *)
		Test["PackingType can only be Cartridge if ColumnType->Guard:",
			Lookup[packet, {ColumnType, PackingType}],
			{Guard, Cartridge} | Except[{Guard, Cartridge}],
			Message -> Hold[Error::OnlyGuardCartridgePackingType],
			MessageArguments -> {identifier}
		],

		Test["If the type of column is for HPLC, FPLC, and/or SupercriticalFluidChromatography, then Connectors should have an inlet and outlet entry:",
			If[MatchQ[Lookup[packet, ChromatographyType], HPLC | FPLC | SupercriticalFluidChromatography],
				SubsetQ[Lookup[packet, Connectors][[All, 1]], {"Column Outlet", "Column Inlet"}],
				True
			],
			True,
			Message -> Hold[Error::ConnectorEntries],
			MessageArguments -> {identifier}
		],
		Test["SeparationMode, MaxpH, MaxPressure, MaxTemperature, MinFlowRate, MinpH, MinPressure, MinTemperature, NominalFlowRate, MaxFlowRate, PackingMaterial of the column must be the same as its PreferredGuardCartridge:",
			If[NullQ[Lookup[packet, PreferredGuardCartridge, Null]],
				True,
				MatchQ[
					Lookup[packet, {SeparationMode, MaxpH, MaxPressure, MaxTemperature, MinFlowRate, MinpH, MinPressure, MinTemperature, NominalFlowRate, MaxFlowRate, PackingMaterial}, Null],
					Lookup[
						guardCartridgePacket,
						{SeparationMode, MaxpH, MaxPressure, MaxTemperature, MinFlowRate, MinpH, MinPressure, MinTemperature, NominalFlowRate, MaxFlowRate, PackingMaterial}
					]
				]
			],
			True,
			Message -> Hold[Error::CartridgeOptionMismatch],
			MessageArguments -> {identifier}
		],

		Test["The option PreferredGuardCartridge must be informed if PackingType is Cartridge and may not be informed otherwise:",
			MatchQ[
				Lookup[packet, {PreferredGuardCartridge, PackingType}, Null],
				{Null, Except[Cartridge]} | {Except[Null], Cartridge}
			],
			True,
			Message -> Hold[Error::PreferredGuardCartridgePackingType],
			MessageArguments -> {identifier}
		],

		(* Fields that must be informed if ChromatographyType is GasChromatography *)
		If[MatchQ[Lookup[packet, ChromatographyType], GasChromatography],
			NotNullFieldTest[
				packet,
				{Diameter, Polarity, ColumnLength, FilmThickness, ColumnFormat, MinTemperature, MaxTemperature, MaxShortExposureTemperature, Size},
				Message -> Hold[Error::RequiredOptions],
				MessageArguments -> {identifier}
			],
			Nothing
		],

		(* Fields that must be informed if ChromatographyType is Flash *)
		If[MatchQ[Lookup[packet, ChromatographyType], Flash],
			NotNullFieldTest[
				packet,
				{MinFlowRate, MaxFlowRate, MinPressure, MaxPressure, Diameter, ColumnLength, Reusable, StorageCaps, BedWeight, VoidVolume},
				Message -> Hold[Error::RequiredOptions],
				MessageArguments -> {identifier}
			],
			Nothing
		],

		(* Fields that must be informed if ChromatographyType is Flash unless ColumnType is Join *)
		If[MatchQ[Lookup[packet,{ChromatographyType, ColumnType}],{Flash, Except[Join]}],
			NotNullFieldTest[
				packet,
				{SeparationMode, PackingMaterial},
				Message -> Hold[Error::RequiredOptions],
				MessageArguments -> {identifier}
			],
			Nothing
		],

		Test["If ChromatographyType is Flash, SeparationMode must be NormalPhase or ReversePhase unless ColumnType is Join:",
			Switch[Lookup[packet, {ChromatographyType, SeparationMode, ColumnType}],
				{Flash, NormalPhase|ReversePhase, _}, True,
				{Flash, _, Join}, True,
				{Flash, _, _}, False,
				{_, _, _}, True
			],
			True,
			Message -> Hold[Error::InvalidFlashChromatographySeparationMode],
			MessageArguments -> {identifier}
		],

		Test["If ChromatographyType is Flash, PackingMaterial must be Silica or Alumina unless ColumnType is Join:",
			Switch[Lookup[packet, {ChromatographyType, PackingMaterial, ColumnType}],
				{Flash, Silica|Alumina, _}, True,
				{Flash, _, Join}, True,
				{Flash, _, _}, False,
				{_, _, _}, True
			],
			True
		],

		Test["If ChromatographyType is Flash, FunctionalGroup must be Null, C8, C18, C18Aq, or Amine:",
			Switch[Lookup[packet, {ChromatographyType, FunctionalGroup}],
				{Flash, Null|C8|C18|C18Aq|Amine}, True,
				{Flash, _}, False,
				{_, _}, True
			],
			True
		],

		Test["If ChromatographyType is Flash and PackingMaterial is Alumina, FunctionalGroup must be Null:",
			Switch[Lookup[packet, {ChromatographyType, PackingMaterial, FunctionalGroup}],
				{Flash, Alumina, Null}, True,
				{Flash, Alumina, _}, False,
				{_, _, _}, True
			],
			True
		]

	}
];

Error::NameIsNotPartOfSynonymsColumn="The name of this Model[Column], `1`, is not part of the Synonyms field. Please include this name in the synonyms field.";
Error::SeparationMode="The option SeparationMode should be informed if ColumnType is not a Join. Please specify the SeparationMode.";
Error::ChromatographyType="The option ChromatographyType should be set to GasChromatography if SeparationMode is GasChromatography. Please specify the ChromatographyType.";
Error::ColumnConnectors="The option Connectors must contain a single entry for Column Inlet and Column Outlet if the ChromatographyType is GasChromatography. Please specify Connectors for these ports.";
Error::OnlyGuardProtectedColumns="The option ProtectedColumns can only be specified if ColumnType->Guard. Please set ColumnType->Guard or do not specify any ProtectedColumns.";
Error::PreferredGuardColumn="The option PreferredGuardColumn can only be informed if ColumnType is not Guard. Please set ColumnType to not Guard or do not specify PreferredGuardColumn.";
Error::InletOptionsRequiredTogether="The options InletFilterThickness and InletFilterMaterial are required together. Please specify both of them or none of them.";
Error::ColumnInvalidInequalityOptions="The following option(s), `1`, must have values greater than or equal to their respective option(s), `2`. Please change the values of these options.";
Error::ParticleSizePoreSizeInvalidInequalityOptions="The option ParticleSize must have values greater than or equal to the respective option PoreSize. Please change the values of these options.";
Error::MaxMinPressureInvalidInequalityOptions="The option MaxPressure must have values greater than or equal to the respective option MinPressure. Please change the values of these options.";
Error::MaxMinFlowRateInvalidInequalityOptions="The option MaxFlowRate must have values greater than or equal to the respective option MinFlowRate. Please change the values of these options.";
Error::MaxNominalFlowRateInvalidInequalityOptions="The option MaxFlowRate must have values greater than or equal to the respective option NominalFlowRate. Please change the values of these options.";
Error::NominalMinFlowRateInvalidInequalityOptions="The option NominalFlowRate must have values greater than or equal to the respective option MinFlowRate. Please change the values of these options.";
Error::MaxMinTemperatureInvalidInequalityOptions="The option MaxTemperature must have values greater than or equal to the respective option MinTemperature. Please change the values of these options.";
Error::MaxMinpHInvalidInequalityOptions="The option MaxpH must have values greater than or equal to the respective option MinpH. Please change the values of these options.";
Error::PreferredGuardCartridgePackingType="The option PreferredGuardCartridge must be informed if PackingType is Cartridge and may not be informed otherwise. Please specify PreferredGuardCartridge and Cartridge PackingType, or specify a PackingType other than Cartridge and do not specify PreferredGuardCartridge.";
Error::ConnectorEntries="If the ColumnType is for HPLC, FPLC, and/or SupercriticalFluidChromatography, then Connectors should have an inlet and outlet entry. Please specify the connectors.";
Error::OnlyGuardCartridgePackingType="PackingType may only be Cartridge if ColumnType is Guard. Please specify a different ColumnType or different PackingType.";
Error::CartridgeOptionMismatch="The options in the newly uploaded column must match the fields of the specified PreferredGuardCartridge -- {SeparationMode, MaxpH, MaxPressure, MaxTemperature, MinFlowRate, MinpH, MinPressure, MinTemperature, NominalFlowRate, MaxFlowRate, and PackingMaterial}. Please update these options or do not specify a PreferredGuardCartridge.";
Error::InvalidFlashChromatographySeparationMode="If ChromatographyType is Flash, the SeparationMode must be NormalPhase or ReversePhase.";

errorToOptionMap[Model[Item, Column]]:={
	"Error::NameIsNotPartOfSynonymsColumn"->{Name, Synonyms},
	"Error::SeparationMode"->{SeparationMode, ColumnType},
	"Error::ChromatographyType"->{ChromatographyType,SeparationMode},
	"Error::OnlyGuardProtectedColumns"->{ProtectedColumns, ColumnType},
	"Error::PreferredGuardColumn"->{PreferredGuardColumn, ColumnType},
	"Error::InletOptionsRequiredTogether"->{InletFilterThickness,InletFilterMaterial},
	"Error::ParticleSizePoreSizeInvalidInequalityOptions"->{ParticleSize,PoreSize},
	"Error::MaxMinPressureInvalidInequalityOptions"->{MaxPressure, MinPressure},
	"Error::MaxMinFlowRateInvalidInequalityOptions"->{MaxFlowRate, MaxFlowRate},
	"Error::MaxNominalFlowRateInvalidInequalityOptions"->{MaxFlowRate,NominalFlowRate},
	"Error::NominalMinFlowRateInvalidInequalityOptions"->{NominalFlowRate, MinFlowRate},
	"Error::MaxMinTemperatureInvalidInequalityOptions"->{MaxTemperature, MinTemperature},
	"Error::MaxMinpHInvalidInequalityOptions"->{MaxpH, MinpH},
	"Error::PreferredGuardCartridgePackingType"->{PreferredGuardCartridge,PackingType},
	"Error::ConnectorEntries"->{ChromatographyType},
	"Error::OnlyGuardCartridgePackingType"->{ColumnType,PackingType},
	"Error::CartridgeOptionMismatch"->{PreferredGuardCartridge},
	"Error::RequiredOptions"->{MaxPressure,MinPressure,MaxFlowRate,MinFlowRate,PackingType,ColumnType,MaxNumberOfUses,Name,Synonyms},
	"Error::InvalidFlashChromatographySeparationMode"->{ChromatographyType,SeparationMode}
};


(* ::Subsection::Closed:: *)
(*validModelItemColumnHolderQTests*)


validModelItemColumnHolderQTests[packet:PacketP[Model[Item,ColumnHolder]]] := {
	(* Fields that should be filled in *)
	NotNullFieldTest[packet,{Name, Synonyms}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemElectrodeQTests*)


validModelItemElectrodeQTests[packet:PacketP[Model[Item,Electrode]]]:= {

	NotNullFieldTest[
		packet,
		{
			(* Shared Fields: *)
			MaxNumberOfUses,
			WettedMaterials,

			(* Non Shared Fields: *)
			BulkMaterial,
			Coated,
			ElectrodeShape,
			MinPotential,
			MaxPotential,
			SonicationSensitive
		}
	],
	FieldComparisonTest[packet,{MinPotential,MaxPotential},LessEqual],
	FieldComparisonTest[packet,{MaxNumberOfPolishings,MaxNumberOfUses},LessEqual],

	Test["If the electrode is not Coated, BulkMaterial is a member of the WettedMaterials:",
		Module[{coated, bulkMaterial, wettedMaterials},
			{coated, bulkMaterial, wettedMaterials} = Lookup[packet, {Coated, BulkMaterial, WettedMaterials}];
			If[MatchQ[coated, Alternatives[False, Null]],
				MemberQ[wettedMaterials, bulkMaterial],
				True
			]
		],
		True
	],

	Test["BulkMaterial is not a member of the IncompatibleMaterials:",
		Module[{bulkMaterial, incompatibleMaterials},
			{bulkMaterial, incompatibleMaterials} = Lookup[packet, {BulkMaterial, IncompatibleMaterials}];
			MemberQ[incompatibleMaterials, bulkMaterial]
		],
		False
	],

	Test["If the electrode is Coated, CoatMaterial is a member of the WettedMaterials:",
		Module[{coated, coatMaterial, wettedMaterials},
			{coated, coatMaterial, wettedMaterials} = Lookup[packet, {Coated, CoatMaterial, WettedMaterials}];
			If[MatchQ[coated, True],
				MemberQ[wettedMaterials, coatMaterial],
				True
			]
		],
		True
	],

	Test["If the electrode is Coated, CoatMaterial is a not member of the IncompatibleMaterials:",
		Module[{coated, coatMaterial, incompatibleMaterials},
			{coated, coatMaterial, incompatibleMaterials} = Lookup[packet, {Coated, CoatMaterial, IncompatibleMaterials}];
			If[MatchQ[coated, True],
				MemberQ[incompatibleMaterials, coatMaterial],
				False
			]
		],
		False
	],

	Test["If ElectrodePackagingMaterial is not Null, ElectrodePackagingMaterial is a member of the WettedMaterials:",
		Module[{packagingMaterial, wettedMaterials},
			{packagingMaterial, wettedMaterials} = Lookup[packet, {ElectrodePackagingMaterial, WettedMaterials}];
			If[MatchQ[packagingMaterial, Null],
				True,
				MemberQ[wettedMaterials, packagingMaterial]
			]
		],
		True
	],

	Test["If ElectrodePackagingMaterial is not Null, ElectrodePackagingMaterial is not a member of the IncompatibleMaterials:",
		Module[{packagingMaterial, incompatibleMaterials},
			{packagingMaterial, incompatibleMaterials} = Lookup[packet, {ElectrodePackagingMaterial, IncompatibleMaterials}];
			If[MatchQ[packagingMaterial, Null],
				False,
				MemberQ[incompatibleMaterials, packagingMaterial]
			]
		],
		False
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemElectrodeReferenceElectrodeQTests*)


validModelItemElectrodeReferenceElectrodeQTests[packet:PacketP[Model[Item,Electrode,ReferenceElectrode]]]:= {
	(* Non-Shared Fields: *)
	NotNullFieldTest[
		packet,
		{
			ReferenceElectrodeType,
			SolutionVolume,
			WiringConnectors,
			Preparable
		}
	],

	RequiredTogetherTest[packet, {Blank, RecommendedSolventType, ReferenceSolution, RecommendedRefreshPeriod}],

	Test["If the model is preparable and public (without a notebook), the Price field must be populated:",
		Module[{notebook, price, preparable, checkResult},
			{notebook, price, preparable} = Lookup[packet, {Notebook, Price, Preparable}];

			checkResult = If[MatchQ[preparable, True] && MatchQ[notebook, Null],
				!NullQ[price],
				True
			]
		],
		True
	],

	Test["If Blank is not informed, ReferenceElectrodeType is a 'Bare' type, and if Blank is informed, ReferenceElectrodeType is not a 'Bare' type:",
		Module[{blank, referenceElectrodeType, checkResult},
			{blank, referenceElectrodeType} = Lookup[packet, {Blank, ReferenceElectrodeType}];

			checkResult = Which[

				(* If Blank is Null, ReferenceElectrodeType is a 'Bare' type *)
				MatchQ[blank, Null] && MatchQ[referenceElectrodeType, ReferenceElectrodeTypeP],
				StringContainsQ[referenceElectrodeType, "bare", IgnoreCase -> True],

				(* If Blank is informed, ReferenceElectrodeType is not a 'Bare' type *)
				MatchQ[blank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]] && MatchQ[referenceElectrodeType, ReferenceElectrodeTypeP],
				!StringContainsQ[referenceElectrodeType, "bare", IgnoreCase -> True],

				(* Otherwise, return False *)
				True,
				False
			]
		],
		True
	],

	Test["If Blank is not informed, ReferenceCouplingSample is not informed either:",
		Lookup[packet, {Blank, ReferenceCouplingSample}],
		Alternatives[{Null, Null}, {ObjectP[Model[Item, Electrode, ReferenceElectrode]], _}]
	],

	Test["If Blank is informed, ReferenceElectrodeType is a 'Pseudo' type if ReferenceCouplingSample is not informed, or ReferenceElectrodeType is not a 'Pseudo' type if ReferenceCouplingSample is informed:",
		Lookup[packet, {Blank, ReferenceCouplingSample, ReferenceElectrodeType}],
		Alternatives[
			(* Blank is Null, ReferenceCouplingSample is Null, ReferenceElectrodeType can be anything for now *)
			{Null, Null, _},

			(* Blank is informed, ReferenceCouplingSample is Null, ReferenceElectrodeType is a 'Pseudo' type *)
			{ObjectP[Model[Item, Electrode, ReferenceElectrode]], Null, _String?(StringContainsQ[#1, "Pseudo", IgnoreCase -> True]&)},

			(* Blank is informed, ReferenceCouplingSample is informed, ReferenceElectrodeType is not a 'Pseudo' type *)
			{ObjectP[Model[Item, Electrode, ReferenceElectrode]], ObjectP[Model[Sample]], Except[_String?(StringContainsQ[#1, "Pseudo", IgnoreCase -> True]&)]}
		]
	],

	Test["If model is not deprecated, the informed Blank is not deprecated either:",
		Module[
			{deprecated, blank, blankDeprecated},
			{deprecated, blank} = Lookup[packet, {Deprecated, Blank}];
			If[MatchQ[deprecated, True],
				(* If the model is deprecated, we do not care about the Blank status *)
				{True, True},

				(* If the model is not deprecated, we check the Blank is informed or not *)
				If[MatchQ[blank, Null],
					(* If Blank is Null, we just return Null *)
					{False, Null},

					(* If Blank is informed, we check if it's deprecated *)
					blankDeprecated = Download[blank, Deprecated];
					If[MatchQ[blankDeprecated, True],
						(* If the blank is deprecated *)
						{False, True},

						(* If the blank is not deprecated *)
						{False, False}
					]
				]
			]
		],
		Alternatives[
			{True, True},
			{False, Null},
			{False, False}
		]
	],

	(* Check WiringDiameters *)
	Module[
		{wiringConnectors, wiringConnectorNames, wiringConnectorTypes, wiringDiameters, nonNullList, missingList},

		{wiringConnectors, wiringDiameters} = Lookup[packet, {WiringConnectors, WiringDiameters}];

		(* Retrieve the names and types form the wiringConnectors *)
		{wiringConnectorNames, wiringConnectorTypes} = If[MatchQ[wiringConnectors, {}],
			{{}, {}},

			(* If wiringConnectors is not an empty list, get the names and types *)
			{wiringConnectors[[All, 1]], wiringConnectors[[All, 2]]}
		];

		(* Check if any ExposedWires missing a diameter or any non-ExposedWires having a diameter *)
		{nonNullList, missingList} = If[!MatchQ[wiringConnectorNames, {}] && !MatchQ[wiringConnectorTypes, {}] && !MatchQ[wiringDiameters, {}],

			(* If the wiringConnectorNames and wiringConnectorTypes are not empty lists, we do the checking *)
			Transpose[MapThread[
				Function[{type, diameter},
					Which[
						(* If the type is not ExposedWire and the diameter is not Null, set nonNull to True and missing to False *)
						MatchQ[type, Except[ExposedWire]] && MatchQ[diameter, DistanceP],
						{True, False},

						(* If the type is ExposedWire and the diameter is Null, set nonNull to False and missing to True *)
						MatchQ[type, ExposedWire] && MatchQ[diameter, Null],
						{False, True},

						(* Otherwise, set both nonNull and missing to False *)
						True,
						{False, False}
					]
				],
				{wiringConnectorTypes, wiringDiameters}
			]],

			(* If any of the wiringConnectorNames and wiringConnectorTypes is an empty list (they will be empty or non-empty at the same time though), we don't the checking *)
			{{}, {}}
		];

		(* Return the tests *)
		{
			(* any non-ExposedWire having wiring diameter test *)
			Test["If WiringDiameter is informed, the diameter for any non-ExposedWire type wiring connectors is Null:",
				MemberQ[nonNullList, True],
				False
			],

			(* any ExposedWire missing wiring diameter test *)
			Test["If WiringDiameter is informed, the diameter for any ExposedWire type wiring connectors is not Null:",
				MemberQ[missingList, True],
				False
			]
		}
	],

	(* ReferenceSolution checks *)
	Module[
		{
			bulkMaterial,
			coatMaterial,
			packagingMaterial,
			defaultStorageCondition,
			referenceSolution,
			referenceSolutionDefaultStorageCondition,
			referenceSolutionIncompatibleMaterials,
			referenceSolutionSolvent,
			referenceSolutionAnalytesList,
			referenceSolutionCompositionField,
			referenceSolutionComposition,
			referenceSolutionSolventMolecule,
			referenceSolutionAnalyteMolecule,

			(* Error tracking booleans *)
			defaultStorageConditionMismatchBool,
			incompatibleMaterialConflictBool,
			solutionLessThanTwoComponentsBool,
			solutionMissingSolventBool,
			solventSampleAmbiguousMoleculeBool,
			solutionMissingAnalyteBool,
			solutionAmbiguousAnalyteBool
		},

		(* gather model information *)
		{bulkMaterial, coatMaterial, packagingMaterial, defaultStorageCondition, referenceSolution} = Lookup[packet, {BulkMaterial, CoatMaterial, PackagingMaterial, DefaultStorageCondition, ReferenceSolution}]/.x:ObjectP[]:>Download[x, Object];

		(* gather reference solution information *)
		{
			referenceSolutionDefaultStorageCondition,
			referenceSolutionIncompatibleMaterials,
			referenceSolutionSolvent,
			referenceSolutionAnalytesList,
			referenceSolutionCompositionField
		} = If[
			MatchQ[referenceSolution, ObjectP[Model[Sample]]],
			(Download[
				referenceSolution,
				{
					DefaultStorageCondition,
					IncompatibleMaterials,
					Solvent,
					Analytes,
					Composition[[All, 2]]
				}
			] /. x:ObjectP[]:>Download[x, Object]),
			(* If the electrode does not have a referenceSolution, set all of these fields to Null *)
			{Null, Null, Null, Null, Null}
		];

		(* Remove the Null's *)
		referenceSolutionComposition = Replace[referenceSolutionCompositionField, {Null -> Nothing}, 1];

		(* Check the DefaultStorageConditions *)
		defaultStorageConditionMismatchBool = If[
			And[
				MatchQ[defaultStorageCondition, ObjectP[Model[StorageCondition]]],
				MatchQ[referenceSolutionDefaultStorageCondition, ObjectP[Model[StorageCondition]]]
			],
			Not[MatchQ[defaultStorageCondition, referenceSolutionDefaultStorageCondition]],
			False
		];

		(* Check if any of BulkMaterial, CoatMaterial, ElectrodePackagingMaterial is a member of the IncompatibleMaterial of ReferenceSolution *)
		incompatibleMaterialConflictBool = Or[
			(* BulkMaterial *)
			If[MatchQ[bulkMaterial, MaterialP],
				MemberQ[referenceSolutionIncompatibleMaterials, bulkMaterial],
				False
			],

			(* CoatMaterial *)
			If[MatchQ[coatMaterial, MaterialP],
				MemberQ[referenceSolutionIncompatibleMaterials, coatMaterial],
				False
			],

			(* ElectrodePackagingMaterial *)
			If[MatchQ[packagingMaterial, MaterialP],
				MemberQ[referenceSolutionIncompatibleMaterials, packagingMaterial],
				False
			]
		];

		(* If the referenceSolutionComposition has less than 2 non-Null entries, set solutionLessThanTwoComponentsBool to True *)
		solutionLessThanTwoComponentsBool = If[
			LessQ[Length[referenceSolutionComposition], 2] && !MatchQ[referenceSolution, Null],
			True,
			False
		];

		(* If referenceSolutionSolvent is an empty list, set solutionMissingSolventBool to True *)
		solutionMissingSolventBool = If[
			MatchQ[referenceSolutionSolvent, Null] && !MatchQ[referenceSolution, Null],
			True,
			False
		];

		(* We try to get solventSample and solventMolecule from solventField *)
		If[
			And[
				!MatchQ[referenceSolution, Null],
				!MatchQ[referenceSolutionSolvent, Null],
				MatchQ[solutionMissingSolventBool, False]
			],

			(* If no errors are encountered, we check the solution solvent *)
			Module[
				{
					solventSampleComposition
				},

				solventSampleComposition = Download[referenceSolutionSolvent, Composition[[All, 2]]] /. {Null -> Nothing};

				If[MatchQ[Length[solventSampleComposition], 1],
					referenceSolutionSolventMolecule = First[solventSampleComposition];
					solventSampleAmbiguousMoleculeBool = False,

					referenceSolutionSolventMolecule = Null;
					solventSampleAmbiguousMoleculeBool = True
				];
			],

			(* If any of the two previous errors are encountered or the referenceSolution is Null, we set them to Null *)
			referenceSolutionSolventMolecule = Null;
			solventSampleAmbiguousMoleculeBool = False;
		];

		(* If referenceSolutionAnalytesList is an empty list, set solutionMissingAnalyteBool to True *)
		solutionMissingAnalyteBool = If[
			MatchQ[Length[referenceSolutionAnalytesList], 0] && !MatchQ[referenceSolution, Null],
			True,
			False
		];

		(* If referenceSolutionAnalytesList has more than one non-Null entries, set solutionAmbiguousAnalyteBool to True *)
		solutionAmbiguousAnalyteBool = If[
			GreaterQ[Length[(referenceSolutionAnalytesList /. {Null -> Nothing})], 1] && !MatchQ[referenceSolution, Null],
			True,
			False
		];

		{
			Test["If ReferenceSolution is informed, the DefaultStorageCondition is identical with ReferenceSolution",
				defaultStorageConditionMismatchBool,
				False
			],

			Test["If ReferenceSolution is informed, the BulkMaterial, CoatMaterial, ElectrodePackagingMaterial are not members of ReferenceSolution's IncompatibleMaterials.",
				incompatibleMaterialConflictBool,
				False
			],

			Test["If ReferenceSolution is informed, the Composition field in ReferenceSolution has at least two non-Null entries:",
				solutionLessThanTwoComponentsBool,
				False
			],

			Test["If ReferenceSolution is informed, the Solvent field in ReferenceSolution is informed:",
				solutionMissingSolventBool,
				False
			],

			Test["If ReferenceSolution is informed, and if the Solvent field in ReferenceSolution contains the solvent sample, its Composition has the corresponding solvent molecule:",
				solventSampleAmbiguousMoleculeBool,
				False
			],

			Test["If ReferenceSolution is informed, the Analytes field in ReferenceSolution is informed:",
				solutionMissingAnalyteBool,
				False
			],

			Test["If ReferenceSolution is informed, the Analytes field in ReferenceSolution has only one non-Null entry:",
				solutionAmbiguousAnalyteBool,
				False
			]
		}
	],

	(* Blank checks *)
	Module[
		{
			(* Model information *)
			blank,

			solutionVolume,
			dimensions,
			bulkMaterial,
			coatMaterial,
			electrodePackagingMaterial,
			electrodeShape,
			wiringConnectors,
			wiringDiameters,
			wiringLength,
			sonicationSensitive,
			wettedMaterials,
			maxNumberOfUses,
			maxNumberOfPolishings,
			minPotential,
			maxPotential,

			(* Blank information *)
			blankSolutionVolume,
			blankDimensions,
			blankBulkMaterial,
			blankCoatMaterial,
			blankElectrodePackagingMaterial,
			blankElectrodeShape,
			blankWiringConnectors,
			blankWiringDiameters,
			blankWiringLength,
			blankSonicationSensitive,
			blankWettedMaterials,
			blankMaxNumberOfUses,
			blankMaxNumberOfPolishings,
			blankMinPotential,
			blankMaxPotential,

			(* Error tracking booleans *)
			solutionVolumeConflictBool,
			dimensionsConflictBool,
			bulkMaterialConflictBool,
			coatMaterialConflictBool,
			electrodePackagingMaterialConflictBool,
			electrodeShapeConflictBool,
			wiringConnectorsConflictBool,
			wiringDiametersConflictBool,
			wiringLengthConflictBool,
			sonicationSensitiveConflictBool,
			wettedMaterialsConflictBool,
			maxNumberOfUsesConflictBool,
			maxNumberOfPolishingsConflictBool,
			minPotentialConflictBool,
			maxPotentialConflictBool
		},

		(* gather model information *)
		{
			blank,
			solutionVolume,
			dimensions,
			bulkMaterial,
			coatMaterial,
			electrodePackagingMaterial,
			electrodeShape,
			wiringConnectors,
			wiringDiameters,
			wiringLength,
			sonicationSensitive,
			wettedMaterials,
			maxNumberOfUses,
			maxNumberOfPolishings,
			minPotential,
			maxPotential
		} = Lookup[packet, {
			Blank,
			SolutionVolume,
			Dimensions,
			BulkMaterial,
			CoatMaterial,
			ElectrodePackagingMaterial,
			ElectrodeShape,
			WiringConnectors,
			WiringDiameters,
			WiringLength,
			SonicationSensitive,
			WettedMaterials,
			MaxNumberOfUses,
			MaxNumberOfPolishings,
			MinPotential,
			MaxPotential
		}]/.x:ObjectP[]:>Download[x, Object];

		(* gather reference solution information *)
		{
			blankSolutionVolume,
			blankDimensions,
			blankBulkMaterial,
			blankCoatMaterial,
			blankElectrodePackagingMaterial,
			blankElectrodeShape,
			blankWiringConnectors,
			blankWiringDiameters,
			blankWiringLength,
			blankSonicationSensitive,
			blankWettedMaterials,
			blankMaxNumberOfUses,
			blankMaxNumberOfPolishings,
			blankMinPotential,
			blankMaxPotential
		} = If[MatchQ[blank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
			(Download[
				blank,
				{
					SolutionVolume,
					Dimensions,
					BulkMaterial,
					CoatMaterial,
					ElectrodePackagingMaterial,
					ElectrodeShape,
					WiringConnectors,
					WiringDiameters,
					WiringLength,
					SonicationSensitive,
					WettedMaterials,
					MaxNumberOfUses,
					MaxNumberOfPolishings,
					MinPotential,
					MaxPotential
				}
			] /. x:ObjectP[]:>Download[x, Object]),
			(* If the electrode does not have a referenceSolution, set all of these fields to Null *)
			ConstantArray[Null, 15]
		];

		(* Check SolutionVolume *)
		solutionVolumeConflictBool = If[
			MatchQ[blank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
			Not[MatchQ[
				SafeRound[solutionVolume, 10^-1 Milliliter, RoundAmbiguous -> Up],
				SafeRound[blankSolutionVolume, 10^-1 Milliliter, RoundAmbiguous -> Up]
			]],
			False
		];

		(* Check Dimensions *)
		dimensionsConflictBool = If[
			MatchQ[blank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
			Not[MatchQ[
				SafeRound[dimensions, 10^-1 Millimeter, RoundAmbiguous -> Up],
				SafeRound[blankDimensions, 10^-1 Millimeter, RoundAmbiguous -> Up]
			]],
			False
		];

		(* Check BulkMaterial *)
		bulkMaterialConflictBool = If[
			MatchQ[blank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
			Not[MatchQ[bulkMaterial, blankBulkMaterial]],
			False
		];

		(* Check CoatMaterial *)
		coatMaterialConflictBool = If[
			MatchQ[blank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
			Not[MatchQ[coatMaterial, blankCoatMaterial]],
			False
		];

		(* Check ElectrodePackagingMaterial *)
		electrodePackagingMaterialConflictBool = If[
			MatchQ[blank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
			Not[MatchQ[electrodePackagingMaterial, blankElectrodePackagingMaterial]],
			False
		];

		(* Check ElectrodeShape *)
		electrodeShapeConflictBool = If[
			MatchQ[blank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
			Not[MatchQ[electrodeShape, blankElectrodeShape]],
			False
		];

		(* Check WiringConnectors *)
		wiringConnectorsConflictBool = If[
			MatchQ[blank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
			Not[MatchQ[wiringConnectors, blankWiringConnectors]],
			False
		];

		(* Check WiringDiameters *)
		wiringDiametersConflictBool = If[
			MatchQ[blank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
			Not[MatchQ[
				SafeRound[wiringDiameters, 10^-1 Millimeter, RoundAmbiguous -> Up],
				SafeRound[blankWiringDiameters, 10^-1 Millimeter, RoundAmbiguous -> Up]
			]],
			False
		];

		(* Check WiringLength *)
		wiringLengthConflictBool = If[
			MatchQ[blank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
			Not[MatchQ[
				SafeRound[wiringLength, 10^-1 Millimeter, RoundAmbiguous -> Up],
				SafeRound[blankWiringLength, 10^-1 Millimeter, RoundAmbiguous -> Up]
			]],
			False
		];

		(* Check SonicationSensitive *)
		sonicationSensitiveConflictBool = If[
			MatchQ[blank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
			Not[MatchQ[sonicationSensitive, blankSonicationSensitive]],
			False
		];

		(* Check WettedMaterials *)
		wettedMaterialsConflictBool = If[
			MatchQ[blank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
			Not[MatchQ[wettedMaterials, blankWettedMaterials]],
			False
		];

		(* Check MaxNumberOfUses *)
		maxNumberOfUsesConflictBool = If[
			MatchQ[blank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
			Not[LessEqualQ[maxNumberOfUses, blankMaxNumberOfUses]],
			False
		];

		(* Check MaxNumberOfPolishings *)
		maxNumberOfPolishingsConflictBool = If[
			MatchQ[blank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]] && Or[IntegerQ[maxNumberOfPolishings], IntegerQ[blankMaxNumberOfPolishings]],
			Not[LessEqualQ[maxNumberOfPolishings, blankMaxNumberOfPolishings]],
			False
		];

		(* Check MinPotential *)
		minPotentialConflictBool = If[
			MatchQ[blank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
			Not[GreaterEqualQ[
				SafeRound[minPotential, 10^-1 Millivolt, RoundAmbiguous -> Up],
				SafeRound[blankMinPotential, 10^-1 Millivolt, RoundAmbiguous -> Up]
			]],
			False
		];

		(* Check MaxPotential *)
		maxPotentialConflictBool = If[
			MatchQ[blank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
			Not[LessEqualQ[
				SafeRound[maxPotential, 10^-1 Millivolt, RoundAmbiguous -> Up],
				SafeRound[blankMaxPotential, 10^-1 Millivolt, RoundAmbiguous -> Up]
			]],
			False
		];

		{
			Test["If Blank is informed, the SolutionVolume is identical with the Blank:",
				solutionVolumeConflictBool,
				False
			],

			Test["If Blank is informed, the Dimensions are identical with the Blank:",
				dimensionsConflictBool,
				False
			],

			Test["If Blank is informed, the BulkMaterial is identical with the Blank:",
				bulkMaterialConflictBool,
				False
			],

			Test["If Blank is informed, the CoatMaterial is identical with the Blank:",
				coatMaterialConflictBool,
				False
			],

			Test["If Blank is informed, the ElectrodePackagingMaterial is identical with the Blank:",
				electrodePackagingMaterialConflictBool,
				False
			],

			Test["If Blank is informed, the ElectrodeShape is identical with the Blank:",
				electrodeShapeConflictBool,
				False
			],

			Test["If Blank is informed, the WiringConnectors are identical with the Blank:",
				wiringConnectorsConflictBool,
				False
			],

			Test["If Blank is informed, the WiringDiameters are identical with the Blank:",
				wiringDiametersConflictBool,
				False
			],

			Test["If Blank is informed, the WiringLength is identical with the Blank:",
				wiringLengthConflictBool,
				False
			],

			Test["If Blank is informed, the SonicationSensitive is identical with the Blank:",
				sonicationSensitiveConflictBool,
				False
			],

			Test["If Blank is informed, the WettedMaterials are identical with the Blank:",
				wettedMaterialsConflictBool,
				False
			],

			Test["If Blank is informed, the MaxNumberOfUses is less or equal to the Blank's MaxNumberOfUses:",
				maxNumberOfUsesConflictBool,
				False
			],

			Test["If Blank is informed, the MaxNumberOfPolishings is less or equal to the Blank's MaxNumberOfPolishings:",
				maxNumberOfPolishingsConflictBool,
				False
			],

			Test["If Blank is informed, the MinPotential is greater or equal to the Blank's MinPotential:",
				minPotentialConflictBool,
				False
			],

			Test["If Blank is informed, the MaxPotential is less or equal to the Blank's MaxPotential:",
				maxPotentialConflictBool,
				False
			]
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemElectrodePolishingPadQTests*)


validModelItemElectrodePolishingPadQTests[packet:PacketP[Model[Item,ElectrodePolishingPad]]]:= {

	NotNullFieldTest[packet,{
		(* Shared Fields *)
		Name,
		Synonyms,
		MaxNumberOfUses,

		(* Non-Shared Fields *)
		PadColor,
		DefaultPolishingSolution,
		DefaultPolishingPlate
	}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemElectrodePolishingPlateQTests*)


validModelItemElectrodePolishingPlateQTests[packet:PacketP[Model[Item,ElectrodePolishingPlate]]]:= {

	NotNullFieldTest[packet,{
		(* Shared Fields *)
		Name,
		Synonyms,
		MaxNumberOfUses
	}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemFilterQTests*)


validModelItemFilterQTests[packet:PacketP[Model[Item,Filter]]]:=
{
	(* Fields that should NOT be filled in *)
	NullFieldTest[packet,{
			LightSensitive,
			MSDSRequired,
			MSDSFile,
			Flammable,
			IncompatibleMaterials,
			NFPA,
			DOTHazardClass,
			BiosafetyLevel
		}
	],

	NotNullFieldTest[packet, {
		FilterType,
		WettedMaterials,
		Name,
		Synonyms
	}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	],

	Test[
		"The MembraneMaterial of a filter has to be included in the WettedMaterials as well:",
		If[Not[NullQ[Lookup[packet, MembraneMaterial]]],
			MemberQ[Lookup[packet,WettedMaterials],Lookup[packet, MembraneMaterial]],
			True
		],
		True
	],

	Test["If Min/MaxVolume are informed, PoreSize is informed:",
		Module[{minVolume,maxVolume, poreSize},
			{minVolume,maxVolume, poreSize}=Lookup[packet,{MinVolume,MaxVolume, PoreSize}];
			{{minVolume,maxVolume},poreSize}
		],
		{NullP|{},_}|{Except[NullP|{}],Except[NullP|{}]}
	],

	(* If the filter is a disk or capsule, InletConnectionType and OutletConnectionType need to be informed *)
	Test[
		"If FilterType is Disk, InletConnectionType and OutletConnectionType have to be informed:",
		Lookup[packet, {FilterType, InletConnectionType, OutletConnectionType}],
		Alternatives[
			{Disk,Except[NullP], Except[NullP]},
			{Centrifuge, NullP, NullP},
			{Membrane, NullP, NullP},
			{BottleTop,_,_},
			{CrossFlowFiltration,_,_}
		]
	],

	(* If the filter is a disk or capsule, InletConnectionType and OutletConnectionType need to be informed *)
	Test[
		"If FilterType is Disk, Membrane, Centrifuge or BottleTop, PoreSize and MembraneMaterial have to be informed:",
		Lookup[packet, {FilterType, PoreSize, MembraneMaterial}],
		Alternatives[
			{Disk, Except[NullP], Except[NullP]},
			{Centrifuge, Except[NullP], Except[NullP]},
			{Membrane, Except[NullP], Except[NullP]},
			{BottleTop,Except[NullP],Except[NullP]},
			{CrossFlowFiltration,_,_}
		]
	],

	(* If the filter is a membrane, Diameter need to be informed *)
	Test[
		"If FilterType is Disk, Membrane, Centrifuge or BottleTop, Diameter has to be informed:",
		Lookup[packet, {FilterType, Diameter}],
		Alternatives[
			{Disk, Except[NullP]},
			{Centrifuge, Except[NullP]},
			{Membrane, Except[NullP]},
			{BottleTop,Except[NullP]},
			{CrossFlowFiltration,_}
		]
	]
};

(* ::Subsection::Closed:: *)
(*validModelItemFilterQTests*)

validModelItemFilterMicrofluidicChipQTests[packet:PacketP[Model[Item, Filter, MicrofluidicChip]]]:=
	{
		If[Not[TrueQ[Lookup[packet, CleanerOnly]]],
			NotNullFieldTest[packet, {
				MaxVolumeOfUses
			}],
			Nothing
		]
	};

(* ::Subsection::Closed:: *)
(*validModelItemGelQTests*)


validModelItemGelQTests[packet:PacketP[Model[Item,Gel]]]:=
		{
			(* Fields that should NOT be filled in *)
			NullFieldTest[packet,{WettedMaterials}],

			(* shared fields filled in *)

			NotNullFieldTest[packet,{
				MSDSRequired,
				BiosafetyLevel,
				(* Unique fields *)
				GelPercentage,
				GelMaterial,
				GelLength,
				NumberOfLanes,
				PreferredBuffer,
				Denaturing,
				MaxWellVolume,
				Name,
				Synonyms
			}
			],

			Test["The contents of the Name field is a member of the Synonyms field:",
				MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
				True
			],

			Test["If MSDSRequired is True, then MSDSFile must be informed:",
				Lookup[packet,{MSDSRequired,MSDSFile}],
				{True,Except[NullP|{}]}|{False,_}
			],
			Test["If MSDSRequired is True, then Flammable must be informed:",
				Lookup[packet,{MSDSRequired,Flammable}],
				{True,Except[NullP|{}]}|{False,_}
			],
			Test["If MSDSRequired is True, then Pyrophoric must be informed:",
				Lookup[packet,{MSDSRequired,Pyrophoric}],
				{True,Except[NullP|{}]}|{False,_}
			],

			Test["If MSDSRequired is True, then NFPA must be informed:",
				Lookup[packet,{MSDSRequired,NFPA}],
				{True,Except[NullP|{}]}|{False,_}
			],
			Test["If MSDSRequired is True, then DOTHazardClass must be informed:",
				Lookup[packet,{MSDSRequired,DOTHazardClass}],
				{True,Except[NullP|{}]}|{False,_}
			],


			Test["If and only if Denaturing is true, Denaturants must be informed:",
				Lookup[packet,{Denaturing,Denaturants}],
				{True,Except[NullP|{}]}|{Except[True],NullP|{}}
			],
			Test["If and only if GelMaterial is Polyacrylamide, CrosslinkerRatio must be informed:",
				Lookup[packet,{GelMaterial,CrosslinkerRatio}],
				{Polyacrylamide,Except[NullP|{}]}|{Except[Polyacrylamide],NullP|{}}
			]
		};


(* ::Subsection::Closed:: *)
(*validModelItemGCInletLinerQTests*)


validModelItemGCInletLinerQTests[packet:PacketP[Model[Item,GCInletLiner]]]:= {

	NotNullFieldTest[packet,{
		Name,
		Synonyms,
		Volume,
		OuterDiameter,
		InnerDiameter,
		LinerLength,
		LinerGeometry,
		GlassWool,
		CupLiner,
		Deactivated
	}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemGCColumnWaferQTests*)


validModelItemGCColumnWaferQTests[packet:PacketP[Model[Item,GCColumnWafer]]]:= {

	NotNullFieldTest[packet,{
		Name,
		Synonyms,
		BladeWidth,
		BladeLength
	}
	],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemGrindingBeadQTests*)


validModelItemGrindingBeadQTests[packet:PacketP[Model[Item,GrindingBead]]]:= {

	NotNullFieldTest[packet,{
		(* Shared *)
		Name,
		Synonyms,
		WettedMaterials,
		(* Specific *)
		Diameter,
		Material
	}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemSwagingToolQTests*)


validModelItemSwagingToolQTests[packet:PacketP[Model[Item,SwagingTool]]]:= {

	NotNullFieldTest[packet,{
		Name,
		Synonyms,
		Gender,
		ConnectionType,
		ThreadType
	}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemNeedleQTests*)


validModelItemNeedleQTests[packet:PacketP[Model[Item,Needle]]]:={
	(* shared field not null *)
	NotNullFieldTest[packet,{Name, Synonyms}],

	(* shared fields null *)
	NullFieldTest[packet,{
			LightSensitive,
			MSDSRequired,
			MSDSFile,
			Flammable,
			IncompatibleMaterials,
			NFPA,
			DOTHazardClass,
			BiosafetyLevel,
			Radioactive,
			Ventilated,
			DrainDisposal
		}
	],

	(* unique fields *)
	NotNullFieldTest[packet,{
			ConnectionType,
			Gauge,
			InnerDiameter,
			OuterDiameter,
			NeedleLength,
			Bevel,
			WettedMaterials
		}
	],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemBoxCutterQTests*)


validModelItemBoxCutterQTests[packet:PacketP[Model[Item,BoxCutter]]] := {

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,{
		Name,
		Synonyms,
		BladeMaterial,
		CasingMaterial,
		CutterWidth,
		CutterLength
	}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};

(* ::Subsection::Closed:: *)
(*validModelItemCalibrationDistanceBlockQTests*)

validModelItemCalibrationDistanceBlockQTests[packet:PacketP[Model[Item,CalibrationDistanceBlock]]]:={
	(* fields that must be Null *)
	NullFieldTest[
		packet,
		{
			WettedMaterials
		}
	],

	(* Fields that must be uploaded *)
	NotNullFieldTest[
		packet,
		{
			Name,
			Synonyms,
			Dimensions,
			AllowedSizeTolerance
		}
	],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};

(* ::Subsection::Closed:: *)
(*validModelItemCalibrationWeightQTests*)


validModelItemCalibrationWeightQTests[packet:PacketP[Model[Item,CalibrationWeight]]]:={
	(* fields that must be Null *)
	NullFieldTest[
		packet,
		{
			WettedMaterials
		}
	],

	(* Fields that must be uploaded *)
	NotNullFieldTest[
		packet,
		{
			Name,
			Synonyms,
			NominalWeight,
			AllowedWeightTolerance,
			Shape,
			WeightClass,
			Material
		}
	],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};





(* ::Subsection::Closed:: *)
(*validModelItemCounterweightQTests*)


validModelItemCounterweightQTests[packet:PacketP[Model[Item,Counterweight]]]:={
	NotNullFieldTest[packet, {Name, Synonyms, Weight}],
	NullFieldTest[
		packet,
		{
			WettedMaterials
		}
	],

	Test["If BottomCavity3D is populated, all entries lie withing the Dimensions of the Item:",
		If[MatchQ[Lookup[packet,BottomCavity3D],Except[Null | {}]],
			Module[{xDim,yDim,zDim},
				{xDim,yDim,zDim}=Lookup[packet,Dimensions];
				MatchQ[
					Lookup[packet,BottomSupport3D],
					{{RangeP[0Millimeter,xDim],RangeP[0Millimeter,yDim],RangeP[0Millimeter,zDim]}..}
				]],
			True
		]
	],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};




(* ::Subsection::Closed:: *)
(*validModelItemFaceShieldQTests*)


validModelItemFaceShieldQTests[packet:PacketP[Model[Item,FaceShield]]] := {

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,{
		Name,
		Synonyms,
		HeadCoverage,
		ChinGuard,
		AdjustableSizing,
		AdjustableShieldPosition,
		VisorMaterial,
		VisorProperties
	}],

	NullFieldTest[packet,{
		Expires,
		WettedMaterials,
		ShelfLife,
		UnsealedShelfLife
	}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemFloorMatQTests*)


validModelItemFloorMatQTests[packet:PacketP[Model[Item, FloorMat]]] := {
	(* Fields that should be filled in *)
	NotNullFieldTest[packet,{Name, Synonyms}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemGloveQTests*)


validModelItemGloveQTests[packet:PacketP[Model[Item,Glove]]] := {

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,{
		Name,
		Synonyms,
		GloveSize,
		GloveType,
		Coverage,
		WaterResistant,
		MaxTemperature,
		MinTemperature
	}],

	NullFieldTest[packet,{
		Expires,
		WettedMaterials,
		ShelfLife,
		UnsealedShelfLife
	}],

	RequiredTogetherTest[packet, {MinTemperature, MaxTemperature}],

	Test[
		"MinTemperature shoud be less than MaxTemperature:",
		Lookup[packet, MinTemperature] <= Lookup[packet, MaxTemperature],
		True
	],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemHeatGunQTests*)


validModelItemHeatGunQTests[packet:PacketP[Model[Item,HeatGun]]] := {

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,{
		Name,
		Synonyms,
		PowerType,
		PlugRequirements,
		CordLength,
		PowerConsumption,
		AdjustableFanSpeed,
		AdjustableTemperature,
		MinFlowRate,
		MaxFlowRate,
		MinTemperature,
		MaxTemperature
	}],

	NullFieldTest[packet,{
		Expires,
		WettedMaterials,
		ShelfLife,
		UnsealedShelfLife
	}],

	RequiredTogetherTest[packet, {AdjustableTemperature, MinTemperature, MaxTemperature}],

	RequiredTogetherTest[packet, {AdjustableFanSpeed, MinFlowRate, MaxTemperature}],

	Test[
		"MinTemperature shoud be less than or equal to MaxTemperature:",
		MapThread[MatchQ[#1,LessEqualP[#2]]&, {Lookup[packet, MinTemperature],Lookup[packet, MaxTemperature]}],
		{True..}
	],

	Test[
		"MinFlowRate shoud be less than or equal to MaxFlowRate:",
		MapThread[MatchQ[#1,LessEqualP[#2]]&, {Lookup[packet, MinFlowRate],Lookup[packet, MaxFlowRate]}],
		{True..}
	],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]

};


(* ::Subsection::Closed:: *)
(*validModelItemIceScraperQTests*)


validModelItemIceScraperQTests[packet:PacketP[Model[Item,IceScraper]]] := {

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,{
		Name,
		Synonyms,
		BladeMaterial,
		HandleMaterial,
		IceScraperLength,
		BladeWidth
	}],
	NullFieldTest[
		packet,
		{
			WettedMaterials
		}
	],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemMagnetizationRackQTests*)


validModelItemMagnetizationRackQTests[packet:PacketP[Model[Item,MagnetizationRack]]]:={

	NotNullFieldTest[packet,{Name,Synonyms,MagnetFootprint,Capacity}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet,Synonyms],Lookup[packet,Name]],
		True
	],

	Test["If BottomCavity3D is populated, all entries lie withing the Dimensions of the Item:",
		If[MatchQ[Lookup[packet,BottomCavity3D],Except[Null | {}]],
			Module[{xDim,yDim,zDim},
				{xDim,yDim,zDim}=Lookup[packet,Dimensions];
				MatchQ[
					Lookup[packet,BottomSupport3D],
					{{RangeP[0Millimeter,xDim],RangeP[0Millimeter,yDim],RangeP[0Millimeter,zDim]}..}
				]],
			True
		]
	],

	(* if can be used with robotic sample preparation, Footprint must be specified *)
	RequiredTogetherTest[packet,{LiquidHandlerPrefix,Footprint}]
};


(* ::Subsection::Closed:: *)
(*validModelItemPlateSealRollerQTests*)


validModelItemPlateSealRollerQTests[packet:PacketP[Model[Item,PlateSealRoller]]] := {

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,{
		Name,
		Synonyms,
		RollerMaterial,
		HandleMaterial,
		RollerDiameter,
		RollerLength
	}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};

(* ::Subsection::Closed:: *)
(*validModelItemRodQTests*)


validModelItemRodQTests[packet:PacketP[Model[Item,Rod]]] := {

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,{
		Name,
		Synonyms
	}]
};


(* ::Subsection::Closed:: *)
(*validModelItemRubberMalletQTests*)


validModelItemRubberMalletQTests[packet:PacketP[Model[Item,RubberMallet]]] := {

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,{
		Name,
		Synonyms,
		MalletHeadDiameter,
		MalletLength,
		MalletHeadColor,
		HandleMaterial,
		Weight
	}],
	NullFieldTest[
		packet,
		{
			WettedMaterials
		}
	],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemRulerQTests*)


validModelItemRulerQTests[packet:PacketP[Model[Item,Ruler]]]:={
	NotNullFieldTest[packet,{Name, Synonyms}],

	NullFieldTest[
		packet,
		{
			WettedMaterials
		}
	],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};



(* ::Subsection::Closed:: *)
(*validModelItemScrewdriverQTests*)


validModelItemScrewdriverQTests[packet:PacketP[Model[Item,Screwdriver]]] := {

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,{
		Name,
		Synonyms,
		ShaftLength,
		ShaftDiameter,
		HandleLength,
		RemovableBit
	}],
	NullFieldTest[
		packet,
		{
			WettedMaterials
		}
	],

	(* If the tip is fixed, make sure we have tip parameters *)
	Test["If the screwdriver bit is not removable, DriveType, DriveSize, SharpTip and Magnetizable must be filled out, otherwise they must be Null:",
		Lookup[packet, {RemovableBit, DriveType, DriveSize, SharpTip, Magnetizable}],
		Alternatives[{Except[False],Null,Null,Null,Null},{False,Except[Null],Except[Null],Except[Null],Except[Null]}]
	],

	(* If the tip is removable, make sure we have removable parameters *)
	Test["If the screwdriver bit is removable, BitConnectionType must be filled out:",
		Lookup[packet, {RemovableBit, BitConnectionType}],
		Alternatives[{True,Except[Null]},{Except[True],Null}]
	],

	(* If the drive size code can be filled out, it should be *)
	Test["If the screwdriver DriveType has a recognized sizing code, the DriveSizeCode of the tip must be filled out, otherwise it must be Null:",
		Lookup[packet, {DriveType, DriveSizeCode}],
		Alternatives[{Phillips,ScrewdriveSizeCodePhillipsP},{Torx,ScrewdriveSizeCodeTorxP},{Pozidriv,ScrewdriveSizeCodePozidrivP},{_,Null}]
	],

	(* If the tip thickness can be filled out, it should be *)
	Test["If the screwdriver DriveType is composed of blades, the TipThickness must be filled out, otherwise is must be Null:",
		Lookup[packet, {DriveType, TipThickness}],
		Alternatives[{Phillips|Slotted,Except[Null]},{_,Null}]
	]
};




(* ::Subsection::Closed:: *)
(*validModelItemScrewdriverBitQTests*)


validModelItemScrewdriverBitQTests[packet:PacketP[Model[Item,ScrewdriverBit]]] :={
	NotNullFieldTest[packet, {
		Name,
		Synonyms,
		DriveType,
		DriveSize,
		SharpTip,
		Magnetizable
	}],

	(* If the drive size code can be filled out, it should be *)
	Test["If the tip DriveType has a recognized sizing code, the DriveSizeCode of the tip must be filled out, otherwise it must be Null:",
		Transpose[Lookup[packet, {DriveType, DriveSizeCode}]],
		{Alternatives[{Phillips,ScrewdriveSizeCodePhillipsP},{Torx,ScrewdriveSizeCodeTorxP},{Pozidriv,ScrewdriveSizeCodePozidrivP},{_,Null}]..}
	],

	(* If the tip thickness can be filled out, it should be *)
	Test["If the tip DriveType is composed of blades, the TipThickness must be filled out, otherwise is must be Null:",
		Transpose[Lookup[packet, {DriveType, TipThickness}]],
		{Alternatives[{Phillips|Slotted,Except[Null]},{_,Null}]..}
	]
};


(* ::Subsection:: *)
(*validModelItemSeptumQTests*)


validModelItemSeptumQTests[packet:PacketP[Model[Item, Septum]]]:={

	NullFieldTest[packet,{
		MSDSFile,
		MSDSRequired,
		NFPA,
		DOTHazardClass,
		BiosafetyLevel,
		TransportTemperature,
		Flammable,
		IncompatibleMaterials,
		LightSensitive
	}],

	(* unique fields *)
	NotNullFieldTest[packet,{CoverFootprint,Name,Synonyms,ImageFile,Diameter}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	],

	RequiredTogetherTest[packet, {Positions, PositionPlotting}]
};


(* ::Subsection::Closed:: *)
(* validModelItemSequencingCartridgeQTests *)


validModelItemSequencingCartridgeQTests[packet : PacketP[Model[Item, SequencingCartridge]]] := {
	(* Fields that SHOULD NOT be informed, ie should be Null*)
	NullFieldTest[packet,
		{
			IncompatibleMaterials
		}
	],

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,
		{
			VersionNumber,
			NumberOfCapillaries,
			ShelfLife,
			UnsealedShelfLife,
			WettedMaterials,
			Reusable,
			MaxNumberOfUses,
			Name,
			Synonyms
		}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemStickerQTests*)


validModelItemStickerQTests[packet:PacketP[Model[Item,Sticker]]]:={

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,{
		Name,
		StickersPerSheet,
		AspectRatio,
		BarcodeType,
		StickersPerSheet,
		AspectRatio,
		HorizontalMargin,
		VerticalMargin,
		HorizontalPitch,
		VerticalPitch,
		Width,
		Height,
		BarcodeHorizontalPosition,
		BarcodeVerticalPosition,
		BarcodeSize,
		TextHorizontalPosition,
		TextVerticalPosition,
		TextVerticalPitch,
		TextBoxWidth,
		TextSize,
		BorderWidth,
		CharacterLimit,
		StickerSize,
		StickerType,
		Name,
		Synonyms
	}
	],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	],


	(* Fields that should NOT be filled in *)
	NullFieldTest[packet,{
			LightSensitive,
			Flammable,
			IncompatibleMaterials,
			Radioactive,
			Ventilated,
			DrainDisposal,
			MSDSFile,
			MSDSRequired,
			NFPA,
			DOTHazardClass,
			BiosafetyLevel,
			TransportTemperature,
			WettedMaterials
		}
	],

	(*Other Tests*)
	Test["Width is greater or equal to 0 and less than HorizontalPitch:",
		Module[{width,horizontalPitch},
			{width,horizontalPitch}=Lookup[packet,{Width,HorizontalPitch}];
			MatchQ[width, RangeP[0 Milli Meter,horizontalPitch]]
		],
		True
	],
	Test["Height is greater or equal to 0 and less than VerticalPitch:",
		Module[{height,verticalPitch},
			{height,verticalPitch}=Lookup[packet,{Height,VerticalPitch}];
			MatchQ[height, RangeP[0 Milli Meter,verticalPitch]]
		],
		True
	],
	Test["Columns * Rows equals NumberOfWells:",
		Module[{rows,columns},
			{rows,columns}=Lookup[packet,{Rows,Columns}];
			rows*columns
		],
		Lookup[packet,StickersPerSheet]
	],
	Test["Columns/Rows  equals AspectRatio:",
		Lookup[packet,AspectRatio],
		_?(Equal[#,Lookup[packet,Columns]/Lookup[packet,Rows]]&)
	],
	Test["StickerSize and StickerType combination is unique:",
		Module[{size,type},
			{size,type}=Lookup[packet,{StickerSize,StickerType}];
			Length[Search[Model[Item,Sticker],StickerSize==size&&StickerType==type]]
		],
		1
	]
};



(* ::Subsection::Closed:: *)
(*validModelItemTabletCutterQTests*)


validModelItemTabletCutterQTests[packet:PacketP[Model[Item,TabletCutter]]] := {

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,{
		Name,
		Synonyms,
		AsymmetricCut
	}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};



(* ::Subsection::Closed:: *)
(*validModelItemTipsQTests*)


validModelItemTipsQTests[packet : PacketP[Model[Item, Tips]]] := {
	(* Fields that SHOULD be informed, ie should NOT be Null*)

	NotNullFieldTest[packet, {
		Name,
		Synonyms,
		Conductive,
		Filtered,
		MaxVolume,
		MinVolume,
		Racked,
		Sterile,
		Material,
		AspirationDepth,
		WettedMaterials,
		PipetteType,
		TipType,
		Diameter3D
	}
	],

	Test["If Sterilized field is True, Sterile field must be True:",
		If[MatchQ[Lookup[packet, Sterilized], True],
			TrueQ[Lookup[packet, Sterile]],
			True
		],
		True
	],

	Test["TipConnectionType cannot be Null if PipetteType is Micropipette, Serological, or PositiveDisplacement:",
		If[MatchQ[Lookup[packet, PipetteType], Alternatives[Micropipette, Serological, PositiveDisplacement]],
			MatchQ[TipConnectionType, Except[Null]],
			True
		],
		True
	],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	],

	(* Need either Products or ServiceProviders *)
	UniquelyInformedTest[packet, {Products, ServiceProviders}],

	NullFieldTest[packet, {
		LightSensitive,
		MSDSRequired,
		MSDSFile,
		Flammable,
		IncompatibleMaterials,
		NFPA,
		DOTHazardClass,
		BiosafetyLevel,
		Radioactive,
		Ventilated,
		DrainDisposal
	}
	],

	(* Additional tests *)
	FieldComparisonTest[packet, {MinVolume, MaxVolume}, LessEqual],

	(* Hamilton-specific tests *)
	Test["For Hamilton wide-bore tips, the CatalogNumber of the Product has to be on the list of supported ones:",
		If[
			And[
				MatchQ[Lookup[packet,PipetteType],Hamilton],
				MatchQ[Lookup[packet,WideBore],True]
			],
			(* Hamilton tips have only 1 Product ever - from Hamilton *)
			KeyExistsQ[Experiment`Private`$HamiltonPartNumbersEquivalence,Download[Lookup[packet,Products][[1]],CatalogNumber]],
			(* pass for all other cases *)
			True
		],
		True
	],

	Test["For serologocial pipettes, at least one graduations field (AscendingGraduations or DescendingGraduations) is informed:",
		If[MatchQ[Lookup[packet, PipetteType], Serological],
			MatchQ[Lookup[packet, {AscendingGraduations, DescendingGraduations}], Except[{{}, {}}]],
			True
		],
		True
	],

	Test["AscendingGraduations are listed from the smallest marking:",
		{Lookup[packet,AscendingGraduations],MatchQ[Lookup[packet,AscendingGraduations],Sort[Lookup[packet,AscendingGraduations]]]},
		{{___},True}
	],
	Test["DescendingGraduations are listed from the largest marking:",
		{Lookup[packet,DescendingGraduations],MatchQ[Lookup[packet,DescendingGraduations],Reverse[Sort[Lookup[packet,DescendingGraduations]]]]},
		{{___},True}
	],
	Test["For serological pipettes, MinVolume is a member of AscendingGraduations or max volume minus DescendingGraduations:",
		If[MatchQ[Lookup[packet, PipetteType], Serological],
			MemberQ[Lookup[packet, AscendingGraduations], EqualP[Lookup[packet, MinVolume]]] || MemberQ[Lookup[packet, MaxVolume] - Lookup[packet, DescendingGraduations], EqualP[Lookup[packet, MinVolume]]],
			True
		],
		True
	],
	Test["For serological pipettes, MaxVolume is a member of AscendingGraduations or zero is a member of DescendingGraduations:",
		If[MatchQ[Lookup[packet, PipetteType], Serological],
			MemberQ[Lookup[packet, AscendingGraduations], EqualP[Lookup[packet, MaxVolume]]] || MemberQ[Lookup[packet, DescendingGraduations], EqualP[0 Milliliter]],
			True
		],
		True
	]
};



(* ::Subsection::Closed:: *)
(*validModelItemTabletCrusherQTests*)


validModelItemTabletCrusherQTests[packet:PacketP[Model[Item,TabletCrusher]]] := {
	(* Fields that should be filled in *)
	NotNullFieldTest[packet,{Name, Synonyms}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemTabletCrusherBagQTests*)


validModelItemTabletCrusherBagQTests[packet:PacketP[Model[Item,TabletCrusherBag]]] := {
	(* Fields that should be filled in *)
	NotNullFieldTest[packet,{Name, Synonyms}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemTweezerQTests*)


validModelItemTweezerQTests[packet:PacketP[Model[Item,Tweezer]]] := {

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,{
		Name,
		Synonyms,
		TipType,
		TweezerLength,
		Material
	}],
	NullFieldTest[
		packet,
		{
			WettedMaterials
		}
	],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};



(* ::Subsection::Closed:: *)
(*validModelItemViperMountingToolQTests*)


validModelItemViperMountingToolQTests[packet:PacketP[Model[Item,ViperMountingTool]]] := {

	(* Fields that should be filled in *)
	NotNullFieldTest[packet,{Name, Synonyms}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemWeightHandleQTests*)


validModelItemWeightHandleQTests[packet:PacketP[Model[Item,WeightHandle]]] := {

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,{
		Name,
		Synonyms,
		CalibrationWeights
	}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemWrenchQTests*)


validModelItemWrenchQTests[packet:PacketP[Model[Item,Wrench]]] := {

	NotNullFieldTest[packet, {
		Name,
		Synonyms,
		WrenchType,
		Ratcheting,
		Kit
	}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	],

	(* Wrench length must be specified in some form *)
	Test["Either WrenchLength or ArmLengths must be specified:",
		Lookup[packet, {WrenchLength, ArmLengths}],
		Alternatives[{Except[Null],_},{Null,Except[Null]}]
	],

	(* Grip sizes must be filled out iff the wrench is fixed *)
	Test["Grip size must be non-Null for fixed size WrenchTypes and Null for adjustable WrenchTypes:",
		Lookup[packet, {WrenchType,SecondaryWrenchType,GripSizes}],
		Alternatives[
			{Adjustable,Adjustable,NullP|{}},
			{Adjustable,Except[Adjustable],{Null,Except[Null]}},
			{Adjustable,Null,{}},
			{Except[Adjustable],Adjustable,{Except[Null],Null}},
			{Except[Adjustable],Except[Adjustable],{Except[Null],Except[Null]}},
			{Except[Adjustable],Null,{Except[Null]...}}
		]
	],

	(* Min/Max Grip sizes must be filled out iff the wrench is adjustable *)
	Test["Min/Max Grip size must be non-Null for Adjustable WrenchTypes and Null for others:",
		Lookup[packet, {WrenchType,SecondaryWrenchType,MinGripSizes,MaxGripSizes}],
		Alternatives[
			{Adjustable,Adjustable,{Except[Null],Except[Null]},{Except[Null],Except[Null]}},
			{Adjustable,Except[Adjustable],{Except[Null],Null},{Except[Null],Null}},
			{Except[Adjustable],Adjustable,{Null,Except[Null]},{Null,Except[Null]}},
			{Except[Adjustable],Except[Adjustable],NullP|{},NullP|{}}
		]
	]
};



(* ::Subsection:: *)
(*validModelItemDialysisMembraneQTests*)


(* ::Subsection::Closed:: *)
(* validModelItemSequencingCartridgeQTests *)


validModelItemSequencingCartridgeQTests[packet:PacketP[Model[Item,Cartridge, DNASequencing]]] := {
	(* Fields that SHOULD NOT be informed, ie should be Null*)
	NullFieldTest[packet,
		{
			IncompatibleMaterials
		}
	],

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,
		{
			VersionNumber,
			NumberOfCapillaries,
			ShelfLife,
			UnsealedShelfLife,
			WettedMaterials,
			Reusable,
			MaxNumberOfUses,
			Name,
			Synonyms
		}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemCartridgeProteinCapillaryElectrophoresisQTests*)


validModelItemCartridgeProteinCapillaryElectrophoresisQTests[packet:PacketP[Model[Item, Cartridge,ProteinCapillaryElectrophoresis]]]:={

	(* Shared fields *)
	NullFieldTest[packet,{
		MSDSFile,
		MSDSRequired,
		NFPA,
		DOTHazardClass,
		BiosafetyLevel,
		TransportTemperature,
		Flammable,
		IncompatibleMaterials,
		LightSensitive
	}
	],

	NotNullFieldTest[packet,{
		WettedMaterials,
		MaxNumberOfUses,
		CartridgeType,
		CapillaryLength,
		CapillaryDiameter,
		MaxInjections,
		MaxInjectionsPerBatch,
		MaxBatches
	}
	],

	(*Required Together*)
	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelItemInoculationPaperQTests*)


validModelItemInoculationPaperQTests[packet:PacketP[Model[Item,InoculationPaper]]]:={

	(* Shared fields which should be null *)

	(* Shared fields which should NOT be null *)
	NotNullFieldTest[packet,{
		Name,
		Synonyms,
		Model,
		Product,
		DateStocked,
		Shape
	}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	],

	(*Paper thickness is equal to the z dimension. Work around lack of numeric precision*)
	Test["Paper thickness is equal to the z dimension:",
		Module[{dimensions,thickness},
			{dimensions,thickness}=Lookup[packet,{Dimensions,PaperThickness}];
			If[MatchQ[thickness,Null],True,dimensions[[3]]-thickness]
		],
		Alternatives[True,LessEqualP[10^-10 Meter]]
	],

	(*If paper is Disk shape, diameter must be specified*)
	Test["Diameter must be specified if and only if shape is Disk:",
		Lookup[packet,{Shape,Diameter}],
		Alternatives[{Disk,Except[Null]},{Except[Disk],Null}]
	],

	(*If diameter is specified, it must equal both the x and y dimensions. Work around lack of numeric precision*)
	Test["If Diameter is specified, it is equal to x and y Dimensions:",
		Module[{dimensions,diameter},
			{dimensions,diameter}=Lookup[packet,{Dimensions,Diameter}];
			If[MatchQ[diameter,Null],True,dimensions-diameter]
		],
		Alternatives[True,{LessEqualP[10^-10 Meter],LessEqualP[10^-10 Meter],_}]
	],

	(*Ensure thickness is shortest dimension*)
	Test["Both dimensions in the plane of the paper are longer than the thickness of the paper:",
		Module[{dimensions,thickness},
			{dimensions,thickness}=Lookup[packet,{Dimensions,PaperThickness}];
			{dimensions[[1]]>thickness,dimensions[[2]]>thickness}
		],
		{True,True}
	]

};



(* ::Subsection::Closed:: *)
(*validModelItemCartridgeDesiccantQTests*)


validModelItemCartridgeDesiccantQTests[packet:PacketP[Model[Item,Cartridge,Desiccant]]]:={

	NotNullFieldTest[packet,{
		Rechargeable
	}],

	(*Sanity check ranges*)
	FieldComparisonTest[packet,{MaxTemperature,MinTemperature},Greater],

	(* Check that a pair of indicator colors are given *)
	RequiredTogetherTest[packet,{InitialIndicatorColor,ExhaustedIndicatorColor}]

};



(* ::Subsection:: *)
(*validModelItemConsumableWickQTests*)


validModelItemConsumableWickQTests[packet:PacketP[Model[Item,Consumable,Wick]]]:=
{
	(* Fields that should be filled in *)
	NotNullFieldTest[packet,{BurnTime,WickLength}]
};


(* ::Subsection:: *)
(*validModelItemPlungerQTests*)


validModelItemPlungerQTests[packet:PacketP[Model[Item,Plunger]]]:=
	{
		(* Fields that should be filled in *)
		NotNullFieldTest[packet,{Diameter}]
	};


(* ::Subsection::Closed:: *)
(*validModelItemMagnifyingGlassQTests*)


validModelItemMagnifyingGlassQTests[packet:PacketP[Model[Item,MagnifyingGlass]]] := {

	NotNullFieldTest[packet, {
		Name,
		Synonyms,
		Magnification,
		Lightning,
		Diameter,
		HandHeld
	}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms], Lookup[packet, Name]],
		True
	]
};



(* ::Subsection::Closed:: *)
(*validModelItemPinchValveCoverQTests*)


validModelItemPinchValveCoverQTests[packet:PacketP[Model[Item,PinchValveCover]]]:={};


(* ::Subsection::Closed:: *)
(*validModelItemPlierQTests*)


validModelItemPlierQTests[packet:PacketP[Model[Item,Plier]]] := {

	NotNullFieldTest[packet, {
		Name,
		Synonyms,
		PlierType,
		JawMaterial,
		JawLengths,
		HandleLengths
	}]

};




(* ::Subsection:: *)
(*validModelItemDeliveryNeedleQTests*)


validModelItemDeliveryNeedleQTests[packet:PacketP[Model[Item,DeliveryNeedle]]]:={
	NotNullFieldTest[packet, {
		DeliveryTipDimensions
	}]
};





(* ::Subsection:: *)
(*validModelItemSupportRodQTests*)


validModelItemSupportRodQTests[packet:PacketP[Model[Item,SupportRod]]]:={
};


(* ::Subsection:: *)
(*validModelItemWasteLabelQTests*)

validModelItemWasteLabelQTests[packet : PacketP[Model[Item, WasteLabel]]] := {};


(* ::Subsection:: *)
(*validModelItemWasherQTests*)


validModelItemWasherQTests[packet:PacketP[Model[Item,Washer]]]:={

};


(* ::Subsection:: *)
(*validModelItemWilhelmyPlateQTests*)


validModelItemWilhelmyPlateQTests[packet:PacketP[Model[Item,WilhelmyPlate]]]:={
	NotNullFieldTest[packet,{
		SampleHolder
	}]
};


(* ::Subsection:: *)
(*Test Registration *)


registerValidQTestFunction[Model[Item],validModelItemQTests];
registerValidQTestFunction[Model[Item, ArrayCardSealer],validModelItemArrayCardSealerQTests];
registerValidQTestFunction[Model[Item, BLIProbe],validModelItemBLIProbeQTests];
registerValidQTestFunction[Model[Item, Consumable],validModelItemConsumableQTests];
registerValidQTestFunction[Model[Item, Consumable, Blade],validModelItemConsumableBladeQTests];
registerValidQTestFunction[Model[Item, Consumable, Sandpaper],validModelItemConsumableSandpaperQTests];
registerValidQTestFunction[Model[Item, CrossFlowFilter],validModelItemCrossFlowFilterQTests];
registerValidQTestFunction[Model[Item, Blank],validItemBlankQTests];
registerValidQTestFunction[Model[Item, Plunger],validModelItemPlungerQTests];
registerValidQTestFunction[Model[Item, Cap],validModelItemCapQTests];
registerValidQTestFunction[Model[Item, PlateSeal],validModelItemPlateSealQTests];
registerValidQTestFunction[Model[Item, Stopper],validModelItemStopperQTests];
registerValidQTestFunction[Model[Item, Cap, ElectrodeCap], validModelItemCapElectrodeCapQTests];
registerValidQTestFunction[Model[Item, Cap, ElectrodeCap, CalibrationCap], validModelItemCapElectrodeCapCalibrationCapQTests];
registerValidQTestFunction[Model[Item, Lid],validModelItemLidQTests];
registerValidQTestFunction[Model[Item, LidSpacer],validModelItemLidSpacerQTests];
registerValidQTestFunction[Model[Item, Clamp],validModelItemClampQTests];
registerValidQTestFunction[Model[Item, Column],validModelItemColumnQTests];
registerValidQTestFunction[Model[Item, ColumnHolder],validModelItemColumnHolderQTests];
registerValidQTestFunction[Model[Item, Electrode], validModelItemElectrodeQTests];
registerValidQTestFunction[Model[Item, Electrode, ReferenceElectrode], validModelItemElectrodeReferenceElectrodeQTests];
registerValidQTestFunction[Model[Item, ElectrodePolishingPad], validModelItemElectrodePolishingPadQTests];
registerValidQTestFunction[Model[Item, ElectrodePolishingPlate], validModelItemElectrodePolishingPlateQTests];
registerValidQTestFunction[Model[Item, Filter],validModelItemFilterQTests];
registerValidQTestFunction[Model[Item, Filter, MicrofluidicChip],validModelItemFilterMicrofluidicChipQTests];
registerValidQTestFunction[Model[Item, Gel],validModelItemGelQTests];
registerValidQTestFunction[Model[Item, GCInletLiner],validModelItemGCInletLinerQTests];
registerValidQTestFunction[Model[Item, GCColumnWafer],validModelItemGCColumnWaferQTests];
registerValidQTestFunction[Model[Item, GrindingBead],validModelItemGrindingBeadQTests];
registerValidQTestFunction[Model[Item, SwagingTool],validModelItemSwagingToolQTests];
registerValidQTestFunction[Model[Item, Needle],validModelItemNeedleQTests];
registerValidQTestFunction[Model[Item, BoxCutter],validModelItemBoxCutterQTests];
registerValidQTestFunction[Model[Item, CalibrationWeight],validModelItemCalibrationWeightQTests];
registerValidQTestFunction[Model[Item, CalibrationDistanceBlock],validModelItemCalibrationDistanceBlockQTests];
registerValidQTestFunction[Model[Item, Counterweight],validModelItemCounterweightQTests];
registerValidQTestFunction[Model[Item, FaceShield],validModelItemFaceShieldQTests];
registerValidQTestFunction[Model[Item, FloorMat],validModelItemFloorMatQTests];
registerValidQTestFunction[Model[Item, Glove],validModelItemGloveQTests];
registerValidQTestFunction[Model[Item, HeatGun],validModelItemHeatGunQTests];
registerValidQTestFunction[Model[Item, IceScraper],validModelItemIceScraperQTests];
registerValidQTestFunction[Model[Item, InoculationPaper],validModelItemInoculationPaperQTests];
registerValidQTestFunction[Model[Item, MagnetizationRack],validModelItemMagnetizationRackQTests];
registerValidQTestFunction[Model[Item, PlateSealRoller],validModelItemPlateSealRollerQTests];
registerValidQTestFunction[Model[Item, Rod],validModelItemRodQTests];
registerValidQTestFunction[Model[Item, RubberMallet],validModelItemRubberMalletQTests];
registerValidQTestFunction[Model[Item, Ruler],validModelItemRulerQTests];
registerValidQTestFunction[Model[Item, Screwdriver],validModelItemScrewdriverQTests];
registerValidQTestFunction[Model[Item, Septum],validModelItemSeptumQTests];
registerValidQTestFunction[Model[Item, SequencingCartridge],validModelItemSequencingCartridgeQTests];
registerValidQTestFunction[Model[Item, Sticker],validModelItemStickerQTests];
registerValidQTestFunction[Model[Item, TabletCutter], validModelItemTabletCutterQTests];
registerValidQTestFunction[Model[Item, TabletCrusher], validModelItemTabletCrusherQTests];
registerValidQTestFunction[Model[Item, TabletCrusherBag], validModelItemTabletCrusherBagQTests];
registerValidQTestFunction[Model[Item, Tips],validModelItemTipsQTests];
registerValidQTestFunction[Model[Item, Tweezer],validModelItemTweezerQTests];
registerValidQTestFunction[Model[Item, ViperMountingTool],validModelItemViperMountingToolQTests];
registerValidQTestFunction[Model[Item, WeightHandle],validModelItemWeightHandleQTests];
registerValidQTestFunction[Model[Item, Wrench],validModelItemWrenchQTests];
registerValidQTestFunction[Model[Item, DialysisMembrane],validModelItemDialysisMembraneQTests];
registerValidQTestFunction[Model[Item, Cartridge, Desiccant],validModelItemCartridgeDesiccantQTests];
registerValidQTestFunction[Model[Item, Cartridge],validModelItemCartridgeQTests];
registerValidQTestFunction[Model[Item, Cartridge, Column],validModelItemCartridgeColumnQTests];
registerValidQTestFunction[Model[Item, ScrewdriverBit],validModelItemScrewdriverBitQTests];
registerValidQTestFunction[Model[Item, Consumable, Wick],validModelItemConsumableWickQTests];
registerValidQTestFunction[Model[Item, MagnifyingGlass],validModelItemMagnifyingGlassQTests];
registerValidQTestFunction[Model[Item, PinchValveCover],validModelItemPinchValveCoverQTests];
registerValidQTestFunction[Model[Item, Plier],validModelItemPlierQTests];
registerValidQTestFunction[Model[Item, DeliveryNeedle],validModelItemDeliveryNeedleQTests];
registerValidQTestFunction[Model[Item, SupportRod],validModelItemSupportRodQTests];
registerValidQTestFunction[Model[Item, Washer],validModelItemWasherQTests];
registerValidQTestFunction[Model[Item, WasteLabel], validModelItemWasteLabelQTests];
registerValidQTestFunction[Model[Item, WilhelmyPlate],validModelItemWilhelmyPlateQTests];



