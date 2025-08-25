(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExperimentBioLayerInterferometry*)


DefineUsage[ExperimentBioLayerInterferometry,
  {
    BasicDefinitions -> {
      {
        Definition->{"ExperimentBioLayerInterferometry[Samples]","Protocol"},
        Description->"generates a 'Protocol' object for performing Bio-Layer Interferometry (BLI) on the provided 'Samples'.",
        Inputs:>{
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "BLI measures the interaction between a solution phase analyte (the input sample) and a bio-layer functionalized probe surface by recording changes in the bio-layer thickness over time. Analytes may include antibodies, antigens, proteins, DNA, RNA, small molecules, cells, viruses, and bacteria. Sample solutions can be homogenous or heterogeneous mixtures, and may be recovered and reused due to the nondesctructive nature of the measurement.",
              Widget->Alternatives[
                "Sample or Container" -> Widget[
                  Type->Object,
                  Pattern:>ObjectP[{Object[Sample],Object[Container]}],
                  ObjectTypes->{Object[Sample],Object[Container]},
                  Dereference->{
                    Object[Container]->Field[Contents[[All,2]]]
                  }
                ],
                "Model Sample"->Widget[
                  Type -> Object,
                  Pattern :> ObjectP[Model[Sample]],
                  ObjectTypes -> {Model[Sample]}
                ]
              ],
              Expandable->False
            },
            IndexName->"experiment samples"
          ]
        },
        Outputs:>{
          {
            OutputName->"Protocol",
            Description->"A protocol object for performing bio-layer interferometry.",
            Pattern:>ListableP[ObjectP[Object[Protocol,BioLayerInterferometry]]]
          }
        }
      }
    },
    MoreInformation -> {(*this section will need to be updated with any changes in the options .*)
      "BLI performs non-destructive analysis of interactions between immobilized species on a bio-probe surface and solution phase analytes by measuring the change in bio-layer thickness as a function of time.",
      "The available experiment types are:",
      "-Kinetics: Measure association and dissociation kinetics for one or more samples as they interact with a immobilized species on the probe surface.",
      "-Quantitation: Quantify the amount of a target analyte in unknown solutions by generating a standard curve.",
      "-EpitopeBinning: Determine if antibodies have the same binding domain with regards to a target antigen via an 8x8 or 7x7 competition experiment.",
      "-AssayDevelopment: Identify the optimum conditions for regeneration and bio-sensor functionalization steps by screening a series of conditions.",
      "Within each type, there are several options for steps including baselines, probe activation, antibody immobilization, probe regeneration, washing, and neutralization.",
      "Experimental parameters and input determination:",
      "- The sample volume is fixed at 200 uL.",
      "- The maximum number of input samples is as follows: kinetics (11), quantitation (84), epitope binning (8), assay development (8).",
      "- The maximum number of samples may decrease if additional options (such as regeneration) necessitate non-sample solutions to populate well positions.",
      "- Biosensors must be of the type Model[Item, BLISensor]. Custom biosensors from ForteBio can also be specified by the user."
    },
    SeeAlso -> {
      "ValidExperimentBioLayerInterferometryQ",
      "ExperimentBioLayerInterferometryOptions",
      "ExperimentDifferentialScanningCalorimetry",
      "ExperimentTotalProteinQuantification",
      "ExperimentTotalProteinDetection"
    },
    Author -> {"alou", "robert"}
  }
];

(* ::Subsubsection::Closed:: *)
(*ExperimentBioLayerInterferometryOptions*)

DefineUsage[ExperimentBioLayerInterferometryOptions,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentBioLayerInterferometryOptions[Samples]", "ResolvedOptions"},
        Description -> "generates the 'ResolvedOptions' for performing bio-layer interferometry on the 'Samples'.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description-> "The samples to be measured.",
              Widget->Alternatives[
                "Sample or Container" -> Widget[
                  Type->Object,
                  Pattern:>ObjectP[{Object[Sample],Object[Container]}],
                  ObjectTypes->{Object[Sample],Object[Container]},
                  Dereference->{
                    Object[Container]->Field[Contents[[All,2]]]
                  }
                ],
                "Model Sample"->Widget[
                  Type -> Object,
                  Pattern :> ObjectP[Model[Sample]],
                  ObjectTypes -> {Model[Sample]}
                ]
              ],
              Expandable->False
            },
            IndexName -> "experiment samples"
          ]
        },
        Outputs :> {
          {
            OutputName -> "ResolvedOptions",
            Description -> "Resolved options when ExperimentBioLayerInterferometryOptions is called on the input samples.",
            Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
          }
        }
      }
    },
    MoreInformation -> {
      "The options returned by this function may be passed directly to ExperimentBioLayerInterferometry."
    },
    SeeAlso -> {
      "ExperimentBioLayerInterferometry",
      "ValidExperimentBioLayerInterferometryQ"
    },
    Author -> {"alou", "robert"}
  }
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentBioLayerInterferometryQ*)


