(* ::Package:: *)
 
(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*validModelContainerQTests*)


validModelContainerQTests[packet:PacketP[Model[Container]]]:={

	(* ----------General Shared Field shaping ----------*)

	If[MatchQ[Lookup[packet,Type],Except[Model[Container, Site]]],
		NotNullFieldTest[packet, {
			Name,
			Synonyms,
			Authors,
			Positions,
			PositionPlotting,
			Dimensions,
			CrossSectionalShape,
			MinTemperature,
			MaxTemperature,
			SelfStanding
		}
		],
		NotNullFieldTest[packet, {
			Name,
			Synonyms,
			Authors,
			Dimensions
		}
		]
	],


	FieldComparisonTest[packet,{MaxTemperature,MinTemperature},GreaterEqual],
	
	RequiredTogetherTest[packet,{
		StickerPositionOnReceiving,
		PositionStickerPlacementImage
	}],
	
	RequiredTogetherTest[packet,{
		StickerConnectionOnReceiving,
		ConnectionStickerPlacementImage
	}],

	Test["The contents of the Name field is a member of the Synonyms field:",
		MemberQ[Lookup[packet, Synonyms],Lookup[packet, Name]],
		True
	],
	
	Test["If PermanentlySealed is True, CoverTypes and CoverFootprints must be Null:",
		If[MatchQ[Lookup[packet, PermanentlySealed], True],
			MatchQ[Lookup[packet, CoverTypes], {}] && MatchQ[Lookup[packet, CoverFootprints], {}],
			True
		],
		True
	],
	
	
	Test["If BuiltInCover is True, CoverTypes and CoverFootprints must be Null:",
		If[MatchQ[Lookup[packet, BuiltInCover], True],
			MatchQ[Lookup[packet, CoverTypes], {}] && MatchQ[Lookup[packet, CoverFootprints], {}],
			True
		],
		True
	],

	Test["If Ampoule is True, CoverTypes and CoverFootprints must be Null:",
		If[MatchQ[Lookup[packet, Ampoule], True],
			MatchQ[Lookup[packet, CoverTypes], {}] && MatchQ[Lookup[packet, CoverFootprints], {}],
			True
		],
		True
	],

	Test["If PermanentlySealed, BuiltInCover and Ampoule are not True, CoverTypes must not be Null:",
		If[MatchQ[Lookup[packet,Type],Alternatives[Model[Container, Vessel],Model[Container,Plate]]],
			If[And[MatchQ[Lookup[packet, BuiltInCover], Except[True]], MatchQ[Lookup[packet, Ampoule], Except[True]],MatchQ[Lookup[packet, PermanentlySealed], Except[True]]],
				MatchQ[Length[ToList[Lookup[packet, CoverTypes]]], GreaterP[0]],
				True
			],
			True
		],
		True
	],

	Test["If the CoverTypes contains Seal, we must be a Model[Container, Plate]:",
		Lookup[packet,{CoverTypes,Type}],
		{_?(MemberQ[#, Seal]&), TypeP[Model[Container, Plate]]} | {Except[_?(MemberQ[#, Seal]&)], _}
	],

	Test["If the CoverTypes contains Screw or Crimp, we must not be a Model[Container, Vessel]:",
		Lookup[packet,{CoverTypes,Type}],
		{_?(MemberQ[#, Screw|Crimp]&), Except[TypeP[Model[Container, Plate]]]} | {Except[_?(MemberQ[#, Screw|Crimp]&)], _}
	],

	Test["The PreferredWashBin field should be informed if CleaningMethod is populated:",
		If[MatchQ[Lookup[packet,CleaningMethod],CleaningMethodP],
			!NullQ[Lookup[packet,PreferredWashBin]],
			True
		],
		True
	],

	Test["If Sterilized field is True, Sterile field must be True:",
		If[MatchQ[Lookup[packet, Sterilized], True],
			TrueQ[Lookup[packet, Sterile]],
			True
		],
		True
	],

	Test["A container of this model cannot be obtained by both a normal product and a kit product (i.e., Products and KitProducts cannot both be populated):",
		Lookup[packet, {Products, KitProducts}],
		Alternatives[
			{{}, {}},
			{{ObjectP[Object[Product]]..}, {}},
			{{}, {ObjectP[Object[Product]]..}}
		]
	],
	

	(* not all reusable containers need to be cleaned, but for sure if we ARE cleaning it, it is reusable *)
	Test["If CleaningMethod is populated, Reusable must be True:",
		If[MatchQ[Lookup[packet,CleaningMethod],CleaningMethodP],
			TrueQ[Lookup[packet,Reusable]],
			True
		],
		True
	],

	If[MatchQ[Lookup[packet,Type],Except[Model[Container, Site]]],
		Test["Every member of Positions also has a corresponding PositionPlotting entry:",
			Complement[Lookup[Lookup[packet,Positions],Name],Lookup[Lookup[packet,PositionPlotting],Name]],
			{}
		],
		Nothing
	],

	Test[
		"If PreferredCamera->Plate, PreferredIllumination cannot be Side due to instrument limitations:",
		Lookup[packet, {PreferredCamera, PreferredIllumination}],
		Alternatives[
			{Plate, Except[Side]},
			{Except[Plate], _}
		]
	],

	Test["If the container model is in the Public ECL Catalog, ImageFileScale is populated:",
		With[
			{catalogContainerModels = DeleteDuplicates[Cases[Catalog`Private`catalogObjs[], ObjectP[Model[Container]]]]},
			If[MemberQ[catalogContainerModels, Lookup[packet, Object]],
				!MatchQ[Lookup[packet, ImageFileScale], Null],
				True
			]
		],
		True
	],

	Test["If the container model is an Ampoule and arrives as a product containing a sample, that model sample is set to SingleUse -> True:",
		If[TrueQ[Lookup[packet, Ampoule]] && MatchQ[Lookup[packet, ProductsContained], {ObjectP[Object[Product]]..}],
			MatchQ[Download[Lookup[packet, ProductsContained], ProductModel[SingleUse]], {True..}],
			True
		],
		True
	],

	Test["If PermanentlySealed is set to True, Ampoule and Hermetic must not be True:",
		Lookup[packet, {Hermetic, Ampoule, PermanentlySealed}],
		Alternatives[
			{_, _, Null|False},
			{Except[True], Except[True], True}
		]
	],

	Test["If the StorageOrientation is Side|Face StorageOrientationImage must be populated unless it is an unverified Plate/Vessel:",
		Lookup[packet, {StorageOrientation, StorageOrientationImage, VerifiedContainerModel}, $Failed],
		Alternatives[
			{_,_, (False|Null)},
			{(Side|Face), ObjectP[], _},
			{Except[(Side|Face)], _, _}
		]
	],

	Test["If the StorageOrientation is Upright StorageOrientationImage or ImageFile must be populated unless it is an unverified Plate/Vessel:",
		Lookup[packet, {StorageOrientation, StorageOrientationImage, ImageFile, VerifiedContainerModel}],
		Alternatives[
			{_, _, _, (False|Null)},
			{Upright, ObjectP[], _, _},
			{Upright, _, ObjectP[], _},
			{Except[Upright], _, _, _}
		]
	],

	(* ---------- Finer-grained tests for container validity ---------- *)

	containerModelImageAspectRatio[packet],
	containerModelPositionsDimensionsValid[packet]
};


(* Check that all Positions fit within the container's Dimensions *)
(* Works only in the X and Y dimensions; ignores Z *)
containerModelPositionsDimensionsValid[packet:PacketP[]]:=Module[
	{positions,positionPlotting,modelShape,xDim,yDim,zDim,oldPositions,dims,modelPoly,positionPoly,positionPolys,positionNames,valid,invalid},

	(* Look up required fields *)
	{positions,positionPlotting,modelShape}=Lookup[packet,{Positions,PositionPlotting,CrossSectionalShape}];

	(* Return no test if either Positions or PositionPlotting are empty.
		RequiredTogether test shared among all container types will catch cases where one or the other is not populated. *)
	If[Or[MatchQ[positions,{}], MatchQ[positionPlotting, {}]], Return[Nothing]];

	dims=Unitless[#, Meter]&/@Lookup[packet,Dimensions];
	{xDim,yDim,zDim}=dims[[#]] & /@ {1, 2, 3};

	(* generate single position definitions from information from the Positions/PositionPlotting fields for each of the models *)
	oldPositions = Map[
		Function[position,
			Module[{dimensions, positionPlottingEntry, anchorPoint},

				(* get the dimensions into a single tuple; these can be Null, so turn into 0 Meter *)
				dimensions = Lookup[position, {MaxWidth, MaxDepth, MaxHeight}]/.{Null->0 Meter};

				(* find the appropriate PositionPlotting entry for this position name *)
				positionPlottingEntry = SelectFirst[positionPlotting, MatchQ[Lookup[#, Name], Lookup[position, Name]]&];

				(* from the plotting entry, get the anchor point as a single spec *)
				anchorPoint = Lookup[positionPlottingEntry, {XOffset, YOffset, ZOffset}];

				(* assemble a single position entry with all informatino combined into downstream expected format *)
				{Name->Lookup[position, Name], AnchorPoint->anchorPoint, Dimensions->dimensions, CrossSectionalShape->Lookup[positionPlottingEntry, CrossSectionalShape], Rotation->Lookup[positionPlottingEntry, Rotation]}
			]
		],
		positions
	];

	Test[
		"Positions all lie within two of three of the modelContainer's dimensions (requires that the Positions, PositionPlotting, CrossSectionalShape, and Dimensions fields be informed):",
		If[AnyTrue[{oldPositions,modelShape,dims},NullQ],
			True,

			Module[{},
				modelPoly = If[MatchQ[modelShape,(Rectangle|Null)],
					Polygon[{{0,0},{0,yDim},{xDim,yDim},{xDim,0}}],
					Disk[{xDim/2,yDim/2},xDim]
				]; (* Change to footprint later? *)

				(* Define a private helper to Convert a given position to a polygon in the modelContainer coordinate system and rotate it appropriately if necessary *)
				positionPoly[pos_] := Module[
					{anchor=Unitless[AnchorPoint/.pos, Meter],shape=CrossSectionalShape/.pos,rot=Rotation/.pos,(*rotFcn=RotationTransform[],*)halfX=Unitless[(Dimensions/.pos)[[1]]/2, Meter],halfY=Unitless[(Dimensions/.pos)[[2]]/2, Meter]},

					(* Draw the graphics primitive for this position in the coordinate system of the parent modelContainer, rotating as appropriate *)
					Locations`Private`rotatePrimitive[
						If[MatchQ[shape,(Rectangle|Null)],
							Polygon[{{anchor[[1]]-halfX,anchor[[2]]-halfY},{anchor[[1]]-halfX,anchor[[2]]+halfY},{anchor[[1]]+halfX,anchor[[2]]+halfY},{anchor[[1]]+halfX,anchor[[2]]-halfY}}],
							Disk[anchor[[;;2]],halfX]
						],
						anchor,
						rot Degree
					]
				];

				(* Convert all positions to polygons using the function above *)
				positionPolys = {Name/.#,positionPoly[#]}&/@oldPositions;

				(* Figure out which positions are valid and which are not using a helper *)
				valid = Select[positionPolys,Locations`Private`regionEnclosedQ[modelPoly,Last[#],1]&];
				invalid = Complement[positionPolys,valid];
				Length[invalid]==0
			]
		],
		True
	]
];


(* Check that the contents of ContainerImage2D, if they exist, are the same aspect ratio as the modelContainer (within 1%) *)
containerModelImageAspectRatio[packet:PacketP[]]:=Module[
	{containerImage2DFile,dimensionX,dimensionY,dims},

	{containerImage2DFile,dims}=Lookup[packet,{ContainerImage2DFile,Dimensions}];
	If[NullQ[containerImage2DFile],
		Return[Nothing]
	];
	{dimensionX,dimensionY}=dims[[#]]&/@{1,2};

	Test[
		"ContainerImage2DFile's aspect ratio matches the modelContainer's X-Y aspect ratio to within 1%",
		Module[
			{img,ctrAspectRatio,imgDims,imgAspectRatio,aspectRatioPctDiff},
			img=ImportCloudFile[containerImage2DFile];
			ctrAspectRatio=(dimensionX/dimensionY);
			imgDims=ImageDimensions[img];
			imgAspectRatio=imgDims[[1]]/imgDims[[2]];
			aspectRatioPctDiff = 100 * Abs[(1-(ctrAspectRatio/imgAspectRatio))];
			aspectRatioPctDiff<1
		],
		True
	]
];


(* ::Subsection::Closed:: *)
(*validModelContainerBagQTests*)


validModelContainerBagQTests[packet:PacketP[Model[Container,Bag]]]:={
	(* Shared fields shaping *)
	NullFieldTest[packet,{
		CleaningMethod,
		MinVolume,
		PreferredBalance,
		PreferredCamera,
		Ampoule,
		Hermetic
	}]
};


(* ::Subsubsection:: *)
(*validModelContainerBagDishwasherQTests*)


validModelContainerBagDishwasherQTests[packet:PacketP[Model[Container,Bag,Dishwasher]]]:={
	(* Shared fields shaping *)
	NotNullFieldTest[packet,{
		MeshSize
	}]
};

(* ::Subsubsection:: *)
(*validModelContainerBagAsepticQTests*)


validModelContainerBagAsepticQTests[packet:PacketP[Model[Container,Bag,Aseptic]]]:={};


(* ::Subsubsection:: *)
(*validModelContainerBagAutoclaveQTests*)


validModelContainerBagAutoclaveQTests[packet:PacketP[Model[Container,Bag,Autoclave]]]:={
	(* Shared fields shaping *)
	NotNullFieldTest[packet,{
		SterilizationMethods
	}]
};



(* ::Subsection::Closed:: *)
(*validModelContainerBenchQTests*)


validModelContainerBenchQTests[packet:PacketP[Model[Container,Bench]]]:={
	(* Shared fields shaping *)
	NullFieldTest[packet, {
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerBenchReceivingQTests*)


validModelContainerBenchReceivingQTests[packet:PacketP[Model[Container,Bench, Receiving]]]:={};


(* ::Subsection::Closed:: *)
(*validModelContainerBuildingQTests*)


validModelContainerBuildingQTests[packet:PacketP[Model[Container,Building]]]:={
	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerSiteQTests*)


validModelContainerSiteQTests[packet:PacketP[Model[Container,Site]]]:={
(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};



(* ::Subsection::Closed:: *)
(*validModelContainerCabinetQTests*)


validModelContainerCabinetQTests[packet:PacketP[Model[Container,Cabinet]]]:={
	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};

(* ::Subsection::Closed:: *)
(*validModelContainerCapillaryQTests*)


validModelContainerCapillaryQTests[packet:PacketP[Model[Container, Capillary]]]:={

	NullFieldTest[packet, {
		CleaningMethod,
		MinVolume,
		MaxVolume}],

	(* Fields which should not be null *)
	NotNullFieldTest[packet, {
		CasingRequired,
		IrretrievableContents,
		CapillaryType,
		Barcode}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerCartDockQTests*)


validModelContainerCartDockQTests[packet:PacketP[Model[Container,CartDock]]]:={
	(* Shared fields shaping *)
	NotNullFieldTest[packet,{
		PlugRequirements,
		AssociatedAccessories
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerExtractionCartridgeQTests*)


validModelContainerExtractionCartridgeQTests[packet:PacketP[Model[Container,ExtractionCartridge]]]:={

	(* Required fields *)
	NotNullFieldTest[packet,{
		MaxVolume,
		ImageFile
	}],

	RequiredTogetherTest[packet,{InletFilterThickness,InletFilterMaterial}],
	RequiredTogetherTest[packet,{OutletFilterThickness,OutletFilterMaterial}],

	FieldComparisonTest[packet,{MinPressure,MaxPressure},LessEqual],
	FieldComparisonTest[packet,{MinpH,MaxpH},LessEqual],
	FieldComparisonTest[packet,{MaxFlowRate,MinFlowRate},GreaterEqual],
	FieldComparisonTest[packet,{MaxFlowRate,NominalFlowRate},GreaterEqual],
	FieldComparisonTest[packet,{NominalFlowRate,MinFlowRate},GreaterEqual],

	(* Fields that must be informed if ChromatographyType is Flash *)
	If[MatchQ[Lookup[packet,ChromatographyType],Flash],
		NotNullFieldTest[
			packet,
			{PackingType,MaxBedWeight,MinFlowRate,MaxFlowRate,MinPressure,MaxPressure,Diameter,CartridgeLength}
		],
		Nothing
	],

	Test["If ChromatographyType is Flash, PackingType must be Prepacked or HandPacked:",
		Switch[Lookup[packet,{ChromatographyType,PackingType}],
			{Flash,Prepacked|HandPacked},True,
			{Flash,_},False,
			{_,_},True
		],
		True
	],

	Test["If ChromatographyType is Flash and PackingType is Prepacked, then PackingMaterial, BedWeight SeparationMode, and (optionally) FunctionalGroup must be informed:",
		Switch[Lookup[packet,{ChromatographyType,PackingType,PackingMaterial,BedWeight,SeparationMode,FunctionalGroup}],
			{Flash,Prepacked,FlashChromatographyCartridgePackingMaterialP,MassP,FlashChromatographySeparationModeP,Null|C18},True,
			{Flash,Prepacked,_,_,_,_},False,
			{_,_,_,_,_,_},True
		],
		True
	],

	(* If ChromatographyType is Flash, BedWeight must be less than or equal to MaxBedWeight *)
	If[MatchQ[Lookup[packet,ChromatographyType],Flash],
		FieldComparisonTest[packet,{BedWeight,MaxBedWeight},LessEqual],
		Nothing
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerCentrifugeRotorQTests*)


validModelContainerCentrifugeRotorQTests[packet:PacketP[Model[Container,CentrifugeRotor]]]:={

	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}],

	NotNullFieldTest[packet, {RotorType,MaxForce,MaxRadius,MaxImbalance}],


	Test["If RotorType is SwingBucket, NumberOfBuckets has to be informed. If RotorType is Fixed, NumberOfBuckets has to be Null:",
		Lookup[packet,{RotorType,NumberOfBuckets}],
		{SwingingBucket,Except[Null]}|{FixedAngle,Null}
	]
};



(* ::Subsection::Closed:: *)
(*validModelContainerCentrifugeBucketQTests*)


validModelContainerCentrifugeBucketQTests[packet:PacketP[Model[Container,CentrifugeBucket]]]:={

	NotNullFieldTest[packet, {Rotor,MaxForce,MaxRadius,MaxRotationRate,ImageFile}],


	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		MinVolume,
		MaxVolume,
		CleaningMethod,
		Ampoule,
		Hermetic
	}],

	(* MaxForce is equal to MaxRotationRate at MaxRadius *)
	Test[
		"MaxForce is equal to MaxRotationRate at MaxRadius:",
		Equal[
			Round[RCFToRPM[Lookup[packet,MaxForce],Lookup[packet,MaxRadius]]],
			Round[Lookup[packet,MaxRotationRate]]
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerColonyHandlerHeadCassetteHolderQTests*)


validModelContainerColonyHandlerHeadCassetteHolderQTests[packet:PacketP[Model[Container,ColonyHandlerHeadCassetteHolder]]]:={};


(* ::Subsection::Closed:: *)
(*validModelContainerCuvetteQTests*)


validModelContainerCuvetteQTests[packet:PacketP[Model[Container,Cuvette]]]:={

	NotNullFieldTest[packet,{
			PathLength,
			Material,
			WallType,
			MinVolume,
			MaxVolume,
			MinRecommendedWavelength,
			MaxRecommendedWavelength,
			InternalDepth,
			Scale,
			PreferredCamera,
			ImageFile
		}
	],

	FieldComparisonTest[packet,{MinVolume,MaxVolume},LessEqual],
	Test["Either both indexes in InternalDimensions are informed, InternalDiameter is informed, or both InternalDimensions and InternalDiameter are informed:",
		Lookup[packet,{InternalDimensions, InternalDiameter}],
		{NullP,Except[NullP]}|{{Except[NullP],Except[NullP]},_}],

	Test["The width and depth of InternalDimensions are equal to the InternalDiameter if both are informed:",
		If[MatchQ[{Lookup[packet,InternalDimensions],Lookup[packet,InternalDiameter]},{Except[Null],Except[Null]}],
			Module[{internalDimensions,internalDiameter},
				internalDimensions=Lookup[packet,InternalDimensions];
				internalDiameter = Lookup[packet,InternalDiameter];
				And[
					MatchQ[internalDimensions[[1]],internalDiameter],
					MatchQ[internalDimensions[[2]],internalDiameter]
				]
			],
			True],
		True
	],

	Test["PathLength is equal to depth (InternalDimensions[[2]]) or InternalDiameter:",
		Module[{internalDimensions,pathLength,internalDiameter,internalDimensionDepth},
			internalDimensions=Lookup[packet,InternalDimensions];
			internalDimensionDepth = If[MatchQ[internalDimensions,Null],Null,internalDimensions[[2]]];
			pathLength=Lookup[packet,PathLength];
			internalDiameter = Lookup[packet,InternalDiameter];
			Or[
				MatchQ[pathLength,internalDimensionDepth],
				MatchQ[pathLength,internalDiameter]
			]
		],
		True
	],

	FieldComparisonTest[packet,{MinVolume,MaxVolume},LessEqual],
	FieldComparisonTest[packet,{MinRecommendedWavelength,MaxRecommendedWavelength},Less]
};


(* ::Subsection:: *)
(*validModelContainerDeckQTests*)


validModelContainerDeckQTests[packet:PacketP[Model[Container,Deck]]]:={
(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}],

	Test["If LiquidHandlerPositionIDs is populated, each member of Positions is represented:",
		Module[{positionIDs,positions},
			{positionIDs,positions}=Lookup[packet,{LiquidHandlerPositionIDs,Positions}];
			If[MatchQ[positionIDs,{}],
				True,
				MatchQ[Complement[(Name/.#&)/@positions,positionIDs[[All,1]]],{}]
			]
		],
		True
	],
	Test["If LiquidHandlerPositionTracks is populated, each member of Positions is represented:",
		Module[{positionIDs,positions},
			{positionIDs,positions}=Lookup[packet,{LiquidHandlerPositionTracks,Positions}];
			If[MatchQ[positionIDs,{}],
				True,
				MatchQ[Complement[(Name/.#&)/@positions,positionIDs[[All,1]]],{}]
			]
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerDosingHeadQTests*)


validModelContainerDosingHeadQTests[packet:PacketP[Model[Container,DosingHead]]]:={
	(* null shared fields *)
	NullFieldTest[packet, {
		PreferredBalance,
		Ampoule,
		Hermetic
	}],

	(* not null unique fields *)
	NotNullFieldTest[packet,{
		MinDosingQuantity,
		PreferredMaxDosingQuantity,
		ImageFile,
		MaxVolume
	}],

	Test["There is a single position defined for the modelContainer:",
		Length[DeleteCases[Lookup[packet,Positions],NullP]],
		1
	],

	Test["The single position defined is named A1:",
		Name /.FirstOrDefault[Lookup[packet,Positions]/. NullP->{Name->None}],
		"A1"
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerElectricalPanelQTests*)


validModelContainerElectricalPanelQTests[packet:PacketP[Model[Container,ElectricalPanel]]]:={
	(* Shared fields *)

	(* Unique fields *)
	NotNullFieldTest[packet,{
		MaxSinglePoleVoltage,
		MaxMultiPoleVoltage,
		MaxCurrent,
		TotalNumberOfSpaces
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerEnclosureQTests*)


validModelContainerEnclosureQTests[packet:PacketP[Model[Container,Enclosure]]]:={
	(* Shared fields *)

	(* Unique fields *)
	NotNullFieldTest[packet,{Vented,Opaque}],
	NullFieldTest[packet, {
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerEnvelopeQTests*)


validModelContainerEnvelopeQTests[packet:PacketP[Model[Container,Envelope]]]:={
	(* Shared fields *)

	(* Unique fields *)
	NotNullFieldTest[packet,
		{
			InternalDimensions,
			ContainerMaterials
		}
	],
	NullFieldTest[packet,
		{
			CleaningMethod,
			MinVolume,
			MaxVolume,
			PreferredBalance,
			Ampoule,
			Hermetic
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerFlammableCabinetQTests*)


validModelContainerFlammableCabinetQTests[packet:PacketP[Model[Container,FlammableCabinet]]]:={

	(* Safety fields filled in *)
	NotNullFieldTest[packet,{
		VolumeCapacity,
		FireRating,
		FlowRate,
		AutomaticDoorClose,
		Certifications
	}],
	NullFieldTest[packet, {
		MinVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerFiberSampleHolderQTests*)


validModelContainerFiberSampleHolderQTests[packet:PacketP[Model[Container,FiberSampleHolder]]]:={
	NotNullFieldTest[packet,{
		SupportedInstruments
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerFloorQTests*)


validModelContainerFloorQTests[packet:PacketP[Model[Container,Floor]]]:={
	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};



(* ::Subsection::Closed:: *)
(*validModelContainerFloatingRackQTests*)


validModelContainerFloatingRackQTests[packet:PacketP[Model[Container,FloatingRack]]]:={
	(* Shared Fields which should be null *)
	NotNullFieldTest[packet, {
		MinTemperature,
		MaxTemperature,
		NumberOfSlots,
		RackThickness,
		SlotDiameter
	}],
	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};



(* ::Subsection::Closed:: *)
(*validModelContainerGasCylinderQTests*)


validModelContainerGasCylinderQTests[packet:PacketP[Model[Container,GasCylinder]]]:={
	(* Fields which should be null *)

	(* Unique fields *)
	NotNullFieldTest[packet, {MaxCapacity,MaxPressure,LiquidLevelGauge}],

	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerGraduatedCylinderQTests*)


validModelContainerGraduatedCylinderQTests[packet:PacketP[Model[Container,GraduatedCylinder]]]:={

	(* Shared Fields which should NOT be null *)
	NotNullFieldTest[packet,{
		ImageFile,
		MinVolume,
		MaxVolume,
		Resolution,
		PreferredCamera,
		Graduations,
		GraduationTypes
	}],

	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		Ampoule,
		Hermetic
	}],

	FieldComparisonTest[packet,{MinVolume,MaxVolume},LessEqual],

	Test["Graduations are listed from the smallest marking:",
		{Lookup[packet,Graduations],MatchQ[Lookup[packet,Graduations],Sort[Lookup[packet,Graduations]]]},
		{{___},True}
	],
	Test["The first index of Graduations equals the MinVolume:",
		{{Lookup[packet,Graduations][[1]], Lookup[packet, MinVolume]}, EqualQ[Lookup[packet,Graduations][[1]],Lookup[packet, MinVolume]]},
		{{___},True}
	],
	Test["The last index of Graduations equals the MaxVolume:",
		{{Lookup[packet,Graduations][[-1]], Lookup[packet, MaxVolume]}, EqualQ[Lookup[packet,Graduations][[-1]],Lookup[packet, MaxVolume]]},
		{{___},True}
	],
	Test[
		"GraduatedCylinder should has RentByDefault set as True:",
		MatchQ[Lookup[packet,RentByDefault],True],
		True
	]
};

(* ::Subsection::Closed:: *)
(*validModelContainerGrinderTubeHolderQTests*)


validModelContainerGrinderTubeHolderQTests[packet:PacketP[Model[Container, GrinderTubeHolder]]]:= {

	(* Fields which should NOT be null *)
	NotNullFieldTest[packet, {
		(* Shared *)
		ImageFile,
		(* Specific *)
		SupportedInstruments
	}]
};


	validModelContainerGrindingContainerQTests[packet:PacketP[Model[Container, GrindingContainer]]]:= {

		(* Fields which should NOT be null *)
		NotNullFieldTest[packet, {
			(* Shared *)
			ImageFile,
			MaxVolume,
			(* Specific *)
			SupportedInstruments
		}],

	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		Ampoule,
		Hermetic
	}],

	Test["If MinVolume is informed, it should be less than or equal to MaxVolume:",
		If[
			!NullQ[Lookup[packet, MinVolume]],
			LessEqualQ[Lookup[packet, MinVolume], Lookup[packet, MaxVolume]],
			True
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerHemocytometerQTests*)


validModelContainerHemocytometerQTests[packet:PacketP[Model[Container,Hemocytometer]]]:={

	(* Shared Fields which should NOT be null *)
	NotNullFieldTest[packet,{
		Reusable,
		MinVolume,
		MaxVolume
	}],

	(* Unique fields *)
	NotNullFieldTest[packet,{
		RecommendedFillVolume,
		ChamberDimensions,
		ChamberDepth,
		NumberOfChambers,
		GridDimensions,
		GridVolume,
		GridColumns,
		NumberOfGrids,
		GridPositions,
		GridPositionPlotting
	}],

	(* Shared Fields which should be null *)
	NullFieldTest[packet,{
		CleaningMethod,
		PreferredBalance,
		Ampoule,
		Hermetic,
		PreferredWashBin,
		PreferredMixer,
		DisposableCaps
	}],

	(* Minimums and maximums *)
	FieldComparisonTest[packet,{MinVolume,RecommendedFillVolume,MaxVolume},LessEqual],

	(* fields required together *)
	RequiredTogetherTest[packet,{PreferredMicroscope,PreferredObjectiveMagnification}],

	(* additional tests to perform if PlateFootprintAdapters is populated *)
	If[MatchQ[Lookup[packet,PlateFootprintAdapters],{}],
		Nothing,
		Module[{adapterPackets,adapterFootprint,adapterPositions,slideFootprintExistQs,footprintTest,positionTest},

			(* download the adapter footprints and positions *)
			adapterPackets=Download[Lookup[packet,PlateFootprintAdapters],Packet[Footprint,Positions]];

			(* get the adapter footprints and positions *)
			adapterFootprint=Lookup[adapterPackets,Footprint];
			adapterPositions=Lookup[adapterPackets,Positions];

			(* check if there's any position with MicroscopeSlide footprint in each adapter *)
			slideFootprintExistQs=MemberQ[Lookup[#,Footprint],MicroscopeSlide]&/@adapterPositions;

			(* if PlateFootprintAdapters is populated, all models must have plate footprint *)
			footprintTest=Test["Each member of PlateFootprintAdapters must have a Plate footprint:",
				Cases[adapterFootprint,Except[Plate]],
				{}
			];

			(* if PlateFootprintAdapters is populated, all models must have positions that accept MicroscopeSlide *)
			positionTest=Test["Each member of PlateFootprintAdapters must have positions that accept MicroscopeSlide:",
				And@@slideFootprintExistQs,
				True
			];

			(* return our tests *)
			{footprintTest,positionTest}
		]
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerJunctionBoxQTests*)


validModelContainerJunctionBoxQTests[packet:PacketP[Model[Container,JunctionBox]]]:={

};


(* ::Subsection::Closed:: *)
(*validModelContainerMagazineRackQTests*)


validModelContainerMagazineRackQTests[packet:PacketP[Model[Container,MagazineRack]]]:= {

	NullFieldTest[packet, {
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]

};


(* ::Subsection::Closed:: *)
(*validModelContainerPhaseSeparatorQTests*)


validModelContainerPhaseSeparatorQTests[packet:PacketP[Model[Container,PhaseSeparator]]]:= {

	NotNullFieldTest[packet, {
		CartridgeWorkingVolume,
		Tabbed,
		MaxRetentionTime,
		ContainerMaterials
	}]

};


(* ::Subsection::Closed:: *)
(*validModelContainerPlateSealMagazineQTests*)


validModelContainerPlateSealMagazineQTests[packet:PacketP[Model[Container,PlateSealMagazine]]]:= {

	NullFieldTest[packet, {
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]

};


(* ::Subsection::Closed:: *)
(*validModelContainerMicrofluidicChipQTests*)


validModelContainerMicrofluidicChipQTests[packet:PacketP[Model[Container,MicrofluidicChip]]]:={
	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		PreferredBalance,
		Ampoule,
		Hermetic,
		PreferredWashBin,
		PreferredMixer,
		DisposableCaps
	}]
};



(* ::Subsection::Closed:: *)
(*validModelContainerNMRSpinnerQTests*)


validModelContainerNMRSpinnerQTests[packet:PacketP[Model[Container,NMRSpinner]]]:={

	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		PreferredBalance,
		Ampoule,
		Hermetic,
		PreferredWashBin,
		PreferredMixer,
		DisposableCaps
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerMicroscopeSlideQTests*)


validModelContainerMicroscopeSlideQTests[packet:PacketP[Model[Container,MicroscopeSlide]]]:={

	(* Shared Fields which should NOT be null *)
	NotNullFieldTest[packet,{
		Reusable
	}],

	(* Shared Fields which should be null *)
	NullFieldTest[packet,{
		CleaningMethod,
		PreferredBalance,
		Ampoule,
		Hermetic,
		PreferredWashBin,
		PreferredMixer,
		DisposableCaps
	}],

	(* additional tests to perform if PlateFootprintAdapters is populated *)
	If[MatchQ[Lookup[packet,PlateFootprintAdapters],{}],
		Nothing,
		Module[{adapterPackets,adapterFootprint,adapterPositions,slideFootprintExistQs,footprintTest,positionTest},

			(* download the adapter footprints and positions *)
			adapterPackets=Download[Lookup[packet,PlateFootprintAdapters],Packet[Footprint,Positions]];

			(* get the adapter footprints and positions *)
			adapterFootprint=Lookup[adapterPackets,Footprint];
			adapterPositions=Lookup[adapterPackets,Positions];

			(* check if there's any position with MicroscopeSlide footprint in each adapter *)
			slideFootprintExistQs=MemberQ[Lookup[#,Footprint],MicroscopeSlide]&/@adapterPositions;

			(* if PlateFootprintAdapters is populated, all models must have plate footprint *)
			footprintTest=Test["Each member of PlateFootprintAdapters must have a Plate footprint:",
				Cases[adapterFootprint,Except[Plate]],
				{}
			];

			(* if PlateFootprintAdapters is populated, all models must have positions that accept MicroscopeSlide *)
			positionTest=Test["Each member of PlateFootprintAdapters must have positions that accept MicroscopeSlide:",
				And@@slideFootprintExistQs,
				True
			];

			(* return our tests *)
			{footprintTest,positionTest}
		]
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerOperatorCartQTests*)


validModelContainerOperatorCartQTests[packet:PacketP[Model[Container,OperatorCart]]]:={
	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerPlateQTests*)


validModelContainerPlateQTests[packet:PacketP[Model[Container,Plate]]]:=Module[{liquidHandlerAdapterPacket},
	liquidHandlerAdapterPacket=Quiet[Download[packet,Packet[LiquidHandlerAdapter[Positions]]]];
	If[MatchQ[Lookup[packet,Type],Except[Model[Container,Plate,Irregular] | Model[Container,Plate,Irregular,CapillaryELISA] | Model[Container,Plate,Irregular,Crystallization]]],

		(* For all plates that are not Irregular Plates *)
		(* Shared fields *)
		{
			NotNullFieldTest[packet,{
				ImageFile,
				PlateColor,
				WellColor,
				Treatment,
				Rows,Columns,
				NumberOfWells,
				AspectRatio,
				HorizontalMargin,
				VerticalMargin,
				DepthMargin,
				WellDepth,
				WellBottom,
				MaxVolume,
				MinVolume,
				HorizontalOffset,
				VerticalOffset
			}],

			(* Shared fields shaping *)

			(* Well dimensions: *)
			Test["If and only if Columns is greater than 1, HorizontalPitch is informed:",
				Lookup[packet,{Columns,HorizontalPitch}],
				{GreaterP[1],Except[NullP]} | {Except[GreaterP[1]],NullP}
			],

			Test["If and only if Rows is greater than 1, VerticalPitch is informed:",
				Lookup[packet,{Rows,VerticalPitch}],
				{GreaterP[1],Except[NullP]} | {Except[GreaterP[1]],NullP}
			],

			Test["Either the two indexes in WellDimensions are informed, or WellDiameter is informed:",
				Lookup[packet,{WellDimensions,WellDiameter}],
				{NullP,Except[NullP]} |
					{{Except[NullP],Except[NullP]},NullP}
			],

			Test["If and only if WellBottom is RoundBottom or VBottom, ConicalWellDepth is informed:",
				Lookup[packet,{WellBottom,ConicalWellDepth}],
				{RoundBottom | VBottom,Except[NullP]} | {Except[RoundBottom | VBottom],NullP}
			],

			Test["Columns * Rows equals NumberOfWells:",
				Times@@Lookup[packet,{Rows,Columns}],
				Lookup[packet,NumberOfWells]
			],
			Test["Columns/Rows  equals AspectRatio:",
				Lookup[packet,AspectRatio],
				_?(Equal[#,Divide@@Lookup[packet,{Columns,Rows} ]]&)
			],

			Test["If NumberOfWells is >=48, then PreferredCamera should be populated:",
				Lookup[packet,{NumberOfWells,PreferredCamera}],
				Alternatives[
					{GreaterEqualP[48],Plate},
					{_,_}
				]
			],

			Test["If LiquidHandlerAdapter is populated, it should have a Plate Slot:",
				If[MatchQ[Lookup[packet,LiquidHandlerAdapter],ObjectP[]],
					MemberQ[Lookup[Lookup[liquidHandlerAdapterPacket,Positions],Name],"Plate Slot"],
					True
				],
				True
			],

			(*
			TODO turn this on once we have re-parametrized all plates used in the lab
			Test["The thickness of the well bottom is positive: ",
				Lookup[packet,Dimensions][[3]] - Lookup[packet,WellDepth] - Lookup[packet,DepthMargin],
				GreaterP[0Millimeter]
			],*)

			Test["If BottomCavity3D is populated, all entries lie withing the Dimensions of the Container:",
				If[MatchQ[Lookup[packet,BottomCavity3D],Except[Null | {}]],
					Module[{xDim,yDim,zDim},
						{xDim,yDim,zDim}=Lookup[packet,Dimensions];
						MatchQ[
							Lookup[packet,BottomCavity3D],
							{{RangeP[0Millimeter,xDim],RangeP[0Millimeter,yDim],RangeP[0Millimeter,zDim]}..}
						]],
					True
				],
				True
			],

			(* Minimums and maximums *)
			FieldComparisonTest[packet,{MinVolume,RecommendedFillVolume,MaxVolume},LessEqual]
		},

		(* For Model[Container,Plate,Irregular] *)
		{
			NotNullFieldTest[packet,{
				ImageFile,
				PlateColor,
				WellColor,
				NumberOfWells,
				HorizontalMargin,
				VerticalMargin,
				DepthMargin,
				WellDepth,
				WellBottom,
				MaxVolume,
				MinVolume
			}],

			(* Minimums and maximums *)
			FieldComparisonTest[packet,{MinVolume,MaxVolume},LessEqual],

			Test["If LiquidHandlerAdapter is populated, it should have a Plate Slot:",
				If[MatchQ[Lookup[packet,LiquidHandlerAdapter],ObjectP[]],
					MemberQ[Lookup[Lookup[liquidHandlerAdapterPacket,Positions],Name],"Plate Slot"],
					True
				],
				True
			],

			Test["If BottomCavity3D is populated, all entries lie withing the Dimensions of the Container:",
				If[MatchQ[Lookup[packet,BottomCavity3D],Except[Null | {}]],
					Module[{xDim,yDim,zDim},
						{xDim,yDim,zDim}=Lookup[packet,Dimensions];
						MatchQ[
							Lookup[packet,BottomCavity3D],
							{{RangeP[0Millimeter,xDim],RangeP[0Millimeter,yDim],RangeP[0Millimeter,zDim]}..}
						]],
					True
				],
				True
			],

			(* Require flange-related fields together *)
			RequiredTogetherTest[packet,{FlangeHeight,FlangeWidth}]
		}
	]];


(* ::Subsection::Closed:: *)
(*validModelContainerPlateDropletCartridgeQTests*)


validModelContainerPlateDropletCartridgeQTests[packet:PacketP[Model[Container,Plate,DropletCartridge]]]:={

	NotNullFieldTest[packet,
		{
			DropletsFromSampleVolume,
			AverageDropletVolume
		}
	]

};


(* ::Subsubsection::Closed:: *)
(*validModelContainerPlateIrregularArrayCardQTests*)


validModelContainerPlateIrregularArrayCardQTests[packet:PacketP[Model[Container,Plate,Irregular,ArrayCard]]]:={

	NotNullFieldTest[packet,{
		ForwardPrimers,
		ReversePrimers,
		Probes
	}]

};


(* ::Subsection::Closed:: *)
(*validModelContainerPlateIrregularCapillaryELISAQTests*)


validModelContainerPlateIrregularCapillaryELISAQTests[packet:PacketP[Model[Container,Plate,Irregular,CapillaryELISA]]]:={

	(* Null Shared Fields *)
	NullFieldTest[packet,{
		CleaningMethod,
		Ampoule,
		Hermetic
	}],

	(* Not Null Shared Fields *)
	NotNullFieldTest[packet,{
		Expires,
		Reusable
	}],

	(* Not Null Unique Fields*)
	NotNullFieldTest[packet,{
		MaxNumberOfSamples,
		CartridgeType,
		NumberOfReplicates,
		WellContents,
		MinBufferVolume
	}],

	(* MinBufferVolume must match the type of the cartridge *)
	Test["MinBufferVolume must match CartridgeType:",
		Lookup[packet,{CartridgeType,MinBufferVolume}],
		{SinglePlex72X1,10.0Milliliter}|{MultiAnalyte32X4,16.0Milliliter}|{MultiAnalyte16X4,8.0Milliliter}|{MultiPlex32X8,16.0Milliliter}|{Customizable,6.0Milliliter}
	],

	(* Depending on the CartridgeType, information about Analytes should be populated or Null. *)
	If[MatchQ[Lookup[packet,CartridgeType],Customizable],

		NullFieldTest[packet,{
			AnalyteNames,
			AnalyteMolecules
		}],

		NotNullFieldTest[packet,{
			AnalyteNames,
			AnalyteMolecules
		}]
	],

	(* AnalyteNames and AnalyteMolecules should match each other - they can be Null when one or more channels of a multi-analyte or multiplex cartridge is empty *)
	Test["AnalyteNames should match AnalyteMolecules:",
		And@@(
			MapThread[
				Module[
					{analyteManuSpec,analyteMoleculeIDFromManuSpec,validAnalyteMoleculeQ},
					analyteManuSpec=Search[Object[ManufacturingSpecification,CapillaryELISACartridge],AnalyteName==#1];
					analyteMoleculeIDFromManuSpec=If[MatchQ[analyteManuSpec,{}],
						Null,
						FirstOrDefault[analyteManuSpec[AnalyteMolecule][ID]]
					];
					validAnalyteMoleculeQ=If[MatchQ[analyteMoleculeIDFromManuSpec,Null],
						MatchQ[#2,Null],
						MatchQ[analyteMoleculeIDFromManuSpec,#2[ID]]
					]
				]&,
				{packet[AnalyteNames],packet[AnalyteMolecules]}
			]
		),
		True
	]

};



(* ::Subsubsection::Closed:: *)
(*validModelContainerPlateIrregularCrystallizationQTests*)

validModelContainerPlateIrregularCrystallizationQTests[packet:PacketP[Model[Container, Plate, Irregular,Crystallization]]] :={
	NullFieldTest[packet,{
		CleaningMethod,
		Ampoule,
		Hermetic
	}],
	NotNullFieldTest[packet, {
		CompatibleCrystallizationTechniques,
		LabeledColumns,
		LabeledRows,
		WellContents
	}],
	Test["Labeled Columns * Labeled Rows the number of individual Wells or HeadspaceSharingWells:",
		If[!NullQ[Lookup[packet, HeadspaceSharingWells]],
			Length[packet[HeadspaceSharingWells]]===packet[LabeledColumns]*packet[LabeledRows],
			Lookup[packet, NumberOfWells]===packet[LabeledColumns]*packet[LabeledRows]
		],
		True
	]
};


(* ::Subsubsection::Closed:: *)
(*validModelContainerPlateIrregularRamanQTests*)


validModelContainerPlateIrregularRamanQTests[packet:PacketP[Model[Container, Plate, Irregular, Raman]]] :={

	(*Shared fields*)
	NotNullFieldTest[packet, {
		WellWindowDimensions
	}],

	NullFieldTest[packet, {
		MaxCentrifugationForce,
		VacuumCentrifugeCompatibility
	}]
};



(* ::Subsubsection::Closed:: *)
(*validModelContainerPlateCapillaryStripQTests*)


validModelContainerPlateCapillaryStripQTests[packet:PacketP[Model[Container, Plate, CapillaryStrip]]] :={

	(*Shared fields*)
	NotNullFieldTest[packet, {
		Reusable,
		RecommendedFillVolume
	}],

	NullFieldTest[packet, {
		MaxCentrifugationForce,
		VacuumCentrifugeCompatibility
	}]
};


(* ::Subsubsection::Closed:: *)
(*validModelContainerPlateFilterQTests*)


validModelContainerPlateFilterQTests[packet:PacketP[Model[Container,Plate,Filter]]]:={

	(* Shared fields *)
	NotNullFieldTest[packet,{
		MembraneMaterial,
		MinVolume,
		MaxVolume
	}],

	UniquelyInformedTest[packet,{PoreSize,MolecularWeightCutoff}],

	FieldComparisonTest[packet,{MinVolume,MaxVolume},LessEqual],

	NullFieldTest[packet, {
		CleaningMethod,
		Ampoule,
		Hermetic
	}]
};



(* ::Subsection::Closed:: *)
(*validModelContainerPlateDialysisQTests*)


validModelContainerPlateDialysisQTests[packet:PacketP[Model[Container,Plate,Dialysis]]]:={

	NotNullFieldTest[packet,{
		MolecularWeightCutoff
	}]

};



(* ::Subsubsection:: *)
(*validModelContainerPlateFilterQTests*)

validModelContainerPlateFilterQTests[packet:PacketP[Model[Container,Plate,Filter]]]:={

	Test["If StorageBuffer -> True, then StorageBufferVolume must be populated:",
		If[TrueQ[Lookup[packet, StorageBuffer]],
			VolumeQ[Lookup[packet, StorageBufferVolume]],
			True
		],
		True
	]
};

(* ::Subsection::Closed:: *)
(*validModelContainerPlateIrregularQTests*)


validModelContainerPlateIrregularQTests[packet:PacketP[Model[Container,Plate,Irregular]]]:={

	(* Shared fields *)
	NotNullFieldTest[packet,{
		WellColors,
		WellTreatments,
		WellDepths,
		WellBottoms,
		MinVolumes,
		MaxVolumes,
		RecommendedFillVolumes
	}],

	Test["For every single well, minimum volume is less than or equal to recommended fill volume and recommended fill volume is less than or equal to maximum volume",
		And @@ MapThread[LessEqual[#1,#2,#3]&,{packet[MinVolumes],packet[RecommendedFillVolumes],packet[MaxVolumes]}],
		True
	]
};



(* ::Subsection::Closed:: *)
(*validModelContainerPortableCoolerQTests*)


validModelContainerPortableCoolerQTests[packet:PacketP[Model[Container,PortableCooler]]]:={

	NotNullFieldTest[packet, {NominalTemperature,MinIncubationTemperature,MaxIncubationTemperature}],

	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}],

	(* Minimums and maximums *)
	FieldComparisonTest[packet,{MinIncubationTemperature,NominalTemperature,MaxIncubationTemperature},LessEqual]

};


(* ::Subsection::Closed:: *)
(*validModelContainerPortableHeaterQTests*)


validModelContainerPortableHeaterQTests[packet:PacketP[Model[Container,PortableHeater]]]:={

	NotNullFieldTest[packet, {NominalTemperature,MinIncubationTemperature,MaxIncubationTemperature}],

	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}],

	(* Minimums and maximums *)
	FieldComparisonTest[packet,{MinIncubationTemperature,NominalTemperature,MaxIncubationTemperature},LessEqual]

};


(* ::Subsection::Closed:: *)
(*validModelContainerRackQTests*)


validModelContainerRackQTests[packet:PacketP[Model[Container,Rack]]]:={

	RequiredTogetherTest[packet,{Rows,Columns}],
	NotNullFieldTest[packet,{
		NumberOfPositions,
		HorizontalOffset,
		VerticalOffset,
		Footprint
	}],
	NullFieldTest[packet, {
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}],

(* Well dimensions: *)
	Test["If and only if Columns is greater than 1, HorizontalPitch and HorizontalMargin are informed:",
		Lookup[packet,{Columns,HorizontalPitch,HorizontalMargin}],
		{GreaterP[1],Except[NullP],Except[NullP]}|{Except[GreaterP[1]],_,_}
	],

	Test["If and only if Rows is greater than 1, VerticalPitch and VerticalMargin area informed:",
		Lookup[packet,{Rows,VerticalPitch,VerticalMargin}],
		{GreaterP[1],Except[NullP],Except[NullP]}|{Except[GreaterP[1]],_,_}
	],

	Test["Either the two indexes in WellDimensions are informed, or WellDiameter is informed:",
		Lookup[packet,{WellDimensions,WellDiameter}],
		{NullP,Except[NullP]}|{{Except[NullP],Except[NullP]},NullP}
	],

	Test["NumberOfPositions matches the number of positions specified in Positions:",
		Lookup[packet,NumberOfPositions],
		Length[Lookup[packet,Positions]]
	];

	Test["If both Rows and Columns are non-Null, then AspectRatio must be informed and must be equal to Columns/Rows. Otherwise, AspectRatio cannot be informed:",
		Lookup[packet,{Rows,Columns,AspectRatio}],
		Alternatives[
			{Except[NullP],Except[NullP],_?(Equal[Rationalize[#],Divide @@ Lookup[packet, {Columns, Rows} ]]&)},
			{NullP,NullP,NullP}
		]
	],

	Test["If both Rows and Columns are non-Null, then NumberOfPositions must be equal to Rows*Columns:",
		Lookup[packet,{Rows,Columns,NumberOfPositions}],
		Alternatives[
			{Except[NullP],Except[NullP],Times@@Lookup[packet, {Rows, Columns}]},
			{NullP,NullP,Except[NullP]}
		]
	],

	Test["If LiquidHandlerPositionIDs is populated, each member of Positions is represented:",
		Module[{positionIDs,positions},
			{positionIDs,positions}=Lookup[packet,{LiquidHandlerPositionIDs,Positions}];
			If[MatchQ[positionIDs,{}],
				True,
				MatchQ[Complement[(Name/.#&)/@positions,positionIDs[[All,1]]],{}]
			]
		],
		True
	],

	Test["If BottomSupport3D is populated, all members should be in Positions:",
		If[MatchQ[Lookup[packet,BottomSupport3D],Except[Null | {}]],
			MatchQ[
				Complement[
					Lookup[Lookup[packet,BottomSupport3D],Name],
					Lookup[Lookup[packet,Positions],Name]
				],
				{}
			],
			True
		],
		True
	],

	Test["If BottomSupport3D is populated, all entries lie withing the Dimensions of the Container:",
		If[MatchQ[Lookup[packet,BottomSupport3D],Except[Null | {}]],
			Module[{xDim,yDim,zDim},
				{xDim,yDim,zDim}=Lookup[packet,Dimensions];
				AllTrue[
					Lookup[Lookup[packet,BottomSupport3D],Dimensions],
					MatchQ[{{RangeP[0Millimeter,xDim],RangeP[0Millimeter,yDim],RangeP[0Millimeter,zDim]}..}]
				]
			],
			True
		],
		True
	],

	Test["If BottomCavity3D is populated, all entries lie withing the Dimensions of the Container:",
		If[MatchQ[Lookup[packet,BottomCavity3D],Except[Null | {}]],
			Module[{xDim,yDim,zDim},
				{xDim,yDim,zDim}=Lookup[packet,Dimensions];
				MatchQ[
					Lookup[packet,BottomCavity3D],
					{{RangeP[0Millimeter,xDim],RangeP[0Millimeter,yDim],RangeP[0Millimeter,zDim]}..}
				]],
			True
		],
		True
	],

	Test["If the rack model has PermanentStorage -> False, any Object[StorageAvailability]s associated with its objects must not have a status that renders them findable:",
		If[MatchQ[Lookup[packet, PermanentStorage], False],
			MatchQ[
				Flatten[Download[Lookup[packet, Objects], StorageAvailability[[All,2]][Status]]],
				{(Inactive|Discarded|InUse)...}
			],
			True
		],
		True
	]
};



(* ::Subsection::Closed:: *)
(*validModelContainerProteinCapillaryElectrophoresisCartridgeQTests*)


validModelContainerProteinCapillaryElectrophoresisCartridgeQTests[packet:PacketP[Model[Container, ProteinCapillaryElectrophoresisCartridge]]]:={

	(* Shared fields *)
	NotNullFieldTest[packet,{
		MaxNumberOfUses,
		ExperimentType,
		CapillaryLength,
		CapillaryDiameter,
		Footprint,
		Positions
	}]
};



(* ::Subsection::Closed:: *)
(*validModelContainerProteinCapillaryElectrophoresisCartridgeInsertQTests*)


validModelContainerProteinCapillaryElectrophoresisCartridgeInsertQTests[packet:PacketP[Model[Container, ProteinCapillaryElectrophoresisCartridgeInsert]]]:={
	(* Shared fields *)
	NotNullFieldTest[packet,{
		Footprint,
		Positions
	}]
};



(* ::Subsubsection::Closed:: *)
(*validModelContainerRackDishwasherQTests*)


validModelContainerRackDishwasherQTests[packet:PacketP[Model[Container,Rack,Dishwasher]]]:={

	NullFieldTest[packet,CleaningMethod],
	NotNullFieldTest[packet,{RackType,BaseHeight}],

	Test["If RackType is Active then NumberOfPositions should be informed:",
		Lookup[packet,{RackType,NumberOfPositions}],
		Alternatives[
			{Active,Except[Null]},
			{Passive,_}
		]
	]
};




(* ::Subsubsection::Closed:: *)
(*validModelContainerRackInsulatedCoolerQTests*)


validModelContainerRackInsulatedCoolerQTests[packet:PacketP[Model[Container,Rack,InsulatedCooler]]]:={

	NotNullFieldTest[packet,{
		DefaultContainer
	}]
};







(* ::Subsection::Closed:: *)
(*validModelContainerReactionVesselQTests*)


validModelContainerReactionVesselQTests[packet:PacketP[Model[Container,ReactionVessel]]]:={

	(* Shared Fields which should not be null *)
	NotNullFieldTest[packet, {
		MaxVolume,
		SelfStanding,
		PreferredCamera,
		ImageFile
	}],

	FieldComparisonTest[packet,{MinPressure,MaxPressure},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelContainerReactionVesselMicrowaveQTests*)


validModelContainerReactionVesselMicrowaveQTests[packet:PacketP[Model[Container,ReactionVessel, Microwave]]]:={

	(* Shared Fields which should not be null *)
	NotNullFieldTest[packet, {
		CleaningMethod
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerReactionVesselSolidPhaseSynthesisQTests*)


validModelContainerReactionVesselSolidPhaseSynthesisQTests[packet:PacketP[Model[Container,ReactionVessel,SolidPhaseSynthesis]]]:={
	(* Shared Fields which should be null *)
	NullFieldTest[packet, {CleaningMethod}],

	(* Required fields *)
	RequiredTogetherTest[packet,{InletFilterThickness,InletFilterMaterial}],
	RequiredTogetherTest[packet,{OutletFilterThickness,OutletFilterMaterial}],

	FieldComparisonTest[packet,{MaxFlowRate,MinFlowRate},GreaterEqual],
	FieldComparisonTest[packet,{MaxFlowRate,NominalFlowRate},GreaterEqual],
	FieldComparisonTest[packet,{NominalFlowRate,MinFlowRate},GreaterEqual]
};


(* ::Subsection::Closed:: *)
(*validModelContainerReactionVesselElectrochemicalSynthesisQTests*)


validModelContainerReactionVesselElectrochemicalSynthesisQTests[packet:PacketP[Model[Container,ReactionVessel,ElectrochemicalSynthesis]]]:={

	(* Shared Fields which should not be null *)
	NotNullFieldTest[packet, {
		MaxNumberOfUses,
		CleaningMethod
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerRoomQTests*)


validModelContainerRoomQTests[packet:PacketP[Model[Container,Room]]]:={
	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerSafeQTests*)


validModelContainerSafeQTests[packet:PacketP[Model[Container,Safe]]]:={
(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerShelfQTests*)


validModelContainerShelfQTests[packet:PacketP[Model[Container,Shelf]]]:={
	(* Fields which should be null *)
	NullFieldTest[packet, {
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerShelvingUnitQTests*)


validModelContainerShelvingUnitQTests[packet:PacketP[Model[Container,ShelvingUnit]]]:={
	(* Fields which should be null *)
	NullFieldTest[packet, {
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerShippingQTests*)


validModelContainerShippingQTests[packet:PacketP[Model[Container, Shipping]]]:={
(* Shared fields shaping *)
	NullFieldTest[packet,{
		CleaningMethod,
		ImageFile,
		MinVolume,
		MaxVolume,
		Ampoule,
		Hermetic
	}]
};



(* ::Subsection::Closed:: *)
(*validModelContainerSyringeQTests*)


validModelContainerSyringeQTests[packet:PacketP[Model[Container,Syringe]]]:={
	(* unique fields which should be not null *)
	NotNullFieldTest[packet,{
		BarrelMaterial,
		PlungerMaterial,
		ConnectionType,
		MinVolume,
		MaxVolume,
		Resolution,
		DeadVolume,
		PreferredCamera,
		ImageFile
	}],
	FieldComparisonTest[packet,{MinVolume,MaxVolume},LessEqual],
	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		PreferredBalance
	}],

	Test["If the syringe is LuerLock, InnerDiameter must be populated:",
		If[MatchQ[Lookup[packet, ConnectionType], LuerLock],
			Not[NullQ[Lookup[packet, InnerDiameter]]],
			True
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerSyringeToolQTests*)


validModelContainerSyringeToolQTests[packet:PacketP[Model[Container,SyringeTool]]]:={
	(* unique fields which should be not null *)
	NotNullFieldTest[packet,{
		ImageFile
	}],
	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		PreferredBalance,
		MinVolume,
		MaxVolume
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerVesselQTests*)


validModelContainerVesselQTests[packet:PacketP[Model[Container,Vessel]]]:={

	(* Not Null fields *)
	NotNullFieldTest[
		packet,
		{
			ImageFile,
			PreferredBalance,
			SelfStanding,
			MaxVolume,
			InternalBottomShape,
			PreferredCamera,
			Sterile,
			Opaque,
			Stocked
		}
	],

	(* Well dimensions: *)

	Test["For ampoule containers (i.e. Ampoule is True), BuiltInCover is False:",
		Lookup[packet,{Ampoule, BuiltInCover}],
		{True, Alternatives[False, Null]}
	],

	Test["InternalDepth is informed unless the vessel is an Ampoule or PermanentlySealed, in which case it may be Null:",
		Lookup[packet,{Ampoule, PermanentlySealed, InternalDepth}],
		{True, _, _} | {_, True, _} | {Except[True], Except[True], Except[NullP]}
	],

	Test["Either the two indexes in InternalDimensions are informed, or InternalDiameter is informed:",
		Lookup[packet,{InternalDimensions,InternalDiameter}],
		{NullP,Except[NullP]}|{{Except[NullP],Except[NullP]},NullP}
	],

	Test["Only one NeckType or TaperGroundJointSize may be informed:",
		Lookup[packet,{NeckType,TaperGroundJointSize}],
		{NullP,NullP}|{Except[NullP],NullP}|{NullP,Except[NullP]}
	],

	Test["If and only if InternalBottomShape is RoundBottom or VBottom, InternalConicalDepth is informed:",
		Lookup[packet,{InternalBottomShape,InternalConicalDepth}],
		{RoundBottom|VBottom,Except[NullP]}|{Except[RoundBottom|VBottom],NullP}
	],

	Test["There is a single position defined for the model container named \"A1\":",
		Lookup[packet,Positions],
		{AssociationMatchP[<|Name->"A1"|>,AllowForeignKeys->True]}
	],

	Test["Aperture is informed if the container is not an ampoule, permanently sealed, dropper, or Hermetic:",
		Lookup[packet,{Ampoule,Dropper,Hermetic,PermanentlySealed,Aperture}],
		Alternatives[
			{True,_,_,_,_},
			{_,True,_,_,_},
			{_,_,True,_,_},
			{_,_,_,True,_},
			{Except[True],Except[True],Except[True],Except[True],Except[Null]}
		]
	],

	Test["If Graduations is informed, they are listed from the smallest marking:",
		{Lookup[packet,Graduations],MatchQ[Lookup[packet,Graduations],Sort[Lookup[packet,Graduations]]]},
		{{___},True}
	],

	Test["If the container is a sterile vessel and washable then its PreferredAutoclaveBin is populated:",
		If[MatchQ[Lookup[packet,Object],Alternatives@@PreferredContainer[All,Sterile->True]]&&MatchQ[Lookup[packet,CleaningMethod],CleaningMethodP],
			!NullQ[Lookup[packet,PreferredAutoclaveBin]],
			True
		],
		True
	],

	Test["If the container has CrossSectionalShape->Circle, X and Y dimensions must be identical:",
		Lookup[packet, {CrossSectionalShape, Dimensions}],
		Alternatives[
			{Circle, {diameter_, diameter_, _}},
			{Except[Circle], _}
		]
	],

	Test["PlateImagerRack must be populated if and only if PreferredCamera or CompatibleCameras includes Plate:",
		{Append@@Lookup[packet, {CompatibleCameras, PreferredCamera}], Lookup[packet, PlateImagerRack]},
		Alternatives[
			{_?(MemberQ[#, Plate]&), Except[Null]},
			{_?(!MemberQ[#, Plate]&), Null}
		]
	]
};



(* ::Subsection::Closed:: *)
(*validModelContainerVesselDialysisQTests*)


validModelContainerVesselDialysisQTests[packet:PacketP[Model[Container,Vessel,Dialysis]]]:={

	NotNullFieldTest[packet,{
		MolecularWeightCutoff
	}]
};



(* ::Subsubsection:: *)
(**)


(* ::Subsection::Closed:: *)
(*validModelContainerVesselBufferCartridgeQTests *)


validModelContainerVesselBufferCartridgeQTests[packet:PacketP[Model[Container,Vessel,BufferCartridge]]]:={

	Test[
		"If CathodeSequencingBuffer is informed, it matches the correct buffer object type:",
		MatchQ[Lookup[packet,CathodeSequencingBuffer],Alternatives[Null,ObjectP[{Model[Sample,"DNA Sequencing Cathode Buffer"],Object[Sample,"DNA Sequencing Cathode Buffer"]}]]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerVesselCrossFlowQTests*)


validModelContainerVesselCrossFlowQTests[packet:PacketP[Model[Container,Vessel,CrossFlowContainer]]]:={

	NotNullFieldTest[packet,{
		MinVolume,
		MaxVolume,
		Connectors
	}],


	Test[
		"Object has at least three connectors with names \"Filter Outlet\", \"Detector Inlet\" and \"Diafiltration Buffer Inlet\":",
		MemberQ[Lookup[packet,Connectors][[All,1]],#]&/@{"Filter Outlet","Detector Inlet","Diafiltration Buffer Inlet"},
		{True,True,True}
	]
};



(* ::Subsection::Closed:: *)
(*validModelContainerVesselCrossFlowQTests*)


validModelWashContainerVesselCrossFlowQTests[packet:PacketP[Model[Container,Vessel,CrossFlowWashContainer]]]:={

	NotNullFieldTest[packet,{
		MinVolume,
		MaxVolume,
		Connectors
	}],


	Test[
		"Object has at least three connectors with names \"Filter Outlet\", \"Detector Inlet\" and \"Diafiltration Buffer Inlet\":",
		MemberQ[Lookup[packet,Connectors][[All,1]],#]&/@{"Filter Outlet","Detector Inlet","Diafiltration Buffer Inlet"},
		{True,True,True}
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerVesselFilterQTests*)


validModelContainerVesselFilterQTests[packet:PacketP[Model[Container,Vessel,Filter]]]:={

(* Shared fields *)
	NotNullFieldTest[packet,{
		MaxVolume,
		MembraneMaterial,
		PreferredBalance,
		FilterType
	}],

	Test["If KitComponents is not populated, only one of the fields (PoreSize, MolecularWeightCutoff) is informed:",
		If[!MatchQ[Lookup[packet, KitComponents, {}], {}],
			Count[
				!MatchQ[#, Null|{}]&/@Lookup[packet, {PoreSize,MolecularWeightCutoff}],
				True
			] == 1,
			True
		],
		True
	],

	Test["If FilterType is Centrifuge and DestinationConatinerModel is populated, the Counterweights field of the DestinationContainerModel must also be populated:",
		If[MatchQ[Lookup[packet, {FilterType, DestinationContainerModel}], {Centrifuge, Except[Null]}],
			Not[MatchQ[Download[Lookup[packet, DestinationContainerModel], Counterweights], {}]],
			True
		],
		True
	],

	Test["If StorageBuffer -> True, then StorageBufferVolume must be populated:",
		If[TrueQ[Lookup[packet, StorageBuffer]],
			VolumeQ[Lookup[packet, StorageBufferVolume]],
			True
		],
		True
	],

	NullFieldTest[packet, {
		CleaningMethod,
		Ampoule,
		Hermetic
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerVesselVolumetricFlaskQTests*)


validModelContainerVesselVolumetricFlaskQTests[packet:PacketP[Model[Container,Vessel,VolumetricFlask]]]:={
	NotNullFieldTest[packet,{
		Precision
	}],

	Test[
		"Graduations of the container is informed and only informed one value:",
		MatchQ[Lookup[packet,Graduations],{_}],
		True
	],
	Test[
		"VolumetricFlask should has RentByDefault set as True:",
		MatchQ[Lookup[packet,RentByDefault],True],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerVesselGasWashingBottleQTests*)


validModelContainerVesselGasWashingBottleQTests[packet:PacketP[Model[Container,Vessel,GasWashingBottle]]]:={
	NotNullFieldTest[packet,{
		MaxVolume,
		MaxNumberOfUses,
		InletFritted
	}],

	Test["The InletPorosity should only be informed when the InletFritted is True:",
		Module[{inletFritted, inletPorosity},
			{inletFritted, inletPorosity} = Lookup[packet, {InletFritted, InletPorosity}]
		],
		Alternatives[{True, GasWashingBottlePorosityP}, {False, Null}]
	]
};


(* ::Subsection::Closed:: *)
(*validContainerWashBathQTests*)


validContainerWashBathQTests[packet:PacketP[Model[Container,WashBath]]]:={

	(* Make sure MaxSampleVolume is populated *)
	NotNullFieldTest[packet, {MaxSampleVolume}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerWashBinQTests*)


validModelContainerWashBinQTests[packet:PacketP[Model[Container,WashBin]]]:={

	(* Shared fields shaping *)
	NullFieldTest[packet,{
		Ampoule,
		Hermetic
	}],

	NotNullFieldTest[packet, {
		CleaningType
	}]

};


(* ::Subsection::Closed:: *)
(*validModelContainerWasteBinQTests*)


validModelContainerWasteBinQTests[packet:PacketP[Model[Container,WasteBin]]]:={

	NotNullFieldTest[packet,{MaxVolume,WasteType,ContainerMaterials}],

	(* Shared Fields which should be null *)
	NullFieldTest[
		packet,
		{
			CleaningMethod,
			PreferredBalance,
			Ampoule,
			Hermetic
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerWasteQTests*)


validModelContainerWasteQTests[packet:PacketP[Model[Container,Waste]]]:={
	NullFieldTest[packet, {
		CleaningMethod,
		ImageFile,
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}],
	NotNullFieldTest[packet,WasteType]

};


(* ::Subsection::Closed:: *)
(*validModelContainerBoxQTests*)


validModelContainerBoxQTests[packet:PacketP[Model[Container,Box]]]:= {

	NotNullFieldTest[packet, {
		InternalDimensions,
		ContainerMaterials
	}
	]
};



(* ::Subsection::Closed:: *)
(*validModelContainerLightBoxQTests*)


validModelContainerLightBoxQTests[packet:PacketP[Model[Container,LightBox]]]:= {

};


(* ::Subsection::Closed:: *)
(*validModelContainerBumpTrapQTests*)


validModelContainerBumpTrapQTests[packet:PacketP[Model[Container,BumpTrap]]]:={

	(* Not Null fields *)
	NotNullFieldTest[
		packet,
		{
			ImageFile,
			MaxVolume,
			Sterile,
			Opaque,
			Stocked,
			InternalDepth,
			Aperture
		}
	],

	(* Well dimensions: *)

	Test["Either the two indexes in InternalDimensions are informed, or InternalDiameter is informed:",
		Lookup[packet,{InternalDimensions,InternalDiameter}],
		{NullP,Except[NullP]}|{{Except[NullP],Except[NullP]},NullP}
	],

	Test["Only one NeckType or TaperGroundJointSize may be informed:",
		Lookup[packet,{NeckType,TaperGroundJointSize}],
		{NullP,NullP}|{Except[NullP],NullP}|{NullP,Except[NullP]}
	],

	Test["There is a single position defined for the model container named \"A1\":",
		Lookup[packet,Positions],
		{AssociationMatchP[<|Name->"A1"|>,AllowForeignKeys->True]}
	],

	Test["If the container is a sterile vessel and washable then its PreferredAutoclaveBin is populated:",
		If[MatchQ[Lookup[packet,Object],Alternatives@@PreferredContainer[All,Sterile->True]]&&MatchQ[Lookup[packet,CleaningMethod],CleaningMethodP],
			!NullQ[Lookup[packet,PreferredAutoclaveBin]],
			True
		],
		True
	],

	Test["If the container has CrossSectionalShape->Circle, X and Y dimensions must be identical:",
		Lookup[packet, {CrossSectionalShape, Dimensions}],
		Alternatives[
			{Circle, {diameter_, diameter_, _}},
			{Except[Circle], _}
		]
	]
};

validModelContainerPlateMALDIQTests[packet:PacketP[Model[Container,Plate,MALDI]]]:={

	Test["The container's footprint is MALDIPlate:",
		Lookup[packet,Footprint],
		MALDIPlate
	]
};

validModelContainerPlatePhaseSeparatorQTests[packet:PacketP[Model[Container,Plate,PhaseSeparator]]]:={

	Test["The container's footprint is Plate:",
		Lookup[packet,Footprint],
		Plate
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerFoamAgitationModuleQTests*)


validModelContainerFoamAgitationModuleQTests[packet:PacketP[Model[Container,FoamAgitationModule]]]:={
	(*fields that should be informed*)

	(*sanity check tests*)
	FieldComparisonTest[packet,{MinFilterDiameter,MaxFilterDiameter},LessEqual],
	FieldComparisonTest[packet,{MinColumnDiameter,MaxColumnDiameter},LessEqual]
};



(* ::Subsection::Closed:: *)
(*validModelContainerFoamColumnQTests*)


validModelContainerFoamColumnQTests[packet:PacketP[Model[Container,FoamColumn]]]:={

	NotNullFieldTest[packet,{
		Detector,
		Jacketed,
		Prism,
		Diameter,
		ColumnHeight
	}],

	(*Sanity check ranges*)
	FieldComparisonTest[packet,{MinSampleVolume,MaxSampleVolume},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelContainerStandQTests*)


validModelContainerStandQTests[packet:PacketP[Model[Container,Stand]]]:={

	NotNullFieldTest[packet,{
		RodLength,
		RodDiameter
	}]

};


(* ::Subsection::Closed:: *)
(*validModelContainerClampQTests*)


validModelContainerClampQTests[packet:PacketP[Model[Container,Clamp]]]:={

	NotNullFieldTest[packet,{
		MinDiameter,
		MaxDiameter
	}],

	FieldComparisonTest[packet,{MinDiameter,MaxDiameter},LessEqual]

};


(* ::Subsection::Closed:: *)
(*validModelContainerSpillKitQTests*)


validModelContainerSpillKitQTests[packet:PacketP[Model[Container,SpillKit]]]:= {

};


(* ::Subsection:: *)
(* Test Registration *)


registerValidQTestFunction[Model[Container],validModelContainerQTests];
registerValidQTestFunction[Model[Container, Bag],validModelContainerBagQTests];
registerValidQTestFunction[Model[Container, Bag, Aseptic],validModelContainerBagAsepticQTests];
registerValidQTestFunction[Model[Container, Bag, Autoclave],validModelContainerBagAutoclaveQTests];
registerValidQTestFunction[Model[Container, Bag, Dishwasher],validModelContainerBagDishwasherQTests];
registerValidQTestFunction[Model[Container, Bench],validModelContainerBenchQTests];
registerValidQTestFunction[Model[Container, Bench, Receiving],validModelContainerBenchReceivingQTests];
registerValidQTestFunction[Model[Container, Building],validModelContainerBuildingQTests];
registerValidQTestFunction[Model[Container, BumpTrap],validModelContainerBumpTrapQTests];
registerValidQTestFunction[Model[Container, Cabinet],validModelContainerCabinetQTests];
registerValidQTestFunction[Model[Container, Capillary],validModelContainerCapillaryQTests];
registerValidQTestFunction[Model[Container, CartDock],validModelContainerCartDockQTests];
registerValidQTestFunction[Model[Container, CentrifugeBucket],validModelContainerCentrifugeBucketQTests];
registerValidQTestFunction[Model[Container, CentrifugeRotor],validModelContainerCentrifugeRotorQTests];
registerValidQTestFunction[Model[Container, ColonyHandlerHeadCassetteHolder],validModelContainerColonyHandlerHeadCassetteHolderQTests];
registerValidQTestFunction[Model[Container, Cuvette],validModelContainerCuvetteQTests];
registerValidQTestFunction[Model[Container, Deck],validModelContainerDeckQTests];
registerValidQTestFunction[Model[Container, DosingHead],validModelContainerDosingHeadQTests];
registerValidQTestFunction[Model[Container, ElectricalPanel],validModelContainerElectricalPanelQTests];
registerValidQTestFunction[Model[Container, Enclosure],validModelContainerEnclosureQTests];
registerValidQTestFunction[Model[Container, ExtractionCartridge],validModelContainerExtractionCartridgeQTests];
registerValidQTestFunction[Model[Container, Envelope], validModelContainerEnvelopeQTests];
registerValidQTestFunction[Model[Container, FlammableCabinet],validModelContainerFlammableCabinetQTests];
registerValidQTestFunction[Model[Container,FiberSampleHolder],validModelContainerFiberSampleHolderQTests];
registerValidQTestFunction[Model[Container, FloatingRack],validModelContainerFloatingRackQTests];
registerValidQTestFunction[Model[Container, Floor],validModelContainerFloorQTests];
registerValidQTestFunction[Model[Container, FoamColumn],validModelContainerFoamColumnQTests];
registerValidQTestFunction[Model[Container, FoamAgitationModule],validModelContainerFoamAgitationModuleQTests];
registerValidQTestFunction[Model[Container, GasCylinder],validModelContainerGasCylinderQTests];
registerValidQTestFunction[Model[Container, GraduatedCylinder],validModelContainerGraduatedCylinderQTests];
registerValidQTestFunction[Model[Container, GrinderTubeHolder],validModelContainerGrinderTubeHolderQTests];
registerValidQTestFunction[Model[Container, GrindingContainer],validModelContainerGrindingContainerQTests];
registerValidQTestFunction[Model[Container, Hemocytometer],validModelContainerHemocytometerQTests];
registerValidQTestFunction[Model[Container, LightBox],validModelContainerLightBoxQTests];
registerValidQTestFunction[Model[Container, JunctionBox],validModelContainerJunctionBoxQTests];
registerValidQTestFunction[Model[Container, MagazineRack],validModelContainerMagazineRackQTests];
registerValidQTestFunction[Model[Container, MicrofluidicChip],validModelContainerMicrofluidicChipQTests];
registerValidQTestFunction[Model[Container, MicroscopeSlide],validModelContainerMicroscopeSlideQTests];
registerValidQTestFunction[Model[Container, NMRSpinner],validModelContainerNMRSpinnerQTests];
registerValidQTestFunction[Model[Container, OperatorCart],validModelContainerOperatorCartQTests];
registerValidQTestFunction[Model[Container, Plate],validModelContainerPlateQTests];
registerValidQTestFunction[Model[Container, Plate, CapillaryStrip],validModelContainerPlateCapillaryStripQTests];
registerValidQTestFunction[Model[Container, Plate, Dialysis],validModelContainerPlateDialysisQTests];
registerValidQTestFunction[Model[Container, Plate, DropletCartridge],validModelContainerPlateDropletCartridgeQTests];
registerValidQTestFunction[Model[Container, Plate, Filter],validModelContainerPlateFilterQTests];
registerValidQTestFunction[Model[Container, Plate, Irregular],validModelContainerPlateIrregularQTests];
registerValidQTestFunction[Model[Container, Plate, Irregular, ArrayCard],validModelContainerPlateIrregularArrayCardQTests];
registerValidQTestFunction[Model[Container, Plate, Irregular, CapillaryELISA],validModelContainerPlateIrregularCapillaryELISAQTests];
registerValidQTestFunction[Model[Container, Plate, Irregular, Raman], validModelContainerPlateIrregularRamanQTests];
registerValidQTestFunction[Model[Container, PlateSealMagazine],validModelContainerPlateSealMagazineQTests];
registerValidQTestFunction[Model[Container, PortableCooler],validModelContainerPortableCoolerQTests];
registerValidQTestFunction[Model[Container, PortableHeater],validModelContainerPortableHeaterQTests];
registerValidQTestFunction[Model[Container, ProteinCapillaryElectrophoresisCartridge],validModelContainerProteinCapillaryElectrophoresisCartridgeQTests];
registerValidQTestFunction[Model[Container, ProteinCapillaryElectrophoresisCartridgeInsert],validModelContainerProteinCapillaryElectrophoresisCartridgeInsertQTests];
registerValidQTestFunction[Model[Container, Rack],validModelContainerRackQTests];
registerValidQTestFunction[Model[Container, Rack, Dishwasher],validModelContainerRackDishwasherQTests];
registerValidQTestFunction[Model[Container, Rack,InsulatedCooler],validModelContainerRackInsulatedCoolerQTests];
registerValidQTestFunction[Model[Container, ReactionVessel],validModelContainerReactionVesselQTests];
registerValidQTestFunction[Model[Container, ReactionVessel, Microwave],validModelContainerReactionVesselMicrowaveQTests];
registerValidQTestFunction[Model[Container, ReactionVessel, SolidPhaseSynthesis],validModelContainerReactionVesselSolidPhaseSynthesisQTests];
registerValidQTestFunction[Model[Container, ReactionVessel, ElectrochemicalSynthesis],validModelContainerReactionVesselElectrochemicalSynthesisQTests];
registerValidQTestFunction[Model[Container, Room],validModelContainerRoomQTests];
registerValidQTestFunction[Model[Container, Safe],validModelContainerSafeQTests];
registerValidQTestFunction[Model[Container, Shelf],validModelContainerShelfQTests];
registerValidQTestFunction[Model[Container, ShelvingUnit],validModelContainerShelvingUnitQTests];
registerValidQTestFunction[Model[Container, Shipping],validModelContainerShippingQTests];
registerValidQTestFunction[Model[Container, Syringe],validModelContainerSyringeQTests];
registerValidQTestFunction[Model[Container, SyringeTool],validModelContainerSyringeToolQTests];
registerValidQTestFunction[Model[Container, Vessel],validModelContainerVesselQTests];
registerValidQTestFunction[Model[Container, Vessel, BufferCartridge],validModelContainerVesselBufferCartridgeQTests];
registerValidQTestFunction[Model[Container, Vessel, CrossFlowContainer],validModelContainerVesselCrossFlowQTests];
registerValidQTestFunction[Model[Container, Vessel, CrossFlowWashContainer],validModelWashContainerVesselCrossFlowQTests];
registerValidQTestFunction[Model[Container, Vessel, Dialysis],validModelContainerVesselDialysisQTests];
registerValidQTestFunction[Model[Container, Vessel, Filter],validModelContainerVesselFilterQTests];
registerValidQTestFunction[Model[Container, Vessel, VolumetricFlask],validModelContainerVesselVolumetricFlaskQTests];
registerValidQTestFunction[Model[Container, Vessel, GasWashingBottle],validModelContainerVesselGasWashingBottleQTests];
registerValidQTestFunction[Model[Container, Plate, Irregular,Crystallization], validModelContainerPlateIrregularCrystallizationQTests];
registerValidQTestFunction[Model[Container, WashBath],validContainerWashBathQTests];
registerValidQTestFunction[Model[Container, WashBin],validModelContainerWashBinQTests];
registerValidQTestFunction[Model[Container, WasteBin],validModelContainerWasteBinQTests];
registerValidQTestFunction[Model[Container, Waste],validModelContainerWasteQTests];
registerValidQTestFunction[Model[Container, Site],validModelContainerSiteQTests];
registerValidQTestFunction[Model[Container, Box],validModelContainerBoxQTests];
registerValidQTestFunction[Model[Container, Plate, MALDI],validModelContainerPlateMALDIQTests];
registerValidQTestFunction[Model[Container, Plate, PhaseSeparator],validModelContainerPlatePhaseSeparatorQTests];
registerValidQTestFunction[Model[Container, Stand],validModelContainerStandQTests];
registerValidQTestFunction[Model[Container, Clamp],validModelContainerClampQTests];
registerValidQTestFunction[Model[Container,PhaseSeparator],validModelContainerPhaseSeparatorQTests];
registerValidQTestFunction[Model[Container,SpillKit],validModelContainerSpillKitQTests];
