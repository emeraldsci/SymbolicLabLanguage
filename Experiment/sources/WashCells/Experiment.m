(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentWashCells Options and Messages*)


DefineOptions[ExperimentWashCells,
  Options :> {

    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      {
        OptionName -> Method,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Alternatives[
          "Custom" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[Custom],
            PatternTooltip -> "Custom indicates that all reagents and conditions are individually selected by the user. Otherwise, select a method object describing cell wash."
          ],
          "Method Object" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Object[Method, WashCells]],
            PatternTooltip -> "A method object describing cell wash.",
            OpenPaths -> {
              {Object[Catalog, "Root"], "Materials", "Cell Culture"}
            }
          ]
        ],
        Description -> "The default operating conditions which are used to dissociate cells.",
        ResolutionDescription -> "Automatically set to the object specified in Model[Cell][WashMethod], if any. Automatically set to Custom if no method object is specified for Model[Cell].",
        Category -> "General"

      },
      {
        OptionName -> CellType,
        Default -> Automatic,
        AllowNull -> False,
        Widget ->
            Widget[
              Type -> Enumeration,
              Pattern :> CellTypeP
            ],
        Description -> "The taxon of the organism or cell line from which the cell sample originates. Options include Bacterial, Mammalian, Insect, Plant, and Yeast.",
        ResolutionDescription -> "Automatically set to the CellType specified in Object[Sample] for the input cell sample.",
        Category -> "General"
      },

      {
        OptionName -> CultureAdhesion,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> Alternatives[Suspension, Adherent]
        ],
        Description -> "Indicates how the cell sample physically interacts with its container prior to washing cells/changing media. Options include Adherent and Suspension (including any microbial liquid media).",
        ResolutionDescription -> "Automatically set to the CultureAdhesion specified in Object[Sample].",
        Category -> "General"
      },
      {
        OptionName -> CellIsolationTechnique,
        Default -> Automatic,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> CellIsolationTechniqueP (* CellIsolationTechniqueP:Pellet | Aspirate *)
        ],
        Description -> "The technique used to remove impurities, debris, and media from cell samples prior to washing cells or changing media. Suspension cells are centrifuged to separate the cells from the media or buffer. Adherent cells remain attached to the bottom of the culture plate whereas the media can be removed via aspiration.",
        ResolutionDescription -> "If CultureAdhesion is Adherent, then set to Aspirate. If CultureAdhesion is set to Suspension and any of the Pellet Options not Null, automatically set to Pellet.",
        AllowNull -> False,
        Category -> "General"
      },
      {
        OptionName -> CellIsolationInstrument,
        Default -> Automatic,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Model[Instrument, Centrifuge],
            Object[Instrument, Centrifuge]}],
          OpenPaths -> {
            {Object[Catalog, "Root"], "Instruments", "Centrifugation", "Centrifuges"}
          }
        ],
        Description -> "The instrument used to isolate the cell sample prior to washing cells or changing media. Centrifuging separates cells from media, forming a cell pellet. The supernatant is removed or harvested, leaving the cell pellet in the container.",
        ResolutionDescription -> "Automatically set to robotic integrated centrifuge, Model[Instrument, Centrifuge, \"HiG4\"] if CellIsolationTechnique is set to Pellet.",
        AllowNull -> True,
        Category -> "General"
      },
      {
        OptionName -> CellAspirationVolume,
        Default -> Automatic,
        Widget -> Alternatives[
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
            Units :> {1, {Milliliter, {Microliter, Milliliter, Liter}}}
          ],
          Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[All]
          ]
        ],
        Description -> "Indicates how much media to remove from an input sample of cells prior to washing cell or changing media when isolating with Aspriate or Pellet.",
        ResolutionDescription -> "Automatically set to aspirate off the majority of the sample volume, leaving the smaller of 5% of the container's capacity or 100 Microliter.",
        AllowNull -> False,
        Category -> "Media Aspiration"
      },
      {
        OptionName -> CellIsolationTime,
        Default -> Automatic,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> Alternatives[Second, Minute, Hour]
        ],
        Description -> "The amount of time to centrifuge the cell samples prior to washing cells or changing media. Centrifuging is intended to separate cells from media.",
        ResolutionDescription -> "Automatically set to 5 min if CellIsolationTechnique is set to Pellet.",
        AllowNull -> True,
        Category -> "Media Aspiration"
      },
      (* Pellet Options *)
      {
        OptionName -> CellPelletContainer,
        Default -> Automatic,
        Description -> "The container to hold the cell samples in centrifugation prior to washing cells or changing media.",
        ResolutionDescription -> "Automatically set to the deep-well plate whose WorkingVolume is larger than the sample volume if CellIsolationTechnique is set to Pellet.", (*Table for choosing container based on sample volume*)
        AllowNull -> True,
        Widget -> Alternatives[
          "Container" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[{Object[Container], Model[Container]}],
            OpenPaths -> {
              {Object[Catalog, "Root"], "Containers", "Plates"}
            }
          ],
          "Container with Index" -> {
            "Index" -> Widget[
              Type -> Number,
              Pattern :> GreaterEqualP[1, 1]
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Container], Model[Container]}],
              OpenPaths -> {
                {Object[Catalog, "Root"], "Containers", "Plates"}
              },
              PreparedSample -> False,
              PreparedContainer -> False
            ]
          },
          "Container with Well" -> {
            "Well" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
              PatternTooltip -> "Enumeration must be any well from A1 to P24."
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Container], Model[Container]}],
              OpenPaths -> {
                {Object[Catalog, "Root"], "Containers", "Plates"}
              },
              PreparedSample -> False,
              PreparedContainer -> False
            ]
          },
          "Container with Well and Index" -> {
            "Well" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
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
                OpenPaths -> {
                  {Object[Catalog, "Root"], "Containers", "Plates"}
                },
                PreparedSample -> False,
                PreparedContainer -> False
              ]
            }
          }
        ],
        Category -> "Media Aspiration"
      },
      {
        OptionName -> CellPelletContainerWell,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
          PatternTooltip -> "Enumeration must be any well from A1 to P24."
        ],
        Description -> "The well of the container into which the cell sample is transfered into for centrifugation in cell wash experiment or change media experiment.",
        ResolutionDescription -> "Automatically set to the first empty well in CellPelletContainer.",
        Category -> "Hidden"
      },
      {
        OptionName -> CellPelletIntensity,
        Default -> Automatic,
        Widget -> Alternatives[
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 RPM, $MaxRoboticCentrifugeSpeed],
            Units -> Alternatives[RPM]
          ],
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 GravitationalAcceleration, $MaxRoboticRelativeCentrifugalForce],
            Units -> Alternatives[GravitationalAcceleration]
          ]
        ],
        Description -> "The rotational speed or force applied to the cell sample by centrifugation prior to washing cells or changing media. Centrifuging is intended to separate cells from media, forming a cell pellet.",
        ResolutionDescription -> "If CellIsolationTechnique is set to Pellet, automatically set to " <> ToString[$LivingMammalianCentrifugeIntensity] <> " if CellType is Mammalian, " <> ToString[$LivingBacterialCentrifugeIntensity] <> " if CellType is Bacterial, " <> ToString[$LivingYeastCentrifugeIntensity] <> " if CellType is Yeast.",
        AllowNull -> True,
        Category -> "Media Aspiration"
      },
      (* Aspirate Options *)
      {
        OptionName -> CellAspirationAngle,
        Default -> Automatic,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 AngularDegree, $MaxRoboticAspirationAngle],
          Units -> Alternatives[AngularDegree]
        ],
        Description -> "Indicates the tilting angle of the adherent cell culture plate when aspirating off the input sample media. See figure XXX.", (*show a figure*)
        ResolutionDescription -> "Automatically set 10 AngularDegree if CellIsolationTechnique is Aspirate.",
        AllowNull -> True,
        Category -> "Media Aspiration"
      },

      (* Collect used media *)
      {
        OptionName -> AliquotSourceMedia,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
        Description -> "Indicates if sample of source media is collected for future analysis prior to washing.",
        ResolutionDescription -> "Automatically set to True if any source media options (AliquotMediaVolume, AliquotMediaContainer,...) are not Null.",
        Category -> "Media Aspiration"
      },
      {
        OptionName -> AliquotMediaVolume,
        Default -> Automatic,
        Widget -> Alternatives[
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
            Units :> {1, {Milliliter, {Microliter, Milliliter, Liter}}}
          ],
          Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[All]
          ]
        ],
        Description -> "The amount of media to collect for analysis after pelleting the cells prior to washing.",
        ResolutionDescription -> "Automatically set to the same as CellAspirationVolume if AliquotSourceMedia is True.",
        AllowNull -> True,
        Category -> "Media Aspiration"
      },
      {
        OptionName -> AliquotMediaContainer,
        Default -> Automatic,
        Description -> "The container used to collect the source media from Media Removal prior to washing.",
        ResolutionDescription -> "Automatically set to the same container as the input sample if AliquotSourceMedia is True. ",
        AllowNull -> True,
        Widget -> Alternatives[
          "Container" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[{Object[Container], Model[Container]}],
            OpenPaths -> {
              {Object[Catalog, "Root"], "Containers"}
            }
          ],
          "Container with Index" -> {
            "Index" -> Widget[
              Type -> Number,
              Pattern :> GreaterEqualP[1, 1]
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Container], Model[Container]}],
              OpenPaths -> {
                {Object[Catalog, "Root"], "Containers"}
              },
              PreparedSample -> False,
              PreparedContainer -> False
            ]
          },
          "Container with Well" -> {
            "Well" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
              PatternTooltip -> "Enumeration must be any well from A1 to P24."
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Container], Model[Container]}],
              OpenPaths -> {
                {Object[Catalog, "Root"], "Containers", "Plates"}
              },
              PreparedSample -> False,
              PreparedContainer -> False
            ]
          },
          "Container with Well and Index" -> {
            "Well" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
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
                OpenPaths -> {
                  {Object[Catalog, "Root"], "Containers", "Plates"}
                },
                PreparedSample -> False,
                PreparedContainer -> False
              ]
            }
          }
        ],
        Category -> "Media Aspiration"
      },
      {
        OptionName -> AliquotMediaContainerWell,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
          PatternTooltip -> "Enumeration must be any well from A1 to P24."
        ],
        Description -> "The well of the container into which the source media from Media Removal in transfered prior to washing.",
        ResolutionDescription -> "Automatically set to the first empty well in AliquotMediaContainer.",
        Category -> "Hidden"
      },
      {
        OptionName -> AliquotMediaContainerLabel,
        Default -> Automatic,
        Description -> "A user defined word or phrase used to identify the SourceMediaContainer that contains the source media separated from cell samples, for use in future analysis.",
        ResolutionDescription -> "Automatically set to \"source media from cell sample container #\" if AliquotSourceMedia is True.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Word
        ],
        Category -> "Media Aspiration"
      },
      {
        OptionName -> AliquotMediaStorageCondition,
        Default -> Automatic,
        Description -> "Indicates the conditions under which separated source media are saved after cell isolation.",
        ResolutionDescription -> "Automatically set to freezer if AliquotSourceMedia is True.",
        AllowNull -> True,
        Widget -> Alternatives[
          "Storage Type" -> Widget[Type -> Enumeration, Pattern :> SampleStorageTypeP | Disposal],
          "Storage Object" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[{Model[StorageCondition]}],
            OpenPaths -> {{Object[Catalog, "Root"], "Storage Conditions"}}
          ]
        ],
        Category -> "Media Aspiration"
      },
      {
        OptionName -> AliquotMediaLabel,
        Default -> Automatic,
        Description -> "A user defined word or phrase used to identify the saved cells sample that is being isolated from media, for use in downstream unit operations.",
        ResolutionDescription -> "Automatically set to \"source media from cell sample #\" if AliquotSourceMedia is True.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Word
        ],
        Category -> "Media Aspiration"
      },
      (* Wash Solution Addition *)
      {
        OptionName -> NumberOfWashes,
        Default -> Automatic,
        Widget -> Widget[
          Type -> Number,
          Pattern :> RangeP[0, $MaxNumberOfWashes, 1]
        ],
        Description -> "The number of times the sample is washed with WashSolution, prior to replenishment with fresh media, in order to wash trace amounts of media and metabolites from the cells.",
        ResolutionDescription -> "Automatically set to 3 if CultureAdhesion is set to Adherent. Otherwise, set to 2.",
        AllowNull -> False,
        Category -> "Washing"
      },
      {
        OptionName -> WashSolution,
        Default -> Automatic,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
          OpenPaths -> {{Object[Catalog, "Root"], "Materials", "Reagents", "Buffers", "Biological Buffers"}}
        ],
        Description -> "The buffer used to wash the cell sample after removing media.",
        ResolutionDescription -> "Automatically set to Model[Sample,\"1x PBS (Phosphate Buffer Saline), Autoclaved\"].",
        AllowNull -> True,
        Category -> "Washing"
      },
      {
        OptionName -> WashSolutionTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Temperature" -> Widget[Type -> Quantity, Pattern :> RangeP[$MinRoboticIncubationTemperature, $MaxRoboticIncubationTemperature], Units :> Alternatives[Celsius, Fahrenheit]],
          "Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        Description -> "The temperature of the wash solution in cell wash experiment.",
        ResolutionDescription -> "If NumberOfWashes is not 0, automatically set to Ambient.",
        Category -> "Washing"
      },
      {
        OptionName -> WashSolutionEquilibrationTime,
        Default -> Automatic,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> Alternatives[Second, Minute, Hour]
        ],
        Description -> "The WashSolution will be incubated for a minimum duration of this time at WashSolutionTemperature prior to washing the live cell sample.",
        ResolutionDescription -> "Automatically set to 10 Minute if WashSolutionTemperature is not Null.",
        AllowNull -> True,
        Category -> "Washing"
      },
      {
        OptionName -> WashVolume,
        Default -> Automatic,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Milliliter, $MaxRoboticTransferVolume],
          Units -> {1, {Milliliter, {Microliter, Milliliter, Liter}}}
        ],
        Description -> "The amount of WashSolution used for washing the cells.",
        ResolutionDescription -> "Automatically set to be the same as CellAspirationVolume.",
        AllowNull -> True,
        Category -> "Washing"
      },
      {
        OptionName -> WashMixType,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> RoboticMixTypeP | None
        ],
        Description -> "Indicates the style of motion (Shake or Pipette) used to mix the cell sample with WashSolution.",
        ResolutionDescription -> "Automatically set to Shake if any of shake options (WashMixRate, WashMixTime, WashMixInstrument) are set. Otherwise, set to Pipette if any of the pipette options (NumberOfWashMix, WashMixVolume) are set.",
        Category -> "Washing"
      },
      (* Shake Options*)
      {
        OptionName -> WashMixInstrument,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Model[Instrument, Shaker], Object[Instrument, Shaker]}],
          OpenPaths :> {{Object[Catalog, "Root"], "Instruments", "Mixing Devices"}}
        ],
        Description -> "The instrument used to mix the cell sample with WashSolution via Shake.",
        ResolutionDescription -> "Automatically set to Model[Instrument, Shaker,\"Inheco ThermoshakeAC\"] if the WashMixType is set to Shake.",
        Category -> "Washing"
      },
      {
        OptionName -> WashMixTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> Alternatives[Second, Minute, Hour]
        ],
        Description -> "Duration of time to mix the cell sample with WashSolution via Shake.",
        ResolutionDescription -> "Automatically set to 1 Minute if WashMixType is set to Shake.",
        Category -> "Washing"
      },
      {
        OptionName -> WashMixRate,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[$MinBioSTARMixRate, $MaxBioSTARMixRate],
          Units -> RPM
        ],
        Description -> "The rate at which the sample is mixed with WashSolution via the selected WashMixType for the duration specified by WashMixTime.",
        ResolutionDescription -> "Automatically set to 200 RPM if WashMixType is set to Shake.",
        Category -> "Washing"
      },
      (* Pipette Options *)
      {
        OptionName -> WashMixVolume,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Microliter, $MaxRoboticSingleTransferVolume],
          Units :> Alternatives[Milliliter, Microliter, Liter]
        ],
        Description -> "The volume of the cell sample in WashSolution that is pipetted up and down to mix the live cell samples with WashSolution.",
        ResolutionDescription -> "If WashMixType is set to Pipette, automatically set to the smaller of half of the volume of the input sample or 970 Microliter, which is the largest volume that can be pipetted in a single step by the robotic liquid handler.",
        Category -> "Washing"
      },
      {
        OptionName -> NumberOfWashMixes,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Number,
          Pattern :> RangeP[1, $MaxNumberOfMixes, 1]
        ],
        Description -> "The number of pipetting cycles (drawing liquid up into the pipette and dispensing back down out of the pipette) used to mix the live cell samples with WashSolution.",
        ResolutionDescription -> "Automatically set to be the lesser of 50 or 5 * WashVolume/WashMixVolume if WashMixType is set to Pipette.",
        Category -> "Washing"
      },
      {
        OptionName -> WashTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Temperature" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[$MinRoboticIncubationTemperature, $MaxRoboticIncubationTemperature],
            Units :> Alternatives[Celsius, Fahrenheit]
          ],
          "Ambient" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[Ambient]
          ]
        ],
        Description -> "The temperature of the device that is used to mix the live cells in WashSolution.",
        ResolutionDescription -> "Automatically set to WashSolutionTemperature selection if WashMix is True.",
        Category -> "Washing"
      },

      {
        OptionName -> WashAspirationVolume,
        Default -> Automatic,
        Widget -> Alternatives[
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 Microliter, $MaxRoboticTransferVolume],
            Units :> {1, {Milliliter, {Microliter, Milliliter, Liter}}}
          ],
          Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[All]
          ]
        ],
        Description -> "Indicates how much wash solution to remove from an input sample of cells prior to media replenishment when isolating with Aspriate or Pellet.",
        ResolutionDescription -> "Automatically set to be the same as WashVolume.",
        AllowNull -> True,
        Category -> "Washing"
      },
      {
        OptionName -> WashIsolationTime,
        Default -> Automatic,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> Alternatives[Second, Minute, Hour]
        ],
        Description -> "The amount of time to pellet the cell samples prior to changing media. Centrifuging is intended to separate cells from media.",
        ResolutionDescription -> "Automatically set the same as CellIsolationTime selection if CellIsolationTechnique is set to Pellet.",
        AllowNull -> True,
        Category -> "Washing"
      },
      {
        OptionName -> WashPelletIntensity,
        Default -> Automatic,
        Widget -> Alternatives[
          "Speed" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 RPM, $MaxRoboticCentrifugeSpeed],
            Units -> Alternatives[RPM]
          ],
          "Force" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 GravitationalAcceleration, $MaxRoboticRelativeCentrifugalForce],
            Units -> Alternatives[GravitationalAcceleration]
          ]
        ],
        Description -> "The rotational speed or force applied to the cell sample by centrifugation prior to changing media. Centrifuging is intended to separate cells from media, forming a cell pellet.",
        ResolutionDescription -> "Automatically set to the same as CellPelletIntensity selection if CellIsolationTechnique is Pellet.",
        AllowNull -> True,
        Category -> "Washing"
      },
      {
        OptionName -> WashAspirationAngle,
        Default -> Automatic,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 AngularDegree, $MaxRoboticAspirationAngle],
          Units -> Alternatives[AngularDegree]
        ],
        Description -> "Indicates the tilting angle of the adherent cell culture plate to aspirate off the wash buffer. The tilt causes the liquid to pool on one edge of the container, thereby making it easier to aspirate off the liquid.",
        ResolutionDescription -> "Automatically set to the CellAspirationAngle selection if CellIsolationTechnique is Aspirate.",
        AllowNull -> True,
        Category -> "Washing"
      },
      {
        OptionName -> ResuspensionMedia,
        Default -> Automatic,
        Widget -> Alternatives[
          Widget[
            Type -> Object,
            Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
            OpenPaths -> {
              {Object[Catalog, "Root"], "Materials", "Reagents"}
            }
          ],
          Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[None]
          ]
        ],
        Description -> "The media used to resuspend the cell pellet after washing with WashSolution.",
        ResolutionDescription -> "Automatically set to the PreferredLiquidMedia of the cell model. Otherwise, set to the same media as the input sample object.",
        AllowNull -> False, (* Careful: We decided to make it None when no media replenishment *)
        Category -> "Media Replenishment"
      },
      {
        OptionName -> ResuspensionMediaTemperature,
        Default -> Automatic,
        Widget -> Alternatives[
          "Temperature" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[$MinRoboticIncubationTemperature, $MaxRoboticIncubationTemperature],
            Units :> Alternatives[Celsius, Fahrenheit]
          ],
          "Ambient" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[Ambient]
          ]
        ],
        Description -> "The temperature of the media used to resuspend the cell sample.",
        ResolutionDescription -> "Automatically set to Ambient if ResuspensionMedia is not None.",
        AllowNull -> True,
        Category -> "Media Replenishment"
      },
      {
        OptionName -> ResuspensionMediaEquilibrationTime,
        Default -> Automatic,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> Alternatives[Second, Minute, Hour]
        ],
        Description -> "Indicates the ResuspensionMedia is incubated at ResuspensionMediaTemperature for at least this amount of time prior to resuspending the cell sample.",
        ResolutionDescription -> "Automatically set to 10 Minute if ResuspenionMedia is not None.",
        AllowNull -> True,
        Category -> "Media Replenishment"
      },
      {
        OptionName -> ResuspensionMediaVolume,
        Default -> Automatic,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Milliliter, $MaxRoboticTransferVolume],
          Units -> {1, {Milliliter, {Microliter, Milliliter, Liter}}}
        ],
        Description -> "The amount of ResuspensionMedia added to the cell sample for media replenishment.",
        ResolutionDescription -> "Automatically set to WorkingVolume of the container object. Otherwise set to 80% of the container's capacity.",
        AllowNull -> True,
        Category -> "Media Replenishment"
      },
      {
        OptionName -> ResuspensionMixType,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> RoboticMixTypeP | None
        ],
        Description -> "Indicates the style of motion (Shake or Pipette) used to resuspend the cell sample with ResuspensionMedia. If ResuspensionMixType is set to None, the cells will not be mixed with the ResuspensionMedia.",
        ResolutionDescription -> "Automatically set to Shake if any of ResuspensionMixRate, ResuspensionMixTime, ResuspensionMixInstrument are set. Otherwise, set to Pipette.",
        Category -> "Media Replenishment"

      },
      {
        OptionName -> ResuspensionTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Temperature" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[$MinRoboticIncubationTemperature, $MaxRoboticIncubationTemperature],
            Units :> Alternatives[Celsius, Fahrenheit]
          ],
          "Ambient" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[Ambient]
          ]
        ],
        Description -> "The temperature of the device that is used to resuspend the cells in ResuspensionMedia.",
        ResolutionDescription -> "Automatically set to ResuspensionMediaTemperature selection.",
        Category -> "Media Replenishment"
      },
      {
        OptionName -> ResuspensionMixInstrument,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Model[Instrument, Shaker], Object[Instrument, Shaker]}],
          OpenPaths :> {{Object[Catalog, "Root"], "Instruments", "Mixing Devices"}}
        ],
        Description -> "The instrument used to resuspend the cell sample with ResuspensionMedia.",
        ResolutionDescription -> "Automatically set to Model[Instrument, Shaker,\"Inheco ThermoshakeAC\"] if ResuspensionMixType is Shake.",
        Category -> "Media Replenishment"
      },
      {
        OptionName -> ResuspensionMixTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> Alternatives[Second, Minute, Hour]
        ],
        Description -> "Duration of time to mix the cell sample with ResuspensionMedia.",
        ResolutionDescription -> "Automatically set to 1 Minute if ResuspensionMixType is set to Shake.",
        Category -> "Media Replenishment"
      },
      {
        OptionName -> ResuspensionMixRate,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[$MinBioSTARMixRate, $MaxBioSTARMixRate], (*BioStar: 100 RPM -2000RPM*)
          Units -> RPM
        ],
        Description -> "The shaking rate to mix cell sample with the ResuspensionMedia over the ResuspensionMediaMixTime.",
        ResolutionDescription -> "Automatically set to 200 RPM if ResuspensionMixType is set to Shake. Automatically set to 20 RPM if ResuspensionMixType is set to 20 RPM.",
        Category -> "Media Replenishment"
      },
      {
        OptionName -> ResuspensionMixVolume,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Microliter, $MaxRoboticSingleTransferVolume],
          Units :> Alternatives[Milliliter, Microliter, Liter]
        ],
        Description -> "The volume of the sample that is pipetted up and down to resuspend the cell sample in ResuspensionMedia.",
        ResolutionDescription -> "If ResuspensionMixType is set to Pipette, automatically set to the smaller of half of the volume of the input sample or 970 Microliter, which is the largest volume that can be pipetted in a single step by the robotic liquid handler.",
        Category -> "Media Replenishment"
      },
      {
        OptionName -> NumberOfResuspensionMixes,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Number,
          Pattern :> RangeP[1, $MaxNumberOfMixes, 1]
        ],
        Description -> "The number of pipetting cycles (drawing liquid up into the pipette and dispensing back down out of the pipette) used to resuspend the cell sample in ResuspensionMedia.",
        ResolutionDescription -> "Automatically set to be the lesser of 50 or 5 * ResuspensionMediaVolume/ResuspensionMixVolume if ResuspensionMixType is set to Pipette.",
        Category -> "Media Replenishment"
      },
      {
        OptionName -> ReplateCells,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> BooleanP
        ],
        Description -> "Indicates whether the sample is transferred into new container.",
        ResolutionDescription -> "Automatically set to True if ContainerOut is not Null.",
        Category -> "Media Replenishment"
      },
      {
        OptionName -> ContainerOut,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Container" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[{Object[Container], Model[Container]}],
            OpenPaths -> {
              {Object[Catalog, "Root"], "Containers"}
            }
          ],
          "Container with Index" -> {
            "Index" -> Widget[
              Type -> Number,
              Pattern :> GreaterEqualP[1, 1]
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Container], Model[Container]}],
              OpenPaths -> {
                {Object[Catalog, "Root"], "Containers"}
              },
              PreparedSample -> False,
              PreparedContainer -> False
            ]
          },
          "Container with Well" -> {
            "Well" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
              PatternTooltip -> "Enumeration must be any well from A1 to P24."
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Container], Model[Container]}],
              OpenPaths -> {
                {Object[Catalog, "Root"], "Containers"}
              },
              PreparedSample -> False,
              PreparedContainer -> False
            ]
          },
          "Container with Well and Index" -> {
            "Well" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
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
                OpenPaths -> {
                  {Object[Catalog, "Root"], "Containers"}
                },
                PreparedSample -> False,
                PreparedContainer -> False
              ]
            }
          }
        ],
        Description -> "The container into which the resuspended cell sample is transferred into after cell washing and media replenishment.",
        ResolutionDescription -> "Automatically set to the same plate as the input sample if ReplateCells is True.",
        Category -> "Media Replenishment"
      },
      {
        OptionName -> ContainerOutWell,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
          PatternTooltip -> "Enumeration must be any well from A1 to P24."
        ],
        Description -> "The well of the container into which the resuspended cell sample is transferred into after cell washing and media replenishment.",
        ResolutionDescription -> "Automatically set to the first empty well in ContainerOut.",
        Category -> "Hidden"
      },
      {
        OptionName -> ContainerOutLabel,
        Default -> Automatic,
        Description -> "A user defined word or phrase used to identify the ContainerOut that contains the replated cell samples.",
        ResolutionDescription -> "Automatically set to \"wash cell sample container #\" if ContainerOut is not Null.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Word
        ],
        Category -> "Media Replenishment"
      },
      {
        OptionName -> SampleOutLabel,
        Default -> Automatic,
        Description -> "A user defined word or phrase used to identify the SampleOut that contains the cell samples after WashCells or ChangeMedia.",
        ResolutionDescription -> "Automatically set to \"wash cell sample out #\".",
        AllowNull -> False,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Word
        ],
        Category -> "Media Replenishment"
      }
    ],
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
      ResolutionDescription -> "Automatically set to Model[Instrument, LiquidHandler, \"bioSTAR\"] if CellType is Mamalian. Otherwise, set to Model[Instrument, LiquidHandler, \"microbioSTAR\"].",
      Category -> "General"
    },

    (* --- Shared Options --- *)
    RoboticPreparationOption,
    (* RoboticInstrumentOption, *)
    ProtocolOptions,
    SimulationOption,
    PostProcessingOptions,
    SubprotocolDescriptionOption,
    SamplesInStorageOptions,
    SamplesOutStorageOptions,
    WorkCellOption
  }
];

