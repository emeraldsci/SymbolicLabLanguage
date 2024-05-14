(* ::Package:: *)

(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(* PackContainers *)

DefineUsage[PackContainers,
  {
    BasicDefinitions -> {
      {"PackContainers[unresolvedContainers, packPlateQ, requiredContainerVolumes, parametersToGroupBy]","{resolvedContainers, resolvedPositions}","converts the 'unresolvedContainers' into two index-matched lists; the first is a list of resolved containers (without container wells/positions), and the second is a list of resolved container wells/positions. The experiment at a given index is packed into well plates if True is the value at the index in 'packPlateQ', and container models are resolved based upon the 'requiredContainerVolumes' and any specified options. Experiments with compatible conditions are grouped into plates according to the 'parametersToGroupBy' and packed column-wise into the plate positions as needed."}
    },
    Input :> {
      {"unresolvedContainers",(ListableP[Alternatives[Null, Automatic, ObjectP[{Object[Container], Model[Container]}], {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], ObjectP[Model[Container]]}, {GreaterEqualP[1, 1], ObjectP[Model[Container]]}, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], {GreaterEqualP[1, 1], ObjectP[Model[Container]]}}]]),"A list (or a single entry) of unresolved containers including specified containers, Automatic, and Null."},
      {"packPlateQ",ListableP[BooleanP],"A Boolean or list of Booleans which indicate if the experiment at a given index is to be packed into a plate."},
      {"requiredContainerVolumes",ListableP[Null|VolumeP],"A volume or list of volumes which will be aliquoted in the experiment."},
      {"parametersToGroupBy",ListableP[_List],"A list (or list of lists) of experiment parameters which serve as the criteria for grouping samples into plates."}
    },
    Output :> {
      {"resolvedContainers",ListableP[Alternatives[Null, ObjectP[{Object[Container], Model[Container]}], {GreaterEqualP[1, 1], ObjectP[Model[Container]]}]],"A container model or specific object (or list of container models and/or specific objects), which may also include container indices, resulting from the packing of experiment samples into plates as specified in the input. The containers in this list are index-matched to the 'resolvedPositions'."},
      {"resolvedPositions",ListableP[Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]]],"A well position (or list of well positions) resulting from the packing of experiment samples into containers as specified in the input. The wells/positions in this list are index-matched to the 'resolvedContainers'."}
    },
    SeeAlso -> {
      "AliquotIntoPlateQ",
      "PreferredContainer",
      "ExperimentAliquot"
    },
    Author -> {"tyler.pabst", "daniel.shlian"}
  }
];


(* ::Subsection:: *)
(* AliquotIntoPlateQ *)

DefineUsage[AliquotIntoPlateQ,
  {
    BasicDefinitions -> {
      {"AliquotIntoPlateQ[unresolvedAliquotContainers, aliquotBooleans, centrifugeBooleans, mixTypes, temperatures]","booleans","generates a list of 'booleans' (or a single Boolean) which indicate if the experiment at a given index is to be aliquoted into a plate according to the input parameters."}
    },
    Input :> {
      {
        "unresolvedAliquotContainers",(ListableP[Alternatives[Null, Automatic, ObjectP[{Object[Container], Model[Container]}], {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], ObjectP[Model[Container]]}, {GreaterEqualP[1, 1], ObjectP[Model[Container]]}, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], {GreaterEqualP[1, 1], ObjectP[Model[Container]]}}]]),"A list (or a single entry) of unresolved containers including specified containers, Automatic, and Null."
      },
      {
        "aliquotBooleans",ListableP[BooleanP],"A list of Booleans which indicate if the sample at a given index is to be aliquoted."
      },
      {
        "centrifugeBooleans",ListableP[ListableP[Null|BooleanP]],"A list (or list of lists) of Booleans which indicate if the sample at a given index is to be centrifuged."
      },
      {
        "mixTypes",ListableP[ListableP[Null|None|MixTypeP]],"A list (or list of lists) of mix types required for the experiment at a given index."
      },
      {
        "temperatures",ListableP[ListableP[Null|Ambient|TemperatureP]],"A list (or list of lists) of temperatures required for the experiment at a given index."
      }
    },
    Output :> {
      {"booleans",ListableP[BooleanP],"A Boolean or list of Booleans which indicate if the experiment at a given index is to be aliquoted into a plate according to the input parameters."}
    },
    SeeAlso -> {
      "PackContainers",
      "PreferredContainer",
      "ExperimentAliquot"
    },
    Author -> {"tyler.pabst", "daniel.shlian"}
  }
];