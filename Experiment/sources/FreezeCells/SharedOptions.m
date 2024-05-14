(* FreezeCell Shared Options for use in other experiment functions. *)
DefineOptionSet[FreezeCellSharedOptions:>Evaluate@{
  {
    OptionName->FreezingType,
    Default->Automatic,
    AllowNull->True,
    Widget->Widget[
      Type->Enumeration,
      Pattern:>FreezingTypeP
    ],
    Description->"The type of freezing that should be used to refreeze any remaining cells in cryopreservation media, if Volume is not All.",
    ResolutionDescription->"Automatically set to FlashFreeze if All of the Volume of the sample is not used.",
    Category->"Refreezing"
  },
  ModifyOptions[ExperimentFreezeCells, FreezingMethods, {AllowNull->True, Category->"Refreezing"}],
  ModifyOptions[ExperimentFreezeCells, Instruments, {AllowNull->True, Category->"Refreezing"}]/.{Instruments->FreezingInstruments},
  ModifyOptions[ExperimentFreezeCells, FreezingProfiles, {Category->"Refreezing"}],
  ModifyOptions[ExperimentFreezeCells, FreezingRates, {Category->"Refreezing"}],
  ModifyOptions[ExperimentFreezeCells, Durations, {Category->"Refreezing"}]/.{Durations->FreezingDurations},
  ModifyOptions[ExperimentFreezeCells, ResidualTemperatures, {Category->"Refreezing"}]/.{ResidualTemperatures->FreezingResidualTemperatures},
  ModifyOptions[ExperimentFreezeCells, FreezingContainers, {Category->"Refreezing"}],
  ModifyOptions[ExperimentFreezeCells, FreezingConditions, {Category->"Refreezing"}],
  ModifyOptions[ExperimentFreezeCells, Coolants, {Category->"Refreezing"}]/.{Coolants->FreezingCoolants},
  ModifyOptions[ExperimentFreezeCells, CoolantVolumes, {Category->"Refreezing"}]/.{CoolantVolumes->FreezingCoolantVolumes},
  ModifyOptions[ExperimentFreezeCells, TransportConditions, {AllowNull->True, Category->"Refreezing"}]/.{TransportConditions->FreezingTransportConditions}
}];