DefineOptions[ExperimentChangeMedia,
  Options :> {ExperimentWashCells}
];

(* ::Subsection:: *)
(* Useful lists of options *)

$WashingOptions =
    {
      WashSolution, WashSolutionTemperature, WashSolutionEquilibrationTime, WashVolume, WashMixType, WashMixInstrument, WashMixTime, WashMixRate, NumberOfWashMixes, WashMixVolume, WashTemperature, WashAspirationVolume, WashIsolationTime, WashPelletIntensity, WashAspirationAngle
    };
$AliquotSourceMediaOptions =
    {
      AliquotMediaVolume, AliquotMediaContainer, AliquotMediaContainerLabel, AliquotMediaStorageCondition, AliquotMediaLabel
    };
$WashShakeOptions =
    {
      WashMixInstrument, WashMixTime, WashMixRate, WashTemperature
    };
$WashPipetteOptions =
    {
      NumberOfWashMixes, WashMixVolume
    };
$ResuspensionShakeOptions =
    {
      ResuspensionMixInstrument, ResuspensionMixTime, ResuspensionMixRate, ResuspensionTemperature
    };
$ResuspensionPipetteOptions =
    {
      NumberOfResuspensionMixes, ResuspensionMixVolume
    };
$WashCellsInstrumentOptions =
    {
      RoboticInstrument, CellIsolationInstrument, WashMixInstrument, ResuspensionMixInstrument
    };
$MediaReplenishmentOptions =
    {
      ResuspensionMediaTemperature, ResuspensionMediaEquilibrationTime, ResuspensionMediaVolume, ResuspensionMixType, ResuspensionTemperature, ResuspensionMixInstrument, ResuspensionMixTime, ResuspensionMixRate, NumberOfResuspensionMixes, ResuspensionMixVolume, ReplateCells
    };

(* Conflicting Options Check *)
Error::ExtraneousWashingOptions = "The sample(s) `1` at indices `5` have option(s) `2` set to `3`. This conflicts with the NumberOfWashes option, which is set to `4`. Please adjust these options to make them consistent with the NumberOfWashes option in order to submit a valid experiment.";
Error::ExtraneousMediaReplenishmentOptions = "The sample(s) `1` at indices `5` have option(s) `2` set to `3`. This conflicts with the ResuspensionMedia option, which is set to `4`. Please adjust these options to make them consistent with the ResuspensionMedia option in order to submit a valid experiment.";

Error::CellIsolationTechniqueConflictingOptions = "The sample(s) `1` at indices `7` have conflicting CellIsolationTechnique Options. CellIsolationTechnique is set to `2` but CellIsolationInstrument is set to `4`, CellIsolationTime is set to `5`, CellPelletIntensity is set to `6`, CellAspirationAngle is set to `3`. When CellIsolationTechnique is set to Pellet, CellAspirationAngle must be Null, CellIsolationInstrument, CellIsolationTime and CellPelletIntensity cannot be set to Null. When WashIsolationTechnique is set to Aspirate, CellAspirationAngle cannot be Null, CellIsolationInstrument, CellIsolationTime and CellPelletIntensity must be set to Null. Please fix these conflicting options to specify a valid experiment.";
Error::WashIsolationTechniqueConflictingOptions = "The sample(s) `1` at indices `6` have conflicting CellIsolationTechnique Options. CellIsolationTechnique is set to `2` but WashIsolationTime is set to `3`, WashPelletIntensity is set to `4`, WashAspirationAngle is set to `5`. When CellIsolationTechnique is set to Pellet and NumberOfWashes is not 0, WashAspirationAngle must be Null, WashIsolationTime and WashPelletIntensity cannot be set to Null. When CellIsolationTechnique is set to Aspirate and NumberOfWashes is not 0, WashAspirationAngle cannot be Null, WashIsolationTime and WashPelletIntensity must be set to Null. Please fix these conflicting options to specify a valid experiment.";
Error::WashMixTypeConflictingOptions = "The sample(s), `1`, at indicies `9`, have conflicting WashMixType Options. WashMixType is set to `2` but WashMixVolume is set to `3`, NumberOfWashMixes is set to `4`, WashMixInstrument is set to `5`, WashTemperature is set to `6`, WashMixTime is set to `7`, WashMixRate is set to `8`. When WashMixType is set to Shake, WashMixVolume and NumberOfWashMixes must be Null, WashMixInstrument, WashTemperature, WashMixTime and WashMixRate cannot be set to Null. When WashMixType is set to Pipette, WashMixVolume and NumberOfWashMixes cannot be Null, WashMixInstrument, WashTemperature, WashMixTime and WashMixRate must be set to Null. When WashMixType is set to None, WashMixVolume, NumberOfWashMixes, WashMixInstrument, WashTemperature, WashMixTime and WashMixRate must be set to Null. Please fix these conflicting options to specify a valid experiment.";
Error::ResuspensionMixTypeConflictingOptions = "The sample(s), `1`, at indicies `9`, have conflicting ResuspensionMixType Options. ResuspensionMixType is set to `2` but ResuspensionMixVolume is set to `3`, NumberOfResuspensionMixes is set to `4`, ResuspensionMixInstrument is set to `5`, ResuspensionTemperature is set to `6`, ResuspensionMixTime is set to `7`, ResuspensionMixRate is set to `8`. When ResuspensionMixType is set to Shake, ResuspensionMixVolume and NumberOfResuspensionMixes must be Null, ResuspensionMixInstrument, ResuspensionTemperature, ResuspensionMixTime and ResuspensionMixRate cannot be set to Null. When ResuspensionMixType is set to Pipette, ResuspensionMixVolume and NumberOfResuspensionMixes cannot be Null, ResuspensionMixInstrument, ResuspensionTemperature, ResuspensionMixTime and ResuspensionMixRate must be set to Null. When ResuspensionMixType is set to None, ResuspensionMixVolume, NumberOfResuspensionMixes, ResuspensionMixInstrument, ResuspensionTemperature, ResuspensionMixTime and ResuspensionMixRate must be set to Null. Please fix these conflicting options to specify a valid experiment.";
Error::ReplateCellsConflictingOption = "The sample(s) `1` at indices `2` have option ReplateCells set to True. This conflicts with cell culture adhesion. Only Suspension cells can be replated. Adherent cells need to use ExperimentSplitCells or ExperimentDissociateCells for replating. Please adjust this option to make it valid in order to submit a valid experiment.";
Error::AspirationVolumeConflictingOption = "The sample(s) `1` at indices `5` have option(s) `2` set to `3`. This conflicts with the current sample volume, which is `4`. Please adjust this option to make it smaller than the current sample volume in order to submit a valid experiment.";
Error::TotalVolumeConflictingOption = "The sample(s) `1` at indices `5` have option(s) `2` set to `3`. This makes the total volume exceed the container MaxVolume `4`. Please adjust this option to make it smaller than container MaxVolume in order to submit a valid experiment.";



(* ::Subsection:: *)
(* - Container to Sample Overload for WashCells - *)
ExperimentWashCells[myContainers : ListableP[ObjectP[{Object[Container], Object[Sample]}] | _String | {LocationPositionP, _String | ObjectP[Object[Container]]}], myOptions : OptionsPattern[]] := Module[
  {cache, listedOptions, listedContainers, outputSpecification, output, gatherTests, containerToSampleResult,
    containerToSampleOutput, samples, sampleOptions, containerToSampleTests, simulation,
    containerToSampleSimulation},
  (* Determine the requested return value from the function *)
  outputSpecification = Quiet[OptionValue[Output]];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests = MemberQ[output, Tests];

  (* Remove temporal links and named objects. *)
  {listedContainers, listedOptions} = removeLinks[ToList[myContainers], ToList[myOptions]];

  (* Fetch the cache from listedOptions. *)
  cache = ToList[Lookup[listedOptions, Cache, {}]];
  simulation = ToList[Lookup[listedOptions, Simulation, {}]];

  (* Convert our given containers into samples and sample index-matched options. *)
  containerToSampleResult = If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
      ExperimentWashCells,
      listedContainers,
      listedOptions,
      Output -> {Result, Tests, Simulation},
      Simulation -> simulation
    ];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
      Null,
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {containerToSampleOutput, containerToSampleSimulation} = containerToSampleOptions[
        ExperimentWashCells,
        listedContainers,
        listedOptions,
        Output -> {Result, Simulation},
        Simulation -> simulation
      ],
      $Failed,
      {Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
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
    ExperimentWashCells[samples, ReplaceRule[sampleOptions, Simulation -> simulation]]
  ]

];

