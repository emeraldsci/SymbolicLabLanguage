(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: tharr *)
(* :Date: 2023-05-15 *)


DefineTests[SimulateDigest, {
  (* ---------------- basic tests --------------------- *)
  Example[{Basic, "Simulating the digest of a sample object with Trypsin returns a state with digested components and concentrations:"},
    SimulateDigest[Object[Sample, "Test sample 1 " <> digestTestingUUID], Trypsin],
    StateP
  ],
  Example[{Basic, "Simulating the digest of a list of sample objects returns a list of states with digested components and concentrations:"},
    SimulateDigest[{Object[Sample, "Test sample 1 " <> digestTestingUUID], Object[Sample, "Test sample 2 " <> digestTestingUUID]}, LysC],
    {StateP..}
  ],
  Example[{Basic, "Simulating the digest of a State returns a state with digested components and concentrations:"},
    Module[
      {state},
      state = State[{Strand[Peptide["MetHisLysTrpAlaAla"]], 10 Millimolar}, {Strand[Peptide["GlyHisGlu"]], 20 Millimolar}];
      SimulateDigest[state, Chymotrypsin]
    ],
    State[{Strand[Peptide["MetHisLysTrp"]], 10 Millimolar}, {Strand[Peptide["AlaAla"]], 10 Millimolar}, {Strand[Peptide["GlyHisGlu"]], 20 Millimolar}]
  ],
  Example[{Basic, "Simulating the digest of a Strand returns a list of digested strands:"},
    Module[
      {strand},
      strand = Strand[Peptide["MetHisLysArgGlyGly"]];
      SimulateDigest[strand, GlutamylEndopeptidase]
    ],
    {StrandP..}
  ],
  Example[{Additional, "Inputting lists of samples and proteases in equal length simulates the digests of each sample for the corresponding protease:"},
    SimulateDigest[{Object[Sample, "Test sample 1 " <> digestTestingUUID], Object[Sample, "Test sample 3 " <> digestTestingUUID]}, {AlphaLyticProtease, Iodobenzoate}],
    {StateP..}
  ],
  Example[{Additional, "Simulating the digest of a Structure returns a list of digested strands:"},
    Module[
      {structure},
      structure = Structure[
        {Strand[Peptide["MetHisLysArgGlyGly"]], Strand[Peptide["MetHisLysArgGlyGly"]]},
        {Bond[{1, 1, 1 ;; 2}, {2, 1, 2 ;; 3}]}
      ];
      SimulateDigest[structure, StaphylococcalProtease]
    ],
    {StrandP..}
  ],
  Example[{Additional, "Simulating the digest of an identity model yields a list of digested strands:"},
    SimulateDigest[Model[Molecule, Protein, "Insulin (Bovine)"], Iodosobenzoate],
    {StrandP..}
  ],
  Example[{Additional, "Simulating the digest of an identity model of a peptide oligomer yields a list of digested strands:"},
    SimulateDigest[Model[Molecule, Oligomer, "GLHRH-Peptide"], ProlineEndopeptidase],
    {StrandP..}
  ],
  Example[{Additional, "Simulating the digest of a State with non-peptides returns a state with digested peptides and leaves the non-peptide components untouched:"},
    Module[
      {state},
      state = State[{Strand[Peptide["MetHisLysGlyHisGlu"]], 10 Millimolar}, {Strand[DNA["AGCTAAA"]], 20 Millimolar}];
      SimulateDigest[state, Chymotrypsin]
    ],
    (* ChymoTrypsin shouldn't digest this thing *)
    State[{Strand[Peptide["MetHisLysGlyHisGlu"]], 10 Millimolar}, {Strand[DNA["AGCTAAA"]], 20 Millimolar}]
  ],

  (* ---------- message tests ------------------- *)
  Example[{Messages, "UnequalLengthInputs", "Inputting a list of states with a different sized list of proteases results in an error:"},
    Module[
      {state1, state2},
      state1 = State[{Strand[Peptide["MetHisLys"]], 10 Millimolar}, {Strand[Peptide["GlyHisGlu"]], 20 Millimolar}];
      state2 = State[{Strand[Peptide["MetHisLysTyrTrp"]], 10 Millimolar}, {Strand[Peptide["HisGlyHisGlu"]], 20 Millimolar}];
      SimulateDigest[{state1, state2}, {Chymotrypsin, Trypsin, LysC}]
    ],
    $Failed,
    Messages :> {SimulateDigest::UnequalLengthInputs}
  ],
  Example[{Messages, "NoPeptides", "Inputting a list of states with no peptides results in an error as the digest can't be completed:"},
    Module[
      {state},
      state = State[{"a", 10 Millimolar}, {"b", 20 Millimolar}];
      SimulateDigest[state, Chymotrypsin]
    ],
    $Failed,
    Messages :> {SimulateDigest::NoPeptides}
  ],
  Example[{Messages, "FatalError", "An error is surfaced if something unexpected occurs during the processing of the data or simulation:"},
    Module[
      {state},
      state = State[{Strand[Peptide["MetHisLys"]], 10 Millimolar}, {Strand[Peptide["GlyHisGlu"]], 20 Millimolar}];
      SimulateDigest[state, Chymotrypsin]
    ],
    $Failed,
    Messages :> {SimulateDigest::FatalError},
    Stubs :> {
      HTTPRequestJSON[___] := HTTPError["blah"]
    }
  ],
  Example[{Messages, "NullConcentrationsFound", "Using a sample object with Null concentrations for any protein/peptide in the Composition field results in a warning:"},
    SimulateDigest[Object[Sample, "Test sample with Null concentration " <> digestTestingUUID], Trypsin],
    StateP,
    Messages :> {Warning::NullConcentrationsFound}
  ],
  Example[{Messages, "InvalidInput","Using a sample object with a peptide/protein in the Composition field that does not have the Molecule field populated results in an error:"},
    SimulateDigest[Object[Sample, "Test sample with protein with no molecule " <> digestTestingUUID], Trypsin],
    $Failed,
    Messages :> {SimulateDigest::InvalidInput}
  ],
  Example[{Messages, "NoProteins", "Using a sample with no proteins in the Composition field results in an error:"},
    SimulateDigest[Object[Sample, "Test sample with no proteins or peptides " <> digestTestingUUID], Trypsin],
    $Failed,
    Messages :> {SimulateDigest::NoProteins}
  ],
  Example[{Messages, "InvalidIdentityModels", "Using an identity model with no proteins/peptides in the Molecule field results in an error:"},
    SimulateDigest[Model[Molecule, Oligomer, "AAAAAGGGGGGGGGG"], Trypsin],
    $Failed,
    Messages :> {SimulateDigest::InvalidIdentityModels}
  ],
  (* ---------------- tests --------------------------- *)
  Test["Test digesting a modified peptide strand:",
    Module[
      {strand},
      strand = Strand[Modification["Pyroglutamic acid"], Peptide["MetHisLysGluArgGlyGly"], DNA["AGCT"]];
      SimulateDigest[strand, GlutamylEndopeptidase]
    ],
    {Strand[Modification["Pyroglutamic acid"], Peptide["MetHisLysGlu"]], Strand[Peptide["ArgGlyGly"], DNA["AGCT"]]}
  ],
  Test["Test digesting a modified non-peptide strand doesn't change the strand:",
    Module[
      {strand},
      strand = Strand[Modification["Pyroglutamic acid"], DNA["AGCT"]];
      SimulateDigest[strand, GlutamylEndopeptidase]
    ],
    $Failed,
    Messages :> {SimulateDigest::NoPeptides}
  ],
  Test["Testing the digest of a state containing modified peptides works as expected:",
    Module[
      {state},
      state = State[{Strand[Modification["Pyroglutamic acid"], Peptide["MetHisLysTrpAlaAla"], Modification["Amidated"]], 10 Millimolar}, {Strand[Peptide["GlyHisGlu"]], 20 Millimolar}];
      SimulateDigest[state, Chymotrypsin]
    ],
    State[{Strand[Modification["Pyroglutamic acid"], Peptide["MetHisLysTrp"]], 10 Millimolar}, {Strand[Peptide["AlaAla"], Modification["Amidated"]], 10 Millimolar}, {Strand[Peptide["GlyHisGlu"]], 20 Millimolar}]
  ],
  Test["Testing the digest of a state containing no peptides fails out appropriately:",
    Module[
      {state},
      state = State[{Strand[Modification["Pyroglutamic acid"], DNA["AGCT"], Modification["Amidated"]], 10 Millimolar}, {Strand[RNA["AUUU"]], 20 Millimolar}];
      SimulateDigest[state, Chymotrypsin]
    ],
    $Failed,
    Messages :> {SimulateDigest::NoPeptides}
  ],
  Test["Test that a sample with mass concentrations works fine:",
    SimulateDigest[Object[Sample, "Test sample with mass concentrations " <> digestTestingUUID], ProlineEndopeptidase],
    StateP
  ],
  Test["Test that 2 samples and 1 protease get index matched correctly:",
    SimulateDigest[{Object[Sample, "Test sample with mass concentrations " <> digestTestingUUID], Object[Sample, "Test sample 1 " <> digestTestingUUID]}, PepsinA],
    {StateP, StateP}
  ],
  Test["Test that 2 states and 1 protease get index matched correctly:",
    Module[
      {state},
      state = State[{Strand[Peptide["MetHisLys"]], 10 Millimolar}, {Strand[Peptide["GlyHisGlu"]], 20 Millimolar}];
      SimulateDigest[{state, state}, CyanogenBromide]
    ],
    {StateP, StateP}
  ],
  Test["Test that 2 strands and 1 protease get index matched correctly:",
    Module[
      {strand},
      strand = Strand[Peptide["MetHisLysArgGlyGly"]];
      SimulateDigest[{strand, strand}, Clostripain]
    ],
    {{StrandP..}, {StrandP..}}
  ],
  Test["Test that 2 structures and 1 protease get index matched correctly:",
    Module[
      {structure},
      structure = Structure[
        {Strand[Peptide["MetHisLysArgGlyGly"]], Strand[Peptide["MetHisLysArgGlyGly"]]},
        {Bond[{1, 1, 1 ;; 2}, {2, 1, 2 ;; 3}]}
      ];
      SimulateDigest[{structure, structure}, ElastaseTrypinChymoTrypsin]
    ],
    {{StrandP..}, {StrandP..}}
  ],
  Test["Test that 2 identity models and 1 protease get index matched correctly:",
    SimulateDigest[{Model[Molecule, Protein, "Insulin (Bovine)"], Model[Molecule, Protein, "Insulin (Bovine)"]}, FormicAcid],
    {{StrandP..}, {StrandP..}}
  ],
  Test["Test that LysN works:",
    Module[
      {state},
      state = State[{Strand[Peptide["MetHisLys"]], 10 Millimolar}, {Strand[Peptide["GlyHisGlu"]], 20 Millimolar}];
      SimulateDigest[state, LysN]
    ],
    StateP
  ],
  Test["Test that AspN works:",
    Module[
      {state},
      state = State[{Strand[Peptide["MetHisLys"]], 10 Millimolar}, {Strand[Peptide["GlyHisGlu"]], 20 Millimolar}];
      SimulateDigest[state, AspN]
    ],
    StateP
  ],
  Test["Test that ArgC works:",
    Module[
      {state},
      state = State[{Strand[Peptide["MetHisLys"]], 10 Millimolar}, {Strand[Peptide["GlyHisGlu"]], 20 Millimolar}];
      SimulateDigest[state, ArgC]
    ],
    StateP
  ]
},
  Variables :> {digestTestingUUID},
  SymbolSetUp :> (
    Module[
      {testSamplePacket1, testSamplePacket2, testSamplePacket3, testSamplePacket4, testSamplePacket5, testSamplePacket6, testSamplePacket7},
      digestTestingUUID = CreateUUID[];
      testSamplePacket1 = <|
        Type -> Object[Sample],
        Name -> "Test sample 1 " <> digestTestingUUID,
        Replace[Composition] -> {
          {10 Millimolar, Link[Model[Molecule, Protein, "Insulin (Bovine)"]]},
          {100 VolumePercent, Link[Model[Molecule, "Water"]]}
        }
      |>;
      testSamplePacket2 = <|
        Type -> Object[Sample],
        Name -> "Test sample 2 " <> digestTestingUUID,
        Replace[Composition] -> {
          {10 Millimolar, Link[Model[Molecule, Protein, "Ubiquitin"]]},
          {10 Micromolar, Link[Model[Molecule, "EDTA"]]},
          {100 VolumePercent, Link[Model[Molecule, "Water"]]}
        }
      |>;
      testSamplePacket3 = <|
        Type -> Object[Sample],
        Name -> "Test sample 3 " <> digestTestingUUID,
        Replace[Composition] -> {
          {10 Millimolar, Link[Model[Molecule, Protein, "Insulin (Bovine)"]]},
          {20 Millimolar, Link[Model[Molecule, Protein, "Ubiquitin"]]},
          {100 VolumePercent, Link[Model[Molecule, "Water"]]}
        }
      |>;
      testSamplePacket4 = <|
        Type -> Object[Sample],
        Name -> "Test sample with mass concentrations " <> digestTestingUUID,
        Replace[Composition] -> {
          {10 Milligram / Milliliter, Link[Model[Molecule, Protein, "Ubiquitin"]]},
          {10 Micromolar, Link[Model[Molecule, "EDTA"]]},
          {100 VolumePercent, Link[Model[Molecule, "Water"]]}
        }
      |>;
      testSamplePacket5 = <|
        Type -> Object[Sample],
        Name -> "Test sample with Null concentration " <> digestTestingUUID,
        Replace[Composition] -> {
          {Null, Link[Model[Molecule, Protein, "Insulin (Bovine)"]]},
          {100 VolumePercent, Link[Model[Molecule, "Water"]]}
        }
      |>;
      testSamplePacket6 = <|
        Type -> Object[Sample],
        Name -> "Test sample with protein with no molecule " <> digestTestingUUID,
        Replace[Composition] -> {
          {Null, Link[Model[Molecule, Protein, "Bovine Albumin"]]},
          {100 VolumePercent, Link[Model[Molecule, "Water"]]}
        }
      |>;
      testSamplePacket7 = <|
        Type -> Object[Sample],
        Name -> "Test sample with no proteins or peptides " <> digestTestingUUID,
        Replace[Composition] -> {
          {100 VolumePercent, Link[Model[Molecule, "Water"]]}
        }
      |>;

      (* upload the test packets *)
      Upload[{testSamplePacket1, testSamplePacket2, testSamplePacket3, testSamplePacket4, testSamplePacket5, testSamplePacket6, testSamplePacket7}];
    ]
  )
];


DefineTests[SimulateDigestOptions,{
  Example[{Basic, "Get the options for a digest simulation of a state"},
   Module[
      {state},
      state = State[{Strand[Peptide["MetHisLys"]], 10 Millimolar}, {Strand[Peptide["GlyHisGlu"]], 20 Millimolar}];
      SimulateDigestOptions[state, Chymotrypsin]
    ],
    {Output -> Options}
  ],
  Example[{Basic, "Get the options for a digest simulation of a strand"},
    Module[
      {strand},
      strand = Strand[Peptide["MetHisLys"]];
      SimulateDigestOptions[strand, Chymotrypsin]
    ],
    {Output -> Options}
  ],
  Example[{Basic, "Get the options for a digest simulation of a sample object"},
    SimulateDigestOptions[Object[Sample, "Test sample 1 " <> digestOptionsUUID], Chymotrypsin],
    {Output -> Options}
  ]
},
  Variables :> {digestOptionsUUID},
  SymbolSetUp :> (

    digestOptionsUUID = CreateUUID[];
    Upload[<|
      Type -> Object[Sample],
      Name -> "Test sample 1 " <> digestOptionsUUID,
      Replace[Composition] -> {
        {10 Millimolar, Link[Model[Molecule, Protein, "Insulin (Bovine)"]]},
        {100 VolumePercent, Link[Model[Molecule, "Water"]]}
      }
    |>];
  )
];


DefineTests[SimulateDigestPreview,{
  Example[{Basic, "Get the preview for a digest simulation of a state"},
    Module[
      {state},
      state = State[{Strand[Peptide["MetHisLys"]], 10 Millimolar}, {Strand[Peptide["GlyHisGlu"]], 20 Millimolar}];
      SimulateDigestPreview[state, Chymotrypsin]
    ],
    ValidGraphicsP[]
  ],
  Example[{Basic, "Get the preview for a digest simulation of a strand"},
    Module[
      {strand},
      strand = Strand[Peptide["MetHisLys"]];
      SimulateDigestPreview[strand, Chymotrypsin]
    ],
    _Image
  ],
  Example[{Basic, "Get the preview for a digest simulation of a sample object"},
    SimulateDigestPreview[Object[Sample, "Test sample 1 " <> digestPreviewUUID], Chymotrypsin],
    ValidGraphicsP[]
  ]
},
  Variables :> {digestPreviewUUID},
  SymbolSetUp :> (

    digestPreviewUUID = CreateUUID[];
    Upload[<|
      Type -> Object[Sample],
      Name -> "Test sample 1 " <> digestPreviewUUID,
      Replace[Composition] -> {
        {10 Millimolar, Link[Model[Molecule, Protein, "Insulin (Bovine)"]]},
        {100 VolumePercent, Link[Model[Molecule, "Water"]]}
      }
    |>];
  )
];


DefineTests[ValidSimulateDigestQ,{
  Example[{Basic, "Get the tests for a digest simulation of a state"},
    Module[
      {state},
      state = State[{Strand[Peptide["MetHisLys"]], 10 Millimolar}, {Strand[Peptide["GlyHisGlu"]], 20 Millimolar}];
      ValidSimulateDigestQ[state, Chymotrypsin]
    ],
    True
  ],
  Example[{Basic, "Get the tests for a digest simulation of a strand"},
    Module[
      {strand},
      strand = Strand[Peptide["MetHisLys"]];
      ValidSimulateDigestQ[strand, Chymotrypsin]
    ],
    True
  ],
  Example[{Basic, "Get the tests for a digest simulation of a sample object"},
    ValidSimulateDigestQ[Object[Sample, "Test sample 1 " <> digestValidQUUID], Chymotrypsin],
    True
  ]
},
  Variables :> {digestValidQUUID},
  SymbolSetUp :> (

    digestValidQUUID = CreateUUID[];
    Upload[<|
      Type -> Object[Sample],
      Name -> "Test sample 1 " <> digestValidQUUID,
      Replace[Composition] -> {
        {10 Millimolar, Link[Model[Molecule, Protein, "Insulin (Bovine)"]]},
        {100 VolumePercent, Link[Model[Molecule, "Water"]]}
      }
    |>];
  )
];
