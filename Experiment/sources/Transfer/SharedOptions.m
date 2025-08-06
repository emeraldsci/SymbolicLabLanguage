(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section::Closed:: *)
(* TransferSharedOptions *)

(* ::Subsection::Closed:: *)
(* TransferDestinationWellOption *)

DefineOptionSet[TransferDestinationWellOption :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName -> DestinationWell,
			Default -> Automatic,
			ResolutionDescription -> "Automatically set to the position of the given Object[Sample]. Otherwise, is set to the first empty well of the container. Otherwise, is set to \"A1\".",
			AllowNull -> False,
			Widget -> Alternatives[
				Widget[
					Type -> String,
					Pattern :> WellPositionP,
					Size->Line,
					PatternTooltip -> "Enumeration must be any well from A1 to H12."
				],
				Widget[
					Type -> String,
					Pattern :> LocationPositionP,
					PatternTooltip -> "Any valid container position.",
					Size->Line
				]
			],
			Description -> "The position in the destination container in which the source sample will be placed.",
			Category->"General"
		}
	]
}];

(* ::Subsection::Closed:: *)
(* TransferInstrumentOption *)

DefineOptionSet[TransferInstrumentOption :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName -> Instrument,
			Default -> Automatic,
			ResolutionDescription -> "Automatically set to an instrument that can move the amount being transferred and the source and destination containers of the transfer. For more information, please refer to the function TransferDevices[].",
			AllowNull -> True, (* Instrument will be Null if pouring, for example. *)
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{
					Model[Container, Syringe],
					Model[Container, GraduatedCylinder],
					Model[Instrument, Pipette],
					Model[Instrument, Aspirator],
					Model[Item, Spatula],
					Model[Item, Tweezer],
					Model[Item, TransferTube],
					Model[Item, ChippingHammer],
					Model[Item, Scissors],

					Object[Container, Syringe],
					Object[Container, GraduatedCylinder],
					Object[Instrument, Pipette],
					Object[Instrument, Aspirator],
					Object[Item, Spatula],
					Object[Item, Tweezer],
					Object[Item, TransferTube],
					Object[Item, ChippingHammer],
					Object[Item, Scissors]
				}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Instruments",
						"Liquid Handling"
					},
					{
						Object[Catalog, "Root"],
						"Labware",
						"Transfer Aids"
					}
				}
			],
			Description -> "The standalone instrument used to transfer the sample from the source container (or from the intermediate container if IntermediateDecant->True) to the destination container. If this option is set to Null, it indicates that pouring will be done to perform the transfer when Preparation->Manual.",
			Category -> "Instrument Specifications"
		}
	]
}];


(* ::Subsection::Closed:: *)
(* MultichannelTransferOptions *)

DefineOptionSet[MultichannelTransferOptions :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName -> MultichannelTransfer,
			Default -> Automatic,
			ResolutionDescription -> "Automatically set to True if (1) the samples are in a plate, (2) the samples to be transferred before/after this sample are in the same row or well of the plate, (3) the volume of the samples to be transferred is the same, and (4) the spacing of the wells in the plate are compatible with the spacing between the channels in the pipette (HorizontalPitch/VerticalPitch/ChannelOffset).",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if this transfer will occur simultaneously with the other transfer that occur before/after it, up to the number of channels that are available in the pipette chosen via the Instrument option.",
			Category->"General"
		},
		{
			OptionName -> MultichannelTransferName,
			Default -> Automatic,
			ResolutionDescription -> "Automatically set to a unique identifier that indicates that the transfers occur during the same time if MultichannelTransfer->True.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> String,
				Pattern :> _String,
				Size -> Line
			],
			Description -> "The unique identitifer for the multichannel transfer.",
			Category -> "Hidden"
		},
		{
			OptionName -> MultiProbeHeadNumberOfRows,
			Default -> Automatic,
			ResolutionDescription -> "Automatically set to the number of rows used for this transfer group.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[0,8,1]
			],
			Description -> "The number of rows used for this manipulation with the multiprobe head.",
			Category -> "Hidden"
		},
		{
			OptionName -> MultiProbeHeadNumberOfColumns,
			Default -> Automatic,
			ResolutionDescription -> "Automatically set to the number of columns used for this transfer group.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[0,12,1]
			],
			Description -> "The number of columns used for this manipulation with the multiprobe head.",
			Category -> "Hidden"
		},
		{
			OptionName -> MultiProbeAspirationOffsetRows,
			Default -> Automatic,
			ResolutionDescription -> "Automatically set to the row offset of the mutiprobe head that is required to perform the aspiration for this transfer group.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[-16,16,1]
			],
			Description -> "The row offset used for the aspiration with the multiprobe head (0 means that A1 of the multiprobe head will aspirate from A1 of the plate, 1 means that A1 of the multiprobe head will aspirate from B1, -1 means that B1 of the multiprobe head will aspirate from the A1 of the plate).",
			Category -> "Hidden"
		},
		{
			OptionName -> MultiProbeAspirationOffsetColumns,
			Default -> Automatic,
			ResolutionDescription -> "Automatically set to the column offset of the mutiprobe head that is required to perform the aspiration for this transfer group.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[-24,24,1]
			],
			Description -> "The column offset used for the aspiration with the multiprobe head (0 means that A1 of the multiprobe head will aspirate from A1 of the plate, 1 means that A1 of the multiprobe head will aspirate from A2, -1 means that A2 of the multiprobe head will aspirate from the A1 of the plate).",
			Category -> "Hidden"
		},
		{
			OptionName -> MultiProbeDispenseOffsetRows,
			Default -> Automatic,
			ResolutionDescription -> "Automatically set to the row offset of the mutiprobe head that is required to perform the dispense for this transfer group.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[-16,16,1]
			],
			Description -> "The row offset used for dispensing with the multiprobe head (0 means that A1 of the multiprobe head will dispense into A1 of the plate, 1 means that A1 of the multiprobe head will dispense into B1 of the plate, -1 means that B1 of the multiprobe head will dispense into A1 of the plate).",
			Category -> "Hidden"
		},
		{
			OptionName -> MultiProbeDispenseOffsetColumns,
			Default -> Automatic,
			ResolutionDescription -> "Automatically set to the column offset of the mutiprobe head that is required to perform the dispense for this transfer group.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[-24,24,1]
			],
			Description -> "The column offset used for dispensing with the multiprobe head (0 means that A1 of the multiprobe head will dispense into A1 of the plate, 1 means that A1 of the multiprobe head will dispense into A2 of the plate, -1 means that A2 of the multiprobe head will dispense into A1 of the plate).",
			Category -> "Hidden"
		}
	]
}];

(* ::Subsection::Closed:: *)
(* TransferCoverOptions *)

