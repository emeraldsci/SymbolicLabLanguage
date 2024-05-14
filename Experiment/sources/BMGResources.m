(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*BMG Resources *)


(* ::Subsubsection:: *)


(* ::Subsection:: *)
(*Patterns*)
PlateReaderUnitOperationTypes={
	Object[UnitOperation, AbsorbanceIntensity],
	Object[UnitOperation, AbsorbanceKinetics],
	Object[UnitOperation, AbsorbanceSpectroscopy],
	Object[UnitOperation, AlphaScreen],
	Object[UnitOperation, FluorescenceIntensity],
	Object[UnitOperation, FluorescenceKinetics],
	Object[UnitOperation, FluorescencePolarizationKinetics],
	Object[UnitOperation, FluorescencePolarization],
	Object[UnitOperation, FluorescenceSpectroscopy],
	Object[UnitOperation, LuminescenceIntensity],
	Object[UnitOperation, LuminescenceKinetics],
	Object[UnitOperation, LuminescenceSpectroscopy],
	Object[UnitOperation, NephelometryKinetics],
	Object[UnitOperation, Nephelometry]
};

(* ::Subsection:: *)
(*Shared Plate Reader Options*)


DefineOptionSet[
	PlateReaderMixOptions:>{
		{
			OptionName->PlateReaderMix,
			Default->Automatic,
			Description->"Indicates if samples should be mixed inside the plate reader chamber.",
			ResolutionDescription->"Automatically set to True if any other plate reader mix options are specified.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Category->"Sample Handling"
		},
		{
			OptionName->PlateReaderMixTime,
			Default->Automatic,
			Description->"The amount of time samples should be mixed inside the plate reader chamber.",
			ResolutionDescription->"Automatically set to 30 second if any other plate reader mix options are specified.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Second,1 Hour],Units:>{1,{Second,{Second,Minute,Hour}}}],
			Category->"Sample Handling"
		},
		{
			OptionName->PlateReaderMixRate,
			Default->Automatic,
			Description->"The rate at which the plate should be agitated inside the plate reader chamber.",
			ResolutionDescription->"Automatically set to 700 RPM if any other plate reader mix options are specified.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[100 RPM,700 RPM],Units:>RPM],
			Category->"Sample Handling"
		},
		{
			OptionName->PlateReaderMixMode,
			Default->Automatic,
			Description->"The pattern of motion which should be employed to shake the plate.",
			ResolutionDescription->"Automatically set to DoubleOrbital if any other plate reader mix options are specified.",
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>MechanicalShakingP],
			Category->"Sample Handling"
		}
	}
];

DefineOptionSet[
	PlateReaderMixScheduleOption:>{
		{
			OptionName->PlateReaderMixSchedule,
			Default->Automatic,
			Description->"Indicates the points at which mixing should occur in the plate reader, for instance after every set of injections.",
			ResolutionDescription->"Automatically set to AfterInjections when other mix options are set and injections are specified or to BetweenReadings when mixing is specified but there are no injections.",
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>MixingScheduleP],
			Category->"Sample Handling"
		}
	}
];

DefineOptionSet[
	EvaporationOptions:>
		{
			{
				OptionName->MoatSize,
				Default->Automatic,
				Description->"Indicates the number of concentric perimeters of wells to fill with MoatBuffer in order to slow evaporation of inner assay samples.",
				ResolutionDescription->"Automatically set to 1 if any other moat options are specified.",
				AllowNull->True,
				Widget->Widget[Type->Number,Pattern:>GreaterP[0,1]],
				Category->"Sample Handling"
			},
			{
				OptionName->MoatVolume,
				Default->Automatic,
				Description->"Indicates the volume to add to to each moat well.",
				ResolutionDescription->"Automatically set to the RecommendedFillVolume of the assay plate if informed, or 75% of the MaxVolume of the assay plate if not, if any other moat options are specified.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1 Microliter,300*Microliter],
					Units->Microliter
				],
				Category->"Sample Handling"
			},
			{
				OptionName->MoatBuffer,
				Default->Automatic,
				Description->"Indicates the sample to use to fill each moat well.",
				ResolutionDescription->"Automatically set to Milli-Q water if any other moat options are specified.",
				AllowNull->True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
				Category->"Sample Handling"
			},
			{
				OptionName->RetainCover,
				Default->False,
				Description->"Indicates if the plate seal or lid on the assay container should not be taken off during measurement to decrease evaporation. When this option is set to True, injections cannot be performed as it's not possible to inject samples through the cover. When using the Cuvette Method, automatically set to True.",
				AllowNull->False,
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
				Category->"Sample Handling"
			}
		}
];

