(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: tharr *)
(* :Date: 2023-03-13 *)

(* ::Section::Closed:: *)
(*LookupIntensiveProperty*)


(* options *)
DefineOptions[LookupIntensiveProperty,
  Options :> {
    {
      OptionName -> Tolerance,
      Default -> 5 Percent,
      Description -> "The relative ratio that, when multiplied by the component concentration, determines the range of concentration values that specify which intensive properties are considered to be measured from an equivalent input sample/composition.",
      AllowNull -> False,
      Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Percent, 100 Percent], Units -> Percent]
    }
  }
];

(* Messages *)
LookupIntensiveProperty::UnknownComposition = "No value for `1` or composition in `2`. Cannot look up property or matching samples.";
LookupIntensiveProperty::NoMatchingSample = "No value for `1` in `2`, and no sample with that property was found matching the composition within the given tolerance.";

(* Patterns *)
(* TODO: after type defs are more well defined, revisit here and programmatically create this list. Right now, there's too many types that aren't actually intensive properties, and are not mapped to sample fields *)
(* an example is pHAdjustment which is in the list of intensive property types, but is definitely not an intensive property *)
IntensivePropertyP::usage = "The intensive properties that may be searched for using LookupIntensiveProperty.";
IntensivePropertyP := Alternatives[
  Conductivity, Density, pH, RefractiveIndex, SpecificVolume, SurfaceTension, TotalProteinConcentration, Viscosity
];

(* main code *)
LookupIntensiveProperty[sample: ObjectP[Object[Sample]], intensiveProperty: IntensivePropertyP, ops: OptionsPattern[]] := Module[
  {inputSamplePacket, composition, measurement},

  (* resolve the sample inputs to find the composition and any possible measurements *)
  inputSamplePacket = First[resolveSampleInputs[{sample}, intensiveProperty]];
  measurement = Lookup[inputSamplePacket, intensiveProperty];
  (* if the measurement exists, then return early *)
  If[MatchQ[Unitless[measurement], _?NumericQ],
    Return[measurement]
  ];

  (* otherwise we continue and send the composition information into the main overload *)
  composition = Lookup[inputSamplePacket, Composition];
  (* Check that composition exists, issue error and exit with $Failed if not. *)
  If[!MatchQ[composition, {{CompositionP, IdentityModelP}..}],
    Message[LookupIntensiveProperty::UnknownComposition, intensiveProperty, sample];
    Return[$Failed];
  ];

  (* pass to main overload *)
  result = First[LookupIntensiveProperty[{composition}, intensiveProperty, ops], $Failed];
  If[MatchQ[result, {}],
    Message[LookupIntensiveProperty::NoMatchingSample, intensiveProperty, sample]
  ];
  result
];