DefineOptionSet[TransferCoverOptions :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName->KeepSourceCovered,
			Default->Automatic,
			ResolutionDescription->"Automatically set to True if Preparation->Manual. If Preparation->Robotic, set based on the KeepCovered field in Object[Sample]/Object[Container] for the source sample/container, or True if SterileTechnique is True.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if the cover on the source container should be \"peaked\" off when transferred into/out of instead of taken off completely when performing Manual Transfers in order to reduce chances of contamination or minimize light exposure. When performing robotic manipulations, this indicates that the container should be re-covered after any manipulation that uncovers it is completed.",
			Category->"Container Covering"
		},
		{
			OptionName -> ReplaceSourceCover,
			Default -> False,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if the cover on the source container will be replaced at the end of the transfer with a new type of cover. If set to False, the previous cover (or a new instance of the previous cover if the previous cover is not reusable) will be used to cover the container after the transfer occurs.",
			ResolutionDescription -> "Automatically set to True if any of the SourceCover options are specified.",
			Category->"Container Covering"
		},
		{
			OptionName -> SourceCover,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[Join[CoverObjectTypes, CoverModelTypes]],
				PreparedSample -> False,
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Containers",
						"Caps"
					},
					{
						Object[Catalog, "Root"],
						"Containers",
						"Plate Lids & Seals"
					}
				}
			],
			Description -> "The new cover that will be placed on the source container after the transfer occurs. By default, this option is set to Null which indicates that the previous cover will be used.",
			ResolutionDescription -> "Automatically set to a cover that is compatible with the source container if ReplaceSourceCover->True.",
			Category->"Container Covering"
		},
		{
			OptionName -> SourceSeptum,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Item, Septum], Object[Item, Septum]}],
				PreparedSample -> False,
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Containers",
						"Caps",
						"Septa Caps"
					}
				}
			],
			Description -> "The new septum that will be placed on the source container after the transfer occurs. By default, this option is set to Null which indicates that the previous septum will be used (if there was previously a septum on the container). This option can only be set if a new SourceCover is to be used and that SourceCover is a Model[Item, Cap]/Object[Item, Cap] that has CoverType->Crimp and SeptumRequired->True.",
			ResolutionDescription -> "Automatically set to a septum that is compatible with the source container if ReplaceSourceCover->True.",
			Category->"Container Covering"
		},
		{
			OptionName -> SourceStopper,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Item, Stopper], Object[Item, Stopper]}],
				PreparedSample -> False
			],
			Description -> "The new stopper that will be placed on the source container after the transfer occurs. By default, this option is set to Null which indicates that the previous stopper will be used (if there was previously a stopper on the container). This option can only be set if a new SourceCover is to be used and that SourceCover is a Model[Item, Cap]/Object[Item, Cap] that has CoverType->Crimp.",
			ResolutionDescription -> "Automatically set to a stopper that is compatible with the source container if ReplaceSourceCover->True.",
			Category->"Container Covering"
		},
		{
			OptionName->KeepDestinationCovered,
			Default->Automatic,
			ResolutionDescription->"Automatically set to True if Preparation->Manual. If Preparation->Robotic, set based on the KeepCovered field in Object[Sample]/Object[Container] for the destination sample/container, or True if SterileTechnique is True.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if the cover on the destination container should be \"peaked\" off when transferred into/out of instead of taken off completely when performing Manual Transfers in order to reduce chances of contamination or minimize light exposure. When performing robotic manipulations, this indicates that the container should be re-covered after any manipulation that uncovers it is completed.",
			Category->"Container Covering"
		},
		{
			OptionName -> ReplaceDestinationCover,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if the cover on the destination container will be replaced at the end of the transfer with a new type of cover. If set to False, the previous cover (or a new instance of the previous cover if the previous cover is not reusable) will be used to cover the container after the transfer occurs.",
			ResolutionDescription -> "Automatically set to True if any of the DestinationCover options are specified.",
			Category->"Container Covering"
		},
		{
			OptionName -> DestinationCover,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[Join[CoverObjectTypes, CoverModelTypes]],
				PreparedSample -> False,
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Containers",
						"Caps"
					},
					{
						Object[Catalog, "Root"],
						"Containers",
						"Plate Lids & Seals"
					}
				}
			],
			Description -> "The new cover that will be placed on the destination container after the transfer occurs. By default, this option is set to Null which indicates that the previous cover will be used.",
			ResolutionDescription -> "Automatically set to a cover that is compatible with the destination container if ReplaceDestinationCover->True.",
			Category->"Container Covering"
		},
		{
			OptionName -> DestinationSeptum,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Item, Septum], Object[Item, Septum]}],
				PreparedSample -> False,
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Containers",
						"Caps",
						"Septa Caps"
					}
				}
			],
			Description -> "The new septum that will be placed on the destination container after the transfer occurs. By default, this option is set to Null which indicates that the previous septum will be used (if there was previously a septum on the container). This option can only be set if a new DestinationCover is to be used and that DestinationCover is a Model[Item, Cap]/Object[Item, Cap] that has SeptumRequired->True.",
			ResolutionDescription -> "Automatically set to a septum that is compatible with the destination container if ReplaceDestinationCover->True.",
			Category->"Container Covering"
		},
		{
			OptionName -> DestinationStopper,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Item, Stopper], Object[Item, Stopper]}],
				PreparedSample -> False
			],
			Description -> "The new stopper that will be placed on the destination container after the transfer occurs. By default, this option is set to Null which indicates that the previous stopper will be used (if there was previously a stopper on the container). This option can only be set if a new DestinationCover is to be used and that DestinationCover is a Model[Item, Cap]/Object[Item, Cap] that has CoverType->Crimp.",
			ResolutionDescription -> "Automatically set to a stopper that is compatible with the destination container if ReplaceDestinationCover->True.",
			Category->"Container Covering"
		}
	]
}];

(* ::Subsection::Closed:: *)
(* TransferEnvironmentOption *)

DefineOptionSet[TransferEnvironmentOption :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName->TransferEnvironment,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to an instrument that can handle the any safety requirements of the samples being transferred.",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{
					Model[Instrument, BiosafetyCabinet],
					Model[Instrument, FumeHood],
					Model[Instrument, GloveBox],
					Model[Container, Bench],
					Model[Container, Enclosure],
					Object[Instrument, BiosafetyCabinet],
					Object[Instrument, FumeHood],
					Object[Instrument, GloveBox],
					Object[Container, Bench],
					Object[Container, Enclosure]
				}],
				PreparedContainer->False,
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Transfer Environments"
					}
				}
			],
			Description->"The environment in which the transfer will be performed (Biosafety Cabinet, Fume Hood, Glove Box, Enclosure, or Bench). Containers involved in the transfer will first be moved into the TransferEnvironment (with covers on), uncovered inside of the TransferEnvironment, then covered after the Transfer has finished -- before they're moved back onto the operator cart. Consult the SterileTechnique/RNaseFreeTechnique option when using a BSC. This option cannot be set when Preparation->Robotic.",
			Category->"Instrument Specifications"
		}
	]
}];

(* ::Subsection::Closed:: *)
(* TransferBalanceOption *)

DefineOptionSet[TransferBalanceOption :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName->Balance,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to a balance whose MinWeight and MaxWeight is compatible with the transfer amount to be measured, if the transfer is occurring gravimetrically (MassP).",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{
					Model[Instrument,Balance],
					Object[Instrument,Balance]
				}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Instruments",
						"Measuring Devices",
						"Balances"
					}
				}
			],
			Description->"The balance used to weigh the transfer amount, if the transfer is occurring gravimetrically.",
			Category->"Instrument Specifications"
		}
	]
}];

