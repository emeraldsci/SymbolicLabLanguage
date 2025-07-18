(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Options and Messages*)

(* ::Subsubsection:: *)
(*Options*)

DefineOptions[ExperimentPrecipitate,
  Options :> {
    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      {


        (*---General---*)


        OptionName -> TargetPhase,
        Default -> Solid,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> (Solid | Liquid)
        ],
        Description -> "Indicates if the target molecules in this sample are expected to be located in the solid precipitate or liquid supernatant after separating the two phases by pelleting or filtration.",
        Category -> "General"
      },
      {
        OptionName -> SeparationTechnique,
        Default -> Pellet,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> (Pellet | Filter)
        ],
        Description -> "Indicates if the the solid precipitate and liquid supernatant are to be separated by centrifugation followed by pipetting of the supernatant (Pellet), or separated by passing the solution through a filter with a pore size large enough to allow the liquid phase to pass through, but not the solid precipitate (Filter).",
        Category -> "General"
      },
      {
        OptionName -> SampleVolume,
        Default -> All,
        AllowNull -> True,
        Widget -> Alternatives[
          "All" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[All]
          ],
          "Volume" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
            Units -> {Microliter, {Microliter, Milliliter, Liter}}
          ]
        ],
        Description -> "The volume of the SampleIn that will be precipitated.",
        Category -> "General"
      },

      (*---Precipitation---*)

      {
        OptionName -> PrecipitationReagent,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
          OpenPaths -> {
            {Object[Catalog, "Root"], "Materials", "Reagents", "Buffers"}
          }
        ],
        Description -> "A reagent which, when added to the sample, will help form the precipitate and encourage it to crash out of solution so that it can be collected if it will contain the target molecules, or discarded if the target molecules will only remain in the liquid phase.",
        ResolutionDescription -> "Automatically set to Model[Sample, StockSolution, \"5M Sodium Chloride\"] if TargetPhase is set to Liquid otherwise PrecipitationReagent is set to Model[Sample, \"Isopropanol\"].",
        Category -> "Precipitation"
      },
      {
        OptionName -> PrecipitationReagentVolume,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
          Units -> {Microliter, {Microliter, Milliliter, Liter}}
        ],
        Description -> "The volume of PrecipitationReagent that will be added to the sample to help form the precipitate and encourage it to crash out of solution.",
        ResolutionDescription -> "Automatically set to the lesser of 50% of the input sample's volume or 80% of the maximum volume of the container minus the volume of input samples in order to not overflow the container. PrecipitationReagentVolume will resolve to a minimum of 1 Microliter.",
        Category -> "Precipitation"
      },
      {
        OptionName -> PrecipitationReagentTemperature,
        Default -> Ambient,
        AllowNull -> True,
        Widget -> Alternatives[
          "Ambient" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[Ambient]
          ],
          "Temperature" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],
            Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}
          ]
        ],
        Description -> "The temperature that the PrecipitationReagent is incubated at for the PrecipitationReagentEquilibrationTime before being added to the sample, which will help form the precipitate and encourage it to crash out of solution once it has been added to the sample.",
        Category -> "Precipitation"
      },
      {
        OptionName -> PrecipitationReagentEquilibrationTime,
        Default -> 5 Minute,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Description -> "The minimum duration for which the PrecipitationReagent will be kept at PrecipitationReagentTemperature before being added to the sample, which will help form the precipitate and encourage it to crash out of solution once it has been added to the sample.",
        Category -> "Precipitation"
      },
      {
        OptionName -> PrecipitationMixType,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> (Shake | Pipette | None)
        ],
        Description -> "The manner in which the sample is agitated following the addition of PrecipitationReagent to the sample, in order to prepare a uniform mixture prior to incubation. Shake indicates that the sample will be placed on a shaker at PrecipitationMixRate for PrecipitationMixTime, while Pipette indicates that PrecipitationMixVolume of the sample will be pipetted up and down for the number of times specified by NumberOfPrecipitationMixes. None indicates that no mixing occurs after adding PrecipitationReagent before incubation.",
        ResolutionDescription -> "Automatically set to Pipette if any corresponding Pipette mixing options are set (PrecipitationMixVolume, NumberOfPrecipitationMixes), otherwise PrecipitationMixType is set to Shake.",
        Category -> "Precipitation"
      },
      {
        OptionName -> PrecipitationMixInstrument,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[

          Type -> Object,
          OpenPaths -> {
            {Object[Catalog, "Root"], "Instruments", "Mixing Devices", "Robotic Compatible Mixing Devices"}
          },
          Pattern :> ObjectP[
            {
              Model[Instrument, Shaker],
              Object[Instrument, Shaker]
            }
          ]
        ],
        Description -> "The instrument used agitate the sample following the addition of PrecipitationReagent, in order to prepare a uniform mixture prior to incubation.",
        ResolutionDescription -> "Automatically set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"] if PrecipitationMixType is set to Shake and PrecipitationMixTemperature is greater than 70 Celsius. Otherwise PrecipitationMixInstrument is set to Model[Instrument, Shaker, \"Inheco ThermoshakeAC\"] if PrecipitationMixType is set to Shake.",
        Category -> "Precipitation"
      },
      {
        OptionName -> PrecipitationMixRate,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 RPM, $MaxMixRate],
          Units -> RPM
        ],
        Description -> "The number of rotations per minute that the sample and PrecipitationReagent will be shaken at in order to prepare a uniform mixture prior to incubation.",
        ResolutionDescription -> "Automatically set to 300 RPM, or the lowest speed PrecipitationMixInstrument is capable of, if PrecipitationMixType is set to Shake.",
        Category -> "Precipitation"
      },
      {
        OptionName -> PrecipitationMixTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Ambient" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[Ambient]
          ],
          "Temperature" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],
            Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}
          ]
        ],
        Description -> "The temperature at which the mixing device's heating/cooling block is maintained during the PrecipitationMixTime in order to prepare a uniform mixture prior to incubation.",
        ResolutionDescription -> "Automatically set to Ambient if PrecipitationMixType is set to Shake.",
        Category -> "Precipitation"
      },
      {
        OptionName -> PrecipitationMixTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Description -> "The duration of time that the sample and PrecipitationReagent will be shaken for, at the specified PrecipitationMixRate, in order to prepare a uniform mixture prior to incubation.",
        ResolutionDescription -> "Automatically set to 15 Minute if PrecipitationMixType is set to Shake.",
        Category -> "Precipitation"
      },
      {
        OptionName -> NumberOfPrecipitationMixes,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Number,
          Pattern :> RangeP[1, $MaxNumberOfMixes, 1]
        ],
        Description -> "The number of times the sample and PrecipitationReagent are mixed by pipetting up and down in order to prepare a uniform mixture prior to incubation.",
        ResolutionDescription -> "Automatically set to 10 if PrecipitationMixType is set to Pipette.",
        Category -> "Precipitation"
      },
      {
        OptionName -> PrecipitationMixVolume,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Microliter, $MaxMicropipetteVolume],
          Units -> {Microliter, {Microliter, Milliliter, Liter}}
        ],
        Description -> "The volume of the combined sample and PrecipitationReagent that is displaced during each up and down pipetting cycle in order to prepare a uniform mixture prior to incubation.",
        ResolutionDescription -> "If PrecipitationMixType is set to Pipette, then PrecipitationMixVolume is automatically set to the lesser of 50% of the sample volume plus PrecipitationReagentVolume, or the maximum pipetting volume of Instrument.",
        Category -> "Precipitation"
      },
      {
        OptionName -> PrecipitationTime,
        Default -> 15 Minute,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Description -> "The duration for which the combined sample and PrecipitationReagent are left to settle, at the specified PrecipitationTemperature, in order to encourage crashing of precipitant following any mixing.",
        Category -> "Precipitation"
      },
      {
        OptionName -> PrecipitationInstrument,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          OpenPaths -> {
            {Object[Catalog, "Root"], "Instruments", "Mixing Devices", "Robotic Compatible Mixing Devices"}
          },
          Pattern :> ObjectP[
            {
              Model[Instrument, Shaker],
              Object[Instrument, Shaker],
              Model[Instrument, HeatBlock],
              Object[Instrument, HeatBlock]
            }
          ]
        ],
        Description -> "The instrument used maintain the sample temperature at PrecipitationTemperature while the sample and PrecipitationReagent are left to settle, in order to encourage crashing of precipitant following any mixing.",
        ResolutionDescription -> "Automatically set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"] if PrecipitationTime is greater than 0 Minute and PrecipitationTemperature is greater than 70 Celsius. Otherwise PrecipitationInstrument is set to Model[Instrument, Shaker, \"Inheco ThermoshakeAC\"] if PrecipitationTime is greater than 0 Minute.",
        Category -> "Precipitation"
      },
      {
        OptionName -> PrecipitationTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Ambient" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[Ambient]
          ],
          "Temperature" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],
            Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}
          ]
        ],
        Description -> "The temperature at which the incubation device's heating/cooling block is maintained during the PrecipitationTime in order to encourage crashing out of precipitant.",
        ResolutionDescription -> "Automatically set to Ambient if PrecipitationTime is greater than 0 Minute.",
        Category -> "Precipitation"
      },


      (*---Filtration---*)


      {
        OptionName -> FiltrationInstrument,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          OpenPaths -> {
            {Object[Catalog, "Root"], "Instruments", "Centrifugation", "Robotic Compatible Microcentrifuges"},
            {Object[Catalog, "Root"], "Instruments", "Robotic Compatible Filtering Devices"}
          },
          Pattern :> ObjectP[
            {
              Model[Instrument, Centrifuge],
              Object[Instrument, Centrifuge],
              Model[Instrument, PressureManifold],
              Object[Instrument, PressureManifold]
            }
          ]
        ],
        Description -> "The instrument used to apply force to the sample in order to facilitate its passage through the filter. Either by applying centrifugal force to the filter in a centrifuge, or by applying increased air pressure using a pressure manifold.",
        ResolutionDescription -> "If FiltrationTechnique is set to Centrifuge then FiltrationInstrument is set to Model[Instrument, Centrifuge, \"VSpin\"] if RoboticInstrument is set to STAR, or Model[Instrument, Centrifuge, \"HiG4\"] if RoboticInstrument is not set to STAR. Otherwise, if FiltrationTechnique is set to AirPressure then FiltrationInstrument is set to Model[Instrument, PressureManifold, \"MPE2 Sterile\"].",
        Category -> "Filtration"
      },
      {
        OptionName -> FiltrationTechnique,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> (Centrifuge | AirPressure)
        ],
        Description -> "The type of dead-end filtration used to apply force to the sample in order to facilitate its passage through the filter. This will be done by either applying centrifugal force to the filter in a centrifuge, or by applying increased air pressure using a pressure manifold.",
        ResolutionDescription -> "Automatically set to AirPressure if SeparationTechnique is set to Filter.",
        Category -> "Filtration"
      },
      {
        OptionName -> Filter,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[
            {
              Model[Container, Plate, Filter],
              Object[Container, Plate, Filter]
            }
          ],
          OpenPaths -> {
            {Object[Catalog, "Root"], "Labware", "Filters", "Filter Plates"}
          }
        ],
        Description -> "The consumable container with an embedded filter which is used to separate the solid and liquid phases of the sample, after incubation with PrecipitationReagent.",
        ResolutionDescription -> "If SeparationTechnique is set to Filter, then Filter is automatically set to a filter that fits on the filtration instrument (either the centrifuge or pressure manifold) and matches MembraneMaterial and PoreSize if they are set. If the sample is already in a filter, then Filter is automatically set to that filter and the sample will not be transferred to a new filter unless this option is explicitly changed to a new filter.",
        Category -> "Filtration"
      },

      {
        OptionName -> PrefilterPoreSize,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> FilterSizeP
        ],
        Description -> "The pore size of the prefilter membrane, which is placed above Filter, and is designed so that molecules larger than the specified prefilter pore size should not pass through this filter.",
        ResolutionDescription -> "If SeparationTechnique is set to Filter, then PrefilterPoreSize is automatically set to .45 Micron if PrefilterMembraneMaterial is set.",
        Category -> "Filtration"
      },
      {
        OptionName -> PrefilterMembraneMaterial,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> FilterMembraneMaterialP
        ],
        Description -> "The material from which the prefilter filtration membrane, which is placed above Filter, is composed. Solvents used should be carefully selected to be compatible with the membrane material.",
        ResolutionDescription -> "Automatically set to GxF if PrefilterPoreSize is specified and SeparationTechnique is set to Filter.",
        Category -> "Filtration"
      },
      {
        OptionName -> PoreSize,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> FilterSizeP
        ],
        Description -> "The pore size of the filter which is designed such that molecules larger than the specified pore size should not pass through this filter.",
        ResolutionDescription -> "If SeparationTechnique is set to Filter, then PoreSize is automatically set to the PoreSize of Filter, if it is specified. Otherwise, PoreSize is set to .22 Micron if MembraneMaterial is set.",
        Category -> "Filtration"
      },
      {
        OptionName -> MembraneMaterial,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> FilterMembraneMaterialP
        ],
        Description -> "The material from which the filtration membrane is composed. Solvents used should be carefully selected to be compatible with the membrane material.",
        ResolutionDescription -> "If SeparationTechnique is set to Filter, then MembraneMaterial is automatically set to the MembraneMaterial of Filter, if it is specified. Otherwise, MembraneMaterial is automatically set to PES if a filter pore size is set.",
        Category -> "Filtration"
      },
      {
        OptionName -> FilterPosition,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> String,
          Pattern :> WellPositionP,
          Size -> Line,
          PatternTooltip -> "Enumeration must be any well from A1 to P24."
        ],
        Description -> "The desired position in the Filter in which the samples are placed for the filtering.",
        ResolutionDescription -> "If the input sample is already in a filter, and SeparationTechnique is set to Filter, then FilterPosition is automatically set to the current position.  Otherwise, FilterPosition is set to the first empty position in the filter based on the search order of A1, A2, A3 ... P22, P23, P24.",
        Category -> "Filtration"
      },
      {
        OptionName -> FilterCentrifugeIntensity,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 RPM, $MaxCentrifugeSpeed],
            Units -> Alternatives[RPM]
          ],
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 GravitationalAcceleration, $MaxRelativeCentrifugalForce],
            Units -> Alternatives[GravitationalAcceleration]
          ]
        ],
        Description -> "The rotational speed or force that will be applied to the sample in order to force the liquid through the filter and facilitate separation of the liquid phase from the insoluble molecules that are larger than the PoreSize of Filter.",
        ResolutionDescription -> "Automatically set to 3600 GravitationalAcceleration if FiltrationInstrument is set to Model[Instrument, Centrifuge, \"HiG4\"] or 2800 RPM if FiltrationInstrument is set to Model[Instrument, Centrifuge, \"VSpin\"].",
        Category -> "Filtration"
      },
      {
        OptionName -> FiltrationPressure,
        Default -> Automatic,
        Description -> "The pressure applied to the sample in order to force the liquid through the filter and facilitate separation of the liquid phase from the insoluble molecules that are larger than the PoreSize of Filter.",
        ResolutionDescription -> "Automatically set to 40 PSI if FiltrationTechnique is set to AirPressure.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> GreaterP[0 PSI],
          Units -> {PSI, {Kilopascal, Pascal, PSI, Millibar, Bar}}
        ],
        Category -> "Filtration"
      },
      {
        OptionName -> FiltrationTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Description -> "The duration for which the samples will be exposed to either FiltrationPressure or FilterCentrifugeIntensity in order to force the liquid through the filter and facilitate separation of the liquid phase from the insoluble molecules that are larger than the PoreSize of Filter.",
        ResolutionDescription -> "Automatically set to 10 Minute if SeparationTechnique is set to Filter.",
        Category -> "Filtration"
      },
      {
        OptionName -> FiltrateVolume,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
          Units -> {Microliter, {Microliter, Milliliter, Liter}}
        ],
        Description -> "The amount of the filtrate that will be transferred into a new container, after passing through the filter thus having been separated from the molecules too large to pass through the filter.",
        ResolutionDescription -> "Automatically set to 100% of PrecipitationReagentVolume plus the sample volume if SeparationTechnique is set to Filter.",
        Category -> "Filtration"
      },
      {
        OptionName -> FilterStorageCondition,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Storage Type" -> Widget[
            Type -> Enumeration,
            Pattern :> (SampleStorageTypeP | Disposal)
          ],
          "Storage Object" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[StorageCondition]],
            OpenPaths -> {
              {Object[Catalog, "Root"], "Storage Conditions"}
            },
            PreparedSample -> False,
            PreparedContainer -> False
          ]
        ],
        Description -> "When FilterStorageCondition is not set to Disposal, FilterStorageCondition is the set of parameters that define the environmental conditions under which the filter used by this experiment will be stored after the protocol is completed.",
        ResolutionDescription -> "If TargetPhase is set to Solid, SeparationTechnique is set to Filter, and ResuspensionBuffer is not set to None, then FilterStorageCondition is automatically set to the StorageCondition of the sample. Otherwise, if SeparationTechnique is set to Filter and TargetPhase is set to Liquid, FilterStorageCondition is automatically set to Disposal.",
        Category -> "Filtration"
      },

      (*---Pelleting---*)

      {
        OptionName -> PelletVolume,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Microliter, $MaxMicropipetteVolume],
          Units -> {Microliter, {Microliter, Milliliter, Liter}}
        ],
        Description -> "The expected volume of the pellet after pelleting by centrifugation. This value is used to calculate the distance from the bottom of the container that the pipette tip will be held during aspiration of the supernatant. This calculated distance is such that the pipette tip should be held 2mm above the top of the pellet in order to prevent aspiration of the pellet. Overestimation of PelletVolume will result in less buffer being aspirated while underestimation of PelletVolume will risk aspiration of the pellet.",
        ResolutionDescription -> "Automatically set to 1 Microliter if SeparationTechnique is set to Pellet.",
        Category -> "Pelleting"
      },
      {
        OptionName -> PelletCentrifuge,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[
            {
              Model[Instrument, Centrifuge],
              Object[Instrument, Centrifuge]
            }
          ],
          OpenPaths -> {
            {Object[Catalog, "Root"], "Instruments", "Centrifugation", "Robotic Compatible Microcentrifuges"}
          }
        ],
        Description -> "The centrifuge that will be used to apply centrifugal force to the samples at PelletCentrifugeIntensity for PelletCentrifugeTime in order to facilitate separation by pelleting of insoluble molecules from the liquid phase into a solid phase at the bottom of the container.",
        ResolutionDescription -> "If SeparationTechnique is set to Pellet then PelletCentrifuge is set to Model[Instrument, Centrifuge, \"VSpin\"] if RoboticInstrument is set to STAR, or Model[Instrument, Centrifuge, \"HiG4\"] if RoboticInstrument is not set to STAR.",
        Category -> "Pelleting"
      },
      {
        OptionName -> PelletCentrifugeIntensity,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 RPM, $MaxCentrifugeSpeed],
            Units -> Alternatives[RPM]
          ],
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 GravitationalAcceleration, $MaxRelativeCentrifugalForce],
            Units -> Alternatives[GravitationalAcceleration]
          ]
        ],
        Description -> "The rotational speed or force that will be applied to the sample to facilitate precipitation of insoluble molecules out of solution.",
        ResolutionDescription -> "Automatically set to 3600 GravitationalAcceleration if PelletCentrifuge is set to Model[Instrument, Centrifuge, \"HiG4\"] or 2800 RPM if PelletCentrifuge is set to Model[Instrument, Centrifuge, \"VSpin\"]",
        Category -> "Pelleting"
      },
      {
        OptionName -> PelletCentrifugeTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Description -> "The duration for which the samples will be centrifuged at PelletCentrifugeIntensity in order to facilitate separation by pelleting of insoluble molecules from the liquid phase into a solid phase at the bottom of the container.",
        ResolutionDescription -> "Automatically set to 10 Minute if SeparationTechnique is set to Pellet.",
        Category -> "Pelleting"
      },
      {
        OptionName -> SupernatantVolume,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
          Units -> {Microliter, {Microliter, Milliliter, Liter}}
        ],
        Description -> "The volume of the supernatant that will be transferred to a new container after the insoluble molecules have been pelleted at the bottom of the starting container.",
        ResolutionDescription -> "Automatically set to 90% of the PrecipitationReagentVolume plus the sample volume if SeparationTechnique is set to Pellet.",
        Category -> "Pelleting"
      },


      (*----Wash----*)


      {
        OptionName -> NumberOfWashes,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Number,
          Pattern :> RangeP[0, 20, 1]
        ],
        Description -> "The number of times WashSolution is added to the solid, mixed, and then separated again by either pelleting and aspiration if SeparationTechnique is set to Pellet, or by filtration if SeparationTechnique is set to Filter. The wash steps are performed in order to help further wash impurities from the solid.",
        ResolutionDescription -> "Automatically set to 0 if TargetPhase is set to Liquid, otherwise automatically set to 3.",
        Category -> "Wash"
      },
      {
        OptionName -> WashSolution,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
          OpenPaths -> {
            {Object[Catalog, "Root"], "Materials", "Reagents", "Solvents", "Aqueous Mixtures"}
          }
        ],
        Description -> "The solution used to help further wash impurities from the solid after the liquid phase has been removed. If SeparationTechnique is set to Filter, then the WashSolution will be added to the filter containing the retentate. If SeparationTechnique is set to Pellet, then the WashSolution will be added to the container containing the pellet. Setting NumberOfWashes to a number greater than 1 will repeat all specified wash steps.",
        ResolutionDescription -> "Automatically set to Model[Sample, StockSolution, \"70% Ethanol\"] if NumberOfWashes is set to a number greater than 0.",

        Category -> "Wash"
      },
      {
        OptionName -> WashSolutionVolume,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
          Units -> {Microliter, {Microliter, Milliliter, Liter}}
        ],
        Description -> "The volume of WashSolution which will used to help further wash impurities from the solid after the liquid phase has been separated from it. If SeparationTechnique is set to Filter, then this amount of WashSolution will be added to the filter containing the retentate. If SeparationTechnique is set to Pellet, then this amount of WashSolution will be added to the container containing the pellet.",
        ResolutionDescription -> "Automatically set to 100% of the sample starting volume if NumberOfWashes is set to a number greater than 0.",
        Category -> "Wash"
      },
      {
        OptionName -> WashSolutionTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Ambient" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[Ambient]
          ],
          "Temperature" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],
            Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}
          ]
        ],
        Description -> "The temperature at which WashSolution is incubated at during the WashSolutionEquilibrationTime before being added to the solid in order to help further wash impurities from the solid.",
        ResolutionDescription -> "Automatically set to Ambient if NumberOfWashes is set to a number greater than 0.",
        Category -> "Wash"
      },
      {
        OptionName -> WashSolutionEquilibrationTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Description -> "The minimum duration for which the WashSolution will be kept at WashSolutionTemperature before being used to help further wash impurities from the solid after the liquid phase has been separated from it.",
        ResolutionDescription -> "Automatically set to 10 Minute if NumberOfWashes is set to a number greater than 0.",
        Category -> "Wash"
      },
      {
        OptionName -> WashMixType,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> (Shake | Pipette | None)
        ],
        Description -> "The manner in which the sample is agitated following addition of WashSolution, in order to help further wash impurities from the solid. Shake indicates that the sample will be placed on a shaker at the specified WashMixRate for WashMixTime, while Pipette indicates that WashMixVolume of the sample will be pipetted up and down for the number of times specified by NumberOfWashMixes. None indicates that no mixing occurs before incubation.",
        ResolutionDescription -> "If TargetPhase is set to Solid and NumberOfWashes is greater than 0, then WashMixType is automatically set to Pipette if any corresponding Pipette mixing options are set (WashMixVolume, NumberOfWashMixes) or if SeparationTechnique is set to Filter. If TargetPhase is set to Solid and NumberOfWashes is greater than 0, then WashMixType is automatically set to Shake if Pipette mixing options are not set and SeparationTechnique is set to Pellet. Otherwise, WashMixType is set to None.",
        Category -> "Wash"
      },
      {
        OptionName -> WashMixInstrument,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          OpenPaths -> {
            {Object[Catalog, "Root"], "Instruments", "Mixing Devices", "Robotic Compatible Mixing Devices"}
          },
          Pattern :> ObjectP[
            {
              Model[Instrument, Shaker],
              Object[Instrument, Shaker]
            }
          ]
        ],
        Description -> "The instrument used agitate the sample following the addition of WashSolution in order to help further wash impurities from the solid.",
        ResolutionDescription -> "Automatically set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"] if WashMixType is set to Shake and WashMixTemperature is greater than 70 Celsius. Otherwise WashMixInstrument is set to Model[Instrument, Shaker, \"Inheco ThermoshakeAC\"] if WashMixType is set to Shake.",
            Category -> "Wash"
      },
      {
        OptionName -> WashMixRate,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 RPM, $MaxMixRate],
          Units -> RPM
        ],
        Description -> "The rate at which the solid and WashSolution are mixed, for the duration of WashMixTime, in order to help further wash impurities from the solid.",
        ResolutionDescription -> "Automatically set to 300 RPM, or the lowest speed WashMixInstrument is capable of, if WashMixType is set to Shake.",
        Category -> "Wash"
      },
      {
        OptionName -> WashMixTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Ambient" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[Ambient]
          ],
          "Temperature" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],
            Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}
          ]
        ],
        Description -> "The temperature at which the mixing device's heating/cooling block is maintained for the duration of WashMixTime in order to further wash impurities from the solid.",
        ResolutionDescription -> "Automatically set to Ambient if WashMixType is set to Shake.",
        Category -> "Wash"
      },
      {
        OptionName -> WashMixTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Description -> "The duration for which the solid and WashSolution are mixed at WashMixRate in order to help further wash impurities from the solid.",
        ResolutionDescription -> "Automatically set to 1 Minute if WashMixType is set to Shake .",
        Category -> "Wash"
      },
      {
        OptionName -> NumberOfWashMixes,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Number,
          Pattern :> RangeP[0, $MaxNumberOfMixes, 1]
        ],
        Description -> "The number of times WashMixVolume of the WashSolution is mixed by pipetting up and down in order to help further wash impurities from the solid.",
        ResolutionDescription -> "Automatically set to 3 if WashMixType is set to Pipette.",
        Category -> "Wash"
      },
      {
        OptionName -> WashMixVolume,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Microliter, $MaxMicropipetteVolume],
          Units -> {Microliter, {Microliter, Milliliter, Liter}}
        ],
        Description -> "The volume of WashSolution that is displaced by pipette during each wash mix cycle, for which the number of cycles are defined by NumberOfWashMixes.",
        ResolutionDescription -> "If WashMixType is set to Pipette, then WashMixVolume is automatically set to the lesser of 50% of WashSolutionVolume, or the maximum pipetting volume of Instrument.",
        Category -> "Wash"
      },
      {
        OptionName -> WashPrecipitationTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Description -> "The duration for which the samples remain in WashSolution after any mixing has occurred, held at WashPrecipitationTemperature, in order to allow the solid to precipitate back out of solution before separation of WashSolution from the solid.",
        ResolutionDescription -> "Automatically set to 1 Minute if WashSolutionTemperature is higher than PrecipitationReagentTemperature.",
        Category -> "Wash"
      },
      {
        OptionName -> WashPrecipitationInstrument,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          OpenPaths -> {
            {Object[Catalog, "Root"], "Instruments", "Mixing Devices", "Robotic Compatible Mixing Devices"}
          },
          Pattern :> ObjectP[
            {
              Model[Instrument, Shaker],
              Object[Instrument, Shaker],
              Model[Instrument, HeatBlock],
              Object[Instrument, HeatBlock]
            }
          ]
        ],
        Description -> "The instrument used to maintain the sample and WashSolution at WashPrecipitationTemperature for the WashPrecipitationTime prior to separation.",
        ResolutionDescription -> "Automatically set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"] if WashPrecipitationTime is greater than 0 Minute and WashPrecipitationTemperature is greater than 70 Celsius. Otherwise WashPrecipitationInstrument is set to Model[Instrument, Shaker, \"Inheco ThermoshakeAC\"] if WashPrecipitationTime is greater than 0 Minute.",
        Category -> "Wash"
      },
      {
        OptionName -> WashPrecipitationTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Ambient" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[Ambient]
          ],
          "Temperature" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],
            Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}
          ]
        ],
        Description -> "The temperature which the samples in WashSolution are held at for the duration of WashPrecipitationTime in order to help further wash impurities from the solid.",
        ResolutionDescription -> "Automatically set to Ambient if WashPrecipitationTime is greater than 0 Minute.",
        Category -> "Wash"
      },
      {
        OptionName -> WashCentrifugeIntensity,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 RPM, $MaxCentrifugeSpeed],
            Units -> Alternatives[RPM]
          ],
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 GravitationalAcceleration, $MaxRelativeCentrifugalForce],
            Units -> Alternatives[GravitationalAcceleration]
          ]
        ],
        Description -> "The rotational speed or the force that will be applied to the sample in order to separate the WashSolution from the solid after any mixing and incubation steps have been performed. If SeparationTechnique is set to Filter, then the force is applied to the filter containing the retentate and WashSolution in order to facilitate the solution's passage through the filter and help further wash impurities from the solid. If SeparationTechnique is set to Pellet, then the force is applied to the container containing the pellet and WashSolution in order to encourage the repelleting of the solid.",
        ResolutionDescription -> "If NumberOfWashes is set to a number greater than 0 then WashCentrifugeIntensity is automatically set to 3600 GravitationalAcceleration if either PelletCentrifuge or FiltrationCentrifuge is set to Model[Instrument, Centrifuge, \"HiG4\"] or 2800 RPM if either PelletCentrifuge or FiltrationCentrifuge is set to Model[Instrument, Centrifuge, \"VSpin\"].",
        Category -> "Wash"
      },
      {
        OptionName -> WashPressure,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 PSI, $MaxRoboticAirPressure],
          Units -> {PSI, {Pascal, Kilopascal, PSI, Millibar, Bar}}
        ],
        Description -> "The target pressure applied to the filter containing the retentate and WashSolution in order to facilitate the solution's passage through the filter to help further wash impurities from the retentate.",
        ResolutionDescription -> "If FiltrationTechnique is set to AirPressure and NumberOfWashes is set to a number greater than 0, then WashPressure is automatically set to 40 PSI.",
        Category -> "Wash"
      },
      {
        OptionName -> WashSeparationTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Description -> "The duration for which the samples are exposed to WashPressure or WashCentrifugeIntensity in order to separate the WashSolution from the solid. If SeparationTechnique is set to Filter, then this separation is performed by passing the WashSolution through Filter by applying force of either WashPressure (if FiltrationTechnique is set to AirPressure) or WashCentrifugeIntensity (if FiltrationTechnique is set to Centrifuge). If SeparationTechnique is set to Pellet, then centrifugal force of WashCentrifugeIntensity is applied to encourage the solid to remain as, or return to, a pellet at the bottom of the container.",
        ResolutionDescription -> "If NumberOfWashes greater than 0, then WashSeparationTime is automatically set to 3 Minute if FiltrationTechnique is set to a AirPressure, or otherwise WashSeparationTime is set to 20 Minute.",
        Category -> "Wash"
      },
      {
        OptionName -> DryingTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Ambient" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[Ambient]
          ],
          "Temperature" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],
            Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}
          ]
        ],
        Description -> "The temperature at which the incubation device's heating/cooling block is maintained for the duration of DryingTime after removal of WashSolution, in order to evaporate any residual WashSolution.",
        ResolutionDescription -> "Automatically set to Ambient if TargetPhase is set to Solid.",
        Category -> "Wash"
      },
      {
        OptionName -> DryingTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Description -> "The amount of time for which the solid will be exposed to open air at DryingTemperature following final removal of WashSolution, in order to evaporate any residual WashSolution.",
        ResolutionDescription -> "Automatically set to 20 Minute if TargetPhase is set to Solid.",
        Category -> "Wash"
      },


      (*----Resuspension----*)


      {
        OptionName -> ResuspensionBuffer,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Sample" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
            OpenPaths -> {
              {Object[Catalog, "Root"], "Materials", "Reagents", "Buffers"},
              {Object[Catalog, "Root"], "Materials", "Reagents", "Solvents"}
            }
          ],
          "None" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[None]
          ]
        ],
        Description -> "The solution into which the target molecules of the solid will be resuspended or redissolved. Setting ResuspensionBuffer to None indicates that the sample will not be resuspended and that it will be stored as a solid, after any wash steps have been performed.",
        ResolutionDescription -> "Automatically set to Model[Sample, StockSolution, \"1x TE Buffer\"] if TargetPhase is set to Solid.",
        Category -> "Resuspension"
      },
      {
        OptionName -> ResuspensionBufferVolume,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
          Units -> {Microliter, {Microliter, Milliliter, Liter}}
        ],
        Description -> "The volume of ResuspensionBuffer that will be added to the solid and mixed in an effort to resuspend or redissolve the solid into the buffer.",
        ResolutionDescription -> "If ResuspensionBuffer is not set to None, then ResuspensionBufferVolume is automatically set to the greater of 25% of the original sample volume, or 10 Microliter.",
        Category -> "Resuspension"
      },
      {
        OptionName -> ResuspensionBufferTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Ambient" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[Ambient]
          ],
          "Temperature" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],
            Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}
          ]
        ],
        Description -> "The temperature that the ResuspensionBuffer is incubated at during the ResuspensionBufferEquilibrationTime before being added to the sample in order to resuspend or redissolve the solid into the buffer.",
        ResolutionDescription -> "Automatically set to Ambient if ResuspensionBuffer is not set to None.",
        Category -> "Resuspension"
      },
      {
        OptionName -> ResuspensionBufferEquilibrationTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Description -> "The minimum duration for which the ResuspensionBuffer will be kept at ResuspensionBufferTemperature before being added to the sample in order to resuspend or redissolve the solid into the buffer.",
        ResolutionDescription -> "Automatically set to 10 Minute if ResuspensionBuffer is not set to None.",
        Category -> "Resuspension"
      },
      {
        OptionName -> ResuspensionMixType,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> (Shake | Pipette | None)
        ],
        Description -> "The manner in which the sample is agitated following addition of ResuspensionBuffer in order to encourage the solid phase to resuspend or redissolve into the buffer. Shake indicates that the sample will be placed on a shaker at the specified ResuspensionMixRate for ResuspensionMixTime at ResuspensionMixTemperature, while Pipette indicates that ResuspensionMixVolume of the sample will be pipetted up and down for the number of times specified by NumberOfResuspensionMixes. None indicates that no mixing occurs after adding ResuspensionBuffer.",
        ResolutionDescription -> "If ResuspensionBuffer is not set to None, then ResuspensionMixType is automatically set to Pipette if any corresponding Pipette mixing options are set (ResuspensionMixVolume, NumberOfResuspensionMixes) or if SeparationTechnique is set to Filter. Otherwise ResuspensionMixType is automatically set to Shake.",
        Category -> "Resuspension"
      },
      {
        OptionName -> ResuspensionMixInstrument,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          OpenPaths -> {
            {Object[Catalog, "Root"], "Instruments", "Mixing Devices", "Robotic Compatible Mixing Devices"}
          },
          Pattern :> ObjectP[
            {
              Model[Instrument, Shaker],
              Object[Instrument, Shaker]
            }
          ]
        ],
        Description -> "The instrument used agitate the sample following the addition of ResuspensionBuffer, in order to encourage the solid to redissolve or resuspend into the ResuspensionBuffer.",
        ResolutionDescription -> "Automatically set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"] if ResuspensionMixType is set to Shake and ResuspensionMixTemperature is greater than 70 Celsius. Otherwise ResuspensionMixInstrument is set to Model[Instrument, Shaker, \"Inheco ThermoshakeAC\"] if ResuspensionMixType is set to Shake.",
            Category -> "Resuspension"
      },
      {
        OptionName -> ResuspensionMixRate,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 RPM, $MaxMixRate],
          Units -> RPM
        ],
        Description -> "The rate at which the solid and ResuspensionBuffer are shaken, for the duration of ResuspensionMixTime at ResuspensionMixTemperature, in order to encourage the solid to redissolve or resuspend into the ResuspensionBuffer.",
        ResolutionDescription -> "Automatically set to 300 RPM, or the lowest speed ResuspensionMixInstrument is capable of, if ResuspensionMixType is set to Shake.",
        Category -> "Resuspension"
      },
      {
        OptionName -> ResuspensionMixTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Ambient" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[Ambient]
          ],
          "Temperature" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],
            Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}
          ]
        ],
        Description -> "The temperature at which the sample and ResuspensionBuffer are held at for the duration of ResuspensionMixTime in order to encourage the solid to redissolve or resuspend into the ResuspensionBuffer.",
        ResolutionDescription -> "Automatically set to Ambient if ResuspensionMixType is set to Shake.",
        Category -> "Resuspension"
      },
      {
        OptionName -> ResuspensionMixTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Description -> "The duration of time that the solid and ResuspensionBuffer is shaken for, at the specified ResuspensionMixRate, in order to encourage the solid to redissolve or resuspend into the ResuspensionBuffer.",
        ResolutionDescription -> "Automatically set to 15 Minute if ResuspensionMixType is set to Shake.",
        Category -> "Resuspension"
      },
      {
        OptionName -> NumberOfResuspensionMixes,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Number,
          Pattern :> RangeP[1, $MaxNumberOfMixes, 1]
        ],
        Description -> "The number of times that the ResuspensionMixVolume of the ResuspensionBuffer and solid are mixed by pipetting up and down in order to encourage the solid to redissolve or resuspend into the ResuspensionBuffer.",
        ResolutionDescription -> "Automatically set to 10 if ResuspensionMixType is set to Pipette.",
        Category -> "Resuspension"
      },
      {
        OptionName -> ResuspensionMixVolume,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Microliter, $MaxMicropipetteVolume],
          Units -> {Microliter, {Microliter, Milliliter, Liter}}
        ],
        Description -> "The volume of ResuspensionBuffer that is displaced during each cycle of mixing by pipetting up and down, which is repeated for the number of times defined by NumberOfResuspensionMixes, in order to encourage the solid to redissolve or resuspend into the ResuspensionBuffer.",
        ResolutionDescription -> "If ResuspensionMixType is set to Pipette, then ResuspensionMixVolume is automatically set to the lesser of 50% of ResuspensionBufferVolume, or the maximum pipetting volume of Instrument.",
        Category -> "Resuspension"
      },


      (*---Storage---*)


      {
        OptionName -> PrecipitatedSampleContainerOut,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Container" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[{Object[Container], Model[Container]}]
          ],
          "Container with Index" -> {
            "Index" -> Widget[
              Type -> Number,
              Pattern :> GreaterEqualP[1, 1]
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Container], Model[Container]}],
              PreparedSample -> False,
              PreparedContainer -> False
            ]
          },
          "Container with Well" -> {
            "Well" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
              PatternTooltip -> "Enumeration must be any well from A1 to P24."
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Container], Model[Container]}],
              PreparedSample -> False,
              PreparedContainer -> False
            ]
          },
          "Container with Well and Index" -> {
            "Well" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
              PatternTooltip -> "Enumeration must be any well from A1 to P24."
            ],
            "Index and Container" -> {
              "Index" -> Widget[
                Type -> Number,
                Pattern :> GreaterEqualP[1, 1]
              ],
              "Container" -> Widget[
                Type -> Object,
                Pattern :> ObjectP[{Model[Container]}],
                PreparedSample -> False,
                PreparedContainer -> False
              ]
            }
          }
        ],
        Description -> "The container that contains the resuspended solid isolated after the protocol is completed.",
        ResolutionDescription -> "If ResuspensionBuffer is not set to None, TargetPhase is set to Solid, and SeperationTechinque is set to Filter then ContainerOut is automatically set to a container selected by PreferredContainer[...] based on having sufficient capacity to not overflow when the ResuspensionBufferVolume is added.",
        Category -> "Sample Storage"
      },
      {
        OptionName -> PrecipitatedSampleStorageCondition,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Storage Type" -> Widget[
            Type -> Enumeration,
            Pattern :> (SampleStorageTypeP | Disposal)
          ],
          "Storage Object" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[StorageCondition]],
            OpenPaths -> {
              {Object[Catalog, "Root"], "Storage Conditions"}
            }
          ]
        ],
        Description -> "The set of parameters that define the environmental conditions under which the solid that is isolated during precipitation will be stored, either as a solid, or as a solution if ResuspensionBuffer is not set to None.",
        ResolutionDescription -> "If TargetPhase is set to Solid, then PrecipitatedSampleStorageCondition is automatically set to StorageCondition of SampleIn.",
        Category -> "Sample Storage"
      },
      {
        OptionName -> PrecipitatedSampleLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Line
        ],
        Description -> "A user defined word or phrase used to identify the solid isolated after precipitation is completed, either as a solid, or as a solution if ResuspensionBuffer is not set to None. If SeparationTechnique is set to Filter, then the sample is the retentate comprised of molecules too large to pass through the filter after precipitation. If SeparationTechnique is set to Pellet, then the sample is the pellet after the supernatant formed during precipitation is removed. This label is for use in downstream unit operations.",
        ResolutionDescription -> "Automatically set to \"precipitated solid sample #\" if TargetPhase is set to Solid.",
        Category -> "Sample Storage",
        UnitOperation -> True
      },
      {
        OptionName -> PrecipitatedSampleContainerLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Line
        ],
        Description -> "A user defined word or phrase used to identify the container that will contain the solid isolated after precipitation completed, either as a solid, or as a solution if ResuspensionBuffer is not set to None. If SeparationTechnique is set to Filter, then the sample contained in the container is the retentate comprised of molecules too large to pass through the filter after precipitation. If SeparationTechnique is set to Pellet, then the sample contained in the container is the pellet after the supernatant formed during precipitation is removed. This label is for use in downstream unit operations.",
        ResolutionDescription -> "Automatically set to \"precipitated solid container #\" if TargetPhase is set to Solid.",
        Category -> "Sample Storage",
        UnitOperation -> True
      },
      {
        OptionName -> UnprecipitatedSampleContainerOut,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Container" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[{Object[Container], Model[Container]}]
          ],
          "Container with Index" -> {
            "Index" -> Widget[
              Type -> Number,
              Pattern :> GreaterEqualP[1, 1]
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Container], Model[Container]}],
              PreparedSample -> False,
              PreparedContainer -> False
            ]
          },
          "Container with Well" -> {
            "Well" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
              PatternTooltip -> "Enumeration must be any well from A1 to P24."
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Container], Model[Container]}],
              PreparedSample -> False,
              PreparedContainer -> False
            ]
          },
          "Container with Well and Index" -> {
            "Well" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
              PatternTooltip -> "Enumeration must be any well from A1 to P24."
            ],
            "Index and Container" -> {
              "Index" -> Widget[
                Type -> Number,
                Pattern :> GreaterEqualP[1, 1]
              ],
              "Container" -> Widget[
                Type -> Object,
                Pattern :> ObjectP[{Model[Container]}],
                PreparedSample -> False,
                PreparedContainer -> False
              ]
            }
          }
        ],
        Description -> "The container that will contain the liquid phase after it is separated from the precipitated solid.",
        ResolutionDescription -> "If TargetPhase is set to Liquid, then UnprecipitatedSampleContainerOut is automatically set to a container selected by PreferredContainer[...] based on having sufficient capacity to not overflow when the separated liquid phase is added.",
        Category -> "Filtration"
      },
      {
        OptionName -> UnprecipitatedSampleStorageCondition,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Storage Type" -> Widget[
            Type -> Enumeration,
            Pattern :> (SampleStorageTypeP | Disposal)
          ],
          "Storage Object" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[StorageCondition]],
            OpenPaths -> {
              {Object[Catalog, "Root"], "Storage Conditions"}
            }
          ]
        ],
        Description -> "The set of parameters that define the environmental conditions under which the solid that is isolated during precipitation will be stored, either as a solid, or as a solution if ResuspensionBuffer is not set to None.",
        ResolutionDescription -> "If TargetPhase is set to Liquid, then UnprecipitatedSampleStorageCondition is automatically set to StorageCondition of SampleIn.",
        Category -> "Sample Storage"
      },
      {
        OptionName -> UnprecipitatedSampleLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Line
        ],
        Description -> "A user defined word or phrase used to identify the liquid phase that is separated during this unit operation. If SeparationTechnique is set to Filter, then the sample is the filtrate after it is separated from the molecules too large to pass through the filter. If SeparationTechnique is set to Pellet, then the sample is the supernatant aspirated after the solid is pelleted using centrifugal force. This label is for use in downstream unit operations.",
        ResolutionDescription -> "If TargetPhase is set to Liquid then LiquidSampleLabel is automatically set to \"precipitated liquid phase sample #\".",
        Category -> "Sample Storage",
        UnitOperation -> True
      },
      {
        OptionName -> UnprecipitatedSampleContainerLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Line
        ],
        Description -> "A user defined word or phrase used to identify the container that contains the liquid phase that is separated during this unit operation. If SeparationTechnique is set to Filter, then the sample contained in the container is the filtrate after it is separated from the molecules too large to pass through the filter. If SeparationTechnique is set to Pellet, then the sample contained in the container is the supernatant aspirated after the solid is pelleted using centrifugal force. This label is for use in downstream unit operations.",
        ResolutionDescription -> "If TargetPhase is set to Liquid then FiltrateContainerLabel is automatically set to \"precipitated liquid phase container #\".",
        Category -> "Sample Storage",
        UnitOperation -> True
      },


      (*---- HIDDEN OPTIONS ----*)


      {
        OptionName -> FullUnprecipitatedSampleContainerOut,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Container with Well and Index" -> {
            "Well" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
              PatternTooltip -> "Enumeration must be any well from A1 to P24."
            ],
            "Index and Container" -> {
              "Index" -> Widget[
                Type -> Number,
                Pattern :> GreaterEqualP[1, 1]
              ],
              "Container" -> Widget[
                Type -> Object,
                Pattern :> ObjectP[{Model[Container]}],
                PreparedSample -> False,
                PreparedContainer -> False
              ]
            }
          },
          "Container with Well" -> {
            "Well" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
              PatternTooltip -> "Enumeration must be any well from A1 to P24."
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Container]}],
              PreparedSample -> False,
              PreparedContainer -> False
            ]
          },
          "Set to Null" -> {
            "Set to Null" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives @@ {Null, Null}
            ]
          }
        ],
        Description -> "Fully resolved UnprescipitatedSampleContainerOut.",
        Category -> "Hidden"
      },
      {
        OptionName -> FullPrecipitatedSampleContainerOut,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Container with Well and Index" -> {
            "Well" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
              PatternTooltip -> "Enumeration must be any well from A1 to P24."
            ],
            "Index and Container" -> {
              "Index" -> Widget[
                Type -> Number,
                Pattern :> GreaterEqualP[1, 1]
              ],
              "Container" -> Widget[
                Type -> Object,
                Pattern :> ObjectP[{Model[Container]}],
                PreparedSample -> False,
                PreparedContainer -> False
              ]
            }
          },
          "Container with Well" -> {
            "Well" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
              PatternTooltip -> "Enumeration must be any well from A1 to P24."
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Container]}],
              PreparedSample -> False,
              PreparedContainer -> False
            ]
          },
          "Set to Null" -> {
            "Set to Null" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives @@ {Null, Null}
            ]
          }
        ],
        Description -> "Fully resolved PrescipitatedSampleContainerOut.",
        Category -> "Hidden"
      }
    ],
    {
      OptionName -> Sterile,
      Default -> Automatic,
      AllowNull -> False,
      Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
      Description -> "Indicates if the steps of the protocol are performed in a sterile environment.",
      ResolutionDescription -> "Automatically set to False if any samples have CellType set to Null, otherwise Sterile is set to True",
      Category -> "General"
    },
    {
      OptionName -> RoboticInstrument,
      Default -> Automatic,
      AllowNull -> False,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[
          {
            Model[Instrument, LiquidHandler],
            Object[Instrument, LiquidHandler]
          }
        ],
        OpenPaths -> {
          {Object[Catalog, "Root"], "Instruments", "Liquid Handling", "Robotic Liquid Handlers"}
        }
      ],
      Description -> "The instrument that transfers the sample and buffers between containers to execute the protocol.",
      ResolutionDescription -> "Automatically set to Model[Instrument, LiquidHandler, \"bioSTAR\"] if Sterile is set to True, and sample contains mammalian cell lines. Or, RoboticInstrument is automatically set to Model[Instrument, LiquidHandler, \"microbioSTAR\"] if Sterile is set to True and sample contains non-mammalian cell lines. Otherwise RoboticInstrument is set to Model[Instrument, LiquidHandler, \"Super STAR\"].",
      Category -> "General"
    },

    (*===Shared Options===*)
    RoboticPreparationOption,
    ProtocolOptions,
    SimulationOption,
    NonBiologyPostProcessingOptions,
    SubprotocolDescriptionOption,
    SamplesInStorageOptions,
    WorkCellOption

  }
];
(* PrecipitateOptions -> FilterOptions *)
$PrecipitateToFilterOptionMap = {
  FiltrationTechnique -> FiltrationType,
  FiltrationTime -> Time,
  FilterCentrifugeIntensity -> Intensity,
  FiltrationInstrument -> Instrument,
  Sterile -> Sterile,
  Filter -> Filter,
  FilterPosition -> FilterPosition,
  Volume -> Volume,
  FiltrationPressure -> Pressure,
  MembraneMaterial -> MembraneMaterial,
  PrefilterMembraneMaterial -> PrefilterMembraneMaterial,
  PoreSize -> PoreSize,
  PrefilterPoreSize -> PrefilterPoreSize,
  CollectRetentate -> CollectRetentate,
  RetentateCollectionMethod -> RetentateCollectionMethod,
  ResuspensionBufferVolume -> ResuspensionVolume,
  RetentateContainerOut -> RetentateContainerOut,
  FiltrateContainerOut -> FiltrateContainerOut,
  RetentateDestinationWell -> RetentateDestinationWell,
  FiltrateDestinationWell -> FiltrateDestinationWell,
  ResuspensionBuffer -> ResuspensionBuffer,
  NumberOfResuspensionMixes -> NumberOfResuspensionMixes,
  WashSolution -> RetentateWashBuffer,
  WashSolutionVolume -> RetentateWashVolume,
  NumberOfWashes -> NumberOfRetentateWashes,
  WashSeparationTime -> RetentateWashDrainTime,
  WashCentrifugeIntensity -> RetentateWashCentrifugeIntensity,
  WashPressure -> RetentateWashPressure,
  TargetPhase -> Target,
  RetentateCollectionMethod -> RetentateCollectionMethod,
  CollectRetentate -> CollectRetentate
}

