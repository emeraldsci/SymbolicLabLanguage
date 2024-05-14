(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* Note that these tests must contact the web app, which must download the object, so test with real object samples. *)
DefineTestsWithCompanions[
  SimulatePeptideFragmentationSpectra,
  {
    (* --- Basic Tests --- *)
    Example[{Basic,"Run simulation for a single Object[Sample]:"},
      SimulatePeptideFragmentationSpectra[Object[Sample, "id:eGakldaZrXvz"]],
      ObjectP[Object[Simulation, FragmentationSpectra]],
      TimeConstraint->1000
    ],
    (* Stub these two specific tests for ValidQ function tests. *)
    Example[{Basic,"Run simulation for a single Strand:"},
      SimulatePeptideFragmentationSpectra[myStrand1],
      ObjectP[Object[Simulation, FragmentationSpectra]],
      Stubs :> {
        myStrand1 = Strand[Peptide["PheValAsnGlnHisLeuCysGlySerHisLeuValGluAlaLeuTyrLeuValCysGlyGluArgGlyPhePheTyrThrPro"]],
        myStrand2 = Strand[Peptide["PheValAsnGlnHisLeuCysGlySerHisLeuValGluAlaLeuTyrLeuValCysGlyGluArgGlyPhePheTyrThrProPhe"]]
      }
    ],
    Example[{Basic,"Run simulation for multiple Strands:"},
      SimulatePeptideFragmentationSpectra[{myStrand1, myStrand2}],
      {ObjectP[Object[Simulation, FragmentationSpectra]], ObjectP[Object[Simulation, FragmentationSpectra]]},
      Stubs :> {
        myStrand1 = Strand[Peptide["PheValAsnGlnHisLeuCysGlySerHisLeuValGluAlaLeuTyrLeuValCysGlyGluArgGlyPhePheTyrThrPro"]],
        myStrand2 = Strand[Peptide["PheValAsnGlnHisLeuCysGlySerHisLeuValGluAlaLeuTyrLeuValCysGlyGluArgGlyPhePheTyrThrProPhe"]]
      }
    ],
    Example[{Basic,"Run simulation for a single State:"},
      SimulatePeptideFragmentationSpectra[myState],
      ObjectP[Object[Simulation, FragmentationSpectra]]
    ],
    Example[{Basic,"Run simulation for multiple State:"},
      SimulatePeptideFragmentationSpectra[{myState, myState}],
      ConstantArray[ObjectP[Object[Simulation, FragmentationSpectra]], 2]
    ],

    (* --- Options Tests --- *)
    Example[{Options, Protease, "Set the Protease to Lys-C:"},
      SimulatePeptideFragmentationSpectra[myStrand1, Protease -> LysC],
      ObjectP[Object[Simulation, FragmentationSpectra]]
    ],
    Example[{Options, MaxIsotopes, "Include isotopes of the fragments:"},
      Length[Cases[SimulatePeptideFragmentationSpectra[myStrand1, MaxIsotopes -> 3,Upload -> False][[2, 1]][IonLabels], "y1++"]],
      3
    ],
    Example[{Options, IsotopeProbabilityCutoff, "Change the isotope probability cutoff, also set MaxIsotopes option."},
      (* pyopenMS generates 3 ions for both y1++ and b2++, but only 2 of the ions for y1++ are above the cutoff, whereas all 3 are for b2++. *)
      Map[
        Length[Cases[
        SimulatePeptideFragmentationSpectra[myStrand1,IsotopeProbabilityCutoff -> Quantity[1 Percent],MaxIsotopes -> 3, Upload -> False][[2, 1]][IonLabels], #]] &, {"y1++", "b2++"}
      ],
      {2,3}
    ],
    Example[{Options, MinCharge, "Set the min fragment charge:"},
      AllTrue[SimulatePeptideFragmentationSpectra[myStrand1, MinCharge -> 4, Upload -> False][[2,1]][IonLabels], StringContainsQ["++++"]],
      True
    ],
    Example[{Options, MaxCharge, "Set the max fragment charge:"},
      SimulatePeptideFragmentationSpectra[myStrand1, MaxCharge -> 4, Upload -> False][[2,1]][IonLabels],
      _?(ContainsAll[#, {"y1+", "y1++++"}]&)
    ],
    Example[{Options, IncludedIons, "Select ion types to be included:"},
      SimulatePeptideFragmentationSpectra[myStrand1, IncludedIons -> {YIon, BIon, AIon, CIon, XIon, ZIon}, Upload -> False][[2, 1]][IonLabels],
      _?(ContainsAll[#, {"y2+", "b2+", "a2+", "c2+","x2+", "z2+"}]&)
    ],
    Example[{Options, IncludePrecursors, "Include precursors in the fragmentation data:"},
      SimulatePeptideFragmentationSpectra[myStrand1, IncludePrecursors -> True, Upload -> False][[2, 1]][IonLabels],
      _?(ContainsAll[#, {"[M+H]-H2O++", "[M+H]-NH3++", "[M+H]++"}]&)
    ],
    Example[{Options, IncludeLosses, "Include losses in the fragmentation data:"},
      SimulatePeptideFragmentationSpectra[myStrand1, IncludeLosses -> True, Upload -> False][[2, 1]][Losses],
      _?(ContainsAll[#, {"C1H2N1O1", "C1H2N2", "H2O1", "H3N1"}]&)
    ],

    (* --- Message Tests --- *)
    Example[{Messages, "InputLengthMismatch", "Message is thrown that function does not support Preview option for Output:"},
      SimulatePeptideFragmentationSpectra[myStrand1, MaxIsotopes -> {3, 4}],
      $Failed,
      Messages :> {Error::InputLengthMismatch}
    ],
    Example[{Messages, "DuplicateSpecies", "Message is thrown when a State contains more than one instance of the same species:"},
      SimulatePeptideFragmentationSpectra[myStateWithDupSpecies],
      ObjectP[Object[Simulation, FragmentationSpectra]],
      Messages :> {SimulatePeptideFragmentationSpectra::DuplicateSpecies}
    ],
    Example[{Messages, "InvalidCharges", "Message is thrown when MinCharge is greater than MaxCharge:"},
      SimulatePeptideFragmentationSpectra[myStrand1, MinCharge -> 5, MaxCharge -> 2],
      $Failed,
      Messages :> {SimulatePeptideFragmentationSpectra::InvalidCharges}
    ],
    Example[{Messages, "FatalError", "Message is thrown when we cannot contact the server, or an error is returned:"},
      SimulatePeptideFragmentationSpectra[myStrand1, Upload->False],
      $Failed,
      Messages :> {SimulatePeptideFragmentationSpectra::FatalError},
      Stubs :> {
        HTTPRequestJSON[_] = HTTPError[None, "Fake a bad request"]
      }
    ],

    (* -- Additional Tests --- *)
    Example[{Additional, "Output->Preview generates an interactive plot:"},
      SimulatePeptideFragmentationSpectra[myStrand1, Output->Preview],
      _DynamicModule
    ],
    Example[{Additional, "Output->Preview for multiple objects generates interactive plots, wrapped in SlideView:"},
      SimulatePeptideFragmentationSpectra[{myStrand1, myStrand2} , Output->Preview],
      _SlideView
    ],
    Example[{Additional, "Output->Preview with Upload->False also generates an interactive plot:"},
      SimulatePeptideFragmentationSpectra[myStrand1, Upload->False, Output->Preview],
      _DynamicModule
    ],
    Example[{Additional, "Check that index matched options are parsed/returned correctly:"},
      Map[Lookup[Association[#], MaxIsotopes]&,
        SimulatePeptideFragmentationSpectra[{myStrand1, myStrand1},MaxIsotopes -> {2, 4}, Upload -> False, Output -> Options]
      ],
      {2, 4}
    ],
    Example[{Additional, "Check that index matched options are used correctly:"},
      Map[Length[Cases[#[[2, 1]][IonLabels], "y1++"]] &,
        SimulatePeptideFragmentationSpectra[{myStrand1, myStrand1}, MaxIsotopes -> {2, 4}, Upload -> False]
      ],
      {2, 4}
    ],
    Example[{Additional, "Check that Output->Tests returns a list of tests:"},
      SimulatePeptideFragmentationSpectra[myStrand1, Output -> Tests, Upload -> False],
      {EmeraldTest[_]..}
    ],
    Example[{Additional, "Check that a strand is digested into multiple fragments:"},
      SimulatePeptideFragmentationSpectra[myStrand1, Protease->Trypsin, Upload->False][[2]],
      ConstantArray[ObjectP[Object[MassFragmentationSpectrum]], 2]
    ],
    Test["Check that a strand fragments for A,C,X,Z ions and precursors contain modifications, except the single [M+H]++ precursor fragment:",
      (*
      This test looks at all of the strands in the ions field, and makes sure that the modifications are correctly handled.
      All the A, C, X, and Z ions should have modifications, and all precursors, except for the single [M+H]++ precursor fragment.
      *)
      Length[Cases[
        Map[MemberQ[#, Modification[_]] &,
          SimulatePeptideFragmentationSpectra[myStrand1, Upload -> False,IncludedIons -> {AIon, CIon, XIon, ZIon}, IncludePrecursors -> True][[2, 1]][Ions]],
        False]
      ],
      1
    ]
  },

  Variables :> {myStrand1, myStrand2, myState, myStateWithDupSpecies},
  SetUp :> {
    $CreatedObjects = {};
    myStrand1 = Strand[Peptide["PheValAsnGlnHisLeuCysGlySerHisLeuValGluAlaLeuTyrLeuValCysGlyGluArgGlyPhePheTyrThrPro"]];
    myStrand2 = Strand[Peptide["PheValAsnGlnHisLeuCysGlySerHisLeuValGluAlaLeuTyrLeuValCysGlyGluArgGlyPhePheTyrThrProPhe"]];
    myState = State[{myStrand1, Quantity[1 Molar]}, {myStrand2, Quantity[1 Molar]}];
    myStateWithDupSpecies = State[{myStrand1, Quantity[1 Molar]}, {myStrand2, Quantity[1 Molar]}, {myStrand2, Quantity[1 Molar]}];
  },
  TearDown :> (
    EraseObject[Pick[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]],
      Force -> True, Verbose -> False];
    Unset[$CreatedObjects];
  )
];