DefineUsage[ValidExperimentBioLayerInterferometryQ,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ValidExperimentBioLayerInterferometryQ[Samples]", "Booleans"},
        Description -> "checks whether the provided 'Samples' and specified options are valid for calling ExperimentBioLayerInterferometry.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description -> "The samples to be measured.",
              Widget -> Alternatives[
                "Sample or Container" -> Widget[
                  Type->Object,
                  Pattern:>ObjectP[{Object[Sample],Object[Container]}],
                  ObjectTypes->{Object[Sample],Object[Container]},
                  Dereference->{
                    Object[Container]->Field[Contents[[All,2]]]
                  }
                ],
                "Model Sample"->Widget[
                  Type -> Object,
                  Pattern :> ObjectP[Model[Sample]],
                  ObjectTypes -> {Model[Sample]}
                ]
              ],
              Expandable -> False
            },
            IndexName -> "experiment samples"
          ]
        },
        Outputs :> {
          {
            OutputName -> "Booleans",
            Description -> "Whether or not the ExperimentBioLayerInterferometry call is valid.  Return value can be changed via the OutputFormat option.",
            Pattern :> _EmeraldTestSummary | BooleanP
          }
        }
      }
    },
    SeeAlso -> {
      "ExperimentBioLayerInterferometry",
      "ExperimentBioLayerInterferometryOptions"
    },
    Author -> {"alou", "robert"}
  }
];

DefineUsage[ExperimentBioLayerInterferometryPreview,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ExperimentBioLayerInterferometryPreview[Samples]", "Preview"},
        Description -> "returns a preview of the assay defined for 'Samples'.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Samples",
              Description -> "The samples to be measured.",
              Widget -> Alternatives[
                "Sample or Container" -> Widget[
                  Type->Object,
                  Pattern:>ObjectP[{Object[Sample],Object[Container]}],
                  ObjectTypes->{Object[Sample],Object[Container]},
                  Dereference->{
                    Object[Container]->Field[Contents[[All,2]]]
                  }
                ],
                "Model Sample"->Widget[
                  Type -> Object,
                  Pattern :> ObjectP[Model[Sample]],
                  ObjectTypes -> {Model[Sample]}
                ]
              ],
              Expandable -> False
            },
            IndexName -> "experiment samples"
          ]
        },
        Outputs :> {
          {
            OutputName -> "Preview",
            Description -> "A preview of the ExperimentBioLayerInterferometry output.  Return value can be changed via the OutputFormat option.",
            Pattern :> Null
          }
        }
      }
    },
    SeeAlso -> {
      "ExperimentBioLayerInterferometry",
      "ExperimentBioLayerInterferometryOptions"
    },
    Author -> {"alou", "robert"}
  }
];


(* ::Subsubsection::Closed:: *)
(*Equilibrate*)


