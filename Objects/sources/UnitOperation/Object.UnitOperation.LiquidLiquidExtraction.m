(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[UnitOperation, LiquidLiquidExtraction],
  {
    Description->"A detailed set of parameters that labels a sample for later use in a SamplePreparation/CellPreparation experiment.",
    CreatePrivileges->None,
    Cache->Session,
    Fields->{
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
        Description -> "The sample that contains the target analyte to be isolated via liquid liquid extraction.",
        Category -> "General",
        Migration -> SplitField
      },
      SampleString -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Relation -> Null,
        Description -> "The sample that contains the target analyte to be isolated via liquid liquid extraction.",
        Category -> "General",
        Migration -> SplitField
      },
      SampleExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
        Relation -> Null,
        Description -> "The sample that contains the target analyte to be isolated via liquid liquid extraction.",
        Category -> "General",
        Migration->SplitField
      },
      ExtractionTechnique -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ExtractionTechniqueP,
        Description -> "For each member of SampleLink, the method that is used to separate the aqueous and organic phase of a sample. The collection of the target phase occurs after the extraction solvent(s) and demulsifier (if specified) are added, the sample is mixed (optionally), allowed to settle for SettlingTime (for the organic and aqueous phases to separate), and centrifuged (optionally). Pipette uses a pipette to aspirate off either the aqueous or organic layer, optionally taking the boundary layer with it according to the ExtractionObjective and ExtractionBoundaryVolume options. PhaseSeparator uses a column with a hydrophobic frit, which allows the organic phase to pass freely through the frit, but physically blocks the aqueous phase from passing through. Note that when using a phase separator, the organic phase must be heavier than the aqueous phase in order for it to pass through the hydrophobic frit, otherwise, the separator will not occur.",
        IndexMatching -> SampleLink,
        Category -> "General"
      },
      ExtractionDeviceString -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Relation -> Null,
        Description -> "For each member of SampleLink, the device which is used to physically separate the aqueous and organic phases.",
        IndexMatching -> SampleLink,
        Category -> "General",
        Migration->SplitField
      },
      ExtractionDeviceLink -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[
          Model[Container, Plate, PhaseSeparator],
          Object[Container, Plate, PhaseSeparator]
        ],
        Description -> "For each member of SampleLink, the device which is used to physically separate the aqueous and organic phases.",
        IndexMatching -> SampleLink,
        Category -> "General",
        Migration->SplitField
      },
      SelectionStrategy -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> SelectionStrategyP,
        Description -> "For each member of SampleLink, indicates if additional rounds of extraction are performed on the impurity phase (Positive) or the TargetPhase (Negative). Positive selection is used when the goal is to extract the maximum amount of TargetAnalyte from the impurity phase (maximizing yield). Negative selection is used when the goal is to remove impurities that may still exist in the TargetPhase (maximizing purity).",
        IndexMatching -> SampleLink,
        Category -> "General"
      },
      IncludeBoundary -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> BooleanP | {BooleanP..},
        Description -> "For each member of SampleLink, indicates if the boundary layer is aspirated along with the TargetPhase (therefore potentially collecting a small amount of the unwanted phase) or if the boundary layer is not aspirated along with the TargetPhase (and therefore reducing the likelihood of collecting any of the unwanted phase). This option is only applicable when ExtractionTechnique is set to Pipette.",
        IndexMatching -> SampleLink,
        Category -> "General"
      },
      TargetAnalyte -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives@@IdentityModelTypes,
        Description -> "For each member of SampleLink, the desired molecular entity that the extraction is designed to isolate.",
        IndexMatching -> SampleLink,
        Category -> "General"
      },
      SamplePhase -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> SamplePhaseP,
        Description -> "For each member of SampleLink, indicates the phase of the input sample before extraction has taken place. Aqueous means that the input sample is liquid and composed only of aqueous solvents. Organic means that the input sample is liquid and composed only of organic solvents. Biphasic means that the input sample is liquid and composed of both aqueous and organic solvents that are separated into two defined layers. Unknown means that the sample phase is unknown, which will result in both Aqueous and Organic solvents being added to the input sample.",
        IndexMatching -> SampleLink,
        Category -> "General"
      },
      TargetPhase -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> TargetPhaseP,
        Description -> "For each member of SampleLink, automatically set to the phase (Organic or Aqueous) that the TargetAnalyte is more likely to be present in after extraction according to the PredictDestinationPhase function. If there is not enough information for PredictDestinationPhase to predict the destination phase of the target molecule, a warning will be thrown and TargetPhase will default to Aqueous. For more information, please refer to the PredictDestinationPhase help file.",
        IndexMatching -> SampleLink,
        Category -> "General"
      },
      TargetLayer -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> TargetLayerP | {TargetLayerP..},
        Description -> "For each member of SampleLink, indicates if the target phase is the top layer or the bottom layer of the separated solution. Note that when performing multiple rounds of extraction (NumberOfExtractions), the composition of the Aqueous and Organic layers during the first round of extraction can differ from the rest of the extraction rounds. For example, if SamplePhase->Biphasic and TargetPhase->Organic, the original organic layer from the input sample will be extracted and in subsequent rounds of extraction, OrganicSolvent added to the Aqueous impurity layer to extract more TargetAnalyte (the specified OrganicSolvent option can differ from the density of the original sample's organic layer). This can result in TargetLayer being different during the first round of extraction compared to the rest of the extraction rounds.",
        IndexMatching -> SampleLink,
        Category -> "General"
      },
      SampleVolumeReal -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 * Milliliter],
        Units -> Milliliter,
        Description -> "For each member of SampleLink, the volume of the input sample that is aliquotted into the ExtractionContainer and the liquid liquid extraction is performed on.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink,
        Migration -> SplitField
      },
      SampleVolumeExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> Alternatives[All],
        Description -> "For each member of SampleLink, the volume of the input sample that is aliquotted into the ExtractionContainer and the liquid liquid extraction is performed on.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink,
        Migration -> SplitField
      },
      ExtractionContainerString -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Relation -> Null,
        Description -> "For each member of SampleLink, the container that the input sample that is aliquotted into, before the liquid liquid extraction is performed.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink,
        Migration->SplitField
      },
      ExtractionContainerLink -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[
          Object[Container],
          Model[Container]
        ],
        Description -> "For each member of SampleLink, the container that the input sample that is aliquotted into, before the liquid liquid extraction is performed.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink,
        Migration->SplitField
      },
      ExtractionContainerExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {_Integer, ObjectP[Model[Container]]},
        Description -> "For each member of SampleLink, the container that the input sample that is aliquotted into, before the liquid liquid extraction is performed.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink,
        Migration->SplitField
      },
      ExtractionContainerWell -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Relation -> Null,
        Description -> "For each member of SampleLink, the well of the container that the input sample that is aliquotted into, before the liquid liquid extraction is performed.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink
      },
      AqueousSolventString -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Relation -> Null,
        Description -> "For each member of SampleLink, the aqueous solvent that is added to the input sample (or the impurity layer from the previous extraction round if NumberOfExtractions > 1) in order to create an organic and aqueous phase.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink,
        Migration->SplitField
      },
      AqueousSolventLink -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Model[Sample], Object[Sample]],
        Description -> "For each member of SampleLink, the aqueous solvent that is added to the input sample (or the impurity layer from the previous extraction round if NumberOfExtractions > 1) in order to create an organic and aqueous phase.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink,
        Migration->SplitField
      },
      AqueousSolventExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> None,
        Description -> "For each member of SampleLink, the aqueous solvent that is added to the input sample (or the impurity layer from the previous extraction round if NumberOfExtractions > 1) in order to create an organic and aqueous phase.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink,
        Migration->SplitField
      },
      AqueousSolventVolume -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 * Milliliter],
        Units -> Milliliter,
        Description -> "For each member of SampleLink, the volume of aqueous solvent that is added and mixed with the sample during each extraction.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink
      },
      AqueousSolventRatio -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0],
        Description -> "For each member of SampleLink, the ratio of the sample volume to the volume of aqueous solvent that is added to the sample.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink
      },
      OrganicSolventString -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Relation -> Null,
        Description -> "For each member of SampleLink, the organic solvent that is added to the input sample (or the impurity layer from the previous extraction round if NumberOfExtractions > 1) in order to create an organic and aqueous phase.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink,
        Migration->SplitField
      },
      OrganicSolventLink -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Model[Sample], Object[Sample]],
        Description -> "For each member of SampleLink, the organic solvent that is added to the input sample (or the impurity layer from the previous extraction round if NumberOfExtractions > 1) in order to create an organic and aqueous phase.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink,
        Migration->SplitField
      },
      OrganicSolventExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> None,
        Description -> "For each member of SampleLink, the organic solvent that is added to the input sample (or the impurity layer from the previous extraction round if NumberOfExtractions > 1) in order to create an organic and aqueous phase.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink,
        Migration->SplitField
      },
      OrganicSolventVolume -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 * Milliliter],
        Units -> Milliliter,
        Description -> "For each member of SampleLink, the volume of organic solvent that is added and mixed with the sample during each extraction.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink
      },
      OrganicSolventRatio -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0],
        Description -> "For each member of SampleLink, the ratio of the sample volume to the volume of orgnanic solvent that is added to the sample.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink
      },
      SolventAdditions -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {Alternatives[ObjectP[{Model[Sample], Object[Sample]}], _String, {Alternatives[ObjectP[{Model[Sample], Object[Sample]}], _String]..}, None]..},
        Description -> "For each member of SampleLink, for each extraction round, the solvent(s) that are added to the sample in order to create a biphasic solution.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink
      },
      DemulsifierAdditions -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {Alternatives[ObjectP[{Model[Sample], Object[Sample]}], _String, None]..},
        Description -> "For each member of SampleLink, for each extraction round, the Demulsifier that is added to the sample mixture to help promote complete phase separation and avoid emulsions.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink
      },
      DemulsifierString -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Relation -> Null,
        Description -> "For each member of SampleLink, the solution that is added to the sample mixture in order to help promote complete phase separation and avoid emulsions.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink,
        Migration->SplitField
      },
      DemulsifierLink -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Model[Sample], Object[Sample]],
        Description -> "For each member of SampleLink, the solution that is added to the sample mixture in order to help promote complete phase separation and avoid emulsions.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink,
        Migration->SplitField
      },
      DemulsifierExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> None,
        Description -> "For each member of SampleLink, the solution that is added to the sample mixture in order to help promote complete phase separation and avoid emulsions.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink,
        Migration->SplitField
      },
      DemulsifierAmountReal -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 * Milliliter],
        Units -> Milliliter,
        Description -> "For each member of SampleLink, the solution that is added to the sample mixture in order to help promote complete phase separation and avoid emulsions.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink,
        Migration -> SplitField
      },
      DemulsifierAmountExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> None,
        Description -> "For each member of SampleLink, the solution that is added to the sample mixture in order to help promote complete phase separation and avoid emulsions.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink,
        Migration -> SplitField
      },
      TemperatureReal -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0*Kelvin],
        Units -> Celsius,
        Description -> "For each member of SampleLink, the set temperature of the incubation device that holds the extraction container during solvent/demulsifier addition, mixing, and settling.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink,
        Migration->SplitField
      },
      TemperatureExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> Ambient,
        Description -> "For each member of SampleLink, the set temperature of the incubation device that holds the extraction container during solvent/demulsifier addition, mixing, and settling.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink,
        Migration->SplitField
      },
      NumberOfExtractions -> {
        Format -> Multiple,
        Class -> Integer,
        Pattern :> GreaterP[0],
        Description -> "For each member of SampleLink, the number of times that the extraction is performed using the specified extraction parameters using the previous extraction round's impurity layer (after the TargetPhase has been extracted) as the input to subsequent rounds of extraction.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink
      },
      ExtractionMixType -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> RoboticMixTypeP,
        Description -> "For each member of SampleLink, the style of motion used to mix the sample mixture following the addition of the AqueousSolvent/OrganicSolvent and Demulsifier (if specified).",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink
      },
      ExtractionMixTime -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 Second],
        Units -> Minute,
        Description -> "For each member of SampleLink, the duration for which the sample, AqueousSolvent/OrganicSolvent, and Demulsifier (if specified) are mixed.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink
      },
      ExtractionMixRate -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 RPM],
        Units -> RPM,
        Description -> "For each member of SampleLink, the frequency of rotation the mixing instrument uses to mechanically incorporate the sample, AqueousSolvent/OrganicSolvent, and demulsifier (if specified).",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink
      },
      NumberOfExtractionMixes -> {
        Format -> Multiple,
        Class -> Integer,
        Pattern :> GreaterP[0],
        Description -> "For each member of SampleLink, the number of times the sample, AqueousSolvent/OrganicSolvent, and demulsifier (if specified) are mixed when ExtractionMixType is set to Pipette.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink
      },
      ExtractionMixVolume -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 * Milliliter],
        Units -> Milliliter,
        Description -> "For each member of SampleLink, the volume of sample, AqueousSolvent/OrganicSolvent, and demulsifier (if specified) that is mixed when ExtractionMixType is set to Pipette.",
        Category -> "Phase Mixing",
        IndexMatching -> SampleLink
      },

      SettlingTime -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 Second],
        Units -> Minute,
        Description -> "For each member of SampleLink, the duration for which the sample is allowed to settle and the organic/aqueous phases separate. This is performed after the AqueousSolvent/OrganicSolvent and Demulsifier (if specified) are added and optionally mixed. If ExtractionTechnique is set to PhaseSeparator, the settling time starts once the sample is loaded into the phase separator (the amount of time that we wait for the organic layer to drain through the phase separator's hydrophobic frit).",
        Category->"Settling",
        IndexMatching -> SampleLink
      },


      ExtractionBoundaryVolume -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> GreaterP[0 * Milliliter] | {GreaterP[0 * Milliliter]..},
        Description -> "For each member of SampleLink, the volume of the target phase that is either overaspirated via Pipette to MaximizeYield (by aspirating the boundary layer along with the TargetPhase and therefore potentially collecting a small amount of the unwanted phase or underaspirated via Pipette to MaximizePurity (by not collecting all of the target phase and therefore reducing the likelihood of collecting any of the unwanted phase). This option only applies if ExtractionTechnique -> Pipette.",
        Category->"Collection",
        IndexMatching -> SampleLink
      },
      ExtractionTransferLayer -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {(Top|Bottom)..},
        Description -> "For each member of SampleLink, indicates whether the top or bottom layer is transferred from the source sample after the organic and aqueous phases are separated. If the TargetLayer matches ExtractionTransferLayer, the sample that is transferred out is the target phase. Otherwise, if TargetLayer doesn't match ExtractionTransferLayer, the sample that remains in the container after the transfer is the target phase.",
        Category->"Collection",
        IndexMatching -> SampleLink
      },
      TargetContainerOutString -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Relation -> Null,
        Description -> "For each member of SampleLink, the container that the separated target layer is transferred into (either via Pipette or PhaseSeparator) after the organic and aqueous phases are separated.",
        IndexMatching -> SampleLink,
        Category -> "Collection",
        Migration->SplitField
      },
      TargetContainerOutLink -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[
          Object[Container],
          Model[Container]
        ],
        Description -> "For each member of SampleLink, the container that the separated target layer is transferred into (either via Pipette or PhaseSeparator) after the organic and aqueous phases are separated.",
        IndexMatching -> SampleLink,
        Category -> "Collection",
        Migration->SplitField
      },
      TargetContainerOutExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {_Integer, ObjectP[Model[Container]]},
        Description -> "For each member of SampleLink, the container that the separated target layer is transferred into (either via Pipette or PhaseSeparator) after the organic and aqueous phases are separated.",
        IndexMatching -> SampleLink,
        Category -> "Collection",
        Migration->SplitField
      },
      TargetContainerOutWell -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Relation -> Null,
        Description -> "For each member of SampleLink, the well of the container that the separated target layer is transferred into (either via Pipette or PhaseSeparator) after the organic and aqueous phases are separated.",
        IndexMatching -> SampleLink,
        Category -> "Collection"
      },
      ImpurityContainerOutString -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Relation -> Null,
        Description -> "For each member of SampleLink, the container that the separated impurity layer is transferred into (either via Pipette or PhaseSeparator) after the organic and aqueous phases are separated.",
        IndexMatching -> SampleLink,
        Category -> "Collection",
        Migration->SplitField
      },
      ImpurityContainerOutLink -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[
          Object[Container],
          Model[Container]
        ],
        Description -> "For each member of SampleLink, the container that the separated impurity layer is transferred into (either via Pipette or PhaseSeparator) after the organic and aqueous phases are separated.",
        IndexMatching -> SampleLink,
        Category -> "Collection",
        Migration->SplitField
      },
      ImpurityContainerOutExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {_Integer, ObjectP[Model[Container]]},
        Description -> "For each member of SampleLink, the container that the separated impurity layer is transferred into (either via Pipette or PhaseSeparator) after the organic and aqueous phases are separated.",
        IndexMatching -> SampleLink,
        Category -> "Collection",
        Migration->SplitField
      },
      ImpurityContainerOutWell -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Relation -> Null,
        Description -> "For each member of SampleLink, the well of the container that the separated impurity layer is transferred into (either via Pipette or PhaseSeparator) after the organic and aqueous phases are separated.",
        IndexMatching -> SampleLink,
        Category -> "Collection"
      },

      TargetStorageConditionLink -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[
          Model[StorageCondition]
        ],
        Description -> "For each member of SampleLink, the condition under which the target sample is stored after the protocol is completed. If left unset, the target sample will be stored under the same condition as the source sample that it originates from.",
        Category -> "Collection",
        IndexMatching -> SampleLink,
        Migration->SplitField
      },
      TargetStorageConditionExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> SampleStorageTypeP | Disposal,
        Relation -> Null,
        Description -> "For each member of SampleLink, the condition under which the target sample is stored after the protocol is completed. If left unset, the target sample will be stored under the same condition as the source sample that it originates from.",
        Category -> "Collection",
        IndexMatching -> SampleLink,
        Migration->SplitField
      },

      ImpurityStorageConditionLink -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[
          Model[StorageCondition]
        ],
        Description -> "For each member of SampleLink, the conditions under which the waste layer samples will be stored after the protocol is completed. If left unset, the waste sample will be stored under the same condition as the source sample that it originates from.",
        Category -> "Collection",
        IndexMatching -> SampleLink,
        Migration->SplitField
      },
      ImpurityStorageConditionExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> SampleStorageTypeP | Disposal,
        Relation -> Null,
        Description -> "For each member of SampleLink, the conditions under which the waste layer samples will be stored after the protocol is completed. If left unset, the waste sample will be stored under the same condition as the source sample that it originates from.",
        Category -> "Collection",
        IndexMatching -> SampleLink,
        Migration->SplitField
      },

      SampleLabel -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Relation -> Null,
        Description -> "For each member of SampleLink, a user defined word or phrase used to identify the input sample, for use in downstream unit operations.",
        IndexMatching -> SampleLink,
        Category->"General"
      },
      SampleContainerLabel -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Relation -> Null,
        Description -> "For each member of SampleLink, a user defined word or phrase used to identify the input sample's container, for use in downstream unit operations.",
        IndexMatching -> SampleLink,
        Category->"General"
      },
      TargetLabel -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Relation -> Null,
        Description -> "For each member of SampleLink, a user defined word or phrase used to identify the sample that contains the extracted target layer sample, for use in downstream unit operations.",
        IndexMatching -> SampleLink,
        Category->"General"
      },
      TargetContainerLabel -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Relation -> Null,
        Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container that contains the extracted target layer sample, for use in downstream unit operations.",
        IndexMatching -> SampleLink,
        Category->"General"
      },
      ImpurityLabel -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Relation -> Null,
        Description -> "For each member of SampleLink, a user defined word or phrase used to identify the sample that contains the waste layer, for use in downstream unit operations.",
        IndexMatching -> SampleLink,
        Category->"General"
      },
      ImpurityContainerLabel -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Relation -> Null,
        Description -> "For each member of SampleLink, a user defined word or phrase used to identify the sample that contains the waste layer, for use in downstream unit operations.",
        IndexMatching -> SampleLink,
        Category->"General"
      }
    }
  }
];
