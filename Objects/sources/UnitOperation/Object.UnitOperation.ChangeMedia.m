(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: User *)
(* :Date: 2023-06-12 *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

$SharedChangeMediaUnitOperationFields={
  (* --- SAMPLES AND SAMPLE LABELS --- *)
  SampleLink -> {
    Format -> Multiple,
    Class -> Link,
    Pattern :> _Link,
    Relation -> Alternatives[
      Object[Sample],
      Model[Sample],
      Model[Container],
      Object[Container]
    ],
    Description -> "The samples that are going to be changed media.",
    Category -> "General",
    Migration->SplitField
  },
  SampleString -> {
    Format -> Multiple,
    Class -> String,
    Pattern :> _String,
    Relation -> Null,
    Description -> "The samples that are going to be changed media.",
    Category -> "General",
    Migration->SplitField
  },
  SampleExpression -> {
    Format -> Multiple,
    Class -> Expression,
    Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
    Relation -> Null,
    Description -> "The samples that are going to be changed media.",
    Category -> "General",
    Migration->SplitField
  },
  SampleLabel -> {
    Format -> Multiple,
    Class -> String,
    Pattern :> _String,
    Relation -> Null,
    Description -> "For each member of SampleLink, a user defined word or phrase used to identify the sample that is used in the experiment, for use in downstream unit operations.",
    IndexMatching -> SampleLink,
    Category -> "General"
  },
  SampleContainerLabel -> {
    Format -> Multiple,
    Class -> String,
    Pattern :> _String,
    Relation -> Null,
    Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container of the sample that is used in the experiment, for use in downstream unit operations.",
    IndexMatching -> SampleLink,
    Category -> "General"
  },
  (* --- GENERAL OPTIONS --- *)
  MethodLink -> {
    Format -> Multiple,
    Class -> Link,
    Pattern :> _Link,
    Relation -> Alternatives[Object[Method,WashCells]],
    Description -> "For each member of SampleLink, the set of reagents and recommended operating conditions which are used to change media of the cell sample.",
    Category -> "General",
    IndexMatching -> SampleLink,
    Migration -> SplitField
  },
  MethodExpression -> {
    Format -> Multiple,
    Class -> Expression,
    Pattern :> Alternatives[Custom],
    Description -> "For each member of SampleLink, the set of reagents and recommended operating conditions which are used to change media of the cell sample.",
    Category -> "General",
    IndexMatching -> SampleLink,
    Migration -> SplitField
  },
  CellType -> {
    Format -> Multiple,
    Class -> Expression,
    Pattern :> CellTypeP,
    Description -> "For each member of SampleLink, the taxon of the organism or cell line from which the cell sample originates. Options include Bacterial, Mammalian, Insect, Plant, and Yeast.",
    IndexMatching -> SampleLink,
    Category -> "General"
  },
  RoboticInstrument -> {
    Format -> Multiple,
    Class -> Link,
    Pattern :> _Link,
    Relation -> Alternatives[
      Object[Instrument],
      Model[Instrument]
    ],
    Description -> "For each member of SampleLink, the instrument that transfers the sample and buffers between containers to execute the protocol.",
    IndexMatching -> SampleLink,
    Category -> "General"
  },
  CultureAdhesion -> {
    Format -> Multiple,
    Class -> Expression,
    Pattern :> Alternatives[Suspension, Adherent],
    Description -> "For each member of SampleLink, indicates how the cell sample physically interacts with its container prior to washing cells/changing media. Options include Adherent and Suspension (including any microbial liquid media).",
    Category -> "General"
  },
  CellIsolationTechnique -> {
    Format -> Multiple,
    Class -> Expression,
    Pattern :> Pellet | Aspirate,
    Description -> "For each member of SampleLink, the technique used to remove impurities, debris, and media from cell samples prior to washing cells or changing media. Suspension cells are centrifuged to separate the cells from the media or buffer. Adherent cells remain attached to the bottom of the culture plate whereas the media can be removed via aspiration.",
    IndexMatching -> SampleLink,
    Category -> "General"
  },
  CellIsolationInstrument -> {
    Format -> Multiple,
    Class -> Link,
    Pattern :> _Link,
    Relation -> Alternatives[
      Object[Instrument],
      Model[Instrument]
    ],
    Description -> "For each member of SampleLink, the instrument used to isolate the cell sample prior to washing cells or changing media. Centrifuging separates cells from media, forming a cell pellet. The supernatant is removed or harvested, leaving the cell pellet in the container.",
    IndexMatching -> SampleLink,
    Category -> "General"
  },

  CellAspirationVolumeReal -> {
    Format -> Multiple,
    Class -> Real,
    Pattern :> GreaterEqualP[0 Microliter],
    Units -> Microliter,
    Description -> "For each member of SampleLink, indicates how much media to remove from an input sample of cells prior to washing cell or changing media when isolating with Aspriate or Pellet.",
    IndexMatching -> SampleLink,
    Category -> "Media Aspiration",
    Migration -> SplitField
  },
  CellAspirationVolumeExpression -> {
    Format -> Multiple,
    Class -> Expression,
    Pattern :> Alternatives[All],
    Description -> "For each member of SampleLink, indicates how much media to remove from an input sample of cells prior to washing cell or changing media when isolating with Aspriate or Pellet.",
    IndexMatching -> SampleLink,
    Category -> "Media Aspiration",
    Migration -> SplitField
  },
  CellIsolationTime -> {
    Format -> Multiple,
    Class -> Real,
    Pattern :> GreaterEqualP[0 Second],
    Units -> Minute,
    Description -> "For each member of SampleLink, the amount of time to centrifuge the cell samples prior to washing cells or changing media. Centrifuging is intended to separate cells from media.",
    IndexMatching -> SampleLink,
    Category -> "Media Aspiration"
  },
  CellPelletContainerString -> {
    Format -> Multiple,
    Class -> String,
    Pattern :> _String,
    Description -> "For each member of SampleLink, the container to hold the cell samples in centrifugation prior to washing cells or changing media.",
    IndexMatching -> SampleLink,
    Category -> "Media Aspiration",
    Migration -> SplitField
  }, (* TODO: Why we need a string?*)
  CellPelletContainerExpression -> {
    Format -> Multiple,
    Class -> Expression,
    Pattern :> {WellP, {_Integer, ObjectP[Model[Container]]}} | {_Integer, ObjectP[Model[Container]]} | {ObjectP[Model[Container]]},
    Description -> "For each member of SampleLink, the container to hold the cell samples in centrifugation prior to washing cells or changing media.",
    IndexMatching -> SampleLink,
    Category -> "Media Aspiration",
    Migration -> SplitField
  },
  CellPelletContainerLink -> {
    Format -> Multiple,
    Class -> Link,
    Pattern :> _Link,
    Relation -> Alternatives[Object[Container], Model[Container]],
    Description -> "For each member of SampleLink, the container to hold the cell samples in centrifugation prior to washing cells or changing media.",
    IndexMatching -> SampleLink,
    Category -> "Media Aspiration",
    Migration -> SplitField
  },
  CellPelletContainerWell -> {
    Format -> Multiple,
    Class -> String,
    Pattern :> _String,
    Relation -> Null,
    Description -> "For each member of SampleLink, the well of the container to hold the cell samples in centrifugation prior to washing cells or changing media.",
    IndexMatching -> SampleLink,
    Category -> "Media Aspiration"
  },
  CellPelletIntensity -> {
    Format -> Multiple,
    Class -> VariableUnit,
    Pattern :> GreaterP[0 * RPM] | GreaterP[0 * GravitationalAcceleration],
    Units -> None,
    Description -> "For each member of SampleLink, the rotational speed or force applied to the cell sample by centrifugation prior to washing cells or changing media. Centrifuging is intended to separate cells from media, forming a cell pellet.",
    IndexMatching -> SampleLink,
    Category -> "Media Aspiration"
  },
  CellAspirationAngle -> {
    Format -> Multiple,
    Class -> Real,
    Pattern :> RangeP[0 AngularDegree, 10 AngularDegree, 1 AngularDegree],
    Units -> AngularDegree,
    Description -> "For each member of SampleLink, indicates the tilting angle of the adherent cell culture plate when aspirating off the input sample media. See figure XXX.", (*show a figure*)
    IndexMatching -> SampleLink,
    Category -> "Media Aspiration"
  },
  AliquotSourceMedia -> {
    Format -> Multiple,
    Class -> Boolean,
    Pattern :> BooleanP,
    Description -> "For each member of SampleLink, indicates if sample of source media is collected for future analysis prior to washing.",
    IndexMatching -> SampleLink,
    Category -> "Media Aspiration"
  },
  AliquotMediaVolumeReal -> {
    Format -> Multiple,
    Class -> Real,
    Pattern :> GreaterEqualP[0 Microliter],
    Units -> Microliter,
    Description -> "For each member of SampleLink, the amount of media to collect for analysis after pelleting the cells prior to washing.",
    IndexMatching -> SampleLink,
    Category -> "Media Aspiration",
    Migration -> SplitField
  },
  AliquotMediaVolumeExpression -> {
    Format -> Multiple,
    Class -> Expression,
    Pattern :> Alternatives[All],
    Description -> "For each member of SampleLink, the amount of media to collect for analysis after pelleting the cells prior to washing.",
    IndexMatching -> SampleLink,
    Category -> "Media Aspiration",
    Migration -> SplitField
  },
  AliquotMediaContainerString -> {
    Format -> Multiple,
    Class -> String,
    Pattern :> _String,
    Description -> "For each member of SampleLink, the container used to collect the source media from Media Removal prior to washing.",
    IndexMatching -> SampleLink,
    Category -> "Media Aspiration",
    Migration -> SplitField
  },
  AliquotMediaContainerExpression -> {
    Format -> Multiple,
    Class -> Expression,
    Pattern :> {WellP, {_Integer, ObjectP[Model[Container]]}} | {_Integer, ObjectP[Model[Container]]} | {ObjectP[Model[Container]]},
    Description -> "For each member of SampleLink, the container used to collect the source media from Media Removal prior to washing.",
    IndexMatching -> SampleLink,
    Category -> "Media Aspiration",
    Migration -> SplitField
  },
  AliquotMediaContainerLink -> {
    Format -> Multiple,
    Class -> Link,
    Pattern :> _Link,
    Relation -> Alternatives[Object[Container], Model[Container]],
    Description -> "For each member of SampleLink, the container used to collect the source media from Media Removal prior to washing.",
    IndexMatching -> SampleLink,
    Category -> "Media Aspiration",
    Migration -> SplitField
  },
  AliquotMediaContainerWell -> {
    Format -> Multiple,
    Class -> String,
    Pattern :> _String,
    Relation -> Null,
    Description -> "For each member of SampleLink, the well of the container used to collect the source media from Media Removal prior to washing.",
    IndexMatching -> SampleLink,
    Category -> "Media Aspiration"
  },
  AliquotMediaLabel->{
    Format->Multiple,
    Class->String,
    Pattern:>_String,
    Description->"For each member of SampleLink, a user defined word or phrase used to identify the saved cells sample that is being isolated from media, for use in downstream unit operations.",
    Category->"Media Aspiration",
    IndexMatching->SampleLink
  },
  AliquotMediaContainerLabel->{
    Format->Multiple,
    Class->String,
    Pattern:>_String,
    Description->"For each member of SampleLink, a user defined word or phrase used to identify the SourceMediaContainer that contains the source media separated from cell samples, for use in future analysis.",
    Category->"Media Aspiration",
    IndexMatching->SampleLink
  },
  AliquotMediaStorageCondition -> {
    Format -> Multiple,
    Class -> Expression,
    Pattern :> SampleStorageTypeP | Disposal,
    Description -> "For each member of SampleLink, indicates the conditions under which separated source media are saved after cell isolation.",
    IndexMatching -> SampleLink,
    Category -> "Media Aspiration"
  },

  NumberOfWashes -> {
    Format -> Multiple,
    Class -> Integer,
    Pattern :> GreaterEqualP[0, 1],
    Description -> "For each member of SampleLink, the number of times the sample is washed with WashSolution, prior to replenishment with fresh media, in order to wash trace amounts of media and metabolites from the cells.",
    IndexMatching -> SampleLink,
    Category -> "Washing"
  },
  WashSolution -> {
    Format -> Multiple,
    Class -> Link,
    Pattern :> _Link,
    Relation -> Alternatives[
      Model[Sample]
    ],
    Description -> "For each member of SampleLink, the buffer used to wash the cell sample after removing media.",
    IndexMatching -> SampleLink,
    Category -> "Washing"
  },
  WashSolutionTemperatureReal -> {
    Format -> Multiple,
    Class -> Real,
    Pattern :> GreaterEqualP[0 Celsius],
    Units -> Celsius,
    Description -> "For each member of SampleLink, the temperature of the wash solution in cell wash experiment.",
    IndexMatching -> SampleLink,
    Category -> "Washing",
    Migration -> SplitField
  },
  WashSolutionTemperatureExpression -> {
    Format -> Multiple,
    Class -> Expression,
    Pattern :> Alternatives[Ambient],
    Description -> "For each member of SampleLink, the temperature of the wash solution in cell wash experiment.",
    IndexMatching -> SampleLink,
    Category -> "Washing",
    Migration -> SplitField
  },
  WashSolutionEquilibrationTime -> {
    Format -> Multiple,
    Class -> Real,
    Pattern :> GreaterEqualP[0 Second],
    Units -> Minute,
    Description -> "For each member of SampleLink, the WashSolution will be incubated for a minimum duration of this time at WashSolutionEquilibrationTemperature prior to washing the live cell sample.",
    IndexMatching -> SampleLink,
    Category -> "Washing"
  },
  WashVolume -> {
    Format -> Multiple,
    Class -> Real,
    Pattern :> GreaterEqualP[0 Microliter],
    Units -> Microliter,
    Description -> "For each member of SampleLink, the amount of WashSolution used for washing the cells.",
    IndexMatching -> SampleLink,
    Category -> "Washing"
  },
  WashMixType -> {
    Format -> Multiple,
    Class -> Expression,
    Pattern :> RoboticMixTypeP | None,
    Description -> "For each member of SampleLink, indicates the style of motion (Shake or Pipette) used to mix the cell sample with WashSolution.",
    IndexMatching -> SampleLink,
    Category -> "Washing"
  },
  WashMixInstrument -> {
    Format -> Multiple,
    Class -> Link,
    Pattern :> _Link,
    Relation -> Alternatives[
      Object[Instrument],
      Model[Instrument]
    ],
    Description -> "For each member of SampleLink, the instrument used to mix the cell sample with WashSolution via Shake.",
    IndexMatching -> SampleLink,
    Category -> "Washing"
  },
  WashMixTime -> {
    Format -> Multiple,
    Class -> Real,
    Pattern :> GreaterEqualP[0 Second],
    Units -> Minute,
    Description -> "For each member of SampleLink, the duration of time to mix the cell sample with WashSolution via Shake.",
    IndexMatching -> SampleLink,
    Category -> "Washing"
  },
  WashMixRate -> {
    Format -> Multiple,
    Class -> Real,
    Pattern :> GreaterP[0 RPM],
    Units -> RPM,
    Description -> "For each member of SampleLink, the rate at which the sample is mixed with WashSolution via the selected WashMixType for the duration specified by WashMixTime.",
    IndexMatching -> SampleLink,
    Category -> "Washing"
  },
  WashMixVolume -> {
    Format -> Multiple,
    Class -> Real,
    Pattern :> GreaterEqualP[0 Microliter],
    Units -> Milliliter,
    Description -> "For each member of SampleLink, the volume of the cell sample in WashSolution that is pipetted up and down to mix the live cell samples with WashSolution.",
    IndexMatching -> SampleLink,
    Category -> "Washing"
  },
  NumberOfWashMixes -> {
    Format -> Multiple,
    Class -> Integer,
    Pattern :> GreaterP[0, 1],
    Description -> "For each member of SampleLink, the number of pipetting cycles (drawing liquid up into the pipette and dispensing back down out of the pipette) used to mix the live cell samples with WashSolution.",
    IndexMatching -> SampleLink,
    Category -> "Washing"
  },
  WashTemperatureReal -> {
    Format -> Multiple,
    Class -> Real,
    Pattern :> GreaterP[0 Celsius],
    Units -> Celsius,
    Description -> "For each member of SampleLink, the temperature of the device that is used to mix the live cells in WashSolution.",
    IndexMatching -> SampleLink,
    Migration -> SplitField,
    Category -> "Washing"
  },
  WashTemperatureExpression -> {
    Format -> Multiple,
    Class -> Expression,
    Pattern :> Alternatives[Ambient],
    Description -> "For each member of SampleLink, the temperature of the device that is used to mix the live cells in WashSolution.",
    IndexMatching -> SampleLink,
    Migration -> SplitField,
    Category -> "Washing"
  },
  WashAspirationVolumeReal -> {
    Format -> Multiple,
    Class -> Real,
    Pattern :> GreaterEqualP[0 Microliter],
    Units -> Microliter,
    Description -> "For each member of SampleLink, indicates how much wash solution to remove from an input sample of cells prior to media replenishment when isolating with Aspriate or Pellet.",
    IndexMatching -> SampleLink,
    Category -> "Washing",
    Migration -> SplitField
  },
  WashAspirationVolumeExpression -> {
    Format -> Multiple,
    Class -> Expression,
    Pattern :> Alternatives[All],
    Description -> "For each member of SampleLink, indicates how much wash solution to remove from an input sample of cells prior to media replenishment when isolating with Aspriate or Pellet.",
    IndexMatching -> SampleLink,
    Category -> "Washing",
    Migration -> SplitField
  },
  WashIsolationTime -> {
    Format -> Multiple,
    Class -> Real,
    Pattern :> GreaterEqualP[0 Second],
    Units -> Minute,
    Description -> "For each member of SampleLink, the amount of time to pellet the cell samples prior to changing media. Centrifuging is intended to separate cells from media.",
    IndexMatching -> SampleLink,
    Category -> "Washing"
  },
  WashPelletIntensity -> {
    Format -> Multiple,
    Class -> VariableUnit,
    Pattern :> GreaterP[0 * RPM] | GreaterP[0 * GravitationalAcceleration],
    Units -> None,
    Description -> "For each member of SampleLink, the rotational speed or force applied to the cell sample by centrifugation prior to changing media. Centrifuging is intended to separate cells from media, forming a cell pellet.",
    IndexMatching -> SampleLink,
    Category -> "Washing"
  },
  WashAspirationAngle -> {
    Format -> Multiple,
    Class -> Real,
    Pattern :> RangeP[0 AngularDegree, 10 AngularDegree, 1 AngularDegree],
    Units -> AngularDegree,
    Description -> "For each member of SampleLink, indicates the tilting angle of the adherent cell culture plate to aspirate off the wash buffer. The tilt causes the liquid to pool on one edge of the container, thereby making it easier to aspirate off the liquid.",
    IndexMatching -> SampleLink,
    Category -> "Washing"
  },

  ResuspensionMediaLink -> {
    Format -> Multiple,
    Class -> Link,
    Pattern :> _Link,
    Relation -> Alternatives[Object[Sample], Model[Sample]],
    Description -> "For each member of SampleLink, the media used to resuspend the cell pellet after washing with WashSolution.",
    IndexMatching -> SampleLink,
    Migration -> SplitField,
    Category -> "Media Replenishment"
  },
  ResuspensionMediaExpression -> {
    Format -> Multiple,
    Class -> Expression,
    Pattern :> Alternatives[None],
    Description -> "For each member of SampleLink, the media used to resuspend the cell pellet after washing with WashSolution.",
    IndexMatching -> SampleLink,
    Migration -> SplitField,
    Category -> "Media Replenishment"
  },
  ResuspensionMediaTemperatureReal -> {
    Format -> Multiple,
    Class -> Real,
    Pattern :> GreaterEqualP[0 Celsius],
    Units -> Celsius,
    Description -> "For each member of SampleLink, the temperature of the media used to resuspend the cell sample.",
    IndexMatching -> SampleLink,
    Category -> "Media Replenishment",
    Migration -> SplitField
  },
  ResuspensionMediaTemperatureExpression -> {
    Format -> Multiple,
    Class -> Expression,
    Pattern :> Alternatives[Ambient],
    Description -> "For each member of SampleLink, the temperature of the media used to resuspend the cell sample.",
    IndexMatching -> SampleLink,
    Category -> "Media Replenishment",
    Migration -> SplitField
  },
  ResuspensionMediaEquilibrationTime -> {
    Format -> Multiple,
    Class -> Real,
    Pattern :> GreaterEqualP[0 Second],
    Units -> Minute,
    Description -> "For each member of SampleLink, indicates the ResuspensionMedia is incubated at ResuspensionMediaTemperature for at least this amount of time prior to resuspending the cell sample.",
    IndexMatching -> SampleLink,
    Category -> "Media Replenishment"
  },
  ResuspensionMediaVolume -> {
    Format -> Multiple,
    Class -> Real,
    Pattern :> GreaterEqualP[0 Microliter],
    Units -> Microliter,
    Description -> "For each member of SampleLink, the amount of ResuspensionMedia added to the cell sample for media replenishment.",
    IndexMatching -> SampleLink,
    Category -> "Media Replenishment"
  },
  ResuspensionMixType -> {
    Format -> Multiple,
    Class -> Expression,
    Pattern :> RoboticMixTypeP | None,
    Description -> "For each member of SampleLink, indicates the style of motion (Shake or Pipette) used to resuspend the cell sample with ResuspensionMedia. If ResuspensionMixType is set to None, the cells will not be mixed with the ResuspensionMedia.",
    IndexMatching -> SampleLink,
    Category -> "Media Replenishment"
  },
  ResuspensionTemperatureReal -> {
    Format -> Multiple,
    Class -> Real,
    Pattern :> GreaterP[0 Celsius],
    Units -> Celsius,
    Description -> "For each member of SampleLink, the temperature of the device that is used to resuspend the cells in ResuspensionMedia.",
    IndexMatching -> SampleLink,
    Category -> "Media Replenishment",
    Migration -> SplitField
  },
  ResuspensionTemperatureExpression -> {
    Format -> Multiple,
    Class -> Expression,
    Pattern :> Alternatives[Ambient],
    Description -> "For each member of SampleLink, the temperature of the device that is used to resuspend the cells in ResuspensionMedia.",
    IndexMatching -> SampleLink,
    Category -> "Media Replenishment",
    Migration -> SplitField
  },
  ResuspensionMixInstrument -> {
    Format -> Multiple,
    Class -> Link,
    Pattern :> _Link,
    Relation -> Alternatives[
      Object[Instrument],
      Model[Instrument]
    ],
    Description -> "For each member of SampleLink, the instrument used to resuspend the cell sample with ResuspensionMedia.",
    IndexMatching -> SampleLink,
    Category -> "Media Replenishment"
  },
  ResuspensionMixTime -> {
    Format -> Multiple,
    Class -> Real,
    Pattern :> GreaterEqualP[0 Second],
    Units -> Minute,
    IndexMatching -> SampleLink,
    Description -> "For each member of SampleLink, the duration of time to mix the cell sample with ResuspensionMedia.",
    Category -> "Media Replenishment"
  },
  ResuspensionMixRate -> {
    Format -> Multiple,
    Class -> Real,
    Pattern :> GreaterP[0 RPM],
    Units -> RPM,
    Description -> "For each member of SampleLink, the shaking rate to mix cell sample with the ResuspensionMedia over the ResuspensionMediaMixTime.",
    IndexMatching -> SampleLink,
    Category -> "Media Replenishment"
  },
  ResuspensionMixVolume -> {
    Format -> Multiple,
    Class -> Real,
    Pattern :> GreaterEqualP[0 Microliter],
    Units -> Microliter,
    Description -> "For each member of SampleLink, the volume of the sample that is pipetted up and down to resuspend the cell sample in ResuspensionMedia.",
    IndexMatching -> SampleLink,
    Category -> "Media Replenishment"
  },
  NumberOfResuspensionMixes -> {
    Format -> Multiple,
    Class -> Integer,
    Pattern :> GreaterP[0, 1],
    Description -> "For each member of SampleLink, the number of pipetting cycles (drawing liquid up into the pipette and dispensing back down out of the pipette) used to resuspend the cell sample in ResuspensionMedia.",
    IndexMatching -> SampleLink,
    Category -> "Media Replenishment"
  },
  ReplateCells -> {
    Format -> Multiple,
    Class -> Boolean,
    Pattern :> BooleanP,
    Description -> "For each member of SampleLink, indicates whether the sample is transferred into new container.",
    IndexMatching -> SampleLink,
    Category -> "Media Replenishment"
  },
  ContainerOutString -> {
    Format -> Multiple,
    Class -> String,
    Pattern :> _String,
    Description -> "For each member of SampleLink, the container into which the resuspended cell sample is transferred into after cell washing and media replenishment.",
    IndexMatching -> SampleLink,
    Category -> "Media Replenishment",
    Migration -> SplitField
  },

  (*ToDO:
  Pattern :> Alternatives[
				{_Integer, ObjectP[Model[Container]]},
				{_String, ObjectP[{Object[Container], Model[Container]}]},
				{_String, {_Integer, ObjectP[{Object[Container], Model[Container]}]}},
				Null
			]*)
  ContainerOutExpression -> {
    Format -> Multiple,
    Class -> Expression,
    Pattern :> {WellP, {_Integer, ObjectP[Model[Container]]}} | {_Integer, ObjectP[Model[Container]]} | {ObjectP[Model[Container]]},
    Description -> "For each member of SampleLink, the container into which the resuspended cell sample is transferred into after cell washing and media replenishment.",
    IndexMatching -> SampleLink,
    Category -> "Media Replenishment",
    Migration -> SplitField
  },
  ContainerOutLink -> {
    Format -> Multiple,
    Class -> Link,
    Pattern :> _Link,
    Relation -> Alternatives[Object[Container], Model[Container]],
    Description -> "For each member of SampleLink, the container into which the resuspended cell sample is transferred into after cell washing and media replenishment.",
    IndexMatching -> SampleLink,
    Category -> "Media Replenishment",
    Migration -> SplitField
  },
  ContainerOutWell -> {
    Format -> Multiple,
    Class -> String,
    Pattern :> _String,
    Relation -> Null,
    Description -> "For each member of SampleLink, the well of the container into which the resuspended cell sample is transferred into after cell washing and media replenishment.",
    IndexMatching -> SampleLink,
    Category -> "Media Replenishment"
  },
  ContainerOutLabel->{
    Format->Multiple,
    Class->String,
    Pattern:>_String,
    Description -> "For each member of SampleLink, a user defined word or phrase used to identify the ContainerOut that contains the replated cell samples.",
    Category->"Media Replenishment",
    IndexMatching->SampleLink
  },
  SampleOutLabel -> {
    Format -> Multiple,
    Class -> String,
    Pattern :> _String,
    Relation -> Null,
    Description -> "For each member of SampleLink, a user defined word or phrase used to identify the cell samples resulting from the washing cells or changing media, for use in downstream unit operations.",
    IndexMatching -> SampleLink,
    Category -> "Media Replenishment"
  }
};

(* NOTE: WashCells is the same as ChangeMedia. *)
With[{insertMe=$SharedChangeMediaUnitOperationFields},
  DefineObjectType[Object[UnitOperation, ChangeMedia],{
    Description->"The group of default settings that should be used when changing media for a given cell culture.",
    CreatePrivileges->None,
    Cache->Session,
    Fields->insertMe
  }]
];