(* ::Subsubsection::Closed:: *)
(*Messages*)

(* PUT YOUR MESSAGES HERE *)

Error::NumberOfWashesConflictingOptions = "The sample(s), `1`, at indicies `5`, have conflicting number of washes options. NumberOfWashes is set to `2` but WashSolution is set to `3` and WashSolutionVolume is set to `4`. When NumberOfWashes is greater than 0, WashSolution must be specified and WashSolutionVolume must be set to a volume greater than 0. Please fix these conflicting options to specify a valid experiment.";
Error::NotWashingConflictingOptions = " The sample(s), `1`, at indicies `20`, have conflicting options for no washes. NumberOfWashes is set to `2`, indicating no washes will be performed for this sample. This requires the following options to be set to Null or 0 but not all of them are. WashSolution is set to `3`, WashSolutionVolume is set to `4`, WashSolutionTemperature is set to `5`, WashSoltuionEquilibrationTime is set to `6`, WashMixType is set to `7`, WashMixInstrument is set to `8`, washMixRate is set to `9`, washMixTemperature is set to `10`, WashMixTime is set to `11`, NumberOfWashMixes is set to `12`, WashMixVolume is set to `13`, WashPrecipitationTime is set to `14`, WashPrecipitationInstrument is set to `15`, WashPrecipitationTemperature is set to `16`, WashCentrifugeIntensity is set to `17`, WashPressure is set to `18` and WashSeparationTime is set to `19`. Please fix these conflicting options to specify a valid experiment.";
Error::ResuspensionBufferConflictingOptions = "The sample(s), `1`, at indicies `4`, have conflicting ResuspensionBufferOptions. ResuspensionBuffer is set to `2` but ResuspensionBufferVolumes is set to `3`. When a ResuspensionBuffer is specified, ResuspensionBufferVolume must be set to a volume greater than zero. If a ResuspensionBuffer is not specified, then ResuspensionBufferVolume must be set to Null or 0. Please fix these conflicting options to specify a valid experiment.";
Error::PrecipitationInstrumentConflictingOptions = "The sample(s), `1`, at indicies `4`, have conflicting precipitation step options. PrecipitationInstrument is set to `2` but PrecipitationTemperature is set to `3`. When a PrecipitationInstrument is specified, PrecipitationTemperature must not be set to Null. If a PrecipitationInstrument is not specified, then PrecipitationTemperature must be set to Null. Please fix these conflicting options to specify a valid experiment.";
Error::SeparationTechniqueConflictingOptions = "The sample(s), `1`, at indices `13`, have conflicting separation options. SeparationTechnique is set to `2`, but FiltrationInstrument -> `3`, FiltrationTechnique -> `4`, Filter -> `5`, FilterPosition -> `6`, FiltrationTime -> `7`, PelletVolume -> `8`, PelletCentrifuge -> `9`, PelletCentrifugeIntensity -> `10`, PelletCentrifugeTime -> `11`, SupernatantVolume -> `12`. If SeparationTechnique is set to Filter, then FiltrationInstrument, FiltrationTechnique, Filter, FilterPosition, and FiltrationTime must be set while PelletVolume, PelletCentrifuge, PelletCentrifugeIntensity, PelletCentrifugeTime, and SupernatantVolume must be Null. If SeparationTechnique is set to Pellet, then PelletVolume, PelletCentrifuge, PelletCentrifugeIntensity, PelletCentrifugeTime, and SupernatantVolume must be set while FiltrationInstrument, FiltrationTechnique, Filter, FilterPosition, and FiltrationTime must be Null. CentrifugeInstrument, CentrifugeIntensity, and CentrifugeTime must be specified. If Centrifuge is set to False, CentrifugeInstrument, CentrifugeIntensity, and CentrifugeTime cannot be specified. Please fix these conflicting options to specify a valid experiment.";
Error::DryingSolidConflictingOptions = " The sample(s), `1`, at indicies `4`, have conflicting Drying Options. DryingTime is set to `2` but DryingTemperature is set to `3`. If DryingTime is set to a time greater than 0 Minute, then DryingTemperature must be set to a temperature greater than 0 Celsius. If Drying time is set to Null or 0, then DryingTemperature must also be set to Null or 0. Please fix these conflicting options to specify a valid experiment.";


Error::PrecipitationMixTypeConflictingOptions = "The sample(s), `1`, at indicies `8`, have conflicting PrecipitationMixType Options. PrecipitationMixType is set to `2` but PrecipitationMixVolume is set to `3`, PrecipitationMixInstrument is set to `4`, NumberOfPrecipitationMixes is set to `5`, PrecipitationTemperature is set to `6`, PrecipitationMixTime is set to `7`. When PrecipitationMixType is set to Shake, PrecipitationMixVolume and PrecipitationMixInstrument must be Null, NumberOfPrecipitationMixes and PrecipitationTemperature cannot be set to Null, and PrecipitationMixTime cannot be set to a time greater than 0 Minute. When PrecipitationMixType is set to Pipette, PrecipitationMixVolume and PrecipitationMixInstrument cannot be set to Null or 0, NumberOfPrecipitationMixes and PrecipitationMixTime must set to Null, and PrecipitationTemperature must be set to Ambient or Null. When PrecipitationMixType is set to None, PrecipitationMixVolume, PrecipitationMixInstrument, NumberOfPrecipitationMixes, PrecipitationTemperature and PrecipitationMixTime must set to Null."
Error::WashMixTypeConflictingOptions = "The sample(s), `1`, at indicies `8`, have conflicting WashBufferMixType Options. WashBufferMixType is set to `2` but WashMixVolume is set to `3`, WashMixInstrument is set to `4`, NumberOfWashMixes is set to `5`, WashBufferTemperature is set to `6`, WashMixTime is set to `7`. When WashBufferMixType is set to Shake, WashMixVolume and WashMixInstrument must be Null, NumberOfWashMixes and WashBufferTemperature cannot be set to Null, and WashMixTime cannot be set to a time greater than 0 Minute. When WashBufferMixType is set to Pipette, WashMixVolume and WashMixInstrument cannot be set to Null or 0, NumberOfWashMixes, WashBufferTemperature, and WashMixTime must set to Null. When WashBufferMixType is set to None, WashMixVolume, WashMixInstrument, NumberOfWashMixes, WashBufferTemperature and WashMixTime must set to Null. Please fix these conflicting options to specify a valid experiment.";
Error::ResuspensionMixTypeConflictingOptions = "The sample(s), `1`, at indicies `8`, have conflicting ResuspensionBufferMixType Options. ResuspensionBufferMixType is set to `2` but ResuspensionMixVolume is set to `3`, ResuspensionMixInstrument is set to `4`, NumberOfResuspensionMixes is set to `5`, ResuspensionBufferTemperature is set to `6`, ResuspensionMixTime is set to `7`. When ResuspensionBufferMixType is set to Shake, ResuspensionMixVolume and ResuspensionMixInstrument must be Null, NumberOfResuspensionMixes and ResuspensionBufferTemperature cannot be set to Null, and ResuspensionMixTime cannot be set to a time greater than 0 Minute. When ResuspensionBufferMixType is set to Pipette, ResuspensionMixVolume and ResuspensionMixInstrument cannot be set to Null or 0, NumberOfResuspensionMixes, ResuspensionBufferTemperature, and ResuspensionMixTime must set to Null. When ResuspensionBufferMixType is set to None, ResuspensionMixVolume, ResuspensionMixInstrument, NumberOfResuspensionMixes, ResuspensionBufferTemperature and ResuspensionMixTime must set to Null. Please fix these conflicting options to specify a valid experiment.";


Error::PreIncubationTemperatureNotSpecified = "The sample(s), `1`, at indicies `8`, has a PreIncubationTemperature Option conflict.PrecipitationReagentTemperature is set to `2`, PrecipitationReagentEquilibrationTime is set to `3`, WashSolutionTemperature is set to `4`, WashSolutionEquilibrationTime is set to `5`, ResuspensionBufferTemperature is set to `6`, and ResuspensionBufferEquilibrationTime is set to `7`. When PrecipitationReagentTemperature, WashSolutionTemperature, or ResuspensionBufferTemperature are set to Null, then the corresponding EquilibrationTime must be set to an amount of time greater than 0 Minute. Please fix these conflicting options to specify a valid experiment.";
Warning::PreIncubationTimeNotSpecified = "The sample(s), `1`, at indicies `8`, has a PreIncubationTime Option conflict.PrecipitationReagentTemperature is set to `2`, PrecipitationReagentEquilibrationTime is set to `3`, WashSolutionTemperature is set to `4`, WashSolutionEquilibrationTime is set to `5`, ResuspensionBufferTemperature is set to `6`, and ResuspensionBufferEquilibrationTime is set to `7`. When PrecipitationReagentTime, WashSolutionTime, or ResuspensionBufferTime are set to Null then the minimum incubation time could vary between repeats of this experiment despite a corresponding EquilibrationTemperature being set. This may result in different reagent Temperatures at time of use between repeats. It is recommended to specify an EquilibrationTime sufficient to ensure the reagent can reach any specified Pre Incubation Temperatures before use, but it is not required.";
Warning::SterileInstrumentConflictingOptions = "The sample(s), `1`, at indicies `4`, have conflicting RoboticInstrument and Sterile Options. Sterile is set to `2` but RoboticInstrument is set to `3`. If Sterile is set to True then RoboticInstrument cannot bet set to STAR. Please fix these conflicting options to specify a valid experiment.";
Warning::PrecipitationWaitTimeConflictingOptions = "The sample(s), `1`, at indicies `5`, have conflicting PrecipitationTime, PrecipitationInstrument and/or PrecipitationTemperature Options. PrecipitationTime is set to `2` but PrecipitationInstrument is set to `3` and PrecipitationTemperature is set to `4`. If PrecipitationTime is set to a time greater than 0 Minute, then neither PrecipitationInstrument nor PrecipitationTemperature can be set to Null. Please fix these conflicting options to specify a valid experiment.";
Warning::NoWashSolutionsForWashingSteps = "The sample(s), `1`, at indicies `5`, have conflicting NumberOfWashes, WashSolution, and/or WashSolutionVolume Options. NumberOfWashes is set to `2` but WashSolution is set to `3` and WashSolutionVolume is set to `4`. If NumberOfWashes is set to a number greater than 0, then WashSolution must not be set to Null and WashSolutionVolume must be set to a volume greater than 0 Milliliter. Please fix these conflicting options to specify a valid experiment.";

(* ::Subsection::Closed:: *)
(*---- Container to Sample Overload ----*)

ExperimentPrecipitate[myContainers : ListableP[ObjectP[{Object[Container], Object[Sample]}] | _String | {LocationPositionP, _String | ObjectP[Object[Container]]}], myOptions : OptionsPattern[]] := Module[
  {cache, listedOptions, listedContainers, outputSpecification, output, gatherTests, containerToSampleResult,
    containerToSampleOutput, samples, sampleOptions, containerToSampleTests, simulation,
    containerToSampleSimulation},

  (* Determine the requested return value from the function *)
  outputSpecification = Quiet[OptionValue[Output]];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests = MemberQ[output, Tests];

  (* Remove temporal links and named objects. *)
  {listedContainers, listedOptions} = {ToList[myContainers], ToList[myOptions]};

  (* Fetch the cache from listedOptions. *)
  cache = ToList[Lookup[listedOptions, Cache, {}]];
  simulation = Lookup[listedOptions, Simulation, Null];

  (* Convert our given containers into samples and sample index-matched options. *)
  containerToSampleResult = If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
      ExperimentPrecipitate,
      listedContainers,
      listedOptions,
      Output -> {Result, Tests, Simulation},
      Simulation -> simulation
    ];

    (* Because we are gathering tests, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
      Null,
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {containerToSampleOutput, containerToSampleSimulation} = containerToSampleOptions[
        ExperimentPrecipitate,
        listedContainers,
        listedOptions,
        Output -> {Result, Simulation},
        Simulation -> simulation
      ],
      $Failed,
      {Download::ObjectDoesNotExist, Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
    ]
  ];

  (* If we were given an empty container, return early. *)
  If[MatchQ[containerToSampleResult, $Failed],
    (* containerToSampleOptions failed - return $Failed *)
    outputSpecification /. {
      Result -> $Failed,
      Tests -> containerToSampleTests,
      Options -> $Failed,
      Preview -> Null
    },
    (* Split up our containerToSample result into the samples and sampleOptions. *)
    {samples, sampleOptions} = containerToSampleOutput;

    (* Call our main function with our samples and converted options. *)
    ExperimentPrecipitate[samples, ReplaceRule[sampleOptions, Simulation -> simulation]]
  ]
];
(* ::Subsection::Closed:: *)
(*---- Main Overload ----*)

