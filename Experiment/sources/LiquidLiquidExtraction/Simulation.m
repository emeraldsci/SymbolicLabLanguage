DefineOptions[PredictSamplePhase,
  Options:>{
    {
      OptionName -> Output,
      Default -> Phase,
      AllowNull -> True,
      Widget -> Alternatives[
        Widget[Type -> Enumeration, Pattern :> Phase | Volume | Mass| Molecule],
        Adder[Widget[Type -> Enumeration, Pattern :> Phase | Volume | Mass| Molecule]]
      ],
      Description -> "Indicate what the function should return.",
      Category -> "General"
    },
    CacheOption,
    SimulationOption
  }
];

$PredictSamplePhaseSampleFields = {Solvent, Composition, Volume};
$PredictSamplePhaseMoleculeFields = {LogP, PubChemID, InChI, InChIKey, Molecule, Name, Density};

PredictSamplePhase[mySamples:ListableP[ObjectP[{Object[Sample],Model[Sample]}]], myOptions:OptionsPattern[]]:=Module[
  {cache, simulation, outputFormat, samplePacketFields, samplePackets, solventPackets, sampleCompositionMoleculePackets, cacheBall,
    solventCompositionMoleculePackets, filteredCompositions, moleculesForEachSample, moleculesToVolumeOrMassPercentForEachSample,
    uniqueMolecules, logPValuesPerUniqueMolecule, moleculeToLogPLookup, predictedSamplePhases, predictedAqueousVolume,
    predictedOrganicVolume, predictedAqueousMass, predictedOrganicMass, predictedAqueousMolecules, predicitedOrganicMolecules, outputRules},

  (* Get our cache and simulation. *)
  cache = Lookup[ToList[myOptions], Cache, {}];
  simulation = Lookup[ToList[myOptions], Simulation, Null];
  outputFormat = Lookup[ToList[myOptions], Output, Phase];

  (* Get the information about our samples. *)
  samplePacketFields = Packet@@$PredictSamplePhaseSampleFields;
  {
    samplePackets,
    solventPackets,
    sampleCompositionMoleculePackets,
    solventCompositionMoleculePackets
  } = Transpose@Quiet[
    Download[
      ToList[mySamples],
      {
        samplePacketFields,
        Packet[Solvent[Composition]],
        Packet[Composition[[All,2]][$PredictSamplePhaseMoleculeFields]],
        Packet[Solvent[Composition][[All,2]][$PredictSamplePhaseMoleculeFields]]
      },
      Cache -> cache,
      Simulation -> simulation
    ],
    {Download::FieldDoesntExist}
  ];

  cacheBall=FlattenCachePackets[{samplePackets, solventPackets, sampleCompositionMoleculePackets, solventCompositionMoleculePackets}];

  (* For each sample, only look at the elements of the composition that are in VolumePercent or MassPercent. *)
  filteredCompositions = MapThread[
    Function[{samplePacket, solventPacket},
      If[MatchQ[Lookup[samplePacket, Solvent], ObjectP[]],
        Cases[Lookup[solventPacket, Composition], {GreaterEqualP[0 VolumePercent]|GreaterEqualP[0 MassPercent], ObjectP[Model[Molecule]]}|{GreaterEqualP[0 VolumePercent]|GreaterEqualP[0 MassPercent], ObjectP[Model[Molecule]], _}][[All, {1, 2}]],
        Cases[Lookup[samplePacket, Composition], {GreaterEqualP[0 VolumePercent]|GreaterEqualP[0 MassPercent], ObjectP[Model[Molecule]]}|{GreaterEqualP[0 VolumePercent]|GreaterEqualP[0 MassPercent], ObjectP[Model[Molecule]], _}][[All, {1, 2}]]
      ]
    ],
    {samplePackets, solventPackets}
  ];

  (* Parse out the molecules and create a lookup of molecules to volume percent for each sample. *)
  moleculesForEachSample = (#[[All,2]] /. {link:LinkP[] :> Download[link, Object]}&)/@filteredCompositions;
  moleculesToVolumeOrMassPercentForEachSample = (Rule@@@Transpose[{Download[#[[All,2]], Object], #[[All,1]]}]&)/@filteredCompositions;

  (* Get the unique molecules to pass down to SimulateLogPartitionCoefficient. *)
  uniqueMolecules = DeleteDuplicates@Download[Flatten[moleculesForEachSample], Object];

  (* Predict the LogP values for each molecule. *)
  logPValuesPerUniqueMolecule = If[Length[uniqueMolecules] == 0,
    {},
    Quiet@SimulateLogPartitionCoefficient[uniqueMolecules, Cache -> cacheBall]
  ];

  (* Create a lookup between molecule objects (in object reference form) and their LogP values. *)
  moleculeToLogPLookup = Association[Rule@@@Transpose[{uniqueMolecules, logPValuesPerUniqueMolecule}]];

  (* For each sample, classify its phase. *)
  {predictedSamplePhases, predictedAqueousMolecules, predicitedOrganicMolecules, predictedAqueousVolume, predictedOrganicVolume, predictedAqueousMass, predictedOrganicMass}=Transpose@MapThread[
    Function[{molecules, moleculesToVolumeOrMassPercent, sampleVolume, sampleMass},
      Module[{logPMoleculeValuesForEachSample, volumeOrMassPercentMoleculeValuesForEachSample, aqueousInformation,
        aqueousMolecules, aqueousVolumeOrMassPercents, organicInformation, organicMolecules, totalAqueousVolumePercent, totalAqueousMassPercent,
        organicVolumeOrMassPercents, totalOrganicVolumePercent, totalOrganicMassPercent, volumePercentScaling, massPercentScaling, classification},

        logPMoleculeValuesForEachSample=(Lookup[moleculeToLogPLookup, #]&)/@molecules;
        volumeOrMassPercentMoleculeValuesForEachSample=(Lookup[moleculesToVolumeOrMassPercent, #]&)/@molecules;

        aqueousInformation=Cases[
          Transpose[{molecules, logPMoleculeValuesForEachSample, volumeOrMassPercentMoleculeValuesForEachSample}],
          {molecule_, LessP[$AqueousLogPThreshold], volOrMassPercent_}:>{molecule, volOrMassPercent}
        ];

        {aqueousMolecules, aqueousVolumeOrMassPercents}=If[Length[aqueousInformation]==0,
          {{}, {}},
          Transpose[aqueousInformation]
        ];

        totalAqueousVolumePercent = If[Length[aqueousVolumeOrMassPercents] == 0,
          0 VolumePercent,
          Total[Cases[aqueousVolumeOrMassPercents,VolumePercentP]]
        ];

        totalAqueousMassPercent = If[Length[aqueousVolumeOrMassPercents] == 0,
          0 MassPercent,
          Total[Cases[aqueousVolumeOrMassPercents,MassPercentP]]
        ];

        organicInformation=Cases[
          Transpose[{molecules, logPMoleculeValuesForEachSample, volumeOrMassPercentMoleculeValuesForEachSample}],
          {molecule_, GreaterP[$OrganicLogPThreshold], volOrMassPercent_}:>{molecule, volOrMassPercent}
        ];

        {organicMolecules, organicVolumeOrMassPercents}=If[Length[organicInformation]==0,
          {{}, {}},
          Transpose[organicInformation]
        ];

        totalOrganicVolumePercent = If[Length[organicVolumeOrMassPercents] == 0,
          0 VolumePercent,
          Total[Cases[organicVolumeOrMassPercents,VolumePercentP]]
        ];

        totalOrganicMassPercent = If[Length[organicVolumeOrMassPercents] == 0,
          0 MassPercent,
          Total[Cases[organicVolumeOrMassPercents,MassPercentP]]
        ];

        volumePercentScaling = If[!MatchQ[(totalAqueousVolumePercent + totalOrganicVolumePercent), GreaterP[0 VolumePercent]],
          0,
          (100 VolumePercent) / (totalAqueousVolumePercent + totalOrganicVolumePercent)
        ];

        massPercentScaling = If[!MatchQ[(totalAqueousMassPercent + totalOrganicMassPercent), GreaterP[0 MassPercent]],
          0,
          (100 MassPercent) / (totalAqueousMassPercent + totalOrganicMassPercent)
        ];

        classification = Which[
          (MatchQ[totalAqueousVolumePercent, GreaterP[30 VolumePercent]]||MatchQ[totalAqueousMassPercent, GreaterP[30 MassPercent]]) && MatchQ[totalOrganicVolumePercent, GreaterP[30 VolumePercent]],
            Biphasic,
          (MatchQ[totalOrganicVolumePercent, GreaterP[30 VolumePercent]]||MatchQ[totalOrganicMassPercent, GreaterP[30 MassPercent]]),
            Organic,
          (MatchQ[totalAqueousVolumePercent, GreaterP[30 VolumePercent]]||MatchQ[totalAqueousMassPercent, GreaterP[30 MassPercent]]) && MemberQ[molecules, ObjectP[Model[Molecule, "id:vXl9j57PmP5D"]]], (* Model[Molecule, "Water"] *)
            Aqueous,
          True,
            Unknown
        ];

        {
          classification,
          Aqueous -> aqueousMolecules,
          Organic -> organicMolecules,
          Aqueous -> If[MatchQ[QuantityMagnitude[totalAqueousVolumePercent]/100 * sampleVolume * volumePercentScaling, GreaterEqualP[0 Liter]],
            QuantityMagnitude[totalAqueousVolumePercent]/100 * sampleVolume * volumePercentScaling,
            0 Milliliter
          ],
          Organic -> If[MatchQ[QuantityMagnitude[totalOrganicVolumePercent]/100 * sampleVolume * volumePercentScaling, GreaterEqualP[0 Liter]],
            QuantityMagnitude[totalOrganicVolumePercent]/100 * sampleVolume * volumePercentScaling,
            0 Milliliter
          ],
          Aqueous -> If[MatchQ[QuantityMagnitude[totalAqueousMassPercent]/100 * sampleMass * massPercentScaling, GreaterEqualP[0 Gram]],
            QuantityMagnitude[totalAqueousMassPercent]/100 * sampleMass * massPercentScaling,
            0 Milliliter
          ],
          Organic -> If[MatchQ[QuantityMagnitude[totalOrganicVolumePercent]/100 * sampleMass * massPercentScaling, GreaterEqualP[0 Gram]],
            QuantityMagnitude[totalOrganicVolumePercent]/100 * sampleMass * massPercentScaling,
            0 Milliliter
          ]
        }
      ]
    ],
    {moleculesForEachSample, moleculesToVolumeOrMassPercentForEachSample, Lookup[samplePackets, Volume, Null], Lookup[samplePackets, Mass, Null]}
  ];

  (* Return. *)
  outputRules = {
    Phase -> If[MatchQ[mySamples, _List],
      predictedSamplePhases,
      FirstOrDefault@predictedSamplePhases
    ],
    Volume -> If[MatchQ[mySamples, _List],
      Transpose[{predictedAqueousVolume, predictedOrganicVolume}],
      FirstOrDefault@Transpose[{predictedAqueousVolume, predictedOrganicVolume}]
    ],
    Mass -> If[MatchQ[mySamples, _List],
      Transpose[{predictedAqueousMass, predictedOrganicMass}],
      FirstOrDefault@Transpose[{predictedAqueousMass, predictedOrganicMass}]
    ],
    Molecule -> If[MatchQ[mySamples, _List],
      Transpose[{predictedAqueousMolecules, predicitedOrganicMolecules}],
      FirstOrDefault@Transpose[{predictedAqueousMolecules, predicitedOrganicMolecules}]
    ]
  };

  outputFormat /. outputRules
];
PredictSamplePhase[myEmptySamples:{}, myOptions:OptionsPattern[]]:={};

DefineOptions[PredictDestinationPhase,
  Options:>{
    CacheOption,
    SimulationOption
  }
];

PredictDestinationPhase[myMolecules:ListableP[ObjectP[Model[Molecule]]], myOptions:OptionsPattern[]]:=Module[
  {cache, simulation, logPValues},

  (* Get our cache and simulation. *)
  cache = Lookup[ToList[myOptions], Cache, {}];
  simulation = Lookup[ToList[myOptions], Simulation, Null];

  (* Get the LogP values for each of our molecules. *)
  logPValues=Quiet@SimulateLogPartitionCoefficient[myMolecules, Cache -> cache];

  (* If the LogP > 0, it will end up in the organic layer, if the LogP < 0, it will end up in the aqueous layer. *)
  logPValues/.{GreaterP[0] -> Organic, LessP[0] -> Aqueous, _ -> Unknown}
];

Error::NoAvailableLogP="There is no known experimentally measured LogP or simulated LogP (via the XLogP3 algorithm) on PubChem for the molecule(s), `1`. Please submit a different molecule for simulation.";

SimulateLogPartitionCoefficient[myMolecules:ListableP[ObjectP[Model[Molecule]]|Null], myOptions:OptionsPattern[]]:=Module[
  {cache, simulation, listedMolecules, uniqueMolecules, moleculePacketFields, uniqueMoleculePackets, pubChemAssociations, logPData},

  (* Get our cache and simulation. *)
  cache = Lookup[ToList[myOptions], Cache, {}];
  simulation = Lookup[ToList[myOptions], Simulation, Null];

  (* Convert input to a list. *)
  listedMolecules=Download[ToList[myMolecules], Object];
  uniqueMolecules=DeleteDuplicates[Download[listedMolecules, Object]];

  (* Download identifying information about the molecules so that we can request their information from the PubChem service. *)
  moleculePacketFields=Packet@@$PredictSamplePhaseMoleculeFields;
  uniqueMoleculePackets=Download[
    uniqueMolecules,
    moleculePacketFields,
    Cache -> cache,
    Simulation -> simulation
  ];

  (* For each of these molecules, get the PubChem ID. *)
  pubChemAssociations = Block[{ExternalUpload`Private`$SimulatedLogP = True},
    Module[
      {positionsToScrape, positionsNotToScrape, notScrapeRules, pubChemIdentifiers, pubChemPackets, scrapeRules},

      (* Figure out which positions we have a LogP for and therefore don't have to populate *)
	  (* this is admittedly super weird with the If; I want it to be Null and want NumericQ to return False in the first case and True in the second case *)
      positionsNotToScrape = Position[uniqueMoleculePackets, _?(NumericQ[If[NullQ[#], Null, Lookup[#, LogP]]]&), {1}, Heads -> False];
      positionsToScrape = Position[uniqueMoleculePackets, _?(!NumericQ[If[NullQ[#], 0, Lookup[#, LogP]]]&), {1}, Heads -> False];

      (* Create rules to return a little packet with the LogP in for the cases where we have it already *)
      notScrapeRules = AssociationMap[
        <|LogP -> Lookup[Extract[uniqueMoleculePackets, #], LogP]|> &,
        positionsNotToScrape
      ];

      (* For the rest, we'll contact PubChem *)
      (* Get a list of identifiers, in order, to try for each input *)
      pubChemIdentifiers = DeleteCases[
        Lookup[
          Extract[uniqueMoleculePackets, positionsToScrape],
          {Molecule, PubChemID, InChI, Name},
          Null
        ],
        Null,
        {2}
      ];

      (* Feed those into scrapeMoleculeData, silencing any messages and replacing $Faileds with empty packets *)
      pubChemPackets = Replace[
        Quiet[ExternalUpload`Private`scrapeMoleculeData[pubChemIdentifiers]],
        $Failed -> <||>,
        1
      ];

      (* Create rules to feed those results back into the index match list *)
      scrapeRules = AssociationThread[positionsToScrape -> pubChemPackets];

      (* Create a final list of empty packets and feed in the results *)
      ReplacePart[
        ConstantArray[<||>, Length[uniqueMoleculePackets]],
        Join[notScrapeRules, scrapeRules]
      ]
    ]
  ];

  (* Lookup the LogP data. We favor experimentally measured LogP data over simulated LogP data from PubChem. *)
  logPData = Map[
    Function[{assoc},
      Which[
        !MatchQ[assoc, _Association],
          Null,
        MatchQ[Lookup[assoc, LogP], _?NumericQ],
          Lookup[assoc, LogP],
        MatchQ[Lookup[assoc, ExternalUpload`Private`SimulatedLogP], _?NumericQ],
          Lookup[assoc, ExternalUpload`Private`SimulatedLogP],
        True,
          Null
      ]
    ],
    pubChemAssociations
  ];

  If[MemberQ[Transpose[{uniqueMolecules, logPData}], {ObjectP[], Null}],
    Message[Error::NoAvailableLogP, PickList[NamedObject[uniqueMoleculePackets], Transpose[{uniqueMolecules, logPData}], {ObjectP[], Null}]];
    Message[Error::InvalidInput, PickList[NamedObject[uniqueMoleculePackets], Transpose[{uniqueMolecules, logPData}], {ObjectP[], Null}]];
  ];

  (* Expand the list if we had duplicates. *)
  If[MatchQ[myMolecules, _List],
    listedMolecules /. Rule@@@Transpose[{uniqueMolecules, logPData}],
    FirstOrDefault[listedMolecules /. Rule@@@Transpose[{uniqueMolecules, logPData}]]
  ]
];