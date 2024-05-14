(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: tharr *)
(* :Date: 2023-03-17 *)


DefineUsage[LookupIntensiveProperty,
  {
    BasicDefinitions -> {
      {"LookupIntensiveProperty[MeasuredSample, IntensiveProperty]", "IntensivePropertyValue", "finds the measured values for a given 'IntensiveProperty' if that property has already been measured for the input sample."},
      {"LookupIntensiveProperty[UnmeasuredSample, IntensiveProperty]", "IntensivePropertyObjects", "searches the database for a set of 'IntensivePropertyObjects' that matches (within a 5% tolerance by default) the composition field of the input 'UnmeasuredSample'."},
      {"LookupIntensiveProperty[Composition, IntensiveProperty]", "IntensivePropertyObjects", "searches the database for a set of 'IntensivePropertyObjects' that match the input 'Composition' (within a 5% tolerance by default)."}
    },
    Input :> {
      {"UnmeasuredSample", ObjectP[Object[Sample]], "A sample object that does not have an experimental measurement for the desired intensive property."},
      {"MeasuredSample", ObjectP[Object[Sample]], "A sample object that does have an experimental measurement for the desired intensive property."},
      {"Composition", {{CompositionP, IdentityModelP}..}, "A list of the concentrations composing a sample for which one wants to know the desired intensive property."},
      {"IntensiveProperty", IntensivePropertyP, "A symbol representing the desired intensive property that is to be searched for."}
    },
    Output :> {
      {"IntensivePropertyObjects", ObjectP[Object[IntensiveProperty]], "The intensive property objects that were determined to have a similar enough composition field to the input sample object."},
      {"IntensivePropertyValue", _?QuantityQ, "The quantity associated with the intensive property measurement is returned if such a measurement already exists for the input sample object."}
    },
    SeeAlso -> {
      "Search"
    },
    Author -> {"tommy.harrelson"}
  }
];