ExperimentPrecipitate[mySamples : ListableP[ObjectP[Object[Sample]]], myOptions : OptionsPattern[]] := Module[
  {
    cache, cacheBall, collapsedResolvedOptions, expandedSafeOps, gatherTests, inheritedOptions, listedOptions,
    listedSamples, messages, output, outputSpecification, precipitateCache, performSimulationQ, resultQ,
    protocolObject, resolvedOptions, resolvedOptionsResult, resolvedOptionsTests, resourceResult, resourcePacketTests,
    returnEarlyQ, safeOps, safeOptions, safeOptionTests, templatedOptions, templateTests, resolvedPreparation, roboticSimulation,
    inheritedSimulation, validLengths, validLengthTests, simulation, listedSanitizedSamples, runTime, listedSanitizedOptions,
    sampleFields, samplePacketFields, sampleModelFields, sampleModelPacketFields, containerObjectFields,
    containerObjectPacketFields, containerModelFields, containerModelPacketFields,
    containerModels, reagentSampleModels, reagentSamples, containerModelsFromObjects
    },
  (* Determine the requested return value from the function *)
  outputSpecification = Quiet[OptionValue[Output]];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests = MemberQ[output, Tests];
  messages = !gatherTests;

  (* Remove temporal links *)
  {listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

  (* Call SafeOptions to make sure all options match pattern *)
  {safeOptions, safeOptionTests} = If[gatherTests,
    SafeOptions[ExperimentPrecipitate, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
    {SafeOptions[ExperimentPrecipitate, listedOptions, AutoCorrect -> False], {}}
  ];
  inheritedSimulation = Lookup[safeOptions, Simulation, Null];

  (* Call sanitize-inputs to clean any named objects *)
  {listedSanitizedSamples, safeOps, listedSanitizedOptions} = sanitizeInputs[listedSamples, safeOptions, listedOptions, Simulation -> inheritedSimulation];

  (* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
  If[MatchQ[safeOps, $Failed],
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> safeOptionTests,
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
  ];

  (* Call ValidInputLengthsQ to make sure all options are the right length *)
  {validLengths, validLengthTests} = If[gatherTests,
    ValidInputLengthsQ[ExperimentPrecipitate, {listedSanitizedSamples}, listedSanitizedOptions, Output -> {Result, Tests}],
    {ValidInputLengthsQ[ExperimentPrecipitate, {listedSanitizedSamples}, listedSanitizedOptions], Null}
  ];

  (* If option lengths are invalid return $Failed (or the tests up to this point) *)
  If[!validLengths,
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> Join[safeOptionTests, validLengthTests],
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
  ];

  (* Use any template options to get values for options not specified in myOptions *)
  {templatedOptions, templateTests} = If[gatherTests,
    ApplyTemplateOptions[ExperimentPrecipitate, {listedSanitizedSamples}, listedSanitizedOptions, Output -> {Result, Tests}],
    {ApplyTemplateOptions[ExperimentPrecipitate, {listedSanitizedSamples}, listedSanitizedOptions], Null}
  ];

  (* Return early if the template cannot be used - will only occur if the template object does not exist. *)
  If[MatchQ[templatedOptions, $Failed],
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> Join[safeOptionTests, validLengthTests, templateTests],
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
  ];

  (* Replace our safe options with our inherited options from our template. *)
  inheritedOptions = ReplaceRule[safeOps, templatedOptions];

  (* Expand index-matching options *)
  expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentPrecipitate, {listedSanitizedSamples}, inheritedOptions]];

  (* Fetch the cache from expandedSafeOps *)
  cache = Lookup[expandedSafeOps, Cache, {}];

  (*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
  (* NOTE: This download should download ALL of the fields that are needed by your option resolver and resource packets function. *)

  (* -- Determine which fields from the various Options that can be Objects or Models or Automatic that we need to download -- *)

  (* Download fields from samples that are required.*)
  (* NOTE: All fields downloaded below should already be included in the cache passed down to us by the main function. *)
  sampleFields = DeleteDuplicates[Flatten[{Analytes, Name, Density, Container, Composition, Position, Volume, StorageCondition, CellType, Model}]];
  samplePacketFields = Packet @@ sampleFields;
  sampleModelFields = DeleteDuplicates[Flatten[{Name, Composition, Density}]];
  sampleModelPacketFields = Packet @@ sampleModelFields;
  containerObjectFields = {Contents, Model, Name};
  containerObjectPacketFields = Packet @@ containerObjectFields;
  containerModelFields = {VolumeCalibrations, MaxCentrifugationForce, Footprint, MaxVolume, Positions, Name};
  containerModelPacketFields = Packet @@ containerModelFields;

  containerModels = DeleteDuplicates@Flatten[{
    Cases[
      Flatten[Lookup[safeOps, {PrecipitatedSampleContainerOut, UnprecipitatedSampleContainerOut}]],
      ObjectP[Model[Container]]
    ],
    PreferredContainer[All, LiquidHandlerCompatible -> True, Type -> All]
  }];
  containerModelsFromObjects = DeleteDuplicates@Cases[
    Flatten[Lookup[safeOps, {PrecipitatedSampleContainerOut, UnprecipitatedSampleContainerOut}]],
    ObjectP[Object[Container]]
  ];
  reagentSampleModels = DeleteDuplicates@Cases[
    (* NOTE: Include the default solvents that we can use since we want their packets as well. *)
    (* Model[Sample, StockSolution, "5M Sodium Chloride"], Model[Sample, StockSolution, "5M Sodium Chloride"], Model[Sample, StockSolution, "70% Ethanol"], Model[Sample, StockSolution, "1x TE Buffer"] *)
    Flatten[{Lookup[safeOps, {PrecipitationReagent, WashSolution, ResuspensionBuffer}], Model[Sample, StockSolution, "id:AEqRl954GJb6"], Model[Sample, StockSolution, "id:AEqRl954GJb6"],
      Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"], Model[Sample, StockSolution, "id:n0k9mGzRaJe6"]}],
    ObjectP[Model[Sample]]
  ];
  reagentSamples = DeleteDuplicates@Cases[
    Flatten[Lookup[safeOps, {PrecipitationReagent, WashSolution, ResuspensionBuffer}]],
    ObjectP[Object[Sample]]
  ];

  (* - Big Download to make cacheBall and get the inputs in order by ID - *)

  precipitateCache = Quiet[
    Download[
      {
        (*1*)listedSanitizedSamples,
        (*2*)listedSanitizedSamples,
        (*3*)listedSanitizedSamples,
        (*4*)listedSanitizedSamples,
        (*5*)containerModels,
        (*6*)containerModelsFromObjects,
        (*7*)reagentSampleModels,
        (*8*)reagentSamples
      },
      Evaluate[{
        (*1*){samplePacketFields},
        (*2*){Packet[Model[sampleModelFields]]},
        (*3*){Packet[Container[containerObjectFields]]},
        (*4*){Packet[Container[Model][containerModelFields]]},
        (*5*){containerModelPacketFields, Packet[VolumeCalibrations[{CalibrationFunction}]]},
        (*6*){containerObjectPacketFields, Packet[Model[containerModelFields]], Packet[Model[VolumeCalibrations][{CalibrationFunction}]]},
        (*7*){sampleModelPacketFields},
        (*8*){sampleFields, Packet[Model[sampleModelPacketFields]]}
      }],
      Cache -> cache,
      Simulation -> inheritedSimulation
    ],
    {Download::FieldDoesntExist, Download::NotLinkField}
  ];

  (* Combine our downloaded and simulated cache. *)
  (* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
  cacheBall = FlattenCachePackets[{cache, precipitateCache}];

  (* Build the resolved options *)
  resolvedOptionsResult = If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {resolvedOptions, resolvedOptionsTests} = resolveExperimentPrecipitateOptions[
      ToList[Download[mySamples, Object]],
      expandedSafeOps,
      Cache -> cacheBall,
      Simulation -> inheritedSimulation,
      Output -> {Result, Tests}
    ];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
      {resolvedOptions, resolvedOptionsTests},
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {resolvedOptions, resolvedOptionsTests} = {
        resolveExperimentPrecipitateOptions[
          ToList[Download[mySamples, Object]],
          expandedSafeOps,
          Cache -> cacheBall,
          Simulation -> inheritedSimulation
        ],
        {}
      },
      $Failed,
      {Error::InvalidInput, Error::InvalidOption}
    ]
  ];

  (* Collapse the resolved options *)
  collapsedResolvedOptions = CollapseIndexMatchedOptions[
    ExperimentPrecipitate,
    resolvedOptions,
    Ignore -> ToList[myOptions],
    Messages -> False
  ];

  (* Lookup our resolved Preparation option. *)
  resolvedPreparation = Lookup[resolvedOptions, Preparation];

  (* run all the tests from the resolution; if any of them were False, then we should return early here *)
  (* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
  (* basically, if _not_ all the tests are passing, then we do need to return early *)

  returnEarlyQ = Which[
    MatchQ[resolvedOptionsResult, $Failed],
      True,
    gatherTests,
      Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
    True,
      False
  ];

  performSimulationQ = MemberQ[output, Result | Simulation];
  resultQ = MemberQ[output, Result];

  (* If option resolution failed, return early. *)
  If[returnEarlyQ && !performSimulationQ,
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> Join[safeOptionTests, validLengthTests, templateTests, resolvedOptionsTests],
      Options -> RemoveHiddenOptions[ExperimentPrecipitate, collapsedResolvedOptions],
      Preview -> Null,
      Simulation -> Simulation[]
    }]
  ];

  (* Build packets with resources *)
  {{resourceResult, roboticSimulation, runTime}, resourcePacketTests} = Which[
    MatchQ[resolvedOptionsResult, $Failed],
    {{$Failed, $Failed, $Failed}, {}},
    gatherTests,
    precipitateResourcePackets[
      ToList[Download[mySamples, Object]],
      templatedOptions,
      resolvedOptions,
      Cache -> cacheBall,
      Simulation -> inheritedSimulation,
      Output -> {Result, Tests}
    ],
    True,
    {
      precipitateResourcePackets[
        ToList[Download[mySamples, Object]],
        templatedOptions,
        resolvedOptions,
        Cache -> cacheBall,
        Simulation -> inheritedSimulation
      ],
      {}
    }
  ];

  (* If we were asked for a simulation, also return a simulation. *)
  simulation = Which[
    !performSimulationQ,
    Null,
    MatchQ[resolvedPreparation, Robotic] && MatchQ[roboticSimulation, SimulationP],
    roboticSimulation,
    True,
    Null
  ];

  (* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
  If[!MemberQ[output, Result],
    Return[outputSpecification /. {
      Result -> Null,
      Tests -> Flatten[{safeOptionTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
      Options -> RemoveHiddenOptions[ExperimentPrecipitate, collapsedResolvedOptions],
      Preview -> Null,
      Simulation -> simulation,
      RunTime -> runTime
    }]
  ];

  (* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
  protocolObject = Which[
    (* If our resource packets failed, we can't upload anything. *)
    MatchQ[resourceResult, $Failed],
    $Failed,

    (* If we're doing Preparation->Robotic, return our unit operations packets back without RequireResources called if *)
    (* Upload->False. *)
    MatchQ[resolvedPreparation, Robotic] && MatchQ[Lookup[safeOps, Upload], False],
    Rest[resourceResult], (* unitOperationPackets *)

    (* If we're doing Preparation->Robotic and Upload->True, call ExperimentRoboticSamplePreparation with our primitive. *)
    True,
    Module[{primitive, nonHiddenOptions, experimentFunction},
      (* Create our primitive to feed into RoboticSamplePreparation. *)
      primitive = Precipitate @@ Join[
        {
          Sample -> Download[ToList[mySamples], Object]
        },
        RemoveHiddenPrimitiveOptions[Precipitate, ToList[myOptions]]
      ];

      (* Remove any hidden options before returning. *)
      nonHiddenOptions = RemoveHiddenOptions[ExperimentPrecipitate, collapsedResolvedOptions];

      experimentFunction = Lookup[Experiment`Private`$WorkCellToExperimentFunction, Lookup[resolvedOptions, WorkCell]];

      (* Memoize the value of ExperimentPrecipitate so the framework doesn't spend time resolving it again. *)
      Internal`InheritedBlock[{ExperimentPrecipitate, $PrimitiveFrameworkResolverOutputCache},
        $PrimitiveFrameworkResolverOutputCache = <||>;

        DownValues[ExperimentPrecipitate] = {};

        ExperimentPrecipitate[___, options : OptionsPattern[]] := Module[{frameworkOutputSpecification},
          (* Lookup the output specification the framework is asking for. *)
          frameworkOutputSpecification = Lookup[ToList[options], Output];

          frameworkOutputSpecification /. {
            Result -> Rest[resourceResult],
            Options -> nonHiddenOptions,
            Preview -> Null,
            Simulation -> simulation,
            RunTime -> runTime
          }
        ];

        experimentFunction[
          {primitive},
          Name -> Lookup[safeOps, Name],
          Upload -> Lookup[safeOps, Upload],
          Confirm -> Lookup[safeOps, Confirm],
          CanaryBranch -> Lookup[safeOps, CanaryBranch],
          ParentProtocol -> Lookup[safeOps, ParentProtocol],
          Priority -> Lookup[safeOps, Priority],
          StartDate -> Lookup[safeOps, StartDate],
          HoldOrder -> Lookup[safeOps, HoldOrder],
          QueuePosition -> Lookup[safeOps, QueuePosition],
          Instrument -> Lookup[resolvedOptions, RoboticInstrument],
          Cache -> cacheBall
        ]
      ]
    ]
  ];

  (* Return requested output *)
  outputSpecification /. {
    Result -> protocolObject,
    Tests -> Flatten[{safeOptionTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
    Options -> RemoveHiddenOptions[ExperimentPrecipitate, collapsedResolvedOptions],
    Preview -> Null,
    Simulation -> simulation,
    RunTime -> runTime
  }
];
(* ::Subsection::Closed:: *)
(*---- resolvePrecipitateWorkCell ----*)

DefineOptions[resolvePrecipitateWorkCell,
  SharedOptions :> {
    ExperimentPrecipitate,
    CacheOption,
    SimulationOption,
    OutputOption
  }
];

(* This function should output a list of work cells that are compatible with the user specified options. *)
(* This function is called before all of the options are resolved. *)
resolvePrecipitateWorkCell[
  myContainersAndSamples : ListableP[Automatic | ObjectP[{Object[Sample], Object[Container]}]],
  myOptions : OptionsPattern[]
] :=
    Which[
      (* If it needs to be Sterile *)
      MatchQ[Lookup[myOptions, Sterile], True],
        {bioSTAR, microbioSTAR},
      True,
        {STAR, bioSTAR, microbioSTAR}
    ];


(* ::Subsection::Closed:: *)
(*---- resolveExperimentPrecipitateOptions ----*)

DefineOptions[
  resolveExperimentPrecipitateOptions,
  Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveExperimentPrecipitateOptions[mySamples : {ObjectP[Object[Sample]]...}, myOptions : {_Rule...}, myResolutionOptions : OptionsPattern[resolveExperimentPrecipitateOptions]] := Module[
  {outputSpecification, output, gatherTests, messages, cache, listedOptions, currentSimulation, optionPrecisions, roundedExperimentOptions, optionPrecisionTests, invalidInputs, invalidOptions, mapThreadFriendlyOptions,
    samplePacketFields, sampleFields, sampleModelFields, sampleModelPacketFields, sampleModelPackets, containerObjectFields, containerObjectPacketFields, containerModelFields, containerModelPacketFields,
    discardedSamplePackets, discardedInvalidInputs, deprecatedSamplePackets, deprecatedInvalidInputs, deprecatedTest, discardedTest, samplePackets, sampleContainerPackets, sampleContainerModelPackets, containerModelPackets,
    containerModelFromObjectPackets, reagentSampleModelPackets, reagentSamplePackets, cacheBall, fastCacheBall, allowedWorkCells, resolvedSterile, resolvedWorkCell, positionsOfFilteredSamples,
    positionsOfPelletedSamples, positionsOfPelletedAutomaticPrecipitatedSampleContainers, positionsOfPelletedAutomaticUnprecipitatedSampleContainers, pelletResolvedPrecipitatedContainerOut, pelletResolvedUnprecipitatedContainerOut,
    pelletResolvedPrecipitatedContainerOutNoWells, pelletResolvedUnprecipitatedContainerOutNoWells, pelletResolvedPrecipitatedContainerOutWells, pelletResolvedPrecipitatedContainerOutIndicies,
    pelletResolvedUnprecipitatedContainerOutWells, pelletResolvedUnprecipitatedContainerOutIndicies, partiallyResolvedFilters, partiallyResolvedPrefilterPoreSizes, partiallyResolvedPrefilterMembraneMaterials,
    partiallyResolvedPoreSizes, partiallyResolvedMembraneMaterials, partiallyResolvedFilterPositions, filterResolvedPrecipitatedContainerOutNoWells, filterResolvedUnprecipitatedContainerOutNoWells,
    resolvedRoboticInstrument, resolvedPrecipitationReagents, resolvedPrecipitationReagentVolumes, resolvedPrecipitationMixTypes,
    resolvedPrecipitationMixInstruments, resolvedPrecipitationMixRates, resolvedPrecipitationMixTemperatures, resolvedPrecipitationMixTimes, resolvedNumberOfPrecipitationMixes, resolvedPrecipitationMixVolumes,
    resolvedPrecipitationInstruments, resolvedPrecipitationTemperatures, resolvedFiltrationInstruments, resolvedFiltrationTechniques, resolvedFilters, resolvedPrefilterPoreSizes, resolvedPrefilterMembraneMaterials,
    resolvedPoreSizes, resolvedMembraneMaterials, resolvedFilterPositions, resolvedFilterCentrifugeIntensities, resolvedFiltrationPressures, resolvedFiltrationTimes, resolvedFiltrateVolumes, resolvedFilterStorageConditions,
    resolvedPelletVolumes, resolvedPelletCentrifuges, resolvedPelletCentrifugeIntensities, resolvedPelletCentrifugeTimes, resolvedSupernatantVolumes, resolvedNumberOfWashes, resolvedWashSolutions, resolvedWashSolutionVolumes,
    resolvedWashSolutionTemperatures, resolvedWashSolutionEquilibrationTimes, resolvedWashMixTypes, resolvedWashMixInstruments, resolvedWashMixRates, resolvedWashMixTemperatures, resolvedWashMixTimes,
    resolvedNumberOfWashMixes, resolvedWashMixVolumes, resolvedWashPrecipitationTimes, resolvedWashPrecipitationInstruments, resolvedWashPrecipitationTemperatures, resolvedWashCentrifugeIntensities, resolvedWashPressures,
    resolvedWashSeparationTimes, resolvedDryingTemperatures, resolvedDryingTimes, resolvedResuspensionBuffers, resolvedResuspensionBufferVolumes, resolvedResuspensionBufferTemperatures,
    resolvedResuspensionBufferEquilibrationTimes, resolvedResuspensionMixTypes, resolvedResuspensionMixInstruments, resolvedResuspensionMixRates, resolvedResuspensionMixTemperatures, resolvedResuspensionMixTimes,
    resolvedNumberOfResuspensionMixes, resolvedResuspensionMixVolumes, resolvedPrecipitatedSampleLabels, resolvedPrecipitatedSampleContainerLabels, resolvedUnprecipitatedSampleLabels,
    resolvedUnprecipitatedSampleContainerLabels, partiallyResolvedPrecipitatedContainerOut, partiallyResolvedUnprecipitatedContainerOut, partiallyResolvedPrecipitatedContainerOutNoWells,
    partiallyResolvedUnprecipitatedContainerOutNoWells, partiallyResolvedPrecipitatedContainerOutWells, partiallyResolvedPrecipitatedContainerOutIndicies, partiallyResolvedUnprecipitatedContainerOutWells,
    partiallyResolvedUnprecipitatedContainerOutIndicies,resolvedPrecipitatedSampleStorageConditions, resolvedUnprecipitatedSampleStorageConditions, resolvedPrecipitatedContainerOut, resolvedUnprecipitatedContainerOut,
    resolvedFullPrecipitatedContainerOut, resolvedFullUnprecipitatedContainerOut, resolvedPrecipitatedContainerOutNoWells, resolvedUnprecipitatedContainerOutNoWells, resolvedPrecipitatedContainerOutWells,
    resolvedUnprecipitatedContainerOutWells, resolvedPrecipitatedContainerOutIndicies, resolvedUnprecipitatedContainerOutIndicies, separationTechniqueConflictingOptions, separationTechniqueConflictingOptionsTests,
    sterileInstrumentConflictingOptions, sterileInstrumentConflictingOptionsTests, precipitationWaitTimeConflictingOptions, precipitationWaitTimeConflictingOptionsTests, precipitationInstrumentConflictingOptions,
    precipitationInstrumentConflictingOptionsTests, noWashSolutionsForWashingSteps, noWashSolutionsForWashingStepsTests, notWashingConflictingOptions, notWashingConflictingOptionsTests, dryingSolidConflictingOptions,
    dryingSolidConflictingOptionsTests, preIncubationTemperatureNotSpecified, preIncubationTemperatureNotSpecifiedTests, resuspensionBufferConflictingOptions, resuspensionBufferConflictingOptionsTests,
    preIncubationTimeNotSpecified, precipitationMixTypeConflictingOptions, precipitationMixTypeConflictingOptionsTests, washTypeConflictingOptions,
    washTypeConflictingOptionsTests, resuspensionTypeConflictingOptions, resuspensionTypeConflictingOptionsTests, email, resolvedOptions, resolvedPostProcessingOptions, userMaxIndex, maxIndex, userAndPelletMaxIndex,
    filterBooleans, calculatedSampleVolumes, preIndexMatchedOptionsPerInput, filterTests, resolvedFilterOptions, newSimulation, resolvedPackPlateQPrecipitatedSamples,
    resolvedPackPlateQUnprecipitatedSamples, containerModels, containerModelFromObjects, reagentSampleModels, reagentSamples, resolvedTotalVolumes
  },

  (*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

  (* Determine the requested output format of this function. *)
  outputSpecification = OptionValue[Output];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests = MemberQ[output, Tests];
  messages = !gatherTests;

  (* Fetch our cache from the parent function. *)
  cache = Lookup[ToList[myResolutionOptions], Cache, {}];

  (* ToList our options. *)
  listedOptions = ToList[myOptions];

  (* Lookup our simulation. *)
  currentSimulation = Lookup[ToList[myResolutionOptions], Simulation];

  (* -- DOWNLOAD -- *)
  (* NOTE: All fields downloaded below should already be included in the cache passed down to us by the main function. *)
  sampleFields = DeleteDuplicates[Flatten[{Analytes, Name, Density, Container, Composition, Position, Volume, StorageCondition, CellType}]];
  samplePacketFields = Packet @@ sampleFields;
  sampleModelFields = DeleteDuplicates[Flatten[{Name, Composition, Density}]];
  sampleModelPacketFields = Packet @@ sampleModelFields;
  containerObjectFields = {Contents, Model, Name};
  containerObjectPacketFields = Packet @@ containerObjectFields;
  containerModelFields = {VolumeCalibrations, MaxCentrifugationForce, Footprint, MaxVolume, Positions, Name};
  containerModelPacketFields = Packet @@ containerModelFields;

  containerModels = DeleteDuplicates@Flatten[{
    Cases[
      Flatten[Lookup[myOptions, {PrecipitatedSampleContainerOut, UnprecipitatedSampleContainerOut}]],
      ObjectP[Model[Container]]
    ],
    PreferredContainer[All, LiquidHandlerCompatible -> True, Type -> All]
  }];
  containerModelFromObjects = DeleteDuplicates@Cases[
    Flatten[Lookup[myOptions, {PrecipitatedSampleContainerOut, UnprecipitatedSampleContainerOut}]],
    ObjectP[Object[Container]]
  ];
  reagentSampleModels = DeleteDuplicates@Cases[
    (* NOTE: Include the default solvents that we can use since we want their packets as well. *)
    (* Model[Sample, StockSolution, "5M Sodium Chloride"], Model[Sample, StockSolution, "5M Sodium Chloride"], Model[Sample, StockSolution, "70% Ethanol"], Model[Sample, StockSolution, "1x TE Buffer"] *)
    Flatten[{Lookup[myOptions, {PrecipitationReagent, WashSolution, ResuspensionBuffer}], Model[Sample, StockSolution, "id:AEqRl954GJb6"], Model[Sample, StockSolution, "id:AEqRl954GJb6"],
      Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"], Model[Sample, StockSolution, "id:n0k9mGzRaJe6"]}],
    ObjectP[Model[Sample]]
  ];
  reagentSamples = DeleteDuplicates@Cases[
    Flatten[Lookup[myOptions, {PrecipitationReagent, WashSolution, ResuspensionBuffer}]],
    ObjectP[Object[Sample]]
  ];

  {
    (*1*)samplePackets,
    (*2*)sampleModelPackets,
    (*3*)sampleContainerPackets,
    (*4*)sampleContainerModelPackets,
    (*5*)containerModelPackets,
    (*6*)containerModelFromObjectPackets,
    (*7*)reagentSampleModelPackets,
    (*8*)reagentSamplePackets
  } = Download[
    {
      (*1*)mySamples,
      (*2*)mySamples,
      (*3*)mySamples,
      (*4*)mySamples,
      (*5*)containerModels,
      (*6*)containerModelFromObjects,
      (*7*)reagentSampleModels,
      (*8*)reagentSamples
    },
    {
      (*1*){samplePacketFields},
      (*2*){Packet[Model[sampleModelFields]]},
      (*3*){Packet[Container[containerObjectFields]]},
      (*4*){Packet[Container[Model][containerModelFields]]},
      (*5*){containerModelPacketFields, Packet[VolumeCalibrations[{CalibrationFunction}]]},
      (*6*){containerObjectPacketFields, Packet[Model[containerModelFields]], Packet[Model[VolumeCalibrations][{CalibrationFunction}]]},
      (*7*){sampleModelPacketFields},
      (*8*){sampleFields, Packet[Model[sampleModelPacketFields]]}
    },
    Cache -> cache,
    Simulation -> currentSimulation
  ];

  {
    (*1*)samplePackets,
    (*2*)sampleModelPackets,
    (*3*)sampleContainerPackets,
    (*4*)sampleContainerModelPackets,
    (*5*)containerModelPackets,
    (*6*)containerModelFromObjectPackets,
    (*7*)reagentSampleModelPackets,
    (*8*)reagentSamplePackets
  } = Flatten /@ {
    (*1*)samplePackets,
    (*2*)sampleModelPackets,
    (*3*)sampleContainerPackets,
    (*4*)sampleContainerModelPackets,
    (*5*)containerModelPackets,
    (*6*)containerModelFromObjectPackets,
    (*7*)reagentSampleModelPackets,
    (*8*)reagentSamplePackets
  };

  cacheBall = FlattenCachePackets[{
    cache,
    (*1*)samplePackets,
    (*2*)sampleModelPackets,
    (*3*)sampleContainerPackets,
    (*4*)sampleContainerModelPackets,
    (*5*)containerModelPackets,
    (*6*)containerModelFromObjectPackets,
    (*7*)reagentSampleModelPackets,
    (*8*)reagentSamplePackets
  }];

  fastCacheBall = makeFastAssocFromCache[cacheBall];

  (*-- RESOLVE PREPARATION OPTION --*)
  (* Usually, we resolve our Preparation option here, but since we can only do Preparation -> Robotic, there is no need to. *)

  (* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication, Engine]. Warnings should NOT be surfaced in engine. *)

  (*-- INPUT VALIDATION CHECKS --*)

  (* Get the samples from mySamples that are discarded. *)

  discardedSamplePackets=Cases[Flatten[samplePackets], KeyValuePattern[Status->Discarded]];

  (* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
  discardedInvalidInputs=If[MatchQ[discardedSamplePackets, {}],
    {},
    Lookup[discardedSamplePackets, Object]
  ];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[Length[discardedInvalidInputs]>0&&!gatherTests,
    Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Cache->cache]];
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  discardedTest=If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest=If[Length[discardedInvalidInputs]==0,
        Nothing,
        Test["The input samples "<>ObjectToString[discardedInvalidInputs, Cache->cache]<>" are not discarded:", True, False]
      ];

      passingTest=If[Length[discardedInvalidInputs]==Length[mySamples],
        Nothing,
        Test["The input samples "<>ObjectToString[Complement[mySamples, discardedInvalidInputs], Cache->cacheBall]<>" are not discarded:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* -- DEPRECATED MODEL CHECK -- *)

  (* Get the samples from samplePackets that are deprecated. *)
  deprecatedSamplePackets = Select[Flatten[sampleModelPackets], If[MatchQ[#, Except[Null]], MatchQ[Lookup[#, Deprecated], True]]&];

  (* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
  deprecatedInvalidInputs = Lookup[deprecatedSamplePackets, Object, {}];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[Length[deprecatedInvalidInputs] > 0 && messages,
    Message[Error::DeprecatedModels, ObjectToString[deprecatedInvalidInputs, Cache -> cache]]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  deprecatedTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[deprecatedInvalidInputs] == 0,
        Nothing,
        Test["The input samples " <> ObjectToString[deprecatedInvalidInputs, Cache -> cache] <> " do not have deprecated models:", True, False]
      ];
      passingTest = If[Length[deprecatedInvalidInputs] == Length[mySamples],
        Nothing,
        Test["The input samples " <> ObjectToString[Complement[mySamples, deprecatedInvalidInputs], Cache -> cache] <> " do not have deprecated models:", True, True]
      ];
      {failingTest, passingTest}
    ],
    Nothing
  ];


  (*-- OPTION PRECISION CHECKS --*)

  (* Define the option precisions that need to be checked. *)
  (* NOTE: Don't check CentrifugeIntensity precision here because each centrifuge has a different precision. ExperimentCentrifuge *)
  (* will check this for us. *)
  optionPrecisions = {
    {SampleVolume, 1 * Microliter},
    {PrecipitationReagentVolume, 1 * Microliter},
    {PrecipitationReagentTemperature, 1 * Celsius},
    {PrecipitationReagentEquilibrationTime, 1 * Second},
    {PrecipitationMixRate, 1 * RPM},
    {PrecipitationMixTemperature, 1 * Celsius},
    {PrecipitationMixVolume, 1 * Microliter},
    {PrecipitationTime, 1 * Second},
    {PrecipitationTemperature, 1 * Celsius},
    {FiltrationPressure, 1 * PSI},
    {FiltrationTime, 1 * Second},
    {FiltrateVolume, 1 * Microliter},
    {PelletVolume, 1 * Microliter},
    {PelletCentrifugeTime, 1 * Second},
    {SupernatantVolume, 1 * Microliter},
    {WashSolutionVolume, 1 * Microliter},
    {WashSolutionTemperature, 1 * Celsius},
    {WashSolutionEquilibrationTime, 1 * Second},
    {WashMixRate, 1 * RPM},
    {WashMixTemperature, 1 * Celsius},
    {WashMixTime, 1 * Second},
    {WashMixVolume, 1 * Microliter},
    {WashPrecipitationTime, 1 * Second},
    {WashPrecipitationTemperature, 1 * Celsius},
    {WashPressure, 1 * PSI},
    {WashSeparationTime, 1 * Second},
    {DryingTemperature, 1 * Celsius},
    {DryingTime, 1 * Second},
    {ResuspensionBufferTemperature, 1 * Celsius},
    {ResuspensionBufferEquilibrationTime, 1 * Second},
    {ResuspensionMixRate, 1 * RPM},
    {ResuspensionMixTime, 1 * Second},
    {ResuspensionMixVolume, 1 * Microliter},
    {WashCentrifugeIntensity, 1 * Microliter},
    {WashCentrifugeIntensity, 1 * GravitationalAcceleration},
    {PelletCentrifugeIntensity, 1 * GravitationalAcceleration},
    {FilterCentrifugeIntensity, 1 * GravitationalAcceleration}
  };

  (* There are still a few options that we need to check the precisions of though. *)
  {roundedExperimentOptions, optionPrecisionTests} = If[gatherTests,
    (*If we are gathering tests *)
    RoundOptionPrecision[Association @@ listedOptions, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]], Output -> {Result, Tests}],
    (* Otherwise *)
    {RoundOptionPrecision[Association @@ listedOptions, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]]], {}}
  ];

  (* Convert our options into a MapThread friendly version. *)
  mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentPrecipitate, roundedExperimentOptions];

  (*-- RESOLVE EXPERIMENT OPTIONS --*)


  allowedWorkCells=resolvePrecipitateWorkCell[mySamples, listedOptions];

  (* Resolve WorkCell. *)
  (* Resolve the work cell that we're going to operator on. *)
  resolvedWorkCell=Which[
    (* If the user set the WorkCell, then return that *)
    MatchQ[Lookup[myOptions, WorkCell], WorkCellP],
      Lookup[myOptions, WorkCell],
    (* If the user set the RoboticInstrument, then set the WorkCell based on that if it's also in the allowed WorkCells *)
    And[
      MatchQ[Lookup[myOptions, RoboticInstrument], ObjectP[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"]]],
      MemberQ[allowedWorkCells, bioSTAR]
    ],
      bioSTAR,
    And[
      MatchQ[Lookup[myOptions, RoboticInstrument], ObjectP[Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"]]],
      MemberQ[allowedWorkCells, microbioSTAR]
    ],
      microbioSTAR,
    And[
      MatchQ[Lookup[myOptions, RoboticInstrument], ObjectP[Model[Instrument, LiquidHandler, "id:7X104vnRbRXd"]]],
      MemberQ[allowedWorkCells, STAR]
    ],
      STAR,
    And[
      MemberQ[Lookup[samplePackets, CellType], (Bacterial | Yeast | Fungal)],
      MemberQ[allowedWorkCells, microbioSTAR]
    ],
      microbioSTAR,
    And[
      MemberQ[Lookup[samplePackets, CellType], (Insect | Mammalian)],
      MemberQ[allowedWorkCells, bioSTAR]
    ],
      bioSTAR,
    Length[allowedWorkCells]>0,
      First[allowedWorkCells],
    True,
      STAR
  ];

  (* If any samples have a Sterile that is set to True, then resolvedSterile should be equal to True *)
  resolvedSterile = Which[
    MatchQ[Lookup[myOptions, Sterile], Except[Automatic]],
      Lookup[myOptions, Sterile],
    MemberQ[Lookup[samplePackets, Sterile], True],
      True,
    MatchQ[resolvedWorkCell, (microbioSTAR | bioSTAR)],
      True,
    True,
      False
  ];

  {
    (*This is the start of the mapThreading option resolver, everything that needs to be map threaded goes in here,
		and comes out correctly at the bottom using the variables listed in the exact same order*)
    resolvedPrecipitationReagents,
    resolvedPrecipitationReagentVolumes,
    resolvedPrecipitationMixTypes,
    resolvedPrecipitationMixInstruments,
    resolvedPrecipitationMixRates,
    resolvedPrecipitationMixTemperatures,
    resolvedPrecipitationMixTimes,
    resolvedNumberOfPrecipitationMixes,
    resolvedPrecipitationMixVolumes,
    resolvedPrecipitationInstruments,
    resolvedPrecipitationTemperatures,
    resolvedFiltrationInstruments,
    resolvedFiltrationTechniques,
    resolvedFilterCentrifugeIntensities,
    resolvedFiltrationPressures,
    resolvedFiltrationTimes,
    resolvedFiltrateVolumes,
    resolvedPelletVolumes,
    resolvedPelletCentrifuges,
    resolvedPelletCentrifugeIntensities,
    resolvedPelletCentrifugeTimes,
    resolvedSupernatantVolumes,
    resolvedNumberOfWashes,
    resolvedWashSolutions,
    resolvedWashSolutionVolumes,
    resolvedWashSolutionTemperatures,
    resolvedWashSolutionEquilibrationTimes,
    resolvedWashMixTypes,
    resolvedWashMixInstruments,
    resolvedWashMixRates,
    resolvedWashMixTemperatures,
    resolvedWashMixTimes,
    resolvedNumberOfWashMixes,
    resolvedWashMixVolumes,
    resolvedWashPrecipitationTimes,
    resolvedWashPrecipitationInstruments,
    resolvedWashPrecipitationTemperatures,
    resolvedWashCentrifugeIntensities,
    resolvedWashPressures,
    resolvedWashSeparationTimes,
    resolvedDryingTemperatures,
    resolvedDryingTimes,
    resolvedResuspensionBuffers,
    resolvedResuspensionBufferVolumes,
    resolvedResuspensionBufferTemperatures,
    resolvedResuspensionBufferEquilibrationTimes,
    resolvedResuspensionMixTypes,
    resolvedResuspensionMixInstruments,
    resolvedResuspensionMixRates,
    resolvedResuspensionMixTemperatures,
    resolvedResuspensionMixTimes,
    resolvedNumberOfResuspensionMixes,
    resolvedResuspensionMixVolumes,
    partiallyResolvedFilters,
    partiallyResolvedPrefilterPoreSizes,
    partiallyResolvedPrefilterMembraneMaterials,
    partiallyResolvedPoreSizes,
    partiallyResolvedMembraneMaterials,
    partiallyResolvedFilterPositions,
    resolvedPrecipitatedSampleStorageConditions,
    resolvedUnprecipitatedSampleStorageConditions,
    resolvedFilterStorageConditions,
    resolvedPrecipitatedSampleLabels,
    resolvedPrecipitatedSampleContainerLabels,
    resolvedUnprecipitatedSampleLabels,
    resolvedUnprecipitatedSampleContainerLabels,
    partiallyResolvedPrecipitatedContainerOut,
    partiallyResolvedUnprecipitatedContainerOut,
    partiallyResolvedPrecipitatedContainerOutNoWells,
    partiallyResolvedUnprecipitatedContainerOutNoWells,
    partiallyResolvedPrecipitatedContainerOutWells,
    partiallyResolvedPrecipitatedContainerOutIndicies,
    partiallyResolvedUnprecipitatedContainerOutWells,
    partiallyResolvedUnprecipitatedContainerOutIndicies,
    filterBooleans,
    calculatedSampleVolumes,
    resolvedPackPlateQPrecipitatedSamples,
    resolvedPackPlateQUnprecipitatedSamples,
    resolvedTotalVolumes
  } = Transpose@MapThread[
    Function[{samplePacket, sampleContainerModelPacket, options},
      Module[
        {precipitationReagent, precipitationReagentVolume, precipitationMixType, precipitationMixInstrument, precipitationMixRate,
          precipitationMixTemperature, precipitationMixTime, numberOfPrecipitationMixes, precipitationMixVolume, precipitationInstrument, precipitationTemperature,
          filtrationInstrument, filtrationTechnique, filters, prefilterPoreSize, prefilterMembraneMaterial, poreSize, membraneMaterial, filterPosition,
          filterCentrifugeIntensity, filtrationPressure, filtrationTime, filtrateVolume, pelletVolume, pelletCentrifuge, pelletCentrifugeIntensity,
          pelletCentrifugeTime, supernatantVolume, numberOfWashes, washSolution, washSolutionVolume, washSolutionTemperature, washSolutionEquilibrationTime,
          washMixType, washMixInstrument, washMixRate, washMixTemperature, washMixTime, numberOfWashMixes, washMixVolume, washPrecipitationTime,
          washPrecipitationInstrument, washPrecipitationTemperature, washCentrifugeIntensity, washPressure, washSeparationTime, dryingTemperature,
          dryingTime, resuspensionBuffer, resuspensionBufferVolume, resuspensionBufferTemperature, resuspensionBufferEquilibrationTime, resuspensionMixType,
          resuspensionMixInstrument, resuspensionMixRate, resuspensionMixTemperature, resuspensionMixTime, numberOfResuspensionMixes, resuspensionMixVolume,
          actualPrecipitationReagentTemperature, actualWashSolutionTemperature, precipitatedSampleStorageCondition, unprecipitatedSampleStorageCondition, precipitatedSampleLabels, precipitatedSampleContainerLabels,
          unprecipitatedSampleLabels, unprecipitatedSampleContainerLabels, filterStorageCondition,

          precipitatedContainerOut, unprecipitatedContainerOut, precipitatedContainerOutNoWells, unprecipitatedContainerOutNoWells, myPackPlateQPrecipitatedSample, myPackPlateQUnprecipitatedSample,

          precipitatedContainerOutWell, precipitatedContainerOutIndex, unprecipitatedContainerOutWell, unprecipitatedContainerOutIndex,

          filterBool, calculatedSampleVolume, totalVolume
        },

        (* Calculate the real samplevolume that will be used *)
        (* If the user specified All or Null, then set it to the total volume of the input sample,
         Otherwise set calculatedSampleVolume to the user's input *)
        calculatedSampleVolume = If[
          MatchQ[Lookup[options, SampleVolume], (All | Null)],
          RoundOptionPrecision[Lookup[samplePacket, Volume], 1 Microliter, Messages -> False],
          Lookup[options, SampleVolume]
        ];

        (* Resolve PrecipitationReagent *)
        precipitationReagent = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, PrecipitationReagent], Except[Automatic]],
            Lookup[options, PrecipitationReagent],
          (* If TargetPhase is set to Liquid, then automatically set PrecipitationReagent to Model[Sample, StockSolution, "5M Sodium Chloride"] *)
          MatchQ[Lookup[options, TargetPhase], Liquid],
            Model[Sample, StockSolution, "id:AEqRl954GJb6"],
          (* Otherwise set PrecipitationReagent to Model[Sample, "Isopropanol"] *)
          True,
            Model[Sample, "id:jLq9jXY4k6da"]
        ];

        (* Resolve PrecipitationReagentVolume *)
        precipitationReagentVolume = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, PrecipitationReagentVolume], Except[Automatic]],
            Lookup[options, PrecipitationReagentVolume],
          (* If half of the sample volume is less than 80% of the max - the sample volume and is less than 1 Microliter, then round to 1 microliter. *)
          And[
            MatchQ[calculatedSampleVolume / 2, LessP[(Lookup[sampleContainerModelPacket, MaxVolume] * 0.8) - calculatedSampleVolume]],
            MatchQ[calculatedSampleVolume / 2, LessEqualP[1 Microliter]]
          ],
            1 Microliter,
          (* If half of the sample volume is less than 80% of the max - the sample volume and is greater than 1 Microliter, then round to 1 microliter. *)
          And[
            MatchQ[calculatedSampleVolume / 2, LessP[(Lookup[sampleContainerModelPacket, MaxVolume] * 0.8) - calculatedSampleVolume]],
            MatchQ[calculatedSampleVolume / 2, GreaterP[1 Microliter]]
          ],
            RoundOptionPrecision[calculatedSampleVolume / 2, 1 Microliter, Messages -> False],
          (* If the sample volume is greater than 80% of the max volume and/or greater than the max volume, then half of the caluclatedSampleVolume is used (to avoid negative volume, error-catching will catch later). *)
          MatchQ[calculatedSampleVolume, GreaterEqualP[Lookup[sampleContainerModelPacket, MaxVolume] * 0.8]],
            RoundOptionPrecision[calculatedSampleVolume / 2, 1 Microliter, Messages -> False],
          (* If half of the sample volume is greater than 80% of the max - the sample volume or the sample volume is greater than the max volume (IE, otherwise), then set PrecipitationReagentVolume to the maximum volume of the container * 0.8 - SampleVolume. *)
          True,
            RoundOptionPrecision[(Lookup[sampleContainerModelPacket, MaxVolume] * 0.8) - calculatedSampleVolume, 1 Microliter, Messages -> False]
        ];

        (* Resolve PrecipitationMixType *)
        precipitationMixType = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, PrecipitationMixType], Except[Automatic]],
            Lookup[options, PrecipitationMixType],
          (* If PrecipitationMixVolume OR NumberOfPrecipitationMixes are set by the user: then automatically set precipitationMixType to Pipette *)
          Or[MatchQ[Lookup[options, PrecipitationMixVolume], Except[(Automatic | Null)]], MatchQ[Lookup[options, NumberOfPrecipitationMixes], Except[(Automatic | Null)]]],
            Pipette,
          (* Otherwise, set precipitationMixType to Shake *)
          True,
            Shake
        ];

        (* Resolve PrecipitationMixTemperature *)
        precipitationMixTemperature = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, PrecipitationMixTemperature], Except[Automatic]],
            Lookup[options, PrecipitationMixTemperature],
          (* If PrecipitationMixType is set to Shake then automatically set precipitationMixTemperature to Ambient *)
          MatchQ[precipitationMixType, Shake],
            Ambient,
          (* Otherwise, set precipitationMixTemperature to Null *)
          True,
            Null
        ];

        (* Resolve PrecipitationMixTime *)
        precipitationMixTime = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, PrecipitationMixTime], Except[Automatic]],
            Lookup[options, PrecipitationMixTime],
          (* If PrecipitationMixType is set to Shake then automatically set PrecipitationMixTime to 15 Minute *)
          MatchQ[precipitationMixType, Shake],
            15 Minute,
          (* Otherwise, set PrecipitationMixTime to Null *)
          True,
            Null
        ];

        (* Resolve PrecipitationMixInstrument*)
        precipitationMixInstrument = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, PrecipitationMixInstrument], Except[Automatic]],
            Lookup[options, PrecipitationMixInstrument],
          MatchQ[precipitationMixType, Except[Shake]],
            Null,
          (* Set to the Inheco ThermoshakeAC if the PrecipitationMixTemperature is less than or equal to 70 degrees C and the WorkCell isn't the STAR *)
          And[
            MatchQ[precipitationMixTemperature, (LessEqualP[70 Celsius] | Ambient)],
            !MatchQ[resolvedWorkCell, STAR]
          ],
            Model[Instrument, Shaker, "id:pZx9jox97qNp"], (*Model[Instrument, Shaker, "Inheco ThermoshakeAC"]*)
          (* If the STAR is the chosen workCell set to Model[Instrument, Shaker, "Hamilton Heater Shaker"]*)
          MatchQ[resolvedWorkCell, STAR],
            Model[Instrument, Shaker, "id:KBL5Dvw5Wz6x"], (*Model[Instrument, Shaker, "Hamilton Heater Shaker"]*)
          (* Otherwise, set to the Inheco Incubator Shaker *)
          True,
            Model[Instrument, Shaker, "id:eGakldJkWVnz"] (*Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"]*)
        ];

        (* Resolve PrecipitationMixRate *)
        precipitationMixRate = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, PrecipitationMixRate], Except[Automatic]],
            Lookup[options, PrecipitationMixRate],
          (* If PrecipitationMixType is set to Shake and precipitationMixInstrument is Model[Instrument, Shaker, "id:eGakldJkWVnz"] then automatically set PrecipitationMixRate to 400 RPM *)
          MatchQ[precipitationMixInstrument, ObjectP[Model[Instrument, Shaker, "id:eGakldJkWVnz"]]],
            400 RPM,
          (* If PrecipitationMixType is set to Shake then automatically set PrecipitationMixRate to 300 RPM *)
          MatchQ[precipitationMixType, Shake],
            300 RPM,
          (* Otherwise, set PrecipitationMixRate to Null *)
          True,
            Null
          ];

        (* Resolve NumberOfPrecipitationMixes *)
        numberOfPrecipitationMixes = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, NumberOfPrecipitationMixes], Except[Automatic]],
            Lookup[options, NumberOfPrecipitationMixes],
          (* If PrecipitationMixType is set to Pipette then automatically set NumberOfPrecipitationMixes to 10 *)
          MatchQ[precipitationMixType, Pipette],
            10,
          (* Otherwise, set NumberOfPrecipitationMixes to Null *)
          True,
           Null
        ];

        (*Resolve PrecipitationMixVolume*)
        precipitationMixVolume = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, PrecipitationMixVolume], Except[Automatic]],
            Lookup[options, PrecipitationMixVolume],
          (* If PrecipitationMixType is set to Pipette then automatically set PrecipitationMixVolume to the lesser of 50% of the sample's volume or $MaxRoboticSingleTransferVolume. *)
          And[MatchQ[precipitationMixType, Pipette], (calculatedSampleVolume + precipitationReagentVolume) / 2 > $MaxRoboticSingleTransferVolume],
            $MaxRoboticSingleTransferVolume,
          And[MatchQ[precipitationMixType, Pipette], (calculatedSampleVolume + precipitationReagentVolume) / 2 <= $MaxRoboticSingleTransferVolume],
            RoundOptionPrecision[(calculatedSampleVolume + precipitationReagentVolume) / 2, 1 Microliter, Messages -> False],
          (* Otherwise, set PrecipitationMixVolume to Null *)
          True,
            Null
        ];

        (*Resolve PrecipitationTemperature *)
        precipitationTemperature = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, PrecipitationTemperature], Except[Automatic]],
            Lookup[options, PrecipitationTemperature],
          (* If PrecipitationTime is set to >0 Minute then automatically set PrecipitationTemperature to Ambient. *)
          MatchQ[Lookup[options, PrecipitationTime], GreaterP[0 Minute]],
            Ambient,
          (* Otherwise, set PrecipitationTemperature to Null *)
          True,
            Null
        ];

        (*Resolve PrecipitationInstrument*)
        precipitationInstrument = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, PrecipitationInstrument], Except[Automatic]],
            Lookup[options, PrecipitationInstrument],
          (* If PrecipitationTime is set to !>0 Minute then automatically set PrecipitationInstrument to Null. *)
          !MatchQ[Lookup[options, PrecipitationTime], GreaterP[0 Minute]],
            Null,
          And[
            MatchQ[resolvedWorkCell, (bioSTAR | microbioSTAR)],
            MatchQ[precipitationTemperature, GreaterP[70 Celsius]]
          ],
            Model[Instrument, Shaker, "id:eGakldJkWVnz"], (*Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"]*)
          (* Otherwise, set PrecipitationInstrument to Null *)
          True,
            Model[Instrument, HeatBlock, "id:R8e1Pjp1W39a"] (*Model[Instrument, HeatBlock, "Hamilton Heater Cooler"]*)
        ];

        (*----Filtration Category----*)
        (*Resolve FiltrationTechnique *)
        filtrationTechnique = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, FiltrationTechnique], Except[Automatic]],
            Lookup[options, FiltrationTechnique],
          (* If SeparationTechnique is set to Filter then automatically set FiltrationTechnique to AirPressure. *)
          MatchQ[Lookup[options, SeparationTechnique], Filter],
            AirPressure,
          (* Otherwise, set FiltrationTechnique to Null *)
          True,
            Null
        ];

        (*Resolve FiltrationInstrument *)
        filtrationInstrument = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, FiltrationInstrument], Except[Automatic]],
            Lookup[options, FiltrationInstrument],
          (* If FiltrationTechnique is set to Centrifuge and SeparationTechnique is set to Filter and resolvedWorkCell is STAR, then automatically set FiltrationInstrument to Model[Instrument, Centrifuge, "VSpin"]. *)
          And[MatchQ[filtrationTechnique, Centrifuge], MatchQ[Lookup[options, SeparationTechnique], Filter], MatchQ[resolvedWorkCell, STAR]],
            Model[Instrument, Centrifuge, "id:vXl9j57YaYrk"], (*Model[Instrument, Centrifuge, "VSpin"]*)
          (* If FiltrationTechnique is set to Centrifuge and SeparationTechnique is set to Filter, but resolvedWorkCell isn't STAR then automatically set FiltrationInstrument to Model[Instrument, Centrifuge, "HiG4"]. *)
          And[MatchQ[filtrationTechnique, Centrifuge], MatchQ[Lookup[options, SeparationTechnique], Filter]],
            Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"], (*Model[Instrument, Centrifuge, "HiG4"]*)
          (* Otherwise, if SeparationTechnique is set to Filter, then set FiltrationInstrument to Model[Instrument, Centrifuge, "MPE2"] *)
          And[
            MatchQ[Lookup[options, SeparationTechnique], Filter],
            MatchQ[resolvedWorkCell, STAR]
          ],
            Model[Instrument, PressureManifold, "id:J8AY5jD1okLb"], (*Model[Instrument, PressureManifold, "MPE2"] *)
          MatchQ[Lookup[options, SeparationTechnique], Filter],
            Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"], (*Model[Instrument, PressureManifold, "MPE2 Sterile"] *)

          (* Otherwise, set FiltrationInstrument to Null *)
          True,
            Null
        ];

        (*Resolve FilterCentrifugeIntensity*)
        filterCentrifugeIntensity = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, FilterCentrifugeIntensity], Except[Automatic]],
            Lookup[options, FilterCentrifugeIntensity],
          (* If FiltrationInstrument is set to Vspin then automatically set PelletCentrifugeIntensity to 2800 RPM, *)
          MatchQ[filtrationInstrument, Model[Instrument, Centrifuge, "id:vXl9j57YaYrk"]], (*Model[Instrument, Centrifuge, "Vspin"]*)
            2800 RPM,
          (* If FiltrationTechnique is set to Centrifuge then automatically set FilterCentrifugeIntensity to 3600 GravitationalAcceleration. *)
          MatchQ[filtrationInstrument, Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]], (*Model[Instrument, Centrifuge, "HiG4"]*)
            3600 GravitationalAcceleration,
          (* Otherwise, set FiltrationInstrument to Null *)
          True,
            Null
        ];

        (* Resolve FiltrationPressure *)
        filtrationPressure = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, FiltrationPressure], Except[Automatic]],
            Lookup[options, FiltrationPressure],
          (* If FiltrationTechnique is set to AirPressure then automatically set FiltrationPressure to 40 PSI. *)
          And[MatchQ[filtrationTechnique, AirPressure], MatchQ[Lookup[options, SeparationTechnique], Filter]],
            40 PSI,
          (* Otherwise, set FiltrationPressure to Null *)
          True,
            Null
        ];

        (* Resolve FiltrationTime *)
        filtrationTime = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, FiltrationTime], Except[Automatic]],
            Lookup[options, FiltrationTime],
          (* If SeparationTechnique is set to Filter then automatically set FiltrationTime to 10 Minute. *)
          MatchQ[Lookup[options, SeparationTechnique], Filter],
            10 Minute,
          (* Otherwise, set FiltrationTime to Null *)
          True,
            Null
        ];

        (* Resolve FiltrateVolume *)
        filtrateVolume = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, FiltrateVolume], Except[Automatic]],
            Lookup[options, FiltrateVolume],
          (* If SeparationTechnique is set to Filter then automatically set FiltrateVolume to 100% of PrecipitationReagentVolume plus the sample volume. *)
          MatchQ[Lookup[options, SeparationTechnique], Filter],
            calculatedSampleVolume + precipitationReagentVolume,
          (* Otherwise, set FiltrateVolume to Null *)
          True,
            Null
        ];

        (*----Pelleting Catagory----*)

        (* Resolve PelletVolume *)
        pelletVolume = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, PelletVolume], Except[Automatic]],
            Lookup[options, PelletVolume],
          (* If SeparationTechnique is set to Pellet then automatically set PelletVolume to 1 Microliter. *)
          MatchQ[Lookup[options, SeparationTechnique], Pellet],
            1 Microliter,
          (* Otherwise, set FiltrateVolume to Null *)
          True,
            Null
        ];

        (* Resolve PelletCentrifuge *)
        pelletCentrifuge = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, PelletCentrifuge], Except[Automatic]],
            Lookup[options, PelletCentrifuge],
          (* If SeparationTechnique is set to Pellet and resolvedWorkCell is STAR, then automatically set PelletCentrifuge to Model[Instrument, Centrifuge, "VSpin"]. *)
          And[MatchQ[Lookup[options, SeparationTechnique], Pellet], MatchQ[resolvedWorkCell, STAR]],
            Model[Instrument, Centrifuge, "id:vXl9j57YaYrk"], (*Model[Instrument, Centrifuge, "VSpin"]*)
          (* If SeparationTechnique is set to Pellet and WorkCell is not set to STAR, then automatically set PelletCentrifuge to Model[Instrument, Centrifuge, "HiG4"]. *)
          MatchQ[Lookup[options, SeparationTechnique], Pellet],
            Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"], (*Model[Instrument, Centrifuge, "HiG4"]*)
          (* Otherwise, set PelletCentrifuge to Null *)
          True,
            Null
        ];

        (* Resolve PelletCentrifugeIntensity *)
        pelletCentrifugeIntensity = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, PelletCentrifugeIntensity], Except[Automatic]],
            Lookup[options, PelletCentrifugeIntensity],
          (* If Instrument is set to Vspin then automatically set PelletCentrifugeIntensity to 2800 RPM, *)
          MatchQ[pelletCentrifuge, Model[Instrument, Centrifuge, "id:vXl9j57YaYrk"]], (*Model[Instrument, Centrifuge, "HiG4"]*)
            2800 RPM,
          (* If SeparationTechnique is set to Pellet then automatically set PelletCentrifugeIntensity to 3600 GravitationalAcceleration. *)
          MatchQ[pelletCentrifuge, Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]], (*Model[Instrument, Centrifuge, "VSpin"]*)
            3600 GravitationalAcceleration,
          (* Otherwise, set PelletCentrifugeIntensity to Null *)
          True,
            Null
        ];

        (* Resolve PelletCentrifugeTime*)
        pelletCentrifugeTime = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, PelletCentrifugeTime], Except[Automatic]],
            Lookup[options, PelletCentrifugeTime],
          (* If SeparationTechnique is set to Pellet then automatically set PelletCentrifugeTime to 10 Minute. *)
          MatchQ[Lookup[options, SeparationTechnique], Pellet],
            10 Minute,
          (* Otherwise, set PelletCentrifugeTime to Null *)
          True,
            Null
        ];

        (* Resolve SupernatantVolume *)
        supernatantVolume = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, SupernatantVolume], Except[Automatic]],
            Lookup[options, SupernatantVolume],
          (* If SeparationTechnique is set to Pellet then automatically set SupernatantVolume to 90% of the PrecipitationReagentVolume plus the sample volume. *)
          MatchQ[Lookup[options, SeparationTechnique], Pellet],
            RoundOptionPrecision[0.9 * (calculatedSampleVolume + precipitationReagentVolume), 1 Microliter, Messages -> False],
          (* Otherwise, set PelletCentrifugeTime to Null *)
          True,
            Null
        ];

        (*----Wash----*)
        (* Resolve NumberOfWashes *)
        numberOfWashes = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, NumberOfWashes], Except[Automatic]],
            Lookup[options, NumberOfWashes],
          (* If TargetPhase is set to Liquid then automatically set NumberOfWashes to 0. *)
          MatchQ[Lookup[options, TargetPhase], Liquid],
            0,
          (* Otherwise, set NumberOfWashes to 3 *)
          True,
            3
        ];

        (* Resolve WashSolution *)
        washSolution = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, WashSolution], Except[Automatic]],
            Lookup[options, WashSolution],
          (* If NumberOfWashes is set to a number greater than 0 then WashSolution is set to Model[Sample, StockSolution, "70% Ethanol"]. *)
          MatchQ[numberOfWashes, GreaterP[0]],
            Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"], (*Model[Sample, StockSolution, "70% Ethanol"]*)
          (* Otherwise, set WashSolution to Null *)
          True,
            Null
        ];

        (* Resolve WashSolutionVolume *)
        washSolutionVolume = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, WashSolutionVolume], Except[Automatic]],
            Lookup[options, WashSolutionVolume],
          (* If NumberOfWashes is set to a number greater than 0 then WashSolutionVolume is set to 100% of the sample starting volume]. *)
          MatchQ[numberOfWashes, GreaterP[0]],
            RoundOptionPrecision[calculatedSampleVolume, 1 Microliter, Messages -> False],
          (* Otherwise, set WashSolution to Null *)
          True,
            Null
        ];

        (* Resolve WashSolutionTemperature *)
        washSolutionTemperature = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, WashSolutionTemperature], Except[Automatic]],
            Lookup[options, WashSolutionTemperature],
          (* If NumberOfWashes is set to a number greater than 0 then WashSolutionTemperature is set to Ambient]. *)
          MatchQ[numberOfWashes, GreaterP[0]],
            Ambient,
          (* Otherwise, set WashSolution to Null *)
          True,
            Null
        ];

        (* Resolve WashSolutionEquilibrationTime *)
        washSolutionEquilibrationTime = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, WashSolutionEquilibrationTime], Except[Automatic]],
            Lookup[options, WashSolutionEquilibrationTime],
          (* If NumberOfWashes is set to a number greater than 0 then WashSolutionEquilibrationTime is set to 10 Minute]. *)
          MatchQ[numberOfWashes, GreaterP[0]],
           10 Minute,
          (* Otherwise, set WashSolution to Null *)
          True,
           Null
        ];

        (* Resolve WashMixType*)
        washMixType = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, WashMixType], Except[Automatic]],
           Lookup[options, WashMixType],
          (* If TargetPhase is set to Solid and WashMixVolume OR NumberOfWashMixes are set OR SeparationTechnique is set to Filter by the user: then automatically set washMixType to Pipette *)
          And[MatchQ[Lookup[options, TargetPhase], Solid],
            MatchQ[numberOfWashes, GreaterP[0]],
            Or[
              MatchQ[Lookup[options, WashMixVolume], Except[(Automatic | Null)]],
              MatchQ[Lookup[options, NumberOfWashMixes], Except[(Automatic | Null)]],
              MatchQ[Lookup[options, SeparationTechnique], Filter]
            ]
          ],
           Pipette,
          (* If NumberOfWashes is set to a number greater than 0 and TargetPhase is set to Solid, then set to Shake *)
          And[
            MatchQ[Lookup[options, TargetPhase], Solid],
            MatchQ[numberOfWashes, GreaterP[0]]
          ],
           Shake,
          (* Otherwise, set washMixType to Null *)
          True,
            None
        ];

        (* Resolve WashMixTemperature *)
        washMixTemperature = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, WashMixTemperature], Except[Automatic]],
           Lookup[options, WashMixTemperature],
          (* If WashMixType is set to Shake then automatically set washMixTemperature to Ambient *)
          MatchQ[washMixType, Shake],
            Ambient,
          (* Otherwise, set washMixTemperature to Null *)
          True,
           Null
        ];

        (* Resolve WashMixInstrument *)
        washMixInstrument = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, WashMixInstrument], Except[Automatic]],
           Lookup[options, WashMixInstrument],
          MatchQ[washMixType, Except[Shake]],
          Null,
          (* Set to the Inheco ThermoshakeAC if the PrecipitationMixTemperature is less than or equal to 70 degrees C and the WorkCell isn't the STAR *)
          And[
            MatchQ[washMixTemperature, (LessEqualP[70 Celsius] | Ambient)],
            !MatchQ[resolvedWorkCell, STAR]
          ],
           Model[Instrument, Shaker, "id:pZx9jox97qNp"], (*Model[Instrument, Shaker, "Inheco ThermoshakeAC"]*)
          (* If the STAR is the chosen workCell set to Model[Instrument, Shaker, "Hamilton Heater Shaker"]*)
          MatchQ[resolvedWorkCell, STAR],
            Model[Instrument, Shaker, "id:KBL5Dvw5Wz6x"], (*Model[Instrument, Shaker, "Hamilton Heater Shaker"]*)
          (* Otherwise, set to the Inheco Incubator Shaker *)
          True,
            Model[Instrument, Shaker, "id:eGakldJkWVnz"] (*Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"]*)
        ];

        (* Resolve WashMixRate *)
        washMixRate = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, WashMixRate], Except[Automatic]],
            Lookup[options, WashMixRate],
          (* If WashMixType is set to Shake and washMixInstrument is Model[Instrument, Shaker, "id:eGakldJkWVnz"] then automatically set WashMixRate to 400 RPM *)
          MatchQ[washMixInstrument, ObjectP[Model[Instrument, Shaker, "id:eGakldJkWVnz"]]],
            400 RPM,
          (* If WashMixType is set to Shake then automatically set WashMixRate to 300 RPM *)
          MatchQ[washMixType, Shake],
            300 RPM,
          (* Otherwise, set WashMixRate to Null *)
          True,
            Null
        ];

        (* Resolve WashMixTime *)
        washMixTime = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, WashMixTime], Except[Automatic]],
            Lookup[options, WashMixTime],
          (* If WashMixType is set to Shake then automatically set WashMixTime to 15 Minute *)
          MatchQ[washMixType, Shake],
           15 Minute,
          (* Otherwise, set WashMixTime to Null *)
          True,
            Null
        ];

        (* Resolve NumberOfWashMixes *)
        numberOfWashMixes = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, NumberOfWashMixes], Except[Automatic]],
           Lookup[options, NumberOfWashMixes],
          (* If WashMixType is set to Pipette then automatically set NumberOfWashMixes to 10 *)
          MatchQ[washMixType, Pipette],
            10,
          (* Otherwise, set NumberOfWashMixes to Null *)
          True,
            Null
        ];

        (*Resolve WashMixVolume *)
        washMixVolume = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, WashMixVolume], Except[Automatic]],
            Lookup[options, WashMixVolume],
          (* If WashMixType is set to Pipette then automatically set WashMixVolume to the lesser of 50% of the WashSolutionVolume or $MaxRoboticSingleTransferVolume. *)
          And[MatchQ[washMixType, Pipette], washSolutionVolume / 2 > $MaxRoboticSingleTransferVolume],
            $MaxRoboticSingleTransferVolume,
          And[MatchQ[washMixType, Pipette], washSolutionVolume / 2 <= $MaxRoboticSingleTransferVolume],
            RoundOptionPrecision[calculatedSampleVolume / 2, 1 Microliter, Messages -> False],
          (* Otherwise, set WashMixVolume to Null *)
          True,
           Null
        ];

        (**** Resolve WashPrecipitationTime ****)
        (* This requires a bit of extra calculation because Ambient needs to be $Ambient to do the evaluations *)
        (* This first step is just to make sure we have two temperatures to compare. *)
        actualPrecipitationReagentTemperature = Which[
          MatchQ[Lookup[options, PrecipitationReagentTemperature], Ambient],
           $AmbientTemperature,
          True,
            Lookup[options, PrecipitationReagentTemperature]
        ];

        actualWashSolutionTemperature = Which[
          MatchQ[washSolutionTemperature, Ambient],
           $AmbientTemperature,
          True,
           washSolutionTemperature
        ];

        (* Now set the washPrecipitationTime based on the two variables set above (Unless the user already specified a value for it *)
        washPrecipitationTime = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, WashPrecipitationTime], Except[Automatic]],
           Lookup[options, WashPrecipitationTime],
          (* If WashSolutionTemperature is higher than PrecipitationReagentTemperature then set WashPrecipitationTime to 1 Minute. *)
          (* We need to make certain neither are set to Null to prevent an error *)
          MatchQ[actualWashSolutionTemperature, GreaterP[actualPrecipitationReagentTemperature]],
           1 Minute,
          (* Otherwise, set WashPrecipitationTime to Null *)
          True,
           Null
        ];

        (*Resolve WashPrecipitationTemperature *)
        washPrecipitationTemperature = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, WashPrecipitationTemperature], Except[Automatic]],
            Lookup[options, WashPrecipitationTemperature],
          (* If WashPrecipitationTime is set to >0 Minute then automatically set WashPrecipitationTemperature to Ambient. *)
          MatchQ[washPrecipitationTime, GreaterP[0 Minute]],
            Ambient,
          (* Otherwise, set WashPrecipitationTemperature to Null *)
          True,
            Null
        ];

        (*Resolve WashPrecipitationInstrument*)
        washPrecipitationInstrument = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, WashPrecipitationInstrument], Except[Automatic]],
            Lookup[options, WashPrecipitationInstrument],
          (* If WashPrecipitationTime is set to !>0 Minute then automatically set WashPrecipitationInstrument to Null. *)
          !MatchQ[washPrecipitationTime, GreaterP[0 Minute]],
            Null,
          And[
            MatchQ[resolvedWorkCell, (bioSTAR | microbioSTAR)],
            MatchQ[washPrecipitationTemperature, GreaterP[70 Celsius]]
          ],
            Model[Instrument, Shaker, "id:eGakldJkWVnz"], (*Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"]*)
          (* Otherwise, set WashPrecipitationInstrument to Null *)
          True,
            Model[Instrument, HeatBlock, "id:R8e1Pjp1W39a"] (*Model[Instrument, HeatBlock, "Hamilton Heater Cooler"]*)
        ];

        (*Resolve WashCentrifugeIntensity*)
        washCentrifugeIntensity = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, WashCentrifugeIntensity], Except[Automatic]],
            Lookup[options, WashCentrifugeIntensity],
          (* If numberOfWashes is more than 0, instrument is set to vSpin, and either FiltrationTechnique is set to Centrifuge, or SeparationTechnique is set to Pellet then automatically set WashCentrifugeIntensity to 2800 RPM*)
          And[
            MatchQ[numberOfWashes, GreaterP[0]],
            Or[
              MatchQ[pelletCentrifuge, Model[Instrument, Centrifuge, "id:vXl9j57YaYrk"]], (*Model[Instrument, Centrifuge, "Vspin"]*)
              MatchQ[filtrationInstrument, Model[Instrument, Centrifuge, "id:vXl9j57YaYrk"]](*Model[Instrument, Centrifuge, "Vspin"]*)
            ]
          ],
            2800 RPM,
          (* If numberOfWashes is more than 0 and either FiltrationTechnique is set to Centrifuge, or SeparationTechnique is set to Pellet then automatically set WashCentrifugeIntensity to 3600 GravitationalAcceleration. *)
          And[
            MatchQ[numberOfWashes, GreaterP[0]],
            Or[
              MatchQ[pelletCentrifuge, Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]], (*Model[Instrument, Centrifuge, "HiG4"]*)
              MatchQ[filtrationInstrument, Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]](*Model[Instrument, Centrifuge, "HiG4"]*)
            ]
          ],
            3600 GravitationalAcceleration,
          (* Otherwise, set WashCentrifugeIntensity to Null *)
          True,
            Null
        ];

        (* Resolve WashPressure *)
        washPressure = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, WashPressure], Except[Automatic]],
            Lookup[options, WashPressure],
          (* If FiltrationTechnique is set to AirPressure then automatically set WashPressure to 40 PSI. *)
          And[
            MatchQ[filtrationTechnique, AirPressure],
            MatchQ[numberOfWashes, GreaterP[0]]
          ],
            40 PSI,
          (* Otherwise, set WashPressure to Null *)
          True,
            Null
        ];

        (* Resolve WashSeparationTime*)
        washSeparationTime = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, WashSeparationTime], Except[Automatic]],
            Lookup[options, WashSeparationTime],
          (* If FiltrationTechnique is set to AirPressure AND NumberOfWashes greater than 0 then automatically set WashSeparationTime to 3 Minute. *)
          And[MatchQ[filtrationTechnique, AirPressure], MatchQ[numberOfWashes, GreaterP[0]]],
            3 Minute,
          (* Otherwise, if NumberOfWashes greater than 0 then automatically set WashSeparationTime to 20 Minute. *)
          MatchQ[numberOfWashes, GreaterP[0]],
            20 Minute,
          (* Otherwise, set WashSeparationTime to Null *)
          True,
            Null
        ];

        (* Resolve DryingTemperature *)
        dryingTemperature = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, DryingTemperature], Except[Automatic]],
            Lookup[options, DryingTemperature],
          (* If TargetPhase is set to Solid then automatically set DryingTemperature to Ambient *)
          MatchQ[Lookup[options, TargetPhase], Solid],
            Ambient,
          (* Otherwise, set DryingTemperature to Null *)
          True,
            Null
        ];

        (* Resolve DryingTime *)
        dryingTime = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, DryingTime], Except[Automatic]],
           Lookup[options, DryingTime],
          (* If TargetPhase is set to Solid then automatically set DryingTime to 20 Minute *)
          MatchQ[Lookup[options, TargetPhase], Solid],
            20 Minute,
          (* Otherwise, set DryingTime to Null *)
          True,
            Null
        ];

        (* Resolve ResuspensionBuffer*)
        resuspensionBuffer = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, ResuspensionBuffer], Except[Automatic]],
            Lookup[options, ResuspensionBuffer],
          (* If TargetPhase is set to Solid then ResuspensionBuffer is set to Model[Sample, StockSolution, "1x TE Buffer"]. *)
          MatchQ[Lookup[options, TargetPhase], Solid],
            Model[Sample, StockSolution, "id:n0k9mGzRaJe6"], (*Model[Sample, StockSolution, "1x TE Buffer"]*)
          (* Otherwise, set ResuspensionBuffer to None *)
          True,
            None
        ];

        (* Resolve ResuspensionBufferVolume *)
        resuspensionBufferVolume = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, ResuspensionBufferVolume], Except[Automatic]],
            Lookup[options, ResuspensionBufferVolume],
          (* If ResuspensionBuffer is not set to None (or Null) then ResuspensionBufferVolume is set the greater of 25% of the original sample volume, or 10 Microliter if it would otherwise be less than 10 microliters. *)
          And[
            MatchQ[resuspensionBuffer, Except[(None | Null)]],
            calculatedSampleVolume / 4 > 10 Microliter
          ],
            RoundOptionPrecision[calculatedSampleVolume / 4, 10 Microliter, Messages -> False],
          And[
            MatchQ[resuspensionBuffer, Except[(None | Null)]],
            calculatedSampleVolume / 4 < 10 Microliter
          ],
            10 Microliter,
          (* Otherwise, set WashSolution to Null *)
          True,
            Null
        ];

        (* Resolve ResuspensionBufferTemperature *)
        resuspensionBufferTemperature = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, ResuspensionBufferTemperature], Except[Automatic]],
            Lookup[options, ResuspensionBufferTemperature],
          (* If ResuspensionBuffer is not set to None (or Null) then ResuspensionBufferTemperature is set to Ambient. *)
          MatchQ[resuspensionBuffer, Except[(None | Null)]],
            Ambient,
          (* Otherwise, set ResuspensionBufferTemperature to Null *)
          True,
            Null
        ];

        (* Resolve ResuspensionBufferEquilibrationTime *)
        resuspensionBufferEquilibrationTime = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, ResuspensionBufferEquilibrationTime], Except[Automatic]],
            Lookup[options, ResuspensionBufferEquilibrationTime],
          (* If ResuspensionBuffer is not set to None (or Null) then ResuspensionBufferEquilibrationTime is set to 10 Minute. *)
          MatchQ[resuspensionBuffer, Except[(None | Null)]],
            10 Minute,
          (* Otherwise, set ResuspensionBufferEquilibrationTime to Null *)
          True,
            Null
        ];

        (* Resolve ResuspensionMixType*)
        resuspensionMixType = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, ResuspensionMixType], Except[Automatic]],
            Lookup[options, ResuspensionMixType],
          (* If ResuspensionBuffer is not set to None (or Null) AND ResuspensionMixVolume OR NumberOfResuspensionMixes are set OR SeparationTechnique is set to Fitler by the user: then automatically set resuspensionMixType to Pipette *)
          And[
            MatchQ[resuspensionBuffer, Except[(None | Null)]],
            Or[
              MatchQ[Lookup[options, ResuspensionMixVolume], Except[(Automatic | Null)]],
              MatchQ[Lookup[options, NumberOfResuspensionMixes], Except[(Automatic | Null)]],
              MatchQ[Lookup[options, SeparationTechnique], Filter]
            ]
          ],
            Pipette,
          MatchQ[resuspensionBuffer, Except[(None | Null)]],
            Shake,
          (* Otherwise, set resuspensionMixType to Null *)
          True,
            None
        ];

        (* Resolve ResuspensionMixTemperature *)
        resuspensionMixTemperature = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, ResuspensionMixTemperature], Except[Automatic]],
            Lookup[options, ResuspensionMixTemperature],
          (* If ResuspensionMixType is set to Shake then automatically set resuspensionMixTemperature to Ambient *)
          MatchQ[resuspensionMixType, Shake],
            Ambient,
          (* Otherwise, set resuspensionMixTemperature to Null *)
          True,
            Null
        ];

        (* Resolve ResuspensionMixInstrument *)
        resuspensionMixInstrument = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, ResuspensionMixInstrument], Except[Automatic]],
            Lookup[options, ResuspensionMixInstrument],
          MatchQ[resuspensionMixType, Except[Shake]],
          Null,
          (* Set to the Inheco ThermoshakeAC if the PrecipitationMixTemperature is less than or equal to 70 degrees C and the WorkCell isn't the STAR *)
          And[
            MatchQ[resuspensionMixTemperature, (LessEqualP[70 Celsius] | Ambient)],
            !MatchQ[resolvedWorkCell, STAR]
          ],
            Model[Instrument, Shaker, "id:pZx9jox97qNp"], (*Model[Instrument, Shaker, "Inheco ThermoshakeAC"]*)
          (* If the STAR is the chosen workCell set to Model[Instrument, Shaker, "Hamilton Heater Shaker"]*)
          MatchQ[resolvedWorkCell, STAR],
            Model[Instrument, Shaker, "id:KBL5Dvw5Wz6x"], (*Model[Instrument, Shaker, "Hamilton Heater Shaker"]*)
          (* Otherwise, set to the Inheco Incubator Shaker *)
          True,
            Model[Instrument, Shaker, "id:eGakldJkWVnz"] (*Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"]*)
        ];

        (* Resolve ResuspensionMixRate *)
        resuspensionMixRate = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, ResuspensionMixRate], Except[Automatic]],
            Lookup[options, ResuspensionMixRate],
          (* If ResuspensionMixType is set to Shake and resuspensionMixInstrument is Model[Instrument, Shaker, "id:eGakldJkWVnz"] then automatically set ResuspensionMixRate to 400 RPM *)
          MatchQ[resuspensionMixInstrument, ObjectP[Model[Instrument, Shaker, "id:eGakldJkWVnz"]]],
            400 RPM,
          (* If ResuspensionMixType is set to Shake then automatically set ResuspensionMixRate to 300 RPM *)
          MatchQ[resuspensionMixType, Shake],
            300 RPM,
          (* Otherwise, set ResuspensionMixRate to Null *)
          True,
          Null
        ];

        (* Resolve ResuspensionMixTime *)
        resuspensionMixTime = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, ResuspensionMixTime], Except[Automatic]],
            Lookup[options, ResuspensionMixTime],
          (* If ResuspensionMixType is set to Shake then automatically set ResuspensionMixTime to 15 Minute *)
          MatchQ[resuspensionMixType, Shake],
            15 Minute,
          (* Otherwise, set ResuspensionMixTime to Null *)
          True,
            Null
        ];

        (* Resolve NumberOfResuspensionMixes *)
        numberOfResuspensionMixes = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, NumberOfResuspensionMixes], Except[Automatic]],
           Lookup[options, NumberOfResuspensionMixes],
          (* If ResuspensionMixType is set to Pipette then automatically set NumberOfResuspensionMixes to 10 *)
          MatchQ[resuspensionMixType, Pipette],
            10,
          (* Otherwise, set NumberOfResuspensionMixes to Null *)
          True,
            Null
        ];

        (* Resolve ResuspensionMixVolume *)
        resuspensionMixVolume = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, ResuspensionMixVolume], Except[Automatic]],
            Lookup[options, ResuspensionMixVolume],
          (* If ResuspensionMixType is set to Pipette then automatically set ResuspensionMixVolume to the lesser of 50% of the sample's volume or $MaxRoboticSingleTransferVolume. *)
          And[MatchQ[resuspensionMixType, Pipette], resuspensionBufferVolume / 2 > $MaxRoboticSingleTransferVolume],
            $MaxRoboticSingleTransferVolume,
          And[MatchQ[resuspensionMixType, Pipette], resuspensionBufferVolume / 2 <= $MaxRoboticSingleTransferVolume],
            RoundOptionPrecision[resuspensionBufferVolume / 2, 1 Microliter, Messages -> False],
          (* Otherwise, set ResuspensionMixVolume to Null *)
          True,
            Null
        ];

        (**** These next three will resolve the storage conditions ****)
        (* Resolve PrecipitatedSampleStorageCondition *)
        precipitatedSampleStorageCondition = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, PrecipitatedSampleStorageCondition], Except[Automatic]],
            Lookup[options, PrecipitatedSampleStorageCondition],
          (* If TargetPhase is set to Solid then automatically set PrecipitatedSampleStorageCondition to StorageCondition of Sample. *)
          MatchQ[Lookup[options, TargetPhase], Solid],
            Lookup[Download[Lookup[samplePacket, StorageCondition]], Object],
          (* Otherwise, set PrecipitatedSampleStorageCondition to Null *)
          True,
            Null
        ];

        (* Resolve UnprecipitatedSampleStorageCondition *)
        unprecipitatedSampleStorageCondition = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, UnprecipitatedSampleStorageCondition], Except[Automatic]],
            Lookup[options, UnprecipitatedSampleStorageCondition],
          (* If TargetPhase is set to Liquid then automatically set UnprecipitatedSampleStorageCondition to StorageCondition of Sample. *)
          MatchQ[Lookup[options, TargetPhase], Liquid],
            Lookup[Download[Lookup[samplePacket, StorageCondition]], Object],
          (* Otherwise, set UnprecipitatedSampleStorageCondition to Null *)
          True,
            Null
        ];

        (* Resolve FilterStorageCondition*)
        filterStorageCondition = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, FilterStorageCondition], Except[Automatic]],
            Lookup[options, FilterStorageCondition],
          (* If TargetPhase is set to Solid, SeparationTechnique is set to Filter, and ResuspensionBuffer is not set to None then automatically set FilterStorageCondition to the StorageCondition of the sample. *)
          And[
            MatchQ[Lookup[options, TargetPhase], Solid],
            MatchQ[Lookup[options, SeparationTechnique], Filter],
            MatchQ[resuspensionBuffer, ObjectP[]]
          ],
            Lookup[Download[Lookup[samplePacket, StorageCondition]], Object],
          (*If Target Phase is set to Liquid but SeparationTech is set to Filter, then set FilterStorageCondition to Disposal*)
          And[MatchQ[Lookup[options, TargetPhase], Liquid], MatchQ[Lookup[options, SeparationTechnique], Filter]],
            Disposal,
          (* Otherwise, set FilterStorageCondition to Null *)
          True,
            Null
        ];

        (**** These next four will resolve the labels ****)
        (* Resolve PrecipitatedSampleLabel *)
        precipitatedSampleLabels = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, PrecipitatedSampleLabel], Except[Automatic]],
            Lookup[options, PrecipitatedSampleLabel],
          (* If TargetPhase is set to Solid then automatically set PrecipitatedSampleLabel to "precipitated solid sample #". *)
          MatchQ[Lookup[options, TargetPhase], Solid],
            CreateUniqueLabel["precipitated solid sample"],
          (* Otherwise, set ResuspensionMixVolume to Null *)
          True,
            Null
        ];

        (* Resolve PrecipitatedSampleContainerLabel *)
        precipitatedSampleContainerLabels = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, PrecipitatedSampleContainerLabel], Except[Automatic]],
            Lookup[options, PrecipitatedSampleContainerLabel],
          (* If TargetPhase is set to Solid then automatically set PrecipitatedSampleContainerLabel to "precipitated solid container #". *)
          MatchQ[Lookup[options, TargetPhase], Solid],
            CreateUniqueLabel["precipitated solid container"],
          (* Otherwise, set PrecipitatedSampleContainerLabel to Null *)
          True,
            Null
        ];
        (* Resolve UnprecipitatedSampleLabel *)
        unprecipitatedSampleLabels = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, UnprecipitatedSampleLabel], Except[Automatic]],
            Lookup[options, UnprecipitatedSampleLabel],
          (* If TargetPhase is set to Solid then automatically set UnprecipitatedSampleLabel to "unprecipitated solid sample #". *)
          MatchQ[Lookup[options, TargetPhase], Liquid],
            CreateUniqueLabel["unprecipitated liquid sample"],
          (* Otherwise, set ResuspensionMixVolume to Null *)
          True,
            Null
        ];
        (* Resolve UnprecipitatedSampleContainerLabel *)
        unprecipitatedSampleContainerLabels = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, UnprecipitatedSampleContainerLabel], Except[Automatic]],
            Lookup[options, UnprecipitatedSampleContainerLabel],
          (* If TargetPhase is set to Solid then automatically set UnprecipitatedSampleContainerLabel to "unprecipitated liquid container #". *)
          MatchQ[Lookup[options, TargetPhase], Liquid],
            CreateUniqueLabel["unprecipitated liquid container"],
          (* Otherwise, set UnprecipitatedSampleContainerLabel to Null *)
          True,
            Null
        ];

        (**** These last few are for Filter only, but we need to resolve them to user input first ****)
        (* If ExperimentFilter changes them, they'll be set later by ExperimentFilter *)
        If[MatchQ[Lookup[options, SeparationTechnique], Pellet],

          (* Resolution for Filter if sample is to be Pelleted *)
          filters = Which[
            (* If the user specified it, then set it to what they specified *)
            MatchQ[Lookup[options, Filter], Except[Automatic]],
              Lookup[options, Filter],
            (* Otherwise, set Filter to Null *)
            True,
              Null
          ];
          (* Resolution for PrefilterPoreSize if sample is to be Pelleted *)
          prefilterPoreSize = Which[
            (* If the user specified it, then set it to what they specified *)
            MatchQ[Lookup[options, PrefilterPoreSize], Except[Automatic]],
              Lookup[options, PrefilterPoreSize],
            (* Otherwise, set PrefilterPoreSizes to Null *)
            True,
              Null
          ];
          (* Resolution for PrefilterMembraneMaterials if sample is to be Pelleted *)
          prefilterMembraneMaterial = Which[
            (* If the user specified it, then set it to what they specified *)
            MatchQ[Lookup[options, PrefilterMembraneMaterial], Except[Automatic]],
              Lookup[options, PrefilterMembraneMaterial],
            (* Otherwise, set PrefilterMembraneMaterials to Null *)
            True,
              Null
          ];
          (* Resolution for PoreSizes if sample is to be Pelleted *)
          poreSize = Which[
            (* If the user specified it, then set it to what they specified *)
            MatchQ[Lookup[options, PoreSize], Except[Automatic]],
              Lookup[options, PoreSize],
            (* Otherwise, set PoreSizes to Null *)
            True,
              Null
          ];
          (* Resolution for MembraneMaterial if sample is to be Pelleted *)
          membraneMaterial = Which[
            (* If the user specified it, then set it to what they specified *)
            MatchQ[Lookup[options, MembraneMaterial], Except[Automatic]],
              Lookup[options, MembraneMaterial],
            (* Otherwise, set MembraneMaterials to Null *)
            True,
              Null
          ];
          (* Resolution for FilterPosition if sample is to be Pelleted *)
          filterPosition = Which[
            (* If the user specified it, then set it to what they specified *)
            MatchQ[Lookup[options, FilterPosition], Except[Automatic]],
              Lookup[options, FilterPosition],
            (* Otherwise, set FilterPosition to Null *)
            True,
              Null
          ];
        ];

        (* Resolution for ContainerOuts, this is only a partial resolution to get those which are not Automatic *)
        {precipitatedContainerOutWell, precipitatedContainerOutIndex, precipitatedContainerOut, precipitatedContainerOutNoWells, myPackPlateQPrecipitatedSample} = If[
          (* If the user specified it, then set precipitatedContainerOut to what they specified and set the other variables as appropriate for internal tracking in the resolver and beyond *)
          MatchQ[Lookup[options, PrecipitatedSampleContainerOut], Except[Automatic]],
          Which[
            (* User input: Container *)
            MatchQ[Lookup[options, PrecipitatedSampleContainerOut], ObjectP[{Object[Container], Model[Container]}]],
              {Automatic, Automatic, Lookup[options, PrecipitatedSampleContainerOut], Lookup[options, PrecipitatedSampleContainerOut], True},
            (* User input: {Index, Container} *)
            MatchQ[Lookup[options, PrecipitatedSampleContainerOut], {_Integer, ObjectP[{Object[Container], Model[Container]}]}],
              {Automatic, Lookup[options, PrecipitatedSampleContainerOut][[1]], Lookup[options, PrecipitatedSampleContainerOut], Lookup[options, PrecipitatedSampleContainerOut], False},
            (* User input: {Well, Container} *)
            MatchQ[Lookup[options, PrecipitatedSampleContainerOut], {WellP, ObjectP[{Object[Container], Model[Container]}]}],
              {Lookup[options, PrecipitatedSampleContainerOut][[1]], Automatic, Lookup[options, PrecipitatedSampleContainerOut], Lookup[options, PrecipitatedSampleContainerOut][[2]], False},
            (* User input: {Well, {Index, Container}} *)
            MatchQ[Lookup[options, PrecipitatedSampleContainerOut], {WellP, {_Integer, ObjectP[{Object[Container], Model[Container]}]}}],
              {Flatten[Lookup[options, PrecipitatedSampleContainerOut]][[1]], Flatten[Lookup[options, PrecipitatedSampleContainerOut]][[2]],
                Lookup[options, PrecipitatedSampleContainerOut], Lookup[options, PrecipitatedSampleContainerOut][[2]], False},
            True,
              {Automatic, Automatic, Lookup[options, PrecipitatedSampleContainerOut], Automatic, True}
          ],
          Which[
            (* If Target is set to Liquid, Set this to Null *)
            MatchQ[Lookup[options, TargetPhase], Liquid],
              {Automatic, Automatic, Automatic, Automatic, True},
            (* Otherwise, set PrecipitatedSampleContainerOut to Automatic *)
            True,
              {Automatic, Automatic, Automatic, Automatic, True}
          ]
        ];
        {unprecipitatedContainerOutWell, unprecipitatedContainerOutIndex, unprecipitatedContainerOut, unprecipitatedContainerOutNoWells, myPackPlateQUnprecipitatedSample} = If[
          (* If the user specified it, then set precipitatedContainerOut to what they specified and set the other variables as appropriate for internal tracking in the resolver and beyond *)
          MatchQ[Lookup[options, UnprecipitatedSampleContainerOut], Except[Automatic]],
          Which[
            (* User input: Container *)
            MatchQ[Lookup[options, UnprecipitatedSampleContainerOut], ObjectP[{Object[Container], Model[Container]}]],
              {Automatic, Automatic, Lookup[options, UnprecipitatedSampleContainerOut], Lookup[options, UnprecipitatedSampleContainerOut], True},
            (* User input: {Index, Container} *)
            MatchQ[Lookup[options, UnprecipitatedSampleContainerOut], {_Integer, ObjectP[{Object[Container], Model[Container]}]}],
              {Automatic, Lookup[options, UnprecipitatedSampleContainerOut][[1]], Lookup[options, UnprecipitatedSampleContainerOut], Lookup[options, UnprecipitatedSampleContainerOut], False},
            (* User input: {Well, Container} *)
            MatchQ[Lookup[options, UnprecipitatedSampleContainerOut], {WellP, ObjectP[{Object[Container], Model[Container]}]}],
              {Lookup[options, UnprecipitatedSampleContainerOut][[1]], Automatic, Lookup[options, UnprecipitatedSampleContainerOut], Lookup[options, UnprecipitatedSampleContainerOut][[2]], False},
            (* User input: {Well, {Index, Container}} *)
            MatchQ[Lookup[options, UnprecipitatedSampleContainerOut], {WellP, {_Integer, ObjectP[{Object[Container], Model[Container]}]}}],
              {Flatten[Lookup[options, UnprecipitatedSampleContainerOut]][[1]], Flatten[Lookup[options, UnprecipitatedSampleContainerOut]][[2]],
                Lookup[options, UnprecipitatedSampleContainerOut], Lookup[options, UnprecipitatedSampleContainerOut][[2]], False},
            (* If it is set to Null, we need to specify these in a way that won't mess up Filter when it is called *)
            True,
            {Automatic, Automatic, Lookup[options, PrecipitatedSampleContainerOut], Automatic, True}
          ],
          Which[
            (* If Target is set to Solid, Set this to Null *)
            MatchQ[Lookup[options, TargetPhase], Solid],
              {Automatic, Automatic, Automatic, Automatic, True},
            (* Otherwise, set UnprecipitatedSampleContainerOut to Automatic *)
            True,
              {Automatic, Automatic, Automatic, Automatic, True}
          ]
        ];

        (* Set filterBool to true for any sample that will be filtered instead of pelleted *)
        (* If the SeparationTechnique is set to Filter, than set filterBool to True, otherwise set it to false *)
        filterBool = MatchQ[Lookup[options, SeparationTechnique], Filter];

        (* Total volume to be precipitated. Used for resolving a container. *)
        totalVolume = calculatedSampleVolume + precipitationReagentVolume;

        {
          precipitationReagent,
          precipitationReagentVolume,
          precipitationMixType,
          precipitationMixInstrument,
          precipitationMixRate,
          precipitationMixTemperature,
          precipitationMixTime,
          numberOfPrecipitationMixes,
          precipitationMixVolume,
          precipitationInstrument,
          precipitationTemperature,
          filtrationInstrument,
          filtrationTechnique,
          filterCentrifugeIntensity,
          filtrationPressure,
          filtrationTime,
          filtrateVolume,
          pelletVolume,
          pelletCentrifuge,
          pelletCentrifugeIntensity,
          pelletCentrifugeTime,
          supernatantVolume,
          numberOfWashes,
          washSolution,
          washSolutionVolume,
          washSolutionTemperature,
          washSolutionEquilibrationTime,
          washMixType,
          washMixInstrument,
          washMixRate,
          washMixTemperature,
          washMixTime,
          numberOfWashMixes,
          washMixVolume,
          washPrecipitationTime,
          washPrecipitationInstrument,
          washPrecipitationTemperature,
          washCentrifugeIntensity,
          washPressure,
          washSeparationTime,
          dryingTemperature,
          dryingTime,
          resuspensionBuffer,
          resuspensionBufferVolume,
          resuspensionBufferTemperature,
          resuspensionBufferEquilibrationTime,
          resuspensionMixType,
          resuspensionMixInstrument,
          resuspensionMixRate,
          resuspensionMixTemperature,
          resuspensionMixTime,
          numberOfResuspensionMixes,
          resuspensionMixVolume,
          filters,
          prefilterPoreSize,
          prefilterMembraneMaterial,
          poreSize,
          membraneMaterial,
          filterPosition,
          precipitatedSampleStorageCondition,
          unprecipitatedSampleStorageCondition,
          filterStorageCondition,
          precipitatedSampleLabels,
          precipitatedSampleContainerLabels,
          unprecipitatedSampleLabels,
          unprecipitatedSampleContainerLabels,
          precipitatedContainerOut,
          unprecipitatedContainerOut,
          precipitatedContainerOutNoWells,
          unprecipitatedContainerOutNoWells,
          precipitatedContainerOutWell,
          precipitatedContainerOutIndex,
          unprecipitatedContainerOutWell,
          unprecipitatedContainerOutIndex,
          filterBool,
          calculatedSampleVolume,
          myPackPlateQPrecipitatedSample,
          myPackPlateQUnprecipitatedSample,
          totalVolume
        }
      ]
    ],
    {samplePackets, sampleContainerModelPackets, mapThreadFriendlyOptions}
  ];

  (***** The following section assigns Indicies, Containers, and Wells for pelleted samples where the user did not specifiy a container *****)
  (***** It also specifies Indicies and Wells for where a user specified a container, but not Wells and or Indicies *****)
  (* Calculate the maximum indicies used so far to ensure the assigned indicies do not conflict *)
  userMaxIndex = Max[Select[Flatten[{resolvedPrecipitatedContainerOutIndicies, resolvedUnprecipitatedContainerOutIndicies, 0}], IntegerQ]];


  (* Resolve RoboticInstrument based on resolvedWorkCell*)
  resolvedRoboticInstrument = Which[
    MatchQ[Lookup[myOptions, RoboticInstrument], Except[Automatic]],
      Lookup[myOptions, RoboticInstrument],
    MatchQ[resolvedWorkCell, bioSTAR],
      Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"],
    MatchQ[resolvedWorkCell, microbioSTAR],
      Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"],
    MatchQ[resolvedWorkCell, STAR],
      Model[Instrument, LiquidHandler, "id:7X104vnRbRXd"]
  ];


  (*Get position of all samples that are to be pelleted, and a separate lists of the positions of automatic container specifications. *)
  positionsOfPelletedSamples = Flatten[Position[Lookup[myOptions, SeparationTechnique], Pellet]];
  {
    positionsOfPelletedAutomaticPrecipitatedSampleContainers,
    positionsOfPelletedAutomaticUnprecipitatedSampleContainers
  } = Map[
    Flatten[
      Position[
        Transpose[{
          Lookup[myOptions, SeparationTechnique], Lookup[myOptions, #]
        }],
        {Pellet, Automatic}
      ]
    ]&,
    {
      PrecipitatedSampleContainerOut,
      UnprecipitatedSampleContainerOut
    }
  ];

  (*----Resolve any Pelleting PrecipitatedSampleContainerOut that were not specified by the user ----*)
  {
    pelletResolvedPrecipitatedContainerOut,
    pelletResolvedUnprecipitatedContainerOut,
    pelletResolvedPrecipitatedContainerOutNoWells,
    pelletResolvedUnprecipitatedContainerOutNoWells,
    pelletResolvedPrecipitatedContainerOutWells,
    pelletResolvedPrecipitatedContainerOutIndicies,
    pelletResolvedUnprecipitatedContainerOutWells,
    pelletResolvedUnprecipitatedContainerOutIndicies
  } = If[
    MemberQ[Lookup[myOptions, SeparationTechnique], Pellet],
    Module[
      {
        groupsOfPrecipitatedSampleContainers, groupsOfUnprecipitatedSampleContainers, pelletedPackedContainersOut,
        pelletedPackedContainerOutWells, packedPrecipitatedContainersOutNoWells, packedUnprecipitatedContainersOutNoWells,
        packedPrecipitatedContainersOutWells, packedUnprecipitatedContainersOutWells
      },

      (* Make sure that all of the samples that have to be centrifuged will be packed into DWPs efficiently, column wise. *)
      groupsOfPrecipitatedSampleContainers = If[Length[positionsOfPelletedSamples] > 0,
        (* Assign a unique ID to each group of samples that can be packed into the same container *)
        Module[{allGroups, uniqueGroups, replaceRules},

          (* Assign unique list based on Options that will affect whether something can be in the same plate or not *)
          allGroups = Transpose[{
            resolvedPrecipitationMixTypes[[positionsOfPelletedSamples]],
            resolvedWashMixTypes[[positionsOfPelletedSamples]],
            resolvedResuspensionMixTypes[[positionsOfPelletedSamples]],
            resolvedPrecipitationMixTemperatures[[positionsOfPelletedSamples]],
            resolvedWashMixTemperatures[[positionsOfPelletedSamples]],
            resolvedResuspensionMixTemperatures[[positionsOfPelletedSamples]],
            resolvedNumberOfWashes[[positionsOfPelletedSamples]],
            Lookup[myOptions, TargetPhase][[positionsOfPelletedSamples]]
          }];

          (* Remove all the duplicate groups so we have only the unique ones *)
          uniqueGroups = DeleteDuplicates[allGroups];

          (* Using the unique groups, create a list of rules to replace with newly generated group IDs *)
          replaceRules = # -> CreateUniqueLabel["group"] & /@ uniqueGroups;

          (* Make a list that'll correspond to the samples with a unique group ID, that's what we return *)
          Replace[replaceRules] /@ allGroups
        ],
        {}
      ];

      (*  ----Resolve any Pelleting UnprecipitatedSampleContainerOut that were not specified by the user ----
       Make sure that all of the samples that have to be centrifuged will be packed into DWPs efficiently, column wise. *)
      groupsOfUnprecipitatedSampleContainers = If[Length[positionsOfPelletedSamples] > 0,
        (*Assign a unique ID to each group of samples that can be packed into the same container*)
        Module[{allGroups, uniqueGroups, replaceRules},

          (*Assign unique list based on Options that will affect if something can be in the same plate or not *)
          allGroups = Transpose[{
            resolvedPrecipitationMixTypes[[positionsOfPelletedSamples]],
            resolvedWashMixTypes[[positionsOfPelletedSamples]],
            resolvedResuspensionMixTypes[[positionsOfPelletedSamples]],
            resolvedPrecipitationMixTemperatures[[positionsOfPelletedSamples]],
            resolvedWashMixTemperatures[[positionsOfPelletedSamples]],
            resolvedResuspensionMixTemperatures[[positionsOfPelletedSamples]],
            resolvedNumberOfWashes[[positionsOfPelletedSamples]],
            Lookup[myOptions, TargetPhase][[positionsOfPelletedSamples]]
          }];

          (*Remove all the duplicate groups so we have only the unique ones *)
          uniqueGroups = DeleteDuplicates[allGroups];

          (*Using the unique groups, create a list of reules to replace with newly generated group IDs *)
          replaceRules = # -> CreateUniqueLabel["group"] & /@ uniqueGroups;

          (*Make a list that'll correspond to the samples with a unique group ID, that's what we return *)
          Replace[replaceRules] /@ allGroups
        ],
        {}
      ];

      (* Pack containers of pelleted samples. *)
      {pelletedPackedContainersOut, pelletedPackedContainerOutWells} = PackContainers[
        Join[
          Lookup[myOptions, PrecipitatedSampleContainerOut][[positionsOfPelletedSamples]],
          Lookup[myOptions, UnprecipitatedSampleContainerOut][[positionsOfPelletedSamples]]
        ] /. Null -> Automatic,
        Flatten[{
          resolvedPackPlateQPrecipitatedSamples[[positionsOfPelletedSamples]],
          resolvedPackPlateQUnprecipitatedSamples[[positionsOfPelletedSamples]]
        }],
        Flatten[{
          resolvedTotalVolumes[[positionsOfPelletedSamples]],
          resolvedTotalVolumes[[positionsOfPelletedSamples]]
        }],
        Flatten[{groupsOfPrecipitatedSampleContainers, groupsOfUnprecipitatedSampleContainers}],
        Sterile -> resolvedSterile,
        FirstNewContainerIndex -> userMaxIndex + 1,
        LiquidHandlerCompatible -> True
      ];

      (* Separate results into precipitated and unprecipitated containers and wells. *)
      {
        {
          packedPrecipitatedContainersOutNoWells,
          packedUnprecipitatedContainersOutNoWells
        },
        {
          packedPrecipitatedContainersOutWells,
          packedUnprecipitatedContainersOutWells
        }
      } = {
        Partition[
          pelletedPackedContainersOut,
          Length[positionsOfPelletedSamples]
        ],
        Partition[
          pelletedPackedContainerOutWells,
          Length[positionsOfPelletedSamples]
        ]
      };

      (* Return packed pelleting container information. *)
      Join[
        (* Replace Automatic values with packed containers and wells. *)
        MapThread[
          Function[{paritallyResolvedContainers, packedContainersNoWells, packedContainerWells, packedContainerPositions},
            ReplacePart[
              paritallyResolvedContainers,
              MapThread[
                If[MatchQ[paritallyResolvedContainers[[#1]], Automatic],
                  #1 -> {#2, #3},
                  Nothing
                ]&,
                {packedContainerPositions, packedContainerWells, packedContainersNoWells}
              ]
            ]
          ],
          {
            {partiallyResolvedPrecipitatedContainerOut, partiallyResolvedUnprecipitatedContainerOut},
            {packedPrecipitatedContainersOutNoWells, packedUnprecipitatedContainersOutNoWells},
            {packedPrecipitatedContainersOutWells, packedUnprecipitatedContainersOutWells},
            {positionsOfPelletedSamples, positionsOfPelletedSamples}
          }
        ],
        (* Return resolved, packed container values (wells, indexes, containers) for use when building the full ContainerOut options. *)
        MapThread[
          Function[{paritallyResolvedValue, packedContainerValues, packedContainerPositions},
            ReplacePart[
              paritallyResolvedValue,
              MapThread[
                #1 -> #2&,
                {packedContainerPositions, packedContainerValues}
              ]
            ]
          ],
          {
            {
              partiallyResolvedPrecipitatedContainerOutNoWells, partiallyResolvedUnprecipitatedContainerOutNoWells,
              partiallyResolvedPrecipitatedContainerOutWells, partiallyResolvedPrecipitatedContainerOutIndicies,
              partiallyResolvedUnprecipitatedContainerOutWells, partiallyResolvedUnprecipitatedContainerOutIndicies
            },
            {
              packedPrecipitatedContainersOutNoWells, packedUnprecipitatedContainersOutNoWells,
              packedPrecipitatedContainersOutWells, packedPrecipitatedContainersOutNoWells[[All, 1]],
              packedUnprecipitatedContainersOutWells, packedUnprecipitatedContainersOutNoWells[[All, 1]]
            },
            {
              positionsOfPelletedSamples, positionsOfPelletedSamples,
              positionsOfPelletedSamples, positionsOfPelletedSamples,
              positionsOfPelletedSamples, positionsOfPelletedSamples
            }
          }
        ]
      ]
    ],
    (* If not pelleting, then just return partially resolved container info. *)
    {
      partiallyResolvedPrecipitatedContainerOut,
      partiallyResolvedUnprecipitatedContainerOut,
      partiallyResolvedPrecipitatedContainerOutNoWells,
      partiallyResolvedUnprecipitatedContainerOutNoWells,
      partiallyResolvedPrecipitatedContainerOutWells,
      partiallyResolvedPrecipitatedContainerOutIndicies,
      partiallyResolvedUnprecipitatedContainerOutWells,
      partiallyResolvedUnprecipitatedContainerOutIndicies
    }
  ];

  (*----Resolve ExperimentFilter Options----*)
  (* Grab the positions of all samples to be filtered so we can run them through the FilterOptionResolver *)
  positionsOfFilteredSamples = Flatten[Position[Lookup[myOptions, SeparationTechnique], Filter]];

  (* This returns either resolved Filter Options, filter simulations, and filterTests, or Nothing, Nothing, Nothing*)
  {resolvedFilterOptions, filterTests} = If[Length[positionsOfFilteredSamples] > 0,

    Module[{simulatedFilterPackets, filterOnlySimulation, filterOptions, filterWashContainer},

      (* Pick containers that will serve as the Wash Collection Plate *)
      filterWashContainer = Module[
        {maxWashVolume},
        maxWashVolume = Max[(resolvedWashSolutionVolumes[[positionsOfFilteredSamples]] * (resolvedNumberOfWashes[[positionsOfFilteredSamples]] /. Null -> 0) /. 0 -> 0 Microliter)]; (* Max can't do Nulls and can't do unitless 0 evaluated with a volume so I replaced them*)
        PreferredContainer[maxWashVolume, Sterile -> resolvedSterile, Type -> Plate, LiquidHandlerCompatible -> True]
      ];

      (* this provides a simulated sample that has extra volume to account for PrecipitationReagent. Primarily needed for properly calculating Filter's resolved Options *)
      simulatedFilterPackets = Simulation[Association[{Object -> #[[1]], Volume -> (#[[2]] + #[[3]])}] & /@ Transpose[{mySamples, resolvedPrecipitationReagentVolumes, Lookup[samplePackets, Volume]}]];
      filterOnlySimulation = If[MatchQ[currentSimulation,SimulationP],
        UpdateSimulation[currentSimulation, simulatedFilterPackets],
        simulatedFilterPackets
      ];

      filterOptions = ExperimentFilter[
        Lookup[samplePackets, Object][[positionsOfFilteredSamples]],
        FiltrationType -> resolvedFiltrationTechniques[[positionsOfFilteredSamples]],
        Time -> resolvedFiltrationTimes[[positionsOfFilteredSamples]],
        Intensity -> resolvedFilterCentrifugeIntensities[[positionsOfFilteredSamples]],
        Instrument -> resolvedFiltrationInstruments[[positionsOfFilteredSamples]],
        Sterile -> resolvedSterile,
        Filter -> Lookup[myOptions, Filter][[positionsOfFilteredSamples]],
        FilterPosition -> Lookup[myOptions, FilterPosition][[positionsOfFilteredSamples]],
        Pressure -> resolvedFiltrationPressures[[positionsOfFilteredSamples]],
        MembraneMaterial -> Lookup[myOptions, MembraneMaterial][[positionsOfFilteredSamples]],
       (* PrefilterMembraneMaterial -> Lookup[myOptions, PrefilterMembraneMaterial][[positionsOfFilteredSamples]], *)
        PoreSize -> Lookup[myOptions, PoreSize][[positionsOfFilteredSamples]],
        (*PrefilterPoreSize -> Lookup[myOptions, PrefilterPoreSize][[positionsOfFilteredSamples]], *)
        ResuspensionBuffer -> (resolvedResuspensionBuffers /. None -> Null)[[positionsOfFilteredSamples]],
        ResuspensionVolume -> resolvedResuspensionBufferVolumes[[positionsOfFilteredSamples]],
        NumberOfResuspensionMixes -> resolvedNumberOfResuspensionMixes[[positionsOfFilteredSamples]],
        RetentateWashBuffer -> resolvedWashSolutions[[positionsOfFilteredSamples]],
        RetentateWashVolume -> resolvedWashSolutionVolumes[[positionsOfFilteredSamples]],
        NumberOfRetentateWashes -> (resolvedNumberOfWashes /. 0 -> Null)[[positionsOfFilteredSamples]], (* Filter throws an error if 0 is given as an input *)
        RetentateWashDrainTime -> resolvedWashSeparationTimes[[positionsOfFilteredSamples]],
        RetentateWashCentrifugeIntensity -> resolvedWashCentrifugeIntensities[[positionsOfFilteredSamples]],
        RetentateWashPressure -> resolvedWashPressures[[positionsOfFilteredSamples]],
        RetentateContainerOut -> (pelletResolvedPrecipitatedContainerOutNoWells /. Null -> Automatic)[[positionsOfFilteredSamples]], (* Null is okay for Precipitate ContainersOut but not for Filter *)
        FiltrateContainerOut -> (pelletResolvedUnprecipitatedContainerOutNoWells /. Null -> Automatic)[[positionsOfFilteredSamples]], (* Null is okay for Precipitate ContainersOut but not for Filter *)
        RetentateDestinationWell -> (pelletResolvedPrecipitatedContainerOutWells /. Null -> Automatic)[[positionsOfFilteredSamples]], (* Null is okay for Precipitate ContainersOut but not for Filter *)
        FiltrateDestinationWell -> (pelletResolvedUnprecipitatedContainerOutWells /. Null -> Automatic)[[positionsOfFilteredSamples]], (* Null is okay for Precipitate ContainersOut but not for Filter *)
        Target -> (Lookup[myOptions, TargetPhase] /. {Solid -> Retentate, Liquid -> Filtrate})[[positionsOfFilteredSamples]], (* Filter's Target needs to be changed from Solid/Liquid to Retentate/Filtrate respectively *)
        RetentateCollectionMethod -> (resolvedResuspensionBuffers /. {ObjectP[] -> Resuspend, None -> Null})[[positionsOfFilteredSamples]], (* Filter requires these inputs, not a number *)
        CollectRetentate -> (resolvedResuspensionBuffers /. {ObjectP[] -> True, None -> False, Null -> False})[[positionsOfFilteredSamples]],
        Volume -> (calculatedSampleVolumes + resolvedPrecipitationReagentVolumes)[[positionsOfFilteredSamples]],
        WashRetentate -> (resolvedNumberOfWashes[[positionsOfFilteredSamples]] /. {GreaterP[0] -> True, (EqualP[0] | Null) -> False}), (* Filter requires these inputs, not a number *)
        WashFlowThroughContainer -> filterWashContainer, (* TODO, this may be an issue if we ever have non-96 well filters... *)
        WorkCell -> resolvedWorkCell,
        Preparation -> Robotic,
        OptionsResolverOnly -> True,
        Simulation -> filterOnlySimulation,
        Output -> If[gatherTests,
          {Options, Tests},
          {Options}
        ]
      ];

      (*Now return either the options, or the Options and tests*)
      If[gatherTests,
        {filterOptions[[1]], filterOptions[[2]]},
        {filterOptions, {}}
      ]
    ],
    {{}, {}}
  ];

  (* If any of the samples were filed, insert the resolved filter options into the correct resolved option indicies *)
  {
    resolvedFilters,
    resolvedPrefilterPoreSizes,
    resolvedPrefilterMembraneMaterials,
    resolvedPoreSizes,
    resolvedMembraneMaterials,
    resolvedFilterPositions,
    resolvedPrecipitatedContainerOutWells,
    resolvedUnprecipitatedContainerOutWells
  } = If[Length[positionsOfFilteredSamples] > 0,
    MapThread[
      Function[{pelletResolvedList, filterOptionName},
        (* Need to flatten differently if there is only one sample *)
        ReplacePart[
          pelletResolvedList,
          MapThread[
            #1 -> #2&,
            {
              positionsOfFilteredSamples,
              If[Length[positionsOfFilteredSamples] > 1,
                Flatten[Lookup[resolvedFilterOptions, filterOptionName], 1],
                Flatten[Lookup[resolvedFilterOptions, filterOptionName]]
              ]
            }
          ]
        ]
      ],
      {
        {
          partiallyResolvedFilters, partiallyResolvedPrefilterPoreSizes,
          partiallyResolvedPrefilterMembraneMaterials, partiallyResolvedPoreSizes,
          partiallyResolvedMembraneMaterials, partiallyResolvedFilterPositions,
          pelletResolvedPrecipitatedContainerOutWells, pelletResolvedUnprecipitatedContainerOutWells
        },
        {
          Filter, PrefilterPoreSize,
          PrefilterMembraneMaterial, PoreSize,
          MembraneMaterial, FilterPosition,
          RetentateDestinationWell, FiltrateDestinationWell
        }
      }
    ],
    (* If nothing is filtered, then just return partially resolved values (which should all be Null or equivalent). *)
    {
      partiallyResolvedFilters,
      partiallyResolvedPrefilterPoreSizes,
      partiallyResolvedPrefilterMembraneMaterials,
      partiallyResolvedPoreSizes,
      partiallyResolvedMembraneMaterials,
      partiallyResolvedFilterPositions,
      pelletResolvedPrecipitatedContainerOutWells,
      pelletResolvedUnprecipitatedContainerOutWells
    }
  ];

  {
    filterResolvedPrecipitatedContainerOutNoWells,
    filterResolvedUnprecipitatedContainerOutNoWells
  } = If[Length[positionsOfFilteredSamples] > 0,
    MapThread[
      Function[{pelletResolvedList, filterOptionName},
        (* Need to flatten differently if there is only one sample *)
        ReplacePart[
          pelletResolvedList,
          MapThread[
            #1 -> #2&,
            {
              positionsOfFilteredSamples,
              Flatten[Lookup[resolvedFilterOptions, filterOptionName], 1]
            }
          ]
        ]
      ],
      {
        {pelletResolvedPrecipitatedContainerOutNoWells, pelletResolvedUnprecipitatedContainerOutNoWells},
        {RetentateContainerOut, FiltrateContainerOut}
      }
    ],
    {pelletResolvedPrecipitatedContainerOutNoWells, pelletResolvedUnprecipitatedContainerOutNoWells}
  ];

  (* Calculate the maximum indicies used so far to ensure the assigned indicies do not conflict *)
  userAndPelletMaxIndex = Max[Select[Flatten[{resolvedPrecipitatedContainerOutIndicies, resolvedUnprecipitatedContainerOutIndicies, 0}], IntegerQ]];

  {
    {
      resolvedPrecipitatedContainerOutNoWells,
      resolvedPrecipitatedContainerOut
    },
    {
      resolvedUnprecipitatedContainerOutNoWells,
      resolvedUnprecipitatedContainerOut
    }
  } = MapThread[
    Function[
      {
        containerOutField, partiallyResolvedContainersOutNoWells, resolvedContainerOutWells,
        partiallyResolvedContainersOut
      },
      Module[
        {
          positionsOfFilteredAutomaticSamples, resolvedAutomaticContainersOutNoWells, resolvedAutomaticContainersOut
        },

        positionsOfFilteredAutomaticSamples = Flatten[
          Position[
            Transpose[{
              Lookup[myOptions, SeparationTechnique],
              Lookup[myOptions, containerOutField]
            }],
            {Filter, Automatic}
          ]
        ];

        (* Increase the Index for all filtered samples based on the userAndPelletMaxIndex set based on
        resolvedPrecipitated/UnprecipitatedContainerOutIndicies which currently does not reflect samples from the Filter resolver *)
        resolvedAutomaticContainersOutNoWells = If[Length[positionsOfFilteredAutomaticSamples] > 0,
          Map[
            If[
              MatchQ[#, Null | {Null, Null}], (*This is to handle the formatting issues of the container being Null *)
              Null,
              {#[[1]] + userAndPelletMaxIndex, #[[2]]}
            ]&,
            partiallyResolvedContainersOutNoWells[[positionsOfFilteredAutomaticSamples]]
          ],
          Null
        ];

        (* This chunk of code combines assigned wells and NoWell variables into a proper ContainerOut format *)
        (* Don't bother assembling the ContainerOut if none were set to Automatic *)
        resolvedAutomaticContainersOut = If[Length[positionsOfFilteredAutomaticSamples] > 0,
          MapThread[
            Function[{containerWells, noWellContainers},
              If[
                MatchQ[noWellContainers, Null], (*This is to handle the formatting issues of the container being Null *)
                Null,
                {containerWells, noWellContainers}
              ]
            ],
            {
              resolvedContainerOutWells[[positionsOfFilteredAutomaticSamples]],
              resolvedAutomaticContainersOutNoWells
            }
          ],
          Null
        ];

        If[Length[positionsOfFilteredAutomaticSamples] > 0,
          MapThread[
            Function[{partiallyResolvedValues, resolvedAutomaticValues},
              ReplacePart[
                partiallyResolvedValues,
                MapThread[#1 -> #2&, {positionsOfFilteredAutomaticSamples, resolvedAutomaticValues}]
              ]
            ],
            {
              {partiallyResolvedContainersOutNoWells, partiallyResolvedContainersOut},
              {resolvedAutomaticContainersOutNoWells, resolvedAutomaticContainersOut}
            }
          ],
          {partiallyResolvedContainersOutNoWells, partiallyResolvedContainersOut}
        ]
      ]
    ],
    {
      {PrecipitatedSampleContainerOut, UnprecipitatedSampleContainerOut},
      {
        filterResolvedPrecipitatedContainerOutNoWells,
        filterResolvedUnprecipitatedContainerOutNoWells
      },
      {
        resolvedPrecipitatedContainerOutWells,
        resolvedUnprecipitatedContainerOutWells
      },
      {
        pelletResolvedPrecipitatedContainerOut,
        pelletResolvedUnprecipitatedContainerOut
      }
    }
  ];

  maxIndex = Max[Select[Flatten[{resolvedPrecipitatedContainerOutIndicies, resolvedUnprecipitatedContainerOutIndicies, 0}], IntegerQ]];

  (* The containers are now fully resolved, but some may not have the proper format so we'll need to set them for the hidden container options that will be passed down from the resolver *)
  (* resolve FullPrecipitatedContainerOut *)
  resolvedFullPrecipitatedContainerOut = MapThread[
    Function[{containerWells, noWellContainers},
      (* If the user specified a Well and a Container, then it isn't actually going to resolve fully above, and we need to add the Index here *)
      If[MatchQ[noWellContainers, ObjectP[Model[Container]]],
        {containerWells, {(ToExpression[CreateUniqueLabel[""]] + maxIndex), noWellContainers}},
        {containerWells, noWellContainers}
      ]
    ],
    {
      resolvedPrecipitatedContainerOutWells,
      resolvedPrecipitatedContainerOutNoWells
    }
  ];

  resolvedFullUnprecipitatedContainerOut = MapThread[
    Function[{containerWells, noWellContainers},
      (* If the user specified a Well and a Container, then it isn't actually going to resolve fully above, and we need to add the Index here *)
      If[MatchQ[noWellContainers, ObjectP[Model[Container]]],
        {containerWells, {(ToExpression[CreateUniqueLabel[""]] + maxIndex), noWellContainers}},
        {containerWells, noWellContainers}
      ]
    ],
    {
      resolvedUnprecipitatedContainerOutWells,
      resolvedUnprecipitatedContainerOutNoWells
    }
  ];

  (* Resolve Post Processing Options *)
  resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];

  (* get the resolved Email option; for this experiment, the default is True if it's a parent protocol, and False if it's a sub *)
  email = Which[
    MatchQ[Lookup[myOptions, Email], Automatic] && NullQ[Lookup[myOptions, ParentProtocol]], True,
      MatchQ[Lookup[myOptions, Email], Automatic] && MatchQ[Lookup[myOptions, ParentProtocol], ObjectP[ProtocolTypes[]]], False,
    True,
      Lookup[myOptions, Email]
  ];

  (****************START Check for conflicting Options*****************)

  (* SeparationTechnique / FiltrationInstrument / FiltrationTechnique / Filter / FilterPosition / FiltrationTime / PelletVolume / PelletCentrifuge /
  PelletCentrifugeIntensity / PelletCentrifugeTime / SupernatantVolume / SupernatantContainer / SupernatantStorageCondition conflicting options. *)
  separationTechniqueConflictingOptions = MapThread[
    Function[
      {
        sample, separationTechnique, filtrationInstrument, filtrationTechnique, filter, filterPosition,
        filtrationTime, pelletVolume, pelletCentrifuge, pelletCentrifugeIntensity, pelletCentrifugeTime,
        supernatantVolume, index
      },
      If[
        Or[
          And[
            MatchQ[separationTechnique, Filter],
            Or[
              MatchQ[filtrationInstrument, Null],
              MatchQ[filtrationTechnique, Null],
              MatchQ[filter, Null],
              MatchQ[filterPosition, Null],
              !MatchQ[filtrationTime, GreaterP[0 Minute]],
              !MatchQ[pelletVolume, Null],
              !MatchQ[pelletCentrifuge, Null],
              !MatchQ[pelletCentrifugeIntensity, Null],
              !MatchQ[pelletCentrifugeTime, Null],
              MatchQ[supernatantVolume, GreaterP[0 Milliliter]]
            ]
          ],
          And[
            MatchQ[separationTechnique, Pellet],
            Or[
              !MatchQ[filtrationInstrument, Null],
              !MatchQ[filtrationTechnique, Null],
              !MatchQ[filter, Null],
              !MatchQ[filterPosition, Null],
              MatchQ[filtrationTime, GreaterP[0 Minute]],
              MatchQ[pelletVolume, Null],
              MatchQ[pelletCentrifuge, Null],
              MatchQ[pelletCentrifugeIntensity, Null],
              MatchQ[pelletCentrifugeTime, Null],
              !MatchQ[supernatantVolume, GreaterP[0 Milliliter]]
            ]
          ]
        ],
        {
          sample, separationTechnique, filtrationInstrument, filtrationTechnique, filter, filterPosition,
          filtrationTime, pelletVolume, pelletCentrifuge, pelletCentrifugeIntensity, pelletCentrifugeTime,
          supernatantVolume, index
        },
        Nothing
      ]
    ],
    {
      mySamples, Lookup[myOptions, SeparationTechnique], resolvedFiltrationInstruments, resolvedFiltrationTechniques, resolvedFilters, resolvedFilterPositions,
      resolvedFiltrationTimes, resolvedPelletVolumes, resolvedPelletCentrifuges, resolvedPelletCentrifugeIntensities, resolvedPelletCentrifugeTimes,
      resolvedSupernatantVolumes, Range[Length[mySamples]]
    }
  ];
  (*Throws the error if tests are not being gathered*)
  If[Length[separationTechniqueConflictingOptions] > 0 && messages,
    Message[
      Error::SeparationTechniqueConflictingOptions,
      ObjectToString[separationTechniqueConflictingOptions[[All, 1]], Cache -> cacheBall],
      separationTechniqueConflictingOptions[[All, 2]],
      ObjectToString[separationTechniqueConflictingOptions[[All, 3]], Cache -> cacheBall],
      separationTechniqueConflictingOptions[[All, 4]],
      ObjectToString[separationTechniqueConflictingOptions[[All, 5]], Cache -> cacheBall],
      separationTechniqueConflictingOptions[[All, 6]],
      separationTechniqueConflictingOptions[[All, 7]],
      separationTechniqueConflictingOptions[[All, 8]],
      separationTechniqueConflictingOptions[[All, 9]],
      separationTechniqueConflictingOptions[[All, 10]],
      separationTechniqueConflictingOptions[[All, 11]],
      separationTechniqueConflictingOptions[[All, 12]],
      separationTechniqueConflictingOptions[[All, 13]]
    ];
  ];
  (* Package the fails/passes if tests are being gathered *)
  separationTechniqueConflictingOptionsTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = separationTechniqueConflictingOptions[[All, 1]];
      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " do not have conflicting SeparationTechnique options:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " do not have conflicting SeparationTechnique options:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* PrecipitationInstrument / PrecipitationTemperature conflicting options.*)
  precipitationInstrumentConflictingOptions = MapThread[
    Function[{sample, precipitationInstrument, precipitationTemperature, index},
      If[
        Or[
          And[
            !MatchQ[precipitationInstrument, Null],
            MatchQ[precipitationTemperature, Null]
          ],
          And[
            MatchQ[precipitationInstrument, Null],
            !MatchQ[precipitationTemperature, Null]
          ]
        ],
        {sample, precipitationInstrument, precipitationTemperature, index},
        Nothing
      ]
    ],
    {mySamples, resolvedPrecipitationInstruments, resolvedPrecipitationTemperatures, Range[Length[mySamples]]}
  ];
  (*Throws the error if tests are not being gathered*)
  If[Length[precipitationInstrumentConflictingOptions] > 0 && messages,
    Message[
      Error::PrecipitationInstrumentConflictingOptions,
      ObjectToString[precipitationInstrumentConflictingOptions[[All, 1]], Cache -> cacheBall],
      ObjectToString[precipitationInstrumentConflictingOptions[[All, 2]], Cache -> cacheBall],
      precipitationInstrumentConflictingOptions[[All, 3]],
      precipitationInstrumentConflictingOptions[[All, 4]]
    ];
  ];
  (* Package the fails/passes if tests are being gathered *)
  precipitationInstrumentConflictingOptionsTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = precipitationInstrumentConflictingOptions[[All, 1]];
      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " do not have conflicting PrecipitationInstrument/PrecipitationTemperature options:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " do not have conflicting PrecipitationInstrument/PrecipitationTemperature options:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];


  (* WashSolution / WashSolutionVolume / WashSolutionTemperature / WashSolutionEquilibrationTime / WashMixType / WashMixInstrument / WashMixRate / WashMixTemperature / WashMixTime / NumberOfWashMixes / WashMixVolume /
  WashPrecipitationTime / WashPrecipitationInstrument / WashPrecipitationTemperature / WashCentrifugeIntensity / WashPressure / WashSeparationTime / conflicting options. *)
  notWashingConflictingOptions = MapThread[
    Function[{sample, numberOfWashes, washSolution, washSolutionVolume, washSolutionTemperature, washSolutionEquilibrationTime, washMixType, washMixInstrument, washMixRate, washMixTemperature, washMixTime, numberOfWashMixes,
      washMixVolume, washPrecipitationTime, washPrecipitationInstrument, washPrecipitationTemperature, washCentrifugeIntensity, washPressure, washSeparationTime, index},
      If[
        And[
          !MatchQ[numberOfWashes, GreaterP[0]],
          Or[
            !MatchQ[washSolution, Null],
            MatchQ[washSolutionVolume, GreaterP[0 Milliliter]],
            !MatchQ[washSolutionTemperature, Null],
            MatchQ[washSolutionEquilibrationTime, GreaterP[0 Minute]],
            !MatchQ[washMixType, (None | Null)],
            !MatchQ[washMixInstrument, Null],
            !MatchQ[washMixRate, Null],
            !MatchQ[washMixTemperature, Null],
            MatchQ[washMixTime, GreaterP[0 Minute]],
            MatchQ[numberOfWashMixes, GreaterP[0]],
            MatchQ[washMixVolume, GreaterP[0 Milliliter]],
            MatchQ[washPrecipitationTime, GreaterP[0 Minute]],
            !MatchQ[washPrecipitationInstrument, Null],
            !MatchQ[washPrecipitationTemperature, Null],
            MatchQ[washCentrifugeIntensity, GreaterP[0 RPM]],
            !MatchQ[washPressure, Null],
            MatchQ[washSeparationTime, GreaterP[0 Minute]]
          ]
        ],
        {sample, numberOfWashes, washSolution, washSolutionVolume, washSolutionTemperature, washSolutionEquilibrationTime, washMixType, washMixInstrument, washMixRate, washMixTemperature, washMixTime, numberOfWashMixes,
          washMixVolume, washPrecipitationTime, washPrecipitationInstrument, washPrecipitationTemperature, washCentrifugeIntensity, washPressure, washSeparationTime, index},
        Nothing
      ]
    ],
    {mySamples, resolvedNumberOfWashes, resolvedWashSolutions, resolvedWashSolutionVolumes, resolvedWashSolutionTemperatures, resolvedWashSolutionEquilibrationTimes, resolvedWashMixTypes, resolvedWashMixInstruments, resolvedWashMixRates,
      resolvedWashMixTemperatures, resolvedWashMixTimes, resolvedNumberOfWashMixes, resolvedWashMixVolumes, resolvedWashPrecipitationTimes, resolvedWashPrecipitationInstruments, resolvedWashPrecipitationTemperatures, resolvedWashCentrifugeIntensities,
      resolvedWashPressures, resolvedWashSeparationTimes, Range[Length[mySamples]]}
  ];
  (*Throws the error if tests are not being gathered*)
  If[Length[notWashingConflictingOptions] > 0 && messages,
    Message[
      Error::NotWashingConflictingOptions,
      ObjectToString[notWashingConflictingOptions[[All, 1]], Cache -> cacheBall],
      notWashingConflictingOptions[[All, 2]],
      ObjectToString[notWashingConflictingOptions[[All, 3]], Cache -> cacheBall],
      notWashingConflictingOptions[[All, 4]],
      notWashingConflictingOptions[[All, 5]],
      notWashingConflictingOptions[[All, 6]],
      notWashingConflictingOptions[[All, 7]],
      ObjectToString[notWashingConflictingOptions[[All, 8]], Cache -> cacheBall],
      notWashingConflictingOptions[[All, 9]],
      notWashingConflictingOptions[[All, 10]],
      notWashingConflictingOptions[[All, 11]],
      notWashingConflictingOptions[[All, 12]],
      notWashingConflictingOptions[[All, 13]],
      notWashingConflictingOptions[[All, 14]],
      ObjectToString[notWashingConflictingOptions[[All, 15]], Cache -> cacheBall],
      notWashingConflictingOptions[[All, 16]],
      notWashingConflictingOptions[[All, 17]],
      notWashingConflictingOptions[[All, 18]],
      notWashingConflictingOptions[[All, 19]],
      notWashingConflictingOptions[[All, 20]]
    ];
  ];
  (* Package the fails/passes if tests are being gathered *)
  notWashingConflictingOptionsTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = notWashingConflictingOptions[[All, 1]];
      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " do not have conflicting options when Washing is not intended:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " do not have conflicting options when Washing is not intended:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* DryingTime / DryingTemperature conflicting options. *)
  dryingSolidConflictingOptions = MapThread[
    Function[{sample, dryingTime, dryingTemperature, index},
      If[
        Or[
          And[
            MatchQ[dryingTime, GreaterP[0 Minute]],
            MatchQ[dryingTemperature, Null]
          ],
          And[
            !MatchQ[dryingTime, GreaterP[0 Minute]],
            !MatchQ[dryingTemperature, Null]
          ]
        ],
        {sample, dryingTime, dryingTemperature, index},
        Nothing
      ]
    ],
    {mySamples, resolvedDryingTimes, resolvedDryingTemperatures, Range[Length[mySamples]]}
  ];
  (*Throws the error if tests are dryingSolidConflictingOptionsnot being gathered*)
  If[Length[dryingSolidConflictingOptions] > 0 && messages,
    Message[
      Error::DryingSolidConflictingOptions,
      ObjectToString[dryingSolidConflictingOptions[[All, 1]], Cache -> cacheBall],
      dryingSolidConflictingOptions[[All, 2]],
      dryingSolidConflictingOptions[[All, 3]],
      dryingSolidConflictingOptions[[All, 4]]
    ];
  ];
  (* Package the fails/passes if tests are being gathered *)
  dryingSolidConflictingOptionsTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = dryingSolidConflictingOptions[[All, 1]];
      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " do not have conflicting Drying options:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " do not have conflicting Drying options:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* ResuspensionBuffer / ResuspensionBufferVolume conflicting options. *)
  resuspensionBufferConflictingOptions = MapThread[
    Function[{sample, resuspensionBuffer, resuspensionBufferVolume, index},
      If[
        Or[
          And[
            MatchQ[resuspensionBuffer, (Null | None)],
            MatchQ[resuspensionBufferVolume, GreaterP[0 Milliliter]]
          ],
          And[
            !MatchQ[resuspensionBuffer, (Null | None)],
            !MatchQ[resuspensionBufferVolume, GreaterP[0 Milliliter]]
          ]
        ],
        {sample, resuspensionBuffer, resuspensionBufferVolume, index},
        Nothing
      ]
    ],
    {mySamples, resolvedResuspensionBuffers, resolvedResuspensionBufferVolumes, Range[Length[mySamples]]}
  ];
  (*Throws the error if tests are not being gathered*)
  If[Length[resuspensionBufferConflictingOptions] > 0 && messages,
    Message[
      Error::ResuspensionBufferConflictingOptions,
      ObjectToString[resuspensionBufferConflictingOptions[[All, 1]], Cache -> cacheBall],
      ObjectToString[resuspensionBufferConflictingOptions[[All, 2]], Cache -> cacheBall],
      resuspensionBufferConflictingOptions[[All, 3]],
      resuspensionBufferConflictingOptions[[All, 4]]
    ];
  ];
  (* Package the fails/passes if tests are being gathered *)
  resuspensionBufferConflictingOptionsTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = resuspensionBufferConflictingOptions[[All, 1]];
      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " do not have conflicting ResuspensionBuffer options:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " do not have conflicting ResuspensionBuffer options:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* PrecipitationReagentTemperature not specified when needed, conflicting options. *)
  preIncubationTemperatureNotSpecified = MapThread[
    Function[{sample, precipitationReagentTemperature, precipitationReagentEquilibrationTime, washSolutionTemperature, washSolutionEquilibrationTime, resuspensionBufferTemperature,
      resuspensionBufferEquilibrationTime, index},
      If[
        Or[
          And[
            MatchQ[precipitationReagentTemperature, Null],
            MatchQ[precipitationReagentEquilibrationTime, GreaterP[0 Minute]]
          ],
          And[
            MatchQ[washSolutionTemperature, Null],
            MatchQ[washSolutionEquilibrationTime, GreaterP[0 Minute]]
          ],
          And[
            MatchQ[resuspensionBufferTemperature, Null],
            MatchQ[resuspensionBufferEquilibrationTime, GreaterP[0 Minute]]
          ]
        ],
        {sample, precipitationReagentTemperature, precipitationReagentEquilibrationTime, washSolutionTemperature, washSolutionEquilibrationTime, resuspensionBufferTemperature, resuspensionBufferEquilibrationTime, index},
        Nothing
      ]
    ],
    {mySamples, Lookup[myOptions, PrecipitationTemperature], Lookup[myOptions, PrecipitationTime], resolvedWashSolutionTemperatures, resolvedWashSolutionEquilibrationTimes,
      resolvedResuspensionBufferTemperatures, resolvedResuspensionBufferEquilibrationTimes, Range[Length[mySamples]]}
  ];
  (*Throws the error if tests are not being gathered*)
  If[Length[preIncubationTemperatureNotSpecified] > 0 && messages,
    Message[
      Error::PreIncubationTemperatureNotSpecified,
      ObjectToString[preIncubationTemperatureNotSpecified[[All, 1]], Cache -> cacheBall],
      preIncubationTemperatureNotSpecified[[All, 2]],
      preIncubationTemperatureNotSpecified[[All, 3]],
      preIncubationTemperatureNotSpecified[[All, 4]],
      preIncubationTemperatureNotSpecified[[All, 5]],
      preIncubationTemperatureNotSpecified[[All, 6]],
      preIncubationTemperatureNotSpecified[[All, 7]],
      preIncubationTemperatureNotSpecified[[All, 8]]
    ];
  ];
  (* Package the fails/passes if tests are being gathered *)
  preIncubationTemperatureNotSpecifiedTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = preIncubationTemperatureNotSpecified[[All, 1]];
      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " do not have conflicting PrecipitationReagentTemperature/PrecipitationReagentEquilibrationTime or WashSolutionTemperature/WashSolutionEquilibrationTime or ResuspensionBufferTemperature/ResuspensionBufferEquilibrationTime options:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " do not have conflicting PrecipitationReagentTemperature/PrecipitationReagentEquilibrationTime or WashSolutionTemperature/WashSolutionEquilibrationTime or ResuspensionBufferTemperature/ResuspensionBufferEquilibrationTime options:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* PrecipitationBufferMixType, PrecipitationMixVolume, PrecipitationMixInstrument, NumberOfPrecipitationMixes, PrecipitationBufferTemperature, PrecipitationMixTime conflicting options. *)
  precipitationMixTypeConflictingOptions = MapThread[
    Function[{sample, precipitationBufferMixType, precipitationMixVolume, precipitationMixInstrument, numberOfprecipitationMixes, precipitationBufferTemperature, precipitationMixTime, index},
      If[
        Or[
          And[
            MatchQ[precipitationBufferMixType, Shake],
            Or[
              !MatchQ[precipitationMixVolume, (Null | EqualP[0 Microliter])],
              !MatchQ[numberOfprecipitationMixes, (Null | EqualP[0])],
              MatchQ[precipitationMixInstrument, Null],
              MatchQ[precipitationBufferTemperature, Null],
              !MatchQ[precipitationMixTime, GreaterP[0 Minute]]
            ]
          ],
          And[
            MatchQ[precipitationBufferMixType, Pipette],
            Or[
              MatchQ[precipitationMixVolume, (Null | EqualP[0 Microliter])],
              MatchQ[numberOfprecipitationMixes, (Null | EqualP[0])],
              !MatchQ[precipitationMixInstrument, Null],
              !MatchQ[precipitationBufferTemperature, (Null | $AmbientTemperature | Ambient)],
              MatchQ[precipitationMixTime, GreaterP[0 Minute]]
            ]
          ],
          And[
            MatchQ[precipitationBufferMixType, (Null | None)],
            Or[
              !MatchQ[precipitationMixVolume, (Null | EqualP[0 Microliter])],
              !MatchQ[numberOfprecipitationMixes, (Null | EqualP[0])],
              !MatchQ[precipitationMixInstrument, Null],
              !MatchQ[precipitationBufferTemperature, (Null | $AmbientTemperature | Ambient)],
              MatchQ[precipitationMixTime, GreaterP[0 Minute]]
            ]
          ]
        ],
        {sample, precipitationBufferMixType, precipitationMixVolume, precipitationMixInstrument, numberOfprecipitationMixes, precipitationBufferTemperature, precipitationMixTime, index},
        Nothing
      ]
      (* After all the tests are gathered, check them to see if any occured, and if so, return a partitioned list so each can be thrown downstream, otherwise just return Nothing *)
      (* But only do Parition if there's more than one Test failed, otherwise it returns a weird format *)
    ],
    {mySamples, resolvedPrecipitationMixTypes, resolvedPrecipitationMixVolumes, resolvedPrecipitationMixInstruments, resolvedNumberOfPrecipitationMixes, resolvedPrecipitationMixTemperatures, resolvedPrecipitationMixTimes, Range[Length[mySamples]]}
  ];
  (*Throws the error if tests are not being gathered*)
  If[Length[precipitationMixTypeConflictingOptions] > 0 && messages,
    Message[
      Error::PrecipitationMixTypeConflictingOptions,
      ObjectToString[precipitationMixTypeConflictingOptions[[All, 1]], Cache -> cacheBall],
      precipitationMixTypeConflictingOptions[[All, 2]],
      precipitationMixTypeConflictingOptions[[All, 3]],
      ObjectToString[precipitationMixTypeConflictingOptions[[All, 4]], Cache -> cacheBall],
      precipitationMixTypeConflictingOptions[[All, 5]],
      precipitationMixTypeConflictingOptions[[All, 6]],
      precipitationMixTypeConflictingOptions[[All, 7]],
      precipitationMixTypeConflictingOptions[[All, 8]]
    ];
  ];
  (* Package the fails/passes if tests are being gathered *)
  precipitationMixTypeConflictingOptionsTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = precipitationMixTypeConflictingOptions[[All, 1]];
      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " do not have conflicting PrecipitationMixing options:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " do not have conflicting PrecipitationMixing options:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* WashBufferMixType, WashMixVolume, WashMixInstrument, NumberOfWashMixes, WashTemperature, WashMixTime conflicting options. *)
  washTypeConflictingOptions = MapThread[
    Function[{sample, washMixType, washMixVolume, numberOfWashMixes, washMixInstrument, washMixTemperature, washMixTime, index},
      If[
        Or[
          And[
            MatchQ[washMixType, Shake],
            Or[
              !MatchQ[washMixVolume, (Null | EqualP[0 Microliter])],
              !MatchQ[numberOfWashMixes, (Null | EqualP[0])],
              MatchQ[washMixInstrument, Null],
              MatchQ[washMixTemperature, Null],
              !MatchQ[washMixTime, GreaterP[0 Minute]]
            ]
          ],
          And[
            MatchQ[washMixType, Pipette],
            Or[
              MatchQ[washMixVolume, (Null | EqualP[0 Microliter])],
              MatchQ[numberOfWashMixes, (Null | EqualP[0])],
              !MatchQ[washMixInstrument, Null],
              !MatchQ[washMixTemperature, (Null | $AmbientTemperature | Ambient)],
              MatchQ[washMixTime, GreaterP[0 Minute]]
            ]
          ],
          And[
            MatchQ[washMixType, (Null | None)],
            Or[
              !MatchQ[washMixVolume, (Null | EqualP[0 Microliter])],
              !MatchQ[numberOfWashMixes, (Null | EqualP[0])],
              !MatchQ[washMixInstrument, Null],
              !MatchQ[washMixTemperature, (Null | $AmbientTemperature | Ambient)],
              MatchQ[washMixTime, GreaterP[0 Minute]]
            ]
          ]
        ],
        {sample, washMixType, washMixVolume, numberOfWashMixes, washMixInstrument, washMixTemperature, washMixTime, index},
        Nothing
      ]
      (* After all the tests are gathered, check them to see if any occured, and if so, return a partitioned list so each can be thrown downstream, otherwise just return Nothing *)
      (* But only do Parition if there's more than one Test failed, otherwise it returns a weird format *)
    ],
    {mySamples, resolvedWashMixTypes, resolvedWashMixVolumes, resolvedNumberOfWashMixes, resolvedWashMixInstruments, resolvedWashMixTemperatures, resolvedWashMixTimes, Range[Length[mySamples]]}
  ];
  (*Throws the error if tests are not being gathered*)
  If[Length[washTypeConflictingOptions] > 0 && messages,
    Message[
      Error::WashMixTypeConflictingOptions,
      ObjectToString[washTypeConflictingOptions[[All, 1]], Cache -> cacheBall],
      washTypeConflictingOptions[[All, 2]],
      washTypeConflictingOptions[[All, 3]],
      ObjectToString[washTypeConflictingOptions[[All, 4]], Cache -> cacheBall],
      washTypeConflictingOptions[[All, 5]],
      washTypeConflictingOptions[[All, 6]],
      washTypeConflictingOptions[[All, 7]],
      washTypeConflictingOptions[[All, 8]]
    ];
  ];
  (* Package the fails/passes if tests are being gathered *)
  washTypeConflictingOptionsTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = washTypeConflictingOptions[[All, 1]];
      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " do not have conflicting WashMixing options:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " do not have conflicting WashMixing options:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* ResuspensionBufferMixType, ResuspensionMixVolume, ResuspensionMixInstrument, NumberOfResuspensionMixes, ResuspensionBufferTemperature, ResuspensionMixTime conflicting options. *)
  resuspensionTypeConflictingOptions = MapThread[
    Function[{sample, resuspensionMixType, resuspensionMixVolume, numberOfresuspensionMixes, resuspensionMixInstrument, resuspensionMixTemperature, resuspensionMixTime, index},

      If[
        Or[
          And[
            MatchQ[resuspensionMixType, Shake],
            Or[
              !MatchQ[resuspensionMixVolume, (Null | EqualP[0 Microliter])],
              !MatchQ[numberOfresuspensionMixes, (Null | EqualP[0])],
              MatchQ[resuspensionMixInstrument, Null],
              MatchQ[resuspensionMixTemperature, Null],
              !MatchQ[resuspensionMixTime, GreaterP[0 Minute]]
            ]
          ],
          And[
            MatchQ[resuspensionMixType, Pipette],
            Or[
              MatchQ[resuspensionMixVolume, (Null | EqualP[0 Microliter])],
              MatchQ[numberOfresuspensionMixes, (Null | EqualP[0])],
              !MatchQ[resuspensionMixInstrument, Null],
              !MatchQ[resuspensionMixTemperature, (Null | $AmbientTemperature | Ambient)],
              MatchQ[resuspensionMixTime, GreaterP[0 Minute]]
            ]
          ],
          And[
            MatchQ[resuspensionMixType, (Null | None)],
            Or[
              !MatchQ[resuspensionMixVolume, (Null | EqualP[0 Microliter])],
              !MatchQ[numberOfresuspensionMixes, (Null | EqualP[0])],
              !MatchQ[resuspensionMixInstrument, Null],
              !MatchQ[resuspensionMixTemperature, (Null | $AmbientTemperature | Ambient)],
              MatchQ[resuspensionMixTime, GreaterP[0 Minute]]
            ]
          ]
        ],
        {sample, resuspensionMixType, resuspensionMixVolume, numberOfresuspensionMixes, resuspensionMixInstrument, resuspensionMixTemperature, resuspensionMixTime, index},
        Nothing
      ]
      (* After all the tests are gathered, check them to see if any occurred, and if so, return a partitioned list so each can be thrown downstream, otherwise just return Nothing *)
      (* But only do Parition if there's more than one Test failed, otherwise it returns a weird format *)
    ],
    {mySamples, resolvedResuspensionMixTypes, resolvedResuspensionMixVolumes, resolvedNumberOfResuspensionMixes, resolvedResuspensionMixInstruments, resolvedResuspensionMixTemperatures, resolvedResuspensionMixTimes, Range[Length[mySamples]]}
  ];
  (*Throws the error if tests are not being gathered*)
  If[Length[resuspensionTypeConflictingOptions] > 0 && messages,
    Message[
      Error::ResuspensionMixTypeConflictingOptions,
      ObjectToString[resuspensionTypeConflictingOptions[[All, 1]], Cache -> cacheBall],
      resuspensionTypeConflictingOptions[[All, 2]],
      resuspensionTypeConflictingOptions[[All, 3]],
      ObjectToString[resuspensionTypeConflictingOptions[[All, 4]], Cache -> cacheBall],
      resuspensionTypeConflictingOptions[[All, 5]],
      resuspensionTypeConflictingOptions[[All, 6]],
      resuspensionTypeConflictingOptions[[All, 7]],
      resuspensionTypeConflictingOptions[[All, 8]]
    ];
  ];
  (* Package the fails/passes if tests are being gathered *)
  resuspensionTypeConflictingOptionsTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = resuspensionTypeConflictingOptions[[All, 1]];
      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " do not have conflicting ResuspensionMixing options:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " do not have conflicting ResuspensionMixing options:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];



  (*********** Warnings ***********)
  (* Sterile / RoboticInstrument conflicting options.*)
  sterileInstrumentConflictingOptions = MapThread[
    Function[{sample, index},
      If[
        And[
          MatchQ[resolvedSterile, True],
          MatchQ[resolvedWorkCell, STAR]
        ],
        {sample, resolvedSterile, resolvedWorkCell, index},
        Nothing
      ]
    ],
    {mySamples, Range[Length[mySamples]]}
  ];
  (*Throws the error if tests are not being gathered*)
  If[Length[sterileInstrumentConflictingOptions] > 0 && messages,
    Message[
      Warning::SterileInstrumentConflictingOptions,
      ObjectToString[sterileInstrumentConflictingOptions[[All, 1]], Cache -> cacheBall],
      sterileInstrumentConflictingOptions[[All, 2]],
      ObjectToString[sterileInstrumentConflictingOptions[[All, 3]], Cache -> cacheBall],
      sterileInstrumentConflictingOptions[[All, 4]]
    ];
  ];

  (* PrecipitationTime / PrecipitationInstrument / PrecipitationTemperature conflicting options. *)
  precipitationWaitTimeConflictingOptions = MapThread[
    Function[{sample, precipitationTime, precipitationInstrument, precipitationTemperature, index},
      If[
        Or[
          And[
            MatchQ[precipitationTime, GreaterP[0 Minute]],
            Or[
              MatchQ[precipitationInstrument, Null],
              MatchQ[precipitationTemperature, Null]
            ]
          ]
        ],
        {sample, precipitationTime, precipitationInstrument, precipitationTemperature, index},
        Nothing
      ]
    ],
    {mySamples, Lookup[myOptions, PrecipitationTime], resolvedPrecipitationInstruments, resolvedPrecipitationTemperatures, Range[Length[mySamples]]}
  ];
  (*Throws the error if tests are not being gathered*)
  If[Length[precipitationWaitTimeConflictingOptions] > 0 && messages,
    Message[
      Warning::PrecipitationWaitTimeConflictingOptions,
      ObjectToString[precipitationWaitTimeConflictingOptions[[All, 1]], Cache -> cacheBall],
      precipitationWaitTimeConflictingOptions[[All, 2]],
      ObjectToString[precipitationWaitTimeConflictingOptions[[All, 3]], Cache -> cacheBall],
      precipitationWaitTimeConflictingOptions[[All, 4]],
      precipitationWaitTimeConflictingOptions[[All, 5]]
    ];
  ];

  (* NumberOfWashes / WashSolution / WashSolutionVolume conflicting options. *)
  noWashSolutionsForWashingSteps = MapThread[
    Function[{sample, numberOfWashes, washSolution, washSolutionVolume, index},
      If[
        Or[
          And[
            MatchQ[numberOfWashes, GreaterP[0]],
            Or[
              MatchQ[washSolution, Null],
              !MatchQ[washSolutionVolume, GreaterP[0 Milliliter]]
            ]
          ]
        ],
        {sample, numberOfWashes, washSolution, washSolutionVolume, index},
        Nothing
      ]
    ],
    {mySamples, resolvedNumberOfWashes, resolvedWashSolutions, resolvedWashSolutionVolumes, Range[Length[mySamples]]}
  ];
  (*Throws the error if tests are not being gathered*)
  If[Length[noWashSolutionsForWashingSteps] > 0 && messages,
    Message[
      Error::NumberOfWashesConflictingOptions,
      ObjectToString[noWashSolutionsForWashingSteps[[All, 1]], Cache -> cacheBall],
      noWashSolutionsForWashingSteps[[All, 2]],
      noWashSolutionsForWashingSteps[[All, 3]],
      noWashSolutionsForWashingSteps[[All, 4]],
      noWashSolutionsForWashingSteps[[All, 5]]
    ];
  ];
  (* Package the fails/passes if tests are being gathered *)
  noWashSolutionsForWashingStepsTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = noWashSolutionsForWashingSteps[[All, 1]];
      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " do not have conflicting NumberOfWashes/WashSolution/WashSolutionVolume options:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " do not have conflicting NumberOfWashes/WashSolution/WashSolutionVolume options:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* Time missing for PrecipitationReagentTemperature / PrecipitationReagentEquilibrationTime OR WashSolutionTemperature / WashSolutionEquilibrationTime OR ResuspensionBufferTemperature / ResuspensionBufferEquilibrationTime
 conflicting options. *)
  preIncubationTimeNotSpecified = MapThread[
    Function[{sample, precipitationReagentTemperature, precipitationReagentEquilibrationTime, washSolutionTemperature, washSolutionEquilibrationTime, resuspensionBufferTemperature,
      resuspensionBufferEquilibrationTime, index},
      If[
        Or[
          And[
            !MatchQ[precipitationReagentTemperature, (Null|Ambient)],
            !MatchQ[precipitationReagentEquilibrationTime, GreaterP[0 Minute]]
          ],
          And[
            !MatchQ[washSolutionTemperature, (Null|Ambient)],
            !MatchQ[washSolutionEquilibrationTime, GreaterP[0 Minute]]
          ],
          And[
            !MatchQ[resuspensionBufferTemperature, (Null|Ambient)],
            !MatchQ[resuspensionBufferEquilibrationTime, GreaterP[0 Minute]]
          ]
        ],
        {sample, precipitationReagentTemperature, precipitationReagentEquilibrationTime, washSolutionTemperature, washSolutionEquilibrationTime, resuspensionBufferTemperature, resuspensionBufferEquilibrationTime, index},
        Nothing
      ]
    ],
    {mySamples, Lookup[myOptions, PrecipitationTemperature], Lookup[myOptions, PrecipitationTime], resolvedWashSolutionTemperatures, resolvedWashSolutionEquilibrationTimes,
      resolvedResuspensionBufferTemperatures, resolvedResuspensionBufferEquilibrationTimes, Range[Length[mySamples]]}
  ];
  (*Throws the error if tests are not being gathered*)
  If[Length[preIncubationTemperatureNotSpecified] > 0 && messages,
    Message[
      Error::PreIncubationTemperatureNotSpecified,
      ObjectToString[preIncubationTemperatureNotSpecified[[All, 1]], Cache -> cacheBall],
      preIncubationTemperatureNotSpecified[[All, 2]],
      preIncubationTemperatureNotSpecified[[All, 3]],
      preIncubationTemperatureNotSpecified[[All, 4]],
      preIncubationTemperatureNotSpecified[[All, 5]],
      preIncubationTemperatureNotSpecified[[All, 6]],
      preIncubationTemperatureNotSpecified[[All, 7]],
      preIncubationTemperatureNotSpecified[[All, 8]]
    ];
  ];
  (* Package the fails/passes if tests are being gathered *)
  preIncubationTimeNotSpecified = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = preIncubationTimeNotSpecified[[All, 1]];
      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " PrecipitationReagentTemperature, WashSolutionTemperature, and ResuspensionBufferTemperature all have appropriate corresponding time settings:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " PrecipitationReagentTemperature, WashSolutionTemperature, and ResuspensionBufferTemperature all have appropriate corresponding time settings:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];
  (**************** END Check for conflicting Options Checks *****************)

  (* Overwrite our rounded options with our resolved options. Everything else has a default. *)
  resolvedOptions = Normal[
    Join[
      Association@roundedExperimentOptions,
      Association@{

        RoboticInstrument -> resolvedRoboticInstrument,
        PrecipitationReagent -> resolvedPrecipitationReagents,
        PrecipitationReagentVolume -> resolvedPrecipitationReagentVolumes,
        PrecipitationMixType -> resolvedPrecipitationMixTypes,
        PrecipitationMixInstrument -> resolvedPrecipitationMixInstruments,
        PrecipitationMixRate -> resolvedPrecipitationMixRates,
        PrecipitationMixTemperature -> resolvedPrecipitationMixTemperatures,
        PrecipitationMixTime -> resolvedPrecipitationMixTimes,
        NumberOfPrecipitationMixes -> resolvedNumberOfPrecipitationMixes,
        PrecipitationMixVolume -> resolvedPrecipitationMixVolumes,
        PrecipitationInstrument -> resolvedPrecipitationInstruments,
        PrecipitationTemperature -> resolvedPrecipitationTemperatures,
        FiltrationInstrument -> resolvedFiltrationInstruments,
        FiltrationTechnique -> resolvedFiltrationTechniques,
        Filter -> resolvedFilters,
        PrefilterPoreSize -> resolvedPrefilterPoreSizes,
        PrefilterMembraneMaterial -> resolvedPrefilterMembraneMaterials,
        PoreSize -> resolvedPoreSizes,
        MembraneMaterial -> resolvedMembraneMaterials,
        FilterPosition -> resolvedFilterPositions,
        FilterCentrifugeIntensity -> resolvedFilterCentrifugeIntensities,
        FiltrationPressure -> resolvedFiltrationPressures,
        FiltrationTime -> resolvedFiltrationTimes,
        FiltrateVolume -> resolvedFiltrateVolumes,
        FilterStorageCondition -> resolvedFilterStorageConditions,
        PelletVolume -> resolvedPelletVolumes,
        PelletCentrifuge -> resolvedPelletCentrifuges,
        PelletCentrifugeIntensity -> resolvedPelletCentrifugeIntensities,
        PelletCentrifugeTime -> resolvedPelletCentrifugeTimes,
        SupernatantVolume -> resolvedSupernatantVolumes,
        NumberOfWashes -> resolvedNumberOfWashes,
        WashSolution -> resolvedWashSolutions,
        WashSolutionVolume -> resolvedWashSolutionVolumes,
        WashSolutionTemperature -> resolvedWashSolutionTemperatures,
        WashSolutionEquilibrationTime -> resolvedWashSolutionEquilibrationTimes,
        WashMixType -> resolvedWashMixTypes,
        WashMixInstrument -> resolvedWashMixInstruments,
        WashMixRate -> resolvedWashMixRates,
        WashMixTemperature -> resolvedWashMixTemperatures,
        WashMixTime -> resolvedWashMixTimes,
        NumberOfWashMixes -> resolvedNumberOfWashMixes,
        WashMixVolume -> resolvedWashMixVolumes,
        WashPrecipitationTime -> resolvedWashPrecipitationTimes,
        WashPrecipitationInstrument -> resolvedWashPrecipitationInstruments,
        WashPrecipitationTemperature -> resolvedWashPrecipitationTemperatures,
        WashCentrifugeIntensity -> resolvedWashCentrifugeIntensities,
        WashPressure -> resolvedWashPressures,
        WashSeparationTime -> resolvedWashSeparationTimes,
        DryingTemperature -> resolvedDryingTemperatures,
        DryingTime -> resolvedDryingTimes,
        ResuspensionBuffer -> resolvedResuspensionBuffers,
        ResuspensionBufferVolume -> resolvedResuspensionBufferVolumes,
        ResuspensionBufferTemperature -> resolvedResuspensionBufferTemperatures,
        ResuspensionBufferEquilibrationTime -> resolvedResuspensionBufferEquilibrationTimes,
        ResuspensionMixType -> resolvedResuspensionMixTypes,
        ResuspensionMixInstrument -> resolvedResuspensionMixInstruments,
        ResuspensionMixRate -> resolvedResuspensionMixRates,
        ResuspensionMixTemperature -> resolvedResuspensionMixTemperatures,
        ResuspensionMixTime -> resolvedResuspensionMixTimes,
        NumberOfResuspensionMixes -> resolvedNumberOfResuspensionMixes,
        ResuspensionMixVolume -> resolvedResuspensionMixVolumes,
        PrecipitatedSampleStorageCondition -> resolvedPrecipitatedSampleStorageConditions,
        UnprecipitatedSampleStorageCondition -> resolvedUnprecipitatedSampleStorageConditions,
        PrecipitatedSampleContainerOut -> resolvedPrecipitatedContainerOut,
        PrecipitatedSampleLabel -> resolvedPrecipitatedSampleLabels,
        PrecipitatedSampleContainerLabel -> resolvedPrecipitatedSampleContainerLabels,
        UnprecipitatedSampleContainerOut -> resolvedUnprecipitatedContainerOut,
        UnprecipitatedSampleLabel -> resolvedUnprecipitatedSampleLabels,
        UnprecipitatedSampleContainerLabel -> resolvedUnprecipitatedSampleContainerLabels,
        (* Null, Null can happen in some conditions if the user sets the container out to Null or a retentate is not saved,
        but this does not match the pattern for the option, so switch to just Null here. *)
        FullPrecipitatedSampleContainerOut -> resolvedFullPrecipitatedContainerOut /. {Null, Null} -> Null,
        FullUnprecipitatedSampleContainerOut -> resolvedFullUnprecipitatedContainerOut /. {Null, Null} -> Null,
        Sterile -> resolvedSterile,

        resolvedPostProcessingOptions,

        Email -> email,
        WorkCell -> resolvedWorkCell

      }
    ],
    Association
  ];

  (* THROW CONFLICTING OPTION ERRORS *)

  (* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)

  invalidInputs = DeleteDuplicates[Flatten[{discardedInvalidInputs, deprecatedInvalidInputs}]];

  invalidOptions = DeleteDuplicates[Flatten[{
    If[Length[separationTechniqueConflictingOptions] > 0,
      {SeparationTechnique, FiltrationInstrument, FiltrationTechnique, Filter, FilterPosition, FiltrationTime, PelletVolume, PelletCentrifuge,
        PelletCentrifugeIntensity, PelletCentrifugeTime, SupernatantVolume},
      {}
    ],
    If[Length[precipitationInstrumentConflictingOptions] > 0,
      {PrecipitationInstrument, PrecipitationTemperature},
      {}
    ],
    If[Length[notWashingConflictingOptions] > 0,
      {NumberOfWashes, WashSolution, WashSolutionVolume, WashSolutionTemperature, WashSolutionEquilibrationTime, WashMixType, WashMixInstrument, WashMixRate, WashMixTemperature,
        WashMixTime, NumberOfWashMixes, WashMixVolume, WashPrecipitationTime, WashPrecipitationInstrument, WashPrecipitationTemperature, WashCentrifugeIntensity,
        WashPressure, WashSeparationTime},
      {}
    ],
    If[Length[dryingSolidConflictingOptions] > 0,
      {DryingTime, DryingTemperature},
      {}
    ],
    If[Length[resuspensionBufferConflictingOptions] > 0,
      {ResuspensionBuffer, ResuspensionBufferVolume},
      {}
    ],
    If[Length[preIncubationTemperatureNotSpecified] > 0,
      {PrecipitationReagentTemperature, PrecipitationReagentEquilibrationTime, WashSolutionTemperature, WashSolutionEquilibrationTime, ResuspensionBufferTemperature, ResuspensionBufferEquilibrationTime},
      {}
    ],
    If[Length[precipitationMixTypeConflictingOptions] > 0,
      {PrecipitationMixType, PrecipitationMixVolume, NumberOfPrecipitationMixes, PrecipitationMixInstrument, PrecipitationMixTemperature, PrecipitationMixTime},
      {}
    ],
    If[Length[washTypeConflictingOptions] > 0,
      {WashMixType, WashMixVolume, NumberOfWashMixes, WashMixInstrument, WashMixTemperature, WashMixTime},
      {}
    ],
    If[Length[resuspensionTypeConflictingOptions] > 0,
      {ResuspensionMixType, ResuspensionMixVolume, NumberOfResuspensionMixes, ResuspensionMixInstrument, ResuspensionMixTemperature, ResuspensionMixTime},
      {}
    ],
    If[Length[noWashSolutionsForWashingSteps] > 0,
      {NumberOfWashes, WashSolution, WashSolutionVolume},
      {}
    ]
  }]];

  (* Throw Error::InvalidInput if there are invalid inputs. *)
  If[Length[invalidInputs] > 0 && !gatherTests,
    Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> cache]]
  ];

  (* Throw Error::InvalidOption if there are invalid options. *)
  If[Length[invalidOptions] > 0 && !gatherTests,
    Message[Error::InvalidOption, invalidOptions]
  ];

  (* Return our resolved options and/or tests. *)
  outputSpecification /. {
    Result -> resolvedOptions,
    Tests -> Flatten[{
      separationTechniqueConflictingOptionsTests,
      sterileInstrumentConflictingOptionsTests,
      precipitationWaitTimeConflictingOptionsTests,
      precipitationInstrumentConflictingOptionsTests,
      noWashSolutionsForWashingStepsTests,
      notWashingConflictingOptionsTests,
      dryingSolidConflictingOptionsTests,
      preIncubationTemperatureNotSpecifiedTests,
      resuspensionBufferConflictingOptionsTests,
      precipitationMixTypeConflictingOptionsTests,
      washTypeConflictingOptionsTests,
      resuspensionTypeConflictingOptionsTests
    }]
  }

];

DefineOptions[
  precipitateResourcePackets,
  Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

precipitateResourcePackets[mySamples : ListableP[ObjectP[Object[Sample]]], myTemplatedOptions : {(_Rule | _RuleDelayed)...}, myResolvedOptions : {(_Rule | _RuleDelayed)..}, ops : OptionsPattern[]] := Module[
  {
    expandedInputs, expandedResolvedOptions, resolvedOptionsNoHidden, outputSpecification, output, gatherTests,
    messages, inheritedCache, samplePackets, uniqueSamplesInResources, resolvedPreparation, mapThreadFriendlyOptions,
    samplesInResources, sampleContainersIn, uniqueSampleContainersInResources, containersInResources,
    protocolPacket, allResourceBlobs, resourcesOk, resourceTests, previewRule, optionsRule, testsRule, resultRule,
    allUnitOperationPackets, currentSimulation, userSpecifiedLabels, runTime,


    expandedPrecipitationPelletBools
  },

  (* get the inherited cache *)
  inheritedCache = Lookup[ToList[ops], Cache, {}];

  (* Get the simulation *)
  currentSimulation = Lookup[ToList[ops], Simulation, {}];

  (* Lookup the resolved Preparation option. *)
  resolvedPreparation = Lookup[myResolvedOptions, Preparation];

  (* expand the resolved options if they weren't expanded already *)
  {expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentPrecipitate, {mySamples}, myResolvedOptions];

  (* Get the resolved collapsed index matching options that don't include hidden options *)
  resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
    ExperimentPrecipitate,
    RemoveHiddenOptions[ExperimentPrecipitate, myResolvedOptions],
    Ignore -> myTemplatedOptions,
    Messages -> False
  ];

  (* Determine the requested return value from the function *)
  outputSpecification = OptionDefault[OptionValue[Output]];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests; if True, then silence the messages *)
  gatherTests = MemberQ[output, Tests];
  messages = !gatherTests;

  (* Download *)
  samplePackets = Download[
    mySamples,
    Packet[Container, Position, Volume],
    Cache -> inheritedCache,
    Simulation -> currentSimulation
  ];

  (* Create resources for our samples in. *)
  uniqueSamplesInResources = (# -> Resource[Sample -> #, Name -> CreateUUID[]]&) /@ DeleteDuplicates[Download[mySamples, Object]];
  samplesInResources = (Download[mySamples, Object]) /. uniqueSamplesInResources;

  (* Create resources for our containers in. *)
  sampleContainersIn = Lookup[samplePackets, Container];
  uniqueSampleContainersInResources = (# -> Resource[Sample -> #, Name -> CreateUUID[]]&) /@ DeleteDuplicates[sampleContainersIn];
  containersInResources = (Download[sampleContainersIn, Object]) /. uniqueSampleContainersInResources;

  (* Get our map thread friendly options. *)
  mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[
    ExperimentPrecipitate,
    myResolvedOptions
  ];

  (* Get our user specified labels. *)
  userSpecifiedLabels = DeleteDuplicates@Cases[
    Flatten@Lookup[
      myResolvedOptions,
      {PrecipitatedSampleLabel, PrecipitatedSampleContainerLabel, UnprecipitatedSampleLabel, UnprecipitatedSampleContainerLabel}
    ],
    _String
  ];

  (* --- Create the protocol packet --- *)
  {protocolPacket, allUnitOperationPackets, currentSimulation, runTime} = Module[
    {extractionContainerLabels, extractionContainers, precipitateContainerLabels, unprecipitateContainerLabels, impurityContainerLabels, precipitatedSampleLabels, unprecipitatedSampleLabels,
      mapThreadFriendlyOptionsWithUpdatedLabels, labelSampleAndContainerUnitOperations, sampleContainerLabels,
      workingSampleContainerLabels, workingSampleContainerWells, aliquotUnitOperations, residualIncubationUnitOperations,
      phaseSeparatorUnitOperations, allPhaseSeparatorLabels, allCollectionContainerLabels, phaseSeparatorAndCollectionContainerLabelUnitOperations,
      pipetteUnitOperations, labelSampleUnitOperation, primitives, roboticUnitOperationPackets, roboticRunTime, roboticSimulation,
      outputUnitOperationPacket,


      precipitationPelletUnitOperations, moveToNewContainer, targetContainers, targetWells,
      maxPrecipitationReagentEquilibrationTime, maxWashSolutionEquilibrationTime, maxResuspensionBufferEquilibrationTime, transferToPrecipitatedSamplesContainerOutUnitOperations,
      labelSamplesUnitOperations,

      pelletPrecipitatedSamplesUnitOperations, pelletWashSamplesUnitOperations, drySamplesUnitOperations, resuspendSamplesUnitOperations, resuspendMixSamplesUnitOperations,
      filterSamplesUnitOperations, filterWashContainer,

      mapThreadFriendlyOptionsToPellet, mapThreadFriendlyOptionsToPelletAndWash, mapThreadFriendlyOptionsToPelletAndPrecipitate, mapThreadFriendlyOptionsToDry, mapThreadFriendlyOptionsToResuspend, mapThreadFriendlyOptionsToResuspendAndMix,
      mapThreadFriendlyOptionsToFilter, mapThreadFriendlyOptionsToMixPelletPrecipitation, mapThreadFriendlyOptionsToMixFilterPrecipitation,
      mapThreadFriendlyOptionsToPelletWashAndMix, experimentFunction, mapThreadFriendlyOptionsToTransferToPrecipitatedContainer, mapThreadFriendlyOptionsToLabel
    },

    (*		Label ContainersOut if they were not labeled, label the SamplesOut if they were not labeled.
may need to Label container a plate
	ask for samples in tubes and transfer them
	Figure out what the DeadVOlume is for plates, (Min volume) *)

    (*** Identify all unique temperature and reagent combinations ***)

    (* Get the maximum EquilibrationTime for each reagent type and we'll set all of them to that. *)
    {maxPrecipitationReagentEquilibrationTime, maxWashSolutionEquilibrationTime, maxResuspensionBufferEquilibrationTime} =
        {
          Max[Lookup[myResolvedOptions, PrecipitationReagentEquilibrationTime] /. Null -> 0 Minute], (* Nulls will cause an error, so convert them to 0 Minute *)
          Max[Lookup[myResolvedOptions, WashSolutionEquilibrationTime] /. Null -> 0 Minute], (* Nulls will cause an error, so convert them to 0 Minute *)
          Max[Lookup[myResolvedOptions, ResuspensionBufferEquilibrationTime] /. Null -> 0 Minute](* Nulls will cause an error, so convert them to 0 Minute *)
        };


    (* If the user didn't specify a label for PrecipitatedSampleContainerOut, then we'll need to do it *)
    (* filled out in order to label containers for use in our unit operations. *)
    precipitateContainerLabels = Module[{sanitizedTargetContainerOuts, combinedContainersToLabels, containersToLabels},
      (* Model[Container] means that a new container should be used. To make sure that this is the case, replace them with UUIDs. *)
      sanitizedTargetContainerOuts = Replace[Lookup[myResolvedOptions, PrecipitatedSampleContainerOut], ObjectP[Model[Container]] :> CreateUUID[], {1}];

      (* Make sure that all TargetContainerOuts have a label. *)
      (* This should already be the case but sometimes the user sets the label to be Null manually. *)
      (* This is in the format <|container1 -> {label1, label1}, container2 -> {label2, label2, Null}|> *)
      combinedContainersToLabels = GroupBy[
        Rule @@@ Transpose[{sanitizedTargetContainerOuts, Lookup[myResolvedOptions, PrecipitatedSampleContainerLabel]}],
        First -> Last
      ];

      (* Take the first label set for the container, if there are no labels, make a unique one to use internally in our UOs. *)
      containersToLabels = Normal[
        Map[
          (FirstCase[#, _String, CreateUniqueLabel["precipitated solid container", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels]]&),
          combinedContainersToLabels
        ],
        Association
      ];

      (Lookup[containersToLabels, Key[#]]&) /@ sanitizedTargetContainerOuts
    ];

    (* If the user didn't specify a label for UnprecipitatedSampleContainerOut, then we'll need to do it *)
    (* filled out in order to label containers for use in our unit operations. *)
    unprecipitateContainerLabels = Module[{sanitizedTargetContainerOuts, combinedContainersToLabels, containersToLabels},
      (* Model[Container] means that a new container should be used. To make sure that this is the case, replace them with UUIDs. *)
      sanitizedTargetContainerOuts = Replace[Lookup[myResolvedOptions, UnprecipitatedSampleContainerOut], ObjectP[Model[Container]] :> CreateUUID[], {1}];

      (* Make sure that all TargetContainerOuts have a label. *)
      (* This should already be the case but sometimes the user sets the label to be Null manually. *)
      (* This is in the format <|container1 -> {label1, label1}, container2 -> {label2, label2, Null}|> *)
      combinedContainersToLabels = GroupBy[
        Rule @@@ Transpose[{sanitizedTargetContainerOuts, Lookup[myResolvedOptions, UnprecipitatedSampleContainerLabel]}],
        First -> Last
      ];

      (* Take the first label set for the container, if there are no labels, make a unique one to use internally in our UOs. *)
      containersToLabels = Normal[
        Map[
          (FirstCase[#, _String, CreateUniqueLabel["unprecipitated liquid container", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels]]&),
          combinedContainersToLabels
        ],
        Association
      ];

      (Lookup[containersToLabels, Key[#]]&) /@ sanitizedTargetContainerOuts
    ];

    (* If the user didn't specify a label for UnprecipitatedSampleOut, then we'll need to do it *)
    (* filled out in order to label containers for use in our unit operations. *)
    precipitatedSampleLabels = Module[{combinedSampleToLabels, samplesToLabels},

      (* Make sure that all TargetContainerOuts have a label. *)
      (* This should already be the case but sometimes the user sets the label to be Null manually. *)
      (* This is in the format <|container1 -> {label1, label1}, container2 -> {label2, label2, Null}|> *)
      combinedSampleToLabels = Lookup[myResolvedOptions, PrecipitatedSampleLabel];

      (* Take the first label set for the container, if there are no labels, make a unique one to use internally in our UOs. *)
    samplesToLabels = Normal[
        Map[
          (Replace[#, Null -> CreateUniqueLabel["precipitated solid sample", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels]]&),
          combinedSampleToLabels
        ],
        Association
      ];
      samplesToLabels
    ];

    (* If the user didn't specify a label for UnprecipitatedSampleOut, then we'll need to do it *)
    (* filled out in order to label containers for use in our unit operations. *)
    unprecipitatedSampleLabels = Module[{sanitizedSampleOuts, combinedSampleToLabels, samplesToLabels},

      (* Make sure that all TargetContainerOuts have a label. *)
      (* This should already be the case but sometimes the user sets the label to be Null manually. *)
      (* This is in the format <|container1 -> {label1, label1}, container2 -> {label2, label2, Null}|> *)
      combinedSampleToLabels = Lookup[myResolvedOptions, UnprecipitatedSampleLabel];

      (* Take the first label set for the container, if there are no labels, make a unique one to use internally in our UOs. *)
      samplesToLabels = Normal[
        Map[
          (Replace[#, Null -> CreateUniqueLabel["unprecipitated liquid sample", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels]]&),
          combinedSampleToLabels
        ],
        Association
      ];
      samplesToLabels
    ];

    mapThreadFriendlyOptionsWithUpdatedLabels = OptionsHandling`Private`mapThreadOptions[
      ExperimentPrecipitate,
      ReplaceRule[
        myResolvedOptions,
        {
          PrecipitatedSampleContainerLabel -> precipitateContainerLabels,
          UnprecipitatedSampleContainerLabel -> unprecipitateContainerLabels,
          PrecipitatedSampleLabel -> precipitatedSampleLabels,
          UnprecipitatedSampleLabel -> unprecipitatedSampleLabels
        }
      ]
    ];

    moveToNewContainer = Module[{resolvedWells, resolvedContainers, currentWells, currentContainers, currentContainerModels},
      {resolvedWells, resolvedContainers} = Transpose[
        Map[
          If[MatchQ[#, Null],
            {Null, Null},
            #
          ]&,
          Lookup[myResolvedOptions, FullPrecipitatedSampleContainerOut]
        ]
      ];

      currentWells = Lookup[samplePackets, Position];
      currentContainers = Lookup[samplePackets, Container];
      currentContainerModels = Download[currentContainers, Model, Cache -> inheritedCache];
      MapThread[
        Function[{resolvedWell, resolvedContainer, currentWell, currentContainer},
          And[
            MatchQ[resolvedContainer, currentContainer[[1]]],
            MatchQ[resolvedWell, currentWell]
          ]
        ],
        {resolvedWells, resolvedContainers, currentWells, currentContainers}
      ]
    ];

    (* Mix cannot handle MixType Null on Robotic so only give it samples with a set MixType *)
    mapThreadFriendlyOptionsToMixPelletPrecipitation = PickList[mapThreadFriendlyOptionsWithUpdatedLabels, Transpose[{Lookup[myResolvedOptions, SeparationTechnique], Lookup[myResolvedOptions, PrecipitationMixType]}], {Pellet, (Shake | Pipette)}];
    mapThreadFriendlyOptionsToMixFilterPrecipitation = PickList[mapThreadFriendlyOptionsWithUpdatedLabels, Transpose[{Lookup[myResolvedOptions, SeparationTechnique], Lookup[myResolvedOptions, PrecipitationMixType]}], {Filter, (Shake | Pipette)}];

    (* If the Sample isn't currently in the Precipitate ContainerOut, then move it ther now*)
    mapThreadFriendlyOptionsToTransferToPrecipitatedContainer = PickList[mapThreadFriendlyOptionsWithUpdatedLabels, Transpose[{Lookup[myResolvedOptions, SeparationTechnique], moveToNewContainer}], {Pellet, False}];
    mapThreadFriendlyOptionsToLabel = PickList[mapThreadFriendlyOptionsWithUpdatedLabels, Transpose[{Lookup[myResolvedOptions, SeparationTechnique], moveToNewContainer}], {Pellet, True}];
    (* If there are any samples not currently in the precipitated container out, then transfer them now *)

    labelSamplesUnitOperations =
        If[Length[mapThreadFriendlyOptionsToLabel] > 0,
          {
            LabelSample[
              Label -> Lookup[mapThreadFriendlyOptionsToLabel, PrecipitatedSampleLabel],
              Sample -> PickList[mySamples, Transpose[{Lookup[myResolvedOptions, SeparationTechnique], moveToNewContainer}], {Pellet, True}]
            ],
            LabelContainer[
              Label -> Lookup[mapThreadFriendlyOptionsToLabel, PrecipitatedSampleContainerLabel],
              Container -> Lookup[mapThreadFriendlyOptionsToLabel, PrecipitatedSampleContainerOut]
            ]
          },
          Nothing
        ];

    transferToPrecipitatedSamplesContainerOutUnitOperations =
        If[Length[mapThreadFriendlyOptionsToTransferToPrecipitatedContainer] > 0,
        Transfer[
          Source -> PickList[mySamples, Transpose[{Lookup[myResolvedOptions, SeparationTechnique], moveToNewContainer}], {Pellet, False}],
          Destination -> Lookup[mapThreadFriendlyOptionsToTransferToPrecipitatedContainer, FullPrecipitatedSampleContainerOut][[All, 2]],
          DestinationLabel -> Lookup[mapThreadFriendlyOptionsToTransferToPrecipitatedContainer, PrecipitatedSampleLabel],
          DestinationWell -> Lookup[mapThreadFriendlyOptionsToTransferToPrecipitatedContainer, FullPrecipitatedSampleContainerOut][[All, 1]],
          DestinationContainerLabel -> Lookup[mapThreadFriendlyOptionsToTransferToPrecipitatedContainer, PrecipitatedSampleContainerLabel],
          Amount -> Lookup[mapThreadFriendlyOptionsToTransferToPrecipitatedContainer, SampleVolume],
          Preparation -> Robotic,
          WorkCell -> Lookup[myResolvedOptions, WorkCell]
        ],
        Nothing
      ];

    mapThreadFriendlyOptionsToPellet = PickList[mapThreadFriendlyOptionsWithUpdatedLabels, Lookup[myResolvedOptions, SeparationTechnique], Pellet];
    mapThreadFriendlyOptionsToPelletAndWash = PickList[mapThreadFriendlyOptionsWithUpdatedLabels, Transpose[{Lookup[myResolvedOptions, SeparationTechnique], Lookup[myResolvedOptions, NumberOfWashes]}], {Pellet, GreaterP[0]}];
    mapThreadFriendlyOptionsToPelletWashAndMix = PickList[mapThreadFriendlyOptionsWithUpdatedLabels, Transpose[{Lookup[myResolvedOptions, SeparationTechnique], Lookup[myResolvedOptions, NumberOfWashes], Lookup[myResolvedOptions, WashMixType]}], {Pellet, GreaterP[0], Except[None|Null]}];
    mapThreadFriendlyOptionsToPelletAndPrecipitate = PickList[mapThreadFriendlyOptionsWithUpdatedLabels, Transpose[{Lookup[myResolvedOptions, SeparationTechnique], Lookup[myResolvedOptions, WashPrecipitationTime]}], {Pellet, GreaterP[0 Minute]}];
    mapThreadFriendlyOptionsToDry = PickList[mapThreadFriendlyOptionsWithUpdatedLabels, Transpose[{Lookup[myResolvedOptions, SeparationTechnique], Lookup[myResolvedOptions, DryingTime]}], {Pellet, GreaterP[0 Minute]}];
    mapThreadFriendlyOptionsToResuspend = PickList[mapThreadFriendlyOptionsWithUpdatedLabels, Transpose[{Lookup[myResolvedOptions, SeparationTechnique], Lookup[myResolvedOptions, ResuspensionBuffer]}], {Pellet, ObjectP[]}];
    mapThreadFriendlyOptionsToResuspendAndMix = PickList[mapThreadFriendlyOptionsWithUpdatedLabels, Transpose[{Lookup[myResolvedOptions, SeparationTechnique], Lookup[myResolvedOptions, ResuspensionBuffer], Lookup[myResolvedOptions, ResuspensionMixType]}], {Pellet, ObjectP[], Except[None|Null]}];
    mapThreadFriendlyOptionsToFilter = PickList[mapThreadFriendlyOptions, Lookup[myResolvedOptions, SeparationTechnique], Filter];

    pelletPrecipitatedSamplesUnitOperations =
        If[MemberQ[Lookup[myResolvedOptions, SeparationTechnique], Pellet],
          {
            Transfer[
              Source -> Lookup[mapThreadFriendlyOptionsToPellet, PrecipitationReagent],
              Destination -> Lookup[mapThreadFriendlyOptionsToPellet, PrecipitatedSampleLabel],
              Amount -> Lookup[mapThreadFriendlyOptionsToPellet, PrecipitationReagentVolume],
              Preparation -> Robotic,
              WorkCell -> Lookup[myResolvedOptions, WorkCell]
            ],
            If[MemberQ[Lookup[mapThreadFriendlyOptionsToPellet, PrecipitationMixType], (Shake | Pipette)],
              Mix[
                Sample -> Lookup[mapThreadFriendlyOptionsToMixPelletPrecipitation, PrecipitatedSampleLabel],
                MixType -> Lookup[mapThreadFriendlyOptionsToMixPelletPrecipitation, PrecipitationMixType],
                Instrument -> Lookup[mapThreadFriendlyOptionsToMixPelletPrecipitation, PrecipitationMixInstrument],
                MixRate -> Lookup[mapThreadFriendlyOptionsToMixPelletPrecipitation, PrecipitationMixRate],
                Temperature -> Lookup[mapThreadFriendlyOptionsToMixPelletPrecipitation, PrecipitationMixTemperature],
                Time -> Lookup[mapThreadFriendlyOptionsToMixPelletPrecipitation, PrecipitationMixTime],
                NumberOfMixes -> Lookup[mapThreadFriendlyOptionsToMixPelletPrecipitation, NumberOfPrecipitationMixes],
                MixVolume -> Lookup[mapThreadFriendlyOptionsToMixPelletPrecipitation, PrecipitationMixVolume],
                Preparation -> Robotic,
                WorkCell -> Lookup[myResolvedOptions, WorkCell]
              ],
              Nothing
            ],
            If[MemberQ[Lookup[mapThreadFriendlyOptionsToPellet, PrecipitationTime], GreaterP[0 Minute]],
              Incubate[
                Sample -> PickList[Lookup[mapThreadFriendlyOptionsToPellet, PrecipitatedSampleLabel], Lookup[mapThreadFriendlyOptionsToPellet, PrecipitationTime], GreaterP[0 Minute]],
                Instrument -> PickList[Lookup[mapThreadFriendlyOptionsToPellet, PrecipitationInstrument], Lookup[mapThreadFriendlyOptionsToPellet, PrecipitationTime], GreaterP[0 Minute]],
                Temperature -> PickList[Lookup[mapThreadFriendlyOptionsToPellet, PrecipitationTemperature], Lookup[mapThreadFriendlyOptionsToPellet, PrecipitationTime], GreaterP[0 Minute]] /. Ambient -> 25 Celsius,
                Time -> PickList[Lookup[mapThreadFriendlyOptionsToPellet, PrecipitationTime], Lookup[mapThreadFriendlyOptionsToPellet, PrecipitationTime], GreaterP[0 Minute]],
                Preparation -> Robotic,
                WorkCell -> Lookup[myResolvedOptions, WorkCell]
              ],
              Nothing
            ],
            Pellet[
              Sample -> Lookup[mapThreadFriendlyOptionsToPellet, PrecipitatedSampleLabel],
              (*Precipitate can have a Null for this label, but Pellet cannot, so swap it to Automatic if set to Null*)
              ContainerOutLabel -> Lookup[mapThreadFriendlyOptionsToPellet, UnprecipitatedSampleContainerLabel] /. Null -> Automatic,
              SampleOutLabel -> Lookup[mapThreadFriendlyOptionsToPellet, UnprecipitatedSampleLabel]  /. Null -> Automatic,
              Instrument -> Lookup[mapThreadFriendlyOptionsToPellet, PelletCentrifuge],
              Intensity -> Lookup[mapThreadFriendlyOptionsToPellet, PelletCentrifugeIntensity],
              Time -> Lookup[mapThreadFriendlyOptionsToPellet, PelletCentrifugeTime],
              (*Pellet cannot transfer more than 970 Microliters, so that needs to be the maximum. Do an extra Transfer afterwards to remove the remaining volume*)
              SupernatantVolume -> Lookup[mapThreadFriendlyOptionsToPellet, SupernatantVolume] /. GreaterP[970 Microliter] -> 970 Microliter,
              (* Precipitate can have a Null for this Container, but Pellet cannot, so swap it to Automatic if set to Null*)
              SupernatantDestination -> Model[Container, Plate, "id:L8kPEjkmLbvW"],
              (*Lookup[mapThreadFriendlyOptionsToPellet, UnprecipitatedSampleContainerOut]/.Null->Automatic TODO This cannot accept a well, Sam is fixing*)
              Preparation -> Robotic,
              WorkCell -> Lookup[myResolvedOptions, WorkCell]
            ]
          },
          Nothing
        ];

    pelletWashSamplesUnitOperations =
        If[MemberQ[Transpose[{Lookup[myResolvedOptions, SeparationTechnique], Lookup[myResolvedOptions, NumberOfWashes]}], {Pellet, GreaterP[0]}],
          Map[
            Function[{washNumber},
              Module[{samplesToWash, samplesToWashAndMix, samplesToWashAndPrecipitate},
                samplesToWash = PickList[mapThreadFriendlyOptionsToPelletAndWash, Lookup[mapThreadFriendlyOptionsToPelletAndWash, NumberOfWashes], GreaterEqualP[washNumber]];
                samplesToWashAndMix = PickList[mapThreadFriendlyOptionsToPelletWashAndMix, Lookup[mapThreadFriendlyOptionsToPelletWashAndMix, NumberOfWashes], GreaterEqualP[washNumber]];
                samplesToWashAndPrecipitate = PickList[mapThreadFriendlyOptionsToPelletAndPrecipitate, Lookup[mapThreadFriendlyOptionsToPelletAndPrecipitate, NumberOfWashes], GreaterEqualP[washNumber]];
                {
                  If[Length[samplesToWash] > 0,
                    Transfer[
                      Source -> Lookup[samplesToWash, WashSolution],
                      Destination -> Lookup[samplesToWash, PrecipitatedSampleLabel],
                      Amount -> Lookup[samplesToWash, WashSolutionVolume],
                      Preparation -> Robotic,
                      WorkCell -> Lookup[myResolvedOptions, WorkCell]
                    ],
                    Nothing
                  ],
                  If[MemberQ[Transpose[{Lookup[samplesToWash, SeparationTechnique], Lookup[samplesToWash, WashMixType]}], {Pellet, Except[(None | Null)]}],
                    Mix[
                      Sample -> Lookup[samplesToWashAndMix, PrecipitatedSampleLabel],
                      MixType -> Lookup[samplesToWashAndMix, WashMixType],
                      Instrument -> Lookup[samplesToWashAndMix, WashMixInstrument],
                      MixRate -> Lookup[samplesToWashAndMix, WashMixRate],
                      Temperature -> Lookup[samplesToWashAndMix, WashMixTemperature],
                      Time -> Lookup[samplesToWashAndMix, WashMixTime],
                      NumberOfMixes -> Lookup[samplesToWashAndMix, NumberOfWashMixes],
                      MixVolume -> Lookup[samplesToWashAndMix, WashMixVolume],
                      Preparation -> Robotic,
                      WorkCell -> Lookup[myResolvedOptions, WorkCell]
                    ],
                    Nothing
                  ],
                  If[MemberQ[Transpose[{Lookup[samplesToWash, SeparationTechnique], Lookup[samplesToWash, WashPrecipitationTime]}], {Pellet, GreaterP[0 Minute]}],
                    Incubate[
                      Sample -> Lookup[samplesToWashAndPrecipitate, PrecipitatedSampleLabel],
                      Instrument -> Lookup[samplesToWashAndPrecipitate, WashPrecipitationInstrument],
                      Temperature -> Lookup[samplesToWashAndPrecipitate, WashPrecipitationTemperature],
                      Time -> Lookup[samplesToWashAndPrecipitate, WashPrecipitationTime],
                      Preparation -> Robotic,
                      WorkCell -> Lookup[myResolvedOptions, WorkCell]
                    ],
                    Nothing
                  ],
                  Pellet[
                    Sample -> Lookup[samplesToWash, PrecipitatedSampleLabel],
                    Instrument -> Lookup[samplesToWash, PelletCentrifuge],
                    Intensity -> Lookup[samplesToWash, WashCentrifugeIntensity],
                    Time -> Lookup[samplesToWash, WashSeparationTime],
                    SupernatantVolume -> Lookup[samplesToWash, WashSolutionVolume],
                    Preparation -> Robotic,
                    WorkCell -> Lookup[myResolvedOptions, WorkCell](*,
                    SupernatantDestination -> Waste*)
                  ]
                }
              ]
            ],
            Range[Max[Lookup[myResolvedOptions, NumberOfWashes] /. Null -> 0]] (*If there is a Null in there, it'll cause an error*)
          ],
          Nothing
        ];

    drySamplesUnitOperations =
        If[And[MemberQ[Lookup[myResolvedOptions, DryingTime], GreaterP[0 Minute]], MemberQ[Lookup[myResolvedOptions, SeparationTechnique], Pellet]],
          Incubate[
            Sample -> Lookup[mapThreadFriendlyOptionsToDry, PrecipitatedSampleLabel],
            Temperature -> Lookup[mapThreadFriendlyOptionsToDry, DryingTemperature] /. Ambient -> 25 Celsius, (* Incubate throws a warning if Temperature is given as Ambient along with these other settings *)
            Time -> Lookup[mapThreadFriendlyOptionsToDry, DryingTime],
            Preparation -> Robotic,
            WorkCell -> Lookup[myResolvedOptions, WorkCell]
          ],
          Nothing
        ];

    resuspendSamplesUnitOperations =
        If[MemberQ[Transpose[{Lookup[myResolvedOptions, SeparationTechnique], Lookup[myResolvedOptions, ResuspensionBuffer]}], {Pellet, ObjectP[]}],
          Transfer[
            Source -> Lookup[mapThreadFriendlyOptionsToResuspend, ResuspensionBuffer],
            Destination -> Lookup[mapThreadFriendlyOptionsToResuspend, PrecipitatedSampleLabel],
            Amount -> Lookup[mapThreadFriendlyOptionsToResuspend, ResuspensionBufferVolume],
            Preparation -> Robotic,
            WorkCell -> Lookup[myResolvedOptions, WorkCell]
          ],
          Nothing
        ];
    resuspendMixSamplesUnitOperations =
        If[MemberQ[Transpose[{Lookup[myResolvedOptions, SeparationTechnique], Lookup[myResolvedOptions, ResuspensionBuffer], Lookup[myResolvedOptions, ResuspensionMixType]}], {Pellet, ObjectP[], Except[None | Null]}],
          Mix[
            Sample -> Lookup[mapThreadFriendlyOptionsToResuspendAndMix, PrecipitatedSampleLabel],
            MixType -> Lookup[mapThreadFriendlyOptionsToResuspendAndMix, ResuspensionMixType],
            Instrument -> Lookup[mapThreadFriendlyOptionsToResuspendAndMix, ResuspensionMixInstrument],
            MixRate -> Lookup[mapThreadFriendlyOptionsToResuspendAndMix, ResuspensionMixRate],
            Temperature -> Lookup[mapThreadFriendlyOptionsToResuspendAndMix, ResuspensionMixTemperature],
            Time -> Lookup[mapThreadFriendlyOptionsToResuspendAndMix, ResuspensionMixTime],
            NumberOfMixes -> Lookup[mapThreadFriendlyOptionsToResuspendAndMix, NumberOfResuspensionMixes],
            MixVolume -> Lookup[mapThreadFriendlyOptionsToResuspendAndMix, ResuspensionMixVolume],
            Preparation -> Robotic,
            WorkCell -> Lookup[myResolvedOptions, WorkCell]
          ],
          Nothing
        ];



    (* Pick containers that will serve as the Wash Collection Plate *)
    filterWashContainer = Module[
      {maxWashVolume},
      maxWashVolume = Max[(Lookup[mapThreadFriendlyOptionsToFilter, WashSolutionVolume] * (Lookup[mapThreadFriendlyOptionsToFilter, NumberOfWashes] /. Null -> 0) /. 0 -> 0 Microliter)]; (* Max can't do Nulls and can't do unitless 0 evaluated with a volume so I replaced them*)
      PreferredContainer[maxWashVolume, Sterile -> Lookup[myResolvedOptions, Sterile], Type -> Plate, LiquidHandlerCompatible -> True]
    ];

    filterSamplesUnitOperations = If[MemberQ[Lookup[myResolvedOptions, SeparationTechnique], Filter],
      {
        Transfer[
          Source -> Lookup[mapThreadFriendlyOptionsToFilter, PrecipitationReagent],
          Destination -> PickList[mySamples, Lookup[myResolvedOptions, SeparationTechnique], Filter],
          Amount -> Lookup[mapThreadFriendlyOptionsToFilter, PrecipitationReagentVolume],
          Preparation -> Robotic,
          WorkCell -> Lookup[myResolvedOptions, WorkCell]
        ],
        If[MemberQ[Lookup[mapThreadFriendlyOptionsToFilter, PrecipitationMixType], (Shake | Pipette)],
          Mix[
            Sample -> PickList[mySamples, Transpose[{Lookup[myResolvedOptions, SeparationTechnique], Lookup[myResolvedOptions, PrecipitationMixType]}], {Filter, (Shake | Pipette)}],
            MixType -> Lookup[mapThreadFriendlyOptionsToMixFilterPrecipitation, PrecipitationMixType],
            Instrument -> Lookup[mapThreadFriendlyOptionsToMixFilterPrecipitation, PrecipitationMixInstrument],
            MixRate -> Lookup[mapThreadFriendlyOptionsToMixFilterPrecipitation, PrecipitationMixRate],
            Temperature -> Lookup[mapThreadFriendlyOptionsToMixFilterPrecipitation, PrecipitationMixTemperature],
            Time -> Lookup[mapThreadFriendlyOptionsToMixFilterPrecipitation, PrecipitationMixTime],
            NumberOfMixes -> Lookup[mapThreadFriendlyOptionsToMixFilterPrecipitation, NumberOfPrecipitationMixes],
            MixVolume -> Lookup[mapThreadFriendlyOptionsToMixFilterPrecipitation, PrecipitationMixVolume],
            Preparation -> Robotic,
            WorkCell -> Lookup[myResolvedOptions, WorkCell]
          ],
          Nothing
        ],
        If[MemberQ[Lookup[mapThreadFriendlyOptionsToFilter, PrecipitationTime], GreaterP[0 Minute]],
          Incubate[
            Sample -> PickList[mySamples, Transpose[{Lookup[myResolvedOptions, SeparationTechnique], Lookup[myResolvedOptions, PrecipitationTime]}], {Filter, GreaterP[0 Minute]}],
            Instrument -> PickList[Lookup[mapThreadFriendlyOptionsToFilter, PrecipitationInstrument], Lookup[mapThreadFriendlyOptionsToFilter, PrecipitationTime], GreaterP[0 Minute]],
            Temperature -> PickList[Lookup[mapThreadFriendlyOptionsToFilter, PrecipitationTemperature], Lookup[mapThreadFriendlyOptionsToFilter, PrecipitationTime], GreaterP[0 Minute]] /. Ambient -> 25 Celsius,
            Time -> PickList[Lookup[mapThreadFriendlyOptionsToFilter, PrecipitationTime], Lookup[mapThreadFriendlyOptionsToFilter, PrecipitationTime], GreaterP[0 Minute]],
            Preparation -> Robotic,
            WorkCell -> Lookup[myResolvedOptions, WorkCell]
          ],
          Nothing
        ],
        Filter[
          Sample -> PickList[mySamples, Lookup[myResolvedOptions, SeparationTechnique], Filter],
          FiltrateLabel -> Lookup[mapThreadFriendlyOptionsToFilter, UnprecipitatedSampleLabel] /. Null -> Automatic, (* Filter doesn't accept Null in the input Pattern for this *)
          FiltrateContainerLabel -> Lookup[mapThreadFriendlyOptionsToFilter, UnprecipitatedSampleContainerLabel] /. Null -> Automatic, (* Filter doesn't accept Null in the input Pattern for this *)
          RetentateLabel -> Lookup[mapThreadFriendlyOptionsToFilter, PrecipitatedSampleLabel],
          RetentateContainerLabel -> Lookup[mapThreadFriendlyOptionsToFilter, PrecipitatedSampleContainerLabel],
          FiltrationType -> Lookup[mapThreadFriendlyOptionsToFilter, FiltrationTechnique],
          Time -> Lookup[mapThreadFriendlyOptionsToFilter, FiltrationTime],
          Instrument -> Lookup[mapThreadFriendlyOptionsToFilter, FiltrationInstrument],
          Sterile -> Lookup[myResolvedOptions, Sterile],
          Pressure -> Lookup[mapThreadFriendlyOptionsToFilter, FiltrationPressure],
          Intensity -> Lookup[mapThreadFriendlyOptionsToFilter, FilterCentrifugeIntensity],
          Target -> Lookup[mapThreadFriendlyOptionsToFilter, TargetPhase] /. {Solid -> Retentate, Liquid -> Filtrate}, (* Filter's Target needs to be changed from Solid/Liquid to Retentate/Filtrate respectively *)
          FiltrateContainerOut -> Map[
            If[MatchQ[#, Null], Null, #[[2]]]&,
            Lookup[mapThreadFriendlyOptionsToFilter, FullUnprecipitatedSampleContainerOut]
          ],
          FiltrateDestinationWell -> Map[
            If[MatchQ[#, Null], Null, #[[1]]]&,
            Lookup[mapThreadFriendlyOptionsToFilter, FullUnprecipitatedSampleContainerOut]
          ],
          Filter -> Lookup[mapThreadFriendlyOptionsToFilter, Filter],
          FilterPosition -> Lookup[mapThreadFriendlyOptionsToFilter, FilterPosition],
          MembraneMaterial -> Lookup[mapThreadFriendlyOptionsToFilter, MembraneMaterial],
          PrefilterMembraneMaterial -> Lookup[mapThreadFriendlyOptionsToFilter, PrefilterMembraneMaterial],
          PoreSize -> Lookup[mapThreadFriendlyOptionsToFilter, PoreSize],
          PrefilterPoreSize -> Lookup[mapThreadFriendlyOptionsToFilter, PrefilterPoreSize],
          FilterStorageCondition -> Lookup[mapThreadFriendlyOptionsToFilter, FilterStorageCondition],
          RetentateContainerOut -> Map[
            If[MatchQ[#, ListableP[Null]], Null, #[[2]]]&,
            Lookup[mapThreadFriendlyOptionsToFilter, FullPrecipitatedSampleContainerOut]
          ],
          RetentateDestinationWell -> Map[
            If[MatchQ[#, ListableP[Null]], Null, #[[1]]]&,
            Lookup[mapThreadFriendlyOptionsToFilter, FullPrecipitatedSampleContainerOut]
          ],
          ResuspensionVolume -> Lookup[mapThreadFriendlyOptionsToFilter, ResuspensionBufferVolume],
          ResuspensionBuffer -> Lookup[mapThreadFriendlyOptionsToFilter, ResuspensionBuffer] /. None -> Null, (* Filter doesn't accept None in the input Pattern for this *)
          NumberOfResuspensionMixes -> Lookup[mapThreadFriendlyOptionsToFilter, NumberOfResuspensionMixes],
          (* I want this to be Automatic if we are not doing wash steps *)
          WashRetentate -> Lookup[mapThreadFriendlyOptionsToFilter, NumberOfWashes] /. {GreaterP[0] -> True, (EqualP[0] | Null) -> False}, (* Filter requires these inputs, not a number *)
          RetentateWashBuffer -> Lookup[mapThreadFriendlyOptionsToFilter, WashSolution] /. None -> Null, (* Filter doesn't accept None in the input Pattern for this *)
          RetentateWashVolume -> Lookup[mapThreadFriendlyOptionsToFilter, WashSolutionVolume],
          WashFlowThroughContainer -> filterWashContainer, (* TODO, this may be an issue if we ever have non-96 well filters... *)
          NumberOfRetentateWashes -> Lookup[mapThreadFriendlyOptionsToFilter, NumberOfWashes] /. 0 -> Null, (* Filter throws an error if 0 is given as an input *)
          RetentateWashDrainTime -> Lookup[mapThreadFriendlyOptionsToFilter, WashSeparationTime],
          RetentateWashCentrifugeIntensity -> Lookup[mapThreadFriendlyOptionsToFilter, WashCentrifugeIntensity],
          (* I want this to be Automatic if we are not resuspending retentate *)
          RetentateCollectionMethod -> Lookup[mapThreadFriendlyOptionsToFilter, ResuspensionBuffer] /. {ObjectP[] -> Resuspend, None -> Null}, (* Filter requires these inputs, not a number *)
          RetentateWashMix -> Lookup[mapThreadFriendlyOptionsToFilter, NumberOfWashes] /. {GreaterP[0] -> True, (EqualP[0] | Null) -> False}, (* Filter requires these inputs, not a number *)
          RetentateWashPressure -> Lookup[mapThreadFriendlyOptionsToFilter, WashPressure],
          CollectRetentate -> Lookup[mapThreadFriendlyOptionsToFilter, ResuspensionBuffer] /. {ObjectP[] -> True, None -> False, Null -> False},
          Preparation -> Robotic,
          WorkCell -> Lookup[myResolvedOptions, WorkCell]
        ]
      },
      Nothing
    ];

    (* Combine to together *)
    primitives = Flatten[{
      labelSamplesUnitOperations,
      transferToPrecipitatedSamplesContainerOutUnitOperations,
      pelletPrecipitatedSamplesUnitOperations,
      pelletWashSamplesUnitOperations,
      drySamplesUnitOperations,
      resuspendSamplesUnitOperations,
      resuspendMixSamplesUnitOperations,
      filterSamplesUnitOperations
    }];

    (* Set this internal variable to unit test the unit operations that are created by this function. *)
    $PrecipitateUnitOperations = primitives;

    experimentFunction = Lookup[Experiment`Private`$WorkCellToExperimentFunction, Lookup[myResolvedOptions, WorkCell]];

    (* Get our robotic unit operation packets. *)
    {{roboticUnitOperationPackets, roboticRunTime}, roboticSimulation} =
        experimentFunction[
          primitives,
          UnitOperationPackets -> True,
          Output -> {Result, Simulation},
          FastTrack -> Lookup[expandedResolvedOptions, FastTrack],
          ParentProtocol -> Lookup[expandedResolvedOptions, ParentProtocol],
          Name -> Lookup[expandedResolvedOptions, Name],
          Simulation -> currentSimulation,
          Upload -> False,
          ImageSample -> Lookup[expandedResolvedOptions, ImageSample],
          MeasureVolume -> Lookup[expandedResolvedOptions, MeasureVolume],
          MeasureWeight -> Lookup[expandedResolvedOptions, MeasureWeight],
          Priority -> Lookup[expandedResolvedOptions, Priority],
          StartDate -> Lookup[expandedResolvedOptions, StartDate],
          HoldOrder -> Lookup[expandedResolvedOptions, HoldOrder],
          QueuePosition -> Lookup[expandedResolvedOptions, QueuePosition],
          CoverAtEnd -> False
        ];

    (* Create our own output unit operation packet, linking up the "sub" robotic unit operation objects. *)
    outputUnitOperationPacket = UploadUnitOperation[
      Module[{nonHiddenOptions},
        (* Only include non-hidden options from Precipitate. *)
        nonHiddenOptions = allowedKeysForUnitOperationType[Object[UnitOperation, Precipitate]];

        (* Override any options with resource. *)
        Precipitate@Join[
          Cases[Normal[myResolvedOptions], Verbatim[Rule][Alternatives @@ nonHiddenOptions, _]],
          {
            Sample -> samplesInResources,
            RoboticUnitOperations -> If[Length[roboticUnitOperationPackets] == 0,
              {},
              (Link /@ Lookup[roboticUnitOperationPackets, Object])
            ]
          }
        ]
      ],
      UnitOperationType -> Output,
      Upload -> False
    ];

    (* Simulate the resources for our main UO since it's now the only thing that doesn't have resources. *)
    (* NOTE: Should probably use SimulateResources[...] here but this is quicker. *)
    roboticSimulation = UpdateSimulation[
      roboticSimulation,
      Simulation[<|Object -> Lookup[outputUnitOperationPacket, Object], Sample -> (Link /@ mySamples)|>]
    ];

    (* since we are putting this UO inside RSP, we should re-do the LabelFields so they link via RoboticUnitOperations *)
    roboticSimulation=If[Length[roboticUnitOperationPackets]==0,
      roboticSimulation,
      updateLabelFieldReferences[roboticSimulation,RoboticUnitOperations]
    ];

    (* Return back our packets and simulation. *)
    {
      Null,
      Flatten[{outputUnitOperationPacket, roboticUnitOperationPackets}],
      roboticSimulation,
      (roboticRunTime + (10 Minute))
    }
  ];

  (* make list of all the resources we need to check in FRQ *)
  allResourceBlobs = If[MatchQ[resolvedPreparation, Manual],
    DeleteDuplicates[Cases[Flatten[Values[protocolPacket]], _Resource, Infinity]],
    {}
  ];

  (* Verify we can satisfy all our resources *)
  {resourcesOk, resourceTests} = Which[
    (* NOTE: If we're robotic, the framework will call FRQ for us. *)
    MatchQ[$ECLApplication, Engine] || MatchQ[resolvedPreparation, Robotic],
      {True, {}},
    gatherTests,
      Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack], Cache -> inheritedCache, Simulation -> currentSimulation],
    True,
      {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack], Messages -> messages, Cache -> inheritedCache, Simulation -> currentSimulation], Null}
  ];

  (* --- Output --- *)
  (* Generate the Preview output rule *)
  previewRule = Preview -> Null;

  (* Generate the options output rule *)
  optionsRule = Options -> If[MemberQ[output, Options],
    resolvedOptionsNoHidden,
    Null
  ];

  (* Generate the tests rule *)
  testsRule = Tests -> If[gatherTests,
    resourceTests,
    {}
  ];

  (* generate the Result output rule *)
  (* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
  resultRule = Result -> If[MemberQ[output, Result] && TrueQ[resourcesOk],
    {Flatten[{protocolPacket, allUnitOperationPackets}], currentSimulation, runTime},
    $Failed
  ];

  (* Return the output as we desire it *)
  outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}
];