(* ::Subsection::Closed:: *)
(* TabletCrusherOption *)

DefineOptionSet[TabletCrusherOption :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName->TabletCrusher,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to Model[Item, TabletCrusher, \"Silent Knight Pill Crusher\"] if an Itemized sample with Tablet -> True is being transferred by mass and not count.",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{
					Model[Item, TabletCrusher],
					Object[Item, TabletCrusher]
				}]
			],
			Description->"The pill crusher that will be used to crush any itemized tablet source samples if they are being transferred by mass and not by count.",
			Category->"Instrument Specifications"
		}
	]
}];

(* ::Subsection::Closed:: *)
(* Sachet Option *)

DefineOptionSet[SachetOptions :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName->IncludeSachetPouch,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to False if the sample has Sachet -> True.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if the pouch is also transferred to the destination along with the filler. If IncludeSachetPouch -> False, the pouch is directly discarded after emptied.",
			Category->"Instrument Specifications"
		},
		{
			OptionName->SachetIntermediateContainer,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to a compatible weigh boat model if Sachet -> True and WeighingContainer is Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{
					Model[Item, WeighBoat],
					Object[Item, WeighBoat]
				}]
			],
			Description->"The weigh boat item that the filler is emptied into after cutting open the source sachet in order to transfer to the destination, if not transferring gravimetrically using a weigh boat already.",
			Category->"General"
		}
	]
}];


(* ::Subsection::Closed:: *)
(* TransferTipOptions *)

DefineOptionSet[TransferTipOptions :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName->Tips,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to a tip that does not conflict with the incompatible materials of the sample(s) that the tip will come in contact with, the amount being transferred, and the source and destination containers of the transfer (accessibility). For more information, please refer to the function TransferDevices[].",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{
					Model[Item, Tips],
					Object[Item, Tips],
					Model[Item, Consumable],
					Object[Item, Consumable]
				}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Labware",
						"Pipette Tips"
					}
				}
			],
			Description->"The pipette tips used to aspirate and dispense the requested volume.",
			Category->"Instrument Specifications"
		},
		{
			OptionName->TipType,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to the TipType field of the calculated Tips that will be used to perform the transfer.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>TipTypeP
			],
			Description->"The type of pipette tips used to aspirate and dispense the requested volume during the transfer.",
			Category->"Instrument Specifications"
		},
		{
			OptionName->TipMaterial,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to the chemistry of the calculated Tips that will be used to perform the transfer.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>MaterialP
			],
			Description->"The material of the pipette tips used to aspirate and dispense the requested volume during the transfer.",
			Category->"Instrument Specifications"
		},
		{
			OptionName->ReversePipetting,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to True if the source or destination sample has the ReversePipetting field set and the transfer is occurring via pipette.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if additional source sample will be aspirated (past the first stop of the pipette) to reduce the chance of bubble formation when dispensing into the destination position. This option can only be set if Preparation->Manual.",
			Category->"Transfer Technique"
		},
		{
			OptionName->SlurryTransfer,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to True if the SampleHandling of the source sample is set to Slurry.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if the source sample should be mixed via pipette until it becomes homogeneous, up to MaxNumberOfAspirationMixes times.",
			Category->"Transfer Technique"
		},
		{
			OptionName -> AspirationMix,
			Default -> Automatic,
			Description -> "Indicates if the source sample will be mixed immediately before it is transferred into the destination sample.",
			ResolutionDescription -> "Automatically set to True if any of the other AspirationMix options are set. Otherwise, set to Null.",
			AllowNull -> False,
			Category->"Transfer Technique",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		{
			OptionName -> DispenseMix,
			Default -> Automatic,
			Description -> "Indicates if the destination sample will be mixed immediately after the source sample is transferred into the destination sample.",
			ResolutionDescription -> "Automatically set to True if any of the other DispenseMix options are set. Otherwise, set to Null.",
			AllowNull -> False,
			Category->"Transfer Technique",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		{
			OptionName->AspirationMixVolume,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to 1/2 the volume of the source sample or the maximum volume of the pipette being used, depending on which value is smaller.",
			AllowNull->True,
			Widget->Widget[
				Type -> Quantity,
				(* NOTE: The largest serological pipette tips are 50 mL. *)
				Pattern :> RangeP[0 Microliter, 50 Milliliter],
				Units -> {Microliter,{Microliter,Milliliter}}
			],
			Description->"The volume that will be repeatedly aspirated and dispensed via pipette from the source sample in order to mix the source sample immediately before the transfer occurs. The same pipette and tips used in the transfer will be used to mix the source sample.",
			Category->"Transfer Technique"
		},
		{
			OptionName -> NumberOfAspirationMixes,
			Default -> Automatic,
			Description -> "The number of times the source is quickly aspirated and dispensed to mix the source sample immediately before it is transferred into the destination.",
			ResolutionDescription -> "Automatically set to 5 if any of the other AspirationMix options are set. Otherwise, set to Null.",
			AllowNull -> True,
			Category->"Transfer Technique",
			Widget -> Widget[
				Type->Number,
				Pattern:>RangeP[0, 50, 1]
			]
		},
		{
			OptionName -> MaxNumberOfAspirationMixes,
			Default -> Automatic,
			Description -> "The number of times the source is quickly aspirated and dispensed to mix the source sample immediately before it is transferred into the destination.",
			ResolutionDescription -> "Automatically set to 5 if any of the other AspirationMix options are set. Otherwise, set to Null.",
			AllowNull -> True,
			Category->"Transfer Technique",
			Widget -> Widget[
				Type->Number,
				Pattern:>RangeP[0, 100, 1]
			]
		},
		{
			OptionName->DispenseMixVolume,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to 1/2 the volume of the destination sample or the maximum volume of the pipette being used, depending on which value is smaller.",
			AllowNull->True,
			Widget->Widget[
				Type -> Quantity,
				(* NOTE: The largest serological pipette tips are 50 mL. *)
				Pattern :> RangeP[0 Microliter, 50 Milliliter],
				Units -> {Microliter,{Microliter,Milliliter}}
			],
			Description->"The volume that will be repeatedly aspirated and dispensed via pipette from the destination sample in order to mix the destination sample immediately after the transfer occurs. The same pipette and tips used in the transfer will be used to mix the destination sample.",
			Category->"Transfer Technique"
		},
		{
			OptionName -> NumberOfDispenseMixes,
			Default -> Automatic,
			Description -> "The number of times the destination is quickly aspirated and dispensed to mix the destination sample immediately after the source is dispensed.",
			ResolutionDescription -> "Automatically set to 5 if any of the other DispenseMix options are set. Otherwise, set to Null.",
			AllowNull -> True,
			Category->"Transfer Technique",
			Widget -> Widget[
				Type->Number,
				Pattern:>RangeP[0, 50, 1]
			]
		}
	]
}];


(* ::Subsection::Closed:: *)
(* TransferRoboticTipOptions *)