DefineOptionSet[
	BMGSamplingOptions:>{
		{
			OptionName -> SamplingPattern,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> PlateReaderSamplingP],
			Description -> "Indicates where in the well measurements are taken.",
			Category -> "Sampling"
		},
		{
			OptionName -> SamplingDistance,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1 Millimeter, 6 Millimeter], Units -> Micrometer],
			Description -> "Indicates the length of the region over which sampling measurements are taken.",
			ResolutionDescription -> "Automatically resolves to Null if SamplingPattern is set to Center otherwise resolves to 80% of the diameter of the well.",
			Category -> "Sampling"
		},
		{
			OptionName -> SamplingDimension,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type->Number,Pattern:>RangeP[2, 30]],
			Description -> "Specifies the size of the grid used for Matrix sampling. For example SamplingDimension->5 will scan a 5 x 5 grid.",
			ResolutionDescription -> "If the SamplingPattern is set to Matrix, SamplingDimension will be set to 3.",
			Category -> "Sampling"
		}
	}
];



(*resolveMoatOptions*)

(* container packet should contain MaxVolume and RecommendedFillVolume *)
resolveMoatOptions[
	myType:(Object[Protocol, Nephelometry] | Object[Protocol, NephelometryKinetics ] | Object[Protocol, CircularDichroism]|
		Object[Protocol, FluorescenceIntensity] | Object[Protocol, FluorescenceKinetics] | Object[Protocol, FluorescenceSpectroscopy] |
		Object[Protocol, LuminescenceIntensity] | Object[Protocol, LuminescenceKinetics] | Object[Protocol, LuminescenceSpectroscopy] |
		Object[Protocol, FluorescencePolarization] | Object[Protocol, FluorescencePolarizationKinetics]|
		Object[Protocol, AbsorbanceSpectroscopy] | Object[Protocol, AbsorbanceIntensity] | Object[Protocol, AbsorbanceKinetics] |
      	Object[Protocol, AlphaScreen]),
	containerModelPacket:ListableP[PacketP[Model[Container]]],
	moatBuffer:ObjectP[{Object[Sample],Model[Sample]}]|Null|Automatic,
	moatVolume:_Quantity|Null|Automatic,
	moatSize:_Integer|Null|Automatic
]:=Module[{impliedMoat,defaultMoatBuffer,defaultMoatVolume,defaultMoatSize,fillVolume,maxVolume,fillVolumeList,maxVolumeList,
	resolvedMoatBuffer,resolvedMoatVolume,resolvedMoatSize,circularDichroismQ,containerMaterial,quartzPlateQ,defaultQuartzCDMoatSize},

	(* if the options are a mixture of Automatic and specified (i.e. there are no Nulls on the list), it is implied that a user wants a moat. Conflicting options are determined in the function validMoat.  *)
	impliedMoat=AllTrue[{moatSize,moatBuffer,moatVolume},MatchQ[Except[Null|0]]];

	(* check the type of the protocol we are resolving for: build a shorthand for circular dichroism*)
	circularDichroismQ=MatchQ[myType, TypeP[Object[Protocol, CircularDichroism]]];

	(* lookup the recommended fill volume and max volume and make sure it's in a list *)
	fillVolume = Flatten[{Lookup[containerModelPacket,RecommendedFillVolume]}];
	maxVolume = Flatten[{Lookup[containerModelPacket,MaxVolume]}];

	(* Extract Plate Material *)
	containerMaterial = Flatten[{Lookup[containerModelPacket,ContainerMaterials]}];

	(* build a short hand if we are using quartz as the read plate *)
	quartzPlateQ=MemberQ[containerMaterial,Quartz];

	(* pick the values from the list that are volumes in case there are any Nulls *)
	fillVolumeList = PickList[fillVolume,VolumeQ[fillVolume]];
	maxVolumeList = PickList[maxVolume,VolumeQ[maxVolume]];

	(* Set the defaults for the moats *)
	defaultMoatBuffer=Model[Sample,"Milli-Q water"];

	defaultMoatVolume=Which[
		(* if there are volumes on the recommended fill volume list, use the first volume on that list *)
		MatchQ[fillVolumeList,{VolumeP..}],First[fillVolumeList],
		(* if there are volumes on the max volume list, use 75% of the first volume on that list *)
		MatchQ[maxVolumeList,{VolumeP..}],SafeRound[0.75*First[maxVolumeList],1Microliter],
		(* if none of those volumes are informed, default to 50 microliters *)
		True,50*Microliter
	];

	(* set the default quartz plate size *)
	defaultMoatSize=1;

	(* for the quartz plate in CD defalut it to 2*)
	defaultQuartzCDMoatSize=2;

	{resolvedMoatBuffer,resolvedMoatVolume,resolvedMoatSize}=If[
		circularDichroismQ,

		(*For quarzt plate in CicrularDichroism, we need moat since the out-most layer of the plate cannot be used for CD-detection, but we don't really need to add buffer into those plate*)

		Switch[{impliedMoat,quartzPlateQ},
			{True,True},
			Flatten[{
				If[MatchQ[moatBuffer,(Null|Automatic)],

					(*If impliedMoat but no buffer, resolve Automatic moat volume to Null*)
					{
						Replace[moatBuffer,Automatic->If[MatchQ[moatVolume,VolumeP],defaultMoatBuffer,Null]],
						Replace[moatVolume,Automatic->Null]
					},
					{
						Replace[moatBuffer, Automatic -> defaultMoatBuffer],
						Replace[moatVolume, Automatic -> defaultMoatVolume]
					}
				],
				Replace[moatSize,Automatic->defaultQuartzCDMoatSize]
			}],
			{True,_},
			{
				Replace[moatBuffer,Automatic->defaultMoatBuffer],
				Replace[moatVolume,Automatic->defaultMoatVolume],
				Replace[moatSize,Automatic->defaultMoatSize]
			},
			{_,True},

			(* need moat for quartz plate, but don't need buffer solvent*)
			{
				Replace[moatBuffer,Automatic->Null],
				Replace[moatVolume,Automatic->Null],
				Replace[moatSize,Automatic->defaultQuartzCDMoatSize]
			},
			_,
			{
				Replace[moatBuffer,Automatic->Null],
				Replace[moatVolume,Automatic->Null],
				Replace[moatSize,Automatic->Null]
			}

		],

		(* resolve for Object[Protocol, Nephelometry] | Object[Protocol, NephelometryKinetics ]*)
		If[impliedMoat&&!MatchQ[{moatBuffer,moatVolume,moatSize},{Automatic, Automatic, Automatic}],
			{
				Replace[moatBuffer,Automatic->defaultMoatBuffer],
				Replace[moatVolume,Automatic->defaultMoatVolume],
				Replace[moatSize,Automatic->defaultMoatSize]
			},
			{
				Replace[moatBuffer,Automatic->Null],
				Replace[moatVolume,Automatic->Null],
				Replace[moatSize,Automatic->Null]
			}
		]
	];

	{resolvedMoatBuffer,resolvedMoatVolume,resolvedMoatSize}
];

(*Overload the function: when ContainerPacket Failed to download from the main packet, the input container packet should be {}, in this case return {Null,Null,Null}*)
resolveMoatOptions[
	myType : (Object[Protocol, Nephelometry] | Object[Protocol, NephelometryKinetics ] | Object[Protocol, CircularDichroism]),
	{},
	moatBuffer:ObjectP[{Object[Sample],Model[Sample]}]|Null|Automatic,
	moatVolume:_Quantity|Null|Automatic,
	moatSize:_Integer|Null|Automatic
]:= {Null,Null,Null};

(*Overload the function: when ContainerPacked Failed to be donwnload from the main packet, the input container packet should be {}, in this case return {Null,Null,Null}*)
resolveMoatOptions[
	myType : (Object[Protocol, Nephelometry] | Object[Protocol, NephelometryKinetics ] | Object[Protocol, CircularDichroism]),
	<||>,
	moatBuffer:ObjectP[{Object[Sample],Model[Sample]}]|Null|Automatic,
	moatVolume:_Quantity|Null|Automatic,
	moatSize:_Integer|Null|Automatic
]:= {Null,Null,Null};

(*Overload the function: when we have no assay plate model packet, the input container packet should be Null, in this case return {Null,Null,Null}*)
resolveMoatOptions[
	myType : Object[Protocol, AlphaScreen],
	Null,
	moatBuffer:ObjectP[{Object[Sample],Model[Sample]}]|Null|Automatic,
	moatVolume:_Quantity|Null|Automatic,
	moatSize:_Integer|Null|Automatic
]:= {Null,Null,Null};