DefineUsage[Equilibrate,
  {
    BasicDefinitions -> {
      {"Equilibrate[equilibrateParameters]","primitive","generates an BioLayerInterferometry-compatible 'primitive' that describes parameters of the assay step."}
    },
    MoreInformation->{
      "Eqilibration via immersion in the assay buffer ensures that the probe surface is fully hydrated prior to performing other assay steps.",
      "The omission of Equilibrate steps may result in baseline drift or discontinuity, or probe failures during the assay.",
      "Descriptions of primitive keys:",
      Grid[{
        {"Key", "Description"},
        {"Buffers", "The samples in which the BLI probes are immersed during this assay step."},
        {"Time", "The duration of the assay step."},
        {"ShakeRate", "The speed at which the plate is shaken during the assay step."}
      }]
    },
    Input:>{
      {
        "equilibrateParameters",
        {
          Buffers -> Alternatives[
            ObjectP[{Object[Sample], Model[Sample]}],
            {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], Null]..}
          ],
          Time -> RangeP[0 Hour, 20 Hour],
          ShakeRate -> Alternatives[RangeP[100 RPM, 1500 RPM], 0 RPM]
        },
        "The list of key/value pairs describing the samples and parameters used in this assay step."
      }
    },
    Output:>{
      {"primitive",_Equilibrate,"A BioLayerInterferometry primitive containing parameters for the assay step."}
    },
    SeeAlso -> {
      "ExperimentBioLayerInterferometry",
      "MeasureBaseline",
      "Wash",
      "Regenerate",
      "Neutralize",
      "Quantitate",
      "Quench",
      "ActivateSurface",
      "LoadSurface",
      "MeasureAssociation",
      "MeasureDissociation"
    },
    Author->{"alou", "robert"}
  }
];

(* ::Subsubsection::Closed:: *)
(*Wash*)


DefineUsage[Wash,
  {
    BasicDefinitions -> {
      {"Wash[washParameters]","primitive","generates an BioLayerInterferometry-compatible 'primitive' that describes parameters of the assay step."}
    },
    MoreInformation->{
      "Descriptions of primitive keys:",
      Grid[{
        {"Key", "Description"},
        {"Buffers", "The samples in which the BLI probes are immersed during this assay step."},
        {"Time", "The duration of the assay step."},
        {"ShakeRate", "The speed at which the plate is shaken during the assay step."}
      }]
    },
    Input:>{
      {
        "washParameters",
        {
          Buffers -> Alternatives[
            ObjectP[{Object[Sample], Model[Sample]}],
            {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], Null]..}
          ],
          Time -> RangeP[0 Hour, 20 Hour],
          ShakeRate -> Alternatives[RangeP[100 RPM, 1500 RPM], 0 RPM]
        },
        "The list of key/value pairs describing the samples and parameters used in this assay step."
      }
    },
    Output:>{
      {"primitive",_Wash,"A BioLayerInterferometry primitive containing parameters for the assay step."}
    },
    SeeAlso -> {
      "ExperimentBioLayerInterferometry",
      "MeasureBaseline",
      "Equilibrate",
      "Regenerate",
      "Neutralize",
      "Quantitate",
      "Quench",
      "ActivateSurface",
      "LoadSurface",
      "MeasureAssociation",
      "MeasureDissociation"
    },
    Author->{"alou", "robert"}
  }
];

(* ::Subsubsection::Closed:: *)
(*Regenerate*)


DefineUsage[Regenerate,
  {
    BasicDefinitions -> {
      {"Regenerate[regenerationParameters]","primitive","generates an BioLayerInterferometry-compatible 'primitive' that describes parameters of the assay step."}
    },
    MoreInformation->{
      "Descriptions of primitive keys:",
      Grid[{
        {"Key", "Description"},
        {"RegenerationSolutions", "The samples in which the BLI probes are immersed during this assay step."},
        {"Time", "The duration of the assay step."},
        {"ShakeRate", "The speed at which the plate is shaken during the assay step."}
      }]
    },
    Input:>{
      {
        "regenerationParameters",
        {
          RegenerationSolutions -> Alternatives[
            ObjectP[{Object[Sample], Model[Sample]}],
            {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], Null]..}
          ],
          Time -> RangeP[0 Hour, 20 Hour],
          ShakeRate -> Alternatives[RangeP[100 RPM, 1500 RPM], 0 RPM]
        },
        "The list of key/value pairs describing the samples and parameters used in this assay step."
      }
    },
    Output:>{
      {"primitive",_Regenerate,"A BioLayerInterferometry primitive containing parameters for the assay step."}
    },
    SeeAlso -> {
      "ExperimentBioLayerInterferometry",
      "MeasureBaseline",
      "Wash",
      "Equilibrate",
      "Neutralize",
      "Quantitate",
      "Quench",
      "ActivateSurface",
      "LoadSurface",
      "MeasureAssociation",
      "MeasureDissociation"
    },
    Author->{"alou", "robert"}
  }
];

(* ::Subsubsection::Closed:: *)
(*Neutralize*)