DefineOptionSet[TransferRoboticTipOptions :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName -> AspirationRate,
			Default -> Automatic,
			Description -> "The speed at which liquid will be drawn up into the pipette tip. This option can only be set if Preparation->Robotic.",
			ResolutionDescription -> "Automatically set to DispenseRate if it is specified, otherwise set to 100 Microliter/Second if Preparation->Robotic.",
			AllowNull -> True,
			Category->"Instrument Specifications",
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
			Description -> "The speed at which liquid will be expelled from the pipette tip. This option can only be set if Preparation->Robotic.",
			ResolutionDescription -> "Automatically set to AspirationRate if it is specified, otherwise set to 100 Microliter/Second.",
			AllowNull -> True,
			Category->"Instrument Specifications",
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
			Description -> "The volume of air drawn into the pipette tip at the end of the aspiration of a liquid. This option can only be set if Preparation->Robotic.",
			ResolutionDescription -> "Automatically set to OverDispenseVolume if it is specified, otherwise set to 5 Microliter.",
			AllowNull -> True,
			Category->"Instrument Specifications",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter,50 Microliter],
				Units -> {Microliter,{Microliter,Milliliter}}
			]
		},
		{
			OptionName -> OverDispenseVolume,
			Default -> Automatic,
			Description -> "The volume of air blown out at the end of the dispensing of a liquid. This option can only be set if Preparation->Robotic.",
			ResolutionDescription -> "Automatically set to 5 Microliter if Preparation->Robotic.",
			AllowNull -> True,
			Category->"Instrument Specifications",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter,300 Microliter],
				Units -> {Microliter,{Microliter,Milliliter}}
			]
		},
		{
			OptionName -> AspirationWithdrawalRate,
			Default -> Automatic,
			Description -> "The speed at which the pipette is removed from the liquid after an aspiration. This option can only be set if Preparation->Robotic.",
			ResolutionDescription -> "Automatically set to DispenseWithdrawalRate if it is specified, otherwise set to 2 Millimeter/Second.",
			AllowNull -> True,
			Category->"Instrument Specifications",
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
			Description -> "The speed at which the pipette is removed from the liquid after a dispense. This option can only be set if Preparation->Robotic.",
			ResolutionDescription -> "Automatically set to AspirationWithdrawalRate if it is specified, otherwise set to 2 Millimeter/Second.",
			AllowNull -> True,
			Category->"Instrument Specifications",
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
			Description -> "The delay length the pipette waits after aspirating before it is removed from the liquid. This option can only be set if Preparation->Robotic.",
			ResolutionDescription -> "Automatically set to DispenseEquilibrationTime if it is specified, otherwise set to 1 Second.",
			AllowNull -> True,
			Category->"Instrument Specifications",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Second, 9.9 Second],
				Units -> {Second,{Second,Minute}}
			]
		},
		{
			OptionName -> DispenseEquilibrationTime,
			Default -> Automatic,
			Description -> "The delay length the pipette waits after dispensing before it is removed from the liquid. This option can only be set if Preparation->Robotic.",
			ResolutionDescription -> "Automatically set to AspirationEquilibrationTime if it is specified, otherwise set to 1 Second.",
			AllowNull -> True,
			Category->"Instrument Specifications",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Second, 9.9 Second],
				Units -> {Second,{Second,Minute}}
			]
		},
		{
			OptionName -> AspirationMixRate,
			Default -> Automatic,
			Description -> "The speed at which liquid is aspirated and dispensed in a liquid before it is aspirated. This option can only be set if Preparation->Robotic.",
			ResolutionDescription -> "Automatically set to DispenseMixRate or AspirationRate if either is specified, otherwise set to 100 Microliter/Second.",
			AllowNull -> True,
			Category->"Instrument Specifications",
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
			Description -> "The speed at which liquid is aspirated and dispensed in a liquid after a dispense. This option can only be set if Preparation->Robotic.",
			ResolutionDescription -> "Automatically set to AspirationMixRate or DispenseRate if either is specified, otherwise set to 100 Microliter/Second.",
			AllowNull -> True,
			Category->"Instrument Specifications",
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
			ResolutionDescription -> "Automatically set to the AspirationPosition in the PipettingMethod if it is specified and Preparation->Robotic, otherwise resolves to TouchOff if Preparation->Robotic.",
			AllowNull -> True,
			Category->"Instrument Specifications",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> PipettingPositionP
			]
		},
		{
			OptionName -> DispensePosition,
			Default -> Automatic,
			Description -> "The location from which liquid should be dispensed. Top will dispense DispensePositionOffset below the Top of the container, Bottom will dispense DispensePositionOffset above the Bottom of the container, LiquidLevel will dispense DispensePositionOffset below the liquid level of the sample in the container, and TouchOff will touch the bottom of the container before moving the specified DispensePositionOffset above the bottom of the container to start dispensing the sample.",
			ResolutionDescription -> "Automatically set to the DispensePosition in the PipettingMethod if it is specified and Preparation->Robotic, resolved to Bottom for MxN MultiProbeHead transfers, otherwise resolves to TouchOff if Preparation->Robotic.",
			AllowNull -> True,
			Category->"Instrument Specifications",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> PipettingPositionP
			]
		},
		{
			OptionName -> AspirationPositionOffset,
			Default -> Automatic,
			Description -> "The distance from the center of the well that liquid will aspirated. The Z Offset is based on the AspirationPosition option -- measured as the height below the top of the well (Top), the height above the bottom of the well (Bottom), or the height below the detected liquid level (LiquidLevel), see the AspirationPosition diagram in the help file for more information. If an X and Y offset is not specified, the liquid will be aspirated in the center of the well, otherwise, -X/+X values will shift the position left and right, respectively, and -Y/+Y values will shift the position down and up, respectively. When the source container is tilted (via AspirationAngle), the AspirationPositionOffset automatically accounts for the angle of tilt.",
			ResolutionDescription -> "Automatically set to the AspirationPositionOffset field in the pipetting method, if specified. If AspirationAngle is set, automatically set to the left most point in the well since liquid will pool in the direction that the plate is tilted. Otherwise, is set to 2 Millimeter.",
			AllowNull -> True,
			Category->"Instrument Specifications",
			Widget -> Alternatives[
				"Z Offset" -> Widget[
					Type -> Quantity,
					Pattern :> GreaterEqualP[0 Millimeter],
					Units -> {Millimeter,{Millimeter}}
				],
				"{X,Y,Z} Coordinate Offset" -> Widget[
					Type -> Expression,
					Pattern :> Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],
					Size -> Line
				]
			]
		},
		{
			OptionName -> AspirationAngle,
			Default -> Automatic,
			Description -> "The angle that the source container will be tilted during the aspiration of liquid. The container is pivoted on its left edge when tilting occurs. This option can only be provided if Preparation->Robotic.",
			ResolutionDescription -> "Automatically set to 0 AngularDegree if Preparation->Robotic. Otherwise, set to Null.",
			AllowNull -> True,
			Category->"Instrument Specifications",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 AngularDegree, 10 AngularDegree, 1 AngularDegree],
				Units -> {AngularDegree,{AngularDegree}}
			]
		},
		{
			OptionName -> DispensePositionOffset,
			Default -> Automatic,
			Description -> "The distance from the center of the well that liquid will dispensed. The Z Offset is based on the DispensePosition option -- measured as the height below the top of the well (Top), the height above the bottom of the well (Bottom), or the height below the detected liquid level (LiquidLevel), see the DispensePosition diagram in the help file for more information. If an X and Y offset is not specified, the liquid will be dispensed in the center of the well, otherwise, -X/+X values will shift the position left and right, respectively, and -Y/+Y values will shift the position down and up, respectively. When the destination container is tilted (via DispenseAngle), the DispensePositionOffset automatically accounts for the angle of tilt.",
			ResolutionDescription -> "Automatically set to the DispensePositionOffset field in the pipetting method, if specified. If DispenseAngle is set, automatically set to the left most point in the well since liquid will pool in the direction that the plate is tilted. Otherwise, is set to 2 Millimeter.",
			AllowNull -> True,
			Category->"Instrument Specifications",
			Widget -> Alternatives[
				"Z Offset" -> Widget[
					Type -> Quantity,
					Pattern :> GreaterEqualP[0 Millimeter],
					Units -> {Millimeter,{Millimeter}}
				],
				"{X,Y,Z} Coordinate Offset" -> Widget[
					Type -> Expression,
					Pattern :> Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],
					Size -> Line
				]
			]
		},
		{
			OptionName -> DispenseAngle,
			Default -> Automatic,
			Description -> "The angle that the destination container will be tilted during the dispensing of liquid. The container is pivoted on its left edge when tilting occurs. This option can only be provided if Preparation->Robotic.",
			ResolutionDescription -> "Automatically set to 0 AngularDegree if Preparation->Robotic. Otherwise, set to Null.",
			AllowNull -> True,
			Category->"Instrument Specifications",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 AngularDegree, 10 AngularDegree, 1 AngularDegree],
				Units -> {AngularDegree,{AngularDegree}}
			]
		},
		{
			OptionName -> CorrectionCurve,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The relationship between a target volume and the corrected volume that needs to be aspirated or dispensed to reach the target volume. The correction curve is derived empirically from the relationship between the target and actual amount of volume transferred when on a specific robotic liquid handler instrument model. It is recommended when building one of these curves to measure the volume of sample transferred gravimetrically to get a more accurate CorrectionCurve. Use the function UploadPipettingMethod to create a new pipetting method for a sample model to have all robotic transfers of this sample model to use the derived CorrectionCurve automatically. This option can only be set if Preparation->Robotic.",
			ResolutionDescription -> "Automatically set to PipettingMethod if it is specified. Otherwise, is set to Null (no correction curve).",
			Category->"Instrument Specifications",
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
			OptionName -> PipettingMethod,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Method, Pipetting]]],
			Description -> "The pipetting parameters used to manipulate the source sample. This option can only be set if Preparation->Robotic. If other pipetting options are specified, the parameters from the method here are overwritten.",
			ResolutionDescription -> "Automatically set to the PipettingMethod of the model of the sample if available.",
			Category->"Instrument Specifications"
		},
		{
			OptionName -> DynamicAspiration,
			Default -> Automatic,
			Description -> "Indicates if droplet formation will be prevented during liquid transfer. This will only be used for solvents that have high vapor pressure. This option can only be set if Preparation->Robotic.",
			ResolutionDescription -> "Automatically set to the DynamicAspiration field in the pipetting method, if available.",
			AllowNull -> True,
			Category->"Instrument Specifications",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		{
			OptionName -> DeviceChannel,
			Default -> Automatic,
			Description -> "The channel of the work cell that will be used to perform the transfer (MultiProbeHead | SingleProbe1 | SingleProbe2 | SingleProbe3 | SingleProbe4 | SingleProbe5 | SingleProbe6 | SingleProbe7 | SingleProbe8). This option can only be set if Preparation->Robotic.",
			ResolutionDescription -> "Automatically set to SingleProbe1 if MultichannelTransfer->False. Otherwise, set to the appropriate channel to perform the transfer.",
			AllowNull -> True,
			Category->"Instrument Specifications",
			Widget->Widget[Type->Enumeration,Pattern:>DeviceChannelP]
		}
	]
}];

