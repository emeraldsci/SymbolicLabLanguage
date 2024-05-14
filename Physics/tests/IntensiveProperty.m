(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: tharr *)
(* :Date: 2023-03-13 *)

DefineTests[LookupIntensiveProperty,
  {

    (* ---------- Basic ---------- *)
    Example[{Basic, "The most recent measurement of the specified intensive property is returned if available:"},
      (
        density = LookupIntensiveProperty[Object[Sample, "test sample with density measurement"], Density];
        Download[Object[Sample, "test sample with density measurement"], Density] === density
      ),
      True,
      Variables :> {density}
    ],
    Example[{Basic, "If the most recent measurement of the specified intensive property can't be found, then properties with matching compositions, within the tolerance, are returned (if any are found):"},
      LookupIntensiveProperty[Object[Sample, "test sample with exactly matching composition"], Density],
      {Object[IntensiveProperty, Density, "id:GmzlKjzB9zxX"]}
    ],
    Example[{Basic, "Search the database for an IntensiveProperty object that matches an input composition:"},
      LookupIntensiveProperty[
        {
          {100 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]},
          {10 Micro Molar, Model[Molecule, Oligomer, "id:Y0lXejlOVBka"]}
        },
        Density
      ],
      {Object[IntensiveProperty, Density, "id:GmzlKjzB9zxX"]}
    ],
    Example[{Basic, "Multiple samples can be searched simultaneously. Samples with no matches generate a warning and return an empty list:"},
      LookupIntensiveProperty[{
        Object[Sample, "test sample with exactly matching composition"],
        Object[Sample, "test sample with no matching composition"]
      }, Density],
      {{Object[IntensiveProperty, Density, "id:GmzlKjzB9zxX"]}, {}},
      Messages :> {Message[LookupIntensiveProperty::NoMatchingSample]}
    ],

    (* ---------- Options ---------- *)
    Example[{Options, Tolerance, "Increasing the tolerance expands the possible returned search results by loosening the matching criteria on the composition concentrations:"},
      LookupIntensiveProperty[Object[Sample, "test sample with matching close composition"], Density, Tolerance -> 20 Percent],
      {Object[IntensiveProperty, Density, "id:GmzlKjzB9zxX"]}
    ],

    (* ---------- Messages ---------- *)
    Example[{Messages, "NoMatchingSample", "Samples with no matches generate a warning and return an empty list:"},
      LookupIntensiveProperty[Object[Sample, "test sample with no matching composition"], Density],
      {},
      Messages :> {Message[LookupIntensiveProperty::NoMatchingSample]}
    ],
    Example[{Messages, "UnknownComposition", "Unmeasured samples with no composition generates a warning and returns $Failed:"},
      LookupIntensiveProperty[Object[Sample, "test sample with pH measurement"], Density],
      $Failed,
      Messages :> {Message[LookupIntensiveProperty::UnknownComposition]}
    ],


    (* ---------- Tests ---------- *)
    Test["Testing out the basic usage of the sample input resolver:",
      resolveSampleInputs[{Object[Sample, "test sample with density measurement"]}, Density],
      {
        KeyValuePattern[{
          Density -> _?QuantityQ,
          Composition -> _
        }]
      }
    ],
    Test["The sample input resolver returns a packet with density measurement information:",
      Lookup[resolveSampleInputs[{Object[Sample, "test sample with density measurement"]}, Density], Density],
      {_?QuantityQ}
    ],
    Test["Testing out the redirect for SpecificVolume of the sample input resolver:",
      Lookup[resolveSampleInputs[{Object[Sample, "test sample with density measurement"]}, SpecificVolume], SpecificVolume],
      {1 / (1.2 Gram/Liter)},
      EquivalenceFunction -> Equal
    ],
    Test["Testing out the null return for SpecificVolume of the sample input resolver:",
      Lookup[resolveSampleInputs[{Object[Sample, "test sample with pH measurement"]}, SpecificVolume], SpecificVolume],
      {Null}
    ],
    Test["Make sure this helper gets the model objects of a composition field:",
      (
        composition = Download[Object[Sample, "test sample with composition field"], Composition];
        getModelObjects[composition]
      ),
      {IdentityModelP..},
      Variables :> {composition}
    ],
    Test["Make sure this helper gets the concentrations from a list of composition fields:",
      (
        composition = Download[Object[Sample, "test sample with composition field"], Composition];
        getConcentrations /@ {composition, composition, composition}
      ),
      {{100 VolumePercent}..},
      Variables :> {composition}
    ],
    Test["Make sure this helper searches for matches on intensive properties correctly:",
      searchForMatchingIntensiveProperties[Viscosity, {{Model[Molecule, "id:BYDOjvG676vq"]}, {Model[Molecule, "id:vXl9j57PmP5D"]}}],
      {{ObjectP[Object[IntensiveProperty, Viscosity]]..}..}
    ],
    Test["Make sure this helper correctly creates tolerance patterns:",
      createTolerancePatterns[{1 Milligram/Milliliter, 1.3 Milligram/Milliliter, 2.3 Milligram/Milliliter, 3.4 Milligram/Milliliter}, 5 Percent],
      _List
    ],
    Test["Make sure this helper multiplies 2 numbers together if they are not null:",
      multiplyButSkipNull[1.2, 1.1],
      1.32
    ],
    Test["Make sure this helper multiplies a number with null gives back Null:",
      multiplyButSkipNull[Null, 1.1],
      Null
    ],
    Test["Make sure this helper multiplies a number with null gives back Null with reversed order:",
      multiplyButSkipNull[1.1, Null],
      Null
    ],
    Test["Test helper that it correctly matches on proper concentrations:",
      findMatchingIntensiveProperties[
        {
          {1 Milligram/Milliliter, 1.3 Milligram/Milliliter, 2.3 Milligram/Milliliter, 3.4 Milligram/Milliliter},
          {1 Milligram/Milliliter, 0.2 Milligram/Milliliter, 2.3 Milligram/Milliliter, 87.3 Milligram/Milliliter}
        },
        {
          RangeP[0 Milligram/Milliliter, 2 Milligram/Milliliter], RangeP[1 Milligram/Milliliter, 2 Milligram/Milliliter],
          RangeP[2 Milligram/Milliliter, 3 Milligram/Milliliter], RangeP[3 Milligram/Milliliter, 4 Milligram/Milliliter]
        }
      ],
      True
    ],
    Test["Test helper that it correctly matches on proper concentrations:",
      findMatchingPropertiesForSearchResults[
        {
          {
            {1 Milligram/Milliliter, 1.3 Milligram/Milliliter, 2.3 Milligram/Milliliter, 3.4 Milligram/Milliliter},
            {1 Milligram/Milliliter, 0.2 Milligram/Milliliter, 2.3 Milligram/Milliliter, 87.3 Milligram/Milliliter}
          },
          {
            {12 Milligram/Milliliter, 1.3 Milligram/Milliliter, 2.3 Milligram/Milliliter, 3.4 Milligram/Milliliter},
            {1 Milligram/Milliliter, 0.2 Milligram/Milliliter, 2.3 Milligram/Milliliter, 87.3 Milligram/Milliliter}
          }
        },
        {
          RangeP[0 Milligram/Milliliter, 2 Milligram/Milliliter], RangeP[1 Milligram/Milliliter, 2 Milligram/Milliliter],
          RangeP[2 Milligram/Milliliter, 3 Milligram/Milliliter], RangeP[3 Milligram/Milliliter, 4 Milligram/Milliliter]
        }
      ],
      {True, False}
    ]
  },

  (* ---------- Symbol Set Up / Tear Down ---------- *)
  SymbolSetUp :> (
    Module[
      {testObjects, objectsToDelete},
      testObjects = {
        Object[Sample, "test sample with density measurement"], Object[Sample, "test sample with pH measurement"],
        Object[Sample, "test sample with composition field"], Object[Sample, "test sample with matching composition"],
        Object[IntensiveProperty, Density, "test intensive property with matching composition for density"],
        Object[Sample, "test sample with no matching composition"], Object[Sample, "test sample with matching close composition"],
        Object[Sample, "test sample with matching models"], Object[Sample, "test sample with exactly matching composition"]
      };
      objectsToDelete = PickList[testObjects, DatabaseMemberQ[testObjects]];
      EraseObject[objectsToDelete, Force -> True];
    ];
    Upload[{
      <|
        Type -> Object[Sample],
        Name -> "test sample with density measurement",
        Density -> 1.2 Gram / Liter
      |>,
      <|
        Type -> Object[Sample],
        Name -> "test sample with matching composition",
        Replace[Composition] -> {
          {100 VolumePercent, Link[Model[Molecule, "id:vXl9j57PmP5D"]]},
          {1.2 Milligram/Milliliter, Link[Model[Molecule, "id:E8zoYvN6m61A"]]}
        }
      |>,
      <|
        Type -> Object[Sample],
        Name -> "test sample with matching models",
        Replace[Composition] -> {
          {100 VolumePercent, Link[Model[Molecule, "id:vXl9j57PmP5D"]]},
          {1.2 Milligram/Milliliter, Link[Model[Molecule, Oligomer, "id:Y0lXejlOVBka"]]}
        }
      |>,
      <|
        Type -> Object[Sample],
        Name -> "test sample with matching close composition",
        Replace[Composition] -> {
          {100 VolumePercent, Link[Model[Molecule, "id:vXl9j57PmP5D"]]},
          {9 Micro Molar, Link[Model[Molecule, Oligomer, "id:Y0lXejlOVBka"]]}
        }
      |>,
      <|
        Type -> Object[Sample],
        Name -> "test sample with exactly matching composition",
        Replace[Composition] -> {
          {100 VolumePercent, Link[Model[Molecule, "id:vXl9j57PmP5D"]]},
          {10 Micro Molar, Link[Model[Molecule, Oligomer, "id:Y0lXejlOVBka"]]}
        }
      |>,
      <|
        Type -> Object[IntensiveProperty, Density],
        Name -> "test intensive property with matching composition for density",
        Replace[Models] -> {Link[Model[Molecule, "id:vXl9j57PmP5D"]], Link[Model[Molecule, "id:E8zoYvN6m61A"]]},
        Replace[Compositions] -> {{100 VolumePercent, 1.2 Milligram / Milliliter}, {30 VolumePercent, 1.5 Milligram / Milliliter}},
        Replace[Density] -> {1.02 Gram / Liter, 1.234 Gram / Liter}
      |>,
      <|
        Type -> Object[Sample],
        Name -> "test sample with no matching composition",
        Replace[Composition] -> {
          {80 VolumePercent, Link[Model[Molecule, "id:vXl9j57PmP5D"]]},
          {3.2 Milligram/Milliliter, Link[Model[Molecule, "id:E8zoYvN6m61A"]]}
        }
      |>,
      <|
        Type -> Object[Sample],
        Name -> "test sample with pH measurement",
        pH -> 7.2
      |>,
      <|
        Type -> Object[Sample],
        Name -> "test sample with composition field",
        Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "id:vXl9j57PmP5D"]]}}
      |>
    }];
  ),
  SymbolTearDown :> {
    EraseObject[{Object[Sample, "test sample with density measurement"], Object[Sample, "test sample with pH measurement"]}, Force -> True]
  }
];
