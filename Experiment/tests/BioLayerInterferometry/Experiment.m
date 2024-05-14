(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentBioLayerInterferometry*)


DefineTests[ExperimentBioLayerInterferometry,
  {
    Example[{Basic, "Perform a quantitation bio layer interferometry assay on a single sample with a naked probe surface:"},
      ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID]],
      ObjectP[Object[Protocol, BioLayerInterferometry]],
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic, "Perform a Kinetics bio layer interferometry assay on multiple samples using a loaded probe:"},
      ExperimentBioLayerInterferometry[
        {
          Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID], Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        LoadingType -> {Load},
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        DefaultBuffer -> Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      ObjectP[Object[Protocol, BioLayerInterferometry]],
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic, "Perform a Quantitation bio layer interferometry assay on multiple samples:"},
      ExperimentBioLayerInterferometry[
        {
          Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID], Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 5 (20 mL)" <> $SessionUUID], Object[Sample, "ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> Quantitation,
        DefaultBuffer -> Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID]
      ],
      ObjectP[Object[Protocol, BioLayerInterferometry]],
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      )
    ],

    Example[{Basic, "Perform a EpitopeBinning bio layer interferometry assay on multiple samples:"},
      ExperimentBioLayerInterferometry[{
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID], Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 5 (20 mL)" <> $SessionUUID], Object[Sample, "ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID]
      },
        ExperimentType -> EpitopeBinning, BinningType -> Tandem,
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        DefaultBuffer -> Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      ObjectP[Object[Protocol, BioLayerInterferometry]],
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      )
    ],

    Example[{Basic, "Perform a AssayDevelopment bio layer interferometry assay on multiple samples:"},
      ExperimentBioLayerInterferometry[
        {
          Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID], Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> AssayDevelopment,
        DefaultBuffer -> Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      ObjectP[Object[Protocol, BioLayerInterferometry]],
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      )
    ],

    (* --------------- *)
    (* --- OPTIONS --- *)
    (* --------------- *)


    (*set experiment type*)
    Example[{Options, ExperimentType, "Use the ExperimentType option to set the type of assay to Quantitation:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], ExperimentType -> Quantitation, Output -> Options];
      Lookup[options, ExperimentType],
      Quantitation,
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],
    Example[{Options, ExperimentType, "Use the ExperimentType option to set the type of assay to AssayDevelopment:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, ExperimentType],
      AssayDevelopment,
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],
    Example[{Options, ExperimentType, "Use the ExperimentType option to set the type of assay to EpitopeBinning:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> EpitopeBinning,
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, ExperimentType],
      EpitopeBinning,
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],
    Example[{Options, ExperimentType, "Use the ExperimentType option to set the type of assay to Kinetics:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, ExperimentType],
      Kinetics,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],



    (* --------------------------------------- *)
    (* --- NON EXPERIMENT SPECIFIC OPTIONS --- *)
    (* --------------------------------------- *)
    Example[{Options, Template, "Use a previous BioLayerInterferometry protocol as a template for a new one:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        Template -> Object[Protocol,BioLayerInterferometry,"Test Template Protocol for ExperimentBLI" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, Instrument],
      ObjectP[Object[Instrument, BioLayerInterferometer, "Test Octet Red96e for ExperimentBLI" <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, Name, "Use Name option to give a name to the protocol:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        Name -> "my BLI protocol",
        Output -> Options
      ];
      Lookup[options, Name],
      "my BLI protocol",
      Variables :> {options}
    ],
    Example[{Options,IncubateAliquotDestinationWell,"Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
      options=ExperimentBioLayerInterferometry[
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        IncubateAliquotDestinationWell -> "A1",
        AliquotContainer->Model[Container, Vessel, "2mL Tube"],
        Output -> Options
      ];
      Lookup[options,IncubateAliquotDestinationWell],
      "A1",
      Variables :> {options}
    ],
    Example[{Options,CentrifugeAliquotDestinationWell,"Indicates the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
      options=ExperimentBioLayerInterferometry[
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        CentrifugeAliquotDestinationWell -> "A1",
        Output -> Options
      ];
      Lookup[options,CentrifugeAliquotDestinationWell],
      "A1",
      Variables :> {options}
    ],
    Example[{Options,FilterAliquotDestinationWell,"Indicates the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
      options=ExperimentBioLayerInterferometry[
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        FilterAliquotDestinationWell -> "A1",
        Output -> Options
      ];
      Lookup[options,FilterAliquotDestinationWell],
      "A1",
      Variables :> {options}
    ],
    Example[{Options,DestinationWell,"Indicates the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
      options=ExperimentBioLayerInterferometry[
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        DestinationWell -> "A1",
        Output -> Options
      ];
      Lookup[options,DestinationWell],
      "A1",
      Variables :> {options}
    ],
    Example[{Options, Instrument, "Set the Instrument for ExperimentBioLayerInterferometry:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        Instrument -> Object[Instrument, BioLayerInterferometer, "Test Octet Red96e for ExperimentBLI" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, Instrument],
      ObjectP[Object[Instrument, BioLayerInterferometer, "Test Octet Red96e for ExperimentBLI" <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, BioProbeType, "Set the BioProbeType for ExperimentBioLayerInterferometry:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options
      ];
      Lookup[options, BioProbeType],
      ObjectP[Model[Item, BLIProbe, "SA"]],
      Variables :> {options}
    ],
    Example[{Options, NumberOfRepeats, "Use the NumberOfRepeats option to request more measurements:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        MeasureAssociationTime -> 2 Hour,
        NumberOfRepeats -> 6,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, NumberOfRepeats],
      6,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, SaveAssayPlate, "Use the SaveAssayPlate option to save the assay plate after experiment:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        SaveAssayPlate -> True,
        Output -> Options];
      Lookup[options, SaveAssayPlate],
      True,
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],
    Example[{Options, KineticsReferenceType, "Use the KineticsReferenceType option to request a blank for kinetics reference:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        KineticsReferenceType -> Blank, ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, KineticsReferenceType],
      Blank,
      Variables :> {options}
    ],
    Example[{Options,MeasureBaselineShakeRate,"Use the MeasureBaselineShakeRate option to set shake rate of the plate while bio-probe is immersed in KineticsBaselineBuffer:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        MeasureBaselineShakeRate -> 200 RPM,
        MeasureAssociationTime -> 20 Second,
        MeasureAssociationShakeRate -> 1000 RPM,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, MeasureBaselineShakeRate],
      200 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options,MeasureAssociationTime,"Use the MeasureAssociationTime option to set the amount of time for which the bio-probe is immersed in the sample solution:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        MeasureBaselineShakeRate -> 200 RPM,
        MeasureAssociationTime -> 20 Second,
        MeasureAssociationShakeRate -> 1000 RPM,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, MeasureAssociationTime],
      20 Second,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options,MeasureAssociationShakeRate,"Use the MeasureAssociationShakeRate option to set the speed at which the assay plate is shaken while the bio-probe is immersed in the sample solution:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        MeasureBaselineShakeRate -> 200 RPM,
        MeasureAssociationTime -> 20 Second,
        MeasureAssociationShakeRate -> 1000 RPM,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, MeasureAssociationShakeRate],
      1000 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options,MeasureAssociationThresholdCriterion,"Use the MeasureAssociationThresholdCriterion option to indicate if the threshold condition for change in bio-layer thickness will trigger the completion of the Association step must be met by any single well, or all of the wells measured in the step:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        MeasureAssociationThresholdCriterion -> All,
        MeasureAssociationThresholdSlope -> 3 Nanometer/Minute,
        MeasureAssociationThresholdSlopeDuration -> 1 Minute,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, MeasureAssociationThresholdCriterion],
      All,
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],
    Example[{Options,MeasureAssociationThresholdSlope,"Use the MeasureAssociationThresholdSlope option to set the rate of change in bio-layer thickness that will trigger the removal of the bio-probe from the sample solution:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        MeasureAssociationThresholdCriterion -> All,
        MeasureAssociationThresholdSlope -> 3 Nanometer/Minute,
        MeasureAssociationThresholdSlopeDuration -> 1 Minute,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, MeasureAssociationThresholdSlope],
      3 Nanometer/Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options,MeasureAssociationThresholdSlopeDuration,"Use the MeasureAssociationThresholdSlopeDuration option to set the amount of time that a given rate of change in bio-layer thickness must be exceeded to will trigger the removal of the bio-probe from the sample solution:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        MeasureAssociationThresholdCriterion -> All,
        MeasureAssociationThresholdSlope -> 3 Nanometer/Minute,
        MeasureAssociationThresholdSlopeDuration -> 1 Minute,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, MeasureAssociationThresholdSlopeDuration],
      1 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options,MeasureAssociationAbsoluteThreshold,"Use the MeasureAssociationAbsoluteThreshold option to set the thickness of bio-layer that will trigger the removal of the bio-probe from the sample solution:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        MeasureAssociationThresholdCriterion -> All,
        MeasureAssociationAbsoluteThreshold -> 100 Nanometer,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, MeasureAssociationAbsoluteThreshold],
      100 Nanometer,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options,MeasureDissociationTime,"Use the MeasureDissociationTime option to set the amount of time that the bio-probe is immersed to measure analyte dissociation:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        MeasureDissociationTime -> 15 Minute,
        MeasureDissociationThresholdCriterion -> All,
        MeasureDissociationThresholdSlope -> 3 Nanometer/Minute,
        MeasureDissociationThresholdSlopeDuration -> 1 Minute,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, MeasureDissociationTime],
      15 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options,MeasureDissociationShakeRate,"Use the MeasureDissociationShakeRate option to set the speed at which the assay plate is shaken while the bio-probe is immersed in the sample solution:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        MeasureBaselineShakeRate -> 200 RPM,
        MeasureDissociationTime -> 20 Second,
        MeasureDissociationShakeRate -> 1000 RPM,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, MeasureDissociationShakeRate],
      1000 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options,MeasureDissociationThresholdCriterion,"Use the MeasureDissociationThresholdCriterion option to indicate if the threshold condition for change in bio-layer thickness will trigger the completion of the Dissociation step must be met by any single well, or all of the wells measured in the step:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        MeasureDissociationTime -> 15 Minute,
        MeasureDissociationThresholdCriterion -> All,
        MeasureDissociationThresholdSlope -> 3 Nanometer/Minute,
        MeasureDissociationThresholdSlopeDuration -> 1 Minute,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, MeasureDissociationThresholdCriterion],
      All,
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],
    Example[{Options,MeasureDissociationThresholdSlope,"Use the MeasureDissociationThresholdSlope option to set the rate of change in bio-layer thickness that will trigger the removal of the bio-probe from the sample solution:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        MeasureDissociationTime -> 15 Minute,
        MeasureDissociationThresholdCriterion -> All,
        MeasureDissociationThresholdSlope -> 3 Nanometer/Minute,
        MeasureDissociationThresholdSlopeDuration -> 1 Minute,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, MeasureDissociationThresholdSlope],
      3 Nanometer/Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options,MeasureDissociationThresholdSlopeDuration,"Use the MeasureDissociationThresholdSlopeDuration option to set the amount of time that a given rate of change in bio-layer thickness must be exceeded to will trigger the removal of the bio-probe from the sample solution:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        MeasureDissociationTime -> 15 Minute,
        MeasureDissociationThresholdCriterion -> All,
        MeasureDissociationThresholdSlope -> 3 Nanometer/Minute,
        MeasureDissociationThresholdSlopeDuration -> 1 Minute,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, MeasureDissociationThresholdSlopeDuration],
      1 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options,MeasureDissociationAbsoluteThreshold,"Use the MeasureDissociationAbsoluteThreshold option to set the thickness of bio-layer that will trigger the removal of the bio-probe from the sample solution:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        MeasureDissociationTime -> 15 Minute,
        MeasureDissociationThresholdCriterion -> All,
        MeasureDissociationAbsoluteThreshold -> -100 Nanometer,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, MeasureDissociationAbsoluteThreshold],
      -100 Nanometer,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, KineticsSampleFixedDilutions, "Use the KineticsSampleFixedDilutions option to define direct dilutions for the given sample:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        KineticsSampleFixedDilutions -> {{{2, "101"}, {5, "102"}, {10, "103"}}},
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, KineticsSampleFixedDilutions],
      {{{2, "101"}, {5, "102"}, {10, "103"}}},
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],
    Example[{Options, KineticsSampleSerialDilutions, "Use the KineticsSampleSerialDilutions option to define serial dilutions for the given sample:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        KineticsSampleSerialDilutions -> {{{2, "105"}, {2, "106"}, {2, "107"}}},
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, KineticsSampleSerialDilutions],
      {{{2, "105"}, {2, "106"}, {2, "107"}}},
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],
    Example[{Options, KineticsSampleDiluent, "Use the KineticsSampleDiluent option to define diluent used in direct dilutions for the given sample:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        KineticsSampleFixedDilutions -> {{{2, "101"}, {5, "102"}, {10, "103"}}},
        KineticsSampleDiluent -> Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, KineticsSampleDiluent],
      ObjectP[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID]],
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],

    Example[{Options, QuantitationParameters, "Set the QuantitationParameters to change a series of modifications on a basic quantitation experiment which are used inform the assay steps and plate layout:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        QuantitationParameters -> {EnzymeLinked, AmplifiedDetection},
        AmplifiedDetectionSolution -> Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
        QuantitationEnzymeSolution -> Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
        QuantitationEnzymeSolutionStorageCondition -> AmbientStorage,
        Output -> Options
      ];
      Lookup[options, QuantitationParameters],
      {EnzymeLinked, AmplifiedDetection},
      Variables :> {options}
    ],
    Example[{Options, AmplifiedDetectionSolution, "Set the AmplifiedDetectionSolution to specify the solution which contains a species that binds to the immobilized analyte on the bio-probe surface, thereby increasing the thickness of the bio-layer:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        QuantitationParameters -> {EnzymeLinked, AmplifiedDetection},
        AmplifiedDetectionSolution -> Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
        QuantitationEnzymeSolution -> Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
        QuantitationEnzymeSolutionStorageCondition -> AmbientStorage,
        Output -> Options
      ];
      Lookup[options, AmplifiedDetectionSolution],
      ObjectP[Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, QuantitationEnzymeSolution, "Set the QuantitationEnzymeSolution to specify the solution which contains enzyme used to amplify quantitation results:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        QuantitationParameters -> {EnzymeLinked, AmplifiedDetection},
        AmplifiedDetectionSolution -> Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
        QuantitationEnzymeSolution -> Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
        QuantitationEnzymeSolutionStorageCondition -> AmbientStorage,
        Output -> Options
      ];
      Lookup[options, QuantitationEnzymeSolution],
      ObjectP[Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, QuantitationStandardSerialDilutions, "Set the AmplifiedDetectionSolution to specify the solution which contains a species that binds to the immobilized analyte on the bio-probe surface, thereby increasing the thickness of the bio-layer:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        QuantitationParameters -> {StandardCurve},
        QuantitationStandard -> Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        QuantitationStandardSerialDilutions -> {{2, "2x standard dilution"},{4, "4x standard dilution"},{8, "8x standard dilution"},{16, "16x standard dilution"},{32, "32x standard dilution"}, {64, "64x standard dilution"},{128,"128x standard dilution"}},
        Output -> Options
      ];
      Lookup[options, QuantitationStandardSerialDilutions],
      {{2, "2x standard dilution"},{4, "4x standard dilution"},{8, "8x standard dilution"},{16, "16x standard dilution"},{32, "32x standard dilution"}, {64, "64x standard dilution"},{128,"128x standard dilution"}},
      Variables :> {options}
    ],
    Example[{Options, PreMixSolutions, "Set PreMixSolutions option:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        BinningType -> PreMix,
        ExperimentType -> EpitopeBinning,
        PreMixSolutions -> {{100 Microliter, 100 Microliter, 10 Microliter, "101"}},
        PreMixDiluent -> Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, PreMixSolutions],
      {{100 Microliter, 100 Microliter, 10 Microliter, "101"}},
      Variables :> {options}
    ],

    Example[{Options, DetectionLimitFixedDilutions, "Set the DetectionLimitFixedDilutions option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        DetectionLimitFixedDilutions -> {{{2, "105"}, {2, "106"}, {2, "107"}}},
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options
      ];
      Lookup[options, DetectionLimitFixedDilutions],
      {{{2, "105"}, {2, "106"}, {2, "107"}}},
      Variables :> {options}
    ],
    Example[{Options, DetectionLimitSerialDilutions, "Set the DetectionLimitSerialDilutions option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        DetectionLimitSerialDilutions -> {{{2, "101"}, {5, "102"}, {10, "103"}}},
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options
      ];
      Lookup[options, DetectionLimitSerialDilutions],
      {{{2, "101"}, {5, "102"}, {10, "103"}}},
      Variables :> {options}
    ],
    Example[{Options, DetectionLimitDiluent, "Set the DetectionLimitDiluent option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        DetectionLimitFixedDilutions -> {{{2, "105"}, {2, "106"}, {2, "107"}}},
        DetectionLimitDiluent -> Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options
      ];
      Lookup[options, DetectionLimitDiluent],
      ObjectP[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID]],
      Variables :> {options}
    ],

    Example[{Options, TestInteractionSolutions, "Set TestInteractionSolutions option:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        DevelopmentType -> ScreenInteraction,
        TestInteractionSolutions ->  Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, TestInteractionSolutions],
      ObjectP[Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, TestBufferSolutions, "Set TestBufferSolutions option:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        DevelopmentType -> ScreenBuffer,
        TestBufferSolutions -> {Model[Sample, "Milli-Q water"]},
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, TestBufferSolutions],
      {ObjectP[Model[Sample, "Milli-Q water"]]},
      Variables :> {options}
    ],
    Example[{Options, TestRegenerationSolutions, "Set TestRegenerationSolutions option:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        DevelopmentType -> ScreenRegeneration,
        RegenerationType -> Regenerate,
        TestRegenerationSolutions -> {Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]},
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, TestRegenerationSolutions],
      {ObjectP[Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]]},
      Variables :> {options},
      Messages :> {Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, TestLoadingSolutions, "Set TestLoadingSolutions option:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        DevelopmentType -> ScreenLoading,
        LoadingType -> {Load},
        TestLoadingSolutions -> {Object[Sample, "ExperimentBLI New Test Chemical 5 (20 mL)" <> $SessionUUID]},
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, TestLoadingSolutions],
      {ObjectP[Object[Sample, "ExperimentBLI New Test Chemical 5 (20 mL)" <> $SessionUUID]]},
      Variables :> {options}
    ],
    Example[{Options, TestActivationSolutions, "Set TestActivationSolutions option:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        DevelopmentType -> ScreenActivation,
        LoadingType -> {Load, Activate},
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        TestActivationSolutions -> {Object[Sample, "ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID]},
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, TestActivationSolutions],
      {ObjectP[Object[Sample, "ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID]]},
      Variables :> {options}
    ],
    Example[{Options, RepeatedSequence, "Use RepeatedSequence option to repeat steps by each bio-probe when regeneration is requested:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        AssaySequencePrimitives -> {
          Equilibrate[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],8], Time -> 20 Minute, ShakeRate -> 200 RPM],
          MeasureBaseline[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],8], Time -> 20 Minute, ShakeRate -> 200 RPM],
          MeasureDissociation[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],8], Time -> 20 Minute, ShakeRate -> 200 RPM]
        },
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        RepeatedSequence -> {MeasureBaseline, MeasureDissociation},
        Output -> Options
      ];
      Lookup[options, RepeatedSequence],
      {MeasureBaseline, MeasureDissociation},
      Variables :> {options},
      Messages :> {Warning::BLIPrimitiveOverride}
    ],

    (* -- STORAGE CONDITION OPTIONS -- *)

    Example[{Options, StandardStorageCondition, "Set the StandardStorageCondition to change the storage condition of the Object[Sample] used as a Standard:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        QuantitationParameters -> {StandardCurve},
        Standard -> Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
        StandardStorageCondition -> AmbientStorage,
        Output -> Options
      ];
      Lookup[options, StandardStorageCondition],
      AmbientStorage,
      Variables :> {options}
    ],
    Example[{Options, QuantitationStandardStorageCondition, "Set the QuantitationStandardStorageCondition to change the storage condition of the Object[Sample] used as a QuantitationStandard:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        QuantitationParameters -> {StandardCurve},
        QuantitationStandard -> Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
        QuantitationStandardStorageCondition -> AmbientStorage,
        Output -> Options
      ];
      Lookup[options, QuantitationStandardStorageCondition],
      AmbientStorage,
      Variables :> {options}
    ],
    Example[{Options, QuantitationStandardStorageCondition, "Automatically resolve the QuantitationStandardStorageCondition when Standard is used as the QuantitationStandard:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        QuantitationParameters -> {StandardCurve},
        Standard -> Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
        StandardStorageCondition -> AmbientStorage,
        Output -> Options
      ];
      Lookup[options, QuantitationStandardStorageCondition],
      AmbientStorage,
      Variables :> {options}
    ],

    Example[{Options, LoadSolutionStorageCondition, "Set the LoadSolutionStorageCondition to change the storage condition of the Object[Sample] used as a LoadSolution:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        LoadingType -> {Load},
        LoadSolution -> Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
        LoadSolutionStorageCondition -> AmbientStorage,
        Output -> Options
      ];
      Lookup[options, LoadSolutionStorageCondition],
      AmbientStorage,
      Variables :> {options}
    ],
    Example[{Options, TestInteractionSolutionsStorageConditions, "Set the TestInteractionSolutionsStorageConditions to change the storage conditions of the Object[Sample]s used as TestInteractionSolutions:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> AssayDevelopment,
        DevelopmentType -> ScreenInteraction,
        TestInteractionSolutions -> {
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        TestInteractionSolutionsStorageConditions -> {AmbientStorage, Freezer},
        Output -> Options
      ];
      Lookup[options, TestInteractionSolutionsStorageConditions],
      {AmbientStorage, Freezer},
      Variables :> {options}
    ],
    Example[{Options, TestLoadingSolutionsStorageConditions, "Set the LoadSolutionStorageConditions to change the storage conditions of the Object[Sample]s used as TestLoadingSoutions:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        DevelopmentType -> ScreenLoading,
        LoadingType -> {Load},
        TestLoadingSolutions -> {
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        TestLoadingSolutionsStorageConditions -> {AmbientStorage, Freezer},
        Output -> Options
      ];
      Lookup[options, TestLoadingSolutionsStorageConditions],
      {AmbientStorage, Freezer},
      Variables :> {options}
    ],
    Example[{Options, QuantitationEnzymeSolutionStorageCondition, "Set the QuantitationEnzymeSolutionStorageCondition to change the storage condition of the Object[Sample] used as a QuantitationEnzyme:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        QuantitationParameters -> {EnzymeLinked, AmplifiedDetection},
        AmplifiedDetectionSolution -> Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
        QuantitationEnzymeSolution -> Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
        QuantitationEnzymeSolutionStorageCondition -> AmbientStorage,
        Output -> Options
      ];
      Lookup[options, QuantitationEnzymeSolutionStorageCondition],
      AmbientStorage,
      Variables :> {options}
    ],
    Example[{Options, BinningAntigenStorageCondition, "Set the BinningAntigenStorageCondition to change the storage condition of the Object[Sample] used as a BinningAntigen:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> EpitopeBinning,
        BinningAntigen -> Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
        BinningAntigenStorageCondition -> AmbientStorage,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options
      ];
      Lookup[options, BinningAntigenStorageCondition],
      AmbientStorage,
      Variables :> {options}
    ],



    (* -- GENERAL OPTIONS -- *)

    Example[{Options, AcquisitionRate, "Set the AcquisitionRate to increase instrument sensitivity to rapid changes in bio-layer thickness or reduce noise:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        AcquisitionRate -> 10 Hertz,
        Output -> Options];
      Lookup[options, AcquisitionRate],
      10 Hertz,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, PlateCover, "Use the PlateCover option to request that the assay plate be covered during the entire assay:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        MeasureAssociationTime -> 2 Hour,
        NumberOfRepeats -> 6,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        PlateCover -> True, Output -> Options];
      Lookup[options, PlateCover],
      True,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {Warning::BLIPlateCoverNotRecommended}
    ],
    Example[{Options, Temperature, "Set the temperature of the assay plate using the Temperature setting:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        Temperature -> 20 Celsius, Output -> Options];
      Lookup[options, Temperature],
      20 Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, RecoupSample, "Use RecoupSample to indicate which samples should be recovered after the non-destructive assay:"},
      options = ExperimentBioLayerInterferometry[
        {Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]},
        RecoupSample -> {True, False}, Output -> Options];
      Lookup[options, RecoupSample],
      {True, False},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, ProbeRackEquilibration, "Use the ProbeRackEquilibration option to indicate if the bio-probes should be equilibrated in their storage rack:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ProbeRackEquilibration -> False, Output -> Options];
      Lookup[options, ProbeRackEquilibration],
      False,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages:>{Warning::NoBLIProbeEquilibration}
    ],
    Example[{Options, ProbeRackEquilibrationTime, "Use the ProbeRackEquilibrationTime option to set the minimum amount of time that probes will be equilibrated prior to use:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], ProbeRackEquilibrationTime -> 20 Minute, Output -> Options];
      Lookup[options, ProbeRackEquilibrationTime],
      20 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, ProbeRackEquilibrationTime, "Automatically resolve the ProbeRackEquilibrationTime if probe rack equilibration is requested:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], ProbeRackEquilibration -> True, Output -> Options];
      Lookup[options, ProbeRackEquilibrationTime],
      10 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, ProbeRackEquilibrationBuffer, "Use the ProbeRackEquilibrationBuffer option to indicate the buffer used to equilibrate the probes in the probe rack:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], ProbeRackEquilibrationBuffer -> Object[Sample,"ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID], Output -> Options];
      Lookup[options, ProbeRackEquilibrationBuffer],
      ObjectP[Object[Sample,"ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, ProbeRackEquilibrationBuffer, "Automatically resolve the ProbeRackEquilibrationBuffer option if probe rack equilibration is requested:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], ProbeRackEquilibration -> True, Output -> Options];
      Lookup[options, ProbeRackEquilibrationBuffer],
      ObjectP[Model[Sample, StockSolution, "BLI Kinetics Buffer, 1X"]],
      Variables :> {options}
    ],
    Example[{Options, StartDelay, "Set the StartDelay to allow the assay plate to reach the desired temperature before starting the assay:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], StartDelay -> 20 Minute, Output -> Options];
      Lookup[options, StartDelay],
      20 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, StartDelay, "Automatically resolve the StartDelay to true if there is no equilibration step requested:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], Equilibrate -> False, Output -> Options];
      Lookup[options, StartDelay],
      15 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, StartDelayShake, "Set the StartDelayShake to indicate if the plate is shaken during the delay before the assay starts:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], StartDelayShake-> False, Output -> Options];
      Lookup[options, StartDelayShake],
      False,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, StartDelayShake, "Automatically resolve the StartDelayShake if a start delay is requested:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], StartDelay -> 20 Minute, Output -> Options];
      Lookup[options, StartDelayShake],
      True,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, Equilibrate, "Set the Equilibrate option to include an equilibrate step in which the probes are immersed in :"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], Equilibrate -> False, Output -> Options];
      Lookup[options, Equilibrate],
      False,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, Equilibrate, "Automatically resolve the Equilibrate option based on the value of ProbeRackEquilibration:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], ProbeRackEquilibration -> False, Output -> Options];
      Lookup[options, Equilibrate],
      True,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages:>{Warning::NoBLIProbeEquilibration}
    ],
    Example[{Options, EquilibrateTime, "Set the EquilibrateTime to dictate the amount of time that the probe will be immersed during the equilibrate step:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        EquilibrateTime -> 2 Minute,
        Output -> Options
      ];
      Lookup[options, EquilibrateTime],
      2 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, EquilibrateTime, "Automatically resolve the EquilibrateTime if Equilibrate is True:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        Equilibrate -> True,
        Output -> Options
      ];
      Lookup[options, EquilibrateTime],
      10 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, EquilibrateBuffer, "Set the EquilibrateBuffer option to indicate the solution which will be used in the equilibrate step:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        EquilibrateBuffer -> Model[Sample, StockSolution, "BLI Kinetics Buffer, 1X"],
        Output -> Options
      ];
      Lookup[options, EquilibrateBuffer],
      ObjectP[Model[Sample, StockSolution, "BLI Kinetics Buffer, 1X"]],
      Variables :> {options}
    ],
    Example[{Options, EquilibrateBuffer, "Automatically resolve the EquilibrateBuffer if Equilibrate is True:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], Equilibrate -> True, Output -> Options];
      Lookup[options, EquilibrateBuffer],
      ObjectP[Model[Sample, StockSolution, "BLI Kinetics Buffer, 1X"]],
      Variables :> {options}
    ],
    Example[{Options, EquilibrateShakeRate, "Set the EquilibrateShakeRate option to dictate the speed at which the plate is shaken during the equilibrate step:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], EquilibrateShakeRate -> 150 RPM, Output -> Options];
      Lookup[options, EquilibrateShakeRate],
      150 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, EquilibrateShakeRate, "Automatically resolve the EquilibrateShakeRate option if Equilibrate is True:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], Equilibrate -> True, Output -> Options];
      Lookup[options, EquilibrateShakeRate],
      1000 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, EquilibrateShakeRate, "Automatically resolve the EquilibrateShakeRate option if Equilibrate is True:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], Equilibrate -> False, Output -> Options];
      Lookup[options, EquilibrateShakeRate],
      Null,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DefaultBuffer, "Set the DefaultBuffer option to dictate the solution which is used as a buffer, baseline, or wash solution in the assay:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], DefaultBuffer -> Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID], Output -> Options];
      Lookup[options, DefaultBuffer],
      ObjectP[Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, ReuseSolution, "Set the ReuseSolution option to indicate groups of steps which may be performed in a common set of wells:"},
      options = ExperimentBioLayerInterferometry[{
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]
      },
        RegenerationType -> {Wash, Regenerate},
        RegenerationCycles -> 1, ReuseSolution -> {{Wash, MeasureBaseline}},
        Output -> Options];
      Lookup[options, ReuseSolution],
      {{Wash, MeasureBaseline}},
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages:>{Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, ReuseSolution, "Set the ReuseSolution option to indicate groups of steps which may be performed in a common set of wells:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ReuseSolution -> {{Wash}},
        Output -> Options];
      Lookup[options, ReuseSolution],
      {{Wash}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, ReuseSolution, "Set the ReuseSolution option to indicate groups of steps which may be performed in a common set of wells:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], ReuseSolution -> Null, Output -> Options];
      Lookup[options, ReuseSolution],
      Null,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, Blank, "Set the Blank option to indicate a solution that can be used as a blank or negative control, measured in parallel with the samples in:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], Blank -> Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID], Output -> Options];
      Lookup[options, Blank],
      ObjectP[Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, Blank, "Automatically resolve the Blank option based on if a blank or negative control is requested:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        KineticsReferenceType -> Blank, ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, Blank],
      ObjectP[Model[Sample, StockSolution, "BLI Kinetics Buffer, 1X"]],
      Variables :> {options}
    ],
    Example[{Options, Standard, "Set the Standard option to indicate a solution which can be used to create a standard curve, or is a positive control measured in parallel with the samples:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], Standard -> Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID], Output -> Options];
      Lookup[options, Standard],
      ObjectP[Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, DilutionMixVolume, "Set the DilutionMixVolume to indicate the amount of sample that will be in and out of a given dilution or premix solution:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]
        }, DilutionMixVolume -> 10 Microliter, Output -> Options];
      Lookup[options, DilutionMixVolume],
      10 Microliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DilutionNumberOfMixes, "Set the DilutionNumberOfMixes to indicate the number of cycles used to mix a given dilution or premix solution:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]
        }, DilutionNumberOfMixes -> 2, Output -> Options];
      Lookup[options, DilutionNumberOfMixes],
      2,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DilutionMixRate, "Set the DilutionMixRate option to indicate the rate at which DilutionMixVolume is pipetted:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]
        }, DilutionMixRate -> 100 Microliter/Second, Output -> Options];
      Lookup[options, DilutionMixRate],
      100 Microliter/Second,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (* --- Regeneration specific tests --- *)
    Example[{Options, RegenerationType, "Set the RegenerationType option to indicate the placement and types of steps used to return the probe surface to the measurement ready condition:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], RegenerationType -> {PreCondition, Wash, Neutralize, Regenerate}, Output -> Options];
      Lookup[options, RegenerationType],
      {PreCondition, Wash, Neutralize, Regenerate},
      Variables :> {options},
      Messages :> {Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, RegenerationSolution, "Set the RegenerationSolution option to indicate the solution in which the bio-probes will be immersed during a regeneration step:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        RegenerationSolution -> Object[Sample, "1.85 M NaOH for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        RegenerationType -> {Regenerate},
        Output -> Options];
      Lookup[options, RegenerationSolution],
      ObjectP[Object[Sample, "1.85 M NaOH for ExperimentBLI Test (20 mL)" <> $SessionUUID]],
      Variables :> {options},
      Messages :> {Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, RegenerationSolution, "Automatically resolve the RegenerationSolution option based on the RegenerationType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], RegenerationType -> {Regenerate, Neutralize}, Output -> Options];
      Lookup[options, RegenerationSolution],
      ObjectP[Model[Sample,StockSolution, "2 M HCl"]],
      Variables :> {options},
      Messages :> {Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, RegenerationCycles, "Set the RegenerationCycles option to dictate the number of times the regeneration sequence will be repeated in between each measurement set:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        RegenerationCycles -> 5,
        RegenerationType -> {Regenerate},
        Output -> Options
      ];
      Lookup[options, RegenerationCycles],
      5,
      Variables :> {options},
      Messages :> {Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, RegenerationCycles, "Automatically resolve the RegenerationCycles option based on the value of RegeneartionType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        RegenerationType -> {Regenerate, Neutralize},
        Output -> Options];
      Lookup[options, RegenerationCycles],
      3,
      Variables :> {options},
      Messages :> {Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, RegenerationTime, "Set the RegenerationTime option to dictate the amount of time the probe will be immersed in RegenerationSolution per each cycle:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        RegenerationType -> {Regenerate},
        RegenerationTime -> 10 Second,
        Output -> Options];
      Lookup[options, RegenerationTime],
      10 Second,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, RegenerationTime, "Automatically resolve the RegenerationTime option based on RegenerationType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        RegenerationType -> {Regenerate, Neutralize, Wash, PreCondition},
        Output -> Options];
      Lookup[options, RegenerationTime],
      5 Second,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, RegenerationShakeRate, "Set the RegenerationShakeRate option to dictate the plate shaking rate during a regeneration step:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        RegenerationType -> {Regenerate},
        RegenerationShakeRate -> 150 RPM, Output -> Options];
      Lookup[options, RegenerationShakeRate],
      150 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, RegenerationShakeRate, "Automatically resolve the RegenerationShakeRate option based on RegenerationType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        RegenerationType -> {Regenerate, Neutralize, Wash, PreCondition}, Output -> Options];
      Lookup[options, RegenerationShakeRate],
      1000 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, NeutralizationSolution, "Set the NeutralizationSolution option to indicate the solution in which the bio-probes will be immersed during a neutralization step:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        RegenerationType -> {Regenerate, Neutralize},
        NeutralizationSolution -> Object[Sample,"ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
        Output -> Options];
      Lookup[options, NeutralizationSolution],
      ObjectP[Object[Sample,"ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID]],
      Variables :> {options},
      Messages :> {Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, NeutralizationSolution, "Automatically resolve the NeutralizationSolution option based on the RegenerationType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        RegenerationType -> {Regenerate, Neutralize},
        Output -> Options];
      Lookup[options, NeutralizationSolution],
      ObjectP[Model[Sample, StockSolution, "BLI Kinetics Buffer, 1X"]],
      Variables :> {options},
      Messages :> {Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, NeutralizationTime, "Set the NeutralizationTime option to dictate the amount of time the probe will be immersed in NeutralizationSolution per each cycle:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        RegenerationType -> {Neutralize, Regenerate},
        NeutralizationTime -> 10 Second, Output -> Options];
      Lookup[options, NeutralizationTime],
      10 Second,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, NeutralizationTime, "Automatically resolve the NeutralizationTime option based on RegenerationType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        RegenerationType -> {Regenerate, Neutralize, Wash, PreCondition}, Output -> Options];
      Lookup[options, NeutralizationTime],
      5 Second,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, NeutralizationShakeRate, "Set the NeutralizationShakeRate option to dictate the plate shaking rate during a neutralization step:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        RegenerationType -> {Regenerate, Neutralize},
        NeutralizationShakeRate -> 150 RPM, Output -> Options];
      Lookup[options, NeutralizationShakeRate],
      150 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, NeutralizationShakeRate, "Automatically resolve the NeutralizationShakeRate option based on RegenerationType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        RegenerationType -> {Regenerate, Neutralize, Wash, PreCondition}, Output -> Options];
      Lookup[options, NeutralizationShakeRate],
      1000 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {Warning::UnneededBLIProbeRegeneration}
    ],

    Example[{Options, WashSolution, "Set the WashSolution option to indicate the solution in which the bio-probes will be immersed during a wash step:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        RegenerationType -> {Regenerate, Wash},
        WashSolution -> Object[Sample,"ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
        Output -> Options];
      Lookup[options, WashSolution],
      ObjectP[Object[Sample,"ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID]],
      Variables :> {options},
      Messages :> {Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, WashSolution, "Automatically resolve the WashSolution option based on the RegenerationType:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        RegenerationType -> {Regenerate, Neutralize, Wash}, Output -> Options];
      Lookup[options, WashSolution],
      ObjectP[Model[Sample, StockSolution, "BLI Kinetics Buffer, 1X"]],
      Variables :> {options},
      Messages :> {Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, WashTime, "Set the WashTime option to dictate the amount of time the probe will be immersed in WashSolution per each cycle:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        RegenerationType->{Regenerate, Wash},
        WashTime -> 10 Second,
        Output -> Options
      ];
      Lookup[options, WashTime],
      10 Second,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, WashTime, "Automatically resolve the WashTime option based on RegenerationType:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        RegenerationType -> {Regenerate, Neutralize, Wash, PreCondition},
        Output -> Options
      ];
      Lookup[options, WashTime],
      5 Second,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, WashShakeRate, "Set the WashShakeRate option to dictate the plate shaking rate during a neutralization step:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        RegenerationType -> {Regenerate, Neutralize, Wash},
        WashShakeRate -> 150 RPM, Output -> Options];
      Lookup[options, WashShakeRate],
      150 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, WashShakeRate, "Automatically resolve the WashShakeRate option based on RegenerationType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        RegenerationType -> {Regenerate, Neutralize, Wash, PreCondition}, Output -> Options];
      Lookup[options, WashShakeRate],
      1000 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {Warning::UnneededBLIProbeRegeneration}
    ],



    (* --- Loading specific tests --- *)

    Example[{Options, LoadingType, "Set the LoadingType to indicate the steps that are included in a probe loading sequence:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        ActivateSolution -> Object[Sample,"ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
        QuenchSolution -> Object[Sample,"ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID],
        LoadingType -> {Load, Activate, Quench}, Output -> Options];
      Lookup[options, LoadingType],
      {Load, Activate, Quench},
      Variables :> {options}
    ],
    Example[{Options, LoadSolution, "Set the LoadSolution to indicate the solution used to functionalize the probe surface:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        LoadingType -> {Load},
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, LoadSolution],
      ObjectP[Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, LoadShakeRate, "Set the LoadShakeRate option to dictate the plate shaking rate during a load step:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        LoadingType -> {Load},
        LoadShakeRate -> 150 RPM,
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, LoadShakeRate],
      150 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, LoadShakeRate, "Automatically resolve the LoadShakeRate option based on LoadingType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        LoadingType -> {Load}, Output -> Options];
      Lookup[options, LoadShakeRate],
      1000 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, LoadTime, "Set the LoadTime option to dictate the amount of time the probe will be immersed in LoadSolution:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        LoadingType -> {Load}, LoadTime -> 10 Second, Output -> Options];
      Lookup[options, LoadTime],
      10 Second,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, LoadTime, "Automatically resolve the LoadTime option based on LoadingType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        LoadingType -> {Load}, Output -> Options];
      Lookup[options, LoadTime],
      15 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, LoadThresholdCriterion, "Set the LoadThresholdCriterion option to dictate if every well or a single well must meet the threshold condition:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        LoadingType -> {Load},
        LoadThresholdCriterion -> All, Output -> Options];
      Lookup[options, LoadThresholdCriterion],
      All,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, LoadThresholdCriterion, "Automatically resolve the LoadThresholdCriterion option based on the population of other loading parameters:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        LoadingType -> {Load},
        LoadAbsoluteThreshold -> 0.4 Nanometer, Output -> Options];
      Lookup[options, LoadThresholdCriterion],
      Single,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, LoadAbsoluteThreshold, "Set the LoadAbsoluteThreshold option to dictate the change in thickness required to begin the next assay step:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        LoadingType -> {Load},
        LoadAbsoluteThreshold -> 10.0*Nanometer, Output -> Options];
      Lookup[options, LoadAbsoluteThreshold],
      10*Nanometer,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, LoadThresholdSlope, "Set the LoadThresholdSlope option to dictate the rate of change in thickness required to begin the next assay step:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        LoadingType -> {Load},
        LoadThresholdSlope -> 0.01*Nanometer/Second, LoadThresholdSlopeDuration -> 2 Minute, Output -> Options];
      Lookup[options, LoadThresholdSlope],
      0.01*Nanometer/Second,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, LoadThresholdSlopeDuration, "Set the LoadThresholdSlopeDuration option to dictate the amount of time for which the LoadThreholdSlope condition must be met to begin the next assay step:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        LoadThresholdSlopeDuration -> 1.0*Minute, LoadThresholdSlope -> 0.5 Nanometer/Minute, LoadingType -> {Load}, Output -> Options];
      Lookup[options, LoadThresholdSlopeDuration],
      1*Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, ActivateSolution, "Set the ActivateSolution to indicate the solution used to activate the probe surface prior to loading:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        ActivateSolution -> Object[Sample,"ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
        LoadingType -> {Load, Activate},
        Output -> Options];
      Lookup[options, ActivateSolution],
      ObjectP[Object[Sample,"ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, ActivateShakeRate, "Set the ActivateShakeRate option to dictate the plate shaking rate during a activate step:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        ActivateSolution -> Object[Sample,"ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID],
        LoadingType -> {Load, Activate},
        ActivateShakeRate -> 150 RPM, Output -> Options];
      Lookup[options, ActivateShakeRate],
      150 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, ActivateShakeRate, "Automatically resolve the ActivateShakeRate option based on LoadingType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        ActivateSolution -> Object[Sample,"ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID],
        LoadingType -> {Load, Activate}, Output -> Options];
      Lookup[options, ActivateShakeRate],
      1000 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, ActivateTime, "Set the ActivateTime option to dictate the amount of time the probe will be immersed in ActivateSolution:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        ActivateSolution -> Object[Sample,"ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID],
        LoadingType -> {Load, Activate},
        ActivateTime -> 10 Second, Output -> Options];
      Lookup[options, ActivateTime],
      10 Second,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, ActivateTime, "Automatically resolve the ActivateTime option based on LoadingType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        ActivateSolution -> Object[Sample,"ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID],
        LoadingType -> {Load, Activate}, Output -> Options];
      Lookup[options, ActivateTime],
      1 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, QuenchSolution, "Set the ActivateSolution to indicate the solution used to passivate unreacted sites after loading:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        QuenchSolution -> Object[Sample,"ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
        LoadingType -> {Load,Quench},
        Output -> Options];
      Lookup[options, QuenchSolution],
      ObjectP[Object[Sample,"ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, QuenchShakeRate, "Set the QuenchShakeRate option to dictate the plate shaking rate during a activate step:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        QuenchSolution -> Object[Sample,"ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
        QuenchShakeRate -> 150 RPM, LoadingType -> {Load,Quench}, Output -> Options];
      Lookup[options, QuenchShakeRate],
      150 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, QuenchShakeRate, "Automatically resolve the QuenchShakeRate option based on LoadingType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        QuenchSolution -> Object[Sample,"ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
        LoadingType -> {Load, Quench}, Output -> Options];
      Lookup[options, QuenchShakeRate],
      1000 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, QuenchTime, "Set the QuenchTime option to dictate the amount of time the probe will be immersed in QuenchSolution:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        QuenchSolution -> Object[Sample,"ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
        QuenchTime -> 10 Second, LoadingType -> {Load, Quench}, Output -> Options];
      Lookup[options, QuenchTime],
      10 Second,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, QuenchTime, "Automatically resolve the QuenchTime option based on LoadingType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        QuenchSolution -> Object[Sample,"ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
        LoadingType -> {Load, Quench}, Output -> Options];
      Lookup[options, QuenchTime],
      1 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (* ------------------------------------------------------- *)
    (* --- EXPERIMENT SPECIFIC OPTIONS - NON INDEX MATCHED --- *)
    (* ------------------------------------------------------- *)

    (* --- KINETICS --- *)
    Example[{Options, KineticsBaselineBuffer, "Automatically resolve the KineticsBaselineBuffer option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, KineticsBaselineBuffer],
      ObjectP[Model[Sample, StockSolution, "BLI Kinetics Buffer, 1X"]],
      Variables :> {options}
    ],
    Example[{Options, KineticsDissociationBuffer, "Automatically resolve the KineticsDissociationBuffer option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        ExperimentType -> Kinetics, Output -> Options];
      Lookup[options, KineticsDissociationBuffer],
      ObjectP[Model[Sample, StockSolution, "BLI Kinetics Buffer, 1X"]],
      Variables :> {options}
    ],
    Example[{Options, KineticsBaselineBuffer, "Set the KineticsBaselineBuffer option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        KineticsBaselineBuffer -> Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, KineticsBaselineBuffer],
      ObjectP[Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, KineticsDissociationBuffer, "Automatically resolve the KineticsDissociationBuffer option based on the value of the:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        KineticsDissociationBuffer -> Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, KineticsDissociationBuffer],
      ObjectP[Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, MeasureBaselineTime, "Automatically resolve the MeasureDissociationTime option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        ExperimentType -> Kinetics, Output -> Options];
      Lookup[options, MeasureBaselineTime],
      30 Second,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, MeasureBaselineTime, "Set the MeasureBaselineTime option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        ExperimentType -> Kinetics, MeasureBaselineTime -> 1 Minute, Output -> Options];
      Lookup[options, MeasureBaselineTime],
      1 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    (*special test for pre-qual experiment call*)
    Example[{Options, ExpandedAssaySequencePrimitives, "Run a standard kinetics assay:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics, BioProbeType -> Model[Item, BLIProbe, "SA"], DefaultBuffer -> Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID], PlateCover -> True, ProbeRackEquilibration -> True,
        MeasureAssociationTime -> 8 Minute, MeasureDissociationTime -> 15 Minute, KineticsSampleSerialDilutions -> {{2,{"dilution 1", "dilution 2", "dilution 3", "dilution 4", "dilution 5", "dilution 6", "dilution 7"}}}, KineticsReferenceType -> Blank,
        LoadSolution -> Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID], LoadTime -> 4 Minute, LoadShakeRate -> 1000 RPM, LoadingType -> {Load}, Output-> Options
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {{LoadSurface[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]}},
      EquivalenceFunction -> MatchQ,
      Variables :> {options},
      Messages :> {Warning::BLIPlateCoverNotRecommended}
    ],



    (* ---------------------------------------- *)
    (* --- QUANTITATION - NON INDEX MATCHED --- *)
    (* ---------------------------------------- *)

    Example[{Options, QuantitationStandard, "Automatically resolve the QuantitationStandard option based on ExperimentType and the value of Standard:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation, Standard -> Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID], QuantitationParameters -> {StandardWell}, Output -> Options];
      Lookup[options, QuantitationStandard],
      ObjectP[Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, QuantitationStandard, "Set the QuantitationStandard option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation,
        QuantitationParameters -> {StandardWell},
        QuantitationStandard -> Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
        Output -> Options];
      Lookup[options, QuantitationStandard],
      ObjectP[Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, QuantitationStandardWell, "Automatically resolve the QuantitationStandardWell option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation, QuantitationParameters -> {StandardWell}, Standard -> Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID], Output -> Options];
      Lookup[options, QuantitationStandardWell],
      ObjectP[Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, QuantitationStandardWell, "Set the QuantitationStandardWell option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation, QuantitationParameters -> {StandardWell}, QuantitationStandardWell -> Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID], Output -> Options];
      Lookup[options, QuantitationStandardWell],
      ObjectP[Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, QuantitateTime, "Automatically resolve the QuantitateTime option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation, Output -> Options];
      Lookup[options, QuantitateTime],
      5 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, QuantitateTime, "Set the QuantitateTime option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation, QuantitateTime -> 20 Minute, Output -> Options];
      Lookup[options, QuantitateTime],
      20 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, QuantitateShakeRate, "Automatically resolve the QuantitateShakeRate option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation, Output -> Options];
      Lookup[options, QuantitateShakeRate],
      1000 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, QuantitateShakeRate, "Set the QuantitateShakeRate option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation, QuantitateShakeRate -> 500 RPM, Output -> Options];
      Lookup[options, QuantitateShakeRate],
      500 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, AmplifiedDetectionTime, "Automatically resolve the AmplifiedDetectionTime option based on ExperimentType and QuantitationParameters:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation,
        QuantitationParameters -> {AmplifiedDetection},
        AmplifiedDetectionSolution -> Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, AmplifiedDetectionTime],
      5 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, AmplifiedDetectionTime, "Set the AmplifiedDetectionTime option:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation,
        QuantitationParameters -> {AmplifiedDetection},
        AmplifiedDetectionTime -> 10 Minute,
        AmplifiedDetectionSolution -> Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
        Output -> Options];
      Lookup[options, AmplifiedDetectionTime],
      10 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, AmplifiedDetectionShakeRate, "Automatically resolve the AmplifiedDetectionShakeRate option based on ExperimentType and QuantitationParameters:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation,
        QuantitationParameters -> {AmplifiedDetection},
        AmplifiedDetectionSolution -> Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
        Output -> Options];
      Lookup[options, AmplifiedDetectionShakeRate],
      1000 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, AmplifiedDetectionShakeRate, "Set the AmplifiedDetectionShakeRate option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation,
        QuantitationParameters -> {AmplifiedDetection},
        AmplifiedDetectionSolution -> Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        AmplifiedDetectionShakeRate -> 500 RPM,
        Output -> Options];
      Lookup[options, AmplifiedDetectionShakeRate],
      500 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, QuantitationEnzymeBuffer, "Automatically resolve the QuantitationEnzymeBuffer option based on ExperimentType and QuantitationParameters:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation,
        AmplifiedDetectionSolution -> Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
        QuantitationEnzymeSolution -> Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID],
        QuantitationParameters -> {EnzymeLinked, AmplifiedDetection},
        Output -> Options
      ];
      Lookup[options, QuantitationEnzymeBuffer],
      ObjectP[Model[Sample, StockSolution, "BLI Kinetics Buffer, 1X"]],
      Variables :> {options}
    ],
    Example[{Options, QuantitationEnzymeBuffer, "Set the QuantitationEnzymeBuffer option:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation,
        QuantitationParameters -> {EnzymeLinked, AmplifiedDetection},
        AmplifiedDetectionSolution -> Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
        QuantitationEnzymeSolution -> Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID],
        QuantitationEnzymeBuffer -> Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, QuantitationEnzymeBuffer],
      ObjectP[Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, QuantitationEnzymeShakeRate, "Automatically resolve the QuantitationEnzymeShakeRate option based on ExperimentType and QuantitationParameters:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation,
        QuantitationParameters -> {EnzymeLinked, AmplifiedDetection},
        AmplifiedDetectionSolution -> Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
        QuantitationEnzymeSolution -> Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID],
        Output -> Options];
      Lookup[options, QuantitationEnzymeShakeRate],
      1000 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, QuantitationEnzymeShakeRate, "Set the QuantitationEnzymeShakeRate option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation,
        QuantitationParameters -> {AmplifiedDetection, EnzymeLinked},
        AmplifiedDetectionSolution -> Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
        QuantitationEnzymeSolution -> Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID],
        QuantitationEnzymeShakeRate -> 500 RPM,
        Output -> Options];
      Lookup[options, QuantitationEnzymeShakeRate],
      500 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, QuantitationEnzymeTime, "Automatically resolve the QuantitationEnzymeTime option based on ExperimentType and QuantitationParameters:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation,
        QuantitationParameters -> {AmplifiedDetection, EnzymeLinked},
        AmplifiedDetectionSolution -> Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
        QuantitationEnzymeSolution -> Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID],
        Output -> Options];
      Lookup[options, QuantitationEnzymeTime],
      5 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, QuantitationEnzymeTime, "Set the QuantitationEnzymeTime option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation,
        QuantitationParameters -> {AmplifiedDetection, EnzymeLinked},
        AmplifiedDetectionSolution -> Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
        QuantitationEnzymeSolution -> Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID],
        QuantitationEnzymeTime -> 1 Minute, Output -> Options];
      Lookup[options, QuantitationEnzymeTime],
      1 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, QuantitationStandardDiluent, "Automatically resolve the QuantitationStandardDiluent option based on ExperimentType and QuantitationParameters:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation,
        QuantitationStandard -> Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
        QuantitationParameters -> {StandardCurve},
        Output -> Options
      ];
      Lookup[options, QuantitationStandardDiluent],
      ObjectP[Model[Sample, StockSolution, "BLI Kinetics Buffer, 1X"]],
      Variables :> {options}
    ],
    Example[{Options, QuantitationStandardDiluent, "Set the QuantitationStandardDiluent option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation,
        QuantitationStandard -> Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
        QuantitationParameters -> {StandardCurve},
        QuantitationStandardDiluent -> Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
        Output -> Options];
      Lookup[options, QuantitationStandardDiluent],
      ObjectP[Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, QuantitationStandardFixedDilutions, "Automatically resolve the QuantitationStandardFixedDilutions option based on ExperimentType and QuantitationParameters:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation,
        QuantitationStandard -> Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
        QuantitationParameters -> {StandardCurve},
        Output -> Options
      ];
      Lookup[options, QuantitationStandardFixedDilutions],
      {
        {2, "2x standard dilution"},
        {4, "4x standard dilution"},
        {8, "8x standard dilution"},
        {16, "16x standard dilution"},
        {32, "32x standard dilution"},
        {64, "64x standard dilution"},
        {128, "128x standard dilution"}
      },
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, QuantitationStandardFixedDilutions, "Set the QuantitationStandardFixedDilutions option:"},
      options = ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation,
        QuantitationParameters -> {StandardCurve},
        QuantitationStandard -> Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
        QuantitationStandardFixedDilutions -> {{2,"101"},{4, "102"},{6, "103"},{8, "104"},{10, "105"}},
        Output -> Options
      ];
      Lookup[options, QuantitationStandardFixedDilutions],
      {{2,"101"},{4, "102"},{6, "103"},{8, "104"},{10, "105"}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (* ------------------------------------------ *)
    (* --- EPITOPEBINNING - NON INDEX MATCHED --- *)
    (* ------------------------------------------ *)

    Example[{Options, BinningType, "Automatically resolve the BinningType option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning,
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, BinningType],
      Sandwich,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, BinningType, "Set the BinningType option:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning, BinningType -> Tandem,
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, BinningType],
      Tandem,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, BinningControlWell, "Automatically resolve the BinningControlWell option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning,
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, BinningControlWell],
      False,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, BinningControlWell, "Set the BinningControlWell option:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        BinningControlWell -> True,
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        Output -> Options];
      Lookup[options, BinningControlWell],
      True,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (*load antibody parameters*)
    Example[{Options, LoadAntibodyTime, "Automatically resolve the LoadAntibodyTime option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], Output -> Options];
      Lookup[options, LoadAntibodyTime],
      10 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, LoadAntibodyTime, "Set the LoadAntibodyTime option:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning, LoadAntibodyTime -> 20 Minute,
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, LoadAntibodyTime],
      20 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, LoadAntibodyShakeRate, "Automatically resolve the LoadAntibodyShakeRate option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        Output -> Options];
      Lookup[options, LoadAntibodyShakeRate],
      1000 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, LoadAntibodyShakeRate, "Set the LoadAntibodyShakeRate option:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning, LoadAntibodyShakeRate -> 500 RPM,
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, LoadAntibodyShakeRate],
      500 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, LoadAntibodyThresholdCriterion, "Automatically resolve the LoadAntibodyThresholdCriterion option based on ExperimentType and the value of LoadAntibodyAbsoluteThreshold and LoadAntibodyThresholdSlope:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        LoadAntibodyAbsoluteThreshold -> 0.5 Nanometer,
        ExperimentType -> EpitopeBinning, BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, LoadAntibodyThresholdCriterion],
      All,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, LoadAntibodyAbsoluteThreshold, "Set the LoadAntibodyAbsoluteThreshold option:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        LoadAntibodyAbsoluteThreshold -> 0.5 Nanometer,
        ExperimentType -> EpitopeBinning, BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, LoadAntibodyAbsoluteThreshold],
      0.5 Nanometer,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, LoadAntibodyThresholdSlope, "Set the LoadAntibodyThresholdSlope option:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        LoadAntibodyThresholdSlope -> 3 Nanometer/Minute,
        LoadAntibodyThresholdSlopeDuration -> 1 Minute,
        ExperimentType -> EpitopeBinning, BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, LoadAntibodyThresholdSlope],
      3 Nanometer/Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, LoadAntibodyThresholdSlopeDuration, "Set the LoadAntibodyThresholdSlopeDuration option:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        LoadAntibodyThresholdSlope -> 3 Nanometer/Minute,
        LoadAntibodyThresholdSlopeDuration -> 1 Minute,
        ExperimentType -> EpitopeBinning, BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, LoadAntibodyThresholdSlopeDuration],
      1 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, LoadAntibodyThresholdCriterion, "Set the LoadAntibodyThresholdCriterion option:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning, LoadAntibodyThresholdCriterion -> Single,
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, LoadAntibodyThresholdCriterion],
      Single,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (*binning quench parameters*)
    Example[{Options, BinningQuenchTime, "Automatically resolve the BinningQuenchTime option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning, BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, BinningQuenchTime],
      5 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, BinningAntigen, "Set BinningAntigen option:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning, BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, BinningAntigen],
     ObjectP[Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID]],
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],
    Example[{Options, BinningQuenchSolution, "Set the BinningQuenchSolution option:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning,
        BinningQuenchTime -> 20 Minute,
        BinningQuenchSolution -> Object[Sample,"ExperimentBLI New Test Chemical 5 (20 mL)" <> $SessionUUID],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, BinningQuenchSolution],
      ObjectP[Object[Sample,"ExperimentBLI New Test Chemical 5 (20 mL)" <> $SessionUUID]],
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],
    Example[{Options, BinningQuenchTime, "Set the BinningQuenchTime option:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning,
        BinningQuenchTime -> 20 Minute,
        BinningQuenchSolution -> Object[Sample,"ExperimentBLI New Test Chemical 5 (20 mL)" <> $SessionUUID],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, BinningQuenchTime],
      20 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, BinningQuenchShakeRate, "Automatically resolve the BinningQuenchShakeRate option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning,
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, BinningQuenchShakeRate],
      1000 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, BinningQuenchShakeRate, "Set the BinningQuenchShakeRate option:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning,
        BinningQuenchShakeRate -> 500 RPM,
        BinningQuenchSolution -> Object[Sample,"ExperimentBLI New Test Chemical 5 (20 mL)" <> $SessionUUID],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, BinningQuenchShakeRate],
      500 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (*LoadAntigen parameters*)
    Example[{Options, LoadAntigenTime, "Automatically resolve the LoadAntigenTime option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], Output -> Options];
      Lookup[options, LoadAntigenTime],
      10 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, LoadAntigenTime, "Set the BinningQuenchTime option:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning, LoadAntigenTime -> 20 Minute,
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, LoadAntigenTime],
      20 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, LoadAntigenShakeRate, "Automatically resolve the LoadAntigenShakeRate option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], Output -> Options];
      Lookup[options, LoadAntigenShakeRate],
      1000 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, LoadAntigenShakeRate, "Set the LoadAntigenShakeRate option:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning, LoadAntigenShakeRate -> 500 RPM,
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, LoadAntigenShakeRate],
      500 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, LoadAntigenAbsoluteThreshold, "Set LoadAntigenAbsoluteThreshold options:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        LoadAntigenAbsoluteThreshold -> 0.5 Nanometer,
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], Output -> Options];
      Lookup[options, LoadAntigenAbsoluteThreshold],
      0.5 Nanometer,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, LoadAntigenThresholdSlope, "Set LoadAntigenThresholdSlope options:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        LoadAntigenThresholdSlope -> 3 Nanometer/Minute,
        LoadAntigenThresholdSlopeDuration -> 1 Minute,
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], Output -> Options];
      Lookup[options, LoadAntigenThresholdSlope],
      3 Nanometer/Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, LoadAntigenThresholdSlopeDuration, "Set LoadAntigenThresholdSlopeDuration options:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        LoadAntigenThresholdSlope -> 3 Nanometer/Minute,
        LoadAntigenThresholdSlopeDuration -> 1 Minute,
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], Output -> Options];
      Lookup[options, LoadAntigenThresholdSlopeDuration],
      1 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, LoadAntigenThresholdCriterion, "Automatically resolve the LoadAntigenThresholdCriterion option based on ExperimentType and the value of LoadAntigenAbsoluteThreshold and LoadAntigenThresholdSlope:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        LoadAntigenAbsoluteThreshold -> 0.5 Nanometer,
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], Output -> Options];
      Lookup[options, LoadAntigenThresholdCriterion],
      All,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, LoadAntigenThresholdCriterion, "Set the LoadAntigenThresholdCriterion option:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        LoadAntigenThresholdCriterion -> Single,
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],  Output -> Options];
      Lookup[options, LoadAntigenThresholdCriterion],
      Single,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (* CompetitionBaseline parameters*)
    Example[{Options, CompetitionBaselineBuffer, "Automatically resolve the CompetitionBaselineBuffer option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], Output -> Options];
      Lookup[options, CompetitionBaselineBuffer],
      ObjectP[Model[Sample, StockSolution, "BLI Kinetics Buffer, 1X"]],
      Variables :> {options}
    ],
    Example[{Options, CompetitionBaselineBuffer, "Set the CompetitionBaselineBuffer option:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        CompetitionBaselineBuffer -> Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],  Output -> Options];
      Lookup[options, CompetitionBaselineBuffer],
      ObjectP[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, CompetitionBaselineTime, "Automatically resolve the CompetitionBaselineTime option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], Output -> Options];
      Lookup[options, CompetitionBaselineTime],
      30 Second,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, CompetitionBaselineTime, "Set the CompetitionBaselineTime option:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        CompetitionBaselineTime -> 20 Second,
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],  Output -> Options];
      Lookup[options, CompetitionBaselineTime],
      20 Second,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, CompetitionBaselineShakeRate, "Automatically resolve the CompetitionBaselineShakeRate option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], Output -> Options];
      Lookup[options, CompetitionBaselineShakeRate],
      1000 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, CompetitionBaselineShakeRate, "Set the CompetitionBaselineShakeRate option:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        CompetitionBaselineShakeRate -> 500 RPM,
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],  Output -> Options];
      Lookup[options, CompetitionBaselineShakeRate],
      500 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (* Competition step parameters*)
    Example[{Options, CompetitionTime, "Automatically resolve the CompetitionTime option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], Output -> Options];
      Lookup[options, CompetitionTime],
      10 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, CompetitionTime, "Set the CompetitionTime option:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        CompetitionTime -> 20 Minute,
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],  Output -> Options];
      Lookup[options, CompetitionTime],
      20 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, CompetitionShakeRate, "Automatically resolve the CompetitionShakeRate option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], Output -> Options];
      Lookup[options, CompetitionShakeRate],
      1000 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, CompetitionShakeRate, "Set the CompetitionShakeRate option:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning, CompetitionShakeRate -> 500 RPM,
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, CompetitionShakeRate],
      500 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, CompetitionThresholdCriterion, "Automatically resolve the CompetitionThresholdCriterion option based on ExperimentType and the value of LoadAntigenAbsoluteThreshold and LoadAntigenThresholdSlope:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        CompetitionAbsoluteThreshold -> 0.5 Nanometer,
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], Output -> Options];
      Lookup[options, CompetitionThresholdCriterion],
      All,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, CompetitionAbsoluteThreshold, "Set the CompetitionAbsoluteThreshold options:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        CompetitionAbsoluteThreshold -> 0.5 Nanometer,
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], Output -> Options];
      Lookup[options, CompetitionAbsoluteThreshold],
      0.5 Nanometer,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, CompetitionThresholdSlope, "Set the CompetitionThresholdSlope options:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        CompetitionThresholdSlope -> 3 Nanometer/Minute,
        CompetitionThresholdSlopeDuration -> 1 Minute,
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], Output -> Options];
      Lookup[options, CompetitionThresholdSlope],
      3 Nanometer/Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, CompetitionThresholdSlopeDuration, "Set the CompetitionThresholdSlopeDuration options:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        CompetitionThresholdSlope -> 3 Nanometer/Minute,
        CompetitionThresholdSlopeDuration -> 1 Minute,
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], Output -> Options];
      Lookup[options, CompetitionThresholdSlopeDuration],
      1 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, CompetitionThresholdCriterion, "Set the CompetitionThresholdCriterion option:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        CompetitionThresholdCriterion -> Single,
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],  Output -> Options];
      Lookup[options, CompetitionThresholdCriterion],
      Single,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (*premix diluent*)
    Example[{Options, PreMixDiluent, "Automatically resolve the PreMixDiluent option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], Output -> Options];
      Lookup[options, PreMixDiluent],
      ObjectP[Model[Sample, StockSolution, "BLI Kinetics Buffer, 1X"]],
      Variables :> {options}
    ],
    Example[{Options, PreMixDiluent, "Set the PreMixDiluent option:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        BinningType -> PreMix,
        PreMixDiluent -> Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        Output -> Options];
      Lookup[options, PreMixDiluent],
      ObjectP[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID]],
      Variables :> {options}
    ],

    (* -------------------------------------------- *)
    (* --- ASSAYDEVELOPMENT - NON INDEX MATCHED --- *)
    (* -------------------------------------------- *)

    (*set the AssayDevelopment Type*)
    Example[{Options, DevelopmentType, "Automatically resolve the DevelopmentType option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        ExperimentType -> AssayDevelopment, Output -> Options];
      Lookup[options, DevelopmentType],
      ScreenDetectionLimit,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    (*TODO: it may be worth putting soem more complicated tests in here to deal with the new index matchign scheme*)
    Example[{Options, DevelopmentType, "Set the DevelopmentType option:"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> AssayDevelopment,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        LoadingType -> {Load},
        DevelopmentType -> ScreenInteraction,
        LoadTime -> 10 Minute, LoadShakeRate -> 1000 RPM,
        TestInteractionSolutions ->
            {
              Object[Sample,"ExperimentBLI New Test Chemical 5 (20 mL)" <> $SessionUUID],
              Object[Sample,"ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID],
              Object[Sample,"ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
              Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID]
            },
        Output -> Options];
      Lookup[options, DevelopmentType],
      ScreenInteraction,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DevelopmentReferenceWell, "Set DevelopmentReferenceWell option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        ExperimentType -> AssayDevelopment,
        DevelopmentReferenceWell -> Standard,
        Standard -> Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
        Output -> Options];
      Lookup[options, DevelopmentReferenceWell],
      Standard,
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],

    (* parameters for DevelopmentBaseline *)
    Example[{Options, DevelopmentBaselineTime, "Automatically resolve the DevelopmentBaselineTime option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, DevelopmentBaselineTime],
      30 Second,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DevelopmentBaselineTime, "Set the DevelopmentBaselineTime option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        DevelopmentBaselineTime -> 20 Minute,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, DevelopmentBaselineTime],
      20 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DevelopmentBaselineShakeRate, "Automatically resolve the DevelopmentBaselineShakeRate option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, DevelopmentBaselineShakeRate],
      1000 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DevelopmentBaselineShakeRate, "Set the DevelopmentBaselineShakeRate option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        DevelopmentBaselineShakeRate -> 500 RPM, Output -> Options];
      Lookup[options, DevelopmentBaselineShakeRate],
      500 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (* parameters for DevelopmentAssociation *)
    Example[{Options, DevelopmentAssociationTime, "Automatically resolve the DevelopmentAssociationTime option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, DevelopmentAssociationTime],
      15 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DevelopmentAssociationTime, "Set the DevelopmentAssociationTime option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        DevelopmentAssociationTime -> 20 Minute, Output -> Options];
      Lookup[options, DevelopmentAssociationTime],
      20 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DevelopmentAssociationShakeRate, "Automatically resolve the DevelopmentAssociationShakeRate option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, DevelopmentAssociationShakeRate],
      1000 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DevelopmentAssociationShakeRate, "Set the DevelopmentAssociationShakeRate option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        DevelopmentAssociationShakeRate -> 500 RPM,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, DevelopmentAssociationShakeRate],
      500 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DevelopmentAssociationThresholdCriterion, "Automatically resolve the DevelopmentAssociationThresholdCriterion option based on ExperimentType and the value of DevelopmentAbsoluteThreshold and DevelopmentThresholdSlope:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        DevelopmentAssociationAbsoluteThreshold -> 0.5 Nanometer,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        ExperimentType -> AssayDevelopment, Output -> Options];
      Lookup[options, DevelopmentAssociationThresholdCriterion],
      All,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DevelopmentAssociationThresholdCriterion, "Set the DevelopmentAssociationThresholdCriterion option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        DevelopmentAssociationThresholdCriterion -> Single, Output -> Options];
      Lookup[options, DevelopmentAssociationThresholdCriterion],
      Single,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DevelopmentAssociationAbsoluteThreshold, "Set the DevelopmentAssociationAbsoluteThreshold option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        DevelopmentAssociationAbsoluteThreshold -> 0.5 Nanometer,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        ExperimentType -> AssayDevelopment, Output -> Options];
      Lookup[options, DevelopmentAssociationAbsoluteThreshold],
      0.5 Nanometer,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DevelopmentAssociationThresholdSlope, "Set the DevelopmentAssociationThresholdSlope option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        DevelopmentAssociationThresholdSlope -> 5 Nanometer/Minute,
        DevelopmentAssociationThresholdSlopeDuration -> 1 Minute,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        ExperimentType -> AssayDevelopment, Output -> Options];
      Lookup[options, DevelopmentAssociationThresholdSlope],
      5 Nanometer/Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DevelopmentAssociationThresholdSlopeDuration, "Set the DevelopmentAssociationThresholdSlopeDuration option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        DevelopmentAssociationThresholdSlope -> 5 Nanometer/Minute,
        DevelopmentAssociationThresholdSlopeDuration -> 1 Minute,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        ExperimentType -> AssayDevelopment, Output -> Options];
      Lookup[options, DevelopmentAssociationThresholdSlopeDuration],
      1 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (* parameters for DevelopmentDissociation *)
    Example[{Options, DevelopmentDissociationTime, "Automatically resolve the DevelopmentDissociationTime option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, DevelopmentDissociationTime],
      30 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DevelopmentDissociationTime, "Set the DevelopmentDissociationTime option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        DevelopmentDissociationTime -> 20 Minute, Output -> Options];
      Lookup[options, DevelopmentDissociationTime],
      20 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DevelopmentDissociationShakeRate, "Automatically resolve the DevelopmentDissociationShakeRate option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, DevelopmentDissociationShakeRate],
      1000 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DevelopmentDissociationShakeRate, "Set the DevelopmentDissociationShakeRate option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        DevelopmentDissociationShakeRate -> 500 RPM, Output -> Options];
      Lookup[options, DevelopmentDissociationShakeRate],
      500 RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DevelopmentDissociationThresholdCriterion, "Automatically resolve the DevelopmentDissociationThresholdCriterion option based on ExperimentType and the value of DevelopmentDissociationAbsoluteThreshold and DevelopmentDissociationThresholdSlope:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        DevelopmentDissociationAbsoluteThreshold -> 0.5 Nanometer,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        ExperimentType -> AssayDevelopment, Output -> Options];
      Lookup[options, DevelopmentDissociationThresholdCriterion],
      All,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DevelopmentDissociationThresholdCriterion, "Set the DevelopmentDissociationThresholdCriterion option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment, DevelopmentDissociationThresholdCriterion -> Single,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, DevelopmentDissociationThresholdCriterion],
      Single,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DevelopmentDissociationAbsoluteThreshold, "Set the DevelopmentDissociationAbsoluteThreshold option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        DevelopmentDissociationAbsoluteThreshold -> 0.5 Nanometer,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        ExperimentType -> AssayDevelopment, Output -> Options];
      Lookup[options, DevelopmentDissociationAbsoluteThreshold],
      0.5 Nanometer,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DevelopmentDissociationThresholdSlope, "Set the DevelopmentDissociationThresholdSlope option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        DevelopmentDissociationThresholdSlope -> 5 Nanometer/Minute,
        DevelopmentDissociationThresholdSlopeDuration -> 1 Minute,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        ExperimentType -> AssayDevelopment, Output -> Options];
      Lookup[options, DevelopmentDissociationThresholdSlope],
      5 Nanometer/Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DevelopmentDissociationThresholdSlopeDuration, "Set the DevelopmentDissociationThresholdSlopeDuration option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        DevelopmentDissociationThresholdSlope -> 5 Nanometer/Minute,
        DevelopmentDissociationThresholdSlopeDuration -> 1 Minute,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        ExperimentType -> AssayDevelopment, Output -> Options];
      Lookup[options, DevelopmentDissociationThresholdSlopeDuration],
      1 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (* -------------------------------------------- *)
    (* --- ASSAYSEQUENCEPRIMITIVES FROM OPTIONS --- *)
    (* -------------------------------------------- *)

    (* basic examples with loading, regen, etc *)
    Example[{Options, AssaySequencePrimitives, "Automatically resolve the AssaySequencePrimitives based on options (Regeneration/Kinetics):"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        RegenerationType -> {PreCondition, Regenerate, Neutralize, Wash},
        RegenerationCycles -> 1,
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, AssaySequencePrimitives],
      {Regenerate[_], Neutralize[_], Wash[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]},
      EquivalenceFunction -> MatchQ,
      Variables :> {options},
      Messages:>{Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, AssaySequencePrimitives, "Automatically resolve the AssaySequencePrimitives based on options (Loading/Kinetics):"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        ActivateSolution -> Object[Sample,"ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID],
        QuenchSolution -> Object[Sample,"ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
        LoadingType -> {Load, Quench, Activate},
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options];
      Lookup[options, AssaySequencePrimitives],
      {ActivateSurface[_], LoadSurface[_], Quench[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]},
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],
    Example[{Options, AssaySequencePrimitives, "Automatically resolve the AssaySequencePrimitives based on options (Equilibrate/Kinetics):"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Equilibrate -> True,
        Output -> Options
      ];
      Lookup[options, AssaySequencePrimitives],
      {Equilibrate[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]},
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],
    Example[{Options, AssaySequencePrimitives, "Automatically resolve the AssaySequencePrimitives based on options (Basic Quantitation with 9 samples):"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 5 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> Quantitation,
        Output -> Options
      ];
      Lookup[options, AssaySequencePrimitives],
      {Quantitate[_]},
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],
    Example[{Options, AssaySequencePrimitives, "Automatically resolve the AssaySequencePrimitives based on options (Basic Quantitation with 9 samples with Standard and Blank):"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 5 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> Quantitation,
        QuantitationParameters -> {StandardWell, BlankWell},
        QuantitationStandard -> Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], Output -> Options
      ];
      Lookup[options, AssaySequencePrimitives],
      {Quantitate[_]},
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],
    Example[{Options, AssaySequencePrimitives, "Automatically resolve the AssaySequencePrimitives based on options (Basic Quantitation with 9 samples with Standard, Blank, and StandardCurve):"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 5 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> Quantitation,
        QuantitationParameters -> {StandardWell, BlankWell, StandardCurve},
        Standard -> Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, AssaySequencePrimitives],
      {Quantitate[_]},
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],

    (* ---------------------------------------------------- *)
    (* --- EXPANDEDASSAYSEQUENCEPRIMITIVES FROM OPTIONS --- *)
    (* ---------------------------------------------------- *)

    Example[{Options, ExpandedAssaySequencePrimitives, "Automatically resolve the AssaySequencePrimitives based on options (Regeneration/Kinetics):"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        RegenerationType -> {PreCondition, Regenerate, Neutralize, Wash},
        RegenerationCycles -> 1,
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {{Regenerate[_], Neutralize[_], Wash[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]}},
      EquivalenceFunction -> MatchQ,
      Variables :> {options},
      Messages :> {Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, ExpandedAssaySequencePrimitives, "Automatically resolve the AssaySequencePrimitives based on options (Loading/Kinetics):"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics, LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        LoadingType -> {Load, Quench, Activate},
        ActivateSolution -> Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
        QuenchSolution -> Object[Sample, "ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {{ActivateSurface[_], LoadSurface[_], Quench[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]}},
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],

    Example[{Options, ExpandedAssaySequencePrimitives, "Automatically resolve the AssaySequencePrimitives based on options (Equilibrate/Kinetics):"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        ExperimentType -> Kinetics,
        Equilibrate -> True,
        Output -> Options
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {{Equilibrate[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]}},
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],
    Example[{Options, ExpandedAssaySequencePrimitives, "Automatically resolve the AssaySequencePrimitives based on options (Basic Quantitation with 9 samples):"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 5 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> Quantitation, Output -> Options
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {{Quantitate[_]}, {Quantitate[_]}},
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],
    Example[{Options, ExpandedAssaySequencePrimitives, "Automatically resolve the AssaySequencePrimitives based on options (Basic Quantitation with 9 samples with Standard and Blank):"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 5 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> Quantitation, QuantitationParameters -> {StandardWell, BlankWell},
        QuantitationStandard -> Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], Output -> Options
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {{Quantitate[_]}, {Quantitate[_]}},
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],
    Example[{Options, ExpandedAssaySequencePrimitives, "Automatically resolve the AssaySequencePrimitives based on options (Basic Quantitation with 9 samples with Standard, Blank, and StandardCurve):"},
      options = ExperimentBioLayerInterferometry[
        {
          Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 5 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> Quantitation,
        QuantitationParameters -> {StandardWell, BlankWell, StandardCurve},
        Standard -> Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {{Quantitate[_]}, {Quantitate[_]}, {Quantitate[_]}, {Quantitate[_]}},
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],

    (* --------------------------------------------------------- *)
    (* --- PRIMITIVEINPUT TO EXPANDEDASSAYSEQUENCEPRIMITIVES --- *)
    (* --------------------------------------------------------- *)

    (*with sharing it should not use more than 1.120 mL*)
    Example[{Options, ExpandedAssaySequencePrimitives, "Set the AssaySequencePrimitives with direct primitive input for ExperimentType -> Kinetics:"},
      options = ExperimentBioLayerInterferometry[ConstantArray[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], 3],
        AssaySequencePrimitives -> {
          Equilibrate[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 5 Second, ShakeRate -> 1000 RPM],
          ActivateSurface[ActivationSolutions -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          LoadSurface[LoadingSolutions -> ConstantArray[Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          Quench[QuenchSolutions -> ConstantArray[Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          Regenerate[RegenerationSolutions -> ConstantArray[Object[Sample, "ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID], 8], Time -> 20 Second, ShakeRate -> 200 RPM],
          Wash[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 20 Second, ShakeRate -> 200 RPM],
          Neutralize[NeutralizationSolutions -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 20 Second, ShakeRate -> 200 RPM],
          MeasureBaseline[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          MeasureAssociation[Analytes -> Samples, Time -> 100 Second, ShakeRate -> 1000 RPM],
          MeasureDissociation[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM]
        },
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {{Equilibrate[_], ActivateSurface[_], LoadSurface[_], Quench[_], Regenerate[_], Wash[_], Neutralize[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]},
        {Regenerate[_], Wash[_], Neutralize[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]},
        {Regenerate[_], Wash[_], Neutralize[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]}
      },
      EquivalenceFunction -> MatchQ,
      Variables :> {options},
      Messages :> {Warning::BLIPrimitiveOverride}
    ],

    Example[{Options, ExpandedAssaySequencePrimitives, "Set the AssaySequencePrimitives with direct primitive input for ExperimentType -> Quantitation:"},
      options = ExperimentBioLayerInterferometry[ConstantArray[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], 21],
        AssaySequencePrimitives -> {
          Equilibrate[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 4], Time -> 5 Second, ShakeRate -> 1000 RPM],
          ActivateSurface[ActivationSolutions -> ConstantArray[Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          LoadSurface[LoadingSolutions -> ConstantArray[Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          Quench[QuenchSolutions -> ConstantArray[Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          Regenerate[RegenerationSolutions -> ConstantArray[Object[Sample, "2 M HCl for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 20 Second, ShakeRate -> 200 RPM],
          Wash[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 20 Second, ShakeRate -> 200 RPM],
          Neutralize[NeutralizationSolutions -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 20 Second, ShakeRate -> 200 RPM],
          Quantitate[Analytes -> Samples, Blanks -> Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], Time -> 100 Second, ShakeRate -> 1000 RPM]
        },
        ExperimentType -> Quantitation,
        Output -> Options
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {
        {Equilibrate[_], ActivateSurface[_], LoadSurface[_], Quench[_], Regenerate[_], Wash[_], Neutralize[_], Quantitate[_]},
        {Regenerate[_], Wash[_], Neutralize[_], Quantitate[_]},
        {Regenerate[_], Wash[_], Neutralize[_], Quantitate[_]}
      },
      EquivalenceFunction -> MatchQ,
      Variables :> {options},
      Messages :> {Warning::BLIPrimitiveOverride}
    ],

    (* with user input loadign solutions, it is fine. The action here is to remove the Samples Key from the LoadSurface Primitive *)
    (* this should also be fixed so that only the number of wells that are required are filled. Currently it fills all the wells - blanks *)
    Example[{Options, ExpandedAssaySequencePrimitives, "Set the AssaySequencePrimitives with direct primitive input for ExperimentType -> EpitopeBinning:"},
      options = ExperimentBioLayerInterferometry[{
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID]
      },
        AssaySequencePrimitives -> {
          Equilibrate[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 3], Time -> 5 Second, ShakeRate -> 1000 RPM],
          LoadSurface[LoadingSolutions -> {
            Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
            Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
            Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID]
          }, Time -> 10 Second, ShakeRate -> 1000 RPM],
          Wash[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          LoadSurface[LoadingSolutions -> ConstantArray[Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          MeasureBaseline[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          MeasureAssociation[Analytes -> Samples, Time -> 100 Second, ShakeRate -> 1000 RPM]
        },
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {{Equilibrate[_], LoadSurface[_], Wash[_], LoadSurface[_], MeasureBaseline[_], MeasureAssociation[_]},
        {Equilibrate[_], LoadSurface[_], Wash[_], LoadSurface[_], MeasureBaseline[_], MeasureAssociation[_]},
        {Equilibrate[_], LoadSurface[_], Wash[_], LoadSurface[_], MeasureBaseline[_], MeasureAssociation[_]}},
      EquivalenceFunction -> MatchQ,
      Variables :> {options},
      Messages :> {Warning::BLIPrimitiveOverride}
    ],

    Example[{Options, ExpandedAssaySequencePrimitives, "Set the AssaySequencePrimitives with direct primitive input for ExperimentType -> AssayDevelopment:"},
      options = ExperimentBioLayerInterferometry[ConstantArray[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], 2],
        AssaySequencePrimitives -> {
          Equilibrate[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 5 Second, ShakeRate -> 1000 RPM],
          LoadSurface[LoadingSolutions -> ConstantArray[Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          Regenerate[RegenerationSolutions -> ConstantArray[Object[Sample, "2 M HCl for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 20 Second, ShakeRate -> 200 RPM],
          Wash[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          MeasureAssociation[Analytes -> Samples, Time -> 100 Second, ShakeRate -> 1000 RPM]
        },
        ExperimentType -> AssayDevelopment,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {{Equilibrate[_], LoadSurface[_], Regenerate[_], Wash[_], MeasureAssociation[_]},
        {Regenerate[_], Wash[_], MeasureAssociation[_]}},
      EquivalenceFunction -> MatchQ,
      Variables :> {options},
      Messages :> {Warning::BLIPrimitiveOverride}
    ],
    Example[{Options, ExpandedAssaySequencePrimitives, "Set the AssaySequencePrimitives with direct primitive input for ExperimentType -> Kinetics to run a typical kinetics assay on 4 samples:"},
      options = ExperimentBioLayerInterferometry[{
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
      },
        AssaySequencePrimitives -> {
          Equilibrate[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 5 Second, ShakeRate -> 1000 RPM],
          ActivateSurface[ActivationSolutions -> ConstantArray[Object[Sample, "ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          LoadSurface[LoadingSolutions -> ConstantArray[Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          Quench[QuenchSolutions -> ConstantArray[Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          Regenerate[RegenerationSolutions -> ConstantArray[Object[Sample, "2 M HCl for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 20 Second, ShakeRate -> 200 RPM],
          Wash[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 20 Second, ShakeRate -> 200 RPM],
          Neutralize[NeutralizationSolutions -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 20 Second, ShakeRate -> 200 RPM],
          MeasureBaseline[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          MeasureAssociation[Analytes -> Samples, Time -> 100 Second, ShakeRate -> 1000 RPM],
          MeasureDissociation[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM]
        },
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {
        {Equilibrate[_], ActivateSurface[_], LoadSurface[_], Quench[_], Regenerate[_], Wash[_], Neutralize[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]},
        {Regenerate[_], Wash[_], Neutralize[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]},
        {Regenerate[_], Wash[_], Neutralize[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]},
        {Regenerate[_], Wash[_], Neutralize[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]}
      },
      EquivalenceFunction -> MatchQ,
      Variables :> {options},
      Messages :> {Warning::BLIPrimitiveOverride}
    ],

    (* ------------------------------------ *)
    (* --- MIXED PRIMITIVE/OPTION INPUT --- *)
    (* ------------------------------------ *)

    (*TODO: add more tests in this section*)

    Example[{Options, ExpandedAssaySequencePrimitives, "Set the AssaySequencePrimitives for ExperimentType -> Kinetics, specifying dilutions with the KineticsSampleSerialDilutions for one sample:"},
      options = ExperimentBioLayerInterferometry[{
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]
      },
        AssaySequencePrimitives -> {
          MeasureBaseline[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          MeasureAssociation[Analytes -> Samples, Blanks -> {Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID]}, Time -> 100 Second, ShakeRate -> 1000 RPM],
          MeasureDissociation[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM]
        },
        ExperimentType -> Kinetics,
        KineticsSampleSerialDilutions -> {{{2, "101"}, {4, "102"}, {6, "103"}, {8, "104"}, {3, "105"}, {10, "106"}, {12, "107"}}, {{2, "201"}, {4, "202"}, {6, "203"}, {8, "204"}, {3, "205"}, {10, "206"}, {12, "207"}}},
        KineticsSampleDiluent -> {Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID]},
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {
        {MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]},
        {MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]}
      },
      EquivalenceFunction -> MatchQ,
      Variables :> {options},
      Messages :> {Warning::BLIPrimitiveOverride}
    ],

    Example[{Options, ExpandedAssaySequencePrimitives, "Set the AssaySequencePrimitives for ExperimentType -> Kinetics, specifying dilutions with the KineticsSampleFixedDilutions for one sample:"},
      options = ExperimentBioLayerInterferometry[{
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]
      },
        AssaySequencePrimitives -> {
          MeasureBaseline[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          MeasureAssociation[Analytes -> Samples, Blanks -> {Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID]}, Time -> 100 Second, ShakeRate -> 1000 RPM],
          MeasureDissociation[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM]
        },
        ExperimentType -> Kinetics,
        KineticsSampleFixedDilutions -> {{{2, "101"}, {4, "102"}, {6, "103"}, {8, "104"}, {3, "105"}, {10, "106"}, {12, "107"}}, {{2, "201"}, {4, "202"}, {6, "203"}, {8, "204"}, {3, "205"}, {10, "206"}, {12, "207"}}},
        KineticsSampleDiluent -> {Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID]},
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {
        {MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]},
        {MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]}
      },
      EquivalenceFunction -> MatchQ,
      Variables :> {options},
      Messages :> {Warning::BLIPrimitiveOverride}
    ],

    (* detectionlimit dilutions *)
    Example[{Options, ExpandedAssaySequencePrimitives, "Set the AssaySequencePrimitives for ExperimentType -> AssayDevelopment, specifying dilutions with the DetectionLimitSerialDilutions for two samples:"},
      options = ExperimentBioLayerInterferometry[{
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]
      },
        AssaySequencePrimitives -> {
          MeasureBaseline[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          MeasureAssociation[Analytes -> Samples, Blanks -> {Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID]}, Time -> 100 Second, ShakeRate -> 1000 RPM],
          MeasureDissociation[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM]
        },
        ExperimentType -> AssayDevelopment,
        DetectionLimitSerialDilutions -> {{{2, "101"}, {4, "102"}, {6, "103"}, {8, "104"}, {3, "105"}, {10, "106"}, {12, "107"}}, {{2, "201"}, {4, "202"}, {6, "203"}, {8, "204"}, {3, "205"}, {10, "206"}, {12, "207"}}},
        DetectionLimitDiluent -> {Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID]},
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {
        {MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]},
        {MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]}
      },
      EquivalenceFunction -> MatchQ,
      Variables :> {options},
      Messages :> {Warning::BLIPrimitiveOverride}
    ],
    Example[{Options, ExpandedAssaySequencePrimitives, "Set the AssaySequencePrimitives for ExperimentType -> AssayDevelopment, specifying dilutions with the DetectionLimitFixedDilutions for two samples:"},
      options = ExperimentBioLayerInterferometry[{
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]
      },
        AssaySequencePrimitives -> {
          MeasureBaseline[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          MeasureAssociation[Analytes -> Samples, Blanks -> {Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID]}, Time -> 100 Second, ShakeRate -> 1000 RPM],
          MeasureDissociation[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM]
        },
        ExperimentType -> AssayDevelopment,
        DetectionLimitFixedDilutions -> {{{2, "101"}, {4, "102"}, {6, "103"}, {8, "104"}, {3, "105"}, {10, "106"}, {12, "107"}}, {{2, "201"}, {4, "202"}, {6, "203"}, {8, "204"}, {3, "205"}, {10, "206"}, {12, "207"}}},
        DetectionLimitDiluent -> {Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID]},
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {
        {MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]},
        {MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]}
      },
      EquivalenceFunction -> MatchQ,
      Variables :> {options},
      Messages :> {Warning::BLIPrimitiveOverride}
    ],

    (* quantitation standard curve *)
    Example[{Options, ExpandedAssaySequencePrimitives, "Set the AssaySequencePrimitives for ExperimentType -> Quantitation, specifying the standard curve with QuantitationStandardSerialDilutions for 7 samples:"},
      options = ExperimentBioLayerInterferometry[{
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 5 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID]
      },
        AssaySequencePrimitives -> {
          Equilibrate[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          Quantitate[Analytes -> Samples, Blanks -> {Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID]}, Time -> 100 Second, ShakeRate -> 1000 RPM]
        },
        ExperimentType -> Quantitation,
        QuantitationStandardSerialDilutions -> {{2, "2x standard dilution"},{4, "4x standard dilution"},{8, "8x standard dilution"},{16, "16x standard dilution"},{32, "32x standard dilution"}, {64, "64x standard dilution"},{128,"128x standard dilution"}},
        QuantitationStandardDiluent -> Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        QuantitationStandard -> Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        QuantitationParameters -> {StandardCurve},
        Output -> Options
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {
        {Equilibrate[_], Quantitate[_]},
        {Equilibrate[_], Quantitate[_]}
      },
      EquivalenceFunction -> MatchQ,
      Variables :> {options},
      Messages :> {Warning::BLIPrimitiveOverride}
    ],
    Example[{Options, ExpandedAssaySequencePrimitives, "Set the AssaySequencePrimitives for ExperimentType -> Quantitation, specifying the standard curve with QuantitationStandardFixedDilutions for 7 samples:"},
      options = ExperimentBioLayerInterferometry[{
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 5 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID]
      },
        AssaySequencePrimitives -> {
          Equilibrate[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Minute, ShakeRate -> 1000 RPM],
          Quantitate[Analytes -> Samples, Blanks -> {Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID]}, Time -> 100 Second, ShakeRate -> 1000 RPM]
        },
        ExperimentType -> Quantitation,
        QuantitationStandardFixedDilutions -> {{2, "101"}, {4, "102"}, {6, "103"}, {8, "104"}, {3, "105"}, {10, "106"}, {12, "107"}},
        QuantitationStandardDiluent -> Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        QuantitationStandard -> Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        QuantitationParameters -> {StandardCurve},
        Output -> Options
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {
        {Equilibrate[_], Quantitate[_]},
        {Equilibrate[_], Quantitate[_]}
      },
      EquivalenceFunction -> MatchQ,
      Variables :> {options},
      Messages :> {Warning::BLIPrimitiveOverride}
    ],

    (* epitope binning - premix, tandem, and sandwich*)
    Example[{Options, ExpandedAssaySequencePrimitives, "Set the AssaySequencePrimitives for ExperimentType -> EpitopeBinning, specifying the PreMixSolutions for 7 samples:"},
      options = ExperimentBioLayerInterferometry[{
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 5 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID]
      },
        AssaySequencePrimitives -> {
          Equilibrate[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          LoadSurface[LoadingSolutions -> {
            Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
            Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
            Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
            Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID],
            Object[Sample, "ExperimentBLI New Test Chemical 5 (20 mL)" <> $SessionUUID],
            Object[Sample, "ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID],
            Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID]
          }, Blanks -> {Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID]}, Time -> 1 Minute, ShakeRate -> 400 RPM],
          Wash[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 30 Second, ShakeRate -> 400 RPM],
          MeasureAssociation[Analytes -> Samples, Time -> 100 Second, ShakeRate -> 400 RPM]
        },
        ExperimentType -> EpitopeBinning,
        BinningType -> PreMix,
        PreMixSolutions -> {
          {110 Microliter, 110 Microliter, 0 Microliter, "1"},
          {110 Microliter, 110 Microliter, 0 Microliter, "2"},
          {110 Microliter, 110 Microliter, 0 Microliter, "3"},
          {110 Microliter, 110 Microliter, 0 Microliter, "4"},
          {110 Microliter, 110 Microliter, 0 Microliter, "5"},
          {110 Microliter, 110 Microliter, 0 Microliter, "6"},
          {110 Microliter, 110 Microliter, 0 Microliter, "7"}
        },
        PreMixDiluent -> Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {
        {Equilibrate[_], LoadSurface[_], Wash[_], MeasureAssociation[_]},
        {Equilibrate[_], LoadSurface[_], Wash[_], MeasureAssociation[_]},
        {Equilibrate[_], LoadSurface[_], Wash[_], MeasureAssociation[_]},
        {Equilibrate[_], LoadSurface[_], Wash[_], MeasureAssociation[_]},
        {Equilibrate[_], LoadSurface[_], Wash[_], MeasureAssociation[_]},
        {Equilibrate[_], LoadSurface[_], Wash[_], MeasureAssociation[_]},
        {Equilibrate[_], LoadSurface[_], Wash[_], MeasureAssociation[_]}
      },
      EquivalenceFunction -> MatchQ,
      Variables :> {options},
      Messages :> {Warning::BLIPrimitiveOverride}
    ],
    (* epitope binning - sandwich*)
    Example[{Options, ExpandedAssaySequencePrimitives, "Set the AssaySequencePrimitives for ExperimentType -> EpitopeBinning and BinningType -> Sandwich for 7 samples:"},
      options = ExperimentBioLayerInterferometry[{
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 5 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID]
      },
        AssaySequencePrimitives -> {
          Equilibrate[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          LoadSurface[LoadingSolutions -> {
            Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
            Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
            Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
            Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID],
            Object[Sample, "ExperimentBLI New Test Chemical 5 (20 mL)" <> $SessionUUID],
            Object[Sample, "ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID],
            Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID]
          }, Blanks -> {Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID]}, Time -> 1 Minute, ShakeRate -> 400 RPM],
          Wash[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 30 Second, ShakeRate -> 400 RPM],
          LoadSurface[LoadingSolutions -> ConstantArray[Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Blanks -> {}, Time -> 1 Minute, ShakeRate -> 400 RPM],
          Wash[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 30 Second, ShakeRate -> 400 RPM],
          MeasureAssociation[Analytes -> Samples, Time -> 100 Second, ShakeRate -> 400 RPM]
        },
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        BinningType -> Sandwich,
        Output -> Options
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {
        {Equilibrate[_], LoadSurface[_], Wash[_], LoadSurface[_], Wash[_], MeasureAssociation[_]},
        {Equilibrate[_], LoadSurface[_], Wash[_], LoadSurface[_], Wash[_], MeasureAssociation[_]},
        {Equilibrate[_], LoadSurface[_], Wash[_], LoadSurface[_], Wash[_], MeasureAssociation[_]},
        {Equilibrate[_], LoadSurface[_], Wash[_], LoadSurface[_], Wash[_], MeasureAssociation[_]},
        {Equilibrate[_], LoadSurface[_], Wash[_], LoadSurface[_], Wash[_], MeasureAssociation[_]},
        {Equilibrate[_], LoadSurface[_], Wash[_], LoadSurface[_], Wash[_], MeasureAssociation[_]},
        {Equilibrate[_], LoadSurface[_], Wash[_], LoadSurface[_], Wash[_], MeasureAssociation[_]}
      },
      EquivalenceFunction -> MatchQ,
      Variables :> {options},
      Messages :> {Warning::BLIPrimitiveOverride}
    ],
    (*tandem*)
    Example[{Options, ExpandedAssaySequencePrimitives, "Set the AssaySequencePrimitives for ExperimentType -> EpitopeBinning and BinningType -> Tandem for 7 samples:"},
      options = ExperimentBioLayerInterferometry[{
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 5 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID]
      },
        AssaySequencePrimitives -> {
          Equilibrate[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          LoadSurface[LoadingSolutions -> ConstantArray[Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Blanks -> {}, Time -> 1 Minute, ShakeRate -> 400 RPM],
          Wash[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 30 Second, ShakeRate -> 400 RPM],
          LoadSurface[LoadingSolutions -> {
            Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
            Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
            Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
            Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID],
            Object[Sample, "ExperimentBLI New Test Chemical 5 (20 mL)" <> $SessionUUID],
            Object[Sample, "ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID],
            Object[Sample, "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID]
          }, Blanks -> {Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID]}, Time -> 1 Minute, ShakeRate -> 400 RPM],
          Wash[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 30 Second, ShakeRate -> 400 RPM],
          MeasureAssociation[Analytes -> Samples, Time -> 100 Second, ShakeRate -> 400 RPM]
        },
        ExperimentType -> EpitopeBinning,
        BinningType -> Tandem,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Output -> Options
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {
        {Equilibrate[_], LoadSurface[_], Wash[_], LoadSurface[_], Wash[_], MeasureAssociation[_]},
        {Equilibrate[_], LoadSurface[_], Wash[_], LoadSurface[_], Wash[_], MeasureAssociation[_]},
        {Equilibrate[_], LoadSurface[_], Wash[_], LoadSurface[_], Wash[_], MeasureAssociation[_]},
        {Equilibrate[_], LoadSurface[_], Wash[_], LoadSurface[_], Wash[_], MeasureAssociation[_]},
        {Equilibrate[_], LoadSurface[_], Wash[_], LoadSurface[_], Wash[_], MeasureAssociation[_]},
        {Equilibrate[_], LoadSurface[_], Wash[_], LoadSurface[_], Wash[_], MeasureAssociation[_]},
        {Equilibrate[_], LoadSurface[_], Wash[_], LoadSurface[_], Wash[_], MeasureAssociation[_]}
      },
      EquivalenceFunction -> MatchQ,
      Variables :> {options},
      Messages :> {Warning::BLIPrimitiveOverride}
    ],


    (* ------------------- *)
    (* --  SHARED TESTS -- *)
    (* ------------------- *)

    (* THIS TEST IS BRUTAL BUT DO NOT REMOVE IT. MAKE SURE YOUR FUNCTION DOESNT BUG ON THIS. *)
    Example[{Additional, "Use the sample preparation options to prepare samples before the main experiment:"},
      options=ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], Incubate->True, Centrifuge->True, Filtration->True, Aliquot->True, Output->Options];
      {Lookup[options, Incubate],Lookup[options, Centrifuge],Lookup[options, Filtration],Lookup[options, Aliquot]},
      {True,True,True,True},
      Variables :> {options}
    ],
    (* ExperimentIncubate tests. *)
    Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], Incubate -> True, Output -> Options];
      Lookup[options, Incubate],
      True,
      Variables :> {options}
    ],
    Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment or any aliquoting:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], IncubationTemperature -> 40*Celsius, Output -> Options];
      Lookup[options, IncubationTemperature],
      40*Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment or any aliquoting:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], IncubationTime -> 40*Minute, Output -> Options];
      Lookup[options, IncubationTime],
      40*Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment or any aliquoting:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], MaxIncubationTime -> 40*Minute, Output -> Options];
      Lookup[options, MaxIncubationTime],
      40*Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    (* Note: This test requires your sample to be in some type of 50mL tube or 96-well plate. Definitely not bigger than a 250mL bottle. *)
    Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment or any aliquoting:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], IncubationInstrument -> Model[Instrument, HeatBlock, "id:WNa4ZjRDVw64"], Output -> Options];
      Lookup[options, IncubationInstrument],
      ObjectP[Model[Instrument, HeatBlock, "id:WNa4ZjRDVw64"]],
      Variables :> {options}
    ],
    Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment or any aliquoting:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], AnnealingTime -> 40*Minute, Output -> Options];
      Lookup[options, AnnealingTime],
      40*Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], IncubateAliquot -> 1.5*Milliliter, Output -> Options];
      Lookup[options, IncubateAliquot],
      1.5*Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
      Lookup[options, IncubateAliquotContainer],
      {1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
      Variables :> {options}
    ],

    Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment or any aliquoting:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], Mix -> True, Output -> Options];
      Lookup[options, Mix],
      True,
      Variables :> {options}
    ],
    (* Note: You CANNOT be in a plate for the following test. *)
    Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment or any aliquoting:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], MixType -> Shake, Output -> Options];
      Lookup[options, MixType],
      Shake,
      Variables :> {options}
    ],
    Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment or any aliquoting:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], MixUntilDissolved -> True, Output -> Options];
      Lookup[options, MixUntilDissolved],
      True,
      Variables :> {options}
    ],

    (* ExperimentCentrifuge *)
    Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], Centrifuge -> True, Output -> Options];
      Lookup[options, Centrifuge],
      True,
      Variables :> {options}
    ],
    (* Note: Put your sample in a 2mL tube for the following test. *)
    Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment or any aliquoting:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"], Output -> Options];
      Lookup[options, CentrifugeInstrument],
      ObjectP[Model[Instrument, Centrifuge, "Microfuge 16"]],
      Variables :> {options}
    ],
    Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment or any aliquoting:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], CentrifugeIntensity -> 1000*RPM, Output -> Options];
      Lookup[options, CentrifugeIntensity],
      1000*RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    (* Note: CentrifugeTime cannot go above 5Minute without restricting the types of centrifuges that can be used. *)
    Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], CentrifugeTime -> 5*Minute, Output -> Options];
      Lookup[options, CentrifugeTime],
      5*Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment or any aliquoting:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], CentrifugeTemperature -> 10*Celsius, Output -> Options];
      Lookup[options, CentrifugeTemperature],
      10*Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], CentrifugeAliquot -> 1.5*Milliliter, Output -> Options];
      Lookup[options, CentrifugeAliquot],
      1.5*Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
      Lookup[options, CentrifugeAliquotContainer],
      {1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
      Variables :> {options}
    ],

    (* filter options *)
    Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], Filtration -> True, Output -> Options];
      Lookup[options, Filtration],
      True,
      Variables :> {options},
      Messages:>{
        Warning::AliquotRequired
      }
    ],
    Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], FiltrationType -> Syringe, Output -> Options];
      Lookup[options, FiltrationType],
      Syringe,
      Variables :> {options}
    ],
    Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
      Lookup[options, FilterInstrument],
      ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
      Variables :> {options}
    ],
    Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], Filter -> Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
      Lookup[options, Filter],
      ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
      Variables :> {options}
    ],
    Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], FilterMaterial -> PES, Output -> Options];
      Lookup[options, FilterMaterial],
      PES,
      Variables :> {options},
      Messages:>{
        Warning::AliquotRequired
      }
    ],
    Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], PrefilterMaterial -> GxF, Output -> Options];
      Lookup[options, PrefilterMaterial],
      GxF,
      Variables :> {options}
    ],
    Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], FilterPoreSize -> 0.22*Micrometer, Output -> Options];
      Lookup[options, FilterPoreSize],
      0.22*Micrometer,
      Variables :> {options},
      Messages:>{
        Warning::AliquotRequired
      }
    ],
    Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], PrefilterPoreSize -> 1.*Micrometer, FilterMaterial -> PTFE, Output -> Options];
      Lookup[options, PrefilterPoreSize],
      1.*Micrometer,
      Variables :> {options}
    ],
    Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
      Lookup[options, FilterSyringe],
      ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
      Variables :> {options}
    ],
    Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
      options = ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID], FiltrationType -> PeristalticPump, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], Output -> Options];
      Lookup[options, FilterHousing],
      ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
      Variables :> {options}
    ],
    Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, Output -> Options];
      Lookup[options, FilterIntensity],
      1000*RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages:>{
        Warning::AliquotRequired
      }
    ],
    Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20*Minute, Output -> Options];
      Lookup[options, FilterTime],
      20*Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages:>{
        Warning::AliquotRequired
      }
    ],
    Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTemperature -> 10*Celsius, Output -> Options];
      Lookup[options, FilterTemperature],
      10*Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages:>{
        Warning::AliquotRequired
      }
    ],
    Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], FilterSterile -> True, Output -> Options];
      Lookup[options, FilterSterile],
      True,
      Variables :> {options},
      Messages:>{
        Warning::AliquotRequired
      }
    ],
    Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], FilterAliquot -> 1.4*Milliliter, Output -> Options];
      Lookup[options, FilterAliquot],
      1.4*Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages:>{
        Warning::AliquotRequired
      }
    ],
    Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
      Lookup[options, FilterAliquotContainer],
      {1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
      Variables :> {options},
      Messages:>{
        Warning::AliquotRequired
      }
    ],
    Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
      Lookup[options, FilterContainerOut],
      {1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
      Variables :> {options}
    ],
    (* aliquot options *)
    Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], AliquotAmount -> 0.28 Milliliter, Output -> Options];
      Lookup[options, AliquotAmount],
      0.28*Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], AliquotAmount -> 0.28*Milliliter, Output -> Options];
      Lookup[options, AliquotAmount],
      0.28*Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], AssayVolume -> 0.28*Milliliter, Output -> Options];
      Lookup[options, AssayVolume],
      0.28*Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],


    Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID],
        TargetConcentration -> 0.5*Millimolar,
        Output -> Options];
      Lookup[options, TargetConcentration],
      0.5*Millimolar,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, TargetConcentrationAnalyte, "Set the TargetConcentrationAnalyte option:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], TargetConcentration -> 0.1*Molar,TargetConcentrationAnalyte->Model[Molecule, "Sodium Chloride"],AssayVolume->300*Microliter,Output -> Options];
      Lookup[options, TargetConcentrationAnalyte],
      ObjectP[Model[Molecule, "Sodium Chloride"]],
      Variables :> {options}
    ],
    Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID],
        ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
        AliquotAmount -> 0.1 Milliliter,
        AssayVolume -> 0.3 Milliliter,
        Output -> Options];
      Lookup[options, ConcentratedBuffer],
      ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
      Variables :> {options}
    ],
    Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID],
        BufferDilutionFactor -> 10,
        ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
        AliquotAmount -> 0.1 Milliliter,
        AssayVolume -> 0.3 Milliliter,
        Output -> Options];
      Lookup[options, BufferDilutionFactor],
      10,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID],
        BufferDiluent -> Model[Sample, "Milli-Q water"],
        BufferDilutionFactor -> 10,
        ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
        AliquotAmount -> 0.1 Milliliter,
        AssayVolume -> 0.3 Milliliter,
        Output -> Options];
      Lookup[options, BufferDiluent],
      ObjectP[Model[Sample, "Milli-Q water"]],
      Variables :> {options}
    ],
    Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID],
        AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
        AliquotAmount -> 0.1 Milliliter,
        AssayVolume -> 0.3 Milliliter,
        Output -> Options];
      Lookup[options, AssayBuffer],
      ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
      Variables :> {options}
    ],


    Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
      Lookup[options, AliquotSampleStorageCondition],
      Refrigerator,
      Variables :> {options}
    ],
    Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], ConsolidateAliquots -> True, Output -> Options];
      Lookup[options, ConsolidateAliquots],
      True,
      Variables :> {options}
    ],
    Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
      Lookup[options, AliquotPreparation],
      Manual,
      Variables :> {options}
    ],
    Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], AliquotContainer -> Model[Container, Plate, "id:kEJ9mqR3XELE"], Output -> Options];
      Lookup[options, AliquotContainer],
      {1, ObjectP[Model[Container, Plate, "id:kEJ9mqR3XELE"]]},
      Variables :> {options}
    ],
    Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], ImageSample -> True, Output -> Options];
      Lookup[options, ImageSample],
      True,
      Variables :> {options}
    ],
    Example[{Options,MeasureVolume,"Indicate if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
      Download[
        ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID],MeasureVolume->True],
        MeasureVolume
      ],
      True
    ],
    Example[{Options,MeasureWeight,"Indicate if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
      Download[
        ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID],MeasureWeight->True],
        MeasureWeight
      ],
      True
    ],
    Example[{Options,SamplesInStorageCondition, "Indicates how the input samples of the experiment should be stored:"},
      options = ExperimentBioLayerInterferometry[Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID], SamplesInStorageCondition -> Refrigerator, Output -> Options];
      Lookup[options,SamplesInStorageCondition],
      Refrigerator,
      Variables:>{options}
    ],

    (* --- Sample Prep unit tests --- *)
    Example[{Options,PreparatoryUnitOperations,"Specify prepared samples for a bio layer interferometry assay:"},
      options=ExperimentBioLayerInterferometry["test sample",
        PreparatoryUnitOperations->{
          LabelContainer[
            Label->"test sample",
            Container->Model[Container, Vessel, "id:bq9LA0dBGGR6"]
          ],
          Transfer[
            Source->Object[Sample,"ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
            Amount->500*Microliter,
            Destination->{"A1","test sample"}
          ]
        },
        Output->Options
      ];
      Lookup[options,AssaySequencePrimitives],
      {_},
      Variables:>{options}
    ],
    Example[{Options,PreparatoryUnitOperations,"Specify a prepared quantitation standard for a bio layer interferometry assay:"},
      ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        QuantitationStandard -> "blank",
        QuantitationParameters -> {StandardCurve},
        PreparatoryUnitOperations->{
          LabelContainer[
            Label->"blank container",
            Container->Model[Container, Vessel, "id:bq9LA0dBGGR6"]
          ],
          Transfer[
            Source->Object[Sample,"ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
            Amount->500*Microliter,
            Destination->{"A1","blank container"},
            DestinationLabel->"blank"
          ]
        }
      ],
      ObjectP[Object[Protocol]],
      TimeConstraint -> 600
    ],
    Example[{Options,PreparatoryPrimitives,"Specify prepared samples for a bio layer interferometry assay:"},
      options=ExperimentBioLayerInterferometry["test sample",
        PreparatoryPrimitives->{
          Define[
            Name->"test sample",
            Container->Model[Container, Vessel, "id:bq9LA0dBGGR6"]
          ],
          Transfer[
            Source->Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID],
            Amount->500*Microliter,
            Destination->{"test sample","A1"}
          ]
        },
        Output->Options
      ];
      Lookup[options,AssaySequencePrimitives],
      {_},
      Variables:>{options}
    ],

    (* make a test warning about low volume also *)

















    (* -------------------------------------------- *)
    (* ----------- WARNINGS AND ERRORS ------------ *)
    (* -------------------------------------------- *)

    Example[{Messages, "BLIMissingTime", "If a required Time value is missing, and error will be thrown:"},
      ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation,
        QuantitateTime -> Null
      ],
      $Failed,
      Messages :> {Error::InvalidResolvedBLIPrimitives,Error::BLIMissingTime, Error::InvalidOption}
    ],
    Example[{Messages, "BLIUnspecifiedQuantitationStandard", "If the QuantitationStandard is required for StandardCurve or StandardWell, it must be informed:"},
      ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation,
        QuantitationParameters -> {StandardCurve}
      ],
      $Failed,
      Messages :> {Error::BLIUnspecifiedQuantitationStandard, Error::InvalidOption}
    ],
    (* if the solutions sets match in length, the resolver can handle it, even though it may not result in the intended assay. This form of input is sort of ambiguous*)
    (* if a primitive holds multiple solution sets and they do not all match in length, then it will only expand around the longest one. Also it does not respect the rule of expandign the samples first. *)
    Example[{Messages, "UserBLIPrimitivesTooManySolutions", "If multiple primitives are specified with greater than 8 solutions, the expanded primitives cannot be generated and an error is thrown:"},
      ExperimentBioLayerInterferometry[{
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]
      },
        AssaySequencePrimitives -> {
          Equilibrate[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 21], Time -> 5 Second, ShakeRate -> 1000 RPM],
          MeasureBaseline[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          MeasureAssociation[Analytes -> Samples, Time -> 100 Second, ShakeRate -> 1000 RPM],
          MeasureDissociation[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID], 8], Time -> 10 Second, ShakeRate -> 1000 RPM]
        },
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      $Failed,
      Messages :> {Warning::BLIPrimitiveOverride, Error::InvalidOption, Error::UserBLIPrimitivesTooManySolutions}
    ],
    Example[{Messages, "MissingBLIShakeRate", "If a required ShakeRate is missing, and error will be thrown:"},
      ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation,
        QuantitateShakeRate -> Null
      ],
      $Failed,
      Messages :> {Error::InvalidResolvedBLIPrimitives,Error::MissingBLIShakeRate, Error::InvalidOption}
    ],

    (*dilution warnings*)
    Example[{Messages, "BLIConflictingKineticsDilutions", "If there are conflicting dilutions for a given sample, an error will be thrown:"},
      ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        KineticsSampleFixedDilutions -> {{{2, "101"}, {5, "102"}, {10, "103"}}},
        KineticsSampleSerialDilutions -> {{{2, "105"}, {2, "106"}, {2, "107"}}},
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      $Failed,
      Messages :> {Error::BLIConflictingKineticsDilutions, Error::InvalidOption}
    ],
    Example[{Messages, "BLIConflictingDevelopmentDilutions", "If there are conflicting dilutions for a given sample, an error will be thrown:"},
      ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment, DetectionLimitSerialDilutions -> {{{2, "101"}, {5, "102"}, {10, "103"}}},
        DetectionLimitFixedDilutions -> {{{2, "105"}, {2, "106"}, {2, "107"}}},
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      $Failed,
      Messages :> {Error::BLIConflictingDevelopmentDilutions, Error::InvalidOption}
    ],
    Example[{Messages, "BLIMissingKineticsDiluent", "If KineticsSampleSerialDilutions or KineticsSampleFixedDilutions are populated but KineticsSampleDiluent is not provided, an error will be thrown:"},
      ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        KineticsSampleFixedDilutions -> {{{2, "101"}, {5, "102"}, {10, "103"}}},
        KineticsSampleDiluent -> Null,
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      $Failed,
      Messages :> {Error::BLIMissingKineticsDiluent, Error::InvalidOption}
    ],
    Example[{Messages, "BLIMissingDevelopmentDiluents", "If DetectionLimitSerialDilutions or DetectionLimitFixedDilutions are populated but DetectionLimitDiluent is not provided, an error will be thrown:"},
      ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        DetectionLimitSerialDilutions -> {{{2, "101"}, {5, "102"}, {10, "103"}}},
        DetectionLimitDiluent -> Null,
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      $Failed,
      Messages :> {Error::BLIMissingDevelopmentDiluents, Error::InvalidOption}
    ],
    Example[{Messages, "BLIMissingPreMixDiluent", "If PreMixSolutions require dilution and the PreMixDiluent is not provided, an error will be thrown:"},
      ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        BinningType -> PreMix,
        ExperimentType -> EpitopeBinning,
        PreMixSolutions -> {{100 Microliter, 100 Microliter, 10 Microliter, "101"}},
        PreMixDiluent -> Null,
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      $Failed,
      Messages :> {Error::BLIMissingPreMixDiluent, Error::InvalidOption}
    ],

    Example[{Messages, "BLIDuplicateDilutionNames", "If solution names are not unique (between two dilution options), an error will be thrown:"},
      ExperimentBioLayerInterferometry[{
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID]
      },
        KineticsSampleFixedDilutions -> {{{2, "101"}, {5, "102"}, {10, "103"}}, Null},
        KineticsSampleSerialDilutions -> {Null, {{2, "101"}, {5, "102"}, {10, "103"}}},
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      $Failed,
      Messages :> {Error::BLIDuplicateDilutionNames, Error::InvalidOption}
    ],
    Example[{Messages, "BLIDuplicateDilutionNames", "If solution names are not unique (within a set of dilutions), an error will be thrown:"},
      ExperimentBioLayerInterferometry[{
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID]
      },
        KineticsSampleFixedDilutions -> {{{2, "101"}, {5, "101"}, {10, "102"}}},
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      $Failed,
      Messages :> {Error::BLIDuplicateDilutionNames, Error::InvalidOption}
    ],

    (* plate overload, too many probes, etc *)
    Example[{Messages, "BLIRepeatedSequenceMismatch", "If RepeatedSequence is inconsistent with user specified AssaySequencePrimitives, an error will be thrown:"},
      ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        AssaySequencePrimitives -> {
          Equilibrate[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],8], Time -> 20 Minute, ShakeRate -> 200 RPM],
          MeasureBaseline[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],8], Time -> 20 Minute, ShakeRate -> 200 RPM],
          MeasureAssociation[Analytes -> Samples, Time -> 10 Minute, ShakeRate -> 200 RPM],
          MeasureDissociation[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],8], Time -> 20 Minute, ShakeRate -> 200 RPM]
        },
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        RepeatedSequence -> {MeasureBaseline, Quantitate, MeasureDissociation}
      ],
      $Failed,
      Messages :> {Warning::BLIPrimitiveOverride, Error::BLIRepeatedSequenceMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "BLIForbiddenRepeatedSequence", "If RepeatedSequence is specified without AssaySequencePrimitives, an error will be thrown:"},
      ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        RepeatedSequence -> {MeasureBaseline, Quantitate, MeasureDissociation}
      ],
      $Failed,
      Messages :> {Error::BLIForbiddenRepeatedSequence, Error::InvalidOption}
    ],

    (* ---------------- *)
    (* --- Warnings --- *)
    (* ---------------- *)

    Example[{Messages, "UnusedOptionValuesBLIPrimitiveInput", "If AssaySequencePrimitives are informed, they will override other inputs such as ShakeRates, Times, Threshold parameters and some Solutions:"},
      ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        AssaySequencePrimitives -> {
          Equilibrate[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],8], Time -> 20 Second, ShakeRate -> 200 RPM],
          MeasureBaseline[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],8], Time -> 20 Second, ShakeRate -> 200 RPM],
          MeasureAssociation[Analytes -> Samples, Time -> 10 Second, ShakeRate -> 200 RPM],
          MeasureDissociation[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],8], Time -> 20 Second, ShakeRate -> 200 RPM]
        },
        ExperimentType -> Kinetics,
        MeasureAssociationTime -> 20 Second,
        MeasureAssociationShakeRate -> 1000 RPM,
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      ObjectP[Object[Protocol, BioLayerInterferometry]],
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages :> {Warning::BLIPrimitiveOverride, Warning::UnusedOptionValuesBLIPrimitiveInput}
    ],
    Example[{Messages, "UnusedOptionValuesBLIPrimitiveInput", "If ExpandedAssaySequencePrimitives are informed, they will override other inputs such as ShakeRates, Times, Threshold parameters and some Solutions:"},
      ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExpandedAssaySequencePrimitives -> {{
          Equilibrate[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],8], Time -> 20 Second, ShakeRate -> 200 RPM],
          MeasureBaseline[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],8], Time -> 20 Second, ShakeRate -> 200 RPM],
          MeasureAssociation[Analytes -> {"2x dilution","4x dilution", "8x dilution", "16x dilution", Null, Null,Null, Null}, Time -> 10 Second, ShakeRate -> 200 RPM],
          MeasureDissociation[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],8], Time -> 20 Second, ShakeRate -> 200 RPM]
        }},
        KineticsSampleSerialDilutions ->{{2,{"2x dilution","4x dilution", "8x dilution", "16x dilution"}}},
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        MeasureAssociationTime -> 20 Second,
        MeasureAssociationShakeRate -> 1000 RPM
      ],
      ObjectP[Object[Protocol, BioLayerInterferometry]],
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages :> {Warning::BLIPrimitiveOverride, Warning::UnusedOptionValuesBLIPrimitiveInput}
    ],
    Example[{Messages, "UnusedBLIOptionValuesQuantitation", "If parameters for a different ExperimentType are specified, and error will be thrown:"},
      ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation,
        MeasureAssociationTime -> 100 Second
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::UnusedBLIOptionValuesQuantitation, Error::InvalidOption}
    ],
    Example[{Messages, "UnusedBLIOptionValuesKinetics", "If parameters for a different ExperimentType are specified, and error will be thrown:"},
      ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        QuantitateShakeRate -> 1000 RPM,
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::UnusedBLIOptionValuesKinetics, Error::InvalidOption}
    ],
    Example[{Messages, "UnusedBLIOptionValuesEpitopeBinning", "If parameters for a different ExperimentType are specified, and error will be thrown:"},
      ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> EpitopeBinning,
        MeasureAssociationTime -> 100 Second,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID]
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::UnusedBLIOptionValuesEpitopeBinning, Error::InvalidOption}
    ],
    Example[{Messages, "UnusedBLIOptionValuesAssayDevelopment", "If parameters for a different ExperimentType are specified, and error will be thrown:"},
      ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        MeasureDissociationTime -> 100 Second
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::UnusedBLIOptionValuesAssayDevelopment, Error::InvalidOption}
    ],
    Example[{Messages, "UserBLIPrimitivesTooManySolutions", "If more solutions are specified in direct primitive input than can be expanded without ambiguity, an error will be thrown:"},
      ExperimentBioLayerInterferometry[
        {
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID]
        },
        AssaySequencePrimitives -> {
          Equilibrate[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],10], Time -> 5 Second, ShakeRate -> 1000 RPM],
          MeasureAssociation[Analytes -> Samples, Time -> 100 Second, ShakeRate -> 1000 RPM],
          MeasureDissociation[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],8], Time -> 10 Second, ShakeRate -> 1000 RPM]
        },
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Warning::BLIPrimitiveOverride, Error::UserBLIPrimitivesTooManySolutions, Error::InvalidOption}
    ],
    Example[{Messages, "BLIProbeApplicationMismatch", "If the probe RecommendedApplication does not match the ExperimentType, a warning will be shown:"},
      ExperimentBioLayerInterferometry[Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation,
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      ObjectP[Object[Protocol, BioLayerInterferometry]],
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Warning::BLIProbeApplicationMismatch}
    ],

    (* -- Storage condition messages -- *)

    Example[{Messages, "BLIQuantitationEnzymeStorageConditionMismatch", "If the storage condition is specified for QuantitationEnzymeSolution but QuantitationEnzymeSolution is not specified or resolvable, an error will be shown:"},
      ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation,
        QuantitationEnzymeSolutionStorageCondition -> AmbientStorage
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::BLIQuantitationEnzymeStorageConditionMismatch, Error::InvalidOption}
    ],

    Example[{Messages, "BLILoadSolutionStorageConditionMismatch", "If the storage condition is specified for LoadSolution but LoadSolution is not specified or resolvable, an error will be shown:"},
      ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        LoadSolutionStorageCondition -> AmbientStorage
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::BLILoadSolutionStorageConditionMismatch, Error::InvalidOption}
    ],

    Example[{Messages, "BLIStandardStorageConditionMismatch", "If the storage condition is specified for Standard but Standard is not specified or resolvable, an error will be shown:"},
      ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        StandardStorageCondition -> AmbientStorage
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::BLIStandardStorageConditionMismatch, Error::InvalidOption}
    ],

    Example[{Messages, "BLIQuantitationStandardStorageConditionMismatch", "If the storage condition is specified for QuantitationStandard but QuantitationStandard is not specified or resolvable, an error will be shown:"},
      ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        QuantitationStandardStorageCondition -> AmbientStorage
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::BLIQuantitationStandardStorageConditionMismatch, Error::InvalidOption}
    ],

    Example[{Messages, "BLIBinningAntigenStorageConditionMismatch", "If the storage condition is specified for BinningAntigen but BinningAntigen is not specified or resolvable, an error will be shown:"},
      ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        BinningAntigenStorageCondition -> AmbientStorage
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::BLIBinningAntigenStorageConditionMismatch, Error::InvalidOption}
    ],

    Example[{Messages, "BLITestInteractionSolutionsStorageConditionMismatch", "If the storage condition is specified for TestInteractionSolutions but TestInteractionSolutions is not specified or resolvable, an error will be shown:"},
      ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        TestInteractionSolutionsStorageConditions -> AmbientStorage
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::BLITestInteractionSolutionsStorageConditionMismatch, Error::InvalidOption}
    ],

    Example[{Messages, "BLITestLoadingSolutionsStorageConditionMismatch", "If the storage condition is specified for TestLoadingSolutions but TestLoadingSolutions is not specified or resolvable, an error will be shown:"},
      ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation,
        TestLoadingSolutionsStorageConditions -> {AmbientStorage, AmbientStorage}
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{
        Error::BLITestLoadingSolutionsStorageConditionMismatch,
        Error::BLITestLoadingSolutionsStorageConditionLengthMismatch,
        Error::InvalidOption
      }
    ],

    (* bad test loading solution length *)
    Example[{Messages, "BLITestLoadingSolutionsStorageConditionLengthMismatch", "If the length of TestLoadingSolutionsStorageCondition does not match the length of TestLoadingSolutions, an error will be shown:"},
      ExperimentBioLayerInterferometry[
        Object[Sample, "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        DevelopmentType -> ScreenLoading,
        LoadingType -> {Load},
        TestLoadingSolutionsStorageConditions -> {AmbientStorage, AmbientStorage},
        TestLoadingSolutions -> {
          Object[Sample, "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample, "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID]
        }
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::BLITestLoadingSolutionsStorageConditionLengthMismatch, Error::InvalidOption}
    ]
  },
  (*  build test objects *)
  Stubs:>{
    $EmailEnabled=False
  },
  SymbolSetUp :> (
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Test bench for ExperimentBLI tests" <> $SessionUUID],
          Object[Item, BLIProbe, "SA probe for ExperimentBLI test" <> $SessionUUID],
          Object[Item, BLIProbe, "ProA probe for BLI test" <> $SessionUUID],
          Object[Part, BLIPlateCover, "Plate Cover for BLI test" <> $SessionUUID],
          Object[Container, Vessel, "Test container 1 for ExperimentBLI tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 2 for ExperimentBLI tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 3 for ExperimentBLI tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 4 for ExperimentBLI tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 5 for ExperimentBLI tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 6 for ExperimentBLI tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 7 for ExperimentBLI tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 8 for ExperimentBLI tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container blank for ExperimentBLI tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container loading1 for ExperimentBLI tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container antigen1 for ExperimentBLI tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container regen1 for ExperimentBLI tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container regen2 for ExperimentBLI tests" <> $SessionUUID],
          Object[Container, Plate,"Test assay plate for ExperimentBLI" <> $SessionUUID],
          Object[Container, Plate, "Test probe rack plate for ExperimentBLI" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 5 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID],
          Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
          Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
          Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
          Object[Sample, "2 M HCl for ExperimentBLI Test (20 mL)" <> $SessionUUID],
          Object[Sample, "1.85 M NaOH for ExperimentBLI Test (20 mL)" <> $SessionUUID],
          Object[Instrument, BioLayerInterferometer, "Test Octet Red96e for ExperimentBLI" <> $SessionUUID],
          Object[Protocol,BioLayerInterferometry,"Test Template Protocol for ExperimentBLI" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ];
    Block[{$AllowSystemsProtocols = True},
      Module[
        {testBench,testPlateCover,testProAProbes,testSAProbes, testInstrument,testProtocol,
          container1, container2, container3, container4, container5, container6, container7, container8, blankContainer1, loadingContainer1, antigenContainer1, regenContainer1, regenContainer2,
          sample1, sample2, sample3, sample4, sample5,sample6,sample7, sample8, blankSolution1, loadingSolution1, antigenSolution1, regenSolution1, regenSolution2, assayPlate, probeRackPlate
        },
        (* set up test bench as a location for the vessel *)
        testBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Test bench for ExperimentBLI tests" <> $SessionUUID, Site -> Link[$Site], DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

        testPlateCover = Upload[<|Type -> Object[Part, BLIPlateCover],
          Model-> Link[Model[Part, BLIPlateCover, "Octet plate cover, 96 well"], Objects],
          Name -> "Plate Cover for BLI test" <> $SessionUUID,
          Status -> Available,
          Site -> Link[$Site],
          ExpirationDate -> DateObject[Now+1 Year]|>];
        testProAProbes = Upload[<|Type -> Object[Item, BLIProbe],
          Model -> Link[Model[Item, BLIProbe, "ProA"],Objects],
          Name -> "ProA probe for BLI test" <> $SessionUUID,
          Count -> 96,
          Status -> Available,
          Site -> Link[$Site],
          ExpirationDate -> DateObject[Now+1 Year]|>];
        testSAProbes = Upload[<|Type -> Object[Item, BLIProbe],
          Model -> Link[Model[Item, BLIProbe, "SA"],Objects],
          Name -> "SA probe for ExperimentBLI test" <> $SessionUUID,
          Count -> 96,
          Status -> Available,
          Site -> Link[$Site],
          ExpirationDate -> DateObject[Now+1 Year]|>];

        (*set up test instrument*)
        testInstrument = Upload[
          <|
            Type -> Object[Instrument, BioLayerInterferometer],
            Name -> "Test Octet Red96e for ExperimentBLI" <> $SessionUUID,
            Model -> Link[Model[Instrument,BioLayerInterferometer, "Octet Red96e"], Objects],
            Status -> Available,
            Site -> Link[$Site],
            DeveloperObject -> True
          |>
        ];

        (* set up a test protocol for template. Do this after the test instrument setup *)
        testProtocol = Upload[
          <|
            Type -> Object[Protocol,BioLayerInterferometry],
            Name -> "Test Template Protocol for ExperimentBLI" <> $SessionUUID,
            ResolvedOptions -> {Instrument -> Object[Instrument, BioLayerInterferometer, "Test Octet Red96e for ExperimentBLI" <> $SessionUUID]},
            DeveloperObject->True
          |>
        ];

        (* set up test containers for our samples *)
        {
          container1,
          container2,
          container3,
          container4,
          container5,
          container6,
          container7,
          container8,
          blankContainer1,
          loadingContainer1,
          antigenContainer1,
          regenContainer1,
          regenContainer2,
          assayPlate,
          probeRackPlate
        } = UploadSample[
          {
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Plate, "id:kEJ9mqR3XELE"],
            Model[Container, Plate, "id:kEJ9mqR3XELE"]
          },
          {
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench}
          },
          Status ->
              {
                Available,
                Available,
                Available,
                Available,
                Available,
                Available,
                Available,
                Available,
                Available,
                Available,
                Available,
                Available,
                Available,
                Available,
                Available
              },
          Name ->
              {
                "Test container 1 for ExperimentBLI tests" <> $SessionUUID,
                "Test container 2 for ExperimentBLI tests" <> $SessionUUID,
                "Test container 3 for ExperimentBLI tests" <> $SessionUUID,
                "Test container 4 for ExperimentBLI tests" <> $SessionUUID,
                "Test container 5 for ExperimentBLI tests" <> $SessionUUID,
                "Test container 6 for ExperimentBLI tests" <> $SessionUUID,
                "Test container 7 for ExperimentBLI tests" <> $SessionUUID,
                "Test container 8 for ExperimentBLI tests" <> $SessionUUID,
                "Test container blank for ExperimentBLI tests" <> $SessionUUID,
                "Test container loading1 for ExperimentBLI tests" <> $SessionUUID,
                "Test container antigen1 for ExperimentBLI tests" <> $SessionUUID,
                "Test container regen1 for ExperimentBLI tests" <> $SessionUUID,
                "Test container regen2 for ExperimentBLI tests" <> $SessionUUID,
                "Test assay plate for ExperimentBLI" <> $SessionUUID,
                "Test probe rack plate for ExperimentBLI" <> $SessionUUID
              },
          FastTrack ->True
        ];

        (* set up test samples to test *)
        {
          sample1,
          sample2,
          sample3,
          sample4,
          sample5,
          sample6,
          sample7,
          sample8,
          blankSolution1,
          loadingSolution1,
          antigenSolution1,
          regenSolution1,
          regenSolution2
        } = UploadSample[
          {
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, StockSolution, "BLI Kinetics Buffer, 1X"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, StockSolution, "2 M HCl"],
            Model[Sample, StockSolution, "1.85 M NaOH"]
          },
          {
            {"A1", container1},
            {"A1", container2},
            {"A1", container3},
            {"A1", container4},
            {"A1", container5},
            {"A1", container6},
            {"A1", container7},
            {"A1", container8},
            {"A1", blankContainer1},
            {"A1", loadingContainer1},
            {"A1", antigenContainer1},
            {"A1", regenContainer1},
            {"A1", regenContainer2}
          },
          InitialAmount ->
              {
                40*Milliliter,
                40*Milliliter,
                40*Milliliter,
                40*Milliliter,
                40*Milliliter,
                40*Milliliter,
                40*Milliliter,
                1.5*Milliliter,
                40*Milliliter,
                40*Milliliter,
                40*Milliliter,
                40*Milliliter,
                40*Milliliter
              },
          Name ->
              {
                "ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID,
                "ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID,
                "ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID,
                "ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID,
                "ExperimentBLI New Test Chemical 5 (20 mL)" <> $SessionUUID,
                "ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID,
                "ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID,
                "ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID,
                "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID,
                "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID,
                "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID,
                "2 M HCl for ExperimentBLI Test (20 mL)" <> $SessionUUID,
                "1.85 M NaOH for ExperimentBLI Test (20 mL)" <> $SessionUUID
              },
          FastTrack->True
        ];

        (* upload the test objects *)
        Upload[<|Object -> #, DeveloperObject -> True, AwaitingStorageUpdate -> Null|> & /@ Cases[Flatten[{container1, container2, container3, container4, container5, container6, container7, container8,
          antigenContainer1, assayPlate, probeRackPlate,
          sample1, sample2, sample3, sample4, sample5,sample6,sample7, sample8, blankSolution1, loadingSolution1, antigenSolution1, regenSolution1, regenSolution2}], ObjectP[]]];

        (* sever model link because it cant be relied on*)
        Upload[Cases[Flatten[
          {
            <|Object -> sample1, Model -> Null|>,
            <|Object -> sample2, Model -> Null|>,
            <|Object -> sample3, Model -> Null|>,
            <|Object -> sample4, Model -> Null|>,
            <|Object -> sample5, Model -> Null|>,
            <|Object -> sample6, Model -> Null|>,
            (*this sample is used for the targetConcentration test and needs a composition with a recognizable analyte in it*)
            <|
              Object -> sample8, Model -> Null,
              Replace[Composition] -> {{90 VolumePercent, Link[Model[Molecule, "id:vXl9j57PmP5D"]]}, {Null, Null}, {0.1 Molar, Link[Model[Molecule, "Sodium Chloride"]]}}
            |>

          }
        ], PacketP[]]];

        Upload[
          {
            <|Object -> assayPlate, Expires -> False|>,
            <|Object -> probeRackPlate, Expires -> False|>
          }
        ];

      ]
    ]
  ),
  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Test bench for ExperimentBLI tests" <> $SessionUUID],
          Object[Item, BLIProbe, "SA probe for ExperimentBLI test" <> $SessionUUID],
          Object[Item, BLIProbe, "ProA probe for BLI test" <> $SessionUUID],
          Object[Part, BLIPlateCover, "Plate Cover for BLI test" <> $SessionUUID],
          Object[Container, Vessel, "Test container 1 for ExperimentBLI tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 2 for ExperimentBLI tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 3 for ExperimentBLI tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 4 for ExperimentBLI tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 5 for ExperimentBLI tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 6 for ExperimentBLI tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 7 for ExperimentBLI tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 8 for ExperimentBLI tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container blank for ExperimentBLI tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container loading1 for ExperimentBLI tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container antigen1 for ExperimentBLI tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container regen1 for ExperimentBLI tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container regen2 for ExperimentBLI tests" <> $SessionUUID],
          Object[Container, Plate,"Test assay plate for ExperimentBLI" <> $SessionUUID],
          Object[Container, Plate, "Test probe rack plate for ExperimentBLI" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 4 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 5 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 6 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 7 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLI New Test Chemical 8 (1.5 mL)" <> $SessionUUID],
          Object[Sample, "BlankSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
          Object[Sample, "LoadingSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
          Object[Sample, "AntigenSolution for ExperimentBLI Test (20 mL)" <> $SessionUUID],
          Object[Sample, "2 M HCl for ExperimentBLI Test (20 mL)" <> $SessionUUID],
          Object[Sample, "1.85 M NaOH for ExperimentBLI Test (20 mL)" <> $SessionUUID],
          Object[Instrument, BioLayerInterferometer, "Test Octet Red96e for ExperimentBLI" <> $SessionUUID],
          Object[Protocol,BioLayerInterferometry,"Test Template Protocol for ExperimentBLI" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ]
  )
];


(* ::Subsection::Closed:: *)
(*ExperimentBioLayerInterferometryPreview*)
DefineTests[
  ExperimentBioLayerInterferometryPreview,
  {
    Example[{Basic,"No preview is currently available for ExperimentBioLayerInterferometry:"},
      ExperimentBioLayerInterferometryPreview[Object[Sample,"ExperimentBLIPreview New Test Chemical 1 (20 mL)" <> $SessionUUID]],
      Null
    ],
    Example[{Additional,"If you wish to understand how the experiment will be performed try using ExperimentBioLayerInterferometryOptions:"},
      ExperimentBioLayerInterferometryOptions[Object[Sample,"ExperimentBLIPreview New Test Chemical 1 (20 mL)" <> $SessionUUID]],
      _Grid
    ],
    Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run:"},
      ValidExperimentBioLayerInterferometryQ[Object[Sample,"ExperimentBLIPreview New Test Chemical 1 (20 mL)" <> $SessionUUID],Verbose->Failures],
      True
    ]
  },

  (*  build test objects *)
  Stubs:>{
    (* I am an important stub that prevents the tester from getting a bunch of notifications *)
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $EmailEnabled=False
  },

  SymbolSetUp :> (
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Test bench for ExperimentBLIPreview tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 1 for ExperimentBLIPreview tests" <> $SessionUUID],
          Object[Sample,"ExperimentBLIPreview New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Item, BLIProbe, "ProA probe for ExperimentBLIPreview test" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ];
    Block[{$AllowSystemsProtocols = True},
      Module[
        {testBench,container1,sample1},
        (* set up test bench as a location for the vessel *)
        testBench = Upload[<|
          Type -> Object[Container, Bench],
          Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
          Name -> "Test bench for ExperimentBLIPreview tests" <> $SessionUUID,
          DeveloperObject -> True,
          StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
          Site -> Link[$Site]
        |>];

        Upload[<|
          Type -> Object[Item, BLIProbe],
          Model -> Link[Model[Item, BLIProbe, "ProA"],Objects],
          Name -> "ProA probe for ExperimentBLIPreview test" <> $SessionUUID,
          Count -> 96,
          Status -> Available,
          ExpirationDate -> DateObject[Now+1 Year],
          Site -> Link[$Site]
        |>];

        (* set up test containers for our samples *)
        container1 = UploadSample[
          Model[Container, Vessel, "id:bq9LA0dBGGR6"], {"Work Surface", testBench},
          Status -> Available,
          Name -> "Test container 1 for ExperimentBLIPreview tests" <> $SessionUUID
        ];

        (* set up test samples to test *)
        sample1 = UploadSample[
          Model[Sample, "Milli-Q water"], {"A1", container1},
          InitialAmount -> 40*Milliliter,
          Name -> "ExperimentBLIPreview New Test Chemical 1 (20 mL)" <> $SessionUUID
        ];

        (* upload the test objects *)
        Upload[<|Object -> #, DeveloperObject -> True, AwaitingStorageUpdate -> Null|> & /@ Cases[Flatten[{container1,sample1}], ObjectP[]]];

      ]
    ]
  ),
  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Test bench for ExperimentBLIPreview tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 1 for ExperimentBLIPreview tests" <> $SessionUUID],
          Object[Sample,"ExperimentBLIPreview New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Item, BLIProbe, "ProA probe for ExperimentBLIPreview test" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ]
  )
];


(* ::Subsection::Closed:: *)
(*ValidExperimentBioLayerInterferometryQ*)



DefineTests[ValidExperimentBioLayerInterferometryQ,
  {
    Example[{Basic, "Returns True if the experiment samples and options are valid:"},
      ValidExperimentBioLayerInterferometryQ[
        Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID]
      ],
      True
    ],
    Example[{Options,OutputFormat,"Return a test summary:"},
      ValidExperimentBioLayerInterferometryQ[Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],OutputFormat->TestSummary],
      _EmeraldTestSummary
    ],
    Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
      ValidExperimentBioLayerInterferometryQ[Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],Verbose->True],
      True
    ],
    (* missingPreMixDiluentsTests *)
    Test["When running tests, returns False if PreMixSolutions are requested but PreMixDiluents is Null for one or more samples:",
      ValidExperimentBioLayerInterferometryQ[
        {
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 3 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning,
        PreMixSolutions -> {
          {100 Microliter, 100 Microliter, 10 Microliter, "101"},
          {100 Microliter, 100 Microliter, 10 Microliter, "201"},
          {100 Microliter, 100 Microliter, 10 Microliter, "301"}
        },
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        BinningType -> PreMix,
        PreMixDiluent -> Null
      ],
      False
    ],
    (*missingPreMixSolutionsTests*)
    Test["When running tests, returns False if a PreMix is selected in BinningType, but the PreMixSolutions are Null:",
      ValidExperimentBioLayerInterferometryQ[
        {
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 3 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        BinningType -> PreMix,
        PreMixSolutions -> {Null, Null, Null}
      ],
      False
    ],
    (*ConflictingDevelopmentDilutionsTests *)
    Test["When running tests, returns False if both Serial and Fixed dilutions are specified for a given sample for DevelopmentType -> ScreenDetectionLimit:",
      ValidExperimentBioLayerInterferometryQ[
        Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        DevelopmentType -> ScreenDetectionLimit,
        DetectionLimitSerialDilutions -> {{2,{"101","102","103","104"}}},
        DetectionLimitFixedDilutions -> {{{2, "201"}, {4, "202"},{6, "203"}, {8, "204"}}},
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      False
    ],
    (*missingDevelopmentDiluentsTests*)
    Test["When running tests, returns False if the DevelopmentDiluent for one or more sample is specified as Null when DevelopmentType -> ScreenDetectionLimit:",
      ValidExperimentBioLayerInterferometryQ[
        Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        DevelopmentType -> ScreenDetectionLimit,
        DetectionLimitDiluent -> {Null},
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      False
    ],
    (*missingDevelopmentDilutionsTests*)
    Test["When running tests, returns False if no dilutions are specified for a sample when Development -> ScreenDetectionLimit:",
      ValidExperimentBioLayerInterferometryQ[
        Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        DevelopmentType -> ScreenDetectionLimit,
        DetectionLimitSerialDilutions -> {Null},
        DetectionLimitFixedDilutions -> {Null},
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      False
    ],
    (*conflictingKineticsDilutionsTests*)
    Test["When running tests, returns False if both Serial and Fixed dilutions are specified for a given sample when ExperimentType-> Kinetics:",
      ValidExperimentBioLayerInterferometryQ[
        Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        KineticsSampleSerialDilutions -> {{2,{"101","102","103","104"}}},
        KineticsSampleFixedDilutions -> {{{2, "201"}, {4, "202"},{6, "203"}, {8, "204"}}},
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      False
    ],
    (*missingKineticsDiluentTests*)
    Test["When running tests, returns False if the KineticsDiluent for one or more sample is specified as Null when ExperimentType -> Kientics:",
      ValidExperimentBioLayerInterferometryQ[
        Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        KineticsSampleDiluent -> Null,
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      False
    ],
    (*missingKineticsDilutionsTests*)
    Test["When running tests, returns False if no dilutions are specified for a sample when ExperimentType -> Kinetics:",
      ValidExperimentBioLayerInterferometryQ[
        Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        KineticsSampleSerialDilutions -> {Null},
        KineticsSampleFixedDilutions -> {Null},
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      False
    ],
    (*missingTimesTests*)
    Test["When running tests, returns False if any options result in one or more elements of assaySequencePrimitives with Time -> Null:",
      ValidExperimentBioLayerInterferometryQ[
        Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
        QuantitateTime -> Null
      ],
      False
    ],
    (*missingShakeRatesTests*)
    Test["When running tests, returns False if any options result in one or more elements of assaySequencePrimitives with ShakeRate -> Null:",
      ValidExperimentBioLayerInterferometryQ[
        Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
        QuantitateShakeRate -> Null
      ],
      False
    ],
    (*missingSolutionsTests*)
    Test["When running tests, returns False if any options result in one or more elements of assaySequencePrimitives without any solutions in it:",
      ValidExperimentBioLayerInterferometryQ[
        Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
        RegenerationType -> {Regenerate},
        RegenerationSolution -> Null
      ],
      False
    ],
    (*conflictingThresholdParameterTests*)
    Test["When running tests, returns False if any options result in one or more elements of assaySequencePrimitives with conflicting threshold parameters:",
      ValidExperimentBioLayerInterferometryQ[
        Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        MeasureAssociationAbsoluteThreshold -> 3 Nanometer,
        MeasureAssociationThresholdSlope -> 3 Nanometer/Minute,
        MeasureAssociationThresholdSlopeDuration -> 10 Minute,
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      False
    ],
    (*missingThresholdCriteriaTests*)
    Test["When running tests, returns False if there are missing threshold parameters in one or more elements of assaySequencePrimitives:",
      ValidExperimentBioLayerInterferometryQ[
        Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        MeasureAssociationThresholdCriterion -> Null,
        MeasureAssociationThresholdSlope -> 3 Nanometer/Minute,
        MeasureAssociationThresholdSlopeDuration -> Null,
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      False
    ],
    (*missingThresholdParametersTests*)
    Test["When running tests, returns False if there are missing threshold parameters in one or more elements of assaySequencePrimitives:",
      ValidExperimentBioLayerInterferometryQ[
        Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        MeasureAssociationThresholdSlope -> 3 Nanometer/Minute,
        MeasureAssociationThresholdSlopeDuration -> Null,
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      False
    ],
    (*invalidSolutionsTests*)
    (*overloadedAssayStepTests*)
    Test["When running tests, returns False if more than one primitive in assaySequencePrimitives have more samples than will fit in a plate column:",
      ValidExperimentBioLayerInterferometryQ[
        Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
        AssaySequencePrimitives -> {
          Equilibrate[Buffers -> ConstantArray[Object[Sample,"ValidExperimentBLIQ New Test Chemical 2 (20 mL)" <> $SessionUUID], 100], Time -> 10 Minute, ShakeRate -> 101 RPM],
          Quantitate[Analytes -> ConstantArray[Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID], 100], Time -> 100 Second, ShakeRate -> 1000 RPM]
        }
      ],
      False
    ],
    (*tooLargePreMixSolutionsTests*)
    Test["When running tests, returns False if one or more PreMixSolutions are greater than the maximum well volume:",
      ValidExperimentBioLayerInterferometryQ[
        Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType ->EpitopeBinning,
        BinningType -> PreMix,
        PreMixSolutions -> {{200 Microliter, 100 Microliter, 0 Microliter, "premix dilution example"}},
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      False
    ],
    (*tooLargeDetectionLimitFixedDilutionsTests*)
    Test["When running tests, returns False if one or more specified Fixed dilution has a volume greater than 2 mL when DevelopmentType -> ScreenDetectionLimit:",
      ValidExperimentBioLayerInterferometryQ[
        Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        DevelopmentType -> ScreenDetectionLimit,
        DetectionLimitFixedDilutions -> {{{2000 Microliter, 100 Microliter, "too large dilution"},{200 Microliter, 100 Microliter, "ok dilution"},{100 Microliter, 100 Microliter, "ok dilution"}}}
      ],
      False
    ],
    (*tooLargeKineticsFixedDilutionsTests*)
    Test["When running tests, returns False if one or more specified Fixed dilution has a volume greater than 2 mL when ExperimentType -> Kinetics:",
      ValidExperimentBioLayerInterferometryQ[
        Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        KineticsSampleFixedDilutions -> {{{2000 Microliter, 100 Microliter, "too large dilution"},{200 Microliter, 100 Microliter, "ok dilution"},{100 Microliter, 100 Microliter, "ok dilution"}}}
      ],
      False
    ],
    (*tooLargeKineticsSerialDilutionsTests*)
    Test["When running tests, returns False if one or more specified Serial dilution has a volume greater than 2 mL when ExperimentType -> Kinetics:",
      ValidExperimentBioLayerInterferometryQ[
        Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        KineticsSampleSerialDilutions -> {{{2000 Microliter, 100 Microliter, "too large dilution"},{200 Microliter, 100 Microliter, "ok dilution"},{100 Microliter, 100 Microliter, "ok dilution"}}}
      ],
      False
    ],
    (*tooLargeDetectionLimitSerialDilutionsTests*)
    Test["When running tests, returns False if one or more specified Serial dilution has a volume greater than 2 mL when DevelopmentType -> ScreenDetectionLimit:",
      ValidExperimentBioLayerInterferometryQ[
        Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        DevelopmentType -> ScreenDetectionLimit,
        DetectionLimitSerialDilutions -> {{{2000 Microliter, 100 Microliter, "too large dilution"},{200 Microliter, 100 Microliter, "ok dilution"},{100 Microliter, 100 Microliter, "ok dilution"}}}
      ],
      False
    ],
    (*validNameTest*)
    Test["When running tests, returns False if the specified protocol name is already in use in the database:",
      ValidExperimentBioLayerInterferometryQ[
        Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
        Name -> "BLIProtocol"
      ],
      False
    ],
    (*insufficientTransferVolumesTests*)
    (*TODO: uncomment when teh resolver error checking is updated *)
    (* Test["When running tests, returns False if the specified dilutions result in transfer volumes which are too small to be accurately measured:",
      ValidExperimentBioLayerInterferometryQ[
        Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        KineticsSampleFixedDilutions -> {{{1000, "dilution with small volume"}, {10000, "other dilution with small transfer"}}}
      ],
      False
    ],
    *)
    (*deprecatedTest*)
    (*tooManyDilutionsTest*)
    Test["When running tests, returns False if more solutions have been specified than can fit in the dilutions plate:",
      ValidExperimentBioLayerInterferometryQ[
        {
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID]
        },
        KineticsSampleSerialDilutions -> {{2, Table[ToString[x], {x, 1, 96}]}},
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Equilibrate -> True
      ],
      False
    ],
    (*forbiddenRepeatedSequenceTests*)
    Test["When running tests, returns False if a RepeatedSequence is specified without specifying AssaySequencePrimitives:",
      ValidExperimentBioLayerInterferometryQ[
        Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
        RepeatedSequence -> {Equilibrate, MeasureBaseline, MeasureAssociation, MeasureDissociation}
      ],
      False
    ],
    (*badRepeatedSequenceTests*)
    Test["When running tests, returns False if the RepeatedSequence is incompatible with the AssaySequencePrimitives:",
      ValidExperimentBioLayerInterferometryQ[
        Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
        AssaySequencePrimitives -> {Quantitate[Analytes -> Samples, Time -> 100 Second, ShakeRate -> 1000 RPM]},
        RepeatedSequence -> {Equilibrate, MeasureBaseline, MeasureAssociation, MeasureDissociation}
      ],
      False
    ],
    (*plateCapacityOverloadTests*)
    Test["When running tests, returns False if more well positions are requested than are available on the assay plate:",
      ValidExperimentBioLayerInterferometryQ[
        {
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 4 (20 mL)" <> $SessionUUID],
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 5 (20 mL)" <> $SessionUUID],
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 6 (20 mL)" <> $SessionUUID],
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 7 (20 mL)" <> $SessionUUID],
          Object[Sample, "BlankSolution for ValidExperimentBLIQ Test (20 mL)" <> $SessionUUID],
          Object[Sample, "LoadingSolution for ValidExperimentBLIQ Test (20 mL)" <> $SessionUUID],
          Object[Sample, "AntigenSolution for ValidExperimentBLIQ Test (20 mL)" <> $SessionUUID],
          Object[Sample, "2 M HCl for ValidExperimentBLIQ Test (20 mL)" <> $SessionUUID],
          Object[Sample, "1.85 M NaOH for ValidExperimentBLIQ Test (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        Equilibrate -> True
      ],
      False
    ],
    (*tooManyRequestedProbesTests*)
    Test["When running tests, returns False if more probes are required than will fit in a single probe rack:",
      ValidExperimentBioLayerInterferometryQ[
        {
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 2 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        NumberOfRepeats -> 12
      ],
      False
    ],
    (*empty container input*)
    Test["When running tests returns False if all containers provided as input to the experiment don't contain samples:",
      ValidExperimentBioLayerInterferometryQ[
        {
          Object[Container, Vessel, "Test container 1 for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 8 for ValidExperimentBLIQ tests" <> $SessionUUID]
        }
      ],
      False
    ]
  },


  (* ========================= *)
  (*  == BUILD TEST OBJECTS == *)
  (* ========================= *)

  Stubs:>{
    $EmailEnabled=False
  },
  SymbolSetUp :> (
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Test bench for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Protocol, BioLayerInterferometry, "BLIProtocol" <> $SessionUUID],
          Object[Item, BLIProbe, "SA probe for ValidExperimentBLIQ test" <> $SessionUUID],
          Object[Item, BLIProbe, "ProA probe for ValidExperimentBLIQ test" <> $SessionUUID],
          Object[Part, BLIPlateCover, "Plate Cover for BLI test" <> $SessionUUID],
          Object[Container, Vessel, "Test container 1 for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 2 for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 3 for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 4 for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 5 for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 6 for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 7 for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 8 for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 9 for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container blank for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container loading1 for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container antigen1 for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container regen1 for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container regen2 for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Plate,"Test assay plate for ValidExperimentBLIQ" <> $SessionUUID],
          Object[Container, Plate, "Test probe rack plate for ValidExperimentBLIQ" <> $SessionUUID],
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 4 (20 mL)" <> $SessionUUID],
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 5 (20 mL)" <> $SessionUUID],
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 6 (20 mL)" <> $SessionUUID],
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 7 (20 mL)" <> $SessionUUID],
          Object[Sample, "BlankSolution for ValidExperimentBLIQ Test (20 mL)" <> $SessionUUID],
          Object[Sample, "LoadingSolution for ValidExperimentBLIQ Test (20 mL)" <> $SessionUUID],
          Object[Sample, "AntigenSolution for ValidExperimentBLIQ Test (20 mL)" <> $SessionUUID],
          Object[Sample, "2 M HCl for ValidExperimentBLIQ Test (20 mL)" <> $SessionUUID],
          Object[Sample, "1.85 M NaOH for ValidExperimentBLIQ Test (20 mL)" <> $SessionUUID],
          Object[Instrument, BioLayerInterferometer, "Test Octet Red96e for ValidExperimentBioLayerInterferometryQ" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ];
    Block[{$AllowSystemsProtocols = True},
      Module[
        {testBench,testPlateCover,testProAProbes,testSAProbes,testProtocol,testInstrument,
          container1, container2, container3, container4, container5, container6, container7, container8, blankContainer1, loadingContainer1, antigenContainer1, regenContainer1, regenContainer2,
          sample1, sample2, sample3, sample4, sample5,sample6,sample7, blankSolution1, loadingSolution1, antigenSolution1, regenSolution1, regenSolution2, assayPlate, probeRackPlate
        },
        (* set up test bench as a location for the vessel *)
        testBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Test bench for ValidExperimentBLIQ tests" <> $SessionUUID, Site -> Link[$Site], DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

        testProtocol = Upload[<|Type-> Object[Protocol, BioLayerInterferometry], Name -> "BLIProtocol"|>];

        (*set up test instrument*)
        testInstrument = Upload[
          <|
            Type -> Object[Instrument, BioLayerInterferometer],
            Name -> "Test Octet Red96e for ValidExperimentBioLayerInterferometryQ" <> $SessionUUID,
            Model -> Link[Model[Instrument,BioLayerInterferometer, "Octet Red96e"], Objects],
            Status -> Available,
            Site -> Link[$Site],
            DeveloperObject -> True
          |>
        ];

        testPlateCover = Upload[<|Type -> Object[Part, BLIPlateCover],
          Model-> Link[Model[Part, BLIPlateCover, "Octet plate cover, 96 well"], Objects],
          Name -> "Plate Cover for BLI test" <> $SessionUUID,
          Status -> Available,
          Site -> Link[$Site],
          ExpirationDate -> DateObject[Now+1 Year]|>];
        testProAProbes = Upload[<|Type -> Object[Item, BLIProbe],
          Model -> Link[Model[Item, BLIProbe, "ProA"],Objects],
          Name -> "ProA probe for ValidExperimentBLIQ test" <> $SessionUUID,
          Count -> 96,
          Status -> Available,
          Site -> Link[$Site],
          ExpirationDate -> DateObject[Now+1 Year]|>];
        testSAProbes = Upload[<|Type -> Object[Item, BLIProbe],
          Model -> Link[Model[Item, BLIProbe, "SA"],Objects],
          Name -> "SA probe for ValidExperimentBLIQ test" <> $SessionUUID,
          Count -> 96,
          Status -> Available,
          Site -> Link[$Site],
          ExpirationDate -> DateObject[Now+1 Year]|>];

        (* set up test containers for our samples *)
        {
          container1,
          container2,
          container3,
          container4,
          container5,
          container6,
          container7,
          container8,
          blankContainer1,
          loadingContainer1,
          antigenContainer1,
          regenContainer1,
          regenContainer2,
          assayPlate,
          probeRackPlate
        } = UploadSample[
          {
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Plate, "id:kEJ9mqR3XELE"],
            Model[Container, Plate, "id:kEJ9mqR3XELE"]
          },
          {
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench}
          },
          Status ->
              {
                Available,
                Available,
                Available,
                Available,
                Available,
                Available,
                Available,
                Available,
                Available,
                Available,
                Available,
                Available,
                Available,
                Available,
                Available
              },
          Name ->
              {
                "Test container 1 for ValidExperimentBLIQ tests" <> $SessionUUID,
                "Test container 2 for ValidExperimentBLIQ tests" <> $SessionUUID,
                "Test container 3 for ValidExperimentBLIQ tests" <> $SessionUUID,
                "Test container 4 for ValidExperimentBLIQ tests" <> $SessionUUID,
                "Test container 5 for ValidExperimentBLIQ tests" <> $SessionUUID,
                "Test container 6 for ValidExperimentBLIQ tests" <> $SessionUUID,
                "Test container 7 for ValidExperimentBLIQ tests" <> $SessionUUID,
                "Test container 8 for ValidExperimentBLIQ tests" <> $SessionUUID,
                "Test container blank for ValidExperimentBLIQ tests" <> $SessionUUID,
                "Test container loading1 for ValidExperimentBLIQ tests" <> $SessionUUID,
                "Test container antigen1 for ValidExperimentBLIQ tests" <> $SessionUUID,
                "Test container regen1 for ValidExperimentBLIQ tests" <> $SessionUUID,
                "Test container regen2 for ValidExperimentBLIQ tests" <> $SessionUUID,
                "Test assay plate for ValidExperimentBLIQ" <> $SessionUUID,
                "Test probe rack plate for ValidExperimentBLIQ" <> $SessionUUID
              },
          FastTrack ->True
        ];

        (* set up test samples to test *)
        {
          sample1,
          sample2,
          sample3,
          sample4,
          sample5,
          sample6,
          sample7,
          blankSolution1,
          loadingSolution1,
          antigenSolution1,
          regenSolution1,
          regenSolution2
        } = UploadSample[
          {
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, StockSolution, "2 M HCl"],
            Model[Sample, StockSolution, "1.85 M NaOH"]
          },
          {
            {"A1", container1},
            {"A1", container2},
            {"A1", container3},
            {"A1", container4},
            {"A1", container5},
            {"A1", container6},
            {"A1", container7},
            {"A1", blankContainer1},
            {"A1", loadingContainer1},
            {"A1", antigenContainer1},
            {"A1", regenContainer1},
            {"A1", regenContainer2}
          },
          InitialAmount ->
              {
                40*Milliliter,
                40*Milliliter,
                40*Milliliter,
                40*Milliliter,
                40*Milliliter,
                40*Milliliter,
                40*Milliliter,
                40*Milliliter,
                40*Milliliter,
                40*Milliliter,
                40*Milliliter,
                40*Milliliter
              },
          Name ->
              {
                "ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID,
                "ValidExperimentBLIQ New Test Chemical 2 (20 mL)" <> $SessionUUID,
                "ValidExperimentBLIQ New Test Chemical 3 (20 mL)" <> $SessionUUID,
                "ValidExperimentBLIQ New Test Chemical 4 (20 mL)" <> $SessionUUID,
                "ValidExperimentBLIQ New Test Chemical 5 (20 mL)" <> $SessionUUID,
                "ValidExperimentBLIQ New Test Chemical 6 (20 mL)" <> $SessionUUID,
                "ValidExperimentBLIQ New Test Chemical 7 (20 mL)" <> $SessionUUID,
                "BlankSolution for ValidExperimentBLIQ Test (20 mL)" <> $SessionUUID,
                "LoadingSolution for ValidExperimentBLIQ Test (20 mL)" <> $SessionUUID,
                "AntigenSolution for ValidExperimentBLIQ Test (20 mL)" <> $SessionUUID,
                "2 M HCl for ValidExperimentBLIQ Test (20 mL)" <> $SessionUUID,
                "1.85 M NaOH for ValidExperimentBLIQ Test (20 mL)" <> $SessionUUID
              },
          FastTrack->True
        ];

        (* upload the test objects *)
        Upload[<|Object -> #, DeveloperObject -> True, AwaitingStorageUpdate -> Null|> & /@ Cases[Flatten[{container1, container2, container3, container4, container5, container6, container7,
          container8, antigenContainer1, assayPlate, probeRackPlate,
          sample1, sample2, sample3, sample4, sample5,sample6,sample7, blankSolution1, loadingSolution1, antigenSolution1, regenSolution1, regenSolution2}], ObjectP[]]];

        (* sever model link because it cant be relied on*)
        Upload[Cases[Flatten[
          {
            <|Object -> sample1, Model -> Null|>,
            <|Object -> sample2, Model -> Null|>,
            <|Object -> sample3, Model -> Null|>,
            <|Object -> sample4, Model -> Null|>,
            <|Object -> sample5, Model -> Null|>,
            <|Object -> sample6, Model -> Null|>,
            <|Object -> sample7, Model -> Null|>
          }
        ], PacketP[]]];

        Upload[
          {
            <|Object -> assayPlate, Expires -> False|>,
            <|Object -> probeRackPlate, Expires -> False|>
          }
        ]
      ]
    ]
  ),
  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Test bench for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Protocol, BioLayerInterferometry, "BLIProtocol" <> $SessionUUID],
          Object[Item, BLIProbe, "SA probe for ValidExperimentBLIQ test" <> $SessionUUID],
          Object[Item, BLIProbe, "ProA probe for ValidExperimentBLIQ test" <> $SessionUUID],
          Object[Part, BLIPlateCover, "Plate Cover for BLI test" <> $SessionUUID],
          Object[Container, Vessel, "Test container 1 for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 2 for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 3 for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 4 for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 5 for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 6 for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 7 for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 8 for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container blank for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container loading1 for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container antigen1 for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container regen1 for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container regen2 for ValidExperimentBLIQ tests" <> $SessionUUID],
          Object[Container, Plate,"Test assay plate for ValidExperimentBLIQ" <> $SessionUUID],
          Object[Container, Plate, "Test probe rack plate for ValidExperimentBLIQ" <> $SessionUUID],
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 4 (20 mL)" <> $SessionUUID],
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 5 (20 mL)" <> $SessionUUID],
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 6 (20 mL)" <> $SessionUUID],
          Object[Sample,"ValidExperimentBLIQ New Test Chemical 7 (20 mL)" <> $SessionUUID],
          Object[Sample, "BlankSolution for ValidExperimentBLIQ Test (20 mL)" <> $SessionUUID],
          Object[Sample, "LoadingSolution for ValidExperimentBLIQ Test (20 mL)" <> $SessionUUID],
          Object[Sample, "AntigenSolution for ValidExperimentBLIQ Test (20 mL)" <> $SessionUUID],
          Object[Sample, "2 M HCl for ValidExperimentBLIQ Test (20 mL)" <> $SessionUUID],
          Object[Sample, "1.85 M NaOH for ValidExperimentBLIQ Test (20 mL)" <> $SessionUUID],
          Object[Instrument, BioLayerInterferometer, "Test Octet Red96e for ValidExperimentBioLayerInterferometryQ" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ]
  )
];



(* ::Subsection::Closed:: *)
(*ExperimentBioLayerInterferometryOptions*)

(* ======================= *)
(* == BLI OPTIONS TESTS == *)
(* ======================= *)

DefineTests[ExperimentBioLayerInterferometryOptions,
  {
    Example[{Basic, "Return a list of options in table form for one sample:"},
      ExperimentBioLayerInterferometryOptions[
        Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID]
        ],
      Graphics_
    ],
    Example[{Basic, "Return a list of options in table form for a Quantitation experiment with one sample:"},
      ExperimentBioLayerInterferometryOptions[Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation
      ],
      Graphics_
    ],
    Example[{Basic, "Return a list of options in table form for an AssayDevelopment experiment with one sample:"},
      ExperimentBioLayerInterferometryOptions[Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      Graphics_
    ],
    Example[{Basic, "Return a list of options in table form for an EpitopeBinning experiment with one sample:"},
      ExperimentBioLayerInterferometryOptions[
        Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> EpitopeBinning,
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"]
      ],
      Graphics_
    ],
    Example[{Basic, "Return a list of options in table form for multiple samples with regeneration:"},
      ExperimentBioLayerInterferometryOptions[
        {
          Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 2 (20 mL)" <> $SessionUUID]
        },
        RegenerationType -> {PreCondition, Neutralize, Wash, Regenerate},
        NeutralizationSolution -> Object[Sample,"ExperimentBLIOptions New Test Chemical 7 (20 mL)" <> $SessionUUID],
        RegenerationCycles -> 1
      ],
      Graphics_,
      Messages:>{Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, OutputFormat, "If OutputFormat -> List, return a list of options rather than a table:"},
      ExperimentBioLayerInterferometryOptions[
        {
          Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 2 (20 mL)" <> $SessionUUID]
        },
        OutputFormat -> List],
      {__Rule}
    ],
    Example[{Options, ProbeRackEquilibration, "Check that the lack of an Equilibrate step will set ProbeRackEquilibration parameters:"},
      options = ExperimentBioLayerInterferometryOptions[
        Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
        Equilibrate -> False,
        OutputFormat -> List
      ];
      Lookup[options, {ProbeRackEquilibration, ProbeRackEquilibrationTime, ProbeRackEquilibrationBuffer}],
      {True, 10 Minute, (ObjectP[Model[Sample]]|ObjectP[Object[Sample]])},
      EquivalenceFunction -> {MatchQ, Equal, MatchQ},
      Variables :> {options}
    ],
    Example[{Options, ExperimentType, "Use the ExperimentType option to set the type of assay to Quantitation:"},
      options = ExperimentBioLayerInterferometryOptions[
        Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Quantitation,
        OutputFormat -> List
      ];
      Lookup[options, ExperimentType],
      Quantitation,
      Variables :> {options}
    ],
    Example[{Options, ExperimentType, "Use the ExperimentType option to set the type of assay to Kinetics:"},
      options = ExperimentBioLayerInterferometryOptions[
        Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        OutputFormat -> List
      ];
      Lookup[options, ExperimentType],
      Kinetics,
      Variables :> {options}
    ],
    Example[{Options, ExperimentType, "Use the ExperimentType option to set the type of assay to EpitopeBinning:"},
      options = ExperimentBioLayerInterferometryOptions[
        Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        BinningAntigen -> Object[Sample, "AntigenSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],
        OutputFormat -> List
      ];
      Lookup[options, ExperimentType],
      EpitopeBinning,
      Variables :> {options}
    ],
    Example[{Options, ExperimentType, "Use the ExperimentType option to set the type of assay to AssayDevelopment:"},
      options = ExperimentBioLayerInterferometryOptions[
        Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> AssayDevelopment,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        OutputFormat -> List
      ];
      Lookup[options, ExperimentType],
      AssayDevelopment,
      Variables :> {options}
    ],
    Example[{Options, BioProbeType, "Use the BioProbeType option to set the probe type that will be used for the assay:"},
      options = ExperimentBioLayerInterferometryOptions[
        Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "ProA"],
        OutputFormat -> List
      ];
      Lookup[options, BioProbeType],
      ObjectP[Model[Item, BLIProbe, "ProA"]],
      Variables :> {options}
    ],


    (* --- Regeneration specific tests --- *)

    Example[{Options, RegenerationType, "Set the RegenerationType option to indicate the placement and types of steps used to return the probe surface to the measurement ready condition:"},
      options = ExperimentBioLayerInterferometryOptions[
        Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
        RegenerationType -> {PreCondition, Wash, Neutralize, Regenerate},
        OutputFormat -> List
      ];
      Lookup[options, RegenerationType],
      {PreCondition, Wash, Neutralize, Regenerate},
      Variables :> {options},
      Messages:>{Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, RegenerationSolution, "Set the RegenerationSolution option to indicate the solution in which the bio-probes will be immersed during a regeneration step:"},
      options = ExperimentBioLayerInterferometryOptions[
        Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
        RegenerationSolution -> Object[Sample, "2 M HCl for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],
        RegenerationType -> {Regenerate},
        OutputFormat -> List];
      Lookup[options, RegenerationSolution],
      ObjectP[Object[Sample, "2 M HCl for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID]],
      Variables :> {options},
      Messages:>{Warning::UnneededBLIProbeRegeneration}
    ],


    (* --- Loading specific tests --- *)

    Example[{Options, LoadingType, "Set the LoadingType to indicate the steps that are included in a probe loading sequence:"},
      options = ExperimentBioLayerInterferometryOptions[
        Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
        LoadingType -> {Load, Activate, Quench},
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],
        ActivateSolution -> Object[Sample,"ExperimentBLIOptions New Test Chemical 6 (20 mL)" <> $SessionUUID],
        QuenchSolution -> Object[Sample,"ExperimentBLIOptions New Test Chemical 7 (20 mL)" <> $SessionUUID],
        OutputFormat -> List
      ];
      Lookup[options, LoadingType],
      {Load, Activate, Quench},
      Variables :> {options}
    ],
    Example[{Options, LoadSolution, "Set the LoadSolution to indicate the solution used to functionalize the probe surface:"},
      options = ExperimentBioLayerInterferometryOptions[
        Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
        LoadingType -> {Load},
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],
        OutputFormat -> List
      ];
      Lookup[options, LoadSolution],
      ObjectP[Object[Sample, "LoadingSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID]],
      Variables :> {options}
    ],


    (* --- Kinetics specific tests --- *)
    Example[{Options, KineticsBaselineBuffer, "Automatically resolve the KineticsBaselineBuffer option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometryOptions[
        Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        OutputFormat -> List
      ];
      Lookup[options, KineticsBaselineBuffer],
      ObjectP[Model[Sample, StockSolution, "BLI Kinetics Buffer, 1X"]],
      Variables :> {options}
    ],
    Example[{Options, KineticsDissociationBuffer, "Automatically resolve the KineticsDissociationBuffer option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometryOptions[
        Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        OutputFormat -> List
      ];
      Lookup[options, KineticsDissociationBuffer],
      ObjectP[Model[Sample, StockSolution, "BLI Kinetics Buffer, 1X"]],
      Variables :> {options}
    ],
    Example[{Options, KineticsBaselineBuffer, "Set the KineticsBaselineBuffer option:"},
      options = ExperimentBioLayerInterferometryOptions[Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        KineticsBaselineBuffer -> Object[Sample,"ExperimentBLIOptions New Test Chemical 2 (20 mL)" <> $SessionUUID],
        OutputFormat -> List];
      Lookup[options, KineticsBaselineBuffer],
      ObjectP[Object[Sample,"ExperimentBLIOptions New Test Chemical 2 (20 mL)" <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, KineticsDissociationBuffer, "Automatically resolve the KineticsDissociationBuffer option based on ExperimentType:"},
      options = ExperimentBioLayerInterferometryOptions[Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        OutputFormat -> List];
      Lookup[options, KineticsDissociationBuffer],
      ObjectP[Model[Sample, StockSolution, "BLI Kinetics Buffer, 1X"]],
      Variables :> {options}
    ],

    (* --- Condensed Primitives from Options tests --- *)
    Example[{Options, AssaySequencePrimitives, "Automatically resolve the AssaySequencePrimitives based on options (Regeneration/Kinetics):"},
      options = ExperimentBioLayerInterferometryOptions[
        Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        RegenerationType->{PreCondition, Regenerate, Neutralize, Wash},
        RegenerationCycles -> 1,
        OutputFormat -> List
      ];
      Lookup[options, AssaySequencePrimitives],
      {Regenerate[_], Neutralize[_], Wash[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]},
      EquivalenceFunction -> MatchQ,
      Variables :> {options},
      Messages:>{Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, AssaySequencePrimitives, "Automatically resolve the AssaySequencePrimitives based on options (Loading/Kinetics):"},
      options = ExperimentBioLayerInterferometryOptions[Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        LoadSolution -> Object[Sample, "LoadingSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],
        ActivateSolution -> Object[Sample,"ExperimentBLIOptions New Test Chemical 6 (20 mL)" <> $SessionUUID],
        QuenchSolution -> Object[Sample,"ExperimentBLIOptions New Test Chemical 7 (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        LoadingType -> {Load, Quench, Activate},
        OutputFormat -> List
      ];
      Lookup[options, AssaySequencePrimitives],
      {ActivateSurface[_],LoadSurface[_], Quench[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]},
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],

    Example[{Options, AssaySequencePrimitives, "Automatically resolve the AssaySequencePrimitives based on options (Basic Quantitation with 9 samples):"},
      options = ExperimentBioLayerInterferometryOptions[
        {
          Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 4 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 5 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 6 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 7 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 2 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> Quantitation,
        OutputFormat -> List
      ];
      Lookup[options, AssaySequencePrimitives],
      {Quantitate[_]},
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],
    Example[{Options, AssaySequencePrimitives, "Automatically resolve the AssaySequencePrimitives based on options (Basic Quantitation with 9 samples with Standard and Blank):"},
      options = ExperimentBioLayerInterferometryOptions[
        {
          Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 4 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 5 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 6 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> Quantitation,
        QuantitationParameters -> {StandardWell, BlankWell},
        QuantitationStandard ->  Object[Sample,"ExperimentBLIOptions New Test Chemical 7 (20 mL)" <> $SessionUUID],
        OutputFormat -> List
      ];
      Lookup[options, AssaySequencePrimitives],
      {Quantitate[_]},
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],
    Example[{Options, AssaySequencePrimitives, "Automatically resolve the AssaySequencePrimitives based on options (Basic Quantitation with 6 samples with Standard, Blank, and StandardCurve):"},
      options = ExperimentBioLayerInterferometryOptions[
        {
          Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 4 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 5 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 6 (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> Quantitation,
        QuantitationParameters -> {StandardWell, BlankWell, StandardCurve},
        Standard -> Object[Sample,"ExperimentBLIOptions New Test Chemical 7 (20 mL)" <> $SessionUUID],
        OutputFormat -> List
      ];
      Lookup[options, AssaySequencePrimitives],
      {Quantitate[_]},
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],

    (* --- Expanded Primitives from Options tests --- *)
    Example[{Options, ExpandedAssaySequencePrimitives, "Automatically resolve the AssaySequencePrimitives based on options (Regeneration/Kinetics):"},
      options = ExperimentBioLayerInterferometryOptions[
        Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        RegenerationType->{PreCondition, Regenerate, Neutralize, Wash},
        NeutralizationSolution -> Object[Sample,"ExperimentBLIOptions New Test Chemical 6 (20 mL)" <> $SessionUUID],
        RegenerationCycles -> 1,
        OutputFormat -> List];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {{Regenerate[_], Neutralize[_], Wash[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]}},
      EquivalenceFunction -> MatchQ,
      Variables :> {options},
      Messages :> {Warning::UnneededBLIProbeRegeneration}
    ],
    Example[{Options, ExpandedAssaySequencePrimitives, "Automatically resolve the AssaySequencePrimitives based on options (Loading/Kinetics):"},
      options = ExperimentBioLayerInterferometryOptions[
        Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        LoadSolution -> Object[Sample,"ExperimentBLIOptions New Test Chemical 6 (20 mL)" <> $SessionUUID],
        LoadingType -> {Load, Quench, Activate},
        ActivateSolution -> Object[Sample,"ExperimentBLIOptions New Test Chemical 7 (20 mL)" <> $SessionUUID],
        QuenchSolution -> Object[Sample, "BlankSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],
        OutputFormat -> List
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {{ActivateSurface[_],LoadSurface[_], Quench[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]}},
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],

    Example[{Options, ExpandedAssaySequencePrimitives, "Automatically resolve the AssaySequencePrimitives based on options (Equilibrate/Kinetics):"},
      options = ExperimentBioLayerInterferometryOptions[
        Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        ExperimentType -> Kinetics,
        Equilibrate -> True,
        OutputFormat -> List
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {{Equilibrate[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]}},
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],
    Example[{Options, ExpandedAssaySequencePrimitives, "Automatically resolve the AssaySequencePrimitives based on options (Basic Quantitation with 9 samples):"},
      options = ExperimentBioLayerInterferometryOptions[
        {
          Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 4 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 5 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 6 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 7 (20 mL)" <> $SessionUUID],
          Object[Sample, "BlankSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],
          Object[Sample, "AntigenSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> Quantitation,
        OutputFormat -> List
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {{Quantitate[_]}, {Quantitate[_]}},
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],
    Example[{Options, ExpandedAssaySequencePrimitives, "Automatically resolve the AssaySequencePrimitives based on options (Basic Quantitation with 8 samples with Standard and Blank):"},
      options = ExperimentBioLayerInterferometryOptions[
        {
          Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 4 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 5 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 6 (20 mL)" <> $SessionUUID],
          Object[Sample, "BlankSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],
          Object[Sample, "AntigenSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> Quantitation,
        QuantitationParameters -> {StandardWell, BlankWell},
        QuantitationStandard -> Object[Sample,"ExperimentBLIOptions New Test Chemical 7 (20 mL)" <> $SessionUUID],
        OutputFormat -> List
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {{Quantitate[_]}, {Quantitate[_]}},
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],
    Example[{Options, ExpandedAssaySequencePrimitives, "Automatically resolve the AssaySequencePrimitives based on options (Basic Quantitation with 8 samples with Standard, Blank, and StandardCurve):"},
      options = ExperimentBioLayerInterferometryOptions[
        {
          Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 4 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 5 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 6 (20 mL)" <> $SessionUUID],
          Object[Sample, "BlankSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],
          Object[Sample, "AntigenSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID]
        },
        ExperimentType -> Quantitation,
        QuantitationParameters -> {StandardWell, BlankWell, StandardCurve},
        Standard -> Object[Sample,"ExperimentBLIOptions New Test Chemical 7 (20 mL)" <> $SessionUUID],
        OutputFormat -> List
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {{Quantitate[_]}, {Quantitate[_]}, {Quantitate[_]}, {Quantitate[_]}},
      EquivalenceFunction -> MatchQ,
      Variables :> {options}
    ],




    (* -- primitive input tests -- *)
    (* --------------------------- *)

    Example[{Options, ExpandedAssaySequencePrimitives, "Set the AssaySequencePrimitives with direct primitive input for ExperimentType -> Kinetics:"},
      options = ExperimentBioLayerInterferometryOptions[ConstantArray[Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],4],
        AssaySequencePrimitives -> {
          Equilibrate[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],1], Time -> 5 Second, ShakeRate -> 1000 RPM],
          ActivateSurface[ActivationSolutions -> ConstantArray[Object[Sample,"ExperimentBLIOptions New Test Chemical 7 (20 mL)" <> $SessionUUID],8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          LoadSurface[LoadingSolutions -> ConstantArray[Object[Sample, "LoadingSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],8], Time -> 10 Second, ShakeRate -> 1000 RPM, ThresholdCriterion -> Single, AbsoluteThreshold -> 0.7 Nanometer],
          Quench[QuenchSolutions -> ConstantArray[Object[Sample,"ExperimentBLIOptions New Test Chemical 6 (20 mL)" <> $SessionUUID],8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          Regenerate[RegenerationSolutions-> ConstantArray[Object[Sample, "2 M HCl for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],8], Time -> 20 Second, ShakeRate -> 200 RPM],
          Wash[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],8], Time -> 20 Second, ShakeRate -> 200 RPM],
          Neutralize[NeutralizationSolutions -> ConstantArray[Object[Sample,"ExperimentBLIOptions New Test Chemical 6 (20 mL)" <> $SessionUUID],8], Time -> 20 Second, ShakeRate -> 200 RPM],
          MeasureBaseline[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          MeasureAssociation[Analytes -> Samples, Time -> 100 Second, ShakeRate -> 1000 RPM],
          MeasureDissociation[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],8], Time -> 10 Second, ShakeRate -> 1000 RPM]
        },
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        OutputFormat -> List
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {{Equilibrate[_], ActivateSurface[_], LoadSurface[_], Quench[_], Regenerate[_], Wash[_], Neutralize[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]},
        {Regenerate[_], Wash[_], Neutralize[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]},
        {Regenerate[_], Wash[_], Neutralize[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]},
        {Regenerate[_], Wash[_], Neutralize[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]}},
      EquivalenceFunction -> MatchQ,
      Variables :> {options},
      Messages:>{Warning::BLIPrimitiveOverride}
    ],

    Example[{Options, ExpandedAssaySequencePrimitives, "Set the AssaySequencePrimitives with direct primitive input for ExperimentType -> Quantitation:"},
      options = ExperimentBioLayerInterferometryOptions[ConstantArray[Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],21],
        AssaySequencePrimitives -> {
          Equilibrate[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],1], Time -> 5 Second, ShakeRate -> 1000 RPM],
          ActivateSurface[ActivationSolutions -> ConstantArray[Object[Sample,"ExperimentBLIOptions New Test Chemical 7 (20 mL)" <> $SessionUUID],8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          LoadSurface[LoadingSolutions -> ConstantArray[Object[Sample, "LoadingSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          Quench[QuenchSolutions -> ConstantArray[Object[Sample,"ExperimentBLIOptions New Test Chemical 5 (20 mL)" <> $SessionUUID],8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          Regenerate[RegenerationSolutions-> ConstantArray[Object[Sample, "2 M HCl for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],8], Time -> 20 Second, ShakeRate -> 200 RPM],
          Wash[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],8], Time -> 20 Second, ShakeRate -> 200 RPM],
          Neutralize[NeutralizationSolutions -> ConstantArray[Object[Sample,"ExperimentBLIOptions New Test Chemical 3 (20 mL)" <> $SessionUUID],8], Time -> 20 Second, ShakeRate -> 200 RPM],
          Quantitate[Analytes -> Samples, Blanks -> Object[Sample, "BlankSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID], Time -> 100 Second, ShakeRate -> 1000 RPM]
        },
        ExperimentType -> Quantitation,
        OutputFormat -> List
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {
        {Equilibrate[_], ActivateSurface[_], LoadSurface[_], Quench[_], Regenerate[_], Wash[_], Neutralize[_], Quantitate[_]},
        {Regenerate[_], Wash[_], Neutralize[_], Quantitate[_]},
        {Regenerate[_], Wash[_], Neutralize[_], Quantitate[_]}
      },
      EquivalenceFunction -> MatchQ,
      Variables :> {options},
      Messages:>{Warning::BLIPrimitiveOverride}
    ],

    Example[{Options, ExpandedAssaySequencePrimitives, "Set the AssaySequencePrimitives with direct primitive input for ExperimentType -> EpitopeBinning:"},
      options = ExperimentBioLayerInterferometryOptions[
        {
          Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 4 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 5 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 6 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 7 (20 mL)" <> $SessionUUID]
        },
        AssaySequencePrimitives -> {
          Equilibrate[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],1], Time -> 5 Second, ShakeRate -> 1000 RPM],
          LoadSurface[
            LoadingSolutions -> {
              Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
              Object[Sample,"ExperimentBLIOptions New Test Chemical 2 (20 mL)" <> $SessionUUID],
              Object[Sample,"ExperimentBLIOptions New Test Chemical 3 (20 mL)" <> $SessionUUID],
              Object[Sample,"ExperimentBLIOptions New Test Chemical 4 (20 mL)" <> $SessionUUID],
              Object[Sample,"ExperimentBLIOptions New Test Chemical 5 (20 mL)" <> $SessionUUID],
              Object[Sample,"ExperimentBLIOptions New Test Chemical 6 (20 mL)" <> $SessionUUID],
              Object[Sample,"ExperimentBLIOptions New Test Chemical 7 (20 mL)" <> $SessionUUID]
            },
            Time -> 10 Second,
            ShakeRate -> 1000 RPM
          ],
          Wash[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          LoadSurface[LoadingSolutions -> ConstantArray[Object[Sample, "AntigenSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          MeasureBaseline[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          MeasureAssociation[Analytes -> Samples, Time -> 100 Second, ShakeRate -> 1000 RPM]
        },
        ExperimentType -> EpitopeBinning,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        OutputFormat -> List
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {
        {Equilibrate[_], LoadSurface[_], Wash[_], LoadSurface[_], MeasureBaseline[_], MeasureAssociation[_]},
        {Equilibrate[_], LoadSurface[_], Wash[_], LoadSurface[_], MeasureBaseline[_], MeasureAssociation[_]},
        {Equilibrate[_], LoadSurface[_], Wash[_], LoadSurface[_], MeasureBaseline[_], MeasureAssociation[_]},
        {Equilibrate[_], LoadSurface[_], Wash[_], LoadSurface[_], MeasureBaseline[_], MeasureAssociation[_]},
        {Equilibrate[_], LoadSurface[_], Wash[_], LoadSurface[_], MeasureBaseline[_], MeasureAssociation[_]},
        {Equilibrate[_], LoadSurface[_], Wash[_], LoadSurface[_], MeasureBaseline[_], MeasureAssociation[_]},
        {Equilibrate[_], LoadSurface[_], Wash[_], LoadSurface[_], MeasureBaseline[_], MeasureAssociation[_]}
      },
      EquivalenceFunction -> MatchQ,
      Variables :> {options},
      Messages:>{Warning::BLIPrimitiveOverride}
    ],

    Example[{Options, ExpandedAssaySequencePrimitives, "Set the AssaySequencePrimitives with direct primitive input for ExperimentType -> AssayDevelopment:"},
      options = ExperimentBioLayerInterferometryOptions[
        {
          Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 2 (20 mL)" <> $SessionUUID]
        },
        AssaySequencePrimitives -> {
          Equilibrate[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],8], Time -> 5 Second, ShakeRate -> 1000 RPM],
          LoadSurface[LoadingSolutions -> ConstantArray[Object[Sample, "LoadingSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          Regenerate[RegenerationSolutions-> ConstantArray[Object[Sample, "2 M HCl for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],8], Time -> 20 Second, ShakeRate -> 200 RPM],
          Wash[Buffers -> ConstantArray[Object[Sample, "BlankSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          MeasureAssociation[Analytes -> Samples, Time -> 100 Second, ShakeRate -> 1000 RPM]
        },
        ExperimentType -> AssayDevelopment,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        OutputFormat -> List
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {{Equilibrate[_], LoadSurface[_], Regenerate[_], Wash[_], MeasureAssociation[_]},
        {Regenerate[_], Wash[_], MeasureAssociation[_]}},
      EquivalenceFunction -> MatchQ,
      Variables :> {options},
      Messages:>{Warning::BLIPrimitiveOverride}
    ],

    Example[{Options, ExpandedAssaySequencePrimitives, "Set the AssaySequencePrimitives with direct primitive input for ExperimentType -> Kinetics:"},
      options = ExperimentBioLayerInterferometryOptions[
        {
          Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 4 (20 mL)" <> $SessionUUID]
        },
        AssaySequencePrimitives -> {
          Equilibrate[Buffers -> ConstantArray[ Object[Sample, "BlankSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],8], Time -> 5 Second, ShakeRate -> 1000 RPM],
          ActivateSurface[ActivationSolutions -> ConstantArray[Object[Sample,"ExperimentBLIOptions New Test Chemical 7 (20 mL)" <> $SessionUUID],8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          LoadSurface[LoadingSolutions -> ConstantArray[Object[Sample, "LoadingSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          Quench[QuenchSolutions -> ConstantArray[Object[Sample,"ExperimentBLIOptions New Test Chemical 6 (20 mL)" <> $SessionUUID],8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          Regenerate[RegenerationSolutions-> ConstantArray[Object[Sample, "2 M HCl for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],8], Time -> 20 Second, ShakeRate -> 200 RPM],
          Wash[Buffers -> ConstantArray[ Object[Sample, "BlankSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],8], Time -> 20 Second, ShakeRate -> 200 RPM],
          Neutralize[NeutralizationSolutions -> ConstantArray[Object[Sample,"ExperimentBLIOptions New Test Chemical 5 (20 mL)" <> $SessionUUID],8], Time -> 20 Second, ShakeRate -> 200 RPM],
          MeasureBaseline[Buffers -> ConstantArray[ Object[Sample, "BlankSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],8], Time -> 10 Second, ShakeRate -> 1000 RPM],
          MeasureAssociation[Analytes -> Samples, Time -> 100 Second, ShakeRate -> 1000 RPM],
          MeasureDissociation[Buffers -> ConstantArray[ Object[Sample, "BlankSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],8], Time -> 10 Second, ShakeRate -> 1000 RPM]
        },
        ExperimentType -> Kinetics,
        BioProbeType -> Model[Item, BLIProbe, "SA"],
        OutputFormat -> List
      ];
      Lookup[options, ExpandedAssaySequencePrimitives],
      {
        {Equilibrate[_], ActivateSurface[_], LoadSurface[_], Quench[_], Regenerate[_], Wash[_], Neutralize[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]},
        {Regenerate[_], Wash[_], Neutralize[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]},
        {Regenerate[_], Wash[_], Neutralize[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]},
        {Regenerate[_], Wash[_], Neutralize[_], MeasureBaseline[_], MeasureAssociation[_], MeasureDissociation[_]}
      },
      EquivalenceFunction -> MatchQ,
      Variables :> {options},
      Messages:>{Warning::BLIPrimitiveOverride}
    ]
  },


  (*  build test objects *)
  Stubs:>{
    $EmailEnabled=False
  },
  SymbolSetUp :> (
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Test bench for ExperimentBLIOptions tests" <> $SessionUUID],
          Object[Item, BLIProbe, "SA probe for ExperimentBLIOptions test" <> $SessionUUID],
          Object[Item, BLIProbe, "ProA probe for ExperimentBLIOptions test" <> $SessionUUID],
          Object[Part, BLIPlateCover, "Plate Cover for BLI test" <> $SessionUUID],
          Object[Container, Vessel, "Test container 1 for ExperimentBLIOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 2 for ExperimentBLIOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 3 for ExperimentBLIOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 4 for ExperimentBLIOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 5 for ExperimentBLIOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 6 for ExperimentBLIOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 7 for ExperimentBLIOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container blank for ExperimentBLIOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container loading1 for ExperimentBLIOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container antigen1 for ExperimentBLIOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container regen1 for ExperimentBLIOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container regen2 for ExperimentBLIOptions tests" <> $SessionUUID],
          Object[Container, Plate,"Test assay plate for ExperimentBLIOptions" <> $SessionUUID],
          Object[Container, Plate, "Test probe rack plate for ExperimentBLIOptions" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 4 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 5 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 6 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 7 (20 mL)" <> $SessionUUID],
          Object[Sample, "BlankSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],
          Object[Sample, "LoadingSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],
          Object[Sample, "AntigenSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],
          Object[Sample, "2 M HCl for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],
          Object[Sample, "1.85 M NaOH for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],
          Object[Instrument, BioLayerInterferometer, "Test Octet Red96e for ExperimentBLIOptions" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ];
    Block[{$AllowSystemsProtocols = True},
      Module[
        {testBench,testPlateCover,testProAProbes,testSAProbes,testInstrument,
          container1, container2, container3, container4, container5, container6, container7, blankContainer1, loadingContainer1, antigenContainer1, regenContainer1, regenContainer2,
          sample1, sample2, sample3, sample4, sample5,sample6,sample7, blankSolution1, loadingSolution1, antigenSolution1, regenSolution1, regenSolution2, assayPlate, probeRackPlate
        },
        (* set up test bench as a location for the vessel *)
        testBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Test bench for ExperimentBLIOptions tests" <> $SessionUUID, Site -> Link[$Site], DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

        testPlateCover = Upload[<|Type -> Object[Part, BLIPlateCover],
          Model-> Link[Model[Part, BLIPlateCover, "Octet plate cover, 96 well"], Objects],
          Name -> "Plate Cover for BLI test" <> $SessionUUID,
          Status -> Available,
          Site -> Link[$Site],
          ExpirationDate -> DateObject[Now+1 Year]|>];
        testProAProbes = Upload[<|Type -> Object[Item, BLIProbe],
          Model -> Link[Model[Item, BLIProbe, "ProA"],Objects],
          Name -> "ProA probe for ExperimentBLIOptions test" <> $SessionUUID,
          Count -> 96,
          Site -> Link[$Site],
          Status -> Available,
          ExpirationDate -> DateObject[Now+1 Year]|>];
        testSAProbes = Upload[<|Type -> Object[Item, BLIProbe],
          Model -> Link[Model[Item, BLIProbe, "SA"],Objects],
          Name -> "SA probe for ExperimentBLIOptions test" <> $SessionUUID,
          Count -> 96,
          Site -> Link[$Site],
          Status -> Available,
          ExpirationDate -> DateObject[Now+1 Year]|>];

        (*set up test instrument*)
        testInstrument = Upload[
          <|
            Type -> Object[Instrument, BioLayerInterferometer],
            Name -> "Test Octet Red96e for ExperimentBLIOptions" <> $SessionUUID,
            Model -> Link[Model[Instrument,BioLayerInterferometer, "Octet Red96e"], Objects],
            Site -> Link[$Site],
            Status -> Available,
            DeveloperObject -> True
          |>
        ];

        (* set up test containers for our samples *)
        {
          container1,
          container2,
          container3,
          container4,
          container5,
          container6,
          container7,
          blankContainer1,
          loadingContainer1,
          antigenContainer1,
          regenContainer1,
          regenContainer2,
          assayPlate,
          probeRackPlate
        } = UploadSample[
          {
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Plate, "id:kEJ9mqR3XELE"],
            Model[Container, Plate, "id:kEJ9mqR3XELE"]
          },
          {
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench}
          },
          Status ->
              {
                Available,
                Available,
                Available,
                Available,
                Available,
                Available,
                Available,
                Available,
                Available,
                Available,
                Available,
                Available,
                Available,
                Available
              },
          Name ->
              {
                "Test container 1 for ExperimentBLIOptions tests" <> $SessionUUID,
                "Test container 2 for ExperimentBLIOptions tests" <> $SessionUUID,
                "Test container 3 for ExperimentBLIOptions tests" <> $SessionUUID,
                "Test container 4 for ExperimentBLIOptions tests" <> $SessionUUID,
                "Test container 5 for ExperimentBLIOptions tests" <> $SessionUUID,
                "Test container 6 for ExperimentBLIOptions tests" <> $SessionUUID,
                "Test container 7 for ExperimentBLIOptions tests" <> $SessionUUID,
                "Test container blank for ExperimentBLIOptions tests" <> $SessionUUID,
                "Test container loading1 for ExperimentBLIOptions tests" <> $SessionUUID,
                "Test container antigen1 for ExperimentBLIOptions tests" <> $SessionUUID,
                "Test container regen1 for ExperimentBLIOptions tests" <> $SessionUUID,
                "Test container regen2 for ExperimentBLIOptions tests" <> $SessionUUID,
                "Test assay plate for ExperimentBLIOptions" <> $SessionUUID,
                "Test probe rack plate for ExperimentBLIOptions" <> $SessionUUID
              },
          FastTrack ->True
        ];

        (* set up test samples to test *)
        {
          sample1,
          sample2,
          sample3,
          sample4,
          sample5,
          sample6,
          sample7,
          blankSolution1,
          loadingSolution1,
          antigenSolution1,
          regenSolution1,
          regenSolution2
        } = UploadSample[
          {
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, StockSolution, "2 M HCl"],
            Model[Sample, StockSolution, "1.85 M NaOH"]
          },
          {
            {"A1", container1},
            {"A1", container2},
            {"A1", container3},
            {"A1", container4},
            {"A1", container5},
            {"A1", container6},
            {"A1", container7},
            {"A1", blankContainer1},
            {"A1", loadingContainer1},
            {"A1", antigenContainer1},
            {"A1", regenContainer1},
            {"A1", regenContainer2}
          },
          InitialAmount ->
              {
                40*Milliliter,
                40*Milliliter,
                40*Milliliter,
                40*Milliliter,
                40*Milliliter,
                40*Milliliter,
                40*Milliliter,
                40*Milliliter,
                40*Milliliter,
                40*Milliliter,
                40*Milliliter,
                40*Milliliter
              },
          Name ->
              {
                "ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID,
                "ExperimentBLIOptions New Test Chemical 2 (20 mL)" <> $SessionUUID,
                "ExperimentBLIOptions New Test Chemical 3 (20 mL)" <> $SessionUUID,
                "ExperimentBLIOptions New Test Chemical 4 (20 mL)" <> $SessionUUID,
                "ExperimentBLIOptions New Test Chemical 5 (20 mL)" <> $SessionUUID,
                "ExperimentBLIOptions New Test Chemical 6 (20 mL)" <> $SessionUUID,
                "ExperimentBLIOptions New Test Chemical 7 (20 mL)" <> $SessionUUID,
                "BlankSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID,
                "LoadingSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID,
                "AntigenSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID,
                "2 M HCl for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID,
                "1.85 M NaOH for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID
              },
          FastTrack->True
        ];

        (* upload the test objects *)
        Upload[<|Object -> #, DeveloperObject -> True, AwaitingStorageUpdate -> Null|> & /@ Cases[Flatten[{container1, container2, container3, container4, container5, container6, container7,
          antigenContainer1, assayPlate, probeRackPlate,
          sample1, sample2, sample3, sample4, sample5,sample6,sample7, blankSolution1, loadingSolution1, antigenSolution1, regenSolution1, regenSolution2}], ObjectP[]]];

        (* sever model link because it cant be relied on*)
        Upload[Cases[Flatten[
          {
            <|Object -> sample1, Model -> Null|>,
            <|Object -> sample2, Model -> Null|>,
            <|Object -> sample3, Model -> Null|>,
            <|Object -> sample4, Model -> Null|>,
            <|Object -> sample5, Model -> Null|>,
            <|Object -> sample6, Model -> Null|>,
            <|Object -> sample7, Model -> Null|>
          }
        ], PacketP[]]];

        Upload[
          {
            <|Object -> assayPlate, Expires -> False|>,
            <|Object -> probeRackPlate, Expires -> False|>
          }
        ];

      ]
    ]
  ),
  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Test bench for ExperimentBLIOptions tests" <> $SessionUUID],
          Object[Item, BLIProbe, "SA probe for ExperimentBLIOptions test" <> $SessionUUID],
          Object[Item, BLIProbe, "ProA probe for ExperimentBLIOptions test" <> $SessionUUID],
          Object[Part, BLIPlateCover, "Plate Cover for BLI test" <> $SessionUUID],
          Object[Container, Vessel, "Test container 1 for ExperimentBLIOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 2 for ExperimentBLIOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 3 for ExperimentBLIOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 4 for ExperimentBLIOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 5 for ExperimentBLIOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 6 for ExperimentBLIOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container 7 for ExperimentBLIOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container blank for ExperimentBLIOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container loading1 for ExperimentBLIOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container antigen1 for ExperimentBLIOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container regen1 for ExperimentBLIOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Test container regen2 for ExperimentBLIOptions tests" <> $SessionUUID],
          Object[Container, Plate,"Test assay plate for ExperimentBLIOptions" <> $SessionUUID],
          Object[Container, Plate, "Test probe rack plate for ExperimentBLIOptions" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 1 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 2 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 3 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 4 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 5 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 6 (20 mL)" <> $SessionUUID],
          Object[Sample,"ExperimentBLIOptions New Test Chemical 7 (20 mL)" <> $SessionUUID],
          Object[Sample, "BlankSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],
          Object[Sample, "LoadingSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],
          Object[Sample, "AntigenSolution for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],
          Object[Sample, "2 M HCl for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],
          Object[Sample, "1.85 M NaOH for ExperimentBLIOptions Test (20 mL)" <> $SessionUUID],
          Object[Instrument, BioLayerInterferometer, "Test Octet Red96e for ExperimentBLIOptions" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ]
  )
];


(* ::Subsection::Closed:: *)
(*Equilibrate*)

DefineTests[Equilibrate,
  {
    Example[{Basic, "Generates a primitive blob with a descriptive icon containing a list of the equilibration buffers and Time and ShakeRate parameters:"},
      Equilibrate[
        Buffers -> {
          Object[Sample, "Sample 1 for Equilibrate Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for Equilibrate Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for Equilibrate Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for Equilibrate Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for Equilibrate Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for Equilibrate Test "<>$SessionUUID],
          Object[Sample, "Sample 7 for Equilibrate Test "<>$SessionUUID],
          Object[Sample, "Sample 8 for Equilibrate Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 400 RPM
      ],
      _Equilibrate
    ],
    Example[{Basic, "Stores the input parameters:"},
      equilPrimitive = Equilibrate[
        Buffers -> {
          Object[Sample, "Sample 1 for Equilibrate Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for Equilibrate Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for Equilibrate Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for Equilibrate Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for Equilibrate Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for Equilibrate Test "<>$SessionUUID],
          Object[Sample, "Sample 7 for Equilibrate Test "<>$SessionUUID],
          Object[Sample, "Sample 8 for Equilibrate Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 1000 RPM
      ];
      Lookup[First[equilPrimitive], {Buffers, Time, ShakeRate}],
      {{
        Object[Sample, "Sample 1 for Equilibrate Test "<>$SessionUUID],
        Object[Sample, "Sample 2 for Equilibrate Test "<>$SessionUUID],
        Object[Sample, "Sample 3 for Equilibrate Test "<>$SessionUUID],
        Object[Sample, "Sample 4 for Equilibrate Test "<>$SessionUUID],
        Object[Sample, "Sample 5 for Equilibrate Test "<>$SessionUUID],
        Object[Sample, "Sample 6 for Equilibrate Test "<>$SessionUUID],
        Object[Sample, "Sample 7 for Equilibrate Test "<>$SessionUUID],
        Object[Sample, "Sample 8 for Equilibrate Test "<>$SessionUUID]
      },
      5 Minute,
      1000 RPM
      },
      Variables:>{equilPrimitive}
    ],
    Example[{Basic, "If parameters are properly informed, the primitive will match ValidBLIPrimitiveP:"},
      equilPrimitive = Equilibrate[
        Buffers -> {
          Object[Sample, "Sample 1 for Equilibrate Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for Equilibrate Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for Equilibrate Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for Equilibrate Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for Equilibrate Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for Equilibrate Test "<>$SessionUUID],
          Object[Sample, "Sample 7 for Equilibrate Test "<>$SessionUUID],
          Object[Sample, "Sample 8 for Equilibrate Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 400 RPM
      ];
      MatchQ[equilPrimitive, ValidBLIPrimitiveP],
      True,
      Variables:>{equilPrimitive}
    ],
    Example[{Basic, "If parameters are not properly informed, the primitive will not match ValidBLIPrimitiveP:"},
      equilPrimitive = Equilibrate[
        Buffers -> {"buffers"},
        Time -> "long time",
        ShakeRate -> "very shake"
      ];
      MatchQ[equilPrimitive, ValidBLIPrimitiveP],
      False,
      Variables:>{equilPrimitive}
    ]
  },
  SymbolSetUp :> (
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Table[Object[Sample,StringJoin["Sample ",ToString[x]," for Equilibrate Test "<>$SessionUUID]], {x,1,10}],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ];
    Module[
      {samples, sampleNames, updatePackets},

      (* reserve IDs *)
      samples = CreateID[ConstantArray[Object[Sample], 10]];

      (* create Names *)
      sampleNames = Table[StringJoin["Sample ",ToString[x]," for Equilibrate Test ",$SessionUUID], {x,1,10}];

      (* make the updates to make these safe deve objects *)
      updatePackets = MapThread[<|Object -> #1, DeveloperObject -> True, Name -> #2, Site -> Link[$Site]|>&,{samples, sampleNames}];
      Upload[updatePackets];
    ]
  ),
  SymbolTearDown :> (
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Table[Object[Sample,StringJoin["Sample ",ToString[x]," for Equilibrate Test "<>$SessionUUID]], {x,1,10}],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ]
  )
];


(* ::Subsection::Closed:: *)
(*Wash*)

DefineTests[Wash,
  {
    Example[{Basic, "Generates a primitive blob with a descriptive icon containing a list of the wash buffers and Time and ShakeRate parameters:"},
      Wash[
        Buffers -> {
          Object[Sample, "Sample 1 for Wash Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for Wash Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for Wash Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for Wash Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for Wash Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for Wash Test "<>$SessionUUID],
          Object[Sample, "Sample 7 for Wash Test "<>$SessionUUID],
          Object[Sample, "Sample 8 for Wash Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 400 RPM
      ],
      _Wash
    ],
    Example[{Basic, "Stores the input parameters:"},
      washPrimitive = Wash[
        Buffers -> {
          Object[Sample, "Sample 1 for Wash Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for Wash Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for Wash Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for Wash Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for Wash Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for Wash Test "<>$SessionUUID],
          Object[Sample, "Sample 7 for Wash Test "<>$SessionUUID],
          Object[Sample, "Sample 8 for Wash Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 1000 RPM
      ];
      Lookup[First[washPrimitive], {Buffers, Time, ShakeRate}],
      {{
        Object[Sample, "Sample 1 for Wash Test "<>$SessionUUID],
        Object[Sample, "Sample 2 for Wash Test "<>$SessionUUID],
        Object[Sample, "Sample 3 for Wash Test "<>$SessionUUID],
        Object[Sample, "Sample 4 for Wash Test "<>$SessionUUID],
        Object[Sample, "Sample 5 for Wash Test "<>$SessionUUID],
        Object[Sample, "Sample 6 for Wash Test "<>$SessionUUID],
        Object[Sample, "Sample 7 for Wash Test "<>$SessionUUID],
        Object[Sample, "Sample 8 for Wash Test "<>$SessionUUID]
      },
        5 Minute,
        1000 RPM
      },
      Variables:>{washPrimitive}
    ],
    Example[{Basic, "If parameters are properly informed, the primitive will match ValidBLIPrimitiveP:"},
      washPrimitive = Wash[
        Buffers -> {
          Object[Sample, "Sample 1 for Wash Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for Wash Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for Wash Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for Wash Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for Wash Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for Wash Test "<>$SessionUUID],
          Object[Sample, "Sample 7 for Wash Test "<>$SessionUUID],
          Object[Sample, "Sample 8 for Wash Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 400 RPM
      ];
      MatchQ[washPrimitive, ValidBLIPrimitiveP],
      True,
      Variables:>{washPrimitive}
    ],
    Example[{Basic, "If parameters are not properly informed, the primitive will not match ValidBLIPrimitiveP:"},
      washPrimitive = Wash[
        Buffers -> {"buffers"},
        Time -> "long time",
        ShakeRate -> "very shake"
      ];
      MatchQ[washPrimitive, ValidBLIPrimitiveP],
      False,
      Variables:>{washPrimitive}
    ]
  },
  SymbolSetUp :> (
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Table[Object[Sample,StringJoin["Sample ",ToString[x]," for Wash Test "<>$SessionUUID]], {x,1,10}],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ];
    Module[
      {samples, sampleNames, updatePackets},

      (* reserve IDs *)
      samples = CreateID[ConstantArray[Object[Sample], 10]];

      (* create Names *)
      sampleNames = Table[StringJoin["Sample ",ToString[x]," for Wash Test ",$SessionUUID], {x,1,10}];

      (* make the updates to make these safe deve objects *)
      updatePackets = MapThread[<|Object -> #1, DeveloperObject -> True, Name -> #2, Site -> Link[$Site]|>&,{samples, sampleNames}];
      Upload[updatePackets];
    ]
  ),
  SymbolTearDown :> (
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Table[Object[Sample,StringJoin["Sample ",ToString[x]," for Wash Test "<>$SessionUUID]], {x,1,10}],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ]
  )
];


(* ::Subsection::Closed:: *)
(*Regenerate*)

DefineTests[Regenerate,
  {
    Example[{Basic, "Generates a primitive blob with a descriptive icon containing a list of the regeneration buffers and Time and ShakeRate parameters:"},
      Regenerate[
        RegenerationSolutions -> {
          Object[Sample, "Sample 1 for Regenerate Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for Regenerate Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for Regenerate Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for Regenerate Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for Regenerate Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for Regenerate Test "<>$SessionUUID],
          Object[Sample, "Sample 7 for Regenerate Test "<>$SessionUUID],
          Object[Sample, "Sample 8 for Regenerate Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 400 RPM
      ],
      _Regenerate
    ],
    Example[{Basic, "Stores the input parameters:"},
      regeneratePrimitive = Regenerate[
        RegenerationSolutions -> {
          Object[Sample, "Sample 1 for Regenerate Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for Regenerate Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for Regenerate Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for Regenerate Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for Regenerate Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for Regenerate Test "<>$SessionUUID],
          Object[Sample, "Sample 7 for Regenerate Test "<>$SessionUUID],
          Object[Sample, "Sample 8 for Regenerate Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 1000 RPM
      ];
      Lookup[First[regeneratePrimitive], {RegenerationSolutions, Time, ShakeRate}],
      {{
        Object[Sample, "Sample 1 for Regenerate Test "<>$SessionUUID],
        Object[Sample, "Sample 2 for Regenerate Test "<>$SessionUUID],
        Object[Sample, "Sample 3 for Regenerate Test "<>$SessionUUID],
        Object[Sample, "Sample 4 for Regenerate Test "<>$SessionUUID],
        Object[Sample, "Sample 5 for Regenerate Test "<>$SessionUUID],
        Object[Sample, "Sample 6 for Regenerate Test "<>$SessionUUID],
        Object[Sample, "Sample 7 for Regenerate Test "<>$SessionUUID],
        Object[Sample, "Sample 8 for Regenerate Test "<>$SessionUUID]
      },
        5 Minute,
        1000 RPM
      },
      Variables:>{regeneratePrimitive}
    ],
    Example[{Basic, "If parameters are properly informed, the primitive will match ValidBLIPrimitiveP:"},
      regeneratePrimitive = Regenerate[
        RegenerationSolutions -> {
          Object[Sample, "Sample 1 for Regenerate Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for Regenerate Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for Regenerate Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for Regenerate Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for Regenerate Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for Regenerate Test "<>$SessionUUID],
          Object[Sample, "Sample 7 for Regenerate Test "<>$SessionUUID],
          Object[Sample, "Sample 8 for Regenerate Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 400 RPM
      ];
      MatchQ[regeneratePrimitive, ValidBLIPrimitiveP],
      True,
      Variables:>{regeneratePrimitive}
    ],
    Example[{Basic, "If parameters are not properly informed, the primitive will not match ValidBLIPrimitiveP:"},
      regeneratePrimitive = Regenerate[
        RegenerationSolutions -> {"buffers"},
        Time -> "long time",
        ShakeRate -> "very shake"
      ];
      MatchQ[regeneratePrimitive, ValidBLIPrimitiveP],
      False,
      Variables:>{regeneratePrimitive}
    ]
  },
  SymbolSetUp :> (
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Table[Object[Sample,StringJoin["Sample ",ToString[x]," for Regenerate Test "<>$SessionUUID]], {x,1,10}],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ];
    Module[
      {samples, sampleNames, updatePackets},

      (* reserve IDs *)
      samples = CreateID[ConstantArray[Object[Sample], 10]];

      (* create Names *)
      sampleNames = Table[StringJoin["Sample ",ToString[x]," for Regenerate Test ",$SessionUUID], {x,1,10}];

      (* make the updates to make these safe deve objects *)
      updatePackets = MapThread[<|Object -> #1, DeveloperObject -> True, Name -> #2, Site -> Link[$Site]|>&,{samples, sampleNames}];
      Upload[updatePackets];
    ]
  ),
  SymbolTearDown :> (
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Table[Object[Sample,StringJoin["Sample ",ToString[x]," for Regenerate Test "<>$SessionUUID]], {x,1,10}],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ]
  )
];


(* ::Subsection::Closed:: *)
(*Neutralize*)

DefineTests[Neutralize,
  {
    Example[{Basic, "Generates a primitive blob with a descriptive icon containing a list of the neutralize buffers and Time and ShakeRate parameters:"},
      Neutralize[
        NeutralizationSolutions -> {
          Object[Sample, "Sample 1 for Neutralize Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for Neutralize Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for Neutralize Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for Neutralize Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for Neutralize Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for Neutralize Test "<>$SessionUUID],
          Object[Sample, "Sample 7 for Neutralize Test "<>$SessionUUID],
          Object[Sample, "Sample 8 for Neutralize Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 400 RPM
      ],
      _Neutralize
    ],
    Example[{Basic, "Stores the input parameters:"},
      neutralizePrimitive = Neutralize[
        NeutralizationSolutions -> {
          Object[Sample, "Sample 1 for Neutralize Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for Neutralize Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for Neutralize Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for Neutralize Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for Neutralize Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for Neutralize Test "<>$SessionUUID],
          Object[Sample, "Sample 7 for Neutralize Test "<>$SessionUUID],
          Object[Sample, "Sample 8 for Neutralize Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 1000 RPM
      ];
      Lookup[First[neutralizePrimitive], {NeutralizationSolutions, Time, ShakeRate}],
      {{
        Object[Sample, "Sample 1 for Neutralize Test "<>$SessionUUID],
        Object[Sample, "Sample 2 for Neutralize Test "<>$SessionUUID],
        Object[Sample, "Sample 3 for Neutralize Test "<>$SessionUUID],
        Object[Sample, "Sample 4 for Neutralize Test "<>$SessionUUID],
        Object[Sample, "Sample 5 for Neutralize Test "<>$SessionUUID],
        Object[Sample, "Sample 6 for Neutralize Test "<>$SessionUUID],
        Object[Sample, "Sample 7 for Neutralize Test "<>$SessionUUID],
        Object[Sample, "Sample 8 for Neutralize Test "<>$SessionUUID]
      },
        5 Minute,
        1000 RPM
      },
      Variables:>{neutralizePrimitive}
    ],
    Example[{Basic, "If parameters are properly informed, the primitive will match ValidBLIPrimitiveP:"},
      neutralizePrimitive = Neutralize[
        NeutralizationSolutions -> {
          Object[Sample, "Sample 1 for Neutralize Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for Neutralize Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for Neutralize Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for Neutralize Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for Neutralize Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for Neutralize Test "<>$SessionUUID],
          Object[Sample, "Sample 7 for Neutralize Test "<>$SessionUUID],
          Object[Sample, "Sample 8 for Neutralize Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 400 RPM
      ];
      MatchQ[neutralizePrimitive, ValidBLIPrimitiveP],
      True,
      Variables:>{neutralizePrimitive}
    ],
    Example[{Basic, "If parameters are not properly informed, the primitive will not match ValidBLIPrimitiveP:"},
      neutralizePrimitive = Neutralize[
        NeutralizationSolutions -> {"buffers"},
        Time -> "long time",
        ShakeRate -> "very shake"
      ];
      MatchQ[neutralizePrimitive, ValidBLIPrimitiveP],
      False,
      Variables:>{neutralizePrimitive}
    ]
  },
  SymbolSetUp :> (
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Table[Object[Sample,StringJoin["Sample ",ToString[x]," for Neutralize Test "<>$SessionUUID]], {x,1,10}],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ];
    Module[
      {samples, sampleNames, updatePackets},

      (* reserve IDs *)
      samples = CreateID[ConstantArray[Object[Sample], 10]];

      (* create Names *)
      sampleNames = Table[StringJoin["Sample ",ToString[x]," for Neutralize Test ",$SessionUUID], {x,1,10}];

      (* make the updates to make these safe deve objects *)
      updatePackets = MapThread[<|Object -> #1, DeveloperObject -> True, Name -> #2, Site -> Link[$Site]|>&,{samples, sampleNames}];
      Upload[updatePackets];
    ]
  ),
  SymbolTearDown :> (
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Table[Object[Sample,StringJoin["Sample ",ToString[x]," for Neutralize Test "<>$SessionUUID]], {x,1,10}],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ]
  )
];


(* ::Subsection::Closed:: *)
(*ActivateSurface*)

DefineTests[ActivateSurface,
  {
    Example[{Basic, "Generates a primitive blob with a descriptive icon containing a list of the activateSurface activationSolutions and Time and ShakeRate parameters:"},
      ActivateSurface[
        ActivationSolutions -> {
          Object[Sample, "Sample 1 for ActivateSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for ActivateSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for ActivateSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for ActivateSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for ActivateSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for ActivateSurface Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 400 RPM,
        Controls -> {Object[Sample, "Sample 9 for ActivateSurface Test "<>$SessionUUID], Object[Sample, "Sample 10 for ActivateSurface Test "<>$SessionUUID]}
      ],
      _ActivateSurface
    ],
    Example[{Basic, "Stores the input parameters:"},
      activateSurfacePrimitive = ActivateSurface[
        ActivationSolutions -> {
          Object[Sample, "Sample 1 for ActivateSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for ActivateSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for ActivateSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for ActivateSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for ActivateSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for ActivateSurface Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 1000 RPM,
        Controls -> {Object[Sample, "Sample 9 for ActivateSurface Test "<>$SessionUUID], Object[Sample, "Sample 10 for ActivateSurface Test "<>$SessionUUID]}
      ];
      Lookup[First[activateSurfacePrimitive], {ActivationSolutions, Time, ShakeRate, Controls}],
      {{
        Object[Sample, "Sample 1 for ActivateSurface Test "<>$SessionUUID],
        Object[Sample, "Sample 2 for ActivateSurface Test "<>$SessionUUID],
        Object[Sample, "Sample 3 for ActivateSurface Test "<>$SessionUUID],
        Object[Sample, "Sample 4 for ActivateSurface Test "<>$SessionUUID],
        Object[Sample, "Sample 5 for ActivateSurface Test "<>$SessionUUID],
        Object[Sample, "Sample 6 for ActivateSurface Test "<>$SessionUUID]
      },
        5 Minute,
        1000 RPM,
        {Object[Sample, "Sample 9 for ActivateSurface Test "<>$SessionUUID], Object[Sample, "Sample 10 for ActivateSurface Test "<>$SessionUUID]}
      },
      Variables:>{activateSurfacePrimitive}
    ],
    Example[{Basic, "If parameters are properly informed, the primitive will match ValidBLIPrimitiveP:"},
      activateSurfacePrimitive = ActivateSurface[
        ActivationSolutions -> {
          Object[Sample, "Sample 1 for ActivateSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for ActivateSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for ActivateSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for ActivateSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for ActivateSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for ActivateSurface Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 400 RPM,
        Controls -> {Object[Sample, "Sample 9 for ActivateSurface Test "<>$SessionUUID], Object[Sample, "Sample 10 for ActivateSurface Test "<>$SessionUUID]}
      ];
      MatchQ[activateSurfacePrimitive, ValidBLIPrimitiveP],
      True,
      Variables:>{activateSurfacePrimitive}
    ],
    Example[{Basic, "If parameters are not properly informed, the primitive will not match ValidBLIPrimitiveP:"},
      activateSurfacePrimitive = ActivateSurface[
        ActivationSolutions -> {"activationSolutions"},
        Time -> "long time",
        ShakeRate -> "very shake",
        Controls -> {"controls"}
      ];
      MatchQ[activateSurfacePrimitive, ValidBLIPrimitiveP],
      False,
      Variables:>{activateSurfacePrimitive}
    ]
  },
  SymbolSetUp :> (
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Table[Object[Sample,StringJoin["Sample ",ToString[x]," for ActivateSurface Test "<>$SessionUUID]], {x,1,10}],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ];
    Module[
      {samples, sampleNames, updatePackets},

      (* reserve IDs *)
      samples = CreateID[ConstantArray[Object[Sample], 10]];

      (* create Names *)
      sampleNames = Table[StringJoin["Sample ",ToString[x]," for ActivateSurface Test ",$SessionUUID], {x,1,10}];

      (* make the updates to make these safe deve objects *)
      updatePackets = MapThread[<|Object -> #1, DeveloperObject -> True, Name -> #2, Site -> Link[$Site]|>&,{samples, sampleNames}];
      Upload[updatePackets];
    ]
  ),
  SymbolTearDown :> (
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Table[Object[Sample,StringJoin["Sample ",ToString[x]," for ActivateSurface Test "<>$SessionUUID]], {x,1,10}],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ]
  )
];


(* ::Subsection::Closed:: *)
(*LoadSurface*)

DefineTests[LoadSurface,
  {
    Example[{Basic, "Generates a primitive blob with a descriptive icon containing a list of the loadingSolutions and Time and ShakeRate parameters:"},
      LoadSurface[
        LoadingSolutions -> {
          Object[Sample, "Sample 1 for LoadSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for LoadSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for LoadSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for LoadSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for LoadSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for LoadSurface Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 400 RPM,
        Controls -> {Object[Sample, "Sample 9 for LoadSurface Test "<>$SessionUUID], Object[Sample, "Sample 10 for LoadSurface Test "<>$SessionUUID]},
        ThresholdCriterion -> Single,
        AbsoluteThreshold -> 2 Nanometer,
        ThresholdSlope -> Null,
        ThresholdSlopeDuration -> Null
      ],
      _LoadSurface
    ],
    Example[{Basic, "Stores the input parameters:"},
      loadSurfacePrimitive = LoadSurface[
        LoadingSolutions -> {
          Object[Sample, "Sample 1 for LoadSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for LoadSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for LoadSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for LoadSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for LoadSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for LoadSurface Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 400 RPM,
        Controls -> {Object[Sample, "Sample 9 for LoadSurface Test "<>$SessionUUID], Object[Sample, "Sample 10 for LoadSurface Test "<>$SessionUUID]},
        ThresholdCriterion -> Single,
        AbsoluteThreshold -> 2 Nanometer,
        ThresholdSlope -> Null,
        ThresholdSlopeDuration -> Null
      ];
      Lookup[First[loadSurfacePrimitive], {LoadingSolutions, Controls,Time, ShakeRate, ThresholdCriterion, AbsoluteThreshold, ThresholdSlope, ThresholdSlopeDuration}],
      {
        {
          Object[Sample, "Sample 1 for LoadSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for LoadSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for LoadSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for LoadSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for LoadSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for LoadSurface Test "<>$SessionUUID]
        },
        {Object[Sample, "Sample 9 for LoadSurface Test "<>$SessionUUID], Object[Sample, "Sample 10 for LoadSurface Test "<>$SessionUUID]},
        5 Minute,
        400 RPM,
        Single,
        2 Nanometer,
        Null,
        Null
      },
      Variables:>{loadSurfacePrimitive}
    ],
    Example[{Basic, "If parameters are properly informed, the primitive will match ValidBLIPrimitiveP:"},
      loadSurfacePrimitive = LoadSurface[
        LoadingSolutions -> {
          Object[Sample, "Sample 1 for LoadSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for LoadSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for LoadSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for LoadSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for LoadSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for LoadSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 7 for LoadSurface Test "<>$SessionUUID],
          Object[Sample, "Sample 8 for LoadSurface Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 400 RPM
      ];
      MatchQ[loadSurfacePrimitive, ValidBLIPrimitiveP],
      True,
      Variables:>{loadSurfacePrimitive}
    ],
    Example[{Basic, "If parameters are not properly informed, the primitive will not match ValidBLIPrimitiveP:"},
      loadSurfacePrimitive = LoadSurface[
        LoadingSolutions -> {"loadingSolutions"},
        Time -> "long time",
        ShakeRate -> "very shake",
        ThresholdSlope -> "big slope"
      ];
      MatchQ[loadSurfacePrimitive, ValidBLIPrimitiveP],
      False,
      Variables:>{loadSurfacePrimitive}
    ]
  },
  SymbolSetUp :> (
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Table[Object[Sample,StringJoin["Sample ",ToString[x]," for LoadSurface Test "<>$SessionUUID]], {x,1,10}],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ];
    Module[
      {samples, sampleNames, updatePackets},

      (* reserve IDs *)
      samples = CreateID[ConstantArray[Object[Sample], 10]];

      (* create Names *)
      sampleNames = Table[StringJoin["Sample ",ToString[x]," for LoadSurface Test ",$SessionUUID], {x,1,10}];

      (* make the updates to make these safe deve objects *)
      updatePackets = MapThread[<|Object -> #1, DeveloperObject -> True, Name -> #2, Site -> Link[$Site]|>&,{samples, sampleNames}];
      Upload[updatePackets];
    ]
  ),
  SymbolTearDown :> (
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Table[Object[Sample,StringJoin["Sample ",ToString[x]," for LoadSurface Test "<>$SessionUUID]], {x,1,10}],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ]
  )
];


(* ::Subsection::Closed:: *)
(*Quench*)

DefineTests[Quench,
  {
    Example[{Basic, "Generates a primitive blob with a descriptive icon containing a list of the quenchSolutions and Time and ShakeRate parameters:"},
      Quench[
        QuenchSolutions -> {
          Object[Sample, "Sample 1 for Quench Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for Quench Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for Quench Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for Quench Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for Quench Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for Quench Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 400 RPM,
        Controls -> {Object[Sample, "Sample 7 for Quench Test "<>$SessionUUID], Object[Sample, "Sample 8 for Quench Test "<>$SessionUUID]}
      ],
      _Quench
    ],
    Example[{Basic, "Stores the input parameters:"},
      quenchPrimitive = Quench[
        QuenchSolutions -> {
          Object[Sample, "Sample 1 for Quench Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for Quench Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for Quench Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for Quench Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for Quench Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for Quench Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 400 RPM,
        Controls -> {Object[Sample, "Sample 7 for Quench Test "<>$SessionUUID], Object[Sample, "Sample 8 for Quench Test "<>$SessionUUID]}
      ];
      Lookup[First[quenchPrimitive], {QuenchSolutions, Controls,Time, ShakeRate}],
      {{
        Object[Sample, "Sample 1 for Quench Test "<>$SessionUUID],
        Object[Sample, "Sample 2 for Quench Test "<>$SessionUUID],
        Object[Sample, "Sample 3 for Quench Test "<>$SessionUUID],
        Object[Sample, "Sample 4 for Quench Test "<>$SessionUUID],
        Object[Sample, "Sample 5 for Quench Test "<>$SessionUUID],
        Object[Sample, "Sample 6 for Quench Test "<>$SessionUUID]
      },
        {Object[Sample, "Sample 7 for Quench Test "<>$SessionUUID], Object[Sample, "Sample 8 for Quench Test "<>$SessionUUID]},
        5 Minute,
        400 RPM
      },
      Variables:>{quenchPrimitive}
    ],
    Example[{Basic, "If parameters are properly informed, the primitive will match ValidBLIPrimitiveP:"},
      quenchPrimitive = Quench[
        QuenchSolutions -> {
          Object[Sample, "Sample 1 for Quench Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for Quench Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for Quench Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for Quench Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for Quench Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for Quench Test "<>$SessionUUID],
          Object[Sample, "Sample 7 for Quench Test "<>$SessionUUID],
          Object[Sample, "Sample 8 for Quench Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 400 RPM
      ];
      MatchQ[quenchPrimitive, ValidBLIPrimitiveP],
      True,
      Variables:>{quenchPrimitive}
    ],
    Example[{Basic, "If parameters are not properly informed, the primitive will not match ValidBLIPrimitiveP:"},
      quenchPrimitive = Quench[
        QuenchSolutions -> {"quenchSolutions"},
        Time -> "long time",
        ShakeRate -> "very shake",
        Controls -> 2
      ];
      MatchQ[quenchPrimitive, ValidBLIPrimitiveP],
      False,
      Variables:>{quenchPrimitive}
    ]
  },
  SymbolSetUp :> (
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Table[Object[Sample,StringJoin["Sample ",ToString[x]," for Quench Test "<>$SessionUUID]], {x,1,10}],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ];
    Module[
      {samples, sampleNames, updatePackets},

      (* reserve IDs *)
      samples = CreateID[ConstantArray[Object[Sample], 10]];

      (* create Names *)
      sampleNames = Table[StringJoin["Sample ",ToString[x]," for Quench Test ",$SessionUUID], {x,1,10}];

      (* make the updates to make these safe deve objects *)
      updatePackets = MapThread[<|Object -> #1, DeveloperObject -> True, Name -> #2, Site -> Link[$Site]|>&,{samples, sampleNames}];
      Upload[updatePackets];
    ]
  ),
  SymbolTearDown :> (
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Table[Object[Sample,StringJoin["Sample ",ToString[x]," for Quench Test "<>$SessionUUID]], {x,1,10}],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ]
  )
];


(* ::Subsection::Closed:: *)
(*MeasureAssociation*)

DefineTests[MeasureAssociation,
  {
    Example[{Basic, "Generates a primitive blob with a descriptive icon containing a list of the measureAssociation analytes and Time and ShakeRate parameters:"},
      MeasureAssociation[
        Analytes -> {
          Object[Sample, "Sample 1 for MeasureAssociation Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for MeasureAssociation Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for MeasureAssociation Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for MeasureAssociation Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for MeasureAssociation Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for MeasureAssociation Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 400 RPM,
        Controls -> {Object[Sample, "Sample 7 for MeasureAssociation Test "<>$SessionUUID], Object[Sample, "Sample 8 for MeasureAssociation Test "<>$SessionUUID]},
        ThresholdCriterion -> Single,
        AbsoluteThreshold -> 2 Nanometer,
        ThresholdSlope -> Null,
        ThresholdSlopeDuration -> Null
      ],
      _MeasureAssociation
    ],
    Example[{Basic, "Stores the input parameters:"},
      measureAssociationPrimitive = MeasureAssociation[
        Analytes -> {
          Object[Sample, "Sample 1 for MeasureAssociation Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for MeasureAssociation Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for MeasureAssociation Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for MeasureAssociation Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for MeasureAssociation Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for MeasureAssociation Test "<>$SessionUUID],
          Object[Sample, "Sample 7 for MeasureAssociation Test "<>$SessionUUID],
          Object[Sample, "Sample 8 for MeasureAssociation Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 1000 RPM,
        Controls -> {Object[Sample, "Sample 7 for MeasureAssociation Test "<>$SessionUUID], Object[Sample, "Sample 8 for MeasureAssociation Test "<>$SessionUUID]},
        ThresholdCriterion -> Single,
        AbsoluteThreshold -> 2 Nanometer,
        ThresholdSlope -> Null,
        ThresholdSlopeDuration -> Null
      ];
      Lookup[First[measureAssociationPrimitive], {Analytes, Controls, Time, ShakeRate, ThresholdCriterion,AbsoluteThreshold, ThresholdSlope, ThresholdSlopeDuration}],
      {{
        Object[Sample, "Sample 1 for MeasureAssociation Test "<>$SessionUUID],
        Object[Sample, "Sample 2 for MeasureAssociation Test "<>$SessionUUID],
        Object[Sample, "Sample 3 for MeasureAssociation Test "<>$SessionUUID],
        Object[Sample, "Sample 4 for MeasureAssociation Test "<>$SessionUUID],
        Object[Sample, "Sample 5 for MeasureAssociation Test "<>$SessionUUID],
        Object[Sample, "Sample 6 for MeasureAssociation Test "<>$SessionUUID],
        Object[Sample, "Sample 7 for MeasureAssociation Test "<>$SessionUUID],
        Object[Sample, "Sample 8 for MeasureAssociation Test "<>$SessionUUID]
      },
        {Object[Sample, "Sample 7 for MeasureAssociation Test "<>$SessionUUID], Object[Sample, "Sample 8 for MeasureAssociation Test "<>$SessionUUID]},
        5 Minute,
        1000 RPM,
        Single,
        2 Nanometer,
        Null,
        Null
      },
      Variables:>{measureAssociationPrimitive}
    ],
    Example[{Basic, "If parameters are properly informed, the primitive will match ValidBLIPrimitiveP:"},
      measureAssociationPrimitive = MeasureAssociation[
        Analytes -> {
          Object[Sample, "Sample 1 for MeasureAssociation Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for MeasureAssociation Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for MeasureAssociation Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for MeasureAssociation Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for MeasureAssociation Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for MeasureAssociation Test "<>$SessionUUID],
          Object[Sample, "Sample 7 for MeasureAssociation Test "<>$SessionUUID],
          Object[Sample, "Sample 8 for MeasureAssociation Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 400 RPM
      ];
      MatchQ[measureAssociationPrimitive, ValidBLIPrimitiveP],
      True,
      Variables:>{measureAssociationPrimitive}
    ],
    Example[{Basic, "If parameters are not properly informed, the primitive will not match ValidBLIPrimitiveP:"},
      measureAssociationPrimitive = MeasureAssociation[
        Analytes -> {"analytes"},
        Time -> "long time",
        ShakeRate -> "very shake"
      ];
      MatchQ[measureAssociationPrimitive, ValidBLIPrimitiveP],
      False,
      Variables:>{measureAssociationPrimitive}
    ]
  },
  SymbolSetUp :> (
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Table[Object[Sample,StringJoin["Sample ",ToString[x]," for MeasureAssociation Test "<>$SessionUUID]], {x,1,10}],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ];
    Module[
      {samples, sampleNames, updatePackets},

      (* reserve IDs *)
      samples = CreateID[ConstantArray[Object[Sample], 10]];

      (* create Names *)
      sampleNames = Table[StringJoin["Sample ",ToString[x]," for MeasureAssociation Test ",$SessionUUID], {x,1,10}];

      (* make the updates to make these safe deve objects *)
      updatePackets = MapThread[<|Object -> #1, DeveloperObject -> True, Name -> #2. Site -> Link[$Site]|>&,{samples, sampleNames}];
      Upload[updatePackets];
    ]
  ),
  SymbolTearDown :> (
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Table[Object[Sample,StringJoin["Sample ",ToString[x]," for MeasureAssociation Test "<>$SessionUUID]], {x,1,10}],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ]
  )
];


(* ::Subsection::Closed:: *)
(*MeasureDissociation*)

DefineTests[MeasureDissociation,
  {
    Example[{Basic, "Generates a primitive blob with a descriptive icon containing a list of the measureDissociation buffers and Time and ShakeRate parameters:"},
      MeasureDissociation[
        Buffers -> {
          Object[Sample, "Sample 1 for MeasureDissociation Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for MeasureDissociation Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for MeasureDissociation Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for MeasureDissociation Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for MeasureDissociation Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for MeasureDissociation Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 1000 RPM,
        Controls -> {Object[Sample, "Sample 7 for MeasureDissociation Test "<>$SessionUUID], Object[Sample, "Sample 8 for MeasureDissociation Test "<>$SessionUUID]},
        ThresholdCriterion -> Single,
        AbsoluteThreshold -> 2 Nanometer,
        ThresholdSlope -> Null,
        ThresholdSlopeDuration -> Null
      ],
      _MeasureDissociation
    ],
    Example[{Basic, "Stores the input parameters:"},
      measureDissociationPrimitive = MeasureDissociation[
        Buffers -> {
          Object[Sample, "Sample 1 for MeasureDissociation Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for MeasureDissociation Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for MeasureDissociation Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for MeasureDissociation Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for MeasureDissociation Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for MeasureDissociation Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 1000 RPM,
        Controls -> {Object[Sample, "Sample 7 for MeasureDissociation Test "<>$SessionUUID], Object[Sample, "Sample 8 for MeasureDissociation Test "<>$SessionUUID]},
        ThresholdCriterion -> Single,
        AbsoluteThreshold -> 2 Nanometer,
        ThresholdSlope -> Null,
        ThresholdSlopeDuration -> Null
      ];
      Lookup[First[measureDissociationPrimitive], {Buffers, Controls, Time, ShakeRate, ThresholdCriterion, AbsoluteThreshold, ThresholdSlope, ThresholdSlopeDuration}],
      {{
        Object[Sample, "Sample 1 for MeasureDissociation Test "<>$SessionUUID],
        Object[Sample, "Sample 2 for MeasureDissociation Test "<>$SessionUUID],
        Object[Sample, "Sample 3 for MeasureDissociation Test "<>$SessionUUID],
        Object[Sample, "Sample 4 for MeasureDissociation Test "<>$SessionUUID],
        Object[Sample, "Sample 5 for MeasureDissociation Test "<>$SessionUUID],
        Object[Sample, "Sample 6 for MeasureDissociation Test "<>$SessionUUID]
      },
        {Object[Sample, "Sample 7 for MeasureDissociation Test "<>$SessionUUID], Object[Sample, "Sample 8 for MeasureDissociation Test "<>$SessionUUID]},
        5 Minute,
        1000 RPM,
        Single,
        2 Nanometer,
        Null,
        Null
      },
      Variables:>{measureDissociationPrimitive}
    ],
    Example[{Basic, "If parameters are properly informed, the primitive will match ValidBLIPrimitiveP:"},
      measureDissociationPrimitive = MeasureDissociation[
        Buffers -> {
          Object[Sample, "Sample 1 for MeasureDissociation Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for MeasureDissociation Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for MeasureDissociation Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for MeasureDissociation Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for MeasureDissociation Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for MeasureDissociation Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 400 RPM,
        Controls -> {Object[Sample, "Sample 7 for MeasureDissociation Test "<>$SessionUUID], Object[Sample, "Sample 8 for MeasureDissociation Test "<>$SessionUUID]},
        ThresholdCriterion -> Single,
        AbsoluteThreshold -> 2 Nanometer,
        ThresholdSlope -> Null,
        ThresholdSlopeDuration -> Null
      ];
      MatchQ[measureDissociationPrimitive, ValidBLIPrimitiveP],
      True,
      Variables:>{measureDissociationPrimitive}
    ],
    Example[{Basic, "If parameters are not properly informed, the primitive will not match ValidBLIPrimitiveP:"},
      measureDissociationPrimitive = MeasureDissociation[
        Buffers -> {"buffers"},
        Time -> "long time",
        ShakeRate -> "very shake"
      ];
      MatchQ[measureDissociationPrimitive, ValidBLIPrimitiveP],
      False,
      Variables:>{measureDissociationPrimitive}
    ]
  },
  SymbolSetUp :> (
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Table[Object[Sample,StringJoin["Sample ",ToString[x]," for MeasureDissociation Test "<>$SessionUUID]], {x,1,10}],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ];
    Module[
      {samples, sampleNames, updatePackets},

      (* reserve IDs *)
      samples = CreateID[ConstantArray[Object[Sample], 10]];

      (* create Names *)
      sampleNames = Table[StringJoin["Sample ",ToString[x]," for MeasureDissociation Test ",$SessionUUID], {x,1,10}];

      (* make the updates to make these safe deve objects *)
      updatePackets = MapThread[<|Object -> #1, DeveloperObject -> True, Name -> #2, Site -> Link[$Site]|>&,{samples, sampleNames}];
      Upload[updatePackets];
    ]
  ),
  SymbolTearDown :> (
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Table[Object[Sample,StringJoin["Sample ",ToString[x]," for MeasureDissociation Test "<>$SessionUUID]], {x,1,10}],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ]
  )
];


(* ::Subsection::Closed:: *)
(*MeasureBaseline*)

DefineTests[MeasureBaseline,
  {
    Example[{Basic, "Generates a primitive blob with a descriptive icon containing a list of the measureBaseline buffers and Time and ShakeRate parameters:"},
      MeasureBaseline[
        Buffers -> {
          Object[Sample, "Sample 1 for MeasureBaseline Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for MeasureBaseline Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for MeasureBaseline Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for MeasureBaseline Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for MeasureBaseline Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for MeasureBaseline Test "<>$SessionUUID],
          Object[Sample, "Sample 7 for MeasureBaseline Test "<>$SessionUUID],
          Object[Sample, "Sample 8 for MeasureBaseline Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 400 RPM
      ],
      _MeasureBaseline
    ],
    Example[{Basic, "Stores the input parameters:"},
      measureBaselinePrimitive = MeasureBaseline[
        Buffers -> {
          Object[Sample, "Sample 1 for MeasureBaseline Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for MeasureBaseline Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for MeasureBaseline Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for MeasureBaseline Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for MeasureBaseline Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for MeasureBaseline Test "<>$SessionUUID],
          Object[Sample, "Sample 7 for MeasureBaseline Test "<>$SessionUUID],
          Object[Sample, "Sample 8 for MeasureBaseline Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 1000 RPM
      ];
      Lookup[First[measureBaselinePrimitive], {Buffers, Time, ShakeRate}],
      {{
        Object[Sample, "Sample 1 for MeasureBaseline Test "<>$SessionUUID],
        Object[Sample, "Sample 2 for MeasureBaseline Test "<>$SessionUUID],
        Object[Sample, "Sample 3 for MeasureBaseline Test "<>$SessionUUID],
        Object[Sample, "Sample 4 for MeasureBaseline Test "<>$SessionUUID],
        Object[Sample, "Sample 5 for MeasureBaseline Test "<>$SessionUUID],
        Object[Sample, "Sample 6 for MeasureBaseline Test "<>$SessionUUID],
        Object[Sample, "Sample 7 for MeasureBaseline Test "<>$SessionUUID],
        Object[Sample, "Sample 8 for MeasureBaseline Test "<>$SessionUUID]
      },
        5 Minute,
        1000 RPM
      },
      Variables:>{measureBaselinePrimitive}
    ],
    Example[{Basic, "If parameters are properly informed, the primitive will match ValidBLIPrimitiveP:"},
      measureBaselinePrimitive = MeasureBaseline[
        Buffers -> {
          Object[Sample, "Sample 1 for MeasureBaseline Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for MeasureBaseline Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for MeasureBaseline Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for MeasureBaseline Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for MeasureBaseline Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for MeasureBaseline Test "<>$SessionUUID],
          Object[Sample, "Sample 7 for MeasureBaseline Test "<>$SessionUUID],
          Object[Sample, "Sample 8 for MeasureBaseline Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 400 RPM
      ];
      MatchQ[measureBaselinePrimitive, ValidBLIPrimitiveP],
      True,
      Variables:>{measureBaselinePrimitive}
    ],
    Example[{Basic, "If parameters are not properly informed, the primitive will not match ValidBLIPrimitiveP:"},
      measureBaselinePrimitive = MeasureBaseline[
        Buffers -> {"buffers"},
        Time -> "long time",
        ShakeRate -> "very shake"
      ];
      MatchQ[measureBaselinePrimitive, ValidBLIPrimitiveP],
      False,
      Variables:>{measureBaselinePrimitive}
    ]
  },
  SymbolSetUp :> (
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Table[Object[Sample,StringJoin["Sample ",ToString[x]," for MeasureBaseline Test "<>$SessionUUID]], {x,1,10}],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ];
    Module[
      {samples, sampleNames, updatePackets},

      (* reserve IDs *)
      samples = CreateID[ConstantArray[Object[Sample], 10]];

      (* create Names *)
      sampleNames = Table[StringJoin["Sample ",ToString[x]," for MeasureBaseline Test ",$SessionUUID], {x,1,10}];

      (* make the updates to make these safe deve objects *)
      updatePackets = MapThread[<|Object -> #1, DeveloperObject -> True, Name -> #2, Site -> Link[$Site]|>&,{samples, sampleNames}];
      Upload[updatePackets];
    ]
  ),
  SymbolTearDown :> (
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Table[Object[Sample,StringJoin["Sample ",ToString[x]," for MeasureBaseline Test "<>$SessionUUID]], {x,1,10}],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ]
  )
];


(* ::Subsection::Closed:: *)
(*Quantitate*)

DefineTests[Quantitate,
  {
    Example[{Basic, "Generates a primitive blob with a descriptive icon containing a list of the quantitate analytes and Time and ShakeRate parameters:"},
      Quantitate[
        Analytes -> {
          Object[Sample, "Sample 1 for Quantitate Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for Quantitate Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for Quantitate Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for Quantitate Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for Quantitate Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for Quantitate Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 400 RPM,
        Controls -> {Object[Sample, "Sample 7 for Quantitate Test "<>$SessionUUID], Object[Sample, "Sample 8 for Quantitate Test "<>$SessionUUID]}
      ],
      _Quantitate
    ],
    Example[{Basic, "Stores the input parameters:"},
      quantitatePrimitive = Quantitate[
        Analytes -> {
          Object[Sample, "Sample 1 for Quantitate Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for Quantitate Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for Quantitate Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for Quantitate Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for Quantitate Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for Quantitate Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 400 RPM,
        Controls -> {Object[Sample, "Sample 7 for Quantitate Test "<>$SessionUUID], Object[Sample, "Sample 8 for Quantitate Test "<>$SessionUUID]}
      ];
      Lookup[First[quantitatePrimitive], {Analytes, Controls,Time, ShakeRate}],
      {{
        Object[Sample, "Sample 1 for Quantitate Test "<>$SessionUUID],
        Object[Sample, "Sample 2 for Quantitate Test "<>$SessionUUID],
        Object[Sample, "Sample 3 for Quantitate Test "<>$SessionUUID],
        Object[Sample, "Sample 4 for Quantitate Test "<>$SessionUUID],
        Object[Sample, "Sample 5 for Quantitate Test "<>$SessionUUID],
        Object[Sample, "Sample 6 for Quantitate Test "<>$SessionUUID]
      },
        {Object[Sample, "Sample 7 for Quantitate Test "<>$SessionUUID], Object[Sample, "Sample 8 for Quantitate Test "<>$SessionUUID]},
        5 Minute,
        400 RPM
      },
      Variables:>{quantitatePrimitive}
    ],
    Example[{Basic, "If parameters are properly informed, the primitive will match ValidBLIPrimitiveP:"},
      quantitatePrimitive = Quantitate[
        Analytes -> {
          Object[Sample, "Sample 1 for Quantitate Test "<>$SessionUUID],
          Object[Sample, "Sample 2 for Quantitate Test "<>$SessionUUID],
          Object[Sample, "Sample 3 for Quantitate Test "<>$SessionUUID],
          Object[Sample, "Sample 4 for Quantitate Test "<>$SessionUUID],
          Object[Sample, "Sample 5 for Quantitate Test "<>$SessionUUID],
          Object[Sample, "Sample 6 for Quantitate Test "<>$SessionUUID],
          Object[Sample, "Sample 7 for Quantitate Test "<>$SessionUUID],
          Object[Sample, "Sample 8 for Quantitate Test "<>$SessionUUID]
        },
        Time -> 5 Minute,
        ShakeRate -> 400 RPM
      ];
      MatchQ[quantitatePrimitive, ValidBLIPrimitiveP],
      True,
      Variables:>{quantitatePrimitive}
    ],
    Example[{Basic, "If parameters are not properly informed, the primitive will not match ValidBLIPrimitiveP:"},
      quantitatePrimitive = Quantitate[
        Analytes -> {"analytes"},
        Time -> "long time",
        ShakeRate -> "very shake"
      ];
      MatchQ[quantitatePrimitive, ValidBLIPrimitiveP],
      False,
      Variables:>{quantitatePrimitive}
    ]
  },
  SymbolSetUp :> (
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Table[Object[Sample,StringJoin["Sample ",ToString[x]," for Quantitate Test "<>$SessionUUID]], {x,1,10}],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ];
    Module[
      {samples, sampleNames, updatePackets},

      (* reserve IDs *)
      samples = CreateID[ConstantArray[Object[Sample], 10]];

      (* create Names *)
      sampleNames = Table[StringJoin["Sample ",ToString[x]," for Quantitate Test ",$SessionUUID], {x,1,10}];

      (* make the updates to make these safe deve objects *)
      updatePackets = MapThread[<|Object -> #1, DeveloperObject -> True, Name -> #2, Site -> Link[$Site]|>&,{samples, sampleNames}];
      Upload[updatePackets];
    ]
  ),
  SymbolTearDown :> (
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Table[Object[Sample,StringJoin["Sample ",ToString[x]," for Quantitate Test "<>$SessionUUID]], {x,1,10}],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ]
  )
];

(* ::Subsection::Closed:: *)