(* ::Subsection::Closed:: *)
(* TransferNeedleOption *)

DefineOptionSet[TransferNeedleOption :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName->Needle,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to a needle that does not conflict with the incompatible materials of the sample(s) that the tip will come in contact with, the amount being transferred, and the source and destination containers of the transfer (accessibility). For more information, please refer to the function TransferDevices[].",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{
					Model[Item, Needle],
					Object[Item, Needle]
				}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Labware",
						"Needles"
					}
				}
			],
			Description->"The needle used to aspirate and dispense the requested volume.",
			Category->"Instrument Specifications"
		}
	]
}];


(* ::Subsection::Closed:: *)
(* TransferFunnelOption *)

DefineOptionSet[TransferFunnelOption :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName->Funnel,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to a funnel that can fit into the aperture of the destination container if 1) the transfer Instrument is set to Null (pouring)/GraduatedCylinder or 2) liquid is being transferred from a weighing container to the destination (pouring).",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{
					Model[Part, Funnel],
					Object[Part, Funnel]
				}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Labware",
						"Transfer Aids"
					}
				}
			],
			Description->"The funnel that is used to guide the source sample into the destination container when pouring or using a graduated cylinder.",
			Category->"Instrument Specifications"
		}
	]
}];


(* ::Subsection::Closed:: *)
(* WeighingContainerOption *)

DefineOptionSet[WeighingContainerOption :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName->WeighingContainer,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to a weigh boat (for solids) or container (for liquids) that can hold the Amount of the transfer specified if transferring gravimetrically (MassP). Otherwise, set to Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{
					Model[Item, WeighBoat],
					Object[Item, WeighBoat],
					Model[Container, Vessel],
					Object[Container, Vessel],
					Model[Item, Consumable],
					Object[Item, Consumable],
					Model[Container, GraduatedCylinder],
					Object[Container, GraduatedCylinder]
				}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Labware",
						"Transfer Aids"
					}
				}
			],
			Description->"The container that will be placed on the Balance and used to weigh out the specified amount of the source that will be transferred to the destination.",
			Category->"Instrument Specifications"
		}
	]
}];


(* ::Subsection::Closed:: *)
(* TransferToleranceOption *)

DefineOptionSet[TransferToleranceOption :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName->Tolerance,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to 5X of the ParticleSize (if specified). Otherwise, set to 2X of the Resolution of the balance being used, if the sample being transferred is a solid. If the sample is not being transferred gravimetrically, set to Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>GreaterP[0 Gram],
				Units->{1,{Gram,{Milligram,Gram}}}
			],
			Description->"The allowed tolerance of the weighed source sample from the specified amount requested to be transferred.",
			Category->"Instrument Specifications"
		}
	]
}];




(* ::Subsection::Closed:: *)
(* HandPumpOption *)

DefineOptionSet[HandPumpOption :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName->HandPump,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to Model[Part, HandPump, \"id:L8kPEjNLDld6\"] if the source is in a container with a MaxVolume over 5 Liters and either (1) the transfer instrument used is a graduated cylinder or (2) an intermediate decant is specified.",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{
					Model[Part, HandPump],
					Object[Part, HandPump]
				}]
			],
			Description->"The hand pump used to get liquid out of the source container.",
			Category->"Instrument Specifications"
		}
	]
}];



(* ::Subsection::Closed:: *)
(* TransferHermeticSourceOptions *)