DefineUsage[Neutralize,
  {
    BasicDefinitions -> {
      {"Neutralize[neutralizeParameters]","primitive","generates an BioLayerInterferometry-compatible 'primitive' that describes parameters of the assay step."}
    },
    MoreInformation->{
      "Neutralization should be performed after Regeneration in cases where the pH of the RegenerationSolutions differs greatly from the assay buffer.",
      "Descriptions of primitive keys:",
      Grid[{
        {"Key", "Description"},
        {"NeutralizationSolutions", "The samples in which the BLI probes are immersed during this assay step."},
        {"Time", "The duration of the assay step."},
        {"ShakeRate", "The speed at which the plate is shaken during the assay step."}
      }]
    },
    Input:>{
      {
        "neutralizeParameters",
        {
          NeutralizationSolutions -> Alternatives[
            ObjectP[{Object[Sample], Model[Sample]}],
            {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], Null]..}
          ],
          Time -> RangeP[0 Hour, 20 Hour],
          ShakeRate -> Alternatives[RangeP[100 RPM, 1500 RPM], 0 RPM]
        },
        "The list of key/value pairs describing the samples and parameters used in this assay step."
      }
    },
    Output:>{
      {"primitive",_Neutralize,"A BioLayerInterferometry primitive containing parameters for the assay step."}
    },
    SeeAlso -> {
      "ExperimentBioLayerInterferometry",
      "MeasureBaseline",
      "Wash",
      "Regenerate",
      "Equilibrate",
      "Quantitate",
      "Quench",
      "ActivateSurface",
      "LoadSurface",
      "MeasureAssociation",
      "MeasureDissociation"
    },
    Author->{"alou", "robert"}
  }
];

(* ::Subsubsection::Closed:: *)
(*ActivateSurface*)


DefineUsage[ActivateSurface,
  {
    BasicDefinitions -> {
      {"ActivateSurface[activationParameters]","primitive","generates an BioLayerInterferometry-compatible 'primitive' that describes parameters of the assay step."}
    },
    MoreInformation->{
      "Activation can be performed prior to LoadSurface in order to chemically activate the surface bound molecules towards the loaded species.",
      "Descriptions of primitive keys:",
      Grid[{
        {"Key", "Description"},
        {"ActivationSolutions", "The samples in which the BLI probes are immersed during this assay step."},
        {"Time", "The duration of the assay step."},
        {"ShakeRate", "The speed at which the plate is shaken during the assay step."}
      }]
    },
    Input:>{
      {
        "activationParameters",
        {
          ActivationSolutions -> Alternatives[
            ObjectP[{Object[Sample], Model[Sample]}],
            {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], Null]..}
          ],
          Controls -> Alternatives[
            ObjectP[{Object[Sample], Model[Sample]}],
            {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], Null]...}
          ],
          Time -> RangeP[0 Hour, 20 Hour],
          ShakeRate -> Alternatives[RangeP[100 RPM, 1500 RPM], 0 RPM]
        },
        "The list of key/value pairs describing the samples and parameters used in this assay step."
      }
    },
    Output:>{
      {"primitive",_ActivateSurface,"A BioLayerInterferometry primitive containing parameters for the assay step."}
    },
    SeeAlso -> {
      "ExperimentBioLayerInterferometry",
      "MeasureBaseline",
      "Wash",
      "Regenerate",
      "Neutralize",
      "Quantitate",
      "Quench",
      "Equilibrate",
      "LoadSurface",
      "MeasureAssociation",
      "MeasureDissociation"
    },
    Author->{"alou", "robert"}
  }
];

(* ::Subsubsection::Closed:: *)
(*LoadSurface*)


