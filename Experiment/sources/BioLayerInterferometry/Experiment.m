(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection:: *)
(* --- Primitive setup --- *)

(* Map of BLI Primitive to Keys in the card: *)
$BLIPrimitivesKeys=<|
  MeasureBaseline -> {Buffers, Time, ShakeRate},
  Equilibrate -> {Buffers, Time, ShakeRate},
  Wash -> {Buffers, Time, ShakeRate},
  ActivateSurface -> {ActivationSolutions, Controls, Time, ShakeRate},
  LoadSurface -> {LoadingSolutions, Controls, ShakeRate, Time, ThresholdCriterion, AbsoluteThreshold, ThresholdSlope, ThresholdSlopeDuration},
  Quench -> {QuenchSolutions, Controls, Time, ShakeRate},
  MeasureAssociation -> {Analytes, Controls, ShakeRate, Time, ThresholdCriterion, AbsoluteThreshold, ThresholdSlope, ThresholdSlopeDuration},
  MeasureDissociation -> {Buffers, Controls, ShakeRate, Time, ThresholdCriterion, AbsoluteThreshold, ThresholdSlope, ThresholdSlopeDuration},
  Quantitate -> {Analytes, Controls, ShakeRate, Time},
  Regenerate -> {RegenerationSolutions, ShakeRate, Time},
  Neutralize -> {NeutralizationSolutions, Time, ShakeRate}
|>;

(* Map of BLIPrimitives to their icons. The images are stored as .png files under Experiment/resources/bli_icons *)
$BLIPrimitivesIcons=<|
  MeasureBaseline -> "BLI_MeasureBaseline",
  Equilibrate -> "BLI_Equilibrate",
  Wash -> "BLI_Wash",
  ActivateSurface -> "BLI_ActivateSurface",
  LoadSurface -> "BLI_LoadSurface",
  Quench -> "BLI_Quench",
  MeasureAssociation -> "BLI_MeasureAssociation",
  MeasureDissociation -> "BLI_MeasureDissociation",
  Quantitate -> "BLI_Quantitate",
  Regenerate -> "BLI_Regenerate",
  Neutralize -> "BLI_Neutralize"
|>;

(* the primitive patterns are also in  patterns.m *)
installBLIPrimitives[]:=KeyValueMap[
  Function[{head,keys},
    (* Install an Icon function that caches the import of the icon: *)
    With[{
      iconFunctionSymbol=ToExpression[ToLowerCase[ToString[head]]<>"Icon"],
      (* decide how many keys to show *)
      numKeysToShow=Which[
        MatchQ[head,Alternatives[MeasureBaseline, Equilibrate, Wash, Regenerate, Neutralize]],
        3,

        MatchQ[head,Alternatives[LoadSurface, MeasureAssociation, MeasureDissociation]],
        8,

        MatchQ[head,Alternatives[ActivateSurface, Quench, Quantitate]],
        4
      ]
    },
      (* grab the icons *)
      iconFunctionSymbol[]:=iconFunctionSymbol[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","bli_icons",Lookup[$BLIPrimitivesIcons,head]<>".png"}]];

      (* Unprotect before installing. *)
      Unprotect[head];

      (* Install the MakeBoxes upvalue: *)
      head/:MakeBoxes[summary:head[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
        head,
        summary,
        iconFunctionSymbol[],

        (* Only show the key in the itai blob if it isn't Null: *)
        (* Main itai blob: *)
        (If[MatchQ[Lookup[assoc,#,Null],Null],
          Nothing,
          BoxForm`SummaryItem[{ToString[#]<>": ", Lookup[assoc,#,Null]}]
        ]&)/@Take[keys,UpTo[numKeysToShow]],

        (* Collapsed keys: *)
        If[Length[keys]>numKeysToShow,
          (If[MatchQ[Lookup[assoc,#,Null],Null],
            Nothing,
            BoxForm`SummaryItem[{ToString[#]<>": ", Lookup[assoc,#,Null]}]
          ]&)/@keys[[numKeysToShow+1;;-1]],
          {}
        ],
        StandardForm
      ];
    ];
  ],
  $BLIPrimitivesKeys
];

(* Shortcut to make an association for the heads. *)
(* Install the first time the package is loaded: *)
installBLIPrimitives[];
OverloadSummaryHead/@Keys[$BLIPrimitivesKeys];

(* Ensure that reloading the package will re-initialize primitive generation: *)
OnLoad[
  installBLIPrimitives[];
  OverloadSummaryHead/@Keys[$BLIPrimitivesKeys];
];


(* ::Subsubsection::Closed:: *)
(* ValidBLIPrimitiveP *)

(*This is also in Patterns.m but because of dependancies (?) it must included here other wise patterns has to be reloaded*)
(* the pattern for primitives used in ExperimentBioLayerInterferometry *)

$BLIPrimitiveKeyPatterns:=<|
  Buffers -> Alternatives[_Link, ObjectP[{Object[Sample], Model[Sample]}], {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], _Link, Null]..}],
  Analytes -> Alternatives[_Link, ObjectP[{Object[Sample], Model[Sample]}], {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], _String, _Link, Null]..},_String,Samples],
  LoadingSolutions -> Alternatives[_Link, ObjectP[{Object[Sample], Model[Sample]}], {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], _String, _Link, Null]..},_String, Samples],
  QuenchSolutions -> Alternatives[_Link, ObjectP[{Object[Sample], Model[Sample]}], {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], _Link, Null]..}],
  ActivationSolutions -> Alternatives[_Link, ObjectP[{Object[Sample], Model[Sample]}], {Alternatives[ObjectP[{Object[Sample], Model[Sample]}],  _Link, Null]..}],
  RegenerationSolutions -> Alternatives[_Link, ObjectP[{Object[Sample], Model[Sample]}], {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], _Link, Null]..}],
  NeutralizationSolutions -> Alternatives[_Link, ObjectP[{Object[Sample], Model[Sample]}], {Alternatives[ObjectP[{Object[Sample], Model[Sample]}],  _Link, Null]..}],
  Controls -> Alternatives[_Link, ObjectP[{Object[Sample], Model[Sample]}], {Alternatives[ObjectP[{Object[Sample], Model[Sample]}],_Link, Null]...}],
  Time -> RangeP[0 Hour, 20 Hour],
  ShakeRate -> Alternatives[RangeP[100 RPM, 1500 RPM], 0 RPM],
  ThresholdCriterion -> Alternatives[Single,All],
  AbsoluteThreshold -> RangeP[-500*Nanometer, 500*Nanometer],
  ThresholdSlope -> GreaterP[0*Nanometer/Minute],
  ThresholdSlopeDuration -> RangeP[0 Hour, 20 Hour]
|>;

(* enforce that if a key is found in the primitive association, the value matches the required pattern *)
bliKeysMatchPatternQ[assoc_Association]:=And@@KeyValueMap[
  Function[{key,value},
    If[KeyExistsQ[$BLIPrimitiveKeyPatterns, key],
      MatchQ[value, Lookup[$BLIPrimitiveKeyPatterns, key]|Null],
      True
    ]
  ],
  assoc
];

(* --- BLI primitives patterns --- *)

Authors[Equilibrate] := {"alou"};
Authors[MeasureBaseline] := {"alou"};
Authors[Wash] := {"alou"};
Authors[Regenerate] := {"alou"};
Authors[Neutralize] := {"alou"};
Authors[Quantitate] := {"alou"};
Authors[Quench] := {"alou"};
Authors[ActivateSurface] := {"alou"};
Authors[LoadSurface] := {"alou"};
Authors[MeasureAssociation] := {"alou"};
Authors[MeasureDissociation] := {"alou"};

(* check that the primitives have the correct keys and and that the values match the given pattern *)
(* Equilibrate, MeasureBaseline, Wash, Regenerate, Neutralize only have the 3 basic keys *)
validEquilibrateQ[Equilibrate[assoc_Association]]:=And@@(KeyExistsQ[assoc, #]&/@{Buffers, Time, ShakeRate})&&bliKeysMatchPatternQ[assoc];
validMeasureBaselineQ[MeasureBaseline[assoc_Association]]:=And@@(KeyExistsQ[assoc, #]&/@{Buffers, Time, ShakeRate})&&bliKeysMatchPatternQ[assoc];
validWashQ[Wash[assoc_Association]]:=And@@(KeyExistsQ[assoc, #]&/@{Buffers, Time, ShakeRate})&&bliKeysMatchPatternQ[assoc];
validRegenerateQ[Regenerate[assoc_Association]]:=And@@(KeyExistsQ[assoc, #]&/@{RegenerationSolutions, Time, ShakeRate})&&bliKeysMatchPatternQ[assoc];
validNeutralizeQ[Neutralize[assoc_Association]]:=And@@(KeyExistsQ[assoc, #]&/@{NeutralizationSolutions, Time, ShakeRate})&&bliKeysMatchPatternQ[assoc];

(* ActivateSurface, Quench, Quantitate have a buffer key *)
validQuantitateQ[Quantitate[assoc_Association]]:=And@@(KeyExistsQ[assoc, #]&/@{Analytes, Time, ShakeRate})&&bliKeysMatchPatternQ[assoc];
validQuenchQ[Quench[assoc_Association]]:=And@@(KeyExistsQ[assoc, #]&/@{QuenchSolutions, Time, ShakeRate})&&bliKeysMatchPatternQ[assoc];
validActivateSurfaceQ[ActivateSurface[assoc_Association]]:=And@@(KeyExistsQ[assoc, #]&/@{ActivationSolutions, Time, ShakeRate})&&bliKeysMatchPatternQ[assoc];

(* LoadSurface, MeasureAssociation, and MeasureDissociation all have threshold keys *)
validLoadSurfaceQ[LoadSurface[assoc_Association]]:=Module[{basicKeysCheck, blanksCheck, thresholdCriterionCheck, thresholdDefinitionCheck, slopeDuration, slope, absolute, criterion},
  {absolute, slope, slopeDuration, criterion}= Lookup[assoc, {AbsoluteThreshold, ThresholdSlope, ThresholdSlopeDuration, ThresholdCriterion}, Null];

  (* check that the required keys are properly informed, and that all given keys match their pattern *)
  basicKeysCheck = And@@(KeyExistsQ[assoc, #]&/@{LoadingSolutions, Time, ShakeRate})&&bliKeysMatchPatternQ[assoc];

  (* check that there arent too many blanks *)
  blanksCheck = Length[ToList[Lookup[assoc, Controls]]]<7;

  (* check that the threshold criterion is informed if the other are also *)
  thresholdCriterionCheck = (MemberQ[{absolute, slope, slopeDuration}, Except[Null]]&&MatchQ[criterion, (Single|All)])||!MemberQ[{absolute, slope, slopeDuration}, Except[Null]];

  (* check that the threshold parameters make sense or are not informed at all *)
  thresholdDefinitionCheck = Or@@{
    MatchQ[absolute, Null]&&MatchQ[{slope, slopeDuration}, {Except[Null], Except[Null]}],
    MatchQ[absolute, Except[Null]&&MatchQ[{slope, slopeDuration}, {Null, Null}]],
    MatchQ[{absolute, slope, slopeDuration}, {Null, Null, Null}]
  };

  (* check that all of the criteria are met *)
  And@@{basicKeysCheck, blanksCheck, thresholdCriterionCheck, thresholdDefinitionCheck}
];

validMeasureAssociationQ[MeasureAssociation[assoc_Association]]:=Module[{basicKeysCheck, blanksCheck, thresholdCriterionCheck, thresholdDefinitionCheck, slopeDuration, slope, absolute, criterion},
  {absolute, slope, slopeDuration, criterion}= Lookup[assoc, {AbsoluteThreshold, ThresholdSlope, ThresholdSlopeDuration, ThresholdCriterion}, Null];

  (* check that the required keys are properly informed, and that all given keys match their pattern *)
  basicKeysCheck = And@@(KeyExistsQ[assoc, #]&/@{Analytes, Time, ShakeRate})&&bliKeysMatchPatternQ[assoc];

  (* check that there arent too many blanks *)
  blanksCheck = Length[ToList[Lookup[assoc, Controls]]]<7;

  (* check that the threshold criterion is informed if the other are also *)
  thresholdCriterionCheck = (MemberQ[{absolute, slope, slopeDuration}, Except[Null]]&&MatchQ[criterion, (Single|All)])||!MemberQ[{absolute, slope, slopeDuration}, Except[Null]];

  (* check that the threshold parameters make sense or are not informed at all *)
  thresholdDefinitionCheck = Or@@{
    MatchQ[absolute, Null]&&MatchQ[{slope, slopeDuration}, {Except[Null], Except[Null]}],
    MatchQ[absolute, Except[Null]&&MatchQ[{slope, slopeDuration}, {Null, Null}]],
    MatchQ[{absolute, slope, slopeDuration}, {Null, Null, Null}]
  };

  (* check that all of the criteria are met *)
  And@@{basicKeysCheck, blanksCheck, thresholdCriterionCheck, thresholdDefinitionCheck}
];
validMeasureDissociationQ[MeasureDissociation[assoc_Association]]:=Module[{basicKeysCheck, blanksCheck, thresholdCriterionCheck, thresholdDefinitionCheck, slopeDuration, slope, absolute, criterion},
  {absolute, slope, slopeDuration, criterion}= Lookup[assoc, {AbsoluteThreshold, ThresholdSlope, ThresholdSlopeDuration, ThresholdCriterion}, Null];

  (* check that the required keys are properly informed, and that all given keys match their pattern *)
  basicKeysCheck = And@@(KeyExistsQ[assoc, #]&/@{Buffers, Time, ShakeRate})&&bliKeysMatchPatternQ[assoc];

  (* check that there arent too many blanks *)
  blanksCheck = Length[ToList[Lookup[assoc, Controls]]]<7;

  (* check that the threshold criterion is informed if the other are also *)
  thresholdCriterionCheck = (MemberQ[{absolute, slope, slopeDuration}, Except[Null]]&&MatchQ[criterion, (Single|All)])||!MemberQ[{absolute, slope, slopeDuration}, Except[Null]];

  (* check that the threshold parameters make sense or are not informed at all *)
  thresholdDefinitionCheck = Or@@{
    MatchQ[absolute, Null]&&MatchQ[{slope, slopeDuration}, {Except[Null], Except[Null]}],
    MatchQ[absolute, Except[Null]&&MatchQ[{slope, slopeDuration}, {Null, Null}]],
    MatchQ[{absolute, slope, slopeDuration}, {Null, Null, Null}]
  };

  (* check that all of the criteria are met *)
  And@@{basicKeysCheck, blanksCheck, thresholdCriterionCheck, thresholdDefinitionCheck}
];


(* generate patterns for each of the primitives based on the Q's *)
ValidEquilibrateP:=_?validEquilibrateQ;
ValidMeasureBaselineP:=_?validMeasureBaselineQ;
ValidActivateSurfaceP:=_?validActivateSurfaceQ;
ValidWashP:=_?validWashQ;
ValidLoadSurfaceP:=_?validLoadSurfaceQ;
ValidQuantitateP:=_?validQuantitateQ;
ValidQuenchP:=_?validQuenchQ;
ValidRegenerateP:=_?validRegenerateQ;
ValidNeutralizeP:=_?validNeutralizeQ;
ValidMeasureAssociationP:=_?validMeasureAssociationQ;
ValidMeasureDissociationP:=_?validMeasureDissociationQ;

(* collect all of them together to check any primitive set *)
ValidBLIPrimitiveP = Alternatives[ValidEquilibrateP, ValidMeasureBaselineP, ValidActivateSurfaceP, ValidWashP, ValidLoadSurfaceP,
  ValidQuantitateP, ValidQuenchP, ValidRegenerateP, ValidNeutralizeP, ValidMeasureAssociationP, ValidMeasureDissociationP];



(* ::Subsection::Closed:: *)
(* Options *)

DefineOptions[ExperimentBioLayerInterferometry,
  Options:> {
    {
      OptionName -> Instrument,
      Default -> Model[Instrument,BioLayerInterferometer, "Octet Red96e"],
      Description -> "The device on which the bio-layer interferometry protocol is to be run.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Model[Instrument, BioLayerInterferometer], Object[Instrument, BioLayerInterferometer]}]
      ],
      Category -> "General"
    },
    {
      OptionName -> ExperimentType,
      Default -> Quantitation,
      Description -> "The objective of bio-layer interferometry experiment. Kinetics: Measure association and dissociation rates of the interaction between a solution phase species and a functionalized bio-probe surface. Quantitation: Quantify the amount of analyte in a solution by measuring the change in bio-layer thickness upon immersion of a functionalized bio-probe in a solution containing the target analyte. EpitopeBinning: Use competition experiments between two antibodies to identify groups of antibodies which bind a given antigen at the same epitope. AssayDevelopment: Optimize the bio-probe functionalization and individual assay steps by performing steps in a variety of solutions.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> Alternatives[BLIApplicationsP]
      ],
      Category -> "General"
    },
    {
      OptionName -> BioProbeType,
      Default -> Model[Item, BLIProbe, "ProA"],
      Description -> "Indicates the type of surface-functionalized fiber-optic probe to be used in this experiment. The probe surface functionalization may allow for direct binding to the analyte, or can be further functionalized with an immobilized secondary species, which would then interact with the solution phase analyte in a subsequent step.",
      AllowNull->False,
      Category -> "General",
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Model[Item, BLIProbe], Object[Item, BLIProbe]}],
        ObjectTypes -> {Object[Item, BLIProbe], Model[Item, BLIProbe]}
      ]
    },
    {
      OptionName -> NumberOfRepeats,
      Default -> Null,
      Description -> "The number of times that the assay will be repeated for each set of samples. All assay steps will be repeated with a new set of bio-probes unless a Regeneration option has been selected.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Number,
        Pattern :> RangeP[2,12,1]
      ],
      Category -> "General"
    },
    {
      OptionName -> AcquisitionRate,
      Default -> 5 Hertz,
      Description -> "Indicates the number of recorded data points per second. A lower acquisition rate (2 Hz) will average more scans per data point, leading to better signal-to-noise ratios. A higher rate (10 Hz) will generates more data points per second, and is best suited for fast binding events which cause rapid changes in bio-layer thickness. The default value of 5 Hz balances data density with signal-to-noise ratio reduction and is suitable for most experiments.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> Alternatives[2 Hertz, 5 Hertz, 10 Hertz]
      ],
      Category -> "General"
    },
    {
      OptionName -> PlateCover,
      Default -> Automatic,
      Description -> "Indicates if a plate cover should be included. This is recommended for assays which are expected to run for more than 4 hours in order to prevent evaporation.",
      ResolutionDescription -> "PlateCover default to True for assays over 4 hours in length.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> BooleanP
      ],
      Category -> "General"
    },
    {
      OptionName -> Temperature,
      Default -> Ambient,
      Description -> "The temperature of the 96 well plate in which the assay is run.",
      AllowNull -> False,
      Widget -> Alternatives[
        Widget[
          Type->Enumeration,
          Pattern:>Alternatives[Ambient]
        ],
        Widget[
          Type -> Quantity,
          Pattern :> RangeP[15 Celsius, 40 Celsius],
          Units->Celsius
        ]
      ],
      Category -> "General"
    },



    (*General*)
    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      {
        OptionName -> RecoupSample,
        Default -> False,
        AllowNull->False,
        Widget -> Widget[
          Type->Enumeration,
          Pattern:>BooleanP
        ],
        Description -> "Indicates if the SampleIn used for bio-layer interferometry measurement will be transferred back into the container that they were in prior to the measurement.",
        Category -> "General"
      }
    ],
    {
      OptionName -> SaveAssayPlate,
      Default -> False,
      AllowNull->False,
      Widget -> Widget[
        Type->Enumeration,
        Pattern:>BooleanP
      ],
      Description -> "Indicates if the Assay Plate should be saved and stored or discarded after the assay is completed.  Note that if both SaveAssayPlate and RecoupSample are True, input samples will be transferred out of the plate and the plate will be stored separately.",
      Category -> "General"
    },


    (*Assay Preparation*)


    {
      OptionName -> ProbeRackEquilibration,
      Default -> True,
      Description -> "Indicates if the bio-probes used in the assay are equilibrated in ProbeRackEquilibrationBuffer solution while stored in the bio-probe rack, which holds bio-probes before and during the experiment. All bio-probes used in this experiment will remain immersed in the ProbRackEquilibrationBuffer until they are required for use in the assay.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> BooleanP
      ],
      Category -> "Assay Preparation"
    },
    {
      OptionName -> ProbeRackEquilibrationTime,
      Default -> Automatic,
      Description -> "The minimum amount of time that the bio-probes used in the assay are equilibrated in ProbeRackEquilibrationBuffer prior to use in the assay. All bio-probes used in this experiment will remain immersed in the ProbeEquilibrationBufferSolution until required for the assay.",
      ResolutionDescription -> "ProbeRackEquilibrationTime will default to 10 Minute if ProbeRackEquilibration is True.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Second, 2 Hour],
        Units -> Alternatives[Second, Minute, Hour]
      ],
      Category -> "Assay Preparation"
    },
    {
      OptionName -> ProbeRackEquilibrationBuffer,
      Default -> Automatic,
      Description -> "Indicates the type of buffer used for ProbeRackEquilibration.",
      ResolutionDescription -> "ProbeRackEquilibrationBuffer defaults to DefaultBuffer when ProbeRackEquilibration is true.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
        ObjectTypes -> {Object[Sample], Model[Sample]}
      ],
      Category -> "Assay Preparation"
    },
    {
      OptionName -> StartDelay,
      Default -> Automatic,
      Description -> "Dictates the amount of time that the assay plate is located in the instrument at the desired temperature prior to beginning the assay.",
      ResolutionDescription -> "StartDelay is set to 15 Minutes if the PlateTemperature is not Ambient. This allows the assay plate temperature to equilibrate.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Minute, 2 Hour],
        Units -> Alternatives[Second, Minute, Hour]
      ],
      Category -> "Assay Preparation"
    },
    {
      OptionName -> StartDelayShake,
      Default -> Automatic,
      Description -> "Indicates if the prepared-assay 96 well plate is shaken during the StartDelay time.",
      ResolutionDescription -> "StartDelayShake is set to True if the PlateTemperature is not Ambient.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> BooleanP
      ],
      Category -> "Assay Preparation"
    },
    {
      OptionName -> Equilibrate,
      Default -> Automatic,
      Description -> "Indicates if an assay step should be added to the beginning of the assay in which the bio-probes are equilibrated in the assay plate.",
      ResolutionDescription -> "Equilibrate defaults to True if ProbeRackEquilibration is False.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> BooleanP
      ],
      Category -> "Assay Preparation"
    },
    {
      OptionName -> EquilibrateTime,
      Default -> Automatic,
      Description -> "The amount of time that the bio-probes are immersed in EquilibrateBuffer as the first step in the assay.",
      ResolutionDescription -> "EquilibrateTime will default to 10 Minute if Equilibrate is True.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Second, 2 Hour],
        Units -> Alternatives[Second, Minute, Hour]
      ],
      Category -> "Assay Preparation"
    },
    {
      OptionName -> EquilibrateBuffer,
      Default -> Automatic,
      Description -> "Indicates the type of buffer used for the Equilibrate step.",
      ResolutionDescription -> "EquilibrateBuffer defaults to DefaultBuffer when Equilibrate is True.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
        ObjectTypes -> {Object[Sample], Model[Sample]}
      ],
      Category -> "Assay Preparation"
    },
    {
      OptionName -> EquilibrateShakeRate,
      Default -> Automatic,
      Description -> "Indicates the rate at which the assay 96 well plate is shaken during the Equilibrate step.",
      ResolutionDescription -> "EquilibrateShakeRate is set to 1000 RPM is Equilibrate is True.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[100 RPM, 1500 RPM],
        Units -> RPM
      ],
      Category -> "Assay Preparation"
    },


    (*BUFFER AND BASELINE SOLUTIONS *)

    {
      OptionName -> DefaultBuffer,
      Default -> Model[Sample, StockSolution, "BLI Kinetics Buffer, 1X"],
      Description -> "The primary buffer solution to be used as the default solution for baseline, equilibration, bio-probe rinsing, or dissociation steps. Note that all assay steps using this solution will occur in a single set of wells containing DefaultBuffer, with the exception of Dissociation steps. If multiple buffers are required, indicate the appropriate buffers in the assay specific options section, or by using the AssaySequencePrimitives.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
        ObjectTypes -> {Object[Sample], Model[Sample]}
      ],
      Category -> "General"
    },
    {
      OptionName -> ReuseSolution,
      Default -> {{MeasureBaseline, Wash, Equilibrate, MeasureDissociation, LoadSurface, ActivateSurface, Quench, Regenerate, Neutralize, Quantitate, MeasureAssociation}},
      Description -> "Indicates groups of assay step types may share a set of wells if they are performed on an identical set of solutions. For example, selecting MeasureDissociation and MeasureBaseline will allow baseline and dissociation steps to occur steps in the same set of buffer wells. A single step, such as Wash, can also be selected to indicate that all Wash using identical solution should be performed in the same set of wells. This will increase the number of wells for available for sample measurement.",
      AllowNull -> True,
      Widget -> Adder[
        Adder[
          Widget[
            Type -> Enumeration,
            Pattern :> BLIPrimitiveNameP
          ]
        ]
      ],
      Category -> "General"
    },
    {
      OptionName -> Blank,
      Default -> Automatic,
      Description -> "The solution which does not contain the analyte to be use as a negative control. This solution can be used to provide a baseline for a given assay step, to account for non-specific binding of other solution species, or to verify the reproducibility of a given experiment.",
      ResolutionDescription -> "Blank will resolve to the same value as the DefaultBuffer when an experiment requires a negative control, and Null if it is not required for the assay.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
        ObjectTypes -> {Object[Sample], Model[Sample]}
      ],
      Category -> "General"
    },
    {
      OptionName -> Standard,
      Default -> Null,
      Description -> "The solution, typically containing a concentration of analyte, to be used as a positive control. This can be used to account for baseline drift and changes in the bio-probe properties.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
        ObjectTypes -> {Object[Sample], Model[Sample]}
      ],
      Category -> "General"
    },
    {
      OptionName->StandardStorageCondition,
      Default->Null,
      Description->"Specifies non-default conditions under which the Standard should be stored after the protocol is completed. If left unset, the Standard will be stored according to the current StorageCondition.",
      AllowNull->True,
      Widget-> Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
      Category->"Post Experiment"
    },

    (*Dilution Preparation*)
    {
      OptionName -> DilutionMixVolume,
      Default -> 100 Microliter,
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Microliter, 2000 Microliter],
        Units -> {1, {Liter, {Liter, Milliliter, Microliter}}}
      ],
      Description -> "The volume that is pipetted out and in of a given dilution to ensure homogeneous composition. This option also applies to PreMixSolution.",
      Category -> "Dilution Preparation"
    },
    {
      OptionName -> DilutionNumberOfMixes,
      Default -> 5,
      AllowNull -> True,
      Widget -> Widget[
        Type -> Number,
        Pattern :> RangeP[0, 20, 1]
      ],
      Description -> "The number of pipette out and in cycles that is used to mix each dilution. This option also applies to PreMixSolution.",
      Category -> "Dilution Preparation"
    },
    {
      OptionName -> DilutionMixRate,
      Default -> 50 Microliter/Second,
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0.5 Microliter/Second, 250 Microliter/Second],
        Units -> CompoundUnit[
          {1,{Microliter,{Microliter,Milliliter}}},
          {-1,{Minute,{Minute,Second}}}
        ]
      ],
      Description -> "The rate at which the DilutionMixVolume is pipetted when mixing to ensure homogeneity. This option also applies to PreMixSolution.",
      Category -> "Dilution Preparation"
    },


    (*REGENERATION STEP INFORMATION*)
    {
      OptionName->RegenerationType,
      Description->"Indicates the steps to be included when returning the bio-probe surface to a measurement-ready condition. Regenerate: Adds a step where the bio-probe is immersed in RegenerationSolution. Neutralize:  The bio-probe is immersed in NeutralizationSolution after regeneration to neutralize the probe surface. Wash: Adds a washing step after Regeneration or Neutralization (if selected) in WashSolution to remove any residual solution. PreCondition: Performs the requested regeneration cycle prior to the first sample measurement to ensure all measurements are performed with identical assay steps.",
      Default->None,
      AllowNull->True,
      Category->"Probe Regeneration",
      Widget->Alternatives[
        Widget[
          Type->Enumeration,
          Pattern:>Alternatives[None]
        ],
        Widget[
          Type->MultiSelect,
          Pattern:>DuplicateFreeListableP[Alternatives[Regenerate,Neutralize,Wash,PreCondition]]
        ]
      ]
    },
    {
      OptionName -> RegenerationSolution,
      Default -> Automatic,
      Description -> "The solution used to remove residual analyte from the bio-probe surface. Regeneration with the appropriate solution will allow for reuse of a set of bio-probes for multiple measurements.",
      ResolutionDescription->"RegenerationSolution defaults to Model[Sample, StockSolution, \"2 M HCl\"] if Regenerate is selected in RegenerationType",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
        ObjectTypes -> {Object[Sample], Model[Sample]}
      ],
      Category -> "Probe Regeneration"
    },
    {
      OptionName -> RegenerationCycles,
      Description -> "Indicates the number of times bio-probe will be subjected to the selected Regenerate and Neutralize steps (prior to a Wash step, if selected).",
      ResolutionDescription -> "RegenerationCycles will be set to 3 if RegenerationParameters is not None. This will generally provide a good balance between complete bio-probe regeneration and experiment time.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Probe Regeneration",
      Widget -> Widget[
        Type -> Number,
        Pattern :> RangeP[0, 10, 1]
      ]
    },
    {
      OptionName -> RegenerationTime,
      Description -> "The amount of time that the bio-probe is immersed in RegenerationSolution.",
      ResolutionDescription -> "RegenerationTime will be set to 5 Second if regeneration steps are included in the assay.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Probe Regeneration",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Second, 20 Minute],
        Units -> Alternatives[Second, Minute, Hour]
      ]
    },
    {
      OptionName -> RegenerationShakeRate,
      Description -> "The plate shake rate while the bio-probe is immersed in RegenerationSolution.",
      ResolutionDescription -> "RegenerationShakeRate will be set to 1000 RPM if regeneration steps are included in the assay.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Probe Regeneration",
      Widget ->Widget[
        Type -> Quantity,
        Pattern :> RangeP[100 RPM,1500 RPM],
        Units -> RPM
      ]
    },
    {
      OptionName -> NeutralizationSolution,
      Default -> Automatic,
      Description -> "The solution that will be used to neutralize the bio-probe surface after regeneration. This solution prevents alteration of the bio-probe surface pH during the regeneration step.",
      ResolutionDescription -> "The NeutralizationSolution will be set to DefaultBuffer if neutralization steps are included in the assay.",
      AllowNull -> True,
      Category -> "Probe Regeneration",
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
        ObjectTypes -> {Object[Sample], Model[Sample]}
      ]
    },
    {
      OptionName -> NeutralizationTime,
      Description -> "The amount of time for which the bio-probe is immersed in NeutralizationSolution following Regeneration.",
      ResolutionDescription -> "NeutralizationTime will be set to 5 Second if neutralization steps are included in the assay.",
      AllowNull -> True,
      Default -> Automatic,
      Category -> "Probe Regeneration",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Second, 20 Minute],
        Units -> Alternatives[Second, Minute, Hour]
      ]
    },
    {
      OptionName -> NeutralizationShakeRate,
      Description -> "The plate shake rate while the bio-probe is immersed in NeutralizationSolution following Regeneration.",
      ResolutionDescription -> "NeutralizationShakeRate will be set to 1000 RPM if neutralization steps are included in the assay.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Probe Regeneration",
      Widget ->Widget[
        Type -> Quantity,
        Pattern :> RangeP[100 RPM,1500 RPM],
        Units -> RPM
      ]
    },
    {
      OptionName -> WashSolution,
      Default -> Automatic,
      Description -> "The solution in which the bio-probe is immersed after neutralization or regeneration, depending on the selection in RegenerationType. This solution prevents interference from the neutralization or regeneration solution.",
      ResolutionDescription -> "The WashSolution will be set to DefaultBuffer if Wash is selected in RegenerationType.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
        ObjectTypes -> {Object[Sample], Model[Sample]}
      ],
      Category -> "Probe Regeneration"
    },
    {
      OptionName -> WashTime,
      Description -> "The amount of time for a step in which the bio-probe is immersed in WashSolution following Neutralization.",
      ResolutionDescription -> "The WashTime will be set to 5 Second if Wash is selected in RegenerationType.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Probe Regeneration",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Second, 20 Minute],
        Units -> Alternatives[Second, Minute, Hour]
      ]
    },
    {
      OptionName -> WashShakeRate,
      Description -> "The shake rate for a step in which the bio-probe is immersed in WashSolution following Neutralization.",
      ResolutionDescription -> "WashShakeRate will be set to 1000 RPM if Wash is selected in RegenerationType.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Probe Regeneration",
      Widget ->Widget[
        Type -> Quantity,
        Pattern :> RangeP[100 RPM,1500 RPM],
        Units -> RPM
      ]
    },



    (*LOADING STEP INFORMATION*)

    {
      OptionName->LoadingType,
      Default->None,
      Description->"Indicates the steps used in the process of loading the immobilized species on the bio-probe. Select all that apply. Load: The bio-probe will be immersed in LoadingSolution prior to sample measurement steps. Activate: The bio-probe will be immersed in ActivationSolution prior to loading. Qunech: The bio-probe will be immersed in QuenchinSolution after loading.",
      AllowNull->True,
      Category->"Probe Loading",
      Widget->Alternatives[
        Widget[
          Type->Enumeration,
          Pattern:>Alternatives[None]
        ],
        Widget[
          Type->MultiSelect,
          Pattern:>DuplicateFreeListableP[Alternatives[Load,Activate,Quench]]
        ]
      ]
    },
    {
      OptionName -> LoadSolution,
      Default -> Null,
      Description -> "The solution which contains a species that is to be immobilized on the bio-probe surface.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
        ObjectTypes -> {Object[Sample], Model[Sample]}
      ],
      Category -> "Probe Loading"
    },
    {
      OptionName->LoadSolutionStorageCondition,
      Default->Null,
      Description->"Specifies non-default conditions under which the LoadSolution should be stored after the protocol is completed. If left unset, the LoadSolution will be stored according to the current StorageCondition.",
      AllowNull->True,
      Widget-> Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
      Category->"Post Experiment"
    },
    {
      OptionName -> LoadTime,
      Default -> Automatic,
      AllowNull -> True,
      Description -> "The amount of time for which the bio-probe surface with is functionalized with the immobilized species (in LoadSolution). This allows for modification of the probe surface such that it will be sensitive to the desired analyte. The LoadingTime will limit the step length in the event that a threshold condition is not met.",
      ResolutionDescription->"LoadTime is set to 15 minutes if Load is selected in LoadingType.",
      Category -> "Probe Loading",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Second, 20 Hour],
        Units -> Alternatives[Second, Minute, Hour]
      ]
    },
    {
      OptionName -> LoadThresholdCriterion,
      Default -> Automatic,
      Category -> "Probe Loading",
      Description -> "Indicates if the threshold condition for change in bio-layer thickness which will trigger the completion of a Load step must be met by any single well, or all of the wells measured in the step. Wells containing a secondary solution such as a Blank or Standard are automatically excluded.",
      AllowNull -> True,
      Widget -> Widget[
        Type->Enumeration,
        Pattern:>Alternatives[All, Single]
      ]
    },
    {
      OptionName -> LoadAbsoluteThreshold,
      Description -> "The change in bio-layer thickness that will trigger the removal of the bio-probe from the LoadingSolution, and initiates the following assay step. This threshold sets the desired thickness of the loaded bio-layer, and can be used both to ensure sufficient loading and guard against over-saturation of the probe surface. Check Model[Instrument, BioLayerInterferometer] for limits on bio-layer thickness.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Probe Loading",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Nanometer],
        Units -> Alternatives[Nanometer, Micrometer]
      ]
    },
    {
      OptionName -> LoadThresholdSlope,
      Description -> "The rate of change in bio-layer thickness that will trigger the removal of the bio-probe from the LoadingSolution, and initiates the following assay step.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Probe Loading",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Nanometer/Minute],
        Units -> CompoundUnit[{1, {Millimeter, {Millimeter, Micrometer, Nanometer}}}, {-1, {Minute, {Minute, Second}}}]
      ]
    },
    {
      OptionName -> LoadThresholdSlopeDuration,
      Description -> "The amount of time that a given rate of change in bio-layer thickness must be exceeded to trigger the removal of the bio-probe from the LoadingSolution, and initiate the following assay step.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Probe Loading",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Second],
        Units -> Alternatives[Second, Minute]
      ]
    },
    {
      OptionName -> LoadShakeRate,
      Description -> "The speed at which the plate is agitated while the bio-probe is immersed in LoadingSolution.",
      ResolutionDescription->"LoadShakeRate is set to 1000 RPM if Load is selected in LoadingType.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Probe Loading",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[100 RPM,1500 RPM],
        Units -> RPM
      ]
    },
    {
      OptionName -> ActivateSolution,
      Default -> Null,
      Description -> "Indicates the solution used to enhance the bio-probe surface capacity and affinity for the immobilized species. The bio-probe is immersed in this solution prior to exposure to the LoadingSolution.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
        ObjectTypes -> {Object[Sample], Model[Sample]}
      ],
      Category -> "Probe Loading"
    },
    {
      OptionName -> ActivateTime,
      Description -> "The amount of time for which the bio-probe is immersed in ActivationSolution prior to loading in LoadingSolution. Activation chemically modifies the probe surface, rendering it more receptive to the immobilized species.",
      ResolutionDescription->"ActivateTime is set to 1 Minute if Activate is selected in LoadingType.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Probe Loading",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Hour, 20 Hour],
        Units -> Alternatives[Second, Minute, Hour]
      ]
    },
    {
      OptionName -> ActivateShakeRate,
      Description -> "The speed at which the plate is agitated while the bio-probe is immersed in ActivationSolution prior to loading in LoadingSolution.",
      ResolutionDescription->"ActivateTime is set to 1000 RPM if Activate is selected in LoadingType.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Probe Loading",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[100 RPM,1500 RPM],
        Units -> RPM
      ]
    },
    {
      OptionName -> QuenchSolution,
      Default -> Null,
      Description -> "The solution used to passivate un-reacted sites after loading the immobilized species by immersion in LoadingSolution. This will reduce the probability of non-selective binding between an analyte and the bio-probe surface.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
        ObjectTypes -> {Object[Sample], Model[Sample]}
      ],
      Category -> "Probe Loading"
    },
    {
      OptionName -> QuenchTime,
      Description -> "The amount of time for which the bio-probe is immersed in QuenchSolution after being functionalized with the immobilized species. This step passivates un-reacted sites and will reduce the probability of non-selective binding between an analyte and the bio-probe surface.",
      ResolutionDescription->"QuenchTime is set to 1 Minute if Quench is selected in LoadingType.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Probe Loading",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Hour, 20 Hour],
        Units -> Alternatives[Second, Minute, Hour]
      ]
    },
    {
      OptionName -> QuenchShakeRate,
      Description -> "The speed at which the assay plate is shaken while the bio-probe is immersed in QuenchSolution after being functionalized with the immobilized species.",
      ResolutionDescription->"QuenchShakeRate is set to 1000 RPM if Quench is selected in LoadingType.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Probe Loading",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[100 RPM,1500 RPM],
        Units -> RPM
      ]
    },



    (*KINETICS ASSAY INFORMATION*)

    {
      OptionName -> KineticsReferenceType,
      Description -> "Indicates the type of non-sample solutions to be included. Select all that apply. A well containing the selected solution will be measured simultaneously during the association step. If multiple solutions are selected, one well for each solution will be included.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Kinetics Assay",
      Widget -> Widget[
        Type -> MultiSelect,
        Pattern :> DuplicateFreeListableP[Alternatives[Blank, Standard]]
      ]
    },
    {
      OptionName -> KineticsBaselineBuffer,
      Description -> "The solution in which the bio-probes are immersed prior to performing the association step in a kinetics assay. This provides a baseline of the bio-layer thickness prior to analyte association.",
      Default -> Automatic,
      ResolutionDescription->"The KineticsBaselineBuffer is set to match the DefaultBuffer if it is informed and the ExperimentType is Kinetics.",
      AllowNull -> True,
      Category -> "Kinetics Assay",
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
        ObjectTypes -> {Object[Sample], Model[Sample]}
      ]
    },
    {
      OptionName -> MeasureBaselineTime,
      Default -> Automatic,
      AllowNull -> True,
      Description -> "The amount of time for which the bio-probe is immersed in KineticsBaselineBuffer directly prior to performing MeasureAssociation.",
      ResolutionDescription->"MeasureBaselineTime is set to 30 Second if Kinetics is selected as the ExperimentType.",
      Category -> "Kinetics Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Second,20 Hour],
        Units -> Alternatives[Second, Minute, Hour]
      ]
    },
    {
      OptionName -> MeasureBaselineShakeRate,
      Description -> "The speed at which the assay plate is shaken while the bio-probe is immersed in KineticsBaselineBuffer directly prior to performing MeasureAssociation.",
      ResolutionDescription->"MeasureBaselineShakeRate is set to 1000 RPM if Kinetics is selected as the ExperimentType.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Kinetics Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[100 RPM,1500 RPM],
        Units -> RPM
      ]
    },

    {
      OptionName -> MeasureAssociationTime,
      Default -> Automatic,
      AllowNull -> True,
      Description -> "The amount of time for which the bio-probe is immersed in the sample solution to measure analyte association.",
      ResolutionDescription->"MeasureAssociationTime is set to 15 Minute if Kinetics is selected as the ExperimentType.",
      Category -> "Kinetics Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Second, 20 Hour],
        Units -> Alternatives[Second, Minute, Hour]
      ]
    },
    {
      OptionName -> MeasureAssociationThresholdCriterion,
      Default -> Automatic,
      Description -> "Indicates if the threshold condition for change in bio-layer thickness which will trigger the completion of the Association step must be met by any single well, or all of the wells measured in the step. Wells containing a secondary solution such as a Blank or Standard are automatically excluded.",
      ResolutionDescription -> "MeasureAssociationThresholdCriterion is set to All if MeasureAssociationAbsoluteThreshold or MeasureAssociationThresholdSlope is specified.",
      AllowNull -> True,
      Category -> "Kinetics Assay",
      Widget -> Widget[
        Type->Enumeration,
        Pattern:>Alternatives[All, Single]
      ]
    },
    {
      OptionName -> MeasureAssociationAbsoluteThreshold,
      Description -> "The change in bio-layer thickness that will trigger the removal of the bio-probe from the sample solution, and initiate the following assay step. This threshold can be used to prevent excessively long association steps.",
      Default -> Null,
      Category -> "Kinetics Assay",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Nanometer],
        Units -> Alternatives[Nanometer, Micrometer]
      ]
    },
    {
      OptionName -> MeasureAssociationThresholdSlope,
      Description -> "The rate of change in bio-layer thickness that will trigger the removal of the bio-probe from the sample solution, and initiate the following assay step.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Kinetics Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Nanometer/Minute],
        Units -> CompoundUnit[{1, {Millimeter, {Millimeter, Micrometer, Nanometer}}}, {-1, {Minute, {Minute, Second}}}]
      ]
    },
    {
      OptionName -> MeasureAssociationThresholdSlopeDuration,
      Description -> "The amount of time that a given rate of change in bio-layer thickness must be exceeded to will trigger the removal of the bio-probe from the sample solution, and initiate the following assay step.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Kinetics Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Second],
        Units -> Alternatives[Second, Minute]
      ]
    },
    {
      OptionName -> MeasureAssociationShakeRate,
      Description -> "The speed at which the assay plate is shaken while the bio-probe is immersed in the analyte solution.",
      ResolutionDescription->"MeasureAssociationShakeRate is set to 1000 RPM if Kinetics is selected as the ExperimentType.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Kinetics Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[100 RPM,1500 RPM],
        Units -> RPM
      ]
    },
    {
      OptionName -> KineticsDissociationBuffer,
      Description -> "The solution in which the dissociation step is performed in a Kinetics assay.",
      Default -> Automatic,
      ResolutionDescription->"The MeasureDissociationBuffer is set to match the KineticsBaselineBuffer if the ExperimentType is Kinetics.",
      AllowNull -> True,
      Category -> "Kinetics Assay",
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
        ObjectTypes -> {Object[Sample], Model[Sample]}
      ]
    },
    {
      OptionName -> MeasureDissociationTime,
      Default -> Automatic,
      Description -> "The amount of time for which the bio-probe is immersed in KineticsDissociationBuffer to measure analyte dissociation.",
      ResolutionDescription->"MeasureDissociationTime is set to 30 Minute if Kinetics is selected as the ExperimentType.",
      Category -> "Kinetics Assay",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Second, 20 Hour],
        Units -> Alternatives[Second, Minute, Hour]
      ]
    },
    {
      OptionName -> MeasureDissociationThresholdCriterion,
      Default -> Automatic,
      Description -> "Indicates if the threshold condition for change in bio-layer thickness which will trigger the completion of the dissociation step must be met by any single well, or all of the wells measured in the step.  Wells containing a secondary solution such as a Blank or Standard are automatically excluded.",
      ResolutionDescription -> "MeasureDissociationThresholdCriterion is set to All if MeasureDissociationAbsoluteThreshold or MeasureDissociationThresholdSlope is specified.",
      AllowNull -> True,
      Category -> "Kinetics Assay",
      Widget -> Widget[
        Type->Enumeration,
        Pattern:>Alternatives[All, Single]
      ]
    },
    {
      OptionName -> MeasureDissociationAbsoluteThreshold,
      Description -> "The change in bio-layer thickness that will trigger the removal of the bio-probe from the sample solution, and initiate the following assay step. This threshold can prevent excessively long dissociation steps.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Kinetics Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> LessP[0 Nanometer],
        Units -> Alternatives[Nanometer, Micrometer]
      ]
    },
    {
      OptionName -> MeasureDissociationThresholdSlope,
      Description -> "The rate of change in bio-layer thickness that will trigger the removal of the bio-probe from the sample solution, and initiate the following assay step.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Kinetics Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Nanometer/Minute],
        Units -> CompoundUnit[{1, {Millimeter, {Millimeter, Micrometer, Nanometer}}}, {-1, {Minute, {Minute, Second}}}]
      ]
    },
    {
      OptionName -> MeasureDissociationThresholdSlopeDuration,
      Description -> "The amount of time that a given rate of change in bio-layer thickness must be exceeded to will trigger the removal of the bio-probe from the sample solution, and initiate the following assay step.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Kinetics Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Second],
        Units -> Alternatives[Second, Minute]
      ]
    },
    {
      OptionName -> MeasureDissociationShakeRate,
      Description -> "The speed at which the assay plate is shaken while the bio-probe is immersed in the MeasureDissociationBuffer solution.",
      ResolutionDescription->"MeasureDissociationShakeRate is set to 1000 RPM if Kinetics is selected as the ExperimentType.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Kinetics Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[100 RPM,1500 RPM],
        Units -> RPM
      ]
    },

    (*Kinetics sample preparation*)

    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      {
        OptionName -> KineticsSampleFixedDilutions,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "The collection of dilutions that will be performed on each sample to generate dilutions for association measurement.
          If the dilutions are prepared in 250 Microliter volumes, they will be performed on the assay plate.
          Otherwise, 250 Microliters of each dilution will be transferred to the assay plate.
          For Fixed Dilutions, the SampleAmount is the volume of the sample that will be mixed with the DiluentAmount of the Diluent to create a desired concentration.",
        ResolutionDescription -> "This is automatically set Null if Kinetics is not selected in ExperimentType. If Kinetics is selected
          it is automatically set to a create a series of 8 solutions which are 250 Microliters each,
          with concentrations evenly spaced between the concentration of the sample and 10 fold dilution.
          For example, given a 100 Micromolar sample, a series of dilutions with concentrations of
           100, 89, 78, 66, 55, 44, 32, 21, 10 Micromolar would be generated.",
        AllowNull -> True,
        Category -> "Kinetics Sample Preparation",
        Widget -> Alternatives[
          "Fixed Dilution Volumes" -> Adder[
            {
              "SampleAmount" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterP[0 Microliter],
                Units -> {1, {Microliter, {Liter, Milliliter, Microliter}}}
              ],
              "DiluentAmount" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Microliter],
                Units -> {1, {Microliter, {Liter, Milliliter, Microliter}}}
              ],
              "SolutionIDs" ->Widget[Type ->String, Pattern:>_String, Size -> Word]
            }
          ],
          "Fixed Dilution Factors" -> Adder[
            {
              "Dilution Factor" -> Widget[
                Type -> Number,
                Pattern :> GreaterEqualP[1]
              ],
              "SolutionIDs" -> Widget[Type -> String, Pattern :> _String, Size -> Word]
            }
          ]
        ]
      },
      {
        OptionName -> KineticsSampleSerialDilutions,
        Default -> Null,
        AllowNull -> True,
        Description -> "The collection of dilutions that will be performed on each sample to generate dilutions for association measurement.
          If the dilutions are prepared in 250 Microliter volumes, they will be performed on the assay plate.
          Otherwise, 250 Microliters of each dilution will be transferred to the assay plate.
          For Serial Dilutions, the TransferAmount is taken out of the sample and added to a second well with the DiluentAmount of the KineticsSampleDiluent.
          It is mixed, then the TransferAmount is taken out of that well to be added to a third well. This is repeated to make samples with the specified SolutionIDs.",
        AllowNull -> True,
        Category -> "Kinetics Sample Preparation",
        Widget ->
            Alternatives[
              "Serial Dilution Volumes" -> Alternatives[
                "Constant"->{
                  "TransferAmount" -> Widget[
                    Type -> Quantity,
                    Pattern :> GreaterP[0 Microliter],
                    Units -> {1, {Microliter, {Liter, Milliliter, Microliter}}}
                  ],
                  "DiluentAmount" -> Widget[
                    Type -> Quantity,
                    Pattern :> GreaterEqualP[0 Microliter],
                    Units -> {1, {Microliter, {Liter, Milliliter, Microliter}}}
                  ],
                  "SolutionIDs" -> Adder[
                    Widget[Type ->String, Pattern :> _String, Size -> Word]
                  ]
                },

                "Variable" ->Adder[
                  {
                    "TransferAmount" -> Widget[
                      Type -> Quantity,
                      Pattern :> GreaterEqualP[0 Microliter],
                      Units -> {1, {Microliter, {Liter, Milliliter, Microliter}}}
                    ],
                    "DiluentAmount" -> Widget[
                      Type -> Quantity,
                      Pattern :> GreaterEqualP[0 Microliter],
                      Units -> {1, {Microliter, {Liter, Milliliter, Microliter}}}
                    ],
                    "SolutionID" -> Widget[Type ->String, Pattern :> _String, Size -> Word]
                  }
                ]
              ],

              "Serial Dilution Factors"->
                  Alternatives[
                    "Constant"->{
                      "Constant Dilution Factor"->Widget[
                        Type -> Number,
                        Pattern :> GreaterEqualP[2,1]
                      ],
                      "SolutionIDs" -> Adder[
                        Widget[Type ->String, Pattern:>_String, Size -> Word]
                      ]
                    },
                    "Variable"->Adder[
                      {
                        "DilutionFactor"->Widget[
                          Type -> Number,
                          Pattern :> GreaterEqualP[1, 1]
                        ],
                        "SolutionID"->Widget[Type ->String, Pattern:>_String, Size -> Word]
                      }
                    ]
                  ]

            ]
      },
      {
        OptionName -> KineticsSampleDiluent,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
          ObjectTypes -> {Object[Sample], Model[Sample]}
        ],
        Description -> "The solution that is used to dilute the samples to generate the solutions used in KineticsAssociation steps.",
        ResolutionDescription -> "If Kinetics has been selected in ExperimentType, KineticsSampleDiluent will default to DefaultBuffer.",
        Category -> "Kinetics Sample Preparation"
      }
    ],


    (*QUANTITATION ASSAY INFORMATION*)

    {
      OptionName -> QuantitationParameters,
      Description -> "A series of modifications on a basic quantitation experiment which are used inform the assay steps and plate layout. Select all that apply and populate options for the relevant solutions section. StandardCurve: Dilutions of user-specified solution (QuantitationStandard) are used to generate a calibration curve used to quantify analyte concentrations in samples. StandardWell: Simultaneously measure a well containing analyte of known concentration (QuantitationStandard) along with the unknown samples. BlankWell: Simultaneously measure a well of solution not containing the analyte (Blank solution) along with unknown samples. AmplifiedDetection: Performs quantitation measurement in DetectionSolution which amplifies the change in bio-layer thickness, yielding more sensitive detection. This solution is generally an antibody or other substrate that binds to the analyte on the probe surface, thereby increasing the bio-layer thickness CaptureAntibody: Includes a step in which the bio-probe is functionalized with a capture antibody by immersion in CaptureAntibodySolution. SecondaryAntibody: Includes a step in which the bio-probe is treated with another antibody (in SecondaryAntibodySolution) following the first treatment. EnzymeLinked: Exposes the bio-probe to EnzymeSolution for direct measurement, or prior to detection.",
      Default -> Null,
      AllowNull->True,
      Category -> "Quantitation Assay",
      Widget -> Widget[
        Type -> MultiSelect,
        Pattern :> DuplicateFreeListableP[Alternatives[StandardCurve, StandardWell, BlankWell, AmplifiedDetection, EnzymeLinked]]
      ]
    },
    {
      OptionName -> QuantitationStandard,
      Default -> Automatic,
      Description -> "Indicates a solution which is used to generate a standard curve for quantitation of the analyte concentration in the input samples.",
      ResolutionDescription -> "The QuantitionStandard will be set to the same value as the Standard if Quantitation is selected in ExperimentType and if the Standard has been user specified.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
        ObjectTypes -> {Object[Sample], Model[Sample]}
      ],
      Category -> "Quantitation Assay"
    },
    {
      OptionName->QuantitationStandardStorageCondition,
      Default->Automatic,
      Description->"Specifies non-default conditions under which the QuantitationStandard should be stored after the protocol is completed. If left unset, the QuantitationStandard will be stored according to the current StorageCondition.",
      ResolutionDescription -> "If Standard is used as the QuantitationStandard, this will be set to StandardStorageCondition.",
      AllowNull->True,
      Widget-> Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
      Category->"Post Experiment"
    },
    {
      OptionName -> QuantitationStandardWell,
      Default -> Automatic,
      Description -> "Indicates a solution which is measured in a single well in parallel with each quantitation step.",
      ResolutionDescription -> "The QuantitionStandardWell will be set to the same value as the QuantitationStandard if Quantitation is selected in ExperimentType and if the QuantitationStandard has been user specified.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
        ObjectTypes -> {Object[Sample], Model[Sample]}
      ],
      Category -> "Quantitation Assay"
    },
    {
      OptionName -> QuantitateTime,
      Default -> Automatic,
      Description -> "The amount of time for which the bio-probe is immersed in the sample solution to perform a quantitation measurement. This time will also apply to steps measuring the QuantitationStandard solutions, if requested in QuantititationParameters.",
      ResolutionDescription->"QuantitateSampleMeasurementTime is set to 5 minutes if Quantitation is selected as the ExperimentType.",
      Category -> "Quantitation Assay",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Second, 20 Hour],
        Units -> Alternatives[Second, Minute, Hour]
      ]
    },
    {
      OptionName -> QuantitateShakeRate,
      Description -> "The speed at which the assay plate is shaken while the bio-probe is immersed in the sample solution to perform a quantitation measurement.  This will also apply to steps measuring the QuantitationStandard solutions, if requested in QuantititationParameters.",
      ResolutionDescription->"QuantitateSampleMeasurementShakeRate is set to 1000 RPM if Quantitation is selected as the ExperimentType.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Quantitation Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[100 RPM,1500 RPM],
        Units -> RPM
      ]
    },
    {
      OptionName -> AmplifiedDetectionSolution,
      Default -> Null,
      Description -> "A solution containing a species which binds to the immobilized analyte on the bio-probe surface, thereby increasing the thickness of the bio-layer. This solution can improve the detection of an analyte in quantitation experiments, and is most commonly used when detecting enzymes.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
        ObjectTypes -> {Object[Sample], Model[Sample]}
      ],
      Category -> "Quantitation Assay"
    },
    {
      OptionName -> AmplifiedDetectionTime,
      Default -> Automatic,
      Description -> "The amount of time for an amplified quantitation measurement step, in which the bio-probe is immersed in the AmplifiedDetectionSolution.",
      ResolutionDescription->"AmplifiedDetectionTime is set to 5 minutes if AmplifiedDetection is selected in QuantitationParameters.",
      Category -> "Quantitation Assay",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Second, 20 Hour],
        Units -> Alternatives[Second, Minute, Hour]
      ]
    },
    {
      OptionName -> AmplifiedDetectionShakeRate,
      Description -> "The speed at which the assay plate is shaken for an amplified quantitation measurement step, in which the bio-probe is immersed in the DetectionSolution.",
      ResolutionDescription->"AmplifiedDetectionShakeRate is set to 1000 RPM if AmplifiedDetection is selected in QuantitationParameters.",
      Default -> Automatic,
      Category -> "Quantitation Assay",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[100 RPM,1500 RPM],
        Units -> RPM
      ]
    },
    {
      OptionName -> QuantitationEnzymeSolution,
      Default -> Null,
      Description -> "Indicates a solution containing enzyme used to amplify quantitation results. The probe is immersed in QuantitationEnzymeSolution after immersion in the analyte solution.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
        ObjectTypes -> {Object[Sample], Model[Sample]}
      ],
      Category -> "Quantitation Assay"
    },
    {
      OptionName->QuantitationEnzymeSolutionStorageCondition,
      Default->Null,
      Description->"Specifies non-default conditions under which the QuantitationEnzymeSolution should be stored after the protocol is completed. If left unset, the QuantitationEnzymeSolution will be stored according to the current StorageCondition.",
      AllowNull->True,
      Widget-> Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
      Category->"Post Experiment"
    },
    {
      OptionName -> QuantitationEnzymeBuffer,
      Default -> Automatic,
      Description -> "Indicates a solution used to rinse the probe between QuantitationEnzyme and Detection.",
      ResolutionDescription -> "QuantitationEnzymeBuffer will be set to DefaultBuffer if QuantitaionEnzyme is selected in QuantitationParameters.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
        ObjectTypes -> {Object[Sample], Model[Sample]}
      ],
      Category -> "Quantitation Assay"
    },
    {
      OptionName -> QuantitationEnzymeTime,
      Default -> Automatic,
      AllowNull -> True,
      Description -> "The amount of time which the bio-probe is immersed in an enzyme solution (QuantitationEnzymeSolution). This step is performed after bio-probe immersion in the sample solutions.",
      ResolutionDescription->"QuantitationEnzymeTime is set to 5 minutes if QuantitaionEnzyme is selected in QuantitationParameters.",
      Category -> "Quantitation Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Second, 20 Hour],
        Units -> Alternatives[Second, Minute, Hour]
      ]
    },
    {
      OptionName -> QuantitationEnzymeShakeRate,
      Description -> "The speed at which the assay plate is shaken while the bio-probe is immersed in an enzyme solution (QuantitationEnzymeSolution). This step is performed after bio-probe immersion in the sample solutions.",
      ResolutionDescription->"QuantitationEnzymeShakeRate is set to 1000 RPM if QuantitaionEnzyme is selected in QuantitationParameters.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Quantitation Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[100 RPM,1500 RPM],
        Units -> RPM
      ]
    },

    (*Quantitation Standard Preparation*)


    {
      OptionName -> QuantitationStandardFixedDilutions,
      Default -> Automatic,
      Description ->
          "The collection of dilutions that will be performed on the QuantitationStandard to generate a standard curve for a Quantitation experiment.
          If the dilutions are prepared in 250 Microliter volumes, they will be performed on the assay plate.
          Otherwise, 250 Microliters of each dilution will be transferred to the assay plate.
          For Fixed Dilution Volumes, the SampleAmount is the volume of the sample that will be mixed with the DiluentAmount of the Diluent to create a desired concentration.
          For Fixed Dilution Factors, an appropriate amount of sample will mixed with diluent to achieve a solution with the requested volume and concentration.
           The SolutionIDs are used to indicate a unique temporary name for each dilution that is referred to in the protocol object.",
      ResolutionDescription ->
          "This is automatically set to Null if QuantitationStandard is set to Null. In all
          other cases it is automatically set to a create a series of dilutions of the QuantitationStandard using dilution factors of 2, 4, 8, 16, 32, 64, and 128 and diluting with QuantiationDiluent.",
      AllowNull -> True,
      Category -> "Quantitation Standard Preparation",
      Widget -> Alternatives[
        "Fixed Dilution Volumes" -> Adder[
          {
            "SampleAmount" -> Widget[
              Type -> Quantity,
              Pattern :> GreaterP[0 Microliter],
              Units -> {1, {Microliter, {Liter, Milliliter, Microliter}}}
            ],
            "DiluentAmount" -> Widget[
              Type -> Quantity,
              Pattern :> GreaterP[0 Microliter],
              Units -> {1, {Microliter, {Liter, Milliliter, Microliter}}}
            ],
            "SolutionIDs" -> Widget[Type -> String, Pattern :> _String, Size -> Word]
          }
        ],
        "Fixed Dilution Factors"->Adder[
          {
            "Dilution Factors"->Widget[
              Type -> Number,
              Pattern :> GreaterEqualP[1]
            ],
            "SolutionIDs" -> Widget[Type -> String, Pattern :> _String, Size -> Word]
          }
        ]
      ]
    },
    {
      OptionName -> QuantitationStandardSerialDilutions,
      Default -> Null,
      Description ->
          "The collection of dilutions that will be performed on the QuantitationStandard to generate a standard curve for a Quantitation experiment.
          For volume based Serial Dilutions, the TransferAmount is taken out of the QuantitationStandard and added to a second well with the DiluentAmount of the QuantitationStandardDiluent.
          It is mixed, then the TransferAmount is taken out of that well to be added to a third well. This is repeated to the solutions labeled by SolutionIDs.
          For dilution factor based Serial Dilutions, the appropriate amount of solution will be added to a diluent to achieve the solutions with desired dilution factor and final volumes of > 250 uL. The SolutionIDs are used to indicate a unique temporary name for each dilution that is referred to in the protocol object.",
      AllowNull -> True,
      Category -> "Quantitation Standard Preparation",
      Widget -> Alternatives[
        "Serial Dilution Volumes" -> Alternatives[
          "Constant"->{
            "TransferAmount" -> Widget[
              Type -> Quantity,
              Pattern :> GreaterP[0 Microliter],
              Units -> {1, {Microliter, {Liter, Milliliter, Microliter}}}
            ],
            "DiluentAmount" -> Widget[
              Type -> Quantity,
              Pattern :> GreaterEqualP[0 Microliter],
              Units -> {1, {Microliter, {Liter, Milliliter, Microliter}}}
            ],
            "SolutionIDs" -> Adder[
              Widget[Type ->String, Pattern :> _String, Size -> Word]
            ]
          },

          "Variable" ->Adder[
            {
              "TransferAmount" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Microliter],
                Units -> {1, {Microliter, {Liter, Milliliter, Microliter}}}
              ],
              "DiluentAmount" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Microliter],
                Units -> {1, {Microliter, {Liter, Milliliter, Microliter}}}
              ],
              "SolutionID" -> Widget[Type ->String, Pattern :> _String, Size -> Word]
            }
          ]
        ],

        "Serial Dilution Factors"-> Alternatives[
          "Constant"->{
            "Constant Dilution Factor"->Widget[
              Type -> Number,
              Pattern :> GreaterEqualP[2,1]
            ],
            "SolutionIDs" -> Adder[
              Widget[Type ->String, Pattern :> _String, Size -> Word]
            ]
          },
          "Variable"->Adder[
            {
              "Dilution Factors"->Widget[
                Type -> Number,
                Pattern :> GreaterEqualP[1,1]
              ],
              "SolutionIDs" -> Widget[Type ->String, Pattern :> _String, Size -> Word]
            }
          ]
        ]
      ]
    },
    {
      OptionName -> QuantitationStandardDiluent,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
        ObjectTypes -> {Object[Sample], Model[Sample]}
      ],
      Description -> "The solution that is used to dilute the QuantitationStandard to generate the solutions used in the quantitation standard curve.",
      ResolutionDescription -> "If the a dilution series has been specified, QuantitationStandardDiluent will default to DefaultBuffer.",
      Category -> "Quantitation Standard Preparation"
    },


    (*EPITOPE BINNING ASSAY OPTIONS*)

    {
      OptionName -> BinningType,
      Description -> "Indicates the assay configuration for EpitopeBinning. Sandwich: The first antibody is bound to the bio-probe surface. The surface is first exposed to the target antigen (BinningAntigen), then to solutions of competing antibodies. Tandem: The target antigen species is immobilized on the bio-probe surface. The surface is then exposed to a pair of competing antibodies sequentially. Premix: An antibody is bound to the bio-probe surface. The bio-probe is then exposed to a premixed solution of antigen and competing antibody.",
      ResolutionDescription -> "If EpitopeBinning is selected in ExperimentType, BinningType will default to Sandwich, otherwise it will default to Null.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Epitope Binning Assay",
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> Alternatives[Sandwich, PreMix, Tandem]
      ]
    },
    {
      OptionName -> BinningControlWell,
      Description -> "During the Antibody loading step, one well of Blank solution will be included. This will reduce the maximum number of antibodies from 8 to 7.",
      ResolutionDescription -> "BinningControlWell defaults to True if EpitopeBinning is selected in ExperimentType, otherwise it will default to Null.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Epitope Binning Assay",
      Widget -> Widget[
        Type->Enumeration,
        Pattern:>BooleanP
      ]
    },
    {
      OptionName -> LoadAntibodyTime,
      Default -> Automatic,
      AllowNull -> True,
      Description -> "For Sandwich-type assays: The amount of time for which the bio-probe surface with is saturated with bound antibody. For Tandem-type assays: The amount of time for which the antigen coated bio-probe surface with is immersed in the first antibody solution.",
      ResolutionDescription->"LoadAntibodyTime is set to 10 minutes if EpitopeBinning is selected as the ExperimentType.",
      Category -> "Epitope Binning Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Second, 20 Hour],
        Units -> Alternatives[Second, Minute, Hour]
      ]
    },
    {
      OptionName -> LoadAntibodyThresholdCriterion,
      Default -> Automatic,
      Description -> "Indicates if the threshold condition for change in bio-layer thickness which will trigger the completion of an assay step must be met by any single well, or all of the wells measured in the step. Wells containing a secondary solution such as a Blank or Standard are automatically excluded.",
      ResolutionDescription -> "LoadAntibodyThresholdCriterion is set to All if LoadAntibodyAbsoluteThreshold or LoadAntibodyThresholdSlope is specified.",
      AllowNull -> True,
      Category -> "Epitope Binning Assay",
      Widget -> Widget[
        Type->Enumeration,
        Pattern:>Alternatives[All, Single]
      ]
    },
    {
      OptionName -> LoadAntibodyAbsoluteThreshold,
      Description -> "The change in bio-layer thickness that will trigger the removal of the bio-probe from the antibody solution, and initiate the following assay step. This threshold can be used to ensure an appropriate amount of antibody association, and prevent over-saturation of the probe surface.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Epitope Binning Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Nanometer],
        Units -> Alternatives[Nanometer, Micrometer]
      ]
    },
    {
      OptionName -> LoadAntibodyThresholdSlope,
      Description -> "The rate of change in bio-layer thickness that will trigger the removal of the bio-probe from the antibody solution, and initiate the following assay step.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Epitope Binning Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Nanometer/Minute],
        Units -> CompoundUnit[{1, {Millimeter, {Millimeter, Micrometer, Nanometer}}}, {-1, {Minute, {Minute, Second}}}]
      ]
    },
    {
      OptionName -> LoadAntibodyThresholdSlopeDuration,
      Description -> "The amount of time that a given rate of change in bio-layer thickness must be exceeded to will trigger the removal of the bio-probe from the antibody solution, and initiate the following assay step.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Epitope Binning Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Second],
        Units -> Alternatives[Second, Minute]
      ]
    },
    {
      OptionName -> LoadAntibodyShakeRate,
      Description -> "For Sandwich-type assays: The speed at which the assay plate is shaken while the bio-probe surface with is saturated with bound antibody. For Tandem-type assays: The speed at which the assay plate is shaken while the antigen coated bio-probe surface with is immersed in the first antibody solution.",
      ResolutionDescription->"LoadAntibodyShakeRate is set to 1000 RPM if EpitopeBinning is selected as the ExperimentType.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Epitope Binning Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[100 RPM,1500 RPM],
        Units -> RPM
      ]
    },
    {
      OptionName -> BinningQuenchSolution,
      Default -> Null,
      Description -> "Indicates a solution used to quench unreacted sites on the probe surface after antibody loading. Immersion of the bio-probe in this solution can help prevent non-selective binding in subsequent assay steps.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
        ObjectTypes -> {Object[Sample], Model[Sample]}
      ],
      Category -> "Epitope Binning Assay"
    },
    {
      OptionName -> BinningQuenchTime,
      Default -> Automatic,
      AllowNull -> True,
      Description -> "The amount of time for which the bio-probe is immersed in BinningQuenchSolution, which blocks unreacted sites. This option will override any assignment made in Loading Information.",
      ResolutionDescription->"BinningQuenchTime is set to 5 minutes if EpitopeBinning is selected as the ExperimentType.",
      Category -> "Epitope Binning Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Second, 20 Hour],
        Units -> Alternatives[Second, Minute, Hour]
      ]
    },
    {
      OptionName -> BinningQuenchShakeRate,
      Description -> "The speed at which the assay plate is shaken while the bio-probe is immersed in BinningQuenchSolution, which blocks unreacted sites. This option will override any assignment made in Loading Information.",
      ResolutionDescription->"BinningQuenchShakeRate is set to 1000 RPM if EpitopeBinning is selected as the ExperimentType.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Epitope Binning Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[100 RPM,1500 RPM],
        Units -> RPM
      ]
    },
    {
      OptionName -> BinningAntigen,
      Default -> Null,
      Description -> "Indicates a solution used in the Tandem and Sandwich type assays to populate the bio-probe surface with the target antigen.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
        ObjectTypes -> {Object[Sample], Model[Sample]}
      ],
      Category -> "Epitope Binning Assay"
    },
    {
      OptionName->BinningAntigenStorageCondition,
      Default->Null,
      Description->"Specifies non-default conditions under which the BinningAntigen should be stored after the protocol is completed. If left unset, the BinningAntigen will be stored according to the current StorageCondition.",
      AllowNull->True,
      Widget-> Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
      Category->"Post Experiment"
    },
    {
      OptionName -> LoadAntigenTime,
      Default -> Automatic,
      AllowNull -> True,
      Description -> "For Sandwich-type assays: The amount of time while the antibody functionalized bio-probe surface is exposed to BinningAntigen. For Tandem-type assays: The amount of time while the bio-probe surface is saturated with antigen in BinningAntigen solution.",
      ResolutionDescription->"LoadAntigenTime is set to 10 minutes if EpitopeBinning is selected as the ExperimentType.",
      Category -> "Epitope Binning Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Second, 20 Hour],
        Units -> Alternatives[Second, Minute, Hour]
      ]
    },
    {
      OptionName -> LoadAntigenThresholdCriterion,
      Default -> Automatic,
      Description -> "Indicates if the threshold condition for change in bio-layer thickness which will trigger the completion of an antigen association step must be met by any single well, or all of the wells measured in the step.  Wells containing a secondary solution such as a Blank or Standard are automatically excluded.",
      ResolutionDescription -> "LoadAntigenThresholdCriterion is set to All if LoadAntigenAbsoluteThreshold or LoadAntigenThresholdSlope is specified.",
      AllowNull -> True,
      Category -> "Epitope Binning Assay",
      Widget -> Widget[
        Type->Enumeration,
        Pattern:>Alternatives[All, Single]
      ]
    },
    {
      OptionName -> LoadAntigenAbsoluteThreshold,
      Description -> "The change in bio-layer thickness that will trigger the removal of the bio-probe from the antigen solution, and initiate the next assay step. This threshold can ensure an appropriate amount of antigen association, preventing oversaturation of the probe surface.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Epitope Binning Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Nanometer],
        Units -> Alternatives[Nanometer, Micrometer]
      ]
    },
    {
      OptionName -> LoadAntigenThresholdSlope,
      Description -> "The rate of change in bio-layer thickness that will trigger the removal of the bio-probe from the antigen solution, and initiate the next assay step.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Epitope Binning Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Nanometer/Minute],
        Units -> CompoundUnit[{1, {Millimeter, {Millimeter, Micrometer, Nanometer}}}, {-1, {Minute, {Minute, Second}}}]
      ]
    },
    {
      OptionName -> LoadAntigenThresholdSlopeDuration,
      Description -> "The amount of time that a given rate of change in bio-layer thickness must be exceeded to will trigger the removal of the bio-probe from the antibody solution, and initiate the next assay step.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Epitope Binning Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Second],
        Units -> Alternatives[Second, Minute]
      ]
    },
    {
      OptionName -> LoadAntigenShakeRate,
      Description -> "For Sandwich-type assays: The speed at which the assay plate is shaken for a step in which the antibody functionalized bio-probe surface is exposed to BinningAntigen. For Tandem-type assays: The speed at which the assay plate is shaken for a step in which the bio-probe surface is saturated with antigen in BinningAntigen.",
      ResolutionDescription->"LoadAntigenShakeRate is set to 1000 RPM if EpitopeBinning is selected as the ExperimentType.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Epitope Binning Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[100 RPM,1500 RPM],
        Units -> RPM
      ]
    },
    {
      OptionName -> CompetitionBaselineBuffer,
      Description -> "The solution in which the bio-probe is immersed prior to performing the competition step of an EpitopeBinning assay.",
      Default -> Automatic,
      ResolutionDescription->"The CompetitionBaselineBuffer is set to match the DefaultBuffer if the ExperimentType is EpitopeBinning.",
      AllowNull -> True,
      Category -> "Epitope Binning Assay",
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
        ObjectTypes -> {Object[Sample], Model[Sample]}
      ]
    },
    {
      OptionName -> CompetitionBaselineTime,
      Default -> Automatic,
      AllowNull -> True,
      Description -> "The amount of time while the bio-probe is immersed in BinningBaselineBuffer solution prior to performing the competition step of a EpitopeBinning assay.",
      ResolutionDescription->"CompetitionBaselineTime is set to 30 seconds if EpitopeBinning is selected as the ExperimentType.",
      Category -> "Epitope Binning Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Second, 20 Hour],
        Units -> Alternatives[Second, Minute, Hour]
      ]
    },
    {
      OptionName -> CompetitionBaselineShakeRate,
      Description -> "The speed at which the assay plate is shaken while the bio-probe is immersed in CompetitionBaselineBuffer solution prior to performing the competition step of a EpitopeBinning assay.",
      ResolutionDescription->"CompetitionBaselineShakeRate is set to 1000 RPM if EpitopeBinning is selected as the ExperimentType.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Epitope Binning Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[100 RPM,1500 RPM],
        Units -> RPM
      ]
    },
    {
      OptionName -> CompetitionTime,
      Default -> Automatic,
      AllowNull -> True,
      Description -> "The amount of time while the bio-probe is immersed in a competing antibody (sample) or premixed antibody/antigen solution to observe competitive binding.",
      ResolutionDescription->"CompetitionTime is set to 10 minutes if EpitopeBinning is selected as the ExperimentType.",
      Category -> "Epitope Binning Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Second, 20 Hour],
        Units -> Alternatives[Second, Minute, Hour]
      ]
    },
    {
      OptionName -> CompetitionShakeRate,
      Description -> "The speed at which the assay plate is shaken while the bio-probe is immersed in a competing antibody (sample) or premixed antibody/antigen solution to observe competitive binding.",
      ResolutionDescription->"CompetitionShakeRate is set to 1000 RPM if EpitopeBinning is selected as the ExperimentType.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Epitope Binning Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[100 RPM,1500 RPM],
        Units -> RPM
      ]
    },
    {
      OptionName -> CompetitionThresholdCriterion,
      Default -> Automatic,
      Description -> "Indicates if the threshold condition for change in bio-layer thickness which will trigger the completion of an assay step must be met by any single well, or all of the wells measured in the step.  Wells containing a secondary solution such as a Blank or Standard are automatically excluded.",
      ResolutionDescription -> "CompetitionThresholdCriterion is set to Single if CompetitionAbsoluteThreshold or CompetitionThresholdSlope is specified.",
      AllowNull -> True,
      Category -> "Epitope Binning Assay",
      Widget -> Widget[
        Type->Enumeration,
        Pattern:>Alternatives[All, Single]
      ]
    },
    {
      OptionName -> CompetitionAbsoluteThreshold,
      Description -> "The change in bio-layer thickness that will trigger the removal of the bio-probe from the antibody solution, and initiate the following assay step. This threshold can be used prevent excessively long step times.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Epitope Binning Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Nanometer],
        Units -> Alternatives[Nanometer, Micrometer]
      ]
    },
    {
      OptionName -> CompetitionThresholdSlope,
      Description -> "The rate of change in bio-layer thickness that will trigger the removal of the bio-probe from the sample solution, and initiates the following assay step. This can be used to ensure that the probe surface reaches an equilibrium condition.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Epitope Binning Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Nanometer/Minute],
        Units -> CompoundUnit[{1, {Millimeter, {Millimeter, Micrometer, Nanometer}}}, {-1, {Minute, {Minute, Second}}}]
      ]
    },
    {
      OptionName -> CompetitionThresholdSlopeDuration,
      Description -> "The amount of time that a given rate of change in bio-layer thickness must be exceeded to will trigger the removal of the bio-probe from the sample solution, and initiates the following assay step.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Epitope Binning Assay",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Second],
        Units -> Alternatives[Second, Minute]
      ]
    },
    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      {
        OptionName -> PreMixSolutions,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "The mixture of antibody solutions (the sample solutions) and antigen solution (BinningAntigen) which compose the PreMixSolutions.
          The solutions can be combined with PreMixDiluent to adjust the final concentration of the PreMixSolutions.",
        ResolutionDescription -> "This is automatically set Null if PreMix is not selected in BinningExperimentType. If PreMix is selected
          it is automatically set to mix 100 Microliters of the sample solution with 100 Microliters of the BinningAntigen.",
        AllowNull -> True,
        Category -> "Epitope Binning Assay",
        Widget -> {
          "SampleAmount" -> Widget[
            Type -> Quantity,
            Pattern :> GreaterEqualP[0 Microliter],
            Units -> {1, {Microliter, {Liter, Milliliter, Microliter}}}
          ],
          "BinningAntigenAmount" -> Widget[
            Type -> Quantity,
            Pattern :> GreaterEqualP[0 Microliter],
            Units -> {1, {Microliter, {Liter, Milliliter, Microliter}}}
          ],
          "PreMixDiluentAmount" -> Widget[
            Type -> Quantity,
            Pattern :> GreaterEqualP[0 Microliter],
            Units -> {1, {Microliter, {Liter, Milliliter, Microliter}}}
          ],
          "SolutionIDs" -> Widget[Type -> String, Pattern :> _String, Size -> Word]
        }
      }
    ],
    {
      OptionName -> PreMixDiluent,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
        ObjectTypes -> {Object[Sample], Model[Sample]}
      ],
      Description -> "The solution that is used to dilute the PreMixSolutions.",
      ResolutionDescription -> "If PreMix has been selected in BinningType, PreMixDiluent will be set to DefaultBuffer.",
      Category -> "Epitope Binning Assay"
    },



    (*ASSAY DEVELOPMENT INFORMATION*)
    {
      OptionName -> DevelopmentType,
      Description -> "Indicates which step or solution is being optimized or investigated. All assays will include an association step (in the input sample solution) and a dissociation step (in DefaultBuffer or TestBufferSolutions). ScreenLoading: Find the best loading condition or immobilized species from a list of TestLoadingSolutions. ScreenInteraction: Test interaction of pairs of immobilized and solution species using the TestInteractionSolutions. These solutions will be used in the load step, and are index matched to the sample input. ScreenBuffer: Perform measurements using a list of TestBufferSolutions. ScreenRegeneration: Perform regeneration using a series of TestRegenerationSolutions. ScreenActivation: Test activation conditions prior to a LoadSurface step, using different activation TestActivationSolutions. ScreenDetectionLimit: Perform identical measurements on increasingly dilute solutions to determine the detection limit for a given analyte.",
      ResolutionDescription -> "If AssayDevelopment is selected in ExperimentType, the DevelopmentType is set to ScreenDetectionLimit.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Assay Development",
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> Alternatives[ScreenLoading, ScreenInteraction, ScreenBuffer, ScreenRegeneration, ScreenActivation, ScreenDetectionLimit]
      ]
    },
    {
      OptionName -> DevelopmentReferenceWell,
      Description -> "Indicates if a well containing Blank, Standard or both should be measured in parallel with the samples in the developmentAssociation step.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Assay Development",
      Widget -> Widget[
        Type -> MultiSelect,
        Pattern:>DuplicateFreeListableP[Alternatives[Blank, Standard]]
      ]
    },
    {
      OptionName -> DevelopmentBaselineTime,
      Default -> Automatic,
      AllowNull -> True,
      Description -> "The amount of time a bio-probe is immersed in buffer (DefaultBuffer or TestBufferSolutions) solution to record a baseline.",
      ResolutionDescription->"DevelopmentBaselineTime is set to 30 seconds if AssayDevelopment is selected as the ExperimentType.",
      Category -> "Assay Development",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Second, 20 Hour],
        Units -> Alternatives[Second, Minute, Hour]
      ]
    },
    {
      OptionName -> DevelopmentBaselineShakeRate,
      Description -> "The speed at which the assay plate is shaken while a bio-probe is immersed in buffer (DefaultBuffer or TestBufferSolutions) solution to record a baseline.",
      ResolutionDescription->"DevelopmentBaselineShakeRate is set to 1000 RPM if AssayDevelopment is selected as the ExperimentType.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Assay Development",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[100 RPM,1500 RPM],
        Units -> RPM
      ]
    },
    {
      OptionName -> DevelopmentAssociationTime,
      Default -> Automatic,
      AllowNull -> True,
      Description -> "The amount of time which the bio-probe is immersed in sample solution to measure analyte association.",
      ResolutionDescription->"AssayDevelopmentAssociationTime is set to 5 minutes if AssayDevelopment is selected as the ExperimentType.",
      Category -> "Assay Development",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Second, 20 Hour],
        Units -> Alternatives[Second, Minute, Hour]
      ]
    },
    {
      OptionName -> DevelopmentAssociationThresholdCriterion,
      Default -> Automatic,
      AllowNull -> True,
      Description -> "Indicates if the threshold condition for change in bio-layer thickness which will trigger the completion of an association step must be met by any single well, or all of the wells measured in the step. Wells containing a secondary solution such as a Blank or Standard are automatically excluded.",
      ResolutionDescription -> "DevelopmentAssociationThresholdCriterion is set to All if DevelopmentAssociationAbsoluteThreshold or DevelopmentAssociationThresholdSlope is specified.",
      AllowNull -> True,
      Category -> "Assay Development",
      Widget -> Widget[
        Type->Enumeration,
        Pattern:>Alternatives[All, Single]
      ]
    },
    {
      OptionName -> DevelopmentAssociationAbsoluteThreshold,
      Description -> "The change in bio-layer thickness that will trigger the removal of the bio-probe from the sample solution, and initiate the next assay step. This threshold can prevent excessively long association steps.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Assay Development",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Nanometer],
        Units -> Alternatives[Nanometer, Micrometer]
      ]
    },
    {
      OptionName -> DevelopmentAssociationThresholdSlope,
      Description -> "The rate of change in bio-layer thickness that will trigger the removal of the bio-probe from the sample solution, and initiate the next assay step.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Assay Development",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Nanometer/Minute],
        Units -> CompoundUnit[{1, {Millimeter, {Millimeter, Micrometer, Nanometer}}}, {-1, {Minute, {Minute, Second}}}]
      ]
    },
    {
      OptionName -> DevelopmentAssociationThresholdSlopeDuration,
      Description -> "The amount of time that a given rate of change in bio-layer thickness must be exceeded to will trigger the removal of the bio-probe from the sample solution, and initiate the next assay step.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Assay Development",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Second],
        Units -> Alternatives[Second, Minute]
      ]
    },
    {
      OptionName -> DevelopmentAssociationShakeRate,
      Description -> "The speed at which the assay plate is shaken while the bio-probe is immersed in sample solution to measure analyte association.",
      ResolutionDescription->"AssayDevelopmentAssociationShakeRate is set to 1000 RPM if AssayDevelopment is selected as the ExperimentType.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Assay Development",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[100 RPM,1500 RPM],
        Units -> RPM
      ]
    },
    {
      OptionName -> DevelopmentDissociationTime,
      Default -> Automatic,
      AllowNull -> True,
      Description -> "The amount of time for which the bio-probe is immersed in DefaultBuffer or TestBufferSolutions during analyte dissociation.",
      ResolutionDescription->"AssayDevelopmentDissociationTime is set to 30 minutes if AssayDevelopment is selected as the ExperimentType.",
      Category -> "Assay Development",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Second, 20 Hour],
        Units -> Alternatives[Second, Minute, Hour]
      ]
    },
    {
      OptionName -> DevelopmentDissociationThresholdCriterion,
      Default -> Automatic,
      Description -> "Indicates if the threshold condition for change in bio-layer thickness which will trigger the completion of an dissociation step must be met by any single well, or all of the wells measured in the step.  Wells containing a secondary solution such as a Blank or Control are automatically excluded.",
      ResolutionDescription -> "DevelopmentDissociationThresholdCriterion is set to All if DevelopmentDissociationAbsoluteThreshold or DevelopmentDissociationThresholdSlope is specified.",
      AllowNull -> True,
      Category -> "Assay Development",
      Widget -> Widget[
        Type->Enumeration,
        Pattern:>Alternatives[All, Single]
      ]
    },
    {
      OptionName -> DevelopmentDissociationAbsoluteThreshold,
      Description -> "The change in bio-layer thickness that will trigger the removal of the bio-probe from the buffer solution, and initiate the next assay step. This threshold can be used to prevent excessively long dissociation steps.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Assay Development",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Nanometer],
        Units -> Alternatives[Nanometer, Micrometer]
      ]
    },
    {
      OptionName -> DevelopmentDissociationThresholdSlope,
      Description -> "The rate of change in bio-layer thickness that will trigger the removal of the bio-probe from the buffer solution, and initiate the next assay step.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Assay Development",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Nanometer/Minute],
        Units -> CompoundUnit[{1, {Millimeter, {Millimeter, Micrometer, Nanometer}}}, {-1, {Minute, {Minute, Second}}}]
      ]
    },
    {
      OptionName -> DevelopmentDissociationThresholdSlopeDuration,
      Description -> "The amount of time that a given rate of change in bio-layer thickness must be exceeded to will trigger the removal of the bio-probe from the buffer solution, and initiate the next assay step.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Assay Development",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Second],
        Units -> Alternatives[Second, Minute]
      ]
    },
    {
      OptionName -> DevelopmentDissociationShakeRate,
      Description -> "The speed at which the assay plate is shaken while the bio-probe is immersed in DefaultBuffer or TestBufferSolutions during analyte dissociation.",
      ResolutionDescription->"AssayDevelopmentDissociationShakeRate is set to 1000 RPM if AssayDevelopment is selected as the ExperimentType.",
      Default -> Automatic,
      AllowNull -> True,
      Category -> "Assay Development",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[100 RPM,1500 RPM],
        Units -> RPM
      ]
    },


    (*ASSAY DEVELOPMENT SOLUTIONS*)

    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      {
        OptionName -> DetectionLimitSerialDilutions,
        Default -> Automatic,
        AllowNull -> True,
        Description ->
            "The collection of dilutions that will be performed on each sample to generate dilutions to determine the limit of detection for one or more analytes.
          If the dilutions are prepared in 250 Microliter volumes, they will be performed on the assay plate.
          Otherwise, 250 Microliters of each dilution will be transferred to the assay plate.
          For Serial Dilutions, the TransferAmount is taken out of the sample and added to a second well with the DiluentAmount of the DetectionLimitDiluent.
          It is mixed, then the TransferAmount is taken out of that well to be added to a third well. This is repeated to make each of the solutions labeled by SolutionIDs.",
        ResolutionDescription ->
            "This is automatically set Null if DetectionLimit is not selected in DevelopmentType. If DetectionLimit is selected
          it is automatically set to a create a series of 6 solutions which are 250 Microliters each,
          using serial dilution of 50 Microliters of sample into 250 Microliters of DetectionLimitDiluent.",
        AllowNull -> True,
        Category -> "Assay Development Solutions",
        Widget -> Alternatives[
          "Serial Dilution Volumes" -> Alternatives[
            "Constant"->{
              "TransferAmount" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterP[0 Microliter],
                Units -> {1, {Microliter, {Liter, Milliliter, Microliter}}}
              ],
              "DiluentAmount" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Microliter],
                Units -> {1, {Microliter, {Liter, Milliliter, Microliter}}}
              ],
              "SolutionIDs" -> Adder[
                Widget[Type ->String, Pattern :> _String, Size -> Word]
              ]
            },

            "Variable" ->Adder[
              {
                "TransferAmount" -> Widget[
                  Type -> Quantity,
                  Pattern :> GreaterEqualP[0 Microliter],
                  Units -> {1, {Microliter, {Liter, Milliliter, Microliter}}}
                ],
                "DiluentAmount" -> Widget[
                  Type -> Quantity,
                  Pattern :> GreaterEqualP[0 Microliter],
                  Units -> {1, {Microliter, {Liter, Milliliter, Microliter}}}
                ],
                "SolutionID" -> Widget[Type ->String, Pattern :> _String, Size -> Word]
              }
            ]
          ],
          "Serial Dilution Factors"->
              Alternatives[
                "Constant"->{
                  "Constant Dilution Factor"->Widget[
                    Type -> Number,
                    Pattern :> GreaterEqualP[2,1]
                  ],
                  "SolutionIDs" -> Adder[
                    Widget[Type ->String, Pattern:> _String, Size -> Word]
                  ]
                },
                "Variable"->Adder[
                  {
                    "Variable Dilution Factor" -> Widget[
                      Type -> Number,
                      Pattern :> GreaterEqualP[1,1]
                    ],
                    "SolutionIDs" -> Widget[Type ->String, Pattern :> _String, Size -> Word]
                  }
                ]
              ]
        ]
      },
      {
        OptionName -> DetectionLimitFixedDilutions,
        Default -> Null,
        AllowNull -> True,
        Description -> "The collection of dilutions that will be performed on each sample to generate dilutions to determine the limit of detection for one or more analytes.
          If the dilutions are prepared in 250 Microliter volumes, they will be performed on the assay plate.
          Otherwise, 250 Microliters of each dilution will be transferred to the assay plate.
          For Fixed Dilution Volumes, the SampleAmount is the volume of the sample that will be mixed with the DiluentAmount of the DetectionLimitDiluent to create a desired concentration.
          For Fixed Dilution Factors, the appropriate amount of sample volume is mixed with diluent to create a solution with the desired dilution factor and volume.",
        AllowNull -> True,
        Category -> "Assay Development Solutions",
        Widget -> Alternatives[
          "Fixed Dilution Volumes" -> Adder[
            {
              "SampleAmount" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterP[0 Microliter],
                Units -> {1, {Microliter, {Liter, Milliliter, Microliter}}}
              ],
              "DiluentAmount" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterP[0 Microliter],
                Units -> {1, {Microliter, {Liter, Milliliter, Microliter}}}
              ],
              "SolutionIDs" -> Widget[Type ->String, Pattern:>_String, Size -> Word]
            }
          ],
          "Fixed Dilution Factors"->Adder[
            {
              "Dilution Factor" -> Widget[
                Type -> Number,
                Pattern :> GreaterEqualP[1]
              ],
              "SolutionIDs" -> Widget[Type ->String, Pattern:>_String, Size -> Word]
            }
          ]
        ]
      },
      {
        OptionName -> DetectionLimitDiluent,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
          ObjectTypes -> {Object[Sample], Model[Sample]}
        ],
        Description -> "The solution that is used to dilute the samples to generate a set of sample which can be used to establish a limit of detection for a given bio-probe/analyte pairing.",
        ResolutionDescription -> "If DetectionLimit has been selected in DevelopmentType, DetectionLimitDiluent will default to DefaultBuffer.",
        Category -> "Assay Development Solutions"
      },
      {
        OptionName -> TestInteractionSolutions,
        Description -> "The list of solutions which are used to load the bio-probe surface for pair-wise interaction screening. This list is required if ScreenInteraction is selected.",
        AllowNull -> True,
        Default -> Null,
        Category -> "Assay Development Solutions",
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
          ObjectTypes -> {Object[Sample], Model[Sample]}
        ]
      },
      {
        OptionName->TestInteractionSolutionsStorageConditions,
        Default->Null,
        Description->"Specifies non-default conditions under which the TestInteractionSolutions should be stored after the protocol is completed. If left unset, the TestInteractionSolutions will be stored according to the current StorageCondition.",
        AllowNull->True,
        Widget-> Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
        Category->"Post Experiment"
      }
    ],
    {
      OptionName -> TestBufferSolutions,
      Description -> "The list of solutions to be used as buffers. This list is required if ScreenBuffer is selected.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Assay Development Solutions",
      Widget -> Adder[
        Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
          ObjectTypes -> {Object[Sample], Model[Sample]}
        ]
      ]
    },
    {
      OptionName -> TestRegenerationSolutions,
      Description -> "The list of solutions to be used to return the probe to a measurement-ready condition. This list is required if ScreenRegeneration is selected.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Assay Development Solutions",
      Widget -> Adder[
        Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
          ObjectTypes -> {Object[Sample], Model[Sample]}
        ]
      ]
    },
    {
      OptionName -> TestLoadingSolutions,
      Description -> "The list of solutions in which the bio-probe will be immersed to load the immobilized species. This list is required if ScreenLoading is selected.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Assay Development Solutions",
      Widget -> Adder[
        Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
          ObjectTypes -> {Object[Sample], Model[Sample]}
        ]
      ]
    },
    {
      OptionName->TestLoadingSolutionsStorageConditions,
      Default->Null,
      Description->"Specifies non-default conditions under which the TestLoadingSolutions should be stored after the protocol is completed. If left unset, the TestLoadingSolutions will be stored according to the current StorageCondition.",
      AllowNull->True,
      Widget-> Adder[
        Widget[
          Type->Enumeration,
          Pattern:>SampleStorageTypeP|Disposal
        ]
      ],
      Category->"Post Experiment"
    },
    {
      OptionName -> TestActivationSolutions,
      Description -> "The list of solutions in which the bio-probe will be immersed in prior to loading the immobilized species. This list is required if ScreenActivation is selected.",
      Default -> Null,
      AllowNull -> True,
      Category -> "Assay Development Solutions",
      Widget -> Adder[
        Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
          ObjectTypes -> {Object[Sample], Model[Sample]}
        ]
      ]
    },

    (* --- PRIMITIVE DEFINITIONS --- *)


    {
      OptionName->AssaySequencePrimitives,
      Default -> Automatic,
      AllowNull->True,
      Widget->
          Adder[
            Widget[
              Type->Primitive,
              Pattern:>ValidBLIPrimitiveP,
              PrimitiveTypes->{MeasureBaseline,Equilibrate,ActivateSurface,LoadSurface,Quantitate,Quench,Regenerate,Neutralize,Wash,MeasureAssociation,MeasureDissociation},
              PrimitiveKeyValuePairs->{
                MeasureBaseline-> {
                  Buffers->Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}], ObjectTypes -> {Object[Sample], Model[Sample]}]],
                  Time->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour],Units->Alternatives[Second,Minute,Hour]],
                  ShakeRate->Widget[Type->Quantity,Pattern:>RangeP[100 RPM, 1500 RPM], Units->RPM]
                },
                Equilibrate-> {
                  Buffers->Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}], ObjectTypes -> {Object[Sample], Model[Sample]}]],
                  Time->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour],Units->Alternatives[Second,Minute,Hour]],
                  ShakeRate->Widget[Type->Quantity,Pattern:>RangeP[100 RPM, 1500 RPM], Units->RPM]
                },
                Wash-> {
                  Buffers->Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}], ObjectTypes -> {Object[Sample], Model[Sample]}]],
                  Time->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour],Units->Alternatives[Second,Minute,Hour]],
                  ShakeRate->Widget[Type->Quantity,Pattern:>RangeP[100 RPM, 1500 RPM], Units->RPM]
                },
                ActivateSurface->{
                  ActivationSolutions->Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}], ObjectTypes -> {Object[Sample], Model[Sample]}]],
                  Controls->Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]]],
                  Time->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour],Units->Alternatives[Second,Minute,Hour]],
                  ShakeRate->Widget[Type->Quantity,Pattern:>RangeP[100 RPM, 1500 RPM], Units->RPM]
                },
                LoadSurface->{
                  LoadingSolutions->Alternatives[
                    Adder[
                      Alternatives[
                        "Existing Object"->Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}], ObjectTypes -> {Object[Sample], Model[Sample]}],
                        "Planned Object"->Widget[Type->String, Pattern:>_String, Size -> Word]
                      ]
                    ],
                    "Samples to Load"-> Widget[Type->Enumeration,Pattern:>Alternatives[Samples]]
                  ],
                  Controls->Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}], ObjectTypes -> {Object[Sample], Model[Sample]}]],
                  ShakeRate->Widget[Type->Quantity,Pattern:>RangeP[100 RPM, 1500 RPM], Units->RPM],
                  Time->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour],Units->Alternatives[Second,Minute,Hour]],
                  ThresholdCriterion->Widget[Type->Enumeration,Pattern:>Alternatives[Single, All]],
                  AbsoluteThreshold->Widget[Type->Quantity,Pattern:>GreaterP[0*Nanometer],Units->Alternatives[Nanometer,Micrometer]],
                  ThresholdSlope->Widget[Type->Quantity, Pattern:>GreaterP[0*Nanometer/Minute],Units -> CompoundUnit[{1, {Nanometer, {Millimeter, Micrometer, Nanometer}}}, {-1, {Minute, {Minute, Second}}}]],
                  ThresholdSlopeDuration->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour], Units->Alternatives[Second,Minute,Hour],PatternTooltip->"The amount of time for which the change in bio-layer thickness over time must be below the designated ThresholdRate."]
                },
                Quench->{
                  QuenchSolutions->Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}], ObjectTypes -> {Object[Sample], Model[Sample]}]],
                  Controls->Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}], ObjectTypes -> {Object[Sample], Model[Sample]}]],
                  Time->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour],Units->Alternatives[Second,Minute,Hour]],
                  ShakeRate->Widget[Type->Quantity,Pattern:>RangeP[100 RPM, 1500 RPM], Units->RPM]
                },
                MeasureAssociation->{
                  Analytes->Alternatives[
                    Adder[
                      Alternatives[
                        "Existing Object"->Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}], ObjectTypes -> {Object[Sample], Model[Sample]}],
                        "Planned Object"->Widget[Type->String, Pattern:>_String, Size -> Word]
                      ]
                    ],
                    "Samples to Measure"-> Widget[Type->Enumeration,Pattern:>Alternatives[Samples]]
                  ],
                  Controls->Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}], ObjectTypes -> {Object[Sample], Model[Sample]}]],
                  ShakeRate->Widget[Type->Quantity,Pattern:>RangeP[100 RPM, 1500 RPM], Units->RPM],
                  Time->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour],Units->Alternatives[Second,Minute,Hour]],
                  ThresholdCriterion->Widget[Type->Enumeration,Pattern:>Alternatives[Single, All]],
                  AbsoluteThreshold->Widget[Type->Quantity,Pattern:>GreaterP[0*Nanometer],Units->Alternatives[Nanometer,Micrometer]],
                  ThresholdSlope->Widget[Type->Quantity, Pattern:>GreaterP[0*Nanometer/Minute],Units -> CompoundUnit[{1, {Nanometer, {Millimeter, Micrometer, Nanometer}}}, {-1, {Minute, {Minute, Second}}}]],
                  ThresholdSlopeDuration->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour], Units->Alternatives[Second,Minute,Hour],PatternTooltip->"The amount of time for which the change in bio-layer thickness over time must be below the designated ThresholdRate."]
                },
                MeasureDissociation->{
                  Buffers-> Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}], ObjectTypes -> {Object[Sample], Model[Sample]}]],
                  Controls->Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}], ObjectTypes -> {Object[Sample], Model[Sample]}]],
                  ShakeRate->Widget[Type->Quantity,Pattern:>RangeP[100 RPM, 1500 RPM], Units->RPM],
                  Time->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour],Units->Alternatives[Second,Minute,Hour]],
                  ThresholdCriterion->Widget[Type->Enumeration,Pattern:>Alternatives[Single, All]],
                  AbsoluteThreshold->Widget[Type->Quantity,Pattern:>GreaterP[0*Nanometer],Units->Alternatives[Nanometer,Micrometer]],
                  ThresholdSlope->Widget[Type->Quantity, Pattern:>GreaterP[0*Nanometer/Minute],Units -> CompoundUnit[{1, {Nanometer, {Millimeter, Micrometer, Nanometer}}}, {-1, {Minute, {Minute, Second}}}]],
                  ThresholdSlopeDuration->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour], Units->Alternatives[Second,Minute,Hour],PatternTooltip->"The amount of time for which the change in bio-layer thickness over time must be below the designated ThresholdRate."]
                },
                Quantitate->{
                  Analytes->Alternatives[
                    Adder[
                      Alternatives[
                        "Existing Object"->Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}], ObjectTypes -> {Object[Sample], Model[Sample]}],
                        "Planned Object"->Widget[Type->String, Pattern:>_String, Size -> Word]
                      ]
                    ],
                    "Solution Type"-> Widget[Type->Enumeration,Pattern:>Alternatives[Samples]]
                  ],
                  Controls->Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}], ObjectTypes -> {Object[Sample], Model[Sample]}]],
                  ShakeRate->Widget[Type->Quantity,Pattern:>RangeP[100 RPM, 1500 RPM], Units->RPM],
                  Time->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour],Units->Alternatives[Second,Minute,Hour]]
                },
                Regenerate->{
                  RegenerationSolutions-> Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}], ObjectTypes -> {Object[Sample], Model[Sample]}]],
                  ShakeRate->Widget[Type->Quantity,Pattern:>RangeP[100 RPM, 1500 RPM], Units->RPM],
                  Time->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour],Units->Alternatives[Second,Minute,Hour]]
                },
                Neutralize->{
                  NeutralizationSolutions-> Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}], ObjectTypes -> {Object[Sample], Model[Sample]}]],
                  Time->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour],Units->Alternatives[Second,Minute,Hour]],
                  ShakeRate->Widget[Type->Quantity,Pattern:>RangeP[100 RPM, 1500 RPM], Units->RPM]
                }
              }
            ]
          ],
      Description->"The sequence of assay steps which will apply to each input sample. This sequence will be repeated the necessary number of times to perform the requested experiments, which the exception of Activation/Loading/Quench sequences, which will not be repeated if Regenerate steps are included. Analytes/Solution/Buffers: The solution(s) required for the assay step. Controls: Solutions (usually a blank or control) which will occupy one well in the assay plate, and are measured in parallel with the primary solution. Time: The amount of time for which the probe is immersed in the solution, if a threshold condition is not met, this time will limit the step length. Threshold: Select between Absolute (based on the total change in bio-layer thickness) and Slope (based on the rate of change in the bio-layer thickness). AbsoluteThreshold: The change in bio-layer thickness which will trigger the next assay step to begin. This can be used to ensure an appropriate amount of association to the probe surface. ThresholdType: Indicates if the threshold conditions must be met by any single well or all of the wells containing the primary solution. ThresholdSlope: The change in bio-layer thickness over time. ThresholdSlopeDuration: The amount of time for which the change in bio layer thickness over time must be less than that the ThresholdSlope to trigger the next step. ShakeRate: The rate at which the assay plate is shaken during this step.",
      ResolutionDescription->"The order, type, and contents of the primitives are determined from the options. For example, setting options ExperimentType -> Kinetics, and LoadingType -> Loading would generate AssaySequencePrimitives of {Equilibrate,Load,Baseline,MeasureAssociation,MeasureDissociation}, with the solution, step times, thresholds, and shake-rate as specified in the options.",
      Category->"Assay Primitives"
    },
    {
      OptionName->ExpandedAssaySequencePrimitives,
      Default -> Automatic,
      AllowNull->False,
      Widget->
          Adder[
            Adder[
              Widget[
                Type->Primitive,
                Pattern:>ValidBLIPrimitiveP,
                PrimitiveTypes->{MeasureBaseline,Equilibrate,ActivateSurface,LoadSurface,Quantitate,Quench,Regenerate,Neutralize,Wash,MeasureAssociation,MeasureDissociation},
                PrimitiveKeyValuePairs->{
                  MeasureBaseline-> {
                    Buffers->Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]]],
                    Time->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour],Units->Alternatives[Second,Minute,Hour]],
                    ShakeRate->Widget[Type->Quantity,Pattern:>RangeP[100 RPM, 1500 RPM], Units->RPM]
                  },
                  Equilibrate-> {
                    Buffers->Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]]],
                    Time->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour],Units->Alternatives[Second,Minute,Hour]],
                    ShakeRate->Widget[Type->Quantity,Pattern:>RangeP[100 RPM, 1500 RPM], Units->RPM]
                  },
                  Wash-> {
                    Buffers->Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]]],
                    Time->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour],Units->Alternatives[Second,Minute,Hour]],
                    ShakeRate->Widget[Type->Quantity,Pattern:>RangeP[100 RPM, 1500 RPM], Units->RPM]
                  },
                  ActivateSurface->{
                    ActivationSolutions->Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]]],
                    Controls->Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]]],
                    Time->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour],Units->Alternatives[Second,Minute,Hour]],
                    ShakeRate->Widget[Type->Quantity,Pattern:>RangeP[100 RPM, 1500 RPM], Units->RPM]
                  },
                  LoadSurface->{
                    LoadingSolutions->
                        Adder[
                          Alternatives[
                            "Existing Object"->Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]],
                            "Planned Object"->Widget[Type->String, Pattern:>_String, Size -> Word]
                          ]
                        ],
                    Controls->Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]]],
                    ShakeRate->Widget[Type->Quantity,Pattern:>RangeP[100 RPM, 1500 RPM], Units->RPM],
                    Time->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour],Units->Alternatives[Second,Minute,Hour]],
                    ThresholdCriterion->Widget[Type->Enumeration,Pattern:>Alternatives[Single, All]],
                    AbsoluteThreshold->Widget[Type->Quantity,Pattern:>GreaterP[0*Nanometer],Units->Alternatives[Nanometer,Micrometer]],
                    ThresholdSlope->Widget[Type->Quantity, Pattern:>GreaterP[0*Nanometer/Minute],Units -> CompoundUnit[{1, {Nanometer, {Millimeter, Micrometer, Nanometer}}}, {-1, {Minute, {Minute, Second}}}]],
                    ThresholdSlopeDuration->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour], Units->Alternatives[Second,Minute,Hour],PatternTooltip->"The amount of time for which the change in bio-layer thickness over time must be below the designated ThresholdRate."]
                  },
                  Quench->{
                    QuenchSolutions->Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]]],
                    Controls->Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]]],
                    Time->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour],Units->Alternatives[Second,Minute,Hour]],
                    ShakeRate->Widget[Type->Quantity,Pattern:>RangeP[100 RPM, 1500 RPM], Units->RPM]
                  },
                  MeasureAssociation->{
                    Analytes->
                        Adder[
                          Alternatives[
                            "Existing Object"->Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]],
                            "Planned Object"->Widget[Type->String, Pattern:>_String, Size -> Word]
                          ]
                        ],
                    Controls->Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]]],
                    ShakeRate->Widget[Type->Quantity,Pattern:>RangeP[100 RPM, 1500 RPM], Units->RPM],
                    Time->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour],Units->Alternatives[Second,Minute,Hour]],
                    ThresholdCriterion->Widget[Type->Enumeration,Pattern:>Alternatives[Single, All]],
                    AbsoluteThreshold->Widget[Type->Quantity,Pattern:>GreaterP[0*Nanometer],Units->Alternatives[Nanometer,Micrometer]],
                    ThresholdSlope->Widget[Type->Quantity, Pattern:>GreaterP[0*Nanometer/Minute],Units -> CompoundUnit[{1, {Nanometer, {Millimeter, Micrometer, Nanometer}}}, {-1, {Minute, {Minute, Second}}}]],
                    ThresholdSlopeDuration->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour], Units->Alternatives[Second,Minute,Hour],PatternTooltip->"The amount of time for which the change in bio-layer thickness over time must be below the designated ThresholdRate."]
                  },
                  MeasureDissociation->{
                    Buffers-> Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]]],
                    Controls->Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]]],
                    ShakeRate->Widget[Type->Quantity,Pattern:>RangeP[100 RPM, 1500 RPM], Units->RPM],
                    Time->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour],Units->Alternatives[Second,Minute,Hour]],
                    ThresholdCriterion->Widget[Type->Enumeration,Pattern:>Alternatives[Single, All]],
                    AbsoluteThreshold->Widget[Type->Quantity,Pattern:>GreaterP[0*Nanometer],Units->Alternatives[Nanometer,Micrometer]],
                    ThresholdSlope->Widget[Type->Quantity, Pattern:>GreaterP[0*Nanometer/Minute],Units -> CompoundUnit[{1, {Nanometer, {Millimeter, Micrometer, Nanometer}}}, {-1, {Minute, {Minute, Second}}}]],
                    ThresholdSlopeDuration->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour], Units->Alternatives[Second,Minute,Hour],PatternTooltip->"The amount of time for which the change in bio-layer thickness over time must be below the designated ThresholdRate."]
                  },
                  Quantitate->{
                    Analytes->
                        Adder[
                          Alternatives[
                            "Existing Object"->Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]],
                            "Planned Object"->Widget[Type->String, Pattern:>_String, Size -> Word]
                          ]
                        ],
                    Controls->Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]]],
                    ShakeRate->Widget[Type->Quantity,Pattern:>RangeP[100 RPM, 1500 RPM], Units->RPM],
                    Time->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour],Units->Alternatives[Second,Minute,Hour]]
                  },
                  Regenerate->{
                    RegenerationSolutions-> Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]]],
                    ShakeRate->Widget[Type->Quantity,Pattern:>RangeP[100 RPM, 1500 RPM], Units->RPM],
                    Time->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour],Units->Alternatives[Second,Minute,Hour]]
                  },
                  Neutralize->{
                    NeutralizationSolutions-> Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]]],
                    Time->Widget[Type->Quantity,Pattern:>RangeP[0 Hour,20 Hour],Units->Alternatives[Second,Minute,Hour]],
                    ShakeRate->Widget[Type->Quantity,Pattern:>RangeP[100 RPM, 1500 RPM], Units->RPM]
                  }
                }
              ]
            ]
          ],
      Description->"The exact sequence of assay steps which will be performed for this bio-layer interferometry experiment, grouped by steps that will be performed with the same probe.",
      ResolutionDescription->"The ExpandedAssaySequencePrimitives are based on the AssaySequencePrimitives as defined directly by the user or by user input options.",
      Category->"Assay Primitives"
    },
    {
      OptionName -> RepeatedSequence,
      Default -> Automatic,
      AllowNull -> True,
      Description -> "The sequence of steps that are repeated by each bio-probe when regeneration is requested. For example, if the AssaySequencePrimitives -> {Load, Quantitate, Regenerate}, RepeatedSequence -> {Load, Quantitate, Regenerate} would return the probe to its original state, while RepeatedSequence -> {Quantitate, Regenerate} would return the surface as functionalized in the Load step.",
      ResolutionDescription -> "RepeatedSequence resolves to the subset of AssaySequencePrimitives names which occur for each sample following the initial measurement. RepeatedSequence resolves to Null unless there is a Regenerate step in AssaySequencePrimitives",
      Widget -> Adder[
        Widget[
          Type -> Enumeration,
          Pattern :> Alternatives[BLIPrimitiveNameP]
        ]
      ],
      Category -> "Assay Primitives"
    },
    ModifyOptions[
      ModelInputOptions,
      PreparedModelAmount,
      {
        ResolutionDescription -> "Automatically set to 40 Milliliter."
      }
    ],
    ModifyOptions[
      ModelInputOptions,
      PreparedModelContainer,
      {
        ResolutionDescription -> "If PreparedModelAmount is set to All and the input model has a product associated with both Amount and DefaultContainerModel populated, automatically set to the DefaultContainerModel value in the product. Otherwise, automatically set to Model[Container, Vessel, \"50mL Tube\"]."
      }
    ],
    SimulationOption,
    NonBiologyFuntopiaSharedOptions,
    SamplesInStorageOption
  }
];

(* ::Subsubsection::Closed:: *)
(*ExperimentBioLayerInterferometry Messages*)

(* --- Invalid input --- *)

Warning::BLIPrimitiveValueInstrumentPrecision = "The value `1` for field `2` in the `3` primitive has been rounded to match the instrument precision.";
Warning::BLIInstrumentPrecision = "The value `2` in the field `1` has been rounded to match instrument precision.";
Error::OptionsWithSolidObjects = "Options `1` contain the following models or objects which are not liquid: `2`. Use preparatory primitives to make a solution of the desired compound.";
Error::InvalidSolidInput = "The following input samples are solids: `1`. This experiment requires liquid samples which can be prepared through the preparatory primitives option.";
Error::BLIBinningTooManySamples = "There are too many samples specified for the desired EpitopeBinning assay. The total number of input samples and blanks must be 8 or less. Consider a 7x7 format or setting BinningControlWell -> False (not recommended).";

(* --- Conflicting options --- *)
Error::BLIConflictingQuantitationStandardDilutions = "Both QuantitationStandardSerialDilutions and QuantitationStandardFixedDilutions were specified and are in conflict. Please specify only one Dilution option. ";
Error::BLIUnspecifiedQuantitationStandard = "If QuantitationParameters includes StandardWell or StandardCurve, the QuantitationStandard must be informed, or set to Automatic when Standard is informed.";
Warning::BLIActivateWithoutLoad = "The Activate step is generally selected along with a Load step. Select Load in LoadingType if you wish to load the probe surface, and populate the other required parameters.";
Warning::BLIQuenchWithoutLoad = "The Quench step is generally selected along with a Load step. Select Load in LoadingType if you wish to load the probe surface, and populate the other required parameters.";
Error::BLISetLoadingType = "The following option values will not be used unless LoadingType includes `1`: `2`.";
Warning::BLIRegenerationNotSpecified = "For the option RegenerationType, PreCondition must be set along with any or all of the following: Neutralize, Wash, Regenerate.";
Warning::UnusedBLIRegenerationOptions = "The following options are only used when RegenerationType includes Regenerate: `1`.";
Warning::UnusedBLINeutralizeOptions = "The following options are only used when RegenerationType includes Neutralize: `1`.";
Warning::UnusedBLIWashOptions = "The following options are only used when RegenerationType includes Wash: `1`.";
Warning::UnneededBLIProbeRegeneration = "Only one measurement step is performed, so there is no need to regenerate the probe.";
Warning::UnusedBLIEquilibrateOptions = "The following options are only used if Equilibrate -> True: `1`. Change the value of Equilibrate to True or Automatic if and equilibration step is required.";
Warning::UnusedBLIProbeEquilibrationOptions = "The following options are only used if ProbeRackEquilibration -> True: `1`. Change the value of ProbeRackEquilibration to True or reset these options to Automatic or Null.";
Warning::MissingBLIProbeEquilibrationOptions = "When ProbeRackEquilibration -> True, the following options must be set to Automatic or a non Null value: `1`.";
Warning::BLIConflictingStartDelayOptions = "The options `1` are in conflict. If a time is specified for the start delay, also specify if the plate should be shaken during this time.";
Warning::BLIUnusedAmplifiedDetectionOptions = "The following options are only used if AmplifiedDetection is selected in QuantitationParameters: `1`.";
Warning::BLIUnusedQuantitationEnzymeOptions = "The following options are only used if EnzymeLinked is selected in QuantitationParameters: `1`.";
Warning::BLIUnusedQuantitationStandardWellOptions = "The following options are only used if StandardWell is selected in QuantitationParameters: `1`.";
Warning::BLIUnusedQuantitationStandardOptions = "The following options are only used if StandardWell or StandardCurve is selected in QuantitationParameters: `1`.";
Error::BLIUnusedStandardCurveOptions = "The following options are only used if StandardCurve is selected in QuantitationParameters: `1`.";
Error::BLIQuantitationParametersRequiredTogether = "When EnzymeLinked is specified in QuantitaitonParameters, AmplifiedDetection must also be specified.";
Error::InvalidResolvedBLIPrimitives = "Resolution of the ExpandedAssaySequencePrimitives yields invalid primitive(s): `1`. Inspect the primitive to determine the cause of the error if no other messages appear. Missing (Time, ShakeRate) or conflicting (ThresholdSlope, ThresholdSlopeDuration, AbsoluteThreshold, ThresholdCriterion) keys and total quantity of solutions greater than 8 are likely sources of this error.";
Warning::UnusedBLIStandard = "The value of Standard has been overridden by QuantitationStandard. If a more complicated assay is desired, consider using the AssaySequencePrimitives or ExpandedAssaySequencePrimitives options.";
Error::UnspecifiedBLIBinningType = "If EpitopeBinning is selected in ExperimentType, the BinningType must be set to Automatic or a non Null value.";
Error::BLIMissingRequestedStandard = "If a standard is requested in the option `1`, it must be specified using the Standard option.";
Warning::BLIUnusedBlank = "Blank was specified but not used. Specify change the value of `1` for the Blank solution to be measured in parallel with the samples.";
Warning::BLIUnusedStandard = "Standard was specified but not used. Specify Standard in `1` for the Standard solution to be measured in parallel with the samples.";
Error::BLIUnusedBinningQuenchOptions = "If BinningQuenchTime and BinningQuenchShakeRate are specified, BinningQuenchSolution must also be included for a quench step to occur after antibody loading.";
Error::BLIUnusedPreMixOptions = "The following options are incompatible with the value of BinningType: `1`. Set BinningType -> PreMix or change these options to Automatic or Null.";
Error::BLIMissingTestSolutions = "The AssayDevelopment type `1` requires the option `2`. Please provide solutions to screen using this option.";
Error::BLIOptionMissingForScreening = "For DevelopmentType -> `1` , the option `2` must include `3`.";
Error::BLIUnusedDevelopmentTypeSpecificOptions = "The option(s) `1` are not used when DevelopmentType -> `2`. Please set these options to Null or Automatic if applicable.";
Warning::BLIProbeApplicationMismatch = "The BioProbeType (`1`) is intended for ExperimentType -> `2`, and may not be suitable for `3`. Validate your assay to confirm that the probe functions properly for this application if you are unsure. ";
Warning::BLIProbeRegeneration = "The BioProbeType (`1`) may not be suitable for regeneration for ExperimentType -> `2`. Validate that the probe can be regenerated for `2` if you are unsure.";

(* --- Assay Setup section --- *)
Warning::BLIPlateCoverRecommended = "The total predicted assay time of `1` exceeds 4 hours. It is recommended that PlateCover be set to True to avoid excessive evaporation, leading to changes in solution concentration during the assay.";
Warning::BLIPlateCoverNotRecommended = "The total predicted assay time of `1` does not exceed 4 hours. A plate cover is generally not required in this case.";
Warning::NoBLIProbeEquilibration = "The probes are not equilibrated prior to use, which will likely adversely impact their performance. Set ProbeRackEquilibration to True, to equilibrate probes in the probe rack. The lack of a probe rack buffer can lead to mis-calibration of the bio-probes which may result in loss of data or inaccurate results.";
Warning::InsufficientBLIStartDelay = "The current StartDelay `1` may be insufficient for the assay plate to reach the desired temperature `2`. For a non-ambient temperature a 10 minute StartDelay is recommended.";
Error::BLIStartDelayMismatch = "The StartDelay value must be longer the value of ProbeRackEquilibrationTime. Adjust one of these options or set them to automatic.";
Error::BLIRepeatedSequenceMismatch = "The RepeatedSequence `1` does not match any part of the AssaySequencePrimitives. Verify the RepeatedSequence or set RepeatedSequence to Automatic. ";
Error::BLIForbiddenRepeatedSequence = "The RepeatedSequence option can only be informed when the user provides AssaySequencePrimitives.";

(* --- Plate and Probe Errors --- *)
Error::BLIPlateCapacityOverload = "The number of unique well sets (`1`) exceeds the 12 rows of the 96-well assay plate. If a common solution set can be shared between steps, indicate this by setting ReuseSolution, otherwise reduce the number of samples or dilutions.";
Error::TooManyRequestedBLIProbes = "The requested assay uses `1` sets of probes, which exceeds the maximum value of 12. If the probe type can be regenerated to conduct multiple measurements, consider setting the appropriate Regeneration parameters.";

(* --- New Primitive Checks --- *)
Error::BLIMissingTime = "The required options `1` have invalid values of `2`. Populate these options with valid values or set it to Automatic (if possible).";
Error::MissingBLIShakeRate = "The required options `1` have invalid values of `2`. Populate these options with valid values or set it to Automatic (if possible).";
Error::BLIMissingSolution = "The required options `1` must be populated by specifying the option value or setting it to Automatic (if possible).";
Error::BLIInvalidSolution = "The specified solutions `1` do not match any defined solution names.";
Error::BLIConflictingThresholdParameters = "The options `1` are in conflict. ThresholdSlope/ThresholdSlopeDuration and AbsoluteThreshold parameters cannot both be set.";
Error::BLIMissingThresholdParameters = "The options `1` are both required. ThresholdSlope and ThresholdSlopeDuration options must be set together.";
Error::BLIMissingThresholdCriterion = "The option `1` is required when specifying a threshold. Specify this option or set it to Automatic (if possible).";
Error::BLITooManySolutions = "Too many samples/blanks have been specified for a given assay step.  Reduce the number of objects or dilutions specified in `1`.";
Error::BLIInvalidSolutionKey = "The primitive(s) `2` have indicated solutions which are invalid: `1`. Check that the value is not Samples, and that all names match a specified dilution.";
Error::BLIPrimitiveResolutionFailed = "The AssaySequencePrimitives and ExpandedAssaySequencePrimitives could not be resolved. Please check to make sure that all error have been resolved.";
Error::UserBLIPrimitivesInvalidSolutionKey = "The primitive `1` at position `2` in ExpandedAssaySequencePrimitives has an invalid solution key value of `3`. Check that any named solutions in this primitive match with designated dilution names.";
Error::UserBLIPrimitivesTooManySolutions = "The primitive `1` at position `2` in the ExpandedAssaySequencePrimitives has too many solutions to fit into a single plate column after expansion. Please reduce the number of solutions, or manually add another set of primitives to this option.";

(* --- Dilutions Map Thread Errors --- *)
Error::BLIMissingKineticsDilutions = "There are no dilutions (KineticsSampleSerialDilutions or KineticsSampleFixedDilutions) specified for the following samples: `1`.";
Error::BLIMissingKineticsDiluent = "KineticsSampleDiluent is requested but not specified for the following samples: `1`.";
Error::BLIConflictingKineticsDilutions = "Both KineticsSampleSerialDilutions and KineticsSampleFixedDilutions are specified for the following samples: `1`. Please specify only one Dilution option.";
Error::BLIMissingDevelopmentDilutions = "There are no dilutions (DetectionLimitSerialDilutions or DetectionLimitFixedDilutions) specified for the following samples: `1`.";
Error::BLIMissingDevelopmentDiluents = "DetectionLimitDiluent is requested but not specified for the following samples: `1`.";
Error::BLIConflictingDevelopmentDilutions = "Both DetectionLimitSerialDilutions and DetectionLimitFixedDilutions are specified for the following samples: `1`. Please specify only one Dilution option.";
Error::BLIMissingPreMixSolution = "PreMixSolutions must be specified for the following samples: `1`.";
Error::BLITooLargePreMixSolutions = "PreMixSolutions is greater than 220 Microliter for the following sample: `1`. Specify the PreMixSolutions such the total volume is less than 220 Microliter.";
Error::BLIMissingPreMixDiluent = "PreMixDiluent was requested , but not specified for the following samples: `1`.";
Error::BLIDuplicateDilutionNames = "The names `1` are assigned to multiple solutions in the options `2`.";
Error::BLIMissingPreMixSolutions = "There are no PreMix solutions specified for the following samples: `1`. Please set PreMixSolutions to automatic or make sure it has a valid value for each sample.";

(* --- dilution volume check errors --- *)
Error::BLILowTransferVolume = "The requested `1` requires transfer amount `2` which is less 1 Microliter.";
Error::BLITooLargeDilutionVolume = "The requested dilutions include solutions with volumes greater than 2 Milliliters for `1`.";
Error::BLITooManyDilutions = "`2` dilutions have been specified using the options (`1`) for this experiment. Limit the number of specified dilutions to 96.";
Warning::BLIInsufficientPreMixVolume = "The PreMixSolutions are less than 250 Microliter for the following samples: `1`. The recommended range is 250 Microliter to 220 Microliter.";
Error::BLIInsufficientDevelopmentFixedDilutionsTransferVolume = "The DetectionLimitFixedDilutions are less than 210 Microliter for the following samples: `1`. The recommended range is 210 Microliter to 250 Microliter.";
Error::BLIInsufficientDevelopmentSerialDilutionsTransferVolume = "The DetectionLimitSerialDilutions are less than 210 Microliter for the following samples: `1`. The recommended range is 210 Microliter to 250 Microliter.";
Warning::BLIInsufficientDevelopmentFixedDilutionsVolume = "The DetectionLimitFixedDilutions require transfer volumes below the achievable volume of 1 Microliter for the following samples: `1`.";
Warning::BLIInsufficientDevelopmentSerialDilutionsVolume = "The DetectionLimitSerialDilutions require transfer volumes below the achievable volume of 1 Microliter for the following samples: `1`.";
Warning::BLIInsufficientKineticsSerialDilutionsVolume = "The KineticsSampleSerialDilutions are less than 210 Microliter for the following samples: `1`. The recommended range is 210 Microliter to 250 Microliter.";
Warning::BLIInsufficientKineticsFixedDilutionsVolume  = "The KineticsSampleFixedDilutions are less than 210 Microliter for the following samples: `1`. The recommended range is 210 Microliter to 250 Microliter.";
Error::BLIInsufficientKineticsSerialDilutionsTransferVolume = "The KineticsSampleSerialDilutions require transfer volumes below the achievable volume of 1 Microliter for the following samples: `1`.";
Error::BLIInsufficientKineticsFixedDilutionsTransferVolume = "The KineticsSampleFixedDilutions require transfer volumes below the achievable volume of 1 Microliter for the following samples: `1`.";
Error::BLIInsufficientQuantitationDilutionsTransferVolume = "The option `1` require transfer volumes below the achievable volume of 1 Microliter. Consider adding intermediate dilutions or using serial instead of fixed dilutions.";
Error::BLIStandardTooLargeDilutionVolume = "The option `1` specifies larger dilution volumes than can be executed in this experiment.";
Error::BLIInsufficientQuantitationStandardDilutionVolume = "The option `1` creates dilutions with volumes less than 210 Microliter. A possible reason for this is serial dilutions, for which volume is transferred out to form the next dilution.";

(* --- Unused Options Warnings --- *)
Warning::UnusedOptionValuesBLIPrimitiveInput = "The following options were specified, but are overridden by the user input AssaySequencePrimitives: `1`.";
Error::UnusedBLIOptionValuesKinetics = "The following options were specified, but are incompatible with ExperimentType -> Kinetics: `1`";
Error::UnusedBLIOptionValuesQuantitation = "The following options were specified, but are incompatible with ExperimentType -> Quantitation: `1`";
Error::UnusedBLIOptionValuesEpitopeBinning = "The following options were specified, but are incompatible with ExperimentType -> EpitopeBinning: `1`";
Error::UnusedBLIOptionValuesAssayDevelopment = "The following options were specified, but are incompatible with ExperimentType -> AssayDevelopment: `1`";
Warning::BLIPrimitiveOverride = "User input AssaySequencePrimitives or ExpandedAssaySequencePrimitives will override other options, except ExperimentType and those related to dilutions such as KineticsSampleSerialDilutions.";

(* -- Storage Condition Errors/Warnings -- *)
Error::BLIQuantitationEnzymeStorageConditionMismatch="If QuantitationEnzymeSolution is Null, QuantitationEnzymeSolutionStorageCondition cannot be specified. Please change the value of either or both option(s).";
Error::BLILoadSolutionStorageConditionMismatch="If LoadSolution is Null, LoadSolutionStorageCondition cannot be specified. Please change the value of either or both option(s).";
Error::BLIStandardStorageConditionMismatch="If Standard is Null, StandardStorageCondition cannot be specified. Please change the value of either or both option(s).";
Error::BLIQuantitationStandardStorageConditionMismatch="If QuantitationStandard is Null, QuantitationStandardStorageCondition cannot be specified. Please change the value of either or both option(s).";
Error::BLIBinningAntigenStorageConditionMismatch="If BinningAntigen is Null, BinningAntigenStorageCondition cannot be specified. Please change the value of either or both option(s).";
Error::BLITestInteractionSolutionsStorageConditionMismatch="If TestInteractionSolutions is Null, TestInteractionSolutionsStorageCondition cannot be specified. Please change the value of either or both option(s).";
Error::BLITestLoadingSolutionsStorageConditionMismatch="If TestLoadingSolutions is Null, TestLoadingSolutionsStorageCondition cannot be specified. Please change the value of either or both option(s).";
Error::BLITestLoadingSolutionsStorageConditionLengthMismatch = "TestLoadingSolutions and TestLoadingSolutionsStorageConditions are not of the same length. Please change one or both of these options.";



(* ::Subsection::Closed:: *)
(*ExperimentBioLayerInterferometry*)

ExperimentBioLayerInterferometry[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[ExperimentBioLayerInterferometry]]:=Module[
  {listedOptions, listedSamples, outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
    safeOps,safeOpsTests,validLengths,validLengthTests, updatedSimulation,
    templatedOptions,templateTests,inheritedOptions,expandedSafeOps,cacheBall,resolvedOptionsResult,
    resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,resourcePackets,resourcePacketTests,allDownloadValues,
    (* variables from safeOps and download *)
    upload, confirm, canaryBranch, fastTrack, parentProt, inheritedCache, samplePreparationPackets, sampleModelPreparationPackets, messages,
    allObjectProbes, allModelProbes, allModelSamplesFromOptions, allObjectSamplesFromOptions, allInstrumentObjectsFromOptions, allObjectsFromOptions, allInstrumentModelsFromOptions,
    containerPreparationPackets, liquidHandlerContainers, containerModelPreparationPackets, hamiltonCompatibleContainerDownloadFields, modelPreparationPackets,
    mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,safeOpsNamed
  },

  (* Make sure we're working with a list of options *)
  {listedSamples, listedOptions}=removeLinks[ToList[mySamples], ToList[myOptions]];

  (* Determine the requested return value from the function *)
  outputSpecification=Quiet[OptionValue[Output]];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];
  messages = !gatherTests;

  (* Simulate our sample preparation. *)
  validSamplePreparationResult=Check[
    (* Simulate sample preparation. *)
    {mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
      ExperimentBioLayerInterferometry,
      listedSamples,
      listedOptions
    ],
    $Failed,
    {Download::ObjectDoesNotExist,Error::MissingDefineNames}
  ];

  (* If we are given an invalid define name, return early. *)
  If[MatchQ[validSamplePreparationResult,$Failed],
    (* Return early. *)
    (* Note: We've already thrown a message above in simulateSamplePreparationPacketsNew. *)
    Return[$Failed]
  ];

  (* Call SafeOptions to make sure all options match pattern *)
  {safeOpsNamed,safeOpsTests}=If[gatherTests,
    SafeOptions[ExperimentBioLayerInterferometry,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
    {SafeOptions[ExperimentBioLayerInterferometry,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
  ];

  {mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

  (* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
  If[MatchQ[safeOps,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> safeOpsTests,
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (* Call ValidInputLengthsQ to make sure all options are the right length *)
  {validLengths,validLengthTests}=If[gatherTests,
    ValidInputLengthsQ[ExperimentBioLayerInterferometry,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
    {ValidInputLengthsQ[ExperimentBioLayerInterferometry,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
  ];



  (* If option lengths are invalid return $Failed (or the tests up to this point) *)
  If[!validLengths,
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests,validLengthTests],
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (* get assorted hidden options *)
  {upload, confirm, canaryBranch, fastTrack, parentProt, inheritedCache} = Lookup[safeOps, {Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Cache}];


  (* Use any template options to get values for options not specified in myOptions *)
  {templatedOptions,templateTests}=If[gatherTests,
    ApplyTemplateOptions[ExperimentBioLayerInterferometry,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples,Output->{Result,Tests}],
    {ApplyTemplateOptions[ExperimentBioLayerInterferometry,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples],Null}
  ];

  (* Return early if the template cannot be used - will only occur if the template object does not exist. *)
  If[MatchQ[templatedOptions,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests,validLengthTests,templateTests],
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (* Replace our safe options with our inherited options from our template. *)
  inheritedOptions=ReplaceRule[safeOps,templatedOptions];

  (* Expand index-matching options *)
  expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentBioLayerInterferometry,{ToList[mySamplesWithPreparedSamples]},inheritedOptions]];

  (* ----------------------------------------------------------------------------------- *)
  (* -- DOWNLOAD THE INFORMATION FOR THE OPTION RESOLVER AND RESOURCE PACKET FUNCTION -- *)
  (* ----------------------------------------------------------------------------------- *)

  (* Combine our downloaded and simulated cache. *)
  (* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
  samplePreparationPackets = Packet[SamplePreparationCacheFields[Object[Sample], Format->Sequence], Volume, IncompatibleMaterials, LiquidHandlerIncompatible, Well, Composition];
  sampleModelPreparationPackets = Packet[Model[Flatten[{Deprecated, Products, UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, IncompatibleMaterials, SamplePreparationCacheFields[Model[Sample]]}]]];
  modelPreparationPackets = Packet[Deprecated, Products, UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, IncompatibleMaterials, SamplePreparationCacheFields[Model[Sample], Format -> Sequence]];
  containerPreparationPackets = Packet[Container[Flatten[{SamplePreparationCacheFields[Object[Container]], Model}]]];
  containerModelPreparationPackets = Packet[Container[Model[DeleteDuplicates[Flatten[
    {
      Object, DefaultStorageCondition, MaxVolume, Positions, WellColor, PlateColor, NumberOfWells,
      FlangeHeight, RecommendedFillVolume, Columns, Rows, Dimensions,
      SamplePreparationCacheFields[Model[Container]]
    }
  ]]]]];
  hamiltonCompatibleContainerDownloadFields = Packet[
    Sequence@@(DeleteDuplicates[Flatten[
    {
      Object, DefaultStorageCondition, MaxVolume, Positions, WellColor, PlateColor, NumberOfWells,
      FlangeHeight, RecommendedFillVolume, Columns, Rows, Dimensions,
      SamplePreparationCacheFields[Model[Container]]
    }
  ]])
  ];

  (* look up the values of the options and select ones that are objects/models *)
  allObjectsFromOptions = DeleteDuplicates[Cases[Values[KeyDrop[expandedSafeOps, Cache]], ObjectP[], Infinity]];

  (* break into their types *)
  allInstrumentObjectsFromOptions = Cases[allObjectsFromOptions, ObjectP[Object[Instrument,BioLayerInterferometer]]];
  allInstrumentModelsFromOptions = Cases[allObjectsFromOptions, ObjectP[Model[Instrument,BioLayerInterferometer]]];
  (* download the object here since there will be a packet also from simulation *)
  allObjectSamplesFromOptions = DeleteCases[Download[Cases[allObjectsFromOptions, ObjectP[Object[Sample]]], Object], Alternatives@@ToList[mySamplesWithPreparedSamples[Object]]];
  allModelSamplesFromOptions = DeleteCases[Download[Cases[allObjectsFromOptions, ObjectP[Model[Sample]]], Object], Alternatives@@ToList[Download[mySamplesWithPreparedSamples, Model[Object], Cache -> inheritedCache, Simulation -> updatedSimulation]]];
  allModelProbes = Cases[allObjectsFromOptions, ObjectP[Model[Item, BLIProbe]]];
  allObjectProbes = Cases[allObjectsFromOptions, ObjectP[Object[Item, BLIProbe]]];

  (* Get all containers which can fit on the liquid handler - many of our resources are in one of these containers *)
  (* hamiltoneAliquotContainers will add 0.5mL tube in 2 mL skirt to the beginning of the list + the other standard containers (Engine uses the first requested container if it has to transfer or make a stock solution) *)
  bliLiquidHandlerContainers[]:=(bliLiquidHandlerContainers[]=Experiment`Private`hamiltonAliquotContainers["Memoization"]);
  liquidHandlerContainers = bliLiquidHandlerContainers[];

  (* Note that the download from allObjectSamplesFromOptions/allModelSamplesFromOptions may need to change to match changes in aliquotting etc. *)
  (* make the big download call *)
  allDownloadValues = Quiet[
    Flatten[
      Download[
        {
          ToList[mySamplesWithPreparedSamples],
          allInstrumentObjectsFromOptions,
          allInstrumentModelsFromOptions,
          allObjectSamplesFromOptions,
          allModelSamplesFromOptions,
          allModelProbes,
          allObjectProbes(*,
          liquidHandlerContainers*)
        },
        {
          {
            samplePreparationPackets,
            sampleModelPreparationPackets,
            containerPreparationPackets,
            containerModelPreparationPackets
          },
          {
            Packet[Object,Name,Status,Model],
            Packet[Model[{Object,Name, WettedMaterials}]]
          },
          {
            Packet[Object, Name, WettedMaterials]
          },
          {
            samplePreparationPackets,
            sampleModelPreparationPackets
          },
          {
            modelPreparationPackets
          },
          {
            Packet[RecommendedApplication, QuantitationRegeneration, KineticsRegeneration]
          },
          {
            Packet[Model[{RecommendedApplication, QuantitationRegeneration, KineticsRegeneration}]]
          }(*,
          {
            hamiltonCompatibleContainerDownloadFields
          }*)
        },
        Cache -> Cases[inheritedCache, PacketP[]],
        Simulation -> updatedSimulation,
        Date->Now
      ]
    ],
    Download::FieldDoesntExist];

  cacheBall=Cases[FlattenCachePackets[{inheritedCache, allDownloadValues}], PacketP[]];

  (* -------------------------- *)
  (* --- RESOLVE THE OPTIONS ---*)
  (* -------------------------- *)

  (* Build the resolved options *)
  resolvedOptionsResult=If[gatherTests,

    (* We are gathering tests. This silences any messages being thrown. *)
    {resolvedOptions, resolvedOptionsTests} = resolveExperimentBioLayerInterferometryOptions[listedSamples, expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> {Result, Tests}];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
      {resolvedOptions,resolvedOptionsTests},
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {resolvedOptions, resolvedOptionsTests} = {resolveExperimentBioLayerInterferometryOptions[listedSamples, expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation], {}},
      $Failed,
      {Error::InvalidInput,Error::InvalidOption}
    ]
  ];

  (* ---------------------------- *)
  (* -- PREPARE OPTIONS OUTPUT -- *)
  (* ---------------------------- *)

  (* Collapse the resolved options *)
  collapsedResolvedOptions = CollapseIndexMatchedOptions[
    ExperimentBioLayerInterferometry,
    resolvedOptions,
    Ignore->ToList[myOptions],
    Messages->False
  ];

  (* If option resolution failed, return early. *)
  If[MatchQ[resolvedOptionsResult,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
      Options->RemoveHiddenOptions[ExperimentBioLayerInterferometry,collapsedResolvedOptions],
      Preview->Null
    }]
  ];

  (* ---------------------------- *)
  (* -- BUILD RESOURCE PACKETS -- *)
  (* ---------------------------- *)

  {resourcePackets,resourcePacketTests} = If[gatherTests,
    bioLayerInterferometryResourcePackets[ToList[mySamplesWithPreparedSamples], expandedSafeOps, resolvedOptions, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> {Result, Tests}],
    {bioLayerInterferometryResourcePackets[ToList[mySamplesWithPreparedSamples], expandedSafeOps, resolvedOptions, Cache -> cacheBall, Simulation -> updatedSimulation], {}}
  ];

  (* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
  If[!MemberQ[output,Result],
    Return[outputSpecification/.{
      Result -> Null,
      Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
      Options -> RemoveHiddenOptions[ExperimentBioLayerInterferometry,collapsedResolvedOptions],
      Preview -> Null
    }]
  ];

  (* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
  protocolObject = If[!MatchQ[resourcePackets,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
    UploadProtocol[
      resourcePackets,
      Upload->Lookup[safeOps,Upload],
      Confirm->Lookup[safeOps,Confirm],
      CanaryBranch->Lookup[safeOps,CanaryBranch],
      ParentProtocol->Lookup[safeOps,ParentProtocol],
      Priority->Lookup[safeOps,Priority],
      StartDate->Lookup[safeOps,StartDate],
      HoldOrder->Lookup[safeOps,HoldOrder],
      QueuePosition->Lookup[safeOps,QueuePosition],
      ConstellationMessage->Object[Protocol,BioLayerInterferometry],
      Cache -> inheritedCache,
      Simulation -> updatedSimulation
    ],
    $Failed
  ];

  (* Return requested output *)
  outputSpecification/.{
    Result -> protocolObject,
    Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests, resourcePacketTests}],
    Options -> RemoveHiddenOptions[ExperimentBioLayerInterferometry,collapsedResolvedOptions],
    Preview -> Null
  }
];

(* -------------------------- *)
(* --- CONTAINER OVERLOAD --- *)
(* -------------------------- *)

ExperimentBioLayerInterferometry[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample], Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
  {listedOptions,listedContainers, outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
    containerToSampleResult,containerToSampleOutput,samples,sampleOptions,containerToSampleTests, updatedSimulation},

  (* Make sure we're working with a list of options *)
  {listedContainers, listedOptions}=removeLinks[ToList[myContainers], ToList[myOptions]];

  (* Determine the requested return value from the function *)
  outputSpecification=Quiet[OptionValue[Output]];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];

  (* First, simulate our sample preparation. *)
  validSamplePreparationResult=Check[
    (* Simulate sample preparation. *)
    {mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation} = simulateSamplePreparationPacketsNew[
      ExperimentBioLayerInterferometry,
      listedContainers,
      listedOptions,
      DefaultPreparedModelAmount -> 40 Milliliter,
      DefaultPreparedModelContainer -> Model[Container, Vessel, "50mL Tube"]
    ],
    $Failed,
    {Download::ObjectDoesNotExist,Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
  ];

  (* If we are given an invalid define name, return early. *)
  If[MatchQ[validSamplePreparationResult,$Failed],
    (* Return early. *)
    (* Note: We've already thrown a message above in simulateSamplePreparationPacketsNew. *)
    Return[$Failed]
  ];

  (* Convert our given containers into samples and sample index-matched options. *)
  containerToSampleResult=If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {containerToSampleOutput,containerToSampleTests}=containerToSampleOptions[
      ExperimentBioLayerInterferometry,
      mySamplesWithPreparedSamples,
      myOptionsWithPreparedSamples,
      Output->{Result,Tests},
      Simulation -> updatedSimulation
    ];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
      Null,
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      containerToSampleOutput=containerToSampleOptions[
        ExperimentBioLayerInterferometry,
        mySamplesWithPreparedSamples,
        myOptionsWithPreparedSamples,
        Output->Result,
        Simulation -> updatedSimulation
      ],
      $Failed,
      {Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
    ]
  ];

  (* If we were given an empty container, return early. *)
  If[MatchQ[containerToSampleResult,$Failed],
    (* containerToSampleOptions failed - return $Failed *)
    outputSpecification/.{
      Result -> $Failed,
      Tests -> containerToSampleTests,
      Options -> $Failed,
      Preview -> Null
    },

    (* Split up our containerToSample result into the samples and sampleOptions. *)
    {samples, sampleOptions} = containerToSampleOutput;

    (* Call our main function with our samples and converted options. *)
    ExperimentBioLayerInterferometry[samples, ReplaceRule[sampleOptions, {Simulation -> updatedSimulation}]]
  ]
];



(* ::Subsection::Closed:: *)
(* resolveExperimentBioLayerInterferometryOptions *)

DefineOptions[
  resolveExperimentBioLayerInterferometryOptions,
  Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveExperimentBioLayerInterferometryOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentBioLayerInterferometryOptions]]:=Module[
  {outputSpecification,output,gatherTests,simulation,samplePrepOptions,bliOptions,simulatedSamples,resolvedSamplePrepOptions,updatedSimulation,samplePrepTests, bliOptionsAssociation,
    bliTests, invalidInputs,invalidOptions,targetContainers,resolvedAliquotOptions,aliquotTests, fullBLIOptionsAssociation, resolvedOptions, mapThreadFriendlyOptions, resolvedPostProcessingOptions,
    (* download related variables *)
    inheritedCache, sampleObjectPrepFields, sampleModelPrepFields, samplePackets, sampleModelPackets, newCache, allDownloadValues,
    probePacket, allObjectPackets, allModelPackets,allModelFields, allObjectFields, allModelOptions, allObjectOptions, probeFields,
    (* invalid input tests *)
    discardedSamplePackets, discardedInvalidInputs, solidStateInvalidInputs,discardedTest, messages, validNameQ, nameInvalidOptions,
    validNameTest, solidSamplePackets, solidSampleTest,
    (* defaulted options *)
    instrument, experimentType, bioProbeType, numberOfRepeats, safeNumberOfRepeats, plateCover,
    temperature, recoupSample, saveAssayPlate, probeRackEquilibration, defaultBuffer, reuseSolution, standard, dilutionNumberOfMixes, dilutionMixRate, regenerationType, loadingType, loadSolution,
    loadAbsoluteThreshold, loadThresholdSlope, loadThresholdSlopeDuration, activateSolution, quenchSolution, kineticsReferenceType, measureAssociationAbsoluteThreshold, measureAssociationThresholdSlope,
    measureAssociationThresholdSlopeDuration, measureDissociationAbsoluteThreshold, measureDissociationThresholdSlope, measureDissociationThresholdSlopeDuration, kineticsSampleSerialDilutions,
    quantitationParameters, amplifiedDetectionSolution, quantitationEnzymeSolution, quantitationStandardSerialDilutions, loadAntibodyAbsoluteThreshold, loadAntibodyThresholdSlope,
    loadAntibodyThresholdSlopeDuration, binningQuenchSolution, binningAntigen, loadAntigenAbsoluteThreshold, loadAntigenThresholdSlope, loadAntigenThresholdSlopeDuration, competitionAbsoluteThreshold,
    competitionThresholdSlope, competitionThresholdSlopeDuration, developmentReferenceWell, developmentAssociationAbsoluteThreshold, developmentAssociationThresholdSlope,
    developmentAssociationThresholdSlopeDuration, developmentDissociationAbsoluteThreshold, developmentDissociationThresholdSlope, developmentDissociationThresholdSlopeDuration, detectionLimitFixedDilutions,
    testInteractionSolutions, testBufferSolutions, testRegenerationSolutions, testLoadingSolutions, testActivationSolutions,
    (* automatic options *)
    acquisitionRate, probeRackEquilibrationTime, probeRackEquilibrationBuffer, startDelay, startDelayShake, equilibrate, equilibrateTime, equilibrateBuffer, equilibrateShakeRate, blank, dilutionMixVolume, regenerationSolution,
    regenerationCycles, regenerationTime, regenerationShakeRate, neutralizationSolution, neutralizationTime, neutralizationShakeRate, washSolution, washTime, washShakeRate, loadTime, loadThresholdCriterion, loadShakeRate, activateTime, activateShakeRate, quenchTime, quenchShakeRate, kineticsBaselineBuffer, measureBaselineTime, measureBaselineShakeRate, measureAssociationTime, measureAssociationThresholdCriterion, measureAssociationShakeRate,
    kineticsDissociationBuffer, measureDissociationTime, measureDissociationThresholdCriterion, measureDissociationShakeRate, kineticsSampleFixedDilutions, kineticsSampleDiluent, quantitationStandard, quantitationStandardWell, quantitateTime, quantitateShakeRate, amplifiedDetectionTime,
    amplifiedDetectionShakeRate, quantitationEnzymeBuffer, quantitationEnzymeTime, quantitationEnzymeShakeRate, quantitationStandardFixedDilutions, quantitationStandardDiluent, binningType, binningControlWell, loadAntibodyTime, loadAntibodyThresholdCriterion, loadAntibodyShakeRate, binningQuenchTime, binningQuenchShakeRate, loadAntigenTime, loadAntigenThresholdCriterion, loadAntigenShakeRate, competitionBaselineBuffer, competitionBaselineTime,
    competitionBaselineShakeRate, competitionTime, competitionShakeRate, competitionThresholdCriterion, preMixSolutions, preMixDiluent, developmentType, developmentBaselineTime, developmentBaselineShakeRate, developmentAssociationTime, developmentAssociationThresholdCriterion, developmentAssociationShakeRate, developmentDissociationTime, developmentDissociationThresholdCriterion,
    developmentDissociationShakeRate, detectionLimitSerialDilutions, detectionLimitDiluent, assaySequencePrimitives, resolvedPlateCover, controlWellSolution,
    (* option rounding *)
    roundingBLITests, roundedAssaySequencePrimitives, roundedPrimitiveValues, safeRoundedPrimitiveValues,
    (* storage condition variables *)
    standardStorageCondition, quantitationStandardStorageCondition, quantitationEnzymeSolutionStorageCondition,
    binningAntigenStorageCondition, loadSolutionStorageCondition, testInteractionSolutionsStorageConditions,
    testLoadingSolutionsStorageConditions, resolvedQuantitationStandardStorageCondition, samplesInStorageCondition,
    validSamplesInStorageBool, validSamplesInStorageConditionBools,
    (* experiment specific helper variables *)
    resolvedKineticsOptions, assayDevelopmentKeys, resolvedAssayDevelopmentOptions, resolvedEpitopeBinningOptions,
    epitopeBinningKeys, resolvedQuantitationOptions, quantitationKeys, kineticsKeys, kineticsDefaults, kineticsDefaultRelation, resolvedKineticsParameters, resolvedQuantitationParameters, resolvedEpitopeBinningParameters,
    resolvedAssayDevelopmentParameters, assayDevelopmentRules,epitopeBinningRules, quantitationRules, kineticsRules, unusedOptionValuesKinetics,
    unusedOptionValuesQuantitation, unusedOptionValuesEpitopeBinning, unusedOptionValuesAssayDevelopment,
    (* solution names *)
    fixedQuantitationStandardNames, serialQuantitationStandardNames, allSolutionNames, DuplicateDilutionNames, duplicateNameLocations,
    (* map thread error tracking variables *)
    missingKineticsDilutions, missingKineticsDiluents, invalidKineticsDilutions, conflictingKineticsDilutions, missingDevelopmentDilutions,
    missingDevelopmentDiluents, invalidDevelopmentDilutions, conflictingDevelopmentDilutions, missingPreMixSolutions, missingPreMixDiluents, invalidPreMixDilutions, kineticsSampleDilutions,
    samplePacketsWithMissingKineticsDilution, samplePacketsWithMissingKineticsDiluent, samplePacketsWithConflictingKineticsDilution, samplePacketsWithMissingDevelopmentDilution,
    samplePacketsWithMissingDevelopmentDiluent, samplePacketsWithConflictingDevelopmentDilution, samplePacketsWithMissingPreMixSolution, samplePacketsWithMissingPreMixDiluent,
    missingPreMixDiluentsTests, missingPreMixSolutionsTests, conflictingDevelopmentDilutionsTests, missingDevelopmentDiluentsTests, missingDevelopmentDilutionsTests,
    conflictingKineticsDilutionsTests, missingKineticsDiluentTests, missingKineticsDilutionsTests,
    insufficientPreMixVolumes, insufficientKineticsSerialDilutionsVolumes, insufficientKineticsFixedDilutionsVolumes,
    insufficientDetectionLimitSerialDilutionsVolumes, insufficientDetectionLimitFixedDilutionsVolumes, insufficientKineticsSerialTransferVolumes, insufficientKineticsFixedTransferVolumes,
    insufficientDetectionLimitSerialTransferVolumes, insufficientDetectionLimitFixedTransferVolumes,  tooLargeKineticsSerialDilutionsVolumes, tooLargeDetectionLimitSerialDilutionsVolumes,
    tooLargeDetectionLimitFixedDilutionsVolumes, tooLargeKineticsFixedDilutionsVolumes, conflictingQuantitationStandardDilutionTests, conflictingQuantitationStandardDilutionsBool,
    tooLargeQuantitationStandardFixedDilutionsBool, tooLargeQuantitationStandardSerialDilutionsBool,
    (*map thread temp variables*)
    tempKineticsSampleDiluent, tempKineticsSampleSerialDilutions, tempKineticsSampleFixedDilutions, tempKineticsSampleDilutions,
    tempDetectionLimitDiluent, tempDetectionLimitSerialDilutions, tempDetectionLimitFixedDilutions, tempDetectionLimitDilutions,
    tempPreMixSolutions, tempPreMixDiluent, tempMissingKineticsDilutions, tempMissingKineticsDiluents, tempInvalidKineticsDilutions,
    tempConflictingKineticsDilutions, tempMissingDevelopmentDilutions, tempMissingDevelopmentDiluents, tempInvalidDevelopmentDilutions,
    tempConflictingDevelopmentDilutions, tempMissingPreMixSolutions, tempMissingPreMixDiluents, tempInvalidPreMixDilutions, tempTooLargePreMixSolutions,
    tempInsufficientPreMixVolume, tempInsufficientKineticsSerialDilutionsVolume, tempInsufficientKineticsFixedDilutionsVolume, tempInsufficientDetectionLimitSerialDilutionsVolume, tempInsufficientDetectionLimitFixedDilutionsVolume,
    tempInsufficientKineticsSerialTransferVolume, tempInsufficientKineticsFixedTransferVolume, tempInsufficientDetectionLimitSerialTransferVolume, tempInsufficientDetectionLimitFixedTransferVolume,
    mergedMapThreadRules, mapThreadRules, tempTooLargeKineticsSerialDilutionsVolume, tempTooLargeDetectionLimitSerialDilutionsVolume,
    tempTooLargeDetectionLimitFixedDilutionsVolume, tempTooLargeKineticsFixedDilutionsVolume,
    (*special solution variables*)
    expandedTestInteractionSolutions, expandedSamples, safeTestInteractionSolutions, detectionLimitDilutions, measuredSamples, fixedKineticsDilutionsNames,
    serialKineticsDilutionsNames, fixedDetectionLimitDilutionsNames, serialDetectionLimitDilutionsNames, preMixSolutionNames, labeledPreMixSolutionNames,
    labeledSerialDetectionLimitDilutionsNames, labeledFixedDetectionLimitDilutionsNames, labeledSerialKineticsDilutionsNames, labeledFixedKineticsDilutionsNames,
    (*primitive resolution from options*)
    sampleExpandedResolvedPrimitives, flattenedExpandedResolvedPrimitives,
    resolvedPrimitiveKeys, resolvedRequiredOptions, resolvedRequiredOptionValues,
    (* incomplete primitive resolution *)
    resolvedExpandedAssaySequencePrimitives, resolvedRepeatedSequence, preResolvedRepeatedSequence, resolvedExpandedSolutions,
    (* general primitive variable *)
    patternSafeAssaySequencePrimitives,anyPrimitiveErrorBools, initialSequence, initialPrimitives, resolvedAssaySequencePrimitives, plateLayout, solutionUses, probeCount, primitiveMasterAssociation, unusedOptionValuesPrimitiveInput,
    (* primitive error tracking variables and tests *)
    tooSmallQuantitationStandardSerialDilutionTransferBool, tooSmallQuantitationStandardFixedDilutionTransferBool,tooSmallQuantitationStandardFixedDilutionsBool,
    tooSmallQuantitationStandardSerialDilutionsBool, badPrimitivesFromOptions, tooLargePreMixSolutionsTests, tooLargeDetectionLimitFixedDilutionsTests, tooLargeKineticsFixedDilutionsTests, tooLargeKineticsSerialDilutionsTests,
    tooLargeDetectionLimitSerialDilutionsTests,  duplicateDilutionIDTest,
    primitivesWithConflictingThresholdParameter, primitivesWithMissingThresholdCriterion,
    primitivesWithMissingThresholdParameters,
    missingTimesTests, missingShakeRatesTests, missingSolutionsTests, conflictingThresholdParameterTests, missingThresholdCriteriaTests, missingThresholdParametersTests, invalidSolutionsTests,
    primitiveHeads, allPrimitiveHeads, allSolutionSets, allBlankSets, badSolutionSets, allStepTimes, overloadedAssayStepTests, totalAssayTime, primitivesWithTooManySolutions, badSolutions,
    equilibrationTests, forbiddenRepeatedSequenceTests, tooManyDilutionsTest, badRepeatedSequence, badRepeatedSequenceTests, tooManyRequestedProbesTests, plateCapacityOverloadTests, missingSolutionKey, primitiveOverrideTests,
    invalidExpandedAssaySequence, badPrimitiveSolutionTests, badSolutionKeys, primitivesWithInvalidSolutionKeys,  badTimeBools,
    invalidTimeValues, timeOptions, badShakeRateBools, invalidShakeRateValues, shakeRateOptions, tooManySolutionsBools, invalidSolutionNameBools,
    invalidSolutionNames, invalidSolutionValues, badSolutionOptions, conflictingThresholdParameterBools, conflictingThresholdParameterOptions, missingThresholdParameterBools,
    missingThresholdParameterOptions, missingThresholdCriterionBools, missingThresholdCriterionOptions, missingSolutionBools,invalidPrimitivesFromOptions,
    badSolutionsIndex, optionsForPrimitivesWithMissingSolutions, primitivesWithMissingSolutions, optionsForPrimitivesWithInvalidSolutionNames, invalidSolutionNameValues,
    primitivesWithInvalidSolutionNames, optionsForPrimitivesWithTooManySolutions, pickedMissingThresholdParameterOptions, pickedMissingThresholdCriterionOptions,
    pickedConflictingThresholdOptions, badShakeRateOptions, badShakeRateValues, primitivesWithBadShakeRate, unusedRegenerationOptions, unusedNeutralizeOptions, unusedWashOptions,
    badTimeOptions, badTimeValues, primitivesWithBadTime, tooManySolutionsTests, invalidPrimitivesTests, userPrimitiveIndex,   unusedQuenchParametersTest,
    unusedActivateParametersTest, unusedLoadParametersTest,enzymeLinkedDetectionTest, unusedStandardCurveTest, tooLargeQuantitationStandardDilutionsTest, tooSmallQuantitationStandardTransfersTest,
    tooSmallQuantitationStandardDilutionsTest, conflictingDelayOptionsTest, missingBLIBinningOptionsTest, solidObjectsTest, binningTooManySamplesTest, missingStandardTest,
    optionsFromWrongExperimentTypeTest, unusedBinningQuenchParametersTest, unusedPreMixOptionsTest, missingTestSolutionsTest, missingRequiredOptionsForDevelopmentTest,
    unusedDevelopmentTypeSpecificOptionTest,
    (*test for storage condition*)
    unusedTestLoadingSolutionsStorageConditionsTest, unusedTestInteractionSolutionsStorageConditionsTest,
    unusedQuantitationEnzymeSolutionStorageConditionTest, unusedQuantitationStandardStorageConditionTest,
    unusedStandardStorageConditionTest, unusedLoadSolutionStorageConditionTest, unusedBinningAntigenStorageConditionTest,
    badLengthTestLoadingSolutionsStorageConditionsTest, validSamplesInStorageConditionTests,
    (* invalid option tracking *)
    invalidKineticsDilutionsOptions, invalidKineticsDiluentOptions, invalidDevelopmentDilutionsOptions, invalidDevelopmentDiluentOptions,
    invalidPreMixSolutionOptions, invalidPreMixDiluentOptions, invalidAssaySequencePrimitivesOption, invalidRepeatedSequenceOptions,
    tooLargePreMixSolutions, invalidPreMixSolutionsOptions, samplePacketsWithTooLargePreMixSolution, samplePacketsWithInsufficientPreMixVolumes,
    samplePacketsWithInsufficientKineticsSerialDilutionsVolumes, samplePacketsWithInsufficientKineticsFixedDilutionsVolumes, samplePacketsWithInsufficientDetectionLimitSerialDilutionsVolumes,
    samplePacketsWithInsufficientDetectionLimitFixedDilutionsVolumes, samplePacketsWithInsufficientKineticsSerialTransferVolumes, samplePacketsWithInsufficientKineticsFixedTransferVolumes,
    samplePacketsWithInsufficientDetectionLimitSerialTransferVolumes, samplePacketsWithInsufficientDetectionLimitFixedTransferVolumes, insufficientTransferVolumesTests,
    invalidDevelopmentFixedOptions, invalidDevelopmentSerialOptions, invalidKineticsSampleFixedOptions, invalidKineticsSampleSerialOptions, name, modelPacketsToCheckIfDeprecated,
    deprecatedModelPackets, deprecatedInvalidInputs, deprecatedTest, compatibleMaterialsBool, compatibleMaterialsTests, compatibleMaterialsInvalidInputs,
    samplePacketsWithTooLargeKineticsSerialDilutionVolumes, samplePacketsWithTooLargeKineticsFixedDilutionVolumes,
    samplePacketsWithTooLargeDetectionLimitSerialDilutionVolumes, samplePacketsWithTooLargeDetectionLimitFixedDilutionVolumes, conflictingQuantitationStandardOptions,
    missingQuantitationStandardTest, missingQuantitationStandardOptions, missingQuantitationStandardBool, unusedLoadParameters, unusedActivateParameters, unusedQuenchParameters,
    unusedEquilibrateOptions, unusedProbeRackEquilibrationOptions, missingProbeRackEquilibrationOptions, conflictingStartDelayOptions, optionsWithTooManyDilutions,
    unusedAmplifiedDetectionOptions, unusedEnzymeLinkedOptions, unusedQuantitationStandardWellOptions, unusedQuantitationStandardOptions,
    unusedStandardCurveOptions, invalidQuantitationParametersOption, badExpandedAssaySequencePrimitiveOption, tooLargeQuantitationStandardDilutionOptions, tooSmallQuantitationStandardDilutionOptions,
    tooSmallQuantitationStandardTransferOptions, conflictingDelayOptions, missingBLIBinningOptions, optionsWithSolidObjectInput,solidObjectInputs, invalidBinningExperimentOption, missingStandardOptions,
    unusedBlankOption, unusedStandardOption, optionsFromWrongExperimentType, unusedBinningQuenchOptions, unusedPreMixOptions, missingTestSolutionsOptions, missingRequiredOptionsForDevelopment,
    developmentTypeSpecificOptions, developmentTypeSpecificValues, unusedDevelopmentTypeSpecificOptions,
    (*invalid options from storage condition*)
    unusedLoadSolutionStorageCondition, unusedStandardStorageCondition, unusedQuantitationStandardStorageCondition,
    unusedQuantitationEnzymeSolutionStorageCondition, unusedTestInteractionSolutionsStorageConditions,
    unusedTestLoadingSolutionsStorageConditions, unusedBinningAntigenStorageCondition, badLengthTestLoadingSolutionsStorageConditions,
    invalidSamplesInStorageConditionOption,
      (* aliquot resolution variables *)
    requiredVolumes, hamiltonCompatibleContainers, simulatedSampleContainers, sampleContainerPackets, sampleContainerFields
  },

  (* ---------------------------------------------- *)
  (*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
  (* ---------------------------------------------- *)

  (* Determine the requested output format of this function. *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests = MemberQ[output,Tests];
  messages = !gatherTests;

  (* Fetch our cache from the parent function. *)
  inheritedCache = Lookup[ToList[myResolutionOptions], Cache, {}];
  simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

  (* Separate out our BLI options from our Sample Prep options. *)
  {samplePrepOptions, bliOptions}=splitPrepOptions[myOptions];

  (* Resolve our sample prep options *)
  {{simulatedSamples, resolvedSamplePrepOptions, updatedSimulation}, samplePrepTests} = If[gatherTests,
    resolveSamplePrepOptionsNew[ExperimentBioLayerInterferometry, mySamples, samplePrepOptions, Cache -> inheritedCache, Simulation -> simulation, Output -> {Result, Tests}],
    {resolveSamplePrepOptionsNew[ExperimentBioLayerInterferometry, mySamples, samplePrepOptions, Cache -> inheritedCache, Simulation -> simulation, Output -> Result], {}}
  ];

  (* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
  bliOptionsAssociation = Association[bliOptions];

  (* Extract the packets that we need from our downloaded cache. *)
  (* we don't know what solutions will be needed yet, is there any way to prevent two download calls here? The solutions in the options will also need a volume check *)

  (* Remember to download from simulatedSamples, using our updatedSimulation *)
  sampleObjectPrepFields = Packet[SamplePreparationCacheFields[Object[Sample], Format -> Sequence], IncompatibleMaterials, State, Volume];
  sampleModelPrepFields = Packet[Model[Flatten[{SamplePreparationCacheFields[Model[Sample], Format -> Sequence], State,Products, IncompatibleMaterials, UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, Deprecated}]]];
  sampleContainerFields = Packet[Container[Flatten[{SamplePreparationCacheFields[Object[Container]], Model}]]];

  (* also need to download some fields from the probe to check compatibility with the regeneration and experiment type *)
  probeFields = Which[

    (* if the probe is an object, look up info from the model *)
    MatchQ[Lookup[bliOptionsAssociation, BioProbeType], ObjectP[Object[Item, BLIProbe]]],
    Packet[Model[Flatten[{QuantitationRegeneration, KineticsRegeneration, RecommendedApplication}]]],

    (* If the input is a model, just look up form there directly *)
    MatchQ[Lookup[bliOptionsAssociation, BioProbeType], ObjectP[Model[Item, BLIProbe]]],
    Packet[QuantitationRegeneration, KineticsRegeneration, RecommendedApplication]
  ];

  (* grab all of the instances of objects in the options and make packets for them - make sure to exclude the cache and also any models/objects found in the input *)
  allObjectOptions = DeleteCases[DeleteDuplicates[Download[Cases[KeyDrop[bliOptionsAssociation, Cache], ObjectP[Object[Sample]], Infinity], Object]],Alternatives@@ToList[simulatedSamples]];
  allModelOptions =  DeleteCases[DeleteDuplicates[Download[Cases[KeyDrop[bliOptionsAssociation, Cache], ObjectP[Model[Sample]], Infinity],Object]], Alternatives@@ToList[Download[simulatedSamples, Model[Object], Cache -> inheritedCache, Simulation -> updatedSimulation, Date ->Now]]];

  (* also grab the fields that we will need to check *)
  allObjectFields = Packet[Object, Name, State, Container, Composition, IncompatibleMaterials];
  allModelFields = Packet[Object, Name, State, IncompatibleMaterials];

  {allDownloadValues, probePacket, allObjectPackets, allModelPackets} = Quiet[Download[
    {
      simulatedSamples,
      ToList[Lookup[bliOptionsAssociation, BioProbeType]],
      allObjectOptions,
      allModelOptions
    },
    {
      {
        sampleObjectPrepFields,
        sampleModelPrepFields,
        sampleContainerFields
      },
      {
        probeFields
      },
      {
        allObjectFields
      },
      {
        allModelFields
      }
    },
    Cache -> Cases[inheritedCache, PacketP[]],
    Simulation -> updatedSimulation,
    Date->Now
  ], Download::FieldDoesntExist];

  (* split out the sample and model packets *)
  samplePackets = allDownloadValues[[All, 1]];
  sampleModelPackets = allDownloadValues[[All, 2]];
  sampleContainerPackets = allDownloadValues[[All, 3]];

  (* update cache to include the downloaded sample information and the inherited stuff *)
  newCache = Cases[FlattenCachePackets[{allDownloadValues, probePacket, allObjectPackets, allModelPackets, inheritedCache}], PacketP[]];

  (* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)


  (* pull out the options that have default values - these are either <default> or <specified> *)
  {
    name,
    instrument,
    experimentType,
    bioProbeType,
    numberOfRepeats,
    plateCover,
    recoupSample,
    saveAssayPlate,
    probeRackEquilibration,
    defaultBuffer,
    reuseSolution,
    standard,
    dilutionNumberOfMixes,
    regenerationType,
    loadingType,
    loadSolution,
    activateSolution,
    quenchSolution,
    kineticsReferenceType,
    quantitationParameters,
    amplifiedDetectionSolution,
    quantitationEnzymeSolution,
    binningQuenchSolution,
    binningAntigen,
    developmentReferenceWell,
    testInteractionSolutions,
    testBufferSolutions,
    testRegenerationSolutions,
    testLoadingSolutions,
    testActivationSolutions
  } = Lookup[bliOptionsAssociation, {Name, Instrument, ExperimentType, BioProbeType, NumberOfRepeats, PlateCover, RecoupSample, SaveAssayPlate, ProbeRackEquilibration, DefaultBuffer, ReuseSolution, Standard, DilutionNumberOfMixes, RegenerationType, LoadingType, LoadSolution, ActivateSolution, QuenchSolution, KineticsReferenceType,
    QuantitationParameters, AmplifiedDetectionSolution, QuantitationEnzymeSolution, BinningQuenchSolution, BinningAntigen,
     DevelopmentReferenceWell, TestInteractionSolutions, TestBufferSolutions, TestRegenerationSolutions, TestLoadingSolutions, TestActivationSolutions}];

  (* make number of repeats 1 unless it is set to another number *)
  safeNumberOfRepeats = If[MatchQ[numberOfRepeats, (Except[_Integer]|0)],
    1,
    numberOfRepeats
  ];

  (* look up storage condition options *)
  {
    standardStorageCondition,
    quantitationStandardStorageCondition,
    quantitationEnzymeSolutionStorageCondition,
    binningAntigenStorageCondition,
    loadSolutionStorageCondition,
    testInteractionSolutionsStorageConditions,
    testLoadingSolutionsStorageConditions,
    samplesInStorageCondition
  } = Lookup[
    bliOptionsAssociation,
    {
      StandardStorageCondition,
      QuantitationStandardStorageCondition,
      QuantitationEnzymeSolutionStorageCondition,
      BinningAntigenStorageCondition,
      LoadSolutionStorageCondition,
      TestInteractionSolutionsStorageConditions,
      TestLoadingSolutionsStorageConditions,
      SamplesInStorageCondition
    }
  ];


  (* --------------------------- *)
  (*-- INPUT VALIDATION CHECKS --*)
  (* --------------------------- *)

  (*Discarded Samples check*)

  (* Get the samples from mySamples that are discarded. *)
  discardedSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[Status->Discarded]];

  (* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
  discardedInvalidInputs=If[MatchQ[discardedSamplePackets,{}],
    {},
    Lookup[discardedSamplePackets,Object]
  ];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[Length[discardedInvalidInputs]>0&&!gatherTests,
    Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Simulation -> updatedSimulation]];
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  discardedTest=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[MatchQ[Length[discardedInvalidInputs],0],
        Nothing,
        Test["Our input samples " <> ObjectToString[discardedInvalidInputs, Simulation -> updatedSimulation] <> " are not discarded:", True, False]
      ];

      passingTest=If[MatchQ[Length[discardedInvalidInputs], Length[mySamples]],
        Nothing,
        Test["Our input samples " <> ObjectToString[Complement[mySamples, discardedInvalidInputs], Simulation -> updatedSimulation] <> " are not discarded:", True, True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* --- Check if the input samples have Deprecated inputs --- *)

  (* get all the model packets together that are going to be checked for whether they are deprecated *)
  (* need to only get the packets themselves (and not any Nulls that might have slipped through) *)
  modelPacketsToCheckIfDeprecated = Cases[sampleModelPackets, PacketP[Model[Sample]]];

  (* get the samples that are deprecated; if on the FastTrack, don't bother checking *)
  deprecatedModelPackets = Select[modelPacketsToCheckIfDeprecated, TrueQ[Lookup[#, Deprecated]]&];

  (* If there are any invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs *)
  deprecatedInvalidInputs = If[MatchQ[deprecatedModelPackets, {PacketP[]..}] && messages,
    (
      Message[Error::DeprecatedModels, Lookup[deprecatedModelPackets, Object, {}]];
      Lookup[deprecatedModelPackets, Object, {}]
    ),
    Lookup[deprecatedModelPackets, Object, {}]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  deprecatedTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[deprecatedInvalidInputs] == 0,
        Nothing,
        Test["Provided samples have models " <> ObjectToString[deprecatedInvalidInputs, Simulation -> updatedSimulation] <> " that are not deprecated:", True, False]
      ];

      passingTest = If[Length[deprecatedInvalidInputs] == Length[modelPacketsToCheckIfDeprecated],
        Nothing,
        Test["Provided samples have models " <> ObjectToString[Download[Complement[modelPacketsToCheckIfDeprecated, deprecatedInvalidInputs], Object, Simulation -> updatedSimulation]] <> " that are not deprecated:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* -- SAMPLES IN STORAGE CONDITION -- *)

  (* determine if incompatible storage conditions have been specified for samples in the same container *)
  (* this will throw warnings if needed *)
  {validSamplesInStorageConditionBools, validSamplesInStorageConditionTests} = Quiet[
    If[gatherTests,
      ValidContainerStorageConditionQ[simulatedSamples, samplesInStorageCondition, Output -> {Result, Tests}, Cache -> newCache, Simulation -> updatedSimulation],
      {ValidContainerStorageConditionQ[simulatedSamples, samplesInStorageCondition, Output -> Result, Cache -> newCache, Simulation -> updatedSimulation], {}}
    ],
    Download::MissingCacheField
  ];

  (* convert to a single boolean *)
  validSamplesInStorageBool = And@@ToList[validSamplesInStorageConditionBools];

  (* collect the bad option to add to invalid options later *)
  invalidSamplesInStorageConditionOption = If[MatchQ[validSamplesInStorageBool, False],
    {SamplesInStorageCondition},
    {}
  ];

  (* -- Check if the input is a solid -- *)

  (* identify sample packets with solid objects *)
  solidSamplePackets = Cases[samplePackets, KeyValuePattern[State->Solid]];

  (*test for solid inputs*)
  solidSampleTest = Test["All input samples are liquids:",
    MatchQ[solidSamplePackets,{}],
    True
  ];

  (* gather the objects that are solids *)
  solidStateInvalidInputs = If[MatchQ[solidSamplePackets, {}],
    {},
    Lookup[solidSamplePackets, Object]
  ];

  (*throw the error*)
  If[MatchQ[solidSamplePackets, Except[{}]]&&!gatherTests,
    Message[Error::InvalidSolidInput,Lookup[solidSamplePackets, Object]]
  ];
  (* ------------------------ *)
  (* -- OBJECT STATE CHECK -- *)
  (* ------------------------ *)

  (* make sure that all the samples which are specified in the options are not solids *)
  {optionsWithSolidObjectInput,solidObjectInputs} = Module[
    {
      objectInputsAssociation, objectInputObjects, objectInputOptionNames, expandedObjectInputOptionName,
      flatObjectInputObjects,flatObjectInputOptionNames,flattenedObjectInputAssociation, objectInputObjectsState,
      solidObjectInputAssociation, primitiveSolidObjectInput, allSolidInputsAssociation
    },

    (* first pull out all of the objects and the field they are associated with *)
    objectInputsAssociation = Select[
      Normal[bliOptionsAssociation],
      MatchQ[
        Values[#], Alternatives[ObjectP[{Object[Sample],Model[Sample]}],{ObjectP[{Object[Sample],Model[Sample]}]..}]
      ]&
    ];

    (* if there are no input objects, just return an empty list *)
    solidObjectInputAssociation = If[MatchQ[objectInputsAssociation, {}],
      {},
      (* -- split into lists and expand the Options to match the length of the objects -- *)
      objectInputObjects = ToList/@Values[objectInputsAssociation];
      objectInputOptionNames = Keys[objectInputsAssociation];
      expandedObjectInputOptionName = MapThread[
        ConstantArray[#1, Length[#2]]&,
        {objectInputOptionNames, objectInputObjects}
      ];

      (* flatten both the sample and option lists *)
      flatObjectInputObjects = Flatten[objectInputObjects];
      flatObjectInputOptionNames = Flatten[expandedObjectInputOptionName];

      (* reassemble the list so that each object is matched to its option *)
      flattenedObjectInputAssociation = MapThread[(#1->#2)&,{flatObjectInputOptionNames,flatObjectInputObjects}];

      (* look up the states for all the objects *)
      objectInputObjectsState = Quiet[Download[flatObjectInputObjects, State, Cache -> newCache, Simulation -> updatedSimulation, Date->Now]];

      (* pick the elements that have state of solid *)
      PickList[flattenedObjectInputAssociation, objectInputObjectsState, Solid]
    ];



    (* also check the primitives *)
    primitiveSolidObjectInput = Which[
      (*If expandedassaysequenceprimitves are informed, check those. Not that other errors will be thrown if they inform both*)
      MatchQ[Lookup[bliOptionsAssociation, ExpandedAssaySequencePrimitives], Except[(Null|Automatic)]],
      Module[{allPotentialSolidObjects, allSolidObjects},

        (* extract all the objects/models *)
        allPotentialSolidObjects = Cases[
          Lookup[bliOptionsAssociation, ExpandedAssaySequencePrimitives],
          ObjectP[{Object[Sample, Model[Sample]]}],
          Infinity
        ];

        (* pick the solid objects *)
        allSolidObjects = PickList[allPotentialSolidObjects, Quiet[Download[allPotentialSolidObjects, State, Cache -> newCache, Simulation -> updatedSimulation, Date->Now]], Solid];

        (* if there are solid objects, return them as an association with the option name *)
        If[MatchQ[allSolidObjects, {}],
          {},
          {ExpandedAssaySequencePrimitives -> allSolidObjects}
        ]
      ],

      (* If AssaySequencePrimitives are informed, check them for solids *)
      MatchQ[Lookup[bliOptionsAssociation, AssaySequencePrimitives], Except[(Null|Automatic)]],
      Module[{allPotentialSolidObjects, allSolidObjects},

        (* extract all the objects/models *)
        allPotentialSolidObjects = Cases[
          Lookup[bliOptionsAssociation, AssaySequencePrimitives],
          ObjectP[{Object[Sample, Model[Sample]]}],
          Infinity
        ];

        (* pick the solid objects *)
        allSolidObjects = PickList[allPotentialSolidObjects, Quiet[Download[allPotentialSolidObjects, State, Cache->newCache, Simulation -> updatedSimulation, Date->Now]], Solid];

        (* if there are solid objects, return them as an association with the option name *)
        If[MatchQ[allSolidObjects, {}],
          {},
          {AssaySequencePrimitives -> allSolidObjects}
        ]
      ],

      True,
      {}
    ];

    (* join the primitives and options solid objects, and merge the options so that the bad objects can be thrown in the error with the option they used *)
    allSolidInputsAssociation = Join[Normal[Merge[solidObjectInputAssociation, Join]], primitiveSolidObjectInput];

    (* break it into  options and the bad objects *)
    {Keys[allSolidInputsAssociation], Values[allSolidInputsAssociation]}
  ];

  (* throw errors for solid inputs *)
  If[MatchQ[optionsWithSolidObjectInput, Except[{}]]&&!gatherTests,
    Message[Error::OptionsWithSolidObjects, optionsWithSolidObjectInput, Flatten[solidObjectInputs]]
  ];

  (* tests for solid inputs *)
  solidObjectsTest = Test["All Objects and Models specified in the options are liquids:",
    MatchQ[optionsWithSolidObjectInput, {}],
    True
  ];


  (* ------------------------------- *)
  (* -- PROBE COMPATIBILITY CHECK -- *)
  (* ------------------------------- *)

  (* check the probe packet to see if the applciation matches the experimentType. Note that EpitopeBinning is basically just Kinetics and AssayDevelopment is a free for all *)
  If[And[
    Not[MemberQ[Lookup[Association@@probePacket, RecommendedApplication],experimentType/.{EpitopeBinning->Kinetics, AssayDevelopment -> (Kinetics|Quantitation)}]],
    !gatherTests,
    Not[MatchQ[$ECLApplication, Engine]]
  ],
    Message[Warning::BLIProbeApplicationMismatch, bioProbeType, Lookup[Association@@probePacket, RecommendedApplication], experimentType]
  ];

  (* check if regeneration is requested, if the probe can be regenerated, and the experiement type *)
  Which[
    And[
      MatchQ[experimentType, Quantitation],
      MatchQ[Lookup[Association@@probePacket, QuantitationRegeneration], False],
      MemberQ[ToList[regenerationType], Regenerate],
      !gatherTests,
      Not[MatchQ[$ECLApplication, Engine]]
    ],
    Message[Warning::BLIProbeRegeneration, bioProbeType, Quantitation],

    And[
      MatchQ[experimentType, Except[Quantitation]],
      MatchQ[Lookup[Association@@probePacket, KineticsRegeneration], False],
      MemberQ[ToList[regenerationType], Regenerate],
      !gatherTests,
      Not[MatchQ[$ECLApplication, Engine]]
    ],
    Message[Warning::BLIProbeRegeneration, bioProbeType, {Kinetics, AssayDevelopment, EpitopeBinning}],

    True,
    Null
  ];

  (* --------------------------- *)
  (*-- OPTION PRECISION CHECKS --*)
  (* --------------------------- *)

  (* note that the primitives are rounded at a later time *)
  (* round options in a module to keep things neat *)
  {
    fullBLIOptionsAssociation,
    roundingBLITests
  } = Module[{roundedOptions, precisionTests, timeOptions, shakeRateOptions, absoluteThresholdOptions, thresholdSlopeOptions, thresholdSlopeDurationOptions, otherQuantityOptions,
    (* precisions *)
    timePrecision, shakeRatePrecision, absoluteThresholdPrecision, thresholdSlopePrecision,
    thresholdSlopeDurationPrecision, otherQuantityPrecision, roundableOptions, roundableOptionsPrecision,
    (* dilutions *)
    unroundedKineticsSampleSerialDilutions, unroundedKineticsSampleFixedDilutions, unroundedDetectionLimitSerialDilutions,
    unroundedDetectionLimitFixedDilutions, unroundedPreMixSolutions, unroundedQuantitationStandardFixedDilutions,
    unroundedQuantitationStandardSerialDilutions, roundedKineticsSampleSerialDilutions, roundedKineticsSampleFixedDilutions,
    roundedDetectionLimitSerialDilutions, roundedDetectionLimitFixedDilutions, roundedPreMixSolutions, roundedQuantitationStandardSerialDilutions,
    roundedQuantitationStandardFixedDilutions,roundedKineticsSampleSerialDilutionValues, roundedKineticsSampleFixedDilutionValues,
    roundedDetectionLimitSerialDilutionValues, roundedDetectionLimitFixedDilutionValues, roundedPreMixSolutionValues,
    roundedQuantitationStandardSerialDilutionValues, roundedQuantitationStandardFixedDilutionValues,
    (* cleanup *)
    finalRoundedOptions,
    roundedDilutions
  },

    (* group the options by type like in HPLC, see around line 3800*)
    (* the precision for time is 1*Second*)
    timeOptions = {
      StartDelay,
      ProbeRackEquilibrationTime,
      EquilibrateTime,
      RegenerationTime,
      NeutralizationTime,
      WashTime,
      LoadTime,
      ActivateTime,
      QuenchTime,
      MeasureBaselineTime,
      MeasureAssociationTime,
      MeasureDissociationTime,
      QuantitateTime,
      AmplifiedDetectionTime,
      QuantitationEnzymeTime,
      BinningQuenchTime,
      LoadAntigenTime,
      CompetitionBaselineTime,
      CompetitionTime,
      DevelopmentAssociationTime,
      DevelopmentDissociationTime,
      DevelopmentBaselineTime,
      LoadAntibodyTime
    };
    timePrecision = Table[1*Second, Length[timeOptions]];

    (* the precision for time is 1*RPM *)
    shakeRateOptions = {
      RegenerationShakeRate,
      NeutralizationShakeRate,
      WashShakeRate,
      LoadShakeRate,
      ActivateShakeRate,
      QuenchShakeRate,
      MeasureBaselineShakeRate,
      MeasureAssociationShakeRate,
      MeasureDissociationShakeRate,
      EquilibrateShakeRate,
      QuantitateShakeRate,
      AmplifiedDetectionShakeRate,
      LoadAntibodyShakeRate,
      BinningQuenchShakeRate,
      LoadAntigenShakeRate,
      CompetitionBaselineShakeRate,
      CompetitionShakeRate,
      DevelopmentBaselineShakeRate,
      DevelopmentAssociationShakeRate,
      DevelopmentDissociationShakeRate,
      QuantitationEnzymeShakeRate
    };
    shakeRatePrecision = Table[1*RPM, Length[shakeRateOptions]];

    (*the precision for AbsoluteThreshold is 10^-2*Nanometer*)
    absoluteThresholdOptions = {
      MeasureAssociationAbsoluteThreshold,
      MeasureDissociationAbsoluteThreshold,
      LoadAntibodyAbsoluteThreshold,
      LoadAntigenAbsoluteThreshold,
      LoadAbsoluteThreshold,
      CompetitionAbsoluteThreshold,
      DevelopmentAssociationAbsoluteThreshold,
      DevelopmentDissociationAbsoluteThreshold
    };
    absoluteThresholdPrecision = Table[10^-2*Nanometer, Length[absoluteThresholdOptions]];

    (*the precision for ThresholdSlope is 10^-2*Nanometer/Minute*)
    thresholdSlopeOptions = {
      MeasureAssociationThresholdSlope,
      MeasureDissociationThresholdSlope,
      LoadAntibodyThresholdSlope,
      LoadAntigenThresholdSlope,
      CompetitionThresholdSlope,
      DevelopmentAssociationThresholdSlope,
      DevelopmentDissociationThresholdSlope,
      LoadThresholdSlope
    };
    thresholdSlopePrecision = Table[10^-2*Nanometer/Minute, Length[thresholdSlopeOptions]];

    (*the precision for ThresholdSlopeDuration is 10^-2 Minute*)
    thresholdSlopeDurationOptions = {
      MeasureAssociationThresholdSlopeDuration,
      LoadThresholdSlopeDuration,
      MeasureDissociationThresholdSlopeDuration,
      LoadAntibodyThresholdSlopeDuration,
      LoadAntigenThresholdSlopeDuration,
      DevelopmentAssociationThresholdSlopeDuration,
      DevelopmentDissociationThresholdSlopeDuration,
      CompetitionThresholdSlopeDuration
    };
    thresholdSlopeDurationPrecision = Table[10^-2*Minute, Length[thresholdSlopeDurationOptions]];

    (* the precision for the other quantities are: 1*Celsius, 0.4 Microliter/Second, and 1 Microliter*)
    otherQuantityOptions = {
      Temperature,
      DilutionMixRate,
      DilutionMixVolume
    };
    otherQuantityPrecision = {1*Celsius, 5*10^-2 Microliter/Second, 1*Microliter};

    (* gather the options and their precisions *)
    roundableOptions = Join[timeOptions, shakeRateOptions, absoluteThresholdOptions, thresholdSlopeOptions,
      thresholdSlopeDurationOptions, otherQuantityOptions];

    roundableOptionsPrecision = Join[timePrecision, shakeRatePrecision, absoluteThresholdPrecision, thresholdSlopePrecision,
      thresholdSlopeDurationPrecision, otherQuantityPrecision];

    (* big round call on the joined lists *)
    {roundedOptions, precisionTests} = If[gatherTests,
      RoundOptionPrecision[Association[bliOptions], roundableOptions, roundableOptionsPrecision, Output -> {Result, Tests}],
      {RoundOptionPrecision[Association[bliOptions],  roundableOptions, roundableOptionsPrecision], {}}
    ];


    (* ----------------------- *)
    (* --- ROUND DILUTIONS --- *)
    (* ----------------------- *)

    (* look up the raw option values *)
    (* IMPORTANT NOTE: this only rounds input forms with volumes - we will round the specified dilution factors somewhere else without throwing warnings, since precision is not user speified in those *)
    {
      unroundedKineticsSampleSerialDilutions, unroundedKineticsSampleFixedDilutions, unroundedDetectionLimitSerialDilutions,
      unroundedDetectionLimitFixedDilutions, unroundedPreMixSolutions, unroundedQuantitationStandardFixedDilutions,
      unroundedQuantitationStandardSerialDilutions
    }= Lookup[Association[bliOptions],
      {
        KineticsSampleSerialDilutions, KineticsSampleFixedDilutions, DetectionLimitSerialDilutions,
        DetectionLimitFixedDilutions, PreMixSolutions, QuantitationStandardFixedDilutions,
        QuantitationStandardSerialDilutions
      }
    ];


    (* KineticsSampleSerialDilutions rounding *)
    {roundedKineticsSampleSerialDilutions, roundedKineticsSampleSerialDilutionValues} = roundBLIDilutions[unroundedKineticsSampleSerialDilutions];

    (*KineticsSampleFixedDilutions rounding *)
    {roundedKineticsSampleFixedDilutions, roundedKineticsSampleFixedDilutionValues} = roundBLIDilutions[unroundedKineticsSampleFixedDilutions];

    (*DetectionLimitFixedDilutions rounding *)
    {roundedDetectionLimitFixedDilutions, roundedDetectionLimitFixedDilutionValues} = roundBLIDilutions[unroundedDetectionLimitFixedDilutions];

    (*DetectionLimitSerialDilutions rounding *)
    {roundedDetectionLimitSerialDilutions, roundedDetectionLimitSerialDilutionValues} = roundBLIDilutions[unroundedDetectionLimitSerialDilutions];

    (*QuantitationStandardFixedDilution rounding *)
    {roundedQuantitationStandardFixedDilutions, roundedQuantitationStandardFixedDilutionValues} = roundBLIDilutions[unroundedQuantitationStandardFixedDilutions];

    (*QuantitationStandardSerialDilutions rounding *)
    {roundedQuantitationStandardSerialDilutions, roundedQuantitationStandardSerialDilutionValues} = roundBLIDilutions[unroundedQuantitationStandardSerialDilutions];

    (*PreMixSolutions rounding *)
    {roundedPreMixSolutions, roundedPreMixSolutionValues} = roundBLIDilutions[unroundedPreMixSolutions];


    (* --- INSTRUMENT PRECISION WARNINGS --- *)

    (* since we may need to throw this several times, turn off the limit just for this section *)
    Off[General::stop];

    (* if any rounding occurred, throw the warning *)
    (* KineticsSampleSerialDilutions warnings *)
    If[MatchQ[roundedKineticsSampleSerialDilutionValues, Except[{}]]&&!gatherTests&& Not[MatchQ[$ECLApplication, Engine]],
      Message[Warning::BLIInstrumentPrecision, #, KineticsSampleSerialDilutions]&/@roundedKineticsSampleSerialDilutionValues
    ];

    (* KineticsSampleFixedDilutions *)
    If[MatchQ[roundedKineticsSampleFixedDilutionValues, Except[{}]]&&!gatherTests&& Not[MatchQ[$ECLApplication, Engine]],
      Message[Warning::BLIInstrumentPrecision, #, KineticsSampleFixedDilutions]&/@roundedKineticsSampleFixedDilutionValues
    ];

    (* DetectionLimitFixedDilutions *)
    If[MatchQ[roundedDetectionLimitFixedDilutionValues, Except[{}]]&&!gatherTests&& Not[MatchQ[$ECLApplication, Engine]],
      Message[Warning::BLIInstrumentPrecision, #, DetectionLimitFixedDilutions]&/@roundedDetectionLimitFixedDilutionValues
    ];

    (* DetectionLimitSerialDilutions *)
    If[MatchQ[roundedDetectionLimitSerialDilutionValues, Except[{}]]&&!gatherTests&& Not[MatchQ[$ECLApplication, Engine]],
      Message[Warning::BLIInstrumentPrecision, #, DetectionLimitSerialDilutions]&/@roundedDetectionLimitSerialDilutionValues
    ];

    (* QuantitationStandardSerialDilutions *)
    If[MatchQ[roundedQuantitationStandardSerialDilutionValues, Except[{}]]&&!gatherTests&& Not[MatchQ[$ECLApplication, Engine]],
      Message[Warning::BLIInstrumentPrecision, #, QuantitationStandardSerialDilutions]&/@roundedQuantitationStandardSerialDilutionValues
    ];

    (* QuantitationStandardFixedDilutions *)
    If[MatchQ[roundedQuantitationStandardFixedDilutionValues, Except[{}]]&&!gatherTests&& Not[MatchQ[$ECLApplication, Engine]],
      Message[Warning::BLIInstrumentPrecision, #, QuantitationStandardFixedDilutions]&/@roundedQuantitationStandardFixedDilutionValues
    ];

    (* PreMixSolutions *)
    If[MatchQ[roundedPreMixSolutionValues, Except[{}]]&&!gatherTests&& Not[MatchQ[$ECLApplication, Engine]],
      Message[Warning::BLIInstrumentPrecision, #, PreMixSolutions]&/@roundedPreMixSolutionValues
    ];

    (* make sure to turn the limit back on again *)
    On[General::stop];

    (* pull out these options in a mini association to overwrite the given options *)
    roundedDilutions = <|
      KineticsSampleSerialDilutions -> roundedKineticsSampleSerialDilutions,
      KineticsSampleFixedDilutions -> roundedKineticsSampleFixedDilutions,
      DetectionLimitSerialDilutions -> roundedDetectionLimitSerialDilutions,
      DetectionLimitFixedDilutions -> roundedDetectionLimitFixedDilutions,
      PreMixSolutions -> roundedPreMixSolutions,
      QuantitationStandardSerialDilutions -> roundedQuantitationStandardSerialDilutions,
      QuantitationStandardFixedDilutions -> roundedQuantitationStandardFixedDilutions
    |>;

    (* replace the unrounded options with the rounded ones *)
    finalRoundedOptions = Join[roundedOptions, roundedDilutions];

    (* return the precision test and rounded options *)
    {finalRoundedOptions, precisionTests}
  ];

  (* pull out the rounded options that have default values - these are either <default> or <specified>.*)
  {
    temperature,
    dilutionMixVolume,
    dilutionMixRate,
    loadAbsoluteThreshold,
    loadThresholdSlope,
    loadThresholdSlopeDuration,
    measureAssociationAbsoluteThreshold,
    measureAssociationThresholdSlope,
    measureAssociationThresholdSlopeDuration,
    measureDissociationAbsoluteThreshold,
    measureDissociationThresholdSlope,
    measureDissociationThresholdSlopeDuration,
    loadAntibodyAbsoluteThreshold,
    loadAntibodyThresholdSlope,
    loadAntibodyThresholdSlopeDuration,
    loadAntigenAbsoluteThreshold,
    loadAntigenThresholdSlope,
    loadAntigenThresholdSlopeDuration,
    competitionAbsoluteThreshold,
    competitionThresholdSlope,
    competitionThresholdSlopeDuration,
    developmentAssociationAbsoluteThreshold,
    developmentAssociationThresholdSlope,
    developmentAssociationThresholdSlopeDuration,
    developmentDissociationAbsoluteThreshold,
    developmentDissociationThresholdSlope,
    developmentDissociationThresholdSlopeDuration
  } = Lookup[fullBLIOptionsAssociation, {Temperature,DilutionMixVolume, DilutionMixRate, LoadAbsoluteThreshold, LoadThresholdSlope, LoadThresholdSlopeDuration, MeasureAssociationAbsoluteThreshold, MeasureAssociationThresholdSlope,
    MeasureAssociationThresholdSlopeDuration, MeasureDissociationAbsoluteThreshold, MeasureDissociationThresholdSlope, MeasureDissociationThresholdSlopeDuration, LoadAntibodyAbsoluteThreshold, LoadAntibodyThresholdSlope, LoadAntibodyThresholdSlopeDuration, LoadAntigenAbsoluteThreshold, LoadAntigenThresholdSlope, LoadAntigenThresholdSlopeDuration, CompetitionAbsoluteThreshold, CompetitionThresholdSlope,
    CompetitionThresholdSlopeDuration, DevelopmentAssociationAbsoluteThreshold, DevelopmentAssociationThresholdSlope, DevelopmentAssociationThresholdSlopeDuration, DevelopmentDissociationAbsoluteThreshold, DevelopmentDissociationThresholdSlope, DevelopmentDissociationThresholdSlopeDuration}];

  (* look up the primitives *)
  assaySequencePrimitives = Lookup[fullBLIOptionsAssociation, AssaySequencePrimitives];

  (* ------------------------- *)
  (* -- INVALID INPUT TESTS -- *)
  (* ------------------------- *)

  {compatibleMaterialsBool, compatibleMaterialsTests} = If[gatherTests,
    CompatibleMaterialsQ[instrument, simulatedSamples, Cache -> newCache, Simulation -> updatedSimulation, Output -> {Result, Tests}],
    {CompatibleMaterialsQ[instrument, simulatedSamples, Cache -> newCache, Simulation -> updatedSimulation, Messages -> messages], {}}
  ];

  (* If the materials are incompatible, then the Instrument is invalid *)
  compatibleMaterialsInvalidInputs = If[Not[compatibleMaterialsBool] && messages,
    Download[mySamples, Object],
    {}
  ];

  (* --- Make sure the Name isn't currently in use --- *)

  (* If the specified Name is not in the database, it is valid. *)
  validNameQ = If[MatchQ[name, _String],
    Not[DatabaseMemberQ[Object[Protocol, BioLayerInterferometry, name]]],
    True
  ];

  (* if validNameQ is False AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
  nameInvalidOptions = If[Not[validNameQ] && messages,
    (
      Message[Error::DuplicateName, "BioLayerInterferometry protocol"];
      {Name}
    ),
    {}
  ];

  (* Generate Test for Name check *)
  validNameTest = If[gatherTests && MatchQ[name,_String],
    Test["If specified, Name is not already a BioLayerInterferometry object name:",
      validNameQ,
      True
    ],
    Null
  ];


  (* ------------------------------ *)
  (*-- CONFLICTING OPTIONS CHECKS --*)
  (* ------------------------------ *)

  (*Check if the instrument is supported using validInstrumentQ*)

  (* Throw a warning for an insufficient start delay *)
  If[MatchQ[temperature, Except[AmbientTemperatureP]]&&MatchQ[Lookup[fullBLIOptionsAssociation,StartDelay], Except[Automatic]]&&MatchQ[Lookup[fullBLIOptionsAssociation,StartDelay], LessP[10*Minute]]&&!gatherTests&& Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::InsufficientBLIStartDelay,{Lookup[fullBLIOptionsAssociation,StartDelay], temperature}]
  ];

  (* throw a warning for AssaySequencePrimitives, letting the user know that most of the options will not matter*)
  If[(MatchQ[assaySequencePrimitives, Except[Automatic]]||MatchQ[Lookup[fullBLIOptionsAssociation, ExpandedAssaySequencePrimitives], Except[Automatic]])&&!gatherTests&& Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::BLIPrimitiveOverride]
  ];

  (* throw warnings for if they specify Quench and Activate without load steps. It may be valid but is probably just a mistake *)
  If[
    And[MemberQ[ToList[loadingType], Quench], !MemberQ[ToList[loadingType], Load]]&&!gatherTests&& Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::BLIQuenchWithoutLoad]
  ];

  If[And[MemberQ[ToList[loadingType], Activate], !MemberQ[ToList[loadingType], Load]]&&!gatherTests&& Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::BLIActivateWithoutLoad]
  ];


  (* --- conflicting Binning options --- *)

  (* if there is no BinningType, throw an error and collect the option *)
  missingBLIBinningOptions = If[MatchQ[experimentType, EpitopeBinning]&&MatchQ[Lookup[fullBLIOptionsAssociation, BinningType], Null],
    {BinningType},
    {}
  ];

  (* throw the error for conflicting options *)
  If[!MatchQ[missingBLIBinningOptions, {}]&&!gatherTests,
    Message[Error::UnspecifiedBLIBinningType]
  ];

  (* test for conflicting delay options *)
  missingBLIBinningOptionsTest = If[gatherTests,
    Test["If the experiment type is EpitopeBinning, the BinningType is not Null:",
      MatchQ[missingBLIBinningOptions, {}],
      True
    ],
    Null
  ];

  (* check if there are too many samples for EpitopeBinning. The limitation here is the number of Antibody solutions that can be loaded in a single column. *)
  invalidBinningExperimentOption = If[
    And[
      MatchQ[experimentType, EpitopeBinning],
      (* either there are more than 8 total samples, or there are more than 7 total samples with one blank *)
      (* if the binning control well is set to Automatic it will default to True for epitope binning, so only Null or false will have no control well *)
      Or[
        MatchQ[Length[ToList[mySamples]],GreaterP[8]],
        MatchQ[Length[ToList[mySamples]], GreaterP[7]]&&MatchQ[Lookup[bliOptionsAssociation,BinningControlWell], Except[(Null|False)]]
      ]
    ],
    {ExperimentType},
    {}
  ];

  (* throw the error for havign too many samples with EpitopeBinning *)
  If[MatchQ[invalidBinningExperimentOption, Except[{}]]&&!gatherTests,
    Message[Error::BLIBinningTooManySamples]
  ];

  (* make a test for having too many samples with EpitopeBinning *)
  binningTooManySamplesTest = Test["If the ExperimentType is EpitopeBinning, there are fewer than 8 total ladign solution including Blanks:",
    MatchQ[invalidBinningExperimentOption, {}],
    True
  ];

  (* check tha binning quench step parameters are set together *)
  unusedBinningQuenchOptions = If[MatchQ[binningQuenchSolution, Null],
    Module[{binningQuenchOptions, binningQuenchOptionValues},
      binningQuenchOptions = {BinningQuenchTime, BinningQuenchShakeRate};
      binningQuenchOptionValues = Lookup[bliOptionsAssociation,binningQuenchOptions];
      PickList[binningQuenchOptions, binningQuenchOptionValues, Except[Automatic]]
    ],
    {}
  ];

  (* throw the error for unused options *)
  If[MatchQ[unusedBinningQuenchOptions,Except[{}]]&&!gatherTests,
    Message[Error::BLIUnusedBinningQuenchOptions, unusedBinningQuenchOptions]
  ];

  (* make a test for specified time and shakerate without solution *)
  unusedBinningQuenchParametersTest = Test[
    "If BinningQuenchTime or BinningQuenchShakeRate are specified, BinningQuenchSolution is also specified:",
    MatchQ[unusedBinningQuenchOptions, {}],
    True
  ];
  (* throw warnings for if they specify neutralize and wash steps without regenerate *)

  (* check if there are premix options populated when the experiment type is not premix *)
  unusedPreMixOptions = If[MatchQ[experimentType,EpitopeBinning]&&!MatchQ[Lookup[bliOptionsAssociation, BinningType], PreMix],
    Module[{preMixOptions, preMixValues},
      (* make a list of the options we are checking, look up their values *)
      preMixOptions = {PreMixSolutions, PreMixDiluent};
      preMixValues = Lookup[bliOptionsAssociation, preMixOptions];

      (* determine if any of the values are not Automatic or Null or list of Nulls *)
      PickList[preMixOptions, preMixValues, Except[(Automatic|Null|{Null...}|{Automatic...})]]
    ],
    {}
  ];

  (* throw an error if the pre mix solutions/diluent has been informed but the experimentType is not premix *)
  If[!MatchQ[unusedPreMixOptions, {}]&&!gatherTests,
    Message[Error::BLIUnusedPreMixOptions, unusedPreMixOptions]
  ];

  (* make a test to check if premix values are informed when premix is false *)
  unusedPreMixOptionsTest = Test["PreMixSolutions and PreMixDiluent are only informed if the BinningType is PreMix:",
    MatchQ[unusedPreMixOptions, {}],
    True
  ];



  (* ------------------------------- *)
  (* --- MASTER SWITCH CONFLICTS --- *)
  (* ------------------------------- *)

  (* using Options[ExperimentBioLayerInterferometry] to get all the options in the form of {OptionName -> default value} *)
  (* check if any options overridden by the primitives were informed, or if any of the options from the wrong experiment type are specified *)
  {
    unusedOptionValuesPrimitiveInput,
    unusedOptionValuesKinetics,
    unusedOptionValuesQuantitation,
    unusedOptionValuesEpitopeBinning,
    unusedOptionValuesAssayDevelopment
  } = Module[
    {defaultOptionValueRules,
      (* defaults map *)
      allPrimitiveIncompatibleOptions, kineticsOptions, generalOptions, quantitationOptions, epitopeBinningOptions, assayDevelopmentOptions,
      (* automatics *)
      allAutomaticOptions, automaticGeneralOptions, automaticKineticsOptions, automaticQuantitationOptions, automaticEpitopeBinningOptions, automaticAssayDevelopmentOptions,
      (* actual values of the default options *)
      primitiveIncompatibleValues, kineticsValues, generalDefaultsValues, quantitationValues, epitopeBinningValues, assayDevelopmentValues,
      (* dilution automatic or default *)
      kineticsDilutionOptions, quantitationDilutionOptions, epitopeBinningSolutionOptions, assayDevelopmentDilutionOptions,
      (* actual values of the dilution options *)
      kineticsDilutionValues, quantitationDilutionValues, epitopeBinningSolutionValues, developmentDilutionValues,
      (* actual values of automatic options *)
      allAutomaticValues, automaticGeneralValues, automaticKineticsValues, automaticQuantitationValues, automaticEpitopeBinningValues, automaticAssayDevelopmentValues,
      (* the value that are user specified (changed form Automatic or default values) *)
      userInformedKineticsDilutionsOptions, userInformedQuantitationDilutionsOptions,
      userInformedEpitopeBinningSolutionsOptions, userInformedAssayDevelopmentDilutionsOptions,
      userInformedOptions, userInformedKineticsOptions, userInformedQuantitationOptions,
      userInformedEpitopeBinningOptions, userInformedAssayDevelopmentOptions
    },

    (* --- DEFAULTS --- *)

    (* return the option in the form of {OptionName -> DefaultValue...} *)
    defaultOptionValueRules = Module[{rawOptionValueRules},

      (*the keys for the Options function are strings sadly*)
      rawOptionValueRules = Options[ExperimentBioLayerInterferometry];

      (* convert the string OptionName into symbols *)
      Map[(ToExpression[First[#]]->Last[#])&, rawOptionValueRules]
    ];

    (* AssayDevelopment specific defaults *)
    assayDevelopmentOptions =   {
      DevelopmentAssociationAbsoluteThreshold,
      DevelopmentAssociationThresholdSlope,
      DevelopmentAssociationThresholdSlopeDuration,
      DevelopmentDissociationAbsoluteThreshold,
      DevelopmentDissociationThresholdSlope,
      DevelopmentDissociationThresholdSlopeDuration,
      DevelopmentReferenceWell,
      TestInteractionSolutions,
      TestBufferSolutions,
      TestRegenerationSolutions,
      TestLoadingSolutions,
      TestActivationSolutions,
      DevelopmentBaselineTime,
      DevelopmentBaselineShakeRate,
      DevelopmentAssociationTime,
      DevelopmentAssociationThresholdCriterion,
      DevelopmentAssociationShakeRate,
      DevelopmentDissociationTime,
      DevelopmentDissociationThresholdCriterion,
      DevelopmentDissociationShakeRate
    };

    (* EpitopeBinning specific defaults *)
    epitopeBinningOptions = {
      LoadAntibodyAbsoluteThreshold,
      LoadAntibodyThresholdSlope,
      LoadAntibodyThresholdSlopeDuration,
      LoadAntigenAbsoluteThreshold,
      LoadAntigenThresholdSlope,
      LoadAntigenThresholdSlopeDuration,
      CompetitionAbsoluteThreshold,
      CompetitionThresholdSlope,
      CompetitionThresholdSlopeDuration,
      BinningQuenchSolution,
      BinningControlWell,
      LoadAntibodyTime,
      LoadAntibodyThresholdCriterion,
      LoadAntibodyShakeRate,
      BinningQuenchTime,
      BinningQuenchShakeRate,
      LoadAntigenTime,
      LoadAntigenThresholdCriterion,
      LoadAntigenShakeRate,
      CompetitionBaselineBuffer,
      CompetitionBaselineTime,
      CompetitionBaselineShakeRate,
      CompetitionTime,
      CompetitionShakeRate,
      CompetitionThresholdCriterion
    };

    (* quantitation specific defaults *)
    quantitationOptions ={
      AmplifiedDetectionSolution,
      QuantitationEnzymeSolution,
      QuantitateTime,
      QuantitateShakeRate,
      AmplifiedDetectionTime,
      AmplifiedDetectionShakeRate,
      QuantitationEnzymeBuffer,
      QuantitationEnzymeTime,
      QuantitationEnzymeShakeRate
    };

    (* non experiment specific defaults *)
    generalOptions = {
      RegenerationType,
      LoadingType,
      LoadSolution,
      ActivateSolution,
      QuenchSolution,
      LoadAbsoluteThreshold,
      LoadThresholdSlope,
      LoadThresholdSlopeDuration,
      Equilibrate,
      EquilibrateTime,
      EquilibrateBuffer,
      EquilibrateShakeRate,
      Blank,
      QuantitationParameters,
      RegenerationSolution,
      RegenerationCycles,
      RegenerationTime,
      RegenerationShakeRate,
      NeutralizationSolution,
      NeutralizationTime,
      NeutralizationShakeRate,
      WashSolution,
      WashTime,
      WashShakeRate,
      LoadTime,
      LoadThresholdCriterion,
      LoadShakeRate,
      ActivateTime,
      ActivateShakeRate,
      QuenchTime,
      QuenchShakeRate
    };

    (*kinetics specific defaults*)
    kineticsOptions ={
      KineticsReferenceType,
      MeasureAssociationAbsoluteThreshold,
      MeasureAssociationThresholdSlope,
      MeasureAssociationThresholdSlopeDuration,
      MeasureDissociationAbsoluteThreshold,
      MeasureDissociationThresholdSlope,
      MeasureDissociationThresholdSlopeDuration,
      MeasureBaselineTime,
      MeasureBaselineShakeRate,
      MeasureAssociationTime,
      MeasureAssociationThresholdCriterion,
      MeasureAssociationShakeRate,
      MeasureDissociationTime,
      MeasureDissociationThresholdCriterion,
      MeasureDissociationShakeRate,
      KineticsDissociationBuffer,
      KineticsBaselineBuffer
    };

    (* join all of the defaults together *)
    allPrimitiveIncompatibleOptions = Join[
      kineticsOptions,
      generalOptions,
      quantitationOptions,
      epitopeBinningOptions,
      assayDevelopmentOptions
    ];

    (* look up the actual option values for the default options *)
    (* the replace rule is to take case or index matched options *)
    primitiveIncompatibleValues = Lookup[fullBLIOptionsAssociation, allPrimitiveIncompatibleOptions]/.{{Null...}->Null, {Automatic...}->Automatic};
    kineticsValues = Lookup[fullBLIOptionsAssociation, kineticsOptions]/.{{Null...}->Null, {Automatic...}->Automatic};
    quantitationValues = Lookup[fullBLIOptionsAssociation, quantitationOptions]/.{{Null...}->Null, {Automatic...}->Automatic};
    epitopeBinningValues = Lookup[fullBLIOptionsAssociation, epitopeBinningOptions]/.{{Null...}->Null, {Automatic...}->Automatic};
    assayDevelopmentValues = Lookup[fullBLIOptionsAssociation, assayDevelopmentOptions]/.{{Null...}->Null, {Automatic...}->Automatic};


    (* -- DILUTIONS -- *)
    (* these are ok to specify along with primitives since they fill out the sample key *)
    (* they are not ok to specify for the wrong experiment type *)
    kineticsDilutionOptions = {
      KineticsSampleSerialDilutions,
      KineticsSampleFixedDilutions,
      KineticsSampleDiluent
    };

    quantitationDilutionOptions = {
      QuantitationStandardSerialDilutions,
      QuantitationStandardFixedDilutions,
      QuantitationStandardDiluent,
      QuantitationStandard,
      QuantitationParameters,
      QuantitationStandardWell
    };

    epitopeBinningSolutionOptions = {
      PreMixSolutions,
      PreMixDiluent,
      BinningAntigen,
      BinningType
    };

    assayDevelopmentDilutionOptions = {
      DetectionLimitSerialDilutions,
      DetectionLimitFixedDilutions,
      DetectionLimitDiluent,
      DevelopmentReferenceWell,
      DevelopmentType
    };

    (*look up the values of the experiment specific but primitive compatible options*)
    (*note that the nulls will have been expanded so we need to replace any {Null...}->Null*)
    kineticsDilutionValues = Lookup[fullBLIOptionsAssociation, kineticsDilutionOptions]/.{{Null...}->Null, {Automatic...}->Automatic};
    quantitationDilutionValues = Lookup[fullBLIOptionsAssociation, quantitationDilutionOptions]/.{{Null...}->Null, {Automatic...}->Automatic};
    epitopeBinningSolutionValues = Lookup[fullBLIOptionsAssociation, epitopeBinningSolutionOptions]/.{{Null...}->Null, {Automatic...}->Automatic};
    developmentDilutionValues = Lookup[fullBLIOptionsAssociation, assayDevelopmentDilutionOptions]/.{{Null...}->Null, {Automatic...}->Automatic};

    (* --- CHECK IF OPTIONS HAVE BEEN CHANGED FROM AUTOMATIC/DEFAULT (USER SPECIFIED) --- *)

    (* determine if the options have been changed by checking the actual against default/automatic value *)
    userInformedKineticsOptions = checkOptionsForUserInput[kineticsValues, kineticsOptions, defaultOptionValueRules];

    (* determine if the options have been changed by checking the actual against default/automatic value *)
    userInformedQuantitationOptions = checkOptionsForUserInput[quantitationValues, quantitationOptions, defaultOptionValueRules];

    (* determine if the options have been changed by checking the actual against default/automatic value *)
    userInformedEpitopeBinningOptions = checkOptionsForUserInput[epitopeBinningValues, epitopeBinningOptions, defaultOptionValueRules];

    (* determine if the options have been changed by checking the actual against default/automatic value *)
    userInformedAssayDevelopmentOptions = checkOptionsForUserInput[assayDevelopmentValues, assayDevelopmentOptions, defaultOptionValueRules];

    (* gather all of the primitive incompatible options that have been changed *)
    userInformedOptions = Join[userInformedKineticsOptions, userInformedQuantitationOptions, userInformedEpitopeBinningOptions, userInformedAssayDevelopmentOptions];

    (* pull out the changes to experiment specific dilution options *)
    userInformedKineticsDilutionsOptions = checkOptionsForUserInput[kineticsDilutionValues, kineticsDilutionOptions, defaultOptionValueRules];
    userInformedQuantitationDilutionsOptions = checkOptionsForUserInput[quantitationDilutionValues, quantitationDilutionOptions, defaultOptionValueRules];
    userInformedEpitopeBinningSolutionsOptions = checkOptionsForUserInput[epitopeBinningSolutionValues, epitopeBinningSolutionOptions, defaultOptionValueRules];
    userInformedAssayDevelopmentDilutionsOptions = checkOptionsForUserInput[developmentDilutionValues, assayDevelopmentDilutionOptions, defaultOptionValueRules];

    (*
    output (in this order):
     1) any options that conflict with primitive input
     2 - 5) any input that is experiment specific
    *)
    {
      userInformedOptions,
      Join[userInformedKineticsOptions, userInformedKineticsDilutionsOptions],
      Join[userInformedQuantitationOptions, userInformedQuantitationDilutionsOptions],
      Join[userInformedEpitopeBinningOptions, userInformedEpitopeBinningSolutionsOptions],
      Join[userInformedAssayDevelopmentOptions, userInformedAssayDevelopmentDilutionsOptions]
    }
  ];

  (* ----------------------------------------- *)
  (* -- THROW THE ERRORS FOR UNUSED OPTIONS -- *)
  (* ----------------------------------------- *)


  (* if there user specified parameters that are being overridden by their primitives, throw a warning*)
  If[
    And[
      Or[
        MatchQ[assaySequencePrimitives, Except[Automatic]],
        MatchQ[Lookup[fullBLIOptionsAssociation, ExpandedAssaySequencePrimitives], Except[Automatic]]
      ],
      !MatchQ[unusedOptionValuesPrimitiveInput, {}],
      !gatherTests,
      Not[MatchQ[$ECLApplication, Engine]]
    ],
    Message[Warning::UnusedOptionValuesBLIPrimitiveInput, unusedOptionValuesPrimitiveInput]
  ];

  (* if the experiment type is Kinetics and there are non-kinetics values specified, throw and error *)
  If[MatchQ[experimentType, Kinetics]&&!MatchQ[Join[unusedOptionValuesQuantitation, unusedOptionValuesEpitopeBinning, unusedOptionValuesAssayDevelopment], {}]&&!gatherTests,
    Message[Error::UnusedBLIOptionValuesKinetics, Join[unusedOptionValuesQuantitation, unusedOptionValuesEpitopeBinning, unusedOptionValuesAssayDevelopment]]
  ];

  (* if the experiment type is Quantitation and there are non-Quantitation values specified, throw and error *)
  If[MatchQ[experimentType, Quantitation]&&!MatchQ[Join[unusedOptionValuesKinetics, unusedOptionValuesEpitopeBinning, unusedOptionValuesAssayDevelopment], {}]&&!gatherTests,
    Message[Error::UnusedBLIOptionValuesQuantitation, Join[unusedOptionValuesKinetics, unusedOptionValuesEpitopeBinning, unusedOptionValuesAssayDevelopment]]
  ];

  (* if the experiment type is EpitopeBinning and there are non-EpitopeBinning values specified, throw and error *)
  If[MatchQ[experimentType, EpitopeBinning]&&!MatchQ[Join[unusedOptionValuesKinetics, unusedOptionValuesQuantitation, unusedOptionValuesAssayDevelopment], {}]&&!gatherTests,
    Message[Error::UnusedBLIOptionValuesEpitopeBinning, Join[unusedOptionValuesKinetics, unusedOptionValuesQuantitation, unusedOptionValuesAssayDevelopment]]
  ];

  (* if the experiment type is AssayDevelopment and there are non-AssayDevelopment values specified, throw and error *)
  If[MatchQ[experimentType, AssayDevelopment]&&!MatchQ[Join[unusedOptionValuesKinetics, unusedOptionValuesQuantitation, unusedOptionValuesEpitopeBinning], {}]&&!gatherTests,
    Message[Error::UnusedBLIOptionValuesAssayDevelopment, Join[unusedOptionValuesKinetics, unusedOptionValuesQuantitation, unusedOptionValuesEpitopeBinning]]
  ];

  (* gather the options from the wrong experiment type into one list. This is important in case the list of the experiment type gets populated by mistake*)

  optionsFromWrongExperimentType = Which[
    MatchQ[experimentType, Kinetics],
    Join[unusedOptionValuesQuantitation, unusedOptionValuesEpitopeBinning, unusedOptionValuesAssayDevelopment],

    MatchQ[experimentType, Quantitation],
    Join[unusedOptionValuesKinetics, unusedOptionValuesEpitopeBinning, unusedOptionValuesAssayDevelopment],

    MatchQ[experimentType, EpitopeBinning],
    Join[unusedOptionValuesKinetics, unusedOptionValuesQuantitation, unusedOptionValuesAssayDevelopment],

    MatchQ[experimentType, AssayDevelopment],
    Join[unusedOptionValuesKinetics, unusedOptionValuesQuantitation, unusedOptionValuesEpitopeBinning]
  ];
  (* -- test for unused values -- *)

  optionsFromWrongExperimentTypeTest = Test["If options are specified, they are relevant to the selected ExperimentType (i.e., Only options for either Kinetics, Quantitiation, EpitopeBinning, or AssayDevelopment experiments are specified):",
    MatchQ[Flatten[optionsFromWrongExperimentType], {}],
    True
  ];

  (* -------------------------------- *)
  (* -- RESOLVE EXPERIMENT OPTIONS -- *)
  (* -------------------------------- *)

  (*If equilibrate is Automatic, set it to True/False based on if the probes are already equilibrated in ProbeRackEquilibration *)
  equilibrate = If[Or[
    !probeRackEquilibration,
    MemberQ[Lookup[fullBLIOptionsAssociation, {EquilibrateTime, EquilibrateBuffer, EquilibrateShakeRate}], Except[(Automatic|Null)]]
  ],
    Lookup[fullBLIOptionsAssociation, Equilibrate]/.{Automatic -> True},
    Lookup[fullBLIOptionsAssociation, Equilibrate]/.{Automatic -> False}
  ];

  (*Set the equilibrate step parameters if equilibration is requested *)
  {
    equilibrateTime,
    equilibrateBuffer,
    equilibrateShakeRate
  } = If[equilibrate,
    {
      Lookup[fullBLIOptionsAssociation,EquilibrateTime]/.{Automatic -> 10 Minute},
      Lookup[fullBLIOptionsAssociation, EquilibrateBuffer]/.{Automatic -> defaultBuffer},
      Lookup[fullBLIOptionsAssociation,EquilibrateShakeRate]/.{Automatic -> 1000 RPM}
    },
    Lookup[fullBLIOptionsAssociation, {EquilibrateTime, EquilibrateBuffer, EquilibrateShakeRate}]/.{Automatic -> Null}
  ];

  (* Set the acquisitionRate *)
  acquisitionRate = Lookup[fullBLIOptionsAssociation, AcquisitionRate];

  (*timer task if there is no Start Delay inserted between loading the instrument and starting the assay. Its basically a start delay.*)
  (* Set probeRackEquilibrationTime to 10 Minutes if the probRackEquilibration has been selected and match the buffer to the default buffer *)
  {
    probeRackEquilibrationTime,
    probeRackEquilibrationBuffer
  } = If[probeRackEquilibration,
    {
      Lookup[fullBLIOptionsAssociation, ProbeRackEquilibrationTime]/.{Automatic -> 10 Minute},
      Lookup[fullBLIOptionsAssociation, ProbeRackEquilibrationBuffer]/.{Automatic -> defaultBuffer}
    },
    Lookup[fullBLIOptionsAssociation, {ProbeRackEquilibrationTime, ProbeRackEquilibrationBuffer}]/.{Automatic -> Null}
  ];

  (* If start delay is automatic, set it based on the temperature, where all non ambient temperatures will get 15 minutes to equilibrate *)
  (* If a longer probe rack equilibration is requested, the delay will get set to that *)
  {
    startDelay,
    startDelayShake
  } = If[Not[MatchQ[Lookup[fullBLIOptionsAssociation, Temperature], AmbientTemperatureP]],
    {
      Lookup[fullBLIOptionsAssociation, StartDelay]/.{Automatic -> probeRackEquilibrationTime},
      Lookup[fullBLIOptionsAssociation, StartDelayShake]/.{Automatic -> False}
    },
    {
      Lookup[fullBLIOptionsAssociation, StartDelay]/.{Automatic-> Max[probeRackEquilibrationTime/.(Null -> 0 Minute), 15 Minute]},
      Lookup[fullBLIOptionsAssociation, StartDelayShake]/.{Automatic -> True}
    }
  ];

  (* all of the references are default values - they may not be relevant but should still be fine to set blank based on these values *)
  blank = If[Or[
    MemberQ[Flatten[{ToList[kineticsReferenceType], ToList[quantitationParameters], ToList[developmentReferenceWell]}], (Blank|BlankWell)],
    MatchQ[Lookup[fullBLIOptionsAssociation, BinningControlWell], True]
  ],
    Lookup[fullBLIOptionsAssociation, Blank]/.{Automatic -> defaultBuffer},
    Lookup[fullBLIOptionsAssociation, Blank]/.{Automatic-> Null}
  ];

  (* ------------------------------------ *)
  (* -- GENERAL WARNINGS FOR CONFLICTS -- *)
  (* ------------------------------------ *)

  (* -- DETERMINE THE OFFENDING OPTIONS -- *)

  (* equilibration parameters will not be used if Equilibrate is set to false, so if they were set we need to throw a warning *)
  unusedEquilibrateOptions = If[MatchQ[equilibrate, False],
    PickList[
      {EquilibrateBuffer, EquilibrateTime, EquilibrateShakeRate},
      {equilibrateBuffer, equilibrateTime, equilibrateShakeRate},
      Except[Null]
    ],
    {}
  ];

  (* if there are parameters specified for how to do probe rack equiilbration but proberackequilibration option si False, warn the user *)
  unusedProbeRackEquilibrationOptions = If[MatchQ[probeRackEquilibration, False],
    PickList[
      {ProbeRackEquilibrationTime, ProbeRackEquilibrationBuffer},
      {probeRackEquilibrationTime, probeRackEquilibrationBuffer},
      Except[Null]
    ],
    {}
  ];

  (* also warn if probe rack equilibratino has been called for but has Null parameters *)
  missingProbeRackEquilibrationOptions = If[MatchQ[probeRackEquilibration, True],
    PickList[
      {ProbeRackEquilibrationTime, ProbeRackEquilibrationBuffer},
      {probeRackEquilibrationTime, probeRackEquilibrationBuffer},
      Null
    ],
    {}
  ];

  (* if the start delay options are in conflict, return them *)
  conflictingStartDelayOptions = If[Or[
    MatchQ[startDelayShake, Null]&&MatchQ[startDelay, Except[Null]],
    MatchQ[startDelay, Null]&&MatchQ[startDelayShake, True]
  ],
    {StartDelay, StartDelayShake},
    {}
  ];

  (* if startDelay is Null and ProbeRackEquilibrationTime is set or if it is less than  *)
  conflictingDelayOptions = If[
    Or[
      MatchQ[startDelay, Null]&&MatchQ[probeRackEquilibrationTime, Except[Null]],
      MatchQ[probeRackEquilibrationTime, Except[Null]]&&MatchQ[startDelay, LessP[probeRackEquilibrationTime]]
    ],
    {ProbeRackEquilibrationTime, StartDelay},
    {}
  ];

  (* throw the error for conflicting options *)
  If[!MatchQ[conflictingDelayOptions, {}]&&!gatherTests,
    Message[Error::BLIStartDelayMismatch]
  ];

  (* test for conflicting delay options *)
  conflictingDelayOptionsTest = If[gatherTests,
    Test["If ProbeRackEquilibration is used, the time is consistent with the StartDelay:",
      MatchQ[conflictingDelayOptions, {}],
      True
    ],
    Null
  ];

  (* check to see it we are overriding the Standard with QuantitationStandard. The experiment type shoudl be Quantitaiton for this warning *)
  If[
    And[
      MatchQ[Lookup[fullBLIOptionsAssociation, Standard], Except[Null]],
      MatchQ[Lookup[fullBLIOptionsAssociation, QuantitationStandard], Except[(Null|Automatic)]],
      MatchQ[experimentType, Quantitation],
      !gatherTests,
      Not[MatchQ[$ECLApplication, Engine]]
  ],
    Message[Warning::UnusedBLIStandard]
  ];

  (* -- THROW THE WARNINGS -- *)

  (* the warning for unused parameters in equilibrate *)
  If[!MatchQ[unusedEquilibrateOptions, {}]&&!gatherTests&&Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::UnusedBLIEquilibrateOptions, unusedEquilibrateOptions]
  ];

  (* the warning for unused parameters in probe rack equilibration *)
  If[!MatchQ[unusedProbeRackEquilibrationOptions, {}]&&!gatherTests&&Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::UnusedBLIProbeEquilibrationOptions, unusedProbeRackEquilibrationOptions]
  ];

  (* the warning for missing parameters in probe rack equilibration *)
  If[!MatchQ[missingProbeRackEquilibrationOptions, {}]&&!gatherTests&&Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::MissingBLIProbeEquilibrationOptions, missingProbeRackEquilibrationOptions]
  ];

  (* the warning for conflicting start delay parameters *)
  If[!MatchQ[conflictingStartDelayOptions, {}]&&!gatherTests&&Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::BLIConflictingStartDelayOptions, conflictingStartDelayOptions]
  ];

  (* ---------------------------------- *)
  (* --- Resolve Regenerate options --- *)
  (* ---------------------------------- *)

  (* lookup the regeneration type and make sure it is a list *)
  regenerationType = ToList[Lookup[fullBLIOptionsAssociation, RegenerationType]];

  (* If regeneration steps are requested, the regeneration fields will be turned on and default values will be selected. *)
  {
    regenerationSolution,
    regenerationCycles,
    regenerationTime,
    regenerationShakeRate
  } = If[MemberQ[regenerationType, Regenerate],
    {
      Lookup[fullBLIOptionsAssociation, RegenerationSolution]/.{Automatic -> Model[Sample, StockSolution, "2 M HCl"]},
      Lookup[fullBLIOptionsAssociation, RegenerationCycles]/.{Automatic -> 3},
      Lookup[fullBLIOptionsAssociation, RegenerationTime]/.{Automatic -> 5 Second},
      Lookup[fullBLIOptionsAssociation, RegenerationShakeRate]/.{Automatic -> 1000 RPM}
    },
    Lookup[fullBLIOptionsAssociation, {RegenerationSolution,RegenerationCycles,RegenerationTime,RegenerationShakeRate}]/.{Automatic -> Null}
  ];

  (* if wash steps are requested, resolve any unspecified parameters to default values *)
  {
    washSolution,
    washTime,
    washShakeRate
  } = If[MemberQ[regenerationType, Wash],
    {
      Lookup[fullBLIOptionsAssociation, WashSolution]/.{Automatic -> defaultBuffer},
      Lookup[fullBLIOptionsAssociation, WashTime]/.{Automatic -> 5 Second},
      Lookup[fullBLIOptionsAssociation, WashShakeRate]/.{Automatic -> 1000 RPM}
    },
    Lookup[fullBLIOptionsAssociation, {WashSolution, WashTime, WashShakeRate}]/.{Automatic -> Null}
  ];

  (* If neutralize is selected, set neutralizationSolution, neutralizationTime, and neutralizationShakeRate to automatic values if they are not informed *)
  {
    neutralizationSolution,
    neutralizationTime,
    neutralizationShakeRate
  } = If[MemberQ[regenerationType, Neutralize],
    {
      Lookup[fullBLIOptionsAssociation, NeutralizationSolution]/.{Automatic -> defaultBuffer},
      Lookup[fullBLIOptionsAssociation, NeutralizationTime]/.{Automatic -> 5 Second},
      Lookup[fullBLIOptionsAssociation, NeutralizationShakeRate]/.{Automatic -> 1000 RPM}
    },
    Lookup[fullBLIOptionsAssociation, {NeutralizationSolution, NeutralizationTime, NeutralizationShakeRate}]/.{Automatic -> Null}
  ];


  (* -- REGENERATE ERRORS -- *)

  (* if precondition is set but nothing else is, it needs to be set *)
  If[!MemberQ[regenerationType, (Regenerate|Neutralize|Wash)]&&MemberQ[regenerationType, PreCondition]&&!gatherTests&&Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::BLIRegenerationNotSpecified]
  ];

  (*determine any unsued parameters that are set, but the correspondign RegenerationType is not set*)
  unusedRegenerationOptions = If[!MemberQ[regenerationType, Regenerate],
    PickList[
      {RegenerationSolution, RegenerationTime, RegenerationShakeRate},
      {regenerationSolution, regenerationTime, regenerationShakeRate},
      Except[Null]
    ],
    {}
  ];

  (* determine any unused parameters that are set but not called *)
  unusedNeutralizeOptions = If[!MemberQ[regenerationType, Neutralize],
    PickList[
      {NeutralizationSolution, NeutralizationTime, NeutralizationShakeRate},
      {neutralizationSolution, neutralizationTime, neutralizationShakeRate},
      Except[Null]
    ],
    {}
  ];

  (* determine any unused parameters that are set but not called *)
  unusedWashOptions = If[!MemberQ[regenerationType, Wash],
    PickList[
      {WashSolution, WashTime, WashShakeRate},
      {washSolution, washTime, washShakeRate},
      Except[Null]
    ],
    {}
  ];

  (* Warn the use if they have specified solutions, time, etc that wont be used because the flag in RegenertionParameters is no on *)
  If[!MatchQ[unusedRegenerationOptions,{}]&&!gatherTests&&Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::UnusedBLIRegenerationOptions, unusedRegenerationOptions]
  ];
  If[!MatchQ[unusedNeutralizeOptions,{}]&&!gatherTests&&Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::UnusedBLINeutralizeOptions, unusedNeutralizeOptions]
  ];
  If[!MatchQ[unusedWashOptions,{}]&&!gatherTests&&Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::UnusedBLIWashOptions, unusedWashOptions]
  ];


  (* ---------------------------- *)
  (* --- Resolve Load options --- *)
  (* ---------------------------- *)

  (* lookup the loading type and convert to list in case it is a single value *)
  loadingType = ToList[Lookup[fullBLIOptionsAssociation, LoadingType]];

  (* If Load is included in LoadingType, automatically resolve the loading step Time, ShakeRate. Also since screen interaction is different it should do the same *)
  {
    loadTime,
    loadShakeRate
  } = If[Or[MemberQ[loadingType, Load], MatchQ[Lookup[bliOptionsAssociation, DevelopmentType], ScreenInteraction]],
    {
      Lookup[fullBLIOptionsAssociation, LoadTime]/.{Automatic -> 15 Minute},
      Lookup[fullBLIOptionsAssociation, LoadShakeRate]/.{Automatic -> 1000 RPM}
    },
    Lookup[fullBLIOptionsAssociation, {LoadTime, LoadShakeRate}]/.{Automatic -> Null}
  ];

  (* if any load threshold parameters are set, set the criterion to all *)
  loadThresholdCriterion = If[MemberQ[{loadThresholdSlope, loadThresholdSlopeDuration, loadAbsoluteThreshold}, Except[Null]],
    Lookup[fullBLIOptionsAssociation, LoadThresholdCriterion]/.{Automatic -> Single},
    Lookup[fullBLIOptionsAssociation, LoadThresholdCriterion]/.{Automatic -> Null}
  ];

  (* If Activate is selected in LoadingType, set the default values *)
  {
    activateSolution,
    activateTime,
    activateShakeRate
  } = If[MemberQ[loadingType, Activate],
    {
      Lookup[fullBLIOptionsAssociation, ActivateSolution]/.{Automatic -> defaultBuffer},
      Lookup[fullBLIOptionsAssociation, ActivateTime]/.{Automatic -> 1 Minute},
      Lookup[fullBLIOptionsAssociation, ActivateShakeRate]/.{Automatic -> 1000 RPM}
    },
    Lookup[fullBLIOptionsAssociation, {ActivateSolution, ActivateTime, ActivateShakeRate}]/.{Automatic -> Null}
  ];

  (* If Quench is selected in LoadingType, set the default values *)

  {
    quenchSolution,
    quenchTime,
    quenchShakeRate
  } = If[MemberQ[loadingType, Quench],
    {
      Lookup[fullBLIOptionsAssociation, QuenchSolution]/.{Automatic -> defaultBuffer},
      Lookup[fullBLIOptionsAssociation, QuenchTime]/.{Automatic -> 1 Minute},
      Lookup[fullBLIOptionsAssociation, QuenchShakeRate]/.{Automatic -> 1000 RPM}
    },
    Lookup[fullBLIOptionsAssociation, {QuenchSolution, QuenchTime, QuenchShakeRate}]/.{Automatic -> Null}
  ];


  (* -------------------- *)
  (* -- LOAD CONFLICTS -- *)
  (* -------------------- *)

  (* if loading conditions are specified but loadignType deosn't include Load, return the options that were set but wont be used *)
  (*  Note that the reverse case, where LoadingType -> {Load} but there is no LoadingSolution may be ok since there are multiple options that the laoding solution *)

  unusedLoadParameters =   If[And[!MemberQ[loadingType, Load], !MatchQ[Lookup[bliOptionsAssociation, DevelopmentType], ScreenInteraction]],
    PickList[
      {LoadSolution, LoadShakeRate, LoadTime, LoadThresholdSlope, LoadThresholdSlopeDuration, LoadAbsoluteThreshold, LoadThresholdCriterion},
      {loadSolution, loadShakeRate, loadTime, loadThresholdSlope, loadThresholdSlopeDuration, loadAbsoluteThreshold, loadThresholdCriterion},
      Except[Null]
    ],
    {}
  ];

  (* if activation conditions are specified but loadingType doesn't include Activate, determine which parameters aren't used *)
  unusedActivateParameters = If[!MemberQ[loadingType, Activate],
    PickList[{ActivateSolution, ActivateShakeRate, ActivateTime},{activateSolution, activateShakeRate, activateTime}, Except[Null]],
    {}
  ];

  (* if quench conditions are specified but loadingType doesn't include Quench, determine which parameters wont be used *)
  unusedQuenchParameters = If[!MemberQ[loadingType, Quench],
    PickList[{QuenchSolution, QuenchShakeRate, QuenchTime},{quenchSolution, quenchShakeRate, quenchTime}, Except[Null]],
    {}
  ];

  (* throw the errors fo unues parameters *)
  If[!MatchQ[unusedLoadParameters, {}]&&!gatherTests,
    Message[Error::BLISetLoadingType, Load, Flatten[unusedLoadParameters]]
  ];

  If[!MatchQ[unusedActivateParameters, {}]&&!gatherTests,
    Message[Error::BLISetLoadingType, Activate, Flatten[unusedActivateParameters]]
  ];

  If[!MatchQ[unusedQuenchParameters, {}]&&!gatherTests,
    Message[Error::BLISetLoadingType, Quench, Flatten[unusedQuenchParameters]]
  ];

  (* make the appropriate tests for unused load, quench, activate options*)
  unusedLoadParametersTest = If[gatherTests,
    Test["If load related options are specified, the LoadingType includes Load:",
      MatchQ[unusedLoadParameters, {}],
      True
    ],
    Null
  ];

  unusedActivateParametersTest = If[gatherTests,
    Test["If activates related options are specified, the LoadingType includes Activate:",
      MatchQ[unusedActivateParameters, {}],
      True
    ],
    Null
  ];

  unusedQuenchParametersTest = If[gatherTests,
    Test["If quench related options are specified, the LoadingType includes Quench:",
      MatchQ[unusedQuenchParameters, {}],
      True
    ],
    Null
  ];

  (* -------------------------------------- *)
  (* --- EXPERIMENT SPECIFIC PARAMETERS --- *)
  (* -------------------------------------- *)

  (*Note: the parameters for association, dissociation, baseline could be index matched in the future. This will require an overhaul, and changes in how expanded/contracted primtiives work.*)
  (*Note: the primitive may no longer be collapsable, in which case we will probably have to remove the assaySequencePrimitive and replace it with the expanded one.*)

  (* KINETICS *)
  (* setup a relationship for the Kinetics-specific parameters automatic resolution - this will keep everything index matched so that it is easier to modify defaults or keys *)
  kineticsDefaultRelation = {
    kineticsBaselineBuffer -> defaultBuffer,
    measureBaselineTime -> 30 Second,
    measureBaselineShakeRate -> 1000 RPM,
    measureAssociationTime -> 15 Minute,
    measureAssociationShakeRate -> 1000 RPM,
    measureAssociationThresholdCriterion -> Single,
    kineticsDissociationBuffer -> defaultBuffer,
    measureDissociationTime -> 30 Minute,
    measureDissociationShakeRate -> 1000 RPM,
    measureDissociationThresholdCriterion -> Single
  };


  (* pull out the default values, the keys, and the resolved option names, which are Decapitalized *)
  kineticsDefaults = Last/@kineticsDefaultRelation;
  resolvedKineticsOptions = First/@kineticsDefaultRelation;
  kineticsKeys = {KineticsBaselineBuffer, MeasureBaselineTime,
    MeasureBaselineShakeRate, MeasureAssociationTime,
    MeasureAssociationShakeRate, MeasureAssociationThresholdCriterion,
    KineticsDissociationBuffer, MeasureDissociationTime,
    MeasureDissociationShakeRate, MeasureDissociationThresholdCriterion};

  (* make the rules that we will substitute values into durign resolution *)
  kineticsRules = MapThread[(#1->#2)&,{kineticsKeys,resolvedKineticsOptions}];


  (* QUANTITATION *)
  (* set up lists of Quantitation-specific parameters so that they can easily be set to Null *)
  (* NOTE: the order of these keys MUST MATCH the order of option resolution in the Experiment Type block *)
  quantitationKeys = {
    QuantitationStandard,
    QuantitationStandardWell,
    QuantitateTime,
    QuantitateShakeRate,
    AmplifiedDetectionTime,
    AmplifiedDetectionShakeRate,
    QuantitationEnzymeTime,
    QuantitationEnzymeShakeRate,
    QuantitationEnzymeBuffer,
    QuantitationStandardFixedDilutions,
    QuantitationStandardDiluent
  };
  resolvedQuantitationOptions = ToExpression[Decapitalize[ToString/@quantitationKeys]];

  (* make the rules that we will substitute values into durign resolution *)
  quantitationRules = MapThread[(#1->#2)&,{quantitationKeys,resolvedQuantitationOptions}];

  (* EPITOPE BINNING *)
  (* set up lists of EpitopeBinning-specific parameters so they can be easily be set to Null *)
  (* NOTE: the order of these keys MUST MATCH the order of option resolution in the Experiment Type block *)
  epitopeBinningKeys = {
    BinningType,
    BinningControlWell,
    LoadAntibodyTime,
    LoadAntibodyShakeRate,
    LoadAntibodyThresholdCriterion,
    BinningQuenchTime,
    BinningQuenchShakeRate,
    LoadAntigenTime,
    LoadAntigenShakeRate,
    LoadAntigenThresholdCriterion,
    CompetitionBaselineBuffer,
    CompetitionBaselineTime,
    CompetitionBaselineShakeRate,
    CompetitionTime,
    CompetitionShakeRate,
    CompetitionThresholdCriterion,
    PreMixDiluent
  };
  resolvedEpitopeBinningOptions = ToExpression[Decapitalize[ToString/@epitopeBinningKeys]];

  (* make the rules that we will substitute values into durign resolution *)
  epitopeBinningRules = MapThread[(#1->#2)&,{epitopeBinningKeys,resolvedEpitopeBinningOptions}];

  (* ASSAY DEVELOPMENT *)
  (* set up lists of AssayDevelopment specific parameters so they can be easily be set to Null *)
  (* NOTE: the order of these keys MUST MATCH the order of option resolution in the Experiment Type block *)
  assayDevelopmentKeys = {
    DevelopmentType,
    DevelopmentBaselineTime,
    DevelopmentBaselineShakeRate,
    DevelopmentAssociationTime,
    DevelopmentAssociationShakeRate,
    DevelopmentAssociationThresholdCriterion,
    DevelopmentDissociationShakeRate,
    DevelopmentDissociationTime,
    DevelopmentDissociationThresholdCriterion
  };
  resolvedAssayDevelopmentOptions = ToExpression[Decapitalize[ToString/@assayDevelopmentKeys]];

  (* make the rules that we will substitute values into durign resolution *)
  assayDevelopmentRules = MapThread[(#1->#2)&,{assayDevelopmentKeys,resolvedAssayDevelopmentOptions}];



  (* --------------------------------------------- *)
  (* -- RESOLVE THE EXPERIMENT SPECIFIC OPTIONS -- *)
  (* --------------------------------------------- *)

  (* automatically resolve parameters of the given experiment type, adn set others to null. There is no error collection here because these will get checked in the primitives. *)
  {
    resolvedKineticsParameters,
    resolvedQuantitationParameters,
    resolvedEpitopeBinningParameters,
    resolvedAssayDevelopmentParameters
  }= Switch[Lookup[fullBLIOptionsAssociation, ExperimentType],
    (* --- KINETICS --- *)
    (* Resolve Kinetics specific parameters, setting the others to null if not specified *)
    Kinetics,
    {
      MapThread[(#1 -> Lookup[fullBLIOptionsAssociation, #1]/.{Automatic -> #2})&, {kineticsKeys, kineticsDefaults}],
      Map[(# -> (Lookup[fullBLIOptionsAssociation, #]/.{Automatic -> Null}))&, quantitationKeys],
      Map[(# -> (Lookup[fullBLIOptionsAssociation, #]/.{Automatic -> Null}))&, epitopeBinningKeys],
      Map[(# -> (Lookup[fullBLIOptionsAssociation, #]/.{Automatic -> Null}))&, assayDevelopmentKeys]
    },


    (* --- QUANTITATION --- *)
    (* Resolve Quantitation specific parameters, setting the others to null if not specified *)
    Quantitation,
    {
      Map[(# -> (Lookup[fullBLIOptionsAssociation, #]/.{Automatic -> Null}))&, kineticsKeys],
      Flatten[
        {
          (* set the quantitation standard to standard (the solution). We don't have to worry that standard is informed here, that error will be thrown in primitive resolution. *)
          QuantitationStandard -> If[MemberQ[ToList[quantitationParameters], (StandardCurve|StandardWell)],
            Lookup[fullBLIOptionsAssociation, QuantitationStandard]/.{Automatic -> standard},
            Lookup[fullBLIOptionsAssociation, QuantitationStandard]/.{Automatic -> Null}
          ],

          (*this is a little tricky - if quantitationstandard is set to automatic, we can set the standard well automatic to standard. Otherwise we can set it to quantitationStandard*)
          (* set the solution that will occupy the standard well *)
          QuantitationStandardWell -> If[MemberQ[ToList[quantitationParameters], StandardWell],
            If[MatchQ[Lookup[fullBLIOptionsAssociation, QuantitationStandard], Automatic],
              Lookup[fullBLIOptionsAssociation, QuantitationStandardWell]/.{Automatic -> standard},
              Lookup[fullBLIOptionsAssociation, QuantitationStandardWell]/.{Automatic -> Lookup[fullBLIOptionsAssociation, QuantitationStandard]}
            ],
            Lookup[fullBLIOptionsAssociation, QuantitationStandardWell]/.{Automatic -> Null}
          ],

          (* set the quantitate step parameters, which apply whenever the probe is dipped in the sample solution *)
          QuantitateTime -> Lookup[fullBLIOptionsAssociation, QuantitateTime]/.{Automatic -> 5 Minute},
          QuantitateShakeRate -> Lookup[fullBLIOptionsAssociation, QuantitateShakeRate]/.{Automatic -> 1000 RPM},

          (* resolve the parameters related to an amplified detection step *)
          (* since we resolve these all together, we need to mapthread to get the association out *)
          MapThread[(#1 -> #2)&,
            {
              {AmplifiedDetectionTime, AmplifiedDetectionShakeRate},
              If[MemberQ[ToList[quantitationParameters], AmplifiedDetection],
                {
                  Lookup[fullBLIOptionsAssociation, AmplifiedDetectionTime]/.{Automatic -> 5 Minute},
                  Lookup[fullBLIOptionsAssociation, AmplifiedDetectionShakeRate]/.{Automatic -> 1000 RPM}
                },
                {
                  Lookup[fullBLIOptionsAssociation, AmplifiedDetectionTime]/.{Automatic -> Null},
                  Lookup[fullBLIOptionsAssociation, AmplifiedDetectionShakeRate]/.{Automatic -> Null}
                }
              ]
            }
          ],

          (* resolve the parameters related to a quantitation enzyme step (where the probe is dipped in enzyme after sample is adsorbed to the surface) *)
          (* since we resolve these all together, we need to mapthread to get the association out *)
          MapThread[(#1 -> #2)&,
            {
              {QuantitationEnzymeTime, QuantitationEnzymeShakeRate, QuantitationEnzymeBuffer},
              If[MemberQ[ToList[quantitationParameters], EnzymeLinked],
                {
                  Lookup[fullBLIOptionsAssociation, QuantitationEnzymeTime]/.{Automatic -> 5 Minute},
                  Lookup[fullBLIOptionsAssociation, QuantitationEnzymeShakeRate]/.{Automatic -> 1000 RPM},
                  Lookup[fullBLIOptionsAssociation, QuantitationEnzymeBuffer]/.{Automatic -> defaultBuffer}
                },
                {
                  Lookup[fullBLIOptionsAssociation, QuantitationEnzymeTime]/.{Automatic -> Null},
                  Lookup[fullBLIOptionsAssociation, QuantitationEnzymeShakeRate]/.{Automatic -> Null},
                  Lookup[fullBLIOptionsAssociation, QuantitationEnzymeBuffer]/.{Automatic -> Null}
                }
              ]
            }
          ],

          (* resolve the standard curve, if requested. The default here is to allow either user specified dilution, and throw an error later if they are in conflict. *)
          QuantitationStandardFixedDilutions -> If[MemberQ[ToList[quantitationParameters], StandardCurve],
            If[
              MatchQ[Lookup[fullBLIOptionsAssociation, QuantitationStandardSerialDilutions],(Null|{Null...})],
              Lookup[fullBLIOptionsAssociation, QuantitationStandardFixedDilutions]/.{Automatic-> {{2, "2x standard dilution"},{4, "4x standard dilution"},{8, "8x standard dilution"},{16, "16x standard dilution"},{32, "32x standard dilution"}, {64, "64x standard dilution"},{128,"128x standard dilution"}}},
              Lookup[fullBLIOptionsAssociation, QuantitationStandardFixedDilutions]/.{Automatic-> Null}
            ],
            Lookup[fullBLIOptionsAssociation, QuantitationStandardFixedDilutions]/.{Automatic-> Null}
          ],

          (* set the quantitation dilution parameter and the diluent if dilutions are requested. Set the dilutions to Null if there are serial dilutions, but still set the buffer *)
          QuantitationStandardDiluent -> If[MemberQ[ToList[quantitationParameters], StandardCurve],
            Lookup[fullBLIOptionsAssociation, QuantitationStandardDiluent]/.{Automatic -> defaultBuffer},
            Lookup[fullBLIOptionsAssociation, QuantitationStandardDiluent]/.{Automatic -> Null}
          ]
        }
      ],
      Map[(# -> (Lookup[fullBLIOptionsAssociation, #]/.{Automatic -> Null}))&, epitopeBinningKeys],
      Map[(# -> (Lookup[fullBLIOptionsAssociation, #]/.{Automatic -> Null}))&, assayDevelopmentKeys]
    },

    (* --- EPITOPEBINNING --- *)
    (* Resolve EpitopeBinning specific parameters, setting the others to null if not specified *)
    EpitopeBinning,
    {
      Map[(# -> (Lookup[fullBLIOptionsAssociation, #]/.{Automatic -> Null}))&, kineticsKeys],
      Map[(# -> (Lookup[fullBLIOptionsAssociation, #]/.{Automatic -> Null}))&, quantitationKeys],

      (* Resolve the experiment specific parameters, in the order that the assay runs. The default type is Sandwich. *)
      {
        BinningType -> Lookup[fullBLIOptionsAssociation, BinningType]/.{Automatic-> Sandwich},
        BinningControlWell -> Lookup[fullBLIOptionsAssociation, BinningControlWell]/.{Automatic-> False},
        LoadAntibodyTime -> Lookup[fullBLIOptionsAssociation, LoadAntibodyTime]/.{Automatic-> 10 Minute},
        LoadAntibodyShakeRate -> Lookup[fullBLIOptionsAssociation, LoadAntibodyShakeRate]/.{Automatic-> 1000 RPM},

        (* ThresholdCriterion is set to All because you would want all of the probes to be sufficiently loaded. We assume that if any of the threshold parameters are informed, they are want a threshold. Malformed Threshold input is dealt with in the primitives. *)
        LoadAntibodyThresholdCriterion -> If[MemberQ[Lookup[fullBLIOptionsAssociation, {LoadAntibodyAbsoluteThreshold, LoadAntibodyThresholdSlope, LoadAntibodyThresholdSlopeDuration}], Except[Null]],
          Lookup[fullBLIOptionsAssociation, LoadAntibodyThresholdCriterion]/.{Automatic -> All},
          Lookup[fullBLIOptionsAssociation, LoadAntibodyThresholdCriterion]/.{Automatic -> Null}
        ],
        BinningQuenchTime -> Lookup[fullBLIOptionsAssociation, BinningQuenchTime]/.{Automatic-> 5 Minute},
        BinningQuenchShakeRate -> Lookup[fullBLIOptionsAssociation, BinningQuenchShakeRate]/.{Automatic-> 1000 RPM},
        LoadAntigenTime -> Lookup[fullBLIOptionsAssociation, LoadAntigenTime]/.{Automatic-> 10 Minute},
        LoadAntigenShakeRate -> Lookup[fullBLIOptionsAssociation, LoadAntigenShakeRate]/.{Automatic-> 1000 RPM},

        (* see the comment above for LoadAntibodyThresholdCriterion, its the same logic *)
        LoadAntigenThresholdCriterion -> If[MemberQ[Lookup[fullBLIOptionsAssociation, {LoadAntigenAbsoluteThreshold, LoadAntigenThresholdSlope, LoadAntigenThresholdSlopeDuration}], Except[Null]],
          Lookup[fullBLIOptionsAssociation, LoadAntigenThresholdCriterion]/.{Automatic -> All},
          Lookup[fullBLIOptionsAssociation, LoadAntigenThresholdCriterion]/.{Automatic -> Null}
        ],
        CompetitionBaselineBuffer -> Lookup[fullBLIOptionsAssociation, CompetitionBaselineBuffer]/.{Automatic-> defaultBuffer},
        CompetitionBaselineTime -> Lookup[fullBLIOptionsAssociation, CompetitionBaselineTime]/.{Automatic-> 30 Second},
        CompetitionBaselineShakeRate -> Lookup[fullBLIOptionsAssociation, CompetitionBaselineShakeRate]/.{Automatic-> 1000 RPM},
        CompetitionTime -> Lookup[fullBLIOptionsAssociation, CompetitionTime]/.{Automatic-> 10 Minute},
        CompetitionShakeRate -> Lookup[fullBLIOptionsAssociation, CompetitionShakeRate]/.{Automatic-> 1000 RPM},

        (* This criterion is set to All in expectation that the suer will employ a slope based threshold. If they choose to use an absolute threshold, the experiment will just time out - no harm done *)
        CompetitionThresholdCriterion -> If[MemberQ[Lookup[fullBLIOptionsAssociation, {CompetitionAbsoluteThreshold, CompetitionThresholdSlope, CompetitionThresholdSlopeDuration}], Except[Null]],
          Lookup[fullBLIOptionsAssociation, CompetitionThresholdCriterion]/.{Automatic -> All},
          Lookup[fullBLIOptionsAssociation, CompetitionThresholdCriterion]/.{Automatic -> Null}
        ],
        PreMixDiluent -> Lookup[fullBLIOptionsAssociation, PreMixDiluent]/.{Automatic-> defaultBuffer}
      },
      Map[(# -> (Lookup[fullBLIOptionsAssociation, #]/.{Automatic -> Null}))&, assayDevelopmentKeys]
    },


    (* --- ASSAYDEVELOPMENT --- *)
    (* Resolve AssayDevelopment specific parameters, setting the others to null if not specified *)
    AssayDevelopment,
    {
      Map[(# -> (Lookup[fullBLIOptionsAssociation, #]/.{Automatic -> Null}))&, kineticsKeys],
      Map[(# -> (Lookup[fullBLIOptionsAssociation, #]/.{Automatic -> Null}))&, quantitationKeys],
      Map[(# -> (Lookup[fullBLIOptionsAssociation, #]/.{Automatic -> Null}))&, epitopeBinningKeys],
      {
        DevelopmentType -> Lookup[fullBLIOptionsAssociation, DevelopmentType]/.{Automatic -> ScreenDetectionLimit},
        DevelopmentBaselineTime -> Lookup[fullBLIOptionsAssociation, DevelopmentBaselineTime]/.{Automatic -> 30 Second},
        DevelopmentBaselineShakeRate -> Lookup[fullBLIOptionsAssociation, DevelopmentBaselineShakeRate]/.{Automatic -> 1000 RPM},
        DevelopmentAssociationTime -> Lookup[fullBLIOptionsAssociation, DevelopmentAssociationTime]/.{Automatic -> 15 Minute},
        DevelopmentAssociationShakeRate -> Lookup[fullBLIOptionsAssociation, DevelopmentAssociationShakeRate]/.{Automatic -> 1000 RPM},
        DevelopmentAssociationThresholdCriterion -> If[MemberQ[Lookup[fullBLIOptionsAssociation, {DevelopmentAssociationAbsoluteThreshold, DevelopmentAssociationThresholdSlope, DevelopmentAssociationThresholdSlopeDuration}], Except[Null]],
          Lookup[fullBLIOptionsAssociation, DevelopmentAssociationThresholdCriterion]/.{Automatic -> All},
          Lookup[fullBLIOptionsAssociation, DevelopmentAssociationThresholdCriterion]/.{Automatic -> Null}
        ],
        DevelopmentDissociationShakeRate -> Lookup[fullBLIOptionsAssociation, DevelopmentDissociationShakeRate]/.{Automatic -> 1000 RPM},
        DevelopmentDissociationTime -> Lookup[fullBLIOptionsAssociation, DevelopmentDissociationTime]/.{Automatic -> 30 Minute},
        DevelopmentDissociationThresholdCriterion -> If[MemberQ[Lookup[fullBLIOptionsAssociation, {DevelopmentDissociationAbsoluteThreshold, DevelopmentDissociationThresholdSlope, DevelopmentDissociationThresholdSlopeDuration}], Except[Null]],
          Lookup[fullBLIOptionsAssociation, DevelopmentDissociationThresholdCriterion]/.{Automatic -> All},
          Lookup[fullBLIOptionsAssociation, DevelopmentDissociationThresholdCriterion]/.{Automatic -> Null}
        ]
      }
    }
  ];

  (* set the parameters to their resolved values *)
  (*kinetics parameters*)
  kineticsBaselineBuffer = KineticsBaselineBuffer/.resolvedKineticsParameters;
  measureBaselineTime = MeasureBaselineTime/.resolvedKineticsParameters;
  measureBaselineShakeRate = MeasureBaselineShakeRate/.resolvedKineticsParameters;
  measureAssociationTime = MeasureAssociationTime/.resolvedKineticsParameters;
  measureAssociationShakeRate = MeasureAssociationShakeRate/.resolvedKineticsParameters;
  measureAssociationThresholdCriterion = MeasureAssociationThresholdCriterion/.resolvedKineticsParameters;
  kineticsDissociationBuffer = KineticsDissociationBuffer/.resolvedKineticsParameters;
  measureDissociationTime = MeasureDissociationTime/.resolvedKineticsParameters;
  measureDissociationShakeRate = MeasureDissociationShakeRate/.resolvedKineticsParameters;
  measureDissociationThresholdCriterion = MeasureDissociationThresholdCriterion/.resolvedKineticsParameters;

  (* resolved quantitation parameters *)
  quantitationStandard = QuantitationStandard/.resolvedQuantitationParameters;
  quantitationStandardWell = QuantitationStandardWell/.resolvedQuantitationParameters;
  quantitateTime = QuantitateTime/.resolvedQuantitationParameters;
  quantitateShakeRate = QuantitateShakeRate/.resolvedQuantitationParameters;
  amplifiedDetectionTime = AmplifiedDetectionTime/.resolvedQuantitationParameters;
  amplifiedDetectionShakeRate = AmplifiedDetectionShakeRate/.resolvedQuantitationParameters;
  quantitationEnzymeTime = QuantitationEnzymeTime/.resolvedQuantitationParameters;
  quantitationEnzymeShakeRate = QuantitationEnzymeShakeRate/.resolvedQuantitationParameters;
  quantitationEnzymeBuffer = QuantitationEnzymeBuffer/.resolvedQuantitationParameters;
  quantitationStandardFixedDilutions = QuantitationStandardFixedDilutions/.resolvedQuantitationParameters;
  quantitationStandardDiluent = QuantitationStandardDiluent/.resolvedQuantitationParameters;
  quantitationStandardSerialDilutions = Lookup[fullBLIOptionsAssociation, QuantitationStandardSerialDilutions];

  (* resolved binning parameters *)
  binningType = BinningType/.resolvedEpitopeBinningParameters;
  binningControlWell = BinningControlWell/.resolvedEpitopeBinningParameters;
  loadAntibodyTime = LoadAntibodyTime/.resolvedEpitopeBinningParameters;
  loadAntibodyShakeRate = LoadAntibodyShakeRate/.resolvedEpitopeBinningParameters;
  loadAntibodyThresholdCriterion = LoadAntibodyThresholdCriterion/.resolvedEpitopeBinningParameters;
  binningQuenchTime = BinningQuenchTime/.resolvedEpitopeBinningParameters;
  binningQuenchShakeRate = BinningQuenchShakeRate/.resolvedEpitopeBinningParameters;
  loadAntigenTime = LoadAntigenTime/.resolvedEpitopeBinningParameters;
  loadAntigenShakeRate = LoadAntigenShakeRate/.resolvedEpitopeBinningParameters;
  loadAntigenThresholdCriterion = LoadAntigenThresholdCriterion/.resolvedEpitopeBinningParameters;
  competitionBaselineBuffer = CompetitionBaselineBuffer/.resolvedEpitopeBinningParameters;
  competitionBaselineTime = CompetitionBaselineTime/.resolvedEpitopeBinningParameters;
  competitionBaselineShakeRate = CompetitionBaselineShakeRate/.resolvedEpitopeBinningParameters;
  competitionTime = CompetitionTime/.resolvedEpitopeBinningParameters;
  competitionShakeRate = CompetitionShakeRate/.resolvedEpitopeBinningParameters;
  competitionThresholdCriterion = CompetitionThresholdCriterion/.resolvedEpitopeBinningParameters;
  preMixDiluent = PreMixDiluent/.resolvedEpitopeBinningParameters;
  controlWellSolution = If[MatchQ[binningControlWell, True],
    blank,
    Nothing
  ];

  (* resolved AssayDevelopment Parameters *)
  developmentType = DevelopmentType/.resolvedAssayDevelopmentParameters;
  developmentBaselineTime = DevelopmentBaselineTime/.resolvedAssayDevelopmentParameters;
  developmentBaselineShakeRate = DevelopmentBaselineShakeRate/.resolvedAssayDevelopmentParameters;
  developmentAssociationTime = DevelopmentAssociationTime/.resolvedAssayDevelopmentParameters;
  developmentAssociationShakeRate = DevelopmentAssociationShakeRate/.resolvedAssayDevelopmentParameters;
  developmentAssociationThresholdCriterion = DevelopmentAssociationThresholdCriterion/.resolvedAssayDevelopmentParameters;
  developmentDissociationShakeRate = DevelopmentDissociationShakeRate/.resolvedAssayDevelopmentParameters;
  developmentDissociationTime = DevelopmentDissociationTime/.resolvedAssayDevelopmentParameters;
  developmentDissociationThresholdCriterion = DevelopmentDissociationThresholdCriterion/.resolvedAssayDevelopmentParameters;


  (* --------------------------------------------- *)
  (* -- EXPERIMENT SPECIFIC CONFLICTING OPTIONS -- *)
  (* --------------------------------------------- *)

  (* -- QUANTITATION -- *)

  (* if AmplifiedDetection is not a member of QuantitationParameters, but AmplifiedDetection options are populated, collect the unused options *)
  unusedAmplifiedDetectionOptions = If[!MemberQ[ToList[quantitationParameters], AmplifiedDetection],
    PickList[
      {AmplifiedDetectionSolution, AmplifiedDetectionTime, AmplifiedDetectionShakeRate},
      {amplifiedDetectionSolution, amplifiedDetectionTime, amplifiedDetectionShakeRate},
      Except[Null]
    ],
    {}
  ];

  (* if EnzymeLinked is not a member of QuantitationParameters, but QuantitationEnzyme options are populated, collect the unused options *)
  unusedEnzymeLinkedOptions = If[!MemberQ[ToList[quantitationParameters], EnzymeLinked],
    PickList[{QuantitationEnzymeSolution, QuantitationEnzymeBuffer, QuantitationEnzymeTime, QuantitationEnzymeShakeRate},
      {quantitationEnzymeSolution, quantitationEnzymeBuffer, quantitationEnzymeTime, quantitationEnzymeShakeRate},
      Except[Null]
    ],
    {}
  ];

  (* if StandardWell is not a member of QuantitationParameters, but QuantitationStandardWell options are populated, collect the unused options *)
  unusedQuantitationStandardWellOptions = If[!MemberQ[ToList[quantitationParameters], StandardWell],
    PickList[
      {QuantitationStandardWell},
      {quantitationStandardWell},
      Except[Null]
    ],
    {}
  ];

  (* if neither StandardWell nor StandardCurve are specified, this option will not be used *)
  unusedQuantitationStandardOptions = If[!MemberQ[ToList[quantitationParameters], (StandardWell|StandardCurve)],
    PickList[
      {QuantitationStandard},
      {quantitationStandard},
      Except[Null]
    ],
    {}
  ];

  (* if the dilutions are specified, but StandardCurve is not included, throw a warning *)
  unusedStandardCurveOptions = If[!MemberQ[ToList[quantitationParameters], StandardCurve],
    PickList[
      {QuantitationStandardDiluent, QuantitationStandardSerialDilutions, QuantitationStandardFixedDilutions},
      {quantitationStandardDiluent, quantitationStandardSerialDilutions, quantitationStandardFixedDilutions},
      Except[Null]
    ],
    {}
  ];

  (* throw the warnings for unused options *)
  If[!MatchQ[unusedAmplifiedDetectionOptions, {}]&&!gatherTests&&Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::BLIUnusedAmplifiedDetectionOptions, unusedAmplifiedDetectionOptions]
  ];
  If[!MatchQ[unusedEnzymeLinkedOptions, {}]&&!gatherTests&&Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::BLIUnusedQuantitationEnzymeOptions, unusedEnzymeLinkedOptions]
  ];
  If[!MatchQ[unusedQuantitationStandardWellOptions, {}]&&!gatherTests&&Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::BLIUnusedQuantitationStandardWellOptions, unusedQuantitationStandardWellOptions]
  ];
  If[!MatchQ[unusedQuantitationStandardOptions, {}]&&!gatherTests&&Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::BLIUnusedQuantitationStandardOptions, unusedQuantitationStandardOptions]
  ];
  If[!MatchQ[unusedStandardCurveOptions, {}]&&!gatherTests&&Not[MatchQ[$ECLApplication, Engine]],
    Message[Error::BLIUnusedStandardCurveOptions, unusedStandardCurveOptions]
  ];

  (* test for standard curves being informed that wont be used *)
  unusedStandardCurveTest = If[gatherTests,
    Test["If QuantitationStandardSerialDilutions or QuantitationStandardFixedDilutions are specified, StandardCurve is selected in QuantitationParameters:",
      MatchQ[unusedStandardCurveOptions, {}],
      True
    ],
    Null
  ];

  (*EnzymeLinked and AmplifiedDetectio must be specified together*)
  If[MemberQ[ToList[quantitationParameters], EnzymeLinked]&&!MemberQ[ToList[quantitationParameters], AmplifiedDetection]&&!gatherTests&&Not[MatchQ[$ECLApplication, Engine]],
    Message[Error::BLIQuantitationParametersRequiredTogether]
  ];

  invalidQuantitationParametersOption = If[MemberQ[ToList[quantitationParameters], EnzymeLinked]&&!MemberQ[ToList[quantitationParameters], AmplifiedDetection],
    {QuantitationParameters},
    {}
  ];

  (* test for EnzymeLinked without AmplifiedDetection *)
  enzymeLinkedDetectionTest = If[gatherTests,
    Test["If EnzymeLinked is specified in QuantitationParametes, AmplifiedDetection is also:",
      MemberQ[ToList[quantitationParameters], EnzymeLinked]&&!MemberQ[ToList[quantitationParameters], AmplifiedDetection],
      False
    ],
    Null
  ];

  (* warn user about unsued blanks *)
  (* if the Blank is specified but BlankWell is not a member of QuantitationParameters, warn the user that it will not be included *)
  (*Which[
    And[
      MatchQ[experimentType, Quantitation],
      MatchQ[blank, Except[Null]]
    ]
  ];*)


  (* ------------------------------------------ *)
  (* -- Check Unused options for development -- *)
  (* ------------------------------------------ *)

  (* -- Conflicting AssayDevelopment options -- *)

  missingTestSolutionsOptions = Which[
    (* screen interaction *)
    And[
      MatchQ[developmentType, ScreenInteraction],
      MatchQ[Lookup[bliOptionsAssociation, TestInteractionSolutions], ({Null...}|Null)]
    ],
    {TestInteractionSolutions},

    (*screen loading*)
    And[
      MatchQ[developmentType, ScreenLoading],
      MatchQ[Lookup[bliOptionsAssociation, TestLoadingSolutions], ({Null...}|Null)]
    ],
    {TestLoadingSolutions},

    (* screen buffer *)
    And[
      MatchQ[developmentType, ScreenBuffer],
      MatchQ[Lookup[bliOptionsAssociation, TestBufferSolutions], ({Null...}|Null)]
    ],
    {TestBufferSolutions},

    (* screen regeneration *)
    And[
      MatchQ[developmentType, ScreenRegeneration],
      MatchQ[Lookup[bliOptionsAssociation, TestRegenerationSolutions], ({Null...}|Null)]
    ],
    {TestRegenerationSolutions},

    (* screen activation *)
    And[
      MatchQ[developmentType, ScreenActivation],
      MatchQ[Lookup[bliOptionsAssociation, TestActivationSolutions], ({Null...}|Null)]
    ],
    {TestActivationSolutions},

    (* everything is ok *)
    True,
    {}
  ];

  (* throw an error if the solutions are not specified but are required *)
  If[!MatchQ[missingTestSolutionsOptions,{}]&&!gatherTests,
    Message[
      Error::BLIMissingTestSolutions,
      developmentType,
      missingTestSolutionsOptions
    ]
  ];

  (* make a test to check if the appropriate test solutions options are populated *)
  missingTestSolutionsTest = Test[
    "The matching solutions are populated for the AssayDevelopment type:",
    MatchQ[missingTestSolutionsOptions,{}],
    True
  ];

  (* most of the screening types required other options to be set in order to work for ex> ScreenActivation needs LoadingType -> {Activate,...} *)
  missingRequiredOptionsForDevelopment = Which[
    (*screen activation needs LoadingType -> {Activate,...}. There is a warning for Activate without load, but it is possible that this is an intended use*)
    And[
      MatchQ[developmentType, ScreenActivation],
      !MemberQ[ToList[Lookup[bliOptionsAssociation, LoadingType]], Activate]
    ],
    {LoadingType},

    (* ScreenLoading needs LoadingType ->{Load,...} *)
    And[
      MatchQ[developmentType, ScreenLoading],
      !MemberQ[ToList[Lookup[bliOptionsAssociation, LoadingType]], Load]
    ],
    {LoadingType},

    (* screenRegeneartion needs RegenerationType -> {Regenerate,...} *)
    And[
      MatchQ[developmentType, ScreenRegeneration],
      !MemberQ[ToList[Lookup[bliOptionsAssociation, RegenerationType]], Regenerate]
    ],
    {RegenerationType},

    (*everything is ok*)
    True,
    {}
  ];

  (* throw errors if there are missing load or regen parameters that are needed for the AssayDevelopment assay. Also include the value needed in the option to correct this error*)
  If[!MatchQ[missingRequiredOptionsForDevelopment, {}]&&!gatherTests,
    Message[
      Error::BLIOptionMissingForScreening,
      Lookup[bliOptionsAssociation, DevelopmentType],
      First[missingRequiredOptionsForDevelopment],
      Which[
        MatchQ[developmentType, ScreenRegeneration],
        Regenerate,

        Or[MatchQ[developmentType, ScreenLoading], MatchQ[developmentType, ScreenInteraction]],
        Load,

        MatchQ[developmentType, ScreenActivation],
        Activate,

        (* keep this from freaking out *)
        True,
        Null
      ]
    ]
  ];

  (* write the test for bad LoadingType or RegenerationType values for the AssayDevelopmentType *)
  missingRequiredOptionsForDevelopmentTest = Test[
    "If the ExperimentType is AssayDevelopment, the appropriate LoadingType and RegenerationType options are set:",
    MatchQ[missingRequiredOptionsForDevelopment, {}],
    True
  ];



  (* make a list of hte options which are used for one development type but not the others. We will throw errors if they are defined when they shouldnt be *)
  developmentTypeSpecificOptions = {
    TestBufferSolutions, TestRegenerationSolutions, TestActivationSolutions, TestLoadingSolutions, TestInteractionSolutions,
    DetectionLimitSerialDilutions, DetectionLimitFixedDilutions, DetectionLimitDiluent
  };

  (* also get the values. If they are not Automatic or Null, then collect the Option name. Remove any options that should be populated *)
  developmentTypeSpecificValues = Lookup[bliOptionsAssociation,developmentTypeSpecificOptions];

  unusedDevelopmentTypeSpecificOptions = Which[
    (* screen buffer *)
    MatchQ[developmentType, ScreenBuffer],
    DeleteCases[PickList[developmentTypeSpecificOptions, developmentTypeSpecificValues, Except[(Automatic|Null|{Automatic...}|{Null...})]], TestBufferSolutions],

    (* ScreenActivation *)
    MatchQ[developmentType, ScreenActivation],
    DeleteCases[PickList[developmentTypeSpecificOptions, developmentTypeSpecificValues, Except[(Automatic|Null|{Automatic...}|{Null...})]], TestActivationSolutions],

    (* ScreenRegeneration *)
    MatchQ[developmentType, ScreenRegeneration],
    DeleteCases[PickList[developmentTypeSpecificOptions, developmentTypeSpecificValues, Except[(Automatic|Null|{Automatic...}|{Null...})]], TestRegenerationSolutions],

    (* ScreenLoading *)
    MatchQ[developmentType, ScreenLoading],
    DeleteCases[PickList[developmentTypeSpecificOptions, developmentTypeSpecificValues, Except[(Automatic|Null|{Automatic...}|{Null...})]], TestLoadingSolutions],

    (* ScreenInteraction *)
    MatchQ[developmentType, ScreenInteraction],
    DeleteCases[PickList[developmentTypeSpecificOptions, developmentTypeSpecificValues, Except[(Automatic|Null|{Automatic...}|{Null...})]], TestInteractionSolutions],

    (* ScreenDetectionLimit *)
    MatchQ[developmentType, ScreenDetectionLimit],
    DeleteCases[PickList[developmentTypeSpecificOptions, developmentTypeSpecificValues, Except[(Automatic|Null|{Automatic...}|{Null...})]], (DetectionLimitSerialDilutions|DetectionLimitFixedDilutions|DetectionLimitDiluent)],

    (* everything is ok *)
    True,
    {}
  ];

  (*throw an error if options are populated for the wrong experiment type*)
  If[!MatchQ[unusedDevelopmentTypeSpecificOptions, {}]&&!gatherTests,
    Message[Error::BLIUnusedDevelopmentTypeSpecificOptions, unusedDevelopmentTypeSpecificOptions, developmentType]
  ];

  (* make a test for these unsued options *)
  unusedDevelopmentTypeSpecificOptionTest = Test["The specified AssayDevelopment options are relevant to the selected DevelopmentType:",
    MatchQ[unusedDevelopmentTypeSpecificOptions,{}],
    True
  ];


  (* --------------------------------------------------------- *)
  (* --- MAP THREAD RESOLUTION OF INDEX MATCHED PARAMETERS --- *)
  (* --------------------------------------------------------- *)

  (* there are things going wrong in here that need to be addressed ASAP - maybe a problem with the way the map thread is set up? *)
  (*MapThreadFriendlyOptions have the Key value pairs expanded to index match, such that if you call Lookup[options, optionname], it gives the Option value at the index we are interested in*)
  (* so each iteration of mapthread is looking at a list of {sample, {OptionName1 -> optionvalue1, OptionName2 -> optionvalue2...}} which is why calling Lookup on option gives the right values.*)
  mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentBioLayerInterferometry, fullBLIOptionsAssociation];

  (*MAPTHREAD for experiment specific options: KineticsFixedDilution, KineticsSerialDilution, KineticsDiluent, PreMixSolutions, detectionLimitFixedDilutions, detectionLimitSerialDilutions *)
  (* These guys are rounded by the new and improved RoundOptionPrecision[]? *)

  mapThreadRules = Transpose@MapThread[Function[{options, index},
    Module[{resolvedKineticsSampleDiluent, resolvedKineticsSampleFixedDilutions, resolvedKineticsSampleSerialDilutions, resolvedDetectionLimitDiluent,
      resolvedDetectionLimitSerialDilutions, resolvedDetectionLimitFixedDilutions, resolvedPreMixSolution, resolvedDetectionLimitDilutions, resolvedKineticsSampleDilutions,
      (* unresolvable index matched user input that we need to figure out how to make dilutions*)
      kineticsSampleSerialDilution,detectionLimitSerialDilution,
      (* naming variables and intermediate lists *)
      preMixNameList, unnamedResolvedPreMixSolution, unnamedResolvedKineticsSampleFixedDilutions, kineticsSampleFixedDilutionsNameList,
      unnamedResolvedDetectionLimitSerialDilutions, detectionLimitSerialDilutionsNameList,
      (*error tracking variables*)
      missingKineticsDilution, missingKineticsDiluent, invalidKineticsDilution, conflictingKineticsDilution, missingDevelopmentDilution,
      missingDevelopmentDiluent, invalidDevelopmentDilution, conflictingDevelopmentDilution, missingPreMixSolution, missingPreMixDiluent, invalidPreMixDilution,
      tooLargePreMixSolution, insufficientPreMixVolume, insufficientKineticsSerialDilutionsVolume, insufficientKineticsFixedDilutionsVolume,
      insufficientDetectionLimitSerialDilutionsVolume, insufficientDetectionLimitFixedDilutionsVolume, insufficientKineticsSerialTransferVolume,
      insufficientKineticsFixedTransferVolume, insufficientDetectionLimitSerialTransferVolume, insufficientDetectionLimitFixedTransferVolume,
      tooLargeKineticsFixedDilutionsVolume, tooLargeKineticsSerialDilutionsVolume, tooLargeDetectionLimitSerialDilutionsVolume, tooLargeDetectionLimitFixedDilutionsVolume
    },

      (* set our error checking variables *)
      {
        missingKineticsDilution,
        missingKineticsDiluent,
        invalidKineticsDilution,
        conflictingKineticsDilution,
        missingDevelopmentDilution,
        missingDevelopmentDiluent,
        invalidDevelopmentDilution,
        conflictingDevelopmentDilution,
        missingPreMixSolution,
        missingPreMixDiluent,
        invalidPreMixDilution,
        tooLargePreMixSolution
      } = {False, False, False, False, False, False, False, False, False, False, False, False};

      (*initialize the volume error tracking variables*)
      {
        insufficientPreMixVolume,
        insufficientKineticsSerialDilutionsVolume,
        insufficientKineticsFixedDilutionsVolume,
        insufficientDetectionLimitSerialDilutionsVolume,
        insufficientDetectionLimitFixedDilutionsVolume,
        insufficientKineticsSerialTransferVolume,
        insufficientKineticsFixedTransferVolume,
        insufficientDetectionLimitSerialTransferVolume,
        insufficientDetectionLimitFixedTransferVolume
      } = {False,False,False,False,False,False,False,False,False};

      (*initialize the too large volume error tracking variables*)
      {
        tooLargeKineticsFixedDilutionsVolume,
        tooLargeKineticsSerialDilutionsVolume,
        tooLargeDetectionLimitSerialDilutionsVolume,
        tooLargeDetectionLimitFixedDilutionsVolume
      }= {False, False, False, False};

      (* --------------------------- *)
      (* -- RESOLVE THE DILUTIONS -- *)

      (* resolve the kinetics sample diluent based on the experiment type *)
      resolvedKineticsSampleDiluent = If[MatchQ[experimentType,Kinetics],
        Lookup[options, KineticsSampleDiluent]/.{Automatic -> defaultBuffer},
        Lookup[options, KineticsSampleDiluent]/.{Automatic -> Null}
      ];

      (* check for missing solution if the experiment type is kinetics (user input Null) *)
      missingKineticsDiluent = If[MatchQ[resolvedKineticsSampleDiluent, Null]&&MatchQ[experimentType, Kinetics],
        True,
        False
      ];

      (* resolve the kinetics dilutions based on experiment type, and the population of Serial dilutions. Any user specified values will take preference, even if they are serial rather than fixed dilutions *)
      (* lookup the user input for serial dilution regardless of experiment type *)
      resolvedKineticsSampleSerialDilutions = Lookup[options, KineticsSampleSerialDilutions];

      (* resolve the kinetics fixed dilutions based on experiment type and if there is a serial dilution specified*)
      unnamedResolvedKineticsSampleFixedDilutions = If[MatchQ[experimentType,Kinetics],
        If[MatchQ[resolvedKineticsSampleSerialDilutions,Null],

          (* the format for these dilutions is: {dilution factor, name} *)
          Lookup[options, KineticsSampleFixedDilutions]/.{Automatic -> {{2, Name},{4, Name},{8, Name},{16, Name},{32, Name}, {64,Name}}},
          Lookup[options, KineticsSampleFixedDilutions]/.{Automatic -> Null}
        ],
        Lookup[options, KineticsSampleFixedDilutions]/.{Automatic -> Null}
      ];

      (* generate a list of names for the samples *)
      (* replace the placeholder name with a real name using index of the solution to determine what numbers to use*)
      kineticsSampleFixedDilutionsNameList = If[
        MatchQ[Lookup[options, KineticsSampleFixedDilutions], Automatic]&&MatchQ[unnamedResolvedKineticsSampleFixedDilutions, _List],

        (*the index keeps the names matched to the sample in: the first sample in has 101,102,103... then second has 201,202,203...*)
        Table[
          (Name -> "dilution "<>ToString[solutionName]),
          {solutionName, index*100, index*100+Length[unnamedResolvedKineticsSampleFixedDilutions]-1, 1}
        ],
        Null
      ];

      (* mapthread to substitute the appropriate name *)
      resolvedKineticsSampleFixedDilutions = If[
        MatchQ[Lookup[options, KineticsSampleFixedDilutions], Automatic]&&MatchQ[unnamedResolvedKineticsSampleFixedDilutions, _List],
        MapThread[#1/.#2&,
          {unnamedResolvedKineticsSampleFixedDilutions, kineticsSampleFixedDilutionsNameList}],
        unnamedResolvedKineticsSampleFixedDilutions
      ];

      (* resolve kinetics dilutions with preference for Fixed dilutions (note that this will never override the user since fixed dilutions are only set if serial dilutiosn are null) *)
      resolvedKineticsSampleDilutions = If[
        MatchQ[resolvedKineticsSampleFixedDilutions, Null],
        {resolvedKineticsSampleSerialDilutions, Serial},
        {resolvedKineticsSampleFixedDilutions, Fixed}
      ];

      (* check the solution volume for serial dilutions *)
      {
        insufficientKineticsSerialDilutionsVolume,
        insufficientKineticsSerialTransferVolume,
        tooLargeKineticsSerialDilutionsVolume
      } = Module[{standardDilutionForm, badTransferVolumes, transfersOut, dilutionFinalVolumes, badDilutionBool, badTransferBool, largeDilutionBool},

        (* put the dilutions into the form: {transfer volume, diluent volume, number} *)
        standardDilutionForm = standardizedBLIDilutions[resolvedKineticsSampleSerialDilutions, Serial];

        (* if the original entry was not Null, then check the standard dilutions for a bad volume *)
        If[MatchQ[standardDilutionForm, Except[Null]],

          (* scale each volume since we may have made dilutions too small *)
          transfersOut = Append[Rest[First/@standardDilutionForm], 0 Microliter];

          (* check the total solution volume  *)
          dilutionFinalVolumes = MapThread[(First[#1] + #1[[2]] - #2)&,{standardDilutionForm, transfersOut}];

          (* if the solution volume is too low, return True *)
          badDilutionBool = If[MatchQ[Min[dilutionFinalVolumes], LessP[210 Microliter]],
            True,
            False
          ];

          (* if the solution volume is too high, return True *)
          largeDilutionBool = If[MatchQ[Max[dilutionFinalVolumes], GreaterP[2.0 Milli Liter]],
            True,
            False
          ];

          (* pull out any elements with volume units that are less than 1 microliter from the scaled dilutions *)
          badTransferVolumes = DeleteCases[Cases[Cases[Flatten[standardDilutionForm], VolumeP], LessP[1 Microliter]], 0 Microliter];

          (* if there are any elements in this list, return true *)
          badTransferBool = If[MatchQ[badTransferVolumes, {}],
            False,
            True
          ];
          {badDilutionBool, badTransferBool, largeDilutionBool},

          (* if the dilutions were not specified, return false for both *)
          {False,False, False}
        ]
      ];

      (* check the solution volume for serial dilutions *)
      {
        insufficientKineticsFixedDilutionsVolume,
        insufficientKineticsFixedTransferVolume,
        tooLargeKineticsFixedDilutionsVolume
      } = Module[{standardDilutionForm, badTransferVolumes, dilutionFinalVolumes, badDilutionBool, largeDilutionBool, badTransferBool},

        (* put the dilutions into the form: {transfer volume, diluent volume, number} *)
        standardDilutionForm = standardizedBLIDilutions[resolvedKineticsSampleFixedDilutions, Fixed];

        (* if the original entry was not Null, then check the standard dilutions for a bad volume *)
        If[MatchQ[standardDilutionForm, Except[Null]],

          (* check the total solution volume  *)
          dilutionFinalVolumes = Map[(First[#] + #[[2]])&, standardDilutionForm];

          (* if the solution volume is too low, return True *)
          badDilutionBool = If[MatchQ[Min[dilutionFinalVolumes], LessP[210 Microliter]],
            True,
            False
          ];

          (* if the solution volume is too high, return True *)
          largeDilutionBool = If[MatchQ[Max[dilutionFinalVolumes], GreaterP[2000 Microliter]],
            True,
            False
          ];

          (* pull out any elements with volume units that are less than 1 microliter from the scaled dilutions *)
          badTransferVolumes = DeleteCases[Cases[Cases[Flatten[standardDilutionForm], VolumeP], LessP[1 Microliter]], 0 Microliter];

          (* if there are any elements in this list, return true *)
          badTransferBool = If[MatchQ[badTransferVolumes, {}],
            False,
            True
          ];
          {badDilutionBool, badTransferBool, largeDilutionBool},

          (* if the dilutions were not specified, return false for both *)
          {False,False, False}
        ]
      ];


      (* check if the user has informed both types of dilutions for this sample *)
      conflictingKineticsDilution = If[MatchQ[experimentType, Kinetics]&&MatchQ[resolvedKineticsSampleFixedDilutions, Except[Null]]&&MatchQ[resolvedKineticsSampleSerialDilutions, Except[Null]],
        True,
        False
      ];

      (* check if there are missing dilutions *)
      missingKineticsDilution = If[MatchQ[experimentType, Kinetics]&&MatchQ[resolvedKineticsSampleFixedDilutions, (Null| {})]&&MatchQ[resolvedKineticsSampleSerialDilutions, (Null| {})],
        True,
        False
      ];

      (* resolve the assay development sample diluent based on the experiment type and the assaydevelopment type *)
      resolvedDetectionLimitDiluent = If[MatchQ[experimentType, AssayDevelopment]&&MatchQ[developmentType, ScreenDetectionLimit],
        Lookup[options, DetectionLimitDiluent]/.{Automatic -> defaultBuffer},
        Lookup[options, DetectionLimitDiluent]/.{Automatic -> Null}
      ];

      (* check if there are missing diluents *)
      missingDevelopmentDiluent = If[MatchQ[resolvedDetectionLimitDiluent, Null]&&MatchQ[experimentType, AssayDevelopment]&&MatchQ[developmentType, ScreenDetectionLimit],
        True,
        False
      ];

      (* resolve the detection limit dilutions based on the population of fixed dilutions *)
      resolvedDetectionLimitFixedDilutions = Lookup[options, DetectionLimitFixedDilutions];
      unnamedResolvedDetectionLimitSerialDilutions = If[MatchQ[experimentType,AssayDevelopment]&&MatchQ[developmentType, ScreenDetectionLimit],
        If[MatchQ[resolvedDetectionLimitFixedDilutions,Null],

          (* the format here is {dilution factor, {list of names}} *)
          Lookup[options, DetectionLimitSerialDilutions]/.{Automatic -> {2, {Name, Name, Name, Name, Name, Name}}},
          Lookup[options, DetectionLimitSerialDilutions]/.{Automatic -> Null}
        ],
        Lookup[options, DetectionLimitSerialDilutions]/.{Automatic -> Null}
      ];

      (* generate a list of Names for the samples if the option is being resolved automatically *)
      (* replace the placeholder Name with a real Name using index of the solution to determine what numbers to use*)
      detectionLimitSerialDilutionsNameList = If[
        MatchQ[Lookup[options, DetectionLimitSerialDilutions], Automatic]&&MatchQ[unnamedResolvedDetectionLimitSerialDilutions, _List],
        (*the index keeps the names matched to the sample in: the first sample in has 101,102,103... then second has 201,202,203...*)
        Table[
          (Name -> "dilution "<>ToString[solutionname]),
          {solutionname, index*100, index*100+Length[Last[unnamedResolvedDetectionLimitSerialDilutions]]-1, 1}
        ],
        Null
      ];

      (* mapthread to substitute the appropriate name, note that because the default behavior is to use serial dilutions, namign is differenc *)
      resolvedDetectionLimitSerialDilutions = If[
        MatchQ[Lookup[options, DetectionLimitSerialDilutions], Automatic]&&MatchQ[unnamedResolvedDetectionLimitSerialDilutions, _List],
        Append[
          Most[unnamedResolvedDetectionLimitSerialDilutions],
          MapThread[#1/.#2&,
            {Last[unnamedResolvedDetectionLimitSerialDilutions], detectionLimitSerialDilutionsNameList}
          ]
        ],
        unnamedResolvedDetectionLimitSerialDilutions
      ];

      (* choose the solution that is populated and use that for building primitives later *)
      resolvedDetectionLimitDilutions = If[MatchQ[resolvedDetectionLimitFixedDilutions, Null],
        {resolvedDetectionLimitSerialDilutions, Serial},
        {resolvedDetectionLimitFixedDilutions, Fixed}
      ];

      (* check the solution volume for serial dilutions *)
      {
        insufficientDetectionLimitSerialDilutionsVolume,
        insufficientDetectionLimitSerialTransferVolume,
        tooLargeDetectionLimitSerialDilutionsVolume
      } = Module[{standardDilutionForm, badTransferVolumes, transfersOut, dilutionFinalVolumes, badDilutionBool, badTransferBool, largeDilutionBool},

        (* put the dilutions into the form: {transfer volume, diluent volume, number} *)
        standardDilutionForm = standardizedBLIDilutions[resolvedDetectionLimitSerialDilutions, Serial];

        (* if the original entry was not Null, then check the standard dilutions for a bad volume *)
        If[MatchQ[standardDilutionForm, Except[Null]],

          (* scale each volume since we may have made dilutions too small *)
          transfersOut = Append[Rest[First/@standardDilutionForm], 0 Microliter];

          (* check the total solution volume  *)
          dilutionFinalVolumes = MapThread[(First[#1] + #1[[2]] - #2)&,{standardDilutionForm, transfersOut}];

          (* if the solution volume is too low, return True *)
          badDilutionBool = If[MatchQ[Min[dilutionFinalVolumes], LessP[210 Microliter]],
            True,
            False
          ];

          (* if the solution volume is too high, return True *)
          largeDilutionBool = If[MatchQ[Max[dilutionFinalVolumes], GreaterP[2.0 Milli Liter]],
            True,
            False
          ];

          (* pull out any elements with volume units that are less than 1 microliter from the scaled dilutions *)
          badTransferVolumes = DeleteCases[Cases[Cases[Flatten[standardDilutionForm], VolumeP], LessP[1 Microliter]], 0 Microliter];

          (* if there are any elements in this list, return true *)
          badTransferBool = If[MatchQ[badTransferVolumes, {}],
            False,
            True
          ];
          {badDilutionBool, badTransferBool, largeDilutionBool},

          (* if the dilutions were not specified, return false for both *)
          {False,False, False}
        ]
      ];

      (* check the solution volume for serial dilutions *)
      {
        insufficientDetectionLimitFixedDilutionsVolume,
        insufficientDetectionLimitFixedTransferVolume,
        tooLargeDetectionLimitFixedDilutionsVolume
      } = Module[{standardDilutionForm, badTransferVolumes, dilutionFinalVolumes, badDilutionBool, badTransferBool, largeDilutionBool},

        (* put the dilutions into the form: {transfer volume, diluent volume, number} *)
        standardDilutionForm = standardizedBLIDilutions[resolvedDetectionLimitFixedDilutions, Fixed];

        (* if the original entry was not Null, then check the standard dilutions for a bad volume *)
        If[MatchQ[standardDilutionForm, Except[Null]],

          (* check the total solution volume  *)
          dilutionFinalVolumes = Map[(First[#] + #[[2]])&, standardDilutionForm];

          (* if the solution volume is too low, return True *)
          badDilutionBool = If[MatchQ[Min[dilutionFinalVolumes], LessP[210 Microliter]],
            True,
            False
          ];

          (* if the solution volume is too high, return True *)
          largeDilutionBool = If[MatchQ[Max[dilutionFinalVolumes], GreaterP[2.0 Milli Liter]],
            True,
            False
          ];

          (* pull out any elements with volume units that are less than 1 microliter from the scaled dilutions *)
          badTransferVolumes = DeleteCases[Cases[Cases[Flatten[standardDilutionForm], VolumeP], LessP[1 Microliter]], 0 Microliter];

          (* if there are any elements in this list, return true *)
          badTransferBool = If[MatchQ[badTransferVolumes, {}],
            False,
            True
          ];
          {badDilutionBool, badTransferBool, largeDilutionBool},

          (* if the dilutions were not specified, return false for both *)
          {False,False, False}
        ]
      ];

      (* check if both serial and fixed dilutions are informed and we are screening detection limit *)
      conflictingDevelopmentDilution = If[
        And[
          MatchQ[experimentType, AssayDevelopment],
          MatchQ[developmentType, Alternatives[Automatic, ScreenDetectionLimit]],
          MatchQ[resolvedDetectionLimitFixedDilutions, Except[Null]],
          MatchQ[resolvedDetectionLimitSerialDilutions, Except[Null]]
        ],
        True,
        False
      ];

      (* check it neither serial nor fixed are informed and we are screening for detection limit *)
      missingDevelopmentDilution = If[
        And[
          MatchQ[experimentType, AssayDevelopment],
          MatchQ[developmentType, Alternatives[Automatic, ScreenDetectionLimit]],
          MatchQ[resolvedDetectionLimitFixedDilutions, Alternatives[{Null}, Null, {}]],
          MatchQ[resolvedDetectionLimitSerialDilutions, Alternatives[{Null}, Null, {}]]
        ],
        True,
        False
      ];

      (* resolve the premix diluent for each input *)
      preMixDiluent = If[MatchQ[experimentType,EpitopeBinning],
        Lookup[options, PreMixDiluent]/.{Automatic -> defaultBuffer},
        Lookup[options, PreMixDiluent]/.{Automatic -> Null}
      ];

      (*resolve the premix solution for each input*)
      unnamedResolvedPreMixSolution = If[MatchQ[experimentType, EpitopeBinning]&&MatchQ[binningType, PreMix],

        (* The format of these dilutions is: {antibody(sample) amount, antigen amount, diluent amount, name} *)
        Lookup[options, PreMixSolutions]/.{Automatic -> {110 Microliter, 110 Microliter, 0  Microliter, Name}},
        Lookup[options, PreMixSolutions]/.{Automatic -> Null}
      ];

      (* replace the placeholder Name with a real Name using index of the solution to determine what numbers to use*)
      preMixNameList = If[MatchQ[Lookup[options, PreMixSolutions], Automatic]&&MatchQ[unnamedResolvedPreMixSolution, _List],

        (*the index keeps the Names matched to the sample in: the first sample in has 101,102,103... then second has 201,202,203...*)
        Table[(Name -> ToString[solutionname]),
          {solutionname, index*100, index*100+Length[unnamedResolvedPreMixSolution]-1, 1}
        ],
        Null
      ];

      (* mapthread to substitute the appropriate name *)
      resolvedPreMixSolution = If[MatchQ[Lookup[options, PreMixSolutions], Automatic]&&MatchQ[unnamedResolvedPreMixSolution, _List],
        MapThread[#1/.#2&, {unnamedResolvedPreMixSolution, preMixNameList}],
        unnamedResolvedPreMixSolution
      ];

      (* check that each premix is correct *)
      missingPreMixSolution = If[MatchQ[experimentType, EpitopeBinning]&&MatchQ[binningType, PreMix]&&MatchQ[resolvedPreMixSolution, Null],
        True,
        False
      ];

      (* check that if the diluent has been requested, that it is specified *)
      missingPreMixDiluent = If[MatchQ[resolvedPreMixSolution, Except[Null]]&&MatchQ[experimentType, EpitopeBinning],
        If[MatchQ[resolvedPreMixSolution[[3]], Except[(0|0 Microliter|0 Milliliter|Null)]]&&MatchQ[preMixDiluent, Null],
          True,
          False],
        False
      ];

      (* check if any of the solutions have too much volume to be held in the dilution plate and run as is *)
      {
        tooLargePreMixSolution,
        insufficientPreMixVolume
      } = Module[{tooSmallBool, tooLargeBool},
        If[MatchQ[resolvedPreMixSolution, Except[Null]]&&MatchQ[experimentType, EpitopeBinning],
          tooLargeBool = If[MatchQ[Total[Most[resolvedPreMixSolution]], GreaterP[250 Microliter]],
            True,
            False
          ];
          tooSmallBool = If[MatchQ[Total[Most[resolvedPreMixSolution]], LessP[210 Microliter]],
            True,
            False
          ];
          {tooLargeBool, tooSmallBool},
          (* volume is not important *)
          {False, False}
        ]
      ];

      (* return the resolved values as an association using the temp variables *)
      {
        tempKineticsSampleDiluent -> resolvedKineticsSampleDiluent,
        tempKineticsSampleSerialDilutions -> resolvedKineticsSampleSerialDilutions,
        tempKineticsSampleFixedDilutions -> resolvedKineticsSampleFixedDilutions,
        tempKineticsSampleDilutions -> resolvedKineticsSampleDilutions,
        tempDetectionLimitDiluent -> resolvedDetectionLimitDiluent,
        tempDetectionLimitSerialDilutions -> resolvedDetectionLimitSerialDilutions,
        tempDetectionLimitFixedDilutions -> resolvedDetectionLimitFixedDilutions,
        tempDetectionLimitDilutions -> resolvedDetectionLimitDilutions,
        tempPreMixSolutions -> resolvedPreMixSolution,
        tempPreMixDiluent -> preMixDiluent,
        tempMissingKineticsDilutions -> missingKineticsDilution,
        tempMissingKineticsDiluents -> missingKineticsDiluent,
        tempInvalidKineticsDilutions -> invalidKineticsDilution,
        tempConflictingKineticsDilutions -> conflictingKineticsDilution,
        tempMissingDevelopmentDilutions -> missingDevelopmentDilution,
        tempMissingDevelopmentDiluents -> missingDevelopmentDiluent,
        tempInvalidDevelopmentDilutions -> invalidDevelopmentDilution,
        tempConflictingDevelopmentDilutions -> conflictingDevelopmentDilution,
        tempMissingPreMixSolutions -> missingPreMixSolution,
        tempMissingPreMixDiluents -> missingPreMixDiluent,
        tempInvalidPreMixDilutions -> invalidPreMixDilution,
        (* volume error trackers *)
        tempTooLargePreMixSolutions -> tooLargePreMixSolution,
        tempInsufficientPreMixVolume -> insufficientPreMixVolume,
        tempInsufficientKineticsSerialDilutionsVolume -> insufficientKineticsSerialDilutionsVolume,
        tempInsufficientKineticsFixedDilutionsVolume -> insufficientKineticsFixedDilutionsVolume,
        tempInsufficientDetectionLimitSerialDilutionsVolume -> insufficientDetectionLimitSerialDilutionsVolume,
        tempInsufficientDetectionLimitFixedDilutionsVolume -> insufficientDetectionLimitFixedDilutionsVolume,
        tempInsufficientKineticsSerialTransferVolume -> insufficientKineticsSerialTransferVolume,
        tempInsufficientKineticsFixedTransferVolume -> insufficientKineticsFixedTransferVolume,
        tempInsufficientDetectionLimitSerialTransferVolume -> insufficientDetectionLimitSerialTransferVolume,
        tempInsufficientDetectionLimitFixedTransferVolume -> insufficientDetectionLimitFixedTransferVolume,
        tempTooLargeKineticsSerialDilutionsVolume -> tooLargeKineticsSerialDilutionsVolume,
        tempTooLargeDetectionLimitSerialDilutionsVolume -> tooLargeDetectionLimitSerialDilutionsVolume,
        tempTooLargeDetectionLimitFixedDilutionsVolume -> tooLargeDetectionLimitFixedDilutionsVolume,
        tempTooLargeKineticsFixedDilutionsVolume -> tooLargeKineticsFixedDilutionsVolume
      }
    ]
  ],
    (* the options that we are map threading across, plus an index to help with counting to name the solutions correctly *)
    {mapThreadFriendlyOptions, Range[Length[mySamples]]}
  ];

  (* take the map thread associations and flatten and merge them to generate a full list of rules for all of the options *)
  mergedMapThreadRules = Merge[Flatten[mapThreadRules], Join];

  (* define the map thread options and error checks  *)
  (* resolved index matched options *)
  kineticsSampleDiluent = tempKineticsSampleDiluent/.mergedMapThreadRules;
  kineticsSampleSerialDilutions = tempKineticsSampleSerialDilutions/.mergedMapThreadRules;
  kineticsSampleFixedDilutions = tempKineticsSampleFixedDilutions/.mergedMapThreadRules;
  kineticsSampleDilutions = tempKineticsSampleDilutions/.mergedMapThreadRules;
  detectionLimitDiluent = tempDetectionLimitDiluent/.mergedMapThreadRules;
  detectionLimitSerialDilutions = tempDetectionLimitSerialDilutions/.mergedMapThreadRules;
  detectionLimitFixedDilutions = tempDetectionLimitFixedDilutions/.mergedMapThreadRules;
  detectionLimitDilutions = tempDetectionLimitDilutions/.mergedMapThreadRules;
  preMixSolutions = tempPreMixSolutions/.mergedMapThreadRules;
  preMixDiluent = tempPreMixDiluent/.mergedMapThreadRules;

  (* error tracking variables *)
  missingKineticsDilutions = tempMissingKineticsDilutions/.mergedMapThreadRules;
  missingKineticsDiluents = tempMissingKineticsDiluents/.mergedMapThreadRules;
  invalidKineticsDilutions = tempInvalidKineticsDilutions/.mergedMapThreadRules;
  conflictingKineticsDilutions = tempConflictingKineticsDilutions/.mergedMapThreadRules;
  missingDevelopmentDilutions = tempMissingDevelopmentDilutions/.mergedMapThreadRules;
  missingDevelopmentDiluents = tempMissingDevelopmentDiluents/.mergedMapThreadRules;
  invalidDevelopmentDilutions = tempInvalidDevelopmentDilutions/.mergedMapThreadRules;
  conflictingDevelopmentDilutions = tempConflictingDevelopmentDilutions/.mergedMapThreadRules;
  missingPreMixSolutions = tempMissingPreMixSolutions/.mergedMapThreadRules;
  missingPreMixDiluents = tempMissingPreMixDiluents/.mergedMapThreadRules;
  invalidPreMixDilutions = tempInvalidPreMixDilutions/.mergedMapThreadRules;

  (* dilution volume error trackers *)
  tooLargePreMixSolutions = tempTooLargePreMixSolutions/.mergedMapThreadRules;
  insufficientPreMixVolumes = tempInsufficientPreMixVolume/.mergedMapThreadRules;
  insufficientKineticsSerialDilutionsVolumes = tempInsufficientKineticsSerialDilutionsVolume/.mergedMapThreadRules;
  insufficientKineticsFixedDilutionsVolumes = tempInsufficientKineticsFixedDilutionsVolume/.mergedMapThreadRules;
  insufficientDetectionLimitSerialDilutionsVolumes = tempInsufficientDetectionLimitSerialDilutionsVolume/.mergedMapThreadRules;
  insufficientDetectionLimitFixedDilutionsVolumes = tempInsufficientDetectionLimitFixedDilutionsVolume/.mergedMapThreadRules;
  insufficientKineticsSerialTransferVolumes = tempInsufficientKineticsSerialTransferVolume/.mergedMapThreadRules;
  insufficientKineticsFixedTransferVolumes = tempInsufficientKineticsFixedTransferVolume/.mergedMapThreadRules;
  insufficientDetectionLimitSerialTransferVolumes = tempInsufficientDetectionLimitSerialTransferVolume/.mergedMapThreadRules;
  insufficientDetectionLimitFixedTransferVolumes = tempInsufficientDetectionLimitFixedTransferVolume/.mergedMapThreadRules;
  tooLargeKineticsSerialDilutionsVolumes = tempTooLargeKineticsSerialDilutionsVolume/.mergedMapThreadRules;
  tooLargeDetectionLimitSerialDilutionsVolumes = tempTooLargeDetectionLimitSerialDilutionsVolume/.mergedMapThreadRules;
  tooLargeDetectionLimitFixedDilutionsVolumes = tempTooLargeDetectionLimitFixedDilutionsVolume/.mergedMapThreadRules;
  tooLargeKineticsFixedDilutionsVolumes = tempTooLargeKineticsFixedDilutionsVolume/.mergedMapThreadRules;

  (* --------------------------- *)
  (* -- MAPTHREAD ERROR CHECK -- *)
  (* --------------------------- *)

  (* get the samplesPackets that have a problem *)
  samplePacketsWithMissingKineticsDilution = PickList[samplePackets, missingKineticsDilutions, True];
  samplePacketsWithMissingKineticsDiluent = PickList[samplePackets, missingKineticsDiluents, True];
  samplePacketsWithConflictingKineticsDilution = PickList[samplePackets, conflictingKineticsDilutions, True];
  samplePacketsWithMissingDevelopmentDilution = PickList[samplePackets, missingDevelopmentDilutions, True];
  samplePacketsWithMissingDevelopmentDiluent = PickList[samplePackets, missingDevelopmentDiluents, True];
  samplePacketsWithConflictingDevelopmentDilution = PickList[samplePackets, conflictingDevelopmentDilutions, True];
  samplePacketsWithMissingPreMixSolution = PickList[samplePackets, missingPreMixSolutions, True];
  samplePacketsWithMissingPreMixDiluent = PickList[samplePackets, missingPreMixDiluents, True];
  samplePacketsWithTooLargePreMixSolution = PickList[samplePackets, tooLargePreMixSolutions, True];

  samplePacketsWithInsufficientPreMixVolumes = PickList[samplePackets, insufficientPreMixVolumes, True];
  samplePacketsWithInsufficientKineticsSerialDilutionsVolumes = PickList[samplePackets, insufficientKineticsSerialDilutionsVolumes, True];
  samplePacketsWithInsufficientKineticsFixedDilutionsVolumes = PickList[samplePackets, insufficientKineticsFixedDilutionsVolumes, True];
  samplePacketsWithInsufficientDetectionLimitSerialDilutionsVolumes = PickList[samplePackets, insufficientDetectionLimitSerialDilutionsVolumes, True];
  samplePacketsWithInsufficientDetectionLimitFixedDilutionsVolumes = PickList[samplePackets, insufficientDetectionLimitFixedDilutionsVolumes, True];
  samplePacketsWithInsufficientKineticsSerialTransferVolumes = PickList[samplePackets, insufficientKineticsSerialTransferVolumes, True];
  samplePacketsWithInsufficientKineticsFixedTransferVolumes = PickList[samplePackets, insufficientKineticsFixedTransferVolumes, True];
  samplePacketsWithInsufficientDetectionLimitSerialTransferVolumes = PickList[samplePackets, insufficientDetectionLimitSerialTransferVolumes, True];
  samplePacketsWithInsufficientDetectionLimitFixedTransferVolumes = PickList[samplePackets, insufficientDetectionLimitFixedTransferVolumes, True];

  samplePacketsWithTooLargeKineticsSerialDilutionVolumes = PickList[samplePackets, tooLargeKineticsSerialDilutionsVolumes, True];
  samplePacketsWithTooLargeKineticsFixedDilutionVolumes = PickList[samplePackets, tooLargeKineticsFixedDilutionsVolumes, True];
  samplePacketsWithTooLargeDetectionLimitSerialDilutionVolumes = PickList[samplePackets, tooLargeDetectionLimitSerialDilutionsVolumes, True];
  samplePacketsWithTooLargeDetectionLimitFixedDilutionVolumes = PickList[samplePackets, tooLargeDetectionLimitFixedDilutionsVolumes, True];

  (* Throw message for missing kinetics dilutions *)
  If[!MatchQ[samplePacketsWithMissingKineticsDilution,{}]&&!gatherTests,
    Message[Error::BLIMissingKineticsDilutions, ObjectToString[samplePacketsWithMissingKineticsDilution, Simulation -> updatedSimulation]]
  ];
  (* test for missing kinetics dilutions *)
  missingKineticsDilutionsTests=sampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithMissingKineticsDilution,
    "KineticsSampleFixedDilutions or KineticsSampleSerialDilutions are specified or Automatic for the input sample `1`:",
    updatedSimulation];

  (* Throw message for missing kinetics diluent *)
  If[!MatchQ[samplePacketsWithMissingKineticsDiluent,{}]&&!gatherTests,
    Message[Error::BLIMissingKineticsDiluent, ObjectToString[samplePacketsWithMissingKineticsDiluent, Simulation -> updatedSimulation]]
  ];
  (* test for missing kinetics diluent *)
  missingKineticsDiluentTests=sampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithMissingKineticsDiluent,
    "KineticsDiluent is specified or Automatic for the input sample `1` if it is required for dilutions:",
    updatedSimulation];

  invalidKineticsDiluentOptions = If[!MatchQ[samplePacketsWithMissingKineticsDiluent,{}],KineticsSampleDiluent];

  (* Throw message for conflicting kinetics dilutions - the user has specified serial and fixed dilutions. This is a warning and not an error becuase it does not prevent the assay from running *)
  If[!MatchQ[samplePacketsWithConflictingKineticsDilution,{}]&&!gatherTests,
    Message[Error::BLIConflictingKineticsDilutions, ObjectToString[samplePacketsWithConflictingKineticsDilution, Simulation -> updatedSimulation]]
  ];
  (* test for conflicting kinetics dlutions - the user has specified serial and fixed dilutions. We deal with this by defaulting to fixed, but it merits a test *)
  conflictingKineticsDilutionsTests=sampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithConflictingKineticsDilution,
    "Either KineticsSampleFixedDilutions and KineticsSampleSerialDilutions have been specified for `1`:",
    updatedSimulation];

  invalidKineticsDilutionsOptions = If[Or[!MatchQ[samplePacketsWithMissingKineticsDilution,{}],!MatchQ[samplePacketsWithConflictingKineticsDilution,{}]]&&MatchQ[experimentType, Kinetics],
    {KineticsSampleSerialDilutions, KineticsSampleFixedDilutions}];

  (* if the transfer volume is bad, the option is invalid *)
  invalidKineticsSampleSerialOptions = If[!MatchQ[
    Join[
      samplePacketsWithInsufficientKineticsSerialTransferVolumes,
      samplePacketsWithTooLargeKineticsSerialDilutionVolumes
    ], {}],
    KineticsSampleSerialDilutions
  ];

  (* if the transfer volume is bad, the option is invalid *)
  invalidKineticsSampleFixedOptions = If[!MatchQ[Join[
    samplePacketsWithInsufficientKineticsFixedTransferVolumes,
    samplePacketsWithTooLargeKineticsFixedDilutionVolumes
  ], {}],
    KineticsSampleFixedDilutions
  ];

  (* Throw message for kinetics serial and fixed dilutions with volumes below 210 microliters *)
  If[!MatchQ[samplePacketsWithInsufficientKineticsSerialDilutionsVolumes,{}]&&!gatherTests&& Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::BLIInsufficientKineticsSerialDilutionsVolume,ObjectToString[samplePacketsWithInsufficientKineticsSerialDilutionsVolumes, Simulation -> updatedSimulation]]
  ];

  If[!MatchQ[samplePacketsWithInsufficientKineticsFixedDilutionsVolumes,{}]&&!gatherTests&& Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::BLIInsufficientKineticsFixedDilutionsVolume, ObjectToString[samplePacketsWithInsufficientKineticsFixedDilutionsVolumes, Simulation -> updatedSimulation]]
  ];

  (* throw errors for insufficient transfer volume ie. requested volume < 1 microliter. It is possible that the semi-automatic resolution of serial dilutions will cause this error, but Automatic will not *)
  If[!MatchQ[samplePacketsWithInsufficientKineticsSerialTransferVolumes,{}]&&!gatherTests,
    Message[Error::BLIInsufficientKineticsSerialDilutionsTransferVolume, ObjectToString[samplePacketsWithInsufficientKineticsSerialTransferVolumes, Simulation -> updatedSimulation]]
  ];

  If[!MatchQ[samplePacketsWithInsufficientKineticsFixedTransferVolumes,{}]&&!gatherTests,
    Message[Error::BLIInsufficientKineticsFixedDilutionsTransferVolume, ObjectToString[samplePacketsWithInsufficientKineticsFixedTransferVolumes Simulation -> updatedSimulation]]
  ];


  (* Throw message for missing dilution for screendetection limit in AssayDevelopment *)
  If[!MatchQ[samplePacketsWithMissingDevelopmentDilution,{}]&&!gatherTests,
    Message[Error::BLIMissingDevelopmentDilutions, ObjectToString[samplePacketsWithMissingDevelopmentDilution, Simulation -> updatedSimulation]]
  ];
  (* test for missing dilutions *)
  missingDevelopmentDilutionsTests=sampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithMissingDevelopmentDilution,
    "DetectionLimitSerialDilutions or DetectionLimitFixedDilutions are specified or Automatic for `1`:",
    updatedSimulation];

  (* Throw message for missing diluent for screendetection limit in AssayDevelopment *)
  If[!MatchQ[samplePacketsWithMissingDevelopmentDiluent,{}]&&!gatherTests,
    Message[Error::BLIMissingDevelopmentDiluents, ObjectToString[samplePacketsWithMissingDevelopmentDiluent, Simulation -> updatedSimulation]]
  ];
  (* test for missing diluent *)
  missingDevelopmentDiluentsTests=sampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithMissingDevelopmentDiluent,
    "DetectionLimitDiluent has been specified for `1` if it is needed for dilutions:",
    updatedSimulation];

  invalidDevelopmentDiluentOptions = If[!MatchQ[samplePacketsWithMissingDevelopmentDiluent,{}],
    DetectionLimitDiluent
  ];

  (* Throw message for conflicting dilutions for screendetection limit in AssayDevelopment *)
  If[!MatchQ[samplePacketsWithConflictingDevelopmentDilution,{}]&&!gatherTests,
    Message[Error::BLIConflictingDevelopmentDilutions, ObjectToString[samplePacketsWithConflictingDevelopmentDilution, Simulation -> updatedSimulation]]
  ];

  (* test for conflictign dilutions *)
  conflictingDevelopmentDilutionsTests=sampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithConflictingDevelopmentDilution,
    "Either DetectionLimitFixedDilutions or DetectionLimitSerialDilutions have been specified for `1`:",
    updatedSimulation];

  (* if either of these are true, then the fixed and serial dilutions have a problem as a set *)
  invalidDevelopmentDilutionsOptions = If[Or[
    !MatchQ[samplePacketsWithConflictingDevelopmentDilution,{}],
    !MatchQ[samplePacketsWithMissingDevelopmentDilution,{}]
  ]&&MatchQ[experimentType, AssayDevelopment]&&MatchQ[developmentType, ScreenDetectionLimit],
    {DetectionLimitSerialDilutions, DetectionLimitFixedDilutions}
  ];

  (* if the transfer volume is bad, the option is invalid *)
  invalidDevelopmentSerialOptions = If[!MatchQ[
    Join[
      samplePacketsWithInsufficientDetectionLimitSerialTransferVolumes,
      samplePacketsWithTooLargeDetectionLimitSerialDilutionVolumes
    ], {}],
    DetectionLimitSerialDilutions
  ];

  (* if the transfer volume is bad or the volume is too high the option is invalid *)
  invalidDevelopmentFixedOptions = If[!MatchQ[Join[
    samplePacketsWithInsufficientDetectionLimitFixedTransferVolumes,
    samplePacketsWithTooLargeDetectionLimitFixedDilutionVolumes
  ], {}],
    DetectionLimitFixedDilutions
  ];

  (* Throw message for kinetics serial and fixed dilutions with volumes below 210 microliters *)
  If[!MatchQ[samplePacketsWithInsufficientDetectionLimitSerialDilutionsVolumes,{}]&&!gatherTests&& Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::BLIInsufficientDevelopmentSerialDilutionsVolume, ObjectToString[samplePacketsWithInsufficientDetectionLimitSerialDilutionsVolumes, Simulation -> updatedSimulation]]
  ];

  If[!MatchQ[samplePacketsWithInsufficientDetectionLimitFixedDilutionsVolumes,{}]&&!gatherTests&& Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::BLIInsufficientDevelopmentFixedDilutionsVolume, ObjectToString[samplePacketsWithInsufficientDetectionLimitFixedDilutionsVolumes, Simulation -> updatedSimulation]]
  ];

  (* throw errors for insufficient transfer volume ie. requested volume < 1 microliter. It is possible that the semi-automatic resolution of serial dilutions will cause this error, but Automatic will not *)
  If[!MatchQ[samplePacketsWithInsufficientDetectionLimitSerialTransferVolumes,{}]&&!gatherTests,
    Message[Error::BLIInsufficientDevelopmentSerialDilutionsTransferVolume, ObjectToString[samplePacketsWithInsufficientDetectionLimitSerialTransferVolumes, Simulation -> updatedSimulation]]
  ];

  If[!MatchQ[samplePacketsWithInsufficientDetectionLimitFixedTransferVolumes,{}]&&!gatherTests,
    Message[Error::BLIInsufficientDevelopmentFixedDilutionsTransferVolume, ObjectToString[samplePacketsWithInsufficientDetectionLimitFixedTransferVolumes, Simulation -> updatedSimulation]]
  ];

  (* Throw message for missing premix solutions *)
  If[!MatchQ[samplePacketsWithMissingPreMixSolution,{}]&&!gatherTests,
    Message[Error::BLIMissingPreMixSolutions, ObjectToString[samplePacketsWithMissingPreMixSolution, Simulation -> updatedSimulation]]
  ];

  (* test for missing premix solutions *)
  missingPreMixSolutionsTests=sampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithMissingPreMixSolution,
    "PreMix solutions are defined for `1` if PreMix is selected in BinningType:",
    updatedSimulation];

  invalidPreMixSolutionOptions = If[!MatchQ[samplePacketsWithMissingPreMixSolution, {}],
    PreMixSolutions
  ];

  (* Throw message for missing premix diluent *)
  If[!MatchQ[samplePacketsWithMissingPreMixDiluent,{}]&&!gatherTests,
    Message[Error::BLIMissingPreMixDiluent, ObjectToString[samplePacketsWithMissingPreMixDiluent, Simulation -> updatedSimulation]]
  ];
  (* test for missing premix solutions *)
  missingPreMixDiluentsTests=sampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithMissingPreMixDiluent,
    "PreMixDiluent is specified for `1` if required for PreMixSolutions:",
    updatedSimulation];

  invalidPreMixDiluentOptions = If[!MatchQ[samplePacketsWithMissingPreMixDiluent,{}], PreMixDiluent];

  (* Throw message for premix solutions with excessive volume *)
  If[!MatchQ[samplePacketsWithTooLargePreMixSolution,{}]&&!gatherTests,
    Message[Error::BLITooLargePreMixSolutions, ObjectToString[samplePacketsWithTooLargePreMixSolution, Simulation -> updatedSimulation]]
  ];

  (* test for missing premix solutions *)
  tooLargePreMixSolutionsTests=sampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithTooLargePreMixSolution,
    "PreMix solutions are less than 220 Microliter for `1` if PreMix is selected in BinningType:",
    updatedSimulation];

  invalidPreMixSolutionsOptions = If[!MatchQ[samplePacketsWithTooLargePreMixSolution, {}],
    PreMixSolutions
  ];

  (* throw a warning if the PreMix volume is too low *)
  If[!MatchQ[samplePacketsWithInsufficientPreMixVolumes,{}]&&!gatherTests&& Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::BLIInsufficientPreMixVolume, ObjectToString[samplePacketsWithInsufficientPreMixVolumes, Simulation -> updatedSimulation]]
  ];

  (* test for insufficient transfer volumes dilutions *)
  insufficientTransferVolumesTests = sampleTests[gatherTests,
    Test,
    samplePackets,
    DeleteDuplicates[Join[
      samplePacketsWithInsufficientKineticsFixedTransferVolumes, samplePacketsWithInsufficientKineticsSerialTransferVolumes,
      samplePacketsWithInsufficientDetectionLimitFixedTransferVolumes, samplePacketsWithInsufficientDetectionLimitSerialTransferVolumes
    ]],
    "All dilutions use attainable transfer volumes for input sample `1`:",
    updatedSimulation];

  (* -- large volume tests -- *)
  (* test for large detection limit dilution volumes solutions *)
  tooLargeDetectionLimitFixedDilutionsTests=sampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithTooLargeDetectionLimitFixedDilutionVolumes,
    "DetectionLimitFixedDilutions are less than 2 Milli Liter for `1`:",
    updatedSimulation];

  (* test for large detection limit dilution volumes solutions *)
  tooLargeDetectionLimitSerialDilutionsTests=sampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithTooLargeDetectionLimitSerialDilutionVolumes,
    "DetectionLimitSerialDilutions are less than 2 Milli Liter for `1`:",
    updatedSimulation];

  (* test for large kinetics dilution volumes solutions *)
  tooLargeKineticsSerialDilutionsTests=sampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithTooLargeKineticsSerialDilutionVolumes,
    "KineticsSampleSerialDilutions are less than 2 Milli Liter for `1`:",
    updatedSimulation];

  (* test for large kinetics dilution volumes solutions *)
  tooLargeKineticsFixedDilutionsTests=sampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithTooLargeKineticsFixedDilutionVolumes,
    "KineticsSampleFixedDilutions are less than 2 Milli Liter for `1`:",
    updatedSimulation];

  (* -- large volume errors -- *)

  (* Throw message for kinetics solutions with excessive volume *)
  If[!MatchQ[samplePacketsWithTooLargeKineticsFixedDilutionVolumes,{}]&&!gatherTests,
    Message[Error::BLITooLargeDilutionVolume, ObjectToString[samplePacketsWithTooLargeKineticsFixedDilutionVolumes, Simulation -> updatedSimulation]]
  ];

  (* Throw message for kinetics solutions with excessive volume *)
  If[!MatchQ[samplePacketsWithTooLargeKineticsSerialDilutionVolumes,{}]&&!gatherTests,
    Message[Error::BLITooLargeDilutionVolume, ObjectToString[samplePacketsWithTooLargeKineticsSerialDilutionVolumes, Simulation -> updatedSimulation]]
  ];

  (* Throw message for detection limit solutions with excessive volume *)
  If[!MatchQ[samplePacketsWithTooLargeDetectionLimitSerialDilutionVolumes,{}]&&!gatherTests,
    Message[Error::BLITooLargeDilutionVolume, ObjectToString[samplePacketsWithTooLargeDetectionLimitSerialDilutionVolumes, Simulation -> updatedSimulation]]
  ];

  (* Throw message for detection limit solutions with excessive volume *)
  If[!MatchQ[samplePacketsWithTooLargeDetectionLimitFixedDilutionVolumes,{}]&&!gatherTests,
    Message[Error::BLITooLargeDilutionVolume, ObjectToString[samplePacketsWithTooLargeDetectionLimitFixedDilutionVolumes, Simulation -> updatedSimulation]]
  ];

  (* -- Check the QuantitationStandardSerial/FixedDilution volumes -- *)
  {
    tooLargeQuantitationStandardSerialDilutionsBool,
    tooSmallQuantitationStandardSerialDilutionsBool,
    tooSmallQuantitationStandardSerialDilutionTransferBool
  } = Module[{safeQuantitationSerialDilutions, totalVolumes, finalVolumes, allVolumes},

    (* format the dilutions for easy use *)
    safeQuantitationSerialDilutions = standardizedBLIDilutions[quantitationStandardSerialDilutions, Serial];

    (* get the actual final volume out by subtracting the next transfer volume from the sum of the previous element *)
    finalVolumes = If[MatchQ[safeQuantitationSerialDilutions, Null],
      (*just a placeholder to prevent unwanted errors*)
      {210 Microliter},

      (* total the diluent and transfer amount in (Total of the first 2 list elements), and subtract the transfer out (the first element, minus the first dilution since that is the original transfer in) *)
      Subtract[Total[Most[#]]&/@safeQuantitationSerialDilutions, Flatten[{Rest[First/@safeQuantitationSerialDilutions], 0 Microliter}]]
    ];

    (* extract the total volume *)
    totalVolumes = If[MatchQ[safeQuantitationSerialDilutions, Null],
      {0 Microliter},
      Total[Most[#]]&/@safeQuantitationSerialDilutions
    ];

    (* make a list of all of the transfer volumes *)
    allVolumes = If[MatchQ[safeQuantitationSerialDilutions, Null],
      {100 Microliter},
      Flatten[{Most[#]&/@safeQuantitationSerialDilutions}]
    ];

    (* determine the booleans for compliant volumes *)

    {
      (* the boolean for large transfers *)
      If[MatchQ[Max[totalVolumes], GreaterP[2000 Microliter]],
        True,
        False
      ],
      (* the boolean for small volumes *)
      If[MatchQ[Min[finalVolumes], LessP[210 Microliter]],
        True,
        False
      ],
      (* the boolean for small transfer volumes - don't throw an error for zero *)
      If[MatchQ[Min[allVolumes], LessP[1 Microliter]]&&MatchQ[Min[allVolumes], GreaterP[0 Microliter]],
        True,
        False
      ]
    }
  ];

  (* determine if there are dilutions that are too big to fit in the containers or too small to be useful *)
  {
    tooLargeQuantitationStandardFixedDilutionsBool,
    tooSmallQuantitationStandardFixedDilutionsBool,
    tooSmallQuantitationStandardFixedDilutionTransferBool
  } = Module[{safeQuantitationFixedDilutions, totalVolumes, allVolumes},

    (* format the dilutions for easy use *)
    safeQuantitationFixedDilutions = standardizedBLIDilutions[quantitationStandardFixedDilutions, Fixed];

    (* extract the total volume *)
    totalVolumes = If[MatchQ[safeQuantitationFixedDilutions, Null],
      (* just give a safe value *)
      {210 Microliter},
      Total[Most[#]]&/@safeQuantitationFixedDilutions
    ];

    (* make a list of all the transfer volumes *)
    allVolumes = If[MatchQ[safeQuantitationFixedDilutions, Null],
      (* just give a safe value *)
      {100 Microliter},
      Flatten[{Most[#]&/@safeQuantitationFixedDilutions}]
    ];

    (* booleans for if the volumes are compliant *)
    {
      If[MatchQ[Max[totalVolumes], GreaterP[2000 Microliter]],
        True,
        False
      ],
      If[MatchQ[Min[totalVolumes], LessP[210 Microliter]],
        True,
        False
      ],
      If[MatchQ[Min[allVolumes], LessP[1 Microliter]]&&MatchQ[Min[allVolumes], GreaterP[0 Microliter]],
        True,
        False
      ]
    }
  ];

  (* -- Make tests, identify options, and throw errors for bad dilution volumes -- *)

  (* Throw message for quantitationstandard dilutions with excessive volume *)
  If[MatchQ[tooLargeQuantitationStandardSerialDilutionsBool,True]&&!gatherTests,
    Message[Error::BLIStandardTooLargeDilutionVolume, QuantitationStandardSerialDilutions]
  ];

  If[MatchQ[tooLargeQuantitationStandardFixedDilutionsBool,True]&&!gatherTests,
    Message[Error::BLIStandardTooLargeDilutionVolume, QuantitationStandardFixedDilutions]
  ];

  (* test for too large dilution *)
  tooLargeQuantitationStandardDilutionsTest = If[gatherTests,
    Test["If quantitation standard dilutions are defined, the largest dilution is less than 2 mL:",
      Or[MatchQ[tooLargeQuantitationStandardFixedDilutionsBool, True], MatchQ[tooLargeQuantitationStandardSerialDilutionsBool, True]],
      False
    ],
    Null
  ];

  (* too large quantitation dilution options *)
  tooLargeQuantitationStandardDilutionOptions = Which[

    MatchQ[tooLargeQuantitationStandardSerialDilutionsBool, True]&&MatchQ[tooLargeQuantitationStandardFixedDilutionsBool, True],
    {QuantitationStandardSerialDilutions, QuantitationStandardFixedDilutions},

    MatchQ[tooLargeQuantitationStandardSerialDilutionsBool, True],
    {QuantitationStandardSerialDilutions},

    MatchQ[tooLargeQuantitationStandardFixedDilutionsBool, True],
    {QuantitationStandardFixedDilutions},

    True,
    {}
  ];

  (* -- Quantitation Standard dilution too small volume -- *)

  (* too small quantitation dilution options *)
  tooSmallQuantitationStandardDilutionOptions = Which[

    MatchQ[tooSmallQuantitationStandardSerialDilutionsBool, True]&&MatchQ[tooSmallQuantitationStandardFixedDilutionsBool, True],
    {QuantitationStandardSerialDilutions, QuantitationStandardFixedDilutions},

    MatchQ[tooSmallQuantitationStandardSerialDilutionsBool, True],
    {QuantitationStandardSerialDilutions},

    MatchQ[tooSmallQuantitationStandardFixedDilutionsBool, True],
    {QuantitationStandardFixedDilutions},

    True,
    {}
  ];

  (* test for too small quantitation standard dilution *)
  tooSmallQuantitationStandardDilutionsTest = If[gatherTests,
    Test["If quantitation standard dilutions are defined, the smallest volume dilution is more than 210 uL:",
      Or[MatchQ[tooSmallQuantitationStandardFixedDilutionsBool, True], MatchQ[tooSmallQuantitationStandardSerialDilutionsBool, True]],
      False
    ],
    Null
  ];

  (* Throw message for quantitationstandard dilutions with too low volume *)
  If[!MatchQ[tooSmallQuantitationStandardDilutionOptions,{}]&&!gatherTests,
    Message[Error::BLIInsufficientQuantitationStandardDilutionVolume, tooSmallQuantitationStandardDilutionOptions]
  ];

  (* -- Quantitation Standard dilution too small transfers -- *)
  (* too small quantitation transfer options *)
  tooSmallQuantitationStandardTransferOptions = Which[

    MatchQ[tooSmallQuantitationStandardSerialDilutionTransferBool, True]&&MatchQ[tooSmallQuantitationStandardFixedDilutionTransferBool, True],
    {QuantitationStandardSerialDilutions, QuantitationStandardFixedDilutions},

    MatchQ[tooSmallQuantitationStandardSerialDilutionTransferBool, True],
    {QuantitationStandardSerialDilutions},

    MatchQ[tooSmallQuantitationStandardFixedDilutionTransferBool, True],
    {QuantitationStandardFixedDilutions},

    True,
    {}
  ];

  (* test for too small quantitation standard dilution *)
  tooSmallQuantitationStandardTransfersTest = If[gatherTests,
    Test["If quantitation standard dilutions are defined, the smallest transfer volume is more than 1 uL:",
      MatchQ[tooSmallQuantitationStandardTransferOptions, {}],
      True
    ],
    Null
  ];

  (* Throw message for quantitationstandard trasnfers with too low volume *)
  If[!MatchQ[tooSmallQuantitationStandardTransferOptions,{}]&&!gatherTests,
    Message[Error::BLIInsufficientQuantitationDilutionsTransferVolume, tooSmallQuantitationStandardTransferOptions]
  ];


  (* ---------------------------------------- *)
  (* --- GATHER SOLUTION NAMES OR NUMBERS --- *)
  (* ---------------------------------------- *)

  (* If the solutions/dilutiosn exists, label them, then extract their names *)
  labeledFixedKineticsDilutionsNames = If[MatchQ[kineticsSampleFixedDilutions, (Null|{Null...})],
    Null, {#, Fixed}&/@kineticsSampleFixedDilutions
  ];
  labeledSerialKineticsDilutionsNames = If[MatchQ[kineticsSampleSerialDilutions, (Null|{Null...})],
    Null, {#, Serial}&/@kineticsSampleSerialDilutions
  ];
  labeledFixedDetectionLimitDilutionsNames = If[MatchQ[detectionLimitFixedDilutions, (Null|{Null...})],
    Null, {#, Fixed}&/@detectionLimitFixedDilutions
  ];
  labeledSerialDetectionLimitDilutionsNames = If[MatchQ[detectionLimitSerialDilutions, (Null|{Null...})],
    Null, {#, Serial}&/@detectionLimitSerialDilutions
  ];
  labeledPreMixSolutionNames = If[MatchQ[preMixSolutions, (Null|{Null...})],
    Null, {#, PreMix}&/@preMixSolutions
  ];

  (* ues the helper function to extract the names *)
  fixedKineticsDilutionsNames = If[MatchQ[labeledFixedKineticsDilutionsNames, Null],
    {Null},
    namesFromBLIDilutions[#]&/@labeledFixedKineticsDilutionsNames
  ];

  serialKineticsDilutionsNames = If[MatchQ[labeledSerialKineticsDilutionsNames, Null],
    {Null},
    namesFromBLIDilutions[#]&/@labeledSerialKineticsDilutionsNames
  ];

  fixedDetectionLimitDilutionsNames = If[MatchQ[labeledFixedDetectionLimitDilutionsNames, Null],
    {Null},
    namesFromBLIDilutions[#]&/@labeledFixedDetectionLimitDilutionsNames
  ];
  serialDetectionLimitDilutionsNames = If[MatchQ[labeledSerialDetectionLimitDilutionsNames, Null],
    {Null},
    namesFromBLIDilutions[#]&/@labeledSerialDetectionLimitDilutionsNames
  ];
  preMixSolutionNames = If[MatchQ[labeledPreMixSolutionNames, Null],
    {Null},
    namesFromBLIDilutions[#]&/@labeledPreMixSolutionNames
  ];
  fixedQuantitationStandardNames = If[MatchQ[quantitationStandardFixedDilutions,Null],
    {Null},
    namesFromBLIDilutions[{quantitationStandardFixedDilutions, Fixed}]
  ];
  serialQuantitationStandardNames = If[MatchQ[quantitationStandardSerialDilutions,Null],
    {Null},
    namesFromBLIDilutions[{quantitationStandardSerialDilutions, Serial}]
  ];

  (*gather all of the solution names together*)
  allSolutionNames = DeleteCases[
    Flatten[
      {
        preMixSolutionNames,
        serialDetectionLimitDilutionsNames,
        fixedDetectionLimitDilutionsNames,
        serialKineticsDilutionsNames,
        fixedKineticsDilutionsNames,
        fixedQuantitationStandardNames,
        serialQuantitationStandardNames
      }
    ],
    Null
  ];


  (* collect duplicate names along with their lists *)
  DuplicateDilutionNames = First/@Select[Tally[allSolutionNames], Last[#]>1&];

  (* find out where the duplicate names came from *)
  duplicateNameLocations = DeleteDuplicates[
    Map[
      Function[{badName},
        Module[{listsWithDuplicates},

          (* see which list contains the duplicate *)
          listsWithDuplicates = Select[{
            {preMixSolutionNames, PreMixSolutions},
            {serialDetectionLimitDilutionsNames, DetectionLimitSerialDilutions},
            {fixedDetectionLimitDilutionsNames, DetectionLimitFixedDilutions},
            {serialKineticsDilutionsNames, KineticsSampleSerialDilutions},
            {fixedKineticsDilutionsNames, KineticsSampleFixedDilutions},
            {fixedQuantitationStandardNames, QuantitationStandardFixedDilutions},
            {serialQuantitationStandardNames, QuantitationStandardSerialDilutions}
          }, MemberQ[Flatten[ToList[First[#]]], badName]&];

          (* return the option(s) with the offending name(s) *)
          If[MatchQ[listsWithDuplicates, {}],
            Nothing,
            Last/@listsWithDuplicates
          ]
        ]
      ],
      DuplicateDilutionNames
    ]
  ];

  (* Duplicate Name error check: *)
  If[!MatchQ[DuplicateDilutionNames, {}]&&!gatherTests,
    Message[Error::BLIDuplicateDilutionNames,Flatten[DuplicateDilutionNames], Flatten[duplicateNameLocations]]
  ];

  (* test for duplicate solution Names *)
  duplicateDilutionIDTest = If[gatherTests&&MatchQ[allSolutionNames, Except[{}]],
    Test["If there are dilutions or solutions defined in the options, they all have a unique identifying number:",
      MatchQ[DuplicateDilutionNames, {}],
      True
    ],
    Null
  ];

  (* -- too many dilutions check -- *)

  (* identify which options have too many dilutions *)
  optionsWithTooManyDilutions = If[MatchQ[Length[allSolutionNames], GreaterP[96]],
    PickList[
      {KineticsSampleSerialDilutions, KineticsSampleFixedDilutions, DetectionLimitSerialDilutions, DetectionLimitFixedDilutions, QuantitationStandardSerialDilutions, QuantitationStandardFixedDilutions},
      {kineticsSampleSerialDilutions, kineticsSampleFixedDilutions, detectionLimitSerialDilutions, detectionLimitFixedDilutions, quantitationStandardSerialDilutions, quantitationStandardFixedDilutions},
      Except[(Null|{}|{Null..}|{{Null..}..})]
    ],
    {}
  ];

  (* error if there are too many dilutions *)
  If[!MatchQ[optionsWithTooManyDilutions, {}]&&!gatherTests,
    Message[Error::BLITooManyDilutions, optionsWithTooManyDilutions, Length[allSolutionNames]]
  ];

  (* test for duplicate solution Names *)
  tooManyDilutionsTest = If[gatherTests,
    Test["If there are dilutions or solutions defined in the options, there are fewer than 96 different solutions:",
      !MatchQ[Length[allSolutionNames], GreaterP[96]],
      True
    ],
    Null
  ];

  (* -- conflicting dilutions check -- *)

  conflictingQuantitationStandardDilutionsBool = If[
    And[
      MatchQ[quantitationStandardSerialDilutions, Except[(Null|{Null...})]],
      MatchQ[quantitationStandardFixedDilutions, Except[(Null|{Null...})]]
    ],
    True,
    False
  ];

  (* if there are conflicting dilutiosn, throw an error *)
  If[MatchQ[conflictingQuantitationStandardDilutionsBool, True]&&!gatherTests,
    Message[Error::BLIConflictingQuantitationStandardDilutions]
  ];

  (* if the bool is false, the test will return true *)
  conflictingQuantitationStandardDilutionTests = If[gatherTests,
    Test["If there are dilutions for the quantitation standard curve, only one dilution method is defined:",
      MatchQ[conflictingQuantitationStandardDilutionsBool, False],
      True
    ],
    Null
  ];

  (* gather the invaldi options *)
  conflictingQuantitationStandardOptions = If[MatchQ[conflictingQuantitationStandardDilutionsBool, True],
    {QuantitationStandardSerialDilutions, QuantitationStandardFixedDilutions},
    {}
  ];


  (* check for missing quantitation standard *)
  missingQuantitationStandardBool = If[Or[
    MemberQ[ToList[quantitationParameters], StandardCurve]&&MatchQ[quantitationStandard, Null],
    MemberQ[ToList[quantitationParameters], StandardCurve]&&MatchQ[quantitationStandard, Automatic]&&MatchQ[standard, Null],
    MemberQ[ToList[quantitationParameters], StandardWell]&&MatchQ[quantitationStandardWell, Null]&&MatchQ[quantitationStandard, Null],
    Or[MatchQ[quantitationStandardSerialDilutions, Except[(Null|{Null..}|{{Null..}..})]],MatchQ[quantitationStandardSerialDilutions, Except[(Null|{Null..}|{{Null..}..})]]]&&MatchQ[quantitationStandard, Null]
  ],
    True,
    False
  ];

  (* throw an error if the standard is missing *)
  If[MatchQ[missingQuantitationStandardBool, True]&&!gatherTests,
    Message[Error::BLIUnspecifiedQuantitationStandard]
  ];

  (* collect options that are invalid *)
  missingQuantitationStandardOptions = If[MatchQ[missingQuantitationStandardBool, True],
    QuantitationStandard,
    {}
  ];

  (* missing quantitation standard test *)
  missingQuantitationStandardTest =  If[gatherTests,
    Test["If StandardCurve or StandardWell is requested in QuantitationParameters, the QuantitationStandard is informed:",
      MatchQ[missingQuantitationStandardBool, False],
      True
    ],
    Null
  ];

  (* -- missing requested standard for kinetics or assaydevelopment -- *)

  (* in situations where standard is included in the primitives, it must be specified not Null *)
  missingStandardOptions = Which[
    (* for kinetics, if standard is selected *)
    And[MatchQ[experimentType, Kinetics], MemberQ[ToList[Lookup[bliOptionsAssociation, KineticsReferenceType]], Standard], MatchQ[standard, Null]],
    {Standard, KineticsReferenceType},

    And[MatchQ[experimentType, AssayDevelopment], MemberQ[ToList[Lookup[bliOptionsAssociation, DevelopmentReferenceWell]], Standard], MatchQ[standard, Null]],
    {Standard, DevelopmentReferenceWell},

    True,
    {}
  ];

  (* throw an error if standard is requested by Kinetics or AssayDevelopment but not provided *)
  If[MatchQ[missingStandardOptions, Except[{}]]&&!gatherTests,
    Message[Error::BLIMissingRequestedStandard, Last[missingStandardOptions]]
  ];

  (* test if the standard has been appropriatly specified *)
  missingStandardTest = Test["If a standard is requested for Kinetics or AssayDevelopment, it is not Null:",
    MatchQ[missingStandardOptions, {}],
    True
  ];

  (* -- unused blanks and standards -- *)

  (* check if standards were specified but not used *)
  unusedStandardOption = Which[

    (* if the experimetn type is kinetics and standard is specified but Standard is not an element of KineticsReferenceType*)
    And[MatchQ[experimentType, Kinetics], !MemberQ[ToList[Lookup[bliOptionsAssociation, KineticsReferenceType]], Standard], MatchQ[standard, Except[Null]]],
    {KineticsReferenceType},

    (* if the experiemnt type is AssayDevelopment and standard si specified but not and element of DevelopmentReferenceWell *)
    And[MatchQ[experimentType, AssayDevelopment], !MemberQ[ToList[Lookup[bliOptionsAssociation, DevelopmentReferenceWell]], Standard], MatchQ[standard, Except[Null]]],
    {DevelopmentReferenceWell},

    True,
    {}
  ];

  (* check if blanks were specified but not used *)
  unusedBlankOption = Which[
    (* if the experiment type is kinetics and blank is specified but Blank is not an element of KineticsReferenceType*)
    And[MatchQ[experimentType, Kinetics], !MemberQ[ToList[Lookup[bliOptionsAssociation, KineticsReferenceType]], Blank], MatchQ[Lookup[bliOptionsAssociation, Blank], Except[(Null|Automatic)]]],
    {KineticsReferenceType},

    (* if the experiment type is AssayDevelopment and blank is specified but not and element of DevelopmentReferenceWell *)
    And[MatchQ[experimentType, AssayDevelopment], !MemberQ[ToList[Lookup[bliOptionsAssociation, DevelopmentReferenceWell]], Blank], MatchQ[Lookup[bliOptionsAssociation, Blank], Except[(Null|Automatic)]]],
    {DevelopmentReferenceWell},

    (* same thing for epitope binning *)
    And[MatchQ[experimentType, EpitopeBinning], MatchQ[binningControlWell, False], MatchQ[Lookup[bliOptionsAssociation, Blank], Except[(Null|Automatic)]]],
    {BinningControlWell},

    True,
    {}
  ];

  (* throw a warning if the standard or blank was specified but not used *)
  If[!MatchQ[unusedStandardOption, {}]&&!gatherTests&&!MatchQ[$ECLApplication, Engine],
    Message[Warning::BLIUnusedStandard, First[unusedStandardOption]]
  ];
  If[!MatchQ[unusedBlankOption, {}]&&!gatherTests&&!MatchQ[$ECLApplication, Engine],
    Message[Warning::BLIUnusedBlank, First[unusedBlankOption]]
  ];

  (* -------------------------------------- *)
  (* --- RESOLUTION OF EXPANDED SAMPLES --- *)
  (* -------------------------------------- *)

  (* These are the samples that replace any Samples Keys in the MA, Load, or Quantitate primitives. *)
  (* solution resolution based on options for blanks, dilutions, and samples in. The output is a list of solutions where each has the form:
  {{solution1, solution2, solution3...},{blank, blank}} and the flattened length < 8*)
  expandedSamples = Module[{userInputControls, userInputBlankValues,
    safeUserInputControls, safeUserInputBlankValues, resolvedExpandedSamples
  },

    (* if the user has already put blanks in the sample step, we will extract them and use a boolean to indicate this to later steps *)
    (*note that the number of blanks will not be greater than 7 because of the restrictive primitive pattern*)
    {userInputControls, userInputBlankValues} = If[MatchQ[assaySequencePrimitives, Except[(Automatic|Null)]],
      (* look for any Samples - if they are there, grab the associated blank and set the boolean to True *)
      {
        True,
        If[MemberQ[Values[#], Samples], Lookup[Association@@#, Controls, Nothing], Nothing]&/@assaySequencePrimitives
      },

      (* no primitives? set the boolean false *)
      {
        False,
        {}
      }
    ];

    (* if there are no blanks, thats ok. If there are multiple sample steps with the same blank, we will remove duplicates and use that. *)
    {safeUserInputControls, safeUserInputBlankValues} = If[MatchQ[Length[DeleteDuplicates[userInputBlankValues]], LessEqualP[1]]&&!MatchQ[userInputBlankValues, {}],
      {True,DeleteDuplicates[userInputBlankValues]},
      {False, {}}
    ];

    (* resolve the analytes/blanks based on the experiment type *)
    resolvedExpandedSamples = Switch[

      experimentType,

      (* RESOLVE FOR KINETICS *)

      Kinetics,
      Module[{kineticsControls, expandedKineticsSolutions, kineticsDilutionName, paddedKineticsSamples},
        (* if blanks/standards are specified, collect them here. First priority goes to any user specified blanks in the primitives*)
        kineticsControls =
            Which[

              safeUserInputControls,
              safeUserInputBlankValues,

              SubsetQ[ToList[kineticsReferenceType], {Blank, Standard}],
              {blank, standard},

              SubsetQ[ToList[kineticsReferenceType], {Blank}],
              {blank},

              SubsetQ[ToList[kineticsReferenceType], {Standard}],
              {standard},

              True,
              {}
            ];

        (* the dilutions are already resolved above as kinticsSampleDilutions the operation to split samples should be mapped across them to enforce that each set of dilutions is measured individually*)
        (* the rules is to break into lists of 8-buffers, then pad any lists that are too short to be 8-buffers long with Nulls *)
        expandedKineticsSolutions = Function[{dilutionSet},

          (* extract the solution names from the dilutions using the helper function. Note that these are pre tagged as Serial/Fixed *)
          kineticsDilutionName = namesFromBLIDilutions[dilutionSet];

          (* partition is super overloaded - this call will split the inputs into lists of the appropriate length, padding with null  *)
          paddedKineticsSamples = Partition[ToList[kineticsDilutionName],(8-Length[kineticsControls]), (8-Length[kineticsControls]), 1, defaultBuffer];

          (* combine the kinetics blanks with blanks with the samples *)
          Transpose[{paddedKineticsSamples, ConstantArray[kineticsControls, Length[paddedKineticsSamples]]}]

          (*this section is technically index matched, even though it happens outside of that block.*)
        ]/@kineticsSampleDilutions;

        (* the mapping here creates an extra layer of nesting which has to be removed to match the other assay types *)
        Flatten[expandedKineticsSolutions, 1]
      ],

      (* RESOLVE FOR QUANTITATION *)

      Quantitation,
      Module[{quantitationControls, expandedQuantitationStandardDilutions, quantitationStandardDilutions, quantitationStandardDilutionNames, paddedQuantitationStandardDilutions,
        paddedQuantitationSamples, expandedQuantitationSamples, expandedQuantitationSolutions},
        (* determine the quantitation blanks based on the quantitationStandardWell value *)
        quantitationControls =
            Which[

              safeUserInputControls,
              safeUserInputBlankValues,

              SubsetQ[ToList[quantitationParameters], {BlankWell, StandardWell}],
              {blank, quantitationStandardWell},

              SubsetQ[ToList[quantitationParameters], {BlankWell}],
              {blank},

              SubsetQ[ToList[quantitationParameters], {StandardWell}],
              {quantitationStandardWell},

              True,
              {}
            ];

        (* if dilutions are requested, get the names and generate a lists which correspond to a plate column *)
        expandedQuantitationStandardDilutions = If[MemberQ[ToList[quantitationParameters], StandardCurve],

          (* determine which set of dilutions to use, if both are specified we will use the fixed ones. There was already a warning thrown earlier. *)
          quantitationStandardDilutions = If[MatchQ[quantitationStandardFixedDilutions, Null],
            {quantitationStandardSerialDilutions, Serial},
            {quantitationStandardFixedDilutions, Fixed}
          ];

          (* extract the names from the solutions using the helper function *)
          quantitationStandardDilutionNames = namesFromBLIDilutions[quantitationStandardDilutions];

          (* use the Partition function to simultaneously break up the dilutions into lists of the appropriate length, and pad with Nulls *)
          paddedQuantitationStandardDilutions = Partition[ToList[quantitationStandardDilutionNames],(8-Length[quantitationControls]), (8-Length[quantitationControls]), 1, defaultBuffer];

          (* combine the blanks and solutions such that each element of the output is a complete plate column when flattened. *)
          Transpose[{paddedQuantitationStandardDilutions, ConstantArray[quantitationControls, Length[paddedQuantitationStandardDilutions]]}],
          {}
        ];

        (* break up samples into lists of the appropriate length, and pad with Nulls *)
        paddedQuantitationSamples = Partition[mySamples,(8-Length[quantitationControls]), (8-Length[quantitationControls]), 1, defaultBuffer];

        (* combine the samples with the blanks *)
        expandedQuantitationSamples = Transpose[{paddedQuantitationSamples, ConstantArray[quantitationControls, Length[paddedQuantitationSamples]]}];

        (* combine the columns for samples and standard curve if needed. Remove the Null if there is no Standard Curve measurement *)
        expandedQuantitationSolutions = DeleteCases[Join[expandedQuantitationStandardDilutions, expandedQuantitationSamples],Null]
      ],

      (* RESOLVE FOR EPITOPEBINNING *)

      EpitopeBinning,
      (* for epitope binning, the control well is actually in load steps, not in the measurement step. For binning it is 99% probable that we want to fill the whole row. *)
      (* the only problem is if they are doing a n x n experiment where n<8, in which case this resolution may cause errors related to solution volumes. *)
      (* in this case, only the number of columns which match the number of samples are included, and the sample is included as a control if there was a control in the loading step *)
      (* Note that the padding is done here so that the primitives come out ok since we assume later that for binning the lists are the right dimensions *)
      If[Or[
        MatchQ[Length[mySamples], GreaterP[8]],
        MatchQ[Length[mySamples], GreaterP[7]]&&MatchQ[binningControlWell, True]
      ],

        (* if there are too many samples, just return something innnocuous to keep the rest of the resolver from erroring more. When Length[mySamples]>8 the protocol will not generate anyway. *)
        ConstantArray[{{ConstantArray[defaultBuffer, 8]},{}}, Length[mySamples]],

        (* -- if there are fewer than 8 solutions it is safe to proceed -- *)
        If[MatchQ[binningType, PreMix],

          (* make sure we are looking at a list first, it may be a null if they made a mistake defining their solutions *)
          If[MatchQ[binningControlWell, True],

            (* if the binningControlWell is used, make sure that there is antibody (sample) in the last well *)
            {
              Join[
                ConstantArray[Last[ToList[#]], Length[ToList[mySamples]]],
                ConstantArray[defaultBuffer, 7-Length[ToList[mySamples]]]
              ],
              {#}
            }&/@preMixSolutions,

            (* if the binningControlWell is not used  *)
            {
              Join[
                ConstantArray[Last[ToList[#]], Length[ToList[mySamples]]],
                ConstantArray[defaultBuffer, 8-Length[ToList[mySamples]]]
              ],
              {}
            }&/@preMixSolutions
          ],

          (* if it is a sandwich or tandem type assay, just use the samples in *)
          If[MatchQ[binningControlWell, True],

            (* if the control well is used, there needs to be antibody in the last well for reference *)
            {
              Join[
                ConstantArray[#, Length[ToList[mySamples]]],
                ConstantArray[defaultBuffer, 7-Length[ToList[mySamples]]]
              ],
              {#}
            }&/@mySamples,

            (* if the binningControlWell is not used, no controls *)
            {
              Join[
                ConstantArray[#, Length[ToList[mySamples]]],
                ConstantArray[defaultBuffer, 8-Length[ToList[mySamples]]]
              ],
              {}
            }&/@mySamples
          ]
        ]
      ],

      (* RESOLVE FOR ASSAY DEVELOPMENT *)

      AssayDevelopment,
      Module[{assayDevelopmentControls, expandedAssayDevelopmentSolutions, detectionLimitDilutionName, paddedDetectionLimitSamples},
        (* look up the values and put them in list form *)
        assayDevelopmentControls =
            Which[
              safeUserInputControls,
              safeUserInputBlankValues,

              SubsetQ[ToList[developmentReferenceWell], {Blank, Standard}],
              {blank, standard},

              SubsetQ[ToList[developmentReferenceWell], {Blank}],
              {blank},

              SubsetQ[ToList[developmentReferenceWell], {Standard}],
              {standard},

              True,
              {}
            ];
        (* the dilutions are already resolved above as detectionLimitDilutions the operation to split samples should be map threaded across them to enforce index matching*)
        (* the rules is to break into lists of 8-buffers, then pad any lists that are too short to be 8-buffers long with Nulls *)
        expandedAssayDevelopmentSolutions =
            Which[
              MatchQ[developmentType, ScreenDetectionLimit],
              Flatten[Function[{dilutionSet},

                (*extract the names form the dilutions using the helper function *)
                detectionLimitDilutionName = namesFromBLIDilutions[dilutionSet];

                paddedDetectionLimitSamples = Partition[ToList[detectionLimitDilutionName],(8-Length[assayDevelopmentControls]), (8-Length[assayDevelopmentControls]), 1, defaultBuffer];

                (* put the blanks and solutiosn together in a useful way *)
                Transpose[{paddedDetectionLimitSamples, ConstantArray[assayDevelopmentControls, Length[paddedDetectionLimitSamples]]}]
              ]/@detectionLimitDilutions, 1],


              MatchQ[developmentType, ScreenInteraction],
              (* for screen interaction, there is no option to indicate a blank, but they may have a blank in a primitive wiht a sample key, in which case we need to use safeUserInputBlankValues *)
              Module[{columns},
                columns = Partition[mySamples,(8-Length[safeUserInputBlankValues]), (8-Length[safeUserInputBlankValues]), 1, defaultBuffer];
                Transpose[{columns, ConstantArray[safeUserInputBlankValues, Length[columns]]}]
              ],


              MatchQ[developmentType, Except[(ScreenDetectionLimit|ScreenInteraction)]],
              (* if we are not looking at detection limit or test interactions, then the samples will just fill the whole row *)
              Transpose[{ConstantArray[#, (8-Length[assayDevelopmentControls])]&/@mySamples, ConstantArray[assayDevelopmentControls, Length[mySamples]]}]
            ];
        expandedAssayDevelopmentSolutions
      ]
    ]
  ];

  (* there is no option to specify blanks for loading so the user will not be able to break this system. *)
  (* measuredSamples is a flattened list that can be displayed in a single primitive in AssaySequencePrimitives *)
  measuredSamples = DeleteCases[Flatten[First/@expandedSamples], Null];

  (* --- TEST INTERACTION SOLUTIONS --- *)

  (* expandedTestInteractionSolutions must index match to the expandedSamples *)
  expandedTestInteractionSolutions = If[MatchQ[Length[testInteractionSolutions], Length[mySamples]],

    (* break the test interaction solutiosn into lists which match the expandedSamples *)
    Partition[ToList[testInteractionSolutions], 8,8,1,defaultBuffer],

    (* even if we are not doing test interaction solutions, make a list of the right length to prevent the map thread from freaking out *)
    ConstantArray[Null, Length[expandedSamples]]
  ];

  safeTestInteractionSolutions = PadRight[expandedTestInteractionSolutions, Length[expandedSamples], defaultBuffer];



  (* ---------------------------------------- *)
  (* --- RESOLVED PRIMITIVES FROM OPTIONS --- *)
  (* ---------------------------------------- *)

  (* The sampleExpandedResolvedPrimitives are a complete set of steps that will occur in the assay. It is formed by mapping over the expandedSamples set. There may still be primitives with more than
   one column worth of solutions, but this will be treated at the same time as treating the user input primitives. *)
  {sampleExpandedResolvedPrimitives, resolvedPrimitiveKeys, resolvedRequiredOptions, resolvedRequiredOptionValues} = Module[{
    primitiveKeys, requiredOptions, requiredOptionsValues,
    (* equilibrate block variables *)
    resolvedEquilibrateBuffer, resolvedEquilibrateBufferKey, equilibrateBlockAssociation, equilibrateBlock, equilibrateOptions, equilibrateValues, equilibrateKeys,
    (* regenerate block variables *)
    resolvedRegenerateSolutions, resolvedRegenerateSolutionsKey, regenerationBlock, regenerationOptions, regenerationValues, regenerationKeys,
    resolvedRegenerateWashSolutions, resolvedRegenerateWashSolutionsKey, singleRegenerationBlock, singleRegenerationOptions, singleRegenerationValues, singleRegenerationKeys,
    regenerateBlockAssociation, expandedRegenerationBlock, expandedRegenerationValues, expandedRegenerationOptions, expandedRegenerationKeys,
    (* four different loading blocks to assemble: antigen, antibody, regular loading, and interaction *)
    loadingBlock, loadingOptions, loadingValues, loadingKeys,
    antigenLoadingBlock, antigenLoadingOptions, antigenLoadingValues, antigenLoadingKeys,
    antibodyLoadingBlock, antibodyLoadingOptions, antibodyLoadingValues, antibodyLoadingKeys,
    screenLoadingBlock, screenLoadingOptions, screenLoadingValues, screenLoadingKeys,
    (*measure baseline block*)
    measureBaselineBlock, measureBaselineOptions, measureBaselineValues, measureBaselineKeys,
    resolvedBaselineBuffer, resolvedBaselineTime, resolvedBaselineShakeRate, resolvedBaselineBufferKey, resolvedBaselineTimeKey, resolvedBaselineShakeRateKey,
    measureBaselineBlockAssociation,
    (*measure dissociation block*)
    measureDissociationBlock, measureDissociationOptions, measureDissociationValues, measureDissociationKeys, resolvedDissociationBuffer, resolvedDissociationTime, resolvedDissociationShakeRate,
    resolvedDissociationThresholdCriterion, resolvedDissociationAbsoluteThreshold, resolvedDissociationThresholdSlope, resolvedDissociationThresholdSlopeDuration,
    resolvedDissociationBufferKey, resolvedDissociationTimeKey, resolvedDissociationShakeRateKey, resolvedDissociationThresholdCriterionKey, resolvedDissociationAbsoluteThresholdKey, resolvedDissociationThresholdSlopeKey,
    resolvedDissociationThresholdSlopeDurationKey,
    (*various washes*)
    enzymeWashBlock, enzymeWashOptions, enzymeWashValues, enzymeWashKeys, generalWashBlock, generalWashOptions, generalWashValues, generalWashKeys,
    (*  loading variables *)
    generalLoadingBlock, generalLoadingOptions, generalLoadingValues, generalLoadingKeys, resolvedActivationSolution, resolvedLoadSolution, resolvedQuenchSolution,
    resolvedActivationSolutionKey, resolvedLoadSolutionKey, resolvedQuenchSolutionKey,
    (* primitives *)
    resolvedAssayPrimitives, resolvedAssayPrimitivePackets, rawAssayPrimitivePackets, extractedPrimitives, extractedKeySets, extractedValueSets, extractedOptionSets
  },


    (* If the primitives are set to automatic, we will resolve them based on the options *)
    If[MatchQ[assaySequencePrimitives, Automatic],


      (* --- EQUILIBRATION BLOCK --- *)
      (* if equilibrate is selected, set up an equilibrate primitive with the appropriate Key/Value pairs *)
      {
        equilibrateBlock,
        equilibrateValues,
        equilibrateOptions,
        equilibrateKeys
      } = If[MatchQ[equilibrate, True],

        (* determine the parameters which should go into the equilibrate primitive *)
        {resolvedEquilibrateBuffer, resolvedEquilibrateBufferKey}=If[MatchQ[developmentType, ScreenBuffer],
          {testBufferSolutions, TestBufferSolutions},
          {equilibrateBuffer, EquilibrateBuffer}
        ];

        (* resolve the equilibrate primitive using the equilibrateBlockAssociation *)
        {
          Equilibrate[Buffers -> ConstantArray[resolvedEquilibrateBuffer,8], Time -> equilibrateTime, ShakeRate -> equilibrateShakeRate],
          {{resolvedEquilibrateBuffer, equilibrateTime, equilibrateShakeRate}},
          {{resolvedEquilibrateBufferKey, EquilibrateTime, EquilibrateShakeRate}},
          {{Buffers, Time, ShakeRate}}
        },
        ConstantArray[Null, 4]
      ];



      (* --- REGENERATION BLOCK --- *)

      (* if regeneration is requested, resolve this block *)
      {
        regenerationBlock,
        regenerationValues,
        regenerationOptions,
        regenerationKeys
      } = If[MatchQ[regenerationType, Except[(None|Null|{})]],

        (* assign the primitive keys to the correct values*)
        {resolvedRegenerateSolutions, resolvedRegenerateSolutionsKey} = If[MatchQ[developmentType, ScreenRegeneration],
          {testRegenerationSolutions/.Null->{}, TestRegenerationSolutions},
          {regenerationSolution, RegenerationSolution}
        ];

        (* the naming here is to differntiate from wash steps which appear outside of the regen block *)
        {resolvedRegenerateWashSolutions, resolvedRegenerateWashSolutionsKey} = If[MatchQ[developmentType, ScreenBuffer],
          {testBufferSolutions, TestBufferSolutions},
          {washSolution, WashSolution}
        ];

        (* generate primitives for the regeneration block using the proper solutions as resolved above *)
        {
          singleRegenerationBlock,
          singleRegenerationValues,
          singleRegenerationOptions,
          singleRegenerationKeys
        } = Transpose[{
          If[MemberQ[regenerationType, Regenerate],
            If[MatchQ[developmentType, ScreenRegeneration],
              {
                Regenerate[RegenerationSolutions -> Flatten[Partition[resolvedRegenerateSolutions,8, 8, 1, defaultBuffer]], Time -> regenerationTime, ShakeRate -> regenerationShakeRate],
                {resolvedRegenerateSolutions, regenerationTime, regenerationShakeRate},
                {resolvedRegenerateSolutionsKey, RegenerationTime, RegenerationShakeRate},
                {Buffers, Time, ShakeRate}
              },
              {
                Regenerate[RegenerationSolutions -> ConstantArray[resolvedRegenerateSolutions,8], Time -> regenerationTime, ShakeRate -> regenerationShakeRate],
                {resolvedRegenerateSolutions, regenerationTime, regenerationShakeRate},
                {resolvedRegenerateSolutionsKey, RegenerationTime, RegenerationShakeRate},
                {Buffers, Time, ShakeRate}
              }
            ],
            ConstantArray[Null, 4]
          ],

          (* if they have selected neutralize, add an options based neutralize primitive.*)
          If[MemberQ[regenerationType, Neutralize],
            {
              Neutralize[NeutralizationSolutions -> ConstantArray[neutralizationSolution, 8], Time -> neutralizationTime, ShakeRate -> neutralizationShakeRate],
              {neutralizationSolution, neutralizationTime, neutralizationShakeRate},
              {NeutralizationSolution, NeutralizationTime, NeutralizationShakeRate},
              {Buffers, Time, ShakeRate}
            },
            ConstantArray[Null, 4]
          ],

          (* if they have selected wash, add an options based wash primitive *)
          If[MemberQ[regenerationType, Wash],
            If[MatchQ[developmentType, ScreenBuffer],
              {
                Wash[Buffers -> Flatten[Partition[resolvedRegenerateWashSolutions/.Null->{}, 8, 8, 1, defaultBuffer]], Time -> washTime, ShakeRate -> washShakeRate],
                {resolvedRegenerateWashSolutions, washTime, washShakeRate},
                {resolvedRegenerateWashSolutionsKey, washTime, washShakeRate},
                {Buffers, Time, ShakeRate}
              },
              {
                Wash[Buffers -> ConstantArray[resolvedRegenerateWashSolutions, 8], Time -> washTime, ShakeRate -> washShakeRate],
                {resolvedRegenerateWashSolutions, washTime, washShakeRate},
                {resolvedRegenerateWashSolutionsKey, washTime, washShakeRate},
                {Buffers, Time, ShakeRate}
              }
            ],
            ConstantArray[Null, 4]
          ]
        }];

        (* append the pre condition steps to the assay primitives, repeated regenerationCycles number of times*)
        {
          expandedRegenerationBlock,
          expandedRegenerationValues,
          expandedRegenerationOptions,
          expandedRegenerationKeys
        } = If[MatchQ[regenerationCycles,(Null|0)],
          {
            {singleRegenerationBlock},
            {singleRegenerationValues},
            {singleRegenerationOptions},
            {singleRegenerationKeys}
          },
          {
            ConstantArray[singleRegenerationBlock, regenerationCycles],
            ConstantArray[singleRegenerationValues, regenerationCycles],
            ConstantArray[singleRegenerationOptions, regenerationCycles],
            ConstantArray[singleRegenerationKeys, regenerationCycles]
          }
        ];

        (*single regeneration block is already a list, so now it is one level too listed so we flatten it a level*)
        (*return the intermediate variables to set the regenerate block and associated error checking*)
        {
          Flatten[expandedRegenerationBlock,1],
          Flatten[expandedRegenerationValues, 1],
          Flatten[expandedRegenerationOptions,1],
          Flatten[expandedRegenerationKeys, 1]
        },
        {Null, Null, Null, Null}
      ];


      (* --- MEASURE BASELINE BLOCK--- *)
      (* for every experiment type except quantitation there is a MB primitive to be resolved *)
      {
        measureBaselineBlock,
        measureBaselineValues,
        measureBaselineOptions,
        measureBaselineKeys
      } = If[MatchQ[experimentType, Except[Quantitation]],
        (* set variables for the measure baseline parameters - this step only appears once per assay. The measure baseline step in quantitate can just be called wash since there is usually no baseline in quantitation anyway *)
        {
          resolvedBaselineBuffer, resolvedBaselineTime, resolvedBaselineShakeRate,
          resolvedBaselineBufferKey, resolvedBaselineTimeKey, resolvedBaselineShakeRateKey
        }=Which[
          MatchQ[experimentType, Kinetics],
          {
            kineticsBaselineBuffer, measureBaselineTime, measureBaselineShakeRate,
            KineticsBaselineBuffer, MeasureBaselineTime, MeasureBaselineShakeRate
          },

          MatchQ[experimentType, EpitopeBinning],
          {
            competitionBaselineBuffer, competitionBaselineTime, competitionBaselineShakeRate,
            CompetitionBaselineBuffer, CompetitionBaselineTime, CompetitionBaselineShakeRate
          },

          MatchQ[experimentType,AssayDevelopment],
          If[MatchQ[developmentType, ScreenBuffer],
            {
              testBufferSolutions/.Null->{}, developmentBaselineTime, developmentBaselineShakeRate,
              TestBufferSolutions, DevelopmentBaselineTime, DevelopmentBaselineShakeRate
            },
            {
              defaultBuffer, developmentBaselineTime, developmentBaselineShakeRate,
              DefaultBuffer, DevelopmentBaselineTime, DevelopmentBaselineShakeRate
            }
          ]
        ];

        (* fill out the primitives - may need to do this as an association to track back to the actual option name. *)
        If[MatchQ[developmentType, ScreenBuffer],
          {
            {MeasureBaseline[Buffers -> Flatten[Partition[resolvedBaselineBuffer, 8,8,1,defaultBuffer]], Time -> resolvedBaselineTime, ShakeRate -> resolvedBaselineShakeRate]},
            {{resolvedBaselineBuffer, resolvedBaselineTime, resolvedBaselineShakeRate}},
            {{resolvedBaselineBufferKey, resolvedBaselineTimeKey, resolvedBaselineShakeRateKey}},
            {{Buffers, Time, ShakeRate}}
          },
          {
            {MeasureBaseline[Buffers -> ConstantArray[resolvedBaselineBuffer, 8], Time -> resolvedBaselineTime, ShakeRate -> resolvedBaselineShakeRate]},
            {{resolvedBaselineBuffer, resolvedBaselineTime, resolvedBaselineShakeRate}},
            {{resolvedBaselineBufferKey, resolvedBaselineTimeKey, resolvedBaselineShakeRateKey}},
            {{Buffers, Time, ShakeRate}}
          }
        ],

        (* for quantitate, set everything to Null *)
        ConstantArray[Null, 4]
      ];


      (* --- MEASURE DISSOCIATION BLOCK --- *)

      (* only Kinetics and Assay Development will have this primitive *)
      {
        measureDissociationBlock,
        measureDissociationValues,
        measureDissociationOptions,
        measureDissociationKeys
      } = If[MatchQ[experimentType, (Kinetics|AssayDevelopment)],

        (* assign the dissociation parameters for kinetics and assay development type experiments *)
        {
          resolvedDissociationBuffer,
          resolvedDissociationTime,
          resolvedDissociationShakeRate,
          resolvedDissociationThresholdCriterion,
          resolvedDissociationAbsoluteThreshold,
          resolvedDissociationThresholdSlope,
          resolvedDissociationThresholdSlopeDuration,
          (* the keys (option names) *)
          resolvedDissociationBufferKey,
          resolvedDissociationTimeKey,
          resolvedDissociationShakeRateKey,
          resolvedDissociationThresholdCriterionKey,
          resolvedDissociationAbsoluteThresholdKey,
          resolvedDissociationThresholdSlopeKey,
          resolvedDissociationThresholdSlopeDurationKey
        }=If[MatchQ[experimentType, Kinetics],
          {
            kineticsDissociationBuffer, measureDissociationTime, measureDissociationShakeRate, measureDissociationThresholdCriterion, measureDissociationAbsoluteThreshold, measureDissociationThresholdSlope, measureDissociationThresholdSlopeDuration,
            KineticsDissociationBuffer, MeasureDissociationTime, MeasureDissociationShakeRate, MeasureDissociationThresholdCriterion, MeasureDissociationAbsoluteThreshold, MeasureDissociationThresholdSlope, MeasureDissociationThresholdSlopeDuration
          },
          If[MatchQ[developmentType, ScreenBuffer],
            {
              testBufferSolutions/.Null->{}, developmentDissociationTime, developmentDissociationShakeRate, developmentDissociationThresholdCriterion, developmentDissociationAbsoluteThreshold, developmentDissociationThresholdSlope, developmentDissociationThresholdSlopeDuration,
              TestBufferSolutions, DevelopmentDissociationTime, DevelopmentDissociationShakeRate, DevelopmentDissociationThresholdCriterion, DevelopmentDissociationAbsoluteThreshold, DevelopmentDissociationThresholdSlope, DevelopmentDissociationThresholdSlopeDuration
            },
            {
              defaultBuffer, developmentDissociationTime, developmentDissociationShakeRate, developmentDissociationThresholdCriterion, developmentDissociationAbsoluteThreshold, developmentDissociationThresholdSlope, developmentDissociationThresholdSlopeDuration,
              DefaultBuffer, DevelopmentDissociationTime, DevelopmentDissociationShakeRate, DevelopmentDissociationThresholdCriterion, DevelopmentDissociationAbsoluteThreshold, DevelopmentDissociationThresholdSlope, DevelopmentDissociationThresholdSlopeDuration
            }
          ]
        ];

        (*  assign measureDissociation primitives and error tracking variables to the given values *)
        If[MatchQ[developmentType, ScreenBuffer],
          {
            {MeasureDissociation[Buffers -> Flatten[Partition[resolvedDissociationBuffer, 8,8,1, defaultBuffer]], Time -> resolvedDissociationTime, ShakeRate -> resolvedDissociationShakeRate, ThresholdCriterion -> resolvedDissociationThresholdCriterion, AbsoluteThreshold -> resolvedDissociationAbsoluteThreshold,
              ThresholdSlope -> resolvedDissociationThresholdSlope, ThresholdSlopeDuration -> resolvedDissociationThresholdSlopeDuration]},
            {{resolvedDissociationBuffer, resolvedDissociationTime, resolvedDissociationShakeRate, resolvedDissociationThresholdCriterion, resolvedDissociationAbsoluteThreshold, resolvedDissociationThresholdSlope, resolvedDissociationThresholdSlopeDuration}},
            {{resolvedDissociationBufferKey, resolvedDissociationTimeKey, resolvedDissociationShakeRateKey, resolvedDissociationThresholdCriterionKey, resolvedDissociationAbsoluteThresholdKey, resolvedDissociationThresholdSlopeKey, resolvedDissociationThresholdSlopeDurationKey}},
            {{Buffers, Time, ShakeRate, ThresholdCriterion, AbsoluteThreshold, ThresholdSlope, ThresholdSlopeDuration}}
          },
          {
            {MeasureDissociation[Buffers -> ConstantArray[resolvedDissociationBuffer, 8], Time -> resolvedDissociationTime, ShakeRate -> resolvedDissociationShakeRate, ThresholdCriterion -> resolvedDissociationThresholdCriterion, AbsoluteThreshold -> resolvedDissociationAbsoluteThreshold,
              ThresholdSlope -> resolvedDissociationThresholdSlope, ThresholdSlopeDuration -> resolvedDissociationThresholdSlopeDuration]},
            {{resolvedDissociationBuffer, resolvedDissociationTime, resolvedDissociationShakeRate, resolvedDissociationThresholdCriterion, resolvedDissociationAbsoluteThreshold, resolvedDissociationThresholdSlope, resolvedDissociationThresholdSlopeDuration}},
            {{resolvedDissociationBufferKey, resolvedDissociationTimeKey, resolvedDissociationShakeRateKey, resolvedDissociationThresholdCriterionKey, resolvedDissociationAbsoluteThresholdKey, resolvedDissociationThresholdSlopeKey, resolvedDissociationThresholdSlopeDurationKey}},
            {{Buffers, Time, ShakeRate, ThresholdCriterion, AbsoluteThreshold, ThresholdSlope, ThresholdSlopeDuration}}
          }
        ],
        ConstantArray[Null,4]
      ];


      (* ---  GENERIC WASH BLOCK --- *)
      (* there are a lot of implicit wash steps that the user does nto specify. We set these based on the wash defaults from the options. *)
      {
        generalWashBlock,
        generalWashValues,
        generalWashOptions,
        generalWashKeys
      }=If[MatchQ[experimentType, AssayDevelopment]&&MatchQ[developmentType, ScreenBuffer],
        {
          {Wash[Buffers -> Flatten[Partition[testBufferSolutions/.Null->{}, 8, 8, 1, defaultBuffer]], Time -> 10 Second, ShakeRate -> 1000 RPM]},
          {{testBufferSolutions, Null, Null}},
          {{TestBufferSolutions, Null, Null}},
          {{Buffers, Time, ShakeRate}}
        },
        {
          {Wash[Buffers -> ConstantArray[defaultBuffer, 8], Time -> 10 Second, ShakeRate -> 1000 RPM]},
          {{defaultBuffer, Null, Null}},
          {{DefaultBuffer, Null, Null}},
          {{Buffers, Time, ShakeRate}}
        }
      ];

      (* --- ENZYME WASH BLOCK --- *)

      (* specific washes for enzyme-linked quantitation assays *)
      {
        enzymeWashBlock,
        enzymeWashValues,
        enzymeWashOptions,
        enzymeWashKeys
      }=If[MatchQ[experimentType, Quantitation]&&MemberQ[ToList[quantitationParameters], EnzymeLinked],
        {
          {Wash[Buffers -> ConstantArray[quantitationEnzymeBuffer,8], Time -> 10 Second, ShakeRate -> 1000 RPM]},
          {{quantitationEnzymeBuffer, Null, Null}},
          {{QuantitationEnzymeBuffer, Null, Null}},
          {{Buffers, Time, ShakeRate}}
        },
        ConstantArray[Null,4]
      ];

      (* --- LOADING BLOCK --- *)
      (* set up the generic loading block (defined from the load section or from the AssayDevelopment section - screenInteraction, screenLoading, screenActivation) *)
      {
        generalLoadingBlock,
        generalLoadingValues,
        generalLoadingOptions,
        generalLoadingKeys
      }=If[MatchQ[loadingType, Except[(None|Null|{})]],

        (* define local variables for the parameters used in the load, activate, and quench primitives *)
        {
          resolvedActivationSolution,
          resolvedLoadSolution,
          resolvedQuenchSolution,

          resolvedActivationSolutionKey,
          resolvedLoadSolutionKey,
          resolvedQuenchSolutionKey
        }= Which[

          MatchQ[developmentType, ScreenActivation],
          {
            testActivationSolutions/.Null->{}, loadSolution, quenchSolution,
            TestActivationSolutions, LoadSolution, QuenchSolution
          },

          MatchQ[developmentType, ScreenLoading],
          {
            activateSolution, testLoadingSolutions/.Null->{}, quenchSolution,
            ActivateSolution, TestLoadingSolutions, QuenchSolution
          },

          (*TODO: pretty sure this does nothing now after QA changes*)
          (*
          MatchQ[developmentType, ScreenInteraction],
          {
            activateSolution, testInteractionSolutions, quenchSolution,
            ActivateSolution, TestInteractionSolutions, QuenchSolution
          },
          *)

          (* catch all other scenerios *)
          MatchQ[experimentType, Except[EpitopeBinning]],
          {
            activateSolution, loadSolution, quenchSolution,
            ActivateSolution, LoadSolution, QuenchSolution
          },

          MatchQ[experimentType, EpitopeBinning],
          ConstantArray[Null, 6]
        ];

        (* resolve the primitives using the variables set above *)
        Transpose[{
          If[MemberQ[loadingType, Activate],
            If[MatchQ[developmentType, ScreenActivation],
              (* activation solutions is a list *)
              {
                ActivateSurface[ActivationSolutions -> Flatten[Partition[resolvedActivationSolution, 8, 8, 1, defaultBuffer]], Controls -> {}, Time -> activateTime, ShakeRate -> activateShakeRate],
                {resolvedActivationSolution, activateTime, activateShakeRate},
                {resolvedActivationSolutionKey, ActivateTime, ActivateShakeRate},
                {ActivationSolutions, Time, ShakeRate}
              },
              (* activation solution is not a list *)
              {
                ActivateSurface[ActivationSolutions -> ConstantArray[resolvedActivationSolution, 8], Controls -> {}, Time -> activateTime, ShakeRate -> activateShakeRate],
                {resolvedActivationSolution, activateTime, activateShakeRate},
                {resolvedActivationSolutionKey, ActivateTime, ActivateShakeRate},
                {ActivationSolutions, Time, ShakeRate}
              }
            ],
            ConstantArray[Null, 4]
          ],
          If[MemberQ[loadingType, Load],
            If[MatchQ[developmentType, ScreenLoading],
              {
                LoadSurface[LoadingSolutions -> Flatten[Partition[resolvedLoadSolution, 8, 8, 1, defaultBuffer]], Controls -> {}, Time -> loadTime, ShakeRate -> loadShakeRate, ThresholdCriterion -> loadThresholdCriterion,
                  AbsoluteThreshold -> loadAbsoluteThreshold, ThresholdSlope -> loadThresholdSlope, ThresholdSlopeDuration -> loadThresholdSlopeDuration],
                {resolvedLoadSolution, {}, loadTime, loadShakeRate, loadThresholdCriterion, loadAbsoluteThreshold, loadThresholdSlope, loadThresholdSlopeDuration},
                {resolvedLoadSolutionKey, Null, LoadTime, LoadShakeRate, LoadThresholdCriterion, LoadAbsoluteThreshold, LoadThresholdSlope, LoadThresholdSlopeDuration},
                {LoadingSolutions, Controls, Time, ShakeRate, ThresholdCriterion, AbsoluteThreshold, ThresholdSlope, ThresholdSlopeDuration}
              },
              {
                LoadSurface[LoadingSolutions -> ConstantArray[resolvedLoadSolution,8], Controls -> {}, Time -> loadTime, ShakeRate -> loadShakeRate, ThresholdCriterion -> loadThresholdCriterion,
                  AbsoluteThreshold -> loadAbsoluteThreshold, ThresholdSlope -> loadThresholdSlope, ThresholdSlopeDuration -> loadThresholdSlopeDuration],
                {resolvedLoadSolution, {}, loadTime, loadShakeRate, loadThresholdCriterion, loadAbsoluteThreshold, loadThresholdSlope, loadThresholdSlopeDuration},
                {resolvedLoadSolutionKey, Null, LoadTime, LoadShakeRate, LoadThresholdCriterion, LoadAbsoluteThreshold, LoadThresholdSlope, LoadThresholdSlopeDuration},
                {LoadingSolutions, Controls, Time, ShakeRate, ThresholdCriterion, AbsoluteThreshold, ThresholdSlope, ThresholdSlopeDuration}
              }
            ],
            ConstantArray[Null, 4]
          ],
          If[MemberQ[loadingType, Quench],
            {
              Quench[QuenchSolutions -> ConstantArray[resolvedQuenchSolution,8], Controls -> {}, Time -> quenchTime, ShakeRate -> quenchShakeRate],
              {resolvedQuenchSolution, quenchTime, quenchShakeRate},
              {resolvedQuenchSolutionKey, QuenchTime, QuenchShakeRate},
              {QuenchSolutions, Time, ShakeRate}
            },
            ConstantArray[Null, 4]
          ]
        }],
        ConstantArray[Null, 4]
      ];

      (* set up the primitives for antigen loading, which occurs when the expeiment type is either Tandem or Sandwich. PreMix does not load the antigen. *)
      (* there need to be wash steps included in the block, after the load step? *)
      {
        antigenLoadingBlock,
        antigenLoadingValues,
        antigenLoadingOptions,
        antigenLoadingKeys
      } = If[MatchQ[experimentType, EpitopeBinning],

        (* if the epitope binning is PreMix, there is no antigen loading *)
        If[MatchQ[binningType, (Sandwich|Tandem)],
          {
            {LoadSurface[LoadingSolutions -> ConstantArray[binningAntigen, 8], Controls -> {}, Time -> loadAntigenTime, ShakeRate -> loadAntigenShakeRate, ThresholdCriterion -> loadAntigenThresholdCriterion,
              AbsoluteThreshold -> loadAntigenAbsoluteThreshold, ThresholdSlope -> loadAntigenThresholdSlope, ThresholdSlopeDuration -> loadAntigenThresholdSlopeDuration
            ]},
            {{binningAntigen, {}, loadAntigenTime, loadAntigenShakeRate, loadAntigenThresholdCriterion, loadAntigenAbsoluteThreshold, loadAntigenThresholdSlope, loadAntigenThresholdSlopeDuration}},
            {{BinningAntigen, Null, LoadAntigenTime, LoadAntigenShakeRate,  LoadAntigenThresholdCriterion, LoadAntigenAbsoluteThreshold, LoadAntigenThresholdSlope, LoadAntigenThresholdSlopeDuration}},
            {{LoadingSolutions, Controls, Time, ShakeRate, ThresholdCriterion, AbsoluteThreshold, ThresholdSlope, ThresholdSlopeDuration}}
          },
          ConstantArray[Null, 4]
        ],
        ConstantArray[Null, 4]
      ];

      (* set up the primitives for antibody loading (all binning assays). there may be a Quench step which occurs after antibody loading, allow it even if it doesnt make that much sense*)
      (* This is a little weird since we will use the samples in here, but it should be safe since the experiment only takes 8 or less samples, enforced elsewhere as tooManySamples: binning edition *)
      {
        antibodyLoadingBlock,
        antibodyLoadingValues,
        antibodyLoadingOptions,
        antibodyLoadingKeys
      } = If[MatchQ[experimentType, EpitopeBinning],
        Transpose[{
          {
            LoadSurface[LoadingSolutions -> PadRight[mySamples, (8 - Length[{controlWellSolution}]), defaultBuffer], Controls -> {controlWellSolution}, Time -> loadAntibodyTime, ShakeRate -> loadAntibodyShakeRate, ThresholdCriterion -> loadAntibodyThresholdCriterion,
              AbsoluteThreshold -> loadAntibodyAbsoluteThreshold, ThresholdSlope -> loadAntibodyThresholdSlope, ThresholdSlopeDuration -> loadAntibodyThresholdSlopeDuration],
            {mySamples, {controlWellSolution},loadAntibodyTime, loadAntibodyShakeRate,loadAntibodyThresholdCriterion, loadAntibodyAbsoluteThreshold, loadAntibodyThresholdSlope, loadAntibodyThresholdSlopeDuration},
            {PreMixSolutions,Blank, LoadAntibodyTime, LoadAntigenShakeRate, LoadAntibodyThresholdCriterion, LoadAntibodyAbsoluteThreshold, LoadAntibodyThresholdSlope, LoadAntibodyThresholdSlopeDuration},
            {LoadingSolutions, Controls, Time, ShakeRate, ThresholdCriterion, AbsoluteThreshold, ThresholdSlope, ThresholdSlopeDuration}
          },
          (*the quench steps used to be here, they are nulled now but I'm not sure if they eventually go back here*)
          ConstantArray[Null, 4]
        }],
        ConstantArray[Null, 4]
      ];


      (* --- MAPTHREAD OVER MEASURED SAMPLES --- *)
      (* the samples in this case are either the dilutions, premix solutions, or the samples in. The steps that will hav to be defined here are MeasureAssociation, Quantitate, and Load. Everything else does not use samples in.*)
      (* the samples are pre-prepared above in the solution resolution section each element:{{solutions},{blanks}}, which only applies to the sampels in, not any lists of solutions which may appear in other parts of the assay *)
      (* Note: If we decide to make other measurement parameters index matched, such as dissociation time or assocaition time, then we will need to include those options here.*)
      (* in that case, we can expand the parameters alongside with the solutions ie. if a dilution requires 2 columns, the index matched paremter will be expanded x2 also*)
      rawAssayPrimitivePackets =
          MapThread[
            Function[{plateColumn, interactionSolutionSet},
              Which[

                (* --- KINETICS PRIMITIVES BUILDER --- *)
                MatchQ[experimentType, Kinetics],
                {
                  (* add an equilibrate step if requested include it except in the case that there is regeneration and we are not looking at the first set of samples*)
                  If[MatchQ[equilibrate, True],
                    If[!MatchQ[plateColumn, First[expandedSamples]]&&MemberQ[regenerationType, (Regenerate|Wash|Neutralize)],
                      Null,
                      <|
                        Primitives -> equilibrateBlock,
                        Keys -> equilibrateKeys,
                        Values -> equilibrateValues,
                        Options -> equilibrateOptions
                      |>
                    ],
                    Null
                  ],

                  (* add the loading block if requested, except if there are regneration steps and this is not the first set of samples *)
                  If[MemberQ[loadingType, (Load|Activate|Quench)],
                    If[!MatchQ[plateColumn, First[expandedSamples]]&&MemberQ[regenerationType, (Regenerate|Wash|Neutralize)],
                      Null,
                      <|
                        Primitives -> generalLoadingBlock,
                        Keys -> generalLoadingKeys,
                        Values -> generalLoadingValues,
                        Options -> generalLoadingOptions
                      |>
                    ],
                    Null
                  ],

                  (* add the regeneration block, if pre-condition is requested *)
                  If[MemberQ[regenerationType, PreCondition],
                    <|
                      Primitives -> regenerationBlock,
                      Keys -> regenerationKeys,
                      Values -> regenerationValues,
                      Options -> regenerationOptions
                    |>,
                    Null
                  ],

                  (* add the baseline block as defined above *)
                  <|
                    Primitives -> measureBaselineBlock,
                    Keys -> measureBaselineKeys,
                    Values -> measureBaselineValues,
                    Options -> measureBaselineOptions
                  |>,

                  (* add the association step for the element of samples in that we are on in the mapthread *)
                  <|
                    Primitives ->
                        {MeasureAssociation[
                          Analytes -> First[plateColumn], Controls -> Last[plateColumn], Time -> measureAssociationTime, ShakeRate -> measureAssociationShakeRate, ThresholdCriterion -> measureAssociationThresholdCriterion,
                          AbsoluteThreshold -> measureAssociationAbsoluteThreshold, ThresholdSlope -> measureAssociationThresholdSlope, ThresholdSlopeDuration -> measureAssociationThresholdSlopeDuration
                        ]},
                    Keys -> {{
                      Analytes, Controls, Time, ShakeRate, ThresholdCriterion, AbsoluteThreshold, ThresholdSlope, ThresholdSlopeDuration
                    }},
                    Values -> {{
                      First[plateColumn], Last[plateColumn], measureAssociationTime, measureAssociationShakeRate, measureAssociationThresholdCriterion,
                      measureAssociationAbsoluteThreshold, measureAssociationThresholdSlope, measureAssociationThresholdSlopeDuration
                    }},
                    Options -> {{{KineticsSampleSerialDilutions, KineticsSampleFixedDilutions}, Null, MeasureAssociationTime, MeasureAssociationShakeRate, MeasureAssociationThresholdCriterion,
                      MeasureAssociationAbsoluteThreshold, MeasureAssociationThresholdSlope, MeasureAssociationThresholdSlopeDuration
                    }}
                  |>,

                  (* add a measure dissociation block *)
                  <|
                    Primitives -> measureDissociationBlock,
                    Keys -> measureDissociationKeys,
                    Values -> measureDissociationValues,
                    Options -> measureDissociationOptions
                  |>,

                  (* add a final regeneration block *)
                  If[MemberQ[regenerationType, (Regenerate|Wash|Neutralize)]&&!MemberQ[regenerationType, PreCondition],
                    <|
                      Primitives -> regenerationBlock,
                      Keys -> regenerationKeys,
                      Values -> regenerationValues,
                      Options -> regenerationOptions
                    |>,
                    Null
                  ]
                },


                (* --- QUANTITATION PRIMITIVES BUILDER --- *)

                MatchQ[experimentType, Quantitation],
                {
                  (* add an equilibrate step if requested include it except in the case that there is regeneration and we are not looking at the first set of samples*)
                  If[MatchQ[equilibrate, True],
                    If[!MatchQ[plateColumn, First[expandedSamples]] && MemberQ[regenerationType, (Regenerate | Wash | Neutralize)],
                      Null,
                      <|
                        Primitives -> equilibrateBlock,
                        Keys -> equilibrateKeys,
                        Values -> equilibrateValues,
                        Options -> equilibrateOptions
                      |>
                    ],
                    Null
                  ],

                  (* add the loading block if requested, except if there are regeneration steps and this is not the first set of samples *)
                  If[MemberQ[loadingType, (Load|Activate|Quench)],
                    If[!MatchQ[plateColumn, First[expandedSamples]]&&MemberQ[regenerationType, (Regenerate|Wash|Neutralize)],
                      Null,
                      <|
                        Primitives -> generalLoadingBlock,
                        Keys -> generalLoadingKeys,
                        Values -> generalLoadingValues,
                        Options -> generalLoadingOptions
                      |>
                    ],
                    Null
                  ],

                  (* add the regeneration block, if pre-condition is requested *)
                  If[MemberQ[regenerationType, PreCondition],
                    <|
                      Primitives -> regenerationBlock,
                      Keys -> regenerationKeys,
                      Values -> regenerationValues,
                      Options -> regenerationOptions
                    |>,
                    Null
                  ],

                  (* If there is amplified detection, or any other secondary steps, we call the sample step a measure assocaition rather than quantitate *)
                  Which[
                    MemberQ[ToList[quantitationParameters], AmplifiedDetection]&&MemberQ[ToList[quantitationParameters], EnzymeLinked],
                    {
                      <|
                        Primitives -> {MeasureAssociation[Analytes -> First[plateColumn], Controls -> Last[plateColumn], Time -> quantitateTime, ShakeRate -> quantitateShakeRate]},
                        Keys -> {{Analytes, Controls, Time, ShakeRate}},
                        Values -> {{First[plateColumn], Last[plateColumn], quantitateTime, quantitateShakeRate}},
                        Options -> {{{QuantitationStandardSerialDilutions, QuantitationStandardFixedDilutions}, Null, QuantitateTime, QuantitateShakeRate}}
                      |>,
                      <|
                        Primitives -> generalWashBlock,
                        Keys -> generalWashKeys,
                        Values -> generalWashValues,
                        Options -> generalWashOptions
                      |>,
                      <|
                        Primitives -> {LoadSurface[LoadingSolutions -> quantitationEnzymeSolution, Controls -> {}, Time -> quantitationEnzymeTime, ShakeRate -> quantitationEnzymeShakeRate]},
                        Keys -> {{LoadingSolutions, Controls, Time, ShakeRate}},
                        Values -> {{quantitationEnzymeSolution, Null, quantitationEnzymeTime, quantitationEnzymeShakeRate}},
                        Options -> {{QuantitationEnzymeSolution, Null, QuantitationEnzymeTime, QuantitationEnzymeShakeRate}}
                      |>,
                      <|
                        Primitives -> enzymeWashBlock,
                        Keys -> enzymeWashKeys,
                        Values -> enzymeWashValues,
                        Options -> enzymeWashOptions
                      |>,
                      <|
                        Primitives -> {Quantitate[Analytes -> ConstantArray[amplifiedDetectionSolution, 8], Controls -> {}, Time -> amplifiedDetectionTime, ShakeRate -> amplifiedDetectionShakeRate]},
                        Keys -> {{Analytes, Controls, Time, ShakeRate}},
                        Values -> {{ConstantArray[amplifiedDetectionSolution, 8], Null, amplifiedDetectionTime, amplifiedDetectionShakeRate}},
                        Options -> {{AmplifiedDetectionSolution, Null, AmplifiedDetectionTime, AmplifiedDetectionShakeRate}}
                      |>
                    },

                    MemberQ[ToList[quantitationParameters], AmplifiedDetection],
                    {
                      <|
                        Primitives -> {MeasureAssociation[Analytes -> First[plateColumn], Controls -> Last[plateColumn], Time -> quantitateTime, ShakeRate -> quantitateShakeRate]},
                        Keys -> {{Analytes, Controls, Time, ShakeRate}},
                        Values ->{{First[plateColumn],Last[plateColumn], quantitateTime, quantitateShakeRate}},
                        Options ->{{Null, Null, QuantitateTime, QuantitateShakeRate}}
                      |>,
                      <|
                        Primitives -> {Quantitate[Analytes -> ConstantArray[amplifiedDetectionSolution, 8], Controls -> {}, Time -> amplifiedDetectionTime, ShakeRate -> amplifiedDetectionShakeRate]},
                        Keys -> {{Analytes, Controls, Time, ShakeRate}},
                        Values -> {{ConstantArray[amplifiedDetectionSolution, 8], Null, amplifiedDetectionTime, amplifiedDetectionShakeRate}},
                        Options -> {{AmplifiedDetectionSolution, Null, AmplifiedDetectionTime, AmplifiedDetectionShakeRate}}
                      |>
                    },

                    True,
                    <|
                      Primitives -> {Quantitate[Analytes -> First[plateColumn], Controls -> Last[plateColumn], Time -> quantitateTime, ShakeRate -> quantitateShakeRate]},
                      Keys -> {{Analytes, Controls, Time, ShakeRate}},
                      Values -> {{First[plateColumn], Last[plateColumn], quantitateTime, quantitateShakeRate}},
                      Options -> {{{QuantitationStandardSerialDilutions, QuantitationStandardFixedDilutions}, Null, QuantitateTime, QuantitateShakeRate}}
                    |>
                  ],

                  (* add a regeneration step if requested and precondition is not true *)
                  If[!MemberQ[regenerationType, PreCondition]&&MemberQ[regenerationType, (Regenerate|Neutralize|Wash)],
                    <|
                      Primitives -> regenerationBlock,
                      Keys -> regenerationKeys,
                      Values -> regenerationValues,
                      Options -> regenerationOptions
                    |>,
                    Null
                  ]
                },


                (* --- EPITOPEBINNING PRIMITIVES BUILDER --- *)

                MatchQ[experimentType, EpitopeBinning],
                {
                  (* add an equilibrate step if requested include it except in the case that there is regeneration and we are not looking at the first set of samples*)
                  If[MatchQ[equilibrate, True],
                    <|
                      Primitives -> equilibrateBlock,
                      Keys -> equilibrateKeys,
                      Values -> equilibrateValues,
                      Options -> equilibrateOptions
                    |>,
                    Null
                  ],
                  Which[
                    (* --- PREMIX --- *)
                    MatchQ[binningType, PreMix],
                    {
                      (* if there is a quench step requested, we add that plus a wash before hand  *)
                      <|
                        Primitives -> antibodyLoadingBlock,
                        Keys -> antibodyLoadingKeys,
                        Values -> antibodyLoadingValues,
                        Options -> antibodyLoadingOptions
                      |>,
                      (* if the quench solution is not null, include the quench step *)
                      If[!MatchQ[binningQuenchSolution,Null],
                        {
                          <|
                            Primitives -> {Quench[QuenchSolutions -> ConstantArray[binningQuenchSolution, 8], Time -> binningQuenchTime, ShakeRate -> binningQuenchShakeRate]},
                            Keys -> {{QuenchSolutions, Time, ShakeRate}},
                            Values -> {{ConstantArray[binningQuenchSolution, 8], binningQuenchTime, binningQuenchShakeRate}},
                            Options ->{{BinningQuenchSolution, BinningQuenchTime, BinningQuenchShakeRate}}
                          |>,
                          <|
                            Primitives -> generalWashBlock,
                            Keys -> generalWashKeys,
                            Values -> generalWashValues,
                            Options -> generalWashOptions
                          |>
                        },
                        Null
                      ]
                    },

                    (* --- TANDEM --- *)
                    MatchQ[binningType, Tandem],
                    {
                      <|
                        Primitives -> antigenLoadingBlock,
                        Keys -> antigenLoadingKeys,
                        Values -> antigenLoadingValues,
                        Options -> antigenLoadingOptions
                      |>,
                      <|
                        Primitives -> generalWashBlock,
                        Keys -> generalWashKeys,
                        Values -> generalWashValues,
                        Options -> generalWashOptions
                      |>,
                      <|
                        Primitives ->antibodyLoadingBlock,
                        Keys -> antibodyLoadingKeys,
                        Values -> antibodyLoadingValues,
                        Options -> antibodyLoadingOptions
                      |>
                    },

                    (* --- SANDWICH --- *)
                    MatchQ[binningType, Sandwich],
                    {
                      <|
                        Primitives ->antibodyLoadingBlock,
                        Keys -> antibodyLoadingKeys,
                        Values -> antibodyLoadingValues,
                        Options -> antibodyLoadingOptions
                      |>,
                      If[!MatchQ[binningQuenchSolution,Null],
                        {
                          <|
                            Primitives -> {Quench[QuenchSolutions -> ConstantArray[binningQuenchSolution, 8], Time -> binningQuenchTime, ShakeRate -> binningQuenchShakeRate]},
                            Keys -> {{QuenchSolutions, Time, ShakeRate}},
                            Values ->{{ConstantArray[binningQuenchSolution, 8], binningQuenchTime, binningQuenchShakeRate}},
                            Options ->{{BinningQuenchSolution, BinningQuenchTime, BinningQuenchShakeRate}}
                          |>,
                          <|
                            Primitives -> generalWashBlock,
                            Keys -> generalWashKeys,
                            Values -> generalWashValues,
                            Options -> generalWashOptions
                          |>
                        },
                        <|
                          Primitives -> generalWashBlock,
                          Keys -> generalWashKeys,
                          Values -> generalWashValues,
                          Options -> generalWashOptions
                        |>
                      ],
                      <|
                        Primitives -> antigenLoadingBlock,
                        Keys -> antigenLoadingKeys,
                        Values -> antigenLoadingValues,
                        Options -> antigenLoadingOptions
                      |>
                    }
                  ],
                  (* all binning experiments have a measureBaselineBlock prior to measurement *)
                  <|
                    Primitives -> measureBaselineBlock,
                    Keys -> measureBaselineKeys,
                    Values -> measureBaselineValues,
                    Options -> measureBaselineOptions
                  |>,
                  <|
                    Primitives -> {MeasureAssociation[Analytes -> First[plateColumn], Controls -> Last[plateColumn], Time -> competitionTime, ShakeRate -> competitionShakeRate, ThresholdCriterion-> competitionThresholdCriterion,
                      AbsoluteThreshold -> competitionAbsoluteThreshold, ThresholdSlope -> competitionThresholdSlope, ThresholdSlopeDuration -> competitionThresholdSlopeDuration
                    ]},
                    Keys -> {{Analytes, Controls, Time, ShakeRate, ThresholdCriterion, AbsoluteThreshold, ThresholdSlope, ThresholdSlopeDuration}},
                    Values -> {{First[plateColumn], Last[plateColumn],competitionTime, competitionShakeRate, competitionThresholdCriterion, competitionAbsoluteThreshold, competitionThresholdSlope, competitionThresholdSlopeDuration}},
                    Options -> {{PreMixSolutions, Null,CompetitionTime, CompetitionShakeRate, CompetitionThresholdCriterion, CompetitionAbsoluteThreshold, CompetitionThresholdSlope, CompetitionThresholdSlopeDuration}}
                  |>
                },


                (* --- ASSAY DEVELOPMENT PRIMITIVES BUILDER --- *)


                MatchQ[experimentType, AssayDevelopment],
                {
                  (* add an equilibrate step if requested include it except in the case that there is regeneration and we are not looking at the first set of samples*)
                  If[MatchQ[equilibrate, True],
                    If[!MatchQ[plateColumn, First[expandedSamples]]&&MemberQ[regenerationType, (Regenerate|Wash|Neutralize)],
                      Null,
                      <|
                        Primitives -> equilibrateBlock,
                        Keys -> equilibrateKeys,
                        Values -> equilibrateValues,
                        Options -> equilibrateOptions
                      |>
                    ],
                    Null
                  ],

                  (* add the loading block if requested, except if there are regneration steps and this is not the first set of samples. Regeneration type already knows about test regeneration *)
                  If[MatchQ[developmentType, ScreenInteraction],
                    {
                      (* add the regeneration block, if pre-condition is requested. For test interaction this needs to happen before the loading step *)
                      If[MemberQ[regenerationType, PreCondition],
                        <|
                          Primitives -> regenerationBlock,
                          Keys -> regenerationKeys,
                          Values -> regenerationValues,
                          Options -> regenerationOptions
                        |>,
                        Null
                      ],

                      (* add the resolved activate block. We already know that Activate will use a sinlge solution rather than a list since ScreenActivation cant be set *)
                      If[MemberQ[loadingType, Activate],
                          (* activation solution is not a list *)
                          <|
                            Primitives -> {ActivateSurface[ActivationSolutions -> ConstantArray[resolvedActivationSolution, 8], Controls -> {}, Time -> activateTime, ShakeRate -> activateShakeRate]},
                            Keys -> {{resolvedActivationSolution, activateTime, activateShakeRate}},
                            Values -> {{resolvedActivationSolutionKey, ActivateTime, ActivateShakeRate}},
                            Options -> {{ActivationSolutions, Time, ShakeRate}}
                          |>,
                        Null
                      ],

                      (* the interaction solutions should still be index matched to the expanded solutions. *)
                      <|
                        Primitives -> {LoadSurface[LoadingSolutions -> interactionSolutionSet, Time -> loadTime, ShakeRate -> loadShakeRate, ThresholdCriterion -> loadThresholdCriterion,
                        AbsoluteThreshold -> loadAbsoluteThreshold, ThresholdSlope -> loadThresholdSlope, ThresholdSlopeDuration -> loadThresholdSlopeDuration
                      ]},
                        Keys ->{{LoadingSolutions, Time, ShakeRate, ThresholdCriterion, AbsoluteThreshold, ThresholdSlope, ThresholdSlopeDuration}},
                        Values ->{{interactionSolutionSet, loadTime, loadShakeRate, loadThresholdCriterion, loadAbsoluteThreshold, loadThresholdSlope,loadThresholdSlopeDuration}},
                        Options ->{{TestInteractionSolutions, LoadTime, LoadShakeRate, LoadThresholdCriterion, LoadAbsoluteThreshold, LoadThresholdSlope, LoadThresholdSlopeDuration}}
                      |>,

                      (*add the quench primitives*)
                      If[MemberQ[loadingType, Quench],
                        <|
                          Primitives -> {Quench[QuenchSolutions -> ConstantArray[resolvedQuenchSolution,8], Controls -> {}, Time -> quenchTime, ShakeRate -> quenchShakeRate]},
                          Keys -> {{resolvedQuenchSolution, quenchTime, quenchShakeRate}},
                          Values -> {{resolvedQuenchSolutionKey, QuenchTime, QuenchShakeRate}},
                          Options -> {{QuenchSolutions, Time, ShakeRate}}
                        |>,
                        Null
                      ]
                    },
                    {
                      If[MemberQ[loadingType, (Load|Activate|Quench)],
                        If[!MatchQ[plateColumn, First[expandedSamples]]&&MemberQ[regenerationType, (Regenerate|Wash|Neutralize)],
                          Null,
                          <|
                            Primitives -> generalLoadingBlock,
                            Keys -> generalLoadingKeys,
                            Values -> generalLoadingValues,
                            Options -> generalLoadingOptions
                          |>
                        ],
                        Null
                      ],

                      (* add the regeneration block, if pre-condition is requested *)
                      If[MemberQ[regenerationType, PreCondition],
                        <|
                          Primitives -> regenerationBlock,
                          Keys -> regenerationKeys,
                          Values -> regenerationValues,
                          Options -> regenerationOptions
                        |>,
                        Null
                      ]
                    }
                  ],

                  (* add the baseline block as defined above *)
                  <|
                    Primitives -> measureBaselineBlock,
                    Keys -> measureBaselineKeys,
                    Values -> measureBaselineValues,
                    Options -> measureBaselineOptions
                  |>,

                  (* add the association step for the element of samples in that we are on in the mapthread *)
                  <|
                    Primitives -> {MeasureAssociation[
                    Analytes -> First[plateColumn], Controls -> Last[plateColumn], Time -> developmentAssociationTime, ShakeRate -> developmentAssociationShakeRate, ThresholdCriterion -> developmentAssociationThresholdCriterion,
                    AbsoluteThreshold -> developmentAssociationAbsoluteThreshold, ThresholdSlope -> developmentAssociationThresholdSlope, ThresholdSlopeDuration -> developmentAssociationThresholdSlopeDuration
                  ]},
                    Keys -> {{Analytes, Controls, Time, ShakeRate, ThresholdCriterion, AbsoluteThreshold, ThresholdSlope, ThresholdSlopeDuration}},
                    Values -> {{First[plateColumn],Last[plateColumn], developmentAssociationTime, developmentAssociationShakeRate, developmentAssociationThresholdCriterion,
                      developmentAssociationAbsoluteThreshold, developmentAssociationThresholdSlope, developmentAssociationThresholdSlopeDuration}},
                    Options -> {{{DetectionLimitSerialDilutions, DetectionLimitFixedDilutions},Null, DevelopmentAssociationTime, DevelopmentAssociationShakeRate, DevelopmentAssociationThresholdCriterion,
                      DevelopmentAssociationAbsoluteThreshold, DevelopmentAssociationThresholdSlope, DevelopmentAssociationThresholdSlopeDuration}}
                  |>,

                  (* add a measure dissociation block - this already knows about test buffers also*)
                  <|
                    Primitives -> measureDissociationBlock,
                    Keys -> measureDissociationKeys,
                    Values -> measureDissociationValues,
                    Options -> measureDissociationOptions
                  |>,

                  (* add a final regeneration block *)
                  If[MemberQ[regenerationType, (Regenerate|Wash|Neutralize)]&&!MemberQ[regenerationType, PreCondition],
                    <|
                      Primitives -> regenerationBlock,
                      Keys -> regenerationKeys,
                      Values -> regenerationValues,
                      Options -> regenerationOptions
                    |>,
                    Null
                  ]
                }
              ]
            ],

            (* the map goes over test interaction solutiosn as well because they are index matched *)
            {expandedSamples, safeTestInteractionSolutions}
          ];

      (* NOTE be very careful here because we are outside the map thread, this means that the grouping of the primitives must be preserved!!*)
      (* flatten and remove nulls between packets within each assay set *)
      resolvedAssayPrimitivePackets = DeleteCases[Flatten[#], Null]&/@rawAssayPrimitivePackets;

      (*Note: there are also Nulls in the bocks themselves so they need to be removed - these Nulls will be there for each Key, for examples it Primitives -> Null, Keys -> Null also*)
      (*Note: the only way to safely keep the keys, options, and values lists matched to the primitives is to make everything nested one level so that {{valueslist}} can join {{valueslist},Null}*)
      (* extract the primitives from the packets only. Note that the Primitives key may poitn to {primitive, Null, primitive} *)
      extractedPrimitives = DeleteCases[Flatten[Lookup[#, Primitives]], Null]&/@resolvedAssayPrimitivePackets;


      (*all these lists are matched to eachother so we could picklist the key to find the value*)
      (* extract the matched options, values, and keys. The order is already matched from the section above *)
      extractedOptionSets = DeleteCases[Join[Lookup[#,Options]], Null]&/@resolvedAssayPrimitivePackets;
      extractedValueSets = DeleteCases[Join[Lookup[#,Values]], Null]&/@resolvedAssayPrimitivePackets;
      extractedKeySets = DeleteCases[Join[Lookup[#,Keys]], Null]&/@resolvedAssayPrimitivePackets;

      (* return the primitives and the associated variables for error tracking *)
      {extractedPrimitives, extractedKeySets, extractedOptionSets, extractedValueSets},

      (* if there are existing primitives, set the assaySequencePrimitivesFromOptions to Null*)
      {Null, Null, Null, Null}
    ]
  ];

  (* ---------------------------------------- *)
  (* --- ROUND AND ERROR CHECK PRIMITIVES --- *)
  (* ---------------------------------------- *)


  (* primitive are rounded by hand, errors are thrown to match the roundOptionsPrecision warning *)
  {roundedPrimitiveValues, roundedAssaySequencePrimitives} = If[MatchQ[assaySequencePrimitives, Automatic],
    (* if it is automatic, leave it, otherwise we need to round *)
    {Null, Automatic},

    (* do the rounding *)
    Transpose[
      Map[
        Function[{primitive},
          Module[{time, absoluteThreshold, thresholdSlope, thresholdSlopeDuration, shakeRate,
            replaceUnroundedValuesRules, roundedValues},

            (* extract the value, and return Null if there is key is missing *)
            {time, absoluteThreshold, thresholdSlope, thresholdSlopeDuration, shakeRate}=Lookup[Association@@primitive,
              {Time, AbsoluteThreshold, ThresholdSlope, ThresholdSlopeDuration, ShakeRate},
              Null
            ];

            (* make replace rules to replace the valriables in the primitives *)
            replaceUnroundedValuesRules = MapThread[(#1 -> SafeRound[#1,#2])&,
              {{time, absoluteThreshold, thresholdSlope, thresholdSlopeDuration, shakeRate}, {10^0 Second, 10^-2 Nanometer, 10^-2 Nanometer/Minute, 10^0 Second, 10^0 RPM}}
            ];

            (* determine if any values were rounded, and collect them in a form that is easy to use for the warning *)
            roundedValues = MapThread[If[!MatchQ[First[#1], Last[#1]],
              <|Value -> First[#1], Key -> #2, Primitive -> Head[primitive]|>,
              Nothing
            ]&, {replaceUnroundedValuesRules, {Time, AbsoluteThreshold, ThresholdSlope, ThresholdSlopeDuration, ShakeRate}}];

            (* replace the unrounded values with rounded ones *)
            {roundedValues, primitive/.replaceUnroundedValuesRules}
          ]
        ],
        assaySequencePrimitives
      ]
    ]
  ];

  safeRoundedPrimitiveValues = If[MatchQ[roundedPrimitiveValues, Null],
    Null,
    Flatten[roundedPrimitiveValues]
  ];

  (* since we may need to throw this several times, turn off the limit just for this section *)
  Off[General::stop];

  (* if there were any rounded primitives, throw a message *)
  If[MatchQ[safeRoundedPrimitiveValues, Except[(Null|{})]]&&!gatherTests&& Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::BLIPrimitiveValueInstrumentPrecision, ToString[First[#]], ToString[#[[2]]], ToString[Last[#]]]&/@safeRoundedPrimitiveValues,
    Null
  ];

  (* make sure to turn the limit back on again *)
  On[General::stop];

  (* ------------------------------------------------------------------ *)
  (* --- PREPARE PRIMITIVE OUTPUT, SOLUTIONS, AND REPEATED SEQUENCE --- *)
    (* --- this is for the user input and primitives-from-options --- *)
  (* ------------------------------------------------------------------ *)

  (* these will come either from user input or resolved options, depending on the value of assaySequencePrimitives *)
  {
    resolvedAssaySequencePrimitives,
    resolvedExpandedAssaySequencePrimitives,
    preResolvedRepeatedSequence,
    resolvedExpandedSolutions
  }=If[MatchQ[Lookup[fullBLIOptionsAssociation, ExpandedAssaySequencePrimitives], Except[Automatic]],
    (* if the user has specified hte expanded primitives then we are basically done with resolution *)
    {
      Null,
      Lookup[fullBLIOptionsAssociation, ExpandedAssaySequencePrimitives],
      Null,
      Null
    },

    If[MatchQ[assaySequencePrimitives, Automatic],

      (* --------------------------------------------------------------------- *)
      (* --- DETERMINE COMPRESSED PRIMITIVES FROM OPTIONS BASED PRIMITIVES --- *)
      (* --------------------------------------------------------------------- *)

      (* The user has given us options with which to resolve the AssaySequencePrimitives, which can then be expanded to the ExpandedAssaySequencePrimitives *)
    Module[{paddedPrimitives, repeatedSequence,
      newCompressedPrimitives, expandedSolutions, stackedPrimitives, primitiveAssociations, condensedSolutions, initialPrimitivesAssociation,
      preExpandedSolutions, replaceSolutionsRule, initialSolutions, shortestSequences, shortestSequence},

      (* resolve repeated sequence by looking at the resolved primitives. These need to be flattened and de-nulled first. *)
      flattenedExpandedResolvedPrimitives = DeleteCases[Flatten[#],Null]&/@sampleExpandedResolvedPrimitives;

      (* the repeated sequence is the shortest number of steps used to measure a column of samples, if it contains Regenerate. If not there is no repeated sequence. *)
      shortestSequences = Select[flattenedExpandedResolvedPrimitives, MatchQ[Length[#],Min[Length/@flattenedExpandedResolvedPrimitives]]&];
      shortestSequence = Head/@Flatten[DeleteDuplicatesBy[shortestSequences, Length]];

      (* note that repeated sequence may be input byt the user, but we are ignoring it since that is not allowed *)
      repeatedSequence = If[MemberQ[shortestSequence, Regenerate],
        shortestSequence,
        Null
      ];

      (* pull out the order for the initial sequence also, which is just the first element of the expanded Primitives*)
      initialPrimitives = First[flattenedExpandedResolvedPrimitives];
      initialSequence = Head/@initialPrimitives;

      (* --- COMPRESSION OF PRIMITIVES FROM OPTIONS --- *)

      (* make the dimensions of the initial and repeated steps match by padding the front of the repeated steps with Nulls *)
      paddedPrimitives = If[MatchQ[Map[Head,#], repeatedSequence],
        PadLeft[#, Length[initialSequence], Null],
        #
      ]&/@flattenedExpandedResolvedPrimitives;

      (* transpose the padded primitives so that each primitives of the same step type are combined. We can remove Nulls because the dimensions do not need to match anymore. *)
      stackedPrimitives = DeleteCases[DeleteCases[#, Null]&/@Transpose[paddedPrimitives], Null];

      (* within each stack, extract the associations *)
      primitiveAssociations = Map[Sequence@@#&, stackedPrimitives, {2}];

      (* Extract the solutions from the lists, by looking for the solution keys (return nothing if the key is absent). Swap the list to sequence head to prevent extra layer of nesting*)
      preExpandedSolutions = Map[Sequence@@Lookup[
        #,
        {Analytes,Buffers,RegenerationSolutions,ActivationSolutions,LoadingSolutions,QuenchSolutions,NeutralizationSolutions},
        Nothing
      ]&,primitiveAssociations, {2}];

      (* delete duplicates since many steps will have the same solution sets. We only want unique solutions in expanded solutions *)
      expandedSolutions = DeleteDuplicates/@preExpandedSolutions;

      (* take the expanded solutions and flatten them so they can be used in the assaySequencePrimitives *)
      condensedSolutions = Flatten/@expandedSolutions;

      (* construct lists of key value pairs for the initial sequence *)
      initialPrimitivesAssociation = Sequence@@#&/@initialPrimitives;

      (* look up and store the value of the solution key. Replace list head with sequence to avoid extra nesting *)
      initialSolutions = Sequence@@Lookup[
        #,
        {Analytes,Buffers,RegenerationSolutions,ActivationSolutions,LoadingSolutions,QuenchSolutions,NeutralizationSolutions},
        Nothing
      ]&/@initialPrimitivesAssociation;

      (* make associations to replace these solutions with the condensed ones since the primitive can only take a flat list*)
      replaceSolutionsRule = MapThread[
        (#1->#2)&,
        {initialSolutions, condensedSolutions}
      ];

      (* replace the initialSolutions with the expanded solutions, leaving the other parameters alone *)
      newCompressedPrimitives = MapThread[
        #1/.#2&,
        {initialPrimitives, replaceSolutionsRule}
      ];

      (* return the "expandedSolutions" - generated by compression, and the compressed primitives *)

      {newCompressedPrimitives, flattenedExpandedResolvedPrimitives, repeatedSequence, expandedSolutions}
    ],




    (* ----------------------------------------------------------------------------------------- *)
    (* --- DETERMINE THE REPEATEDSEQUENCE AND EXPANDED PRIMITIVES FROM USER INPUT PRIMITIVES --- *)
    (* ----------------------------------------------------------------------------------------- *)

      (* The user has specified some AssaySequencePrimitives which need to be expanded to ExpandedAssaySequencePrimitives *)
    Module[{userRepeatedPrimitiveSequence, userCompletedAssaySequencePrimitives, userExpandedPrimitives, userStepTypes, userLastLoadStepIndex, userExpandedSolutions,
      userPrimitiveAssociations, userFlatCompressedSolutions,
      userCombinedPrimitiveValues,userNumberOfSamplesKeys, userPreExpandedSolutions,
      (*primtives manipulation*)
      userPreExpandedPrimitives, userTooManySolutionSets, expansionLength,safeUserExpandedSolutions, safeUserPreExpandedPrimitives, longestSequence,
      userOverFullColumn, incompleteUserPreExpandedSolutions, multipleSampleColumns, cleanUserExpandedPrimitives
    },

      (* extract the values from each primitive*)
      userCombinedPrimitiveValues = Values[Sequence@@#]&/@roundedAssaySequencePrimitives;

      (* check the number of times that Samples occurs *)
      userNumberOfSamplesKeys = Count[Flatten[userCombinedPrimitiveValues], Samples];


      (* --- FIND THE REPEATED  SEQUENCE --- *)
      (* get the heads from the primitives so to simplify finding a repeated sequence*)
      userStepTypes = Head/@roundedAssaySequencePrimitives;

      (* if the repeated sequence is not Automatic, it is user defined. However, if it is not legal, we will need to define it ourselves. *)
      (*repeated sequence is a sequence of steps repeated by a single set of probes. It is relevant only when there is regeneration. *)
      userRepeatedPrimitiveSequence = If[MatchQ[Lookup[bliOptionsAssociation, RepeatedSequence], Except[Automatic]]&&SubsetQ[userStepTypes, ToList[Lookup[bliOptionsAssociation, RepeatedSequence]]],

        (* the repeated sequence is legit and can be used *)
        Lookup[bliOptionsAssociation, RepeatedSequence],

        (* the repeated sequence need sto be resolved *)
        If[!MemberQ[userStepTypes, Regenerate],

          (* there is no repeated sequence if there is no regeneration step *)
          Null,

          (* If there are load steps, presumably the user wants to repeat the steps after load, unless the experiment type is test interaction. *)
          Which[

            (* normal loading, no test interaction *)
            MemberQ[userStepTypes, LoadSurface]&&MatchQ[developmentType, Except[ScreenInteraction]],

            (* get the index of the last Quench step or load step. The index after this is the start of the repeated sequence  *)
            userLastLoadStepIndex = If[MemberQ[userStepTypes, Quench],
              Max[Flatten[Position[userStepTypes, Quench]]],
              Max[Flatten[Position[userStepTypes, LoadSurface]]]
            ];
            (* use the position to pull out the repeated sequence *)
            roundedAssaySequencePrimitives[[(userLastLoadStepIndex+1);;]],


            (* if we are testing interaction and there are regeneration steps, they will need to occur prior to the loading step, ie. the entire sequence is repeated except any equilibrate step *)
            MemberQ[userStepTypes, LoadSurface]&&MatchQ[developmentType, ScreenInteraction],
            If[MatchQ[userStepTypes, Equilibrate],
              Rest[roundedAssaySequencePrimitives],
              roundedAssaySequencePrimitives
            ],

            (* if there is an equilibrate step, use the rest of the primitives as the repeated sequence *)
            MemberQ[userStepTypes, Equilibrate],
            Rest[roundedAssaySequencePrimitives],

            (* if none of the situations above apply, the entire sequence is repeated *)
            True,
            roundedAssaySequencePrimitives
          ],

          (* if there is an equilibrate step do not repeat it *)
          If[MemberQ[userStepTypes, Equilibrate],
            Rest[roundedAssaySequencePrimitives],
            roundedAssaySequencePrimitives
          ]
        ]
    ];


      (* RESOLVE THE EXPANDED SOLUTIONS *)


      (* extract the primitive associations from the primitives *)
      userPrimitiveAssociations = Sequence@@#&/@roundedAssaySequencePrimitives;

      (* extract the solutions and any Controls from the associations. transpose to get them in the form {{{Solutions}, {blanks}}...} *)
      userFlatCompressedSolutions=Transpose[
        {
          ToList/@Lookup[userPrimitiveAssociations, {Buffers,Analytes, ActivationSolutions, LoadingSolutions, QuenchSolutions, RegenerationSolutions, NeutralizationSolutions}, Nothing],
          ToList/@Lookup[userPrimitiveAssociations, Controls, {}]
        }
      ];

      (* -------------------------------------------------------- *)
      (* --- RESOLVE THE SOLUTIONS IF THERE ARE SAMPLE VALUES --- *)
      (* -------------------------------------------------------- *)

      (* meaning that either MeasureAssociaiton, Quantitate, or LoadSurface Primitives have Analytes/LoadingSolutions -> Samples *)
      If[MatchQ[userNumberOfSamplesKeys, GreaterP[0]],

        (*TODO: remove if recursive expansion implemented*)
        (* check if any solutions sets are longer than the column, return true *)
        userOverFullColumn = If[Length[Flatten[ToList[#]]]>8,
          True,
          False
        ]&/@userFlatCompressedSolutions;

        (* check to see if the expandedSamples are going to take up more than one column. These were already expanded with knowledge of blanks in the primitive. *)
        (* this signifies that we will need to expand the primitives wrt expandedSamples eventually, and also helps keep track of how many solution sets are too long *)
        multipleSampleColumns = If[MatchQ[Length[expandedSamples], Except[(1|0)]],1, 0];

        (* if there is a solution set that requires multiple plate columns AND the samples need to be expanded, we have too many solution sets *)
        (* if there are multiple primitives for which there are multiple solution sets, we will cant resolve it without ambiguity (except for screen interaction) *)
        userTooManySolutionSets = If[MatchQ[(multipleSampleColumns + Count[userOverFullColumn, True]), LessEqualP[1]]||MatchQ[developmentType, ScreenInteraction],
          False,
          True
        ];


        (*The goal here is to pad all solutions to a length of 8-blanks, or partition them if needed. They do not yet need to be expanded to match the longest element. *)
        (*TODO: it is probably safe to implement the recursive expansion to check how many lists are in each list *)

        (* if the solutions are treatable (ie. there are not multiple solutions with excessive length), pad or partition them *)
        (* expand the solutions by mapping over each element - this will expand all of the solution lists to either a list of matching length, or a list of lists with matching lenths. Each one will come out nested.*)
        (* if there are multiple solution sets that are longer than 8, we will not do expansion, and will return Null. *)
        incompleteUserPreExpandedSolutions =
            Module[{paddedSamples},
              Which[
                (* if the solutions are just Samples *)
                MatchQ[First[#],{Samples}],
                First[#],

                (* solutions shorter than 8 just need to be padded *)
                MatchQ[Length[Flatten[#]],LessEqualP[8]],
                PadRight[Flatten[First[#]], (8 - Length[Last[#]]),defaultBuffer],

                (* solutions longer than 8 need to be partitioned *)
                MatchQ[Length[Flatten[#]], GreaterP[8]],
                paddedSamples = Partition[Flatten[First[#]], (8 - Length[Last[#]]), (8 - Length[Last[#]]), 1, defaultBuffer]
              ]
            ]&/@userFlatCompressedSolutions;

        (* having expanded any other solutions, we can now add in the already expanded samples *)
        userPreExpandedSolutions = incompleteUserPreExpandedSolutions/.{Samples}-> (First/@expandedSamples),



        (* --- RESOLVE THE SOLUTIONS IF THERE ARE NO SAMPLE VALUES --- *)
        (* check if any solutions sets are longer than the column, return true *)
        userOverFullColumn = If[MatchQ[Length[Flatten[#]], GreaterP[8]],
          True,
          False
        ]&/@userFlatCompressedSolutions;
        (* if there are multiple primitives for which there are multiple solution sets, we will cant resolve it without ambiguity (except for screen interaction) *)
        userTooManySolutionSets = If[MatchQ[Count[userOverFullColumn, True], LessEqualP[1]]||MatchQ[developmentType, ScreenInteraction],
          False,
          True
        ];

        (* for now we will allow expansion of any length of samples. If they are doing test interaction, the lengths will be matched and it will be correct.  *)
        (* If there are unequal length lists of solutiosn, the longer will expand, and the shorter will constant array *)
        userPreExpandedSolutions = Module[{paddedSamples},
          If[MatchQ[Length[Flatten[#]], LessEqualP[8]],

            (*this needs to be wrapped in a list to match the nestedness of hte partitioned list*)
            {PadRight[Flatten[First[#]], (8 - Length[Last[#]]), defaultBuffer]},
            paddedSamples = Partition[Flatten[First[#]], (8 - Length[Last[#]]), (8 - Length[Last[#]]), 1, defaultBuffer]
          ]
        ]&/@userFlatCompressedSolutions
      ];

      (*TODO: want to make sure that we expand around solutions first, which can be implemented as priority rules in recursive expansion*)
      (* determine how many solution sets are associated with the primitive that has the most solution sets. This is the number of times the primitives sequence are repeated *)
      (* not that if we don't need to repeat, then there will not be any lists *)
      expansionLength = Max[Count[#,_List]&/@userPreExpandedSolutions];

      (* we really want to be counting the number of lists here, not individual elements since this is expansion, and each list is already a safe length *)
      (* use the repeated sequence to expand the primitives (still with the same contents as before) *)
      userExpandedSolutions = If[MatchQ[Count[#,_List],expansionLength],
        #,
        ConstantArray[#, expansionLength]
      ]&/@userPreExpandedSolutions;

      (* ------------------------------------ *)
      (* --- EXPAND USER INPUT PRIMITIVES --- *)
      (* ------------------------------------ *)

      (* Note that we do not support a repeated sequence at the beginning of the primitives, mostly because it is nonsense *)
      (* make expanded primitives using repeated sequence*)
      userPreExpandedPrimitives = If[MatchQ[userRepeatedPrimitiveSequence, Null],

        (* if there is no repeated sequence, just repeat the primitives *)
        ConstantArray[roundedAssaySequencePrimitives, expansionLength],

        (* this ie equivilant to adding the initial steps to the repeated ones *)
        {
          roundedAssaySequencePrimitives,
          If[(expansionLength-1)>0,
            Sequence@@ConstantArray[userRepeatedPrimitiveSequence, (expansionLength-1)],
            Nothing
          ]
        }
      ];

      (* pad every element to the longest assay sequence - first get the length of the longest element, then pad*)
      longestSequence = Max[Length/@DeleteCases[userPreExpandedPrimitives, {}]];
      safeUserPreExpandedPrimitives = PadLeft[#, longestSequence, {{Buffers -> {Null}}}]&/@DeleteCases[userPreExpandedPrimitives, {}];

      (* repeat the process wiht the solutions so the dimensions match *)
      safeUserExpandedSolutions = PadLeft[#, longestSequence, Null]&/@Transpose[userExpandedSolutions];

      (*TODO: this is where the primitive s get the wrong solutions if the Controls key has the exact same value as the solutions key. Its weird but coudl happen*)
      (* mapthread to put the new solutions into the primitives using replace*)
      userExpandedPrimitives = MapThread[
        Function[{primitiveSet, solutionSet},

          (* replace the current value of the solution key with the updated solution *)
          (* recall that each primitive already contains the correct blanks *)
          primitiveSet/.(First[Lookup[Association@@primitiveSet, {Buffers, Analytes, RegenerationSolutions, LoadingSolutions, ActivationSolutions, NeutralizationSolutions, QuenchSolutions}, Nothing]] -> solutionSet)
        ],
        {safeUserPreExpandedPrimitives, safeUserExpandedSolutions},
        2
      ];

      (* remove the dummy elements from above used to deal with bad dimensions. Be aware that the Null has probably been changed to something *)
      cleanUserExpandedPrimitives = DeleteCases[#,{Buffers -> _}]&/@userExpandedPrimitives;

      {roundedAssaySequencePrimitives, cleanUserExpandedPrimitives, Head/@userRepeatedPrimitiveSequence, userExpandedSolutions}
    ]
  ]
  ];



  (* Throw message for forbidden repeated sequence input *)
  If[MatchQ[assaySequencePrimitives, Automatic]&&MatchQ[Lookup[bliOptionsAssociation, RepeatedSequence], Except[(Automatic|Null)]]&&!gatherTests,
    Message[Error::BLIForbiddenRepeatedSequence]
  ];

  (* create a test for if repeated sequence is informed when it shouldnt be *)
  forbiddenRepeatedSequenceTests = testOrNull[gatherTests, "The RepeatedSequence is informed only if the user provides AssaySequencePrimitives:",
    !(MatchQ[assaySequencePrimitives, Automatic]&&MatchQ[Lookup[bliOptionsAssociation, RepeatedSequence], Except[(Automatic|Null)]])
  ];

  (* Throw message for bad repeated sequence if repeated sequence is not a member of the primitives, and both the RepeatedSequence and and AssaySeqeuncePrimitives are informed. There is a different error for the other cases*)
  badRepeatedSequence = If[
    And[
      !MemberQ[Subsequences[ToList[Head/@assaySequencePrimitives]], ToList[Lookup[bliOptionsAssociation, RepeatedSequence]]],
      MatchQ[assaySequencePrimitives, Except[Automatic]],
      MatchQ[Lookup[bliOptionsAssociation, RepeatedSequence], Except[Automatic]]
    ],
    True,
    False
  ];
  badRepeatedSequence = If[Or[
    MemberQ[Subsequences[ToList[Head/@assaySequencePrimitives]], ToList[Lookup[bliOptionsAssociation, RepeatedSequence]]]&&!MatchQ[assaySequencePrimitives, Automatic],
    MatchQ[Lookup[bliOptionsAssociation, RepeatedSequence], Automatic],
    MatchQ[assaySequencePrimitives, Automatic]
  ],
    False,
    True
  ];

  If[badRepeatedSequence&&!gatherTests,
    Message[Error::BLIRepeatedSequenceMismatch, badRepeatedSequence]
  ];

  (* create a test for populated Time Keys *)
  badRepeatedSequenceTests = testOrNull[gatherTests, "The RepeatedSequence is a subset of the AssaySequencePrimitives:", !badRepeatedSequence];

  (* if the RepeatedSequence is unwelcome add it to the invalid options *)
  invalidRepeatedSequenceOptions = If[Or[MatchQ[assaySequencePrimitives, Automatic]&&MatchQ[Lookup[bliOptionsAssociation, RepeatedSequence], Except[Automatic]],MatchQ[badRepeatedSequence,True]], RepeatedSequence];

  (* resolve the actual repeated sequence that will be shown in the options *)
  resolvedRepeatedSequence = Lookup[bliOptionsAssociation, RepeatedSequence]/.Automatic -> preResolvedRepeatedSequence;


  (* -------------------------- *)
  (* --- PLATE LAYOUT CHECK --- *)
  (* -------------------------- *)


  (* call helper function to sort out the plate layout with the resolved expanded primitives and reuseSolution *)
  {primitiveMasterAssociation, plateLayout} = resolveProtocolReadyPrimitives[resolvedExpandedAssaySequencePrimitives, ToList[reuseSolution], defaultBuffer];

  (* Throw message for plate capacity overload *)
  If[MatchQ[Length[plateLayout], GreaterP[12]]&&!gatherTests,
    Message[Error::BLIPlateCapacityOverload,Length[plateLayout]]
  ];
  (* create a test for plate capacity overload *)
  plateCapacityOverloadTests = testOrNull[gatherTests, "The 96-well assay plate can fit the requested assay:", MatchQ[Length[plateLayout], LessEqualP[12]]];

  (* -------------------------- *)
  (* --- PROBE NUMBER CHECK --- *)
  (* -------------------------- *)

  (* look up the probe numbers from the master association, and multiply by repeats *)
  probeCount = Max[Lookup[Flatten[primitiveMasterAssociation], ProbeNumber]]*safeNumberOfRepeats;

  (* Throw message for plate capacity overload *)
  If[MatchQ[probeCount,GreaterP[12]]&&!gatherTests,
    Message[Error::TooManyRequestedBLIProbes,probeCount]
  ];
  (* create a test for plate capacity overload *)
  tooManyRequestedProbesTests = testOrNull[gatherTests, "The assay uses less than or equal to 12 sets of probes:", MatchQ[probeCount, LessEqualP[12]]];

  (* ----------------------------- *)
  (* --- VALID PRIMITIVE CHECK --- *)
  (* ----------------------------- *)

  (* look at each primitive and collect lists for missingAnalyte, missingTime, missing ShakeRate, conflicting Threshold etc. *)
  (* this is checking both the user input and the resolved primitives (condensed form) *)


  (* -------------------------------------------------------- *)
  (* -- check ExpandedAssaySequencePrimitives from options -- *)
  (* -------------------------------------------------------- *)

  (* When both AssaySequencePrimitives and ExpandedAssaySequencePrimitives are Automatic everything is resolved based off of the options *)
  (*because of the restrictive input pattern, the assaySequencePrimitives are always valid - except for the solutions*)
  (* this means they can be checked just like user input ones - they will only error on solution keys *)
  (* The user input one will return errors which point to a specific Key of a primitives at a specified position, while the options defined ones will point to the options that gives the bad primitive. *)
  (* Becasuse the Expanded primitives are nested, they are flattened one level for easy of checking*)
  {
    anyPrimitiveErrorBools,
    invalidPrimitivesFromOptions,
    badTimeBools,
    invalidTimeValues,
    timeOptions,
    badShakeRateBools,
    invalidShakeRateValues,
    shakeRateOptions,
    tooManySolutionsBools,
    invalidSolutionNameBools,
    invalidSolutionNames,
    invalidSolutionValues,
    badSolutionOptions,
    missingSolutionBools,
    conflictingThresholdParameterBools,
    conflictingThresholdParameterOptions,
    missingThresholdParameterBools,
    missingThresholdParameterOptions,
    missingThresholdCriterionBools,
    missingThresholdCriterionOptions
  }= If[
    And[
      MatchQ[Lookup[fullBLIOptionsAssociation, ExpandedAssaySequencePrimitives], Automatic],
      MatchQ[Lookup[fullBLIOptionsAssociation, AssaySequencePrimitives], Automatic]
    ],

    (* determine all of the bad keys in a primitive *)
    Transpose[
      MapThread[Function[{primitive, keySet, valueSet, optionSet},
        Module[{solutionType, solutions, blanks, time, shakeRate, thresholdCriterion, absoluteThreshold, thresholdSlope, thresholdSlopeDuration,
          stringSolutions,
          (*outputs*)
          anyErrorBool, invalidPrimitive, badTimeBool, timeOption, badShakeRateBool, shakeRateOption,
          tooManySolutionsBool, invalidSolutionNameBool, invalidSolutionName, solution, badSolutionOption,
          conflictingThresholdParameterBool, conflictingThresholdParameterOption,
          missingThresholdParameterBool, missingThresholdParameterOption,
          missingThresholdCriterionBool, missingThresholdCriterionOption, missingSolutionBool
        },
          (* figure out which solution key we are looking for in this primitive *)
          solutionType = First[Cases[Keys[primitive], (Analytes|Buffers|RegenerationSolutions|NeutralizationSolutions|LoadingSolutions|QuenchSolutions|ActivationSolutions)]];

          (* pull out all of the relevant values *)
          {
            solutions,
            blanks,
            time,
            shakeRate,
            thresholdCriterion,
            absoluteThreshold,
            thresholdSlope,
            thresholdSlopeDuration
          } = Lookup[Association@@primitive,
            {
              solutionType,
              Controls,
              Time,
              ShakeRate,
              ThresholdCriterion,
              AbsoluteThreshold,
              ThresholdSlope,
              ThresholdSlopeDuration
            }, noKey];

          (* -- check for bad keys -- *)

          (* check if time is 0 or Null *)
          badTimeBool = If[Or[MatchQ[time, Null], EqualQ[time, 0 Second]],
            True,
            False
          ];

          (* use the key set to extract the option that informs the Time key *)
          timeOption = PickList[optionSet, keySet, Time];

          (* shakeRate error check *)
          badShakeRateBool = If[MatchQ[shakeRate, Null],
            True,
            False
          ];

          (* use the key set to extract the option that informs the ShakeRate key *)
          shakeRateOption = PickList[optionSet, keySet, ShakeRate];

          (* check fo uninformed solution key *)
          missingSolutionBool = If[MatchQ[solutions, (Null|{Null...})],
            True,
            False
          ];

          (* check that the threshold stuff is all correct *)
          conflictingThresholdParameterBool = If[MatchQ[absoluteThreshold, Except[(Null|noKey)]]&&(MatchQ[thresholdSlope, Except[(Null|noKey)]]||MatchQ[thresholdSlopeDuration, Except[(Null|noKey)]]),
            True,
            False
          ];

          (* pull out the threshold parameters that could be in conflict *)
          conflictingThresholdParameterOption = {
            PickList[optionSet, keySet, AbsoluteThreshold],
            PickList[optionSet, keySet, ThresholdSlope],
            PickList[optionSet, keySet, ThresholdSlopeDuration]
          };

          (* if any of the guys that are required together are not together, then set missingThresholdParameter to True *)
          missingThresholdParameterBool = If[MatchQ[Length[Cases[{thresholdSlopeDuration,thresholdSlope},Null]],1],
            True,
            False
          ];

          (* pull out the parameters that might be bad *)
          missingThresholdParameterOption = {
            PickList[optionSet, keySet, ThresholdSlope],
            PickList[optionSet, keySet, ThresholdSlopeDuration]
          };

          (* check if the thresholdCriterion is informed along with the other threshold keys *)
          missingThresholdCriterionBool = If[MemberQ[{absoluteThreshold, thresholdSlope, thresholdSlopeDuration}, Except[Null]]&&MatchQ[thresholdCriterion, Null],
            True,
            False
          ];

          missingThresholdCriterionOption = PickList[optionSet, keySet, ThresholdCriterion];

          (* we will assume the objects are real solutions (checked later in FRQ anyway), but need to check the named solutions from dilution etc. *)
          stringSolutions = Cases[Flatten[ToList[solutions]], _String];

          (* complement: identify elements in the first list that are not in the later list(s). If it is not an empty list, there are solutions which are not defined. *)
          (* we are not goign to check for duplicate string solutions because there can be good reasons to have the same solutions measured twice*)
          invalidSolutionName = Complement[stringSolutions, allSolutionNames];

          (* make a boolean for error tracking *)
          invalidSolutionNameBool = If[MatchQ[invalidSolutionName, {}],
            False,
            True
          ];

          (* check if the primitive has too many solutions *)
          tooManySolutionsBool = If[MatchQ[Plus[Length[Flatten[ToList[solutions]]], Length[Flatten[ToList[blanks/.(noKey->Nothing)]]]], GreaterP[8]],
            True,
            False
          ];

          (* figure out the appropriate option to yell about *)
          badSolutionOption = PickList[optionSet, keySet, solutionType];

          (* might as well grab the head while were here*)
          invalidPrimitive = Head[primitive];

          (* check if anything is wrong in the primitive *)
          anyErrorBool = Or[
            badTimeBool,
            badShakeRateBool,
            tooManySolutionsBool,
            invalidSolutionNameBool,
            missingSolutionBool,
            conflictingThresholdParameterBool,
            missingThresholdParameterBool,
            missingThresholdCriterionBool
          ];

          (* return the error tracking booleans and the values that go with them *)
          {
            anyErrorBool,
            invalidPrimitive,
            badTimeBool,
            time,
            timeOption,
            badShakeRateBool,
            shakeRate,
            shakeRateOption,
            tooManySolutionsBool,
            invalidSolutionNameBool,
            invalidSolutionName,
            solution,
            badSolutionOption,
            missingSolutionBool,
            conflictingThresholdParameterBool,
            conflictingThresholdParameterOption,
            missingThresholdParameterBool,
            missingThresholdParameterOption,
            missingThresholdCriterionBool,
            missingThresholdCriterionOption
          }
        ]
      ],
        (*I'm still a little confused why these need to be flattened 2 levels vs the primitives, which come out correctly, but it works so just do it*)
        {
          DeleteCases[Flatten[resolvedExpandedAssaySequencePrimitives, 1],Null],
          DeleteCases[Flatten[resolvedPrimitiveKeys,2], Null],
          DeleteCases[Flatten[resolvedRequiredOptionValues,2], Null],
          DeleteCases[Flatten[resolvedRequiredOptions,2], Null]
        }
      ]
    ],

    (* return a list of Nulls so that PickList wont get mad *)
    ConstantArray[{Null}, 20]
  ];

  (* -- Extract the bad primitives, the bad values, and the options they came from -- *)

  (* -- bad primitives -- *)
  (*TODO: grab any primitive that has a bad value in it and surface it*)
  (* only do this for primitives from options. If either of the primitive input fields are used, don't check this.*)
  badPrimitivesFromOptions = If[
    And[
      MatchQ[Lookup[fullBLIOptionsAssociation, ExpandedAssaySequencePrimitives], Automatic],
      MatchQ[Lookup[fullBLIOptionsAssociation, AssaySequencePrimitives], Automatic]
    ],
    PickList[
      DeleteCases[Flatten[resolvedExpandedAssaySequencePrimitives, 1],Null],
      anyPrimitiveErrorBools,
      True
    ],
    {}
  ];


  (* throw an error if there is a bad primitive. *)
  If[!MatchQ[badPrimitivesFromOptions, {}]&&!gatherTests,
    Message[Error::InvalidResolvedBLIPrimitives, DeleteDuplicates[badPrimitivesFromOptions]]
  ];

  (* if there is any malformed primitives, then make sure the function returns failed. Since the error messages appear alongside eachother this should not be confusing. *)
  badExpandedAssaySequencePrimitiveOption = If[!MatchQ[badPrimitivesFromOptions, {}],
    {ExpandedAssaySequencePrimitives},
    {}
  ];

  (* --- time error tracking --- *)
  primitivesWithBadTime = PickList[invalidPrimitivesFromOptions, badTimeBools, True];
  badTimeValues = PickList[invalidTimeValues, badTimeBools, True];
  badTimeOptions = PickList[timeOptions, badTimeBools, True];


  (* --- shake rate error tracking --- *)
  primitivesWithBadShakeRate = PickList[invalidPrimitivesFromOptions, badShakeRateBools, True];
  badShakeRateValues = PickList[invalidShakeRateValues, badShakeRateBools, True];
  badShakeRateOptions = PickList[shakeRateOptions, badShakeRateBools, True];

  (* --- threshold error tracking --- *)
  (* conflicting parameters *)
  primitivesWithConflictingThresholdParameter = PickList[invalidPrimitivesFromOptions, conflictingThresholdParameterBools, True];
  pickedConflictingThresholdOptions = PickList[conflictingThresholdParameterOptions, conflictingThresholdParameterBools, True];

  (*missing threhsold criterion*)
  primitivesWithMissingThresholdCriterion = PickList[invalidPrimitivesFromOptions, missingThresholdCriterionBools, True];
  pickedMissingThresholdCriterionOptions = PickList[missingThresholdCriterionOptions, missingThresholdCriterionBools, True];

  (* missing parameters *)
  primitivesWithMissingThresholdParameters = PickList[invalidPrimitivesFromOptions, missingThresholdParameterBools, True];
  pickedMissingThresholdParameterOptions = PickList[missingThresholdParameterOptions, missingThresholdParameterBools, True];

  (* --- solution error tracking --- *)
  (* primitives with too many solutions *)
  primitivesWithTooManySolutions = PickList[invalidPrimitivesFromOptions, tooManySolutionsBools, True];
  optionsForPrimitivesWithTooManySolutions = PickList[badSolutionOptions, tooManySolutionsBools, True];

  (* primitives with invalid names, and the names *)
  primitivesWithInvalidSolutionNames = PickList[invalidPrimitivesFromOptions, invalidSolutionNameBools, True];
  invalidSolutionNameValues = PickList[invalidSolutionNames,invalidSolutionNameBools, True];
  optionsForPrimitivesWithInvalidSolutionNames = PickList[badSolutionOptions,invalidSolutionNameBools, True];

  (* primitives with missing solutions *)
  primitivesWithMissingSolutions = PickList[invalidPrimitivesFromOptions, missingSolutionBools,True];
  optionsForPrimitivesWithMissingSolutions = PickList[badSolutionOptions,missingSolutionBools,True];

  (* ---------------------------------------- *)
  (* -- ERRORS FOR PRIMITIVES FROM OPTIONS -- *)
  (* ---------------------------------------- *)

  (* Throw message for missing Time Keys *)
    If[!MatchQ[primitivesWithBadTime,{}]&&!gatherTests,
      Message[Error::BLIMissingTime, DeleteDuplicates[Flatten[badTimeOptions]], DeleteDuplicates[Flatten[badTimeValues]]]
    ];
    (* create a test for populated Time Keys *)
    missingTimesTests = testOrNull[gatherTests, "The specified Options result in primitives with valid Time keys:", MatchQ[primitivesWithBadTime, {}]];


    (* Throw message for missing ShakeRate Keys *)
    If[!MatchQ[primitivesWithBadShakeRate,{}]&&!gatherTests,
      Message[Error::MissingBLIShakeRate, DeleteDuplicates[Flatten[badShakeRateOptions]], DeleteDuplicates[Flatten[badShakeRateValues]]]
    ];
    (* create a test for populated ShakeRate Keys *)
    missingShakeRatesTests = testOrNull[gatherTests, "The specified Options result in primitives with valid ShakeRate keys:", MatchQ[primitivesWithBadShakeRate, {}]];

  (* ------------------------ *)
  (* --- threshold errors --- *)
  (* ------------------------ *)


  (* Throw message for conflicting threshold parameters *)
  If[!MatchQ[primitivesWithConflictingThresholdParameter,{}]&&!gatherTests,
    Message[Error::BLIConflictingThresholdParameters, DeleteDuplicates[Flatten[pickedConflictingThresholdOptions]]]
  ];
  (* create a test for conflicting threshold parameters *)
  conflictingThresholdParameterTests = testOrNull[gatherTests, "The Threshold Keys do not conflict:", MatchQ[primitivesWithConflictingThresholdParameter, {}]];

  (* Throw message for missing ShakeRate Keys *)
  If[!MatchQ[primitivesWithMissingThresholdCriterion,{}]&&!gatherTests,
    Message[Error::BLIMissingThresholdCriterion, DeleteDuplicates[Flatten[pickedMissingThresholdCriterionOptions]]]
  ];
  (* create a test for populated ShakeRate Keys *)
  missingThresholdCriteriaTests = testOrNull[gatherTests, "The ThresholdCriterion is informed along with any other Threshold related keys:", MatchQ[primitivesWithMissingThresholdCriterion , {}]];

  (* Throw message for missing ShakeRate Keys *)
  If[!MatchQ[primitivesWithMissingThresholdParameters ,{}]&&!gatherTests,
    Message[Error::BLIMissingThresholdParameters, DeleteDuplicates[Flatten[pickedMissingThresholdParameterOptions]]]
  ];
  (* create a test for populated ShakeRate Keys *)
  missingThresholdParametersTests = testOrNull[gatherTests, "The ThresholdSlope and ThresholdSlopeDuration keys are informed together or both not informed:", MatchQ[primitivesWithMissingThresholdParameters, {}]];

  (* --------------------------- *)
  (* --- bad solution errors --- *)
  (* --------------------------- *)

  (* ---  missing solutions --- *)

  (* Throw message for missing Solution Keys *)
  If[!MatchQ[primitivesWithMissingSolutions,{}]&&!gatherTests,
    Message[Error::BLIMissingSolution, DeleteDuplicates[Flatten[optionsForPrimitivesWithMissingSolutions]]]
  ];
  (* create a test for populated Solution Keys *)
  missingSolutionsTests = testOrNull[gatherTests, "Required solutions have all been sepcified:", MatchQ[primitivesWithMissingSolutions, {}]];

  (* --- too many solutions --- *)

  (* Throw message for missing Solution Keys *)
  If[!MatchQ[primitivesWithTooManySolutions,{}]&&!gatherTests,
    Message[Error::BLITooManySolutions, primitivesWithTooManySolutions, DeleteDuplicates[Flatten[optionsForPrimitivesWithTooManySolutions]]]
  ];
  (* create a test for populated Solution Keys *)
  tooManySolutionsTests = testOrNull[gatherTests, "The specified options result in each member of the AssaySequencePrimitives having fewer than 8 total solutions:", MatchQ[primitivesWithTooManySolutions, {}]];

  (* --- invalid solutions --- *)

  (* Throw message for invalid solution *)
  If[!MatchQ[primitivesWithInvalidSolutionNames,{}]&&!gatherTests,
    Message[Error::BLIInvalidSolution, invalidSolutionNameValues, DeleteDuplicates[Flatten[optionsForPrimitivesWithInvalidSolutionNames]]]
  ];

  (* create a test for invalid solutions *)
  invalidSolutionsTests = testOrNull[gatherTests, "The solution IDs match with user defined or resolved solutions:", MatchQ[primitivesWithInvalidSolutionNames, {}]];


  (* --- error check for Null primitives --- *)

  (* if expandedassayprimitives are Null, something else has gone horribly wrong *)
  If[MatchQ[resolvedExpandedAssaySequencePrimitives, Null]&&!gatherTests,
    Message[Error::BLIPrimitiveResolutionFailed]
  ];
  invalidPrimitivesTests = testOrNull[gatherTests, "The given options result in valid ExpandedAssaySequencePrimitives:", MatchQ[resolvedExpandedAssaySequencePrimitives, Except[Null]]];


  (* --------------------------------------------------------------- *)
  (* --- PRIMITIVE ERROR CHECK ON USER INPUT EXPANDED PRIMITIVES --- *)
  (* --------------------------------------------------------------- *)

  (* check the validity of hte expanded primitives *)
  (* note that the user input ones have already been checked by the pattern so we are only interested in if they have the right number of solutions and don't have a Analytes -> Samples*)
  (* the finalExpandedAssaySequencePrimitives from option resolution have already been checked, and take their keys from the compressed primitives. So there is no need to check those either  *)
  {
    primitiveHeads,
    allSolutionSets,
    allBlankSets,
    badSolutionSets,
    badSolutionKeys,
    allStepTimes,
    userPrimitiveIndex
  } = If[Or[
    !MatchQ[Lookup[fullBLIOptionsAssociation, ExpandedAssaySequencePrimitives], Automatic],
    !MatchQ[Lookup[fullBLIOptionsAssociation, AssaySequencePrimitives], Automatic]
  ],

    (*error check the primitives*)
    Transpose@MapIndexed[
      Function[{primitive, index},
        Module[{primitiveAssociation, primitiveHead, samples, blanks, overLengthSamples, solutionKeyDesignatedSamples, times},
          (* get the primitive type *)
          primitiveHead = Head[primitive];

          (*make the primitive easy to lookup from*)
          primitiveAssociation = Association@@primitive;

          (* look up the keys *)
          samples = Lookup[primitiveAssociation, {Analytes,Buffers,RegenerationSolutions,NeutralizationSolutions,LoadingSolutions,QuenchSolutions,ActivationSolutions}, Nothing];
          blanks = Lookup[primitiveAssociation, Controls, {Nothing}];
          times = Lookup[primitiveAssociation, Time];

          (* determine if there are too many samples in this primitive - this is a guard against overloaded columns while recursive expand is not implemented *)
          overLengthSamples = If[MatchQ[Plus[Length[Flatten[ToList[blanks]]], Length[Flatten[ToList[samples]]]], GreaterP[8]],
            True,
            False
          ];

          (* determine if a Samples designation has been used in a sample key. This should never be the case at this point. *)
          (* also check if any strings here match the known string names. If not, this will be flagged *)
          solutionKeyDesignatedSamples = If[
            Or[
              MatchQ[samples, Samples],
              !SubsetQ[allSolutionNames,Cases[Flatten[ToList[samples]], _String]]
            ],
            True,
            False
          ];

          (* return the error trackers and values *)
          {primitiveHead, samples, blanks, overLengthSamples, solutionKeyDesignatedSamples, times, index}
        ]
      ],
      Flatten[resolvedExpandedAssaySequencePrimitives]
    ],

    (*don't error check the primitives, it has already been done earlier*)
    ConstantArray[{Null}, 7]
  ];

  (* calculate the total assay time (rough estimate that does not include any switching probes ~ 5 seconds) *)
  totalAssayTime = If[MatchQ[invalidTimeValues, {Null}],
    Plus@@allStepTimes/.(Null->0 Second),
    Plus@@invalidTimeValues/.(Null->0 Second)
  ];

  (* -- pull out the bad elements -- *)
  primitivesWithTooManySolutions = PickList[primitiveHeads, badSolutionSets, True];
  primitivesWithInvalidSolutionKeys = PickList[primitiveHeads, badSolutionKeys, True];
  badSolutions = PickList[allSolutionSets, badSolutionSets, True];
  badSolutionsIndex = PickList[userPrimitiveIndex, badSolutionSets, True];

  (*TODO: the TooManySolutions section can be removed if recursive solution expansion is implemented - meaning that the primitives are expanded until none have more than 8 solutions. *)
  (* Throw message for bad solutions that indicates which primitive it is *)
  If[!MatchQ[primitivesWithTooManySolutions,{}]&&!gatherTests,
    Message[Error::UserBLIPrimitivesTooManySolutions, primitivesWithTooManySolutions, badSolutionsIndex, badSolutions]
  ];

  (* create a test for too many solutions in a primitive that cant be expanded *)
  overloadedAssayStepTests = testOrNull[gatherTests, "When expanded, each primitive has fewer than 8 solutions:", MatchQ[primitivesWithTooManySolutions, {}]];

  (* Throw and error for having the Samples value for a solution key *)
  If[!MatchQ[primitivesWithInvalidSolutionKeys,{}]&&!gatherTests,
    Message[Error::UserBLIPrimitivesInvalidSolutionKey, primitivesWithInvalidSolutionKeys, badSolutionsIndex,  badSolutionKeys]
  ];

  (* create a test ExpandedAssaySequencePrimitives with the Samples value in them or unrecognized solution names. *)
  badPrimitiveSolutionTests = testOrNull[gatherTests, "Each element of ExpandedAssaySequence has valid solutions:", MatchQ[primitivesWithInvalidSolutionKeys, {}]];

  (* make the option invalid if this test fails and the option was user specified *)
  invalidExpandedAssaySequence = If[MatchQ[Lookup[fullBLIOptionsAssociation, ExpandedAssaySequencePrimitives], Automatic]&&!MatchQ[primitivesWithInvalidSolutionKeys, {}],
    ExpandedAssaySequencePrimitives,
    Null
  ];

  (* resolve the plate cover based on the total assay time *)
  resolvedPlateCover = If[MatchQ[totalAssayTime, GreaterP[4 Hour]],
    plateCover/.Automatic -> True,
    plateCover/.Automatic -> False
  ];

  (* Throw message for a required plate cover. Even though it long, over 5 Hours it is really important for maintaining concentration *)
  If[totalAssayTime>4*Hour&&!resolvedPlateCover&&!gatherTests&& Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::BLIPlateCoverRecommended, totalAssayTime]
  ];

  (* Throw message for unneeded plate cover - we are not too strict here since it may be reasonable for a 3 hour assay. In general we do want to discourage the plate cover use. *)
  (* this plate cover will increase the cost by ~$100 and also is sort of a sketchy part that looks failure prone *)
  If[totalAssayTime<4*Hour&&resolvedPlateCover&&!gatherTests&& Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::BLIPlateCoverNotRecommended, totalAssayTime]
  ];

  allPrimitiveHeads = Head/@(Flatten[resolvedExpandedAssaySequencePrimitives]);
  (* Throw message for missing equilibration *)
  If[MatchQ[probeRackEquilibration, False]&&!gatherTests&&Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::NoBLIProbeEquilibration]
  ];

  (* if this is only a single measuremnt, warn the user that regeneration is not needed *)
  If[MemberQ[regenerationType, (Wash|Neutralize|Regenerate)]&&MatchQ[Times[safeNumberOfRepeats,Length[resolvedExpandedAssaySequencePrimitives]], 1]&&!gatherTests&&Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::UnneededBLIProbeRegeneration]
  ];

  (* create a test for populated Time Keys *)
  equilibrationTests = testOrNull[gatherTests, "The probes are equilibrated prior to use in measurement or loading steps:", MatchQ[probeRackEquilibration, True]];






  (* ----------------------------- *)
  (* -- STORAGE CONDITION CHECK -- *)
  (* ----------------------------- *)

  (*Note: the only option which has a specified storage condition and is automatic is quantitationStandardStorageCondition*)


  (* -- check if load solution is specified -- *)
  (* collect invalid option *)
  unusedLoadSolutionStorageCondition = If[
    MatchQ[loadSolution, Null]&&MatchQ[loadSolutionStorageCondition, Except[Null]],
    {LoadSolutionStorageCondition},
    {}
  ];

  (* make the test *)
  unusedLoadSolutionStorageConditionTest = testOrNull[
    gatherTests,
    "The storage condition for the Standard is only populated if Standard is specified:",
    MatchQ[unusedLoadSolutionStorageCondition, {}]
  ];

  (* throw the error *)
  If[MatchQ[unusedLoadSolutionStorageCondition, Except[{}]]&&messages,
    Message[Error::BLILoadSolutionStorageConditionMismatch]
  ];



  (* -- check if standard is specified -- *)
  (* collect invalid option *)
  unusedStandardStorageCondition = If[
    MatchQ[standard, Null]&&MatchQ[standardStorageCondition, Except[Null]],
    {StandardStorageCondition},
    {}
  ];

  (* make the test *)
  unusedStandardStorageConditionTest = testOrNull[
    gatherTests,
    "The storage condition for the Standard is only populated if Standard is specified:",
    MatchQ[unusedStandardStorageCondition, {}]
  ];

  (* throw the error *)
  If[MatchQ[unusedStandardStorageCondition, Except[{}]]&&messages,
    Message[Error::BLIStandardStorageConditionMismatch]
  ];



  (* -- check if quantitaionStandard is specified -- *)

  (* resolve the storage condition in case it got carried over from Standard *)
  resolvedQuantitationStandardStorageCondition = If[MatchQ[quantitationStandard, standard]&&MatchQ[quantitationStandard, Except[Null]],
    quantitationStandardStorageCondition/.Automatic -> standardStorageCondition,
    quantitationStandardStorageCondition/.Automatic -> Null
  ];

  (* collect invalid option *)
  unusedQuantitationStandardStorageCondition = If[
    MatchQ[quantitationStandard, Null]&&MatchQ[resolvedQuantitationStandardStorageCondition, Except[Null]],
    {QuantitationStandardStorageCondition},
    {}
  ];

  (* make the test *)
  unusedQuantitationStandardStorageConditionTest = testOrNull[
    gatherTests,
    "The storage condition for the QuantitationStandard is only populated if QuantitationStandard is specified:",
    MatchQ[unusedQuantitationStandardStorageCondition, {}]
  ];

  (* throw the error *)
  If[MatchQ[unusedQuantitationStandardStorageCondition, Except[{}]]&&messages,
    Message[Error::BLIQuantitationStandardStorageConditionMismatch]
  ];


  (* -- check if quantitiatyenzyme is specified -- *)
  (* collect invalid option *)
  unusedQuantitationEnzymeSolutionStorageCondition = If[
    MatchQ[quantitationEnzymeSolution, Null]&&MatchQ[quantitationEnzymeSolutionStorageCondition, Except[Null]],
    {QuantitationEnzymeSolutionStorageCondition},
    {}
  ];

  (* make the test *)
  unusedQuantitationEnzymeSolutionStorageConditionTest = testOrNull[
    gatherTests,
    "The storage condition for the QuantitationEnzymeSolution is only populated if QuantitiationEnzymeSolution is specified:",
    MatchQ[unusedQuantitationEnzymeSolutionStorageCondition, {}]
  ];

  (* throw the error *)
  If[MatchQ[unusedQuantitationEnzymeSolutionStorageCondition, Except[{}]]&&messages,
    Message[Error::BLIQuantitationEnzymeStorageConditionMismatch]
  ];


  (* -- check if interaction solutions are specified -- *)
  (* collect invalid option *)
  unusedTestInteractionSolutionsStorageConditions = If[
    MatchQ[testInteractionSolutions, (Null|{Null..})]&&MatchQ[testInteractionSolutionsStorageConditions, Except[(Null|{Null..})]],
    {TestInteractionSolutionsStorageConditions},
    {}
  ];

  (* make the test *)
  unusedTestInteractionSolutionsStorageConditionsTest = testOrNull[
    gatherTests,
    "The storage condition for the TestInteractionSolutions is only populated if TestInteractionSolutions is specified:",
    MatchQ[unusedTestInteractionSolutionsStorageConditions, {}]
  ];

  (* throw the error *)
  If[MatchQ[unusedTestInteractionSolutionsStorageConditions, Except[{}]]&&messages,
    Message[Error::BLITestInteractionSolutionsStorageConditionMismatch]
  ];


  (* -- check if test loading solutions are specified -- *)
  (* collect invalid option *)
  unusedTestLoadingSolutionsStorageConditions = If[
    MatchQ[testLoadingSolutions, Null]&&MatchQ[testLoadingSolutionsStorageConditions, Except[Null]],
    {TestLoadingSolutionsStorageConditions},
    {}
  ];

  (* make the test *)
  unusedTestLoadingSolutionsStorageConditionsTest = testOrNull[
    gatherTests,
    "The storage condition for the TestLoadingSolutions is only populated if TestLoadingSolutions is specified:",
    MatchQ[unusedTestLoadingSolutionsStorageConditions, {}]
  ];

  (* throw the error *)
  If[MatchQ[unusedTestLoadingSolutionsStorageConditions, Except[{}]]&&messages,
    Message[Error::BLITestLoadingSolutionsStorageConditionMismatch]
  ];


  (* -- check the length of the test loading solutions -- *)
  badLengthTestLoadingSolutionsStorageConditions = If[
    MatchQ[Length[ToList[testLoadingSolutions]], Length[ToList[testLoadingSolutionsStorageConditions]]],
    {},
    {TestLoadingSolutionsStorageConditions}
  ];

  (* make the test *)
  badLengthTestLoadingSolutionsStorageConditionsTest = testOrNull[
    gatherTests,
    "The length of the storage condition for the TestLoadingSolutions matches the length of TestLoadingSolutions:",
    MatchQ[badLengthTestLoadingSolutionsStorageConditions, {}]
  ];

  (*throw the error*)
  If[MatchQ[badLengthTestLoadingSolutionsStorageConditions, Except[{}]],
    Message[Error::BLITestLoadingSolutionsStorageConditionLengthMismatch]
  ];

  (* invalid options, error message, test *)

  (* -- check if load solution is specified -- *)
  (* collect invalid option *)
  unusedBinningAntigenStorageCondition = If[
    MatchQ[binningAntigen, Null]&&MatchQ[binningAntigenStorageCondition, Except[Null]],
    {BinningAntigenStorageCondition},
    {}
  ];

  (* make the test *)
  unusedBinningAntigenStorageConditionTest = testOrNull[
    gatherTests,
    "The storage condition for the BinningAntigen is only populated if BinningAntigen is specified:",
    MatchQ[unusedBinningAntigenStorageCondition, {}]
  ];

  (* throw the error *)
  If[MatchQ[unusedBinningAntigenStorageCondition, Except[{}]]&&messages,
    Message[Error::BLIBinningAntigenStorageConditionMismatch]
  ];


  (* ------------------------ *)
	(*-- CONTAINER RESOLUTION --*)
  (* ------------------------ *)

  (* Resolve RequiredAliquotContainers *)
  (* we want to do microSM so we are going to transfer all of the samples into LiquidHandler compatible containers *)

  requiredVolumes = Module[{allSamplesInPlate, rawSamplesInPlateVolumeRules, samplesInPlateVolumeRules,
    safeDetectionLimitSerialDilutions, safeDetectionLimitFixedDilutions, safeKineticsSampleSerialDilutions,
    safeKineticsSampleFixedDilutions, dilutionsVolumeRules, preMixVolumeRules, allVolumeRules, mySafeSamples},

    (* -- clean up the samples -- *)
    mySafeSamples = ToList[mySamples]/.x:ObjectP[]:>Download[x, Object];

    (* -- check the sample in plate -- *)
    (* find all of the instances of the samples in the plate *)
    allSamplesInPlate = Cases[(Flatten[plateLayout]/.x:ObjectP[]:>Download[x, Object]), Alternatives@@mySafeSamples];

    (* map each one to 250 Microliter *)
    rawSamplesInPlateVolumeRules = Map[(#->250 Microliter)&,allSamplesInPlate];

    (* merge the volumes together as rules of the form Samples -> TotalVolInPlate *)
    samplesInPlateVolumeRules = Merge[rawSamplesInPlateVolumeRules, Total];

    (* make the things safe either in the form of {Null...} or {{trasnfer amount, diluent amount, name}...}*)
    safeKineticsSampleFixedDilutions = Map[standardizedBLIDilutions[#, Fixed]&, kineticsSampleFixedDilutions];
    safeKineticsSampleSerialDilutions = Map[standardizedBLIDilutions[#, Serial]&, kineticsSampleSerialDilutions];
    safeDetectionLimitFixedDilutions = Map[standardizedBLIDilutions[#, Fixed]&,  detectionLimitFixedDilutions];
    safeDetectionLimitSerialDilutions = Map[standardizedBLIDilutions[#, Serial]&, detectionLimitSerialDilutions];

    (* -- check the dilutions/solutions -- *)

    (* generate sample -> volume rules *)
    dilutionsVolumeRules = MapThread[
      Function[{sample, kineticsSerialDilution, kineticsFixedDilution, developmentSerialDilution, developmentFixedDilution, preMixSolution},
        (*standardize the dilutions before using them*)
      Module[{kineticsVolumes, developmentVolumes, preMixVolumes, totalVolumeRule},

        (* determine the volumes required for kinetics samples *)
        kineticsVolumes = Which[

          MatchQ[kineticsSerialDilution, Except[Null]],
          First[First[kineticsSerialDilution]],

          MatchQ[kineticsFixedDilution, Except[Null]],
          Total[First/@kineticsFixedDilution],

          True,
          (0 Microliter)
        ];

        (* determine the volumes required for development samples *)
        developmentVolumes = Which[

          MatchQ[developmentSerialDilution, Except[Null]],
          First[First[developmentSerialDilution]],

          MatchQ[developmentFixedDilution, Except[Null]],
          Total[First/@developmentFixedDilution],

          True,
          (0 Microliter)
        ];

        preMixVolumes =
          If[MatchQ[preMixSolution], Except[Null],
            Module[{preMixName, numberOfWells, totalPreMixVolume},
              (* pull the name of the solution out *)
              preMixName = Last[preMixSolution];
              (* find out how many wells have the premix solution in it *)
              numberOfWells = Length[Cases[Flatten[plateLayout], preMixName]];

              (* multiply the volume of the sample by the number of wells it is in *)
              totalPreMixVolume = numberOfWells*First[preMixSolution]
            ],
            (0 Microliter)
          ];

        (* make the volume in the form of a rule so we can merge it easily later *)
        totalVolumeRule = (sample -> Total[{kineticsVolumes, developmentVolumes, preMixVolumes}])
      ]
    ],
      {mySafeSamples, safeKineticsSampleSerialDilutions, safeKineticsSampleSerialDilutions, safeDetectionLimitFixedDilutions, safeDetectionLimitSerialDilutions, preMixSolutions}
    ];

    (* combine the sample amounts from the plate with those from the dilutions *)
    allVolumeRules = Merge[Join[Normal[dilutionsVolumeRules], Normal[samplesInPlateVolumeRules]], Total];

    (* just do a straight substitution here, no need to clean up any bad input *)
    mySafeSamples/.allVolumeRules
  ];


  (* choose an aliquot container if it is needed. If not, it can just be set to Null *)
  (*1: check the volumes - this needs to be different for serial vs fixed dilutiosn adn also premix*)

  (* 2: check the container *)
  (* 3: if the container is not SM compatible - other wise put a Null. RequiredAliquotContainers *)
  (* 4: if the container is not Null, put the volume. Otherwise put Null for RequireAliquotAmounts *)

  (* targetContainers is in the form {(Null|ObjectP[Model[Container]])..} and is index-matched to simulatedSamples. *)
  (* When you do not want an aliquot to happen for the corresopnding simulated sample, make the corresponding index of targetContainers Null. *)
  (* Otherwise, make it the Model[Container] that you want to transfer the sample into. *)

  (* make a list of viable containers *)
  hamiltonCompatibleContainers=bliLiquidHandlerContainers[];

  (* look up the containers from the cache *)
  simulatedSampleContainers = Download[simulatedSamples, Container[Model], Cache -> newCache, Simulation -> updatedSimulation, Date->Now][Object];

  (* determine the target container for each sample that is not already in an ok container *)
  targetContainers=MapThread[Function[{container,volume},
    If[MemberQ[hamiltonCompatibleContainers,container],

      (* container is ok *)
      Null,

      (* select an appropriately sized container that is liquid handler compatible *)
      PreferredContainer[volume,LiquidHandlerCompatible -> True]
    ]
  ],
    {simulatedSampleContainers, requiredVolumes}
  ];


  (* resolveAliquotOptions is index matched to the samples in. So it is ok to go through the volume of each and do a switch list *)
  (* need to determine required aliquot amount *)
	(* Resolve Aliquot Options *)
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
	(* Note: we don't allow solids (default) so resolveAliquotOptions will throw an error if solid samples will be given as input *)
		resolveAliquotOptions[
			ExperimentBioLayerInterferometry,
			mySamples,
			simulatedSamples,
			ReplaceRule[myOptions,resolvedSamplePrepOptions],
			Cache -> newCache,
      Simulation -> updatedSimulation,
			RequiredAliquotAmounts->requiredVolumes,
			RequiredAliquotContainers->targetContainers,
			Output->{Result,Tests}
		],
		{
			resolveAliquotOptions[
				ExperimentBioLayerInterferometry,
				mySamples,
				simulatedSamples,
				ReplaceRule[myOptions,resolvedSamplePrepOptions],
				Cache -> newCache,
        Simulation -> updatedSimulation,
				RequiredAliquotAmounts->requiredVolumes,
				RequiredAliquotContainers->targetContainers,
				Output->Result
      ],
			{}
		}
	];

	(* Resolve Post Processing Options *)
  resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

  (* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
  (* gather the invalid inputs *)
  invalidInputs=DeleteDuplicates[Flatten[{
    solidStateInvalidInputs,
    discardedInvalidInputs,
    compatibleMaterialsInvalidInputs
  }]];

  (* figure out if there are any problems with the primitives *)
  invalidAssaySequencePrimitivesOption = If[MemberQ[
    Join[
      primitivesWithTooManySolutions, primitivesWithMissingThresholdParameters,
      primitivesWithMissingThresholdCriterion,
      primitivesWithConflictingThresholdParameter
    ], Except[{}]]||Length[probeCount]>12||Length[plateLayout]>12,
    AssaySequencePrimitives];

  (*add the invalid options here*)
  (* gather the invalid options *)
  invalidOptions=DeleteCases[
    DeleteDuplicates[
      Flatten[
        {
          optionsForPrimitivesWithTooManySolutions,
          pickedMissingThresholdParameterOptions,
          pickedMissingThresholdCriterionOptions,
          pickedConflictingThresholdOptions,
          badTimeOptions,
          badShakeRateOptions,
          optionsForPrimitivesWithInvalidSolutionNames,
          optionsForPrimitivesWithMissingSolutions,
          deprecatedInvalidInputs,nameInvalidOptions,
          invalidPreMixSolutionsOptions,
          invalidAssaySequencePrimitivesOption,
          invalidKineticsDilutionsOptions,
          invalidKineticsDiluentOptions,
          invalidDevelopmentDilutionsOptions,
          invalidDevelopmentDiluentOptions,
          invalidPreMixSolutionOptions,
          invalidPreMixDiluentOptions,
          invalidRepeatedSequenceOptions,
          duplicateNameLocations,
          invalidDevelopmentFixedOptions,
          invalidDevelopmentSerialOptions,
          invalidKineticsSampleFixedOptions,
          invalidKineticsSampleSerialOptions,
          invalidExpandedAssaySequence,
          duplicateNameLocations,
          conflictingQuantitationStandardOptions,
          missingQuantitationStandardOptions,
          unusedLoadParameters,
          unusedActivateParameters,
          unusedQuenchParameters,
          optionsWithTooManyDilutions,
          invalidQuantitationParametersOption,
          unusedStandardCurveOptions,
          badExpandedAssaySequencePrimitiveOption,
          tooLargeQuantitationStandardDilutionOptions,
          tooSmallQuantitationStandardDilutionOptions,
          tooSmallQuantitationStandardTransferOptions,
          conflictingDelayOptions,
          missingBLIBinningOptions,
          optionsWithSolidObjectInput,
          invalidBinningExperimentOption,
          missingStandardOptions,
          optionsFromWrongExperimentType,
          unusedBinningQuenchOptions,
          unusedPreMixOptions,
          missingTestSolutionsOptions,
          missingRequiredOptionsForDevelopment,
          unusedDevelopmentTypeSpecificOptions,
          (* storage condition *)
          unusedLoadSolutionStorageCondition,
          unusedStandardStorageCondition,
          unusedQuantitationStandardStorageCondition,
          unusedQuantitationEnzymeSolutionStorageCondition,
          unusedTestInteractionSolutionsStorageConditions,
          unusedTestLoadingSolutionsStorageConditions,
          unusedBinningAntigenStorageCondition,
          badLengthTestLoadingSolutionsStorageConditions,
          invalidSamplesInStorageConditionOption
        }
      ]
    ],
    Null
  ];

  (* Throw Error::InvalidInput if there are invalid inputs. *)
  If[Length[invalidInputs]>0&&!gatherTests,
    Message[Error::InvalidInput, ObjectToString[invalidInputs, Simulation -> updatedSimulation]]
  ];

  (* Throw Error::InvalidOption if there are invalid options. *)
  If[Length[invalidOptions]>0&&!gatherTests,
    Message[Error::InvalidOption,invalidOptions]
  ];

  bliTests = Cases[Flatten[
    {
      samplePrepTests, aliquotTests, missingPreMixDiluentsTests, missingPreMixSolutionsTests, conflictingDevelopmentDilutionsTests, missingDevelopmentDiluentsTests ,
      missingDevelopmentDilutionsTests, conflictingKineticsDilutionsTests, missingKineticsDiluentTests,
      missingKineticsDilutionsTests, missingTimesTests, missingShakeRatesTests, missingSolutionsTests,
      conflictingThresholdParameterTests, missingThresholdCriteriaTests, missingThresholdParametersTests, invalidSolutionsTests,
      overloadedAssayStepTests, tooLargePreMixSolutionsTests, tooLargeDetectionLimitFixedDilutionsTests,
      tooLargeKineticsFixedDilutionsTests, tooLargeKineticsSerialDilutionsTests, tooLargeDetectionLimitSerialDilutionsTests,
      validNameTest, insufficientTransferVolumesTests, deprecatedTest, compatibleMaterialsTests, tooManyDilutionsTest,
      forbiddenRepeatedSequenceTests, badRepeatedSequenceTests, plateCapacityOverloadTests, tooManyRequestedProbesTests,
      badPrimitiveSolutionTests, invalidPrimitivesTests, tooManySolutionsTests, duplicateDilutionIDTest, conflictingQuantitationStandardDilutionTests,
      missingQuantitationStandardTest, unusedQuenchParametersTest, unusedActivateParametersTest, unusedLoadParametersTest,
      enzymeLinkedDetectionTest, unusedStandardCurveTest, tooLargeQuantitationStandardDilutionsTest, tooSmallQuantitationStandardDilutionsTest,
      tooSmallQuantitationStandardTransfersTest, conflictingDelayOptionsTest, missingBLIBinningOptionsTest, solidObjectsTest, solidSampleTest,
      binningTooManySamplesTest, missingStandardTest, missingTestSolutionsTest,
      optionsFromWrongExperimentTypeTest, unusedBinningQuenchParametersTest, unusedPreMixOptionsTest, missingRequiredOptionsForDevelopmentTest,
      unusedDevelopmentTypeSpecificOptionTest,
      (*storage condition tests*)
      unusedTestLoadingSolutionsStorageConditionsTest, unusedTestInteractionSolutionsStorageConditionsTest,
      unusedQuantitationEnzymeSolutionStorageConditionTest, unusedQuantitationStandardStorageConditionTest,
      unusedStandardStorageConditionTest, unusedLoadSolutionStorageConditionTest, unusedBinningAntigenStorageConditionTest,
      badLengthTestLoadingSolutionsStorageConditionsTest, validSamplesInStorageConditionTests
    }
  ], _EmeraldTest];

  (* --- RESOLVED OPTIONS --- *)

  (* if the input was through ExpandedAssaySequencePrimitives we need to change the empty list to a Null *)
  patternSafeAssaySequencePrimitives = Module[{noNullsPrimitives},
    noNullsPrimitives = DeleteCases[Flatten[ToList[resolvedAssaySequencePrimitives]],Null];
    If[MatchQ[noNullsPrimitives, {}],
      Null,
      noNullsPrimitives
    ]
  ];

  resolvedOptions = ReplaceRule[Normal[fullBLIOptionsAssociation],
    Flatten[
      {

        (* --- DEFAULT OPTIONS --- *)

        (* general options *)
        Instrument -> instrument,
        ExperimentType -> experimentType,
        BioProbeType -> bioProbeType,
        NumberOfRepeats -> numberOfRepeats,
        PlateCover -> resolvedPlateCover,
        Temperature -> temperature,
        RecoupSample -> recoupSample,
        SaveAssayPlate -> saveAssayPlate,
        ProbeRackEquilibration -> probeRackEquilibration,
        DefaultBuffer -> defaultBuffer,
        ReuseSolution -> reuseSolution,
        Standard -> standard,

        (* general dilution options *)
        DilutionNumberOfMixes -> dilutionNumberOfMixes,
        DilutionMixRate -> dilutionMixRate,
        RegenerationType -> (regenerationType/.{{Null}-> Null,{None}-> None}),

        (* loading options *)
        LoadingType -> (loadingType/.{{Null}-> Null,{None}-> None}),
        LoadSolution -> loadSolution,
        LoadAbsoluteThreshold -> loadAbsoluteThreshold,
        LoadThresholdSlope -> loadThresholdSlope,
        LoadThresholdSlopeDuration -> loadThresholdSlopeDuration,
        ActivateSolution -> activateSolution,
        QuenchSolution -> quenchSolution,

        (* kinetics specific options *)
        KineticsReferenceType -> (kineticsReferenceType/.{{Null}-> Null}),
        MeasureAssociationAbsoluteThreshold -> measureAssociationAbsoluteThreshold,
        MeasureAssociationThresholdSlope -> measureAssociationThresholdSlope,
        MeasureAssociationThresholdSlopeDuration -> measureAssociationThresholdSlopeDuration,
        MeasureDissociationAbsoluteThreshold -> measureDissociationAbsoluteThreshold,
        MeasureDissociationThresholdSlope -> measureDissociationThresholdSlope,
        MeasureDissociationThresholdSlopeDuration -> measureDissociationThresholdSlopeDuration,

        (* quantitation specific options *)
        QuantitationParameters -> (ToList[quantitationParameters]/.{{Null}-> Null,{None}-> None}),
        AmplifiedDetectionSolution -> amplifiedDetectionSolution,
        QuantitationEnzymeSolution -> quantitationEnzymeSolution,
        QuantitationStandardSerialDilutions -> quantitationStandardSerialDilutions,
        LoadAntibodyAbsoluteThreshold -> loadAntibodyAbsoluteThreshold,
        LoadAntibodyThresholdSlope -> loadAntibodyThresholdSlope,
        LoadAntibodyThresholdSlopeDuration -> loadAntibodyThresholdSlopeDuration,

        (* epitope binning specific options *)
        BinningQuenchSolution -> binningQuenchSolution,
        BinningAntigen -> binningAntigen,
        LoadAntigenAbsoluteThreshold -> loadAntigenAbsoluteThreshold,
        LoadAntigenThresholdSlope -> loadAntigenThresholdSlope,
        LoadAntigenThresholdSlopeDuration -> loadAntigenThresholdSlopeDuration,
        CompetitionAbsoluteThreshold -> competitionAbsoluteThreshold,
        CompetitionThresholdSlope -> competitionThresholdSlope,
        CompetitionThresholdSlopeDuration -> competitionThresholdSlopeDuration,


        (* AssayDevelopment specific options *)
        DevelopmentReferenceWell -> (developmentReferenceWell/.{{Null}-> Null}),
        DevelopmentAssociationAbsoluteThreshold -> developmentAssociationAbsoluteThreshold,
        DevelopmentAssociationThresholdSlope -> developmentAssociationThresholdSlope,
        DevelopmentAssociationThresholdSlopeDuration -> developmentAssociationThresholdSlopeDuration,
        DevelopmentDissociationAbsoluteThreshold -> developmentDissociationAbsoluteThreshold,
        DevelopmentDissociationThresholdSlope -> developmentDissociationThresholdSlope,
        DevelopmentDissociationThresholdSlopeDuration -> developmentDissociationThresholdSlopeDuration,
        DetectionLimitFixedDilutions -> detectionLimitFixedDilutions,
        TestInteractionSolutions -> testInteractionSolutions,
        TestBufferSolutions -> testBufferSolutions,
        TestRegenerationSolutions -> testRegenerationSolutions,
        TestLoadingSolutions -> testLoadingSolutions,
        TestActivationSolutions -> testActivationSolutions,

        (* --- AUTOMATIC OPTIONS --- *)
        (* General options *)
        AcquisitionRate -> acquisitionRate,
        ProbeRackEquilibrationTime -> probeRackEquilibrationTime,
        ProbeRackEquilibrationBuffer -> probeRackEquilibrationBuffer,
        StartDelay -> startDelay,
        StartDelayShake -> startDelayShake,
        Equilibrate -> equilibrate,
        EquilibrateTime -> equilibrateTime,
        EquilibrateBuffer -> equilibrateBuffer,
        EquilibrateShakeRate -> equilibrateShakeRate,
        Blank -> blank,
        DilutionMixVolume -> dilutionMixVolume,

        (* Regeneration options *)
        RegenerationSolution -> regenerationSolution,
        RegenerationCycles -> regenerationCycles,
        RegenerationTime -> regenerationTime,
        RegenerationShakeRate -> regenerationShakeRate,
        NeutralizationSolution -> neutralizationSolution,
        NeutralizationTime -> neutralizationTime,
        NeutralizationShakeRate -> neutralizationShakeRate,
        WashSolution -> washSolution,
        WashTime -> washTime,
        WashShakeRate -> washShakeRate,

        (* Load options*)
        LoadTime -> loadTime,
        LoadThresholdCriterion -> loadThresholdCriterion,
        LoadShakeRate -> loadShakeRate,
        ActivateTime -> activateTime,
        ActivateShakeRate -> activateShakeRate,
        QuenchTime -> quenchTime,
        QuenchShakeRate -> quenchShakeRate,

        (* Kinetics options *)
        resolvedKineticsParameters,
        KineticsSampleFixedDilutions -> kineticsSampleFixedDilutions,
        KineticsSampleDiluent -> kineticsSampleDiluent,
        KineticsSampleSerialDilutions -> kineticsSampleSerialDilutions,

        (* Quantitation options *)
        resolvedQuantitationParameters,

        (* EpitopeBinning options *)
        resolvedEpitopeBinningParameters,
        PreMixSolutions -> preMixSolutions,

        (* AssayDevelopment options *)
        resolvedAssayDevelopmentParameters,
        DetectionLimitSerialDilutions -> detectionLimitSerialDilutions,
        DetectionLimitDiluent -> detectionLimitDiluent,

        (* Storage Conditions *)
        QuantitationStandardStorageCondition -> resolvedQuantitationStandardStorageCondition,

        (* --- PRIMITIVES --- *)
        AssaySequencePrimitives -> patternSafeAssaySequencePrimitives,
        ExpandedAssaySequencePrimitives -> resolvedExpandedAssaySequencePrimitives, (*note that this does not have repeats - that is intentional.*)
        RepeatedSequence -> resolvedRepeatedSequence,

        (* --- pass through and other resolved options ---- *)
        resolvedSamplePrepOptions,
        resolvedAliquotOptions,
        resolvedPostProcessingOptions
      }
    ]
  ]/.x:LinkP[]:>x[Object];
  (*TODO: if this link replace turns out to be a problem then remove it. I do not think that we need any links*)
  (* Return our resolved options and/or tests. *)

  outputSpecification/.{
    Result -> resolvedOptions,
    Tests -> bliTests
  }
];



(* ::Subsection::Closed:: *)
(* ExperimentBLIOptions *)

DefineOptions[ExperimentBioLayerInterferometryOptions,
  Options:>{
    {
      OptionName->OutputFormat,
      Default->Table,
      AllowNull->False,
      Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
      Description->"Indicates whether the function returns a table or a list of the options."
    }
  },
  SharedOptions :> {ExperimentBioLayerInterferometry}
];

ExperimentBioLayerInterferometryOptions[myInput:ListableP[ObjectP[{Object[Sample],Object[Container], Model[Sample]}]|_String],myOptions:OptionsPattern[ExperimentBioLayerInterferometryOptions]]:=Module[
  {listedOptions,preparedOptions,resolvedOptions},

  listedOptions=ToList[myOptions];

  (* Send in the correct Output option and remove OutputFormat option *)
  preparedOptions=Normal[KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}]];

  resolvedOptions=ExperimentBioLayerInterferometry[myInput,preparedOptions];

  (* Return the option as a list or table *)
  If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
    LegacySLL`Private`optionsToTable[resolvedOptions,ExperimentBioLayerInterferometry],
    resolvedOptions
  ]
];

(* ::Subsubsection::Closed:: *)
(*ExperimentBioLayerInterferometryPreview*)

(* ====================== *)
(* == PREVIEW FUNCTION == *)
(* ====================== *)

DefineOptions[ExperimentBioLayerInterferometryPreview,
  SharedOptions :> {ExperimentBioLayerInterferometry}
];

(* preview function *)
ExperimentBioLayerInterferometryPreview[myInput:ListableP[ObjectP[{Object[Sample],Object[Container],Model[Sample]}]|_String],myOptions:OptionsPattern[ValidExperimentBioLayerInterferometryQ]]:=
  Module[
    {listedOptions, noOutputOptions},

    (* get the options as a list *)
    listedOptions = ToList[myOptions];

    (* remove the Output option before passing to the core function because it doesn't make sense here *)
    noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _]];

    (* return only the preview for ExperimentBioLayerInterferometry *)
    ExperimentBioLayerInterferometry[myInput, Append[noOutputOptions, Output -> Preview]]
  ];




(* ::Subsubsection::Closed:: *)
(*ValidExperimentBioLayerInterferometryQ*)

DefineOptions[ValidExperimentBioLayerInterferometryQ,
  Options:>{
    VerboseOption,
    OutputFormatOption
  },
  SharedOptions :> {ExperimentBioLayerInterferometry}
];

ValidExperimentBioLayerInterferometryQ[myInput:ListableP[ObjectP[{Object[Sample],Object[Container],Model[Sample]}]|_String],myOptions:OptionsPattern[ValidExperimentBioLayerInterferometryQ]]:=Module[
  {listedInput,listedOptions,preparedOptions,functionTests,initialTestDescription,allTests,safeOps,verbose,outputFormat,result},

  listedInput=ToList[myInput];
  listedOptions=ToList[myOptions];

  (* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
  preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Tests],{Verbose,OutputFormat}];

  (* Call the function to get a list of tests *)
  functionTests=ExperimentBioLayerInterferometry[myInput,preparedOptions];

  initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

  allTests=If[MatchQ[functionTests,$Failed],
    {Test[initialTestDescription,False,True]},
    Module[{initialTest,validObjectBooleans,voqWarnings,testResults},
      initialTest=Test[initialTestDescription,True,True];

      (* Create warnings for invalid objects *)
      validObjectBooleans=ValidObjectQ[DeleteCases[listedInput,_String],OutputFormat->Boolean];
      voqWarnings=MapThread[
        Warning[ToString[#1,InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
          #2,
          True
        ]&,
        {DeleteCases[listedInput,_String],validObjectBooleans}
      ];

      (* Get all the tests/warnings *)
      Join[{initialTest},functionTests,voqWarnings]
    ]
  ];

  (* Lookup test running options *)
  safeOps=SafeOptions[ValidExperimentBioLayerInterferometryQ,Normal@KeyTake[listedOptions,{Verbose,OutputFormat}]];
  {verbose,outputFormat}=Lookup[safeOps,{Verbose,OutputFormat}];

  (* Run the tests as requested and return just the summary not the association if OutputFormat->TestSummary*)
  Lookup[
    RunUnitTest[
      <|"ExperimentBioLayerInterferometry"->allTests|>,
      Verbose->verbose,
      OutputFormat->outputFormat
    ],
    "ExperimentBioLayerInterferometry"
  ]
];


(* ::Subsubsection::Closed:: *)
(*BioLayerInterferometryResourcePackets*)

DefineOptions[bioLayerInterferometryResourcePackets,
  Options:>{
    CacheOption,
    SimulationOption,
    OutputOption
  }
];

bioLayerInterferometryResourcePackets[mySamples:{ObjectP[Object[Sample]]..}, myUnresolvedOptions:{___Rule}, myResolvedOptions:{___Rule},ops:OptionsPattern[]]:=Module[
  {
    expandedInputs, expandedResolvedOptions,resolvedOptionsNoHidden,outputSpecification,output,gatherTests,messages,inheritedCache,simulation,containerPackets,numRepeats,samplePacketFields,
    samplePackets,expandedSamplesWithNumRepeats,minimumVolume,expandedAliquotVolume,sampleVolumes,pairedSamplesInAndVolumes,sampleVolumeRules,
    sampleResourceReplaceRules,mergedPairedSamplesInAndVolumes, samplesInResources,instrument,instrumentTime,instrumentResource,protocolPacket,sharedFieldPacket,finalizedPacket,
    allResourceBlobs,fulfillable, frqTests,testsRule,resultRule, allSolutionVolumeRules, uniqueResources, uniqueObjects,uniqueObjectResourceReplaceRules, safeNumberOfRepeats,
    (* mostly pass-through options *)
    experimentType, bioProbeType, acquisitionRate, temperature, probeRackEquilibration,
    probeRackEquilibrationTime, probeRackEquilibrationBuffer, startDelay, startDelayShake, developmentType, quantitationParameters,
    binningType, binningAntigen, repeatedSequence, expandedAssaySequencePrimitives, recoupSample, saveAssayPlate, instrumentObject, dilutionNumberOfMixes,
    dilutionMixRate, dilutionMixVolume,
    (* figuring out dilutions variables *)
    kineticsSampleFixedDilutions, kineticsSampleSerialDilutions, quantitationStandardSerialDilutions, quantitationStandardFixedDilutions, detectionLimitFixedDilutions,
    detectionLimitSerialDilutions, preMixSolutions, kineticsSampleDiluent, detectionLimitDiluent, quantitationStandardDiluent, preMixDiluent, quantitationStandard, probeRackEquilibrationBufferVolume,
    safeKineticsSampleFixedDilutions, safeKineticsSampleSerialDilutions, safeQuantitationStandardSerialDilutions,
    safeQuantitationStandardFixedDilutions, safeDetectionLimitFixedDilutions, safeDetectionLimitSerialDilutions, safePreMixSolutions,
    (*rules related to dilutions*)
    probeRackEquilibrationBufferVolumeRules,preMixSolutionsVolumeRules, detectionLimitFixedDilutionsVolumeRules, detectionLimitSerialDilutionsVolumeRules, kineticsDilutionsSerialDilutionsVolumeRules,
    kineticsDilutionsFixedDilutionsVolumeRules, quantitationStandardSerialDilutionsVolumeRules, quantitationStandardFixedDilutionsVolumeRules, allDilutionVolumeRules, safeDilutionVolumeRules,
    liquidHandlerContainers, liquidHandlerContainerDownload, liquidHandlerContainerMaxVolumes, nonSampleSolutionVolumeRules,
    detectionLimitDiluentResource,kineticsSampleDiluentResource,quantitationStandardDiluentResource,antigenSolutionResource, preMixDiluentResource,safePreMixResources,probeRackEquilibrationBufferResource,
    quantitationStandardResource,
    (* variables related to solutions *)
    plateLayout, primitiveMasterAssociation, solutionManifest, resourcesManifest, objectsManifest, linkedResourcesManifest,
    existingPlateSolutions, plannedDilutions,
    existingPlateSolutionsVolume, existingPlateSolutionsVolumeRule,
    sampleVolumesFromPlate, sampleSolutionVolumeRules, uniqueSamples,sampleResourceRules, uniqueSampleResourceReplaceRules,
    (*other resources*)
    assayPlateResource, probeRackPlateResource, probeRackResource, probeCount, plateCoverResource,
    assayTime, setUpTime, tearDownTime, allStepTimes, numberOfRepeats, safeStartDelay, initialSequence, assayOverview, probeCountPerRepeat, repeatedPrimitives,
    assayNumberPerRepeat, rawAssayOverview, repeatAssayOverview, finalizedAssayOverview, dilutionPrepTime, safeLoadSolutionResource,
    (* dilutions plates *)
    developmentSampleFixedDilutionsPlate, developmentSampleSerialDilutionsPlate, quantitationStandardSerialDilutionsPlate,
    quantitationStandardFixedDilutionsPlate, kineticsSampleSerialDilutionsPlate, kineticsSampleFixedDilutionsPlate,
    liquidHandlerContainerRecommendedFillVolumes, liquidHandlerContainerNumberOfWells, liquidHandlerContainerPositions,kineticsFixedDilutionsForPlateResolution,
    kineticsSerialDilutionsForPlateResolution,
    detectionLimitFixedDilutionsForPlateResolution,
    detectionLimitSerialDilutionsForPlateResolution,
    (* storage condition related option variables *)
    loadSolution, testLoadingSolutions, testInteractionSolutions, binningAntigenStorageCondition, loadSolutionStorageCondition,
    testLoadingSolutionsStorageConditions, testInteractionSolutionsStorageConditions, standard,
    (* storage condition field variables *)
    quantitationEnzyme, quantitationEnzymeSolutionStorageCondition, antigenSolutionStorageCondition, standardStorageCondition,
    quantitationStandardStorageCondition, loadSolutions, loadSolutionsStorageConditions,
    (* variables related to recoup sample *)
    labeledPlateLayout, wellsToRecover, defaultBuffer
  },


  (* expand the resolved options if they weren't expanded already *)
  {expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentBioLayerInterferometry, {mySamples}, myResolvedOptions];

  (* Get the resolved collapsed index matching options that don't include hidden options *)
  resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
    ExperimentBioLayerInterferometry,
    RemoveHiddenOptions[ExperimentBioLayerInterferometry,myResolvedOptions],
    Ignore->myUnresolvedOptions,
    Messages->False
  ];

  (* Determine the requested return value from the function *)
  outputSpecification=OptionDefault[OptionValue[Output]];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests = MemberQ[output,Tests];
  messages = Not[gatherTests];

  (* Get the inherited cache *)
  inheritedCache = Lookup[ToList[ops],Cache];
  simulation = Lookup[ToList[ops], Simulation];
  samplePacketFields = Packet[Object,Composition,Analytes,Sequence@@SamplePreparationCacheFields[Object[Sample]]];

  (* --------------------------- *)
  (* --- IDENTIFY CONTAINERS --- *)
  (* --------------------------- *)

  (* Get all containers which can fit on the liquid handler - many of our resources are in one of these containers *)
  (* In case we need to prepare the resource add 0.5mL tube in 2 mL skirt to the beginning of the list (Engine uses the first requested container if it has to transfer or make a stock solution) *)
  liquidHandlerContainers =bliLiquidHandlerContainers[];

  (* flatten and extract the relevant values from the packets *)
  {liquidHandlerContainerMaxVolumes,liquidHandlerContainerPositions} = Transpose[Download[liquidHandlerContainers, {MaxVolume, Positions}, Simulation -> simulation]];
  liquidHandlerContainerNumberOfWells = Length/@liquidHandlerContainerPositions;

  (* Look up all of the values we are going to need, many of which are passed directly to the protocol object *)
  {
    defaultBuffer,
    saveAssayPlate,
    experimentType,
    bioProbeType,
    acquisitionRate,
    temperature,
    probeRackEquilibration,
    probeRackEquilibrationTime,
    probeRackEquilibrationBuffer,
    startDelay,
    startDelayShake,
    developmentType,
    quantitationParameters,
    binningType,
    binningAntigen,
    repeatedSequence,
    recoupSample,
    numberOfRepeats,
    expandedAssaySequencePrimitives,
    dilutionNumberOfMixes,
    dilutionMixRate,
    dilutionMixVolume
  } = Lookup[myResolvedOptions, {
    DefaultBuffer,
    SaveAssayPlate,
    ExperimentType,
    BioProbeType,
    AcquisitionRate,
    Temperature,
    ProbeRackEquilibration,
    ProbeRackEquilibrationTime,
    ProbeRackEquilibrationBuffer,
    StartDelay,
    StartDelayShake,
    DevelopmentType,
    QuantitationParameters,
    BinningType,
    BinningAntigen,
    RepeatedSequence,
    RecoupSample,
    NumberOfRepeats,
    ExpandedAssaySequencePrimitives,
    DilutionNumberOfMixes,
    DilutionMixRate,
    DilutionMixVolume
  }];


  safeNumberOfRepeats = If[MatchQ[numberOfRepeats, Except[_Integer]],
    1,
    numberOfRepeats
  ];

  (* ------------------------------- *)
  (* -- STORAGE CONDITION UPDATES -- *)
  (* ------------------------------- *)


  (* look up the storage condition options to pass through to the protocol *)
  {
    standardStorageCondition,
    quantitationStandardStorageCondition,
    quantitationEnzymeSolutionStorageCondition,
    binningAntigenStorageCondition,
    loadSolutionStorageCondition,
    testLoadingSolutionsStorageConditions,
    testInteractionSolutionsStorageConditions
  } = Lookup[myResolvedOptions,
    {
      StandardStorageCondition,
      QuantitationStandardStorageCondition,
      QuantitationEnzymeSolutionStorageCondition,
      BinningAntigenStorageCondition,
      LoadSolutionStorageCondition,
      TestLoadingSolutionsStorageConditions,
      TestInteractionSolutionsStorageConditions
    }
  ];

  (* look up any other solutions we need to pass through so that they can have their storage condition updated *)
  {
    standard,
    quantitationStandard,
    quantitationEnzyme,
    loadSolution,
    testLoadingSolutions,
    testInteractionSolutions
  } = Lookup[myResolvedOptions,
    {
      Standard,
      QuantitationStandard,
      QuantitationEnzymeSolution,
      LoadSolution,
      TestLoadingSolutions,
      TestInteractionSolutions
    }
  ];


  (* figure out what should go in the protocol since some optiosn get condensed here *)
  (* also accoutn for the slight differences in namespace *)
  antigenSolutionStorageCondition = binningAntigenStorageCondition;

  (* the load solution in the protocol will be which ever of these fields is informed *)
  loadSolutions = Flatten[Cases[{loadSolution, testLoadingSolutions, testInteractionSolutions}, Except[(Null|{Null..}|{})]]];

  (* determine which storage condition options to look at based on the population of the solution options *)
  loadSolutionsStorageConditions = Flatten[
    PickList[
      {
        loadSolutionStorageCondition, testLoadingSolutionsStorageConditions, testInteractionSolutionsStorageConditions
      },
      {
        loadSolution, testLoadingSolutions, testInteractionSolutions
      },
      Except[(Null|{Null..}|{})]
    ]
  ];

  (* ------------------------------------------------------- *)
  (* --- Make all the resources needed in the experiment --- *)
  (* ------------------------------------------------------- *)


  (* Figure out what the resources actually are by resolving the sample plate *)
  (* the helper function returns the master association, which are grouped by assay, have keys indicating their assay and step  position, probe, and column and primitive of course *)
  (* the plateLayout contains all of the solutions grouped by column *)
  {primitiveMasterAssociation, plateLayout} = resolveProtocolReadyPrimitives[Lookup[myResolvedOptions, ExpandedAssaySequencePrimitives], ToList[Lookup[myResolvedOptions, ReuseSolution]], defaultBuffer];

  (* look up the probe numbers from the master association, and multiply by repeats *)
  probeCountPerRepeat =Max[Lookup[Flatten[primitiveMasterAssociation], ProbeNumber]];

  (* determine the probe count - if there is regeneration then probeCount = probeCountPerRepeat, other wise  *)
  probeCount = If[MemberQ[Head/@Flatten[expandedAssaySequencePrimitives], Regenerate],
    probeCountPerRepeat,
    probeCountPerRepeat*safeNumberOfRepeats
  ];

  (*find out how many assays are in one repeat*)
  assayNumberPerRepeat = Max[Lookup[Flatten[primitiveMasterAssociation], AssayNumber]];

  (* the flattened assay overview is for a single repeat. The repeats are done by repeating the entire assay.  *)
  rawAssayOverview = Values/@Flatten[primitiveMasterAssociation];

  (*expand by the number of repeats*)
  repeatAssayOverview = ConstantArray[rawAssayOverview, safeNumberOfRepeats];

  (*each repeat is in a list. add probe count per repeat and AssayNumber per repeat too *)
  finalizedAssayOverview = MapThread[
    Function[{overview, index},
      (* add the appropriate assay and probe number, and grab the primitive head *)
      If[MemberQ[Head/@Flatten[expandedAssaySequencePrimitives], Regenerate],
        (*if there is regeneration, make all of the probe numbers the same #[[4]] shoudl always be 1 in this case*)
        Map[{(First[#]+(index-1)*assayNumberPerRepeat), #[[2]], #[[3]], #[[4]], Head[Last[#]]}&, overview],

        (* if there is no regeneration, each repeat needs a new set of probes *)
        Map[{(First[#]+(index-1)*assayNumberPerRepeat), #[[2]], #[[3]], (#[[4]]+(index-1)*probeCountPerRepeat), Head[Last[#]]}&, overview]
      ]
    ],
    {repeatAssayOverview, Range[safeNumberOfRepeats]}];

  (* look up the initial sequence *)
  initialSequence = Head/@First[expandedAssaySequencePrimitives];


  (* get a flat list of solutions, throwing out any Nulls *)
  solutionManifest = DeleteCases[Flatten[plateLayout],Null];

  (* for resource picking, we want to consolidate the solutions. First we need to figure out how much of each is needed*)
  (* if the solutions are objects, then they can be figured out directly *)
  (* if the solutions are string, then they are dilutison/mixtures that need to be figured out based on the thing they match to *)
  existingPlateSolutions = Select[solutionManifest, MatchQ[#, ObjectP[]]&];
  plannedDilutions = Select[solutionManifest, MatchQ[#, _String]&];

  (* assign each solution to 250 Microliter. The dynamic range is between 210-250 uL *)
  (*also note that since we cleaned up bad input already and set volume ourselves, there is no need to select cases here*)
  existingPlateSolutionsVolumeRule = Join[{#->250 Microliter}&/@existingPlateSolutions];


  (* --- RESOLVE THE DILUTIONS --- *)

  (* look up the dilutions and tag them so that they can be read by DilutionsToNamesHelper. keep the index matched ones index matched since they will dictate the amonut of sample needed *)
  (* we will put them all in the same format so it is easy to figure out how much solution is needed: <|sample->Volume, sample->volume|>  *)
  (* we can throw out all of the sample->volumes that have non object names and should be good to go *)

  {
    kineticsSampleFixedDilutions, kineticsSampleSerialDilutions, quantitationStandardSerialDilutions,
    quantitationStandardFixedDilutions, detectionLimitFixedDilutions, detectionLimitSerialDilutions, preMixSolutions
  } = Lookup[myResolvedOptions,{KineticsSampleFixedDilutions, KineticsSampleSerialDilutions, QuantitationStandardSerialDilutions,
    QuantitationStandardFixedDilutions, DetectionLimitFixedDilutions, DetectionLimitSerialDilutions, PreMixSolutions}];


  (* we need to standardze the format for the protocol object using the helper function for all dilutions except PreMixSolutions *)
  (*the standard format for the protocol is {transfer/sample amount, diluent amount, name} *)
  safeKineticsSampleFixedDilutions = Map[standardizedBLIDilutions[#, Fixed]&,kineticsSampleFixedDilutions];
  safeKineticsSampleSerialDilutions = Map[standardizedBLIDilutions[#, Serial]&,kineticsSampleSerialDilutions];
  safeDetectionLimitFixedDilutions = Map[standardizedBLIDilutions[#, Fixed]&,  detectionLimitFixedDilutions];
  safeDetectionLimitSerialDilutions = Map[standardizedBLIDilutions[#, Serial]&, detectionLimitSerialDilutions];

  (* the quantitation positon are not index matched and are fine at level 1 *)
  safeQuantitationStandardSerialDilutions = standardizedBLIDilutions[quantitationStandardSerialDilutions, Serial];
  safeQuantitationStandardFixedDilutions = standardizedBLIDilutions[quantitationStandardFixedDilutions, Fixed];

  safePreMixSolutions = preMixSolutions;

  (* also look up the solutions that we may have used in the dilutions *)
  {
    kineticsSampleDiluent, detectionLimitDiluent, quantitationStandardDiluent, preMixDiluent, quantitationStandard, binningAntigen
  } = Lookup[myResolvedOptions,
    {KineticsSampleDiluent, DetectionLimitDiluent, QuantitationStandardDiluent, PreMixDiluent, QuantitationStandard, BinningAntigen}];

  (* quantitation standard dilutions Rules*)
  quantitationStandardFixedDilutionsVolumeRules = dilutionsResolver[quantitationStandardFixedDilutions, Fixed, quantitationStandard, quantitationStandardDiluent];
  quantitationStandardSerialDilutionsVolumeRules = dilutionsResolver[quantitationStandardSerialDilutions, Serial, quantitationStandard, quantitationStandardDiluent];

  (* kinetics dilutions Rules *)
  kineticsDilutionsSerialDilutionsVolumeRules = MapThread[dilutionsResolver[#3, Serial, #1, #2]&, {Download[mySamples, Object], kineticsSampleDiluent, kineticsSampleSerialDilutions}];
  kineticsDilutionsFixedDilutionsVolumeRules =  MapThread[dilutionsResolver[#3, Fixed, #1, #2]&, {Download[mySamples, Object], kineticsSampleDiluent, kineticsSampleFixedDilutions}];

  (* assay development rules *)
  detectionLimitSerialDilutionsVolumeRules = MapThread[dilutionsResolver[#3, Serial, #1, #2]&, {Download[mySamples, Object], detectionLimitDiluent, detectionLimitSerialDilutions}];
  detectionLimitFixedDilutionsVolumeRules =  MapThread[dilutionsResolver[#3, Fixed, #1, #2]&, {Download[mySamples, Object], detectionLimitDiluent, detectionLimitFixedDilutions}];

  (* premix rules - there is only one format for*)
  preMixSolutionsVolumeRules = MapThread[
    If[MatchQ[#2, Except[Null]],
      {#1 -> #2[[1]], binningAntigen -> #2[[2]], preMixDiluent -> #2[[3]], Name -> #2[[4]]},
      {}
    ]&,
    {Download[mySamples, Object], safePreMixSolutions}];

  (* probe rack equilibration buffer volume is defined by probeCount and also if it is called for *)
  probeRackEquilibrationBufferVolume = If[probeRackEquilibration, probeCount*8*260*Microliter, 0*Microliter];

  (* probe rack equilibration buffer rules *)
  probeRackEquilibrationBufferVolumeRules = {probeRackEquilibrationBuffer-> probeRackEquilibrationBufferVolume};

  (* Note: we need to request all of the named dilution resources because it is possible that they are intermediates, even if they don't appear in the assayPlate. The compiler is ok with this. *)
  (* combine the dilutions together, remove Null, and get the amount of each sample needed *)
  allDilutionVolumeRules = Flatten[Join[quantitationStandardFixedDilutionsVolumeRules, quantitationStandardSerialDilutionsVolumeRules, kineticsDilutionsSerialDilutionsVolumeRules, kineticsDilutionsFixedDilutionsVolumeRules,
    detectionLimitSerialDilutionsVolumeRules, detectionLimitFixedDilutionsVolumeRules, preMixSolutionsVolumeRules,probeRackEquilibrationBufferVolumeRules]];

  (* clean up the list of rules by removing anything invalid and the Names *)
  safeDilutionVolumeRules=Cases[allDilutionVolumeRules, Except[Alternatives[ _-> 0*Microliter, _-> Null, Null -> _, Name -> _]]];

  (* merge the lists and total the solutions. both of the lists are already cleaned up so they do not need more treatement *)
  allSolutionVolumeRules = Merge[Flatten[{safeDilutionVolumeRules, existingPlateSolutionsVolumeRule}], Total];


  (* ------------------------------------ *)
  (* --- MAKE RESOURCES FOR SOLUTIONS --- *)
  (* ------------------------------------ *)

  (*pull the sample values out*)
  nonSampleSolutionVolumeRules = KeyDrop[Normal[allSolutionVolumeRules]/.(x:ObjectP[]:>Download[x, Object]), Download[mySamples, Object]];

  (*grab the samples*)
  sampleSolutionVolumeRules = KeyTake[Normal[allSolutionVolumeRules]/.(x:ObjectP[]:>Download[x, Object]), Download[mySamples, Object]];

  (* - Use this association to make Resources for each unique Object or Model Key that is not the samples - *)
  uniqueResources=KeyValueMap[
    Module[{amount,containers},
      amount=#2;
      containers=PickList[liquidHandlerContainers,liquidHandlerContainerMaxVolumes,GreaterEqualP[amount*1.2]];
      Resource[Sample->#1,Amount->SafeRound[amount*1.2, 10^0 Microliter],Container->containers,Name->ToString[#1]]
    ]&,
    nonSampleSolutionVolumeRules
  ];


  (* -- Define a list of replace rules for the unique Model and Objects with the corresponding Resources --*)
  (* - Find a list of the unique Object/Model Keys - *)
  uniqueObjects = Keys[nonSampleSolutionVolumeRules];

  (* - Make a list of replace rules, replacing unique objects with their respective Resources - *)
  uniqueObjectResourceReplaceRules=MapThread[
    (#1->#2)&,
    {uniqueObjects,uniqueResources}
  ];


  (* -- Generate resources for the SamplesIn -- *)
  (* pull out the AliquotAmount option *)
  expandedAliquotVolume = Lookup[myResolvedOptions, AliquotAmount];

  (* pull the minimum volumes out of the general solvent rules. Note that the results will be index matched to mySamples *)
  sampleVolumesFromPlate = Lookup[sampleSolutionVolumeRules, #, Null]&/@Download[mySamples, Object];

  (* Get the sample volume; if we're aliquoting, use that amount; otherwise use the minimum volume the experiment will require *)
  (* Template Note: Only include a volume if the experiment is actually consuming some amount *)
  sampleVolumes = MapThread[
    If[VolumeQ[#1],
      #1,
      #2*1.2
    ]&,
    {expandedAliquotVolume, sampleVolumesFromPlate}
  ];

  (* Pair the SamplesIn and their Volumes *)
  pairedSamplesInAndVolumes = MapThread[
    #1 -> #2&,
    {Download[mySamples, Object], sampleVolumes}
  ];


  (* merge the samples in and volumes to account for duplicate samples in *)
  mergedPairedSamplesInAndVolumes = DeleteDuplicates[pairedSamplesInAndVolumes];

  (* Make replace rules for the samples and its resources; doing it this way because we only want to make one resource per sample including in repeats *)
  sampleResourceReplaceRules = Map[
    Function[{rule},
      If[VolumeQ[Values[rule]],
        Keys[rule] -> Resource[Sample -> Keys[rule], Name -> ToString[Unique[]], Amount -> SafeRound[Values[rule], 10^0 Microliter]],
        Keys[rule] -> Resource[Sample -> Keys[rule], Name -> ToString[Unique[]]]
      ]
    ],
    mergedPairedSamplesInAndVolumes
  ];

  (* pull the resources out to use in the protocol object *)
  samplesInResources = Download[mySamples, Object]/.sampleResourceReplaceRules;

  (* EXTRACT THE RESOURCES AND CORRESPONDING OBJECTS *)
  (* the samples are not included here because we are resource pickign them form SamplesIn, and mapping to OriginalSamplesIn*)
  (* split the objects from their resources, keeping them index matched *)

  objectsManifest = Keys[Flatten[{uniqueObjectResourceReplaceRules}]];
  resourcesManifest = Values[Flatten[{uniqueObjectResourceReplaceRules}]];
  linkedResourcesManifest = Link[#]&/@resourcesManifest;

  (* --- UPDATE PRIMITIVES --- *)
  (*apply the repeats to the primitives*)
  repeatedPrimitives = ConstantArray[Flatten[expandedAssaySequencePrimitives], safeNumberOfRepeats];

  (* ----------------------------------- *)
  (* CREATE RESOURCES FROM OBJECTS/MODEL *)
  (* ----------------------------------- *)

  (* - For the options that are single objects, Map over replacing the option with the replace rules to get the corresponding resources - *)

  (* note that only the dilution solutions need to be defined here, since all other sit inside the primitives. *)
  {
    detectionLimitDiluentResource,
    kineticsSampleDiluentResource,
    quantitationStandardDiluentResource,
    quantitationStandardResource,
    antigenSolutionResource,
    preMixDiluentResource,
    safePreMixResources,
    probeRackEquilibrationBufferResource,
    safeLoadSolutionResource
  } =
    {
      detectionLimitDiluent,
      kineticsSampleDiluent,
      quantitationStandardDiluent,
      quantitationStandard,
      binningAntigen,
      preMixDiluent,
      safePreMixSolutions,
      probeRackEquilibrationBuffer,
      loadSolution
    }/.uniqueObjectResourceReplaceRules;

  (* -- Make resources for other things needed for the experiment -- *)

  (* grab compatible plates, which have 96 wells, black well and plate, well volume of Range[], dimensions of Range[], and flangeheight of Range[], NumberOfWells *)
  (* currently this should only return Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"] *)
  assayPlateResource = Module[{allPlates, possibleContainers, allPlatePackets, possiblePackets},
    (* pull out all the plates *)
    allPlates = Cases[liquidHandlerContainers, ObjectP[Model[Container, Plate]]];

    (* make packets to select the right plate from *)
    allPlatePackets = Download[allPlates, Packet[WellColor, PlateColor, NumberOfWells, FlangeHeight, RecommendedFillVolume, Columns, Rows, Dimensions], Simulation -> simulation];

    (* find any plate models that will have the right dimensions and material properties (must be black, this is an optical method) *)
    possiblePackets = Select[
      allPlatePackets,
      KeyValuePattern[{
        WellColor -> OpaqueBlack,
        PlateColor -> OpaqueBlack,
        NumberOfWells -> 96,
        FlangeHeight -> RangeP[2.4 Millimeter, 2.6 Millimeter],
        RecommendedFillVolume -> RangeP[350 Microliter, 400 Microliter],
        Columns -> 12,
        Rows -> 8,
        Dimensions -> {RangeP[0.1270 Meter, 0.1280 Meter],RangeP[0.0854 Meter, 0.855 Meter],LessP[0.015 Meter]}
      }]
    ];

    (* lookup the objects from the selected packets *)
    possibleContainers = Lookup[possiblePackets, Object, {}];

    (* if for some reason we dindt find the plate, use this default *)
    If[MatchQ[possibleContainers, {}],
      Resource[Sample -> Model[Container, Plate, "id:AEqRl9KmGPWa"]],
      Resource[Sample -> First[possibleContainers]]
    ]
  ];

  probeRackPlateResource = assayPlateResource;

  (* probe rack resource is an entire rack that contains enough probes of the given type for the assay *)
  probeRackResource = Resource[
    Sample -> bioProbeType, Amount -> probeCount*8, UpdateCount -> False
  ];

  (* --- PLATE COVER RESOURCE --- *)
  plateCoverResource = If[Lookup[myResolvedOptions, PlateCover],
    Resource[Sample -> Model[Part, BLIPlateCover, "Octet plate cover, 96 well"]]
  ];


  (* --------------------------------- *)
  (* --- DILUTION PLATES RESOURCES --- *)
  (* --------------------------------- *)

  (* we need to check if there are requested dilutions which use a volume greater than the assay plate well volume. Ideally all dilutions are prepared on the assay plate. *)
  (* for development, kinetics and epitope binning, the dilutions are index matched, adn so we need to map over them unless they are Null *)

  (* ------------------------------- *)
  (* --- INDEX MATCHED DILUTIONS --- *)
  (* ------------------------------- *)

  (* make the dilutions into a usable form - right now they are either: {Null, Null, Null}, {{dilutions},{dilutions}}, or {Null, {dilutions}} *)
  (* clean up to either be {} or {dilutions} *)
  {
    kineticsFixedDilutionsForPlateResolution,
    kineticsSerialDilutionsForPlateResolution,
    detectionLimitFixedDilutionsForPlateResolution,
    detectionLimitSerialDilutionsForPlateResolution
  } = Map[
    Flatten[DeleteCases[#, Null], 1]&,
    {
      safeKineticsSampleFixedDilutions,
      safeKineticsSampleSerialDilutions,
      safeDetectionLimitFixedDilutions,
      safeDetectionLimitSerialDilutions
    }
  ];

  (*Note: the quantitation standard dilutions are already in the right form of: Null, or {dilutions}*)

  (* -------------------------------------- *)
  (* --- KINETICS SERIAL DILUTION PLATE --- *)
  (* -------------------------------------- *)

  (*use the helper function to determine if we need a dilutions plate, and what type it should be*)
  (* kinetics fixed dilutions *)
  kineticsSampleFixedDilutionsPlate = dilutionsPlateResolver[
    kineticsFixedDilutionsForPlateResolution,
    plateLayout,
    liquidHandlerContainers,
    liquidHandlerContainerNumberOfWells,
    liquidHandlerContainerMaxVolumes,
    Fixed];

  (*the same for kinetics serial dilutions*)
  kineticsSampleSerialDilutionsPlate = dilutionsPlateResolver[
    kineticsSerialDilutionsForPlateResolution,
    plateLayout,
    liquidHandlerContainers,
    liquidHandlerContainerNumberOfWells,
    liquidHandlerContainerMaxVolumes,
    Serial];

  (* ---------------------------------- *)
  (* --- DEVELOPMENT DILUTION PLATE --- *)
  (* ---------------------------------- *)

  (*the same for kinetics serial dilutions*)
  developmentSampleFixedDilutionsPlate = dilutionsPlateResolver[
    detectionLimitFixedDilutionsForPlateResolution,
    plateLayout,
    liquidHandlerContainers,
    liquidHandlerContainerNumberOfWells,
    liquidHandlerContainerMaxVolumes,
    Fixed];

  (*the same for kinetics serial dilutions*)
  developmentSampleSerialDilutionsPlate = dilutionsPlateResolver[
    detectionLimitSerialDilutionsForPlateResolution,
    plateLayout,
    liquidHandlerContainers,
    liquidHandlerContainerNumberOfWells,
    liquidHandlerContainerMaxVolumes,
    Serial];

  (* --------------------------------------- *)
  (* --- QUANTITATION STANDARD DILUTION  --- *)
  (* --------------------------------------- *)

  (* the quantitation dilutions are already either Null or a list of dilutions - use the helper function to determine if a plate is needed *)
  quantitationStandardFixedDilutionsPlate = dilutionsPlateResolver[
    safeQuantitationStandardFixedDilutions,
    plateLayout,
    liquidHandlerContainers,
    liquidHandlerContainerNumberOfWells,
    liquidHandlerContainerMaxVolumes,
    Fixed];

  (* the quantitation dilutions are already either Null or a list of dilutions - use the helper function to determine if a plate is needed*)
  quantitationStandardSerialDilutionsPlate = dilutionsPlateResolver[
    safeQuantitationStandardSerialDilutions,
    plateLayout,
    liquidHandlerContainers,
    liquidHandlerContainerNumberOfWells,
    liquidHandlerContainerMaxVolumes,
    Serial];

  (* ---------------------- *)
  (* -- Estimate SM time -- *)
  (* ---------------------- *)

  dilutionPrepTime = Module[{fixedDilutions, fixedDilutionTime, serialDilutions, serialDilutionTime},

    (* each dilution has a string name, so the number of strings = the numebr of dilutions *)
    fixedDilutions = Cases[Flatten[{safeDetectionLimitFixedDilutions, safeKineticsSampleFixedDilutions, safeQuantitationStandardFixedDilutions}], _String];

    (* fixed dilution time (est 15 Second per well) *)
    fixedDilutionTime = Length[fixedDilutions]*15 Second;

    (* each dilution has a string name, so the number of strings = the numebr of dilutions *)
    serialDilutions = Cases[Flatten[{safeDetectionLimitSerialDilutions, safeKineticsSampleSerialDilutions, safeQuantitationStandardSerialDilutions}], _String];

    (* the amount of time for serial dilutions (est 40 s per well) *)
    serialDilutionTime = Length[serialDilutions]*40 Second;

    (* total estimated time for dilutions, pad extra time for set up etc. *)
    Plus[fixedDilutionTime, serialDilutionTime, 10 Minute]
  ];

  (* ----------------------------------- *)
  (* -- Generate instrument resources -- *)
  (* ----------------------------------- *)

  (* Template Note: The time in instrument resources is used to charge customers for the instrument time so it's important that this estimate is accurate
    this will probably look like set-up time + time/sample + tear-down time *)
  instrument = Lookup[myResolvedOptions, Instrument];

  (* determine the maximum assay time *)
  allStepTimes = Map[Lookup[Association@@#, Time]&, Flatten[expandedAssaySequencePrimitives]];

  (* adjust for number of repeats *)
  assayTime = (Plus@@allStepTimes)*If[MatchQ[numberOfRepeats, _Integer], numberOfRepeats, 1];

  (*  set up involves putting the prepared plate onto the instrument deck, adding the probes, and proberackplate, and closign the door. Probably 5 minutes max on deck*)
  setUpTime = 5 Minute;

  (* tear down involves taking the plate/cover/racks down and disposiing of used tips *)
  tearDownTime = 5 Minute;

  (*make sure startDelay is a time *)
  safeStartDelay = If[!MatchQ[startDelay, TimeP], 0 Second, startDelay];

  (* add any start delay time, setup, teardown *)
  instrumentTime = Plus@@Flatten[{assayTime, safeStartDelay, setUpTime, tearDownTime}];

  (* create the instrument resource *)
  instrumentResource = Resource[Instrument -> instrument, Time -> instrumentTime, Name -> ToString[Unique[]]];

  (* ------------------------------------ *)
  (* --- GENERATE THE PROTOCOL PACKET --- *)
  (* ------------------------------------ *)

  protocolPacket=<|
    Type -> Object[Protocol,BioLayerInterferometry],
    Object -> CreateID[Object[Protocol,BioLayerInterferometry]],
    Replace[SamplesIn] -> (Link[#,Protocols]&/@samplesInResources),
    UnresolvedOptions -> myUnresolvedOptions,
    ResolvedOptions -> myResolvedOptions,
    NumberOfReplicates -> Lookup[myResolvedOptions, NumberOfReplicates,Null],
    Instrument -> Link[instrumentResource],

    (*fields specific to BLI protocol*)
    ExperimentType -> experimentType,
    BioProbes -> Link[probeRackResource],
    ProbeRackPlate -> Link[probeRackPlateResource],
    RepeatMeasurements -> Lookup[myResolvedOptions, NumberOfRepeats],
    AcquisitionRate -> acquisitionRate,
    PlateCover -> Link[plateCoverResource],
    Temperature -> temperature/.Ambient->$AmbientTemperature,
    ProbeRackEquilibrationTime -> probeRackEquilibrationTime,
    ProbeRackEquilibrationBuffer -> Link[probeRackEquilibrationBuffer],
    StartDelay -> startDelay,
    StartDelayShake -> startDelayShake,
    AssayPlate -> Link[assayPlateResource],

    InstrumentRunTime -> assayTime,
    ProbesUsed -> probeCount*8,

    DilutionMixRate -> dilutionMixRate,
    DilutionMixVolume -> dilutionMixVolume,
    DilutionNumberOfMixes -> dilutionNumberOfMixes,

    (*other solutions added so that their storage condition can be updated*)
    QuantitationEnzyme -> Link[quantitationEnzyme],
    QuantitationEnzymeStorageCondition -> quantitationEnzymeSolutionStorageCondition,
    AntigenSolutionStorageCondition -> antigenSolutionStorageCondition,
    StandardStorageCondition -> standardStorageCondition,
    QuantitationStandardStorageCondition -> quantitationStandardStorageCondition,
    Replace[LoadSolutions] -> (Link[#]&/@ToList[safeLoadSolutionResource]),
    Replace[LoadSolutionsStorageConditions] -> loadSolutionsStorageConditions,

    DevelopmentType -> developmentType,
    Replace[DevelopmentSampleDiluent] -> (Link[#]&/@detectionLimitDiluent),
    Replace[DevelopmentSampleFixedDilutions] -> safeDetectionLimitFixedDilutions,
    DevelopmentSampleFixedDilutionsPlate -> Link[developmentSampleFixedDilutionsPlate],
    Replace[DevelopmentSampleSerialDilutions] -> safeDetectionLimitSerialDilutions,
    DevelopmentSampleSerialDilutionsPlate -> Link[developmentSampleSerialDilutionsPlate],
    Replace[KineticsSampleDiluent] -> (Link[#]&/@kineticsSampleDiluent),
    Replace[KineticsSampleFixedDilutions] -> safeKineticsSampleFixedDilutions,
    KineticsSampleFixedDilutionsPlate -> Link[kineticsSampleFixedDilutionsPlate],
    Replace[KineticsSampleSerialDilutions] -> safeKineticsSampleSerialDilutions,
    KineticsSampleSerialDilutionsPlate -> Link[kineticsSampleSerialDilutionsPlate],
    Replace[QuantitationParameters] -> quantitationParameters,
    Replace[QuantitationStandard] -> Link[quantitationStandardResource],
    Replace[QuantitationStandardDiluent] -> Link[quantitationStandardDiluentResource],
    Replace[QuantitationStandardFixedDilutions] -> safeQuantitationStandardFixedDilutions,
    Replace[QuantitationStandardFixedDilutionsPlate] -> Link[quantitationStandardFixedDilutionsPlate],
    Replace[QuantitationStandardSerialDilutions] -> safeQuantitationStandardSerialDilutions,
    Replace[QuantitationStandardSerialDilutionsPlate] -> Link[quantitationStandardSerialDilutionsPlate],
    BinningType -> binningType,
    AntigenSolution -> Link[antigenSolutionResource],
    PreMixDiluent -> Link[preMixDiluentResource],
    Replace[PreMixSolutions] -> safePreMixResources,
    Replace[InitialSequence] -> initialSequence,
    Replace[RepeatedSequence] -> repeatedSequence,
    Replace[AssayPrimitives] -> Flatten[repeatedPrimitives]/.x:LinkP[]:>x[Object],
    Replace[AssayOverview] -> Flatten[finalizedAssayOverview,1],
    Replace[PlateLayout]-> plateLayout/.x:LinkP[]:>x[Object],
    Replace[RecoupSample] -> recoupSample,
    SaveAssayPlate -> saveAssayPlate,
    Replace[Checkpoints] -> {
      {"Picking Resources", 10 Minute,"Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 10 Minute]]},
      {"Preparing Samples", 10 Minute,"Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.",Link[Resource[Operator -> $BaselineOperator, Time -> 10 Minute]]},
      {"Preparing Assay Plate", dilutionPrepTime,"The assay plate is loaded with the required solutions and dilution series.", Link[Resource[Operator -> $BaselineOperator, Time -> 10*Minute]]},
      {"Instrument Setup", 5 Minute,"The probe rack, assay plate, and plate cover are placed inside the instrument.", Link[Resource[Operator -> $BaselineOperator, Time -> 5*Minute]]},
      {"Acquiring Data", assayTime, "Data is acquired by the instrument.", Link[Resource[Operator -> $BaselineOperator, Time -> 10*Minute]]},
      {"Instrument Clean Up", 10 Minute,"The instrument is returned to the original state and resources are discarded, recovered or stored as specified.", Link[Resource[Operator -> $BaselineOperator, Time -> 10*Minute]]},
      {"Sample Post-Processing", 0 Minute,"The samples are imaged and volumes are measured.",Resource[Operator->$BaselineOperator,Time->0 Minute]}
    },
    (* fields to create rules that will add the resourced objects into the primitives and other fields *)
    Replace[ObjectsManifest] -> Download[objectsManifest, Object],
    Replace[ResourcesManifest] -> linkedResourcesManifest,
    Replace[OriginalSamplesIn] -> Download[mySamples, Object]
  |>;

  (* generate a packet with the shared fields *)
  sharedFieldPacket = populateSamplePrepFields[mySamples, myResolvedOptions, Cache -> inheritedCache, Simulation -> simulation];

  (* Merge the shared fields with the specific fields *)
  finalizedPacket = Join[sharedFieldPacket, protocolPacket];

  (* get all the resource symbolic representations *)
  (* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
  allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

  (* call fulfillableResourceQ on all the resources we created *)
  {fulfillable, frqTests} = Which[
    MatchQ[$ECLApplication, Engine], {True, {}},
    gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Cache->inheritedCache, Simulation -> simulation],
    True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Messages -> messages, Cache->inheritedCache, Simulation -> simulation], Null}
  ];

  (* generate the tests rule *)
  testsRule = Tests -> If[gatherTests,
    frqTests,
    Null
  ];

  (* generate the Result output rule *)
  (* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
  resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
    finalizedPacket,
    $Failed
  ];

  (* return the output as we desire it *)
  outputSpecification /. {resultRule, testsRule}
];



(* ::Subsection::Closed:: *)
(* ExperimentBioLayerInterferometry general helper functions *)

(* ======================== *)
(* == sampleTests HELPER == *)
(* ======================== *)

(* Conditionally returns appropriate tests based on the number of failing samples and the gather tests boolean
	Inputs:
		testFlag - Indicates if we should actually make tests
		allSamples - The input samples
		badSamples - Samples which are invalid in some way
		testDescription - A description of the sample invalidity check
			- must be formatted as a template with an `1` which can be replaced by a list of samples or "all input samples"
	Outputs:
		out: {(_Test|_Warning)...} - Tests for the good and bad samples - if all samples fall in one category, only one test is returned *)

sampleTests[testFlag:False,testHead:(Test|Warning),allSamples_,badSamples_,testDescription_,simulation_]:={};

sampleTests[testFlag:True,testHead:(Test|Warning),allSamples:{PacketP[]..},badSamples:{PacketP[]...},testDescription_String,simulation_]:=Module[{
  numberOfSamples,numberOfBadSamples,allSampleObjects,badObjects,goodObjects},

  (* Convert packets to objects *)
  allSampleObjects=Lookup[allSamples,Object];
  badObjects=Lookup[badSamples,Object,{}];

  (* Determine how many of each sample we have - delete duplicates in case one of sample sets was sent to us with duplicates removed *)
  numberOfSamples=Length[DeleteDuplicates[allSampleObjects]];
  numberOfBadSamples=Length[DeleteDuplicates[badObjects]];

  (* Get a list of objects which are okay *)
  goodObjects=Complement[allSampleObjects,badObjects];

  Which[
    (* All samples are okay *)
    MatchQ[numberOfBadSamples,0],{testHead[StringTemplate[testDescription]["all input samples"],True,True]},

    (* All samples are bad *)
    MatchQ[numberOfBadSamples,numberOfSamples],{testHead[StringTemplate[testDescription]["all input samples"],False,True]},

    (* Mixed samples *)
    True,
    {
      (* Passing Test *)
      testHead[StringTemplate[testDescription][ObjectToString[goodObjects, Simulation -> simulation]], True, True],
      (* Failing Test *)
      testHead[StringTemplate[testDescription][ObjectToString[badObjects, Simulation -> simulation]], False, True]
    }
  ]
];

(*testOrNull:Simple helper that returns a Test whose expected value is True if makeTest[Rule] True, Null otherwise*)
(*Input:makeTest-Boolean indicating if we should create a test description-test description expression-value we expect to be True*)
testOrNull[makeTest : BooleanP, description_, expression_] :=
    If[makeTest, Test[description, expression, True], Null];

(*warningOrNull:Simple helper that returns a Warning if makeTest [Rule]True,Null otherwise*)
(*Input:makeTest-Boolean indicating if we should create a warning description-warning description expression-value we expect to be True*)

warningOrNull[makeTest : BooleanP, description_, expression_] :=
    If[makeTest, Warning[description, expression, True], Null];



(* ========================== *)
(* == DILUTION NAME HELPER == *)
(* ========================== *)

(* name from dilution helper. There are a few formats for solutions - they get labeled as fixed or serial to help keep track of where the names can be found*)

(*overload for Null or empty dilutions - If they get labeled, {Null, Label} should also go to Null*)
namesFromBLIDilutions[dilutions:(Null|{}|{Null, Fixed}|{Null, Serial}|{Null, PreMix})]:=Null;

(*main function*)
namesFromBLIDilutions[dilutions:_List]:=
    Which[

      (*
      serial dilutions have the formats:
      {{DilutionFactor, {solutionIDs...}}, (Serial)},
      {{TransferAmonut, DiluentAmount, {solutionIDs...}}, (Serial)},
      {{{DilutionFactor, ID}...}, (Serial)},
      {{{TransferAmount, DiluentAmount, ID}...}, (Serial)}
      *)
      MemberQ[dilutions, Serial],
      (* If the first element of the first element is a list, the format is: {{{DilutionFactor, ID}...}, Serial} or {{{TransferAmount, DiluentAmount, ID}...}, Serial}*)
      If[MatchQ[First[First[dilutions]], _List],
        Last/@First[dilutions],

        (* otherwise, all of the names are stored in a list as the last element of the dilution *)
        Last[First[dilutions]]
      ],

      (* fixed dilutions have the formats:  {{{DilutionFactor, ID}...}, (Fixed|Serial)} and {{{SampleAmount, DiluentAmount, ID}...},(Fixed|Serial)} *)
      (* fixed dilutions have the names at the end of each dilution *)
      MemberQ[dilutions, Fixed],
      Last/@First[dilutions],

      (* if there is no fixed or serial tag, they are premix solutions: They have the format of {{sample amount, antigen amount, diluent amount, ID}, PreMix} *)
      MemberQ[dilutions, PreMix],
      Last[First[dilutions]]
    ];



(* this function figures out the plate layout and associates probes and the plate columns with the primitive steps.
- It takes expanded assay sequence primitives (aka the ones which are grouped by assay) as input
- It does not handle repeats. If there are repeats, they need to be dealt with somewhere else. In fact, they should not even be shown in the ExpandedAssayPrimitives
 *)

(* ================================ *)
(* == PRIMITIVE EXPANSION HELPER == *)
(* ================================ *)

(* Note: this only handles repeated sequence at the back, not at the front*)
(*core function*)
resolveProtocolReadyPrimitives[primitives : _List, reuseKey : _List, defaultBuffer_] :=
    Module[{primitiveAssociationOnly, primitivePositions, indexedPrimitives, safePrimitivePositions, safePrimitiveAssociationOnly, safeReuseKey, longestList,
      (* reuse buffer variables *)
      flatIndexedPrimitives, groupedForReusePackets, groupedSolutions, groupedControls, groupedColumns, columnLabels, columnAssignedPackets,  preparedColumns, finalColumns,
      reorderedAssignedPackets, regroupedAssignedPackets, newProbeNeeded, probeNumbers, finalPrimitivePackets},

      (* in case the reuse key is Null, need to make it safe *)
      safeReuseKey = If[MatchQ[reuseKey, ({Null}|Null)],
        Null,
        If[MemberQ[reuseKey, _List],
          reuseKey,
          {reuseKey}]
      ];

      (*make the initial association with the primitives*)
      primitiveAssociationOnly = Map[(Primitive -> #) &, primitives, {2}];

      (* return the index of each primitive *)
      primitivePositions = MapIndexed[
        {
          AssayNumber -> First[#2],
          StepNumber -> Last[#2],
          PlateColumn -> columnNumber,
          ProbeNumber -> probeNumber
        }&,
        primitives,
        {2}
      ];

      (* Map thread is not smart enough to handle ragged lists so we need to pad both to make sure all of the elemetns at level 1 have the same length  *)
      longestList = Max[Length/@primitiveAssociationOnly];

      (* pad both lists so they are map thread safe *)
      safePrimitiveAssociationOnly = PadLeft[#, longestList]&/@primitiveAssociationOnly;
      safePrimitivePositions = PadLeft[#, longestList]&/@primitivePositions;

      (* associate the primitive with its index for sorting later *)
      indexedPrimitives = MapThread[If[MatchQ[#2, 0], Nothing, Association@@(Append[#2, #1])]&, {safePrimitiveAssociationOnly, safePrimitivePositions}, 2];

      (* now that the primitives are indexed, we can flatten and move group them freely *)
      flatIndexedPrimitives = Flatten[indexedPrimitives];

      (*use reuseSolutionQ to group solutions into their reuse groups*)
      groupedForReusePackets = Gather[flatIndexedPrimitives, reuseSolutionQ[#1, #2, safeReuseKey] &];


      (* --- LABEL THE PRIMITIVE PACKETS TO POINT THEM AT A PLATE COLUMN INDEX  --- *)

      (*add the column labels so that the plate can be set up*)
      columnLabels = Table[index, {index, 1, Length[groupedForReusePackets]}];

      (* assign each primitive to a column index *)
      columnAssignedPackets = MapThread[(#1 /. columnNumber -> #2) &, {groupedForReusePackets, columnLabels}];

      (* regroup the primitives into their assays,
      then also sort them so the steps are in the right order again *)
      regroupedAssignedPackets = GatherBy[Flatten[columnAssignedPackets], Lookup[#, AssayNumber] &];
      reorderedAssignedPackets  = SortBy[#, Lookup[#, StepNumber] &] & /@ regroupedAssignedPackets;

      (* --- PLATE LAYOUT --- *)

      (* create the solution to column number association.
      also flatten to remove annoying over nestedness *)
      groupedSolutions = Map[Flatten[Lookup[
        Association @@ Lookup[#, Primitive],
        {Buffers, Analytes, RegenerationSolutions, NeutralizationSolutions, ActivationSolutions, LoadingSolutions, QuenchSolutions },
        Nothing]] &, groupedForReusePackets, {2}];

      (* do the same for any blanks as well since we are settign up the plate we need everything *)
      groupedControls = Map[Flatten[Lookup[Association @@ Lookup[#, Primitive], ToList[Controls], {Nothing}]] &, groupedForReusePackets, {2}];

      (* put the solutions and blanks together into useable columns, making sure that the blanks stay at the end and everything is the right length *)
      groupedColumns = Transpose[#] & /@ MapThread[{#1, #2} &, {groupedSolutions, groupedControls}];

      (* need to make sure each list is 8 long, padded with defaultBuffer *)
      preparedColumns = Map[{PadRight[First[#], (8 - Length[Last[#]]), defaultBuffer], Last[#]} &, groupedColumns, {2}];

      (* remove any duplicates in a solution set (they share solutions), and flatten the list form both ends so that it is a flat list of columns. *)
      finalColumns = Flatten /@ Flatten[DeleteDuplicates /@ preparedColumns, 1];

      (* --- ASSIGN PROBES TO STEPS --- *)

      (* if regeneration is in the sequence,
      then we are reusing the probe.
      1 means the next sequence needs a new probe set,
      0 means that the probe is going to be regenerated.
      We don't care about the last assay because the experiment is over *)

      newProbeNeeded = If[MemberQ[Head /@ Lookup[#, Primitive], Regenerate], 0, 1 ] & /@ Most[reorderedAssignedPackets];

      (* output is plate layout, primitive packets tied to the plate/
      probe. Start at 0 for the first probe. *)
      probeNumbers = Table[Plus[1, Sequence @@ Take[newProbeNeeded, index]], {index, 0, Length[newProbeNeeded]}];

      (* assign each primitive to a column index *)
      finalPrimitivePackets = MapThread[(#1 /. probeNumber -> #2) &, {reorderedAssignedPackets, probeNumbers}];

      (*Output is finalizedPackets *)
      {finalPrimitivePackets, finalColumns}
    ];



(* ====================================== *)
(* == HELPER FUNCTION FOR BUFFER REUSE == *)
(* ====================================== *)

(* reuse buffer helper function tells you if two primitives can share the same set of wells on the assay plate*)
(* the resue list can be null or badly formed, so the input is not restrictive *)
reuseSolutionQ[association1_, association2_, reuseSolution_] :=
    Module[{safeBuffers, primitive1, primitive2, primitiveAssociation1, primitiveAssociation2, head1, head2, solutions1, solutions2,
      blanks1, blanks2, fullSolutions1, fullSolutions2,
      solutionMatch, sameList, headMatch, matchOrNot},

      (* secondary protection against bad input in case this is called outside if the original context *)
      safeBuffers = If[MatchQ[reuseSolution, Null],
        {},
        If[MemberQ[reuseSolution, _List],
          reuseSolution,
          {reuseSolution}
        ]
      ];

      (* grab the primitive packet and make it an association*)
      {primitive1, primitive2} = Lookup[{association1, association2}, Primitive];
      {primitiveAssociation1, primitiveAssociation2} = Association@@#& /@ {primitive1, primitive2} ;

      (* extract the required primitive heads *)
      {head1, head2} = Head /@ {primitive1, primitive2};

      (* extract the solutions *)
      {solutions1, solutions2} = Lookup[{primitiveAssociation1, primitiveAssociation2} , {Buffers, Analytes, RegenerationSolutions, NeutralizationSolutions, LoadingSolutions, ActivationSolutions, QuenchSolutions}, Nothing];

      (* extract the blanks *)
      {blanks1, blanks2} = Lookup[{primitiveAssociation1, primitiveAssociation2} , Controls, Null];

      (* make the solutiosn useful by combining and removing nulls *)
      {fullSolutions1, fullSolutions2} = MapThread[ {#1, #2} &, {{solutions1, solutions2}, {blanks1, blanks2}}];

      (* check if solutions match *)
      solutionMatch = MatchQ[fullSolutions1, fullSolutions2];

      (* If the solutions don't match, don't bother with the rest *)

      sameList = If[solutionMatch,
        (* check if the two heads are elements of the same list *)
        If[SubsetQ[#, {head1, head2}], True, False]&/@ safeBuffers,
        {False}
      ];

      (* if same list contains any True elements, than the solutions can be shared between the steps *)
      headMatch = Or@@sameList
    ];


(* =================================== *)
(* == DILUTION HELPER FOR RESOURCES == *)
(* =================================== *)

(* a function to figure out the resources needed for each dilution *)
(* the output has the format {{sample -> volume, diluent ->volume, ID}..}. Since this is used pick resources, the sample in serial dilutions except for the first trasnfer is marked as Null. *)
(* overload for Nulls so we can remove an If *)
dilutionsResolver[dilutions:(Null|{}),  dilutionType: (Serial|Fixed), sample_, diluent_]:={};

dilutionsResolver[dilutions:_List, dilutionType: (Serial|Fixed), sample_, diluent_]:=Module[{},
  If[MatchQ[dilutionType, Fixed],

    (* -- standardize fixed dilutions -- *)
    If[MatchQ[Length[#], 3],
      (* we are looking at the dilutions with format:{SampleAmount, DiluentAmount, "ID"} *)
      List[sample -> First[#],  diluent -> #[[2]], Name -> Last[#]],

      (* we are lookign at the format: {DilutionFactor, ID} *)
      List[sample-> (250 Microliter/First[#]), diluent -> (250 Microliter -(250 Microliter/First[#])), Name -> Last[#]]
    ]&/@dilutions,

    (* -- standardize serial dilutions -- *)

    If[MatchQ[First[dilutions], _List],
      (* if the first element is a list, the format is: {DilutionFactor, "ID"} or {TransferAmount, DiluentAmount, "ID"}*)
      (* the first solution uses the standard, the rest just need diluent resources *)
      If[MatchQ[Length[First[dilutions]],2],

        (* the format is {DilutionFactor, "ID"} *)
        Join[
          List[Null -> (500 Microliter/First[#]), diluent -> (500 Microliter -(500 Microliter/First[#])), Name -> Last[#]]&/@Rest[dilutions],
          List[{sample -> (500 Microliter/First[First[dilutions]]), diluent -> (500 Microliter -(500 Microliter/First[First[dilutions]])), Name -> Last[First[dilutions]]}]
        ],

        (* the format is {TransferAmount, DiluentAmount, "ID"} *)
        Join[
          List[Null -> First[#], diluent -> #[[2]], Name -> Last[#]]&/@Rest[dilutions],
          List[{sample -> First[First[dilutions]], diluent -> First[dilutions[[2]]], Name -> Last[First[dilutions]]}]
        ]
      ],

      Which[
        MatchQ[Length[dilutions], 3],
        (* we are looking at the dilutions with format:{TransferAmonut, DiluentAmount, {"solutionIDs"...}} *)
        Join[
          List[Null -> First[dilutions],  diluent -> dilutions[[2]], Name -> #]&/@Rest[Last[dilutions]],
          List[{sample -> First[dilutions],  diluent -> dilutions[[2]], Name -> First[Last[dilutions]]}]
        ],

        MatchQ[Length[dilutions], 2],
        (* we are looking at the format: {DilutionFactor, {"solutionIDs"...}} *)
        Join[
          List[Null -> 500 Microliter/First[dilutions],  diluent -> (500 Microliter - 500 Microliter/First[dilutions]), Name -> #]&/@Rest[Last[dilutions]],
          List[{sample -> 500 Microliter/First[dilutions],  diluent -> (500 Microliter - 500 Microliter/First[dilutions]), Name -> First[Last[dilutions]]}]
        ]
      ]
    ]
  ]
];

(* right now the fix for serial dilutions is pretty crude, but should be robust *)



(* ======================================= *)
(* == STANDARDIZE DILUTION INPUT HELPER == *)
(* ======================================= *)

(* TODO: need to throw errors here for volume input that is not transferrable *)

(*a helper function to take the messy dilutions input and turn it into a standardized form to fixed or serial dilutions:*)
(*overload for nulls*)
standardizedBLIDilutions[dilutions:(Null|{}),  dilutionType: (Serial|Fixed)]:=Null;

(*Fixed: {amount of sample, amount of diluent, name}*)
(*Serial: {dilutionfactor, name}*)
standardizedBLIDilutions[dilutions:_List, dilutionType:(Serial|Fixed)]:= Module[{},
  If[MatchQ[dilutionType, Fixed],
    (* -- fixed dilutions -- *)
    If[MatchQ[Length[#], 3],

      (*TODO: these are getting rounded to 0 now, when they should just be throwing errors and rounding to 1*)
      (* we are looking at the dilutions with format:{SampleAmount, DiluentAmount, ID} - this is the format we want but it may need rounding *)
      #/.{x:VolumeP :> Round[x, 1 Microliter]},

      (* we are looking at the format: {DilutionFactor, ID}, need to expand that to make solutions of 250 Microliter *)
      List[Round[(250*Microliter/First[#]),1], Round[(250*Microliter-(250*Microliter/First[#])),1], Last[#]]
    ]&/@dilutions,

    (* -- serial dilutions -- *)
    If[MatchQ[First[dilutions], _List],
      (* if the first element is a list, the format is: {DilutionFactor, ID} or {{Transfer amount, Diluent amount, ID},{Transfer amount, Diluent amount, ID}...}*)
      If[MatchQ[Length[First[dilutions]],2],

        (* if the element has a length of 2, is is the {DilutionFactor, ID} format, we need to convert to volumes *)
        (* use 500 Microliter instead of 250 Microliter to make sure that the volumes are ok for anything over 2x dilutions. This will require more sample and a secondary dilution plate but thats ok *)
        List[Round[(500*Microliter/First[#]), 1], Round[(500*Microliter-(500*Microliter/First[#])), 1], Last[#]]&/@dilutions,

        (* if the element has a length of 3 then just return the dilutions because it is already the desired format of {{Transfer Amount, Diluent Amount, ID}...}. They should already be rounded. *)
        dilutions
      ],

      Which[
        MatchQ[Length[dilutions], 3],
        (* we are looking at the dilutions with format:{TransferAmount, DiluentAmount, {solutionIDs...}} - convert to {transfer amount, diluentamount,name} *)
        List[Round[First[dilutions], 1 Microliter], Round[dilutions[[2]], 1 Microliter], #]&/@Last[dilutions],

        MatchQ[Length[dilutions], 2],
        (* we are looking at the format: {DilutionFactor, {solutionIDs...}} *)
        List[Round[(500*Microliter/First[dilutions]),1], Round[(500*Microliter-(500*Microliter/First[dilutions])), 1], #]&/@Last[dilutions]
      ]
    ]
  ]
];


(* ::Subsubsection::Closed:: *)
(*dilutionsPlateResolver*)

(* =================================== *)
(* == HELPER TO PICK DILUTION PLATE == *)
(* =================================== *)

(*A helper function to determine if there needs to be another plate for dilutions, and if so, picks an plate with enough wells and volume per well*)
(* serial dilutions wil always have a secondary dilution plate because we want the volume to be identical for each well *)
(* note that this takes either a flat list of dilutions in the form {transfer amount, diluent amount, name}, or Null or {} *)
dilutionsPlateResolver[dilutions_, plateLayout:_List, liquidHandlerContainers:_List, liquidHandlerContainerNumberOfWells:_List, liquidHandlerContainerMaxVolumes:_List, dilutionType:(Fixed|Serial)]:=
      (* the input here is a cleaned up version of the dilutions, where Null elements have been removed if it was a list. *)
      If[MatchQ[dilutions, Alternatives[Null, {}]],

        (* there are no dilutions to be performed, so no plate is needed *)
        Null,

        (* the criteria for needing a plate differ between serial and fixed dilutions *)
        If[MatchQ[dilutionType, Serial],

          (* for serial dilutions, pick a container that will fit the max dilution volume and has the right number of wells *)
          Module[{sufficientlyLargeContainers, dilutionContainers, maxVolume},

            (* determine the max volume of each well *)
            maxVolume = Max[Total[Most[#]]&/@dilutions];

            (* find a plate that has well volumes large enough for the max dilution. Include the number of wells so we can pick that next. *)
            sufficientlyLargeContainers = PickList[Transpose[{liquidHandlerContainers, liquidHandlerContainerNumberOfWells}], liquidHandlerContainerMaxVolumes, GreaterEqualP[maxVolume]];

            (* the container will also need the right NumberOfWells > Length[dilutions] *)
            dilutionContainers = First/@Select[sufficientlyLargeContainers, MatchQ[Last[#], GreaterEqualP[Length[dilutions]]]&];

            (* create the resource for the plate by picking the first element of the list *)
            Resource[Sample -> First[dilutionContainers]]
          ],


          (* for fixed dilutions do a more extensive evaluation if we need the secondary dilutions plate *)
          Module[{finalVolume, safeVolumeBool, sameVolumeBool, maxVolume, noIntermediatesBool, safeForPlateBool,
            sufficientlyLargeContainers, dilutionContainers},

            (* determine the final volume of each dilution *)
            finalVolume = Total[Most[#]]&/@dilutions;

            (* determine the max volume of each well *)
            maxVolume = Max[Total[Most[#]]&/@dilutions];

            (* determine if all the dilution volumes are all the same *)
            sameVolumeBool = If[MatchQ[Length[DeleteDuplicates[finalVolume]], 1],
              True,
              False
            ];

            (* if all the volumes are in the acceptable range for BLI measurement. Dont worry about the min volume, as we have already warned the user if it is too low. *)
            safeVolumeBool = If[MatchQ[maxVolume, LessEqualP[250 Micro Liter]],
              True,
              False
            ];

            (* return True if all of the dilutions are used in the assayPlate *)
            noIntermediatesBool = SubsetQ[Flatten[plateLayout], dilutions[[All, 3]]];

            (* based on volume and variation in volume, determine if the dilutions are safe to go directly on the assay plate *)
            safeForPlateBool = If[MatchQ[sameVolumeBool, True]&&MatchQ[safeVolumeBool, True]&&MatchQ[noIntermediatesBool, True],
              True,
              False
            ];

            (* if there are large dilutions or there are intermediates, we need a plate resource *)
            If[MatchQ[safeForPlateBool, False],

              (* find a plate that has well volumes large enough for the max dilution. Include the number of wells so we can pick that next. *)
              sufficientlyLargeContainers = PickList[Transpose[{liquidHandlerContainers, liquidHandlerContainerNumberOfWells}], liquidHandlerContainerMaxVolumes, GreaterEqualP[maxVolume]];

              (* the container will aslo need the right NumberOfWells > Length[dilutions] *)
              dilutionContainers = First/@Select[sufficientlyLargeContainers, MatchQ[Last[#], GreaterEqualP[Length[dilutions]]]&];

              (* create the resource for the plate by picking the first element of the list *)
              Resource[Sample -> First[dilutionContainers]],

              (* if safeForPlate is true, then we don't need a dilution plate, it can be made directly on the assay plate *)
              Null
            ]
          ]
        ]
      ];


(* ::Subsubsection::Closed:: *)
(*roundBLIDilutions*)

(* ============================ *)
(* == ROUND DILUTIONS HELPER == *)
(* ============================ *)

roundBLIDilutions[unroundedDilutions_]:=Module[
  {allVolumes, roundedVolumes, replaceVolumeRules, roundedVolumeList},

  (* if the options is not Null or a list of Nulls see if it needs to be rounded *)
  If[MatchQ[unroundedDilutions, Except[(Automatic|Null|{Null...})]],

    (* pull out any volume elements *)
    allVolumes = Cases[Flatten[unroundedDilutions], VolumeP];

    (* If there are no volumes, as in dilution factors are given, roundedVolumes is an empty list*)
    roundedVolumes = SafeRound[allVolumes, 10^0 Microliter, AvoidZero->True];

    (* determine which values were rounded *)
    roundedVolumeList = MapThread[
      If[EqualQ[#1, #2], Nothing, #1] &,
      {allVolumes, roundedVolumes}
    ];

    (* get the replace rules - note that the empty lists are still ok *)
    replaceVolumeRules = MapThread[(#1->#2)&, {allVolumes, roundedVolumes}];

    (*return the rounded option value and any voumes that got rounded*)
    {unroundedDilutions/.replaceVolumeRules, roundedVolumeList},

    (* if the option is not roundable, just return whatever it was *)
    {unroundedDilutions,{}}
  ]
];

(* ::Subsubsection::Closed:: *)
(*checkOptionsForUserInput*)

(* this is a helper function to check if an option has been specified by the user by checking it against the default or automatic. *)
(* it returns any values that are differnt form the default *)
checkOptionsForUserInput[optionValues:_List, optionNames:_List, defaultRules:_List]:= Module[{defaultValues},

  (* use the rules to determine the default values *)
  defaultValues = optionNames/.defaultRules;

  (* check the input values against the defaults *)
  MapThread[
    If[MatchQ[#1, #2],
      Nothing,
      #3
    ]&,
    {optionValues, defaultValues, optionNames}
  ]
];

(* ::Subsubsection::Closed:: *)
(*BLIPrimitiveAssistant*)


(* TODO: this is a helper function that can help to fill in incomplete primitives so the user can generate primitives outside of the options resolver. *)
(* there will be an error checking and primitives output, and it will share the BLI options so that primitives can be resolved in the context of the options *)
(*


If[MatchQ[assaySequencePrimitives, Except[(Automatic|Null|{})]],
  {
    completedAssaySequencePrimitives,
    completedPrimitiveKeys,
    completedRequiredOptions,
    completedRequiredOptionValues,
    (* error checking variable lists*)
    unresolvableSolutions,
    unresolvableTimes,
    unresolvableShakeRates,
    unresolvableThresholdCriteria,
    unresolvableAbsoluteThresholds,
    unresolvableThresholdSlopes,
    unresolvableThresholdSlopeDurations,
    invalidPrimitives,
    unresolvablePrimitives,
    invalidPrimitiveTypes
  } = Transpose@MapThread[
    Function[{primitive, primitiveIndex},
      Module[{
        (* general variables for primitives, keys, values *)
        completedAssayPrimitive,primitiveAssociation, primitiveKeys, primitiveValues,
        (* primitive value local variables *)
        completedLoadThresholdSlopeDuration, completedLoadThresholdSlope, completedLoadAbsoluteThreshold, completedLoadThresholdCriterion,
        completedLoadShakeRate, completedLoadTime, completedLoadSolution, completedLoadBlankSolution, completedQuenchShakeRate,completedQuenchTime, completedQuenchSolution,
        completedActivationShakeRate, completedActivationTime, completedActivationSolution, completedNeutralizationShakeRate, completedNeutralizationTime,
        completedNeutralizationSolution, completedRegenerationShakeRate, completedRegenerationTime, completedRegenerationSolution, completedWashShakeRate,
        completedWashTime, completedWashSolution, completedEquilibrateShakeRate, completedEquilibrateTime, completedEquilibrateBuffer, completedQuantitationAnalytes,
        completedQuantitationControls, completedQuantitationTime, completeQuantitationShakeRate,
        (*measure dissociaiton, assocaition, baseline variables*)
        completedMeasureDissociationSolution, completedMeasureDissociationTime, completedMeasureDissociationShakeRate, completedMeasureDissociationThresholdCriterion,
        completedMeasureDissociationAbsoluteThreshold, completedMeasureDissociationThresholdSlope, completedMeasureDissociationThresholdSlopeDuration,
        completedMeasureBaselineSolution, completedMeasureBaselineTime, completedMeasureBaselineShakeRate, completedPrimitiveKey,
        completedRequiredOption, completedRequiredOptionValue, completedMeasureAssociationSolution, completedMeasureAssociationBlank, completedMeasureAssociationTime, completedMeasureAssociationShakeRate,
        completedMeasureAssociationThresholdCriterion, completedMeasureAssociationAbsoluteThreshold, completedMeasureAssociationThresholdSlope, completedMeasureAssociationThresholdSlopeDuration,
        (* error tracking variables *)
        unresolvableSolution, unresolvableTime, unresolvableShakeRate, unresolvableThresholdCriterion, unresolvableAbsoluteThreshold,
        unresolvableThresholdSlope, unresolvableThresholdSlopeDuration, invalidPrimitive, unresolvablePrimitive, invalidPrimitiveType
      },



        (* extract the association from the primitive *)
        primitiveAssociation = Association@@primitive;

        (* extract the values from the primitive *)
        primitiveValues = Values[primitiveAssociation];
        primitiveKeys = Keys[primitiveAssociation];

        (*initialize error tracking variables *)
        unresolvableSolution = False;
        unresolvableTime = False;
        unresolvableShakeRate = False;
        unresolvableThresholdCriterion = False;
        unresolvableAbsoluteThreshold = False;
        unresolvableThresholdSlope = False;
        unresolvableThresholdSlopeDuration = False;
        invalidPrimitive = False;


        (* Resolve the primitives by type *)
        completedAssayPrimitive = Switch[Head[primitive],

          (* --- EQUILIBRATE --- *)
          Equilibrate,
          If[MemberQ[primitiveValues,Null]|!MatchQ[Length[primitiveValues], 3],

            (* fill in the keys based on the options. Note that the repalce rule if the key Buffers is absent will return Buffers*)
            completedEquilibrateBuffer = If[MatchQ[Buffers/.primitiveAssociation, (Null|Nothing|{}|Buffers)],
              If[MatchQ[equilibrateBuffer, Null],
                If[MatchQ[testBufferSolutions, (Null|{})],
                  defaultBuffer,
                  testBufferSolutions
                ],
                equilibrateBuffer
              ],
              Buffers/.primitiveAssociation
            ];
            completedEquilibrateTime = If[MatchQ[Time/.primitiveAssociation, (Null|Nothing|{}|Time)],
              If[MatchQ[equilibrateTime, Null],
                10 Minute,
                equilibrateTime
              ],
              Time/.primitiveAssociation
            ];
            completedEquilibrateShakeRate = If[MatchQ[ShakeRate/.primitiveAssociation, (Null|Nothing|{}|ShakeRate)],
              If[MatchQ[equilibrateShakeRate, Null],
                1000 RPM,
                equilibrateShakeRate
              ],
              Buffers/.primitiveAssociation
            ];
            (* since none of the keys are Null, just return the primitive *)
            Equilibrate[Buffers -> completedEquilibrateBuffer, Time -> completedEquilibrateTime, ShakeRate -> completedEquilibrateShakeRate],
            primitive
          ],

          (* --- WASH --- *)
          Wash,
          If[(MemberQ[primitiveValues,Null]|!MatchQ[Length[primitiveValues], 3]),
            (* if the was solution is part of a regen sequence, look at the washSolution option *)
            completedWashSolution = If[MatchQ[Buffers/.primitiveAssociation, (Null|Nothing|{}|Buffers)],
              If[MatchQ[Head[Part[assaySequencePrimitives, (primitiveIndex - 1)]], (Neutralize|Regeneration)],
                washSolution,
                If[MatchQ[testBufferSolutions, (Null|{})],
                  defaultBuffer,
                  testBufferSolutions
                ],
                (* if the wash step is not part of the regen sequence, set it to either the default buffer or the test buffers *)
                If[MatchQ[testBufferSolutions, (Null|{})],
                  defaultBuffer,
                  testBufferSolutions
                ]
              ],
              Buffers/.primitiveAssociation
            ];
            completedWashTime = If[MatchQ[Time/.primitiveAssociation, (Null|Nothing|{}|Time)],

              (* check if the wash is in the context of regeneration by looking at the previous step name, if it is not, default to 10 Second *)
              If[MatchQ[Head[Part[assaySequencePrimitives, (primitiveIndex - 1)]], (Neutralize|Regeneration)],
                washTime,
                10 Second],
              Time/.primitiveAssociation
            ];
            completedWashShakeRate = If[MatchQ[ShakeRate/.primitiveAssociation, (Null|Nothing|{}|ShakeRate)],
              If[MatchQ[Head[Part[assaySequencePrimitives, (primitiveIndex - 1)]], (Neutralize|Regeneration)],
                washShakeRate,
                1000 RPM],
              ShakeRate/.primitiveAssociation
            ];
            Wash[WashSolutions -> completedWashSolution, Time -> completedWashTime, ShakeRate -> completedWashShakeRate],

            (* if the primitive is complete, return it unchanged *)
            primitive
          ],

          (* --- REGENERATE --- *)
          Regenerate,
          If[(MemberQ[primitiveValues,Null]|!SubSetQ[primitiveKeys, {Time, ShakeRate, RegenerateSolutions}]),
            (* if the was solution is part of a regen sequence, look at the washSolution option *)
            completedRegenerationSolution = If[MatchQ[RegenerationSolutions/.primitiveAssociation, (Null|Nothing|{}|RegenerationSolutions)],
              If[MemberQ[regenerationType, Regeneration],
                If[MatchQ[testRegenerationSolutions, (Null|{})],
                  regenerationSolution,
                  testRegenerationSolutions
                ],
                (* if there is no regeneration requested but the step is there, fill in the default Regen solutions *)
                Model[Sample, StockSolution, "2 M HCl"]
              ],
              RegenerationSolutions/.primitiveAssociation
            ];

            (* if regeneration is selected, look at the regeneration time, otherwise set it to the default *)
            completedRegenerationTime = If[MatchQ[Time/.primitiveAssociation, (Null|Nothing|{}|Time)],
              If[MemberQ[regenerationType, Regeneration],
                regenerationTime,
                5 Second],
              Time/.primitiveAssociation
            ];

            (* if regeneration is selected, look at the regenerationShakeRate, otherwise set it to default *)
            completedRegenerationShakeRate = If[MatchQ[ShakeRate/.primitiveAssociation, (Null|Nothing|{}|ShakeRate)],
              If[MemberQ[regenerationType, Regeneration],
                regenerationShakeRate,
                1000 RPM],
              ShakeRate/.primitiveAssociation
            ];
            Regeneration[RegenerationSolutions -> completedRegenerationSolution, Time -> completedRegenerationTime, ShakeRate -> completedRegenerationShakeRate],

            (* if the primitive is complete, return it unchanged *)
            primitive
          ],

          (* --- NEUTRALIZE --- *)
          Neutralize,
          If[(MemberQ[primitiveValues,Null]|!SubSetQ[primitiveKeys, {Time, ShakeRate, NeutralizationSolutions}]),
            (* if the was solution is part of a regen sequence, look at the washSolution option *)
            completedNeutralizationSolution = If[MatchQ[NeutralizationSolutions/.primitiveAssociation, (Null|Nothing|{}|NeutralizationSolutions)],
              If[MemberQ[regenerationType, Neutralize],
                neutralizationSolution,
                (* If this is an unexpected neutralization step, fill in default buffer *)
                defaultBuffer
              ],
              NeutralizationSolutions/.primitiveAssociation
            ];

            (* if regeneration is selected, look at the regeneration time, otherwise set it to the default *)
            completedNeutralizationTime = If[MatchQ[Time/.primitiveAssociation, (Null|Nothing|{}|Time)],
              If[MemberQ[regenerationType, Regeneration],
                neutralizationTime,
                5 Second],
              Time/.primitiveAssociation
            ];

            (* if regeneration is selected, look at the regenerationShakeRate, otherwise set it to default *)
            completedNeutralizationShakeRate = If[MatchQ[ShakeRate/.primitiveAssociation, (Null|Nothing|{}|ShakeRate)],
              If[MemberQ[regenerationType, Neutralization],
                neutralizationShakeRate,
                1000 RPM],
              ShakeRate/.primitiveAssociation
            ];
            Neutralization[NeutralizationSolutions -> completedNeutralizationSolution, Time -> completedNeutralizationTime, ShakeRate -> completedNeutralizationShakeRate],

            (* if the primitive is complete, return it unchanged *)
            primitive
          ],

          (* --- ACTIVATESURFACE --- *)
          ActivateSurface,
          If[(MemberQ[primitiveValues,Null]|!SubSetQ[primitiveKeys, {Time, ShakeRate, ActivationSolutions}]),
            (* if the was solution is part of a regen sequence, look at the washSolution option *)
            completedActivationSolution = If[MatchQ[ActivationSolutions/.primitiveAssociation, (Null|Nothing|{}|ActivationSolutions)],
              If[MemberQ[loadingType, Activation],
                If[MatchQ[testActivationSolutions, (Null|{})],
                  activateSolution,
                  testActivationSolutions
                ],
                (* If this is an unexpected activate step, fill in default buffer *)
                defaultBuffer
              ],
              ActivationSolutions/.primitiveAssociation
            ];

            (* if regeneration is selected, look at the regeneration time, otherwise set it to the default *)
            completedActivationTime = If[MatchQ[Time/.primitiveAssociation, (Null|Nothing|{}|Time)],
              If[MemberQ[loadingType, Activation],
                activateTime,
                1 Minute],
              Time/.primitiveAssociation
            ];

            (* if regeneration is selected, look at the regenerationShakeRate, otherwise set it to default *)
            completedActivationShakeRate = If[MatchQ[ShakeRate/.primitiveAssociation, (Null|Nothing|{}|ShakeRate)],
              If[MemberQ[loadingType, Activation],
                activateShakeRate,
                1000 RPM],
              ShakeRate/.primitiveAssociation
            ];
            Neutralization[ActivationSolutions -> completedActivationSolution, Time -> completedActivationTime, ShakeRate -> completedActivationShakeRate],

            (* if the primitive is complete, return it unchanged *)
            primitive
          ],

          (* --- QUENCH --- *)
          Quench,
          If[(MemberQ[primitiveValues,Null]|!SubSetQ[primitiveKeys, {Time, ShakeRate, QuenchSolutions}]),
            (* if the was solution is part of a regen sequence, look at the washSolution option *)
            completedQuenchSolution = If[MatchQ[QuenchSolutions/.primitiveAssociation, (Null|Nothing|{}|QuenchSolutions)],
              If[MemberQ[loadingType, Quench],
                quenchSolution,
                (* If this is an unexpected activate step, fill in default buffer *)
                defaultBuffer
              ],
              QuenchSolutions/.primitiveAssociation
            ];

            (* if regeneration is selected, look at the regeneration time, otherwise set it to the default *)
            completedQuenchTime = If[MatchQ[Time/.primitiveAssociation, (Null|Nothing|{}|Time)],
              If[MemberQ[loadingType, Quench],
                quenchTime,
                1 Minute],
              Time/.primitiveAssociation
            ];

            (* if regeneration is selected, look at the regenerationShakeRate, otherwise set it to default *)
            completedQuenchShakeRate = If[MatchQ[ShakeRate/.primitiveAssociation, (Null|Nothing|{}|ShakeRate)],
              If[MemberQ[loadingType, Quench],
                quenchShakeRate,
                1000 RPM],
              ShakeRate/.primitiveAssociation
            ];
            Quench[QuenchSolutions -> completedQuenchSolution, Time -> completedQuenchTime, ShakeRate -> completedQuenchShakeRate],

            (* if the primitive is complete, return it unchanged *)
            primitive
          ],


          (* --- LOADSURFACE --- *)
          LoadSurface,
          If[(MemberQ[primitiveValues,Null]|!SubSetQ[primitiveKeys, {Time, ShakeRate, QuenchSolutions, ThresholdCriterion, AbsoluteThreshold}]|!SubSetQ[primitiveKeys, {Time, ShakeRate, QuenchSolutions, ThresholdCriterion, ThrehsoldSlope, ThresholdSlopeDuration}]),

            (* this resolution could be super complicated, but for now, I will restrict it to the case were loadign has been selected.
             Load appears in many contexts, but it is super complicated to resolve right, and so we will leave this for a later time*)
            completedLoadSolution = If[MatchQ[LoadSolutions/.primitiveAssociation, (Null|Nothing|{}|LoadSolutions)],
              If[MemberQ[loadingType, Load],
                Which[
                  MatchQ[developmentType, ScreenLoading],
                  MatchQ[developmentType, ScreenInteraction],
                  True,
                  loadSolution
                ],
                (* If this is not a simple load step, don't guess at what they are going for. This is their fault and we cannot help. *)
                unresolvableSolution = True;
                Null
              ],
              LoadSolutions/.primitiveAssociation
            ];

            (* there is no resolution for the blanks, but we need to make sure that the input is ok when the primitive is reconstructed later. *)
            completedLoadBlankSolution = If[MatchQ[Controls/.primitiveAssociation, (Null|Nothing|{}|Controls)],
              Null,
              Controls/.primitiveAssocaition
            ];

            (* If loadTime is selected, set it. Again, we can't really guess on this one, so the user will need to fill this out. *)
            completedLoadTime = If[MatchQ[Time/.primitiveAssociation, (Null|Nothing|{}|Time)],
              If[MemberQ[loadingType, Load],
                loadTime,
                unresolvableTime = True;
                Null],
              Time/.primitiveAssociation
            ];

            (* For consistency we can't set this parameter either. *)
            completedLoadShakeRate = If[MatchQ[ShakeRate/.primitiveAssociation, (Null|Nothing|{}|ShakeRate)],
              If[MemberQ[loadingType, Load],
                loadShakeRate,
                unresolvableShakeRate = True;
                Null],
              ShakeRate/.primitiveAssociation
            ];

            (* If this is not specified in the load section set it to Null.  *)
            completedLoadThresholdCriterion = If[MatchQ[ThresholdCriterion/.primitiveAssociation, (Null|Nothing|{}|ThresholdCriterion)],
              If[MemberQ[loadingType, Load],
                loadThresholdCriterion,
                unresolvableThresholdCriterion = True;
                Null],
              ThresholdCriterion/.primitiveAssociation
            ];

            (* If this is not specified in the load section set it to Null.  *)
            completedLoadAbsoluteThreshold = If[MatchQ[AbsoluteThreshold/.primitiveAssociation, (Null|Nothing|{}|AbsoluteThreshold)],
              If[MemberQ[loadingType, Load],
                loadAbsoluteThreshold,
                unresolvableAbsoluteThreshold = True;
                Null],
              AbsoluteThreshold/.primitiveAssociation
            ];

            (* If this is not specified in the load section set it to Null.  *)
            completedLoadThresholdSlope = If[MatchQ[ThresholdSlope/.primitiveAssociation, (Null|Nothing|{}|ThresholdSlope)],
              If[MemberQ[loadingType, Load],
                loadThresholdSlope,
                unresolvableThresholdSlope = True;
                Null],
              ThresholdSlope/.primitiveAssociation
            ];

            (* If this is not specified in the load section set it to Null.  *)
            completedLoadThresholdSlopeDuration = If[MatchQ[ThresholdSlopeDuration/.primitiveAssociation, (Null|Nothing|{}|ThresholdSlopeDuration)],
              If[MemberQ[loadingType, Load],
                loadThresholdSlopeDuration,
                unresolvableThresholdSlopeDuration = True;
                Null],
              ThresholdSlopeDuration/.primitiveAssociation
            ];

            (* define the primitive with the resolved values *)
            LoadSurface[
              LoadSolutions -> completedLoadSolution, Controls -> completedLoadBlankSolution, Time -> completedLoadTime, ShakeRate -> completedLoadShakeRate,
              ThresholdCriterion -> completedLoadThresholdCriterion, AbsoluteThreshold -> completedLoadAbsoluteThreshold, ThresholdSlope -> completedLoadThresholdSlope,
              ThresholdSlopeDuration -> completedLoadThresholdSlopeDuration
            ],
            (* if the primitive is ok already, return it *)
            primitive
          ],

          (* --- QUANTITATE --- *)
          Quantitate,
          If[(MemberQ[primitiveValues,Null]|!SubSetQ[primitiveKeys, {Time, ShakeRate, Analytes}]),

            (* check if the experiment type is quantitation. If it is not, we cant resolve it *)
            If[MatchQ[experimentType, Quantitation],
              {
                completedQuantitationAnalytes,
                completedQuantitationControls,
                completedQuantitationTime,
                completeQuantitationShakeRate
              }= If[MatchQ[quantitationParameters, AmplifiedDetection],
                {
                  If[MatchQ[Analytes/.primitiveAssociation, (Null|Nothing|{}|Analytes)],amplifiedDetectionSolution, Analytes -> amplifiedDetectionSolution],
                  Null,
                  If[MatchQ[Time/.primitiveAssociation, (Null|Nothing|{}|Time)],amplifiedDetectionTime, Time/.primitiveAssociation],
                  If[MatchQ[ShakeRate/.primitiveAssociation, (Null|Nothing|{}|ShakeRate)], amplifiedDetectionShakeRate, ShakeRate/.primitiveAssociation]
                },
                {
                  If[MatchQ[Analytes/.primitiveAssociation, (Null|Nothing|{}|Analytes)],
                    Which[

                      (* if a standard curve is requested, use fixed dilutions by default, then serial dilutiosn if these aren't informed *)
                      MemberQ[quantitationParameters, StandardCurve]&&MatchQ[quantitationStandardFixedDilutions, Except[(Null|{})]],
                      {quantitationStandardFixedDilutions, mySamples},
                      MemberQ[quantitationParameters, StandardCurve]&&MatchQ[quantitationStandardSerialDilutions, Except[(Null|{})]],
                      {quantitationStandardSerialDilutions, mySamples},

                      (*if no standard curve is needed, just add the sample input*)
                      True,
                      {mySamples}
                    ],
                    Analytes/.primitiveAssociation],

                  (*resolve blanks based on the selection in QuantitationParameters*)
                  If[MatchQ[Controls/.primitiveAssociation, (Null|Nothing|{}|Time)],
                    Which[
                      SubsetQ[ToList[quantitationParameters], {StandardWell, BlankWell}],
                      {quantitationStandard, blank},
                      MemberQ[ToList[quantitationParameters], BlankWell],
                      {blank},
                      MemberQ[ToList[quantitationParameters], StandardWell],
                      {quantitationStandard},
                      True,
                      Null
                    ],
                    Controls/.primitiveAssociation
                  ],
                  If[MatchQ[Time/.primitiveAssociation, (Null|Nothing|{}|Time)],quantitateTime, Time/.primitiveAssociation],
                  If[MatchQ[ShakeRate/.primitiveAssociation, (Null|Nothing|{}|ShakeRate)], quantitateShakeRate, ShakeRate/.primitiveAssociation]
                }
              ];

              (* define the primitive with the resolved values *)
              Quantitate[
                Analytes -> completedQuantitationAnalytes, Controls -> completedQuantitationControls, Time -> completedQuantitationTime, ShakeRate -> completeQuantitationShakeRate
              ],
              unresolvablePrimitive = True;
              primitive
            ],

            (* if the primitive is ok already, return it *)
            primitive
          ],

          (* --- MEASUREBASELINE --- *)
          MeasureBaseline,
          If[(MemberQ[primitiveValues,Null]|!SubSetQ[primitiveKeys, {Time, ShakeRate, Buffers}]),

            {
              completedMeasureBaselineSolution,
              completedMeasureBaselineTime,
              completedMeasureBaselineShakeRate
            } = Which[
              MatchQ[experimentType, Kinetics],
              {
                If[MatchQ[Buffers/.primitiveAssociation, (Null|Nothing|{}|Buffers)], kineticsBaselineBuffer, Buffers/.primitiveAssociation],
                If[MatchQ[Time/.primitiveAssociation, (Null|Nothing|{}|Time)], measureBaselineTime, Time/.primitiveAssociation],
                If[MatchQ[ShakeRate/.primitiveAssociation, (Null|Nothing|{}|ShakeRate)], measureBaselineShakeRate, ShakeRate/.primitiveAssociation]
              },
              MatchQ[experimentType, AssayDevelopment],
              {
                If[MatchQ[Buffers/.primitiveAssociation, (Null|Nothing|{}|Buffers)],
                  If[MatchQ[testBufferSolutions, (Null|{})],
                    defaultBuffer,
                    testBufferSolutions
                  ],
                  Buffers/.primitiveAssociation
                ],
                If[MatchQ[Time/.primitiveAssociation, (Null|Nothing|{}|Time)], developmentBaselineTime, Time/.primitiveAssociation],
                If[MatchQ[ShakeRate/.primitiveAssociation, (Null|Nothing|{}|ShakeRate)], developmentBaselineShakeRate, ShakeRate/.primitiveAssociation]
              },
              MatchQ[experimentType, EpitopeBinning],
              {
                If[MatchQ[Buffers/.primitiveAssociation, (Null|Nothing|{}|Buffers)], competitionBaselineBuffer, Buffers/.primitiveAssociation],
                If[MatchQ[Time/.primitiveAssociation, (Null|Nothing|{}|Time)], competitionBaselineTime, Time/.primitiveAssociation],
                If[MatchQ[ShakeRate/.primitiveAssociation, (Null|Nothing|{}|ShakeRate)], competitionBaselineShakeRate, ShakeRate/.primitiveAssociation]
              },
              (* for quantitation it is not clear what they are baselining, but it may be a fair thing to do, and it is reasonable to resolve this even with no information *)
              MatchQ[experimentType, Quantitation],
              {
                If[MatchQ[Buffers/.primitiveAssociation, (Null|Nothing|{}|Buffers)],defaultBuffer, Buffers/.primitiveAssociation],
                If[MatchQ[Time/.primitiveAssociation, (Null|Nothing|{}|Time)], 1 Minute,  Time/.primitiveAssociation],
                If[MatchQ[ShakeRate/.primitiveAssociation, (Null|Nothing|{}|ShakeRate)], 1000 RPM, ShakeRate/.primitiveAssociation]
              }
            ];

            (* now we can construct the primitive based on the resolved values. *)
            MeasureBaseline[Buffers -> completedMeasureBaselineSolution, Time -> completedMeasureBaselineTime, ShakeRate -> completedMeasureBaselineShakeRate],

            (* if the primitive is complete, return it unchanged *)
            primitive
          ],


          (* --- MEASUREASSOCIATION --- *)
          MeasureAssociation,
          If[(MemberQ[primitiveValues,Null]|!SubsetQ[primitiveKeys, {Time, ShakeRate, Buffers}]),
            {
              completedMeasureAssociationSolution,
              completedMeasureAssociationBlank,
              completedMeasureAssociationTime,
              completedMeasureAssociationShakeRate,
              completedMeasureAssociationThresholdCriterion,
              completedMeasureAssociationAbsoluteThreshold,
              completedMeasureAssociationThresholdSlope,
              completedMeasureAssociationThresholdSlopeDuration
            } = Which[
              MatchQ[experimentType, Kinetics],
              {
                If[MatchQ[Analytes/.primitiveAssociation, (Null|Nothing|{}|Analytes)],
                  (*this is a mix of kineticsSampleFixedDilutions adn kineticsSampleSerialDilutions, depending on whihc is populated. Last is to extract the solution name*)
                  Last/@kineticsSampleDilutions,
                  Analytes/.primitiveAssociation
                ],
                If[MatchQ[Controls/.primitiveAssociation, (Null|Nothing|{}|Controls)],
                  Which[
                    SubsetQ[ToList[kineticsReferenceType], {Controls, Standard}],
                    {blank, standard},
                    MemberQ[ToList[kineticsReferenceType], blank],
                    {blank},
                    MemberQ[ToList[kineticsReferenceType], standard],
                    {standard},
                    True,
                    Null
                  ],
                  Controls/.primitiveAssociation
                ],
                If[MatchQ[Time/.primitiveAssociation, (Null|Nothing|{}|Time)], measureAssociationTime, Time/.primitiveAssociation],
                If[MatchQ[ShakeRate/.primitiveAssociation, (Null|Nothing|{}|ShakeRate)], measureAssociationShakeRate, ShakeRate/.primitiveAssociation],
                If[MatchQ[ThresholdCriterion/.primitiveAssociation, (Null|Nothing|{}|ThresholdCriterion)], measureAssociationThresholdCriterion, ThresholdCriterion/.primitiveAssociation],
                If[MatchQ[AbsoluteThreshold/.primitiveAssociation, (Null|Nothing|{}|AbsoluteThreshold)], measureAssociationAbsoluteThreshold, AbsoluteThreshold/.primitiveAssociation],
                If[MatchQ[ThresholdSlope/.primitiveAssociation, (Null|Nothing|{}|ThresholdSlope)], measureAssociationThresholdSlope, ThresholdSlope/.primitiveAssociation],
                If[MatchQ[ThresholdSlopeDuration/.primitiveAssociation, (Null|Nothing|{}|ThresholdSlopeDuration)], measureAssociationThresholdSlopeDuration, ThresholdSlopeDuration/.primitiveAssociation]
              },


              MatchQ[experimentType, AssayDevelopment],
              {
                If[MatchQ[Analytes/.primitiveAssociation, (Null|Nothing|{}|Analytes)],
                  If[MatchQ[developmentType, ScreenDetectionLimit],
                    detectionLimitDilutions,
                    mySamples
                  ],
                  Analytes/.primitiveAssociation
                ],
                If[MatchQ[Controls/.primitiveAssociation, (Null|Nothing|{}|Controls)],
                  Which[
                    SubsetQ[ToList[developmentReferenceWell], {Controls, Standard}],
                    {blank, standard},
                    MemberQ[ToList[developmentReferenceWell], blank],
                    {blank},
                    MemberQ[ToList[developmentReferenceWell], standard],
                    {standard},
                    True,
                    Null
                  ],
                  Controls/.primitiveAssociation
                ],
                If[MatchQ[Time/.primitiveAssociation, (Null|Nothing|{}|Time)], developmentAssociationTime, Time/.primitiveAssociation],
                If[MatchQ[ShakeRate/.primitiveAssociation, (Null|Nothing|{}|ShakeRate)], developmentDissociationShakeRate, ShakeRate/.primitiveAssociation],
                If[MatchQ[ThresholdCriterion/.primitiveAssociation, (Null|Nothing|{}|ThresholdCriterion)], developmentAssociationThresholdCriterion, ThresholdCriterion/.primitiveAssociation],
                If[MatchQ[AbsoluteThreshold/.primitiveAssociation, (Null|Nothing|{}|AbsoluteThreshold)], developmentAssociationAbsoluteThreshold, AbsoluteThreshold/.primitiveAssociation],
                If[MatchQ[ThresholdSlope/.primitiveAssociation, (Null|Nothing|{}|ThresholdSlope)], developmentAssociationThresholdSlope, ThresholdSlope/.primitiveAssociation],
                If[MatchQ[ThresholdSlopeDuration/.primitiveAssociation, (Null|Nothing|{}|ThresholdSlopeDuration)], developmentAssociationThresholdSlopeDuration, ThresholdSlopeDuration/.primitiveAssociation]
              },

              (* measure association for epitope binning *)
              MatchQ[experimentType, EpitopeBinning],
              {
                If[MatchQ[Analytes/.primitiveAssociation, (Null|Nothing|{}|Buffers|Samples)],
                  measuredSamples,
                  Analytes/.primitiveAssociation
                ],
                If[MatchQ[Controls/.primitiveAssociation, (Null|Nothing|{}|Controls)], Null, Controls/.primitiveAssociation],
                If[MatchQ[Time/.primitiveAssociation, (Null|Nothing|{}|Time)], competitionTime, Time/.primitiveAssociation],
                If[MatchQ[ShakeRate/.primitiveAssociation, (Null|Nothing|{}|ShakeRate)], competitionShakeRate, ShakeRate/.primitiveAssociation],
                If[MatchQ[ThresholdCriterion/.primitiveAssociation, (Null|Nothing|{}|ThresholdCriterion)], competitionThresholdCriterion, ThresholdCriterion/.primitiveAssociation],
                If[MatchQ[AbsoluteThreshold/.primitiveAssociation, (Null|Nothing|{}|AbsoluteThreshold)], competitionAbsoluteThreshold, AbsoluteThreshold/.primitiveAssociation],
                If[MatchQ[ThresholdSlope/.primitiveAssociation, (Null|Nothing|{}|ThresholdSlope)], competitionThresholdSlope, ThresholdSlope/.primitiveAssociation],
                If[MatchQ[ThresholdSlopeDuration/.primitiveAssociation, (Null|Nothing|{}|ThresholdSlopeDuration)], competitionThresholdSlopeDuration, ThresholdSlopeDuration/.primitiveAssociation]
              },

              (* measure association for quantitation - dipping in the analyte prior to another detection step *)
              MatchQ[experimentType, Quantitation],
              {
                If[MatchQ[Analytes/.primitiveAssociation, (Null|Nothing|{}|Analytes|Samples)],
                  measuredSamples,
                  Analytes/.primitiveAssociation
                ],
                If[MatchQ[Controls/.primitiveAssociation, (Null|Nothing|{}|Controls)], Null, Controls/.primitiveAssociation],
                If[MatchQ[Time/.primitiveAssociation, (Null|Nothing|{}|Time)], competitionTime, Time/.primitiveAssociation],
                If[MatchQ[ShakeRate/.primitiveAssociation, (Null|Nothing|{}|ShakeRate)], competitionShakeRate, ShakeRate/.primitiveAssociation],
                If[MatchQ[ThresholdCriterion/.primitiveAssociation, (Null|Nothing|{}|ThresholdCriterion)], competitionThresholdCriterion, ThresholdCriterion/.primitiveAssociation],
                If[MatchQ[AbsoluteThreshold/.primitiveAssociation, (Null|Nothing|{}|AbsoluteThreshold)], competitionAbsoluteThreshold, AbsoluteThreshold/.primitiveAssociation],
                If[MatchQ[ThresholdSlope/.primitiveAssociation, (Null|Nothing|{}|ThresholdSlope)], competitionThresholdSlope, ThresholdSlope/.primitiveAssociation],
                If[MatchQ[ThresholdSlopeDuration/.primitiveAssociation, (Null|Nothing|{}|ThresholdSlopeDuration)], competitionThresholdSlopeDuration, ThresholdSlopeDuration/.primitiveAssociation]
              }
            ],
            primitive
          ],


          (* --- MEASUREDISSOCIATION --- *)
          MeasureDissociation,
          If[(MemberQ[primitiveValues,Null]|!SubSetQ[primitiveKeys, {Time, ShakeRate, Buffers}]),

            {
              completedMeasureDissociationSolution,
              completedMeasureDissociationTime,
              completedMeasureDissociationShakeRate,
              completedMeasureDissociationThresholdCriterion,
              completedMeasureDissociationAbsoluteThreshold,
              completedMeasureDissociationThresholdSlope,
              completedMeasureDissociationThresholdSlopeDuration
            } = Which[
              MatchQ[experimentType, Kinetics],
              {
                If[MatchQ[Buffers/.primitiveAssociation, (Null|Nothing|{}|Buffers)], kineticsDissociationBuffer, Buffers/.primitiveAssociation],
                If[MatchQ[Time/.primitiveAssociation, (Null|Nothing|{}|Time)], measureDissociationTime, Time/.primitiveAssociation],
                If[MatchQ[ShakeRate/.primitiveAssociation, (Null|Nothing|{}|ShakeRate)], measureDissociationShakeRate, ShakeRate/.primitiveAssociation],
                If[MatchQ[ThresholdCriterion/.primitiveAssociation, (Null|Nothing|{}|ThresholdCriterion)], measureDissociationThresholdCriterion, ThresholdCriterion/.primitiveAssociation],
                If[MatchQ[AbsoluteThreshold/.primitiveAssociation, (Null|Nothing|{}|AbsoluteThreshold)], measureDissociationAbsoluteThreshold, AbsoluteThreshold/.primitiveAssociation],
                If[MatchQ[ThresholdSlope/.primitiveAssociation, (Null|Nothing|{}|ThresholdSlope)], measureDissociationThresholdSlope, ThresholdSlope/.primitiveAssociation],
                If[MatchQ[ThresholdSlopeDuration/.primitiveAssociation, (Null|Nothing|{}|ThresholdSlopeDuration)], measureDissociationThresholdSlopeDuration, ThresholdSlopeDuration/.primitiveAssociation]
              },
              MatchQ[experimentType, AssayDevelopment],
              {
                If[MatchQ[Buffers/.primitiveAssociation, (Null|Nothing|{}|Buffers)],
                  If[MatchQ[testBufferSolutions, (Null|{})],
                    defaultBuffer,
                    testBufferSolutions
                  ],
                  Buffers/.primitiveAssociation
                ],
                If[MatchQ[Time/.primitiveAssociation, (Null|Nothing|{}|Time)], developmentDissociationTime, Time/.primitiveAssociation],
                If[MatchQ[ShakeRate/.primitiveAssociation, (Null|Nothing|{}|ShakeRate)], developmentDissociationShakeRate, ShakeRate/.primitiveAssociation],
                If[MatchQ[ThresholdCriterion/.primitiveAssociation, (Null|Nothing|{}|ThresholdCriterion)], developmentDissociationThresholdCriterion, ThresholdCriterion/.primitiveAssociation],
                If[MatchQ[AbsoluteThreshold/.primitiveAssociation, (Null|Nothing|{}|AbsoluteThreshold)], developmentDissociationAbsoluteThreshold, AbsoluteThreshold/.primitiveAssociation],
                If[MatchQ[ThresholdSlope/.primitiveAssociation, (Null|Nothing|{}|ThresholdSlope)], developmentDissociationThresholdSlope, ThresholdSlope/.primitiveAssociation],
                If[MatchQ[ThresholdSlopeDuration/.primitiveAssociation, (Null|Nothing|{}|ThresholdSlopeDuration)], developmentDissociationThresholdSlopeDuration, ThresholdSlopeDuration/.primitiveAssociation]
              },

              (* measure dissocaiiton for these types of assays is a mistake. This step can't be resolved. *)
              MatchQ[experimentType, (EpitopeBinning|Quantitation)],
              unresolvablePrimitive = True;
              {
                If[MatchQ[Buffers/.primitiveAssociation, (Null|Nothing|{}|Buffers)], Null, Buffers/.primitiveAssociation],
                If[MatchQ[Time/.primitiveAssociation, (Null|Nothing|{}|Time)], Null, Time/.primitiveAssociation],
                If[MatchQ[ShakeRate/.primitiveAssociation, (Null|Nothing|{}|ShakeRate)], Null, ShakeRate/.primitiveAssociation],
                If[MatchQ[ThresholdCriterion/.primitiveAssociation, (Null|Nothing|{}|ThresholdCriterion)], Null, ThresholdCriterion/.primitiveAssociation],
                If[MatchQ[AbsoluteThreshold/.primitiveAssociation, (Null|Nothing|{}|AbsoluteThreshold)], Null, AbsoluteThreshold/.primitiveAssociation],
                If[MatchQ[ThresholdSlope/.primitiveAssociation, (Null|Nothing|{}|ThresholdSlope)], Null, ThresholdSlope/.primitiveAssociation],
                If[MatchQ[ThresholdSlopeDuration/.primitiveAssociation, (Null|Nothing|{}|ThresholdSlopeDuration)], Null, ThresholdSlopeDuration/.primitiveAssociation]
              }
            ];

            (* now we can construct the primitive based on the resolved values. *)
            MeasureBaseline[Buffers -> completedMeasureBaselineSolution, Time -> completedMeasureBaselineTime, ShakeRate -> completedMeasureBaselineShakeRate],

            (* if the primitive is complete, return it unchanged *)
            primitive
          ],
          (* INVALID PRIMITIVE HEAD *)
          Not[Alternatives[Equilibrate, Wash, Regenerate, Neutralize, ActivateSurface, Quench, LoadSurface, MeasureBaseline, Quantitate, MeasureAssociation, MeasureDissociation]],

          (* collect an invalid primitive type and return the offending primitive*)
          invalidPrimitiveType = True;
          primitive
        ];
        (* error check the primitive *)
        completedAssayPrimitive;
        {
          completedAssayPrimitive,
          completedPrimitiveKey,
          completedRequiredOption,
          completedRequiredOptionValue,
          (* error checking variable lists*)
          unresolvableSolution,
          unresolvableTime,
          unresolvableShakeRate,
          unresolvableThresholdCriterion,
          unresolvableAbsoluteThreshold,
          unresolvableThresholdSlope,
          unresolvableThresholdSlopeDuration,
          invalidPrimitive,
          unresolvablePrimitive,
          invalidPrimitiveType
        }
      ]
    ],
    (* we are mapthreading over the assay primitives and their index*)
    {assaySequencePrimitives, Table[index, {index, 1, Length[assaySequencePrimitives]}]}
  ],
  (* set the completed primitives to null since we are using the option defined ones *)
  completedAssaySequencePrimitives = Null
];


*)

(* TODO: This is inprogress but may be redundant because of the updated error checking. *)


(* ::Subsection::Closed:: *)