DefineOptionSet[TransferHermeticSourceOptions :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName->BackfillGas,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to Nitrogen if the source's container is hermetic and UnsealHermeticSource->False.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>Alternatives[
					Nitrogen,
					Argon
				]
			],
			Description->"The inert gas that is used equalize the pressure in the source's hermetic container while the transfer out of the source's container occurs.",
			Category->"Hermetic Transfers"
		},
		{
			OptionName->BackfillNeedle,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to the same model of Needle that will be used to perform the transfer, if the source's container is hermetic and UnsealHermeticSource->False.",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{
					Model[Item, Needle],
					Object[Item, Needle]
				}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Labware",
						"Needles"
					}
				}
			],
			Description->"The needle used to backfill the source's hermetic container with BackfillGas.",
			Category->"Hermetic Transfers"
		},
		{
			OptionName->UnsealHermeticSource,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to True if it is indicated that a syringe/needle will not be used to perform the transfer and the source is in a hermetic container. Otherwise, is set to False.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if the source's hermetic container will be unsealed before sample is transferred out of it.",
			Category->"Hermetic Transfers"
		}
	]
}];


(* ::Subsection::Closed:: *)
(* TransferHermeticDestinationOptions *)

DefineOptionSet[TransferHermeticDestinationOptions :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName->VentingNeedle,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to the same model of Needle that will be used to perform the transfer, if the destination's container is hermetic and UnsealHermeticDestination->False.",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{
					Model[Item, Needle],
					Object[Item, Needle]
				}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Labware",
						"Needles"
					}
				}
			],
			Description->"The needle that is used equalize the pressure in the destination's hermetic container while the transfer into the destination's container occurs.",
			Category->"Hermetic Transfers"
		},
		{
			OptionName->UnsealHermeticDestination,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to True if it is indicated that a syringe/needle will not be used to perform the transfer and the destination is in a hermetic container. Otherwise, is set to False.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if the destination's hermetic container will be unsealed before sample is transferred out of it.",
			Category->"Hermetic Transfers"
		}
	]
}];


(* ::Subsection::Closed:: *)
(* QuantitativeTransferOptions *)

DefineOptionSet[QuantitativeTransferOptions :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName->QuantitativeTransfer,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to True if any of the other QuantitativeTransfer options are set. Otherwise, is set to False.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if additional QuantitativeTransferWashSolution will be used to wash the weigh boat, NumberOfQuantitativeTransferWashes times, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
			Category->"Quantitative Transfers"
		},
		{
			OptionName->QuantitativeTransferWashSolution,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to Model[Sample, \"Milli-Q water\"] if any of the other QuantitativeTransfer options are set. Otherwise, is set to Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{
					Model[Sample],
					Object[Sample]
				}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials"
					}
				}
			],
			Description->"The solution that will be used to wash the weigh boat, NumberOfQuantitativeTransferWashes times, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
			Category->"Quantitative Transfers"
		},
		{
			OptionName->QuantitativeTransferWashVolume,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to 1/4 of the MaxVolume of the weigh boat that will be used if any of the other QuantitativeTransfer options are set, up to a maximum of 10 mL. Otherwise, is set to Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>GreaterP[0 Liter],
				Units->{1,{Milliliter,{Microliter,Milliliter}}}
			],
			Description->"The volume of the solution that will be used to wash the weigh boat, NumberOfQuantitativeTransferWashes times, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
			Category->"Quantitative Transfers"
		},
		{
			OptionName->QuantitativeTransferWashInstrument,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to a pipette that can transfer the requested QuantitativeTransferWashVolume. Otherwise, is set to Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{
					Model[Instrument,Pipette],
					Object[Instrument,Pipette]
				}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Instruments",
						"Liquid Handling",
						"Pipettes"
					}
				}
			],
			Description->"The pipette that will be used to transfer the wash solution to wash the weigh boat, NumberOfQuantitativeTransferWashes times, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
			Category->"Quantitative Transfers"
		},
		{
			OptionName->QuantitativeTransferWashTips,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to tips that can transfer the requested QuantitativeTransferWashVolume. Otherwise, is set to Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{
					Model[Item, Tips],
					Object[Item, Tips]
				}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Labware",
						"Pipette Tips"
					}
				}
			],
			Description->"The tips that will be used to transfer the wash solution to wash the weigh boat, NumberOfQuantitativeTransferWashes times, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
			Category->"Quantitative Transfers"
		},
		{
			OptionName->NumberOfQuantitativeTransferWashes,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to 2 if any of the other QuantitativeTransfer options are set. Otherwise, is set to Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Number,
				Pattern:>GreaterP[0,1]
			],
			Description->"Indicates the number of washes of the weight boat with QuantitativeTransferWashSolution that will occur, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
			Category->"Quantitative Transfers"
		}
	]
}];


(* ::Subsection::Closed:: *)
(* TipRinseOptions *)

DefineOptionSet[TipRinseOptions :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName->TipRinse,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to True if any of the other TipRinse options are set. Otherwise, is set to False.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if the Tips will first be rinsed with a TipRinseSolution before they are used to aspirate from the source sample.",
			Category->"Tip Rinsing"
		},
		{
			OptionName->TipRinseSolution,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to Model[Sample, \"Milli-Q water\"] if any of the other TipRinse options are set. Otherwise, is set to Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{
					Model[Sample],
					Object[Sample]
				}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials"
					}
				}
			],
			Description->"The solution that the Tips will be rinsed before they are used to aspirate from the source sample.",
			Category->"Tip Rinsing"
		},
		{
			OptionName->TipRinseVolume,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to 125% of the volume to be transferred, or the MaxVolume of the Tips (which ever is smaller) if any of the other TipRinse options are set. Otherwise, is set to Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>GreaterP[0 Liter],
				Units->{1,{Milliliter,{Microliter,Milliliter}}}
			],
			Description->"The volume of the solution that the Tips will be rinsed before they are used to aspirate from the source sample.",
			Category->"Tip Rinsing"
		},
		{
			OptionName->NumberOfTipRinses,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to 1 if any of the other TipRinse options are set. Otherwise, is set to Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Number,
				Pattern:>GreaterP[0, 1]
			],
			Description->"The number of times that the Tips will be rinsed before they are used to aspirate from the source sample.",
			Category->"Tip Rinsing"
		}
	]
}];



(* ::Subsection::Closed:: *)
(* AspirationMixOptions *)

DefineOptionSet[AspirationMixOptions :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName->AspirationMix,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to True if any of the other AspirationMix options are set. Otherwise, set to Null.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if mixing will occur during aspiration from the source sample.",
			Category->"Mixing"
		},
		{
			OptionName->AspirationMixType,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to Pipette if any of the other AspirationMix options are set and we're using a pipette to do the transfer. Otherwise, set to Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>Swirl|Pipette|Tilt
			],
			Description->"The type of mixing that will occur immediately before aspiration from the source container. Swirl has the operator place the container on the surface of the TransferEnvironment and perform NumberOfAspirationMixes clockwise rotations of the container. Pipette performs NumberOfAspirationMixes aspiration/dispense cycle(s) of AspirationMixVolume using a pipette. Tilt changes the angle of the container to (1) 0 AngularDegrees, (2) 10 AngularDegrees, (3) 0 AngularDegrees, a total of NumberOfAspirationMixes times on a Hamilton integrated tilt plate position. Swirl is only available when Preparation->Manual and Tilt is only available when Preparation->Robotic.",
			Category->"Mixing"
		},
		{
			OptionName->NumberOfAspirationMixes,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to 5 if any of the other AspirationMix options are set. Otherwise, set to Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Number,
				Pattern:>RangeP[0, 50, 1]
			],
			Description->"The number of times that the source sample will be mixed during aspiration.",
			Category->"Mixing"
		}
	]
}];


