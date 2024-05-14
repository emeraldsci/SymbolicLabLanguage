(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentDNASequencing*)


DefineTests[ExperimentDNASequencing,
  {
    (* ----------- *)
    (* -- BASIC -- *)
    (* ----------- *)
    Example[{Basic, "Determine the nucleotide sequence of a single DNA template sample object prepared by chain-termination polymerase reaction:"},
      ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID]],
      ObjectP[Object[Protocol, DNASequencing]],
      SetUp :> ($CreatedObjects = {}),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic,"Accepts a non-empty container object:"},
      ExperimentDNASequencing[
        Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 1"<>$SessionUUID]
      ],
      ObjectP[Object[Protocol, DNASequencing]],
      SetUp :> ($CreatedObjects = {}),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic,"Accepts a sample object with one specified primer object:"},
      ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test primer sample 1"<>$SessionUUID]
      ],
      ObjectP[Object[Protocol, DNASequencing]],
      SetUp :> ($CreatedObjects = {}),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic,"Accepts multiple sample objects, each with primer objects:"},
      ExperimentDNASequencing[
        {
          Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
          Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID]
        },
        {
          Object[Sample,"ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
          Object[Sample,"ExperimentDNASequencing test primer sample 1"<>$SessionUUID]
        }
      ],
      ObjectP[Object[Protocol, DNASequencing]],
      SetUp :> ($CreatedObjects = {}),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],




    (* ------------- *)
    (* -- OPTIONS -- *)
    (* ------------- *)

    (* --General-- *)
    Example[{Options, Instrument, "Specify the DNA sequencing instrument on which this experiment will be run:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Instrument ->  Object[Instrument, GeneticAnalyzer, "Instrument for ExperimentDNASequencing test"<>$SessionUUID],
        Output -> Options];
      Lookup[options, Instrument],
      ObjectP[Object[Instrument, GeneticAnalyzer, "Instrument for ExperimentDNASequencing test"<>$SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, SequencingCartridge, "Specify the cartridge containing the polymer, capillary array, and anode buffer that fits into the instrument for running the DNA sequencing experiment:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        SequencingCartridge -> Object[Item, Cartridge,DNASequencing,"ExperimentDNASequencing test sequencing cartridge"<>$SessionUUID],
        Output -> Options];
      Lookup[options, SequencingCartridge],
      ObjectP[Object[Item, Cartridge,DNASequencing,"ExperimentDNASequencing test sequencing cartridge"<>$SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, BufferCartridge, "Specify the cartridge containing the cathode buffer and waste container that fits into the instrument for running the DNA sequencing experiment:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        BufferCartridge -> Object[Container, Vessel, BufferCartridge, "Buffer cartridge for ExperimentDNASequencing test"<>$SessionUUID],
        Output -> Options];
      Lookup[options, BufferCartridge],
      ObjectP[Object[Container, Vessel, BufferCartridge, "Buffer cartridge for ExperimentDNASequencing test"<>$SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, Temperature, "Specify the temperature of the capillary array throughout the experiment:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Temperature -> 60 Celsius,
        Output -> Options];
      Lookup[options, Temperature],
      60 Celsius,
      EquivalenceFunction -> Equal,
      SetUp :> ($CreatedObjects = {}),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, Temperature, "Temperature must be specified to the closest 1 Celsius:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Temperature -> 40.5 Celsius,
        Output -> Options];
      Lookup[options, Temperature],
      41 Celsius,
      EquivalenceFunction -> Equal,
      Messages :> {
        Warning::InstrumentPrecision
      },
      Variables :> {options}
    ],

    (* PreparedPlate *)
    Example[{Options,PreparedPlate,"PreparedPlate is automatically set to True if primer input is not specified:"},
      options=ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Output->Options];
      Lookup[options,PreparedPlate],
      True,
      Variables:>{options}
    ],
    Example[{Options,PreparedPlate,"PreparedPlate is automatically set to False if primer input is specified:"},
      options=ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        Output->Options];
      Lookup[options,PreparedPlate],
      False,
      Variables:>{options}
    ],
    Example[{Options,PreparatoryPrimitives,"Specify a series of manipulations which should be performed before the sequencing experiment:"},
      ExperimentDNASequencing["Sequencing Standard Plate",
        {
          PreparatoryPrimitives -> {Define[<|Name -> "Sequencing Standard Plate", Container ->Model[Container,Plate,"id:Z1lqpMz1EnVL"]|>],
            Define[<|Name -> "Resuspended Sequencing Standard", Sample -> Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID]|>],
            Mix[<|Sample -> "Resuspended Sequencing Standard", MixType -> Vortex, Time -> Quantity[1, "Minutes"]|>],
            Incubate[<|Sample -> "Resuspended Sequencing Standard", Time -> Quantity[2, "Minutes"], Temperature -> Quantity[95, "DegreesCelsius"]|>],
            Incubate[<|Sample -> "Resuspended Sequencing Standard", Time -> Quantity[15, "Minutes"], Temperature -> Quantity[0, "DegreesCelsius"]|>],
            Aliquot[
              <|Source -> "Resuspended Sequencing Standard",
                Amounts -> {Quantity[10, "Microliters"], Quantity[10, "Microliters"], Quantity[10, "Microliters"], Quantity[10, "Microliters"]},
                Destinations -> {{"Sequencing Standard Plate", "A1"}, {"Sequencing Standard Plate", "B1"}, {"Sequencing Standard Plate", "C1"}, {"Sequencing Standard Plate", "D1"}}
              |>
            ]
          },
          DyeSet -> "Z_BigDye Terminator v3.1",
          PreparedPlate -> True,
          ReadLength -> 1200,
          Confirm -> False,
          Upload -> True}
      ],
      ObjectP[Object[Protocol,DNASequencing]]
    ],
    Example[{Options,PreparatoryUnitOperations,"Specify a series of manipulations which should be performed before the sequencing experiment:"},
        ExperimentDNASequencing["Sequencing Standard Plate",
          {
            PreparatoryUnitOperations -> {
              LabelContainer[
                Label -> "Sequencing Standard Plate",
                Container ->Model[Container,Plate,"id:Z1lqpMz1EnVL"]
              ],
              LabelSample[
                Label -> "Resuspended Sequencing Standard",
                Sample -> Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID]
              ],
              Mix[
                Sample -> "Resuspended Sequencing Standard",
                MixType -> Vortex,
                Time -> Quantity[1, "Minutes"]
              ],
              Incubate[
                Sample -> "Resuspended Sequencing Standard",
                Time -> Quantity[2, "Minutes"],
                Temperature -> Quantity[95, "DegreesCelsius"]
              ],
              Incubate[
                Sample -> "Resuspended Sequencing Standard",
                Time -> Quantity[15, "Minutes"],
                Temperature -> Quantity[0, "DegreesCelsius"]
              ],
              Transfer[
                Source -> "Resuspended Sequencing Standard",
                Amount -> {Quantity[10, "Microliters"], Quantity[10, "Microliters"], Quantity[10, "Microliters"], Quantity[10, "Microliters"]},
                Destination -> {{"A1", "Sequencing Standard Plate"}, {"B1","Sequencing Standard Plate"}, {"C1", "Sequencing Standard Plate"}, {"D1", "Sequencing Standard Plate"}}
              ]
            },
            DyeSet -> "Z_BigDye Terminator v3.1",
            PreparedPlate -> True,
            ReadLength -> 1200,
            Confirm -> False,
            Upload -> True}
        ],
        ObjectP[Object[Protocol,DNASequencing]]
    ],

    Example[{Options, NumberOfInjections, "Use the NumberOfInjections option to repeat a capillary electrophoresis sequencing run for a template sample:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        NumberOfInjections -> 2,
        Output -> Options];
      Lookup[options, NumberOfInjections],
      2,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (* ReadLength *)
    Example[{Options, ReadLength, "Set the length of the sequence to be analyzed:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        ReadLength -> 520,
        Output -> Options];
      Lookup[options, ReadLength],
      520,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, ReadLength, "Automatically resolve the length of the sequence to be analyzed based on the sequence length of the Composition field of the sample:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Output -> Options];
      Lookup[options, ReadLength],
      500,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (* SampleVolume *)
    Example[{Options, SampleVolume, "Set the volume of DNA template sample used in the polymerase reaction:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        SampleVolume -> 3 Microliter,
        Output -> Options];
      Lookup[options, SampleVolume],
      3 Microliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, SampleVolume, "SampleVolume must be specified to the closest 0.1 Microliter:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        SampleVolume -> 12.51 Microliter,
        Output -> Options];
      Lookup[options, SampleVolume],
      12.5 Microliter,
      EquivalenceFunction -> Equal,
      Messages :> {
        Warning::InstrumentPrecision
      },
      Variables :> {options}
    ],
    Example[{Options, SampleVolume, "Automatically resolve the SampleVolume based on the value of PreparedPlate:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        PreparedPlate -> False,
        Output -> Options];
      Lookup[options, SampleVolume],
      2 Microliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (* ReactionVolume *)
    Example[{Options, ReactionVolume, "Set the total reaction volume for the polymerase reaction:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        ReactionVolume -> 21 Microliter,
        Output -> Options];
      Lookup[options, ReactionVolume],
      21 Microliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, ReactionVolume, "ReactionVolume must be specified to the closest 0.1 Microliter:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        ReactionVolume -> 21.76 Microliter,
        Output -> Options];
      Lookup[options, ReactionVolume],
      21.8 Microliter,
      EquivalenceFunction -> Equal,
      Messages :> {Warning::InstrumentPrecision},
      Variables :> {options}
    ],
    Example[{Options, ReactionVolume, "Automatically resolve the ReactionVolume based on the value of PreparedPlate:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        PreparedPlate -> False,
        Output -> Options];
      Lookup[options, ReactionVolume],
      20 Microliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (* PrimerConcentration *)
    Example[{Options, PrimerConcentration, "Set the primer concentration for the polymerase reaction:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        PrimerConcentration -> 0.2 Micromolar,
        Output -> Options];
      Lookup[options, PrimerConcentration],
      0.2 Micromolar,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, PrimerConcentration, "PrimerConcentration must be specified to the closest 0.1 Picomolar:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        PrimerConcentration -> 5.01 Picomolar,
        Output -> Options];
      Lookup[options, PrimerConcentration],
      5.0 Picomolar,
      EquivalenceFunction -> Equal,
      Messages :> {Warning::InstrumentPrecision},
      Variables :> {options}
    ],
    Example[{Options, PrimerConcentration, "Automatically resolve the PrimerConcentration based on the value of PreparedPlate:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        PreparedPlate -> False,
        Output -> Options];
      Lookup[options, PrimerConcentration],
      0.1 Micromolar,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (* PrimerVolume *)
    Example[{Options, PrimerVolume, "Set the primer volume for the polymerase reaction:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        PrimerVolume -> 3 Microliter,
        Output -> Options];
      Lookup[options, PrimerVolume],
      3 Microliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, PrimerVolume, "PrimerVolume must be specified to the closest 0.1 Microliter:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        PrimerVolume -> 2.61 Microliter,
        Output -> Options];
      Lookup[options, PrimerVolume],
      2.6 Microliter,
      EquivalenceFunction -> Equal,
      Messages :> {Warning::InstrumentPrecision},
      Variables :> {options}
    ],
    Example[{Options, PrimerVolume, "Automatically resolve the PrimerVolume based on the value of PreparedPlate and the equation PrimerConcentration*ReactionVolume/(primer[Composition]):"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        PreparedPlate -> False,
        Output -> Options];
      Lookup[options, PrimerVolume],
      1 Microliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (* PrimerStorageCondition *)
    Example[{Options, PrimerStorageCondition, "Set the primer storage condition for the polymerase reaction:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        PrimerStorageCondition -> Disposal,
        Output -> Options];
      Lookup[options, PrimerStorageCondition],
      Disposal,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
 
    (* MasterMix *)
    Example[{Options, MasterMix, "Specify the stock solution composed of the polymerase, nucleotides, fluorescent dideoxynucleotides, and buffer for the polymerase reaction:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        MasterMix -> Object[Sample,"ExperimentDNASequencing test BigDye Direct MasterMix in 2 mL tube"<>$SessionUUID],
        Output -> Options];
      Lookup[options, MasterMix],
      ObjectP[Object[Sample,"ExperimentDNASequencing test BigDye Direct MasterMix in 2 mL tube"<>$SessionUUID]],
      Variables :> {options}
    ],

    (* MasterMixVolume *)
    Example[{Options, MasterMixVolume, "Set the Master Mix volume for the polymerase reaction:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        MasterMixVolume -> 13 Microliter,
        Output -> Options];
      Lookup[options, MasterMixVolume],
      13 Microliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, MasterMixVolume, "MasterMixVolume must be specified to the closest 0.1 Microliter:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        MasterMixVolume -> 15.01 Microliter,
        Output -> Options];
      Lookup[options, MasterMixVolume],
      15.0 Microliter,
      EquivalenceFunction -> Equal,
      Messages :> {Warning::InstrumentPrecision},
      Variables :> {options}
    ],
    Example[{Options, MasterMixVolume, "Automatically resolve the MasterMixVolume to 0.5*ReactionVolume if PreparedPlate is False:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        PreparedPlate -> False,
        Output -> Options];
      Lookup[options, MasterMixVolume],
      10 Microliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, MasterMixVolume, "MasterMixVolume is automatically set to Null if MasterMix is set to Null:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        MasterMix -> Null,
        DyeSet->"Z_BigDye Direct",
        Output -> Options];
      Lookup[options, MasterMixVolume],
      Null,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (* MasterMixStorageCondition *)
    Example[{Options, MasterMixStorageCondition, "Set the MasterMix storage condition for the polymerase reaction:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        MasterMixStorageCondition -> Disposal,
        Output -> Options];
      Lookup[options, MasterMixStorageCondition],
      Disposal,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (* AdenosineTriphosphateTerminator *)
    Example[{Options, AdenosineTriphosphateTerminator, "Specify the dye molecule (dideoxynucelotide triphosphate) used to terminate DNA chains at locations where the base pair on the opposing strand is thymine:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        AdenosineTriphosphateTerminator -> Model[Molecule,"ExperimentDNASequencing test terminator dye"],
        Output -> Options];
      Lookup[options, AdenosineTriphosphateTerminator],
      ObjectP[Model[Molecule,"ExperimentDNASequencing test terminator dye"]],
      Variables :> {options}
    ],
    Example[{Options, AdenosineTriphosphateTerminator, "Automatically set based on the DyeSet:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        DyeSet -> "Z_BigDye Terminator v3.1",
        Output -> Options];
      Lookup[options, AdenosineTriphosphateTerminator],
      Model[ProprietaryFormulation, "BigDye Terminator v3.1 adenosine triphosphate terminator"],
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (* ThymidineTriphosphateTerminator *)
    Example[{Options, ThymidineTriphosphateTerminator, "Specify the dye molecule (dideoxynucelotide triphosphate) used to terminate DNA chains at locations where the base pair on the opposing strand is adenine:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        ThymidineTriphosphateTerminator -> Model[Molecule,"ExperimentDNASequencing test terminator dye"],
        Output -> Options];
      Lookup[options, ThymidineTriphosphateTerminator],
      ObjectP[Model[Molecule,"ExperimentDNASequencing test terminator dye"]],
      Variables :> {options}
    ],
    Example[{Options, ThymidineTriphosphateTerminator, "Automatically set based on the DyeSet name:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        DyeSet -> "Z_BigDye Terminator v3.1",
        Output -> Options];
      Lookup[options, ThymidineTriphosphateTerminator],
      Model[ProprietaryFormulation, "BigDye Terminator v3.1 thymidine triphosphate terminator"],
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (* GuanosineTriphosphateTerminator *)
    Example[{Options, GuanosineTriphosphateTerminator, "Specify the dye molecule (dideoxynucelotide triphosphate) used to terminate DNA chains at locations where the base pair on the opposing strand is cytosine:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        GuanosineTriphosphateTerminator -> Model[Molecule,"ExperimentDNASequencing test terminator dye"],
        Output -> Options];
      Lookup[options, GuanosineTriphosphateTerminator],
      ObjectP[Model[Molecule,"ExperimentDNASequencing test terminator dye"]],
      Variables :> {options}
    ],
    Example[{Options, GuanosineTriphosphateTerminator, "Automatically set based on the composition of MasterMix:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        DyeSet -> "Z_BigDye Terminator v3.1",
        Output -> Options];
      Lookup[options, GuanosineTriphosphateTerminator],
      Model[ProprietaryFormulation, "BigDye Terminator v3.1 guanosine triphosphate terminator"],
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (* CytosineTriphosphateTerminator *)
    Example[{Options, CytosineTriphosphateTerminator, "Specify the dye molecule (dideoxynucelotide triphosphate) used to terminate DNA chains at locations where the base pair on the opposing strand is guanine:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        CytosineTriphosphateTerminator -> Model[Molecule,"ExperimentDNASequencing test terminator dye"],
        Output -> Options];
      Lookup[options, CytosineTriphosphateTerminator],
      ObjectP[Model[Molecule,"ExperimentDNASequencing test terminator dye"]],
      Variables :> {options}
    ],
    Example[{Options, CytosineTriphosphateTerminator, "Automatically set based on the composition of MasterMix:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        DyeSet -> "Z_BigDye Terminator v3.1",
        Output -> Options];
      Lookup[options, CytosineTriphosphateTerminator],
      Model[ProprietaryFormulation, "BigDye Terminator v3.1 cytosine triphosphate terminator"],
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (* Diluent *)
    Example[{Options, Diluent, "Specify the solution for bringing each reaction to ReactionVolume once all the reaction components (template, primers, and master mix) are added:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        Diluent -> Model[Sample,"Nuclease-free Water"],
        Output -> Options];
      Lookup[options, Diluent],
      ObjectP[Model[Sample,"Nuclease-free Water"]],
      Variables :> {options}
    ],

    (* DiluentVolume *)
    Example[{Options, DiluentVolume, "Set the diluent volume for the polymerase reaction:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        DiluentVolume -> 5 Microliter,
        Output -> Options];
      Lookup[options, DiluentVolume],
      5 Microliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DiluentVolume, "DiluentVolume must be specified to the closest 0.1 Microliter:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        DiluentVolume -> 7.01 Microliter,
        Output -> Options];
      Lookup[options, DiluentVolume],
      7.0 Microliter,
      EquivalenceFunction -> Equal,
      Messages :> {Warning::InstrumentPrecision},
      Variables :> {options}
    ],
    Example[{Options, DiluentVolume, "Automatically resolve the DiluentVolume based on the equation ReactionVolume - (SampleVolume + MasterMixVolume + PrimerVolume) when PreparedPlate is False:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        PreparedPlate -> False,
        Output -> Options];
      Lookup[options, DiluentVolume],
      7. Microliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],


    (* --------------------- *)
    (* -----PCR Options----- *)
    (* --------------------- *)

    (*---Activation options---*)

    (*Activation*)
    Example[{Options,Activation,"Activation is automatically set to Null if PreparedPlate is True:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        PreparedPlate->True,
        ReadLength->700
      ];
      Download[options,Activation],
      Null,
      Variables:>{options}
    ],
    Example[{Options,Activation,"Activation is automatically set to True if any of the other Activation options are set:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        ActivationTime->30 Second,
        Output->Options
      ];
      Lookup[options,Activation],
      True,
      Variables:>{options}
    ],
    (*ActivationTime*)
    Example[{Options,ActivationTime,"ActivationTime is automatically set to Null if Activation is set to False:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        Activation->False,
        Output->Options
      ];
      Lookup[options,ActivationTime],
      Null,
      Variables:>{options}
    ],
    Example[{Options,ActivationTime,"ActivationTime is automatically set to 60 seconds if Activation is set to True:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        Activation->True,
        Output->Options
      ];
      Lookup[options,ActivationTime],
      60 Second,
      Variables:>{options}
    ],
    Example[{Options,ActivationTime,"ActivationTime can be specified:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        ActivationTime->22 Second,
        Output->Options
      ];
      Lookup[options,ActivationTime],
      22 Second,
      Variables:>{options}
    ],
    Example[{Options,ActivationTime,"ActivationTime, if specified, is rounded to the nearest second:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        ActivationTime->22.2 Second,
        Output->Options
      ];
      Lookup[options,ActivationTime],
      22 Second,
      EquivalenceFunction->Equal,
      Messages:>{
        Warning::InstrumentPrecision
      },
      Variables:>{options}
    ],
    (*ActivationTemperature*)
    Example[{Options,ActivationTemperature,"ActivationTemperature is automatically set to Null if Activation is set to False:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        Output->Options
      ];
      Lookup[options,ActivationTemperature],
      Null,
      Variables:>{options}
    ],
    Example[{Options,ActivationTemperature,"ActivationTemperature is automatically set to 95 degrees Celsius if Activation is set to True:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        Activation->True,
        Output->Options
      ];
      Lookup[options,ActivationTemperature],
      95 Celsius,
      Variables:>{options}
    ],
    Example[{Options,ActivationTemperature,"ActivationTemperature can be specified:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        ActivationTemperature->102.2 Celsius,
        Output->Options
      ];
      Lookup[options,ActivationTemperature],
      102.2 Celsius,
      Variables:>{options}
    ],
    Example[{Options,ActivationTemperature,"ActivationTemperature, if specified, is rounded to the nearest 0.1 degree Celsius:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        ActivationTemperature->102.22 Celsius,
        Output->Options
      ];
      Lookup[options,ActivationTemperature],
      102.2 Celsius,
      EquivalenceFunction->Equal,
      Messages:>{
        Warning::InstrumentPrecision
      },
      Variables:>{options}
    ],
    (*ActivationRampRate*)
    Example[{Options,ActivationRampRate,"ActivationRampRate is automatically set to Null if Activation is set to False:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        Output->Options
      ];
      Lookup[options,ActivationRampRate],
      Null,
      Variables:>{options}
    ],
    Example[{Options,ActivationRampRate,"ActivationRampRate is automatically set to 3.5 degrees Celsius per second if Activation is set to True:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        Activation->True,
        Output->Options
      ];
      Lookup[options,ActivationRampRate],
      3.5 (Celsius/Second),
      Variables:>{options}
    ],
    Example[{Options,ActivationRampRate,"ActivationRampRate can be specified:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        ActivationRampRate->1.2 (Celsius/Second),
        Output->Options
      ];
      Lookup[options,ActivationRampRate],
      1.2 (Celsius/Second),
      Variables:>{options}
    ],
    Example[{Options,ActivationRampRate,"ActivationRampRate, if specified, is rounded to the nearest 0.1 degree Celsius/Second:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        ActivationRampRate->1.22 (Celsius/Second),
        Output->Options
      ];
      Lookup[options,ActivationRampRate],
      1.2 (Celsius/Second),
      EquivalenceFunction->Equal,
      Messages:>{
        Warning::InstrumentPrecision
      },
      Variables:>{options}
    ],


    (*---Denaturation options---*)

    (*DenaturationTime*)
    Example[{Options,DenaturationTime,"DenaturationTime can be specified:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        DenaturationTime->22 Second,
        Output->Options
      ];
      Lookup[options,DenaturationTime],
      22 Second,
      Variables:>{options}
    ],
    Example[{Options,DenaturationTime,"DenaturationTime, if specified, is rounded to the nearest second:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        DenaturationTime->22.2 Second,
        Output->Options
      ];
      Lookup[options,DenaturationTime],
      22 Second,
      EquivalenceFunction->Equal,
      Messages:>{
        Warning::InstrumentPrecision
      },
      Variables:>{options}
    ],
    (*DenaturationTemperature*)
    Example[{Options,DenaturationTemperature,"DenaturationTemperature can be specified:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        DenaturationTemperature->102.2 Celsius,
        Output->Options
      ];
      Lookup[options,DenaturationTemperature],
      102.2 Celsius,
      Variables:>{options}
    ],
    Example[{Options,DenaturationTemperature,"DenaturationTemperature, if specified, is rounded to the nearest 0.1 degree Celsius:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        DenaturationTemperature->102.22 Celsius,
        Output->Options
      ];
      Lookup[options,DenaturationTemperature],
      102.2 Celsius,
      EquivalenceFunction->Equal,
      Messages:>{
        Warning::InstrumentPrecision
      },
      Variables:>{options}
    ],
    (*DenaturationRampRate*)
    Example[{Options,DenaturationRampRate,"DenaturationRampRate can be specified:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        DenaturationRampRate->1.2 (Celsius/Second),
        Output->Options
      ];
      Lookup[options,DenaturationRampRate],
      1.2 (Celsius/Second),
      Variables:>{options}
    ],
    Example[{Options,DenaturationRampRate,"DenaturationRampRate, if specified, is rounded to the nearest 0.1 degree Celsius/Second:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        DenaturationRampRate->1.22 (Celsius/Second),
        Output->Options
      ];
      Lookup[options,DenaturationRampRate],
      1.2 (Celsius/Second),
      EquivalenceFunction->Equal,
      Messages:>{
        Warning::InstrumentPrecision
      },
      Variables:>{options}
    ],


    (*---Primer annealing options---*)

    (*PrimerAnnealing*)
    Example[{Options,PrimerAnnealing,"PrimerAnnealing is automatically set to False if none of the other PrimerAnnealing options are set:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        Output->Options
      ];
      Lookup[options,PrimerAnnealing],
      False,
      Variables:>{options}
    ],
    Example[{Options,PrimerAnnealing,"PrimerAnnealing is automatically set to True if any of the other PrimerAnnealing options are set:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        PrimerAnnealingTime->30 Second,
        Output->Options
      ];
      Lookup[options,PrimerAnnealing],
      True,
      Variables:>{options}
    ],
    (*PrimerAnnealingTime*)
    Example[{Options,PrimerAnnealingTime,"PrimerAnnealingTime is automatically set to Null if PrimerAnnealing is set to False:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        Output->Options
      ];
      Lookup[options,PrimerAnnealingTime],
      Null,
      Variables:>{options}
    ],
    Example[{Options,PrimerAnnealingTime,"PrimerAnnealingTime is automatically set to 30 seconds if PrimerAnnealing is set to True:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        PrimerAnnealing->True,
        Output->Options
      ];
      Lookup[options,PrimerAnnealingTime],
      30 Second,
      Variables:>{options}
    ],
    Example[{Options,PrimerAnnealingTime,"PrimerAnnealingTime can be specified:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        PrimerAnnealingTime->22 Second,
        Output->Options
      ];
      Lookup[options,PrimerAnnealingTime],
      22 Second,
      Variables:>{options}
    ],
    Example[{Options,PrimerAnnealingTime,"PrimerAnnealingTime, if specified, is rounded to the nearest second:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        PrimerAnnealingTime->22.2 Second,
        Output->Options
      ];
      Lookup[options,PrimerAnnealingTime],
      22 Second,
      EquivalenceFunction->Equal,
      Messages:>{
        Warning::InstrumentPrecision
      },
      Variables:>{options}
    ],
    (*PrimerAnnealingTemperature*)
    Example[{Options,PrimerAnnealingTemperature,"PrimerAnnealingTemperature is automatically set to Null if PrimerAnnealing is set to False:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        Output->Options
      ];
      Lookup[options,PrimerAnnealingTemperature],
      Null,
      Variables:>{options}
    ],
    Example[{Options,PrimerAnnealingTemperature,"PrimerAnnealingTemperature is automatically set to 60 degrees Celsius if PrimerAnnealing is set to True:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        PrimerAnnealing->True,
        Output->Options
      ];
      Lookup[options,PrimerAnnealingTemperature],
      60 Celsius,
      Variables:>{options}
    ],
    Example[{Options,PrimerAnnealingTemperature,"PrimerAnnealingTemperature can be specified:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        PrimerAnnealingTemperature->102.2 Celsius,
        Output->Options
      ];
      Lookup[options,PrimerAnnealingTemperature],
      102.2 Celsius,
      Variables:>{options}
    ],
    Example[{Options,PrimerAnnealingTemperature,"PrimerAnnealingTemperature, if specified, is rounded to the nearest 0.1 degree Celsius:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        PrimerAnnealingTemperature->102.22 Celsius,
        Output->Options
      ];
      Lookup[options,PrimerAnnealingTemperature],
      102.2 Celsius,
      EquivalenceFunction->Equal,
      Messages:>{
        Warning::InstrumentPrecision
      },
      Variables:>{options}
    ],
    (*PrimerAnnealingRampRate*)
    Example[{Options,PrimerAnnealingRampRate,"PrimerAnnealingRampRate is automatically set to Null if PrimerAnnealing is set to False:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        Output->Options
      ];
      Lookup[options,PrimerAnnealingRampRate],
      Null,
      Variables:>{options}
    ],
    Example[{Options,PrimerAnnealingRampRate,"PrimerAnnealingRampRate is automatically set to 3.5 degrees Celsius per second if PrimerAnnealing is set to True:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        PrimerAnnealing->True,
        Output->Options
      ];
      Lookup[options,PrimerAnnealingRampRate],
      3.5 (Celsius/Second),
      Variables:>{options}
    ],
    Example[{Options,PrimerAnnealingRampRate,"PrimerAnnealingRampRate can be specified:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        PrimerAnnealingRampRate->1.2 (Celsius/Second),
        Output->Options
      ];
      Lookup[options,PrimerAnnealingRampRate],
      1.2 (Celsius/Second),
      Variables:>{options}
    ],
    Example[{Options,PrimerAnnealingRampRate,"PrimerAnnealingRampRate, if specified, is rounded to the nearest 0.1 degree Celsius/Second:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        PrimerAnnealingRampRate->1.22 (Celsius/Second),
        Output->Options
      ];
      Lookup[options,PrimerAnnealingRampRate],
      1.2 (Celsius/Second),
      EquivalenceFunction->Equal,
      Messages:>{
        Warning::InstrumentPrecision
      },
      Variables:>{options}
    ],


    (*---Extension options---*)

    (*ExtensionTime*)
    Example[{Options,ExtensionTime,"ExtensionTime can be specified:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        ExtensionTime->22 Second,
        Output->Options
      ];
      Lookup[options,ExtensionTime],
      22 Second,
      Variables:>{options}
    ],
    Example[{Options,ExtensionTime,"ExtensionTime, if specified, is rounded to the nearest second:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        ExtensionTime->22.2 Second,
        Output->Options
      ];
      Lookup[options,ExtensionTime],
      22 Second,
      EquivalenceFunction->Equal,
      Messages:>{
        Warning::InstrumentPrecision
      },
      Variables:>{options}
    ],
    (*ExtensionTemperature*)
    Example[{Options,ExtensionTemperature,"ExtensionTemperature can be specified:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        ExtensionTemperature->102.2 Celsius,
        Output->Options
      ];
      Lookup[options,ExtensionTemperature],
      102.2 Celsius,
      Variables:>{options}
    ],
    Example[{Options,ExtensionTemperature,"ExtensionTemperature, if specified, is rounded to the nearest 0.1 degree Celsius:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        ExtensionTemperature->102.22 Celsius,
        Output->Options
      ];
      Lookup[options,ExtensionTemperature],
      102.2 Celsius,
      EquivalenceFunction->Equal,
      Messages:>{
        Warning::InstrumentPrecision
      },
      Variables:>{options}
    ],
    (*ExtensionRampRate*)
    Example[{Options,ExtensionRampRate,"ExtensionRampRate can be specified:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        ExtensionRampRate->1.2 (Celsius/Second),
        Output->Options
      ];
      Lookup[options,ExtensionRampRate],
      1.2 (Celsius/Second),
      Variables:>{options}
    ],
    Example[{Options,ExtensionRampRate,"ExtensionRampRate, if specified, is rounded to the nearest 0.1 degree Celsius/Second:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        ExtensionRampRate->1.22 (Celsius/Second),
        Output->Options
      ];
      Lookup[options,ExtensionRampRate],
      1.2 (Celsius/Second),
      EquivalenceFunction->Equal,
      Messages:>{
        Warning::InstrumentPrecision
      },
      Variables:>{options}
    ],


    (*Infinite hold option*)
    Example[{Options,HoldTemperature,"HoldTemperature can be specified:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        HoldTemperature->10.2 Celsius,
        Output->Options
      ];
      Lookup[options,HoldTemperature],
      10.2 Celsius,
      EquivalenceFunction->Equal,
      Variables:>{options}
    ],
    Example[{Options,HoldTemperature,"HoldTemperature, if specified, is rounded to the nearest 0.1 degree Celsius:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        HoldTemperature->10.22 Celsius,
        Output->Options
      ];
      Lookup[options,HoldTemperature],
      10.2 Celsius,
      EquivalenceFunction->Equal,
      Messages:>{
        Warning::InstrumentPrecision
      },
      Variables:>{options}
    ],


    (* NumberOfCycles option*)
    Example[{Options,NumberOfCycles,"NumberOfCycles can be specified:"},
      options=ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        NumberOfCycles->23,
        Output->Options
      ];
      Lookup[options,NumberOfCycles],
      23,
      EquivalenceFunction->Equal,
      Variables:>{options}
    ],


    

    (* PurificationType *)
    Example[{Options, PurificationType, "Set the type of purification procedure used to quench the polymerase reaction:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        PurificationType -> "BigDye XTerminator",
        Output -> Options];
      Lookup[options, PurificationType],
      "BigDye XTerminator",
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, PurificationType, "Automatically set based on MasterMix name:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        MasterMix -> Object[Sample,"ExperimentDNASequencing test BigDye Direct MasterMix in 2 mL tube"<>$SessionUUID],
        Output -> Options];
      Lookup[options, PurificationType],
      "BigDye XTerminator",
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (* QuenchingReagents *)
    Example[{Options, QuenchingReagents, "Specify the reagent used to quench the polymerase reaction:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        QuenchingReagents -> {Model[Sample, "Milli-Q water"]},
        Output -> Options];
      Lookup[options, QuenchingReagents],
      {ObjectP[Model[Sample, "Milli-Q water"]]},
      Variables :> {options}
    ],
    Example[{Options, QuenchingReagents, "Automatically set QuenchingReagents based on PurificationType \"BigDye XTerminator\":"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        PurificationType -> "BigDye XTerminator",
        Output -> Options];
      Lookup[options, QuenchingReagents],
      {ObjectP[{Model[Sample, "SAM Solution"], Model[Sample, "BigDye XTerminator Solution"]}]..},
      Variables :> {options}
    ],
    Example[{Options, QuenchingReagents, "Automatically set QuenchingReagents based on PurificationType \"Ethanol precipitation\":"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        PurificationType -> "Ethanol precipitation",
        Output -> Options];
      Lookup[options, QuenchingReagents],
      {ObjectP[{Model[Sample, "Absolute Ethanol, Anhydrous"], Model[Sample, StockSolution, "125 mM EDTA"]}]..},
      Variables :> {options}
    ],

    (* QuenchingReagentVolumes *)
    Example[{Options, QuenchingReagentVolumes, "Set the volume of reagent used to quench the polymerase reaction:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        QuenchingReagentVolumes -> {45 Microliter},
        Output -> Options];
      Lookup[options, QuenchingReagentVolumes],
      {45 Microliter},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, QuenchingReagentVolumes, "QuenchingReagentVolumes must be specified to the closest 0.1 Microliter:"},
      options = ExperimentDNASequencing[
        Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        QuenchingReagentVolumes -> {35.61 Microliter},
        PreparedPlate -> False, Output -> Options];
      Lookup[options, QuenchingReagentVolumes],
      {35.6 Microliter, 35.6 Microliter},
      EquivalenceFunction -> Equal,
      Messages :> {Warning::InstrumentPrecision},
      Variables :> {options}
    ],
    Example[{Options, QuenchingReagentVolumes, "Automatically set if QuenchingReagents is not Null:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        QuenchingReagents -> {Model[Sample, "Milli-Q water"]},
        Output -> Options];
      Lookup[options, QuenchingReagentVolumes],
      {40 Microliter},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, QuenchingReagentVolumes, "QuenchingReagentVolumes is automatically set to Null if QuenchingReagents is set to Null:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        QuenchingReagents -> Null,
        Output -> Options];
      Lookup[options, QuenchingReagentVolumes],
      Null,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (* SequencingBuffer *)
    Example[{Options, SequencingBuffer, "Specify the buffer to be mixed with DNA samples prior to the capillary electrophoresis run:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        SequencingBuffer -> Model[Sample,"Nuclease-free Water"],
        Output -> Options];
      Lookup[options, SequencingBuffer],
      ObjectP[Model[Sample,"Nuclease-free Water"]],
      Variables :> {options}
    ],
    Example[{Options, SequencingBuffer, "Automatically set SequencingBuffer based on PurificationType \"BigDye XTerminator\":"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        PurificationType -> "BigDye XTerminator",
        Output -> Options];
      Lookup[options, SequencingBuffer],
      Null,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, SequencingBuffer, "Automatically set SequencingBuffer based on PurificationType \"Ethanol precipitation\":"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        PurificationType -> "Ethanol precipitation",
        Output -> Options];
      Lookup[options, SequencingBuffer],
      ObjectP[Model[Sample,"Tris EDTA 0.1 buffer solution"]],
      Variables :> {options}
    ],


    (* SequencingBufferVolume *)
    Example[{Options, SequencingBufferVolume, "Set the volume of buffer mixed with samples prior to capillary electrophoresis run:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        SequencingBufferVolume -> 21 Microliter,
        Output -> Options];
      Lookup[options, SequencingBufferVolume],
      21 Microliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, SequencingBufferVolume, "SequencingBufferVolume must be specified to the closest 0.1 Microliter:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        SequencingBuffer -> Model[Sample,"Nuclease-free Water"],
        SequencingBufferVolume -> 11.01 Microliter,
        Output -> Options];
      Lookup[options, SequencingBufferVolume],
      11.0 Microliter,
      EquivalenceFunction -> Equal,
      Messages :> {Warning::InstrumentPrecision},
      Variables :> {options}
    ],
    Example[{Options, SequencingBufferVolume, "Automatically set if SequencingBuffer is not Null:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        SequencingBuffer -> Model[Sample,"Milli-Q water"],
        Output -> Options];
      Lookup[options, SequencingBufferVolume],
      40 Microliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, SequencingBufferVolume, "SequencingBufferVolume is automatically set to Null if SequencingBuffer is set to Null:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        SequencingBuffer -> Null,
        Output -> Options];
      Lookup[options, SequencingBufferVolume],
      Null,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (* DyeSet *)
    Example[{Options, DyeSet, "Specify the name of the dye set used to prepare the samples for the capillary electrophoresis experiment:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        DyeSet -> "E_BigDye Terminator v1.1",
        Output -> Options];
      Lookup[options, DyeSet],
      "E_BigDye Terminator v1.1",
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DyeSet, "DyeSet is automatically set based on the name of the master mix:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        MasterMix -> Model[Sample,"ExperimentDNASequencing test Master Mix with BigDye Direct composition"<>$SessionUUID],
        Output -> Options];
      Lookup[options, DyeSet],
      "E_BigDye Terminator v1.1",
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (* PrimeTime *)
    Example[{Options, PrimeTime, "Specify the time the capillary array is primed prior to running the capillary electrophoresis experiment:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        PrimeTime -> 190 Second,
        Output -> Options];
      Lookup[options, PrimeTime],
      190 Second,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, PrimeTime, "PrimeTime must be specified to the closest 1 Second:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        PrimeTime -> 100.1 Second,
        Output -> Options];
      Lookup[options, PrimeTime],
      100 Second,
      EquivalenceFunction -> Equal,
      Messages :> {Warning::InstrumentPrecision},
      Variables :> {options}
    ],
    (* PrimeVoltage *)
    Example[{Options, PrimeVoltage, "Specify the voltage applied to prime the capillary array prior to running the capillary electrophoresis experiment:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        PrimeVoltage -> 12 Kilovolt,
        Output -> Options];
      Lookup[options, PrimeVoltage],
      12 Kilovolt,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, PrimeVoltage, "PrimeVoltage must be specified to the closest 1 Volt:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        PrimeVoltage -> 2.2 Volt,
        Output -> Options];
      Lookup[options, PrimeVoltage],
      2 Volt,
      EquivalenceFunction -> Equal,
      Messages :> {
        Warning::InstrumentPrecision
      },
      Variables :> {options}
    ],
    (* InjectionTime *)
    Example[{Options, InjectionTime, "Specify the time the sample is drawn into the capillary array to run the capillary electrophoresis experiment:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        InjectionTime -> 20 Second,
        Output -> Options];
      Lookup[options, InjectionTime],
      20 Second,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, InjectionTime, "InjectionTime must be specified to the closest 1 Second:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        InjectionTime -> 101.1 Second,
        Output -> Options];
      Lookup[options, InjectionTime],
      101 Second,
      EquivalenceFunction -> Equal,
      Messages :> {Warning::InstrumentPrecision},
      Variables :> {options}
    ],
    (* InjectionVoltage *)
    Example[{Options, InjectionVoltage, "Specify the voltage applied during injection of the sample for the capillary electrophoresis experiment:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        InjectionVoltage -> 10 Kilovolt,
        Output -> Options];
      Lookup[options, InjectionVoltage],
      10 Kilovolt,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, InjectionVoltage, "InjectionVoltage must be specified to the closest 1 Volt:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        InjectionVoltage -> 20.2 Volt,
        Output -> Options];
      Lookup[options, InjectionVoltage],
      20 Volt,
      EquivalenceFunction -> Equal,
      Messages :> {Warning::InstrumentPrecision},
      Variables :> {options}
    ],
    Example[{Options, InjectionVoltage, "Automatically resolve the InjectionVoltage based on the value of ReadLength:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        ReadLength -> 550,
        Output -> Options];
      Lookup[options, InjectionVoltage],
      1200 Volt,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, InjectionVoltage, "Automatically resolve the InjectionVoltage based on the value of ReadLength:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        ReadLength -> 650,
        Output -> Options];
      Lookup[options, InjectionVoltage],
      1400 Volt,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    (* RampTime *)
    Example[{Options, RampTime, "Specify the time the voltage applied to the capillary array is ramped from the InjectionVoltage to the RunVoltage during the capillary electrophoresis experiment:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        RampTime -> 200 Second,
        Output -> Options];
      Lookup[options, RampTime],
      200 Second,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, RampTime, "RampTime must be specified to the closest 1 Second:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        RampTime -> 102.1 Second,
        Output -> Options];
      Lookup[options, RampTime],
      102 Second,
      EquivalenceFunction -> Equal,
      Messages :> {Warning::InstrumentPrecision},
      Variables :> {options}
    ],
    (* RunVoltage *)
    Example[{Options, RunVoltage, "Specify the voltage applied during the capillary electrophoresis experiment:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        RunVoltage -> 5 Kilovolt,
        Output -> Options];
      Lookup[options, RunVoltage],
      5 Kilovolt,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, RunVoltage, "RunVoltage must be specified to the closest 1 Volt:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        RunVoltage -> 200.2 Volt,
        Output -> Options];
      Lookup[options, RunVoltage],
      200 Volt,
      EquivalenceFunction -> Equal,
      Messages :> {Warning::InstrumentPrecision},
      Variables :> {options}
    ],
    Example[{Options, RunVoltage, "Automatically resolve the RunVoltage based on the value of ReadLength:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        ReadLength -> 250,
        Output -> Options];
      Lookup[options, RunVoltage],
      12000 Volt,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, RunVoltage, "Automatically resolve the RunVoltage based on the value of ReadLength:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        ReadLength -> 230,
        Output -> Options];
      Lookup[options, RunVoltage],
      12000 Volt,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, RunVoltage, "Automatically resolve the RunVoltage based on the value of ReadLength:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        ReadLength -> 450,
        Output -> Options];
      Lookup[options, RunVoltage],
      9000 Volt,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, RunVoltage, "Automatically resolve the RunVoltage based on the value of ReadLength:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        ReadLength -> 750,
        Output -> Options];
      Lookup[options, RunVoltage],
      4000 Volt,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    (* RunTime *)
    Example[{Options, RunTime, "Specify the time the voltage is applied to the sample during the capillary electrophoresis experiment:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        RunTime -> 400 Second,
        Output -> Options];
      Lookup[options, RunTime],
      400 Second,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, RunTime, "RunTime must be specified to the closest 1 Second:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        RunTime -> 300.1 Second,
        Output -> Options];
      Lookup[options, RunTime],
      300 Second,
      EquivalenceFunction -> Equal,
      Messages :> {Warning::InstrumentPrecision},
      Variables :> {options}
    ],
    Example[{Options, RunTime, "Automatically resolve the RunTime based on the value of ReadLength:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        ReadLength -> 200,
        Output -> Options];
      Lookup[options, RunTime],
      760 Second,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, RunTime, "Automatically resolve the RunTime based on the value of ReadLength:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        ReadLength -> 400,
        Output -> Options];
      Lookup[options, RunTime],
      1380 Second,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, RunTime, "Automatically resolve the RunTime based on the value of ReadLength:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        ReadLength -> 725,
        Output -> Options];
      Lookup[options, RunTime],
      5140 Second,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (* InjectionGroups *)
    Example[{Options, InjectionGroups, "A group of samples to be co-injected for the capillary electrophoresis experiment are automatically formed for a single sample:"},
      protocol = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID]];
      Download[protocol, InjectionGroups],
      {
        {ObjectP[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID]],
        ObjectP[Model[Sample,"Hi-Di formamide"]],
        ObjectP[Model[Sample,"Hi-Di formamide"]],
        ObjectP[Model[Sample,"Hi-Di formamide"]]}
      },
      Variables :> {protocol}
    ],
    Example[{Options, InjectionGroups, "Groups of samples to be co-injected for the capillary electrophoresis experiment run are automatically formed if not specified:"},
      protocol = ExperimentDNASequencing[ConstantArray[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],5]];
      Download[protocol, InjectionGroups],
      {
        {ObjectP[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID]],
          ObjectP[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID]],
          ObjectP[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID]],
          ObjectP[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID]]},
        {ObjectP[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID]],
          ObjectP[Model[Sample,"Hi-Di formamide"]],
          ObjectP[Model[Sample,"Hi-Di formamide"]],
          ObjectP[Model[Sample,"Hi-Di formamide"]]}
      },
      Variables :> {protocol}
    ],
    Example[{Options, InjectionGroups, "Separate groups of samples to be co-injected for the capillary electrophoresis experiment run are automatically formed if different electrophoresis settings are specified:"},
      protocol = ExperimentDNASequencing[ConstantArray[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],2],
        InjectionVoltage -> {3567Volt, 4583Volt}];
      Download[protocol, InjectionGroups],
      {
        {ObjectP[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID]],
          ObjectP[Model[Sample,"Hi-Di formamide"]],
          ObjectP[Model[Sample,"Hi-Di formamide"]],
          ObjectP[Model[Sample,"Hi-Di formamide"]]},
        {ObjectP[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID]],
          ObjectP[Model[Sample,"Hi-Di formamide"]],
          ObjectP[Model[Sample,"Hi-Di formamide"]],
          ObjectP[Model[Sample,"Hi-Di formamide"]]}
      },
      Variables :> {protocol}
    ],
    (*Example[{Options, InjectionGroups, "Specify multiple groups of samples to be co-injected for the capillary electrophoresis experiment run:"},
      options = ExperimentDNASequencing[ConstantArray[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],4],
        InjectionGroups -> {
          {Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
          Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID]},
          {Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
          Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID]}
        },
        Output -> Options];
      Lookup[options, InjectionGroups],
      {
        {ObjectP[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID]],
          ObjectP[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID]],
          ObjectP[Model[Sample,"Hi-Di formamide"]],
          ObjectP[Model[Sample,"Hi-Di formamide"]]},
        {ObjectP[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID]],
          ObjectP[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID]],
          ObjectP[Model[Sample,"Hi-Di formamide"]],
          ObjectP[Model[Sample,"Hi-Di formamide"]]}
      },
      Variables :> {options}
    ],*)

    (* Storage *)
    Example[{Options, SamplesInStorageCondition, "Specify the storage parameters of the SamplesIn once they are stored after the protocol runs:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        SamplesInStorageCondition -> Disposal,
        Output -> Options];
      Lookup[options, SamplesInStorageCondition],
      Disposal,
      Variables :> {options}
    ],
    Example[{Options, SequencingCartridgeStorageCondition, "Specify the storage parameter of the SequencingCartridge once it is stored after the protocol runs:"},
      options = ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        SequencingCartridgeStorageCondition -> Refrigerator,
        Output -> Options];
      Lookup[options, SequencingCartridgeStorageCondition],
      Refrigerator,
      Variables :> {options}
    ],



    (* ----------- *)
    (* -- TESTS -- *)
    (* ----------- *)
    Test["Accepts a model-less sample object:",
      ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test model-less sample"<>$SessionUUID]
      ],
      ObjectP[Object[Protocol,DNASequencing]],
      SetUp :> ($CreatedObjects = {}),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Test["Accepts multiple sample objects:",
      ExperimentDNASequencing[
        {
          Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
          Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID]
        }
      ],
      ObjectP[Object[Protocol,DNASequencing]],
      SetUp :> ($CreatedObjects = {}),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Test["Accepts non-empty primer container object:",
      ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Container, Vessel, "ExperimentDNASequencing test 2mL tube"<>$SessionUUID]
      ],
      ObjectP[Object[Protocol,DNASequencing]],
      SetUp :> ($CreatedObjects = {}),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Test["Accepts multiple non-empty sample and primer container objects:",
      ExperimentDNASequencing[
        {
          Object[Container, Vessel, "ExperimentDNASequencing test 2mL tube"<>$SessionUUID],
          Object[Container, Vessel, "ExperimentDNASequencing test 2mL tube"<>$SessionUUID]
        },
        {
          Object[Container, Vessel, "ExperimentDNASequencing test 2mL tube"<>$SessionUUID],
          Object[Container, Vessel, "ExperimentDNASequencing test 2mL tube"<>$SessionUUID]
        }
      ],
      ObjectP[Object[Protocol,DNASequencing]],
      SetUp :> ($CreatedObjects = {}),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],



    (* -------------- *)
    (* -- MESSAGES -- *)
    (* -------------- *)
    Example[{Messages, "DuplicateName", "The Name option must not be the name of an already-existing DNASequencing protocol:"},
      ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Name -> "Already existing name"<>$SessionUUID],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages :> {
        Error::DuplicateName,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "DiscardedSamples", "Samples that are discarded cannot be provided:"},
      ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test discarded sample"<>$SessionUUID]],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages :> {
        Error::DiscardedSamples,
        Error::InvalidInput
      }
    ],
    Example[{Messages,"DiscardedSamples","The primers cannot have a Status of Discarded:"},
      ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test discarded primer sample"<>$SessionUUID]
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{
        Error::DiscardedSamples,
        Error::InvalidInput
      }
    ],
    Example[{Messages, "DeprecatedModels", "Samples whose models are deprecated cannot be provided:"},
      ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test deprecated model sample"<>$SessionUUID]],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages :> {
        Error::DeprecatedModels,
        Error::InvalidInput
      }
    ],
    Example[{Messages, "DeprecatedModels", "Primer samples whose models are deprecated cannot be provided:"},
      ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test deprecated model sample"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test deprecated model primer sample"<>$SessionUUID]
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages :> {
        Error::DeprecatedModels,
        Error::InvalidInput
      }
    ],
    Example[{Messages, "SolidSample", "The samples and primer samples cannot be solid:"},
      ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test solid sample"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test solid sample"<>$SessionUUID]
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages :> {
        Error::InvalidSolidInput,
        Error::SolidSamplesUnsupported,
        Error::InvalidInput
      }
    ],
    Example[{Messages, "DNASequencingTooManySamples", "An error is thrown if more than 96 samples are run in a single protocol:"},
      ExperimentDNASequencing[
        ConstantArray[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID], 97]
        ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages :> {
        Error::DNASequencingTooManySamples,
        Error::InvalidInput
      }
    ],
    Example[{Messages, "DNASequencingPreparedPlateInputInvalid", "An error is thrown if PreparedPlate->True and primer inputs are given, or PreparedPlate->False and no primer inputs are given:"},
      ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        PreparedPlate->False
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages :> {
        Error::DNASequencingPreparedPlateInputInvalid, Error::InvalidInput, Error::InvalidOption, Error::DNASequencingPreparedPlateMismatch, Error::DNASequencingPrimerCompositionNull
      }
    ],
    Example[{Messages,"InvalidPreparedPlateContainer","When using a prepared plate, all the samples must be in a 96-well Optical Semi-Skirted PCR Plate:"},
      ExperimentDNASequencing[
        "ExperimentDNASequencing PreparatoryUnitOperations test plate 1",
        PreparatoryUnitOperations->{
          LabelContainer[Label->"ExperimentDNASequencing PreparatoryUnitOperations test plate 1",Container->Model[Container,Plate,"96-well Optical Full-Skirted PCR Plate"]],
          Transfer[Source->Model[Sample,"Milli-Q water"],Destination->{"A1", "ExperimentDNASequencing PreparatoryUnitOperations test plate 1"},Amount->20 Microliter]
        },
        ReadLength->300
      ],
      $Failed,
      SetUp :> ($CreatedObjects = {}),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::DNASequencingPreparedPlateContainerInvalid,Error::InvalidInput}
    ],
    Example[{Messages,"InvalidPreparedPlateContainer","When using a prepared plate, all the samples must be in a 96-well Optical Semi-Skirted PCR Plate:"},
      ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample in 50mL tube"<>$SessionUUID],
        ReadLength->300
      ],
      $Failed,
      SetUp :> ($CreatedObjects = {}),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::DNASequencingPreparedPlateContainerInvalid,Error::InvalidInput}
    ],
    Example[{Messages, "DNASequencingCathodeBufferInvalid", "An error is thrown if the CathodeSequencingBuffer specified in the BufferCartridge Object is invalid:"},
      ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        BufferCartridge -> Object[Container,Vessel,BufferCartridge,"ExperimentDNASequencing test buffer cartridge with wrong cathode buffer"<>$SessionUUID]],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages :> {Error::DNASequencingCathodeBufferInvalid, Error::InvalidOption}
    ],
    Example[{Messages, "DNASequencingAnodeBufferInvalid", "An error is thrown if the AnodeBuffer specified in the SequencingCartridge Object is invalid:"},
      ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        SequencingCartridge -> Object[Item,Cartridge,DNASequencing,"ExperimentDNASequencing test sequencing cartridge with wrong polymer and anode buffer"<>$SessionUUID]],
        $Failed,
        SetUp:>($CreatedObjects={}),
        TearDown:>(
          EraseObject[$CreatedObjects,Force->True,Verbose->False];
          Unset[$CreatedObjects]
        ),
        Messages :> {Error::DNASequencingAnodeBufferInvalid, Error::InvalidOption, Error::DNASequencingPolymerInvalid,Error::DNASequencingCartridgeTypeInvalid}
      ],
    Example[{Messages, "DNASequencingPolymerInvalid", "An error is thrown if the Polymer specified in the SequencingCartridge Object is invalid:"},
      ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        SequencingCartridge -> Object[Item,Cartridge,DNASequencing,"ExperimentDNASequencing test sequencing cartridge with wrong polymer and anode buffer"<>$SessionUUID]],
        $Failed,
        SetUp:>($CreatedObjects={}),
        TearDown:>(
          EraseObject[$CreatedObjects,Force->True,Verbose->False];
          Unset[$CreatedObjects]
        ),
        Messages :> {Error::DNASequencingPolymerInvalid, Error::InvalidOption, Error::DNASequencingAnodeBufferInvalid,Error::DNASequencingCartridgeTypeInvalid}
      ],
    Example[{Messages, "DNASequencingCartridgeTypeInvalid", "An error is thrown if the CartridgeType specified in the SequencingCartridge Object is invalid:"},
      ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        SequencingCartridge -> Object[Item,Cartridge,DNASequencing,"ExperimentDNASequencing test sequencing cartridge with wrong polymer and anode buffer"<>$SessionUUID]],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages :> {Error::DNASequencingPolymerInvalid, Error::InvalidOption, Error::DNASequencingAnodeBufferInvalid,Error::DNASequencingCartridgeTypeInvalid}
    ],
    Example[{Messages, "DNASequencingPurificationTypeMismatch", "QuenchingReagents cannot be Null when PurificationType is BigDye XTerminator:"},
      ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        QuenchingReagents -> Null,
        PurificationType -> "BigDye XTerminator"
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::DNASequencingPurificationTypeMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "DNASequencingPurificationTypeMismatch", "SequencingBuffer cannot be Null when PurificationType is Ethanol precipitation:"},
      ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        SequencingBuffer -> Null,
        PurificationType -> "Ethanol precipitation"
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::DNASequencingPurificationTypeMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "DNASequencingQuenchingReagentVolumeMismatch", "The QuenchingReagentVolumes can only be specified when QuenchingReagents is not Null:"},
      ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        QuenchingReagents -> Null,
        QuenchingReagentVolumes -> {45 Microliter}
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::DNASequencingQuenchingReagentVolumeMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "DNASequencingQuenchingReagentVolumeMismatch", "The QuenchingReagentVolumes cannot be specified as Null when QuenchingReagents is not Null:"},
      ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        QuenchingReagents -> {Model[Sample, "Absolute Ethanol, Anhydrous"]},
        QuenchingReagentVolumes -> Null
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::DNASequencingQuenchingReagentVolumeMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "DNASequencingBufferVolumeMismatch", "The SequencingBufferVolume can only be specified when SequencingBuffer is not Null:"},
      ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        SequencingBuffer -> Null,
        SequencingBufferVolume -> 20 Microliter
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::DNASequencingBufferVolumeMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "DNASequencingBufferVolumeMismatch", "The SequencingBufferVolume cannot be specified as Null when SequencingBuffer is not Null:"},
      ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        SequencingBuffer -> Model[Sample,"Hi-Di formamide"],
        SequencingBufferVolume -> Null
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::DNASequencingBufferVolumeMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "MultipleSampleOligomersSpecified", "An error is thrown if multiple oligomer molecules are specified in the sample composition:"},
      ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample multiple oligomers"<>$SessionUUID]
        ],
      ObjectP[Object[Protocol, DNASequencing]],
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages :> {Warning::MultipleSampleOligomersSpecified, Warning::DNASequencingReadLengthNotSpecified}
    ],
    Example[{Messages, "DNASequencingTooManyInjectionGroups", "An error is thrown if more injection groups are formed than can fit on the plate:"},
      ExperimentDNASequencing[
        ConstantArray[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID], 25],
        PrimeTime -> {Quantity[10, "Seconds"], Quantity[20, "Seconds"],
          Quantity[30, "Seconds"], Quantity[40, "Seconds"],
          Quantity[50, "Seconds"], Quantity[60, "Seconds"],
          Quantity[70, "Seconds"], Quantity[80, "Seconds"],
          Quantity[90, "Seconds"], Quantity[100, "Seconds"],
          Quantity[110, "Seconds"], Quantity[120, "Seconds"],
          Quantity[130, "Seconds"], Quantity[140, "Seconds"],
          Quantity[150, "Seconds"], Quantity[160, "Seconds"],
          Quantity[170, "Seconds"], Quantity[180, "Seconds"],
          Quantity[190, "Seconds"], Quantity[200, "Seconds"],
          Quantity[210, "Seconds"], Quantity[220, "Seconds"],
          Quantity[230, "Seconds"], Quantity[240, "Seconds"],
          Quantity[250, "Seconds"]}
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages :> {
        Error::DNASequencingTooManyInjectionGroups,
        Error::InvalidInput
      }
    ],
    (*Example[{Messages, InjectionGroups,"DNASequencingInjectionGroupsSettingsMismatch", "If injection groups with different samples are specified, the electrophoresis settings match:"},
      ExperimentDNASequencing[{Object[Sample, "ExperimentDNASequencing test plate sample A1"<>$SessionUUID], Object[Sample, "ExperimentDNASequencing test plate sample B1"<>$SessionUUID]},
        InjectionGroups -> {{Object[Sample, "ExperimentDNASequencing test plate sample A1"<>$SessionUUID], Object[Sample, "ExperimentDNASequencing test plate sample B1"<>$SessionUUID]}},
        InjectionVoltage -> {3528 Volt, 4637 Volt}
      ],
      ObjectP[Object[Protocol, DNASequencing]],
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Warning::DNASequencingInjectionGroupsSettingsMismatch}
    ],
    Example[{Messages, InjectionGroups, "DNASequencingInjectionGroupsSettingsMismatch", "If injection groups with replicate samples are specified, the electrophoresis settings match:"},
      ExperimentDNASequencing[{Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID], Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID]},
        InjectionGroups -> {{Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID], Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID]}},
        InjectionVoltage -> {3528 Volt, 4637 Volt}
      ],
      ObjectP[Object[Protocol, DNASequencing]],
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Warning::DNASequencingInjectionGroupsSettingsMismatch}
    ],
    Example[{Messages, InjectionGroups, "DNASequencingInjectionGroupsLengths", "If injection groups are specified, the length of each group is not longer than the NumberOfCapillaries of the SequencingCartridge:"},
      ExperimentDNASequencing[{Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID]},
        InjectionGroups -> {{Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
          Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
          Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
          Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
          Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID]}}
      ],
      ObjectP[Object[Protocol, DNASequencing]],
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Warning::DNASequencingInjectionGroupsLengths}
    ],
    Example[{Messages, InjectionGroups, "DNASequencingInjectionGroupsSamplesLengthsMismatch", "A warning is thrown if all samples are not contained in the injection groups or there are more samples in the injection groups than are input:"},
      ExperimentDNASequencing[{Object[Sample,"ExperimentDNASequencing test plate sample A1"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test plate sample B1"<>$SessionUUID]},
        InjectionGroups -> {{Object[Sample,"ExperimentDNASequencing test plate sample A1"<>$SessionUUID]}}
      ],
      ObjectP[Object[Protocol, DNASequencing]],
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Warning::DNASequencingInjectionGroupsSamplesLengthsMismatch}
    ],
    Example[{Messages, InjectionGroups, "DNASequencingInjectionGroupsOptionsAmbiguous", "A warning is thrown if there are any replicate samples and the samples in are in a different order than the specified injection groups, but the same samples have the different options:"},
      ExperimentDNASequencing[{Object[Sample,"ExperimentDNASequencing test plate sample A1"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test plate sample B1"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test plate sample A1"<>$SessionUUID]},
        InjectionGroups -> {
          {Object[Sample,"ExperimentDNASequencing test plate sample A1"<>$SessionUUID],Object[Sample,"ExperimentDNASequencing test plate sample A1"<>$SessionUUID]},
          {Object[Sample,"ExperimentDNASequencing test plate sample B1"<>$SessionUUID]}
        },
        PrimeTime->{345Second,452Second,567Second}
      ],
      ObjectP[Object[Protocol, DNASequencing]],
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Warning::DNASequencingInjectionGroupsOptionsAmbiguous}
    ],*)
    Example[{Messages, "DNASequencingPCROptionsForPreparedPlate", "A warning is thrown if PCR options are specified when PreparedPlate->True:"},
      ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        ReadLength->300,
        Activation->True
      ],
      ObjectP[Object[Protocol, DNASequencing]],
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages :> {Warning::DNASequencingPCROptionsForPreparedPlate}
    ],
    Example[{Messages, "MultiplePrimerSampleOligomersSpecified", "An error is thrown if multiple oligomer molecules are specified in the primer sample composition:"},
      ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test primer sample multiple oligomers"<>$SessionUUID]
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages :> {Error::MultiplePrimerSampleOligomersSpecified,Error::DNASequencingPrimerCompositionNull,Error::InvalidOption}
    ],
    Example[{Messages, "DNASequencingPrimerCompositionNull", "The PrimerVolume is specified or primer[Composition] is informed so PrimerVolume is automatically resolved when PreparedPlate -> False:"},
      ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 3"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test sample with Null composition"<>$SessionUUID],
        PreparedPlate -> False
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::DNASequencingPrimerCompositionNull, Error::InvalidOption, Error::DNASequencingPreparedPlateMismatch}
    ],
    Example[{Messages,"DNASequencingPrimerStorageConditionMismatch","PrimerStorageCondition is only specified when primer inputs are specified:"},
      ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        PrimerStorageCondition->Disposal
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::DNASequencingPrimerStorageConditionMismatch, Error::InvalidOption}
    ],
    Example[{Messages, "DNASequencingMasterMixNotSpecified", "The MasterMixVolume can only be specified when MasterMix is not Null:"},
      ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        MasterMix -> Null,
        MasterMixVolume -> 13 Microliter,
        DyeSet->"Z_BigDye Direct"
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::DNASequencingMasterMixNotSpecified, Error::InvalidOption}
    ],
    Example[{Messages, "DNASequencingMasterMixNotSpecified", "The MasterMixVolume cannot be specified as Null when MasterMix is not Null:"},
      ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        MasterMix -> Model[Sample, "ExperimentDNASequencing test Master Mix with BigDye Direct composition"<>$SessionUUID],
        MasterMixVolume -> Null
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::DNASequencingMasterMixNotSpecified, Error::InvalidOption, Error::DNASequencingPreparedPlateMismatch}
    ],
    Example[{Messages,"DNASequencingMasterMixStorageConditionMismatch","MasterMixStorageCondition is specified only when MasterMix is specified:"},
      ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        MasterMix->Null,
        MasterMixStorageCondition->Disposal,
        DyeSet->"E_BigDye Terminator v1.1"
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::DNASequencingMasterMixStorageConditionMismatch, Error::InvalidOption, Error::DNASequencingPreparedPlateMismatch}
    ],
    Example[{Messages, "DNASequencingDiluentNotSpecified", "The DiluentVolume can only be specified when Diluent is not Null:"},
      ExperimentDNASequencing[Object[Sample, "ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        Diluent->Null,
        DiluentVolume->3 Microliter
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::DNASequencingDiluentNotSpecified, Error::InvalidOption}
    ],
    Example[{Messages,"DNASequencingTotalVolumeOverReactionVolume","The total volume cannot exceed ReactionVolume:"},
      ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        SampleVolume->60 Microliter,
        ReactionVolume->30 Microliter
      ],
      $Failed,
      SetUp :> ($CreatedObjects = {}),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::DNASequencingTotalVolumeOverReactionVolume, Error::InvalidOption}
    ],
    Example[{Messages, "DNASequencingPreparedPlateMismatch", "If all sample preparation options are Null and there are no primer inputs, PreparedPlate should be set to True:"},
      ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        PreparedPlate -> False,
        PrimerConcentration -> Null,
        PrimerVolume -> Null,
        MasterMix -> Null,
        MasterMixVolume -> Null,
        Diluent -> Null,
        DiluentVolume -> Null,
        DyeSet->"E_BigDye Terminator v1.1"
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::DNASequencingPreparedPlateMismatch, Error::InvalidOption,Error::InvalidInput,Error::DNASequencingPreparedPlateInputInvalid}
    ],
    Example[{Messages, "DNASequencingPreparedPlateMismatch", "If all sample preparation options are set and primers are given as inputs, PreparedPlate should be set to False:"},
      ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        PreparedPlate -> True,
        PrimerConcentration -> 10 Micromolar,
        PrimerVolume -> 5 Microliter,
        MasterMix -> Model[Sample,"Nuclease-free Water"],
        MasterMixVolume -> 5 Microliter,
        Diluent -> Model[Sample,"Nuclease-free Water"],
        DiluentVolume -> 5 Microliter,
        DyeSet->"E_BigDye Terminator v1.1"
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::DNASequencingPreparedPlateMismatch, Error::InvalidOption,Error::InvalidInput,Error::DNASequencingPreparedPlateInputInvalid}
    ],
    Example[{Messages, "DNASequencingReadLengthNotSpecified", "If the sample composition is Null, the read length is not set based on the composition:"},
      ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample with Null composition"<>$SessionUUID]
      ],
      ObjectP[Object[Protocol, DNASequencing]],
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Warning::DNASequencingReadLengthNotSpecified}
    ],
    Example[{Messages, "DyeSetUnknown", "The dye sets are specified or are resolved from the name of the Master Mix:"},
      ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        MasterMix -> Model[Sample,"ExperimentDNASequencing test DNA sample with Null composition"<>$SessionUUID]
      ],
      $Failed,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Error::DyeSetUnknown, Error::InvalidOption}
    ],
    Example[{Messages, "DNASequencingCartridgeStorageCondition", "If the SequencingCartridgeStorageCondition is not specified as Refrigerator, a warning is thrown:"},
      ExperimentDNASequencing[
        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        SequencingCartridgeStorageCondition -> DeepFreezer
      ],
      ObjectP[Object[Protocol, DNASequencing]],
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages:>{Warning::DNASequencingCartridgeStorageCondition}
    ],


    Example[{Options, Template, "Use a previous DNASequencing protocol as a template for a new one:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Template->Object[Protocol, DNASequencing, "Parent Protocol for Template ExperimentDNASequencing tests"<>$SessionUUID],
        Output -> Options];
      Lookup[options, Template],
      ObjectP[Object[Protocol,DNASequencing]],
      Variables :> {options}
    ],



    (*--------------------------------------*)
    (*===Shared sample prep options tests===*)
    (*--------------------------------------*)


    Example[{Additional,"Use the sample preparation options to prepare samples before the main experiment:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],Incubate->True,Centrifuge->True,Filtration->True,Aliquot->True,Output->Options];
      {Lookup[options,Incubate],Lookup[options,Centrifuge],Lookup[options,Filtration],Lookup[options,Aliquot]},
      {True,True,True,True},
      Variables:>{options},
      TimeConstraint->240
    ],

    (*Incubate options tests*)
    Example[{Options,Incubate,"Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],Incubate->True,Output->Options];
      Lookup[options,Incubate],
      True,
      Variables:>{options}
    ],
    Example[{Options,IncubationTime,"Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],IncubationTime->40*Minute,Output->Options];
      Lookup[options,IncubationTime],
      40*Minute,
      EquivalenceFunction->Equal,
      Variables:>{options}
    ],
    Example[{Options,MaxIncubationTime,"Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],MaxIncubationTime->40*Minute,Output->Options];
      Lookup[options,MaxIncubationTime],
      40*Minute,
      EquivalenceFunction->Equal,
      Variables:>{options}
    ],
    Example[{Options,IncubationTemperature,"Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],IncubationTemperature->40*Celsius,Output->Options];
      Lookup[options,IncubationTemperature],
      40*Celsius,
      EquivalenceFunction->Equal,
      Variables:>{options}
    ],
    (*Note: This test requires your sample to be in some type of 50mL tube or 96-well plate. Definitely not bigger than a 250mL bottle*)
    Example[{Options,IncubationInstrument,"The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],IncubationInstrument->Model[Instrument,HeatBlock,"id:WNa4ZjRDVw64"],Output->Options];
      Lookup[options,IncubationInstrument],
      ObjectP[Model[Instrument,HeatBlock,"id:WNa4ZjRDVw64"]],
      Variables:>{options}
    ],
    Example[{Options,AnnealingTime,"Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],AnnealingTime->40*Minute,Output->Options];
      Lookup[options,AnnealingTime],
      40*Minute,
      EquivalenceFunction->Equal,
      Variables:>{options}
    ],
    Example[{Options,IncubateAliquot,"The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],IncubateAliquot->5*Microliter,Output->Options];
      Lookup[options,IncubateAliquot],
      5*Microliter,
      EquivalenceFunction->Equal,
      Variables:>{options}
    ],
    Example[{Options,IncubateAliquotContainer,"The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],IncubateAliquotContainer->{1, Model[Container, Vessel, "2mL Tube"]},Output->Options];
      Lookup[options,IncubateAliquotContainer],
      {1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
      Variables:>{options}
    ],
    Example[{Options,IncubateAliquotDestinationWell,"Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],IncubateAliquotDestinationWell->"A1",AliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
      Lookup[options,IncubateAliquotDestinationWell],
      "A1",
      Variables:>{options}
    ],
    Example[{Options,Mix,"Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],Mix->True,Output->Options];
      Lookup[options,Mix],
      True,
      Variables:>{options}
    ],
    (*Note: You CANNOT be in a plate for the following test*)
    Example[{Options,MixType,"Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample in 2mL tube"<>$SessionUUID],MixType->Shake,Output->Options];
      Lookup[options,MixType],
      Shake,
      Messages:>{Error::DNASequencingPreparedPlateContainerInvalid, Error::InvalidInput},
      Variables:>{options}
    ],
    Example[{Options,MixUntilDissolved,"Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incubation will occur prior to starting the experiment:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],MixUntilDissolved->True,Output->Options];
      Lookup[options,MixUntilDissolved],
      True,
      Variables:>{options}
    ],

    (*Centrifuge options tests*)
    Example[{Options,Centrifuge,"Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],Centrifuge->True,Output->Options];
      Lookup[options,Centrifuge],
      True,
      Variables:>{options}
    ],
    (*Note: CentrifugeTime cannot go above 5 minutes without restricting the types of centrifuges that can be used*)
    Example[{Options,CentrifugeTime,"The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],CentrifugeTime->5*Minute,Output->Options];
      Lookup[options,CentrifugeTime],
      5*Minute,
      EquivalenceFunction->Equal,
      Variables:>{options}
    ],
    Example[{Options,CentrifugeTemperature,"The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],CentrifugeTemperature->30*Celsius,CentrifugeAliquotContainer->Model[Container,Vessel,"50mL Tube"],AliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
      Lookup[options,CentrifugeTemperature],
      30*Celsius,
      EquivalenceFunction->Equal,
      Variables:>{options},
      TimeConstraint -> 240
    ],
    Example[{Options,CentrifugeIntensity,"The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],CentrifugeIntensity->1000*RPM,Output->Options];
      Lookup[options,CentrifugeIntensity],
      1000*RPM,
      EquivalenceFunction->Equal,
      Variables:>{options}
    ],
    (*Note: Put your sample in a 2mL tube for the following test*)
    Example[{Options,CentrifugeInstrument,"The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample in 2mL tube"<>$SessionUUID],CentrifugeInstrument->Model[Instrument,Centrifuge,"Microfuge 16"],Output->Options];
      Lookup[options,CentrifugeInstrument],
      ObjectP[Model[Instrument,Centrifuge,"Microfuge 16"]],
      Variables:>{options},
      Messages:>{Error::DNASequencingPreparedPlateContainerInvalid, Error::InvalidInput}
    ],
    Example[{Options,CentrifugeAliquot,"The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],CentrifugeAliquot->5*Microliter,Output->Options];
      Lookup[options,CentrifugeAliquot],
      5*Microliter,
      EquivalenceFunction->Equal,
      Variables:>{options}
    ],
    Example[{Options,CentrifugeAliquotContainer,"The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],CentrifugeAliquotContainer->{1, Model[Container, Vessel, "2mL Tube"]},Output->Options];
      Lookup[options,CentrifugeAliquotContainer],
      {1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
      Variables:>{options}
    ],
    Example[{Options,CentrifugeAliquotDestinationWell,"Indicates the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],CentrifugeAliquotDestinationWell->"A1",Output->Options];
      Lookup[options,CentrifugeAliquotDestinationWell],
      "A1",
      Variables:>{options}
    ],

    (*Filter options tests*)
    Example[{Options,Filtration,"Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],Filtration->True,Output->Options];
      Lookup[options,Filtration],
      True,
      Variables:>{options}
    ],
    Example[{Options,FiltrationType,"The type of filtration method that should be used to perform the filtration:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],FiltrationType->Syringe,PurificationType -> Null,Output->Options];
      Lookup[options,FiltrationType],
      Syringe,
      Variables:>{options}
    ],
    Example[{Options,FilterInstrument,"The instrument that should be used to perform the filtration:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],FilterInstrument->Model[Instrument,SyringePump,"NE-1010 Syringe Pump"],Output->Options];
      Lookup[options,FilterInstrument],
      ObjectP[Model[Instrument,SyringePump,"NE-1010 Syringe Pump"]],
      Variables:>{options}
    ],
    Example[{Options,Filter,"The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],Filter->Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"],Output->Options];
      Lookup[options,Filter],
      ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
      Variables:>{options}
    ],
    Example[{Options,FilterMaterial,"The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],FilterMaterial->PES,FilterContainerOut->Model[Container,Vessel,"50mL Tube"],Output->Options];
      Lookup[options,FilterMaterial],
      PES,
      Variables:>{options}
    ],
    (*Note: Put your sample in a 50mL tube for the following test*)
    Example[{Options,PrefilterMaterial,"The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample in 50mL tube"<>$SessionUUID],PrefilterMaterial->GxF,Output->Options];
      Lookup[options,PrefilterMaterial],
      GxF,
      Variables:>{options},
      Messages:>{Error::DNASequencingPreparedPlateContainerInvalid,Error::InvalidInput}
    ],
    Example[{Options,FilterPoreSize,"The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],FilterPoreSize->0.22*Micrometer,Output->Options];
      Lookup[options,FilterPoreSize],
      0.22*Micrometer,
      Variables:>{options}
    ],
    (*Note: Put your sample in a 50mL tube for the following test*)
    Example[{Options,PrefilterPoreSize,"The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample in 50mL tube"<>$SessionUUID],PrefilterPoreSize->1.*Micrometer,FilterMaterial->PTFE,Output->Options];
      Lookup[options,PrefilterPoreSize],
      1.*Micrometer,
      Variables:>{options},
      Messages:>{Error::DNASequencingPreparedPlateContainerInvalid, Error::InvalidInput}
    ],
    Example[{Options,FilterSyringe,"The syringe used to force that sample through a filter:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],FiltrationType->Syringe,FilterSyringe->Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"],Output->Options];
      Lookup[options,FilterSyringe],
      ObjectP[Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"]],
      Variables:>{options}
    ],
    Example[{Options,FilterHousing,"FilterHousing option resolves to Null because it can't be used reasonably for volumes we would use in this experiment:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],FilterHousing->Null,Output->Options];
      Lookup[options,FilterHousing],
      Null,
      Variables:>{options}
    ],
    Example[{Options,FilterTime,"The amount of time for which the samples will be centrifuged during filtration:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],FiltrationType->Centrifuge,FilterTime->20*Minute,Output->Options];
      Lookup[options,FilterTime],
      20*Minute,
      EquivalenceFunction->Equal,
      Variables:>{options}
    ],
    (*Note: Put your sample in a 50mL tube for the following test*)
    Example[{Options,FilterTemperature,"The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample in 50mL tube"<>$SessionUUID],FiltrationType->Centrifuge,FilterTemperature->10*Celsius,Output->Options];
      Lookup[options,FilterTemperature],
      10*Celsius,
      EquivalenceFunction->Equal,
      Variables:>{options},
      Messages:>{Error::DNASequencingPreparedPlateContainerInvalid, Error::InvalidInput}
    ],
    Example[{Options,FilterIntensity,"The rotational speed or force at which the samples will be centrifuged during filtration:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],FiltrationType->Centrifuge,FilterIntensity->1000*RPM,Output->Options];
      Lookup[options,FilterIntensity],
      1000*RPM,
      EquivalenceFunction->Equal,
      Variables:>{options}
    ],
    Example[{Options,FilterSterile,"Indicates if the filtration of the samples should be done in a sterile environment:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],FilterSterile->True,Output->Options];
      Lookup[options,FilterSterile],
      True,
      Variables:>{options}
    ],
    Example[{Options,FilterAliquot,"The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample in 50mL tube"<>$SessionUUID],Object[Sample,"ExperimentDNASequencing test primer sample 1"<>$SessionUUID],FilterAliquot->1*Milliliter,Output->Options];
      Lookup[options,FilterAliquot],
      1*Milliliter,
      EquivalenceFunction->Equal,
      Variables:>{options}
    ],
    Example[{Options,FilterAliquotContainer,"The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],FilterAliquotContainer->{1, Model[Container, Vessel, "2mL Tube"]},Output->Options];
      Lookup[options,FilterAliquotContainer],
      {1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
      Variables:>{options}
    ],
    Example[{Options,FilterAliquotDestinationWell,"Indicates the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],FilterAliquotDestinationWell->"A1",Output->Options];
      Lookup[options,FilterAliquotDestinationWell],
      "A1",
      Variables:>{options}
    ],
    Example[{Options,FilterContainerOut,"The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],FilterContainerOut->{1, Model[Container, Vessel, "2mL Tube"]},Output->Options];
      Lookup[options,FilterContainerOut],
      {1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
      Variables:>{options}
    ],

    (*Aliquot options tests*)
    Example[{Options,Aliquot,"Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],Aliquot->True,Output->Options];
      Lookup[options,Aliquot],
      True,
      EquivalenceFunction->Equal,
      Variables:>{options}
    ],
    Example[{Options,AliquotAmount,"The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],AliquotAmount->5*Microliter,Output->Options];
      Lookup[options,AliquotAmount],
      5*Microliter,
      EquivalenceFunction->Equal,
      Variables:>{options}
    ],
    Example[{Options,AssayVolume,"The desired total volume of the aliquoted sample plus dilution buffer:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],AssayVolume->5*Microliter,Output->Options];
      Lookup[options,AssayVolume],
      5*Microliter,
      EquivalenceFunction->Equal,
      Variables:>{options}
    ],
    Example[{Options,TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],TargetConcentration->5*Micromolar,Output->Options];
      Lookup[options,TargetConcentration],
      5*Micromolar,
      EquivalenceFunction->Equal,
      Variables:>{options}
    ],
    Example[{Options,TargetConcentrationAnalyte,"Set the TargetConcentrationAnalyte option:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],TargetConcentration->1*Micromolar,TargetConcentrationAnalyte->Model[Molecule,Oligomer,"ExperimentDNASequencing test DNA molecule"<>$SessionUUID],AssayVolume->0.5*Milliliter,Output->Options];
      Lookup[options,TargetConcentrationAnalyte],
      ObjectP[Model[Molecule,Oligomer,"ExperimentDNASequencing test DNA molecule"<>$SessionUUID]],
      Variables:>{options}
    ],
    Example[{Options,ConcentratedBuffer,"The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->5*Microliter,AssayVolume->0.5*Milliliter,Output->Options];
      Lookup[options,ConcentratedBuffer],
      ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
      Variables:>{options}
    ],
    Example[{Options,BufferDilutionFactor,"The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],BufferDilutionFactor->10,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->1*Microliter,AssayVolume->5*Microliter,Output->Options];
      Lookup[options,BufferDilutionFactor],
      10,
      EquivalenceFunction->Equal,
      Variables:>{options}
    ],
    Example[{Options,BufferDiluent,"The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],BufferDiluent->Model[Sample,"Milli-Q water"],BufferDilutionFactor->10,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->5*Microliter,AssayVolume->0.8*Milliliter,Output->Options];
      Lookup[options,BufferDiluent],
      ObjectP[Model[Sample,"Milli-Q water"]],
      Variables:>{options}
    ],
    Example[{Options,AssayBuffer,"The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],AssayBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->5*Microliter,AssayVolume->0.8*Milliliter,Output->Options];
      Lookup[options,AssayBuffer],
      ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
      Variables:>{options}
    ],
    Example[{Options,AliquotSampleStorageCondition,"The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],AliquotSampleStorageCondition->Refrigerator,Output->Options];
      Lookup[options,AliquotSampleStorageCondition],
      Refrigerator,
      Variables:>{options}
    ],
    Example[{Options,ConsolidateAliquots,"Indicates if identical aliquots should be prepared in the same container/position:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],ConsolidateAliquots->True,Output->Options];
      Lookup[options,ConsolidateAliquots],
      True,
      Variables:>{options}
    ],
    Example[{Options,AliquotPreparation,"Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],Aliquot->True,AliquotPreparation->Manual,Output->Options];
      Lookup[options,AliquotPreparation],
      Manual,
      Variables:>{options}
    ],
    Example[{Options,AliquotContainer,"The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],AliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
      Lookup[options,AliquotContainer],
      {1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
      Variables:>{options}
    ],
    Example[{Options,DestinationWell,"Indicates the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],DestinationWell->"A1",Output->Options];
      Lookup[options,DestinationWell],
      "A1",
      Variables:>{options}
    ],

    (*Post-processing options tests*)
    Example[{Options,MeasureWeight,"Set the MeasureWeight option:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],MeasureWeight->True,Output->Options];
      Lookup[options,MeasureWeight],
      True,
      Variables:>{options}
    ],
    Example[{Options,MeasureVolume,"Set the MeasureVolume option:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],MeasureVolume->True,Output->Options];
      Lookup[options,MeasureVolume],
      True,
      Variables:>{options}
    ],
    Example[{Options,ImageSample,"Set the ImageSample option:"},
      options=ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],ImageSample->True,Output->Options];
      Lookup[options,ImageSample],
      True,
      Variables:>{options}
    ],
    Example[{Options, Name, "Specify the Name of the created DNASequencing object:"},
      options = ExperimentDNASequencing[Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID], Name -> "My special DNASequencing object name", Output -> Options];
      Lookup[options, Name],
      "My special DNASequencing object name",
      Variables :> {options}
    ]

  },
  
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $EmailEnabled=False,
    Search[Model[Container,Plate],__]={
      Model[Container,Plate,"id:Z1lqpMGjee35"],Model[Container,Plate,"id:L8kPEjkmLbvW"],Model[Container,Plate,"id:n0k9mGzRaaBn"],
      Model[Container,Plate,"id:Vrbp1jG800ME"],Model[Container,Plate,"id:E8zoYveRllM7"],Model[Container,Plate,"id:qdkmxzkKwn11"],
      Model[Container,Plate,"id:1ZA60vwjbbqa"],Model[Container,Plate,"id:Z1lqpMGjeekO"],Model[Container,Plate,"id:L8kPEjNLDDvN"],
      Model[Container,Plate,"id:7X104vK9ZZ7X"],Model[Container,Plate,"id:eGakld01zzLx"],Model[Container,Plate,"id:P5ZnEj4P88qr"],
      Model[Container,Plate,"id:6V0npvK611zG"],Model[Container,Plate,"id:Vrbp1jG800zm"],Model[Container,Plate,"id:XnlV5jmbZZZN"],
      Model[Container,Plate,"id:3em6Zv9NjjjB"],Model[Container,Plate,"id:6V0npvK6111w"],Model[Container,Plate,"id:4pO6dMWvnnJ5"],
      Model[Container,Plate,"id:P5ZnEj4P88kW"],Model[Container,Plate,"id:6V0npvK611rw"],Model[Container,Plate,"id:Vrbp1jG800Vb"],
      Model[Container,Plate,"id:GmzlKjY5EE8e"],Model[Container,Plate,"id:bq9LA0dBGGYv"],Model[Container,Plate,"id:01G6nvkKrrZm"],
      Model[Container,Plate,"id:zGj91aR3ddeJ"],Model[Container,Plate,"id:bq9LA0dBGGlv"],Model[Container,Plate,"id:M8n3rxYE55OP"],
      Model[Container,Plate,"id:01G6nvkKrrYm"],Model[Container,Plate,"id:eGakld01zzxE"],Model[Container,Plate,"id:XnlV5jmbZZ3n"],
      Model[Container,Plate,"id:01G6nvkKrrY4"],Model[Container,Plate,"id:dORYzZn0oove"],Model[Container,Plate,"id:E8zoYveRlldX"],
      Model[Container,Plate,"id:wqW9BP4Y00G4"],Model[Container,Plate,"id:rea9jl1orrV5"],Model[Container,Plate,"id:jLq9jXY4kknW"],
      Model[Container,Plate,"id:6V0npvK611DZ"],Model[Container,Plate,"id:WNa4ZjRr55E7"],Model[Container,Plate,"id:Z1lqpMGjeePM"],
      Model[Container,Plate,"id:4pO6dMWvnnP7"],Model[Container,Plate,"id:jLq9jXY4kkKW"],Model[Container,Plate,"id:aXRlGnZmOOqv"],
      Model[Container,Plate,"id:L8kPEjNLDDLA"],Model[Container,Plate,"id:M8n3rxYE55E5"],Model[Container,Plate,"id:R8e1PjRDbbEK"],
      Model[Container,Plate,"id:WNa4ZjRr551q"],Model[Container,Plate,"id:kEJ9mqR3XELE"],Model[Container,Plate,"id:BYDOjvG1pRnE"],
      Model[Container,Plate,"id:O81aEBZ4EMXj"],Model[Container,Plate,"id:P5ZnEjddrmNW"],Model[Container,Plate,"id:4pO6dM55ar55"],
      Model[Container,Plate,"id:pZx9jo8x59oP"],Model[Container,Plate,"id:R8e1PjpBXOpX"],Model[Container,Plate,"id:54n6evLWKqbG"],
      Model[Container,Plate,"id:pZx9jo83G0VP"],Model[Container,Plate,"id:L8kPEjno5XoE"],Model[Container,Plate,"id:P5ZnEjdmXJmE"],
      Model[Container,Plate,"id:8qZ1VW06z9Zp"],Model[Container,Plate,"id:9RdZXv1laYVK"],Model[Container,Plate,"id:eGakldJ5M44n"],
      Model[Container,Plate,"id:Y0lXejML17rm"],Model[Container,Plate,"id:R8e1PjpVrbMv"],Model[Container,Plate,"id:L8kPEjn1Y9v6"],
      Model[Container,Plate,"id:7X104vnG34Pd"],Model[Container,Plate,"id:D8KAEvGmOEMm"],Model[Container,Plate,"id:aXRlGn6YwGN9"],
      Model[Container,Plate,"id:qdkmxzqrmP04"],Model[Container,Plate,"id:R8e1PjpV1zR4"],Model[Container,Plate,"id:wqW9BP7N0w7V"],
      Model[Container,Plate,"id:AEqRl9KmGPWa"],Model[Container,Plate,"id:Z1lqpMz8K5n0"],Model[Container,Plate,"id:XnlV5jKArpnn"],
      Model[Container,Plate,"id:KBL5Dvw0kGJJ"],Model[Container,Plate,"id:01G6nvwADjX1"],Model[Container,Plate,"id:GmzlKjP9KdJ9"],
      Model[Container,Plate,"id:rea9jlRLlqYr"],Model[Container,Plate,"id:54n6evLezbmN"],Model[Container,Plate,"id:eGakldJPJkzE"],
      Model[Container,Plate,"id:7X104vn56dLX"],Model[Container,Plate,"id:01G6nvwNDARA"],Model[Container,Plate,"id:L8kPEjnarBZW"],
      Model[Container,Plate,"id:jLq9jXvzR0XR"],Model[Container,Plate,"id:7X104vneWNvw"],Model[Container,Plate,"id:1ZA60vL978v8"],
      Model[Container,Plate,"id:Z1lqpMzn3JMV"],Model[Container,Plate,"id:dORYzZJqe6e5"],Model[Container,Plate,"id:eGakldJRp9po"],
      Model[Container,Plate,"id:M8n3rx0w7ZNR"],Model[Container,Plate,"id:Y0lXejMaRo0P"],Model[Container,Plate,"id:Z1lqpMz1EnVL"],
      Model[Container,Plate,"id:rea9jlR4L8eO"],Model[Container,Plate,"id:KBL5DvwJ0q4k"],Model[Container,Plate,"id:jLq9jXvN5Bpz"],
      Model[Container,Plate,"id:L8kPEjnY8dME"],Model[Container,Plate,"id:dORYzZJwOJb5"],Model[Container,Plate,"id:1ZA60vLlZzrM"],
      Model[Container,Plate,"id:Y0lXejMW7NMo"],Model[Container,Plate,"id:Vrbp1jKw7W9q"],Model[Container,Plate,"id:vXl9j57AR9lD"],
      Model[Container,Plate,"id:8qZ1VW0na15R"],Model[Container,Plate,"id:xRO9n3Brzr1Z"],Model[Container,Plate,"id:lYq9jRx9p4xA"],
      Model[Container,Plate,"id:pZx9jo89qRqM"],Model[Container,Plate,"id:D8KAEvG0vN8l"],Model[Container,Plate,"id:Y0lXejMPjv1P"],
      Model[Container,Plate,"id:aXRlGn615Kak"],Model[Container,Plate,"id:mnk9jORMlWlY"],Model[Container,Plate,"id:Z1lqpMzk6Vao"],
      Model[Container,Plate,"id:kEJ9mqRMNA98"],Model[Container,Plate,"id:3em6ZvLwoEK7"],Model[Container,Plate,"id:54n6evLlR8YL"],
      Model[Container,Plate,"id:J8AY5jD98R1Z"],Model[Container,Plate,"id:O81aEBZjRXvx"]
    }
  },

  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Error::ContainerTooSmall];
    Module[{allObjects,existingObjects},
      ClearMemoization[];

      (*Gather all the objects and models created in SymbolSetUp*)
      allObjects=Cases[Flatten[{
        Object[Container, Bench, "Test bench for ExperimentDNASequencing tests"<>$SessionUUID],
        Object[Container,Vessel,BufferCartridge,"Buffer cartridge for ExperimentDNASequencing test"<>$SessionUUID],
        Object[Container,Vessel,BufferCartridge,"Old Buffer cartridge for ExperimentDNASequencing test"<>$SessionUUID],
        Object[Instrument, GeneticAnalyzer, "Instrument for ExperimentDNASequencing test"<>$SessionUUID],
        Object[Item, PlateSeal, "Test plate septa for ExperimentDNASequencing"<>$SessionUUID],
        Object[Item, "Test capillary protector for ExperimentDNASequencing"<>$SessionUUID],
        Object[Item,Cartridge,DNASequencing,"ExperimentDNASequencing test sequencing cartridge"<>$SessionUUID],
        Object[Item,"Test buffer cartridge septa for ExperimentDNASequencing"<>$SessionUUID],
        Model[Item,Cartridge,DNASequencing,"ExperimentDNASequencing test sequencing cartridge model wrong AnodeBuffer and Polymer"<>$SessionUUID],
        Model[Container,Vessel,BufferCartridge,"ExperimentDNASequencing test buffer cartridge model wrong CathodeSequencingBuffer"<>$SessionUUID],
        Object[Item,Cartridge,DNASequencing,"ExperimentDNASequencing test sequencing cartridge with wrong polymer and anode buffer"<>$SessionUUID],
        Object[Container,Vessel,BufferCartridge,"ExperimentDNASequencing test buffer cartridge with wrong cathode buffer"<>$SessionUUID],

        Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 1"<>$SessionUUID],
        Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 2"<>$SessionUUID],
        Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 3"<>$SessionUUID],
        Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 4"<>$SessionUUID],
        Object[Container,Vessel,"ExperimentDNASequencing test 2mL tube"<>$SessionUUID],
        Object[Container,Vessel,"ExperimentDNASequencing test 2mL tube for master mix"<>$SessionUUID],
        Object[Container,Vessel,"ExperimentDNASequencing test 2mL tube for Hi-Di Formamide"<>$SessionUUID],
        Object[Container,Vessel,"ExperimentDNASequencing test 50mL tube"<>$SessionUUID],

        Model[Molecule,Oligomer,"ExperimentDNASequencing test DNA molecule"<>$SessionUUID],

        Model[Sample,"ExperimentDNASequencing test DNA sample"<>$SessionUUID],
        Model[Sample,"ExperimentDNASequencing test DNA sample (Deprecated)"<>$SessionUUID],
        Model[Sample,"ExperimentDNASequencing test DNA sample with Null composition"<>$SessionUUID],
        Model[Sample,"ExperimentDNASequencing test Master Mix with BigDye Direct composition"<>$SessionUUID],
        Model[Sample,"ExperimentDNASequencing test DNA sample with multiple oligomers"<>$SessionUUID],
        Model[Sample,"ExperimentDNASequencing test solid DNA sample"<>$SessionUUID],

        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test sample 2"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test primer sample 2"<>$SessionUUID],

        Object[Sample, "ExperimentDNASequencing test BigDye Direct MasterMix in 2 mL tube"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test Hi-Di Formamide in 2 mL tube"<>$SessionUUID],

        Object[Sample,"ExperimentDNASequencing test discarded sample"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test discarded primer sample"<>$SessionUUID],

        Object[Sample,"ExperimentDNASequencing test deprecated model sample"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test deprecated model primer sample"<>$SessionUUID],

        Object[Sample,"ExperimentDNASequencing test sample 3"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test sample with Null composition"<>$SessionUUID],

        Object[Sample,"ExperimentDNASequencing test sample multiple oligomers"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test primer sample multiple oligomers"<>$SessionUUID],

        Object[Sample,"ExperimentDNASequencing test sample in 2mL tube"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test sample in 50mL tube"<>$SessionUUID],

        Object[Sample,"ExperimentDNASequencing test model-less sample"<>$SessionUUID],

        Object[Sample,"ExperimentDNASequencing test plate sample A1"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test plate sample B1"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test plate sample C1"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test plate sample D1"<>$SessionUUID],

        Object[Sample,"ExperimentDNASequencing test solid sample"<>$SessionUUID],

        Object[Protocol, DNASequencing, "Already existing name"<>$SessionUUID],
        Object[Protocol, DNASequencing, "Parent Protocol for Template ExperimentDNASequencing tests"<>$SessionUUID]

      }],ObjectP[]];

      (*Check whether the names we want to give below already exist in the database*)
      existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

      (*Erase any test objects and models that we failed to erase in the last unit test*)
      Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
    ];


    Block[{$AllowSystemsProtocols=True},
      Module[{testBench, testProtocol, testInstrument, testPlateSepta, testCapillaryProtector, testSequencingCartridge, parentProtocol,
        emptyTestContainers,testBufferCartridge,testOldBufferCartridge,fakeBufferCartridgeSepta,testOligomer,testSequencingCartridgeModel,testBufferCartridgeModel,testInstrumentPartsIncorrect,
        testSampleModels,testDeprecatedSampleModel,testSampleContainerObjects,testSampleContainerResourceObjects,testDiscardedSamples,testModellessSample,
        containerSampleObjects,instrumentPartsObjects,developerObjects,allObjects},

        (* set up fake bench as a location for the vessel *)
        {testBench, testProtocol, parentProtocol} = Upload[{
            <|
              Type -> Object[Container, Bench],
              Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
              Name -> "Test bench for ExperimentDNASequencing tests"<>$SessionUUID,
              DeveloperObject -> True,
              Site->Link[$Site],
              StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
            |>,
            <|
              Type -> Object[Protocol, DNASequencing],
              Name -> "Already existing name"<>$SessionUUID,
              Site->Link[$Site],
              DeveloperObject -> True
            |>,
            <|
              Type -> Object[Protocol, DNASequencing],
              Name -> "Parent Protocol for Template ExperimentDNASequencing tests"<>$SessionUUID,
              Site->Link[$Site],
              DeveloperObject -> True
            |>
        }];

        (* --- Test Instrument and Resources --- *)

        {testBufferCartridge, testOldBufferCartridge} = UploadSample[
          {Model[Container, Vessel, BufferCartridge, "SeqStudio Buffer Cartridge"],Model[Container, Vessel, BufferCartridge, "SeqStudio Buffer Cartridge"]},
          {{"Work Surface", testBench},{"Work Surface", testBench}},
          Name-> {"Buffer cartridge for ExperimentDNASequencing test"<>$SessionUUID,"Old Buffer cartridge for ExperimentDNASequencing test"<>$SessionUUID},
          Status-> {Stocked,Stocked},
          StorageCondition-> {Link[Model[StorageCondition, "Ambient Storage"]],Link[Model[StorageCondition,"Ambient Storage"]]},
          Expires-> {False,False}
        ];

        testInstrument = Upload[
          <|
            Type -> Object[Instrument, GeneticAnalyzer],
            Model -> Link[Model[Instrument, GeneticAnalyzer, "SeqStudio"], Objects],
            Site->Link[$Site],
            Name -> "Instrument for ExperimentDNASequencing test"<>$SessionUUID,
            Software -> "SeqStudio Plate Manager",
            Status ->Available,
            DataFilePath -> "Data\\SeqStudio DNASequencing",
            MethodFilePath->"Instrument Methods\\SeqStudio",
            Replace[Contents]-> {{"BufferCartridge Slot", Link[testOldBufferCartridge, Container]}},
            DeveloperObject->True
          |>
        ];

        testPlateSepta = Upload[<|
            Type -> Object[Item,PlateSeal],
            Model -> Link[Model[Item, PlateSeal, "Plate Seal, 96-Well Round Septa"],Objects],
            Name -> "Test plate septa for ExperimentDNASequencing"<>$SessionUUID,
            Status -> Stocked,
            Site -> Link[$Site],
            StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
            Count->5
        |>];
        testCapillaryProtector = Upload[<|
            Type -> Object[Item],
            Model -> Link[Model[Item, "Genetic Analyzer Sequencing Cartridge Capillary Protector"],Objects],
            Name -> "Test capillary protector for ExperimentDNASequencing"<>$SessionUUID,
            Status -> Stocked,
            Site -> Link[$Site],
            StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
        |>];
        testSequencingCartridge = Upload[
          <|
            Type -> Object[Item, Cartridge,DNASequencing],
            Model -> Link[Model[Item, Cartridge,DNASequencing, "SeqStudio Sequencing Cartridge"], Objects],
            Name -> "ExperimentDNASequencing test sequencing cartridge"<>$SessionUUID,
            Status ->Stocked,
            Site -> Link[$Site],
            StorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
            Count->5
          |>
        ];
        fakeBufferCartridgeSepta = Upload[<|
          Type -> Object[Item],
          Model -> Link[Model[Item, "Genetic Analyzer Buffer Cartridge Septa"],Objects],
          Name -> "Test buffer cartridge septa for ExperimentDNASequencing"<>$SessionUUID,
          Status -> Stocked,
          Site -> Link[$Site],
          StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
          Count->5
        |>];

        {testSequencingCartridgeModel,testBufferCartridgeModel} = Upload[{
          <|
            Type->Model[Item,Cartridge,DNASequencing],
            Name->"ExperimentDNASequencing test sequencing cartridge model wrong AnodeBuffer and Polymer"<>$SessionUUID,
            AnodeBuffer->Link[Model[Sample,"Milli-Q water"]],
            Polymer->Link[Model[Sample,"Milli-Q water"]],
            CartridgeType->Column,
            NumberOfCapillaries->4,
            DeveloperObject->True
          |>,
          <|
            Type->Model[Container,Vessel,BufferCartridge],
            Name->"ExperimentDNASequencing test buffer cartridge model wrong CathodeSequencingBuffer"<>$SessionUUID,
            CathodeSequencingBuffer->Link[Model[Sample,"Milli-Q water"]],
            DeveloperObject->True
          |>
        }];

        testInstrumentPartsIncorrect = Upload[{
          <|
            Type->Object[Item,Cartridge,DNASequencing],
            Model -> Link[Model[Item, Cartridge,DNASequencing, "ExperimentDNASequencing test sequencing cartridge model wrong AnodeBuffer and Polymer"<>$SessionUUID], Objects],
            Name->"ExperimentDNASequencing test sequencing cartridge with wrong polymer and anode buffer"<>$SessionUUID,
            Site->Link[$Site],
            Status -> Stocked
          |>,
          <|
            Type->Object[Container,Vessel,BufferCartridge],
            Model -> Link[Model[Container, Vessel, BufferCartridge, "ExperimentDNASequencing test buffer cartridge model wrong CathodeSequencingBuffer"<>$SessionUUID], Objects],
            Name->"ExperimentDNASequencing test buffer cartridge with wrong cathode buffer"<>$SessionUUID,
            CathodeSequencingBuffer->Link[Model[Sample,"Milli-Q water"]],
            Site->Link[$Site],
            Status ->Stocked
          |>
        }];

        UploadLocation[{testPlateSepta,testCapillaryProtector,testSequencingCartridge,fakeBufferCartridgeSepta},{"Work Surface",testBench}];

        (*Make some empty test container objects*)
        emptyTestContainers=UploadSample[
          {
           Model[Container,Plate,"id:Z1lqpMz1EnVL"],
           Model[Container,Plate,"id:Z1lqpMz1EnVL"],
           Model[Container,Plate,"id:Z1lqpMz1EnVL"],
           Model[Container,Plate,"id:Z1lqpMz1EnVL"],
            Model[Container, Vessel, "2mL Tube"],
            Model[Container, Vessel, "2mL Tube"],
            Model[Container, Vessel, "2mL Tube"],
            Model[Container, Vessel, "50mL Tube"]
          },
          {
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
                Available
              },
          Name ->
              {
                "ExperimentDNASequencing test 96-well PCR plate 1"<>$SessionUUID,
                "ExperimentDNASequencing test 96-well PCR plate 2"<>$SessionUUID,
                "ExperimentDNASequencing test 96-well PCR plate 3"<>$SessionUUID,
                "ExperimentDNASequencing test 96-well PCR plate 4"<>$SessionUUID,
                "ExperimentDNASequencing test 2mL tube"<>$SessionUUID,
                "ExperimentDNASequencing test 2mL tube for master mix"<>$SessionUUID,
                "ExperimentDNASequencing test 2mL tube for Hi-Di Formamide"<>$SessionUUID,
                "ExperimentDNASequencing test 50mL tube"<>$SessionUUID
              }
        ];

        (*Make a test DNA identity model*)
        testOligomer=UploadOligomer["ExperimentDNASequencing test DNA molecule"<>$SessionUUID,Molecule->Strand[RandomSequence[500]],PolymerType->DNA];

        (*Make some test sample models*)
        testSampleModels=UploadSampleModel[
          {
            "ExperimentDNASequencing test DNA sample"<>$SessionUUID,
            "ExperimentDNASequencing test DNA sample (Deprecated)"<>$SessionUUID,
            "ExperimentDNASequencing test DNA sample with Null composition"<>$SessionUUID,
            "ExperimentDNASequencing test Master Mix with BigDye Direct composition"<>$SessionUUID,
            "ExperimentDNASequencing test DNA sample with multiple oligomers"<>$SessionUUID,
            "ExperimentDNASequencing test solid DNA sample"<>$SessionUUID
          },
          Composition->
              {
                {{10 Micromolar,Model[Molecule,Oligomer,"ExperimentDNASequencing test DNA molecule"<>$SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}},
                {{10 Micromolar,Model[Molecule,Oligomer,"ExperimentDNASequencing test DNA molecule"<>$SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}},
                {{Null, Null}},
                {{10 Micromolar,Model[Molecule,"LIZ Dye"]},{100 VolumePercent,Model[Molecule,"Water"]}},
                {{10 Micromolar,Model[Molecule,Oligomer,"ExperimentDNASequencing test DNA molecule"<>$SessionUUID]},{10 Micromolar,Model[Molecule,Oligomer,"ExperimentDNASequencing test DNA molecule"<>$SessionUUID]}},
                {{100 MassPercent,Model[Molecule,Oligomer,"ExperimentDNASequencing test DNA molecule"<>$SessionUUID]}}
              },
          IncompatibleMaterials->ConstantArray[{None},6],
          Expires->ConstantArray[True,6],
          ShelfLife->ConstantArray[2 Year,6],
          UnsealedShelfLife->ConstantArray[90 Day,6],
          DefaultStorageCondition->ConstantArray[Model[StorageCondition,"Ambient Storage"],6],
          MSDSRequired->ConstantArray[False,6],
          BiosafetyLevel->ConstantArray["BSL-1",6],
          State-> {Liquid,Liquid,Liquid,Liquid,Liquid,Solid}
        ];

        (*Make a deprecated test sample model*)
        testDeprecatedSampleModel=Upload[
          <|
            Object->Model[Sample,"ExperimentDNASequencing test DNA sample (Deprecated)"<>$SessionUUID],
            Deprecated->True
          |>
        ];

        (*Make some test sample objects in the test container objects*)
        testSampleContainerObjects=UploadSample[
          Join[
            ConstantArray[Model[Sample,"ExperimentDNASequencing test DNA sample"<>$SessionUUID],6],
            ConstantArray[Model[Sample,"ExperimentDNASequencing test DNA sample (Deprecated)"<>$SessionUUID],2],
            {Model[Sample,"ExperimentDNASequencing test DNA sample"<>$SessionUUID],Model[Sample,"ExperimentDNASequencing test DNA sample with Null composition"<>$SessionUUID]},
            ConstantArray[Model[Sample,"ExperimentDNASequencing test DNA sample with multiple oligomers"<>$SessionUUID],2],
            ConstantArray[Model[Sample,"ExperimentDNASequencing test DNA sample"<>$SessionUUID],2],
            ConstantArray[Model[Sample,"ExperimentDNASequencing test DNA sample"<>$SessionUUID],5]
          ],
          {
            {"A1",Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 1"<>$SessionUUID]},
            {"A1",Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 2"<>$SessionUUID]},
            {"A2",Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 2"<>$SessionUUID]},
            {"A3",Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 2"<>$SessionUUID]},

            {"B1",Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 2"<>$SessionUUID]},
            {"B2",Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 2"<>$SessionUUID]},

            {"C1",Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 2"<>$SessionUUID]},
            {"C2",Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 2"<>$SessionUUID]},

            {"D1",Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 2"<>$SessionUUID]},
            {"D2",Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 2"<>$SessionUUID]},

            {"E1",Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 2"<>$SessionUUID]},
            {"E2",Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 2"<>$SessionUUID]},

            {"A1",Object[Container,Vessel,"ExperimentDNASequencing test 2mL tube"<>$SessionUUID]},
            {"A1",Object[Container,Vessel,"ExperimentDNASequencing test 50mL tube"<>$SessionUUID]},

            {"A1",Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 4"<>$SessionUUID]},
            {"B1",Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 4"<>$SessionUUID]},
            {"C1",Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 4"<>$SessionUUID]},
            {"D1",Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 4"<>$SessionUUID]},

            {"E3",Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 2"<>$SessionUUID]}

          },
          Name->
              {
                "ExperimentDNASequencing test sample 1"<>$SessionUUID,
                "ExperimentDNASequencing test sample 2"<>$SessionUUID,
                "ExperimentDNASequencing test primer sample 1"<>$SessionUUID,
                "ExperimentDNASequencing test primer sample 2"<>$SessionUUID,

                "ExperimentDNASequencing test discarded sample"<>$SessionUUID,
                "ExperimentDNASequencing test discarded primer sample"<>$SessionUUID,

                "ExperimentDNASequencing test deprecated model sample"<>$SessionUUID,
                "ExperimentDNASequencing test deprecated model primer sample"<>$SessionUUID,

                "ExperimentDNASequencing test sample 3"<>$SessionUUID,
                "ExperimentDNASequencing test sample with Null composition"<>$SessionUUID,

                "ExperimentDNASequencing test sample multiple oligomers"<>$SessionUUID,
                "ExperimentDNASequencing test primer sample multiple oligomers"<>$SessionUUID,

                "ExperimentDNASequencing test sample in 2mL tube"<>$SessionUUID,
                "ExperimentDNASequencing test sample in 50mL tube"<>$SessionUUID,

                "ExperimentDNASequencing test plate sample A1"<>$SessionUUID,
                "ExperimentDNASequencing test plate sample B1"<>$SessionUUID,
                "ExperimentDNASequencing test plate sample C1"<>$SessionUUID,
                "ExperimentDNASequencing test plate sample D1"<>$SessionUUID,

                "ExperimentDNASequencing test solid sample"<>$SessionUUID
              },
          InitialAmount->Join[
            {50*Microliter},
            ConstantArray[6*Microliter, 12],
            {5 Milliliter},
            ConstantArray[6*Microliter,4],{20Milligram}
          ]
        ];

        Upload[<|Object->Object[Sample, "ExperimentDNASequencing test solid sample"<>$SessionUUID],State->Solid|>];

        (* make objects for resource picking that are not developer objects *)
        testSampleContainerResourceObjects=UploadSample[
            {Model[Sample,"Hi-Di formamide"],Model[Sample,"BigDye Direct Sequencing Master Mix"]},
          {
            {"A1",Object[Container,Vessel,"ExperimentDNASequencing test 2mL tube for master mix"<>$SessionUUID]},
            {"A1",Object[Container,Vessel,"ExperimentDNASequencing test 2mL tube for Hi-Di Formamide"<>$SessionUUID]}
          },
          Name->
              {
                "ExperimentDNASequencing test BigDye Direct MasterMix in 2 mL tube"<>$SessionUUID,
                "ExperimentDNASequencing test Hi-Di Formamide in 2 mL tube"<>$SessionUUID
              },
          InitialAmount->{1 Milliliter, 1 Milliliter}
        ];

        (*Modify some properties of the test sample objects*)
        testDiscardedSamples=UploadSampleStatus[
          {
            Object[Sample,"ExperimentDNASequencing test discarded sample"<>$SessionUUID],
            Object[Sample,"ExperimentDNASequencing test discarded primer sample"<>$SessionUUID]
          },
          ConstantArray[Discarded,2]
        ];

        (*Make a test model-less sample object*)
        testModellessSample=UploadSample[
          {{10 Micromolar,Model[Molecule,Oligomer,"ExperimentDNASequencing test DNA molecule"<>$SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}},
          {"A1",Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 3"<>$SessionUUID]},
          Name->"ExperimentDNASequencing test model-less sample"<>$SessionUUID,
          InitialAmount->0.5 Milliliter
        ];


        (*Gather all the created objects and models*)
        containerSampleObjects={emptyTestContainers,testOligomer,testSampleModels,testDeprecatedSampleModel,testSampleContainerObjects,testDiscardedSamples,testModellessSample};

      (* gather the instrument parts *)
        instrumentPartsObjects={testBufferCartridge,testOldBufferCartridge,testSequencingCartridge,testCapillaryProtector,testPlateSepta,fakeBufferCartridgeSepta,testInstrument,testSampleContainerResourceObjects};

        (*Make all the test objects and models except the instrument parts developer objects*)
        developerObjects=Upload[<|Object->#,DeveloperObject->True|>&/@Flatten[containerSampleObjects]];

        (*Gather all the test objects and models created in SymbolSetUp*)
        allObjects=Flatten[{instrumentPartsObjects,developerObjects}];

      ]
    ]
  ),


  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    Module[{allObjects,existingObjects},

      (*Gather all the objects and models created in SymbolSetUp*)
      allObjects=Cases[Flatten[{
        Object[Container, Bench, "Test bench for ExperimentDNASequencing tests"<>$SessionUUID],
        Object[Container,Vessel,BufferCartridge,"Buffer cartridge for ExperimentDNASequencing test"<>$SessionUUID],
        Object[Container,Vessel,BufferCartridge,"Old Buffer cartridge for ExperimentDNASequencing test"<>$SessionUUID],
        Object[Instrument, GeneticAnalyzer, "Instrument for ExperimentDNASequencing test"<>$SessionUUID],
        Object[Item, PlateSeal, "Test plate septa for ExperimentDNASequencing"<>$SessionUUID],
        Object[Item, "Test capillary protector for ExperimentDNASequencing"<>$SessionUUID],
        Object[Item,Cartridge,DNASequencing,"ExperimentDNASequencing test sequencing cartridge"<>$SessionUUID],
        Object[Item,"Test buffer cartridge septa for ExperimentDNASequencing"<>$SessionUUID],
        Model[Item,Cartridge,DNASequencing,"ExperimentDNASequencing test sequencing cartridge model wrong AnodeBuffer and Polymer"<>$SessionUUID],
        Model[Container,Vessel,BufferCartridge,"ExperimentDNASequencing test buffer cartridge model wrong CathodeSequencingBuffer"<>$SessionUUID],
        Object[Item,Cartridge,DNASequencing,"ExperimentDNASequencing test sequencing cartridge with wrong polymer and anode buffer"<>$SessionUUID],
        Object[Container,Vessel,BufferCartridge,"ExperimentDNASequencing test buffer cartridge with wrong cathode buffer"<>$SessionUUID],

        Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 1"<>$SessionUUID],
        Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 2"<>$SessionUUID],
        Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 3"<>$SessionUUID],
        Object[Container,Plate,"ExperimentDNASequencing test 96-well PCR plate 4"<>$SessionUUID],
        Object[Container,Vessel,"ExperimentDNASequencing test 2mL tube"<>$SessionUUID],
        Object[Container,Vessel,"ExperimentDNASequencing test 2mL tube for master mix"<>$SessionUUID],
        Object[Container,Vessel,"ExperimentDNASequencing test 2mL tube for Hi-Di Formamide"<>$SessionUUID],
        Object[Container,Vessel,"ExperimentDNASequencing test 50mL tube"<>$SessionUUID],
        Object[Container,Vessel,BufferCartridge,"ExperimentDNASequencing test buffer cartridge"<>$SessionUUID],

        Model[Molecule,Oligomer,"ExperimentDNASequencing test DNA molecule"<>$SessionUUID],

        Model[Sample,"ExperimentDNASequencing test DNA sample"<>$SessionUUID],
        Model[Sample,"ExperimentDNASequencing test DNA sample (Deprecated)"<>$SessionUUID],
        Model[Sample,"ExperimentDNASequencing test DNA sample with Null composition"<>$SessionUUID],
        Model[Sample,"ExperimentDNASequencing test Master Mix with BigDye Direct composition"<>$SessionUUID],
        Model[Sample,"ExperimentDNASequencing test DNA sample with multiple oligomers"<>$SessionUUID],
        Model[Sample,"ExperimentDNASequencing test solid DNA sample"<>$SessionUUID],

        Object[Sample,"ExperimentDNASequencing test sample 1"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test sample 2"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test primer sample 1"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test primer sample 2"<>$SessionUUID],

        Object[Sample, "ExperimentDNASequencing test BigDye Direct MasterMix in 2 mL tube"<>$SessionUUID],
        Object[Sample, "ExperimentDNASequencing test Hi-Di Formamide in 2 mL tube"<>$SessionUUID],

        Object[Sample,"ExperimentDNASequencing test discarded sample"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test discarded primer sample"<>$SessionUUID],

        Object[Sample,"ExperimentDNASequencing test deprecated model sample"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test deprecated model primer sample"<>$SessionUUID],

        Object[Sample,"ExperimentDNASequencing test sample 3"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test sample with Null composition"<>$SessionUUID],

        Object[Sample,"ExperimentDNASequencing test sample multiple oligomers"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test primer sample multiple oligomers"<>$SessionUUID],

        Object[Sample,"ExperimentDNASequencing test model-less sample"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test sample in 2mL tube"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test sample in 50mL tube"<>$SessionUUID],

        Object[Sample,"ExperimentDNASequencing test plate sample A1"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test plate sample B1"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test plate sample C1"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencing test plate sample D1"<>$SessionUUID],

        Object[Sample,"ExperimentDNASequencing test solid sample"<>$SessionUUID],

        Object[Protocol, DNASequencing, "Already existing name"<>$SessionUUID],
        Object[Protocol, DNASequencing, "Parent Protocol for Template ExperimentDNASequencing tests"<>$SessionUUID]


      }],ObjectP[]];

      (*Check whether the created objects and models exist in the database*)
      existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
    ];
  )
];




(* ::Subsection::Closed:: *)
(*ExperimentDNASequencingOptions*)


DefineTests[ExperimentDNASequencingOptions,
  {
    Example[{Basic,"Returns the options in table form given a sample:"},
      ExperimentDNASequencingOptions[
        Object[Sample,"ExperimentDNASequencingOptions test sample 1"<>$SessionUUID]
      ],
      _Grid,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic,"Returns the options in table form given a sample and a primer:"},
      ExperimentDNASequencingOptions[
        Object[Sample,"ExperimentDNASequencingOptions test sample 1"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencingOptions test primer sample 1"<>$SessionUUID]
      ],
      _Grid,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options,OutputFormat,"If OutputFormat -> List, returns the options as a list of rules:"},
      ExperimentDNASequencingOptions[
        Object[Sample,"ExperimentDNASequencingOptions test sample 1"<>$SessionUUID],
        OutputFormat->List
      ],
      {_Rule..},
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic, "View any potential issues with provided inputs/options displayed:"},
      ExperimentDNASequencingOptions[
        Object[Sample,"ExperimentDNASequencingOptions test sample 1"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencingOptions test primer sample 1"<>$SessionUUID],
        PreparedPlate -> True
      ],
      _Grid,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      ),
      Messages :> {Error::DNASequencingPreparedPlateInputInvalid, Error::InvalidInput}
    ]
  },
  
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $EmailEnabled=False,
    Search[Model[Container,Plate],__]={
      Model[Container,Plate,"id:Z1lqpMGjee35"],Model[Container,Plate,"id:L8kPEjkmLbvW"],Model[Container,Plate,"id:n0k9mGzRaaBn"],
      Model[Container,Plate,"id:Vrbp1jG800ME"],Model[Container,Plate,"id:E8zoYveRllM7"],Model[Container,Plate,"id:qdkmxzkKwn11"],
      Model[Container,Plate,"id:1ZA60vwjbbqa"],Model[Container,Plate,"id:Z1lqpMGjeekO"],Model[Container,Plate,"id:L8kPEjNLDDvN"],
      Model[Container,Plate,"id:7X104vK9ZZ7X"],Model[Container,Plate,"id:eGakld01zzLx"],Model[Container,Plate,"id:P5ZnEj4P88qr"],
      Model[Container,Plate,"id:6V0npvK611zG"],Model[Container,Plate,"id:Vrbp1jG800zm"],Model[Container,Plate,"id:XnlV5jmbZZZN"],
      Model[Container,Plate,"id:3em6Zv9NjjjB"],Model[Container,Plate,"id:6V0npvK6111w"],Model[Container,Plate,"id:4pO6dMWvnnJ5"],
      Model[Container,Plate,"id:P5ZnEj4P88kW"],Model[Container,Plate,"id:6V0npvK611rw"],Model[Container,Plate,"id:Vrbp1jG800Vb"],
      Model[Container,Plate,"id:GmzlKjY5EE8e"],Model[Container,Plate,"id:bq9LA0dBGGYv"],Model[Container,Plate,"id:01G6nvkKrrZm"],
      Model[Container,Plate,"id:zGj91aR3ddeJ"],Model[Container,Plate,"id:bq9LA0dBGGlv"],Model[Container,Plate,"id:M8n3rxYE55OP"],
      Model[Container,Plate,"id:01G6nvkKrrYm"],Model[Container,Plate,"id:eGakld01zzxE"],Model[Container,Plate,"id:XnlV5jmbZZ3n"],
      Model[Container,Plate,"id:01G6nvkKrrY4"],Model[Container,Plate,"id:dORYzZn0oove"],Model[Container,Plate,"id:E8zoYveRlldX"],
      Model[Container,Plate,"id:wqW9BP4Y00G4"],Model[Container,Plate,"id:rea9jl1orrV5"],Model[Container,Plate,"id:jLq9jXY4kknW"],
      Model[Container,Plate,"id:6V0npvK611DZ"],Model[Container,Plate,"id:WNa4ZjRr55E7"],Model[Container,Plate,"id:Z1lqpMGjeePM"],
      Model[Container,Plate,"id:4pO6dMWvnnP7"],Model[Container,Plate,"id:jLq9jXY4kkKW"],Model[Container,Plate,"id:aXRlGnZmOOqv"],
      Model[Container,Plate,"id:L8kPEjNLDDLA"],Model[Container,Plate,"id:M8n3rxYE55E5"],Model[Container,Plate,"id:R8e1PjRDbbEK"],
      Model[Container,Plate,"id:WNa4ZjRr551q"],Model[Container,Plate,"id:kEJ9mqR3XELE"],Model[Container,Plate,"id:BYDOjvG1pRnE"],
      Model[Container,Plate,"id:O81aEBZ4EMXj"],Model[Container,Plate,"id:P5ZnEjddrmNW"],Model[Container,Plate,"id:4pO6dM55ar55"],
      Model[Container,Plate,"id:pZx9jo8x59oP"],Model[Container,Plate,"id:R8e1PjpBXOpX"],Model[Container,Plate,"id:54n6evLWKqbG"],
      Model[Container,Plate,"id:pZx9jo83G0VP"],Model[Container,Plate,"id:L8kPEjno5XoE"],Model[Container,Plate,"id:P5ZnEjdmXJmE"],
      Model[Container,Plate,"id:8qZ1VW06z9Zp"],Model[Container,Plate,"id:9RdZXv1laYVK"],Model[Container,Plate,"id:eGakldJ5M44n"],
      Model[Container,Plate,"id:Y0lXejML17rm"],Model[Container,Plate,"id:R8e1PjpVrbMv"],Model[Container,Plate,"id:L8kPEjn1Y9v6"],
      Model[Container,Plate,"id:7X104vnG34Pd"],Model[Container,Plate,"id:D8KAEvGmOEMm"],Model[Container,Plate,"id:aXRlGn6YwGN9"],
      Model[Container,Plate,"id:qdkmxzqrmP04"],Model[Container,Plate,"id:R8e1PjpV1zR4"],Model[Container,Plate,"id:wqW9BP7N0w7V"],
      Model[Container,Plate,"id:AEqRl9KmGPWa"],Model[Container,Plate,"id:Z1lqpMz8K5n0"],Model[Container,Plate,"id:XnlV5jKArpnn"],
      Model[Container,Plate,"id:KBL5Dvw0kGJJ"],Model[Container,Plate,"id:01G6nvwADjX1"],Model[Container,Plate,"id:GmzlKjP9KdJ9"],
      Model[Container,Plate,"id:rea9jlRLlqYr"],Model[Container,Plate,"id:54n6evLezbmN"],Model[Container,Plate,"id:eGakldJPJkzE"],
      Model[Container,Plate,"id:7X104vn56dLX"],Model[Container,Plate,"id:01G6nvwNDARA"],Model[Container,Plate,"id:L8kPEjnarBZW"],
      Model[Container,Plate,"id:jLq9jXvzR0XR"],Model[Container,Plate,"id:7X104vneWNvw"],Model[Container,Plate,"id:1ZA60vL978v8"],
      Model[Container,Plate,"id:Z1lqpMzn3JMV"],Model[Container,Plate,"id:dORYzZJqe6e5"],Model[Container,Plate,"id:eGakldJRp9po"],
      Model[Container,Plate,"id:M8n3rx0w7ZNR"],Model[Container,Plate,"id:Y0lXejMaRo0P"],Model[Container,Plate,"id:Z1lqpMz1EnVL"],
      Model[Container,Plate,"id:rea9jlR4L8eO"],Model[Container,Plate,"id:KBL5DvwJ0q4k"],Model[Container,Plate,"id:jLq9jXvN5Bpz"],
      Model[Container,Plate,"id:L8kPEjnY8dME"],Model[Container,Plate,"id:dORYzZJwOJb5"],Model[Container,Plate,"id:1ZA60vLlZzrM"],
      Model[Container,Plate,"id:Y0lXejMW7NMo"],Model[Container,Plate,"id:Vrbp1jKw7W9q"],Model[Container,Plate,"id:vXl9j57AR9lD"],
      Model[Container,Plate,"id:8qZ1VW0na15R"],Model[Container,Plate,"id:xRO9n3Brzr1Z"],Model[Container,Plate,"id:lYq9jRx9p4xA"],
      Model[Container,Plate,"id:pZx9jo89qRqM"],Model[Container,Plate,"id:D8KAEvG0vN8l"],Model[Container,Plate,"id:Y0lXejMPjv1P"],
      Model[Container,Plate,"id:aXRlGn615Kak"],Model[Container,Plate,"id:mnk9jORMlWlY"],Model[Container,Plate,"id:Z1lqpMzk6Vao"],
      Model[Container,Plate,"id:kEJ9mqRMNA98"],Model[Container,Plate,"id:3em6ZvLwoEK7"],Model[Container,Plate,"id:54n6evLlR8YL"],
      Model[Container,Plate,"id:J8AY5jD98R1Z"],Model[Container,Plate,"id:O81aEBZjRXvx"]
    }
  },


  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
    Module[{allObjects,existingObjects},
      ClearMemoization[];

      (*Gather all the objects and models created in SymbolSetUp*)
      allObjects=Cases[Flatten[{
        Object[Container, Bench, "ExperimentDNASequencingOptions test 96-well PCR plate 1"<>$SessionUUID],
        Object[Container,Plate,"ExperimentDNASequencingOptions test 96-well PCR plate 1"<>$SessionUUID],
        Model[Molecule,Oligomer,"ExperimentDNASequencingOptions test DNA molecule"<>$SessionUUID],
        Model[Sample,"ExperimentDNASequencingOptions test DNA sample"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencingOptions test sample 1"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencingOptions test primer sample 1"<>$SessionUUID]

      }],ObjectP[]];

      (*Check whether the names we want to give below already exist in the database*)
      existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

      (*Erase any test objects and models that we failed to erase in the last unit test*)
      Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
    ];


    Block[{$AllowSystemsProtocols=True},
      Module[{fakeBench, emptyTestContainers,testOligomer, testSampleModels,testSampleContainerObjects,
        containerSampleObjects,developerObjects,allObjects},

        (* set up fake bench as a location for the vessel *)
        fakeBench = Upload[<|
          Type -> Object[Container, Bench],
          Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
          Name -> "ExperimentDNASequencingOptions test 96-well PCR plate 1"<>$SessionUUID,
          DeveloperObject -> True,
          StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
        |>];

        (*Make some empty test container objects*)
        emptyTestContainers=UploadSample[
          {Model[Container,Plate,"id:Z1lqpMz1EnVL"]},
          {{"Work Surface", fakeBench}},
          Status -> {Available},
          Name -> {"ExperimentDNASequencingOptions test 96-well PCR plate 1"<>$SessionUUID}
        ];

        (*Make a test DNA identity model*)
        testOligomer=UploadOligomer["ExperimentDNASequencingOptions test DNA molecule"<>$SessionUUID,Molecule->Strand[RandomSequence[100]],PolymerType->DNA];

        (*Make some test sample models*)
        testSampleModels=UploadSampleModel[
          {
            "ExperimentDNASequencingOptions test DNA sample"<>$SessionUUID
          },
          Composition->
              {
                {{10 Micromolar,Model[Molecule,Oligomer,"ExperimentDNASequencingOptions test DNA molecule"<>$SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}}
              },
          IncompatibleMaterials->ConstantArray[{None},1],
          Expires->ConstantArray[True,1],
          ShelfLife->ConstantArray[2 Year,1],
          UnsealedShelfLife->ConstantArray[90 Day,1],
          DefaultStorageCondition->ConstantArray[Model[StorageCondition,"Ambient Storage"],1],
          MSDSRequired->ConstantArray[False,1],
          BiosafetyLevel->ConstantArray["BSL-1",1],
          State->ConstantArray[Liquid,1]
        ];

        (*Make some test sample objects in the test container objects*)
        testSampleContainerObjects=UploadSample[
          Join[
            ConstantArray[Model[Sample,"ExperimentDNASequencingOptions test DNA sample"<>$SessionUUID],2]
          ],
          {
            {"A1",Object[Container,Plate,"ExperimentDNASequencingOptions test 96-well PCR plate 1"<>$SessionUUID]},
            {"A2",Object[Container,Plate,"ExperimentDNASequencingOptions test 96-well PCR plate 1"<>$SessionUUID]}
          },
          Name->
              {
                "ExperimentDNASequencingOptions test sample 1"<>$SessionUUID,
                "ExperimentDNASequencingOptions test primer sample 1"<>$SessionUUID
              },
          InitialAmount->ConstantArray[0.5 Milliliter, 2]
        ];

        (*Gather all the created objects and models*)
        containerSampleObjects={emptyTestContainers,testOligomer,testSampleModels,testSampleContainerObjects};

        (*Make all the test objects and models except the instrument parts developer objects*)
        developerObjects=Upload[<|Object->#,DeveloperObject->True|>&/@Flatten[containerSampleObjects]];

        (*Gather all the test objects and models created in SymbolSetUp*)
        allObjects=Flatten[{fakeBench,developerObjects}];

      ]
    ]
  ),


  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Error::ContainerTooSmall];
    Module[{allObjects,existingObjects},


      (*Gather all the objects and models created in SymbolSetUp*)
      allObjects=Cases[Flatten[{
        Object[Container, Bench, "ExperimentDNASequencingOptions test 96-well PCR plate 1"<>$SessionUUID],
        Object[Container,Plate,"ExperimentDNASequencingOptions test 96-well PCR plate 1"<>$SessionUUID],
        Model[Molecule,Oligomer,"ExperimentDNASequencingOptions test DNA molecule"<>$SessionUUID],
        Model[Sample,"ExperimentDNASequencingOptions test DNA sample"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencingOptions test sample 1"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencingOptions test primer sample 1"<>$SessionUUID]

      }],ObjectP[]];

      (*Check whether the created objects and models exist in the database*)
      existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
    ];
  )
];

(* ::Subsection::Closed:: *)
(*ExperimentDNASequencingPreview*)

DefineTests[ExperimentDNASequencingPreview,
  {
    Example[{Basic,"No preview is currently available for ExperimentDNASequencing:"},
      ExperimentDNASequencingPreview[
        Object[Sample,"ExperimentDNASequencingPreview test sample 1"<>$SessionUUID]
      ],
      Null,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic,"No preview is currently available for ExperimentDNASequencing:"},
      ExperimentDNASequencingPreview[
        Object[Sample,"ExperimentDNASequencingPreview test sample 1"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencingPreview test primer sample 1"<>$SessionUUID]
      ],
      Null,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Additional, "If you wish to understand how the experiment will be performed, try using ExperimentDNASequencingOptions:"},
      ExperimentDNASequencingOptions[
        Object[Sample,"ExperimentDNASequencingPreview test sample 1"<>$SessionUUID]
      ],
      _Grid,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Additional, "The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentDNASequencingQ:"},
      ValidExperimentDNASequencingQ[
        Object[Sample,"ExperimentDNASequencingPreview test sample 1"<>$SessionUUID]
      ],
      True,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      )
    ]
  },
  
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $EmailEnabled=False,
    Search[Model[Container,Plate],__]={
      Model[Container,Plate,"id:Z1lqpMGjee35"],Model[Container,Plate,"id:L8kPEjkmLbvW"],Model[Container,Plate,"id:n0k9mGzRaaBn"],
      Model[Container,Plate,"id:Vrbp1jG800ME"],Model[Container,Plate,"id:E8zoYveRllM7"],Model[Container,Plate,"id:qdkmxzkKwn11"],
      Model[Container,Plate,"id:1ZA60vwjbbqa"],Model[Container,Plate,"id:Z1lqpMGjeekO"],Model[Container,Plate,"id:L8kPEjNLDDvN"],
      Model[Container,Plate,"id:7X104vK9ZZ7X"],Model[Container,Plate,"id:eGakld01zzLx"],Model[Container,Plate,"id:P5ZnEj4P88qr"],
      Model[Container,Plate,"id:6V0npvK611zG"],Model[Container,Plate,"id:Vrbp1jG800zm"],Model[Container,Plate,"id:XnlV5jmbZZZN"],
      Model[Container,Plate,"id:3em6Zv9NjjjB"],Model[Container,Plate,"id:6V0npvK6111w"],Model[Container,Plate,"id:4pO6dMWvnnJ5"],
      Model[Container,Plate,"id:P5ZnEj4P88kW"],Model[Container,Plate,"id:6V0npvK611rw"],Model[Container,Plate,"id:Vrbp1jG800Vb"],
      Model[Container,Plate,"id:GmzlKjY5EE8e"],Model[Container,Plate,"id:bq9LA0dBGGYv"],Model[Container,Plate,"id:01G6nvkKrrZm"],
      Model[Container,Plate,"id:zGj91aR3ddeJ"],Model[Container,Plate,"id:bq9LA0dBGGlv"],Model[Container,Plate,"id:M8n3rxYE55OP"],
      Model[Container,Plate,"id:01G6nvkKrrYm"],Model[Container,Plate,"id:eGakld01zzxE"],Model[Container,Plate,"id:XnlV5jmbZZ3n"],
      Model[Container,Plate,"id:01G6nvkKrrY4"],Model[Container,Plate,"id:dORYzZn0oove"],Model[Container,Plate,"id:E8zoYveRlldX"],
      Model[Container,Plate,"id:wqW9BP4Y00G4"],Model[Container,Plate,"id:rea9jl1orrV5"],Model[Container,Plate,"id:jLq9jXY4kknW"],
      Model[Container,Plate,"id:6V0npvK611DZ"],Model[Container,Plate,"id:WNa4ZjRr55E7"],Model[Container,Plate,"id:Z1lqpMGjeePM"],
      Model[Container,Plate,"id:4pO6dMWvnnP7"],Model[Container,Plate,"id:jLq9jXY4kkKW"],Model[Container,Plate,"id:aXRlGnZmOOqv"],
      Model[Container,Plate,"id:L8kPEjNLDDLA"],Model[Container,Plate,"id:M8n3rxYE55E5"],Model[Container,Plate,"id:R8e1PjRDbbEK"],
      Model[Container,Plate,"id:WNa4ZjRr551q"],Model[Container,Plate,"id:kEJ9mqR3XELE"],Model[Container,Plate,"id:BYDOjvG1pRnE"],
      Model[Container,Plate,"id:O81aEBZ4EMXj"],Model[Container,Plate,"id:P5ZnEjddrmNW"],Model[Container,Plate,"id:4pO6dM55ar55"],
      Model[Container,Plate,"id:pZx9jo8x59oP"],Model[Container,Plate,"id:R8e1PjpBXOpX"],Model[Container,Plate,"id:54n6evLWKqbG"],
      Model[Container,Plate,"id:pZx9jo83G0VP"],Model[Container,Plate,"id:L8kPEjno5XoE"],Model[Container,Plate,"id:P5ZnEjdmXJmE"],
      Model[Container,Plate,"id:8qZ1VW06z9Zp"],Model[Container,Plate,"id:9RdZXv1laYVK"],Model[Container,Plate,"id:eGakldJ5M44n"],
      Model[Container,Plate,"id:Y0lXejML17rm"],Model[Container,Plate,"id:R8e1PjpVrbMv"],Model[Container,Plate,"id:L8kPEjn1Y9v6"],
      Model[Container,Plate,"id:7X104vnG34Pd"],Model[Container,Plate,"id:D8KAEvGmOEMm"],Model[Container,Plate,"id:aXRlGn6YwGN9"],
      Model[Container,Plate,"id:qdkmxzqrmP04"],Model[Container,Plate,"id:R8e1PjpV1zR4"],Model[Container,Plate,"id:wqW9BP7N0w7V"],
      Model[Container,Plate,"id:AEqRl9KmGPWa"],Model[Container,Plate,"id:Z1lqpMz8K5n0"],Model[Container,Plate,"id:XnlV5jKArpnn"],
      Model[Container,Plate,"id:KBL5Dvw0kGJJ"],Model[Container,Plate,"id:01G6nvwADjX1"],Model[Container,Plate,"id:GmzlKjP9KdJ9"],
      Model[Container,Plate,"id:rea9jlRLlqYr"],Model[Container,Plate,"id:54n6evLezbmN"],Model[Container,Plate,"id:eGakldJPJkzE"],
      Model[Container,Plate,"id:7X104vn56dLX"],Model[Container,Plate,"id:01G6nvwNDARA"],Model[Container,Plate,"id:L8kPEjnarBZW"],
      Model[Container,Plate,"id:jLq9jXvzR0XR"],Model[Container,Plate,"id:7X104vneWNvw"],Model[Container,Plate,"id:1ZA60vL978v8"],
      Model[Container,Plate,"id:Z1lqpMzn3JMV"],Model[Container,Plate,"id:dORYzZJqe6e5"],Model[Container,Plate,"id:eGakldJRp9po"],
      Model[Container,Plate,"id:M8n3rx0w7ZNR"],Model[Container,Plate,"id:Y0lXejMaRo0P"],Model[Container,Plate,"id:Z1lqpMz1EnVL"],
      Model[Container,Plate,"id:rea9jlR4L8eO"],Model[Container,Plate,"id:KBL5DvwJ0q4k"],Model[Container,Plate,"id:jLq9jXvN5Bpz"],
      Model[Container,Plate,"id:L8kPEjnY8dME"],Model[Container,Plate,"id:dORYzZJwOJb5"],Model[Container,Plate,"id:1ZA60vLlZzrM"],
      Model[Container,Plate,"id:Y0lXejMW7NMo"],Model[Container,Plate,"id:Vrbp1jKw7W9q"],Model[Container,Plate,"id:vXl9j57AR9lD"],
      Model[Container,Plate,"id:8qZ1VW0na15R"],Model[Container,Plate,"id:xRO9n3Brzr1Z"],Model[Container,Plate,"id:lYq9jRx9p4xA"],
      Model[Container,Plate,"id:pZx9jo89qRqM"],Model[Container,Plate,"id:D8KAEvG0vN8l"],Model[Container,Plate,"id:Y0lXejMPjv1P"],
      Model[Container,Plate,"id:aXRlGn615Kak"],Model[Container,Plate,"id:mnk9jORMlWlY"],Model[Container,Plate,"id:Z1lqpMzk6Vao"],
      Model[Container,Plate,"id:kEJ9mqRMNA98"],Model[Container,Plate,"id:3em6ZvLwoEK7"],Model[Container,Plate,"id:54n6evLlR8YL"],
      Model[Container,Plate,"id:J8AY5jD98R1Z"],Model[Container,Plate,"id:O81aEBZjRXvx"]
    }
  },

  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
    Module[{allObjects,existingObjects},
      ClearMemoization[];

      (*Gather all the objects and models created in SymbolSetUp*)
      allObjects=Cases[Flatten[{
        Object[Container, Bench, "Fake bench for ExperimentDNASequencingPreview tests"<>$SessionUUID],
        Object[Container,Plate,"ExperimentDNASequencingPreview test 96-well PCR plate 1"<>$SessionUUID],
        Model[Molecule,Oligomer,"ExperimentDNASequencingPreview test DNA molecule"<>$SessionUUID],
        Model[Sample,"ExperimentDNASequencingPreview test DNA sample"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencingPreview test sample 1"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencingPreview test primer sample 1"<>$SessionUUID]

      }],ObjectP[]];

      (*Check whether the names we want to give below already exist in the database*)
      existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

      (*Erase any test objects and models that we failed to erase in the last unit test*)
      Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
    ];


    Block[{$AllowSystemsProtocols=True},
      Module[{fakeBench, emptyTestContainers,testOligomer, testSampleModels,testSampleContainerObjects,
        containerSampleObjects,developerObjects,allObjects},

        (* set up fake bench as a location for the vessel *)
        fakeBench = Upload[<|
          Type -> Object[Container, Bench],
          Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
          Name -> "Fake bench for ExperimentDNASequencingPreview tests"<>$SessionUUID,
          DeveloperObject -> True,
          StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
        |>];

        (*Make some empty test container objects*)
        emptyTestContainers=UploadSample[
          {Model[Container,Plate,"id:Z1lqpMz1EnVL"]},
          {{"Work Surface", fakeBench}},
          Status -> {Available},
          Name -> {"ExperimentDNASequencingPreview test 96-well PCR plate 1"<>$SessionUUID}
        ];

        (*Make a test DNA identity model*)
        testOligomer=UploadOligomer["ExperimentDNASequencingPreview test DNA molecule"<>$SessionUUID,Molecule->Strand[RandomSequence[100]],PolymerType->DNA];

        (*Make some test sample models*)
        testSampleModels=UploadSampleModel[
          {
            "ExperimentDNASequencingPreview test DNA sample"<>$SessionUUID
          },
          Composition->
              {
                {{10 Micromolar,Model[Molecule,Oligomer,"ExperimentDNASequencingPreview test DNA molecule"<>$SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}}
              },
          IncompatibleMaterials->ConstantArray[{None},1],
          Expires->ConstantArray[True,1],
          ShelfLife->ConstantArray[2 Year,1],
          UnsealedShelfLife->ConstantArray[90 Day,1],
          DefaultStorageCondition->ConstantArray[Model[StorageCondition,"Ambient Storage"],1],
          MSDSRequired->ConstantArray[False,1],
          BiosafetyLevel->ConstantArray["BSL-1",1],
          State->ConstantArray[Liquid,1]
        ];

        (*Make some test sample objects in the test container objects*)
        testSampleContainerObjects=UploadSample[
          Join[
            ConstantArray[Model[Sample,"ExperimentDNASequencingPreview test DNA sample"<>$SessionUUID],2]
          ],
          {
            {"A1",Object[Container,Plate,"ExperimentDNASequencingPreview test 96-well PCR plate 1"<>$SessionUUID]},
            {"A2",Object[Container,Plate,"ExperimentDNASequencingPreview test 96-well PCR plate 1"<>$SessionUUID]}
          },
          Name->
              {
                "ExperimentDNASequencingPreview test sample 1"<>$SessionUUID,
                "ExperimentDNASequencingPreview test primer sample 1"<>$SessionUUID
              },
          InitialAmount->ConstantArray[0.5 Milliliter, 2]
        ];

        (*Gather all the created objects and models*)
        containerSampleObjects={emptyTestContainers,testOligomer,testSampleModels,testSampleContainerObjects};

        (*Make all the test objects and models except the instrument parts developer objects*)
        developerObjects=Upload[<|Object->#,DeveloperObject->True|>&/@Flatten[containerSampleObjects]];

        (*Gather all the test objects and models created in SymbolSetUp*)
        allObjects=Flatten[{fakeBench,developerObjects}];

      ]
    ]
  ),


  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    Module[{allObjects,existingObjects},

      (*Gather all the objects and models created in SymbolSetUp*)
      allObjects=Cases[Flatten[{
        Object[Container, Bench, "Fake bench for ExperimentDNASequencingPreview tests"<>$SessionUUID],
        Object[Container,Plate,"ExperimentDNASequencingPreview test 96-well PCR plate 1"<>$SessionUUID],
        Model[Molecule,Oligomer,"ExperimentDNASequencingPreview test DNA molecule"<>$SessionUUID],
        Model[Sample,"ExperimentDNASequencingPreview test DNA sample"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencingPreview test sample 1"<>$SessionUUID],
        Object[Sample,"ExperimentDNASequencingPreview test primer sample 1"<>$SessionUUID]

      }],ObjectP[]];

      (*Check whether the created objects and models exist in the database*)
      existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
    ];
  )
];


(* ::Subsection::Closed:: *)
(*ValidExperimentDNASequencingQ*)


DefineTests[ValidExperimentDNASequencingQ,
  {
    Example[{Basic,"Returns a Boolean indicating the validity of a DNASequencing experimental setup on a sample:"},
      ValidExperimentDNASequencingQ[
        Object[Sample,"ValidExperimentDNASequencingQ test sample 1"<>$SessionUUID]
      ],
      True,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic,"Returns a Boolean indicating the validity of a DNASequencing experimental setup on a sample and a primer:"},
      ValidExperimentDNASequencingQ[
        Object[Sample,"ValidExperimentDNASequencingQ test sample 1"<>$SessionUUID],
        Object[Sample,"ValidExperimentDNASequencingQ test primer sample 1"<>$SessionUUID]
      ],
      True,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic, "Return False if there are problems with the inputs or options:"},
      ValidExperimentDNASequencingQ[
        Object[Sample,"ValidExperimentDNASequencingQ test sample 1"<>$SessionUUID],
        PreparedPlate -> False
      ],
      False,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options,Verbose,"If Verbose -> True, returns the passing and failing tests:"},
      ValidExperimentDNASequencingQ[
        Object[Sample,"ValidExperimentDNASequencingQ test sample 1"<>$SessionUUID],
        Verbose->True
      ],
      True,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options,OutputFormat,"If OutputFormat -> TestSummary, returns a test summary instead of a Boolean:"},
      ValidExperimentDNASequencingQ[
        Object[Sample,"ValidExperimentDNASequencingQ test sample 1"<>$SessionUUID],
        OutputFormat->TestSummary
      ],
      _EmeraldTestSummary,
      SetUp:>($CreatedObjects={}),
      TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        Unset[$CreatedObjects]
      )
    ]
  },
  
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $EmailEnabled=False,
    Search[Model[Container,Plate],__]={
      Model[Container,Plate,"id:Z1lqpMGjee35"],Model[Container,Plate,"id:L8kPEjkmLbvW"],Model[Container,Plate,"id:n0k9mGzRaaBn"],
      Model[Container,Plate,"id:Vrbp1jG800ME"],Model[Container,Plate,"id:E8zoYveRllM7"],Model[Container,Plate,"id:qdkmxzkKwn11"],
      Model[Container,Plate,"id:1ZA60vwjbbqa"],Model[Container,Plate,"id:Z1lqpMGjeekO"],Model[Container,Plate,"id:L8kPEjNLDDvN"],
      Model[Container,Plate,"id:7X104vK9ZZ7X"],Model[Container,Plate,"id:eGakld01zzLx"],Model[Container,Plate,"id:P5ZnEj4P88qr"],
      Model[Container,Plate,"id:6V0npvK611zG"],Model[Container,Plate,"id:Vrbp1jG800zm"],Model[Container,Plate,"id:XnlV5jmbZZZN"],
      Model[Container,Plate,"id:3em6Zv9NjjjB"],Model[Container,Plate,"id:6V0npvK6111w"],Model[Container,Plate,"id:4pO6dMWvnnJ5"],
      Model[Container,Plate,"id:P5ZnEj4P88kW"],Model[Container,Plate,"id:6V0npvK611rw"],Model[Container,Plate,"id:Vrbp1jG800Vb"],
      Model[Container,Plate,"id:GmzlKjY5EE8e"],Model[Container,Plate,"id:bq9LA0dBGGYv"],Model[Container,Plate,"id:01G6nvkKrrZm"],
      Model[Container,Plate,"id:zGj91aR3ddeJ"],Model[Container,Plate,"id:bq9LA0dBGGlv"],Model[Container,Plate,"id:M8n3rxYE55OP"],
      Model[Container,Plate,"id:01G6nvkKrrYm"],Model[Container,Plate,"id:eGakld01zzxE"],Model[Container,Plate,"id:XnlV5jmbZZ3n"],
      Model[Container,Plate,"id:01G6nvkKrrY4"],Model[Container,Plate,"id:dORYzZn0oove"],Model[Container,Plate,"id:E8zoYveRlldX"],
      Model[Container,Plate,"id:wqW9BP4Y00G4"],Model[Container,Plate,"id:rea9jl1orrV5"],Model[Container,Plate,"id:jLq9jXY4kknW"],
      Model[Container,Plate,"id:6V0npvK611DZ"],Model[Container,Plate,"id:WNa4ZjRr55E7"],Model[Container,Plate,"id:Z1lqpMGjeePM"],
      Model[Container,Plate,"id:4pO6dMWvnnP7"],Model[Container,Plate,"id:jLq9jXY4kkKW"],Model[Container,Plate,"id:aXRlGnZmOOqv"],
      Model[Container,Plate,"id:L8kPEjNLDDLA"],Model[Container,Plate,"id:M8n3rxYE55E5"],Model[Container,Plate,"id:R8e1PjRDbbEK"],
      Model[Container,Plate,"id:WNa4ZjRr551q"],Model[Container,Plate,"id:kEJ9mqR3XELE"],Model[Container,Plate,"id:BYDOjvG1pRnE"],
      Model[Container,Plate,"id:O81aEBZ4EMXj"],Model[Container,Plate,"id:P5ZnEjddrmNW"],Model[Container,Plate,"id:4pO6dM55ar55"],
      Model[Container,Plate,"id:pZx9jo8x59oP"],Model[Container,Plate,"id:R8e1PjpBXOpX"],Model[Container,Plate,"id:54n6evLWKqbG"],
      Model[Container,Plate,"id:pZx9jo83G0VP"],Model[Container,Plate,"id:L8kPEjno5XoE"],Model[Container,Plate,"id:P5ZnEjdmXJmE"],
      Model[Container,Plate,"id:8qZ1VW06z9Zp"],Model[Container,Plate,"id:9RdZXv1laYVK"],Model[Container,Plate,"id:eGakldJ5M44n"],
      Model[Container,Plate,"id:Y0lXejML17rm"],Model[Container,Plate,"id:R8e1PjpVrbMv"],Model[Container,Plate,"id:L8kPEjn1Y9v6"],
      Model[Container,Plate,"id:7X104vnG34Pd"],Model[Container,Plate,"id:D8KAEvGmOEMm"],Model[Container,Plate,"id:aXRlGn6YwGN9"],
      Model[Container,Plate,"id:qdkmxzqrmP04"],Model[Container,Plate,"id:R8e1PjpV1zR4"],Model[Container,Plate,"id:wqW9BP7N0w7V"],
      Model[Container,Plate,"id:AEqRl9KmGPWa"],Model[Container,Plate,"id:Z1lqpMz8K5n0"],Model[Container,Plate,"id:XnlV5jKArpnn"],
      Model[Container,Plate,"id:KBL5Dvw0kGJJ"],Model[Container,Plate,"id:01G6nvwADjX1"],Model[Container,Plate,"id:GmzlKjP9KdJ9"],
      Model[Container,Plate,"id:rea9jlRLlqYr"],Model[Container,Plate,"id:54n6evLezbmN"],Model[Container,Plate,"id:eGakldJPJkzE"],
      Model[Container,Plate,"id:7X104vn56dLX"],Model[Container,Plate,"id:01G6nvwNDARA"],Model[Container,Plate,"id:L8kPEjnarBZW"],
      Model[Container,Plate,"id:jLq9jXvzR0XR"],Model[Container,Plate,"id:7X104vneWNvw"],Model[Container,Plate,"id:1ZA60vL978v8"],
      Model[Container,Plate,"id:Z1lqpMzn3JMV"],Model[Container,Plate,"id:dORYzZJqe6e5"],Model[Container,Plate,"id:eGakldJRp9po"],
      Model[Container,Plate,"id:M8n3rx0w7ZNR"],Model[Container,Plate,"id:Y0lXejMaRo0P"],Model[Container,Plate,"id:Z1lqpMz1EnVL"],
      Model[Container,Plate,"id:rea9jlR4L8eO"],Model[Container,Plate,"id:KBL5DvwJ0q4k"],Model[Container,Plate,"id:jLq9jXvN5Bpz"],
      Model[Container,Plate,"id:L8kPEjnY8dME"],Model[Container,Plate,"id:dORYzZJwOJb5"],Model[Container,Plate,"id:1ZA60vLlZzrM"],
      Model[Container,Plate,"id:Y0lXejMW7NMo"],Model[Container,Plate,"id:Vrbp1jKw7W9q"],Model[Container,Plate,"id:vXl9j57AR9lD"],
      Model[Container,Plate,"id:8qZ1VW0na15R"],Model[Container,Plate,"id:xRO9n3Brzr1Z"],Model[Container,Plate,"id:lYq9jRx9p4xA"],
      Model[Container,Plate,"id:pZx9jo89qRqM"],Model[Container,Plate,"id:D8KAEvG0vN8l"],Model[Container,Plate,"id:Y0lXejMPjv1P"],
      Model[Container,Plate,"id:aXRlGn615Kak"],Model[Container,Plate,"id:mnk9jORMlWlY"],Model[Container,Plate,"id:Z1lqpMzk6Vao"],
      Model[Container,Plate,"id:kEJ9mqRMNA98"],Model[Container,Plate,"id:3em6ZvLwoEK7"],Model[Container,Plate,"id:54n6evLlR8YL"],
      Model[Container,Plate,"id:J8AY5jD98R1Z"],Model[Container,Plate,"id:O81aEBZjRXvx"]
    }
  },


  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
    Module[{allObjects,existingObjects},
      ClearMemoization[];

      (*Gather all the objects and models created in SymbolSetUp*)
      allObjects=Cases[Flatten[{
        Object[Container, Bench, "Fake bench for ValidExperimentDNASequencingQ tests"<>$SessionUUID],
        Object[Container,Plate,"ValidExperimentDNASequencingQ test 96-well PCR plate 1"<>$SessionUUID],
        Model[Molecule,Oligomer,"ValidExperimentDNASequencingQ test DNA molecule"<>$SessionUUID],
        Model[Sample,"ValidExperimentDNASequencingQ test DNA sample"<>$SessionUUID],
        Object[Sample,"ValidExperimentDNASequencingQ test sample 1"<>$SessionUUID],
        Object[Sample,"ValidExperimentDNASequencingQ test primer sample 1"<>$SessionUUID]

      }],ObjectP[]];

      (*Check whether the names we want to give below already exist in the database*)
      existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

      (*Erase any test objects and models that we failed to erase in the last unit test*)
      Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
    ];


    Block[{$AllowSystemsProtocols=True},
      Module[{fakeBench, emptyTestContainers,testOligomer, testSampleModels,testSampleContainerObjects,
        containerSampleObjects,developerObjects,allObjects},

        (* set up fake bench as a location for the vessel *)
        fakeBench = Upload[<|
          Type -> Object[Container, Bench],
          Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
          Name -> "Fake bench for ValidExperimentDNASequencingQ tests"<>$SessionUUID,
          DeveloperObject -> True,
          StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
        |>];

        (*Make some empty test container objects*)
        emptyTestContainers=UploadSample[
          {Model[Container,Plate,"id:Z1lqpMz1EnVL"]},
          {{"Work Surface", fakeBench}},
          Status -> {Available},
          Name -> {"ValidExperimentDNASequencingQ test 96-well PCR plate 1"<>$SessionUUID}
        ];

        (*Make a test DNA identity model*)
        testOligomer=UploadOligomer["ValidExperimentDNASequencingQ test DNA molecule"<>$SessionUUID,Molecule->Strand[RandomSequence[100]],PolymerType->DNA];

        (*Make some test sample models*)
        testSampleModels=UploadSampleModel[
          {
            "ValidExperimentDNASequencingQ test DNA sample"<>$SessionUUID
          },
          Composition->
              {
                {{10 Micromolar,Model[Molecule,Oligomer,"ValidExperimentDNASequencingQ test DNA molecule"<>$SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}}
              },
          IncompatibleMaterials->ConstantArray[{None},1],
          Expires->ConstantArray[True,1],
          ShelfLife->ConstantArray[2 Year,1],
          UnsealedShelfLife->ConstantArray[90 Day,1],
          DefaultStorageCondition->ConstantArray[Model[StorageCondition,"Ambient Storage"],1],
          MSDSRequired->ConstantArray[False,1],
          BiosafetyLevel->ConstantArray["BSL-1",1],
          State->ConstantArray[Liquid,1]
        ];

        (*Make some test sample objects in the test container objects*)
        testSampleContainerObjects=UploadSample[
          Join[
            ConstantArray[Model[Sample,"ValidExperimentDNASequencingQ test DNA sample"<>$SessionUUID],2]
          ],
          {
            {"A1",Object[Container,Plate,"ValidExperimentDNASequencingQ test 96-well PCR plate 1"<>$SessionUUID]},
            {"A2",Object[Container,Plate,"ValidExperimentDNASequencingQ test 96-well PCR plate 1"<>$SessionUUID]}
          },
          Name->
              {
                "ValidExperimentDNASequencingQ test sample 1"<>$SessionUUID,
                "ValidExperimentDNASequencingQ test primer sample 1"<>$SessionUUID
              },
          InitialAmount->ConstantArray[0.5 Milliliter, 2]
        ];

        (*Gather all the created objects and models*)
        containerSampleObjects={emptyTestContainers,testOligomer,testSampleModels,testSampleContainerObjects};

        (*Make all the test objects and models except the instrument parts developer objects*)
        developerObjects=Upload[<|Object->#,DeveloperObject->True|>&/@Flatten[containerSampleObjects]];

        (*Gather all the test objects and models created in SymbolSetUp*)
        allObjects=Flatten[{fakeBench,developerObjects}];

      ]
    ]
  ),


  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    Module[{allObjects,existingObjects},

      (*Gather all the objects and models created in SymbolSetUp*)
      allObjects=Cases[Flatten[{
        Object[Container, Bench, "Fake bench for ValidExperimentDNASequencingQ tests"<>$SessionUUID],
        Object[Container,Plate,"ValidExperimentDNASequencingQ test 96-well PCR plate 1"<>$SessionUUID],
        Model[Molecule,Oligomer,"ValidExperimentDNASequencingQ test DNA molecule"<>$SessionUUID],
        Model[Sample,"ValidExperimentDNASequencingQ test DNA sample"<>$SessionUUID],
        Object[Sample,"ValidExperimentDNASequencingQ test sample 1"<>$SessionUUID],
        Object[Sample,"ValidExperimentDNASequencingQ test primer sample 1"<>$SessionUUID]

      }],ObjectP[]];

      (*Check whether the created objects and models exist in the database*)
      existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
    ];
  )
];