DefineUsage[LoadSurface,
  {
    BasicDefinitions -> {
      {"LoadSurface[loadingParameters]","primitive","generates an BioLayerInterferometry-compatible 'primitive' that describes parameters of the assay step."}
    },
    MoreInformation->{
      "Functionalize the BLI probe surface with the LoadingSolutions.",
      "Controls will be added at the bottom of the plate column if specified.",
      "Descriptions of primitive keys:",
      Grid[{
        {"Key", "Description"},
        {"LoadingSolutions", "The samples in which the BLI probes are immersed during this assay step."},
        {"Controls", "Blank or Standard samples used im parallel with LoadingSolutions."},
        {"Time", "The duration of the assay step."},
        {"ThresholdCriterion", "The criteria used to trigger the start of the next assay step."},
        {"AbsoluteThreshold", "The absolute change in bio-layer thickness from to start of a given assay step that will trigger the start of the next step."},
        {"ThresholdSlope", "The rate of change in bio-layer thickness that must be met in order to trigger the start of the next assay step."},
        {"ThresholdSlopeDuration", "The duration for which the ThresholdSlope condition must be met or exceeded in order to trigger the start of the next assay step."}
      }]
    },
    Input:>{
      {
        "loadingParameters",
        {
          LoadingSolutions -> Alternatives[
            ObjectP[{Object[Sample], Model[Sample]}],
            {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], Null]..}
          ],
          Controls -> Alternatives[
            ObjectP[{Object[Sample], Model[Sample]}],
            {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], Null]...}
          ],
          Time -> RangeP[0 Hour, 20 Hour],
          ShakeRate -> Alternatives[RangeP[100 RPM, 1500 RPM], 0 RPM],
          ThresholdCriterion -> Alternatives[Single,All],
          AbsoluteThreshold -> RangeP[-500*Nanometer, 500*Nanometer],
          ThresholdSlope -> GreaterP[0*Nanometer/Minute],
          ThresholdSlopeDuration -> RangeP[0 Hour, 20 Hour]
        },
        "The list of key/value pairs describing the samples and parameters used in this assay step."
      }
    },
    Output:>{
      {"primitive",_LoadSurface,"A BioLayerInterferometry primitive containing parameters for the assay step."}
    },
    SeeAlso -> {
      "ExperimentBioLayerInterferometry",
      "MeasureBaseline",
      "Wash",
      "Regenerate",
      "Neutralize",
      "Quantitate",
      "Quench",
      "ActivateSurface",
      "Equilibrate",
      "MeasureAssociation",
      "MeasureDissociation"
    },
    Author->{"alou", "robert"}
  }
];

(* ::Subsubsection::Closed:: *)
(*Quench*)


DefineUsage[Quench,
  {
    BasicDefinitions -> {
      {"Quench[quenchParameters]","primitive","generates an BioLayerInterferometry-compatible 'primitive' that describes parameters of the assay step."}
    },
    MoreInformation->{
      "Quench steps are used following LoadSurface to deactivate any unwanted reactive surface species that could lead to non-selective binding in subsequent assay steps.",
      "Descriptions of primitive keys:",
      Grid[{
        {"Key", "Description"},
        {"QuenchSolutions", "The samples in which the BLI probes are immersed during this assay step."},
        {"Time", "The duration of the assay step."},
        {"ShakeRate", "The speed at which the plate is shaken during the assay step."}
      }]
    },
    Input:>{
      {
        "quenchParameters",
        {
          QuenchSolutions -> Alternatives[
            ObjectP[{Object[Sample], Model[Sample]}],
            {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], Null]..}
          ],
          Controls -> Alternatives[
            ObjectP[{Object[Sample], Model[Sample]}],
            {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], Null]...}
          ],
          Time -> RangeP[0 Hour, 20 Hour],
          ShakeRate -> Alternatives[RangeP[100 RPM, 1500 RPM], 0 RPM]
        },
        "The list of key/value pairs describing the samples and parameters used in this assay step."
      }
    },
    Output:>{
      {"primitive",_Quench,"A BioLayerInterferometry primitive containing parameters for the assay step."}
    },
    SeeAlso -> {
      "ExperimentBioLayerInterferometry",
      "MeasureBaseline",
      "Wash",
      "Regenerate",
      "Neutralize",
      "Quantitate",
      "Quench",
      "ActivateSurface",
      "LoadSurface",
      "MeasureAssociation",
      "MeasureDissociation"
    },
    Author->{"alou", "robert"}
  }
];

(* ::Subsubsection::Closed:: *)
(*MeasureBaseline*)