(* ::Subsection::Closed:: *)
(* DispenseMixOptions *)

DefineOptionSet[DispenseMixOptions :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName->DispenseMix,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to True if any of the other DispenseMix options are set. Otherwise, set to Null.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if mixing will occur after the sample is dispensed into the destination container.",
			Category->"Mixing"
		},
		{
			OptionName->DispenseMixType,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to Pipette if any of the other DispenseMix options are set and we're using a pipette to do the transfer. Otherwise, set to Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>Swirl|Pipette|Tilt
			],
			Description->"The type of mixing that will occur immediately after the sample is dispensed into the destination container. Swirl has the operator place the container on the surface of the TransferEnvironment and perform NumberOfDispenseMixes clockwise rotations of the container. Pipette performs NumberOfDispenseMixes aspiration/dispense cycle(s) of DispenseMixVolume using a pipette. Tilt changes the angle of the container to (1) 0 AngularDegrees, (2) 10 AngularDegrees, (3) 0 AngularDegrees, a total of NumberOfDispenseMixes times on a Hamilton integrated tilt plate position. Swirl is only available when Preparation->Manual and Tilt is only available when Preparation->Robotic.",
			Category->"Mixing"
		},
		{
			OptionName->NumberOfDispenseMixes,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to 5 if any of the other DispenseMix options are set. Otherwise, set to Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Number,
				Pattern:>RangeP[0, 50, 1]
			],
			Description->"The number of times that the destination sample will be mixed after the sample is dispensed into the destination container.",
			Category->"Mixing"
		}
	]
}];


(* ::Subsection::Closed:: *)
(* IntermediateDecantOptions *)

DefineOptionSet[IntermediateDecantOptions :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName->IntermediateDecant,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to True if the source is in a container that in a container that is pipette-inaccessible and the Instrument set to perform the transfer is a pipette.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if the source will need to be decanted into an intermediate container in order for the precise amount requested to be transferred via pipette. Intermediate decants are necessary if the container geometry prevents the Instrument from reaching the liquid level of the sample in the container (plus the delta of volume that is to be transferred). The container geometry is automatically calculated from the inverse of the volume calibration function when the container is parameterized upon receiving. This option will be set to Null if Preparation->Robotic.",
			Category->"Intermediate Decanting"
		},
		{
			OptionName->IntermediateContainer,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to the PreferredContainer[...] of the volume that is being transferred if IntermediateDecant->True.",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{
					Model[Container],
					Object[Container]
				}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Containers"
					}
				}
			],
			Description->"The container that the source will be decanted into in order to make the final transfer via pipette into the final destination.",
			Category->"Intermediate Decanting"
		},
		{
			OptionName->IntermediateFunnel,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to a funnel that can fit inside the IntermediateContainer, if an IntermediateDecant is required.",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{
					Model[Part, Funnel],
					Object[Part, Funnel]
				}]
			],
			Description->"The funnel that is used to guide the source sample into the intermediate container when pouring.",
			Category->"Instrument Specifications"
		}
	]
}];



(* ::Subsection::Closed:: *)
(* SourceTemperatureOptions *)

DefineOptionSet[SourceTemperatureOptions :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName->SourceTemperature,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to the TransferTemperature or TransportTemperature (whichever is first filled out) of the source sample. Otherwise, is transferred at Ambient temperature.",
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type -> Quantity, Pattern :> RangeP[$MinIncubationTemperature, 90 Celsius],Units :> Celsius],
				Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]]
			],
			Description->"Indicates the temperature at which the source sample will be at during the transfer. When samples are transferred off of the operator cart and into the TransferEnvironment, they are placed in a portable heater/cooler to get the sample to temperature right before the transfer occurs. Note that this is different than the TransportCondition of the sample.",
			Category->"Temperature Conditions"
		},
		{
			OptionName->SourceEquilibrationTime,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to 5 Minute if SourceTemperature is not set to Ambient.",
			AllowNull->True,
			Widget->Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Minute,$MaxExperimentTime],
				Units->{1,{Hour,{Second,Minute,Hour}}}
			],
			Description->"The duration of time for which the samples will be heated/cooled to the target SourceTemperature.",
			Category->"Temperature Conditions"
		},
		{
			OptionName->MaxSourceEquilibrationTime,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to 30 Minute if SourceEquilibrationCheck is set.",
			AllowNull->True,
			Widget->Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Minute,$MaxExperimentTime],
				Units->{1,{Hour,{Second,Minute,Hour}}}
			],
			Description->"The maximum duration of time for which the samples will be heated/cooled to the target SourceTemperature, if they do not reach the SourceTemperature after SourceEquilibrationTime. MaxSourceEquilibrationTime will only be used if SourceEquilibrationCheck is set, in order to extend the equilibration time past the initial SourceEquilibrationTime if SourceTemperature has not been reached. Performing an equilibration check will require stopping the experiment and verifying the temperature before moving on; this may add experiment time and may result in loss of sample through evaporation, and is only recommended for use in cases where temperature precision or temperature data is required.",
			Category->"Temperature Conditions"
		},
		{
			OptionName->SourceEquilibrationCheck,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>EquilibrationCheckP
			],
			Description->"The method by which to verify the temperature of the source before the transfer is performed. Performing an equilibration check will require stopping the experiment and verifying the temperature before moving on; this may add experiment time and may result in loss of sample through evaporation, and is only recommended for use in cases where temperature precision or temperature data is required.",
			Category->"Temperature Conditions"
		}
	]
}];


(* ::Subsection::Closed:: *)
(* DestinationTemperatureOptions *)