(* ::Subsection:: *)
(* -- Main Overload for WashCells --*)
ExperimentWashCells[mySamples : ListableP[ObjectP[Object[Sample]]], myOptions : OptionsPattern[]] := Module[
  {
    cache, cacheBall, collapsedResolvedOptions, expandedSafeOps, gatherTests, inheritedOptions, listedOptions,
    listedSamples, messages, output, outputSpecification, washCellsCache, performSimulationQ, resultQ,
    protocolObject, resolvedOptions, resolvedOptionsResult, resolvedOptionsTests, resourceResult, resourcePacketTests,
    returnEarlyQ, safeOps, safeOptions, safeOptionTests, templatedOptions, templateTests, resolvedPreparation, roboticSimulation, runTime,
    inheritedSimulation, validLengths, validLengthTests, simulation, listedSanitizedSamples,
    listedSanitizedOptions, userSpecifiedObjects, objectsExistQs, objectsExistTests,
    sampleDownloadFields, methodObjects, washCellsMethodFields, washCellsMethodPacketFields,
    instrumentOptions, userSpecifiedInstruments, defaultInstruments, instrumentFields, modelInstrumentFields,
    optionsResolverOnly, returnEarlyBecauseOptionsResolverOnly
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
    SafeOptions[ExperimentWashCells, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
    {SafeOptions[ExperimentWashCells, listedOptions, AutoCorrect -> False], {}}
  ];

  (* Call sanitize-inputs to clean any objects referenced by Name; i.e., reference them by ID instead *)
  {listedSanitizedSamples, safeOps, listedSanitizedOptions} = sanitizeInputs[listedSamples, safeOptions, listedOptions];

  (* Call ValidInputLengthsQ to make sure all options are the right length *)
  {validLengths, validLengthTests} = If[gatherTests,
    ValidInputLengthsQ[ExperimentWashCells, {listedSanitizedSamples}, listedSanitizedOptions, Output -> {Result, Tests}],
    {ValidInputLengthsQ[ExperimentWashCells, {listedSanitizedSamples}, listedSanitizedOptions], Null}
  ];

  (* If the specified options don't match their patterns return $Failed *)
  If[MatchQ[safeOps, $Failed],
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> safeOptionTests,
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
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
    ApplyTemplateOptions[ExperimentWashCells, {listedSanitizedSamples}, listedSanitizedOptions, Output -> {Result, Tests}],
    {ApplyTemplateOptions[ExperimentWashCells, {listedSanitizedSamples}, listedSanitizedOptions], Null}
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
  expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentWashCells, {listedSanitizedSamples}, inheritedOptions]];

  (* Fetch the Cache and Simulation options. *)
  cache = Lookup[expandedSafeOps, Cache, {}];
  inheritedSimulation = Lookup[expandedSafeOps, Simulation, Null];

  (* Disallow Upload->False and Confirm->True. *)
  (* Not making a test here because Upload is a hidden option and we don't currently make tests for hidden options. *)
  If[MatchQ[Lookup[safeOps, Upload], False] && TrueQ[Lookup[safeOps, Confirm]],
    Message[Error::ConfirmUploadConflict];
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> Flatten[{safeOptionTests, validLengthTests}],
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (* Make sure that all of our objects exist. *)
  userSpecifiedObjects = DeleteDuplicates@Cases[
    Flatten[{ToList[mySamples], ToList[myOptions]}],
    ObjectReferenceP[]
  ];

  objectsExistQs = DatabaseMemberQ[userSpecifiedObjects, Simulation -> inheritedSimulation];

  (* Build tests for object existence *)
  objectsExistTests = If[gatherTests,
    MapThread[
      Test[StringTemplate["Specified object `1` exists in the database:"][#1], #2, True]&,
      {userSpecifiedObjects, objectsExistQs}
    ],
    {}
  ];

  (* If objects do not exist, return failure *)
  If[!(And @@ objectsExistQs),
    If[!gatherTests,
      Message[Error::ObjectDoesNotExist, PickList[userSpecifiedObjects, objectsExistQs, False]];
      Message[Error::InvalidInput, PickList[userSpecifiedObjects, objectsExistQs, False]]
    ];
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> Join[safeOptionTests, validLengthTests, templateTests, objectsExistTests],
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
  (* Fields to download from samples *)
  sampleDownloadFields = {
    SamplePreparationCacheFields[Object[Sample], Format -> Packet],
    Packet[Model[SamplePreparationCacheFields[Model[Sample]]]],
    Packet[Container[SamplePreparationCacheFields[Object[Container]]]],
    Packet[Container[Model][SamplePreparationCacheFields[Model[Container]]]],
    Packet[Living]
  };

  (* Fields to download from wash Method objects *)
  methodObjects = Lookup[expandedSafeOps, Method];
  washCellsMethodFields = {
    Method,
    CellType,
    CultureAdhesion,
    CellIsolationTechnique,
    CellIsolationInstrument,
    CellIsolationTime,
    CellPelletIntensity,
    CellAspirationAngle,
    AliquotSourceMedia,
    AliquotMediaStorageCondition,
    NumberOfWashes,
    WashSolution,
    WashSolutionTemperature,
    WashSolutionEquilibrationTime,
    WashMixType,
    WashMixInstrument,
    WashMixTime,
    WashMixRate,
    NumberOfWashMixes,
    WashTemperature,
    WashIsolationTime,
    WashPelletIntensity,
    WashAspirationAngle,
    ResuspensionMedia,
    ResuspensionMediaTemperature,
    ResuspensionMediaEquilibrationTime,
    ResuspensionMixType,
    ResuspensionTemperature,
    ResuspensionMixInstrument,
    ResuspensionMixTime,
    ResuspensionMixRate,
    NumberOfResuspensionMixes,
    ReplateCells
  };
  washCellsMethodPacketFields = Packet[washCellsMethodFields];
  (* Options whose inputs could be an instrument object or model *)
  instrumentOptions = {
    RoboticInstrument,
    CellIsolationInstrument,
    WashMixInstrument,
    ResuspensionMixInstrument
  };
  (* Extract any instrument objects that the user has explicitly specified *)
  userSpecifiedInstruments = DeleteDuplicates @ Cases[
    Flatten @ Lookup[ToList[myOptions], instrumentOptions, Null],
    ObjectP[]
  ];

  defaultInstruments = {
    Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"], (* Model[Instrument, LiquidHandler, "bioSTAR"] *)
    Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"], (* Model[Instrument, LiquidHandler, "microbioSTAR"] *)
    Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"], (* Model[Instrument, Centrifuge, "HiG4"] *)
    Model[Instrument, Shaker, "id:pZx9jox97qNp"], (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
    Model[Instrument, Shaker, "id:eGakldJkWVnz"], (* Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"] *)
    Model[Instrument, HeatBlock, "id:R8e1Pjp1W39a"] (* Model[Instrument, HeatBlock, "Hamilton Heater Cooler"] *)
  };

  instrumentFields = {
    Packet[Model, Status, MinVolume, MinRotationRate, MaxRotationRate, MinTemperature, MaxTemperature],
    Packet[Model[{ModelName, Deprecated, Positions}]]
  };

  modelInstrumentFields = Packet[{Name, MinVolume, MinRotationRate, MaxRotationRate, MinTemperature, MaxTemperature, Positions}];
  (* - Big Download to make cacheBall and get the inputs in order by ID - *)
  washCellsCache = Quiet[
    Download[
      {
        listedSanitizedSamples,
        methodObjects,
        Join[{userSpecifiedInstruments, defaultInstruments}],
        Join[{userSpecifiedInstruments, defaultInstruments}]
      },
      Evaluate[{
        sampleDownloadFields,
        washCellsMethodPacketFields,
        instrumentFields,
        modelInstrumentFields
      }],
      Cache -> cache,
      Simulation -> inheritedSimulation
    ],
    {Download::ObjectDoesNotExist, Download::FieldDoesntExist, Download::NotLinkField}
  ];

  (* Combine our downloaded and simulated cache. *)
  (* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
  cacheBall = FlattenCachePackets[{cache, washCellsCache}];

  (* Build the resolved options *)
  resolvedOptionsResult = If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {resolvedOptions, resolvedOptionsTests} = resolveExperimentWashCellsOptions[
      ExperimentWashCells,
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
        resolveExperimentWashCellsOptions[
          ExperimentWashCells,
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
    ExperimentWashCells,
    resolvedOptions,
    Ignore -> ToList[myOptions],
    Messages -> False
  ];

  (* Lookup our resolved Preparation option. *)
  resolvedPreparation = Lookup[resolvedOptions, Preparation];

  (* lookup our OptionsResolverOnly option.  This will determine if we skip the resource packets and simulation functions *)
  (* if Output contains Result, Simulation, or Tests, then we can't do this *)
  optionsResolverOnly = Lookup[resolvedOptions, OptionsResolverOnly];
  returnEarlyBecauseOptionsResolverOnly = TrueQ[optionsResolverOnly] && Not[MemberQ[output, Result | Simulation]];

  (* run all the tests from the resolution; if any of them were False, then we should return early here *)
  (* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
  (* basically, if _not_ all the tests are passing, then we do need to return early *)
  returnEarlyQ = Which[
    (*True, True, *)
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
  If[!performSimulationQ && (returnEarlyQ || returnEarlyBecauseOptionsResolverOnly),
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> Join[safeOptionTests, validLengthTests, templateTests, resolvedOptionsTests],
      Options -> RemoveHiddenOptions[ExperimentWashCells, collapsedResolvedOptions],
      Preview -> Null,
      Simulation -> Simulation[]
    }]
  ];

  (* Build packets with resources *)
  {{resourceResult, roboticSimulation, runTime}, resourcePacketTests} = Which[
    MatchQ[resolvedOptionsResult, $Failed],
    {{$Failed, $Failed, $Failed}, {}},
    gatherTests,
    washCellsResourcePackets[
      ToList[Download[mySamples, Object]],
      templatedOptions,
      resolvedOptions,
      Cache -> cacheBall,
      Simulation -> inheritedSimulation,
      Output -> {Result, Tests}
    ],
    True,
    {
      washCellsResourcePackets[
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
      Options -> RemoveHiddenOptions[ExperimentWashCells, collapsedResolvedOptions],
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

    (* If we're doing Preparation->Robotic and Upload->True, call ExperimentRoboticCellPreparation with our primitive. *)
    True,
    Module[{primitive, nonHiddenOptions},
      (* Create our primitive to feed into RoboticCellPreparation. *)
      primitive = WashCells @@ Join[
        {
          Sample -> Download[ToList[mySamples], Object]
        },
        RemoveHiddenPrimitiveOptions[WashCells, ToList[myOptions]]
      ];

      (* Remove any hidden options before returning. *)
      nonHiddenOptions = RemoveHiddenOptions[ExperimentWashCells, collapsedResolvedOptions];


      (* Memoize the value of ExperimentWashCells so the framework doesn't spend time resolving it again. *)
      Internal`InheritedBlock[{ExperimentWashCells, $PrimitiveFrameworkResolverOutputCache},
        $PrimitiveFrameworkResolverOutputCache = <||>;

        DownValues[ExperimentWashCells] = {};

        ExperimentWashCells[___, options : OptionsPattern[]] := Module[{frameworkOutputSpecification},
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

        ExperimentRoboticCellPreparation[
          {primitive},
          Name -> Lookup[safeOps, Name],
          Upload -> Lookup[safeOps, Upload],
          Confirm -> Lookup[safeOps, Confirm],
          ParentProtocol -> Lookup[safeOps, ParentProtocol],
          Priority -> Lookup[safeOps, Priority],
          StartDate -> Lookup[safeOps, StartDate],
          HoldOrder -> Lookup[safeOps, HoldOrder],
          QueuePosition -> Lookup[safeOps, QueuePosition],
          Cache -> cacheBall(*,
          Debug -> True*)
        ]
      ]
    ]
  ];

  (* Return requested output *)
  outputSpecification /. {
    Result -> protocolObject,
    Tests -> Flatten[{safeOptionTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
    Options -> RemoveHiddenOptions[ExperimentWashCells, collapsedResolvedOptions],
    Preview -> Null,
    Simulation -> simulation,
    RunTime -> runTime
  }
];


(* ::Subsection:: *)
(* - Container to Sample Overload for ChangeMedia - *)
ExperimentChangeMedia[myContainers : ListableP[ObjectP[{Object[Container], Object[Sample]}] | _String | {LocationPositionP, _String | ObjectP[Object[Container]]}], myOptions : OptionsPattern[]] := Module[
  {cache, listedOptions, listedContainers, outputSpecification, output, gatherTests, containerToSampleResult,
    containerToSampleOutput, samples, sampleOptions, containerToSampleTests, simulation,
    containerToSampleSimulation},
  (* Determine the requested return value from the function *)
  outputSpecification = Quiet[OptionValue[Output]];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests = MemberQ[output, Tests];

  (* Remove temporal links and named objects. *)
  {listedContainers, listedOptions} = removeLinks[ToList[myContainers], ToList[myOptions]];

  (* Fetch the cache from listedOptions. *)
  cache = ToList[Lookup[listedOptions, Cache, {}]];
  simulation = ToList[Lookup[listedOptions, Simulation, {}]];

  (* Convert our given containers into samples and sample index-matched options. *)
  containerToSampleResult = If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
      ExperimentWashCells,
      listedContainers,
      listedOptions,
      Output -> {Result, Tests, Simulation},
      Simulation -> simulation
    ];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
      Null,
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {containerToSampleOutput, containerToSampleSimulation} = containerToSampleOptions[
        ExperimentWashCells,
        listedContainers,
        listedOptions,
        Output -> {Result, Simulation},
        Simulation -> simulation
      ],
      $Failed,
      {Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
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
    ExperimentWashCells[samples, ReplaceRule[sampleOptions, Simulation -> simulation]]
  ]

];

(* ::Subsection:: *)
(* -- Main Overload for ChangeMedia --*)
ExperimentChangeMedia[mySamples : ListableP[ObjectP[Object[Sample]]], myOptions : OptionsPattern[]] := Module[
  {
    cache, cacheBall, collapsedResolvedOptions, expandedSafeOps, gatherTests, inheritedOptions, listedOptions,
    listedSamples, messages, output, outputSpecification, washCellsCache, performSimulationQ, resultQ,
    protocolObject, resolvedOptions, resolvedOptionsResult, resolvedOptionsTests, resourceResult, resourcePacketTests,
    returnEarlyQ, safeOps, safeOptions, safeOptionTests, templatedOptions, templateTests, resolvedPreparation, roboticSimulation, runTime,
    inheritedSimulation, validLengths, validLengthTests, simulation, listedSanitizedSamples,
    listedSanitizedOptions, userSpecifiedObjects, objectsExistQs, objectsExistTests,
    sampleDownloadFields, methodObjects, washCellsMethodFields, washCellsMethodPacketFields,
    instrumentOptions, userSpecifiedInstruments, defaultInstruments, instrumentFields, modelInstrumentFields,
    optionsResolverOnly, returnEarlyBecauseOptionsResolverOnly
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
    SafeOptions[ExperimentWashCells, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
    {SafeOptions[ExperimentWashCells, listedOptions, AutoCorrect -> False], {}}
  ];

  (* Call sanitize-inputs to clean any objects referenced by Name; i.e., reference them by ID instead *)
  {listedSanitizedSamples, safeOps, listedSanitizedOptions} = sanitizeInputs[listedSamples, safeOptions, listedOptions];

  (* Call ValidInputLengthsQ to make sure all options are the right length *)
  {validLengths, validLengthTests} = If[gatherTests,
    ValidInputLengthsQ[ExperimentWashCells, {listedSanitizedSamples}, listedSanitizedOptions, Output -> {Result, Tests}],
    {ValidInputLengthsQ[ExperimentWashCells, {listedSanitizedSamples}, listedSanitizedOptions], Null}
  ];

  (* If the specified options don't match their patterns return $Failed *)
  If[MatchQ[safeOps, $Failed],
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> safeOptionTests,
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
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
    ApplyTemplateOptions[ExperimentWashCells, {listedSanitizedSamples}, listedSanitizedOptions, Output -> {Result, Tests}],
    {ApplyTemplateOptions[ExperimentWashCells, {listedSanitizedSamples}, listedSanitizedOptions], Null}
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
  expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentWashCells, {listedSanitizedSamples}, inheritedOptions]];

  (* Fetch the Cache and Simulation options. *)
  cache = Lookup[expandedSafeOps, Cache, {}];
  inheritedSimulation = Lookup[expandedSafeOps, Simulation, Null];

  (* Disallow Upload->False and Confirm->True. *)
  (* Not making a test here because Upload is a hidden option and we don't currently make tests for hidden options. *)
  If[MatchQ[Lookup[safeOps, Upload], False] && TrueQ[Lookup[safeOps, Confirm]],
    Message[Error::ConfirmUploadConflict];
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> Flatten[{safeOptionTests, validLengthTests}],
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (* Make sure that all of our objects exist. *)
  userSpecifiedObjects = DeleteDuplicates@Cases[
    Flatten[{ToList[mySamples], ToList[myOptions]}],
    ObjectReferenceP[]
  ];

  objectsExistQs = DatabaseMemberQ[userSpecifiedObjects, Simulation -> inheritedSimulation];

  (* Build tests for object existence *)
  objectsExistTests = If[gatherTests,
    MapThread[
      Test[StringTemplate["Specified object `1` exists in the database:"][#1], #2, True]&,
      {userSpecifiedObjects, objectsExistQs}
    ],
    {}
  ];

  (* If objects do not exist, return failure *)
  If[!(And @@ objectsExistQs),
    If[!gatherTests,
      Message[Error::ObjectDoesNotExist, PickList[userSpecifiedObjects, objectsExistQs, False]];
      Message[Error::InvalidInput, PickList[userSpecifiedObjects, objectsExistQs, False]]
    ];
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> Join[safeOptionTests, validLengthTests, templateTests, objectsExistTests],
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
  (* Fields to download from samples *)
  sampleDownloadFields = {
    SamplePreparationCacheFields[Object[Sample], Format -> Packet],
    Packet[Model[SamplePreparationCacheFields[Model[Sample]]]],
    Packet[Container[SamplePreparationCacheFields[Object[Container]]]],
    Packet[Container[Model][SamplePreparationCacheFields[Model[Container]]]],
    Packet[Living]
  };

  (* Fields to download from wash Method objects *)
  methodObjects = Lookup[expandedSafeOps, Method];
  washCellsMethodFields = {
    Method,
    CellType,
    CultureAdhesion,
    CellIsolationTechnique,
    CellIsolationInstrument,
    CellIsolationTime,
    CellPelletIntensity,
    CellAspirationAngle,
    AliquotSourceMedia,
    AliquotMediaStorageCondition,
    NumberOfWashes,
    WashSolution,
    WashSolutionTemperature,
    WashSolutionEquilibrationTime,
    WashMixType,
    WashMixInstrument,
    WashMixTime,
    WashMixRate,
    NumberOfWashMixes,
    WashTemperature,
    WashIsolationTime,
    WashPelletIntensity,
    WashAspirationAngle,
    ResuspensionMedia,
    ResuspensionMediaTemperature,
    ResuspensionMediaEquilibrationTime,
    ResuspensionMixType,
    ResuspensionTemperature,
    ResuspensionMixInstrument,
    ResuspensionMixTime,
    ResuspensionMixRate,
    NumberOfResuspensionMixes,
    ReplateCells
  };
  washCellsMethodPacketFields = Packet[washCellsMethodFields];
  (* Options whose inputs could be an instrument object or model *)
  instrumentOptions = {
    RoboticInstrument,
    CellIsolationInstrument,
    WashMixInstrument,
    ResuspensionMixInstrument
  };
  (* Extract any instrument objects that the user has explicitly specified *)
  userSpecifiedInstruments = DeleteDuplicates @ Cases[
    Flatten @ Lookup[ToList[myOptions], instrumentOptions, Null],
    ObjectP[]
  ];

  defaultInstruments = {
    Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"], (* Model[Instrument, LiquidHandler, "bioSTAR"] *)
    Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"], (* Model[Instrument, LiquidHandler, "microbioSTAR"] *)
    Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"], (* Model[Instrument, Centrifuge, "HiG4"] *)
    Model[Instrument, Shaker, "id:pZx9jox97qNp"], (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
    Model[Instrument, Shaker, "id:eGakldJkWVnz"], (* Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"] *)
    Model[Instrument, HeatBlock, "id:R8e1Pjp1W39a"] (* Model[Instrument, HeatBlock, "Hamilton Heater Cooler"] *)
  };

  instrumentFields = {
    Packet[Model, Status, MinVolume, MinRotationRate, MaxRotationRate, MinTemperature, MaxTemperature],
    Packet[Model[{ModelName, Deprecated, Positions}]]
  };

  modelInstrumentFields = Packet[{Name, MinVolume, MinRotationRate, MaxRotationRate, MinTemperature, MaxTemperature, Positions}];
  (* - Big Download to make cacheBall and get the inputs in order by ID - *)
  washCellsCache = Quiet[
    Download[
      {
        listedSanitizedSamples,
        methodObjects,
        Join[{userSpecifiedInstruments, defaultInstruments}],
        Join[{userSpecifiedInstruments, defaultInstruments}]
      },
      Evaluate[{
        sampleDownloadFields,
        washCellsMethodPacketFields,
        instrumentFields,
        modelInstrumentFields
      }],
      Cache -> cache,
      Simulation -> inheritedSimulation
    ],
    {Download::ObjectDoesNotExist, Download::FieldDoesntExist, Download::NotLinkField}
  ];

  (* Combine our downloaded and simulated cache. *)
  (* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
  cacheBall = FlattenCachePackets[{cache, washCellsCache}];

  (* Build the resolved options *)
  resolvedOptionsResult = If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {resolvedOptions, resolvedOptionsTests} = resolveExperimentWashCellsOptions[
      ExperimentChangeMedia,
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
        resolveExperimentWashCellsOptions[
          ExperimentChangeMedia,
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
    ExperimentWashCells,
    resolvedOptions,
    Ignore -> ToList[myOptions],
    Messages -> False
  ];

  (* Lookup our resolved Preparation option. *)
  resolvedPreparation = Lookup[resolvedOptions, Preparation];

  (* lookup our OptionsResolverOnly option.  This will determine if we skip the resource packets and simulation functions *)
  (* if Output contains Result, Simulation, or Tests, then we can't do this *)
  optionsResolverOnly = Lookup[resolvedOptions, OptionsResolverOnly];
  returnEarlyBecauseOptionsResolverOnly = TrueQ[optionsResolverOnly] && Not[MemberQ[output, Result | Simulation]];

  (* run all the tests from the resolution; if any of them were False, then we should return early here *)
  (* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
  (* basically, if _not_ all the tests are passing, then we do need to return early *)
  returnEarlyQ = Which[
    (* True, True, remove this line when the resolver is done *)
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
  If[!performSimulationQ && (returnEarlyQ || returnEarlyBecauseOptionsResolverOnly),
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> Join[safeOptionTests, validLengthTests, templateTests, resolvedOptionsTests],
      Options -> RemoveHiddenOptions[ExperimentWashCells, collapsedResolvedOptions],
      Preview -> Null,
      Simulation -> Simulation[]
    }]
  ];

  (* Build packets with resources *)
  {{resourceResult, roboticSimulation, runTime}, resourcePacketTests} = Which[
    MatchQ[resolvedOptionsResult, $Failed],
    {{$Failed, $Failed, $Failed}, {}},
    gatherTests,
    washCellsResourcePackets[
      ToList[Download[mySamples, Object]],
      templatedOptions,
      resolvedOptions,
      Cache -> cacheBall,
      Simulation -> inheritedSimulation,
      Output -> {Result, Tests}
    ],
    True,
    {
      washCellsResourcePackets[
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
      Options -> RemoveHiddenOptions[ExperimentWashCells, collapsedResolvedOptions],
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

    (* If we're doing Preparation->Robotic and Upload->True, call ExperimentRoboticCellPreparation with our primitive. *)
    True,
    Module[{primitive, nonHiddenOptions},
      (* Create our primitive to feed into RoboticCellPreparation. *)
      primitive = WashCells @@ Join[
        {
          Sample -> Download[ToList[mySamples], Object]
        },
        RemoveHiddenPrimitiveOptions[WashCells, ToList[myOptions]]
      ];


      (* Remove any hidden options before returning. *)
      nonHiddenOptions = RemoveHiddenOptions[ExperimentWashCells, collapsedResolvedOptions];


      (* Memoize the value of ExperimentWashCells so the framework doesn't spend time resolving it again. *)
      Internal`InheritedBlock[{ExperimentWashCells, $PrimitiveFrameworkResolverOutputCache},
        $PrimitiveFrameworkResolverOutputCache = <||>;

        DownValues[ExperimentWashCells] = {};

        ExperimentWashCells[___, options : OptionsPattern[]] := Module[{frameworkOutputSpecification},
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

        ExperimentRoboticCellPreparation[
          {primitive},
          Name -> Lookup[safeOps, Name],
          Upload -> Lookup[safeOps, Upload],
          Confirm -> Lookup[safeOps, Confirm],
          ParentProtocol -> Lookup[safeOps, ParentProtocol],
          Priority -> Lookup[safeOps, Priority],
          StartDate -> Lookup[safeOps, StartDate],
          HoldOrder -> Lookup[safeOps, HoldOrder],
          QueuePosition -> Lookup[safeOps, QueuePosition],
          Cache -> cacheBall(*,
          Debug -> True*)
        ]
      ]
    ]
  ];


  (* Return requested output *)
  outputSpecification /. {
    Result -> protocolObject,
    Tests -> Flatten[{safeOptionTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
    Options -> RemoveHiddenOptions[ExperimentWashCells, collapsedResolvedOptions],
    Preview -> Null,
    Simulation -> simulation,
    RunTime -> runTime
  }
];


(* ::Subsection::Closed:: *)
(* resolveWashCellsWorkCell *)

DefineOptions[resolveWashCellsWorkCell,
  SharedOptions :> {
    ExperimentWashCells,
    CacheOption,
    SimulationOption,
    OutputOption
  }
];

resolveWashCellsWorkCell[
  myContainersAndSamples : ListableP[Automatic | ObjectP[{Object[Sample], Object[Container]}]],
  myOptions : OptionsPattern[]
] := Module[{mySamples, myContainers, samplePackets},

  mySamples = Cases[myContainersAndSamples, ObjectP[Object[Sample]], Infinity];
  myContainers = Cases[myContainersAndSamples, ObjectP[Object[Container]], Infinity];

  samplePackets = Download[mySamples, Packet[CellType]];

  (* NOTE: due to the mechanism by which the primitive framework resolves WorkCell, we can't just resolve it on our own and then tell *)
  (* the framework what to use. So, we resolve using the CellType option if specified, or the CellType field in the input sample(s). *)

  Which[
    (* If the user specifies the microbioSTAR for RoboticInstrument, resolve the WorkCell to match *)
    KeyExistsQ[myOptions, RoboticInstrument] && MatchQ[Lookup[myOptions, RoboticInstrument], Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"]],
    {microbioSTAR},
    (* If the user specifies the microbioSTAR for RoboticInstrument, resolve the WorkCell to match *)
    KeyExistsQ[myOptions, RoboticInstrument] && MatchQ[Lookup[myOptions, RoboticInstrument], Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"]],
    {bioSTAR},
    (* If the user specifies any microbial (Bacterial, Yeast, or Fungal) cell types using the CellType option, resolve to microbioSTAR *)
    KeyExistsQ[myOptions, CellType] && MemberQ[Lookup[myOptions, CellType], MicrobialCellTypeP],
    {microbioSTAR},
    (* If the user specifies only nonmicrobial (Mammalian, Insect, or Plant) cell types using the CellType option, resolve to bioSTAR *)
    KeyExistsQ[myOptions, CellType] && MatchQ[Lookup[myOptions, CellType], {NonMicrobialCellTypeP..}],
    {bioSTAR},
    (*If CellType field for any input Sample objects is microbial (Bacterial, Yeast, or Fungal), then the microbioSTAR is used. *)
    MemberQ[Lookup[samplePackets, CellType], MicrobialCellTypeP],
    {microbioSTAR},
    (*If CellType field for all input Sample objects is not microbial (Mammalian, Plant, or Insect), then the bioSTAR is used. *)
    MatchQ[Lookup[samplePackets, CellType], {NonMicrobialCellTypeP..}],
    {bioSTAR},
    (*Otherwise, use the microbioSTAR.*)
    True,
    {microbioSTAR}
  ]
];

(* ::Subsection:: *)
(* resolveExperimentWashCellsOptions *)

DefineOptions[
  resolveExperimentWashCellsOptions,
  Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveExperimentWashCellsOptions[myFunction : (ExperimentWashCells | ExperimentChangeMedia), mySamples : {ObjectP[Object[Sample]]...}, myOptions : {_Rule...}, myResolutionOptions : OptionsPattern[resolveExperimentWashCellsOptions]] := Module[
  {outputSpecification, output, gatherTests, messages, cache, listedOptions, currentSimulation, optionPrecisions, roundedExperimentOptions,
    optionPrecisionTests, mapThreadFriendlyOptions, samplePacketFields, sampleFields,
    sampleModelFields, sampleModelPacketFields, containerObjectFields, containerObjectPacketFields, containerModelFields, containerModelPacketFields, washCellsMethodFields, washCellsMethodPacketFields, instrumentFields, instrumentPacketFields, modelInstrumentFields, modelInstrumentPacketFields, sampleCompositionModelPackets, compositionModelFields, compositionModelPacketFields,
    samplePackets,
    sampleModelPackets,
    sampleContainerPackets,
    sampleContainerModelPackets,
    containerModelPackets,
    containerModelFromObjectPackets,
    washCellsMethodPackets,
    instrumentPackets,
    modelInstrumentPackets,
    samplePacketsWithConvertedCompositions,
    cacheBall, fastAssoc, discardedSamplePackets, discardedInvalidInputs, discardedTest, deprecatedSamplePackets, deprecatedInvalidInputs, deprecatedTest,
    solidMediaInvalidInputs, solidMediaTest, invalidInputs, invalidOptions,

    resolvedWorkCell, resolvedRoboticInstrument,
    resolvedMethod,
    resolvedCellType,
    resolvedCultureAdhesion,
    resolvedCellIsolationTechnique,
    resolvedCellIsolationInstrument,
    resolvedCellAspirationVolume,
    resolvedCellIsolationTime,
    resolvedCellPelletIntensity,
    resolvedCellAspirationAngle,
    resolvedAliquotSourceMedia,
    resolvedAliquotMediaLabel,
    resolvedAliquotMediaVolume,
    resolvedAliquotMediaStorageCondition,
    resolvedNumberOfWashes,
    resolvedWashSolution,
    resolvedWashSolutionTemperature,
    resolvedWashSolutionEquilibrationTime,
    resolvedWashVolume,
    resolvedWashMixType,
    resolvedWashMixInstrument,
    resolvedWashMixTime,
    resolvedWashMixRate,
    resolvedNumberOfWashMixes,
    resolvedWashMixVolume,
    resolvedWashTemperature,
    resolvedWashAspirationVolume,
    resolvedWashIsolationTime,
    resolvedWashPelletIntensity,
    resolvedWashAspirationAngle,
    resolvedResuspensionMedia,
    resolvedResuspensionMediaTemperature,
    resolvedResuspensionMediaEquilibrationTime,
    resolvedResuspensionMediaVolume,
    resolvedResuspensionMixType,
    resolvedResuspensionTemperature,
    resolvedResuspensionMixInstrument,
    resolvedResuspensionMixTime,
    resolvedResuspensionMixRate,
    resolvedNumberOfResuspensionMixes,
    resolvedResuspensionMixVolume,
    resolvedReplateCells,
    resolvedSampleOutLabel,

    userSpecifiedLabels, resolvedPostProcessingOptions, email, resolvedOptions,

    resolvedCellPelletContainer, resolvedCellPelletContainerWells, semiresolvedCellPelletContainerModel, semiresolvedSampleContainerModelAfterPelletPackets, semiresolvedAliquotMediaContainerModel,
    resolvedAliquotMediaContainer, resolvedAliquotMediaContainerWells, resolvedContainerOut, resolvedContainerOutWells,
    resolvedAliquotMediaContainerLabel, resolvedContainerOutLabel, semiresolvedContainerOutModel,

    resolvedvolumeAfterAspiration,
    resolvedvolumeInWashing,
    resolvedvolumeAfterWashing,
    resolvedvolumeLimitWashing,
    resolvedvolumeInResuspension,

    (*Conflict Options *)
    extraneousWashingOptionsCases, extraneousWashingOptionsTest,
    extraneousMediaReplenishmentOptionsCases,
    extraneousMediaReplenishmentOptionsTest,
    cellIsolationTechniqueConflictingOptionsCases,
    cellIsolationTechniqueConflictingOptionsTest,
    washIsolationTechniqueConflictingOptionsCases,
    washIsolationTechniqueConflictingOptionsTest,
    washMixTypeConflictingOptionsCases,
    washMixTypeConflictingOptionsTest,
    resuspensionMixTypeConflictingOptionsCases,
    resuspensionMixTypeConflictingOptionsTest,
    replateCellsConflictingOptionCases,
    replateCellsConflictingOptionTest,
    aspirationVolumeConflictingOptionCases,
    aspirationVolumeConflictingOptionTest,
    totalVolumeConflictingOptionCases, totalVolumeConflictingOptionTest

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

  (*-- RESOLVE PREPARATION OPTION --*)
  (* Usually, we resolve our Preparation option here, but since we can only do Preparation -> Robotic, there is no need to. *)

  (* -- DOWNLOAD -- *)

  (* NOTE: All fields downloaded below should already be included in the cache passed down to us by the main function. *)
  sampleFields = DeleteDuplicates[Flatten[{Name, Composition, Container, Position, Volume, Media, CultureAdhesion, CellType}]];
  samplePacketFields = Packet @@ sampleFields;
  sampleModelFields = DeleteDuplicates[Flatten[{Name}]];
  sampleModelPacketFields = Packet @@ sampleModelFields;

  containerObjectFields = {Contents, Model, MaxVolume, Name, Type};
  containerObjectPacketFields = Packet @@ containerObjectFields;
  containerModelFields = {MaxVolume, Positions, Name, Footprint};
  containerModelPacketFields = Packet @@ containerModelFields;

  compositionModelFields = {PreferredLiquidMedia};
  compositionModelPacketFields = Packet @@ compositionModelFields;

  washCellsMethodFields = DeleteDuplicates[{
    CellType,
    CultureAdhesion,
    CellIsolationTechnique,
    CellIsolationInstrument,
    CellIsolationTime,
    CellPelletIntensity,
    CellAspirationAngle,
    AliquotSourceMedia,
    AliquotMediaStorageCondition,
    NumberOfWashes,
    WashSolution,
    WashSolutionTemperature,
    WashSolutionEquilibrationTime,
    WashMixType,
    WashMixInstrument,
    WashMixTime,
    WashMixRate,
    NumberOfWashMixes,
    WashTemperature,
    WashIsolationTime,
    WashPelletIntensity,
    WashAspirationAngle,
    ResuspensionMedia,
    ResuspensionMediaTemperature,
    ResuspensionMediaEquilibrationTime,
    ResuspensionMixType,
    ResuspensionTemperature,
    ResuspensionMixInstrument,
    ResuspensionMixTime,
    ResuspensionMixRate,
    NumberOfResuspensionMixes,
    ReplateCells
  }];
  washCellsMethodPacketFields = Packet @@ washCellsMethodFields;

  instrumentFields = DeleteDuplicates[{Model, Status, MinVolume, MinRotationRate, MaxRotationRate, MinTemperature, MaxTemperature}];
  instrumentPacketFields = Packet @@ instrumentFields;
  modelInstrumentFields = DeleteDuplicates[{Name, MinTemperature, MaxTemperature, Positions}];
  modelInstrumentPacketFields = Packet @@ modelInstrumentFields;

  {
    (*1*)samplePackets,
    (*2*)sampleModelPackets,
    (*3*)sampleContainerPackets,
    (*4*)sampleContainerModelPackets,
    (*5*)sampleCompositionModelPackets,

    containerModelPackets,
    containerModelFromObjectPackets,
    washCellsMethodPackets,
    instrumentPackets,
    modelInstrumentPackets

  } = Quiet[Download[
    {
      (*1*)mySamples,
      (*2*)mySamples,
      (*3*)mySamples,
      (*4*)mySamples,
      (*5*)mySamples,


      DeleteDuplicates@Flatten[{
        Cases[
          Flatten[Lookup[myOptions, {CellPelletContainer, AliquotMediaContainer, ContainerOut}]],
          ObjectP[Model[Container]]
        ],
        PreferredContainer[All, LiquidHandlerCompatible -> True, Type -> All]
      }],
      DeleteDuplicates@Cases[
        Flatten[Lookup[myOptions, {CellPelletContainer, AliquotMediaContainer, ContainerOut}]],
        ObjectP[Object[Container]]
      ],
      DeleteDuplicates@Flatten[{
        Cases[
          Flatten[Lookup[myOptions, Method]], ObjectP[Object[Method, WashCells]]]}
      ],
      DeleteDuplicates@Flatten[{
        Cases[
          Flatten[Lookup[myOptions, $WashCellsInstrumentOptions]], ObjectP[Object[Instrument]]]}
      ],
      DeleteDuplicates@Flatten[{
        Cases[{
          Flatten[Lookup[myOptions, $WashCellsInstrumentOptions]],
          Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"], (* Model[Instrument, LiquidHandler, "bioSTAR"] *)
          Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"], (* Model[Instrument, LiquidHandler, "microbioSTAR"] *)
          Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"], (* Model[Instrument, Centrifuge, "HiG4"] *)
          Model[Instrument, Shaker, "id:pZx9jox97qNp"], (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
          Model[Instrument, Shaker, "id:eGakldJkWVnz"], (* Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"] *)
          Model[Instrument, HeatBlock, "id:R8e1Pjp1W39a"]}, ObjectP[Model[Instrument]]]}  (* Model[Instrument, HeatBlock, "Hamilton Heater Cooler"] *)
      ]

    },
    {
      {samplePacketFields},
      {Packet[Model[sampleModelFields]]},
      {Packet[Container[containerObjectFields]]},
      {Packet[Container[Model][containerModelFields]]},
      {Packet[Composition[[All, 2]][compositionModelFields]]},

      {containerModelPacketFields},
      {containerObjectPacketFields, Packet[Model[containerModelFields]]},
      {washCellsMethodPacketFields},
      {instrumentPacketFields},
      {modelInstrumentPacketFields}
    },
    Cache -> cache,
    Simulation -> currentSimulation
  ],
    {Download::ObjectDoesNotExist, Download::FieldDoesntExist, Download::NotLinkField}
  ];
  {
    samplePackets,
    sampleModelPackets,
    sampleContainerPackets,
    sampleContainerModelPackets,
    sampleCompositionModelPackets,
    containerModelPackets,
    containerModelFromObjectPackets,
    washCellsMethodPackets,
    instrumentPackets,
    modelInstrumentPackets
  } = Flatten /@ {
    samplePackets,
    sampleModelPackets,
    sampleContainerPackets,
    sampleContainerModelPackets,
    sampleCompositionModelPackets,
    containerModelPackets,
    containerModelFromObjectPackets,
    washCellsMethodPackets,
    instrumentPackets,
    modelInstrumentPackets
  };
  cacheBall = FlattenCachePackets[{
    cache,
    samplePackets,
    sampleModelPackets,
    sampleContainerPackets,
    sampleContainerModelPackets,
    sampleCompositionModelPackets,
    containerModelPackets,
    containerModelFromObjectPackets,
    washCellsMethodPackets,
    instrumentPackets,
    modelInstrumentPackets
  }];

  (* Make fast association to look up things from cache quickly.*)
  fastAssoc = makeFastAssocFromCache[cacheBall];

  (*-- INPUT VALIDATION CHECKS --*)

  (* Get the samples from mySamples that are discarded. *)
  discardedSamplePackets = Cases[Flatten[samplePackets], KeyValuePattern[Status -> Discarded]];

  (* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
  discardedInvalidInputs = If[MatchQ[discardedSamplePackets, {}],
    {},
    Lookup[discardedSamplePackets, Object]
  ];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[Length[discardedInvalidInputs] > 0 && !gatherTests,
    Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Cache -> cache]];
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  discardedTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[discardedInvalidInputs] == 0,
        Nothing,
        Test["The input samples " <> ObjectToString[discardedInvalidInputs, Cache -> cache] <> " are not discarded:", True, False]
      ];

      passingTest = If[Length[discardedInvalidInputs] == Length[mySamples],
        Nothing,
        Test["The input samples " <> ObjectToString[Complement[mySamples, discardedInvalidInputs], Cache -> cacheBall] <> " are not discarded:", True, True]
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

  (* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
  If[Length[deprecatedInvalidInputs] > 0 && messages,
    Message[Error::DeprecatedModels, ObjectToString[deprecatedInvalidInputs, Cache -> cache]]
  ];

  (* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
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

  (* -- SOLID MEDIA CHECK -- *)

  {solidMediaInvalidInputs, solidMediaTest} = checkSolidMedia[samplePackets, messages, Cache -> cache];

  (* -- INVALID INPUT CHECK -- *)

  (*Gather a list of all invalid inputs from all invalid input tests.*)
  invalidInputs = DeleteDuplicates[Flatten[{discardedInvalidInputs, deprecatedInvalidInputs, solidMediaInvalidInputs}]];

  invalidInputs = DeleteDuplicates[Flatten[{}]];

  (*Throw Error::InvalidInput if there are any invalid inputs.*)
  If[!gatherTests && Length[invalidInputs] > 0,
    Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> cache]]
  ];

  (*-- OPTION PRECISION CHECKS --*)

  (* Define the option precisions that need to be checked. *)
  (* NOTE: Don't check CentrifugeIntensity precision here because each centrifuge has a different precision. ExperimentCentrifuge *)
  (* will check this for us. *)
  optionPrecisions = {
    {CellAspirationVolume, 1 * Microliter},
    {WashMixVolume, 1 * Microliter},
    {WashAspirationVolume, 1 * Microliter},
    {AliquotMediaVolume, 1 * Microliter},
    {ResuspensionMediaVolume, 1 * Microliter},
    {ResuspensionMixVolume, 1 * Microliter},
    {WashSolutionTemperature, 1 * Celsius},
    {WashTemperature, 1 * Celsius},
    {ResuspensionMediaTemperature, 1 * Celsius},
    {ResuspensionTemperature, 1 * Celsius},
    {CellIsolationTime, 1 * Second},
    {WashSolutionEquilibrationTime, 1 * Second},
    {WashMixTime, 1 * Second},
    {WashIsolationTime, 1 * Second},
    {ResuspensionMediaEquilibrationTime, 1 * Second},
    {ResuspensionMixTime, 1 Second},
    {WashMixRate, 1 RPM},
    {ResuspensionMixRate, 1 RPM}
  };

  (* There are still a few options that we need to check the precisions of though. *)
  {roundedExperimentOptions, optionPrecisionTests} = If[gatherTests,
    (*If we are gathering tests *)
    RoundOptionPrecision[Association @@ listedOptions, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]], Output -> {Result, Tests}],
    (* Otherwise *)
    {RoundOptionPrecision[Association @@ listedOptions, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]]], {}}
  ];

  (* Convert our options into a MapThread friendly version. *)
  mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentWashCells, roundedExperimentOptions];


  (*-- RESOLVE EXPERIMENT OPTIONS --*)

  (* resolveWashCellsWorkCell[mySamples] return {WorkCell} *)
  resolvedWorkCell = First[resolveWashCellsWorkCell[mySamples]];

  resolvedRoboticInstrument = Which[
    (* If user-set, then use set value. *)
    MatchQ[Lookup[myOptions, RoboticInstrument], Except[Automatic | Null]],
    Lookup[myOptions, RoboticInstrument],
    (* If there is no user-set value, resolve to match the resolved WorkCell - see directly above *)
    MatchQ[resolvedWorkCell, bioSTAR],
    Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"], (* Model[Instrument, LiquidHandler, "bioSTAR"] *)
    True,
    Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"] (* Model[Instrument, LiquidHandler, "microbioSTAR"] *)
  ];

  (* Use convertCellComposition to update sample packets with any non (cell/mL) units converted into (cell/mL) if there is a standard curve. The majority cell composition could be defined in MapThread using samplePacketsWithConvertedCompositions *)
  samplePacketsWithConvertedCompositions = Experiment`Private`convertCellCompositions[samplePackets];

  {
    resolvedMethod,
    resolvedCellType,
    resolvedCultureAdhesion,
    resolvedCellIsolationTechnique,
    resolvedCellIsolationInstrument,
    resolvedCellAspirationVolume,
    resolvedCellIsolationTime,
    resolvedCellPelletIntensity,
    resolvedCellAspirationAngle,
    resolvedAliquotSourceMedia,
    resolvedAliquotMediaLabel,
    resolvedAliquotMediaVolume,
    resolvedAliquotMediaStorageCondition,
    resolvedNumberOfWashes,
    resolvedWashSolution,
    resolvedWashSolutionTemperature,
    resolvedWashSolutionEquilibrationTime,
    resolvedWashVolume,
    resolvedWashMixType,
    resolvedWashMixInstrument,
    resolvedWashMixTime,
    resolvedWashMixRate,
    resolvedNumberOfWashMixes,
    resolvedWashMixVolume,
    resolvedWashTemperature,
    resolvedWashAspirationVolume,
    resolvedWashIsolationTime,
    resolvedWashPelletIntensity,
    resolvedWashAspirationAngle,
    resolvedResuspensionMedia,
    resolvedResuspensionMediaTemperature,
    resolvedResuspensionMediaEquilibrationTime,
    resolvedResuspensionMediaVolume,
    resolvedResuspensionMixType,
    resolvedResuspensionTemperature,
    resolvedResuspensionMixInstrument,
    resolvedResuspensionMixTime,
    resolvedResuspensionMixRate,
    resolvedNumberOfResuspensionMixes,
    resolvedResuspensionMixVolume,
    resolvedReplateCells,
    resolvedSampleOutLabel,
    semiresolvedContainerOutModel,
    semiresolvedCellPelletContainerModel,
    semiresolvedSampleContainerModelAfterPelletPackets,
    semiresolvedAliquotMediaContainerModel,
    resolvedvolumeAfterAspiration,
    resolvedvolumeInWashing,
    resolvedvolumeAfterWashing,
    resolvedvolumeLimitWashing,
    resolvedvolumeInResuspension

  } = Transpose@MapThread[
    Function[{samplePacket, sampleContainerModelPacket, samplePacketsWithConvertedComposition, options},
      Module[{
        method,
        methodSpecifiedQ,
        methodPacket,
        volumeAfterAspiration,
        volumeInWashing,
        volumeAfterWashing,
        volumeLimitWashing,
        volumeInResuspension,
        cellPelletContainerModel,
        aliquotMediaContainerModel,
        sampleContainerModelAfterPelletPacket,
        majorityCellModel,
        cellModelPacket,
        cellType,
        cultureAdhesion,
        cellIsolationTechnique,
        cellIsolationInstrument,
        cellAspirationVolume,
        cellIsolationTime,
        cellPelletIntensity,
        cellAspirationAngle,
        aliquotSourceMedia,
        aliquotMediaLabel,
        aliquotMediaVolume,
        aliquotMediaStorageCondition,
        numberOfWashes,
        washSolution,
        washSolutionTemperature,
        washSolutionEquilibrationTime,
        washVolume,
        washMixType,
        washMixInstrument,
        washMixTime,
        washMixRate,
        numberOfWashMixes,
        washMixVolume,
        washTemperature,
        washAspirationVolume,
        washIsolationTime,
        washPelletIntensity,
        washAspirationAngle,
        resuspensionMedia,
        resuspensionMediaTemperature,
        resuspensionMediaEquilibrationTime,
        resuspensionMediaVolume,
        resuspensionMixType,
        resuspensionTemperature,
        resuspensionMixInstrument,
        resuspensionMixTime,
        resuspensionMixRate,
        numberOfResuspensionMixes,
        resuspensionMixVolume,
        replateCells,
        sampleOutLabel,
        containerOutModel
      },

        (* --- GENERAL --- *)
        (* Resolve Method *)
        method = If[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, Method], ObjectP[Object[Method]]],
          Lookup[options, Method],
          (* Otherwise, default to Custom *)
          Custom
        ];
        (* Write a method Boolean internal variable to switch on/off Method-specified options *)
        methodSpecifiedQ = MatchQ[method, Except[Custom]];
        (* Get the method packet that will be used for this sample if there is one *)
        methodPacket = If[
          MatchQ[method, Except[Custom]],
          fetchPacketFromFastAssoc[method, fastAssoc],
          <||>
        ];

        (* Resolve CellType *)
        cellType = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, CellType], Except[Automatic | Null]],
          Lookup[options, CellType],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, CellType] && MatchQ[Lookup[methodPacket, CellType], Except[Null]],
          Lookup[methodPacket, CellType],
          (* Use the value of the CellType field in Object[Sample], if any *)
          MatchQ[Lookup[samplePacket, CellType], CellTypeP],
          Lookup[samplePacket, CellType],
          (* If neither of the above apply, default to Bacterial and throw a warning *)
          True,
          Bacterial
        ];
        (* Resolve CultureAdhesion *)
        cultureAdhesion = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, CultureAdhesion], Except[Automatic | Null]],
          Lookup[options, CultureAdhesion],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, CultureAdhesion] && MatchQ[Lookup[methodPacket, CultureAdhesion], Except[Null]],
          Lookup[methodPacket, CultureAdhesion],
          (* Use the value of the CultureAdhesion field in Object[Sample], if any *)
          MatchQ[Lookup[samplePacket, CultureAdhesion], Except[Null]],
          Lookup[samplePacket, CultureAdhesion],
          (* If neither of the above apply, default to Adherent and throw an error *)
          True,
          Adherent
        ];

        (* Resolve CellIsolationTechnique *)
        cellIsolationTechnique = Which[
          MatchQ[Lookup[options, CellIsolationTechnique], CellIsolationTechniqueP],
          Lookup[options, CellIsolationTechnique],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, CellIsolationTechnique] && MatchQ[Lookup[methodPacket, CellIsolationTechnique], Except[Null]],
          Lookup[methodPacket, CellIsolationTechnique],
          (* If any Pellet Options Specified, set CellIsolationTechnique to Pellet *)
          MemberQ[Lookup[options, {CellIsolationInstrument, CellIsolationTime, CellPelletIntensity, WashIsolationTime, WashPelletIntensity}], Except[Automatic | Null]],
          Pellet,
          (* If any Aspirate Options Specified, set CellIsolationTechnique to Aspirate *)
          MemberQ[Lookup[options, {CellAspirationAngle, WashAspirationAngle}], Except[Automatic | Null]],
          Aspirate,
          (* These options tell us to use Aspirate. *)
          MatchQ[cultureAdhesion, Adherent],
          Aspirate,
          (* Otherwise, we use Pellet *)
          True,
          Pellet
        ];
        (* Resolve CellIsolationInstrument *)
        cellIsolationInstrument = Which[
          MatchQ[Lookup[options, CellIsolationInstrument], Except[Automatic]],
          Lookup[options, CellIsolationInstrument],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, CellIsolationInstrument] && MatchQ[Lookup[methodPacket, CellIsolationInstrument], Except[Null]],
          Lookup[methodPacket, CellIsolationInstrument],
          (* Pellet technique will use HiG4 *)
          MatchQ[cellIsolationTechnique, Pellet],
          Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"], (* Model[Instrument, Centrifuge, "HiG4"] *)
          (* Aspirate technique does not need instrument *)
          True,
          Null
        ];
        (* Resolve NumberOfWashes *)
        numberOfWashes = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, NumberOfWashes], Except[Automatic | Null]],
          Lookup[options, NumberOfWashes],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, NumberOfWashes] && MatchQ[Lookup[methodPacket, NumberOfWashes], Except[Null]],
          Lookup[methodPacket, NumberOfWashes],
          (* In ExperimentChangeMedia, if any wash options set to Null, NumberOfWashes resolves to 0 *)
          MatchQ[myFunction, ExperimentChangeMedia] && !MemberQ[Lookup[options, $WashingOptions], Except[Automatic | Null]],
          0,
          (* If Adherent, NumberOfWashes resolves to 3 *)
          MatchQ[cultureAdhesion, Adherent],
          3,
          (* Otherwise, set to 2 *)
          True,
          2
        ];

        (* --- Media Aspiration --- *)

        (* Resolve CellAspirationVolume *)
        cellAspirationVolume = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, CellAspirationVolume], Except[Automatic]],
          Lookup[options, CellAspirationVolume],
          (* If cultureAdhesion is Suspension then automatically set cellAspirationVolume to 85% of the sample volume *)
          MatchQ[cultureAdhesion, Suspension] && MatchQ[Lookup[samplePacket, Volume], VolumeP],
          SafeRound[0.85 * (Lookup[samplePacket, Volume]), 1 Microliter],
          (* Otherwise, set cellAspirationVolume to all the sample volume *)
          True,
          All
        ];
        volumeAfterAspiration = If[
          MatchQ[cellAspirationVolume, All],
          0,
          Max[Lookup[samplePacket, Volume] - cellAspirationVolume, 1 Microliter]
        ];

        (* Resolve CellIsolationTime *)
        cellIsolationTime = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, CellIsolationTime], Except[Automatic]],
          Lookup[options, CellIsolationTime],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, CellIsolationTime] && MatchQ[Lookup[methodPacket, CellIsolationTime], Except[Null]],
          Lookup[methodPacket, CellIsolationTime],
          (* if cellRemovalTechnique is Pellet, resolve to 10 Minute. *)
          MatchQ[cellIsolationTechnique, Pellet],
          10 Minute,
          (* otherwise, resolve to Null *)
          True,
          Null
        ];
        (* Resolve CellPelletIntensity *)
        cellPelletIntensity = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, CellPelletIntensity], Except[Automatic]],
          Lookup[options, CellPelletIntensity],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, CellPelletIntensity] && MatchQ[Lookup[methodPacket, CellPelletIntensity], Except[Null]],
          Lookup[methodPacket, CellPelletIntensity],
          (* if cellRemovalTechnique is not Pellet, resolve to Null. *)
          MatchQ[cellIsolationTechnique, Except[Pellet]],
          Null,
          (* Otherwise, resolve to match the default $Constant for the resolved cellType *)
          MatchQ[cellType, Mammalian],
          1560 RPM, (* $LivingMammalianCentrifugeIntensity, 300 g *)
          MatchQ[cellType, Yeast],
          2850 RPM, (* $LivingYeastCentrifugeIntensity, 1000 g *)
          True,
          4030 RPM (* $LivingBacterialCentrifugeIntensity, 2000 g *)
        ];
        (* Resolve CellAspirationAngle *)
        cellAspirationAngle = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, CellAspirationAngle], Except[Automatic]],
          Lookup[options, CellAspirationAngle],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, CellAspirationAngle] && MatchQ[Lookup[methodPacket, CellAspirationAngle], Except[Null]],
          Lookup[methodPacket, CellAspirationAngle],
          (* if cellRemovalTechnique is Aspirate, resolve to $MaxRoboticAspirationAngle. *)
          MatchQ[cellIsolationTechnique, Aspirate] && MatchQ[Lookup[sampleContainerModelPacket, Footprint], Plate],
          $MaxRoboticAspirationAngle, (* 10 AngularDegree *)
          (* if cellRemovalTechnique is Aspirate but the sample in not in a plate, it cannot be tilted *)
          MatchQ[cellIsolationTechnique, Aspirate] && MatchQ[Lookup[sampleContainerModelPacket, Footprint], Except[Plate]],
          0 AngularDegree,
          (* otherwise, resolve to Null. *)
          True,
          Null
        ];
        (* Resolve AliquotSourceMedia *)
        aliquotSourceMedia = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, AliquotSourceMedia], Except[Null | Automatic]],
          Lookup[options, AliquotSourceMedia],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, AliquotSourceMedia] && MatchQ[Lookup[methodPacket, AliquotSourceMedia], Except[Null]],
          Lookup[methodPacket, AliquotSourceMedia],
          (* Otherwise, are any aliquot options specified by the user? If so, then resolve to True. *)
          MemberQ[Lookup[options, $AliquotSourceMediaOptions], Except[Automatic | Null]],
          True,
          (* otherwise, resolve to False. *)
          True,
          False
        ];

        (* Resolve AliquotMediaLabel *)
        aliquotMediaLabel = Which[
          (* Use the user-specified label, if any *)
          MatchQ[Lookup[options, AliquotMediaLabel], Except[Null | Automatic]],
          Lookup[options, AliquotMediaLabel],
          (* If the label is not user-specified but PreLysisPellet is True, make a new label for this sample *)
          MatchQ[aliquotSourceMedia, True],
          CreateUniqueLabel["wash cells source media", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels],
          (* Otherwise, set this to Null *)
          True,
          Null
        ];

        (* Pre-Resolve AliquotMediaContainerModel *)
        aliquotMediaContainerModel = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, AliquotMediaContainer], Except[Automatic]],
          Lookup[options, AliquotMediaContainer],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, AliquotMediaContainer] && MatchQ[Lookup[methodPacket, AliquotMediaContainer], Except[Null]],
          Lookup[methodPacket, AliquotMediaContainer],
          (* Otherwise, aliquotSourceMedia true? If so, then resolve to Automatic. *)
          MatchQ[aliquotSourceMedia, True],
          Automatic,
          (* otherwise, resolve to Null *)
          True,
          Null
        ];

        (* Resolve AliquotMediaVolume *)
        aliquotMediaVolume = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, AliquotMediaVolume], Except[Automatic]] && MatchQ[Lookup[options, AliquotMediaVolume], Except[All]],
          Lookup[options, AliquotMediaVolume],
          (* Otherwise, aliquotSourceMedia false? If so, then resolve to Null. *)
          MatchQ[aliquotSourceMedia, False],
          Null,
          (* Otherwise, resolve to cellAspirationVolume *)
          True,
          If[MatchQ[cellAspirationVolume, All],
            (* All option will lead errors in Transfer UnitOperation if there are sequential transfer steps *)
            Lookup[samplePacket, Volume],
            cellAspirationVolume
          ]
        ];

        (* Resolve AliquotMediaStorageCondition *)
        aliquotMediaStorageCondition = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, AliquotMediaStorageCondition], Except[Automatic]],
          Lookup[options, AliquotMediaStorageCondition],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, AliquotMediaStorageCondition] && MatchQ[Lookup[methodPacket, AliquotMediaStorageCondition], Except[Null]],
          Lookup[methodPacket, AliquotMediaStorageCondition],
          (* Otherwise, aliquotSourceMedia true? If so, then resolve to Freezer. *)
          MatchQ[aliquotSourceMedia, True],
          Freezer,
          (* otherwise, resolve to Null *)
          True,
          Null
        ];


        (* --- Washing --- *)

        (* Resolve WashSolution *)
        washSolution = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, WashSolution], Except[Automatic]],
          Lookup[options, WashSolution],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, WashSolution] && MatchQ[Lookup[methodPacket, WashSolution], Except[Null]],
          Lookup[methodPacket, WashSolution],
          (* If numberOfWashes is greater than 0, default to 1x PBS buffer as the washSolution *)
          MatchQ[numberOfWashes, GreaterP[0]],
          Model[Sample, StockSolution, "id:9RdZXv1KejGK"], (* Model[Sample, StockSolution, "1x PBS from 10X stock"] *)
          (* Otherwise, resolves to Null *)
          True,
          Null
        ];

        majorityCellModel = Module[{cellCompositions, sampleCompositions, cellConcentrationCompatibleP},

          cellConcentrationCompatibleP = PercentConfluencyP | CellConcentrationP | CFUConcentrationP | OD600P;
          (* NOTE: We converted all of the cell units to (cell/mL) before the MapThread, if we could. *)
          sampleCompositions = Lookup[samplePacketsWithConvertedComposition, Composition];
          cellCompositions = Cases[sampleCompositions, {cellConcentrationCompatibleP, ObjectP[]}];

          Which[
            (* If none of the Compositions is cellConcentrationCompatibleP, return Null *)
            MatchQ[cellCompositions, {}],
            Null,
            (* If only one of them has the cellConcentrationCompatibleP, use that as majorityCellModel *)
            MatchQ[Length[cellCompositions], 1],
            Last[First[cellCompositions]],
            (* If there are multiple components, and they have same unit, use the max one as majorityCellModel *)
            SameQ @@ Units[cellCompositions[[All, 1]]],
            Last[FirstCase[cellCompositions, {EqualP[Max[cellCompositions[[All, 1]]]], ObjectP[]}]],

            (* Otherwise, just take the first cell model from the first cell composition entry. *)
            True,
            Last[First[cellCompositions]]
          ]
        ];
        cellModelPacket = If[
          (* If there is a majority cell model, use that *)
          MatchQ[majorityCellModel, ObjectP[]],
          fetchPacketFromFastAssoc[majorityCellModel, fastAssoc],
          <||>
        ];

        (* Resolve WashSolutionTemperature *)
        washSolutionTemperature = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, WashSolutionTemperature], Except[Automatic]],
          Lookup[options, WashSolutionTemperature],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, WashSolutionTemperature] && MatchQ[Lookup[methodPacket, WashSolutionTemperature], Except[Null]],
          Lookup[methodPacket, WashSolutionTemperature],
          (* If numberOfWashes is 0, resolves to Null *)
          MatchQ[numberOfWashes, 0],
          Null,
          (* Otherwise, set to Ambient *)
          True,
          Ambient
        ];
        (* Resolve WashSolutionEquilibrationTime *)
        washSolutionEquilibrationTime = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, WashSolutionEquilibrationTime], Except[Automatic]],
          Lookup[options, WashSolutionEquilibrationTime],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, WashSolutionEquilibrationTime] && MatchQ[Lookup[methodPacket, WashSolutionEquilibrationTime], Except[Null]],
          Lookup[methodPacket, WashSolutionEquilibrationTime],
          (* If washSolutionTemperature is Null, resolves to Null *)
          MatchQ[washSolutionTemperature, Null],
          Null,
          (* Otherwise, resolve to the result of the function *)
          True,
          10 Minute
        ];

        cellPelletContainerModel = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, CellPelletContainer], Except[Automatic]],
          Lookup[options, CellPelletContainer],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, CellPelletContainer] && MatchQ[Lookup[methodPacket, CellPelletContainer], Except[Null]],
          Lookup[methodPacket, CellPelletContainer],
          MatchQ[cellIsolationTechnique, Aspirate],
          Null,
          MatchQ[Lookup[sampleContainerModelPacket, Footprint], Plate],
          Null,
          True,
          PreferredContainer[Lookup[samplePacket, Volume], LiquidHandlerCompatible -> True, Type -> Plate]
        ];
        sampleContainerModelAfterPelletPacket = Which[
          MatchQ[cellPelletContainerModel, Except[Null]],
          fetchModelPacketFromFastAssoc[cellPelletContainerModel, fastAssoc], (* User specified index*)
          True,
          sampleContainerModelPacket
        ];

        (* Resolve WashVolume *)
        washVolume = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, WashVolume], Except[Automatic]],
          Lookup[options, WashVolume],
          (* If NumberOfWashes is greater than 0, set the washVolume to be the same as cellAspirationVolume so the total volume is unchanged during washing *)
          MatchQ[numberOfWashes, GreaterP[0]] && MatchQ[cellAspirationVolume, All],
          Lookup[samplePacket, Volume],
          MatchQ[numberOfWashes, GreaterP[0]],
          cellAspirationVolume,
          (* Otherwise, resolves to Null *)
          True,
          Null
        ];
        volumeInWashing = If[MatchQ[washVolume, Null],
          volumeAfterAspiration,
          washVolume + volumeAfterAspiration];

        (* Resolve WashMixType *)
        washMixType = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, WashMixType], Except[Automatic]],
          Lookup[options, WashMixType],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, WashMixType] && MatchQ[Lookup[methodPacket, WashMixType], Except[Null]],
          Lookup[methodPacket, WashMixType],
          (* If NumberOfWashes is 0, resolves to Null *)
          MatchQ[numberOfWashes, 0],
          Null,
          (* Automatically set to Shake if $WashShakeOptions is specified *)
          MemberQ[Lookup[options, $WashShakeOptions], Except[Automatic | Null]],
          Shake,
          (* Automatically set to Pipette if $WashPipetteOptions is specified *)
          MemberQ[Lookup[options, $WashPipetteOptions], Except[Automatic | Null]],
          Pipette,
          (* Set to Shake if cultureAdhesion is Adherent *)
          MatchQ[cultureAdhesion, Adherent],
          Shake,
          (* Otherwise, set to Pipette *)
          True,
          Pipette

        ];
        (* Resolve WashMixInstrument *)
        washMixInstrument = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, WashMixInstrument], Except[Automatic]],
          Lookup[options, WashMixInstrument],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, WashMixInstrument] && MatchQ[Lookup[methodPacket, WashMixInstrument], Except[Null]],
          Lookup[methodPacket, WashMixInstrument],
          (* If WashMixType is Shake, resolves to Inheco ThermoshakeAC *)
          MatchQ[washMixType, Shake],
          Model[Instrument, Shaker, "id:pZx9jox97qNp"], (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
          (* Otherwise, resolves to Null *)
          True,
          Null
        ];
        (* Resolve WashMixRate *)
        washMixRate = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, WashMixRate], Except[Automatic]],
          Lookup[options, WashMixRate],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, WashMixRate] && MatchQ[Lookup[methodPacket, WashMixRate], Except[Null]],
          Lookup[methodPacket, WashMixRate],
          (* If WashMixType is Shake, resolves to 200 RPM *)
          MatchQ[washMixType, Shake],
          200 RPM,
          (* Otherwise, resolves to Null *)
          True,
          Null
        ];
        (* Resolve WashMixTime *)
        washMixTime = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, WashMixTime], Except[Automatic]],
          Lookup[options, WashMixTime],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, WashMixTime] && MatchQ[Lookup[methodPacket, WashMixTime], Except[Null]],
          Lookup[methodPacket, WashMixTime],
          (* If mixType is Shake, resolves to 1 Minute *)
          MatchQ[washMixType, Shake],
          1 Minute,
          (* Otherwise, resolves to Null *)
          True,
          Null
        ];
        (* Resolve WashMixVolume *)
        washMixVolume = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, WashMixVolume], Except[Automatic]],
          Lookup[options, WashMixVolume],

          (* If washMixType is Pipette, WashMixVolume is the lesser of: $MaxRoboticSingleTransferVolume or 50% of the washVolume *)
          MatchQ[washMixType, Pipette],
          Min[
            $MaxRoboticSingleTransferVolume,
            SafeRound[0.50 * washVolume, 1 Microliter]
          ],
          (* Otherwise, resolves to Null *)
          True,
          Null
        ];
        (* Resolve NumberOfWashMixes *)
        numberOfWashMixes = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, NumberOfWashMixes], Except[Automatic]],
          Lookup[options, NumberOfWashMixes],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, NumberOfWashMixes] && MatchQ[Lookup[methodPacket, NumberOfWashMixes], Except[Null]],
          Lookup[methodPacket, NumberOfWashMixes],
          (* If mixType is Pipette, resolves to the lesser of: 50, 5 * washVolume/washMixVolume *)
          MatchQ[washMixType, Pipette],
          Min[
            50,
            Ceiling[5 * washVolume / washMixVolume]
          ],
          (* Otherwise, resolves to Null *)
          True,
          Null
        ];

        (* Resolve WashTemperature *)
        washTemperature = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, WashTemperature], Except[Automatic]],
          Lookup[options, WashTemperature],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, WashTemperature] && MatchQ[Lookup[methodPacket, WashTemperature], Except[Null]],
          Lookup[methodPacket, WashTemperature],
          (* If mixType is Shake, resolves to washSolutionTemperature *)
          MatchQ[washMixType, Shake],
          washSolutionTemperature,
          (* Otherwise, resolves to Null *)
          True,
          Null
        ];
        (* Resolve WashAspirationVolume *)
        washAspirationVolume = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, WashAspirationVolume], Except[Automatic]],
          Lookup[options, WashAspirationVolume],
          (* If numberOfWashes is 0, resolves to Null *)
          MatchQ[numberOfWashes, 0],
          Null,
          (* Otherwise, set washAspirationVolume to all the washVolume *)
          True,
          washVolume
        ];
        volumeAfterWashing = If[
          MatchQ[washAspirationVolume, All],
          0,
          If[MatchQ[washAspirationVolume, Null],
            volumeInWashing,
            volumeInWashing - washAspirationVolume
          ]
        ];
        volumeLimitWashing = Which[
          MatchQ[washVolume, Null],
          volumeAfterAspiration,
          MatchQ[washAspirationVolume, Null],
          volumeAfterAspiration + numberOfWashes * washVolume,
          MatchQ[washAspirationVolume, All],
          volumeAfterAspiration,
          True,
          volumeAfterAspiration + numberOfWashes * (washVolume - washAspirationVolume)
        ];

        (* Resolve WashIsolationTime *)
        washIsolationTime = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, WashIsolationTime], Except[Automatic]],
          Lookup[options, WashIsolationTime],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, WashIsolationTime] && MatchQ[Lookup[methodPacket, WashIsolationTime], Except[Null]],
          Lookup[methodPacket, WashIsolationTime],
          (* If numberOfWashes is 0, resolves to Null *)
          MatchQ[numberOfWashes, 0],
          Null,
          (* if cellRemovalTechnique is Pellet (we don't have washIsolationTechnique be consistent with the IsolationTechnique), resolve to the same as cellIsolationTime *)
          MatchQ[cellIsolationTechnique, Pellet],
          cellIsolationTime,
          (* otherwise, resolve to Null. *)
          True,
          Null
        ];
        (* Resolve WashPelletIntensity *)
        washPelletIntensity = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, WashPelletIntensity], Except[Automatic]],
          Lookup[options, WashPelletIntensity],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, WashPelletIntensity] && MatchQ[Lookup[methodPacket, WashPelletIntensity], Except[Null]],
          Lookup[methodPacket, WashPelletIntensity],
          (* If numberOfWashes is 0, resolves to Null *)
          MatchQ[numberOfWashes, 0],
          Null,
          (* if cellRemovalTechnique is Pellet, resolve to the same as cellPelletIntensity *)
          MatchQ[cellIsolationTechnique, Pellet],
          cellPelletIntensity,
          (* otherwise, resolve to Null. *)
          True,
          Null
        ];
        (* Resolve WashAspirationAngle *)
        washAspirationAngle = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, WashAspirationAngle], Except[Automatic]],
          Lookup[options, WashAspirationAngle],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, WashAspirationAngle] && MatchQ[Lookup[methodPacket, WashAspirationAngle], Except[Null]],
          Lookup[methodPacket, WashAspirationAngle],
          (* If numberOfWashes is 0, resolves to Null *)
          MatchQ[numberOfWashes, 0],
          Null,
          (* if cellRemovalTechnique is Pellet, resolve to the same as cellAspirationAngle *)
          MatchQ[cellIsolationTechnique, Aspirate],
          cellAspirationAngle,
          (* otherwise, resolve to Null. *)
          True,
          Null
        ];

        (* --- Media Replenishment --- *)

        (* Resolve ResuspensionMedia *)
        resuspensionMedia = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, ResuspensionMedia], Except[Automatic | Null]],
          Lookup[options, ResuspensionMedia],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, ResuspensionMedia] && MatchQ[Lookup[methodPacket, ResuspensionMedia], Except[Null]],
          Lookup[methodPacket, ResuspensionMedia],
          (* If Media is not Null, resolves to Media of input sample object *)
          MatchQ[Lookup[samplePacket, Media], Except[Null]],
          Lookup[samplePacket, Media][Object],
          (* If Media of input sample object is Null, resolves to PreferredLiquidMedia of sample model object *)
          KeyExistsQ[cellModelPacket, PreferredLiquidMedia] && MatchQ[Lookup[cellModelPacket, PreferredLiquidMedia], Except[Null]],
          Lookup[cellModelPacket, PreferredLiquidMedia][Object],
          (* otherwise, resolve to Null. *)
          True,
          Model[Sample, Media, "id:N80DNjlYwV16"] (* Model[Sample, "DMEM + 10% FBS + 4.0 g/L Glucose + 0.0134 g/L Phenol Red + L-Glutamine, with no Pyruvate"] *)
        ];
        (* Resolve ResuspensionMediaTemperature *)
        resuspensionMediaTemperature = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, ResuspensionMediaTemperature], Except[Automatic]],
          Lookup[options, ResuspensionMediaTemperature],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, ResuspensionMediaTemperature] && MatchQ[Lookup[methodPacket, ResuspensionMediaTemperature], Except[Null]],
          Lookup[methodPacket, ResuspensionMediaTemperature],
          (* If resuspensionMedia is None, resolves to Null *)
          MatchQ[resuspensionMedia, None],
          Null,
          (* Otherwise, set to Ambient *)
          True,
          Ambient
        ];
        (* Resolve ResuspensionMediaEquilibrationTime *)
        resuspensionMediaEquilibrationTime = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, ResuspensionMediaEquilibrationTime], Except[Automatic]],
          Lookup[options, ResuspensionMediaEquilibrationTime],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, ResuspensionMediaEquilibrationTime] && MatchQ[Lookup[methodPacket, ResuspensionMediaEquilibrationTime], Except[Null]],
          Lookup[methodPacket, ResuspensionMediaEquilibrationTime],
          (* If resuspensionMediaTemperature is Null, resolves to Null *)
          MatchQ[resuspensionMediaTemperature, Null],
          Null,
          (* Otherwise, resolve to the result of the function *)
          True,
          10 Minute
        ];
        (* Resolve ResuspensionMediaVolume *)
        resuspensionMediaVolume = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, ResuspensionMediaVolume], Except[Automatic]],
          Lookup[options, ResuspensionMediaVolume],
          (* If resuspensionMedia is not Null, set final volume to the larger of 80% of capacity of the container and 1 Milliliter *)
          MatchQ[resuspensionMedia, Except[None]],
          Max[SafeRound[0.80 * (Lookup[sampleContainerModelAfterPelletPacket, MaxVolume]) - volumeLimitWashing, 1 Microliter], 1 Microliter],
          (* Otherwise, resolves to Null *)
          True,
          Null
        ];
        volumeInResuspension = If[MatchQ[resuspensionMediaVolume, Null],
          volumeLimitWashing,
          volumeLimitWashing + resuspensionMediaVolume];

        (* Resolve ResuspensionMixType *)
        resuspensionMixType = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, ResuspensionMixType], Except[Automatic]],
          Lookup[options, ResuspensionMixType],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, ResuspensionMixType] && MatchQ[Lookup[methodPacket, ResuspensionMixType], Except[Null]],
          Lookup[methodPacket, ResuspensionMixType],
          (* If resuspensionMedia is None, resolves to Null *)
          MatchQ[resuspensionMedia, None],
          Null,
          (* Automatically set to Shake if $WashShakeOptions is specified. *)
          MemberQ[Lookup[options, $ResuspensionShakeOptions], Except[Automatic | Null]],
          Shake,
          (* Automatically set to Pipette if $WashPipetteOptions is specified. *)
          MemberQ[Lookup[options, $ResuspensionPipetteOptions], Except[Automatic | Null]],
          Pipette,
          (* Set to Shake if cultureAdhesion is Adherent *)
          MatchQ[cultureAdhesion, Adherent],
          Shake,
          (* Otherwise, do not mix *)
          True,
          Pipette
        ];

        (* Resolve ResuspensionMixInstrument *)
        resuspensionMixInstrument = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, ResuspensionMixInstrument], Except[Automatic]],
          Lookup[options, ResuspensionMixInstrument],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, ResuspensionMixInstrument] && MatchQ[Lookup[methodPacket, ResuspensionMixInstrument], Except[Null]],
          Lookup[methodPacket, ResuspensionMixInstrument],
          (* If resuspensionMixType is Shake, resolves to Inheco ThermoshakeAC *)
          MatchQ[resuspensionMixType, Shake],
          Model[Instrument, Shaker, "id:pZx9jox97qNp"], (* Model[Instrument, Shaker, "Inheco ThermoshakeAC"] *)
          (* Otherwise, resolves to Null *)
          True,
          Null
        ];
        (* Resolve ResuspensionMixRate *)
        resuspensionMixRate = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, ResuspensionMixRate], Except[Automatic]],
          Lookup[options, ResuspensionMixRate],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, ResuspensionMixRate] && MatchQ[Lookup[methodPacket, ResuspensionMixRate], Except[Null]],
          Lookup[methodPacket, ResuspensionMixRate],
          (* If ResuspensionMixType is Shake, resolves to 200 RPM *)
          MatchQ[resuspensionMixType, Shake],
          200 RPM,
          (* Otherwise, resolves to Null *)
          True,
          Null
        ];
        (* Resolve ResuspensionMixTime *)
        resuspensionMixTime = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, ResuspensionMixTime], Except[Automatic]],
          Lookup[options, ResuspensionMixTime],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, ResuspensionMixTime] && MatchQ[Lookup[methodPacket, ResuspensionMixTime], Except[Null]],
          Lookup[methodPacket, ResuspensionMixTime],
          (* If resuspensionMixType is Shake, resolves to 1 Minute *)
          MatchQ[resuspensionMixType, Shake],
          1 Minute,
          (* Otherwise, resolves to Null *)
          True,
          Null
        ];
        (* Resolve ResuspensionMixVolume *)
        resuspensionMixVolume = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, ResuspensionMixVolume], Except[Automatic]],
          Lookup[options, ResuspensionMixVolume],

          (* If resuspensionMixType is Pipette, ResuspensionMixVolume is the lesser of: $MaxRoboticSingleTransferVolume or 50% of the resuspensionMediaVolume *)
          MatchQ[resuspensionMixType, Pipette],
          Min[
            $MaxRoboticSingleTransferVolume,
            SafeRound[0.50 * resuspensionMediaVolume, 1 Microliter]
          ],
          (* Otherwise, resolves to Null *)
          True,
          Null
        ];
        (* Resolve NumberOfResuspensionMixes *)
        numberOfResuspensionMixes = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, NumberOfResuspensionMixes], Except[Automatic]],
          Lookup[options, NumberOfResuspensionMixes],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, NumberOfResuspensionMixes] && MatchQ[Lookup[methodPacket, NumberOfResuspensionMixes], Except[Null]],
          Lookup[methodPacket, NumberOfResuspensionMixes],
          (* If mixType is Pipette, resolves to the lesser of: 50, 5 * resuspensionMediaVolume/resuspensionMixVolume *)
          MatchQ[resuspensionMixType, Pipette],
          Min[
            50,
            Ceiling[5 * resuspensionMediaVolume / resuspensionMixVolume]
          ],
          (* Otherwise, resolves to Null *)
          True,
          Null
        ];
        (* Resolve ResuspensionTemperature *)
        resuspensionTemperature = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, ResuspensionTemperature], Except[Automatic]],
          Lookup[options, ResuspensionTemperature],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, ResuspensionTemperature] && MatchQ[Lookup[methodPacket, ResuspensionTemperature], Except[Null]],
          Lookup[methodPacket, ResuspensionTemperature],
          (* If mixType is Pipette, resolves to washSolutionTemperature *)
          MatchQ[resuspensionMixType, Shake],
          resuspensionMediaTemperature,
          (* Otherwise, resolves to Null *)
          True,
          Null
        ];
        (* Resolve ReplateCells *)
        replateCells = Which[
          (* Use the user-specified values, if any *)
          MatchQ[Lookup[options, ReplateCells], Except[Automatic]],
          Lookup[options, ReplateCells],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, ReplateCells] && MatchQ[Lookup[methodPacket, ReplateCells], Except[Null]],
          Lookup[methodPacket, ReplateCells],
          (* If resuspensionMedia is None, resolves to Null *)
          MatchQ[resuspensionMedia, None],
          Null,
          (* If cultureAdhesion is Adherent, resolves to False *)
          MatchQ[cultureAdhesion, Adherent],
          False,
          (* If ContainerOut is not Null, set to True *)
          MatchQ[Lookup[options, ContainerOut], Except[Null]],
          True,
          (* Otherwise, do not use a new plate *)
          True,
          False
        ];
        (* Resolve SampleOutLabel *)
        sampleOutLabel = Which[
          (* Use the user-specified label, if any *)
          MatchQ[Lookup[options, SampleOutLabel], Except[Null | Automatic]],
          Lookup[options, SampleOutLabel],
          (* Otherwise, make a new label for this sample *)
          True,
          CreateUniqueLabel["wash cells sample out", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels]
        ];

        (* Pre-Resolve ContainerOutModel *)
        containerOutModel = Which[
          (* If the user specified it, then set it to what they specified *)
          MatchQ[Lookup[options, ContainerOut], Except[Automatic]],
          Lookup[options, ContainerOut],
          (* Use the Method-specified values, if any *)
          methodSpecifiedQ && KeyExistsQ[methodPacket, ContainerOut] && MatchQ[Lookup[methodPacket, ContainerOut], Except[Null]],
          Lookup[methodPacket, ContainerOut],
          (* Otherwise, resuspensionMedia none? If so, then resolve to Null. *)
          MatchQ[resuspensionMedia, None],
          Null,
          (* otherwise, replateCells False? If so, then resolve to Null. *)
          MatchQ[replateCells, False | Null],
          Null,
          (* Otherwise, resolve to Automatic for now*)
          True,
          Automatic
        ];


        {
          method,
          cellType,
          cultureAdhesion,
          cellIsolationTechnique,
          cellIsolationInstrument,
          cellAspirationVolume,
          cellIsolationTime,
          cellPelletIntensity,
          cellAspirationAngle,
          aliquotSourceMedia,
          aliquotMediaLabel,
          aliquotMediaVolume,
          aliquotMediaStorageCondition,
          numberOfWashes,
          washSolution,
          washSolutionTemperature,
          washSolutionEquilibrationTime,
          washVolume,
          washMixType,
          washMixInstrument,
          washMixTime,
          washMixRate,
          numberOfWashMixes,
          washMixVolume,
          washTemperature,
          washAspirationVolume,
          washIsolationTime,
          washPelletIntensity,
          washAspirationAngle,
          resuspensionMedia,
          resuspensionMediaTemperature,
          resuspensionMediaEquilibrationTime,
          resuspensionMediaVolume,
          resuspensionMixType,
          resuspensionTemperature,
          resuspensionMixInstrument,
          resuspensionMixTime,
          resuspensionMixRate,
          numberOfResuspensionMixes,
          resuspensionMixVolume,
          replateCells,
          sampleOutLabel,
          containerOutModel,
          cellPelletContainerModel,
          sampleContainerModelAfterPelletPacket,
          aliquotMediaContainerModel,
          volumeAfterAspiration,
          volumeInWashing,
          volumeAfterWashing,
          volumeLimitWashing,
          volumeInResuspension
        }

      ]
    ],
    {samplePackets, sampleContainerModelPackets, samplePacketsWithConvertedCompositions, mapThreadFriendlyOptions}
  ];

  (* Resolve CellPelletContainer *)
  {
    resolvedCellPelletContainer,
    resolvedCellPelletContainerWells
  } = Module[
    {highestUserSpecifiedCellPelletContainerIndex, cellPelletContainerQ},
    highestUserSpecifiedCellPelletContainerIndex = Max[{
      0,
      Cases[Flatten[{Lookup[listedOptions, {CellPelletContainer}]}], _Integer]
    }];

    (* Function to resolve if samples will be packed: If IsolationTechnique is not Pellet or sample use the input container, we do not pack *)
    cellPelletContainerQ = If[MatchQ[#, Null], False, True]& /@ semiresolvedCellPelletContainerModel;

    PackContainers[
      (* semiresolvedCellPelletContainers: Null or PreferredContainer-Plate *)
      semiresolvedCellPelletContainerModel,
      (* list of booleans indicating whether aliquoting into a plate is necessary. Notice: When set to True, it will resolve a container even semiresolvedContainerModel is Null *)
      cellPelletContainerQ,
      (* minimum required volumes for the aliquot containers *)
      Lookup[samplePackets, Volume],
      (* a list (or a list of lists) of experiment parameters to group by *)
      {resolvedWashTemperature,
        resolvedResuspensionTemperature,
        resolvedWashMixType,
        resolvedResuspensionMixType,
        resolvedWashMixRate,
        resolvedResuspensionMixRate},
      (* number of replicates for the experiment *)
      NumberOfReplicates -> 1,
      (* highest container index specified by the user *)
      FirstNewContainerIndex -> highestUserSpecifiedCellPelletContainerIndex + 1
    ]

  ];

  (* Resolve AliquotMediaContainer *)
  {
    resolvedAliquotMediaContainer,
    resolvedAliquotMediaContainerWells
  } = Module[
    {highestUserSpecifiedAliquotMediaContainerIndex, AliquotMediaContainerQ, postresolvedAliquotMediaVolume},
    highestUserSpecifiedAliquotMediaContainerIndex = Max[{
      0,
      Cases[Flatten[{Lookup[listedOptions, {AliquotMediaContainer}]}], _Integer]
    }];
    postresolvedAliquotMediaVolume = MapThread[
      Function[{aliquotMediaVolume, cellAspirationVolume, samplePacket},
        Which[
          MatchQ[aliquotMediaVolume, Except[All]],
          aliquotMediaVolume,
          MatchQ[cellAspirationVolume, Except[All]],
          cellAspirationVolume,
          MatchQ[Lookup[samplePacket, Volume], VolumeP],
          Lookup[samplePacket, Volume],
          True,
          1 Microliter
        ]
      ],
      {resolvedAliquotMediaVolume, resolvedCellAspirationVolume, samplePackets}
    ];

    AliquotMediaContainerQ = AliquotIntoPlateQ[
      semiresolvedAliquotMediaContainerModel, (* semiresolvedAliquotMediaContainerModel: Null or Automatic or user-specified container *)
      resolvedAliquotSourceMedia, (*resolved aliquot Booleans*)
      Null, (*resolved centrifuge Booleans or Null*)
      Null, (*resolved mix types or Null*)
      Null (*resolved temperatures or Null*)
    ];
    PackContainers[
      semiresolvedAliquotMediaContainerModel, (* semiresolvedAliquotMediaContainerModel: Null or Automatic or user-specified container *)
      AliquotMediaContainerQ, (* list of booleans indicating whether aliquoting into a plate is necessary *)
      postresolvedAliquotMediaVolume, (* minimum required volumes for the aliquot containers *)
      resolvedAliquotMediaStorageCondition, (* a list (or a list of lists) of experiment parameters to group by *)
      NumberOfReplicates -> 1, (* number of replicates for the experiment *)
      FirstNewContainerIndex -> highestUserSpecifiedAliquotMediaContainerIndex + 1 (* highest container index specified by the user *)
    ]
  ];

  (* Get all of the user specified labels *)
  userSpecifiedLabels = DeleteDuplicates@Cases[
    Flatten@Lookup[
      listedOptions,
      {AliquotMediaContainerLabel, ContainerOutLabel, AliquotMediaLabel}
    ],
    _String
  ];

  (* Resolve AliquotMediaContainerLabel *)
  resolvedAliquotMediaContainerLabel = Module[
    {containersToGroupedLabels, containersToUserSpecifiedLabels, preResolvedAliquotMediaContainerLabel},

    (* normalized version resolvedAliquotMediaContainer and use the normalized format in the following *)

    (* This is in the format <|object1 -> {label1, label1}, object2 -> {label2, label2, Null}|> *)
    containersToGroupedLabels = GroupBy[
      Rule @@@ Transpose[{resolvedAliquotMediaContainer, Lookup[listedOptions, AliquotMediaContainerLabel]}],
      First -> Last
    ];

    (* Model[Container]s are unique containers and therefore don't need shared labels. *)
    containersToUserSpecifiedLabels = (#[[1]] -> FirstCase[#[[2]], _String, Null]&) /@ Normal[containersToGroupedLabels];

    preResolvedAliquotMediaContainerLabel = MapThread[
      Function[{aliquotMediaContainer, userSpecifiedLabel, aliquotSourceMedia},
        Which[
          (* If we're not pelleting prior to lysis, we don't produce a pellet and we don't need a container label *)
          MatchQ[aliquotSourceMedia, False],
          Null,
          (* User specified the option. *)
          MatchQ[userSpecifiedLabel, _String],
          userSpecifiedLabel,
          (* All Model[Container]s are unique. *)
          MatchQ[aliquotMediaContainer, ObjectP[Model[Container]]],
          CreateUniqueLabel["wash cells source media container", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels],
          (* User specified the option for another index and AliquotSourceMedia is True. *)
          MatchQ[Lookup[containersToUserSpecifiedLabels, Key[aliquotMediaContainer]], _String] && aliquotSourceMedia,
          Lookup[containersToUserSpecifiedLabels, Key[aliquotMediaContainer]],
          (* We need to make a new label for this object. *)
          aliquotSourceMedia,
          Module[{},
            containersToUserSpecifiedLabels = ReplaceRule[
              containersToUserSpecifiedLabels,
              aliquotMediaContainer -> CreateUniqueLabel["wash cells source media container", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels]
            ];
            Lookup[containersToUserSpecifiedLabels, Key[aliquotMediaContainer]]
          ]
        ]
      ],
      {resolvedAliquotMediaContainer, Lookup[listedOptions, AliquotMediaContainerLabel], resolvedAliquotSourceMedia}
    ]
  ];


  {
    resolvedContainerOut,
    resolvedContainerOutWells
  } = Module[
    {highestUserSpecifiedContainerOutIndex, ContainerOutQ, postresolvedReplateCells, postresolvedvolumeInResuspension},
    highestUserSpecifiedContainerOutIndex = Max[{
      0,
      Cases[Flatten[{Lookup[listedOptions, {ContainerOut}]}], _Integer]
    }];
    postresolvedReplateCells = resolvedReplateCells /. Null -> False;
    postresolvedvolumeInResuspension = resolvedvolumeInResuspension /. 0 -> Null;
    ContainerOutQ = AliquotIntoPlateQ[semiresolvedContainerOutModel, postresolvedReplateCells, Null, Null, Null];
    PackContainers[
      semiresolvedContainerOutModel,
      ContainerOutQ,
      postresolvedvolumeInResuspension,
      resolvedResuspensionTemperature,
      NumberOfReplicates -> 1,
      FirstNewContainerIndex -> highestUserSpecifiedContainerOutIndex + 1]
  ];

  (* Resolve ContainerOutLabel *)
  resolvedContainerOutLabel = Module[
    {containersOutToGroupedLabels, containersOutToUserSpecifiedLabels, preResolvedContainersOutLabels},

    (* This is in the format <|object1 -> {label1, label1}, object2 -> {label2, label2, Null}|> *)
    containersOutToGroupedLabels = GroupBy[
      Rule @@@ Transpose[{resolvedContainerOut, Lookup[listedOptions, ContainerOutLabel]}],
      First -> Last
    ];

    (* Model[Container]s are unique containers and therefore don't need shared labels. *)
    containersOutToUserSpecifiedLabels = (#[[1]] -> FirstCase[#[[2]], _String, Null]&) /@ Normal[containersOutToGroupedLabels];

    preResolvedContainersOutLabels = MapThread[
      Function[{containerOut, userSpecifiedLabel},
        Which[
          (* User specified the option. *)
          MatchQ[userSpecifiedLabel, _String],
          userSpecifiedLabel,
          (* All Model[Container]s are unique. *)
          MatchQ[containerOut, ObjectP[Model[Container]]],
          CreateUniqueLabel["wash cells container out", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels],
          (* User specified the option for another index. *)
          MatchQ[Lookup[containersOutToUserSpecifiedLabels, Key[containerOut]], _String],
          Lookup[containersOutToUserSpecifiedLabels, Key[containerOut]],
          (* The user has labeled this object upstream in another unit operation *)
          MatchQ[currentSimulation, SimulationP] && MatchQ[containerOut, ObjectP[Object[Container]]] && MatchQ[LookupObjectLabel[currentSimulation, Download[containerOut, Object]], _String],
          LookupObjectLabel[currentSimulation, Download[containerOut, Object]],
          (* We need to make a new label for this object. *)
          MatchQ[containerOut, Except[Null]],
          Module[{},
            containersOutToUserSpecifiedLabels = ReplaceRule[
              containersOutToUserSpecifiedLabels,
              containerOut -> CreateUniqueLabel["wash cells container out", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels]
            ];

            Lookup[containersOutToUserSpecifiedLabels, Key[containerOut]]
          ]
        ]

      ],
      {resolvedContainerOut, Lookup[listedOptions, ContainerOutLabel]}
    ]
  ];

  (* Resolve Post Processing Options *)
  resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];

  (* get the resolved Email option; for this experiment, the default is True if it's a parent protocol, and False if it's a sub *)
  email = Which[
    MatchQ[Lookup[myOptions, Email], Automatic] && NullQ[Lookup[myOptions, ParentProtocol]],
    True,
    MatchQ[Lookup[myOptions, Email], Automatic] && MatchQ[Lookup[myOptions, ParentProtocol], ObjectP[ProtocolTypes[]]],
    False,
    True,
    Lookup[myOptions, Email]
  ];
  (* Overwrite our rounded options with our resolved options. Everything else has a default. *)
  resolvedOptions = Normal[Join[
    Association@roundedExperimentOptions,
    Association@{
      WorkCell -> resolvedWorkCell,
      RoboticInstrument -> resolvedRoboticInstrument,
      Method -> resolvedMethod,
      CellType -> resolvedCellType,
      CultureAdhesion -> resolvedCultureAdhesion,
      CellIsolationTechnique -> resolvedCellIsolationTechnique,
      CellIsolationInstrument -> resolvedCellIsolationInstrument,
      CellAspirationVolume -> resolvedCellAspirationVolume,
      CellIsolationTime -> resolvedCellIsolationTime,
      CellPelletIntensity -> resolvedCellPelletIntensity,
      CellAspirationAngle -> resolvedCellAspirationAngle,
      AliquotSourceMedia -> resolvedAliquotSourceMedia,
      AliquotMediaLabel -> resolvedAliquotMediaLabel,
      AliquotMediaVolume -> resolvedAliquotMediaVolume,
      AliquotMediaStorageCondition -> resolvedAliquotMediaStorageCondition,
      NumberOfWashes -> resolvedNumberOfWashes,
      WashSolution -> resolvedWashSolution,
      WashSolutionTemperature -> resolvedWashSolutionTemperature,
      WashSolutionEquilibrationTime -> resolvedWashSolutionEquilibrationTime,
      WashVolume -> resolvedWashVolume,
      WashMixType -> resolvedWashMixType,
      WashMixInstrument -> resolvedWashMixInstrument,
      WashMixTime -> resolvedWashMixTime,
      WashMixRate -> resolvedWashMixRate,
      NumberOfWashMixes -> resolvedNumberOfWashMixes,
      WashMixVolume -> resolvedWashMixVolume,
      WashTemperature -> resolvedWashTemperature,
      WashAspirationVolume -> resolvedWashAspirationVolume,
      WashIsolationTime -> resolvedWashIsolationTime,
      WashPelletIntensity -> resolvedWashPelletIntensity,
      WashAspirationAngle -> resolvedWashAspirationAngle,
      ResuspensionMedia -> resolvedResuspensionMedia,
      ResuspensionMediaTemperature -> resolvedResuspensionMediaTemperature,
      ResuspensionMediaEquilibrationTime -> resolvedResuspensionMediaEquilibrationTime,
      ResuspensionMediaVolume -> resolvedResuspensionMediaVolume,
      ResuspensionMixType -> resolvedResuspensionMixType,
      ResuspensionTemperature -> resolvedResuspensionTemperature,
      ResuspensionMixInstrument -> resolvedResuspensionMixInstrument,
      ResuspensionMixTime -> resolvedResuspensionMixTime,
      ResuspensionMixRate -> resolvedResuspensionMixRate,
      NumberOfResuspensionMixes -> resolvedNumberOfResuspensionMixes,
      ResuspensionMixVolume -> resolvedResuspensionMixVolume,
      ReplateCells -> resolvedReplateCells,
      SampleOutLabel -> resolvedSampleOutLabel,

      CellPelletContainer -> resolvedCellPelletContainer,
      AliquotMediaContainer -> resolvedAliquotMediaContainer,
      AliquotMediaContainerLabel -> resolvedAliquotMediaContainerLabel,
      ContainerOut -> resolvedContainerOut,
      ContainerOutLabel -> resolvedContainerOutLabel,

      CellPelletContainerWell -> resolvedCellPelletContainerWells,
      AliquotMediaContainerWell -> resolvedAliquotMediaContainerWells,
      ContainerOutWell -> resolvedContainerOutWells,

      resolvedPostProcessingOptions,
      Email -> email
    }
  ], Association];

  (* THROW CONFLICTING OPTION ERRORS *)

  (* There should only be washing options if NumberOfWashes is greater than 0. *)
  extraneousWashingOptionsCases = MapThread[
    Function[
      {
        sample,
        numberOfWashes,
        washSolution,
        washSolutionTemperature,
        washSolutionEquilibrationTime,
        washVolume,
        washMixType,
        washMixInstrument,
        washMixTime,
        washMixRate,
        numberOfWashMixes,
        washMixVolume,
        washTemperature,
        washAspirationVolume,
        washIsolationTime,
        washPelletIntensity,
        washAspirationAngle,
        index
      },
      Sequence @@ {
        If[MatchQ[washSolution, Except[Null]] && MatchQ[numberOfWashes, 0],
          {sample, WashSolution, washSolution, numberOfWashes, index},
          Nothing
        ],
        If[MatchQ[washSolutionTemperature, Except[Null]] && MatchQ[numberOfWashes, 0],
          {sample, WashSolutionTemperature, washSolutionTemperature, numberOfWashes, index},
          Nothing
        ],
        If[MatchQ[washSolutionEquilibrationTime, Except[Null]] && MatchQ[numberOfWashes, 0],
          {sample, WashSolutionEquilibrationTime, washSolutionEquilibrationTime, numberOfWashes, index},
          Nothing
        ],
        If[MatchQ[washVolume, Except[Null]] && MatchQ[numberOfWashes, 0],
          {sample, WashVolume, washVolume, numberOfWashes, index},
          Nothing
        ],
        If[MatchQ[washMixType, Except[Null]] && MatchQ[numberOfWashes, 0],
          {sample, WashMixType, washMixType, numberOfWashes, index},
          Nothing
        ],
        If[MatchQ[washMixInstrument, Except[Null]] && MatchQ[numberOfWashes, 0],
          {sample, WashMixInstrument, washMixInstrument, numberOfWashes, index},
          Nothing
        ],
        If[MatchQ[washMixTime, Except[Null]] && MatchQ[numberOfWashes, 0],
          {sample, WashMixTime, washMixTime, numberOfWashes, index},
          Nothing
        ],
        If[MatchQ[washMixRate, Except[Null]] && MatchQ[numberOfWashes, 0],
          {sample, WashMixRate, washMixRate, numberOfWashes, index},
          Nothing
        ],
        If[MatchQ[numberOfWashMixes, Except[Null]] && MatchQ[numberOfWashes, 0],
          {sample, NumberOfWashMixes, numberOfWashMixes, numberOfWashes, index},
          Nothing
        ],
        If[MatchQ[washMixVolume, Except[Null]] && MatchQ[numberOfWashes, 0],
          {sample, WashMixVolume, washMixVolume, numberOfWashes, index},
          Nothing
        ],
        If[MatchQ[washTemperature, Except[Null]] && MatchQ[numberOfWashes, 0],
          {sample, WashTemperature, washTemperature, numberOfWashes, index},
          Nothing
        ],
        If[MatchQ[washAspirationVolume, Except[Null]] && MatchQ[numberOfWashes, 0],
          {sample, WashAspirationVolume, washAspirationVolume, numberOfWashes, index},
          Nothing
        ],
        If[MatchQ[washIsolationTime, Except[Null]] && MatchQ[numberOfWashes, 0],
          {sample, WashIsolationTime, washIsolationTime, numberOfWashes, index},
          Nothing
        ],
        If[MatchQ[washPelletIntensity, Except[Null]] && MatchQ[numberOfWashes, 0],
          {sample, WashPelletIntensity, washPelletIntensity, numberOfWashes, index},
          Nothing
        ],
        If[MatchQ[washAspirationAngle, Except[Null]] && MatchQ[numberOfWashes, 0],
          {sample, WashAspirationAngle, washAspirationAngle, numberOfWashes, index},
          Nothing
        ]
      }
    ],
    {
      mySamples,
      resolvedNumberOfWashes,
      resolvedWashSolution,
      resolvedWashSolutionTemperature,
      resolvedWashSolutionEquilibrationTime,
      resolvedWashVolume,
      resolvedWashMixType,
      resolvedWashMixInstrument,
      resolvedWashMixTime,
      resolvedWashMixRate,
      resolvedNumberOfWashMixes,
      resolvedWashMixVolume,
      resolvedWashTemperature,
      resolvedWashAspirationVolume,
      resolvedWashIsolationTime,
      resolvedWashPelletIntensity,
      resolvedWashAspirationAngle,
      Range[Length[mySamples]]
    }
  ];

  If[MatchQ[Length[extraneousWashingOptionsCases], GreaterP[0]] && messages,
    Message[
      Error::ExtraneousWashingOptions,
      ObjectToString[extraneousWashingOptionsCases[[All, 1]], Cache -> cacheBall],
      ObjectToString[extraneousWashingOptionsCases[[All, 2]], Cache -> cacheBall],
      ObjectToString[extraneousWashingOptionsCases[[All, 3]], Cache -> cacheBall],
      ObjectToString[extraneousWashingOptionsCases[[All, 4]], Cache -> cacheBall],
      extraneousWashingOptionsCases[[All, 5]]
    ];
  ];

  extraneousWashingOptionsTest = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = extraneousWashingOptionsCases[[All, 1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["No washing options are specified for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " if NumberOfWashes is equal to 0:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["No washing options are specified for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " if NumberOfWashes is equal to 0:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* There should only be Media Replenishment options if Resuspension Media is not Null. *)
  extraneousMediaReplenishmentOptionsCases = MapThread[
    Function[
      {
        sample,
        resuspensionMedia,
        resuspensionMediaTemperature,
        resuspensionMediaEquilibrationTime,
        resuspensionMediaVolume,
        resuspensionMixType,
        resuspensionTemperature,
        resuspensionMixInstrument,
        resuspensionMixTime,
        resuspensionMixRate,
        numberOfResuspensionMixes,
        resuspensionMixVolume,
        replateCells,
        index
      },
      Sequence @@ {
        If[MatchQ[resuspensionMediaTemperature, Except[Null]] && MatchQ[resuspensionMedia, None],
          {sample, ResuspensionMediaTemperature, resuspensionMediaTemperature, resuspensionMedia, index},
          Nothing
        ],
        If[MatchQ[resuspensionMediaEquilibrationTime, Except[Null]] && MatchQ[resuspensionMedia, None],
          {sample, ResuspensionMediaEquilibrationTime, resuspensionMediaEquilibrationTime, resuspensionMedia, index},
          Nothing
        ],
        If[MatchQ[resuspensionMediaVolume, Except[Null]] && MatchQ[resuspensionMedia, None],
          {sample, ResuspensionMediaVolume, resuspensionMediaVolume, resuspensionMedia, index},
          Nothing
        ],
        If[MatchQ[resuspensionMixType, Except[Null]] && MatchQ[resuspensionMedia, None],
          {sample, ResuspensionMixType, resuspensionMixType, resuspensionMedia, index},
          Nothing
        ],
        If[MatchQ[resuspensionTemperature, Except[Null]] && MatchQ[resuspensionMedia, None],
          {sample, ResuspensionTemperature, resuspensionTemperature, resuspensionMedia, index},
          Nothing
        ],
        If[MatchQ[resuspensionMixInstrument, Except[Null]] && MatchQ[resuspensionMedia, None],
          {sample, ResuspensionMixInstrument, resuspensionMixInstrument, resuspensionMedia, index},
          Nothing
        ],
        If[MatchQ[resuspensionMixTime, Except[Null]] && MatchQ[resuspensionMedia, None],
          {sample, ResuspensionMixTime, resuspensionMixTime, resuspensionMedia, index},
          Nothing
        ],
        If[MatchQ[resuspensionMixRate, Except[Null]] && MatchQ[resuspensionMedia, None],
          {sample, ResuspensionMixRate, resuspensionMixRate, resuspensionMedia, index},
          Nothing
        ],
        If[MatchQ[numberOfResuspensionMixes, Except[Null]] && MatchQ[resuspensionMedia, None],
          {sample, NumberOfResuspensionMixes, numberOfResuspensionMixes, resuspensionMedia, index},
          Nothing
        ],
        If[MatchQ[resuspensionMixVolume, Except[Null]] && MatchQ[resuspensionMedia, None],
          {sample, ResuspensionMixVolume, resuspensionMixVolume, resuspensionMedia, index},
          Nothing
        ],
        If[MatchQ[replateCells, Except[Null]] && MatchQ[resuspensionMedia, None],
          {sample, ReplateCells, replateCells, resuspensionMedia, index}, (* TODO: ContainerOut*)
          Nothing
        ]
      }
    ],
    {
      mySamples,
      resolvedResuspensionMedia,
      resolvedResuspensionMediaTemperature,
      resolvedResuspensionMediaEquilibrationTime,
      resolvedResuspensionMediaVolume,
      resolvedResuspensionMixType,
      resolvedResuspensionTemperature,
      resolvedResuspensionMixInstrument,
      resolvedResuspensionMixTime,
      resolvedResuspensionMixRate,
      resolvedNumberOfResuspensionMixes,
      resolvedResuspensionMixVolume,
      resolvedReplateCells,
      Range[Length[mySamples]]
    }
  ];

  If[MatchQ[Length[extraneousMediaReplenishmentOptionsCases], GreaterP[0]] && messages,
    Message[
      Error::ExtraneousMediaReplenishmentOptions,
      ObjectToString[extraneousMediaReplenishmentOptionsCases[[All, 1]], Cache -> cacheBall],
      ObjectToString[extraneousMediaReplenishmentOptionsCases[[All, 2]], Cache -> cacheBall],
      ObjectToString[extraneousMediaReplenishmentOptionsCases[[All, 3]], Cache -> cacheBall],
      ObjectToString[extraneousMediaReplenishmentOptionsCases[[All, 4]], Cache -> cacheBall],
      extraneousMediaReplenishmentOptionsCases[[All, 5]]
    ];
  ];

  extraneousMediaReplenishmentOptionsTest = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = extraneousMediaReplenishmentOptionsCases[[All, 1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["No media replenishment options are specified for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " if ResuspensionMedia is equal to None:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["No media replenishment options are specified for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " if ResuspensionMedia is equal to None:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* CellIsolationTechnique should be consistent with cell isolation options. *) (*TODO: CellPelletContainer *)
  cellIsolationTechniqueConflictingOptionsCases = MapThread[
    Function[
      {
        sample,
        cellIsolationTechnique,
        cellIsolationInstrument,
        cellIsolationTime,
        cellPelletIntensity,
        cellAspirationAngle,
        index
      },
      If[
        Or[
          (* There should only be Aspirate options in Media Aspiration if CellIsolationTechnique is Aspirate. *)
          And[
            MatchQ[cellIsolationTechnique, Pellet],
            Or[
              !MatchQ[cellAspirationAngle, Null],
              MatchQ[cellIsolationInstrument, Null],
              MatchQ[cellIsolationTime, Null],
              MatchQ[cellPelletIntensity, Null]
            ]
          ],
          (* There should only be Pellet options in Media Aspiration if CellIsolationTechnique is Pellet. *)
          And[
            MatchQ[cellIsolationTechnique, Aspirate],
            Or[
              MatchQ[cellAspirationAngle, Null],
              !MatchQ[cellIsolationInstrument, Null],
              !MatchQ[cellIsolationTime, Null],
              !MatchQ[cellPelletIntensity, Null]
            ]
          ]
        ],
        {sample,
          cellIsolationTechnique, cellAspirationAngle, cellIsolationInstrument, cellIsolationTime, cellPelletIntensity,
          index},
        Nothing
      ]
    ],
    {
      mySamples,
      resolvedCellIsolationTechnique,
      resolvedCellIsolationInstrument,
      resolvedCellIsolationTime,
      resolvedCellPelletIntensity,
      resolvedCellAspirationAngle,
      Range[Length[mySamples]]
    }
  ];

  If[MatchQ[Length[cellIsolationTechniqueConflictingOptionsCases], GreaterP[0]] && messages,
    Message[
      Error::CellIsolationTechniqueConflictingOptions,
      ObjectToString[cellIsolationTechniqueConflictingOptionsCases[[All, 1]], Cache -> cacheBall],
      ObjectToString[cellIsolationTechniqueConflictingOptionsCases[[All, 2]], Cache -> cacheBall],
      ObjectToString[cellIsolationTechniqueConflictingOptionsCases[[All, 3]], Cache -> cacheBall],
      ObjectToString[cellIsolationTechniqueConflictingOptionsCases[[All, 4]], Cache -> cacheBall],
      ObjectToString[cellIsolationTechniqueConflictingOptionsCases[[All, 5]], Cache -> cacheBall],
      ObjectToString[cellIsolationTechniqueConflictingOptionsCases[[All, 6]], Cache -> cacheBall],
      cellIsolationTechniqueConflictingOptionsCases[[All, 7]]
    ];
  ];

  cellIsolationTechniqueConflictingOptionsTest = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = cellIsolationTechniqueConflictingOptionsCases[[All, 1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["CellIsolationTechnique for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " is consistent with the isolation options in Media Aspiration:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["CellIsolationTechnique for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " is consistent with the isolation options in Media Aspiration:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* CellIsolationTechnique should be consistent with wash isolation options.*)
  washIsolationTechniqueConflictingOptionsCases = MapThread[
    Function[
      {
        sample,
        cellIsolationTechnique,
        numberOfWashes,
        washIsolationTime,
        washPelletIntensity,
        washAspirationAngle,
        index
      },
      If[
        Or[
          (* There should only be Aspirate options in Washing if CellIsolationTechnique is Aspirate and NumberOfWashes is not 0. *)
          And[
            MatchQ[cellIsolationTechnique, Pellet],
            MatchQ[numberOfWashes, GreaterP[0]],
            Or[
              !MatchQ[washAspirationAngle, Null],
              MatchQ[washIsolationTime, Null],
              MatchQ[washPelletIntensity, Null]
            ]
          ],
          (* There should only be Pellet options in Washing if CellIsolationTechnique is Pellet and NumberOfWashes is not 0. *)
          And[
            MatchQ[cellIsolationTechnique, Aspirate],
            MatchQ[numberOfWashes, GreaterP[0]],
            Or[
              MatchQ[washAspirationAngle, Null],
              !MatchQ[washIsolationTime, Null],
              !MatchQ[washPelletIntensity, Null]
            ]
          ]
        ],
        {sample,
          cellIsolationTechnique, washIsolationTime, washPelletIntensity, washAspirationAngle,
          index},
        Nothing
      ]
    ],

    {
      mySamples,
      resolvedCellIsolationTechnique,
      resolvedNumberOfWashes,
      resolvedWashIsolationTime,
      resolvedWashPelletIntensity,
      resolvedWashAspirationAngle,
      Range[Length[mySamples]]
    }
  ];

  If[MatchQ[Length[washIsolationTechniqueConflictingOptionsCases], GreaterP[0]] && messages,
    Message[
      Error::WashIsolationTechniqueConflictingOptions,
      ObjectToString[washIsolationTechniqueConflictingOptionsCases[[All, 1]], Cache -> cacheBall],
      ObjectToString[washIsolationTechniqueConflictingOptionsCases[[All, 2]], Cache -> cacheBall],
      ObjectToString[washIsolationTechniqueConflictingOptionsCases[[All, 3]], Cache -> cacheBall],
      ObjectToString[washIsolationTechniqueConflictingOptionsCases[[All, 4]], Cache -> cacheBall],
      ObjectToString[washIsolationTechniqueConflictingOptionsCases[[All, 5]], Cache -> cacheBall],
      washIsolationTechniqueConflictingOptionsCases[[All, 6]]
    ];
  ];

  washIsolationTechniqueConflictingOptionsTest = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = washIsolationTechniqueConflictingOptionsCases[[All, 1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["CellIsolationTechnique for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " is consistent with the isolation options in Washing:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["CellIsolationTechnique for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " is consistent with the isolation options in Washing:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* WashMixType should be consistent with wash mix options. *)
  washMixTypeConflictingOptionsCases = MapThread[
    Function[
      {
        sample,
        washMixType,
        washMixInstrument,
        washMixTime,
        washMixRate,
        washTemperature,
        numberOfWashMixes,
        washMixVolume,
        index
      },
      If[
        Or[
          (* There should only be Shake options in Washing if WashMixType is Shake. *)
          And[
            MatchQ[washMixType, Shake],
            Or[
              !MatchQ[washMixVolume, Null],
              !MatchQ[numberOfWashMixes, Null],
              MatchQ[washMixInstrument, Null],
              MatchQ[washTemperature, Null],
              MatchQ[washMixTime, Null],
              MatchQ[washMixRate, Null]
            ]
          ],
          (* There should only be Pipette options in Washing if WashMixType is Pipette. *)
          And[
            MatchQ[washMixType, Pipette],
            Or[
              MatchQ[washMixVolume, Null],
              MatchQ[numberOfWashMixes, Null],
              !MatchQ[washMixInstrument, Null],
              !MatchQ[washTemperature, Null],
              !MatchQ[washMixTime, Null],
              !MatchQ[washMixRate, Null]
            ]
          ],
          And[
            MatchQ[washMixType, (None | Null)],
            Or[
              !MatchQ[washMixVolume, Null],
              !MatchQ[numberOfWashMixes, Null],
              !MatchQ[washMixInstrument, Null],
              !MatchQ[washTemperature, Null],
              !MatchQ[washMixTime, Null],
              !MatchQ[washMixRate, Null]
            ]
          ]
        ],
        {sample,
          washMixType, washMixVolume, numberOfWashMixes, washMixInstrument, washTemperature, washMixTime, washMixRate,
          index},
        Nothing
      ]
    ],
    {
      mySamples,
      resolvedWashMixType,
      resolvedWashMixInstrument,
      resolvedWashMixTime,
      resolvedWashMixRate,
      resolvedWashTemperature,
      resolvedNumberOfWashMixes,
      resolvedWashMixVolume,
      Range[Length[mySamples]]
    }
  ];

  If[MatchQ[Length[washMixTypeConflictingOptionsCases], GreaterP[0]] && messages,
    Message[
      Error::WashMixTypeConflictingOptions,
      ObjectToString[washMixTypeConflictingOptionsCases[[All, 1]], Cache -> cacheBall],
      ObjectToString[washMixTypeConflictingOptionsCases[[All, 2]], Cache -> cacheBall],
      ObjectToString[washMixTypeConflictingOptionsCases[[All, 3]], Cache -> cacheBall],
      ObjectToString[washMixTypeConflictingOptionsCases[[All, 4]], Cache -> cacheBall],
      ObjectToString[washMixTypeConflictingOptionsCases[[All, 5]], Cache -> cacheBall],
      ObjectToString[washMixTypeConflictingOptionsCases[[All, 6]], Cache -> cacheBall],
      ObjectToString[washMixTypeConflictingOptionsCases[[All, 7]], Cache -> cacheBall],
      ObjectToString[washMixTypeConflictingOptionsCases[[All, 8]], Cache -> cacheBall],
      washMixTypeConflictingOptionsCases[[All, 9]]
    ];
  ];

  washMixTypeConflictingOptionsTest = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = washMixTypeConflictingOptionsCases[[All, 1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["WashMixType for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " is consistent with mix options:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["WashMixType for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " is consistent with mix options:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* ResuspensionMixType should be consistent with resuspension mix options. *)
  resuspensionMixTypeConflictingOptionsCases = MapThread[
    Function[
      {
        sample,
        resuspensionMixType,
        resuspensionMixInstrument,
        resuspensionMixTime,
        resuspensionMixRate,
        resuspensionTemperature,
        numberOfResuspensionMixes,
        resuspensionMixVolume,
        index
      },
      If[
        Or[
          (* There should only be Shake options in Media Replenishment if ResuspensionMixType is Shake. *)
          And[
            MatchQ[resuspensionMixType, Shake],
            Or[
              !MatchQ[resuspensionMixVolume, Null],
              !MatchQ[numberOfResuspensionMixes, Null],
              MatchQ[resuspensionMixInstrument, Null],
              MatchQ[resuspensionTemperature, Null],
              MatchQ[resuspensionMixTime, Null],
              MatchQ[resuspensionMixRate, Null]
            ]
          ],
          (* There should only be Pipette options in Media Replenishment if ResuspensionMixType is Pipette. *)
          And[
            MatchQ[resuspensionMixType, Pipette],
            Or[
              MatchQ[resuspensionMixVolume, Null],
              MatchQ[numberOfResuspensionMixes, Null],
              !MatchQ[resuspensionMixInstrument, Null],
              !MatchQ[resuspensionTemperature, Null],
              !MatchQ[resuspensionMixTime, Null],
              !MatchQ[resuspensionMixRate, Null]
            ]
          ],
          And[
            MatchQ[resuspensionMixType, (None | Null)],
            Or[
              !MatchQ[resuspensionMixVolume, Null],
              !MatchQ[numberOfResuspensionMixes, Null],
              !MatchQ[resuspensionMixInstrument, Null],
              !MatchQ[resuspensionTemperature, Null],
              !MatchQ[resuspensionMixTime, Null],
              !MatchQ[resuspensionMixRate, Null]
            ]
          ]
        ],
        {sample,
          resuspensionMixType, resuspensionMixVolume, numberOfResuspensionMixes, resuspensionMixInstrument, resuspensionTemperature, resuspensionMixTime, resuspensionMixRate,
          index},
        Nothing
      ]
    ],
    {
      mySamples,
      resolvedResuspensionMixType,
      resolvedResuspensionMixInstrument,
      resolvedResuspensionMixTime,
      resolvedResuspensionMixRate,
      resolvedResuspensionTemperature,
      resolvedNumberOfResuspensionMixes,
      resolvedResuspensionMixVolume,
      Range[Length[mySamples]]
    }
  ];

  If[MatchQ[Length[resuspensionMixTypeConflictingOptionsCases], GreaterP[0]] && messages,
    Message[
      Error::ResuspensionMixTypeConflictingOptions,
      ObjectToString[resuspensionMixTypeConflictingOptionsCases[[All, 1]], Cache -> cacheBall],
      ObjectToString[resuspensionMixTypeConflictingOptionsCases[[All, 2]], Cache -> cacheBall],
      ObjectToString[resuspensionMixTypeConflictingOptionsCases[[All, 3]], Cache -> cacheBall],
      ObjectToString[resuspensionMixTypeConflictingOptionsCases[[All, 4]], Cache -> cacheBall],
      ObjectToString[resuspensionMixTypeConflictingOptionsCases[[All, 5]], Cache -> cacheBall],
      ObjectToString[resuspensionMixTypeConflictingOptionsCases[[All, 6]], Cache -> cacheBall],
      ObjectToString[resuspensionMixTypeConflictingOptionsCases[[All, 7]], Cache -> cacheBall],
      ObjectToString[resuspensionMixTypeConflictingOptionsCases[[All, 8]], Cache -> cacheBall],
      resuspensionMixTypeConflictingOptionsCases[[All, 9]]
    ];
  ];

  resuspensionMixTypeConflictingOptionsTest = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = cellIsolationTechniqueConflictingOptionsCases[[All, 1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["ResuspensionMixType for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " is consistent with mix options:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["ResuspensionMixType for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " is consistent with mix options:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* Replate can only be true is Culture Adhesion is Suspension. *)
  replateCellsConflictingOptionCases = MapThread[
    Function[
      {
        sample,
        cultureAdhesion,
        replateCells,
        index
      },

      If[
        MatchQ[replateCells, True] && MatchQ[cultureAdhesion, Except[Suspension]],
        {sample, index},
        Nothing
      ]
    ],
    {
      mySamples,
      resolvedCultureAdhesion,
      resolvedReplateCells,
      Range[Length[mySamples]]
    }
  ];

  If[MatchQ[Length[replateCellsConflictingOptionCases], GreaterP[0]] && messages,
    Message[
      Error::ReplateCellsConflictingOption,
      ObjectToString[replateCellsConflictingOptionCases[[All, 1]], Cache -> cacheBall],
      replateCellsConflictingOptionCases[[All, 2]]
    ];
  ];

  replateCellsConflictingOptionTest = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = replateCellsConflictingOptionCases[[All, 1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The ReplateCells option for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " can be set to True only when CultureAdhesion is Suspension:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The ReplateCells option for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " can be set to True only when CultureAdhesion is Suspension:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* AspirationVolume must be smaller than current sample volume. *)
  aspirationVolumeConflictingOptionCases = MapThread[
    Function[
      {
        sample,
        cellAspirationVolume,
        washAspirationVolume,
        volumeInWashing,
        volumeLimitWashing,
        samplePacket,
        index
      },
      Sequence @@ {
        If[
          MatchQ[cellAspirationVolume, GreaterP[Lookup[samplePacket, Volume]]],
          {sample, CellAspirationVolume, cellAspirationVolume, Lookup[samplePacket, Volume], index},
          Nothing
        ],
        If[
          MatchQ[washAspirationVolume, GreaterP[volumeInWashing]],
          {sample, WashAspirationVolume, washAspirationVolume, volumeInWashing, index},
          Nothing
        ],
        If[
          MatchQ[volumeLimitWashing, LessP[0]],
          {sample, WashAspirationVolume, washAspirationVolume, volumeInWashing, index},
          Nothing
        ]
      }
    ],
    {
      mySamples,
      resolvedCellAspirationVolume,
      resolvedWashAspirationVolume,
      resolvedvolumeInWashing,
      resolvedvolumeLimitWashing,
      samplePackets,
      Range[Length[mySamples]]
    }
  ];

  If[MatchQ[Length[aspirationVolumeConflictingOptionCases], GreaterP[0]] && messages,
    Message[
      Error::AspirationVolumeConflictingOption,
      ObjectToString[aspirationVolumeConflictingOptionCases[[All, 1]], Cache -> cacheBall],
      ObjectToString[aspirationVolumeConflictingOptionCases[[All, 2]], Cache -> cacheBall],
      ObjectToString[aspirationVolumeConflictingOptionCases[[All, 3]], Cache -> cacheBall],
      ObjectToString[aspirationVolumeConflictingOptionCases[[All, 4]], Cache -> cacheBall],
      aspirationVolumeConflictingOptionCases[[All, 5]]
    ];
  ];

  aspirationVolumeConflictingOptionTest = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = aspirationVolumeConflictingOptionCases[[All, 1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The aspiration volume for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " is set to be smaller than current sample volume:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The aspiration volume for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " is set to be smaller than current sample volume:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* Total Volume must be smaller than container max Volume. *)
  totalVolumeConflictingOptionCases = MapThread[
    Function[
      {
        sample,
        washVolume,
        resuspensionMediaVolume,
        volumeAfterAspiration,
        volumeAfterWashing,
        volumeLimitWashing,
        sampleContainerModelAfterPelletPacket,
        index
      },
      Sequence @@ {
        If[
          MatchQ[washVolume + volumeAfterAspiration, GreaterP[Lookup[sampleContainerModelAfterPelletPacket, MaxVolume]]],
          {sample, WashVolume, washVolume, Lookup[sampleContainerModelAfterPelletPacket, MaxVolume], index},
          Nothing
        ],
        If[
          MatchQ[resuspensionMediaVolume + volumeLimitWashing, GreaterP[Lookup[sampleContainerModelAfterPelletPacket, MaxVolume]]],
          {sample, ResuspensionMediaVolume, resuspensionMediaVolume, Lookup[sampleContainerModelAfterPelletPacket, MaxVolume], index},
          Nothing
        ],
        If[
          MatchQ[volumeLimitWashing, GreaterP[Lookup[sampleContainerModelAfterPelletPacket, MaxVolume]]],
          {sample, WashVolume, washVolume, Lookup[sampleContainerModelAfterPelletPacket, MaxVolume], index},
          Nothing
        ]
      }
    ],
    {
      mySamples,
      resolvedWashVolume,
      resolvedResuspensionMediaVolume,
      resolvedvolumeAfterAspiration,
      resolvedvolumeAfterWashing,
      resolvedvolumeLimitWashing,
      semiresolvedSampleContainerModelAfterPelletPackets,
      Range[Length[mySamples]]
    }
  ];

  If[MatchQ[Length[totalVolumeConflictingOptionCases], GreaterP[0]] && messages,
    Message[
      Error::TotalVolumeConflictingOption,
      ObjectToString[totalVolumeConflictingOptionCases[[All, 1]], Cache -> cacheBall],
      ObjectToString[totalVolumeConflictingOptionCases[[All, 2]], Cache -> cacheBall],
      ObjectToString[totalVolumeConflictingOptionCases[[All, 3]], Cache -> cacheBall],
      ObjectToString[totalVolumeConflictingOptionCases[[All, 4]], Cache -> cacheBall],
      totalVolumeConflictingOptionCases[[All, 5]]
    ];
  ];

  totalVolumeConflictingOptionTest = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = totalVolumeConflictingOptionCases[[All, 1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The total volume before mixing for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " is set to be smaller than the max volume of the container:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The total volume before mixing for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " is set to be smaller than the max volume of the container:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];
  (* Aliquot volume and Aliquot Container *)

  (* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
  invalidInputs = DeleteDuplicates[Flatten[{discardedInvalidInputs, deprecatedInvalidInputs, solidMediaInvalidInputs}]];

  invalidOptions = DeleteDuplicates[Flatten[{
    If[MatchQ[Length[extraneousWashingOptionsCases], GreaterP[0]],
      Join[{NumberOfWashes}, $WashingOptions],
      {}
    ],
    If[MatchQ[Length[extraneousMediaReplenishmentOptionsCases], GreaterP[0]],
      Join[{ResuspensionMedia}, $MediaReplenishmentOptions],
      {}
    ],
    If[MatchQ[Length[cellIsolationTechniqueConflictingOptionsCases], GreaterP[0]],
      {CellIsolationTechnique, CellIsolationInstrument, CellIsolationTime, CellPelletIntensity, CellAspirationAngle},
      {}
    ],
    If[MatchQ[Length[washIsolationTechniqueConflictingOptionsCases], GreaterP[0]],
      {CellIsolationTechnique, NumberOfWashes, WashIsolationTime, WashPelletIntensity, WashAspirationAngle},
      {}
    ],
    If[MatchQ[Length[washMixTypeConflictingOptionsCases], GreaterP[0]],
      {WashMixType, WashMixInstrument, WashMixTime, WashMixRate, WashTemperature, NumberOfWashMixes, WashMixVolume},
      {}
    ],
    If[MatchQ[Length[resuspensionMixTypeConflictingOptionsCases], GreaterP[0]],
      {ResuspensionMixType, ResuspensionMixInstrument, ResuspensionMixTime, ResuspensionMixRate, ResuspensionTemperature, NumberOfResuspensionMixes, ResuspensionMixVolume},
      {}
    ],
    If[MatchQ[Length[replateCellsConflictingOptionCases], GreaterP[0]],
      {CultureAdhesion, ReplateCells},
      {}
    ],
    If[MatchQ[Length[aspirationVolumeConflictingOptionCases], GreaterP[0]],
      {CellAspirationVolume, WashAspirationVolume},
      {}
    ],
    If[MatchQ[Length[totalVolumeConflictingOptionCases], GreaterP[0]],
      {WashVolume, ResuspensionMediaVolume},
      {}
    ]
  }]];

  (* Throw Error::InvalidInput if there are invalid inputs. *)
  If[MatchQ[Length[invalidInputs], GreaterP[0]] && !gatherTests,
    Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> cache]]
  ];

  (* Throw Error::InvalidOption if there are invalid options. *)
  If[MatchQ[Length[invalidOptions], GreaterP[0]] && !gatherTests,
    Message[Error::InvalidOption, invalidOptions]
  ];

  (* Return our resolved options and/or tests. *)
  outputSpecification /. {
    Result -> resolvedOptions,
    Tests -> Flatten[{
      (*ConfilictingTests*)
      extraneousWashingOptionsTest,
      extraneousMediaReplenishmentOptionsTest,
      cellIsolationTechniqueConflictingOptionsTest,
      washIsolationTechniqueConflictingOptionsTest,
      washMixTypeConflictingOptionsTest,
      resuspensionMixTypeConflictingOptionsTest,
      replateCellsConflictingOptionTest,
      aspirationVolumeConflictingOptionTest,
      totalVolumeConflictingOptionTest
    }]
  }

];


(* ::Subsection::Closed:: *)
(* WashCellsResourcePackets *)


(* --- WashCellsResourcePackets --- *)

DefineOptions[
  washCellsResourcePackets,
  Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

washCellsResourcePackets[mySamples : ListableP[ObjectP[Object[Sample]]], myTemplatedOptions : {(_Rule | _RuleDelayed)...}, myResolvedOptions : {(_Rule | _RuleDelayed)..}, ops : OptionsPattern[]] := Module[
  {
    expandedInputs, expandedResolvedOptions, resolvedOptionsNoHidden, outputSpecification, output, gatherTests,
    messages, inheritedCache, samplePackets, mapThreadFriendlyOptions,

    userSpecifiedLabels, uniqueSamplesInResources, resolvedPreparation, samplesInResources, sampleContainersIn, uniqueSampleContainersInResources, containersInResources,
    protocolPacket, allUnitOperationPackets, currentSimulation, runTime, allResourceBlobs, resourcesOk, resourceTests, previewRule, optionsRule, testsRule, resultRule,
    simulatedObjectsToLabel, expandedResolvedOptionsWithLabels, subRoboticUnitOperations, roboticUnitOperationsToUse
  },

  (* get the inherited cache *)
  inheritedCache = Lookup[ToList[ops], Cache, {}];

  (* Get the simulation *)
  currentSimulation = Lookup[ToList[ops], Simulation];

  (* Lookup the resolved Preparation option. *)
  resolvedPreparation = Lookup[myResolvedOptions, Preparation];

  (* expand the resolved options if they weren't expanded already *)
  {expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentWashCells, {mySamples}, myResolvedOptions];


  (* determine which objects in the simulation are simulated and make replace rules for those *)
  simulatedObjectsToLabel = If[NullQ[currentSimulation],
    {},
    Module[{allObjectsInSimulation, simulatedQ},
      (* Get all objects out of our simulation. *)
      allObjectsInSimulation = Download[Lookup[currentSimulation[[1]], Labels][[All, 2]], Object];

      (* Figure out which objects are simulated. *)
      simulatedQ = Experiment`Private`simulatedObjectQs[allObjectsInSimulation, currentSimulation];

      (Reverse /@ PickList[Lookup[currentSimulation[[1]], Labels], simulatedQ]) /. {link_Link :> Download[link, Object]}
    ]
  ];
  (* get the resolved options with simulated objects replaced with labels *)
  (* Currently the rule replacement hits the simulation as well as it's in the expanded options,
    which breaks labels as the objects the labels point at get replaced with more labels.
    We have to add an unmodified version back in to avoid this issue. BMB committed, Steven approved
  *)
  expandedResolvedOptionsWithLabels = Module[{dropped, output},
    dropped = KeyDrop[expandedResolvedOptions, Simulation]; (* Watch out, this returns an assc*)
    output = dropped /. simulatedObjectsToLabel;
    output[Simulation] -> Lookup[expandedResolvedOptions, Simulation];
    Normal[output]
  ];

  (* Get the resolved collapsed index matching options that don't include hidden options *)
  resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
    ExperimentWashCells,
    RemoveHiddenOptions[ExperimentWashCells, myResolvedOptions],
    Ignore -> myTemplatedOptions,
    Messages -> False
  ];

  (* Determine the requested return value from the function *)
  outputSpecification = OptionDefault[OptionValue[Output]];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests; if True, then silence the messages *)
  gatherTests = MemberQ[output, Tests];
  messages = Not[gatherTests];

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
    ExperimentWashCells,
    myResolvedOptions
  ];
  (* Get all of the user specified labels *)
  userSpecifiedLabels = DeleteDuplicates@Cases[
    Flatten@Lookup[
      myResolvedOptions,
      {AliquotMediaContainerLabel, ContainerOutLabel, AliquotMediaLabel}
    ],
    _String
  ];

  (* --- Create the protocol packet --- *)
  {protocolPacket, allUnitOperationPackets, currentSimulation, runTime} = Module[
    {primitives, roboticUnitOperationPackets, roboticRunTime, roboticSimulation, outputUnitOperationPacket,

      mapThreadFriendlyOptionsToPelletAndWash, mapThreadFriendlyOptionsToPelletWashAndMix, mapThreadFriendlyOptionsToAspirateAndWash, mapThreadFriendlyOptionsToAspirateWashAndMix, mapThreadFriendlyOptionsToResuspend, mapThreadFriendlyOptionsToWash,

      transferBeforePelletSamples, transferBeforePelletDestinationLabels, transferBeforePelletReplaceRules,
      pelletWashSamplesAndLabels, pelletWashMixSamplesAndLabels, washSamplesAndLabels,
      resuspensionMediaContainerLabels, washSolutionContainerLabels,

      equilibrationUnitOperations, mediaAspirationUnitOperation, washSamplesUnitOperations, resuspensionUnitOperations,
      replateCellsUnitOperations, sampleOutLabelUnitOperations
    },


    mapThreadFriendlyOptionsToWash = PickList[mapThreadFriendlyOptions, Lookup[myResolvedOptions, NumberOfWashes], GreaterP[0]];
    mapThreadFriendlyOptionsToResuspend = PickList[mapThreadFriendlyOptions, Lookup[myResolvedOptions, ResuspensionMedia], ObjectP[]];

    washSolutionContainerLabels = Table[
      CreateUniqueLabel["ExperimentWashCells WashSolutionContainer", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels],
      {x, 1, Length[mapThreadFriendlyOptionsToWash]}
    ];

    resuspensionMediaContainerLabels = Table[
      CreateUniqueLabel["ExperimentWashCells ResuspensionMediaContainer", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels],
      {x, 1, Length[mapThreadFriendlyOptionsToResuspend]}
    ];


    (* Incubate/Equilibration Unit Operation *)
    equilibrationUnitOperations = Module[
      {labelWashSolutionUnitOperations, labelResuspensionMediaUnitOperations, washSolutionIncubateUnitOperations, resuspensionMediaIncubateUnitOperations},

      labelWashSolutionUnitOperations = If[Length[mapThreadFriendlyOptionsToWash] > 0,
        {
          LabelContainer[
            Label -> washSolutionContainerLabels,
            Container -> (PreferredContainer[#, LiquidHandlerCompatible -> True, Type -> Vessel]&/@ (Lookup[mapThreadFriendlyOptionsToWash, WashVolume] * Max[Lookup[mapThreadFriendlyOptionsToWash, NumberOfWashes]]))
          ],
          Transfer[
            Source -> Lookup[mapThreadFriendlyOptionsToWash, WashSolution],
            Destination -> washSolutionContainerLabels,
            Amount -> Lookup[mapThreadFriendlyOptionsToWash, WashVolume] * Max[Lookup[mapThreadFriendlyOptionsToWash, NumberOfWashes]]
          ]
        },
        Nothing
      ];
      labelResuspensionMediaUnitOperations = If[Length[mapThreadFriendlyOptionsToResuspend] > 0,
        {
          LabelContainer[
            Label -> resuspensionMediaContainerLabels,
            Container -> (PreferredContainer[#, LiquidHandlerCompatible -> True, Type -> Vessel]& /@ Lookup[mapThreadFriendlyOptionsToResuspend, ResuspensionMediaVolume])
          ],
          Transfer[
            Source -> Lookup[mapThreadFriendlyOptionsToResuspend, ResuspensionMedia],
            Destination -> resuspensionMediaContainerLabels,
            Amount -> Lookup[mapThreadFriendlyOptionsToResuspend, ResuspensionMediaVolume]
          ]
        },
        Nothing
      ];
      washSolutionIncubateUnitOperations = If[Length[mapThreadFriendlyOptionsToWash] > 0,
        Incubate[
          Sample -> washSolutionContainerLabels,
          Temperature -> (Lookup[mapThreadFriendlyOptionsToWash, WashSolutionTemperature] /. Ambient -> $AmbientTemperature),
          Time -> (Lookup[mapThreadFriendlyOptionsToWash, WashSolutionEquilibrationTime]/. Null -> 0 Minute),
          Preparation -> Robotic,
          WorkCell -> Lookup[myResolvedOptions, WorkCell]
        ],
        Nothing
      ];
      resuspensionMediaIncubateUnitOperations = If[Length[mapThreadFriendlyOptionsToResuspend] > 0,
        Incubate[
          Sample -> resuspensionMediaContainerLabels,
          Temperature -> (Lookup[mapThreadFriendlyOptionsToResuspend, ResuspensionMediaTemperature] /. Ambient -> $AmbientTemperature),
          Time -> (Lookup[mapThreadFriendlyOptionsToResuspend, ResuspensionMediaEquilibrationTime]/. Null -> 0 Minute),
          Preparation -> Robotic,
          WorkCell -> Lookup[myResolvedOptions, WorkCell]
        ],
        Nothing
      ];
      Flatten[{labelWashSolutionUnitOperations, labelResuspensionMediaUnitOperations, washSolutionIncubateUnitOperations, resuspensionMediaIncubateUnitOperations}]
    ];

    (* these are the samples that we are transferring before pelleting; this may be only some of the samples that actually get pelleted *)
    transferBeforePelletSamples = PickList[mySamples, Transpose[{Lookup[myResolvedOptions, CellIsolationTechnique], Lookup[myResolvedOptions, CellPelletContainer]}], {Pellet, Except[Null]}];
    transferBeforePelletDestinationLabels = MapThread[
      Function[{cellIsoTechnique, cellPelletContainer, cellPelletContainerWell},
        If[MatchQ[cellIsoTechnique, Pellet] && MatchQ[cellPelletContainer, Except[Null]],
          "Post Transfer Pre Pellet Sample " <> ToString[{cellPelletContainer, cellPelletContainerWell}],
          Nothing
        ]
      ],
      {Lookup[myResolvedOptions, CellIsolationTechnique], Lookup[myResolvedOptions, CellPelletContainer], Lookup[myResolvedOptions, CellPelletContainerWell]}
    ];
    transferBeforePelletReplaceRules = AssociationThread[transferBeforePelletSamples, transferBeforePelletDestinationLabels];

    (* Media Aspiration Unit Operation *)
    mediaAspirationUnitOperation = Module[
      {mapThreadFriendlyOptionsToPellet, mapThreadFriendlyOptionsToAspirate, mapThreadFriendlyOptionsToPelletTransfer,
        pelletSamplesAndLabels,
        pelletSourceMediaLabels, aspirateSourceMediaLabels,
        labelPelletSourceMediaUnitOperations, labelAspirateSourceMediaUnitOperations,
        pelletTransferCellUnitOperations, pelletCellUnitOperations, aspirateCellUnitOperations
      },
      mapThreadFriendlyOptionsToPellet = PickList[mapThreadFriendlyOptions, Lookup[myResolvedOptions, CellIsolationTechnique], Pellet];
      mapThreadFriendlyOptionsToAspirate = PickList[mapThreadFriendlyOptions, Lookup[myResolvedOptions, CellIsolationTechnique], Aspirate];
      mapThreadFriendlyOptionsToPelletTransfer = PickList[mapThreadFriendlyOptions, Transpose[{Lookup[myResolvedOptions, CellIsolationTechnique], Lookup[myResolvedOptions, CellPelletContainer]}], {Pellet, Except[Null]}];

      (* these are ALL the samples that will get pelleted; this includes stuff that was transferred before and stuff that was not *)
      pelletSamplesAndLabels = PickList[mySamples, Lookup[myResolvedOptions, CellIsolationTechnique], Pellet] /. transferBeforePelletReplaceRules;

      (* Waste Containers *)
      pelletSourceMediaLabels = Table[
        CreateUniqueLabel["ExperimentWashCells pellet source media", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels],
        {x, 1, Length[mapThreadFriendlyOptionsToPellet]}
      ];
      aspirateSourceMediaLabels = Table[
        CreateUniqueLabel["ExperimentWashCells aspirate source media", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels],
        {x, 1, Length[mapThreadFriendlyOptionsToAspirate]}
      ];

      (* tentative container for source media*)
      labelPelletSourceMediaUnitOperations = If[Length[mapThreadFriendlyOptionsToPellet] > 0,
        {
          LabelContainer[
            Label -> pelletSourceMediaLabels,
            Container -> PreferredContainer[Max[Lookup[samplePackets, Volume]], LiquidHandlerCompatible -> True, Type -> Vessel]
          ]
        },
        Nothing
      ];
      labelAspirateSourceMediaUnitOperations = If[Length[mapThreadFriendlyOptionsToAspirate] > 0,
        {
          LabelContainer[
            Label -> aspirateSourceMediaLabels,
            Container -> PreferredContainer[Max[Lookup[samplePackets, Volume]], LiquidHandlerCompatible -> True, Type -> Vessel]
          ]
        },
        Nothing
      ];

      pelletTransferCellUnitOperations = If[Length[mapThreadFriendlyOptionsToPelletTransfer] > 0,
        Transfer[
          Source -> transferBeforePelletSamples,
          Destination -> Lookup[mapThreadFriendlyOptionsToPelletTransfer, CellPelletContainer],
          DestinationWell -> Lookup[mapThreadFriendlyOptionsToPelletTransfer, CellPelletContainerWell],
          Amount -> All,
          DestinationLabel -> transferBeforePelletDestinationLabels
        ],
        Nothing
      ];
      pelletCellUnitOperations = If[Length[mapThreadFriendlyOptionsToPellet] > 0,
        {
          Pellet[
            Sample -> pelletSamplesAndLabels,
            Instrument -> Lookup[mapThreadFriendlyOptionsToPellet, CellIsolationInstrument],
            Intensity -> Lookup[mapThreadFriendlyOptionsToPellet, CellPelletIntensity],
            Time -> Lookup[mapThreadFriendlyOptionsToPellet, CellIsolationTime],
            SupernatantVolume -> Lookup[mapThreadFriendlyOptionsToPellet, CellAspirationVolume],
            SupernatantDestination -> pelletSourceMediaLabels,
            Preparation -> Robotic
          ],
          MapThread[
            Function[{source, mapThreadFriendlyOption},
              If[MatchQ[Lookup[mapThreadFriendlyOption, AliquotSourceMedia], True],
                Transfer[
                  Source -> source,
                  Amount -> Lookup[mapThreadFriendlyOption, AliquotMediaVolume],
                  Destination -> Lookup[mapThreadFriendlyOption, AliquotMediaContainer],
                  DestinationWell -> Lookup[mapThreadFriendlyOption, AliquotMediaContainerWell],
                  DestinationLabel -> Lookup[mapThreadFriendlyOption, AliquotMediaLabel],
                  DestinationContainerLabel -> Lookup[mapThreadFriendlyOption, AliquotMediaContainerLabel],
                  SamplesOutStorageCondition -> Lookup[mapThreadFriendlyOption, AliquotMediaStorageCondition] /. Null -> Disposal
                ],
                Nothing
              ]
            ],
            {pelletSourceMediaLabels, mapThreadFriendlyOptionsToPellet}
          ]
        },
        Nothing
      ];

      aspirateCellUnitOperations = If[Length[mapThreadFriendlyOptionsToAspirate] > 0,
        {
          Transfer[
            Source -> PickList[mySamples, Lookup[myResolvedOptions, CellIsolationTechnique], Aspirate],
            Amount -> Lookup[mapThreadFriendlyOptionsToAspirate, CellAspirationVolume],
            AspirationAngle -> Lookup[mapThreadFriendlyOptionsToAspirate, CellAspirationAngle],
            Destination -> aspirateSourceMediaLabels
          ],
          MapThread[
            Function[{source, mapThreadFriendlyOption},
              If[MatchQ[Lookup[mapThreadFriendlyOption, AliquotSourceMedia], True],
                Transfer[
                  Source -> source,
                  Amount -> Lookup[mapThreadFriendlyOption, AliquotMediaVolume],
                  Destination -> Lookup[mapThreadFriendlyOption, AliquotMediaContainer],
                  DestinationWell -> Lookup[mapThreadFriendlyOption, AliquotMediaContainerWell],
                  DestinationLabel -> Lookup[mapThreadFriendlyOption, AliquotMediaLabel],
                  DestinationContainerLabel -> Lookup[mapThreadFriendlyOption, AliquotMediaContainerLabel],
                  SamplesOutStorageCondition -> Lookup[mapThreadFriendlyOption, AliquotMediaStorageCondition] /. Null -> Disposal
                ],
                Nothing
              ]
            ],
            {aspirateSourceMediaLabels, mapThreadFriendlyOptionsToAspirate}
          ]
        },
        Nothing
      ];

      Flatten[{labelPelletSourceMediaUnitOperations, labelAspirateSourceMediaUnitOperations, pelletTransferCellUnitOperations, pelletCellUnitOperations, aspirateCellUnitOperations}]
    ];

    mapThreadFriendlyOptionsToPelletAndWash = PickList[mapThreadFriendlyOptions, Transpose[{Lookup[myResolvedOptions, CellIsolationTechnique], Lookup[myResolvedOptions, NumberOfWashes]}], {Pellet, GreaterP[0]}];
    mapThreadFriendlyOptionsToPelletWashAndMix = PickList[mapThreadFriendlyOptions, Transpose[{Lookup[myResolvedOptions, CellIsolationTechnique], Lookup[myResolvedOptions, NumberOfWashes], Lookup[myResolvedOptions, WashMixType]}], {Pellet, GreaterP[0], (Shake | Pipette)}];
    mapThreadFriendlyOptionsToAspirateAndWash = PickList[mapThreadFriendlyOptions, Transpose[{Lookup[myResolvedOptions, CellIsolationTechnique], Lookup[myResolvedOptions, NumberOfWashes]}], {Aspirate, GreaterP[0]}];
    mapThreadFriendlyOptionsToAspirateWashAndMix = PickList[mapThreadFriendlyOptions, Transpose[{Lookup[myResolvedOptions, CellIsolationTechnique], Lookup[myResolvedOptions, NumberOfWashes], Lookup[myResolvedOptions, WashMixType]}], {Aspirate, GreaterP[0], (Shake | Pipette)}];

    washSamplesAndLabels = PickList[mySamples, Lookup[myResolvedOptions, NumberOfWashes], GreaterP[0]] /. transferBeforePelletReplaceRules;
    pelletWashSamplesAndLabels = PickList[mySamples, Transpose[{Lookup[myResolvedOptions, CellIsolationTechnique], Lookup[myResolvedOptions, NumberOfWashes]}], {Pellet, GreaterP[0]}] /. transferBeforePelletReplaceRules;
    pelletWashMixSamplesAndLabels = PickList[mySamples, Transpose[{Lookup[myResolvedOptions, CellIsolationTechnique], Lookup[myResolvedOptions, NumberOfWashes], Lookup[myResolvedOptions, WashMixType]}], {Pellet, GreaterP[0], (Shake | Pipette)}] /. transferBeforePelletReplaceRules;

    washSamplesUnitOperations =
        If[Length[mapThreadFriendlyOptionsToWash] > 0,
          Map[
            Function[{washNumber},
              Module[{samplesToWash, samplesToPelletAndWash, samplesToPelletWashAndMix, samplesToAspirateAndWash, samplesToAspirateWashAndMix,
                washUnitOperations, pelletWashUnitOperations, aspirateWashUnitOperations},

                samplesToWash = PickList[mapThreadFriendlyOptionsToWash, Lookup[mapThreadFriendlyOptionsToWash, NumberOfWashes], GreaterEqualP[washNumber]];
                samplesToPelletAndWash = PickList[mapThreadFriendlyOptionsToWash, Transpose[{Lookup[mapThreadFriendlyOptionsToWash, CellIsolationTechnique], Lookup[mapThreadFriendlyOptionsToWash, NumberOfWashes]}], {Pellet, GreaterEqualP[washNumber]}];
                samplesToPelletWashAndMix = PickList[mapThreadFriendlyOptionsToWash, Transpose[{Lookup[mapThreadFriendlyOptionsToWash, CellIsolationTechnique], Lookup[mapThreadFriendlyOptionsToWash, NumberOfWashes], Lookup[mapThreadFriendlyOptionsToWash, WashMixType]}], {Pellet, GreaterEqualP[washNumber], (Shake | Pipette)}];
                samplesToAspirateAndWash = PickList[mapThreadFriendlyOptionsToWash, Transpose[{Lookup[mapThreadFriendlyOptionsToWash, CellIsolationTechnique], Lookup[mapThreadFriendlyOptionsToWash, NumberOfWashes]}], {Aspirate, GreaterEqualP[washNumber]}];
                samplesToAspirateWashAndMix = PickList[mapThreadFriendlyOptionsToWash, Transpose[{Lookup[mapThreadFriendlyOptionsToWash, CellIsolationTechnique], Lookup[mapThreadFriendlyOptionsToWash, NumberOfWashes], Lookup[mapThreadFriendlyOptionsToWash, WashMixType]}], {Aspirate, GreaterEqualP[washNumber], (Shake | Pipette)}];

                washUnitOperations = If[Length[samplesToWash] > 0,
                  Transfer[
                    Source -> PickList[washSolutionContainerLabels, Lookup[mapThreadFriendlyOptionsToWash, NumberOfWashes], GreaterEqualP[washNumber]],
                    Destination -> PickList[washSamplesAndLabels, Lookup[mapThreadFriendlyOptionsToWash, NumberOfWashes], GreaterEqualP[washNumber]],
                    Amount -> Lookup[samplesToWash, WashVolume]
                  ],
                  Nothing
                ];

                pelletWashUnitOperations =
                    If[Length[samplesToPelletAndWash] > 0,
                      {
                        If[Length[samplesToPelletWashAndMix] > 0,
                          Mix[
                            Sample -> PickList[pelletWashMixSamplesAndLabels, Lookup[mapThreadFriendlyOptionsToPelletWashAndMix, NumberOfWashes], GreaterEqualP[washNumber]],
                            MixType -> Lookup[samplesToPelletWashAndMix, WashMixType],
                            Instrument -> Lookup[samplesToPelletWashAndMix, WashMixInstrument],
                            MixRate -> Lookup[samplesToPelletWashAndMix, WashMixRate],
                            Temperature -> (Lookup[samplesToPelletWashAndMix, WashTemperature] /. Ambient -> $AmbientTemperature),
                            Time -> Lookup[samplesToPelletWashAndMix, WashMixTime],
                            NumberOfMixes -> Lookup[samplesToPelletWashAndMix, NumberOfWashMixes],
                            MixVolume -> Lookup[samplesToPelletWashAndMix, WashMixVolume]
                          ],
                          Nothing
                        ],
                        Pellet[
                          Sample -> PickList[pelletWashSamplesAndLabels, Lookup[mapThreadFriendlyOptionsToPelletAndWash, NumberOfWashes], GreaterEqualP[washNumber]],
                          ContainerOutLabel -> Automatic,
                          SampleOutLabel -> Automatic,
                          Instrument -> Lookup[samplesToPelletAndWash, CellIsolationInstrument],
                          Intensity -> Lookup[samplesToPelletAndWash, WashPelletIntensity],
                          Time -> Lookup[samplesToPelletAndWash, WashIsolationTime],
                          SupernatantVolume -> Lookup[samplesToPelletAndWash, WashAspirationVolume],
                          Preparation -> Robotic
                        ]
                      },
                      Nothing
                    ];

                aspirateWashUnitOperations =
                    If[Length[samplesToAspirateAndWash] > 0,
                      {
                        If[Length[samplesToAspirateWashAndMix] > 0,
                          Mix[
                            Sample -> PickList[mySamples, Transpose[{Lookup[myResolvedOptions, CellIsolationTechnique], Lookup[myResolvedOptions, NumberOfWashes], Lookup[myResolvedOptions, WashMixType]}], {Aspirate, GreaterEqualP[washNumber], (Shake | Pipette)}],
                            MixType -> Lookup[samplesToAspirateWashAndMix, WashMixType],
                            Instrument -> Lookup[samplesToAspirateWashAndMix, WashMixInstrument],
                            MixRate -> Lookup[samplesToAspirateWashAndMix, WashMixRate],
                            Temperature -> (Lookup[samplesToAspirateWashAndMix, WashTemperature] /. Ambient -> $AmbientTemperature),
                            Time -> Lookup[samplesToAspirateWashAndMix, WashMixTime],
                            NumberOfMixes -> Lookup[samplesToAspirateWashAndMix, NumberOfWashMixes],
                            MixVolume -> Lookup[samplesToAspirateWashAndMix, WashMixVolume]
                          ],
                          Nothing
                        ],
                        Transfer[
                          Source -> PickList[mySamples, Transpose[{Lookup[myResolvedOptions, CellIsolationTechnique], Lookup[myResolvedOptions, NumberOfWashes]}], {Aspirate, GreaterEqualP[washNumber]}],
                          AspirationAngle -> Lookup[samplesToAspirateAndWash, WashAspirationAngle],
                          Amount -> Lookup[samplesToAspirateAndWash, WashAspirationVolume],
                          (*give a new container, Waste is a manual step*)
                          Destination -> ConstantArray[Model[Container, Plate, "id:E8zoYveRllM7"], Length[samplesToAspirateAndWash]] (* "48-well Pyramid Bottom Deep Well Plate" *)
                        ]
                      },
                      Nothing
                    ];
                Flatten[{washUnitOperations, pelletWashUnitOperations, aspirateWashUnitOperations}]
              ]
            ],
            Range[Max[Lookup[myResolvedOptions, NumberOfWashes]]]
          ],
          Nothing
        ];

    resuspensionUnitOperations = Module[
      {mapThreadFriendlyOptionsToResuspendAndMix,
        resuspensionSamplesAndLabels, resuspensionMixSamplesAndLabels,
        resuspendMediaUnitOperations, resuspendMediaMixUnitOperations},

      mapThreadFriendlyOptionsToResuspendAndMix = PickList[mapThreadFriendlyOptions, Transpose[{Lookup[myResolvedOptions, ResuspensionMedia], Lookup[myResolvedOptions, ResuspensionMixType]}], {ObjectP[], Except[None | Null]}];

      resuspensionSamplesAndLabels = PickList[mySamples, Lookup[myResolvedOptions, ResuspensionMedia], ObjectP[]] /. transferBeforePelletReplaceRules;
      resuspensionMixSamplesAndLabels = PickList[mySamples, Transpose[{Lookup[myResolvedOptions, ResuspensionMedia], Lookup[myResolvedOptions, ResuspensionMixType]}], {ObjectP[], (Shake | Pipette)}] /. transferBeforePelletReplaceRules;

      resuspendMediaUnitOperations =
          If[MemberQ[Lookup[myResolvedOptions, ResuspensionMedia], ObjectP[]],
            Transfer[
              Source -> resuspensionMediaContainerLabels,
              Destination -> resuspensionSamplesAndLabels,
              Amount -> Lookup[mapThreadFriendlyOptionsToResuspend, ResuspensionMediaVolume]
            ],
            Nothing
          ];
      resuspendMediaMixUnitOperations = If[MemberQ[Transpose[{Lookup[myResolvedOptions, ResuspensionMedia], Lookup[myResolvedOptions, ResuspensionMixType]}], {ObjectP[], Except[None | Null]}],
        Mix[
          Sample -> resuspensionMixSamplesAndLabels,
          MixType -> Lookup[mapThreadFriendlyOptionsToResuspendAndMix, ResuspensionMixType],
          Instrument -> Lookup[mapThreadFriendlyOptionsToResuspendAndMix, ResuspensionMixInstrument],
          MixRate -> Lookup[mapThreadFriendlyOptionsToResuspendAndMix, ResuspensionMixRate],
          Temperature -> (Lookup[mapThreadFriendlyOptionsToResuspendAndMix, ResuspensionTemperature] /. Ambient -> $AmbientTemperature),
          Time -> Lookup[mapThreadFriendlyOptionsToResuspendAndMix, ResuspensionMixTime],
          NumberOfMixes -> Lookup[mapThreadFriendlyOptionsToResuspendAndMix, NumberOfResuspensionMixes],
          MixVolume -> Lookup[mapThreadFriendlyOptionsToResuspendAndMix, ResuspensionMixVolume]
        ],
        Nothing
      ];
      Flatten[{resuspendMediaUnitOperations, resuspendMediaMixUnitOperations}]
    ];

    (* UnitOperation for Replate *)
    replateCellsUnitOperations = Module[{mapThreadFriendlyOptionsToReplate, replateCellsSamplesAndLabels},
      mapThreadFriendlyOptionsToReplate = PickList[mapThreadFriendlyOptions, Lookup[myResolvedOptions, ReplateCells], True];
      replateCellsSamplesAndLabels = PickList[mySamples, Lookup[myResolvedOptions, ReplateCells], True] /. transferBeforePelletReplaceRules;

      If[Length[mapThreadFriendlyOptionsToReplate] > 0,
        Transfer[
          Source -> replateCellsSamplesAndLabels,
          Destination -> Lookup[mapThreadFriendlyOptionsToReplate, ContainerOut],
          DestinationWell -> Lookup[mapThreadFriendlyOptionsToReplate, ContainerOutWell],
          Amount -> All,
          DestinationLabel -> Lookup[mapThreadFriendlyOptionsToReplate, SampleOutLabel],
          DestinationContainerLabel -> Lookup[mapThreadFriendlyOptionsToReplate, ContainerOutLabel] /. Null -> Automatic
        ],
        Nothing
      ]
    ];

    (* SampleOutLabel for every sample output*)
    sampleOutLabelUnitOperations = Module[{noReplateCellsSamplesAndLabels, mapThreadFriendlyOptionsToNoReplate},
      mapThreadFriendlyOptionsToNoReplate = PickList[mapThreadFriendlyOptions, Lookup[myResolvedOptions, ReplateCells], Except[True]];
      noReplateCellsSamplesAndLabels = PickList[mySamples, Lookup[myResolvedOptions, ReplateCells], Except[True]] /. transferBeforePelletReplaceRules;
      If[Length[mapThreadFriendlyOptionsToNoReplate] > 0,
        LabelSample[
          Sample -> noReplateCellsSamplesAndLabels,
          Label -> Lookup[mapThreadFriendlyOptionsToNoReplate, SampleOutLabel]
        ],
        Nothing
      ]
    ];

    (* Combine to together *)
    primitives = Flatten[{
      equilibrationUnitOperations,
      mediaAspirationUnitOperation,
      washSamplesUnitOperations,
      resuspensionUnitOperations,
      replateCellsUnitOperations,
      sampleOutLabelUnitOperations
    }];

    (* Set this internal variable to unit test the unit operations that are created by this function. *)
    $WashCellsUnitOperations = primitives;

    (* Get our robotic unit operation packets. *)
    {{roboticUnitOperationPackets, roboticRunTime}, roboticSimulation} =
        ExperimentRoboticCellPreparation[
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
          CoverAtEnd -> False(*,
          Debug -> True*)
        ];

    subRoboticUnitOperations = Download[Cases[Flatten[Lookup[roboticUnitOperationPackets, Replace[RoboticUnitOperations]]], ObjectP[]], Object];
    roboticUnitOperationsToUse = Select[roboticUnitOperationPackets, Not[MatchQ[#, ObjectP[subRoboticUnitOperations]]]&];


    (* Create our own output unit operation packet, linking up the "sub" robotic unit operation objects. *)
    outputUnitOperationPacket = UploadUnitOperation[
      Module[{nonHiddenOptions},
        (* Only include non-hidden options from WashCells. *)
        nonHiddenOptions = allowedKeysForUnitOperationType[Object[UnitOperation, WashCells]];

        (* Override any options with resource. *)
        WashCells@Join[
          Cases[Normal[expandedResolvedOptionsWithLabels, Association], Verbatim[Rule][Alternatives @@ nonHiddenOptions, _]],
          {
            Sample -> samplesInResources,
            RoboticUnitOperations -> If[Length[roboticUnitOperationsToUse] == 0,
              {},
              (Link /@ Lookup[roboticUnitOperationsToUse, Object])
            ]
          }
        ]
      ],
      UnitOperationType -> Output,
      Upload -> False
    ];


    (* Simulate the resources for our main UO since it's now the only thing that doesn't have resources. *)
    roboticSimulation = UpdateSimulation[
      roboticSimulation,
      Simulation[<|Object -> Lookup[outputUnitOperationPacket, Object], Sample -> (Link /@ mySamples)|>]
    ];

    (* Return back our packets and simulation. *)
    {
      Null,
      Flatten[{outputUnitOperationPacket, roboticUnitOperationPackets}],
      roboticSimulation,
      (roboticRunTime + (10 Minute))
    }
  ];

  (* Make list of all the resources we need to check in FRQ *)
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
  testsRule = Tests -> If[
    gatherTests,
    resourceTests,
    {}
  ];

  (* Generate the Result output rule *)
  (* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
  resultRule = Result -> If[MemberQ[output, Result] && TrueQ[resourcesOk],
    {Flatten[{protocolPacket, allUnitOperationPackets}], currentSimulation, runTime},
    $Failed
  ];


  (* Return the output as we desire it *)
  outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}

];