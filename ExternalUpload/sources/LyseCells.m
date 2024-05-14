(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(* Source Code *)


(* ::Subsection:: *)
(* UploadLyseCellsMethod *)


(* ::Subsubsection:: *)
(* Options and Messages *)


DefineOptions[UploadLyseCellsMethod,
  Options :> {
    IndexMatching[
      IndexMatchingInput -> "Input Data",

      {
        OptionName -> CellType,
        Default -> Null,
        Description->"The taxon of the organism or cell line from which the cell sample originates. Options include Bacterial, Mammalian, Insect, Plant, and Yeast.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> CellTypeP
        ],
        Category -> "General"
      },
      {
        OptionName -> TargetCellularComponent,
        Default -> Null,
        AllowNull -> True,
        Description -> "The class of biomolecule whose purification is desired following lysis of the cell sample and any subsequent extraction operations. Options include CytosolicProtein, PlasmaMembraneProtein, NuclearProtein, SecretoryProtein, TotalProtein, RNA, GenomicDNA, PlasmidDNA, Organelle, Virus and Unspecified.",
        Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[CellularComponentP, Unspecified]],
        Category -> "General"
      },

      (* --- NUMBER OF LYSIS STEPS --- *)

      {
        OptionName -> NumberOfLysisSteps,
        Default -> Null,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[1, 2, 3]],
        Description -> "The number of times that the cell sample is subjected to a unique set of conditions for disruption of the cell membranes. These conditions include the LysisSolution, LysisSolutionVolume, MixType, MixRate, NumberOfMixes, MixVolume, MixTemperature, MixInstrument, LysisTime, LysisTemperature, and IncubationInstrument.",
        Category -> "General"
      },

      (* --- OPTIONS FOR PELLETING PRIOR TO LYSIS --- *)

      {
        OptionName -> PreLysisPellet,
        Default -> Null,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
        Description -> "Indicates if the cell sample is centrifuged to remove unwanted media prior to addition of LysisSolution.",
        Category -> "Pelleting"
      },
      {
        OptionName -> PreLysisPelletingIntensity,
        Default -> Null,
        AllowNull -> True,
        Widget -> Alternatives[
          "Revolutions per Minute" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 RPM, $MaxRoboticCentrifugeSpeed],
            Units -> Alternatives[RPM]
          ],
          "Relative Centrifugal Force" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 GravitationalAcceleration, $MaxRoboticRelativeCentrifugalForce],
            Units -> Alternatives[GravitationalAcceleration]
          ]
        ],
        Description -> "The rotational speed or force applied to the cell sample to facilitate separation of the cells from the media.",
        Category -> "Pelleting"
      },
      {
        OptionName -> PreLysisPelletingTime,
        Default -> Null,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Description -> "The duration for which the cell sample is centrifuged at PreLysisPelletingIntensity to facilitate separation of the cells from the media.",
        Category -> "Pelleting"
      },

      (* --- CONDITIONS FOR PRIMARY LYSIS STEP --- *)

      {
        OptionName -> LysisSolution,
        Default -> Null,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
          OpenPaths -> {
            {Object[Catalog, "Root"], "Materials", "Reagents"}
          }
        ],
        Description -> "The solution employed for disruption of cell membranes, including enzymes, detergents, and chaotropics.",
        Category -> "Lysis Solution Addition"
      },
      {
        OptionName -> MixType,
        Default -> Null,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Shake, Pipette, None]],
        Description -> "The manner in which the sample is mixed following combination of cell sample and LysisSolution.",
        Category -> "Mixing"
      },
      {
        OptionName -> MixRate,
        Default -> Null,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 RPM, $MaxMixRate], Units -> RPM],
        Description -> "The rate at which the sample is mixed by the selected MixType during the MixTime.",
        Category -> "Mixing"
      },
      {
        OptionName -> MixTime,
        Default -> Null,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Description -> "The duration for which the sample is mixed by the selected MixType following combination of the cell sample and the LysisSolution.",
        Category -> "Mixing"
      },
      {
        OptionName -> NumberOfMixes,
        Default -> Null,
        AllowNull -> True,
        Widget -> Widget[Type -> Number, Pattern :> RangeP[1, $MaxNumberOfMixes, 1]],
        Description -> "The number of times that the sample is mixed by pipetting the MixVolume up and down following combination of the cell sample and the LysisSolution.",
        Category -> "Mixing"
      },
      {
        OptionName -> MixTemperature,
        Default -> Null,
        AllowNull -> True,
        Widget -> Alternatives[
          "Temperature" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],
            Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}
          ],
          "Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        Description -> "The temperature at which the instrument heating or cooling the cell sample is maintained during the MixTime, which occurs immediately before the LysisTime.",
        Category -> "Mixing"
      },
      {
        OptionName -> LysisTime,
        Default -> Null,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Description -> "The minimum duration for which the IncubationInstrument is maintained at the LysisTemperature to facilitate the disruption of cell membranes and release of cellular contents. The LysisTime occurs immediately after addition of LysisSolution and optional mixing.",
        Category -> "Cell Lysis"
      },
      {
        OptionName -> LysisTemperature,
        Default -> Null,
        AllowNull -> True,
        Widget -> Alternatives[
          "Temperature" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],
            Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}
          ],
          "Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        Description -> "The temperature at which the IncubationInstrument is maintained during the LysisTime, following the mixing of the cell sample and LysisSolution.",
        Category -> "Cell Lysis"
      },

      (* --- CONDITIONS FOR SECONDARY LYSIS STEP --- *)

      {
        OptionName -> SecondaryLysisSolution,
        Default -> Null,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
          OpenPaths -> {
            {Object[Catalog, "Root"], "Materials", "Reagents"}
          }
        ],
        Description -> "The solution employed for disruption of cell membranes, including enzymes, detergents, and chaotropics in an optional second lysis step.",
        Category -> "Lysis Solution Addition"
      },
      {
        OptionName -> SecondaryMixType,
        Default -> Null,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Shake, Pipette, None]],
        Description -> "The manner in which the sample is mixed following combination of cell sample and SecondaryLysisSolution in an optional second lysis step.",
        Category -> "Mixing"
      },
      {
        OptionName -> SecondaryMixRate,
        Default -> Null,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 RPM, $MaxMixRate],
          Units -> RPM
        ],
        Description -> "The rate at which the sample is mixed by the selected SecondaryMixType during the SecondaryMixTime in an optional second lysis step.",
        Category -> "Mixing"
      },
      {
        OptionName -> SecondaryMixTime,
        Default -> Null,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Description -> "The duration for which the sample is mixed by the selected SecondaryMixType following combination of the cell sample and the SecondaryLysisSolution in an optional second lysis step.",
        Category -> "Mixing"
      },
      {
        OptionName -> SecondaryNumberOfMixes,
        Default -> Null,
        AllowNull -> True,
        Widget -> Widget[Type -> Number, Pattern :> RangeP[1, $MaxNumberOfMixes, 1]],
        Description -> "The number of times that the sample is mixed by pipetting the SecondaryMixVolume up and down following combination of the cell sample and the SecondaryLysisSolution in an optional second lysis step.",
        Category -> "Mixing"
      },
      {
        OptionName -> SecondaryMixTemperature,
        Default -> Null,
        AllowNull -> True,
        Widget -> Alternatives[
          "Temperature" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],
            Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}
          ],
          "Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        Description -> "The temperature at which the instrument heating or cooling the cell sample is maintained during the SecondaryMixTime, which occurs immediately before the SecondaryLysisTime in an optional second lysis step.",
        Category -> "Mixing"
      },
      {
        OptionName -> SecondaryLysisTime,
        Default -> Null,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Description -> "The minimum duration for which the SecondaryIncubationInstrument is maintained at the SecondaryLysisTemperature to facilitate the disruption of cell membranes and release of cellular contents in an optional second lysis step. The SecondaryLysisTime occurs immediately after addition of SecondaryLysisSolution and optional mixing.",
        Category -> "Cell Lysis"
      },
      {
        OptionName -> SecondaryLysisTemperature,
        Default -> Null,
        AllowNull -> True,
        Widget -> Alternatives[
          "Temperature" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],
            Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}
          ],
          "Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        Description -> "The temperature at which the SecondaryIncubationInstrument is maintained during the SecondaryLysisTime, following the mixing of the cell sample and SecondaryLysisSolution in an optional second lysis step.",
        Category -> "Cell Lysis"
      },

      (* --- CONDITIONS FOR TERTIARY LYSIS STEP --- *)

      {
        OptionName -> TertiaryLysisSolution,
        Default -> Null,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
          OpenPaths -> {
            {Object[Catalog, "Root"], "Materials", "Reagents"}
          }
        ],
        Description -> "The solution employed for disruption of cell membranes, including enzymes, detergents, and chaotropics in an optional third lysis step.",
        Category -> "Lysis Solution Addition"
      },
      {
        OptionName -> TertiaryMixType,
        Default -> Null,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Shake, Pipette, None]],
        Description -> "The manner in which the sample is mixed following combination of cell sample and TertiaryLysisSolution in an optional third lysis step.",
        Category -> "Mixing"
      },
      {
        OptionName -> TertiaryMixRate,
        Default -> Null,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 RPM, $MaxMixRate], Units -> RPM],
        Description -> "The rate at which the sample is mixed by the selected TertiaryMixType during the TertiaryMixTime in an optional third lysis step.",
        Category -> "Mixing"
      },
      {
        OptionName -> TertiaryMixTime,
        Default -> Null,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Description -> "The duration for which the sample is mixed by the selected TertiaryMixType following combination of the cell sample and the TertiaryLysisSolution in an optional third lysis step.",
        Category -> "Mixing"
      },
      {
        OptionName -> TertiaryNumberOfMixes,
        Default -> Null,
        AllowNull -> True,
        Widget -> Widget[Type -> Number, Pattern :> RangeP[1, $MaxNumberOfMixes, 1]],
        Description -> "The number of times that the sample is mixed by pipetting the TertiaryMixVolume up and down following combination of the cell sample and the TertiaryLysisSolution in an optional third lysis step.",
        Category -> "Mixing"
      },
      {
        OptionName -> TertiaryMixTemperature,
        Default -> Null,
        AllowNull -> True,
        Widget -> Alternatives[
          "Temperature" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],
            Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}
          ],
          "Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        Description -> "The temperature at which the instrument heating or cooling the cell sample is maintained during the TertiaryMixTime, which occurs immediately before the TertiaryLysisTime in an optional third lysis step.",
        Category -> "Mixing"
      },
      {
        OptionName -> TertiaryLysisTime,
        Default -> Null,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Description -> "The minimum duration for which the TertiaryIncubationInstrument is maintained at the TertiaryLysisTemperature to facilitate the disruption of cell membranes and release of cellular contents in an optional third lysis step. The TertiaryLysisTime occurs immediately after addition of TertiaryLysisSolution and optional mixing.",
        Category -> "Cell Lysis"
      },
      {
        OptionName -> TertiaryLysisTemperature,
        Default -> Null,
        AllowNull -> True,
        Widget -> Alternatives[
          "Temperature" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],
            Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}
          ],
          "Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        Description -> "The temperature at which the TertiaryIncubationInstrument is maintained during the TertiaryLysisTime, following the mixing of the cell sample and TertiaryLysisSolution in an optional third lysis step.",
        Category -> "Cell Lysis"
      },

      (* --- LYSATE CLARIFICATION --- *)

      {
        OptionName -> ClarifyLysate,
        Default -> Null,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
        Description -> "Indicates if the lysate is centrifuged to remove cellular debris following incubation in the presence of LysisSolution.",
        Category -> "Lysate Clarification"
      },
      {
        OptionName -> ClarifyLysateIntensity,
        Default -> Null,
        AllowNull -> True,
        Widget -> Alternatives[
          "Revolutions per Minute" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 RPM, $MaxRoboticCentrifugeSpeed],
            Units -> Alternatives[RPM]
          ],
          "Relative Centrifugal Force" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 GravitationalAcceleration, $MaxRoboticRelativeCentrifugalForce],
            Units -> Alternatives[GravitationalAcceleration]
          ]
        ],
        Description -> "The rotational speed or force applied to the lysate to facilitate separation of insoluble cellular debris from the lysate solution following incubation in the presence of LysisSolution.",
        Category -> "Lysate Clarification"
      },
      {
        OptionName -> ClarifyLysateTime,
        Default -> Null,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Description -> "The duration for which the lysate is centrifuged at ClarifyLysateIntensity to facilitate separation of insoluble cellular debris from the lysate solution following incubation in the presence of LysisSolution.",
        Category -> "Lysate Clarification"
      }
    ]
  },
  SharedOptions :> {
    ExternalUploadHiddenOptions
  }
];

InstallDefaultUploadFunction[UploadLyseCellsMethod, Object[Method, LyseCells]];
InstallValidQFunction[UploadLyseCellsMethod, Object[Method, LyseCells]];
InstallOptionsFunction[UploadLyseCellsMethod, Object[Method, LyseCells]];