LookupIntensiveProperty[samples: {ObjectP[Object[Sample]]..}, intensiveProperty: IntensivePropertyP, ops: OptionsPattern[]] := Module[
  {
    inputSamplePackets, measurements, compositions,
    nullPropertyPositions, nullCompositionPositions,
    validSamplePositions, invalidSamplePositions,
    compositionsToParse, searchedMeasurements,
    noMatchPositions
  },

  inputSamplePackets = resolveSampleInputs[samples, intensiveProperty];

  (* if all the sample packets have a measurement then return early *)
  measurements = Lookup[inputSamplePackets, intensiveProperty];
  If[MatchQ[measurements, {(_?NumericQ | _?QuantityQ)..}],
    Return[measurements]
  ];

  (* If any measurements are missing, get the compositions from all the input sample packets. *)
  compositions = Lookup[inputSamplePackets, Composition];

  (*
  Find the positions for the samples with null measurements and valid compositions, and pass those to the main overload.
  For samples with null measurements and null compositions ({}), throw an error and return $Failed.
  Note that the final output needs to be reconstructed after getting the results from the main overload,
  so keep track of the null indices for reconstructing the final output.
  *)
  nullPropertyPositions = Position[measurements, Null, {1}];
  nullCompositionPositions = Position[compositions, Except[{{CompositionP, IdentityModelP}..}], {1}, Heads->False];
  validSamplePositions = Complement[nullPropertyPositions, nullCompositionPositions];
  invalidSamplePositions = Intersection[nullPropertyPositions, nullCompositionPositions];

  (* Issue errors for invalid samples. *)
  If[!MatchQ[invalidSamplePositions, {}],
    Message[LookupIntensiveProperty::UnknownComposition, intensiveProperty, samples[[Flatten[invalidSamplePositions]]]]
  ];

  (* Pass to main overload.
  If no valid compositions, skip the search and assign null to avoid throwing NoMatchingSample warning. *)
  compositionsToParse = Extract[compositions, validSamplePositions];
  searchedMeasurements = If[!MatchQ[compositionsToParse, {}],
    LookupIntensiveProperty[compositionsToParse, intensiveProperty, ops],
    Null
  ];

  (* Check for samples for which no matching sample with property could be found and issue warning. *)
  noMatchPositions = Flatten[Position[searchedMeasurements, {}]];
  If[!MatchQ[noMatchPositions, {}],
    Message[LookupIntensiveProperty::NoMatchingSample, intensiveProperty, samples[[noMatchPositions]]]
  ];

  (* Reconstruct the final output by replacing the null measurements with the most similar searched values *)
  ReplacePart[
    measurements,
    Join[
      Thread[validSamplePositions -> searchedMeasurements],
      Thread[invalidSamplePositions -> $Failed]
    ]
  ]
];


LookupIntensiveProperty[composition: {{CompositionP, IdentityModelP}..}, intensiveProperty: IntensivePropertyP, ops: OptionsPattern[]] := Module[
  {},
  (* pass to main overload *)
  First[LookupIntensiveProperty[{composition}, intensiveProperty, ops], $Failed]
];


