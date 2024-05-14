DefineUsage[PredictDestinationPhase,
  {
    BasicDefinitions -> {
      {
        Definition->{"PredictDestinationPhase[molecules]", "predictedDestinationPhases"},
        Description->"predicts the destination phases of the given 'molecules' when they are in a biphasic sample that contains both an Aqueous and Organic phase.",
        Inputs:>{
          {
            InputName->"molecules",
            Description->"The molecules whose destination phases are predicted.",
            Widget->Widget[
              Type->Object,
              Pattern:>ObjectP[Model[Molecule]]
            ]
          }
        },
        Outputs:>{
          {
            OutputName->"predictedDestinationPhases",
            Description->"The predicted destination phases of the given molecules (Aqueous or Organic) when they are in a biphasic sample that contains both an Aqueous and Organic phase.",
            Pattern:>Aqueous | Organic | Unknown
          }
        }
      }
    },
    MoreInformation -> {
      "The function SimulateLogPartitionCoefficient is used to lookup the experimentally derived or simulated Log Partition Coefficient (LogP).",
      "Molecules with a LogP greater than 0 are more hydrophobic (and are predicted to have a higher concentration in the Organic phase) and molecules with a LogP less than 0 are more hydrophilic (and are predicted to have a higher concentration in the Aqueous phase).",
      "Note that LogP refers to the concentration of the molecule in Octanol (Organic) and Water (Aqueous) so the molecule's concentration will different when different Organic/Aqueous solvents are chosen."
    },
    SeeAlso -> {
      "ExperimentLiquidLiquidExtraction",
      "SimulateLogPartitionCoefficient",
      "PredictSamplePhase"
    },
    Author -> {"thomas", "lige.tonggu"}
  }
];

DefineUsage[PredictSamplePhase,
  {
    BasicDefinitions -> {
      {
        Definition->{"PredictSamplePhase[samples]", "predictedSamplePhases"},
        Description->"predicts the phase of the given 'samples' (Aqueous, Organic, Biphasic, Unknown).",
        Inputs:>{
          {
            InputName->"samples",
            Description->"The samples whose phases are predicted.",
            Widget->Widget[
              Type->Object,
              Pattern:>ObjectP[Model[Molecule]]
            ]
          }
        },
        Outputs:>{
          {
            OutputName->"predictedSamplePhases",
            Description->"The predicted phase of the given sample (Aqueous, Organic, Biphasic, Unknown).",
            Pattern:>SamplePhaseP
          }
        }
      }
    },
    MoreInformation -> {
      "If the given sample has a Solvent (field in Object[Sample]), the Composition of the sample's Solvent is used to estimate the sample's phase. Otherwise, the molecules in the sample's Composition are used. Only molecules that are listed in the Composition as VolumePercent are included (analytes that are listed in molarity are not included).",
      "A molecule is considered to contribute to the Aqueous layer if its LogP (according to the function SimulateLogPartitionCoefficient) is < -0.5. A molecule is considered to contribute to the Organic layer if its LogP (according to the function SimulateLogPartitionCoefficient) is > 0.5. Molecules with a LogP between -0.5 and 0.5 are considered to be evenly distributed amongst both Aqueous and Organic layers (if either are present).",
      "If the sample is comprised of more than 30 VolumePercent Organic components and more than 30 VolumePercent Aqueous components (when summing up the VolumePercent contributions from all of the individual molecules), it is considered Biphasic (containing both Organic and Aqueous phases).",
      "Otherwise, if the sample is comprised of more than 30 VolumePercent Organic components, it is considered to only have an Organic layer.",
      "Otherwise, if the sample is comprised of more than 30 VolumePercent Aqueous components and contains Model[Molecule, \"Water\"], it is considered to only have an Aqueous layer.",
      "Otherwise, the sample has an Unknown phase.",
      "Note that LogP refers to the concentration of the molecule in Octanol (Organic) and Water (Aqueous) so the molecule's concentration will different when different Organic/Aqueous solvents are chosen."
    },
    SeeAlso -> {
      "ExperimentLiquidLiquidExtraction",
      "SimulateLogPartitionCoefficient",
      "PredictDestinationPhase"
    },
    Author -> {"thomas", "lige.tonggu"}
  }
];

DefineUsage[SimulateLogPartitionCoefficient,
  {
    BasicDefinitions -> {
      {
        Definition->{"SimulateLogPartitionCoefficient[molecule]", "logP"},
        Description->"computes the logarithm of the partition coefficient, which is the ratio of concentrations of a solute between the aqueous and organic phases of a biphasic solution.",
        Inputs:>{
          {
            InputName->"molecule",
            Description->"The molecule whose LogP will be calculated.",
            Widget->Widget[
              Type->Object,
              Pattern:>ObjectP[Model[Molecule]]
            ]
          }
        },
        Outputs:>{
          {
            OutputName->"logP",
            Description->"The logarithm of the partition coefficient, which is the ratio of concentrations of a solute between the aqueous and organic phases of a biphasic solution.",
            Pattern:>_?NumericQ
          }
        }
      }
    },
    MoreInformation -> {
      "The partition coefficient measures the hydrophilicity or hydrophobicity of a molecule. This metric can be used to predict which layer of an aqueous/organic separation a molecule will be more concentrated in. It can also be used to predict the distribution of a drug after absorbed by the body (for example, hydrophobic drugs are mainly distributed to hydrophobic areas in the body such as the lipid bilayers of cells).",
      "Molecules with a LogP greater than 0 are more hydrophobic and molecules with a LogP less than 0 are more hydrophilic.",
      "The function will first try to find an experimentally measured LogP value in Model[Molecule][LogP]. If the function is unable to find an experimentally measured LogP value, LogP is simulated using the XLogP3 algorithm (Cheng, T. et al \"Computation of Octanol-Water Partition Coefficients by Guiding an Additive Model with Knowledge\", J. Chem. Inf. Model. 2007, 47, 2140-2148.) via the PubChem public API. An error will be returned for if the PubChem API does not have a predicted LogP for the given molecule.",
      "Note that LogP refers to the concentration of the molecule in Octanol (Organic) and Water (Aqueous) so the molecule's concentration will different when different Organic/Aqueous solvents are chosen."
    },
    SeeAlso -> {
      "ExperimentLiquidLiquidExtraction",
      "PredictDestinationPhase",
      "PredictSamplePhase"
    },
    Author -> {"thomas", "lige.tonggu"}
  }
];