DefineUsage[MeasureBaseline,
  {
    BasicDefinitions -> {
      {"MeasureBaseline[baselineParameters]","primitive","generates an BioLayerInterferometry-compatible 'primitive' that describes parameters of the assay step."}
    },
    MoreInformation->{
      "Used to measure the baseline, generally prior to MeasureAssociation.",
      "Descriptions of primitive keys:",
      Grid[{
        {"Key", "Description"},
        {"Buffers", "The samples in which the BLI probes are immersed during this assay step."},
        {"Time", "The duration of the assay step."},
        {"ShakeRate", "The speed at which the plate is shaken during the assay step."}
      }]
    },
    Input:>{
      {
        "baselineParameters",
        {
          Buffers -> Alternatives[
            ObjectP[{Object[Sample], Model[Sample]}],
            {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], Null]..}
          ],
          Time -> RangeP[0 Hour, 20 Hour],
          ShakeRate -> Alternatives[RangeP[100 RPM, 1500 RPM], 0 RPM]
        },
        "The list of key/value pairs describing the samples and parameters used in this assay step."
      }
    },
    Output:>{
      {"primitive",_MeasureBaseline,"A BioLayerInterferometry primitive containing parameters for the assay step."}
    },
    SeeAlso -> {
      "ExperimentBioLayerInterferometry",
      "Equilibrate",
      "Wash",
      "Regenerate",
      "Neutralize",
      "Quantitate",
      "Quench",
      "ActivateSurface",
      "LoadSurface",
      "MeasureAssociation",
      "MeasureDissociation"
    },
    Author->{"alou", "robert"}
  }
];

(* ::Subsubsection::Closed:: *)
(*MeasureAssociation*)


DefineUsage[MeasureAssociation,
  {
    BasicDefinitions -> {
      {"MeasureAssociation[associationParameters]","primitive","generates an BioLayerInterferometry-compatible 'primitive' that describes parameters of the assay step."}
    },
    MoreInformation->{
      "MeasureAssociation steps record data for the binding of the target analyte to the surface bound species.",
      "If the desired experiment type is Quantitation, please use the Quantitate primitive.",
      "Descriptions of primitive keys:",
      Grid[{
        {"Key", "Description"},
        {"Analytes", "The samples in which the BLI probes are immersed during this assay step."},
        {"Time", "The duration of the assay step."},
        {"ShakeRate", "The speed at which the plate is shaken during the assay step."},
        {"ThresholdCriterion", "The criteria used to trigger the start of the next assay step."},
        {"AbsoluteThreshold", "The absolute change in bio-layer thickness from to start of a given assay step that will trigger the start of the next step."},
        {"ThresholdSlope", "The rate of change in bio-layer thickness that must be met in order to trigger the start of the next assay step."},
        {"ThresholdSlopeDuration", "The duration for which the ThresholdSlope condition must be met or exceeded in order to trigger the start of the next assay step."}
      }]
    },
    Input:>{
      {
        "associationParameters",
        {
          Analytes -> Alternatives[
            ObjectP[{Object[Sample], Model[Sample]}],
            {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], Null]..}
          ],
          Controls -> Alternatives[
            ObjectP[{Object[Sample], Model[Sample]}],
            {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], Null]...}
          ],
          Time -> RangeP[0 Hour, 20 Hour],
          ShakeRate -> Alternatives[RangeP[100 RPM, 1500 RPM], 0 RPM],
          ThresholdCriterion -> Alternatives[Single,All],
          AbsoluteThreshold -> RangeP[-500*Nanometer, 500*Nanometer],
          ThresholdSlope -> GreaterP[0*Nanometer/Minute],
          ThresholdSlopeDuration -> RangeP[0 Hour, 20 Hour]
        },
        "The list of key/value pairs describing the samples and parameters used in this assay step."
      }
    },
    Output:>{
      {"primitive",_MeasureAssociation,"A BioLayerInterferometry primitive containing parameters for the assay step."}
    },
    SeeAlso -> {
      "ExperimentBioLayerInterferometry",
      "MeasureBaseline",
      "Wash",
      "Regenerate",
      "Neutralize",
      "Quantitate",
      "Quench",
      "ActivateSurface",
      "LoadSurface",
      "Equilibrate",
      "MeasureDissociation"
    },
    Author->{"alou", "robert"}
  }
];

(* ::Subsubsection::Closed:: *)
(*MeasureDissociation*)