(* ------------------------------- MAIN OVERLOAD --------------------------------------- *)
LookupIntensiveProperty[compositions: {{{CompositionP, IdentityModelP}..}..}, intensiveProperty: IntensivePropertyP, ops: OptionsPattern[]] := Module[
  {
    identityModelLists, searchResults, intensivePropertyConcentrations, tolerance,
    concentrationsLists, toleratedPatterns, matchingConcentrationsBooleans
  },

  (* --- resolve inputs ---- *)
  (* need to download key fields from input *)
  identityModelLists = getModelObjects /@ compositions;

  (* search for any matching intensive properties *)
  (* TODO: filter out nulls from identity model lists *)
  searchResults = searchForMatchingIntensiveProperties[intensiveProperty, identityModelLists];

  (* download the compositions from each matching intensive property *)
  (* NOTE: this should be safe b/c the search results should all be the same type right now *)
  (* the structure is very nested; there is a search result for every composition, and each search result contains a list of potential matching compositions *)
  intensivePropertyConcentrations = Download[searchResults, Compositions];

  (* resolve the acceptable tolerances of the given concentrations in the input compositions *)
  tolerance = OptionDefault[OptionValue[Tolerance]];
  concentrationsLists = getConcentrations /@ compositions;
  toleratedPatterns = createTolerancePatterns[#, tolerance] & /@ concentrationsLists;

  (* check each concentration list matches on the associated tolerated patterns *)
  (* a singleton of the tolerated patterns list is {_?Between[{q1, q2}], ...} *)
  (* which will be matched onto a concentrations list of {1 Gram/Liter, ...} *)
  matchingConcentrationsBooleans = MapThread[findMatchingPropertiesForSearchResults, {intensivePropertyConcentrations, toleratedPatterns}];

  (* the boolean result should be a doubly nested list of {{True, False, ...}, {False, ...}, ...} which should have the same structure as the search results *)
  (* this allows us to use PickList on each element to return search results *)
  MapThread[PickList, {searchResults, matchingConcentrationsBooleans}]

];

createTolerancePatterns[concentrations_, tolerance_] := Module[
  {fractionTolerance, fudgeFactors, minConcentrations, maxConcentrations},
  (* need to convert the tolerance in percent to a fraction *)
  fractionTolerance = N[Convert[tolerance, 1]];

  (* multiply the tolerance by each concentration value to get the allowable fudge factor *)
  fudgeFactors = multiplyButSkipNull[#, fractionTolerance] & /@ concentrations;

  (* create patterns using the RangeP and return *)
  maxConcentrations = concentrations + fudgeFactors;
  minConcentrations = concentrations - fudgeFactors;
  MapThread[RangeP, {minConcentrations, maxConcentrations}]
];

multiplyButSkipNull[num1_, num2_] := num1 * num2;
multiplyButSkipNull[Null, num2_] := Null;
multiplyButSkipNull[num1_, Null] := Null;
multiplyButSkipNull[Null, Null] := Null;

(* there are multiple search results, and we need to check each one for matches *)
findMatchingPropertiesForSearchResults[intPropSearchResult_, toleratedPatterns_] := Map[findMatchingIntensiveProperties[#, toleratedPatterns] &, intPropSearchResult];

(* within each returned object in the search there are potentially multiple property measurements *)
(* we need to map over each one and find the boolean value of whether they match or not *)
findMatchingIntensiveProperties[intPropConcentrationsList_, toleratedPatterns_] := Module[
  {booleans},

  booleans = Map[MatchQ[#, toleratedPatterns] &, intPropConcentrationsList];
  (* return the True if at least 1 match exists *)
  Or@@booleans
];

getConcentrations[composition_] := First /@ composition;

resolveSampleInputs[samples_, intensiveProperty_] := Module[
  {},
  (* goal is to check if the intensive property is already in the samples *)
  Download[samples, Packet[intensiveProperty, Composition]]
];

resolveSampleInputs[samples_, SpecificVolume] := Module[
  {inputPackets, densities, specificVolumes},
  (* if intensive property is specific volume just download the density and invert it *)
  (* redirect to get the density measurements first *)
  inputPackets = resolveSampleInputs[samples, Density];
  densities = Lookup[inputPackets, Density];

  (* invert the measured densities samples *)
  specificVolumes = Map[
    If[MatchQ[#, _?QuantityQ],
      1 / #,
      #
    ] &,
    densities
  ];

  (* make a new packet for the specific volumes *)
  MapThread[
    <|
      SpecificVolume -> #1,
      Composition -> #2
    |> &,
    {specificVolumes, Lookup[inputPackets, Composition]}
  ]
];

getModelObjects[composition_]:=Download[Last /@ composition, Object];

searchForMatchingIntensiveProperties[intensiveProperty_, identityModelLists_] := Module[
  {typesToSearch, heldTypesToSearch, listOfHeldCriteria, heldCriteria, heldCriteriaList, heldSearchArgs},

  (* get a list of types to search for from the intensive property input *)
  typesToSearch = ConstantArray[{Object[IntensiveProperty, intensiveProperty]}, Length[identityModelLists]];
  heldTypesToSearch = With[{types = typesToSearch}, Hold[types]];

  (* start creating the search criteria by wrapping Exactly around each list of models *)
  listOfHeldCriteria = Replace[identityModelLists, contents_List :> Hold[Exactly[Models == contents]], {1}];

  (* invert the list of holds to a hold of a list *)
  heldCriteria = Join @@ listOfHeldCriteria;
  heldCriteriaList = Replace[heldCriteria, Hold[contents___] :> Hold[{contents}], {0}];

  (* search for an intensive property value with exactly the same model objects *)
  heldSearchArgs = Join[heldTypesToSearch, heldCriteriaList];
  Search @@ heldSearchArgs
];