DefineOptionSet[DestinationTemperatureOptions :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName->DestinationTemperature,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to the TransferTemperature or TransportTemperature (whichever is first filled out) of the destination sample. Otherwise, is transferred at Ambient temperature.",
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type -> Quantity, Pattern :> RangeP[$MinIncubationTemperature, 90 Celsius],Units :> Celsius],
				Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]]
			],
			Description->"Indicates the temperature at which the destination will be at during the transfer. When samples are transferred off of the operator cart and into the TransferEnvironment, they are placed in a portable heater/cooler to get the sample to temperature right before the transfer occurs. Note that this is different than the TransportCondition of the sample.",
			Category->"Temperature Conditions"
		},
		{
			OptionName->DestinationEquilibrationTime,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to 5 Minute if DestinationTemperature is not set to Ambient.",
			AllowNull->True,
			Widget->Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Minute,$MaxExperimentTime],
				Units->{1,{Hour,{Second,Minute,Hour}}}
			],
			Description->"The duration of time for which the samples will be heated/cooled to the target DestinationTemperature.",
			Category->"Temperature Conditions"
		},
		{
			OptionName->MaxDestinationEquilibrationTime,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to 30 Minute if DestinationEquilibrationCheck is set.",
			AllowNull->True,
			Widget->Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Minute,$MaxExperimentTime],
				Units->{1,{Hour,{Second,Minute,Hour}}}
			],
			Description->"The maximum duration of time for which the samples will be heated/cooled to the target DestinationTemperature, if they do not reach the DestinationTemperature after DestinationEquilibrationTime. MaxDestinationEquilibrationTime will only be used if DestinationEquilibrationCheck is set, in order to extend the equilibration time past the initial DestinationEquilibrationTime if DestinationTemperature has not been reached. Performing an equilibration check will require stopping the experiment and verifying the temperature before moving on; this may add experiment time and may result in loss of sample through evaporation, and is only recommended for use in cases where temperature precision or temperature data is required.",
			Category->"Temperature Conditions"
		},
		{
			OptionName->DestinationEquilibrationCheck,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>EquilibrationCheckP
			],
			Description->"The method by which to verify the temperature of the destination before the transfer is performed. Performing an equilibration check will require stopping the experiment and verifying the temperature before moving on; this may add experiment time and may result in loss of sample through evaporation, and is only recommended for use in cases where temperature precision or temperature data is required.",
			Category->"Temperature Conditions"
		}
	]
}];


(* ::Subsection::Closed:: *)
(* SterileTechniqueOption *)

DefineOptionSet[SterileTechniqueOption :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName->SterileTechnique,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to True if the samples being transferred contain tissue culture or microbial components, or require aseptic techniques.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if sterilized instruments and aseptic transfer environments must be used for the transfer. Aseptic transfer environments include biosafety cabinets as TransferEnvironment, or bioSTAR and microbioSTAR Hamilton enclosures as WorkCell. Please consult the ExperimentTransfer documentation for a full diagram of SterileTechnique that is employed by operators.",
			Category->"Transfer Technique"
		}
	]
}];


(* ::Subsection::Closed:: *)
(* RNaseFreeTechniqueOption *)

DefineOptionSet[RNaseFreeTechniqueOption :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName->RNaseFreeTechnique,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to True if the samples being transferred are RNaseFree->True.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates that RNase free technique will be followed when performing the transfer (spraying RNase away on surfaces, using RNaseFree tips, etc.).",
			Category->"Transfer Technique"
		}
	]
}];


(* ::Subsection::Closed:: *)
(* MagnetizationOptions *)

DefineOptionSet[MagnetizationOptions :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName->Magnetization,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to False if transferring a liquid. Otherwise, set to Null.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if the source container will be put in a magnetized rack to separate out any magnetic components before the transfer is performed.",
			Category->"Transfer Technique"
		},
		{
			OptionName->MagnetizationTime,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to 15 Second if Magnetization->True. Otherwise, set to Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern :> RangeP[0 Minute,$MaxExperimentTime],
				Units -> {Minute,{Minute,Second}}
			],
			Description->"The time that the source sample will be left on the magnetic rack until the magnetic components are settled at the side of the container.",
			Category->"Transfer Technique"
		},
		{
			OptionName->MaxMagnetizationTime,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to 1 Minute if Magnetization->True. Otherwise, set to Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern :> RangeP[0 Minute,$MaxExperimentTime],
				Units -> {Minute,{Minute,Second}}
			],
			Description->"The maximum time that the source sample will be left on the magnetic rack until the magnetic components are settled at the side of the container.",
			Category->"Transfer Technique"
		},
		{
			OptionName->MagnetizationRack,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to a magnetized rack that can hold the source/intermediate container, if Magnetization->True is specified.",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{
					Model[Container, Rack],
					Object[Container, Rack],
					Model[Item,MagnetizationRack],
					Object[Item,MagnetizationRack]
				}],
				PreparedContainer->False,
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Magnetic Bead Separation",
						"Magnetization Racks"
					}
				}
			],
			Description->"The magnetized rack that the source/intermediate container will be placed in before the transfer is performed.",
			Category->"Transfer Technique"
		},
		{
			OptionName -> UnresolvedMagnetizationRackFromParentProtocol,
			Default -> Null,
			AllowNull->True,
			Widget->Alternatives[
				Widget[
					Type->Object,
					Pattern:>ObjectP[{
						Model[Item,MagnetizationRack],
						Object[Item,MagnetizationRack]
					}]
				],
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]]
			],
			Description->"The user input of the magnetic rack used during magnetization passed from the higher level experiment function.",
			Category->"Hidden"
		}
	]
}];


(* ::Subsection::Closed:: *)
(* CollectionContainerOptions *)

DefineOptionSet[CollectionContainerOptions :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName -> CollectionContainer,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				"Existing Container" -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Container, Plate], Model[Container, Plate]}],
					PreparedContainer->True,
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers",
							"Plates"
						}
					}
				],
				"New Container" -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container, Plate]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers",
							"Plates"
						}
					}
				],
				"New Container with Index"->{
					"Index" -> Widget[
						Type -> Number,
						Pattern :> GreaterEqualP[1, 1]
					],
					"Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Container]}],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Containers",
								"Plates"
							}
						}
					]
				}
			],
			Description -> "Specifies the container that is stacked on the bottom of the destination container, before the source sample is transferred into the destination container, in order to collect the sample that flows through from the bottom of the destination container and into the CollectionContainer. This option is only available when Preparation->Robotic.",
			ResolutionDescription->"Automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"] if CollectionTime is specified. Otherwise, set to Null.",
			Category->"Transfer Technique"
		},
		{
			OptionName -> CollectionTime,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Minute,$MaxExperimentTime],
				Units->{1,{Hour,{Second,Minute,Hour}}}
			],
			Description -> "The amount of time that the sample that is transferred into the destination container is allowed to flow through the bottom of the destination plate and into the CollectionContainer (that is stacked on the bottom of the destination container). This option is only available when Preparation->Robotic.",
			ResolutionDescription->"Automatically set to 1 Minute if CollectionContainer is specified, otherwise set to Null.",
			Category->"Transfer Technique"
		}
	]
}];

(* ::Subsection::Closed:: *)
(* TransferLayerOptions *)

DefineOptionSet[TransferLayerOptions :> {
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName->Supernatant,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to True if Magnetization->True. Otherwise, set to False/Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates that only top most layer of the source sample will be aspirated when performing the transfer.",
			Category->"Transfer Technique"
		},
		{
			OptionName->AspirationLayer,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to 1 if Supernatant->True. Otherwise, is set to Null.",
			AllowNull->True,
			Widget->Widget[
				Type -> Number,
				Pattern :> GreaterP[0., 1.]
			],
			Description->"The layer (counting from the top) of the source sample that will be aspirated from when performing the transfer.",
			Category->"Transfer Technique"
		},
		{
			OptionName->DestinationLayer,
			Default->Null,
			AllowNull->True,
			Widget->Widget[
				Type -> Number,
				Pattern :> GreaterP[0., 1.]
			],
			Description->"The layer (counting from the top) of the destination sample that will be dispensed into when performing the transfer.",
			Category->"Transfer Technique"
		}
	]
}];