DefineUsage[MeasureDissociation,
  {
    BasicDefinitions -> {
      {"MeasureDissociation[dissociationParameters]","primitive","generates an BioLayerInterferometry-compatible 'primitive' that describes parameters of the assay step."}
    },
    MoreInformation->{
      "MeasureDissociation steps follow MeasureAssociation steps and record data for the dissociation of the target analyte from the surface bound species.",
      "Descriptions of primitive keys:",
      Grid[{
        {"Key", "Description"},
        {"Buffers", "The samples in which the BLI probes are immersed during this assay step."},
        {"Time", "The duration of the assay step."},
        {"ShakeRate", "The speed at which the plate is shaken during the assay step."},
        {"ThresholdCriterion", "The criteria used to trigger the start of the next assay step."},
        {"AbsoluteThreshold", "The absolute change in bio-layer thickness from to start of a given assay step that will trigger the start of the next step."},
        {"ThresholdSlope", "The rate of change in bio-layer thickness that must be met in order to trigger the start of the next assay step."},
        {"ThresholdSlopeDuration", "The duration for which the ThresholdSlope condition must be met or exceeded in order to trigger the start of the next assay step."}
      }]
    },
    Input:>{
      {
        "dissociationParameters",
        {
          Buffers -> Alternatives[
            ObjectP[{Object[Sample], Model[Sample]}],
            {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], Null]..}
          ],
          Controls -> Alternatives[
            ObjectP[{Object[Sample], Model[Sample]}],
            {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], Null]...}
          ],
          Time -> RangeP[0 Hour, 20 Hour],
          ShakeRate -> Alternatives[RangeP[100 RPM, 1500 RPM], 0 RPM],
          ThresholdCriterion -> Alternatives[Single,All],
          AbsoluteThreshold -> RangeP[-500*Nanometer, 500*Nanometer],
          ThresholdSlope -> GreaterP[0*Nanometer/Minute],
          ThresholdSlopeDuration -> RangeP[0 Hour, 20 Hour]
        },
        "The list of key/value pairs describing the samples and parameters used in this assay step."
      }
    },
    Output:>{
      {"primitive",_MeasureDissociation,"A BioLayerInterferometry primitive containing parameters for the assay step."}
    },
    SeeAlso -> {
      "ExperimentBioLayerInterferometry",
      "MeasureBaseline",
      "Wash",
      "Regenerate",
      "Neutralize",
      "Quantitate",
      "Quench",
      "ActivateSurface",
      "LoadSurface",
      "MeasureAssociation",
      "Equilibrate"
    },
    Author->{"alou", "robert"}
  }
];

(* ::Subsubsection::Closed:: *)
(*Quantitate*)


DefineUsage[Quantitate,
  {
    BasicDefinitions -> {
      {"Quantitate[quantitationParameters]","primitive","generates an BioLayerInterferometry-compatible 'primitive' that describes parameters of the assay step."}
    },
    MoreInformation->{
      "Record binding of the target analyte to the surface bound species.",
      "Descriptions of primitive keys:",
      Grid[{
        {"Key", "Description"},
        {"Buffers", "The samples in which the BLI probes are immersed during this assay step."},
        {"Time", "The duration of the assay step."},
        {"ShakeRate", "The speed at which the plate is shaken during the assay step."}
      }]
    },
    Input:>{
      {
        "quantitationParameters",
        {
          Analytes -> Alternatives[
            ObjectP[{Object[Sample], Model[Sample]}],
            {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], Null]..}
          ],
          Controls -> Alternatives[
            ObjectP[{Object[Sample], Model[Sample]}],
            {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], Null]...}
          ],
          Time -> RangeP[0 Hour, 20 Hour],
          ShakeRate -> Alternatives[RangeP[100 RPM, 1500 RPM], 0 RPM]
        },
        "The list of key/value pairs describing the samples and parameters used in this assay step."
      }
    },
    Output:>{
      {"primitive",_Quantitate,"A BioLayerInterferometry primitive containing parameters for the assay step."}
    },
    SeeAlso -> {
      "ExperimentBioLayerInterferometry",
      "MeasureBaseline",
      "Wash",
      "Regenerate",
      "Neutralize",
      "Equilibrate",
      "Quench",
      "ActivateSurface",
      "LoadSurface",
      "MeasureAssociation",
      "MeasureDissociation"
    },
    Author->{"alou", "robert"}
  }
];