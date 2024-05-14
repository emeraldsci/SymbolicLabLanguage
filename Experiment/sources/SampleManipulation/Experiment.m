(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*Primitive Installation*)


(* ::Subsubsection::Closed:: *)
(*Primitive Images*)


(* memoize imported image after first reference *)
aliquotImage[]:=aliquotImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","AliquotIcon.png"}]];
mixImage[]:=mixImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","MixIcon.png"}]];
transferImage[]:=transferImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","TransferIcon.png"}]];
consolidationImage[]:=consolidationImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","ConsolidateIcon.png"}]];
filltovolumeImage[]:=filltovolumeImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","FillToVolumeIcon.png"}]];
incubateImage[]:=incubateImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","IncubateIcon.png"}]];
waitImage[]:=waitImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","WaitIcon.png"}]];
defineImage[]:=defineImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","DefineIcon.png"}]];
filterImage[]:=filterImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","FilterIcon.png"}]];
moveToMagnetImage[]:=moveToMagnetImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","MoveToMagnetIcon.png"}]];
removeFromMagnetImage[]:=removeFromMagnetImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","RemoveFromMagnetIcon.png"}]];
centrifugeImage[]:=centrifugeImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","CentrifugeIcon.png"}]];
readPlateImage[]:=centrifugeImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","ReadPlateIcon.png"}]];
pelletImage[]:=pelletImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","CentrifugeIcon.png"}]];
resuspendImage[]:=resuspendImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","ResuspendIcon.png"}]];
coverImage[]:=coverImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","CoverIcon.png"}]];
uncoverImage[]:=uncoverImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","CoverIcon.png"}]];

(* TODO - when sending in ReadPlate options convert instrument object to model *)


(* ::Subsubsection::Closed:: *)
(*installSampleManipulationPrimitives*)


formatBoxForm[assoc_, key_, description_]:=With[{value=Lookup[assoc,key,Null]},
	If[NullQ[value],Nothing,BoxForm`SummaryItem[{description<>": ",value}]]
];


installSampleManipulationPrimitives[]:={
	installTransferPrimitive[];,
	installAliquotPrimitive[];,
	installConsolidationPrimitive[];,
	installMixPrimitive[];,
	installIncubatePrimitive[];
	installFillToVolumePrimitive[];
	installWaitPrimitive[];
	installDefinePrimitive[];
	installFilterPrimitive[];
	installMoveToMagnetPrimitive[];
	installRemoveFromMagnetPrimitive[];
	installCentrifugePrimitive[];
	installReadPlatePrimitive[];
	installPelletPrimitive[];
	installResuspendPrimitive[];
	installCoverPrimitive[];
	installUncoverPrimitive[];
};

installSampleManipulationPrimitives[];
Unprotect/@{Aliquot,Consolidation,Transfer,Mix,FillToVolume,Incubate,Wait,Define,Filter,MoveToMagnet,RemoveFromMagnet,Centrifuge,ReadPlate,Pellet,Resuspend,Cover,Uncover};
OverloadSummaryHead/@{Aliquot,Consolidation,Transfer,Mix,FillToVolume,Incubate,Wait,Define,Filter,MoveToMagnet,RemoveFromMagnet,Centrifuge,ReadPlate,Pellet,Resuspend,Cover,Uncover};
Protect/@{Aliquot,Consolidation,Transfer,Mix,FillToVolume,Incubate,Wait,Define,Filter,MoveToMagnet,RemoveFromMagnet,Centrifuge,ReadPlate,Pellet,Resuspend,Cover,Uncover};

(* ensure that reloading the package will re-initialize primitive generation *)
OnLoad[
	installSampleManipulationPrimitives[];
	Unprotect/@{Aliquot,Consolidation,Transfer,Mix,FillToVolume,Incubate,Wait,Define,Filter,MoveToMagnet,RemoveFromMagnet,Centrifuge,ReadPlate,Pellet,Resuspend,Cover,Uncover};
	OverloadSummaryHead/@{Aliquot,Consolidation,Transfer,Mix,FillToVolume,Incubate,Wait,Define,Filter,MoveToMagnet,RemoveFromMagnet,Centrifuge,ReadPlate,Pellet,Resuspend,Cover,Uncover};
	Protect/@{Aliquot,Consolidation,Transfer,Mix,FillToVolume,Incubate,Wait,Define,Filter,MoveToMagnet,RemoveFromMagnet,Centrifuge,ReadPlate,Pellet,Resuspend,Cover,Uncover};
];


(* ::Subsection::Closed:: *)
(*Primitive Definitions*)


(* ::Subsubsection::Closed:: *)
(*Pipetting Parameters Option Set*)


DefineOptionSet[
	pipettingParameterOptions:>{
		{
			OptionName -> TipType,
			Default -> Automatic,
			Description -> "The tip to use to transfer liquid in the manipulation.",
			ResolutionDescription -> "Automatically resolves based on the amount being transferred or TipSize specification.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Alternatives[
				Widget[Type->Enumeration,Pattern:>TipTypeP],
				Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[Item,Tips]]
				]
			]
		},
		{
			OptionName -> TipSize,
			Default -> Automatic,
			Description -> "The maximum volume of the tip used to transfer liquid in the manipulation.",
			ResolutionDescription -> "Automatically resolves based on the amount being transferred orr the TipType specified.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0 Microliter],
				Units -> {Microliter,{Microliter,Milliliter}}
			]
		},
		{
			OptionName -> AspirationRate,
			Default -> Automatic,
			Description -> "The speed at which liquid should be drawn up into the pipette tip.",
			ResolutionDescription -> "Automatically resolves from DispenseRate if it is specified, otherwise resolves to 100 Microliter/Second.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.4 Microliter/Second,500 Microliter/Second],
				Units -> CompoundUnit[
					{1,{Milliliter,{Microliter,Milliliter,Liter}}},
					{-1,{Second,{Second,Minute}}}
				]
			]
		},
		{
			OptionName -> DispenseRate,
			Default -> Automatic,
			Description -> "The speed at which liquid should be expelled from the pipette tip.",
			ResolutionDescription -> "Automatically resolves from AspirationRate if it is specified, otherwise resolves to 100 Microliter/Second.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.4 Microliter/Second,500 Microliter/Second],
				Units -> CompoundUnit[
					{1,{Milliliter,{Microliter,Milliliter,Liter}}},
					{-1,{Second,{Second,Minute}}}
				]
			]
		},
		{
			OptionName -> OverAspirationVolume,
			Default -> Automatic,
			Description -> "The volume of air drawn into the pipette tip at the end of the aspiration of a liquid.",
			ResolutionDescription -> "Automatically resolves from OverDispenseVolume if it is specified, otherwise resolves to 5 Microliter.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter,50 Microliter],
				Units -> {Microliter,{Microliter,Milliliter}}
			]
		},
		{
			OptionName -> OverDispenseVolume,
			Default -> Automatic,
			Description -> "The volume of air blown out at the end of the dispensing of a liquid.",
			ResolutionDescription -> "Automatically resolves to 5 Microliter.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter,300 Microliter],
				Units -> {Microliter,{Microliter,Milliliter}}
			]
		},
		{
			OptionName -> AspirationWithdrawalRate,
			Default -> Automatic,
			Description -> "The speed at which the pipette is removed from the liquid after an aspiration.",
			ResolutionDescription -> "Automatically resolves from DispenseWithdrawalRate if it is specified, otherwise resolves to 2 Millimeter/Second.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.3 Millimeter/Second, 160 Millimeter/Second],
				Units -> CompoundUnit[
					{1,{Millimeter,{Millimeter,Micrometer}}},
					{-1,{Second,{Second,Minute}}}
				]
			]
		},
		{
			OptionName -> DispenseWithdrawalRate,
			Default -> Automatic,
			Description -> "The speed at which the pipette is removed from the liquid after a dispense.",
			ResolutionDescription -> "Automatically resolves from AspirationWithdrawalRate if it is specified, otherwise resolves to 2 Millimeter/Second.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.3 Millimeter/Second, 160 Millimeter/Second],
				Units -> CompoundUnit[
					{1,{Millimeter,{Millimeter,Micrometer}}},
					{-1,{Second,{Second,Minute}}}
				]
			]
		},
		{
			OptionName -> AspirationEquilibrationTime,
			Default -> Automatic,
			Description -> "The delay length the pipette waits after aspirating before it is removed from the liquid.",
			ResolutionDescription -> "Automatically resolves from DispenseEquilibrationTime if it is specified, otherwise resolves to 1 Second.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Second, 9.9 Second],
				Units -> {Second,{Second,Minute}}
			]
		},
		{
			OptionName -> DispenseEquilibrationTime,
			Default -> Automatic,
			Description -> "The delay length the pipette waits after dispensing before it is removed from the liquid.",
			ResolutionDescription -> "Automatically resolves from AspirationEquilibrationTime if it is specified, otherwise resolves to 1 Second.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Second, 9.9 Second],
				Units -> {Second,{Second,Minute}}
			]
		},
		{
			OptionName -> AspirationMix,
			Default -> Automatic,
			Description -> "Indicates if the source should be mixed before it is aspirated.",
			ResolutionDescription -> "Automatically resolves to True if other aspiration mix parameters are specified, otherwise False.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		{
			OptionName -> DispenseMix,
			Default -> Automatic,
			Description -> "Indicates if the destination should be mixed after the source is dispensed.",
			ResolutionDescription -> "Automatically resolves to True if other dispense mix parameters are specified, otherwise False.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		{
			OptionName -> AspirationMixVolume,
			Default -> Automatic,
			Description -> "The volume quickly aspirated and dispensed to mix the source sample before it is aspirated.",
			ResolutionDescription -> "Automatically resolves to half the volume of the source if AspirationMix is True.",
			AllowNull -> True,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter,970 Microliter],
				Units -> {Microliter,{Microliter,Milliliter}}
			]
		},
		{
			OptionName -> DispenseMixVolume,
			Default -> Automatic,
			Description -> "The volume quickly aspirated and dispensed to mix the destination sample after the source is dispensed.",
			ResolutionDescription -> "Automatically resolves to half the volume of the destination if DispenseMix is True.",
			AllowNull -> True,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter,970 Microliter],
				Units -> {Microliter,{Microliter,Milliliter}}
			]
		},
		{
			OptionName -> AspirationNumberOfMixes,
			Default -> Automatic,
			Description -> "The number of times the source is quickly aspirated and dispensed to mix the source sample before it is aspirated.",
			ResolutionDescription -> "Automatically resolves to three if AspirationMix is True.",
			AllowNull -> True,
			Category -> "Pipetting",
			Widget -> Widget[Type -> Number,Pattern :> GreaterEqualP[0]]
		},
		{
			OptionName -> DispenseNumberOfMixes,
			Default -> Automatic,
			Description -> "The number of times the destination is quickly aspirated and dispensed to mix the destination sample after the source is dispensed.",
			ResolutionDescription -> "Automatically resolves to three if DispenseMix is True.",
			AllowNull -> True,
			Category -> "Pipetting",
			Widget -> Widget[Type -> Number,Pattern :> GreaterEqualP[0]]
		},
		{
			OptionName -> AspirationMixRate,
			Default -> Automatic,
			Description -> "The speed at which liquid is aspirated and dispensed in a liquid before it is aspirated.",
			ResolutionDescription -> "Automatically resolves from DispenseMixRate or AspirationRate if either is specified, otherwise resolves to 100 Microliter/Second.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.4 Microliter/Second,500 Microliter/Second],
				Units -> CompoundUnit[
					{1,{Milliliter,{Microliter,Milliliter,Liter}}},
					{-1,{Second,{Second,Minute}}}
				]
			]
		},
		{
			OptionName -> DispenseMixRate,
			Default -> Automatic,
			Description -> "The speed at which liquid is aspirated and dispensed in a liquid after a dispense.",
			ResolutionDescription -> "Automatically resolves from AspirationMixRate or DispenseRate if either is specified, otherwise resolves to 100 Microliter/Second.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.4 Microliter/Second,500 Microliter/Second],
				Units -> CompoundUnit[
					{1,{Milliliter,{Microliter,Milliliter,Liter}}},
					{-1,{Second,{Second,Minute}}}
				]
			]
		},
		{
			OptionName -> AspirationPosition,
			Default -> Automatic,
			Description -> "The location from which liquid should be aspirated. Top will aspirate AspirationPositionOffset below the Top of the container, Bottom will aspirate AspirationPositionOffset above the Bottom of the container, LiquidLevel will aspirate AspirationPositionOffset below the liquid level of the sample in the container, and TouchOff will touch the bottom of the container before moving the specified AspirationPositionOffset above the bottom of the container to start aspirate the sample.",
			ResolutionDescription -> "Automatically set to the AspirationPosition in the PipettingMethod if it is specified and Preparation->Robotic, otherwise resolves to LiquidLevel if Preparation->Robotic.",
			AllowNull -> True,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> PipettingPositionP
			]
		},
		{
			OptionName -> DispensePosition,
			Default -> Automatic,
			Description -> "The location from which liquid should be dispensed. Top will dispense DispensePositionOffset below the Top of the container, Bottom will dispense DispensePositionOffset above the Bottom of the container, LiquidLevel will dispense DispensePositionOffset below the liquid level of the sample in the container, and TouchOff will touch the bottom of the container before moving the specified DispensePositionOffset above the bottom of the container to start dispensing the sample.",
			ResolutionDescription -> "Automatically set to the DispensePosition in the PipettingMethod if it is specified and Preparation->Robotic, otherwise resolves to LiquidLevel if Preparation->Robotic.",
			AllowNull -> True,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> PipettingPositionP
			]
		},
		{
			OptionName -> AspirationPositionOffset,
			Default -> Automatic,
			Description -> "The distance from the top or bottom of the container, depending on AspirationPosition, from which liquid should be aspirated.",
			ResolutionDescription -> "Automatically resolves from DispensePositionOffset if it is specified, or if AspirationPosition is not Null resolves to 2 Millimeter, otherwise resolves to Null and is determined at runtime by inspecting a sample's container type.",
			AllowNull -> True,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterEqualP[0 Millimeter],
				Units -> {Millimeter,{Millimeter}}
			]
		},
		{
			OptionName -> DispensePositionOffset,
			Default -> Automatic,
			Description -> "The distance from the top or bottom of the container, depending on DispensePosition, from which liquid should be dispensed.",
			ResolutionDescription -> "Automatically resolves from AspirationPositionOffset if it is specified, or if DispensePosition is not Null resolves to 2 Millimeter, otherwise resolves to Null and is determined at runtime by inspecting a sample's container type.",
			AllowNull -> True,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterEqualP[0 Millimeter],
				Units -> {Millimeter,{Millimeter}}
			]
		},
		{
			OptionName -> CorrectionCurve,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The relationship between a target volume and the corrected volume that needs to be aspirated or dispensed to reach the target volume.",
			ResolutionDescription -> "Automatically resolves from PipettingMethod if it is specified, or the default correction curve empirically determined for water.",
			Category -> "Pipetting",
			Widget -> Adder[
				{
					"Target Volume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Microliter, 1000 Microliter],
						Units -> {Microliter,{Microliter,Milliliter}}
					],
					"Actual Volume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Microliter, 1250 Microliter],
						Units -> {Microliter,{Microliter,Milliliter}}
					]
				},
				Orientation -> Vertical
			]
		},
		{
			OptionName -> DynamicAspiration,
			Default -> Automatic,
			Description -> "Indicates if droplet formation should be prevented during liquid transfer. This should only be used for solvents that have high vapor pressure.",
			ResolutionDescription -> "Automatically resolves to False if unspecified.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		}
	}
];


(* Primitive keys used to specify pipetting method *)
pipettingParameterSet:=(pipettingParameterSet=Association[
	TipType -> Alternatives[
		Automatic,
		TipTypeP,
		(* Specific tip model *)
		ObjectP[Model[Item,Tips]]
	],
	TipSize -> Automatic|VolumeP,
	AspirationRate -> (RangeP[0.4 Microliter/Second,500 Microliter/Second]|Automatic),
	DispenseRate -> (RangeP[0.4 Microliter/Second,500 Microliter/Second]|Automatic),
	OverAspirationVolume -> (RangeP[0 Microliter,50 Microliter]|Automatic),
	OverDispenseVolume -> (RangeP[0 Microliter,300 Microliter]|Automatic),
	AspirationWithdrawalRate -> (RangeP[0.3 Millimeter/Second, 160 Millimeter/Second]|Automatic),
	DispenseWithdrawalRate -> (RangeP[0.3 Millimeter/Second, 160 Millimeter/Second]|Automatic),
	AspirationEquilibrationTime -> (RangeP[0 Second, 9.9 Second]|Automatic),
	DispenseEquilibrationTime -> (RangeP[0 Second, 9.9 Second]|Automatic),
	CorrectionCurve -> Alternatives[
		{{RangeP[0 Microliter, 1000 Microliter],RangeP[0 Microliter, 1250 Microliter]}...},
		Automatic,
		Null
	],
	AspirationMixRate -> (RangeP[0.4 Microliter/Second,500 Microliter/Second]|Automatic|Null),
	DispenseMixRate -> (RangeP[0.4 Microliter/Second,500 Microliter/Second]|Automatic|Null),
	AspirationMix -> BooleanP|Automatic,
	DispenseMix -> BooleanP|Automatic,
	AspirationMixVolume -> (RangeP[0 Microliter,970 Microliter]|Automatic|Null),
	DispenseMixVolume -> (RangeP[0 Microliter,970 Microliter]|Automatic|Null),
	AspirationNumberOfMixes -> (_Integer|Automatic|Null),
	DispenseNumberOfMixes -> (_Integer|Automatic|Null),
	AspirationPosition -> (PipettingPositionP|Automatic),
	DispensePosition -> (PipettingPositionP|Automatic),
	AspirationPositionOffset -> (GreaterEqualP[0 Millimeter]|Automatic),
	DispensePositionOffset -> (GreaterEqualP[0 Millimeter]|Automatic),
	PipettingMethod -> (ObjectP[Model[Method,Pipetting]]|Automatic|Null),
	DynamicAspiration -> Automatic|BooleanP
]);

(* Pattern matching name of any pipetting parameters *)
pipettingParameterP:=(pipettingParameterP=Alternatives@@Keys[pipettingParameterSet]);



(* ::Subsubsection::Closed:: *)
(*Transfer*)


DefineOptions[Transfer,
	Options :> {
		{
			OptionName -> Resuspension,
			Default -> False,
			Description -> "Indicates if this transfer is resuspending a solid. If True, liquid will be dispensed at the top of the destination's container.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		{
			OptionName -> TransferType,
			Default -> Automatic,
			Description -> "Describes the sample consistency being transferred. Unspecified pipetting parameters may be resolved based on this value.",
			ResolutionDescription -> "Automatically resolves from the destination sample's state.",
			AllowNull -> True,
			Category -> "Pipetting",
			Widget -> Widget[Type->Enumeration,Pattern:>(Liquid|Slurry|Solid)]
		},
		{
			(* Lets the users choose whether the droplets transferred from different samples into the same destination well are spatially separated *)
			OptionName->InWellSeparation,
			Default->Null,
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates how the droplets of different samples are transferred into the same destination well. If True, the droplets are targeted to be spatially separated to avoid mixing with each other until additional volume is added to the well. This option is specific to ExperimentAcousticLiquidHandling.",
			Category->"Acoustic Liquid Handling"
		},
		pipettingParameterOptions
	}
];


installTransferPrimitive[]:=MakeBoxes[summary:Transfer[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	Transfer,
	summary,
	transferImage[],
	{
		If[MatchQ[assoc[Source],_Missing],Nothing,BoxForm`SummaryItem[{"Source: ",Shallow[assoc[Source],{Infinity,20}]}]],
		If[MatchQ[assoc[Destination],_Missing],Nothing,BoxForm`SummaryItem[{"Destination: ",Shallow[assoc[Destination],{Infinity,20}]}]],
		If[MatchQ[assoc[Amount],_Missing],Nothing,BoxForm`SummaryItem[{"Amount: ",Shallow[assoc[Amount],{Infinity,20}]}]],
		If[MatchQ[assoc[Volume],_Missing],Nothing,BoxForm`SummaryItem[{"Amount: ",Shallow[assoc[Volume],{Infinity,20}]}]],
		If[MatchQ[assoc[TipType],_Missing],Nothing,BoxForm`SummaryItem[{"Tip Type: ",Shallow[assoc[TipType],{Infinity,20}]}]],
		If[MatchQ[assoc[TipSize],_Missing],Nothing,BoxForm`SummaryItem[{"Tip Size: ",Shallow[assoc[TipSize],{Infinity,20}]}]],
		If[MatchQ[assoc[PipettingMethod],_Missing],Nothing,BoxForm`SummaryItem[{"PipettingMethod: ",Shallow[assoc[PipettingMethod],{Infinity,20}]}]],
		If[MatchQ[assoc[AspirationClassifications],_Missing],Nothing,BoxForm`SummaryItem[{"Aspiration Classifications: ",Shallow[assoc[AspirationClassifications],{Infinity,20}]}]],
		If[MatchQ[assoc[AspirationClassificationConfidences],_Missing],Nothing,BoxForm`SummaryItem[{"Aspiration Classification Confidences: ",Shallow[assoc[AspirationClassificationConfidences],{Infinity,20}]}]]
	},
	{
		If[MatchQ[assoc[Resuspension],_Missing],Nothing,BoxForm`SummaryItem[{"Resuspension: ",Shallow[assoc[Resuspension],{Infinity,20}]}]],
		If[MatchQ[assoc[TransferType],_Missing],Nothing,BoxForm`SummaryItem[{"TransferType: ",Shallow[assoc[TransferType],{Infinity,20}]}]],
		If[MatchQ[assoc[DeviceChannel],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DeviceChannel: ",Shallow[assoc[DeviceChannel],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationRate: ",Shallow[assoc[AspirationRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseRate: ",Shallow[assoc[DispenseRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[OverAspirationVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"OverAspirationVolume: ",Shallow[assoc[OverAspirationVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[OverDispenseVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"OverDispenseVolume: ",Shallow[assoc[OverDispenseVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationWithdrawalRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationWithdrawalRate: ",Shallow[assoc[AspirationWithdrawalRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseWithdrawalRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseWithdrawalRate: ",Shallow[assoc[DispenseWithdrawalRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationEquilibrationTime],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationEquilibrationTime: ",Shallow[assoc[AspirationEquilibrationTime],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseEquilibrationTime],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseEquilibrationTime: ",Shallow[assoc[DispenseEquilibrationTime],{Infinity,20}]}]
		],
		If[MatchQ[assoc[CorrectionCurve],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"CorrectionCurve: ",Shallow[assoc[CorrectionCurve],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationMixRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationMixRate: ",Shallow[assoc[AspirationMixRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseMixRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseMixRate: ",Shallow[assoc[DispenseMixRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationMix],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationMix: ",Shallow[assoc[AspirationMix],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseMix],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseMix: ",Shallow[assoc[DispenseMix],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationMixVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationMixVolume: ",Shallow[assoc[AspirationMixVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseMixVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseMixVolume: ",Shallow[assoc[DispenseMixVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationNumberOfMixes],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationNumberOfMixes: ",Shallow[assoc[AspirationNumberOfMixes],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseNumberOfMixes],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseNumberOfMixes: ",Shallow[assoc[DispenseNumberOfMixes],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationPosition],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationPosition: ",Shallow[assoc[AspirationPosition],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispensePosition],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispensePosition: ",Shallow[assoc[DispensePosition],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationPositionOffset],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationPositionOffset: ",Shallow[assoc[AspirationPositionOffset],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispensePositionOffset],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispensePositionOffset: ",Shallow[assoc[DispensePositionOffset],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DynamicAspiration],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"Dynamic Aspiration: ",Shallow[assoc[DynamicAspiration],{Infinity,20}]}]
		],
		If[MatchQ[assoc[InWellSeparation],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"InWellSeparation: ",Shallow[assoc[InWellSeparation],{Infinity,20}]}]
		]
	},
	StandardForm
];



(* ::Subsubsection::Closed:: *)
(*Resuspend*)


DefineOptions[Resuspend,
	Options :> {
		{
			OptionName -> Volume,
			Default -> Null,
			Description -> "The desired total volume of the resuspended sample plus diluent.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[1 Microliter, 20 Liter],
				Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
			]
		},
		{
			OptionName -> Diluent,
			Default -> Model[Sample, "Milli-Q water"],
			Description -> "The sample that should be added to the input sample, where the volume of this sample added is the Volume option.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
				PreparedSample -> False,
				PreparedContainer -> False
			]
		},
		{
			OptionName -> MixType,
			Widget -> Alternatives[
				Widget[Type -> Enumeration,Pattern :> MixTypeP],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
			],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "Indicates the style of motion used to mix the sample."
		},
		{
			OptionName -> MixUntilDissolved,
			Widget -> Alternatives[
				Widget[Type -> Enumeration,Pattern :> BooleanP],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
			],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "Indicates if the mix should be continued up to the MaxTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute."
		},
		{
			OptionName -> MixVolume,
			Widget -> Alternatives[
				Widget[Type->Quantity,Pattern:>GreaterEqualP[0*Microliter],Units->{Microliter,{Microliter,Milliliter,Liter}}],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
			],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "The volume of the sample that should be pipetted up and down to mix if mix Type: Pipette, is chosen.",
			Category->"Pipetting"
		},
		{
			OptionName -> NumberOfMixes,
			Widget -> Alternatives[
				Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
			],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "Number of times the samples should be mixed if mix Type: Pipette or Invert, is chosen.",
			Category-> "Pipetting"
		},
		{
			OptionName -> MaxNumberOfMixes,
			Widget -> Alternatives[
				Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
			],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "Maximum number of times for which the samples will be mixed, in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. Note this option only applies for mix type: Pipette or Invert."
		},
		{
			OptionName -> IncubationTime,
			Widget -> Widget[Type->Quantity,Pattern :> RangeP[0 Minute,72 Hour],Units -> {Minute,{Minute,Second}}],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "Duration of time for which the samples will be incubated."
		},
		{
			OptionName -> MaxIncubationTime,
			Widget -> Alternatives[
				Widget[Type->Quantity,Pattern :> RangeP[0 Minute,72 Hour],Units -> {Minute,{Minute,Second}}],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
			],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "Maximum duration of time for which the samples will be mixed, in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. Note this option only applies for mix type: Shake, Roll, Vortex or Sonicate."
		},
		{
			OptionName -> IncubationInstrument,
			Widget -> Alternatives[
				Widget[Type -> Object,Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
			],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "The instrument used to perform the incubate."
		},
		{
			OptionName -> IncubationTemperature,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],Units -> Celsius],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "The temperature of the device that should be used to mix/incubate the sample. If mixing via homogenization, the pulse duty cycle of the sonication horn will automatically adjust if the measured temperature of the sample exceeds this set temperature."
		},
		{
			OptionName -> AnnealingTime,
			Widget -> Widget[Type->Quantity,Pattern :> GreaterEqualP[0 Minute],Units -> {Minute,{Minute,Second}}],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the Time has passed."
		},
		pipettingParameterOptions
	}

];

installResuspendPrimitive[]:=MakeBoxes[summary:Resuspend[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	Resuspend,
	summary,
	resuspendImage[],
	{
		If[MatchQ[assoc[Sample],_Missing],Nothing,BoxForm`SummaryItem[{"Sample: ",Shallow[assoc[Sample],{Infinity,20}]}]],
		If[MatchQ[assoc[Volume],_Missing],Nothing,BoxForm`SummaryItem[{"Volume: ",Shallow[assoc[Volume],{Infinity,20}]}]],
		If[MatchQ[assoc[Diluent],_Missing],Nothing,BoxForm`SummaryItem[{"Diluent: ",Shallow[assoc[Diluent], {Infinity,20}]}]]
	},
	{
		If[MatchQ[assoc[Mix],_Missing],Nothing,BoxForm`SummaryItem[{"Mix: ",Shallow[assoc[Mix],{Infinity,20}]}]],
		If[MatchQ[assoc[MixType],_Missing],Nothing,BoxForm`SummaryItem[{"Mix Type: ",Shallow[assoc[MixType],{Infinity,20}]}]],
		If[MatchQ[assoc[MixUntilDissolved],_Missing],Nothing,BoxForm`SummaryItem[{"MixUntilDissolved: ",Shallow[assoc[MixUntilDissolved],{Infinity,20}]}]],
		If[MatchQ[assoc[MixVolume],_Missing],Nothing,BoxForm`SummaryItem[{"Mix Volume: ",Shallow[assoc[MixVolume],{Infinity,20}]}]],
		If[MatchQ[assoc[NumberOfMixes],_Missing],Nothing,BoxForm`SummaryItem[{"Number of Mixes: ",Shallow[assoc[NumberOfMixes],{Infinity,20}]}]],
		If[MatchQ[assoc[MaxNumberOfMixes],_Missing],Nothing,BoxForm`SummaryItem[{"Max Number of Mixes: ",Shallow[assoc[MaxNumberOfMixes],{Infinity,20}]}]],
		If[MatchQ[assoc[IncubationTime],_Missing],Nothing,BoxForm`SummaryItem[{"Incubation Time: ",Shallow[assoc[IncubationTime],{Infinity,20}]}]],
		If[MatchQ[assoc[MaxIncubationTime],_Missing],Nothing,BoxForm`SummaryItem[{"MaxIncubation Time: ",Shallow[assoc[MaxIncubationTime],{Infinity,20}]}]],
		If[MatchQ[assoc[IncubationInstrument],_Missing],Nothing,BoxForm`SummaryItem[{"Incubation Instrument: ",Shallow[assoc[IncubationInstrument],{Infinity,20}]}]],
		If[MatchQ[assoc[IncubationTemperature],_Missing],Nothing,BoxForm`SummaryItem[{"Incubation Temperature: ",Shallow[assoc[IncubationTemperature],{Infinity,20}]}]],
		If[MatchQ[assoc[AnnealingTime],_Missing],Nothing,BoxForm`SummaryItem[{"Annealing Time: ",Shallow[assoc[AnnealingTime],{Infinity,20}]}]],
		If[MatchQ[assoc[TipType],_Missing],Nothing,BoxForm`SummaryItem[{"Tip Type: ",Shallow[assoc[TipType],{Infinity,20}]}]],
		If[MatchQ[assoc[TipSize],_Missing],Nothing,BoxForm`SummaryItem[{"Tip Size: ",Shallow[assoc[TipSize],{Infinity,20}]}]],
		If[MatchQ[assoc[PipettingMethod],_Missing],Nothing,BoxForm`SummaryItem[{"PipettingMethod: ",Shallow[assoc[PipettingMethod],{Infinity,20}]}]],
		If[MatchQ[assoc[DeviceChannel],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DeviceChannel: ",Shallow[assoc[DeviceChannel],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationRate: ",Shallow[assoc[AspirationRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseRate: ",Shallow[assoc[DispenseRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[OverAspirationVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"OverAspirationVolume: ",Shallow[assoc[OverAspirationVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[OverDispenseVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"OverDispenseVolume: ",Shallow[assoc[OverDispenseVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationWithdrawalRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationWithdrawalRate: ",Shallow[assoc[AspirationWithdrawalRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseWithdrawalRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseWithdrawalRate: ",Shallow[assoc[DispenseWithdrawalRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationEquilibrationTime],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationEquilibrationTime: ",Shallow[assoc[AspirationEquilibrationTime],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseEquilibrationTime],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseEquilibrationTime: ",Shallow[assoc[DispenseEquilibrationTime],{Infinity,20}]}]
		],
		If[MatchQ[assoc[CorrectionCurve],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"CorrectionCurve: ",Shallow[assoc[CorrectionCurve],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationMixRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationMixRate: ",Shallow[assoc[AspirationMixRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseMixRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseMixRate: ",Shallow[assoc[DispenseMixRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationMix],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationMix: ",Shallow[assoc[AspirationMix],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseMix],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseMix: ",Shallow[assoc[DispenseMix],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationMixVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationMixVolume: ",Shallow[assoc[AspirationMixVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseMixVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseMixVolume: ",Shallow[assoc[DispenseMixVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationNumberOfMixes],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationNumberOfMixes: ",Shallow[assoc[AspirationNumberOfMixes],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseNumberOfMixes],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseNumberOfMixes: ",Shallow[assoc[DispenseNumberOfMixes],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationPosition],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationPosition: ",Shallow[assoc[AspirationPosition],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispensePosition],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispensePosition: ",Shallow[assoc[DispensePosition],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationPositionOffset],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationPositionOffset: ",Shallow[assoc[AspirationPositionOffset],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispensePositionOffset],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispensePositionOffset: ",Shallow[assoc[DispensePositionOffset],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DynamicAspiration],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"Dynamic Aspiration: ",Shallow[assoc[DynamicAspiration],{Infinity,20}]}]
		]
	},
	StandardForm
];


(* ::Subsubsection::Closed:: *)
(*Aliquot*)


DefineOptions[Aliquot,
	Options :> {
		{
			OptionName -> TransferType,
			Default -> Automatic,
			Description -> "Describes the sample consistency being transferred. Unspecified pipetting parameters may be resolved based on this value.",
			ResolutionDescription -> "Automatically resolves from the destination sample's state.",
			AllowNull -> True,
			Category -> "Pipetting",
			Widget -> Widget[Type->Enumeration,Pattern:>(Liquid|Slurry|Solid)]
		},
		{
			(* Lets the users choose whether the droplets transferred from different samples into the same destination well are spatially separated *)
			OptionName->InWellSeparation,
			Default->Null,
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates how the droplets of different samples are transferred into the same destination well. If True, the droplets are targeted to be spatially separated to avoid mixing with each other until additional volume is added to the well. This option is specific to ExperimentAcousticLiquidHandling.",
			Category->"Acoustic Liquid Handling"
		},
		pipettingParameterOptions
	}
];



installAliquotPrimitive[]:=MakeBoxes[summary:Aliquot[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	Aliquot,
	summary,
	aliquotImage[],
	{
		If[MatchQ[assoc[Source],_Missing],Nothing,BoxForm`SummaryItem[{"Source: ",Shallow[assoc[Source],{Infinity,20}]}]],
		If[MatchQ[assoc[Destinations],_Missing],Nothing,BoxForm`SummaryItem[{"Destinations: ",Shallow[assoc[Destinations],{Infinity,20}]}]],
		If[MatchQ[assoc[Amounts],_Missing],Nothing,BoxForm`SummaryItem[{"Amounts: ",Shallow[assoc[Amounts],{Infinity,20}]}]],
		If[MatchQ[assoc[Volumes],_Missing],Nothing,BoxForm`SummaryItem[{"Amounts: ",Shallow[assoc[Volumes],{Infinity,20}]}]],
		If[MatchQ[assoc[TipType],_Missing],Nothing,BoxForm`SummaryItem[{"Tip Type: ",Shallow[assoc[TipType],{Infinity,20}]}]],
		If[MatchQ[assoc[TipSize],_Missing],Nothing,BoxForm`SummaryItem[{"Tip Size: ",Shallow[assoc[TipSize],{Infinity,20}]}]],
		If[MatchQ[assoc[PipettingMethod],_Missing],Nothing,BoxForm`SummaryItem[{"PipettingMethod: ",Shallow[assoc[PipettingMethod],{Infinity,20}]}]]
	},
	{
		If[MatchQ[assoc[TransferType],_Missing],Nothing,BoxForm`SummaryItem[{"TransferType: ",Shallow[assoc[TransferType],{Infinity,20}]}]],
		If[MatchQ[assoc[AspirationRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationRate: ",Shallow[assoc[AspirationRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseRate: ",Shallow[assoc[DispenseRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[OverAspirationVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"OverAspirationVolume: ",Shallow[assoc[OverAspirationVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[OverDispenseVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"OverDispenseVolume: ",Shallow[assoc[OverDispenseVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationWithdrawalRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationWithdrawalRate: ",Shallow[assoc[AspirationWithdrawalRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseWithdrawalRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseWithdrawalRate: ",Shallow[assoc[DispenseWithdrawalRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationEquilibrationTime],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationEquilibrationTime: ",Shallow[assoc[AspirationEquilibrationTime],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseEquilibrationTime],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseEquilibrationTime: ",Shallow[assoc[DispenseEquilibrationTime],{Infinity,20}]}]
		],
		If[MatchQ[assoc[CorrectionCurve],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"CorrectionCurve: ",Shallow[assoc[CorrectionCurve],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationMixRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationMixRate: ",Shallow[assoc[AspirationMixRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseMixRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseMixRate: ",Shallow[assoc[DispenseMixRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationMix],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationMix: ",Shallow[assoc[AspirationMix],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseMix],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseMix: ",Shallow[assoc[DispenseMix],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationMixVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationMixVolume: ",Shallow[assoc[AspirationMixVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseMixVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseMixVolume: ",Shallow[assoc[DispenseMixVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationNumberOfMixes],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationNumberOfMixes: ",Shallow[assoc[AspirationNumberOfMixes],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseNumberOfMixes],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseNumberOfMixes: ",Shallow[assoc[DispenseNumberOfMixes],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationPosition],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationPosition: ",Shallow[assoc[AspirationPosition],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispensePosition],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispensePosition: ",Shallow[assoc[DispensePosition],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationPositionOffset],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationPositionOffset: ",Shallow[assoc[AspirationPositionOffset],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispensePositionOffset],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispensePositionOffset: ",Shallow[assoc[DispensePositionOffset],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DynamicAspiration],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"Dynamic Aspiration: ",Shallow[assoc[DynamicAspiration],{Infinity,20}]}]
		],
		If[MatchQ[assoc[InWellSeparation],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"InWellSeparation: ",Shallow[assoc[InWellSeparation],{Infinity,20}]}]
		]
	},
	StandardForm
];



(* ::Subsubsection::Closed:: *)
(*Consolidation*)


DefineOptions[Consolidation,
	Options :> {
		{
			OptionName -> TransferType,
			Default -> Automatic,
			Description -> "Describes the sample consistency being transferred. Unspecified pipetting parameters may be resolved based on this value.",
			ResolutionDescription -> "Automatically resolves from the destination sample's state.",
			AllowNull -> True,
			Category -> "Pipetting",
			Widget -> Widget[Type->Enumeration,Pattern:>(Liquid|Slurry|Solid)]
		},
		{
			(* Lets the users choose whether the droplets transferred from different samples into the same destination well are spatially separated *)
			OptionName->InWellSeparation,
			Default->Null,
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates how the droplets of different samples are transferred into the same destination well. If True, the droplets are targeted to be spatially separated to avoid mixing with each other until additional volume is added to the well. This option is specific to ExperimentAcousticLiquidHandling.",
			Category->"Acoustic Liquid Handling"
		},
		pipettingParameterOptions
	}
];


installConsolidationPrimitive[]:=MakeBoxes[summary:Consolidation[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	Consolidation,
	summary,
	consolidationImage[],
	{
		If[MatchQ[assoc[Destination],_Missing],Nothing,BoxForm`SummaryItem[{"Destination: ",Shallow[assoc[Destination],{Infinity,20}]}]],
		If[MatchQ[assoc[Sources],_Missing],Nothing,BoxForm`SummaryItem[{"Sources: ",Shallow[assoc[Sources],{Infinity,20}]}]],
		If[MatchQ[assoc[Amounts],_Missing],Nothing,BoxForm`SummaryItem[{"Amounts: ",Shallow[assoc[Amounts],{Infinity,20}]}]],
		If[MatchQ[assoc[Volumes],_Missing],Nothing,BoxForm`SummaryItem[{"Amounts: ",Shallow[assoc[Volumes],{Infinity,20}]}]],
		If[MatchQ[assoc[TipType],_Missing],Nothing,BoxForm`SummaryItem[{"Tip Type: ",Shallow[assoc[TipType],{Infinity,20}]}]],
		If[MatchQ[assoc[TipSize],_Missing],Nothing,BoxForm`SummaryItem[{"Tip Size: ",Shallow[assoc[TipSize],{Infinity,20}]}]],
		If[MatchQ[assoc[PipettingMethod],_Missing],Nothing,BoxForm`SummaryItem[{"PipettingMethod: ",Shallow[assoc[PipettingMethod],{Infinity,20}]}]]
	},
	{
		If[MatchQ[assoc[TransferType],_Missing],Nothing,BoxForm`SummaryItem[{"TransferType: ",Shallow[assoc[TransferType],{Infinity,20}]}]],
		If[MatchQ[assoc[AspirationRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationRate: ",Shallow[assoc[AspirationRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseRate: ",Shallow[assoc[DispenseRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[OverAspirationVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"OverAspirationVolume: ",Shallow[assoc[OverAspirationVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[OverDispenseVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"OverDispenseVolume: ",Shallow[assoc[OverDispenseVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationWithdrawalRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationWithdrawalRate: ",Shallow[assoc[AspirationWithdrawalRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseWithdrawalRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseWithdrawalRate: ",Shallow[assoc[DispenseWithdrawalRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationEquilibrationTime],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationEquilibrationTime: ",Shallow[assoc[AspirationEquilibrationTime],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseEquilibrationTime],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseEquilibrationTime: ",Shallow[assoc[DispenseEquilibrationTime],{Infinity,20}]}]
		],
		If[MatchQ[assoc[CorrectionCurve],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"CorrectionCurve: ",Shallow[assoc[CorrectionCurve],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationMixRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationMixRate: ",Shallow[assoc[AspirationMixRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseMixRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseMixRate: ",Shallow[assoc[DispenseMixRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationMix],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationMix: ",Shallow[assoc[AspirationMix],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseMix],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseMix: ",Shallow[assoc[DispenseMix],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationMixVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationMixVolume: ",Shallow[assoc[AspirationMixVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseMixVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseMixVolume: ",Shallow[assoc[DispenseMixVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationNumberOfMixes],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationNumberOfMixes: ",Shallow[assoc[AspirationNumberOfMixes],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseNumberOfMixes],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseNumberOfMixes: ",Shallow[assoc[DispenseNumberOfMixes],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationPosition],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationPosition: ",Shallow[assoc[AspirationPosition],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispensePosition],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispensePosition: ",Shallow[assoc[DispensePosition],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationPositionOffset],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationPositionOffset: ",Shallow[assoc[AspirationPositionOffset],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispensePositionOffset],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispensePositionOffset: ",Shallow[assoc[DispensePositionOffset],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DynamicAspiration],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"Dynamic Aspiration: ",Shallow[assoc[DynamicAspiration],{Infinity,20}]}]
		],
		If[MatchQ[assoc[InWellSeparation],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"InWellSeparation: ",Shallow[assoc[InWellSeparation],{Infinity,20}]}]
		]
	},
	StandardForm
];



(* ::Subsubsection::Closed:: *)
(*Mix*)


DefineOptions[Mix,
	Options:>{
	{
		OptionName -> MixVolume,
		Widget -> Alternatives[
			Widget[Type->Quantity,Pattern:>GreaterEqualP[0*Microliter],Units->{Microliter,{Microliter,Milliliter,Liter}}],
			Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
		],
		AllowNull -> True,
		Default -> Automatic,
		Description -> "The volume of the sample that should be pipetted up and down to mix if mix Type: Pipette, is chosen.",
		Category->"Pipetting"
	},
	{
		OptionName -> NumberOfMixes,
		Widget -> Alternatives[
			Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
			Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
		],
		AllowNull -> True,
		Default -> Automatic,
		Description -> "Number of times the samples should be mixed if mix Type: Pipette or Invert, is chosen.",
		Category-> "Pipetting"
	},
	{
		OptionName -> MixType,
		Widget -> Alternatives[
			Widget[Type -> Enumeration,Pattern :> MixTypeP],
			Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
		],
		AllowNull -> True,
		Default -> Automatic,
		Description -> "Indicates the style of motion used to mix the sample."
	},
	{
		OptionName -> MixRate,
		Widget -> Alternatives[
			Widget[Type -> Quantity,Pattern :> RangeP[30 RPM,2500 RPM],Units -> RPM],
			Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
		],
		AllowNull -> True,
		Default -> Automatic,
		Description -> "Frequency of rotation the mixing instrument should use to mix the samples."
	},
	{
		OptionName -> MixFlowRate,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[0.4 Microliter/Second,500 Microliter/Second],
			Units -> CompoundUnit[
				{1,{Milliliter,{Microliter,Milliliter,Liter}}},
				{-1,{Second,{Second,Minute}}}
			],
			PatternTooltip -> "The speed at which liquid should be drawn up into the pipette tip."
		],
		AllowNull -> True,
		Default -> Automatic,
		Description -> "The speed at which liquid is aspirated and dispensed in a liquid before it is aspirated.",
		ResolutionDescription->"Automatically resolves to 100 Microliter/Second when mixing by pipetting.",
		Category-> "Pipetting"
	},
	{
		OptionName -> MixPosition,
		Widget -> Widget[
			Type -> Enumeration,
			Pattern :> PipettingPositionP,
			PatternTooltip -> "The location from which liquid should be aspirated."
		],
		AllowNull -> True,
		Default -> Automatic,
		Description -> "The location from which liquid should be mixed by pipetting.",
		ResolutionDescription -> "Automatically resolves to LiquidLevel.",
		Category-> "Pipetting"
	},
	{
		OptionName -> MixPositionOffset,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> GreaterEqualP[0 Millimeter],
			Units -> {Millimeter,{Millimeter}},
			PatternTooltip -> "The distance from the top or bottom of the container, depending on AspirationPosition, from which liquid should be aspirated."
		],
		AllowNull -> True,
		Default -> Automatic,
		Description -> "The distance below the top of the container, above the bottom of the container, or below the liquid level, depending on MixPosition, from which liquid should be mixed.",
		ResolutionDescription -> "Automatically resolves to 2 Millimeter if mixing by pipetting.",
		Category-> "Pipetting"
	},
	{
		OptionName -> CorrectionCurve,
		Widget ->  Adder[
			{
				"Target Volume" -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Microliter, 1000 Microliter],
					Units -> {Microliter,{Microliter,Milliliter}}
				],
				"Actual Volume" -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Microliter, 1250 Microliter],
					Units -> {Microliter,{Microliter,Milliliter}}
				]
			}
		],
		AllowNull -> True,
		Default -> Automatic,
		Description -> "The relationship between a target volume and the corrected volume that needs to be aspirated or dispensed to reach the target volume.",
		ResolutionDescription -> "Automatically resolves to the default correction curve empirically determined for water.",
		Category-> "Pipetting"

	},
	{
		OptionName -> TipType,
		Widget -> Alternatives[
			"Tip Type" -> Widget[
				Type -> Enumeration,
				Pattern :> TipTypeP,
				PatternTooltip -> "The tip type to use to transfer liquid in the manipulation."
			],
			"Tip Model" -> Widget[
				Type -> Object,
				Pattern :> ObjectP[Model[Item,Tips]],
				PatternTooltip -> "The tip model to use to transfer liquid in the manipulation.",
				PreparedContainer -> False
			]
		],
		AllowNull -> True,
		Default -> Automatic,
		Description -> "The tip to use to mix liquid in the manipulation.",
		ResolutionDescription -> "Automatically resolves based on the amount being mixed or TipSize specification.",
		Category-> "Pipetting"
	},
	{
		OptionName -> TipSize,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> GreaterP[0 Microliter],
			Units -> {Microliter,{Microliter,Milliliter}},
			PatternTooltip -> "The maximum volume of the tip used to transfer liquid in the manipulation."
		],
		AllowNull -> True,
		Default -> Automatic,
		Description -> "The maximum volume of the tip used to mix liquid in the manipulation.",
		ResolutionDescription -> "Automatically resolves based on the amount being mixed or the TipType specified.",
		Category-> "Pipetting"
	},
	{
		OptionName -> Instrument,
		Widget -> Alternatives[
			Adder[
				Alternatives[
					Widget[Type -> Object,Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
			Alternatives[
				Widget[Type -> Object,Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
			]
		],
		AllowNull -> True,
		Default -> Automatic,
		Description -> "The instrument used to perform the mix."
	},
	{
		OptionName -> Time,
		Widget -> Widget[Type->Quantity,Pattern :> RangeP[0 Minute,$MaxExperimentTime],Units -> {Minute,{Minute,Second}}],
		AllowNull -> True,
		Default -> Automatic,
		Description -> "Duration of time for which the samples will be incubated."
	},
	{
		OptionName -> MixUntilDissolved,
		Widget -> Alternatives[
			Widget[Type -> Enumeration,Pattern :> BooleanP],
			Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
		],
		AllowNull -> True,
		Default -> Automatic,
		Description -> "Indicates if the mix should be continued up to the MaxTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute."
	},
	{
		OptionName -> MaxNumberOfMixes,
		Widget -> Alternatives[
			Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
			Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
		],
		AllowNull -> True,
		Default -> Automatic,
		Description -> "Maximum number of times for which the samples will be mixed, in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. Note this option only applies for mix type: Pipette or Invert."
	},
	{
		OptionName -> MaxTime,
		Widget -> Alternatives[
			Widget[Type->Quantity,Pattern :> RangeP[0 Minute,$MaxExperimentTime],Units -> {Minute,{Minute,Second}}],
			Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
		],
		AllowNull -> True,
		Default -> Automatic,
		Description -> "Maximum duration of time for which the samples will be mixed, in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. Note this option only applies for mix type: Shake, Roll, Vortex or Sonicate."
	},
	{
		OptionName -> Temperature,
		Widget -> Widget[Type -> Quantity,Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],Units -> Celsius],
		AllowNull -> True,
		Default -> Automatic,
		Description -> "The temperature of the device that should be used to mix/incubate the sample. If mixing via homogenization, the pulse duty cycle of the sonication horn will automatically adjust if the measured temperature of the sample exceeds this set temperature."
	},
	{
		OptionName -> AnnealingTime,
		Widget -> Widget[Type->Quantity,Pattern :> GreaterEqualP[0 Minute],Units -> {Minute,{Minute,Second}}],
		AllowNull -> True,
		Default -> Automatic,
		Description -> "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the Time has passed."
	},
	{
		OptionName -> ResidualIncubation,
		Widget -> Widget[Type -> Enumeration,Pattern :> BooleanP],
		AllowNull -> True,
		Default -> Automatic,
		Description -> "Indicates that the sample(s) should remain incubating at the ResidualTemperature after Time has elapsed."
	},
	{
		OptionName -> ResidualTemperature,
		Widget -> Alternatives[
			Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 80 Celsius],Units -> Celsius],
			Widget[Type -> Enumeration,Pattern :> Alternatives[Ambient,Null]]
		],
		AllowNull -> True,
		Default -> Automatic,
		Description -> 	"The temperature at which the sample(s) should remain incubating after Time has elapsed."
	},
	{
		OptionName -> ResidualMix,
		Widget -> Widget[Type -> Enumeration,Pattern :> BooleanP],
		AllowNull -> True,
		Default -> Automatic,
		Description -> "Indicates that the sample(s) should remain shaking at the ResidualMixRate after Time has elapsed."
	},
	{
		OptionName -> ResidualMixRate,
		Widget -> Widget[Type -> Quantity,Pattern :> RangeP[30 RPM,2500 RPM],Units -> RPM],
		AllowNull -> True,
		Default -> Automatic,
		Description -> "When mixing by shaking, this is the rate at which the sample(s) should remain shaking after Time has elapsed."
	}
}];


installMixPrimitive[]:=MakeBoxes[summary:Mix[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	Mix,
	summary,
	mixImage[],
	{
		If[MatchQ[assoc[Sample],_Missing],Nothing,BoxForm`SummaryItem[{"Sample: ",Shallow[assoc[Sample],{Infinity,20}]}]],
		If[MatchQ[assoc[MixType],_Missing],Nothing,BoxForm`SummaryItem[{"Mix Type: ",Shallow[assoc[MixType],{Infinity,20}]}]],
		If[MatchQ[assoc[Time],_Missing],Nothing,BoxForm`SummaryItem[{"Time: ",Shallow[assoc[Time],{Infinity,20}]}]],
		If[MatchQ[assoc[MixRate],_Missing],Nothing,BoxForm`SummaryItem[{"Rate: ",Shallow[assoc[MixRate],{Infinity,20}]}]],
		If[MatchQ[assoc[NumberOfMixes],_Missing],Nothing,BoxForm`SummaryItem[{"Number of Mixes: ",Shallow[assoc[NumberOfMixes],{Infinity,20}]}]],
		If[MatchQ[assoc[TipType],_Missing],Nothing,BoxForm`SummaryItem[{"Tip Type: ",Shallow[assoc[TipType],{Infinity,20}]}]],
		If[MatchQ[assoc[TipSize],_Missing],Nothing,BoxForm`SummaryItem[{"Tip Size: ",Shallow[assoc[TipSize],{Infinity,20}]}]]
	},
	{
		If[MatchQ[assoc[MixVolume],_Missing],Nothing,BoxForm`SummaryItem[{"Mix Volume: ",Shallow[assoc[MixVolume],{Infinity,20}]}]],
		If[MatchQ[assoc[MixFlowRate],_Missing],Nothing,BoxForm`SummaryItem[{"Mix Flow Rate: ",Shallow[assoc[MixFlowRate],{Infinity,20}]}]],
		If[MatchQ[assoc[MixPosition],_Missing],Nothing,BoxForm`SummaryItem[{"Mix Position: ",Shallow[assoc[MixPosition],{Infinity,20}]}]],
		If[MatchQ[assoc[MixPositionOffset],_Missing],Nothing,BoxForm`SummaryItem[{"Mix Position Offset: ",Shallow[assoc[MixPositionOffset],{Infinity,20}]}]],
		If[MatchQ[assoc[CorrectionCurve],_Missing],Nothing,BoxForm`SummaryItem[{"Correction Curve: ",Shallow[assoc[CorrectionCurve],{Infinity,20}]}]]
	},
	StandardForm
];

(* TEMPORARY OVERLOAD to convert legacy keys to renamed keys *)
Unprotect[Mix];
Mix[assoc_Association]:=((Mix@KeyDrop[
	Prepend[
		assoc,
		{
			If[KeyExistsQ[assoc,Source],
				Sample -> Lookup[assoc,Source],
				Nothing
			],
			If[KeyExistsQ[assoc,MixCount],
				NumberOfMixes -> Lookup[assoc,MixCount],
				Nothing
			],
			If[KeyExistsQ[assoc,MixTime],
				Time -> Lookup[assoc,MixTime],
				Nothing
			]
		}
	],
	{Source,MixCount,MixTime}
])/;Or[KeyExistsQ[assoc,Source],KeyExistsQ[assoc,MixCount],KeyExistsQ[assoc,MixTime]]);
Protect[Mix];



(* ::Subsubsection::Closed:: *)
(*FillToVolume*)


installFillToVolumePrimitive[]:=MakeBoxes[summary:FillToVolume[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	FillToVolume,
	summary,
	filltovolumeImage[],
	{
		If[MatchQ[assoc[Source],_Missing],Nothing,BoxForm`SummaryItem[{"Source: ",Shallow[assoc[Source],{Infinity,20}]}]],
		Switch[assoc[Destination],
			(* If Destination is just a sample, display that information *)
			(ObjectP[]|_String|PlateAndWellP),
				BoxForm`SummaryItem[{"Destination: ",Shallow[assoc[Destination],{Infinity,20}]}],
			(* If Destination is a unique but unspecified modelContainer, display that information *)
			{_,ObjectP[Model[Container]]},
				Unevaluated[Sequence[
					BoxForm`SummaryItem[{"Destination Container: ",Shallow[assoc[Destination],{Infinity,20}][[1]]}],
					BoxForm`SummaryItem[{"Destination Container Model: ",Shallow[assoc[Destination],{Infinity,20}][[2]]}]
				]],
			_,Nothing
		],
		If[MatchQ[assoc[FinalVolume],_Missing],Nothing,BoxForm`SummaryItem[{"FinalVolume: ",Shallow[assoc[FinalVolume],{Infinity,20}]}]]
	},
	{
		If[MatchQ[assoc[TransferType],_Missing],Nothing,BoxForm`SummaryItem[{"TransferType: ",Shallow[assoc[TransferType],{Infinity,20}]}]],
		If[MatchQ[assoc[Method],_Missing],Nothing,BoxForm`SummaryItem[{"Method: ",Shallow[assoc[Method],{Infinity,20}]}]]
	},
	StandardForm
];



(* ::Subsubsection::Closed:: *)
(*Incubate*)


DefineOptions[Incubate,
	Options:>{
		{
			OptionName -> Time,
			Widget -> Widget[Type->Quantity,Pattern :> RangeP[0 Minute,$MaxExperimentTime],Units -> {Minute,{Minute,Second}}],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "Duration of time for which the samples will be incubated."
		},
		{
			OptionName -> Temperature,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],Units -> Celsius],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "The temperature of the device that should be used to mix/incubate the sample. If mixing via homogenization, the pulse duty cycle of the sonication horn will automatically adjust if the measured temperature of the sample exceeds this set temperature."
		},
		{
			OptionName -> MixRate,
			Widget -> Alternatives[
				Widget[Type -> Quantity,Pattern :> RangeP[30 RPM,2500 RPM],Units -> RPM],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
			],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "Frequency of rotation the mixing instrument should use to mix the samples."
		},
		{
			OptionName -> ResidualIncubation,
			Widget -> Widget[Type -> Enumeration,Pattern :> BooleanP],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "Indicates that the sample(s) should remain incubating at the ResidualTemperature after Time has elapsed."
		},
		{
			OptionName -> ResidualTemperature,
			Widget -> Alternatives[
				Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 80 Celsius],Units -> Celsius],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Ambient,Null]]
			],
			AllowNull -> True,
			Default -> Automatic,
			Description -> 	"The temperature at which the sample(s) should remain incubating after Time has elapsed."
		},
		{
			OptionName -> ResidualMix,
			Widget -> Widget[Type -> Enumeration,Pattern :> BooleanP],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "Indicates that the sample(s) should remain shaking at the ResidualMixRate after Time has elapsed."
		},
		{
			OptionName -> ResidualMixRate,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[30 RPM,2500 RPM],Units -> RPM],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "When mixing by shaking, this is the rate at which the sample(s) should remain shaking after Time has elapsed."
		},
		{
			OptionName -> Preheat,
			Widget -> Widget[Type -> Enumeration,Pattern :> BooleanP],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "Indicates if the incubation position should be brought to Temperature before exposing the Sample to it."
		},
		{
			OptionName -> MixType,
			Widget -> Alternatives[
				Widget[Type -> Enumeration,Pattern :> MixTypeP],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
			],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "Indicates the style of motion used to mix the sample."
		},
		{
			OptionName -> Instrument,
			Widget -> Alternatives[
				Adder[
					Alternatives[
						Widget[Type -> Object,Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
					]
				],
				Alternatives[
					Widget[Type -> Object,Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
				]
			],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "The instrument used to perform the incubate."
		},
		{
			OptionName -> MixVolume,
			Widget -> Alternatives[
				Widget[Type->Quantity,Pattern:>GreaterEqualP[0*Microliter],Units->{Microliter,{Microliter,Milliliter,Liter}}],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
			],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "The volume of the sample that should be pipetted up and down to mix if mix Type: Pipette, is chosen.",
			Category->"Pipetting"
		},
		{
			OptionName -> NumberOfMixes,
			Widget -> Alternatives[
				Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
			],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "Number of times the samples should be mixed if mix Type: Pipette or Invert, is chosen.",
			Category-> "Pipetting"
		},
		{
			OptionName -> MixUntilDissolved,
			Widget -> Alternatives[
				Widget[Type -> Enumeration,Pattern :> BooleanP],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
			],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "Indicates if the mix should be continued up to the MaxTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute."
		},
		{
			OptionName -> MaxNumberOfMixes,
			Widget -> Alternatives[
				Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
			],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "Maximum number of times for which the samples will be mixed, in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. Note this option only applies for mix type: Pipette or Invert."
		},
		{
			OptionName -> MaxTime,
			Widget -> Alternatives[
				Widget[Type->Quantity,Pattern :> RangeP[0 Minute,$MaxExperimentTime],Units -> {Minute,{Minute,Second}}],
				Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
			],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "Maximum duration of time for which the samples will be mixed, in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. Note this option only applies for mix type: Shake, Roll, Vortex or Sonicate."
		},
		{
			OptionName -> AnnealingTime,
			Widget -> Widget[Type->Quantity,Pattern :> GreaterEqualP[0 Minute],Units -> {Minute,{Minute,Second}}],
			AllowNull -> True,
			Default -> Automatic,
			Description -> "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the Time has passed."
		}
}];

installIncubatePrimitive[]:=MakeBoxes[summary:Incubate[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	Incubate,
	summary,
	incubateImage[],
	{
		If[MatchQ[assoc[Sample],_Missing],Nothing,BoxForm`SummaryItem[{"Sample: ",Shallow[assoc[Sample],{Infinity,20}]}]],
		If[MatchQ[assoc[Temperature],_Missing],Nothing,BoxForm`SummaryItem[{"Temperature: ",Shallow[assoc[Temperature],{Infinity,20}]}]],
		If[MatchQ[assoc[Time],_Missing],Nothing,BoxForm`SummaryItem[{"Time: ",Shallow[assoc[Time],{Infinity,20}]}]],
		If[MatchQ[assoc[MixRate],_Missing],Nothing,BoxForm`SummaryItem[{"Mix Rate: ",Shallow[assoc[MixRate],{Infinity,20}]}]]
	},
	{
		If[MatchQ[assoc[Mix],_Missing],Nothing,BoxForm`SummaryItem[{"Mix: ",Shallow[assoc[Mix],{Infinity,20}]}]],
		If[MatchQ[assoc[Preheat],_Missing],Nothing,BoxForm`SummaryItem[{"Preheat: ",Shallow[assoc[Preheat],{Infinity,20}]}]],
		If[MatchQ[assoc[ResidualIncubation],_Missing],Nothing,BoxForm`SummaryItem[{"Residual Incubation: ",Shallow[assoc[ResidualIncubation],{Infinity,20}]}]],
		If[MatchQ[assoc[ResidualTemperature],_Missing],Nothing,BoxForm`SummaryItem[{"Residual Temperature: ",Shallow[assoc[ResidualTemperature],{Infinity,20}]}]],
		If[MatchQ[assoc[ResidualMix],_Missing],Nothing,BoxForm`SummaryItem[{"Residual Mix: ",Shallow[assoc[ResidualMix],{Infinity,20}]}]],
		If[MatchQ[assoc[ResidualMixRate],_Missing],Nothing,BoxForm`SummaryItem[{"Residual MixRate: ",Shallow[assoc[ResidualMixRate],{Infinity,20}]}]],
		If[MatchQ[assoc[MixType],_Missing],Nothing,BoxForm`SummaryItem[{"Mix Type: ",Shallow[assoc[MixType],{Infinity,20}]}]],
		If[MatchQ[assoc[Instrument],_Missing],Nothing,BoxForm`SummaryItem[{"Instrument: ",Shallow[assoc[Instrument],{Infinity,20}]}]],
		If[MatchQ[assoc[NumberOfMixes],_Missing],Nothing,BoxForm`SummaryItem[{"Number Of Mixes: ",Shallow[assoc[NumberOfMixes],{Infinity,20}]}]],
		If[MatchQ[assoc[MixVolume],_Missing],Nothing,BoxForm`SummaryItem[{"Mix Volume: ",Shallow[assoc[MixVolume],{Infinity,20}]}]],
		If[MatchQ[assoc[MixUntilDissolved],_Missing],Nothing,BoxForm`SummaryItem[{"Mix Until Dissolved: ",Shallow[assoc[MixUntilDissolved],{Infinity,20}]}]],
		If[MatchQ[assoc[MaxNumberOfMixes],_Missing],Nothing,BoxForm`SummaryItem[{"Max Number Of Mixes: ",Shallow[assoc[MaxNumberOfMixes],{Infinity,20}]}]],
		If[MatchQ[assoc[MaxTime],_Missing],Nothing,BoxForm`SummaryItem[{"Max Time: ",Shallow[assoc[MaxTime],{Infinity,20}]}]],
		If[MatchQ[assoc[AnnealingTime],_Missing],Nothing,BoxForm`SummaryItem[{"Annealing Time: ",Shallow[assoc[AnnealingTime],{Infinity,20}]}]]
	},
	StandardForm
];



(* ::Subsubsection::Closed:: *)
(*Wait*)


installWaitPrimitive[]:=MakeBoxes[summary:Wait[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	Wait,
	summary,
	waitImage[],
	{
		If[MatchQ[assoc[Duration],_Missing],Nothing,BoxForm`SummaryItem[{"Duration: ",assoc[Duration]}]]
	},
	{},
	StandardForm
];



(* ::Subsubsection::Closed:: *)
(*Define*)


DefineOptions[Define,
	Options :> {
		(* Naming information *)
		{
			OptionName -> Sample,
			Default -> Automatic,
			Description -> "The sample or model object or a sample location whose reference name is defined by this Define primitive.",
			ResolutionDescription -> "Automatically resolves from the Container if specified as a vessel or is Null.",
			AllowNull -> True,
			Category -> "Method",
			Widget -> Alternatives[
				Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Sample],Model[Sample]}]
				],
				{
					"Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{
							Object[Container],
							Model[Container]
						}]
					],
					"Well" -> Widget[
						Type -> String,
						Pattern :> WellPositionP,
						Size -> Line
					]
				}
			]
		},
		{
			OptionName -> Container,
			Default -> Automatic,
			Description -> "The container object whose reference name is defined by this Define primitive.",
			ResolutionDescription -> "Automatically resolves from the Sample if specified as a sample or is Null.",
			AllowNull -> True,
			Category -> "Method",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{
					Object[Container],
					Model[Container]
				}]
			]
		},
		{
			OptionName -> Well,
			Default -> Automatic,
			Description -> "The container well of the sample whose reference name is defined by this Define primitive.",
			ResolutionDescription -> "Automatically resolves from the Sample if specified as a sample or is Null.",
			AllowNull -> True,
			Category -> "Method",
			Widget -> Widget[
				Type -> String,
				Pattern :> WellPositionP,
				Size -> Line
			]
		},
		{
			OptionName -> ContainerName,
			Default -> Null,
			Description -> "If a specified sample is named, it's container can be named using this option.",
			AllowNull -> True,
			Category -> "Method",
			Widget -> Widget[
				Type -> String,
				Pattern :> _String,
				Size -> Line
			]
		},
		(* Sample information *)
		{
			OptionName -> Model,
			Default -> Automatic,
			Description -> "If a new sample will be created in the defined position, this option specifies the model of the created sample.",
			ResolutionDescription -> "Automatically resolves at runtime based on the nature of the new sample's sources.",
			AllowNull -> True,
			Category -> "Method",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[Model[Sample]]
			]
		},
		{
			OptionName -> StorageCondition,
			Default -> Automatic,
			Description -> "If a new sample will be created in the defined position, this option specifies the storage condition of the created sample.",
			ResolutionDescription -> "Automatically resolves from SamplesOutStorageCondition option of the protocol.",
			AllowNull -> True,
			Category -> "Method",
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> SampleStorageTypeP
				],
				Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[StorageCondition]],
					OpenPaths -> {{Object[Catalog, "Root"], "Storage Conditions"}}
				]
			]
		},
		{
			OptionName -> ExpirationDate,
			Default -> Automatic,
			Description -> "If a new sample will be created in the defined position, this option specifies the expiration date of the created sample.",
			ResolutionDescription -> "Automatically resolves from the resolved Model's expiration date.",
			AllowNull -> True,
			Category -> "Method",
			Widget -> Widget[
				Type -> Date,
				Pattern :> _?DateObjectQ,
				TimeSelector -> True
			]
		},
		{
			OptionName -> TransportWarmed,
			Default -> Null,
			Description -> "If a new sample will be created in the defined position, this option specifies the temperature at which it should be transported.",
			AllowNull -> True,
			Category -> "Method",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0 Kelvin],
				Units -> Celsius
			]
		},
		{
			OptionName -> SamplesOut,
			Default -> True,
			Description -> "Indicates if a new sample created in the defined position should be included in the SamplesOut field.",
			AllowNull -> True,
			Category -> "Method",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		},
		(* Model Generation Information *)
		{
			OptionName -> ModelName,
			Default -> Null,
			Description -> "If a new sample will be created in the defined position, a new model will be created with this name.",
			AllowNull -> True,
			Category -> "Method",
			Widget -> Widget[
				Type -> String,
				Pattern :> _String,
				Size -> Line
			]
		},
		{
			OptionName -> ModelType,
			Default -> Null,
			Description -> "If a new sample will be created in the defined position, a new model will be created with this type.",
			AllowNull -> True,
			Category -> "Method",
			Widget -> Widget[
				Type -> Expression,
				Pattern :> TypeP[Model[Sample]],
				Size -> Line
			]
		},
		{
			OptionName -> State,
			Default -> Null,
			Description -> "If a new sample will be created in the defined position, a new model will be created with this state.",
			AllowNull -> True,
			Category -> "Method",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> ModelStateP
			]
		},
		{
			OptionName -> Expires,
			Default -> Null,
			Description -> "If a new sample will be created in the defined position, a new model will be created with this expiration value.",
			AllowNull -> True,
			Category -> "Method",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		},
		{
			OptionName -> ShelfLife,
			Default -> Null,
			Description -> "If a new sample will be created in the defined position, a new model will be created with this shelf life.",
			AllowNull -> True,
			Category -> "Method",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0 Day],
				Units -> Day
			]
		},
		{
			OptionName -> UnsealedShelfLife,
			Default -> Null,
			Description -> "If a new sample will be created in the defined position, a new model will be created with this unsealed shelf life.",
			AllowNull -> True,
			Category -> "Method",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0 Day],
				Units -> Day
			]
		},
		{
			OptionName -> DefaultStorageCondition,
			Default -> Automatic,
			Description -> "If a new sample will be created in the defined position, a new model will be created with this storage condition.",
			AllowNull -> True,
			Category -> "Method",
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> SampleStorageTypeP
				],
				Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[StorageCondition]]
				]
			]
		},
		{
			OptionName -> DefaultTransportWarmed,
			Default -> Null,
			Description -> "If a new sample will be created in the defined position, a new model will be created with this default transportation temperature.",
			AllowNull -> True,
			Category -> "Method",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0 Kelvin],
				Units -> Celsius
			]
		}
	}
];



installDefinePrimitive[]:=MakeBoxes[summary:Define[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	Define,
	summary,
	defineImage[],
	{
		If[MatchQ[assoc[Name],_Missing],Nothing,BoxForm`SummaryItem[{"Name: ",assoc[Name]}]],
		If[MatchQ[assoc[Sample],_Missing],Nothing,BoxForm`SummaryItem[{"Sample: ",assoc[Sample]}]],
		If[MatchQ[assoc[ContainerName],_Missing],Nothing,BoxForm`SummaryItem[{"ContainerName: ",assoc[ContainerName]}]],
		If[MatchQ[assoc[Container],_Missing],Nothing,BoxForm`SummaryItem[{"Container: ",assoc[Container]}]],
		If[MatchQ[assoc[Well],_Missing],Nothing,BoxForm`SummaryItem[{"Well: ",assoc[Well]}]]
	},
	{
		If[MatchQ[assoc[Model],_Missing],Nothing,BoxForm`SummaryItem[{"Model: ",assoc[Model]}]],
		If[MatchQ[assoc[StorageCondition],_Missing],Nothing,BoxForm`SummaryItem[{"StorageCondition: ",assoc[StorageCondition]}]],
		If[MatchQ[assoc[ExpirationDate],_Missing],Nothing,BoxForm`SummaryItem[{"ExpirationDate: ",assoc[ExpirationDate]}]],
		If[MatchQ[assoc[TransportWarmed],_Missing],Nothing,BoxForm`SummaryItem[{"TransportWarmed: ",assoc[TransportWarmed]}]],
		If[MatchQ[assoc[SamplesOut],_Missing],Nothing,BoxForm`SummaryItem[{"SamplesOut: ",assoc[SamplesOut]}]],
		If[MatchQ[assoc[ModelType],_Missing],Nothing,BoxForm`SummaryItem[{"ModelType: ",assoc[ModelType]}]],
		If[MatchQ[assoc[ModelName],_Missing],Nothing,BoxForm`SummaryItem[{"ModelName: ",assoc[ModelName]}]],
		If[MatchQ[assoc[State],_Missing],Nothing,BoxForm`SummaryItem[{"State: ",assoc[State]}]],
		If[MatchQ[assoc[Expires],_Missing],Nothing,BoxForm`SummaryItem[{"Expires: ",assoc[Expires]}]],
		If[MatchQ[assoc[ShelfLife],_Missing],Nothing,BoxForm`SummaryItem[{"ShelfLife: ",assoc[ShelfLife]}]],
		If[MatchQ[assoc[UnsealedShelfLife],_Missing],Nothing,BoxForm`SummaryItem[{"UnsealedShelfLife: ",assoc[UnsealedShelfLife]}]],
		If[MatchQ[assoc[DefaultStorageCondition],_Missing],Nothing,BoxForm`SummaryItem[{"DefaultStorageCondition: ",assoc[DefaultStorageCondition]}]],
		If[MatchQ[assoc[DefaultTransportWarmed],_Missing],Nothing,BoxForm`SummaryItem[{"DefaultTransportWarmed: ",assoc[DefaultTransportWarmed]}]]
	},
	StandardForm
];


(* ::Subsubsection::Closed:: *)
(*Filter*)


DefineOptions[Filter,
	Options :> {
		{
			OptionName -> Time,
			Default -> Null,
			Description -> "The duration the specified pressure is applied to the filter plate.",
			AllowNull -> True,
			Category -> "Method",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0 Second],
				Units -> {Second,{Second,Minute}}
			]
		},
		{
			OptionName -> Pressure,
			Default -> Null,
			Description -> "The target pressure applied to the filter.",
			AllowNull -> True,
			Category -> "Method",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0 PSI],
				Units -> {PSI,{PSI,Bar,Pascal}}
			]
		},
		{
			OptionName -> CollectionContainer,
			Default -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
			Description -> "The container in which the filtrate should be collected.",
			AllowNull -> False,
			Category -> "Method",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Container, Plate], Model[Container, Plate]}]
			]
		},
		{
			OptionName->Instrument,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{
				Model[Instrument,FilterBlock],
				Object[Instrument,FilterBlock],
				Model[Instrument,PeristalticPump],
				Object[Instrument,PeristalticPump],
				Model[Instrument,VacuumPump],
				Object[Instrument,VacuumPump],
				Model[Instrument,Centrifuge],
				Object[Instrument,Centrifuge],
				Model[Instrument,SyringePump],
				Object[Instrument,SyringePump]
			}]],
			Description->"The instrument that should be used to perform the filtration.",
			ResolutionDescription->"Will automatically resolve to an instrument appropriate for the filtration type.",
			Category->"Protocol"
		},
		{
			OptionName->Filter,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{
				Model[Container,Plate,Filter],Object[Container,Plate,Filter],
				Model[Container,Vessel,Filter],Object[Container,Vessel,Filter],
				Model[Item,Filter],Object[Item,Filter]
			}]],
			Description->"The filter that should be used to remove impurities from the sample.",
			ResolutionDescription->"Will automatically resolve to a filter appropriate for the filtration type and instrument.",
			Category->"Protocol"
		},
		{
			OptionName->MembraneMaterial,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>FilterMembraneMaterialP],
			Description->"The material from which the filtration membrane should be made of.",
			ResolutionDescription->"Will automatically resolve to PES or to the MembraneMaterial of Filter if it is specified.",
			Category->"Protocol"
		},
		{
			OptionName->PrefilterMembraneMaterial,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>FilterMembraneMaterialP],
			Description->"The material from which the prefilter filtration membrane should be made of.",
			ResolutionDescription->"Will automatically resolve to GxF if a prefilter pore size is specified.",
			Category->"Protocol"
		},
		{
			OptionName->PoreSize,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>FilterSizeP],
			Description->"The pore size of the filter; all particles larger than this should be removed during the filtration.",
			ResolutionDescription->"Will automatically resolve to .22 Micron or to the PoreSize of Filter if it is specified. Will automatically resolve to Null if MolecularWeightCutoff is specified.",
			Category->"Protocol"
		},
		{
			OptionName->MolecularWeightCutoff,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>FilterMolecularWeightCutoffP],
			Description->"The molecular weight cutoff of the filter; all particles larger than this should be removed during the filtration.",
			ResolutionDescription->"Will automatically resolve to Null or to the MolecularWeightCutoff of Filter if it is specified.",
			Category->"Protocol"
		},
		{
			OptionName->Syringe,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{
				Model[Container,Syringe],
				Object[Container,Syringe]
			}]],
			Description->"The syringe used to force that sample through a filter.",
			ResolutionDescription->"Resolves to an syringe appropriate to the volume of sample being filtered.",
			Category->"Protocol"
		},
		{
			OptionName->Sterile,
			Default->False,
			Description->"Indicates if the filtration of the samples should be done in a sterile environment.",
			AllowNull->False,
			Category->"Protocol",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		{
			OptionName->FilterHousing,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{
				Model[Instrument, FilterHousing],
				Object[Instrument, FilterHousing],
				Model[Instrument, FilterBlock],
				Object[Instrument, FilterBlock]
			}]],
			Description->"The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane.",
			ResolutionDescription->"Resolves to an housing capable of holding the size of the membrane being used, if filter with Membrane FilterType is being used.",
			Category->"Protocol"
		},
		(* Macro specific keys *)

		{
			OptionName->FiltrationType,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>FiltrationTypeP],
			Description->"The type of filtration method that should be used to perform the filtration.",
			ResolutionDescription->"Will automatically resolve to a filtration type appropriate for the volume of sample being filtered.",
			Category->"Protocol"
		},
		{
			OptionName->PrefilterPoreSize,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>FilterSizeP],
			Description->"The pore size of the prefilter; all particles larger than this should be removed during the filtration.",
			ResolutionDescription->"Will automatically resolve to .45 Micron if a prefilter membrane material is specified",
			Category->"Protocol"
		},
		{
			OptionName->Temperature,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>GreaterEqualP[4 Celsius],Units->{Celsius,{Celsius,Fahrenheit,Kelvin}}],
			Category->"Protocol",
			Description->"The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration.",
			ResolutionDescription->"Will automatically resolve to 22 Celsius if filtering type is Centrifuge."
		},
			{
				OptionName->Intensity,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					"Speed"->Widget[Type->Quantity,Pattern :> GreaterP[0 RPM],Units->{RPM,{RPM}}],
					"Force"->Widget[Type->Quantity,Pattern :> GreaterP[0 GravitationalAcceleration],Units->{GravitationalAcceleration,{GravitationalAcceleration}}]
				],
				Category->"Protocol",
				Description->"The rotational speed or force at which the samples will be centrifuged during filtration.",
				ResolutionDescription->"Will automatically resolve to 2000 GravitationalAcceleration if filtering type is Centrifuge."
			}
	}
];

installFilterPrimitive[]:=MakeBoxes[summary:Filter[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	Filter,
	summary,
	filterImage[],
	{
		If[MatchQ[assoc[Sample],_Missing],Nothing,BoxForm`SummaryItem[{"Sample: ",Shallow[assoc[Sample],{Infinity,20}]}]],
		If[MatchQ[assoc[Pressure],_Missing],Nothing,BoxForm`SummaryItem[{"Pressure: ",Shallow[assoc[Pressure],{Infinity,20}]}]],
		If[MatchQ[assoc[Time],_Missing],Nothing,BoxForm`SummaryItem[{"Time: ",Shallow[assoc[Time],{Infinity,20}]}]],
		If[MatchQ[assoc[FiltrationType],_Missing],Nothing,BoxForm`SummaryItem[{"Filtration Type: ",Shallow[assoc[FiltrationType],{Infinity,20}]}]],
		If[MatchQ[assoc[Filter],_Missing],Nothing,BoxForm`SummaryItem[{"Filter: ",Shallow[assoc[Filter],{Infinity,20}]}]],
		If[MatchQ[assoc[FilterStorageCondition],_Missing],Nothing,BoxForm`SummaryItem[{"Filter Storage Condition: ",Shallow[assoc[FilterStorageCondition],{Infinity,20}]}]],
		If[MatchQ[assoc[MembraneMaterial],_Missing],Nothing,BoxForm`SummaryItem[{"Membrane Material: ",Shallow[assoc[MembraneMaterial],{Infinity,20}]}]],
		If[MatchQ[assoc[PoreSize],_Missing],Nothing,BoxForm`SummaryItem[{"Pore Size: ",Shallow[assoc[PoreSize],{Infinity,20}]}]],
		If[MatchQ[assoc[Temperature],_Missing],Nothing,BoxForm`SummaryItem[{"Temperature: ",Shallow[assoc[Temperature],{Infinity,20}]}]],
		If[MatchQ[assoc[Intensity],_Missing],Nothing,BoxForm`SummaryItem[{"Intensity: ",Shallow[assoc[Intensity],{Infinity,20}]}]]
	},
	{
		If[MatchQ[assoc[CollectionContainer],_Missing],Nothing,BoxForm`SummaryItem[{"Collection Container: ",Shallow[assoc[CollectionContainer],{Infinity,20}]}]],
		If[MatchQ[assoc[Instrument],_Missing],Nothing,BoxForm`SummaryItem[{"Instrument: ",Shallow[assoc[Instrument],{Infinity,20}]}]],
		If[MatchQ[assoc[FilterHousing],_Missing],Nothing,BoxForm`SummaryItem[{"Filter Housing: ",Shallow[assoc[FilterHousing],{Infinity,20}]}]],
		If[MatchQ[assoc[Syringe],_Missing],Nothing,BoxForm`SummaryItem[{"Syringe: ",Shallow[assoc[Syringe],{Infinity,20}]}]],
		If[MatchQ[assoc[PrefilterMembraneMaterial],_Missing],Nothing,BoxForm`SummaryItem[{"Prefilter Membrane Material: ",Shallow[assoc[PrefilterMembraneMaterial],{Infinity,20}]}]],
		If[MatchQ[assoc[PrefilterPoreSize],_Missing],Nothing,BoxForm`SummaryItem[{"Prefilter Pore Size: ",Shallow[assoc[PrefilterPoreSize],{Infinity,20}]}]],
		If[MatchQ[assoc[MolecularWeightCutoff],_Missing],Nothing,BoxForm`SummaryItem[{"Molecular Weight Cutoff: ",Shallow[assoc[MolecularWeightCutoff],{Infinity,20}]}]],
		If[MatchQ[assoc[Sterile],_Missing],Nothing,BoxForm`SummaryItem[{"Sterile: ",Shallow[assoc[Sterile],{Infinity,20}]}]]
	},
	StandardForm
];



(* ::Subsubsection::Closed:: *)
(*MoveToMagnet*)


installMoveToMagnetPrimitive[]:=MakeBoxes[summary:MoveToMagnet[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	MoveToMagnet,
	summary,
	moveToMagnetImage[],
	{
		If[MatchQ[assoc[Sample],_Missing],Nothing,BoxForm`SummaryItem[{"Sample: ",assoc[Sample]}]]
	},
	{},
	StandardForm
];



(* ::Subsubsection::Closed:: *)
(*RemoveFromMagnet*)


installRemoveFromMagnetPrimitive[]:=MakeBoxes[summary:RemoveFromMagnet[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	RemoveFromMagnet,
	summary,
	removeFromMagnetImage[],
	{
		If[MatchQ[assoc[Sample],_Missing],Nothing,BoxForm`SummaryItem[{"Sample: ",assoc[Sample]}]]
	},
	{},
	StandardForm
];



(* ::Subsubsection::Closed:: *)
(*Centrifuge*)


installCentrifugePrimitive[]:=MakeBoxes[summary:Centrifuge[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	Centrifuge,
	summary,
	centrifugeImage[],
	{
		If[MatchQ[assoc[Sample],_Missing],Nothing,BoxForm`SummaryItem[{"Sample: ",Shallow[assoc[Sample],{Infinity,20}]}]],
		If[MatchQ[assoc[Time],_Missing],Nothing,BoxForm`SummaryItem[{"Time: ",Shallow[assoc[Time],{Infinity,20}]}]],
		If[MatchQ[assoc[Intensity],_Missing],Nothing,BoxForm`SummaryItem[{"Intensity: ",Shallow[assoc[Intensity],{Infinity,20}]}]]
	},
	{
		If[MatchQ[assoc[Instrument],_Missing],Nothing,BoxForm`SummaryItem[{"Instrument: ",Shallow[assoc[Instrument],{Infinity,20}]}]],
		If[MatchQ[assoc[Temperature],_Missing],Nothing,BoxForm`SummaryItem[{"Temperature: ",Shallow[assoc[Temperature],{Infinity,20}]}]]
	},
	StandardForm
];


(* ::Subsubsection::Closed:: *)
(*ReadPlate*)


DefineOptions[ReadPlate,Options:>{
	{
		OptionName->Type,
		Default->Automatic,
		AllowNull->False,
		Description->"The style of plate reading to perform",
		ResolutionDescription->"Automatically set based by considering provided options specific to given types, for instance if PrimaryInjectionTime is set it's assumed that a kinetics experiment is being done.",
		Widget->Widget[Type->Enumeration,Pattern:>ReadPlateTypeP]
	},
	FluorescenceBaseOptions,
	IntensityAndKineticsBaseOptions,
	{
		OptionName->IntegrationTime,
		Default->1 Second,
		Description->"The amount of time over which luminescence measurements should be integrated. Select a higher time to increase the reading intensity.",
		AllowNull->True,
		Category->"Optics",
		Widget->Widget[Type->Quantity,Pattern:>RangeP[0.01 Second,100 Second],Units:>{1,{Second,{Microsecond,Millisecond,Second}}}]
	},
	{
		OptionName->BlankAbsorbance,
		Default->True,
		Description->"Indicates if blank samples are prepared to account for the background signal when reading absorbance of the assay samples.",
		AllowNull->False,
		Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
		Category->"Data Processing"
	},
	{
		OptionName->Blank,
		Default->Automatic,
		AllowNull->True,
		Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}]],
		Description->"The source used to generate a blank sample whose absorbance is subtracted as background from the absorbance readings of the input sample.",
		ResolutionDescription->"Automatically set to Null if BlankAbsorbance is False, and Model[Sample, \"Milli-Q water\"] if BlankAbsorbance is True.",
		Category->"Data Processing"
	},
	{
		OptionName->RunTime,
		Default->45 Minute,
		Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Minute, 24 Hour],Units:>{Hour,{Hour,Minute,Second}}],
		AllowNull->False,
		Description->"The length of time over which fluorescence measurements should be made."
	},
	{
		OptionName->ReadOrder,
		Default->Parallel,
		Description->"Indicates if all measurements and injections should be done for one well before advancing to the next (serial) or in cycles in which each well is read once per cycle (parallel).",
		AllowNull->False,
		Widget->Widget[Type->Enumeration,Pattern:>ReadOrderP]
	},
	{
		OptionName->PlateReaderMixSchedule,
		Default->Automatic,
		Description-> "Indicates the points at which mixing should occur in the plate reader.",
		AllowNull->True,
		Widget->Widget[Type->Enumeration,Pattern:>MixingScheduleP]
	},
	{
		OptionName->PrimaryInjectionTime,
		Default->Null,
		Description->"The time at which the first round of injections should start.",
		AllowNull->True,
		Widget->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Second],Units->Second]
	},
	{
		OptionName->SecondaryInjectionTime,
		Default->Null,
		Description->"The time at which the second round of injections should start.",
		AllowNull->True,
		Widget->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Second],Units->Second]
	},
	{
		OptionName->TertiaryInjectionTime,
		Default->Null,
		Description->"The time at which the third round of injections should start.",
		AllowNull->True,
		Widget->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Second],Units->Second]
	},
	{
		OptionName->QuaternaryInjectionTime,
		Default->Null,
		Description->"The time at which the fourth round of injections should start.",
		AllowNull->True,
		Widget->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Second],Units->Second]
	},
	{
		OptionName->SpectralScan,
		Default->Automatic,
		AllowNull->False,
		Widget->Alternatives[
			Adder[Widget[Type->Enumeration,Pattern:>FluorescenceScanTypeP]],
			Widget[Type->Enumeration,Pattern:>FluorescenceScanTypeP]
		],
		Description->"Indicates if fluorescence should be recorded using a fixed excitation wavelength and a range of emission wavelengths (Emission) or using a fixed emission wavelength and a range of excitation wavelengths (Excitation). Specify Emission and Excitation to record both spectra.",
		ResolutionDescription->"If unspecified uses the emission spectrum if EmissionWavelengthRange is specified and/or the excitation spectrum if ExcitationWavelengthRange is specified, defaulting to measure both spectrum if all options are left Automatic.",
		Category->"Optics"
	},
	{
		OptionName->ExcitationWavelengthRange,
		Default->Automatic,
		AllowNull->True,
		Widget->Span[
			Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
			Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer]
		],
		Description->"Defines the wavelengths which should be used to excite fluorescence in the samples. Fluorescence will then be measured at 'EmissionWavelength'.",
		ResolutionDescription->"If unspecified uses the largest possible range of excitation wavelengths with the constraints that the range must be within the instrument operating limits and below the emission wavelength.",
		Category->"Optics"
	},
	{
		OptionName->EmissionWavelengthRange,
		Default->Automatic,
		AllowNull->True,
		Widget->Span[
			Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
			Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer]
		],
		Description->"Defines the wavelengths at which fluorescence emitted from the sample should be measured after the sample has been excited by 'ExcitationWavelength'.",
		ResolutionDescription->"If unspecified uses the largest possible range of emission wavelengths with the constraints that the range must be within the instrument operating limits and above the excitation wavelength.",
		Category->"Optics"
	},
	{
		OptionName->ExcitationScanGain,
		Default->Automatic,
		Description->"The gain which should be applied to the signal reaching the primary detector during the excitation scan. This may be specified either as a direct voltage, or as a percentage (which indicates that the gain should be set such that the AdjustmentSample fluoresces at that percentage of the instrument's dynamic range).",
		ResolutionDescription->"If unspecified defaults to 90% if an adjustment sample is provided or if the instrument can scan the entire plate to determine gain. Otherwise defaults to 2500 Microvolt",
		AllowNull->True,
		Widget->Alternatives[
			Widget[Type->Quantity,Pattern:>RangeP[0 Percent,95 Percent],Units:>Percent],
			Widget[Type->Quantity,Pattern:>RangeP[0 Microvolt,4095 Microvolt],Units:>Microvolt]
		]
	},
	{
		OptionName->EmissionScanGain,
		Default->Automatic,
		Description->"The gain which should be applied to the signal reaching the primary detector during the emission scan. This may be specified either as a direct voltage, or as a percentage (which indicates that the gain should be set such that the AdjustmentSample fluoresces at that percentage of the instrument's dynamic range).",
		ResolutionDescription->"If unspecified defaults to 90% if an adjustment sample is provided or if the instrument can scan the entire plate to determine gain. Otherwise defaults to 2500 Microvolt",
		AllowNull->True,
		Widget->Alternatives[
			Widget[Type->Quantity,Pattern:>RangeP[0 Percent,95 Percent],Units:>Percent],
			Widget[Type->Quantity,Pattern:>RangeP[0 Microvolt,4095 Microvolt],Units:>Microvolt]
		]
	},
	{
		OptionName->AdjustmentEmissionWavelength,
		Default->Automatic,
		AllowNull->True,
		Widget->Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
		Description->"The wavelength at which fluorescence should be read in order to perform automatic adjustments of gain and focal height values at run time.",
		ResolutionDescription->"If unspecified uses the wavelength in the middle of the requested emission wavelength range if the gain is not being set directly.",
		Category->"Spectral Scanning"
	},
	{
		OptionName->AdjustmentExcitationWavelength,
		Default->Automatic,
		AllowNull->True,
		Widget->Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
		Description->"The wavelength at which the sample should be excited in order to perform automatic adjustments of gain and focal height values at run time.",
		ResolutionDescription->"If unspecified uses the wavelength in the middle of the requested excitation wavelength range if the gain is not being set directly.",
		Category->"Spectral Scanning"
	},
	(* Specific options for ExperimentAlphaScreen *)
	(* Since these options are used for PreparedPlate->True in ExperimentAlphaScreen and experiment function is not called, We probably want to hide these so the user will not see *)
	{
		OptionName->PreResolved,
		Default->False,
		Description->"Indicates if the options for a plate reader experiment are all resolved prior to the ReadPlate call. If PreResolved ->True, the experiment function call is skipped in ReadPlate and the options are passed to compiler directly.",
		AllowNull->True,
		Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
	},
	{
		OptionName->AlphaGain,
		Default->3600 Microvolt,
		Description->"The gain which should be applied to the signal reaching the primary detector photomultiplier tube (PMT) in ExperimentAlphaScreen. This is specified as a direct voltage.",
		AllowNull->False,
		Widget->Alternatives[
			Widget[Type->Quantity,Pattern:>RangeP[1 Microvolt,4095 Microvolt],Units:>Microvolt],
			Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]]
		],
		Category->"Optics"
	},
	{
		OptionName->SettlingTime,
		Default->0 Millisecond,
		Description->"The time between the movement of the plate and the beginning of the measurement. It reduces potential vibration of the samples in plate due to the stop and go motion of the plate carrier.",
		AllowNull->False,
		Widget->Widget[Type->Quantity,Pattern:>RangeP[0 Second,1 Second],Units:>{1,{Second,{Millisecond,Second}}}],
		Category->"Optics"
	},
	{
		OptionName->ExcitationTime,
		Default->80 Millisecond,
		Description->"The time that the samples will be excited by the light source and the singlet Oxygen is generated.",
		AllowNull->False,
		Widget->Widget[Type->Quantity,Pattern:>RangeP[0.01 Second,1 Second],Units:>{1,{Second,{Millisecond,Second}}}],
		Category->"Optics"
	},
	BMGSamplingOptions
}];


installReadPlatePrimitive[]:=MakeBoxes[summary:ReadPlate[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	ReadPlate,
	summary,
	readPlateImage[],
	{
		If[MatchQ[assoc[Sample],_Missing],Nothing,BoxForm`SummaryItem[{"Sample: ",Shallow[assoc[Sample],{Infinity,20}]}]],
		If[MatchQ[assoc[Type],_Missing],Nothing,BoxForm`SummaryItem[{"Type: ",assoc[Type]}]],
		If[MatchQ[assoc[Data],_Missing],Nothing,BoxForm`SummaryItem[{"Data: ",assoc[Data]}]],
		If[MatchQ[assoc[BlankData],_Missing|{}],Nothing,BoxForm`SummaryItem[{"Blank Data: ",assoc[BlankData]}]]
	},
	{
		If[MatchQ[assoc[Blank],_Missing|{}],Nothing,BoxForm`SummaryItem[{"Blank: ",assoc[Blank]}]],
		If[MatchQ[assoc[Wavelength],_Missing],Nothing,BoxForm`SummaryItem[{"Wavelength: ",assoc[Wavelength]}]],
		If[MatchQ[assoc[ExcitationWavelength],_Missing],Nothing,BoxForm`SummaryItem[{"Excitation Wavelength: ",assoc[ExcitationWavelength]}]],
		If[MatchQ[assoc[EmissionWavelength],_Missing],Nothing,BoxForm`SummaryItem[{"Emission Wavelength: ",assoc[EmissionWavelength]}]],

		If[MatchQ[assoc[RunTime],_Missing],Nothing,BoxForm`SummaryItem[{"RunTime: ",assoc[RunTime]}]],
		If[MatchQ[assoc[Temperature],_Missing],Nothing,BoxForm`SummaryItem[{"Temperature: ",assoc[Temperature]}]],
		If[MatchQ[assoc[PlateReaderMix],_Missing],Nothing,BoxForm`SummaryItem[{"Plate Reader Mixing: ",assoc[PlateReaderMix]}]],
		If[MatchQ[assoc[NumberOfReadings],_Missing],Nothing,BoxForm`SummaryItem[{"Number Of Readings: ",assoc[NumberOfReadings]}]],

		If[MatchQ[assoc[Temperature],_Missing],Nothing,BoxForm`SummaryItem[{"Temperature: ",assoc[Temperature]}]],
		If[MatchQ[assoc[EquilibrationTime],_Missing],Nothing,BoxForm`SummaryItem[{"EquilibrationTime: ",assoc[EquilibrationTime]}]],

		If[MatchQ[assoc[SamplingPattern],_Missing|Null],Nothing,BoxForm`SummaryItem[{"SamplingPattern: ",assoc[SamplingPattern]}]],
		If[MatchQ[assoc[SamplingDistance],_Missing|Null],Nothing,BoxForm`SummaryItem[{"SamplingDistance: ",assoc[SamplingDistance]}]],
		If[MatchQ[assoc[SamplingDimension],_Missing|Null],Nothing,BoxForm`SummaryItem[{"SamplingDimension: ",assoc[SamplingDimension]}]]
	},
	StandardForm
];


(* ::Subsubsection::Closed:: *)
(*Pellet*)


installPelletPrimitive[]:=MakeBoxes[summary:Pellet[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	Pellet,
	summary,
	pelletImage[],
	(
		If[MatchQ[assoc[#],_Missing],Nothing,BoxForm`SummaryItem[{ToString[#]<>": ",Shallow[assoc[#],{Infinity,20}]}]]
	&)/@{Sample, Time, Intensity, SupernatantVolume},
	(
		If[MatchQ[assoc[#],_Missing],Nothing,BoxForm`SummaryItem[{ToString[#]<>": ",Shallow[assoc[#],{Infinity,20}]}]]
	&)/@{
		Instrument, Temperature, SupernatantVolume, SupernatantDestination,
		SupernatantTransferInstrument, ResuspensionSource,
		ResuspensionVolume, ResuspensionInstrument, ResuspensionMix,
		ResuspensionMixType, ResuspensionMixUntilDissolved,
		ResuspensionMixInstrument, ResuspensionMixTime,
		ResuspensionMixMaxTime, ResuspensionMixDutyCycle,
		ResuspensionMixRate, ResuspensionNumberOfMixes,
		ResuspensionMaxNumberOfMixes, ResuspensionMixVolume,
		ResuspensionMixTemperature, ResuspensionMixMaxTemperature,
		ResuspensionMixAmplitude
	},
	StandardForm
];



(* ::Subsubsection::Closed:: *)
(*Cover*)


DefineOptions[Cover,
	Options :> {
		(* Naming information *)
		{
			OptionName -> Sample,
			Default -> Null,
			Description -> "The sample or model object or a sample location who will be covered by this primitive.",
			AllowNull -> True,
			Category -> "Method",
			Widget -> Alternatives[
				Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Sample],Model[Sample]}]
				],
				{
					"Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{
							Object[Container],
							Model[Container]
						}]
					],
					"Well" -> Widget[
						Type -> String,
						Pattern :> WellPositionP,
						Size -> Line
					]
				}
			]
		},
		{
			OptionName -> Cover,
			Default -> Automatic,
			Description -> "The cover item which is put on top of the sample.",
			ResolutionDescription -> "Automatically resolves to a default lid for the sample's container model.",
			AllowNull -> True,
			Category -> "Method",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{
					Object[Container],
					Model[Container]
				}]
			]
		}
	}
];



installCoverPrimitive[]:=MakeBoxes[summary:Cover[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	Cover,
	summary,
	coverImage[],
	{
		If[MatchQ[assoc[Sample],_Missing],Nothing,BoxForm`SummaryItem[{"Sample: ",assoc[Sample]}]],
		If[MatchQ[assoc[Cover],_Missing],Nothing,BoxForm`SummaryItem[{"Cover: ",assoc[Cover]}]]
	},
	{},
	StandardForm
];


(* ::Subsubsection::Closed:: *)
(*Cover*)


DefineOptions[Uncover,
	Options :> {
		(* Naming information *)
		{
			OptionName -> Sample,
			Default -> Null,
			Description -> "The sample or model object or a sample location who will be uncovered by this primitive.",
			AllowNull -> True,
			Category -> "Method",
			Widget -> Alternatives[
				Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Sample],Model[Sample]}]
				],
				{
					"Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{
							Object[Container],
							Model[Container]
						}]
					],
					"Well" -> Widget[
						Type -> String,
						Pattern :> WellPositionP,
						Size -> Line
					]
				}
			]
		}
	}
];



installUncoverPrimitive[]:=MakeBoxes[summary:Uncover[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	Uncover,
	summary,
	uncoverImage[],
	{If[MatchQ[assoc[Sample],_Missing],Nothing,BoxForm`SummaryItem[{"Sample: ",assoc[Sample]}]]},
	{},
	StandardForm
];

(* ::Subsection:: *)
(*General Patterns*)


(* ::Subsubsection:: *)
(*primitiveQ*)


(* ::Subsubsection::Closed:: *)
(*Primitive Key Patterns*)


(* a plate model must be associated with a well, and can also be tagged for uniqueness *)
modelPlateP={ObjectP[Model[Container,Plate]]|{_Integer|_Symbol,ObjectP[Model[Container,Plate]]},WellPositionP};

(* a vessel model should not have a well associated, but may have a uniqueness symbol tag prefixed *)
modelVesselP=Alternatives[
	ObjectP[Model[Container,Vessel]],
	{_Integer|_Symbol,ObjectP[Model[Container,Vessel]]},
	ObjectP[Model[Container,Cartridge]],
	{_Integer|_Symbol,ObjectP[Model[Container,Cartridge]]},
	ObjectP[Model[Container,ReactionVessel]],
	{_Integer|_Symbol,ObjectP[Model[Container,ReactionVessel]]},
	ObjectP[Model[Container,Cuvette]],
	{_Integer|_Symbol,ObjectP[Model[Container,Cuvette]]}
];

(* a sample model to serve as a Source *)
modelP=(NonSelfContainedSampleModelP|{_Integer|_Symbol,NonSelfContainedSampleModelP});

objectSpecificationP:=(objectSpecificationP=Alternatives[
	NonSelfContainedSampleP,
	NonSelfContainedSampleModelP,
	FluidContainerP,
	FluidContainerModelP,
	PlateAndWellP,
	{ObjectP[Model[Container,Plate]],WellPositionP},
	(* Defined tag *)
	_String,
	(* Container tag *)
	{_String,WellPositionP},
	{_Integer|_Symbol,NonSelfContainedSampleModelP|FluidContainerP|FluidContainerModelP},
	{{_Integer|_Symbol,FluidContainerP|FluidContainerModelP},WellPositionP}
]);

objectSpecificationNoModelP:=(objectSpecificationNoModelP=Alternatives[
	NonSelfContainedSampleP,
	FluidContainerP,
	PlateAndWellP,
	(* Defined tag *)
	_String,
	(* Container tag *)
	{_String,WellPositionP},
	{_Integer|_Symbol,NonSelfContainedSampleModelP|FluidContainerP|FluidContainerModelP},
	{{_Integer|_Symbol,FluidContainerP|FluidContainerModelP},WellPositionP}
]);

manipulationKeyPatterns[Transfer]:=(manipulationKeyPatterns[Transfer]=Join[
	Association[
		Source -> objectSpecificationP,
		Destination -> objectSpecificationP,
		Amount -> (GreaterEqualP[0 Microliter]|GreaterEqualP[0 Gram]|GreaterEqualP[0, 1]),
		Resuspension -> BooleanP|Automatic,
		TransferType -> (Liquid|Slurry|Solid|Automatic),
		DeviceChannel -> Alternatives[
			MultiProbeHead,
			SingleProbe1,
			SingleProbe2,
			SingleProbe3,
			SingleProbe4,
			SingleProbe5,
			SingleProbe6,
			SingleProbe7,
			SingleProbe8
		],
		InWellSeparation -> BooleanP
	],
	pipettingParameterSet
]);

manipulationKeyPatterns[Aliquot]:=(manipulationKeyPatterns[Aliquot]=Join[
	Association[
		Source -> objectSpecificationP,
		Destinations -> {objectSpecificationP..},
		Amounts -> ListableP[(GreaterEqualP[0 Microliter]|GreaterEqualP[0 Gram]|GreaterEqualP[0, 1])],
		TransferType -> (Liquid|Slurry|Solid),
		InWellSeparation -> BooleanP
	],
	pipettingParameterSet
]);
manipulationKeyPatterns[Resuspend]:=(manipulationKeyPatterns[Resuspend]=Join[
	Association[
		Sample -> objectSpecificationP,
		Volume -> GreaterEqualP[0 Microliter],
		Diluent -> objectSpecificationP,
		Mix -> BooleanP,
		MixType -> ListableP[Null|MixTypeP],
		MixUntilDissolved -> ListableP[BooleanP],
		MixVolume -> ListableP[RangeP[1 Microliter, 50 Milliliter]|Null],
		NumberOfMixes -> ListableP[RangeP[1, 50, 1]|Null],
		MaxNumberOfMixes ->  ListableP[RangeP[1, 50, 1]|Null],
		(* Time and Temperature need to allow Null in case we're mixing by Pipette/Inversion *)
		IncubationTime -> ListableP[RangeP[0 Minute,72 Hour] | Null],
		MaxIncubationTime -> ListableP[RangeP[0 Minute,72 Hour]|Null],
		IncubationInstrument -> ListableP[
			ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]|Null],
			IncubationTemperature -> ListableP[Ambient | TemperatureP | Null],
			AnnealingTime -> ListableP[GreaterEqualP[0 Minute]|Null]
	],
	pipettingParameterSet
]);
manipulationKeyPatterns[Consolidation]:=(manipulationKeyPatterns[Consolidation]=Join[
	Association[
		Sources -> {objectSpecificationP..},
		Destination -> objectSpecificationP,
		Amounts -> {(GreaterEqualP[0 Microliter]|GreaterEqualP[0 Gram]|GreaterEqualP[0, 1])..},
		TransferType -> (Liquid|Slurry|Solid),
		InWellSeparation -> BooleanP
	],
	pipettingParameterSet
]);

manipulationKeyPatterns[FillToVolume]:=(manipulationKeyPatterns[FillToVolume]=Association[
	Source -> objectSpecificationP,
	Destination -> objectSpecificationP,
	FinalVolume -> GreaterEqualP[0 Microliter],
	TransferType -> Liquid,
	Method -> FillToVolumeMethodP
]);

manipulationKeyPatterns[Incubate|Mix]:=(manipulationKeyPatterns[Incubate|Mix]=Association[
	(* Incubate keys shared among the different scales *)
	Sample -> ListableP[objectSpecificationNoModelP],
	(* Time and Temperature need to allow Null in case we're mixing by Pipette/Inversion *)
	Time -> ListableP[RangeP[0 Minute,$MaxExperimentTime] | Null],
	Temperature -> ListableP[Ambient | TemperatureP | Null],
	MixRate -> ListableP[RPMP|Null],
	ResidualIncubation -> ListableP[BooleanP],
	ResidualTemperature -> ListableP[Ambient|TemperatureP|Null],
	ResidualMix -> ListableP[BooleanP],
	ResidualMixRate -> ListableP[RPMP|Null],
	(* Incubate keys specific to MicroLiquidHandling *)
	Preheat -> ListableP[BooleanP],
	(* Incubate keys specific to MacroLiquidHandling *)
	Mix -> ListableP[BooleanP],
	MixType -> ListableP[Null|MixTypeP],
	Instrument -> ListableP[ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]|Null],
	NumberOfMixes -> ListableP[RangeP[1, 50, 1]|Null],
	MixVolume -> ListableP[RangeP[1 Microliter, 50 Milliliter]|Null],
	MixUntilDissolved -> ListableP[BooleanP],
	MaxNumberOfMixes ->  ListableP[RangeP[1, 50, 1]|Null],
	MaxTime -> ListableP[RangeP[0 Minute,$MaxExperimentTime]|Null],
	AnnealingTime -> ListableP[GreaterEqualP[0 Minute]|Null],
	(* Mix borrows this key from the pipetting parameters but since there isn't
	really a concept of aspiration/dispense for mix-by-pipette, fold into one key *)
	MixFlowRate -> (RangeP[0.4 Microliter/Second,500 Microliter/Second]|Automatic),
	MixPosition -> (PipettingPositionP|Automatic),
	MixPositionOffset -> (GreaterEqualP[0 Millimeter]|Automatic),
	CorrectionCurve -> Alternatives[
		{{RangeP[0 Microliter, 1000 Microliter],RangeP[0 Microliter, 1250 Microliter]}...},
		Automatic,
		Null
	],
	TipType -> Alternatives[
		Automatic,
		TipTypeP,
		(* Specific tip model *)
		ObjectP[Model[Item,Tips]]
	],
	TipSize -> Automatic|VolumeP,
	DeviceChannel -> ListableP[Alternatives[
		MultiProbeHead,
		SingleProbe1,
		SingleProbe2,
		SingleProbe3,
		SingleProbe4,
		SingleProbe5,
		SingleProbe6,
		SingleProbe7,
		SingleProbe8
	]]
]);


manipulationKeyPatterns[Wait]:=(manipulationKeyPatterns[Wait]=Association[
	Duration -> GreaterEqualP[0 Second]
]);

manipulationKeyPatterns[Define]:=(manipulationKeyPatterns[Define]=Association[
	Name -> _String,
	Sample -> Alternatives[
		ObjectP[{Object[Sample],Model[Sample]}],
		{
			ObjectP[{Object[Container],Model[Container]}]|_String,
			WellPositionP
		},
		Null,
		Automatic
	],
	Container -> ObjectP[{Object[Container],Model[Container]}]|Null|Automatic,
	Well -> WellPositionP|Automatic,
	ContainerName -> _String|Null,
	Model -> ObjectP[Model[Sample]]|Null|Automatic,
	StorageCondition -> SampleStorageTypeP|ObjectP[Model[StorageCondition]]|Null|Automatic,
	ExpirationDate -> _?DateObjectQ|Null|Automatic,
	TransportWarmed -> GreaterP[0 Kelvin]|Null|Automatic,
	SamplesOut -> BooleanP,
	ModelType -> TypeP[Model[Sample]]|Null,
	ModelName -> _String|Null,
	State -> ModelStateP|Null,
	Expires -> BooleanP|Null,
	ShelfLife -> GreaterP[0 Day]|Null,
	UnsealedShelfLife -> GreaterP[0 Day]|Null,
	DefaultStorageCondition -> SampleStorageTypeP|ObjectP[Model[StorageCondition]]|Null|Automatic,
	DefaultTransportWarmed -> GreaterP[0 Kelvin]|Null
]);


manipulationKeyPatterns[Filter]:=(manipulationKeyPatterns[Filter]=Association[
	(* shared keys among Micro and Macro *)
	Sample -> ListableP[objectSpecificationP],
	(* note that Time is the time to apply pressure in Micro, and the time to centrifuge in Macro *)
	Time -> TimeP,
	CollectionContainer -> Automatic|ListableP[objectSpecificationP],
	CollectionSample -> ListableP[objectSpecificationP]|Null,
	(* Micro specific keys *)
	Pressure -> RangeP[1 PSI, 40 PSI]|Null,
	(*
	FiltrateModel -> ListableP[ObjectP[Model[Sample]]|Null|Automatic],
	ResidueModel -> ListableP[ObjectP[Model[Sample]]|Null|Automatic],
	CollectResidue -> ListableP[Automatic|BooleanP],
	ResidueCollectionSolvent -> ListableP[objectSpecificationP],
	ResidueCollectionDestination -> ListableP[objectSpecificationP],
	ResidueCollectionVolume -> ListableP[Null|VolumeP]
	*)
	(* Macro specific keys *)
	Filter -> Automatic|ListableP[_String]|ListableP[ObjectP[{
		Model[Container, Plate, Filter],
		Object[Container, Plate, Filter],
		Model[Container, Vessel, Filter],
		Object[Container, Vessel, Filter],
		Model[Item,Filter],
		Object[Item,Filter]
	}]],
	FilterStorageCondition->(SampleStorageTypeP|Disposal|ObjectP[Model[StorageCondition]]),
	MembraneMaterial -> Automatic|FilterMembraneMaterialP,
	PoreSize -> Automatic|FilterSizeP,
	FiltrationType -> Automatic|FiltrationTypeP,
	Instrument -> Automatic| ObjectP[{
		Model[Instrument,FilterBlock],
		Object[Instrument,FilterBlock],
		Model[Instrument,PeristalticPump],
		Object[Instrument,PeristalticPump],
		Model[Instrument,VacuumPump],
		Object[Instrument,VacuumPump],
		Model[Instrument,Filter],
		Model[Instrument,Centrifuge],
		Object[Instrument,Centrifuge],
		Model[Instrument,SyringePump],
		Object[Instrument,SyringePump]
	}],
	FilterHousing -> Automatic | Null | ObjectP[{
		Model[Instrument,FilterHousing],
		Object[Instrument,FilterHousing],
		Model[Instrument, FilterBlock],
		Object[Instrument, FilterBlock]
	}],
	Syringe -> Automatic | Null | ObjectP[{
		Model[Container,Syringe],
		Object[Container,Syringe]
	}],
	Sterile -> BooleanP,
	MolecularWeightCutoff -> Automatic | Null | FilterMolecularWeightCutoffP,
	PrefilterMembraneMaterial -> Automatic | Null | FilterMembraneMaterialP,
	PrefilterPoreSize -> Automatic | Null | FilterSizeP,
	Temperature -> Automatic | Null | GreaterEqualP[4 Celsius],
	Intensity -> Automatic | Null | GreaterP[0 RPM] | GreaterP[0 GravitationalAcceleration],
	CounterbalanceWeight -> Automatic  | {RangeP[0 Gram, 500 Gram]..}
]);

manipulationKeyPatterns[MoveToMagnet]:=(manipulationKeyPatterns[MoveToMagnet]=Association[
	Sample->objectSpecificationP
]);

manipulationKeyPatterns[RemoveFromMagnet]:=(manipulationKeyPatterns[RemoveFromMagnet]=Association[
	Sample->objectSpecificationP
]);

manipulationKeyPatterns[Centrifuge]:=(manipulationKeyPatterns[Centrifuge]=Association[
	Sample -> ListableP[objectSpecificationP],
	Instrument -> ListableP[Automatic | ObjectP[{Model[Instrument,Centrifuge],Object[Instrument,Centrifuge]}]],
	Intensity -> ListableP[Automatic | GreaterP[0 RPM] | GreaterP[0 GravitationalAcceleration]],
	Time -> ListableP[Automatic | TimeP],
	Temperature -> ListableP[Automatic | Ambient | RangeP[4 Celsius,40 Celsius]],
	CollectionContainer -> ListableP[objectSpecificationP],
	CounterbalanceWeight -> Automatic | {RangeP[0 Gram, 500 Gram]..}
]);

manipulationKeyPatterns[Pellet]:=(manipulationKeyPatterns[Pellet]=Association@List[
	Sample -> ListableP[objectSpecificationP],
	Instrument -> ListableP[Automatic | ObjectP[{Model[Instrument,Centrifuge],Object[Instrument,Centrifuge]}]],
	Intensity -> ListableP[Automatic | GreaterP[0 RPM] | GreaterP[0 GravitationalAcceleration]],
	Time -> ListableP[Automatic | TimeP],
	Temperature -> ListableP[Automatic | Ambient | RangeP[4 Celsius,40 Celsius]],

	SupernatantDestination->ListableP[objectSpecificationP|Waste],
	ResuspensionSource->ListableP[objectSpecificationP],

	(* Copy over the options from ExperimentPellet. *)
	Sequence@@(#->Automatic|ReleaseHold[Lookup[FirstCase[OptionDefinition[ExperimentPellet], KeyValuePattern["OptionSymbol" -> #]], "Pattern"]]&)/@{
		SupernatantVolume, SupernatantTransferInstrument,
		ResuspensionVolume, ResuspensionInstrument, ResuspensionMix,
		ResuspensionMixType, ResuspensionMixUntilDissolved,
		ResuspensionMixInstrument, ResuspensionMixTime,
		ResuspensionMixMaxTime, ResuspensionMixDutyCycle,
		ResuspensionMixRate, ResuspensionNumberOfMixes,
		ResuspensionMaxNumberOfMixes, ResuspensionMixVolume,
		ResuspensionMixTemperature, ResuspensionMixMaxTemperature,
		ResuspensionMixAmplitude
	}
]);


manipulationKeyPatterns[ReadPlate]:=(manipulationKeyPatterns[ReadPlate]=Association[
	Sample -> ListableP[objectSpecificationP],
	Blank -> ListableP[objectSpecificationP],
	Type -> ReadPlateTypeP,
	Mode -> (Fluorescence|TimeResolvedFluorescence|Automatic),
	Wavelength -> Alternatives[
		ListableP[RangeP[220 Nanometer, 1000 Nanometer]],
		Span[RangeP[220 Nanometer, 1000 Nanometer],RangeP[220 Nanometer, 1000 Nanometer]],
		All,
		Automatic
	],
	BlankAbsorbance -> BooleanP,
	ExcitationWavelength -> ListableP[RangeP[320 Nanometer,740 Nanometer]|Automatic],
	EmissionWavelength -> ListableP[RangeP[320 Nanometer,740 Nanometer]|Automatic],
	WavelengthSelection -> (WavelengthSelectionP|Automatic),
	PrimaryInjectionSample -> ListableP[ObjectP[{Object[Sample],Model[Sample]}]|Null],
	SecondaryInjectionSample -> ListableP[ObjectP[{Object[Sample],Model[Sample]}]|Null],
	TertiaryInjectionSample -> ListableP[ObjectP[{Object[Sample],Model[Sample]}]|Null],
	QuaternaryInjectionSample -> ListableP[ObjectP[{Object[Sample],Model[Sample]}]|Null],
	PrimaryInjectionVolume -> ListableP[RangeP[0.5 Microliter,300 Microliter]|Null],
	SecondaryInjectionVolume -> ListableP[RangeP[0.5 Microliter,300 Microliter]|Null],
	TertiaryInjectionVolume -> ListableP[RangeP[0.5 Microliter,300 Microliter]|Null],
	QuaternaryInjectionVolume -> ListableP[RangeP[0.5 Microliter,300 Microliter]|Null],
	Gain -> ListableP[Alternatives[
		RangeP[1 Percent,95 Percent],
		RangeP[1 Microvolt,4095 Microvolt],
		Automatic
	]],
	DelayTime -> RangeP[0 Microsecond,2 Second]|Automatic,
	ReadTime -> RangeP[1 Microsecond,10000 Microsecond]|Automatic,
	ReadLocation -> ReadLocationP|Automatic,
	Temperature -> Ambient|RangeP[$AmbientTemperature,45 Celsius]|Null,
	EquilibrationTime -> RangeP[0 Minute,1 Hour],
	NumberOfReadings -> RangeP[1,200],
	AdjustmentSample -> FullPlate|objectSpecificationP|Automatic,
	FocalHeight -> RangeP[0 Millimeter,25 Millimeter]|Auto|Automatic,
	PrimaryInjectionFlowRate -> BMGFlowRateP|Automatic,
	SecondaryInjectionFlowRate -> BMGFlowRateP|Automatic,
	TertiaryInjectionFlowRate -> BMGFlowRateP|Automatic,
	QuaternaryInjectionFlowRate -> BMGFlowRateP|Automatic,
	PlateReaderMix -> BooleanP|Automatic,
	PlateReaderMixTime -> RangeP[1 Second,1 Hour]|Automatic|Null,
	PlateReaderMixRate -> RangeP[100 RPM,700 RPM]|Automatic|Null,
	PlateReaderMixMode -> MechanicalShakingP|Automatic|Null,
	ReadDirection -> ReadDirectionP,
	InjectionSampleStorageCondition -> SampleStorageTypeP|Disposal|Null,
	RunTime -> GreaterP[0 Second],
	ReadOrder -> ReadOrderP,
	PlateReaderMixSchedule -> MixingScheduleP|Automatic|Null,
	PrimaryInjectionTime -> GreaterEqualP[0 Second],
	SecondaryInjectionTime -> GreaterEqualP[0 Second],
	TertiaryInjectionTime -> GreaterEqualP[0 Second],
	QuaternaryInjectionTime -> GreaterEqualP[0 Second],
	SpectralScan -> ListableP[FluorescenceScanTypeP|Automatic],
	ExcitationWavelengthRange -> Alternatives[
		Span[RangeP[320 Nanometer,740 Nanometer],RangeP[320 Nanometer,740 Nanometer]],
		Automatic
	],
	EmissionWavelengthRange -> Alternatives[
		Span[RangeP[320 Nanometer,740 Nanometer],RangeP[320 Nanometer,740 Nanometer]],
		Automatic
	],
	ExcitationScanGain -> Alternatives[
		RangeP[0 Percent,95 Percent],
		RangeP[0 Microvolt,4095 Microvolt],
		Automatic
	],
	EmissionScanGain -> Alternatives[
		RangeP[0 Percent,95 Percent],
		RangeP[0 Microvolt,4095 Microvolt],
		Automatic
	],
	AdjustmentEmissionWavelength -> RangeP[320 Nanometer,740 Nanometer]|Automatic,
	AdjustmentExcitationWavelength -> RangeP[320 Nanometer,740 Nanometer]|Automatic,
	IntegrationTime -> RangeP[0.01 Second,100 Second],
	QuantificationWavelength -> ListableP[RangeP[0 Nanometer, 1000 Nanometer]|Automatic],
	QuantifyConcentration -> ListableP[BooleanP|Automatic],
	(* Additional patterns for ExperimentAlphaScreen *)
	PreResolved -> BooleanP,
	AlphaGain -> RangeP[1 Microvolt,4095 Microvolt],
	SettlingTime -> RangeP[0 Second,1 Second],
	ExcitationTime -> RangeP[0.01 Second,1 Second],

	(* Sampling Options for all *)
	SamplingPattern -> PlateReaderSamplingP,
	SamplingDimension -> RangeP[2, 30],
	SamplingDistance -> RangeP[1 Millimeter, 6 Millimeter]
]);

manipulationKeyPatterns[Cover]:=(manipulationKeyPatterns[Cover]=Association[
	Sample -> ListableP[objectSpecificationP],
	Cover -> ListableP[Automatic|ObjectP[{Object[Item,Lid],Model[Item,Lid]}]]
]);

manipulationKeyPatterns[Uncover]:=(manipulationKeyPatterns[Uncover]=Association[
	Sample -> ListableP[objectSpecificationP]
]);

(*ExperimentSampleManipulation*)


(* ::Subsubsection::Closed:: *)
(*ExperimentSampleManipulation Options and Messages*)


DefineOptions[ExperimentSampleManipulation,
	Options:>{
	(* none of these options is indexmatched with the input *)
		{
			OptionName->LiquidHandlingScale,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>LiquidHandlingScaleP],
			Description->"Indicates the desired scale at which liquid handling will occur.",
			ResolutionDescription->"Automatic resolution will occur based on manipulation volumes and container types.",
			Category->"Protocol"
		},
		{
			OptionName->OptimizePrimitives,
			Default->True,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Description->"Indicates that input liquid-handling primitives can be modified and merged to be most efficient for the instrument executing the liquid transfers. Optimization will not modify the order of primitives or their source(s), destination(s), and amount(s).",
			Category->"Protocol"
		},
		{
		(* TODO: rename into "Instrument" since we're only using one Instrument for this experiment. Make sure to only rename the option and not any variable *)
			OptionName->LiquidHandler,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{
				Model[Instrument,LiquidHandler],
				Object[Instrument,LiquidHandler]
			}]],
			Description->"Indicates the liquid handler which should be used to perform the provided manipulations.",
			ResolutionDescription->"Automatically resolves based on the containers required by the manipulations.",
			Category->"Protocol"
		},
		{
			OptionName->TareWeighContainers,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Description->"Indicates if empty containers should be tare weighed prior to running the experiment. Tare weighing of each container improves accuracy of any subsequent weighing or gravimetric volume measurement performed in the container.",
			Category->"Protocol"
		},
		{
		(* modify the shared option SampleImageOption, since here the default is to always take a picture of the resulting samples. *)
			OptionName->PreferredSampleImageOrientation,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>ImagingDirectionP],
			Description->"Indicates the preferred orientation in which the SamplesOut manipulated in the course of the experiment should be imaged after running the experiment.",
			Category->"PostProcessing"
		},
		{
			OptionName->Bufferbot,
			Default->False,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Description->"Indicates if an automated macro liquid handler will be considered as an instrument option for the provided manipulations.",
			Category->"Hidden"
		},
		{
			OptionName->PreFlush,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Description->"Indicates if a pre-rinse of a macro liquid handler's source lines should be performed prior to dispensing.",
			ResolutionDescription->"If automatic, resolves to True if the sample manipulation will be performed with a macro liquid handler.",
			Category->"Hidden"
		},
		{
		(* TODO consider eliminating this option? Since ParentProtocol is included in ProtocolOptions *)
			OptionName->RootProtocol,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Object,Pattern:>ObjectP[ProtocolTypes[]]],
			Description->"The root protocol for the generated protocol.",
			Category->"Hidden"
		},
		{
			(* TODO potentially rename this option? Since an Aliquot\[Rule]BooleanP exists in the AliquotOptions *)
			OptionName->Aliquot,
			Default->False,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Description->"Indicates if this function is being called by ExperimentAliquot.",
			Category->"Hidden"
		},
		{
			OptionName->Resuspend,
			Default->False,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Description->"Indicates if this function is being called by ExperimentResuspend.",
			Category->"Hidden"
		},
		{
			OptionName->Dilute,
			Default->False,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Description->"Indicates if this function is being called by ExperimentDilute.",
			Category->"Hidden"
		},
		{
			OptionName->OrderFulfilled,
			Default->Null,
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ListableP[ObjectP[Object[Transaction,Order]]]],
			Description->"The inventory order that is requesting sample transfers.",
			Category->"Hidden"
		},
		{
			OptionName->PreparedResources,
			Default->{},
			AllowNull->False,
			Widget->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Resource,Sample]]]],
			Description->"Model resources in the ParentProtocol that are being transferred into an appropriate container model by this experiment call.",
			Category->"Hidden"
		},
		{
			OptionName->RentContainer,
			Default->{},
			AllowNull->False,
			Widget->Alternatives[
				Adder[Widget[Type->Enumeration,Pattern:>BooleanP]],
				Widget[Type->Expression,Pattern:>{},Size->Line]
			],
			Description->"Indicates if any container model resources requested as part of the index-matched manipulation should be rented when this experiment is performed to prepare a StockSolution.",
			Category->"Hidden"
		},
		{
			OptionName -> SamplesInStorageCondition,
			Default -> Null,
			Description -> "The non-default conditions under which the SamplesIn of this experiment should be stored after the protocol is completed. If left unset, SamplesIn will be stored according to their current StorageCondition.",
			AllowNull -> True,
			Category -> "Post Experiment",
			(* Null indicates the storage conditions will be inherited from the model *)
			Widget -> Alternatives[
				Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]
			]
		},
		{
			OptionName -> SamplesOutStorageCondition,
			Default -> Null,
			Description -> "The non-default conditions under which any new samples generated by this experiment should be stored after the protocol is completed. If left unset, the new samples will be stored according to their Models' DefaultStorageCondition.",
			AllowNull -> True,
			Category -> "Post Experiment",
			(* Null indicates the storage conditions will be inherited from the model *)
			Widget -> Alternatives[
				Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]
			]
		},
		{
			OptionName->Simulation,
			Default->False,
			AllowNull->False,
			Description->"Indicates that the output is used for the simulation of a sample manipulation.",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Category->"Hidden"
		},
		{
			OptionName->SamplePreparation,
			Default->False,
			AllowNull->False,
			Description->"Indicates that the resulting protocol is being used as part of another protocol's sample preparation.",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Category->"Hidden"
		},
		{
			OptionName -> PlaceLids,
			Default -> Automatic,
			Description -> "Indicates if lids are placed on all plates after the manipulations have completed. This should decrease evaporation.",
			ResolutionDescription->"If automatic, resolves to True if no Cover or Uncover primitives are specified.",
			AllowNull -> False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		(* ProtocolOptions include: Confirm, ProtocolTemplate, NumberOfReplicates, ParentProtocol, Name, Cache, Upload, FastTrack, Operator, Email and Output options *)
		(*	ProtocolOptions *)
		(* TODO: add Operator, NumberOfReplicates, Template into code *)
		ConfirmOption,
		UploadOption,
		CacheOption,
		FastTrackOption,
		OutputOption,
		ParentProtocolOption,
		SubprotocolDescriptionOption,
		EmailOption,
		NameOption,
		PostProcessingOptions,
		PriorityOption,
		StartDateOption,
		HoldOrderOption,
		QueuePositionOption
	}
];

Error::PrimitiveAmountsInputInvalid = "For Aliquot primitives, the Amounts and Destinations keys must be the same length, and for Consolidation primitives, the Amounts and Sources keys must be the same length, but these keys are not the same length for the primitive(s) `1`. Please change these keys so the input lengths match.";
Error::PrimitiveInputLengthsInvalid="The lengths of Source and Destination does not match for the primitive(s) `1`. Please ensure that the input lengths match.";
Error::InvalidPrimitiveValue="The `1` key does not match the expected pattern `2` in the primitive at index `3`. Please correct this primitive's key value.";
Error::InWellSeparationKeyNotAllowed="The input primitives at index `1` have InWellSeparation Key which is not supported by ExperimentSampleManipulation. Please remove InWellSeparation Key from the primitives in question.";
Warning::TransferTypeDefaulted="The manipulation `1` was specified with TransferType `2`. However, this transfer type is inconsistent with the amount(s) of the manipulation. This manipulation will be performed via transfer type `3`";
Warning::ZeroAmountManipulationRemoved="The manipulation `1` has been removed from the manipulation list as it contained all 0 amounts.";
Warning::ZeroAmountRemoved="The manipulation `1` includes an amount of 0. This mass-transfer has been removed from the manipulation.";
Error::AllManipulationsRemoved="All manipulations were removed due to having an amount of 0. Please ensure that at least one manipulation contains a manipulation amount greater than 0 and then call this function again.";
Error::DeprecatedModels="The following sample/container models have been deprecated in SLL and cannot currently be involved in sample manipulations: `1`. Please check the Deprecated field of all models and container models in your manipulations and exclude any objects marked as deprecated, or contact ECL if an object has been deprecated in error.";
Error::FillToVolumeDestinationsNotUnique="Multiple FillToVolume manipulations were requested for a single container. Please make sure a single FillToVolume manipulation is specified for each unique destination container.";
Error::NotCalibratedFillToVolumeDestination="The FillToVolume manipulation(s) `1` have destination container models without a calibration populated in its VolumeCalibrations field that is not Anomalous or Deprecated. Please use containers that have a valid calibration or use Transfer primitive.";
Error::InvalidScaleSpecification="The requested manipulation scale, `1`, is not compatible with the specified manipulations.";
Error::IncompatibleScalesRequired="LiquidHandlingScale could not be resolved because a primitive that requires MicroLiquidHandling and a primitive that requires MacroLiquidHandling exist. Please make sure Incubate primitives do not exist alongside FillToVolume primitives or primitives incompatible with liquid handlers.";
Error::IncompatibleChemicals="MicroLiquidHandling was requested, but the following models/samples have been marked as difficult to manipulate with current automated liquid handling methods: `1`. Please allow these manipulations to be performed at macro scale by setting the LiquidHandlingScale option to Automatic or MacroLiquidHandling.";
Error::SampleManipulationAmountOutOfRange="The following manipulations cannot be performed using any currently-available instrumentation in the lab: `1`. Please consult with ECL.";
Error::ModelOverMicroMax="The requested manipulations require a total of `2` of `1`. However, the liquid handling scale has resolved to MicroLiquidHandling, which has a threshold of 250mL of any one model source. Please consider splitting up manipulations that require `1`, or setting LiquidHandlingScale to MacroLiquidHandling.";
Error::EmptySourceContainer="The source container in the manipulation, `1`, is empty and cannot be used for Transfer. Please specify a container with sample inside.";
Warning::DrainedWell="It is expected that the manipulation, `1`, will try and draw more liquid from the location `2` than it will contain at the time (`2` would need an additional `3` to complete the manipulation).";
Error::OverfilledWell="It is expected that the manipulation, `1`, will try and dispense more liquid into location `2` than it can hold. The predicted total volume of the well after the manipulation is `3` and it can only hold `4`.";
Warning::UnusedLiquidHandler="The LiquidHandler option was specified, but the manipulation scale has defaulted to MacroLiquidHandling; the provided liquid handler option will not be used.";
Error::InvalidLiquidHandler="The provided LiquidHandler option, `1`, cannot accommodate the requested manipulations due to deck space limitations. Please either set the LiquidHandler option to Automatic, provide one of the following liquid handler models - `2` - or a specific instrument of these models.";
Error::IncompatibleLiquidHandler="The provided LiquidHandler option, `1` cannot accommodate `2` primitives. Please either set the LiquidHandler option to Automatic, provide one of the following liquid handler models - `3` - or a specific instrument of these models.";
Error::TooManyContainers="The liquid handling scale for these manipulations has resolved to micro liquid handling, but the manipulations require more containers than can fit on a single robot deck. Please either allow these manipulations to proceed at macro liquid handling scale, or lower the total number of containers involved.";
Warning::ManyTransfersRequired="Some of the specified manipulations contain volumes >10mL which will require many discrete pipette transfers to complete on the liquid handler. You may wish to consider performing some or all of your manipulations in a separate MacroLiquidHandling protocol.";
Error::MicroScaleNotPossible="The manipulations of the type `3` at position(s) `1` (not counting the Define primitives, if present) require `2`, but the LiquidHandlingScale was specified to MicroLiquidHandling. Please leave the LiquidHandlingScale Automatic or modify the primitives accordingly.";
Error::FillToVolumeConflictsWithScale="The manipulations at position(s) `1` are of the type `2`, which due to its nature requires the LiquidHandlingScale to be MacroLiquidHandling, but the LiquidHandlingScale was specified to MicroLiquidHandling. Please leave the scale Automatic or set it to MacroLiquidHandling.";
Error::IncompatiblePipettingParametersScale="Some manipulations (`1`) specify pipetting or tip parameters, however MacroLiquidHandling scale is required. Pipetting parameters are not compatible with macro liquid handling. Please remove pipetting parameter specifications.";
Error::MissingTareWeight="If TareWeighContainers->False, TareWeight must be specified in the models of all empty containers that would otherwise be tare weighed. The following container models do not have a TareWeight specified: `1`. Please set TareWeighContainers->True or specify destination containers whose models have defined TareWeight.";
Error::VentilatedOpenContainer="Substances which must be handled in a fume hood (Ventilated->True), cannot be transferred into open containers. Please check: `1`";
Error::InvalidFillToVolumeMethodManipulations="The manipulation(s), `1`, have an invalid Method defined. Fill to volume stock solutions cannot be generated via Ultrasonic measurement if the resulting stock solution is UltrasonicIncompatible. Stock solutions also cannot be generated via Volumetric measurement if the resulting stock solution is over 2L (the largest volumetric flask). Please change this option to create a valid stock solution.";
Error::TransferStateAmountMismatch="All transfers of liquid samples must provide amounts in volumes. Please convert these amounts. If you do not know the density of the liquids being transferred consider calling ExperimentMeasureDensity. Check: `1`";
Error::MultiProbeHeadInvalidTransfer="The primitives at indices `1` have specified a DeviceChannel of MultiProbeHead with an incompatible number of transfers. Please ensure each Transfer primitive requesting the MultiProbeHead contains exactly 96 transfers.";

(* Define Errors *)
Error::MissingDefineKeys="Name or ContainerName and Sample or Container must be specified in the Define primitive at index `1`. Please add these keys.";
Error::InvalidModelTypeName="Either both or neither ModelName and ModelType must be specified in the Define primitive at index `1`. Please specify both or neither.";
Error::InvalidSampleContainer="Sample must be a location or Container must be specified if ModelType/ModelName are specified in the Define primitive at index `1`. Please ensure a sample object is not specified with model-generation parameters.";
Error::InvalidModelParameters="ModelType and ModelName must be specified if any model parameters (TransportWarmed, State, Expires, ShelfLife, UnsealedShelfLife, or DefaultStorageCondition) are specified in the Define primitive at index `1`. Please remove model-generation parameters or specify a type and name for the new model.";
Error::InvalidContainerName="Container must be specified or Sample must specify a location if ContainerName is specified in the Define primitive at index `1`. Please remove name or specify the container or sample location.";
Error::InvalidModelSpecification="Model cannot be specified as well as ModelType or ModelName in the Define primitive at index `1`. Please remove Model specification or model-generation parameters.";
Error::InvalidSampleParameters="StorageCondition or ExpirationDate can only be specified for samples that do not already exist (ie: Sample must be a model or location) in the Define primitive at index `1`. Please ensure a model or empty location is defined.";
Error::InvalidNameReference="The names `1` used in primitives at index `2` do not have an associated Define primitive that establishes the name. Please define any used names using a Define primitive.";
Error::InvalidName="The names `1` used in primitives `2` are container wells and cannot be used as defined names as they create ambiguity with other container wells. Please change the name or append a unique suffix.";
Error::ModelNameExists="The ModelName(s) `1` are already used. Please specify a unique name or specify the existing model with the Model key.";
Error::DuplicateModelName="The ModelName(s) `1` are used multiple times across Define primitives. Please specify a unique name or specify the existing model with the Model key.";
Error::DuplicateSamplesDefined="The Define primitives at indices `1` are attempting to assign multiple names to the same Sample. Please ensure that no single sample is Defined using multiple names.";

(* Mix Errors *)
Error::MissingMixKeys="The Mix primitives at positions `1` must specify MixVolume and NumberOfMixes.";

(* Filter Errors *)
Error::InvalidFilterSampleSpecification="The Filter primitive at index `1` does not specify a sample or list of samples in its Sample key. Please specify a sample rather than a container, or when using a Define primitives, refer to a plate and well position.";
Error::InvalidFilterSampleLocation="The Filter primitive at index `1` must refer to samples that are only in a single Model[Container, Plate, Filter] or are in PhyTip Columns. Please be sure the referenced sample(s) or location(s) are in a single filter plate or are in phytip columns. Samples that are in a combination of filter plates and phytip columns must be filtered using separate filter primitives.";
Error::IncompatibleCollectionContainer="The Filter primitive at index `1` has an invalid CollectionContainer specification. Currently this must be a plate with the 'Plate' footprint with the same number of wells as the filter plate.";
Error::IncompatibleFilterContainer="The Filter primitives specified use an incompatible filter container (`1`). Currently filter containers must have one of the models `2`.";
Error::IncompatibleSpinFilterContainer="The Filter-by-centrifuge primitives specified use an incompatible filter container (`1`). Currently filter containers must have one of the models `2`.";
Error::InvalidFilterContainerAccess="The manipulations at index `1` access a different filter collection plate than the one currently being manipulated. Filter plates must be manipulated on top of their collection plate so that filtered material does not drip onto the liquid handler deck. However, there is only one specialized position on the liquid handler deck that can load the combined stack of filter/collection plate due to height restrictions. Therefore, only one set of filter/collection plate can be manipulated at a time. Please include a Filter[...] primitive (to perform the filtration) for the current filter/collection plate to allow for the loading of other filter/collection plates.";
Error::InvalidCollectionContainerAccess="The manipulations at index `1` access the collection container plate while the filter/collection plate is being loaded but before the filter/collection plate has been filtered. The collection plate cannot be accessed during loading of the filter plate (on top) because removal of the filter plate may result in filtered material dripping through the filter and onto the liquid handler deck. Please either transfer into/out of the collection container before transferring into/out of the filter container, or after filtration has occurred (include a Filter[...] primitive).";
Error::FilterRequired="The manipulations at index `1` access a filter plate without a downstream Filter[...] primitive. In micro liquid handling, in order to perform transfer from a filter plate, Filter must be performed at any point in protocol after the last Transfer into the filter plate before the Transfer from it.";
Error::InvalidTransferFilterPlatePrimitive="The manipulations at index, `1`, are transferring into multiple filter plates at the same time. The liquid handler only has one low plate position that can accommodate the filter plate and collection plate stack. Please only transfer into one filter plate at a time.";
Error::InvalidFilterSourcePrimitive="The manipulations at index, `1`, have samples that are in different containers. When using the liquid handler, filter primitives can only have samples from the same container, since the MPE2 can only filter one filter plate/collection plate stack at a time. Please only include samples that are in the same filter plate.";
Error::IncompatibleFilterParameters="The Filter primitive at index `1` has a filter specified whose properties do not match the specified MembraneMaterial and PoreSize values. Please be sure these keys match those of the specified filter or do not specify them.";
Error::InvalidFilterParameters="The Filter primitive at index `1` only one of MembraneMaterial and PoreSize specified. Please specify both or neither.";
Error::InvalidFilterSpecification="The Filter primitive at index `1` does not properly specify the filter to use. Please specify either Filter or both MembraneMaterial and PoreSize.";
Error::NoFiltersFound="The Filter primitive at index `1` cannot resolve its Filter object because no filters with the specified MembraneMaterial and PoreSize exist. Please verify an existing filter is compatible with these specifications.";
Error::ConflictingFilterPrimitiveKeys="The manipulations of the type Filter at position(s) `1` have requested the keys `2` which are specific for more than one LiquidHandlingScale. Please consult the documentation for 'Filter' for a full listing of primitive keys valid for each scale.";
Error::FilterManipConflictsWithScale="The manipulations at position(s) `1` have specified the keys `3` which are specific for `4`, however the requested manipulation scale is `2`. Please omit the keys `3` in these manipulations in order to proceed with `2`. Please consult the documentation for 'Filter' for a full listing of primitive keys valid for each scale.";
Error::MissingMicroFilterKeys="The manipulations `1` of the type Filter at position(s) `2` are missing the key(s) `3` which are required for micro liquid handling scale. Please consult the documentation for 'Filter' for a full listing of primitive keys required and optional for each scale.";
Error::InvalidCollectionContainer="The Filter primitive at index `1` has an invalid CollectionContainer specification. The CollectionContainer for micro liquid handling must be a plate.";
Error::FilterManipConflictsWithResolvedScale="The LiquidHandlingScale resolved to `2` because at least one of the manipulations requires `2`. However the manipulation(s) of the type Filter at position(s) `1` require(s) `4` due to the keys specified in the primitive. Please consider splitting up the manipulations, or omit the keys `3` from the manipulations at position(s) `1` in order to proceed with `2`. Please consult the documentation for 'Filter' for a full listing of primitive keys valid for each scale.";
Error::TooManyMacroFilterCollectionPlates="The Filter primitive at index `1` resolves to multiple CollectionContainer plates. The CollectionContainer must be a single plate or vessel for macro liquid handling, or multiple vessels. Please specify CollectionContainer to the appropriate container object or model.";
Error::TooManyMacroFilterContainers="The samples in the Filter primitive at index `1` are located in more than one plate. Only samples in a single plate or in multiple vessels per filter primitive are currently supported. Please split your your input samples into several consecutive primitives to perform the requested filtration.";
Error::InvalidMacroFilterCollectionContainer="In the filter primitive at index `1`, the specified CollectionContainer model(s), `2`, are currently not supported for collecting the filtrate of the input sample(s) via the specified or resolved filtration type(s) `3` and instrument(s) `4`. Consider not specifying CollectionContainer and appending a transfer primitive to transfer the sample to the requested container, or specify a container of the model(s) `5` as CollectionContainer.";
Error::FiltrationTypeNotSupported="In the filter primitive at index `1`, the filtration type(s) and the filter(s) were specified or resolved to `2` and `3`. Filtering by Centrifuge is currently not supported for filtering via SampleManipulation. Please try specifying a different type of filtration or call ExperimentFilter as a separate experiment.";
Error::InvalidMacroFilterSourceContainer="In the filter primitive at index `1`, the samples are in container(s) of the type `2`,which are not supported for filtering by filtration type(s) `3` and instrument(s) `4`. Please move the sample(s) to container(s) of the type(s) `5` via a Transfer primitive, prior to the Filter primitive, or change to a different filtration type.";

(* MoveToMagnet/RemoveFromMagnet Errors *)
Error::IncompatibleMagnetContainer="The sample in the MoveToMagnet/RemoveFromMagnet primitive(s) `1` is not in a 96-well plate and therefore is not currently supported for magnetization. Please transfer the samples to a 96-well plate.";
Error::FilterMagnetPrimitives="The Filter and MoveToMagnet/RemoveFromMagnet primitives are not currently supported together.";

(* Incubate Errors *)
Error::IncompatibleIncubationFootprints="The containers used in the Incubate at index `1` do not have a Plate footprint. Only containers with a Plate footprint can be incubated. Please transfer samples to a plate before incubating.";
Error::TooManyIncubationContainers="More than four containers are specified to residually incubate or mix (`1`). No more than four containers can be residually incubated. Please alter the input primitives to use a maximum of four residual incubations or mixes.";
Error::ConflictingIncubation="The Incubation at index `1` specified distinct incubation times, temperatures, or mix rates for samples in the same container. Please verify that incubation parameters are the same for distinct containers within an Incubate primitive.";
Error::ConflictingCoolingShaking="The micro liquid handling incubation at index `1` specifies cooling and shaking which cannot be performed at the same time. Please change either Temperature and MixRate or switch to macro liquid handling scale.";
Error::IncubateManipConflictsWithScale="The manipulations at position(s) `1` have specified the keys `3` which are specific for `4`, however the requested manipulation scale is `2`. Please omit the keys `3` in these manipulations in order to proceed with `2`. Please consult the documentation for 'Incubate' for a full listing of primitive keys valid for each scale.";
Error::InvalidIncubatePrimitive="The manipulations of the type Incubate at position(s) `1` have requested the keys `2` which are specific for more than one LiquidHandlingScale. Please consult the documentation for 'Incubate' for a full listing of primitive keys valid for each scale.";
Error::IncubateManipConflictsWithResolvedScale="The LiquidHandlingScale resolved to `2` because at least one of the manipulations requires `2`. However the manipulation(s) of the type Incubate at position(s) `1` require(s) `4` due to the keys specified. Please consider splitting up the manipulations, or omit the keys `3` from the manipulations at position(s) `1` in order to proceed with `2`. Please consult the documentation for 'Incubate' for a full listing of primitive keys valid for each scale.";
Error::InvalidResidualMixRate="The manipulations of the type Incubate at position(s) `1` have specified both ResidualMixRate and MixRate. These keys are required to have identical values when working on macro liquid handling scale. Please adjust these values or leave one of the keys empty.";
Error::InvalidResidualTemperature="The manipulations of the type Incubate at position(s) `1` have specified both ResidualTemperature and Temperature. These keys are required to have identical values when working on macro liquid handling scale. Please adjust these values or leave one of the keys empty.";
Error::InvalidResidualMix="The manipulations of the type Incubate at position(s) `1` have specified ResidualMixRate while the ResidualMix boolean is turned to False. Please turn ResidualMix to True in order to perform residual mixing, or leave the ResidualMixRate key empty.";
Error::InvalidResidualIncubation="The manipulations of the type Incubate at position(s) `1` have specified ResidualTemperature while the ResidualTemperature boolean is turned to False. Please turn ResidualTemperature to True in order to perform residual incubation, or leave the ResidualTemperature key empty.";
Error::ResidualMixNeeded="The manipulations of the type Incubate at position(s) `1` have specified ResidualMix to False, while ResidualIncubation is True. Since MixRate was specified or resolved to `2`, during the residual incubation, residual shaking will also take place. Thus either turn ResidualMix to True, or turn ResidualIncubation to False.";
Error::ResidualIncubationNeeded="The manipulations of the type Incubate at position(s) `1` have specified ResidualIncubate to False, while ResidualMix is True. During the residual mixing, residual incubation will also take place. Thus either turn ResidualMix to False, or turn ResidualIncubation to True.";
Error::MicroPrimitiveMissingKeys="The manipulations of the type Incubate at position(s) `1` are missing the key(s) `2` which are required for the scale 'MicroLiquidHandling' which was either specified or resolved to because no other primitive required macro liquid handling scale. Please specify a different scale, or add these keys to the primitives before proceeding.";

(* Centrifuge Errors *)
Error::InvalidCentrifugePrimitives="It is not possible to perform the centrifuges specified in `1`. Please ensure the samples and settings are compatible with at least one centrifuge instrument. See ExperimentCentrifuge for more information.";

(* Pellet Errors *)
Error::PelletConflictsWithScale="It is not currently possible to pellet samples when LiquidHandlingScale->MicroLiquidHandling. If you wish to perform your manipulations on a robotic liquid handler, please consider performing the pelleting steps before or after this protocol.";
Error::InvalidPelletPrimitives="It is not possible to perform the pelleting manipulations specified in `1`. Please ensure the samples and settings are compatible with at least one centrifuge instrument. See ExperimentPellet for more information.";

(* Tip Parameter Errors *)
Error::LiquidHandlerNotCompatibleWithTipType="The specified LiquidHandler is not specified with the TipType/TipSize specifications for primitives: `1`.";
Error::IncompatibleTipSize="The specified TipSize values in primitives `1` are not compatible with liquid handlers. Please use 50 ul, 300 ul, or 1000 ul tip sizes.";
Error::TipTypeDoesNotExistForSize="The specified TipSize does not exist with the specified TipType in primitives `1`. Please specify a specific TipType model or remove one of the specifications.";
Error::TipTypeSizeDoesNotExist="The specified TipType object does not have a MaxVolume of the specified TipSize in primitives `1`. Please make sure these values agree or remove TipSize specification.";
Error::TipSizeIncompatibleWithContainers="A tip size of `1` is not compatible with the containers used in primitives `2`. Please use a different tip size or allow for automatic tip resolution.";
Error::TooManyTipsRequired="The input manipulations require more tip racks than can fit on a liquid handler (`1`). Please truncate the number of manipulations.";
Error::IncompatibleTipForMixVolume="The specified TipType or TipSize in Mix primitives `1` have a maximum aspiration volume less than the maximum volume being mixes. Please change the specified tip type or size.";

(* ReadPlate Errors *)
Error::TooManyInjectionSamples="A maximum of two unique injection samples can be used across all ReadPlate primitives.";
Error::TooManyReadPlateContainers="The ReadPlate primitive `1` specifies samples and blanks in greater than one container. Please be sure to specify samples that are all in the same container.";
Error::InvalidReadPlateSample="The ReadPlate primitive `1` does not specify a sample or well location in its Sample key. Please check that a sample or container and well is specified instead of a full plate.";
Error::InvalidReadPlateScale="The LiquidHandlingScale of this experiment has been resolved to MacroLiquidHandling but ReadPlate primitives primitives are not allowed under MacroLiquidHandling scale. Please remove the ReadPlate primitives or specify LiquidHandlingScale as MicroLiquidHandling and use liquid handler compatible containers.";
Error::IncompatibleReadPlatePlateModels="The ReadPlate primitive requires all plates have the same layout and number of wells for instruments which require unique set-up depending on the plate layout, e.g focusing devices. Ensure all plates being imaged have the same layout and number of wells";
Error::UnresolvedOptions="When PreResolved->True, the options `1` are not resolved.";
Error::EmptyWells = "ReadPlate primitive `1` specifies a well that does not contain sample in it which is currently not supported. Please check that all wells specified in the ReadPlate have samples in tehm or will have samples created in them during this experiment.";


(* ::Subsubsection::Closed:: *)
(*ExperimentSampleManipulation*)


ExperimentSampleManipulation[myIntitialManipulations:{SampleManipulationP..},myOptions:OptionsPattern[ExperimentSampleManipulation]]:=Module[
	{listedOptions,outputSpecification,output,gatherTests,messagesBoolean,warningsBoolean,testOrNull,warningOrNull,safeOptions,safeOptionTests,validLengths,
	validLengthTests,email,upload,resolvedEmail,parentProtocol,liquidHandlerOption,expandVolume,manipulationsWithAmountKey,manipulationKeyChecks,
	invalidManipulationsBool,invalidManipulationTest,invalidPrimitiveInputs,validAmountsLengthInputBools,validAmountsInputTest,validTransferInputLengthBools,validTransferInputLengthTest,invalidManipulations,invalidManipulationMessage,manipulationsWithTransferTypeTuples,
	manipulationsWithTransferType,transferTypeDefaultedTests,manipulationsWithResuspension,inputMixPrimitivePositions,inputIncubatePrimitivePositions,
	inputMixIncubatePrimitivePositions,inputMixIncubatePrimitives,convertedMixIncubatePrimitives,manipulationsWithExpandedMixes,
	manipulationsWithExpandedIncubations,primitivesWithConvertedTransfers,nonZeroAmountManipulationTuples,nonZeroAmountManipulations,
	modifiedRawManipulationPositions,nonZeroAmountManipulationTests,ceVialRackModel,phyTipRackModel,defaultFilterCollectionModel,defaultOnDeckReservoir,modelContainersRequiringAdapting,
	modelContainerRackLookup,filterModelContainersOut,samples,models,containers,modelContainers,specifiedPipettingMethods,specifiedTipTypes,
	centrifugeRelatedObjects,centrifugeInstruments,centrifugeRotors,centrifugeBuckets,centrifugeAdapters,centrifugeInstrumentFields,centrifugeRotorFields,centifugeBucketFields,centrifugeAdapterFields,centrifugePackets,
	possibleTips,allTips,sampleAllFields,modelAllFields,containerAllFields,modelContainerAllFields,pipettingMethodFields,tipFields,preparedResources,
	rentContainerFromSS,preparedResourceFields,parentProtocolDownloadObject,downloadPackets,allPackets,uniqueContainerPackets,uniqueSamplePackets,
	counterweightModelPackets,counterweightWeights,inWellSeparationKeyExistQ,positionsWithInWellSeparationKey,primitivesWithInWellSeparationKeyTests,inWellSeparationKeyMessage,
	parentProtocolPackets,discardedPackets,discardedPacketsExistQ,discardedSamplesTest,deprecatedPackets,deprecatedPacketsExistQ,deprecatedSamplesTest,
	liquidHandlerModel,preparedResourcePackets,resourceRentContainerBools,liquidHandlingScaleCache,resolvedLiquidHandlingScale,
	cannotResolveScaleMessagesBool,resolvedLiquidHandlingScaleTests,scaleToUseForFurtherResolving,manipulationsWithResolvedDefines,resolvedDefinePrimitives,
	definedNamesLookup,validDefinesQ,generateDefineTests,definedNameReferences,invalidDefinedNameReferences,invalidDefinedNamePrimitiveIndices,validNameReferencesTest,
	incompatibleDefineNames,invalidDefinedNames,invalidNameTest,definePrimitivesWithModelNames,specifiedModelNames,definedNewModels,existingModelBools,
	existingModelNames,primitivesWithExistingModelNames,existingModelNameTest,duplicatedModelNames,primitivesWithDuplicatedNames,duplicatedModelNamesTest,
		primitivesWithDuplicateSamples, primitivesWithDuplicateSamplesTest,
	defineTests,manipulationsWithPlateWells,splitPrimitiveLists,splitPrimitives,expandedRentContainerBools,expandedRawManipulationPositions,manipulationsWithObjectReferences,
	filterPrimitivesWithoutSpecificKeys,filterPrimitivePositionsMacroAndMicro,filterPrimitivePositionsMicro,filterPrimitivePositionsMacro,filterPrimitivePositionsWithoutSpecificKeys,
	microOnlyFilterOptions,macroOnlyFilterOptions,filterPrimitivesMacroAndMicro,filterPrimitivesMicro,filterPrimitivesMacro,
	conflictingFilterMessage,conflictingFilterPrimitiveTests,filterPrimitivesConflictingWithScale,conflictingFilterWithScaleMessage,conflictingFilterWithScaleTests,
	filterMacroPositions,filterMicroPrimitives,validMacroFilterQ,resolvedFilterMacroPrimitives,individualFilterMacroTests,resolvedFilterMicroPrimitives,individualFilterMicroTests,
	missingKeysMicroFilterPrimitiveTuples,missingKeysMicroFilterPrimitives,missingFilterKeysIndeces,missingFilterKeys,missingKeysFilterMessage,missingKeysMicroFilterPrimitiveTests,
	filterMacroPrimitives,filterMicroPositions,filterPrimitives,validMicroFiltersQ,specifiedCollectionContainers,
	collectionContainerPlateTest,allFilteredSamples,specifiedFilteredContainers,
	compatibleFilterModels,filterContainerModels,invalidFilterContainerModels,filterContainerCompatibilityTest,collectionPlatePrimitiveTest,transferNeedsFilterTest,invalidFilterTransferIndices,
	filterPlatePrimitiveTest, transferFilterPlateTest,filterSourceTest, primitivesWithConvertedTransfersListy,
	manipulationsWithResolvedFilters,manipulationsWithResolvedCoverings,manipulationsWithTaggedContainers,fillToVolumeDestinations,fillToVolumeProblemBool,fillToVolumeTestDescription,
	fillToVolumeTest,fillToVolumeProblematicManipulations,fillToVolumeProblemMessage,fillToVolumeDestinationObjects,fillToVolumeDestinationContainerModelPackets,
	validVolumeCalibrationBools,invalidDestinationFillToVolumes,fillToVolumeDestinationCalibrationTest,invalidfillToVolumeDestinationQ,
	allSpecifiedModelPackets,modelMaxAmounts,modelMaxAmountLookup,modifiedSourcePositionAmountTuples,gatheredTuples,gatheredByAmountTuples,replacementRules,
	replacedSources,manipulationsWithSplitModels,specifiedManipulations,fetchSingleContainerReference,invalidTransferFilterPlateIndices,invalidFilterSourceIndices,
	invalidCollectionPlatePrimitiveIndices,invalidFilterPlatePrimitiveIndices,filterTests,
	overfilledDrainedTests,overfilledCheckTripped,specifiedScale,stateMismatchManipulations,stateMismatchTest,fillToVolumeAndMicroMessage,fillToVolumeMethodMessage,fillToVolumeConflictsWithScaleTests,fillToVolumeMethodTests,
	simulatePrimitiveInputFunction,collapseMacroOptionsToContainers,centrifugePositions,centrifugePrimitives,resolveMicroCentrifugePrimitive,centrifugeOutput,resolvedCentrifugePrimitives,centrifugeTests,centrifugeOkBooleans,
	invalidCentrifugePrimitives,invalidCentrifugePrimitivesTest,
	manipulationsWithResolvedCentrifuges,centrifugeLiquidHandlingScaleMismatch,rawReadPlatePrimitivePositions,readPlatePositions,readPlateAfterTransferQ,
	initialResolvedReadPlatePrimitives,initialResolvedPlateReaderInstruments,initialReadPlateTests,initialValidReadPlateBooleans,reresolutionRequiredQ,reresolutionPositions,
	reresolvedReadPlatePrimitives,reresolvedPlateReaderInstruments,reresolvedreadPlateTests,reresolvedvalidReadPlateBooleans,requiredPlateReader,readPlatePrimitives,readPlateSamplesByPlate,
	flatReadPlateContainers,readPlateContainers,plateCoveredQ,resolvedReadPlatePrimitives,resolvedPlateReaderInstruments,resolvedPlateReaderInstrument,readPlateTests,validReadPlateBooleans,manipulationsWithResolvedReadPlates,
	resolvedReadPlateAssociations,listyConvertedMixIncubatePrimitives,
	allInjectionSamples,allInjectionVolumes,uniqueInjectionSamples,validInjectionCountQ,injectionSampleCountTest,injectionSampleVolumeLookup,allowedInjectionContainers,
	injectionResources,primaryInjectionSample,secondaryInjectionSample,numberOfInjectionContainers,anyInjectionsQ,washVolume,primaryCleaningSolvent,
	secondaryCleaningSolvent,plateReaderFields,validReadPlatesQ,microOnlyIncubateOptions,
	macroOnlyIncubateOptions,microRequiredOptions,rawIncubatePrimitivePositions,incubatePrimitivesMissingKeys,incubatePrimitivesMacroAndMicro,
	incubatePrimitivesMicro,incubatePrimitivesMacro,missingKeysMessage,missingKeysTests,conflictingIncubateMessage,conflictingIncubatePrimitiveTests,
	incubatePrimitivesConflictingWithScale,conflictingIncubateWithScaleMessage,conflictingIncubateWithScaleTests,resolveIncubationFunction,incubatePositions,
	incubatePrimitives,scaleByIncubateKeys,resolvedIncubatePrimitives,manipulationsWithResolvedIncubations,incubationMacroTests,validMacroIncubationBooleans,
	validMacroIncubationsQ,validMicroIncubationsQ,generateIncubationTests,allMicroIncubatePositions,residualIncubations,residualIncubationContainers,
	numberOfIncubatorsRequired,incubationOverflowTest,incubationTests,validMixKeysQ,mixKeysTest,manipulationsWithPipettingParameters,pipettingParameterTests,invalidPipettingParameterQ,
	tipUsageLookup,partitionedTipCountLookup,uniqueTipTypes,requiredStackedTipTypes,requiredNonStackedTipTypes, listyResuspendLengths,
	flattenedStackedTipTuples,flattenedNonStackedTipTuples,allTipTypeCountTuples,allTipResources,maxStackedTipPositions,maxNonStackedTipPositions,maxStackedSuperstarTipPositions,maxNonStackedSuperstarTipPositions,
	validTipCountQ,validTipCountTest,requiredObjects,requiredObjectsLookup,requiredObjectsNotFailed,modelResourceContainerModels,modelsMissingPackets,newModelPackets,skipTareFunction,possibleContainersToTare,
	toContainerModel,tareContainerModelTareWeights,tareContainersWithoutModelTareWeight,tareContainerTareWeightErrorQ,tareContainerTareWeightTest,resolvedTareWeighContainers,
	tareContainers,resolvedPreFlush,specifiedMicroIncubations,taggedIncubationContainers,vialPlacements,hplcVialHamiltonRackRequiredQ,vesselRackPlacements,
	allVesselPlacements,plateAdapterPlacements,liquidHandlerResource,liquidHandlerTest,validLiquidHandlerQ,
	magnetPrimitives,magnetContainerModels,magnetContainerModelPackets,validMagnetContainerQ,magnetContainerTest,
	validFilterMagnetQ,filterMagnetTest,openContainerSafeQ,unsafeVentilatedTransfers,unsafeTransfersExist,
	ventilatedTest,optimizedPrimitives,splitMixPrimitives,resolvedPostProcessingOptions,preferredOrientation,resolvedPreferredSampleImageOrientation,
	resolvedOptions,nameOption,nameValidBool,nameTest,samplesIn,liquidHandlingEstimate,plateReaderResource,placeLidsQ,lidPlacements,lidSpacerPlacements,samplesInStorageCondition,protocolType,protocolID,protocolPacket,
	hardMessagesoccurred,optionsRule,previewRule,allMainFunctionTests,testsRule,resultRule, primitivesWithConvertedResuspends, primitivesWithListyResuspends,
	pelletPositions,pelletPrimitives,pelletOutput,resolvedPelletPrimitives,pelletTests,pelletOkBooleans,manipulationsWithResolvedPellets,pelletLiquidHandlingScaleMismatch,pelletScaleTest,
	readPlateAssayPlateContainers,readPlateAssayPlateModels,bmgPlateReaderFormats,validReadPlatePlateModelsQ,readPlatePlateModelsTest,
	myRawManipulations, myRawListedManipulations,usesMagnetQ,validMultiProbeHeadTransferQ,validMultiProbeHeadTransferTest},

	(* make sure we're working with a list of options and samples, and remove all temporal links *)
	{myRawListedManipulations, listedOptions} = removeLinks[ToList[myIntitialManipulations], ToList[myOptions]];

	(* remove Links from the manipulations *)
	myRawManipulations = myRawListedManipulations/.(x:LinkP[]:>Download[x, Object]);

	(* Determine the requested return value from the function *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output,Tests];

	(* whenever we are not collecting tests, print messages instead *)
	messagesBoolean = !gatherTests;

	(* Determine whether we should display warnings based on whether we're in engine *)
	warningsBoolean = !MatchQ[$ECLApplication, Engine];

	(* Define test generation helpers *)
	testOrNull[testDescription_String,passQ:BooleanP]:=If[gatherTests,
		Test[testDescription,True,Evaluate[passQ]],
		Null
	];
	warningOrNull[testDescription_String,passQ:BooleanP]:=If[gatherTests,
		Warning[testDescription,True,Evaluate[passQ]],
		Null
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests}=If[gatherTests,
		SafeOptions[ExperimentSampleManipulation,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentSampleManipulation,listedOptions,AutoCorrect->False],Null}
	];

	(* Call ValidOptionLengthsQ to make sure all options are the right length *)
	(* Silence the missing option errors *)
	{validLengths,validLengthTests}=Quiet[
		If[gatherTests,
			ValidInputLengthsQ[ExperimentSampleManipulation,{myRawManipulations},listedOptions,Output->{Result,Tests}],
			{ValidInputLengthsQ[ExperimentSampleManipulation,{myRawManipulations},listedOptions],Null}
			],
		Warning::IndexMatchingOptionMissing
	];

	(*If the specified options don't match their patterns or if option lengths are invalid return $Failed*)
	If[MatchQ[safeOptions,$Failed]||!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> DeleteCases[Join[safeOptionTests,validLengthTests],Null],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* we can immediately throw an error if Upload->False and Confirm->True; this combo doesn't work due to ShippingMaterials behavior of UPS *)
	If[MatchQ[Lookup[safeOptions,Upload],False]&&TrueQ[Lookup[safeOptions,Confirm]],
		Message[Error::ConfirmUploadConflict];
		Return[$Failed]
	];

	(* Pull Email and Upload options from safeOptions *)
	{email,upload} = Lookup[safeOptions, {Email, Upload}];

	(* Resolve Email option if Automatic *)
	resolvedEmail = If[!MatchQ[email, Automatic],
		(* If Email!=Automatic, use the supplied value *)
		email,
		(* If BOTH Upload->True and Result is a member of Output, send emails. Otherwise, DO NOT send emails *)
		If[And[upload, MemberQ[output, Result]],
			True,
			False
		]
	];

	(* pull out the parent protocol and the liquid handler from the provided Options *)
	{parentProtocol,liquidHandlerOption}=Lookup[safeOptions,{ParentProtocol,LiquidHandler}];

	(* we still allow the Amount key to be specified as legacy Volume key; convert everything to Amount/Amounts
	 	for ease of use internally; currently, only Transfer/Aliquot/Consolidation allow initial Volume(s) key use *)
	expandVolume[amount_, length_] := If[ListQ[amount], amount, Table[amount, Length[length]]];

	manipulationsWithAmountKey = Map[
		Switch[#,
			_Transfer,
				If[!MissingQ[#[Volume]],
					Transfer[Append[KeyDrop[First[#],Volume],Amount->#[Volume]]],
					#
				],
			_Aliquot,
				If[!MissingQ[#[Volumes]],
					Head[#][Append[KeyDrop[First[#],Volumes],Amounts->expandVolume[#[Volumes],#[Destinations]]]],
					Head[#][Append[KeyDrop[First[#],Volumes],Amounts->expandVolume[#[Amounts],#[Destinations]]]]
				],
			_Consolidation,
				If[!MissingQ[#[Volumes]],
					Head[#][Append[KeyDrop[First[#],Volumes],Amounts->expandVolume[#[Volumes],#[Sources]]]],
					Head[#][Append[KeyDrop[First[#],Volumes],Amounts->expandVolume[#[Amounts],#[Sources]]]]
				],
			_,
				#
		]&,
		myRawManipulations
	];


	(* check that the input lengths match for Aliquot and Consolidation *)
	validAmountsLengthInputBools = Map[
		With[{headLessPrimitive=Last[#]},
			Switch[#,
				_Aliquot,
				(* Destinations and Amounts have to be the same Length*)
				SameQ[Length[Lookup[headLessPrimitive,Destinations]],Length[Lookup[headLessPrimitive,Amounts]]],

				_Consolidation,
				(* Destinations and Amounts have to be the same Length*)
				SameQ[Length[Lookup[headLessPrimitive,Sources]],Length[Lookup[headLessPrimitive,Amounts]]],

				(* if it's not an Aliquot or Consolidation primitive, it is valid *)
				_,
				True
			]]&,manipulationsWithAmountKey
	];
	

	validAmountsInputTest = If[gatherTests,
		Test[
			"All the Aliquot and Consolidation primitives have Amounts matching the length of the Destinations or Sources key:",
			MemberQ[validAmountsLengthInputBools,False],
			False
		],
		Null
	];

	invalidPrimitiveInputs = If[MemberQ[validAmountsLengthInputBools,False]&&messagesBoolean,
		(
			Message[Error::PrimitiveAmountsInputInvalid,PickList[manipulationsWithAmountKey,validAmountsLengthInputBools,False],If];
			Message[Error::InvalidInput,PickList[manipulationsWithAmountKey,validAmountsLengthInputBools,False]];
		),
		{}
	];
	
	validTransferInputLengthBools=If[
		MatchQ[#,Except[_Transfer]],
		True,
		Module[{primitiveAssociation,source,destination},
			
			(* Get the association from the primitive *)
			primitiveAssociation=First[#];
			
			(* Find the source *)
			source=Lookup[primitiveAssociation,Source, {}];
			
			(* Find the destination *)
			destination=Lookup[primitiveAssociation,Destination,{}];
			
			(* Compare the lengths:
			 a) single entry in Source or Destination is fine (have to account for {container, well} specification here
			 b) same lengths are fine
			 *)
			Switch[{source, destination},
				{objectSpecificationP,_}, True,
				{_,objectSpecificationP}, True,
				{_,_}, Length[source]==Length[destination]
			]
		]
	]&/@manipulationsWithAmountKey;
	
	If[
		MemberQ[validTransferInputLengthBools,False]&&messagesBoolean,
		(
			Message[Error::PrimitiveInputLengthsInvalid,PickList[manipulationsWithAmountKey,validTransferInputLengthBools,False]];
			Message[Error::InvalidInput,PickList[manipulationsWithAmountKey,validTransferInputLengthBools,False]];
		),
		{}
	];
	
	validTransferInputLengthTest=If[gatherTests,
		Test[
			"All the Transfer primitives have matching lengths of Source and Destination keys:",
			MemberQ[validTransferInputLengthBools,False],
			False
		],
		Null
	];
	
	(* check the patterns of the keys in the provided manipulations to ensure validity;
	 	return a message for each invalid manipulation, and return $Failed for each to indicate invalidity *)
	manipulationKeyChecks = Map[
		Module[{keyValidities,invalidKeys},

			(* validate each of the manipulation's keys against full expected pattern *)
			keyValidities=KeyValueMap[
				Function[{key,value},
					(* Temp hack to allow Transfer to be listable *)
					If[MatchQ[#,_Transfer],
						MatchQ[
							value,
							If[MatchQ[key,Source|Destination|Amount],
								ListableP[Lookup[manipulationKeyPatterns[Head[#]],key],2],
								ListableP[Lookup[manipulationKeyPatterns[Head[#]],key]]
							]
						],
						MatchQ[value,Lookup[manipulationKeyPatterns[Head[#]],key]]
					]
				],
				First[#]
			];

			(* identify keys in this manipulation that do not match expected patterns *)
			invalidKeys=PickList[Keys[First[#]],keyValidities,False]

		]&,
		manipulationsWithAmountKey
	];

	(* for each of sample manipulation requested, check whether there is at least one invalid key *)
	invalidManipulationsBool = Map[
		If[Length[Flatten[#]] > 0, True, False]&,
		manipulationKeyChecks
	];

	(* Throw specific errors for invalid keys *)
	If[messagesBoolean,
		MapThread[
			Function[{primitiveIndex,invalidKeys},
				If[Length[invalidKeys] > 0,
					Map[
						(
							Message[
								Error::InvalidPrimitiveValue,
								#,
								Lookup[manipulationKeyPatterns[Head[manipulationsWithAmountKey[[primitiveIndex]]]],#],
								primitiveIndex
							];
						)&,
						invalidKeys
					]
				]
			],
			{Range[Length[manipulationsWithAmountKey]],manipulationKeyChecks}
		]
	];

	(*if we're gathering tests, return a test for each manipulation testing its validity *)
	invalidManipulationTest = MapThread[
		If[gatherTests,
			Test["All keys in the manipulation "<>ToString[#2]<>" primitive match the expected pattern:",#1,False],
			Null
		]&,
		{invalidManipulationsBool,myRawManipulations}
	];

	invalidManipulations = PickList[myRawManipulations,invalidManipulationsBool,True];

	(*if we're not returning tests, collect the message and a message bool so we can return $Failed later *)
	invalidManipulationMessage = If[messagesBoolean&&(Or@@invalidManipulationsBool),
		Message[Error::InvalidInput,invalidManipulations];
		True,
		False
	];

	If[TrueQ[Or@@invalidManipulationsBool]||MemberQ[validAmountsLengthInputBools,False]||MemberQ[validTransferInputLengthBools,False],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> DeleteCases[Join[safeOptionTests,validLengthTests,invalidManipulationTest,{validAmountsInputTest},{validTransferInputLengthTest}],Null],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* check if InWellSeparation Key exists in Transfer/Aliquot/Consolidation primitives as it is only supported by ExperimentAcousticLiquidHandling *)
	inWellSeparationKeyExistQ=Map[
		Switch[#,
			Alternatives[_Transfer,_Aliquot,_Consolidation],
			KeyExistsQ[Association@@#,InWellSeparation],
			_,
			False
		]&,
		myRawManipulations
	];

	(* get the position of primitives with InWellSeparation Key *)
	positionsWithInWellSeparationKey=Flatten[Position[inWellSeparationKeyExistQ,True]];

	(* if there are primitives with InWellSeparation Key and we are throwing messages, throw a warning message *)
	inWellSeparationKeyMessage=If[messagesBoolean,
		If[MatchQ[positionsWithInWellSeparationKey,{}],
			False,
			Message[Error::InWellSeparationKeyNotAllowed,positionsWithInWellSeparationKey];
			Message[Error::InvalidInput,PickList[myRawManipulations,inWellSeparationKeyExistQ]];
			True
		],
		Not[MatchQ[positionsWithInWellSeparationKey,{}]]
	];

	(* if we are gathering tests,create a passing and/or failing test with the appropriate result *)
	primitivesWithInWellSeparationKeyTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=
				If[MatchQ[positionsWithInWellSeparationKey,{}],
					Nothing,
					Test["The input primitives at index "<>ToString[positionsWithInWellSeparationKey]<>" do not have InWellSeparation Key:",True,False]];

			passingTest=
				If[Length[positionsWithInWellSeparationKey]==Length[myRawManipulations],
					Nothing,
					Test["The input primitives at index "<>ToString[Complement[Range[Length[myRawManipulations]],positionsWithInWellSeparationKey]]<>" do not have InWellSeparation Key:",True,True]];

			{failingTest,passingTest}
		],
		{}
	];

	(* convert the Resuspend primitives into Transfer+Incubate primitives *)
	primitivesWithListyResuspends = convertResuspendPrimitive /@ manipulationsWithAmountKey;

	(* get the length of each list that is in primitivesWithListyResuspends; this is useful later for converting the flat list of primitives into the groups from the primitives*)
	listyResuspendLengths = Length /@ primitivesWithListyResuspends;

	(* flatten it out so that the Transfer/Incubate pairs become one with the rest of things *)
	primitivesWithConvertedResuspends = Flatten[primitivesWithListyResuspends];

	(* add TransferType to manipulations without it, and ensure that if provided, it is compatible with the Amount(s);
	 currently this key only exists for Transfer, Aliquot, Consolidation and FillToVolume, so in all other cases,
	 add Test->Null no matter whether we're collecting Tests or not since the Test does not make sense in that case *)
	manipulationsWithTransferTypeTuples = Map[
		If[MatchQ[#,(_Transfer|_Aliquot|_Consolidation|_FillToVolume)],
			Module[
				{amounts,possibleTransferTypes,suppliedTransferType,resolvedTransferType,
				transferTypeDefaultedTestDescription,transferTypeDefaultedBool},

				(* get the amounts in the manipulation *)
				amounts = Switch[#,
					_Transfer,{#[Amount]},
					_FillToVolume,#[FinalVolume],
					_,#[Amounts]
				];

				(* determine the possible transfer types based on the amounts. If amounts are mass or integer (indicating a tablet), transfer type is solid. *)
				possibleTransferTypes=If[MatchQ[amounts,{(MassP | _Integer)..}],
					{Solid},
					{Liquid,Slurry}
				];

				(* if a TransferType was directly supplied, ensure it is consistent with Amount key;
				 	if not, or if not provided, default to first possible transfer type *)
				suppliedTransferType=#[TransferType];
				{resolvedTransferType,transferTypeDefaultedBool}=If[
					!MissingQ[suppliedTransferType]&&!MatchQ[suppliedTransferType,Automatic],
					If[!MemberQ[possibleTransferTypes,suppliedTransferType],
						(* Message[Warning::TransferTypeDefaulted,#,suppliedTransferType,First[possibleTransferTypes]]*)
						{First[possibleTransferTypes],True},
						{suppliedTransferType,False}
					],
					{First[possibleTransferTypes],False}
				];

				transferTypeDefaultedTestDescription = "The transfer type specified is consistent with the amount(s) of the manipulation.";

				(* update the TransferType key in the manipulation with the resolved choice *)
				(* if we are gathering messages, return the TransferType key and Null for the tests *)
				If[messagesBoolean,
					If[TrueQ[transferTypeDefaultedBool],
						(* throw a warning if the transfer type was defaulted *)
						Message[Warning::TransferTypeDefaulted,#,Head[#],First[possibleTransferTypes]];{Head[#][Append[First[#],TransferType->resolvedTransferType]],Null},
						{Head[#][Append[First[#],TransferType->resolvedTransferType]],Null}
					],
					(* if we are not collecting messages, we are collecting tests, so return the resolved Transfer Type and the Warning test *)
					{Head[#][Append[First[#],TransferType->resolvedTransferType]],Warning[transferTypeDefaultedTestDescription,transferTypeDefaultedBool,False]}
				]
			],
			{#,Null}
		]&,
		primitivesWithConvertedResuspends
	];

	(* pull out the manipulation with resolved TransferType from the tuple *)
	manipulationsWithTransferType = manipulationsWithTransferTypeTuples[[All, 1]];

	(* pull out the tests from the tuple *)
	transferTypeDefaultedTests = manipulationsWithTransferTypeTuples[[All, 2]];

	(* add Resuspension->False key to Transfers if it was not explicitly provided *)
	manipulationsWithResuspension = Map[
		If[MatchQ[#,_Transfer|_Aliquot|_Consolidation],
			If[MissingQ[#[Resuspension]],
				Head[#][Append[First[#],Resuspension->False]],
				#
			],
			#
		]&,
		manipulationsWithTransferType
	];

	(* Extract positions of Mix and Incubate primitives *)
	inputMixPrimitivePositions = Flatten[Position[manipulationsWithResuspension,_Mix,{1}]];
	inputIncubatePrimitivePositions = Flatten[Position[manipulationsWithResuspension,_Incubate,{1}]];

	(* Join both list of positions together *)
	inputMixIncubatePrimitivePositions = Sort[Join[inputMixPrimitivePositions,inputIncubatePrimitivePositions]];

	(* Extract the primitives at these positions *)
	inputMixIncubatePrimitives = manipulationsWithResuspension[[inputMixIncubatePrimitivePositions]];

	(* IMPORTANT: Because Mix and Incubate have the same interface but are treated differently behind the scenes,
	convert any Incubate primitives that are actually mix-by-pipette to Mix and any Mix primitives that
	are NOT mix-by-pipette to Incubate. Downstream we will convert these back to the input heads so
	not to confuse the user. *)
	convertedMixIncubatePrimitives = Map[
		If[MatchQ[#,_Mix|_Incubate],
			If[
				Or[
					MatchQ[#[MixType],ListableP[Pipette]],
					And[
						MatchQ[#[MixVolume],ListableP[VolumeP]],
						MatchQ[#[NumberOfMixes],ListableP[_Integer|_Missing]],
						MatchQ[#[MixType],ListableP[Pipette|Null|_Missing]]
					]
				],
				Mix[First[#]],
				(* if we're channeling a Macro Mix into Macro Incubate, turn the Mix boolean to True to make sure we're actually gonna resolve to mixing and not just incubation without mixing *)
				Incubate[If[(MatchQ[#,_Mix]&&MatchQ[#[Mix],_Missing]&&MatchQ[LiquidHandlingScale/.safeOptions,(MacroLiquidHandling|Automatic)]),Append[First[#],Mix->True],First[#]]]
			],
			#
		]&,
		manipulationsWithResuspension
	];

	(* Expand singleton keys in any Mix primitives *)
	manipulationsWithExpandedMixes = Map[
		If[MatchQ[#,_Mix],
			Module[{expandedSamples},

				expandedSamples = If[MatchQ[#[Sample],objectSpecificationP],
					{#[Sample]},
					#[Sample]
				];

				Mix[
					Prepend[First[#],
						Join[
							{
								Sample -> If[MatchQ[#[Sample],objectSpecificationP],
									{#[Sample]},
									#[Sample]
								],
								If[MatchQ[#[MixType],_Missing],
									Nothing,
									MixType -> If[MatchQ[#[MixType],MixTypeP|Null],
										Table[#[MixType],Length[expandedSamples]],
										#[MixType]
									]
								],
								If[MatchQ[#[NumberOfMixes],_Missing],
									Nothing,
									NumberOfMixes -> If[MatchQ[#[NumberOfMixes],_Integer],
										Table[#[NumberOfMixes],Length[expandedSamples]],
										#[NumberOfMixes]
									]
								],
								If[MatchQ[#[MixVolume],_Missing],
									Nothing,
									MixVolume -> If[MatchQ[#[MixVolume],VolumeP],
										Table[#[MixVolume],Length[expandedSamples]],
										#[MixVolume]
									]
								]
							},
							KeyValueMap[
								If[MemberQ[Keys[manipulationKeyPatterns[Mix]],#1],
									If[MatchQ[#2,Lookup[manipulationKeyPatterns[Mix],#1]],
										#1 -> Table[#2,Length[expandedSamples]],
										Nothing
									],
									Nothing
								]&,
								KeyDrop[First[#],{Sample,MixType,NumberOfMixes,MixVolume}]
							]
						]
					]
				]
			],
			#
		]&,
		convertedMixIncubatePrimitives
	];

	(* Expand singleton Sample key in Incubate primitives
	(Other Incubate keys will be expanded in resolution) *)
	manipulationsWithExpandedIncubations = Map[
		If[MatchQ[#,_Incubate],
			Incubate[
				Prepend[
					First[#],
					Sample -> If[MatchQ[#[Sample],objectSpecificationP],
						{#[Sample]},
						#[Sample]
					]
				]
			],
			#
		]&,
		manipulationsWithExpandedMixes
	];

	(* Converts Aliquot and Consolidation primitives to low-level Transfer syntax
	and returns Transfer primitives with expanded Source/Destination/Amount key values *)
	primitivesWithConvertedTransfers = convertTransferPrimitive/@manipulationsWithExpandedIncubations;

	(* get the primitives in the listy form from the Resuspend primitives (i.e., if it is from a Resuspend primitive with a Transfer and an Incubate, those are grouped as a list; everything else stays the same) *)
	primitivesWithConvertedTransfersListy = TakeList[primitivesWithConvertedTransfers, listyResuspendLengths] /. {{x:SampleManipulationP} :> x};

	(* Handle primitives that have zero amounts. Remove any zero-amounts or set an entire primitive to
	$Failed if all its amounts are 0. Also build tests for all these checks. Return in the form:
	{{primitive or $Failed, tests}..} *)
	nonZeroAmountManipulationTuples = MapThread[
		Function[{primitive,rawPrimitive,primitiveIndex},
			Module[{allZeroAmountsTestDescription,zeroAmountsTestDescription},

				(* Test descriptions for zero-amount cases *)
				allZeroAmountsTestDescription = StringJoin[
					"The primitive at position ",
					ToString[primitiveIndex],
					" has amounts greater than zero:"
				];
				zeroAmountsTestDescription = StringJoin[
					"The primitive's amounts at position ",
					ToString[primitiveIndex],
					" have no amounts that are zero and therefore no transfers will be removed:"
				];

				(* For the primitive, check if it has zero-amounts *)
				Switch[primitive,
					(* Check Amount key in Transfer primitives *)
					(* If we're dealing with a pair of Transfer + Incubate/Mix, then we're dealing with a former Resuspend primitive*)
					_Transfer | {_Transfer, _Incubate|_Mix},
						Module[
							{amounts,sources,destinations,zeroAmountPositions,trimmedAmounts,fullyRemovedIndices,
								actualTransferPrimitive},

							(* if we have a list of transfer + incubate/mix (i.e., from a Resuspend primitive), then just deal with the Transfer primitive *)
							actualTransferPrimitive = If[MatchQ[primitive, _Transfer],
								primitive,
								First[primitive]
							];

							(* Extract key-values *)
							amounts = actualTransferPrimitive[Amount];
							sources = actualTransferPrimitive[Source];
							destinations = actualTransferPrimitive[Destination];
							(* Find any positions where the amount is zero *)
							zeroAmountPositions = Position[amounts,_?PossibleZeroQ,{2}];

							(* Delete positions with 0 amount ie: if an original amount list was {{0,0},{1,0}},
							trimmedAmounts would be {{},{1}} *)
							trimmedAmounts = Delete[amounts,zeroAmountPositions];

							(* Find nested positions for which all amounts were removed.
							Ie: if an original amount list was {{0,0},{1,0}}, trimmedAmounts would be {{},{1}}
							and this would return {1}. *)
							fullyRemovedIndices = Position[trimmedAmounts,{},{1}];

							(* Handle cases where ALL amounts are zero, some amounts are zero, or none are zero *)
							Which[
								(* If all amounts are 0, then we remove this Transfer completely *)
								(* Note that this will _also_ take out the Incubate/Mix primitive that came from the Resuspend primitives, but that's totally fine*)
								MatchQ[trimmedAmounts,{{}..}],
									{
										$Failed,
										If[messagesBoolean,
											(
												If[warningsBoolean,
													Message[Warning::ZeroAmountManipulationRemoved,rawPrimitive]; Message[Warning::ZeroAmountRemoved,rawPrimitive];
												];
												{}
											),
											{
												warningOrNull[allZeroAmountsTestDescription,False],
												warningOrNull[zeroAmountsTestDescription,False]
											}
										]
									},
								(* If some amounts are 0, remove those indices from all keys *)
								(* note that since Resuspend can only take one sample at a time, the Transfer is only ever going to have one and so we won't go down this path, so this is totally fine*)
								Length[zeroAmountPositions] > 0,
									{
										Transfer[
											Join[
												{
													Source -> Delete[sources,Join[fullyRemovedIndices,zeroAmountPositions]],
													Destination -> Delete[destinations,Join[fullyRemovedIndices,zeroAmountPositions]],
													Amount -> Delete[amounts,Join[fullyRemovedIndices,zeroAmountPositions]]
												},
												KeyValueMap[
													(* Take first index of positions since all these keys are not nested as deep
													as Source/Destination/Amount *)
													#1 -> Delete[#2,fullyRemovedIndices]&,
													KeyDrop[First[primitive],{Source,Destination,Amount}]
												]
											]
										],
										If[messagesBoolean,
											(
												If[warningsBoolean,
													Message[Warning::ZeroAmountRemoved,rawPrimitive];
												];
												{}
											),
											{
												warningOrNull[allZeroAmountsTestDescription,True],
												warningOrNull[zeroAmountsTestDescription,False]
											}
										]
									},
								(* Otherwise, we're all good with the original primitive *)
								True,
									{
										primitive,
										If[messagesBoolean,
											{},
											{
												warningOrNull[allZeroAmountsTestDescription,True],
												warningOrNull[zeroAmountsTestDescription,True]
											}
										]
									}
							]
						],
					(* We only need to worry about the FinalVolume key in FillToVolume primitives *)
					_FillToVolume,
						If[PossibleZeroQ[primitive[FinalVolume]],
							{
								$Failed,
								If[messagesBoolean,
									(
										If[warningsBoolean,
											Message[Warning::ZeroAmountManipulationRemoved,rawPrimitive]; Message[Warning::ZeroAmountRemoved,rawPrimitive];
										];
										{}
									),
									{
										warningOrNull[allZeroAmountsTestDescription,False],
										warningOrNull[zeroAmountsTestDescription,False]
									}
								]
							},
							{
								primitive,
								If[messagesBoolean,
									{},
									{
										warningOrNull[allZeroAmountsTestDescription,True],
										warningOrNull[zeroAmountsTestDescription,True]
									}
								]
							}
						],
					_Mix,
						If[Or[MissingQ[primitive[MixVolume]],MissingQ[primitive[NumberOfMixes]]],
							{$Failed,{}},
							{primitive,{}}
						],
					_,
						{primitive,{}}
				]
			]
		],
		{primitivesWithConvertedTransfersListy,manipulationsWithAmountKey,Range[Length[primitivesWithConvertedTransfersListy]]}
	];

	(* Extract from the tuples the nonZeroAmountManipulations (ignore any $Failed entries since those are the manipulations that we're going to ignore *)
	nonZeroAmountManipulations = Flatten[DeleteCases[nonZeroAmountManipulationTuples[[All,1]],$Failed]];

	(* Because we may have removed some primitive, we need to update a list that index-matches the
	NOT removed primitives to their original position in the input list *)
	(* Note also that the ConstantArray is because if we expanded a Resuspend primitive to be a Transfer+Incubate/Mix primitive, we are going to have two primitives in here but we want them to correspond to the same initial index *)
	modifiedRawManipulationPositions = Flatten[MapIndexed[
		If[MatchQ[#1,$Failed],
			Nothing,
			ConstantArray[#2, Length[ToList[#1]]]
		]&,
		nonZeroAmountManipulationTuples[[All,1]]
	]];

	(* Extract from the tuples the corresponding tests *)
	nonZeroAmountManipulationTests = Flatten[nonZeroAmountManipulationTuples[[All,2]]];

	(* Return $Failed and throw an appropriate error message if all manipulations were removed;
		do some wacky shit to return legit stuff in this fucked case *)
	If[Length[nonZeroAmountManipulations] == 0,
		Message[Error::AllManipulationsRemoved];
		Message[Error::InvalidInput,myRawManipulations];
		Return[
			outputSpecification/.{
				Result->$Failed,
				Preview->Null,
				Tests->DeleteCases[Join[invalidManipulationTest,transferTypeDefaultedTests,nonZeroAmountManipulationTests],Null],
				Options->RemoveHiddenOptions[
					ExperimentSampleManipulation,
					CollapseIndexMatchedOptions[
						ExperimentSampleManipulation,
						ReplaceRule[safeOptions,{
							LiquidHandlingScale->If[MatchQ[LiquidHandlingScale/.safeOptions,Automatic],
								MacroLiquidHandling,
								LiquidHandlingScale/.safeOptions
							],
							LiquidHandler->If[MatchQ[LiquidHandler/.safeOptions,Automatic],
								Null,
								LiquidHandler/.safeOptions
							],
							ImageSample->If[MatchQ[ImageSample/.safeOptions,Automatic],
								True,
								ImageSample/.safeOptions
							]
						}]
					]
				]
			}
		]
	];

	(* Download information from this model since it may need to be used for CE vials on the robot deck *)
	ceVialRackModel = Model[Container, Rack, "id:kEJ9mqR4RkGe"];
	phyTipRackModel = Model[Container,Rack, "id:54n6evLRjd4G"];

	(* If CollectionContainer is not specified, we will default to a 2mL DWP *)
	defaultFilterCollectionModel = Model[Container, Plate, "id:L8kPEjkmLbvW"];
	
	(* Use this for large volume storage on the liquid handler decks *)
	defaultOnDeckReservoir = Model[Container,Plate,"id:54n6evLWKqbG"];

	(* Certain vessels need to be in a certain liquid-handler-compatible rack to be
	used in MicroLiquidHandling. Define this lookup early so we can download required
	fields from the rack models. *)
	modelContainersRequiringAdapting = Search[{Model[Container,Vessel],Model[Container,Plate]},LiquidHandlerAdapter!=Null];

	(* If the primitives contain Filter, we need to download from all possible model containers that ExperimentFilter may resolve the ContainerOut to *)
	filterModelContainersOut=If[MemberQ[nonZeroAmountManipulations,_Filter],
		DeleteDuplicates[
			Flatten[{
				PreferredContainer[All,Type->All],
				PreferredContainer[All,Sterile->True,Type->All],
				PreferredContainer[All,LightSensitive->True,Type->All],
				{Model[Container, Plate, "id:L8kPEjkmLbvW"],Model[Container,Plate,"id:n0k9mGzRaaBn"]}
			}]
		],
		{}
	];

	(* extract separate lists that each container a specific type of object *)
	samples = findObjectsOfTypeInPrimitive[nonZeroAmountManipulations,Object[Sample]];
	models = findObjectsOfTypeInPrimitive[nonZeroAmountManipulations,Model[Sample]];
	containers = findObjectsOfTypeInPrimitive[nonZeroAmountManipulations,Object[Container]];
	modelContainers = Join[
		findObjectsOfTypeInPrimitive[nonZeroAmountManipulations,Model[Container]],
		{ceVialRackModel,phyTipRackModel,defaultFilterCollectionModel},
		modelContainersRequiringAdapting,
		(* all possible containers that the filter primitives may use as ContainerOut *)
		filterModelContainersOut,
		{defaultOnDeckReservoir}
	];

	specifiedPipettingMethods = Cases[
		Flatten@Map[
			(#[PipettingMethod])&,
			nonZeroAmountManipulations
		],
		ObjectP[]
	];
	specifiedTipTypes = Cases[
		Flatten@Map[
			(#[TipType])&,
			nonZeroAmountManipulations
		],
		ObjectP[]
	];

	(* We need to download fields from all liquid-handler compatible tips *)
	possibleTips = {
		Model[Item,Tips,"300 uL Hamilton tips, non-sterile"],
		Model[Item,Tips,"300 uL Hamilton barrier tips, sterile"],
		Model[Item,Tips,"300 uL Hamilton barrier tips, wide bore, 1.55mm orifice"],
		Model[Item,Tips,"1000 uL Hamilton tips, non-sterile"],
		Model[Item,Tips,"1000 uL Hamilton barrier tips, sterile"],
		Model[Item,Tips,"1000 uL Hamilton barrier tips, wide bore, 3.2mm orifice"],
		Model[Item,Tips,"50 uL Hamilton tips, non-sterile"],
		Model[Item,Tips,"50 uL Hamilton barrier tips, sterile"],
		Model[Item,Tips,"10 uL Hamilton tips, non-sterile"],
		Model[Item,Tips,"10 uL Hamilton barrier tips, sterile"]
	};

	(* Join any specified tips and known-compatible tips *)
	allTips = Join[possibleTips,specifiedTipTypes];

	(* Get all centrifuge related objects *)
	centrifugeRelatedObjects = Flatten[Experiment`Private`allCentrifugeEquipmentSearch["Memoization"]];
	centrifugeInstruments = Cases[centrifugeRelatedObjects, ObjectP[Model[Instrument, Centrifuge]]];
	centrifugeRotors = Cases[centrifugeRelatedObjects, ObjectP[Model[Container, CentrifugeRotor]]];
	centrifugeBuckets = Cases[centrifugeRelatedObjects, ObjectP[Model[Container, CentrifugeBucket]]];
	centrifugeAdapters = Cases[centrifugeRelatedObjects, ObjectP[Model[Part, CentrifugeAdapter]]];

	(* for the objects, we need to traverse some links to get all the packets we want; construct those full field specs *)
	sampleAllFields = {
		Packet[Status,Model,Volume,Mass,Count,Position,Container,UltrasonicIncompatible,Tablet,TabletWeight,Composition,PipettingMethod,State,Ventilated,Solvent,LiquidHandlerIncompatible],
		Packet[PipettingMethod[All]],
		Packet[Field[Composition[[All,2]]][{Deprecated,LiquidHandlerIncompatible,State,Ventilated}]],
		Packet[Model[{Deprecated,LiquidHandlerIncompatible,State,Ventilated}]], (* TODO DO I NEED THIS LINE *)
		Packet[Container[{Status,Model,Contents,TareWeight,KitComponents}]],
		Packet[Container[Model][{Deprecated,MaxVolume,MinVolume,Footprint,VolumeCalibrations,Immobile,TareWeight,NumberOfWells,OpenContainer,LidSpacerRequired,MultiProbeHeadIncompatible,HighPrecisionPositionRequired,Aperture,InternalDepth,WellDimensions,WellDiameter,WellDepth,WellPositionDimensions,WellDiameters,WellDepths,Counterweights,StorageBufferVolume}]],
		Packet[Container[Model][Counterweights][{Weight,Footprint}]],
		Packet[Container[Model][VolumeCalibrations][{Anomalous,Deprecated}]],
		Packet[Model[PipettingMethod[All]]],
		Packet[Field[Container[Contents][[All,2]]][{Status,Model,Volume,Mass,Count,Position,Container,Composition}]],
		(* these are required for ContainerOut from filter primitives where the collection container will be a specific object connected already to the top part *)
		Packet[Container[KitComponents][Model]],
		Packet[Container[KitComponents][Model][{MaxVolume,Footprint}]],
		Packet[Field[Solvent][{PipettingMethod}]],
		Packet[Field[Solvent][PipettingMethod[All]]]
	};
	modelAllFields = {
		Packet[Deprecated,LiquidHandlerIncompatible,Tablet,TabletWeight,State,PipettingMethod,Ventilated,Solvent,Autoclave],
		Packet[Products[{Deprecated,ProductModel,Amount,CountPerSample}]],
		Packet[KitProducts[{Deprecated,KitComponents}]],
		Packet[PipettingMethod[All]],
		Packet[Field[Solvent][{PipettingMethod}]],
		Packet[Field[Solvent][PipettingMethod[All]]]
	};
	containerAllFields = {
		Packet[Status,Model,Contents,TareWeight],
		Packet[Model[{Deprecated,MaxVolume,MinVolume,Footprint,VolumeCalibrations,MembraneMaterial,PoreSize,Immobile,TareWeight,NumberOfWells,OpenContainer,LidSpacerRequired,MultiProbeHeadIncompatible,HighPrecisionPositionRequired,Aperture,InternalDepth,WellDimensions,WellDiameter,WellDepth,WellPositionDimensions,WellDiameters,WellDepths,Counterweights,StorageBufferVolume}]],
		Packet[Model[Counterweights][{Weight,Footprint}]],
		Packet[Field[Contents[[All,2]]][{Status,Model,Volume,Mass,Count,Position,Container,Composition,LiquidHandlerIncompatible}]],
		Packet[Field[Contents[[All,2]][Composition[[All,2]]]][{Deprecated,LiquidHandlerIncompatible,PipettingMethod,Ventilated}]],
		Packet[Field[Contents[[All,2]]][Model][{Deprecated,LiquidHandlerIncompatible,PipettingMethod,Ventilated}]],
		Packet[Model[VolumeCalibrations][{Anomalous,Deprecated}]],
		Packet[Field[Contents[[All,2]]][Model][PipettingMethod][All]]
	};
	modelContainerAllFields = {
		Packet[Deprecated,MaxVolume,MinVolume,Footprint,VolumeCalibrations,Rows,Columns,NumberOfPositions,NumberOfWells,Positions,MembraneMaterial,PoreSize,TareWeight,OpenContainer,LidSpacerRequired,MultiProbeHeadIncompatible,HighPrecisionPositionRequired,Aperture,InternalDepth,WellDimensions,WellDiameter,WellDepth,LiquidHandlerAdapter,WellPositionDimensions,WellDiameters,WellDepths,Counterweights,StorageBufferVolume],
		Packet[Counterweights[{Weight,Footprint}]],
		Packet[VolumeCalibrations[{Anomalous,Deprecated}]],
		Packet[LiquidHandlerAdapter[{Deprecated,MaxVolume,MinVolume,Footprint,VolumeCalibrations,Rows,Columns,NumberOfPositions,NumberOfWells,Positions,MembraneMaterial,PoreSize,TareWeight,OpenContainer,LidSpacerRequired,MultiProbeHeadIncompatible,HighPrecisionPositionRequired}]]
	};
	pipettingMethodFields = {Packet[All]};
	tipFields = {Packet[MaxVolume,WideBore,Filtered,NumberOfTips,MaxStackSize,AspirationDepth]};

	(* Centrifuge related fields *)
	centrifugeInstrumentFields={Packet[MaxTime,MaxTemperature,MinTemperature,MaxRotationRate,MinRotationRate,CentrifugeType,SampleHandlingCategories,Footprint,Positions,Name,SpeedResolution,RequestedResources,MaxStackHeight,MaxWeight]};
	centrifugeRotorFields=centrifugeRotorDownloadFields[];
	centifugeBucketFields=centrifugeBucketDownloadFields[];
	centrifugeAdapterFields=centrifugeAdapterDownloadFields[];

	(* set the provided PreparedResources to a local variable; assumign either empty list or index-matched to myManipulations since Hidden option;
	 	also look up the RentContainer option; this will be used specifically by StockSolution when this SM is for preparing the solution;
		the StockSolution has Preparedresources, but if we go turtles and the SS has an SS component, need to pass down RentContainer *)
	preparedResources = Lookup[safeOptions,PreparedResources];
	rentContainerFromSS = Lookup[safeOptions,RentContainer];

	(* define the fields we would want to download from the prepped resources *)
	preparedResourceFields = {Packet[RentContainer]};

	(* Only try and download info from parent if it's already in the database - legacy experiments may still call ExperimentSampleManipulation before their own upload *)
	parentProtocolDownloadObject = If[MatchQ[parentProtocol,ObjectP[]]&&DatabaseMemberQ[parentProtocol],
		parentProtocol,
		Null
	];

	(* construct a single Download call that will get everything we want; assign raw output to tuples pending further separation into particular packets;
	 	If liquid handler is provided as an instrument: we need to get its model in addition to standard sample/model/container stuff
		 	- otherwise, if provided as a Model, just get the object reference
			- and if Automatic, we don't know the liquid handler model yet (set to Null) *)
	downloadPackets = If[MatchQ[liquidHandlerOption,ObjectP[Object[Instrument,LiquidHandler]]],
		Quiet[Download[
			{samples,models,containers,modelContainers,specifiedPipettingMethods,allTips,preparedResources,{parentProtocolDownloadObject},{liquidHandlerOption},centrifugeInstruments,centrifugeRotors,centrifugeBuckets,centrifugeAdapters},
			{sampleAllFields,modelAllFields,containerAllFields,modelContainerAllFields,pipettingMethodFields,tipFields,preparedResourceFields,{Packet[ImageSample],Packet[ParentProtocol..[ImageSample]]},{Packet[Model]},centrifugeInstrumentFields,{Evaluate[Packet[Sequence@@centrifugeRotorFields]]},{Evaluate[Packet[Sequence@@centifugeBucketFields]]},{Evaluate[Packet[Sequence@@centrifugeAdapterFields]]}},
			Cache->(Cache/.safeOptions)
		],{Download::MissingField,Download::FieldDoesntExist,Download::NotLinkField,Download::MissingCacheField}],
		Quiet[Download[
			{samples,models,containers,modelContainers,specifiedPipettingMethods,allTips,preparedResources,{parentProtocolDownloadObject},centrifugeInstruments,centrifugeRotors,centrifugeBuckets,centrifugeAdapters},
			{sampleAllFields,modelAllFields,containerAllFields,modelContainerAllFields,pipettingMethodFields,tipFields,preparedResourceFields,{Packet[ImageSample],Packet[ParentProtocol..[ImageSample]]},centrifugeInstrumentFields,{Evaluate[Packet[Sequence@@centrifugeRotorFields]]},{Evaluate[Packet[Sequence@@centifugeBucketFields]]},{Evaluate[Packet[Sequence@@centrifugeAdapterFields]]}},
			Cache->(Cache/.safeOptions)
		],{Download::MissingField,Download::FieldDoesntExist,Download::NotLinkField,Download::MissingCacheField}]
	];

	(* Merge all packets so we can use it as a psuedo cache *)
	allPackets = FlattenCachePackets[
		DeleteCases[Flatten[downloadPackets],Null|$Failed]
	];

	(* Extract samples' container and specified container packets *)
	uniqueContainerPackets = DeleteDuplicatesBy[
		Join[
			fetchPacketFromCacheHPLC[#,allPackets]&/@((fetchPacketFromCacheHPLC[#,allPackets]&/@Download[samples,Object])[[All,Key[Container]]]),
			fetchPacketFromCacheHPLC[#,allPackets]&/@Download[containers,Object]
		],
		#[Object]&
	];

	(* All specified samples and container contents packets *)
	uniqueSamplePackets = Map[
		fetchPacketFromCacheHPLC[#,allPackets]&,
		DeleteDuplicates@Download[
			Flatten[{
				((fetchPacketFromCacheHPLC[#,allPackets]&/@Download[containers,Object])[[All,Key[Contents]]])[[All,All,2]],
				samples
			}],
			Object
		]
	];
	
	counterweightModelPackets = Cases[Cases[allPackets,PacketP[Model[Item,Counterweight]]],KeyValuePattern[Footprint->Plate]];
	counterweightWeights = counterweightModelPackets[[All,Key[Weight]]];

	(* Centrifuge packets *)
	centrifugePackets=fetchPacketFromCacheHPLC[#,allPackets]&/@centrifugeRelatedObjects;

	(* IMPORTANT: This assumes that all protocol packets in the cache-ball are parents
	ie if you add a new download field that fetches protocol packets, this line must be modified. *)
	parentProtocolPackets = Cases[allPackets,ObjectP[{Object[Protocol],Object[Qualification],Object[Maintenance]}]];

	(* --- do some quick error checking now that we have Downloaded information from all objects --- *)
	(* identify any samples/containers that are discarded and throw an error if any are found *)
	discardedPackets = Select[
		fetchPacketFromCacheHPLC[#,allPackets]&/@Download[Join[samples,containers],Object],
		MatchQ[Lookup[#,Status],Discarded]&
	];

	(* check whether discarded samples or containers exist *)
	discardedPacketsExistQ = And[
		!TrueQ[Lookup[safeOptions,FastTrack]],
		MatchQ[discardedPackets,{PacketP[]..}]
	];

	(* if we're gathering tests, return a test whether sample manipulations contain samples/containers that are discarded *)
	discardedSamplesTest = If[discardedPacketsExistQ,
		(
			If[messagesBoolean,
				(
					Message[Error::DiscardedSamples,Lookup[discardedPackets,Object]];
					Message[Error::InvalidInput,Lookup[discardedPackets,Object]];
					Null
				),
				testOrNull["None of the sample/container objects in the requested sample manipulations are discarded:",False]
			]
		),
		If[gatherTests,
			testOrNull["None of the sample/container objects in the requested sample manipulations are discarded:",True],
			Null
		]
	];

	(* identify any models/container models that are Deprecated and throw an error if any are found *)
	deprecatedPackets = Select[
		fetchPacketFromCacheHPLC[#,allPackets]&/@Join[containers,modelContainers],
		TrueQ[Lookup[#,Deprecated]]&
	];

	(* check whether discarded samples or containers exist *)
	deprecatedPacketsExistQ = And[
		!TrueQ[Lookup[safeOptions,FastTrack]],
		MatchQ[deprecatedPackets,{PacketP[]..}]
	];

	(* if we're gathering tests, return a test whether sample manipulations contain samples/containers that are deprecated *)
	deprecatedSamplesTest = If[deprecatedPacketsExistQ,
		(
			If[messagesBoolean,
				(
					Message[Error::DeprecatedModels,Lookup[deprecatedPackets,Object]];
					Message[Error::InvalidInput,Lookup[deprecatedPackets,Object]];
					Null
				),
				testOrNull["None of the model samples/containers in the requested sample manipulations are deprecated:",False]
			]
		),
		If[gatherTests,
			testOrNull["None of the model samples/containers in the requested sample manipulations are deprecated:",True],
			Null
		]
	];

	(* Extract specified liquid handler model *)
	liquidHandlerModel = Switch[liquidHandlerOption,
		ObjectP[Object[Instrument,LiquidHandler]],
			Download[Lookup[fetchPacketFromCacheHPLC[liquidHandlerOption,allPackets],Model],Object],
		ObjectP[Model[Instrument,LiquidHandler]],
			Download[liquidHandlerOption,Object],
		_,
			Null
	];

	(* Fetch packets of PreparedResources *)
	preparedResourcePackets = fetchPacketFromCacheHPLC[#,allPackets]&/@preparedResources;

	(* will be convenient to just keep a list of the RentContainer bools from EITHER the PreparedResources packets or the RentContainer option;
		ASSUME that we will have XOR of these options (PreparedResources is passed by Engine, and RentContainer by StockSolution procedure);
		ASSUME we have index-matching with the manipulations in either case (Hidden option, don't enforce, please upstream don't screw up)
		the meaning here is the same though, so we can combine; set to False if we don't have either of these *)
	resourceRentContainerBools = Which[
		MatchQ[preparedResourcePackets,{PacketP[]..}],
			TrueQ/@Lookup[preparedResourcePackets,RentContainer],
		MatchQ[rentContainerFromSS,{BooleanP..}],
			rentContainerFromSS,
		True,
			ConstantArray[False,Length[nonZeroAmountManipulations]]
	];


	(* resolveLiquidHandlingScale expects a Cache with only relevant packets (sample models and containers) *)
	liquidHandlingScaleCache = DeleteCases[
		Join[
			uniqueSamplePackets,
			fetchPacketFromCacheHPLC[#,allPackets]&/@(uniqueSamplePackets[[All,Key[Model]]]),
			fetchPacketFromCacheHPLC[#,allPackets]&/@Download[models,Object],
			uniqueContainerPackets,
			Cases[allPackets,PacketP[Model[Container]]]
		],
		(* Delete Null in case sample Model doesn't exist *)
		Null
	];

	(* Determine the appropriate liquid handling scale given the containers/amounts involved in the manipulations;
		 if this is a direct child of a sample manipulation, must do macro, as we are doing a resource transfer
		to get something in a Hamilton-compatible container

	 Get the resolved scale along with a list of messages and tests when appropriate in the form Result = {scale, {messagesBools},{tests}};
		 make sure the secret default case here is compatible with remaining messages-y code

	Cam code: pls don't blame robert for confusion or severely lacking capabilities *)
	{resolvedLiquidHandlingScale,{cannotResolveScaleMessagesBool,resolvedLiquidHandlingScaleTests}} = If[
		MatchQ[parentProtocol,ObjectP[Object[Protocol,SampleManipulation]]],
		{MacroLiquidHandling,{{False},{}}},
		resolveLiquidHandlingScale[
			nonZeroAmountManipulations,
			Lookup[safeOptions,LiquidHandlingScale],
			(* This input used to be the BufferBot option value. Since BufferBot is highly not in use,
			we hard-code this to False for now *)
			False,
			gatherTests,
			manipulationsWithAmountKey,
			Cache -> liquidHandlingScaleCache
		]
	];

	(* from the resolvedLiquidHandlingScale results, pull out the resolvedLiquidHandlingScale; since this may be $failed but we still gotta keep going,
	 	fuck it and set it to macro in another var and chug along *)
	scaleToUseForFurtherResolving = If[MatchQ[resolvedLiquidHandlingScale,$Failed],
		MacroLiquidHandling,
		resolvedLiquidHandlingScale
	];

	(* === Define Primitive Resolution === *)

	(* Resolve key values in any Define primitives *)
	manipulationsWithResolvedDefines = Map[
		If[MatchQ[#,_Define],
			resolveDefinePrimitive[#,Cache -> allPackets],
			#
		]&,
		nonZeroAmountManipulations
	];

	(* Extract all Define primitives *)
	resolvedDefinePrimitives = Cases[manipulationsWithResolvedDefines,_Define];

	(* Build association lookup of "Name" -> Define primitive *)
	definedNamesLookup = Association@Flatten@Map[
		{
			(#[Name] -> #),
			If[MatchQ[#[ContainerName],_String],
				#[ContainerName] -> #,
				Nothing
			]
		}&,
		resolvedDefinePrimitives
	];

	(* Define function to build tests for each individual Define primitive *)
	validDefinesQ = True;
	generateDefineTests[definePrimitive_Define,primitiveIndex_Integer]:=Module[
		{modelTypeNameTest,sampleContainerTest,modelParametersTest,containerNameTest,
		modelSpecificationTest,sampleParameterTest,sufficientKeysTest},

		(* If ModelType is populated, ModelName must be populated *)
		modelTypeNameTest = If[
			Or[
				And[
					MatchQ[definePrimitive[ModelType],TypeP[]],
					!MatchQ[definePrimitive[ModelName],_String]
				],
				And[
					MatchQ[definePrimitive[ModelName],_String],
					!MatchQ[definePrimitive[ModelType],TypeP[]]
				]
			],
			validDefinesQ = False;
			If[gatherTests,
				Test[StringTemplate["Either both ModelName or ModelType or neither are specified in the Define at index `1`:"][primitiveIndex],True,False],
				Message[Error::InvalidModelTypeName,primitiveIndex];
				Message[Error::InvalidInput,myRawManipulations[[primitiveIndex]]];
				Null
			],
			If[gatherTests,
				Test[StringTemplate["Either both ModelName or ModelType or neither are specified in the Define at index `1`:"][primitiveIndex],True,True],
				Null
			]
		];

		(* If ModelName/ModelType is populated, Sample must be a location or Container is specified *)
		sampleContainerTest = If[
			And[
				Or[
					MatchQ[definePrimitive[ModelType],TypeP[]],
					MatchQ[definePrimitive[ModelType],_String]
				],
				And[
					!MatchQ[definePrimitive[Sample],ObjectP[{Object[Container],Model[Container]}]|{ObjectP[{Object[Container],Model[Container]}],_String}],
					!MatchQ[definePrimitive[Container],ObjectP[]]
				]
			],
			validDefinesQ = False;
			If[gatherTests,
				Test[StringTemplate["If ModelName or ModelType is specified, Sample is a location or Container is specified in the Define at index `1`:"][primitiveIndex],True,False],
				Message[Error::InvalidSampleContainer,primitiveIndex];
				Message[Error::InvalidInput,myRawManipulations[[primitiveIndex]]];
				Null
			],
			If[gatherTests,
				Test[StringTemplate["If ModelName or ModelType is specified, Sample is a location or Container is specified in the Define at index `1`:"][primitiveIndex],True,True],
				Null
			]
		];


		(* If TransportWarmed, State, Expires, ShelfLife, UnsealedShelfLife, or DefaultStorageCondition
		is populated, ModelType and ModelName must be populated *)
		modelParametersTest = If[
			And[
				Or[
					MatchQ[definePrimitive[TransportWarmed],Except[_Missing|Null|Automatic]],
					MatchQ[definePrimitive[State],Except[_Missing|Null|Automatic]],
					MatchQ[definePrimitive[Expires],Except[_Missing|Null|Automatic]],
					MatchQ[definePrimitive[ShelfLife],Except[_Missing|Null|Automatic]],
					MatchQ[definePrimitive[UnsealedShelfLife],Except[_Missing|Null|Automatic]],
					MatchQ[definePrimitive[DefaultStorageCondition],Except[_Missing|Null|Automatic]]
				],
				And[
					!MatchQ[definePrimitive[ModelType],TypeP[]],
					!MatchQ[definePrimitive[ModelType],_String]
				]
			],
			validDefinesQ = False;
			If[gatherTests,
				Test[StringTemplate["If model parameter(s) TransportWarmed, State, Expires, ShelfLife, UnsealedShelfLife, or DefaultStorageCondition are specified, ModelType and ModelName are specified in the Define at index `1`:"][primitiveIndex],True,False],
				Message[Error::InvalidModelParameters,primitiveIndex];
				Message[Error::InvalidInput,myRawManipulations[[primitiveIndex]]];
				Null
			],
			If[gatherTests,
				Test[StringTemplate["If model parameter(s) TransportWarmed, State, Expires, ShelfLife, UnsealedShelfLife, or DefaultStorageCondition are specified, ModelType and ModelName are specified in the Define at index `1`:"][primitiveIndex],True,True],
				Null
			]
		];

		(* If ContainerName is populated, Container must be populated or Sample must be a sample or tuple *)
		containerNameTest = If[
			And[
				MatchQ[definePrimitive[ContainerName],_String],
				!Or[
					MatchQ[definePrimitive[Container],ObjectP[]],
					MatchQ[definePrimitive[Sample],{ObjectP[],_String}],
					MatchQ[definePrimitive[Sample],ObjectP[Object[Sample]]]
				]
			],
			validDefinesQ = False;
			If[gatherTests,
				Test[StringTemplate["If ContainerName is specified, Container is specified or Sample is a location the Define at index `1`:"][primitiveIndex],True,False],
				Message[Error::InvalidContainerName,primitiveIndex];
				Message[Error::InvalidInput,myRawManipulations[[primitiveIndex]]];
				Null
			],
			If[gatherTests,
				Test[StringTemplate["If ContainerName is specified, Container is specified or Sample is a location the Define at index `1`:"][primitiveIndex],True,True],
				Null
			]
		];

		(* If Model is specified, ModelName and ModelType cannot be specified *)
		modelSpecificationTest = If[
			And[
				MatchQ[definePrimitive[Model],Except[_Missing|Null|Automatic]],
				Or[
					MatchQ[definePrimitive[ModelType],TypeP[]],
					MatchQ[definePrimitive[ModelType],_String]
				]
			],
			validDefinesQ = False;
			If[gatherTests,
				Test[StringTemplate["If Model is specified, ModelType and ModelName are not specified in the Define at index `1`:"][primitiveIndex],True,False],
				Message[Error::InvalidModelSpecification,primitiveIndex];
				Message[Error::InvalidInput,myRawManipulations[[primitiveIndex]]];
				Null
			],
			If[gatherTests,
				Test[StringTemplate["If Model is specified, ModelType and ModelName are not specified in the Define at index `1`:"][primitiveIndex],True,True],
				Null
			]
		];

		(* If StorageCondition or ExpirationDate is populated, Sample must be a model or location or ModelName/ModelType must be populated *)
		sampleParameterTest = If[
			And[
				Or[
					MatchQ[definePrimitive[StorageCondition],Except[_Missing|Null|Automatic]],
					MatchQ[definePrimitive[ExpirationDate],Except[_Missing|Null|Automatic]]
				],
				!MatchQ[definePrimitive[Sample],Except[ObjectP[Object[Sample]]|{ObjectP[Object[Sample]],_String}]]
			],
			validDefinesQ = False;
			If[gatherTests,
				Test[StringTemplate["If StorageCondition or ExpirationDate is specified, Sample does not specify a sample object in the Define at index `1`:"][primitiveIndex],True,False],
				Message[Error::InvalidSampleParameters,primitiveIndex];
				Message[Error::InvalidInput,myRawManipulations[[primitiveIndex]]];
				Null
			],
			If[gatherTests,
				Test[StringTemplate["If StorageCondition or ExpirationDate is specified, Sample does not specify a sample object in the Define at index `1`:"][primitiveIndex],True,True],
				Null
			]
		];

		(* Name or ContainerName must be specified with Sample or Container *)
		sufficientKeysTest = If[
			!And[
				Or[
					MatchQ[definePrimitive[Sample],Except[_Missing|Null]],
					MatchQ[definePrimitive[Container],Except[_Missing|Null]]
				],
				Or[
					MatchQ[definePrimitive[Name],Except[_Missing|Null]],
					MatchQ[definePrimitive[ContainerName],Except[_Missing|Null]]
				]
			],
			validDefinesQ = False;
			If[gatherTests,
				Test[StringTemplate["Name or ContainerName and Sample or Container are specified in the Define primitive at index `1`:"][primitiveIndex],True,False],
				Message[Error::MissingDefineKeys,primitiveIndex];
				Message[Error::InvalidInput,myRawManipulations[[primitiveIndex]]];
				Null
			],
			If[gatherTests,
				Test[StringTemplate["Name or ContainerName and Sample or Container are specified in the Define primitive at index `1`:"][primitiveIndex],True,True],
				Null
			]
		];

		DeleteCases[
			Flatten[{
				modelTypeNameTest,
				sampleContainerTest,
				modelParametersTest,
				containerNameTest,
				modelSpecificationTest,
				sampleParameterTest,
				sufficientKeysTest
			}],
			Null
		]
	];

	(* For any primitives that use a name, extract the referenced name *)
	definedNameReferences = Map[
		Switch[#,
			_Transfer,
				Cases[
					Join@@MapThread[
						Join,
						{#[Source],#[Destination]}
					],
					(name_String|{name_String,WellPositionP}):>name,{1}
				],
			_FillToVolume,
				Cases[{#[Source],#[Destination]},(name_String|{name_String,WellPositionP}):>name,{1}],
			_Pellet,
				Cases[
					(* Note: We have to add an additional layer of listing so that we don't flatten out {sample, well}. *)
					If[MatchQ[#,objectSpecificationP],{#},#]&/@Join[
						ToList[Lookup[#[[1]], Sample, {}]],
						ToList[Lookup[#[[1]], SupernatantDestination, {}]],
						ToList[Lookup[#[[1]], ResuspensionSource, {}]]
					],
					(name_String|{name_String,WellPositionP}):>name,
					{1}
				],
			_Incubate|_Mix,
				(* If not a list, do not Cases *)
				If[MatchQ[#[Sample],objectSpecificationP],
					Switch[#[Sample],
						_String,
							{#[Sample]},
						{_String,WellPositionP},
							{#[Sample][[1]]},
						_,
							{}
					],
					Cases[#[Sample],(name_String|{name_String,WellPositionP}):>name,{1}]
				],
			_Centrifuge,
				(* If not a list, do not Cases *)
				Join[
					If[MatchQ[#[Sample],objectSpecificationP],
						Switch[#[Sample],
							_String,
							{#[Sample]},
							{_String,WellPositionP},
							{#[Sample][[1]]},
							_,
							{}
						],
						Cases[ToList[#[Sample]],(name_String|{name_String,WellPositionP}):>name,{1}]
					],
					If[MatchQ[#[CollectionContainer],ListableP[objectSpecificationP]],
						Cases[ToList[#[CollectionContainer]],(name_String|{name_String,WellPositionP}):>name,{1}],
						{}
					]
				],
			_Filter,
				(* If not a list, do not Cases *)
				Join[
					If[MatchQ[#[Sample],objectSpecificationP],
						Switch[#[Sample],
							_String,
								{#[Sample]},
							{_String,WellPositionP},
								{#[Sample][[1]]},
							_,
								{}
						],
						Cases[ToList[#[Sample]],(name_String|{name_String,WellPositionP}):>name,{1}]
					],
					If[MatchQ[#[CollectionContainer],ListableP[objectSpecificationP]],
						Cases[ToList[#[CollectionContainer]],(name_String|{name_String,WellPositionP}):>name,{1}],
						{}
					],
					If[MatchQ[#[Filter],ListableP[objectSpecificationP]],
						Cases[ToList[#[Filter]],(name_String|{name_String,WellPositionP}):>name,{1}],
						{}
					]
				],
			_MoveToMagnet|_RemoveFromMagnet,
			(* If not a list, do not Cases *)
			If[MatchQ[#[Sample],objectSpecificationP],
				Switch[#[Sample],
					_String,
					{#[Sample]},
					{_String,WellPositionP},
					{#[Sample][[1]]},
					_,
					{}
				],
				Cases[#[Sample],(name_String|{name_String,WellPositionP}):>name,{1}]
			],
			_ReadPlate,
				(* If not a list, do not Cases *)
				Join[
					If[MatchQ[#[Sample],objectSpecificationP],
						Switch[#[Sample],
							_String,
								{#[Sample]},
							{_String,WellPositionP},
								{#[Sample][[1]]},
							_,
								{}
						],
						Cases[#[Sample],(name_String|{name_String,WellPositionP}):>name,{1}]
					],
					If[MatchQ[#[Blank],ListableP[objectSpecificationP]],
						If[MatchQ[#[Blank],objectSpecificationP],
							Switch[#[Blank],
								_String,
									{#[Blank]},
								{_String,WellPositionP},
									{#[Blank][[1]]},
								_,
									{}
							],
							Cases[#[Blank],(name_String|{name_String,WellPositionP}):>name,{1}]
						],
						{}
					]
				],
			_Define,
				{
					If[MatchQ[#[Sample],{_String,WellPositionP}],
						#[Sample][[1]],
						Nothing
					],
					If[MatchQ[#[Container],_String],
						#[Container],
						Nothing
					]
				},
			_,
				{}
		]&,
		manipulationsWithResolvedDefines
	];

	(* Extract any names that do not have an associated Define primitive *)
	invalidDefinedNameReferences = Map[
		Select[#,!KeyExistsQ[definedNamesLookup,#]&]&,
		definedNameReferences
	];

	(* Find indices for primitives that use an invalid name *)
	invalidDefinedNamePrimitiveIndices = PickList[
		Range[Length[manipulationsWithResolvedDefines]],
		invalidDefinedNameReferences,
		_?((Length[#]>0)&)
	];

	(* Generate test for invalid names *)
	validNameReferencesTest = If[
		Length[invalidDefinedNamePrimitiveIndices] > 0,
			(
				validDefinesQ = False;
				If[gatherTests,
					Test["Any name references in primitives have an associated Define primitive for the name:",True,False],
					Message[Error::InvalidNameReference,Flatten[invalidDefinedNameReferences],invalidDefinedNamePrimitiveIndices];
					Message[Error::InvalidInput,myRawManipulations[[invalidDefinedNamePrimitiveIndices]]];
					Null
				]
			),
		If[gatherTests,
			Test["Any name references in primitives have an associated Define primitive for the name:",True,True],
			Null
		]
	];

	(* Defined names cannot be well positions since this confuses things downstream when determining
	if a list if a {container, position} tuple or {container, defined object} list. *)
	incompatibleDefineNames = Flatten[AllWells[]];

	(* Extract any names that cannot be used *)
	invalidDefinedNames = Map[
		If[MatchQ[#,Alternatives@@incompatibleDefineNames],
			#,
			Nothing
		]&,
		Keys[definedNamesLookup]
	];

	(* Build test for invalid names *)
	invalidNameTest = If[Length[invalidDefinedNames] > 0,
		(
			validDefinesQ = False;
			If[gatherTests,
				Test["All defined names are not well positions:",True,False],
				Message[Error::InvalidName,invalidDefinedNames,Lookup[definedNamesLookup,invalidDefinedNames]];
				Message[Error::InvalidInput,Lookup[definedNamesLookup,invalidDefinedNames]];
				Null
			]
		),
		If[gatherTests,
			Test["All defined names are not well positions:",True,True],
			Null
		]
	];

	(* Extract any primitives with ModelName specified *)
	definePrimitivesWithModelNames = Map[
		If[
			And[
				MatchQ[#[ModelName],_String],
				MatchQ[#[ModelType],TypeP[]]
			],
			#,
			Nothing
		]&,
		resolvedDefinePrimitives
	];

	(* Extract ModelName from the relevant Define primitives *)
	specifiedModelNames = (#[ModelName])&/@definePrimitivesWithModelNames;

	(* Build full object specification (Model[Sample, Type, "ModelName"]) *)
	definedNewModels = Map[
		Append[#[ModelType],#[ModelName]]&,
		definePrimitivesWithModelNames
	];

	(* Check if the names already exist *)
	existingModelBools = DatabaseMemberQ[definedNewModels];

	(* Extract names that already exist *)
	existingModelNames = PickList[specifiedModelNames,existingModelBools,True];

	(* Extract primitives that already exist *)
	primitivesWithExistingModelNames = PickList[definePrimitivesWithModelNames,existingModelBools,True];

	(* Build test for ModelNames that already exist *)
	existingModelNameTest = If[Length[existingModelNames] > 0,
		(
			validDefinesQ = False;
			If[gatherTests,
				Test["Any specified ModelName(s) are not already in use:",True,False],
				Message[Error::ModelNameExists,existingModelNames];
				Message[Error::InvalidInput,primitivesWithExistingModelNames];
				Null
			]
		),
		If[gatherTests,
			Test["Any specified ModelName(s) are not already in use:",True,True],
			Null
		]
	];

	(* Extract any specified ModelName strings that are used in multiple Define primitives *)
	duplicatedModelNames = Select[
		Tally[specifiedModelNames],
		(#[[2]] > 1)&
	][[All,1]];

	(* Get actual define primitives that are invalid *)
	primitivesWithDuplicatedNames = Select[
		definePrimitivesWithModelNames,
		MatchQ[#[ModelName],Alternatives@@duplicatedModelNames]&
	];

	(* Build test for duplicated names *)
	duplicatedModelNamesTest = If[Length[duplicatedModelNames] > 0,
		(
			validDefinesQ = False;
			If[gatherTests,
				Test["All specified ModelName(s) are unique:",True,False],
				Message[Error::DuplicateModelName,duplicatedModelNames];
				Message[Error::InvalidInput,primitivesWithDuplicatedNames];
				Null
			]
		),
		If[gatherTests,
			Test["All specified ModelName(s) are unique:",True,True],
			Null
		]
	];

	(* check that we do not Define the same sample more than once *)
	primitivesWithDuplicateSamples = Module[
		{headlessPrimitives, definePrimitives, allDefineSamples, gatheredNames, repeatedNames},
		headlessPrimitives = manipulationsWithResolvedDefines[[All,1]];
		definePrimitives = Cases[manipulationsWithResolvedDefines, _Define,{}];
		(* Exit early if there are no Define primitives *)
		If[MatchQ[definePrimitives, {}], Return[Null,Module]];
		allDefineSamples = DeleteCases[Lookup[definePrimitives[[All,1]], Sample,<||>],Missing["KeyAbsent",Sample]|ObjectP[Model[Sample]]];
		gatheredNames = Gather[ToList@allDefineSamples];
		repeatedNames = DeleteDuplicates@Flatten[Select[gatheredNames, Length[#]>1&],1];
		(* return positions of the primitives with repeated Samples *)
		DeleteCases[Flatten@Position[headlessPrimitives, KeyValuePattern[Sample->#]]&/@repeatedNames,{}]
	];

	(* make tests for duplicated samples in the Define primitives *)
	primitivesWithDuplicateSamplesTest = If[Length[primitivesWithDuplicateSamples] > 0,
		(
			validDefinesQ = False;
			If[gatherTests,
				Test["All specified Define primitives are referencing different Sample:",True,False],
				Message[Error::DuplicateSamplesDefined,primitivesWithDuplicateSamples];
				Message[Error::InvalidInput,myRawManipulations[[Flatten@primitivesWithDuplicateSamples]]];
				Null
			]
		),
		If[gatherTests,
			Test["All specified Define primitives are referencing different Sample:",True,True],
			Null
		]
	];

	(* Pass Define primitive and its index to test-building function  *)
	defineTests = Join[
		Join@@MapThread[
			generateDefineTests[#1,#2]&,
			(* Pass indicies of raw input manipulations since that is what we want to refer to in messages
			and the modified manipulations may be of different length now due to volume-splitting *)
			{Cases[nonZeroAmountManipulations,_Define],Flatten[Position[myRawManipulations,_Define,{1}]]}
		],
		DeleteCases[{validNameReferencesTest,invalidNameTest,existingModelNameTest,duplicatedModelNamesTest, primitivesWithDuplicateSamplesTest},Null]
	];

	(* Default any raw plate references to {plate,"A1"} references *)
	manipulationsWithPlateWells = Map[
		Function[primitive,
			If[MatchQ[primitive,_Transfer],
				Module[{modifiedSources,modifiedDestinations},

					{modifiedSources,modifiedDestinations} = Map[
						Function[specifications,
							Map[
								Switch[#,
									_String,
										If[
											(* If spec is a defined container without a sample or well specified, default to A1 *)
											And[
												MatchQ[Lookup[definedNamesLookup,#][Sample],_Missing],
												MatchQ[Lookup[definedNamesLookup,#][Well],_Missing],
												MatchQ[Lookup[definedNamesLookup,#][Container],ObjectP[{Model[Container,Plate],Object[Container,Plate]}]]
											],
											{#,"A1"},
											#
										],
									(* If it's a raw plate or plate model, default to A1 *)
									ObjectP[{Model[Container,Plate],Object[Container,Plate]}],
										{#,"A1"},
									_,
										#
								]&,
								specifications,
								{2}
							]
						],
						{primitive[Source],primitive[Destination]}
					];

					(* Add modded references back to primitive *)
					Transfer[
						Prepend[
							First[primitive],
							{
								Source -> modifiedSources,
								Destination -> modifiedDestinations
							}
						]
					]
				],
				primitive
			]
		],
		manipulationsWithResolvedDefines
	];

	(* Split Transfer primitive pipetting steps into multiple pipettings if Amount exceeds specified
	tip size or our max available tip size. (Only split volumes if we're using MicroLiquidHandling). *)
	splitPrimitiveLists = If[MatchQ[scaleToUseForFurtherResolving,MicroLiquidHandling],
		(splitTransfers[#,Cache->allPackets,DefineLookup->definedNamesLookup]&/@manipulationsWithPlateWells),
		{#}&/@manipulationsWithPlateWells
	];

	(* splitTransfers returns nested lists in case it needs to split a transfer into multiple.
	We keep this nestedness so we can expand our RentContainer bools. But join them together to build
	a flat list here. *)
	splitPrimitives = Join@@splitPrimitiveLists;

	(* As described in the previous comment, expand the rent container bools to match the length
	of any split transfers *)
	expandedRentContainerBools = Join@@MapThread[
		Table[#2,Length[#1]]&,
		{splitPrimitiveLists,resourceRentContainerBools}
	];

	(* Build a list of positions that relate a (potentially) split primitive to its original position
	in the input list *)
	expandedRawManipulationPositions = Join@@MapThread[
		Table[#2,Length[#1]]&,
		{splitPrimitiveLists,modifiedRawManipulationPositions}
	];

	(* Turn all of the objects in the manipulations into object references;
	This makes it WAY easier downstream to locate particular objects amongst the full manips list
	Turn named objects, links, and packets into their ID-ed object references *)
	manipulationsWithObjectReferences = Map[
		If[MatchQ[#,_Define],
			#,
			ReplaceAll[
				#,
				{
					objectReference:ObjectReferenceP[] :> Download[objectReference,Object],
					link:LinkP[] :> Download[link[Object],Object],
					packet:PacketP[] :> Lookup[packet,Object]
				}
			]
		]&,
		splitPrimitives
	];

	(* Determine if we're using the magnet position - the 96-head cannot reach this position as of 4-8-22 *)
	(* We are working to change that and this can be removed when that is no longer the case *)
	usesMagnetQ = MemberQ[Head/@myIntitialManipulations,MoveToMagnet];
	
	(* Check if we have any MultiHeadProbe transfers with less than 96 samples -- we are only checking for cases where OptimizePrimitives->False, because optimization will split/merge the primitives so the output may be different *)
	validMultiProbeHeadTransferQ=If[
		Lookup[safeOptions,OptimizePrimitives],
		True,
		Module[{deviceChannelPrimitivePositions,deviceChannelPrimitiveAssociations,partialValidMultiProbeHeadTransferQ},
			
			(* Find the positions of the primitives with DeviceChannel key *)
			deviceChannelPrimitivePositions=Flatten[Position[manipulationsWithObjectReferences,_Transfer|_Resuspend|_Incubate|_Mix]];
			
			(* Get the associations from our primitives *)
			deviceChannelPrimitiveAssociations=manipulationsWithObjectReferences[[#,1]]&/@deviceChannelPrimitivePositions;
			
			(* Check the number of transfers for the device channel primitives *)
			partialValidMultiProbeHeadTransferQ=If[
				MatchQ[Lookup[#,DeviceChannel],MultiProbeHead|{MultiProbeHead..}],
				!usesMagnetQ && Length[Lookup[#,Source]]==96,
				True
			]&/@deviceChannelPrimitiveAssociations;
			
			(* Reconstruct the list for all primitives *)
			ReplacePart[manipulationsWithObjectReferences,Join[Thread[deviceChannelPrimitivePositions->partialValidMultiProbeHeadTransferQ],#->True&/@Complement[Range[Length[manipulationsWithObjectReferences]],deviceChannelPrimitivePositions]]]
		]
	];
	
	(* If we have any invalid MultiProbeHead transfers, throw an error *)
	If[
		Not[And@@validMultiProbeHeadTransferQ]&&messagesBoolean,
		Message[Error::MultiProbeHeadInvalidTransfer,Flatten[Position[validMultiProbeHeadTransferQ,False]]]
	];
	
	(* If gathering tests, create a passing or failing test *)
	validMultiProbeHeadTransferTest=Which[
		!gatherTests,Nothing,
		gatherTests&&And@@validMultiProbeHeadTransferQ,Test["All MultiProbeHead transfers contain exactly 96 transfers:",True,True],
		gatherTests&&!And@@validMultiProbeHeadTransferQ,Test["All MultiProbeHead transfers contain exactly 96 transfers:",True,False]
	];
	
	(* === Filter Primitive Resolution === *)

	(* 1 - First we do some Error checking regarding keys and scale if specified *)

	(* Get the scale provided by the user *)
	specifiedScale=LiquidHandlingScale/.safeOptions;

	(* List the keys from the Filter primitive that are only used in Micro scale *)
	microOnlyFilterOptions=Alternatives[
		Pressure
	];

	(* List the keys from the Filter primitive that are only used in Macro scale *)
	macroOnlyFilterOptions=Alternatives[
		Filter,
		MembraneMaterial,
		PoreSize,
		FiltrationType,
		Instrument,
		FilterHousing,
		Syringe,
		Sterile,
		MolecularWeightCutoff,
		PrefilterMembraneMaterial,
		PrefilterPoreSize,
		Temperature
	];

	(* Get the Filter primitives that have defined both macro and micro keys - these are invalid right away *)
	filterPrimitivePositionsMacroAndMicro=Position[manipulationsWithObjectReferences,_?(MatchQ[#,_Filter]&&MemberQ[Keys[First[#]],microOnlyFilterOptions]&&MemberQ[Keys[First[#]],macroOnlyFilterOptions]&)];

	(* Get the Filter primitives that have defined micro keys only. These are valid as long as the Liquidhandlingscale, if specified, is Micro as well - we will test this below *)
	filterPrimitivePositionsMicro=Position[manipulationsWithObjectReferences,_?(MatchQ[#,_Filter]&&MemberQ[Keys[First[#]],microOnlyFilterOptions]&&!MemberQ[Keys[First[#]],macroOnlyFilterOptions]&)];

	(* Get the Filter primitives that have defined macro keys only. These are valid as long as the Liquidhandlingscale, if specified, is Macro as well - we will test this below *)
	filterPrimitivePositionsMacro=Position[manipulationsWithObjectReferences,_?(MatchQ[#,_Filter]&&MemberQ[Keys[First[#]],macroOnlyFilterOptions]&&!MemberQ[Keys[First[#]],microOnlyFilterOptions]&)];

	(* Get the Filter primitives that have no scale specific keys *)
	filterPrimitivePositionsWithoutSpecificKeys=Position[manipulationsWithObjectReferences,_?(MatchQ[#,_Filter]&&!MemberQ[Keys[First[#]],macroOnlyFilterOptions]&&!MemberQ[Keys[First[#]],microOnlyFilterOptions]&)];

	(* pull out the primitives of each type by position *)
	{filterPrimitivesMacroAndMicro,filterPrimitivesMicro,filterPrimitivesMacro,filterPrimitivesWithoutSpecificKeys}=Map[
		Extract[manipulationsWithObjectReferences,#]&,
		{filterPrimitivePositionsMacroAndMicro,filterPrimitivePositionsMicro,filterPrimitivePositionsMacro,filterPrimitivePositionsWithoutSpecificKeys}
	];

	(* If there are Filter primitives with keys for both Macro and Micro, and we are throwing messages, throw an error message and set the error tracking variable to True *)
	conflictingFilterMessage=Module[{conflictingFilterOptions,primitiveIndices},
		If[(Length[filterPrimitivesMacroAndMicro]>0 && !gatherTests),
			conflictingFilterOptions=Map[Intersection[Keys[#],Join[ToList@@microOnlyFilterOptions,ToList@@macroOnlyFilterOptions]]&,filterPrimitivesMacroAndMicro];
			primitiveIndices=Flatten[Position[manipulationsWithObjectReferences,#]&/@filterPrimitivesMacroAndMicro];
			(
				Message[Error::ConflictingFilterPrimitiveKeys,primitiveIndices,conflictingFilterOptions];
				Message[Error::InvalidInput,filterPrimitivesMacroAndMicro]
			);
			True,
			False
		]
	];

	(* If we are gathering tests, create tests for the Filter primitives with both Macro and Micro keys *)
	conflictingFilterPrimitiveTests=If[gatherTests,

	(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingManips,passingFilterManips,passingManipsTest,passingPrimitiveIndices,failingPrimitiveIndices,failingManipsTest},

		(* Get the inputs that pass this test. *)
			passingManips=Complement[manipulationsWithObjectReferences,filterPrimitivesMacroAndMicro];

			(* Make sure we only select the filter primitives here, since for the others this test is irrelevant *)
			passingFilterManips=Select[passingManips,MatchQ[#,_Filter]&];

			(* Get the index of the failing and passing primitives *)
			passingPrimitiveIndices=Sort[Flatten[Position[manipulationsWithObjectReferences,#]&/@passingFilterManips]];
			failingPrimitiveIndices=Sort[Flatten[Position[manipulationsWithObjectReferences,#]&/@filterPrimitivesMacroAndMicro]];

			(* Create a test for the passing inputs. *)
			passingManipsTest=If[Length[passingPrimitiveIndices]>0,
				Test["In the Filter manipulations at the positions "<>ToString[passingPrimitiveIndices]<>", the primitive keys are specific for a single LiquidHandlingScale:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingManipsTest=If[Length[filterPrimitivesMacroAndMicro]>0,
				Test["In the Filter manipulations at the positions "<>ToString[failingPrimitiveIndices]<>", the primitive keys are specific for a single LiquidHandlingScale:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingManipsTest,
				failingManipsTest
			}
		],
	(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Now we find Filter primitives with keys that are conflicting with the Scale if that was specified - we can throw an error right away before resolving the scale *)
	filterPrimitivesConflictingWithScale=Which[
		MatchQ[specifiedScale,MicroLiquidHandling]&&!MatchQ[filterPrimitivesMacro,{}],filterPrimitivesMacro,
		MatchQ[specifiedScale,MacroLiquidHandling]&&!MatchQ[filterPrimitivesMicro,{}],filterPrimitivesMicro,
		True,{}
	];

	(* If there are Filter primitives with keys conflicting with the scale, and we are throwing messages, throw an error message here and set the error variable to True*)
	conflictingFilterWithScaleMessage=Module[{conflictingWithScaleFilterOptions,primitiveIndices},
		If[(Length[filterPrimitivesConflictingWithScale]>0 && !gatherTests),
			conflictingWithScaleFilterOptions=Map[Intersection[Keys[#],Join[ToList@@microOnlyFilterOptions,ToList@@macroOnlyFilterOptions]]&,filterPrimitivesConflictingWithScale];
			primitiveIndices=Flatten[Position[manipulationsWithObjectReferences,#]&/@filterPrimitivesConflictingWithScale];
			(Message[Error::InvalidOption,LiquidHandlingScale];Message[Error::FilterManipConflictsWithScale,primitiveIndices,specifiedScale,conflictingWithScaleFilterOptions,If[MatchQ[specifiedScale,MicroLiquidHandling],MacroLiquidHandling,MicroLiquidHandling]]);
			True,
			False
		]
	];

	(* If we are gathering tests, create tests for the Filter primitives conflicting with the specified Scale *)
	conflictingFilterWithScaleTests=If[gatherTests,

	(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingManips,passingFilterManips,passingManipsTest,passingPrimitiveIndices,failingPrimitiveIndices,failingManipsTest},

		(* Get the inputs that pass this test. *)
			passingManips=Complement[manipulationsWithObjectReferences,filterPrimitivesConflictingWithScale];

			(* Make sure we only select the filter primitives here, since for the others this test is irrelevant *)
			passingFilterManips=Select[passingManips,MatchQ[#,_Filter]&];

			(* Get the index of the failing and passing primitives *)
			passingPrimitiveIndices=Sort[Flatten[Position[manipulationsWithObjectReferences,#]&/@passingFilterManips]];
			failingPrimitiveIndices=Sort[Flatten[Position[manipulationsWithObjectReferences,#]&/@filterPrimitivesConflictingWithScale]];

			(* Create a test for the passing inputs. *)
			passingManipsTest=If[Length[passingFilterManips]>0,
				Test["In the manipulation primitives at the positions(s) "<>ToString[passingPrimitiveIndices]<>", the primitive keys match the provided LiquidHandlingScale:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingManipsTest=If[Length[filterPrimitivesConflictingWithScale]>0,
				Test["In the manipulation primitives at the positions(s) "<>ToString[failingPrimitiveIndices]<>", the primitive keys match the provided LiquidHandlingScale:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingManipsTest,
				failingManipsTest
			}
		],
	(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Get the filter primitives we want to resolve in macro (we will have thrown error for the primitive with conflicting keys above, simply drag them along here and resolve them to Macro *)
	(* If the scale was specified to Macro we'll also resolve the primitives with no specific keys, and the primitives with both *)
	(* sort them so that they are extracted in the order they are found in manipulationsWithObjectReferences *)
	filterMacroPrimitives=If[MatchQ[specifiedScale,MacroLiquidHandling],
		Extract[
			manipulationsWithObjectReferences,
			Sort[Join[filterPrimitivePositionsMacro,filterPrimitivePositionsMacroAndMicro,filterPrimitivePositionsWithoutSpecificKeys]]
		],
		Join[filterPrimitivesMacro]
	];

	(* Find positions from these primitives in the input list *)
	(* need to delete duplicates in the primitive list, otherwise Positions will list those twice *)
	filterMacroPositions=Sort[Flatten[Position[manipulationsWithObjectReferences,#]&/@DeleteDuplicates[filterMacroPrimitives]]];

	(* Get the filter primitives we want to resolve in micro (we will have thrown error for the primitive with conflicting keys above, simply drag them along here and resolve them to Micro *)
	(* If the scale was specified to Macro we'll also resolve the primitives with no specific keys, and the primitives with both *)
	(* sort them so that they are extracted in the order they are found in manipulationsWithObjectReferences *)
	filterMicroPrimitives=If[MatchQ[specifiedScale,(MicroLiquidHandling|Automatic)],
		Extract[
			manipulationsWithObjectReferences,
			Sort[Join[filterPrimitivePositionsMicro,filterPrimitivePositionsMacroAndMicro,filterPrimitivePositionsWithoutSpecificKeys]]
		],
		Join[filterPrimitivesMicro]
	];

	(* Get the positions from the primitives with Micro keys *)
	(* need to delete duplicates in the primitive list, otherwise Positions will list those twice *)
	filterMicroPositions=Sort[Flatten[Position[manipulationsWithObjectReferences,#]&/@DeleteDuplicates[filterMicroPrimitives]]];

	(* 2 - Do some Error checking regarding all micro primitives *)

	(* Initialize filter Micro primitive validity as True (reset to False downstream if needed) *)
	validMicroFiltersQ = True;

	(* find filter micro primitives that are missing required keys *)
	missingKeysMicroFilterPrimitiveTuples=MapThread[
		Which[
			MissingQ[#[Time]],{#1,#2,Time},
			True,Nothing
		]&,
		{filterMicroPrimitives,filterMicroPositions}];

	(* Transpose the invalid tuples so that we get a list of invalid primitives, the positions, and the missing keys *)
	{missingKeysMicroFilterPrimitives,missingFilterKeysIndeces,missingFilterKeys}=If[!MatchQ[missingKeysMicroFilterPrimitiveTuples,{}],
		Transpose[missingKeysMicroFilterPrimitiveTuples],
		{{},{},{}}
	];

	(* If there are Filter primitives with keys for both Macro and Micro, and we are throwing messages, throw an error message and set the error tracking variable to True *)
	missingKeysFilterMessage=Module[{conflictingFilterOptions,primitiveIndices},
		If[(Length[missingKeysMicroFilterPrimitiveTuples]>0 && !gatherTests),
			(
				Message[Error::MissingMicroFilterKeys,missingKeysMicroFilterPrimitives,missingFilterKeysIndeces,missingFilterKeys];
				Message[Error::InvalidInput,missingKeysMicroFilterPrimitives]
			);
			True,
			False
		]
	];

	(* If we are gathering tests, create tests for the Filter primitives with both Macro and Micro keys *)
	missingKeysMicroFilterPrimitiveTests=If[gatherTests,

	(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingManips,passingFilterManips,passingManipsTest,passingPrimitiveIndices,failingPrimitiveIndices,failingManipsTest},

		(* Get the inputs that pass this test. *)
			passingManips=Complement[Select[manipulationsWithObjectReferences,MatchQ[#,_Filter]&],missingKeysMicroFilterPrimitives];

			(* Get the index of the failing and passing primitives *)
			passingPrimitiveIndices=Sort[Flatten[Position[manipulationsWithObjectReferences,#]&/@passingManips]];
			failingPrimitiveIndices=Sort[Flatten[Position[manipulationsWithObjectReferences,#]&/@missingKeysMicroFilterPrimitives]];

			(* Create a test for the passing inputs if we have any. *)
			passingManipsTest=If[Length[passingPrimitiveIndices]>0,
				Test["In the Filter manipulations at the positions "<>ToString[passingPrimitiveIndices]<>", all required keys are specified:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs if we have any. *)
			failingManipsTest=If[Length[missingKeysMicroFilterPrimitiveTuples]>0,
				Test["In the Filter manipulations at the positions "<>ToString[failingPrimitiveIndices]<>", all required keys are specified:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingManipsTest,
				failingManipsTest
			}
		],
	(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Extract any explicitly specified CollectionContainer references *)
	specifiedCollectionContainers = DeleteDuplicates@Map[
		Switch[#,
			ObjectP[],
				Download[#,Object],
			_String,
				(* If reference points to a specific container object, extract it since this
				object could be references elsewhere directly or by a different name *)
				If[MatchQ[Lookup[definedNamesLookup,#][Container],ObjectP[Object[Container]]],
					Lookup[definedNamesLookup,#][Container],
					#
				],
			_,
				Nothing
		]&,
		#[CollectionContainer]&/@filterMicroPrimitives
	];

	(* 3 - Resolve the micro primitives and throw errors/test for each primitive *)

	(* Resolve all Filter primitives and build tests. Each MapThread iteration will
	return the tuple {resolved primitive, primitive tests}, so Transpose all those tuples
	to get expected output. *)
	{resolvedFilterMicroPrimitives,individualFilterMicroTests} = If[Length[filterMicroPrimitives] > 0,
		Transpose@MapThread[
			Function[{filterPrimitive,primitiveIndex},
				Module[
					{filterAssociation,resolvedSamples,invalidSampleSpecifications,sampleSpecificationTest,
					validSampleSpecificationBools,validSampleLocationBools,phytipColumnModels,
					resolvedCollectionContainer,invalidSamples,sampleLocationTest,collectionContainerModel,
					collectionContainerModelTest,resolvedPrimitive,allPrimitiveTests,sampleContainerModels},

					(* define the phytip column object. *)
					phytipColumnModels = {
						Model[Container, Vessel, "id:zGj91a7nlzM6"]
					};

					(* Extract primitive's underlying association *)
					filterAssociation = First[filterPrimitive];

					(* Listablize Sample if necessary *)
					resolvedSamples = If[MatchQ[Lookup[filterAssociation,Sample],objectSpecificationP],
						{Lookup[filterAssociation,Sample]},
						Lookup[filterAssociation,Sample]
					];

					(* The Sample field must point to samples (not containers) *)
					invalidSampleSpecifications = Map[
						Switch[#,
							(* Container specification is not ok *)
							ObjectP[{Object[Container],Model[Container]}],
								#,
							_String,
								(* If defined name reference points to a sample or a phytip container model, then we're good *)
								If[
									And[
										(* Defined name doesn't point to a phytip container model. *)
										If[MatchQ[Lookup[definedNamesLookup,#][Container], ObjectP[Object[Container, Vessel]]],
											!MatchQ[fetchModelPacketFromCacheHPLC[Lookup[definedNamesLookup,#][Container],allPackets], ObjectP[phytipColumnModels]],
											!MatchQ[Lookup[definedNamesLookup,#][Container], ObjectP[phytipColumnModels]]
										],

										(* If both Sample and Well are empty, the defined name reference doesnt point to a sample *)
										And[
											MatchQ[Lookup[definedNamesLookup,#][Sample],_Missing],
											MatchQ[Lookup[definedNamesLookup,#][Well],_Missing]
										]
									],
									#,
									Nothing
								],
							_,
								Nothing
						]&,
						resolvedSamples
					];

					(* Build test for sample specification *)
					sampleSpecificationTest = If[Length[invalidSampleSpecifications] > 0,
						validMicroFiltersQ = False;
						If[gatherTests,
							Test[StringTemplate["The Filter primitive at index `1` references samples in its Sample key:"][primitiveIndex],True,False],
							Message[Error::InvalidFilterSampleSpecification,primitiveIndex];
							Message[Error::InvalidInput,filterPrimitive];
							Null
						],
						If[gatherTests,
							Test[StringTemplate["The Filter primitive at index `1` references samples in its Sample key:"][primitiveIndex],True,True],
							Null
						]
					];

					(* Get a list of the container models that each of our samples are in. *)
					sampleContainerModels = Map[
						Module[{convertedReference},

							(* Convert any defined references to objects *)
							convertedReference = Switch[#,
								(* A defined sample reference *)
								_String,
									If[!MatchQ[Lookup[definedNamesLookup,#][Sample],_Missing],
										Lookup[definedNamesLookup,#][Sample],
										If[MatchQ[Lookup[definedNamesLookup,#][Well],WellPositionP],
											{Lookup[definedNamesLookup,#][Container],Lookup[definedNamesLookup,#][Well]},
											Lookup[definedNamesLookup,#][Container]
										]
									],
								(* A location reference with defined container *)
								{_String,WellPositionP},
									{Lookup[definedNamesLookup,#[[1]]][Container],#[[2]]},
								_,
									#
							];

							(* Determine if the referenced object is actually in a filter plate OR in a phytip column *)
							Switch[convertedReference,
								ObjectP[Model[Container]],
									convertedReference,

								{ObjectP[Model[Container]], WellPositionP},
									convertedReference[[1]],

								(* A position that is a vessel object *)
								ObjectP[Object[Container]],
									fetchModelPacketFromCacheHPLC[convertedReference,allPackets],

								(* A position that is a vessel object and position*)
								{ObjectP[Object[Container]], WellPositionP},
									fetchModelPacketFromCacheHPLC[convertedReference[[1]],allPackets],

								(* If we have {_String, WellPositionP}, get the model of the defined container. *)
								{_String,WellPositionP},
									fetchDefineModelContainer[
										Lookup[definedNamesLookup,convertedReference[[1]]],
										Cache->allPackets
									],
								(* Direct sample reference -- make sure sample is already in a filter plate or phytip vessel model *)
								ObjectP[Object[Sample]],
									fetchModelPacketFromCacheHPLC[
										Lookup[fetchPacketFromCacheHPLC[convertedReference,allPackets],Container],
										allPackets
									],
								(* Cannot specify a sample model since we need it to be transferred into a filter *)
								ObjectP[Model[Sample]],
									Null,

								(* All other cases should be invalid *)
								_,
									Null
							]
						]&,
						resolvedSamples
					];

					(* Build a list of bools that determine if the referenced sample is in a filter plate OR in a phytip column *)
					(* If the samples are in a combination of filter plates and phytip columns, the manipulation in invalid -- we can only do one at a time. *)
					validSampleLocationBools=If[MatchQ[sampleContainerModels, {ObjectP[{Model[Container,Plate,Filter], Sequence@@phytipColumnModels}]..}] && !MatchQ[sampleContainerModels, {ObjectP[Model[Container,Plate,Filter]]..}|{ObjectP[phytipColumnModels]..}],
						ConstantArray[False, Length[sampleContainerModels]],
						Map[
							(MatchQ[#, ObjectP[{Model[Container,Plate,Filter], Sequence@@phytipColumnModels}]]&),
							sampleContainerModels
						]
					];

					(* Extract those samples that are invalid -- all samples are invalid if we have both filter plates and phytips. *)
					invalidSamples = If[MemberQ[sampleContainerModels, ObjectP[Model[Container, Plate, Filter]]] && MemberQ[sampleContainerModels, ObjectP[phytipColumnModels]],
						resolvedSamples,
						PickList[resolvedSamples,validSampleLocationBools,False]
					];

					(* Build test for sample location *)
					sampleLocationTest = If[Length[invalidSamples] > 0,
						validMicroFiltersQ = False;
						If[gatherTests,
							Test[StringTemplate["The Filter primitive at index `1` references samples that are in a filter plate:"][primitiveIndex],True,False],
							Message[Error::InvalidFilterSampleLocation,primitiveIndex];
							Message[Error::InvalidInput,filterPrimitive];
							Null
						],
						If[gatherTests,
							Test[StringTemplate["The Filter primitive at index `1` references samples that are in a filter plate:"][primitiveIndex],True,True],
							Null
						]
					];

					(* Resolve CollectionContainer to DWP if it is Automatic *)
					resolvedCollectionContainer = If[
						MatchQ[Lookup[filterAssociation,CollectionContainer,Automatic],Automatic],
							(* Use a shallow plate if we're using the centrifuge (due to height restrictions) *)
							If[MatchQ[Lookup[filterAssociation,Intensity],GreaterP[0 RPM]|GreaterP[0 GravitationalAcceleration]],
								{Unique[], Model[Container, Plate, "96-well UV-Star Plate"]},
								{Unique[], Model[Container, Plate, "96-well 2mL Deep Well Plate"]}
							],
						Lookup[filterAssociation,CollectionContainer,Null]
					];

					(* Fetch model of collection container *)
					collectionContainerModel = Switch[resolvedCollectionContainer,
						_String,
							fetchDefineModelContainer[Lookup[definedNamesLookup,resolvedCollectionContainer],Cache->allPackets],
						ObjectP[Object[Container]],
							Download[Lookup[fetchPacketFromCacheHPLC[resolvedCollectionContainer,allPackets],Model],Object],
						ObjectP[Model[Container]],
							Download[resolvedCollectionContainer,Object],
						{_,ObjectP[Model[Container]]},
							Download[resolvedCollectionContainer[[2]],Object],
						_,
							Null
					];

					(* Make sure the collection container is a plate *)
					collectionContainerPlateTest = If[!MatchQ[collectionContainerModel,ObjectP[{Model[Container, Plate]}]],
						validMicroFiltersQ = False;
						If[gatherTests,
							Test[StringTemplate["In the Filter primitive at index `1`, the specified CollectionContainer is a plate:"][primitiveIndex],True,False],
							Message[Error::InvalidCollectionContainer,primitiveIndex];
							Message[Error::InvalidInput,filterPrimitive];
							Null
						],
						If[gatherTests,
							Test[StringTemplate["In the Filter primitive at index `1`, the specified CollectionContainer is a plate:"][primitiveIndex],True,True],
							Null
						]
					];

					(* Current the collection container _must_ be a DWP, so we also throw this error until it can be removed *)
					collectionContainerModelTest = If[
						And[
							!MatchQ[Lookup[filterAssociation,CollectionContainer,Automatic],Automatic],
							!MatchQ[
								Lookup[fetchPacketFromCacheHPLC[collectionContainerModel,allPackets],Footprint],
								Plate
							]
						],
						validMicroFiltersQ = False;
						If[gatherTests,
							Test[StringTemplate["The Filter primitive at index `1` has a valid CollectionContainer specified:"][primitiveIndex],True,False],
							Message[Error::IncompatibleCollectionContainer,primitiveIndex];
							Message[Error::InvalidInput,filterPrimitive];
							Null
						],
						If[gatherTests,
							Test[StringTemplate["The Filter primitive at index `1` has a valid CollectionContainer specified:"][primitiveIndex],True,True],
							Null
						]
					];

					(* Add all resolved keys to primitive *)
					resolvedPrimitive = Filter[
						Prepend[filterAssociation,
							{
								Sample -> resolvedSamples,
								CollectionContainer -> resolvedCollectionContainer,

								(* Default Pressure to 100 PSI if the samples aren't in a phytip column. *)
								(* TODO: Throw an error if the Pressure key is given an the samples are in phytip columns. *)
								Pressure -> If[KeyExistsQ[filterAssociation, Pressure],
									Lookup[filterAssociation,Pressure],
									If[
										Or[
											MemberQ[sampleContainerModels, ObjectP[phytipColumnModels]],
											MatchQ[Lookup[filterAssociation,Intensity],GreaterP[0 RPM]|GreaterP[0 GravitationalAcceleration]]
										],
										Null,
										100 PSI
									]
								]

								(* ignore Macro keys, and Time is required *)
							}
						]
					];

					(* Build list of all primitive tests *)
					allPrimitiveTests = DeleteCases[
						{sampleSpecificationTest,sampleLocationTest,collectionContainerModelTest,collectionContainerPlateTest},
						Null
					];

					(* Return expected tuple *)
					{resolvedPrimitive,allPrimitiveTests}
				]
			],
			{filterMicroPrimitives,filterMicroPositions}
		],
		{{},{}}
	];

	(* 4 - Some more error checking on the resolved micro primitives *)

	(* Extract all filtered samples or sample references *)
	allFilteredSamples = Join@@(#[Sample]&/@resolvedFilterMicroPrimitives);

	(* Extract all filter container references across all Filter primitives *)
	specifiedFilteredContainers = DeleteDuplicates@Map[
		(* Extract container objects or unique references *)
		Switch[#,
			(* A defined sample reference *)
			_String,
				Which[
					(* If a defined reference is a sample, fetch its container *)
					MatchQ[Lookup[definedNamesLookup,#][Sample],ObjectP[Object[Sample]]],
						Download[Lookup[fetchPacketFromCacheHPLC[#,allPackets],Container],Object],
					(* If the defined reference points to a {container, well} pair, extract the container *)
					MatchQ[Lookup[definedNamesLookup,#][Sample],{ObjectP[],WellPositionP}],
						(Lookup[definedNamesLookup,#][Sample])[[1]],
					(* If reference is a {container, well} pair where the container is a reference, extract container *)
					MatchQ[Lookup[definedNamesLookup,#][Sample],{_String,WellPositionP}],
						(* If container reference is an object (not model) then fetch it *)
						If[MatchQ[Lookup[definedNamesLookup,Lookup[definedNamesLookup,#][Sample][[1]]][Container],ObjectP[Object[Container]]],
							Lookup[definedNamesLookup,Lookup[definedNamesLookup,#][Sample][[1]]][Container],
							Lookup[definedNamesLookup,#][Sample][[1]]
						],
					(* If reference is a container, extract it *)
					MatchQ[Lookup[definedNamesLookup,#][Container],_String],
						(* If container reference is a defined container object, extract the actual object *)
						If[MatchQ[Lookup[definedNamesLookup,Lookup[definedNamesLookup,#][Container]][Container],ObjectP[Object[Container]]],
							Lookup[definedNamesLookup,Lookup[definedNamesLookup,#][Container]][Container],
							Lookup[definedNamesLookup,#][Container]
						],
					True,
						Nothing
				],
			(* A location reference with defined container *)
			{_String,WellPositionP},
				If[MatchQ[Lookup[definedNamesLookup,#[[1]]][Container],ObjectP[Object[Container]]],
					Lookup[definedNamesLookup,Lookup[definedNamesLookup,#[[1]]]][Container],
					#[[1]]
				],
			{ObjectP[{Object[Container,Plate,Filter],Model[Container,Plate,Filter]}],WellPositionP},
				Download[#[[1]],Object],
			ObjectP[{Object[Container,Plate,Filter],Model[Container,Plate,Filter]}],
				Download[#,Object],
			(* Direct sample reference *)
			ObjectP[Object[Sample]],
				Download[Lookup[fetchPacketFromCacheHPLC[#,allPackets],Container],Object],
			_,
				Nothing
		]&,
		allFilteredSamples
	];

	(* List of filter plate models that are currently supported *)
	compatibleFilterModels = {
		(* "Plate Filter, GlassFiber, 30.0um, 1mL" *)
		Model[Container, Plate, Filter, "id:qdkmxzqGl7J3"],
		(* "Plate Filter, GlassFiber, 30.0um, 2mL" *)
		Model[Container, Plate, Filter, "id:R8e1PjpB69LX"],
		(* "Zeba 7K 96-well Desalt Spin Plate" *)
		Model[Container, Plate, Filter, "id:M8n3rx0ZkwB5"],
		(* "Plate Filter, Omega 3K MWCO, 350uL" *)
		Model[Container, Plate, Filter, "id:4pO6dM53Nq4r"],
		(* "Zeba 40K 96-well Desalt Spin Plate" *)
		Model[Container, Plate, Filter, "id:BYDOjvGrqzr8"],
		(* "QiaQuick 96well *)
		Model[Container, Plate, Filter, "id:xRO9n3BGnqDz"],
		(* "MinElute 96 UF PCR Purification Plates" *)
		Model[Container, Plate, Filter, "id:J8AY5jDjvqo7"]
	};

	(* Fetch any used filter container model objects *)
	filterContainerModels = Map[
		Switch[#,
			ObjectP[Object[Container,Plate,Filter]],
				Download[Lookup[fetchPacketFromCacheHPLC[#,allPackets],Model],Object],
			ObjectP[Model[Container,Plate,Filter]],
				Download[#,Object],
			_String,
				If[MatchQ[Lookup[definedNamesLookup,#][Container],ObjectP[Object[Container]]],
					Download[Lookup[fetchPacketFromCacheHPLC[Lookup[definedNamesLookup,#][Container],allPackets],Model],Object],
					Download[Lookup[definedNamesLookup,#][Container],Object]
				],
			_,
				Nothing
		]&,
		specifiedFilteredContainers
	];

	(* Extract any incompatible filter containers *)
	invalidFilterContainerModels = Select[
		filterContainerModels,
		(* We can filter out any non-filter plates since this will be caught by the error
		InvalidFilterSampleLocation *)
		And[
			MatchQ[#,ObjectP[Model[Container,Plate,Filter]]],
			!MemberQ[compatibleFilterModels,#]
		]&
	];

	(* Build test for filter container compatibility *)
	filterContainerCompatibilityTest = If[Length[invalidFilterContainerModels] > 0,
		validMicroFiltersQ = False;
		If[gatherTests,
			Test["All Filter primitives' filter container is supported:",True,False],
			Message[Error::IncompatibleFilterContainer,invalidFilterContainerModels,compatibleFilterModels];
			Message[Error::InvalidInput,filterMicroPrimitives];
			Null
		],
		If[gatherTests,
			Test["All Filter primitives' filter container is supported:",True,True],
			Null
		]

	];

	(* 5 - Resolve the macro primitives and build tests *)

	(* Set the Macro Filter error tracking variable here to True, and turn it to False downstream if needed *)
	validMacroFilterQ=True;

	(* Resolve all Macro Filter primitives and build tests. *)
	(* We let ExperimentFilter throw all the messages if we're not gathering tests *)
	(* Each MapThread iteration will return the tuple {resolved primitive, primitive tests}, so Transpose all those tuples to get expected output. *)
	{resolvedFilterMacroPrimitives,individualFilterMacroTests} = If[Length[filterMacroPrimitives] > 0,
		Transpose@MapThread[
			Function[{filterPrimitive,primitiveIndex},
				Module[{filterAssociation,expandedSource,invalidSampleSpecifications,sourceModelContainer,
					specifiedFilteredContainers,sampleSpecificationTest,filterContainerCountTest,
					expandedParams,sourceModelContainers,sourceModelContainerPackets,volumes,filterInput,
					filterSamplesByContainer,filterContainers,filterSamples,sterile,macroFilterOptions,macroFilterTests,
					expandedFilterMacroOptions,	time,containerOut,filter,membraneMaterial,
					poreSize,type,instrument,housing,syringe,molCutoff,prefilterMembraneMaterial,prefilterPoreSize,temperature,intensity,counterbalanceWeight,collectionContainer,
					smMacroFilterTests,resolvedCollectionContainer,resolvedCollectionContainerWithoutDefine,macroCollectionContainerTest,resolvedContainerOut,
					collectionContainerModels,types,resolvedFilters,filters,filtersDBMembers,filtersToDownload,downloadedFilters,
					simulatedFilterReplacementRules,instruments,invalidContainerModels,invalidFiltrationTypes,
					validContainers,invalidInstruments,invalidFilters,notSupportedflags,
					sampleContainerObjectsOrModels,sampleModelContainers,filterStorageCondition,sourceObjectOrModelContainerPackets,
					invalidContainerModelsForSamples,invalidFiltrationTypesForSamples,validContainersForSamples,invalidInstrumentsForSamples,
					invalidFiltersForSamples,notSupportedflagsForSamples,macroFilterCollectionContainerTest,macroFilterSourceContainerTest,
					macroFiltrationSupportedTest, filterSimulation
				},

				(* get the full form of the incubation as an Association *)
					filterAssociation = First[filterPrimitive];

					(* Listablize Sample if necessary *)
					expandedSource = If[MatchQ[Lookup[filterAssociation,Sample],objectSpecificationP],
						{Lookup[filterAssociation,Sample]},
						Lookup[filterAssociation,Sample]
					];

					(* make sure the association has the expanded source *)
					expandedParams = Prepend[filterAssociation, Sample -> expandedSource];

					(* -- Do some error checking on the samples -- *)

					(* The Sample field must point to samples (not containers) *)
					invalidSampleSpecifications = Map[
						(* we're mapping of the sample list so we check each sample individually *)
						Switch[#,
						(* Container specification to a plate is not ok *)
							ObjectP[{Object[Container,Plate],Model[Container,Plate]}],
							#,
						(* Container specification is ok if it's a container since we know there is only the A1 position *)
							ObjectP[{Object[Container,Vessel],Model[Container,Vessel]}],
							Nothing,
							_String,
						(* If defined name reference points to a vessel (not a plate), then we're good since we know there is only the A1 position*)
							If[MatchQ[Lookup[definedNamesLookup,#][Container],ObjectP[{Object[Container,Vessel],Model[Container,Vessel]}]],
								Nothing,
								If[
								(* If both Sample and Well are empty, the defined name reference doesn't point to a sample *)
									And[
										MatchQ[Lookup[definedNamesLookup,#][Sample],_Missing],
										MatchQ[Lookup[definedNamesLookup,#][Well],_Missing]
									],
									#,
									Nothing
								]
							],
							_,
							Nothing
						]&,
						expandedSource
					];

					(* Build test for sample specification *)
					sampleSpecificationTest = If[Length[invalidSampleSpecifications] > 0,
						validMacroFilterQ = False;
						If[gatherTests,
							Test[StringTemplate["The Filter primitive at index `1` references samples, vessels, in its Sample key:"][primitiveIndex],True,False],
							Message[Error::InvalidFilterSampleSpecification,primitiveIndex];
							Message[Error::InvalidInput,filterPrimitive];
							Null
						],
						If[gatherTests,
							Test[StringTemplate["The Filter primitive at index `1` references samples in its Sample key:"][primitiveIndex],True,True],
							Null
						]
					];

					(* Extract the container the samples are in; this will be a list of objects and models (in case of Define primitives referring to a model container) *)
					sampleContainerObjectsOrModels = Map[
						(* Extract container objects or unique references *)
						Switch[#,
							(* A defined sample reference *)
							_String,
							Which[
								(* If a defined reference is a sample, fetch its container *)
									MatchQ[Lookup[definedNamesLookup,#][Sample],ObjectP[Object[Sample]]],
									Download[Lookup[fetchPacketFromCacheHPLC[Lookup[definedNamesLookup, #][Sample],allPackets], Container], Object],
								(* If the defined reference points to a {container, well} pair, extract the container *)
									MatchQ[Lookup[definedNamesLookup,#][Sample],{ObjectP[],WellPositionP}],
									(Lookup[definedNamesLookup,#][Sample])[[1]],
								(* If reference is a {container, well} pair where the container is a reference, extract container *)
									MatchQ[Lookup[definedNamesLookup,#][Sample],{_String,WellPositionP}],
								(* If container reference is an object or model then fetch it *)
									If[MatchQ[Lookup[definedNamesLookup,Lookup[definedNamesLookup,#][Sample][[1]]][Container],ObjectP[{Object[Container],Model[Container]}]],
										Lookup[definedNamesLookup,Lookup[definedNamesLookup,#][Sample][[1]]][Container],
										Lookup[definedNamesLookup,#][Sample][[1]]
									],
								(* If reference is a object or model container, return that *)
									MatchQ[Lookup[definedNamesLookup,#][Container],ObjectP[{Object[Container],Model[Container]}]],
										Lookup[definedNamesLookup,#][Container],
								(* If reference is a defined container, extract it *)
									MatchQ[Lookup[definedNamesLookup,#][Container],_String],
								(* If container reference is a defined container object, extract the actual object *)
									If[MatchQ[Lookup[definedNamesLookup,Lookup[definedNamesLookup,#][Container]][Container],ObjectP[Object[Container]]],
										Lookup[definedNamesLookup,Lookup[definedNamesLookup,#][Container]][Container],
										Lookup[definedNamesLookup,#][Container]
									],
									True,
									Nothing
								],
						(* A location reference with defined container *)
							{_String,WellPositionP},
							If[MatchQ[Lookup[definedNamesLookup,#[[1]]][Container],ObjectP[{Model[Container],Object[Container]}]],
								Lookup[definedNamesLookup,#[[1]]][Container],
								#[[1]]
							],
						(* plate object or model with well *)
							{ObjectP[{Object[Container,Plate],Model[Container,Plate]}],WellPositionP},
							Download[#[[1]],Object],
						(* plate or vessel object or model *)
							ObjectP[{Object[Container],Model[Container]}],
							Download[#,Object],
						(* Direct sample reference *)
							ObjectP[Object[Sample]],
							Download[Lookup[fetchPacketFromCacheHPLC[#,allPackets],Container],Object],
						(* Tagged Model container *)
							{_Symbol|_String|_Integer,ObjectP[Model[Container]]},
							#[[2]],
						(* Model tag with well *)
							{{_Symbol|_String|_Integer,ObjectP[Model[Container]]},_String},
							#[[1,2]],
							_,
							Nothing
						]&,
						expandedSource
					];

					(* Currently, we only support one plate per Macro Filter primitive, so if we have multiple containers it must be vessels, and not plates *)
					filterContainerCountTest = If[Length[DeleteDuplicates[sampleContainerObjectsOrModels]] > 1 && !MatchQ[sampleContainerObjectsOrModels, {ObjectP[{Object[Container, Vessel],Model[Container,Vessel]}] ..}],
						validMacroFilterQ = False;
						If[gatherTests,
							Test[StringTemplate["All samples in the Filter primitive at index `1` use the same filter plate:"][primitiveIndex],True,False],
							Message[Error::TooManyMacroFilterContainers,primitiveIndex];
							Message[Error::InvalidInput,filterPrimitive];
							Null
						],
						If[gatherTests,
							Test[StringTemplate["All samples in the Filter primitive at index `1` use the same filter plate:"][primitiveIndex],True,True],
							Null
						]
					];

					(* -- Prepare for the ExperimentFilter call -- *)

					(* Get packets for containers objects and models *)
					sourceModelContainers=Map[
						If[MatchQ[#,ObjectP[Model[Container]]],
							Download[#,Object],
							Download[Lookup[fetchPacketFromCacheHPLC[#,allPackets],Model],Object]
						]&,
						sampleContainerObjectsOrModels
					];

					sourceModelContainerPackets = (fetchPacketFromCacheHPLC[#,allPackets]&)/@sourceModelContainers;

					sourceObjectOrModelContainerPackets = (fetchPacketFromCacheHPLC[#,allPackets]&)/@sampleContainerObjectsOrModels;

					(* Fetch max volumes to use as dummy sample volumes below *)
					(* TODO: Right now, this assumes that things are not in plates. This entire simulation process is fucked and needs to be completely rewritten. *)
					volumes = (
						If[MatchQ[#,ObjectP[Model[Container]]],
							Lookup[#, MaxVolume],
							If[Length[Lookup[#, Contents]]>=1,
								With[{samplePacket=fetchPacketFromCacheHPLC[Lookup[#, Contents][[1]][[2]],allPackets]},
									If[MatchQ[samplePacket, ObjectP[Object[Sample]]],
										Lookup[samplePacket, Volume],
										Lookup[fetchPacketFromCacheHPLC[Lookup[#, Model],allPackets], MaxVolume]
									]
								]
							]
						]
					&)/@sourceObjectOrModelContainerPackets;

					(* As the input for ExperimentFilter, we may have to create simulated samples with the model container of the source location and add contents of water. We do this
					because the samples may not yet be created for some incubate primitives(ie: intermediate primitives currently using models via the Define primitive) *)
					(* Note that these packets can be passed as cache as well into ExperimentFilter *)
					filterInput = If[!MatchQ[expandedSource,{ObjectP[Object[Sample]]..}],
						MapThread[
							SimulateSample[
								{Model[Sample,"Milli-Q water"]},
								"",
								{"A1"},
								#1,
								{Volume->#2,Mass->Null,Count->Null}
							]&,
							{sourceModelContainers,volumes}
						],
						{}
					];

					(* If we created simulated samples, separate the simulated packets into sample packets, and container packets *)
					{filterSamplesByContainer,filterContainers}=If[!MatchQ[filterInput,{}],Transpose[filterInput],{{},{}}];

					(* The input samples into ExperimentFilter are either the specified samples or the simulated samples *)
					filterSamples=If[!MatchQ[filterContainers,{}],Flatten[filterSamplesByContainer,1],expandedSource];

					(* If the options are not specified, fill in Automatic so that we can call ExperimentIncubate below (with the exception of Sterile which defaults to False) *)
					{time,filterStorageCondition,membraneMaterial,poreSize,type,instrument,housing,syringe,molCutoff,prefilterMembraneMaterial,prefilterPoreSize,temperature,intensity,counterbalanceWeight}=Map[
						If[MissingQ[filterAssociation[#]],
							Automatic,
							filterAssociation[#]]&,
						{Time,FilterStorageCondition,MembraneMaterial,PoreSize,FiltrationType,Instrument,FilterHousing,Syringe,MolecularWeightCutoff,PrefilterMembraneMaterial,PrefilterPoreSize,Temperature,Intensity,CounterbalanceWeight}
					];

					(* Extract any specified CollectionContainer Object or Model references if we have a defined CollectionContainer since ExperimentFilter doesn't handle strings as ContainerOut *)
					filter = Switch[Lookup[filterAssociation,Filter],
						(* if it's missing, we put in automatic *)
						_Missing,
							Automatic,
						(* If it was specified as an object or model container, we take that *)
						ObjectP[],
							Download[Lookup[filterAssociation,Filter],Object],
						_String,
							(* If we have defined it via a string, look it up so we can pass it to ExperimentFilter *)
							(* TODO: have we covered all edge cases here? *)
							Lookup[definedNamesLookup,Lookup[filterAssociation,Filter]][Container],
						_,
							Automatic
					];

					(* Extract any specified CollectionContainer Object or Model references if we have a defined CollectionContainer since ExperimentFilter doesn't handle strings as CollectionContainer *)
					collectionContainer = Switch[Lookup[filterAssociation,CollectionContainer],
						(* if it's missing, we put in automatic *)
						_Missing,
						Automatic,
						(* If it was specified as an object or model container, we take that *)
						ObjectP[],
						Download[Lookup[filterAssociation,CollectionContainer],Object],
						_String,
						(* If we have defined it via a string, look it up so we can pass it to ExperimentFilter *)
						(* TODO: have we covered all edge cases here? *)
						Lookup[definedNamesLookup,Lookup[filterAssociation,CollectionContainer]][Container],
						_,
						Automatic
					];

					(* Extract any specified CollectionContainer Object or Model references if we have a defined CollectionContainer since ExperimentFilter doesn't handle strings as ContainerOut *)
					containerOut = Switch[Lookup[filterAssociation,CollectionContainer],
						(* if it's missing, we put in automatic *)
						_Missing,
							Automatic,
						(* If it was specified as an object or model container, we take that *)
						ObjectP[],
							Download[Lookup[filterAssociation,CollectionContainer],Object],
						_String,
							(* If we have defined it via a string, look it up so we can pass it to ExperimentFilter *)
							(* TODO: have we covered all edge cases here? *)
							Lookup[definedNamesLookup,Lookup[filterAssociation,CollectionContainer]][Container],
						_,
							Automatic
					];

					(* Default Sterile to False, if it wasn't specified by the user (no Automatic) *)
					sterile=If[MissingQ[filterAssociation[Sterile]],
						False,
						filterAssociation[Sterile]
					];

					(* collect all the tests we threw inside the resolver *)
					smMacroFilterTests={filterContainerCountTest,sampleSpecificationTest};

					(* make a simulation blob for ExperimentFilter *)
					filterSimulation = Simulation[FlattenCachePackets[{filterInput,centrifugePackets}]];

					(* Call ExperimentIncubate to resolve the options for the Macro Incubate primitive *)
					{macroFilterOptions,macroFilterTests}=If[gatherTests,
						Module[{options,tests},
							{options,tests}=ExperimentFilter[
								filterSamples,
								Time -> time,
								FiltrateContainerOut -> containerOut,
								Filter -> filter,
								FilterStorageCondition -> (filterStorageCondition/.{Automatic->Disposal}),
								MembraneMaterial -> membraneMaterial,
								PoreSize -> poreSize,
								FiltrationType -> type,
								Instrument -> instrument,
								FilterHousing -> housing,
								Syringe -> syringe,
								Sterile -> sterile,
								MolecularWeightCutoff -> molCutoff,
								PrefilterMembraneMaterial -> prefilterMembraneMaterial,
								PrefilterPoreSize -> prefilterPoreSize,
								Temperature -> temperature,
								Intensity -> intensity,
								Simulation -> filterSimulation,
								Aliquot->False,
								EnableSamplePreparation->False,
								CounterbalanceWeight->counterbalanceWeight,
								CollectionContainer->containerOut,
								OptionsResolverOnly -> True,
								Output->{Options,Tests}
							];
							If[RunUnitTest[<|"Tests"->tests|>,OutputFormat->SingleBoolean,Verbose->False],
								{options,Join[tests,smMacroFilterTests]},
								{$Failed,Join[tests,smMacroFilterTests]}
							]
						],
						(
							{
								Check[
									ExperimentFilter[
										filterSamples,
										Time -> time,
										FiltrateContainerOut -> containerOut,
										Filter -> filter,
										FilterStorageCondition -> (filterStorageCondition/.{Automatic->Disposal}),
										MembraneMaterial -> membraneMaterial,
										PoreSize -> poreSize,
										FiltrationType -> type,
										Instrument -> instrument,
										FilterHousing -> housing,
										Syringe -> syringe,
										Sterile -> sterile,
										MolecularWeightCutoff -> molCutoff,
										PrefilterMembraneMaterial -> prefilterMembraneMaterial,
										PrefilterPoreSize -> prefilterPoreSize,
										Temperature -> temperature,
										Intensity -> intensity,
										Simulation -> filterSimulation,
										Aliquot->False,
										EnableSamplePreparation->False,
										CounterbalanceWeight->counterbalanceWeight,
										CollectionContainer->containerOut,
										OptionsResolverOnly -> True,
										Output->Options
									],
									$Failed,
									{Error::InvalidInput,Error::InvalidOption}
								],
								{}
							}
						)
					];

					(* Since some options will be collapsed and others expanded (such as ContainerOut) in this output, make sure we expand them all to indexmatch the samples *)
					expandedFilterMacroOptions=If[!MatchQ[macroFilterOptions,$Failed],
						ExpandIndexMatchedInputs[ExperimentFilter, {filterSamples},macroFilterOptions][[2]],
					(* If the option resoultion failed, we switch the validity bool to False *)
						validMacroFilterQ=False;
						$Failed
					];

					(* if the resolution returned failed, we return the primitive as it was without doing any further error checking on the resolved options *)
					If[MatchQ[expandedFilterMacroOptions,$Failed],
					(* if the resolution returned failed, we return the primitive as it was *)
						Return[{Filter[expandedParams],macroFilterTests},Module]
					];

					(* -- check whether the resolved collection container is OK -- *)

					(* Important note: In SM, we require the collection container to be the container that the filtrate is directly collected in.
						We do not want ExpFilter to grab intermediate containers before transferring the sample into the container specified by the user, since that causes multiple transfers which will cause a huge mess.
						Importantly, the SM compiler will be creating that sample during that single transfer.
						We pass a flag during the ExpFilter subprotocol creation in the procedure letting ExpFilter know not to make samples as it usually does.
						What collection containers are OK depends highly on the type of filtration we're doing, so we will make a big switch below.
					 *)

					(* grab the containerOut that ExpFilter resolved to *)
					resolvedContainerOut=ToList[Lookup[expandedFilterMacroOptions,FiltrateContainerOut]];

					(* Fetch models of collection container. We know that at this point it's not a string anymore since we've fetched the defined reference before calling ExpFilter*)
					collectionContainerModels = Switch[resolvedContainerOut,
						(* object container or containers *)
						{ObjectP[Object[Container]]},
							Download[Lookup[fetchPacketFromCacheHPLC[resolvedContainerOut,allPackets],Model],Object],
						{ObjectP[Object[Container]]..},
							Download[Lookup[fetchPacketFromCacheHPLC[#,allPackets],Model]&/@resolvedContainerOut,Object],

						(* model container or containers *)
						{ObjectP[Model[Container]]..},
						Download[resolvedContainerOut,Object],

					(* tagged object container or containers *)
						{_,ObjectP[Object[Container]]},
						Download[Lookup[fetchPacketFromCacheHPLC[resolvedContainerOut[[2]],allPackets],Model],Object],
						{{_,ObjectP[Object[Container]]}..},
						Download[Lookup[fetchPacketFromCacheHPLC[#,allPackets],Model]&/@resolvedContainerOut[[All,2]],Object],

					(* tagged model container or containers *)
						{_,ObjectP[Object[Container]]},
							Download[resolvedContainerOut[[2]],Object],
						{{_,ObjectP[Model[Container]]}..},
							Download[resolvedContainerOut[[All,2]],Object],
						_,
						Null
					];

					(* Make sure the model of the collection container is suitable, depending on the filtration type *)
					(* no need to check for Volume since ExpFilter will throw errors *)
					types=Lookup[expandedFilterMacroOptions,FiltrationType];

					(* If we resolved to a filter that doesn't exist, it's because we simulated our sample to be in a filter that doesn't exist. *)
					(* Switch back to Automatic in this case so that it can be resolved again when it comes time to resource pick our filter. *)

					(* Run dbmQ to identify simulated containers *)
					filtersDBMembers = DatabaseMemberQ[Lookup[expandedFilterMacroOptions,Filter]];

					(* We need to download any simulated containers (not databaseMembers), first find which ones they are *)
					filtersToDownload = If[And@@filtersDBMembers,
         				MapThread[
							Function[{filter, dbMember},
								MatchQ[filter,ObjectP[Object[Container]]] && !dbMember
							],
							{ToList[Lookup[expandedFilterMacroOptions,Filter]],ToList[filtersDBMembers]}
						],
						False
					];

					(* Download needed models that are not in the database *)
					downloadedFilters =  If[And@@ToList[filtersToDownload],
						Download[
							PickList[Lookup[expandedFilterMacroOptions,Filter],filtersToDownload],
							Model[Object],
							Cache->Flatten[filterInput]
						],
						{}
					];

					(* To replace the simulated containers make a replacement rule for position->downloaded model *)
					simulatedFilterReplacementRules = If[And@@ToList[filtersToDownload],
         				MapThread[
							Rule[#1,#2]&,
							{Flatten[Position[filtersToDownload, True]],downloadedFilters}
						],
						{}
					];

					(* Now we can replace the simulated containers with their downloaded model, if there are any *)
					filters = If[And@@ToList[filtersToDownload],
						ReplacePart[Lookup[expandedFilterMacroOptions,Filter], simulatedFilterReplacementRules],
						Lookup[expandedFilterMacroOptions,Filter]
					];

					instruments=Lookup[expandedFilterMacroOptions,Instrument];

					(* it is possible that the input were multiple samples that require different types of filtration so we will have to map over the samples and containers *)
					{invalidContainerModels,invalidFiltrationTypes,validContainers,invalidInstruments,invalidFilters,notSupportedflags}=Transpose[MapThread[
						Function[{model,type,filter,instrument},
						Switch[{type,filter,instrument},

							(* For pos pressure filtering, any vessel is fine since we stick a tubing into it, no plates though *)
							{PeristalticPump,_,_},
							If[!MatchQ[model,ObjectP[{Model[Container, Vessel]}]],
								{model,type,"Model[Container,Vessel]",instrument,filter,False},
								{{},{},{},{},{},{}}
							],

							(* For syringe filtering, any vessel is fine assuming the syringe nozzle fits into the tube *)
							{Syringe,_,_},
							If[!MatchQ[model,ObjectP[{Model[Container, Vessel]}]],
								{model,type,"Model[Container,Vessel]",instrument,filter,Null},
								{{},{},{},{},{},{}}
							],

							(* The case where we use vacuum and filter block as instrument, in which case only 96 well plates are fine *)
							(* Currently only DWP are ok *)
							{Vacuum,_,ObjectP[{Object[Instrument,FilterBlock],Model[Instrument,FilterBlock]}]},
							If[!MatchQ[model,ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]],
								{model,type,"Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]",instrument,filter,Null},
								{{},{},{},{},{},{}}
							],

							(* The case where we use vacuum and a separate item as filter (one without a collection container attached to it), in which case any collection vessel is fine *)
							{Vacuum,ObjectP[{Object[Item,Filter],Model[Item,Filter]}],_},
							If[!MatchQ[model,ObjectP[{Model[Container, Vessel]}]],
								{model,type,"Model[Container,Vessel]",instrument,filter,Null},
								{{},{},{},{},{},{}}
							],

							(* The case where we use vacuum and a insert inside a container, only those filter containers where the inserts are located in are fine *)
							(* Note that the type of this is just a regular container vessel. We don't make any additional check here - we rely on ExperimentFilter to throw an error if the ContainerOut provided by the user is not in line with the respective bottom part model *)
							{Vacuum,ObjectP[{Object[Container,Vessel,Filter],Model[Container,Vessel,Filter]}],_},
								If[!MatchQ[model,ObjectP[{Model[Container,Vessel],Object[Container,Vessel]}]],
								{model,type,"Model[Container,Vessel,Filter]",instrument,filter,Null},
								{{},{},{},{},{},{}}
								],

							(* In centrifuge we always use an insert inside a container, in which case only those filter containers are fine *)
							{Centrifuge,ObjectP[{Object[Container,Vessel,Filter],Model[Container,Vessel,Filter]}],_},
								(* If[!MatchQ[model,ObjectP[{Model[Container,Vessel,Filter]}]],
								{Null,type,"Model[Container,Vessel,Filter]",instrument,True},
								{{},{},{},{},{},{}}
								] *)
								(* TODO currently we do not support this until the filter container is 2 separate containers, so we set the flag to True so we can throw a different error *)
							(* TODO: @Wal -- is this correct? *)
							{{},{},{},{},{},{}},

							(* catch-all *)
							_,{{},{},{},{},{},{}}
						]
					],
						{collectionContainerModels,types,filters,instruments}
					]];

					(* If we have invalid CollectionContainers, we need to throw an error indicating which containers may be valid and suggest appending a transfer primitive *)
					macroFilterCollectionContainerTest=If[!MatchQ[Flatten[invalidContainerModels],{}]&&!MemberQ[notSupportedflags,True],
						validMacroFilterQ = False;
						If[gatherTests,
							Test[StringTemplate["In the Filter primitive at index `1`, the specified CollectionContainer model, `2`, is supported for filtering via `3`:"][primitiveIndex,DeleteDuplicates[invalidContainerModels],DeleteDuplicates[invalidFiltrationTypes]],True,False],
							Message[Error::InvalidMacroFilterCollectionContainer,primitiveIndex,DeleteDuplicates[invalidContainerModels],DeleteDuplicates[invalidFiltrationTypes],DeleteDuplicates[invalidInstruments],DeleteDuplicates[validContainers]];
							Message[Error::InvalidInput,filterPrimitive];
							Null
						],
						If[gatherTests,
							Test[StringTemplate["In the Filter primitive at index `1`, the specified CollectionContainer model, `2`, is supported for filtering via `3`:"][primitiveIndex,DeleteDuplicates[invalidContainerModels],DeleteDuplicates[invalidFiltrationTypes]],True,True],
							Null
						]
					];

					(* TODO: this is a TEMPORARY error, remove once centrifuge and bottle top filters are 2 different objects *)
					(* If any of the samples triggered the flag, we will have to throw an error indicating that this type of filtration is not supported currently *)
					macroFiltrationSupportedTest=If[MemberQ[notSupportedflags,True],
						validMacroFilterQ = False;
						If[gatherTests,
							Test[StringTemplate["In the Filter primitive at index `1`, the specified `2`, is supported for filtering via SampleManipulation:"][primitiveIndex,DeleteDuplicates[invalidFiltrationTypes]],True,False],
							Message[Error::FiltrationTypeNotSupported,primitiveIndex,DeleteDuplicates[invalidFiltrationTypes],DeleteDuplicates[invalidFilters]];
							Message[Error::InvalidInput,filterPrimitive];
							Null
						],
						If[gatherTests,
							Test[StringTemplate["In the Filter primitive at index `1`, the specified `2`, is supported for filtering via SampleManipulation:"][primitiveIndex,DeleteDuplicates[invalidFiltrationTypes]],True,True],
							Null
						]
					];

					(* -- check whether the containers in which the input samples are currently in are OK -- *)

					(* Important note: In SM, we require the container of the sample to be the one from which we can directly execute the filtering.
						We do not want ExpFilter to have to transfer into a suitable container before filtering the sample since that causes multiple transfers which will cause a huge mess.
						Importantly, the SM compiler will be creating that sample during that single transfer, and not ExpFilter.
						We pass a flag during the ExpFilter sub-protocol creation in the procedure letting ExpFilter know not to make samples as it usually does.
						What sample input containers are OK depends highly on the type of filtration we're doing, so we will make a big switch here.
					 *)

					(* it is possible that the input were multiple samples that require different types of filtration so we will have to map over the samples and containers *)
					{invalidContainerModelsForSamples,invalidFiltrationTypesForSamples,validContainersForSamples,invalidInstrumentsForSamples,invalidFiltersForSamples,notSupportedflagsForSamples}=Transpose[MapThread[Function[{model,type,filter,instrument},
						Switch[{type,filter,instrument},

						(* For pos pressure filtering, any vessel is fine since we stick a tubing into it, no plates though *)
							{PeristalticPump,_,_},
							If[!MatchQ[model,ObjectP[{Model[Container, Vessel]}]],
								{model,type,"Model[Container,Vessel]",instrument,filter,False},
								{{},{},{},{},{},{}}
							],

						(* For syringe filtering, any vessel is fine assuming the syringe nozzle fits into the tube *)
							{Syringe,_,_},
							If[!MatchQ[model,ObjectP[{Model[Container, Vessel]}]],
								{model,type,"Model[Container,Vessel]",instrument,filter,Null},
								{{},{},{},{},{},{}}
							],

						(* The case where we use vacuum and filter block as instrument, in which case only 96 well filter plates are fine *)
						(* We are assuming that all 96 well plates we hold will fit the ANSI dimentions (127mmx85mm) *)
							{Vacuum,_,ObjectP[{Object[Instrument,FilterBlock],Model[Instrument,FilterBlock]}]},
							validBlockPlates=Search[Model[Container,Plate,Filter],NumberOfWells==96 && Deprecated!=True];
							If[!MatchQ[model,ObjectP[validBlockPlates]],
								{model,type,"Model[Container,Plate,Filter] with NumberOfWells = 96",instrument,filter,Null},
								{{},{},{},{},{},{}}
							],

						(* The case where we use vacuum and a insert inside a container, only samples that are already inside the inserts are ok *)
							{Vacuum,ObjectP[{Object[Container,Vessel,Filter],Model[Container,Vessel,Filter]}],_},
							If[!MatchQ[model,ObjectP[{Model[Container,Vessel,Filter]}]],
								{model,type,"Model[Container,Vessel,Filter]",instrument,True},
								{{},{},{},{},{},{}}
							],

						(* The case where we use vacuum and a separate sample object as filter, in which case any  vessel is fine *)
							{Vacuum,ObjectP[{Model[Container, Vessel]}],_},
							If[!MatchQ[model,ObjectP[{Model[Container, Vessel]}]],
								{model,type,"Model[Container,Vessel]",instrument,filter,Null},
								{{},{},{},{},{},{}}
							],

						(* In centrifuge we always use an insert inside a container, only samples that are already inside the inserts are ok *)
							{Centrifuge,ObjectP[{Object[Container,Vessel,Filter],Model[Container,Vessel,Filter]}],_},
						(* If[!MatchQ[model,ObjectP[{Model[Container,Vessel,Filter]}]],
						{Null,type,"Model[Container,Vessel,Filter]",instrument,True},
						{{},{},{},{},{},{}}
						] *)
						(* TODO currently we do not support this until the filter container is 2 separate containers, so we set the flag to True *)
							{model,type,"Model[Container,Vessel,Filter]",instrument,filter,True},

						(* catch-all *)
							_,{{},{},{},{},{},{}}
						]
					],
						{sourceModelContainers,types,filters,instruments}
					]];

					(* If we have invalid CollectionContainers, we need to throw an error indicating which containers may be valid and suggest prepending a transfer primitive *)
					(* TODO: currently don't throw an error when the notSupportedflagsForSamples flag is True since we've already thrown an error above *)
					macroFilterSourceContainerTest=If[!MatchQ[Flatten[invalidContainerModelsForSamples],{}] (* this is temporary --> *)&&!MemberQ[notSupportedflagsForSamples,True],
						validMacroFilterQ = False;
						If[gatherTests,
							Test[StringTemplate["In the Filter primitive at index `1`, the sample(s) are in containers `2` that are supported for filtering via `3`:"][primitiveIndex,DeleteDuplicates[invalidContainerModelsForSamples],DeleteDuplicates[invalidFiltrationTypesForSamples]],True,False],
							Message[Error::InvalidMacroFilterSourceContainer,primitiveIndex,DeleteDuplicates[invalidContainerModelsForSamples],DeleteDuplicates[invalidFiltrationTypesForSamples],DeleteDuplicates[invalidInstrumentsForSamples],DeleteDuplicates[validContainersForSamples]];
							Message[Error::InvalidInput,filterPrimitive];
							Null
						],
						If[gatherTests,
							Test[StringTemplate["In the Filter primitive at index `1`, the sample(s) are in containers `2` that are supported  for filtering via `3`:"][primitiveIndex,DeleteDuplicates[invalidContainerModelsForSamples],DeleteDuplicates[invalidFiltrationTypesForSamples]],True,True],
							Null
						]
					];

					(* For the resolved primitive keys, make sure to convert back to the string reference and pass object/models without the index that ContainerOut resolves to *)
					resolvedCollectionContainer=If[
						(* If the user had not given us anything (either Automatic or Missing) then we grab the ExpFilter option output *)
						MatchQ[Lookup[filterAssociation,CollectionContainer,Automatic],Automatic],
						(* for the compiler, we need to format the ContainerOut output from ExperimentFilter *)
						(* It may be tagged as {{1,object|model}..}, so we delete duplicates and grab the container *)
						If[MatchQ[Lookup[expandedFilterMacroOptions,FiltrateContainerOut],{{_,ObjectP[{Model[Container],Object[Container]}]}..}],
							Lookup[expandedFilterMacroOptions,FiltrateContainerOut][[All,2]],
							Lookup[expandedFilterMacroOptions,FiltrateContainerOut]
						],
						(* if the user gave us something we simply go with that (it has to be a single object or model or a reference string *)
						If[MatchQ[Lookup[filterAssociation,CollectionContainer,Null], _List],
							Lookup[filterAssociation,CollectionContainer,Null],
							ConstantArray[Lookup[filterAssociation,CollectionContainer,Null], Length[types]]
						]
					];

					(* Convert any define names to the container models. *)
					resolvedCollectionContainerWithoutDefine=(If[MatchQ[#,_String],
						Lookup[definedNamesLookup,#][Container],
						#
					]&)/@resolvedCollectionContainer;

					(* Throw error if resolvedCollectionContainer resulted in multiple different plates. Multiple vessels are fine. *)
					macroCollectionContainerTest = If[Length[DeleteDuplicates[resolvedCollectionContainerWithoutDefine]] > 1 && !MatchQ[DeleteDuplicates[resolvedCollectionContainerWithoutDefine], {ObjectP[{Object[Container, Vessel],Model[Container,Vessel]}] ..}],
						validMacroFilterQ = False;
						If[gatherTests,
							Test[StringTemplate["In the Filter primitive at index `1` CollectionContainer was resolved or specified to 1 plate, 1 vessel, or multiple vessels:"][primitiveIndex],True,False],
							Message[Error::TooManyMacroFilterCollectionPlates,primitiveIndex];
							Message[Error::InvalidInput,filterPrimitive];
							Null
						],
						If[gatherTests,
							Test[StringTemplate["In the Filter primitive at index `1` CollectionContainer was resolved or specified to 1 plate, 1 vessel, or multiple vessels:"][primitiveIndex],True,True],
							Null
						]
					];

					(* If the user gave us filters, don't swap them out for the resolved filters. *)
					(* This is similar to resolvedCollectionContainer. *)
					resolvedFilters=If[MatchQ[Lookup[filterAssociation,Filter,Automatic],Automatic],
						filters,
						(* if the user gave us something we simply go with that (it has to be a single object or model or a reference string *)
						If[MatchQ[Lookup[filterAssociation,Filter,Null], _List],
							Lookup[filterAssociation,Filter,Null],
							ConstantArray[Lookup[filterAssociation,Filter,Null], Length[types]]
						]
					];

					(* Return the resolved primitive, and the tests *)
					{
							Filter[
								Append[expandedParams,
									{
									(* replace the Macro keys with the resolved expanded values *)
										CollectionContainer -> resolvedCollectionContainer,
										Time -> Lookup[expandedFilterMacroOptions,Time],
										Filter -> resolvedFilters,
										MembraneMaterial -> Lookup[expandedFilterMacroOptions,MembraneMaterial],
										PoreSize -> Lookup[expandedFilterMacroOptions,PoreSize],
										FiltrationType -> Lookup[expandedFilterMacroOptions,FiltrationType],
										Instrument -> Lookup[expandedFilterMacroOptions,Instrument],
										FilterHousing -> Lookup[expandedFilterMacroOptions,FilterHousing],
										Syringe -> Lookup[expandedFilterMacroOptions,Syringe],
										Sterile -> Lookup[expandedFilterMacroOptions,Sterile],
										MolecularWeightCutoff -> Lookup[expandedFilterMacroOptions,MolecularWeightCutoff],
										PrefilterMembraneMaterial -> Lookup[expandedFilterMacroOptions,PrefilterMembraneMaterial],
										PrefilterPoreSize -> Lookup[expandedFilterMacroOptions,PrefilterPoreSize],
										Temperature -> Lookup[expandedFilterMacroOptions,Temperature],
										Intensity -> Lookup[expandedFilterMacroOptions,Intensity],
										FilterStorageCondition->Lookup[expandedFilterMacroOptions,FilterStorageCondition]
									(* ignore Micro keys *)
										(* CounterbalanceWeight doesn't get resolved and is a hidden key so won't show up in returned options *)
									}
								]
							],

						Join[macroFilterTests,{macroFilterCollectionContainerTest},{macroFilterSourceContainerTest},{macroFiltrationSupportedTest},{macroCollectionContainerTest},{sampleSpecificationTest},{filterContainerCountTest}]
					}
				]],
			{filterMacroPrimitives,filterMacroPositions}
		],
		{{},{}}
	];

	(* Replace existing Filter primitives with resolved Filter primitives (both Macro and Micro *)
	manipulationsWithResolvedFilters = ReplacePart[
		manipulationsWithObjectReferences,
		MapThread[
			Rule[#1,#2]&,
			{Join[filterMacroPositions,filterMicroPositions],Join[resolvedFilterMacroPrimitives,resolvedFilterMicroPrimitives]}
		]
	];
	
	(* === Cover/Uncover Resolution === *)
	
	manipulationsWithResolvedCoverings = Module[{},
		
		Map[
			Function[primitive,
				If[MatchQ[primitive,_Cover],
					Module[{primitiveAssociation,resolvedSample,resolvedCover},
						
						primitiveAssociation = First[primitive];
						
						resolvedSample = Switch[Lookup[primitiveAssociation,Sample],
							ObjectP[]|_String,
								{Lookup[primitiveAssociation,Sample]},
							_,
								Lookup[primitiveAssociation,Sample]
						];
						
						resolvedCover = Switch[Lookup[primitiveAssociation,Cover],
							_Missing|Automatic,
								Table[Model[Item,Lid,"Universal Black Lid"],Length[resolvedSample]],
							{(ObjectP[]|Automatic)..},
								Map[
									If[MatchQ[#,Automatic],
										Model[Item,Lid,"Universal Black Lid"],
										#
									]&,
									Lookup[primitiveAssociation,Cover]
								],
							ObjectP[],
								Table[Lookup[primitiveAssociation,Cover],Length[resolvedSample]],
							_,
								Lookup[primitiveAssociation,Cover]
						];
						
						Cover[Append[
							primitiveAssociation,
							{
								Sample -> resolvedSample,
								Cover -> resolvedCover
							}
						]
					]],
					primitive
				]
			],
			manipulationsWithResolvedFilters
		]
	];
	
	(* ================================ *)

	(* Further process the manipulations; add unique tags to any container models that aren't already tagged per Module-like variable tagging;
	 	also ensure that from now on, all objects are in reference form in the manipulations *)
	manipulationsWithTaggedContainers = Map[
		Function[primitive,
			Module[{tagModelContainerFunction,sources,destinations,modifiedSources,modifiedDestinations},

				(* Define a function that will perform the desired replacements of container models with tagged versions;
				 	make sure not to double-tag stuff that was named/tagged on input *)
				tagModelContainerFunction[sourceDestinationValue_]:=Switch[sourceDestinationValue,
					{ObjectP[Model[Container,Plate]],_String},
						{{Unique[],First[sourceDestinationValue]},Last[sourceDestinationValue]},
					ObjectP[{Model[Container,Vessel],Model[Container,Cartridge],Model[Container,ReactionVessel],Model[Container,Cuvette],Model[Container,Plate]}],
						{Unique[],sourceDestinationValue},
					_,
						sourceDestinationValue
				];

				(* Get the source(s) and destination(s) of this manipulation;
				 	all manips have Source, but Mix doesn't have Destination *)
				sources = Switch[primitive,
					(* Any incubate/mix primitives will have their Source field in a single list by now.
					Wrap in extra list to match Transfer's listability *)
					_Incubate|_Mix|_Centrifuge|_ReadPlate|_Filter|_Pellet|_MoveToMagnet|_RemoveFromMagnet,
						{primitive[Sample]},
					_FillToVolume,
						{{primitive[Source]}},
					_,
						primitive[Source]
				];

				(* Wrap FillToVolume's Destination in two lists to match Transfer's listability *)
				destinations = Switch[primitive,
					_Transfer,
						primitive[Destination],
					_FillToVolume,
						{{primitive[Destination]}},
					_,
						{}
				];

				(* Apply tags to the sources/destinations if they are container models without tags already *)
				modifiedSources = Map[
					tagModelContainerFunction,
					sources,
					{2}
				];
				modifiedDestinations = Map[
					tagModelContainerFunction,
					destinations,
					{2}
				];

				(* replace the tagged sources/destinations in the manipulation association *)
				Switch[primitive,
					_Transfer,
						Transfer[
							Append[First[primitive],
								{
									Source->modifiedSources,
									Destination->modifiedDestinations
								}
							]
						],
					_FillToVolume,
						FillToVolume[
							Append[First[primitive],
								{
									Source->First@First[modifiedSources],
									Destination->First@First[modifiedDestinations]
								}
							]
						],
					(* Take First for Mix/Incubate/Centrifuge since they should be listed at one level less than Transfer *)
					_Mix,
						Mix[Append[First[primitive],Source->First[modifiedSources]]],
					_Incubate,
						Incubate[Append[First[primitive],Sample->First[modifiedSources]]],
					_Centrifuge,
						Centrifuge[Append[First[primitive],Sample->First[modifiedSources]]],
					_Filter,
						Filter[
							Prepend[First[primitive],
								{
									Sample -> First[modifiedSources],
									CollectionContainer -> If[MatchQ[Lookup[First[primitive],CollectionContainer],{ObjectP[{Model[Container]}]..}],
										tagModelContainerFunction/@Lookup[First[primitive],CollectionContainer],
										tagModelContainerFunction[Lookup[First[primitive],CollectionContainer]]
									]
								}
							]
						],
					_MoveToMagnet,
						MoveToMagnet[Append[First[primitive],Sample->First[modifiedSources]]],
					_RemoveFromMagnet,
						RemoveFromMagnet[Append[First[primitive],Sample->First[modifiedSources]]],
					_Pellet,
						Pellet[
							Prepend[First[primitive],
								{
									Sample -> First[modifiedSources],
									SupernatantDestination -> If[MatchQ[Lookup[First[primitive],SupernatantDestination],{ObjectP[{Model[Container]}]..}],
										tagModelContainerFunction/@Lookup[First[primitive],SupernatantDestination,Automatic],
										tagModelContainerFunction[Lookup[First[primitive],SupernatantDestination,Automatic]]
									]
								}
							]
						],
					_ReadPlate,
						ReadPlate[
							Prepend[
								First[primitive],
								{
									Sample -> First[modifiedSources],
									Blank -> tagModelContainerFunction/@Lookup[First[primitive],Blank,{}]
								}
							]
						],
					_,primitive
				]
			]
		],
		manipulationsWithResolvedCoverings
	];

	(* == Validate FillToVolume primitives  == *)

	(* If we're throwing messages, and we have FillToVolume primitives, make sure the Method flag is valid. *)
	{fillToVolumeMethodMessage,fillToVolumeMethodTests}=Module[{primitiveIndices,ftvPrimitives,invalidIndices,
		volumetricFlasks,volumetricFlaskPackets,volumetricFlaskVolumes,maxVolumetricFlaskVolume},
		If[!gatherTests&&MemberQ[manipulationsWithTaggedContainers,_FillToVolume],
			primitiveIndices=Position[Head/@manipulationsWithTaggedContainers,FillToVolume];
			ftvPrimitives=Extract[manipulationsWithTaggedContainers,primitiveIndices];

			(* TODO: This is relatively fast code (0.2s), despite it being a second download. Future improvement would be to squeeze this into the initial download or download conditionally *)
			(* find all the volumetric flasks if we have at least one volumetric fill to volume*)
			volumetricFlasks = Search[Model[Container, Vessel, VolumetricFlask], Deprecated != True && MaxVolume != Null];

			(* Download the volumetric flask packets but only if we are doing that (otherwise we will be Downloading from {} anyway)*)
			volumetricFlaskPackets = Download[volumetricFlasks, Packet[Object, MaxVolume]];

			(* Pull out volumetric flask volumes *)
			volumetricFlaskVolumes = Cases[Download[volumetricFlaskPackets,MaxVolume],VolumeP];

			(* Determine max volumetric flask volume *)
			maxVolumetricFlaskVolume = If[MatchQ[volumetricFlaskVolumes,{VolumeP..}],
				Max[volumetricFlaskVolumes],
				0*Liter
			];

			invalidIndices=MapThread[
				Function[{index, primitive},
					If[
						And[
							(* We have the Method specified. *)
							MatchQ[primitive[Method], FillToVolumeMethodP],
							Or[
								(* Invalid Ultrasonic. *)
								And[
									MatchQ[primitive[Method],Ultrasonic],
									(* The MeasureVolume is called on the destination sample. *)
									MatchQ[Quiet[Lookup[fetchPacketFromCacheHPLC[primitive[Destination],allPackets],UltrasonicIncompatible,Null]],True]
								],
								(* Invalid Volumetric. *)
								And[
									MatchQ[primitive[Method],Volumetric],
									Or[
										MatchQ[primitive[FinalVolume],GreaterP[maxVolumetricFlaskVolume]], (* The largest VolumetricFlask we have. *)
										(* Make sure that the destination is either a volumetric flask, or is in a volumetric flask. *)
										If[MatchQ[primitive[Destination],ObjectP[Object[Sample]]],
											MatchQ[
												fetchPacketFromCache[
													Lookup[fetchPacketFromCacheHPLC[primitive[Destination],allPackets],Container],
													allPackets
												],
												ObjectP[Object[Container,Vessel,Volumetric]]
											],
											MatchQ[primitive[Destination],ObjectP[Object[Container,Vessel,Volumetric]]]
										]
									]
								]
							]
						],
						index,
						Nothing
					]
				],
				{primitiveIndices,ftvPrimitives}
			];

			(* If we have invalid primitives, throw an error. *)
			If[Length[invalidIndices]>1,
				(
					Message[Error::InvalidFillToVolumeMethodManipulations,Flatten[primitiveIndices]];
					Message[Error::InvalidInput,Extract[manipulationsWithTaggedContainers,invalidIndices]]
				);
				{
					True,
					Test["The FillToVolume manipulation primitive(s) at positions "<>ToString[invalidIndices]<>" have a valid Method specified:",True,False]
				},
				{
					False,
					Test["The FillToVolume manipulation primitive(s) have a valid Method specified:",True,True]
				}
			],
			{
				False,
				Test["The FillToVolume manipulation primitive(s) have a valid Method specified:",True,True]
			}
		]
	];

	(* If we're throwing messages, and we have FillToVolume primitives while the scale was specified to MicroLiquidHandling, throw an error here *)
	fillToVolumeAndMicroMessage=Module[{primitiveIndices,invalidFillToVolumePrimitives},
		If[!gatherTests&&MemberQ[manipulationsWithTaggedContainers,_FillToVolume]&&MatchQ[specifiedScale,MicroLiquidHandling],
			primitiveIndices=Position[Head/@manipulationsWithTaggedContainers,FillToVolume];
			invalidFillToVolumePrimitives=Extract[manipulationsWithTaggedContainers,primitiveIndices];
			(Message[Error::InvalidOption,LiquidHandlingScale];Message[Error::FillToVolumeConflictsWithScale,Flatten[primitiveIndices],"FillToVolume"]);
			True,
			False
		]
	];

	(* If we are gathering tests, create tests (but only need those tests if we have a FillToVolume primitive *)
	fillToVolumeConflictsWithScaleTests=If[gatherTests&&MemberQ[manipulationsWithTaggedContainers,_FillToVolume],

		(* We're gathering tests. Create the appropriate tests. *)
		Module[{fillToVolumePrimitives,passingManips,passingIncubateManips,passingManipsTest,passingPrimitiveIndices,
			failingPrimitiveIndices,failingManipsTest},

		(* get the invalid primtiives. If the scale is specified to Micro they are all invalid, otherwise, they will all pass this test *)
			fillToVolumePrimitives=If[MatchQ[specifiedScale,MicroLiquidHandling],
				Cases[manipulationsWithTaggedContainers,_FillToVolume],
				{}
			];

			(* Get the FillToVolume primitives that pass this test. *)
			passingManips=Cases[Complement[manipulationsWithTaggedContainers,fillToVolumePrimitives],_FillToVolume];

			(* get the index of the failing and passing primitives *)
			passingPrimitiveIndices=Sort[Flatten[Position[manipulationsWithTaggedContainers,#]&/@passingManips]];
			failingPrimitiveIndices=Sort[Flatten[Position[manipulationsWithTaggedContainers,#]&/@fillToVolumePrimitives]];

			(* Create a test for the passing inputs. *)
			passingManipsTest=If[Length[passingManips]>0,
				Test["The FillToVolume manipulation primitive(s) at positions "<>ToString[passingPrimitiveIndices]<>" are compatible with the specified LiquidHandlingScale:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingManipsTest=If[Length[fillToVolumePrimitives]>0,
				Test["The FillToVolume manipulation primitive(s) at positions "<>ToString[failingPrimitiveIndices]<>", are compatible with the specified LiquidHandlingScale:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingManipsTest,
				failingManipsTest
			}
		],
	(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* make sure that there is only FillToVolume for each unique destination*)
	fillToVolumeDestinations = Lookup[First[#],Destination]&/@Cases[manipulationsWithTaggedContainers,_?Patterns`Private`fillToVolumeQ];

	(* check whether discarded samples or containers exist *)
	fillToVolumeProblemBool = If[Not[DuplicateFreeQ[fillToVolumeDestinations]],True,False];

	(* if we're gathering tests, return a test whether FillToVolume manipulations specified unique destinations *)
	fillToVolumeTestDescription = "Only one FillToVolume manipulation was requested for a single container.";
	fillToVolumeTest = If[gatherTests,
		Test[fillToVolumeTestDescription,fillToVolumeProblemBool,False],
		Null];

	fillToVolumeProblematicManipulations = PickList[fillToVolumeDestinations,fillToVolumeProblemBool];

	(* throw an error message when not collecting tests and collect a boolean whether this error message was thrown *)
	fillToVolumeProblemMessage = If[!gatherTests&&fillToVolumeProblemBool,
		(
			Message[Error::FillToVolumeDestinationsNotUnique];
			Message[Error::InvalidInput,fillToVolumeProblematicManipulations]
		);
		True,
		False
	];

	(* Find any objects referenced in the FtV destination *)
	fillToVolumeDestinationObjects = Map[
		Cases[#,ObjectP[],{0,Infinity}]&,
		fillToVolumeDestinations
	];

	(* Extract container model packets for destination objects *)
	fillToVolumeDestinationContainerModelPackets = Map[
		Switch[#,
			ObjectP[Model[Container]],
				fetchPacketFromCacheHPLC[#,allPackets],
			ObjectP[Object[Container]],
				fetchModelPacketFromCacheHPLC[#,allPackets],
			ObjectP[Object[Sample]],
				fetchModelPacketFromCacheHPLC[Download[Lookup[fetchPacketFromCacheHPLC[#,allPackets],Container],Object],allPackets],
			_,
				Nothing
		]&,
		fillToVolumeDestinationObjects,
		{2}
	];

	(* If the container model has an object in its VolumeCalibrations field that
	is not Anomalous -> True nor Deprecated -> True, then it can be used in FtV, otherwise it cannot
	since we cannot appropriately measure its volume as we fill it *)
	validVolumeCalibrationBools = Map[
		Or[
			MatchQ[#, {ObjectP[{Model[Container,Vessel,VolumetricFlask],Object[Container,Vessel,VolumetricFlask]}]..}],
			And@@Map[
				And[
					MatchQ[#,{ObjectP[]..}],
				(* If any are not Anomalous -> True ot Deprecated -> True, then we're good *)
					Or@@Map[
						If[
							MatchQ[#,ObjectP[Object[Container]]],
							And[!TrueQ[Lookup[fetchPacketFromCacheHPLC[fetchModelPacketFromCacheHPLC[#,allPackets],allPackets],Anomalous]],!TrueQ[Lookup[fetchPacketFromCacheHPLC[fetchModelPacketFromCacheHPLC[#,allPackets],allPackets],Deprecated]]],
							And[!TrueQ[Lookup[fetchPacketFromCacheHPLC[#,allPackets],Anomalous]],!TrueQ[Lookup[fetchPacketFromCacheHPLC[#,allPackets],Deprecated]]]
						]&,
						#
					]

				]&,
				#[[All,Key[VolumeCalibrations]]]
			]
		]&,
		fillToVolumeDestinationContainerModelPackets
	];

	(* Extract manipulations that have invalid destinations *)
	invalidDestinationFillToVolumes = PickList[
		Cases[manipulationsWithTaggedContainers,_?Patterns`Private`fillToVolumeQ],
		validVolumeCalibrationBools,
		False
	];

	(* Build test for destination calibration *)
	fillToVolumeDestinationCalibrationTest = If[gatherTests,
		If[Length[invalidDestinationFillToVolumes] > 0,
			Test["FillToVolume destinations have VolumeCalibrations:",True,False],
			Test["FillToVolume destinations have VolumeCalibrations:",True,True]
		],
		Null
	];

	(* Throw error if destinations are used without a calibration *)
	invalidfillToVolumeDestinationQ = If[And[!gatherTests,Length[invalidDestinationFillToVolumes] > 0],
		(
			Message[Error::NotCalibratedFillToVolumeDestination,invalidDestinationFillToVolumes];
			Message[Error::InvalidInput,invalidDestinationFillToVolumes];
			True
		),
		False
	];

	allSpecifiedModelPackets = fetchPacketFromCacheHPLC[#,allPackets]&/@Download[models,Object];

	(* For the unique sample models involved (these can only be Source(s)), determine what their max amounts are based on product information;
	 	this list must be index-matched with allSpecifiedModelPackets; currently, only do this for Chemical models;
		 use Null to indicate that no max is verifiable. Handle special water case, where we want to pool water requests
		 UNDER a given threshold, but not split large requests (we want to pour these right into the destination from the purifier) *)
	modelMaxAmounts = Map[
		Function[modelPacket,
			Which[
				(* Water *)
				MatchQ[Lookup[modelPacket,Object],WaterModelP],
					If[MatchQ[Lookup[safeOptions,LiquidHandlingScale],MicroLiquidHandling],
						(* Set max volume to volume of robotic reservoir minus its dead volume (200mL - 30mL) *)
						170 Milliliter,
						20 Liter
					],

				(* Tablet model chemicals *)
				MatchQ[modelPacket,PacketP[Model[Sample]] && Lookup[modelPacket,Tablet,Null]],
				Module[{activeProductPackets},

					(* find all the non-Deprecated product packets on file for this model *)
					activeProductPackets=Select[
						Cases[allPackets,ObjectP[Object[Product]]],
						!TrueQ[Lookup[#,Deprecated]]&&MatchQ[Download[Lookup[#,ProductModel],Object],Lookup[modelPacket,Object]]&
					];

					(* if we have no products on file, return Null to indicate we can't put a bound on what the max single sample of this chemical holds *)
					If[MatchQ[activeProductPackets,{}],
						Return[Null,Module]
					];

					(* determine the tablet count of each active product, and take the max *)
					Max[Lookup[#,CountPerSample]&/@activeProductPackets]
				],

				(* Non-tablet model chemicals *)
				MatchQ[modelPacket,PacketP[Model[Sample]]],
					Module[{activeProductPackets,activeKitProductPackets,maxProductVolume},

						(* find all the non-Deprecated and non-kit product packets on file for this model *)
						activeProductPackets=Select[
							Cases[allPackets,ObjectP[Object[Product]]],
							!TrueQ[Lookup[#,Deprecated]]&&MatchQ[Download[Lookup[#,ProductModel],Object],Lookup[modelPacket,Object]]&
						];

						(* find all the non-Deprecated and kit-component product packets on file for this model *)
						activeKitProductPackets=Select[
							Cases[allPackets,ObjectP[Object[Product]]],
							!TrueQ[Lookup[#,Deprecated]]&&MemberQ[Download[Lookup[Lookup[#,KitComponents,{}],ProductModel],Object],Lookup[modelPacket,Object]]&
						];

						(* get the max volume from the product; if we have no products on file, return Null to indicate we can't put a bound on what the max single sample of this chemical holds *)
						maxProductVolume = Which[
								!MatchQ[activeProductPackets,{}],
									(* determine the sample amount of each active product, and take the max *)
									Max[Lookup[#,Amount]&/@activeProductPackets],
								!MatchQ[activeKitProductPackets,{}],
									(* determine the sample amount from the appropriate entry in the KitComponents field of each active product and take the max*)
									Max[Lookup[Select[Flatten[Lookup[#,KitComponents]],MatchQ[Download[Lookup[#,ProductModel],Object],Lookup[modelPacket,Object]]&],Amount]&/@activeKitProductPackets],
								True,
									Null
						];

						If[MatchQ[Lookup[modelPacket,State],Liquid]&&MatchQ[Lookup[safeOptions,LiquidHandlingScale],MicroLiquidHandling],
							If[NullQ[maxProductVolume],
								(* Volume of robotic reservoir minus its dead volume *)
								170 Milliliter,
								Min[170 Milliliter, maxProductVolume]
							],
							maxProductVolume
						]
					],

				(* Other *)
				True,
					If[MatchQ[Lookup[modelPacket,State],Liquid]&&MatchQ[Lookup[safeOptions,LiquidHandlingScale],MicroLiquidHandling],
						(* Volume of robotic reservoir minus its dead volume *)
						170 Milliliter,
						Null
					]
			]
		],
		allSpecifiedModelPackets
	];

	(* Generate a lookup that relates each model to its max single sample amount (if we know it) *)
	modelMaxAmountLookup = AssociationThread[allSpecifiedModelPackets[[All,Key[Object]]],modelMaxAmounts];

	(* In order to split the model sources, we first extract the position for each individual
	model request with its amount required. Store this information in the form:
	{{model, RentContainer bool, position in primitive list and its source key value}, amount}   *)
	modifiedSourcePositionAmountTuples = Join@@MapThread[
		Function[{index,primitive,rentContainerQ},
			Module[{sourceList},
				(* If we're not in a Transfer or FillToVolume, we don't have to worry about source usage  *)
				If[!MatchQ[primitive,_Transfer|_FillToVolume],
					Return[{},Module]
				];

				sourceList = If[MatchQ[primitive,_Transfer],
					primitive[Source],
					{{primitive[Source]}}
				];

				Join@@MapIndexed[
					If[MatchQ[#1,ObjectP[Model[Sample]]],
						If[MatchQ[primitive,_Transfer],
							{
								{Download[#1,Object],rentContainerQ,Prepend[#2,index]},
								Extract[primitive[Amount],#2]
							},
							{
								{Download[#1,Object],rentContainerQ,{index}},
								primitive[FinalVolume]
							}
						],
						Nothing
					]&,
					sourceList,
					{2}
				]
			]
		],
		{Range[Length[manipulationsWithTaggedContainers]],manipulationsWithTaggedContainers,expandedRentContainerBools}
	];

	(* Gather tuple by unique model and RentContainer bool. This will be in the form:
	 {{{model, RentContainer bool, position in primitive list and its source key value}, amount}..}
	 with each sublist having the same model and RentContainer bool *)
	gatheredTuples = GatherBy[
		modifiedSourcePositionAmountTuples,
		#[[1]][[{1,2}]]&
	];

	(* For each list of unique model/RentContainer pairs, group into sublists with each sublist
	corresponding to an amount usage below the max product volume. This is now in the form:
	{{{{model, RentContainer bool, position in primitive list and its source key value}, amount}..}..}
	with each subsublist representing a set of source positions that can use the same sample *)
	gatheredByAmountTuples = Map[
		Module[{maxAmount,okayUnitTuples,tuplesUnderMaxAmount,tuplesOverMaxAmount},

			(* Lookup the model's max amount *)
			maxAmount = Lookup[modelMaxAmountLookup,#[[1]][[1]][[1]]];

			(* If not in the lookup table, return early *)
			If[NullQ[maxAmount],
				Return[{#},Module]
			];

			(* Don't even bother trying to handle things given in units that don't match our maxAmount *)
			okayUnitTuples=Select[#,(CompatibleUnitQ[#[[2]],maxAmount])&];

			(* GroupByTotal can only handle amounts that are less than the target amount *)
			tuplesUnderMaxAmount = Select[okayUnitTuples,(#[[2]]<=maxAmount)&];

			(* Extract those tuples that request more than the target amount.
			NOTE: we let the resource picking consolidation system handle fulfillment of these. *)
			tuplesOverMaxAmount = Complement[okayUnitTuples,tuplesUnderMaxAmount];

			Join[
				GroupByTotal[tuplesUnderMaxAmount,maxAmount],
				{#}&/@tuplesOverMaxAmount
			]
		]&,
		gatheredTuples
	];

	(* Build replacement rules relating a source position to a unique tag representing a sample.
	Each subsublist of sources that can use the same sample will share the same tag *)
	replacementRules = Join@@Join@@Map[
		Function[gatheredTuples,
			Module[{tag},
				tag = Unique[];
				Map[
					# -> {tag,gatheredTuples[[1]][[1]][[1]]}&,
					gatheredTuples[[All,1]][[All,3]]
				]
			]
		],
		gatheredByAmountTuples,
		{2}
	];

	(* Replace positions in Source key values with the tagged models *)
	replacedSources = If[Length[replacementRules] > 0,
		ReplacePart[
			(#[Source])&/@manipulationsWithTaggedContainers,
			replacementRules
		],
		{}
	][[replacementRules[[All,1]][[All,1]]]];

	(* For each modified primitive position, replace Source key value with modified sources *)
	manipulationsWithSplitModels = If[Length[replacementRules] > 0,
		ReplacePart[
			manipulationsWithTaggedContainers,
			MapThread[
				#1[[1]] -> If[MatchQ[manipulationsWithTaggedContainers[[#1[[1]]]],_Transfer],
					Transfer[
						Prepend[
							First[manipulationsWithTaggedContainers[[#1[[1]]]]],
							Source -> #2
						]
					],
					FillToVolume[
						Prepend[
							First[manipulationsWithTaggedContainers[[#1[[1]]]]],
							Source -> #2
						]
					]
				]&,
				{replacementRules[[All,1]],replacedSources}
			]
		],
		manipulationsWithTaggedContainers
	];

	(* A "specified" primitive is one that has all auxilary sample/location specification keys populated
	 	Transfer/FillToVolume:
			ResolvedSourceLocation
			ResolvedDestinationLocation
			SourceSample
			DestinationSample
		Incubate/Mix/Centrifuge:
			ResolvedSourceLocation
			SourceSample
		Pellet:
			ResolvedSourceLocation
			ResolvedSupernatantDestinationLocation
			ResolvedResuspensionSourceLocation
			SourceSample
			SupernatantDestinationSample
			ResuspensionSourceSample
		Filter:
			ResolvedSourceLocation
			SourceSample
			ResolvedFilterLocation
			ResolvedCollectionLocation
		MoveToMagnet/RemoveFromMagnet:
			ResolvedSourceLocation
			SourceSample
		ReadPlate:
			ResolvedSourceLocation
			ResolvedAdjustmentSampleLocation
			SourceSample
		*)
	specifiedManipulations = Map[
		specifyManipulation[#,Cache->allPackets,DefineLookup->definedNamesLookup]&,
		manipulationsWithSplitModels
	];



	(* Note: If there are multiple locations or sample references, just take the container of the first one. *)
	(* This is because we did the transfer and filter error checking for multiple inputs/destinations above so they must be the same. *)
	fetchSingleContainerReference[rawLocation_,rawSampleReference_]:=Module[{location,sampleReference},
		location=(If[MatchQ[#,_List],If[MatchQ[#,PlateAndWellP|{_String,WellPositionP}],#,Sequence@@#],#]&)/@rawLocation;
		sampleReference=(If[MatchQ[#,_List],If[MatchQ[#,PlateAndWellP|{_String,WellPositionP}],#,Sequence@@#],#]&)/@rawSampleReference;

		Which[
			(* Given a location. If our sample already exists, we will have this key. *)
			MatchQ[location,ObjectP[Object[Container]]],
				location,
			MatchQ[location,PlateAndWellP],
				location[[1]],

			(* Given multiple locations, take the first.  *)
			MatchQ[location,{(ObjectP[Object[Container]]|PlateAndWellP)..}],
				If[MatchQ[location[[1]],PlateAndWellP],
					location[[1]][[1]],
					location[[1]]
				],

			(* Or sample is defined. We must have a defined sample name. *)
			MatchQ[sampleReference,_String],
				If[MatchQ[Lookup[definedNamesLookup,sampleReference][Container],ObjectP[Model[Container]]],
					sampleReference,
					Lookup[definedNamesLookup,sampleReference][Container]
				],
			MatchQ[sampleReference,{_String,WellPositionP}],
				If[MatchQ[Lookup[definedNamesLookup,sampleReference[[1]]][Container],ObjectP[Model[Container]]],
					sampleReference[[1]],
					Lookup[definedNamesLookup,sampleReference[[1]]][Container]
				],

			(* Given multiple defined samples. *)
			MatchQ[sampleReference,{(_String|{_String,WellPositionP})..}],
				If[MatchQ[sampleReference[[1]],{_String,WellPositionP}],
					(* We're already talking about a defined sample container. *)
					sampleReference[[1]][[1]],
					(* We're talking about a defined sample. Lookup the container. *)
					If[MatchQ[Lookup[definedNamesLookup,sampleReference[[1]]][Container],ObjectP[Model[Container]]],
						sampleReference[[1]],
						Lookup[definedNamesLookup,sampleReference[[1]]][Container]
					]
				],

			True,
				Null
		]
	];

	fetchSingleContainerModelReference[rawSampleReference_]:=Module[{convertedReference},

		(* Convert any defined references to objects *)
		convertedReference = Switch[rawSampleReference,
			(* A defined sample reference *)
			_String,
				If[!MatchQ[Lookup[definedNamesLookup,rawSampleReference][Sample],_Missing],
					Lookup[definedNamesLookup,rawSampleReference][Sample],
					If[MatchQ[Lookup[definedNamesLookup,rawSampleReference][Well],WellPositionP],
						{Lookup[definedNamesLookup,rawSampleReference][Container],Lookup[definedNamesLookup,#][Well]},
						Lookup[definedNamesLookup,rawSampleReference][Container]
					]
				],
			(* A location reference with defined container *)
			{_String,WellPositionP},
				{Lookup[definedNamesLookup,rawSampleReference[[1]]][Container],rawSampleReference[[2]]},
			_,
				rawSampleReference
		];

		(* Determine if the referenced object is actually in a filter plate OR in a phytip column *)
		Switch[convertedReference,
			ObjectP[Model[Container]],
				convertedReference,

			{ObjectP[Model[Container]], WellPositionP},
				convertedReference[[1]],

			(* A position that is a vessel object *)
			ObjectP[Object[Container]],
				fetchModelPacketFromCacheHPLC[convertedReference,allPackets],

			(* A position that is a vessel object and position*)
			{ObjectP[Object[Container]], WellPositionP},
				fetchModelPacketFromCacheHPLC[convertedReference[[1]],allPackets],

			(* If we have {_String, WellPositionP}, get the model of the defined container. *)
			{_String,WellPositionP},
				fetchDefineModelContainer[
					Lookup[definedNamesLookup,convertedReference[[1]]],
					Cache->allPackets
				],
			(* Direct sample reference -- make sure sample is already in a filter plate or phytip vessel model *)
			ObjectP[Object[Sample]],
				fetchModelPacketFromCacheHPLC[
					Lookup[fetchPacketFromCacheHPLC[convertedReference,allPackets],Container],
					allPackets
				],
			(* Cannot specify a sample model since we need it to be transferred into a filter *)
			ObjectP[Model[Sample]],
				Null,

			(* All other cases should be invalid *)
			_,
				Null
		]
	];

	(* Check to make sure you cannot Transfer primitive into multiple filter plate destinations. *)
	invalidTransferFilterPlateIndices=If[MatchQ[resolvedLiquidHandlingScale,MicroLiquidHandling],
		MapThread[
			Function[{manipulation,manipulationIndex},
				Module[{resolvedDestinations,resolvedDestinationModelContainers,nameToModelLookup},
					If[MatchQ[manipulation,_Transfer],
						(* Destination and ResolvedDestinationLocation are index-matched. Get the resolved destination for each map-thread index. *)
						resolvedDestinations=MapThread[
							fetchSingleContainerReference[#1,#2]&,
							{manipulation[ResolvedDestinationLocation],manipulation[Destination]}
						];

						(* Do we have multiple destinations that we need to check? *)
						If[Length[DeleteDuplicates[resolvedDestinations]]==1,
							Nothing,
							(* ELSE: Get the models of their containers. *)
							resolvedDestinationModelContainers=Flatten[fetchDestinationModelContainers[
								manipulation,
								Cache->allPackets,
								DefineLookup->definedNamesLookup
							]];

							(* Create rules of the destination name to the model. *)
							nameToModelLookup=MapThread[#1->#2&,{resolvedDestinations,resolvedDestinationModelContainers}];

							If[
								Length[
									Cases[
										Apply[Association,DeleteDuplicates[nameToModelLookup]],
										ObjectP[Model[Container,Plate,Filter]]
									]
								]>1,
								manipulationIndex,
								Nothing
							]
						],
						(* ELSE: Not a transfer. *)
						Nothing
					]
				]
			],
			{specifiedManipulations,Range[Length[specifiedManipulations]]}
		],
		{}
	];

	(* Throw our errors if we got them. *)
	transferFilterPlateTest = If[Length[invalidTransferFilterPlateIndices]>0,
		validMicroFiltersQ = False;
		If[gatherTests,
			Test["Transfers into multiple filter plates within a single primitive are now allowed (since only one filter plate can be stacked on the collection plate at a time, to prevent dripping onto the deck):",True,False],
			Message[Error::InvalidTransferFilterPlatePrimitive,invalidTransferFilterPlateIndices];
			Message[Error::InvalidInput,invalidTransferFilterPlateIndices];
			Null
		],
		If[gatherTests,
			Test["Transfers into multiple filter plates within a single primitive are now allowed (since only one filter plate can be stacked on the collection plate at a time, to prevent dripping onto the deck):",True,True],
			Null
		]
	];

	(* Check that you cannot filter samples from multiple filter plates. *)
	invalidFilterSourceIndices=If[MatchQ[resolvedLiquidHandlingScale,MicroLiquidHandling],
		MapThread[
			Function[{manipulation,manipulationIndex},
				Module[{resolvedSourceContainers,resolvedSourceContainerModels},
					If[MatchQ[manipulation,_Filter],
						(* Destination and ResolvedDestinationLocation are index-matched. Get the resolved destination for each map-thread index. *)
						resolvedSourceContainers=MapThread[
							fetchSingleContainerReference[#1,#2]&,
							{manipulation[ResolvedSourceLocation],manipulation[Sample]}
						];

						(* Get the models of our containers. *)
						resolvedSourceContainerModels=fetchSingleContainerModelReference/@manipulation[Sample];

						(* If there are multiple source containers and they are not all phytips (phytips always go into the same singular rack), we have an invalid primitive. *)
						If[!MatchQ[resolvedSourceContainerModels, {ObjectP[Model[Container,Vessel,"id:zGj91a7nlzM6"]]..}] && Length[DeleteDuplicates[resolvedSourceContainers]]>1,
							manipulationIndex,
							Nothing
						],
						(* ELSE: Not a filter. *)
						Nothing
					]
				]
			],
			{specifiedManipulations,Range[Length[specifiedManipulations]]}
		],
		{}
	];

	(* Throw our errors if we got them. *)
	filterSourceTest = If[Length[invalidFilterSourceIndices] > 0,
		validMicroFiltersQ = False;
		If[gatherTests,
			Test["Micro filter primitives can only have samples from the same container, since the MPE2 can only filter one filter plate/collection plate stack at a time:",True,False],
			Message[Error::InvalidFilterSourcePrimitive,invalidFilterSourceIndices];
			Message[Error::InvalidInput,invalidFilterSourceIndices];
			Null
		],
		If[gatherTests,
			Test["Micro filter primitives can only have samples from the same container, since the MPE2 can only filter one filter plate/collection plate stack at a time:",True,True],
			Null
		]
	];

	(* Keep track of invalid primitive indices. *)
	invalidFilterPlatePrimitiveIndices={};
	invalidCollectionPlatePrimitiveIndices={};
	invalidFilterTransferIndices={};

	(* The following checks only apply for MicroLiquidHandling: *)
	(* Check to make sure that we're not transferring into a filter plate is directly book-ended by a Filter[...] primitive of that filter plate. There cannot be overlap between these regions. *)
	(* Also check to make sure that we're not transferring into a collection plate when it's in the low plate position slot. *)

	If[MatchQ[resolvedLiquidHandlingScale,MicroLiquidHandling],
		Module[{currentFilterPlate,currentCollectionPlate,allFilterPlates,allCollectionPlates},
			(* Keep track of the current filter and collection plate being loaded into in the low plate position. *)
			currentFilterPlate=Null;
			currentCollectionPlate=Null;

			(* Get all of the filter and collection plates. *)
			allFilterPlates=Flatten[(fetchSingleContainerReference[#[ResolvedFilterLocation],#[Sample]]&)/@Cases[specifiedManipulations,_Filter]];
			allCollectionPlates=Flatten[(#[CollectionContainer]&)/@Cases[specifiedManipulations,_Filter]];

			(* Map over our manipulations and update the variables above. *)
			MapThread[
				Function[{manipulation,manipulationIndex},
					Switch[manipulation,
						_Filter,
						(* If we are filtering, reset the current filter/collection plate, if they were the ones that we were previously loading. *)
						(* This is because we could *technically* filter an empty plate that we weren't loading. *)
						(
							Module[{filterLocation,collectionLocation},
								(* Filter location will be Null if filtering from a defined container. *)
								filterLocation=fetchSingleContainerReference[manipulation[ResolvedFilterLocation],manipulation[Sample]];

								(* CollectionContainer is always filled out. *)
								collectionLocation=manipulation[CollectionContainer];

								If[MatchQ[currentFilterPlate,filterLocation] && MatchQ[currentCollectionPlate,collectionLocation],
									currentFilterPlate=Null;
									currentCollectionPlate=Null;
								];
							]
						),
						_Transfer,
						(
							Module[{transferSourceLocation,transferDestinationLocation},
								(* Lookup the source and destination locations. *)
								transferSourceLocation=fetchSingleContainerReference[manipulation[ResolvedSourceLocation],manipulation[Source]];

								transferDestinationLocation=fetchSingleContainerReference[manipulation[ResolvedDestinationLocation],manipulation[Destination]];

								(* Are we transferring into/out of one of our filter/collection plates? *)
								If[MemberQ[Join[allCollectionPlates,allFilterPlates], transferDestinationLocation|transferSourceLocation],
									(* Yes. *)

									(* Are the current filter/collection plate set? (note: they get set together so it doesn't really matter that we || here ) *)
									If[MatchQ[currentFilterPlate,Null]||MatchQ[currentCollectionPlate,Null],
										(* They are not set. *)
										(* If we are transferring into a filter plate: *)
										If[MemberQ[allFilterPlates, transferDestinationLocation],
											(* This means that we will be loading the transfer primitive onto the low position position to prepare the plate for filtration. *)
											(* Find the next Filter[...] primitive that references this filter plate. We will use this primitive to find our corresponding collection plate. *)
											Module[{nextFilterPrimitive},
												nextFilterPrimitive=FirstCase[specifiedManipulations[[manipulationIndex;;-1]],_Filter,Null];

												(* If we didn't find a next filter primitive, it is NOT okay. *)
												If[MatchQ[nextFilterPrimitive,Null],
													AppendTo[invalidFilterTransferIndices,manipulationIndex],
													(* We found a filter primitive. Use it to set the current filter/collection plate. *)
													currentFilterPlate=fetchSingleContainerReference[nextFilterPrimitive[ResolvedFilterLocation],nextFilterPrimitive[Sample]];
													currentCollectionPlate=nextFilterPrimitive[CollectionContainer];
												];
											]
										],
										(* They are set. *)
										Which[
											(* Transferring into/out of the current collection plate is NOT okay. *)
											MatchQ[currentCollectionPlate, transferSourceLocation|transferDestinationLocation],
												AppendTo[invalidCollectionPlatePrimitiveIndices,manipulationIndex],
											(* Transferring into/out of the current filter plate IS okay. *)
											MatchQ[currentFilterPlate, transferSourceLocation|transferDestinationLocation],
												Null,
											(* Transferring into/out of OTHER filter plates is NOT okay. *)
											MemberQ[Complement[allFilterPlates,{currentFilterPlate}], transferSourceLocation|transferDestinationLocation],
												AppendTo[invalidFilterPlatePrimitiveIndices,manipulationIndex],
											(* Otherwise, we're fine. *)
											True,
												Null
										]
									],
									(* No. *)
									Null
								];
							];
						),
						_,
						Null
					];
				],
				{specifiedManipulations,Range[Length[specifiedManipulations]]}
			]
		];
	];

	(* Throw our errors if we got them. *)
	filterPlatePrimitiveTest = If[Length[invalidFilterPlatePrimitiveIndices] > 0,
		validMicroFiltersQ = False;
		If[gatherTests,
			Test["Only one filter plate is allowed to be transferred into at a time (between filterations, so that the filtered material does not drip onto the liquid handling deck):",True,False],
			Message[Error::InvalidFilterContainerAccess,invalidFilterPlatePrimitiveIndices];
			Message[Error::InvalidInput,invalidFilterPlatePrimitiveIndices];
			Null
		],
		If[gatherTests,
			Test["Only one filter plate is allowed to be transferred into at a time (between filterations, so that the filtered material does not drip onto the liquid handling deck):",True,True],
			Null
		]
	];

	(* Throw our errors if we got them. *)
	collectionPlatePrimitiveTest = If[Length[invalidCollectionPlatePrimitiveIndices] > 0,
		validMicroFiltersQ = False;
		If[gatherTests,
			Test["Collection plates are not allowed to be transferred into/out of when they are stacked under the filter plate (when the corresponding filter plate is being loaded in preparation for filteration):",True,False],
			Message[Error::InvalidCollectionContainerAccess,invalidCollectionPlatePrimitiveIndices];
			Message[Error::InvalidInput,invalidCollectionPlatePrimitiveIndices];
			Null
		],
		If[gatherTests,
			Test["Collection plates are not allowed to be transferred into/out of when they are stacked under the filter plate (when the corresponding filter plate is being loaded in preparation for filteration):",True,True],
			Null
		]
	];
	
	(* make a test for Filter being required if Transfer is happening out of the filter plate *)
	transferNeedsFilterTest = If[Length[invalidFilterTransferIndices] > 0,
		validMicroFiltersQ = False;
		If[gatherTests,
			Test["In micro liquid handling, every time Transfer is specified out of filter plate, Filter primitive must be present after the last Transfer into the filter plate:",True,False],
			Message[Error::FilterRequired,invalidFilterTransferIndices];
			Message[Error::InvalidInput,invalidFilterTransferIndices];
		],
		If[gatherTests,
			Test["In micro liquid handling, every time Transfer is specified out of filter plate, Filter primitive must be present after the last Transfer into the filter plate:",True,True],
			Null
		]
	];

	(* Join all filter-related tests *)
	filterTests = Join[
		individualFilterMacroTests,
		individualFilterMicroTests,
		missingKeysMicroFilterPrimitiveTests,
		{
			filterContainerCompatibilityTest,
			filterPlatePrimitiveTest,
			collectionPlatePrimitiveTest,
			transferFilterPlateTest,
			filterSourceTest,
			transferNeedsFilterTest
		}
	];

	(* == Define Function: simulatePrimitiveInputFunction == *)
	(* sources: list of values given for Sample key *)
	(* sourceLocations: values in ResolvedSourceLocation *)
	(* returns simulated sample packets *)
	simulatePrimitiveInputFunction[sources_,sourceLocations_,sourceSamples_,options:OptionsPattern[]]:=Module[
		{sourceContainers,sourceWells,sourceModelContainers,sourceModelContainerPackets,minVolumes,gatheredParams,volumeKey},

		(* Fetch any known containers or tagged model containers for sources *)
		sourceContainers = MapThread[
			Function[{source,sourceLocation},
				Which[
					(* Tagged Model container *)
					MatchQ[source,{_Symbol|_String|_Integer,ObjectP[Model[Container]]}],
					source,
					(* Model tag with well *)
					MatchQ[source,{{_Symbol|_String|_Integer,ObjectP[Model[Container]]},_String}],
					source[[1]],
					(* Straight Model container *)
					MatchQ[source,ObjectP[Model[Container]]],
					source,
					(* If source location is a container or container and well, fetch its model from the cache *)
					MatchQ[sourceLocation,ObjectP[Object[Container]]],
					sourceLocation,
					MatchQ[sourceLocation,PlateAndWellP],
					sourceLocation[[1]],
					(* Tagged Model container *)
					MatchQ[source,_String],
					(* extract any subsequent definitions from the definedNamesLookup *)
					If[
						!MatchQ[Lookup[definedNamesLookup, source][Sample], _Missing],
						Lookup[definedNamesLookup, source][Container],
						source
					],
					MatchQ[source,{_String,WellPositionP}],
					source[[1]],
					True,
					Nothing
				]
			],
			{sources,sourceLocations}
		];

		(* Fetch any specified wells. Default to A1 *)
		sourceWells = MapThread[
			Function[{source,sourceLocation},
				Which[
					(* Tagged Model container *)
					MatchQ[source,{_Symbol|_String|_Integer,ObjectP[Model[Container]]}],
					"A1",
					(* Model tag with well *)
					MatchQ[source,{{_Symbol|_String|_Integer,ObjectP[Model[Container]]},_String}],
					source[[2]],
					(* Straight Model container *)
					MatchQ[source,ObjectP[Model[Container]]],
					"A1",
					(* If source location is a container or container and well, fetch its model from the cache *)
					MatchQ[sourceLocation,ObjectP[Object[Container]]],
					"A1",
					MatchQ[sourceLocation,PlateAndWellP],
					sourceLocation[[2]],
					(* Tagged Model container *)
					MatchQ[source,_String],
					If[
						MatchQ[Lookup[definedNamesLookup,source][Well],WellPositionP],
						Lookup[definedNamesLookup,source][Well],
						If[
							MatchQ[Lookup[definedNamesLookup,source][Sample],{_,WellPositionP}],
							Lookup[definedNamesLookup,source][Sample][[2]],
							"A1"
						]
					],
					MatchQ[source,{_String,WellPositionP}],
					source[[2]],
					True,
					Nothing
				]
			],
			{sources,sourceLocations}
		];
		
		(* Determine the container models of the samples given as input *)
		(* If given an explicit sample/container object, ResolvedSourceLocation will point to the container object *)
		(* If given some type of model, must look at original Sample key *)
		sourceModelContainers = MapThread[
			Function[{source,sourceLocation},
				Which[
					(* Tagged Model container *)
					MatchQ[source,{_Symbol|_String|_Integer,ObjectP[Model[Container]]}],
					source[[2]],
					(* Model tag with well *)
					MatchQ[source,{{_Symbol|_String|_Integer,ObjectP[Model[Container]]},_String}],
					source[[1,2]],
					(* Straight Model container *)
					MatchQ[source,ObjectP[Model[Container]]],
					source,
					(* If source location is a container or container and well, fetch its model from the cache *)
					MatchQ[sourceLocation,ObjectP[Object[Container]]],
					Download[Lookup[fetchPacketFromCacheHPLC[sourceLocation,allPackets],Model],Object],
					MatchQ[sourceLocation,PlateAndWellP],
					Download[Lookup[fetchPacketFromCacheHPLC[sourceLocation[[1]],allPackets],Model],Object],
					(* Tagged Model container *)
					MatchQ[source,_String],
					fetchDefineModelContainer[Lookup[definedNamesLookup,source],Cache->allPackets,DefineLookup->definedNamesLookup],
					(* Tagged Model container and well. *)
					MatchQ[source,{_String,WellPositionP}],
					fetchDefineModelContainer[Lookup[definedNamesLookup,source[[1]]],Cache->allPackets,DefineLookup->definedNamesLookup],
					True,
					Nothing
				]
			],
			{sources,sourceLocations}
		];

		(* Get packets for model containers *)
		sourceModelContainerPackets = fetchPacketFromCacheHPLC[#,allPackets]&/@sourceModelContainers;
		(* Determine whether to lookup MinVolume or MaxVolume (sometimes it is safer to assume the container is *)
		(* almost empty or completely full). *)
		volumeKey=Lookup[ToList[options],MaxVolume,MinVolume];

		(* Fetch min volumes to use as dummy sample volumes below *)
		minVolumes = sourceModelContainerPackets[[All,Key[volumeKey]]]/.{Null->0 Microliter};

		(* We need to call SimulateSample ONCE PER unique container such that the resulting simulated packets
		are in the same container. Therefore group by container.
		Results in the form {{{cont1,well,model,minvol},{cont1,well,model,minvol}},{{cont2,well,model,minvol}}} *)
		gatheredParams = GatherBy[Transpose[{sourceContainers,sourceWells,sourceModelContainers,minVolumes}],#[[1]]&];

		(* As the input for ExperimentIncubate/ExperimentCentrifuge, create simulated samples with the
		model container of the source location and add contents of water.
		We do this because the samples may not yet be created
		(ie: intermediate primitives currently using models via the Define primitive) *)
		(* we only simulate if we don't have samples specified (Sample can be a container, so also check the SourceSample *)
		If[MatchQ[sources,{ObjectP[Object[Sample]]..}]||MatchQ[sourceSamples,{ObjectP[Object[Sample]]..}],
			{},
			Map[
				SimulateSample[
					Table[Model[Sample,"Milli-Q water"],Length[#]],
					"",
					#[[All,2]],
					#[[1,3]],
					Table[{Volume->#[[1,4]],Mass->Null, Count -> Null, State -> Liquid},Length[#]]
				]&,
				gatheredParams
			]
		]
	];

	(* == Define Function: collapseMacroOptionsToContainers == *)
	(* nestedSamples: list of samples (nested) that are located inside the source containers, eg. if we're dealing with a plate and two containers this could be {{s1,s2},{s3},{s4}} *)
	(* listedContainers: list of source containers (indexmatched to nestedSamples) *)
	(* optionsToTransform: the set of resolved options from the ExperimentOptions call *)
	(* The option output from the ExperimentOptions call is partially collapsed, partially expanded to the flat list of samples *)
	(* This helper converts the option set to be indexmatched to the flat list of containers, which in case there are plates, is less then the list of samples *)
	collapseMacroOptionsToContainers[
		experimentFunction_Symbol,
		nestedSamples:{{ObjectP[Object[Sample]]..}..}, (* if we're simulating we have looked up the Object of the simulated sample *)
		listedContainers:({ObjectP[{Object[Container],Model[Container]}]..} | {_String..} | {{_,ObjectP[Model[Container]]}..}), (* can be a list of strings if we're simulating *)
		optionsToTransform:OptionsPattern[]]:=Module[
		{flattenedSamples,indexmatchedContainers,uniqueContainers,functionDefinition,expandedOptions,
			nonIndexMatchedOptions,indexMatchedOptions,indexMatchedOptionsWithContainers,groupedOptionsByContainers,
			contractedOptionsTransposed,contractedOptionsValues,contractedOptionsAssociation},

	(* prepare the list of samples and containers *)
		flattenedSamples=Flatten[nestedSamples];
		indexmatchedContainers=Flatten[ExpandDimensions[nestedSamples,listedContainers]];
		uniqueContainers=DeleteDuplicates[indexmatchedContainers];

		(* Get the full list of option definitions for this function *)
		(* Pretend that AliquotContainer is index-matching *)
		functionDefinition=OverwriteAliquotOptionDefinition[experimentFunction,OptionDefinition[experimentFunction]];

		(* expand the options to match the flat list of samples *)
		expandedOptions=ExpandIndexMatchedInputs[experimentFunction,{flattenedSamples},optionsToTransform][[2]];

		(* For each key value pair in the expanded options, sort the options into non-index matched and index matched options: *)
		{nonIndexMatchedOptions,indexMatchedOptions}=Flatten/@Transpose[(
			Module[{optionDefinition},
			(* Lookup the definition of this option from its symbol. *)
				optionDefinition=FirstCase[functionDefinition,KeyValuePattern["OptionSymbol"->#[[1]]],<||>];

				(* Is this option index matched and is it in it's non-singleton version? *)
				If[MatchQ[Lookup[optionDefinition,"IndexMatchingInput",$Failed], _String]&&!MatchQ[#[[2]],ReleaseHold[Lookup[optionDefinition,"SingletonPattern",$Failed]]],
					{{},#},
					{#,{}}
				]
			]
		&)/@expandedOptions];

		(* append the Containers list to the indexmatched option set *)
		indexMatchedOptionsWithContainers=Join[indexMatchedOptions,{"Containers"->indexmatchedContainers}];

		(* extract the option values per sample and group by the container ID *)
		(* this has the form <|container1->{{a1,b1,container1},{a1,b1,container1}},container2->{{a2,b2,container1},{a2,b2,container2}}|> *)
		groupedOptionsByContainers=GroupBy[Transpose[Values[indexMatchedOptionsWithContainers]],Last];

		(* pick one set of options per container (the option sets should be identical for all samples within the same container - we would have thrown an error before calling this helper  *)
		contractedOptionsTransposed=Lookup[groupedOptionsByContainers,#][[1]]&/@uniqueContainers;

		(* Transpose back to have options values grouped together. We know the last entries are containers so we kick it out *)
		(* this is now in the form of {{a1,a2},{b1,b2}} *)
		contractedOptionsValues=Transpose[contractedOptionsTransposed][[1;;-2]];

		(* construct the option set by adding back the keys to the modified values *)
		contractedOptionsAssociation=MapThread[
			#1->#2&,
			{Keys[indexMatchedOptions],contractedOptionsValues}
		];

		(* append the updated contracted options to the options that are singletons and turn it back into an association *)
		Association[Append[nonIndexMatchedOptions,contractedOptionsAssociation]]

	];

	(* -- Resolve Pellet Primitives -- *)

	(* Find positions of any centrifuge manipulations - and remove needless outer list returned by Position *)
	pelletPositions=First/@(Position[specifiedManipulations,_Pellet,{1}]);

	pelletPrimitives=specifiedManipulations[[pelletPositions]];

	(* - Simulate the samples we're going to create - *)
	pelletOutput=Map[
		Function[pelletPrimitive,
			Module[{pelletAssociation,expandedSource,expandedSourceSample,expandedSourceLocation,pelletInput,
				simulatedSourcePackets,pelletSamplesByContainer,pelletContainers,pelletSamples,time,
				intensity,instrument,temperature,defaultTime,defaultTemperature,pelletOptions,pelletTests,
				expandedOptions,resolvedPrimitive,expandedResuspensionSource,expandedResuspensionSourceLocation,expandedResuspensionSourceSample,
				simulatedResuspensionSourcePackets,resuspensionSamplesByContainer,resuspensionContainers,
				resuspensionSamples,expandedSupernatantDestinationSource,expandedSupernatantDestinationLocation,expandedSupernatantSourceSample,
				simulatedSupernatantDestinationPackets,supernatantDestinationByContainer,supernatantDestinationContainers,
				supernatantDestinations,pelletSimulation,supernatantDestinationsWithoutSimulation,resuspensionSourcesWithoutSimulation,
				expandedNonSimulatedOptions,pelletResult},

				pelletAssociation=First[pelletPrimitive];

				(* -- SIMULATE SOURCE PACKETS -- *)
				(* Get whatever the user specified, convert to a list if it's not already in that form *)
				expandedSource=If[MatchQ[Lookup[pelletAssociation,Sample],objectSpecificationP],
					{Lookup[pelletAssociation,Sample]},
					Lookup[pelletAssociation,Sample]
				];

				(* Get resolved source sample - this will only be populated if we know the specific object*)
				expandedSourceSample = Lookup[pelletAssociation,SourceSample];

				(* Get resolved location - this will only be populated if we know the specific object *)
				expandedSourceLocation=Lookup[pelletAssociation,ResolvedSourceLocation];

				(* If we aren't working with a list of sample objects, simulate samples *)
				simulatedSourcePackets=simulatePrimitiveInputFunction[expandedSource,expandedSourceLocation,expandedSourceSample,Volume->MaxVolume];

				(* Assemble the incubate samples (using either the sources, or the simulated samples *)
				{pelletSamplesByContainer,pelletContainers}=If[!MatchQ[simulatedSourcePackets,{}],
					Transpose[simulatedSourcePackets],
					{{},{}}
				];

				pelletSamples=If[!MatchQ[pelletSamplesByContainer,{}],
					Flatten[pelletSamplesByContainer,1],
					(* notably the Sample key can be provided as Plate and Well, which would break the ExperimentPellet call below *)
					(* we'll grab the corresponding samples in the wells provided, which is stored in the SourceSample key at this point *)
					MapThread[
						If[MatchQ[#1,PlateAndWellP],
							#2,
							#1
						]&,
						{expandedSource,expandedSourceSample}
					]
				];

				(* -- SIMULATE RESUSPENSION SOURCE PACKETS -- *)
				(* Get whatever the user specified, convert to a list if it's not already in that form *)
				expandedResuspensionSource=Lookup[pelletAssociation,ResuspensionSource,{}];

				(* Get resolved source sample - this will only be populated if we know the specific object*)
				expandedResuspensionSourceSample=Lookup[pelletAssociation,ResuspensionSourceSample,{}];

				(* Get resolved location - this will only be populated if we know the specific object *)
				expandedResuspensionSourceLocation=Lookup[pelletAssociation,ResolvedResuspensionSourceLocation,{}];

				(* If we aren't working with a list of sample objects, simulate samples *)
				simulatedResuspensionSourcePackets=If[MatchQ[expandedResuspensionSource,Automatic|{Automatic...}],
					{},
					simulatePrimitiveInputFunction[expandedResuspensionSource,expandedResuspensionSourceLocation,expandedResuspensionSourceSample,Volume->MaxVolume]
				];

				(* Assemble the incubate samples (using either the sources, or the simulated samples *)
				{resuspensionSamplesByContainer,resuspensionContainers}=If[!MatchQ[simulatedResuspensionSourcePackets,{}],
					Transpose[simulatedResuspensionSourcePackets],
					{{},{}}
				];
				resuspensionSamples=If[!MatchQ[resuspensionSamplesByContainer,{}],
					Flatten[resuspensionSamplesByContainer,1],
					expandedResuspensionSource
				];

				(* -- SIMULATE SUPERNATANT DESTINATION PACKETS -- *)
				(* Get whatever the user specified, convert to a list if it's not already in that form *)
				expandedSupernatantDestinationSource=Lookup[pelletAssociation,SupernatantDestination,{}];

				(* Get resolved source sample - this will only be populated if we know the specific object*)
				expandedSupernatantSourceSample=Lookup[pelletAssociation,SupernatantSourceSample,{}];

				(* Get resolved location - this will only be populated if we know the specific object *)
				expandedSupernatantDestinationLocation=Lookup[pelletAssociation,ResolvedSupernatantDestinationLocation,{}];

				(* If we aren't working with a list of sample objects, simulate samples *)
				simulatedSupernatantDestinationPackets=If[MatchQ[expandedSupernatantDestinationSource,Automatic|{Automatic...}],
					{},
					simulatePrimitiveInputFunction[expandedSupernatantDestinationSource,expandedSupernatantDestinationLocation,expandedSupernatantSourceSample,Volume->MinVolume]
				];

				(* Assemble the samples (using either the sources, or the simulated samples *)
				{supernatantDestinationByContainer,supernatantDestinationContainers}=If[!MatchQ[simulatedSupernatantDestinationPackets,{}],
					Transpose[simulatedSupernatantDestinationPackets],
					{{},{}}
				];
				supernatantDestinations=If[!MatchQ[supernatantDestinationByContainer,{}],
					Flatten[supernatantDestinationByContainer,1],
					expandedSupernatantDestinationSource
				];
				
				(* make a simulation blob for ExperimentPellet *)
				pelletSimulation = Simulation[FlattenCachePackets[Flatten[{simulatedSourcePackets,simulatedResuspensionSourcePackets,simulatedSupernatantDestinationPackets}]]];

				(* Call ExperimentPellet to resolve our pellet options *)
				pelletResult=Check[
					{pelletOptions,pelletTests}=If[gatherTests,
						Module[{options,tests},
							{options,tests}=ExperimentPellet[
								pelletSamples,

								(* Pass down all of our options -- except for the ones that don't take Automatic, manually replace those. *)
								Time->(Lookup[pelletAssociation,Time,Automatic]/.{Automatic->5 Minute}),
								Temperature->(Lookup[pelletAssociation,Temperature,Automatic]/.{Automatic->Ambient}),
								SupernatantVolume->(Lookup[pelletAssociation,SupernatantVolume,Automatic]/.{Automatic->All}),

								(* Pass down options that have to be simulated. *)
								ResuspensionSource->If[MatchQ[resuspensionSamples,{Automatic...}],
									Automatic,
									resuspensionSamples
								],
								SupernatantDestination->If[MatchQ[supernatantDestinations,Automatic|{Automatic...}],
									Waste,
									supernatantDestinations/.{Automatic->Waste}
								],

								Sequence@@(If[KeyExistsQ[pelletAssociation,#],
										#->Lookup[pelletAssociation,#,Automatic],
										Nothing
									]&)/@{
									Intensity, Instrument, SupernatantTransferInstrument,
									ResuspensionVolume, ResuspensionInstrument, ResuspensionMix,
									ResuspensionMixType, ResuspensionMixUntilDissolved,
									ResuspensionMixInstrument, ResuspensionMixTime,
									ResuspensionMixMaxTime, ResuspensionMixDutyCycle,
									ResuspensionMixRate, ResuspensionNumberOfMixes,
									ResuspensionMaxNumberOfMixes, ResuspensionMixVolume,
									ResuspensionMixTemperature, ResuspensionMixMaxTemperature,
									ResuspensionMixAmplitude
								},

								Aliquot->False,
								Simulation -> pelletSimulation,
								OptionsResolverOnly -> True,
								Output->{Options,Tests}
							];
							If[RunUnitTest[<|"Tests"->tests|>,OutputFormat->SingleBoolean,Verbose->False],
								{options,tests},
								{$Failed,tests}
							]
						],
						{
							ExperimentPellet[
								pelletSamples,

								(* Pass down all of our options -- except for the ones that don't take Automatic, manually replace those. *)
								Time->(Lookup[pelletAssociation,Time,Automatic]/.{Automatic->5 Minute}),
								Temperature->(Lookup[pelletAssociation,Temperature,Automatic]/.{Automatic->Ambient}),
								SupernatantVolume->(Lookup[pelletAssociation,SupernatantVolume,Automatic]/.{Automatic->All}),

								(* Pass down options that have to be simulated. *)
								ResuspensionSource->If[MatchQ[resuspensionSamples,{Automatic...}],
									Automatic,
									resuspensionSamples
								],
								SupernatantDestination->If[MatchQ[supernatantDestinations,Automatic|{Automatic...}],
									Waste,
									supernatantDestinations/.{Automatic->Waste}
								],

								Sequence@@(If[KeyExistsQ[pelletAssociation,#],
										#->Lookup[pelletAssociation,#,Automatic],
										Nothing
									]&)/@{
									Intensity, Instrument, SupernatantTransferInstrument,
									ResuspensionVolume, ResuspensionInstrument, ResuspensionMix,
									ResuspensionMixType, ResuspensionMixUntilDissolved,
									ResuspensionMixInstrument, ResuspensionMixTime,
									ResuspensionMixMaxTime, ResuspensionMixDutyCycle,
									ResuspensionMixRate, ResuspensionNumberOfMixes,
									ResuspensionMaxNumberOfMixes, ResuspensionMixVolume,
									ResuspensionMixTemperature, ResuspensionMixMaxTemperature,
									ResuspensionMixAmplitude
								},

								Aliquot->False,
								Simulation -> pelletSimulation,
								OptionsResolverOnly -> True,
								Output->Options
							],
							{}
						}
					],
					$Failed,
					{Error::InvalidOption, Error::InvalidInput}
				];

				(* since some options will be collapsed in this output, make sure we expand them all *)
				expandedOptions=If[!MatchQ[pelletOptions,$Failed],
					ExpandIndexMatchedInputs[ExperimentPellet,{pelletSamples},pelletOptions][[2]],
					$Failed
				];

				(* We don't actually want to use the resolved SupernatantDestination and ResuspensionSource options because they can have *)
				(* simulated samples in them. If the raw and resolved options are of the same length, map thread over them and replace any *)
				(* simulated samples with their original define names. *)
				supernatantDestinationsWithoutSimulation=If[Length[Lookup[expandedOptions,SupernatantDestination]] == Length[expandedSupernatantDestinationSource],
					MapThread[
						Function[{resolvedOption, orignalOption},
							If[MatchQ[resolvedOption, ObjectP[]] && Quiet[MatchQ[Lookup[resolvedOption, Simulated, False], True]],
								orignalOption,
								resolvedOption
							]
						],
						{Lookup[expandedOptions,SupernatantDestination],expandedSupernatantDestinationSource}
					],
					Lookup[expandedOptions,SupernatantDestination]
				];

				resuspensionSourcesWithoutSimulation=If[Length[Lookup[expandedOptions,ResuspensionSource]] == Length[expandedResuspensionSource],
					MapThread[
						Function[{resolvedOption, orignalOption},
							If[MatchQ[resolvedOption, ObjectP[]] && Quiet[MatchQ[Lookup[resolvedOption, Simulated, False], True]],
								orignalOption,
								resolvedOption
							]
						],
						{Lookup[expandedOptions,ResuspensionSource],expandedResuspensionSource}
					],
					Lookup[expandedOptions,ResuspensionSource]
				];

				(* Replace our expanded options with these non-simulated options. *)
				expandedNonSimulatedOptions=ReplaceRule[
					expandedOptions/.{$Failed->{}},
					{
						SupernatantDestination->supernatantDestinationsWithoutSimulation,
						ResuspensionSource->resuspensionSourcesWithoutSimulation
					}
				];

				(* Update our primitive with our newly resolved options *)
				resolvedPrimitive=Pellet[
					Append[
						pelletAssociation,
						(#->Lookup[expandedNonSimulatedOptions,#]&)/@{
							Time,Temperature,SupernatantVolume,SupernatantDestination,
							Intensity, Instrument, SupernatantVolume, SupernatantDestination,
							SupernatantTransferInstrument, ResuspensionSource,
							ResuspensionVolume, ResuspensionInstrument, ResuspensionMix,
							ResuspensionMixType, ResuspensionMixUntilDissolved,
							ResuspensionMixInstrument, ResuspensionMixTime,
							ResuspensionMixMaxTime, ResuspensionMixDutyCycle,
							ResuspensionMixRate, ResuspensionNumberOfMixes,
							ResuspensionMaxNumberOfMixes, ResuspensionMixVolume,
							ResuspensionMixTemperature, ResuspensionMixMaxTemperature,
							ResuspensionMixAmplitude
						}
					]
				];

				{
					Pellet[Append[First[resolvedPrimitive],Sample->expandedSource]],
					pelletTests,
					!MatchQ[pelletResult,$Failed]
				}
			]
		],
		pelletPrimitives
	];

	{resolvedPelletPrimitives,pelletTests,pelletOkBooleans}=If[MatchQ[pelletOutput,{}],
		{{},{},{}},
		Transpose[pelletOutput]
	];

	(* Put our resolved options back into the primitives *)
	manipulationsWithResolvedPellets=ReplacePart[
		specifiedManipulations,
		MapThread[Rule,{pelletPositions,resolvedPelletPrimitives}]
	];

	(* If user wants MicroLiquidHandling and we have any centrifuge primitives, we have to throw an error *)
	pelletLiquidHandlingScaleMismatch=!MatchQ[pelletPrimitives,{}]&&MatchQ[specifiedScale,MicroLiquidHandling];

	If[pelletLiquidHandlingScaleMismatch&&!gatherTests,
		Message[Error::PelletConflictsWithScale]
	];

	pelletScaleTest=If[gatherTests,
		Test["If MicroLiquidHandling is requested, ",pelletLiquidHandlingScaleMismatch,False]
	];

	If[!MatchQ[pelletOkBooleans,{True...}],
		Message[Error::InvalidPelletPrimitives,PickList[pelletPrimitives,pelletOkBooleans,False]]
	];


	(* -- Check State of Source Matches Amount -- *)

	stateMismatchManipulations=DeleteDuplicates@Flatten@Map[
		Function[{manipulation},
		Module[{sources,sourceSamples,amounts,sourceStates,resolvedSources},

			(* Extract source and amount info from the manipulation *)
			{sources,sourceSamples,amounts}=Switch[manipulation,
				_Transfer,{manipulation[Source],manipulation[SourceSample],manipulation[Amount]},
				_Aliquot,{manipulation[Source],manipulation[SourceSample],manipulation[Amounts]},
				_Consolidation,{manipulation[Sources],manipulation[SourceSamples],manipulation[Amounts]},
				_,{Null,Null,Null}
			];

			(* Early Return if we aren't dealing with a transfer type primitive *)
			If[MatchQ[sources,Null],Return[Nothing,Module]];

			(* Pull out the source object if we know it, the model otherwise *)
			resolvedSources = If[!MatchQ[sources,{}],
				MapThread[
					Function[{source,sourceSample},
						Which[
							(* If the source sample exists, extract it's model from its packet *)
							MatchQ[sourceSample,ObjectP[Object[Sample]]],sourceSample,
							(* If source is a model, take model directly *)
							MatchQ[source,ObjectP[Model[Sample]]],source,
							(* If source is a tagged model, take model *)
							And[
								MatchQ[source,_String],
								MatchQ[Lookup[definedNamesLookup,source][Sample],ObjectP[Model[Sample]]]
							],Lookup[definedNamesLookup,source][Sample],
							(* If source is a tagged model, take model *)
							MatchQ[source,{_,ObjectP[Model[Sample]]}],source[[2]],
							(* If SourceSample doesn't exist and source is not a model
							(ie: source is a model container), set to Null *)
							True,Null
						]
					],
					{sources,sourceSamples},
					2
				],
				{}
			];

			(* If we're transferring a liquid, Amount must be given as a volume *)
			(* note - can't restrict transferring solids by volume since you could be adding liquid in a previous manipulation *)
			MapThread[
				If[
					And[
						!MatchQ[#1,Null],
						MatchQ[Lookup[fetchPacketFromCacheHPLC[#1,allPackets],State],Liquid],
						!VolumeQ[#2]
					],
					manipulation,
					Nothing
				]&,
				{resolvedSources,amounts},
				2
			]
		]
		],
		manipulationsWithResolvedPellets
	];

	(* Print an error message about the bad manipulations*)
	If[Length[stateMismatchManipulations]!=0,
		Message[Error::TransferStateAmountMismatch,stateMismatchManipulations]
	];

	(* Track as a test *)
	stateMismatchTest=Test[
		"Any manipulations which direct liquid to be transferred must provide the amount as a volume.",
		Length[stateMismatchManipulations]==0,
		True
	];

	(* == Validate FillToVolume primitives (throw error when LiquidHandlingScale is Macro) == *)

	(* If we're throwing messages, and we have FillToVolume primitives while the scale was specified to MicroLiquidHandling, throw an error here *)
	fillToVolumeAndMicroMessage=Module[{primitiveIndices,invalidFillToVolumePrimitives},
		If[!gatherTests&&MemberQ[specifiedManipulations,_FillToVolume]&&MatchQ[specifiedScale,MicroLiquidHandling],
			primitiveIndices=Position[Head/@specifiedManipulations,FillToVolume];
			invalidFillToVolumePrimitives=Extract[specifiedManipulations,primitiveIndices];
			(Message[Error::InvalidOption,LiquidHandlingScale];Message[Error::FillToVolumeConflictsWithScale,Flatten[primitiveIndices],"FillToVolume"]);
		True,
		False
		]
	];

	(* If we are gathering tests, create tests (but only need those tests if we have a FillToVolume primitive *)
	fillToVolumeConflictsWithScaleTests=If[gatherTests&&MemberQ[specifiedManipulations,_FillToVolume],

	(* We're gathering tests. Create the appropriate tests. *)
		Module[{fillToVolumePrimitives,passingManips,passingIncubateManips,passingManipsTest,passingPrimitiveIndices,failingPrimitiveIndices,failingManipsTest},

		(* get the invalid primtiives. If the scale is specified to Micro they are all invalid, otherwise, they will all pass this test *)
			fillToVolumePrimitives=If[MatchQ[specifiedScale,MicroLiquidHandling],
				Cases[specifiedManipulations,_FillToVolume],
				{}
			];

			(* Get the FillToVolume primitives that pass this test. *)
			passingManips=Cases[Complement[specifiedManipulations,fillToVolumePrimitives],_FillToVolume];

			(* get the index of the failing and passing primitives *)
			passingPrimitiveIndices=Sort[Flatten[Position[specifiedManipulations,#]&/@passingManips]];
			failingPrimitiveIndices=Sort[Flatten[Position[specifiedManipulations,#]&/@fillToVolumePrimitives]];

			(* Create a test for the passing inputs. *)
			passingManipsTest=If[Length[passingManips]>0,
				Test["The FillToVolume manipulation primitive(s) at positions "<>ToString[passingPrimitiveIndices]<>" are compatible with the specified LiquidHandlingScale:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingManipsTest=If[Length[fillToVolumePrimitives]>0,
				Test["The FillToVolume manipulation primitive(s) at positions "<>ToString[failingPrimitiveIndices]<>", are compatible with the specified LiquidHandlingScale:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingManipsTest,
				failingManipsTest
			}
		],
	(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* -- Resolve Centrifuge Primitives -- *)

	(* Find positions of any centrifuge manipulations - and remove needless outer list returned by Position *)
	centrifugePositions = Sort@Join[
		First/@(Position[manipulationsWithResolvedPellets,_Centrifuge,{1}]),
		If[MatchQ[resolvedLiquidHandlingScale,MicroLiquidHandling],
			First/@(Position[
				manipulationsWithResolvedPellets,
				_Filter?(MatchQ[#[Intensity],Except[_Missing|Null]]&),
				{1}
			]),
			{}
		]
	];

	centrifugePrimitives = manipulationsWithResolvedPellets[[centrifugePositions]];
	
	resolveMicroCentrifugePrimitive[myPrimitive_,myPrimitiveIndex_]:=Module[
		{centrifugeAssociation,expandedSource,expandedSourceSample,expandedSourceLocation,expandedSourceContainers,
		precedingTransfers,simulatedPackets,resolvedDefinitions,resolvedSourceContainers,collectionContainer,
		collectionContainerModel,filterContainers,spinFilterContainerModels,compatibleSpinFilterModels,
		invalidSpinFilterContainerModels,spinFilterContainerCompatibilityTest,sourceContainerWeights,
		nearestCounterweightWeights,sourceCounterweightModels},
		
		centrifugeAssociation = First[myPrimitive];
		
		(* Get whatever the user specified, convert to a list if it's not already in that form *)
		expandedSource = If[
			MatchQ[Lookup[centrifugeAssociation,Sample],objectSpecificationP],
			{Lookup[centrifugeAssociation,Sample]},
			Lookup[centrifugeAssociation,Sample]
		];

		(* Get resolved source sample - this will only be populated if we know the specific object*)
		expandedSourceSample = Lookup[centrifugeAssociation,SourceSample];

		(* Get resolved location - this will only be populated if we know the specific object *)
		expandedSourceLocation = Lookup[centrifugeAssociation,ResolvedSourceLocation];

		(* Fetch any known containers or tagged model containers for sources *)
		expandedSourceContainers = MapThread[
			Function[{source,sourceLocation},
				Which[
				(* Tagged Model container *)
					MatchQ[source,{_Symbol|_String|_Integer,ObjectP[Model[Container]]}],
					source,
				(* Model tag with well *)
					MatchQ[source,{{_Symbol|_String|_Integer,ObjectP[Model[Container]]},_String}],
					source[[1]],
				(* Straight Model container *)
					MatchQ[source,ObjectP[Model[Container]]],
					source,
				(* If source location is a container or container and well, fetch its model from the cache *)
					MatchQ[sourceLocation,ObjectP[Object[Container]]],
					sourceLocation,
					MatchQ[sourceLocation,PlateAndWellP],
					sourceLocation[[1]],
				(* Tagged Model container *)
					MatchQ[source,_String],
					(* extract any subsequent definitions from the definedNamesLookup in case this is a sample *)
					If[
						!MatchQ[Lookup[definedNamesLookup, source][Sample], _Missing],
						Lookup[definedNamesLookup, source][Container],
						source
					],
					MatchQ[source,{_String,WellPositionP}],
					source[[1]],
					True,
					Nothing
				]
			],
			{expandedSource,expandedSourceLocation}
		];
		
		precedingTransfers = (Head[#][KeyDrop[
			First[#],
			{
				TransferType,
				ResolvedSourceLocation,
				ResolvedDestinationLocation,
				SourceSample,
				DestinationSample,
				ResolvedFilterLocation,
				ResolvedCollectionLocation
			}
		]])&/@Cases[manipulationsWithResolvedPellets[[;;(myPrimitiveIndex-1)]],(_Transfer|_Define|_Filter)];
		
		{simulatedPackets,resolvedDefinitions} = If[MatchQ[precedingTransfers,{}],
			{{},{}},
			simulateSampleManipulation[precedingTransfers,ParentProtocol->parentProtocol]
		];
		
		resolvedSourceContainers = Map[
			If[MatchQ[#,_String],
				Lookup[resolvedDefinitions,#],
				#
			]&,
			expandedSourceContainers
		];
		
		collectionContainer = If[MatchQ[myPrimitive,_Filter],
			myPrimitive[CollectionContainer],
			Null
		];
		
		filterContainers = DeleteDuplicates@If[MatchQ[myPrimitive,_Filter],
			Map[
				Switch[#,
					(* A defined sample reference *)
					_String,
						Which[
							(* If a defined reference is a sample, fetch its container *)
							MatchQ[Lookup[definedNamesLookup,#][Sample],ObjectP[Object[Sample]]],
								Download[Lookup[fetchPacketFromCacheHPLC[#,allPackets],Container],Object],
							(* If the defined reference points to a {container, well} pair, extract the container *)
							MatchQ[Lookup[definedNamesLookup,#][Sample],{ObjectP[],WellPositionP}],
								(Lookup[definedNamesLookup,#][Sample])[[1]],
							(* If reference is a {container, well} pair where the container is a reference, extract container *)
							MatchQ[Lookup[definedNamesLookup,#][Sample],{_String,WellPositionP}],
								(* If container reference is an object (not model) then fetch it *)
								If[MatchQ[Lookup[definedNamesLookup,Lookup[definedNamesLookup,#][Sample][[1]]][Container],ObjectP[Object[Container]]],
									Lookup[definedNamesLookup,Lookup[definedNamesLookup,#][Sample][[1]]][Container],
									Lookup[definedNamesLookup,#][Sample][[1]]
								],
							(* If reference is a container, extract it *)
							MatchQ[Lookup[definedNamesLookup,#][Container],_String],
								(* If container reference is a defined container object, extract the actual object *)
								If[MatchQ[Lookup[definedNamesLookup,Lookup[definedNamesLookup,#][Container]][Container],ObjectP[Object[Container]]],
									Lookup[definedNamesLookup,Lookup[definedNamesLookup,#][Container]][Container],
									Lookup[definedNamesLookup,#][Container]
								],
							True,
								Nothing
						],
					(* A location reference with defined container *)
					{_String,WellPositionP},
						If[MatchQ[Lookup[definedNamesLookup,#[[1]]][Container],ObjectP[Object[Container]]],
							Lookup[definedNamesLookup,Lookup[definedNamesLookup,#[[1]]]][Container],
							#[[1]]
						],
					{ObjectP[{Object[Container,Plate,Filter],Model[Container,Plate,Filter]}],WellPositionP},
						Download[#[[1]],Object],
					ObjectP[{Object[Container,Plate,Filter],Model[Container,Plate,Filter]}],
						Download[#,Object],
					(* Direct sample reference *)
					ObjectP[Object[Sample]],
						Download[Lookup[fetchPacketFromCacheHPLC[#,allPackets],Container],Object],
					_,
						Nothing
				]&,
				myPrimitive[Sample]
			],
			{}
		];
		
		(* Fetch any used filter container model objects *)
		spinFilterContainerModels = Map[
			Switch[#,
				ObjectP[Object[Container,Plate,Filter]],
					Download[Lookup[fetchPacketFromCacheHPLC[#,allPackets],Model],Object],
				ObjectP[Model[Container,Plate,Filter]],
					Download[#,Object],
				_String,
					If[MatchQ[Lookup[definedNamesLookup,#][Container],ObjectP[Object[Container]]],
						Download[Lookup[fetchPacketFromCacheHPLC[Lookup[definedNamesLookup,#][Container],allPackets],Model],Object],
						Download[Lookup[definedNamesLookup,#][Container],Object]
					],
				_,
					Nothing
			]&,
			filterContainers
		];
		
		compatibleSpinFilterModels = {
			(* "Zeba 7K 96-well Desalt Spin Plate" *)
			Model[Container, Plate, Filter, "id:M8n3rx0ZkwB5"],
			(* "Plate Filter, Omega 3K MWCO, 350uL" *)
			Model[Container, Plate, Filter, "id:4pO6dM53Nq4r"]
		};
		
		(* Extract any incompatible filter containers *)
		invalidSpinFilterContainerModels = Select[
			spinFilterContainerModels,
			(* We can filter out any non-filter plates since this will be caught by the error
			InvalidFilterSampleLocation *)
			And[
				MatchQ[#,ObjectP[Model[Container,Plate,Filter]]],
				!MemberQ[compatibleSpinFilterModels,#]
			]&
		];

		(* Build test for filter container compatibility *)
		spinFilterContainerCompatibilityTest = If[Length[invalidSpinFilterContainerModels] > 0,
			validMicroFiltersQ = False;
			If[gatherTests,
				Test["All Filter by Centrifuge primitives' filter container is supported:",True,False],
				Message[Error::IncompatibleSpinFilterContainer,invalidSpinFilterContainerModels,compatibleSpinFilterModels];
				Message[Error::InvalidInput,myPrimitive];
				Null
			],
			If[gatherTests,
				Test["All Filter by Centrifuge primitives' filter container is supported:",True,True],
				Null
			]
		];

		
		collectionContainerModel = Switch[collectionContainer,
			_String,
				fetchDefineModelContainer[Lookup[definedNamesLookup,collectionContainer],Cache->allPackets],
			ObjectP[Object[Container]],
				Download[Lookup[fetchPacketFromCacheHPLC[collectionContainer,allPackets],Model],Object],
			ObjectP[Model[Container]],
				Download[collectionContainer,Object],
			{_,ObjectP[Model[Container]]},
				Download[collectionContainer[[2]],Object],
			_,
				Null
		];
		
		sourceContainerWeights = Map[
			Function[container,
				Module[{simulatedSamplePacketsInContainer,existingSamplePacketsInContainer,samplePacketsInContainer,
				sampleVolumes,sampleMasses,containerModel,containerModelWeight,collectionContainerModelWeight},
					
					simulatedSamplePacketsInContainer = Cases[simulatedPackets,KeyValuePattern[{Container->LinkP[container]}]];
					
					existingSamplePacketsInContainer = Cases[allPackets,KeyValuePattern[{Container->LinkP[container]}]];
					
					(* DeleteDuplicatesBy keeps the first isntance. Simulated samples will have the most up to date volume. *)
					samplePacketsInContainer = DeleteDuplicatesBy[
						Join[simulatedSamplePacketsInContainer,existingSamplePacketsInContainer],
						Lookup[#,Position]&
					];
					
					sampleVolumes = Cases[samplePacketsInContainer[[All,Key[Volume]]],VolumeP];
					
					sampleMasses = (#*Quantity[0.997`, ("Grams")/("Milliliters")])&/@sampleVolumes;
					
					containerModel = Download[Lookup[fetchPacketFromCacheHPLC[container,Join[allPackets,simulatedPackets]],Model],Object];
					
					containerModelWeight = Lookup[fetchPacketFromCacheHPLC[containerModel,allPackets],TareWeight];
					
					collectionContainerModelWeight = If[!NullQ[collectionContainer],
						Lookup[fetchPacketFromCacheHPLC[collectionContainerModel,allPackets],TareWeight],
						0 Gram
					];
					
					Total[sampleMasses] + containerModelWeight + collectionContainerModelWeight
				]
			],
			resolvedSourceContainers
		];
		
		nearestCounterweightWeights = Map[
			First@Nearest[counterweightWeights,#]&,
			sourceContainerWeights
		];
		
		sourceCounterweightModels = Map[
			Function[weight,
				Lookup[SelectFirst[counterweightModelPackets,(Lookup[#,Weight]==weight)&],Object]
			],
			nearestCounterweightWeights
		];
		
		{
			Head[myPrimitive][
				Append[
					centrifugeAssociation,
					{
						Sample -> expandedSource,
						Counterweight -> sourceCounterweightModels
					}
				]
			],
			{spinFilterContainerCompatibilityTest},
			True
		}
	];

	resolveMacroCentrifugePrimitive[myPrimitive_,myPrimitiveIndex_]:=Module[
		{centrifugeAssociation,expandedSource,expandedSourceSample,expandedSourceLocation,expandedSourceContainers,centrifugeInput,
		simulatedCentrifugePackets,centrifugeSamplesByContainer,centrifugeContainers,centrifugeSamples,time,
		intensity,instrument,temperature,defaultTime,defaultTemperature,centrifugeOptions,centrifugeTests,expandedOptions,
		sourceSampleObjects,sourceContainerObjects,resolvedPrimitive,collectionContainer,counterbalanceWeight,simulatedCollectionContainer,
		expandedSpecifiedCollectionContainer,expandedSourceSampleRules},

		centrifugeAssociation=First[myPrimitive];

		(* Get whatever the user specified, convert to a list if it's not already in that form *)
		expandedSource=If[
			MatchQ[Lookup[centrifugeAssociation,Sample],objectSpecificationP],
			{Lookup[centrifugeAssociation,Sample]},
			Lookup[centrifugeAssociation,Sample]
		];

		(* Get resolved source sample - this will only be populated if we know the specific object*)
		expandedSourceSample=Lookup[centrifugeAssociation,SourceSample];

		(* Create source sample rules for replacement later on -- we'll need this in case someone decides to do something quackadoodle like specify a known object by name *)
		expandedSourceSampleRules=MapThread[If[MatchQ[#2,ObjectReferenceP[]],Rule[#1, #2],Nothing] &, {expandedSource, expandedSourceSample}];

		(* Get resolved location - this will only be populated if we know the specific object *)
		expandedSourceLocation=Lookup[centrifugeAssociation,ResolvedSourceLocation];

		(* Fetch any known containers or tagged model containers for sources *)
		expandedSourceContainers = MapThread[
			Function[{source,sourceLocation},
				Which[
				(* Tagged Model container *)
					MatchQ[source,{_Symbol|_String|_Integer,ObjectP[Model[Container]]}],
					source,
				(* Model tag with well *)
					MatchQ[source,{{_Symbol|_String|_Integer,ObjectP[Model[Container]]},_String}],
					source[[1]],
				(* Straight Model container *)
					MatchQ[source,ObjectP[Model[Container]]],
					source,
				(* If source location is a container or container and well, fetch its model from the cache *)
					MatchQ[sourceLocation,ObjectP[Object[Container]]],
					sourceLocation,
					MatchQ[sourceLocation,PlateAndWellP],
					sourceLocation[[1]],
				(* Tagged Model container *)
					MatchQ[source,_String],
					(* extract any subsequent definitions from the definedNamesLookup *)
					If[
						!MatchQ[Lookup[definedNamesLookup, source][Sample], _Missing],
						Lookup[definedNamesLookup, source][Container],
						source
					],
					MatchQ[source,{_String,WellPositionP}],
					source[[1]],
					True,
					Nothing
				]
			],
			{expandedSource,expandedSourceLocation}
		];

		(* If we aren't working with a list of sample objects, simulate samples *)
		simulatedCentrifugePackets=simulatePrimitiveInputFunction[expandedSource,expandedSourceLocation,expandedSourceSample];

		(* Assemble the centrifuge samples (using either the sources, or the simulated samples *)
		{centrifugeSamplesByContainer,centrifugeContainers}=If[!MatchQ[simulatedCentrifugePackets,{}],
			Transpose[simulatedCentrifugePackets],
			{{},{}}
		];

		centrifugeSamples=If[!MatchQ[centrifugeContainers,{}],
			Flatten[centrifugeSamplesByContainer,1],
			(* notably the source can be provided as Plate and Well, which would break the ExperimentCentrifuge call below - grab the plate *)
			(* we're loosing information here but that's OK, we'll always assume we centrifuge this one plate once and if the user gave us multiple samples at different parameters, we'll throw an error *)
			expandedSource /.Join[{{myPlate:(ObjectP[Object[Container, Plate]]), WellP} -> myPlate},expandedSourceSampleRules]
		];

		(* Get options specified for how to perform the centrifuge *)
		{time,intensity,instrument,temperature,collectionContainer,counterbalanceWeight}=Map[
			Lookup[centrifugeAssociation,#,Automatic]&,
			{Time,Intensity,Instrument,Temperature,CollectionContainer,CounterbalanceWeight}
		];

		(* ExperimentCentrifuge has default/times temps so we must also default them here (can't just use Automatic) *)
		defaultTime=If[MatchQ[time,Automatic],
			5 Minute,
			time
		];
		defaultTemperature=If[MatchQ[temperature,Automatic],
			Ambient,
			temperature
		];

		expandedSpecifiedCollectionContainer=If[MatchQ[collectionContainer,Except[{objectSpecificationP..}]],
			ConstantArray[collectionContainer, Length[centrifugeSamples]],
			collectionContainer
		];

		(* Extract any specified CollectionContainer Object or Model references if we have a defined CollectionContainer since ExperimentFilter doesn't handle strings as ContainerOut *)
		simulatedCollectionContainer = Map[
			Function[specifiedCollectionContainer,
				Switch[specifiedCollectionContainer,
					(* if it's missing, we put in automatic *)
					_Missing,
						Automatic,
					(* If it was specified as an object or model container, we take that *)
					ObjectP[],
						Download[specifiedCollectionContainer,Object],
					_String,
						(* If we have defined it via a string, look it up so we can pass it to ExperimentFilter *)
						(* TODO: have we covered all edge cases here? *)
						Lookup[definedNamesLookup,specifiedCollectionContainer][Container],
					_,
						Automatic
				]
			],
			expandedSpecifiedCollectionContainer
		];

		(* Call ExperimentCentrifuge to resolve our centrifuge options *)
		{centrifugeOptions,centrifugeTests}=If[gatherTests,
			Module[{options,tests},
				{options,tests}=ExperimentCentrifuge[
					centrifugeSamples,
					Time->defaultTime,
					Intensity->intensity,
					Instrument->instrument,
					Temperature->defaultTemperature,
					CollectionContainer->simulatedCollectionContainer,
					CounterbalanceWeight->counterbalanceWeight,
					Aliquot->False,
					EnableSamplePreparation->False,
					Cache->Flatten[simulatedCentrifugePackets],
					Output->{Options,Tests},
					OptionsResolverOnly -> True
				];
				If[RunUnitTest[<|"Tests"->tests|>,OutputFormat->SingleBoolean,Verbose->False],
					{options,tests},
					{$Failed,tests}
				]
			],
			{
				Quiet[
					Check[
						ExperimentCentrifuge[
							centrifugeSamples,
							Time->defaultTime,
							Intensity->intensity,
							Instrument->instrument,
							Temperature->defaultTemperature,
							CollectionContainer->simulatedCollectionContainer,
							CounterbalanceWeight->counterbalanceWeight,
							Aliquot->False,
							EnableSamplePreparation->False,
							Cache->Flatten[simulatedCentrifugePackets],
							Output->Options,
							OptionsResolverOnly -> True
						],
						$Failed,
						(* If the container won't fit in the centrifuge we want to throw our own message *)
						{Error::InvalidInput,Error::InvalidOption,Warning::ContainerCentrifugeIncompatible,Error::AliquotOptionConflict,Error::NoTransferContainerFound}
					],
					(* Quiet these messages since we're making our own *)
					{Error::InvalidInput,Error::InvalidOption,Warning::ContainerCentrifugeIncompatible,Error::AliquotOptionConflict,Error::NoTransferContainerFound}
				],
				{}
			}
		];

		(* we map over the samples (simulated or not) and convert plates and containers into samples if needed, constructed a nested list lik {{s1,s2},{s3},...} *)
		(* we can't just use SourceSample since that does not contain the simulated samples *)
		sourceSampleObjects=Map[Function[{sample},
			Switch[sample,
			(* if we're dealing with a plate we take all samples *)
				ObjectReferenceP[Object[Container,Plate]],
				Lookup[#,Object]&/@Select[allPackets,MatchQ[sample,Download[Lookup[#,Container],Object]]&],
			(* if we're dealing with a container we assume it contains only one sample *)
				ObjectReferenceP[Object[Container,Vessel]],
				{Lookup[SelectFirst[allPackets,MatchQ[sample,Download[Lookup[#,Container],Object]]&,Null],Object]},
			(* if it's a sample already we can simply keep that *)
				ObjectReferenceP[Object[Sample]],
				{sample},
				PacketP[Object[Sample]],
			(* if it's a packet we're dealing with a simulated sample, grab the object ID *)
				{Lookup[sample,Object]},
			(* catch all *)
				_,
				{sample}
			]],
			centrifugeSamples
		];

		sourceContainerObjects=Switch[{expandedSourceContainers,centrifugeContainers},
		(* we are not simulating, we simply grab the source containers list *)
			{{ObjectP[Object[Container]]..},{}},
			expandedSourceContainers,
		(* if we're simulating, grab the containers from the simulation packet *)
			{{_String..},{_?AssociationQ..}},
			Lookup[centrifugeContainers,Object],
		(* catch all just in case *)
			_,
			expandedSourceContainers
		];

		(* Importantly: ExperimentCentrifuge will always turn containers into samples *)
		(* This means options that were specified to different values per container, are not indexmatched to the Sample key anymore, since that can contain plates, but to the actual samples inside the containers *)
		(* Some options are collapsed to singletons, if all samples want the same parameter *)
		(* To construct the primitives below, we expand all indexmatched options to containers, and not samples, using our special helper *)
		expandedOptions=If[!MatchQ[centrifugeOptions,$Failed],
			collapseMacroOptionsToContainers[ExperimentCentrifuge, sourceSampleObjects,sourceContainerObjects, centrifugeOptions],
			$Failed
		];

		(* since some options will be collapsed in this output, make sure we expand them all *)
		(* expandedOptions=If[!MatchQ[centrifugeOptions,$Failed],
			ExpandIndexMatchedInputs[ExperimentCentrifuge,{centrifugeSamples},centrifugeOptions][[2]],
			$Failed
		]; *)

		(* Update our primitive with our newly resolved options *)
		resolvedPrimitive=If[MatchQ[expandedOptions,$Failed],
			myPrimitive,
			Centrifuge[
				Append[
					centrifugeAssociation,
					{
						Time->Lookup[expandedOptions,Time],
						Intensity->Lookup[expandedOptions,Intensity],
						Instrument->Lookup[expandedOptions,Instrument],
						Temperature->Lookup[expandedOptions,Temperature],
						(* If the user specified something, go with that. Otherwise, use the resolved value. *)
						(* This is because we swap out the containers that we use with the model to pass to the resolver. *)
						CollectionContainer->If[MatchQ[expandedSpecifiedCollectionContainer, {Automatic..}],
							Lookup[expandedOptions,CollectionContainer],
							expandedSpecifiedCollectionContainer
						]
								(* CounterbalanceWeight doesn't get resolved and is a hidden key so won't show up in returned options *)
					}
				]
			]
		];

		{
			Centrifuge[Append[First[resolvedPrimitive],Sample->expandedSource]],
			centrifugeTests,
			!MatchQ[centrifugeOptions,$Failed]
		}
	];
	
	(* - Simulate the samples we're going to create - *)
	centrifugeOutput = MapThread[
		If[MatchQ[resolvedLiquidHandlingScale,MicroLiquidHandling],
			resolveMicroCentrifugePrimitive[#1,#2],
			resolveMacroCentrifugePrimitive[#1,#2]
		]&,
		{centrifugePrimitives,centrifugePositions}
	];

	{resolvedCentrifugePrimitives,centrifugeTests,centrifugeOkBooleans}=If[MatchQ[centrifugeOutput,{}],
		{{},{},{}},
		Transpose[centrifugeOutput]
	];
	
	invalidCentrifugePrimitives = PickList[centrifugePrimitives,centrifugeOkBooleans,False];
	
	invalidCentrifugePrimitivesTest = If[Length[invalidCentrifugePrimitives]>0,
		If[gatherTests,
			Test["It is not possible to perform the all specified centrifuges:",True,False],
			Message[Error::InvalidCentrifugePrimitives,invalidCentrifugePrimitives];
			Message[Error::InvalidInput,invalidCentrifugePrimitives];
			Null
		],
		If[gatherTests,
			Test["It is not possible to perform the all specified centrifuges:",True,True],
			Null
		]
	];

	(* Put our resolved options back into the primitives *)
	manipulationsWithResolvedCentrifuges=ReplacePart[
		manipulationsWithResolvedPellets,
		MapThread[Rule,{centrifugePositions,resolvedCentrifugePrimitives}]
	];


	(* --- Check for overflowing wells/aspirations of zero volume --- *)
	(* Only check if there's no parent - assume other protocols calling SM know what they're doing
		if you don't care, skip to variable name resolvedLiquidHandlingScale
		FAT HACK: catch the OverfilledWell error to see if result should be $Failed; And even worse hack, append to for tests *)
	overfilledDrainedTests = {};
	overfilledCheckTripped = Check[If[!(FastTrack/.safeOptions),
		Module[{initialLocationVolumeLookup,storageBufferInitialLookup,maxContainerVolumeLookup},

			(* to do this check, we need a running tally lookup for every location as we step through the manipulations;
         locations will only start with volume if there's a sample there (best we know);
        so just create initial entries for these locations. Assumes one sample per location *)
			initialLocationVolumeLookup = <|Map[
				Module[{container,volume,well},

					(* Get the sample's container, well, and volume *)
					{container,volume,well} = Lookup[#,{Container,Volume,Position}];

					(* create an entry for the container with the sample's current volume;
					 	use {plate,well} for a plate but jsut the container otherwise *)
					If[MatchQ[volume,VolumeP],
						If[MatchQ[container,ObjectP[Object[Container,Plate]]],
							{Download[container,Object],well}->volume,
							Download[container,Object]->volume
						],
						Nothing
					]
				]&,
				uniqueSamplePackets
			]|>;
			
			(* Do all sorts of crazy shit to account for the fact that some model plates could come with
			a pre-set amount of storage buffer. Create a lookup here that maps references to locations in these
			containers to their initial storage buffer.  *)
			storageBufferInitialLookup = Join@@Map[
				Function[modelContainer,
					Module[{packet},
						packet = fetchPacketFromCacheHPLC[modelContainer,allPackets];
						
						If[!NullQ[Lookup[packet,StorageBufferVolume]],
							If[MatchQ[modelContainer,ObjectP[Model[Container,Plate]]],
								Module[
									{positions,taggedReferences,namedReferences,allReferences},
								
									positions = Lookup[packet,Positions][[All,Key[Name]]];
								
									taggedReferences = DeleteDuplicates[
										DeleteCases[
											Cases[
												manipulationsWithResolvedCentrifuges,
												{_Symbol|_Integer,ObjectP[modelContainer]},
												Infinity
											],
											(* comically, in Filter Macro, we can have {Null, syringe container} in the Syringe key, if filtering with two different filtration types, so need to delete those from this list *)
											{Null,ObjectReferenceP[Model[Container]]}
										]
									];
									
									namedReferences = KeyValueMap[
										If[MatchQ[#2[Container],ObjectP[modelContainer]],
											#1,
											Nothing
										]&,
										definedNamesLookup
									];
									
									allReferences = Append[Join[taggedReferences,namedReferences],modelContainer];
									
									Join@@Map[
										Function[reference,
											Map[
												({reference,#} -> Lookup[packet,StorageBufferVolume])&,
												positions
											]
										],
										allReferences
									]
								],
								{Download[modelContainer,Object] -> Lookup[packet,StorageBufferVolume]}
							],
							{}
						]
					]
				],
				modelContainers
			];
			
			AppendTo[initialLocationVolumeLookup,storageBufferInitialLookup];

			(* we also want a lookup that tells us the max volume that all of the containers can hold;
			 	this is how we will tell if we overfilled. Also do this for tagged container Models that were directly
				provided, since some of these may be sources/destinations *)
			maxContainerVolumeLookup = Quiet[<|
				Join[
					Map[
						Module[{containerModel,containerModelPacket},

							(* get the container's model, and find the packet for the container model *)
							containerModel = Download[Lookup[fetchPacketFromCacheHPLC[#,allPackets],Model],Object];
							containerModelPacket = fetchPacketFromCacheHPLC[containerModel,allPackets];

							(* create an entry for the container with the MaxVolume of its model *)
							Lookup[#,Object]->Lookup[containerModelPacket,MaxVolume]
						]&,
						Cases[allPackets,ObjectP[Object[Container]]]
					],
					Lookup[#,Object]->Lookup[#,MaxVolume]&/@Cases[allPackets,ObjectP[Model[Container]]]
				]
			|>];

			(* Now step through the manipulations one at a time - Fold is the choice here - and keep a running tally of
			 	how much liquid is expected to be in each location; throw a message each time we find that we've removed too much from a container/location, or added too much

				Temporarily quiet repeated message suppression since we may yell a lot *)
			Quiet[
				Fold[
					Function[{currentLocationVolumeLookup,currentManipulationIndexTuple},
						Module[
							{currentManipulation,index,locationAmountSourceTuples,currentManipulationWithdrawals,emptyCurrentLocationQ,singleEmptyWellTest,postWithdrawalLocationVolumeLookup,
								locationAmountDestinationTuples,currentManipulationAdditions,postAdditionLocationVolumeLookup},

							(* separate the current manip and index *)
							{currentManipulation,index} = {
								currentManipulationIndexTuple[[1]],
								expandedRawManipulationPositions[[currentManipulationIndexTuple[[2]]]]
							};

							(* assemble tuples with the direct source, source location (if present), and amount drawn from each source in the manip *)
							locationAmountSourceTuples = Switch[currentManipulation,
								_Transfer,
									Join@@MapThread[
										Transpose[{#1,#2,#3}]&,
										{currentManipulation[ResolvedSourceLocation],currentManipulation[Amount],currentManipulation[Source]}
									],
								_Mix,
									Transpose[{
										currentManipulation[ResolvedSourceLocation],
										currentManipulation[MixVolume],
										currentManipulation[Sample]
									}],
								(*FillToVolume volume doesn't count towards the total since it is the total*)
								_FillToVolume,
									{{currentManipulation[ResolvedSourceLocation],Null,currentManipulation[Source]}},
								(* Incubate/Centrifuge has no volume to count toward the tally *)
								_Incubate,
									{{currentManipulation[ResolvedSourceLocation],Null,currentManipulation[Sample]}},
								(* Centrifuge doesn't count toward the tally if there is no CollectionContainer option. *)
								_Centrifuge,
									MapThread[
										(If[!MatchQ[#2, objectSpecificationP],
											(* No collection occurring. *)
											{#1,Null,#3},
											(* Collection occurring. *)
											{
												#1,
												If[MatchQ[#1, Null],
													Lookup[currentLocationVolumeLookup,Key[#3],Null],
													Lookup[currentLocationVolumeLookup,Key[#1],Null]
												],
												#3
											}
										]&),
										{
											currentManipulation[ResolvedSourceLocation],
											If[MatchQ[currentManipulation[CollectionContainer], _Missing|{Null..}],
												ConstantArray[Null, Length[currentManipulation[ResolvedSourceLocation]]],
												currentManipulation[CollectionContainer]
											],
											currentManipulation[Sample]
										}
									],
								(* Pelleting pulls off the supernatant and can also resuspend. *)
								_Pellet,
									Join[
										MapThread[
											({
												#1,
												(* We have to convert All into a volume here. *)
												If[MatchQ[#2, VolumeP],
													#2,
													If[MatchQ[#1, Null],
														Lookup[currentLocationVolumeLookup,Key[#3],Null],
														Lookup[currentLocationVolumeLookup,Key[#1],Null]
													]
												],
												#3
											}&),
											{
												currentManipulation[ResolvedSourceLocation],
												currentManipulation[SupernatantVolume],
												currentManipulation[Sample]
											}
										],
										MapThread[
											(* We may not be resuspending. *)
											(If[MatchQ[#3, Null],
												Nothing,
												{
													#1,
													(* We have to convert All into a volume here. *)
													If[MatchQ[#2, VolumeP],
														#2,
														If[MatchQ[#1, Null],
															Lookup[currentLocationVolumeLookup,Key[#3],Null],
															Lookup[currentLocationVolumeLookup,Key[#1],Null]
														]
													],
													#3
												}
											]&),
											{
												currentManipulation[ResolvedResuspensionSourceLocation],
												currentManipulation[ResuspensionVolume],
												currentManipulation[ResuspensionSource]
											}
										]
									],
								_Filter,
									MapThread[
										{
											#1,
											If[!NullQ[#1],
												Lookup[currentLocationVolumeLookup,Key[#1],Null],
												Lookup[currentLocationVolumeLookup,Key[#2],Null]
											],
											#2
										}&,
										{currentManipulation[ResolvedSourceLocation],currentManipulation[Sample]}
									],
								(* MoveToMagnet/RemoveFromMagnet has no volume to count toward the tally *)
								_MoveToMagnet|_RemoveFromMagnet,
									{{currentManipulation[ResolvedSourceLocation],Null,currentManipulation[Sample]}},
								_,
									{{Null,Null,Null}}
							];

							(* process the tuples into an association that can be merged with the existing amounts;
							  	use the resolved source location if we have it, but if not, means we're pulling from a model container (tagged)
								or even just a sample model. Keep the tagged model containers, but we can't overdraw from a sample model, so ignore these;
								we also want to ignore masses or counts *)
							currentManipulationWithdrawals = Merge[
								Map[
									Which[
										!VolumeQ[#[[2]]],
											Nothing,
										!NullQ[#[[1]]],
											#[[1]]->(-#[[2]]),
										(* If direct model container or tagged value *)
										MatchQ[#[[3]],{ObjectP[Model[Container,Plate]]|_String,WellPositionP}|FluidContainerModelP|modelPlateP|modelVesselP],
											#[[3]]->(-#[[2]]),
										(* If a defined model container *)
										And[
											MatchQ[#[[3]],_String],
											!MatchQ[Lookup[definedNamesLookup,#[[3]]][Sample],ObjectP[Model[Sample]]],
											Or[
												MatchQ[Lookup[definedNamesLookup,#[[3]]][Sample],{ObjectP[Model[Container,Plate]],WellPositionP}],
												MatchQ[Lookup[definedNamesLookup,#[[3]]][Container],FluidContainerModelP],
												MatchQ[Lookup[definedNamesLookup,#[[3]]][Sample],ObjectP[Model[Container,Vessel]]]
											]
										],
											#[[3]]->(-#[[2]]),
										True,
											Nothing
									]&,
									locationAmountSourceTuples
								],
								Total
							];

							(* Return early if we do not have volume for this source in the currentLocationVolumeLookup. That means we were given an empty container *)
							emptyCurrentLocationQ=Not[
								And@@Map[
									KeyExistsQ[currentLocationVolumeLookup,#]&,
									Keys[currentManipulationWithdrawals]
								]
							];

							(* make a warning *)
							singleEmptyWellTest=If[gatherTests,
								Test[
									StringJoin[
										"Manipulation at position ",ToString[index],
										" has a non-empty source container."
									],
									emptyCurrentLocationQ,
									False
								],
								Nothing
							];

							(* add the test to our list *)
							AppendTo[overfilledDrainedTests,singleEmptyWellTest];

							If[!gatherTests&&emptyCurrentLocationQ,
								Message[Error::EmptySourceContainer,currentManipulation];
								Message[Error::InvalidInput,currentManipulation]
							];

							(* merge the current manipulations withdrawals with the current log of volumes in locations;
							 	Merge with Total will add together amounts that have same key (same location), and otherwise create new entries *)
							postWithdrawalLocationVolumeLookup = Merge[{currentLocationVolumeLookup,currentManipulationWithdrawals},Total];

							(* see if after applying this manipulation's actions, we have aspirated too much from a location (it will have a negative
								volume in the new lookup). Throw a warning if so. Add a little buffer so we don't complain about very slight negatives;
								only consider key/values that have changed this time around

								Only do this for root protocols because we assume parents know what they're doing *)
							If[MatchQ[parentProtocol,Null],
								KeyValueMap[
									Function[{location,volume},
										Module[{overdrawn,warning},

											(* determine if we are overdrawing at this point *)
											overdrawn=volume<(-10 Microliter);

											(* make a warning *)
											warning=If[gatherTests,
												Warning[
													StringJoin[
														"Manipulation location ",ToString[location],
														" will have enough volume (",
														ToString[UnitForm[volume,Brackets->False]],
														") to satisfy the manipulation amount(s) at index ",
														ToString[index],": ",
														ToString[UnitForm[#,Brackets->False]]&/@ToList[Switch[currentManipulation,
															_Transfer|_FillToVolume,currentManipulation[Amount],
															_Consolidation|_Aliquot,currentManipulation[Amounts],
															_Mix,currentManipulation[MixVolume]
														]]
													],
													overdrawn,
													False
												],
												Nothing
											];

											(* make a message *)
											If[!gatherTests&&overdrawn&&warningsBoolean&&!emptyCurrentLocationQ,
												Message[Warning::DrainedWell,currentManipulation,location,UnitScale[Abs[volume]]]
											];

											(* append the test (Nothing works) *)
											AppendTo[overfilledDrainedTests,warning]
										]
									],
									<|KeyValueMap[
										Function[{location,volume},
											If[SameQ[currentLocationVolumeLookup[location],volume],
												Nothing,
												location->volume
											]
										],
										postWithdrawalLocationVolumeLookup
									]|>
								]
							];

							(* now, assemble the dispenses that will happen on the back side of the current manipulation;
							 	create tuples with the destination location, amount, and destination raw in case it's a model  *)
							locationAmountDestinationTuples = Switch[currentManipulation,
								_Transfer,
									Join@@MapThread[
										Transpose[{#1,#2,#3}]&,
										{currentManipulation[ResolvedDestinationLocation],currentManipulation[Amount],currentManipulation[Destination]}
									],
								_Mix,
									Transpose[{
										currentManipulation[ResolvedSourceLocation],
										currentManipulation[MixVolume],
										currentManipulation[Sample]
									}],
								(*FillToVolume volume doesn't count towards the total since it is the total*)
								_FillToVolume,
									{{currentManipulation[ResolvedDestinationLocation],Null,currentManipulation[Destination]}},
								(* Incubate/Centrifuge has no volume to count toward the tally *)
								_Incubate|_Centrifuge,
									{{currentManipulation[ResolvedSourceLocation],Null,currentManipulation[Sample]}},
								(* Pelleting pulls off the supernatant and can also resuspend. *)
								_Pellet,
									Join[
										MapThread[
											(If[MatchQ[#3, Waste],
												Nothing,
												{
													#1,
													(* We have to convert All into a volume here. *)
													If[MatchQ[#2, VolumeP],
														#2,
														If[MatchQ[#4, Null],
															Lookup[currentLocationVolumeLookup,Key[#5],Null],
															Lookup[currentLocationVolumeLookup,Key[#4],Null]
														]
													],
													#3
												}
											]&),
											{
												currentManipulation[ResolvedSupernatantDestinationLocation],
												currentManipulation[SupernatantVolume],
												currentManipulation[SupernatantDestination],
												currentManipulation[ResolvedSourceLocation],
												currentManipulation[Sample]
											}
										],
										MapThread[
											(* We may not be resuspending. *)
											(If[MatchQ[#2, Null],
												Nothing,
												{
													#1,
													(* We have to convert All into a volume here. *)
													If[MatchQ[#2, VolumeP],
														#2,
														If[MatchQ[#4, Null],
															Lookup[currentLocationVolumeLookup,Key[#5],Null],
															Lookup[currentLocationVolumeLookup,Key[#4],Null]
														]
													],
													#3
												}
											]&),
										{
											currentManipulation[ResolvedSourceLocation],
											currentManipulation[ResuspensionVolume],
											currentManipulation[Sample],
											currentManipulation[ResolvedResuspensionSourceLocation],
											currentManipulation[ResuspensionSource]
										}
									]
								],
								_Filter,
									MapThread[
										Which[
											(* First, we hope that we have a legit location for the source sample to get a volume. *)
											MatchQ[#1,{_,WellPositionP}],
											{
												{currentManipulation[CollectionContainer],#1[[2]]},
												Lookup[currentLocationVolumeLookup,Key[#1],Null],
												{currentManipulation[CollectionContainer],#1[[2]]}
											},
											MatchQ[#2,{_,WellPositionP}],
											{
												{currentManipulation[CollectionContainer],#2[[2]]},
												Lookup[currentLocationVolumeLookup,Key[#2],Null],
												{currentManipulation[CollectionContainer],#2[[2]]}
											},
											(* If not, then try to get the volume of the sample from the define lookup. *)
											(* TODO: It's not entirely clear what format that the locationAmountDestinationTuples lookup wants things in. *)
											(* This is kind of fucked and should be rewritten. *)
											And[
												MatchQ[#2,_String],
												!MatchQ[Lookup[definedNamesLookup,#2][Sample],ObjectP[Model[Sample]]],
												MatchQ[Lookup[definedNamesLookup,#2][Sample],{ObjectP[Model[Container,Plate]],WellPositionP}]
											],
											{
												FirstOrDefault[currentManipulation[CollectionContainer], currentManipulation[CollectionContainer]],
												Lookup[currentLocationVolumeLookup,Lookup[definedNamesLookup,#2][Sample],Null],
												FirstOrDefault[currentManipulation[CollectionContainer], currentManipulation[CollectionContainer]]
											},
											And[
												MatchQ[#2,_String],
												!MatchQ[Lookup[definedNamesLookup,#2][Sample],ObjectP[Model[Sample]]],
												MatchQ[Lookup[definedNamesLookup,#2][Container],ObjectP[Object[Container, Vessel]]]
											],
											{
												FirstOrDefault[currentManipulation[CollectionContainer], currentManipulation[CollectionContainer]],
												Lookup[currentLocationVolumeLookup,Lookup[definedNamesLookup,#2][Container],Null],
												FirstOrDefault[currentManipulation[CollectionContainer], currentManipulation[CollectionContainer]]
											},
											True,
											Nothing
										]&,
										{currentManipulation[ResolvedSourceLocation],currentManipulation[Sample]}
									],
								(* MoveToMagnet/RemoveFromMagnet has no volume to count toward the tally *)
								_MoveToMagnet|_RemoveFromMagnet,
									{{currentManipulation[ResolvedSourceLocation],Null,currentManipulation[Sample]}},
								_,
									{{Null,Null,Null}}
							];

							(* process the tuples into an association that can be merged with the existing amounts;
							  	use the resolved destination location if we have it, but if not, means we're adding to a model container (tagged);
								we also want to ignore masses *)
							(* TODO: Convert All here (for pellet) into a volume. *)
							currentManipulationAdditions = Merge[
								Map[
									Which[
										!VolumeQ[#[[2]]],Nothing,
										!NullQ[#[[1]]],#[[1]]->#[[2]],
										True,#[[3]]->#[[2]]
									]&,
									locationAmountDestinationTuples
								],
								Total
							];

							(* merge the current post-withdrawal location volumes with the additions the new manipulation is making;
							 	Merge with Total will add together amounts that have same key (same location), and otherwise create new entries *)
							postAdditionLocationVolumeLookup = Merge[{postWithdrawalLocationVolumeLookup,currentManipulationAdditions},Total];
							(* see if after applying this manipulation's actions, we have added too much to a location.
							 	Throw a message if so (only if this manipulation has changed the values) *)
							KeyValueMap[
								Function[{location,volume},
									Module[{containerObject,maxVolume,overfilled,test},

										(* figure out what the max amount in this container is by using the max amount lookup;
                       the location may be tagged, so make sure to use just the object;
                      assumes all model containers are tagged *)
										containerObject = Switch[location,
											ObjectReferenceP[{Object[Container],Model[Container]}],
											location,
											{ObjectReferenceP[Object[Container,Plate]],_String},
											location[[1]],
											_String,
											With[{definedPrimitive=Lookup[definedNamesLookup,location]},
												fetchDefineModelContainer[definedPrimitive,DefineLookup->definedNamesLookup,Cache->allPackets]
											],
											{_String,_String},
											Lookup[definedNamesLookup,location[[1]]][Container],
											{_Symbol|_Integer,ObjectReferenceP[Model[Container]]},location[[2]],
											{{_Symbol|_Integer,ObjectReferenceP[Model[Container,Plate]]},_String},location[[1,2]]
										];

										(* lookup the max volume of this container object *)
										maxVolume = Lookup[maxContainerVolumeLookup,Download[containerObject,Object]];

										(* determine if we're overfilled *)
										overfilled=And[
											MatchQ[volume, GreaterP[(1.05*maxVolume)]],
											!MatchQ[parentProtocol, ObjectP[Object[Protocol, StockSolution]]]
										];

										(* make a warning *)
										test=If[gatherTests,
											Test[
												StringJoin[
													"Manipulation location ",ToString[location],
													" total volume after completion of manipulation at index ",
													ToString[index]," will not exceed the max volume of the destination (",
													ToString[UnitForm[maxVolume,Brackets->False]],")."
												],
												overfilled,
												False
											],
											Nothing
										];

										(* add the test to our list *)
										AppendTo[overfilledDrainedTests,test];

										(* if we're over a certain threshold above the max volume of the container, throw a message *)
										(* Use TrueQ in case maxVolume is Null *)
										If[!gatherTests&&overfilled,
											Message[Error::OverfilledWell,currentManipulation,location,UnitScale[volume],UnitScale[maxVolume]];
											Message[Error::InvalidInput,currentManipulation]
										]
									]
								],
								<|KeyValueMap[
									Function[{location,volume},
										If[SameQ[postWithdrawalLocationVolumeLookup[location],volume],
											Nothing,
											location->volume
										]
									],
									postAdditionLocationVolumeLookup
								]|>
							];

							(* return the most up-to-date location volume lookup for the next round of checks *)
							postAdditionLocationVolumeLookup
						]
					],
					initialLocationVolumeLookup,
					(* so tests can ref index *)
					Transpose[{manipulationsWithResolvedCentrifuges,Range[Length[manipulationsWithResolvedCentrifuges]]}]
				],
				General::stop
			];
		]
	],True, {Error::EmptySourceContainer,Error::OverfilledWell}];


	(* == Resolve and validate ReadPlate primitives === *)

	Options[resolveReadPlateFunction]:={PlateReader->Automatic,OverwriteSolidSample->False};
	resolveReadPlateFunction[myPrimitive_,myPrimitiveIndex_,OptionsPattern[]]:=Module[
		{readPlateAssociation,validReadPlateScaleQ,readPlateScaleTest,validReadPlateSampleSpecificationQ,readPlateSampleTest,expandedSource,
		expandedSourceLocation,expandedBlank,expandedBlankLocation,expandedSourceSample,expandedBlankSample,
		readPlateAdjustmentSample,expandedAdjustmentSampleLocation,expandedAdjustmentSampleObject,specifiedAdjustmentSample,
		allSimulatedReadPlatePackets,simulatedReadPlateSamplesByContainer,simulatedReadPlateContainers,validReadPlatePlateCountQ,
		readPlatePlateCountTest,allSimulatedReadPlateSamplePackets,readPlateSamples,readPlateBlanks,kineticsBool,fluorBool,
		fluorSpecBool,absBool,readPlateType,experimentFunction,experimentFunctionOptionNames,primitiveOptions,preResolved,
		unresolvedOptions,unresolvedOptionsQ,unresolvedOptionsTest,readPlateOptions,
		readPlateExperimentTests,readPlateTests,expandedOptions,replacedOptions,primitiveID,
		resolvedPrimitive,validReadPlateQ,resolvedPlateReader,liquidSampleOverwriteCache,updatedCache,
			previousPotentialTransfers, positionsWithSamplesInPlate, emptyWells, readPlatePlateEmptyWellsTest, readPlatePlateEmptyWellsQ},

		readPlateAssociation = First[myPrimitive];

		(* First check that we are doing ReadPlate only in Micro, not Macro *)
		validReadPlateScaleQ=MatchQ[resolvedLiquidHandlingScale,MicroLiquidHandling];

		readPlateScaleTest = If[!validReadPlateScaleQ,
			(
				If[messagesBoolean,
					(
						Message[Error::InvalidReadPlateScale];
						Message[Error::InvalidInput,myPrimitive];
						Null
					),
					testOrNull["The ReadPlate primitives are only allowed under MicroLiquidHandling scale:",False]
				]
			),
			testOrNull["The ReadPlate primitives are only allowed under MicroLiquidHandling scale:",True]
		];


		(* Don't allow specification of only a plate *)
		validReadPlateSampleSpecificationQ = Switch[Lookup[readPlateAssociation,Sample],
			_String,
				If[
					And[
						!MatchQ[Lookup[definedNamesLookup,Lookup[readPlateAssociation,Sample]][Sample],ObjectP[Model[Sample]]],
						MatchQ[Lookup[definedNamesLookup,Lookup[readPlateAssociation,Sample]][Container],ObjectP[Model[Container,Plate]]]
					],
					False,
					True
				],
			ObjectP[{Model[Container,Plate],Object[Container,Plate]}],
				False,
			_,
				True
		];

		readPlateSampleTest = If[!validReadPlateSampleSpecificationQ,
			(
				If[messagesBoolean,
					(
						Message[Error::InvalidReadPlateSample,myPrimitive];
						Message[Error::InvalidInput,myPrimitive];
						Null
					),
					testOrNull[StringTemplate["The ReadPlate primitive at index `1` specifies a sample or well position in a plate:"][myPrimitiveIndex],False]
				]
			),
			testOrNull[StringTemplate["The ReadPlate primitive at index `1` specifies a sample or well position in a plate:"][myPrimitiveIndex],True]
		];

		(* if we were given a single sample, get it into a list *)
		expandedSource = If[
			MatchQ[Lookup[readPlateAssociation,Sample],objectSpecificationP],
			{Lookup[readPlateAssociation,Sample]},
			Lookup[readPlateAssociation,Sample]
		];

		(* Get resolved location - this will only be populated if we know the specific object *)
		expandedSourceLocation = Lookup[readPlateAssociation,ResolvedSourceLocation];

		(* if we were given a single sample, get it into a list *)
		expandedBlank = If[
			MatchQ[Lookup[readPlateAssociation,Blank],objectSpecificationP],
			{Lookup[readPlateAssociation,Blank]},
			Lookup[readPlateAssociation,Blank]
		];

		(* Get resolved location - this will only be populated if we know the specific object *)
		expandedBlankLocation = Lookup[readPlateAssociation,ResolvedBlankLocation];

		(* Get resolved source sample - this will only be populated if we know the specific object*)
		expandedSourceSample=Lookup[readPlateAssociation,SourceSample];
		expandedBlankSample=Lookup[readPlateAssociation,SourceSample];

		expandedAdjustmentSampleObject=Lookup[readPlateAssociation,ResolvedAdjustmentSample];
		expandedAdjustmentSampleLocation=Lookup[readPlateAssociation,ResolvedAdjustmentSampleLocation];


		(* if we are asking to read Object[Sample], we are fine - we will not pull anything from the simulated samples *)
		(* if we are giving Samples as {Container, Well} we have to check for:
			if there are Samples in those wells already
			if we have transferred/aliquotted into them prior to this manipulation index
		 *)
		previousPotentialTransfers = Cases[manipulationsWithResolvedCentrifuges[[1;;FirstOrDefault[{myPrimitiveIndex},0]]],_Transfer|_Aliquot,{1}];

		positionsWithSamplesInPlate = If[MatchQ[previousPotentialTransfers,{}],
			(* we did not transfer anything into the plate, so all samples have to be in it already.
			Depending on how samples are specified we need to ignore/check positions differently *)

			Module[{},Map[Function[{source},Which[
				(* we are using trickery here - because we will not have Samples in different plates and plates + samples
				in a different plate specified we can get away with grabbing only the first result using Return[, Module] *)

				(* we were given a sample in a plate *)
				MatchQ[source, {ObjectP[Object[Container, Plate]],_}],
					Return[Lookup[fetchPacketFromCacheHPLC[source[[1]], allPackets], Contents][[All,1]], Module],

				(* we were given a plate *)
				MatchQ[source, ObjectP[Object[Container, Plate]]],
				Return[Lookup[fetchPacketFromCacheHPLC[source, allPackets], Contents][[All,1]], Module],

				(* we have a sample mixed in, we can check only one because we can't read samples from different container anyways and check for it *)
				MatchQ[source, ObjectP[Object[Sample]]],
				Return[
					Lookup[fetchPacketFromCacheHPLC[
						Download[
							Lookup[
								fetchPacketFromCacheHPLC[source, allPackets],
								Container],
							Object],
						allPackets],
						Contents][[All, 1]],
					Module],

				True,
				Nothing
			]],
			expandedSource
		]],

			(* we did do some transfers so we have to calculate what we have *)
			Module[{allTransfersDestinations, thisPlate, filledWells},
				(* Flatten 3 is to bring everything to a single layer of listiness *)
				allTransfersDestinations = Cases[Lookup[previousPotentialTransfers[[All,1]],{Destination,Destinations},{}],{_,WellP}, Infinity];
				thisPlate = Switch[expandedSource[[1]],
					{_,_}, expandedSource[[1,1]],
					_, expandedSource[[1]]
				];
				filledWells = DeleteDuplicates@Cases[allTransfersDestinations,{thisPlate,_}][[All,2]]
			]
		];

		allSimulatedReadPlatePackets = simulatePrimitiveInputFunction[
			Join[expandedSource,expandedBlank],
			Join[expandedSourceLocation,expandedBlankLocation],
			Join[expandedSourceSample,expandedBlankSample]
		];

		{simulatedReadPlateSamplesByContainer,simulatedReadPlateContainers} = If[!MatchQ[allSimulatedReadPlatePackets,{}],
			Transpose[allSimulatedReadPlatePackets],
			{{},{}}
		];

		validReadPlatePlateCountQ = True;
		readPlatePlateCountTest = If[Length[simulatedReadPlateSamplesByContainer] > 1,
			(
				validReadPlatePlateCountQ = False;
				If[messagesBoolean,
					(
						Message[Error::TooManyReadPlateContainers,myPrimitive];
						Message[Error::InvalidInput,myPrimitive];
						Null
					),
					testOrNull[StringTemplate["The ReadPlate primitive at index `1` has all its samples and blanks in the same plate:"][myPrimitiveIndex],False]
				]
			),
			testOrNull[StringTemplate["The ReadPlate primitive at index `1` has all its samples and blanks in the same plate:"][myPrimitiveIndex],True]
		];

		allSimulatedReadPlateSamplePackets = Join@@simulatedReadPlateSamplesByContainer;

		emptyWells = {};

		readPlateSamples = MapThread[
			Function[{source, sourceSample, sourceLocation},
				Which[
					(* if we have a position in a plate specified and it is not one of the ones that we know exist in the plate, don't give it to the Experiment function  *)
					NullQ[sourceSample]&&MatchQ[source, {_,Except[Alternatives@@positionsWithSamplesInPlate]}],
						AppendTo[emptyWells, source[[2]]]; Nothing,
					MatchQ[sourceSample, ObjectP[Object[Sample]]],
						sourceSample,
					MatchQ[source,ObjectP[Object[Sample]]],
						source,
					(* Tagged Model container *)
					MatchQ[source,{_Symbol|_String|_Integer,ObjectP[Model[Container]]}],
						SelectFirst[allSimulatedReadPlateSamplePackets,MatchQ[Lookup[#,Well],"A1"]&],
					(* Model tag with well *)
					MatchQ[source,{{_Symbol|_String|_Integer,ObjectP[Model[Container]]},_String}],
						SelectFirst[allSimulatedReadPlateSamplePackets,MatchQ[Lookup[#,Well],source[[2]]]&],
					(* Straight Model container *)
					MatchQ[source,ObjectP[Model[Container]]],
						SelectFirst[allSimulatedReadPlateSamplePackets,MatchQ[Lookup[#,Well],"A1"]&],
					(* If source location is a container or container and well, fetch its model from the cache *)
					MatchQ[sourceLocation,ObjectP[Object[Container]]],
						SelectFirst[allSimulatedReadPlateSamplePackets,MatchQ[Lookup[#,Well],"A1"]&],
					MatchQ[sourceLocation,PlateAndWellP],
						SelectFirst[allSimulatedReadPlateSamplePackets,MatchQ[Lookup[#,Well],sourceLocation[[2]]]&],
					(* Tagged Model container *)
					MatchQ[source,_String],
					(* once again we need to not make the assumption that a string is a container, if it has a Sample key in definedNamesLookup *)
						If[
							MatchQ[Lookup[definedNamesLookup, source][Sample], {_,WellPositionP}],
							SelectFirst[allSimulatedReadPlateSamplePackets,MatchQ[Lookup[#,Well],Lookup[definedNamesLookup, source][Sample][[2]]]&],
							SelectFirst[allSimulatedReadPlateSamplePackets,MatchQ[Lookup[#,Well],"A1"]&]
						],
					MatchQ[source,{_String,WellPositionP}],
						SelectFirst[allSimulatedReadPlateSamplePackets,MatchQ[Lookup[#,Well],source[[2]]]&],
					True,
						First[allSimulatedReadPlateSamplePackets]
				]
			],
			{expandedSource, expandedSourceSample,expandedSourceLocation}
		];

		readPlatePlateEmptyWellsQ = True;
		readPlatePlateEmptyWellsTest = If[Length[emptyWells] > 0,
			(
				readPlatePlateEmptyWellsQ = False;
				If[messagesBoolean,
					(
						Message[Error::EmptyWells,myPrimitive];
						Message[Error::InvalidInput,myPrimitive];
						Null
					),
					testOrNull[StringTemplate["The ReadPlate primitive at index `1` has all specified positions in the plate not empty:"][myPrimitiveIndex],False]
				]
			),
			testOrNull[StringTemplate["The ReadPlate primitive at index `1` has all specified positions in the plate not empty:"][myPrimitiveIndex],True]
		];

		readPlateBlanks = MapThread[
			Function[{source,sourceLocation},
				Which[
					MatchQ[source,ObjectP[Object[Sample]]],
						source,
					(* Tagged Model container *)
					MatchQ[source,{_Symbol|_String|_Integer,ObjectP[Model[Container]]}],
						SelectFirst[allSimulatedReadPlateSamplePackets,MatchQ[Lookup[#,Well],"A1"]&],
					(* Model tag with well *)
					MatchQ[source,{{_Symbol|_String|_Integer,ObjectP[Model[Container]]},_String}],
						SelectFirst[allSimulatedReadPlateSamplePackets,MatchQ[Lookup[#,Well],source[[2]]]&],
					(* Straight Model container *)
					MatchQ[source,ObjectP[Model[Container]]],
						SelectFirst[allSimulatedReadPlateSamplePackets,MatchQ[Lookup[#,Well],"A1"]&],
					(* If source location is a container or container and well, fetch its model from the cache *)
					MatchQ[sourceLocation,ObjectP[Object[Container]]],
						SelectFirst[allSimulatedReadPlateSamplePackets,MatchQ[Lookup[#,Well],"A1"]&],
					MatchQ[sourceLocation,PlateAndWellP],
						SelectFirst[allSimulatedReadPlateSamplePackets,MatchQ[Lookup[#,Well],sourceLocation[[2]]]&],
					(* Tagged Model container *)
					MatchQ[source,_String],
					(* once again we need to not make the assumption that a string is a container, if it has a Sample key in definedNamesLookup *)
						If[
							MatchQ[Lookup[definedNamesLookup, source][Sample], {_,WellPositionP}],
							SelectFirst[allSimulatedReadPlateSamplePackets,MatchQ[Lookup[#,Well],Lookup[definedNamesLookup, source][Sample][[2]]]&],
							SelectFirst[allSimulatedReadPlateSamplePackets,MatchQ[Lookup[#,Well],"A1"]&]
						],
					MatchQ[source,{_String,WellPositionP}],
						SelectFirst[allSimulatedReadPlateSamplePackets,MatchQ[Lookup[#,Well],source[[2]]]&],
					True,
						First[allSimulatedReadPlateSamplePackets]
				]
			],
			{expandedBlank,expandedBlankLocation}
		];

		specifiedAdjustmentSample=Lookup[readPlateAssociation,AdjustmentSample];

		readPlateAdjustmentSample=Which[
			MatchQ[Lookup[readPlateAssociation,AdjustmentSample],FullPlate],
				FullPlate,
			MatchQ[specifiedAdjustmentSample,ObjectP[Object[Sample]]],
				specifiedAdjustmentSample,
			(* Tagged Model container *)
			MatchQ[specifiedAdjustmentSample,{_Symbol|_String|_Integer,ObjectP[Model[Container]]}],
				SelectFirst[allSimulatedReadPlateSamplePackets,MatchQ[Lookup[#,Well],"A1"]&],
			(* Model tag with well *)
			MatchQ[specifiedAdjustmentSample,{{_Symbol|_String|_Integer,ObjectP[Model[Container]]},_String}],
				SelectFirst[allSimulatedReadPlateSamplePackets,MatchQ[Lookup[#,Well],specifiedAdjustmentSample[[2]]]&],
			(* Straight Model container *)
			MatchQ[specifiedAdjustmentSample,ObjectP[Model[Container]]],
				SelectFirst[allSimulatedReadPlateSamplePackets,MatchQ[Lookup[#,Well],"A1"]&],
			(* If specifiedAdjustmentSample location is a container or container and well, fetch its model from the cache *)
			MatchQ[specifiedAdjustmentSample,ObjectP[Object[Container]]],
				SelectFirst[allSimulatedReadPlateSamplePackets,MatchQ[Lookup[#,Well],"A1"]&],
			MatchQ[specifiedAdjustmentSample,PlateAndWellP],
				SelectFirst[allSimulatedReadPlateSamplePackets,MatchQ[Lookup[#,Well],specifiedAdjustmentSample[[2]]]&],
			(* Tagged Model container *)
			MatchQ[specifiedAdjustmentSample,_String],
			(* once again we need to not make the assumption that a string is a container, if it has a Sample key in definedNamesLookup *)
				If[
					MatchQ[Lookup[definedNamesLookup, specifiedAdjustmentSample][Sample], {_,WellPositionP}],
					SelectFirst[allSimulatedReadPlateSamplePackets,MatchQ[Lookup[#,Well],Lookup[definedNamesLookup, specifiedAdjustmentSample][Sample][[2]]]&],
					SelectFirst[allSimulatedReadPlateSamplePackets,MatchQ[Lookup[#,Well],"A1"]&]
				],
			MatchQ[specifiedAdjustmentSample,{_String,WellPositionP}],
				SelectFirst[allSimulatedReadPlateSamplePackets,MatchQ[Lookup[#,Well],specifiedAdjustmentSample[[2]]]&],
			True,
				Null
		];

		(* Do some quicky handwavy approximations to determine type if it's left unresolved *)
		kineticsBool=MemberQ[Lookup[readPlateAssociation,{PrimaryInjectionVolume,PrimaryInjectionTime,PrimaryInjectionSample},Null],Except[Null]];
		fluorBool=MemberQ[Lookup[readPlateAssociation,{EmissionWavelength,ExcitationWavelength},Null],Except[Null]];
		fluorSpecBool=MemberQ[Lookup[readPlateAssociation,{EmissionWavelengthRange,ExcitationWavelengthRange},Null],Except[Null]];
		absBool=MemberQ[Lookup[readPlateAssociation,{Blank,BlankAbsorbance},Null],Except[Null]];

		readPlateType = With[{type=Lookup[readPlateAssociation,Type,Null]},
			Which[
				MatchQ[type,ReadPlateTypeP],type,
				kineticsBool&&fluorBool,FluorescenceKinetics,
				kineticsBool&&absBool,AbsorbanceKinetics,
				fluorSpecBool,FluorescenceSpectroscopy,
				fluorBool,FluorescenceIntensity,
				True,AbsorbanceSpectroscopy
			]
		];

		experimentFunction = Switch[readPlateType,
			AbsorbanceIntensity,
				ExperimentAbsorbanceIntensity,
			AbsorbanceSpectroscopy,
				ExperimentAbsorbanceSpectroscopy,
			AbsorbanceKinetics,
				ExperimentAbsorbanceKinetics,
			FluorescenceIntensity,
				ExperimentFluorescenceIntensity,
			FluorescenceSpectroscopy,
				ExperimentFluorescenceSpectroscopy,
			FluorescenceKinetics,
				ExperimentFluorescenceKinetics,
			LuminescenceIntensity,
				ExperimentLuminescenceIntensity,
			LuminescenceSpectroscopy,
				ExperimentLuminescenceSpectroscopy,
			LuminescenceKinetics,
				ExperimentLuminescenceKinetics,
			AlphaScreen,
				ExperimentAlphaScreen
		];

		experimentFunctionOptionNames = ToExpression/@Keys[Options[experimentFunction]];

		primitiveOptions = Append[
			KeyTake[readPlateAssociation,experimentFunctionOptionNames],
			{
				If[MemberQ[experimentFunctionOptionNames,Blanks],
					If[Length[readPlateBlanks] > 0,
						(* If Blank was passed in as a singleton, pass it through as a singleton *)
						Blanks -> If[MatchQ[Lookup[readPlateAssociation,Blank],objectSpecificationP],
							First[readPlateBlanks],
							readPlateBlanks
						],
						Nothing
					],
					Nothing
				],
				If[MemberQ[experimentFunctionOptionNames,AdjustmentSample],
					AdjustmentSample -> readPlateAdjustmentSample,
					Nothing
				],
				If[!MatchQ[OptionValue[PlateReader],Automatic],
					Instrument -> OptionValue[PlateReader],
					Nothing
				],
				(* send in AlphaScreen specific options *)
				If[MatchQ[readPlateType,AlphaScreen],
					Sequence@@{
						PreResolved->Lookup[readPlateAssociation,PreResolved],
						AlphaGain->Lookup[readPlateAssociation,AlphaGain],
						Temperature->Lookup[readPlateAssociation,Temperature],
						EquilibrationTime->Lookup[readPlateAssociation,EquilibrationTime]
					},
					Nothing
				],
				(* with Absorbance* read types we need to pass a requirement to use BMG instrument *)
				If[MatchQ[readPlateType, AbsorbanceIntensity|AbsorbanceSpectroscopy|AbsorbanceKinetics],
					LiquidHandler->True,
					Nothing
				]
			}
		];

		(* Throw an error if there are options that aren't resolved if PreResolved -> True *)
		preResolved=Lookup[primitiveOptions,PreResolved,False]/.{Null->False};

		unresolvedOptions=If[preResolved,
			Keys[Select[primitiveOptions,MatchQ[#,Automatic]&]],
			{}
		];

		unresolvedOptionsQ=Length[unresolvedOptions]>0;

		unresolvedOptionsTest = If[unresolvedOptionsQ,
			(
				If[messagesBoolean,
					(
						Message[Error::UnresolvedOptions,unresolvedOptions];
						Null
					),
					testOrNull["All options have been resolved when PreResolved->True:",False]
				]
			),
			testOrNull["All options have been resolved when PreResolved->True:",True]
		];

		(* Prepare some packets if we have to overwrite the readPlateSamples to Liquid *)
		liquidSampleOverwriteCache=<|Object->Download[#1,Object],State->Liquid|>&/@readPlateSamples;

		updatedCache=If[TrueQ[OptionValue[OverwriteSolidSample]],
			Flatten[
				Map[
					(* merge to get the last state from liquidSampleOverwriteCache *)
					Merge[#,Last]&,
					(* Gather the packets for the same samples *)
					Gather[Flatten[{simulatedReadPlateSamplesByContainer,simulatedReadPlateContainers,liquidSampleOverwriteCache}],Download[#1,Object]==Download[#2,Object]&]
				]
			],
			(* No need to change states of samples *)
			Flatten[{simulatedReadPlateSamplesByContainer,simulatedReadPlateContainers}]
		];
		
		updatedSimulation = Simulation[FlattenCachePackets[updatedCache]];

		(* Resolve the ReadPlate options -- we are adding the quiet here because we are throwing low volume errors for ReadPlate primitives. We throw the warning because we simulate primitives one by one and not from the beginning of the SM to the end. If you have an Aliquot to a plate followed by a ReadPlate, we don't account for the Aliquot when simulating the ReadPlate and will call the resolver with the sample volumes as the MinVolume of the plate. The resolver will then show the warning. For example, if you aliquot 200 uL into a plate that has a MinVolume of 50 uL and read the plate, you will get a warning saying 50 uL is too low because the simulation does not know we aliquoted 200 uL into our plate earlier in the SM. Yes, this is horrible but I am not rewriting the whole SM simulation pipeline to simulate all primitives sequentially just to quiet this error *)
		{readPlateOptions,readPlateExperimentTests}=Quiet[
			Which[

				(* Don't call the experiment function if PreResolved -> True *)
				preResolved,{primitiveOptions,Null},

				(* If gathering tests, get them and run *)
				gatherTests,Module[{options,tests,updatedTests},

					(* Call the resolver *)
					{options,tests}=experimentFunction[
						readPlateSamples,
						Sequence@@Normal[primitiveOptions],
						Aliquot->False,
						Simulation->updatedSimulation,
						Output->{Options,Tests}
					];

					(* Remove volume tests -- this is a horrible idea but see explanation above *)
					updatedTests=DeleteCases[tests,EmeraldTest[KeyValuePattern[Description->Alternatives[
						"The specified input sample volumes (or AssayVolumes specified) are greater than the minimum required sample volume for the resolved instrument type."
					]]]];

					(* Run the tests and return the output *)
					If[
						RunUnitTest[<|"Tests"->updatedTests|>,OutputFormat->SingleBoolean,Verbose->False],
						{options,updatedTests},
						{$Failed,updatedTests}
					]
				],

				(* Otherwise, just resolve *)
				True,{
					Quiet[
						Check[
							experimentFunction[
								readPlateSamples,
								Sequence@@Normal[primitiveOptions],
								Aliquot->False,
								Simulation->updatedSimulation,
								Output->Options
							],
							$Failed,
							(* If the container won't fit in the centrifuge we want to throw our own message *)
							{Error::InvalidInput,Error::InvalidOption,Error::AliquotOptionConflict,Error::NoTransferContainerFound}
						],
						(* Quiet these messages since we're making our own *)
						{Error::InvalidInput,Error::InvalidOption,Error::AliquotOptionConflict,Error::NoTransferContainerFound}
					],
					{}
				}
			],
			{Warning::AbsSpecInsufficientSampleVolume}
		];

		(* Some of the experiment functions resolve AdjustmentSample in a weird way that could
		refer to a simulated sample we passed in. We must replace that reference with the original
		sample's specification. *)
		replacedOptions = If[
			And[
				!MatchQ[readPlateOptions,$Failed],
				MatchQ[Lookup[readPlateOptions,AdjustmentSample],{_Integer,ObjectP[]}]
			],
			ReplaceRule[
				readPlateOptions,
				AdjustmentSample -> Replace[
					Lookup[readPlateOptions,AdjustmentSample][[2]],
					Join[
						MapThread[
							(ObjectP[Lookup[#1,Object]] -> #2)&,
							{readPlateSamples,expandedSource}
						],
						MapThread[
							(ObjectP[Lookup[#1,Object]] -> #2)&,
							{readPlateBlanks,expandedBlank}
						]
					]
				]
			],
			readPlateOptions
		];

		expandedOptions = If[!preResolved,
		  If[!MatchQ[replacedOptions,$Failed],
				ExpandIndexMatchedInputs[experimentFunction,{readPlateSamples},replacedOptions][[2]],
				$Failed
			],
			primitiveOptions
		];

		primitiveID = First@FirstPosition[rawReadPlatePrimitivePositions,myPrimitiveIndex];

		(* Update our primitive with our newly resolved options *)
		resolvedPrimitive = If[MatchQ[expandedOptions,$Failed],
			ReadPlate[Append[readPlateAssociation,{Sample->expandedSource,PrimitiveID->primitiveID}]],
			ReadPlate[
				Append[
					readPlateAssociation,
					Join[
						Association[{Sample->expandedSource,PrimitiveID->primitiveID,Type->readPlateType}],
						KeyTake[expandedOptions,Keys[manipulationKeyPatterns[ReadPlate]]]
					]
				]
			]
		];

		(* Extract the plate reader the experiment function wants to use *)
		resolvedPlateReader = Which[
			(* If it is for PreResolved AlphaScreen experiment, resolve it to CLARIOstar *)
			preResolved, Model[Instrument, PlateReader, "id:E8zoYvNkmwKw"],
			!MatchQ[replacedOptions,$Failed], Lookup[replacedOptions,Instrument],
			True,Null
		];

		validReadPlateQ = And[
			!MatchQ[replacedOptions,$Failed],
			validReadPlatePlateCountQ,
			validReadPlateSampleSpecificationQ,
			readPlatePlateEmptyWellsQ
		];

		readPlateTests = Join[
			readPlateExperimentTests,
			{readPlateScaleTest,readPlatePlateCountTest,readPlateSampleTest, readPlatePlateEmptyWellsTest}
		];

		{
			resolvedPrimitive,
			resolvedPlateReader,
			readPlateTests,
			validReadPlateQ
		}
	];

	(* Extract the positions in raw input primitive list that are actually Incubate primitives *)
	rawReadPlatePrimitivePositions = Flatten@Position[convertedMixIncubatePrimitives,_ReadPlate,{1}];

	(* Find positions for ReadPlate primitives in specified manipulations. *)
	readPlatePositions = Flatten@Position[manipulationsWithResolvedCentrifuges,_ReadPlate,{1}];
	(* If there is a Transfer or Aliquot before the first ReadPlate, let's assume the sample is now liquid *)
	(* Use this key as an option for resolveReadPlateFunction so we can quiet the handling of solid sample in plate reader experiments *)
	readPlateAfterTransferQ = MemberQ[manipulationsWithResolvedCentrifuges[[1;;FirstOrDefault[readPlatePositions,0]]],_Transfer|_Aliquot];

	(* Extract actual primitives *)
	readPlatePrimitives = manipulationsWithResolvedCentrifuges[[readPlatePositions]];
	
	(* Get the samples we are reading *)
	readPlateSamplesByPlate=Lookup[readPlatePrimitives[[All,1]],Sample,{}]/.containerWellTuple:{_String|ObjectP[Object[Container]],Alternatives@@Flatten[AllWells[NumberOfWells->384]]}:>First[containerWellTuple];
	
	(* Make a flat list of containers that correspond to each sample *)
	flatReadPlateContainers=Which[
		MatchQ[#,ObjectP[Object[Container]]], #,
		MatchQ[#,ObjectP[Object[Sample]]], Download[Lookup[fetchPacketFromCacheHPLC[#,allPackets],Container],Object],
		True, Lookup[First[Lookup[definedNamesLookup,#,{<||>}]],Container,{}]
	]&/@Flatten[readPlateSamplesByPlate];
	
	(* Make a list of plates for each ReadPlate primitive -- we are flattening here because you can only have one plate per read *)
	readPlateContainers=Flatten[DeleteDuplicates/@(readPlateSamplesByPlate/.Thread[Flatten[readPlateSamplesByPlate]->flatReadPlateContainers])];
	
	(* Determine if the plates are read with a lid or not *)
	plateCoveredQ=MapThread[
		Function[
			{readPlatePosition,readPlateContainer},
			Module[{coverUncoverPrimitives,coverPlateTuples,liddingActions},
				
				(* Get all the cover/uncover primitives up to the plate read we are doing *)
				coverUncoverPrimitives=Cases[Take[manipulationsWithResolvedCentrifuges,readPlatePosition],_Cover|_Uncover];
				
				(* Make tuples in the form of {Cover|Uncover,plate} *)
				coverPlateTuples={Head[#],Lookup[First[#],Sample]}&/@coverUncoverPrimitives;
				
				(* Create a list of cover/uncover actions for our plate *)
				liddingActions=Cases[coverPlateTuples,{_,readPlateContainer|{readPlateContainer}}][[All,1]];
				
				(* Return a bool for whether the plate is covered *)
				Count[liddingActions,Cover]>Count[liddingActions,Uncover]
			]
		],
		{readPlatePositions,readPlateContainers}
	];
	
	(* If we have any incubate or filter primitives OR the superstar is directly specified OR we are doing a covered plate read,we must use the Clariostar *)
	requiredPlateReader = Which[
		Or[
			MemberQ[manipulationsWithResolvedCentrifuges,(_Incubate|_Filter)],
			MatchQ[liquidHandlerModel,ObjectP[Model[Instrument, LiquidHandler, "id:7X104vnRbRXd"]]],
			MemberQ[plateCoveredQ,True]
		],Model[Instrument, PlateReader, "id:E8zoYvNkmwKw"],
		MatchQ[liquidHandlerModel,ObjectP[Model[Instrument, LiquidHandler, "id:kEJ9mqaW7xZP"]]],Model[Instrument,PlateReader,"id:mnk9jO3qDzpY"],
		True,Automatic
	];

	(* Resolve the ReadPlate primitives. Pass in positions for ReadPlate primitives from raw input primitives
	since we may have split transfers upstream. *)
	{initialResolvedReadPlatePrimitives,initialResolvedPlateReaderInstruments,initialReadPlateTests,initialValidReadPlateBooleans} = If[Length[readPlatePositions]>0,
		Transpose@MapThread[
			resolveReadPlateFunction[#1,#2,PlateReader->requiredPlateReader,OverwriteSolidSample->readPlateAfterTransferQ]&,
			{readPlatePrimitives,rawReadPlatePrimitivePositions}
		],
		{{},{},{},{True}}
	];

	reresolutionRequiredQ = !(SameQ@@DeleteCases[initialResolvedPlateReaderInstruments,Null]);

	(* Find positions of any Omega instances and re-resolve them *)
	reresolutionPositions = If[reresolutionRequiredQ,
		Flatten@Position[initialResolvedPlateReaderInstruments,ObjectP[Model[Instrument,PlateReader,"id:mnk9jO3qDzpY"]],{1}],
		{}
	];

	(* Attempt to re-resolve forcing clariostar usage *)
	{reresolvedReadPlatePrimitives,reresolvedPlateReaderInstruments,reresolvedreadPlateTests,reresolvedvalidReadPlateBooleans} = If[Length[reresolutionPositions]>0,
		Transpose@MapThread[
			resolveReadPlateFunction[#1,#2,PlateReader->Model[Instrument, PlateReader, "id:E8zoYvNkmwKw"],OverwriteSolidSample->readPlateAfterTransferQ]&,
			{readPlatePrimitives[[reresolutionPositions]],rawReadPlatePrimitivePositions[[reresolutionPositions]]}
		],
		{{},{},{},{}}
	];

	resolvedReadPlatePrimitives = ReplacePart[
		initialResolvedReadPlatePrimitives,
		MapThread[
			(#1 -> #2)&,
			{reresolutionPositions,reresolvedReadPlatePrimitives}
		]
	];

	(* We must resimulate our read plate primitives to make sure all plates used are either all 96 or all 384 well format *)
	(* This is due to setup restrictions, where 384 requires special setup incompatible with 96well plates *)
	readPlateAssayPlateContainers = Map[
		Function[{readPlateAssociation},
			Module[
				{expandedSource,expandedSourceLocation,expandedBlank,expandedBlankLocation,expandedSourceSample,expandedBlankSample},

				(* if we were given a single sample, get it into a list *)
				expandedSource = If[
					MatchQ[readPlateAssociation[Sample],objectSpecificationP],
					{readPlateAssociation[Sample]},
					readPlateAssociation[Sample]
				];


				(* Get resolved location - this will only be populated if we know the specific object *)
				expandedSourceLocation = readPlateAssociation[ResolvedSourceLocation];

				(* if we were given a single sample, get it into a list *)
				expandedBlank = If[
					MatchQ[readPlateAssociation[Blank],objectSpecificationP],
					{readPlateAssociation[Blank]},
					readPlateAssociation[Blank]
				];

				(* Get resolved location - this will only be populated if we know the specific object *)
				expandedBlankLocation = readPlateAssociation[ResolvedBlankLocation];

				(* Get resolved source sample - this will only be populated if we know the specific object*)
				expandedSourceSample = readPlateAssociation[SourceSample];
				expandedBlankSample = readPlateAssociation[SourceSample];

				simulatePrimitiveInputFunction[
					Join[
						expandedSource,
						expandedBlank
					],
					Join[
						expandedSourceLocation,
						expandedBlankLocation
					],
					Join[
						expandedSourceSample,
						expandedBlankSample
					]
				]
			]
		],
		resolvedReadPlatePrimitives
	];

	(* Gather the models *)
	readPlateAssayPlateModels = Download[
		Lookup[
			Cases[readPlateAssayPlateContainers,AssociationMatchP[<|Type->Object[Container,Plate]|>,AllowForeignKeys->True],Infinity],
			Model
		],
		Object
	];

	bmgPlateReaderFormats = BMGPlateModelLookup[readPlateAssayPlateModels];

	validReadPlatePlateModelsQ = True;
	readPlatePlateModelsTest = If[Length[DeleteDuplicates@bmgPlateReaderFormats] > 1,
		(
			validReadPlatePlateModelsQ = False;
			If[messagesBoolean,
				(
					Message[Error::IncompatibleReadPlatePlateModels];
					Message[Error::InvalidInput,readPlatePrimitives];
					Null
				),
				testOrNull["The assay plates of the ReadPlate primitives are all 96-well format or all 384 well format:",False]
			]
		),
		testOrNull["The assay plates of the ReadPlate primitives are all 96-well format or all 384 well format:",True]
	];

	resolvedPlateReaderInstruments = ReplacePart[
		initialResolvedPlateReaderInstruments,
		MapThread[
			(#1 -> #2)&,
			{reresolutionPositions,reresolvedPlateReaderInstruments}
		]
	];

	resolvedPlateReaderInstrument = FirstCase[
		resolvedPlateReaderInstruments,
		ObjectP[Model[Instrument, PlateReader]],
		Null
	];

	readPlateTests = ReplacePart[
		Append[initialReadPlateTests,readPlatePlateModelsTest],
		MapThread[
			(#1 -> #2)&,
			{reresolutionPositions,reresolvedreadPlateTests}
		]
	];

	validReadPlateBooleans = ReplacePart[
		initialValidReadPlateBooleans,
		MapThread[
			(#1 -> #2)&,
			{reresolutionPositions,reresolvedvalidReadPlateBooleans}
		]
	];

	(* Replace relevant primitives with resolved ReadPlate primitives  *)
	manipulationsWithResolvedReadPlates = If[Length[resolvedReadPlatePrimitives]>0,
		ReplacePart[
			manipulationsWithResolvedCentrifuges,
			MapThread[
				Rule,
				{readPlatePositions,resolvedReadPlatePrimitives}
			]
		],
		manipulationsWithResolvedCentrifuges
	];

	(* if any of the readplates are invalid, we will throw InvalidOption error below *)
	validReadPlatesQ = And@@validReadPlateBooleans;

	(* Strip out associations *)
	resolvedReadPlateAssociations = First/@resolvedReadPlatePrimitives;

	(* Extract injection samples from associations, defaulting to Null if not specified *)
	allInjectionSamples = Join@@Map[
		Lookup[#,{PrimaryInjectionSample,SecondaryInjectionSample,TertiaryInjectionSample,QuaternaryInjectionSample},Null]&,
		resolvedReadPlateAssociations
	];

	(* Extract injection volumes from associations, defaulting to Null if not specified *)
	allInjectionVolumes = Join@@Map[
		Lookup[#,{PrimaryInjectionVolume,SecondaryInjectionVolume,TertiaryInjectionVolume,QuaternaryInjectionVolume},Null]&,
		resolvedReadPlateAssociations
	];

	uniqueInjectionSamples = DeleteDuplicates@DeleteCases[Flatten@allInjectionSamples,Null];

	validInjectionCountQ = True;
	injectionSampleCountTest = If[Length[uniqueInjectionSamples] > 2,
		validInjectionCountQ = False;
		If[messagesBoolean,
			(
				Message[Error::TooManyInjectionSamples];
				Message[Error::InvalidInput,readPlatePrimitives];
				Null
			),
			testOrNull["All ReadPlate primitives can use a maximum of two unique injection samples:",False]
		],
		testOrNull["All ReadPlate primitives can use a maximum of two unique injection samples:",True]
	];

	(* MapThread at level 2 since injection samples and volumes are doubly listed (index-matched to Sample) *)
	injectionSampleVolumeLookup = If[Length[uniqueInjectionSamples] > 0 && And@@Join[initialValidReadPlateBooleans,reresolvedvalidReadPlateBooleans],
		Merge[
			Join@@MapThread[
				If[NullQ[#1],
					Nothing,
					Download[#1,Object] -> #2
				]&,
				{allInjectionSamples,allInjectionVolumes},
				2
			],
			Total
		],
		<||>
	];

	(* Track containers which can be used to hold injection samples - plate readers have spots for 2mL, 15mL and 50mL tubes *)
	allowedInjectionContainers = Search[Model[Container, Vessel],Footprint==(Conical50mLTube|Conical15mLTube|MicrocentrifugeTube)&&Deprecated!=True];

	injectionResources = KeyValueMap[
		Module[{sample,volume,injectionContainer,injectionContainerModel},

			{sample,volume}={#1,#2};

			(* Lookup sample's container model *)
			injectionContainer = If[MatchQ[sample,ObjectP[Object[Sample]]],
				Download[Lookup[fetchPacketFromCacheHPLC[sample,allPackets],Container],Object],
				Null
			];
			injectionContainerModel = If[!NullQ[injectionContainer],
				Download[Lookup[fetchPacketFromCacheHPLC[injectionContainer,allPackets],Model],Object],
				Null
			];

			(* Create a resource for the sample *)
			Resource@@{
				Sample -> sample,
				(* Include volume lost due to priming lines (compiler sets to 1mL)
				- prime should account for all needed dead volume - prime fluid stays in syringe/line (which have vol of ~750 uL) *)
				Amount -> (volume + $BMGPrimeVolume),

				(* Specify a container if we're working with a model or if current container isn't workable *)
				If[MatchQ[injectionContainerModel,ObjectP[allowedInjectionContainers]],
					Nothing,
					Container -> PreferredContainer[volume + $BMGPrimeVolume,Type->Vessel]
				],
				Name->ToString[sample]
			}
		]&,
		injectionSampleVolumeLookup
	];

	primaryInjectionSample = If[Length[injectionResources]>0,
		injectionResources[[1]],
		Null
	];
	secondaryInjectionSample = If[Length[injectionResources]>1,
		injectionResources[[2]],
		Null
	];

	numberOfInjectionContainers = Which[
		!NullQ[secondaryInjectionSample],
			2,
		!NullQ[primaryInjectionSample],
			1,
		True,
			0
	];

	anyInjectionsQ = Or[
		!NullQ[primaryInjectionSample],
		!NullQ[secondaryInjectionSample]
	];


	(* Wash each line being used with the flush volume - request a little extra to avoid air in the lines *)
	(* Always multiply by 2 - either we'll use same resource for prepping and flushing or we have two lines to flush *)
	washVolume = ($BMGFlushVolume + 2.5 Milliliter) * 2;

	(* Create solvent resources to clean the lines *)
	primaryCleaningSolvent = Resource@@{
		Sample -> Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"] (* 70% Ethanol *),
		(* Wash each line being used with the wash volume - request a little extra to avoid air in the lines *)
		Amount->washVolume,
		Container -> Model[Container, Vessel, "id:bq9LA0dBGGR6"],
		(* If we have only one injection container then we are only priming one line and we can use the same resource for set-up and tear-down *)
		If[numberOfInjectionContainers==1,
			Name->"Primary Cleaning Solvent",
			Nothing
		]
	};

	secondaryCleaningSolvent=Resource@@{
		Sample->Model[Sample,"id:8qZ1VWNmdLBD"] (*Milli-Q water *),
		(* Wash each line being used with the wash volume - request a little extra to avoid air in the lines *)
		Amount->washVolume,
		Container->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
		(* If we have only one injection container then we are only priming one line and we can use the same resource for set-up and tear-down *)
		If[numberOfInjectionContainers==1,
			Name->"Secondary Cleaning Solvent",
			Nothing
		]
	};

	(* Populate fields needed to clean the lines before/after the run *)
	plateReaderFields = If[anyInjectionsQ,
		Association[
			InjectionSample -> primaryInjectionSample,
			SecondaryInjectionSample -> secondaryInjectionSample,
			PrimaryPreppingSolvent -> primaryCleaningSolvent,
			PrimaryFlushingSolvent -> primaryCleaningSolvent,
			SecondaryPreppingSolvent -> secondaryCleaningSolvent,
			SecondaryFlushingSolvent -> secondaryCleaningSolvent
		],
		Association[]
	];

	(* == Resolve and validate Incubate primitives === *)

	(* list the keys from the Incubate primitive that are only used in Micro scale *)
	microOnlyIncubateOptions=Alternatives[
		Preheat
	];

	(* list the keys from the Incubate primitive that are only used in Macro scale *)
	macroOnlyIncubateOptions=Alternatives[
		AnnealingTime,
		MixType,
		Instrument,
		NumberOfMixes,
		MixVolume,
		MixUntilDissolved,
		MaxNumberOfMixes,
		MaxTime
	];

	microRequiredOptions = {
		Time,
		Temperature
	};

	(* Doing this TakeList trick because Resuspend primitives create extra Incubate primitives that can confuse this stuff*)
	listyConvertedMixIncubatePrimitives = TakeList[convertedMixIncubatePrimitives, listyResuspendLengths];

	(* Extract the positions in raw input primitive list that are actually Incubate primitives *)
	(* so any Incubate primitive is going to be either a list of just an Incubate (normal) or a list of  one Transfer+ an Incubate*)
	rawIncubatePrimitivePositions = Flatten@Position[listyConvertedMixIncubatePrimitives,{Repeated[_Transfer, {0, 1}], _Incubate},{1}];

	(* If the scale was specified to MicroLiquidHandling, we know we required both Time and Temperature *)
	incubatePrimitivesMissingKeys = If[MatchQ[specifiedScale,MicroLiquidHandling],
		MapThread[
			(* Doing this Last thing because it makes it clearer that I'm pulling the Incubate primitive from the list *)
			With[{incubatePrimitive = Last[#2]},
				If[!ContainsAll[Keys[First[incubatePrimitive]], microRequiredOptions],
					#1,
					Nothing
				]
			]&,
			{myRawManipulations[[rawIncubatePrimitivePositions]], listyConvertedMixIncubatePrimitives[[rawIncubatePrimitivePositions]]}
		],
		{}
	];

	(* Get the Incubate primitives that have defined both macro and micro keys - these are invalid right away *)
	incubatePrimitivesMacroAndMicro = MapThread[
		(* Last because if you have a converted Resuspend primitive, then the first is always going to be a Transfer and we only care about the second *)
		(* otherwise, it's a list of length 1 anyway*)
		With[{possibleIncubatePrimitive = Last[#2]},
			If[
				And[
					MatchQ[possibleIncubatePrimitive, _Incubate|_Mix],
					MemberQ[Keys[First[possibleIncubatePrimitive]],microOnlyIncubateOptions],
					MemberQ[Keys[First[possibleIncubatePrimitive]],macroOnlyIncubateOptions]
				],
				#1,
				Nothing
			]
		]&,
		{myRawManipulations, listyConvertedMixIncubatePrimitives}
	];

	(* Get the Incubate primitives that have defined micro keys only. These are valid as long as the Liquidhandlingscale, if specified, is Micro as well - we will test this below *)
	incubatePrimitivesMicro = MapThread[
		(* Last because if you have a converted Resuspend primitive, then the first is always going to be a Transfer and we only care about the second *)
		(* otherwise, it's a list of length 1 anyway*)
		With[{incubatePrimitive = Last[#2]},
			If[
				And[
					MemberQ[Keys[First[incubatePrimitive]],microOnlyIncubateOptions],
					!MemberQ[Keys[First[incubatePrimitive]],macroOnlyIncubateOptions]
				],
				#1,
				Nothing
			]
		]&,
		{myRawManipulations[[rawIncubatePrimitivePositions]], listyConvertedMixIncubatePrimitives[[rawIncubatePrimitivePositions]]}
	];

	(* Get the Incubate primitives that have defined macro keys only. These are valid as long as the Liquidhandlingscale, if specified, is Macro as well - we will test this below *)
	incubatePrimitivesMacro = MapThread[
		(* Last because if you have a converted Resuspend primitive, then the first is always going to be a Transfer and we only care about the second *)
		(* otherwise, it's a list of length 1 anyway*)
		With[{incubatePrimitive = Last[#2]},
			If[
				And[
					!MemberQ[Keys[First[incubatePrimitive]],microOnlyIncubateOptions],
					MemberQ[Keys[First[incubatePrimitive]],macroOnlyIncubateOptions]
				],
				#1,
				Nothing
			]
		]&,
		{myRawManipulations[[rawIncubatePrimitivePositions]], listyConvertedMixIncubatePrimitives[[rawIncubatePrimitivePositions]]}
	];

	(* If there are Incubate primitives that are missing Time or Temperature and we're doing Microliquidhandling, we need to throw an error; also set the message variable to True *)
	missingKeysMessage = Module[
		{missingIncubateOptions,primitiveIndices},

		If[(Length[incubatePrimitivesMissingKeys]>0 && !gatherTests),
			missingIncubateOptions = Map[Complement[microRequiredOptions,Keys[#]]&,incubatePrimitivesMissingKeys];
			primitiveIndices = Flatten[Position[myRawManipulations,#]&/@incubatePrimitivesMissingKeys];
			(
				Message[Error::MicroPrimitiveMissingKeys,primitiveIndices,missingIncubateOptions];
				Message[Error::InvalidInput,incubatePrimitivesMissingKeys]
			);
			True,
			False
		]
	];

	(* If we are gathering tests, create tests for the Incubate primitives with missing keys *)
	missingKeysTests = If[gatherTests,

	(* We're gathering tests. Create the appropriate tests. *)
		Module[
			{passingManips,passingIncubateManips,passingManipsTest,passingPrimitiveIndices,
			failingPrimitiveIndices,failingManipsTest},

			(* Get the inputs that pass this test. *)
			passingManips=Complement[myRawManipulations,incubatePrimitivesMissingKeys];

			(* make sure we only select the incubate primitives here, since for the others this test is irrelevant *)
			(* doing Resuspend because that could be an Incubate too*)
			passingIncubateManips=Select[passingManips,MatchQ[#,_Incubate|_Resuspend]&];

			(* get the index of the failing and passing primitives *)
			passingPrimitiveIndices=Sort[Flatten[Position[myRawManipulations,#]&/@passingIncubateManips]];
			failingPrimitiveIndices=Sort[Flatten[Position[myRawManipulations,#]&/@incubatePrimitivesMissingKeys]];

			(* Create a test for the passing inputs. *)
			passingManipsTest=If[Length[passingPrimitiveIndices]>0,
				Test["The Incubate manipulations at the positions "<>ToString[passingPrimitiveIndices]<>", lists all keys required for the specified LiquidHandlingScale:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingManipsTest=If[Length[incubatePrimitivesMissingKeys]>0,
				Test["The Incubate manipulations at the positions "<>ToString[failingPrimitiveIndices]<>", lists all keys required for the specified LiquidHandlingScale:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingManipsTest,
				failingManipsTest
			}
		],
	(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* If there are Incubate primitives with keys for both Macro and Micro, and we are throwing messages, throw an error message *)
	conflictingIncubateMessage = Module[
		{conflictingIncubateOptions,primitiveIndices},

		If[(Length[incubatePrimitivesMacroAndMicro]>0 && !gatherTests),
			conflictingIncubateOptions = Map[Intersection[Keys[#],Join[ToList@@microOnlyIncubateOptions,ToList@@macroOnlyIncubateOptions]]&,incubatePrimitivesMacroAndMicro];
			primitiveIndices = Flatten[Position[myRawManipulations,#]&/@incubatePrimitivesMacroAndMicro];
			(
				Message[Error::InvalidIncubatePrimitive,primitiveIndices,conflictingIncubateOptions];
				Message[Error::InvalidInput,incubatePrimitivesMacroAndMicro]
			);
			True,
			False
		]
	];

	(* If we are gathering tests, create tests for the Incubate primitives with both Macro and Micro keys *)
	conflictingIncubatePrimitiveTests = If[gatherTests,

	(* We're gathering tests. Create the appropriate tests. *)
		Module[
			{passingManips,passingIncubateManips,passingManipsTest,passingPrimitiveIndices,
			failingPrimitiveIndices,failingManipsTest},

			(* Get the inputs that pass this test. *)
			passingManips=Complement[myRawManipulations,incubatePrimitivesMacroAndMicro];

			(* make sure we only select the incubate primitives here, since for the others this test is irrelevant *)
			(* doing Resuspend because that could be an Incubate too*)
			passingIncubateManips=Select[passingManips,MatchQ[#,_Incubate|_Resuspend]&];

			(* get the index of the failing and passing primitives *)
			passingPrimitiveIndices=Sort[Flatten[Position[myRawManipulations,#]&/@passingIncubateManips]];
			failingPrimitiveIndices=Sort[Flatten[Position[myRawManipulations,#]&/@incubatePrimitivesMacroAndMicro]];

			(* Create a test for the passing inputs. *)
			passingManipsTest=If[Length[passingPrimitiveIndices]>0,
				Test["In the Incubate manipulations at the positions "<>ToString[passingPrimitiveIndices]<>", the primitive keys are specific for a single LiquidHandlingScale:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingManipsTest=If[Length[incubatePrimitivesMacroAndMicro]>0,
				Test["In the Incubate manipulations at the positions "<>ToString[failingPrimitiveIndices]<>", the primitive keys are specific for a single LiquidHandlingScale:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingManipsTest,
				failingManipsTest
			}
		],
	(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* now get Incubate primitives with keys that are conflicting with the Scale if that was specified - we can throw an error right away *)
	incubatePrimitivesConflictingWithScale = Which[
		MatchQ[specifiedScale,MicroLiquidHandling]&&!MatchQ[incubatePrimitivesMacro,{}],incubatePrimitivesMacro,
		MatchQ[specifiedScale,MacroLiquidHandling]&&!MatchQ[incubatePrimitivesMicro,{}],incubatePrimitivesMicro,
		True,{}
	];

	(* If there are Incubate primitives with keys conflicting with the scale, and we are throwing messages, throw an error message here and set the error variable to True*)
	conflictingIncubateWithScaleMessage = Module[
		{conflictingWithScaleIncubateOptions,primitiveIndices},

		If[(Length[incubatePrimitivesConflictingWithScale]>0 && !gatherTests),
			conflictingWithScaleIncubateOptions = Map[Intersection[Keys[#],Join[ToList@@microOnlyIncubateOptions,ToList@@macroOnlyIncubateOptions]]&,incubatePrimitivesConflictingWithScale];
			primitiveIndices = Flatten[Position[myRawManipulations,#]&/@incubatePrimitivesConflictingWithScale];
			(
				Message[Error::InvalidOption,LiquidHandlingScale];
				Message[
					Error::IncubateManipConflictsWithScale,
					primitiveIndices,
					specifiedScale,
					conflictingWithScaleIncubateOptions,
					If[MatchQ[specifiedScale,MicroLiquidHandling],
						MacroLiquidHandling,
						MicroLiquidHandling
					]
				]
			);
			True,
			False
		]
	];

	(* If we are gathering tests, create tests for the Incubate primtiives conflicting with the specified Scale *)
	conflictingIncubateWithScaleTests = If[gatherTests,

	(* We're gathering tests. Create the appropriate tests. *)
		Module[
			{passingManips,passingIncubateManips,passingManipsTest,passingPrimitiveIndices,
			failingPrimitiveIndices,failingManipsTest},

			(* Get the inputs that pass this test. *)
			passingManips=Complement[myRawManipulations,incubatePrimitivesConflictingWithScale];

			(* make sure we only select the incubate primitives here, since for the others this test is irrelevant *)
			(* doing Resuspend because that could be an Incubate too*)
			passingIncubateManips=Select[passingManips,MatchQ[#,_Incubate|_Resuspend]&];

			(* get the index of the failing and passing primitives *)
			passingPrimitiveIndices=Sort[Flatten[Position[myRawManipulations,#]&/@passingIncubateManips]];
			failingPrimitiveIndices=Sort[Flatten[Position[myRawManipulations,#]&/@incubatePrimitivesConflictingWithScale]];

			(* Create a test for the passing inputs. *)
			passingManipsTest=If[Length[passingIncubateManips]>0,
				Test["In the manipulation primitives at the positions(s) "<>ToString[passingPrimitiveIndices]<>", the primitive keys match the provided LiquidHandlingScale:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingManipsTest=If[Length[incubatePrimitivesConflictingWithScale]>0,
				Test["In the manipulation primitives at the positions(s) "<>ToString[failingPrimitiveIndices]<>", the primitive keys match the provided LiquidHandlingScale:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingManipsTest,
				failingManipsTest
			}
		],
	(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Helper function to resolve any Incubation keys that need specification - Note that we return the primitive and a list of tests each *)
	resolveIncubationFunction[myPrimitive_,myPrimitiveIndex_,myRequiredScale_]:=Module[
		{incubationAssociation,expandedSource,expandedSourceSample,expandedParams,resolvedPrimitive,incubateTests,validMacroIncubationQ},

		(* get the full form of the incubation as an Association *)
		incubationAssociation = First[myPrimitive];

		(* if we were given a single sample, get it into a list *)
		expandedSource = If[
			MatchQ[Lookup[incubationAssociation,Sample],objectSpecificationP],
			{Lookup[incubationAssociation,Sample]},
			Lookup[incubationAssociation,Sample]
		];

		(* Get resolved source sample - this will only be populated if we know the specific object*)
		expandedSourceSample = Lookup[incubationAssociation,SourceSample];

		(* if we were given single parameters, get them into a list *)
		expandedParams = Prepend[
			Map[
				If[MatchQ[#,_List],
					#,
					Table[#,Length[expandedSource]]
				]&,
				KeyDrop[incubationAssociation,Sample]
			],
			Sample -> expandedSource
		];

		(* set the error-tracking variable here *)
		validMacroIncubationQ = True;

		(* Now let's resolve the primitive keys. Do a big Switch call, depending on which scale this Incubate primitive needs *)
		{resolvedPrimitive,incubateTests,validMacroIncubationQ}=Switch[myRequiredScale,

		(* If we're doing MicroLiquidHandling resolve the micro-specific keys *)
			MicroLiquidHandling,

			Module[{resolvedPreheat,resolvedResidualIncubation,resolvedResidualTemperature,resolvedMixRate,
				resolvedResidualMix,resolvedResidualMixRate,resolvedTemperature,resolvedTime},

			(* Source, Time, and Temperature are required so we don't need to check if they're missing *)

			(* If Preheat is not specified, resolve to False *)
				resolvedPreheat = If[KeyExistsQ[expandedParams,Preheat],
					Lookup[expandedParams,Preheat],
					Table[False,Length[expandedSource]]
				];

				(* If ResidualTemperature is populated, any indices with a temperature (or Ambient) should set ResidualIncubation to True,
				otherwise the index should be Null and ResidualIncubation should set to False *)
				resolvedResidualIncubation = If[KeyExistsQ[expandedParams,ResidualIncubation],
					Lookup[expandedParams,ResidualIncubation],
					If[KeyExistsQ[expandedParams,ResidualTemperature],
						If[NullQ[#],False,True]&/@Lookup[expandedParams,ResidualTemperature],
						Table[False,Length[expandedSource]]
					]
				];

				(* If ResidualTemperature is not set, resolve to Temperature where ResidualIncubation is True, otherwise resolve to Null
				If ResidualIncubation is not specified at all, resolve all to Null *)
				resolvedResidualTemperature = If[KeyExistsQ[expandedParams,ResidualTemperature],
					Lookup[expandedParams,ResidualTemperature],
					If[KeyExistsQ[expandedParams,ResidualIncubation],
					(* If ResidualIncubation is specified but ResidualTemperature is not, resolve ResidualTemperature
					(when ResidualIncubation is True, to Temperature; otherwise to Null) *)
						MapThread[
							Function[{residualIncubationQ,temperature},
								If[residualIncubationQ,
									temperature,
									Null
								]
							],
							{Lookup[expandedParams,ResidualIncubation],Lookup[expandedParams,Temperature]}
						],
						Table[Null,Length[expandedSource]]
					]
				];

				(* If a MixRate is not specified, resolve to 250 RPM if Mix is requested *)
				resolvedMixRate = Which[
					KeyExistsQ[expandedParams,MixRate], Lookup[expandedParams,MixRate],
					MatchQ[Lookup[expandedParams,Mix,Null],ListableP[True]], Table[250RPM,Length[expandedSource]],
					True, Table[Null,Length[expandedSource]]
				];

				(* If ResidualMixRate is populated, any indices with a mix rate should set ResidualMix to True,
				otherwise the index should be Null and ResidualMix should set to False *)
				resolvedResidualMix = If[KeyExistsQ[expandedParams,ResidualMix],
					Lookup[expandedParams,ResidualMix],
					If[KeyExistsQ[expandedParams,ResidualMixRate],
						If[NullQ[#],False,True]&/@Lookup[expandedParams,ResidualMixRate],
						Table[False,Length[expandedSource]]
					]
				];

				(* Same situation as ResidualTemperature: if ResidualMixRate is not set,
				resolve to MixRate where ResidualMix is True, otherwise resolve to Null
				If ResidualMixRate is not specified at all, resolve all to Null *)
				resolvedResidualMixRate = If[KeyExistsQ[expandedParams,ResidualMixRate],
					Lookup[expandedParams,ResidualMixRate],
					If[KeyExistsQ[expandedParams,ResidualMix],
						MapThread[
							Function[{residualMixQ,mixRate},
								If[residualMixQ,
									mixRate,
									Null
								]
							],
							{Lookup[expandedParams,ResidualMix],Lookup[expandedParams,MixRate]}
						],
						Table[Null,Length[expandedSource]]
					]
				];

				(* Because Time and Temperature are not required keys anymore, we need to fill in Null for the resolution *)
				resolvedTemperature=If[!KeyExistsQ[expandedParams,Temperature],
					Table[Null,Length[expandedSource]],
					Lookup[expandedParams,Temperature]
				];

				resolvedTime=If[!KeyExistsQ[expandedParams,Time],
					Table[Null,Length[expandedSource]],
					Lookup[expandedParams,Time]
				];

				(* Return the resolved primitive, plus an empty list for tests, plus True for the validMacroIncubationQ boolean *)
				{
					Incubate[
						Append[expandedParams,
							{
								Temperature -> resolvedTemperature,
								Time -> resolvedTime,
								Preheat -> resolvedPreheat,
								ResidualIncubation -> resolvedResidualIncubation,
								ResidualTemperature -> resolvedResidualTemperature,
								MixRate -> resolvedMixRate,
								ResidualMix -> resolvedResidualMix,
								ResidualMixRate -> resolvedResidualMixRate
							(* ignore Macro keys *)
							}
						]
					],
					{},
					validMacroIncubationQ
				}

			],

		(* If this is a Macro primitive, we resolve all keys via ExperimentIncubate *)
			MacroLiquidHandling|Bufferbot,

			Module[
				{conflictResidualMixRatePrimitives,conflictingResidualMixRateTest,conflictResidualTemperaturePrimitives,conflictingResidualTemperatureTest,
				conflictResidualMixPrimitives,conflictingResidualMixTest,conflictResidualIncubationPrimitives,conflictingResidualIncubationTest,
				expandedSourceLocation,expandedSourceContainers,simulatedIncubatePackets,incubateSamplesByContainer,
				incubateContainers,incubateSamples,incubateMixBooleans,incubateTimes,incubateTemperatures,incubateMixRates,incubateAnnealingTimes,
				incubateMixTypes,incubateInstruments,incubateNumberOfMixes,incubateMixVolumes,incubateMixUntilDissolved,
				incubateMaxNumberOfMixes,incubateMaxTimes,macroIncubateOptions,sourceSampleObjects,sourceContainerObjects,preResolvedMixRates,preResolvedTemperatures,
				preResolvedResidualIncubation,preResolverTests,resolvedResidualMixRate,resolvedResidualTemperature,resolvedResidualMix,
				macroIncubateTests,expandedOptions,conflictingResidualBooleansPrimitives,conflictingResidualBooleansTest,
				conflictingResidualIncubatePrimitives,conflictingResidualIncubateTest,postResolverTests},

				(* Note: Since ExperimentIncubate has only the ResidualIncubation option, whereas SM has the keys ResidualIncubation, ResidualMix, ResidualTemperature and ResidualMixRate,
					we need to do some checks upfront and then do some pre-resolution before calling the ExperimentIncubate option resolver *)

				(* == Check 1: ResidualBlah and Blah need to be identical ==*)

				(* conflicting ResidualMixRate vs MixRate keys *)
				conflictResidualMixRatePrimitives=Module[{resMixRate,mixRate},
					If[KeyExistsQ[expandedParams,ResidualMixRate]&&KeyExistsQ[expandedParams,MixRate],
						resMixRate=Lookup[expandedParams,ResidualMixRate];
						mixRate=Lookup[expandedParams,MixRate];
						If[resMixRate!=mixRate,
							myPrimitive,
							{}],
						{}
					]
				];

				(* Build test for ResidualMixRate vs MixRate *)
				conflictingResidualMixRateTest = If[Length[conflictResidualMixRatePrimitives] > 0,
					validMacroIncubationQ = False;
					If[gatherTests,
						Test[StringTemplate["The ResidualMixRate in the Incubate primitive at index `1` matches the specified MixRate:"][myPrimitiveIndex],True,False],
						Message[Error::InvalidResidualMixRate,myPrimitiveIndex];
						Message[Error::InvalidInput,myPrimitive];
						Null
					],
					If[gatherTests,
						Test[StringTemplate["The ResidualMixRate in the Incubate primitive at index `1` matches the specified MixRate:"][myPrimitiveIndex],True,True],
						Null
					]
				];

				(* conflicting ResidualTemperature and Temperature keys *)
				conflictResidualTemperaturePrimitives=Module[{resTemp,temp},
					If[KeyExistsQ[expandedParams,ResidualTemperature]&&KeyExistsQ[expandedParams,Temperature],
						resTemp=Lookup[expandedParams,ResidualTemperature];
						temp=Lookup[expandedParams,Temperature];
						If[resTemp!=temp,
							myPrimitive,
							{}
						],
						{}
					]
				];

				(* Build test for ResidualTemperature vs Temperature *)
				conflictingResidualTemperatureTest = If[Length[conflictResidualTemperaturePrimitives] > 0,
					validMacroIncubationQ = False;
					If[gatherTests,
						Test[StringTemplate["The ResidualTemperature in the Incubate primitive at index `1` matches the specified Temperature:"][myPrimitiveIndex],True,False],
						Message[Error::InvalidResidualTemperature,myPrimitiveIndex];
						Message[Error::InvalidInput,myPrimitive];
						Null
					],
					If[gatherTests,
						Test[StringTemplate["The ResidualTemperature in the Incubate primitive at index `1` matches the specified Temperature:"][myPrimitiveIndex],True,True],
						Null
					]
				];

				(* == Check 2: ResidualBool cannot be False when ResidualBlah is specified ==*)

				(* conflicting ResidualMixRate vs ResidualMix keys *)
				conflictResidualMixPrimitives=If[KeyExistsQ[expandedParams,ResidualMixRate]&&KeyExistsQ[expandedParams,ResidualMix],
					If[!MatchQ[Lookup[expandedParams,ResidualMixRate],{Null..}]&&!MatchQ[Lookup[expandedParams,ResidualMix],{True..}],
						myPrimitive,
						{}
					],
				{}];

				(* Build test for ResidualMixRate vs ResidualMix *)
				conflictingResidualMixTest = If[Length[conflictResidualMixPrimitives] > 0,
					validMacroIncubationQ = False;
					If[gatherTests,
						Test[StringTemplate["The ResidualMixRate in the Incubate primitive at index `1` is specified when ResidualMix is not False:"][myPrimitiveIndex],True,False],
						Message[Error::InvalidResidualMix,myPrimitiveIndex];
						Message[Error::InvalidInput,myPrimitive];
						Null
					],
					If[gatherTests,
						Test[StringTemplate["The ResidualMixRate in the Incubate primitive at index `1` is specified when ResidualMix is not False:"][myPrimitiveIndex],True,True],
						Null
					]
				];

				(* conflicting ResidualTemperature vs ResidualIncubation keys *)
				conflictResidualIncubationPrimitives=If[KeyExistsQ[expandedParams,ResidualTemperature]&&KeyExistsQ[expandedParams,ResidualIncubation],
					If[!MatchQ[Lookup[expandedParams,ResidualTemperature],{Null..}]&&!MatchQ[Lookup[expandedParams,ResidualIncubation],{True..}],
						myPrimitive,
						{}
					],
				{}];

				(* Build test for ResidualTemperature vs ResidualIncubation *)
				conflictingResidualIncubationTest = If[Length[conflictResidualIncubationPrimitives] > 0,
					validMacroIncubationQ = False;
					If[gatherTests,
						Test[StringTemplate["The ResidualTemperature in the Incubate primitive at index `1` is specified when ResidualIncubation is not False:"][myPrimitiveIndex],True,False],
						Message[Error::InvalidResidualIncubation,myPrimitiveIndex];
						Message[Error::InvalidInput,myPrimitive];
						Null
					],
					If[gatherTests,
						Test[StringTemplate["The ResidualTemperature in the Incubate primitive at index `1` is specified when ResidualIncubation is not False:"][myPrimitiveIndex],True,True],
						Null
					]
				];

				(* == Prepare the ExperimentIncubate Output->Options call  == *)

				(* get the resolved SourceLocation - make sure we're expanding it if it was a single value *)
				expandedSourceLocation= If[MatchQ[Lookup[incubationAssociation,Sample],objectSpecificationP],
					{Lookup[incubationAssociation,ResolvedSourceLocation]},
					Lookup[incubationAssociation,ResolvedSourceLocation]
				];

				(* Fetch any known containers or tagged model containers for sources *)
				expandedSourceContainers = MapThread[
					Function[{source,sourceLocation},
						Which[
						(* Tagged Model container *)
							MatchQ[source,{_Symbol|_String|_Integer,ObjectP[Model[Container]]}],
							source,
						(* Model tag with well *)
							MatchQ[source,{{_Symbol|_String|_Integer,ObjectP[Model[Container]]},_String}],
							source[[1]],
						(* Straight Model container *)
							MatchQ[source,ObjectP[Model[Container]]],
							source,
						(* If source location is a container or container and well, fetch its model from the cache *)
							MatchQ[sourceLocation,ObjectP[Object[Container]]],
							sourceLocation,
							MatchQ[sourceLocation,PlateAndWellP],
							sourceLocation[[1]],
						(* Tagged Model container *)
							MatchQ[source,_String],
						(* extract any subsequent definitions from the definedNamesLookup *)
							If[
								!MatchQ[Lookup[definedNamesLookup, source][Sample], _Missing],
								Lookup[definedNamesLookup, source][Container],
								source
							],
							MatchQ[source,{_String,WellPositionP}],
							source[[1]],
							True,
							Nothing
						]
					],
					{expandedSource,expandedSourceLocation}
				];

				(* If we aren't working with samples, we will simulate them *)
				simulatedIncubatePackets=simulatePrimitiveInputFunction[expandedSource,expandedSourceLocation,expandedSourceSample];

				(* construct the incubate samples (either the source, or the simulated sample *)
				{incubateSamplesByContainer,incubateContainers}=If[!MatchQ[simulatedIncubatePackets,{}],
					Transpose[simulatedIncubatePackets],
					{{},{}}
				];
				incubateSamples=If[!MatchQ[incubateContainers,{}],
					Flatten[incubateSamplesByContainer,1],
					(* notably the source can be provided as Plate and Well, which would break the ExperimentIncubate call below - grab the plate *)
					(* we're loosing information here but that's OK, we'll always assume we incubate this one plate once and if the user gave us multiple samples at different parameters, we'll throw an error *)
					MapThread[If[MatchQ[#2, ObjectP[Object[Sample]]], #2, #1]&, {expandedSource, expandedSourceSample}] /. {{myPlate:(ObjectP[Object[Container, Plate]]), WellP} -> myPlate}
				];

				(* If the options are not specified, fill in Automatic so that we can call ExperimentIncubate below *)
				{incubateMixBooleans,incubateTimes,incubateMixTypes,incubateInstruments,incubateNumberOfMixes,incubateMixVolumes,
					incubateMixUntilDissolved,incubateMaxNumberOfMixes,incubateMaxTimes,incubateAnnealingTimes}=Map[
					If[MissingQ[expandedParams[#]],
						Automatic,
						expandedParams[#]]&,
					{Mix,Time,MixType,Instrument,NumberOfMixes,MixVolume,MixUntilDissolved,MaxNumberOfMixes,MaxTime,AnnealingTime}
				];

				(* If ResidualMixRate is set, resolve MixRate to that value unless it was specified *)
				preResolvedMixRates=If[KeyExistsQ[expandedParams,ResidualMixRate],
					Lookup[expandedParams,ResidualMixRate],
					If[KeyExistsQ[expandedParams,MixRate],
						Lookup[expandedParams,MixRate],
						Automatic
					]
				];

				(* If ResidualTemperature is set, resolve Temperature to that value unless it already was specified *)
				preResolvedTemperatures=If[KeyExistsQ[expandedParams,ResidualTemperature],
					Lookup[expandedParams,ResidualTemperature],
					If[KeyExistsQ[expandedParams,Temperature],
						Lookup[expandedParams,Temperature],
						Automatic
					]
				];

				(* We pre-resolve the ExperimentIncubate option ResidualIncubation depending on whether we have ResidualMixRate, ResidualTemperature, or ResidualMix specified by the user.
					Note that it can also be specified to Null in which case we resolve to False - need to MapThread here*)
				preResolvedResidualIncubation=Module[{resTemp,resMixRate,resMix},
					If[KeyExistsQ[expandedParams,ResidualIncubation],
						Lookup[expandedParams,ResidualIncubation],
						(* if it wasn't set by the user, we look at ResidualMixRate and ResidualTemperature *)
						If[KeyExistsQ[expandedParams,ResidualTemperature]||KeyExistsQ[expandedParams,ResidualMixRate]||KeyExistsQ[expandedParams,ResidualMix],
							resTemp=If[!KeyExistsQ[expandedParams,ResidualTemperature],Table[Null,Length[incubateSamples]],Lookup[expandedParams,ResidualTemperature]];
							resMixRate=If[!KeyExistsQ[expandedParams,ResidualMixRate],Table[Null,Length[incubateSamples]],Lookup[expandedParams,ResidualMixRate]];
							resMix=If[!KeyExistsQ[expandedParams,ResidualMix],Table[Null,Length[incubateSamples]],Lookup[expandedParams,ResidualMix]];
							MapThread[
							(* If either of the specified values are not Null, we turn the boolean to True *)
								If[!NullQ[#1]||!NullQ[#2]||!MatchQ[#3,False],
									True,
									False]&,
								{resTemp,resMixRate,resMix}],
							(* If neither ResidualTemperature or ResidualMixRate or ResidualMix are specified, we set ResidualIncubation to Automatic *)
							Automatic
						]
					]
				];

				preResolverTests={conflictingResidualMixRateTest,conflictingResidualTemperatureTest,conflictingResidualMixTest,conflictingResidualIncubationTest};

				(* Call ExperimentIncubate to resolve the options for the Macro Incubate primitive *)
				{macroIncubateOptions,macroIncubateTests}=If[gatherTests,
					Module[{options,tests},
						{options,tests}=ExperimentIncubate[
							incubateSamples,
							Mix->incubateMixBooleans,
							Temperature->preResolvedTemperatures,
							MixRate->preResolvedMixRates,
							Time->incubateTimes,
							MixType -> incubateMixTypes,
							Instrument -> incubateInstruments,
							NumberOfMixes -> incubateNumberOfMixes,
							MixVolume -> incubateMixVolumes,
							MixUntilDissolved -> incubateMixUntilDissolved,
							MaxNumberOfMixes -> incubateMaxNumberOfMixes,
							MaxTime ->incubateMaxTimes,
							AnnealingTime->incubateAnnealingTimes,
							ResidualIncubation->preResolvedResidualIncubation,
							Cache->Flatten[simulatedIncubatePackets],
							Aliquot->False,
							EnableSamplePreparation->False,
							OptionsResolverOnly -> True,
							Output->{Options,Tests}
						];
						If[RunUnitTest[<|"Tests"->tests|>,OutputFormat->SingleBoolean,Verbose->False],
							{options,tests},
							{$Failed,tests}
						]
					],
					(
						{
							Check[
								ExperimentIncubate[
									incubateSamples,
									Mix->incubateMixBooleans,
									Temperature->preResolvedTemperatures,
									MixRate->preResolvedMixRates,
									Time->incubateTimes,
									MixType -> incubateMixTypes,
									Instrument -> incubateInstruments,
									NumberOfMixes -> incubateNumberOfMixes,
									MixVolume -> incubateMixVolumes,
									MixUntilDissolved -> incubateMixUntilDissolved,
									MaxNumberOfMixes -> incubateMaxNumberOfMixes,
									MaxTime ->incubateMaxTimes,
									AnnealingTime->incubateAnnealingTimes,
									ResidualIncubation->preResolvedResidualIncubation,
									Cache->Flatten[simulatedIncubatePackets],
									Aliquot->False,
									EnableSamplePreparation->False,
									OptionsResolverOnly -> True,
									Output->Options],
								$Failed,
								{Error::InvalidInput,Error::InvalidOption}
							],
							(* no tests to pass *)
							{}
						}
					)
				];

				(* we map over the samples (simulated or not) and convert plates and containers into samples if needed, constructed a nested list lik {{s1,s2},{s3},...} *)
				(* we can't just use SourceSample since that does not contain the simulated samples *)
				sourceSampleObjects=Map[Function[{sample},
					Switch[sample,
					(* if we're dealing with a plate we take all samples *)
						ObjectReferenceP[Object[Container,Plate]],
						Lookup[#,Object]&/@Select[allPackets,MatchQ[sample,Download[Lookup[#,Container],Object]]&],
					(* if we're dealing with a container we assume it contains only one sample *)
						ObjectReferenceP[Object[Container,Vessel]],
						{Lookup[SelectFirst[allPackets,MatchQ[sample,Download[Lookup[#,Container],Object]]&,Null],Object]},
					(* if it's a sample already we can simply keep that *)
						ObjectReferenceP[Object[Sample]],
						{sample},
						PacketP[Object[Sample]],
					(* if it's a packet we're dealing with a simulated sample, grab the object ID *)
						{Lookup[sample,Object]},
					(* catch all *)
						_,
						{sample}
					]],
					incubateSamples
				];

				sourceContainerObjects=Switch[{expandedSourceContainers,incubateContainers},
					(* we are not simulating, we simply grab the source containers list *)
					{{ObjectP[Object[Container]]..},{}},
						expandedSourceContainers,
					(* if we're simulating, grab the containers from the simulation packet *)
					{{_String..},{_?AssociationQ..}},
							Lookup[incubateContainers,Object],
					(* catch all just in case *)
					_,
							expandedSourceContainers
				];

				(* Importantly: ExperimentIncubate will always turn containers into samples *)
				(* This means some options are not indexmatched to the Sample key anymore, since that can contain plates, but to the actual samples inside the containers *)
				(* Some options are collapsed to singletons, if all samples want the same parameter *)
				(* To construct the primitives below, we expand all indexmatched options to containers, and not samples, using our special helper *)
				expandedOptions=If[!MatchQ[macroIncubateOptions,$Failed],
					collapseMacroOptionsToContainers[ExperimentIncubate, sourceSampleObjects,sourceContainerObjects, macroIncubateOptions],
					$Failed
				];

				(* switch the error-tracking variable here if the option resolution failed (make sure to leave it False if it was already set before) *)
				validMacroIncubationQ=If[MatchQ[expandedOptions,$Failed],False,validMacroIncubationQ];

				(* == resolve ResidualMix, ResidualMixRate and ResidualTemperature manually since our ExperimentIncubate doesn't do that for us == *)

				(* Resolve the Boolean ResidualMix depending on ResidualIncubation and whether we have a MixRate *)
				resolvedResidualMix=If[!MatchQ[macroIncubateOptions,$Failed]&&!KeyExistsQ[expandedParams,ResidualMix],
					MapThread[
					(* If ResidualIncubation resolved to True, and we have a MixRate, we know we're also doing ResidualMix, so set to True *)
						If[TrueQ[#1]&&!NullQ[#2],
							True,
							False
						]&,
						{Lookup[expandedOptions,ResidualIncubation],Lookup[expandedOptions,MixRate]}
					],
					(* If we reach this, the option resolution failed or we have a ResidualMix specified to start with *)
					If[KeyExistsQ[expandedParams,ResidualMix],
						(* if it was set to begin with, we use that *)
						(* notably the expandedParams is indexmatched to the Sample key, which may contain samples within the same plate *)
						(* we collapse to unique containers as we did with the other resolved options *)
						First /@ SplitBy[Transpose[{Lookup[expandedParams, ResidualMix],expandedSourceContainers}], Last][[All, 1]],
						(* otherwise, default to False *)
						Table[False,Length[DeleteDuplicates[expandedSourceContainers]]]
					]
				];

				(* If we don't have any ResidualMixRate in the original primitive, but the ResidualMix bool is True, we resolve ResidualMixRate to whatever the MixRate was resolved to *)
				resolvedResidualMixRate=If[!MatchQ[macroIncubateOptions,$Failed],
					If[KeyExistsQ[expandedParams,ResidualMixRate],
					(* if it was set to begin with, we use that *)
					(* notably the expandedParams is indexmatched to the Sample key, which may contain samples within the same plate *)
					(* we collapse to unique containers as we did with the other resolved options *)
						First /@ SplitBy[Transpose[{Lookup[expandedParams, ResidualMixRate],expandedSourceContainers}], Last][[All, 1]],
					(* If we're here, we know that the option resolution has not failed, and that we did not have ResidualMixRate specified by the user *)
						MapThread[
							(* If ResidualMix resolved to True, we set ResidualMixRate to whatever MixRate was resolved to *)
							If[MatchQ[#1,True],
								#2,
								Null
							]&,
							{resolvedResidualMix,Lookup[expandedOptions,MixRate]}
						]
					],
					(* If the option resolution failed we set everything to Null *)
					Table[Null,Length[DeleteDuplicates[expandedSourceContainers]]]
				];

				(* If we don't have the ResidualTemperature in the original primitive, but the ResidualIncubation is True, we resolve ResidualTemperature to whatever the Temperature was resolved to *)
				resolvedResidualTemperature=If[!MatchQ[macroIncubateOptions,$Failed],
					If[KeyExistsQ[expandedParams,ResidualTemperature],
						(* if it was set to begin with, we use that *)
						(* notably the expandedParams is indexmatched to the Sample key, which may contain samples within the same plate *)
						(* we collapse to unique containers as we did with the other resolved options *)
						First /@ SplitBy[Transpose[{Lookup[expandedParams, ResidualTemperature],expandedSourceContainers}], Last][[All, 1]],
						(* If we're here, we know that the option resolution has not failed, and that we did not have ResidualTemperature specified by the user *)
						MapThread[
						(* If ResidualIncubation resolved to True, we set ResidualTemperature to whatever Temperature was resolved to *)
							If[MatchQ[#1,True],
								#2,
								Null
							]&,
							{Lookup[expandedOptions,ResidualIncubation],Lookup[expandedOptions,Temperature]}
						]
					],
					(* If the option resolution failed we set everything to Null *)
					Table[Null,Length[DeleteDuplicates[expandedSourceContainers]]]
				];

				(* == Throw post-resolution errors regarding ResidualMix and ResidualIncubation  == *)

				(* We can't have ResidualMix user-specified to False when ResidualIncubation is set or resolved to True *)
				(* This is because in ExperimentIncubate, we can only keep heating AND mixing, or not do either *)
				conflictingResidualBooleansPrimitives=If[!MatchQ[macroIncubateOptions,$Failed],
					MapThread[
					(* If ResidualIncubation resolved to True and ResidualMix is False (it will never resolve to False so it was user specified), and we have a MixRate, we need to throw an errior *)
						If[MatchQ[#1,False]&&MatchQ[#2,True]&&!NullQ[#3],
							myPrimitive,
							Nothing
						]&,
						{resolvedResidualMix,Lookup[expandedOptions,ResidualIncubation],Lookup[expandedOptions,MixRate]}
					],
					{}
				];

					(* Build test for ResidualMix vs ResidualIncubation *)
				conflictingResidualBooleansTest = If[Length[conflictingResidualBooleansPrimitives] > 0,
					validMacroIncubationQ = False;
					If[gatherTests,
						Test[StringTemplate["In the Incubate primitive at index `1` ResidualMix does not conflict with ResidualIncubation:"][myPrimitiveIndex],True,False],
						Message[Error::ResidualMixNeeded,myPrimitiveIndex,Lookup[expandedOptions,MixRate]];
						Message[Error::InvalidInput,myPrimitive];
						Null
					],
					If[gatherTests,
						Test[StringTemplate["In the Incubate primitive at index `1` ResidualMix does not conflict with ResidualIncubation:"][myPrimitiveIndex],True,True],
						Null
					]
				];

				(* We can't have ResidualMix user-specified to True when ResidualIncubation is set or resolved to False *)
				(* This is because in ExperimentIncubate, we can only keep heating AND mixing, or not do either *)
				conflictingResidualIncubatePrimitives=If[!MatchQ[macroIncubateOptions,$Failed],
					MapThread[
					(* If ResidualIncubation was specified or resolved to False and ResidualMix is True we need to throw an error *)
						If[MatchQ[#1,True]&&MatchQ[#2,False],
							myPrimitive,
							Nothing
						]&,
						{resolvedResidualMix,Lookup[expandedOptions,ResidualIncubation]}
					],
					{}
				];

				(* Build test for ResidualMix vs ResidualIncubation *)
				conflictingResidualIncubateTest = If[Length[conflictingResidualIncubatePrimitives] > 0,
					validMacroIncubationQ = False;
					If[gatherTests,
						Test[StringTemplate["In the Incubate primitive at index `1` ResidualIncubation does not conflict with ResidualMix:"][myPrimitiveIndex],True,False],
						Message[Error::ResidualIncubationNeeded,myPrimitiveIndex];
						Message[Error::InvalidInput,myPrimitive];
						Null
					],
					If[gatherTests,
						Test[StringTemplate["In the Incubate primitive at index `1` ResidualIncubation does not conflict with ResidualMix:"][myPrimitiveIndex],True,True],
						Null
					]
				];

				postResolverTests={conflictingResidualBooleansTest,conflictingResidualIncubateTest};

				(* Return the resolved primitive, and the tests *)
				{
					If[MatchQ[expandedOptions,$Failed],
						(* if the resolution returned failed, we return the primitive as it was *)
						Incubate[expandedParams],
						Incubate[
							Append[expandedParams,
								{
									(* replace the Macro keys with the resolved expanded values *)
									Temperature->Lookup[expandedOptions,Temperature],
									Time->Lookup[expandedOptions,Time],
									Mix -> Lookup[expandedOptions, Mix],
									MixRate -> Lookup[expandedOptions,MixRate],
									MixType -> Lookup[expandedOptions,MixType],
									Instrument -> Lookup[expandedOptions,Instrument],
									NumberOfMixes -> Lookup[expandedOptions,NumberOfMixes],
									MixVolume -> Lookup[expandedOptions,MixVolume],
									MixUntilDissolved -> Lookup[expandedOptions,MixUntilDissolved],
									MaxNumberOfMixes -> Lookup[expandedOptions,MaxNumberOfMixes],
									MaxTime -> Lookup[expandedOptions,MaxTime],
									AnnealingTime -> Lookup[expandedOptions,AnnealingTime],
									ResidualIncubation -> Lookup[expandedOptions,ResidualIncubation],
									(* add the keys we resolved ourselves since missing in ExperimentIncubate *)
									ResidualMix -> resolvedResidualMix,
									ResidualMixRate -> resolvedResidualMixRate,
									ResidualTemperature -> resolvedResidualTemperature
									(* ignore Micro keys *)
								}
							]
						]
					],
					Join[macroIncubateTests,preResolverTests,postResolverTests],
					validMacroIncubationQ
				}
			]
		]
	];

	(* Find positions for Incubate primitives in specified manipulations. This may differ from
	rawIncubatePrimitivePositions since we may have split transfers. *)
	incubatePositions = Flatten@Position[manipulationsWithResolvedReadPlates,_Incubate,{1}];

	(* Extract actual primitives *)
	incubatePrimitives = manipulationsWithResolvedReadPlates[[incubatePositions]];

	(* For the Incubate resolver, we need to know whether the primitive wants Micro or Macro. We go with whichever keys are specified in the raw manipulation *)
	(* Note that if we have conflicting keys, or if we have primitives that want different scale, we don't care at this point - we have either thrown errors above or will throw error inside the resolveLiquidHandling *)
	(* At this point we just want to make sure we don't overwrite any keys that were defined by the user *)
	scaleByIncubateKeys = Map[
		Function[primitive,
			Which[
				(* for all Non-Incubate primitives, simply put Null since we don't care about them *)
				!MatchQ[primitive,_Incubate],Null,
				(* if the liquid handling scale is specified, we use that *)
				MatchQ[specifiedScale,MacroLiquidHandling|Bufferbot],MacroLiquidHandling,
				MatchQ[specifiedScale,MicroLiquidHandling],MicroLiquidHandling,
				(* if there are keys specific for macro keys, we go with macro *)
				And[MatchQ[primitive,_Incubate], MemberQ[Keys[First[primitive]],macroOnlyIncubateOptions]],MacroLiquidHandling,
				And[
					MatchQ[primitive,_Incubate],
					Or@@(!MemberQ[Keys[First[primitive]],#]&/@microRequiredOptions)
				],MacroLiquidHandling,
				(* If there are no macro keys, we default to the resolved scale *)
				And[MatchQ[primitive,_Incubate]], scaleToUseForFurtherResolving,
				True,scaleToUseForFurtherResolving
			]
		],
		incubatePrimitives
	];

	(* Resolve the Incubate primitives. Pass in positions for Incubate primitives from raw input primitives
	since we may have split transfers upstream. *)
	{resolvedIncubatePrimitives,incubationMacroTests,validMacroIncubationBooleans} = If[Length[incubatePositions]>0,
		Transpose@MapThread[
			resolveIncubationFunction[#1,#2,#3]&,
			{incubatePrimitives,rawIncubatePrimitivePositions,scaleByIncubateKeys}
		],
		{{},{},{True}}
	];

	(* Replace relevant primitives with resolved incubations  *)
	manipulationsWithResolvedIncubations = If[Length[resolvedIncubatePrimitives]>0,
		ReplacePart[
			manipulationsWithResolvedReadPlates,
			MapThread[
				Rule,
				{incubatePositions,resolvedIncubatePrimitives}
			]
		],
		manipulationsWithResolvedReadPlates
	];

	(* if any of the incubations are invalid, we will throw InvalidOption error below *)
	validMacroIncubationsQ=AllTrue[validMacroIncubationBooleans, TrueQ];


	(* make a helper to generate tests for the micro incubate primitives *)
	validMicroIncubationsQ = True;
	generateIncubationTests[incubation_Incubate,primitiveIndex_Integer]:=Module[
		{sourceModelContainers,sourceModelContainerPackets,footprints,footprintTest,
			sourceContainers,gatheredIncubationParamTuples,duplicateIncubationTests,mixRates,temperatures},

	(* Fetch any known model containers for incubation sources *)
		sourceModelContainers = MapThread[
			Function[{source,sourceLocation},
				Which[
				(* Tagged Model container *)
					MatchQ[source,{_Symbol|_String|_Integer,ObjectP[Model[Container]]}],
					source[[2]],
				(* Model tag with well *)
					MatchQ[source,{{_Symbol|_String|_Integer,ObjectP[Model[Container]]},_String}],
					source[[1,2]],
				(* Straight Model container *)
					MatchQ[source,ObjectP[Model[Container]]],
					source,
				(* If source location is a container or container and well, fetch its model from the cache *)
					MatchQ[sourceLocation,ObjectP[Object[Container]]],
					Download[Lookup[fetchPacketFromCacheHPLC[sourceLocation,allPackets],Model],Object],
					MatchQ[sourceLocation,PlateAndWellP],
					Download[Lookup[fetchPacketFromCacheHPLC[sourceLocation[[1]],allPackets],Model],Object],
				(* Tagged Model container *)
					MatchQ[source,_String],
					fetchDefineModelContainer[Lookup[definedNamesLookup,source],Cache->allPackets],
					True,
					Nothing
				]
			],
			{incubation[Sample],incubation[ResolvedSourceLocation]}
		];

		(* Get packets for model containers *)
		sourceModelContainerPackets = fetchPacketFromCacheHPLC[#,allPackets]&/@DeleteCases[sourceModelContainers,Null];

		(* Extract footprint from model containers *)
		footprints = sourceModelContainerPackets[[All,Key[Footprint]]];

		(* Only Plates or CE Vials can fit on the Heater/Shakers *)
		footprintTest = If[!MatchQ[footprints,{(CEVial|Plate|GlassReactionVessel|AvantVial)...}],
			validMicroIncubationsQ = False;
			If[gatherTests,
				Test[StringTemplate["Containers used in the Incubate at index `1` all have a Plate or CEVial footprint:"][primitiveIndex],True,False],
				Message[Error::IncompatibleIncubationFootprints,primitiveIndex];
				Message[Error::InvalidInput,myRawManipulations[[primitiveIndex]]];
				Null
			],
			If[gatherTests,
				Test[StringTemplate["Containers used in the Incubate at index `1` all have a Plate or CEVial footprint:"][primitiveIndex],True,True],
				Null
			]
		];

		(* Fetch any known containers or tagged model containers for incubation sources *)
		sourceContainers = MapThread[
			Function[{source,sourceLocation},
				Which[
				(* Source Location is a straight up container *)
					MatchQ[sourceLocation,ObjectP[Object[Container]]],
					sourceLocation,
					MatchQ[sourceLocation,PlateAndWellP],
					sourceLocation[[1]],
				(* Source location is a tagged model container *)
					MatchQ[source,{_Symbol|_String|_Integer,ObjectP[Model[Container]]}],
					source,
				(* Source location is a tagged model container or something else *)
				(* Use source as the catch-all because we need index-matching for downstream tests *)
					True,
					source
				]
			],
			{incubation[Sample],incubation[ResolvedSourceLocation]}
		];

		(* Gather tuples of incubation parameters by the source location *)
		gatheredIncubationParamTuples = GatherBy[
			Transpose[{sourceContainers,incubation[Time],incubation[Temperature],incubation[MixRate]}],
			#[[1]]&
		];

		(* The same container cannot be incubated simultaneously with different Time, Temperature, or MixRate.
		Check that the specified parameters for a group of sources in the same container are all the same. *)
		duplicateIncubationTests = Map[
			If[Length[#]>1,
				If[!(SameQ@@(#[[All,2;;]])),
					validMicroIncubationsQ = False;
					If[gatherTests,
						Test[StringTemplate["The Incubate primitive at index `1` specifies distinct containers for distinct incubation time, temperature, and mix rates:"][primitiveIndex],True,False],
						Message[Error::ConflictingIncubation,primitiveIndex];
						Message[Error::InvalidInput,myRawManipulations[[primitiveIndex]]];
						Nothing
					],
					If[gatherTests,
						Test[StringTemplate["The Incubate primitive at index `1` specifies distinct containers for distinct incubation time, temperature, and mix rates:"][primitiveIndex],True,True],
						Nothing
					]
				],
				Nothing
			]&,
			gatheredIncubationParamTuples
		];

		(* Get Temperature*)
		temperatures = ToList[incubation[Temperature]];
		(* Get MixRates*)
		mixRates = ToList[incubation[MixRate]];
		(* We cannot cool and shake at the same time *)
		conflictingCoolingShakingTest = MapThread[
			If[!MatchQ[#1,Ambient] && #1<$AmbientTemperature && MatchQ[#2,GreaterP[0RPM]],
				validMicroIncubationsQ = False;
				If[gatherTests,
					Test[StringTemplate["The Incubate primitive at index `1` does not specify cooling and mix at the same time:"][primitiveIndex],True,False];
					Message[Error::ConflictingCoolingShaking,primitiveIndex];
					Message[Error::InvalidInput,myRawManipulations[[primitiveIndex]]],

					Message[Error::ConflictingCoolingShaking,primitiveIndex];
					Message[Error::InvalidInput,myRawManipulations[[primitiveIndex]]]
				],
				If[gatherTests,
					Test[StringTemplate["The Incubate primitive at index `1` does not specify cooling and mix at the same time:"][primitiveIndex],True,True],
					Nothing
				]
			]&,
			{temperatures,mixRates}
		];

		DeleteCases[Flatten[{footprintTest,duplicateIncubationTests,conflictingCoolingShakingTest}],Null]
	];




	(* Extract specified Micro incubate primitives *)
	allMicroIncubatePositions = Flatten[Position[scaleByIncubateKeys, MicroLiquidHandling]];

	(* Extract all Incubations that will be left on the heater/shaker  *)
	residualIncubations = DeleteDuplicatesBy[
		Select[
			resolvedIncubatePrimitives[[allMicroIncubatePositions]],
			Or[MemberQ[#[ResidualIncubation],True],MemberQ[#[ResidualMix],True]]&
		],
		(#[Sample])&
	];

	(* Fetch any known containers or tagged model containers for incubation sources *)
	residualIncubationContainers = DeleteDuplicates[
		Join@@Map[
			MapThread[
				Function[{source,sourceLocation,residualIncubationQ,residualMixQ},
					If[Or[TrueQ[residualIncubationQ],TrueQ[residualMixQ]],
						Which[
						(* Source Location is a straight up container *)
							MatchQ[sourceLocation,ObjectP[Object[Container]]],
							sourceLocation,
							MatchQ[sourceLocation,PlateAndWellP],
							sourceLocation[[1]],
						(* Source location is a tagged model container *)
							MatchQ[source,{_Symbol|_String|_Integer,ObjectP[Model[Container]]}],
							source,
						(* Source location is a tagged model container *)
							MatchQ[source,_String],
							{source,fetchDefineModelContainer[Lookup[definedNamesLookup,source],Cache->allPackets]},
							True,
							Nothing
						],
						Nothing
					]
				],
				{#[Sample],#[ResolvedSourceLocation],#[ResidualIncubation],#[ResidualMix]}
			]&,
			residualIncubations
		]
	];

	(* If any vials exist, assume they are in the correct footprint and will all fit in a single rack
	(therefore they will only require 1 incubator) *)
	numberOfIncubatorsRequired = If[
		MemberQ[
			residualIncubationContainers,
			Alternatives[
				ObjectP[{Object[Container,Vessel],Model[Container,Vessel]}],
				{_Symbol|_String|_Integer,ObjectP[Model[Container,Vessel]]}
			]
		],
		Length[
			DeleteCases[
				residualIncubationContainers,
				Alternatives[
					ObjectP[{Object[Container,Vessel],Model[Container,Vessel]}],
					{_Symbol|_String|_Integer,ObjectP[Model[Container,Vessel]]}
				]
			]
		] + 1,
		Length[residualIncubationContainers]
	];

	incubationOverflowTest = If[numberOfIncubatorsRequired > 4,
		(
			validMicroIncubationsQ = False;
			If[gatherTests,
				Test["A maximum of four incubation positions are used simultaneously:",True,False],
				Message[Error::TooManyIncubationContainers,residualIncubations];
				Message[Error::InvalidInput,residualIncubations];
				Null
			]
		),
		If[gatherTests,
			Test["A maximum of four incubation positions are used simultaneously:",True,True],
			Null
		]
	];

	(* Pass Incubation Micro primitive and its index to test-building function  *)
	incubationTests = Join[
		(* create the micro incubate tests *)
		Join@@MapThread[
			generateIncubationTests[#1,#2]&,
			{resolvedIncubatePrimitives[[allMicroIncubatePositions]],rawIncubatePrimitivePositions[[allMicroIncubatePositions]]}
		],
		If[NullQ[incubationOverflowTest],
			{},
			{incubationOverflowTest}
		],
		(* also add here the conflict tests and the macro incubate tests *)
		conflictingIncubatePrimitiveTests,
		missingKeysTests,
		conflictingIncubateWithScaleTests,
		incubationMacroTests
	];

	validMixKeysQ = True;
	(* Generate test for required keys in Mix primitives *)
	mixKeysTest = Module[
		{mixPrimitivePositions,mixPrimitives,validKeysBools,invalidKeysPositions},


		(* Find the positions for any Mix by pipetting primitives *)
		(* need to do the listy one here because of Resuspend primitives potentially generating more Mixes*)
		mixPrimitivePositions = Flatten[Position[listyConvertedMixIncubatePrimitives, {Repeated[_Transfer, {0, 1}], _Mix}, {1}]];

		(* Extract these primitives *)
		mixPrimitives = convertedMixIncubatePrimitives[[mixPrimitivePositions]];

		(* Build list of bools representing the validity of their keys *)
		validKeysBools = Map[
			(* mixing primitives are always the last of the list because either it's a list of length 2 (from a Resuspend) or just a singleton *)
			With[{mix = Last[#]},
				And[
					!MissingQ[mix[NumberOfMixes]],
					!MissingQ[mix[MixVolume]]
				]
			]&,
			mixPrimitives
		];

		(* Find invalid positions *)
		invalidKeysPositions = PickList[mixPrimitivePositions,validKeysBools,False];

		If[Length[invalidKeysPositions] > 0,
			validMixKeysQ = False;
			If[gatherTests,
				Test[StringTemplate["The Mix primitives at the positions `1` specify MixVolume and NumberOfMixes:"][invalidKeysPositions],True,False],
				Message[Error::MissingMixKeys,invalidKeysPositions];
				Message[Error::InvalidInput,myRawManipulations[[invalidKeysPositions]]];
			],
			If[gatherTests,
				Test[StringTemplate["The Mix primitives at the positions `1` specify MixVolume and NumberOfMixes:"][invalidKeysPositions],True,True],
				Null
			]
		]
	];

	(* Generate the required objects lookup that will be used to pick the appropriate resources,
	and resolve the right models in the right places; this action depends heavily on correct tagging
	of container models, water sources, and model sample resources in above steps;
	also create Resource blobs if necessary *)
	requiredObjects = Module[
		{incubatedModels,modelAmountRulesByManipulation,sampleAmountRules,uniqueSampleAmountLookup,modelToRentContainerBoolLookup,
		modelAmountRules,uniqueModelAmountLookup,nonZeroModelAmountLookup,modelResources,taggedModelContainerRentContainerBoolTuples,
		allTags,ftvPrimitives,ftvVolumetricSources,uniqueModelContainerRentContainerTuples,modelContainerResources,emptyContainers,
		sampleResourcePackets,sampleResources,counterweights,counterweightResources,magnet,magnetResource},

		(* Generate a list of rules relating any sample model (tagged or untagged) from the manips with the amount of it that is needed *)
		modelAmountRulesByManipulation = Map[
			Switch[#,
				_Transfer,
					Join@@MapThread[
						Switch[#1,
							modelP,
								#1->#2,
							_String,
								(* If tag represents a model, associate the amount with the tag *)
								If[MatchQ[Lookup[definedNamesLookup,#1][Sample],NonSelfContainedSampleModelP],
									#1->#2,
									Nothing
								],
							_,
								Nothing
						]&,
						{#[Source],#[Amount]},
						2
					],
				_FillToVolume,
					Switch[#[Source],
						modelP,
							{#[Source]->#[FinalVolume]},
						_String,
							(* If tag represents a model, associate the amount with the tag *)
							If[MatchQ[Lookup[definedNamesLookup,#[Source]][Sample],NonSelfContainedSampleModelP],
								{#[Source]->#[FinalVolume]},
								{}
							],
						_,
							{}
					],
				_Incubate|_Centrifuge,
					Map[
						Switch[#,
							modelP,
								#->0 Milliliter,
							_String,
								(* If tag represents a model, associate the amount with the tag *)
								If[MatchQ[Lookup[definedNamesLookup,#][Sample],NonSelfContainedSampleModelP],
									#->0 Milliliter,
									Nothing
								],
							_,
								Nothing
						]&,
						#[Sample]
					],
				_MoveToMagnet|_RemoveFromMagnet,
					Switch[#[Sample],
						modelP,
						{#[Sample]->0 Milliliter},
						_String,
						(* If tag represents a model, associate the amount with the tag *)
						If[MatchQ[Lookup[definedNamesLookup,#[Sample]][Sample],NonSelfContainedSampleModelP],
							{#[Sample]->0 Milliliter},
							{}
						],
						_,
						{}
					],
				_Pellet,
					Join@@MapThread[
						Function[{source, supernatantVolume, resuspensionSource, resuspensionVolume},
							{
								(* Create a rule for the source sample. *)
								Switch[source,
									modelP,
										source->supernatantVolume/.{All->0 Milliliter},
									_String,
										(* If tag represents a model, associate the amount with the tag *)
										If[MatchQ[Lookup[definedNamesLookup,source][Sample],NonSelfContainedSampleModelP],
											source->supernatantVolume/.{All->0 Milliliter},
											Nothing
										],
									_,
										Nothing
								],

								(* Create a rule for the resuspension source sample. *)
								Switch[resuspensionSource,
									modelP,
										resuspensionSource->resuspensionVolume/.{All->0 Milliliter},
									_String,
										(* If tag represents a model, associate the amount with the tag *)
										If[MatchQ[Lookup[definedNamesLookup,resuspensionSource][Sample],NonSelfContainedSampleModelP],
											resuspensionSource->resuspensionVolume/.{All->0 Milliliter},
											Nothing
										],
									_,
										Nothing
								]
							}
						],
						{#[Sample],#[SupernatantVolume],#[ResuspensionSource],#[ResuspensionVolume]}
					],
				_,
					{}
			]&,
			manipulationsWithResolvedIncubations
		];

		(* Build rules for the amount used of each sample (if primitives use a specific sample) *)
		sampleAmountRules = Flatten@Map[
			Switch[#,
				_Transfer,
					MapThread[
						If[!NullQ[#1],
							#1 -> #2,
							Nothing
						]&,
						{#[SourceSample],#[Amount]},
						2
					],
				_Pellet,
					MapThread[
						{
							If[!NullQ[#1],
								#1 -> #2/.{All->0 Milliliter},
								Nothing
							],
							If[!NullQ[#3],
								#3 -> #4/.{All->0 Milliliter},
								Nothing
							]
						}&,
						{#[SourceSample],#[SupernatantVolume],#[ResuspensionSourceSample],#[ResuspensionVolume]}
					],
				_FillToVolume,
					If[!NullQ[#[SourceSample]],
						#[SourceSample] -> #[FinalVolume],
						Nothing
					],
				_,
					Nothing
			]&,
			manipulationsWithResolvedIncubations
		];

		(* Merge the rules into a single lookup indicating the total amount needed of each unique sample *)
		uniqueSampleAmountLookup = Merge[sampleAmountRules,Total];

		(* Any model requests in Incubate primitives must be resolved with a plate *)
		incubatedModels = Join@@Map[
			Map[
				Switch[#,
					modelP,
						#,
					_String,
						(* If tag represents a model *)
						If[MatchQ[Lookup[definedNamesLookup,#][Sample],NonSelfContainedSampleModelP],
							#,
							Nothing
						],
					_,
						Nothing
				]&,
				#[Sample]
			]&,
			Cases[manipulationsWithResolvedIncubations,_Incubate]
		];

		(* create a lookup that takes all of the {tag,model} from the above list of {tag,model}->amount and associate with the RentContainer bool for the resource the manip prepares (if any) *)
		modelToRentContainerBoolLookup = Association@DeleteDuplicates@Flatten@MapThread[
			Function[{modAmountRules,rentContainerBool},
				(#->rentContainerBool&)/@modAmountRules[[All,1]]
			],
			{modelAmountRulesByManipulation,expandedRentContainerBools}
		];

		(* flatten the model amount rules so we can merge-group them *)
		modelAmountRules = Flatten[modelAmountRulesByManipulation];

		(* merge the rules into a single lookup indicating the total amount needed of each unique model; this will only merge like-tagged models *)
		uniqueModelAmountLookup = Merge[modelAmountRules,Total];

		(* Delete any models of which we require nothing. If we were to include this, we'd be trying to
		pick samples with 0 volume/mass for no reason. This usually happens if someone defines a "model"
		that is only ever used as a destination (ie: it never needs its own amount to start)  *)
		nonZeroModelAmountLookup = Association@KeyValueMap[
			Function[{tag,amount},
				If[
					(* If the model is a Defined name, but none is required, and its container is defined,
					remove it from this lookup since we only need to pick the container. If the container is not defined,
					we'll pick the model, even though the amount will be 0ul. *)
					And[
						MatchQ[tag,_String],
						QuantityMagnitude[amount] == 0,
						MatchQ[Lookup[definedNamesLookup,tag][Container],ObjectP[]]
					],
					Nothing,
					tag -> amount
				]
			],
			uniqueModelAmountLookup
		];

		(* Before going into the resource prep, need to know which resource are actually sources for a volumetric FtV since we'll insist those to be in a container
		that's easy to access (no hermetics or pumps)*)

		ftvPrimitives = Cases[manipulationsWithResolvedIncubations,_FillToVolume];
		ftvVolumetricSources = If[!MatchQ[ftvPrimitives,{}],
			Cases[#[Source]&/@ftvPrimitives,{_Symbol,_}],
			{}
		];

		(* use the lookup to create resources for each of the unique models/tagged models *)
		modelResources = KeyValueMap[
			Function[{sourceModel,totalAmount},
				Module[{modelObject,calculatedAmountToRequest,amountToRequest,containerModelToRequest,rentContainerBool,autoclaveQ,maxTemp},

					(* isolate just the model if it's tagged *)
					modelObject = Switch[sourceModel,
						_String,
							Lookup[definedNamesLookup,sourceModel][Sample],
						{_Symbol|_String|_Integer,ObjectReferenceP[Model[Sample]]},
							Last[sourceModel],
						_,
							sourceModel
					];

					(* we have a problem if the total amount of a model we need exceeds 250mL (what we can fit in a robot-friendly container)
					 	and the desired liquid handling scale is Micro; this should be pretty hard to manage *)
					If[MatchQ[scaleToUseForFurtherResolving,MicroLiquidHandling]&&totalAmount>250 Milliliter,
						Message[Error::ModelOverMicroMax,sourceModel,totalAmount];
						Message[Error::InvalidInput,myRawManipulations];
						Return[$Failed,Module]
					];

					(* determine how much of the model to request; be conscious of the special cases:
					 	- it is water (request differently depending on scale)
						- it is required at the limit of the max amount of a single sample *)
					calculatedAmountToRequest=Which[
						MatchQ[modelObject,WaterModelP]&&MatchQ[scaleToUseForFurtherResolving,MicroLiquidHandling],200 Milliliter,
						MatchQ[modelObject,WaterModelP]&&!VolumeQ[totalAmount],totalAmount,
						MatchQ[modelObject,WaterModelP],Module[{waterVolume},

							(* ask for more, unless it'll put us over the water-in-vessel gathering threshold;
							 	only applicable for manual (bufferbot may need a source over the pour threshold) *)
							waterVolume=Min[totalAmount*1.1,20 Liter];

							(* Scale up to the nearest amount that the purifier dispenses *)
							SelectFirst[Join[{15,50,100,250,500,750,1000},Range[1250,5000,250],Range[6000,20000,1000]]*Milliliter,#>=waterVolume&]
						],

						(* If the amount requested is an integer (tablets), request the exact amount *)
						IntegerQ[totalAmount],totalAmount,

						(* otherwise, we wanna get a little more than we need, unless that'll put us over a max amount *)
						True,Module[{modelMaxAmount,bufferedAmount},

							(* use the previously-assembled model max info to see if we have a known max amount per single sample for this model;
							 	this will be Null if we don't know, or some number *)
							modelMaxAmount=Lookup[AssociationThread[Lookup[allSpecifiedModelPackets,Object],modelMaxAmounts],Download[modelObject,Object]];

							(* add a buffer of 10% to the amount we need, unless that'll put us over the limit *)
							bufferedAmount = If[CompatibleUnitQ[modelMaxAmount,totalAmount],
								(* If totalAmount is less than or equal to the max product amount but the totalAmount with a buffer is greater,
								just request the max product amount, otherwise keep the buffer. *)
								If[totalAmount<=modelMaxAmount<(totalAmount*1.1),
									modelMaxAmount,
									totalAmount*1.1
								],
								totalAmount*1.1
							];

							(* make sure not to bump us out of Micro range by asking for more of a model than can fit in the largest robot container *)
							If[MatchQ[scaleToUseForFurtherResolving,MicroLiquidHandling],
								(* If amount is > 50mL, we're gonna use a robot reservoir.
								In that case, request enough to account for dead volume of the reservoir (30mL) *)
								(* When tagging models, we split requests for the same model at 200mL, so we totalAmount <=200mL *)
								If[
									Or[
										(* If we're incubating, we'll use a reservoir for anything above 10.4mL,
										Will also use reservoir if a define primitive specifically requested it
										Otherwise we'll use a reservoir for anything above 50mL *)
										MemberQ[incubatedModels,sourceModel] && bufferedAmount > 10.4 Milliliter,
										bufferedAmount > 50 Milliliter,
										And[
											MatchQ[sourceModel,_String],
											MatchQ[
												Lookup[definedNamesLookup,sourceModel][Container],
												ObjectP[defaultOnDeckReservoir]
											]
										]
									],
									Min[totalAmount + 30 Milliliter, 200 Milliliter],
									bufferedAmount
								],
								bufferedAmount
							]
						]
					];

					(* Round requests for volume/mass to a resolution that we can actually measure, leave counts alone *)
					amountToRequest = If[And[QuantityQ[calculatedAmountToRequest],Not[MatchQ[modelObject, WaterModelP]]],
						Module[{roundedAmount},
							(* If we need an amount smaller than what we can measure, leave the calculated amount alone *)
							(* Later in the code SM will throw Error::SampleManipulationAmountOutOfRange, referring to the specific problematic relations *)
							roundedAmount=AchievableResolution[calculatedAmountToRequest, All, Messages->False];
							If[MatchQ[roundedAmount,$Failed],
								calculatedAmountToRequest,
								roundedAmount
							]
						],
						calculatedAmountToRequest
					];

					(* determine if the requested sample must be autoclaved *)
					autoclaveQ = TrueQ[Lookup[fetchPacketFromCacheHPLC[modelObject, allPackets],Autoclave]];

					(* set the maxTemperature to request *)
					maxTemp = If[autoclaveQ,120*Celsius,Automatic];

					(* determine what containers to request the resource in;
					 	anything goes for macro, otherwise use compatible containers for the other methods *)
						containerModelToRequest = Which[
							MemberQ[ftvVolumetricSources,sourceModel],
							PreferredContainer[amountToRequest, MaxTemperature -> maxTemp],
							And[
								MatchQ[sourceModel,_String],
								MatchQ[Lookup[definedNamesLookup,sourceModel][Container],FluidContainerModelP]
							],
								Lookup[definedNamesLookup,sourceModel][Container],
							MatchQ[scaleToUseForFurtherResolving,MicroLiquidHandling]&&MatchQ[modelObject,WaterModelP],
								defaultOnDeckReservoir,
							MatchQ[modelObject,WaterModelP],
								PreferredContainer[amountToRequest, Type -> Vessel, MaxTemperature -> maxTemp],
							(* if we're on bufferbot, we are handling solid transfers in advance, so no need to request a container model *)
							MatchQ[scaleToUseForFurtherResolving,Bufferbot]&&MassQ[amountToRequest],Null,
							MatchQ[scaleToUseForFurtherResolving,MacroLiquidHandling],
								If[Lookup[safeOptions,SamplePreparation]||Lookup[safeOptions,Simulation],
									(* If we're doing tablets, use tablet weight to pass to PreferredContainer *)
									If[IntegerQ[amountToRequest],
										PreferredContainer[
											(amountToRequest*Lookup[fetchPacketFromCacheHPLC[modelObject,allPackets],TabletWeight]),
											MaxTemperature -> maxTemp
										],
										PreferredContainer[amountToRequest, MaxTemperature -> maxTemp]
									],
									Null
								],
							MatchQ[scaleToUseForFurtherResolving,MicroLiquidHandling],If[MemberQ[incubatedModels,sourceModel],
								If[TrueQ[Lookup[safeOptions,Simulation]],
									PreferredContainer[amountToRequest, LiquidHandlerCompatible -> True, Type -> Plate, MaxTemperature -> maxTemp],
									PreferredContainer[amountToRequest, LiquidHandlerCompatible -> True, Type -> Plate, All -> False, MaxTemperature -> maxTemp]
								],
								Switch[amountToRequest,
									RangeP[0 Milliliter,50 Milliliter],
										If[TrueQ[Lookup[safeOptions,Simulation]],
											PreferredContainer[amountToRequest, LiquidHandlerCompatible -> True, Type -> Vessel, MaxTemperature -> maxTemp],
											(* this is super edge case-y, but if we already have 12 inputs in 50 mL tube footprints, we can't resolve another tube, but we can try to resolve 24-well DWP as a reservoir if the
													requested amount is less than 10 mL *)
											(* TODO: be a little more intelligent when resolving deck containers -- it might be possible to use plates/reservoirs in a serious pinch to replace things like 50 mL tubes which have limited spaces to get things to work where they otherwise might not *)
											If[
												MatchQ[
													KeyValueMap[
														#1->Length[#2]&,
														GroupBy[
															Map[
																fetchPacketFromCacheHPLC[#,allPackets]&,
																Download[uniqueContainerPackets[[All,Key[Model]]],Object]
															],
															Lookup[#,Footprint]&
														]
													],
													KeyValuePattern[Conical50mLTube->GreaterEqualP[12]]
												] && 2 Milliliter < amountToRequest < 10 Milliliter,
												PreferredContainer[amountToRequest, LiquidHandlerCompatible -> True, Type -> Plate, MaxTemperature -> maxTemp],
												(* otherwise proceed as normal *)
												PreferredContainer[amountToRequest, LiquidHandlerCompatible -> True, Type -> Vessel, All -> False, MaxTemperature -> maxTemp]
											]
										],
									_,
										(* Call plate because we'll get back a robot reservoir *)
										PreferredContainer[amountToRequest, LiquidHandlerCompatible -> True, Type -> Plate, MaxTemperature -> maxTemp]
								]
							],
							(* TODO: Thiis is never called... figure out why *)
							True,compatibleSampleManipulationContainers[scaleToUseForFurtherResolving,EngineDefaultOnly->False]
						];

					(* finally we need to know if this resource needs to propagate the REntContainer information from a prepared resource passed by the parent; wemade a lookup for this;
					gotta slashdot since the keys are tuples and Lookup tries to lookup eachof them as individuals *)
					rentContainerBool=sourceModel/.modelToRentContainerBoolLookup;

					(* generate the blob, requesting a container or not depending on if we have any restrictions  *)
					If[NullQ[containerModelToRequest],
						Resource[Name->ToString[Unique[]],Sample->modelObject,Amount->amountToRequest,RentContainer->rentContainerBool],
						Resource[Name->ToString[Unique[]],Sample->modelObject,Amount->amountToRequest,Container->containerModelToRequest,RentContainer->rentContainerBool]
					]
				]
			],
			nonZeroModelAmountLookup
		];

		(* if we failed during generation of any of these resources, pass that failure up here *)
		If[MemberQ[modelResources,$Failed],
			Return[$Failed,Module]
		];

		(* case out all tagged model containers in this manip *)
		allTags = DeleteDuplicates[
			DeleteCases[
				Cases[
					manipulationsWithResolvedIncubations,
					Alternatives[
						Alternatives@@Flatten[definedNameReferences],
						{_Symbol|_Integer,ObjectReferenceP[Model[Container]]}
					],
					Infinity
				],
				(* comically, in Filter Macro, we can have {Null, syringe container} in the Syringe key, if filtering with two different filtration types, so need to delete those from this list *)
				{Null,ObjectReferenceP[Model[Container]]}
			]
		];

		(* now get all of the unique container models from the manipulations; these will ALL be tagged (per manipulationsWithTaggedContainers);
		 	need to keep track of if these are RentContainer->True or not; ASSUMES that we aren't crossing the wires w.r.t. rent and same tag *)
		taggedModelContainerRentContainerBoolTuples=Flatten[MapThread[
			Function[{manipulation,rentContainerBool},
				If[MatchQ[manipulation,_Define],
					Nothing,
					Module[{taggedContainerModels},

						(* Extract those tags that define a model container *)
						taggedContainerModels = Map[
							Which[
								MatchQ[#,{_Symbol|_Integer,ObjectReferenceP[Model[Container]]}],
									#,
								And[
									MatchQ[#,_String],
									Or[
										And[
											!MatchQ[Lookup[definedNamesLookup,#][Sample],ObjectP[Model[Sample]]],
											MatchQ[Lookup[definedNamesLookup,#][Container],ObjectP[Model[Container]]]
										],
										And[
											MatchQ[Lookup[definedNamesLookup,#][ContainerName],#],
											MatchQ[Lookup[definedNamesLookup,#][Sample],ObjectP[Model[Sample]]],
											QuantityMagnitude[Lookup[uniqueModelAmountLookup,#,0]] == 0,
											MatchQ[Lookup[definedNamesLookup,#][Container],ObjectP[Model[Container]]]
										]
									]
								],
									#,
								Or[
									(* If tag defines an empty model container (ie: not a sample or model), then include it
									Also if the defined name refers to a ContainerName and the Sample of that define function
									does not need any volume, then we should include this ContainerName/container entry
									since we're not going to pick the model directly (as its required volume is 0).
									This happens if someone specified both Name/Sample and ContainerName/Container but
									the Name is never used as a source (so it doesnt need any volume) but the ContainerName
									is used *)
									And[
										Or[
											!MatchQ[Lookup[definedNamesLookup,#][Sample],ObjectP[Model,Sample]],
											And[
												MatchQ[Lookup[definedNamesLookup,#][ContainerName],#],
												MatchQ[Lookup[definedNamesLookup,#][Sample],ObjectP[Model,Sample]],
												QuantityMagnitude[Lookup[uniqueModelAmountLookup,#,0]] == 0
											]
										],
										MatchQ[Lookup[definedNamesLookup,#][Container],ObjectP[Model[Container]]|{_Symbol|_Integer,ObjectP[Model[Container]]}]
									],
									MatchQ[Lookup[definedNamesLookup,#][Sample],{ObjectP[Model[Container]]|{_Symbol|_Integer,ObjectP[Model[Container]]},WellPositionP}]
								],
									Lookup[definedNamesLookup,#][Container],
								True,
									Nothing
							]&,
							allTags
						];

						(* asssociate into tuples with this manip's index's rent bool *)
						{#,rentContainerBool}&/@taggedContainerModels
					]
				]
			],
			{manipulationsWithResolvedIncubations,expandedRentContainerBools}
		],1];

		(* get just the unique pairings of {tag,containerModel} and rentContainerBool *)
		uniqueModelContainerRentContainerTuples=DeleteDuplicatesBy[taggedModelContainerRentContainerBoolTuples,First];

		(* generate resources for each of the unique containers; for Container resources, just use Rent flag *)
		modelContainerResources = Map[
			Switch[#[[1]],
				_String,
					Resource[
						Name -> ToString[Unique[]],
						Sample -> fetchDefineModelContainer[Lookup[definedNamesLookup,#[[1]]],Cache->allPackets],
						Rent -> #[[2]]
					],
				{_Symbol|_Integer,ObjectP[]},
					Resource[
						Name->ToString[Unique[]],
						Sample->Last[#[[1]]],
						Rent->#[[2]]
					],
				_,
					Resource[
						Name->ToString[Unique[]],
						Sample->#[[1]],
						Rent->#[[2]]
					]
			]&,
			uniqueModelContainerRentContainerTuples
		];

		(* we also want to include in RequiredObjects any samples that we already know about, and
		 	any empty container objects. We already know the unique samples from uniqueSamplePackets *)
		emptyContainers = Select[uniqueContainerPackets,MatchQ[Lookup[#,Contents],{}]&];

		(* Do not make RequiredObjects resources for ReadPlate injection samples *)
		sampleResourcePackets = Select[uniqueSamplePackets,!MemberQ[uniqueInjectionSamples,Lookup[#,Object]]&];

		(* generate resources for the direct samples being picked; this is to ensure that
		 	they will be routed to ResourceThaw if necessary (which only works if there's a resource object) *)
		sampleResources = Map[
			Resource[
				Name -> ToString[Unique[]],
				Sample -> Lookup[#,Object],
				Amount -> Lookup[
					uniqueSampleAmountLookup,
					Lookup[#,Object],
					(* If the sample has a count, first request a count *)
					(* then, If the sample has Mass and not Volume, request a mass, otherwise use volume.
					This is because FRQ downstream will fuck up if the units are not appropriate. *)
					Which[
						MatchQ[Lookup[#, Count], UnitsP[Unit]], 0 Unit,
						MassQ[Lookup[#,Mass]]&&!VolumeQ[Lookup[#,Volume]], 0 Gram,
						True, 0 Milliliter
					]
				]
			]&,
			sampleResourcePackets
		];
		
		counterweights = DeleteDuplicates@Cases[
			Flatten@Map[
				#[Counterweight]&,
				Cases[
					manipulationsWithResolvedIncubations,
					Alternatives[
						_Centrifuge,
						_Filter?(KeyExistsQ[First[#],Counterweight]&)
					]
				]
			],
			ObjectP[]
		];
		
		counterweightResources = Map[
			Resource[
				Name -> ToString[Unique[]],
				Sample -> #,
				Rent -> True
			]&,
			counterweights
		];

		(*If a magnet is needed on the deck, make a resource for it*)
		magnet=If[MatchQ[scaleToUseForFurtherResolving,MicroLiquidHandling]&&MemberQ[manipulationsWithResolvedIncubations,_MoveToMagnet|_RemoveFromMagnet],
			Model[Container,Rack,"Alpaqua Magnum FLX Enhanced Universal Magnet 96-well Plate Rack"],
			Null
		];
		magnetResource=If[!NullQ[magnet],
			Resource[Sample->magnet,Rent->True],
			Null
		];

		(* generate the full required objects field; multiple in the form {uniqueTag,resource/object};
		 	the tag is either just an object ID or a symbol-tagged object ID *)
		Join[
			Transpose[{Keys[nonZeroModelAmountLookup],Link/@modelResources}],
			Transpose[{uniqueModelContainerRentContainerTuples[[All,1]],Link/@modelContainerResources}],
			Transpose[{sampleResourcePackets[[All,Key[Object]]],Link/@sampleResources}],
			Transpose[{Lookup[emptyContainers,Object,{}],Link[emptyContainers]}],
			Transpose[{counterweights,Link/@counterweightResources}],
			If[!NullQ[magnet],
				{{magnet,magnetResource}},
				{Nothing}
			]
		]
	];

	(* Build lookup table to conver a container or tagged model to its resource *)
	requiredObjectsLookup = Association[Rule@@@requiredObjects];

	(*  set a var in case required objects is failed to use as placeholde for further stuff*)
	requiredObjectsNotFailed=If[MatchQ[requiredObjects,$Failed],
		{},
		requiredObjects
	];
	
	(* Pull out any required Containers *)
	modelResourceContainerModels = Cases[
		Flatten[First[#][Container]&/@requiredObjectsNotFailed[[All,2]]],
		ObjectP[Model[Container]]
	];
	
	(* Extract models that do not already have packets in the cache *)
	modelsMissingPackets = Select[
		modelResourceContainerModels,
		!MemberQ[allPackets,KeyValuePattern[{Object->#}]]&
	];
	
	(* Download model container information *)
	newModelPackets = Quiet[
		Download[
			modelsMissingPackets,
			Packet[Deprecated,MaxVolume,MinVolume,Footprint,VolumeCalibrations,Rows,Columns,NumberOfPositions,NumberOfWells,Positions,MembraneMaterial,PoreSize,TareWeight,OpenContainer,LidSpacerRequired,Aperture,InternalDepth,WellDimensions,WellDiameter,WellDepth,LiquidHandlerAdapter,WellPositionDimensions,WellDiameters,WellDepths,StorageBufferVolume]
		],
		{Download::MissingField,Download::FieldDoesntExist,Download::NotLinkField}
	];
	
	(* Update cache with new packets *)
	allPackets = Join[allPackets,newModelPackets];

	(* Run a primitive optimization to merge Transfers into the most efficient pipetting steps.
	We can only optimize if the OptimizePrimitives option is True and we're on the liquid-handler. *)
	optimizedPrimitives = If[
		And[
			Lookup[safeOptions,OptimizePrimitives],
			MatchQ[scaleToUseForFurtherResolving,MicroLiquidHandling]
		],
		optimizePrimitives[
			manipulationsWithResolvedIncubations,
			RequiredObjectsLookup->requiredObjectsLookup,
			Cache->allPackets,
			DefineLookup->definedNamesLookup
		],
		manipulationsWithResolvedIncubations
	];

	(* Resolve pipetting parameters  *)
	{manipulationsWithPipettingParameters,pipettingParameterTests,invalidPipettingParameterQ} = Module[
		{invalidParametersQ,relevantManipulationIndices,originalManipulationIndices,uniqueRelevantRawManipulationIndices,relevantManipulations,relevantRawManipulations,mixPipettingParameterP,tipParameterP,
		manipulationsWithPipettingParameters,pipettingParameterScaleTest,manipulationsWithCorrectionCurve,correctionCurves,
		validZeroCorrectionQs,manipulationsWithInvalidZeroCorrection,validZeroCorrectionTest,manipulationsWithPipettingMethod,
		pipettingMethods,pipettingMethodExistsQs,manipulationsWithNonExistentPipettingMethod,validPipettingMethodsTest,
		liquidHandlerCompatibleBools,tipSizeCompatibleBools,tipTypeSizeExistsBools,tipTypeSizeCompatibleBools,tip1000ContainerCompatibleBools,
		tip50ContainerCompatibleBools,compatibleMixVolumeBools,invalidLiquidHandlerManipulationPositions,invalidLiquidHandlerManipulations,validLiquidHandlerTipTypeTest,
		invalidTipSizeManipulationPositions,invalidTipSizeManipulations,validTipSizeTest,invalidTipTypeSizeExistsManipulationPositions,invalidTipTypeSizeExistsManipulations,validTipTypeSizeCombinationTest,
		invalidTipTypeSizeManipulationPositions,invalidTipTypeSizeManipulations,validTipTypeSizeAgreementTest,invalidTip1000ContainerManipulationnPositions,invalidTip1000ContainerManipulations,valid1000ulTipCompatibilityTest,
		invalidTip50ContainerManipulationionPositions,invalidTip50ContainerManipulations,valid50ulTipCompatibilityTest,incompatibleMixVolumeTipManipulationPositions,incompatibleMixVolumeTipManipulations,validMixVolumeTipCompatibilityTest,
		allPipettingParameterTests,resolvedManipulations},

		(* Initialize invalid parameters tracking variable *)
		invalidParametersQ = False;

		(* Extract indices of primitives that could possibly have pipetting parameters specified *)
		relevantManipulationIndices = Flatten@Position[
			manipulationsWithResolvedIncubations,
			(_Transfer|_Mix),
			{1}
		];

		originalManipulationIndices = expandedRawManipulationPositions[[relevantManipulationIndices]];

		(* Extract indices of primitives that could possibly have pipetting parameters specified *)
		uniqueRelevantRawManipulationIndices = DeleteDuplicates[originalManipulationIndices];

		(* Extract primitives that could possibly have pipetting parameters specified *)
		relevantManipulations = manipulationsWithResolvedIncubations[[relevantManipulationIndices]];

		(* Extract relevant input primitives *)
		relevantRawManipulations = myRawManipulations[[uniqueRelevantRawManipulationIndices]];

		(* Pipetting parameters for Mix primitives are different than the standard
		pipettingParameterP set *)
		mixPipettingParameterP = Alternatives[
			MixFlowRate,
			MixPosition,
			MixPositionOffset
		];

		(* Tip Parameter key names *)
		tipParameterP = Alternatives[TipType,TipSize];

		(* Since the resolved scale should "default" to Micro, we should be able to assume
		that if it is Macro, then there is a reason Macro _must_ be used. Therefore, we can
		check here that the resolved scale is micro if any pipetting parameters are set. *)
		manipulationsWithPipettingParameters = Select[
			relevantRawManipulations,
			MemberQ[Keys[First[#]],pipettingParameterP|mixPipettingParameterP|tipParameterP]&
		];

		(* Pipetting parameters cannot be used in Macro liquid handling
		(ie: they can only be used on the liquid handler). Build test to
		check this compatibility. *)
		pipettingParameterScaleTest = If[
			And[
				!MatchQ[scaleToUseForFurtherResolving,MicroLiquidHandling],
				Length[manipulationsWithPipettingParameters] > 0
			],
			(
				invalidParametersQ = True;
				If[messagesBoolean,
					(
						Message[Error::IncompatiblePipettingParametersScale,manipulationsWithPipettingParameters];
						Message[Error::InvalidInput,manipulationsWithPipettingParameters];
						Null
					),
					testOrNull["If required liquid handling scale is MacroLiquidHandling, pipetting and tip parameters are not specified in manipulations:",False]
				]
			),
			If[gatherTests,
				testOrNull["If required liquid handling scale is MacroLiquidHandling, pipetting and tip parameters are not specified in manipulations:",True],
				Null
			]
		];

		(* Fetch manipulations with a specified CorrectionCurve *)
		manipulationsWithCorrectionCurve = Select[relevantRawManipulations,MatchQ[#[CorrectionCurve],_List]&];

		(* Extract actual correction curve values *)
		correctionCurves = Map[
			If[MatchQ[#[CorrectionCurve],{{VolumeP,VolumeP}...}],
				{#[CorrectionCurve]},
				#[CorrectionCurve]
			]&,
			manipulationsWithCorrectionCurve
		];

		(* If a 0-point is specified, both target and actual value must be 0 *)
		validZeroCorrectionQs = Map[
			And@@Map[
				!And[
					Length[#] > 0,
					#[[1,1]] == 0 Microliter,
					#[[1,2]] != 0 Microliter
				]&,
				#
			]&,
			correctionCurves
		];

		(* Filter manipulations that have erroneous zero-value in correction curve *)
		manipulationsWithInvalidZeroCorrection = PickList[
			manipulationsWithCorrectionCurve,
			validZeroCorrectionQs,
			False
		];

		(* Build test for zero point check *)
		validZeroCorrectionTest = If[Length[manipulationsWithInvalidZeroCorrection] > 0,
			(
				invalidParametersQ = True;
				If[messagesBoolean,
					(
						Message[Error::InvalidManipulationCorrectionCurveZeroValue,manipulationsWithInvalidZeroCorrection];
						Message[Error::InvalidInput,manipulationsWithInvalidZeroCorrection];
						Null
					),
					testOrNull["Any manipulation's specified CorrectionCurve's actual volume value for a target volume of 0 Microliter is also 0 Microliter:",False]
				]
			),
			If[gatherTests,
				testOrNull["Any manipulation's specified CorrectionCurve's actual volume value for a target volume of 0 Microliter is also 0 Microliter:",True],
				Null
			]
		];

		(* Extract manipulations with specified pipetting methods *)
		manipulationsWithPipettingMethod = Select[relevantRawManipulations,MatchQ[#[PipettingMethod],ObjectP[]]&];

		(* Extract actual pipetting method object *)
		pipettingMethods = Map[
			If[MatchQ[#[PipettingMethod],ObjectP[]],
				{#[PipettingMethod]},
				#[PipettingMethod]
			]&,
			manipulationsWithPipettingMethod
		];

		(* Build list of bools describing if the specified method actually exists *)
		pipettingMethodExistsQs = DatabaseMemberQ[Download[#,Object]]&/@pipettingMethods;

		(* Filter manipulations that have invalid pipetting method objects *)
		manipulationsWithNonExistentPipettingMethod = PickList[
			manipulationsWithPipettingMethod,
			pipettingMethodExistsQs,
			False
		];

		(* Build test for pipetting method check *)
		validPipettingMethodsTest = If[Length[manipulationsWithNonExistentPipettingMethod] > 0,
			(
				invalidParametersQ = True;
				If[messagesBoolean,
					(
						Message[Error::PipettingMethodDoesNotExist,manipulationsWithNonExistentPipettingMethod];
						Message[Error::InvalidInput,manipulationsWithNonExistentPipettingMethod];
						Null
					),
					testOrNull["Any manipulation's specified PipettingMethod exists in the database:",False]
				]
			),
			If[gatherTests,
				testOrNull["Any manipulation's specified PipettingMethod exists in the database:",True],
				Null
			]
		];

		(* --- TipType / TipSize tests --- *)

		(* Build error checking bools for tip parameters *)
		{
			liquidHandlerCompatibleBools,
			tipSizeCompatibleBools,
			tipTypeSizeExistsBools,
			tipTypeSizeCompatibleBools,
			tip1000ContainerCompatibleBools,
			tip50ContainerCompatibleBools,
			compatibleMixVolumeBools
		} = If[Length[relevantManipulations] > 0,
			Transpose@Map[
				Function[manipulation,
					Module[
						{specifiedTipTypes,specifiedTipSizes,liquidHandlerCompatibleQ,tipSizeCompatibleQ,tipTypeSizeExistsQ,
						tipTypeSizeCompatibleQ,sourceContainerModels,destinationContainerModels,allAccessedContainerModels,
						tip1000ContainerCompatibleQ,tip50ContainerCompatibleQ,compatibleMixVolumeQ},

						(* Extract specified tip params *)
						specifiedTipTypes = If[MatchQ[manipulation[TipType],_List],
							manipulation[TipType],
							If[MatchQ[manipulation,_Mix],
								Table[manipulation[TipType],Length[manipulation[Sample]]],
								Table[manipulation[TipType],Length[manipulation[Source]]]
							]
						];
						specifiedTipSizes = If[MatchQ[manipulation[TipSize],_List],
							manipulation[TipSize],
							If[MatchQ[manipulation,_Mix],
								Table[manipulation[TipSize],Length[manipulation[Sample]]],
								Table[manipulation[TipSize],Length[manipulation[Source]]]
							]
						];

						(* Only some tips are compatible on the hamiltons *)
						liquidHandlerCompatibleQ = And@@Map[
							Or[
								(* If not specified, assume it's okay *)
								!MatchQ[#,ObjectP[]],
								MatchQ[Download[#,Object],Alternatives@@Download[possibleTips,Object]]
							]&,
							specifiedTipTypes
						];

						(* Only some sizes are compatible on the hamiltons *)
						tipSizeCompatibleQ = And@@Map[
							If[MatchQ[#,VolumeP],
								Or[
									# == 50 Microliter,
									# == 300 Microliter,
									# == 1000 Microliter
								],
								True
							]&,
							specifiedTipSizes
						];

						(* 10ul and 50ul tips do not have the WideBore option *)
						tipTypeSizeExistsQ = And@@MapThread[
							Function[{specifiedTipType,specifiedTipSize},
								If[
									And[
										MatchQ[specifiedTipSize,VolumeP],
										MatchQ[specifiedTipType,WideBore]
									],
									And[
										specifiedTipSize != 10 Microliter,
										specifiedTipSize != 50 Microliter
									],
									True
								]
							],
							{specifiedTipTypes,specifiedTipSizes}
						];

						(* If TipType is an object and TipSize is a volume, make sure the object agrees with the specified size *)
						tipTypeSizeCompatibleQ = And@@MapThread[
							Function[{specifiedTipType,specifiedTipSize},
								If[
									And[
										MatchQ[specifiedTipType,ObjectP[]],
										MatchQ[specifiedTipSize,VolumeP]
									],
									Lookup[fetchPacketFromCacheHPLC[specifiedTipType,allPackets],MaxVolume] == specifiedTipSize,
									True
								]
							],
							{specifiedTipTypes,specifiedTipSizes}
						];

						(* Fetch container models used in the Source(s) *)
						sourceContainerModels = DeleteCases[
							fetchSourceModelContainers[
								manipulation,
								Cache->allPackets,
								DefineLookup->definedNamesLookup,
								RequiredObjectsLookup->requiredObjectsLookup
							],
							Null,
							{2}
						];

						(* Fetch container models used in the Destination(s) *)
						destinationContainerModels = If[MatchQ[manipulation,_Mix],
							Table[{},Length[sourceContainerModels]],
							DeleteCases[
								fetchDestinationModelContainers[
									manipulation,
									Cache->allPackets,
									DefineLookup->definedNamesLookup,
									RequiredObjectsLookup->requiredObjectsLookup
								],
								Null,
								{2}
							]
						];

						(* Join source and destination container models *)
						allAccessedContainerModels = MapThread[
							DeleteDuplicates[Join[#1,#2]]&,
							{sourceContainerModels,destinationContainerModels}
						];

						(* Some labware is not compatible with 1000ul tips *)
						tip1000ContainerCompatibleQ = And@@MapThread[
							Function[{specifiedTipType,accessedContainerModels},
								If[
									And[
										MatchQ[specifiedTipType,ObjectP[]],
										(* 1000uL tips have different real MaxVolume - 1060uL and 1245uL *)
										With[{tipMaxVolume = Lookup[fetchPacketFromCacheHPLC[specifiedTipType,allPackets],MaxVolume]},
											Or[
												tipMaxVolume==1060 Microliter,
												tipMaxVolume==1245 Microliter
											]
										]
									],
									(* 1000ul tips cannot fit in some vessels *)
									And@@(tipsReachContainerBottomQ[
										specifiedTipType,
										fetchPacketFromCacheHPLC[#,allPackets],
										{fetchPacketFromCacheHPLC[specifiedTipType,allPackets]}
									]&/@accessedContainerModels),
									True
								]
							],
							{specifiedTipTypes,allAccessedContainerModels}
						];

						(* Some labware is not compatible with 50ul tips *)
						tip50ContainerCompatibleQ = And@@MapThread[
							Function[{specifiedTipType,accessedContainerModels},
								If[
									And[
										MatchQ[specifiedTipType,ObjectP[]],
										Lookup[fetchPacketFromCacheHPLC[specifiedTipType,allPackets],MaxVolume] == 55 Microliter (* 50uL tip has a MaxVolume of 55uL *)
									],
									And@@(tipsReachContainerBottomQ[
										specifiedTipType,
										fetchPacketFromCacheHPLC[#,allPackets],
										{fetchPacketFromCacheHPLC[specifiedTipType,allPackets]}
									]&/@accessedContainerModels),
									True
								]
							],
							{specifiedTipTypes,allAccessedContainerModels}
						];

						(* For mixes, the MixVolume must be less than the tip size *)
						compatibleMixVolumeQ = And@@If[MatchQ[manipulation,_Mix],
							MapThread[
								Function[{specifiedTipType,specifiedTipSize},
									(* Neither the tip type's max volume or the tip size can be greater than the maximum mix volume *)
									!Or[
										And[
											MatchQ[specifiedTipType,ObjectP[]],
											maximumAspirationVolume[fetchPacketFromCacheHPLC[specifiedTipType,allPackets]] < Max[manipulation[MixVolume]]
										],
										And[
											MatchQ[specifiedTipSize,VolumeP],
											maximumAspirationVolume[specifiedTipSize] < Max[manipulation[MixVolume]]
										]
									]
								],
								{specifiedTipTypes,specifiedTipSizes}
							],
							{True}
						];

						(* Return bools in expected order *)
						{
							liquidHandlerCompatibleQ,
							tipSizeCompatibleQ,
							tipTypeSizeExistsQ,
							tipTypeSizeCompatibleQ,
							tip1000ContainerCompatibleQ,
							tip50ContainerCompatibleQ,
							compatibleMixVolumeQ
						}
					]
				],
				relevantManipulations
			],
			{{},{},{},{},{},{},{}}
		];

		(* Build test for TipType/LiquidHandler compatibilities *)
		invalidLiquidHandlerManipulationPositions = DeleteDuplicates@PickList[originalManipulationIndices,liquidHandlerCompatibleBools,False];
		invalidLiquidHandlerManipulations = myRawManipulations[[invalidLiquidHandlerManipulationPositions]];
		validLiquidHandlerTipTypeTest = If[Length[invalidLiquidHandlerManipulations] > 0,
			(
				invalidParametersQ = True;
				If[messagesBoolean,
					(
						Message[Error::LiquidHandlerNotCompatibleWithTipType,invalidLiquidHandlerManipulations];
						Message[Error::InvalidInput,invalidLiquidHandlerManipulations];
						Null
					),
					testOrNull["If LiquidHandler is specified, all manipulations' TipTypes are compatible with the specified liquid handler:",False]
				]
			),
			If[gatherTests,
				testOrNull["If LiquidHandler is specified, all manipulations' TipTypes are compatible with the specified liquid handler:",True],
				Null
			]
		];

		(* Build test for TipSize existing for hamiltons *)
		invalidTipSizeManipulationPositions = DeleteDuplicates@PickList[originalManipulationIndices,tipSizeCompatibleBools,False];
		invalidTipSizeManipulations = myRawManipulations[[invalidTipSizeManipulationPositions]];
		validTipSizeTest = If[Length[invalidTipSizeManipulations] > 0,
			(
				invalidParametersQ = True;
				If[messagesBoolean,
					(
						Message[Error::IncompatibleTipSize,invalidTipSizeManipulations];
						Message[Error::InvalidInput,invalidTipSizeManipulations];
						Null
					),
					testOrNull["All manipulations' TipSize are compatible with the required liquid handler:",False]
				]
			),
			If[gatherTests,
				testOrNull["All manipulations' TipSize are compatible with the required liquid handler:",True],
				Null
			]
		];

		(* Build test for TipType existing for specified TipSize *)
		invalidTipTypeSizeExistsManipulationPositions = DeleteDuplicates@PickList[originalManipulationIndices,tipTypeSizeExistsBools,False];
		invalidTipTypeSizeExistsManipulations = myRawManipulations[[invalidTipTypeSizeExistsManipulationPositions]];
		validTipTypeSizeCombinationTest = If[Length[invalidTipTypeSizeExistsManipulations] > 0,
			(
				invalidParametersQ = True;
				If[messagesBoolean,
					(
						Message[Error::TipTypeDoesNotExistForSize,invalidTipTypeSizeExistsManipulations];
						Message[Error::InvalidInput,invalidTipTypeSizeExistsManipulations];
						Null
					),
					testOrNull["Tips exist for any specified TipType/TipSize combinations:",False]
				]
			),
			If[gatherTests,
				testOrNull["Tips exist for any specified TipType/TipSize combinations:",True],
				Null
			]
		];

		(* Build test for TipType and TipSize agreeing *)
		invalidTipTypeSizeManipulationPositions = DeleteDuplicates@PickList[originalManipulationIndices,tipTypeSizeCompatibleBools,False];
		invalidTipTypeSizeManipulations = myRawManipulations[[invalidTipTypeSizeManipulationPositions]];
		validTipTypeSizeAgreementTest = If[Length[invalidTipTypeSizeManipulations] > 0,
			(
				invalidParametersQ = True;
				If[messagesBoolean,
					(
						Message[Error::TipTypeSizeDoesNotExist,invalidTipTypeSizeManipulations];
						Message[Error::InvalidInput,invalidTipTypeSizeManipulations];
						Null
					),
					testOrNull["Any specified TipType values agree with the corresponding TipSize specifications:",False]
				]
			),
			If[gatherTests,
				testOrNull["Any specified TipType values agree with the corresponding TipSize specifications:",True],
				Null
			]
		];

		(* Build test for 1000ul tip compatibility with labware *)
		invalidTip1000ContainerManipulationnPositions = DeleteDuplicates@PickList[originalManipulationIndices,tip1000ContainerCompatibleBools,False];
		invalidTip1000ContainerManipulations = myRawManipulations[[invalidTip1000ContainerManipulationnPositions]];
		valid1000ulTipCompatibilityTest = If[Length[invalidTip1000ContainerManipulations] > 0,
			(
				invalidParametersQ = True;
				If[messagesBoolean,
					(
						Message[Error::TipSizeIncompatibleWithContainers,1000 Microliter,invalidTip1000ContainerManipulations];
						Message[Error::InvalidInput,invalidTip1000ContainerManipulations];
						Null
					),
					testOrNull["Any manipulations using 1000ul tips transfer into and out of compatible containers:",False]
				]
			),
			If[gatherTests,
				testOrNull["Any manipulations using 1000ul tips transfer into and out of compatible containers:",True],
				Null
			]
		];

		(* Build test for 50ul tip compatibility with labware *)
		invalidTip50ContainerManipulationionPositions = DeleteDuplicates@PickList[originalManipulationIndices,tip50ContainerCompatibleBools,False];
		invalidTip50ContainerManipulations = myRawManipulations[[invalidTip50ContainerManipulationionPositions]];
		valid50ulTipCompatibilityTest = If[Length[invalidTip50ContainerManipulations] > 0,
			(
				invalidParametersQ = True;
				If[messagesBoolean,
					(
						Message[Error::TipSizeIncompatibleWithContainers,50 Microliter,invalidTip50ContainerManipulations];
						Message[Error::InvalidInput,invalidTip50ContainerManipulations];
						Null
					),
					testOrNull["Any manipulations using 50ul tips transfer into and out of compatible containers:",False]
				]
			),
			If[gatherTests,
				testOrNull["Any manipulations using 50ul tips transfer into and out of compatible containers:",True],
				Null
			]
		];

		(* Build test for MixVolume/TipType volume compatibility *)
		incompatibleMixVolumeTipManipulationPositions = DeleteDuplicates@PickList[originalManipulationIndices,compatibleMixVolumeBools,False];
		incompatibleMixVolumeTipManipulations = myRawManipulations[[incompatibleMixVolumeTipManipulationPositions]];
		validMixVolumeTipCompatibilityTest = If[Length[incompatibleMixVolumeTipManipulations] > 0,
			(
				invalidParametersQ = True;
				If[messagesBoolean,
					(
						Message[Error::IncompatibleTipForMixVolume,incompatibleMixVolumeTipManipulations];
						Message[Error::InvalidInput,incompatibleMixVolumeTipManipulations];
						Null
					),
					testOrNull["Any specified tips for Mix primitives have a size less than the volume being mixed:",False]
				]
			),
			If[gatherTests,
				testOrNull["Any specified tips for Mix primitives have a size less than the volume being mixed:",True],
				Null
			]
		];

		(* Join all tests *)
		allPipettingParameterTests = {
			pipettingParameterScaleTest,
			validZeroCorrectionTest,
			validPipettingMethodsTest,
			validLiquidHandlerTipTypeTest,
			validTipSizeTest,
			validTipTypeSizeCombinationTest,
			validTipTypeSizeAgreementTest,
			valid1000ulTipCompatibilityTest,
			valid50ulTipCompatibilityTest,
			validMixVolumeTipCompatibilityTest
		};

		(* Resolve and expand all pipetting parameters in Transfer/Mix primitives IFF the
		liquid handling scale is compatible (Micro), otherwise return manips untouched *)
		resolvedManipulations = If[MatchQ[scaleToUseForFurtherResolving,MicroLiquidHandling],
			MapIndexed[
				Function[{primitive,index},
					Switch[primitive,
						_Transfer,
							Module[{previousTransfers,allPreviousDestinations,destinations,destinationSamples,emptyDestinationBools},

								previousTransfers = Cases[
									manipulationsWithResolvedIncubations[[;;(First[index]-1)]],
									_Transfer
								];

								allPreviousDestinations = Cases[
									Join@@Map[
										(Join@@(#[Destination]))&,
										previousTransfers
									],
									(* Raw model containers are can't be re-used *)
									Except[ObjectP[Model[Container]]]
								];

								destinations = primitive[Destination];
								destinationSamples = primitive[DestinationSample];

								emptyDestinationBools = MapThread[
									And@@MapThread[
										If[!NullQ[#2],
											False,
											!MemberQ[allPreviousDestinations,#1]
										]&,
										{#1,#2}
									]&,
									{destinations,destinationSamples}
								];

								resolvePipettingParameters[
									primitive,
									Cache -> allPackets,
									DefineLookup -> definedNamesLookup,
									RequiredObjectsLookup -> requiredObjectsLookup,
									EmptyDestination -> emptyDestinationBools
								]
							],
						_Mix,
							resolvePipettingParameters[
								primitive,
								Cache -> allPackets,
								DefineLookup -> definedNamesLookup,
								RequiredObjectsLookup -> requiredObjectsLookup
							],
						_,
							primitive
					]
				],
				optimizedPrimitives
			],
			optimizedPrimitives
		];

		(* Return expected tuple *)
		{resolvedManipulations,allPipettingParameterTests,invalidParametersQ}
	];

	(* Determine if we want to get the tare weight for an object *)
	(* We don't need a tare weight if one is already recorded for the container and we can't get one if the container is Immobile *)
	(* Also skip if we're doing this to satisfy a resource request since we'll throw out the container afterwards *)
	skipTareFunction[containerResource_]:=Module[{involvedContainer,containerPacket,containerModel,containerModelPacket,containerModelsToNotTareWeigh},

		(* Extract container or container model *)
		(* containerResource could be a container object, model container object, or a resource wrapped in Link *)
		involvedContainer=If[MatchQ[containerResource,Link[_Resource]],
			First[containerResource][Sample],
			containerResource
		];

		{containerPacket,containerModelPacket}=If[MatchQ[involvedContainer,ObjectP[Model]],
			{<||>,fetchPacketFromCacheHPLC[involvedContainer,allPackets]},
			Module[{packet,model,modelPacket},
				packet = fetchPacketFromCacheHPLC[involvedContainer,allPackets];
				model = Lookup[packet,Model,Null];
				modelPacket = fetchPacketFromCacheHPLC[model,allPackets];
				{packet,modelPacket}
			]
		];

		containerModelsToNotTareWeigh={
			(* Phytip columns -- we throw these out at the end so there's no point in tare weighing. *)
			Model[Container, Vessel, "id:zGj91a7nlzM6"]
		};

		Quiet[Or[
			MatchQ[Lookup[safeOptions,PreparedResources],{ObjectP[]..}],
			MatchQ[Lookup[containerPacket,TareWeight,Null],MassP],
			MatchQ[Lookup[containerModelPacket,Immobile,Null],True],
			MatchQ[Lookup[containerModelPacket,Object,Null],ObjectP[containerModelsToNotTareWeigh]]
		]]
	];

	(* from the required objects, pull out any required containers; containers (or models) will only show up in
	 	requiredObjects if they are empty; we want to tare-weigh these guys if necessary (don't already have TareWeight); required objects might be failed, so pretend it's empty since we're gonna fail later *)
	possibleContainersToTare = Map[
		Function[requiredObjectEntry,
			Switch[First[requiredObjectEntry],
				ObjectReferenceP[Model@@#&/@SingleSampleContainerTypes]|{_Symbol|_Integer,ObjectReferenceP[Model@@#&/@SingleSampleContainerTypes]},
					If[skipTareFunction[Last[requiredObjectEntry]],
						Nothing,
						Last[requiredObjectEntry]
					],
				ObjectReferenceP[SingleSampleContainerTypes],
					If[skipTareFunction[First[requiredObjectEntry]],
						Nothing,
						Last[requiredObjectEntry]
					],
				_String,
					Module[{definePrimitive},

						definePrimitive = Lookup[definedNamesLookup,First[requiredObjectEntry]];

						Which[
							MatchQ[definePrimitive[Sample],ObjectReferenceP[Model[Sample]]],
								Nothing,
							MatchQ[definePrimitive[Container],ObjectReferenceP[SingleSampleContainerTypes]],
								If[skipTareFunction[definePrimitive[Container]],
									Nothing,
									Last[requiredObjectEntry]
								],
							MatchQ[definePrimitive[Container],ObjectReferenceP[Model@@#&/@SingleSampleContainerTypes]],
								If[skipTareFunction[Last[requiredObjectEntry]],
									Nothing,
									Last[requiredObjectEntry]
								],
							MatchQ[definePrimitive[Sample],{ObjectReferenceP[SingleSampleContainerTypes],WellPositionP}],
								If[skipTareFunction[First[definePrimitive[Sample]]],
									Nothing,
									Last[requiredObjectEntry]
								],
							MatchQ[definePrimitive[Sample],ObjectReferenceP[SingleSampleContainerTypes]],
								If[skipTareFunction[definePrimitive[Sample]],
									Nothing,
									Last[requiredObjectEntry]
								],
							MatchQ[definePrimitive[Sample],{ObjectReferenceP[Model@@#&/@SingleSampleContainerTypes],WellPositionP}],
								If[skipTareFunction[Last[requiredObjectEntry]],
									Nothing,
									Last[requiredObjectEntry]
								],
							MatchQ[definePrimitive[Sample],ObjectReferenceP[Model@@#&/@SingleSampleContainerTypes]],
								If[skipTareFunction[Last[requiredObjectEntry]],
									Nothing,
									Last[requiredObjectEntry]
								],
							True,
								Nothing
						]
					],
				_,
					Nothing
			]
		],
		requiredObjectsNotFailed
	];

	(* Define a function to convert any possible form in possibleTareContainers to a Model[Container] ObjectReference *)
	toContainerModel[item_] := Switch[item,
		ObjectP[Object[Container]],
			fetchModelPacketFromCacheHPLC[item,allPackets],
		ObjectP[Model[Container]],
			item,
		Link[_Resource],
			Lookup[item[[1, 1]], Sample]
	];

	(* Look up container model tare weight field for each container to be tare weighed *)
	(* skipTareFunction above will already have excluded any Object[Container] that has TareWeight, so the model is all we need to look at *)
	tareContainerModelTareWeights = Map[
		Function[{singleTareContainer},
			Module[{containerModel, containerModelPacket},
				(* Look up the container model; method depends on whether we've been passed a container, a container model, or a link to a Resource primitive *)
				containerModel = toContainerModel[singleTareContainer];
				(* Look up the container model's packet and extract the TareWeight *)
				containerModelPacket=fetchPacketFromCacheHPLC[containerModel,allPackets];
				Quiet[Lookup[containerModelPacket, TareWeight, Null]]
			]
		],
		possibleContainersToTare
	];

	(* Find any containers to be tare weighed that do not have a model tare weight *)
	tareContainersWithoutModelTareWeight = PickList[possibleContainersToTare, tareContainerModelTareWeights, Null];

	(* If TareWeighContainers->False and any containers to be tared do not have model tare weight, we need to throw an error *)
	tareContainerTareWeightErrorQ = And[MatchQ[Lookup[safeOptions, TareWeighContainers], False], !MatchQ[tareContainersWithoutModelTareWeight, {}]];

	(* Generate tests / throw errors for TareWeighContainers if necessary *)
	tareContainerTareWeightTest = If[tareContainerTareWeightErrorQ,
		(
			If[messagesBoolean,
				(
					Message[Error::InvalidOption,TareWeighContainers];
					Message[Error::MissingTareWeight,toContainerModel/@tareContainersWithoutModelTareWeight];
					Null
				),
				testOrNull["If TareWeighContainers->False, TareWeight exists in Models of all containers that would otherwise be tare weighed:",False]
			]
		),
		If[gatherTests,
			testOrNull["If TareWeighContainers->False, TareWeight exists in Models of all containers that would otherwise be tare weighed:",True],
			Null
		]
	];

	(* No need to weight containers if we're just going to trash them *)
	resolvedTareWeighContainers=Switch[Lookup[safeOptions, {TareWeighContainers,SamplesOutStorageCondition}],
		{BooleanP,_},Lookup[safeOptions, TareWeighContainers],
		{Automatic,Disposal},False,
		_,True
	];

	(* If TareWeighContainers->False, clear out the list and don't tare anything. Appropriate error checking has been done above
		to catch cases where this option should not be allowed to be False. *)
	tareContainers = If[resolvedTareWeighContainers, possibleContainersToTare, {}];

	(* resolve the PreFlush option; can only do this if we're at Bufferbot liquid handling scale *)
	resolvedPreFlush = If[MatchQ[PreFlush/.safeOptions,Automatic],
		MatchQ[scaleToUseForFurtherResolving,Bufferbot],
		If[MatchQ[scaleToUseForFurtherResolving,Bufferbot],
			PreFlush/.safeOptions,
			(* direct bool was supplied but we're not actually using bufferbot; change to Null *)
			False
		]
	];

	(* get all the incubations that we know are Incubate on the MicroLiquidHandling scale *)
	specifiedMicroIncubations = PickList[resolvedIncubatePrimitives,scaleByIncubateKeys,MicroLiquidHandling];

	(* Extract known containers or tagged model containers from each incubation
	in the form {{container or tagged model container ..}..} (one list of tagged containers
	for each incubation primitive) *)
	taggedIncubationContainers = Map[
		MapThread[
			Function[{source,sourceLocation},
				Which[
					(* Tagged Model container *)
					MatchQ[source,_String|{_Symbol|_String|_Integer,ObjectP[Model[Container]]}],
						source,
					(* Model tag with well *)
					MatchQ[source,{_String|{_Symbol|_String|_Integer,ObjectP[Model[Container]]},WellPositionP}],
						source[[1]],
					(* If source location is a container or container and well, fetch its model from the cache *)
					MatchQ[sourceLocation,ObjectP[Object[Container]]],
						sourceLocation,
					MatchQ[sourceLocation,PlateAndWellP],
						sourceLocation[[1]],
					True,
						Null
				]
			],
			{#[Sample],#[ResolvedSourceLocation]}
		]&,
		specifiedMicroIncubations
	];


	(* --- The following block generates VialPlacements to move any vials onto liquid-handler-compatible vial holders ---  *)
	vialPlacements = Module[
		{taggedCEVialIncubationTuples,gatheredCEVialIncubations,
		vialGroups,ceVialRackModelPacket,partitionedCEVials,ceVialRackResources},

		(* Extract containers or tagged model containers that have a CEVial footprint and their incubation parameters
		in the form {{{container or tagged model container, incubation sample (ie: what will be in RequiredObjects), {incubation params}}..}..} where each sublist
		represents the CEVials and params for a single incubation *)
		taggedCEVialIncubationTuples = MapThread[
			DeleteDuplicates@Function[{taggedContainers,incubation},
				MapThread[
					Function[{taggedContainer,incubationSample,incubationParams},
						Module[{modelContainer,modelContainerPacket},

							If[NullQ[taggedContainer],
								Return[Nothing,Module]
							];

							modelContainer = Switch[taggedContainer,
								ObjectP[Object[Container]],
									Download[Lookup[fetchPacketFromCacheHPLC[taggedContainer,allPackets],Model],Object],
								_String,
									fetchDefineModelContainer[Lookup[definedNamesLookup,taggedContainer],Cache->allPackets],
								_,
									taggedContainer[[2]]
							];

							If[NullQ[modelContainer],
								Return[Nothing,Module]
							];

							modelContainerPacket = fetchPacketFromCacheHPLC[modelContainer,allPackets];

							If[MatchQ[Lookup[modelContainerPacket,Footprint],CEVial],
								{taggedContainer,incubationSample,incubationParams},
								Nothing
							]
						]
					],
					{taggedContainers,incubation[Sample],Transpose@Lookup[First[incubation],{Time,Temperature,MixRate,Preheat,ResidualIncubation,ResidualTemperature,ResidualMix,ResidualMixRate}]}
				]
			],
			{taggedIncubationContainers,specifiedMicroIncubations}
		];

		(* CE Vials gathered by incubation parameters (ie each sublist of vessels
		represents a set of vessels incubated at the same parameters) *)
		gatheredCEVialIncubations = Join@@Map[
			Function[incubationTuples,
				(* Use SameQ in case parameters are equivalent but use different units.
				Extract Sample of Incubation since this will be used later to find
				appropriate resource in RequiredObjects *)
				Gather[incubationTuples,SameQ[#1[[-1]],#2[[-1]]]&][[All,All,2]]
			],
			taggedCEVialIncubationTuples
		];

		(* Build sets of vials that can be placed in the same rack
		(ie: they always have the same incubation parameters) *)
		vialGroups = GatherBy[
			DeleteDuplicates[Join@@gatheredCEVialIncubations],
			Function[vial,
				Map[MemberQ[#,vial]&,gatheredCEVialIncubations]
			]
		];

		(* Fetch packet for ce vial rack model *)
		ceVialRackModelPacket = fetchPacketFromCacheHPLC[ceVialRackModel,allPackets];

		(* Split list of CE vials by the number of positions in each vial rack *)
		partitionedCEVials = Join@@(PartitionRemainder[#,Lookup[ceVialRackModelPacket,NumberOfPositions]]&/@vialGroups);

		(* Create a resource for all required vial racks *)
		ceVialRackResources = Table[
			Resource[Sample -> ceVialRackModel, Rent -> True, Name -> CreateUUID[]],
			Length[partitionedCEVials]
		];

		(* Generate placements to manually move vials into their rack in the form {{source resource, rack, rack position}..} *)
		Join@@MapThread[
			Function[{vials,rackResource},
				MapThread[
					(* RequiredObjects entry already has Link wrapper *)
					{Lookup[requiredObjectsLookup,Key[#1]],Link[rackResource],#2}&,
					{vials,Lookup[ceVialRackModelPacket,Positions][[All,Key[Name]]][[;;Length[vials]]]}
				]
			],
			{partitionedCEVials,ceVialRackResources}
		]
	];

	(* Determine if the slide-in Hamilton CE Vial rack is required in addition to any SBS-style vial racks *)
	hplcVialHamiltonRackRequiredQ = Module[{ceVialResourcesOnSBSRack,requiredObjectsWithoutSBSRackedVials},

		(* If we're not even using a liquid handler, then we definitely don't need the Hamilton CE vial rack *)
		If[!MatchQ[scaleToUseForFurtherResolving,MicroLiquidHandling],
			Return[False,Module]
		];

		(* Fetch resources for vials that are going to be placed in a SBS rack *)
		ceVialResourcesOnSBSRack = vialPlacements[[All,1]];

		(* Fetch elements of RequiredObjects which correspond to objects not being placed in an SBS rack *)
		requiredObjectsWithoutSBSRackedVials = Cases[
			requiredObjects,
			{requiredObject_,Except[Alternatives@@ceVialResourcesOnSBSRack]}:>requiredObject
		];

		(* If any of the RequiredObjects are not in an SBS rack and their container model
		has a CEVial footprint, then we know there will be CEVials off the SBS racks and
		therefore the Hamilton CE vial rack is required to be rented *)
		AnyTrue[
			requiredObjectsWithoutSBSRackedVials,
			Function[requiredObject,
				Switch[requiredObject,
					_String,
						Module[{definePrimitive,modelContainer,modelContainerPacket},

							definePrimitive = Lookup[definedNamesLookup,requiredObject];

							modelContainer = fetchDefineModelContainer[definePrimitive,Cache->allPackets];

							If[NullQ[modelContainer],
								Return[False,Module]
							];

							modelContainerPacket = fetchPacketFromCacheHPLC[modelContainer,allPackets];

							MatchQ[Lookup[modelContainerPacket,Footprint],CEVial]
						],
					{_Symbol|_String|_Integer,ObjectP[Model[Container]]},
						MatchQ[Lookup[fetchPacketFromCacheHPLC[requiredObject[[2]],allPackets],Footprint],CEVial],
					ObjectP[Object[Container]],
						MatchQ[
							Lookup[
								(* Fetch container's model packet *)
								fetchPacketFromCacheHPLC[Download[Lookup[fetchPacketFromCacheHPLC[requiredObject,allPackets],Model],Object],allPackets],
								Footprint
							],
							CEVial
						],
					ObjectP[Object[Sample]],
						MatchQ[
							Lookup[
								(* Fetch sample's container's model packet *)
								fetchPacketFromCacheHPLC[
									Download[
										Lookup[
											fetchPacketFromCacheHPLC[
												Download[Lookup[fetchPacketFromCacheHPLC[requiredObject,allPackets],Container],Object],
												allPackets
											],
											Model
										],
										Object
									],
									allPackets
								],
								Footprint
							],
							CEVial
						],
					_,
						False
				]
			]
		]
	];

	(* --- Define internal function to extract the container or tagged model container of a manipulation --- *)
	fetchContainerSpecificationFunction[reference_,resolvedLocation_]:=Which[
		(* Tagged Model container *)
		MatchQ[reference,{_Symbol|_String|_Integer,ObjectP[Model[Container]]}],
			reference,
		(* Model tag with well *)
		MatchQ[reference,{{_Symbol|_String|_Integer,ObjectP[Model[Container]]},_String}],
			reference[[1]],
		(* If source location is a container or container and well, fetch its model from the cache *)
		MatchQ[resolvedLocation,ObjectP[Object[Container]]],
			resolvedLocation,
		MatchQ[resolvedLocation,PlateAndWellP],
			resolvedLocation[[1]],
		(* Tagged Model container *)
		MatchQ[reference,_String],
			reference,
		True,
			Null
	];

	vesselRackPlacements = Module[
		{referenceResolvedLocationTuples,incubationResolvedLocationTuples,nonIncubationReferenceResolvedLocationTuples,
		nonIncubationContainerSpecifications,nonIncubationManipulationsModelContainers,taggedVesselIncubationTuples,
		gatheredVesselIncubationTuples,nonIncubationVesselRackTuples,vesselGroupTuples,numberOfPositions,
		partitionedVesselGroups,vesselRackResources,rackPositions},

		modelContainerRackLookup = Association[
			Map[
				(# -> Download[Lookup[fetchPacketFromCacheHPLC[#,allPackets],LiquidHandlerAdapter],Object])&,
				Cases[modelContainersRequiringAdapting,ObjectP[Model[Container,Vessel]]]
			]
		];

		(* Fetch source/destination and resolved source/destination locations for all objects
		Tuples in the form {{source/destination, resolved source/destination location}..} *)
		referenceResolvedLocationTuples = DeleteDuplicates[
			Join@@Map[
				Switch[#,
					_Transfer,
						Join[
							Join@@MapThread[
								Transpose[{#1,#2}]&,
								{#[Source],#[ResolvedSourceLocation]}
							],
							Join@@MapThread[
								Transpose[{#1,#2}]&,
								{#[Destination],#[ResolvedDestinationLocation]}
							]
						],
					_FillToVolume,
						{
							{#[Source],#[ResolvedSourceLocation]},
							{#[Destination],#[ResolvedDestinationLocation]}
						},
					_Incubate|_Mix|_Centrifuge,
						Transpose[{#[Sample],#[ResolvedSourceLocation]}],
					_Pellet,
						Join[
							MapThread[
								{#1,#2}&,
								{#[Sample],#[ResolvedSourceLocation]}
							],
							If[MatchQ[#[SupernatantDestination],{(objectSpecificationP|{ObjectReferenceP[Object[Container,Vessel]],WellPositionP})..}] && KeyExistsQ[First[#],ResolvedSupernatantDestinationLocation],
								MapThread[
									{#1,#2}&,
									{#[SupernatantDestination],#[ResolvedSupernatantDestinationLocation]}
								],
								{}
							],
							If[MatchQ[#[ResuspensionSource],{(objectSpecificationP|{ObjectReferenceP[Object[Container,Vessel]],WellPositionP})..}] && KeyExistsQ[First[#],ResolvedResuspensionSourceLocation],
								MapThread[
									{#1,#2}&,
									{#[ResuspensionSource],#[ResolvedResuspensionSourceLocation]}
								],
								{}
							]
						],
					_,{{Null,Null}}
				]&,
				manipulationsWithPipettingParameters
			]
		];

		(* Find the resolved location for any samples being incubated *)
		incubationResolvedLocationTuples = Join@@Map[
			Transpose[{#[Sample],#[ResolvedSourceLocation]}]&,
			specifiedMicroIncubations
		];

		(* Find the referenced location tuples that are never incubated *)
		nonIncubationReferenceResolvedLocationTuples = Select[
			referenceResolvedLocationTuples,
			And[
				!MemberQ[incubationResolvedLocationTuples[[All,2]],#[[2]]],
				!MemberQ[incubationResolvedLocationTuples[[All,1]],#[[1]]]
			]&
		];

		(* Fetch the container or tagged container model for each tuple *)
		nonIncubationContainerSpecifications = Map[
			fetchContainerSpecificationFunction[#[[1]],#[[2]]]&,
			nonIncubationReferenceResolvedLocationTuples
		];

		(* For each container specification, fetch model container *)
		nonIncubationManipulationsModelContainers = Map[
			Switch[#,
				_String,
					Download[
						fetchDefineModelContainer[Lookup[definedNamesLookup,#],Cache->allPackets],
						Object
					],
				ObjectP[Object[Container]],
					Download[Lookup[fetchPacketFromCacheHPLC[#,allPackets],Model],Object],
				Null,
					#,
				_,
					Download[#[[2]],Object]
			]&,
			nonIncubationContainerSpecifications
		];

		(* Extract containers or tagged model containers that have a corresponding rack and their incubation parameters
		in the form {{{container or tagged model container, incubation sample (ie: what will be in RequiredObjects), {incubation params}}..}..} where each sublist
		represents the vessels and params for a single incubation *)
		taggedVesselIncubationTuples = MapThread[
			DeleteDuplicates@Function[{taggedContainers,incubation},
				MapThread[
					Function[{taggedContainer,incubationSample,incubationParams},
						Module[{modelContainer,modelContainerPacket},

							If[NullQ[taggedContainer],
								Return[Nothing,Module]
							];

							modelContainer = Switch[taggedContainer,
								ObjectP[Object[Container]],
									Download[Lookup[fetchPacketFromCacheHPLC[taggedContainer,allPackets],Model],Object],
								_String,
									fetchDefineModelContainer[Lookup[definedNamesLookup,taggedContainer],Cache->allPackets],
								_,
									taggedContainer[[2]]
							];

							If[NullQ[modelContainer],
								Return[Nothing,Module]
							];

							modelContainerPacket = fetchPacketFromCacheHPLC[modelContainer,allPackets];

							If[MemberQ[Keys[modelContainerRackLookup],ObjectP[Lookup[modelContainerPacket,Object]]],
								{taggedContainer,incubationSample,Lookup[modelContainerRackLookup,Lookup[modelContainerPacket,Object]],incubationParams},
								Nothing
							]
						]
					],
					{taggedContainers,incubation[Sample],Transpose@Lookup[First[incubation],{Time,Temperature,MixRate,Preheat,ResidualIncubation,ResidualTemperature,ResidualMix,ResidualMixRate}]}
				]
			],
			{taggedIncubationContainers,specifiedMicroIncubations}
		];

		(* Vessels gathered by incubation parameters (ie each sublist of vessels
		represents a set of vessels incubated at the same parameters) *)
		gatheredVesselIncubationTuples = Join@@Map[
			Function[incubationTuples,
				(* Use SameQ in case parameters are equivalent but use different units.
				Extract Sample of Incubation since this will be used later to find
				appropriate resource in RequiredObjects *)
				Gather[
					incubationTuples,
					And[
						MatchQ[#1[[3]],#2[[3]]],
						SameQ[#1[[-1]],#2[[-1]]]
					]&
				][[All,All,{2,3}]]
			],
			taggedVesselIncubationTuples
		];

		(* If a specified location exists in the modelContainerRackLookup, it means
		it will need to be placed in a vessel rack and included in VesselRackPlacements.
		Output tuples in the form: {{object reference, required rack model}..} *)
		nonIncubationVesselRackTuples = MapThread[
			If[MemberQ[Keys[modelContainerRackLookup],ObjectP[#2]],
				(* Take first index of tuple since that is what will be specified in RequiredObjects *)
				{#1[[1]],Lookup[modelContainerRackLookup,Key[#2]]},
				Nothing
			]&,
			{nonIncubationReferenceResolvedLocationTuples,nonIncubationManipulationsModelContainers}
		];

		(* Build sets of vials that can be placed in the same rack
		(ie: they always have the same incubation parameters) *)
		vesselGroupTuples = Join[
			GatherBy[
				DeleteDuplicates[Join@@gatheredVesselIncubationTuples],
				Function[tuple,
					Map[MemberQ[#,tuple]&,gatheredVesselIncubationTuples]
				]
			],
			If[Length[nonIncubationVesselRackTuples] > 0,
				GatherBy[nonIncubationVesselRackTuples,#[[2]]&],
				{}
			]
		];

		If[Length[Join@@vesselGroupTuples] == 0,
			Return[{},Module]
		];

		(* For each unique rack type being used, fetch the max number of vessels
		we can place in it *)
		numberOfPositions = Map[
			Lookup[fetchPacketFromCacheHPLC[#,allPackets],NumberOfPositions]&,
			vesselGroupTuples[[All,All,2]][[All,1]]
		];

		(* Partition each group of objects requiring a specific rack model into
		groups with max length of the number of positions of the rack model needed *)
		partitionedVesselGroups = Join@@MapThread[
			PartitionRemainder[#1,#2]&,
			{vesselGroupTuples,numberOfPositions}
		];

		(* Create a resource for each required vessel rack *)
		vesselRackResources = Map[
			Resource[Sample -> #, Rent -> True, Name -> CreateUUID[]]&,
			partitionedVesselGroups[[All,All,2]][[All,1]]
		];

		(* Get the positions in which each vessel will be placed for each group *)
		rackPositions = Map[
			Module[{modelContainerPacket,allWells,convertedWells},

				(* Fetch rack model packet *)
				modelContainerPacket = fetchPacketFromCacheHPLC[#[[1,2]],allPackets];

				(* Get all transposed rack well indices. Use TransposedIndex because we want to preferentially
				use A1,B1,C1,... such that the pipetting channels are used most efficiently. *)
				allWells = Flatten@Transpose@AllWells[
					AspectRatio -> (Lookup[modelContainerPacket,Columns]/Lookup[modelContainerPacket,Rows]),
					NumberOfWells -> Lookup[modelContainerPacket,NumberOfPositions],
					OutputFormat -> TransposedIndex
				];

				(* Convert the wells back to position names *)
				convertedWells = ConvertWell[allWells,
					AspectRatio -> (Lookup[modelContainerPacket,Columns]/Lookup[modelContainerPacket,Rows]),
					NumberOfWells -> Lookup[modelContainerPacket,NumberOfPositions],
					InputFormat -> TransposedIndex
				];

				convertedWells[[;;Length[#]]]
			]&,
			partitionedVesselGroups
		];

		(* Generate placements to manually move vessels into their rack
		in the form {{source resource, rack, rack position}..} *)
		Join@@MapThread[
			Function[{vessels,rackResource,positions},
				MapThread[
					Module[{requiredObjectsKey},

						(* So the RequiredObjects entry for samples and containers, even if they're defined,
						will be the objects (not any defined labels). Extract the underlying object from any labels) *)
						requiredObjectsKey = Which[
							And[
								MatchQ[#1,_String],
								MatchQ[Lookup[definedNamesLookup,#1][Sample],ObjectP[Object[Sample]]]
							],
								Lookup[definedNamesLookup,#1][Sample],
							And[
								MatchQ[#1,_String],
								MatchQ[Lookup[definedNamesLookup,#1][Container],ObjectP[Object[Container]]]
							],
								Lookup[definedNamesLookup,#1][Container],
							(* If we get a sample, use it since we have samples in the RequiredObjects *)
							MatchQ[#1,NonSelfContainedSampleModelP|{_Integer,ObjectP[Model[Container]]}],
								#1,
							MatchQ[#1,_String],
								#1,
							(* If we have a container, get its sample. If it is empty, then go with the contianer itself *)
							True,
								FirstOrDefault[Download[Lookup[fetchPacketFromCacheHPLC[#1,allPackets],Contents,{}][[All,2]],Object],#1]
						];

						(* RequiredObjects entry already has Link wrapper *)
						{Lookup[requiredObjectsLookup,Key[requiredObjectsKey]],Link[rackResource],#2}
					]&,
					{vessels,positions}
				]
			],
			{partitionedVesselGroups[[All,All,1]],vesselRackResources,rackPositions}
		]
	];

	(* Join all placements *)
	allVesselPlacements = Join[vialPlacements,vesselRackPlacements];

	plateAdapterPlacements = Module[
		{modelContainerAdapterLookup,referenceResolvedLocationTuples,containerSpecifications,
		containerSpecificationModels,plateAdapterTuples,plateAdapterResources},

		modelContainerAdapterLookup = Association[
			Map[
				(# -> Download[Lookup[fetchPacketFromCacheHPLC[#,allPackets],LiquidHandlerAdapter],Object])&,
				Cases[modelContainersRequiringAdapting,ObjectP[Model[Container,Plate]]]
			]
		];
		
		(* Fetch source/destination and resolved source/destination locations for all objects
		Tuples in the form {{source/destination, resolved source/destination location}..} *)
		referenceResolvedLocationTuples = DeleteDuplicates[
			Join@@Map[
				Switch[#,
					_Transfer,
						Join[
							Join@@MapThread[
								Transpose[{#1,#2}]&,
								{#[Source],#[ResolvedSourceLocation]}
							],
							Join@@MapThread[
								Transpose[{#1,#2}]&,
								{#[Destination],#[ResolvedDestinationLocation]}
							]
						],
					_FillToVolume,
						{
							{#[Source],#[ResolvedSourceLocation]},
							{#[Destination],#[ResolvedDestinationLocation]}
						},
					_Incubate|_Mix|_Centrifuge,
						Transpose[{#[Sample],#[ResolvedSourceLocation]}],
					_Pellet,
						Join[
							MapThread[
								{#1,#2}&,
								{#[Sample],#[ResolvedSourceLocation]}
							],
							If[MatchQ[#[SupernatantDestination],{(objectSpecificationP|{ObjectReferenceP[Object[Container,Vessel]],WellPositionP})..}] && KeyExistsQ[First[#],ResolvedSupernatantDestinationLocation],
								MapThread[
									{#1,#2}&,
									{#[SupernatantDestination],#[ResolvedSupernatantDestinationLocation]}
								],
								{}
							],
							If[MatchQ[#[ResuspensionSource],{(objectSpecificationP|{ObjectReferenceP[Object[Container,Vessel]],WellPositionP})..}] && KeyExistsQ[First[#],ResolvedResuspensionSourceLocation],
								MapThread[
									{#1,#2}&,
									{#[ResuspensionSource],#[ResolvedResuspensionSourceLocation]}
								],
								{}
							]
						],
					_,{{Null,Null}}
				]&,
				manipulationsWithPipettingParameters
			]
		];

		(* Fetch the container or tagged container model for each tuple *)
		containerSpecifications=DeleteDuplicates[
			(* all Nulls are removed before deleting duplicates *)
			ReplaceAll[
				(* mapping below generates a list of plates  *)
				MapThread[
					Function[{referenceSource,referenceSourceLocation},
						Which[
							(* Tagged Model container *)
							MatchQ[referenceSource,_String|{_Symbol|_String|_Integer,ObjectP[Model[Container]]}],
								referenceSource,
							(* Model tag with well *)
							MatchQ[referenceSource,{_String|{_Symbol|_String|_Integer,ObjectP[Model[Container]]},WellPositionP}],
								referenceSource[[1]],
							(* If source location is a container or container and well, fetch its model from the cache *)
							MatchQ[referenceSourceLocation,ObjectP[Object[Container]]],
								referenceSourceLocation,
							MatchQ[referenceSourceLocation,PlateAndWellP],
								referenceSourceLocation[[1]],
							True,
								Null
						]
					],
					Transpose[referenceResolvedLocationTuples]
				],
				{Null->Nothing}
			]
		];

		(* For each container specification, fetch model container *)
		containerSpecificationModels = Map[
			Switch[#,
				_String,
					Download[
						fetchDefineModelContainer[Lookup[definedNamesLookup,#],Cache->allPackets],
						Object
					],
				ObjectP[Object[Container]],
					Download[Lookup[fetchPacketFromCacheHPLC[#,allPackets],Model],Object],
				Null,
					#,
				_,
					Download[#[[2]],Object]
			]&,
			containerSpecifications
		];

		(* If a specified location exists in the modelContainerAdapterLookup, it means
		it will need to be placed in a adapter rack and included in PlateAdapterPlacements.
		Output tuples in the form: {{object reference, required rack model}..} *)
		plateAdapterTuples = DeleteDuplicates@MapThread[
			If[MemberQ[Keys[modelContainerAdapterLookup],ObjectP[#2]],
				(* Take first index of tuple since that is what will be specified in RequiredObjects *)
				{#1,Lookup[modelContainerAdapterLookup,Key[#2]]},
				Nothing
			]&,
			{containerSpecifications,containerSpecificationModels}
		];

		If[Length[Join@@plateAdapterTuples] == 0,
			Return[{},Module]
		];

		(* Create a resource for each required vessel rack *)
		plateAdapterResources = Map[
			Resource[Sample -> #, Rent -> True, Name -> CreateUUID[]]&,
			plateAdapterTuples[[All,2]]
		];

		(* Generate placements to manually move vessels into their rack
		in the form {{source resource, rack, rack position}..} *)
		MapThread[
			Function[{plate,rackResource},
				Module[{requiredObjectsKey,placementObject},

					(* So the RequiredObjects entry for samples and containers, even if they're defined,
					will be the objects (not any defined labels). Extract the underlying object from any labels) *)
					requiredObjectsKey = Which[
						And[
							MatchQ[plate,_String],
							MatchQ[Lookup[definedNamesLookup,plate][Sample],ObjectP[Object[Sample]]]
						],
							Lookup[definedNamesLookup,plate][Sample],
						And[
							MatchQ[plate,_String],
							MatchQ[Lookup[definedNamesLookup,plate][Container],ObjectP[Object[Container]]]
						],
							Lookup[definedNamesLookup,plate][Container],
						True,
							plate
					];

					(* Pretty fat assumption here: If the specifier doesn't exist in RequiredObjects,
					it is a container (whose sample contents exist in RequiredObjects) *)
					placementObject = Lookup[
						requiredObjectsLookup,
						Key[requiredObjectsKey],
						Link[requiredObjectsKey]
					];

					(* RequiredObjects entry already has Link wrapper *)
					{placementObject,Link[rackResource],"Plate Slot"}
				]
			],
			{plateAdapterTuples[[All,1]],plateAdapterResources}
		]
	];

	(* -- Check if any primitives will transfer ventilated samples into open containers -- *)
	openContainerSafeQ[source:ObjectP[],destination:Null]:=True;
	openContainerSafeQ[source:Null,destination:ObjectP[]]:=True;
	openContainerSafeQ[source:Null,destination:Null]:=True;
	openContainerSafeQ[source:ObjectP[],destination:ObjectP[]]:=Module[
		{fumehoodRequired,destinationObject,destinationModel,openContainer},

		(* Check if source requires ventilation (i.e. must be used in a fume hood) *)
		fumehoodRequired=TrueQ[Lookup[fetchPacketFromCacheHPLC[source,allPackets],Ventilated,True]];

		(* Extract destination object. Destination could be specified as: object, {id,object}, {object,well}, {id,{object,well}} *)


		(* Get the model of the receiving container *)
		destinationModel=If[MatchQ[destination,ObjectP[Object]],
			Lookup[fetchPacketFromCacheHPLC[destination,allPackets],Model],
			destination
		];

		(* Determine if the destination can't be sealed *)
		openContainer=TrueQ[Lookup[fetchPacketFromCacheHPLC[destinationModel,allPackets],OpenContainer,True]];

		(* Transfer is not safe if a ventilated model is being moved into an open container *)
		!(fumehoodRequired&&openContainer)
	];

	(* Allow child protocols to bypass this check *)
	(* This allows handwash and maldi plate cleaning to proceed properly *)
	unsafeVentilatedTransfers=If[MatchQ[parentProtocol,ObjectP[]],
		{},
		Map[
			If[MatchQ[#,_Transfer],
				Module[{groupedSourceSamples,groupedDestinations,safetyBooleans},

					groupedSourceSamples=extractSourceSampleOrModels[#,DefineLookup->definedNamesLookup,Cache->allPackets];
					groupedDestinations=fetchDestinationModelContainers[#,DefineLookup->definedNamesLookup,Cache->allPackets];

					safetyBooleans=MapThread[
						openContainerSafeQ,
						{groupedSourceSamples,groupedDestinations},
						2
					];

					If[And@@Flatten[safetyBooleans,2],
						Nothing,
						#
					]
				],
				Nothing
			]&,
			manipulationsWithPipettingParameters
		]
	];

	unsafeTransfersExist=!MatchQ[unsafeVentilatedTransfers,{}];

	ventilatedTest=Test["None of the transfers specify that a substance which must be handled in a fume hood (Ventilated->True)",unsafeTransfersExist,False];

	If[unsafeTransfersExist&&!gatherTests,
		Message[Error::VentilatedOpenContainer,unsafeVentilatedTransfers]
	];

	splitMixPrimitives = If[MatchQ[scaleToUseForFurtherResolving,MicroLiquidHandling],
		Join@@Map[
			If[MatchQ[#,_Transfer|_Mix],
				splitMixing[#],
				{#}
			]&,
			manipulationsWithPipettingParameters
		],
		manipulationsWithPipettingParameters
	];

	(* make a time estimate for the liquid handling operation *)
	liquidHandlingEstimate=Module[
		{amounts,transferTime,incubationTime,centrifugeTime,pelletTime,fillToVolumeNumber},
		(* get a flat list of all the manipulation amounts *)
		amounts = Map[
			Switch[#,
				_Transfer,#[Amount],
				_Consolidation|_Aliquot,#[Amounts],
				(* make sure we're only calculating the Amounts if the Mix resolution didn't fail *)
				_Mix,If[!MatchQ[#[MixType],Except[Pipette,MixTypeP]],
					If[MatchQ[scaleToUseForFurtherResolving,MicroLiquidHandling],
						#[MixVolume],
						Join@@MapThread[
							Table[#1,#2]&,
							{#[MixVolume],#[NumberOfMixes]}
						]
					],
					Nothing
				],
				_,Nothing
			]&,
			splitMixPrimitives
		];

		(* Assume about 1 Minute per span-8 or 96-Head transfer *)
		transferTime = (1 Minute * Length[amounts]);

		(* Calculate the amount of time being incubated *)
		incubationTime = Total@Cases[(#[Time])&/@Cases[convertedMixIncubatePrimitives,_Incubate],TimeP];

		(* Calculate the amount of time samples are centrifuged *)
		centrifugeTime = Total@Cases[(Max[#[Time]])&/@Cases[splitMixPrimitives,_Centrifuge],TimeP];

		(* Calculate the amount of time samples are pelleted *)
		pelletTime = If[Length[Cases[splitMixPrimitives,_Pellet]]>0,
			1.25*Total@Cases[(Max[#[Time]])&/@Cases[splitMixPrimitives,_Pellet],TimeP],
			0 Minute
		];

		fillToVolumeNumber=Length[Cases[splitMixPrimitives,_FillToVolume]];

		(* if on the Hamilton, partition the amounts further and then time-multiply *)
		Switch[scaleToUseForFurtherResolving,
			MicroLiquidHandling,(transferTime+incubationTime+centrifugeTime+2 Minute),
			Bufferbot,10 Minute,
			MacroLiquidHandling,((5 Minute*Length[Flatten[amounts]]+fillToVolumeNumber*20 Minute)+pelletTime+incubationTime)
		]
	];

	(* Count the number of tips required of each type and build lookup to use for resource generation
	in the form: <|TipType1 -> _Integer, TipType2 -> _Integer, ...|> *)
	tipUsageLookup = If[MatchQ[scaleToUseForFurtherResolving,MicroLiquidHandling],
		Fold[
			Function[{currentLookup,nextPrimitive},
				(* If primitive is a transfer using the MultiProbeHead, we need to do special handling with tip counts
				because the entire remaining stack level will be discarded/skipped in order to use a full 96 tips  *)
				If[
					And[
						MatchQ[nextPrimitive,_Transfer],
						MatchQ[nextPrimitive[DeviceChannel],{MultiProbeHead..}],
						!NullQ[nextPrimitive[TipType][[1]]]
					],
					(* If tip type doesn't already exist, add it straight up *)
					If[!KeyExistsQ[currentLookup,nextPrimitive[TipType][[1]]],
						Append[currentLookup,(nextPrimitive[TipType][[1]])->Length[nextPrimitive[TipType]]],
						Module[{tipPacket,quotient,remainder,extraTipCount,updatedCount},

							(* Fetch tip packet *)
							tipPacket  =  fetchPacketFromCacheHPLC[nextPrimitive[TipType][[1]],allPackets];

							(* Find if there is any remaining tips in the current stack level (they will all be thrown away) *)
							{quotient,remainder} = QuotientRemainder[
								Lookup[currentLookup,nextPrimitive[TipType][[1]]],
								Lookup[tipPacket,NumberOfTips]
							];

							(* "Extra tips" mean tips that must be thrown out to expose a full 96 for the multiprobehead *)
							extraTipCount = If[remainder==0,
								0,
								Lookup[tipPacket,NumberOfTips]
							];

							(* Update the tip count to include the existing full stack levels, the extra tips that will be thrown
							away, and the number of tips used by the MultiProbeHead *)
							updatedCount = (Lookup[tipPacket,NumberOfTips]*quotient) + extraTipCount + Length[nextPrimitive[TipType]];

							Append[currentLookup,(nextPrimitive[TipType][[1]])->updatedCount]
						]
					],
					Merge[
						{
							currentLookup,
							Counts[DeleteCases[nextPrimitive[TipType],Null]]
						},
						Total
					]
				]
			],
			Association[],
			Cases[splitMixPrimitives,_Transfer|_Mix]
		],
		Association[]
	];

	(* Build lookup relating tip type to a list of tip counts partitioned by sample.
	For example, if we need 100 300ul stackable tips, <| 300ul tip type -> {4,96} ...|> *)
	partitionedTipCountLookup = Association@KeyValueMap[
		Function[{tipModel,requiredCount},
			Module[{tipPacket,stackSize,maxUsableTipCountPerStack,fullLayersNeeded,tipRemainder,numberOfFullTipBoxesNeeded,numberOfOtherLayersNeeded,tipBoxCounts},
				(* Fetch tip model packet *)
				tipPacket = fetchPacketFromCacheHPLC[tipModel,allPackets];

				(* Fetch the number of levels in a stack *)
				stackSize = If[TrueQ[Lookup[tipPacket,MaxStackSize] > 1],
					Lookup[tipPacket,MaxStackSize],
					1
				];

				(* NOTE: For every tip box, we want to make sure that we are requesting AT LEAST $HamiltonTipBoxBuffer extra tips. This is because *)
				(* our tip counts may not be exactly precise due to pipetting issues (re-performing the pipetting will result in extra tips being used) *)
				(* or incorrect tip counts in the tip objects. *)
				(* NOTE: Also, Hamilton may discard the top layer of a tip rack if it has less than 8 tips -- so $HamiltonTipBoxBuffer has *)
				(* to be AT LEAST 8. *)
				maxUsableTipCountPerStack = Lookup[tipPacket,NumberOfTips] - $HamiltonTipBoxBuffer;

				(* Get the number of layers of tips that we will need. *)
				{fullLayersNeeded, tipRemainder} = QuotientRemainder[requiredCount,maxUsableTipCountPerStack];

				(* Get the number of full tip boxes that we need. *)
				numberOfFullTipBoxesNeeded = Floor[fullLayersNeeded/stackSize];
				numberOfOtherLayersNeeded = fullLayersNeeded - (numberOfFullTipBoxesNeeded * stackSize);

				(* Create the list of the amounts of tips that we need in each of our tip boxes. *)
				tipBoxCounts = Prepend[
					Table[Lookup[tipPacket,NumberOfTips] * stackSize, numberOfFullTipBoxesNeeded],
					(* NOTE: We have to add $HamiltonTipBoxBuffer here again because tipRemainder will add another layer *)
					(* to our entire request, and we want $HamiltonTipBoxBuffer on each layer we request. *)
					Which[
						tipRemainder > 0 && numberOfOtherLayersNeeded > 0,
							(Lookup[tipPacket,NumberOfTips] * numberOfOtherLayersNeeded) + tipRemainder + $HamiltonTipBoxBuffer,
						tipRemainder > 0,
							tipRemainder + $HamiltonTipBoxBuffer,
						numberOfOtherLayersNeeded > 0,
							(Lookup[tipPacket,NumberOfTips] * numberOfOtherLayersNeeded),
						True,
							Nothing
					]
				];

				(* Return rule *)
				tipModel -> tipBoxCounts
			]
		],
		tipUsageLookup
	];

	(* List of unique tip types required *)
	uniqueTipTypes = Keys[tipUsageLookup];

	(* Extract required tip types that are stacked *)
	requiredStackedTipTypes = Select[
		uniqueTipTypes,
		TrueQ[Lookup[fetchPacketFromCacheHPLC[#,allPackets],MaxStackSize] > 1]&
	];

	(* Extract required tip types that are not stacked *)
	requiredNonStackedTipTypes = Complement[uniqueTipTypes,requiredStackedTipTypes];

	(* Build tuples of a stacked tip type and its required count for each sample request in the form:
	 {{tip type, tip count required}..}*)
	flattenedStackedTipTuples = Join@@Map[
		Function[tipModel,
			{tipModel,#}&/@Lookup[partitionedTipCountLookup,tipModel]
		],
		requiredStackedTipTypes
	];

	(* Build tuples of a non-stacked tip type and its required count for each sample request in the form:
	 {{tip type, tip count required}..}*)
	flattenedNonStackedTipTuples = Join@@Map[
		Function[tipModel,
			{tipModel,#}&/@Lookup[partitionedTipCountLookup,tipModel]
		],
		requiredNonStackedTipTypes
	];

	(* Join tip count tuples for both stacked and non-stacked tips *)
	allTipTypeCountTuples = Join[flattenedStackedTipTuples,flattenedNonStackedTipTuples];

	(* Create a resource for each tip sample with the required count *)
	allTipResources = Map[
		Resource[
			Name -> ToString[Unique[]],
			Sample -> #[[1]],
			Amount -> #[[2]],
			UpdateCount->False
		]&,
		allTipTypeCountTuples
	];

	(* Fetch the maximum number of positions for stacked and non stacked tips *)
	maxStackedTipPositions = 5;
	maxNonStackedTipPositions = 5;
	maxStackedSuperstarTipPositions = 5;
	maxNonStackedSuperstarTipPositions = 5;
	validTipCountQ = True;
	validTipCountTest = Null;

	(* Create a liquid handler resource with all liquid handler(s) that can do the manipulations at the resolved scale;
		also throw errors if a specific thing was asked for that won't work with the manips scale *)
	{liquidHandlerResource,liquidHandlerTest,validLiquidHandlerQ} = Switch[scaleToUseForFurtherResolving,
		MacroLiquidHandling,
			If[!MatchQ[liquidHandlerOption,Automatic]&&MatchQ[parentProtocol,Null],
				If[messagesBoolean,
					Message[Warning::UnusedLiquidHandler];
				];
				{Null,warningOrNull["If a LiquidHandler is specified, it is used:",False],True},
				{Null,warningOrNull["If a LiquidHandler is specified, it is used:",True],True}
			],
		Bufferbot,
			Which[
				MatchQ[liquidHandlerOption,Automatic],
					{
						Resource[Name->ToString[Unique[]],Instrument->Model[Instrument,LiquidHandler,"id:01G6nvkqJ5vK"]],
						Null,
						True
					}, (* Bufferbot *)
				MatchQ[liquidHandlerModel,Model[Instrument,LiquidHandler,"id:01G6nvkqJ5vK"]],
					{
						Resource[Name->ToString[Unique[]],Instrument->liquidHandlerOption],
						Null,
						True
					},
				(* if we were given some other liquid handler model, default it silently;
					while Bufferbot is a hidden option *)
				True,
					{
						Resource[Name->ToString[Unique[]],Instrument->Model[Instrument,LiquidHandler,"id:01G6nvkqJ5vK"]],
						Null,
						True
					}
			],
		MicroLiquidHandling,
			Module[
				{directContainerModels,requiredObjectsContainerModels,modelResources,modelResourceContainerModels,counterWeightModels,
				allContainerModels,allContainerModelPackets,groupedContainerModelPackets,requiredFootprintCounts,multipleHighPrecisionQ,
				starFootprintCounts,superstarFootprintCounts,multiProbeHeadQ,starletFootprintCounts,starFootprintRemainders,
				superstarFootprintRemainders,starletFootprintRemainders,validStarTipPositionsQ,
				validSuperstarTipPositionsQ,starQ,superstarQ,pseudoSuperstarQ,starletQ, requiresCoolingQ},

				(* --- determine all of the container models that will be required for the manipulations --- *)
				(* first get the models of all of the unique, directly-specified containers we already know about *)
				directContainerModels = Download[uniqueContainerPackets[[All,Key[Model]]],Object];

				(* get all the unique tagged container models we will be using;
					use requiredObjects for this; as always, we know they'll be tagged at this point *)
				requiredObjectsContainerModels = DeleteCases[
					Join[
						Map[
							fetchDefineModelContainer[Lookup[definedNamesLookup,#[[1]]],Cache->allPackets]&,
							Select[requiredObjectsNotFailed,MatchQ[First[#],_String]&]
						],
						Select[requiredObjectsNotFailed,MatchQ[First[#],{_Symbol|_Integer|_String,ObjectReferenceP[Model[Container]]}]&][[All,1,2]]
					],
					Null
				];

				(* also, we may need some sample model resources; pick the resource objects we made out of the required objects list  *)
				modelResources = Select[
					requiredObjectsNotFailed,
					Or[
						MatchQ[First[#],{_Symbol|_Integer|_String,ObjectReferenceP[Model[Sample]]}|ObjectReferenceP[Model[Sample]]],
						And[
							MatchQ[First[#],_String],
							MatchQ[Lookup[definedNamesLookup,First[#]][Sample],ObjectReferenceP[Model[Sample]]],
							(* If Container key is populated, we would've caught this resource in the line above (setting requiredObjectsContainerModels) *)
							!MatchQ[Lookup[definedNamesLookup,First[#]][Container],ObjectReferenceP[]]
						]
					]&
				][[All,2]];

				(* from the resources, we can get the container model that we asked for:
					- these resources have Link wrapped around them for upload readiness, so take First to get the resource blob alone
					- if there are multiple containers, assume both are gonna be there to be conservative *)
				modelResourceContainerModels=Flatten[First[#][Container]&/@modelResources];
				
				counterWeightModels = Download[Cases[requiredObjectsNotFailed[[All,1]],ObjectP[Model[Item,Counterweight]]],Object];

				(* combine the full list of container models we need for this protocol *)
				(* Note: This counts filter plates and collection plates separately, which is what we want since they need *)
				(* to be loaded onto the deck in separate positions. *)
				allContainerModels = Join[directContainerModels,requiredObjectsContainerModels,modelResourceContainerModels,counterWeightModels];
				
				allContainerModelPackets = Map[
					fetchPacketFromCacheHPLC[#,allPackets]&,
					allContainerModels
				];

				(* group the container models based on which ones need to go in which type of position *)
				groupedContainerModelPackets=GroupBy[allContainerModelPackets,Lookup[#,Footprint]&];

				(* further process this association by just turning each value (a list of the container models grouped by footprint)
						into the length (we just want the raw number of each position type that we need). Set negative so we can subtract from
					the total capacities below *)
				requiredFootprintCounts=<|KeyValueMap[
					#1->(-Length[#2])&,
					groupedContainerModelPackets
				]|>;

				(* another thing to check is how many HighPrecisionPositionRequired contianers *)
				multipleHighPrecisionQ = TrueQ[Count[Lookup[allContainerModelPackets,HighPrecisionPositionRequired,False],True]>1];

				(* -- define lookups that hard-code the number of each footprint position that the star and starlets have currently -- *)
				starFootprintCounts=<|Plate->6,MicrocentrifugeTube->60,Conical50mLTube->12,CEVial->30,MALDIPlate->1,AvantVial->12|>;

				(* Note: if you change the super star one please change it in aliquot too *)
				(* This means that implicitly, the low plate slot will always be open when we load up our deck. This happens to guarantee that if we are *)
				(* When filtering a position an additional position is needed since the collection plate and filter plate are not always stacked *)
				superstarFootprintCounts = Association[
					Plate -> If[MemberQ[manipulationsWithPipettingParameters,(_ReadPlate|_Centrifuge|_Filter)],
						16,
						17
					],
					MicrocentrifugeTube -> 64,
					Conical50mLTube -> 12,
					CEVial -> 30,
					(* Note: The phytip rack holder is a 96-well plate format that can hold a phytip column in each of the wells. *)
					PhytipColumn -> 96,
					GlassReactionVessel -> 96,
					MALDIPlate -> 1,
					AvantVial -> 12
				];

				multiProbeHeadQ=!MatchQ[Cases[Lookup[#[[1]],DeviceChannel]&/@manipulationsWithPipettingParameters,{MultiProbeHead..}],
					{}
				];
				starletFootprintCounts = Association[
					Plate -> If[Or[MemberQ[manipulationsWithPipettingParameters,(_ReadPlate|_Filter)],multiProbeHeadQ],
						4,
						5
					],
					MicrocentrifugeTube -> 30,
					Conical50mLTube -> 12,
					PhytipColumn -> 96,
					CEVial -> 30,
					MALDIPlate -> 1,
					AvantVial -> 12
				];


				(* get the remaining positions if we were to place this container set on each of the deck setups *)
				starFootprintRemainders=Merge[{starFootprintCounts,requiredFootprintCounts},Total];
				superstarFootprintRemainders=Merge[{superstarFootprintCounts,requiredFootprintCounts},Total];
				starletFootprintRemainders=Merge[{starletFootprintCounts,requiredFootprintCounts},Total];

				validStarTipPositionsQ = And[
					Length[flattenedStackedTipTuples] <= maxStackedTipPositions,
					Length[flattenedNonStackedTipTuples] <= maxNonStackedTipPositions
				];

				validSuperstarTipPositionsQ = And[
					Length[flattenedStackedTipTuples] <= maxStackedSuperstarTipPositions,
					Length[flattenedNonStackedTipTuples] <= maxNonStackedSuperstarTipPositions
				];

				(* find if any of the Incubate primitives require cooling *)
				requiresCoolingQ = Module[{incubatePrimitives, incubateTemperatures},
					incubatePrimitives= Cases[manipulationsWithPipettingParameters, _Incubate];
					If[MatchQ[incubatePrimitives, {}], Return[False, Module]];
					incubateTemperatures = Lookup[incubatePrimitives[[All,1]],Temperature];
					AnyTrue[incubateTemperatures, (MatchQ[First@#, LessP[24*Celsius]]&)]
				];

				(* See if we could use a star or starlet (no negative remainders)
				Star cannot support Incubate primitives *)
				starQ = And[
					AllTrue[starFootprintRemainders,NonNegative],
					!MemberQ[manipulationsWithPipettingParameters,(_Centrifuge|_Incubate|_Filter|_ReadPlate|_MoveToMagnet|_RemoveFromMagnet)],
					validStarTipPositionsQ
				];
				starletQ = And[
					AllTrue[starletFootprintRemainders,NonNegative],
					!MemberQ[
						manipulationsWithPipettingParameters,
						Alternatives[
							_Centrifuge,
							_Filter?(MatchQ[#[Intensity],Except[_Missing|Null]]&)
						]
					],
					!requiresCoolingQ,
					(* If we're either not using a plate reader or we're using an omega *)
					MatchQ[resolvedPlateReaderInstrument,Null|ObjectP[Model[Instrument,PlateReader,"id:mnk9jO3qDzpY"]]],
					validStarTipPositionsQ,
					!multipleHighPrecisionQ
				];
				superstarQ = And[
					AllTrue[superstarFootprintRemainders,NonNegative],
					(* If we're either not using a plate reader or we're using a clariostar *)
					MatchQ[resolvedPlateReaderInstrument,Null|ObjectP[Model[Instrument, PlateReader, "id:E8zoYvNkmwKw"]]],
					validSuperstarTipPositionsQ
				];

				pseudoSuperstarQ = And[
					AllTrue[superstarFootprintRemainders,NonNegative],
					(* If we're not using a centrifuge *)
					!MemberQ[manipulationsWithPipettingParameters,_Centrifuge],
					validSuperstarTipPositionsQ
				];

				validTipCountQ = Which[
					MatchQ[liquidHandlerOption,Automatic],
						If[And[!validStarTipPositionsQ,!validSuperstarTipPositionsQ],
							False,
							True
						],
					(* If option is not Automatic and is not the superstar *)
					And[
						!MatchQ[liquidHandlerOption,Automatic],
						!MatchQ[liquidHandlerModel,Model[Instrument, LiquidHandler, "id:7X104vnRbRXd"]]
					],
						validStarTipPositionsQ,
					True,
						validSuperstarTipPositionsQ
				];

				(* Build test for tip count validity *)
				validTipCountTest = If[!validTipCountQ,
					(
						If[messagesBoolean,
							(
								Message[Error::TooManyTipsRequired,Length[flattenedStackedTipTuples]+Length[flattenedNonStackedTipTuples]];
								Message[Error::InvalidInput,myRawManipulations];
								Null
							),
							testOrNull["For MicroLiquidHandling, tips for all manipulations can fit on a liquid handler deck:",False]
						]
					),
					If[gatherTests,
						testOrNull["For MicroLiquidHandling, tips for all manipulations can fit on a liquid handler deck:",True],
						Null
					]
				];

				(* return the appropriate response depending on initial option value, possible instruments *)
				If[MatchQ[liquidHandlerOption,Automatic],
					If[
						Or[starQ,superstarQ,starletQ,pseudoSuperstarQ],
						{
							Resource[
								Name->ToString[Unique[]],
								Instrument->PickList[
									(* Super Star, Starlet, Pseudo Super Star models *)
									{Model[Instrument, LiquidHandler, "id:7X104vnRbRXd"],Model[Instrument,LiquidHandler,"id:kEJ9mqaW7xZP"],Model[Instrument, LiquidHandler, "id:R8e1PjeLn8Bj"]},
									{superstarQ,starletQ,pseudoSuperstarQ},
									True
								],
								Time -> liquidHandlingEstimate
							],
							testOrNull["The input primitives are compatible with a liquid handler:",True],
							True
						},
						If[
							(* If tip count is not valid, we threw an error above so don't throw one here *)
							And[
								validTipCountQ,
								!Or[starQ,superstarQ,starletQ,pseudoSuperstarQ]
							],
							If[messagesBoolean,
								(
									Message[Error::TooManyContainers];
									Message[Error::InvalidInput,myRawManipulations];
								)
							];
							{$Failed,testOrNull["All required containers can fit on a liquid handler:",False],False},
							{$Failed,Null,False}
						]
					],
					Which[
						(*Incubate isn't supported on the STAR yet*)
						And[
							MatchQ[liquidHandlerModel,Model[Instrument,LiquidHandler,"id:aXRlGnZmOd9m"]],
							MemberQ[manipulationsWithPipettingParameters,_Incubate]
						],
							If[messagesBoolean,
								(
									Message[
										Error::IncompatibleLiquidHandler,
										liquidHandlerOption,
										Incubate,
										PickList[
											(* Super Star, Starlet models *)
											{Model[Instrument, LiquidHandler, "id:7X104vnRbRXd"],Model[Instrument,LiquidHandler,"id:kEJ9mqaW7xZP"],Model[Instrument, LiquidHandler, "id:R8e1PjeLn8Bj"]},
											{superstarQ,starletQ,pseudoSuperstarQ},
											True
										]
									];
									Message[Error::InvalidOption,LiquidHandler];
								)
							];
							{$Failed,testOrNull["The specified liquid handler is compatible with the input primitives:",False],False},
						(*MoveToMagnet isn't supported on the STAR yet*)
						And[
							MatchQ[liquidHandlerModel,Model[Instrument,LiquidHandler,"id:aXRlGnZmOd9m"]],
							MemberQ[manipulationsWithPipettingParameters,_MoveToMagnet]
						],
						If[messagesBoolean,
							(
								Message[
									Error::IncompatibleLiquidHandler,
									liquidHandlerOption,
									MoveToMagnet,
									PickList[
										(* Super Star, Starlet models *)
										{Model[Instrument, LiquidHandler, "id:7X104vnRbRXd"],Model[Instrument,LiquidHandler,"id:kEJ9mqaW7xZP"],Model[Instrument, LiquidHandler, "id:R8e1PjeLn8Bj"]},
										{superstarQ,starletQ,pseudoSuperstarQ},
										True
									]
								];
								Message[Error::InvalidOption,LiquidHandler];
							)
						];
						{$Failed,testOrNull["The specified liquid handler is compatible with the input primitives:",False],False},
						(*RemoveFromMagnet isn't supported on the STAR yet*)
						And[
							MatchQ[liquidHandlerModel,Model[Instrument,LiquidHandler,"id:aXRlGnZmOd9m"]],
							MemberQ[manipulationsWithPipettingParameters,_RemoveFromMagnet]
						],
						If[messagesBoolean,
							(
								Message[
									Error::IncompatibleLiquidHandler,
									liquidHandlerOption,
									RemoveFromMagnet,
									PickList[
										(* Super Star, Starlet models *)
										{Model[Instrument, LiquidHandler, "id:7X104vnRbRXd"],Model[Instrument,LiquidHandler,"id:kEJ9mqaW7xZP"],Model[Instrument, LiquidHandler, "id:R8e1PjeLn8Bj"]},
										{superstarQ,starletQ,pseudoSuperstarQ},
										True
									]
								];
								Message[Error::InvalidOption,LiquidHandler];
							)
						];
						{$Failed,testOrNull["The specified liquid handler is compatible with the input primitives:",False],False},
						Or[
							MatchQ[liquidHandlerModel,Model[Instrument,LiquidHandler,"id:aXRlGnZmOd9m"]]&&starQ,
							MatchQ[liquidHandlerModel,Model[Instrument, LiquidHandler, "id:7X104vnRbRXd"]]&&superstarQ,
							MatchQ[liquidHandlerModel,Model[Instrument,LiquidHandler,"id:kEJ9mqaW7xZP"]]&&starletQ,
							MatchQ[liquidHandlerModel,Model[Instrument, LiquidHandler, "id:R8e1PjeLn8Bj"]]&&pseudoSuperstarQ
						],
							{
								Resource[
									Name->ToString[Unique[]],
									Instrument->liquidHandlerOption,
									Time -> liquidHandlingEstimate
								],
								testOrNull["The specified liquid handler can accomodate the input primitives:",True],
								True
							},
						!starQ&&!superstarQ&&!starletQ&&!pseudoSuperstarQ,
							If[messagesBoolean,
								(
									Message[Error::TooManyContainers];
									Message[Error::InvalidInput,myRawManipulations];
								)
							];
							{$Failed,testOrNull["All required containers can fit on a liquid handler:",False],False},
						True,
							If[messagesBoolean,
								(
									Message[
										Error::InvalidLiquidHandler,
										liquidHandlerOption,
										PickList[
											(* Super Star, Starlet models *)
											{Model[Instrument, LiquidHandler, "id:7X104vnRbRXd"],Model[Instrument,LiquidHandler,"id:kEJ9mqaW7xZP"],Model[Instrument, LiquidHandler, "id:R8e1PjeLn8Bj"]},
											{superstarQ,starletQ,pseudoSuperstarQ},
											True
										]
									];
									Message[Error::InvalidOption,LiquidHandler];
								)
							];
							{$Failed,testOrNull["The specified liquid handler can accomodate the input primitives:",False],False}
					]
			]
		]
	];


	(*===MoveToMagnet/RemoveFromMagnet Checks===*)

	(*---Each magnet container must be a 96-well plate---*)
	If[MemberQ[manipulationsWithPipettingParameters,_MoveToMagnet|_RemoveFromMagnet],

		(*If there are MoveToMagnet/RemoveFromMagnet primitives, get those*)
		magnetPrimitives=Cases[manipulationsWithPipettingParameters,_MoveToMagnet|_RemoveFromMagnet];

		(*Fetch the source container models from the magnet primitives*)
		magnetContainerModels=DeleteDuplicates[
			DeleteCases[
				Flatten[
					fetchSourceModelContainers[
						#,
						Cache->allPackets,
						DefineLookup->definedNamesLookup,
						RequiredObjectsLookup->requiredObjectsLookup
					]&/@magnetPrimitives
				],
				Null
			]
		];

		(*Fetch packets for the source container models*)
		magnetContainerModelPackets=fetchPacketFromCacheHPLC[#,allPackets]&/@magnetContainerModels;

		(*If all magnet containers are plates and have 96 wells, then they're valid*)
		validMagnetContainerQ=If[MatchQ[Lookup[magnetContainerModelPackets,Type],ListableP[Model[Container,Plate]]],
			If[AllTrue[Lookup[magnetContainerModelPackets,NumberOfWells],#==96&],
				True,
				False
			],
			False
		];

		magnetContainerTest=If[!validMagnetContainerQ,
			(
				If[messagesBoolean,
					(
						Message[Error::IncompatibleMagnetContainer,magnetPrimitives];
						Message[Error::InvalidInput,magnetPrimitives];
						Null
					),
					testOrNull["The sample in the MoveToMagnet/RemoveFromMagnets primitive(s) is in a 96-well plate:",False]
				]
			),
			testOrNull["The sample in the MoveToMagnet/RemoveFromMagnets primitive(s) is in a 96-well plate:",True]
		],

		(*If there aren't MoveToMagnet/RemoveFromMagnet primitives, return a True Boolean and a Null test*)
		validMagnetContainerQ=True;
		magnetContainerTest=Null
	];

	(*---Filter and MoveToMagnet/RemoveFromMagnet primitives aren't currently supported together on any liquid handler - only 1 low position---*)
	validFilterMagnetQ=!And[
			!NullQ[liquidHandlerResource],
			MemberQ[manipulationsWithPipettingParameters,_Filter],
			MemberQ[manipulationsWithPipettingParameters,_MoveToMagnet|_RemoveFromMagnet]
	];

	filterMagnetTest=If[!validFilterMagnetQ,
		(
			If[messagesBoolean,
				(
					Message[Error::FilterMagnetPrimitives];
					Message[Error::InvalidInput,Cases[manipulationsWithPipettingParameters,_Filter|_MoveToMagnet|_RemoveFromMagnet]];
					Null
				),
				testOrNull["The Filter and MoveToMagnet/RemoveFromMagnet primitives aren't both specified:",False]
			]
		),
		testOrNull["The Filter and MoveToMagnet/RemoveFromMagnet primitives aren't both specified:",True]
	];


	(* Resolve ImageSample, MeasureVolume, and MeasureWeight *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[safeOptions];

	preferredOrientation = Lookup[safeOptions,PreferredSampleImageOrientation];
	resolvedPreferredSampleImageOrientation = Which[
		(* If it was left on automatic, then *)
		MatchQ[preferredOrientation,Automatic],Null,
		(* If not imaging, then  Null*)
		MatchQ[Lookup[resolvedPostProcessingOptions,ImageSample], False],Null,
		(* Use user value *)
		MatchQ[preferredOrientation,ImagingDirectionP],preferredOrientation
	];

	(* If Cover primitives are used, we don't place lids *)
	placeLidsQ = If[MatchQ[Lookup[safeOptions,PlaceLids],Automatic],
		True,
		Lookup[safeOptions,PlaceLids]
	];

	(* replace the options with the resolved option values *)
	resolvedOptions = ReplaceRule[
		safeOptions,
		Join[
			{
				LiquidHandlingScale->Which[
					MatchQ[LiquidHandlingScale/.safeOptions,LiquidHandlingScaleP],LiquidHandlingScale/.safeOptions,
					MatchQ[resolvedLiquidHandlingScale,LiquidHandlingScaleP],resolvedLiquidHandlingScale,
					True,MacroLiquidHandling
				],
				LiquidHandler->Which[
					MatchQ[liquidHandlerResource,$Failed],Lookup[safeOptions,LiquidHandler]/.{Automatic->Null},
					!NullQ[liquidHandlerResource],First[ToList[liquidHandlerResource[Instrument]]],
					True,Null
				],
				PreFlush->resolvedPreFlush,
				PreferredSampleImageOrientation->resolvedPreferredSampleImageOrientation,
				PlaceLids -> placeLidsQ,
				TareWeighContainers -> resolvedTareWeighContainers
			},
			resolvedPostProcessingOptions
		]
	];

	(* Validate the Name option *)
	nameOption=Lookup[safeOptions,Name];
	nameValidBool=Or[NullQ[nameOption],!DatabaseMemberQ[Object[Protocol,SampleManipulation,nameOption]]];

	nameTest=If[gatherTests,
		Test["Name is unique:",nameValidBool,True],
		Null];

	(* If Name is invalid, return early *)
	If[!nameValidBool,
		(Message[Error::DuplicateName,Lookup[safeOptions,Name]]; Message[Error::InvalidOption,Name]);
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests ->DeleteCases[Flatten[ToList[#]&/@{safeOptionTests,validLengthTests,invalidManipulationTest,transferTypeDefaultedTests,nonZeroAmountManipulationTests,discardedSamplesTest,deprecatedSamplesTest,fillToVolumeTest,resolvedLiquidHandlingScaleTests,overfilledDrainedTests,liquidHandlerTest,nameTest}],Null],
			Options -> resolvedOptions,
			Preview -> Null
		}]
	];

	(* pull out all samples we already know about from the manipulations *)
	samplesIn=DeleteDuplicates[Cases[manipulationsWithPipettingParameters,ObjectReferenceP[Object[Sample]],Infinity]];

	(* Create the following lid-related placement fields (only for MicroSM):
		- A list of lid placements in the form: {{lid resource, {nested lid stack position reference..}}..}
		- A list of lid spacer placements in the form: {{lid spacer resource, {nested lid spacer deck position reference..}}..} *)
	{lidPlacements, lidSpacerPlacements} = Which[
		!MatchQ[scaleToUseForFurtherResolving,MicroLiquidHandling],
			{{},{}},
		placeLidsQ,
			Module[
				{coverPrimitives,coverPrimitivesRequireMovements,sampleCoverTuples,sampleCoverTuplesRequireMovements,uniqueCoverTuples,uniqueCoverTuplesNoMovements,uniqueCoversRequired,coverLidResources,
				coverLidPlacementsPrelim,uniqueCoverObjects,uniqueCoverPlateObjects,uniqueCoverPlateResources,
				allUniqueCoverPlateObjects,uniqueCoverModelPlateObjects,uniqueCoverModelPlateResources,allUniqueCoverModelPlates,
				uniqueCoverPlateModels,uniqueCoverPlateModelsRequiringLidSpacers,coverLidSpacerResources,coverLidSpacerPlacementsPrelim,
				allCollectionContainers,requirementsToCover,defaultLidModel,
				defaultLidSpacerModel,allRequirements,requiredSampleObjects,requiredSampleResources,allSampleObjects,
				requiredPlateObjects,requiredPlateResources,allUniquePlateObjects,requiredModelPlateObjects,
				requiredModelPlateResources,allRequiredModelPlates,containerModels,plateModels,lidResources,
				plateModelsRequiringLidSpacers,lidSpacerResources,lidPlacementsPrelim, lidSpacerPlacementsPrelim},

				defaultLidModel = Model[Item,Lid,"Universal Black Lid"];
				defaultLidSpacerModel = Model[Item, LidSpacer, "Universal Plate Lid Spacer"];

				coverPrimitives = Cases[manipulationsWithPipettingParameters,_Cover];

				(* Find the Cover primitives that has an Incubate or ReadPlate before the next Uncover. This means we will need to move the plate while we have the lid on it. We then need an extra lid for the new position. *)
				coverPrimitivesRequireMovements = MapIndexed[
					If[MatchQ[#1,_Cover],
						Module[
							{nextUncoverPosition},
							(* Check the position of next Uncover *)
							nextUncoverPosition = FirstOrDefault[FirstPosition[manipulationsWithPipettingParameters[[(First[#2]+1);;]],_Uncover,0]+#2,Length[manipulationsWithPipettingParameters]];
							(* Check if we have Incubate/ReadPlate between this Cover the next Uncover *)
							If[MemberQ[manipulationsWithPipettingParameters[[First[#2];;nextUncoverPosition]],_Incubate|_ReadPlate],
								#1,
								Nothing
							]
						],
						Nothing
					]&,
					manipulationsWithPipettingParameters
				];
				
				(* Make list of tuples for each {sample specification,cover} pair *)
				sampleCoverTuples = Join@@Map[
					Transpose[{#[Sample],#[Cover],#[ResolvedSourceLocation]}]&,
					coverPrimitives
				];

				(* Make list of tuples for each {sample specification,cover} pair, if we need to create an extra lid placement resource for the moving cover *)
				sampleCoverTuplesRequireMovements = Join@@Map[
					Transpose[{#[Sample],#[Cover],#[ResolvedSourceLocation]}]&,
					coverPrimitivesRequireMovements
				];
				
				uniqueCoverTuples = DeleteDuplicatesBy[
					sampleCoverTuples,
					Function[tuple,
						Switch[tuple[[1]],
							ObjectP[Object[Sample]],
								tuple[[3]][[1]],
							{ObjectP[Object[Container]],_String},
								tuple[[1]][[1]],
							_,
								tuple[[1]]
						]
					]
				];

				(* Get the Cover that we don't need to move. Do not need extra resource for those *)
				uniqueCoverTuplesNoMovements = Complement[uniqueCoverTuples,sampleCoverTuplesRequireMovements];
				
				uniqueCoversRequired = uniqueCoverTuples[[All,2]];
				
				coverLidResources = Map[
					Resource[
						Name -> ToString[Unique[]],
						Sample -> #,
						Rent -> True
					]&,
					uniqueCoversRequired
				];
				
				coverLidPlacementsPrelim = Map[
					{Link[#],{}}&,
					coverLidResources
				];

				(* TODO We may want to allow LidSpacer key in Cover primitives in the future. *)
				(* For now, we should assume that even with Cover primitive, a plate that requires a lid spacer will also need a lid spacer for the new cover *)
				(* Get all objects that need to be covered, either _String or Object. Then dereference the name with the resource/object *)
				uniqueCoverObjects = Map[
					FirstCase[requiredObjects,{#,___},{Null,#}][[2]]&,
					uniqueCoverTuples[[All,1]]
				]/.{x:_Link:>First[x]};

				(* Extract all containers or resources pointing to containers *)
				uniqueCoverPlateObjects = Cases[uniqueCoverObjects,ObjectP[Object[Container,Plate]]];
				uniqueCoverPlateResources = Select[
					uniqueCoverObjects,
					And[
						MatchQ[#,_Resource],
						Or[
							MatchQ[#[Sample],ObjectP[Object[Container,Plate]]],
							MatchQ[#[Container],ObjectP[Object[Container,Plate]]]
						]
					]&
				];

				(* Join together direct container requests and underlying containers from resources *)
				allUniqueCoverPlateObjects = DeleteDuplicates@Join[
					uniqueCoverPlateObjects,
					Map[
						If[MatchQ[#[Sample],ObjectP[Object[Container,Plate]]],
							#[Sample],
							#[Container]
						]&,
						uniqueCoverPlateResources
					]
				];

				(* Extract all model plates and resources pointing to model plates *)
				uniqueCoverModelPlateObjects = Cases[uniqueCoverObjects,ObjectP[Model[Container,Plate]]];
				uniqueCoverModelPlateResources = Select[
					uniqueCoverObjects,
					And[
						MatchQ[#,_Resource],
						Or[
							MatchQ[#[Sample],ObjectP[Model[Container,Plate]]],
							MatchQ[#[Container],ListableP[ObjectP[Model[Container,Plate]]]]
						]
					]&
				];

				(* Join together all model requests and the above requested containers' models *)
				allUniqueCoverModelPlates = Join[
					uniqueCoverModelPlateObjects,
					Map[
						If[MatchQ[#[Sample],ObjectP[Model[Container,Plate]]],
							#[Sample],
							If[MatchQ[#[Container],{ObjectP[Model[Container,Plate]]..}],
								First[#[Container]],
								#[Container]
							]
						]&,
						uniqueCoverModelPlateResources
					],
					Map[
						Download[Lookup[fetchPacketFromCacheHPLC[#,allPackets],Model],Object]&,
						allUniqueCoverPlateObjects
					]
				];

				(* Extract those model that are plates (and therefore will use a lid) *)
				uniqueCoverPlateModels = Select[
					Download[Cases[allUniqueCoverModelPlates,ObjectP[Model[Container,Plate]]],Object],
					MatchQ[Lookup[fetchPacketFromCacheHPLC[#,allPackets],Footprint],Plate]&
				];

				(* From plate models list above, extract those plates that require use of a spacer *)
				uniqueCoverPlateModelsRequiringLidSpacers = PickList[
					uniqueCoverPlateModels,
					(* Note: This is one of the only places where we pull information from container model packets that may correspond
						to models that appear ONLY in Resource blobs. This occurs when a Define primitive is used to request a sample but
						no container is specified. In this specific case, the container model(s) will not appear in the SM primitives, so their
						packets may not have been downloaded up front	and may not be present in 'allPackets'. We use a packet lookup function below
						that is resilient to the packet's being absent and default the looked up value to Null in cases where either the field or
						the packet doesn't exist. This should be safe because we don't expect to use a lid-spacer-requiring plate as a default container. *)
					Lookup[fetchPacketFromCache[#,allPackets], LidSpacerRequired, Null]& /@ uniqueCoverPlateModels,
					True
				];

				(* Create resources for required lid spacers *)
				coverLidSpacerResources = Table[
					Resource[
						Name -> ToString[Unique[]],
						Sample -> defaultLidSpacerModel,
						Rent->True
					],
					Length[uniqueCoverPlateModelsRequiringLidSpacers]
				];

				(* Make placements field for lids to be put on the deck *)
				(* NOTE: the compiler populates the destination and re-uploads this field *)
				coverLidSpacerPlacementsPrelim = Map[
					{Link[#],{}}&,
					coverLidSpacerResources
				];
				
				allCollectionContainers = Map[
					(#[CollectionContainer])&,
					Cases[resolvedCentrifugePrimitives,_Filter]
				];
				
				requirementsToCover = Select[
					requiredObjects,
					(* We still get an extra lid for any covered movements so we only check for the ones that do not need move *)
					And[
						!MemberQ[uniqueCoverTuplesNoMovements[[All,1]],#[[1]]],
						!MemberQ[allCollectionContainers,#[[1]]]
					]&
				];

				(* Take First to strip the link off *)
				allRequirements = First/@(requirementsToCover[[All,2]]);

				(* We need to find all the unique plate models we'll be working with *)
				(* First, extract all samples or resources pointing to samples *)
				requiredSampleObjects = Cases[allRequirements,ObjectP[Object[Sample]]];
				requiredSampleResources = Select[
					allRequirements,
					And[
						MatchQ[#,_Resource],
						MatchQ[#[Sample],ObjectP[Object[Sample]]]
					]&
				];

				(* Fetch the underlying sample from the resource *)
				allSampleObjects = Join[
					requiredSampleObjects,
					(#[Sample]&)/@requiredSampleResources
				];

				(* Extract all containers or resources pointing to containers *)
				requiredPlateObjects = Cases[allRequirements,ObjectP[Object[Container,Plate]]];
				requiredPlateResources = Select[
					allRequirements,
					And[
						MatchQ[#,_Resource],
						Or[
							MatchQ[#[Sample],ObjectP[Object[Container,Plate]]],
							MatchQ[#[Container],ObjectP[Object[Container,Plate]]]
						]
					]&
				];

				(* Join together direct container requests, underlying containers from resources,
				and the above samples' containers *)
				allUniquePlateObjects = DeleteDuplicates@Join[
					requiredPlateObjects,
					Map[
						If[MatchQ[#[Sample],ObjectP[Object[Container,Plate]]],
							#[Sample],
							#[Container]
						]&,
						requiredPlateResources
					],
					Map[
						Download[Lookup[fetchPacketFromCacheHPLC[#,allPackets],Container],Object]&,
						allSampleObjects
					]
				];

				(* Extract all model plates and resources pointing to model plates *)
				requiredModelPlateObjects = Cases[allRequirements,ObjectP[Model[Container,Plate]]];
				requiredModelPlateResources = Select[
					allRequirements,
					And[
						MatchQ[#,_Resource],
						Or[
							MatchQ[#[Sample],ObjectP[Model[Container,Plate]]],
							MatchQ[#[Container],ListableP[ObjectP[Model[Container,Plate]]]]
						]
					]&
				];

				(* Join together all model requests and the above requested containers' models *)
				allRequiredModelPlates = Join[
					requiredModelPlateObjects,
					Map[
						If[MatchQ[#[Sample],ObjectP[Model[Container,Plate]]],
							#[Sample],
							If[MatchQ[#[Container],{ObjectP[Model[Container,Plate]]..}],
								First[#[Container]],
								#[Container]
							]
						]&,
						requiredModelPlateResources
					],
					Map[
						Download[Lookup[fetchPacketFromCacheHPLC[#,allPackets],Model],Object]&,
						allUniquePlateObjects
					]
				];

				(* Extract those model that are plates (and therefore will use a lid) *)
				plateModels = Select[
					Download[Cases[allRequiredModelPlates,ObjectP[Model[Container,Plate]]],Object],
					MatchQ[Lookup[fetchPacketFromCacheHPLC[#,allPackets],Footprint],Plate]&
				];

				(* Create resources for required lids *)
				lidResources = Table[
					Resource[
						Name -> ToString[Unique[]],
						Sample -> defaultLidModel,
						Rent -> True
					],
					Length[plateModels]
				];

				(* Make placements field for lids to be put on the deck *)
				(* NOTE: the compiler populates the destination and re-uploads this field *)
				lidPlacementsPrelim = Map[
					{Link[#],{}}&,
					lidResources
				];

				(* From plate models list above, extract those plates that require use of a spacer *)
				plateModelsRequiringLidSpacers = PickList[
					plateModels,
					(* Note: This is one of the only places where we pull information from container model packets that may correspond
						to models that appear ONLY in Resource blobs. This occurs when a Define primitive is used to request a sample but
						no container is specified. In this specific case, the container model(s) will not appear in the SM primitives, so their
						packets may not have been downloaded up front	and may not be present in 'allPackets'. We use a packet lookup function below
						that is resilient to the packet's being absent and default the looked up value to Null in cases where either the field or
						the packet doesn't exist. This should be safe because we don't expect to use a lid-spacer-requiring plate as a default container. *)
					Lookup[fetchPacketFromCache[#,allPackets], LidSpacerRequired, Null]& /@ plateModels,
					True
				];

				(* Create resources for required lid spacers *)
				lidSpacerResources = Table[
					Resource[
						Name -> ToString[Unique[]],
						Sample -> defaultLidSpacerModel,
						Rent->True
					],
					Length[plateModelsRequiringLidSpacers]
				];

				(* Make placements field for lids to be put on the deck *)
				(* NOTE: the compiler populates the destination and re-uploads this field *)
				lidSpacerPlacementsPrelim = Map[
					{Link[#],{}}&,
					lidSpacerResources
				];

				{
					Join[lidPlacementsPrelim,coverLidPlacementsPrelim],
					Join[lidSpacerPlacementsPrelim,coverLidSpacerPlacementsPrelim]
				}
			],
		(* ELSE generate special lid placements based on Cover primitives *)
		True,
			Module[
				{coverPrimitives,sampleCoverTuples,uniqueCoverTuples,uniqueCoversRequired,lidResources,lidPlacementsPrelim},
				
				coverPrimitives = Cases[manipulationsWithPipettingParameters,_Cover];
				
				(* Make list of tuples for each {sample specification,cover} pair *)
				sampleCoverTuples = Join@@Map[
					Transpose[{#[Sample],#[Cover],#[ResolvedSourceLocation]}]&,
					coverPrimitives
				];
				
				uniqueCoverTuples = DeleteDuplicatesBy[
					sampleCoverTuples,
					Function[tuple,
						Switch[tuple[[1]],
							ObjectP[Object[Sample]],
								tuple[[3]][[1]],
							{ObjectP[Object[Container]],_String},
								tuple[[1]][[1]],
							_,
								tuple[[1]]
						]
					]
				];
				
				uniqueCoversRequired = uniqueCoverTuples[[All,2]];
				
				lidResources = Map[
					Resource[
						Name -> ToString[Unique[]],
						Sample -> #,
						Rent -> True
					]&,
					uniqueCoversRequired
				];
				
				lidPlacementsPrelim = Map[
					{Link[#],{}}&,
					lidResources
				];
			
				{lidPlacementsPrelim,{}}
			]
	];

	(* If we need the plate reader, create a resource *)
	plateReaderResource = If[Length[readPlatePrimitives] > 0 && !MatchQ[resolvedPlateReaderInstrument,Null],
		Resource[
			Name->ToString[Unique[]],
			Instrument->resolvedPlateReaderInstrument,
			Time -> liquidHandlingEstimate
		],
		Null
	];

	(* Before uploading the protocol, make sure that the storage condition given is valid. *)
	(* We resolve the storage condition to a symbol in order to upload it in the protocol object. *)
	samplesInStorageCondition = SamplesInStorageCondition/.safeOptions;

	(* generate the protocol packet; if Aliquot called us, make the sub-typed Object and Type *)
	protocolType=Which[
		Aliquot /. safeOptions, Object[Protocol, SampleManipulation, Aliquot],
		Resuspend /. safeOptions, Object[Protocol, SampleManipulation, Resuspend],
		Dilute /. safeOptions, Object[Protocol, SampleManipulation, Dilute],
		True, Object[Protocol, SampleManipulation]
	];

	protocolID=CreateID[protocolType];
	protocolPacket = Join[
		Association[
			Object->protocolID,
			Type->protocolType,
			Name->nameOption,
			ParentProtocol->If[MatchQ[parentProtocol,ObjectP[ProtocolTypes[]]],
				Link[parentProtocol,Subprotocols]
			],
			Author->If[MatchQ[parentProtocol,Null],
				Link[$PersonID,ProtocolsAuthored]
			],
			Replace[SamplesIn]->Link[samplesIn,Protocols],
			Replace[Manipulations]->myRawManipulations,
			Replace[ResolvedManipulations]->splitMixPrimitives,
			LiquidHandlingScale->(scaleToUseForFurtherResolving/.{Bufferbot->MacroLiquidHandling}),
			LiquidHandler->Link[liquidHandlerResource],
			PlateReader -> Link[plateReaderResource],
			(* If we're using HPLC vials, we'll need to add the HPLC vial rack; doing it here so we can make a rent resource *)
			Replace[RackPlacements]->If[hplcVialHamiltonRackRequiredQ,
				{{Link[Resource[Sample->Model[Container,Rack,"id:Z1lqpMGjeejo"],Rent->True]],{"Deck Slot","HPLC Carrier Slot"}}},
				{}
			],
			Replace[VesselRackPlacements] -> allVesselPlacements,
			Replace[PlateAdapterPlacements] -> plateAdapterPlacements,
			Replace[LidPlacements] -> lidPlacements,
			Replace[LidSpacerPlacements] -> lidSpacerPlacements,
			(* since we only have one hardcoding it for now, will elimanate an annoying instrument select/release step s*)
			Replace[WaterPurifiers]->{Link[Object[Instrument, WaterPurifier, "id:O81aEB4kJw9D"]]},
			PreFlush->If[resolvedPreFlush,
				True
			],
			Replace[ContainersIn]->Link[Lookup[uniqueContainerPackets,Object,{}],Protocols],
			Replace[RequiredObjects]->requiredObjects,
			Replace[TaredContainers]->tareContainers,
			Replace[OrdersFulfilled]->Link[DeleteCases[ToList[Lookup[safeOptions,OrderFulfilled]],Null],Fulfillment],
			(* ASSUME: PreparedResources is UNIQUE, i.e. there is ONE MANIPULATION PER PREPARED RESOURCE *)
			Replace[PreparedResources]->Link[preparedResourcePackets,Preparation],
			MeasureWeight->(MeasureWeight/.resolvedPostProcessingOptions),
			MeasureVolume->(MeasureVolume/.resolvedPostProcessingOptions),
			ImageSample->(ImageSample/.resolvedPostProcessingOptions),
			PreferredSampleImageOrientation->resolvedPreferredSampleImageOrientation,
			UnresolvedOptions->ToList[myOptions],
			ResolvedOptions->resolvedOptions,
			Replace[SamplesInStorage] -> If[!NullQ[samplesInStorageCondition],
				Table[samplesInStorageCondition,Length[samplesIn]],
				{}
			],
			Replace[Checkpoints]->{
				{"Picking Resources",Length[tareContainers]*3 Minute+15 Minute,"Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> Length[tareContainers]*3 Minute+15 Minute]]},
				{"Liquid Handling",liquidHandlingEstimate,"The sample manipulations specified in this protocol are executed.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> liquidHandlingEstimate]]},
				{"Parsing Data",1 Minute,"The database is updated to reflect changes to the manipulated samples.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 1 Minute]]},
				{"Sample Post-Processing",1 Minute,"Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 1 Minute]]},
				{"Returning Materials",If[MatchQ[parentProtocol,ObjectP[ProtocolTypes[]]],1 Minute,Max[Length[Lookup[uniqueContainerPackets,Object,{}]],1]*5 Minute+5 Minute],"Samples are returned to storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> If[MatchQ[parentProtocol,ObjectP[ProtocolTypes[]]],1 Minute,Max[Length[Lookup[uniqueContainerPackets,Object,{}]],1]*5 Minute+5 Minute]]]}
			},
			(* TODO: this is dumb because RunTime is an Expression *)
			RunTime->Round[Convert[liquidHandlingEstimate,Minute],1],
			If[MatchQ[scaleToUseForFurtherResolving,MicroLiquidHandling],
				Replace[PipetteTips] -> Link/@allTipResources,
				Nothing
			]
		],
		plateReaderFields
	];

	(* collect all hard error messages bools (warnings can be ignored) so we can return $Failed below; some of the messages are lists, so we need to flatten *)
	hardMessagesoccurred=Or@@Flatten[{
		invalidManipulationMessage,
		inWellSeparationKeyMessage,
		deprecatedPacketsExistQ,
		discardedPacketsExistQ,
		fillToVolumeProblemMessage,
		invalidfillToVolumeDestinationQ,
		conflictingIncubateMessage,
		missingKeysMessage,
		conflictingIncubateWithScaleMessage,
		fillToVolumeAndMicroMessage,
		fillToVolumeMethodMessage,
		!TrueQ[And@@centrifugeOkBooleans],
		!TrueQ[And@@pelletOkBooleans],
		!TrueQ[validReadPlatesQ],
		!TrueQ[validReadPlatePlateModelsQ],
		!TrueQ[validInjectionCountQ],
		!TrueQ[validMicroIncubationsQ],
		!TrueQ[validMacroIncubationsQ],
		!TrueQ[validMicroFiltersQ],
		!TrueQ[validMacroFilterQ],
		!TrueQ[validDefinesQ],
		cannotResolveScaleMessagesBool,
		TrueQ[overfilledCheckTripped],
		!TrueQ[validLiquidHandlerQ],
		!TrueQ[validMagnetContainerQ],
		!TrueQ[validFilterMagnetQ],
		TrueQ[tareContainerTareWeightErrorQ],
		MatchQ[requiredObjects,$Failed],
		MatchQ[liquidHandlerResource,$Failed],
		invalidPipettingParameterQ,
		!validMixKeysQ,
		!TrueQ[validTipCountQ],
		missingKeysFilterMessage,
		conflictingFilterWithScaleMessage,
		conflictingFilterMessage,
		unsafeTransfersExist,
		Length[stateMismatchManipulations]!=0,
		!TrueQ[And@@pelletOkBooleans],
		!TrueQ[And@@validMultiProbeHeadTransferQ]
	}];

	(* --- Now that we have done all error testing and have created the packets, construct the rules for the Output option (Options, Preview, Tests, Result) --- *)

	(*Prepare the Options result if we were asked to do so*)
	optionsRule=Options->If[MemberQ[output,Options],
		RemoveHiddenOptions[ExperimentSampleManipulation,CollapseIndexMatchedOptions[ExperimentSampleManipulation,resolvedOptions,Ignore->listedOptions,Messages->False]],
		Null
	];

	(* Prepare the Preview result if we were asked to do so *)
	previewRule=Preview->If[MemberQ[output,Preview],
		Module[{object,handler,manipulations,scale,steps},
		(* extract useful information from the protocol packet *)
			{object,handler,manipulations,scale} = Lookup[protocolPacket,#]& /@ {Object,LiquidHandler,Replace[Manipulations],LiquidHandlingScale};
			steps = Table[StringJoin["Step " , ToString[#], " "]] & /@ Range[Length[manipulations]];
			(* Construct a Table with the information *)
			PlotTable[Transpose[{steps, Flatten[ToList /@ manipulations]}],
				(* need secondary so that we can make one title line that doesn't split up into columns *)
				SecondaryTableHeadings -> {None, {StringJoin[ToString[scale]," Protocol"]}},
				(* turn off tooltips so that we can hover over the primitives and expand them by clicking on the plus *)
				Tooltips -> False
			]
		],
		Null
	];

	allMainFunctionTests = Flatten[{
		{invalidManipulationTest},
		{validAmountsInputTest},
		validTransferInputLengthTest,
		primitivesWithInWellSeparationKeyTests,
		transferTypeDefaultedTests,
		{discardedSamplesTest},
		{deprecatedSamplesTest},
		{fillToVolumeTest,fillToVolumeDestinationCalibrationTest},
		fillToVolumeConflictsWithScaleTests,
		fillToVolumeMethodTests,
		defineTests,
		filterTests,
		centrifugeTests,
		pelletTests,
		{pelletScaleTest},
		{invalidCentrifugePrimitivesTest},
		incubationTests,
		{mixKeysTest},
		pipettingParameterTests,
		readPlateTests,
		{validTipCountTest},
		{tareContainerTareWeightTest},
		resolvedLiquidHandlingScaleTests,
		overfilledDrainedTests,
		{liquidHandlerTest},
		{magnetContainerTest},
		{filterMagnetTest},
		{ventilatedTest},
		ToList[nameTest],
		{stateMismatchTest},
		validMultiProbeHeadTransferTest
	}];

	(* Prepare the Test result if we were asked to do so *)
	testsRule=Tests->If[MemberQ[output,Tests],
	(* Join all exisiting tests generated by the top level function and helper functions *)
		DeleteCases[Join[safeOptionTests,validLengthTests(* , templateTests,resolvedOptionsTests, *), allMainFunctionTests],Null],
		Null
	];

	(* sneak in early return of the packet now pre-RequireResources if Aliquot->True or Resuspend -> True*)
	If[(Aliquot /. safeOptions) || (Resuspend /. safeOptions) || (Dilute /. safeOptions),
		If[hardMessagesoccurred,
			Return[outputSpecification /. {previewRule, optionsRule, testsRule, Result -> $Failed}],
			Return[outputSpecification /. {previewRule, optionsRule, testsRule, Result -> protocolPacket}]
		]
	];

	If[Lookup[safeOptions,Simulation],
		Return[protocolPacket]
	];

	(* prepare the standard result if we were asked for it and we can safely do so *)
	resultRule=Result->If[MemberQ[output,Result],
	(* if the resolved Options returned $Failed, and/or hard errors were encountered in the core function, we cannot gather the results and return $Failed *)
		If[hardMessagesoccurred,
			$Failed,
			(* If we can safely do so, upload the resulting protocol/resource objects; must upload protocol and resource before Status change for UPS' ShippingMaterials shite *)
			Module[{rootProtocol,queueOrderChangePackets,packetAndResourcePackets,updatedBy},

				(* Find resource's root protocol *)
				rootProtocol = If[MatchQ[Lookup[safeOptions,RootProtocol],Automatic],
					If[MatchQ[parentProtocol,ObjectP[]],
						LastOrDefault[Download[Download[parentProtocol,ParentProtocol..],Object],parentProtocol],
						protocolID
					],
					Lookup[safeOptions,RootProtocol]
				];

				(* pass the protocol packet to RequireResources to generate upload packets for the required resources *)
				packetAndResourcePackets=RequireResources[protocolPacket,RootProtocol->rootProtocol,Upload->False];

				queueOrderChangePackets = If[MatchQ[parentProtocol,ObjectP[]],
					{},
					(* Note: We only do this because we don't call UploadProtocol. Normally you SHOULD NOT call this by itself. *)
					(* If you do, definitely do not pass down QueuePosition. *)
					ToList@UploadProtocolPriority[
						(* Make sure that we pass down the Notebook field if it isn't included. *)
						If[!KeyExistsQ[protocolPacket, Notebook],
							Append[
								protocolPacket,
								Notebook->Link[$Notebook]
							],
							protocolPacket
						],

						HoldOrder -> Lookup[safeOptions,HoldOrder],
						Priority -> Lookup[safeOptions,Priority],
						StartDate -> Lookup[safeOptions,StartDate],

						Upload->False
					]
				];

				(* figure out who should be responsible for the protocol status update *)
				updatedBy=If[MatchQ[parentProtocol,Null],
					$PersonID,
					parentProtocol
				];

				If[Lookup[safeOptions,Upload],
				(* In the case where Upload -> True, upload the protocol and resource packets, call UPS on the protocol *)
					Module[{uploadedObjects,upsReturn},

						(* upload all of the packets; return a hard failure if we did not receive object references back *)
						uploadedObjects=Upload[Join[packetAndResourcePackets,queueOrderChangePackets],ConstellationMessage->Object[Protocol,SampleManipulation]];
						If[!MatchQ[uploadedObjects,{ObjectReferenceP[]..}],
							Return[$Failed]
						];

						(* call UploadProtocolStatus on the protocol ID (now in DB) with appropriate status depending on Confirm option *)
						upsReturn=If[TrueQ[Lookup[safeOptions,Confirm]],
							UploadProtocolStatus[protocolID,OperatorStart,UpdatedBy->updatedBy,FastTrack->True,Email->resolvedEmail],
							UploadProtocolStatus[protocolID,InCart,UpdatedBy->updatedBy,FastTrack->True,Email->resolvedEmail]
						];

						(* propagate a UPS failure; otherwise, return just the protocol iD *)
						If[MatchQ[upsReturn,$Failed],
							$Failed,
							protocolID
						]
					],
					(* In the case where Upload -> False (and we have enforced that Confirm MUST be False as well in this case), return the packets *)
					Module[{protocolStatusChangePackets},

						(* get change packets related to changing the protocl to InCart *)
						protocolStatusChangePackets=UploadProtocolStatus[protocolPacket,InCart,UpdatedBy->updatedBy,Upload->False,FastTrack->True,Email->resolvedEmail];

						(* propagate a UPS failure; otherwise, return ALL of the packets *)
						If[MatchQ[protocolStatusChangePackets,$Failed],
							$Failed,
							Join[packetAndResourcePackets,queueOrderChangePackets,protocolStatusChangePackets]
						]
					]
				]
			]
		],
		(* In the case were no Result is requested as Output, return Null *)
		Null
	];

	outputSpecification /. {previewRule, optionsRule, testsRule, resultRule}
];


(* ::Subsubsection::Closed:: *)
(*findObjectsOfTypeInPrimitive*)


(* We need to separate all of the different types of objects that appear in the manipulations so we can download from them
	to help with this, define an internal function that will chew through the manips looking for a given type *)
findObjectsOfTypeInPrimitive[myManipulations_List,myTypeToFind:TypeP[]]:=Module[
	{allSources,allDestinations,allNamedObjects,allObjectsInManipulations},

	(* get the source(s) and destination(s) of all manipulations;
		all manips have Source/Sources, but Mix doesn't have Destination *)
	allSources = Map[
		Switch[#,
			_Incubate|_Filter|_MoveToMagnet|_RemoveFromMagnet|_Mix|_Centrifuge|_Pellet|_ReadPlate,
			#[{Sample,SourceSample}],
			_,
			#[Source]
		]&,
		myManipulations
	];

	allDestinations = Map[
		Switch[#,
			_Transfer|_FillToVolume,
				#[Destination],
			_Filter, (* in macro filter, the Filter may become the collection container, so we include this in the objects *)
				#[{CollectionContainer,Filter}],
			_Pellet,
				#[{SupernatantDestination,ResuspensionSource}],
			_ReadPlate,
				#[{Blank,PrimaryInjectionSample,SecondaryInjectionSample,TertiaryInjectionSample,QuaternaryInjectionSample}],
			_,
				{}
		]&,
		myManipulations
	];

	(* Fetch any objects within Define primitives *)
	allNamedObjects = Map[
		If[MatchQ[#,_Define],
			Flatten[{#[Sample],#[Container],#[Model]}],
			Nothing
		]&,
		myManipulations
	];

	(* combine into a full list; there may be some tags floating around, so delete _String *)
	allObjectsInManipulations = DeleteDuplicates[
		DeleteCases[
			Join[
				Flatten[allSources],
				Flatten[allDestinations],
				Flatten[allNamedObjects]
			],
			_String
		]
	];

	(* return the instances at the first level of the type of interest *)
	Cases[allObjectsInManipulations,ObjectP[myTypeToFind]]
];


(* ::Subsubsection::Closed:: *)
(*resolveDefinePrimitive*)


Options[resolveDefinePrimitive]:={Cache->{}};

resolveDefinePrimitive[myDefinePrimitive_Define,ops:OptionsPattern[]]:=Module[
	{defineAssociation,resolvedContainer,resolvedSample},

	(* Strip out underlying association *)
	defineAssociation = First[myDefinePrimitive];

	(*
		Container is model
	 	Container is object
		Container is name
		Sample is {Object,well}
		Sample is {Model,well}
		Sample is {container name, well}

		*)
	(* If ContainerName is specified and Container is not populated, we must populate it *)
	resolvedContainer = Which[
		MatchQ[Lookup[defineAssociation,Container],ObjectP[]],
			Lookup[defineAssociation,Container],
		MatchQ[Lookup[defineAssociation,Sample],ObjectP[]],
			Download[Lookup[fetchPacketFromCacheHPLC[Lookup[defineAssociation,Sample],OptionValue[Cache]],Container],Object],
		MatchQ[Lookup[defineAssociation,Sample],{ObjectP[]|_String,_String}],
			If[MatchQ[Lookup[defineAssociation,Sample][[1]],ObjectP[Model]],
				{Unique[],Lookup[defineAssociation,Sample][[1]]},
				Lookup[defineAssociation,Sample][[1]]
			],
		True,
			Lookup[defineAssociation,Container]
	];

	resolvedSample = If[MatchQ[Lookup[defineAssociation,Sample],{ObjectP[Model],_String}],
		{resolvedContainer,Lookup[defineAssociation,Sample][[2]]},
		Lookup[defineAssociation,Sample]
	];

	Define[
		Append[defineAssociation,
			{
				If[!MatchQ[Lookup[defineAssociation,Container],resolvedContainer],
					Container -> resolvedContainer,
					Nothing
				],
				If[!MatchQ[Lookup[defineAssociation,Sample],resolvedSample],
					Sample -> resolvedSample,
					Nothing
				]
			}
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*fetchDefineModelOrSample*)


Options[fetchDefineModelOrSample]:={Cache->{}};

fetchDefineModelOrSample[myDefinePrimitive:Null,ops:OptionsPattern[]]:=Null;
fetchDefineModelOrSample[myDefinePrimitive_Define,ops:OptionsPattern[]]:=Module[
	{sampleKey,containerKey,wellKey,container},

	sampleKey=myDefinePrimitive[Sample];
	containerKey=myDefinePrimitive[Container];
	wellKey=myDefinePrimitive[Well];

	(* Extract the container if it happens to be tagged *)
	container=If[MatchQ[containerKey,{_Symbol|_String|_Integer,ObjectP[]}],
		Last[containerKey],
		containerKey
	];

	(* If container is populated, use it. If Sample is a container, well tuple, extract the container. *)
	Which[
		(* Given a sample or model directly *)
		MatchQ[sampleKey,ObjectP[]],sampleKey,

		(* Given a tagged sample or model directly *)
		MatchQ[sampleKey,{_Symbol|_String|_Integer,ObjectP[]}],sampleKey,

		(* Given a position in a plate *)
		MatchQ[sampleKey,{ObjectP[],WellPositionP}],Module[{contents},
			contents=Lookup[fetchPacketFromCacheHPLC[sampleKey[[1]],OptionValue[Cache]],Contents];
			Last[FirstCase[contents,{sampleKey[[2]],ObjectP[]},{Null,Null}]]
		],

		(* Given a tagged position in a plate *)
		MatchQ[sampleKey,{{_Symbol|_String|_Integer,ObjectP[Object[Container]]},WellPositionP}],Module[{contents},
			contents=Lookup[fetchPacketFromCacheHPLC[sampleKey[[1,2]],OptionValue[Cache]],Contents];
			Last[FirstCase[contents,{sampleKey[[2]],ObjectP[]},{Null,Null}]]
		],

		(* Container/Well key point to a position in a plate *)
		MatchQ[{containerKey,wellKey},{ObjectP[],WellPositionP}],Module[{contents},
			contents=Lookup[fetchPacketFromCacheHPLC[containerKey,OptionValue[Cache]],Contents];
			Last[FirstCase[contents,{wellKey,ObjectP[]},{Null,Null}]]
		],
		(* Given a single position vessel - take the first sample *)
		MatchQ[containerKey,ObjectP[Object]],Module[{contents},
			contents=Lookup[fetchPacketFromCacheHPLC[containerKey,OptionValue[Cache]],Contents];
			First[contents,{Null,Null}][[2]]
		],
		True,Null
	]
];


(* ::Subsubsection::Closed:: *)
(*fetchDefineModelContainer*)


Options[fetchDefineModelContainer]:={Cache->{}, DefineLookup->{}};

fetchDefineModelContainer[myDefinePrimitive:Null,ops:OptionsPattern[]]:=Null;
fetchDefineModelContainer[myDefinePrimitive_Define,ops:OptionsPattern[]]:=Module[
	{convertedContainer},

	(* If container is populated, use it. If Sample is a container, well tuple, extract the container. *)
	convertedContainer = Which[
		(* Direct container *)
		MatchQ[myDefinePrimitive[Container],ObjectP[]],
			myDefinePrimitive[Container],
		(* Tagged container *)
		MatchQ[myDefinePrimitive[Container],{_Symbol|_String|_Integer,ObjectP[]}],
			Last[myDefinePrimitive[Container]],
		(* container and well  *)
		MatchQ[myDefinePrimitive[Sample],{ObjectP[],WellPositionP}],
			First[myDefinePrimitive[Sample]],
		(* tagged container and well *)
		MatchQ[myDefinePrimitive[Sample],{{_Symbol|_String|_Integer,ObjectP[]},WellPositionP}],
			myDefinePrimitive[Sample][[1,2]],
		(* sample *)
		MatchQ[myDefinePrimitive[Sample],ObjectP[Object[Sample]]],
			Lookup[fetchPacketFromCacheHPLC[myDefinePrimitive[Sample],OptionValue[Cache]],Container],
		(* tagged sample *)
		MatchQ[myDefinePrimitive[Sample],{_Symbol|_String|_Integer,ObjectP[Object[Sample]]}],
			Lookup[fetchPacketFromCacheHPLC[myDefinePrimitive[Sample][[2]],OptionValue[Cache]],Container],
		(* named container *)
		MatchQ[myDefinePrimitive[Container],_Symbol|_String|_Integer] && MatchQ[Lookup[OptionValue[DefineLookup], myDefinePrimitive[Container]], _Define],
			fetchDefineModelContainer[Lookup[OptionValue[DefineLookup], myDefinePrimitive[Container]], ops],
		(* if we're just given a model sample we can't know the container *)
		True,
			Null
	];

	If[NullQ[convertedContainer],
		Return[Null]
	];

	(* If container is not a model, fetch the model object *)
	If[MatchQ[convertedContainer,ObjectP[Object[Container]]],
		Download[Lookup[fetchPacketFromCacheHPLC[convertedContainer,OptionValue[Cache]],Model],Object],
		convertedContainer
	]
];


(* ::Subsubsection::Closed:: *)
(*extractSourceSampleOrModels*)


Options[extractSourceSampleOrModels]={Cache->{},DefineLookup->Association[]};
extractSourceSampleOrModels[myManipulation_Transfer,ops:OptionsPattern[]]:=Module[
	{cache,manipulationAssociation,sources,sourceLocations},

	(* Extract the cache ball *)
	cache = OptionValue[Cache];

	(* Strip off primitive head so we can work with an association *)
	manipulationAssociation = First[myManipulation];

	sources = Lookup[manipulationAssociation,Source];

	(* Fetch source container models from specified destination.
	Note: The source container may be tagged at this point. *)
	Map[
		Function[source,
			Which[
				(* Reference to model or sample *)
				MatchQ[source,ObjectP[{Model[Sample],Object[Sample]}]],
					source,
				(* Reference to tagged model or sample *)
				MatchQ[source,{_Symbol|_String|_Integer,ObjectP[{Model[Sample],Object[Sample]}]}],
					Last[source],

				(* Model container *)
				MatchQ[source,ObjectP[Model[Container]]],
					Null,
				(* Tagged container model *)
				MatchQ[source,{_Symbol|_String|_Integer,ObjectP[Model[Container]]}],
					Null,
				(* Model container and well *)
				MatchQ[source,{ObjectP[Model[Container]],WellPositionP}],
					Null,
				(* Tagged container model with well *)
				MatchQ[source,{{_Symbol|_String|_Integer,ObjectP[Model[Container]]},WellPositionP}],
					Null,

				(* Container *)
				(* If source location is a single container it must be a vessel - so just take the first sample inside *)
				MatchQ[source,ObjectP[Object[Container]]],
					Module[{container,sample},
						container=fetchPacketFromCacheHPLC[source,cache];
						sample=First[Lookup[container,Contents],{Null,Null}][[2]];
						If[MatchQ[sample,ObjectP[]],
							sample,
							Null
						]
					],
				(* Plate and well *)
				MatchQ[source,PlateAndWellP],
					Module[{contents,sample},
						contents=Lookup[fetchPacketFromCacheHPLC[source[[1]],cache],Contents];
						sample=FirstCase[contents,{source[[2]],ObjectP[]},{Null,Null}][[2]];
						If[MatchQ[sample,ObjectP[]],
							sample,
							Null
						]
					],
				(* Tagged container *)
				MatchQ[source,{_Symbol|_String|_Integer,ObjectP[Object[Container]]}],
					Module[{container,sample},
						container=fetchPacketFromCacheHPLC[Last[source],cache];
						sample=First[Lookup[container,Contents],{Null,Null}][[2]];
						If[MatchQ[sample,ObjectP[]],
							sample,
							Null
						]
					],
				(* Tagged container and well *)
				MatchQ[source,{{_Symbol|_String|_Integer,ObjectP[Object[Container]]},WellPositionP}],
					Module[{container,contents,sample},
						container=source[[1,2]];
						contents=Lookup[fetchPacketFromCacheHPLC[container,cache],Contents];
						sample=FirstCase[contents,{source[[2]],ObjectP[]},{Null,Null}][[2]];
						If[MatchQ[sample,ObjectP[]],
							sample,
							Null
						]
					],

				(* Reference to Define primitive - find the associated define primitive and extract model from it *)
				MatchQ[source,_String],
					fetchDefineModelOrSample[Lookup[OptionValue[DefineLookup],source,Null],Cache->cache],
				(* Reference Define primitive with well *)
				(* Lookup the corresponding Define primitive and add well *)
				MatchQ[source,{_String,WellPositionP}],
					fetchDefineModelOrSample[Append[Lookup[OptionValue[DefineLookup],First[source],Null],Well->Last[source]],Cache->cache]
			]
		],
		sources,
		{2}
	]
];



(* ::Subsubsection::Closed:: *)
(*fetchSourceModelContainersNew*)


Options[fetchSourceModelContainers]={Cache->{},DefineLookup->Association[],RequiredObjectsLookup->Association[]};
fetchSourceModelContainers[myManipulation_,ops:OptionsPattern[]]:=Module[
	{cache,manipulationAssociation,sources,sourceLocations},

	(* Extract the cache ball *)
	cache = OptionValue[Cache];

	(* Strip off primitive head so we can work with an association *)
	manipulationAssociation = First[myManipulation];

	(* Depending on the primitive type, extract lists of sources and resolved source locations
	For primitives that have singleton values for any of these fields, wrap them in a list. *)
	{sources,sourceLocations} = Switch[
		myManipulation,
		_Transfer,
			{
				Lookup[manipulationAssociation,Source],
				Lookup[
					manipulationAssociation,
					ResolvedSourceLocation,
					Table[Null,Length[#]]&/@Lookup[manipulationAssociation,Source]
				]
			},
		_Mix|_ReadPlate,
			{
				{#}&/@Lookup[manipulationAssociation,Sample],
				{#}&/@Lookup[manipulationAssociation,ResolvedSourceLocation]
			},
		_MoveToMagnet|_RemoveFromMagnet,
			{
				{{Lookup[manipulationAssociation,Sample]}},
				{{Lookup[manipulationAssociation,ResolvedSourceLocation]}}
			},
		_,
			{{{}},{{}}}
	];

	(* Fetch source container models from specified destination.
	Note: The source container may be tagged at this point. *)
	MapThread[
		Function[{source,sourceLocation},
			Which[
				(* If source location is a container or container and well, fetch its model from the cache *)
				MatchQ[sourceLocation,ObjectP[Object[Container]]],
					Download[Lookup[fetchPacketFromCacheHPLC[sourceLocation,cache],Model],Object],
				MatchQ[sourceLocation,PlateAndWellP],
					Download[Lookup[fetchPacketFromCacheHPLC[sourceLocation[[1]],cache],Model],Object],
				MatchQ[source,ObjectP[Object[Container]]],
					Download[Lookup[fetchPacketFromCacheHPLC[source,cache],Model],Object],
				MatchQ[source,PlateAndWellP],
					Download[Lookup[fetchPacketFromCacheHPLC[source[[1]],cache],Model],Object],
				(* Tagged Model container *)
				MatchQ[source,{_Symbol|_String|_Integer,ObjectP[Model[Container]]}],
					source[[2]],
				(* Model tag with well *)
				MatchQ[source,{{_Symbol|_String|_Integer,ObjectP[Model[Container]]},_String}],
					source[[1,2]],
				(* Straight Model container *)
				MatchQ[source,ObjectP[Model[Container]]],
					source,
				(* Defined Model container or {defined model container, well} *)
				MatchQ[source,_String|{_String,WellPositionP}],
					Module[{sourceContainerReference,definedModelContainer,resource,resourceContainerModel},

						sourceContainerReference = If[MatchQ[source,{_String,_}],
							First[source],
							source
						];

						definedModelContainer = fetchDefineModelContainer[
							Lookup[OptionValue[DefineLookup],sourceContainerReference,Null],
							Cache->cache
						];

						If[!NullQ[definedModelContainer],
							Return[definedModelContainer,Module]
						];

						resource = Lookup[OptionValue[RequiredObjectsLookup],Key[sourceContainerReference],Null];

						If[NullQ[resource],
							Return[Null,Module]
						];

						(* Strip link off using First *)
						resourceContainerModel = fetchResourceContainerModel[First@resource,Cache->cache];

						If[NullQ[resourceContainerModel],
							Null,
							resourceContainerModel
						]
					],
				MatchQ[source,ObjectP[Object[Sample]]],
					Download[
						Lookup[
							fetchPacketFromCacheHPLC[
								Download[Lookup[fetchPacketFromCacheHPLC[source,cache],Container],Object],
								cache
							],
							Model
						],
						Object
					],
				(* Tagged model *)
				MatchQ[source,{_Symbol|_String|_Integer,ObjectP[Model[Sample]]}],
					Module[{resource,resourceContainerModel},

						resource = Lookup[OptionValue[RequiredObjectsLookup],Key[source],Null];

						If[NullQ[resource],
							Return[Null,Module]
						];

						(* Strip link off using First *)
						resourceContainerModel = fetchResourceContainerModel[First@resource,Cache->cache];

						If[NullQ[resourceContainerModel],
							Null,
							resourceContainerModel
						]
					],
				(* {container, well} tuple with defined container *)
				MatchQ[source,{_String,WellPositionP}],
					Module[{resource,resourceContainerModel},

						resource = Lookup[OptionValue[RequiredObjectsLookup],Key[source],Null];

						If[NullQ[resource],
							Return[Null,Module]
						];

						(* Strip link off using First *)
						resourceContainerModel = fetchResourceContainerModel[First@resource,Cache->cache];

						If[NullQ[resourceContainerModel],
							Null,
							resourceContainerModel
						]
					],
				True,
					Null
			]
		],
		{sources,sourceLocations},
		2
	]
];



(* ::Subsubsection::Closed:: *)
(*fetchDestinationModelContainersNew*)


Options[fetchDestinationModelContainers]:={Cache->{},DefineLookup->Association[],RequiredObjectsLookup->Association[]};
fetchDestinationModelContainers[myManipulation_,ops:OptionsPattern[]]:=Module[
	{cache,manipulationAssociation,destinations,destinationLocations},

	(* Extract the cache ball *)
	cache = OptionValue[Cache];

	(* Strip off primitive head so we can work with an association *)
	manipulationAssociation = First[myManipulation];

	(* Depending on the primitive type, extract lists of sources and resolved source locations
	For primitives that have singleton values for any of these fields, wrap them in a list. *)
	{destinations,destinationLocations} = Switch[
		myManipulation,
		_Transfer,
			{
				Lookup[manipulationAssociation,Destination],
				Lookup[
					manipulationAssociation,
					ResolvedDestinationLocation,
					Table[Null,Length[#]]&/@Lookup[manipulationAssociation,Destination]
				]
			},
		_,
			{{{}},{{}}}
	];

	(* Fetch destination container models from specified destination.
	Note: The destination container may be tagged at this point. *)
	MapThread[
		Function[{destination,destinationLocation},
			Which[
				(* If destination location is a container or container and well, fetch its model from the cache *)
				MatchQ[destinationLocation,ObjectP[Object[Container]]],
					Download[Lookup[fetchPacketFromCacheHPLC[destinationLocation,cache],Model],Object],
				MatchQ[destinationLocation,PlateAndWellP],
					Download[Lookup[fetchPacketFromCacheHPLC[destinationLocation[[1]],cache],Model],Object],
				MatchQ[destination,ObjectP[Object[Container]]],
					Download[Lookup[fetchPacketFromCacheHPLC[destination,cache],Model],Object],
				MatchQ[destination,PlateAndWellP],
					Download[Lookup[fetchPacketFromCacheHPLC[destination[[1]],cache],Model],Object],
				(* Tagged Model container *)
				MatchQ[destination,{_Symbol|_String|_Integer,ObjectP[Model[Container]]}],
					destination[[2]],
				(* Model tag with well *)
				MatchQ[destination,{{_Symbol|_String|_Integer,ObjectP[Model[Container]]},_String}],
					destination[[1,2]],
				(* Straight Model container *)
				MatchQ[destination,ObjectP[Model[Container]]],
					destination,
				(* Defined Model container or {defined model container, well} *)
				MatchQ[destination,_String|{_String,WellPositionP}],
					Module[{destinationContainerReference,definedModelContainer,resource,resourceContainerModel},

						destinationContainerReference = If[MatchQ[destination,{_String,_}],
							First[destination],
							destination
						];

						definedModelContainer = fetchDefineModelContainer[
							Lookup[OptionValue[DefineLookup],Key[destinationContainerReference],Null],
							Cache->cache
						];

						If[!NullQ[definedModelContainer],
							Return[definedModelContainer,Module]
						];

						resource = Lookup[OptionValue[RequiredObjectsLookup],Key[destinationContainerReference],Null];

						If[NullQ[resource],
							Return[Null,Module]
						];

						(* Strip link off using First *)
						resourceContainerModel = fetchResourceContainerModel[First@resource,Cache->cache];

						If[NullQ[resourceContainerModel],
							Null,
							resourceContainerModel
						]
					],
				MatchQ[destination,ObjectP[Object[Sample]]],
					Download[
						Lookup[
							fetchPacketFromCacheHPLC[
								Download[Lookup[fetchPacketFromCacheHPLC[destination,cache],Container],Object],
								cache
							],
							Model
						],
						Object
					],
				(* Tagged model *)
				MatchQ[destination,{_Symbol|_String|_Integer,ObjectP[Model[Sample]]}],
					Module[{resource,resourceContainerModel},

						resource = Lookup[OptionValue[RequiredObjectsLookup],Key[destination],Null];

						If[NullQ[resource],
							Return[Null,Module]
						];

						(* Strip link off using First *)
						resourceContainerModel = fetchResourceContainerModel[First@resource,Cache->cache];

						If[NullQ[resourceContainerModel],
							Null,
							resourceContainerModel
						]
					],
				(* {container, well} tuple with defined container *)
				MatchQ[destination,{_String,WellPositionP}],
					Module[{resource,resourceContainerModel},

						resource = Lookup[OptionValue[RequiredObjectsLookup],Key[destination],Null];

						If[NullQ[resource],
							Return[Null,Module]
						];

						(* Strip link off using First *)
						resourceContainerModel = fetchResourceContainerModel[First@resource,Cache->cache];

						If[NullQ[resourceContainerModel],
							Null,
							resourceContainerModel
						]
					],
				True,
					Null
			]
		],
		{destinations,destinationLocations},
		2
	]
];


(* ::Subsubsection::Closed:: *)
(*fetchResourceContainerModel*)


Options[fetchResourceContainerModel]:={Cache->{}};
(* This function will extract the requested container(s) for a resource *)
fetchResourceContainerModel[myResource_Resource,ops:OptionsPattern[]]:=Module[
	{container},

	(* If the resource directly requests a container, the container will be in the Sample key,
	If it requests a model in a particular container, the container(s) will be in the Container key.  *)
	container = Which[
		MatchQ[myResource[Sample],ObjectP[{Object[Container],Model[Container]}]],
			myResource[Sample],
		MatchQ[myResource[Container],ListableP[ObjectP[{Object[Container],Model[Container]}]]],
			myResource[Container],
		MatchQ[myResource[Sample],ObjectP[Object[Sample]]],
			Download[Lookup[fetchPacketFromCacheHPLC[myResource[Sample],OptionValue[Cache]],Container],Object],
		True,
			Null
	];

	If[NullQ[container],
		Return[Nothing,Module]
	];

	Switch[container,
		ObjectP[Object[Container]],
			Download[Lookup[fetchPacketFromCacheHPLC[container,OptionValue[Cache]],Model],Object],
		{ObjectP[Object[Container]]..},
			Download[Lookup[fetchPacketFromCacheHPLC[#,OptionValue[Cache]],Model]&/@container,Object],
		_,
			container
	]
];


(*specifyManipulation*)


(* Update the manipulation with additional keys to more fully specify the manipulation by fetching location information from samples and sample information from locations *)
(* This is needed since users initially describe manipulations in varying and incomplete ways - e.g. they might provide a destination sample, but we need to know the container/well *)
(* This will add the all information currently available and is called in the Experiment function and again in the compiler (necessary since models will not be fulfilled until run-time). *)
(* The following keys are added (manipulation specific):
	Transfer: ResolvedSourceLocation, SourceSample, ResolvedDestinationLocation,
	Aliquot: ResolvedSourceLocation, SourceSample, ResolvedDestinationLocations, DestinationSamples
	Consolidation: ResolvedSourceLocations,SourceSamples,ResolvedDestinationLocation,DestinationSample
	Mix: ResolvedSourceLocation, SourceSample
	Incubate: ResolvedSourceLocation, SourceSample
	Centrifuge: ResolvedSourceLocation, SourceSample
	Filter: ResolvedSourceLocation,SourceSample,ResolvedFilterLocation,ResolvedCollectionLocation
	Pellet: ResolvedSourceLocation, ResolvedSupernatantDestinationLocation, ResolvedResuspensionSourceLocation, SourceSample, SupernatantDestinationSample, ResuspensionSourceSample
	Cover: ResolvedSourceLocation
	Uncover: ResolvedSourceLocation
*)
(* Unknown information will be represented by Null values - e.g. if a transfer of a model is specified SourceSample and ResolvedSourceLocation will be set to Null *)
Options[specifyManipulation]:={Cache->{},DefineLookup-><||>,PrimaryInjectionSample->Null,SecondaryInjectionSample->Null};
specifyManipulation[myManipulation:SampleManipulationP,ops:OptionsPattern[]]:=Module[
	{manipulationType,defineLookup,specifyLocationFunction,specifySampleFunction,primaryInjectionModel,
	secondaryInjectionModel,specificationRules,specifiedManipulation},

	(* Get the type of myManipulation to determine what needs populating *)
	manipulationType = Head[myManipulation];

	(* Fetch lookup from options (lookup in the form <|"Name" -> Define primitive) *)
	defineLookup = OptionValue[DefineLookup];

	(* --- define internal functions that will be used to specify locations/samples for Source/Destination keys --- *)
	(* When specifying a manipulations, the sources/destinations can be supplied as Model[Sample], Model[Container], Object[Container], Object[Sample] or locations *)
	(* If possible we want to take the specified value and determine the location (container for single position containers, {container, well} for plates ) *)
	(* myContainerContents, myContainers, myContentPositions are index-matched lists used to get the container/well for the specified sample without having to Download *)
	specifyLocationFunction[mySpecifier_]:=Module[
		{convertedSpecifier},

		(* If the specified has a defined string in it, we need to convert it to the string's reference *)
		convertedSpecifier = Which[
			(* If specifier is a string, determine _what_ it specifies *)
			MatchQ[mySpecifier,_String],
				Module[{definePrimitive},

					definePrimitive = Lookup[defineLookup,mySpecifier];

					If[MatchQ[definePrimitive[ContainerName],mySpecifier],
						Return[
							If[MatchQ[definePrimitive[Sample],{ObjectP[{Object[Container],Model[Container]}],WellPositionP}],
								definePrimitive[Sample][[1]],
								definePrimitive[Container]
							],
							Module
						]
					];

					Which[
						MatchQ[definePrimitive[Sample],Except[Null|Automatic|_Missing]],
							definePrimitive[Sample],
						MatchQ[{definePrimitive[Container],definePrimitive[Well]},{ObjectP[],WellPositionP}],
							{definePrimitive[Container],definePrimitive[Well]},
						MatchQ[definePrimitive[Container],ObjectP[]],
							definePrimitive[Container],
						True,
							Null
					]
				],
			(* If specifier is a string representing a container, determine _what_ container it specifies *)
			MatchQ[mySpecifier,{_String,WellPositionP}],
				Module[{definePrimitive},

					definePrimitive = Lookup[defineLookup,mySpecifier[[1]]];

					If[MatchQ[definePrimitive[Container],ObjectP[{Object[Container,Vessel],Model[Container,Vessel]}]],
						definePrimitive[Container],
						{definePrimitive[Container],mySpecifier[[2]]}
					]
				],
			True,
				mySpecifier
		];

		Switch[convertedSpecifier,
			{ObjectReferenceP[Object[Container,Vessel]],WellPositionP},convertedSpecifier[[1]],
			(* Resolve raw plate locations to A1 *)
			ObjectReferenceP[Object[Container,Plate]],{convertedSpecifier,"A1"},
			ObjectReferenceP[Object[Container]]|PlateAndWellP,convertedSpecifier,
			ObjectReferenceP[Object[Sample]],Module[{samplePacket,container},

				(* get the sample packet from the overall sample packet list; we
				 	must have it since it is in the manipulation *)
				samplePacket=SelectFirst[OptionValue[Cache],MatchQ[Download[convertedSpecifier,Object],Lookup[#,Object]]&];

				(* pull out the sample container from the packet *)
				container=Download[Lookup[samplePacket,Container],Object];

				(* Return the container, or if in a plate, the {container,well} pair *)
				If[MatchQ[container,ObjectP[Object[Container,Plate]]],
					{container,Lookup[samplePacket,Position]},
					container
				]
			],
			(* Specifier is still a model, so we can't yet get the location *)
			_,Null
		]
	];

	(* When specifying a manipulations, the sources/destinations can be supplied as Model[Sample], Model[Container], Object[Container], Object[Sample] or locations *)
	(* If possible we want to take the specified value and determine the sample being referenced *)
	specifySampleFunction[mySpecifier_]:=Module[
		{convertedSpecifier},

		(* If the specified has a defined string in it, we need to convert it to the string's reference *)
		convertedSpecifier = Which[
			(* If specifier is a string, determine _what_ it specifies *)
			MatchQ[mySpecifier,_String],
				Module[{definePrimitive},

					definePrimitive = Lookup[defineLookup,mySpecifier];

					If[MatchQ[definePrimitive[ContainerName],mySpecifier],
						Return[
							If[MatchQ[definePrimitive[Sample],{ObjectP[{Object[Container],Model[Container]}],WellPositionP}],
								definePrimitive[Sample][[1]],
								definePrimitive[Container]
							],
							Module
						]
					];

					Which[
						MatchQ[definePrimitive[Sample],Except[Null|Automatic|_Missing]],
							definePrimitive[Sample],
						MatchQ[{definePrimitive[Container],definePrimitive[Well]},{ObjectP[],WellPositionP}],
							{definePrimitive[Container],definePrimitive[Well]},
						MatchQ[definePrimitive[Container],ObjectP[]],
							definePrimitive[Container],
						True,
							Null
					]
				],
			(* If specifier is a string representing a container, determine _what_ container it specifies *)
			MatchQ[mySpecifier,{_String,WellPositionP}],
				Module[{definePrimitive},

					definePrimitive = Lookup[defineLookup,mySpecifier[[1]]];

					If[MatchQ[definePrimitive[Container],ObjectP[{Object[Container,Vessel],Model[Container,Vessel]}]],
						definePrimitive[Container],
						{definePrimitive[Container],mySpecifier[[2]]}
					]
				],
			(* in case it's a plate and the ID is a Name, download the object since we're doing MatchQ below *)
			MatchQ[mySpecifier,ObjectP[Object[Container]]],
				Download[mySpecifier,Object],
			(* in case it's a plate and well and the ID is a Name, download the object since we're doing MatchQ below *)
			MatchQ[mySpecifier,PlateAndWellP],
				{Download[mySpecifier[[1]], Object], mySpecifier[[2]]},
			True,
				mySpecifier
		];
		
		Switch[convertedSpecifier,
			ObjectReferenceP[Object[Sample]],convertedSpecifier,

			ObjectReferenceP[Object[Container,Plate]],Module[
				{samplePacket},
				(* TODO do we need a swtich for Object[Container,Plate] here to populate not with SelectFirst but Select? *)
				(* find the sample that is in this container; since it's JUST a container,
				 we assume it is single position, and that only one sample packet is in it, if any (it may be empty) *)
				samplePacket=SelectFirst[OptionValue[Cache],MatchQ[convertedSpecifier,Download[Lookup[#,Container],Object]]&];

				(* return the object from the packet, or Null if the we didn't find any sample packet with this container (it's empty) *)
				If[MatchQ[samplePacket,PacketP[Object[Sample]]],
					Lookup[samplePacket,Object],
					Null
				]
			],

			ObjectReferenceP[Object[Container]],Module[
				{samplePacket},
			(* TODO do we need a swtich for Object[Container,Plate] here to populate not with SelectFirst but Select? *)
				(* find the sample that is in this container; since it's JUST a container,
				 	we assume it is single position, and that only one sample packet is in it, if any (it may be empty) *)
				samplePacket=SelectFirst[OptionValue[Cache],MatchQ[convertedSpecifier,Download[Lookup[#,Container],Object]]&,Null];

				(* return the object from the packet, or Null if the we didn't find any sample packet with this container (it's empty) *)
				If[MatchQ[samplePacket,PacketP[Object[Sample]]],
					Lookup[samplePacket,Object]
				]
			],
			{ObjectReferenceP[Object[Container]],_String},Module[
				{samplePacket},

				(* select the sample packet that is in the container and well specified (should be either none or 1) *)
				samplePacket = SelectFirst[
					OptionValue[Cache],
					And[
						MatchQ[Download[convertedSpecifier[[1]],Object],Download[Lookup[#,Container],Object]],
						MatchQ[convertedSpecifier[[2]],Lookup[#,Position]]
					]&,
					Null
				];

				(* return the object from the packet, or Null if the we didn't find any sample packet with this container (it's empty) *)
				If[MatchQ[samplePacket,PacketP[Object[Sample]]],
					Lookup[samplePacket,Object]
				]
			],
			_,Null
		]
	];

	primaryInjectionModel = If[MatchQ[OptionValue[PrimaryInjectionSample],ObjectP[Object[Sample]]],
		Download[Lookup[SelectFirst[OptionValue[Cache],MatchQ[OptionValue[PrimaryInjectionSample],Lookup[#,Object]]&,<||>],Model,Null],Object],
		OptionValue[PrimaryInjectionSample]
	];

	secondaryInjectionModel = If[MatchQ[OptionValue[SecondaryInjectionSample],ObjectP[Object[Sample]]],
		Download[Lookup[SelectFirst[OptionValue[Cache],MatchQ[OptionValue[SecondaryInjectionSample],Lookup[#,Object]]&,<||>],Model,Null],Object],
		OptionValue[SecondaryInjectionSample]
	];

	(* Get a new list of keys depending on the manipulation type *)
	specificationRules = Switch[manipulationType,
		Transfer,{
			ResolvedSourceLocation -> Map[
				specifyLocationFunction,
				(myManipulation[Source]),
				{2}
			],
			SourceSample -> Map[
				specifySampleFunction,
				(myManipulation[Source]),
				{2}
			],
			ResolvedDestinationLocation -> Map[
				specifyLocationFunction,
				(myManipulation[Destination]),
				{2}
			],
			DestinationSample -> Map[
				specifySampleFunction,
				(myManipulation[Destination]),
				{2}
			]
		},
		FillToVolume,{
			ResolvedSourceLocation->specifyLocationFunction[myManipulation[Source]],
			SourceSample->specifySampleFunction[myManipulation[Source]],
			ResolvedDestinationLocation->specifyLocationFunction[myManipulation[Destination]],
			DestinationSample->specifySampleFunction[myManipulation[Destination]]
		},
		Incubate|Mix|Cover|Uncover,
			Which[
			(* For the Incubate case, if we're dealing with a Sample key that is specified to a plate, we expand the source samples to all the samples contained in the plate here *)
				MatchQ[myManipulation[Sample],ObjectReferenceP[Object[Container,Plate]]],
				{
					ResolvedSourceLocation -> {specifyLocationFunction[myManipulation[Sample]]},
					SourceSample -> specifySampleFunction[myManipulation[Sample]] (* no need to list since the specifySampleFunction gives us a list for the case of a plate *)
				},
				(* If we're dealing with a listabl-ized primitive, we map over each entry *)
				MatchQ[myManipulation[Sample],{(objectSpecificationP|{ObjectReferenceP[Object[Container,Vessel]],WellPositionP})..}]&&!MatchQ[myManipulation[Sample],PlateAndWellP|{ObjectReferenceP[Object[Container,Vessel]],WellPositionP}],
				{
					ResolvedSourceLocation -> (specifyLocationFunction /@ myManipulation[Sample]),
					SourceSample -> Flatten[(specifySampleFunction /@ myManipulation[Sample])] (* need to flatten here in case we're dealing with a plate, in which case we would get a nested list *)
				},
				(* If the primitive comes in not listable-ized, don't listablize it.
				This is done because the compiler expands listable Mix primitives into
				multiple singleton primitives and expects them to be returned from
				this function still singleton. *)
			True,
				{
					ResolvedSourceLocation -> specifyLocationFunction[myManipulation[Sample]],
					SourceSample -> specifySampleFunction[myManipulation[Sample]]
				}
			],
		Centrifuge,
			Which[
			(* For the Centrifuge case, if we're dealing with a Sample key that is specified to a plate, we expand the source samples to all the samples contained in the plate here *)
				MatchQ[myManipulation[Sample],ObjectReferenceP[Object[Container,Plate]]],
				{
					ResolvedSourceLocation -> {specifyLocationFunction[myManipulation[Sample]]},
					SourceSample -> specifySampleFunction[myManipulation[Sample]] (* no need to list since the specifySampleFunction gives us a list *)
				},
			(* Convert input to list if it's not yet listed *)
				MatchQ[myManipulation[Sample],(objectSpecificationP|{ObjectReferenceP[Object[Container,Vessel]],WellPositionP})],
				{
					ResolvedSourceLocation -> {specifyLocationFunction[myManipulation[Sample]]},
					SourceSample -> {specifySampleFunction[myManipulation[Sample]]}
				},

				True,
			(* Keep listed input *)
				{
					ResolvedSourceLocation -> (specifyLocationFunction /@ myManipulation[Sample]),
					SourceSample -> Flatten[(specifySampleFunction /@ myManipulation[Sample])] (* need to flatten here in case we're dealing with a plate here, in which case we would get a nested list here *)
				}
			],
		Pellet,
			Module[{pelletSampleSpecification},
				(* We use this below to get the length of our samples. *)
				pelletSampleSpecification=If[MatchQ[myManipulation[Sample],(objectSpecificationP|{ObjectReferenceP[Object[Container,Vessel]],WellPositionP})],
					(* Convert input to list *)
					{
						ResolvedSourceLocation -> {specifyLocationFunction[myManipulation[Sample]]},
						SourceSample -> {specifySampleFunction[myManipulation[Sample]]}
					},
					(* Keep listed input *)
					{
						ResolvedSourceLocation -> (specifyLocationFunction /@ myManipulation[Sample]),
						SourceSample -> (specifySampleFunction /@ myManipulation[Sample])
					}
				];

				Join[
					pelletSampleSpecification,
					With[{
						expandedDestinations=If[MatchQ[myManipulation[SupernatantDestination],(Automatic|Waste|objectSpecificationP|{ObjectReferenceP[Object[Container,Vessel]],WellPositionP})],
							ConstantArray[Lookup[myManipulation[[1]], SupernatantDestination, Automatic], Length[Lookup[pelletSampleSpecification, SourceSample]]],
							myManipulation[SupernatantDestination]
						]},

						Switch[expandedDestinations,
							(Waste|objectSpecificationP|{ObjectReferenceP[Object[Container,Vessel]],WellPositionP}),
							(* Convert input to list *)
							{
								SupernatantDestination -> expandedDestinations,
								ResolvedSupernatantDestinationLocation -> {specifyLocationFunction[expandedDestinations]},
								SupernatantDestinationSample -> {specifySampleFunction[expandedDestinations]}
							},
							{(Waste|objectSpecificationP|{ObjectReferenceP[Object[Container,Vessel]],WellPositionP})..},
							(* Keep listed input *)
							{
								SupernatantDestination -> expandedDestinations,
								ResolvedSupernatantDestinationLocation -> (specifyLocationFunction /@ expandedDestinations),
								SupernatantDestinationSample -> (specifySampleFunction /@ expandedDestinations)
							},
							_,
							{
								SupernatantDestination -> expandedDestinations,
								ResolvedSupernatantDestinationLocation -> ConstantArray[Null, Length[expandedDestinations]],
								SupernatantDestinationSample -> ConstantArray[Null, Length[expandedDestinations]]
							}
						]
					],
					With[{
						expandedResuspensions=If[!MatchQ[myManipulation[ResuspensionSource], _List],
							ConstantArray[Lookup[myManipulation[[1]], ResuspensionSource, Automatic], Length[Lookup[pelletSampleSpecification, SourceSample]]],
							myManipulation[ResuspensionSource]
						]},
						Switch[expandedResuspensions,
							(objectSpecificationP|{ObjectReferenceP[Object[Container,Vessel]],WellPositionP}),
							(* Convert input to list *)
							{
								ResuspensionSource -> expandedResuspensions,
								ResolvedResuspensionSourceLocation -> {specifyLocationFunction[expandedResuspensions]},
								ResuspensionSourceSample -> {specifySampleFunction[expandedResuspensions]}
							},
							{(objectSpecificationP|{ObjectReferenceP[Object[Container,Vessel]],WellPositionP})..},
							(* Keep listed input *)
							{
								ResuspensionSource -> expandedResuspensions,
								ResolvedResuspensionSourceLocation -> (specifyLocationFunction /@ expandedResuspensions),
								ResuspensionSourceSample -> (specifySampleFunction /@ expandedResuspensions)
							},
							_,
							{
								ResuspensionSource -> expandedResuspensions,
								ResolvedResuspensionSourceLocation -> ConstantArray[Null, Length[expandedResuspensions]],
								ResuspensionSourceSample -> ConstantArray[Null, Length[expandedResuspensions]]
							}
						]
					]
				]
			],
		ReadPlate,
			Join[
				If[MatchQ[myManipulation[Sample],(objectSpecificationP|{ObjectReferenceP[Object[Container,Vessel]],WellPositionP})],
					(* Convert input to list *)
					{
						ResolvedSourceLocation -> {specifyLocationFunction[myManipulation[Sample]]},
						SourceSample -> {specifySampleFunction[myManipulation[Sample]]}
					},
					(* Keep listed input *)
					{
						ResolvedSourceLocation -> (specifyLocationFunction /@ myManipulation[Sample]),
						SourceSample -> (specifySampleFunction /@ myManipulation[Sample])
					}
				],
				If[MatchQ[myManipulation[AdjustmentSample],(objectSpecificationP|{ObjectReferenceP[Object[Container,Vessel]],WellPositionP})],
					{
						ResolvedAdjustmentSample -> specifySampleFunction[myManipulation[AdjustmentSample]],
						ResolvedAdjustmentSampleLocation -> specifyLocationFunction[myManipulation[AdjustmentSample]]
					},
					{}
				],
				If[MatchQ[myManipulation[Blank],(objectSpecificationP|{ObjectReferenceP[Object[Container,Vessel]],WellPositionP})],
					(* Convert input to list *)
					{
						ResolvedBlankLocation -> {specifyLocationFunction[myManipulation[Blank]]},
						ResolvedBlankSample -> {specifySampleFunction[myManipulation[Blank]]}
					},
					{
						ResolvedBlankLocation -> (specifyLocationFunction /@ Lookup[First[myManipulation],Blank,{}]),
						ResolvedBlankSample -> (specifySampleFunction /@ Lookup[First[myManipulation],Blank,{}])
					}
				],
				{
					If[MatchQ[myManipulation[PrimaryInjectionSample],{ObjectP[]|Null..}],
						PrimaryInjectionSample -> Map[
							Switch[#,
								primaryInjectionModel,
									OptionValue[PrimaryInjectionSample],
								secondaryInjectionModel,
									OptionValue[SecondaryInjectionSample],
								_,
									#
							]&,
							myManipulation[PrimaryInjectionSample]
						],
						Nothing
					],
					If[MatchQ[myManipulation[SecondaryInjectionSample],{ObjectP[]|Null..}],
						SecondaryInjectionSample -> Map[
							Switch[#,
								primaryInjectionModel,
									OptionValue[PrimaryInjectionSample],
								secondaryInjectionModel,
									OptionValue[SecondaryInjectionSample],
								_,
									#
							]&,
							myManipulation[SecondaryInjectionSample]
						],
						Nothing
					],
					If[MatchQ[myManipulation[TertiaryInjectionSample],{ObjectP[]|Null..}],
						TertiaryInjectionSample -> Map[
							Switch[#,
								primaryInjectionModel,
									OptionValue[PrimaryInjectionSample],
								secondaryInjectionModel,
									OptionValue[SecondaryInjectionSample],
								_,
									#
							]&,
							myManipulation[TertiaryInjectionSample]
						],
						Nothing
					],
					If[MatchQ[myManipulation[QuaternaryInjectionSample],{ObjectP[]|Null..}],
						QuaternaryInjectionSample -> Map[
							Switch[#,
								primaryInjectionModel,
									OptionValue[PrimaryInjectionSample],
								secondaryInjectionModel,
									OptionValue[SecondaryInjectionSample],
								_,
									#
							]&,
							myManipulation[QuaternaryInjectionSample]
						],
						Nothing
					]
				}
			],
		Filter,Module[
			{sourceLocations,sourceSamples,filterLocation,collectionContainerLocation,
			collectionLocations,collectionSamples},

			(* Fetch sample positions if possible *)
			sourceLocations = (specifyLocationFunction/@myManipulation[Sample]);

			(* Fetch sample objects *)
			sourceSamples = (specifySampleFunction/@myManipulation[Sample]);

			(* NOTE: Assume that error checking has occurred where we know all objects
			in Sample are in the same filter plate or are all in phytip columns. *)

			(* If our samples are in plates, then take the first index (the container) of the first sample location listed. *)
			(* Otherwise, if our samples are in phytip columns, take the first phytip column. *)
			filterLocation = Which[
				MatchQ[First[sourceLocations],{ObjectP[],WellPositionP}],
					First[First[sourceLocations]],
				MatchQ[sourceLocations, {ObjectP[Object[Container, Vessel]]..}],
					sourceLocations,
				True,
					Null
			];

			(* Fetch collection container location. Note that for Filter Macro, this can be a list of things, so we map over specifyLocationFunction in these cases *)
			collectionContainerLocation = Which[
				(* This is kind of a hacky first case where in some (macro) cases the manipulation has a list
				of all the same container index matching the ResolvedSampleLocation values.
				NOTE: the true thing to do if figure out why macro Filter sets it as such and change that *)
				And[
					MatchQ[myManipulation[CollectionContainer],{ObjectP[Object[Container,Plate]]..}],
					SameQ@@(myManipulation[CollectionContainer])
				],
					{First[myManipulation[CollectionContainer]]},
				MatchQ[myManipulation[CollectionContainer],{(ObjectP[]|_String|{_String,WellPositionP})..}],
					specifyLocationFunction/@myManipulation[CollectionContainer],
				True,
					specifyLocationFunction[myManipulation[CollectionContainer]]
			];

			(* Convert source locations to collection locations *)
			collectionLocations = Which[
				(* If we're dealing with a list of vessels (macro), those are just fine for the lookup below *)
				MatchQ[collectionContainerLocation,{ObjectP[Object[Container,Vessel]]..}],
					collectionContainerLocation,
				(* in other macro cases, like the Filter block, the collection container may be a plate, in a list *)
				(* we will use the source location to get the new {{collectionPlate, well}..} *)
				MatchQ[collectionContainerLocation,{ObjectP[Object[Container,Plate]]}],
					Map[
						{First[collectionContainerLocation],#[[2]]}&,
						sourceLocations
					],
				(* If we're dealing with a plate as the collection container but vessels as the sample containers, we're doing phytips. *)
				(* Use transposed AllWells[] order to get the order of the phytips. *)
				(* TODO: This should probably use vessel rack placements. *)
				MatchQ[collectionContainerLocation,{ObjectP[Object[Container,Plate]],"A1"}] && MatchQ[sourceLocations, {ObjectP[Object[Container, Vessel]]..}],
					Map[
						{First[collectionContainerLocation],#}&,
						Take[Flatten[Transpose[AllWells[]]], Length[sourceLocations]]
					],
				(* If we're dealing with a plate (micro), we will use the source location to get the new {{collectionPlate, well}..} *)
				MatchQ[collectionContainerLocation,ObjectP[Object[Container,Plate]]],
					Map[
					{collectionContainerLocation,#[[2]]}&,
					sourceLocations
				],
				MatchQ[collectionContainerLocation,{ObjectP[Object[Container,Plate]],_String}],
					Map[
						{collectionContainerLocation[[1]],#[[2]]}&,
						sourceLocations
				],
				True,
					Null
			];

			(* Find sample created at the collection location *)
			collectionSamples = Which[
				MatchQ[myManipulation[CollectionSample],{ObjectP[Object[Sample]]..}],
					myManipulation[CollectionSample],
				MatchQ[myManipulation[CollectionSample],(_Missing|{Null..}|Null)],
					specifySampleFunction/@collectionLocations,
				True,
					Table[Null,Length[sourceSamples]]
			];

			{
				ResolvedSourceLocation -> sourceLocations,
				SourceSample -> sourceSamples,
				ResolvedFilterLocation -> filterLocation,
				ResolvedCollectionLocation -> collectionContainerLocation,
				CollectionSample -> collectionSamples
			}
		],
		MoveToMagnet|RemoveFromMagnet,
			{
				ResolvedSourceLocation->specifyLocationFunction[myManipulation[Sample]],
				SourceSample->specifySampleFunction[myManipulation[Sample]]
			},
		_,{}
	];

	(* replace the manipulation internal association with the new specification rules *)
	manipulationType[Append[First[myManipulation],specificationRules]]
];



(* ::Subsubsection::Closed:: *)
(*convertResuspendPrimitive*)


(* Convert any Resuspend primitive to Transfer primitives*)
convertResuspendPrimitive[myPrimitive:SampleManipulationP]:=Module[
	{resuspendAssoc, sample, volume, diluent, pipettingParameterNames, specifiedPipettingParameters, transferPrimitive,
		incubatePrimitive, specifiedMixType, specifiedMixUntilDissolved, specifiedMixVolume, specifiedNumMixes,
		specifiedMaxNumMixes, specifiedIncubationTime, specifiedMaxIncubationTime, specifiedIncubationInstrument,
		specifiedIncubationTemperature, speciifedAnnealingTime, allAutomaticMixOptionValues, incubateQ,
		allPrimitives},

	(* if the primitive that we got in is anything but a resuspend primitive, just return it right here *)
	(* returning as a list because that will help us on the other side*)
	If[Not[MatchQ[myPrimitive, _Resuspend]],
		Return[{myPrimitive}]
	];

	(* pull out the association form of the Resuspend primitive *)
	resuspendAssoc = First[myPrimitive];

	(* pull out the Volume, Sample, and Diluent from the Resuspend primitive *)
	sample = Lookup[resuspendAssoc, Sample];
	volume = Lookup[resuspendAssoc, Volume];
	diluent = Lookup[resuspendAssoc, Diluent, Model[Sample, "Milli-Q water"]];

	(* get all of the pipetting parameters that were specified as an association*)
	pipettingParameterNames = Keys[SafeOptions[pipettingParameterOptions]];
	specifiedPipettingParameters = KeyTake[resuspendAssoc, pipettingParameterNames];

	(* generate the transfer primitive  *)
	transferPrimitive = Transfer[Join[
		<|
			Source -> diluent,
			Destination -> sample,
			Amount -> volume
		|>,
		specifiedPipettingParameters
	]];

	(* pull out all the mix option values *)
	allAutomaticMixOptionValues = Lookup[
		resuspendAssoc,
		{
			MixType,
			MixUntilDissolved,
			MixVolume,
			NumberOfMixes,
			MaxNumberOfMixes,
			IncubationTime,
			MaxIncubationTime,
			IncubationInstrument,
			IncubationTemperature,
			AnnealingTime
		},
		Automatic
	];


	(* determine if we are going to incubate or not *)
	incubateQ = MemberQ[allAutomaticMixOptionValues, Except[Automatic|Null]];

	(* split the mix options into their own variables the logic below to be more straightforward *)
	{
		specifiedMixType,
		specifiedMixUntilDissolved,
		specifiedMixVolume,
		specifiedNumMixes,
		specifiedMaxNumMixes,
		specifiedIncubationTime,
		specifiedMaxIncubationTime,
		specifiedIncubationInstrument,
		specifiedIncubationTemperature,
		speciifedAnnealingTime
	} = allAutomaticMixOptionValues;

	(* generate the Incubate or Mix primitive *)
	(* doing it in the association form so that Nothing works properly (i.e., Incubate[Sample -> blah, Nothing] doesn't collapse, but Incubate[<|Smaple -> blah, Nothing|>] does)*)
	incubatePrimitive = If[incubateQ,
		Incubate[<|
			Sample -> sample,
			If[MatchQ[specifiedMixType, Automatic|Null],
				Nothing,
				MixType -> specifiedMixType
			],
			If[MatchQ[specifiedMixUntilDissolved, Automatic|Null],
				Nothing,
				MixUntilDissolved -> specifiedMixUntilDissolved
			],
			If[MatchQ[specifiedMixVolume, Automatic|Null],
				Nothing,
				MixVolume -> specifiedMixVolume
			],
			If[MatchQ[specifiedNumMixes, Automatic|Null],
				Nothing,
				NumberOfMixes -> specifiedNumMixes
			],
			If[MatchQ[specifiedMaxNumMixes, Automatic|Null],
				Nothing,
				MaxNumberOfMixes -> specifiedMaxNumMixes
			],
			If[MatchQ[specifiedIncubationTime, Automatic|Null],
				Nothing,
				Time -> specifiedIncubationTime
			],
			If[MatchQ[specifiedMaxIncubationTime, Automatic|Null],
				Nothing,
				MaxTime -> specifiedMaxIncubationTime
			],
			If[MatchQ[specifiedIncubationInstrument, Automatic|Null],
				Nothing,
				Instrument -> specifiedIncubationInstrument
			],
			(* Add Ambient to the temperature if it's not specified because otherwise it will freak out*)
			If[MatchQ[specifiedIncubationTemperature, Automatic|Null],
				Temperature -> Ambient,
				Temperature -> specifiedIncubationTemperature
			],
			If[MatchQ[speciifedAnnealingTime, Automatic|Null],
				Nothing,
				AnnealingTime -> speciifedAnnealingTime
			]
		|>],
		Null
	];

	(* return the transfer and incubate primitives *)
	allPrimitives = DeleteCases[Flatten[{transferPrimitive, incubatePrimitive}], Null];

	allPrimitives

];



(* ::Subsubsection::Closed:: *)
(*convertTransferPrimitive*)


(* Convert any Aliquot/Consolidation primitives to expanded Transfer primitives and expand any Transfer primitives.
 	NOTE: Source/Destination/Amount key values will be "expanded" to low-level list syntax
	(ie: Source -> {{value..}..} etc *)
convertTransferPrimitive[myPrimitive_]:=Module[
	{},

	Switch[myPrimitive,
		_Aliquot,
			Transfer[
				(* Prepend such that any other parameters are preserved *)
				Prepend[
					KeyDrop[First[myPrimitive],{Destinations,Amounts}],
					Join[
						{
							Source -> Switch[myPrimitive[Source],
								{ObjectP[Model[Container,Plate]],_String},
									Module[{tag=Unique[]},
										Table[{{{tag,First[myPrimitive[Source]]},Last[myPrimitive[Source]]}},Length[myPrimitive[Destinations]]]
									],
								ObjectP[{Model[Container,Vessel],Model[Container,Cartridge],Model[Container,ReactionVessel],Model[Container,Cuvette],Model[Container,Plate]}],
									Module[{tag=Unique[]},
										Table[{{tag,myPrimitive[Source]}},Length[myPrimitive[Destinations]]]
									],
								_,
									Table[{myPrimitive[Source]},Length[myPrimitive[Destinations]]]
							],
							Destination -> List/@(myPrimitive[Destinations]),
							Amount -> Module[{myAmounts, expandedAmounts},
								myAmounts = myPrimitive[Amounts];
								expandedAmounts = If[MatchQ[myAmounts,_List],
									myAmounts,
									ConstantArray[myAmounts,Length[myPrimitive[Destinations]]]
								];
								List/@expandedAmounts
							]
						},
						KeyValueMap[
							If[MemberQ[Keys[manipulationKeyPatterns[Transfer]],#1],
								If[MatchQ[#2,Lookup[manipulationKeyPatterns[Transfer],#1]],
									#1 -> Table[#2,Length[myPrimitive[Destinations]]],
									Nothing
								],
								Nothing
							]&,
							KeyDrop[First[myPrimitive],{Source,Destinations,Amounts}]
						]
					]
				]
			],
		_Consolidation,
			Transfer[
				(* Prepend such that any other parameters are preserved *)
				Prepend[
					KeyDrop[First[myPrimitive],{Sources,Amounts}],
					Join[
						{
							Source -> List/@(myPrimitive[Sources]),
							Destination -> Switch[myPrimitive[Destination],
								{ObjectP[Model[Container,Plate]],_String},
									Module[{tag=Unique[]},
										Table[{{{tag,First[myPrimitive[Destination]]},Last[myPrimitive[Destination]]}},Length[myPrimitive[Sources]]]
									],
								ObjectP[{Model[Container,Vessel],Model[Container,Cartridge],Model[Container,ReactionVessel],Model[Container,Cuvette],Model[Container,Plate]}],
									Module[{tag=Unique[]},
										Table[{{tag,myPrimitive[Destination]}},Length[myPrimitive[Sources]]]
									],
								_,
									Table[{myPrimitive[Destination]},Length[myPrimitive[Sources]]]
							],
							Amount -> Module[{myAmounts, expandedAmounts},
								myAmounts = myPrimitive[Amounts];
								expandedAmounts = If[MatchQ[myAmounts,_List],
									myAmounts,
									ConstantArray[myAmounts, Length[myPrimitive[Sources]]]
								];
								List/@expandedAmounts
							]
						},
						KeyValueMap[
							If[MemberQ[Keys[manipulationKeyPatterns[Transfer]],#1],
								If[MatchQ[#2,Lookup[manipulationKeyPatterns[Transfer],#1]],
									#1 -> Table[#2,Length[myPrimitive[Sources]]],
									Nothing
								],
								Nothing
							]&,
							KeyDrop[First[myPrimitive],{Sources,Destination,Amounts}]
						]
					]
				]
			],
		_Transfer,
			Module[
				{rawSource,rawDestination,rawAmount,expandedSource,expandedDestination,expandedAmount},

				(* Extract specified values *)
				rawSource = myPrimitive[Source];
				rawDestination = myPrimitive[Destination];
				rawAmount = myPrimitive[Amount];

				(* Expand Source and Destination values depending on the specified syntax/listability *)
				{expandedSource,expandedDestination} = Switch[rawSource,
					objectSpecificationP,
						Switch[rawDestination,
							(* Source -> A, Destination -> B *)
							objectSpecificationP,
								{
									{{rawSource}},
									{{rawDestination}}
								},
							(* Source -> A, Destination -> {B} or {{B}} *)
							{(objectSpecificationP|{objectSpecificationP..})..},
								{
									(* Expand Source to match length of Destination *)
									Table[{rawSource},Length[rawDestination]],
									(* If Destination -> {B,C}, convert to {{B},{C}} *)
									Map[
										If[MatchQ[#,objectSpecificationP],
											{#},
											#
										]&,
										rawDestination
									]
								}
						],
					{(objectSpecificationP|{objectSpecificationP..})..},
						Switch[rawDestination,
							(* Source -> {A,B} or {{A},{B}}, Destination -> C *)
							objectSpecificationP,
								(* If Source -> {A,B}, convert to {{A},{B}} *)
								{
									Map[
										If[MatchQ[#,objectSpecificationP],
											{#},
											#
										]&,
										rawSource
									],
									(* Expand Destination to match length of Source *)
									Table[{rawDestination},Length[rawSource]]
								},
							(* Source -> {A,B} or {{A},{B}}, Destination -> {C,D} or {{C},{D}} *)
							{(objectSpecificationP|{objectSpecificationP..})..},
								(* If Source/Destination -> {A,B}, convert to {{A},{B}} *)
								Transpose@MapThread[
									Switch[#1,
										objectSpecificationP,
											Switch[#2,
												objectSpecificationP,
													{{#1},{#2}},
												{objectSpecificationP..},
													{Table[#1,Length[#2]],#2}
											],
										{objectSpecificationP..},
											Switch[#2,
												objectSpecificationP,
													{#1,Table[#2,Length[#1]]},
												{objectSpecificationP..},
													{#1,#2}
											]
									]&,
									{rawSource,rawDestination}
								]
						]
				];

				(* Expand Amount to match the listability or Source/Destination *)
				expandedAmount = Switch[rawAmount,
					(* If Amount -> amt, convert to {amt..} for each Source/Destination sublist.
					Expand the length of {amt..} to match the longest length of Source vs Destination
					ie: if Source -> {{A,B},{C}} and Destination -> {{D},{E}}, expand Amount -> {{amt,amt},{amt}}
					Use _Quantity instead of MassP|VolumeP in case the amount value is invalid (still need to handle it) *)
					_Quantity|_Integer,
						MapThread[
							Table[rawAmount,Max[Length[#1],Length[#2]]]&,
							{expandedSource,expandedDestination}
						],
					(* If Amount -> {amt..} or {{amt..}..}, convert any {amt..} to {{amt..}} matching the max
					length of expanded Source or Destination *)
					{(_Quantity|_Integer)..}|{{(_Quantity|_Integer)..}..},
					MapThread[
						If[MatchQ[#3,{(MassP|VolumeP|_Integer)..}],
							#3,
							Table[#3,Max[Length[#1],Length[#2]]]
						]&,
						{expandedSource,expandedDestination,rawAmount}
					]
				];

				(* Replace Source/Destination/Amount values with expanded values *)
				Transfer@Prepend[
					First[myPrimitive],
					Join[
						{
							Source -> expandedSource,
							Destination -> expandedDestination,
							Amount -> expandedAmount
						},
						KeyValueMap[
							If[MemberQ[Keys[manipulationKeyPatterns[Transfer]],#1],
								If[MatchQ[#2,Lookup[manipulationKeyPatterns[Transfer],#1]],
									#1 -> Table[#2,Length[expandedSource]],
									Nothing
								],
								Nothing
							]&,
							KeyDrop[First[myPrimitive],{Source,Destination,Amount}]
						]
					]
				]
			],
		_,
			myPrimitive
	]
];


(* ::Subsubsection::Closed:: *)
(*splitTransfers*)


Options[splitTransfers]:={Cache->{},DefineLookup->Association[]};

splitTransfers[myPrimitive_Mix,ops:OptionsPattern[]]:=Module[
	{primitiveAssociation,numberOfSamples},

	(* If we're not dealing with a mix-by-pipetting, return early *)
	If[
		And[
			!MatchQ[myPrimitive[MixType],{Pipette...}],
			!MatchQ[myPrimitive[MixVolume],{VolumeP...}]
		],
		Return[{myPrimitive}]
	];

	primitiveAssociation = First[myPrimitive];

	numberOfSamples = Length[primitiveAssociation[Sample]];

	(* Partition primitive. If a primitive has expanded its amounts such that the single
	primitive requires more than 8 channels, split that primitive into multiple primitives, each
	with fewer than 8 pipettings.
	NOTE: if we're optimizing, any split primitives will be merged in optimizePrimitives *)
	Mix/@If[numberOfSamples > 8,
		Association/@(Transpose@KeyValueMap[
			Function[{key,value},
				If[MatchQ[value,_List],
					Map[
						(key -> #)&,
						PartitionRemainder[value,8]
					],
					Table[key -> value,Quotient[numberOfSamples,8]]
				]
			],
			primitiveAssociation
		]),
		{primitiveAssociation}
	]

];

(* Split Transfer primitive pipetting steps into multiple pipettings if Amount exceeds specified
tip size or our max available tip size *)
splitTransfers[myPrimitive_,ops:OptionsPattern[]]:=Module[
	{cache,primitiveAssociation,specifiedTipTypes,specifiedTipSizes,sourceContainerModels,
	destinationContainerModels,allAccessedContainerModels,maxTipVolumes,amounts,
	partitionedAmounts,expandedPrimitiveAssociation},

	(* If we're not dealing with a transfer, return early *)
	If[!MatchQ[myPrimitive,_Transfer],
		Return[{myPrimitive}]
	];

	cache = OptionValue[Cache];

	(* Extract underlying association *)
	primitiveAssociation = First[myPrimitive];

	(* Extract specified TipType. If not a list, expand to the number of pipetting steps. *)
	specifiedTipTypes = Switch[Lookup[primitiveAssociation,TipType],
		_List,
			Lookup[primitiveAssociation,TipType],
		_Missing,
			Table[Automatic,Length[Lookup[primitiveAssociation,Amount]]],
		_,
			Table[Lookup[primitiveAssociation,TipType],Length[Lookup[primitiveAssociation,Amount]]]
	];

	(* Extract specified TipSize. If not a list, expand to the number of pipetting steps. *)
	specifiedTipSizes = Switch[Lookup[primitiveAssociation,TipSize],
		_List,
			Lookup[primitiveAssociation,TipSize],
		_Missing,
			Table[Automatic,Length[Lookup[primitiveAssociation,Amount]]],
		_,
			Table[Lookup[primitiveAssociation,TipSize],Length[Lookup[primitiveAssociation,Amount]]]
	];

	(* Fetch source container models from specified destination. This will be in the form:{{models..}..} *)
	sourceContainerModels = DeleteCases[
		fetchSourceModelContainers[
			myPrimitive,
			Cache->cache,
			DefineLookup->OptionValue[DefineLookup]
		],
		Null,
		{2}
	];

	(* Fetch destination container models from specified destination. This will be in the form:{{models..}..} *)
	destinationContainerModels = DeleteCases[
		fetchDestinationModelContainers[
			myPrimitive,
			Cache->cache,
			DefineLookup->OptionValue[DefineLookup]
		],
		Null,
		{2}
	];

	(* Join source and destination container models *)
	allAccessedContainerModels = MapThread[
		DeleteDuplicates[Flatten[{#1,#2}]]&,
		{destinationContainerModels,sourceContainerModels}
	];

	(* Determine the max volume that can be transferred by either a specified tip size
	or the biggest tip we have *)
	maxTipVolumes = MapThread[
		Function[{tipType,tipSize,accessedContainerModels},
			Which[
				MatchQ[tipSize,VolumeP],
					maximumAspirationVolume[tipSize],
				MatchQ[tipType,ObjectP[]],
					maximumAspirationVolume[Lookup[fetchPacketFromCacheHPLC[tipType,cache],MaxVolume]],
				(* 1000ul tips cannot fit in some vessels *)
				!And@@(tipsReachContainerBottomQ[
					Download[Model[Item,Tips,"1000 uL Hamilton tips, non-sterile"],Object],
					fetchPacketFromCacheHPLC[#,cache],
					{fetchPacketFromCacheHPLC[Download[Model[Item,Tips,"1000 uL Hamilton tips, non-sterile"],Object],cache]}
				]&/@accessedContainerModels),
					maximumAspirationVolume[300 Microliter],
				True,
					maximumAspirationVolume[1000 Microliter]
			]
		],
		{specifiedTipTypes,specifiedTipSizes,allAccessedContainerModels}
	];

	(* Extract the specified/expanded amounts *)
	amounts = Lookup[primitiveAssociation,Amount];

	(* Partition amounts by the max pipetting volume *)
	partitionedAmounts = Join@@MapThread[
		Function[{amountList,maxTipVolume},
			If[!MatchQ[amountList,{VolumeP..}],
				amountList,
				QuantityPartition[#,maxTipVolume]&/@amountList
			]
		],
		{amounts,maxTipVolumes}
	];

	(* For each pipetting step, replace specified amount with the partitioned amount
	(If we didn't need to partition into multiple volumes, the existing Amount value
	will be replaced with the identical amount value) *)
	expandedPrimitiveAssociation = Fold[
		Function[{splitPrimitive,amountIndexTuple},
			Module[{amountList,pipettingIndex},

				(* Extract next amount list and pipetting step index *)
				{amountList,pipettingIndex} = amountIndexTuple;

				(* If Amount is not a volume or is a list of a single volume,
				we don't need to expand/replace anything, return early. *)
				If[Or[!MatchQ[amountList,{VolumeP..}],Length[amountList]==1],
					(* Append whatever value is already in the original primitive at this pipettingIndex
					to the built splitPrimitive *)
					Association@KeyValueMap[
						Function[{key,value},
							key -> Append[
								value,
								Lookup[primitiveAssociation,key][[pipettingIndex]]
							]
						],
						splitPrimitive
					]
				];

				(* Expand all primitive key values to new, partitioned Amount length *)
				Association@KeyValueMap[
					Function[{key,value},
						key -> Join[
							value,
							Switch[key,
								Amount,
									{#}&/@amountList,
								Source|Destination,
									If[Length[amountList] == 1,
										{Lookup[primitiveAssociation,key][[pipettingIndex]]},
										Module[{tag=Unique[]},
											Table[
												Map[
													Switch[#,
														{ObjectP[Model[Container,Plate]],_String},
															{{tag,First[#]},Last[#]},
														ObjectP[{Model[Container,Vessel],Model[Container,Cartridge],Model[Container,ReactionVessel],Model[Container,Cuvette],Model[Container,Plate]}],
															{tag,#},
														_,
															#
													]&,
													Lookup[primitiveAssociation,key][[pipettingIndex]]
												],
												Length[amountList]
											]
										]
									],
								_,
									Table[Lookup[primitiveAssociation,key][[pipettingIndex]],Length[amountList]]
							]
						]
					],
					splitPrimitive
				]
			]
		],
		(* Start with an empty primitive *)
		Map[{}&,primitiveAssociation],
		Transpose[{partitionedAmounts,Range[Length[partitionedAmounts]]}]
	];

	(* Rebuild expanded primitives. If a primitive has expanded its amounts such that the single
	primitive requires more than 8 channels, split that primitive into multiple primitives, each
	with fewer than 8 pipettings.
	NOTE: if we're optimizing, any split primitives will be merged in optimizePrimitives *)
	Transfer/@If[Length[expandedPrimitiveAssociation[Source]] > 8,
		Association/@(Transpose@KeyValueMap[
			Function[{key,value},
				Map[
					(key -> #)&,
					PartitionRemainder[value,8]
				]
			],
			expandedPrimitiveAssociation
		]),
		{expandedPrimitiveAssociation}
	]
];



(* ::Subsubsection::Closed:: *)
(*resolveLiquidHandlingScale*)


(*
 	This function determines the possible liquid handling scales that can be used for each of the manipulations, and all of them as a whole

	Will follow the preference hierarchy: Micro>Bufferbot>Macro

	Checks whether all amounts required by the manipulation are in range for each method/scale, and checks container compatibility

	A lot of hard-coded stuff in here
*)
Options[resolveLiquidHandlingScale]:={Cache->{}};
resolveLiquidHandlingScale[myManipulations:{SampleManipulationP..},myScaleOption:(LiquidHandlingScaleP|Automatic),myBufferbotQ:BooleanP,myGatherTestBool:BooleanP,rawManipulations:{SampleManipulationP..},ops:OptionsPattern[]]:=Module[
	{gatherTests,messages,incubatePrimitivesMicro,incubatePrimitivesMacro,microOnlyIncubateOptionP,macroOnlyIncubateOptionP,microRequiredOptions,
	microOnlyFilterOptionsP,macroOnlyFilterOptionsP,filteredSampleReferences,definedFilterReferences,filterPrimitivesMicro,filterPrimitivesMacro,methodByFilterKeys,
	mismatchingScaleManips,mismatchingScaleTest,failingManipulations,liquidTransferMethods,overallBufferbotQ,sampleAndModelPackets,
	incompatibleSamples,liquidHandlerIncompatibleQ, incubatePrimitivesConflictingWithResolvedScale,manipulationMethods,
	microCompatibleContainers,bufferbotCompatibleContainers,resolvedLiquidHandlingScale,amountOutOfRangeMessageTestTuple,invalidScaleMessageTestTuple,
	incubateMicroPrimitivesMissingKeys,incubateMicroMissingKeysMessage,incubateMicroMissingKeysTest,transferManipulations,
	amountsForTransfers,volumesForTransfers,largeLiquidHandlerVolume,largeVolumeTest,scaleErrorBooleans,scaleTests,
	allBooleans,conflictingWithResolvedScaleMessage,mismatchingScaleMessage,allTests,conflictingIncubateWithScaleTests,
	filterPrimitivesConflictingWithResolvedScale,filterConflictingWithResolvedScaleMessage,conflictingFilterWithScaleTests,
	incubatePrimitivesConflictingWithResolvedScaleTuples,requiredIncubateScale,filterPrimitivesConflictingWithResolvedScaleTuples,requiredFilterScale},

	gatherTests = myGatherTestBool;
	messages =! gatherTests;

	(* list the keys from the Incubate primitive that are only used in Micro scale *)
	microOnlyIncubateOptionP = Alternatives[
		Preheat
	];

	(* list the keys from the Incubate primitive that are only used in Macro scale *)
	macroOnlyIncubateOptionP = Alternatives[
		AnnealingTime,
		MixType,
		Instrument,
		NumberOfMixes,
		MixVolume,
		MixUntilDissolved,
		MaxNumberOfMixes,
		MaxTime
	];

	microRequiredOptions = {
		Time,
		Temperature
	};

	(* get the Incubate primitives that have defined micro keys only *)
	incubatePrimitivesMicro = Select[
		myManipulations,
		(MatchQ[#,_Incubate]&&MemberQ[Keys[First[#]],microOnlyIncubateOptionP]&&!MemberQ[Keys[First[#]],macroOnlyIncubateOptionP])&
	];

	(* get the Incubate primitives that have defined macro keys only *)
	incubatePrimitivesMacro = Select[
		myManipulations,
		(MatchQ[#,_Incubate]&&MemberQ[Keys[First[#]],macroOnlyIncubateOptionP]&&!MemberQ[Keys[First[#]],microOnlyIncubateOptionP])&
	];

	(* List the keys from the Filter primitive that are only used in Micro scale *)
	microOnlyFilterOptionsP=Alternatives[
		Pressure
	];

	(* List the keys from the Filter primitive that are only used in Macro scale *)
	macroOnlyFilterOptionsP=Alternatives[
		Filter,
		MembraneMaterial,
		PoreSize,
		FiltrationType,
		Instrument,
		FilterHousing,
		Syringe,
		Sterile,
		MolecularWeightCutoff,
		PrefilterMembraneMaterial,
		PrefilterPoreSize,
		Temperature
	];

	(* get the Incubate primitives that have defined micro keys only *)
	filterPrimitivesMicro=Select[rawManipulations,(MatchQ[#,_Filter]&&MemberQ[Keys[First[#]],microOnlyFilterOptionsP]&&!MemberQ[Keys[First[#]],macroOnlyFilterOptionsP])&];

	(* get the Incubate primitives that have defined macro keys only *)
	filterPrimitivesMacro=Select[rawManipulations,(MatchQ[#,_Filter]&&MemberQ[Keys[First[#]],macroOnlyFilterOptionsP]&&!MemberQ[Keys[First[#]],microOnlyFilterOptionsP])&];

	(* We need to extract all all Filter plate references that are used as a filter in a Filter primitive.
	These plates are able to be used in Micro SM but if they're not used in a filter primitive, we must use Macro
	(since we don't "auto" select a collection plate to sit under the filter plate) *)
	filteredSampleReferences = Join@@Map[
		If[MatchQ[#[Sample],objectSpecificationP],
			{#[Sample]},
			#[Sample]
		]&,
		Cases[rawManipulations,_Filter]
	];

	(* Extract the string references to the Filter primitives *)
	definedFilterReferences = Map[
		Switch[#,
			_String,
				#,
			{_String,WellPositionP},
				#[[1]],
			_,
				Nothing
		]&,
		filteredSampleReferences
	];

	(* To Avoid calling compatibleSampleManipulationContainers in every iteration, pull it once into designated variables *)
	microCompatibleContainers = compatibleSampleManipulationContainers[MicroLiquidHandling,EngineDefaultOnly->False];

	(* For consistency, do the same for bufferbot, although those don't really prompt a search *)
	bufferbotCompatibleContainers = compatibleSampleManipulationContainers[Bufferbot];
	
	(* determine which liquid handling scale can be used for each of the manipulations, in isolation;
	 	follow the preference order Micro > Bufferbot > Manual.
	 	Note that for the Incubate primitive, we decide depending on which type of keys were specified in the raw manipulation	*)
	manipulationMethods = Map[
		Module[
			{macroOnlyCentrifugeOptionP,methodByCentrifugeKeys,microIncubateTemperatureMinMax,
			methodByIncubateKeys,containers,modelContainers,samples,sampleContainers,allContainers,
			directContainerModels,uniqueModelContainers,methodByMagnetContainerModels,methodByContainerModels,manipulationAmounts,
			transferCutoff,microMinMax,bufferbotMinMax,manualVolumeMinMax,manualWeightMinMax,
			methodByAmounts},

		(* "Wait" can go with either Micro or Macro - default to Micro since we can still resolve to Macro if Automatic*)
			If[MatchQ[#1,_Wait],
				Return[MicroLiquidHandling,Module]
			];

			If[MatchQ[#1,_ReadPlate],
				Return[MicroLiquidHandling,Module]
			];
			
			If[MatchQ[#1,_Cover|_Uncover],
				Return[MicroLiquidHandling,Module]
			];

			If[MatchQ[#1,_FillToVolume],
				Return[MacroLiquidHandling,Module]
			];

			If[MatchQ[#1,_Pellet],
				Return[MacroLiquidHandling,Module]
			];
			
			If[And[MatchQ[#1,_Mix],MatchQ[#[MixType],Except[_Missing|{(Pipette|Null)..},MixTypeP]]],
				Return[MacroLiquidHandling,Module]
			];
			
			microIncubateTemperatureMinMax = {0 Celsius, 105 Celsius};

			(* If it's an Incubate primitive we go with whichever keys are specified in the raw manipulation *)
			methodByIncubateKeys=Which[
			(* If we have a temperature outside the micro-compatible range, use Macro *)
			And[
				MatchQ[#,_Incubate],
				KeyExistsQ[First[#],Temperature],
				And@@Map[
					And[
						!MatchQ[#,Ambient],
						!Between[#,microIncubateTemperatureMinMax]
					]&,
					(* In case Temperature is listable *)
					ToList[Lookup[First[#],Temperature]]
				]
			],
				Return[MacroLiquidHandling,Module],
			(* if we only have micro keys, go with micro *)
				And[MatchQ[#,_Incubate], MemberQ[Keys[First[#]],microOnlyIncubateOptionP],!MemberQ[Keys[First[#]],macroOnlyIncubateOptionP]],Return[MicroLiquidHandling,Module],
			(* if we only have macro keys, go with macro *)
				And[MatchQ[#,_Incubate], MemberQ[Keys[First[#]],macroOnlyIncubateOptionP],!MemberQ[Keys[First[#]],microOnlyIncubateOptionP]],Return[MacroLiquidHandling,Module],
			(* if none of the specific keys are provided, we default to MicroLiquidHandling *)
				And[MatchQ[#,_Incubate], !MemberQ[Keys[First[#]],macroOnlyIncubateOptionP],!MemberQ[Keys[First[#]],microOnlyIncubateOptionP]],Return[MicroLiquidHandling,Module],
			(* if conflicting, we can't determine - do not put $Failed since that will throw a different error below; and we've already thrown an error above *)
				And[MatchQ[#,_Incubate], MemberQ[Keys[First[#]],macroOnlyIncubateOptionP],MemberQ[Keys[First[#]],microOnlyIncubateOptionP]],Return[Null,Module]
			];

			(* If it's an Incubate primitive we go with whichever keys are specified in the raw manipulation *)
			methodByFilterKeys=Which[
			(* if we only have micro keys, go with micro *)
				And[MatchQ[#,_Filter], MemberQ[Keys[First[#]],microOnlyFilterOptionsP],!MemberQ[Keys[First[#]],macroOnlyFilterOptionsP]],Return[MicroLiquidHandling,Module],
			(* if we only have macro keys, go with macro *)
				And[MatchQ[#,_Filter], MemberQ[Keys[First[#]],macroOnlyFilterOptionsP],!MemberQ[Keys[First[#]],microOnlyFilterOptionsP]],Return[MacroLiquidHandling,Module],
			(* if none of the specific keys are provided, we default to MicroLiquidHandling *)
				And[MatchQ[#,_Filter], !MemberQ[Keys[First[#]],macroOnlyFilterOptionsP],!MemberQ[Keys[First[#]],microOnlyFilterOptionsP]],Return[MicroLiquidHandling,Module],
			(* if conflicting, we can't determine - do not put $Failed since that will throw a different error below; and we've already thrown an error above *)
				And[MatchQ[#,_Filter], MemberQ[Keys[First[#]],macroOnlyFilterOptionsP],MemberQ[Keys[First[#]],microOnlyFilterOptionsP]],Return[Null,Module]
			];

			(* Pull out all of the container objects, and model objects used in this manipulation

			If this is a define primitive defining a sample/plate used as a Filter plate in a Filter primitive,
			do not check that it is compatible since we check that elsewhere. *)
			containers = If[
				And[
					MatchQ[#,_Define],
					Or[
						MemberQ[definedFilterReferences,#[Name]],
						MemberQ[definedFilterReferences,#[ContainerName]]
					]
				],
				{},
				If[MatchQ[#,_Filter],
					Cases[KeyDrop[First[#],Filter],ObjectReferenceP[Object[Container]],Infinity],
					Cases[#,ObjectReferenceP[Object[Container]],Infinity]
				]
			];
			modelContainers=If[
				And[
					MatchQ[#,_Define],
					Or[
						MemberQ[definedFilterReferences,#[Name]],
						MemberQ[definedFilterReferences,#[ContainerName]]
					]
				],
				{},
				If[MatchQ[#,_Filter],
					Cases[KeyDrop[First[#],Filter],ObjectReferenceP[Model[Container]],Infinity],
					Cases[#,ObjectReferenceP[Model[Container]],Infinity]
				]
			];
			samples=Cases[#,ObjectReferenceP[Object[Sample]],Infinity];

			(* Fetch the samples' containers *)
			sampleContainers = Download[
				Map[
					Lookup[fetchPacketFromCacheHPLC[#,OptionValue[Cache]],Container]&,
					Download[samples,Object]
				],
				Object
			];

			(* Join sample containers and directly specified containers *)
			allContainers = Join[containers,sampleContainers];

			(* use the overall container packet input list to determine the models  *)
			directContainerModels=Lookup[
				Map[
					Function[
						containerObject,
						fetchPacketFromCacheHPLC[containerObject,OptionValue[Cache]]
					],
					Download[allContainers,Object]
				],
				Model,
				{}
			];

			(* get all of the unique model containers involved in this manipulation. *)
			uniqueModelContainers = DeleteDuplicates[Download[Join[modelContainers,directContainerModels],Object]];
			
			macroOnlyCentrifugeOptionP = Alternatives[
				Temperature,
				CollectionContainer,
				Instrument,
				CounterbalanceWeight
			];
			
			(* If it's an Centrifuge primitive we go with whichever keys are specified in the raw manipulation *)
			methodByCentrifugeKeys = If[
				Or[
					MatchQ[#,_Centrifuge],
					And[
						MatchQ[#,_Filter],
						KeyExistsQ[First[#],Intensity]
					]
				],
				Which[
					Or[
						!KeyExistsQ[First[#],Intensity],
						!KeyExistsQ[First[#],Time]
					],
						Return[MacroLiquidHandling,Module],
					Or@@Map[
						!MatchQ[Lookup[fetchPacketFromCacheHPLC[#,OptionValue[Cache]],Footprint],Plate]&,
						uniqueModelContainers
					],
						Return[MacroLiquidHandling,Module],
					(* If we have a intensity outside the micro-compatible range, use Macro *)
					And[
						Or[
							MatchQ[#,_Centrifuge],
							And[
								MatchQ[#,_Filter],
								KeyExistsQ[First[#],Intensity]
							]
						],
						KeyExistsQ[First[#],Intensity],
						And@@Map[
							If[MatchQ[#,RPMP],
								# > 3000 RPM,
								# > 1000 GravitationalAcceleration
							]&,
							(* In case Temperature is listable *)
							ToList[Lookup[First[#],Intensity]]
						]
					],
						Return[MacroLiquidHandling,Module],
				(* if we have macro keys, go with macro *)
					And[
						Or[
							MatchQ[#,_Centrifuge],
							And[
								MatchQ[#,_Filter],
								KeyExistsQ[First[#],Intensity]
							]
						],
						MemberQ[Keys[First[#]],macroOnlyCentrifugeOptionP]
					],
						Return[MacroLiquidHandling,Module],
					(* Otherwise default to Micro *)
					True,
						Return[MicroLiquidHandling,Module]
				]
			];

			(*If it's a MoveToMagnet/RemoveFromMagnet primitive we currently only support a 96-well plate and Micro;
			if the container is not a 96-well plate, we already threw Error::IncompatibleMagnetContainer so just return Null here*)
			methodByMagnetContainerModels=If[MatchQ[#,_MoveToMagnet|_RemoveFromMagnet],
				If[
					Or@@Map[
						!MatchQ[Lookup[fetchPacketFromCacheHPLC[#,OptionValue[Cache]],NumberOfWells],96]&,
						uniqueModelContainers
					],
					Return[Null,Module],
					(*Otherwise default to Micro*)
					Return[MicroLiquidHandling,Module]
				]
			];

			(* determine which method can support the provided container models;
			 	any contianers are compatible with Manual *)
			methodByContainerModels=Which[
				SubsetQ[microCompatibleContainers,uniqueModelContainers],MicroLiquidHandling,
				myBufferbotQ&&SubsetQ[bufferbotCompatibleContainers,uniqueModelContainers],Bufferbot,
				True,MacroLiquidHandling
			];

			If[MatchQ[#,_Define],
				Return[methodByContainerModels,Module]
			];

			(* now check the amounts in the manipulation; get all the amounts required by the manipulation *)
			manipulationAmounts=Switch[#,
				_Transfer,Join@@(#[Amount]),
				_Mix,#[MixVolume],
				_,{0 Microliter}
			];

			(* If the user specifically asked for Micro don't impose a max volume *)
			transferCutoff=If[MatchQ[myScaleOption,MicroLiquidHandling],
				Infinity*Milliliter,
				10 Milliliter
			];

			(* determine the min/max allowed amounts for each potential scale; these can also depend on the type of manip *)
			microMinMax={
				0.5 Microliter,
				If[MatchQ[#,_Mix],
					maximumAspirationVolume[1000 Microliter],
					transferCutoff
				]
			};
			bufferbotMinMax={2 Milliliter,20 Liter};
			manualVolumeMinMax={
				Min[TransferDevices[Model[Item,Tips],All][[All,2]]],
				If[MatchQ[#,_Mix],
					Max[TransferDevices[Model[Item,Tips],All][[All,3]]], (* can only mix with tips currently *)
					Max[TransferDevices[Model[Container,GraduatedCylinder],All][[All,3]]]*20 (* current hard-coded number of repeat fills for manual *)
				]
			};
			manualWeightMinMax={
				Min[TransferDevices[Model[Instrument,Balance],All][[All,2]]],
				Max[TransferDevices[Model[Instrument,Balance],All][[All,3]]]
			};

			(* now determine what liquid handling method is possible based on the amounts *)
			methodByAmounts=Which[
				MatchQ[manipulationAmounts,{VolumeP..}]&&(And@@(Between[microMinMax]/@manipulationAmounts)),MicroLiquidHandling,
				myBufferbotQ&&!MatchQ[#,_Mix]&&MatchQ[manipulationAmounts,{VolumeP..}]&&(And@@(Between[bufferbotMinMax]/@manipulationAmounts)),Bufferbot,
				MatchQ[manipulationAmounts,{VolumeP..}]&&(And@@(Between[manualVolumeMinMax]/@manipulationAmounts)),MacroLiquidHandling,
				MatchQ[manipulationAmounts,{MassP..}]&&(And@@(Between[manualWeightMinMax]/@manipulationAmounts)),MacroLiquidHandling,
				MatchQ[manipulationAmounts,{_Integer..}],MacroLiquidHandling,
				True,$Failed
			];

			(* if either by container model or amount standards we have to use a lower priority scale,
			 	default into that as the method for this manipulation *)
			Which[
				MemberQ[{methodByContainerModels,methodByAmounts},$Failed],$Failed,
				MemberQ[{methodByContainerModels,methodByAmounts},MacroLiquidHandling],MacroLiquidHandling,
				MemberQ[{methodByContainerModels,methodByAmounts},Bufferbot],Bufferbot,
				True,MicroLiquidHandling
			]
		]&,
		myManipulations
	];

	(* If any of the manipulations wants Macro, but the LiquidHandlingScale was user-specified to Micro, need to throw a (vague) error. *)
	(* Since we've already thrown more specific FillToVolume, Filter, MoveToMagnet, RemoveFromMagnet, Incubate, Centrifuge, Pellet errors/tests above and below, remove those primitive types from this error/tests *)
	(* TODO make this even more granular by taking into account methodByAmounts and methodByContainerModels *)
	mismatchingScaleManips=If[MatchQ[myScaleOption,MicroLiquidHandling],
		DeleteCases[PickList[myManipulations,manipulationMethods,Except[MicroLiquidHandling]],(_FillToVolume|_Filter|_MoveToMagnet|_RemoveFromMagnet|_Incubate|_Centrifuge|_Pellet)],
		{}];

	(* If the scale was specified to MicroLiquidHandling, but some of the primitives require Macro/BufferBot, we throw an error and set the tracking variable to True *)
	mismatchingScaleMessage=Module[{mismatchingPrimitiveHead,primitiveIndices,mismatchingScale},
		If[(Length[mismatchingScaleManips]>0 && messages),
			primitiveIndices=Position[myManipulations,#]&/@mismatchingScaleManips;
			mismatchingPrimitiveHead=DeleteDuplicates[Head/@mismatchingScaleManips];
			mismatchingScale=Extract[manipulationMethods,primitiveIndices];
			(Message[Error::MicroScaleNotPossible,Flatten[primitiveIndices],mismatchingScale,mismatchingPrimitiveHead];Message[Error::InvalidOption,LiquidHandlingScale]);
		True,
		False
		]
	];

	(* If we are gathering tests, create tests (but only need those tests if scale is specified to MicroLiquidHandling *)
	mismatchingScaleTest=If[gatherTests&&MatchQ[myScaleOption,MicroLiquidHandling],

	(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingManips,passingIncubateManips,passingManipsTest,passingPrimitiveIndices,failingPrimitiveIndices,failingManipsTest},

		(* Get the inputs that pass this test. Make sure to exclude FillToVolume, MoveToMagnet, RemoveFromMagnet, Incubate, Centrifuge, Pellet primitives since we've already thrown a more specific test above *)
			passingManips=DeleteCases[Complement[myManipulations,mismatchingScaleManips],_FillToVolume|_MoveToMagnet|_RemoveFromMagnet|_Incubate|_Centrifuge|_Pellet];

			(* get the index of the failing and passing primitives *)
			passingPrimitiveIndices=Sort[Flatten[Position[myManipulations,#]&/@passingManips]];
			failingPrimitiveIndices=Sort[Flatten[Position[myManipulations,#]&/@mismatchingScaleManips]];

			(* Create a test for the passing inputs. *)
			passingManipsTest=If[Length[passingManips]>0,
				Test["The manipulation primitive(s) at positions "<>ToString[passingPrimitiveIndices]<>" are compatible with the specified LiquidHandlingScale, MicroLiquidHandling:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingManipsTest=If[Length[mismatchingScaleManips]>0,
				Test["The manipulation primitive(s) at positions "<>ToString[failingPrimitiveIndices]<>" are compatible with the specified LiquidHandlingScale, MicroLiquidHandling:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingManipsTest,
				failingManipsTest
			}
		],
	(* We aren't gathering tests. No tests to create. *)
		{}
	];


	(* if we encountered a hard failure for any single manipulation, we don't have a method currently to do whatever was requested;
	 throw an error in this case *)
	failingManipulations=PickList[myManipulations,manipulationMethods,$Failed];

	(* TODO: currently, manipulations that don't match the patterns will also throw the AmountOutOfRange error message since they return methodByAmounts->$Failed and thus show up in failingManipulations -> FIX THAT *)
	(* collect the appropriate tests or throw error messages if there are failing manipulations; collect a boolean for whether a message was thrown so that we can return $Failed further down*)
	amountOutOfRangeMessageTestTuple =
		{
		(* If we're collecting messages and there are failing manipulations, throw an error message and set the message bool to True *)
		If[!gatherTests&&Length[failingManipulations]>0,
			(
				Message[Error::SampleManipulationAmountOutOfRange,failingManipulations];
				Message[Error::InvalidInput,failingManipulations];
			);
			True,
			False],
		(* If we're collecting test, throw a test if a specific manipulation cannot be performed and if all are fine, throw a different test message stating that *)
		If[gatherTests,
			If[Length[failingManipulations]>0,
				Test["This manipulation "<>ToString[failingManipulations]<>" can be performed using the currently-available instrumentation in the lab:",True,False],
				Test["All manipulations can be performed using the currently-available instrumentation in the lab:",True,True]],
			Null]
		};

	(* bufferbot is overall in play if:
		 - the flag to allow it was passed
		 - all LIQUID manipulations are bbot compatible (there is handling for solid transfers to happen in advance) *)
	liquidTransferMethods=MapThread[
		Function[{manipulation,method},
			If[MatchQ[manipulation,_Transfer]&&MatchQ[Join@@(manipulation[Amount]),{VolumeP..}],
				method,
				Nothing
			]
		],
		{myManipulations,manipulationMethods}
	];
	overallBufferbotQ=myBufferbotQ&&MatchQ[liquidTransferMethods,{Bufferbot..}];

	(* get the sample and model packets *)
	sampleAndModelPackets=Cases[OptionValue[Cache],PacketP[{Object[Sample],Model[Sample]}]];

	(* determine if any of the samples/models involved are marked as liquid handling incompatible *)
	incompatibleSamples=Cases[sampleAndModelPackets,KeyValuePattern[{Object->obj_,LiquidHandlerIncompatible->True}]:>obj];
	liquidHandlerIncompatibleQ=!MatchQ[incompatibleSamples,{}];

	(* depending on the initial option value, resolve it, validate it, or provide an error *)
	(* since we haven't return a hard error above for failing manipulations, need to consider these here as well and put the scale to $Failed in these cases *)
	{resolvedLiquidHandlingScale, invalidScaleMessageTestTuple}= Switch[myScaleOption,

		Automatic,Which[
			(* If failing Manipulations exist, the scale needs to resolve to $Failed. Don't throw message/test since we've done so already above*)
			Length[failingManipulations]>0,
				{$Failed,{False,Null}},
			MatchQ[manipulationMethods,{MicroLiquidHandling..}]&&!liquidHandlerIncompatibleQ,
				{MicroLiquidHandling,{False,Null}},
			overallBufferbotQ&&!liquidHandlerIncompatibleQ,
				{Bufferbot,{False,Null}},
			True,
				{MacroLiquidHandling,{False,Null}}
		],

		(*If MacroLiquidHandling is specified, we can do manual (indicate with MacroLiquidHandling) or Bufferbot *)
		MacroLiquidHandling,Which[
			(* If Macro is specified but failing Manipulations exist, need to resolve to $Failed. Don't throw message/test since we've done so already above*)
			Length[failingManipulations]>0,
				{$Failed,{False,Null}},
			(* We can do Bufferbot only if the feature flag has been passed in and all liquid manipulations are bbot compatible *)
			overallBufferbotQ&&liquidHandlerIncompatibleQ,
				{Bufferbot,{False,Null}},
			(* else, we do Macro, es specified *)
			True,
				{MacroLiquidHandling,{False,Null}}
		],

		(* If Micro is specified, make sure none require macro, that there is no incompatibility, and no failing manipulations *)
		MicroLiquidHandling,Which[

			(* If a primitive requires Macro, the scale needs to be $Failed. Don't throw message/test since we've done so already above *)
			Or[
				MemberQ[manipulationMethods,MacroLiquidHandling|Bufferbot],
				MemberQ[myManipulations,_FillToVolume|_Pellet]
			],
				{$Failed,{True,Null}},

			(* if any of the primitives are handling samples that are liquid-handling incompatible, need to throw error / tests here *)
			liquidHandlerIncompatibleQ,
				If[!gatherTests,
					(Message[Error::IncompatibleChemicals,DeleteDuplicates[incompatibleSamples]];Message[Error::InvalidOption,LiquidHandlingScale]);
					{$Failed,{True,Null}},
					{$Failed,{True,Test["The requested manipulation scale "<>ToString[myScaleOption]<>" is compatible with the specified manipulations:",False,True]}}],

			(* If failing Manipulations exist, the scale needs to be $Failed. Don't throw message/test since we've done so already above*)
			Length[failingManipulations]>0,
				{$Failed,{False,Null}},

			(* In all cases, we can do Micro as userspecified *)
			True,
				{MicroLiquidHandling,{False,Null}}
		]
	];

	(* Reformat results from Maps *)
	{scaleErrorBooleans,scaleTests}=Transpose[{amountOutOfRangeMessageTestTuple,invalidScaleMessageTestTuple}];

	(* == more error checking - now that we have resolved the scale, we need to make sure that no Incubate or Filter primitives need the other scale *)

	(* get Incubate primitives with keys that are conflicting with the resolved Scale *)
	{incubatePrimitivesConflictingWithResolvedScale,requiredIncubateScale}=Which[
		(* it wasn't specified before (in that cse we've already thrown an error above), and it was specified to Micro, but we have primitives that want Macro *)
		MatchQ[myScaleOption,Automatic]&&MatchQ[resolvedLiquidHandlingScale,MicroLiquidHandling]&&!MatchQ[incubatePrimitivesMacro,{}],{incubatePrimitivesMacro,"MacroLiquidHandling"},
		MatchQ[myScaleOption,Automatic]&&MatchQ[resolvedLiquidHandlingScale,MacroLiquidHandling]&&!MatchQ[incubatePrimitivesMicro,{}],{incubatePrimitivesMicro,"MicroLiquidHandling"},
		True,{{},{}}
	];

	(* If there are Incubate primitives with keys conflicting with the scale, and we are throwing messages, throw an error message here and set the error tracking variable to True *)
	conflictingWithResolvedScaleMessage=Module[{conflictingWithScaleIncubateOptions,primitiveIndices},
		If[(Length[incubatePrimitivesConflictingWithResolvedScale]>0 && !gatherTests),
			conflictingWithScaleIncubateOptions=Map[Intersection[Keys[#],Join[ToList@@microOnlyIncubateOptionP,ToList@@macroOnlyIncubateOptionP]]&,incubatePrimitivesConflictingWithResolvedScale];
			primitiveIndices=Flatten[Position[myManipulations,#]&/@incubatePrimitivesConflictingWithResolvedScale];
			(
				Message[Error::IncubateManipConflictsWithResolvedScale,primitiveIndices,resolvedLiquidHandlingScale,conflictingWithScaleIncubateOptions,requiredIncubateScale];
				Message[Error::InvalidInput,incubatePrimitivesConflictingWithResolvedScale];
			);
			True,
			False
		]
	];

	(* If we are gathering tests, create tests for the Incubate primitives conflicting with the specified Scale *)
	conflictingIncubateWithScaleTests=If[gatherTests,

	(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingManips,passingIncubateManips,passingManipsTest,passingPrimitiveIndices,failingPrimitiveIndices,failingManipsTest},

		(* Get the inputs that pass this test. *)
			passingManips=Complement[myManipulations,incubatePrimitivesConflictingWithResolvedScale];

			(* make sure we only select the incubate primitives here, since for the others this test is irrelevant *)
			passingIncubateManips=Select[passingManips,MatchQ[#,_Incubate]&];

			(* get the index of the failing and passing primitives *)
			passingPrimitiveIndices=Sort[Flatten[Position[myManipulations,#]&/@passingIncubateManips]];
			failingPrimitiveIndices=Sort[Flatten[Position[myManipulations,#]&/@incubatePrimitivesConflictingWithResolvedScale]];

			(* Create a test for the passing inputs. *)
			passingManipsTest=If[Length[passingManips]>0,
				Test["In the manipulation primitives at the positions(s) "<>ToString[passingPrimitiveIndices]<>", the primitive keys match the resolved LiquidHandlingScale:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingManipsTest=If[Length[incubatePrimitivesConflictingWithResolvedScale]>0,
				Test["In the manipulation primitives at the positions(s) "<>ToString[failingPrimitiveIndices]<>", the primitive keys match the resolved LiquidHandlingScale:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingManipsTest,
				failingManipsTest
			}
		],
	(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* get Filter primitives with keys that are conflicting with the resolved Scale *)
	{filterPrimitivesConflictingWithResolvedScale,requiredFilterScale}=Which[
	(* it wasn't specified before (in that cse we've already thrown an error above), and it was specified to Micro, but we have primitives that want Macro *)
		MatchQ[myScaleOption,Automatic]&&MatchQ[resolvedLiquidHandlingScale,MicroLiquidHandling]&&!MatchQ[filterPrimitivesMacro,{}],{filterPrimitivesMacro,"MacroLiquidHandling"},
		MatchQ[myScaleOption,Automatic]&&MatchQ[resolvedLiquidHandlingScale,MacroLiquidHandling]&&!MatchQ[filterPrimitivesMicro,{}],{filterPrimitivesMicro,"MicroLiquidHandling"},
		True,{{},{}}
	];

	(* If there are Filter primitives with keys conflicting with the scale, and we are throwing messages, throw an error message here and set the error tracking variable to True *)
	filterConflictingWithResolvedScaleMessage=Module[{conflictingWithScaleFilterOptions,primitiveIndices},
		If[(Length[filterPrimitivesConflictingWithResolvedScale]>0 && !gatherTests),
			conflictingWithScaleFilterOptions=Map[Intersection[Keys[#],Join[ToList@@microOnlyFilterOptionsP,ToList@@macroOnlyFilterOptionsP]]&,filterPrimitivesConflictingWithResolvedScale];
			primitiveIndices=Flatten[Position[rawManipulations,#]&/@incubatePrimitivesConflictingWithResolvedScale];
			(
				Message[Error::FilterManipConflictsWithResolvedScale,primitiveIndices,resolvedLiquidHandlingScale,conflictingWithScaleFilterOptions,requiredFilterScale];
				Message[Error::InvalidInput,filterPrimitivesConflictingWithResolvedScale];
			);
			True,
			False
		]
	];

	(* If we are gathering tests, create tests for the Incubate primitives conflicting with the specified Scale *)
	conflictingFilterWithScaleTests=If[gatherTests,

	(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingManips,passingIncubateManips,passingManipsTest,passingPrimitiveIndices,failingPrimitiveIndices,failingManipsTest},

		(* Get the inputs that pass this test. *)
			passingManips=Complement[rawManipulations,incubatePrimitivesConflictingWithResolvedScale];

			(* make sure we only select the incubate primitives here, since for the others this test is irrelevant *)
			passingIncubateManips=Select[passingManips,MatchQ[#,_Incubate]&];

			(* get the index of the failing and passing primitives *)
			passingPrimitiveIndices=Sort[Flatten[Position[rawManipulations,#]&/@passingIncubateManips]];
			failingPrimitiveIndices=Sort[Flatten[Position[rawManipulations,#]&/@incubatePrimitivesConflictingWithResolvedScale]];

			(* Create a test for the passing inputs. *)
			passingManipsTest=If[Length[passingManips]>0,
				Test["In the manipulation primitives at the positions(s) "<>ToString[passingPrimitiveIndices]<>", the primitive keys match the resolved LiquidHandlingScale:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingManipsTest=If[Length[incubatePrimitivesConflictingWithResolvedScale]>0,
				Test["In the manipulation primitives at the positions(s) "<>ToString[failingPrimitiveIndices]<>", the primitive keys match the resolved LiquidHandlingScale:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingManipsTest,
				failingManipsTest
			}
		],
	(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* get Incubate primitives with keys that are conflicting with the resolved Scale *)
	incubateMicroPrimitivesMissingKeys=If[MatchQ[myScaleOption,Automatic]&&MatchQ[resolvedLiquidHandlingScale,MicroLiquidHandling],
		Select[myManipulations,(MatchQ[#,_Incubate]&&!ContainsAll[Keys[First[#]], microRequiredOptions])&],
		{}
	];

	(* If we have primitives with missing keys, throw an error *)
	incubateMicroMissingKeysMessage=Module[{missingIncubateOptions,primitiveIndices},
		If[(Length[incubateMicroPrimitivesMissingKeys]>0 && !gatherTests),
			missingIncubateOptions=Map[Complement[microRequiredOptions,Keys[#]]&,incubateMicroPrimitivesMissingKeys];
			primitiveIndices=Flatten[Position[myManipulations,#]&/@incubateMicroPrimitivesMissingKeys];
			(
				Message[Error::MicroPrimitiveMissingKeys,primitiveIndices,missingIncubateOptions];
				Message[Error::InvalidInput,incubateMicroPrimitivesMissingKeys];
			);
			True,
			False
		]
	];

	(* If we are gathering tests, create tests for the Incubate primitives conflicting with the specified Scale *)
	incubateMicroMissingKeysTest=If[gatherTests,

	(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingManips,passingIncubateManips,passingManipsTest,passingPrimitiveIndices,failingPrimitiveIndices,failingManipsTest},

		(* Get the inputs that pass this test. *)
			passingManips=Complement[myManipulations,incubateMicroPrimitivesMissingKeys];

			(* make sure we only select the incubate primitives here, since for the others this test is irrelevant *)
			passingIncubateManips=Select[passingManips,MatchQ[#,_Incubate]&];

			(* get the index of the failing and passing primitives *)
			passingPrimitiveIndices=Sort[Flatten[Position[myManipulations,#]&/@passingIncubateManips]];
			failingPrimitiveIndices=Sort[Flatten[Position[myManipulations,#]&/@incubateMicroPrimitivesMissingKeys]];

			(* Create a test for the passing inputs. *)
			passingManipsTest=If[Length[passingManips]>0,
				Test["The manipulation primitives at the positions(s) "<>ToString[passingPrimitiveIndices]<>", have all keys that are required by the LiquidHandlingScale that was resolved to:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingManipsTest=If[Length[incubateMicroPrimitivesMissingKeys]>0,
				Test["The manipulation primitives at the positions(s) "<>ToString[failingPrimitiveIndices]<>", have all keys that are required by the LiquidHandlingScale that was resolved to:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingManipsTest,
				failingManipsTest
			}
		],
	(* We aren't gathering tests. No tests to create. *)
		{}
	];



	(* == more error checking  related to the transfer Volumes == *)

	(* Check only the manipulations which transfer volumes *)
	transferManipulations = Cases[myManipulations,_Transfer];

	(* Get a list of amounts from each manipulation *)
	amountsForTransfers = Map[
		Join@@(#[Amount])&,
		transferManipulations
	];

	(* Get just the volumes (in case we have some masses) *)
	volumesForTransfers=Cases[Flatten[amountsForTransfers,1],VolumeP];

	(* If we're doing micro liquid handling, make sure we aren't going to spend a crazy amount of time pipetting large volumes *)
	largeLiquidHandlerVolume=MatchQ[resolvedLiquidHandlingScale,MicroLiquidHandling]&&MemberQ[volumesForTransfers,GreaterP[10 Milliliter]];

	(* Throw a warning if we have large volumes, provided we aren't instead returning tests *)
	If[largeLiquidHandlerVolume&&!gatherTests,
		Message[Warning::ManyTransfersRequired]
	];

	allBooleans=Join[{filterConflictingWithResolvedScaleMessage},{conflictingWithResolvedScaleMessage},scaleErrorBooleans,{mismatchingScaleMessage},{incubateMicroMissingKeysMessage}];
	allTests=Join[conflictingIncubateWithScaleTests,conflictingIncubateWithScaleTests,scaleTests,{largeVolumeTest},{mismatchingScaleTest},{incubateMicroMissingKeysTest}];

	(* Create a test for our large liquid handler volume warning *)
	largeVolumeTest=Warning["If the manipulations will be performed on a micro liquid handler, all volumes being transferred are less than or equal to 5mL and can be completed without an inordinate number of pipet transfers:",largeLiquidHandlerVolume,False];

	{
		resolvedLiquidHandlingScale,
		{
			allBooleans,
			allTests
		}
	}
];


(* NOTE: this function is called in AbsorbanceSpectroscopy and not just in directly-related SampleManipulation places, so if you dramatically change this function, be sure to make sure that one works too *)
(*compatibleSampleManipulationContainers[MicroLiquidHandling]:={
	Model[Container,Plate,"id:L8kPEjkmLbvW"],*)(* "96-well 2mL Deep Well Plate" *)(*
	Model[Container,Plate,"id:jLq9jXY4kknW"], *)(* "96-well 500uL Round Bottom DSC Plate" *)(*
	Model[Container,Plate,"id:n0k9mGzRaaBn"], *)(* "96-well UV-Star Plate" *)(*
	Model[Container,Plate,"id:1ZA60vwjbbqa"], *)(* "96-well Round Bottom Plate" *)(*
	Model[Container,Plate,"id:Vrbp1jG800Vb"], *)(* "Sterile 300mL Polypropylene Robotic Reservoir" *)(*
	Model[Container, Plate, "id:54n6evLWKqbG"], *)(* "200mL Polypropylene Robotic Reservoir, non-sterile" *)(*
	Model[Container,Plate,"id:E8zoYveRllM7"], *)(* "48-well Pyramid Bottom Deep Well Plate" *)(*
	Model[Container, Plate, "id:qdkmxzkKwn11"], *)(* "24-well V-bottom 10 mL Deep Well Plate Sterile" *)(*
	Model[Container,Plate,"id:6V0npvK611zG"], *)(* "96-well Black Wall Plate" *)(*
	Model[Container,Plate,"id:kEJ9mqR3XELE"], *)(* "96-well Black Wall Greiner Plate" *)(*
	Model[Container, Plate, "id:Y0lXejML17rm"], *)(* 96-Well Black Optical-Bottom Plates with Polymer Base *)(*
	Model[Container,Plate,"id:BYDOjvG1pRnE"], *)(* "96-Well All Black Plate" *)(*
	Model[Container,Plate,"id:Z1lqpMGjeekO"], *)(* "96-well 1mL Deep Well Plate" *)(*
	Model[Container, Plate, "id:R8e1PjpVrbMv"], *)(* 96-well 1.2mL Deep Well Plate (Hamilton version for Elmo) *)(*
	Model[Container,Plate,"id:01G6nvkKrrYm"], *)(* "96-well PCR Plate" *)(*
	Model[Container, Plate, "id:9RdZXv1laYVK"], *)(* "96-well Optical Full-Skirted PCR Plate" *)(*
	Model[Container,Plate,"id:4pO6dM55ar55"], *)(* "96-well Clear Wall V-Bottom Plate" *)(*
	Model[Container, Plate, "id:wqW9BP7N0w7V"],	*)(* 96-well Polystyrene Conical-Bottom Plate, Clear *)(*
	Model[Container, Plate, "id:AEqRl9KmGPWa"],	*)(* 96-well Polypropylene Flat-Bottom Plate, Black *)(*
	Model[Container, Plate, "id:rea9jlRLlqYr"],	*)(* 96-well Polystyrene Flat-Bottom Plate, Clear *)(*
	Model[Container,Plate,"id:O81aEBZ4EMXj"], *)(* Lunatic chip plate *)(*
	Model[Container,Vessel,"id:3em6Zv9NjjN8"], *)(* "2mL Tube" *)(*
	Model[Container,Vessel,"id:01G6nvkKrrL4"], *)(* "2mL Black Tube" *)(*
	Model[Container,Vessel,"id:aXRlGn6LO7Bk"], *)(* 0.7mL Skirted Tube *)(*
	Model[Container,Vessel,"id:01G6nvkKrrb1"], *)(* 0.5mL Skirted Tube" *)(*
	Model[Container, Vessel, "id:E8zoYvNOwG9v"], *)(* "Fully Tapered 0.5mL Tube with 2mL Tube Skirt" *)(*
	Model[Container, Vessel, "id:6V0npvmqR5BG"], *)(* "Fully Tapered 0.5mL Tube with 2mL Tube Skirt, Brown" *)(*
	Model[Container,Vessel,"id:bq9LA0dBGGR6"], *)(* "50mL Tube" *)(*
	Model[Container,Vessel,"id:bq9LA0dBGGrd"], *)(* "50mL Light Sensitive Centrifuge Tube" *)(*
	Model[Container,Vessel,"id:AEqRl954GGvv"], *)(* "HPLC vial (flat bottom)" *)(*
	Model[Container,Vessel,"id:AEqRl954GG7a"], *)(* "2mL Glass CE Vials" *)(*
	Model[Container,Vessel,"id:jLq9jXvxr6OZ"], *)(* HPLC vial (high recovery) *)(*
	Model[Container,Vessel,"id:eGakld01zzpq"], *)(* "1.5mL Tube with 2mL Tube Skirt" *)(*
	Model[Container,Vessel,"id:4pO6dM5WvJKM"], *)(* "8x43mm Glass Reaction Vial" *)(*
	Model[Container, Vessel, "id:eGakldJ6p35e"], *)(* "22x45mm screw top vial 10mL" *)(*
	Model[Container, Plate, MALDI, "id:7X104vK9ZZ7X"], *)(* "96-well Ground Steel MALDI Plate"] *)(*
	Model[Container, Plate, "id:pZx9jo8x59oP"], *)(* In Situ-1 Crystallization Plate *)(*
	Model[Container, Plate, "id:pZx9jo83G0VP"], *)(* 384-well qPCR Optical Reaction Plate *)(*
	Model[Container, Plate, "id:Vrbp1jG800ME"], *)(* 384-well UV-Star Plate *)(*
	Model[Container, Plate, "id:P5ZnEjddrmNW"], *)(* 384-well Black Flat Bottom Plate *)(*
	Model[Container, Plate, Irregular, "id:dORYzZJArVMG"], *)(* Simple Western MidMolecularWeight (12-230 kDa) assay plate *)(*
	Model[Container, Plate, Irregular, "id:dORYzZJArnRe"], *)(* Simple Western LowMolecularWeight (2-40 kDa) assay plate *)(*
	Model[Container, Plate, Irregular, "id:9RdZXv1nGK3j"], *)(* Simple Western HighMolecularWeight (66-440 kDa) assay plate *)(*
	Model[Container, Plate, "id:8qZ1VW06z9Zp"], *)(* Kibron Tensiometer DynePlate *)(*
	Model[Container, Plate, "id:GmzlKjP9KdJ9"], *)(*Uncle capillary plate adapter*)(*
	Model[Container, Plate, Irregular, CapillaryELISA, "id:lYq9jRxrY65l"], *)(* CapillaryELISA SinglePlex 72X1 Cartridge for IL-6 *)(*
	Model[Container, Plate, Irregular, CapillaryELISA, "id:3em6ZvLneGBW"] *)(* CapillaryELISA 48-Digoxigenin Cartridge *)(*
};*)
compatibleSampleManipulationContainers[Bufferbot]:={
	Model[Container,Vessel,"id:xRO9n3vk11pw"], (* 15 mL tube *)
	Model[Container,Vessel,"id:bq9LA0dBGGR6"], (* 50 mL tube *)
	Model[Container,Vessel,"id:bq9LA0dBGGrd"], (* "50mL Light Sensitive Centrifuge Tube" *)
	Model[Container,Vessel,"id:J8AY5jwzPPR7"], (* 250 mL glass bottle *)
	Model[Container,Vessel,"id:aXRlGnZmOONB"], (* 500 mL glass bottle *)
	Model[Container,Vessel,"id:zGj91aR3ddXJ"], (* 1L glass bottle *)
	Model[Container,Vessel,"id:3em6Zv9Njjbv"], (* 2L glass bottle *)
	Model[Container,Vessel,"id:Vrbp1jG800Zm"], (* 4L amber glass bottle *)
	Model[Container,Vessel,"id:aXRlGnZmOOB9"], (* 10L Polypropylene Carboy *)
	Model[Container,Vessel,"id:3em6Zv9NjjkY"] (* 20L Polypropylene Carboy *)
};

DefineOptions[
	compatibleSampleManipulationContainers,
	Options:>{
		{ContainerType -> {Model[Container,Vessel],Model[Container,Plate]}, All|ListableP[TypeP[Model[Container]]], "The list of container types desired as output. Defaults to All types"},
		{EngineDefaultOnly -> True, BooleanP, "Indicates whether a container must be marked as EngineDefault->True to be considered compatible. This is useful when creating resource requests where samples should be transferred into common Hamilton-compatible containers."},
		(*{MinVolume -> None, None|VolumeP, "The list of container types desired as output. Defaults to All types"},*)
		CacheOption
	}
];

(* Core overload which memoizes *)
(*compatibleSampleManipulationContainers[MicroLiquidHandling,ops:OptionsPattern[compatibleSampleManipulationContainers]] := compatibleSampleManipulationContainers[MicroLiquidHandling] = Module[*)
compatibleSampleManipulationContainers[MicroLiquidHandling,ops:OptionsPattern[compatibleSampleManipulationContainers]] := Module[
	{safeOps,typesOp,discoveredPlates,discoveredRacks,discoveredVessels,additionalTempHardcodes,engineDefaultOnly,
		plateSearchCriteria,vesselSearchCriteria},

	safeOps = SafeOptions[compatibleSampleManipulationContainers,ToList[ops]];
	{typesOp,engineDefaultOnly} = Lookup[safeOps,{ContainerType,EngineDefaultOnly}];

	plateSearchCriteria = If[engineDefaultOnly,
		LiquidHandlerPrefix != Null && EngineDefault !=False && DeveloperObject!=True,
		LiquidHandlerPrefix != Null && DeveloperObject!=True
	];

	vesselSearchCriteria = If[engineDefaultOnly,
		LiquidHandlerRackID != Null && EngineDefault !=False && DeveloperObject!=True,
		LiquidHandlerRackID != Null && DeveloperObject!=True
	];

	(* Search for all plates with LiquidHandlerPrefix and all Vessels with LiquidHandlerRackID *)
	{discoveredPlates,discoveredRacks,discoveredVessels} = If[Constellation`Private`loggedInQ[],

		Search[
			{Model[Container,Plate],Model[Container,Rack],Model[Container,Vessel]},
			Evaluate[{plateSearchCriteria,plateSearchCriteria,vesselSearchCriteria}]
		],

		(* Necessary for loading without error *)
		{{},{},{}}
	];

	(* Temporary hardcodes while we adjust how these vessels are handled in the database - will update by end of 7/14/2020 *)
	additionalTempHardcodes = {
		Model[Container, Vessel, "id:4pO6dM5WvJKM"],(*"8x43mm Glass Reaction Vial"*)
		Model[Container, Vessel, "id:eGakldJ6p35e"](*"22x45mm screw top vial 10mL"*)
	};

	(* Return the full list of plates and vessels that can be used *)
	If[MatchQ[typesOp,All],
		Flatten[{discoveredVessels,discoveredPlates,additionalTempHardcodes}],
		DeleteCases[
			Flatten[{discoveredVessels,discoveredPlates,discoveredRacks,additionalTempHardcodes}],
			Except[Alternatives@@(ObjectP/@ToList[typesOp])]
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*OptimizePrimitives*)


DefineOptions[OptimizePrimitives,Options:>{CacheOption}];

OptimizePrimitives[myPrimitives:{SampleManipulationP...},ops:OptionsPattern[]]:=Module[
	{listedOptions,safeOptions,allSamples,allContainers,allModelContainers,specifiedTipTypes,downloadPackets,
	allPackets,expandVolume,manipulationsWithAmountKey,manipulationsWithExpandedMixes,
	manipulationsWithExpandedIncubations,primitivesWithConvertedTransfers,nonZeroAmountManipulations,
	splitPrimitiveLists,splitPrimitives,manipulationsWithResolvedDefines,resolvedDefinePrimitives,definedNamesLookup,
	specifiedManipulations,scaleToUseForFurtherResolving,defaultOnDeckReservoir,expandedRentContainerBools,allSpecifiedModelPackets,
	modelMaxAmounts,optimizedPrimitives, primitivesWithConvertedResuspends,uniqueContainerPackets,
	uniqueSamplePackets,allModels,requiredObjects,requiredObjectsLookup,possibleTips,allTips},

	(* Filter options through pattern check *)
	listedOptions = ToList[ops];
	safeOptions = SafeOptions[ExperimentSampleManipulation,listedOptions,AutoCorrect->False];

	(* If input options are invalid, return early *)
	If[MatchQ[safeOptions,$Failed],
		Return[$Failed]
	];

	(* convert the Resuspend primitives to Transfer/Incubate primitives immediately *)
	primitivesWithConvertedResuspends = Flatten[convertResuspendPrimitive /@ myPrimitives];

	(* we still allow the Amount key to be specified as legacy Volume key; convert everything to Amount/Amounts
		for ease of use internally; currently, only Transfer/Aliquot/Consolidation allow initial Volume(s) key use *)
	expandVolume[amount_,length_]:=If[ListQ[amount],amount,Table[amount,Length[length]]];
	manipulationsWithAmountKey = Map[
		Switch[#,
			_Transfer,
				If[!MissingQ[#[Volume]],
					Transfer[Append[KeyDrop[First[#],Volume],Amount->#[Volume]]],
					#
				],
			_Aliquot,
				If[!MissingQ[#[Volumes]],
					Head[#][Append[KeyDrop[First[#],Volumes],Amounts->expandVolume[#[Volumes],#[Destinations]]]],
					Head[#][Append[KeyDrop[First[#],Volumes],Amounts->expandVolume[#[Amounts],#[Destinations]]]]
				],
			_Consolidation,
				If[!MissingQ[#[Volumes]],
					Head[#][Append[KeyDrop[First[#],Volumes],Amounts->expandVolume[#[Volumes],#[Sources]]]],
					Head[#][Append[KeyDrop[First[#],Volumes],Amounts->expandVolume[#[Amounts],#[Sources]]]]
				],
			_,
				#
		]&,
		primitivesWithConvertedResuspends
	];
	
	(* Expand singleton keys in any Mix primitives *)
	manipulationsWithExpandedMixes = Map[
		If[MatchQ[#,_Mix],
			Module[{expandedSamples},

				expandedSamples = If[MatchQ[#[Sample],objectSpecificationP],
					{#[Sample]},
					#[Sample]
				];

				Mix[
					Prepend[First[#],
						{
							Sample -> If[MatchQ[#[Sample],objectSpecificationP],
								{#[Sample]},
								#[Sample]
							],
							If[MatchQ[#[MixType],_Missing],
								Nothing,
								MixType -> If[MatchQ[#[MixType],MixTypeP|Null],
									Table[#[MixType],Length[expandedSamples]],
									#[MixType]
								]
							],
							If[MatchQ[#[NumberOfMixes],_Missing],
								Nothing,
								NumberOfMixes -> If[MatchQ[#[NumberOfMixes],_Integer],
									Table[#[NumberOfMixes],Length[expandedSamples]],
									#[NumberOfMixes]
								]
							],
							If[MatchQ[#[MixVolume],_Missing],
								Nothing,
								MixVolume -> If[MatchQ[#[MixVolume],VolumeP],
									Table[#[MixVolume],Length[expandedSamples]],
									#[MixVolume]
								]
							]
						}
					]
				]
			],
			#
		]&,
		manipulationsWithAmountKey
	];

	(* Expand singleton Sample key in Incubate primitives
	(Other Incubate keys will be expanded in resolution) *)
	manipulationsWithExpandedIncubations = Map[
		If[MatchQ[#,_Incubate],
			Incubate[
				Prepend[
					First[#],
					Sample -> If[MatchQ[#[Sample],objectSpecificationP],
						{#[Sample]},
						#[Sample]
					]
				]
			],
			#
		]&,
		manipulationsWithExpandedMixes
	];

	(* Converts Aliquot and Consolidation primitives to low-level Transfer syntax
	and returns Transfer primitives with expanded Source/Destination/Amount key values *)
	primitivesWithConvertedTransfers = convertTransferPrimitive/@manipulationsWithExpandedIncubations;

	(* Extract objects of specific types referenced in primitives *)
	allSamples = findObjectsOfTypeInPrimitive[primitivesWithConvertedTransfers,Object[Sample]];
	allModels = findObjectsOfTypeInPrimitive[primitivesWithConvertedTransfers,Model[Sample]];
	allContainers = findObjectsOfTypeInPrimitive[primitivesWithConvertedTransfers,Object[Container]];
	allModelContainers = findObjectsOfTypeInPrimitive[primitivesWithConvertedTransfers,Model[Container]];
	
	(* Extract any tip types specified in primitives *)
	specifiedTipTypes = Cases[
		Flatten@Map[(#[TipType])&,primitivesWithConvertedResuspends],
		ObjectP[]
	];

	(* We need to download fields from all liquid-handler compatible tips *)
	possibleTips = {
		Model[Item,Tips,"300 uL Hamilton tips, non-sterile"],
		Model[Item,Tips,"300 uL Hamilton barrier tips, sterile"],
		Model[Item,Tips,"300 uL Hamilton barrier tips, wide bore, 1.55mm orifice"],
		Model[Item,Tips,"1000 uL Hamilton tips, non-sterile"],
		Model[Item,Tips,"1000 uL Hamilton barrier tips, sterile"],
		Model[Item,Tips,"1000 uL Hamilton barrier tips, wide bore, 3.2mm orifice"],
		Model[Item,Tips,"50 uL Hamilton tips, non-sterile"],
		Model[Item,Tips,"50 uL Hamilton barrier tips, sterile"],
		Model[Item,Tips,"10 uL Hamilton tips, non-sterile"],
		Model[Item,Tips,"10 uL Hamilton barrier tips, sterile"]
	};

	(* Join any specified tips and known-compatible tips *)
	allTips = Join[possibleTips,specifiedTipTypes];

	(* Construct a single download call to fetch the fields required for downstream logic *)
	downloadPackets = Quiet[
		Download[
			{allSamples,allModels,allContainers,allModelContainers,possibleTips},
			{
				{
					Packet[Container],
					Packet[Container[Model]],
					Packet[Container[Model][{NumberOfWells,Footprint,WellDepth,InternalDepth}]]
				},
				{
					Packet[Deprecated,LiquidHandlerIncompatible,Tablet,TabletWeight,State,PipettingMethod,Ventilated],
					Packet[Products[{Deprecated,ProductModel,Amount,CountPerSample}]]
				},
				{
					Packet[Model],
					Packet[Model[{NumberOfWells,Footprint,WellDepth,InternalDepth}]]
				},
				{Packet[NumberOfWells,Footprint,WellDepth,InternalDepth]},
				{Packet[MaxVolume,WideBore,Filtered,NumberOfTips,MaxStackSize,AspirationDepth]}
			},
			Cache -> (Cache/.safeOptions)
		],
		{Download::MissingField,Download::FieldDoesntExist,Download::NotLinkField}
	];
	
	(* Merge all packets so we can use it as a cache-ball *)
	allPackets = FlattenCachePackets[
		DeleteCases[Flatten[downloadPackets],Null|$Failed]
	];
		
	(* Extract samples' container and specified container packets *)
	uniqueContainerPackets = DeleteDuplicatesBy[
		Join[
			fetchPacketFromCacheHPLC[#,allPackets]&/@((fetchPacketFromCacheHPLC[#,allPackets]&/@Download[allSamples,Object])[[All,Key[Container]]]),
			fetchPacketFromCacheHPLC[#,allPackets]&/@Download[allContainers,Object]
		],
		#[Object]&
	];

	(* All specified samples and container contents packets *)
	uniqueSamplePackets = Map[
		fetchPacketFromCacheHPLC[#,allPackets]&,
		DeleteDuplicates@Download[
			allSamples,
			Object
		]
	];

	(* Handle primitives that have zero amounts. Remove any zero-amounts or set an entire primitive to
	$Failed if all its amounts are 0. Also build tests for all these checks. Return in the form:
	{{primitive or $Failed, tests}..} *)
	nonZeroAmountManipulations = Map[
		Function[primitive,
			(* For the primitive, check if it has zero-amounts *)
			Switch[primitive,
				(* Check Amount key in Transfer primitives *)
				_Transfer,
					Module[
						{amounts,sources,destinations,zeroAmountPositions,trimmedAmounts,fullyRemovedIndices},

						(* Extract key-values *)
						amounts = primitive[Amount];
						sources = primitive[Source];
						destinations = primitive[Destination];

						(* Find any positions where the amount is zero *)
						zeroAmountPositions = Position[amounts,_?PossibleZeroQ,{2}];

						(* Delete positions with 0 amount ie: if an original amount list was {{0,0},{1,0}},
						trimmedAmounts would be {{},{1}} *)
						trimmedAmounts = Delete[amounts,zeroAmountPositions];

						(* Find nested positions for which all amounts were removed.
						Ie: if an original amount list was {{0,0},{1,0}}, trimmedAmounts would be {{},{1}}
						and this would return {1}. *)
						fullyRemovedIndices = Position[trimmedAmounts,{},{1}];

						(* Handle cases where ALL amounts are zero, some amounts are zero, or none are zero *)
						Which[
							(* If all amounts are 0, then we remove this Transfer completely *)
							MatchQ[trimmedAmounts,{{}..}],
								Nothing,
							(* If some amounts are 0, remove those indices from all keys *)
							Length[zeroAmountPositions] > 0,
								Transfer[
									Join[
										{
											Source -> Delete[sources,Join[fullyRemovedIndices,zeroAmountPositions]],
											Destination -> Delete[destinations,Join[fullyRemovedIndices,zeroAmountPositions]],
											Amount -> Delete[amounts,Join[fullyRemovedIndices,zeroAmountPositions]]
										},
										KeyValueMap[
											(* Take first index of positions since all these keys are not nested as deep
											as Source/Destination/Amount *)
											#1 -> Delete[#2,fullyRemovedIndices]&,
											KeyDrop[First[primitive],{Source,Destination,Amount}]
										]
									]
								],
							(* Otherwise, we're all good with the original primitive *)
							True,
								primitive
						]
					],
				(* We only need to worry about the FinalVolume key in FillToVolume primitives *)
				_FillToVolume,
					If[PossibleZeroQ[primitive[FinalVolume]],
						Nothing,
						primitive
					],
				_,
					primitive
			]
		],
		primitivesWithConvertedTransfers
	];

	(* Resolve key values in any Define primitives *)
	manipulationsWithResolvedDefines = Map[
		If[MatchQ[#,_Define],
			resolveDefinePrimitive[#,Cache -> allPackets],
			#
		]&,
		nonZeroAmountManipulations
	];

	(* Extract all Define primitives *)
	resolvedDefinePrimitives = Cases[manipulationsWithResolvedDefines,_Define];

	(* Build association lookup of "Name" -> Define primitive *)
	definedNamesLookup = Association@Flatten@Map[
		{
			(#[Name] -> #),
			If[MatchQ[#[ContainerName],_String],
				#[ContainerName] -> #,
				Nothing
			]
		}&,
		resolvedDefinePrimitives
	];

	(* Split Transfer primitive pipetting steps into multiple pipettings if Amount exceeds specified
	tip size or our max available tip size. (Only split volumes if we're using MicroLiquidHandling).

	Cache required: specified TipType's MaxVolume *)
	splitPrimitiveLists = splitTransfers[#,Cache->allPackets,DefineLookup->definedNamesLookup]&/@manipulationsWithResolvedDefines;

	(* splitTransfers returns nested lists in case it needs to split a transfer into multiple.
	Join them together to build a flat list here. *)
	splitPrimitives = Join@@splitPrimitiveLists;

	(* A "specified" primitive is one that has all auxilary sample/location specification keys populated
	 	Transfer/FillToVolume:
			ResolvedSourceLocation
			ResolvedDestinationLocation
			SourceSample
			DestinationSample
		Incubate/Mix:
			ResolvedSourceLocation
			SourceSample
		Filter:
			ResolvedSourceLocation
			SourceSample
			ResolvedFilterLocation
			ResolvedCollectionLocation

		Cache requires:
		 	sample packets: Container
			*)
	specifiedManipulations = Map[
		specifyManipulation[#,Cache->allPackets,DefineLookup->definedNamesLookup]&,
		splitPrimitives
	];
	
	(* Assume Micro if we're optimizing *)
	scaleToUseForFurtherResolving = MicroLiquidHandling;
	
	(* Use this for large volume storage on the liquid handler decks *)
	defaultOnDeckReservoir = Model[Container,Plate,"id:54n6evLWKqbG"];
	
	expandedRentContainerBools = Table[False,Length[specifiedManipulations]];
	
	allSpecifiedModelPackets = fetchPacketFromCacheHPLC[#,allPackets]&/@Download[allModels,Object];

	(* For the unique sample models involved (these can only be Source(s)), determine what their max amounts are based on product information;
	 	this list must be index-matched with allSpecifiedModelPackets; currently, only do this for Chemical models;
		 use Null to indicate that no max is verifiable. Handle special water case, where we want to pool water requests
		 UNDER a given threshold, but not split large requests (we want to pour these right into the destination from the purifier) *)
	modelMaxAmounts = Map[
		Function[modelPacket,
			Which[
				(* Water *)
				MatchQ[Lookup[modelPacket,Object],WaterModelP],
					If[MatchQ[Lookup[safeOptions,LiquidHandlingScale],MicroLiquidHandling],
						(* Set max volume to volume of robotic reservoir minus its dead volume (200mL - 30mL) *)
						170 Milliliter,
						20 Liter
					],

				(* Tablet model chemicals *)
				MatchQ[modelPacket,PacketP[Model[Sample]] && Lookup[modelPacket,Tablet,Null]],
				Module[{activeProductPackets},

					(* find all the non-Deprecated product packets on file for this model *)
					activeProductPackets=Select[
						Cases[allPackets,ObjectP[Object[Product]]],
						!TrueQ[Lookup[#,Deprecated]]&&MatchQ[Download[Lookup[#,ProductModel],Object],Lookup[modelPacket,Object]]&
					];

					(* if we have no products on file, return Null to indicate we can't put a bound on what the max single sample of this chemical holds *)
					If[MatchQ[activeProductPackets,{}],
						Return[Null,Module]
					];

					(* determine the tablet count of each active product, and take the max *)
					Max[Lookup[#,CountPerSample]&/@activeProductPackets]
				],

				(* Non-tablet model chemicals *)
				MatchQ[modelPacket,PacketP[Model[Sample]]],
					Module[{activeProductPackets,activeKitProductPackets,maxProductVolume},

						(* find all the non-Deprecated and non-kit product packets on file for this model *)
						activeProductPackets=Select[
							Cases[allPackets,ObjectP[Object[Product]]],
							!TrueQ[Lookup[#,Deprecated]]&&MatchQ[Download[Lookup[#,ProductModel],Object],Lookup[modelPacket,Object]]&
						];

						(* find all the non-Deprecated and kit-component product packets on file for this model *)
						activeKitProductPackets=Select[
							Cases[allPackets,ObjectP[Object[Product]]],
							!TrueQ[Lookup[#,Deprecated]]&&MemberQ[Download[Lookup[Lookup[#,KitComponents,{}],ProductModel],Object],Lookup[modelPacket,Object]]&
						];

						(* get the max volume from the product; if we have no products on file, return Null to indicate we can't put a bound on what the max single sample of this chemical holds *)
						maxProductVolume = Which[
								!MatchQ[activeProductPackets,{}],
									(* determine the sample amount of each active product, and take the max *)
									Max[Lookup[#,Amount]&/@activeProductPackets],
								!MatchQ[activeKitProductPackets,{}],
									(* determine the sample amount from the appropriate entry in the KitComponents field of each active product and take the max*)
									Max[Lookup[Select[Flatten[Lookup[#,KitComponents]],MatchQ[Download[Lookup[#,ProductModel],Object],Lookup[modelPacket,Object]]&],Amount]&/@activeKitProductPackets],
								True,
									Null
						];

						If[MatchQ[Lookup[modelPacket,State],Liquid]&&MatchQ[Lookup[safeOptions,LiquidHandlingScale],MicroLiquidHandling],
							If[NullQ[maxProductVolume],
								(* Volume of robotic reservoir minus its dead volume *)
								170 Milliliter,
								Min[170 Milliliter, maxProductVolume]
							],
							maxProductVolume
						]
					],

				(* Other *)
				True,
					If[MatchQ[Lookup[modelPacket,State],Liquid]&&MatchQ[Lookup[safeOptions,LiquidHandlingScale],MicroLiquidHandling],
						(* Volume of robotic reservoir minus its dead volume *)
						170 Milliliter,
						Null
					]
			]
		],
		allSpecifiedModelPackets
	];
	
	(* Generate the required objects lookup that will be used to pick the appropriate resources,
	and resolve the right models in the right places; this action depends heavily on correct tagging
	of container models, water sources, and model sample resources in above steps;
	also create Resource blobs if necessary *)
	requiredObjects = Module[
		{incubatedModels,modelAmountRulesByManipulation,sampleAmountRules,uniqueSampleAmountLookup,modelToRentContainerBoolLookup,
		modelAmountRules,uniqueModelAmountLookup,nonZeroModelAmountLookup,modelResources,taggedModelContainerRentContainerBoolTuples,
		allTags,ftvPrimitives,ftvVolumetricSources,uniqueModelContainerRentContainerTuples,modelContainerResources,emptyContainers,
		sampleResourcePackets,sampleResources},

		(* Generate a list of rules relating any sample model (tagged or untagged) from the manips with the amount of it that is needed *)
		modelAmountRulesByManipulation = Map[
			Switch[#,
				_Transfer,
					Join@@MapThread[
						Switch[#1,
							modelP,
								#1->#2,
							_String,
								(* If tag represents a model, associate the amount with the tag *)
								If[MatchQ[Lookup[definedNamesLookup,#1][Sample],NonSelfContainedSampleModelP],
									#1->#2,
									Nothing
								],
							_,
								Nothing
						]&,
						{#[Source],#[Amount]},
						2
					],
				_FillToVolume,
					Switch[#[Source],
						modelP,
							{#[Source]->#[FinalVolume]},
						_String,
							(* If tag represents a model, associate the amount with the tag *)
							If[MatchQ[Lookup[definedNamesLookup,#[Source]][Sample],NonSelfContainedSampleModelP],
								{#[Source]->#[FinalVolume]},
								{}
							],
						_,
							{}
					],
				_Incubate|_Centrifuge,
					Map[
						Switch[#,
							modelP,
								#->0 Milliliter,
							_String,
								(* If tag represents a model, associate the amount with the tag *)
								If[MatchQ[Lookup[definedNamesLookup,#][Sample],NonSelfContainedSampleModelP],
									#->0 Milliliter,
									Nothing
								],
							_,
								Nothing
						]&,
						#[Sample]
					],
				_Pellet,
					Join@@MapThread[
						Function[{source, supernatantVolume, resuspensionSource, resuspensionVolume},
							{
								(* Create a rule for the source sample. *)
								Switch[source,
									modelP,
										source->supernatantVolume/.{All->0 Milliliter},
									_String,
										(* If tag represents a model, associate the amount with the tag *)
										If[MatchQ[Lookup[definedNamesLookup,source][Sample],NonSelfContainedSampleModelP],
											source->supernatantVolume/.{All->0 Milliliter},
											Nothing
										],
									_,
										Nothing
								],

								(* Create a rule for the resuspension source sample. *)
								Switch[resuspensionSource,
									modelP,
										resuspensionSource->resuspensionVolume/.{All->0 Milliliter},
									_String,
										(* If tag represents a model, associate the amount with the tag *)
										If[MatchQ[Lookup[definedNamesLookup,resuspensionSource][Sample],NonSelfContainedSampleModelP],
											resuspensionSource->resuspensionVolume/.{All->0 Milliliter},
											Nothing
										],
									_,
										Nothing
								]
							}
						],
						{#[Sample],#[SupernatantVolume],#[ResuspensionSource],#[ResuspensionVolume]}
					],
				_,
					{}
			]&,
			specifiedManipulations
		];

		(* Build rules for the amount used of each sample (if primitives use a specific sample) *)
		sampleAmountRules = Flatten@Map[
			Switch[#,
				_Transfer,
					MapThread[
						If[!NullQ[#1],
							#1 -> #2,
							Nothing
						]&,
						{#[SourceSample],#[Amount]},
						2
					],
				_Pellet,
					MapThread[
						{
							If[!NullQ[#1],
								#1 -> #2/.{All->0 Milliliter},
								Nothing
							],
							If[!NullQ[#3],
								#3 -> #4/.{All->0 Milliliter},
								Nothing
							]
						}&,
						{#[SourceSample],#[SupernatantVolume],#[ResuspensionSourceSample],#[ResuspensionVolume]}
					],
				_FillToVolume,
					If[!NullQ[#[SourceSample]],
						#[SourceSample] -> #[FinalVolume],
						Nothing
					],
				_,
					Nothing
			]&,
			specifiedManipulations
		];

		(* Merge the rules into a single lookup indicating the total amount needed of each unique sample *)
		uniqueSampleAmountLookup = Merge[sampleAmountRules,Total];

		(* Any model requests in Incubate primitives must be resolved with a plate *)
		incubatedModels = Join@@Map[
			Map[
				Switch[#,
					modelP,
						#,
					_String,
						(* If tag represents a model *)
						If[MatchQ[Lookup[definedNamesLookup,#][Sample],NonSelfContainedSampleModelP],
							#,
							Nothing
						],
					_,
						Nothing
				]&,
				#[Sample]
			]&,
			Cases[specifiedManipulations,_Incubate]
		];

		(* create a lookup that takes all of the {tag,model} from the above list of {tag,model}->amount and associate with the RentContainer bool for the resource the manip prepares (if any) *)
		modelToRentContainerBoolLookup = Association@DeleteDuplicates@Flatten@MapThread[
			Function[{modAmountRules,rentContainerBool},
				(#->rentContainerBool&)/@modAmountRules[[All,1]]
			],
			{modelAmountRulesByManipulation,expandedRentContainerBools}
		];

		(* flatten the model amount rules so we can merge-group them *)
		modelAmountRules = Flatten[modelAmountRulesByManipulation];

		(* merge the rules into a single lookup indicating the total amount needed of each unique model; this will only merge like-tagged models *)
		uniqueModelAmountLookup = Merge[modelAmountRules,Total];

		(* Delete any models of which we require nothing. If we were to include this, we'd be trying to
		pick samples with 0 volume/mass for no reason. This usually happens if someone defines a "model"
		that is only ever used as a destination (ie: it never needs its own amount to start)  *)
		nonZeroModelAmountLookup = Association@KeyValueMap[
			Function[{tag,amount},
				If[
					(* If the model is a Defined name, but none is required, and its container is defined,
					remove it from this lookup since we only need to pick the container. If the container is not defined,
					we'll pick the model, even though the amount will be 0ul. *)
					And[
						MatchQ[tag,_String],
						QuantityMagnitude[amount] == 0,
						MatchQ[Lookup[definedNamesLookup,tag][Container],ObjectP[]]
					],
					Nothing,
					tag -> amount
				]
			],
			uniqueModelAmountLookup
		];

		(* Before going into the resource prep, need to know which resource are actually sources for a volumetric FtV since we'll insist those to be in a container
		that's easy to access (no hermetics or pumps)*)

		ftvPrimitives = Cases[specifiedManipulations,_FillToVolume];
		ftvVolumetricSources = If[!MatchQ[ftvPrimitives,{}],
			Cases[#[Source]&/@ftvPrimitives,{_Symbol,_}],
			{}
		];

		(* use the lookup to create resources for each of the unique models/tagged models *)
		modelResources = KeyValueMap[
			Function[{sourceModel,totalAmount},
				Module[{modelObject,calculatedAmountToRequest,amountToRequest,containerModelToRequest,rentContainerBool},

					(* isolate just the model if it's tagged *)
					modelObject = Switch[sourceModel,
						_String,
							Lookup[definedNamesLookup,sourceModel][Sample],
						{_Symbol|_String|_Integer,ObjectReferenceP[Model[Sample]]},
							Last[sourceModel],
						_,
							sourceModel
					];

					(* we have a problem if the total amount of a model we need exceeds 250mL (what we can fit in a robot-friendly container)
					 	and the desired liquid handling scale is Micro; this should be pretty hard to manage *)
					If[MatchQ[scaleToUseForFurtherResolving,MicroLiquidHandling]&&totalAmount>250 Milliliter,
						Message[Error::ModelOverMicroMax,sourceModel,totalAmount];
						Message[Error::InvalidInput,myPrimitives];
						Return[$Failed,Module]
					];

					(* determine how much of the model to request; be conscious of the special cases:
					 	- it is water (request differently depending on scale)
						- it is required at the limit of the max amount of a single sample *)
					calculatedAmountToRequest=Which[
						MatchQ[modelObject,WaterModelP]&&MatchQ[scaleToUseForFurtherResolving,MicroLiquidHandling],200 Milliliter,
						MatchQ[modelObject,WaterModelP]&&!VolumeQ[totalAmount],totalAmount,
						MatchQ[modelObject,WaterModelP],Module[{waterVolume},

							(* ask for more, unless it'll put us over the water-in-vessel gathering threshold;
							 	only applicable for manual (bufferbot may need a source over the pour threshold) *)
							waterVolume=Min[totalAmount*1.1,20 Liter];

							(* Scale up to the nearest amount that the purifier dispenses *)
							SelectFirst[Join[{15,50,100,250,500,750,1000},Range[1250,5000,250],Range[6000,20000,1000]]*Milliliter,#>=waterVolume&]
						],

						(* If the amount requested is an integer (tablets), request the exact amount *)
						IntegerQ[totalAmount],totalAmount,

						(* otherwise, we wanna get a little more than we need, unless that'll put us over a max amount *)
						True,Module[{modelMaxAmount,bufferedAmount},

							(* use the previously-assembled model max info to see if we have a known max amount per single sample for this model;
							 	this will be Null if we don't know, or some number *)
							modelMaxAmount=Lookup[AssociationThread[Lookup[allSpecifiedModelPackets,Object],modelMaxAmounts],Download[modelObject,Object]];

							(* add a buffer of 10% to the amount we need, unless that'll put us over the limit *)
							bufferedAmount = If[CompatibleUnitQ[modelMaxAmount,totalAmount],
								(* If totalAmount is less than or equal to the max product amount but the totalAmount with a buffer is greater,
								just request the max product amount, otherwise keep the buffer. *)
								If[totalAmount<=modelMaxAmount<(totalAmount*1.1),
									modelMaxAmount,
									totalAmount*1.1
								],
								totalAmount*1.1
							];

							(* make sure not to bump us out of Micro range by asking for more of a model than can fit in the largest robot container *)
							If[MatchQ[scaleToUseForFurtherResolving,MicroLiquidHandling],
								(* If amount is > 50mL, we're gonna use a robot reservoir.
								In that case, request enough to account for dead volume of the reservoir (30mL) *)
								(* When tagging models, we split requests for the same model at 200mL, so we totalAmount <=200mL *)
								If[
									Or[
										(* If we're incubating, we'll use a reservoir for anything above 10.4mL,
										Will also use reservoir if a define primitive specifically requested it
										Otherwise we'll use a reservoir for anything above 50mL *)
										MemberQ[incubatedModels,sourceModel] && bufferedAmount > 10.4 Milliliter,
										bufferedAmount > 50 Milliliter,
										And[
											MatchQ[sourceModel,_String],
											MatchQ[
												Lookup[definedNamesLookup,sourceModel][Container],
												ObjectP[defaultOnDeckReservoir]
											]
										]
									],
									Min[totalAmount + 30 Milliliter, 200 Milliliter],
									bufferedAmount
								],
								bufferedAmount
							]
						]
					];

					(* Round requests for volume/mass to a resolution that we can actually measure, leave counts alone *)
					amountToRequest = If[And[QuantityQ[calculatedAmountToRequest],Not[MatchQ[modelObject, WaterModelP]]],
						Module[{roundedAmount},
							(* If we need an amount smaller than what we can measure, leave the calculated amount alone *)
							(* Later in the code SM will throw Error::AmountOutOfRange, referring to the specific problematic relations *)
							roundedAmount=AchievableResolution[calculatedAmountToRequest, All, Messages->False];
							If[MatchQ[roundedAmount,$Failed],
								calculatedAmountToRequest,
								roundedAmount
							]
						],
						calculatedAmountToRequest
					];

					(* determine what containers to request the resource in;
					 	anything goes for macro, otherwise use compatible containers for the other methods *)
					containerModelToRequest = Which[
						MemberQ[ftvVolumetricSources,sourceModel],
						PreferredContainer[amountToRequest],
						And[
							MatchQ[sourceModel,_String],
							MatchQ[Lookup[definedNamesLookup,sourceModel][Container],FluidContainerModelP]
						],
							Lookup[definedNamesLookup,sourceModel][Container],
						MatchQ[scaleToUseForFurtherResolving,MicroLiquidHandling]&&MatchQ[modelObject,WaterModelP],
							defaultOnDeckReservoir,
						MatchQ[modelObject,WaterModelP],
							PreferredContainer[amountToRequest, Type -> Vessel],
						(* if we're on bufferbot, we are handling solid transfers in advance, so no need to request a container model *)
						MatchQ[scaleToUseForFurtherResolving,Bufferbot]&&MassQ[amountToRequest],Null,
						MatchQ[scaleToUseForFurtherResolving,MacroLiquidHandling],
							If[Lookup[safeOptions,SamplePreparation]||Lookup[safeOptions,Simulation],
								PreferredContainer[amountToRequest],
								Null
							],
						MatchQ[scaleToUseForFurtherResolving,MicroLiquidHandling],If[MemberQ[incubatedModels,sourceModel],
							PreferredContainer[amountToRequest, LiquidHandlerCompatible -> True, Type -> Plate, All -> False],
							Switch[amountToRequest,
								RangeP[0 Milliliter,50 Milliliter],
									PreferredContainer[amountToRequest, LiquidHandlerCompatible -> True, Type -> Vessel, All -> False],
								_,
									(* Call plate because we'll get back a robot reservoir *)
									PreferredContainer[amountToRequest, LiquidHandlerCompatible -> True, Type -> Plate]
							]
						],
						(* TODO: Thiis is never called... figure out why *)
						True,compatibleSampleManipulationContainers[scaleToUseForFurtherResolving,EngineDefaultOnly->False]
					];

					(* finally we need to know if this resource needs to propagate the REntContainer information from a prepared resource passed by the parent; wemade a lookup for this;
					gotta slashdot since the keys are tuples and Lookup tries to lookup eachof them as individuals *)
					rentContainerBool=sourceModel/.modelToRentContainerBoolLookup;

					(* generate the blob, requesting a container or not depending on if we have any restrictions  *)
					If[NullQ[containerModelToRequest],
						Resource[Name->ToString[Unique[]],Sample->modelObject,Amount->amountToRequest,RentContainer->rentContainerBool],
						Resource[Name->ToString[Unique[]],Sample->modelObject,Amount->amountToRequest,Container->containerModelToRequest,RentContainer->rentContainerBool]
					]
				]
			],
			nonZeroModelAmountLookup
		];

		(* if we failed during generation of any of these resources, pass that failure up here *)
		If[MemberQ[modelResources,$Failed],
			Return[$Failed,Module]
		];

		(* case out all tagged model containers in this manip *)
		allTags = DeleteDuplicates[
			DeleteCases[
				Cases[
					specifiedManipulations,
					Alternatives[
						Alternatives@@Flatten[Keys[definedNamesLookup]],
						{_Symbol|_Integer,ObjectReferenceP[Model[Container]]}
					],
					Infinity
				],
				(* comically, in Filter Macro, we can have {Null, syringe container} in the Syringe key, if filtering with two different filtration types, so need to delete those from this list *)
				{Null,ObjectReferenceP[Model[Container]]}
			]
		];

		(* now get all of the unique container models from the manipulations; these will ALL be tagged (per manipulationsWithTaggedContainers);
		 	need to keep track of if these are RentContainer->True or not; ASSUMES that we aren't crossing the wires w.r.t. rent and same tag *)
		taggedModelContainerRentContainerBoolTuples=Flatten[MapThread[
			Function[{manipulation,rentContainerBool},
				If[MatchQ[manipulation,_Define],
					Nothing,
					Module[{taggedContainerModels},

						(* Extract those tags that define a model container *)
						taggedContainerModels = Map[
							Which[
								MatchQ[#,{_Symbol|_Integer,ObjectReferenceP[Model[Container]]}],
									#,
								And[
									MatchQ[#,_String],
									Or[
										And[
											!MatchQ[Lookup[definedNamesLookup,#][Sample],ObjectP[Model[Sample]]],
											MatchQ[Lookup[definedNamesLookup,#][Container],ObjectP[Model[Container]]]
										],
										And[
											MatchQ[Lookup[definedNamesLookup,#][ContainerName],#],
											MatchQ[Lookup[definedNamesLookup,#][Sample],ObjectP[Model[Sample]]],
											QuantityMagnitude[Lookup[uniqueModelAmountLookup,#,0]] == 0,
											MatchQ[Lookup[definedNamesLookup,#][Container],ObjectP[Model[Container]]]
										]
									]
								],
									#,
								Or[
									(* If tag defines an empty model container (ie: not a sample or model), then include it
									Also if the defined name refers to a ContainerName and the Sample of that define function
									does not need any volume, then we should include this ContainerName/container entry
									since we're not going to pick the model directly (as its required volume is 0).
									This happens if someone specified both Name/Sample and ContainerName/Container but
									the Name is never used as a source (so it doesnt need any volume) but the ContainerName
									is used *)
									And[
										Or[
											!MatchQ[Lookup[definedNamesLookup,#][Sample],ObjectP[Model,Sample]],
											And[
												MatchQ[Lookup[definedNamesLookup,#][ContainerName],#],
												MatchQ[Lookup[definedNamesLookup,#][Sample],ObjectP[Model,Sample]],
												QuantityMagnitude[Lookup[uniqueModelAmountLookup,#,0]] == 0
											]
										],
										MatchQ[Lookup[definedNamesLookup,#][Container],ObjectP[Model[Container]]|{_Symbol|_Integer,ObjectP[Model[Container]]}]
									],
									MatchQ[Lookup[definedNamesLookup,#][Sample],{ObjectP[Model[Container]]|{_Symbol|_Integer,ObjectP[Model[Container]]},WellPositionP}]
								],
									Lookup[definedNamesLookup,#][Container],
								True,
									Nothing
							]&,
							allTags
						];

						(* asssociate into tuples with this manip's index's rent bool *)
						{#,rentContainerBool}&/@taggedContainerModels
					]
				]
			],
			{specifiedManipulations,expandedRentContainerBools}
		],1];

		(* get just the unique pairings of {tag,containerModel} and rentContainerBool *)
		uniqueModelContainerRentContainerTuples=DeleteDuplicatesBy[taggedModelContainerRentContainerBoolTuples,First];

		(* generate resources for each of the unique containers; for Container resources, just use Rent flag *)
		modelContainerResources = Map[
			Switch[#[[1]],
				_String,
					Resource[
						Name -> ToString[Unique[]],
						Sample -> fetchDefineModelContainer[Lookup[definedNamesLookup,#[[1]]],Cache->allPackets],
						Rent -> #[[2]]
					],
				{_Symbol|_Integer,ObjectP[]},
					Resource[
						Name->ToString[Unique[]],
						Sample->Last[#[[1]]],
						Rent->#[[2]]
					],
				_,
					Resource[
						Name->ToString[Unique[]],
						Sample->#[[1]],
						Rent->#[[2]]
					]
			]&,
			uniqueModelContainerRentContainerTuples
		];

		(* we also want to include in RequiredObjects any samples that we already know about, and
		 	any empty container objects. We already know the unique samples from uniqueSamplePackets *)
		emptyContainers = Select[uniqueContainerPackets,MatchQ[Lookup[#,Contents],{}]&];

		(* Do not make RequiredObjects resources for ReadPlate injection samples *)
		sampleResourcePackets = uniqueSamplePackets;

		(* generate resources for the direct samples being picked; this is to ensure that
		 	they will be routed to ResourceThaw if necessary (which only works if there's a resource object) *)
		sampleResources = Map[
			Resource[
				Name -> ToString[Unique[]],
				Sample -> Lookup[#,Object],
				Amount -> Lookup[
					uniqueSampleAmountLookup,
					Lookup[#,Object],
					(* If the sample has a count, first request a count *)
					(* then, If the sample has Mass and not Volume, request a mass, otherwise use volume.
					This is because FRQ downstream will fuck up if the units are not appropriate. *)
					Which[
						MatchQ[Lookup[#, Count], UnitsP[Unit]], 0 Unit,
						MassQ[Lookup[#,Mass]]&&!VolumeQ[Lookup[#,Volume]], 0 Gram,
						True, 0 Milliliter
					]
				]
			]&,
			sampleResourcePackets
		];

		(* generate the full required objects field; multiple in the form {uniqueTag,resource/object};
		 	the tag is either just an object ID or a symbol-tagged object ID *)
		Join[
			Transpose[{Keys[nonZeroModelAmountLookup],Link/@modelResources}],
			Transpose[{uniqueModelContainerRentContainerTuples[[All,1]],Link/@modelContainerResources}],
			Transpose[{sampleResourcePackets[[All,Key[Object]]],Link/@sampleResources}],
			Transpose[{Lookup[emptyContainers,Object,{}],Link[emptyContainers]}]
		]
	];

	(* Build lookup table to conver a container or tagged model to its resource *)
	requiredObjectsLookup = Association[Rule@@@requiredObjects];

	(* Pass to core overload *)
	optimizedPrimitives = optimizePrimitives[
		specifiedManipulations,
		RequiredObjectsLookup->requiredObjectsLookup,
		Cache->allPackets,
		DefineLookup->definedNamesLookup
	];

	(* Remove keys added from specifyManipulation such that the primitives match the input *)
	(Head[#][KeyDrop[
		First[#],
		{
			ResolvedSourceLocation,
			ResolvedDestinationLocation,
			SourceSample,
			DestinationSample,
			ResolvedFilterLocation,
			ResolvedCollectionLocation
		}
	]])&/@optimizedPrimitives
];


(* ::Subsubsection::Closed:: *)
(*optimizePrimitives*)


(* This the minimum number of wells that should be considered for 96-head transfer
NOTE: right now we only allow full plate stamping *)
$MultiProbeHeadThreshold = 96;

(* optimizePrimitives is the core Transfer optimization function that takes in a list of primitives
	and merges pipettings such that all 8 channels are used as often as possible.
	Input: a list of primitives to be optimizes
	Output: a list of optimized primitives (NOTE: length may not match the input primitive list's length)

This function expects input manipulations to:
	- Have all Aliquot/Consolidation primitives converted to Transfer primitives
	- Have "expanded" Transfer key values
	- Have all pipetting steps split by the volume if the Amount exceeds the TipSize's volume
 	- Be "specified" (ie: have their SourceSample, ResolvedSourceLocation, ResolvedDestinationLocation fields populated)
	- Have all pipetting parameters resolved (via resolvePipettingParameters) *)

Options[optimizePrimitives]:={RequiredObjectsLookup->Association[],Cache->{},DefineLookup->Association[]};

optimizePrimitives[myPrimitives:{SampleManipulationP...},ops:OptionsPattern[]]:=Module[
	{cache,defineLookup,requiredObjectsLookup,explodedPrimitives,orderedPrimitiveGroups,idealWellOrder,
	transposed384WellNamesByColumn,orderedPrimitives,splitByVolume,splitBySource,splitByDestination,splitByWells,
	partitionedByLength,merged96HeadPrimitives,allMergedPrimitives,rePartitionedByLength},

	cache = OptionValue[Cache];
	defineLookup = OptionValue[DefineLookup];
	requiredObjectsLookup = OptionValue[RequiredObjectsLookup];

	(* Explode any Transfer primitives that have multiple source/destination/amounts *)
	explodedPrimitives = Join@@Map[
		Function[primitive,
			(* It is safe to use Mix head here because any Mix-NOT-by-pipetting should be converted to incubates *)
			If[MatchQ[primitive,_Transfer|_Mix],
				(Head[primitive]@@#)&/@Transpose@KeyValueMap[
					Function[{key,values},
						Map[
							(key -> {#})&,
							values
						]
					],
					First[primitive]
				],
				{primitive}
			]
		],
		myPrimitives
	];

	(* 96-head needs all volumes to be the same *)
	splitByVolume = Split[
		explodedPrimitives,
		Or[
			And[
				MatchQ[#1,_Transfer],
				MatchQ[#2,_Transfer],
				((#1[Amount][[1]]) == (#2[Amount][[1]]))
			],
			And[
				MatchQ[#1,_Mix],
				MatchQ[#2,_Mix],
				((#1[MixVolume][[1]]) == (#2[MixVolume][[1]]))
			]
		]&
	];

	multiProbeHeadCompatibleResourceQ[myResource:(_Resource|ObjectP[{Model[Container],Object[Container]}])]:=Module[
		{containerModel,containerModelPacket},

		containerModel = Switch[myResource,
			_Resource, fetchResourceContainerModel[myResource,Cache->cache],
			ObjectP[Object[Container]], Lookup[fetchPacketFromCacheHPLC[myResource,cache],Model],
			_, myResource
		];

		If[
			Or[
				!MatchQ[containerModel,ObjectP[Model[Container,Plate]]],
				(* Don't allow 96-head use into filter plates because they will be on a collection plate
				in the LOW PLATE POSITION on the deck which is not currently accessible via the 96-head.  *)
				MatchQ[containerModel,ObjectP[Model[Container,Plate,Filter]]]
			],
			Return[False]
		];

		(* Determine if we're using the magnet position - the 96-head cannot reach this position as of 4-8-22 *)
		(* We are working to change that and this can be removed when that is no longer the case *)
		If[MemberQ[Head/@myPrimitives,MoveToMagnet],
			Return[False]
		];

		containerModelPacket = fetchPacketFromCacheHPLC[containerModel,cache];

		Or[
			MatchQ[containerModel,ObjectP[Model[Container, Plate, "id:54n6evLWKqbG"]]],
			And[
				MatchQ[Lookup[containerModelPacket,Footprint],Plate],
				Or[
					Lookup[containerModelPacket,NumberOfWells] == 96,
					Lookup[containerModelPacket,NumberOfWells] == 384
				]
			]
		]
	];

	(* All sources must have the same source container *)
	splitBySource = Join@@Map[
		Switch[#,
			{_Transfer..},
				Split[
					#,
					Or[
						(* Handles the case where the source location is resolved (ie: the source is a sample) *)
						And[
							MatchQ[#1[ResolvedSourceLocation],{{{ObjectP[{Model[Container],Object[Container]}],_String}..}..}],
							MatchQ[#2[ResolvedSourceLocation],{{{ObjectP[{Model[Container],Object[Container]}],_String}..}..}],
							MatchQ[#1[ResolvedSourceLocation][[All,All,1]],#2[ResolvedSourceLocation][[All,All,1]]],
							And@@Flatten[
								Map[
									(* Take First to strip the link off *)
									multiProbeHeadCompatibleResourceQ,
									#1[ResolvedSourceLocation][[All,All,1]],
									{2}
								]
							]
						],
						(* Handles the cases where the source is a model or model container *)
						And[
							MatchQ[
								#1[Source],
								{{Alternatives[
									(* Defined object *)
									_String,
									(* Tagged object *)
									{_Symbol|_Integer,ObjectP[]}
								]..}..}
							],
							MatchQ[#1[Source],#2[Source]],
							And@@Flatten[
								Map[
									(* Take First to strip the link off *)
									multiProbeHeadCompatibleResourceQ[First@Lookup[requiredObjectsLookup,Key[#]]]&,
									#1[Source],
									{2}
								]
							]
						],
						And[
							MatchQ[
								#1[Source],
								{{Alternatives[
									(* {Defined container, well} tuple *)
									{_String,_String},
									(* {Tagged object, well} tuple *)
									{{_Symbol|_Integer,ObjectP[]},_String}
								]..}..}
							],
							MatchQ[#1[Source][[All,All,1]],#2[Source][[All,All,1]]],
							And@@Flatten[
								Map[
									(* Take First to strip the link off *)
									multiProbeHeadCompatibleResourceQ[First@Lookup[requiredObjectsLookup,Key[#]]]&,
									#1[Source][[All,All,1]],
									{2}
								]
							]
						]
					]&
				],
			{_Mix..},
				Split[
					#,
					Or[
						(* Handles the case where the source location is resolved (ie: the source is a sample) *)
						And[
							MatchQ[#1[ResolvedSourceLocation],{{ObjectP[{Model[Container],Object[Container]}],_String}..}],
							MatchQ[#2[ResolvedSourceLocation],{{ObjectP[{Model[Container],Object[Container]}],_String}..}],
							MatchQ[#1[ResolvedSourceLocation][[All,1]],#2[ResolvedSourceLocation][[All,1]]]
						],
						(* Handles the cases where the source is a model or model container *)
						And[
							MatchQ[
								#1[Sample],
								{Alternatives[
									(* Defined object *)
									_String,
									(* Tagged object *)
									{_Symbol|_Integer,ObjectP[]}
								]..}
							],
							MatchQ[#1[Sample],#2[Sample]],
							And@@Flatten[
								Map[
									(* Take First to strip the link off *)
									multiProbeHeadCompatibleResourceQ[First@Lookup[requiredObjectsLookup,Key[#]]]&,
									#1[Sample]
								]
							]
						],
						And[
							MatchQ[
								#1[Sample],
								{Alternatives[
									(* {Defined container, well} tuple *)
									{_String,_String},
									(* {Tagged object, well} tuple *)
									{{_Symbol|_Integer,ObjectP[]},_String}
								]..}
							],
							MatchQ[#1[Sample][[All,1]],#2[Sample][[All,1]]],
							And@@Flatten[
								Map[
									(* Take First to strip the link off *)
									multiProbeHeadCompatibleResourceQ[First@Lookup[requiredObjectsLookup,Key[#]]]&,
									#1[Sample][[All,1]]
								]
							]
						]
					]&
				],
			_,
				{#}
		]&,
		splitByVolume
	];

	(* All destinations must have the same source container *)
	splitByDestination = Join@@Map[
		(* Don't need to consider Mix because it does not have a Destination *)
		If[MatchQ[#,{_Transfer..}],
			Split[
				#,
				Or[
					(* Handles the case where the source location is resolved (ie: the source is a sample) *)
					And[
						MatchQ[#1[ResolvedDestinationLocation],{{{ObjectP[{Model[Container],Object[Container]}],_String}..}..}],
						MatchQ[#2[ResolvedDestinationLocation],{{{ObjectP[{Model[Container],Object[Container]}],_String}..}..}],
						MatchQ[#1[ResolvedDestinationLocation][[All,All,1]],#2[ResolvedDestinationLocation][[All,All,1]]]
					],
					(* Handles the cases where the source is a model or model container *)
					And[
						MatchQ[
							#1[Destination],
							{{Alternatives[
								(* Defined object *)
								_String,
								(* Tagged object *)
								{_Symbol|_Integer,ObjectP[]}
							]..}..}
						],
						MatchQ[#1[Destination],#2[Destination]],
						And@@Flatten[
							Map[
								(* Take First to strip the link off *)
								multiProbeHeadCompatibleResourceQ[First@Lookup[requiredObjectsLookup,Key[#]]]&,
								#1[Destination],
								{2}
							]
						]
					],
					And[
						MatchQ[
							#1[Destination],
							{{Alternatives[
								(* {Defined container, well} tuple *)
								{_String,_String},
								(* {Tagged object, well} tuple *)
								{{_Symbol|_Integer,ObjectP[]},_String}
							]..}..}
						],
						MatchQ[
							#2[Destination],
							{{Alternatives[
								(* {Defined container, well} tuple *)
								{_String,_String},
								(* {Tagged object, well} tuple *)
								{{_Symbol|_Integer,ObjectP[]},_String}
							]..}..}
						],
						MatchQ[#1[Destination][[All,All,1]],#2[Destination][[All,All,1]]],
						And@@Flatten[
							Map[
								(* Take First to strip the link off *)
								multiProbeHeadCompatibleResourceQ[First@Lookup[requiredObjectsLookup,Key[#]]]&,
								#1[Destination][[All,All,1]],
								{2}
							]
						]
					]
				]&
			],
			{#}
		]&,
		splitBySource
	];

	splitByWells = Join@@Map[
		If[MatchQ[#,{(_Transfer|_Mix)..}],
			Fold[
				If[
					multiProbeCompatibleWellPairingsQ[
						Last[#1],
						#2,
						Cache->cache,
						DefineLookup->defineLookup,
						RequiredObjectsLookup->requiredObjectsLookup
					],
					Append[Most[#1],Append[Last[#1],#2]],
					Append[#1,{#2}]
				]&,
				{{First[#]}},
				Rest[#]
			],
			{#}
		]&,
		splitByDestination
	];

	(* Now we know all sublist transfers have the same volume, same source plate,
	same destination plate, and matching source/dest wells. Now we need to take only those
	that have > $MultiProbeHeadThreshold wells *)
	partitionedByLength = Join@@Map[
		If[Length[#] >= $MultiProbeHeadThreshold,
			PartitionRemainder[#,96],
			{#}&/@#
		]&,
		splitByWells
	];

	(* once we split the groups we now need to split everything that is now less than $MultiProbeHeadThreshold *)
	(* since PartitionRemainder will split the transfer group into multiples if we have over n*96 transfers *)
	(* we only need to expand transfers once and not do it recursively *)
	rePartitionedByLength = Join@@Map[Function[{transferGroup},
		If[And[
			Length[transferGroup] < $MultiProbeHeadThreshold,
			Length[transferGroup]!=1
		],
			{#}&/@transferGroup,
			{transferGroup}
		]
	],
		partitionedByLength];

	(* Merge those transfers than can be merged *)
	merged96HeadPrimitives = Map[
		If[MatchQ[#,{(_Transfer|_Mix)..}]&&Length[#]>1,
			Head[First[#]][
				Append[
					Merge[First/@#,Apply[Join]],
					DeviceChannel -> Table[MultiProbeHead,Length[#]]
				]
			],
			First[#]
		]&,
		rePartitionedByLength
	];

	(* In the form:
		{
			{ transfers...},
			{transfers that must be done next},
			{transfers that must be done next},
			...
		} *)
	orderedPrimitiveGroups = Fold[
		Function[{currentGroups,nextPrimitive},
			Which[
				Length[currentGroups] == 0,
					Append[currentGroups,{nextPrimitive}],
				(* If previous group and this primitive are mixes, they could be merged *)
				And[
					MatchQ[nextPrimitive,_Mix],
					MatchQ[Last[currentGroups],{_Mix..}],
					!MatchQ[nextPrimitive[DeviceChannel],{MultiProbeHead..}]
				],
					Append[
						Most[currentGroups],
						Append[Last[currentGroups],nextPrimitive]
					],
				Or[
					!MatchQ[nextPrimitive,_Transfer],
					!MatchQ[Last[currentGroups],{_Transfer..}],
					MatchQ[nextPrimitive[DeviceChannel],{MultiProbeHead..}]
				],
					Append[currentGroups,{nextPrimitive}],
				True,
					Module[
						{nextSourceValue,nextResolvedSource,nextSource,nextDestinationValue,nextResolvedDestination,
						nextDestination,nonTransferPositions,possibleMergeGroupPositions,conflictingLocationPosition},

						(* Extract raw Source value *)
						nextSourceValue = nextPrimitive[Source][[1]][[1]];

						(* Extract resolved source locations *)
						nextResolvedSource = nextPrimitive[ResolvedSourceLocation][[1]][[1]];

						(* If ResolvedSourceLocation is Null, take the Source value *)
						nextSource = If[NullQ[nextResolvedSource],
							(* If the Source is a straight model, tag it so we know it is unique.
							The tag should already exist when being called from ExperimentSampleManipulation
							but may not if being called from OptimizePrimitives *)
							Switch[nextSourceValue,
								{ObjectP[Model[Container,Plate]],_String},
									{{Unique[],First[nextSourceValue]},Last[nextSourceValue]},
								ObjectP[{Model[Container,Vessel],Model[Container,Cartridge],Model[Container,ReactionVessel],Model[Container,Cuvette],Model[Container,Plate]}],
									{Unique[],nextSourceValue},
								_,
									nextSourceValue
							],
							nextResolvedSource
						];

						(* Extract raw Destination value *)
						nextDestinationValue = nextPrimitive[Destination][[1]][[1]];

						(* Extract resolved destination locations *)
						nextResolvedDestination = nextPrimitive[ResolvedDestinationLocation][[1]][[1]];

						(* If ResolvedDestinationLocation is Null, take the Destination value *)
						nextDestination = If[NullQ[nextResolvedDestination],
							(* If the Source is a straight model, tag it so we know it is unique.
							The tag should already exist when being called from ExperimentSampleManipulation
							but may not if being called from OptimizePrimitives *)
							Switch[nextDestinationValue,
								{ObjectP[Model[Container,Plate]],_String},
									{{Unique[],First[nextDestinationValue]},Last[nextDestinationValue]},
								ObjectP[{Model[Container,Vessel],Model[Container,Cartridge],Model[Container,ReactionVessel],Model[Container,Cuvette],Model[Container,Plate]}],
									{Unique[],nextDestinationValue},
								_,
									nextDestinationValue
							],
							nextResolvedDestination
						];

						nonTransferPositions = Flatten@Position[currentGroups,Except[{_Transfer...}],{1}];

						possibleMergeGroupPositions = If[Length[nonTransferPositions] > 0,
							Range[Max[nonTransferPositions]+1,Length[currentGroups]],
							Length[currentGroups]
						];

						conflictingLocationPosition = SelectFirst[
							Reverse[possibleMergeGroupPositions],
							Function[groupIndex,
								Module[
									{group,groupSourceValues,groupSourceLocations,groupSources,groupDestinationValues,groupDestinationLocations,groupDestinations},

									group = currentGroups[[groupIndex]];

									groupSourceValues = Map[
										#[Source][[1]][[1]]&,
										group
									];

									groupSourceLocations = Map[
										#[ResolvedSourceLocation][[1]][[1]]&,
										group
									];

									(* Note: This is an extremely HOT loop. Doing ObjectP makes it 10X slower (which usually means about 4-5 minutes for large sets of primitives). *)
									groupSources = MapThread[
										If[NullQ[#2],
											Switch[#1,
												{ObjectReferenceP[Model[Container,Plate]]|LinkP[Model[Container,Plate]],_String},
												{{Unique[],First[#1]},Last[#1]},
												Alternatives[
													ObjectReferenceP[{Model[Container,Vessel],Model[Container,Cartridge],Model[Container,ReactionVessel],Model[Container,Cuvette],Model[Container,Plate]}],
													LinkP[{Model[Container,Vessel],Model[Container,Cartridge],Model[Container,ReactionVessel],Model[Container,Cuvette],Model[Container,Plate]}]
												],
												{Unique[],#1},
												_,
												#1
											],
											#2
										]&,
										{groupSourceValues,groupSourceLocations}
									];

									groupDestinationValues = Map[
										#[Destination][[1]][[1]]&,
										group
									];

									groupDestinationLocations = Map[
										#[ResolvedDestinationLocation][[1]][[1]]&,
										group
									];

									(* Note: This is an extremely HOT loop. Doing ObjectP makes it 10X slower (which usually means about 4-5 minutes for large sets of primitives). *)
									groupDestinations = MapThread[
										If[NullQ[#2],
											Switch[#1,
												{ObjectReferenceP[Model[Container,Plate]]|LinkP[Model[Container,Plate]],_String},
												{{Unique[],First[#1]},Last[#1]},
												Alternatives[
													ObjectReferenceP[{Model[Container,Vessel],Model[Container,Cartridge],Model[Container,ReactionVessel],Model[Container,Cuvette],Model[Container,Plate]}],
													LinkP[{Model[Container,Vessel],Model[Container,Cartridge],Model[Container,ReactionVessel],Model[Container,Cuvette],Model[Container,Plate]}]
												],
												{Unique[],#1},
												_,
												#1
											],
											#2
										]&,
										{groupDestinationValues,groupDestinationLocations}
									];

									Or[
										MemberQ[groupDestinations,nextSource],
										MemberQ[groupSources,nextDestination],
										If[
											And[
												MatchQ[nextSource,_String],
												MatchQ[Lookup[defineLookup,nextSource][Sample],{_String,_String}]
											],
											MemberQ[groupDestinations,Lookup[defineLookup,nextSource][Sample]],
											False
										],
										If[
											And[
												MatchQ[nextDestination,_String],
												MatchQ[Lookup[defineLookup,nextDestination][Sample],{_String,_String}]
											],
											MemberQ[groupSources,Lookup[defineLookup,nextDestination][Sample]],
											False
										]
									]
								]
							],
							Min[possibleMergeGroupPositions]-1
						];

						If[Length[currentGroups] >= (conflictingLocationPosition+1),
							ReplacePart[
								currentGroups,
								(conflictingLocationPosition + 1) -> Append[
									currentGroups[[(conflictingLocationPosition + 1)]],
									nextPrimitive
								]
							],
							Append[currentGroups,{nextPrimitive}]
						]
					]
			]
		],
		{},
		merged96HeadPrimitives
	];
	
	(* Assign the transposed 384-well plate well order to a variable since it's 
		slow to compute *)
	transposed384WellNamesByColumn = Transpose[AllWells[NumberOfWells -> 384]];
	
	(* Define ideal well orders for common plate layouts *)
	idealWellOrder[96] = Flatten[Transpose[AllWells[]]];
	idealWellOrder[384] = Flatten[
		With[{oddPositions = Range[1, 15, 2], evenPositions = Range[2, 16, 2]},
			(* For each column, sort odd wells first and even wells last to
				accommodate pipette channel spacing. Can never pipette into adjacent
				wells in a 384-well plate with adjacent pipette channels. *)
			Map[
				Part[#, Join[oddPositions, evenPositions]]&,
				transposed384WellNamesByColumn
			]
		]
	];
	(* For any other number of wells, use 96-well layout *)
	idealWellOrder[_] = idealWellOrder[96];

	orderedPrimitives = Join@@Map[
		Function[group,
			Which[
				And[
					MatchQ[group,{_Transfer..}],
					Length[group] > 1
				],
					Module[
						{groupedByDestinationContainer,orderedByWells},

						(* Gather by destination container in for form:
						{
							{transfers grouped with same destination container},
							{transfers grouped with same destination container},
							...
						} *)
						groupedByDestinationContainer = GatherBy[
							group,
							Function[transfer,
								Module[{destinationValue,resolvedDestination},

									(* Extract raw Destination value *)
									destinationValue = transfer[Destination][[1]][[1]];

									(* Extract resolved destination locations *)
									resolvedDestination = transfer[ResolvedDestinationLocation][[1]][[1]];

									(* If ResolvedDestinationLocation is Null, take the Destination value *)
									If[NullQ[resolvedDestination],
										(* If the Destination is a straight model, tag it so we know it is unique.
										The tag should already exist when being called from ExperimentSampleManipulation
										but may not if being called from OptimizePrimitives *)
										Switch[destinationValue,
											{ObjectP[Model[Container,Plate]],_String},
												{Unique[],First[destinationValue]},
											ObjectP[{Model[Container,Vessel],Model[Container,Cartridge],Model[Container,ReactionVessel],Model[Container,Cuvette],Model[Container,Plate]}],
												{Unique[],destinationValue},
											{_,_String},
												First[destinationValue],
											_,
												destinationValue
										],
										If[MatchQ[resolvedDestination,{_,_String}],
											First[resolvedDestination],
											resolvedDestination
										]
									]
								]
							]
						];

						orderedByWells = Map[
							If[Length[#] > 1,
								Module[
									{destinationContainerModel,destinationNumberOfWells,wellOrder,wellPrimitiveTuples,sortedTuples,splitTuples,
									transposedTuples,orderedTuples},

									wellPrimitiveTuples = MapIndexed[
										Function[{transfer,index},
											Module[{destinationValue,resolvedDestination,well},

												(* Extract raw Destination value *)
												destinationValue = transfer[Destination][[1]][[1]];

												(* Extract resolved destination locations *)
												resolvedDestination = transfer[ResolvedDestinationLocation][[1]][[1]];

												(* If ResolvedDestinationLocation is Null, take the Destination value *)
												well = If[NullQ[resolvedDestination],
													(* If the Destination is a straight model, tag it so we know it is unique.
													The tag should already exist when being called from ExperimentSampleManipulation
													but may not if being called from OptimizePrimitives *)
													If[MatchQ[destinationValue,{_,_String}],
														Last[destinationValue],
														Null
													],
													If[MatchQ[resolvedDestination,{_,_String}],
														Last[resolvedDestination],
														Null
													]
												];

												{well,transfer,index[[1]]}
											]
										],
										#
									];
									
									(* Get the destination container model from the first primitive in the group *)
									destinationContainerModel = First[Flatten[fetchDestinationModelContainers[
										First[#],
										Cache->cache,
										DefineLookup->defineLookup,
										RequiredObjectsLookup->requiredObjectsLookup
									]]];
									
									(* Only attempt to look up number of wells if destination container model
										is an object; this must be done to prevent further errors in cases where
										destinations use Define names that aren't properly defined *)
									destinationNumberOfWells = If[MatchQ[destinationContainerModel, ObjectP[]],
										Lookup[fetchPacketFromCache[destinationContainerModel, cache], NumberOfWells, 96],
										96
									];
									
									wellOrder = idealWellOrder[destinationNumberOfWells];
									
									sortedTuples = SortBy[
										wellPrimitiveTuples,
										{
											First@FirstPosition[wellOrder,#[[1]],{Infinity}]&,
											First@FirstPosition[wellPrimitiveTuples[[All,3]],#[[3]]]&
										}
									][[All,{1,2}]];

									splitTuples = SplitBy[sortedTuples,#[[1]]&];

									transposedTuples = Transpose@Map[
										PadRight[#,Max[Length/@splitTuples]]&,
										splitTuples
									];

									orderedTuples = Join@@Map[
										DeleteCases[#,0]&,
										transposedTuples
									];

									orderedTuples[[All,2]]
								],
								#
							]&,
							groupedByDestinationContainer
						];

						Join@@orderedByWells
					],
				And[
					MatchQ[group,{_Mix..}],
					Length[group] > 1
				],
					Module[
						{groupedBySampleContainer,orderedByWells},

							(* Gather by sample container in for form:
							{
								{transfers grouped with same container},
								{transfers grouped with same container},
								...
							} *)
						groupedBySampleContainer = GatherBy[
							group,
							Function[mix,
								Module[{locationValue,resolvedLocation},

									(* Extract raw Sample value *)
									locationValue = mix[Sample][[1]];

									(* Extract resolved destination locations *)
									resolvedLocation = mix[ResolvedSourceLocation][[1]];

									(* If ResolvedSourceLocation is Null, take the Sample value *)
									If[NullQ[resolvedLocation],
										(* If the Source is a straight model, tag it so we know it is unique.
										The tag should already exist when being called from ExperimentSampleManipulation
										but may not if being called from OptimizePrimitives *)
										Switch[locationValue,
											{ObjectP[Model[Container,Plate]],_String},
												{Unique[],First[locationValue]},
											ObjectP[{Model[Container,Vessel],Model[Container,Cartridge],Model[Container,ReactionVessel],Model[Container,Cuvette],Model[Container,Plate]}],
												{Unique[],locationValue},
											{_,_String},
												First[locationValue],
											_,
												locationValue
										],
										If[MatchQ[resolvedLocation,{_,_String}],
											First[resolvedLocation],
											resolvedLocation
										]
									]
								]
							]
						];

						orderedByWells = Map[
							If[Length[#] > 1,
								Module[
									{sourceContainerModel,sourceNumberOfWells,wellOrder,wellPrimitiveTuples,sortedTuples,splitTuples,
									transposedTuples,orderedTuples},

									wellPrimitiveTuples = Map[
										Function[mix,
											Module[{locationValue,resolvedLocation,well},

												(* Extract raw Sample value *)
												locationValue = mix[Sample][[1]];

												(* Extract resolved source locations *)
												resolvedLocation = mix[ResolvedSourceLocation][[1]];

												(* If ResolvedSourceLocation is Null, take the Sample value *)
												well = If[NullQ[resolvedLocation],
													(* If the Source is a straight model, tag it so we know it is unique.
													The tag should already exist when being called from ExperimentSampleManipulation
													but may not if being called from OptimizePrimitives *)
													If[MatchQ[locationValue,{_,_String}],
														Last[locationValue],
														Null
													],
													If[MatchQ[resolvedLocation,{_,_String}],
														Last[resolvedLocation],
														Null
													]
												];

												{well,mix}
											]
										],
										#
									];

									(* Get the destination container model from the first primitive in the group *)
									sourceContainerModel = First[Flatten[fetchSourceModelContainers[
										First[#],
										Cache->cache,
										DefineLookup->defineLookup,
										RequiredObjectsLookup->requiredObjectsLookup
									]]];
									
									sourceNumberOfWells = Lookup[fetchPacketFromCache[sourceContainerModel, cache], NumberOfWells, 96];
									
									wellOrder = idealWellOrder[sourceNumberOfWells];
									
									sortedTuples = SortBy[wellPrimitiveTuples,First@FirstPosition[wellOrder,#[[1]],{Infinity}]&];

									splitTuples = SplitBy[sortedTuples,#[[1]]&];

									transposedTuples = Transpose@Map[
										PadRight[#,Max[Length/@splitTuples]]&,
										splitTuples
									];

									orderedTuples = Join@@Map[
										DeleteCases[#,0]&,
										transposedTuples
									];

									orderedTuples[[All,2]]
								],
								#
							]&,
							groupedBySampleContainer
						];

						Join@@orderedByWells
					],
				True,
					group
			]
		],
		orderedPrimitiveGroups
	];

	(* Map-Reduce the input list of primitives to a new list of optimized primitives *)
	allMergedPrimitives = Fold[
		Function[{currentPrimitiveList,nextPrimitive},
			Module[
				{nextPrimitiveAssociation,lastPrimitiveAssociation,sourceKey,previousDestinationValues,previousDestinationLocations,
				previousDestinations,nextSourceValues,nextResolvedSources,nextSources,maxSplitIndex,splitIndex,
				mergedIndices,unmergedIndices,mergedPrimitive,unmergedPrimitive,newPrimitiveList},

				(* Extract associations underlying the next and last primitive *)
				nextPrimitiveAssociation = First[nextPrimitive];
				lastPrimitiveAssociation = First@Last[currentPrimitiveList];

				sourceKey = If[MatchQ[Last[currentPrimitiveList],_Transfer],
					Source,
					Sample
				];

				(* If the next primitive is not a Transfer
					or the previous primitive is not a Transfer
					or the previous Transfer primitive is full-up (all 8 channels used)
					or we're not transferring volumes
					or this or the previous transfer uses the 96-head (it has already been optimized above)
				then we can't optimize this one, return early *)
				If[
					Or[
						!MatchQ[nextPrimitive,(_Transfer|_Mix)],
						!MatchQ[Last[currentPrimitiveList],(_Transfer|_Mix)],
						!MatchQ[Head[Last[currentPrimitiveList]],Head[nextPrimitive]],
						MatchQ[Lookup[nextPrimitiveAssociation,DeviceChannel],{MultiProbeHead..}],
						MatchQ[Lookup[lastPrimitiveAssociation,DeviceChannel],{MultiProbeHead..}],
						Length[Lookup[lastPrimitiveAssociation,sourceKey]] == 8,
						If[MatchQ[nextPrimitive,_Transfer],
							Or[
								!MatchQ[Lookup[lastPrimitiveAssociation,Amount],{{VolumeP..}..}],
								!MatchQ[Lookup[nextPrimitiveAssociation,Amount],{{VolumeP..}..}]
							],
							Or[
								!MatchQ[Lookup[lastPrimitiveAssociation,MixVolume],{VolumeP..}],
								!MatchQ[Lookup[nextPrimitiveAssociation,MixVolume],{VolumeP..}]
							]
						]
					],
					Return[Append[currentPrimitiveList,nextPrimitive],Module]
				];

				(* Extract Destination values *)
				previousDestinationValues = If[MatchQ[Last[currentPrimitiveList],_Transfer],
					Join@@Lookup[lastPrimitiveAssociation,Destination],
					{}
				];

				(* Extract destination location values *)
				previousDestinationLocations = If[MatchQ[Last[currentPrimitiveList],_Transfer],
					Join@@Lookup[lastPrimitiveAssociation,ResolvedDestinationLocation],
					{}
				];

				(* If ResolvedDestinationLocation is Null, take the Destination value *)
				previousDestinations = MapThread[
					If[NullQ[#2],
						(* If the Destination is a straight model, tag it so we know it is unique.
						The tag should already exist when being called from ExperimentSampleManipulation
						but may not if being called from OptimizePrimitives *)
						Switch[#1,
							{ObjectP[Model[Container,Plate]],_String},
								{{Unique[],First[#1]},Last[#1]},
							ObjectP[{Model[Container,Vessel],Model[Container,Cartridge],Model[Container,ReactionVessel],Model[Container,Cuvette],Model[Container,Plate]}],
								{Unique[],#1},
							_,
								#1
						],
						#2
					]&,
					{previousDestinationValues,previousDestinationLocations}
				];

				(* Extract raw Source value *)
				nextSourceValues = nextPrimitive[sourceKey];

				(* Extract resolved source locations *)
				nextResolvedSources = nextPrimitive[ResolvedSourceLocation];

				(* If ResolvedSourceLocation is Null, take the Source value *)
				nextSources = MapThread[
					If[NullQ[#2],
						(* If the Source is a straight model, tag it so we know it is unique.
						The tag should already exist when being called from ExperimentSampleManipulation
						but may not if being called from OptimizePrimitives *)
						Switch[#1,
							{ObjectP[Model[Container,Plate]],_String},
								{{Unique[],First[#1]},Last[#1]},
							ObjectP[{Model[Container,Vessel],Model[Container,Cartridge],Model[Container,ReactionVessel],Model[Container,Cuvette],Model[Container,Plate]}],
								{Unique[],#1},
							_,
								#1
						],
						#2
					]&,
					{nextSourceValues,nextResolvedSources}
				];

				(* The maximum index whose sources/destinations we can merge is either the number of manips
				that can fit in the previous transfer or the number of current sources/destinations  *)
				maxSplitIndex = Min[
					8 - Length[Last[currentPrimitiveList][sourceKey]],
					Length[nextSources]
				];

				(* The "split index" is the index at which we can merge previous source/destinations
				into the previous transfer *)
				splitIndex = Fold[
					Function[{currentSplitIndex,index},
						Module[
							{sources},

							(* If the previously determined split index is less than our current index,
							this means we need to split before this index so return previous split index. *)
							If[currentSplitIndex < index,
								Return[currentSplitIndex,Module]
							];

							(* Fetch sources for current index *)
							sources = nextSources[[index]];

							(* If a source is a member of the previous transfer's destinations, we shant merge them
							since hamilton aspirates all probes before dispensing. If we _did_ merge, then we'd be
							aspirating from a source prematurely (before the previous transfer dispenses into it) *)
							If[
								(index <= maxSplitIndex) && AnyTrue[sources,MemberQ[previousDestinations,#]&],
								index - 1,
								currentSplitIndex
							]
						]
					],
					maxSplitIndex,
					Range[Length[nextSources]]
				];

				(* Split the indices that can/cannot be merged *)
				{mergedIndices,unmergedIndices} = {
					Range[Length[nextSources]][[;;(splitIndex)]],
					Range[Length[nextSources]][[(splitIndex+1);;]]
				};

				(* If we're merging any indices, add indices of each key value to the previous Transfer *)
				mergedPrimitive = If[Length[mergedIndices] > 0,
					Head[nextPrimitive][
						Association@Map[
							(* We need to expand any keys that exist in one of the primitives but not the other
							such that the merged primitive index-matches properly. For example if the previous
							primitive has AspirationMix specified but the current one does not, we need to append
							Automatics to the merged primitive.

							NOTE: this should never happen if we're being called from ExperimentSampleManipulation
							since all keys should be resolved by the time we're called. However in OptimizePrimitives,
							the keys may not be resolved. *)
							# -> Join[
								(* If the key exists in the last primitive, take its value, otherwise pad with Automatics *)
								If[KeyExistsQ[lastPrimitiveAssociation,#],
									Lookup[lastPrimitiveAssociation,#],
									Table[Automatic,Length[Lookup[lastPrimitiveAssociation,sourceKey]]]
								],
								If[KeyExistsQ[nextPrimitiveAssociation,#],
									Lookup[nextPrimitiveAssociation,#][[mergedIndices]],
									Table[Automatic,Length[mergedIndices]]
								]
							]&,
							DeleteDuplicates[Join[Keys[lastPrimitiveAssociation],Keys[nextPrimitiveAssociation]]]
						]
					],
					Last[currentPrimitiveList]
				];

				(* Truncate any key values not being merged. If everything is being merged, set to Null. *)
				unmergedPrimitive = If[Length[unmergedIndices] > 0,
					Head[nextPrimitive][
						Association@KeyValueMap[
							Function[{key,value},
								key -> value[[unmergedIndices]]
							],
							nextPrimitiveAssociation
						]
					],
					Null
				];

				(* Join merged primitives (if everything is being merged, unmergedPrimitive will be Null) *)
				Join[
					Most[currentPrimitiveList],
					{
						mergedPrimitive,
						If[NullQ[unmergedPrimitive],
							Nothing,
							unmergedPrimitive
						]
					}
				]
			]
		],
		{First[orderedPrimitives]},
		Rest[orderedPrimitives]
	];

	(* Add DeviceChannel to primitives that don't have it already populated *)
	Map[
		If[
			And[
				MatchQ[#,(_Transfer|_Mix)],
				MissingQ[Lookup[First[#],DeviceChannel]]
			],
			Head[#][
				Append[
					First[#],
					DeviceChannel -> Map[
						probeSymbolForChannel[#]&,
						Range[Length[Lookup[First[#],If[MatchQ[#,_Transfer],Source,Sample]]]]
					]
				]
			],
			#
		]&,
		allMergedPrimitives
	]
];

(* At this point all transfers in sublists have the same volume, same source plate and same destination plate
Now, all transfers need to:
	- have identical source/destination well pairings
	- be a reservoir to plate stamp transfer
	- or be a 384-well stamp pattern to 384-well stamp pattern

	TODO: handle the second two of these alternatives *)

(* We know that the source/destination containers of both transfer are the same.
We can merge the two transfers if:
	- if first and second source/destination well pairs are the same internally but not the same
	as any other wells already being accessed
	-  if the source/destination is a reservoir
	- if the source/destination well pairings are part of a 384 well plate stamping pattern*)
Options[multiProbeCompatibleWellPairingsQ]:={Cache->{},DefineLookup->Association[],RequiredObjectsLookup->Association[]};
multiProbeCompatibleWellPairingsQ[myExistingPrimitives_,myNewPrimitive_,ops:OptionsPattern[]]:=Module[
	{cache,defineLookup,requiredObjectsLookup,newSourceModelContainers,newDestinationModelContainers,sourceKey,
	newSources,newSourceLocations,newSourceWells,newDestinations,newDestinationLocations,newDestinationWells,
	existingSources,existingSourceLocations,existingSourceWells,existingDestinations,existingDestinationLocations,
	existingDestinationWells,allExistingSourceWells,validSourceAdditionQ,allExistingDestinationWells,
	validDestinationAdditionQ},

	cache = OptionValue[Cache];
	defineLookup = OptionValue[DefineLookup];
	requiredObjectsLookup = OptionValue[RequiredObjectsLookup];

	newSourceModelContainers = DeleteCases[
		fetchSourceModelContainers[
			myNewPrimitive,
			Cache->cache,
			DefineLookup->defineLookup,
			RequiredObjectsLookup->requiredObjectsLookup
		],
		Null,
		{2}
	];

	newDestinationModelContainers = If[MatchQ[myNewPrimitive,_Mix],
		Null,
		DeleteCases[
			fetchDestinationModelContainers[
				myNewPrimitive,
				Cache->cache,
				DefineLookup->defineLookup,
				RequiredObjectsLookup->requiredObjectsLookup
			],
			Null,
			{2}
		]
	];

	(* If all source and destination containers are a reservoir, we can for sure combine the transfers *)
	If[
		And[
			MatchQ[myNewPrimitive,_Transfer],
			And@@Flatten[
				MapThread[
					MatchQ[{#1,#2},{ObjectP[Model[Container, Plate, "id:54n6evLWKqbG"]]..}]&,
					{newSourceModelContainers,newDestinationModelContainers},
					2
				]
			]
		],
		Return[True]
	];

	(* We know the previous source/destination wells are valid. We need to check the new transfer's *)

	extractWell[specification_,location_]:=Module[
		{},

		Which[
			MatchQ[location,PlateAndWellP],
				Last[location],
			MatchQ[specification,{_,WellPositionP}],
				Last[specification],
			MatchQ[specification,_String],
				Module[{definePrimitive},

					definePrimitive = Lookup[defineLookup,specification,Null];

					If[NullQ[definePrimitive],
						Return[Null,Module]
					];

					Which[
						MatchQ[definePrimitive[Well],_String],
							definePrimitive[Well],
						MatchQ[definePrimitive[Sample],{_,_String}],
							Last[definePrimitive[Sample]],
						True,
							Null
					]
				],
			True,
				Null
		]
	];

	sourceKey = If[MatchQ[myNewPrimitive,_Transfer],
		Source,
		Sample
	];

	{newSources,newSourceLocations} = If[MatchQ[myNewPrimitive,_Transfer],
		{
			Lookup[First[myNewPrimitive],sourceKey],
			Lookup[
				First[myNewPrimitive],
				ResolvedSourceLocation,
				Table[Null,Length[#]]&/@Lookup[First[myNewPrimitive],sourceKey]
			]
		},
		{
			{#}&/@Lookup[First[myNewPrimitive],sourceKey],
			{#}&/@Lookup[
				First[myNewPrimitive],
				ResolvedSourceLocation,
				Table[Null,Length[Lookup[First[myNewPrimitive],sourceKey]]]
			]
		}
	];

	newSourceWells = MapThread[
		Function[{source,sourceLocation},
			extractWell[source,sourceLocation]
		],
		{newSources,newSourceLocations},
		2
	];

	{newDestinations,newDestinationLocations} = If[MatchQ[myNewPrimitive,_Transfer],
		{
			Lookup[First[myNewPrimitive],Destination],
			Lookup[
				First[myNewPrimitive],
				ResolvedDestinationLocation,
				Table[Null,Length[#]]&/@Lookup[First[myNewPrimitive],Destination]
			]
		},
		{Null,Null}
	];

	newDestinationWells = If[MatchQ[myNewPrimitive,_Transfer],
		MapThread[
			Function[{destination,destinationLocation},
				extractWell[destination,destinationLocation]
			],
			{newDestinations,newDestinationLocations},
			2
		],
		Null
	];

	(* If the source and destination wells for the new transfer are not matching, return False *)
	If[
		And[
			MatchQ[myNewPrimitive,_Transfer],
			!(And@@Flatten[
				MapThread[
					Function[{sourceModelContainer,sourceWell,destinationModelContainer,destinationWell},
						And[
							MatchQ[Lookup[fetchPacketFromCacheHPLC[sourceModelContainer,cache],MultiProbeHeadIncompatible],Except[True]],
							MatchQ[Lookup[fetchPacketFromCacheHPLC[destinationModelContainer,cache],MultiProbeHeadIncompatible],Except[True]],
							Or[
								MatchQ[sourceWell,destinationWell],
								MatchQ[sourceModelContainer,ObjectP[Model[Container, Plate, "id:54n6evLWKqbG"]]],
								MatchQ[destinationModelContainer,ObjectP[Model[Container, Plate, "id:54n6evLWKqbG"]]],
								(* If one of the plates is a 384 well plate, the source/destination well pair must be within
								a distance of 3 rows and 3 wells away *)
								And[
									Lookup[fetchPacketFromCacheHPLC[sourceModelContainer,cache],NumberOfWells] == 384,
									Lookup[fetchPacketFromCacheHPLC[destinationModelContainer,cache],NumberOfWells] == 384,
									AllTrue[
										Abs[
											Subtract@@ConvertWell[
												{sourceWell,destinationWell},
												InputFormat->Position,
												OutputFormat->RowColumnIndex,
												NumberOfWells->384
											]
										],
										(# <= 4)&
									]
								],
								(* If source is a 384 well plate and destination is a 96 well plate, the source/destination
								pairings must be a compatible match where the destination well index corresponds to a
								384 well plate well at that index *)
								And[
									Lookup[fetchPacketFromCacheHPLC[sourceModelContainer,cache],NumberOfWells] == 384,
									Lookup[fetchPacketFromCacheHPLC[destinationModelContainer,cache],NumberOfWells] != 384,
									MemberQ[$validMultiProbe384WellSets[[All,ConvertWell[destinationWell]]],sourceWell]
								],
								And[
									Lookup[fetchPacketFromCacheHPLC[destinationModelContainer,cache],NumberOfWells] == 384,
									Lookup[fetchPacketFromCacheHPLC[sourceModelContainer,cache],NumberOfWells] != 384,
									MemberQ[$validMultiProbe384WellSets[[All,ConvertWell[sourceWell]]],destinationWell]
								]
							]
						]
					],
					{newSourceModelContainers,newSourceWells,newDestinationModelContainers,newDestinationWells},
					2
				]
			])
		],
		Return[False]
	];

	{existingSources,existingSourceLocations} = Transpose@Map[
		If[MatchQ[myNewPrimitive,_Transfer],
			{
				Lookup[First[#],sourceKey],
				Lookup[
					First[#],
					ResolvedSourceLocation,
					Table[Null,Length[#]]&/@Lookup[First[#],sourceKey]
				]
			},
			{
				{#}&/@Lookup[First[#],sourceKey],
				{#}&/@Lookup[
					First[#],
					ResolvedSourceLocation,
					Table[Null,Length[Lookup[First[#],sourceKey]]]
				]
			}
		]&,
		myExistingPrimitives
	];

	existingSourceWells = MapThread[
		Function[{source,sourceLocation},
			extractWell[source,sourceLocation]
		],
		{existingSources,existingSourceLocations},
		3
	];

	{existingDestinations,existingDestinationLocations} = If[MatchQ[myNewPrimitive,_Transfer],
		Transpose@Map[
			{
				Lookup[First[#],Destination],
				Lookup[
					First[#],
					ResolvedDestinationLocation,
					Table[Null,Length[#]]&/@Lookup[First[#],Destination]
				]
			}&,
			myExistingPrimitives
		],
		{Null,Null}
	];

	existingDestinationWells = If[MatchQ[myNewPrimitive,_Transfer],
		MapThread[
			Function[{destination,destinationLocation},
				extractWell[destination,destinationLocation]
			],
			{existingDestinations,existingDestinationLocations},
			3
		],
		Null
	];

	(* Get source list in the form:
		{
			{all wells in first source "cycle" from all previously merged transfers},
			{all wells in second source "cycle" from all previously merged transfers},
			...
		}
	 *)
	allExistingSourceWells = Module[{gatheredByCycle,maxCycles},

		gatheredByCycle = Map[
			Module[{maxSources},
				maxSources = Max[Length/@#];
				DeleteCases[Transpose@Map[PadRight[#,maxSources,Null]&,#],Null,{2}]
			]&,
			existingSourceWells
		];

		maxCycles = Max[Length/@gatheredByCycle];

		DeleteCases[Transpose@PadRight[gatheredByCycle,maxCycles,Null],Null,{2}]
	];

	validSourceAdditionQ = And@@Flatten[
		MapThread[
			Function[{existingWells,modelContainer,newWell},
				Or[
					MatchQ[modelContainer,ObjectP[Model[Container, Plate, "id:54n6evLWKqbG"]]],
					And[
						!MemberQ[existingWells,newWell],
						Or[
							Lookup[fetchPacketFromCacheHPLC[modelContainer,cache],NumberOfWells] == 96,
							AnyTrue[$validMultiProbe384WellSets,SubsetQ[#,Append[existingWells,newWell]]&]
						]
					]
				]
			],
			{allExistingSourceWells,newSourceModelContainers,newSourceWells},
			2
		]
	];

	allExistingDestinationWells = If[MatchQ[myNewPrimitive,_Transfer],
		Module[{gatheredByCycle,maxCycles},

			gatheredByCycle = Map[
				Module[{maxDestinations},
					maxDestinations = Max[Length/@#];
					DeleteCases[Transpose@Map[PadRight[#,maxDestinations,Null]&,#],Null,{2}]
				]&,
				existingDestinationWells
			];

			maxCycles = Max[Length/@gatheredByCycle];

			DeleteCases[Transpose@PadRight[gatheredByCycle,maxCycles,Null],Null,{2}]
		],
		Null
	];

	validDestinationAdditionQ = If[MatchQ[myNewPrimitive,_Transfer],
		And@@Flatten[
			MapThread[
				Function[{existingWells,modelContainer,newWell},
					Or[
						MatchQ[modelContainer,ObjectP[Model[Container, Plate, "id:54n6evLWKqbG"]]],
						And[
							!MemberQ[existingWells,newWell],
							Or[
								Lookup[fetchPacketFromCacheHPLC[modelContainer,cache],NumberOfWells] == 96,
								AnyTrue[$validMultiProbe384WellSets,SubsetQ[#,Append[existingWells,newWell]]&]
							]
						]
					]
				],
				{allExistingDestinationWells,newDestinationModelContainers,newDestinationWells},
				2
			]
		],
		True
	];

	And[validSourceAdditionQ,validDestinationAdditionQ]
];

$validMultiProbe384WellSets:=($validMultiProbe384WellSets=Transpose[PartitionRemainder[Flatten@AllWells[NumberOfWells->384],4]]);

probeSymbolForChannel[myChannelIndex_Integer]:=ToExpression["SingleProbe"<>ToString[myChannelIndex]];

groupPossible96HeadTransfers[myPrimitives_List]:=Module[
	{explodedPrimitives,splitByVolume,splitBySource,splitByDestination,splitByWells,partitionedByLength},

	(* Explode any Transfer primitives that have multiple source/destination/amounts *)
	explodedPrimitives = Join@@Map[
		If[MatchQ[#,_Transfer],
			(Transfer@@#)&/@Transpose@KeyValueMap[
				Function[{key,values},
					Map[
						(key -> {#})&,
						values
					]
				],
				First[#]
			],
			{#}
		]&,
		myPrimitives
	];

	(* 96-head needs all volumes to be the same *)
	splitByVolume = Split[
		explodedPrimitives,
		And[
			MatchQ[#1,_Transfer],
			MatchQ[#2,_Transfer],
			((#1[Amount][[1]]) == (#2[Amount][[1]]))
		]&
	];

	(* All sources must have the same source container *)
	splitBySource = Join@@Map[
		If[MatchQ[#,{_Transfer..}],
			Split[
				#,
				And[
					MatchQ[#1[ResolvedSourceLocation][[1]],{ObjectP[{Model[Container],Object[Container]}],_String}],
					MatchQ[#2[ResolvedSourceLocation][[1]],{ObjectP[{Model[Container],Object[Container]}],_String}],
					MatchQ[#1[ResolvedSourceLocation][[1]][[1]],#2[ResolvedSourceLocation][[1]][[1]]]
				]&
			],
			{#}
		]&,
		splitByVolume
	];

	(* All destinations must have the same source container *)
	splitByDestination = Join@@Map[
		If[MatchQ[#,{_Transfer..}],
			Split[
				#,
				And[
					MatchQ[#1[ResolvedDestinationLocation][[1]],{ObjectP[{Model[Container],Object[Container]}],_String}],
					MatchQ[#2[ResolvedDestinationLocation][[1]],{ObjectP[{Model[Container],Object[Container]}],_String}],
					MatchQ[#1[ResolvedDestinationLocation][[1]][[1]],#2[ResolvedDestinationLocation][[1]][[1]]]
				]&
			],
			{#}
		]&,
		splitBySource
	];

	(* At this point all transfers in sublists have the same volume, same source plate and same destination plate
	Now, all transfers need to:
		- have identical source/destination well pairings
		- be a reservoir to plate stamp transfer
		- or be a 384-well stamp pattern to 384-well stamp pattern

		TODO: handle the second two of these alternatives *)
	splitByWells = Join@@Map[
		If[MatchQ[#,{_Transfer..}],
			Fold[
				If[
					And[
						MatchQ[#2[ResolvedSourceLocation][[1]],{ObjectP[{Model[Container],Object[Container]}],_String}],
						MatchQ[#2[ResolvedDestinationLocation][[1]],{ObjectP[{Model[Container],Object[Container]}],_String}],
						MatchQ[#2[ResolvedSourceLocation][[1]][[2]],#2[ResolvedDestinationLocation][[1]][[2]]],
						(* Make sure the same well isn't already being accessed *)
						!MemberQ[(#[ResolvedSourceLocation][[1]][[2]])&/@Last[#1],#2[ResolvedSourceLocation][[1]][[2]]]
					],
					Append[Most[#1],Append[Last[#1],#2]],
					Append[#1,{#2}]
				]&,
				{{First[#]}},
				Rest[#]
			],
			{#}
		]&,
		splitByDestination
	];

	(* Now we know all sublist transfers have the same volume, same source plate,
	same destination plate, and matching source/dest wells. Now we need to take only those
	that have > $MultiProbeHeadThreshold wells *)
	partitionedByLength = Join@@Map[
		If[Length[#] >= $MultiProbeHeadThreshold,
			PartitionRemainder[#,96],
			{#}&/@#
		]&,
		splitByWells
	];

	(* Merge those transfers than can be merged *)
	Map[
		If[MatchQ[#,{_Transfer..}]&&Length[#]>1,
			Transfer[Merge[First/@#,Apply[Join]]],
			First[#]
		]&,
		partitionedByLength
	]
];



(* ::Subsubsection::Closed:: *)
(*splitMixing*)


splitMixing[myPrimitive_Mix]:=Module[
	{mixVolumes,mixCounts,mixFlowRates,partitionedCounts,partitionedLengths,primitiveAssociation,
	listableMixAssociation,splitValueAssociations},

	(* If this mix primitive is not a mix-by-pipetting, we don't need to split anything *)
	If[!MatchQ[myPrimitive[NumberOfMixes],{_Integer..}],
		Return[{myPrimitive}]
	];

	(* Extract relevant information from primitive *)
	mixVolumes = myPrimitive[MixVolume];
	mixCounts = myPrimitive[NumberOfMixes];
	mixFlowRates = myPrimitive[MixFlowRate];

	(* The hamilton errors if a pipetting step takes longer than 5 minutes. So, we calculate how long
	a mix should take (number of mixes * 2 * volume / flow rate) and split into multiple mixes if necessary.

	IMPORTANT NOTE: this Mix primitive handling assumes that multi-channel pipetting does not exist for Mixes.
	Ie: each individual sample is mixed in separate hamilton instructions. If this changes, then we need to
	split this more intelligently (with a knapsack solver to group multiple mixes such that they take <4min) *)
	partitionedCounts = MapThread[
		Function[{volume,count,flowRate},
			Module[{timePerMix,numberOfMixesLimit},

				(* Calculate the time per mix (one aspiration/dispense) *)
				timePerMix = (volume/flowRate)*2;

				(* Determine the max number of mixes that can be done in 4.5 min to be safe *)
				numberOfMixesLimit = Quotient[4.5 Minute,timePerMix];

				(* Partition the count if needed *)
				QuantityPartition[count,numberOfMixesLimit]
			]
		],
		{mixVolumes,mixCounts,mixFlowRates}
	];

	If[MatchQ[Length/@partitionedCounts,{1..}],
		Return[{myPrimitive}]
	];

	(* Build list of lengths corresponding to the number of mixes we need to split to *)
	partitionedLengths = Length/@partitionedCounts;

	(* Extract underlying association *)
	primitiveAssociation = First[myPrimitive];

	(* Extract listable keys *)
	listableMixAssociation = KeyTake[
		primitiveAssociation,
		{Sample,ResolvedSourceLocation,SourceSample,NumberOfMixes,MixVolume,
		MixFlowRate,MixPosition,MixPositionOffset,CorrectionCurve,TipType,TipSize}
	];

	(* Split key-values into lists of the correct length *)
	splitValueAssociations = (Association/@Transpose[#])&/@(Transpose@KeyValueMap[
		Function[{key,values},
			MapThread[
				Thread[key -> Table[{#2},#1]]&,
				{partitionedLengths,values}
			]
		],
		listableMixAssociation
	]);

	(* Rebuild primitives by adding back the non-listable keys and split counts *)
	Mix/@(Join@@MapThread[
		Function[{coreAssociations,mixCounts},
			MapThread[
				Join[
					primitiveAssociation,
					#1,
					Association[NumberOfMixes -> {#2}]
				]&,
				{coreAssociations,mixCounts}
			]
		],
		{splitValueAssociations,partitionedCounts}
	])
];

splitMixing[myPrimitive_Transfer]:=Module[
	{aspirationMixVolumes,aspirationMixRates,aspirationNumberOfMixes,sources,aspirationMixTimes,
	totalAspirationMixTime,aspirationTimes,totalAspirationTime,dispenseMixVolumes,dispenseMixRates,
	dispenseNumberOfMixes,destinations,dispenseMixTimes,totalDispenseMixTime,dispenseTimes,
	totalDispenseTime,totalPipettingTime},

	(* If no aspiration mix or dispense mix, return early
	If we're using the 96-Head, assume we can do it fast enough *)
	If[
		Or[
			!Or@@Join[myPrimitive[AspirationMix],myPrimitive[DispenseMix]],
			MatchQ[myPrimitive[DeviceChannel],{MultiProbeHead..}]
		],
		Return[{myPrimitive}]
	];

	(* Extract parameters related to aspiration mixing *)
	aspirationMixVolumes = myPrimitive[AspirationMixVolume];
	aspirationMixRates = myPrimitive[AspirationMixRate];
	aspirationNumberOfMixes = myPrimitive[AspirationNumberOfMixes];
	sources = myPrimitive[Source];

	(* Calculate the time for each aspiration mix *)
	aspirationMixTimes = MapThread[
		Function[{volume,flowRate,numberOfMixes,sourceList},
			If[VolumeQ[volume],
				((volume/flowRate)*2*numberOfMixes*Length[sourceList]),
				0 Minute
			]
		],
		{aspirationMixVolumes,aspirationMixRates,aspirationNumberOfMixes,sources}
	];

	(* Total the amount of time required to mix all sources before aspiration *)
	totalAspirationMixTime = Total[aspirationMixTimes];

	(* Calculate the time required to aspiration the sources *)
	aspirationTimes = MapThread[
		Function[{rate,volumes},
			Total[volumes/rate]
		],
		{myPrimitive[AspirationRate],myPrimitive[Amount]}
	];

	(* Total each source's aspiration time *)
	totalAspirationTime = Total[aspirationTimes];

	(* Extract parameters related to dispense mixing *)
	dispenseMixVolumes = myPrimitive[DispenseMixVolume];
	dispenseMixRates = myPrimitive[DispenseMixRate];
	dispenseNumberOfMixes = myPrimitive[DispenseNumberOfMixes];
	destinations = myPrimitive[Destination];

	(* Calculate the time for each dispense mix *)
	dispenseMixTimes = MapThread[
		Function[{volume,flowRate,numberOfMixes,destinationList},
			If[VolumeQ[volume],
				((volume/flowRate)*2*numberOfMixes*Length[destinationList]),
				0 Minute
			]
		],
		{dispenseMixVolumes,dispenseMixRates,dispenseNumberOfMixes,destinations}
	];

	(* Total the amount of time required to mix all sources after dispensing *)
	totalDispenseMixTime = Total[dispenseMixTimes];

	(* Calculate the time required to dispense to the destinations *)
	dispenseTimes = MapThread[
		Function[{rate,volumes},
			Total[volumes/rate]
		],
		{myPrimitive[DispenseRate],myPrimitive[Amount]}
	];

	(* Total each source's dispense time *)
	totalDispenseTime = Total[dispenseTimes];

	(* Total time required to aspiration and dispense *)
	totalPipettingTime = (totalAspirationTime + totalDispenseTime);

	(* If aspiration mix time + dispense mix time + pipetting time > 4.5 min, split into 3 steps *)
	 If[(totalAspirationMixTime + totalDispenseMixTime + totalPipettingTime) > 4.5 Minute,
	 	Module[
			{aspirationMixPrimitives,splitAspirationMixPrimitives,dispenseMixPrimitives,
			splitDispenseMixPrimitives,strippedTransfer},

			(* Split off all Aspiration mixing parameters into its own Mix primitive *)
			aspirationMixPrimitives = Join@@MapThread[
				Function[{sourceList,volume,rate,mixCount,position,positionOffset,correctionCurve,tipType,tipSize},
					If[VolumeQ[volume],
						Map[
							Mix[
								Sample -> {#},
								MixVolume -> {volume},
								NumberOfMixes -> {mixCount},
								MixFlowRate -> {rate},
								MixPosition -> {position},
								MixPositionOffset -> {positionOffset},
								CorrectionCurve -> {correctionCurve},
								TipType -> {tipType},
								TipSize -> {tipSize}
							]&,
							sourceList
						],
						{}
					]
				],
				{
					sources,
					aspirationMixVolumes,
					aspirationMixRates,
					aspirationNumberOfMixes,
					myPrimitive[AspirationPosition],
					myPrimitive[AspirationPositionOffset],
					myPrimitive[CorrectionCurve],
					myPrimitive[TipType],
					myPrimitive[TipSize]
				}
			];

			(* Pass to Mix overload to split if the aspiration mixing is going to itself take too much time *)
			splitAspirationMixPrimitives = Join@@(splitMixing/@aspirationMixPrimitives);

			(* Split off all dispense mixing parameters into its own Mix primitive *)
			dispenseMixPrimitives = Join@@MapThread[
				Function[{sourceList,volume,rate,mixCount,position,positionOffset,correctionCurve,tipType,tipSize},
					If[VolumeQ[volume],
						Map[
							Mix[
								Sample -> {#},
								MixVolume -> {volume},
								NumberOfMixes -> {mixCount},
								MixFlowRate -> {rate},
								MixPosition -> {position},
								MixPositionOffset -> {positionOffset},
								CorrectionCurve -> {correctionCurve},
								TipType -> {tipType},
								TipSize -> {tipSize}
							]&,
							sourceList
						],
						{}
					]
				],
				{
					destinations,
					dispenseMixVolumes,
					dispenseMixRates,
					dispenseNumberOfMixes,
					myPrimitive[DispensePosition],
					myPrimitive[DispensePositionOffset],
					myPrimitive[CorrectionCurve],
					myPrimitive[TipType],
					myPrimitive[TipSize]
				}
			];

			(* Pass to Mix overload to split if the dispense mixing is going to itself take too much time *)
			splitDispenseMixPrimitives = Join@@(splitMixing/@dispenseMixPrimitives);

			(* "Clear" all aspiration/dispense mixing related keys in the original primitive *)
			strippedTransfer = Transfer[
				Append[
					First[myPrimitive],
					{
						AspirationMix -> Table[False,Length[sources]],
						AspirationMixVolume -> Table[Null,Length[sources]],
						AspirationNumberOfMixes -> Table[Null,Length[sources]],
						DispenseMix -> Table[False,Length[destinations]],
						DispenseMixVolume -> Table[Null,Length[destinations]],
						DispenseNumberOfMixes -> Table[Null,Length[destinations]]
					}
				]
			];

			(* Join all split primitives *)
			Join[splitAspirationMixPrimitives,{strippedTransfer},splitDispenseMixPrimitives]
		],
	 	{myPrimitive}
	 ]
];



(* ::Subsubsection::Closed:: *)
(*resolvePipettingParameters*)


(* resolvePipettingParameters resolves all pipetting parameter key-values for primitives
with pipetting parameters.
	Input: primitive with unresolved pipetting parameters
	Output: primitive with resolved pipetting paramets (as well as any other keys)

This function expects input manipulations to be "specified" (ie: have their
SourceSample, ResolvedSourceLocation, ResolvedDestinationLocation fields populated) *)

Options[resolvePipettingParameters]:={
	Cache->{},
	DefineLookup->Association[],
	RequiredObjectsLookup->Association[],
	EmptyDestination -> False
};

resolvePipettingParameters[myManipulation_,ops:OptionsPattern[]]:=Module[
	{cache,manipulationAssociation,numberOfTransfers,sources,destinations,amounts,
	sourceSamples,destinationSamples,destinationLocations,sourceSamplePackets,destinationSamplePackets,
	sourceModels,sourceContainerModels,destinationContainerModels,allAccessedContainerModels,
	expandedParameterAssociation,specifiedMethods,specifiedMethodPackets,specifiedMethodOptionsAssociations,
	defaultDispensePositions,defaultDispensePositionOffsets,defaultAspirationMixRates,defaultAspirationPositions,
	defaultAspirationPositionOffsets,modelPipettingMethods,modelPipettingMethodPackets,defaultMethodParameters,
	uploadPipettingMethodModelOptions,resolvedMethodOptions,resolvedMethodOptionsAssociations,resolvedAspirationPositions,
	expandedEmptyDestinationBools,resolvedDispensePositions,resolvedAspirationPositionOffsets,resolvedDispensePositionOffsets,
	resolvedAspirationMixBools,resolvedDispenseMixBools,defaultAspirationMixVolumes,resolvedAspirationMixVolumes,resolvedAspirationNumberOfMixes,
	defaultDispenseMixVolumes,resolvedDispenseMixVolumes,resolvedDispenseNumberOfMixes,defaultDynamicAspirations,defaultDynamicAspirationBools,resolvedDynamicAspirationBools,
	allResolvedPipettingParameters,overAspirationVolumes,maxVolumesTransferred,specifiedTipTypes,specifiedTipSizes,
	maxVolumesRequired,resolvedTipTypes,resolvedTipSizes,resolvedTipParameters,manipulationType},

	(* Only Transfer, Aliquot, and Consolidation primitives require pipetting
	parameter resolution. If input primitive is not one of these, return it untouched. *)
	If[MatchQ[myManipulation,Except[_Transfer|_Mix]],
		Return[myManipulation]
	];

	(* Extract the cache ball *)
	cache = OptionValue[Cache];

	(* Strip off primitive head so we can work with an association *)
	manipulationAssociation = First[myManipulation];

	numberOfTransfers = Length@If[MatchQ[myManipulation,_Mix],
		Lookup[manipulationAssociation,Sample],
		Lookup[manipulationAssociation,Source]
	];

	(* Depending on the primitive type, extract lists of sources, destinations, amounts,
	source samples, resolved source locations, and resolved destination locations.
	For primitives that have singleton values for any of these fields, wrap them in a list. *)
	{sources,destinations,amounts,sourceSamples,destinationSamples,destinationLocations} = Switch[
		myManipulation,
		_Transfer,
			{
				Lookup[manipulationAssociation,Source],
				Lookup[manipulationAssociation,Destination],
				Lookup[manipulationAssociation,Amount],
				Lookup[manipulationAssociation,SourceSample],
				Lookup[manipulationAssociation,DestinationSample],
				Lookup[manipulationAssociation,ResolvedDestinationLocation]
			},
		_Mix,
			{
				{#}&/@Lookup[manipulationAssociation,Sample],
				{},
				{},
				{#}&/@Lookup[manipulationAssociation,SourceSample],
				{},
				{}
			},
		(* Default to empty lists but this should never happen since we should've
		returned already if primitive head is not relevant to pipetting params *)
		_,
			{{},{},{},{},{}}
	];

	(* Extract packets from source samples, if they exist *)
	sourceSamplePackets = Map[
		fetchPacketFromCacheHPLC[#,cache]&,
		sourceSamples,
		{2}
	];

	(* Extract packets from destination samples, if they exist *)
	destinationSamplePackets = Map[
		fetchPacketFromCacheHPLC[#,cache]&,
		destinationSamples,
		{2}
	];

	(* Extract source models from SourceSample *)
	sourceModels = MapThread[
		Function[{source,sourceSample},
			Which[
				(* If the source sample exists, extract it's model from its packet *)
				MatchQ[sourceSample,ObjectP[Object[Sample]]],
					Download[Lookup[fetchPacketFromCacheHPLC[sourceSample,cache],Model],Object],
				(* If source is a model, take model directly *)
				MatchQ[source,ObjectP[Model[Sample]]],
					source,
				(* If source is a tagged model, take model *)
				And[
					MatchQ[source,_String],
					MatchQ[Lookup[OptionValue[DefineLookup],source][Sample],ObjectP[Model[Sample]]]
				],
					Lookup[OptionValue[DefineLookup],source][Sample],
				(* If source is a tagged model, take model *)
				MatchQ[source,{_,ObjectP[Model[Sample]]}],
					source[[2]],
				(* If SourceSample doesn't exist and source is not a model
				(ie: source is a model container), set to Null *)
				True,
					Null
			]
		],
		{sources,sourceSamples},
		2
	];

	(* Fetch source container models from specified destination. This will be in the form:{{models..}..} *)
	sourceContainerModels = DeleteCases[
		fetchSourceModelContainers[
			myManipulation,
			Cache->cache,
			DefineLookup->OptionValue[DefineLookup],
			RequiredObjectsLookup->OptionValue[RequiredObjectsLookup]
		],
		Null,
		{2}
	];

	(* Fetch destination container models from specified destination. This will be in the form:{{models..}..} *)
	destinationContainerModels = If[MatchQ[myManipulation,_Mix],
		Table[{},Length[sourceContainerModels]],
		DeleteCases[
			fetchDestinationModelContainers[
				myManipulation,
				Cache->cache,
				DefineLookup->OptionValue[DefineLookup],
				RequiredObjectsLookup->OptionValue[RequiredObjectsLookup]
			],
			Null,
			{2}
		]
	];

	(* Join source and destination container models *)
	allAccessedContainerModels = MapThread[
		DeleteDuplicates[Flatten[{#1,#2}]]&,
		{destinationContainerModels,sourceContainerModels}
	];

	(* Expand any specified pipetting parameter values to match the number of transfers within the primitive *)
	expandedParameterAssociation = Association@KeyValueMap[
		Function[{key,value},
			key -> If[!MatchQ[key,CorrectionCurve],
				If[MatchQ[value,_List],
					value,
					Table[value,numberOfTransfers]
				],
				If[MatchQ[value,{{VolumeP,VolumeP}..}],
					Table[value,numberOfTransfers],
					value
				]
			]
		],
		KeyTake[
			manipulationAssociation,
			Join[
				Keys[pipettingParameterSet],
				{Resuspension,TransferType,MixFlowRate,MixPosition,MixPositionOffset}
			]
		]
	];
	
	(* Extract specified tip parameter values defaulting to Automatic *)
	specifiedTipTypes = Lookup[expandedParameterAssociation,TipType,Table[Automatic,numberOfTransfers]];
	specifiedTipSizes = Lookup[expandedParameterAssociation,TipSize,Table[Automatic,numberOfTransfers]];

	(* Extract a explicitly specified pipetting method, defaulting to Null *)
	specifiedMethods = Replace[Lookup[expandedParameterAssociation,PipettingMethod,Table[Null,numberOfTransfers]],Automatic->Null,1];

	(* This uses the definition of fetchPacketFromCacheHPLC in ExperimentHPLC so...
	don't delete that *)
	specifiedMethodPackets = fetchPacketFromCacheHPLC[#,cache]&/@specifiedMethods;

	(* Build an association of pipetting parameters taken from the specified pipetting method *)
	specifiedMethodOptionsAssociations = Map[
		Function[specifiedMethodPacket,
			If[!NullQ[specifiedMethodPacket],
				DeleteCases[
					KeyTake[
						specifiedMethodPacket,
						{
							AspirationRate,
							DispenseRate,
							OverAspirationVolume,
							OverDispenseVolume,
							AspirationWithdrawalRate,
							DispenseWithdrawalRate,
							AspirationEquilibrationTime,
							DispenseEquilibrationTime,
							AspirationMixRate,
							DispenseMixRate,
							AspirationPosition,
							DispensePosition,
							AspirationPositionOffset,
							DispensePositionOffset,
							CorrectionCurve,
							DynamicAspiration
						}
					],
					Null
				],
				Null
			]
		],
		specifiedMethodPackets
	];

	(* "Pre-resolve" dispense position. If not directly specified but the destination is
	a cuvette, dispense 35mm from the bottom of the cuvetter. Otherwise, if Resuspension
	is specified, this means DispensePosition should resolve to 5mm above the bottom.
	Otherwise, let downstream resolution resolve Automatic values. *)
	{defaultDispensePositions,defaultDispensePositionOffsets} = If[MatchQ[myManipulation,_Mix],
		{Table[Automatic,numberOfTransfers],Table[Automatic,numberOfTransfers]},
		Transpose@MapThread[
			Function[{dispensePosition,dispensePositionOffset,resuspensionQ,containerModels},
				Which[
					!MatchQ[dispensePosition,Automatic],
						{dispensePosition,dispensePositionOffset},
					AnyTrue[containerModels,MatchQ[#,ObjectP[Model[Container,Cuvette]]]&],
						{Bottom,35 Millimeter},
					TrueQ[resuspensionQ],
						{Bottom,5 Millimeter},
					True,
					{Automatic,Automatic}
				]
			],
			Append[
				Lookup[
					expandedParameterAssociation,
					{DispensePosition,DispensePositionOffset,Resuspension},
					Table[Automatic,numberOfTransfers]
				],
				destinationContainerModels
			]
		]
	];

	(* If primitive is a Mix, we'll set AspirationMixRate, AspirationPosition,
	and AspirationPositionOffset to the MixFlowRate, MixPosition, and MixPositionOffset
	values respectively in order to resolve all options *)
	{defaultAspirationMixRates,defaultAspirationPositions,defaultAspirationPositionOffsets} = If[
		MatchQ[myManipulation,_Mix],
		Lookup[expandedParameterAssociation,{MixFlowRate,MixPosition,MixPositionOffset},Table[Automatic,numberOfTransfers]],
		Lookup[expandedParameterAssociation,{AspirationMixRate,AspirationPosition,AspirationPositionOffset},Table[Automatic,numberOfTransfers]]
	];

	(* Extract default pipetting methods from sources/source models *)
	modelPipettingMethods = MapThread[
		Function[{sources,models},
			MapThread[
				Function[{source, model},
					Module[{pipettingModelFromObject, pipettingModelFromModel,objectSolvent,pipettingModelFromObjectSolvent,modelSolvent,pipettingModelFromModelSolvent},
						pipettingModelFromObject=Download[Lookup[fetchPacketFromCacheHPLC[source,cache]/.{Null->{}},PipettingMethod, Null],Object];
						pipettingModelFromModel=Download[Lookup[fetchPacketFromCacheHPLC[model,cache]/.{Null->{}},PipettingMethod, Null],Object];

						(* If the Object has a Solvent, get its pipetting method *)
						objectSolvent=Lookup[Replace[fetchPacketFromCacheHPLC[source,cache],Null->{}],Solvent, Null];
						pipettingModelFromObjectSolvent=Download[Lookup[fetchPacketFromCacheHPLC[objectSolvent,cache]/.{Null->{}},PipettingMethod, Null],Object];

						(* If the Model has Solvents, find the solvent with the highest anbundance and get its pipetting method -- this should be updated to better handle mixtures *)
						modelSolvent=Lookup[Replace[fetchPacketFromCacheHPLC[model,cache],Null->{}],Solvent, Null];
						pipettingModelFromModelSolvent=Download[Lookup[fetchPacketFromCacheHPLC[modelSolvent,cache]/.{Null->{}},PipettingMethod, Null],Object];

						(* Favor the pipetting method from the object over the one from the model. *)
						Which[
							MatchQ[pipettingModelFromObject, ObjectP[Model[Method, Pipetting]]],
								pipettingModelFromObject,
							(* Only take from the model if the source isn't an object (define primitive or specifying the model as a source) *)
							!MatchQ[source, ObjectP[Object[Sample]]] && MatchQ[pipettingModelFromModel, ObjectP[Model[Method, Pipetting]]],
								pipettingModelFromModel,
							(* If we still don't have a method, try pulling it from the Object's primary Solvent *)
							MatchQ[pipettingModelFromObjectSolvent, ObjectP[Model[Method, Pipetting]]],
								pipettingModelFromObjectSolvent,
							(* If we still don't have a method, try pulling it from the Model's primary Solvent *)
							MatchQ[pipettingModelFromModelSolvent, ObjectP[Model[Method, Pipetting]]],
								pipettingModelFromModelSolvent,
							True,
								Null
						]
					]
				],
				{sources, models}
			]
		],
		{sourceSamples,sourceModels}
	];

	(* Fetch packet from first pipetting method.
	(TODO: handle case where multiple sources have different default methods) *)
	modelPipettingMethodPackets = fetchPacketFromCacheHPLC[FirstOrDefault[#],cache]&/@modelPipettingMethods;

	(* If a default pipetting method exists, build association with pipetting param
	values from the default method *)
	defaultMethodParameters = Map[
		If[NullQ[#],
			Null,
			DeleteCases[
				KeyTake[
					#,
					{
						AspirationRate,
						DispenseRate,
						OverAspirationVolume,
						OverDispenseVolume,
						AspirationWithdrawalRate,
						DispenseWithdrawalRate,
						AspirationEquilibrationTime,
						DispenseEquilibrationTime,
						AspirationMixRate,
						DispenseMixRate,
						AspirationPosition,
						DispensePosition,
						AspirationPositionOffset,
						DispensePositionOffset,
						CorrectionCurve,
						DynamicAspiration
					}
				],
				Null
			]
		]&,
		modelPipettingMethodPackets
	];


	(* If not directly specified, get it from specified method, otherwise default dynamic aspiration to False *)
	defaultDynamicAspirations=Lookup[expandedParameterAssociation,DynamicAspiration,Table[Automatic,numberOfTransfers]];
	defaultDynamicAspirationBools = MapThread[
		If[MatchQ[#1,BooleanP],
			#1,
			Lookup[Replace[#2,Null->{}],DynamicAspiration,False]
		]&,
		{defaultDynamicAspirations,specifiedMethodOptionsAssociations}
	];

	(* Build association of pipetting parameters to pass in as input to UploadPipettingMethod.
	The inheritance of parameters is important here. If a pipetting method is explicitly specified,
	we start with that, otherwise we start with the model's default pipetting method
	(if neither exists, we start with an empty association). Then we overwrite with any
	directly specified params in the primitive including pre-resolved (defaulted)
	dispense position/offset from shorthand Resuspension key. *)
	uploadPipettingMethodModelOptions = MapThread[
		Function[{index,specifiedMethodOptionsAssociation,defaultMethodParameterAssociation,defaultDispensePosition,defaultDispensePositionOffset,defaultAspirationMixRate,defaultAspirationPosition,defaultAspirationPositionOffset,dynamicAspirationQ,defaultDynamicAspiration,tipType,tipSize},
			DeleteCases[
				Join[
					(* If doing dynamic aspiration then default OverAspiration/DispenseVolume to 1Microliter, If anything else specifies these values they will be overwritten *)
					Which[
						Or[
							MatchQ[
								tipType,
								Alternatives[
									Model[Item,Tips,"10 uL Hamilton tips, non-sterile"],
									Model[Item, Tips, "id:vXl9j5qEnnV7"],
									Model[Item, Tips, "10 uL Hamilton barrier tips, sterile"],
									Model[Item, Tips, "id:P5ZnEj4P884r"]
								]
							],
							MatchQ[tipSize,10 Microliter]
						],
							Association[
								OverAspirationVolume -> 0 Microliter,
								OverDispenseVolume -> 0 Microliter
							],
						dynamicAspirationQ,
							Association[
								OverAspirationVolume->1Microliter,
								OverDispenseVolume->1Microliter
							],
						True,
							Association[]
					],
					If[!NullQ[specifiedMethodOptionsAssociation],
						specifiedMethodOptionsAssociation,
						If[!NullQ[defaultMethodParameterAssociation],
							defaultMethodParameterAssociation,
							Association[]
						]
					],
					(* Delete Automatics since we don't necesarily want to override the specified method's values
					unles we default to something specific (for example, due to Resuspension specification) *)
					DeleteCases[
						Association[
							DispensePosition -> defaultDispensePosition,
							DispensePositionOffset -> defaultDispensePositionOffset,
							AspirationMixRate -> defaultAspirationMixRate,
							AspirationPosition -> defaultAspirationPosition,
							AspirationPositionOffset -> defaultAspirationPositionOffset,
							DynamicAspiration -> defaultDynamicAspiration
						],
						Automatic
					],
					Map[
						#[[index]]&,
						KeyTake[
							expandedParameterAssociation,
							{
								AspirationRate,
								DispenseRate,
								OverAspirationVolume,
								OverDispenseVolume,
								AspirationWithdrawalRate,
								DispenseWithdrawalRate,
								AspirationEquilibrationTime,
								DispenseEquilibrationTime,
								AspirationMixRate,
								DispenseMixRate,
								AspirationPosition,
								DispensePosition,
								AspirationPositionOffset,
								DispensePositionOffset,
								CorrectionCurve
							}
						]
					]
				],
				Automatic
			]
		],
		{
			Range[numberOfTransfers],
			specifiedMethodOptionsAssociations,
			defaultMethodParameters,
			defaultDispensePositions,
			defaultDispensePositionOffsets,
			defaultAspirationMixRates,
			defaultAspirationPositions,
			defaultAspirationPositionOffsets,
			defaultDynamicAspirationBools,
			defaultDynamicAspirations,
			specifiedTipTypes,
			specifiedTipSizes
		}
	];

	(* Use upload function to resolve most of the pipetting parameters. We must quiet
	errors since we check them upstream and throw listed error messages. *)
	resolvedMethodOptions = Map[
		UploadPipettingMethod[Sequence@@Normal[#],Output -> Options]&,
		uploadPipettingMethodModelOptions
	];

	(* If resolution fails, return failed. This failure should not happen and errors
	should be caught upstream by primitive validation. *)
	If[MemberQ[resolvedMethodOptions,$Failed],
		Return[$Failed]
	];

	(* Convert to Association for downstream usage *)
	resolvedMethodOptionsAssociations = Association/@resolvedMethodOptions;

	(* UploadPipettingMethod may not resolve AspirationPosition or DispensePosition
	since it could leave it to us now to resolve based on the container model.
	If this is the case, resolve to LiquidLevel *)
	resolvedAspirationPositions = Map[
		Which[
			(* If we're using the 96-head, resolve to bottom since only a couple of the 96 probes actually LLD *)
			And[
				NullQ[Lookup[#,AspirationPosition]],
				MatchQ[myManipulation[DeviceChannel],{MultiProbeHead..}]
			],
				Bottom,
			NullQ[Lookup[#,AspirationPosition]],
				LiquidLevel,
			True,
				Lookup[#,AspirationPosition]
		]&,
		resolvedMethodOptionsAssociations
	];

	expandedEmptyDestinationBools = If[MatchQ[OptionValue[EmptyDestination],_List],
		OptionValue[EmptyDestination],
		Table[OptionValue[EmptyDestination],Length[resolvedMethodOptionsAssociations]]
	];

	resolvedDispensePositions = MapThread[
		If[NullQ[Lookup[#1,DispensePosition]],
			If[TrueQ[#2],
				Bottom,
				LiquidLevel
			],
			Lookup[#1,DispensePosition]
		]&,
		{resolvedMethodOptionsAssociations,expandedEmptyDestinationBools}
	];

	(* Similarly, AspirationPositionOffset and DispensePositionOffset may not be resolved. Default to 2mm. *)
	resolvedAspirationPositionOffsets = Map[
		If[NullQ[Lookup[#,AspirationPositionOffset]],
			2 Millimeter,
			Lookup[#,AspirationPositionOffset]
		]&,
		resolvedMethodOptionsAssociations
	];
	resolvedDispensePositionOffsets = Map[
		If[NullQ[Lookup[#,DispensePositionOffset]],
			2 Millimeter,
			Lookup[#,DispensePositionOffset]
		]&,
		resolvedMethodOptionsAssociations
	];

	(* If not directly specified and any other aspiration mix parameters are specified,
	resolve to True *)
	resolvedAspirationMixBools = MapThread[
		Function[{aspirationMixQ,mixVolume,numberOfMixes},
			If[MatchQ[aspirationMixQ,BooleanP],
				aspirationMixQ,
				Or[MatchQ[mixVolume,VolumeP],MatchQ[numberOfMixes,_Integer]]
			]
		],
		Lookup[
			expandedParameterAssociation,
			{AspirationMix,AspirationMixVolume,AspirationNumberOfMixes},
			Table[Automatic,numberOfTransfers]
		]
	];

	(* If not directly specified and any other aspiration mix parameters are specified,
	resolve to True *)
	resolvedDispenseMixBools = MapThread[
		Function[{dispenseMixQ,mixVolume,numberOfMixes},
			If[MatchQ[dispenseMixQ,BooleanP],
				dispenseMixQ,
				Or[MatchQ[mixVolume,VolumeP],MatchQ[numberOfMixes,_Integer]]
			]
		],
		Lookup[
			expandedParameterAssociation,
			{DispenseMix,DispenseMixVolume,DispenseNumberOfMixes},
			Table[Automatic,numberOfTransfers]
		]
	];

	(* If mix volume is not specified and AspirationMix is True, mix with either
	the maximum volume allowed in a tip (270ul) or 1/3 the (minimum) volume of the source(s)
	or half the min volumes being transfered *)
	defaultAspirationMixVolumes = If[MatchQ[myManipulation,_Mix],
		Table[Null,numberOfTransfers],
		MapThread[
			Function[{sourcePackets,amountList},
				If[MemberQ[DeleteCases[sourcePackets,Null][[All,Key[Volume]]],VolumeP],
					Min[
						Min[Cases[DeleteCases[sourcePackets,Null][[All,Key[Volume]]],VolumeP]]/3,
						270 Microliter
					],
					Min[Append[amountList/2,270 Microliter]]
				]
			],
			{sourceSamplePackets,amounts}
		]
	];

	(* If not specified, and we're aspirate mixing, use above defaulted value *)
	resolvedAspirationMixVolumes = MapThread[
		Function[{specifiedMixVolume,defaultMixVolume,mixQ},
			If[MatchQ[specifiedMixVolume,VolumeP],
				specifiedMixVolume,
				If[mixQ,
					defaultMixVolume,
					Null
				]
			]
		],
		{
			Lookup[expandedParameterAssociation,AspirationMixVolume,Table[Automatic,numberOfTransfers]],
			defaultAspirationMixVolumes,
			resolvedAspirationMixBools
		}
	];

	(* If not specified and AspirationMix is True, mix 3 times  *)
	resolvedAspirationNumberOfMixes = MapThread[
		Function[{specifiedNumberOfMixes,mixQ},
			If[MatchQ[specifiedNumberOfMixes,_Integer],
				specifiedNumberOfMixes,
				If[mixQ,
					3,
					Null
				]
			]
		],
		{
			Lookup[expandedParameterAssociation,AspirationNumberOfMixes,Table[Automatic,numberOfTransfers]],
			resolvedAspirationMixBools
		}
	];

	(* If mix volume is not specified and DispenseMix is True, mix with either
	the maximum volume allowed in a tip (270ul) or 1/3 the (minimum) volume of the source(s)
	or half the min volumes being transfered *)
	defaultDispenseMixVolumes = If[MatchQ[myManipulation,_Mix],
		Table[Null,numberOfTransfers],
		MapThread[
			Function[{destinationPackets,amountList},
				If[MemberQ[DeleteCases[destinationPackets,Null][[All,Key[Volume]]],VolumeP],
					Min[
						Min[Cases[DeleteCases[destinationPackets,Null][[All,Key[Volume]]],VolumeP]]/3,
						270 Microliter
					],
					Min[Append[amountList/2,270 Microliter]]
				]
			],
			{destinationSamplePackets,amounts}
		]
	];

	(* If not specified, and we're dispense mixing, use above defaulted value *)
	resolvedDispenseMixVolumes = MapThread[
		Function[{specifiedMixVolume,defaultMixVolume,mixQ},
			If[MatchQ[specifiedMixVolume,VolumeP],
				specifiedMixVolume,
				If[mixQ,
					defaultMixVolume,
					Null
				]
			]
		],
		{
			Lookup[expandedParameterAssociation,DispenseMixVolume,Table[Automatic,numberOfTransfers]],
			defaultDispenseMixVolumes,
			resolvedDispenseMixBools
		}
	];

	(* If not specified and DispenseMix is True, mix 3 times  *)
	resolvedDispenseNumberOfMixes = MapThread[
		Function[{specifiedNumberOfMixes,mixQ},
			If[MatchQ[specifiedNumberOfMixes,_Integer],
				specifiedNumberOfMixes,
				If[mixQ,
					3,
					Null
				]
			]
		],
		{
			Lookup[expandedParameterAssociation,DispenseNumberOfMixes,Table[Automatic,numberOfTransfers]],
			resolvedDispenseMixBools
		}
	];

	(* If not specified, DynamicAspiration can be pulled from the resolved method options*)
	resolvedDynamicAspirationBools = MapThread[
		Function[{specifiedDynamicAspiration,methodDynamicAspirationQ},
			If[MatchQ[specifiedDynamicAspiration,BooleanP],
				specifiedDynamicAspiration,
				methodDynamicAspirationQ
			]
		],
		{
			Lookup[expandedParameterAssociation,DynamicAspiration,Table[Automatic,numberOfTransfers]],
			Lookup[resolvedMethodOptions,DynamicAspiration]
		}
	];

	(* Join all parameters resolved with UploadPipettingMethod with
	the parameters resolved directly here. If the manipulation is a mix,
	we used the aspiration parameters to resolve the mix pipetting parameters. *)
	allResolvedPipettingParameters = If[MatchQ[myManipulation,_Mix],
		Association[
			MixPosition -> resolvedAspirationPositions,
			MixPositionOffset -> resolvedAspirationPositionOffsets,
			MixFlowRate -> resolvedMethodOptionsAssociations[[All,Key[AspirationMixRate]]],
			CorrectionCurve -> resolvedMethodOptionsAssociations[[All,Key[CorrectionCurve]]]
		],
		Merge[
			MapThread[
				Function[{methodOptionsAssociation,resolvedDispensePosition,resolvedDispensePositionOffset,resolvedAspirationPosition,resolvedAspirationPositionOffset,resolvedAspirationMixQ,resolvedDispenseMixQ,resolvedAspirationMixVolume,resolvedAspirationNumberOfMixes,resolvedDispenseMixVolume,resolvedDispenseNumberOfMixes,resolvedDynamicAspirationQ},
					Join[
						methodOptionsAssociation,
						Association[
							DispensePosition -> resolvedDispensePosition,
							DispensePositionOffset -> resolvedDispensePositionOffset,
							AspirationPosition -> resolvedAspirationPosition,
							AspirationPositionOffset -> resolvedAspirationPositionOffset,
							AspirationMix -> resolvedAspirationMixQ,
							DispenseMix -> resolvedDispenseMixQ,
							AspirationMixVolume -> resolvedAspirationMixVolume,
							AspirationNumberOfMixes -> resolvedAspirationNumberOfMixes,
							DispenseMixVolume -> resolvedDispenseMixVolume,
							DispenseNumberOfMixes -> resolvedDispenseNumberOfMixes,
							DynamicAspiration -> resolvedDynamicAspirationQ
						]
					]
				],
				{
					resolvedMethodOptionsAssociations,
					resolvedDispensePositions,
					resolvedDispensePositionOffsets,
					resolvedAspirationPositions,
					resolvedAspirationPositionOffsets,
					resolvedAspirationMixBools,
					resolvedDispenseMixBools,
					resolvedAspirationMixVolumes,
					resolvedAspirationNumberOfMixes,
					resolvedDispenseMixVolumes,
					resolvedDispenseNumberOfMixes,
					resolvedDynamicAspirationBools
				}
			],
			Identity
		]
	];

	(* Fetch the OverAspirationVolume since it needs to be taken into account when resolving tips *)
	overAspirationVolumes = Map[
		If[MatchQ[#,VolumeP],
			#,
			0 Microliter
		]&,
		Lookup[allResolvedPipettingParameters,OverAspirationVolume,Table[Automatic,numberOfTransfers]]
	];

	(* Calculate the maximum volume in the manipulation that needs to be transferred *)
	maxVolumesTransferred = Max/@Switch[myManipulation,
		_Transfer,
			Lookup[manipulationAssociation,Amount],
		_Mix,
			{#}&/@Lookup[manipulationAssociation,MixVolume],
		_,
			{{0 Microliter}}
	];

	(* Fetch the max volume tranferred including mix volumes and over aspiration volumes *)
	maxVolumesRequired = MapThread[
		Max@Cases[
			Flatten[{#1,#2,Flatten[#3] + #4}],
			VolumeP
		]&,
		{
			Lookup[allResolvedPipettingParameters,AspirationMixVolume,Table[Null,numberOfTransfers]],
			Lookup[allResolvedPipettingParameters,DispenseMixVolume,Table[Null,numberOfTransfers]],
			maxVolumesTransferred,
			overAspirationVolumes
		}
	];

	(* Possible specifications:
		- TipType specified as an object
		- TipSize specified, TipType not specified
		- TipType specified, TipSize not specified
		- TipType specified, TipSize specified
		- TipType and TipSize not specified
	 *)
	resolvedTipTypes = MapThread[
		Function[{specifiedTipType,specifiedTipSize,maxVolumeRequired,accessedContainerModels},
			Which[
				(* TipType is a model *)
				MatchQ[specifiedTipType,ObjectP[]],
					specifiedTipType,
				(* TipSize is specified, TipType either specified or not *)
				MatchQ[specifiedTipSize,VolumeP],
					Switch[{specifiedTipType,specifiedTipSize},
						(* TipSize is 300ul and TipType is Normal or unspecified *)
						{Normal|Except[TipTypeP],_?((#==300 Microliter)&)},
							Model[Item,Tips,"300 uL Hamilton tips, non-sterile"],
						(* Barrier, 300ul tips *)
						{Barrier,_?((#==300 Microliter)&)},
							Model[Item,Tips,"300 uL Hamilton barrier tips, sterile"],
						(* WideBore, 300ul tips *)
						{WideBore,_?((#==300 Microliter)&)},
							Model[Item,Tips,"300 uL Hamilton barrier tips, wide bore, 1.55mm orifice"],
						(* TipSize is 1000ul and TipType is Normal or unspecified *)
						{Normal|Except[TipTypeP],_?((#==1000 Microliter)&)},
							Model[Item,Tips,"1000 uL Hamilton tips, non-sterile"],
						(* Barrier, 1000ul tips *)
						{Barrier,_?((#==1000 Microliter)&)},
							Model[Item,Tips,"1000 uL Hamilton barrier tips, sterile"],
						(* WideBore, 1000ul tips *)
						{WideBore,_?((#==1000 Microliter)&)},
							Model[Item,Tips,"1000 uL Hamilton barrier tips, wide bore, 3.2mm orifice"],
						(* TipSize is 50ul and TipType is Normal or unspecified *)
						{Normal|Except[TipTypeP],_?((#==50 Microliter)&)},
							If[TrueQ[$50uLTipShortage],
								(* ECL doesn't currently stock non-barrier sterile tips *)
								Model[Item,Tips,"50 uL Hamilton barrier tips, sterile"],
								Model[Item,Tips,"50 uL Hamilton tips, non-sterile"]
							],
						(* Barrier, 50ul tips *)
						{Barrier,_?((#==50 Microliter)&)},
							Model[Item,Tips,"50 uL Hamilton barrier tips, sterile"],
						(* TipSize is 10ul and TipType is Normal or unspecified *)
						{Normal|Except[TipTypeP],_?((#==10 Microliter)&)},
							Model[Item,Tips,"10 uL Hamilton tips, non-sterile"],
						(* Barrier, 10ul tips *)
						{Barrier,_?((#==10 Microliter)&)},
							Model[Item,Tips,"10 uL Hamilton barrier tips, sterile"],
						(* There are no WideBore 50ul or 10ul tips (catch error elsewhere) *)
						_,
							Null
					],
				(* TipType is TipTypeP and TipSize is not specified *)
				MatchQ[specifiedTipType,TipTypeP],
					Switch[{specifiedTipType,maxVolumeRequired},
						(* If the volume required is > 300ul, use 1000ul tips *)
						{Normal,_?((# > maximumAspirationVolume[300 Microliter])&)},
							Model[Item,Tips,"1000 uL Hamilton tips, non-sterile"],
						{Barrier,_?((# > maximumAspirationVolume[300 Microliter])&)},
							Model[Item,Tips,"1000 uL Hamilton barrier tips, sterile"],
						{WideBore,_?((# > maximumAspirationVolume[300 Microliter])&)},
							Model[Item,Tips,"1000 uL Hamilton barrier tips, wide bore, 3.2mm orifice"],
						(* If the volume required is > 50ul, use 300ul tips *)
						{Normal,_?((# > maximumAspirationVolume[50 Microliter])&)},
							Model[Item,Tips,"300 uL Hamilton tips, non-sterile"],
						{Barrier,_?((# > maximumAspirationVolume[50 Microliter])&)},
							Model[Item,Tips,"300 uL Hamilton barrier tips, sterile"],
						{WideBore,_?((# > maximumAspirationVolume[50 Microliter])&)},
							Model[Item,Tips,"300 uL Hamilton barrier tips, wide bore, 1.55mm orifice"],
						(* Otherwise use 50ul tips. NOTE: We don't consider 10ul tips here since they are
						basically incompatible with all labware. If they specify it directly, so be it. *)
						{Normal,_},
							(* If we're in a 50ul shortage, use 300ul *)
							If[TrueQ[$50uLTipShortage],
								Model[Item,Tips,"300 uL Hamilton tips, non-sterile"],
								Model[Item,Tips,"50 uL Hamilton tips, non-sterile"]
							],
						{Barrier,_},
							Model[Item,Tips,"50 uL Hamilton barrier tips, sterile"],
						(* There are no WideBore 10ul or 50ul tips so use 300ul *)
						{WideBore,_},
							Model[Item,Tips,"300 uL Hamilton barrier tips, wide bore, 1.55mm orifice"],
						_,
							Null
					],
				(* Nothing specified *)
				True,
					Which[
						And[
							maxVolumeRequired > maximumAspirationVolume[300 Microliter],
							(* 1000ul tips cannot fit in some vessels *)
							And@@(tipsReachContainerBottomQ[
								Download[Model[Item,Tips,"1000 uL Hamilton tips, non-sterile"],Object],
								fetchPacketFromCacheHPLC[#,cache],
								{fetchPacketFromCacheHPLC[Download[Model[Item,Tips,"1000 uL Hamilton tips, non-sterile"],Object],cache]}
							]&/@accessedContainerModels)
						],
							Model[Item,Tips,"1000 uL Hamilton tips, non-sterile"],
						And[
							maxVolumeRequired <= maximumAspirationVolume[50 Microliter],
							(* Only default to 50ul tips if we're not in a shortage *)
							!TrueQ[$50uLTipShortage],
							(* Some vessels require using at least 300ul tips to reach the bottom *)
							And@@(tipsReachContainerBottomQ[
								Download[Model[Item,Tips,"50 uL Hamilton tips, non-sterile"],Object],
								fetchPacketFromCacheHPLC[#,cache],
								{fetchPacketFromCacheHPLC[Download[Model[Item,Tips,"50 uL Hamilton tips, non-sterile"],Object],cache]}
							]&/@accessedContainerModels)
						],
							Model[Item,Tips,"50 uL Hamilton tips, non-sterile"],
						(* NOTE: We don't consider 10ul tips here since they are basically incompatible with all labware.
						If they specify it directly, so be it. *)
						True,
							Model[Item,Tips,"300 uL Hamilton tips, non-sterile"]
					]
			]
		],
		{specifiedTipTypes,specifiedTipSizes,maxVolumesRequired,allAccessedContainerModels}
	];

	(* Fetch TipSize of resolved tip *)
	resolvedTipSizes = Map[
		If[!NullQ[#],
			Lookup[fetchPacketFromCacheHPLC[#,cache],MaxVolume],
			Null
		]&,
		resolvedTipTypes
	];

	(* Join resolved tip parameters *)
	resolvedTipParameters = Association[
		TipType -> resolvedTipTypes,
		TipSize -> resolvedTipSizes
	];

	(* Strip off head of primitive *)
	manipulationType = Head[myManipulation];

	(* Append resolved pipetting parameters to all primitive parameters,
	reconstruct primitive with original head and return *)
	manipulationType[
		Join[
			manipulationAssociation,
			allResolvedPipettingParameters,
			resolvedTipParameters
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*maximumAspirationVolume*)


(* We restrict the amount the hamilton will aspirate into a tip so it doesnt get liquid in its probes.
(This may deserve to be in a field but we'll leave it here for now).

Input: tip model packet that includes MaxVolume field or a volume
Output: the maximum aspirate-able volume *)
maximumAspirationVolume[myTipModelPacket:PacketP[]]:=Module[
	{tipMaxVolume},

	(* Extract tip's nominal max volume *)
	tipMaxVolume = Lookup[myTipModelPacket,MaxVolume];

	(* Call core overload *)
	maximumAspirationVolume[tipMaxVolume]
];

(* Core overload *)
maximumAspirationVolume[myNominalTipMaxVolume_]:=Module[
	{},

	(* Lookup the max aspiration volume *)
	Switch[myNominalTipMaxVolume,
		10 Microliter,
			9 Microliter,
		50 Microliter|55 Microliter,
			45 Microliter,
		300 Microliter|355 Microliter|395 Microliter,
			270 Microliter,
		1000 Microliter|1060 Microliter|1245 Microliter,
			970 Microliter,
		(* This case means we don't know this tip type/size. So assume its max is its nominal amount. *)
		_,
			myNominalTipMaxVolume
	]
];







(* ::Subsubsection:: *)
(*ImportSampleManipulation*)

(* Define Options *)
DefineOptions[ImportSampleManipulation,
	Options:>{
		{
			OptionName->ReadDirection,
			Default->Row,
			Description->"Specifies whether the primitives will be generated row by row or column by column.",
			ResolutionDescription->"Automatically resolves to generating primitives row by row.",
			AllowNull->False,
			Widget->Widget[Type->Expression,Pattern:>RowColumnP,Size->Line]
		}
	}
];

(* Define Messages *)
Error::InvalidFormat="The format of the input is not valid. Please run ValidImportSampleManipulationQ to determine why.";

(* Main Singleton Overloads *)
(* CloudFile *)
ImportSampleManipulation[myCloudFile:ObjectP[Object[EmeraldCloudFile]],myOptions:OptionsPattern[]]:=First[ImportSampleManipulation[{myCloudFile},myOptions]];

(* File Path *)
ImportSampleManipulation[myFilePath:FilePathP,myOptions:OptionsPattern[]]:=First[ImportSampleManipulation[{myFilePath},myOptions]];

(* Raw Data *)
ImportSampleManipulation[myData:{{(_String|NumericP|BooleanP)..}..},myOptions:OptionsPattern[]]:=First[ImportSampleManipulation[{myData},myOptions]];

(* Mixed Listable Overload *)
ImportSampleManipulation[myMixedList:{Alternatives[ObjectP[Object[EmeraldCloudFile]],FilePathP,{{(_String|NumericP|BooleanP)..}..}]..},myOptions:OptionsPattern[]]:=Module[
	{
		convertFunc
	},
	convertFunc=Function[{input},
		Switch[input,
			ObjectP[Object[EmeraldCloudFile]],ImportCloudFile[input],
			(* For MM > 12.0, "XLSX" needs to be specified *)
			FilePathP,Import[input, "XLSX"],
			{{(_String|NumericP|BooleanP)..}..},input
		]
	];
	Map[Function[{convertedData},ImportSampleManipulation[convertedData,myOptions]],convertFunc/@myMixedList]
];

(* Main Listable Overload *)
ImportSampleManipulation[myDataList:{{{(_String|NumericP|BooleanP)..}..}..},myOptions:OptionsPattern[]]:=Module[
	{
		generateManips,listedOptions,safeOptions,readDirection,possibleWellPositions,generateMainManips,generateSimpleManips
	},

	(* Get the options into a listed form *)
	listedOptions=ToList[myOptions];

	(* Get the safe options *)
	safeOptions=SafeOptions[ImportSampleManipulation,listedOptions];

	(* Extract the ReadDirection option *)
	readDirection=Lookup[safeOptions,ReadDirection];

	(* Define possible well labels *)
	(* Possible Well Positions *)
	possibleWellPositions=Flatten[
		Transpose[
			Table[
				ToUpperCase[FromLetterNumber[x]] <> ToString[y],
				{x,1,8},
				{y,1,12}
			]
		]
	];

	generateMainManips=Function[{cleanedRows,cleanedCols},
		Module[
			{
				indexColumn,withIndexReference,columnSymbols,heads,extendedHeads,withExtendedHeads,plateNumberPosition,
				resolvedPlateNumber,withPlateNumber,updatedHeads,updatedPlateNumberPosition,updatedRows,gatheredByPlate,
				headerRows,gathered,withWellPositions,modelsAndDefPrimitives,withPlateModels,definePlatePrimitives,
				resolvedTransposed,resolvedFlattened,resolvedSorted,resolvedData,withoutReferenceIndices,finalHeads,
				finalWellPosition,finalPlateDefPosition,splitPrimitives,primitiveData,primitiveHeads,headAssociations,
				finalWellPositions,finalPlateDefinitions,wellAndPlateAssociations,combinedAssociations,orientedAssociations,
				genericPrimitiveGenerators,primitives,cleanedPrimitives,defaultWellNameColumn,withWellNames,finalWellNamePosition,
				finalWellNames,definedWellPrimitives,cleanedWellDefinitions

			},

			(* Add indexing reference column *)
			indexColumn=Range[Length[cleanedRows]];
			withIndexReference=Prepend[cleanedCols,indexColumn];

			(* Convert the Objects from strings *)
			columnSymbols=Quiet[Map[
				If[StringMatchQ[ToString[#], Alternatives["Object" ~~ ___ , "Model" ~~ ___]],
					ToExpression[#],
					#
				]&,
				withIndexReference,
				{2}
			],{ToExpression::sntx}];

			(* Get the heads *)
			heads=columnSymbols[[2;;,1]];

			(* Extend column headers which allow for options *)
			extendedHeads=Prepend[Rest[
				FoldList[
					Switch[#2,
						Except[""], #2,
						"", If[StringMatchQ[#1, ___ ~~ " Option"], #1, #1 ~~ " Option"]
					]&,
					"",
					heads
				]
			],1];

			(* Replace original heads with extended heads *)
			withExtendedHeads=Transpose[ReplacePart[Transpose[columnSymbols],1->extendedHeads]];

			(* Get position of Plate Number head if it exists *)
			plateNumberPosition=Flatten[Position[extendedHeads,"Plate Number"]];

			(* Resolve Plate Number column*)
			resolvedPlateNumber=If[MemberQ[extendedHeads,"Plate Number"],
				withExtendedHeads[[plateNumberPosition]],
				Join[{"Plate Number","",""},Repeat[1,Length[cleanedRows]-3]]
			];

			(* Add Plate number column if not there already *)
			withPlateNumber=If[MemberQ[extendedHeads,"Plate Number"],
				withExtendedHeads,
				Insert[withExtendedHeads,resolvedPlateNumber,2]
			];

			(* Get the updated plate number position *)
			updatedHeads=withPlateNumber[[All,1]];
			updatedPlateNumberPosition=Flatten[
				Position[
					updatedHeads,"Plate Number"
				]
			];

			(* Transpose the data with plate number to be able to gather by plate *)
			updatedRows=Transpose[withPlateNumber];

			(* Gather the rows by plate number to be able to resolve well labels and plate model *)
			gatheredByPlate=Gather[updatedRows[[4;;]],#1[[updatedPlateNumberPosition]]==#2[[updatedPlateNumberPosition]]&];

			(* Get the rows which are the headers *)
			headerRows=updatedRows[[1;;3]];

			(* Add the header rows back for each plate *)
			gathered=Transpose[Join[headerRows,#1]]&/@gatheredByPlate;

			(* Resolve Wells *)
			withWellPositions=
				Function[{plate},
					Module[{defaultWellPositions,defaultWellColumn},

						(* Define default well positions based on the length of the column *)
						defaultWellPositions=possibleWellPositions[[1;;(Length[First[plate]]-3)]];

						(* Add the well position header *)
						defaultWellColumn=Join[{"Well","",""},defaultWellPositions];

						(* Add the well position column if it is not already there *)
						If[MemberQ[updatedHeads,"Well"],
							plate,
							Insert[plate,defaultWellColumn,2]
						]
					]
				]/@gathered;

			(* Resolved Plate Model *)
			modelsAndDefPrimitives=Map[
				Function[{plate},
					Module[{plateNumberPos,plateNumber,plateName,plateModelPosition,resolvedPlateModel,definePrimitive,
						nameColumn,plateModelColumn,readPlateStartPositions,readPlateTypes,resolvedReadPlateType,fluoresceneReadP,alphaScreenP},

						(* Get the position of the plate number column *)
						plateNumberPos=Flatten[
							Position[
								plate[[All,1]],
								"Plate Number"
							]
						];

						(* Get plate number *)
						plateNumber=Last[Last[plate[[plateNumberPos]]]];

						(* define plate name based on plateNumber *)
						plateName=If[MatchQ[plateNumber,GreaterP[0.,1.]],
							"Plate "<>ToString[plateNumber],
							plateNumber
						];

						(* Get the position of the plate model column if it exists *)
						plateModelPosition=Flatten[
							Position[
								plate[[All,1]],
								"Plate Model"
							]
						];

						(* Get the position of the ReadPlate primitive head if it exists *)
						readPlateStartPositions=Flatten[
							Position[
								plate[[All,1]],
								"ReadPlate"
							]
						];

						(* Get ReadPlate Type for each ReadPlate call *)
						readPlateTypes=Flatten[
							Take[plate,{#,#},{4}]&/@readPlateStartPositions
						];

						(* Get the final type *)
						resolvedReadPlateType=If[MatchQ[readPlateTypes,{""..}|{}],
							"Default",
							SelectFirst[readPlateTypes,!MatchQ[#,""]&]
						];

						(* Pattern definition used to differentiate between using a Fluorescene plate or a UV plate *)
						fluoresceneReadP=FluoresceneSpectroscopy|FluoresceneIntensity|FluoresceneKinetics;
						(* How is this pattern matched in later Switch? *)
						alphaScreenP=AlphaScreen;
						(* What does this resolved plate mode do? *)
						(* Resolve plate model*)
						resolvedPlateModel=If[MemberQ[updatedHeads,"Plate Model"],
							Last[Last[plate[[plateModelPosition]]]],
							Switch[ToExpression[resolvedReadPlateType],
								Default,Model[Container,Plate,"96-well 2mL Deep Well Plate"],(* If ReadPlate is not specified or if Read Plate is but type is not *)
								fluoresceneReadP,Model[Container, Plate, "96-well Black Wall Greiner Plate"],(* If type is fluorescene *)
								alphaScreenP,Model[Container,Plate,"AlphaPlate Half Area 96-Well Gray Plate"],
								_,Model[Container, Plate, "96-well UV-Star Plate"](* Else use UV plate *)
							]
						];

						(* Create define primitive using resolved plate model *)
						definePrimitive=Define[Name->plateName,Container->resolvedPlateModel];

						(* Create column which will be inserted into data to connect back to correct define primitive *)
						nameColumn=Repeat[plateName,Length[First[plate]]-3];

						(* Add Plate Model header *)
						plateModelColumn=Join[{"Plate Model","",""},nameColumn];

						(* Return updated data and the define primitive *)
						If[MemberQ[updatedHeads,"Plate Model"],
							{ReplacePart[plate,plateModelPosition->plateModelColumn],definePrimitive},
							{Insert[plate,plateModelColumn,2],definePrimitive}
						]
					]
				],
				withWellPositions
			];

			(* Extract data with plate models *)
			withPlateModels=modelsAndDefPrimitives[[All,1]];

			(* Extract the define primitive *)
			definePlatePrimitives=modelsAndDefPrimitives[[All,2]];

			(* Put back into original workable form *)
			resolvedTransposed=Transpose/@withPlateModels;
			resolvedFlattened=Flatten[resolvedTransposed,1];
			resolvedSorted=Sort[resolvedFlattened,First[#1] < First[#2] &];

			(* Remove duplicate headers *)
			resolvedData=Transpose[DeleteDuplicates[resolvedSorted]];

			(* remove reference indices *)
			withoutReferenceIndices=resolvedData[[2;;,All]];

			(* Define default well name column *)
			defaultWellNameColumn=Join[{"Well Name","",""},Repeat["",Length[cleanedRows]-3]];

			(* Add Well Name column if it is not present *)
			withWellNames=If[MemberQ[withoutReferenceIndices[[All,1]],"Well Name"],
				withoutReferenceIndices,
				Insert[withoutReferenceIndices,defaultWellNameColumn,2]
			];

			(* Get the final heads *)
			finalHeads=withWellNames[[All,1]];

			(* Get the final positions of the Well and Plate Model heads *)
			finalWellPosition=Flatten[Position[finalHeads,"Well"]];
			finalPlateDefPosition=Flatten[Position[finalHeads,"Plate Model"]];
			finalWellNamePosition=Flatten[Position[finalHeads,"Well Name"]];

			finalWellNames=First[withWellNames[[finalWellNamePosition,4;;]]];

			finalPlateDefinitions=First[withWellNames[[finalPlateDefPosition,4;;]]];

			finalWellPositions=First[withWellNames[[finalWellPosition,4;;]]];

			definedWellPrimitives=If[MatchQ[finalWellNamePosition,{_Integer}],
				MapThread[
					Function[{name,well,plateDef},
						If[MatchQ[name,""],
							Null,
							Define[
								Name->name,
								Container->{plateDef,well}
							]
						]
					],
					{finalWellNames,finalWellPositions,finalPlateDefinitions}
				],
				{}
			];

			cleanedWellDefinitions=DeleteCases[definedWellPrimitives,Null];

			(* Break data up by primitive *)
			splitPrimitives=Split[withWellNames[[5;;,All]],
				Length[StringSplit[First[#1]]]<=Length[StringSplit[First[#2]]]>=2&];

			(* Extract the data fields *)
			primitiveData=(Transpose/@splitPrimitives)[[All,4;;]];

			(* Extract the primitive headers *)
			primitiveHeads=splitPrimitives[[All,All,1;;3]];

			(* Create a corresponding association for each header *)
			headAssociations=Function[{headList},
				Module[{mainPrimitive,headRule,mainInputRule,unitRule,optionRules},
					mainPrimitive=First[headList];
					headRule="Head"->First[mainPrimitive];
					mainInputRule="Main Input"->mainPrimitive[[2]];
					unitRule="Unit"->Last[mainPrimitive];
					optionRules="Options"->(Rest[#]&)/@(Rest[headList]);
					Join[<|headRule,mainInputRule,unitRule,optionRules|>]
				]
			]/@primitiveHeads;

			(* Create association for each data point to keep track of the well position and plate *)
			wellAndPlateAssociations=Function[{nums},
					MapThread[
						If[MatchQ[#1,""],
							<||>,
							<|
								"Data"->#1,
								"Well Pos"->If[MatchQ[#4,""],#2,#4],
								"Plate"->#3
							|>
						]&,
						{nums,finalWellPositions,finalPlateDefinitions,finalWellNames}]
			]/@primitiveData;

			(* Combine the head Associations and data associations *)
			combinedAssociations=MapThread[
				Function[{head,base},
					If[MatchQ[#,<||>],
						<||>,
						Join[head,#]
					]&/@base],
				{headAssociations,wellAndPlateAssociations}
			];

			(* Orient based on readDirection option *)
			orientedAssociations=If[MatchQ[readDirection,Row],
				Flatten[Transpose[combinedAssociations]],
				Flatten[combinedAssociations]
			];

			(* Define the generic primitive generator functions *)
			genericPrimitiveGenerators=<|
				"Transfer"->transferGenerator[],
				"Incubate"->incubateGenerator[],
				"Mix"->mixGenerator[],
				"Wait"->waitGenerator[],
				"FillToVolume"->fillToVolumeGenerator[],
				"Aliquot"->aliquotGenerator[],
				"Consolidation"->consolidationGenerator[],
				"Centrifuge"->centrifugeGenerator[],
				"ReadPlate"->readPlateGenerator[]
			|>;

			(* Create a primitive for each association which is not empty*)
			primitives=Function[{assoc},
				If[MatchQ[assoc,<||>],
					Null,
					((Lookup[assoc,"Head"])/.genericPrimitiveGenerators)[assoc]
				]
			]/@orientedAssociations;

			(* Remove Null from the list of primitives *)
			cleanedPrimitives=DeleteCases[primitives,Null];

			(* Add define primitives at the beginning *)
			Join[definePlatePrimitives,cleanedWellDefinitions,cleanedPrimitives]
		]
	];

	generateSimpleManips=Function[{validCheck,cleanedCols},
		Module[
			{
				orientedData,orientedDataSymbols,defaultCheckAssociation,definedRowsAssociation,withWellPositions,
				withUnits,rowLength,withPlateModels,definePrimitive,transferPrimitives,resolvedPlateModel,plateModel
			},

			(* Get data into consistent form *)
			orientedData=Switch[validCheck,
				"Simple Column",cleanedCols,
				"Simple Column Header",Rest/@cleanedCols,
				"Simple Row",Transpose[cleanedCols],
				"Simple Row Header",Rest/@(Transpose[cleanedCols])
			];

			(* Convert the Objects from strings *)
			orientedDataSymbols=Quiet[Map[
				If[StringMatchQ[ToString[#], Alternatives["Object" ~~ ___ , "Model" ~~ ___]],
					ToExpression[#],
					#
				]&,
				orientedData,
				{2}
			],{ToExpression::sntx}
			];

			(* Define default base association *)
			defaultCheckAssociation=<|
				"Sample"->False,
				"Volume"->False,
				"Well"->False,
				"Unit"->False,
				"Plate Model"->False
			|>;


			(* Determine what rows there are *)
			definedRowsAssociation=Fold[
				Function[{currAssoc,currRow},
					If[MatchQ[Quiet[ToExpression[currRow],{ToExpression::notstrbox}],{(VolumeP|Null)..}],
						Join[currAssoc,<|"Unit"->ToExpression[currRow]|>],
						Switch[currRow,
							{ObjectP[{Object[Sample],Model[Sample]}]..},Join[currAssoc,<|"Sample"->currRow|>],
							{GreaterP[0.]..},Join[currAssoc,<|"Volume"->currRow|>],
							{WellPositionP..},Join[currAssoc,<|"Well"->currRow|>],
							{ObjectP[Model[Container,Plate]]..},Join[currAssoc,<|"Plate Model"->currRow|>]
						]
					]
				],
				defaultCheckAssociation,
				orientedDataSymbols
			];

			(* Get the length of a single row *)
			rowLength=Length[Lookup[definedRowsAssociation,"Sample"]];

			(* Resolve Well Positions*)
			withWellPositions=If[MatchQ[Lookup[definedRowsAssociation,"Well"],False],
				Join[definedRowsAssociation,<|"Well"->possibleWellPositions[[1;;rowLength]]|>],
				definedRowsAssociation
			];

			(* Resolve Unit *)
			withUnits=If[MatchQ[Lookup[definedRowsAssociation,"Unit"],False],
				Join[withWellPositions,<|"Unit"->Repeat[Micro Liter,rowLength]|>],
				withWellPositions
			];


			(* Get plate model list if it exists *)
			plateModel=Lookup[definedRowsAssociation,"Plate Model",False];

			(* Resolve Plate Model *)
			{withPlateModels,resolvedPlateModel}=If[MatchQ[plateModel,False],
				{Join[withUnits,<|"Plate Model"->Repeat["Plate1",rowLength]|>],Model[Container,Plate,"96-well 2mL Deep Well Plate"]},
				If[Equal@@Lookup[definedRowsAssociation,"Plate Model"],
					{Join[withUnits,<|"Plate Model"->Repeat["Plate1",rowLength]|>],First[plateModel]},
					Message[Error::NotSamePlate];
					Return[]
				]
			];

			(* Create define primitive  *)
			definePrimitive=Define[Name->"Plate1",Container->resolvedPlateModel];

			(* Create transfer primitive for each column/row *)
			transferPrimitives=MapThread[
				Function[{sample,volume,unit,well},
					Transfer[
						Source->sample,
						Destination->{"Plate 1",well},
						Amount->(volume*unit)
					]
				],
				{Lookup[withPlateModels,"Sample"],Lookup[withPlateModels,"Volume"],Lookup[withPlateModels,"Unit"],Lookup[withPlateModels,"Well"]}
			];

			(* Add define primitive to beginning of the list of primitives *)
			Prepend[transferPrimitives,definePrimitive]
		]
	];

	(* Function which will take the data and generate the manipulations *)
	generateManips=Function[{data},
		Module[
			{cleanedRows,cleanedCols,validCheck},

			(* See if the format is valid *)
			validCheck=ValidImportSampleManipulationQ[data,Return->Format];

			(* Trim any blank rows and columns *)
			(* Remove any lines of just empty strings*)
			cleanedRows=DeleteCases[data,{""..}];
			cleanedCols=DeleteCases[Transpose[cleanedRows],{""..}];


			(* If it is invalid then throw an error and return. Otherwise generate manips*)
			Switch[validCheck,
				"Main",generateMainManips[cleanedRows,cleanedCols],
				"Failed",Message[Error::InvalidFormat];$Failed,
				_,generateSimpleManips[validCheck,cleanedCols]
			]
		]
	]/@myDataList

];

(* Function to generate a Transfer primitive given an association of data *)
transferGenerator[]:=Function[{transferAssoc},
	Module[{sample,unit,allData,wellLabel,plate,options,volume,optionData,optionRules,cleanedOptionRules},

		(* Extract necessary data *)
		{sample,unit,allData,wellLabel,plate,options}=Lookup[transferAssoc,{"Main Input","Unit","Data","Well Pos","Plate","Options"},{}];

		(* Get the volume *)
		volume=First[allData];

		(* Get the data for the options *)
		optionData=Rest[allData];

		(* Convert the option data and option names to rules *)
		optionRules=MapThread[
			Function[{data,option},
				Module[{name,unit},
					name=ToExpression[First[option]];
					unit=ToExpression[Last[option]];
					If[MatchQ[data,""],
						Null,
						If[MatchQ[unit,Null],
							name->data,
							name->data*unit
						]
					]
				]
			],
			{optionData,options}
		];

		(* Remove unused options *)
		cleanedOptionRules=DeleteCases[optionRules,Null];

		transferRules=Sequence[Source->sample,
			Destination->If[MatchQ[wellLabel,WellPositionP],
				{plate,wellLabel},
				wellLabel
			],
			Amount->volume*ToExpression[unit],
			Sequence@@cleanedOptionRules];

		(* Check if primitive should be generated *)
		If[MatchQ[volume,""],
			Null,
			Transfer[transferRules]
		]
	]
];

(* Function to generate incubate primitive given association of data *)
incubateGenerator[]:=Function[{incubateAssoc},
	Module[{firstOption,firstOptionUnit,allData,wellLabel,plate,options,optionRules,cleanedOptionRules},

		(* Lookup needed data *)
		{firstOption,firstOptionUnit,allData,wellLabel,plate,options}=Lookup[incubateAssoc,{"Main Input","Unit","Data","Well Pos","Plate","Options"},{}];

		(* All of the data would be an option so convert it to rules *)
		optionRules=MapThread[
			Function[{option,data},
				Module[{name,unit},
					name=ToExpression[First[option]];
					unit=ToExpression[Last[option]];
					If[MatchQ[data,""],
						Null,
						If[MatchQ[unit,Null],
							name->data,
							name->data*unit
						]
					]
				]
			],
			{Prepend[options,{firstOption,firstOptionUnit}],allData}
		];

		(* Remove unwanted options *)
		cleanedOptionRules=DeleteCases[optionRules,Null];

		(* Generate the primitive if data is not blank *)
		If[MatchQ[allData,{""..}],
			Null,
			(* If option row is blank and  *)
			If[MatchQ[First[allData],True]&&MatchQ[firstOption,""],
				Incubate[
					Sample->If[MatchQ[wellLabel,WellPositionP],
						{plate,wellLabel},
						wellLabel
					]
				],
				Incubate[
					Sample->If[MatchQ[wellLabel,WellPositionP],
						{plate,wellLabel},
						wellLabel
					],
					Sequence@@cleanedOptionRules
				]
			]
		]
	]
];

(* Function to generate Mix primitive from association of data *)
mixGenerator[]:=Function[{mixAssoc},
	Module[{firstOption,firstOptionUnit,allData,wellLabel,plate,options,optionRules,cleanedOptionRules},

		(* Extract needed data *)
		{firstOption,firstOptionUnit,allData,wellLabel,plate,options}=Lookup[mixAssoc,{"Main Input","Unit","Data","Well Pos","Plate","Options"},{}];

		(* All of the data would be options so convert it to rules *)
		optionRules=MapThread[
			Function[{option,data},
				Module[{name,unit},
					name=ToExpression[First[option]];
					unit=ToExpression[Last[option]];

					(* Don't include option if no data provided *)
					If[MatchQ[data,""],
						Null,
						If[MatchQ[unit,Null],
							name->data,
							name->data*unit
						]
					]
				]
			],
			{Prepend[options,{firstOption,firstOptionUnit}],allData}
		];

		(* Remove unwanted options *)
		cleanedOptionRules=DeleteCases[optionRules,Null];

		(* Generate primitive if data is not blank *)
		If[MatchQ[allData,{""..}],
			Null,
			If[MatchQ[First[allData],True]&&MatchQ[firstOption,""],
				Mix[
					Sample->If[MatchQ[wellLabel,WellPositionP],
						{plate,wellLabel},
						wellLabel
					]
				],
				Mix[
					Sample->If[MatchQ[wellLabel,WellPositionP],
						{plate,wellLabel},
						wellLabel
					],
					Sequence@@cleanedOptionRules
				]
			]
		]
	]
];

(* Function to generate centrifuge primitive given association of data *)
centrifugeGenerator[]:=Function[{centrifugeAssoc},
	Module[{firstOption,firstOptionUnit,allData,wellLabel,plate,options,optionRules,cleanedOptionRules},

		(* Extract needed data *)
		{firstOption,firstOptionUnit,allData,wellLabel,plate,options}=Lookup[centrifugeAssoc,{"Main Input","Unit","Data","Well Pos","Plate","Options"},{}];

		(* All of the data would be options so convert it to rules *)
		optionRules=MapThread[
			Function[{option,data},
				Module[{name,unit},
					name=ToExpression[First[option]];
					unit=ToExpression[Last[option]];

					(* Don't include option if data not provided *)
					If[MatchQ[data,""],
						Null,
						If[MatchQ[unit,Null],
							name->data,
							name->data*unit
						]
					]
				]
			],
			{Prepend[options,{firstOption,firstOptionUnit}],allData}
		];

		(* remove instances of Null from list *)
		cleanedOptionRules=DeleteCases[optionRules,Null];

		(* Generate primitive if data not empty *)
		If[MatchQ[allData,{""..}],
			Null,
			(* If true is specified, use all defaults *)
			If[MemberQ[allData,True],
				Centrifuge[
					Sample->If[MatchQ[wellLabel,WellPositionP],
						{plate,wellLabel},
						wellLabel
					]
				],
				Centrifuge[
					Sample->If[MatchQ[wellLabel,WellPositionP],
						{plate,wellLabel},
						wellLabel
					],
					Sequence@@cleanedOptionRules
				]
			]
		]
	]
];

(* Function to generate wait primitive given association of data *)
waitGenerator[]:=Function[{waitAssoc},
	Module[{firstOptionUnit,allData},

		(* Extract needed data *)
		{firstOptionUnit,allData}=Lookup[waitAssoc,{"Unit","Data"},{}];

		(* Generate the primitive if data provided *)
		If[MatchQ[allData,{""..}],
			Null,
			Wait[
				Duration->First[allData]*ToExpression[firstOptionUnit]
			]
		]
	]
];

(* Function to generate FillToVolume primitive given association of data *)
fillToVolumeGenerator[]:=Function[{fTVAssoc},
	Module[{sample,unit,allData,wellLabel,plate,volume},

		(* Extract needed data *)
		{sample,unit,allData,wellLabel,plate}=Lookup[fTVAssoc,{"Main Input","Unit","Data","Well Pos","Plate"},{}];

		(* Extract the volume *)
		volume=First[allData];

		(* Generate the primitive if data is provided *)
		If[MatchQ[allData,{""..}],
			Null,
			FillToVolume[
				Source->sample,
				Destination->If[MatchQ[wellLabel,WellPositionP],
					{plate,wellLabel},
					wellLabel
				],
				FinalVolume->volume*ToExpression[unit]
			]
		]
	]
];

(* Function to generate aliquot primitive given association of data *)
aliquotGenerator[]:=Function[{aliquotAssoc},
	Module[{sample,unit,allData,wellLabel,plate,options,volume,optionData,optionRules,cleanedOptionRules},

		(* Extract needed data *)
		{sample,unit,allData,wellLabel,plate,options}=Lookup[aliquotAssoc,{"Main Input","Unit","Data","Well Pos","Plate","Options"},{}];
		volume=First[allData];
		optionData=Rest[allData];

		(* Interpret options and convert them to rules *)
		optionRules=MapThread[
			Function[{data,option},
				Module[{name,unit},
					name=ToExpression[First[option]];
					unit=ToExpression[Last[option]];
					(* Convert option if data is provided *)
					If[MatchQ[data,""],
						Null,
						If[MatchQ[unit,Null],
							name->data,
							name->data*unit
						]
					]
				]
			],
			{optionData,options}
		];

		(* Remove instances of Null from the option list *)
		cleanedOptionRules=DeleteCases[optionRules,Null];

		(* Generate primitive if data is provided *)
		If[MatchQ[volume,""],
			Null,
			Aliquot[
				Source->sample,
				Destinations->{If[MatchQ[wellLabel,WellPositionP],
					{plate,wellLabel},
					wellLabel
				]},
				Amounts->{volume*ToExpression[unit]},
				Sequence@@cleanedOptionRules
			]
		]
	]
];

(* Function to generate a consolidation primitive  *)
consolidationGenerator[]:=Function[{consolidationAssoc},
	Module[{sample,unit,allData,wellLabel,plate,options,volumes,optionData,otherSources,sourcesAndOptionRules,optionRules,cleanedOptionRules,units,samples,amounts,firstVolume,
			blankVolumePositions,cleanedVolumes,cleanedSamples,cleanedUnits},

		(* Extract needed data *)
		{sample,unit,allData,wellLabel,plate,options}=Lookup[consolidationAssoc,{"Main Input","Unit","Data","Well Pos","Plate","Options"},{}];

		(* Separate option data from first sample volume data *)
		optionData=Rest[allData];
		firstVolume=First[allData];

		(* Go through the option data. If it is an option convert it to rule form, if it is another sample to consolidate, pass *)
		sourcesAndOptionRules=MapThread[
			Function[{data,option},
				Module[{name,unit,sampleBool},

					(* Check if the data is a sample or an option *)
					sampleBool=MatchQ[First[option],ObjectP[{Object[Sample],Model[Sample]}]];
					name=Quiet[ToExpression[First[option]],{ToExpression::notstrbox}];
					unit=ToExpression[Last[option]];

					(* Convert the option to rule form if it is an option. If it is sample data, just return it *)
					If[sampleBool,
						Append[option,data],
						If[MatchQ[data,""],
							Null,
							If[MatchQ[unit,Null],
								name->data,
								name->data*unit
							]
						]
					]
				]
			],
			{optionData,options}
		];

		(* Split the converted options and sample into their respective lists *)
		otherSources=Cases[sourcesAndOptionRules,{ObjectP[{Object[Sample],Model[Sample]}],_,_}];
		optionRules=Complement[sourcesAndOptionRules,otherSources];

		(* Remove instances of Null from options list *)
		cleanedOptionRules=DeleteCases[optionRules,Null];

		(* Add initial unit, volume, and sample to respective list.  *)
		units=ToExpression[Prepend[otherSources[[All,2]],unit]]/.{Null->Micro Liter};
		samples=Prepend[otherSources[[All,1]],sample];
		volumes=Prepend[otherSources[[All,3]],firstVolume];

		(* Remove blank volumes and corresponding units/samples *)
		blankVolumePositions=Position[volumes,""];

		(* remove the units and samples corresponding to missing volumes *)
		cleanedUnits=Delete[units,blankVolumePositions];
		cleanedSamples=Delete[samples,blankVolumePositions];
		cleanedVolumes=Delete[volumes,blankVolumePositions];

		(* Convert the volumes and units to amounts *)
		amounts=MapThread[#1*#2&,{cleanedVolumes,cleanedUnits}];

		(* Create the primitive if data is provided *)
		If[MatchQ[cleanedVolumes,{}],
			Null,
			Consolidation[
				Sources->cleanedSamples,
				Destination->If[MatchQ[wellLabel,WellPositionP],
					{plate,wellLabel},
					wellLabel
				],
				Amounts->amounts,
				Sequence@@cleanedOptionRules
			]
		]
	]
];

(* Function to generate ReadPlate primitive given association of data *)
readPlateGenerator[]:=Function[{readPlateAssoc},
	Module[{allData,wellLabel,plate,options,type,optionData,optionRules,cleanedOptionRules},

		(* Extract needed data *)
		{allData,wellLabel,plate,options}=Lookup[readPlateAssoc,{"Data","Well Pos","Plate","Options"},{}];

		(* Split the data into type of read plate and option data *)
		type=First[allData];
		optionData=Rest[allData];

		(* Convert options to option form when data is provided *)
		optionRules=MapThread[
			Function[{data,option},
				Module[{name,unit},
					name=ToExpression[First[option]];
					unit=ToExpression[Last[option]];
					(* If data is provided put the option and data into rule form *)
					If[MatchQ[data,""],
						Null,
						If[MatchQ[unit,Null],
							name->data,
							name->data*unit
						]
					]
				]
			],
			{optionData,options}
		];

		(* Remove instances of Null from option rules *)
		cleanedOptionRules=DeleteCases[optionRules,Null];

		(* Generate the primitive if data is provided *)
		If[MatchQ[type,""],
			Null,
			ReadPlate[
				Sample->If[MatchQ[wellLabel,WellPositionP],
					{plate,wellLabel},
					wellLabel
				],
				Type->type,
				Sequence@@cleanedOptionRules
			]
		]
	]
];

(* ::Subsubsection::Closed:: *)
(*ValidImportSampleManipulationQ*)


(* Define Options *)
DefineOptions[ValidImportSampleManipulationQ,
	Options:>{
		{
			OptionName->Return,
			Default->Tests,
			Description->"Specifies whether the function should return the test summary or the underlying format of the input.",
			ResolutionDescription->"Automatically returns the test summary generated.",
			AllowNull->False,
			Widget->Widget[Type->Expression,Pattern:>Tests|Format,Size->Line],
			Category->"Hidden"
		},
		VerboseOption
	}
];


(* Main Singleton Overloads *)
(* CloudFile*)
ValidImportSampleManipulationQ[myCloudFile:ObjectP[Object[EmeraldCloudFile]],myOptions:OptionsPattern[]]:=First[ValidImportSampleManipulationQ[{myCloudFile},myOptions]];

(* File Path *)
ValidImportSampleManipulationQ[myFilePath:FilePathP,myOptions:OptionsPattern[]]:=First[ValidImportSampleManipulationQ[{myFilePath},myOptions]];

(* Raw Data *)
ValidImportSampleManipulationQ[myData:{{(_String|NumericP|BooleanP)..}..},myOptions:OptionsPattern[]]:=First[ValidImportSampleManipulationQ[{myData},myOptions]];

(* Mixed Listable Overload *)
ValidImportSampleManipulationQ[myMixedList:{Alternatives[ObjectP[Object[EmeraldCloudFile]],FilePathP,{{(_String|NumericP|BooleanP)..}..}]..},myOptions:OptionsPattern[]]:=Module[
	{
		convertFunc
	},
	convertFunc=Function[{input},
		Switch[input,
			ObjectP[Object[EmeraldCloudFile]],ImportCloudFile[input],
			(* For MM > 12.0, "XLSX" needs to be specified *)
			FilePathP,Import[input, "XLSX"],
			{{(_String|NumericP|BooleanP)..}..},{input}
		]
	];
	ValidImportSampleManipulationQ[Flatten[convertFunc/@myMixedList,1],myOptions]
];

(* Main Listable Overload *)
ValidImportSampleManipulationQ[myDataList:{{{(_String|NumericP|BooleanP)..}..}..},myOptions:OptionsPattern[]]:=Module[
	{
		listedOptions,safeOptions,verbose,return,genericTests,validHeads,generateSimpleTests,generateMainTests,generateTestSummary
	},

	(* Put the options into a listable form *)
	listedOptions=ToList[myOptions];

	(* Get the safe options *)
	safeOptions=SafeOptions[ValidImportSampleManipulationQ,listedOptions];

	(* Extract the verbose and return options *)
	verbose=Lookup[safeOptions,Verbose];
	return=Lookup[safeOptions,Return];

	(* Define the generic tests for each type of column (Main format) *)
	genericTests=<|
		"Plate Model"->plateModelTests[],
		"Plate Number"->plateNumberTests[],
		"Well"->wellTests[],
		"Well Name"->wellNameTests[],
		"Transfer"->transferTests[],
		"TransferOption"->transferOptionTests[],
		"Incubate"->incubateOptionTests[],
		"IncubateOption"->incubateOptionTests[],
		"Wait"->waitTests[],
		"Mix"->mixOptionTests[],
		"MixOption"->mixOptionTests[],
		"FillToVolume"->fillToVolumeTests[],
		"Centrifuge"->centrifugeOptionTests[],
		"CentrifugeOption"->centrifugeOptionTests[],
		"Aliquot"->aliquotTests[],
		"AliquotOptions"->AliquotOptionTests[],
		"Consolidation"->consolidationTests[],
		"ConsolidationOption"->consolidationOptionTests[],
		"ReadPlate"->readPlateTests[],
		"ReadPlateOption"->readPlateOptionTests[]
	|>;

	(* Enumerate Valid Heads *)
	validHeads={"Plate Model", "Plate Number", "Well","Well Name","Transfer","TransferOption","Incubate","IncubateOption","Wait",
				"Mix","MixOption","FillToVolume","Centrifuge","CentrifugeOption","Aliquot","AliquotOptions","Consolidation",
				"ConsolidationOption","ReadPlate","ReadPlateOption"};

	(* Function to generate the tests for the simple format *)
	generateSimpleTests=Function[{columnSymbols},
		Module[{
			rowSymbols,allowedRowsP,unitRowP,recognizedRowQ,rowAll,rowRest,colAll,colRest,simpleLengthTest,resolvedOrientation,testLabel,
			orientationTest,defaultCheckAssoc,testList,index,generateOutput,definedRowsAssoc,rowTests,finalIndex,sampleTest,volumeTest
		},

			(* Get the row orientation *)
			rowSymbols=Transpose[columnSymbols];

			(* Define test to check row lengths *)
			simpleLengthTest=Test["Test that there is not just a single row or a single column:",
				Length[rowSymbols]>=2||Length[columnSymbols]>=2,
				True
			];

			(* Define allowable row patterns *)
			allowedRowsP=Alternatives[{ObjectP[{Object[Sample],Model[Sample]}]..},{GreaterP[0.]..},{WellPositionP..},{ObjectP[Model[Container,Plate]]..}];
			unitRowP={(VolumeP|Null)..};

			(* Define function to determine if a row is recognized *)
			recognizedRowQ=Function[{row},
				Quiet[
					MatchQ[row,allowedRowsP]||MatchQ[ToExpression[row],unitRowP],
					{ToExpression::notstrbox,ToExpression::sntx}
				]
			];

			(* Get the possible first rows and columns (cases with and without headers) *)
			rowAll=First[rowSymbols];
			rowRest=If[Length[rowSymbols]>=2,
				Rest[First[rowSymbols]],
				False
			];
			colAll=First[columnSymbols];
			colRest=If[Length[columnSymbols]>=2,
				Rest[First[columnSymbols]],
				False
			];

			(* Determine the orientation of the data and whether there are headers *)
			{resolvedOrientation,testLabel}=Switch[{recognizedRowQ[rowAll],recognizedRowQ[rowRest],recognizedRowQ[colAll],recognizedRowQ[colRest]},
				{True,_,_,_},{rowSymbols,"Row"},
				{_,_,True,_},{columnSymbols,"Column"},
				{False,True,_,_},{Rest/@rowSymbols,"Row Header"},
				{_,_,False,True},{Rest/@columnSymbols,"Column Header"},
				_,{"Not recognized","Neither"}
			];

			(* Define the test to check if the orientation is recognized *)
			orientationTest=Test["Test if the first row can be recognized as SM Primitives, or first row/column can be recognized as Well Positions, Units, Samples, Volumes, or Plate Models. If it can not, no more tests will be generated:",
				!MatchQ[resolvedOrientation,"Not recognized"],
				True
			];

			(* If the orientation is not recognized then return *)
			If[MatchQ[resolvedOrientation,"Not recognized"],
				{{simpleLengthTest,orientationTest},"Not recognized"},

				(* Otherwise generate the simple format tests *)

				(* Association to keep track of recognized rows *)
				defaultCheckAssoc=<|
					"Sample"->False,
					"Volume"->False,
					"Well"->False,
					"Unit"->False,
					"Plate Model"->False,
					"Extra"->False
				|>;

				(* Initial list of the row tests *)
				testList={};

				(* Initial index *)
				index=1;

				(* Function to generate the tests for each row *)
				generateOutput=Function[{currAssoc,currTestList,currIndex,rowType},
					Module[{alreadySeen,duplicateTest,recognizedTest,updatedAssoc},
						alreadySeen=Lookup[currAssoc,rowType];
						recognizedTest=Test[testLabel ~~ " " ~~ ToString[currIndex] ~~ ": Test if row is a recognized type (Sample, Volume, Well, Plate Model, Unit):",
							!StringMatchQ[rowType,"Extra"],
							True
						];
						duplicateTest=Test[testLabel ~~ " " ~~ ToString[currIndex] ~~ ": Test if " ~~ rowType ~~ " row has already been seen:",
							alreadySeen,
							False
						];
						updatedAssoc=Join[currAssoc,<|rowType->True|>];
						{updatedAssoc,Join[currTestList,{duplicateTest,recognizedTest}],currIndex+1}
					]
				];

				(* Determine what rows there are *)
				{definedRowsAssoc,rowTests,finalIndex}=Fold[
					Function[{checks,currRow},
						Module[{currAssoc,currTestList,currIndex},
							{currAssoc,currTestList,currIndex}=checks;
							If[MatchQ[Quiet[ToExpression[currRow],{ToExpression::notstrbox}],{(VolumeP|Null)..}],
								generateOutput[currAssoc,currTestList,currIndex,"Unit"],
								Switch[currRow,
									{ObjectP[{Object[Sample],Model[Sample]}]..},generateOutput[currAssoc,currTestList,currIndex,"Sample"],
									{GreaterP[0.]..},generateOutput[currAssoc,currTestList,currIndex,"Volume"],
									{WellPositionP..},generateOutput[currAssoc,currTestList,currIndex,"Well"],
									{ObjectP[Model[Container,Plate]]..},generateOutput[currAssoc,currTestList,currIndex,"Plate Model"],
									_,generateOutput[currAssoc,currTestList,currIndex,"Extra"]
								]
							]
						]
					],
					{defaultCheckAssoc,testList,index},
					resolvedOrientation
				];

				(* Define test to check if sample row/col is present *)
				sampleTest=Test[testLabel ~~ " of samples is present:",
					Lookup[definedRowsAssoc,"Sample"],
					True
				];

				(* Define test to check if volume row/col is present *)
				volumeTest=Test[testLabel ~~ " of volumes to be transferred present:",
					Lookup[definedRowsAssoc,"Volume"],
					True
				];

				{Join[{simpleLengthTest,orientationTest},rowTests,{sampleTest,volumeTest}],"Simple " <> testLabel}

			]
		]
	];

	(* Function to generate the tests for the main format *)
	generateMainTests=Function[{columnSymbols,heads,extendedHeads},
		Module[{lengths,lengthBool,lengthTest,testFunctions,invalidHeads,mainTests,plateNumberPosition,plateNumberDuplicateTest,
		plateModelPosition,plateModelDuplicateTest,wellPosition,wellDuplicateTest,readPlatePositions,gatheredByPlate,consistencyTests,
		rowSymbols,workableGatheredData},

			(* Get the lengths of all the columns *)
			lengths=Length/@columnSymbols;

			(* Generate test for checking if all columns are same length *)
			lengthBool=Length[DeleteDuplicates[lengths]]==1;
			lengthTest=Test["Test if all of the columns are the same length:",
				lengthBool,
				True
			];

			(* Generate the test functions for each column *)
			testFunctions=extendedHeads/.genericTests;

			(* Get invalid heads *)
			invalidHeads=Cases[testFunctions,_String];

			(* Generate tests *)
			mainTests=Flatten[MapThread[
				Function[{testGenerator,index},
					Module[{column,lengthCheck,lengthTest,headCheck,headTest,columnTests},
						column=columnSymbols[[index]];

						(* Individual column length check *)
						lengthCheck=!Length[columnSymbols[[index]]]<4;

						lengthTest=Test["Column " ~~ ToString[index] ~~ ": Test if column has at least 4 rows. If it does not, tests for this column will not ge generated:",
							lengthCheck,
							True
						];

						(* Check if head is valid *)
						headCheck=!MatchQ[testGenerator,_String];

						headTest=Test["Column " ~~ ToString[index] ~~ ": Test if head, " ~~heads[[index]]~~ " is valid. If it is not, tests for this column will not be generated:",
							headCheck,
							True
						];

						(* Generate column specific tests based on head *)
						columnTests=If[lengthCheck&&headCheck,
							testGenerator[columnSymbols[[index]],index],
							{}
						];

						(* Return all of the tests *)
						Join[{lengthTest},{headTest},columnTests]
					]
				],
				{testFunctions,Range[Length[testFunctions]]}
			]];

			(* Create duplicate tests for Plate Model, Plate Number, and Well *)
			plateNumberPosition=Flatten[Position[heads,"Plate Number"]];
			plateNumberDuplicateTest=Test["Test that the Plate Number head appears no more than once:",
				Length[plateNumberPosition]<=1,
				True
			];

			plateModelPosition=Flatten[Position[heads,"Plate Model"]];
			plateModelDuplicateTest=Test["Test that the Plate Model head appears no more than once:",
				Length[plateModelPosition]<=1,
				True
			];

			wellPosition=Flatten[Position[heads,"Well"]];
			wellDuplicateTest=Test["Test that the Well head appears no more than once:",
				Length[wellPosition]<=1,
				True
			];

			(* create extra Plate Model and Read Plate tests *)

			(* Get positions of ReadPlate head *)
			readPlatePositions=Flatten[Position[heads,"ReadPlate"]];

			(* Get the data in terms of rows *)
			rowSymbols=Transpose[columnSymbols];

			(* Gather the data by plate number *)
			gatheredByPlate=If[MatchQ[plateNumberPosition,{_Integer}],
				Gather[rowSymbols[[4;;,All]],#1[[plateNumberPosition]]==#2[[plateNumberPosition]]&],
				{rowSymbols[[4;;,All]]}
			];

			(* Get the gathered data into a workable form *)
			workableGatheredData=Transpose/@gatheredByPlate;

			(* Generate the consistency tests *)
			consistencyTests=Map[
				Function[{plate},
					Module[{readPlateBool,readPlateTest,readPlateData,removedEmptyStrings,removedDuplicates,plateModelBool,plateModelTest,plateModelData},

						(* Get the read plate type data *)
						readPlateBool=!MatchQ[readPlatePositions,{}];
						readPlateData=Flatten[Take[plate,{#}]&/@readPlatePositions];

						(* Test that for this plate across all the ReadPlate calls there is a single ReadPlateTypeP or blanks *)
						removedEmptyStrings=DeleteCases[readPlateData,""];
						removedDuplicates=DeleteDuplicates[removedEmptyStrings];
						readPlateTest=Test["Test if ReadPlate Type is equal for all rows of the same plate across all ReadPlate primitives (if ReadPlate exists):",
											Length[removedDuplicates]<=1,
											True
										];

						(* Make sure for this plate that if there is a specified plate model it is consistent *)
						plateModelBool=!MatchQ[plateModelPosition,{}];
						plateModelData=Flatten[Take[plate,plateModelPosition]];
						plateModelTest=Test["Test if specified plate model is equal for each plate (can be blank):",
							Equal@@plateModelData,
							True
						];

						(* Use tests which are needed *)
						PickList[{readPlateTest,plateModelTest},{readPlateBool,plateModelBool},True]
					]
				],
				workableGatheredData
			];

			{Join[mainTests,{plateNumberDuplicateTest,plateModelDuplicateTest,wellDuplicateTest},Flatten[consistencyTests]],"Main"}
		]
	];

	(* Function to generate and run the tests on the input data *)
	generateTestSummary=Function[{inputData},
		Module[{cleanedRows,cleanedCols,columnSymbols,heads,extendedHeads,allTests,format,testSummary,testResult},


			(* Get the data into a workable form *)
			(* Remove any lines of just empty strings*)
			cleanedRows=DeleteCases[inputData,{""..}];
			cleanedCols=DeleteCases[Transpose[cleanedRows],{""..}];

			(* Convert the Objects in the data from strings to expressions*)
			columnSymbols=Quiet[Map[
				If[StringMatchQ[ToString[#], Alternatives["Object" ~~ ___ , "Model" ~~ ___]],
					ToExpression[#],
					#
				]&,
				cleanedCols,
				{2}
			],{ToExpression::sntx}];

			(* Get the column headers *)
			heads=columnSymbols[[All,1]];

			(* Extend column headers which allow for options *)
			extendedHeads=Rest[
				FoldList[
					Switch[#2,
						Except[""], #2,
						"", If[StringMatchQ[#1, ___ ~~ "Option"], #1, #1 ~~ "Option"]
					]&,
					"",
					heads
				]
			];

			(* If all of the heads are valid then generate main format tests otherwise generate simple format tests *)
			{allTests,format}=If[!SubsetQ[validHeads,extendedHeads],
					generateSimpleTests[columnSymbols],
					generateMainTests[columnSymbols,heads,extendedHeads]
			];

			(* Run the tests *)
			testSummary=Lookup[RunUnitTest[<|"FormatTests"->allTests|>,Verbose->verbose],"FormatTests"];

			(* Get the test result *)
			testResult=testSummary[Passed];

			(* Return the correct output based on the resolved Return option *)
			If[MatchQ[return,Tests],
				testResult,
				If[testResult,
					format,
					"Failed"
				]
			]
		]
	];

	generateTestSummary/@myDataList

];

(* Define tests for each column *)
plateModelTests[]:=Function[{columnData,columnIndex},
	Module[{indexTest,possibleEmptyRows,emptyRowTest,restRows,modelBools,modelTest},
		(* Test if index is under 4 *)
		indexTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if Plate Models are specified in first four columns or not at all:",
			columnIndex<5,
			True
		];

		(* Test if second and third rows are empty *)
		possibleEmptyRows=Take[columnData,{2,3}];
		emptyRowTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if second and third rows are empty:",
			MatchQ[possibleEmptyRows,{"",""}],
			True
		];

		(* Test if rest of rows specify a plate model *)
		restRows=columnData[[4;;]];
		modelBools=MatchQ[#,ObjectP[Model[Container,Plate]]]&/@restRows;
		modelTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if rows 4 to the end specify a plate model:",
			And@@modelBools,
			True
		];

		{indexTest,emptyRowTest,modelTest}
	]
];
plateNumberTests[]:=Function[{columnData,columnIndex},
	Module[{indexTest,possibleEmptyRows,emptyRowTest,restRows,integerBools,integerTest},
		(* Test if index is under 4 *)
		indexTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if Plate Numbers are specified in first four columns or not at all:",
			columnIndex<5,
			True
		];

		(* Test if second and third rows are empty *)
		possibleEmptyRows=Take[columnData,{2,3}];
		emptyRowTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if second and third rows are empty:",
			MatchQ[possibleEmptyRows,{"",""}],
			True
		];

		(* Test if rest of rows specify integer plate number *)
		restRows=columnData[[4;;]];
		integerBools=MatchQ[#,GreaterP[0.,1.]|_String]&/@restRows;
		integerTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if rows 4 to the end are an integer or plate name:",
			And@@integerBools,
			True
		];

		{indexTest,emptyRowTest,integerTest}
	]
];
wellTests[]:=Function[{columnData,columnIndex},
	Module[{indexTest,possibleEmptyRows,emptyRowTest,restRows,wellLabelBools,wellLabelTest},
		(* Test if index is under 4 *)
		indexTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if Wells are specified in first four columns or not at all:",
			columnIndex<5,
			True
		];

		(* Test if second and third rows are empty *)
		possibleEmptyRows=Take[columnData,{2,3}];
		emptyRowTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if second and third rows are empty:",
			MatchQ[possibleEmptyRows,{"",""}],
			True
		];

		(* Test if rest of rows specify well labels *)
		restRows=columnData[[4;;]];
		wellLabelBools=MatchQ[ToString[#],WellPositionP]&/@restRows;
		wellLabelTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if rows 4 to the end are well-formed well labels:",
			And@@wellLabelBools,
			True
		];

		{indexTest,emptyRowTest,wellLabelTest}
	]
];
wellNameTests[]:=Function[{columnData,columnIndex},
	Module[{indexTest,possibleEmptyRows,emptyRowTest,restRows,wellNameBools,wellNameTest},
		(* Test if index is under 4 *)
		indexTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if Well Names are specified in first four columns or not at all:",
			columnIndex<5,
			True
		];

		(* Test if second and third rows are empty *)
		possibleEmptyRows=Take[columnData,{2,3}];
		emptyRowTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if second and third rows are empty:",
			MatchQ[possibleEmptyRows,{"",""}],
			True
		];

		(* Test if rest of rows specify well labels *)
		restRows=columnData[[4;;]];
		wellNameBools=MatchQ[#,_String]&/@restRows;
		wellNameTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if rows 4 to the end are well Names:",
			And@@wellNameBools,
			True
		];

		{indexTest,emptyRowTest,wellNameTest}
	]
];
transferTests[]:=Function[{columnData,columnIndex},
	Module[{sample,sampleTest,unit,unitTest,restRows,numericBools,numericTest},
		(* Test if second row is a sample *)
		sample=columnData[[2]];
		sampleTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if second row is a sample:",
			MatchQ[sample,ObjectP[{Object[Sample],Model[Sample]}]],
			True
		];

		(* Test if third row is blank or a unit *)
		unit=ToExpression[columnData[[3]]];
		unitTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if third row is blank or a volume unit:",
			MatchQ[unit,VolumeP|Null],
			True
		];

		(* Test if rest of rows specify a number *)
		restRows=columnData[[4;;]];
		numericBools=MatchQ[#,""|GreaterEqualP[0.]]&/@restRows;
		numericTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if rows 4 to the end are numeric and greater than 0 or blank:",
			And@@numericBools,
			True
		];

		{sampleTest,unitTest,numericTest}
	]
];
transferOptionTests[]:=Function[{columnData,columnIndex},
	Module[{possibleOptions,key,keyTest},
		(* Test if the key is a transfer option *)
		possibleOptions=Keys[Options[Transfer]];
		key=columnData[[2]];
		keyTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if second row is a valid option for Transfer:",
			MemberQ[possibleOptions,key],
			True
		];

		{keyTest}
	]
];
incubateOptionTests[]:=Function[{columnData,columnIndex},
	Module[{possibleOptions,key,keyTest},
		(* Test if the key is an incubate option *)
		possibleOptions=Append[Keys[Options[Incubate]],""];
		key=columnData[[2]];
		keyTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if second row is a valid option for Incubate:",
			MemberQ[possibleOptions,key],
			True
		];

		{keyTest}
	]
];
waitTests[]:=Function[{columnData,columnIndex},
	Module[{key,keyTest,unit,unitTest,restRows,numericBools,numericTest},
		(* Make sure there is no wait option *)
		key=columnData[[2]];
		keyTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if second row is a empty:",
			MatchQ[key,""],
			True
		];

		(* Test if third row is a time unit *)
		unit=ToExpression[columnData[[3]]];
		unitTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if third row is a time unit:",
			MatchQ[unit,TimeP],
			True
		];

		(* Test if rest of rows specify a number greater than 0*)
		restRows=columnData[[4;;]];
		numericBools=MatchQ[#,""|GreaterEqualP[0.]]&/@restRows;
		numericTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if rows 4 to the end are numeric or blank:",
			And@@numericBools,
			True
		];

		{keyTest,unitTest,numericTest}
	]
];
mixOptionTests[]:=Function[{columnData,columnIndex},
	Module[{possibleOptions,key,keyTest},
		(* Test if the key is an incubate option *)
		possibleOptions=Append[Keys[Options[Mix]],""];
		key=columnData[[2]];
		keyTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if second row is a valid option for Mix:",
			MemberQ[possibleOptions,key],
			True
		];

		{keyTest}
	]
];
fillToVolumeTests[]:=Function[{columnData,columnIndex},
	Module[{sample,sampleTest,unit,unitTest,restRows,numericBools,numericTest},
		(* Test if second row is a sample *)
		sample=columnData[[2]];
		sampleTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if second row is a sample:",
			MatchQ[sample,ObjectP[{Object[Sample],Model[Sample]}]],
			True
		];

		(* Test if third row is a volume unit *)
		unit=ToExpression[columnData[[3]]];
		unitTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if third row is blank or a volume unit:",
			MatchQ[unit,VolumeP],
			True
		];

		(* Test if rest of rows specify a number greater than 0*)
		restRows=columnData[[4;;]];
		numericBools=MatchQ[#,""|GreaterEqualP[0.]]&/@restRows;
		numericTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if rows 4 to the end are numeric and greater than 0 or blank:",
			And@@numericBools,
			True
		];

		{sampleTest,unitTest,numericTest}
	]
];
centrifugeOptionTests[]:=Function[{columnData,columnIndex},
	Module[{possibleOptions,key,keyTest},
		(* Test if the key is a centrifuge option *)
		possibleOptions={"Time","Intensity","Temperature","Instrument"};
		key=columnData[[2]];
		keyTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if second row is a valid option for Centrifuge:",
			MemberQ[possibleOptions,key],
			True
		];

		{keyTest}
	]
];
readPlateTests[]:=Function[{columnData,columnIndex},
	Module[{secondRow,typeTest,thirdRow,emptyTest,restRows,validBools,validEntryTest},
		(* Test if second row is Type option *)
		secondRow=columnData[[2]];
		typeTest=Test["Column " <> ToString[columnIndex] <> ": Test if the second row is Type:",
			MatchQ["Type",secondRow],
			True
		];

		(* Test if third row is empty *)
		thirdRow=columnData[[3]];
		emptyTest=Test["Column " <> ToString[columnIndex] <> ": Test if the third row is left blank:",
			MatchQ[thirdRow,""],
			True
		];

		(* Test if the rest of the rows are either blank or a ReadPlateTypeP *)
		restRows=columnData[[4;;]];
		validBools=MatchQ[ToExpression[#],Alternatives[Null,ReadPlateTypeP]]&/@restRows;
		validEntryTest=Test["Column " <> ToString[columnIndex] <> ": Test if the rest of the rows are either blank or a ReadPlateTypeP:",
			And@@validBools,
			True
		];

		{typeTest,emptyTest,validEntryTest}
	]
];
readPlateOptionTests[]:=Function[{columnData,columnIndex},
	Module[{possibleOptions,key,keyTest},
		(* Test if the key is a ReadPlate option *)
		possibleOptions=Keys[Options[ReadPlate]];
		key=columnData[[2]];
		keyTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if second row is a valid option for ReadPlate:",
			MemberQ[possibleOptions,key],
			True
		];

		{keyTest}
	]
];
aliquotTests[]:=Function[{columnData,columnIndex},
	Module[{sample,sampleTest,unit,unitTest,restRows,numericBools,numericTest},
		(* Test if second row is a sample *)
		sample=columnData[[2]];
		sampleTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if second row is a sample:",
			MatchQ[sample,ObjectP[{Object[Sample],Model[Sample]}]],
			True
		];

		(* Test if third row is blank or a unit *)
		unit=ToExpression[columnData[[3]]];
		unitTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if third row is blank or a volume unit:",
			MatchQ[unit,VolumeP|Null],
			True
		];

		(* Test if rest of rows specify a number *)
		restRows=columnData[[4;;]];
		numericBools=MatchQ[#,""|GreaterEqualP[0.]]&/@restRows;
		numericTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if rows 4 to the end are numeric and greater than 0 or blank:",
			And@@numericBools,
			True
		];

		{sampleTest,unitTest,numericTest}
	]
];
aliquotOptionTests[]:=Function[{columnData,columnIndex},
	Module[{possibleOptions,key,keyTest},
		(* Test if the key is a aliquot option *)
		possibleOptions=Keys[Options[Aliquot]];
		key=columnData[[2]];
		keyTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if second row is a valid option for Aliquot:",
			MemberQ[possibleOptions,key],
			True
		];

		{keyTest}
	]
];
consolidationTests[]:=Function[{columnData,columnIndex},
	Module[{sample,sampleTest,unit,unitTest,restRows,numericBools,numericTest},
		(* Test if second row is a sample *)
		sample=columnData[[2]];
		sampleTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if second row is a sample:",
			MatchQ[sample,ObjectP[{Object[Sample],Model[Sample]}]],
			True
		];

		(* Test if third row is blank or a unit *)
		unit=ToExpression[columnData[[3]]];
		unitTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if third row is blank or a volume unit:",
			MatchQ[unit,VolumeP|Null],
			True
		];

		(* Test if rest of rows specify a number *)
		restRows=columnData[[4;;]];
		numericBools=MatchQ[#,""|GreaterEqualP[0.]]&/@restRows;
		numericTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if rows 4 to the end are numeric and greater than 0 or blank:",
			And@@numericBools,
			True
		];

		{sampleTest,unitTest,numericTest}
	]
];
consolidationOptionTests[]:=Function[{columnData,columnIndex},
	Module[{possibleOptions,key,keyTest,unit,unitTest,restRows,numericBools,numericTest},
		(* Test if the key is a consolidate option or another sample *)
		possibleOptions=Keys[Options[Consolidation]];
		key=columnData[[2]];
		keyTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if second row is a valid option for Aliquot:",
			MemberQ[possibleOptions,key],
			True
		];

		(* Test if the third row is a volume unit and the rest are positive numerics *)
		unit=ToExpression[columnData[[3]]];
		unitTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if third row is blank or a volume unit:",
			MatchQ[unit,VolumeP|Null],
			True
		];

		(* Test if rest of rows specify a number *)
		restRows=columnData[[4;;]];
		numericBools=MatchQ[#,""|GreaterEqualP[0.]]&/@restRows;
		numericTest=Test["Column " ~~ ToString[columnIndex] ~~ ": Test if rows 4 to the end are numeric and greater than 0 or blank:",
			And@@numericBools,
			True
		];

		(* If other samples are specified check the rest of the rows *)
		If[MatchQ[key,(NonSelfContainedSampleP | NonSelfContainedSampleModelP | ObjectP[{Model[Container, Vessel], Model[Container, ReactionVessel], Model[Container, Cuvette], Object[Container, Vessel], Object[Container, ReactionVessel], Object[Container, Cuvette]}] | {ObjectP[{Model[Container, Plate], Object[Container, Plate]}], WellP})],
			{unitTest,numericTest},
			(* Otherwise test if the key is valid *)
			{keyTest}
		]
	]
];



(* ::Subsection::Closed:: *)
(*ExperimentSampleManipulation Sister Functions (Options,Preview, ValidQ)*)


(* ::Subsubsection::Closed:: *)
(*ExperimentSampleManipulationOptions*)


DefineOptions[ExperimentSampleManipulationOptions,
	Options:>{
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table|List)],
			Description -> "Determines whether the function returns a table or a list of the options.",
			Category->"Protocol"
		}
	},
	SharedOptions :> {ExperimentSampleManipulation}
];

(* Overload with manipulation list: return the options for this function *)
ExperimentSampleManipulationOptions[myManipulations_,myOptions:OptionsPattern[]]:=Module[
	{listedOptions, preparedOptions,options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function *)
	preparedOptions = DeleteCases[listedOptions, (OutputFormat -> _) | (Output -> _)];

	(* pass to core function with Output->Options to return only the non-hidden Options for ExperimentSampleManipulation *)
	options = ExperimentSampleManipulation[myManipulations,Append[preparedOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentSampleManipulation],
		options
	]
];


(* ::Subsubsection::Closed:: *)
(*ExperimentSampleManipulationPreview*)


DefineOptions[ExperimentSampleManipulationPreview,
	SharedOptions :> {ExperimentSampleManipulation}
];

(* Manipulation list overload, return the preview for this function *)
ExperimentSampleManipulationPreview[myManipulations_,myOptions:OptionsPattern[ExperimentSampleManipulationPreview]]:=Module[
	{listedOptions, preparedOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function *)
	preparedOptions = DeleteCases[listedOptions, Output -> _];

	(* pass to core function with Output->Options to return only the Preview for ExperimentSampleManipulation *)
	ExperimentSampleManipulation[myManipulations,Append[preparedOptions, Output -> Preview]]
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentSampleManipulationQ*)


DefineOptions[ValidExperimentSampleManipulationQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentSampleManipulation}
];

ValidExperimentSampleManipulationQ[myManipulations:Except[{}],myOptions:OptionsPattern[]]:=Module[
	{listedOptions, preparedOptions, experimentSampleManipulationTests, initialTestDescription, allTests, verbose, outputFormat,allManipulationObjects},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	experimentSampleManipulationTests=ExperimentSampleManipulation[myManipulations,Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* pull out all Objects from the primitives for the VOQ testing *)
	allManipulationObjects= Module[
		{allSources,allDestinations,allObjectsInManipulations},

		(* get the source(s) and destination(s) of all manipulations;
		 	all manips have Source/Sources, but Mix/Incubate doesn't have Destination *)
		allSources=Map[
			Switch[#,
				_Consolidation,
					#[Sources],
				_Incubate,
					#[Sample],
				_Centrifuge,
					#[Sample],
				_Pellet|_MoveToMagnet|_RemoveFromMagnet,
					#[Sample],
				_,
					{#[Source]}
			]&,
			myManipulations
		];
		allDestinations=Map[
			Switch[#,
				_Transfer|_Consolidation|_FillToVolume,{#[Destination]},
				_Aliquot,#[Destinations],
				_Pellet,{#[ResuspensionSource],#[SupernatantDestination]},
				_,{}
			]&,
			myManipulations
		];

		(* combine into a full list; there may be some tags floating around, so delete _Symbol|_Integer *)
		allObjectsInManipulations=DeleteDuplicates[DeleteCases[Join[Flatten[allSources],Flatten[allDestinations]],_Symbol|_Integer]];

		(* return the instances at the first level of all objects *)
		Cases[allObjectsInManipulations,ObjectP[]]
	];

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[experimentSampleManipulationTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings, testResults},

		(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[allManipulationObjects, OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{allManipulationObjects, validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, experimentSampleManipulationTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidUnrestrictSamplesQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* TODO: update to call RunValidQTest once it will accept a flat list of tests *)
	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentSampleManipulationQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentSampleManipulationQ"]
];


DefineOptions[ValidFillToVolumePrimitiveQ,SharedOptions:>{{RunValidQTest,{Verbose, OutputFormat}}}];
ValidFillToVolumePrimitiveQ[myPrimitives:ListableP[_FillToVolume],myOptions:OptionsPattern[ValidFillToVolumePrimitiveQ]] :=
		ValidSampleManipulationPrimitiveQ[myPrimitives,myOptions];


DefineOptions[ValidTransferPrimitiveQ,SharedOptions:>{{RunValidQTest,{Verbose, OutputFormat}}}];
ValidTransferPrimitiveQ[myPrimitives:ListableP[_Transfer],myOptions:OptionsPattern[ValidTransferPrimitiveQ]] :=
		ValidSampleManipulationPrimitiveQ[myPrimitives,myOptions];
NewTransferP:=_?ValidTransferPrimitiveQ;


DefineOptions[ValidAliquotPrimitiveQ, SharedOptions :> {{RunValidQTest, {Verbose, OutputFormat}}}];
ValidAliquotPrimitiveQ[myPrimitives : ListableP[_Aliquot], myOptions : OptionsPattern[ValidAliquotPrimitiveQ]] :=
		ValidAliquotPrimitiveQ[myPrimitives,myOptions];


DefineOptions[ValidConsolidationPrimitiveQ,SharedOptions:>{{RunValidQTest,{Verbose, OutputFormat}}}];
ValidConsolidationPrimitiveQ[myPrimitives:ListableP[_Consolidation],myOptions:OptionsPattern[ValidConsolidationPrimitiveQ]] :=
		ValidConsolidationPrimitiveQ[myPrimitives,myOptions];


DefineOptions[ValidMixPrimitiveQ,SharedOptions:>{{RunValidQTest,{Verbose, OutputFormat}}}];
ValidMixPrimitiveQ[myPrimitives:ListableP[_Mix],myOptions:OptionsPattern[ValidMixPrimitiveQ]] :=
		ValidMixPrimitiveQ[myPrimitives,myOptions];


DefineOptions[ValidIncubatePrimitiveQ,SharedOptions:>{{RunValidQTest,{Verbose, OutputFormat}}}];
ValidIncubatePrimitiveQ[myPrimitives:ListableP[_Incubate],myOptions:OptionsPattern[ValidIncubatePrimitiveQ]] :=
		ValidIncubatePrimitiveQ[myPrimitives,myOptions];


DefineOptions[ValidMoveToMagnetPrimitiveQ,SharedOptions:>{{RunValidQTest,{Verbose,OutputFormat}}}];
ValidMoveToMagnetPrimitiveQ[myPrimitives:ListableP[_MoveToMagnet],myOptions:OptionsPattern[ValidMoveToMagnetPrimitiveQ]]:=
    ValidSampleManipulationPrimitiveQ[myPrimitives,myOptions];


DefineOptions[ValidRemoveFromMagnetPrimitiveQ,SharedOptions:>{{RunValidQTest,{Verbose,OutputFormat}}}];
ValidRemoveFromMagnetPrimitiveQ[myPrimitives:ListableP[_RemoveFromMagnet],myOptions:OptionsPattern[ValidRemoveFromMagnetPrimitiveQ]]:=
		ValidSampleManipulationPrimitiveQ[myPrimitives,myOptions];


NewFillToVolumeP:=_?ValidFillToVolumePrimitiveQ;
NewAliquotP:=_?ValidAliquotPrimitiveQ;
NewConsolidationP:=_?ValidConsolidationPrimitiveQ;
NewMixP:=_?ValidMixPrimitiveQ;
NewIncubateP:=_?ValidIncubatePrimitiveQ;
NewSampleManipulationP=_?ValidSampleManipulationPrimitiveQ;


DefineOptions[ValidSampleManipulationPrimitiveQ, SharedOptions :> {{RunValidQTest, {Verbose, OutputFormat}}}];
ValidSampleManipulationPrimitiveQ[
	myPrimitives:ListableP[Alternatives[_FillToVolume,_Incubate,_MoveToMagnet,_RemoveFromMagnet,_Transfer,_Aliquot,_Consolidation,_Mix,_Incubate,_Centrifuge,_Pellet]],
	myOptions:OptionsPattern[ValidIncubatePrimitiveQ]
]:=Module[{safeOps, verbose, output, listedPrimitives, boolResults, prepareTests},

(*deal with the options*)
	safeOps=SafeOptions[ValidSampleManipulationPrimitiveQ,ToList[myOptions]];
	{verbose,output}=Lookup[safeOps,{Verbose,OutputFormat}];

	(*convert the input to a list and strip the primitive head *)
	listedPrimitives=Last[#]&/@ToList[myPrimitives];

	(* basic tests ran when not asking for verbose output, this is quite a bit faster since running test does quite a bit longer *)
	boolResults=Map[
		With[{headLessPrimitive=Last[#]},
			Switch[#,

				_FillToVolume,
				And[
				(* Has to have Source, Destination and FinalVolume*)
					KeyExistsQ[headLessPrimitive,Source],
					KeyExistsQ[headLessPrimitive,Destination],
					KeyExistsQ[headLessPrimitive,FinalVolume],
				(* Required keys and their associated patterns*)
					MatchQ[Lookup[headLessPrimitive,Source],objectSpecificationP],
					MatchQ[Lookup[headLessPrimitive,Destination],objectSpecificationP],
					MatchQ[Lookup[headLessPrimitive,FinalVolume], GreaterEqualP[0 Microliter]],
				(* Optional keys and their associated patterns*)
					MatchQ[Lookup[headLessPrimitive,TransferType,Liquid],Liquid]
				],

				_Transfer,
				And[
				(* Have to have Source,Destination and FinalVolume*)
					KeyExistsQ[headLessPrimitive,Source],
					KeyExistsQ[headLessPrimitive,Destination],
					KeyExistsQ[headLessPrimitive,Amount],
				(* Required keys and their associated patterns*)
					MatchQ[Lookup[headLessPrimitive,Source],objectSpecificationP],
					MatchQ[Lookup[headLessPrimitive,Destination],objectSpecificationP],
					MatchQ[Lookup[headLessPrimitive,Amount],Alternatives[GreaterEqualP[0 Microliter],GreaterEqualP[0 Gram],GreaterEqualP[0,1]]],
				(* Optional keys and their associated patterns*)
					MatchQ[Lookup[headLessPrimitive,TransferType,Liquid],Alternatives[Liquid,Slurry,Solid]],
					MatchQ[Lookup[headLessPrimitive,Resuspension,True],BooleanP]
				],

				_Aliquot,
				And[
				(* Have to have Source,Destination and FinalVolume*)
					KeyExistsQ[headLessPrimitive,Source],
					KeyExistsQ[headLessPrimitive,Destinations],
					KeyExistsQ[headLessPrimitive,Amounts],
				(* Destinations and Amounts have to be the same Length*)
					SameQ[Length[Lookup[headLessPrimitive,Destinations]],Length[Lookup[headLessPrimitive,Amounts]]],
				(* Required keys and their associated patterns*)
					MatchQ[Lookup[headLessPrimitive,Source],objectSpecificationP],
					MatchQ[Lookup[headLessPrimitive,Destinations],{objectSpecificationP..}],
					MatchQ[Lookup[headLessPrimitive,Amounts],{(GreaterEqualP[0 Microliter]|GreaterEqualP[0 Gram]|GreaterEqualP[0, 1])..}],

				(* Optional keys and their associated patterns*)
					MatchQ[Lookup[headLessPrimitive,TransferType,Liquid],Alternatives[Liquid,Slurry,Solid]]
				],

				_Consolidation,
				And[
				(* Have to have Source,Destination and FinalVolume*)
					KeyExistsQ[headLessPrimitive,Sources],
					KeyExistsQ[headLessPrimitive,Destination],
					KeyExistsQ[headLessPrimitive,Amounts],
				(* Destinations and Amounts have to be the same Length*)
					SameQ[Length[Lookup[headLessPrimitive,Sources]],Length[Lookup[headLessPrimitive,Amounts]]],
				(* Required keys and their associated patterns*)
					MatchQ[Lookup[headLessPrimitive,Sources],{objectSpecificationP..}],
					MatchQ[Lookup[headLessPrimitive,Destination],objectSpecificationP],
					MatchQ[Lookup[headLessPrimitive,Amounts],{(GreaterEqualP[0 Microliter]|GreaterEqualP[0 Gram]|GreaterEqualP[0, 1])..}],

				(* Optional keys and their associated patterns*)
					MatchQ[Lookup[headLessPrimitive,TransferType,Liquid],Alternatives[Liquid,Slurry,Solid]]
				],

				_Mix,
				And[
				(* Have to have Source,Destination and FinalVolume*)
					KeyExistsQ[headLessPrimitive,Source],
					KeyExistsQ[headLessPrimitive,MixVolume],
					KeyExistsQ[headLessPrimitive,MixCount],
				(* Required keys and their associated patterns*)
					MatchQ[Lookup[headLessPrimitive,Source],ListableP[objectSpecificationP]],
					MatchQ[Lookup[headLessPrimitive,MixCount],GreaterEqualP[1]],

				(* Optional keys and their associated patterns*)
					MatchQ[Lookup[headLessPrimitive,MixType,Null],MixTypeP|Null],
					MatchQ[Lookup[headLessPrimitive,MixRate,Null],RPMP|Null],
					MatchQ[Lookup[headLessPrimitive,MixTime,Null],MixTypeP|Null]
				],

				_Incubate,
				And[
				(* Have to have Source,Destination and FinalVolume*)
					KeyExistsQ[headLessPrimitive,Sample],
					KeyExistsQ[headLessPrimitive,Time],
					KeyExistsQ[headLessPrimitive,Temperature],
					KeyExistsQ[headLessPrimitive,Preheat],
					KeyExistsQ[headLessPrimitive,ResidualIncubation],
					KeyExistsQ[headLessPrimitive,ResidualMix],

				(* Required keys and their associated patterns*)
					MatchQ[Lookup[headLessPrimitive,Sample],ListableP[objectSpecificationP]],
					MatchQ[Lookup[headLessPrimitive,Time],ListableP[GreaterEqualP[0 Minute]]],
					MatchQ[Lookup[headLessPrimitive,Temperature],ListableP[Ambient | TemperatureP]],
					MatchQ[Lookup[headLessPrimitive,Preheat],ListableP[BooleanP]],
					MatchQ[Lookup[headLessPrimitive,ResidualIncubation],ListableP[BooleanP]],
					MatchQ[Lookup[headLessPrimitive,ResidualMix],ListableP[BooleanP]],

				(* Optional keys and their associated patterns*)
					MatchQ[Lookup[headLessPrimitive,MixRate,Null],ListableP[RPMP|Null]],
					MatchQ[Lookup[headLessPrimitive,ResidualTemperature,Null],ListableP[Ambient|TemperatureP|Null]],
					MatchQ[Lookup[headLessPrimitive,ResidualMixRate,Null],ListableP[RPMP|Null]]

				],
				_Wait,
				KeyExistsQ[headLessPrimitive,Duration],
				_Centrifuge,
				KeyExistsQ[headLessPrimitive,Sample],
				_Pellet|_MoveToMagnet|_RemoveFromMagnet,
				KeyExistsQ[headLessPrimitive,Sample]
			]]&,myPrimitives
	];

	(* full tests to be ran via RunValidQTest (only with Verbose\[Rule]True) *)
	prepareTests[in_]:=Module[{headLessPrimitive},
		headLessPrimitive=Last[in];
		Switch[in,
			_FillToVolume,
			{
				Test["A FillToVolume primitive must have a Source key:",KeyExistsQ[headLessPrimitive,Source],True],
				Test["A FillToVolume primitive must have a Destination key:",KeyExistsQ[headLessPrimitive,Destination],True],
				Test["A FillToVolume primitive must have a FinalVolume key:",
					KeyExistsQ[headLessPrimitive,FinalVolume],
					True
				],
				Test["The Source value has to match (make a pattern for this?) pattern:",
					MatchQ[
						Lookup[headLessPrimitive,Source],
						objectSpecificationP
					],
					True
				],
				Test["The Destination value has to match pattern:",
					MatchQ[
						Lookup[headLessPrimitive,Destination],
						objectSpecificationP
					],
					True
				],
				Test["The Volume value has to match GreaterEqualP[0 Microliter]:",
					MatchQ[Lookup[headLessPrimitive,FinalVolume], GreaterEqualP[0 Microliter]],
					True
				],
				Test["The TransferType value to be Liquid or left unspecified:",
					MatchQ[Lookup[headLessPrimitive,TransferType,Liquid],Liquid],
					True
				]
			},
			_,
				{}
		]
	];

	(*either run the testing framework test (way slower but more informative ), or return the bool results (faster, will probably be mostly used as a pattern) *)
	If[
		MatchQ[verbose, True|Failures],
		RunValidQTest[
			myPrimitives,
			{prepareTests},
			PassOptions[ValidResourceQ,RunValidQTest,safeOps]
		],
		If[MatchQ[output,SingleBoolean],AllTrue[boolResults,TrueQ],boolResults]
	]

];



(* ::Subsubsection::Closed:: *)
(*tipsReachContainerBottomQ*)


(*
	This function takes in a device (a serological tip or a pipette) being used, a model container into which the device is being inserted and a list of packets of all possible tips
	This functions returns whether the specified this manipulation is possible with the device and tips provided
*)
tipsReachContainerBottomQ[
	myTips:ObjectReferenceP[Model[Item,Tips]],
	myContainerModelPacket:PacketP[Model[Container]],
	myTipPackets:{PacketP[Model[Item,Tips]]..}
]:=Module[
	{tipPacket,sourceAperture,sourceDepth,aspirationDepthsAtApertures,aspirationDepthAtClosestAperture,
		maxDepthTipsCanReach,sortedAspirationDepthsAtApertures},

	(* get the packet of the tips we're using; pull AspirationDepth out of that *)
	tipPacket=SelectFirst[myTipPackets,MatchQ[Lookup[#,Object],Download[myTips,Object]]&];
	aspirationDepthsAtApertures=Lookup[tipPacket,AspirationDepth];

	(* TODO handle other container model types *)
	{sourceAperture,sourceDepth}=Switch[myContainerModelPacket,
		PacketP[{Model[Container,Vessel],Model[Container,Cuvette]}],Lookup[myContainerModelPacket,{Aperture,InternalDepth}],
		(* MALDI Plate position is very small but it does not have a well and tips do not need to go to the "bottom" of the plate since the liquid is just touching the surface *)
		PacketP[{Model[Container,Plate,MALDI]}],{
			Min[DeleteCases[Flatten@Lookup[myContainerModelPacket,{WellDimensions,WellDiameter}],Null]],
			0Meter
		},
		PacketP[Model[Container,Plate,Irregular]],{
			Min[DeleteCases[Flatten@Lookup[myContainerModelPacket,{WellPositionDimensions,WellDiameters}],Null]],
			Max[Lookup[myContainerModelPacket,WellDepths]]
		},
		PacketP[Model[Container,Plate]],{
			Min[DeleteCases[Flatten@Lookup[myContainerModelPacket,{WellDimensions,WellDiameter}],Null]],
			Lookup[myContainerModelPacket,WellDepth]
		},
		_,{Null,Null}
	];

	(* If any information is missing, assume the tips can reach the bottom rather than throwing an error and stopping the protocol *)
	(* All info is required by VOQ, so this shouldn't happen *)
	If[
		Or[
			MatchQ[aspirationDepthsAtApertures,{}],
			MatchQ[sourceDepth,NullP],
			MatchQ[sourceAperture,NullP]
		],
		Return[True]
	];

	(* Sort the {{aperture,aspiration depth}..} list by aperture*)
	sortedAspirationDepthsAtApertures=Prepend[SortBy[aspirationDepthsAtApertures,First],{0 Meter,0 Meter}];

	(* Get the last entry with an aperture larger than that of the source aperture *)
	aspirationDepthAtClosestAperture=Last[DeleteCases[
		sortedAspirationDepthsAtApertures,
		_?(First[#]>sourceAperture &)
	]];

	(* Get the aspiration depth for that entry *)
	maxDepthTipsCanReach=Last[aspirationDepthAtClosestAperture];

	(* Check if the aspiration depth is larger than the source depth, indicating tips can reach bottom *)
	maxDepthTipsCanReach>=sourceDepth
];



(* ::Subsubsection:: *)
(*pipetForTips*)


(*The preferred tip to be used for each pipette type*)
pipetForTips[Model[Item,Tips,"id:8qZ1VW0Vx7jP"]]:=Model[Instrument,Pipette,"id:54n6evLmRbaY"]; (* "Eppendorf Research Plus P2.5", "0.1 - 10 uL Tips, Low Retention, Non-Sterile" *)
pipetForTips[Model[Item,Tips,"id:6V0npvmNkmJe"]]:=Model[Instrument,Pipette,"id:54n6evLmRbaY"]; (* "Eppendorf Research Plus P2.5", "0.1 - 10 uL Tips, Low Retention, Sterile" *)
pipetForTips[Model[Item,Tips,"id:rea9jl1or6YL"]]:=Model[Instrument,Pipette,"id:n0k9mG8Pwod4"]; (* "Eppendorf Research Plus P20", "Olympus 20 ul Filter tips, sterile" *)
pipetForTips[Model[Item,Tips,"id:4pO6dMWvnAlB"]]:=Model[Instrument,Pipette,"id:01G6nvwRpbLd"]; (* "Eppendorf Research Plus P200", "200 ul Towerpacks, non-sterile" *)
pipetForTips[Model[Item,Tips,"id:P5ZnEj4P88jR"]]:=Model[Instrument,Pipette,"id:01G6nvwRpbLd"]; (* "Eppendorf Research Plus P200", "Olympus 200 ul tips, sterile" *)
pipetForTips[Model[Item,Tips,"id:L8kPEjNLDpa6"]]:=Model[Instrument,Pipette,"id:01G6nvwRpbLd"]; (* "Eppendorf Research Plus P200", "200 ul wide-bore tips"*)
pipetForTips[Model[Item,Tips,"id:WNa4ZjKxLnNL"]]:=Model[Instrument,Pipette,"id:01G6nvwRpbLd"]; (* "Eppendorf Research Plus P200", "200 uL gel loading tips"*)
pipetForTips[Model[Item,Tips,"id:n0k9mGzRaaN3"]]:=Model[Instrument,Pipette,"id:1ZA60vL547EM"]; (* "Eppendorf Research Plus P1000", "1000 ul reach tips, sterile" *)
pipetForTips[Model[Item,Tips,"id:8qZ1VWNw1z0X"]]:=Model[Instrument,Pipette,"id:1ZA60vL547EM"]; (* "Eppendorf Research Plus P1000", "1000 ul wide-bore tips" *)
pipetForTips[Model[Item,Tips,"id:mnk9jO3qD6R7"]]:=Model[Instrument,Pipette,"id:KBL5Dvw6eLDk"]; (* "Eppendorf Research Plus P5000", "D5000 TIPACK 5 ml tips" *)
pipetForTips[Model[Item,Tips,"id:WNa4ZjKROWBE"]]:=Model[Instrument, Pipette, "id:E8zoYvNe7LNv"];(* "Pos-D MR-1000", "1000 uL positive displacement tips, sterile" *)
pipetForTips[Model[Item,Tips,"id:P5ZnEjd4eYJn"]]:=Model[Instrument, Pipette, "id:Y0lXejMGAmr1"];(* "Pos-D MR-100", "100 uL positive displacement tips, sterile" *)
pipetForTips[Model[Item,Tips,"id:1ZA60vwjbRmw"]]:=Model[Instrument, Pipette, "id:1ZA60vL547EM"];(* "Eppendorf Research Plus P1000", ""1000 uL tips, non-sterile"" *)
pipetForTips[Model[Item, Tips, "id:eGakldJR8D9e"]]:=Model[Instrument, Pipette, "id:1ZA60vL547EM"];(*"Eppendorf Research Plus P1000","1000 uL reach tips, non-sterile"*)
pipetForTips[Model[Item, Tips, "id:O81aEBZDpVzN"]]:=Model[Instrument, Pipette, "id:01G6nvwRpbLd"];(*"Eppendorf Research Plus P200","200 uL tips, non-sterile"*)

pipetForTips[Model[Item,Tips,"id:WNa4ZjRr5ljD"]|Model[Item,Tips,"id:01G6nvkKr5Em"]|Model[Item,Tips,"id:zGj91aR3d6MJ"]|Model[Item,Tips,"id:R8e1PjRDbO7d"]|Model[Item,Tips,"id:P5ZnEj4P8q8L"]|Model[Item,Tips,"id:aXRlGnZmOJdv"]|Model[Item,Tips,"id:D8KAEvdqzb8b"]|Model[Item,Tips, "id:kEJ9mqaVP6nV"]|Model[Item,Tips,"id:XnlV5jmbZLwB"]|Model[Item,Tips,"id:pZx9jonGJmkp"]|Model[Item,Tips,"id:Vrbp1jG80zpm"]]:=Model[Instrument,Pipette,"id:3em6ZvLlDkBY"]
