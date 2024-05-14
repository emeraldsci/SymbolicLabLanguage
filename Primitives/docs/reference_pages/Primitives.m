DefineUsage[DefinePrimitive,
  {
    BasicDefinitions -> {
      {"DefinePrimitive[primitiveHead]", "association", "defines the primitive for the given 'primitiveHead' by returning information in 'association' that will be passed to DefinePrimitiveSet."}
    },
    MoreInformation -> {
      "DefinePrimitive also installs the box forms in the front end for display of the primitives.",
      "DefinePrimitive requires Object[UnitOperation, primitiveHead] to exist with fields for each of the options in the primitive. Make sure that the fields match the patterns of the options in the primitive, use split fields if you have to to accomplish this."
    },
    Input :> {
      {"primitiveHead", _Symbol, "The head of the primitive to be defined."}
    },
    Output :> {
      {"association", _Association, "Information about the defined primitive -- to be passed into DefinePrimitiveSet."}
    },
    SeeAlso -> {"DefinePrimitiveSet", "ExperimentSamplePreparation"},
    Author -> {"tyler.pabst", "daniel.shlian", "thomas"}
  }
];

DefineUsage[DefinePrimitiveSet,
  {
    BasicDefinitions -> {
      {"DefinePrimitiveSet[primitiveSetPattern, primitiveList]", "null", "defines primitiveSetPattern via the list of primitive information created by DefinePrimitive."}
    },
    MoreInformation -> {
      "DefinePrimitiveSet stores all the information about the primitives given in primtiiveList in $PrimitiveSetPrimitiveLookup."
    },
    Input :> {
      {"primitiveSetPattern", _Symbol, "The symbol to install the pattern of the primitive set in."},
      {"primitiveList", _List, "The list of primitive information, created by calling DefinePrimitive for each primitive."}
    },
    Output :> {
      {"null", Null, "Null."}
    },
    SeeAlso -> {"DefinePrimitiveSet", "ExperimentSamplePreparation"},
    Author -> {"tyler.pabst", "daniel.shlian", "thomas"}
  }
];